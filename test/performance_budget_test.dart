/// Performance budget smoke test — Batch 5 visual & perf review.
///
/// WHAT THIS MEASURES, AND WHAT IT DOES NOT.
///
/// Each case pumps a fixed number of frames through `WidgetTester` and times
/// the wall clock with a [Stopwatch]. That number is TEST-BINDING layout and
/// paint cost on the *host* CPU, running in `flutter test`'s software
/// `TestWidgetsFlutterBinding` — there is no GPU, no Skia/Impeller rasterizer,
/// and no device thermal/DVFS behaviour anywhere in the loop. A widget that
/// is cheap to lay out and paint in this harness can still be expensive to
/// rasterize on a real device (a big blur, an expensive shader, a huge
/// layer tree), and a widget that is expensive here is expensive **for a
/// structural reason** — an O(n^2) layout pass, a rebuild that is not
/// scoped, a list that is not virtualized — the kind of regression that
/// shows up as a frame-time regression on every device at once.
///
/// So: a ceiling breach here is a real, worth-investigating structural
/// finding. A pass here is NOT evidence the widget hits 60fps/120fps on a
/// phone. That claim needs a profiled device run, which this file is not.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/material.dart' show MaterialApp, Material;
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
import 'package:flutter_test/flutter_test.dart';

/// A real app root — same shape as `test/interaction_kernel_test.dart`'s
/// `host()`. `StyledText` asserts in debug without a root `DefaultTextStyle`,
/// which is why this is not just `ThemeScope` + the widget under test.
Widget host(Widget child, {ColorMode mode = ColorMode.dark}) => ThemeScope(
  controller: ThemeController(mode: mode),
  child: MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Builder(
      builder: (BuildContext context) => DefaultTextStyle(
        style: StyledText.styleOf(
          context,
          TextStyles.body,
          color: ThemeScope.of(context).foreground,
        ),
        child: Material(child: child),
      ),
    ),
  ),
);

/// Frames pumped per case. Large enough that a per-frame regression shows up
/// as more than test-harness noise, small enough that the suite stays fast.
const int kFrames = 120;

/// Generous on purpose — this ceiling exists to catch an algorithmic
/// regression (O(n^2) layout, an unbounded rebuild), not to assert a frame
/// budget a real device would recognise. See the library doc above.
const Duration kPerFrameCeiling = Duration(milliseconds: 40);

/// Pumps [n] frames of [step] and returns the average wall-clock cost per
/// frame. Uses `pump`, never `pumpAndSettle` — several of these subjects
/// (the spinner, the background glow) animate forever, and `pumpAndSettle`
/// on an unsynced infinite phase never returns (the same rule the capture
/// rig and the widget tests for `Alert` already follow).
Future<Duration> pumpAndMeasure(
  WidgetTester tester,
  int n, {
  Duration step = MotionDurations.fast,
}) async {
  final Stopwatch watch = Stopwatch();
  for (int i = 0; i < n; i++) {
    watch.start();
    await tester.pump(step);
    watch.stop();
  }
  return Duration(microseconds: watch.elapsedMicroseconds ~/ n);
}

