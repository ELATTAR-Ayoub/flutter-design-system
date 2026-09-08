/// The bar specimens, and the list the gallery and the reference page read.
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

/// The X axis six of the ten bar variants share (`tickMargin` 10, not 8).
const ChartAxis _barMonthAxis = ChartAxis(
  dataKey: 'month',
  tickLine: false,
  axisLine: false,
  tickMargin: 10,
  tickFormatter: month3,
);

// specimen: chart-bar-default
Widget barDefault(ChartInk ink) => plot(
  ink.desktop,
  CartesianChart(
    data: monthsDesktop,
    grid: const ChartGrid(vertical: false),
    xAxis: _barMonthAxis,
    tooltip: const ChartTooltipSpec(cursor: false, hideLabel: true),
    series: <ChartSeriesSpec>[
      ChartSeriesSpec(
        kind: ChartSeriesKind.bar,
        dataKey: 'desktop',
        fill: ink.slot(1),
        radii: radiiAll,
      ),
    ],
  ),
);

/// `layout="vertical"`, `YAxis type="category"`: the same chart rotated, and
/// the one the page warns *"reads backwards until you have hit it once"*.
// specimen: chart-bar-horizontal
Widget barHorizontal(ChartInk ink) => plot(
  ink.desktop,
  CartesianChart(
    data: monthsDesktop,
    layout: ChartLayout.vertical,
    margin: const ChartMargin(left: -20),
    xAxis: const ChartAxis(
      type: ChartAxisType.number,
      dataKey: 'desktop',
      hide: true,
    ),
    yAxis: const ChartAxis(
      dataKey: 'month',
      tickLine: false,
      axisLine: false,
      tickMargin: 10,
      tickFormatter: month3,
    ),
    tooltip: const ChartTooltipSpec(cursor: false, hideLabel: true),
    series: <ChartSeriesSpec>[
      ChartSeriesSpec(
        kind: ChartSeriesKind.bar,
        dataKey: 'desktop',
        fill: ink.slot(1),
        radii: radiiAll,
      ),
    ],
  ),
);

// specimen: chart-bar-multiple
Widget barMultiple(ChartInk ink) => plot(
  ink.desktopMobile,
  CartesianChart(
    data: monthsDesktopMobile,
    grid: const ChartGrid(vertical: false),
    xAxis: _barMonthAxis,
    tooltip: const ChartTooltipSpec(
      cursor: false,
      indicator: ChartIndicator.dashed,
    ),
    series: <ChartSeriesSpec>[
      ChartSeriesSpec(
        kind: ChartSeriesKind.bar,
        dataKey: 'desktop',
        fill: ink.slot(1),
        radii: radiiAll,
      ),
      ChartSeriesSpec(
        kind: ChartSeriesKind.bar,
        dataKey: 'mobile',
        fill: ink.slot(2),
        radii: radiiAll,
      ),
    ],
  ),
);

/// Two bars sharing a `stackId`. Only the zeros' position is geometry: the
/// radius itself is `--radius-sm`, one rung for the whole family.
// specimen: chart-bar-stacked
Widget barStacked(ChartInk ink) => plot(
  ink.desktopMobile,
  CartesianChart(
    data: monthsDesktopMobile,
    grid: const ChartGrid(vertical: false),
    xAxis: _barMonthAxis,
    tooltip: const ChartTooltipSpec(hideLabel: true),
    legend: const ChartLegendSpec(),
    series: <ChartSeriesSpec>[
      ChartSeriesSpec(
        kind: ChartSeriesKind.bar,
        dataKey: 'desktop',
        stackId: 'a',
        fill: ink.slot(1),
        radii: radiiBottom,
      ),
      ChartSeriesSpec(
        kind: ChartSeriesKind.bar,
        dataKey: 'mobile',
        stackId: 'a',
        fill: ink.slot(2),
        radii: radiiTop,
      ),
    ],
  ),
);

/// The registry sets `fontSize={12}` on this `LabelList`: a raw SVG number
/// for a value the type scale already owns. `text-xs` reaches the same size
/// through CSS; here it is [ChartText.xs], which is the same statement.
// specimen: chart-bar-label
Widget barLabel(ChartInk ink, ThemeTokens theme) => plot(
  ink.desktop,
  CartesianChart(
    data: monthsDesktop,
    margin: const ChartMargin(top: 20),
    grid: const ChartGrid(vertical: false),
    xAxis: _barMonthAxis,
    tooltip: const ChartTooltipSpec(cursor: false, hideLabel: true),
    series: <ChartSeriesSpec>[
      ChartSeriesSpec(
        kind: ChartSeriesKind.bar,
        dataKey: 'desktop',
        fill: ink.slot(1),
        radii: radiiAll,
        labels: <ChartLabelList>[
          ChartLabelList(offset: 12, color: theme.foreground),
        ],
      ),
    ],
  ),
);

