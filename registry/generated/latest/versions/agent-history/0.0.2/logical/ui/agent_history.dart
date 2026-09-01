/// `components/agent/parts/{history-card,chat-history,history-search}.tsx` —
/// every conversation the user has had with this agent.
///
/// Three widgets and one helper, in the reference's own split:
///
///  * [HistoryCard] decides what a conversation *can do* and what each of
///    those actions looks like. Built on [Item], not beside it — a history
///    row is a list row, and `Item` already owns the border, the radius, the
///    padding, the gap and the colour transition.
///  * [ChatHistory] *arranges*. It is a drawer inside the console, not a
///    sheet over the page, and it reads every capability off the store.
///  * [HistorySearch] is a palette rather than a filter box, because the list
///    lives inside a console inside a dialog and the thing being searched for
///    is a sentence.
///  * [FlipController] is `core/use-flip.ts` — and the reason it paints
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
/// the running maximum of the old indices already placed. [FlipController]
/// ports that rule and bumps [FlipController.generationOf] for that row, so
/// the port paints what the reference paints — a teleport, plus one neighbour
/// replaying its entrance — and [FlipController.travel] keeps the inversion
/// that was computed and discarded, so a test can pin the drift rather than
/// take it on trust.
library;

import 'dart:ui' as ui;

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
import 'package:flutter/widgets.dart' as flutter show OverlayPortal;

import './surface.dart';
import '../../design_system/foundation/motion.dart';
import '../../design_system/foundation/shadows.dart';
import '../../design_system/foundation/spacing.dart';
import '../../design_system/foundation/theme.dart';
import '../../design_system/foundation/typography.dart';
import '../../design_system/foundation/theme_scope.dart';
import './agent_core.dart';
import './alert.dart';
import './alert_dialog.dart';
import './button.dart';
import './command.dart';
import './dialog.dart';
import './dropdown_menu.dart';
import './empty.dart';
import './field.dart';
import './icon.dart';
import './icon_paths.g.dart';
import './input.dart';
import './item.dart';
import './menu.dart';
import './popover.dart';
import './spinner.dart';

/* ═══════════════════════════════════════════════════════════════════════════
   Row motion — `anim-row-in`, `anim-row-out`, `anim-blur-*`
   ═══════════════════════════════════════════════════════════════════════════ */

