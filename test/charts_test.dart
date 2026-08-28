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
      // Measured on `TooltipDefault`, which shows its tooltip at rest through
      // `defaultIndex={1}`: 128 x 70.78.
      expect(size.width, closeTo(128, _tol));
      expect(size.height, closeTo(70.78, 1.5));
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