/// The registry mints a per-container `--color-label` so the in-bar month text
/// can contrast against the bar's own fill; `bar.tsx` replaces it with
/// `fill-background`, which is a themed utility rather than a runtime mint.
// specimen: chart-bar-label-custom
Widget barLabelCustom(ChartInk ink, ThemeTokens theme) => plot(
  ink.desktop,
  CartesianChart(
    data: monthsDesktop,
    layout: ChartLayout.vertical,
    margin: const ChartMargin(right: 16),
    grid: const ChartGrid(horizontal: false),
    yAxis: const ChartAxis(
      dataKey: 'month',
      tickLine: false,
      axisLine: false,
      hide: true,
    ),
    xAxis: const ChartAxis(
      dataKey: 'desktop',
      type: ChartAxisType.number,
      hide: true,
    ),
    tooltip: const ChartTooltipSpec(
      cursor: false,
      indicator: ChartIndicator.line,
    ),
    series: <ChartSeriesSpec>[
      ChartSeriesSpec(
        kind: ChartSeriesKind.bar,
        dataKey: 'desktop',
        fill: ink.slot(1),
        radii: radiiAll,
        labels: <ChartLabelList>[
          ChartLabelList(
            dataKey: 'month',
            position: ChartLabelPosition.insideLeft,
            offset: 8,
            color: theme.background,
          ),
          ChartLabelList(
            dataKey: 'desktop',
            position: ChartLabelPosition.right,
            offset: 8,
            color: theme.foreground,
          ),
        ],
      ),
    ],
  ),
);

/// One `Bar`, a colour per datum. No `fill` on the series: each row in
/// `BROWSERS` already carries its own.
// specimen: chart-bar-mixed
Widget barMixed(ChartInk ink) => plot(
  ink.browser,
  CartesianChart(
    data: browsers,
    layout: ChartLayout.vertical,
    margin: const ChartMargin(left: 0),
    yAxis: ChartAxis(
      dataKey: 'browser',
      tickLine: false,
      axisLine: false,
      tickMargin: 10,
      tickFormatter: (Object? v) => browserLabel('$v'),
    ),
    xAxis: const ChartAxis(
      dataKey: 'visitors',
      type: ChartAxisType.number,
      hide: true,
    ),
    tooltip: const ChartTooltipSpec(cursor: false, hideLabel: true),
    series: <ChartSeriesSpec>[
      ChartSeriesSpec(
        kind: ChartSeriesKind.bar,
        dataKey: 'visitors',
        radii: radiiAll,
        cellFills: <Color>[
          for (final Map<String, Object?> row in browsers) ink.ofRow(row),
        ],
      ),
    ],
  ),
);

/// `data.ts` names this shape as one of the eight kept local: `BROWSERS`
/// reordered, so the "active" third bar lands on firefox rather than chrome.
const List<Map<String, Object?>> _barActiveData = <Map<String, Object?>>[
  <String, Object?>{'browser': 'chrome', 'visitors': 187, 'slot': 1},
  <String, Object?>{'browser': 'safari', 'visitors': 200, 'slot': 2},
  <String, Object?>{'browser': 'firefox', 'visitors': 275, 'slot': 3},
  <String, Object?>{'browser': 'edge', 'visitors': 173, 'slot': 4},
  <String, Object?>{'browser': 'other', 'visitors': 90, 'slot': 5},
];

/// `activeIndex` moved off `Bar` between recharts v2 and v3: it is now
/// `Tooltip`'s `defaultIndex`, which is why this specimen shows a panel with no
/// pointer anywhere near it.
// specimen: chart-bar-active
Widget barActive(ChartInk ink) => plot(
  ink.browser,
  CartesianChart(
    data: _barActiveData,
    grid: const ChartGrid(vertical: false),
    xAxis: ChartAxis(
      dataKey: 'browser',
      tickLine: false,
      axisLine: false,
      tickMargin: 10,
      tickFormatter: (Object? v) => browserLabel('$v'),
    ),
    tooltip: const ChartTooltipSpec(
      cursor: false,
      defaultIndex: 2,
      hideLabel: true,
    ),
    series: <ChartSeriesSpec>[
      ChartSeriesSpec(
        kind: ChartSeriesKind.bar,
        dataKey: 'visitors',
        radii: radiiAll,
        cellFills: <Color>[
          for (final Map<String, Object?> row in _barActiveData) ink.ofRow(row),
        ],
      ),
    ],
  ),
);

/// Kept local per `data.ts`, `{ month, visitors }` with two negative rows.
const List<Map<String, Object?>> _barNegativeData = <Map<String, Object?>>[
  <String, Object?>{'month': 'January', 'visitors': 186},
  <String, Object?>{'month': 'February', 'visitors': 205},
  <String, Object?>{'month': 'March', 'visitors': -207},
  <String, Object?>{'month': 'April', 'visitors': 173},
  <String, Object?>{'month': 'May', 'visitors': -209},
  <String, Object?>{'month': 'June', 'visitors': 214},
];

