/// `components/agent/agent-console.tsx` — the whole component.
///
/// > One component, pointed at a transport. It owns the composer, the
/// > transcript, the face and the voice; it owns no protocol, no persona and no
/// > product knowledge. Everything specific arrives as a prop:
/// >
/// >   `transport`   what it talks to. The whole reason this is reusable.
/// >   `avatar`      what it looks like. Swap the renderer, keep the machine.
/// >   `speech`      what it sounds like. Swap the adapter, keep the controls.
/// >   `toolStates`  what its tools mean, so the face can describe them honestly.
/// >
/// > The three seams do not know about each other, which is what stops this
/// > becoming a component that only works for the app it was written in.
///
/// The contract it stands on — [DsAgentTransport], [dsResolveAgentState],
/// [DsAgentCapabilities], [DsAgentSendOptions], [dsSerialiseAttachments] — is
/// `agent_core.dart`'s. This file is the machine, and it composes: the face and
/// status line from `agent_face.dart`, every turn from `agent_transcript.dart`,
/// the input from `agent_composer.dart`.
///
/// ## Measured, at 1440×900
///
/// | box | measured |
/// |---|---|
/// | root | `p-5` (20), `gap-4` (16); `h-152` = **608** live, `h-80` = **320** minimal |
/// | header | **48** tall — the `md` face's own box — `gap-3`, `pr-6` |
/// | name | `.type-h4` 17/23.8, truncating; the live console's name box is 954 wide |
/// | status | `.type-chip` 11.5/13.8. `Ready` sits still; every busy state shimmers |
/// | scroller | `flex-1` `pr-1`, `space-y-4` — **390** live, **168** minimal |
/// | composer | **98** live, **96** minimal |
///
/// `608 = 20 + 48 + 16 + 390 + 16 + 98 + 20` and `320 = 20 + 168 + 16 + 96 + 20`
/// exactly. Both demo boxes have explicit heights, so **nothing inside the
/// console moves the page** — the scroller's `flex-1` absorbs every difference.
///
/// ## Probe corrections
///
///  * **The approval gate never reaches `awaiting_approval`.** `reduceEvent`
///    builds the action turn with `status: "running"` and **no** `approval`
///    field; `markApproval` only runs once the user has answered. So
///    [dsResolveAgentState]'s branch 2 — *"something is waiting on a human"* —
///    cannot match while the card is on screen, and branch 4 wins. Probed live
///    with the card up: the status line reads **`Processing`**. One of the
///    twenty states is unreachable through this transport, and the port
///    reproduces that rather than repairing it.
///  * **The status line's shimmer is not `DsShimmerText`.** See
///    [DsAgentShimmerText] — `anim-shimmer-text` is a different animation from
///    shadcn's `shimmer`, measured at 2.6s over a 220% tile.
///
/// ## Divergences, by construction
///
///  1. **No speech, no dictation.** `useBrowserSpeech` and `useDictation` are
///     Web Speech API hooks; Flutter ships no equivalent and this port invents
///     none. The consequence is exact and bounded: [DsAgentFeatures.speech] and
///     [DsAgentFeatures.microphone] are honoured as flags, [DsAgentVoice] is
///     always at rest, and the built-in `voice` command — gated on
///     `features.speech && speech.isSupported` — never appears. A browser
///     without the API reaches the same state, so this is a *reachable* state
///     of the reference; it is simply the only one the port can reach.
///  2. ~~**The model menu's rows are one line, not two.**~~ **CLOSED.**
///     `ModelPicker` writes `flex-col items-start gap-1` and stacks the label
///     over its hint; [DsMenuItem] had `label` and `shortcut` and no child slot,
///     so the hint rode the shortcut and sat beside the label instead of under
///     it. Recorded rather than forked, and the fix landed where it belonged —
///     [DsMenuItem.subtitle], on `DsCommandItem.subtitle`'s own terms. This file
///     passes `subtitle:` now and the divergence is gone; a divergence list that
///     keeps its closed entries struck through is the only way a reader can tell
///     "we looked and it is fine" from "nobody has looked".
///
/// ## Drift, reproduced
///
///  * **`pendingApprovals` renders after every turn**, not in the transcript
///    position the action turn occupies. With one gate open the two are
///    adjacent; with two they would both sink to the bottom.
///  * **The welcome card is handed every command and filters to skills.** The
///    reference filters inside the card; `DsWelcomeCard` takes a capability
///    list with no group on it, so the filter moved up here. Same three chips
///    on screen, and `MAX_CAPABILITIES = 4` is still never binding.
///
/// ## USER-ORDERED MOBILE ADAPTATION — the composer rises off the keyboard
///
/// Not a translation of anything: the reference's composer is a `<textarea>` in
/// a browser, and a browser shrinks its own visual viewport and scrolls the
/// focused field back into it. A widget layer with no `Scaffold` under it does
/// neither, so on a phone the composer — bottom-anchored by construction, and
/// inside the launcher's dialog at that — sat *behind* the software keyboard
/// and the user typed into a field they could not see.
///
/// The console pays it in the one place it can: a spacer of
/// `MediaQuery.viewInsets.bottom` at the end of its column, so the composer
/// lifts by the keyboard's height and the `flex-1` scroller gives up the same
/// amount — the transcript stays whole, just shorter, and the stick-to-bottom
/// promise is re-honoured across the change. The general rule for every *other*
/// field in the system is [DsFieldVisibility], which this console's own
/// composer also wears. Both are inert with no keyboard on screen: a desktop
/// console builds the identical tree it built before.
library;

