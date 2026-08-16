/// The avatar family, against the numbers the live reference reports.
///
/// Probe: `scratchpad/ag-avatar-inv.js` → `ag-avatar-light.{json,txt}`, run at
/// 1440×900 on 2026-08-16 against
/// `http://localhost:3000/design-system/components/agent/avatar`. It walked all
/// twenty specimens in §states and read, per state: the `<svg>`'s viewBox and
/// resolved width, every polygon's `fill` / `stroke` / `stroke-width` /
/// `stroke-dasharray`, and the live `animation` shorthand on every animated
/// `<g>`. The idle cube was read separately for its `perspective`, face size and
/// six face transforms.
///
/// The painter carries **rendered-pixel** pins as well as geometry, per the
/// standing painter rule. Nothing here blurs a combined path: the cube is three
/// filled polygons and a stroke, and the ghost's dash is walked with
/// [ui.PathMetric] rather than approximated.
library;

import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget host(
  Widget child, {
  DsThemeMode mode = DsThemeMode.light,
  bool reduced = false,
}) =>
    MediaQuery(
      data: MediaQueryData(
        size: const Size(1440, 900),
        disableAnimations: reduced,
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: DsTheme(
          controller: DsThemeController(mode: mode),
          child: Center(child: child),
        ),
      ),
    );

/// The reference's own `lg` scale, which every §states measurement was read at.
const double _lg = 0.48;

/// Half a unit — every viewBox edge is a multiple of 0.5.
const double _exact = 1e-9;

/* ── The measured viewBoxes ──────────────────────────────────────────────── */

/// `svg[viewBox]` for each of the nineteen isometric scenes, read off the live
/// §states matrix. Not declared anywhere in the reference — `CubeScene` measures
/// them from the cubes, so these are the *output* of the geometry and the
/// tightest single check on it.
const Map<DsAgentState, (double, double, double, double)> _viewBoxes =
    <DsAgentState, (double, double, double, double)>{
  DsAgentState.queued: (-23, -10, 98, 72),
  DsAgentState.planning: (-36, -29.5, 98, 91.5),
  DsAgentState.retrieving: (-49, -10, 98, 72),
  DsAgentState.ingesting: (-36, -23, 72, 72),
  DsAgentState.running: (-62, -10, 124, 85),
  DsAgentState.delegating: (-36, -16.5, 124, 91.5),
  DsAgentState.awaitingApproval: (-49, -10, 98, 72),
  DsAgentState.validating: (-49, -10, 98, 72),
  DsAgentState.retrying: (-36, -23, 72, 72),
  DsAgentState.error: (-49, -10, 98, 72),
  DsAgentState.summarizing: (-49, -10, 98, 72),
  DsAgentState.thinking: (-49, -10, 98, 72),
  DsAgentState.processing: (-62, -10, 124, 85),
  DsAgentState.callingTools: (-36, -10, 124, 85),
  DsAgentState.searching: (-62, -23, 111, 98),
  DsAgentState.reading: (-36, -36, 85, 91.5),
  DsAgentState.recalling: (-49, -10, 111, 78.5),
  DsAgentState.writing: (-49, -10, 111, 78.5),
  DsAgentState.done: (-36, -23, 72, 72),
};

/// `svg[width]` at `lg`, as the browser resolved it. `scene.width × 0.48`.
const Map<DsAgentState, double> _svgWidths = <DsAgentState, double>{
  DsAgentState.queued: 91.2,
  DsAgentState.planning: 76.8,
  DsAgentState.retrieving: 80.64,
  DsAgentState.ingesting: 57.6,
  DsAgentState.running: 80.64,
  DsAgentState.delegating: 91.2,
  DsAgentState.awaitingApproval: 80.64,
  DsAgentState.validating: 80.64,
  DsAgentState.retrying: 57.6,
  DsAgentState.error: 80.64,
  DsAgentState.summarizing: 80.64,
  DsAgentState.thinking: 80.64,
  DsAgentState.processing: 80.64,
  DsAgentState.callingTools: 94.08,
  DsAgentState.searching: 80.64,
  DsAgentState.reading: 72,
  DsAgentState.recalling: 80.64,
  DsAgentState.writing: 80.64,
  DsAgentState.done: 52.8,
};

/// `<g>` count per state, straight off the probe.
///
/// One group per cube, **plus one** for each cube that carries an `outer`
/// wrapper — which is why `delegating` and `searching` report one more than
/// their cube counts and the other seventeen report exactly their own.
const Map<DsAgentState, int> _groupCounts = <DsAgentState, int>{
  DsAgentState.queued: 5,
  DsAgentState.planning: 20,
  DsAgentState.retrieving: 9,
  DsAgentState.ingesting: 8,
  DsAgentState.running: 16,
  DsAgentState.delegating: 10,
  DsAgentState.awaitingApproval: 9,
  DsAgentState.validating: 9,
  DsAgentState.retrying: 5,
  DsAgentState.error: 9,
  DsAgentState.summarizing: 9,
  DsAgentState.thinking: 9,
  DsAgentState.processing: 16,
  DsAgentState.callingTools: 12,
  DsAgentState.searching: 16,
  DsAgentState.reading: 18,
  DsAgentState.recalling: 12,
  DsAgentState.writing: 12,
  DsAgentState.done: 8,
};

/* ── Raster helpers ──────────────────────────────────────────────────────── */

