/// The travelling selection pill — `components/ui/sliding-indicator.tsx` plus
/// the `slide-pill` utility (`app/globals.css` L2256) and the `yuki-jelly`
/// keyframes (L2431–2438).
///
/// RULES §4: *selection travels, never blinks.* Instead of every option owning
/// a background and one blinking on while another blinks off, the group owns a
/// single pill that physically moves from the old selection to the new one and
/// lands with a squash. You see where the selection went, which is the point.
///
/// Two mechanics matter and both are ported literally:
/// * the pill **measures** rather than guesses, so options of different widths
///   work and a re-layout is followed;
/// * it is **invisible until the first measurement**, and that first placement
///   does not animate — flying in from the left edge on mount looks like a
///   glitch, so the web sets `transition: none` for one frame.
///
/// The arrival squash itself is [DsJelly] — `keyframes.dart` holds the one
/// transcription of `yuki-jelly`, which is also what `.anim-jelly` plays on
/// the motion page. This file used to carry a private second copy of the same
/// six stops; the reference declares them once, and so does the port.
///
/// **The two edges, measured** (behaviour-audit §1.5–1.6, T6–T8b). Both were
/// recorded from before hydration with a `MutationObserver` on the pill's
/// inline style, and both used to be guessed here:
///
/// * **First placement pops in *and* squashes once.** The hook's first `move()`
///   writes `opacity 0→1`, `width 0→W` and the transform **with
///   `transition: none`**, all in a single frame — so nothing fades. Its
///   `isFirstMove` guard then returns before the jelly replay, but the same
///   hook attaches a `ResizeObserver` whose mandatory initial callback fires a
///   *second* `move()` ~117ms later with identical geometry, and that one takes
///   the jelly branch. Net observable behaviour: **no travel, no fade, one
///   squash.** The port used to fade the pill in over 150ms and suppress the
///   squash entirely — both halves inverted.
/// * **Deselection fades in place.** Clicking the selected item writes exactly
///   one style record — `width: 51.89px; height: 32px; transform:
///   translate(74.89px, 0); opacity: 0` — in which width, height and transform
///   are **unchanged from the last selection**. Sampled for 174ms: the rect
///   never moves, only opacity does, over 150ms `--ease-out`, and the jelly
///   stays at 1.000 throughout (`move()` returns in its `!active` branch before
///   reaching the replay). The port used to re-target `left/top/width/height`
///   to `0/0/0/0` — sliding the pill to the group origin under the fade — and
///   to replay a 600ms squash on a pill that was disappearing.
///
/// Everything between those two edges is measured **correct** and is not to be
/// disturbed: 250ms `--ease-spring` travel with a +9.65–9.67% overshoot peaking
/// at Δ168 of 250, width moving in exact lock-step with position (same frame,
/// same curve, same settle — there is no width lag), the 600ms jelly running
/// *concurrently* and outliving the travel by 350ms, per-segment easing inside
/// it, and a re-measure that replays the squash on any resize (the reference's
/// `ResizeObserver` path is not gated by `isFirstMove`, so it replays too).
library;

import 'package:flutter/widgets.dart';

import '../foundation/motion.dart';
import '../theme_scope.dart';
import 'keyframes.dart';

/// Lays [children] out in a row with one travelling [pill] behind them.
///
/// The pill is painted first (so it sits behind), ignores pointers, and takes
/// the exact measured rect of the child at [activeIndex].
class DsSlidingPillGroup extends StatefulWidget {
  const DsSlidingPillGroup({
    super.key,
    required this.activeIndex,
    required this.pill,
    required this.children,
    this.padding = EdgeInsets.zero,
    this.gap = 0,
    this.travelDuration,
  });

  /// The selected child. Out of range — including a deliberate −1 — hides the
  /// pill, which is how the web handles a fully deselected toggle group.
  final int activeIndex;