import 'package:flutter/widgets.dart';

import '../foundation/spacing.dart';
import '../foundation/theme.dart';
import '../foundation/typography.dart';
import '../theme_scope.dart';
import 'agent_avatar.dart';
import 'agent_composer.dart';
import 'agent_core.dart';
import 'agent_face.dart';
// `DsBlurSwitch` only. The widget form of `blurClass` is owned by the
// history family, which probed the two keyframes it plays; importing it keeps
// that single owner rather than growing a second copy here. No cycle — nothing
// in `agent_history.dart` reaches back into the console.
import 'agent_history.dart';
import 'agent_slash_palette.dart';
import 'agent_transcript.dart';
import 'button.dart';
import 'dropdown_menu.dart';
import 'icon.dart';
import 'icon_paths.g.dart';
import 'marker.dart';
import 'menu.dart';
import 'popover.dart';

/// `AgentConsoleFeatures` — *"nine switches, all on by default. A console with
/// everything turned off is still a console — which is the test that the parts
/// are genuinely separable rather than merely arranged."*
@immutable
class DsAgentFeatures {
  const DsAgentFeatures({
    this.avatar = true,
    this.suggestions = true,
    this.toolTrace = true,
    this.microphone = true,
    this.speech = true,
    this.attachments = true,
    this.commands = true,
    this.models = true,
    this.reset = true,
  });

  /// `DEFAULT_FEATURES` — every one of them on.
  static const DsAgentFeatures all = DsAgentFeatures();

  /// The face and the status line beside it.
  final bool avatar;

  /// Starter prompts, on an empty conversation.
  final bool suggestions;

  /// Tool chips and the generative renderers for their results.
  final bool toolTrace;

  /// Dictation, with the live waveform.
  final bool microphone;

  /// Read answers aloud, with the voice picker.
  final bool speech;

  /// The file tray, drag-and-drop and paste.
  final bool attachments;

  /// The `/` palette.
  final bool commands;

  /// The model picker.
  final bool models;

  /// Reset the conversation.
  final bool reset;
}

/// `AgentPersona`.
@immutable
class DsAgentPersona {
  const DsAgentPersona({
    required this.name,
    this.blurb,
    this.suggestions = const <String>[],
    this.placeholder,
  });

  final String name;
  final String? blurb;
  final List<String> suggestions;
  final String? placeholder;
}

/// `ModelOption` — *"the list is supplied by the caller and validated
/// server-side."*
@immutable
class DsAgentModel {
  const DsAgentModel({required this.id, required this.label, this.hint});

  final String id;
  final String label;
  final String? hint;
}

/// `AgentConsole`.
class DsAgentConsole extends StatefulWidget {
  const DsAgentConsole({
    super.key,
    required this.transport,
    this.persona,
    this.toolStates,
    this.models = const <DsAgentModel>[],
    this.commands = const <DsAgentCommand>[],
    this.avatar,
    this.features = DsAgentFeatures.all,
    this.accent,
    this.speed,
    this.renderToolResult,
    this.describeApproval,
    this.headerSlot,
    this.switchPhase = DsSwitchPhase.idle,
    this.height,
  });

  final DsAgentTransport transport;
  final DsAgentPersona? persona;
  final DsToolStateMap? toolStates;
  final List<DsAgentModel> models;

