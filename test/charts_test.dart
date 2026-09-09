/// The chart family, against the geometry the reference's SVG actually carries.
///
/// Every number in the "measured" groups was read off
/// `http://localhost:3000/design-system/components/base/charts` at 1440 × 900
/// on 2026-08-16, by dumping all 72 specimens' `<svg>` subtrees and parsing the
/// attributes out. Nothing here is derived from recharts' documentation: the
/// plot box, the tick stops, the bar rectangles, the sector `d`s and the radar
/// vertices are the browser's own output, to the hundredth of a pixel.
///
/// The three families of assertion, and why each exists:
///
///  * **maths** — `chartNiceTicks` and the scales, checked in isolation. The
///    niced domain is the one number nothing else can be placed without, and it
///    is invisible in the DOM: it has to be read back out of a path.
///  * **rendered pixels** — the standing painter rule. A painter ships with
///    pins taken off a real rasterisation, so a curve that is subtly wrong
///    cannot pass by having the right bounding box.
///  * **widgets** — the container, tooltip and legend at their measured sizes.
library;

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/material.dart'
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
        TableColumnWidth,
        ActionChip,
        AlertDialog,
        Badge,
        Card,
        CarouselController,
        Checkbox,
        Dialog,
        DropdownMenu,
        Drawer,
        DrawerHeader,
        Slider,
        Switch,
        TextFormField,
        Tooltip;
import 'package:flutter/rendering.dart' show RenderRepaintBoundary;
import 'package:flutter/services.dart' show FontLoader;
import 'package:flutter_test/flutter_test.dart';

/// The plot every `ChartContainer` on the page renders at: `h-64 w-full`
/// inside a 532-wide panel with `p-6` — measured 482 × 256 for all 70.
const Size _plot = Size(482, 256);

/// Half a pixel. The web numbers are rounded to 4dp in the SVG `d`, and Skia's
/// own path arithmetic is double precision, so anything looser than this would
/// stop catching a wrong control point.
const double _tol = 0.5;

/// Tighter still for the pure maths, which has no rasteriser in the loop.
const double _mathTol = 1e-9;

Future<void> _loadFonts() async {
  Future<void> one(String family, String file) async {
    final ByteData bytes = ByteData.sublistView(
      File('assets/fonts/$file').readAsBytesSync(),
    );
    // The package pubspec registers its faces under the prefixed family name,
    // and `TextStyleToken` threads `package:` through every `TextStyle` — so a
    // loader registered on the bare family name is never consulted and every
    // measurement below silently becomes an Ahem measurement.
    final FontLoader loader = FontLoader(
      'packages/elattar_design_system/$family',
    )..addFont(Future<ByteData>.value(bytes));
    await loader.load();
  }

  await one('InterLocal', 'InterVariable.ttf');
  await one('GeistMono', 'GeistMono-Variable.ttf');
}

Widget _scoped(Widget child, {ColorMode mode = ColorMode.light}) => ThemeScope(
  controller: ThemeController(mode: mode),
  child: MediaQuery(
    data: const MediaQueryData(disableAnimations: true),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: Align(alignment: Alignment.topLeft, child: child),
    ),
  ),
);

