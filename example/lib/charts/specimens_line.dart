/// The line specimens, and the list the gallery and the reference page read.
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

import 'chart_data.dart';
import 'chart_ink.dart';
import 'chart_plot.dart';
import 'chart_specimen.dart';

/// The one line every `dot={false}` variant draws.
ChartSeriesSpec _lineSeries(
  Color colour,
  String key,
  CurveType curve, {
  ChartDot? dot,
  List<ChartLabelList> labels = const <ChartLabelList>[],
}) => ChartSeriesSpec(
  kind: ChartSeriesKind.line,
  dataKey: key,
  curve: curve,
  stroke: colour,
  strokeWidth: 2,
  dot: dot,
  labels: labels,
);

Widget lineChart(
  ChartConfig config,
  List<Map<String, Object?>> data,
  List<ChartSeriesSpec> series, {
  ChartAxis? xAxis,
  ChartMargin margin = const ChartMargin(left: 12, right: 12),
  ChartTooltipSpec tooltip = const ChartTooltipSpec(
    cursor: false,
    hideLabel: true,
  ),
}) => plot(
  config,
  CartesianChart(
    data: data,
    margin: margin,
    grid: const ChartGrid(vertical: false),
    xAxis: xAxis,
    tooltip: tooltip,
    series: series,
  ),
);

// specimen: chart-line-default
Widget lineDefault(ChartInk ink) => lineChart(
  ink.desktop,
  monthsDesktop,
  <ChartSeriesSpec>[_lineSeries(ink.slot(1), 'desktop', CurveType.natural)],
  xAxis: monthAxis(),
);

// specimen: chart-line-linear
Widget lineLinear(ChartInk ink) => lineChart(
  ink.desktop,
  monthsDesktop,
  <ChartSeriesSpec>[_lineSeries(ink.slot(1), 'desktop', CurveType.linear)],
  xAxis: monthAxis(),
);

// specimen: chart-line-step
Widget lineStep(ChartInk ink) => lineChart(
  ink.desktop,
  monthsDesktop,
  <ChartSeriesSpec>[_lineSeries(ink.slot(1), 'desktop', CurveType.step)],
  xAxis: monthAxis(),
);

// specimen: chart-line-multiple
Widget lineMultiple(ChartInk ink) => lineChart(
  ink.desktopMobile,
  monthsDesktopMobile,
  <ChartSeriesSpec>[
    _lineSeries(ink.slot(1), 'desktop', CurveType.monotone),
    _lineSeries(ink.slot(2), 'mobile', CurveType.monotone),
  ],
  xAxis: monthAxis(),
  tooltip: const ChartTooltipSpec(),
);

// specimen: chart-line-dots
Widget lineDots(ChartInk ink) =>
    lineChart(ink.desktopMobile, monthsDesktopMobile, <ChartSeriesSpec>[
      _lineSeries(
        ink.slot(1),
        'desktop',
        CurveType.natural,
        dot: ChartDot(fill: ink.slot(1)),
      ),
    ], xAxis: monthAxis());

/// The registry hardcodes 24 for the glyph's box; `line.tsx` reads it off the
/// icon ladder instead, *"so `xl` is 24 in one place only"*.
// specimen: chart-line-dots-custom
Widget lineDotsCustom(ChartInk ink, ThemeTokens theme) =>
    lineChart(ink.desktopMobile, monthsDesktopMobile, <ChartSeriesSpec>[
      _lineSeries(
        ink.slot(1),
        'desktop',
        CurveType.natural,
        dot: ChartDot(
          radius: Icon.pxFor(IconSize.xl) / 2,
          fill: theme.background,
          stroke: ink.slot(1),
        ),
      ),
    ], xAxis: monthAxis());

/// One line through five categorical points, coloured from each row rather than
/// from a series palette: five rows, five tokens, no cycling.
// specimen: chart-line-dots-colors
Widget lineDotsColors(ChartInk ink) => lineChart(
  ink.browser,
  browsers,
  <ChartSeriesSpec>[
    ChartSeriesSpec(
      kind: ChartSeriesKind.line,
      dataKey: 'visitors',
      curve: CurveType.natural,
      // `visitors` is the value key and carries no colour of its own, so
      // the stroke is the plain `--color-chart-2` the registry's config
      // resolves to, not a lookup through it.
      stroke: ink.slot(2),
      strokeWidth: 2,
      dot: const ChartDot(radius: 5),
      cellFills: <Color>[
        for (final Map<String, Object?> row in browsers) ink.ofRow(row),
      ],
    ),
  ],
  margin: const ChartMargin(top: 24, left: 24, right: 24),
  tooltip: const ChartTooltipSpec(
    cursor: false,
    indicator: ChartIndicator.line,
    nameKey: 'visitors',
    hideLabel: true,
  ),
);

// specimen: chart-line-label
Widget lineLabel(ChartInk ink, ThemeTokens theme) => lineChart(
  ink.desktopMobile,
  monthsDesktopMobile,
  <ChartSeriesSpec>[
    _lineSeries(
      ink.slot(1),
      'desktop',
      CurveType.natural,
      dot: ChartDot(fill: ink.slot(1)),
      labels: <ChartLabelList>[
        ChartLabelList(offset: 12, color: theme.foreground),
      ],
    ),
  ],
  xAxis: monthAxis(),
  margin: const ChartMargin(top: 20, left: 12, right: 12),
  tooltip: const ChartTooltipSpec(
    cursor: false,
    indicator: ChartIndicator.line,
  ),
);

