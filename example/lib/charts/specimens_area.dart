/// The area specimens, and the list the gallery and the reference page read.
///
/// Each builder carries a `// specimen: <id>` marker directly above it. That
/// line is what `tool/chart_sources/extractor.dart` keys on, and it is the
/// only reason the code a reader copies is the code this file compiles.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
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

import '../pages/charts.dart' show monthAxis, plot, RangeStrip, shortDate;
import 'chart_data.dart';
import 'chart_ink.dart';
import 'chart_specimen.dart';

/// `chart-area-default`: one series, natural curve.
// specimen: chart-area-default
Widget areaDefault(ChartInk ink) => plot(
  ink.desktop,
  CartesianChart(
    data: monthsDesktop,
    // Plot maths, not the 8-point scale: recharts' own margin box.
    margin: const ChartMargin(left: 12, right: 12),
    grid: const ChartGrid(vertical: false),
    xAxis: monthAxis(),
    tooltip: const ChartTooltipSpec(
      cursor: false,
      indicator: ChartIndicator.line,
    ),
    series: <ChartSeriesSpec>[
      ChartSeriesSpec(
        kind: ChartSeriesKind.area,
        dataKey: 'desktop',
        curve: CurveType.natural,
        fill: ink.slot(1),
        fillOpacity: 0.4,
        stroke: ink.slot(1),
      ),
    ],
  ),
);

// specimen: chart-area-linear
Widget areaLinear(ChartInk ink) => plot(
  ink.desktop,
  CartesianChart(
    data: monthsDesktop,
    margin: const ChartMargin(left: 12, right: 12),
    grid: const ChartGrid(vertical: false),
    xAxis: monthAxis(),
    tooltip: const ChartTooltipSpec(cursor: false, hideLabel: true),
    series: <ChartSeriesSpec>[
      ChartSeriesSpec(
        kind: ChartSeriesKind.area,
        dataKey: 'desktop',
        fill: ink.slot(1),
        fillOpacity: 0.4,
        stroke: ink.slot(1),
      ),
    ],
  ),
);

/// The registry's `chartConfig.desktop.icon` is `Activity`, unused by this
/// variant's own markup but read by the tooltip's indicator slot: the gap
/// `area.tsx` documents, where the config's icon bypasses `Icon` entirely.
/// Flutter's builder slot has no such constraint, so it goes through [Icon].
// specimen: chart-area-step
Widget areaStep(ChartInk ink) => plot(
  ChartConfig(<String, ChartSeries>{
    'desktop': ChartSeries(
      label: 'Desktop',
      color: ink.slot(1),
      icon: (BuildContext context) =>
          const Icon.lucide(Lucide.activity, size: IconSize.xs),
    ),
  }),
  CartesianChart(
    data: monthsDesktop,
    margin: const ChartMargin(left: 12, right: 12),
    grid: const ChartGrid(vertical: false),
    xAxis: monthAxis(),
    tooltip: const ChartTooltipSpec(cursor: false, hideLabel: true),
    series: <ChartSeriesSpec>[
      ChartSeriesSpec(
        kind: ChartSeriesKind.area,
        dataKey: 'desktop',
        curve: CurveType.step,
        fill: ink.slot(1),
        fillOpacity: 0.4,
        stroke: ink.slot(1),
      ),
    ],
  ),
);

/// The two stacked areas six variants build on. `mobile` is declared first, so
/// it is drawn at the bottom of the stack.
List<ChartSeriesSpec> _stackedAreas(ChartInk ink) => <ChartSeriesSpec>[
  ChartSeriesSpec(
    kind: ChartSeriesKind.area,
    dataKey: 'mobile',
    curve: CurveType.natural,
    stackId: 'a',
    fill: ink.slot(2),
    fillOpacity: 0.4,
    stroke: ink.slot(2),
  ),
  ChartSeriesSpec(
    kind: ChartSeriesKind.area,
    dataKey: 'desktop',
    curve: CurveType.natural,
    stackId: 'a',
    fill: ink.slot(1),
    fillOpacity: 0.4,
    stroke: ink.slot(1),
  ),
];

// specimen: chart-area-stacked
Widget areaStacked(ChartInk ink) => plot(
  ink.desktopMobile,
  CartesianChart(
    data: monthsDesktopMobile,
    margin: const ChartMargin(left: 12, right: 12),
    grid: const ChartGrid(vertical: false),
    xAxis: monthAxis(),
    tooltip: const ChartTooltipSpec(cursor: false),
    series: _stackedAreas(ink),
  ),
);

