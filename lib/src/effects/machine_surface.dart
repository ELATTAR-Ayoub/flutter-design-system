/// Machine surfaces — the shadow specs CSS can paint and Flutter cannot.
///
/// `--shadow-e1`…`e4` are ordinary drop shadows and go straight into a
/// [BoxDecoration]. The machine family does not: `--shadow-btn`,
/// `--shadow-pressed`, `--shadow-btn-down`, `--shadow-chip` and
/// `--shadow-key-down` all carry `inset` layers, and Flutter has no inset
/// shadow. That is what this file is for — an outline button's inner top rim
/// of light and inner bottom shade are the entire reason it reads as a thing
/// that can be pressed.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../foundation/shadows.dart';
import '../foundation/theme.dart';
import '../theme_scope.dart';

/// Paints a [DsShadowSpec] — outer layers *and* inset layers — around and
/// inside [child].
///
/// Painting order reproduces CSS's: fill, then inset shadows, then the border,
/// then content. Getting that order wrong is visible on every outline button:
/// the `inset 0 1px 0 var(--rim)` highlight is a one-pixel line hugging the
/// top inside edge, and it must sit *under* the border, not over it.
class DsMachineSurface extends StatelessWidget {
  const DsMachineSurface({
    super.key,
    required this.spec,
    required this.radius,
    this.fill,
    this.border,
    required this.child,
  });

  /// The `--shadow-*` token to paint.
  final DsShadowSpec spec;

  /// The shape. Both the outer shadows and the inset clip follow it.
  final BorderRadius radius;

  /// The surface's own `background-color`, if it has one.
  final Color? fill;

  /// The surface's `border`, painted above the inset shadows.
  final BoxBorder? border;

  final Widget child;

  /// The region one inset [layer] darkens inside [shape].
  ///
  /// Exposed for tests: the direction of an inset shadow is decided entirely
  /// by the sign of its `dy`, and it is worth pinning that a positive `dy`
  /// lights the *top* edge rather than the bottom.
  @visibleForTesting
  static Path debugInsetRing(RRect shape, DsShadowLayer layer) =>
      _insetRing(shape, layer);

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);

    Widget content = child;
    if (border != null) {
      content = DecoratedBox(
        decoration: BoxDecoration(border: border, borderRadius: radius),
        // `box-sizing: border-box` — the border is paid for out of the
        // surface's own box, so what is left for the content is the box minus
        // the border on each side. [Container] does this for its callers via
        // `decoration.padding`; [DecoratedBox] does not, so it is done here
        // rather than left for every caller to remember.
        child: Padding(padding: border!.dimensions, child: content),
      );
    }
    if (spec.hasInset) {
      content = CustomPaint(
        painter: _InsetShadowPainter(
          layers: spec.insetLayers,
          radius: radius,
          theme: theme,
        ),
        child: content,
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: fill,
        borderRadius: radius,
        boxShadow: spec.outerShadows(theme),
      ),
      child: content,
    );
  }
}

/// How far past the shape the ring must extend so that its own outer edge —
/// which the blur softens just as much as the inner one — never shows through
/// the clip.
///
/// A Gaussian is spent by three sigma, and `sigma` here is half the CSS blur,
/// so `1.5 × blur` would do; twice the blur is the same reasoning with room to
/// spare. The floor keeps a zero-blur layer's ring from collapsing onto the
/// shape's own edge.
double _ringReach(DsShadowLayer layer) =>
    layer.blur * 2 + layer.spread.abs() + layer.offset.distance + 4;

/// The area an inset [layer] covers inside [shape]: everything except the
/// "hole" — the shape itself, displaced by the layer's offset and shrunk by
/// its spread. Blurring the boundary of that hole is the shadow.
Path _insetRing(RRect shape, DsShadowLayer layer) {
  final Path outer = Path()
    ..addRect(shape.outerRect.inflate(_ringReach(layer)));

  RRect hole = shape.shift(layer.offset);
  if (layer.spread != 0) hole = hole.deflate(layer.spread);
  // A spread wide enough to close the hole fills the whole surface.
  if (hole.width <= 0 || hole.height <= 0) return outer;

  return Path.combine(
    PathOperation.difference,
    outer,
    Path()..addRRect(hole),
  );
}

class _InsetShadowPainter extends CustomPainter {
  const _InsetShadowPainter({
    required this.layers,
    required this.radius,
    required this.theme,
  });

  final List<DsShadowLayer> layers;
  final BorderRadius radius;
  final DsThemeData theme;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final RRect shape = radius.toRRect(Offset.zero & size);

    canvas.save();
    canvas.clipRRect(shape, doAntiAlias: true);
    // CSS paints the first-listed shadow on top, so the list is walked
    // backwards — the same reversal `DsShadowSpec.outerShadows` makes.
    for (final DsShadowLayer layer in layers.reversed) {
      final Paint paint = Paint()..color = layer.color(theme);
      // `layer.blurRadius` already un-does Flutter's radius→sigma formula, so
      // putting it back through that formula lands on the CSS sigma exactly:
      // half the declared blur. A zero-blur layer stays a hard edge.
      final double sigma = Shadow.convertRadiusToSigma(layer.blurRadius);
      if (sigma > 0) {
        paint.maskFilter = MaskFilter.blur(BlurStyle.normal, sigma);
      }
      canvas.drawPath(_insetRing(shape, layer), paint);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_InsetShadowPainter old) =>
      old.theme != theme ||
      old.radius != radius ||
      !listEquals(old.layers, layers);
}