  /// The pill itself, stretched to the active child's rect. The theme toggle
  /// passes `--card` + `--shadow-e1`; the default in the web component is
  /// `--primary` + `--shadow-chip`.
  final Widget pill;

  final List<Widget> children;

  /// The container's own padding — `p-0.5` on the theme toggle.
  final EdgeInsets padding;

  /// Space between options — `gap-px` on the theme toggle.
  final double gap;

  /// How long the pill takes to reach its new home. `slide-pill`'s own 250ms
  /// on `--ease-spring` when null, which is what the nav rail runs.
  ///
  /// [Duration.zero] makes the move a **snap**, and one call site needs it:
  /// the theme toggle. Clicking an option there flips the theme, and
  /// `next-themes` injects `transition: none !important` on `<html>` for about
  /// 14ms to stop every colour in the document animating at once. The pill's
  /// own transform commits inside that window, so it never travels — measured
  /// on a real theme click. The arrival squash still plays: the class is
  /// re-added in the same batch and runs its full 600ms after the freeze
  /// lifts.
  ///
  /// A `Duration?` rather than a `bool` because what varies is a duration, and
  /// because reduced motion already collapses both legs through
  /// `dsAnimationDuration` below.
  final Duration? travelDuration;

  @override
  State<DsSlidingPillGroup> createState() => _DsSlidingPillGroupState();
}

