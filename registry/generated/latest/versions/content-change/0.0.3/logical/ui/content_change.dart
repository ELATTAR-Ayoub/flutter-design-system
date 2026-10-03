/// `@utility anim-content-change` — globals.css L2904–2906.
///
/// ```css
/// @utility anim-content-change {
///   animation: pulls-content-change var(--duration-base) var(--ease-spring) both;
/// }
/// @keyframes pulls-content-change {
///   from { opacity: 0; transform: scale(0.96); }
///   to   { opacity: 1; transform: scale(1); }
/// }
/// ```
///
/// The stylesheet says why it exists:
///
/// > Content replacing content in the same slot — a row becoming its own
/// > rename field, or its own delete confirmation. It springs because the row
/// > is not going anywhere; only its contents changed, and a linear fade makes
/// > that read as a re-render rather than as a state change the user just
/// > caused.
///
/// Two sites on the data page, and they behave differently for the same
/// reason CSS animations behave the way they do:
///
/// * `Stat`'s arriving figure is keyed on the state (`<span key={state}>`), so
///   a `loading → ready` swap unmounts the old node and mounts a new one and
///   the animation runs again. That is what [replayKey] reproduces.
/// * The data table's rows carry the class permanently. Sorting reorders them
///   and React moves the same DOM nodes, so the animation does **not** restart
///   — *(probed: `animation-name` stays `pulls-content-change` across a sort with no
///   new run)*. Those rows pass no [replayKey] and play once, at mount.
///
/// `both` fill means a reduced-motion freeze lands on the **end** frame, which
/// is what [KeyframeFill.both] already gives the player.
library;

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

import '../../design_system/foundation/motion.dart';
import './keyframes.dart';

/// `from { transform: scale(0.96) }`.
const double _fromScale = 0.96;

/// Plays `pulls-content-change` over its child, once per [replayKey].
class ContentChange extends StatelessWidget {
  const ContentChange({super.key, required this.child, this.replayKey});

  final Widget child;

  /// Change it to re-run the animation, exactly as a changed React `key`
  /// remounts the node and restarts the CSS animation.
  final Object? replayKey;

  /// `var(--duration-base)` — 250ms.
  static Duration get duration => MotionDurations.normal;

  /// `var(--ease-spring)`.
  static Curve get curve => MotionCurves.emphasized;

  @override
  Widget build(BuildContext context) => KeyframePlayer(
    key: replayKey == null ? null : ValueKey<Object>(replayKey!),
    duration: duration,
    builder: (BuildContext context, double t, Widget? child) {
      final double eased = curve.transform(t.clamp(0, 1));
      return Opacity(
        opacity: eased.clamp(0, 1),
        child: Transform.scale(
          scale: _fromScale + (1 - _fromScale) * eased,
          child: child,
        ),
      );
    },
    child: child,
  );
}