/// `data.ts` deliberately does not carry this shape, `MONTHS_DESKTOP_MOBILE`
/// plus an `other` series exists for exactly one variant, so it stays local
/// rather than becoming a ninth shared export.
const List<Map<String, Object?>> _areaExpandData = <Map<String, Object?>>[
  <String, Object?>{
    'month': 'January',
    'desktop': 186,
    'mobile': 80,
    'other': 45,
  },
  <String, Object?>{
    'month': 'February',
    'desktop': 305,
    'mobile': 200,
    'other': 100,
  },
  <String, Object?>{
    'month': 'March',
    'desktop': 237,
    'mobile': 120,
    'other': 150,
  },
  <String, Object?>{
    'month': 'April',
    'desktop': 73,
    'mobile': 190,
    'other': 50,
  },
  <String, Object?>{
    'month': 'May',
    'desktop': 209,
    'mobile': 130,
    'other': 100,
  },
  <String, Object?>{
    'month': 'June',
    'desktop': 214,
    'mobile': 140,
    'other': 160,
  },
];

// specimen: chart-area-stacked-expand
Widget areaStackedExpand(ChartInk ink) => plot(
  ink.desktopMobile.plus(<String, ChartSeries>{
    'other': ChartSeries(label: 'Other', color: ink.slot(3)),
  }),
  CartesianChart(
    data: _areaExpandData,
    margin: const ChartMargin(left: 12, right: 12, top: 12),
    stackOffsetExpand: true,
    grid: const ChartGrid(vertical: false),
    xAxis: monthAxis(),
    tooltip: const ChartTooltipSpec(
      cursor: false,
      indicator: ChartIndicator.line,
    ),
    series: <ChartSeriesSpec>[
      ChartSeriesSpec(
        kind: ChartSeriesKind.area,
        dataKey: 'other',
        curve: CurveType.natural,
        stackId: 'a',
        fill: ink.slot(3),
        fillOpacity: 0.1,
        stroke: ink.slot(3),
      ),
      ..._stackedAreas(ink),
    ],
  ),
);

// specimen: chart-area-legend
Widget areaLegend(ChartInk ink) => plot(
  ink.desktopMobile,
  CartesianChart(
    data: monthsDesktopMobile,
    margin: const ChartMargin(left: 12, right: 12),
    grid: const ChartGrid(vertical: false),
    xAxis: monthAxis(),
    tooltip: const ChartTooltipSpec(
      cursor: false,
      indicator: ChartIndicator.line,
    ),
    legend: const ChartLegendSpec(),
    series: _stackedAreas(ink),
  ),
);

/// `TrendingDown` on `desktop` and `TrendingUp` on `mobile` is the registry's
/// own pairing, not a claim these charts render onto that shape.
// specimen: chart-area-icons
Widget areaIcons(ChartInk ink) => plot(
  ChartConfig(<String, ChartSeries>{
    'desktop': ChartSeries(
      label: 'Desktop',
      color: ink.slot(1),
      icon: (BuildContext context) =>
          const Icon.lucide(Lucide.trendingDown, size: IconSize.sm),
    ),
    'mobile': ChartSeries(
      label: 'Mobile',
      color: ink.slot(2),
      icon: (BuildContext context) =>
          const Icon.lucide(Lucide.trendingUp, size: IconSize.sm),
    ),
  }),
  CartesianChart(
    data: monthsDesktopMobile,
    margin: const ChartMargin(left: 12, right: 12),
    grid: const ChartGrid(vertical: false),
    xAxis: monthAxis(),
    tooltip: const ChartTooltipSpec(
      cursor: false,
      indicator: ChartIndicator.line,
    ),
    legend: const ChartLegendSpec(),
    series: _stackedAreas(ink),
  ),
);

/// A `<linearGradient>` in `<defs>`, both stops on the token.
///
/// Drift 3: the `fillOpacity={0.4}` beside it multiplies the gradient's own
/// 0.8 → 0.1 stops rather than replacing them, so what actually paints on
/// `AreaGradient` is 0.32 → 0.04. `AreaInteractive`, the other gradient
/// variant, sets no `fillOpacity` at all and gets the declared stops.
LinearGradient _gradientFor(Color colour, {double opacity = 1}) =>
    LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: const <double>[0.05, 0.95],
      colors: <Color>[
        colour.withValues(alpha: 0.8 * opacity),
        colour.withValues(alpha: 0.1 * opacity),
      ],
    );

