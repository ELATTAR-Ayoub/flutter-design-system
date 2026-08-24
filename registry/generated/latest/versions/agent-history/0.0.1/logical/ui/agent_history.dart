/// `components/agent/parts/{history-card,chat-history,history-search}.tsx` —
/// every conversation the user has had with this agent.
///
/// Three widgets and one helper, in the reference's own split:
///
///  * [ElHistoryCard] decides what a conversation *can do* and what each of
///    those actions looks like. Built on [ElItem], not beside it — a history
///    row is a list row, and `Item` already owns the border, the radius, the
///    padding, the gap and the colour transition.
///  * [ElChatHistory] *arranges*. It is a drawer inside the console, not a
///    sheet over the page, and it reads every capability off the store.
///  * [ElHistorySearch] is a palette rather than a filter box, because the list
///    lives inside a console inside a dialog and the thing being searched for
///    is a sentence.
///  * [ElFlipController] is `core/use-flip.ts` — and the reason it paints
///    nothing is the headline finding below.
///
/// ## Measured on the live reference (2026-08-16, dark, 1440 × 900)
///
/// | part | value |
/// |---|---|
/// | card | 1030 × **69.5** at full width, 482 × **89** in a half-width panel (the preview wraps), radius 12, 1px `--border`, `gap-2.5 px-3 py-2.5` |
/// | its `transition-colors duration-fast` | **0.25s / cubic-bezier(0.22, 1, 0.36, 1)** — `duration-fast` is a no-op, corpus-wide |
/// | `anim-row-in` | `pulls-row-in 0.25s --ease-out both`, delay **0.08s flat** — no `--row-index` is set in these demos, so nothing staggers |
/// | list | ONE flat `ItemGroup gap-1` → a **73.5px** pitch; no "Pinned"/"Recents" headings (those are the drawer's) |
/// | pin button | `ghost` `icon-sm`, 32 × 32, `opacity: 0` at rest on an unpinned row and 1 on card hover; a pinned row holds it lit |
/// | menu trigger | 32 × 32, `opacity: 0` at rest on **every** row |
/// | inline rename | an `Input` of **348 × 24**, `h-6 rounded-sm px-1.5 py-0 shadow-none`, whole value selected on entry — **and the card's height does not move** (89.0 before and after) |
/// | inline confirm | `role="alertdialog"` **480 × 87** over the row, `px-3 gap-2`, radius 12, opaque `--card` under `border-destructive/50` |
/// | menu | rows 144 × 35 — Share, Rename, Pin/Unpin, separator, Delete |
/// | drawer | **384** wide (`max-w-sm`), full height, `--popover`, `shadow-e4`, `anim-panel-in` 0.32s, over a `bg-scrim anim-fade-in` button |
///
/// ## THE FLIP IS DEAD, AND THAT IS WHAT THE READER SEES
///
/// `use-flip.ts` is a correct FLIP: it measures before the reorder, inverts
/// with `node.style.transform`, and releases on the next frame under
/// `transform 250ms var(--ease-settle)`. **None of it reaches the screen.**
///
/// *(Probed `scratchpad/ag-h-flip2.js`, 2026-08-16, with the target pinned by
/// NODE rather than resolved by selector index — which is what the first pass
/// got wrong.)* Pinning "Putting a pack on hold" moves it from y=536.75 to
/// y=463.25, and across the whole 900ms window the moved row reports:
///
/// ```text
/// t=  13.4  y=536.75  tr=matrix(1,0,0,1,0,0)  an=pulls-row-in  inline=""
/// t= 310.7  y=463.25  tr=matrix(1,0,0,1,0,0)  an=pulls-row-in  inline="translate(0px, 73.5px)"
/// t= 332.4  y=463.25  tr=matrix(1,0,0,1,0,0)  an=pulls-row-in  inline=""  inlineTrans="transform 250ms var(--ease-settle)"
/// ```
///
/// The inline transform is written, and the **computed** transform never leaves
/// the identity matrix. The cause is the cascade: every card carries
/// `anim-row-in`, whose `animation-fill-mode: both` keeps `pulls-row-in`'s
/// `to { transform: none }` in effect for ever, and **CSS animations outrank
/// normal author declarations, inline styles included**. So the pinned row
/// teleports one row up in a single frame.
///
/// What *does* move is the row it overtook. In the same trace "Pricing service
/// outage" runs `matrix(1,0,0,1,-10,0)` → 0 over 250ms — which is
/// `pulls-row-in`'s own `translateX(-10px)`, horizontally, replaying after the
/// 80ms delay. Exactly one row replays, and it is the one React's
/// `lastPlacedIndex` walk moves in the DOM: the child whose old index is below
/// the running maximum of the old indices already placed. [ElFlipController]
/// ports that rule and bumps [ElFlipController.generationOf] for that row, so
/// the port paints what the reference paints — a teleport, plus one neighbour
/// replaying its entrance — and [ElFlipController.travel] keeps the inversion
/// that was computed and discarded, so a test can pin the drift rather than
/// take it on trust.
library;

import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../effects/machine_surface.dart';
import '../foundation/motion.dart';
import '../foundation/shadows.dart';
import '../foundation/spacing.dart';
import '../foundation/theme.dart';
import '../foundation/typography.dart';
import '../theme_scope.dart';
import 'agent_core.dart';
import 'alert.dart';
import 'alert_dialog.dart';
import 'button.dart';
import 'command.dart';
import 'dialog.dart';
import 'dropdown_menu.dart';
import 'empty.dart';
import 'field.dart';
import 'icon.dart';
import 'icon_paths.g.dart';
import 'input.dart';
import 'item.dart';
import 'menu.dart';
import 'popover.dart';
import 'spinner.dart';

/* ═══════════════════════════════════════════════════════════════════════════
   Row motion — `anim-row-in`, `anim-row-out`, `anim-blur-*`
   ═══════════════════════════════════════════════════════════════════════════ */

/// `anim-row-in` / `anim-row-out`, the two utilities every editable list in the
/// system shares.
///
/// * in — `pulls-row-in`: `opacity 0 → 1`, `translateX(-10px) → none`, over
///   [ElDurations.base] on [ElCurves.out], after an
///   `animation-delay: calc(--duration-tick + var(--row-index, 0) *
///   --duration-tick / 2)`. **Nothing on this page sets `--row-index`**, so the
///   delay is a flat 80ms on every row *(measured: `animationDelay: 0.08s` on
///   all seven)* and the list does not stagger.
/// * out — `pulls-row-out`: opacity and a −24px slide over the first 45%, then
///   the box collapses its own height to zero over the rest, all on
///   [ElCurves.inOut]. One movement, so the rows below rise into the gap
///   instead of snapping shut after it.
///
/// [generation] replays the entrance when it changes — see the library note on
/// which row that is and why.
class ElRowMotion extends StatefulWidget {
  const ElRowMotion({
    super.key,
    required this.child,
    this.generation = 0,
    this.leaving = false,
  });

  final Widget child;

  /// Bumped to replay `anim-row-in`.
  final int generation;

  /// `data-leaving` — the list owns the timing, and the row stays mounted for
  /// the whole of it.
  final bool leaving;

  /// `translateX(-10px)` — `pulls-row-in`'s only travel.
  // allow-hardcoded: a keyframe offset from globals.css L3079, not a spacing
  // token — `--spacing * 2.5` would be a coincidence, not a derivation.
  static const double enterShift = -10;