  /// *"Skills and browser commands offered under `/`."*
  final List<DsAgentCommand> commands;

  /// *"What it looks like. Swap the renderer, keep the machine."*
  final DsAgentAvatarBuilder? avatar;

  final DsAgentFeatures features;

  /// *"Any CSS colour. Recolours the whole avatar set."*
  final Color? accent;

  /// *"Avatar speed multiplier."*
  final double? speed;

  /// *"Turns a tool result into the product's own components."*
  final Widget Function(DsToolTurn turn)? renderToolResult;

  /// *"Turns a held action into a sentence a human can decide on."*
  final String Function(String action, Map<String, Object?> params)?
      describeApproval;

  /// *"Controls rendered at the right of the header — chat history, and
  /// whatever else a surface needs there. A slot rather than a fixed set,
  /// because what belongs beside a persona differs between a docked panel and a
  /// full page."*
  final Widget? headerSlot;

  /// *"The transcript's cross-fade phase while switching conversations."*
  ///
  /// *"Supplied rather than derived, because the console cannot derive it: by
  /// the time it can see that the conversation changed, the old messages are
  /// already gone and there is nothing left to blur out. `useBlurSwitch` owns
  /// the sequence and hands the phase down. Left undefined, the transcript
  /// simply never transitions — which is correct for a console with no history
  /// behind it."*
  ///
  /// **The scroller only.** The reference puts `blurClass(switchPhase)` on the
  /// `overflow-y-auto` div and nowhere else, so the header and the composer sit
  /// still through the swap. They are not part of the conversation being
  /// replaced — blurring the persona and the input the user is about to type
  /// into would say the whole console had changed, when only the transcript
  /// has. [DsBlurSwitch] returns its child untouched on
  /// [DsSwitchPhase.idle], so a console with no history behind it pays nothing.
  final DsSwitchPhase switchPhase;

  /// The `className` height the specimens pass — `h-152` (608) and `h-80`
  /// (320). Null lets the console fill the box it is given, which is what
  /// `min-h-0 flex-1` does inside the launcher's dialog.
  final double? height;

  /// `p-5` — *"the console owns its own inset."*
  ///
  /// *"It used to have none, on the assumption that whatever mounted it would
  /// supply one — and every surface that mounts it is a Dialog, which is `p-0`
  /// precisely so the console can reach the edges when it needs to. The result
  /// was a transcript whose text began at the dialog's border: no margin on the
  /// messages, the avatar jammed into the corner, the composer welded to the
  /// bottom."*
  static double get padding => ds(5);

  /// `gap-4` between the header, the scroller and the composer.
  static double get gap => ds(4);

  /// `gap-3` inside the header, and `pr-6` on it — *"the right padding clears a
  /// dialog's own close button."*
  static double get headerGap => ds(3);
  static double get headerInset => ds(6);

  /// `space-y-4` in the scroller, and `pr-1` beside its scrollbar.
  static double get turnGap => ds(4);
  static double get scrollerInset => ds(1);

  /// *"A 32px tolerance, so a user who is essentially at the bottom stays
  /// pinned and one who has scrolled up to read is left alone."*
  static double get pinTolerance => ds(8);

  @override
  State<DsAgentConsole> createState() => _DsAgentConsoleState();
}

class _DsAgentConsoleState extends State<DsAgentConsole> {
  final TextEditingController _draft = TextEditingController();
  final FocusNode _composerFocus = FocusNode();
  final ScrollController _scroller = ScrollController();

  List<DsAgentAttachment> _attachments = <DsAgentAttachment>[];

  /// *"`chosen` holds only what the user actually picked, so it stays null
  /// until they touch the control, and the fallback keeps working if the list
  /// is replaced."*
  String? _chosen;

  bool _awaitingFirstEvent = false;

  /// *"Which answers the user cut off… stopping is recorded against the turn it
  /// interrupted and marked in place. Console-local rather than a turn kind,
  /// because `core/` is the part of this that travels into another product and
  /// a new kind is a contract change."*
  final Set<String> _stopped = <String>{};

  /// Whether the reader is still riding the bottom.
  bool _pinned = true;