class _DsSlidingPillGroupState extends State<DsSlidingPillGroup>
    with SingleTickerProviderStateMixin {
  final GlobalKey _frameKey = GlobalKey();
  List<GlobalKey> _itemKeys = <GlobalKey>[];

  /// Every option's rect, in the group's own coordinates. Null until the first
  /// layout has happened — there is nowhere honest to put the pill before it.
  List<Rect>? _rects;

  /// Set once the pill has been placed, which is what makes the *next* move a
  /// travel rather than an appearance — and what keeps the first appearance
  /// from fading, since the reference writes that one with `transition: none`.
  bool _placed = false;

  /// The rect the pill is parked on: the last rect an **active** item had.
  ///
  /// Deselection is the only thing this exists for. The reference's `move()`
  /// writes `opacity: 0` and nothing else when there is no active item, so the
  /// pill keeps the geometry of the selection it is leaving and fades where it
  /// stands. Holding the rect here is that same statement — an
  /// [AnimatedPositioned] whose target never changes has nothing to animate.
  Rect? _held;

  /// The arrival squash. The duration named here is a placeholder for the
  /// first frame only — [build] re-reads it through [dsAnimationDuration] on
  /// every pass, the way `DsPress` does, so reduced motion stills the squash
  /// as well as the travel and the fade.
  late final AnimationController _jelly = AnimationController(
    vsync: this,
    duration: DsDurations.animJelly,
  );

  @override
  void initState() {
    super.initState();
    _syncKeys();
  }

  @override
  void didUpdateWidget(DsSlidingPillGroup old) {
    super.didUpdateWidget(old);
    _syncKeys();
    if (old.activeIndex != widget.activeIndex) _replayJelly();
  }

  @override
  void dispose() {
    _jelly.dispose();
    super.dispose();
  }

  void _syncKeys() {
    if (_itemKeys.length == widget.children.length) return;
    _itemKeys = List<GlobalKey>.generate(
      widget.children.length,
      (int _) => GlobalKey(),
    );
    _rects = null;
    _placed = false;
    _held = null;
  }

  /// Restarts the arrival squash from the top.
  ///
  /// The web does this by removing the class, forcing a reflow, and re-adding
  /// it; `forward(from: 0)` is the same intent. It runs *concurrently* with
  /// the travel, exactly as the CSS animation does — the pill squashes on its
  /// way rather than after it arrives.
  ///
  /// **The one guard is the reference's own.** `move()` returns in its
  /// `!active` branch before it ever reaches the jelly, so a group with nothing
  /// selected does not squash — traced on a real deselection, where the jelly
  /// held 1.000 on every frame while the pill faded (T8b). The *first*
  /// placement is deliberately not guarded any more: the hook's own
  /// `ResizeObserver` re-enters `move()` right after mount and that call does
  /// take the jelly branch, so the reference squashes once on load (T7).
  void _replayJelly() {
    if (_target(_rects) == null) return;
    _jelly.forward(from: 0);
  }

  /// Measures every option against the group, after layout.
  ///
  /// Scheduled after each build, which covers everything the web's
  /// `MutationObserver` + `ResizeObserver` pair covers: a selection change, a
  /// resize, a font swap, a child appearing. It only calls `setState` when a
  /// rect actually moved, so it settles after one extra frame.
  void _measure() {
    if (!mounted) return;
    final RenderObject? frame = _frameKey.currentContext?.findRenderObject();
    if (frame is! RenderBox || !frame.hasSize) return;

    final List<Rect> measured = <Rect>[];
    for (final GlobalKey key in _itemKeys) {
      final RenderObject? box = key.currentContext?.findRenderObject();
      if (box is! RenderBox || !box.hasSize) return;
      measured.add(box.localToGlobal(Offset.zero, ancestor: frame) & box.size);
    }

    if (_rects != null && _listEqual(_rects!, measured)) {
      _placed = _placed || _target(_rects) != null;
      return;
    }

    setState(() => _rects = measured);
    _replayJelly();
  }

  static bool _listEqual(List<Rect> a, List<Rect> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  Rect? _target(List<Rect>? rects) {
    if (rects == null) return null;
    if (widget.activeIndex < 0 || widget.activeIndex >= rects.length) {
      return null;
    }
    return rects[widget.activeIndex];
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
    // `anim-jelly` is an animation like any other: the reference's blanket
    // `prefers-reduced-motion` rule collapses it to 0.01ms along with the
    // travel and the fade below, and this is that rule.
    _jelly.duration = dsAnimationDuration(context, DsDurations.animJelly);

    final Rect? target = _target(_rects);
    if (target != null) _held = target;
    // Deselected, the pill keeps the rect it had — the reference writes only
    // `opacity: 0` and leaves width, height and transform untouched (T8).
    final Rect? rect = target ?? _held;
    final bool travels = _placed;

    return Stack(
      key: _frameKey,
      children: <Widget>[
        AnimatedPositioned(
          // `slide-pill`: transform/width/height 250ms `--ease-spring`.
          duration: travels
              ? dsAnimationDuration(
                  context,
                  widget.travelDuration ?? DsDurations.base,
                )
              : Duration.zero,
          curve: DsCurves.spring,
          left: rect?.left ?? 0,
          top: rect?.top ?? 0,
          width: rect?.width ?? 0,
          height: rect?.height ?? 0,
          child: IgnorePointer(
            child: AnimatedOpacity(
              // `slide-pill`: opacity 150ms `--ease-out`.
              opacity: target == null ? 0 : 1,
              // …except on the first placement, which the hook writes inside a
              // `transition: none` window: the pill pops in rather than fading
              // (T6). The same `_placed` flag gates the travel above, because
              // it is the same one frame of suppressed transition.
              duration: travels
                  ? dsAnimationDuration(context, DsDurations.fast)
                  : Duration.zero,
              curve: DsCurves.out,
              child: AnimatedBuilder(
                animation: _jelly,
                builder: (BuildContext context, Widget? child) {
                  final Offset scale = DsJelly.scale.evaluate(_jelly);
                  return Transform.scale(
                    scaleX: scale.dx,
                    scaleY: scale.dy,
                    child: child,
                  );
                },
                child: widget.pill,
              ),
            ),
          ),
        ),
        Padding(
          padding: widget.padding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for (int i = 0; i < widget.children.length; i++) ...<Widget>[
                if (i > 0) SizedBox(width: widget.gap),
                KeyedSubtree(key: _itemKeys[i], child: widget.children[i]),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
