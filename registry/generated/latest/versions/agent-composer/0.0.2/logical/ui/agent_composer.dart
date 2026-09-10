/// `components/agent/parts/composer.tsx` — where the user says things.
///
/// *"A textarea that grows, a file tray above it, a slash palette over it, and
/// the controls along the bottom. The awkward part is keyboard routing: while
/// the palette is open the arrow keys and Enter belong to it, and the moment it
/// closes they belong to the textarea again. That is handled in one place here
/// rather than spread across both components."*
///
/// ## Port note — `value` / `onChange` / `inputRef` collapse into a controller
///
/// The reference is a **controlled** textarea: it takes `value` and
/// `onChange`, and a third prop `inputRef` for *"callers that write into it
/// from outside — the welcome card arming a skill"*, exposed as a prop rather
/// than through `forwardRef` because the composer's own ref is already spoken
/// for by the grow-to-fit measurement.
///
/// A controlled Flutter text field **is** a [TextEditingController]: it carries
/// the value, it publishes changes, and it is the handle an outside caller
/// writes through. So all three props are one [controller] here, plus an
/// optional [focusNode] for the half of `inputRef` that is about focus rather
/// than text. Nothing else in the signature moves.
///
/// ## Measured
///
/// Every number is a computed style read off
/// `/design-system/components/agent/composer` at 1440×900 on 2026-08-16
/// (`scratchpad/ag-composer-inv.js`, `ag-composer-live.js`,
/// `ag-composer-hover.js`).
///
/// | | value |
/// |---|---|
/// | shell | `rounded-xl` 16, 1px `--border`, `--card`, `shadow-pressed`; **96** tall at rest |
/// | input | `.type-body` 15 / 24, `px-4 py-3`, transparent, no ring — **48** at one row |
/// | grow | +24 per line to a **200** cap, then it scrolls (`MAX_ROWS_PX`) |
/// | control row | `px-2 pb-2 gap-1`, **40** tall over a 32px send |
/// | send | 32px box; `ArrowUp` at **16**, `Square` at **14** on the stop twin |
/// | tray | `border-b p-3`, **83** tall around one 58px card |
/// | drag | `border-agent bg-agent/8` — the fill replaces `--card` outright |
///
/// ## Drift register — recorded, shipped as written
///
///  1. **A 6px gap sits under the input that nothing declares.** The
///     `<textarea>` is `display: inline-block` inside a block `<div>`, so it
///     sits on a line box and the parent's strut adds its descent below it.
///     *(Measured: the input's bottom edge is 619.58 and the control row's top
///     is 625.58 — exactly 6px, and the shell is 96 where its children add up
///     to 90.)* It is real rendered geometry on every composer in the corpus,
///     so [inlineGap] pays it.
///  2. **Escape does not close the palette.** *(Probed: after Escape the
///     listbox is still mounted and the value is unchanged.)* The handler sets
///     the caret to −1 to close it — but `"/".slice(0, -1)` is `""`, which is a
///     perfectly valid **empty query** rather than null, and the `onKeyUp`
///     handler on the very same physical keypress then restores the caret to
///     its real offset. Two independent reasons, one outcome. Reproduced by
///     construction: [_caret] takes −1 on the key-down and the key-up puts it
///     back.
///  3. **The palette is clipped to a 56px sliver by the specimen's own frame.**
///     Not a component bug and reproduced for free: `bottom-full` puts a 256px
///     panel 8px above a composer that sits 40px inside a Panel whose card is
///     `overflow-hidden`, so the section documenting the slash palette shows
///     the bottom quarter of one row of it. *(Probed:
///     `document.elementFromPoint` at the palette's own top centre returns the
///     page header's chip list — the clipped part is not hit-testable either.)*
///  4. **`accessory` and `micControl` are slots this page never fills**, so the
///     `gap-1` on either side of the flex spacer is unreachable here. Built,
///     because the console fills both.
///
/// ## Recorded divergences
///
///  1. **The drop target is Flutter's own.** `onDragOver` / `onDragLeave` /
///     `onDrop` are DOM events carrying a `DataTransfer` of real `File`s. A
///     widget layer has no counterpart and may take no plugin, so the composer
///     is a [DragTarget] over `List<AgentAttachment>` — same three moments,
///     same `border-agent bg-agent/8`, same [formatBytes] refusal message
///     against [maxFileBytes], with attachments where the reference has
///     `File`s.
///  2. **The hidden `<input type="file">` has none.** `onPickFiles` is passed
///     to the plus menu on exactly the reference's condition — whenever
///     [onAttach] is non-null — so the *Photos & files* row mounts and the
///     menu's geometry is the reference's. Opening an OS file dialog is the one
///     thing this layer cannot do, so the row's press is inert.
///  3. **Paste-to-attach is not built.** `onPaste` reads
///     `event.clipboardData.files`; Flutter's clipboard carries text and
///     nothing else. Recorded rather than approximated.
///
/// ## Accepted limitation — an instance of 4f01eeb's, not a drift of this file
///
/// The palette's visible sliver is only **partly clickable**. [_ComposerStack]
/// skips its own bounds check, so it paints and clips exactly where the
/// reference does; but every ancestor between it and the Panel bounds-checks
/// first, which is the family-wide limitation commit **4f01eeb** already
/// recorded — *"ancestors bounds-check before the expander is consulted
/// (margin unreachable through snug parents) — pre-existing, family-wide,
/// wants its own ruling."* Of the reference's 56.4px of clickable sliver the
/// port makes roughly the bottom 16px hit-reachable — the part that falls
/// inside the Panel body's own box. Keyboard selection is complete and
/// unaffected, and it is the path the reference's own source comment calls the
/// point of the component.
///
/// **SUPERVISOR RULING (accepted as shipped):** *"paint fidelity over hit
/// reachability is the standing family-wide limitation recorded at commit
/// 4f01eeb, and portalling to gain the clicks at the cost of showing the full
/// 256px would be the wrong trade."* Filed here under that limitation's
/// register class rather than as a new standalone drift. The page test's case
/// pins the behaviour exactly as it stands; it documents an accepted
/// limitation, not an open defect.
///
/// ## USER-ORDERED MOBILE ADAPTATION — it keeps itself off the keyboard
///
/// The composer holds its own [EditableText] rather than a [Input], so it
/// wears the field family's one keyboard-avoidance hook — [FieldVisibility] —
/// directly, around [_ComposerStack]. On a phone, focusing it inside any
/// scroller scrolls the whole shell (input, control row and all) clear of the
/// software keyboard with a small margin. Inside [AgentConsole] the console's
/// own spacer has usually done that already, and the two compose rather than
/// compete: the hook measures how much of the scroller the keyboard actually
/// covers, which is nothing once room has been made. With no keyboard on
/// screen — every desktop frame, every existing test — the hook builds its
/// child and does nothing at all.
library;

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart'
    hide
        AspectRatio,
        Icon,
        OverlayPortal,
        RichText,
        SafeArea,
        ScrollPosition,
        Table,
        TableColumnWidth;

