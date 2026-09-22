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

import '../../design_system/foundation/motion.dart';

/* ── Open / close ────────────────────────────────────────────────────────── */

/// `anim-jelly-in` and `anim-jelly-out`, on one animation.
///
/// ```css
/// @keyframes yuki-jelly-in {
///   0%   { opacity: 0; transform: scale(0.92) translateY(24px); }
///   60%  { opacity: 1; transform: scale(1.02) translateY(-4px); }
///   100% { opacity: 1; transform: scale(1)    translateY(0);    }
/// }
/// @keyframes yuki-jelly-out {
///   0%   { opacity: 1; transform: scale(1)    translateY(0);    }
///   30%  { opacity: 1; transform: scale(1.01) translateY(-4px); }
///   100% { opacity: 0; transform: scale(0.94) translateY(16px); }
/// }
/// ```
///
/// Two things the CSS says that a naive lerp would get wrong, and both were
/// confirmed on the trace:
///
///  1. **The easing runs per *segment*, not across the whole animation.** CSS
///     applies `animation-timing-function` between each pair of keyframes, so
///     `--ease-spring` is spent twice on the way in: once over 0→60% and again
///     over 60→100%. Measured: the peak scale 1.02 lands at 252ms, which is
///     60% of 420 and not the 57% a single spring across the whole run would
///     put it at.
///  2. **`scale()` precedes `translateY()`, so the translate is scaled.** The
///     first frame measures `matrix(0.92, 0, 0, 0.92, 0, 22.08)` — 22.08 is
///     0.92 x 24, not 24. Wrapping the translate *inside* the scale is what
///     reproduces that.
class OpenTransition extends StatelessWidget {
  const OpenTransition({
    super.key,
    required this.animation,
    required this.child,
  });

  final Animation<double> animation;
  final Widget child;

  /// The one keyframe stop `yuki-jelly-in` declares between its ends.
  static const double _inBreak = 0.60;

  /// `yuki-jelly-out`'s.
  static const double _outBreak = 0.30;

  /// The in-keyframes, as (scale, translateY, opacity) at 0 / 60 / 100.
  static const List<double> _inScale = <double>[0.92, 1.02, 1];
  static const List<double> _inShift = <double>[24, -4, 0];

  /// The out-keyframes at 0 / 30 / 100.
  static const List<double> _outScale = <double>[1, 1.01, 0.94];
  static const List<double> _outShift = <double>[0, -4, 16];

  static double _lerp(double a, double b, double t) => a + (b - a) * t;

  /// The state at [progress] along whichever keyframe list is running.
  ///
  /// [progress] is the animation's own 0→1 for the entrance; for the exit it is
  /// `1 - value`, because `yuki-jelly-out` is a forward animation of its own
  /// and not the entrance reversed.
  static ({double scale, double shift, double opacity}) sample(
    double progress, {
    required bool entering,
  }) {
    final double t = progress.clamp(0.0, 1.0);
    if (entering) {
      if (t <= _inBreak) {
        final double local = MotionCurves.emphasized.transform(t / _inBreak);
        return (
          scale: _lerp(_inScale[0], _inScale[1], local),
          shift: _lerp(_inShift[0], _inShift[1], local),
          // `opacity: 0 → 1` over the same first segment.
          opacity: local.clamp(0.0, 1.0),
        );
      }
      final double local = MotionCurves.emphasized.transform(
        (t - _inBreak) / (1 - _inBreak),
      );
      return (
        scale: _lerp(_inScale[1], _inScale[2], local),
        shift: _lerp(_inShift[1], _inShift[2], local),
        opacity: 1,
      );
    }
    if (t <= _outBreak) {
      final double local = MotionCurves.move.transform(t / _outBreak);
      return (
        scale: _lerp(_outScale[0], _outScale[1], local),
        shift: _lerp(_outShift[0], _outShift[1], local),
        opacity: 1,
      );
    }
    final double local = MotionCurves.move.transform(
      (t - _outBreak) / (1 - _outBreak),
    );
    return (
      scale: _lerp(_outScale[1], _outScale[2], local),
      shift: _lerp(_outShift[1], _outShift[2], local),
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