  /// USER-ORDERED MOBILE ADAPTATION — `MediaQuery.viewInsets.bottom`, the
  /// height the software keyboard has taken off the window.
  ///
  /// Read here rather than in [build] so the dependency is registered once, in
  /// the callback the framework provides for it, and so a change can be
  /// noticed: the scroller shrinks when the keyboard opens, and a reader who
  /// was riding the bottom has to be put back there.
  ///
  /// Zero on every desktop frame, where the whole adaptation costs one
  /// comparison and builds nothing.
  double _keyboardInset = 0;

  @override
  void initState() {
    super.initState();
    widget.transport.addListener(_onTransport);
    _draft.addListener(_onDraft);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final double next = MediaQuery.maybeViewInsetsOf(context)?.bottom ?? 0;
    if (next == _keyboardInset) return;
    _keyboardInset = next;
    // The composer just moved and the scroller just changed height. Stick-to-
    // bottom is the console's one scroll promise, so it is re-honoured here for
    // the same reason it is after a turn arrives.
    _autoscroll();
  }

  @override
  void didUpdateWidget(DsAgentConsole old) {
    super.didUpdateWidget(old);
    if (!identical(old.transport, widget.transport)) {
      old.transport.removeListener(_onTransport);
      widget.transport.addListener(_onTransport);
    }
  }

  @override
  void dispose() {
    widget.transport.removeListener(_onTransport);
    _draft
      ..removeListener(_onDraft)
      ..dispose();
    _composerFocus.dispose();
    _scroller.dispose();
    super.dispose();
  }

  void _onDraft() => setState(() {});

  void _onTransport() {
    if (!mounted) return;
    setState(() {});
    _autoscroll();
  }

  /// `node.scrollTop = node.scrollHeight` after every turn or state change —
  /// but only while pinned.
  void _autoscroll() {
    if (!_pinned) return;
    WidgetsBinding.instance.addPostFrameCallback((Duration _) {
      if (!mounted || !_scroller.hasClients) return;
      _scroller.jumpTo(_scroller.position.maxScrollExtent);
    });
  }