import './surface.dart';
import '../../design_system/foundation/shadows.dart';
import '../../design_system/foundation/spacing.dart';
import '../../design_system/foundation/surfaces.dart';
import '../../design_system/foundation/theme.dart';
import '../../design_system/foundation/typography.dart';
import '../../design_system/foundation/theme_scope.dart';
import './agent_attachments.dart';
import './agent_attach_menu.dart';
import './agent_core.dart';
import './agent_slash_palette.dart';
import './button.dart';
import './icon.dart';
import './icon_paths.g.dart';
import './input.dart';

/// The composer.
class AgentComposer extends StatefulWidget {
  const AgentComposer({
    super.key,
    required this.controller,
    this.focusNode,
    required this.onSubmit,
    this.onStop,
    this.disabled = false,
    this.busy = false,
    this.placeholder,
    this.commands,
    this.attachments,
    this.onAttach,
    this.onRemoveAttachment,
    this.accessory,
    this.micControl,
    this.dictationError,
  });

  /// `value` + `onChange` + `inputRef`, as one object — see the library note.
  final TextEditingController controller;

  /// The focus half of `inputRef`.
  final FocusNode? focusNode;

  final VoidCallback onSubmit;
  final VoidCallback? onStop;

  /// *"The transport is not ready to carry a message at all."*
  final bool disabled;

  /// *"The agent is answering"* — send becomes stop.
  final bool busy;

  /// Defaults to [defaultPlaceholder].
  final String? placeholder;