/// One rasterised frame of [child], as an ARGB reader.
Future<Color Function(int, int)> _raster(
  WidgetTester t,
  Widget child, {
  DsThemeMode mode = DsThemeMode.light,
  bool reduced = false,
}) async {
  await t.pumpWidget(host(
    RepaintBoundary(key: const Key('raster'), child: child),
    mode: mode,
    reduced: reduced,
  ));
  await t.pump();

  final RenderRepaintBoundary box =
      t.renderObject(find.byKey(const Key('raster')));
  final ui.Image image = (await t.runAsync(() => box.toImage(pixelRatio: 1)))!;
  final ByteData bytes = (await t.runAsync(
    () async => (await image.toByteData(format: ui.ImageByteFormat.rawRgba))!,
  ))!;
  final int width = image.width;
  image.dispose();

  return (int x, int y) {
    final int i = (y * width + x) * 4;
    return Color.fromARGB(
      bytes.getUint8(i + 3),
      bytes.getUint8(i),
      bytes.getUint8(i + 1),
      bytes.getUint8(i + 2),
    );
  };
}

/// A fixed stage, so a pixel coordinate in this file is a stable number.
///
/// 120 × 100 with the scene centred: `queued` at `lg` is 91.2 × 67.02, so it
/// lands at (14.4, 16.49).
Widget _stage(Widget child) => SizedBox(
      width: 120,
      height: 100,
      child: Builder(
        builder: (BuildContext context) => ColoredBox(
          color: DsTheme.of(context).background,
          child: Center(child: child),
        ),
      ),
    );

void _expectColor(Color actual, Color expected, {int within = 1}) {
  int ch(double v) => (v * 255).round();
  expect(
    <int>[ch(actual.r), ch(actual.g), ch(actual.b), ch(actual.a)],
    <Matcher>[
      closeTo(ch(expected.r), within),
      closeTo(ch(expected.g), within),
      closeTo(ch(expected.b), within),
      closeTo(ch(expected.a), within),
    ],
  );
}