void main() {
  group('Performance budget (test-binding layout + paint, no raster/GPU)', () {
    testWidgets('animated painter — BackgroundEffect, $kFrames frames', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        host(
          const SizedBox(width: 800, height: 600, child: BackgroundEffect()),
        ),
      );
      await tester.pump();

      final Duration perFrame = await pumpAndMeasure(tester, kFrames);
      // ignore: avoid_print
      print(
        'BackgroundEffect: ${perFrame.inMicroseconds}us/frame '
        '($kFrames frames)',
      );
      expect(
        perFrame,
        lessThan(kPerFrameCeiling),
        reason:
            'BackgroundEffect per-frame cost exceeded the generous '
            'test-binding ceiling — see library doc for what this ceiling '
            'does and does not prove.',
      );
    });

    testWidgets('animated painter — Spinner, $kFrames frames', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(host(const Spinner()));
      await tester.pump();

      final Duration perFrame = await pumpAndMeasure(tester, kFrames);
      // ignore: avoid_print
      print('Spinner: ${perFrame.inMicroseconds}us/frame ($kFrames frames)');
      expect(perFrame, lessThan(kPerFrameCeiling));
    });

    testWidgets('chart — CartesianChart (area), $kFrames frames', (
      WidgetTester tester,
    ) async {
      final ThemeTokens theme = ThemeTokens.dark;
      final List<Map<String, Object?>> data = <Map<String, Object?>>[
        for (int i = 0; i < 24; i++)
          <String, Object?>{'month': 'M$i', 'desktop': 100 + (i * 37) % 250},
      ];

      await tester.pumpWidget(
        host(
          SizedBox(
            width: 800,
            height: 400,
            child: ChartContainer(
              height: 400,
              config: ChartConfig(<String, ChartSeries>{
                'desktop': ChartSeries(label: 'Desktop', color: theme.chart1),
              }),
              child: CartesianChart(
                data: data,
                xAxis: const ChartAxis(
                  dataKey: 'month',
                  tickLine: false,
                  axisLine: false,
                ),
                series: <ChartSeriesSpec>[
                  ChartSeriesSpec(
                    kind: ChartSeriesKind.area,
                    dataKey: 'desktop',
                    curve: CurveType.natural,
                    fill: theme.chart1,
                    fillOpacity: 0.35,
                    stroke: theme.chart1,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      final Duration perFrame = await pumpAndMeasure(tester, kFrames);
      // ignore: avoid_print
      print(
        'CartesianChart: ${perFrame.inMicroseconds}us/frame '
        '($kFrames frames)',
      );
      expect(perFrame, lessThan(kPerFrameCeiling));
    });

    testWidgets('long list — 500-item ListView.builder, $kFrames frames', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        host(
          SizedBox(
            width: 400,
            height: 700,
            child: ListView.builder(
              itemCount: 500,
              itemBuilder: (BuildContext context, int i) => Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: StyledText(
                  'Row $i — a representative label',
                  TextStyles.body,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      final Stopwatch watch = Stopwatch();
      for (int i = 0; i < kFrames; i++) {
        watch.start();
        // Scrolls a little each frame so the list is doing real virtualized
        // layout work, not just repainting an already-settled viewport.
        await tester.drag(
          find.byType(ListView),
          const Offset(0, -20),
          warnIfMissed: false,
        );
        await tester.pump(MotionDurations.fast);
        watch.stop();
      }
      final Duration perFrame = Duration(
        microseconds: watch.elapsedMicroseconds ~/ kFrames,
      );
      // ignore: avoid_print
      print(
        'Long list (scrolling): ${perFrame.inMicroseconds}us/frame '
        '($kFrames frames)',
      );
      expect(perFrame, lessThan(kPerFrameCeiling));
    });

    testWidgets('overlay — open Dialog, $kFrames frames', (
      WidgetTester tester,
    ) async {
      Widget dialog() => Dialog(
        trigger: (BuildContext context, VoidCallback open) =>
            Button(label: 'Open', onPressed: open, child: const Text('Open')),
        content: (BuildContext context, VoidCallback close) => DialogContent(
          children: <Widget>[
            DialogHeader(children: <Widget>[DialogTitle('Performance probe')]),
            Padding(
              padding: const EdgeInsets.all(16),
              child: StyledText(
                'An open dialog, held steady while frames are pumped.',
                TextStyles.body,
              ),
            ),
          ],
        ),
      );

      await tester.pumpWidget(host(dialog()));
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      expect(find.byType(DialogContent), findsOneWidget);

      final Duration perFrame = await pumpAndMeasure(tester, kFrames);
      // ignore: avoid_print
      print(
        'Open Dialog: ${perFrame.inMicroseconds}us/frame ($kFrames frames)',
      );
      expect(perFrame, lessThan(kPerFrameCeiling));
    });
  });
}
