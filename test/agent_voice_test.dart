/// The voice family — `VoiceIndicator`, `LiveWaveform`, `BarVisualizer`,
/// `MicControl`.
///
/// The orb is a painter over a fragment programme, so it is held to the
/// painter rule in full: **rendered pixels**, not recipe parameters. The
/// phase-3 lesson is the reason — 852 passing tests once sat over a socket bug
/// because they asserted the arguments a painter was given rather than what it
/// drew.
///
/// The pixel groups need the asset bundle (the shader and its perlin field are
/// assets), so they skip under `--no-test-assets` rather than failing there.
/// Run this file **without** that flag to exercise them:
///
/// ```
/// flutter test test/agent_voice_test.dart
/// ```
///
/// The skip is announced by the test name, and `the shader asset is reachable`
/// fails loudly if the bundle is present and the programme still will not
/// compile — the case that must never pass quietly. It caught a real one:
/// `(i % 2 == 1)` in the vendored GLSL compiles under Impeller and is rejected
/// outright by SkSL, and the only symptom was *"does not contain appropriate
/// runtime stage data for current backend (SkSL). Found stages: Vulkan"* — a
/// shader that had silently lost half its targets, not a toolchain limit.
library;

import 'dart:io';
import 'dart:ui' as ui;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart' show RenderRepaintBoundary;
import 'package:flutter/services.dart' show rootBundle;
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

/// The size the reference's own orb specimens are drawn at.
const double _orbSize = 112;

/// A seed with a known `splitmix32` expansion — see `the RNG` group.
const int _seed = 1234;