  bool _onScroll(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification && _scroller.hasClients) {
      final ScrollPosition p = _scroller.position;
      _pinned = p.maxScrollExtent - p.pixels < DsAgentConsole.pinTolerance;
    }
    return false;
  }

  /// `chosen ?? models?.[0]?.id ?? null` — derived during build rather than
  /// synced, *"so the picker is never in the state where it shows a placeholder
  /// while a list sits behind it."*
  String? get _modelId =>
      _chosen ?? (widget.models.isEmpty ? null : widget.models.first.id);

  DsAgentState get _state => dsResolveAgentState(
        turns: widget.transport.turns,
        signals: DsAgentSignals(
          isLoading: widget.transport.isLoading,
          // `awaitingFirstEvent && !transport.turns.some(isAssistantTurn)`.
          awaitingFirstEvent: _awaitingFirstEvent &&
              !widget.transport.turns.any((DsAgentTurn t) => t is! DsUserTurn),
        ),
        toolStates: widget.toolStates,
      );

  Future<void> _send(String raw) async {
    final String text = raw.trim();
    if (text.isEmpty && _attachments.isEmpty) return;

    final List<DsAgentAttachment> outgoing = _attachments;
    setState(() {
      _draft.clear();
      _attachments = <DsAgentAttachment>[];
      _awaitingFirstEvent = true;
    });

    // *"Attachments are folded into the message here rather than in the
    // transport, so every transport gets the same honest treatment and the
    // delivery stamp is decided in one place. The result goes on the wire as
    // `wireText`; the transcript keeps the sentence the user actually typed."*
    final DsSerialisedMessage payload = outgoing.isEmpty
        ? DsSerialisedMessage(
            text: text,
            attachments: const <DsAgentAttachment>[],
          )
        : dsSerialiseAttachments(text, outgoing);

    try {
      await widget.transport.send(
        text,
        DsAgentSendOptions(
          attachments: payload.attachments,
          wireText: payload.text != text ? payload.text : null,
          model: _modelId,
        ),
      );
    } finally {
      if (mounted) setState(() => _awaitingFirstEvent = false);
    }
  }

  /// *"`abort()` stops the stream and leaves the half-written turn exactly
  /// where it was, which on screen is indistinguishable from an answer that
  /// finished. That is the one thing this console must never be: a transcript
  /// you cannot trust to mean what it looks like."*
  void _stop() {
    final List<DsAgentTurn> turns = widget.transport.turns;
    final DsAgentTurn? last = turns.isEmpty ? null : turns.last;
    if (last is DsTextTurn && last.streaming) {
      setState(() => _stopped.add(last.id));
    }
    widget.transport.abort();
  }

  /// *"Arming a skill from the welcome card. Identical to picking one from the
  /// `/` palette or the plus menu — the same directive, into the same composer
  /// — because they are three routes to one action and a fourth behaviour would
  /// be a fourth thing to learn."*
  void _useCapability(DsAgentCommand command) {
    final VoidCallback? run = command.run;
    if (run != null) {
      run();
      return;
    }
    final String text =
        command.directive != null ? '${command.directive} ' : '/${command.id} ';
    _draft.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
    // *"Focus follows the click: the sentence is half-written and the user has
    // to finish it, so leaving the caret elsewhere makes them click twice."*
    _composerFocus.requestFocus();
  }

  /// The caller's commands, plus the built-ins.
  ///
  /// `clear` always, `stop` while busy. The third — `voice` — is gated on
  /// `features.speech && speech.isSupported`, and the port has no speech
  /// adapter, so it never appears (divergence 1).
  List<DsAgentCommand> get _allCommands {
    if (!widget.features.commands) return const <DsAgentCommand>[];
    return <DsAgentCommand>[
      ...widget.commands,
      DsAgentCommand(
        id: 'clear',
        label: 'Clear',
        hint: 'Start a new conversation',
        group: DsAgentCommandGroup.command,
        icon: DsLucide.rotateCcw,
        run: widget.transport.reset,
      ),
      if (_state.isBusy)
        DsAgentCommand(
          id: 'stop',
          label: 'Stop',
          hint: 'Interrupt the current turn',
          group: DsAgentCommandGroup.command,
          icon: DsLucide.square,
          run: widget.transport.abort,
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final DsAgentTransport transport = widget.transport;
    final DsAgentState state = _state;

    return SizedBox(
      height: widget.height,
      child: Padding(
        padding: EdgeInsets.all(DsAgentConsole.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (widget.features.avatar) ...<Widget>[
              _header(context, state),
              SizedBox(height: DsAgentConsole.gap),
            ],
            Expanded(child: _transcript(context)),
            SizedBox(height: DsAgentConsole.gap),
            DsAgentComposer(
              controller: _draft,
              focusNode: _composerFocus,
              onSubmit: () => _send(_draft.text),
              onStop: _stop,
              disabled: !transport.isReady,
              busy: state.isBusy,
              placeholder: widget.persona?.placeholder,
              commands: _allCommands,
              attachments: widget.features.attachments ? _attachments : null,
              onAttach: widget.features.attachments
                  ? (List<DsAgentAttachment> files) => setState(
                        () => _attachments = <DsAgentAttachment>[
                          ..._attachments,
                          ...files,
                        ],
                      )
                  : null,
              onRemoveAttachment: (String id) => setState(
                () => _attachments = _attachments
                    .where((DsAgentAttachment a) => a.id != id)
                    .toList(),
              ),
              accessory: widget.features.models && widget.models.length > 1
                  ? _ModelPicker(
                      models: widget.models,
                      modelId: _modelId,
                      onSelect: (String id) => setState(() => _chosen = id),
                      disabled: !transport.isReady,
                    )
                  : null,
            ),
            // USER-ORDERED MOBILE ADAPTATION — the composer rises by exactly
            // the keyboard's height, and the scroller above it (which is the
            // only `Expanded` in this column) gives up exactly that much.
            //
            // Not padding and not a `SafeArea`: a spacer at the end of the
            // column is the one expression that shrinks the transcript by the
            // same amount it lifts the composer, which is what keeps the last
            // turn readable while the user types a reply to it. The composer is
            // bottom-anchored inside a box the console does not own — a dialog's
            // in the launcher — so it moves within that box rather than asking
            // the box to move.
            //
            // Built only when there is a keyboard, so a desktop tree is
            // identical widget for widget to the one before this change.
            // `viewInsets` is the ambient contract: an ancestor that has already
            // made room is expected to have consumed it (`MediaQuery.removeView
            // Insets`), and this then reads zero and nothing double-counts.
            //
            // BOUNDARY, recorded rather than patched: a console pinned to a
            // height shorter than its own chrome plus the keyboard has nowhere
            // to put the lift, and the column overflows — which is what
            // `Scaffold(resizeToAvoidBottomInset: true)` does with a body too
            // tall for what is left, since it pads rather than measures. Every
            // surface that mounts a console on a phone sizes it from the
            // viewport (the launcher's dialog, a full-bleed page); the two
            // pinned heights are the docs page's own `h-152` and `h-80`
            // specimens.
            if (_keyboardInset > 0) SizedBox(height: _keyboardInset),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context, DsAgentState state) {
    final DsThemeData theme = DsTheme.of(context);
    return Padding(
      padding: EdgeInsets.only(right: DsAgentConsole.headerInset),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          DsAgentFace(
            state: state,
            avatar: widget.avatar,
            accent: widget.accent,
            speed: widget.speed,
          ),
          SizedBox(width: DsAgentConsole.headerGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (widget.persona != null)
                  DsText(
                    widget.persona!.name,
                    DsType.h4,
                    color: theme.foreground,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: DsAgentStatusLine(state: state),
                ),
              ],
            ),
          ),
          // *"Read-aloud lives on the audio control beside send, with the voice
          // it uses. It was a second speaker icon up here doing half the job."*
          if (widget.headerSlot != null) widget.headerSlot!,
        ],
      ),
    );
  }

  Widget _transcript(BuildContext context) {
    final DsAgentTransport transport = widget.transport;
    final bool empty = transport.turns.isEmpty;

    final List<Widget> rows = <Widget>[
      if (empty)
        DsWelcomeCard(
          name: widget.persona?.name,
          blurb: widget.persona?.blurb,
          capabilities: <DsAgentCapability>[
            for (final DsAgentCommand c in widget.commands)
              if (c.group == DsAgentCommandGroup.skill)
                DsAgentCapability(
                  id: c.id,
                  label: c.label,
                  hint: c.hint,
                  glyph: c.icon,
                ),
          ],
          suggestions: widget.features.suggestions
              ? (widget.persona?.suggestions ?? const <String>[])
              : const <String>[],
          onPick: (String text) => _send(text),
          onUseCapability: (DsAgentCapability capability) => _useCapability(
            widget.commands.firstWhere(
              (DsAgentCommand c) => c.id == capability.id,
            ),
          ),
          disabled: !transport.isReady,
          avatar: _avatarSlot,
        ),
      for (final DsAgentTurn turn in transport.turns) ..._turn(context, turn),
      for (final DsPendingApproval approval in transport.pendingApprovals)
        DsApprovalCard(approval: approval, describe: widget.describeApproval),
      if (transport.error != null) _errorRow(context, '${transport.error}'),
    ];

    final Widget column = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (int i = 0; i < rows.length; i += 1) ...<Widget>[
          if (i > 0) SizedBox(height: DsAgentConsole.turnGap),
          rows[i],
        ],
      ],
    );

    return NotificationListener<ScrollNotification>(
      onNotification: _onScroll,
      child: Padding(
        padding: EdgeInsets.only(right: DsAgentConsole.scrollerInset),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) =>
              SingleChildScrollView(
            controller: _scroller,
            child: ConstrainedBox(
              // The welcome card's `grid h-full place-items-center`: with one
              // child the scroller is exactly its own height and the card
              // centres in it.
              constraints: BoxConstraints(
                minHeight: empty ? constraints.maxHeight : 0,
              ),
              // Inside the `ConstrainedBox`, so the welcome card's centring
              // still measures against the viewport rather than against a
              // blurred layer, and outside nothing else — the header and the
              // composer are deliberately not in here.
              child: DsBlurSwitch(phase: widget.switchPhase, child: column),
            ),
          ),
        ),
      ),
    );
  }

  /// `DsWelcomeCard`'s own seam — a box of the size it asks for, filled with
  /// whatever renderer this console was given.
  Widget _avatarSlot(BuildContext context, double size) => DsAgentFace(
        state: DsAgentState.idle,
        avatar: widget.avatar,
        size: DsAgentAvatarSize.lg,
        accent: widget.accent,
        speed: widget.speed,
      );

  List<Widget> _turn(BuildContext context, DsAgentTurn turn) {
    switch (turn) {
      case DsUserTurn():
        return <Widget>[DsUserMessage(turn: turn)];

      case DsTextTurn():
        if (!_stopped.contains(turn.id)) {
          return <Widget>[DsAgentMessage(turn: turn)];
        }
        // *"A transport is not obliged to emit `done` on abort — the mock one
        // doesn't, so `turn.streaming` would still read `true` here and
        // `AgentMessage` would draw its blinking 'still writing' cursor
        // directly above a marker that just said the opposite… it overrides
        // what it renders instead. Do not delete this as 'redundant' — without
        // it the cursor and the marker contradict each other on screen."*
        return <Widget>[
          DsAgentMessage(turn: turn.notStreaming()),
          SizedBox(height: DsAgentConsole.turnGap),
          const DsMarker(
            variant: DsMarkerVariant.separator,
            icon: DsIcon.lucide(
              DsLucide.square,
              size: DsIconSize.sm,
              tone: DsIconTone.muted,
            ),
            label: 'Stopped by you',
          ),
        ];

      case DsToolTurn():
        return widget.features.toolTrace
            ? <Widget>[
                DsToolChip(
                  turn: turn,
                  toolStates: widget.toolStates,
                  renderResult: widget.renderToolResult,
                ),
              ]
            : const <Widget>[];

      case DsActionTurn():
        return widget.features.toolTrace
            ? <Widget>[DsActionChip(turn: turn)]
            : const <Widget>[];

      case DsErrorTurn():
        return <Widget>[_errorRow(context, turn.message)];
    }
  }

  /// `type-small text-destructive-ink border-destructive/30 bg-destructive/8
  /// rounded-md border p-3` — one row for a turn-level error and for the
  /// transport's own standing banner, which is why it is a method rather than
  /// two literals.
  Widget _errorRow(BuildContext context, String message) {
    final DsThemeData theme = DsTheme.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ds(3)),
      decoration: BoxDecoration(
        color: theme.destructive.withValues(alpha: _errorFillAlpha),
        borderRadius: BorderRadius.circular(DsRadii.md),
        border: Border.all(
          color: theme.destructive.withValues(alpha: _errorBorderAlpha),
          width: DsWidths.hairline,
        ),
      ),
      child: DsText(message, DsType.small, color: theme.destructiveInk),
    );
  }
}

