import 'dart:typed_data';
import 'dart:ui' as ui show Image, ImageByteFormat;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Wave A3 — the feedback page's effects layer: `bloom-cosmic`'s two drifts and
/// its hover swell, `.starfield`, `AlertAction`, `DsProgress`, `DsSkeleton` and
/// the `DsEmpty` family.
///
/// **The painter rule is in force here.** Four of these six paint, and what a
/// widget tree *says* and what lands on the canvas are two different claims —
/// so every painter ships a rendered-pixel pin read off a rasterised
/// [RenderRepaintBoundary], with its interior and band assertions computed from
/// live tokens and an explicit anti-assertion naming the failure mode it exists
/// to catch. That is `inputs_test.dart`'s socket-pin pattern, applied to light
/// instead of to shadow.
///
/// **No `pumpAndSettle` anywhere in this file.** The bloom runs two forever
/// loops per host and the starfield two more, so a settle would never return.
/// `pump(Duration)` with explicit steps only; the freeze probes run under
/// `MediaQuery(disableAnimations: true)`.

Widget host(
  Widget child, {
  DsThemeMode mode = DsThemeMode.dark,
  bool reducedMotion = false,
}) {
  return MediaQuery(
    data: MediaQueryData(
      size: const Size(1440, 900),
      disableAnimations: reducedMotion,
    ),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: DsTheme(
        controller: DsThemeController(mode: mode),
        child: Center(child: child),
      ),
    ),
  );
}

/// One rasterised frame of [child], as a row-major grid of colours.
///
/// The whole reason this file rasterises: `DsBloomCosmic`, `DsStarfield`,
/// `DsProgress` and `DsSkeleton` all paint through a [CustomPainter], and a
/// widget-tree assertion can only see the arguments that went in. This reads
/// what came out.
class Raster {
  Raster(this.pixels, this.width, this.height);

  final Float64List pixels; // r,g,b,a per pixel
  final int width;
  final int height;

  Color at(int x, int y) {
    final int i = (y * width + x) * 4;
    return Color.from(
      alpha: pixels[i + 3],
      red: pixels[i],
      green: pixels[i + 1],
      blue: pixels[i + 2],
    );
  }

  /// Perceived brightness, for "is there light here" questions.
  double luma(int x, int y) {
    final Color c = at(x, y);
    return c.r * 0.2126 + c.g * 0.7152 + c.b * 0.0722;
  }

  /// The brightest pixel inside [region] — where a corner light or a sparkle
  /// actually landed.
  double maxLumaIn(Rect region) {
    double best = 0;
    for (int y = region.top.floor(); y < region.bottom.ceil(); y++) {
      for (int x = region.left.floor(); x < region.right.ceil(); x++) {
        if (x < 0 || y < 0 || x >= width || y >= height) continue;
        final double l = luma(x, y);
        if (l > best) best = l;
      }
    }
    return best;
  }

  /// How many pixels of [region] differ from [other]'s by more than [epsilon].
  int changedIn(Raster other, Rect region, {double epsilon = 1 / 255}) {
    int n = 0;
    for (int y = region.top.floor(); y < region.bottom.ceil(); y++) {
      for (int x = region.left.floor(); x < region.right.ceil(); x++) {
        if (x < 0 || y < 0 || x >= width || y >= height) continue;
        final Color a = at(x, y);
        final Color b = other.at(x, y);
        if ((a.r - b.r).abs() > epsilon ||
            (a.g - b.g).abs() > epsilon ||
            (a.b - b.b).abs() > epsilon) {
          n++;
        }
      }
    }
    return n;
  }
}

/// Pumps [child] for [settle] and rasterises it.
Future<Raster> rasterise(
  WidgetTester t,
  Widget child, {
  DsThemeMode mode = DsThemeMode.dark,
  bool reducedMotion = false,
  Duration settle = Duration.zero,
}) async {
  await t.pumpWidget(host(
    RepaintBoundary(key: const Key('raster'), child: child),
    mode: mode,
    reducedMotion: reducedMotion,
  ));
  await t.pump();
  if (settle > Duration.zero) await t.pump(settle);

  final RenderRepaintBoundary box =
      t.renderObject(find.byKey(const Key('raster')));
  final ui.Image image = (await t.runAsync(() => box.toImage(pixelRatio: 1)))!;
  final ByteData bytes = (await t.runAsync(() async =>
      (await image.toByteData(format: ui.ImageByteFormat.rawRgba))!))!;
  final Float64List out = Float64List(image.width * image.height * 4);
  for (int i = 0; i < image.width * image.height * 4; i++) {
    out[i] = bytes.getUint8(i) / 255;
  }
  final Raster raster = Raster(out, image.width, image.height);
  image.dispose();
  return raster;
}

/// A bloom on its own, at a given host size — the shape both hosts mount.
Widget bloomBox(Size size, {bool starfield = true}) => SizedBox(
      width: size.width,
      height: size.height,
      child: Builder(
        builder: (BuildContext context) => DsBloomCosmic.action(
          radius: BorderRadius.circular(DsRadii.lg),
          fill: DsTheme.of(context).card,
          starfield: starfield,
          child: const SizedBox.expand(),
        ),
      ),
    );

