/// The overlay entrance and exit — web's `anim-open` / `anim-close`.
///
/// One widget, every overlay: dialog, alert dialog, popover, tooltip, hover
/// card, menu, combobox, select. Forward it plays [OpenMotion] (scale 0.92 →
/// 1.02 → 1 with a 24 → −4 → 0 rise, on `emphasized` over `open`); reversed it
/// plays [CloseMotion] (1 → 1.01 → 0.94, 0 → −4 → 16, on `move` over
/// `normal`). Leaving never takes as long as arriving.
///
/// The sheet and the drawer do NOT use this: a panel that belongs to an edge
/// slides from it (`sheet.dart`, `drawer.dart`), which is component-owned
/// motion, not vocabulary.
library;

import 'package:flutter/widgets.dart';

import 'keyframes.dart';

/* ── Open / close ────────────────────────────────────────────────────────── */

/// [OpenMotion] and [CloseMotion], on one animation.
///
/// Two things a naive lerp would get wrong, and both were confirmed on the
/// trace:
///
///  1. **The easing runs per *segment*, not across the whole animation.** A
///     CSS `animation-timing-function` applies between each pair of
///     keyframes, so the emphasized spring is spent twice on the way in: once
///     over 0→60% and again over 60→100%. Measured: the peak scale 1.02 lands
///     at 252ms, which is 60% of 420 and not the 57% a single spring across
///     the whole run would put it at.
///  2. **Scale precedes translate, so the translate is scaled.** The first
///     frame measures `matrix(0.92, 0, 0, 0.92, 0, 22.08)` — 22.08 is 0.92 x
///     24, not 24. Wrapping the translate *inside* the scale is what
///     reproduces that.
class OpenTransition extends StatelessWidget {
  const OpenTransition({
    super.key,
    required this.animation,
    required this.child,
  });

  final Animation<double> animation;
  final Widget child;

  static double _lerp(double a, double b, double t) => a + (b - a) * t;

  /// The state at [progress] along whichever keyframe list is running.
  ///
  /// [progress] is the animation's own 0→1 for the entrance; for the exit it
  /// is `1 - value`, because [CloseMotion] is a forward animation of its own
  /// and not the entrance reversed. The stop tables themselves live on
  /// [OpenMotion] and [CloseMotion] — this reads them rather than keeping a
  /// private copy.
  static ({double scale, double shift, double opacity}) sample(
    double progress, {
    required bool entering,
  }) {
    final double t = progress.clamp(0.0, 1.0);
    if (entering) {
      final double inBreak = OpenMotion.break_;
      final List<double> inScale = OpenMotion.scaleStops
          .map((KeyframeStop<double> s) => s.value)
          .toList();
      final List<double> inShift = OpenMotion.translateYStops
          .map((KeyframeStop<double> s) => s.value)
          .toList();
      if (t <= inBreak) {
        final double local = OpenMotion.curve.transform(t / inBreak);
        return (
          scale: _lerp(inScale[0], inScale[1], local),
          shift: _lerp(inShift[0], inShift[1], local),
          // `opacity: 0 → 1` over the same first segment.
          opacity: local.clamp(0.0, 1.0),
        );
      }
      final double local = OpenMotion.curve.transform(
        (t - inBreak) / (1 - inBreak),
      );
      return (
        scale: _lerp(inScale[1], inScale[2], local),
        shift: _lerp(inShift[1], inShift[2], local),
        opacity: 1,
      );
    }
    final double outBreak = CloseMotion.break_;
    final List<double> outScale = CloseMotion.scaleStops
        .map((KeyframeStop<double> s) => s.value)
        .toList();
    final List<double> outShift = CloseMotion.translateYStops
        .map((KeyframeStop<double> s) => s.value)
        .toList();
    if (t <= outBreak) {
      final double local = CloseMotion.curve.transform(t / outBreak);
      return (
        scale: _lerp(outScale[0], outScale[1], local),
        shift: _lerp(outShift[0], outShift[1], local),
        opacity: 1,
      );
    }
    final double local = CloseMotion.curve.transform(
      (t - outBreak) / (1 - outBreak),
    );
    return (
      scale: _lerp(outScale[1], outScale[2], local),
      shift: _lerp(outShift[1], outShift[2], local),
      opacity: 1 - local.clamp(0.0, 1.0),
    );
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: animation,
    child: child,
    builder: (BuildContext context, Widget? child) {
      final bool entering = animation.status != AnimationStatus.reverse;
      final ({double scale, double shift, double opacity}) frame = sample(
        entering ? animation.value : 1 - animation.value,
        entering: entering,
      );
      return Opacity(
        opacity: frame.opacity.clamp(0.0, 1.0),
        child: Transform.scale(
          scale: frame.scale,
          // Inside the scale, because `scale() translateY()` scales the
          // translate — see the class doc.
          child: Transform.translate(
            offset: Offset(0, frame.shift),
            child: child,
          ),
        ),
      );
    },
  );
}
