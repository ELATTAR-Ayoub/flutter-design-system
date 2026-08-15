/// `components/ui/skeleton.tsx` — thirty-two lines, one utility, one prop.
///
/// ```tsx
/// <Comp data-slot="skeleton" className={cn("anim-shimmer rounded-md", className)} />
/// ```
///
/// Everything visible is `@utility anim-shimmer` (globals.css L2344–2353):
///
/// ```css
/// background: linear-gradient(90deg, var(--popover) 0%, var(--accent) 50%, var(--popover) 100%);
/// background-size: 200% 100%;
/// animation: pulls-shimmer 1.4s var(--ease-in-out) infinite;
/// ```
///
/// So this file states no motion of its own: [DsShimmer] already carries the
/// table, the tile factor, the two end positions and the theme-resolved
/// gradient, and the motion page already renders it. What is new here is a
/// **widget** — a box of a given size, with the sweep inside it.
///
/// **The geometry is the caller's.** The reference sizes every instance with
/// Tailwind classes (`h-32 w-full`, `size-8 rounded-pill`, `mt-2 h-3.5 w-36`)
/// because *"a skeleton must match the footprint of what it replaces. A generic
/// grey rectangle where a pack card will appear causes a layout jump, which is
/// worse than a spinner."* Twenty-four of them stand on the feedback page in
/// seven distinct shapes, and none of those shapes belongs in this file.
///
/// **The shimmer is a repeating tile, not a single band.** `background-repeat`
/// defaults to `repeat`, which is why the box is never empty at the extremes —
/// see [DsShimmer]'s own note, which also explains why the reduced-motion
/// freeze agrees with motion-map §8.2 even though the two name different
/// numbers.
///
/// Supervisor ruling F2: all twenty-four build and all twenty-four run. The
/// only gate is `dsAnimationDuration`, and there is deliberately no
/// out-of-view pause.
library;

import 'package:flutter/widgets.dart';

import '../foundation/spacing.dart';
import '../foundation/theme.dart';
import '../motion/keyframes.dart';
import '../theme_scope.dart';

/// A shimmering placeholder the size of the thing that is arriving.
class DsSkeleton extends StatelessWidget {
  const DsSkeleton({
    super.key,
    this.width,
    this.height,
    this.radius,
  });

  /// `rounded-md` — 10px, the class list's own default.
  ///
  /// Every instance on the feedback page keeps it except the three pills
  /// (`h-5 w-20 rounded-pill`, `h-5 w-16 rounded-pill`, `size-8 rounded-pill`),
  /// which is what [radius] is for.
  static double get defaultRadius => DsRadii.md;

  /// The box's width, or null to take the incoming constraint (`w-full`).
  final double? width;

  /// The box's height, or null to take the incoming constraint.
  final double? height;

  /// Overrides [defaultRadius] — `rounded-pill` on the three pill placeholders.
  final double? radius;

  /// `as="span"` — the same box as an **inline** placeholder, for a skeleton
  /// standing in for a run of text rather than for a block.
  ///
  /// `skeleton.tsx`'s one prop switches the element to a `<span>` and adds
  /// `inline-block`; the page's single instance pairs that with `align-middle`.
  /// Flutter's inline vocabulary is [WidgetSpan], and
  /// [PlaceholderAlignment.middle] **is** `vertical-align: middle` — both align
  /// the box's centre with the middle of the surrounding lowercase letters.
  ///
  /// Returned as a span rather than as a widget with a flag, because the
  /// difference is not how it paints but where it can be put: `inline-block`
  /// means "this belongs inside a paragraph", and a caller that wanted a box
  /// would just use the constructor.
  static InlineSpan span({double? width, double? height, double? radius}) =>
      WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: DsSkeleton(width: width, height: height, radius: radius),
      );

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius ?? defaultRadius),
        child: DsKeyframePlayer(
          duration: DsShimmer.duration,
          // No `animation-fill-mode`, so a stilled shimmer reverts to stop 0.
          fill: DsShimmer.fill,
          repeat: DsShimmer.loops,
          // A childless [CustomPaint] takes `constraints.smallest`, and the
          // constraints here are whatever the [SizedBox] resolved.
          builder: (BuildContext context, double t, Widget? child) =>
              CustomPaint(
            painter: _ShimmerPainter(t: t, gradient: DsShimmer.gradient(theme)),
          ),
        ),
      ),
    );
  }
}

class _ShimmerPainter extends CustomPainter {
  const _ShimmerPainter({required this.t, required this.gradient});

  final double t;
  final LinearGradient gradient;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    // `background-size: 200% 100%` at the position the table says, drawn as a
    // repeating tile because `background-repeat` defaults to `repeat`.
    final Rect tile = Rect.fromLTWH(
      DsShimmer.offsetAt(t, size.width),
      0,
      DsShimmer.tileWidth(size.width),
      size.height,
    );
    canvas.drawRect(
      Offset.zero & size,
      Paint()..shader = gradient.createShader(tile),
    );
  }

  @override
  bool shouldRepaint(_ShimmerPainter old) =>
      old.t != t || old.gradient != gradient;
}