// specimen: chart-line-label-custom
Widget lineLabelCustom(ChartInk ink, ThemeTokens theme) => lineChart(
  ink.browser,
  browsers,
  <ChartSeriesSpec>[
    _lineSeries(
      ink.slot(2),
      'visitors',
      CurveType.natural,
      dot: ChartDot(fill: ink.slot(2)),
      labels: <ChartLabelList>[
        ChartLabelList(
          dataKey: 'browser',
          offset: 12,
          color: theme.foreground,
          formatter: _browserLabelOf,
        ),
      ],
    ),
  ],
  margin: const ChartMargin(top: 24, left: 24, right: 24),
  tooltip: const ChartTooltipSpec(
    cursor: false,
    indicator: ChartIndicator.line,
    nameKey: 'visitors',
    hideLabel: true,
  ),
);

String _browserLabelOf(Object? value) => browserLabel('$value');

// specimen: chart-line-interactive
Widget lineInteractive(BuildContext context, ChartInk ink) {
  final String active = SeriesScope.of(context);
  return plot(
    ink.desktopMobile.plus(<String, ChartSeries>{
      'views': const ChartSeries(label: 'Page Views'),
    }),
    CartesianChart(
      data: dailyVisits,
      margin: const ChartMargin(left: 12, right: 12),
      grid: const ChartGrid(vertical: false),
      xAxis: const ChartAxis(
        dataKey: 'date',
        tickLine: false,
        axisLine: false,
        tickMargin: 8,
        minTickGap: 32,
        tickFormatter: shortDate,
      ),
      tooltip: ChartTooltipSpec(
        nameKey: 'views',
        labelFormatter: shortDateYearLabel,
        // `className="w-40"`.
        width: space(40),
      ),
      series: <ChartSeriesSpec>[
        _lineSeries(seriesColour(ink, active), active, CurveType.monotone),
      ],
    ),
  );
}

/// The line specimens, and the list the gallery and the reference page read.
const List<ChartSpecimen> lineSpecimens = <ChartSpecimen>[
  ChartSpecimen(
    id: 'chart-line-default',
    note: 'dot={false}',
    skeleton: ChartSkeletonKind.line,
    build: _lineDefaultBuild,
  ),
  ChartSpecimen(
    id: 'chart-line-linear',
    note: 'type=linear',
    skeleton: ChartSkeletonKind.line,
    build: _lineLinearBuild,
  ),
  ChartSpecimen(
    id: 'chart-line-step',
    note: 'type=step',
    skeleton: ChartSkeletonKind.line,
    build: _lineStepBuild,
  ),
  ChartSpecimen(
    id: 'chart-line-multiple',
    note: 'three lines, three tokens',
    skeleton: ChartSkeletonKind.line,
    build: _lineMultipleBuild,
  ),
  ChartSpecimen(
    id: 'chart-line-dots',
    note: 'a dot on every point',
    skeleton: ChartSkeletonKind.line,
    build: _lineDotsBuild,
  ),
  ChartSpecimen(
    id: 'chart-line-dots-custom',
    note: 'dot as a render function',
    skeleton: ChartSkeletonKind.line,
    build: _lineDotsCustomBuild,
  ),
  ChartSpecimen(
    id: 'chart-line-dots-colors',
    note: 'a token per dot',
    skeleton: ChartSkeletonKind.line,
    build: _lineDotsColorsBuild,
  ),
  ChartSpecimen(
    id: 'chart-line-label',
    note: 'LabelList above the line',
    skeleton: ChartSkeletonKind.line,
    build: _lineLabelBuild,
  ),
  ChartSpecimen(
    id: 'chart-line-label-custom',
    note: 'LabelList with a render function',
    skeleton: ChartSkeletonKind.line,
    build: _lineLabelCustomBuild,
  ),
  ChartSpecimen(
    id: 'chart-line-interactive',
    note: 'series picker, travelling pill',
    skeleton: ChartSkeletonKind.line,
    build: lineInteractive,
    fullWidth: true,
  ),
];

Widget _lineDefaultBuild(BuildContext context, ChartInk ink) =>
    lineDefault(ink);
Widget _lineLinearBuild(BuildContext context, ChartInk ink) =>
    lineLinear(ink);
Widget _lineStepBuild(BuildContext context, ChartInk ink) => lineStep(ink);
Widget _lineMultipleBuild(BuildContext context, ChartInk ink) =>
    lineMultiple(ink);
Widget _lineDotsBuild(BuildContext context, ChartInk ink) => lineDots(ink);
Widget _lineDotsCustomBuild(BuildContext context, ChartInk ink) =>
    lineDotsCustom(ink, ThemeScope.of(context));
Widget _lineDotsColorsBuild(BuildContext context, ChartInk ink) =>
    lineDotsColors(ink);
Widget _lineLabelBuild(BuildContext context, ChartInk ink) =>
    lineLabel(ink, ThemeScope.of(context));
Widget _lineLabelCustomBuild(BuildContext context, ChartInk ink) =>
    lineLabelCustom(ink, ThemeScope.of(context));