  final List<AgentCommand>? commands;
  final List<AgentAttachment>? attachments;

  final ValueChanged<List<AgentAttachment>>? onAttach;
  final ValueChanged<String>? onRemoveAttachment;

  /// *"Slot for the model picker, rendered on the left of the control row."*
  final Widget? accessory;

  /// *"The whole microphone control, supplied by the console because it also
  /// carries the speech settings. Rendered immediately left of send."*
  final Widget? micControl;

  /// `dictation?.error` — the only field of the dictation session this
  /// component reads.
  final String? dictationError;

  /// `placeholder = "Ask anything…"` — a real horizontal ellipsis.
  static const String defaultPlaceholder = 'Ask anything…';

  /// `placeholder={dragging ? "Drop files here" : placeholder}`.
  static const String dropPlaceholder = 'Drop files here';

  /// `aria-label="Message"`.
  static const String inputLabel = 'Message';

  /// `MAX_ROWS_PX` — *"Grow to fit, up to a cap, then scroll."*
  ///
  /// *"The cap is set here rather than as a utility because the same number
  /// drives the grow-to-fit effect above, and one constant beats a class and a
  /// literal that have to be kept in step by hand."*
  static double get maxRowsPx => space(50);

  /// `px-4 py-3` on the input.
  static EdgeInsets get inputInsets =>
      EdgeInsets.symmetric(horizontal: space(4), vertical: space(3));

  /// `px-2 pb-2` on the control row.
  static EdgeInsets get controlInsets =>
      EdgeInsets.only(left: space(2), right: space(2), bottom: space(2));

  /// `gap-1` between the controls.
  static double get controlGap => space(1);

  /// `p-3` on the file tray.
  static double get trayPadding => space(3);

  /// The inline-block descent under the input — drift 1.
  static double get inlineGap => space(1.5);

  /// `size-8` — the send, stop and plus controls are all one rung.
  static ButtonSize get controlSize => ButtonSize.iconSm;

  /// `size-4` on the send arrow — the base class list's, not the `size-8`
  /// rung's.
  static double get sendGlyphSize => Button.iconPxFor(ButtonSize.icon);

  /// `size-3.5` on the stop square, written explicitly at the call site.
  static double get stopGlyphSize => Button.iconPxFor(ButtonSize.iconSm);

  /// `bg-agent/8` while a file is over the composer.
  static const double dragFillAlpha = 0.08;

  /// `disabled:opacity-60` — on the input alone, and deliberately not the 45
  /// the button family dims to.
  static const double disabledInputOpacity = SurfaceOpacity.disabled;

  /// `mt-2` above the refusal and dictation lines.
  static double get messageTopGap => space(2);

  @override
  State<AgentComposer> createState() => _AgentComposerState();
}

class _AgentComposerState extends State<AgentComposer> {
  final GlobalKey<EditableTextState> _editableKey =
      GlobalKey<EditableTextState>();

  FocusNode? _ownedFocusNode;

  /// `const [caret, setCaret] = useState(0)`.
  int _caret = 0;

  /// `const [activeIndex, setActiveIndex] = useState(0)`.
  int _activeIndex = 0;

  /// `const [rejected, setRejected] = useState<string | null>(null)`.
  String? _rejected;

  /// `const [dragging, setDragging] = useState(false)`.
  bool _dragging = false;

  /// `const [lastQuery, setLastQuery] = useState(query)`.
  String? _lastQuery;
  bool _seenQuery = false;

  FocusNode get _focusNode =>
      widget.focusNode ?? (_ownedFocusNode ??= FocusNode());