/// `bg-destructive/8`.
const double _errorFillAlpha = 0.08;

/// `border-destructive/30`.
const double _errorBorderAlpha = 0.3;

/// `ModelPicker` — *"lives beside the other two and shares their one rule: hide
/// when there is nothing to choose."*
///
/// `if (models.length < 2) return null`, which is why the console guards on the
/// same count rather than this widget doing it twice.
class _ModelPicker extends StatelessWidget {
  const _ModelPicker({
    required this.models,
    required this.modelId,
    required this.onSelect,
    required this.disabled,
  });

  final List<DsAgentModel> models;
  final String? modelId;
  final ValueChanged<String> onSelect;
  final bool disabled;

  /// `w-80` on the content — *"wide enough for the hint to sit on one or two
  /// lines. A model menu whose descriptions wrap to four lines each is harder
  /// to compare than no descriptions at all."*
  static double get menuWidth => DsContainers.xs;

  /// `h-8 gap-1 px-2` on the trigger.
  static EdgeInsets get triggerPadding =>
      EdgeInsets.symmetric(horizontal: ds(2));

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    DsAgentModel? current;
    for (final DsAgentModel model in models) {
      if (model.id == modelId) current = model;
    }

    return DsDropdownMenu(
      width: menuWidth,
      side: DsPopoverSide.top,
      enabled: !disabled,
      trigger: DsButton(
        variant: DsButtonVariant.ghost,
        size: DsButtonSize.sm,
        padding: triggerPadding,
        // `DropdownMenuTrigger` stamps `aria-haspopup="menu"`, which cancels
        // the press scale — `dropdown_menu.dart`'s GAP CLOSED 1.
        suppressPressScale: true,
        onPressed: disabled ? null : () {},
        child: DsText(
          current?.label ?? 'Model',
          DsType.chip,
          color: theme.mutedForeground,
        ),
      ),
      children: <DsMenuChild>[
        const DsMenuLabel('Model'),
        const DsMenuSeparator(),
        for (final DsAgentModel model in models)
          DsMenuItem(
            label: model.label,
            // Divergence 2, closed: the hint stacks **under** the label, which
            // is what `flex-col items-start gap-1` does. It rode the shortcut
            // slot — and so sat beside the label — for as long as [DsMenuItem]
            // had no second line; see [DsMenuItem.subtitle].
            subtitle: model.hint,
            onSelect: () => onSelect(model.id),
          ),
      ],
    );
  }
}