// specimen: chart-area-gradient
Widget areaGradient(ChartInk ink) => plot(
  ink.desktopMobile,
  CartesianChart(
    data: monthsDesktopMobile,
    margin: const ChartMargin(left: 12, right: 12),
    grid: const ChartGrid(vertical: false),
    xAxis: monthAxis(),
    tooltip: const ChartTooltipSpec(cursor: false),
    series: <ChartSeriesSpec>[
      ChartSeriesSpec(
        kind: ChartSeriesKind.area,
        dataKey: 'mobile',
        curve: CurveType.natural,
        stackId: 'a',
        gradient: _gradientFor(ink.slot(2), opacity: 0.4),
        stroke: ink.slot(2),
      ),
      ChartSeriesSpec(
        kind: ChartSeriesKind.area,
        dataKey: 'desktop',
        curve: CurveType.natural,
        stackId: 'a',
        gradient: _gradientFor(ink.slot(1), opacity: 0.4),
        stroke: ink.slot(1),
      ),
    ],
  ),
);

/// Both axes labelled: and the one chart on the page with a negative margin,
/// which claws 20 of the Y axis's 60px back out of the plot's left edge.
// specimen: chart-area-axes
Widget areaAxes(ChartInk ink) => plot(
  ink.desktopMobile,
  CartesianChart(
    data: monthsDesktopMobile,
    margin: const ChartMargin(left: -20, right: 12),
    grid: const ChartGrid(vertical: false),
    xAxis: monthAxis(),
    yAxis: const ChartAxis(
      type: ChartAxisType.number,
      tickLine: false,
      axisLine: false,
      tickMargin: 8,
      tickCount: 3,
    ),
    tooltip: const ChartTooltipSpec(cursor: false),
    series: _stackedAreas(ink),
  ),
);

/// The range picker and the 91-day plot it filters.
///
/// The registry sits this `Select` in a `CardHeader`. Stripped of `Card` it
/// used to render inline above the plot, inside the component: which put it
/// inside the swapped slot, where it exists only in `ready`, and the panel then
/// grew 60px the moment you left Loading or Empty: 393.39 → 453.39, measured.
/// So the strip is hoisted out of the slot and the state comes with it.
class AreaInteractive extends StatefulWidget {
  const AreaInteractive({super.key, required this.ink, required this.child});

  final ChartInk ink;

  /// The keyed slot, rendered exactly once and below the strip.
  final Widget child;

  /// The registry's own reference date.
  static final DateTime reference = DateTime(2024, 6, 30);

  /// Which range the plot draws. Defaulted, not nullable, so the chart still
  /// renders a real 90-day series if it is ever mounted without its strip.
  static const String defaultRange = '90d';

  static List<Map<String, Object?>> filtered(String range) {
    final int days = switch (range) {
      '30d' => 30,
      '7d' => 7,
      _ => 90,
    };
    final DateTime start = reference.subtract(Duration(days: days));
    return <Map<String, Object?>>[
      for (final Map<String, Object?> row in dailyVisits)
        if (!DateTime.parse('${row['date']}').isBefore(start)) row,
    ];
  }

  @override
  State<AreaInteractive> createState() => _AreaInteractiveState();
}

class _AreaInteractiveState extends State<AreaInteractive> {
  String _range = AreaInteractive.defaultRange;

  @override
  Widget build(BuildContext context) => RangeStrip(
    value: _range,
    onChanged: (String next) => setState(() => _range = next),
    child: AreaInteractiveRange(range: _range, child: widget.child),
  );
}

/// The context the strip hands down through the keyed slot.
class AreaInteractiveRange extends InheritedWidget {
  const AreaInteractiveRange({
    super.key,
    required this.range,
    required super.child,
  });

  final String range;

  static String of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<AreaInteractiveRange>()
          ?.range ??
      AreaInteractive.defaultRange;

  @override
  bool updateShouldNotify(AreaInteractiveRange old) => old.range != range;
}