  /// `translateX(-24px)` at the 45% stop of `pulls-row-out`.
  // allow-hardcoded: globals.css L3088, same reason as [enterShift].
  static const double exitShift = -24;

  /// The keyframe stop where `pulls-row-out` hands over from the slide to the
  /// collapse.
  static const double exitBreak = 0.45;

  /// `animation-delay` + `animation-duration`, as one controller.
  ///
  /// The delay is `calc(--duration-tick + var(--row-index, 0) *
  /// --duration-tick / 2)` and **no specimen on this page sets `--row-index`**
  /// *(measured: `animationDelay: 0.08s` on all seven rows)*, so it is a flat
  /// [ElDurations.tick]. It rides the curve rather than a timer because
  /// `animation-fill-mode: both` means the delay is *part of the animation* —
  /// the backwards fill holds the `from` keyframe through it — and because a
  /// pending [Timer] outlives a widget test that never advances the clock.
  static Duration get enterSpan => ElDurations.tick + ElDurations.base;

  /// Where the delay ends inside [enterSpan].
  static double get enterDelayFraction =>
      ElDurations.tick.inMicroseconds / enterSpan.inMicroseconds;

  /// The whole of `anim-row-in`: hold, then `pulls-row-in` on `--ease-out`.
  static Curve get enterCurve =>
      Interval(enterDelayFraction, 1, curve: ElCurves.out);

  @override
  State<ElRowMotion> createState() => _ElRowMotionState();
}