/// §1.4 / §5, *a delta is a shape before it is a hue*. A figure that can fall
/// is not an error, so the falling half does not reach for `destructive`: the
/// direction is already legible from each bar's own position above or below the
/// zero baseline, and the registry's own choice separates the two with
/// `--chart-1` / `--chart-2`, both neutral action-ramp hues.
// specimen: chart-bar-negative
Widget barNegative(ChartInk ink, ThemeTokens theme) => plot(
  ChartConfig(<String, ChartSeries>{
    'visitors': const ChartSeries(label: 'Visitors'),
  }),
  CartesianChart(
    data: _barNegativeData,
    grid: const ChartGrid(vertical: false),
    tooltip: const ChartTooltipSpec(
      cursor: false,
      hideLabel: true,
      hideIndicator: true,
    ),
    series: <ChartSeriesSpec>[
      ChartSeriesSpec(
        kind: ChartSeriesKind.bar,
        dataKey: 'visitors',
        cellFills: <Color>[
          for (final Map<String, Object?> row in _barNegativeData)
            (row['visitors']! as num) > 0 ? ink.slot(1) : ink.slot(2),
        ],
        labels: <ChartLabelList>[
          // No explicit fill in the registry means recharts' own untokenised
          // grey paints the month labels: the same class of failure
          // `ui/chart.tsx` measured on the axis ticks. `fill-foreground`
          // closes it.
          ChartLabelList(dataKey: 'month', color: theme.foreground),
        ],
      ),
    ],
  ),
);

// specimen: chart-bar-interactive
Widget barInteractive(BuildContext context, ChartInk ink) {
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
      tooltip: const ChartTooltipSpec(
        nameKey: 'views',
        labelFormatter: shortDateYearLabel,
      ),
      series: <ChartSeriesSpec>[
        ChartSeriesSpec(
          kind: ChartSeriesKind.bar,
          dataKey: active,
          fill: seriesColour(ink, active),
        ),
      ],
    ),
  );
}

/// The bar specimens, and the list the gallery and the reference page read.
const List<ChartSpecimen> barSpecimens = <ChartSpecimen>[
  ChartSpecimen(
    id: 'chart-bar-default',
    note: 'one series',
    skeleton: ChartSkeletonKind.bar,
    build: _barDefaultBuild,
  ),
  ChartSpecimen(
    id: 'chart-bar-horizontal',
    note: 'layout=vertical, YAxis type=category',
    skeleton: ChartSkeletonKind.bar,
    build: _barHorizontalBuild,
  ),
  ChartSpecimen(
    id: 'chart-bar-multiple',
    note: 'two Bars, no stackId',
    skeleton: ChartSkeletonKind.bar,
    build: _barMultipleBuild,
  ),
  ChartSpecimen(
    id: 'chart-bar-stacked',
    note: 'three Bars sharing a stackId',
    skeleton: ChartSkeletonKind.bar,
    build: _barStackedBuild,
  ),
  ChartSpecimen(
    id: 'chart-bar-label',
    note: 'LabelList on the bar',
    skeleton: ChartSkeletonKind.bar,
    build: _barLabelBuild,
  ),
  ChartSpecimen(
    id: 'chart-bar-label-custom',
    note: 'LabelList with a render function',
    skeleton: ChartSkeletonKind.bar,
    build: _barLabelCustomBuild,
  ),
  ChartSpecimen(
    id: 'chart-bar-mixed',
    note: 'one Bar, a colour per datum',
    skeleton: ChartSkeletonKind.bar,
    build: _barMixedBuild,
  ),
  ChartSpecimen(
    id: 'chart-bar-active',
    note: 'activeIndex highlights one',
    skeleton: ChartSkeletonKind.bar,
    build: _barActiveBuild,
  ),
  ChartSpecimen(
    id: 'chart-bar-negative',
    note: 'values below zero — direction by position, not by red',
    skeleton: ChartSkeletonKind.bar,
    build: _barNegativeBuild,
  ),
  ChartSpecimen(
    id: 'chart-bar-interactive',
    note: 'series picker, travelling pill',
    skeleton: ChartSkeletonKind.bar,
    build: barInteractive,
    fullWidth: true,
  ),
];

Widget _barDefaultBuild(BuildContext context, ChartInk ink) => barDefault(ink);
Widget _barHorizontalBuild(BuildContext context, ChartInk ink) =>
    barHorizontal(ink);
Widget _barMultipleBuild(BuildContext context, ChartInk ink) =>
    barMultiple(ink);
Widget _barStackedBuild(BuildContext context, ChartInk ink) => barStacked(ink);
Widget _barLabelBuild(BuildContext context, ChartInk ink) =>
    barLabel(ink, ThemeScope.of(context));
Widget _barLabelCustomBuild(BuildContext context, ChartInk ink) =>
    barLabelCustom(ink, ThemeScope.of(context));
Widget _barMixedBuild(BuildContext context, ChartInk ink) => barMixed(ink);
Widget _barActiveBuild(BuildContext context, ChartInk ink) => barActive(ink);
Widget _barNegativeBuild(BuildContext context, ChartInk ink) =>
    barNegative(ink, ThemeScope.of(context));