  List<AgentAttachment> get _attachments =>
      widget.attachments ?? const <AgentAttachment>[];

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onValueChanged);
  }

  @override
  void didUpdateWidget(AgentComposer old) {
    super.didUpdateWidget(old);
    if (old.controller != widget.controller) {
      old.controller.removeListener(_onValueChanged);
      widget.controller.addListener(_onValueChanged);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onValueChanged);
    _ownedFocusNode?.dispose();
    super.dispose();
  }

  /// `onChange={(e) => { onChange(e.target.value); setCaret(e.target.selectionStart ?? e.target.value.length) }}`,
  /// and the `onClick` handler beside it — a Flutter controller publishes both
  /// the text and the selection through one notification.
  void _onValueChanged() {
    if (!mounted) return;
    final TextSelection selection = widget.controller.selection;
    setState(
      () => _caret = selection.isValid
          ? selection.baseOffset
          : widget.controller.text.length,
    );
  }

  /// `onKeyUp={(e) => setCaret(e.currentTarget.selectionStart ?? 0)}`.
  ///
  /// This is half of drift 2: it fires on the key-up of the very Escape whose
  /// key-down set the caret to −1.
  void _syncCaretFromKeyUp() {
    final TextSelection selection = widget.controller.selection;
    final int next = selection.isValid ? selection.baseOffset : 0;
    if (next == _caret) return;
    setState(() => _caret = next);
  }

  String get _value => widget.controller.text;

  /// `const query = commands?.length ? slashQuery(value, caret) : null`.
  String? get _query => (widget.commands?.isNotEmpty ?? false)
      ? slashQuery(_value, _caret)
      : null;

  List<AgentCommand> _matchesFor(String? query) => query == null
      ? const <AgentCommand>[]
      : filterCommands(widget.commands ?? const <AgentCommand>[], query);

  /// `command.run` runs locally and clears the box; otherwise a directive — or
  /// the id — is written in with *"a trailing space so the user can keep typing
  /// their own argument."*
  void _applyCommand(AgentCommand command) {
    final VoidCallback? run = command.run;
    if (run != null) {
      run();
      _write('');
      return;
    }
    final String? directive = command.directive;
    _write(directive != null ? '$directive ' : '/${command.id} ');
    _focusNode.requestFocus();
  }

  /// A controlled `onChange("…")` — the value and the caret it leaves behind.
  void _write(String value) {
    widget.controller.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
  }

  /// `takeFiles` — over attachments rather than `File`s (divergence 1).
  void _takeFiles(List<AgentAttachment> files) {
    final ValueChanged<List<AgentAttachment>>? onAttach = widget.onAttach;
    if (onAttach == null) return;

    final List<AgentAttachment> accepted = <AgentAttachment>[];
    final List<String> refused = <String>[];
    for (final AgentAttachment file in files) {
      if (file.size > maxFileBytes) {
        refused.add(file.name);
      } else {
        accepted.add(file);
      }
    }
    setState(
      () => _rejected = refused.isNotEmpty
          ? '${refused.join(", ")} — over the '
                '${formatBytes(maxFileBytes)} limit'
          : null,
    );
    if (accepted.isNotEmpty) onAttach(accepted);
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is KeyUpEvent) {
      _syncCaretFromKeyUp();
      return KeyEventResult.ignored;
    }
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    final String? query = _query;
    final List<AgentCommand> matches = _matchesFor(query);
    final bool paletteOpen = query != null && matches.isNotEmpty;
    final LogicalKeyboardKey key = event.logicalKey;
    final bool enter =
        key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.numpadEnter;

    if (paletteOpen) {
      if (key == LogicalKeyboardKey.arrowDown) {
        setState(() => _activeIndex = (_activeIndex + 1) % matches.length);
        return KeyEventResult.handled;
      }
      if (key == LogicalKeyboardKey.arrowUp) {
        setState(
          () => _activeIndex =
              (_activeIndex - 1 + matches.length) % matches.length,
        );
        return KeyEventResult.handled;
      }
      if (enter || key == LogicalKeyboardKey.tab) {
        _applyCommand(matches[_activeIndex]);
        return KeyEventResult.handled;
      }
      if (key == LogicalKeyboardKey.escape) {
        // *"Closing the palette without clearing the text: the user may have
        // meant to type a literal slash."* — which is drift 2: it closes
        // nothing.
        setState(() => _caret = -1);
        return KeyEventResult.handled;
      }
    }

    final bool shift = HardwareKeyboard.instance.isShiftPressed;
    if (enter && !shift) {
      if (!widget.disabled) widget.onSubmit();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    final String? query = _query;
    final List<AgentCommand> matches = _matchesFor(query);
    final bool paletteOpen = query != null && matches.isNotEmpty;

    // *"A new query starts at the top of its own list. Adjusted during render
    // rather than in an effect … React re-runs this component before touching
    // the DOM, so this reset is never visible."* A Flutter build is the same
    // moment: nothing has been laid out yet.
    if (!_seenQuery || _lastQuery != query) {
      _lastQuery = query;
      _seenQuery = true;
      _activeIndex = 0;
    }

    final bool canSend =
        !widget.disabled &&
        (_value.trim().isNotEmpty || _attachments.isNotEmpty);

    final Widget shell = Surface(
      spec: Shadows.inset,
      radius: BorderRadius.circular(Radii.xl),
      // twMerge drops `bg-card` and `border-border` outright while dragging —
      // *(measured: the class list is `shadow-pressed rounded-xl border
      // border-agent bg-agent/8`, with neither of the resting pair left)*.
      fill: _dragging
          ? theme.agentAccent.withValues(alpha: AgentComposer.dragFillAlpha)
          : theme.card,
      border: Border.all(
        color: _dragging ? theme.agentAccent : theme.border,
        width: BorderWidths.hairline,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (_attachments.isNotEmpty)
            Container(
              padding: EdgeInsets.all(AgentComposer.trayPadding),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: theme.border,
                    width: BorderWidths.hairline,
                  ),
                ),
              ),
              child: AgentAttachmentList(
                attachments: _attachments,
                onRemove: widget.onRemoveAttachment,
                compact: true,
              ),
            ),
          _ComposerInput(
            editableKey: _editableKey,
            controller: widget.controller,
            focusNode: _focusNode,
            enabled: !widget.disabled,
            placeholder: _dragging
                ? AgentComposer.dropPlaceholder
                : (widget.placeholder ?? AgentComposer.defaultPlaceholder),
          ),
          // Drift 1 — the line box under an `inline-block` textarea.
          SizedBox(height: AgentComposer.inlineGap),
          Padding(
            padding: AgentComposer.controlInsets,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // *"Adding to the message lives on the left; acting on it
                // lives on the right. The plus is one control for 'what goes
                // in', whether that is a file or a capability."*
                AgentAttachMenu(
                  onPickFiles: widget.onAttach != null ? _pickFiles : null,
                  commands: widget.commands,
                  onRunCommand: _applyCommand,
                  disabled: widget.disabled,
                ),
                SizedBox(width: AgentComposer.controlGap),
                if (widget.accessory != null) ...<Widget>[
                  widget.accessory!,
                  SizedBox(width: AgentComposer.controlGap),
                ],
                // `<span className="flex-1" />`.
                const Expanded(child: SizedBox.shrink()),
                SizedBox(width: AgentComposer.controlGap),
                // *"Speaking is the other way of composing a message, so the
                // microphone sits with send rather than with the attach
                // controls."*
                if (widget.micControl != null) ...<Widget>[
                  widget.micControl!,
                  SizedBox(width: AgentComposer.controlGap),
                ],
                if (widget.busy && widget.onStop != null)
                  Button(
                    variant: ButtonVariant.outline,
                    size: AgentComposer.controlSize,
                    label: 'Stop',
                    onPressed: widget.onStop,
                    child: Icon.lucide(
                      Lucide.square,
                      sizePx: AgentComposer.stopGlyphSize,
                    ),
                  )
                else
                  Button(
                    size: AgentComposer.controlSize,
                    label: 'Send',
                    onPressed: canSend ? widget.onSubmit : null,
                    child: Icon.lucide(
                      Lucide.arrowUp,
                      sizePx: AgentComposer.sendGlyphSize,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );

    final Widget body = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        shell,
        if (_rejected != null) _Message(text: _rejected!),
        if (widget.dictationError != null)
          _Message(text: widget.dictationError!),
      ],
    );

    // `onDragOver` / `onDragLeave` / `onDrop` — divergence 1.
    final Widget dropTarget = widget.onAttach == null
        ? body
        : DragTarget<List<AgentAttachment>>(
            onWillAcceptWithDetails:
                (DragTargetDetails<List<AgentAttachment>> details) {
                  setState(() => _dragging = true);
                  return true;
                },
            onLeave: (List<AgentAttachment>? _) =>
                setState(() => _dragging = false),
            onAcceptWithDetails:
                (DragTargetDetails<List<AgentAttachment>> details) {
                  setState(() => _dragging = false);
                  _takeFiles(details.data);
                },
            builder:
                (
                  BuildContext context,
                  List<List<AgentAttachment>?> candidate,
                  List<dynamic> rejected,
                ) => body,
          );

    return Focus(
      // The key router. It sits above the field's own node so a key reaches it
      // before `DefaultTextEditingShortcuts`, which `WidgetsApp` installs above
      // the whole tree.
      canRequestFocus: false,
      skipTraversal: true,
      onKeyEvent: _onKey,
      // USER-ORDERED MOBILE ADAPTATION — the field family's one keyboard-
      // avoidance hook, from [FieldVisibility]. The composer holds an
      // [EditableText] of its own rather than a [Input], so it wears the
      // mechanism directly; wrapped around the stack, so what is revealed is
      // the shell and its control row and not just the line being typed into.
      // Inert on every desktop frame — see the hook's own doc.
      child: FieldVisibility(
        focusNode: _focusNode,
        child: _ComposerStack(
          gap: AgentSlashPalette.bottomGap,
          children: <Widget>[
            dropTarget,
            if (paletteOpen)
              AgentSlashPalette(
                commands: matches,
                activeIndex: _activeIndex,
                onSelect: _applyCommand,
                onHover: (int i) => setState(() => _activeIndex = i),
              ),
          ],
        ),
      ),
    );
  }

  /// `fileInput.current?.click()` — divergence 2. The row exists because the
  /// reference's condition for mounting it is `onAttach`, and it is inert
  /// because a widget layer cannot open an OS file dialog.
  void _pickFiles() {}
}