/// The plot only: no wrapper, so its footprint is `PLOT` exactly like the
/// other nine.
// specimen: chart-area-interactive
Widget areaInteractive(BuildContext context, ChartInk ink) => plot(
  ink.desktopMobile.plus(<String, ChartSeries>{
    'visitors': const ChartSeries(label: 'Visitors'),
  }),
  CartesianChart(
    data: AreaInteractive.filtered(AreaInteractiveRange.of(context)),
    grid: const ChartGrid(vertical: false),
    xAxis: const ChartAxis(
      dataKey: 'date',
      tickLine: false,
      axisLine: false,
      tickMargin: 8,
      minTickGap: 32,
      tickFormatter: shortDate,
    ),
    tooltip: const ChartTooltipSpec(
      cursor: false,
      labelFormatter: _shortDateLabel,
    ),
    legend: const ChartLegendSpec(),
    series: <ChartSeriesSpec>[
      ChartSeriesSpec(
        kind: ChartSeriesKind.area,
        dataKey: 'mobile',
        curve: CurveType.natural,
        stackId: 'a',
        gradient: _gradientFor(ink.slot(2)),
        stroke: ink.slot(2),
      ),
      ChartSeriesSpec(
        kind: ChartSeriesKind.area,
        dataKey: 'desktop',
        curve: CurveType.natural,
        stackId: 'a',
        gradient: _gradientFor(ink.slot(1)),
        stroke: ink.slot(1),
      ),
    ],
  ),
);

String _shortDateLabel(String label, List<ChartTooltipItem> items) =>
    shortDate(label);

/// The area specimens, and the list the gallery and the reference page read.
const List<ChartSpecimen> areaSpecimens = <ChartSpecimen>[
  ChartSpecimen(
    id: 'chart-area-default',
    note: 'one series, natural curve',
    skeleton: ChartSkeletonKind.area,
    build: _areaDefaultBuild,
  ),
  ChartSpecimen(
    id: 'chart-area-linear',
    note: 'type=linear',
    skeleton: ChartSkeletonKind.area,
    build: _areaLinearBuild,
  ),
  ChartSpecimen(
    id: 'chart-area-step',
    note: 'type=step',
    skeleton: ChartSkeletonKind.area,
    build: _areaStepBuild,
  ),
  ChartSpecimen(
    id: 'chart-area-stacked',
    note: 'shared stackId',
    skeleton: ChartSkeletonKind.area,
    build: _areaStackedBuild,
  ),
  ChartSpecimen(
    id: 'chart-area-stacked-expand',
    note: 'stackOffset=expand — shares, not totals',
    skeleton: ChartSkeletonKind.area,
    build: _areaStackedExpandBuild,
  ),
  ChartSpecimen(
    id: 'chart-area-legend',
    note: 'ChartLegendContent',
    skeleton: ChartSkeletonKind.area,
    build: _areaLegendBuild,
  ),
  ChartSpecimen(
    id: 'chart-area-icons',
    note: 'config icons in the legend',
    skeleton: ChartSkeletonKind.area,
    build: _areaIconsBuild,
  ),
  ChartSpecimen(
    id: 'chart-area-gradient',
    note: 'a linearGradient in defs, both stops on the token',
    skeleton: ChartSkeletonKind.area,
    build: _areaGradientBuild,
  ),
  ChartSpecimen(
    id: 'chart-area-axes',
    note: 'both axes labelled',
    skeleton: ChartSkeletonKind.area,
    build: _areaAxesBuild,
  ),
  ChartSpecimen(
    id: 'chart-area-interactive',
    note: 'range picker, above the plot',
    skeleton: ChartSkeletonKind.area,
    build: areaInteractive,
    fullWidth: true,
  ),
];

Widget _areaDefaultBuild(BuildContext context, ChartInk ink) =>
    areaDefault(ink);
Widget _areaLinearBuild(BuildContext context, ChartInk ink) =>
    areaLinear(ink);
Widget _areaStepBuild(BuildContext context, ChartInk ink) => areaStep(ink);
Widget _areaStackedBuild(BuildContext context, ChartInk ink) =>
    areaStacked(ink);
Widget _areaStackedExpandBuild(BuildContext context, ChartInk ink) =>
    areaStackedExpand(ink);
Widget _areaLegendBuild(BuildContext context, ChartInk ink) =>
    areaLegend(ink);
Widget _areaIconsBuild(BuildContext context, ChartInk ink) => areaIcons(ink);
Widget _areaGradientBuild(BuildContext context, ChartInk ink) =>
    areaGradient(ink);
Widget _areaAxesBuild(BuildContext context, ChartInk ink) => areaAxes(ink);
