/// The radial specimens, and the list the gallery and the reference page
/// read.
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

/// `radial.tsx`'s two rungs. *"`10` is exactly the `md` rung already, on a
/// 30px-thick single ring… `5` is not a rung at all and moves to `sm` (6), the
/// same rung every bar corner in this system already takes."*
const double _ringRadius = Radii.md;
const double _stackRadius = Radii.sm;

// specimen: chart-radial-simple
Widget radialSimple(ChartInk ink) => plot(
  ink.browser,
  RadialBarChart(
    data: ink.rows(browsers),
    innerRadius: 30,
    outerRadius: 110,
    series: const <RadialBarSpec>[
      RadialBarSpec(dataKey: 'visitors', background: true),
    ],
    tooltip: const ChartTooltipSpec(
      cursor: false,
      hideLabel: true,
      nameKey: 'browser',
    ),
  ),
);

// specimen: chart-radial-grid
Widget radialGrid(ChartInk ink) => plot(
  ink.browser,
  RadialBarChart(
    data: ink.rows(browsers),
    innerRadius: 30,
    outerRadius: 100,
    grid: const PolarGrid(gridType: PolarGridType.circle),
    series: const <RadialBarSpec>[RadialBarSpec(dataKey: 'visitors')],
    tooltip: const ChartTooltipSpec(
      cursor: false,
      hideLabel: true,
      nameKey: 'browser',
    ),
  ),
);

/// The labels sit at each arc's START angle, which is both the registry's own
/// position and the only placement where five of them cannot collide: at the
/// mid-angle they came out 19.9px apart for labels 48px wide.
// specimen: chart-radial-label
Widget radialLabel(ChartInk ink) => plot(
  ink.browser,
  RadialBarChart(
    data: ink.rows(browsers),
    startAngle: -90,
    endAngle: 380,
    innerRadius: 30,
    outerRadius: 110,
    series: const <RadialBarSpec>[
      RadialBarSpec(
        dataKey: 'visitors',
        background: true,
        chipLabelKey: 'browser',
      ),
    ],
    tooltip: const ChartTooltipSpec(
      cursor: false,
      hideLabel: true,
      nameKey: 'browser',
    ),
  ),
);

/// A single browser row, used by nothing else.
const List<Map<String, Object?>> _radialTextData = <Map<String, Object?>>[
  <String, Object?>{'browser': 'safari', 'visitors': 200, 'slot': 2},
];

/// Drift 6: the panel's note calls this "a custom activeShape" and the vendored
/// source has none: it is `chart-radial-text` with a different sweep and a
/// different number (1260 rather than 200).
const List<Map<String, Object?>> _radialShapeData = <Map<String, Object?>>[
  <String, Object?>{'browser': 'safari', 'visitors': 1260, 'slot': 2},
];

PolarGrid _radialPlate(ThemeTokens theme) => PolarGrid(
  gridType: PolarGridType.circle,
  radialLines: false,
  // `className="first:fill-muted last:fill-background"`.
  fills: <Color>[theme.muted, theme.background],
  polarRadius: const <double>[86, 74],
);

// specimen: chart-radial-text
Widget radialText(ChartInk ink, ThemeTokens theme) => plot(
  ChartConfig(<String, ChartSeries>{
    'visitors': const ChartSeries(label: 'Visitors'),
    'safari': ChartSeries(label: 'Safari', color: ink.slot(2)),
  }),
  RadialBarChart(
    data: ink.rows(_radialTextData),
    startAngle: 0,
    endAngle: 250,
    innerRadius: 80,
    outerRadius: 110,
    grid: _radialPlate(theme),
    series: const <RadialBarSpec>[
      RadialBarSpec(
        dataKey: 'visitors',
        background: true,
        cornerRadius: _ringRadius,
      ),
    ],
    radiusAxis: PolarRadiusAxis(
      tick: false,
      axisLine: false,
      centerLabel: (BuildContext context) =>
          donutCentre(context, chartNumber(200), 'Visitors'),
    ),
  ),
);

// specimen: chart-radial-shape
Widget radialShape(ChartInk ink, ThemeTokens theme) => plot(
  ChartConfig(<String, ChartSeries>{
    'visitors': const ChartSeries(label: 'Visitors'),
    'safari': ChartSeries(label: 'Safari', color: ink.slot(2)),
  }),
  RadialBarChart(
    data: ink.rows(_radialShapeData),
    endAngle: 100,
    innerRadius: 80,
    outerRadius: 140,
    grid: _radialPlate(theme),
    series: const <RadialBarSpec>[
      RadialBarSpec(dataKey: 'visitors', background: true),
    ],
    radiusAxis: PolarRadiusAxis(
      tick: false,
      axisLine: false,
      centerLabel: (BuildContext context) =>
          donutCentre(context, chartNumber(1260), 'Visitors'),
    ),
  ),
);