class _ElRowMotionState extends State<ElRowMotion>
    with TickerProviderStateMixin {
  late final AnimationController _enter = AnimationController(
    vsync: this,
    duration: ElRowMotion.enterSpan,
  );
  late final AnimationController _exit = AnimationController(
    vsync: this,
    duration: ElDurations.base,
  );

  /// `elAnimationDuration` reads the ambient `disableAnimations`, which is an
  /// inherited lookup — so the first play waits for [didChangeDependencies]
  /// rather than running in [initState].
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    _play();
    if (widget.leaving) _exit.value = 1;
  }

  void _play() {
    final Duration span = elAnimationDuration(context, ElRowMotion.enterSpan);
    _enter.duration = span;
    if (span == Duration.zero) {
      _enter.value = 1;
      return;
    }
    _enter.forward(from: 0);
  }

  @override
  void didUpdateWidget(ElRowMotion old) {
    super.didUpdateWidget(old);
    if (old.generation != widget.generation) _play();
    if (old.leaving != widget.leaving) {
      _exit
        ..duration = elAnimationDuration(context, ElDurations.base)
        ..value = widget.leaving ? 0 : 1;
      if (!widget.leaving) {
        _exit.value = 0;
      } else if (_exit.duration == Duration.zero) {
        // Reduced motion collapses the animation to its final frame, which for
        // `pulls-row-out` is a zero-height box — the gap the list rises into.
        _exit.value = 1;
      } else {
        _exit.forward();
      }
    }
  }

  @override
  void dispose() {
    _enter.dispose();
    _exit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge(<Listenable>[_enter, _exit]),
      builder: (BuildContext context, Widget? child) {
        if (_exit.value > 0 || widget.leaving) {
          final double t = _exit.value;
          // `0% → 45%` carries opacity and the slide; `45% → 100%` carries the
          // collapse, and the transform holds at −24px through it.
          final double slide =
              ElCurves.inOut.transform(t.clamp(0, 1)) / ElRowMotion.exitBreak;
          final double a = slide.clamp(0, 1);
          final double collapse = t <= ElRowMotion.exitBreak
              ? 1
              : 1 -
                    ((ElCurves.inOut.transform(t) - ElRowMotion.exitBreak) /
                            (1 - ElRowMotion.exitBreak))
                        .clamp(0, 1);
          return Align(
            alignment: Alignment.topCenter,
            heightFactor: collapse,
            child: Opacity(
              opacity: 1 - a,
              child: Transform.translate(
                offset: Offset(ElRowMotion.exitShift * a, 0),
                child: child,
              ),
            ),
          );
        }
        // `animation-fill-mode: both` — the backwards fill is why the row is
        // not painted at full opacity for the 80ms before its delay ends.
        final double t = ElRowMotion.enterCurve.transform(_enter.value);
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(ElRowMotion.enterShift * (1 - t), 0),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}

/// `blurClass(phase)` — what a transcript wears while a conversation is swapped.
///
/// * `anim-blur-out` — `opacity 1 → 0`, `blur(0) → blur(6px)`, over
///   [ElDurations.fast] on [ElCurves.curveIn].
/// * `anim-blur-in` — `opacity 0 → 1`, `blur(8px) → blur(0)`, over
///   [ElDurations.base] on [ElCurves.settle].
///
/// *(Measured end to end: `pulls-blur-out` from t≈112 to 374, `pulls-blur-in`
/// from 374 to ≈586 — 150 out, 250 in, ≈475ms of wall clock including the
/// click-to-first-frame latency.)*
///
/// A CSS `blur(r)` radius is twice the Gaussian σ Flutter's [ui.ImageFilter]
/// takes, which is why the two constants below are halved at the call.
class ElBlurSwitch extends StatefulWidget {
  const ElBlurSwitch({super.key, required this.phase, required this.child});

  final ElSwitchPhase phase;
  final Widget child;

  /// `blur(6px)` — where `pulls-blur-out` ends.
  // allow-hardcoded: a keyframe filter radius from globals.css L3357; the
  // `--blur-*` scale does not carry it.
  static const double outRadius = 6;

  /// `blur(8px)` — where `pulls-blur-in` starts.
  // allow-hardcoded: globals.css L3360, same reason as [outRadius].
  static const double inRadius = 8;

  @override
  State<ElBlurSwitch> createState() => _ElBlurSwitchState();
}

class _ElBlurSwitchState extends State<ElBlurSwitch>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this);

  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    _restart();
  }

  @override
  void didUpdateWidget(ElBlurSwitch old) {
    super.didUpdateWidget(old);
    if (old.phase != widget.phase) _restart();
  }

  void _restart() {
    final Duration d = switch (widget.phase) {
      ElSwitchPhase.idle => Duration.zero,
      ElSwitchPhase.out => ElDurations.fast,
      ElSwitchPhase.blurIn => ElDurations.base,
    };
    _c.duration = elAnimationDuration(context, d);
    if (_c.duration == Duration.zero) {
      _c.value = 1;
      return;
    }
    _c.forward(from: 0);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.phase == ElSwitchPhase.idle) return widget.child;
    return AnimatedBuilder(
      animation: _c,
      builder: (BuildContext context, Widget? child) {
        final bool out = widget.phase == ElSwitchPhase.out;
        final double t = (out ? ElCurves.curveIn : ElCurves.settle).transform(
          _c.value.clamp(0, 1),
        );
        final double opacity = out ? 1 - t : t;
        final double radius = out
            ? ElBlurSwitch.outRadius * t
            : ElBlurSwitch.inRadius * (1 - t);
        // A zero-σ blur still costs a saveLayer, so the identity case skips it.
        if (radius <= 0) return Opacity(opacity: opacity, child: child);
        return Opacity(
          opacity: opacity,
          child: ImageFiltered(
            imageFilter: ui.ImageFilter.blur(
              sigmaX: radius / 2,
              sigmaY: radius / 2,
              tileMode: TileMode.decal,
            ),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}

/* ═══════════════════════════════════════════════════════════════════════════
   useFlip
   ═══════════════════════════════════════════════════════════════════════════ */

/// `core/use-flip.ts` — measure, invert, play. And on this page, discard.
///
/// The reference's own contract is kept: [keyFor] is `ref(id)`, [measure] is
/// called immediately **before** the state change that reorders the list, and
/// [travel] is what the inversion would have been. See the library note for why
/// none of it paints, and what does.
class ElFlipController extends ChangeNotifier {
  ElFlipController({this.duration = ElDurations.base});

  /// `useFlip(duration = 250)`, released on `var(--ease-settle)`.
  final Duration duration;

  final Map<String, GlobalKey> _keys = <String, GlobalKey>{};
  final Map<String, Offset> _before = <String, Offset>{};
  final Map<String, Offset> _travel = <String, Offset>{};
  final Map<String, int> _generation = <String, int>{};
  List<String> _order = const <String>[];
  bool _armed = false;

  /// `Math.abs(dx) < 1 && Math.abs(dy) < 1` — sub-pixel drift is not movement.
  static const double minimumTravel = 1;

  /// `ref(id)` — attach to every row that can move.
  GlobalKey keyFor(String id) => _keys.putIfAbsent(id, GlobalKey.new);

  /// The inversion the last [measure] produced, per row.
  ///
  /// Computed and **never painted** — the whole point of the drift. Public so a
  /// test can assert that the port measured the same 73.5px travel the browser
  /// measured, and threw it away for the same reason.
  Map<String, Offset> get travel => Map<String, Offset>.unmodifiable(_travel);

  /// How many times this row's `anim-row-in` has been replayed.
  int generationOf(String id) => _generation[id] ?? 0;

  /// `measure()` — call immediately BEFORE the state change that reorders.
  void measure() {
    _before.clear();
    _keys.forEach((String id, GlobalKey key) {
      final RenderObject? object = key.currentContext?.findRenderObject();
      if (object is RenderBox && object.hasSize) {
        _before[id] = object.localToGlobal(Offset.zero);
      }
    });
    _armed = true;
  }

  /// Called from the list's `build` with the order it is about to paint.
  ///
  /// Two jobs, and only on the render that follows an explicit [measure] —
  /// `armed.current` in the reference, and for the same reason: without it a
  /// rename, a hover or a store refresh would replay the travel.
  void reconcile(List<String> order) {
    if (!_armed) {
      _order = List<String>.unmodifiable(order);
      return;
    }
    _armed = false;
    for (final String id in _movedByReconciliation(_order, order)) {
      _generation[id] = (_generation[id] ?? 0) + 1;
    }
    _order = List<String>.unmodifiable(order);
    // The inversion itself needs post-layout positions, and it is discarded
    // either way, so it is recorded after the frame rather than blocking it.
    WidgetsBinding.instance.addPostFrameCallback((_) => _record());
  }

  void _record() {
    _travel.clear();
    _before.forEach((String id, Offset first) {
      final RenderObject? object = _keys[id]?.currentContext
          ?.findRenderObject();
      if (object is! RenderBox || !object.hasSize) return;
      final Offset delta = first - object.localToGlobal(Offset.zero);
      if (delta.dx.abs() < minimumTravel && delta.dy.abs() < minimumTravel) {
        return;
      }
      _travel[id] = delta;
    });
    _before.clear();
  }

  /// React's `reconcileChildrenArray` placement rule, ported.
  ///
  /// Walking the new order, a child is given a `Placement` — a real
  /// `insertBefore` — whenever its **old** index is below the running maximum
  /// of the old indices already placed. That is exactly the one row per pin
  /// whose `anim-row-in` was measured replaying.
  static List<String> _movedByReconciliation(
    List<String> before,
    List<String> after,
  ) {
    final Map<String, int> was = <String, int>{
      for (int i = 0; i < before.length; i++) before[i]: i,
    };
    final List<String> moved = <String>[];
    int lastPlaced = 0;
    for (final String id in after) {
      final int? old = was[id];
      // A row with no previous index is new: it mounts, which plays the
      // entrance once through [ElRowMotion.initState] rather than through a
      // generation bump.
      if (old == null) continue;
      if (old < lastPlaced) {
        moved.add(id);
      } else {
        lastPlaced = old;
      }
    }
    return moved;
  }
}

/* ═══════════════════════════════════════════════════════════════════════════
   HistoryCard
   ═══════════════════════════════════════════════════════════════════════════ */

/// `HistoryCardProps['confirm']` — which shape the destructive confirmation
/// takes.
enum ElHistoryConfirm { inline, dialog }

/// `HistoryCardProps['rename']`.
enum ElHistoryRename { inline, dialog }

/// One conversation in the history list.
///
/// **Renaming moves nothing.** The media slot, the timestamp, the preview and
/// the row's own box hold their exact positions — only the title swaps for an
/// input on the same baseline at the same height. Enter commits, Escape
/// abandons, blur commits.
///
/// **Deleting asks in the row's own space.** The confirmation arrives from the
/// trailing edge and lands *on top of* the controls it is asking about, so the
/// delete button is physically gone by the time the question is up.
///
/// Both destructive shapes and both rename shapes ship, chosen per card,
/// because a system that offers only one has not made the case for it.
class ElHistoryCard extends StatefulWidget {
  const ElHistoryCard({
    super.key,
    required this.conversation,
    required this.onOpen,
    required this.onRename,
    required this.onRemove,
    this.active = false,
    this.confirm = ElHistoryConfirm.inline,
    this.rename = ElHistoryRename.inline,
    this.onPin,
    this.onShare,
    this.leaving = false,
    this.entranceGeneration = 0,
  });

  final ElConversationSummary conversation;

  /// The conversation the console is showing. Marked by its **glyph**, not by
  /// its surface: a tinted row competed with the pinned section it might be in
  /// and with the destructive confirm that covers it, and three overlapping
  /// colour states on one row is one too many to read at a glance.
  final bool active;

  final ElHistoryConfirm confirm;
  final ElHistoryRename rename;

  final void Function(String id) onOpen;
  final void Function(String id, String title) onRename;
  final void Function(String id) onRemove;

  /// Omitted when the store cannot pin. The affordance goes with it.
  final void Function(String id, bool pinned)? onPin;

  /// Omitted when the store cannot share.
  final void Function(String id)? onShare;

  /// Set while this row plays its exit. The list owns the timing.
  final bool leaving;

  /// [ElFlipController.generationOf] for this row — replays `anim-row-in`.
  final int entranceGeneration;

  /// `CONFIRM_EXIT_MS` — matches `anim-confirm-out`, `--duration-tick`.
  static Duration get confirmExit => ElDurations.tick;

  /// `EXIT_MS` in `chat-history.tsx` — *"must match `--duration-base`"*.
  static Duration get rowExit => ElDurations.base;

  /// `h-6` on `ItemTitle`, in both states — what stops a rename moving the
  /// timestamp beneath it by a single pixel.
  static double get titleHeight => el(6);

  /// `translateX(12%)` — `pulls-confirm-in`'s only travel, as a fraction of the
  /// confirm's own width. *(Measured: 57.6px on the 480px box.)*
  static const double confirmShift = 0.12;

  /// `border-destructive/50` on the inline confirm.
  static const double confirmBorderAlpha = 0.50;

  @override
  State<ElHistoryCard> createState() => _ElHistoryCardState();
}

class _ElHistoryCardState extends State<ElHistoryCard> {
  final TextEditingController _draft = TextEditingController();
  final FocusNode _renameFocus = FocusNode(debugLabel: 'Conversation title');
  final GlobalKey<ElModalPortalState> _alert = GlobalKey<ElModalPortalState>();
  final GlobalKey<ElModalPortalState> _renameDialog =
      GlobalKey<ElModalPortalState>();

  bool _editing = false;
  bool _confirming = false;

  /// The confirm has to outlive its own dismissal for long enough to animate.
  /// Without this it was unmounted on the frame it was dismissed and
  /// `anim-confirm-out` never ran once — a defined animation nothing played.
  bool _closingConfirm = false;
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    _draft.text = widget.conversation.title;
    _renameFocus.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _renameFocus.removeListener(_onFocusChanged);
    _renameFocus.dispose();
    _draft.dispose();
    super.dispose();
  }

  /// `onBlur={() => commit(draft)}`.
  void _onFocusChanged() {
    if (_editing && !_renameFocus.hasFocus) _commit(_draft.text);
  }

  void _commit(String title) {
    final String next = title.trim();
    if (next.isNotEmpty && next != widget.conversation.title) {
      widget.onRename(widget.conversation.id, next);
    }
    if (mounted) setState(() => _editing = false);
    _renameDialog.currentState?.close();
  }

  void _startRename() {
    _draft.text = widget.conversation.title;
    if (widget.rename == ElHistoryRename.dialog) {
      _renameDialog.currentState?.open();
      return;
    }
    setState(() => _editing = true);
    // Select the whole title on entry. A rename almost always replaces rather
    // than appends, and making the user clear it first is a step nobody wants.
    // *(Measured: `selectionStart 0`, `selectionEnd 22`.)*
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _renameFocus.requestFocus();
      _draft.selection = TextSelection(
        baseOffset: 0,
        extentOffset: _draft.text.length,
      );
    });
  }

  void _dismissConfirm() {
    setState(() => _closingConfirm = true);
    Future<void>.delayed(
      elAnimationDuration(context, ElHistoryCard.confirmExit),
      () {
        if (!mounted) return;
        setState(() {
          _confirming = false;
          _closingConfirm = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    final ElConversationSummary c = widget.conversation;

    final Widget row = ElItem(
      variant: ElItemVariant.outline,
      alignStart: true,
      media: ElItemMedia(
        child: ElIcon.lucide(
          widget.active
              ? ElLucide.messageSquareDot
              : c.pinned
              ? ElLucide.pin
              : ElLucide.messageSquare,
          tone: ElIconTone.muted,
        ),
      ),
      content: ElItemContent(
        children: <Widget>[
          SizedBox(
            height: ElHistoryCard.titleHeight,
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: _editing ? _renameField(theme) : _titleButton(theme),
            ),
          ),
          // Everything below the title is inert during a rename — it neither
          // moves nor changes, which is the whole point of the inline form.
          //
          // DRIFT: the call site writes `className="type-caption"` and it never
          // applies. `ItemDescription`'s own `text-sm leading-normal` are
          // utilities and `.type-caption` is `@layer components`, so the
          // utilities win both properties they share. *(Measured 13px/19.5px,
          // not 10.5/14.175.)*
          ElItemDescription(
            c.preview == null
                ? elRelativeTimeOf(context, c.updatedAt)
                : '${elRelativeTimeOf(context, c.updatedAt)} · ${c.preview}',
          ),
        ],
      ),
      actions: ElItemActions(
        children: <Widget>[
          // Pin is promoted out of the menu because it is the one action taken
          // repeatedly and wanted at a glance.
          if (widget.onPin != null)
            _fade(
              visible: c.pinned || _hovered,
              child: ElButton(
                variant: ElButtonVariant.ghost,
                size: ElButtonSize.iconSm,
                label: c.pinned ? 'Unpin conversation' : 'Pin conversation',
                onPressed: () => widget.onPin!(c.id, !c.pinned),
                child: ElIcon.lucide(
                  c.pinned ? ElLucide.pin : ElLucide.pinOff,
                  size: ElIconSize.sm,
                  tone: c.pinned ? ElIconTone.action : ElIconTone.muted,
                ),
              ),
            ),
          // `opacity-0 group-hover/card:opacity-100 focus-visible:opacity-100
          // data-[state=open]:opacity-100` — the third clause is the trigger's
          // alone, which is why this fade reads the open state from inside the
          // trigger while the pin beside it reads only the card's hover.
          ElDropdownMenu(
            align: ElPopoverAlign.end,
            trigger: Builder(
              builder: (BuildContext context) => _fade(
                visible: _hovered || ElMenuTriggerScope.openOf(context),
                child: ElButton(
                  variant: ElButtonVariant.ghost,
                  size: ElButtonSize.iconSm,
                  label: 'Conversation actions',
                  expanded: ElMenuTriggerScope.openOf(context),
                  suppressPressScale: ElDropdownMenu.pressScaleSuppressed,
                  // The press is handled on pointer-down by
                  // [ElMenuPointerDown]; the handler is here only so the
                  // button is not `disabled`, which would take
                  // `pointer-events-none` and `opacity-45` with it. The
                  // corpus's own trigger convention.
                  onPressed: () {},
                  child: const ElIcon.lucide(
                    ElLucide.ellipsis,
                    size: ElIconSize.sm,
                    tone: ElIconTone.muted,
                  ),
                ),
              ),
            ),
            children: <ElMenuChild>[
              if (widget.onShare != null)
                ElMenuItem(
                  label: 'Share',
                  lucideIcon: ElLucide.share2,
                  onSelect: () => widget.onShare!(c.id),
                ),
              ElMenuItem(
                label: 'Rename',
                lucideIcon: ElLucide.pencil,
                onSelect: _startRename,
              ),
              if (widget.onPin != null)
                ElMenuItem(
                  label: c.pinned ? 'Unpin' : 'Pin',
                  lucideIcon: c.pinned ? ElLucide.pinOff : ElLucide.pin,
                  onSelect: () => widget.onPin!(c.id, !c.pinned),
                ),
              const ElMenuSeparator(),
              ElMenuItem(
                label: 'Delete',
                lucideIcon: ElLucide.trash2,
                variant: ElMenuItemVariant.destructive,
                onSelect: () {
                  if (widget.confirm == ElHistoryConfirm.dialog) {
                    _alert.currentState?.open();
                  } else {
                    setState(() => _confirming = true);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );

    // `relative isolate overflow-hidden` is what lets the inline confirm sit
    // over the row instead of pushing it around.
    Widget card = ClipRRect(
      borderRadius: BorderRadius.circular(ElItem.radius),
      child: Stack(
        children: <Widget>[
          row,
          if (widget.confirm == ElHistoryConfirm.inline && _confirming)
            Positioned.fill(child: _inlineConfirm(theme)),
        ],
      ),
    );

    card = MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: card,
    );

    card = ElRowMotion(
      generation: widget.entranceGeneration,
      leaving: widget.leaving,
      child: card,
    );

    // The two overlays are siblings of the row in the reference and portalled
    // out of it in the DOM; here they are zero-sized children of the same
    // subtree, opened through their own state.
    return Stack(
      children: <Widget>[
        card,
        if (widget.confirm == ElHistoryConfirm.dialog) _alertDialog(c),
        _renameDialogPortal(c),
      ],
    );
  }

  /// The reveal transition — `transition: … opacity 0.25s`, the same clock the
  /// button's own list runs *(measured: all six properties at 0.25s)*.
  Widget _fade({required bool visible, required Widget child}) =>
      AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: elAnimationDuration(context, ElDurations.transitionDefault),
        curve: ElCurves.out,
        // `opacity-0` leaves the control in the layout and hit-testable, which
        // is what the reference does too — no `pointer-events` rule joins it.
        child: child,
      );

  Widget _titleButton(ElThemeData theme) => _TapRegion(
    onTap: () => widget.onOpen(widget.conversation.id),
    child: ElText(
      widget.conversation.title,
      ElComponentType.itemTitle,
      color: theme.foreground,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      softWrap: false,
    ),
  );

  /// `h-6 rounded-sm px-1.5 py-0 shadow-none` — 348 × 24 *(measured)*, on
  /// `--card` under `--input`, with no socket at all.
  Widget _renameField(ElThemeData theme) => Shortcuts(
    shortcuts: const <ShortcutActivator, Intent>{
      SingleActivator(LogicalKeyboardKey.escape): DismissIntent(),
    },
    child: Actions(
      actions: <Type, Action<Intent>>{
        DismissIntent: CallbackAction<DismissIntent>(
          // Escape abandons — the draft is dropped, not committed, so the
          // blur that follows must not commit either.
          onInvoke: (_) {
            setState(() => _editing = false);
            return null;
          },
        ),
      },
      child: ElInput(
        controller: _draft,
        focusNode: _renameFocus,
        label: 'Conversation title',
        boxHeight: ElHistoryCard.titleHeight,
        radius: BorderRadius.circular(ElRadii.sm),
        padding: EdgeInsets.symmetric(horizontal: el(1.5)),
        flat: true,
        onSubmitted: _commit,
      ),
    ),
  );

  /// Absolutely positioned over the row rather than pushed into it, so nothing
  /// below reflows while the question is up.
  ///
  /// OPAQUE, not a tint. This was `bg-destructive/8`, which is a wash — the row
  /// underneath showed straight through it and the two sets of words sat on top
  /// of each other. `bg-card` covers, and the destructive signal is carried by
  /// the border and the button, which is where it belongs.
  Widget _inlineConfirm(ElThemeData theme) => _ConfirmSlide(
    closing: _closingConfirm,
    child: Semantics(
      container: true,
      label: 'Delete ${widget.conversation.title}?',
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: el(3)),
        decoration: BoxDecoration(
          color: theme.card,
          borderRadius: BorderRadius.circular(ElItem.radius),
          border: Border.all(
            color: theme.destructive.withValues(
              alpha: ElHistoryCard.confirmBorderAlpha,
            ),
            width: ElWidths.hairline,
          ),
        ),
        child: Row(
          children: <Widget>[
            // Short, because the row is narrow and the buttons beside it
            // are not negotiable. "Delete this conversation?" pushed them
            // off the end of the card.
            Expanded(
              child: ElText(
                'Delete this?',
                ElType.caption,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
              ),
            ),
            SizedBox(width: el(2)),
            ElButton(
              variant: ElButtonVariant.ghost,
              size: ElButtonSize.sm,
              onPressed: _dismissConfirm,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const ElIcon.lucide(ElLucide.x, size: ElIconSize.sm),
                  SizedBox(width: ElButton.gapFor(ElButtonSize.sm)),
                  const Text('Keep'),
                ],
              ),
            ),
            SizedBox(width: el(2)),
            ElButton(
              variant: ElButtonVariant.destructive,
              size: ElButtonSize.sm,
              onPressed: () {
                setState(() => _confirming = false);
                widget.onRemove(widget.conversation.id);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const ElIcon.lucide(ElLucide.check, size: ElIconSize.sm),
                  SizedBox(width: ElButton.gapFor(ElButtonSize.sm)),
                  const Text('Delete'),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );

  /// The same decision, at full screen. Heavier on purpose: the right shape
  /// when deleting is genuinely costly and the wrong one when it is not.
  /// [ElModalPortal] rather than [ElAlertDialog], and the difference is one
  /// line: this overlay is opened from a **menu row**, not from its own
  /// trigger, so the caller needs the portal's [ElModalPortalState] — and a
  /// key on the stateless `ElAlertDialog` wrapper resolves to the wrapper, not
  /// to the portal inside it. Everything else is what that widget passes:
  /// [ElJellyTransition], and *"not dismissible by overlay click"*.
  Widget _alertDialog(ElConversationSummary c) => ElModalPortal(
    key: _alert,
    dismissOnOverlayTap: false,
    transition:
        (BuildContext context, Animation<double> animation, Widget child) =>
            ElJellyTransition(animation: animation, child: child),
    trigger: (BuildContext context, VoidCallback open) =>
        const SizedBox.shrink(),
    content: (BuildContext context, VoidCallback close) => ElAlertDialogContent(
      header: const ElAlertDialogHeader(
        title: ElAlertDialogTitle('Delete this conversation?'),
        description: ElAlertDialogDescription(
          'and everything in it will be removed. This cannot be undone.',
        ),
      ),
      footer: ElAlertDialogFooter(
        cancel: ElAlertDialogCancel(label: 'Keep it', onPressed: close),
        action: ElAlertDialogAction(
          label: 'Delete',
          onPressed: () {
            close();
            widget.onRemove(c.id);
          },
        ),
      ),
    ),
  );

  /// The second way. Worth having when a title is long enough that a row-width
  /// input is cramped, or when renaming is rare enough that finding it beats
  /// doing it quickly.
  Widget _renameDialogPortal(ElConversationSummary c) => ElModalPortal(
    key: _renameDialog,
    transition:
        (BuildContext context, Animation<double> animation, Widget child) =>
            ElJellyTransition(animation: animation, child: child),
    trigger: (BuildContext context, VoidCallback open) =>
        const SizedBox.shrink(),
    content: (BuildContext context, VoidCallback close) => ElDialogContent(
      onClose: close,
      children: <Widget>[
        const ElDialogHeader(
          children: <Widget>[
            ElDialogTitle('Rename conversation'),
            ElDialogDescription(
              'Only the title changes. The conversation itself is untouched.',
            ),
          ],
        ),
        ElField(
          label: 'Title',
          child: ElInput(controller: _draft, onSubmitted: _commit),
        ),
        ElDialogFooter(
          children: <Widget>[
            ElButton(
              variant: ElButtonVariant.outline,
              onPressed: close,
              child: const Text('Cancel'),
            ),
            ElButton(
              onPressed: _draft.text.trim().isEmpty
                  ? null
                  : () => _commit(_draft.text),
              child: const Text('Save'),
            ),
          ],
        ),
      ],
    ),
  );
}

/// `anim-confirm-in` / `anim-confirm-out`.
///
/// In: `opacity 0 → 1` with `translateX(12%) → none` over [ElDurations.fast] on
/// [ElCurves.out]. Out: opacity only, over [ElDurations.tick] on
/// [ElCurves.curveIn] — **no retrace of the slide**, because the row underneath
/// is what the eye should return to and sliding back out drags attention with
/// it.
class _ConfirmSlide extends StatefulWidget {
  const _ConfirmSlide({required this.closing, required this.child});

  final bool closing;
  final Widget child;

  @override
  State<_ConfirmSlide> createState() => _ConfirmSlideState();
}

class _ConfirmSlideState extends State<_ConfirmSlide>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this);

  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    _c.duration = elAnimationDuration(context, ElDurations.fast);
    if (_c.duration == Duration.zero) {
      _c.value = 1;
    } else {
      _c.forward(from: 0);
    }
  }

  @override
  void didUpdateWidget(_ConfirmSlide old) {
    super.didUpdateWidget(old);
    if (old.closing == widget.closing) return;
    _c.duration = elAnimationDuration(context, ElDurations.tick);
    if (_c.duration == Duration.zero) {
      _c.value = 0;
    } else {
      _c.reverse(from: 1);
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _c,
    builder: (BuildContext context, Widget? child) {
      if (widget.closing) {
        return Opacity(
          opacity: ElCurves.curveIn.transform(1 - _c.value) > 0
              ? 1 - ElCurves.curveIn.transform(1 - _c.value)
              : 0,
          child: child,
        );
      }
      final double t = ElCurves.out.transform(_c.value);
      return Opacity(
        opacity: t,
        child: FractionalTranslation(
          translation: Offset(ElHistoryCard.confirmShift * (1 - t), 0),
          child: child,
        ),
      );
    },
    child: widget.child,
  );
}

/// A bare tap target with the pointer cursor a `<button>` gets, and no surface
/// of its own — `className="truncate text-left"` and nothing else.
class _TapRegion extends StatelessWidget {
  const _TapRegion({required this.onTap, required this.child});

  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) => MouseRegion(
    cursor: SystemMouseCursors.click,
    child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: child,
    ),
  );
}

/* ═══════════════════════════════════════════════════════════════════════════
   HistorySearch
   ═══════════════════════════════════════════════════════════════════════════ */

/// Search across every conversation.
///
/// **Recent chats are the empty state.** Opening a search box onto nothing is a
/// dead end — it asks a question before you have one. Opening it onto what you
/// were last working on means the most likely destination is already on screen
/// and the search is only needed for the rest.
///
/// Matching is over title **and preview together**, because the thing people
/// remember about a conversation is usually what they asked, not what it got
/// named afterwards — which is also why [ElCommand.shouldFilter] is off here:
/// cmdk would re-score by the row's own text and drop exactly those matches.
///
/// *(Measured: dialog 384 × 344 at radius 16 on `--popover`, `top-1/3`; command
/// `p-2`; input wrapper 368 × 40; the group 352 × 32; the list capped at 288;
/// rows 352 × 48.7.)*
class ElHistorySearch extends StatefulWidget {
  const ElHistorySearch({
    super.key,
    required this.conversations,
    required this.open,
    required this.onOpenChange,
    required this.onOpen,
    required this.query,
    required this.onQueryChange,
  });

  final List<ElConversationSummary> conversations;
  final bool open;
  final ValueChanged<bool> onOpenChange;
  final void Function(String id) onOpen;

  /// Controlled so the page can drive the specimen.
  final String query;
  final ValueChanged<String> onQueryChange;

  /// `RECENT` — how many recent conversations stand in for a query.
  static const int recent = 6;

  /// `top-1/3 translate-y-0` on the `DialogContent` — the palette rests a third
  /// of the way down rather than centred. *(Measured: top 300 in a 900 frame.)*
  static const double topFraction = 1 / 3;

  /// `${n} match${n === 1 ? "" : "es"}`.
  static String matchHeading(int n) => '$n match${n == 1 ? '' : 'es'}';

  /// The two-key order every list here shares: pinned first, then newest.
  static ({
    List<ElConversationSummary> pinned,
    List<ElConversationSummary> recent,
    List<ElConversationSummary> results,
  })
  partition(List<ElConversationSummary> conversations, String query) {
    final String trimmed = query.trim().toLowerCase();
    final List<ElConversationSummary> byNewest =
        List<ElConversationSummary>.of(conversations)..sort(
          (ElConversationSummary a, ElConversationSummary b) =>
              b.updatedAt.compareTo(a.updatedAt),
        );
    if (trimmed.isEmpty) {
      return (
        pinned: byNewest.where((ElConversationSummary c) => c.pinned).toList(),
        recent: byNewest
            .where((ElConversationSummary c) => !c.pinned)
            .take(ElHistorySearch.recent)
            .toList(),
        results: const <ElConversationSummary>[],
      );
    }
    return (
      pinned: const <ElConversationSummary>[],
      recent: const <ElConversationSummary>[],
      results: byNewest
          .where(
            (ElConversationSummary c) =>
                '${c.title} ${c.preview ?? ''}'.toLowerCase().contains(trimmed),
          )
          .toList(),
    );
  }

  @override
  State<ElHistorySearch> createState() => _ElHistorySearchState();
}

class _ElHistorySearchState extends State<ElHistorySearch> {
  final GlobalKey<ElModalPortalState> _portal = GlobalKey<ElModalPortalState>();
  late final TextEditingController _input = TextEditingController(
    text: widget.query,
  );

  @override
  void initState() {
    super.initState();
    _input.addListener(() {
      if (_input.text != widget.query) widget.onQueryChange(_input.text);
    });
    if (widget.open) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _portal.currentState?.open();
      });
    }
  }

  @override
  void didUpdateWidget(ElHistorySearch old) {
    super.didUpdateWidget(old);
    if (old.open != widget.open) {
      // `open` is a prop and the portal is imperative, so the two have to be
      // reconciled somewhere — and `OverlayPortalController.show()` asserts if
      // it is called during a build, which `didUpdateWidget` is part of.
      final bool wanted = widget.open;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || widget.open != wanted) return;
        if (wanted) {
          _portal.currentState?.open();
        } else {
          _portal.currentState?.close();
        }
      });
    }
    if (widget.query != _input.text) _input.text = widget.query;
  }

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  void _choose(String id) {
    widget.onOpenChange(false);
    widget.onQueryChange('');
    _input.clear();
    widget.onOpen(id);
  }

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    final ({
      List<ElConversationSummary> pinned,
      List<ElConversationSummary> recent,
      List<ElConversationSummary> results,
    })
    split = ElHistorySearch.partition(widget.conversations, widget.query);

    final List<ElCommandGroup> groups = <ElCommandGroup>[
      if (split.pinned.isNotEmpty)
        ElCommandGroup(heading: 'Pinned', items: _rows(split.pinned)),
      if (split.recent.isNotEmpty)
        ElCommandGroup(heading: 'Recent', items: _rows(split.recent)),
      if (split.results.isNotEmpty)
        ElCommandGroup(
          heading: ElHistorySearch.matchHeading(split.results.length),
          items: _rows(split.results),
        ),
    ];

    return ElModalPortal(
      key: _portal,
      transition:
          (BuildContext context, Animation<double> animation, Widget child) =>
              ElJellyTransition(animation: animation, child: child),
      onOpenChange: (bool open) {
        if (!open && widget.open) widget.onOpenChange(false);
      },
      trigger: (BuildContext context, VoidCallback open) =>
          const SizedBox.shrink(),
      content: (BuildContext context, VoidCallback close) => Padding(
        // `top-1/3 translate-y-0` — the content is top-aligned in the theatre
        // and pushed down a third of the viewport, not centred in it.
        padding: EdgeInsets.only(
          top: MediaQuery.sizeOf(context).height * ElHistorySearch.topFraction,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: ElDialogContent.maxWidth),
          child: ElMachineSurface(
            // `p-0` and `showCloseButton={false}`, so nothing of
            // `DialogContent`'s own anatomy survives but the panel: one ring,
            // no elevation, radius 16, `--popover`.
            spec: ElDialogContent.ringSpec,
            radius: BorderRadius.circular(ElDialogContent.radius),
            fill: theme.popover,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(ElDialogContent.radius),
              child: ElCommand(
                inDialog: true,
                shouldFilter: false,
                controller: _input,
                label: 'Search conversations',
                placeholder: 'Search conversations…',
                emptyLabel: 'No conversation matches that.',
                groups: groups,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<ElCommandItem> _rows(List<ElConversationSummary> list) =>
      <ElCommandItem>[
        for (final ElConversationSummary c in list)
          ElCommandItem(
            value: c.id,
            label: c.title,
            subtitle: c.preview,
            meta: elRelativeTimeOf(context, c.updatedAt),
            lucideIcon: c.pinned ? ElLucide.pin : ElLucide.messageSquare,
            iconTone: c.pinned ? ElIconTone.action : ElIconTone.muted,
            onSelect: () => _choose(c.id),
          ),
      ];
}

/* ═══════════════════════════════════════════════════════════════════════════
   ChatHistory
   ═══════════════════════════════════════════════════════════════════════════ */

/// Every conversation this user has had with this agent.
///
/// It is a drawer **inside the console**, not a sheet over the page. A history
/// list belongs to the assistant it is the history of, and portalling it to the
/// body made it take over the whole viewport — dimming a page that has nothing
/// to do with it. Positioned inside the console it reads as the panel turning
/// around to show its back, which is what it is.
///
/// **Capabilities come from the store, not from props.** A pin button appears
/// because `store.pin` exists; a share item appears because `store.share` does.
///
/// The reference is a React fragment — a trigger button plus two absolutely
/// positioned siblings that escape the header they are written in and land
/// against the console's `relative` root. Flutter has no `position: absolute`
/// across a subtree, so the drawer is rendered through an [OverlayPortal] and
/// laid over the rect [surfaceKey] reports. Pass the console root's key; with
/// none, the drawer covers the whole [Overlay], which is the honest fallback
/// and never what a console wants.
class ElChatHistory extends StatefulWidget {
  const ElChatHistory({
    super.key,
    required this.store,
    this.title = 'Conversations',
    this.nav,
    this.onOpenConversation,
    this.surfaceKey,
  });

  final ElConversationStore store;

  /// Shown at the top of the panel. The product's name for this assistant.
  final String title;

  /// Extra navigation rows, rendered under `New chat` and above the
  /// conversations. A slot rather than a fixed list, because what belongs there
  /// is entirely the product's business.
  final List<Widget>? nav;

  /// What a row calls instead of `store.open` — `useBlurSwitch`'s `switchTo`.
  ///
  /// The reference spreads a wired store (`{ ...store, open: switchTo }`) into
  /// the drawer; a Dart `ChangeNotifier` cannot be spread, so the override
  /// arrives as its own prop and defaults to [ElConversationStore.open].
  final void Function(String id)? onOpenConversation;

  /// The box the drawer and its scrim are laid over — the console's own root.
  final GlobalKey? surfaceKey;

  /// `max-w-sm` — 384 *(measured)*.
  static double get width => ElContainers.sm;

  /// `EXIT_MS` — *"must match `--duration-base` in globals.css"*.
  static Duration get exit => ElDurations.base;

  /// `anim-panel-in` — `translateX(-100%) → none` over `--duration-overlay`.
  static Duration get panelIn => ElDurations.overlay;

  @override
  State<ElChatHistory> createState() => _ElChatHistoryState();
}

class _ElChatHistoryState extends State<ElChatHistory> {
  final OverlayPortalController _portal = OverlayPortalController();
  final ElFlipController _flip = ElFlipController();

  bool _open = false;
  bool _searching = false;
  String _query = '';

  /// The row on its way out. A deleted row has to outlive its own deletion for
  /// long enough to animate, so the store call is deferred and the row stays
  /// mounted playing `anim-row-out` until it lands.
  String? _leaving;

  @override
  void dispose() {
    _flip.dispose();
    super.dispose();
  }

  void _setOpen(bool next) {
    if (_open == next) return;
    setState(() => _open = next);
    if (next) {
      _portal.show();
    } else {
      _portal.hide();
    }
  }

  void _remove(String id) {
    setState(() => _leaving = id);
    Future<void>.delayed(elAnimationDuration(context, ElChatHistory.exit), () {
      if (!mounted) return;
      widget.store.remove(id);
      setState(() => _leaving = null);
    });
  }

  void _openConversation(String id) {
    (widget.onOpenConversation ?? widget.store.open)(id);
    _setOpen(false);
  }

  void Function(String, bool)? get _pin {
    final void Function(String, bool)? pin = widget.store.pin;
    if (pin == null) return null;
    // `measure()` runs immediately before the store call so FLIP has a "before"
    // to invert against.
    return (String id, bool pinned) {
      _flip.measure();
      pin(id, pinned);
    };
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        OverlayPortal(
          controller: _portal,
          overlayChildBuilder: _buildDrawer,
          child: ElButton(
            variant: ElButtonVariant.ghost,
            size: ElButtonSize.iconSm,
            label: 'Open sidebar',
            expanded: _open,
            onPressed: () => _setOpen(!_open),
            child: const ElIcon.lucide(ElLucide.panelLeft),
          ),
        ),
        ElHistorySearch(
          conversations: widget.store.conversations,
          open: _searching,
          onOpenChange: (bool v) => setState(() => _searching = v),
          onOpen: _openConversation,
          query: _query,
          onQueryChange: (String v) => setState(() => _query = v),
        ),
      ],
    );
  }

  Rect _surfaceRect(BuildContext context) {
    final RenderObject? overlay = Overlay.of(
      context,
    ).context.findRenderObject();
    final RenderObject? surface = widget.surfaceKey?.currentContext
        ?.findRenderObject();
    if (overlay is! RenderBox || surface is! RenderBox || !surface.hasSize) {
      return Offset.zero & (overlay is RenderBox ? overlay.size : Size.zero);
    }
    return surface.localToGlobal(Offset.zero, ancestor: overlay) & surface.size;
  }

  Widget _buildDrawer(BuildContext context) {
    final Rect rect = _surfaceRect(context);
    return Positioned.fromRect(
      rect: rect,
      // The console clips the drawer at its own edges; the Panel around it
      // clips the corners. Only the first is reproducible from here.
      child: ClipRect(
        child: ListenableBuilder(
          listenable: widget.store,
          builder: (BuildContext context, Widget? _) => Stack(
            children: <Widget>[
              // The dim covers the console and stops at its edges.
              Positioned.fill(
                child: _FadeIn(
                  child: _TapRegion(
                    onTap: () => _setOpen(false),
                    child: ColoredBox(color: ElTheme.of(context).scrim),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                width: rect.width < ElChatHistory.width
                    ? rect.width
                    : ElChatHistory.width,
                child: _PanelIn(child: _drawerBody(context)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawerBody(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    final ElConversationStore store = widget.store;

    /* Pinned first, then newest. Sorting here rather than asking the store for
       it: a store's natural order is whatever its query returned, and every
       store would otherwise have to reimplement the same two-key sort. */
    final List<ElConversationSummary> byNewest =
        List<ElConversationSummary>.of(store.conversations)..sort(
          (ElConversationSummary a, ElConversationSummary b) =>
              b.updatedAt.compareTo(a.updatedAt),
        );
    final List<ElConversationSummary> pinned = byNewest
        .where((ElConversationSummary c) => c.pinned)
        .toList();
    final List<ElConversationSummary> rest = byNewest
        .where((ElConversationSummary c) => !c.pinned)
        .toList();
    _flip.reconcile(<String>[
      for (final ElConversationSummary c in <ElConversationSummary>[
        ...pinned,
        ...rest,
      ])
        c.id,
    ]);

    Widget body = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        // Title, search, collapse. Nothing else — every action that navigates
        // lives in the list below, on the same rail as the conversations it
        // sits with.
        Padding(
          padding: EdgeInsets.all(el(3)),
          child: Row(
            children: <Widget>[
              Expanded(
                child: ElText(
                  widget.title,
                  ElType.section,
                  color: theme.foreground,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: el(1)),
              ElButton(
                variant: ElButtonVariant.ghost,
                size: ElButtonSize.iconSm,
                label: 'Search conversations',
                onPressed: () => setState(() => _searching = true),
                child: const ElIcon.lucide(
                  ElLucide.search,
                  tone: ElIconTone.muted,
                ),
              ),
              SizedBox(width: el(1)),
              ElButton(
                variant: ElButtonVariant.ghost,
                size: ElButtonSize.iconSm,
                label: 'Close sidebar',
                onPressed: () => _setOpen(false),
                child: const ElIcon.lucide(
                  ElLucide.panelLeft,
                  tone: ElIconTone.muted,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(el(3), 0, el(3), el(3)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // `New chat` is a destination like any conversation is, so it
                // sits on the same rail at the same indent rather than floating
                // above as a button — which is what makes the sidebar read as
                // one list instead of a toolbar stacked on a list.
                ElItemGroup(
                  gapOverride: el(0.5),
                  children: <Widget>[
                    _TapRegion(
                      onTap: () {
                        store.create();
                        _setOpen(false);
                      },
                      child: ElItem(
                        media: const ElItemMedia(
                          nudged: false,
                          child: ElIcon.lucide(
                            ElLucide.squarePen,
                            tone: ElIconTone.muted,
                          ),
                        ),
                        content: const ElItemContent(
                          children: <Widget>[ElItemTitle('New chat')],
                        ),
                      ),
                    ),
                    ...?widget.nav,
                  ],
                ),
                if (store.error != null) ...<Widget>[
                  SizedBox(height: el(4)),
                  ElAlert(
                    variant: ElAlertVariant.destructive,
                    icon: const ElIcon.lucide(ElLucide.octagonX),
                    title: 'History is unavailable',
                    description: store.error,
                  ),
                ],
                if (store.error == null &&
                    store.conversations.isEmpty) ...<Widget>[
                  SizedBox(height: el(4)),
                  ElEmpty(
                    children: <Widget>[
                      ElEmptyHeader(
                        children: <Widget>[
                          // `EmptyMedia variant="icon"` takes arbitrary
                          // children here — a Spinner while the store loads —
                          // while [ElEmptyMedia] takes a curated glyph and
                          // nothing else, so the tile is assembled from that
                          // widget's own measurements rather than forked.
                          _EmptyMediaTile(
                            child: store.isLoading
                                ? const ElSpinner()
                                : ElIcon.lucide(
                                    ElLucide.messageSquare,
                                    sizePx: ElEmptyMedia.glyphSize,
                                    strokeOverride: ElEmptyMedia.glyphStroke,
                                    tone: ElIconTone.muted,
                                  ),
                          ),
                          ElEmptyTitle(
                            store.isLoading
                                ? 'Loading conversations'
                                : 'No conversations yet',
                          ),
                          ElEmptyDescription(
                            store.isLoading
                                ? 'Reading them from the store.'
                                : 'Ask the assistant something and it will appear here.',
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
                if (pinned.isNotEmpty) ...<Widget>[
                  SizedBox(height: el(4)),
                  _section(theme, 'Pinned', pinned, store),
                ],
                if (rest.isNotEmpty) ...<Widget>[
                  SizedBox(height: el(4)),
                  _section(
                    theme,
                    pinned.isEmpty ? null : 'Recents',
                    rest,
                    store,
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );

    body = ElMachineSurface(
      spec: ElShadows.e4,
      radius: BorderRadius.zero,
      fill: theme.popover,
      border: Border(
        right: BorderSide(color: theme.border, width: ElWidths.hairline),
      ),
      child: body,
    );

    // Escape closes it, the way a drawer should. Radix gives this for free; an
    // in-container panel has to say so — and it has to STOP there, or the
    // dialog the console lives in closes too and one Escape dismisses the whole
    // assistant.
    return Semantics(
      container: true,
      label: 'Chat history',
      child: Shortcuts(
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.escape): DismissIntent(),
        },
        child: Actions(
          actions: <Type, Action<Intent>>{
            DismissIntent: CallbackAction<DismissIntent>(
              onInvoke: (_) {
                _setOpen(false);
                return null;
              },
            ),
          },
          child: FocusScope(child: body),
        ),
      ),
    );
  }

  Widget _section(
    ElThemeData theme,
    String? heading,
    List<ElConversationSummary> rows,
    ElConversationStore store,
  ) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      if (heading != null) ...<Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: el(1)),
          child: ElText(heading, ElType.section),
        ),
        SizedBox(height: el(2)),
      ],
      ElItemGroup(
        gapOverride: el(1),
        children: <Widget>[
          for (final ElConversationSummary c in rows)
            ElHistoryCard(
              key: _flip.keyFor(c.id),
              conversation: c,
              active: c.id == store.activeId,
              leaving: c.id == _leaving,
              entranceGeneration: _flip.generationOf(c.id),
              onOpen: _openConversation,
              onRename: store.rename,
              onRemove: _remove,
              onPin: _pin,
              onShare: store.share,
            ),
        ],
      ),
    ],
  );
}

/// `anim-fade-in` — `--duration-overlay` on `--ease-out`.
class _FadeIn extends StatefulWidget {
  const _FadeIn({required this.child});

  final Widget child;

  @override
  State<_FadeIn> createState() => _FadeInState();
}

class _FadeInState extends State<_FadeIn> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this);

  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    _c.duration = elAnimationDuration(context, ElDurations.overlay);
    if (_c.duration == Duration.zero) {
      _c.value = 1;
    } else {
      _c.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
    opacity: CurvedAnimation(parent: _c, curve: ElCurves.out),
    child: widget.child,
  );
}

/// `anim-panel-in` — `translateX(-100%) → none` over `--duration-overlay` on
/// `--ease-out`.
class _PanelIn extends StatefulWidget {
  const _PanelIn({required this.child});

  final Widget child;

  @override
  State<_PanelIn> createState() => _PanelInState();
}

class _PanelInState extends State<_PanelIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this);

  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    _c.duration = elAnimationDuration(context, ElChatHistory.panelIn);
    if (_c.duration == Duration.zero) {
      _c.value = 1;
    } else {
      _c.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SlideTransition(
    position: Tween<Offset>(
      begin: const Offset(-1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _c, curve: ElCurves.out)),
    child: widget.child,
  );
}

/// `EmptyMedia variant="icon"` with an arbitrary child.
///
/// The drawer's empty state swaps a [ElSpinner] in while the store loads, and
/// [ElEmptyMedia] takes a curated [ElIconGlyph] and nothing else. Everything
/// about the tile — its box, its radius, its fill and the 8px it holds off the
/// title — is read off that widget rather than restated.
class _EmptyMediaTile extends StatelessWidget {
  const _EmptyMediaTile({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: ElEmptyMedia.marginBottom),
    child: Container(
      width: ElEmptyMedia.box,
      height: ElEmptyMedia.box,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: ElTheme.of(context).muted,
        borderRadius: BorderRadius.circular(ElEmptyMedia.radius),
      ),
      child: child,
    ),
  );
}
