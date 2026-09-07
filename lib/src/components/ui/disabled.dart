/// The one way a control in this system goes disabled.
///
/// Sixteen components used to hand-roll `Opacity(SurfaceOpacity.disabled)`
/// around an `IgnorePointer`, and four of them forgot one half. This widget is
/// the shared `.disabled` class: the fade, the pointer block, the cursor, the
/// reason tooltip and the tap hook live here and nowhere else.
library;

import 'package:flutter/foundation.dart' show clampDouble;
import 'package:flutter/widgets.dart';

import '../../design_system/foundation/motion.dart';
import '../../design_system/foundation/surfaces.dart';
import '../../design_system/foundation/theme_scope.dart';
import './tooltip.dart';

class Disabled extends StatelessWidget {
  const Disabled({
    super.key,
    required this.disabled,
    required this.child,
    this.reason,
    this.onDisabledTap,
    this.blockPointer = true,
    this.duration,
  });

  final bool disabled;
  final Widget child;

  /// Why the control is disabled. Shown as a tooltip on hover (pointer) or
  /// tap (touch) while [disabled]; null shows nothing.
  final String? reason;

  /// Called when a pointer taps the disabled control. Fires only while
  /// [disabled]; the child never sees the tap.
  final VoidCallback? onDisabledTap;

  /// Whether the child stops receiving pointer input while disabled.
  /// Menu rows that gate input themselves pass false.
  final bool blockPointer;

  /// How long the fade takes; null uses [MotionDurations.fast]. Button passes
  /// its own measured spring.
  final Duration? duration;

  @override
  Widget build(BuildContext context) {
    Widget result = TweenAnimationBuilder<double>(
      tween: Tween<double>(end: disabled ? SurfaceOpacity.disabled : 1),
      duration: effectiveMotionDuration(context, duration ?? MotionDurations.fast),
      curve: MotionCurves.emphasized,
      builder: (BuildContext context, double value, Widget? child) => Opacity(
        // The spring overshoots past 1 on the way back; CSS clamps opacity to
        // 0..1 for its used value and so do we.
        opacity: clampDouble(value, 0, 1),
        child: child,
      ),
      child: IgnorePointer(ignoring: disabled && blockPointer, child: child),
    );

    if (!disabled) return result;

    result = MouseRegion(
      cursor: SystemMouseCursors.basic,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onDisabledTap,
        child: result,
      ),
    );

    final String? label = reason;
    if (label == null || label.isEmpty) return result;
    return Tooltip(label: label, child: result);
  }
}