Future<void> _pumpOrb(
  WidgetTester tester, {
  VoiceIndicatorState state = VoiceIndicatorState.idle,
  bool reduced = true,
  double size = _orbSize,
  ValueListenable<double>? level,
}) async {
  await tester.pumpWidget(
    ThemeScope(
      controller: ThemeController(mode: ColorMode.light),
      child: MediaQuery(
        data: MediaQueryData(disableAnimations: reduced),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: VoiceIndicator(
              state: state,
              size: size,
              seed: _seed,
              level: level,
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

/// Rasterises the whole widget tree and hands back the pixels.
///
/// `toImage` awaits the real event loop, so it must sit inside `runAsync` — it
/// deadlocks silently under the test binding's fake async rather than failing.
Future<_Raster> _raster(WidgetTester tester, Finder finder) async {
  final RenderRepaintBoundary boundary = tester
      .renderObject<RenderRepaintBoundary>(finder);
  late _Raster raster;
  await tester.runAsync(() async {
    final ui.Image image = await boundary.toImage();
    final ByteData? data = await image.toByteData(
      format: ui.ImageByteFormat.rawRgba,
    );
    raster = _Raster(image.width, image.height, data!.buffer.asUint8List());
  });
  return raster;
}

/// Is there an asset bundle at all?
///
/// `flutter test --no-test-assets` is the standing invocation on this machine,
/// and without a bundle the shader cannot be compiled — so the pixel groups
/// skip rather than fail. Probing a **declared asset** rather than the shader
/// keeps the two failures apart: no bundle is a skip, a bundle whose shader
/// will not compile is a failure.
Future<bool> _bundlePresent(WidgetTester tester) async {
  bool present = false;
  await tester.runAsync(() async {
    for (final String key in <String>[
      'packages/elattar_design_system/assets/textures/perlin-noise.png',
      'assets/textures/perlin-noise.png',
    ]) {
      try {
        await rootBundle.load(key);
        present = true;
        return;
      } catch (_) {
        // try the other key
      }
    }
  });
  return present;
}

/// Why the pixel pins cannot run, or null when they can.
///
/// The only sanctioned reason is an absent bundle. A programme that will not
/// load **with** a bundle is a failure and is left to the test to assert: that
/// is how the SkSL rejection above was found, and reporting it as a skip would
/// have hidden a shader with one working backend out of two.
Future<String?> _shaderBlocked(WidgetTester tester) async {
  if (!await _bundlePresent(tester)) {
    return 'no asset bundle — run without --no-test-assets';
  }
  return null;
}

/// Swallow the orb's own load failure — and nothing else.
///
/// [VoiceIndicator] reports a programme it could not load through [FlutterError]
/// rather than swallowing it, which is right, and which means the failure lands
/// in whichever test pumped first. Matching on the recorded error object keeps
/// this from becoming a blanket catch: anything the orb did not raise rethrows.
void _drainStageError(WidgetTester tester) {
  final Object? thrown = tester.takeException();
  if (thrown == null) return;
  final Object? recorded = VoiceIndicatorProgram.lastError;
  if (recorded != null && thrown.toString() == recorded.toString()) return;
  throw thrown;
}

class _Raster {
  _Raster(this.width, this.height, this.bytes);

  final int width;
  final int height;
  final Uint8List bytes;

  /// Straight (un-premultiplied is not attempted — these are compared as
  /// composited pixels, which is what a reader sees).
  List<int> at(int x, int y) {
    final int i = (y * width + x) * 4;
    return <int>[bytes[i], bytes[i + 1], bytes[i + 2], bytes[i + 3]];
  }

  int alphaAt(int x, int y) => at(x, y)[3];
}

void main() {
  /* ── The vendored asset ────────────────────────────────────────────────── */

  group('shaders/orb.frag', () {
    test('the example app copy has not drifted', () {
      // `shaders:` is read only from the ROOT project, so the gallery declares
      // its own copy — an asset path may not climb above its project root and
      // a relative reference is not available. Two files, one source: this is
      // what stops the copy becoming a second one.
      final File package = File('shaders/orb.frag');
      final File app = File('example/shaders/orb.frag');
      expect(package.existsSync(), isTrue);
      expect(
        app.existsSync(),
        isTrue,
        reason:
            'example/shaders/orb.frag is the gallery copy — without '
            'it the orb silently paints nothing in a web build',
      );
      expect(
        app.readAsBytesSync(),
        package.readAsBytesSync(),
        reason: 'the two copies of the vendored shader have diverged',
      );
    });

    test('it carries no operator SkSL rejects', () {
      // `%` compiles under Impeller and is rejected outright by SkSL, and the
      // only symptom is a programme that quietly ships one backend's stage
      // data. Caught once on a web build; guarded here so it cannot come back
      // through an edit that is never built for the web before it lands.
      final String source = File('shaders/orb.frag').readAsStringSync();
      final Iterable<String> code = source
          .split('\n')
          .where((String line) => !line.trimLeft().startsWith('//'));
      expect(
        code.where((String line) => line.contains(' % ')),
        isEmpty,
        reason: 'SkSL does not allow the % operator',
      );
    });
  });

  /* ── The RNG ───────────────────────────────────────────────────────────── */

  group('splitmix32', () {
    test('reproduces the browser sequence bit for bit', () {
      // Generated by running the vendored `splitmix32(1234)` in node — the same
      // function `orb-vendor.tsx` L300 ships — and taking seven draws.
      const List<double> expected = <double>[
        4.552874018323385,
        3.87391890520909,
        0.6270742755891667,
        0.9888325916350938,
        0.4774192350903145,
        1.6596637490740256,
        3.1458267627574354,
      ];
      final List<double> actual = VoiceIndicator.offsetsForSeed(_seed);
      expect(actual, hasLength(7));
      for (int i = 0; i < 7; i++) {
        // Float32List storage is the only reason this is not exact: the
        // arithmetic itself is integer and identical.
        expect(
          actual[i],
          closeTo(expected[i], 1e-6),
          reason: 'offset $i drifted from the browser draw',
        );
      }
    });

    test('every draw lands inside one full turn', () {
      for (final int seed in <int>[0, 1, 0xFFFFFFFF, 987654321]) {
        for (final double offset in VoiceIndicator.offsetsForSeed(seed)) {
          expect(offset, inInclusiveRange(0, 6.283185307179587));
        }
      }
    });

    test('a seed is a seed — the same one twice gives the same phases', () {
      expect(
        VoiceIndicator.offsetsForSeed(7),
        VoiceIndicator.offsetsForSeed(7),
      );
      expect(
        VoiceIndicator.offsetsForSeed(7),
        isNot(equals(VoiceIndicator.offsetsForSeed(8))),
      );
    });
  });

  /* ── The disc ──────────────────────────────────────────────────────────── */

  group('VoiceIndicator geometry', () {
    test('the disc fraction is the measured one', () {
      // r3f's default camera: 75° fov at z = 5 gives a frustum
      // 2 · 5 · tan(37.5°) = 7.673270 tall, and the mesh is 7 across.
      expect(VoiceIndicator.discFraction, closeTo(7 / 7.673269879789604, 1e-9));
      // And what the browser actually rendered: 102px of a 112px canvas.
      expect((VoiceIndicator.discFraction * 112).round(), 102);
    });

    testWidgets('takes exactly the box it is given', (
      WidgetTester tester,
    ) async {
      await _pumpOrb(tester);
      _drainStageError(tester);
      // True whether or not the programme loaded: an orb that cannot draw is
      // still an orb-shaped hole, never a collapsed one.
      expect(tester.getSize(find.byType(VoiceIndicator)), const Size(112, 112));
    });

    testWidgets('a null level leaves the orb at rest and still drawn', (
      WidgetTester tester,
    ) async {
      // Reduced motion stops the clock; it must not blank the orb. The fade-in
      // ends rather than never starting.
      await _pumpOrb(tester, reduced: true);
      _drainStageError(tester);
      expect(tester.takeException(), isNull);
    });
  });

  /* ── Rendered pixels ───────────────────────────────────────────────────── */

  group('VoiceIndicator rendered pixels', () {
    setUp(VoiceIndicatorProgram.resetForTest);

    testWidgets('the shader asset is reachable and compiles', (
      WidgetTester tester,
    ) async {
      if (!await _bundlePresent(tester)) {
        markTestSkipped('no asset bundle — run without --no-test-assets');
        return;
      }
      final VoiceIndicatorProgram? loaded = await tester
          .runAsync<VoiceIndicatorProgram?>(() => VoiceIndicatorProgram.load());
      _drainStageError(tester);
      expect(
        loaded,
        isNotNull,
        reason:
            'the bundle is present, so shaders/orb.frag failing to load '
            'is a real failure — a stage-data complaint means the GLSL was '
            'rejected by one backend and accepted by the other',
      );
      expect(loaded!.noise.width, greaterThan(0));
    });

    testWidgets('paints a disc: opaque at the centre, clear at the corners', (
      WidgetTester tester,
    ) async {
      final String? blocked = await _shaderBlocked(tester);
      if (blocked != null) {
        markTestSkipped(blocked);
        return;
      }
      // Loaded before the pump so the widget picks the programme up in its
      // first build: an orb that is still waiting paints a bare box, and there
      // would be no boundary to rasterise.
      final VoiceIndicatorProgram? ready = await tester
          .runAsync<VoiceIndicatorProgram?>(() => VoiceIndicatorProgram.load());
      _drainStageError(tester);
      expect(ready, isNotNull, reason: 'the bundle is present');
      await _pumpOrb(tester);
      await tester.pump();

      final _Raster raster = await _raster(
        tester,
        find.byType(RepaintBoundary).last,
      );
      expect(raster.width, 112, reason: 'the boundary under test is the orb');
      const int mid = _orbSize ~/ 2;

      // The corners are outside the disc — the mesh upstream draws onto simply
      // has no geometry there.
      expect(raster.alphaAt(1, 1), 0);
      expect(raster.alphaAt(raster.width - 2, 1), 0);
      expect(raster.alphaAt(1, raster.height - 2), 0);

      // The centre is fully painted: `color.a` starts at 1 and only `uOpacity`
      // ever reduces it, and the entrance has finished.
      expect(raster.alphaAt(mid, mid), 255);
    });

    testWidgets('the disc edge lands where the reference measured it', (
      WidgetTester tester,
    ) async {
      final String? blocked = await _shaderBlocked(tester);
      if (blocked != null) {
        markTestSkipped(blocked);
        return;
      }
      // Loaded before the pump so the widget picks the programme up in its
      // first build: an orb that is still waiting paints a bare box, and there
      // would be no boundary to rasterise.
      final VoiceIndicatorProgram? ready = await tester
          .runAsync<VoiceIndicatorProgram?>(() => VoiceIndicatorProgram.load());
      _drainStageError(tester);
      expect(ready, isNotNull, reason: 'the bundle is present');
      await _pumpOrb(tester);
      await tester.pump();

      final _Raster raster = await _raster(
        tester,
        find.byType(RepaintBoundary).last,
      );
      const int mid = _orbSize ~/ 2;

      // 102px across a 112px box leaves 5px of clearance each side.
      int first = -1;
      int last = -1;
      for (int x = 0; x < raster.width; x++) {
        if (raster.alphaAt(x, mid) > 8) {
          if (first < 0) first = x;
          last = x;
        }
      }
      expect(
        last - first + 1,
        closeTo(102, 2),
        reason: 'the chord through the middle is the disc diameter',
      );
      expect(first, closeTo(5, 1));

      // The anti-assertion: a full-bleed square would have measured 112 and
      // started at 0. It must not.
      expect(last - first + 1, isNot(112));
      expect(first, isNot(0));
    });

    testWidgets('dark inverts the ramp rather than recolouring it', (
      WidgetTester tester,
    ) async {
      final String? blocked = await _shaderBlocked(tester);
      if (blocked != null) {
        markTestSkipped(blocked);
        return;
      }
      // Loaded before the pump so the widget picks the programme up in its
      // first build: an orb that is still waiting paints a bare box, and there
      // would be no boundary to rasterise.
      final VoiceIndicatorProgram? ready = await tester
          .runAsync<VoiceIndicatorProgram?>(() => VoiceIndicatorProgram.load());
      _drainStageError(tester);
      expect(ready, isNotNull, reason: 'the bundle is present');

      Future<_Raster> render(ColorMode mode) async {
        await tester.pumpWidget(
          ThemeScope(
            controller: ThemeController(mode: mode),
            child: const MediaQuery(
              data: MediaQueryData(disableAnimations: true),
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Center(
                  child: VoiceIndicator(size: _orbSize, seed: _seed),
                ),
              ),
            ),
          ),
        );
        await tester.pump();
        return _raster(tester, find.byType(RepaintBoundary).last);
      }

      final _Raster light = await render(ColorMode.light);
      final _Raster dark = await render(ColorMode.dark);
      const int mid = _orbSize ~/ 2;

      // `luminance = mix(color.r, 1.0 - color.r, uInverted)` — the same field,
      // read from the other end. An uncovered pixel ramps to white on light and
      // to black on dark, so the two rasters cannot be equal.
      expect(light.at(mid, mid), isNot(equals(dark.at(mid, mid))));
      // Both are still fully painted.
      expect(light.alphaAt(mid, mid), 255);
      expect(dark.alphaAt(mid, mid), 255);
    });
  });

  /* ── Waveform ──────────────────────────────────────────────────────────── */

  group('LiveWaveform', () {
    testWidgets('defaults are the component\'s own', (
      WidgetTester tester,
    ) async {
      expect(LiveWaveform.defaultWidth, 120);
      expect(LiveWaveform.defaultHeight, 28);
      expect(LiveWaveform.strokeWidth, 1.5);

      await tester.pumpWidget(
        _host(const LiveWaveform(width: 320, height: 48)),
      );
      expect(tester.getSize(find.byType(LiveWaveform)), const Size(320, 48));
    });

    testWidgets(
      'no stream draws a flat line at the midpoint, and nothing else',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          _host(const LiveWaveform(width: 320, height: 48)),
        );
        final _Raster raster = await _raster(
          tester,
          find.byType(RepaintBoundary).last,
        );

        // The line is 1.5 wide and centred on y = 24, so it spans 23.25–24.75:
        // row 23 takes 0.75 of a pixel and row 24 the other 0.75. Neither is
        // fully opaque, and that is the anti-aliased truth of a 1.5px stroke.
        final int inkRow = raster.height ~/ 2;
        expect(
          raster.alphaAt(raster.width ~/ 2, inkRow),
          greaterThan(150),
          reason: 'the resting line is drawn',
        );
        expect(
          raster.alphaAt(raster.width ~/ 2, inkRow - 1),
          greaterThan(150),
          reason: 'and it straddles the midpoint rather than sitting under it',
        );
        // …and the quarter heights are empty, which is what makes it a LINE
        // rather than a trace of invented data.
        expect(raster.alphaAt(raster.width ~/ 2, raster.height ~/ 4), 0);
        expect(raster.alphaAt(raster.width ~/ 2, raster.height * 3 ~/ 4), 0);
      },
    );

    testWidgets('a signal is drawn at 0.9 of the half height', (
      WidgetTester tester,
    ) async {
      // A square wave at full deflection: every sample at +1, so the trace
      // should sit at mid + mid·0.9 and nowhere near the middle.
      final ValueNotifier<Float32List> samples = ValueNotifier<Float32List>(
        Float32List.fromList(List<double>.filled(64, 1)),
      );
      addTearDown(samples.dispose);

      await tester.pumpWidget(
        _host(LiveWaveform(samples: samples, width: 320, height: 48)),
      );
      final _Raster raster = await _raster(
        tester,
        find.byType(RepaintBoundary).last,
      );

      // mid 24 + 24·0.9 = 45.6.
      expect(raster.alphaAt(160, 45), greaterThan(120));
      expect(
        raster.alphaAt(160, 24),
        0,
        reason: 'the resting line must be gone once there is a signal',
      );
    });
  });

  /* ── Bars ──────────────────────────────────────────────────────────────── */

  group('BarVisualizer', () {
    test('the reference constants', () {
      expect(BarVisualizer.defaultBars, 12);
      expect(BarVisualizer.defaultWidth, 96);
      expect(BarVisualizer.defaultHeight, 24);
      expect(BarVisualizer.gap, 2);
      expect(BarVisualizer.floor, 0.06);
      // `(w - gap · (bars - 1)) / bars` — the number every bar's radius is
      // derived from.
      const double barWidth = (96 - 2 * 11) / 12;
      expect(barWidth, closeTo(6.1667, 0.001));
    });

    testWidgets('at rest, twelve bars sit at the floor', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_host(const BarVisualizer()));
      final _Raster raster = await _raster(
        tester,
        find.byType(RepaintBoundary).last,
      );

      // Floor 0.06 × 24 = 1.44px tall, centred on 12 — so row 12 is inked and
      // rows 8 and 16 are not.
      int inked = 0;
      for (int x = 0; x < raster.width; x++) {
        if (raster.alphaAt(x, 12) > 40) inked++;
      }
      expect(
        inked,
        greaterThan(60),
        reason: 'twelve bars of ~6.17px each, gaps aside',
      );
      expect(raster.alphaAt(raster.width ~/ 2, 4), 0);
      expect(raster.alphaAt(raster.width ~/ 2, 20), 0);
    });

    testWidgets('active oscillates without an analyser; idle does not', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_host(const BarVisualizer(active: true)));
      await tester.pump(const Duration(milliseconds: 120));
      final _Raster moving = await _raster(
        tester,
        find.byType(RepaintBoundary).last,
      );
      await tester.pump(const Duration(milliseconds: 120));
      final _Raster later = await _raster(
        tester,
        find.byType(RepaintBoundary).last,
      );
      expect(
        moving.bytes,
        isNot(equals(later.bytes)),
        reason: '`active` is the one path allowed to move without a signal',
      );

      await tester.pumpWidget(_host(const BarVisualizer()));
      final _Raster still = await _raster(
        tester,
        find.byType(RepaintBoundary).last,
      );
      await tester.pump(const Duration(milliseconds: 240));
      final _Raster stillLater = await _raster(
        tester,
        find.byType(RepaintBoundary).last,
      );
      expect(
        still.bytes,
        equals(stillLater.bytes),
        reason: 'nothing here fabricates audio data',
      );
    });

    testWidgets('reduced motion stops the oscillator', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _host(const BarVisualizer(active: true), reduced: true),
      );
      final _Raster first = await _raster(
        tester,
        find.byType(RepaintBoundary).last,
      );
      await tester.pump(const Duration(milliseconds: 400));
      final _Raster second = await _raster(
        tester,
        find.byType(RepaintBoundary).last,
      );
      expect(first.bytes, equals(second.bytes));
    });
  });

  /* ── Mic control ───────────────────────────────────────────────────────── */

  group('MicControl', () {
    testWidgets('one pill, 34 x 34, with a single half', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _host(MicControl(listening: false, onToggle: () {})),
      );
      // 1px border + a 32px button + 1px border, measured on the live
      // reference. The chevron half is `hasMenu`-gated and never renders there.
      expect(tester.getSize(find.byType(MicControl)), const Size(34, 34));
      expect(find.byType(Button), findsOneWidget);
      expect(tester.getSize(find.byType(Button)), const Size(32, 32));
    });

    testWidgets('the accessible name is the verb, and it flips', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _host(MicControl(listening: false, onToggle: () {})),
      );
      expect(tester.widget<Button>(find.byType(Button)).label, 'Dictate');

      await tester.pumpWidget(
        _host(MicControl(listening: true, onToggle: () {})),
      );
      expect(
        tester.widget<Button>(find.byType(Button)).label,
        'Stop dictation',
      );
    });

    testWidgets('going live tints the pill and nothing else changes size', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _host(MicControl(listening: false, onToggle: () {})),
      );
      final _Raster rest = await _raster(
        tester,
        find.byType(RepaintBoundary).last,
      );

      await tester.pumpWidget(
        _host(MicControl(listening: true, onToggle: () {})),
      );
      await tester.pump();
      final _Raster live = await _raster(
        tester,
        find.byType(RepaintBoundary).last,
      );

      expect(live.width, rest.width);
      expect(live.height, rest.height);
      // `bg-agent/12` over the fill, `border-agent/45` over the ring: the pill
      // is measurably bluer in the middle of a straight edge.
      final List<int> restEdge = rest.at(rest.width ~/ 2, 1);
      final List<int> liveEdge = live.at(live.width ~/ 2, 1);
      expect(
        liveEdge[2],
        greaterThan(restEdge[2]),
        reason: 'the border goes agent-coloured',
      );
    });

    testWidgets('a null handler leaves the control inert', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_host(const MicControl(listening: false)));
      expect(tester.widget<Button>(find.byType(Button)).onPressed, isNull);
    });

    testWidgets('disabled beats a handler', (WidgetTester tester) async {
      await tester.pumpWidget(
        _host(MicControl(listening: false, disabled: true, onToggle: () {})),
      );
      expect(tester.widget<Button>(find.byType(Button)).onPressed, isNull);
    });
  });
}

/* ── Harness ─────────────────────────────────────────────────────────────── */

Widget _host(Widget child, {bool reduced = false}) => ThemeScope(
  controller: ThemeController(mode: ColorMode.light),
  child: MediaQuery(
    data: MediaQueryData(disableAnimations: reduced),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: Center(child: RepaintBoundary(child: child)),
    ),
  ),
);