/// The `<p className="type-caption text-destructive-ink mt-2">` under the
/// shell, for a refused file or a dictation error.
class _Message extends StatelessWidget {
  const _Message({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(top: AgentComposer.messageTopGap),
    child: StyledText(
      text,
      TextStyles.small,
      color: ThemeScope.of(context).destructiveText,
    ),
  );
}

/// The `<textarea>`: `.type-body`, transparent, `outline-none`, `resize-none`,
/// growing to [AgentComposer.maxRowsPx] and then scrolling.
class _ComposerInput extends StatefulWidget {
  const _ComposerInput({
    required this.editableKey,
    required this.controller,
    required this.focusNode,
    required this.enabled,
    required this.placeholder,
  });

  final GlobalKey<EditableTextState> editableKey;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool enabled;
  final String placeholder;

  @override
  State<_ComposerInput> createState() => _ComposerInputState();
}

class _ComposerInputState extends State<_ComposerInput> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChanged);
  }

  @override
  void didUpdateWidget(_ComposerInput old) {
    super.didUpdateWidget(old);
    if (old.controller != widget.controller) {
      old.controller.removeListener(_onChanged);
      widget.controller.addListener(_onChanged);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChanged);
    super.dispose();
  }

  /// Only the placeholder's presence depends on the text here; the box grows on
  /// its own.
  void _onChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final TextStyle style = StyledText.styleOf(context, TextStyles.body);

    final Widget editable = EditableText(
      key: widget.editableKey,
      controller: widget.controller,
      focusNode: widget.focusNode,
      readOnly: !widget.enabled,
      // `rows={1}` with no cap of its own — the cap is the box's, below.
      maxLines: null,
      minLines: 1,
      keyboardType: TextInputType.multiline,
      style: style,
      cursorColor: theme.foreground,
      backgroundCursorColor: theme.mutedForeground,
      selectionColor: theme.primary.withValues(
        alpha: FieldSurfaceRecipe.selectionAlpha,
      ),
    );

    Widget body = Stack(
      alignment: AlignmentDirectional.topStart,
      children: <Widget>[
        SizedBox(width: double.infinity, child: editable),
        if (widget.controller.text.isEmpty)
          // `placeholder:text-muted-foreground`. Positioned so it never
          // contributes to the box's height.
          Positioned.fill(
            child: IgnorePointer(
              child: Align(
                alignment: AlignmentDirectional.topStart,
                child: StyledText(
                  widget.placeholder,
                  TextStyles.body,
                  color: theme.mutedForeground,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
              ),
            ),
          ),
      ],
    );

    // `max-height: MAX_ROWS_PX` on the border box, so the padding is paid for
    // from inside the cap and the content scrolls in what is left.
    body = ConstrainedBox(
      constraints: BoxConstraints(maxHeight: AgentComposer.maxRowsPx),
      child: Padding(padding: AgentComposer.inputInsets, child: body),
    );

    body = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => widget.editableKey.currentState?.requestKeyboard(),
      child: MouseRegion(cursor: SystemMouseCursors.text, child: body),
    );

    // `disabled:opacity-60` — the input's own, and nothing else in the shell
    // dims with it.
    return Opacity(
      opacity: widget.enabled ? 1 : AgentComposer.disabledInputOpacity,
      child: Semantics(
        textField: true,
        multiline: true,
        label: AgentComposer.inputLabel,
        enabled: widget.enabled,
        child: body,
      ),
    );
  }
}