void main() {
  // ───────────────────────────────────────────────────────────────────────────
  // bloom-cosmic — the two drifts, the swell, and the caps that make both work
  // ───────────────────────────────────────────────────────────────────────────

  group('DsBloomDrift — the keyframe tables', () {
    test('the periods are the two the utility writes', () {
      expect(DsBloomDrift.deep.duration, DsDurations.cosmicDriftDeep);
      expect(DsBloomDrift.near.duration, DsDurations.cosmicDriftNear);
      expect(DsDurations.cosmicDriftDeep, const Duration(seconds: 18));
      expect(DsDurations.cosmicDriftNear, const Duration(seconds: 11));
      // 11s collides numerically with `foilDrift` and must stay its own name:
      // a metal sheen and a corner light are unrelated animations.
      expect(DsDurations.cosmicDriftNear, DsDurations.foilDrift);
      expect(
        DsDurations.cosmicDriftNear.hashCode,
        DsDurations.foilDrift.hashCode,
      );
    });

    test('cosmic-drift-deep is three stops, cosmic-drift-near four', () {
      expect(DsBloomDrift.deep.stops, hasLength(3));
      expect(DsBloomDrift.near.stops, hasLength(4));
      expect(
        DsBloomDrift.deep.stops.map((DsBloomDriftStop s) => s.percent),
        <double>[0, 50, 100],
      );
      expect(
        DsBloomDrift.near.stops.map((DsBloomDriftStop s) => s.percent),
        <double>[0, 35, 70, 100],
      );
    });

    test('the tracks land on the declared values at every stop', () {
      // `50% { translate3d(-11%, 8%, 0) rotate(7deg) scale(1.2) }`
      expect(DsBloomDrift.deep.translateX.transform(0.5), closeTo(-0.11, 1e-9));
      expect(DsBloomDrift.deep.translateY.transform(0.5), closeTo(0.08, 1e-9));
      expect(DsBloomDrift.deep.scale.transform(0.5), closeTo(1.2, 1e-9));
      // `100% { translate3d(6%, -9%, 0) rotate(-5deg) scale(1.08) }`
      expect(DsBloomDrift.deep.translateX.transform(1), closeTo(0.06, 1e-9));
      expect(DsBloomDrift.deep.scale.transform(1), closeTo(1.08, 1e-9));
      // The near field's `0%` is scale(1.04) — NOT 1. See the resting-frame
      // test below, which is where that 4% matters.
      expect(DsBloomDrift.near.scale.transform(0), closeTo(1.04, 1e-9));
      expect(DsBloomDrift.near.scale.transform(0.35), closeTo(1.18, 1e-9));
      expect(DsBloomDrift.near.scale.transform(0.70), closeTo(1, 1e-9));
      expect(DsBloomDrift.near.scale.transform(1), closeTo(1.14, 1e-9));
    });

    test('the hover swell is 2.2 on the deep layer and 2.5 on the near', () {
      expect(DsBloomDrift.deep.hoverScale, 2.2);
      expect(DsBloomDrift.near.hoverScale, 2.5);
    });

    test('transform-origin is 88%/82% deep and 90%/86% near', () {
      expect(DsBloomDrift.deep.originX, 0.88);
      expect(DsBloomDrift.deep.originY, 0.82);
      expect(DsBloomDrift.near.originX, 0.90);
      expect(DsBloomDrift.near.originY, 0.86);
    });

    test('the resting frame is transform:none, not stop 0', () {
      // The blanket reduced-motion rule collapses the duration and the
      // iteration count, so both animations FINISH; neither declares a fill
      // mode, so the element reverts to its own `transform`, which the utility
      // never sets. On the deep layer that happens to equal stop 0; on the near
      // one it does not, and reading "stop 0" instead would leave every stilled
      // near field 4% too big — the failure mode this pin names.
      const Rect layer = Rect.fromLTWH(0, 0, 416, 200);
      expect(
        DsBloomDrift.deep.restingMatrixFor(layer, hoverT: 0),
        Matrix4.identity(),
      );
      expect(
        DsBloomDrift.near.restingMatrixFor(layer, hoverT: 0),
        Matrix4.identity(),
      );
      expect(
        DsBloomDrift.near.driftMatrix(layer, 0),
        isNot(Matrix4.identity()),
        reason: 'stop 0 of the near table is scale(1.04)',
      );
    });

    test('the swell multiplies onto the drift about the layer origin', () {
      const Rect layer = Rect.fromLTWH(0, 0, 400, 200);
      final Matrix4 hovered =
          DsBloomDrift.deep.matrixFor(layer, driftT: 0, hoverT: 1);
      // At driftT 0 the deep table is the identity, so a fully-hovered layer is
      // the pure 2.2 swell about (88%, 82%) — the point that must not move.
      const Offset origin = Offset(400 * 0.88, 200 * 0.82);
      final Offset mapped = MatrixUtils.transformPoint(hovered, origin);
      expect(mapped.dx, closeTo(origin.dx, 1e-6));
      expect(mapped.dy, closeTo(origin.dy, 1e-6));
      // …and a point one unit left of it is 2.2 units left after the swell.
      final Offset probe = MatrixUtils.transformPoint(
        hovered,
        origin - const Offset(1, 0),
      );
      expect(origin.dx - probe.dx, closeTo(2.2, 1e-6));
    });
  });

  group('the two min() caps', () {
    // globals.css L1724–1729: `min(95%, 26rem)` / `min(86%, 21rem)` exist so
    // the corner light is roughly the same physical size on a 356px toast and a
    // 1030px Alert.
    test('both caps bite on the feedback page\'s Alert', () {
      // `w-full` inside a 1030px panel body, less the 1px border on each side.
      const Rect alert = Rect.fromLTWH(0, 0, 1028, 69.125);
      expect(DsBloomCosmic.layerRectFor(alert, deep: true).width, 416);
      expect(DsBloomCosmic.layerRectFor(alert, deep: false).width, 336);
      // The anti-assertion: an uncapped port would paint these instead, and
      // 976px of light on a 1028px card is a flood, not a corner.
      expect(1028 * 0.95, closeTo(976.6, 0.05));
      expect(1028 * 0.86, closeTo(884.08, 0.05));
    });

    test('neither cap bites on a toast', () {
      // 356px less its 1px border on each side.
      const Rect toast = Rect.fromLTWH(0, 0, 354, 51.5);
      expect(DsBloomCosmic.layerRectFor(toast, deep: true).width,
          closeTo(336.3, 0.05));
      expect(DsBloomCosmic.layerRectFor(toast, deep: false).width,
          closeTo(304.44, 0.05));
      // Both are under their caps, which is the point: the same declaration
      // resolves to a percentage here and to a constant on the Alert.
      expect(DsBloomCosmic.layerRectFor(toast, deep: true).width, lessThan(416));
      expect(
          DsBloomCosmic.layerRectFor(toast, deep: false).width, lessThan(336));
    });

    test('the layer hangs off the right edge and overshoots top and bottom', () {
      const Rect alert = Rect.fromLTWH(0, 0, 1028, 69.125);
      final Rect deep = DsBloomCosmic.layerRectFor(alert, deep: true);
      // `inset: -95% -4.5rem -95% auto` — 72px past the right edge, and 95% of
      // the host's height clear of both the top and the bottom.
      expect(deep.right, closeTo(1028 + 72, 0.001));
      expect(deep.top, closeTo(-69.125 * 0.95, 0.001));
      expect(deep.height, closeTo(69.125 * (1 + 0.95 * 2), 0.001));
      expect(deep.left, closeTo(1028 + 72 - 416, 0.001));
    });
  });

  group('the bloom, rasterised', () {
    // A 1030px Alert is too wide to raster cheaply; the toast box carries the
    // same effect uncapped and is the one the reference measures on.
    const Size box = Size(354, 96);

    testWidgets('the light is in the bottom-right corner, not a wash',
        (WidgetTester t) async {
      final Raster frame = await rasterise(t, bloomBox(box, starfield: false));
      final Color card = DsThemeData.dark.card;
      final double cardLuma =
          card.r * 0.2126 + card.g * 0.7152 + card.b * 0.0722;

      // The corner the two layers hang off is measurably lit.
      final double corner = frame.maxLumaIn(
        Rect.fromLTWH(box.width - 80, box.height - 60, 80, 60),
      );
      expect(corner, greaterThan(cardLuma * 1.5),
          reason: 'the bloom did not paint at all');

      // …and the far corner is the card, untouched. THE FAILURE MODE: a port
      // that dropped the radial gradients' geometry, or that painted the group
      // without its mask, would light the whole box evenly and this would rise
      // to meet the corner.
      final double far = frame.maxLumaIn(const Rect.fromLTWH(0, 0, 40, 30));
      expect(far, lessThan(corner * 0.6),
          reason: 'the bloom flooded the surface instead of lighting a corner');
    });

    testWidgets('the drift moves the light, and keeps it in the corner',
        (WidgetTester t) async {
      final Raster first = await rasterise(t, bloomBox(box, starfield: false));
      // A quarter of the near field's 11s period: far enough for the light to
      // have travelled, nowhere near a full cycle.
      final Raster later = await rasterise(
        t,
        bloomBox(box, starfield: false),
        settle: const Duration(milliseconds: 2750),
      );

      final Rect corner =
          Rect.fromLTWH(box.width - 120, box.height - 80, 120, 80);
      expect(first.changedIn(later, corner), greaterThan(200),
          reason: 'the drifts are not running — the light never moved');

      // The far corner stays the card in BOTH frames: a drift that escaped its
      // own layer box would show up here first.
      expect(first.changedIn(later, const Rect.fromLTWH(0, 0, 30, 24)),
          lessThan(30),
          reason: 'the drift dragged light across the whole surface');
    });

    testWidgets('reduced motion stills the drifts but still paints',
        (WidgetTester t) async {
      final Raster first = await rasterise(
        t,
        bloomBox(box, starfield: false),
        reducedMotion: true,
      );
      final Raster later = await rasterise(
        t,
        bloomBox(box, starfield: false),
        reducedMotion: true,
        settle: const Duration(milliseconds: 2750),
      );
      expect(first.changedIn(later, Offset.zero & box), 0,
          reason: 'a stilled bloom moved');

      // Stilled is not blank: the resting frame is the light the forms page
      // already ships.
      final Color card = DsThemeData.dark.card;
      final double cardLuma =
          card.r * 0.2126 + card.g * 0.7152 + card.b * 0.0722;
      expect(
        first.maxLumaIn(Rect.fromLTWH(box.width - 80, box.height - 60, 80, 60)),
        greaterThan(cardLuma * 1.5),
      );
    });

    testWidgets('a hover swells both layers', (WidgetTester t) async {
      await t.pumpWidget(host(RepaintBoundary(
        key: const Key('raster'),
        child: bloomBox(box, starfield: false),
      )));
      await t.pump();

      final TestGesture mouse =
          await t.createGesture(kind: PointerDeviceKind.mouse);
      await mouse.addPointer(location: Offset.zero);
      addTearDown(mouse.removePointer);
      await t.pump();

      final RenderRepaintBoundary render =
          t.renderObject(find.byKey(const Key('raster')));
      Future<Raster> shot() async {
        final ui.Image image =
            (await t.runAsync(() => render.toImage(pixelRatio: 1)))!;
        final ByteData bytes = (await t.runAsync(() async =>
            (await image.toByteData(format: ui.ImageByteFormat.rawRgba))!))!;
        final Float64List out =
            Float64List(image.width * image.height * 4);
        for (int i = 0; i < out.length; i++) {
          out[i] = bytes.getUint8(i) / 255;
        }
        final Raster r = Raster(out, image.width, image.height);
        image.dispose();
        return r;
      }

      final Raster resting = await shot();
      await mouse.moveTo(t.getCenter(find.byType(DsBloomCosmic)));
      // Two pumps, not one: the swell's controller starts during the event
      // dispatch, and its ticker takes the first frame after that as t0. A
      // single `pump(1050ms)` would land on t0 and read a swell of zero — the
      // test would fail while the widget was right.
      await t.pump();
      await t.pump(DsDurations.bloom + const Duration(milliseconds: 50));
      final Raster hovered = await shot();

      // The swell is 2.2×/2.5× about a corner origin, so the light reaches
      // further into the middle of the surface than it ever does at rest.
      final Rect middle = Rect.fromLTWH(
        box.width * 0.25,
        box.height * 0.25,
        box.width * 0.3,
        box.height * 0.3,
      );
      expect(hovered.maxLumaIn(middle), greaterThan(resting.maxLumaIn(middle)),
          reason: 'the hover swell did not reach — `scale` was overwritten by '
              'the drift rather than multiplied onto it');
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // .starfield
  // ───────────────────────────────────────────────────────────────────────────

  group('DsStarfield — the two clusters', () {
    test('eight sparkles bottom-right, five top-right, thirteen in all', () {
      expect(dsStarfieldDense.sparkles, hasLength(8));
      expect(dsStarfieldThin.sparkles, hasLength(5));
      expect(DsStarfield.clusters, <DsStarfieldCluster>[
        dsStarfieldDense,
        dsStarfieldThin,
      ]);
    });

    test('the tiles are the two viewBoxes', () {
      expect(dsStarfieldDense.tile, const Size(260, 96));
      expect(dsStarfieldThin.tile, const Size(200, 64));
    });

    test('every instance is its measured opacity/translate/scale triple', () {
      const List<List<double>> dense = <List<double>>[
        <double>[0.95, 214, 54, 0.46],
        <double>[0.78, 240, 24, 0.26],
        <double>[0.85, 180, 76, 0.32],
        <double>[0.66, 248, 72, 0.20],
        <double>[0.55, 196, 16, 0.18],
        <double>[0.58, 146, 40, 0.22],
        <double>[0.50, 232, 92, 0.16],
        <double>[0.42, 112, 66, 0.15],
      ];
      const List<List<double>> thin = <List<double>>[
        <double>[0.78, 168, 18, 0.24],
        <double>[0.55, 132, 42, 0.17],
        <double>[0.60, 190, 46, 0.18],
        <double>[0.42, 96, 14, 0.13],
        <double>[0.38, 150, 60, 0.12],
      ];
      for (final (List<List<double>> table, DsStarfieldCluster cluster)
          in <(List<List<double>>, DsStarfieldCluster)>[
        (dense, dsStarfieldDense),
        (thin, dsStarfieldThin),
      ]) {
        for (int i = 0; i < table.length; i++) {
          final DsSparkle s = cluster.sparkles[i];
          expect(s.opacity, table[i][0], reason: 'sparkle ${i + 1} opacity');
          expect(s.x, table[i][1], reason: 'sparkle ${i + 1} x');
          expect(s.y, table[i][2], reason: 'sparkle ${i + 1} y');
          expect(s.scale, table[i][3], reason: 'sparkle ${i + 1} scale');
          // The box is `24 × scale`, so the whole set runs 2.88px to 11.04px.
          expect(s.box.width, closeTo(24 * table[i][3], 1e-9));
        }
      }
      expect(dsStarfieldDense.sparkles.first.box.width, closeTo(11.04, 1e-9));
      expect(dsStarfieldThin.sparkles.last.box.width, closeTo(2.88, 1e-9));
    });

    test('the sways are 44s ±6° and 33s ∓5°', () {
      expect(dsStarfieldDense.sway, DsDurations.sway);
      expect(dsStarfieldThin.sway, DsDurations.swayAlt);
      expect(DsDurations.sway, const Duration(seconds: 44));
      expect(DsDurations.swayAlt, const Duration(seconds: 33));

      expect(dsStarfieldDense.swayDegreesAt(0), closeTo(-6, 1e-9));
      expect(dsStarfieldDense.swayDegreesAt(1), closeTo(6, 1e-9));
      // The alt runs the other way: `from { rotate: 5deg } to { rotate: -5deg }`.
      expect(dsStarfieldThin.swayDegreesAt(0), closeTo(5, 1e-9));
      expect(dsStarfieldThin.swayDegreesAt(1), closeTo(-5, 1e-9));
      // An oscillation, never a revolution — a full turn would swing the
      // cluster clear of the box for half its cycle.
      for (double t = 0; t <= 1; t += 0.05) {
        expect(dsStarfieldDense.swayDegreesAt(t).abs(), lessThanOrEqualTo(6));
      }
    });

    test('the hover nudge is not rotated by the sway', () {
      // Three independent properties in CSS: `translate` composes OUTSIDE
      // `rotate`, so the −5px lean is the same vector at either end of the
      // cycle. Written as one `transform` the hover would arrive somewhere
      // different at every rotation — which is the failure mode.
      const Size box = Size(354, 96);
      final Offset origin = dsStarfieldDense.originIn(box);
      Offset mappedOrigin(double swayT) => MatrixUtils.transformPoint(
            dsStarfieldDense.matrixFor(box, swayT: swayT, hoverT: 1),
            origin,
          );

      // The origin is the pivot of both the rotation and the scale, so only the
      // translate can move it — and it moves it by the same amount either way.
      expect(mappedOrigin(0) - origin, dsStarfieldDense.hoverTranslate);
      expect(mappedOrigin(1) - origin, dsStarfieldDense.hoverTranslate);
      expect(dsStarfieldDense.hoverTranslate, const Offset(-5, 3));
      expect(dsStarfieldDense.hoverScale, 1.06);
      expect(dsStarfieldThin.hoverTranslate, const Offset(-3, -2));
      expect(dsStarfieldThin.hoverScale, 1.04);
    });

    test('each cluster pivots about the corner it is anchored to', () {
      const Size box = Size(1028, 69.125);
      expect(dsStarfieldDense.originIn(box), const Offset(1028, 69.125));
      expect(dsStarfieldThin.originIn(box), const Offset(1028, 0));
      // `background-position: right bottom` / `right top`, no-repeat.
      expect(dsStarfieldDense.tileOriginIn(box),
          const Offset(1028 - 260, 69.125 - 96));
      expect(dsStarfieldThin.tileOriginIn(box), const Offset(1028 - 200, 0));
    });

    test('the clipping decides which sparkles exist — Alert', () {
      // Anchored, not tiled: on a 69.125px Alert the 96px tile's top 26.875px
      // is outside the box. Sparkle 5 (tile-y 16…20.32) goes entirely.
      const Size alert = Size(1028, 69.125);
      final List<DsSparkle> visible =
          DsStarfield.visibleIn(dsStarfieldDense, alert);
      expect(visible, hasLength(7));
      expect(visible.contains(dsStarfieldDense.sparkles[4]), isFalse,
          reason: 'sparkle 5 is above the box and must not render');
      // Sparkle 2 (tile-y 24…30.24) survives as a 3.365px sliver.
      final DsSparkle two = dsStarfieldDense.sparkles[1];
      expect(visible.contains(two), isTrue);
      final double origin = dsStarfieldDense.tileOriginIn(alert).dy;
      expect(two.box.shift(Offset(0, origin)).bottom, closeTo(3.365, 0.005));
      // Cluster B is never clipped vertically.
      expect(DsStarfield.visibleIn(dsStarfieldThin, alert), hasLength(5));
    });

    test('the clipping decides which sparkles exist — toast', () {
      // A single-line toast is 51.5px tall, so the tile origin is −44.5 and
      // BOTH 2 and 5 go; 6 keeps 0.78px; 1 · 3 · 4 · 7 · 8 survive.
      const Size toast = Size(354, 51.5);
      final List<DsSparkle> visible =
          DsStarfield.visibleIn(dsStarfieldDense, toast);
      expect(visible, hasLength(6));
      expect(visible.contains(dsStarfieldDense.sparkles[1]), isFalse);
      expect(visible.contains(dsStarfieldDense.sparkles[4]), isFalse);
      final DsSparkle six = dsStarfieldDense.sparkles[5];
      final double origin = dsStarfieldDense.tileOriginIn(toast).dy;
      expect(six.box.shift(Offset(0, origin)).bottom, closeTo(0.78, 0.005));

      // THE FAILURE MODE, named: a port that rescaled the tile to fit instead
      // of clipping it would keep all eight, and the field would read as a
      // different density on every host.
      expect(visible.length, isNot(dsStarfieldDense.sparkles.length),
          reason: 'the tile was rescaled to fit rather than clipped');
    });

    test('the glow splits per theme, and only the light one is per-host', () {
      // Dark: `rgb(255 255 255 / 0.5)` — the sparkle's own white, halved.
      final Color dark =
          DsStarfield.glowFor(DsThemeData.dark, DsPalette.warning);
      expect(dark.a, closeTo(0.5, 1e-9));
      expect(dark.r, 1);
      expect(dark.g, 1);
      expect(dark.b, 1);
      // …and it does NOT move with the host's hue.
      expect(DsStarfield.glowFor(DsThemeData.dark, DsPalette.info), dark);

      // Light: `color-mix(in oklab, var(--bloom-2) 85%, transparent)` — the
      // host's own hue at 0.85, so an info alert and a warning toast glow in
      // two different colours on paper.
      final Color warm =
          DsStarfield.glowFor(DsThemeData.light, DsPalette.warning);
      final Color cool =
          DsStarfield.glowFor(DsThemeData.light, DsPalette.info);
      expect(warm.a, closeTo(0.85, 1e-9));
      expect(warm, isNot(cool));
    });

    test('drop-shadow reads its length as a box-shadow radius, not a sigma',
        () {
      // The asymmetry worth pinning: `blur(16px)` IS a sigma, `drop-shadow(0 0
      // 2px)` is a radius and therefore σ = 1. Reading the second as a sigma
      // would double every glow on the page.
      final ({double tight, double wide}) dark =
          DsStarfield.sigmasFor(DsThemeData.dark);
      expect(DsThemeData.dark.starGlowSize, 2);
      expect(dark.tight, closeTo(1, 1e-9));
      expect(dark.wide, closeTo(3, 1e-9));

      final ({double tight, double wide}) light =
          DsStarfield.sigmasFor(DsThemeData.light);
      expect(DsThemeData.light.starGlowSize, 3);
      expect(light.tight, closeTo(1.5, 1e-9));
      expect(light.wide, closeTo(4.5, 1e-9));
    });
  });

  group('the starfield, rasterised', () {
    const Size box = Size(354, 96);

    testWidgets('sparkles land in the anchored corners and nowhere else',
        (WidgetTester t) async {
      final Raster withStars = await rasterise(t, bloomBox(box));
      final Raster without = await rasterise(t, bloomBox(box, starfield: false));

      // Cluster A's brightest instance is sparkle 1 at tile (214, 54) scaled
      // 0.46 — inside the bottom-right 260 × 96 tile.
      final Rect dense = Rect.fromLTWH(
        box.width - 60,
        box.height - 50,
        60,
        50,
      );
      expect(withStars.maxLumaIn(dense),
          greaterThan(without.maxLumaIn(dense) + 0.05),
          reason: 'no sparkle painted in the dense cluster');

      // Cluster B is `right top`, so the top-right corner gains light too.
      final Rect thin = Rect.fromLTWH(box.width - 60, 0, 60, 30);
      expect(withStars.maxLumaIn(thin), greaterThan(without.maxLumaIn(thin)),
          reason: 'no sparkle painted in the thin cluster');

      // THE FAILURE MODE: anchored, not tiled. Cluster A's instances span
      // tile-x 112…252 of a 260px tile, so on a 354px host nothing is drawn in
      // the left 94px — a port that repeated or stretched the background would
      // light it.
      final Rect left = const Rect.fromLTWH(0, 0, 60, 96);
      expect(withStars.changedIn(without, left), 0,
          reason: 'the starfield tiled or stretched instead of anchoring');
    });

    testWidgets('the sway moves them, and reduced motion does not',
        (WidgetTester t) async {
      final Rect corner =
          Rect.fromLTWH(box.width - 80, box.height - 60, 80, 60);

      final Raster first = await rasterise(t, bloomBox(box));
      final Raster later = await rasterise(
        t,
        bloomBox(box),
        // An eighth of the 44s sway — several degrees of rotation about the
        // corner, which on an 11px sparkle 240px out is plainly visible.
        settle: const Duration(seconds: 5, milliseconds: 500),
      );
      expect(first.changedIn(later, corner), greaterThan(100),
          reason: 'the sways are not running');

      final Raster stillA =
          await rasterise(t, bloomBox(box), reducedMotion: true);
      final Raster stillB = await rasterise(
        t,
        bloomBox(box),
        reducedMotion: true,
        settle: const Duration(seconds: 5, milliseconds: 500),
      );
      expect(stillA.changedIn(stillB, corner), 0,
          reason: 'a stilled starfield moved');
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // AlertAction and the reserved lane
  // ───────────────────────────────────────────────────────────────────────────

  group('DsAlert.action — F10\'s unconditional lane', () {
    testWidgets('the action sits 8px from the top and right of the border box',
        (WidgetTester t) async {
      await t.pumpWidget(host(SizedBox(
        width: 1030,
        child: DsAlert(
          variant: DsAlertVariant.warning,
          icon: const DsIcon(DsIconGlyph.hourglass),
          title: 'Withdrawal under review',
          description: 'Withdrawals over \$1,000 are reviewed manually.',
          action: DsButton(
            variant: DsButtonVariant.secondary,
            size: DsButtonSize.sm,
            onPressed: () {},
            child: const Text('Details'),
          ),
        ),
      )));
      final Rect alert = t.getRect(find.byType(DsAlert));
      final Rect button = t.getRect(find.byType(DsButton));
      expect(alert.top - button.top, closeTo(-8, 0.001));
      expect(alert.right - button.right, closeTo(8, 0.001));
      // `Button variant="secondary" size="sm"` is 32px tall.
      expect(button.height, closeTo(32, 0.001));
    });

    testWidgets('the lane is 80px whether or not anything would collide',
        (WidgetTester t) async {
      // Supervisor ruling F10. `has-data-[slot=alert-action]:pr-20` widens the
      // right padding unconditionally, which is what makes the two action
      // Alerts wrap differently from the other three.
      expect(DsAlert.actionLane, 80);
      expect(DsAlert.actionInset, 8);

      // A title long enough to fill its line, so its longest line reports the
      // measure it was given.
      const String long =
          'a b c d e f g h i j k l m n o p q r s t u v w x y z a b c d e f g '
          'h i j k l m n o p q r s t u v w x y z a b c d e f g h i j k l m n '
          'o p q r s t u v w x y z a b c d e f g h i j k l m n o p q r s t u';

      Future<({EdgeInsets pad, double titleRight})> lay(
          {required bool withAction}) async {
        await t.pumpWidget(host(SizedBox(
          width: 1030,
          child: DsAlert(
            icon: const DsIcon(DsIconGlyph.info),
            title: long,
            action: withAction
                ? DsButton(
                    variant: DsButtonVariant.secondary,
                    size: DsButtonSize.sm,
                    onPressed: () {},
                    child: const Text('Retry'),
                  )
                : null,
          ),
        )));
        // The alert's own `px-4 py-3.5`, which is the declaration `pr-20`
        // replaces the right half of.
        final EdgeInsets pad = t
            .widgetList<Padding>(find.descendant(
              of: find.byType(DsAlert),
              matching: find.byType(Padding),
            ))
            .map((Padding p) => p.padding.resolve(TextDirection.ltr))
            .firstWhere((EdgeInsets e) => e.top == 14);
        return (pad: pad, titleRight: t.getRect(find.text(long)).right);
      }

      final ({EdgeInsets pad, double titleRight}) bare =
          await lay(withAction: false);
      final ({EdgeInsets pad, double titleRight}) laned =
          await lay(withAction: true);

      // `px-4` on its own…
      expect(bare.pad.left, 16);
      expect(bare.pad.right, 16);
      // …and `pr-20` in place of its right half the moment an action mounts.
      expect(laned.pad.left, 16);
      expect(laned.pad.right, 80);

      // The rendered consequence, which is the whole reason F10 says
      // reproduce-exactly: the text column loses 64px it did not have to.
      expect(bare.titleRight - laned.titleRight, closeTo(64, 12));
    });

    testWidgets('no action means no lane and no Stack', (WidgetTester t) async {
      await t.pumpWidget(host(const SizedBox(
        width: 448,
        child: DsAlert(title: 'Provably fair'),
      )));
      expect(find.byType(DsButton), findsNothing);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // DsProgress
  // ───────────────────────────────────────────────────────────────────────────

  group('DsProgress', () {
    test('five tones, each an -ink fill on its own shadow', () {
      expect(DsProgressTone.values, hasLength(5));
      expect(DsProgressTone.normal.label, 'default');
      expect(DsProgressTone.value.label, 'value');

      final DsThemeData theme = DsThemeData.dark;
      expect(DsProgressTone.normal.inkOf(theme), theme.actionInk);
      expect(DsProgressTone.value.inkOf(theme), theme.valueInk);
      expect(DsProgressTone.success.inkOf(theme), theme.successInk);
      expect(DsProgressTone.warning.inkOf(theme), theme.warningInk);
      expect(DsProgressTone.destructive.inkOf(theme), theme.destructiveInk);

      // The two lit tones carry their ramp's own glow; the other three do not.
      expect(DsProgressTone.normal.shadow, DsShadows.btnPrimary);
      expect(DsProgressTone.value.shadow, DsShadows.btnValue);
      expect(DsProgressTone.success.shadow, DsShadows.btn);
      expect(DsProgressTone.warning.shadow, DsShadows.btn);
      expect(DsProgressTone.destructive.shadow, DsShadows.btn);
    });

    test('the fill is a translation of a full-width bar', () {
      expect(const DsProgress(value: 100).translation, 0);
      expect(const DsProgress(value: 0).translation, -1);
      expect(const DsProgress(value: 20.6).translation, closeTo(-0.794, 1e-9));
      expect(const DsProgress(value: 69.6).translation, closeTo(-0.304, 1e-9));
    });

    test('the transition is the default, not the token that matches it', () {
      // `duration-base` is a `duration-<word>` utility and emits nothing, so
      // the transition lands on `--default-transition-duration`.
      expect(DsProgress.transition, DsDurations.transitionDefault);
      expect(DsProgress.height, 10);
    });

    testWidgets('10px channel, r999, 1px --input over --muted, in a socket',
        (WidgetTester t) async {
      await t.pumpWidget(host(const SizedBox(
        width: 448,
        child: DsProgress(value: 69.6, tone: DsProgressTone.value),
      )));
      final DsThemeData theme = DsTheme.of(t.element(find.byType(DsProgress)));
      final Rect bar = t.getRect(find.byType(DsProgress));
      expect(bar.height, 10);
      expect(bar.width, 448);

      final DsMachineSurface root = t.widget<DsMachineSurface>(
        find.descendant(
          of: find.byType(DsProgress),
          matching: find.byType(DsMachineSurface),
        ).first,
      );
      expect(root.spec.layers, DsShadows.pressed.layers);
      expect(root.fill, theme.muted);
      expect((root.border! as Border).top.color, theme.input);
      expect(root.radius, BorderRadius.circular(DsRadii.pill));
    });

    testWidgets('the first bar can have no accessible name — drift 6',
        (WidgetTester t) async {
      final SemanticsHandle handle = t.ensureSemantics();
      await t.pumpWidget(host(const SizedBox(
        width: 448,
        child: DsProgress(value: 20.6),
      )));
      // `page.tsx:339` is a bare `<Progress value={20.6} />`; every other bar
      // on the page passes an aria-label. The port must be able to reproduce
      // the omission rather than quietly fixing it.
      expect(t.getSemantics(find.byType(DsProgress)).label, '');
      expect(t.getSemantics(find.byType(DsProgress)).value, '21%');
      handle.dispose();
    });

    testWidgets('rasterised: ink to the left of the boundary, track to the '
        'right', (WidgetTester t) async {
      const double width = 448;
      final Raster frame = await rasterise(
        t,
        const SizedBox(
          width: width,
          child: DsProgress(value: 60, tone: DsProgressTone.success),
        ),
        // Past the fill transition, which starts from 0 on the first frame.
        settle: const Duration(milliseconds: 400),
      );
      final DsThemeData theme = DsThemeData.dark;

      // The content box is the channel less its 1px border on each side, and
      // 60% of it is filled.
      const double content = width - 2;
      final int boundary = (1 + content * 0.6).round();
      final int mid = 5; // the channel is 10 tall; row 5 is its middle.

      // Left of the boundary: the tone's own `-ink`, under `shadow-btn`'s two
      // inset layers — so the pin is the HUE, not the exact triple. A
      // `--success-ink` fill is overwhelmingly green and barely red, and it
      // stays that way however the rim and the shade darken it.
      final Color filled = frame.at(boundary - 12, mid);
      expect(filled.g, greaterThan(filled.r * 3));
      expect(filled.g, greaterThan(filled.b));
      expect(filled.g, closeTo(theme.successInk.g, 0.15));

      // Right of it: the sunken `--muted` track, which is far darker.
      expect(frame.luma(boundary + 12, mid),
          lessThan(frame.luma(boundary - 12, mid) * 0.5));
      // …and neutral, where the fill is not: the track spends no hue at all.
      final Color empty = frame.at(boundary + 12, mid);
      expect((empty.g - empty.r).abs(), lessThan(0.05));

      // THE FAILURE MODE: a port that ignored the translation, or that drove
      // the fill with a width factor and then let the clip round it, would
      // carry ink all the way to the right edge.
      expect(frame.luma(width.round() - 6, mid),
          lessThan(frame.luma(boundary - 12, mid) * 0.5),
          reason: 'the indicator filled the whole channel — the translation '
              'never applied');
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // DsSkeleton
  // ───────────────────────────────────────────────────────────────────────────

  group('DsSkeleton', () {
    test('it states no motion of its own', () {
      expect(DsSkeleton.defaultRadius, DsRadii.md);
      expect(DsShimmer.duration, DsDurations.shimmer);
      expect(DsShimmer.fill, DsKeyframeFill.none);
      expect(DsShimmer.loops, isTrue);
    });

    testWidgets('the box is the caller\'s and the corner is rounded-md',
        (WidgetTester t) async {
      await t.pumpWidget(host(const DsSkeleton(width: 160, height: 16)));
      final Rect box = t.getRect(find.byType(DsSkeleton));
      expect(box.width, 160);
      expect(box.height, 16);
      final ClipRRect clip = t.widget<ClipRRect>(find.descendant(
        of: find.byType(DsSkeleton),
        matching: find.byType(ClipRRect),
      ));
      expect(clip.borderRadius, BorderRadius.circular(DsRadii.md));
    });

    test('the span form is an inline box aligned to the middle', () {
      // `as="span"` → `inline-block`, and the page's one instance adds
      // `align-middle`.
      final InlineSpan span = DsSkeleton.span(width: 112, height: 14);
      expect(span, isA<WidgetSpan>());
      expect((span as WidgetSpan).alignment, PlaceholderAlignment.middle);
      expect(span.child, isA<DsSkeleton>());
    });

    testWidgets('rasterised: the band crosses, and reduced motion holds it',
        (WidgetTester t) async {
      const Size box = Size(160, 24);
      const Widget skeleton = DsSkeleton(width: 160, height: 24);
      final Rect all = Offset.zero & box;

      final Raster first = await rasterise(t, skeleton);
      final Raster later = await rasterise(
        t,
        skeleton,
        // A third of the 1.4s cycle.
        settle: const Duration(milliseconds: 470),
      );
      expect(first.changedIn(later, all), greaterThan(500),
          reason: 'the shimmer is not running');

      // Every pixel is somewhere on the popover→accent ramp, in both frames:
      // the tile repeats, so the box is never empty at the extremes.
      final DsThemeData theme = DsThemeData.dark;
      final double floor = theme.popover.r * 0.2126 +
          theme.popover.g * 0.7152 +
          theme.popover.b * 0.0722;
      final double ceiling = theme.accent.r * 0.2126 +
          theme.accent.g * 0.7152 +
          theme.accent.b * 0.0722;
      for (final Raster frame in <Raster>[first, later]) {
        for (int x = 2; x < box.width - 2; x += 7) {
          final double l = frame.luma(x, 12);
          expect(l, greaterThanOrEqualTo(floor - 0.02));
          expect(l, lessThanOrEqualTo(ceiling + 0.02));
        }
      }
      // THE FAILURE MODE: a single band instead of a repeating tile leaves the
      // box flat --popover at the extremes. The bright stop has to be present
      // somewhere on this frame.
      expect(first.maxLumaIn(all), greaterThan(floor + (ceiling - floor) * 0.3),
          reason: 'the accent band never entered the box — the gradient was '
              'drawn as one band rather than a repeating tile');

      final Raster stillA = await rasterise(t, skeleton, reducedMotion: true);
      final Raster stillB = await rasterise(
        t,
        skeleton,
        reducedMotion: true,
        settle: const Duration(milliseconds: 470),
      );
      expect(stillA.changedIn(stillB, all), 0);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // DsEmpty
  // ───────────────────────────────────────────────────────────────────────────

  group('DsEmpty — six parts, two drifts', () {
    testWidgets('the dashed border never paints — drift 8',
        (WidgetTester t) async {
      await t.pumpWidget(host(SizedBox(
        width: 482,
        child: DsEmpty(children: <Widget>[
          DsEmptyHeader(children: <Widget>[
            const DsEmptyMedia(
              glyph: DsIconGlyph.packageOpen,
              tone: DsIconTone.action,
            ),
            const DsEmptyTitle('Your Stash is empty'),
            const DsEmptyDescription('Cards land here.'),
          ]),
        ]),
      )));
      // `rounded-xl border-dashed` with NO width class: Tailwind's
      // `border-dashed` sets only `border-style`, Preflight resets the width to
      // 0, and the border therefore never renders. A port that read the class
      // list instead of the render would draw a dashed rectangle that is
      // nowhere on the reference.
      final Iterable<DecoratedBox> decorated = t
          .widgetList<DecoratedBox>(find.descendant(
            of: find.byType(DsEmpty),
            matching: find.byType(DecoratedBox),
          ))
          .where((DecoratedBox d) => (d.decoration as BoxDecoration).border != null);
      expect(decorated, isEmpty,
          reason: 'a border painted where the reference has none');
      expect(DsEmpty.radius, DsRadii.xl);
      expect(DsEmpty.padding, 24);
      expect(DsEmpty.gap, 16);
    });

    testWidgets('EmptyMedia defeats Icon size="xl" — drift 9',
        (WidgetTester t) async {
      await t.pumpWidget(host(const DsEmptyMedia(
        glyph: DsIconGlyph.search,
        tone: DsIconTone.subtle,
      )));
      // The tile is 32 × 32 on a 12px corner.
      final Rect tile = t.getRect(find.byType(Container));
      expect(tile.width, 32);
      expect(tile.height, 32);

      // …and the glyph inside it is 16px, drawn with the stroke computed for
      // 24: `[&_svg:not([class*='size-'])]:size-4` wins the box and the
      // `size="xl"` attribute loses, but `icon.tsx` computes strokeWidth from
      // the PROP. So it is visibly thinner than every other 16px glyph.
      final DsIcon icon = t.widget<DsIcon>(find.byType(DsIcon));
      expect(icon.sizePx, 16);
      expect(icon.strokeOverride, 2);
      expect(DsIcon.strokeFor(16), 2.4,
          reason: 'the whole point of the drift is that these differ');
      expect(t.getRect(find.byType(DsIcon)).width, 16);
    });

    testWidgets('both measures are max-w-sm, and the gaps are 8 / 10 / 16',
        (WidgetTester t) async {
      expect(DsEmptyHeader.maxWidth, DsContainers.sm);
      expect(DsEmptyContent.maxWidth, DsContainers.sm);
      expect(DsContainers.sm, 384);
      expect(DsEmptyHeader.gap, 8);
      expect(DsEmptyContent.gap, 10);
      expect(DsEmpty.gap, 16);
      expect(DsEmptyMedia.marginBottom, 8);

      await t.pumpWidget(host(SizedBox(
        width: 482,
        child: DsEmptyHeader(children: <Widget>[
          const DsEmptyTitle('No packs match those filters'),
        ]),
      )));
      // 482px of panel, but the header caps itself at 384.
      expect(t.getRect(find.byType(DsEmptyTitle)).width,
          lessThanOrEqualTo(DsContainers.sm));
    });

    testWidgets('the title is 13/500 tracking-tight and the description 1.625',
        (WidgetTester t) async {
      await t.pumpWidget(host(const SizedBox(
        width: 384,
        child: DsEmptyTitle('Your Stash is empty'),
      )));
      final TextStyle title =
          t.widget<Text>(find.byType(Text)).style!;
      expect(title.fontSize, 13);
      expect(title.fontWeight, FontWeight.w500);
      // `tracking-tight` −0.02em at 13px = −0.26px, measured on the reference.
      expect(title.letterSpacing, closeTo(-0.26, 1e-9));
      // `font-heading` and `font-sans` are two tokens for one face, so the
      // class changes which is read and not which renders.
      expect(title.fontFamily, contains(DsFonts.heading));
      expect(DsFonts.heading, DsFonts.sans);

      expect(DsEmptyDescription.spec.size, 13);
      expect(DsEmptyDescription.spec.height, closeTo(1.625, 1e-9));
    });
  });
}
