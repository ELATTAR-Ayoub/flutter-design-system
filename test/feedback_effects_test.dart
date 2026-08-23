import 'dart:async';
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
  Size viewport = const Size(1440, 900),
  EdgeInsets padding = EdgeInsets.zero,
}) {
  return MediaQuery(
    data: MediaQueryData(
      size: viewport,
      disableAnimations: reducedMotion,
      // The system bars. Zero everywhere but the two compact-anchor probes, so
      // every geometry pin in this file measures the box it always measured.
      padding: padding,
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
  return readRaster(t);
}

/// The `Key('raster')` boundary's pixels, for a host this file pumped by hand.
///
/// [rasterise] mounts its subject and reads it in one call, which a live
/// [DsToaster] cannot use: it has to be mounted first and fired into
/// afterwards, so the read is the half that has to stand on its own.
Future<Raster> readRaster(WidgetTester t) async {
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

  // ────────────────────────────────────────────────────────────────────────
  // Wave B2 — sonner's choreography. Supervisor rulings F4, F5, F8.
  //
  // Transcribed from `node_modules/sonner/dist/styles.css` + `index.mjs`, then
  // rAF-sampled on the live reference (1440 × 900, dark, 2026-08-16) before a
  // line was written. Every number below is one of those two, and where the two
  // disagree the measurement wins.
  //
  // Geometry is read off `getRect`, which resolves ancestor transforms — so
  // these pin **where the toast landed**, not which `Transform` widgets are in
  // the tree. That distinction is the whole point: three nested transforms
  // could each be right and compose wrong.
  //
  // No `pumpAndSettle` here either: a toast carries a `DsBloomCosmic`, which
  // runs two forever loops, so a settle would never return.
  // ────────────────────────────────────────────────────────────────────────
  group('sonner choreography — the stack', () {
    Widget toaster(DsToastController c) => host(
          SizedBox(
            width: 1440,
            height: 900,
            child: DsToaster(controller: c),
          ),
        );

    Finder toastWith(String title) => find.ancestor(
          of: find.text(title),
          matching: find.byType(DsToast),
        );

    /// The edge every toast is anchored to — `bottom: 24px` inside the host.
    double anchor(WidgetTester t) =>
        t.getRect(find.byType(DsToaster)).bottom - DsToaster.viewportOffset;

    /// How far a toast's own bottom edge sits above that anchor.
    double raise(WidgetTester t, String title) =>
        anchor(t) - t.getRect(toastWith(title)).bottom;

    double scaleOf(WidgetTester t, String title) =>
        t.getRect(toastWith(title)).width / DsToaster.width;

    /// The measured natural height the host pinned the stack to — read back
    /// off the widget rather than assumed, because it is a font metric.
    double heightOf(WidgetTester t, String title) =>
        t.getRect(toastWith(title)).height / scaleOf(t, title);

    double opacityOf(WidgetTester t, String title) => t
        .widget<Opacity>(
            find.ancestor(of: toastWith(title), matching: find.byType(Opacity)).first)
        .opacity;

    double contentOpacityOf(WidgetTester t, String title) =>
        t.widget<DsToast>(toastWith(title)).contentOpacity;

    /// The mount frame, the measure-then-lay-out round trip, and the entrance.
    Future<void> arrive(WidgetTester t) async {
      await t.pump();
      await t.pump();
      await t.pump(DsToaster.transition);
      await t.pump();
    }

    Future<TestGesture> hover(WidgetTester t, Offset at) async {
      final TestGesture g =
          await t.createGesture(kind: PointerDeviceKind.mouse);
      await g.addPointer(location: Offset.zero);
      addTearDown(g.removePointer);
      await g.moveTo(at);
      await t.pump();
      return g;
    }

    testWidgets(
        'enters from translateY(100%) at opacity 0, over the slow window on '
        'CSS ease', (WidgetTester t) async {
      final DsToastController c = DsToastController();
      addTearDown(c.dispose);
      await t.pumpWidget(toaster(c));
      c.success('Sold 3 cards for \$2,481.00',
          description: 'Credited to your available balance.');

      // The base rule, before `data-mounted` flips: the toast is a whole box
      // BELOW its resting place and completely transparent. There is no
      // `@keyframes` entrance — sonner's own comment says so.
      await t.pump();
      final double height = heightOf(t, 'Sold 3 cards for \$2,481.00');
      expect(height, greaterThan(0));
      expect(raise(t, 'Sold 3 cards for \$2,481.00'), closeTo(-height, 0.01),
          reason: 'translateY(100%) is a whole box, resolved against itself');
      expect(opacityOf(t, 'Sold 3 cards for \$2,481.00'), 0);

      // `data-mounted="true"` — one frame later, and it travels.
      await t.pump();
      await t.pump(DsToaster.transition ~/ 2);
      final double half = DsCurves.cssEase.transform(0.5);
      expect(raise(t, 'Sold 3 cards for \$2,481.00'),
          closeTo(-height * (1 - half), 0.6),
          reason: 'measured 0.645 of the travel at 38.3% of the window — this '
              'curve, and not DsCurves.standard or DsCurves.out');
      expect(opacityOf(t, 'Sold 3 cards for \$2,481.00'), closeTo(half, 0.02));

      await t.pump(DsToaster.transition);
      expect(raise(t, 'Sold 3 cards for \$2,481.00'), closeTo(0, 0.01));
      expect(opacityOf(t, 'Sold 3 cards for \$2,481.00'), 1);
      c.clear();
      await t.pump();
    });

    testWidgets(
        'a collapsed stack blanks, scales 1 − 0.05n and pins every back toast '
        "to the FRONT toast's measured height", (WidgetTester t) async {
      final DsToastController c = DsToastController();
      addTearDown(c.dispose);
      await t.pumpWidget(toaster(c));
      const String front = 'Could not reach the vault';
      const String back1 = 'Sold 3 cards for \$2,481.00';
      const String back2 = 'Added to favourites';

      // Each toast's own height, read while it is still the front one — the
      // only moment it wears it.
      c.show(const DsToastMessage(title: back2));
      await arrive(t);
      final double natural2 = heightOf(t, back2);
      c.success(back1, description: 'Credited to your available balance.');
      await arrive(t);
      final double natural1 = heightOf(t, back1);
      c.error(front, description: 'Nothing was charged. Try again in a moment.');
      await arrive(t);

      final double frontHeight = heightOf(t, front);
      // A title-only toast and a title-plus-description one genuinely differ,
      // which is the only reason the pin below means anything. The comparison
      // is between line COUNTS, never between wrap widths: this file renders on
      // the test fallback face, so where a description breaks is not a fact
      // about the reference.
      expect(natural2, lessThan(natural1));
      expect(natural2, lessThan(frontHeight));

      // The front toast is untouched: `--offset: 0`, no scale, legible.
      expect(raise(t, front), closeTo(0, 0.01));
      expect(scaleOf(t, front), closeTo(1, 1e-9));
      expect(contentOpacityOf(t, front), 1);

      // `--y: translateY(--lift-amount * n) scale(1 - 0.05n)` — measured
      // `matrix(0.95, 0, 0, 0.95, 0, -14)` and `matrix(0.9, 0, 0, 0.9, 0, -28)`.
      for (final (int n, String title) in <(int, String)>[
        (1, back1),
        (2, back2),
      ]) {
        final double scale = 1 - DsToaster.stackScaleStep * n;
        expect(scaleOf(t, title), closeTo(scale, 1e-6), reason: 'toast $n');
        // `height: var(--front-toast-height)` — drift 17's measure-then-lay-out
        // pass, and the assertion this whole render object exists for.
        expect(heightOf(t, title), closeTo(frontHeight, 0.01),
            reason: 'back toast $n is pinned to the front toast, not to itself');
        // The box is translated by the gap and then scaled about its centre.
        expect(
          raise(t, title),
          closeTo(DsToaster.gap * n + frontHeight * (1 - scale) / 2, 0.02),
          reason: 'toast $n sits translateY(-14n) up, scaled about its centre',
        );
        // `> * { opacity: 0 }` — the icon slot and the content column both.
        expect(contentOpacityOf(t, title), 0);
        // …and the starfield goes with them, because it hangs off
        // `[data-content]`. Measured on the live stack: contentOpacity 0 with
        // both bloom layers still at 0.75 and still drifting.
        expect(t.widget<DsToast>(toastWith(title)).starfield, isFalse);
        // The bloom is NOT blanked: its two pseudo-elements are on the toast
        // itself, so a collapsed sliver still glows.
        expect(
          find.descendant(
              of: toastWith(title), matching: find.byType(DsBloomCosmic)),
          findsOneWidget,
        );
      }
      // The whole toast stays opaque; only its children fade.
      expect(opacityOf(t, back2), 1);

      c.clear();
      await t.pump();
    });

    // ──────────────────────────────────────────────────────────────────────
    // The empty-plate bug, and the two transitions it was hiding behind.
    //
    // A toast's whole choreography lives in its `State` — `_mounted`, the four
    // `_Track`s, the live swipe. The `Stack` that holds the slots re-indexes on
    // every arrival and on every front departure, and it was carrying its
    // `ValueKey` on the `_ToastSlot` **inside** an unkeyed `Positioned`: the
    // unkeyed wrappers matched by position, the keyed children were then
    // rejected by `Widget.canUpdate`, and every surviving toast's `State` was
    // torn out and rebuilt from `initState`. That resets `_mounted` to false,
    // `_opacity` to 0 and `_transform` to the entrance base — full scale, a
    // whole box off the anchor — while the blanking is re-`set` rather than
    // re-animated. What you saw was a full-size, contentless plate sliding
    // through the stack, and a promoted toast blinking out instead of fading
    // its title back in.
    //
    // Both tests below assert the CONTINUITY, not the endpoint: every one of
    // them passes on the torn-out build if it only looks at where things came
    // to rest. The bite is in the frames between.
    // ──────────────────────────────────────────────────────────────────────
    testWidgets(
        'the toast a front exit promotes fades its content back in, at full '
        'opacity throughout — it does not blink out and re-enter',
        (WidgetTester t) async {
      final DsToastController c = DsToastController();
      addTearDown(c.dispose);
      await t.pumpWidget(toaster(c));
      const String front = 'Could not reach the vault';
      const String back1 = 'Sold 3 cards for \$2,481.00';
      const String back2 = 'Added to favourites';
      c.show(const DsToastMessage(title: back2));
      await arrive(t);
      c.success(back1, description: 'Credited to your available balance.');
      await arrive(t);
      final int id = c.error(front,
          description: 'Nothing was charged. Try again in a moment.');
      await arrive(t);

      // Blanked, scaled and pinned behind the front toast — the state the
      // promotion has to travel out of.
      expect(contentOpacityOf(t, back1), 0);
      final Element element = t.element(toastWith(back1));

      c.dismiss(id);
      await t.pump();
      // Nothing the leaving toast does touches the one behind it: sonner drops
      // it from `heights` and the survivors close the gap, but `--opacity` is
      // the toast's own and the back toast is not the one leaving.
      for (int i = 0; i < 4; i++) {
        await t.pump(DsToaster.unmountDelay ~/ 4);
        expect(opacityOf(t, back1), 1,
            reason: 'the back toast is not leaving; only the front is');
      }
      await t.pump();

      // The promotion frame. The element is the SAME element — the whole point
      // — so its clocks carry the blanked state forward instead of starting
      // over from the entrance.
      expect(identical(t.element(toastWith(back1)), element), isTrue,
          reason: 'a re-indexed slot must MOVE its element, not rebuild it; a '
              'rebuilt one restarts at opacity 0 on the entrance base');
      expect(opacityOf(t, back1), 1,
          reason: 'the promoted toast was already on screen and stays on it');
      expect(contentOpacityOf(t, back1), lessThan(0.02),
          reason: 'the content FADES in over the slow window; a torn-out state '
              'would have re-`set` it to 1 in one frame');
      // Where the promotion starts from: still the blanked slot, one gap up
      // and scaled about its own centre.
      final double from = raise(t, back1);
      expect(from, greaterThan(DsToaster.gap));

      // Mid-fade: content, scale and offset all part-way, on the one 400ms
      // window they share.
      await t.pump(DsToaster.transition ~/ 2);
      final double half = DsCurves.cssEase.transform(0.5);
      expect(contentOpacityOf(t, back1), closeTo(half, 0.02));
      expect(opacityOf(t, back1), 1);
      expect(scaleOf(t, back1),
          closeTo(1 - DsToaster.stackScaleStep * (1 - half), 0.01),
          reason: 'travelling 0.95 → 1, not restarting at 1');
      expect(raise(t, back1), closeTo(from * (1 - half), 0.6));
      expect(raise(t, back1), greaterThan(-0.01),
          reason: 'it lifts into the front slot from above it; the entrance '
              'base would put it a whole box BELOW the anchor');

      // Landed: the front toast, legible, exactly where the front toast sits.
      await t.pump(DsToaster.transition);
      expect(contentOpacityOf(t, back1), 1);
      expect(opacityOf(t, back1), 1);
      expect(scaleOf(t, back1), closeTo(1, 1e-6));
      expect(raise(t, back1), closeTo(0, 0.01));
      expect(find.text(back1), findsOneWidget);
      expect(find.text('Credited to your available balance.'), findsOneWidget);
      // …and the one behind it has taken over the blanked slot.
      expect(contentOpacityOf(t, back2), 0);

      c.clear();
      await t.pump();
    });

    testWidgets(
        'the FRONT toast paints over the stack behind it — a back plate is '
        'opaque, and a title under one is the empty plate',
        (WidgetTester t) async {
      // THE PAINTER RULE, and the one bug in this file that no widget-tree
      // assertion above can see. `--z-index: toasts.length - index` puts the
      // newest on top; a `Stack` paints in child order and `slots` is built
      // newest-FIRST, because that is the order sonner's `index` counts in.
      // Handed over unreversed, the OLDEST toast paints last — over the front
      // one — and it is not a translucent hint but a whole opaque `--popover`
      // plate, pinned to the front toast's height, 14px off it, with its own
      // children at `opacity: 0`. Every assertion in this group still passes:
      // the tree is right and only the canvas is wrong.
      final DsToastController c = DsToastController();
      addTearDown(c.dispose);
      await t.pumpWidget(host(RepaintBoundary(
        key: const Key('raster'),
        // Smaller than the 1440 × 900 the other tests lay out in, and it
        // changes nothing: the compact branch reads the MediaQuery, which
        // `host` still puts at 1440, so this is the wide contract's 356px box
        // in a cheaper raster.
        child: SizedBox(
          width: 700,
          height: 400,
          child: DsToaster(controller: c),
        ),
      )));

      // The control: one toast, nothing over it. Its title is `--foreground`
      // on `--popover`, so it is the brightest thing in its own band.
      const String back = 'Added to favourites';
      c.show(const DsToastMessage(title: back));
      await arrive(t);
      final Rect boundary = t.getRect(find.byKey(const Key('raster')));
      final Rect backTitle = t.getRect(find.text(back));
      final double legible =
          (await readRaster(t)).maxLumaIn(backTitle.shift(-boundary.topLeft));
      expect(legible, greaterThan(0.8),
          reason: 'the control — what a title that reaches the canvas reads');

      // A second toast arrives. The first is now the blanked back plate, and
      // the new one is the front: its title has to survive to the canvas.
      const String front = 'Sold 3 cards for \$2,481.00';
      c.success(front);
      await arrive(t);
      final Rect frontTitle = t.getRect(find.text(front));
      expect(t.getRect(toastWith(back)).overlaps(frontTitle), isTrue,
          reason: 'the back plate genuinely covers this band — without that '
              'overlap the assertion below would prove nothing');
      expect(contentOpacityOf(t, back), 0,
          reason: 'and it is blank, so what it covers it covers with nothing');

      final double painted =
          (await readRaster(t)).maxLumaIn(frontTitle.shift(-boundary.topLeft));
      expect(painted, closeTo(legible, 0.05),
          reason: 'the front toast reads exactly as it did alone. Painted '
              'under the back plate this band reads 0.53 against 0.98 — and '
              '0.13 where the plate covers a title outright, which is the '
              'empty plate in the screenshot');

      c.clear();
      await t.pump();
    });

    testWidgets(
        'an arrival lets the toast already on screen FADE into the stack, '
        'rather than restarting its entrance', (WidgetTester t) async {
      final DsToastController c = DsToastController();
      addTearDown(c.dispose);
      await t.pumpWidget(toaster(c));
      const String first = 'Added to favourites';
      c.show(const DsToastMessage(title: first));
      await arrive(t);
      final Element element = t.element(toastWith(first));
      expect(contentOpacityOf(t, first), 1);

      c.success('Sold 3 cards for \$2,481.00');
      await t.pump();
      await t.pump();

      expect(identical(t.element(toastWith(first)), element), isTrue);
      // It is on its way to blanked, and it is *on its way*: a torn-out state
      // re-`set` this to 0 in the frame the newcomer mounted, which is the cut
      // the collapse is not allowed to have.
      expect(contentOpacityOf(t, first), greaterThan(0.5),
          reason: 'the blanking rides the same 400ms transition as everything '
              'else — it is not applied in one frame');
      expect(opacityOf(t, first), 1,
          reason: 'only the NEW toast enters; this one is already here');

      await t.pump(DsToaster.transition ~/ 2);
      final double half = DsCurves.cssEase.transform(0.5);
      expect(contentOpacityOf(t, first), closeTo(1 - half, 0.06));
      expect(contentOpacityOf(t, first), greaterThan(0),
          reason: 'a cut to 0 is the empty plate this test exists to catch');
      expect(opacityOf(t, first), 1);
      // And it sinks back into the stack from its own slot, never from below
      // the anchor — the entrance base a rebuilt state would start from.
      final double mid = raise(t, first);
      expect(mid, greaterThan(0), reason: 'it has left the front slot');

      await t.pump(DsToaster.transition);
      expect(contentOpacityOf(t, first), 0);
      expect(opacityOf(t, first), 1);
      expect(scaleOf(t, first), closeTo(1 - DsToaster.stackScaleStep, 1e-6));
      // Where it was headed, measured rather than assumed — the pin is the
      // newcomer's height and this file renders on the test fallback face, so
      // how either title wraps is not a fact about anything.
      final double blanked = raise(t, first);
      expect(mid, lessThan(blanked),
          reason: 'the mid-window sample was still on its way into the slot, '
              'not already parked in it');
      expect(mid, closeTo(blanked * half, 0.6));
      expect(heightOf(t, first),
          closeTo(heightOf(t, 'Sold 3 cards for \$2,481.00'), 0.05),
          reason: 'pinned to the front toast, which is now the newcomer');

      c.clear();
      await t.pump();
    });

    testWidgets(
        'hovering expands to translateY(-offset) at each toast\'s own height',
        (WidgetTester t) async {
      final DsToastController c = DsToastController();
      addTearDown(c.dispose);
      await t.pumpWidget(toaster(c));
      c.show(const DsToastMessage(title: 'Added to favourites'));
      await arrive(t);
      c.success('Sold 3 cards for \$2,481.00',
          description: 'Credited to your available balance.');
      await arrive(t);
      c.error('Could not reach the vault',
          description: 'Nothing was charged. Try again in a moment.');
      await arrive(t);

      const String front = 'Could not reach the vault';
      const String back1 = 'Sold 3 cards for \$2,481.00';
      const String back2 = 'Added to favourites';
      final double h0 = heightOf(t, front);
      final double h1 = t.widget<DsToast>(toastWith(back1)).pinnedHeight!;

      await hover(t, t.getCenter(toastWith(front)));
      await t.pump(DsToaster.transition);
      await t.pump();

      // `--offset: heightIndex * gap + Σ(heights before)`. Measured on the
      // live stack: 107.875px for the second of three, at its own 75.6875px.
      final double h1Natural = heightOf(t, back1);
      expect(raise(t, back1), closeTo(DsToaster.gap + h0, 0.02));
      expect(scaleOf(t, back1), closeTo(1, 1e-6));
      expect(contentOpacityOf(t, back1), 1);
      expect(h1Natural, lessThan(h1),
          reason: 'it was pinned to the taller front toast and has now been '
              'let back down to its own height');

      expect(raise(t, back2), closeTo(2 * DsToaster.gap + h0 + h1Natural, 0.05));
      expect(scaleOf(t, back2), closeTo(1, 1e-6));
      expect(contentOpacityOf(t, back2), 1);

      // The front toast never moves: its own offset is zero.
      expect(raise(t, front), closeTo(0, 0.01));

      c.clear();
      await t.pump();
    });

    testWidgets('the host grows to cover the expanded stack, so crossing the '
        'gap does not collapse it', (WidgetTester t) async {
      final DsToastController c = DsToastController();
      addTearDown(c.dispose);
      await t.pumpWidget(toaster(c));
      c.show(const DsToastMessage(title: 'Added to favourites'));
      await arrive(t);
      c.success('Sold 3 cards for \$2,481.00');
      await arrive(t);

      final Finder stack = find.descendant(
          of: find.byType(DsToaster), matching: find.byType(Stack));
      final double collapsed = t.getRect(stack.first).height;

      final TestGesture g =
          await hover(t, t.getCenter(toastWith('Sold 3 cards for \$2,481.00')));
      await t.pump(DsToaster.transition);
      await t.pump();
      final double expanded = t.getRect(stack.first).height;
      expect(expanded, greaterThan(collapsed),
          reason: 'sonner bridges the gap with an ::after strip; the port '
              'gives the host the stack\'s own reach instead');

      // The 14px gap between two expanded toasts is inside the host, so the
      // pointer never leaves it.
      final Rect top = t.getRect(toastWith('Added to favourites'));
      await g.moveTo(Offset(top.center.dx, top.bottom + DsToaster.gap / 2));
      await t.pump();
      await t.pump(DsToaster.transition);
      expect(contentOpacityOf(t, 'Added to favourites'), 1,
          reason: 'a stack that collapsed in the gap would flicker');

      c.clear();
      await t.pump();
    });

    testWidgets('a blanked toast lays its content out and clips it, rather '
        'than squashing it', (WidgetTester t) async {
      final DsToastController c = DsToastController();
      addTearDown(c.dispose);
      await t.pumpWidget(toaster(c));
      // A two-line toast first, then a one-line one on top of it: the back
      // toast is now pinned SHORTER than it measures, which is the direction
      // that clips.
      c.success('Sold 3 cards for \$2,481.00',
          description: 'Credited to your available balance.');
      await arrive(t);
      final double tall = heightOf(t, 'Sold 3 cards for \$2,481.00');
      c.show(const DsToastMessage(title: 'Added to favourites'));
      await arrive(t);

      final double short = heightOf(t, 'Added to favourites');
      expect(short, lessThan(tall));
      expect(heightOf(t, 'Sold 3 cards for \$2,481.00'), closeTo(short, 0.01));
      // The description is still laid out at full size — `overflow: hidden`
      // clips the paint, it does not reflow the text.
      expect(find.text('Credited to your available balance.'), findsOneWidget);
      expect(
        t.getRect(find.text('Credited to your available balance.')).height,
        greaterThan(0),
      );
      c.clear();
      await t.pump();
    });
  });

  group('sonner choreography — the three exits and the swipe', () {
    Widget toaster(DsToastController c) => host(
          SizedBox(
            width: 1440,
            height: 900,
            child: DsToaster(controller: c),
          ),
        );

    Finder toastWith(String title) => find.ancestor(
          of: find.text(title),
          matching: find.byType(DsToast),
        );

    double anchor(WidgetTester t) =>
        t.getRect(find.byType(DsToaster)).bottom - DsToaster.viewportOffset;

    double raise(WidgetTester t, String title) =>
        anchor(t) - t.getRect(toastWith(title)).bottom;

    double scaleOf(WidgetTester t, String title) =>
        t.getRect(toastWith(title)).width / DsToaster.width;

    double heightOf(WidgetTester t, String title) =>
        t.getRect(toastWith(title)).height / scaleOf(t, title);

    double opacityOf(WidgetTester t, String title) => t
        .widget<Opacity>(
            find.ancestor(of: toastWith(title), matching: find.byType(Opacity)).first)
        .opacity;

    Future<void> arrive(WidgetTester t) async {
      await t.pump();
      await t.pump();
      await t.pump(DsToaster.transition);
      await t.pump();
    }

    testWidgets('the front leaves the way it came in, and is torn out '
        'mid-flight', (WidgetTester t) async {
      final DsToastController c = DsToastController();
      addTearDown(c.dispose);
      await t.pumpWidget(toaster(c));
      final int id = c.success('Preferences saved');
      await arrive(t);
      final double height = heightOf(t, 'Preferences saved');

      c.dismiss(id);
      await t.pump();
      await t.pump(DsToaster.unmountDelay ~/ 2);
      // `--y: translateY(--lift * -100%)` — the entrance, run backwards.
      final double t100 = DsCurves.cssEase.transform(
          DsToaster.unmountDelay.inMicroseconds /
              2 /
              DsToaster.transition.inMicroseconds);
      expect(raise(t, 'Preferences saved'), closeTo(-height * t100, 1.2));
      expect(opacityOf(t, 'Preferences saved'), closeTo(1 - t100, 0.03));

      // TIME_BEFORE_UNMOUNT is 200ms and the transition is 400ms, so the node
      // is torn out with the exit half-run. Measured on the live front exit:
      // the last frame before unmount read opacity 0.35.
      expect(opacityOf(t, 'Preferences saved'), greaterThan(0.2));
      await t.pump(DsToaster.unmountDelay ~/ 2);
      await t.pump();
      expect(find.byType(DsToast), findsNothing);
      expect(c.length, 0);
    });

    testWidgets('a back toast in a COLLAPSED stack falls 40% instead, on a '
        'longer transform window than its fade', (WidgetTester t) async {
      final DsToastController c = DsToastController();
      addTearDown(c.dispose);
      await t.pumpWidget(toaster(c));
      final int oldest = c.show(const DsToastMessage(title: 'Added to favourites'));
      await arrive(t);
      c.success('Sold 3 cards for \$2,481.00',
          description: 'Credited to your available balance.');
      await arrive(t);

      const String back = 'Added to favourites';
      expect(scaleOf(t, back), closeTo(1 - DsToaster.stackScaleStep, 1e-6));

      c.dismiss(oldest);
      await t.pump();
      await t.pump(DsToaster.unmountDelay ~/ 2);

      // `--y: translateY(40%)` with NO `scale()` in it — so the scale is
      // released back to 1 on the way out. Measured: 0.9 → 0.9019 → 0.9152 →
      // 0.9295 over the frames before the unmount.
      final double moved = DsCurves.cssEase.transform(
          DsToaster.unmountDelay.inMicroseconds /
              2 /
              DsToaster.collapsedExitTransform.inMicroseconds);
      expect(scaleOf(t, back),
          closeTo(1 - DsToaster.stackScaleStep * (1 - moved), 0.01));
      expect(
        raise(t, back),
        lessThan(DsToaster.gap),
        reason: 'it is falling, not lifting',
      );

      // `transition: transform 500ms, opacity 200ms` — the fade is more than
      // twice as far along as the fall.
      final double faded = DsCurves.cssEase.transform(0.5);
      expect(opacityOf(t, back), closeTo(1 - faded, 0.06));
      expect(1 - opacityOf(t, back), greaterThan(moved * 2),
          reason: 'it is gone well before it has finished falling');

      await t.pump(DsToaster.unmountDelay ~/ 2);
      await t.pump();
      expect(find.text(back), findsNothing);
      c.clear();
      await t.pump();
    });

    testWidgets('a back toast in an EXPANDED stack leaves through its own slot',
        (WidgetTester t) async {
      final DsToastController c = DsToastController();
      addTearDown(c.dispose);
      await t.pumpWidget(toaster(c));
      final int oldest = c.show(const DsToastMessage(title: 'Added to favourites'));
      await arrive(t);
      c.success('Sold 3 cards for \$2,481.00');
      await arrive(t);

      final TestGesture g = await t.createGesture(kind: PointerDeviceKind.mouse);
      await g.addPointer(location: Offset.zero);
      addTearDown(g.removePointer);
      await g.moveTo(t.getCenter(toastWith('Sold 3 cards for \$2,481.00')));
      await t.pump();
      await t.pump(DsToaster.transition);
      await t.pump();

      const String back = 'Added to favourites';
      final double offset = raise(t, back);
      final double height = heightOf(t, back);
      expect(offset, greaterThan(DsToaster.gap));

      c.dismiss(oldest);
      await t.pump();
      await t.pump(DsToaster.unmountDelay ~/ 2);

      // `--y: translateY(--lift * --offset + --lift * -100%)` — it keeps the
      // slot the expansion gave it and travels a whole box further down it.
      final double moved = DsCurves.cssEase.transform(
          DsToaster.unmountDelay.inMicroseconds /
              2 /
              DsToaster.transition.inMicroseconds);
      expect(raise(t, back), closeTo(offset - height * moved, 1.2));
      expect(scaleOf(t, back), closeTo(1, 1e-6));

      await t.pump(DsToaster.unmountDelay);
      await t.pump();
      expect(find.text(back), findsNothing);
      c.clear();
      await t.pump();
    });

    testWidgets('a swipe past the threshold throws it out; short of it the '
        'toast snaps home and survives', (WidgetTester t) async {
      final DsToastController c = DsToastController();
      addTearDown(c.dispose);
      await t.pumpWidget(toaster(c));
      c.warning('Only 12 packs left in this print run');
      await arrive(t);
      const String title = 'Only 12 packs left in this print run';
      final double home = t.getRect(toastWith(title)).left;

      // Short of SWIPE_THRESHOLD, and slowly: sonner writes the swipe amount
      // back to zero while `data-swiping` is still true, so it snaps with no
      // transition at all. Measured: the toast did not travel and survived.
      await t.drag(toastWith(title),
          Offset(DsToaster.swipeThreshold - 15, 0),
          touchSlopX: 0);
      await t.pump();
      expect(find.byType(DsToast), findsOneWidget);
      expect(t.getRect(toastWith(title)).left, closeTo(home, 0.01),
          reason: 'a snap, not a spring — there is no transition to ride');

      // Past it: `data-swipe-out` beats all three removal rules.
      await t.drag(
          toastWith(title), Offset(DsToaster.swipeThreshold + 15, 0),
          touchSlopX: 0);
      await t.pump();
      await t.pump(DsToaster.swipeOutDuration ~/ 2);
      expect(t.getRect(toastWith(title)).left,
          greaterThan(home + DsToaster.swipeThreshold + 15),
          reason: 'it keeps going in the direction it was thrown, a whole box '
              'further on');
      await t.pump(DsToaster.unmountDelay);
      await t.pump();
      expect(find.byType(DsToast), findsNothing);
      expect(c.length, 0);
    });

    testWidgets('a drag pulling back INTO the corner is dampened',
        (WidgetTester t) async {
      // `getDampening` — `1 / (1.5 + |delta| / 20)`. Only the corner's own two
      // directions travel one-for-one.
      expect(DsToaster.dampen(20), closeTo(20 / 2.5, 1e-9));
      expect(DsToaster.dampen(-20), closeTo(-20 / 2.5, 1e-9));
      expect(DsToaster.dampen(100), closeTo(100 / 6.5, 1e-9));

      final DsToastController c = DsToastController();
      addTearDown(c.dispose);
      await t.pumpWidget(toaster(c));
      c.warning('Only 12 packs left in this print run');
      await arrive(t);
      const String title = 'Only 12 packs left in this print run';
      final double home = t.getRect(toastWith(title)).left;

      // Left is *away* from a bottom-right toaster's swipe directions.
      await t.drag(toastWith(title), const Offset(-60, 0), touchSlopX: 0);
      await t.pump();
      expect(find.byType(DsToast), findsOneWidget,
          reason: '60px dampened to ${DsToaster.dampen(-60)} never reaches the '
              'threshold');
      expect(t.getRect(toastWith(title)).left, closeTo(home, 0.01));
      c.clear();
      await t.pump();
    });

    testWidgets('a fling under the threshold still dismisses, on velocity',
        (WidgetTester t) async {
      final DsToastController c = DsToastController();
      addTearDown(c.dispose);
      await t.pumpWidget(toaster(c));
      c.warning('Only 12 packs left in this print run');
      await arrive(t);
      expect(DsToaster.swipeVelocity, 110,
          reason: "sonner's 0.11 px/ms, in the units DragEndDetails speaks");

      await t.fling(
        toastWith('Only 12 packs left in this print run'),
        const Offset(120, 0),
        900,
      );
      await t.pump();
      await t.pump(DsToaster.unmountDelay);
      await t.pump();
      expect(find.byType(DsToast), findsNothing);
    });
  });

  group('sonner choreography — clocks, promise and reduced motion', () {
    Widget toaster(DsToastController c, {bool reducedMotion = false}) => host(
          SizedBox(
            width: 1440,
            height: 900,
            child: DsToaster(controller: c),
          ),
          reducedMotion: reducedMotion,
        );

    Finder toastWith(String title) => find.ancestor(
          of: find.text(title),
          matching: find.byType(DsToast),
        );

    Future<void> arrive(WidgetTester t) async {
      await t.pump();
      await t.pump();
      await t.pump(DsToaster.transition);
      await t.pump();
    }

    testWidgets('hover-pause resumes from the stored remainder, not from zero',
        (WidgetTester t) async {
      final DsToastController c = DsToastController();
      addTearDown(c.dispose);
      await t.pumpWidget(toaster(c));
      c.info('Saved as @ayoub');
      await t.pump();
      await t.pump();

      // A quarter of the way through the lifetime, park a pointer on it.
      await t.pump(DsToaster.lifetime ~/ 4);
      final TestGesture g = await t.createGesture(kind: PointerDeviceKind.mouse);
      await g.addPointer(location: Offset.zero);
      addTearDown(g.removePointer);
      await g.moveTo(t.getCenter(toastWith('Saved as @ayoub')));
      await t.pump();

      // Held for four whole lifetimes. A toast whose clock had not stopped
      // would be long gone.
      await t.pump(DsToaster.lifetime * 4);
      expect(find.byType(DsToast), findsOneWidget);

      await g.moveTo(const Offset(4, 4));
      await t.pump();
      // Three quarters were left, and three quarters are what is left. Measured
      // on the live page: hovered at +1062ms, released at +3844ms, gone at
      // +6798ms — a restart would have been +7700ms.
      await t.pump(DsToaster.lifetime ~/ 2);
      expect(find.byType(DsToast), findsOneWidget,
          reason: 'a restart would still be running here too — the next step '
              'is what tells them apart');
      await t.pump(DsToaster.lifetime ~/ 4);
      await t.pump(DsToaster.unmountDelay);
      await t.pump();
      expect(find.byType(DsToast), findsNothing,
          reason: 'a restart would have had a full quarter still to run');
    });

    testWidgets('a loading toast has no clock at all', (WidgetTester t) async {
      final DsToastController c = DsToastController();
      addTearDown(c.dispose);
      await t.pumpWidget(toaster(c));
      c.loading('Requesting withdrawal…');
      await arrive(t);
      await t.pump(DsToaster.lifetime * 3);
      expect(find.byType(DsToast), findsOneWidget,
          reason: "index.mjs returns before startTimer whenever the type is "
              "loading");
      c.clear();
      await t.pump();
    });

    testWidgets('toast.promise swaps in place — same toast, no second entrance',
        (WidgetTester t) async {
      final DsToastController c = DsToastController();
      addTearDown(c.dispose);
      await t.pumpWidget(toaster(c));
      final Completer<void> settled = Completer<void>();
      final int id = c.promise<void>(
        settled.future,
        loading: 'Requesting withdrawal…',
        success: 'Withdrawal requested',
        error: 'Request failed',
      );
      await arrive(t);

      expect(c.messageOf(id)!.type, DsToastType.loading);
      expect(c.messageOf(id)!.promise, isTrue);
      expect(t.widget<DsToast>(toastWith('Requesting withdrawal…'))
          .message.resolvedGlyph, DsIconGlyph.loaderCircle);
      final Rect before = t.getRect(toastWith('Requesting withdrawal…'));

      // The page's Promise button resolves after 1800ms.
      await t.pump(const Duration(milliseconds: 1800));
      settled.complete();
      await t.pump();
      await t.pump();

      expect(c.length, 1, reason: 'the same toast, not a second one');
      expect(c.messageOf(id)!.type, DsToastType.success);
      expect(find.text('Requesting withdrawal…'), findsNothing);
      expect(find.text('Withdrawal requested'), findsOneWidget);
      expect(t.getRect(toastWith('Withdrawal requested')), before,
          reason: 'same box, same slot — it never left and never re-entered');

      // The settled glyph crosses in over the loader rather than cutting.
      await t.pump(const Duration(milliseconds: 100));
      final DsToast mid = t.widget<DsToast>(toastWith('Withdrawal requested'));
      expect(mid.swapFrom, DsIconGlyph.loaderCircle);
      expect(mid.message.resolvedGlyph, DsIconGlyph.circleCheck);
      expect(mid.swapIn, greaterThan(0));
      expect(mid.swapIn, lessThan(1));
      expect(mid.swapOut, greaterThan(mid.swapIn),
          reason: 'the loader leaves over a shorter window than the glyph '
              'arrives over, so the two cross');

      // …and only now does the 4000ms clock start.
      await t.pump(const Duration(milliseconds: 300));
      expect(t.widget<DsToast>(toastWith('Withdrawal requested')).swapFrom,
          isNull);
      await t.pump(DsToaster.lifetime);
      await t.pump(DsToaster.unmountDelay);
      await t.pump();
      expect(find.byType(DsToast), findsNothing);
    });

    testWidgets('a rejected promise settles to the error toast',
        (WidgetTester t) async {
      final DsToastController c = DsToastController();
      addTearDown(c.dispose);
      await t.pumpWidget(toaster(c));
      final Completer<void> settled = Completer<void>();
      final int id = c.promise<void>(
        settled.future,
        loading: 'Requesting withdrawal…',
        success: 'Withdrawal requested',
        error: 'Request failed',
      );
      await arrive(t);
      settled.completeError(StateError('vault unreachable'));
      await t.pump();
      await t.pump();
      expect(c.messageOf(id)!.type, DsToastType.error);
      expect(find.text('Request failed'), findsOneWidget);
      c.clear();
      await t.pump();
    });

    testWidgets('the four missing controller methods fire their own types',
        (WidgetTester t) async {
      final DsToastController c = DsToastController();
      addTearDown(c.dispose);
      await t.pumpWidget(toaster(c));
      // The page fires neutral, success, error, warning and promise; `info`
      // and `loading` complete the set sonner exposes.
      expect(c.messageOf(c.info('i'))!.type, DsToastType.info);
      expect(c.messageOf(c.warning('w'))!.type, DsToastType.warning);
      expect(c.messageOf(c.loading('l'))!.type, DsToastType.loading);
      expect(c.messageOf(c.success('s'))!.type, DsToastType.success);
      expect(c.messageOf(c.error('e'))!.type, DsToastType.error);
      expect(c.messageOf(c.show(const DsToastMessage(title: 'n')))!.type,
          DsToastType.normal);
      c.clear();
      await t.pump();
    });

    testWidgets('reduced motion lands every leg on its final frame, and the '
        'clocks still run', (WidgetTester t) async {
      final DsToastController c = DsToastController();
      addTearDown(c.dispose);
      await t.pumpWidget(toaster(c, reducedMotion: true));
      c.success('Sold 3 cards for \$2,481.00');
      await t.pump();
      await t.pump();
      await t.pump();

      // Sonner ships its own `prefers-reduced-motion` block that removes the
      // transitions outright, where globals.css collapses them to 0.01ms —
      // drift 14, two regimes that disagree. The port has one switch and takes
      // sonner's reading. Measured under `prefers-reduced-motion: reduce`: the
      // toast appears already at matrix(1,0,0,1,0,0) / opacity 1.
      final double anchor =
          t.getRect(find.byType(DsToaster)).bottom - DsToaster.viewportOffset;
      expect(
        anchor - t.getRect(toastWith('Sold 3 cards for \$2,481.00')).bottom,
        closeTo(0, 0.01),
        reason: 'no entrance to run — it is simply there',
      );
      expect(
        t
            .widget<Opacity>(find
                .ancestor(
                    of: toastWith('Sold 3 cards for \$2,481.00'),
                    matching: find.byType(Opacity))
                .first)
            .opacity,
        1,
      );

      // The lifetime is NOT gated on dsAnimationDuration: sonner's block
      // removes transitions, not timers, and the live page confirms it.
      await t.pump(DsToaster.lifetime);
      await t.pump(DsToaster.unmountDelay);
      await t.pump();
      expect(find.byType(DsToast), findsNothing);
    });

    testWidgets('the title inherits .cn-toast\'s 1.5 and the description keeps '
        'sonner\'s own 1.4', (WidgetTester t) async {
      // `[data-title]` declares weight and colour and no leading, so it takes
      // `.cn-toast { line-height: 1.5 }` → 19.5px. `DsComponentType.buttonLabel`
      // is the same 13/500 on text-sm's surviving Tailwind ratio and is 0.93px
      // a line short of it.
      expect(DsToast.titleSpec.size, 13);
      expect(DsToast.titleSpec.height, DsType.small.height);
      expect(DsToast.titleSpec.weight, DsComponentType.buttonLabel.weight);
      expect(
          DsToast.titleSpec.height! * DsToast.titleSpec.size!, closeTo(19.5, 1e-9));
      expect(DsToast.titleSpec.height,
          isNot(closeTo(DsComponentType.buttonLabel.height!, 1e-6)),
          reason: 'the whole reason this spec exists');

      // `[data-description]`: `.cn-toast` sets its size and colour and never
      // its leading, so sonner's own 1.4 survives — drift 4, live numbers.
      expect(DsToast.descriptionSpec.size, 13);
      expect(DsToast.descriptionSpec.height! * DsToast.descriptionSpec.size!,
          closeTo(18.2, 1e-9));
      expect(DsToast.descriptionSpec.weight, DsType.small.weight);

      // And the box they add up to. Measured on the live toaster: 53.5px for a
      // title-only toast — 32 of padding and 2 of border around one 19.5 line.
      final DsToastController c = DsToastController();
      addTearDown(c.dispose);
      await t.pumpWidget(toaster(c));
      c.show(const DsToastMessage(title: 'Added to favourites'));
      await arrive(t);
      expect(t.getRect(toastWith('Added to favourites')).height,
          closeTo(53.5, 0.35));
      c.clear();
      await t.pump();
    });

    testWidgets('the toast carries an action pill, and pressing it dismisses',
        (WidgetTester t) async {
      final DsToastController c = DsToastController();
      addTearDown(c.dispose);
      await t.pumpWidget(toaster(c));
      bool retried = false;
      c.error(
        'Could not reach the vault',
        description: 'Nothing was charged. Try again in a moment.',
        action: DsToastAction(
          label: 'Retry',
          onPressed: () => retried = true,
        ),
      );
      await arrive(t);

      // `[data-button]` — 32px on a pill, `margin-left: auto`, and top-aligned
      // against `align-items: flex-start`.
      final Finder pill = find.ancestor(
        of: find.text('Retry'),
        matching: find.byType(AnimatedContainer),
      );
      final Rect box = t.getRect(pill);
      final Rect toast = t.getRect(toastWith('Could not reach the vault'));
      expect(box.height, closeTo(32, 1e-9));
      // padding 16 + the hairline.
      expect(toast.right - box.right, closeTo(17, 0.01),
          reason: 'margin-left: auto puts it hard against the right edge');
      expect(box.top - toast.top, closeTo(17, 0.01),
          reason: 'flex-start, not centred against a one-line title');

      final DsThemeData theme = DsTheme.of(t.element(find.byType(DsToast)));
      expect(
        t.widget<AnimatedContainer>(pill).decoration,
        isA<BoxDecoration>().having(
            (BoxDecoration d) => d.color, 'secondary, not outline', theme.secondary),
      );

      // The handler first, `deleteToast()` after — sonner's own order.
      await t.tap(find.text('Retry'));
      await t.pump();
      expect(retried, isTrue);
      await t.pump(DsToaster.unmountDelay);
      await t.pump();
      expect(find.byType(DsToast), findsNothing);
    });

    testWidgets(
        'the card shows the click cursor only while a tap would dismiss it',
        (WidgetTester t) async {
      // The tap-to-dismiss is the port's own affordance, not sonner's (see
      // [DsToast.onDismiss]), so the cursor that marks it is the port's own
      // choice too: click while a tap does something, basic while it does not.
      await t.pumpWidget(host(DsToast(
        message: const DsToastMessage(title: 'Saved'),
        onDismiss: () {},
      )));
      await t.pump();
      final MouseRegion enabled = t.widget<MouseRegion>(
        find.ancestor(
          of: find.byType(GestureDetector),
          matching: find.byType(MouseRegion),
        ).first,
      );
      expect(enabled.cursor, SystemMouseCursors.click);

      // No handler: the static-preview case the class doc names.
      await t.pumpWidget(host(const DsToast(
        message: DsToastMessage(title: 'Saved'),
      )));
      await t.pump();
      final MouseRegion disabled = t.widget<MouseRegion>(
        find.ancestor(
          of: find.byType(GestureDetector),
          matching: find.byType(MouseRegion),
        ).first,
      );
      expect(disabled.cursor, isNot(SystemMouseCursors.click));
      expect(disabled.cursor, SystemMouseCursors.basic);
    });

    testWidgets('a spinner keeps the 16px stroke at every box — drift 11',
        (WidgetTester t) async {
      // `Icon` computes strokeWidth from the size PROP and `spinner.tsx` never
      // passes one, so the className moves the box and leaves the stroke where
      // it was. Measured: 20px and 24px spinners still at 2.4.
      await t.pumpWidget(host(Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const DsSpinner(),
          DsSpinner(size: ds(5)),
          DsSpinner(size: ds(6)),
        ],
      )));
      final List<DsIcon> icons =
          t.widgetList<DsIcon>(find.byType(DsIcon)).toList();
      expect(icons, hasLength(3));
      for (final DsIcon icon in icons) {
        expect(icon.strokeOverride, closeTo(2.4, 1e-9));
      }
      // The ladder's own answer for the two larger boxes, which the reference
      // never reaches.
      expect(DsIcon.strokeFor(ds(5)), 2);
      expect(DsIcon.strokeFor(ds(6)), 2);
      expect(DsIcon.strokeFor(DsSpinner.px), closeTo(2.4, 1e-9));

      // …and a caller may still say otherwise.
      await t.pumpWidget(host(DsSpinner(size: ds(6), strokeOverride: 2)));
      expect(t.widget<DsIcon>(find.byType(DsIcon)).strokeOverride, 2);
    });

    testWidgets('sonner\'s two easings are CSS\'s, not the system\'s — F5',
        (WidgetTester t) async {
      // Both are foreign defaults, and both are visibly not the tokens whose
      // names they share. Measured against the live traces.
      expect(DsCurves.cssEase, const Cubic(0.25, 0.1, 0.25, 1));
      expect(DsCurves.cssEaseOut, const Cubic(0, 0, 0.58, 1));
      expect(DsCurves.all, isNot(contains(DsCurves.cssEase)),
          reason: 'the transcript of --ease-* has seven entries and neither of '
              'these is one of them');
      expect(DsCurves.all, isNot(contains(DsCurves.cssEaseOut)));
      // The retiming that snapping either to a system token would have caused.
      expect(DsCurves.cssEase.transform(0.2),
          isNot(closeTo(DsCurves.standard.transform(0.2), 0.05)));
      expect(DsCurves.cssEaseOut.transform(0.775),
          isNot(closeTo(DsCurves.out.transform(0.775), 0.02)));
      // The two numbers the live traces actually produced.
      expect(DsCurves.cssEase.transform(0.383), closeTo(0.645, 0.02));
      expect(DsCurves.cssEaseOut.transform(0.775), closeTo(0.923, 0.02));
    });
  });

  // ────────────────────────────────────────────────────────────────────────
  // The compact anchor — user-ordered top placement on a phone.
  //
  // What the reference does, measured before a line was written:
  // `styles.css` L425 is `@media (max-width: 600px)`, sonner's one breakpoint.
  // Inside it the toaster takes `left/right: var(--mobile-offset)` and
  // `width: 100%`, each toast takes `calc(100% - offset * 2)`, and the anchored
  // edge moves to the mobile offset — `MOBILE_VIEWPORT_OFFSET` 16px against
  // `VIEWPORT_OFFSET` 24px. The block has a rule for EACH of
  // `[data-y-position=bottom]` and `[data-y-position=top]` and moves neither:
  // it reskins whichever is already set. `app/layout.tsx:39` mounts
  // `<Toaster position="bottom-right" />` as a literal, with no `mobileOffset`
  // and no responsive override in the app, so the reference's own phone
  // behaviour is a BOTTOM stack at a 16px inset.
  //
  // The order was top-on-mobile and the order wins. Sonner's geometry is
  // adopted whole — 600px, 16px, full bleed — and only the anchored edge is
  // the port's own. These tests pin both halves of that.
  //
  // No `pumpAndSettle`: the bloom's forever loops are still running here.
  // ────────────────────────────────────────────────────────────────────────
  group('sonner choreography — the compact anchor', () {
    /// A phone: 375 × 812 in logical pixels, both as the media query the
    /// widget reads and as the surface it is laid out on.
    const Size phone = Size(375, 812);

    Widget toaster(
      DsToastController c, {
      Size viewport = const Size(1440, 900),
      DsToastPosition position = DsToastPosition.bottomRight,
      EdgeInsets bars = EdgeInsets.zero,
    }) =>
        host(
          SizedBox(
            width: viewport.width,
            height: viewport.height,
            child: DsToaster(controller: c, position: position),
          ),
          viewport: viewport,
          padding: bars,
        );

    /// An iPhone 14's own two obstructions, in logical pixels: the status bar
    /// and notch above, the gesture bar below.
    const EdgeInsets systemBars = EdgeInsets.only(top: 47, bottom: 34);

    /// Shrinks the test surface so a 375-wide host is not laid out inside an
    /// 800 × 600 window it overflows.
    void useSurface(WidgetTester t, Size size) {
      t.view.physicalSize = size;
      t.view.devicePixelRatio = 1;
      addTearDown(t.view.reset);
    }

    Finder toastWith(String title) => find.ancestor(
          of: find.text(title),
          matching: find.byType(DsToast),
        );

    /// The edge a compact stack hangs from — `top: 16px` inside the host.
    double topAnchor(WidgetTester t) =>
        t.getRect(find.byType(DsToaster)).top + DsToaster.mobileViewportOffset;

    /// How far a toast's own top edge sits BELOW that anchor. The mirror of
    /// the wide contract's `raise`, and positive in the direction the stack
    /// grows.
    double drop(WidgetTester t, String title) =>
        t.getRect(toastWith(title)).top - topAnchor(t);

    double scaleOf(WidgetTester t, String title) =>
        t.getRect(toastWith(title)).width / DsToaster.widthFor(phone.width);

    double heightOf(WidgetTester t, String title) =>
        t.getRect(toastWith(title)).height / scaleOf(t, title);

    double opacityOf(WidgetTester t, String title) => t
        .widget<Opacity>(
            find.ancestor(of: toastWith(title), matching: find.byType(Opacity)).first)
        .opacity;

    Future<void> arrive(WidgetTester t) async {
      await t.pump();
      await t.pump();
      await t.pump(DsToaster.transition);
      await t.pump();
    }

    test('the breakpoint and the offsets are sonner\'s own', () {
      // `@media (max-width: 600px)` — a max-width query is inclusive, so 600
      // itself is compact and 601 is not.
      expect(DsToaster.mobileBreakpoint, 600);
      expect(DsToaster.isCompact(600), isTrue);
      expect(DsToaster.isCompact(601), isFalse);
      expect(DsToaster.isCompact(375), isTrue);
      expect(DsToaster.isCompact(1440), isFalse);

      // MOBILE_VIEWPORT_OFFSET against VIEWPORT_OFFSET.
      expect(DsToaster.mobileViewportOffset, 16);
      expect(DsToaster.viewportOffset, 24);
      expect(DsToaster.offsetFor(375), DsToaster.mobileViewportOffset);
      expect(DsToaster.offsetFor(1440), DsToaster.viewportOffset);

      // `width: calc(100% - var(--mobile-offset-left) * 2)` against the
      // 356px box.
      expect(DsToaster.widthFor(375), 375 - 16 * 2);
      expect(DsToaster.widthFor(1440), DsToaster.width);
      expect(DsToaster.width, 356);
      // It tracks the viewport rather than swapping one constant for another:
      // narrower than the 356px box on a 375 phone, wider than it at the
      // breakpoint itself.
      expect(DsToaster.widthFor(375), lessThan(DsToaster.width));
      expect(DsToaster.widthFor(600), greaterThan(DsToaster.width));
      // A viewport narrower than its own two insets squeezes rather than
      // going negative, which would be an assertion in `Positioned`.
      expect(DsToaster.widthFor(20), 0);

      // The ordered departure, stated as an assertion so a later "fix" back to
      // the reference fails loudly. sonner's mobile block moves the x-position
      // and the offsets and NEVER the y-position; the app mounts bottom-right;
      // the reference therefore keeps its bottom stack on a phone. This port
      // does not.
      expect(DsToaster.positionFor(DsToastPosition.bottomRight, 375),
          DsToastPosition.topRight,
          reason: 'user-ordered top placement on small screens — the one place '
              'this file leaves the reference');
      expect(DsToaster.positionFor(DsToastPosition.bottomLeft, 375),
          DsToastPosition.topLeft,
          reason: 'the side survives the anchor swap; only the edge moves');
      expect(DsToaster.positionFor(DsToastPosition.bottomRight, 1440),
          DsToastPosition.bottomRight,
          reason: 'the wide contract is untouched');

      // `--lift` is the whole of the swap: every offset in the choreography is
      // a multiple of it, which is why there is one set of rules and not two.
      expect(DsToastPosition.bottomRight.lift, -1);
      expect(DsToastPosition.bottomRight.topAnchored.lift, 1);
    });

    // ──────────────────────────────────────────────────────────────────────
    // The system bars — user-ordered, and with no reference to port. sonner's
    // stylesheet never spells `env(safe-area-inset-*)` because a desktop
    // browser has no bar to clear; the compact anchor above is what creates the
    // problem, since 16px from `y = 0` on a phone is 16px INTO the status bar.
    // The ruling is `DsSafeArea`'s, corpus-wide: the anchored edge pays
    // `MediaQuery.padding` over sonner's own inset, and nothing else moves.
    // ──────────────────────────────────────────────────────────────────────
    test('the anchored edge pays the system bars over sonner\'s inset', () {
      // Compact is top-anchored, so the status bar is the one that is paid.
      final EdgeInsets compact = DsToaster.paddingFor(
          375, systemBars, DsToastPosition.topRight);
      expect(compact.top, 47 + DsToaster.mobileViewportOffset);
      expect(compact.bottom, DsToaster.mobileViewportOffset,
          reason: 'the stack does not reach the far edge; spending an inset '
              'there would only cap how far it could expand');
      expect(compact.left, DsToaster.mobileViewportOffset);
      expect(compact.right, DsToaster.mobileViewportOffset,
          reason: "the sides stay sonner's, because widthFor is 100% - 2 * 16 "
              'and the toast box is that same arithmetic');

      // The configured corner, not a pre-resolved one: which edge is anchored
      // at 375 is `positionFor`'s answer, so the app's literal `bottom-right`
      // pays the status bar it actually ends up under — the mistake a caller
      // would otherwise make silently, and in the direction that reproduces
      // the bug.
      expect(
        DsToaster.paddingFor(375, systemBars, DsToastPosition.bottomRight),
        DsToaster.paddingFor(375, systemBars, DsToastPosition.topRight),
      );
      expect(
          DsToaster.paddingFor(375, systemBars, DsToastPosition.bottomRight).top,
          47 + DsToaster.mobileViewportOffset);

      // The wide contract is bottom-anchored, so it is the gesture bar's turn.
      final EdgeInsets wide = DsToaster.paddingFor(
          1440, systemBars, DsToastPosition.bottomRight);
      expect(wide.bottom, 34 + DsToaster.viewportOffset);
      expect(wide.top, DsToaster.viewportOffset);
      expect(wide.right, DsToaster.viewportOffset);

      // Every desktop, every browser, every test that does not set
      // `view.padding`: sonner's number, unchanged, and no second code path.
      expect(
        DsToaster.paddingFor(1440, EdgeInsets.zero, DsToastPosition.bottomRight),
        EdgeInsets.all(DsToaster.viewportOffset),
      );
      expect(
        DsToaster.paddingFor(375, EdgeInsets.zero, DsToastPosition.topRight),
        EdgeInsets.all(DsToaster.mobileViewportOffset),
      );

      // `Padding` asserts on a negative inset, so a nonsense bar squeezes
      // rather than crashing — `widthFor`'s own argument.
      expect(
        DsToaster.paddingFor(375, const EdgeInsets.only(top: -100),
            DsToastPosition.topRight),
        EdgeInsets.all(DsToaster.mobileViewportOffset),
      );
    });

    testWidgets('a phone drops the stack BELOW the status bar, not under it',
        (WidgetTester t) async {
      useSurface(t, phone);
      final DsToastController c = DsToastController();
      addTearDown(c.dispose);
      await t.pumpWidget(toaster(c, viewport: phone, bars: systemBars));
      c.success('Sold 3 cards for \$2,481.00',
          description: 'Credited to your available balance.');
      await arrive(t);

      const String title = 'Sold 3 cards for \$2,481.00';
      final Rect toast = t.getRect(toastWith(title));
      final Rect screen = t.getRect(find.byType(DsToaster));

      // `MediaQuery.padding.top` + MOBILE_VIEWPORT_OFFSET. The whole ordered
      // change, in one number.
      expect(toast.top - screen.top,
          closeTo(systemBars.top + DsToaster.mobileViewportOffset, 0.01));
      expect(toast.top - screen.top, isNot(closeTo(16, 1)),
          reason: '16px from y = 0 is 16px INTO the status bar — the title '
              'lands under the clock, which is the screenshot that ordered '
              'this');
      expect(toast.top - screen.top, greaterThan(systemBars.top),
          reason: 'clear of the bar, not merely overlapping it less');

      // Nothing else moved: the two side insets and the full-bleed width are
      // still sonner's own arithmetic.
      expect(toast.left - screen.left,
          closeTo(DsToaster.mobileViewportOffset, 0.01));
      expect(screen.right - toast.right,
          closeTo(DsToaster.mobileViewportOffset, 0.01));
      expect(toast.width, closeTo(DsToaster.widthFor(phone.width), 0.01));

      c.clear();
      await t.pump();
    });

    testWidgets('a wide bottom stack clears the gesture bar the same way',
        (WidgetTester t) async {
      final DsToastController c = DsToastController();
      addTearDown(c.dispose);
      await t.pumpWidget(toaster(c, bars: systemBars));
      c.success('Sold 3 cards for \$2,481.00');
      await arrive(t);

      const String title = 'Sold 3 cards for \$2,481.00';
      final Rect toast = t.getRect(toastWith(title));
      final Rect screen = t.getRect(find.byType(DsToaster));

      // The bottom anchor pays `padding.bottom`; the sides keep VIEWPORT_OFFSET
      // and the box keeps its 356px.
      expect(screen.bottom - toast.bottom,
          closeTo(systemBars.bottom + DsToaster.viewportOffset, 0.01));
      expect(screen.bottom - toast.bottom, isNot(closeTo(24, 1)));
      expect(screen.right - toast.right,
          closeTo(DsToaster.viewportOffset, 0.01));
      expect(toast.width, closeTo(DsToaster.width, 0.01));

      c.clear();
      await t.pump();
    });

    testWidgets('a phone anchors the stack to the TOP, 16px down, full bleed '
        'between the two insets', (WidgetTester t) async {
      useSurface(t, phone);
      final DsToastController c = DsToastController();
      addTearDown(c.dispose);
      await t.pumpWidget(toaster(c, viewport: phone));
      c.success('Sold 3 cards for \$2,481.00',
          description: 'Credited to your available balance.');
      await arrive(t);

      const String title = 'Sold 3 cards for \$2,481.00';
      final Rect toast = t.getRect(toastWith(title));
      final Rect screen = t.getRect(find.byType(DsToaster));

      // Anchored to the top edge, at the mobile offset.
      expect(drop(t, title), closeTo(0, 0.01));
      expect(toast.top - screen.top,
          closeTo(DsToaster.mobileViewportOffset, 0.01));
      // And nowhere near the bottom, which is what it would be on the wide
      // contract and what the reference itself still does.
      expect(screen.bottom - toast.bottom,
          greaterThan(screen.height / 2),
          reason: 'a bottom anchor here would be the reference behaviour and '
              'the wrong one — the order was top');

      // `width: calc(100% - var(--mobile-offset-left) * 2)`, and the insets it
      // leaves on each side.
      expect(toast.width, closeTo(phone.width - 16 * 2, 0.01));
      expect(toast.width, closeTo(DsToaster.widthFor(phone.width), 0.01));
      expect(toast.left - screen.left,
          closeTo(DsToaster.mobileViewportOffset, 0.01));
      expect(screen.right - toast.right,
          closeTo(DsToaster.mobileViewportOffset, 0.01));
      // Full bleed is the viewport minus its insets, not a second fixed box —
      // narrower than 356 on a 375 phone and wider than it at the 600px
      // breakpoint, which a constant could not be both of.
      expect(toast.width, isNot(closeTo(DsToaster.width, 1)));
      expect(toast.width, closeTo(343, 0.01));

      c.clear();
      await t.pump();
    });

    testWidgets('it enters from the TOP edge — translateY(-100%) at opacity 0',
        (WidgetTester t) async {
      useSurface(t, phone);
      final DsToastController c = DsToastController();
      addTearDown(c.dispose);
      await t.pumpWidget(toaster(c, viewport: phone));
      c.success('Sold 3 cards for \$2,481.00');

      // `[data-y-position=top] { --y: translateY(-100%) }` — a whole box ABOVE
      // its resting place, and transparent. The sign is the anchor's, not a
      // second rule.
      await t.pump();
      const String title = 'Sold 3 cards for \$2,481.00';
      final double height = heightOf(t, title);
      expect(height, greaterThan(0));
      expect(drop(t, title), closeTo(-height, 0.01),
          reason: 'a bottom stack enters from +height; this one mirrors it');
      expect(opacityOf(t, title), 0);

      // `data-mounted="true"` — and it travels DOWNWARD into place, on the
      // same slow window and the same CSS ease as the wide contract.
      await t.pump();
      await t.pump(DsToaster.transition ~/ 2);
      final double half = DsCurves.cssEase.transform(0.5);
      expect(drop(t, title), closeTo(-height * (1 - half), 0.6));
      expect(drop(t, title), lessThan(0),
          reason: 'still above its slot, on its way down');
      expect(opacityOf(t, title), closeTo(half, 0.02));

      await t.pump(DsToaster.transition);
      expect(drop(t, title), closeTo(0, 0.01));
      expect(opacityOf(t, title), 1);
      c.clear();
      await t.pump();
    });

    testWidgets('the stack grows DOWNWARD, and expands downward too',
        (WidgetTester t) async {
      useSurface(t, phone);
      final DsToastController c = DsToastController();
      addTearDown(c.dispose);
      await t.pumpWidget(toaster(c, viewport: phone));
      c.success('Sold 3 cards for \$2,481.00');
      await arrive(t);
      c.info('Saved as @ayoub');
      await arrive(t);
      c.warning('Only 12 packs left in this print run');
      await arrive(t);

      // Collapsed: the same `--lift * gap * n` and `1 − 0.05n` as the wide
      // contract, with `--lift` now +1 — so every back toast sits BELOW the
      // front one instead of above it.
      const String front = 'Only 12 packs left in this print run';
      final double frontHeight = heightOf(t, front);
      expect(drop(t, front), closeTo(0, 0.01));
      for (final (int n, String title) in <(int, String)>[
        (1, 'Saved as @ayoub'),
        (2, 'Sold 3 cards for \$2,481.00'),
      ]) {
        final double scale = 1 - DsToaster.stackScaleStep * n;
        expect(scaleOf(t, title), closeTo(scale, 0.01));
        expect(drop(t, title),
            closeTo(DsToaster.gap * n + frontHeight * (1 - scale) / 2, 0.05),
            reason: 'positive is downward here — the stack hangs from the top');
        expect(drop(t, title), greaterThan(0));
        // Pinned to the front toast's measured height, as ever.
        expect(heightOf(t, title), closeTo(frontHeight, 0.05));
      }

      // Hovering lifts each toast to its own `--offset`, still downward.
      final TestGesture g = await t.createGesture(kind: PointerDeviceKind.mouse);
      await g.addPointer(location: Offset.zero);
      addTearDown(g.removePointer);
      await g.moveTo(t.getCenter(toastWith(front)));
      await t.pump();
      await t.pump(DsToaster.transition);
      await t.pump();

      final double h0 = heightOf(t, front);
      expect(scaleOf(t, 'Saved as @ayoub'), closeTo(1, 0.01));
      expect(drop(t, 'Saved as @ayoub'), closeTo(DsToaster.gap + h0, 0.05),
          reason: 'expanded offset = n * gap + Σ heights before, downward');
      final double h1 = heightOf(t, 'Saved as @ayoub');
      expect(drop(t, 'Sold 3 cards for \$2,481.00'),
          closeTo(2 * DsToaster.gap + h0 + h1, 0.1));

      c.clear();
      await t.pump();
    });

    testWidgets('the swipe follows the anchor — up dismisses, down is dampened',
        (WidgetTester t) async {
      useSurface(t, phone);
      final DsToastController c = DsToastController();
      addTearDown(c.dispose);
      await t.pumpWidget(toaster(c, viewport: phone));
      c.warning('Only 12 packs left in this print run');
      await arrive(t);
      const String title = 'Only 12 packs left in this print run';
      final double home = t.getRect(toastWith(title)).top;

      // DOWN is away from a top toaster's own direction, so it is dampened by
      // `1 / (1.5 + |delta| / 20)` and 60px lands at 13.3 — nowhere near the
      // 45px threshold. On the wide bottom-right contract this same drag is
      // the one that dismisses.
      expect(DsToaster.dampen(60), lessThan(DsToaster.swipeThreshold));
      await t.drag(toastWith(title), const Offset(0, 60), touchSlopY: 0);
      await t.pump();
      expect(find.byType(DsToast), findsOneWidget);
      expect(t.getRect(toastWith(title)).top, closeTo(home, 0.01),
          reason: 'released short, it snaps home with no transition at all');

      // UP travels 1:1 and clears the threshold.
      await t.drag(toastWith(title), const Offset(0, -60), touchSlopY: 0);
      await t.pump();
      await t.pump(DsToaster.swipeOutDuration ~/ 2);
      expect(t.getRect(toastWith(title)).top, lessThan(home - 60),
          reason: 'the swipe-out keyframe carries it a further 100% upward');
      await t.pump(DsToaster.unmountDelay);
      await t.pump();
      expect(find.byType(DsToast), findsNothing);
    });

    testWidgets('the hover-pause, the collapse reset and the exits all still '
        'run compact', (WidgetTester t) async {
      useSurface(t, phone);
      final DsToastController c = DsToastController();
      addTearDown(c.dispose);
      await t.pumpWidget(toaster(c, viewport: phone));
      c.info('Saved as @ayoub');
      await t.pump();
      await t.pump();

      // The clock is the clock whatever edge the toast hangs from.
      await t.pump(DsToaster.lifetime ~/ 4);
      final TestGesture g = await t.createGesture(kind: PointerDeviceKind.mouse);
      await g.addPointer(location: Offset.zero);
      addTearDown(g.removePointer);
      await g.moveTo(t.getCenter(toastWith('Saved as @ayoub')));
      await t.pump();
      await t.pump(DsToaster.lifetime * 4);
      expect(find.byType(DsToast), findsOneWidget,
          reason: 'pauseTimer holds the remainder, compact or not');

      await g.moveTo(const Offset(4, 4));
      await t.pump();
      await t.pump(DsToaster.lifetime ~/ 2);
      expect(find.byType(DsToast), findsOneWidget);
      await t.pump(DsToaster.lifetime ~/ 4);

      // The front exit leaves the way it came in — upward, out of the top.
      const String title = 'Saved as @ayoub';
      final double home = t.getRect(toastWith(title)).top;
      await t.pump(DsToaster.unmountDelay ~/ 2);
      expect(t.getRect(toastWith(title)).top, lessThan(home),
          reason: '--y: translateY(--lift * -100%) with --lift = +1 is upward');
      await t.pump(DsToaster.unmountDelay);
      await t.pump();
      expect(find.byType(DsToast), findsNothing);
    });

    testWidgets('at 1440 the bottom-right contract is untouched',
        (WidgetTester t) async {
      final DsToastController c = DsToastController();
      addTearDown(c.dispose);
      await t.pumpWidget(toaster(c));
      c.success('Sold 3 cards for \$2,481.00');
      await arrive(t);

      const String title = 'Sold 3 cards for \$2,481.00';
      final Rect toast = t.getRect(toastWith(title));
      final Rect screen = t.getRect(find.byType(DsToaster));

      // 24px from the bottom and 24px from the right, at 356px wide — every
      // pin the wide contract already carries, restated here so a regression
      // in the responsive branch cannot pass by only breaking the phone.
      expect(screen.bottom - toast.bottom,
          closeTo(DsToaster.viewportOffset, 0.01));
      expect(screen.right - toast.right,
          closeTo(DsToaster.viewportOffset, 0.01));
      expect(toast.width, closeTo(DsToaster.width, 0.01));
      expect(toast.top - screen.top, greaterThan(screen.height / 2),
          reason: 'nowhere near the top edge');

      // And the entrance is still upward from below.
      c.clear();
      await t.pump();
      c.info('Saved as @ayoub');
      await t.pump();
      final Rect entering = t.getRect(toastWith('Saved as @ayoub'));
      expect(entering.bottom,
          greaterThan(screen.bottom - DsToaster.viewportOffset),
          reason: 'translateY(+100%) — below its slot, not above it');
      c.clear();
      await t.pump();
    });
  });
}
