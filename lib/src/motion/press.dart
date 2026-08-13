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
/// Put this on anything clickable that is not a `DsButton` — the logo, a chip,
/// a nav row, a theme-toggle option.
class DsPress extends StatefulWidget {
  const DsPress({
    super.key,
    this.scale = DsTransforms.pressScale,
    required this.child,
    this.onTap,
    this.behavior = HitTestBehavior.opaque,
  });

  /// The `:active` scale. Defaults to the `press` utility's 0.94; `DsButton`
  /// passes [DsTransforms.buttonScale], `click-spring` surfaces 0.9.
  final double scale;

  final Widget child;

  /// Optional tap handling, so a pressable surface does not need a second
  /// gesture widget wrapped around it.
  final VoidCallback? onTap;

  final HitTestBehavior behavior;

  @override
  State<DsPress> createState() => _DsPressState();
}

class _DsPressState extends State<DsPress> with SingleTickerProviderStateMixin {
  /// 0 at rest, 1 fully pressed. The asymmetry lives in the two durations.
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: DsDurations.pressDown,
    reverseDuration: DsDurations.base,
  );

  /// `--ease-spring` in both directions.
  ///
  /// The reverse curve is *flipped*, not reused: CSS runs its timing function
  /// forward in real time whichever way a property is transitioning, while a
  /// reversing [AnimationController] would otherwise play the easing
  /// backwards and turn the spring's overshoot into a lag.
  late final Animation<double> _progress = CurvedAnimation(
    parent: _controller,
    curve: DsCurves.spring,
    reverseCurve: DsCurves.spring.flipped,
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
    _controller.duration =
        dsAnimationDuration(context, DsDurations.pressDown);
    _controller.reverseDuration =
        dsAnimationDuration(context, DsDurations.base);

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