/* ── The out-of-flow palette ─────────────────────────────────────────────── */

/// `<div className="relative">` with an `absolute bottom-full mb-2 z-10` child.
///
/// A [Stack] cannot express it: the palette must **not** contribute to the
/// composer's height, must sit entirely above it, and must paint over whatever
/// is up there. So this is the CSS box directly — one in-flow child that sets
/// the size, and one laid out at `w-full` and offset to sit [gap] above the
/// whole thing.
///
/// [RenderBox.hitTest]'s bounds check is skipped here for the same reason the
/// browser has none: a positioned child that escapes its parent's box is still
/// the thing under the pointer. Ancestors still bounds-check — and on this page
/// the nearest one that matters is the Panel's own `overflow-hidden`, which is
/// exactly what clips the reference too (drift 3). What the ancestors above
/// *that* cost is the accepted limitation in this library's doc: an instance of
/// 4f01eeb's, ruled on and shipped, not a defect of this box.
class _ComposerStack extends MultiChildRenderObjectWidget {
  const _ComposerStack({required this.gap, required super.children});

  /// `mb-2`.
  final double gap;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderComposerStack(gap);

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderComposerStack renderObject,
  ) {
    renderObject.gap = gap;
  }
}

class _RenderComposerStack extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, StackParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, StackParentData> {
  _RenderComposerStack(this._gap);