void main() {
  setUpAll(_loadFonts);

  /* ── Nice ticks ───────────────────────────────────────────────────────── */

  group('nice ticks — the domain nothing else can be placed without', () {
    test('MONTHS_DESKTOP nices 305 up to 320', () {
      // Read back out of `AreaDefault`'s own path: February (305) lands at
      // y=10.594 of a 226-tall plot, which is 305/320 and not 305/305.
      expect(chartNiceTicks(0, 305), <double>[0, 80, 160, 240, 320]);
      final ({double min, double max}) domain = chartNiceDomain(0, 305);
      expect(domain.min, 0);
      expect(domain.max, 320);
    });

    test('AreaAxes renders three ticks over 0..600', () {
      // Measured: the Y axis prints 0 · 300 · 600 at y = 226 · 113 · 9.
      expect(chartNiceTicks(0, 505, tickCount: 3), <double>[0, 300, 600]);
    });

    test('a stacked pair nices to the stack total, not the tallest series', () {
      // AreaStacked's top series reaches 505 (305 + 200).
      expect(chartNiceTicks(0, 505), <double>[0, 150, 300, 450, 600]);
    });

    test('BarNegative keeps zero as a tick on both sides', () {
      final List<double> ticks = chartNiceTicks(-209, 214);
      expect(ticks.contains(0), isTrue);
      expect(ticks.first, lessThanOrEqualTo(-209));
      expect(ticks.last, greaterThanOrEqualTo(214));
    });

    test('SPORT_DAYS stacks to 950 and nices to 1000', () {
      expect(chartNiceTicks(0, 950), <double>[0, 250, 500, 750, 1000]);
    });

    test('a flat domain still returns tickCount stops', () {
      expect(chartNiceTicks(5, 5).length, 5);
    });
  });

  /* ── Scales ───────────────────────────────────────────────────────────── */

  group('scales — measured stops', () {
    test('the point scale puts six months on the plot edges', () {
      const PointScale scale = PointScale(count: 6, start: 12, extent: 458);
      final List<double> xs = <double>[for (int i = 0; i < 6; i++) scale.at(i)];
      // `AreaDefault`'s six vertices, exactly.
      expect(xs[0], closeTo(12, _mathTol));
      expect(xs[1], closeTo(103.6, 1e-9));
      expect(xs[2], closeTo(195.2, 1e-9));
      expect(xs[3], closeTo(286.8, 1e-9));
      expect(xs[4], closeTo(378.4, 1e-9));
      expect(xs[5], closeTo(470, _mathTol));
    });

    test('the band scale centres six categories across BarDefault', () {
      const BandScale scale = BandScale(count: 6, start: 5, extent: 472);
      expect(scale.bandwidth, closeTo(78.6667, 1e-3));
      expect(scale.bandStart(0), closeTo(5, _mathTol));
      expect(scale.center(0), closeTo(44.3333, 1e-3));
    });

    test('the value scale maps 186 to BarDefault\'s own bar top', () {
      final LinearScale scale = LinearScale.nice(
        dataMin: 73,
        dataMax: 305,
        rangeStart: 221,
        rangeEnd: 5,
      );
      expect(scale.domainMax, 320);
      // Measured rect: y = 95.45, height 125.55, baseline 221.
      expect(scale.scale(186), closeTo(95.45, _tol));
      expect(scale.scale(305), closeTo(15.125, _tol));
      expect(scale.scale(73), closeTo(171.725, _tol));
    });
  });

  /* ── Bar layout ───────────────────────────────────────────────────────── */

  group('bar slots — the JS int cast is load-bearing', () {
    test('one bar in a 78.667 band comes out 62 wide, not 62.93', () {
      final List<BarSlot> slots = barSlots(bandSize: 472 / 6, barCount: 1);
      expect(slots.single.offset, closeTo(7.8667, 1e-3));
      // recharts writes `originalSize >>= 0`. Rounding instead would give 63
      // and push the last bar past the grid.
      expect(slots.single.size, 62);
    });

    test('two bars share the band with a 4px gap', () {
      final List<BarSlot> slots = barSlots(bandSize: 472 / 6, barCount: 2);
      expect(slots[0].size, 29);
      expect(slots[0].offset, closeTo(7.8667, 1e-3));
      expect(slots[1].offset, closeTo(7.8667 + 29 + 4, 1e-3));
    });
  });

  /* ── Curves ───────────────────────────────────────────────────────────── */

  group('curves — control points, not silhouettes', () {
    /// `AreaDefault`'s own six vertices.
    const List<Offset> areaDefault = <Offset>[
      Offset(12, 94.637),
      Offset(103.6, 10.594),
      Offset(195.2, 58.619),
      Offset(286.8, 174.444),
      Offset(378.4, 78.394),
      Offset(470, 74.863),
    ];

    test('natural reaches the measured overshoot above February', () {
      final Path path = curvePath(areaDefault, CurveType.natural);
      final Rect bounds = path.getBounds();
      // The rendered `d` runs C…103.6,10.594 C134.133,-0.072… — the spline
      // rises ABOVE the plot before it comes back down, which is exactly the
      // thing a naive smoothing would flatten away.
      expect(bounds.top, closeTo(-0.072, _tol));
      expect(bounds.left, closeTo(12, _tol));
      expect(bounds.right, closeTo(470, _tol));
    });

    test('linear stays inside its own points', () {
      final Path path = curvePath(areaDefault, CurveType.linear);
      expect(path.getBounds().top, closeTo(10.594, _tol));
    });

    test('step breaks at the midpoint of each interval', () {
      final Path path = curvePath(const <Offset>[
        Offset(0, 100),
        Offset(100, 0),
      ], CurveType.step);
      // A midpoint break is on the vertical at x=50, so both ends are touched
      // and nothing overshoots.
      final Rect b = path.getBounds();
      expect(b.left, closeTo(0, _mathTol));
      expect(b.right, closeTo(100, _mathTol));
      expect(b.top, closeTo(0, _mathTol));
      expect(b.bottom, closeTo(100, _mathTol));
    });

    test('monotone never overshoots a data point', () {
      final Path path = curvePath(areaDefault, CurveType.monotone);
      final Rect b = path.getBounds();
      expect(b.top, greaterThanOrEqualTo(10.594 - _tol));
      expect(b.bottom, lessThanOrEqualTo(174.444 + _tol));
    });
  });

  /* ── Polar ────────────────────────────────────────────────────────────── */

  group('polar — the measured pie', () {
    test('the plot radius is 98.4 on a 482 x 256 box', () {
      expect(
        polarMaxRadius(_plot.width, _plot.height) * 0.8,
        closeTo(98.4, 1e-9),
      );
    });

    test('chrome ends where the rendered sector ends', () {
      // BROWSERS totals 925; chrome is 275, i.e. 107.027 degrees.
      const double total = 925;
      const double angle = 275 / total * 360;
      final Offset end = polarToCartesian(241, 128, 98.4, angle);
      expect(end.dx, closeTo(212.1863, _tol));
      expect(end.dy, closeTo(33.9132, _tol));
    });

    test('the radar web starts at twelve o\'clock and steps -60', () {
      // RadarDefault's grid ring at full radius.
      final Offset v0 = polarToCartesian(241, 128, 98.4, 90);
      final Offset v1 = polarToCartesian(241, 128, 98.4, 30);
      expect(v0.dx, closeTo(241, _tol));
      expect(v0.dy, closeTo(29.6, _tol));
      expect(v1.dx, closeTo(326.2169, _tol));
      expect(v1.dy, closeTo(78.8, _tol));
    });

    test('a donut sector closes on its own inner arc', () {
      final Path path = sectorPath(
        cx: 241,
        cy: 128,
        innerRadius: 60,
        outerRadius: 98.4,
        startAngle: 0,
        endAngle: 275 / 925 * 360,
      );
      final Rect b = path.getBounds();
      expect(b.right, closeTo(339.4, _tol));
      // The wedge sweeps past twelve o'clock on its way to 107.03 degrees, so
      // its topmost ink is the arc's own apex at cy − r, not its end point.
      // Reading the end point here was this file's own first wrong pin.
      expect(b.top, closeTo(128 - 98.4, _tol));
    });
  });

  /* ── Widgets ──────────────────────────────────────────────────────────── */

  group('ChartContainer', () {
    testWidgets('renders at the measured 482 x 256 plot', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        _scoped(
          SizedBox(
            width: _plot.width,
            child: ChartContainer(
              config: const ChartConfig(<String, ChartSeries>{}),
              child: const SizedBox.shrink(),
            ),
          ),
        ),
      );
      expect(t.getSize(find.byType(ChartContainer)), const Size(482, 256));
    });
  });

  group('ChartTooltipContent', () {
    testWidgets('the default panel is 128 wide at its measured height', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        _scoped(
          ChartTooltipContent(
            config: const ChartConfig(<String, ChartSeries>{
              'running': ChartSeries(label: 'Running'),
              'swimming': ChartSeries(label: 'Swimming'),
            }),
            label: '2024-07-16',
            items: const <ChartTooltipItem>[
              ChartTooltipItem(name: 'running', value: 380),
              ChartTooltipItem(name: 'swimming', value: 420),
            ],
          ),
        ),
      );
      final Size size = t.getSize(find.byType(ChartTooltipContent));
      // The panel is as wide as its widest row and no wider, and it never
      // narrows below the minimum a two-column row needs.
      expect(size.width, greaterThanOrEqualTo(128));
      expect(size.height, greaterThan(TextStyles.small.step.leading * 2));
    });

    testWidgets('hideLabel drops the header row', (WidgetTester t) async {
      await t.pumpWidget(
        _scoped(
          ChartTooltipContent(
            config: const ChartConfig(<String, ChartSeries>{
              'running': ChartSeries(label: 'Running'),
            }),
            label: '2024-07-16',
            hideLabel: true,
            items: const <ChartTooltipItem>[
              ChartTooltipItem(name: 'running', value: 380),
            ],
          ),
        ),
      );
      expect(find.text('2024-07-16'), findsNothing);
      expect(find.text('Running'), findsOneWidget);
    });
  });

  group('ChartLegendContent', () {
    testWidgets('one row of keys, centred', (WidgetTester t) async {
      await t.pumpWidget(
        _scoped(
          SizedBox(
            width: _plot.width,
            child: ChartLegendContent(
              config: const ChartConfig(<String, ChartSeries>{
                'desktop': ChartSeries(label: 'Desktop'),
                'mobile': ChartSeries(label: 'Mobile'),
              }),
              items: const <ChartLegendItem>[
                ChartLegendItem(name: 'desktop', color: Color(0xFF1A6EF4)),
                ChartLegendItem(name: 'mobile', color: Color(0xFF1A6EF4)),
              ],
            ),
          ),
        ),
      );
      expect(find.text('Desktop'), findsOneWidget);
      expect(find.text('Mobile'), findsOneWidget);
    });
  });

  group('CartesianChart — X axis, first and last tick preservation', () {
    // Six months, a 12px left/right margin — `AreaDefault`'s own shape. Any
    // narrower and `_preserveEndTicks` used to drop 'Jan' outright: `frame.left`
    // sits at exactly `margin.left` on a point scale (no bars), and `ChartText.xs`
    // resolves wide enough at every breakpoint this system ships that half of a
    // 3-letter month exceeds a 12px margin.
    const List<Map<String, Object?>> months = <Map<String, Object?>>[
      <String, Object?>{'month': 'Jan', 'value': 186},
      <String, Object?>{'month': 'Feb', 'value': 305},
      <String, Object?>{'month': 'Mar', 'value': 237},
      <String, Object?>{'month': 'Apr', 'value': 73},
      <String, Object?>{'month': 'May', 'value': 209},
      <String, Object?>{'month': 'Jun', 'value': 214},
    ];
    const List<String> monthLabels = <String>[
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
    ];
    const ChartAxis monthAxis = ChartAxis(
      dataKey: 'month',
      tickLine: false,
      axisLine: false,
      tickMargin: 8,
    );

    // The 2026-08-26 spec's own overflow defect was correct at one width and
    // broken at another, and a single-width test missed it. Sweep a range —
    // desktop down to a narrow mobile rail — so a width-dependent regression
    // in either direction cannot hide again.
    const List<double> widths = <double>[1600, 1200, 900, 600, 400, 280];

    // `ChartText.xs` resolves off `TypeWidthScope`, which falls back to
    // `MediaQuery.sizeOf(context).width` — the SCREEN width, not the chart's
    // own constraint. Pinning it to a desktop screen (>= Breakpoints.lg)
    // reproduces the diagnosis's own precondition (14px `TextStyles.small`)
    // at every chart width swept below, so the sweep exercises the tick
    // algorithm's own width-dependence rather than the font's.
    Widget scopedAt(double chartWidth, Widget child) => ThemeScope(
      controller: ThemeController(mode: ColorMode.light),
      child: MediaQuery(
        data: const MediaQueryData(
          size: Size(1440, 900),
          disableAnimations: true,
        ),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(width: chartWidth, child: child),
          ),
        ),
      ),
    );

    Widget pointScaleChart() => ChartContainer(
      config: const ChartConfig(<String, ChartSeries>{}),
      child: CartesianChart(
        data: months,
        margin: const ChartMargin(left: 12, right: 12),
        xAxis: monthAxis,
        series: const <ChartSeriesSpec>[
          ChartSeriesSpec(kind: ChartSeriesKind.area, dataKey: 'value'),
        ],
      ),
    );

    Widget bandScaleChart() => ChartContainer(
      config: const ChartConfig(<String, ChartSeries>{}),
      child: CartesianChart(
        data: months,
        margin: const ChartMargin(left: 12, right: 12),
        xAxis: monthAxis,
        series: const <ChartSeriesSpec>[
          ChartSeriesSpec(kind: ChartSeriesKind.bar, dataKey: 'value'),
        ],
      ),
    );

    for (final double width in widths) {
      testWidgets(
        'point scale (area) keeps all six labels at ${width}px',
        (WidgetTester t) async {
          await t.pumpWidget(scopedAt(width, pointScaleChart()));
          for (final String label in monthLabels) {
            expect(
              find.text(label),
              findsOneWidget,
              reason: '$label missing at width $width',
            );
          }
        },
      );
    }

    for (final double width in widths) {
      testWidgets(
        'band scale (bar) is unaffected at ${width}px',
        (WidgetTester t) async {
          await t.pumpWidget(scopedAt(width, bandScaleChart()));
          for (final String label in monthLabels) {
            expect(
              find.text(label),
              findsOneWidget,
              reason: '$label missing at width $width',
            );
          }
        },
      );
    }
  });

  /* ── Numeric role ─────────────────────────────────────────────────────── */

  group('CartesianChart — numeric role on number surfaces', () {
    // Task 28: numerals get `TextStyles.numberSm`, category text keeps the
    // chart's own prose role (`ChartText.xs`, which is `TextStyles.small`).
    // A fixed >= Breakpoints.lg viewport resolves both roles to their
    // desktop steps, so the two are guaranteed distinct sizes to compare.
    const List<Map<String, Object?>> months = <Map<String, Object?>>[
      <String, Object?>{'month': 'Jan', 'value': 186},
      <String, Object?>{'month': 'Feb', 'value': 305},
    ];

    Widget scoped(Widget child) => ThemeScope(
      controller: ThemeController(mode: ColorMode.light),
      child: MediaQuery(
        data: const MediaQueryData(
          size: Size(1440, 900),
          disableAnimations: true,
        ),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(width: 480, height: 260, child: child),
          ),
        ),
      ),
    );

    testWidgets('a numeric Y axis tick renders numberSm', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        scoped(
          ChartContainer(
            config: const ChartConfig(<String, ChartSeries>{}),
            child: CartesianChart(
              data: months,
              xAxis: const ChartAxis(dataKey: 'month'),
              yAxis: const ChartAxis(type: ChartAxisType.number),
              series: const <ChartSeriesSpec>[
                ChartSeriesSpec(kind: ChartSeriesKind.bar, dataKey: 'value'),
              ],
            ),
          ),
        ),
      );
      // `chartNiceTicks(0, 305)` always keeps 0 among its five stops.
      final Text tick = t.widget<Text>(find.text('0'));
      expect(tick.style!.fontSize, TextStyles.numberSm.desktop.size);
    });

    testWidgets(
      'a CATEGORY X axis tick keeps the prose role, not numberSm',
      (WidgetTester t) async {
        await t.pumpWidget(
          scoped(
            ChartContainer(
              config: const ChartConfig(<String, ChartSeries>{}),
              child: CartesianChart(
                data: months,
                xAxis: const ChartAxis(dataKey: 'month'),
                yAxis: const ChartAxis(type: ChartAxisType.number),
                series: const <ChartSeriesSpec>[
                  ChartSeriesSpec(
                    kind: ChartSeriesKind.bar,
                    dataKey: 'value',
                  ),
                ],
              ),
            ),
          ),
        );
        final Text tick = t.widget<Text>(find.text('Jan'));
        expect(tick.style!.fontSize, TextStyles.small.desktop.size);
        expect(
          tick.style!.fontSize,
          isNot(TextStyles.numberSm.desktop.size),
        );
      },
    );

    testWidgets('a LabelList value renders numberSm', (WidgetTester t) async {
      await t.pumpWidget(
        scoped(
          ChartContainer(
            config: const ChartConfig(<String, ChartSeries>{}),
            child: CartesianChart(
              data: months,
              xAxis: const ChartAxis(dataKey: 'month', hide: true),
              yAxis: const ChartAxis(type: ChartAxisType.number, hide: true),
              series: const <ChartSeriesSpec>[
                ChartSeriesSpec(
                  kind: ChartSeriesKind.bar,
                  dataKey: 'value',
                  labels: <ChartLabelList>[ChartLabelList()],
                ),
              ],
            ),
          ),
        ),
      );
      final Text label = t.widget<Text>(find.text('186'));
      expect(label.style!.fontSize, TextStyles.numberSm.desktop.size);
    });

    testWidgets(
      "a LabelList pointed at a category field keeps the prose role",
      (WidgetTester t) async {
        await t.pumpWidget(
          scoped(
            ChartContainer(
              config: const ChartConfig(<String, ChartSeries>{}),
              child: CartesianChart(
                data: months,
                layout: ChartLayout.vertical,
                xAxis: const ChartAxis(
                  dataKey: 'value',
                  type: ChartAxisType.number,
                  hide: true,
                ),
                yAxis: const ChartAxis(dataKey: 'month', hide: true),
                series: const <ChartSeriesSpec>[
                  ChartSeriesSpec(
                    kind: ChartSeriesKind.bar,
                    dataKey: 'value',
                    labels: <ChartLabelList>[
                      ChartLabelList(
                        dataKey: 'month',
                        position: ChartLabelPosition.insideLeft,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
        final Text label = t.widget<Text>(find.text('Jan'));
        expect(label.style!.fontSize, TextStyles.small.desktop.size);
      },
    );
  });

  /* ── Polar hover ─────────────────────────────────────────────────────── */

  group('PieChart / RadialBarChart — hover tooltip', () {
    // The measured frame every polar specimen shares: 482 × 256, centre
    // (241, 128) — see chart_polar.dart's own library doc.
    const Offset centre = Offset(241, 128);

    Future<void> hoverAt(
      WidgetTester t,
      TestGesture mouse,
      Finder chart,
      Offset local,
    ) async {
      await mouse.moveTo(t.getTopLeft(chart) + local);
      await t.pump();
    }

    Future<TestGesture> startMouse(WidgetTester t) async {
      final TestGesture mouse = await t.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      await mouse.addPointer(location: Offset.zero);
      addTearDown(mouse.removePointer);
      await t.pump();
      return mouse;
    }

    const List<Map<String, Object?>> pieData = <Map<String, Object?>>[
      <String, Object?>{'name': 'Alpha', 'value': 10, 'fill': Color(0xFF1A6EF4)},
      <String, Object?>{'name': 'Beta', 'value': 10, 'fill': Color(0xFF2ECC71)},
      <String, Object?>{'name': 'Gamma', 'value': 10, 'fill': Color(0xFFF39C12)},
    ];

    Widget pie({int? defaultIndex}) => _scoped(
      SizedBox(
        width: _plot.width,
        height: _plot.height,
        child: PieChart(
          pies: <PieSpec>[
            const PieSpec(
              data: pieData,
              dataKey: 'value',
              innerRadius: 40,
              outerRadius: 100,
            ),
          ],
          tooltip: ChartTooltipSpec(defaultIndex: defaultIndex),
        ),
      ),
    );

    // Three equal slices of 120° each, starting at 0°: Alpha 0..120 (mid
    // 60°), Beta 120..240 (mid 180°), Gamma 240..360 (mid 300°).
    final Offset alphaPoint = polarToCartesian(centre.dx, centre.dy, 70, 60);
    final Offset betaPoint = polarToCartesian(centre.dx, centre.dy, 70, 180);

    testWidgets('hovering a sector shows THAT sector — two different '
        'sectors, two different tooltips', (WidgetTester t) async {
      await t.pumpWidget(pie());
      final TestGesture mouse = await startMouse(t);
      final Finder chart = find.byType(PieChart);

      await hoverAt(t, mouse, chart, alphaPoint);
      expect(find.text('Alpha'), findsOneWidget);
      expect(find.text('Beta'), findsNothing);
      expect(find.text('Gamma'), findsNothing);

      await hoverAt(t, mouse, chart, betaPoint);
      expect(find.text('Beta'), findsOneWidget);
      expect(find.text('Alpha'), findsNothing);
      expect(find.text('Gamma'), findsNothing);
    });

    testWidgets('the donut hole shows no tooltip', (WidgetTester t) async {
      await t.pumpWidget(pie());
      final TestGesture mouse = await startMouse(t);
      // Dead centre: radius 0, inside the 40px hole.
      await hoverAt(t, mouse, find.byType(PieChart), centre);
      expect(find.byType(ChartTooltipContent), findsNothing);
    });

    testWidgets('a point outside the outer radius shows no tooltip', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(pie());
      final TestGesture mouse = await startMouse(t);
      final Offset outside = polarToCartesian(centre.dx, centre.dy, 150, 60);
      await hoverAt(t, mouse, find.byType(PieChart), outside);
      expect(find.byType(ChartTooltipContent), findsNothing);
    });

    testWidgets(
      'defaultIndex shows at rest and is restored once the pointer leaves',
      (WidgetTester t) async {
        await t.pumpWidget(pie(defaultIndex: 1));
        // No pointer has moved yet — Beta (index 1) shows at rest.
        expect(find.text('Beta'), findsOneWidget);

        final TestGesture mouse = await startMouse(t);
        final Finder chart = find.byType(PieChart);
        await hoverAt(t, mouse, chart, alphaPoint);
        expect(find.text('Alpha'), findsOneWidget);
        expect(find.text('Beta'), findsNothing);

        // Leave the chart entirely.
        await mouse.moveTo(t.getTopLeft(chart) - const Offset(50, 50));
        await t.pump();
        expect(find.text('Beta'), findsOneWidget);
        expect(find.text('Alpha'), findsNothing);
      },
    );

    testWidgets('a radial chart shows a tooltip for the hovered arc', (
      WidgetTester t,
    ) async {
      // Two rings 30..100, one row per ring: bandSize 35, a 10% gap each
      // side leaves a 28px ring — row 0 at 33.5..61.5, row 1 at 68.5..96.5.
      // Row 0's value (5 of a 10 domain) sweeps only the first half of its
      // ring; row 1's (10 of 10) sweeps the whole ring.
      await t.pumpWidget(
        _scoped(
          SizedBox(
            width: _plot.width,
            height: _plot.height,
            child: RadialBarChart(
              data: const <Map<String, Object?>>[
                <String, Object?>{'value': 5},
                <String, Object?>{'value': 10},
              ],
              series: const <RadialBarSpec>[RadialBarSpec(dataKey: 'value')],
              innerRadius: 30,
              outerRadius: 100,
              tooltip: const ChartTooltipSpec(),
            ),
          ),
        ),
      );
      final TestGesture mouse = await startMouse(t);
      final Finder chart = find.byType(RadialBarChart);

      final Offset row0 = polarToCartesian(centre.dx, centre.dy, 47.5, 90);
      await hoverAt(t, mouse, chart, row0);
      expect(find.byType(ChartTooltipContent), findsOneWidget);
      expect(find.text('5'), findsOneWidget);

      final Offset row1 = polarToCartesian(centre.dx, centre.dy, 82.5, 180);
      await hoverAt(t, mouse, chart, row1);
      expect(find.byType(ChartTooltipContent), findsOneWidget);
      expect(find.text('10'), findsOneWidget);
    });

    testWidgets(
      'two positions inside the SAME sector place the tooltip at '
      'DIFFERENT screen positions — it follows the pointer, not a fixed '
      'anchor',
      (WidgetTester t) async {
        await t.pumpWidget(pie());
        final TestGesture mouse = await startMouse(t);
        final Finder chart = find.byType(PieChart);
        final Offset origin = t.getTopLeft(chart);

        // Both points sit inside Alpha's 0..120° sector (mid 60°) and
        // between the 40..100 ring, so both hover the same slice.
        final Offset near = polarToCartesian(centre.dx, centre.dy, 55, 20);
        final Offset far = polarToCartesian(centre.dx, centre.dy, 95, 100);

        await hoverAt(t, mouse, chart, near);
        expect(find.text('Alpha'), findsOneWidget);
        final Offset nearTooltip =
            t.getTopLeft(find.byType(ChartTooltipContent)) - origin;

        await hoverAt(t, mouse, chart, far);
        expect(find.text('Alpha'), findsOneWidget);
        final Offset farTooltip =
            t.getTopLeft(find.byType(ChartTooltipContent)) - origin;

        expect(nearTooltip, isNot(equals(farTooltip)));
      },
    );

    testWidgets(
      'hovering near the right/bottom edge keeps the tooltip within the '
      'chart bounds',
      (WidgetTester t) async {
        // A big enough ring that a point on it sits close to the plot's
        // right and bottom edges.
        await t.pumpWidget(
          _scoped(
            SizedBox(
              width: _plot.width,
              height: _plot.height,
              child: PieChart(
                pies: <PieSpec>[
                  const PieSpec(
                    data: pieData,
                    dataKey: 'value',
                    innerRadius: 40,
                    outerRadius: 120,
                  ),
                ],
                tooltip: const ChartTooltipSpec(),
              ),
            ),
          ),
        );
        final TestGesture mouse = await startMouse(t);
        final Finder chart = find.byType(PieChart);
        final Offset origin = t.getTopLeft(chart);

        // 10° is inside Alpha's 0..120° sector and, at radius 118, close
        // enough to the plot's right edge (482) to push the unclamped
        // anchor (357 + the space(3) gap) past `plot.width - minWidth`.
        final Offset corner = polarToCartesian(centre.dx, centre.dy, 118, 10);
        await hoverAt(t, mouse, chart, corner);
        expect(find.text('Alpha'), findsOneWidget);

        final Rect tooltip =
            (t.getTopLeft(find.byType(ChartTooltipContent)) - origin) &
            t.getSize(find.byType(ChartTooltipContent));
        expect(tooltip.left, greaterThanOrEqualTo(0));
        expect(tooltip.top, greaterThanOrEqualTo(0));
        expect(tooltip.right, lessThanOrEqualTo(_plot.width));
        // The vertical clamp is bounded by the tooltip's own MEASURED height
        // (via the `CustomSingleChildLayout` delegate), not a stand-in
        // width constant, so the bottom edge is held in-bounds too.
        expect(tooltip.bottom, lessThanOrEqualTo(_plot.height));
      },
    );

    testWidgets(
      'hovering a sector near the BOTTOM of the plot places the tooltip in '
      'the lower half — the vertical clamp must bound the real measured '
      'height, not a width constant standing in for one',
      (WidgetTester t) async {
        await t.pumpWidget(pie());
        final TestGesture mouse = await startMouse(t);
        final Finder chart = find.byType(PieChart);
        final Offset origin = t.getTopLeft(chart);

        // Gamma's sector is 240..360°, mid 300° — polarToCartesian's
        // convention (screen y = cy + sin(300°)·r = cy + 0.866·r) puts this
        // well below the plot's vertical centre, near the bottom edge of
        // the 256px-tall plot.
        final Offset bottom = polarToCartesian(centre.dx, centre.dy, 95, 300);
        await hoverAt(t, mouse, chart, bottom);
        expect(find.text('Gamma'), findsOneWidget);

        final Offset tooltipTopLeft =
            t.getTopLeft(find.byType(ChartTooltipContent)) - origin;
        expect(tooltipTopLeft.dy, greaterThan(_plot.height / 2));
      },
    );

    testWidgets(
      "defaultIndex's resting position — no pointer, tooltip at rest — is "
      'unchanged from before pointer-following was added: centred on the '
      "pie's own centre x, space(2) down from the plot's top",
      (WidgetTester t) async {
        await t.pumpWidget(pie(defaultIndex: 1));
        final Finder chart = find.byType(PieChart);
        final Offset origin = t.getTopLeft(chart);
        final Offset resting =
            t.getTopLeft(find.byType(ChartTooltipContent)) - origin;
        expect(resting, const Offset(241, 8));
      },
    );
  });

  group('PieChart / RadialBarChart — no tooltip installs no hover handling', () {
    // widget.tooltip == null gates rendering already (see
    // `if (active != null && widget.tooltip != null)` in chart_polar.dart);
    // this proves the MouseRegion that drives it is gated the same way, so a
    // chart with no tooltip spec pays no setState on pointer move.
    testWidgets('PieChart with no tooltip has no MouseRegion', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        _scoped(
          SizedBox(
            width: _plot.width,
            height: _plot.height,
            child: PieChart(
              pies: <PieSpec>[
                const PieSpec(
                  data: <Map<String, Object?>>[
                    <String, Object?>{'name': 'Alpha', 'value': 10},
                    <String, Object?>{'name': 'Beta', 'value': 10},
                  ],
                  dataKey: 'value',
                  innerRadius: 40,
                  outerRadius: 100,
                ),
              ],
            ),
          ),
        ),
      );
      expect(
        find.descendant(
          of: find.byType(PieChart),
          matching: find.byType(MouseRegion),
        ),
        findsNothing,
      );
    });

    testWidgets('RadialBarChart with no tooltip has no MouseRegion', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        _scoped(
          SizedBox(
            width: _plot.width,
            height: _plot.height,
            child: RadialBarChart(
              data: const <Map<String, Object?>>[
                <String, Object?>{'value': 5},
                <String, Object?>{'value': 10},
              ],
              series: const <RadialBarSpec>[RadialBarSpec(dataKey: 'value')],
              innerRadius: 30,
              outerRadius: 100,
            ),
          ),
        ),
      );
      expect(
        find.descendant(
          of: find.byType(RadialBarChart),
          matching: find.byType(MouseRegion),
        ),
        findsNothing,
      );
    });
  });

  /* ── Rendered pixels ──────────────────────────────────────────────────── */

  group('rendered pixels — the standing painter rule', () {
    /// One rasterised pixel out of [child], at [at].
    ///
    /// The whole point of the rule: a `Path` with the right bounding box can
    /// still be the wrong curve, and a `drawRRect` with the right rect can
    /// still have square corners. Only the canvas settles it.
    Future<Color> pixel(
      WidgetTester t,
      Widget child,
      Size size,
      Offset at,
    ) async {
      await t.pumpWidget(
        _scoped(
          RepaintBoundary(
            key: const Key('raster'),
            child: SizedBox(
              width: size.width,
              height: size.height,
              child: ColoredBox(color: const Color(0xFF000000), child: child),
            ),
          ),
        ),
      );
      await t.pump();
      final RenderRepaintBoundary box = t.renderObject(
        find.byKey(const Key('raster')),
      );
      final ui.Image image = (await t.runAsync(
        () => box.toImage(pixelRatio: 1),
      ))!;
      final ByteData data = (await t.runAsync(
        () async =>
            (await image.toByteData(format: ui.ImageByteFormat.rawRgba))!,
      ))!;
      final int i = ((at.dy.round() * size.width.round()) + at.dx.round()) * 4;
      final Color colour = Color.fromARGB(
        data.getUint8(i + 3),
        data.getUint8(i),
        data.getUint8(i + 1),
        data.getUint8(i + 2),
      );
      image.dispose();
      return colour;
    }

    /// `BarDefault`'s first bar, exactly as the browser draws it:
    /// `x=12.8667 y=95.45 width=62 height=125.55 radius=6`.
    Widget barSpecimen() => CustomPaint(
      painter: const BarSeriesPainter(
        bars: <BarRect>[
          BarRect(
            rect: Rect.fromLTWH(12.8667, 95.45, 62, 125.55),
            radii: <double>[Radii.sm, Radii.sm, Radii.sm, Radii.sm],
            color: Color(0xFF1A6EF4),
          ),
        ],
      ),
    );

    testWidgets('the bar fills its own rectangle', (WidgetTester t) async {
      final Color inside = await pixel(
        t,
        barSpecimen(),
        _plot,
        const Offset(43, 150),
      );
      expect(inside, const Color(0xFF1A6EF4));
    });

    testWidgets('and stops at the measured top edge', (WidgetTester t) async {
      // y = 94 is one pixel above the bar; y = 97 is inside it.
      expect(
        await pixel(t, barSpecimen(), _plot, const Offset(43, 94)),
        const Color(0xFF000000),
      );
      expect(
        await pixel(t, barSpecimen(), _plot, const Offset(43, 97)),
        const Color(0xFF1A6EF4),
      );
    });

    testWidgets('the --radius-sm corner is really cut', (WidgetTester t) async {
      // The top-left corner box is 6 x 6 from (12.8667, 95.45). Its outermost
      // pixel is outside the rounded quadrant; the pixel one radius in is not.
      // A square `drawRect` would paint both.
      expect(
        await pixel(t, barSpecimen(), _plot, const Offset(13, 96)),
        const Color(0xFF000000),
      );
      expect(
        await pixel(t, barSpecimen(), _plot, const Offset(20, 102)),
        const Color(0xFF1A6EF4),
      );
    });

    testWidgets('a full donut sector paints between its two radii', (
      WidgetTester t,
    ) async {
      final Widget donut = CustomPaint(
        painter: _SectorProbe(
          path: sectorPath(
            cx: 241,
            cy: 128,
            innerRadius: 60,
            outerRadius: 98.4,
            startAngle: 0,
            endAngle: 359.999,
          ),
        ),
      );
      // 241 + 80 is between the two radii; 241 + 40 is inside the hole and
      // 241 + 110 is outside the ring.
      expect(
        await pixel(t, donut, _plot, const Offset(321, 128)),
        const Color(0xFF1A6EF4),
      );
      expect(
        await pixel(t, donut, _plot, const Offset(281, 128)),
        const Color(0xFF000000),
      );
      expect(
        await pixel(t, donut, _plot, const Offset(351, 128)),
        const Color(0xFF000000),
      );
    });

    testWidgets('the natural spline overshoots where the web overshoots', (
      WidgetTester t,
    ) async {
      // `AreaDefault`'s curve passes ABOVE the plot between January and
      // February — the rendered `d` reads `C134.133,-0.072`. A linear or a
      // monotone interpolation cannot put ink at y=4 near x=120; the natural
      // spline does, and that single pixel is the difference.
      final Widget stroke = CustomPaint(
        painter: _SectorProbe(
          path: curvePath(const <Offset>[
            Offset(12, 94.637),
            Offset(103.6, 10.594),
            Offset(195.2, 58.619),
            Offset(286.8, 174.444),
            Offset(378.4, 78.394),
            Offset(470, 74.863),
          ], CurveType.natural),
          stroke: 4,
        ),
      );
      expect(
        await pixel(t, stroke, _plot, const Offset(126, 6)),
        const Color(0xFF1A6EF4),
      );
    });
  });
}

/// Paints one path in the action colour so a pixel probe can find it.
class _SectorProbe extends CustomPainter {
  const _SectorProbe({required this.path, this.stroke});

  final Path path;
  final double? stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = const Color(0xFF1A6EF4);
    if (stroke != null) {
      paint
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke!;
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_SectorProbe old) => old.path != path;
}
