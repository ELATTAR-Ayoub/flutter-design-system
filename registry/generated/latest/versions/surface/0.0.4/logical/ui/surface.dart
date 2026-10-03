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

import '../../design_system/foundation/shadows.dart';
import '../../design_system/foundation/theme.dart';
import '../../design_system/foundation/theme_scope.dart';

/// Paints a [ShadowStyle] — outer layers *and* inset layers — around and
/// inside [child].
///
/// Painting order reproduces CSS's: fill, then inset shadows, then the border,
/// then content. Getting that order wrong is visible on every outline button:
/// the `inset 0 1px 0 var(--rim)` highlight is a one-pixel line hugging the
/// top inside edge, and it must sit *under* the border, not over it.
class Surface extends StatelessWidget {
  const Surface({
    super.key,
    required this.spec,
    required this.radius,
    this.fill,
    this.border,
    required this.child,
  });

  /// The `--shadow-*` token to paint.
  final ShadowStyle spec;

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
  static Path debugInsetRing(RRect shape, ShadowLayer layer) =>
      _insetRing(shape, layer);

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

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
double _ringReach(ShadowLayer layer) =>
    layer.blur * 2 + layer.spread.abs() + layer.offset.distance + 4;

/// The area an inset [layer] covers inside [shape], as the **pair of rounded
/// rectangles** it actually is: everything inside `outer` except the `hole` —
/// the shape itself, displaced by the layer's offset and shrunk by its spread.
/// Blurring the boundary of that hole is the shadow.
///
/// A null `hole` means a spread wide enough to close it, so the layer covers
/// the whole surface.
///
/// Kept as two rectangles rather than one combined [Path] because that is what
/// [Canvas.drawDRRect] takes, and because a rectangle pair is the shape's own
/// vocabulary — see [_InsetShadowPainter.paint] for why the difference matters.
({RRect outer, RRect? hole}) _insetRingRects(RRect shape, ShadowLayer layer) {
  final RRect outer = RRect.fromRectAndRadius(
    shape.outerRect.inflate(_ringReach(layer)),
    Radius.zero,
  );
  RRect hole = shape.shift(layer.offset);
  if (layer.spread != 0) hole = hole.deflate(layer.spread);
  if (hole.width <= 0 || hole.height <= 0) {
    return (outer: outer, hole: null);
  }
  return (outer: outer, hole: hole);
}

/// [_insetRingRects] as one [Path].
///
/// Derived from the same pair the painter draws, so the region this reports and
/// the region that lands on the canvas cannot drift apart. It is no longer what
/// gets painted — see [_InsetShadowPainter.paint] — and survives because it is
/// how the ring's *geometry* is asserted: which edge a signed `dy` lights, and
/// how far past the shape the ring has to reach.
Path _insetRing(RRect shape, ShadowLayer layer) {
  final ({RRect outer, RRect? hole}) rects = _insetRingRects(shape, layer);
  final Path outer = Path()..addRRect(rects.outer);
  final RRect? hole = rects.hole;
  if (hole == null) return outer;

  return Path.combine(PathOperation.difference, outer, Path()..addRRect(hole));
}

class _InsetShadowPainter extends CustomPainter {
  const _InsetShadowPainter({
    required this.layers,
    required this.radius,
    required this.theme,
  });

  final List<ShadowLayer> layers;
  final BorderRadius radius;
  final ThemeTokens theme;

  /// **Why [Canvas.drawDRRect] and not `drawPath` over a combined path.**
  ///
  /// The ring used to be built with `Path.combine(PathOperation.difference, …)`
  /// and drawn under a [MaskFilter]. On the Dart VM that rasters correctly; on
  /// **CanvasKit it collapses** — the blur fills the entire clip instead of the
  /// band, so every socket interior came out at the layer colours composited at
  /// full coverage rather than at the surface's own fill. Measured on the
  /// inputs page as `#cacace` against a `#ffffff` card, and reproduced in three
  /// Chrome variants — headful, headless, and headless with the capture rig's
  /// flags — against the released bundle. The VM and CanvasKit disagreed about
  /// the same scene, so the scene was the thing to change.
  ///
  /// A ring between two rounded rectangles is a **DRRect**, which Skia has as a
  /// first-class op with its own blur path, rather than a general path it has
  /// to resolve and then mask. Expressing it as what it is rasters the same on
  /// both backends. The geometry is unchanged — [_insetRingRects] is the single
  /// source both this and [_insetRing] read — so nothing about which edge a
  /// layer lights, or how far it reaches, moves.
  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final RRect shape = radius.toRRect(Offset.zero & size);

    canvas.save();
    canvas.clipRRect(shape, doAntiAlias: true);
    // CSS paints the first-listed shadow on top, so the list is walked
    // backwards — the same reversal `ShadowStyle.outerShadows` makes.
    for (final ShadowLayer layer in layers.reversed) {
      final Paint paint = Paint()..color = layer.color(theme);
      // `layer.blurRadius` already un-does Flutter's radius→sigma formula, so
      // putting it back through that formula lands on the CSS sigma exactly:
      // half the declared blur. A zero-blur layer stays a hard edge.
      final double sigma = Shadow.convertRadiusToSigma(layer.blurRadius);
      if (sigma > 0) {
        paint.maskFilter = MaskFilter.blur(BlurStyle.normal, sigma);
      }
      final ({RRect outer, RRect? hole}) rects = _insetRingRects(shape, layer);
      final RRect? hole = rects.hole;
      if (hole == null) {
        // A spread wide enough to close the hole: the layer is the surface.
        canvas.drawRRect(rects.outer, paint);
      } else {
        canvas.drawDRRect(rects.outer, hole, paint);
      }
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_InsetShadowPainter old) =>
      old.theme != theme ||
      old.radius != radius ||
      !listEquals(old.layers, layers);
}