void main() {
  /* ── The projection ────────────────────────────────────────────────────── */

  group('the isometric unit', () {
    test('screenX = (x − y) · 13, screenY = (x + y) · 6.5 − z · 13', () {
      expect(DsAgentCube.iso(0, 0), Offset.zero);
      expect(DsAgentCube.iso(1, 0), const Offset(13, 6.5));
      expect(DsAgentCube.iso(0, 1), const Offset(-13, 6.5));
      expect(DsAgentCube.iso(1, 1), const Offset(0, 13));
      expect(DsAgentCube.iso(0, 0, 1), const Offset(0, -13));
      expect(DsAgentCube.iso(2, 0, 1.5), const Offset(26, -6.5));
    });

    test('the three faces are the reference\'s polygon strings', () {
      // "0,0 13,6.5 0,13 -13,6.5"
      expect(DsAgentCube.topFace, const <Offset>[
        Offset(0, 0),
        Offset(13, 6.5),
        Offset(0, 13),
        Offset(-13, 6.5),
      ]);
      // "-13,6.5 0,13 0,26 -13,19.5"
      expect(DsAgentCube.leftFace, const <Offset>[
        Offset(-13, 6.5),
        Offset(0, 13),
        Offset(0, 26),
        Offset(-13, 19.5),
      ]);
      // "13,6.5 0,13 0,26 13,19.5"
      expect(DsAgentCube.rightFace, const <Offset>[
        Offset(13, 6.5),
        Offset(0, 13),
        Offset(0, 26),
        Offset(13, 19.5),
      ]);
    });

    test('stroke is 0.8 on every polygon, dash is "3 2.5"', () {
      expect(DsAgentCube.strokeWidth, 0.8);
      expect(DsAgentCube.dash, <double>[3, 2.5]);
    });

    test('the painter\'s sort puts a boosted cube last', () {
      // `retrieving` — a 3×3 with the centre boosted out of the ordering.
      final DsAgentCubeScene scene = dsAgentCubeScene(DsAgentState.retrieving);
      final List<DsAgentCubeSpec> order = DsAgentCube.sorted(scene.cubes);
      expect(order.last.boost, 100);
      expect(order.last.x, 1);
      expect(order.last.y, 1);
      // Everything else ascends on x + y.
      for (int i = 1; i < order.length - 1; i += 1) {
        expect(
          order[i].x + order[i].y,
          greaterThanOrEqualTo(order[i - 1].x + order[i - 1].y),
        );
      }
    });

    test('z breaks a tie within one grid cell, bottom-up', () {
      // `done` — four columns of two, so every cell ties on x + y.
      final List<DsAgentCubeSpec> order =
          DsAgentCube.sorted(dsAgentCubeScene(DsAgentState.done).cubes);
      for (int i = 1; i < order.length; i += 1) {
        final double a = order[i - 1].x + order[i - 1].y;
        final double b = order[i].x + order[i].y;
        if (a == b) expect(order[i].z, greaterThanOrEqualTo(order[i - 1].z));
      }
    });
  });

  /* ── The scenes ────────────────────────────────────────────────────────── */

  group('the twenty scenes', () {
    test('idle is the one state with no recipe', () {
      expect(DsAgentState.values.length, 20);
      expect(
        () => dsAgentCubeScene(DsAgentState.idle),
        throwsA(isA<AssertionError>()),
      );
    });

    test('every viewBox is the one the browser resolved', () {
      for (final MapEntry<DsAgentState, (double, double, double, double)> e
          in _viewBoxes.entries) {
        final Rect box =
            DsAgentCube.viewBoxOf(dsAgentCubeScene(e.key).cubes);
        expect(
          <double>[box.left, box.top, box.width, box.height],
          <Matcher>[
            closeTo(e.value.$1, _exact),
            closeTo(e.value.$2, _exact),
            closeTo(e.value.$3, _exact),
            closeTo(e.value.$4, _exact),
          ],
          reason: e.key.wire,
        );
      }
      expect(_viewBoxes.length, 19);
    });

    test('scene.width × 0.48 is the rendered svg width at lg', () {
      for (final MapEntry<DsAgentState, double> e in _svgWidths.entries) {
        expect(
          dsAgentCubeScene(e.key).width * _lg,
          closeTo(e.value, 1e-9),
          reason: e.key.wire,
        );
      }
    });

    test('the cube counts are the probe\'s group counts', () {
      for (final MapEntry<DsAgentState, int> e in _groupCounts.entries) {
        final DsAgentCubeScene scene = dsAgentCubeScene(e.key);
        final int wrappers =
            scene.cubes.where((DsAgentCubeSpec c) => c.outer != null).length;
        expect(scene.cubes.length + wrappers, e.value, reason: e.key.wire);
      }
      // Only the two composed scenes carry an outer wrapper.
      expect(
        <DsAgentState>[
          for (final DsAgentState s in DsAgentState.values)
            if (s != DsAgentState.idle &&
                dsAgentCubeScene(s)
                    .cubes
                    .any((DsAgentCubeSpec c) => c.outer != null))
              s,
        ],
        <DsAgentState>[DsAgentState.delegating, DsAgentState.searching],
      );
    });

    test('error is the only scene that leaves the accent', () {
      for (final DsAgentState s in DsAgentState.values) {
        if (s == DsAgentState.idle) continue;
        final bool red =
            dsAgentCubeScene(s).cubes.any((DsAgentCubeSpec c) => c.red);
        expect(red, s == DsAgentState.error, reason: s.wire);
      }
    });

    test('two scenes hold a dashed cube — the slot and the hole', () {
      expect(
        <DsAgentState>[
          for (final DsAgentState s in DsAgentState.values)
            if (s != DsAgentState.idle &&
                dsAgentCubeScene(s)
                    .cubes
                    .any((DsAgentCubeSpec c) => c.dashed))
              s,
        ],
        <DsAgentState>[DsAgentState.awaitingApproval, DsAgentState.searching],
      );
    });

    test('queued: five cubes, the middle one accented, 0.22s apart', () {
      final DsAgentCubeScene scene = dsAgentCubeScene(DsAgentState.queued);
      expect(scene.width, 190);
      expect(scene.cubes.length, 5);
      expect(
        scene.cubes.map((DsAgentCubeSpec c) => c.accent).toList(),
        <bool>[false, false, true, false, false],
      );
      expect(
        scene.cubes.map((DsAgentCubeSpec c) => c.motion!.delay).toList(),
        <double>[0, 0.22, 0.44, 0.66, 0.88],
      );
      expect(scene.cubes.first.motion!.name, DsAgentCubeKeyframe.bob);
      expect(scene.cubes.first.motion!.seconds, 2.2);
    });

    test('searching drops two cells and dashes a third', () {
      final DsAgentCubeScene scene = dsAgentCubeScene(DsAgentState.searching);
      // 16 grid cells, two "gone", plus the scanner.
      expect(scene.cubes.length, 15);
      final DsAgentCubeSpec scanner = scene.cubes.last;
      expect(scanner.z, 1.5);
      expect(scanner.boost, 100);
      expect(scanner.outer!.name, DsAgentCubeKeyframe.glide);
      expect(scanner.outer!.alternate, isTrue);
      expect(scanner.outer!.seconds, 2.6);
      expect(scanner.motion!.name, DsAgentCubeKeyframe.bob);
      expect(scanner.motion!.seconds, 1.3);
    });

    test('reading lifts the two upper layers together', () {
      final DsAgentCubeScene scene = dsAgentCubeScene(DsAgentState.reading);
      expect(scene.cubes.length, 18);
      for (final DsAgentCubeSpec c in scene.cubes) {
        expect(
          c.motion?.name,
          switch (c.z) {
            0 => null,
            1 => DsAgentCubeKeyframe.lift,
            _ => DsAgentCubeKeyframe.lift2,
          },
        );
        // Same duration and phase on both lifted layers.
        if (c.motion != null) {
          expect(c.motion!.seconds, 2.2);
          expect(c.motion!.delay, 0);
        }
        expect(c.accent, c.z == 2);
      }
    });

    test('speed divides every duration and delay, at two decimals', () {
      // `(seconds / speed).toFixed(2)` — the reference formats the shorthand
      // and the browser parses that string, so 2.2 / 3 is 0.73 and not 0.7333.
      final DsAgentCubeScene fast =
          dsAgentCubeScene(DsAgentState.queued, speed: 3);
      expect(fast.cubes.first.motion!.seconds, 0.73);
      expect(fast.cubes[1].motion!.delay, 0.07);
      // The geometry does not move.
      expect(fast.width, 190);
      expect(
        DsAgentCube.viewBoxOf(fast.cubes),
        DsAgentCube.viewBoxOf(dsAgentCubeScene(DsAgentState.queued).cubes),
      );
    });
  });

  /* ── The keyframes ─────────────────────────────────────────────────────── */

  group('the fourteen keyframes', () {
    /// The translation at a CSS percentage.
    ///
    /// A [TweenSequence] divides the run by weight and reaches an internal stop
    /// through a float division, so a stop lands within ~1e-5 of its declared
    /// value rather than on it. The band is the arithmetic, not a tolerance on
    /// the number: 1e-4 of a pixel is four decimal places below anything the
    /// rasteriser can express.
    Matcher at(double value) => closeTo(value, 1e-4);
    double y(DsAgentCubeKeyframe k, double percent) =>
        DsAgentCubeKeyframes.translateAt(k, percent / 100).dy;

    test('the enum is the fourteen globals.css declares', () {
      expect(DsAgentCubeKeyframe.values.length, 14);
    });

    test('bob, settle, lift, lift2, pull, rise land on their stops', () {
      expect(y(DsAgentCubeKeyframe.bob, 0), at(0));
      expect(y(DsAgentCubeKeyframe.bob, 50), at(-5));
      expect(y(DsAgentCubeKeyframe.settle, 50), at(-3));
      expect(y(DsAgentCubeKeyframe.lift, 45), at(-6.5));
      expect(y(DsAgentCubeKeyframe.lift, 60), at(-6.5));
      expect(y(DsAgentCubeKeyframe.lift2, 45), at(-13));
      expect(y(DsAgentCubeKeyframe.pull, 25), at(-20));
      expect(y(DsAgentCubeKeyframe.pull, 40), at(-20));
      expect(y(DsAgentCubeKeyframe.pull, 60), at(0));
      expect(y(DsAgentCubeKeyframe.rise, 20), at(-11));
      expect(y(DsAgentCubeKeyframe.rise, 35), at(-11));
      expect(y(DsAgentCubeKeyframe.rise, 55), at(0));
    });

    test('shake crosses zero and bounce lands twice', () {
      expect(y(DsAgentCubeKeyframe.shake, 20), at(-2.5));
      expect(y(DsAgentCubeKeyframe.shake, 40), at(2.5));
      expect(y(DsAgentCubeKeyframe.shake, 60), at(-2));
      expect(y(DsAgentCubeKeyframe.shake, 80), at(2));
      expect(y(DsAgentCubeKeyframe.bounce, 35), at(-16));
      expect(y(DsAgentCubeKeyframe.bounce, 55), at(0));
      expect(y(DsAgentCubeKeyframe.bounce, 70), at(-6));
      expect(y(DsAgentCubeKeyframe.bounce, 82), at(0));
    });

    test('glide travels three half-widths across and three half-heights down',
        () {
      expect(DsAgentCubeKeyframes.glideTravel, const Offset(39, 19.5));
      expect(
        DsAgentCubeKeyframes.translateAt(DsAgentCubeKeyframe.glide, 1),
        const Offset(39, 19.5),
      );
      expect(
        DsAgentCubeKeyframes.translateAt(DsAgentCubeKeyframe.glide, 0),
        Offset.zero,
      );
      expect(DsAgentCubeKeyframes.glideTravel.dx, DsAgentCube.halfWidth * 3);
      expect(DsAgentCubeKeyframes.glideTravel.dy, DsAgentCube.halfHeight * 3);
    });

    test('appear and drop END at opacity 0 — the Game Boy cut', () {
      double a(DsAgentCubeKeyframe k, double p) =>
          DsAgentCubeKeyframes.opacityAt(k, p / 100);
      expect(a(DsAgentCubeKeyframe.appear, 0), at(0));
      expect(a(DsAgentCubeKeyframe.appear, 10), at(1));
      expect(a(DsAgentCubeKeyframe.appear, 93), at(1));
      expect(a(DsAgentCubeKeyframe.appear, 95), at(0));
      expect(a(DsAgentCubeKeyframe.appear, 100), at(0));
      expect(a(DsAgentCubeKeyframe.drop, 0), at(0));
      expect(a(DsAgentCubeKeyframe.drop, 18), at(1));
      expect(a(DsAgentCubeKeyframe.drop, 100), at(0));
      // Their transforms are declared only at the head of the table and HOLD.
      expect(y(DsAgentCubeKeyframe.appear, 0), at(8));
      expect(y(DsAgentCubeKeyframe.appear, 10), at(0));
      expect(y(DsAgentCubeKeyframe.appear, 99), at(0));
      expect(y(DsAgentCubeKeyframe.drop, 0), at(-24));
      expect(y(DsAgentCubeKeyframe.drop, 18), at(0));
    });

    test('the two blinks are opacity only', () {
      double a(DsAgentCubeKeyframe k, double p) =>
          DsAgentCubeKeyframes.opacityAt(k, p / 100);
      expect(a(DsAgentCubeKeyframe.blinkfade, 0), at(0.15));
      expect(a(DsAgentCubeKeyframe.blinkfade, 50), at(0.95));
      expect(a(DsAgentCubeKeyframe.blinkslow, 0), at(1));
      expect(a(DsAgentCubeKeyframe.blinkslow, 50), at(0.25));
      expect(y(DsAgentCubeKeyframe.blinkfade, 50), at(0));
      expect(y(DsAgentCubeKeyframe.blinkslow, 50), at(0));
    });

    test('every table eases on var(--ease-in-out), between adjacent stops', () {
      expect(DsAgentCubeKeyframes.curve, DsCurves.inOut);
      // A CSS timing function eases between stops, not across the run: `bob`
      // at 25% is the curve a quarter of the way to −5, not −2.5.
      expect(
        y(DsAgentCubeKeyframe.bob, 25),
        closeTo(-5 * DsCurves.inOut.transform(0.5), 1e-9),
      );
    });

    test('nothing declares a fill mode, so nothing holds', () {
      expect(DsAgentCubeKeyframes.fill, DsKeyframeFill.none);
    });
  });

  /* ── The clock ─────────────────────────────────────────────────────────── */

  group('the elapsed-time clock', () {
    test('a delayed animation shows the element\'s own style until it starts',
        () {
      const DsAgentCubeMotion plain =
          DsAgentCubeMotion(DsAgentCubeKeyframe.bob, 2, delay: 1);
      expect(plain.sampleAt(0.5).opacity, 1);
      expect(plain.sampleAt(0.5).translate, Offset.zero);
      // `appear` sets an inline `opacity: 0`, which is what the delay shows.
      const DsAgentCubeMotion appearing = DsAgentCubeMotion.appear(4, 2.1);
      expect(appearing.startsHidden, isTrue);
      expect(appearing.sampleAt(1).opacity, 0);
      expect(appearing.sampleAt(2.5).opacity, greaterThan(0));
    });

    test('the clock wraps rather than stopping', () {
      const DsAgentCubeMotion bob = DsAgentCubeMotion(
        DsAgentCubeKeyframe.bob,
        2,
      );
      expect(bob.sampleAt(1).translate.dy, -5);
      expect(bob.sampleAt(3).translate.dy, -5);
      expect(bob.sampleAt(101).translate.dy, -5);
    });

    test('alternate runs the second cycle backwards', () {
      const DsAgentCubeMotion glide = DsAgentCubeMotion(
        DsAgentCubeKeyframe.glide,
        2,
        alternate: true,
      );
      expect(glide.sampleAt(1.999).translate.dx, greaterThan(38));
      // Second cycle: the same clock, read from the other end.
      expect(glide.sampleAt(2.001).translate.dx, greaterThan(38));
      expect(glide.sampleAt(3).translate.dx, closeTo(19.5, 1e-6));
      expect(glide.sampleAt(3.999).translate.dx, lessThan(1));
    });
  });

  /* ── The tokens ────────────────────────────────────────────────────────── */

  group('the face palettes', () {
    final DsAgentCubeTokens light = DsAgentCubeTokens.light;

    test('the neutral trio and its stroke, light', () {
      final DsAgentCubeFaces n = DsAgentCubeFaces.neutral(light);
      _expectColor(n.top, dsHsl(240, 20, 99)); // rgb(252,252,253)
      _expectColor(n.left, dsHsl(240, 15, 94)); // rgb(237,237,242)
      _expectColor(n.right, dsHsl(240, 14, 90)); // rgb(226,226,233)
      _expectColor(n.stroke, dsHsl(240, 10, 79)); // rgb(196,196,207)
      expect(n.dash, isNull);
    });

    test('the accent is one value lit three ways, in oklab', () {
      final DsAgentCubeFaces a = DsAgentCubeFaces.accent(light, light.accent);
      // The left face IS the accent — `rgb(26, 110, 244)` on the live page.
      expect(a.left, DsPalette.action);
      // Measured `oklab(0.761057 −0.0199977 −0.117387)` / `oklab(0.608586
      // −0.0316453 −0.182568)` / `oklab(0.710687 −0.0141747 −0.103635)`. Read
      // back through [DsOklab] the port lands within 2e-5 of all three, which
      // is the 8-bit round trip and not a difference in the mix.
      for (final (Color got, double l, double aa, double bb) sample
          in <(Color, double, double, double)>[
        (a.top, 0.761057, -0.0199977, -0.117387),
        (a.right, 0.608586, -0.0316453, -0.182568),
        (a.stroke, 0.710687, -0.0141747, -0.103635),
      ]) {
        final ({double l, double c, double h}) o = DsOklab.toOklch(sample.$1);
        expect(o.l, closeTo(sample.$2, 5e-5));
        expect(
          o.c,
          closeTo(
            math.sqrt(sample.$3 * sample.$3 + sample.$4 * sample.$4),
            5e-5,
          ),
        );
      }
    });

    test('the ghost is that trio at 45% alpha, plus a dash', () {
      final DsAgentCubeFaces a = DsAgentCubeFaces.accent(light, light.accent);
      final DsAgentCubeFaces g = DsAgentCubeFaces.ghost(light, light.accent);
      // `color(srgb 0.101961 0.431373 0.956863 / 0.45)` — the same colour, not
      // a pre-composited one.
      for (final (Color ghost, Color lit) pair in <(Color, Color)>[
        (g.top, a.top),
        (g.left, a.left),
        (g.right, a.right),
      ]) {
        expect(pair.$1.a, closeTo(0.45, 1e-9));
        expect(pair.$1.r, pair.$2.r);
        expect(pair.$1.g, pair.$2.g);
        expect(pair.$1.b, pair.$2.b);
      }
      // The stroke is NOT at 45% — it is a separate oklab mix toward the ink.
      expect(g.stroke.a, 1);
      expect(g.dash, <double>[3, 2.5]);
      final ({double l, double c, double h}) o = DsOklab.toOklch(g.stroke);
      expect(o.l, closeTo(0.586043, 5e-5)); // oklab(0.586043 …)
    });

    test('the error trio, light', () {
      final DsAgentCubeFaces e = DsAgentCubeFaces.error(light);
      _expectColor(e.top, dsHsl(0, 70, 88)); // rgb(246,203,203)
      _expectColor(e.left, dsHsl(0, 65, 82)); // rgb(239,179,179)
      _expectColor(e.stroke, dsHsl(0, 55, 69)); // rgb(219,132,132)
      // PROBE CORRECTION. `--agent-cube-error-right: hsl(0 60% 75%)`
      // rasterises `rgb(230, 153, 153)` in Chrome and `rgb(229, 153, 153)`
      // here: the red channel lands on 0.9 × 255 = 229.5 exactly, and the two
      // implementations break that tie in opposite directions. One 8-bit step
      // on one channel of one token, in `dsHsl` rather than in this family.
      _expectColor(e.right, dsHsl(0, 60, 75), within: 1);
    });

    test('faces(cube): red beats dashed beats accent beats neutral', () {
      DsAgentCubeFaces of(DsAgentCubeSpec c) =>
          DsAgentCubeFaces.forCube(c, light, light.accent);
      expect(
        of(const DsAgentCubeSpec(x: 0, y: 0, red: true, accent: true)).left,
        DsAgentCubeFaces.error(light).left,
      );
      expect(
        of(const DsAgentCubeSpec(x: 0, y: 0, dashed: true, accent: true)).dash,
        isNotNull,
      );
      expect(
        of(const DsAgentCubeSpec(x: 0, y: 0)).left,
        DsAgentCubeFaces.neutral(light).left,
      );
    });

    test('FOLLOW-UP CLOSED: the twelve are theme tokens and ride the theme',
        () {
      // They used to be declared in `agent_avatar.dart` with a note saying they
      // should not be, and resolved by a `DsAgentCubeTokens.of(context)` that
      // did what `DsTheme.of` already does. They are `theme.dart`'s now, and
      // each block carries its own set — so a themed subtree resolves cubes the
      // way it resolves every other colour, and the two statics that every test
      // above spends are the same two objects.
      expect(DsThemeData.light.cube, same(DsAgentCubeTokens.light));
      expect(DsThemeData.dark.cube, same(DsAgentCubeTokens.dark));
      // The bite: the two sets must not be interchangeable, or the field could
      // be wired to either block and pass.
      expect(DsThemeData.light.cube.top, isNot(DsThemeData.dark.cube.top));
    });

    test('dark is the inversion, not a recolour of light', () {
      expect(DsAgentCubeTokens.dark.accent, DsPalette.actionBright);
      expect(DsAgentCubeTokens.light.accent, DsPalette.action);
      // The dark top face is darker than its own stroke; on light it is
      // lighter — which is the inversion stated in globals.css.
      expect(
        DsOklab.toOklch(DsAgentCubeTokens.dark.top).l,
        lessThan(DsOklab.toOklch(DsAgentCubeTokens.dark.stroke).l),
      );
      expect(
        DsOklab.toOklch(DsAgentCubeTokens.light.top).l,
        greaterThan(DsOklab.toOklch(DsAgentCubeTokens.light.stroke).l),
      );
    });
  });

  /* ── The painter, in pixels ────────────────────────────────────────────── */

  group('rendered pixels', () {
    // `queued` at lg on the 120 × 100 stage: viewBox (−23, −10, 98, 72), width
    // 91.2 so scale = 91.2 / 98 = 0.930612, box at (14.4, 16.49). A scene point
    // (vx, vy) lands at (14.4 + (vx + 23)·s, 16.49 + (vy + 10)·s).
    Widget queued() => _stage(DsCubeScene(
          scene: dsAgentCubeScene(DsAgentState.queued),
          width: dsAgentCubeScene(DsAgentState.queued).width * _lg,
          accent: DsAgentCubeTokens.light.accent,
          frozen: true,
        ));

    /// One cube alone at a scale of exactly 10: viewBox (−23, −10, 46, 46) at
    /// a width of 460, so a scene point `(vx, vy)` lands at
    /// `((vx + 23) · 10, (vy + 10) · 10)` and every face is unoccluded.
    Widget alone({bool dashed = false, bool accent = false, bool red = false}) =>
        Builder(builder: (BuildContext context) {
          return ColoredBox(
            color: DsTheme.of(context).background,
            child: DsCubeScene(
              scene: DsAgentCubeScene(
                cubes: <DsAgentCubeSpec>[
                  DsAgentCubeSpec(
                    x: 0,
                    y: 0,
                    dashed: dashed,
                    accent: accent,
                    red: red,
                  ),
                ],
                width: 460,
              ),
              width: 460,
              accent: DsAgentCubeTokens.light.accent,
              frozen: true,
            ),
          );
        });

    testWidgets('the accented cube paints its three lit faces',
        (WidgetTester tester) async {
      final Color Function(int, int) at =
          await _raster(tester, alone(accent: true));
      final DsAgentCubeFaces a = DsAgentCubeFaces.accent(
        DsAgentCubeTokens.light,
        DsAgentCubeTokens.light.accent,
      );
      _expectColor(at(230, 165), a.top); // top centre (0, 6.5)
      _expectColor(at(165, 262), a.left); // left centre (−6.5, 16.25)
      _expectColor(at(295, 262), a.right); // right centre (6.5, 16.25)
    });

    testWidgets('a neutral cube paints the neutral trio',
        (WidgetTester tester) async {
      final Color Function(int, int) at = await _raster(tester, alone());
      final DsAgentCubeFaces n =
          DsAgentCubeFaces.neutral(DsAgentCubeTokens.light);
      _expectColor(at(230, 165), n.top);
      _expectColor(at(165, 262), n.left);
      _expectColor(at(295, 262), n.right);
    });

    testWidgets('the error cube is the only one that leaves the accent',
        (WidgetTester tester) async {
      final Color Function(int, int) at =
          await _raster(tester, alone(red: true));
      final DsAgentCubeFaces e = DsAgentCubeFaces.error(DsAgentCubeTokens.light);
      _expectColor(at(230, 165), e.top);
      _expectColor(at(165, 262), e.left);
      _expectColor(at(295, 262), e.right);
    });

    testWidgets('the painter\'s sort hides a cube behind its nearer neighbour',
        (WidgetTester tester) async {
      final Color Function(int, int) at = await _raster(tester, queued());
      final DsAgentCubeFaces n =
          DsAgentCubeFaces.neutral(DsAgentCubeTokens.light);
      final DsAgentCubeFaces a = DsAgentCubeFaces.accent(
        DsAgentCubeTokens.light,
        DsAgentCubeTokens.light.accent,
      );
      // Scene point (30, 32) is inside the accented cube's RIGHT face and
      // inside its neighbour's LEFT face; the neighbour has the larger x + y,
      // so it draws later and the accent never reaches the canvas there.
      _expectColor(at(64, 56), n.left);
      // The last cube is the one with nothing in front of it — origin
      // (52, 26), right centre (58.5, 42.25).
      _expectColor(at(90, 65), n.right);
      // And the accented cube's own top face, which nothing covers.
      _expectColor(at(60, 44), a.top);
    });

    testWidgets('reduced motion freezes visible, not at stop 0',
        (WidgetTester tester) async {
      // `validating`'s ring runs `blinkfade`, whose stop 0 is opacity 0.15.
      // globals.css L3195–3215 says the freeze is `opacity: 1`, so a frozen
      // ring cube is the FULL accent and a running one at t = 0 is not.
      final DsAgentCubeScene scene = dsAgentCubeScene(DsAgentState.validating);
      Widget stage({required bool frozen}) => _stage(DsCubeScene(
            scene: scene,
            width: scene.width * _lg,
            accent: DsAgentCubeTokens.light.accent,
            frozen: frozen,
          ));

      final DsAgentCubeFaces a = DsAgentCubeFaces.accent(
        DsAgentCubeTokens.light,
        DsAgentCubeTokens.light.accent,
      );
      // viewBox (−49, −10, 98, 72), width 80.64, scale 0.822857, box at
      // (19.68, 20.37). Ring cube (0, 0): top centre (0, 6.5) → (60, 34).
      final Color Function(int, int) frozen =
          await _raster(tester, stage(frozen: true));
      _expectColor(frozen(60, 34), a.top);

      final Color Function(int, int) live =
          await _raster(tester, stage(frozen: false));
      final Color at0 = live(60, 34);
      expect(at0.r, greaterThan(a.top.r));
      expect(at0.b, greaterThan(a.top.b));
    });

    testWidgets('the ghost composites at 45%, over the background',
        (WidgetTester tester) async {
      // One dashed cube alone: viewBox (−23, −10, 46, 46), so a width of 460
      // is a scale of exactly 10 and the stage is the box.
      const DsAgentCubeScene one = DsAgentCubeScene(
        cubes: <DsAgentCubeSpec>[DsAgentCubeSpec(x: 0, y: 0, dashed: true)],
        width: 460,
      );
      late Color background;
      final Color Function(int, int) at = await _raster(
        tester,
        Builder(builder: (BuildContext context) {
          background = DsTheme.of(context).background;
          return ColoredBox(
            color: background,
            child: DsCubeScene(
              scene: one,
              width: 460,
              accent: DsAgentCubeTokens.light.accent,
              frozen: true,
            ),
          );
        }),
      );
      final DsAgentCubeFaces g = DsAgentCubeFaces.ghost(
        DsAgentCubeTokens.light,
        DsAgentCubeTokens.light.accent,
      );
      // Left face centre (−6.5, 16.25) → ((−6.5 + 23)·10, (16.25 + 10)·10).
      final Color painted = at(165, 262);
      final Color expected = Color.alphaBlend(g.left, background);
      _expectColor(painted, expected, within: 2);
    });

    testWidgets('the dash removes 3-in-5.5 of the stroke',
        (WidgetTester tester) async {
      // Same cube twice: dashed and solid. `stroke-dasharray: 3 2.5` is a
      // 3-unit mark in a 5.5-unit period, so the dashed stroke covers
      // 3 / 5.5 = 0.545 of the same outline. Counted rather than sampled,
      // because a per-pixel pin on a 0.8-unit stroke is an antialiasing pin.
      Future<int> strokePixels({required bool dashed}) async {
        final DsAgentCubeScene one = DsAgentCubeScene(
          cubes: <DsAgentCubeSpec>[
            DsAgentCubeSpec(x: 0, y: 0, dashed: dashed, accent: !dashed),
          ],
          width: 460,
        );
        final Color Function(int, int) at = await _raster(
          tester,
          Builder(builder: (BuildContext context) {
            return ColoredBox(
              color: DsTheme.of(context).background,
              child: DsCubeScene(
                scene: one,
                width: 460,
                accent: DsAgentCubeTokens.light.accent,
                frozen: true,
              ),
            );
          }),
        );
        final Color want = dashed
            ? DsAgentCubeFaces.ghost(
                DsAgentCubeTokens.light,
                DsAgentCubeTokens.light.accent,
              ).stroke
            : DsAgentCubeFaces.accent(
                DsAgentCubeTokens.light,
                DsAgentCubeTokens.light.accent,
              ).stroke;
        int count = 0;
        for (int y = 0; y < 460; y += 1) {
          for (int x = 0; x < 460; x += 1) {
            final Color c = at(x, y);
            if (((c.r - want.r).abs() * 255 < 6) &&
                ((c.g - want.g).abs() * 255 < 6) &&
                ((c.b - want.b).abs() * 255 < 6) &&
                c.a > 0.99) {
              count += 1;
            }
          }
        }
        return count;
      }

      final int solid = await strokePixels(dashed: false);
      final int dashed = await strokePixels(dashed: true);
      expect(solid, greaterThan(1000));
      expect(dashed / solid, closeTo(3 / 5.5, 0.08));
    });
  });

  /* ── Idle ──────────────────────────────────────────────────────────────── */

  group('idle, a real cube', () {
    test('the measured geometry at lg', () {
      // `perspective: 172.8px`, `face: 28.5px`, `translateZ: 14.256px`.
      expect(DsAgentCube.idlePerspective(_lg), closeTo(172.8, 1e-9));
      expect(DsAgentCube.idleFace(_lg), closeTo(28.512, 1e-9));
      expect(DsAgentCube.idleTranslateZ(_lg), closeTo(14.256, 1e-9));
      expect(DsCubeAvatar.spin.name, DsAgentCubeKeyframe.spin3d);
      expect(DsCubeAvatar.spin.seconds, 9);
    });

    testWidgets('at rest the accent face is square on to the viewer',
        (WidgetTester tester) async {
      final Color Function(int, int) at = await _raster(
        tester,
        _stage(const DsCubeAvatar(size: DsAgentAvatarSize.xl)),
        reduced: true,
      );
      // `translateZ(+half)` puts the accent face nearest the viewer, so the
      // centre pixel is the accent itself and not a mix.
      _expectColor(at(60, 50), DsPalette.action);
    });
  });

  /* ── The component ─────────────────────────────────────────────────────── */

  group('CubeAvatar', () {
    test('the four sizes are the page\'s own captions', () {
      expect(DsAgentAvatarSize.sm.box, 32);
      expect(DsAgentAvatarSize.md.box, 48);
      expect(DsAgentAvatarSize.lg.box, 80);
      expect(DsAgentAvatarSize.xl.box, 128);
      expect(DsAgentAvatarSize.sm.scale, 0.19);
      expect(DsAgentAvatarSize.md.scale, 0.29);
      expect(DsAgentAvatarSize.lg.scale, _lg);
      expect(DsAgentAvatarSize.xl.scale, 0.78);
    });

    testWidgets('the box is the size class, whatever the scene',
        (WidgetTester tester) async {
      for (final DsAgentAvatarSize size in DsAgentAvatarSize.values) {
        await tester.pumpWidget(host(
          DsCubeAvatar(state: DsAgentState.callingTools, size: size),
        ));
        await tester.pump();
        expect(
          tester.getSize(find.byType(DsCubeAvatar)),
          Size(size.box, size.box),
        );
      }
    });

    testWidgets('the scene is scene.width × scale wide',
        (WidgetTester tester) async {
      await tester.pumpWidget(host(
        const DsCubeAvatar(
          state: DsAgentState.thinking,
          size: DsAgentAvatarSize.lg,
        ),
      ));
      await tester.pump();
      expect(
        tester.getSize(find.byType(DsCubeScene)).width,
        closeTo(80.64, 1e-9),
      );
      // xl thinking measured 131.04 = 168 × 0.78.
      await tester.pumpWidget(host(
        const DsCubeAvatar(
          state: DsAgentState.thinking,
          size: DsAgentAvatarSize.xl,
        ),
      ));
      await tester.pump();
      expect(
        tester.getSize(find.byType(DsCubeScene)).width,
        closeTo(131.04, 1e-9),
      );
      // sm thinking measured 31.92.
      await tester.pumpWidget(host(
        const DsCubeAvatar(
          state: DsAgentState.thinking,
          size: DsAgentAvatarSize.sm,
        ),
      ));
      await tester.pump();
      expect(
        tester.getSize(find.byType(DsCubeScene)).width,
        closeTo(31.92, 1e-9),
      );
    });

    testWidgets('the outgoing scene is held for one fade and then dropped',
        (WidgetTester tester) async {
      await tester.pumpWidget(host(
        const DsCubeAvatar(
          state: DsAgentState.thinking,
          size: DsAgentAvatarSize.lg,
        ),
      ));
      await tester.pump();
      expect(find.byType(DsCubeScene), findsOneWidget);

      await tester.pumpWidget(host(
        const DsCubeAvatar(
          state: DsAgentState.writing,
          size: DsAgentAvatarSize.lg,
        ),
      ));
      await tester.pump();
      // Both scenes are mounted for the length of the crossfade.
      expect(find.byType(DsCubeScene), findsNWidgets(2));

      await tester.pump(DsCubeAvatar.crossfade);
      await tester.pump(DsCubeAvatar.crossfade);
      expect(find.byType(DsCubeScene), findsOneWidget);
    });

    test('the crossfade is --duration-fast', () {
      expect(DsCubeAvatar.crossfade, DsDurations.fast);
      expect(DsCubeAvatar.crossfade.inMilliseconds, 150);
    });

    testWidgets('idle gets its own branch, not a scene',
        (WidgetTester tester) async {
      await tester.pumpWidget(host(const DsCubeAvatar()));
      await tester.pump();
      expect(find.byType(DsCubeScene), findsNothing);
      expect(tester.getSize(find.byType(DsCubeAvatar)), const Size(48, 48));
    });

    testWidgets('the accessible name is the state label',
        (WidgetTester tester) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(host(
        const DsCubeAvatar(state: DsAgentState.awaitingApproval),
      ));
      await tester.pump();
      expect(
        tester.getSemantics(find.byType(DsCubeAvatar)).label,
        'Awaiting approval',
      );
      handle.dispose();
    });

    testWidgets('reduced motion never starts the clock',
        (WidgetTester tester) async {
      await tester.pumpWidget(host(
        const DsCubeAvatar(
          state: DsAgentState.summarizing,
          size: DsAgentAvatarSize.lg,
        ),
        reduced: true,
      ));
      await tester.pump();
      // No pending frames: a live ticker would keep the binding busy, and an
      // `appear` scene under the blanket rule would be frozen to nothing.
      expect(tester.binding.hasScheduledFrame, isFalse);
    });
  });
}