/// A single `{ month, desktop, mobile }` row. The registry names it
/// `"january"`; kept, though it plays no visual role: there is no category
/// axis rendering it.
const List<Map<String, Object?>> _radialStackedData = <Map<String, Object?>>[
  <String, Object?>{'month': 'january', 'desktop': 1260, 'mobile': 570},
];

/// The explicit `PolarAngleAxis domain` is the fix for this family's headline
/// error: left alone the angle-axis domain runs to the largest SINGLE series
/// rather than to the stack total, so the first ring fills the whole sweep and
/// the one behind it is clipped to nothing: no error, no warning.
// specimen: chart-radial-stacked
Widget radialStacked(ChartInk ink) {
  const int total = 1260 + 570;
  return plot(
    ink.desktopMobile,
    RadialBarChart(
      data: _radialStackedData,
      endAngle: 180,
      innerRadius: 80,
      outerRadius: 130,
      angleAxis: PolarAngleAxis(
        tick: false,
        axisLine: false,
        domain: (min: 0, max: total.toDouble()),
      ),
      radiusAxis: PolarRadiusAxis(
        tick: false,
        axisLine: false,
        centerLabel: (BuildContext context) {
          final ThemeTokens theme = ThemeScope.of(context);
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              StyledText(
                chartNumber(total),
                TextStyles.numberLg,
                color: theme.foreground,
              ),
              SizedBox(height: space(1)),
              StyledText(
                'Visitors',
                ChartText.xs,
                color: theme.mutedForeground,
              ),
            ],
          );
        },
      ),
      series: <RadialBarSpec>[
        RadialBarSpec(
          dataKey: 'desktop',
          stackId: 'a',
          cornerRadius: _stackRadius,
          fill: ink.slot(1),
        ),
        RadialBarSpec(
          dataKey: 'mobile',
          stackId: 'a',
          cornerRadius: _stackRadius,
          fill: ink.slot(2),
        ),
      ],
      tooltip: const ChartTooltipSpec(cursor: false, hideLabel: true),
    ),
  );
}

/// The radial specimens, and the list the gallery and the reference page
/// read.
const List<ChartSpecimen> radialSpecimens = <ChartSpecimen>[
  ChartSpecimen(
    id: 'chart-radial-simple',
    note: 'background rings, one bar per tier',
    skeleton: ChartSkeletonKind.radial,
    build: _radialSimpleBuild,
  ),
  ChartSpecimen(
    id: 'chart-radial-grid',
    note: 'PolarGrid inside the ring',
    skeleton: ChartSkeletonKind.radial,
    build: _radialGridBuild,
  ),
  ChartSpecimen(
    id: 'chart-radial-label',
    note: 'on a card chip — the arc cannot clear AA',
    skeleton: ChartSkeletonKind.radial,
    build: _radialLabelBuild,
  ),
  ChartSpecimen(
    id: 'chart-radial-text',
    note: 'the total in the hole',
    skeleton: ChartSkeletonKind.radial,
    build: _radialTextBuild,
  ),
  ChartSpecimen(
    id: 'chart-radial-shape',
    note: 'a custom activeShape',
    skeleton: ChartSkeletonKind.radial,
    build: _radialShapeBuild,
  ),
  ChartSpecimen(
    id: 'chart-radial-stacked',
    note: 'startAngle 180 → endAngle 0',
    skeleton: ChartSkeletonKind.radial,
    build: _radialStackedBuild,
  ),
];

Widget _radialSimpleBuild(BuildContext context, ChartInk ink) =>
    radialSimple(ink);
Widget _radialGridBuild(BuildContext context, ChartInk ink) => radialGrid(ink);
Widget _radialLabelBuild(BuildContext context, ChartInk ink) =>
    radialLabel(ink);
Widget _radialTextBuild(BuildContext context, ChartInk ink) =>
    radialText(ink, ThemeScope.of(context));
Widget _radialShapeBuild(BuildContext context, ChartInk ink) =>
    radialShape(ink, ThemeScope.of(context));
Widget _radialStackedBuild(BuildContext context, ChartInk ink) =>
    radialStacked(ink);