/// `anim-row-in` / `anim-row-out`, the two utilities every editable list in the
/// system shares.
///
/// * in — `pulls-row-in`: `opacity 0 → 1`, `translateX(-10px) → none`, over
///   [MotionDurations.normal] on [MotionCurves.enter], after an
///   `animation-delay: calc(--duration-tick + var(--row-index, 0) *
///   --duration-tick / 2)`. **Nothing on this page sets `--row-index`**, so the
///   delay is a flat 80ms on every row *(measured: `animationDelay: 0.08s` on
///   all seven)* and the list does not stagger.
/// * out — `pulls-row-out`: opacity and a −24px slide over the first 45%, then
///   the box collapses its own height to zero over the rest, all on
///   [MotionCurves.move]. One movement, so the rows below rise into the gap
///   instead of snapping shut after it.
///
/// [generation] replays the entrance when it changes — see the library note on
/// which row that is and why.
class RowMotion extends StatefulWidget {
  const RowMotion({
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
  /// [MotionDurations.tick]. It rides the curve rather than a timer because
  /// `animation-fill-mode: both` means the delay is *part of the animation* —
  /// the backwards fill holds the `from` keyframe through it — and because a
  /// pending [Timer] outlives a widget test that never advances the clock.
  static Duration get enterSpan =>
      MotionDurations.tick + MotionDurations.normal;

  /// Where the delay ends inside [enterSpan].
  static double get enterDelayFraction =>
      MotionDurations.tick.inMicroseconds / enterSpan.inMicroseconds;

  /// The whole of `anim-row-in`: hold, then `pulls-row-in` on `--ease-out`.
  static Curve get enterCurve =>
      Interval(enterDelayFraction, 1, curve: MotionCurves.enter);

  @override
  State<RowMotion> createState() => _RowMotionState();
}

class _RowMotionState extends State<RowMotion> with TickerProviderStateMixin {
  late final AnimationController _enter = AnimationController(
    vsync: this,
    duration: RowMotion.enterSpan,
  );
  late final AnimationController _exit = AnimationController(
    vsync: this,
    duration: MotionDurations.normal,
  );

  /// `effectiveMotionDuration` reads the ambient `disableAnimations`, which is an
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
    final Duration span = effectiveMotionDuration(context, RowMotion.enterSpan);
    _enter.duration = span;
    if (span == Duration.zero) {
      _enter.value = 1;
      return;
    }
    _enter.forward(from: 0);
  }

  @override
  void didUpdateWidget(RowMotion old) {
    super.didUpdateWidget(old);
    if (old.generation != widget.generation) _play();
    if (old.leaving != widget.leaving) {
      _exit
        ..duration = effectiveMotionDuration(context, MotionDurations.normal)
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
              MotionCurves.move.transform(t.clamp(0, 1)) / RowMotion.exitBreak;
          final double a = slide.clamp(0, 1);
          final double collapse = t <= RowMotion.exitBreak
              ? 1
              : 1 -
                    ((MotionCurves.move.transform(t) - RowMotion.exitBreak) /
                            (1 - RowMotion.exitBreak))
                        .clamp(0, 1);
          return Align(
            alignment: Alignment.topCenter,
            heightFactor: collapse,
            child: Opacity(
              opacity: 1 - a,
              child: Transform.translate(
                offset: Offset(RowMotion.exitShift * a, 0),
                child: child,
              ),
            ),
          );
        }
        // `animation-fill-mode: both` — the backwards fill is why the row is
        // not painted at full opacity for the 80ms before its delay ends.
        final double t = RowMotion.enterCurve.transform(_enter.value);
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(RowMotion.enterShift * (1 - t), 0),
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
///   [MotionDurations.fast] on [MotionCurves.exit].
/// * `anim-blur-in` — `opacity 0 → 1`, `blur(8px) → blur(0)`, over
///   [MotionDurations.normal] on [MotionCurves.settle].
///
/// *(Measured end to end: `pulls-blur-out` from t≈112 to 374, `pulls-blur-in`
/// from 374 to ≈586 — 150 out, 250 in, ≈475ms of wall clock including the
/// click-to-first-frame latency.)*
///
/// A CSS `blur(r)` radius is twice the Gaussian σ Flutter's [ui.ImageFilter]
/// takes, which is why the two constants below are halved at the call.
class BlurSwitch extends StatefulWidget {
  const BlurSwitch({super.key, required this.phase, required this.child});

  final SwitchPhase phase;
  final Widget child;

  /// `blur(6px)` — where `pulls-blur-out` ends.
  // allow-hardcoded: a keyframe filter radius from globals.css L3357; the
  // `--blur-*` scale does not carry it.
  static const double outRadius = 6;

  /// `blur(8px)` — where `pulls-blur-in` starts.
  // allow-hardcoded: globals.css L3360, same reason as [outRadius].
  static const double inRadius = 8;

  @override
  State<BlurSwitch> createState() => _BlurSwitchState();
}

class _BlurSwitchState extends State<BlurSwitch>
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
  void didUpdateWidget(BlurSwitch old) {
    super.didUpdateWidget(old);
    if (old.phase != widget.phase) _restart();
  }

  void _restart() {
    final Duration d = switch (widget.phase) {
      SwitchPhase.idle => Duration.zero,
      SwitchPhase.out => MotionDurations.fast,
      SwitchPhase.blurIn => MotionDurations.normal,
    };
    _c.duration = effectiveMotionDuration(context, d);
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
    if (widget.phase == SwitchPhase.idle) return widget.child;
    return AnimatedBuilder(
      animation: _c,
      builder: (BuildContext context, Widget? child) {
        final bool out = widget.phase == SwitchPhase.out;
        final double t = (out ? MotionCurves.exit : MotionCurves.settle)
            .transform(_c.value.clamp(0, 1));
        final double opacity = out ? 1 - t : t;
        final double radius = out
            ? BlurSwitch.outRadius * t
            : BlurSwitch.inRadius * (1 - t);
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
class FlipController extends ChangeNotifier {
  FlipController({this.duration = MotionDurations.normal});

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
      // entrance once through [RowMotion.initState] rather than through a
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
enum HistoryConfirm { inline, dialog }

/// `HistoryCardProps['rename']`.
enum HistoryRename { inline, dialog }

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
class HistoryCard extends StatefulWidget {
  const HistoryCard({
    super.key,
    required this.conversation,
    required this.onOpen,
    required this.onRename,
    required this.onRemove,
    this.active = false,
    this.confirm = HistoryConfirm.inline,
    this.rename = HistoryRename.inline,
    this.onPin,
    this.onShare,
    this.leaving = false,
    this.entranceGeneration = 0,
  });

  final ConversationSummary conversation;

  /// The conversation the console is showing. Marked by its **glyph**, not by
  /// its surface: a tinted row competed with the pinned section it might be in
  /// and with the destructive confirm that covers it, and three overlapping
  /// colour states on one row is one too many to read at a glance.
  final bool active;

  final HistoryConfirm confirm;
  final HistoryRename rename;

  final void Function(String id) onOpen;
  final void Function(String id, String title) onRename;
  final void Function(String id) onRemove;

  /// Omitted when the store cannot pin. The affordance goes with it.
  final void Function(String id, bool pinned)? onPin;

  /// Omitted when the store cannot share.
  final void Function(String id)? onShare;

  /// Set while this row plays its exit. The list owns the timing.
  final bool leaving;

  /// [FlipController.generationOf] for this row — replays `anim-row-in`.
  final int entranceGeneration;

  /// `CONFIRM_EXIT_MS` — matches `anim-confirm-out`, `--duration-tick`.
  static Duration get confirmExit => MotionDurations.tick;

  /// `EXIT_MS` in `chat-history.tsx` — *"must match `--duration-base`"*.
  static Duration get rowExit => MotionDurations.normal;

  /// `h-6` on `ItemTitle`, in both states — what stops a rename moving the
  /// timestamp beneath it by a single pixel.
  static double get titleHeight => space(6);

  /// `translateX(12%)` — `pulls-confirm-in`'s only travel, as a fraction of the
  /// confirm's own width. *(Measured: 57.6px on the 480px box.)*
  static const double confirmShift = 0.12;

  /// `border-destructive/50` on the inline confirm.
  static const double confirmBorderAlpha = 0.50;

  @override
  State<HistoryCard> createState() => _HistoryCardState();
}

class _HistoryCardState extends State<HistoryCard> {
  final TextEditingController _draft = TextEditingController();
  final FocusNode _renameFocus = FocusNode(debugLabel: 'Conversation title');
  final GlobalKey<OverlayPortalState> _alert = GlobalKey<OverlayPortalState>();
  final GlobalKey<OverlayPortalState> _renameDialog =
      GlobalKey<OverlayPortalState>();

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
    if (widget.rename == HistoryRename.dialog) {
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
      effectiveMotionDuration(context, HistoryCard.confirmExit),
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
    final ThemeTokens theme = ThemeScope.of(context);
    final ConversationSummary c = widget.conversation;

    final Widget row = Item(
      variant: ItemVariant.outline,
      alignStart: true,
      media: ItemMedia(
        child: Icon.lucide(
          widget.active
              ? Lucide.messageSquareDot
              : c.pinned
              ? Lucide.pin
              : Lucide.messageSquare,
          tone: IconTone.muted,
        ),
      ),
      content: ItemContent(
        children: <Widget>[
          SizedBox(
            height: HistoryCard.titleHeight,
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
          ItemDescription(
            c.preview == null
                ? relativeTimeOf(context, c.updatedAt)
                : '${relativeTimeOf(context, c.updatedAt)} · ${c.preview}',
          ),
        ],
      ),
      actions: ItemActions(
        children: <Widget>[
          // Pin is promoted out of the menu because it is the one action taken
          // repeatedly and wanted at a glance.
          if (widget.onPin != null)
            _fade(
              visible: c.pinned || _hovered,
              child: Button(
                variant: ButtonVariant.ghost,
                size: ButtonSize.iconSm,
                label: c.pinned ? 'Unpin conversation' : 'Pin conversation',
                onPressed: () => widget.onPin!(c.id, !c.pinned),
                child: Icon.lucide(
                  c.pinned ? Lucide.pin : Lucide.pinOff,
                  size: IconSize.sm,
                  tone: c.pinned ? IconTone.action : IconTone.muted,
                ),
              ),
            ),
          // `opacity-0 group-hover/card:opacity-100 focus-visible:opacity-100
          // data-[state=open]:opacity-100` — the third clause is the trigger's
          // alone, which is why this fade reads the open state from inside the
          // trigger while the pin beside it reads only the card's hover.
          DropdownMenu(
            align: PopoverAlign.end,
            trigger: Builder(
              builder: (BuildContext context) => _fade(
                visible: _hovered || MenuTriggerScope.openOf(context),
                child: Button(
                  variant: ButtonVariant.ghost,
                  size: ButtonSize.iconSm,
                  label: 'Conversation actions',
                  expanded: MenuTriggerScope.openOf(context),
                  suppressPressScale: DropdownMenu.pressScaleSuppressed,
                  // The press is handled on pointer-down by
                  // [MenuPointerDown]; the handler is here only so the
                  // button is not `disabled`, which would take
                  // `pointer-events-none` and `opacity-45` with it. The
                  // corpus's own trigger convention.
                  onPressed: () {},
                  child: const Icon.lucide(
                    Lucide.ellipsis,
                    size: IconSize.sm,
                    tone: IconTone.muted,
                  ),
                ),
              ),
            ),
            children: <MenuChild>[
              if (widget.onShare != null)
                MenuItem(
                  label: 'Share',
                  lucideIcon: Lucide.share2,
                  onSelect: () => widget.onShare!(c.id),
                ),
              MenuItem(
                label: 'Rename',
                lucideIcon: Lucide.pencil,
                onSelect: _startRename,
              ),
              if (widget.onPin != null)
                MenuItem(
                  label: c.pinned ? 'Unpin' : 'Pin',
                  lucideIcon: c.pinned ? Lucide.pinOff : Lucide.pin,
                  onSelect: () => widget.onPin!(c.id, !c.pinned),
                ),
              const MenuSeparator(),
              MenuItem(
                label: 'Delete',
                lucideIcon: Lucide.trash2,
                variant: MenuItemVariant.destructive,
                onSelect: () {
                  if (widget.confirm == HistoryConfirm.dialog) {
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
      borderRadius: BorderRadius.circular(Item.radius),
      child: Stack(
        children: <Widget>[
          row,
          if (widget.confirm == HistoryConfirm.inline && _confirming)
            Positioned.fill(child: _inlineConfirm(theme)),
        ],
      ),
    );

    card = MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: card,
    );

    card = RowMotion(
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
        if (widget.confirm == HistoryConfirm.dialog) _alertDialog(c),
        _renameDialogPortal(c),
      ],
    );
  }

  /// The reveal transition — `transition: … opacity 0.25s`, the same clock the
  /// button's own list runs *(measured: all six properties at 0.25s)*.
  Widget _fade({required bool visible, required Widget child}) =>
      AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: effectiveMotionDuration(context, MotionDurations.normal),
        curve: MotionCurves.enter,
        // `opacity-0` leaves the control in the layout and hit-testable, which
        // is what the reference does too — no `pointer-events` rule joins it.
        child: child,
      );

  Widget _titleButton(ThemeTokens theme) => _TapRegion(
    onTap: () => widget.onOpen(widget.conversation.id),
    child: StyledText(
      widget.conversation.title,
      TextStyles.body,
      color: theme.foreground,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      softWrap: false,
    ),
  );

  /// `h-6 rounded-sm px-1.5 py-0 shadow-none` — 348 × 24 *(measured)*, on
  /// `--card` under `--input`, with no socket at all.
  Widget _renameField(ThemeTokens theme) => Shortcuts(
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
      child: Input(
        controller: _draft,
        focusNode: _renameFocus,
        label: 'Conversation title',
        boxHeight: HistoryCard.titleHeight,
        radius: BorderRadius.circular(Radii.sm),
        padding: EdgeInsets.symmetric(horizontal: space(1.5)),
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
  Widget _inlineConfirm(ThemeTokens theme) => _ConfirmSlide(
    closing: _closingConfirm,
    child: Semantics(
      container: true,
      label: 'Delete ${widget.conversation.title}?',
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: space(3)),
        decoration: BoxDecoration(
          color: theme.card,
          borderRadius: BorderRadius.circular(Item.radius),
          border: Border.all(
            color: theme.destructive.withValues(
              alpha: HistoryCard.confirmBorderAlpha,
            ),
            width: BorderWidths.hairline,
          ),
        ),
        child: Row(
          children: <Widget>[
            // Short, because the row is narrow and the buttons beside it
            // are not negotiable. "Delete this conversation?" pushed them
            // off the end of the card.
            Expanded(
              child: StyledText(
                'Delete this?',
                TextStyles.small,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
              ),
            ),
            SizedBox(width: space(2)),
            Button(
              variant: ButtonVariant.ghost,
              size: ButtonSize.sm,
              onPressed: _dismissConfirm,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon.lucide(Lucide.x, size: IconSize.sm),
                  SizedBox(width: Button.gapFor(ButtonSize.sm)),
                  const Text('Keep'),
                ],
              ),
            ),
            SizedBox(width: space(2)),
            Button(
              variant: ButtonVariant.destructive,
              size: ButtonSize.sm,
              onPressed: () {
                setState(() => _confirming = false);
                widget.onRemove(widget.conversation.id);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon.lucide(Lucide.check, size: IconSize.sm),
                  SizedBox(width: Button.gapFor(ButtonSize.sm)),
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
  /// [OverlayPortal] rather than [AlertDialog], and the difference is one
  /// line: this overlay is opened from a **menu row**, not from its own
  /// trigger, so the caller needs the portal's [OverlayPortalState] — and a
  /// key on the stateless `AlertDialog` wrapper resolves to the wrapper, not
  /// to the portal inside it. Everything else is what that widget passes:
  /// [OpenTransition], and *"not dismissible by overlay click"*.
  Widget _alertDialog(ConversationSummary c) => OverlayPortal(
    key: _alert,
    dismissOnOverlayTap: false,
    transition:
        (BuildContext context, Animation<double> animation, Widget child) =>
            OpenTransition(animation: animation, child: child),
    trigger: (BuildContext context, VoidCallback open) =>
        const SizedBox.shrink(),
    content: (BuildContext context, VoidCallback close) => AlertDialogContent(
      header: const AlertDialogHeader(
        title: AlertDialogTitle('Delete this conversation?'),
        description: AlertDialogDescription(
          'and everything in it will be removed. This cannot be undone.',
        ),
      ),
      footer: AlertDialogFooter(
        cancel: AlertDialogCancel(label: 'Keep it', onPressed: close),
        action: AlertDialogAction(
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
  Widget _renameDialogPortal(ConversationSummary c) => OverlayPortal(
    key: _renameDialog,
    transition:
        (BuildContext context, Animation<double> animation, Widget child) =>
            OpenTransition(animation: animation, child: child),
    trigger: (BuildContext context, VoidCallback open) =>
        const SizedBox.shrink(),
    content: (BuildContext context, VoidCallback close) => DialogContent(
      onClose: close,
      children: <Widget>[
        const DialogHeader(
          children: <Widget>[
            DialogTitle('Rename conversation'),
            DialogDescription(
              'Only the title changes. The conversation itself is untouched.',
            ),
          ],
        ),
        Field(
          label: 'Title',
          child: Input(controller: _draft, onSubmitted: _commit),
        ),
        DialogFooter(
          children: <Widget>[
            Button(
              variant: ButtonVariant.outline,
              onPressed: close,
              child: const Text('Cancel'),
            ),
            Button(
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
/// In: `opacity 0 → 1` with `translateX(12%) → none` over [MotionDurations.fast] on
/// [MotionCurves.enter]. Out: opacity only, over [MotionDurations.tick] on
/// [MotionCurves.exit] — **no retrace of the slide**, because the row underneath
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
    _c.duration = effectiveMotionDuration(context, MotionDurations.fast);
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
    _c.duration = effectiveMotionDuration(context, MotionDurations.tick);
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
          opacity: MotionCurves.exit.transform(1 - _c.value) > 0
              ? 1 - MotionCurves.exit.transform(1 - _c.value)
              : 0,
          child: child,
        );
      }
      final double t = MotionCurves.enter.transform(_c.value);
      return Opacity(
        opacity: t,
        child: FractionalTranslation(
          translation: Offset(HistoryCard.confirmShift * (1 - t), 0),
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
/// named afterwards — which is also why [Command.shouldFilter] is off here:
/// cmdk would re-score by the row's own text and drop exactly those matches.
///
/// *(Measured: dialog 384 × 344 at radius 16 on `--popover`, `top-1/3`; command
/// `p-2`; input wrapper 368 × 40; the group 352 × 32; the list capped at 288;
/// rows 352 × 48.7.)*
class HistorySearch extends StatefulWidget {
  const HistorySearch({
    super.key,
    required this.conversations,
    required this.open,
    required this.onOpenChange,
    required this.onOpen,
    required this.query,
    required this.onQueryChange,
  });

  final List<ConversationSummary> conversations;
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
    List<ConversationSummary> pinned,
    List<ConversationSummary> recent,
    List<ConversationSummary> results,
  })
  partition(List<ConversationSummary> conversations, String query) {
    final String trimmed = query.trim().toLowerCase();
    final List<ConversationSummary> byNewest =
        List<ConversationSummary>.of(conversations)..sort(
          (ConversationSummary a, ConversationSummary b) =>
              b.updatedAt.compareTo(a.updatedAt),
        );
    if (trimmed.isEmpty) {
      return (
        pinned: byNewest.where((ConversationSummary c) => c.pinned).toList(),
        recent: byNewest
            .where((ConversationSummary c) => !c.pinned)
            .take(HistorySearch.recent)
            .toList(),
        results: const <ConversationSummary>[],
      );
    }
    return (
      pinned: const <ConversationSummary>[],
      recent: const <ConversationSummary>[],
      results: byNewest
          .where(
            (ConversationSummary c) =>
                '${c.title} ${c.preview ?? ''}'.toLowerCase().contains(trimmed),
          )
          .toList(),
    );
  }

  @override
  State<HistorySearch> createState() => _HistorySearchState();
}

class _HistorySearchState extends State<HistorySearch> {
  final GlobalKey<OverlayPortalState> _portal = GlobalKey<OverlayPortalState>();
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
  void didUpdateWidget(HistorySearch old) {
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
    final ThemeTokens theme = ThemeScope.of(context);
    final ({
      List<ConversationSummary> pinned,
      List<ConversationSummary> recent,
      List<ConversationSummary> results,
    })
    split = HistorySearch.partition(widget.conversations, widget.query);

    final List<CommandGroup> groups = <CommandGroup>[
      if (split.pinned.isNotEmpty)
        CommandGroup(heading: 'Pinned', items: _rows(split.pinned)),
      if (split.recent.isNotEmpty)
        CommandGroup(heading: 'Recent', items: _rows(split.recent)),
      if (split.results.isNotEmpty)
        CommandGroup(
          heading: HistorySearch.matchHeading(split.results.length),
          items: _rows(split.results),
        ),
    ];

    return OverlayPortal(
      key: _portal,
      transition:
          (BuildContext context, Animation<double> animation, Widget child) =>
              OpenTransition(animation: animation, child: child),
      onOpenChange: (bool open) {
        if (!open && widget.open) widget.onOpenChange(false);
      },
      trigger: (BuildContext context, VoidCallback open) =>
          const SizedBox.shrink(),
      content: (BuildContext context, VoidCallback close) => Padding(
        // `top-1/3 translate-y-0` — the content is top-aligned in the theatre
        // and pushed down a third of the viewport, not centred in it.
        padding: EdgeInsets.only(
          top: MediaQuery.sizeOf(context).height * HistorySearch.topFraction,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: DialogContent.maxWidth),
          child: Surface(
            // `p-0` and `showCloseButton={false}`, so nothing of
            // `DialogContent`'s own anatomy survives but the panel: one ring,
            // no elevation, radius 16, `--popover`.
            spec: DialogContent.ringSpec,
            radius: BorderRadius.circular(DialogContent.radius),
            fill: theme.popover,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(DialogContent.radius),
              child: Command(
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

  List<CommandItem> _rows(List<ConversationSummary> list) => <CommandItem>[
    for (final ConversationSummary c in list)
      CommandItem(
        value: c.id,
        label: c.title,
        subtitle: c.preview,
        meta: relativeTimeOf(context, c.updatedAt),
        lucideIcon: c.pinned ? Lucide.pin : Lucide.messageSquare,
        iconTone: c.pinned ? IconTone.action : IconTone.muted,
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
class ChatHistory extends StatefulWidget {
  const ChatHistory({
    super.key,
    required this.store,
    this.title = 'Conversations',
    this.nav,
    this.onOpenConversation,
    this.surfaceKey,
  });

  final ConversationStore store;

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
  /// arrives as its own prop and defaults to [ConversationStore.open].
  final void Function(String id)? onOpenConversation;

  /// The box the drawer and its scrim are laid over — the console's own root.
  final GlobalKey? surfaceKey;

  /// `max-w-sm` — 384 *(measured)*.
  static double get width => Containers.sm;

  /// `EXIT_MS` — *"must match `--duration-base` in globals.css"*.
  static Duration get exit => MotionDurations.normal;

  /// `anim-panel-in` — `translateX(-100%) → none` over `--duration-overlay`.
  static Duration get panelIn => MotionDurations.overlayEnter;

  @override
  State<ChatHistory> createState() => _ChatHistoryState();
}

class _ChatHistoryState extends State<ChatHistory> {
  final OverlayPortalController _portal = OverlayPortalController();
  final FlipController _flip = FlipController();

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
    Future<void>.delayed(
      effectiveMotionDuration(context, ChatHistory.exit),
      () {
        if (!mounted) return;
        widget.store.remove(id);
        setState(() => _leaving = null);
      },
    );
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
        flutter.OverlayPortal(
          controller: _portal,
          overlayChildBuilder: _buildDrawer,
          child: Button(
            variant: ButtonVariant.ghost,
            size: ButtonSize.iconSm,
            label: 'Open sidebar',
            expanded: _open,
            onPressed: () => _setOpen(!_open),
            child: const Icon.lucide(Lucide.panelLeft),
          ),
        ),
        HistorySearch(
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
                    child: ColoredBox(color: ThemeScope.of(context).scrim),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                width: rect.width < ChatHistory.width
                    ? rect.width
                    : ChatHistory.width,
                child: _PanelIn(child: _drawerBody(context)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawerBody(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final ConversationStore store = widget.store;

    /* Pinned first, then newest. Sorting here rather than asking the store for
       it: a store's natural order is whatever its query returned, and every
       store would otherwise have to reimplement the same two-key sort. */
    final List<ConversationSummary> byNewest =
        List<ConversationSummary>.of(store.conversations)..sort(
          (ConversationSummary a, ConversationSummary b) =>
              b.updatedAt.compareTo(a.updatedAt),
        );
    final List<ConversationSummary> pinned = byNewest
        .where((ConversationSummary c) => c.pinned)
        .toList();
    final List<ConversationSummary> rest = byNewest
        .where((ConversationSummary c) => !c.pinned)
        .toList();
    _flip.reconcile(<String>[
      for (final ConversationSummary c in <ConversationSummary>[
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
          padding: EdgeInsets.all(space(3)),
          child: Row(
            children: <Widget>[
              Expanded(
                child: StyledText(
                  widget.title,
                  TextStyles.small,
                  color: theme.foreground,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: space(1)),
              Button(
                variant: ButtonVariant.ghost,
                size: ButtonSize.iconSm,
                label: 'Search conversations',
                onPressed: () => setState(() => _searching = true),
                child: const Icon.lucide(Lucide.search, tone: IconTone.muted),
              ),
              SizedBox(width: space(1)),
              Button(
                variant: ButtonVariant.ghost,
                size: ButtonSize.iconSm,
                label: 'Close sidebar',
                onPressed: () => _setOpen(false),
                child: const Icon.lucide(
                  Lucide.panelLeft,
                  tone: IconTone.muted,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(space(3), 0, space(3), space(3)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // `New chat` is a destination like any conversation is, so it
                // sits on the same rail at the same indent rather than floating
                // above as a button — which is what makes the sidebar read as
                // one list instead of a toolbar stacked on a list.
                ItemGroup(
                  gapOverride: space(0.5),
                  children: <Widget>[
                    _TapRegion(
                      onTap: () {
                        store.create();
                        _setOpen(false);
                      },
                      child: Item(
                        media: const ItemMedia(
                          nudged: false,
                          child: Icon.lucide(
                            Lucide.squarePen,
                            tone: IconTone.muted,
                          ),
                        ),
                        content: const ItemContent(
                          children: <Widget>[ItemTitle('New chat')],
                        ),
                      ),
                    ),
                    ...?widget.nav,
                  ],
                ),
                if (store.error != null) ...<Widget>[
                  SizedBox(height: space(4)),
                  Alert(
                    variant: AlertVariant.destructive,
                    icon: const Icon.lucide(Lucide.octagonX),
                    title: 'History is unavailable',
                    description: store.error,
                  ),
                ],
                if (store.error == null &&
                    store.conversations.isEmpty) ...<Widget>[
                  SizedBox(height: space(4)),
                  Empty(
                    children: <Widget>[
                      EmptyHeader(
                        children: <Widget>[
                          // `EmptyMedia variant="icon"` takes arbitrary
                          // children here — a Spinner while the store loads —
                          // while [EmptyMedia] takes a curated glyph and
                          // nothing else, so the tile is assembled from that
                          // widget's own measurements rather than forked.
                          _EmptyMediaTile(
                            child: store.isLoading
                                ? const Spinner()
                                : Icon.lucide(
                                    Lucide.messageSquare,
                                    sizePx: EmptyMedia.glyphSize,
                                    strokeOverride: EmptyMedia.glyphStroke,
                                    tone: IconTone.muted,
                                  ),
                          ),
                          EmptyTitle(
                            store.isLoading
                                ? 'Loading conversations'
                                : 'No conversations yet',
                          ),
                          EmptyDescription(
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
                  SizedBox(height: space(4)),
                  _section(theme, 'Pinned', pinned, store),
                ],
                if (rest.isNotEmpty) ...<Widget>[
                  SizedBox(height: space(4)),
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

    body = Surface(
      spec: Shadows.xl,
      radius: BorderRadius.zero,
      fill: theme.popover,
      border: Border(
        right: BorderSide(color: theme.border, width: BorderWidths.hairline),
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
    ThemeTokens theme,
    String? heading,
    List<ConversationSummary> rows,
    ConversationStore store,
  ) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      if (heading != null) ...<Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: space(1)),
          child: StyledText(heading, TextStyles.small),
        ),
        SizedBox(height: space(2)),
      ],
      ItemGroup(
        gapOverride: space(1),
        children: <Widget>[
          for (final ConversationSummary c in rows)
            HistoryCard(
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
    _c.duration = effectiveMotionDuration(
      context,
      MotionDurations.overlayEnter,
    );
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
    opacity: CurvedAnimation(parent: _c, curve: MotionCurves.enter),
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
    _c.duration = effectiveMotionDuration(context, ChatHistory.panelIn);
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
    ).animate(CurvedAnimation(parent: _c, curve: MotionCurves.enter)),
    child: widget.child,
  );
}

/// `EmptyMedia variant="icon"` with an arbitrary child.
///
/// The drawer's empty state swaps a [Spinner] in while the store loads, and
/// [EmptyMedia] takes a curated [IconGlyph] and nothing else. Everything
/// about the tile — its box, its radius, its fill and the 8px it holds off the
/// title — is read off that widget rather than restated.
class _EmptyMediaTile extends StatelessWidget {
  const _EmptyMediaTile({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: EmptyMedia.marginBottom),
    child: Container(
      width: EmptyMedia.box,
      height: EmptyMedia.box,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: ThemeScope.of(context).muted,
        borderRadius: BorderRadius.circular(EmptyMedia.radius),
      ),
      child: child,
    ),
  );
}