  double _gap;
  set gap(double value) {
    if (_gap == value) return;
    _gap = value;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! StackParentData) {
      child.parentData = StackParentData();
    }
  }

  RenderBox? get _overlay =>
      firstChild == null ? null : childAfter(firstChild!);

  @override
  double computeMinIntrinsicWidth(double height) =>
      firstChild?.getMinIntrinsicWidth(height) ?? 0;

  @override
  double computeMaxIntrinsicWidth(double height) =>
      firstChild?.getMaxIntrinsicWidth(height) ?? 0;

  @override
  double computeMinIntrinsicHeight(double width) =>
      firstChild?.getMinIntrinsicHeight(width) ?? 0;

  @override
  double computeMaxIntrinsicHeight(double width) =>
      firstChild?.getMaxIntrinsicHeight(width) ?? 0;

  @override
  Size computeDryLayout(BoxConstraints constraints) =>
      firstChild?.getDryLayout(constraints) ?? constraints.smallest;

  @override
  void performLayout() {
    final RenderBox? body = firstChild;
    if (body == null) {
      size = constraints.smallest;
      return;
    }
    body.layout(constraints, parentUsesSize: true);
    size = body.size;
    (body.parentData! as StackParentData).offset = Offset.zero;

    final RenderBox? overlay = _overlay;
    if (overlay == null) return;
    // `left-0 w-full` against the positioned parent.
    overlay.layout(
      BoxConstraints.tightFor(width: size.width),
      parentUsesSize: true,
    );
    // `bottom-full mb-2` — its bottom edge lands `gap` above this box's top.
    (overlay.parentData! as StackParentData).offset = Offset(
      0,
      -(overlay.size.height + _gap),
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // `z-10` on the palette: painted last, so it covers whatever is above.
    defaultPaint(context, offset);
  }

  @override
  void applyPaintTransform(RenderBox child, Matrix4 transform) {
    final StackParentData data = child.parentData! as StackParentData;
    transform.translateByDouble(data.offset.dx, data.offset.dy, 0, 1);
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    // No `size.contains(position)` — see the class doc.
    if (hitTestChildren(result, position: position) || hitTestSelf(position)) {
      result.add(BoxHitTestEntry(this, position));
      return true;
    }
    return false;
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) =>
      defaultHitTestChildren(result, position: position);
}
