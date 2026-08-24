/// The click feel — the `press` utility, `app/globals.css` L2274–2285.
///
/// ```css
/// @utility press {
///   transition: transform var(--duration-base) var(--ease-spring);
///   &:active { transform: scale(0.94); transition-duration: 40ms; }
/// }
/// ```
///
/// Its comment names the thesis: *"Instant squish in, springy jelly return
/// out. The asymmetry is the point: 40ms down, 250ms spring back."*
library;

import 'package:flutter/widgets.dart';

import '../foundation/motion.dart';
import '../theme_scope.dart';

/// Squishes [child] while a pointer is down on it.
///
/// Put this on anything clickable that is not a `ElButton` — the logo, a chip,
/// a nav row, a theme-toggle option.
class ElPress extends StatefulWidget {
  const ElPress({
    super.key,
    this.scale = ElTransforms.pressScale,
    required this.child,
    this.onTap,
    this.behavior = HitTestBehavior.opaque,
    this.downDuration = ElDurations.pressDown,
    this.upDuration = ElDurations.base,
  });

  /// The `:active` scale. Defaults to the `press` utility's 0.94; `ElButton`
  /// passes [ElTransforms.buttonScale], `click-spring` surfaces 0.9.
  final double scale;

  /// How long the squish takes. `press` and its two siblings all use 40ms;
  /// `btn-spring` — what a `ElButton` wears — uses `--duration-tick`, 80ms.
  final Duration downDuration;

  /// How long the spring back takes. `--duration-base` for every utility in
  /// the family.
  final Duration upDuration;

  final Widget child;

  /// Optional tap handling, so a pressable surface does not need a second
  /// gesture widget wrapped around it.
  final VoidCallback? onTap;

  final HitTestBehavior behavior;

  @override
  State<ElPress> createState() => _ElPressState();
}

class _ElPressState extends State<ElPress> with SingleTickerProviderStateMixin {
  /// 0 at rest, 1 fully pressed. The asymmetry lives in the two durations.
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: ElDurations.pressDown,
    reverseDuration: ElDurations.base,
  );

  /// `--ease-spring` in both directions.
  ///
  /// The reverse curve is *flipped*, not reused: CSS runs its timing function
  /// forward in real time whichever way a property is transitioning, while a
  /// reversing [AnimationController] would otherwise play the easing
  /// backwards and turn the spring's overshoot into a lag.
  late final Animation<double> _progress = CurvedAnimation(
    parent: _controller,
    curve: ElCurves.spring,
    reverseCurve: ElCurves.spring.flipped,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _down(PointerDownEvent _) => _controller.forward();
  void _release([PointerEvent? _]) => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    _controller.duration = elAnimationDuration(context, widget.downDuration);
    _controller.reverseDuration = elAnimationDuration(
      context,
      widget.upDuration,
    );

    Widget result = Listener(
      onPointerDown: _down,
      onPointerUp: _release,
      onPointerCancel: _release,
      behavior: widget.behavior,
      child: AnimatedBuilder(
        animation: _progress,
        builder: (BuildContext context, Widget? child) => Transform.scale(
          // The spring overshoots past 1, which is what carries the scale a
          // hair beyond its target and back — do not clamp it.
          scale: 1 + (widget.scale - 1) * _progress.value,
          child: child,
        ),
        child: widget.child,
      ),
    );

    if (widget.onTap != null) {
      result = GestureDetector(
        onTap: widget.onTap,
        behavior: widget.behavior,
        child: result,
      );
    }
    return result;
  }
}
