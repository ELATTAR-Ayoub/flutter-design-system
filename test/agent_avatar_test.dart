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
import 'package:flutter/rendering.dart' hide ScrollDirection;
import 'package:flutter/widgets.dart'
    hide
        AspectRatio,
        Form,
        FormField,
        Icon,
        OverlayPortal,
        RadioGroup,
        RichText,
        SafeArea,
        ScrollPosition,
        Table,
        TableColumnWidth;
import 'package:flutter_test/flutter_test.dart';

Widget host(
  Widget child, {
  ColorMode mode = ColorMode.light,
  bool reduced = false,
}) => MediaQuery(
  data: MediaQueryData(size: const Size(1440, 900), disableAnimations: reduced),
  child: Directionality(
    textDirection: TextDirection.ltr,
    child: ThemeScope(
      controller: ThemeController(mode: mode),
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
const Map<AgentState, (double, double, double, double)> _viewBoxes =
    <AgentState, (double, double, double, double)>{
      AgentState.queued: (-23, -10, 98, 72),
      AgentState.planning: (-36, -29.5, 98, 91.5),
      AgentState.retrieving: (-49, -10, 98, 72),
      AgentState.ingesting: (-36, -23, 72, 72),
      AgentState.running: (-62, -10, 124, 85),
      AgentState.delegating: (-36, -16.5, 124, 91.5),
      AgentState.awaitingApproval: (-49, -10, 98, 72),
      AgentState.validating: (-49, -10, 98, 72),
      AgentState.retrying: (-36, -23, 72, 72),
      AgentState.error: (-49, -10, 98, 72),
      AgentState.summarizing: (-49, -10, 98, 72),
      AgentState.thinking: (-49, -10, 98, 72),
      AgentState.processing: (-62, -10, 124, 85),
      AgentState.callingTools: (-36, -10, 124, 85),
      AgentState.searching: (-62, -23, 111, 98),
      AgentState.reading: (-36, -36, 85, 91.5),
      AgentState.recalling: (-49, -10, 111, 78.5),
      AgentState.writing: (-49, -10, 111, 78.5),
      AgentState.done: (-36, -23, 72, 72),
    };

/// `svg[width]` at `lg`, as the browser resolved it. `scene.width × 0.48`.
const Map<AgentState, double> _svgWidths = <AgentState, double>{
  AgentState.queued: 91.2,
  AgentState.planning: 76.8,
  AgentState.retrieving: 80.64,
  AgentState.ingesting: 57.6,
  AgentState.running: 80.64,
  AgentState.delegating: 91.2,
  AgentState.awaitingApproval: 80.64,
  AgentState.validating: 80.64,
  AgentState.retrying: 57.6,
  AgentState.error: 80.64,
  AgentState.summarizing: 80.64,
  AgentState.thinking: 80.64,
  AgentState.processing: 80.64,
  AgentState.callingTools: 94.08,
  AgentState.searching: 80.64,
  AgentState.reading: 72,
  AgentState.recalling: 80.64,
  AgentState.writing: 80.64,
  AgentState.done: 52.8,
};

/// `<g>` count per state, straight off the probe.
///
/// One group per cube, **plus one** for each cube that carries an `outer`
/// wrapper — which is why `delegating` and `searching` report one more than
/// their cube counts and the other seventeen report exactly their own.
const Map<AgentState, int> _groupCounts = <AgentState, int>{
  AgentState.queued: 5,
  AgentState.planning: 20,
  AgentState.retrieving: 9,
  AgentState.ingesting: 8,
  AgentState.running: 16,
  AgentState.delegating: 10,
  AgentState.awaitingApproval: 9,
  AgentState.validating: 9,
  AgentState.retrying: 5,
  AgentState.error: 9,
  AgentState.summarizing: 9,
  AgentState.thinking: 9,
  AgentState.processing: 16,
  AgentState.callingTools: 12,
  AgentState.searching: 16,
  AgentState.reading: 18,
  AgentState.recalling: 12,
  AgentState.writing: 12,
  AgentState.done: 8,
};

/* ── Raster helpers ──────────────────────────────────────────────────────── */

/// One rasterised frame of [child], as an ARGB reader.
Future<Color Function(int, int)> _raster(
  WidgetTester t,
  Widget child, {
  ColorMode mode = ColorMode.light,
  bool reduced = false,
}) async {
  await t.pumpWidget(
    host(
      RepaintBoundary(key: const Key('raster'), child: child),
      mode: mode,
      reduced: reduced,
    ),
  );
  await t.pump();

  final RenderRepaintBoundary box = t.renderObject(
    find.byKey(const Key('raster')),
  );
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
      color: ThemeScope.of(context).background,
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
      expect(AgentCube.iso(0, 0), Offset.zero);
      expect(AgentCube.iso(1, 0), const Offset(13, 6.5));
      expect(AgentCube.iso(0, 1), const Offset(-13, 6.5));
      expect(AgentCube.iso(1, 1), const Offset(0, 13));
      expect(AgentCube.iso(0, 0, 1), const Offset(0, -13));
      expect(AgentCube.iso(2, 0, 1.5), const Offset(26, -6.5));
    });

    test('the three faces are the reference\'s polygon strings', () {
      // "0,0 13,6.5 0,13 -13,6.5"
      expect(AgentCube.topFace, const <Offset>[
        Offset(0, 0),
        Offset(13, 6.5),
        Offset(0, 13),
        Offset(-13, 6.5),
      ]);
      // "-13,6.5 0,13 0,26 -13,19.5"
      expect(AgentCube.leftFace, const <Offset>[
        Offset(-13, 6.5),
        Offset(0, 13),
        Offset(0, 26),
        Offset(-13, 19.5),
      ]);
      // "13,6.5 0,13 0,26 13,19.5"
      expect(AgentCube.rightFace, const <Offset>[
        Offset(13, 6.5),
        Offset(0, 13),
        Offset(0, 26),
        Offset(13, 19.5),
      ]);
    });

    test('stroke is 0.8 on every polygon, dash is "3 2.5"', () {
      expect(AgentCube.strokeWidth, 0.8);
      expect(AgentCube.dash, <double>[3, 2.5]);
    });

    test('the painter\'s sort puts a boosted cube last', () {
      // `retrieving` — a 3×3 with the centre boosted out of the ordering.
      final AgentCubeScene scene = agentCubeScene(AgentState.retrieving);
      final List<AgentCubeSpec> order = AgentCube.sorted(scene.cubes);
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
      final List<AgentCubeSpec> order = AgentCube.sorted(
        agentCubeScene(AgentState.done).cubes,
      );
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
      expect(AgentState.values.length, 20);
      expect(
        () => agentCubeScene(AgentState.idle),
        throwsA(isA<AssertionError>()),
      );
    });

    test('every viewBox is the one the browser resolved', () {
      for (final MapEntry<AgentState, (double, double, double, double)> e
          in _viewBoxes.entries) {
        final Rect box = AgentCube.viewBoxOf(agentCubeScene(e.key).cubes);
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
      for (final MapEntry<AgentState, double> e in _svgWidths.entries) {
        expect(
          agentCubeScene(e.key).width * _lg,
          closeTo(e.value, 1e-9),
          reason: e.key.wire,
        );
      }
    });

    test('the cube counts are the probe\'s group counts', () {
      for (final MapEntry<AgentState, int> e in _groupCounts.entries) {
        final AgentCubeScene scene = agentCubeScene(e.key);
        final int wrappers = scene.cubes
            .where((AgentCubeSpec c) => c.outer != null)
            .length;
        expect(scene.cubes.length + wrappers, e.value, reason: e.key.wire);
      }
      // Only the two composed scenes carry an outer wrapper.
      expect(
        <AgentState>[
          for (final AgentState s in AgentState.values)
            if (s != AgentState.idle &&
                agentCubeScene(
                  s,
                ).cubes.any((AgentCubeSpec c) => c.outer != null))
              s,
        ],
        <AgentState>[AgentState.delegating, AgentState.searching],
      );
    });

    test('error is the only scene that leaves the accent', () {
      for (final AgentState s in AgentState.values) {
        if (s == AgentState.idle) continue;
        final bool red = agentCubeScene(
          s,
        ).cubes.any((AgentCubeSpec c) => c.red);
        expect(red, s == AgentState.error, reason: s.wire);
      }
    });

    test('two scenes hold a dashed cube — the slot and the hole', () {
      expect(
        <AgentState>[
          for (final AgentState s in AgentState.values)
            if (s != AgentState.idle &&
                agentCubeScene(s).cubes.any((AgentCubeSpec c) => c.dashed))
              s,
        ],
        <AgentState>[AgentState.awaitingApproval, AgentState.searching],
      );
    });

    test('queued: five cubes, the middle one accented, 0.22s apart', () {
      final AgentCubeScene scene = agentCubeScene(AgentState.queued);
      expect(scene.width, 190);
      expect(scene.cubes.length, 5);
      expect(scene.cubes.map((AgentCubeSpec c) => c.accent).toList(), <bool>[
        false,
        false,
        true,
        false,
        false,
      ]);
      expect(
        scene.cubes.map((AgentCubeSpec c) => c.motion!.delay).toList(),
        <double>[0, 0.22, 0.44, 0.66, 0.88],
      );
      expect(scene.cubes.first.motion!.name, AgentCubeKeyframe.bob);
      expect(scene.cubes.first.motion!.seconds, 2.2);
    });

    test('searching drops two cells and dashes a third', () {
      final AgentCubeScene scene = agentCubeScene(AgentState.searching);
      // 16 grid cells, two "gone", plus the scanner.
      expect(scene.cubes.length, 15);
      final AgentCubeSpec scanner = scene.cubes.last;
      expect(scanner.z, 1.5);
      expect(scanner.boost, 100);
      expect(scanner.outer!.name, AgentCubeKeyframe.glide);
      expect(scanner.outer!.alternate, isTrue);
      expect(scanner.outer!.seconds, 2.6);
      expect(scanner.motion!.name, AgentCubeKeyframe.bob);
      expect(scanner.motion!.seconds, 1.3);
    });

    test('reading lifts the two upper layers together', () {
      final AgentCubeScene scene = agentCubeScene(AgentState.reading);
      expect(scene.cubes.length, 18);
      for (final AgentCubeSpec c in scene.cubes) {
        expect(c.motion?.name, switch (c.z) {
          0 => null,
          1 => AgentCubeKeyframe.lift,
          _ => AgentCubeKeyframe.lift2,
        });
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
      final AgentCubeScene fast = agentCubeScene(AgentState.queued, speed: 3);
      expect(fast.cubes.first.motion!.seconds, 0.73);
      expect(fast.cubes[1].motion!.delay, 0.07);
      // The geometry does not move.
      expect(fast.width, 190);
      expect(
        AgentCube.viewBoxOf(fast.cubes),
        AgentCube.viewBoxOf(agentCubeScene(AgentState.queued).cubes),
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
    double y(AgentCubeKeyframe k, double percent) =>
        AgentCubeKeyframes.translateAt(k, percent / 100).dy;

    test('the enum is the fourteen globals.css declares', () {
      expect(AgentCubeKeyframe.values.length, 14);
    });

    test('bob, settle, lift, lift2, pull, rise land on their stops', () {
      expect(y(AgentCubeKeyframe.bob, 0), at(0));
      expect(y(AgentCubeKeyframe.bob, 50), at(-5));
      expect(y(AgentCubeKeyframe.settle, 50), at(-3));
      expect(y(AgentCubeKeyframe.lift, 45), at(-6.5));
      expect(y(AgentCubeKeyframe.lift, 60), at(-6.5));
      expect(y(AgentCubeKeyframe.lift2, 45), at(-13));
      expect(y(AgentCubeKeyframe.pull, 25), at(-20));
      expect(y(AgentCubeKeyframe.pull, 40), at(-20));
      expect(y(AgentCubeKeyframe.pull, 60), at(0));
      expect(y(AgentCubeKeyframe.rise, 20), at(-11));
      expect(y(AgentCubeKeyframe.rise, 35), at(-11));
      expect(y(AgentCubeKeyframe.rise, 55), at(0));
    });

    test('shake crosses zero and bounce lands twice', () {
      expect(y(AgentCubeKeyframe.shake, 20), at(-2.5));
      expect(y(AgentCubeKeyframe.shake, 40), at(2.5));
      expect(y(AgentCubeKeyframe.shake, 60), at(-2));
      expect(y(AgentCubeKeyframe.shake, 80), at(2));
      expect(y(AgentCubeKeyframe.bounce, 35), at(-16));
      expect(y(AgentCubeKeyframe.bounce, 55), at(0));
      expect(y(AgentCubeKeyframe.bounce, 70), at(-6));
      expect(y(AgentCubeKeyframe.bounce, 82), at(0));
    });

    test(
      'glide travels three half-widths across and three half-heights down',
      () {
        expect(AgentCubeKeyframes.glideTravel, const Offset(39, 19.5));
        expect(
          AgentCubeKeyframes.translateAt(AgentCubeKeyframe.glide, 1),
          const Offset(39, 19.5),
        );
        expect(
          AgentCubeKeyframes.translateAt(AgentCubeKeyframe.glide, 0),
          Offset.zero,
        );
        expect(AgentCubeKeyframes.glideTravel.dx, AgentCube.halfWidth * 3);
        expect(AgentCubeKeyframes.glideTravel.dy, AgentCube.halfHeight * 3);
      },
    );

    test('appear and drop END at opacity 0 — the Game Boy cut', () {
      double a(AgentCubeKeyframe k, double p) =>
          AgentCubeKeyframes.opacityAt(k, p / 100);
      expect(a(AgentCubeKeyframe.appear, 0), at(0));
      expect(a(AgentCubeKeyframe.appear, 10), at(1));
      expect(a(AgentCubeKeyframe.appear, 93), at(1));
      expect(a(AgentCubeKeyframe.appear, 95), at(0));
      expect(a(AgentCubeKeyframe.appear, 100), at(0));
      expect(a(AgentCubeKeyframe.drop, 0), at(0));
      expect(a(AgentCubeKeyframe.drop, 18), at(1));
      expect(a(AgentCubeKeyframe.drop, 100), at(0));
      // Their transforms are declared only at the head of the table and HOLD.
      expect(y(AgentCubeKeyframe.appear, 0), at(8));
      expect(y(AgentCubeKeyframe.appear, 10), at(0));
      expect(y(AgentCubeKeyframe.appear, 99), at(0));
      expect(y(AgentCubeKeyframe.drop, 0), at(-24));
      expect(y(AgentCubeKeyframe.drop, 18), at(0));
    });

    test('the two blinks are opacity only', () {
      double a(AgentCubeKeyframe k, double p) =>
          AgentCubeKeyframes.opacityAt(k, p / 100);
      expect(a(AgentCubeKeyframe.blinkfade, 0), at(0.15));
      expect(a(AgentCubeKeyframe.blinkfade, 50), at(0.95));
      expect(a(AgentCubeKeyframe.blinkslow, 0), at(1));
      expect(a(AgentCubeKeyframe.blinkslow, 50), at(0.25));
      expect(y(AgentCubeKeyframe.blinkfade, 50), at(0));
      expect(y(AgentCubeKeyframe.blinkslow, 50), at(0));
    });

    test('every table eases on var(--ease-in-out), between adjacent stops', () {
      expect(AgentCubeKeyframes.curve, MotionCurves.move);
      // A CSS timing function eases between stops, not across the run: `bob`
      // at 25% is the curve a quarter of the way to −5, not −2.5.
      expect(
        y(AgentCubeKeyframe.bob, 25),
        closeTo(-5 * MotionCurves.move.transform(0.5), 1e-9),
      );
    });

    test('nothing declares a fill mode, so nothing holds', () {
      expect(AgentCubeKeyframes.fill, KeyframeFill.none);
    });
  });

  /* ── The clock ─────────────────────────────────────────────────────────── */

  group('the elapsed-time clock', () {
    test(
      'a delayed animation shows the element\'s own style until it starts',
      () {
        const AgentCubeMotion plain = AgentCubeMotion(
          AgentCubeKeyframe.bob,
          2,
          delay: 1,
        );
        expect(plain.sampleAt(0.5).opacity, 1);
        expect(plain.sampleAt(0.5).translate, Offset.zero);
        // `appear` sets an inline `opacity: 0`, which is what the delay shows.
        const AgentCubeMotion appearing = AgentCubeMotion.appear(4, 2.1);
        expect(appearing.startsHidden, isTrue);
        expect(appearing.sampleAt(1).opacity, 0);
        expect(appearing.sampleAt(2.5).opacity, greaterThan(0));
      },
    );

    test('the clock wraps rather than stopping', () {
      const AgentCubeMotion bob = AgentCubeMotion(AgentCubeKeyframe.bob, 2);
      expect(bob.sampleAt(1).translate.dy, -5);
      expect(bob.sampleAt(3).translate.dy, -5);
      expect(bob.sampleAt(101).translate.dy, -5);
    });

    test('alternate runs the second cycle backwards', () {
      const AgentCubeMotion glide = AgentCubeMotion(
        AgentCubeKeyframe.glide,
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
    final AgentCubeTokens light = AgentCubeTokens.light;

    test('the neutral trio and its stroke, light', () {
      final AgentCubeFaces n = AgentCubeFaces.neutral(light);
      _expectColor(n.top, hslColor(240, 20, 99)); // rgb(252,252,253)
      _expectColor(n.left, hslColor(240, 15, 94)); // rgb(237,237,242)
      _expectColor(n.right, hslColor(240, 14, 90)); // rgb(226,226,233)
      _expectColor(n.stroke, hslColor(240, 10, 79)); // rgb(196,196,207)
      expect(n.dash, isNull);
    });

    test('the accent is one value lit three ways, in oklab', () {
      final AgentCubeFaces a = AgentCubeFaces.accent(light, light.accent);
      // The left face IS the accent — `rgb(26, 110, 244)` on the live page.
      expect(a.left, Palette.action);
      // Measured `oklab(0.761057 −0.0199977 −0.117387)` / `oklab(0.608586
      // −0.0316453 −0.182568)` / `oklab(0.710687 −0.0141747 −0.103635)`. Read
      // back through [OklabColor] the port lands within 2e-5 of all three, which
      // is the 8-bit round trip and not a difference in the mix.
      for (final (Color got, double l, double aa, double bb) sample
          in <(Color, double, double, double)>[
            (a.top, 0.761057, -0.0199977, -0.117387),
            (a.right, 0.608586, -0.0316453, -0.182568),
            (a.stroke, 0.710687, -0.0141747, -0.103635),
          ]) {
        final ({double l, double c, double h}) o = OklabColor.toOklch(
          sample.$1,
        );
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
      final AgentCubeFaces a = AgentCubeFaces.accent(light, light.accent);
      final AgentCubeFaces g = AgentCubeFaces.ghost(light, light.accent);
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
      final ({double l, double c, double h}) o = OklabColor.toOklch(g.stroke);
      expect(o.l, closeTo(0.586043, 5e-5)); // oklab(0.586043 …)
    });

    test('the error trio, light', () {
      final AgentCubeFaces e = AgentCubeFaces.error(light);
      _expectColor(e.top, hslColor(0, 70, 88)); // rgb(246,203,203)
      _expectColor(e.left, hslColor(0, 65, 82)); // rgb(239,179,179)
      _expectColor(e.stroke, hslColor(0, 55, 69)); // rgb(219,132,132)
      // PROBE CORRECTION. `--agent-cube-error-right: hsl(0 60% 75%)`
      // rasterises `rgb(230, 153, 153)` in Chrome and `rgb(229, 153, 153)`
      // here: the red channel lands on 0.9 × 255 = 229.5 exactly, and the two
      // implementations break that tie in opposite directions. One 8-bit step
      // on one channel of one token, in `hslColor` rather than in this family.
      _expectColor(e.right, hslColor(0, 60, 75), within: 1);
    });

    test('faces(cube): red beats dashed beats accent beats neutral', () {
      AgentCubeFaces of(AgentCubeSpec c) =>
          AgentCubeFaces.forCube(c, light, light.accent);
      expect(
        of(const AgentCubeSpec(x: 0, y: 0, red: true, accent: true)).left,
        AgentCubeFaces.error(light).left,
      );
      expect(
        of(const AgentCubeSpec(x: 0, y: 0, dashed: true, accent: true)).dash,
        isNotNull,
      );
      expect(
        of(const AgentCubeSpec(x: 0, y: 0)).left,
        AgentCubeFaces.neutral(light).left,
      );
    });

    test('FOLLOW-UP CLOSED: the twelve are theme tokens and ride the theme', () {
      // They used to be declared in `agent_avatar.dart` with a note saying they
      // should not be, and resolved by a `AgentCubeTokens.of(context)` that
      // did what `ThemeScope.of` already does. They are `theme.dart`'s now, and
      // each block carries its own set — so a themed subtree resolves cubes the
      // way it resolves every other colour, and the two statics that every test
      // above spends are the same two objects.
      expect(ThemeTokens.light.cube, same(AgentCubeTokens.light));
      expect(ThemeTokens.dark.cube, same(AgentCubeTokens.dark));
      // The bite: the two sets must not be interchangeable, or the field could
      // be wired to either block and pass.
      expect(ThemeTokens.light.cube.top, isNot(ThemeTokens.dark.cube.top));
    });

    test('dark is the inversion, not a recolour of light', () {
      expect(AgentCubeTokens.dark.accent, Palette.actionBright);
      expect(AgentCubeTokens.light.accent, Palette.action);
      // The dark top face is darker than its own stroke; on light it is
      // lighter — which is the inversion stated in globals.css.
      expect(
        OklabColor.toOklch(AgentCubeTokens.dark.top).l,
        lessThan(OklabColor.toOklch(AgentCubeTokens.dark.stroke).l),
      );
      expect(
        OklabColor.toOklch(AgentCubeTokens.light.top).l,
        greaterThan(OklabColor.toOklch(AgentCubeTokens.light.stroke).l),
      );
    });
  });

  /* ── The painter, in pixels ────────────────────────────────────────────── */

  group('rendered pixels', () {
    // `queued` at lg on the 120 × 100 stage: viewBox (−23, −10, 98, 72), width
    // 91.2 so scale = 91.2 / 98 = 0.930612, box at (14.4, 16.49). A scene point
    // (vx, vy) lands at (14.4 + (vx + 23)·s, 16.49 + (vy + 10)·s).
    Widget queued() => _stage(
      CubeScene(
        scene: agentCubeScene(AgentState.queued),
        width: agentCubeScene(AgentState.queued).width * _lg,
        accent: AgentCubeTokens.light.accent,
        frozen: true,
      ),
    );

    /// One cube alone at a scale of exactly 10: viewBox (−23, −10, 46, 46) at
    /// a width of 460, so a scene point `(vx, vy)` lands at
    /// `((vx + 23) · 10, (vy + 10) · 10)` and every face is unoccluded.
    Widget alone({
      bool dashed = false,
      bool accent = false,
      bool red = false,
    }) => Builder(
      builder: (BuildContext context) {
        return ColoredBox(
          color: ThemeScope.of(context).background,
          child: CubeScene(
            scene: AgentCubeScene(
              cubes: <AgentCubeSpec>[
                AgentCubeSpec(
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
            accent: AgentCubeTokens.light.accent,
            frozen: true,
          ),
        );
      },
    );

    testWidgets('the accented cube paints its three lit faces', (
      WidgetTester tester,
    ) async {
      final Color Function(int, int) at = await _raster(
        tester,
        alone(accent: true),
      );
      final AgentCubeFaces a = AgentCubeFaces.accent(
        AgentCubeTokens.light,
        AgentCubeTokens.light.accent,
      );
      _expectColor(at(230, 165), a.top); // top centre (0, 6.5)
      _expectColor(at(165, 262), a.left); // left centre (−6.5, 16.25)
      _expectColor(at(295, 262), a.right); // right centre (6.5, 16.25)
    });

    testWidgets('a neutral cube paints the neutral trio', (
      WidgetTester tester,
    ) async {
      final Color Function(int, int) at = await _raster(tester, alone());
      final AgentCubeFaces n = AgentCubeFaces.neutral(AgentCubeTokens.light);
      _expectColor(at(230, 165), n.top);
      _expectColor(at(165, 262), n.left);
      _expectColor(at(295, 262), n.right);
    });

    testWidgets('the error cube is the only one that leaves the accent', (
      WidgetTester tester,
    ) async {
      final Color Function(int, int) at = await _raster(
        tester,
        alone(red: true),
      );
      final AgentCubeFaces e = AgentCubeFaces.error(AgentCubeTokens.light);
      _expectColor(at(230, 165), e.top);
      _expectColor(at(165, 262), e.left);
      _expectColor(at(295, 262), e.right);
    });

    testWidgets(
      'the painter\'s sort hides a cube behind its nearer neighbour',
      (WidgetTester tester) async {
        final Color Function(int, int) at = await _raster(tester, queued());
        final AgentCubeFaces n = AgentCubeFaces.neutral(AgentCubeTokens.light);
        final AgentCubeFaces a = AgentCubeFaces.accent(
          AgentCubeTokens.light,
          AgentCubeTokens.light.accent,
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
      },
    );

    testWidgets('reduced motion freezes visible, not at stop 0', (
      WidgetTester tester,
    ) async {
      // `validating`'s ring runs `blinkfade`, whose stop 0 is opacity 0.15.
      // globals.css L3195–3215 says the freeze is `opacity: 1`, so a frozen
      // ring cube is the FULL accent and a running one at t = 0 is not.
      final AgentCubeScene scene = agentCubeScene(AgentState.validating);
      Widget stage({required bool frozen}) => _stage(
        CubeScene(
          scene: scene,
          width: scene.width * _lg,
          accent: AgentCubeTokens.light.accent,
          frozen: frozen,
        ),
      );

      final AgentCubeFaces a = AgentCubeFaces.accent(
        AgentCubeTokens.light,
        AgentCubeTokens.light.accent,
      );
      // viewBox (−49, −10, 98, 72), width 80.64, scale 0.822857, box at
      // (19.68, 20.37). Ring cube (0, 0): top centre (0, 6.5) → (60, 34).
      final Color Function(int, int) frozen = await _raster(
        tester,
        stage(frozen: true),
      );
      _expectColor(frozen(60, 34), a.top);

      final Color Function(int, int) live = await _raster(
        tester,
        stage(frozen: false),
      );
      final Color at0 = live(60, 34);
      expect(at0.r, greaterThan(a.top.r));
      expect(at0.b, greaterThan(a.top.b));
    });

    testWidgets('the ghost composites at 45%, over the background', (
      WidgetTester tester,
    ) async {
      // One dashed cube alone: viewBox (−23, −10, 46, 46), so a width of 460
      // is a scale of exactly 10 and the stage is the box.
      const AgentCubeScene one = AgentCubeScene(
        cubes: <AgentCubeSpec>[AgentCubeSpec(x: 0, y: 0, dashed: true)],
        width: 460,
      );
      late Color background;
      final Color Function(int, int) at = await _raster(
        tester,
        Builder(
          builder: (BuildContext context) {
            background = ThemeScope.of(context).background;
            return ColoredBox(
              color: background,
              child: CubeScene(
                scene: one,
                width: 460,
                accent: AgentCubeTokens.light.accent,
                frozen: true,
              ),
            );
          },
        ),
      );
      final AgentCubeFaces g = AgentCubeFaces.ghost(
        AgentCubeTokens.light,
        AgentCubeTokens.light.accent,
      );
      // Left face centre (−6.5, 16.25) → ((−6.5 + 23)·10, (16.25 + 10)·10).
      final Color painted = at(165, 262);
      final Color expected = Color.alphaBlend(g.left, background);
      _expectColor(painted, expected, within: 2);
    });

    testWidgets('the dash removes 3-in-5.5 of the stroke', (
      WidgetTester tester,
    ) async {
      // Same cube twice: dashed and solid. `stroke-dasharray: 3 2.5` is a
      // 3-unit mark in a 5.5-unit period, so the dashed stroke covers
      // 3 / 5.5 = 0.545 of the same outline. Counted rather than sampled,
      // because a per-pixel pin on a 0.8-unit stroke is an antialiasing pin.
      Future<int> strokePixels({required bool dashed}) async {
        final AgentCubeScene one = AgentCubeScene(
          cubes: <AgentCubeSpec>[
            AgentCubeSpec(x: 0, y: 0, dashed: dashed, accent: !dashed),
          ],
          width: 460,
        );
        final Color Function(int, int) at = await _raster(
          tester,
          Builder(
            builder: (BuildContext context) {
              return ColoredBox(
                color: ThemeScope.of(context).background,
                child: CubeScene(
                  scene: one,
                  width: 460,
                  accent: AgentCubeTokens.light.accent,
                  frozen: true,
                ),
              );
            },
          ),
        );
        final Color want = dashed
            ? AgentCubeFaces.ghost(
                AgentCubeTokens.light,
                AgentCubeTokens.light.accent,
              ).stroke
            : AgentCubeFaces.accent(
                AgentCubeTokens.light,
                AgentCubeTokens.light.accent,
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
      expect(AgentCube.idlePerspective(_lg), closeTo(172.8, 1e-9));
      expect(AgentCube.idleFace(_lg), closeTo(28.512, 1e-9));
      expect(AgentCube.idleTranslateZ(_lg), closeTo(14.256, 1e-9));
      expect(AgentAvatar.spin.name, AgentCubeKeyframe.spin3d);
      expect(AgentAvatar.spin.seconds, 9);
    });

    testWidgets('at rest the accent face is square on to the viewer', (
      WidgetTester tester,
    ) async {
      final Color Function(int, int) at = await _raster(
        tester,
        _stage(const AgentAvatar(size: AgentAvatarSize.xl)),
        reduced: true,
      );
      // `translateZ(+half)` puts the accent face nearest the viewer, so the
      // centre pixel is the accent itself and not a mix.
      _expectColor(at(60, 50), Palette.action);
    });
  });

  /* ── The component ─────────────────────────────────────────────────────── */

  group('CubeAvatar', () {
    test('the four sizes are the page\'s own captions', () {
      expect(AgentAvatarSize.sm.box, 32);
      expect(AgentAvatarSize.md.box, 48);
      expect(AgentAvatarSize.lg.box, 80);
      expect(AgentAvatarSize.xl.box, 128);
      expect(AgentAvatarSize.sm.scale, 0.19);
      expect(AgentAvatarSize.md.scale, 0.29);
      expect(AgentAvatarSize.lg.scale, _lg);
      expect(AgentAvatarSize.xl.scale, 0.78);
    });

    testWidgets('the box is the size class, whatever the scene', (
      WidgetTester tester,
    ) async {
      for (final AgentAvatarSize size in AgentAvatarSize.values) {
        await tester.pumpWidget(
          host(AgentAvatar(state: AgentState.callingTools, size: size)),
        );
        await tester.pump();
        expect(
          tester.getSize(find.byType(AgentAvatar)),
          Size(size.box, size.box),
        );
      }
    });

    testWidgets('the scene is scene.width × scale wide', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        host(
          const AgentAvatar(
            state: AgentState.thinking,
            size: AgentAvatarSize.lg,
          ),
        ),
      );
      await tester.pump();
      expect(
        tester.getSize(find.byType(CubeScene)).width,
        closeTo(80.64, 1e-9),
      );
      // xl thinking measured 131.04 = 168 × 0.78.
      await tester.pumpWidget(
        host(
          const AgentAvatar(
            state: AgentState.thinking,
            size: AgentAvatarSize.xl,
          ),
        ),
      );
      await tester.pump();
      expect(
        tester.getSize(find.byType(CubeScene)).width,
        closeTo(131.04, 1e-9),
      );
      // sm thinking measured 31.92.
      await tester.pumpWidget(
        host(
          const AgentAvatar(
            state: AgentState.thinking,
            size: AgentAvatarSize.sm,
          ),
        ),
      );
      await tester.pump();
      expect(
        tester.getSize(find.byType(CubeScene)).width,
        closeTo(31.92, 1e-9),
      );
    });

    testWidgets('the outgoing scene is held for one fade and then dropped', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        host(
          const AgentAvatar(
            state: AgentState.thinking,
            size: AgentAvatarSize.lg,
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(CubeScene), findsOneWidget);

      await tester.pumpWidget(
        host(
          const AgentAvatar(
            state: AgentState.writing,
            size: AgentAvatarSize.lg,
          ),
        ),
      );
      await tester.pump();
      // Both scenes are mounted for the length of the crossfade.
      expect(find.byType(CubeScene), findsNWidgets(2));

      await tester.pump(AgentAvatar.crossfade);
      await tester.pump(AgentAvatar.crossfade);
      expect(find.byType(CubeScene), findsOneWidget);
    });

    test('the crossfade is --duration-fast', () {
      expect(AgentAvatar.crossfade, MotionDurations.fast);
      expect(AgentAvatar.crossfade.inMilliseconds, 150);
    });

    testWidgets('idle gets its own branch, not a scene', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(host(const AgentAvatar()));
      await tester.pump();
      expect(find.byType(CubeScene), findsNothing);
      expect(tester.getSize(find.byType(AgentAvatar)), const Size(48, 48));
    });

    testWidgets('the accessible name is the state label', (
      WidgetTester tester,
    ) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(
        host(const AgentAvatar(state: AgentState.awaitingApproval)),
      );
      await tester.pump();
      expect(
        tester.getSemantics(find.byType(AgentAvatar)).label,
        'Awaiting approval',
      );
      handle.dispose();
    });

    testWidgets('reduced motion never starts the clock', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        host(
          const AgentAvatar(
            state: AgentState.summarizing,
            size: AgentAvatarSize.lg,
          ),
          reduced: true,
        ),
      );
      await tester.pump();
      // No pending frames: a live ticker would keep the binding busy, and an
      // `appear` scene under the blanket rule would be frozen to nothing.
      expect(tester.binding.hasScheduledFrame, isFalse);
    });
  });
}
