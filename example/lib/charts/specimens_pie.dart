/// The pie specimens, and the list the gallery and the reference page read.
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

/// The bare `Pie` eight of the eleven variants start from.
PieSpec _browserPie(
  ChartInk ink, {
  double? innerRadius,
  double strokeWidth = 1,
  int? activeIndex,
  double activeGrow = 0,
  bool activeRing = false,
  bool outsideLabel = false,
  bool labelLine = true,
  String Function(Map<String, Object?>)? labelBuilder,
  String? chipLabelKey,
  List<Map<String, Object?>>? data,
}) => PieSpec(
  data: ink.rows(data ?? browsers),
  dataKey: 'visitors',
  nameKey: 'browser',
  innerRadius: innerRadius,
  strokeWidth: strokeWidth,
  activeIndex: activeIndex,
  activeGrow: activeGrow,
  activeRing: activeRing,
  outsideLabel: outsideLabel,
  labelLine: labelLine,
  labelBuilder: labelBuilder,
  chipLabelKey: chipLabelKey,
);

// specimen: chart-pie-simple
Widget pieSimple(ChartInk ink) => plot(
  ink.browser,
  PieChart(
    pies: <PieSpec>[_browserPie(ink)],
    tooltip: const ChartTooltipSpec(cursor: false, hideLabel: true),
  ),
);

/// `stroke="0"` is the registry's own value, kept verbatim: the wedge
/// separator is a stroke WIDTH here, not a hue, and there is nothing in it for
/// a token to own.
// specimen: chart-pie-separator-none
Widget pieSeparatorNone(ChartInk ink) => plot(
  ink.browser,
  PieChart(
    pies: <PieSpec>[_browserPie(ink, strokeWidth: 0)],
    tooltip: const ChartTooltipSpec(cursor: false, hideLabel: true),
  ),
);

/// The label sits OUTSIDE the wedge, on the panel background, so this is a
/// background-contrast case rather than the on-fill one `PieLabelList` answers.
// specimen: chart-pie-label
Widget pieLabel(ChartInk ink, ThemeTokens theme) => plot(
  ink.browser,
  PieChart(
    pies: <PieSpec>[_browserPie(ink, outsideLabel: true)],
    labelColor: theme.foreground,
    tooltip: const ChartTooltipSpec(hideLabel: true),
  ),
);

/// The registry's custom `label` render function, swept once:
/// `fill="hsla(var(--foreground))"` → `--foreground`. It still lands outside
/// the wedge, so this is background contrast again.
// specimen: chart-pie-label-custom
Widget pieLabelCustom(ChartInk ink, ThemeTokens theme) => plot(
  ink.browser,
  PieChart(
    pies: <PieSpec>[
      _browserPie(
        ink,
        outsideLabel: true,
        labelLine: false,
        labelBuilder: (Map<String, Object?> row) =>
            chartNumber(row['visitors']! as num),
      ),
    ],
    labelColor: theme.foreground,
    tooltip: const ChartTooltipSpec(nameKey: 'visitors', hideLabel: true),
  ),
);

/// This family's real AA question, and the one the arithmetic decides —
/// see the chip widget in `chart_polar.dart` for the full derivation.
// specimen: chart-pie-label-list
Widget pieLabelList(ChartInk ink) => plot(
  ink.browser,
  PieChart(
    pies: <PieSpec>[_browserPie(ink, chipLabelKey: 'browser')],
    tooltip: const ChartTooltipSpec(nameKey: 'visitors', hideLabel: true),
  ),
);

/// No tooltip in this variant: the legend is the whole point.
// specimen: chart-pie-legend
Widget pieLegend(ChartInk ink) => plot(
  ink.browser,
  PieChart(
    pies: <PieSpec>[_browserPie(ink)],
    legend: const ChartLegendSpec(
      nameKey: 'browser',
      wrap: true,
      // `-translate-y-2`.
      offset: 8,
    ),
  ),
);

/// `innerRadius={60}` is the registry's own pixel value, kept rather than
/// reinstated as a percentage (drift 4: the panel's note still says
/// "percentage").
// specimen: chart-pie-donut
Widget pieDonut(ChartInk ink) => plot(
  ink.browser,
  PieChart(
    pies: <PieSpec>[_browserPie(ink, innerRadius: 60)],
    tooltip: const ChartTooltipSpec(cursor: false, hideLabel: true),
  ),
);

// specimen: chart-pie-donut-active
Widget pieDonutActive(ChartInk ink) => plot(
  ink.browser,
  PieChart(
    pies: <PieSpec>[
      _browserPie(
        ink,
        innerRadius: 60,
        strokeWidth: 5,
        activeIndex: 0,
        activeGrow: 10,
      ),
    ],
    tooltip: const ChartTooltipSpec(
      cursor: false,
      defaultIndex: 0,
      hideLabel: true,
    ),
  ),
);

/// Drift 5: `data.ts` calls this "+12 firefox / +100 other" and both raised
/// rows are +100. `pie.tsx` flags it and does not reconcile it.
const List<Map<String, Object?>> _pieDonutTextData = <Map<String, Object?>>[
  <String, Object?>{'browser': 'chrome', 'visitors': 275, 'slot': 1},
  <String, Object?>{'browser': 'safari', 'visitors': 200, 'slot': 2},
  <String, Object?>{'browser': 'firefox', 'visitors': 287, 'slot': 3},
  <String, Object?>{'browser': 'edge', 'visitors': 173, 'slot': 4},
  <String, Object?>{'browser': 'other', 'visitors': 190, 'slot': 5},
];

// specimen: chart-pie-donut-text
Widget pieDonutText(ChartInk ink) {
  final int total = _pieDonutTextData.fold<int>(
    0,
    (int acc, Map<String, Object?> row) => acc + (row['visitors']! as int),
  );
  return plot(
    ink.browser,
    PieChart(
      pies: <PieSpec>[
        _browserPie(
          ink,
          innerRadius: 60,
          strokeWidth: 5,
          data: _pieDonutTextData,
        ),
      ],
      centerLabel: (BuildContext context) =>
          donutCentre(context, chartNumber(total), 'Visitors'),
      tooltip: const ChartTooltipSpec(cursor: false, hideLabel: true),
    ),
  );
}

/// Two rings, one dataset each.
// specimen: chart-pie-stacked
Widget pieStacked(ChartInk ink) => plot(
  ink.pieMonths,
  PieChart(
    pies: <PieSpec>[
      PieSpec(
        data: ink.rows(pieMonthsDesktop),
        dataKey: 'desktop',
        nameKey: 'month',
        outerRadius: 60,
      ),
      PieSpec(
        data: ink.rows(pieMonthsMobile),
        dataKey: 'mobile',
        nameKey: 'month',
        innerRadius: 70,
        outerRadius: 90,
      ),
    ],
    tooltip: const ChartTooltipSpec(
      labelKey: 'visitors',
      nameKey: 'month',
      indicator: ChartIndicator.line,
    ),
  ),
);

// specimen: chart-pie-interactive
Widget pieInteractive(
  BuildContext context,
  ChartInk ink,
  int activeIndex,
) => plot(
  ink.pieMonths,
  PieChart(
    pies: <PieSpec>[
      PieSpec(
        data: ink.rows(pieMonthsDesktop),
        dataKey: 'desktop',
        nameKey: 'month',
        innerRadius: 60,
        strokeWidth: 5,
        activeIndex: activeIndex,
        activeGrow: 10,
        activeRing: true,
      ),
    ],
    centerLabel: (BuildContext context) => donutCentre(
      context,
      chartNumber(pieMonthsDesktop[activeIndex]['desktop']! as num),
      'Visitors',
    ),
    tooltip: ChartTooltipSpec(
      cursor: false,
      defaultIndex: activeIndex,
      hideLabel: true,
    ),
  ),
);

/// The active slice, handed down through the keyed slot.
class PieActiveScope extends InheritedWidget {
  const PieActiveScope({super.key, required this.index, required super.child});

  final int index;

  static int of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<PieActiveScope>()?.index ??
      0;

  @override
  bool updateShouldNotify(PieActiveScope old) => old.index != index;
}

/// The pie specimens, and the list the gallery and the reference page read.
const List<ChartSpecimen> pieSpecimens = <ChartSpecimen>[
  ChartSpecimen(
    id: 'chart-pie-simple',
    note: 'fill carried on each datum',
    skeleton: ChartSkeletonKind.pie,
    build: _pieSimpleBuild,
  ),
  ChartSpecimen(
    id: 'chart-pie-separator-none',
    note: 'paddingAngle={0}',
    skeleton: ChartSkeletonKind.pie,
    build: _pieSeparatorNoneBuild,
  ),
  ChartSpecimen(
    id: 'chart-pie-label',
    note: 'labels outside, with leader lines',
    skeleton: ChartSkeletonKind.pie,
    build: _pieLabelBuild,
  ),
  ChartSpecimen(
    id: 'chart-pie-label-custom',
    note: 'label as a render function',
    skeleton: ChartSkeletonKind.pie,
    build: _pieLabelCustomBuild,
  ),
  ChartSpecimen(
    id: 'chart-pie-label-list',
    note: 'on a card chip — the fill cannot clear AA',
    skeleton: ChartSkeletonKind.pie,
    build: _pieLabelListBuild,
  ),
  ChartSpecimen(
    id: 'chart-pie-legend',
    note: 'ChartLegendContent, no tooltip',
    skeleton: ChartSkeletonKind.pie,
    build: _pieLegendBuild,
  ),
  ChartSpecimen(
    id: 'chart-pie-donut',
    note: 'innerRadius as a percentage',
    skeleton: ChartSkeletonKind.pie,
    build: _pieDonutBuild,
  ),
  ChartSpecimen(
    id: 'chart-pie-donut-active',
    note: 'activeIndex grows one slice',
    skeleton: ChartSkeletonKind.pie,
    build: _pieDonutActiveBuild,
  ),
  ChartSpecimen(
    id: 'chart-pie-donut-text',
    note: 'the total in the hole',
    skeleton: ChartSkeletonKind.pie,
    build: _pieDonutTextBuild,
  ),
  ChartSpecimen(
    id: 'chart-pie-stacked',
    note: 'two rings, one chart',
    skeleton: ChartSkeletonKind.pie,
    build: _pieStackedBuild,
  ),
  ChartSpecimen(
    id: 'chart-pie-interactive',
    note: 'slice picker, travelling pill',
    skeleton: ChartSkeletonKind.pie,
    build: _pieInteractiveBuild,
    fullWidth: true,
  ),
];

Widget _pieSimpleBuild(BuildContext context, ChartInk ink) => pieSimple(ink);
Widget _pieSeparatorNoneBuild(BuildContext context, ChartInk ink) =>
    pieSeparatorNone(ink);
Widget _pieLabelBuild(BuildContext context, ChartInk ink) =>
    pieLabel(ink, ThemeScope.of(context));
Widget _pieLabelCustomBuild(BuildContext context, ChartInk ink) =>
    pieLabelCustom(ink, ThemeScope.of(context));
Widget _pieLabelListBuild(BuildContext context, ChartInk ink) =>
    pieLabelList(ink);
Widget _pieLegendBuild(BuildContext context, ChartInk ink) => pieLegend(ink);
Widget _pieDonutBuild(BuildContext context, ChartInk ink) => pieDonut(ink);
Widget _pieDonutActiveBuild(BuildContext context, ChartInk ink) =>
    pieDonutActive(ink);
Widget _pieDonutTextBuild(BuildContext context, ChartInk ink) =>
    pieDonutText(ink);
Widget _pieStackedBuild(BuildContext context, ChartInk ink) =>
    pieStacked(ink);
Widget _pieInteractiveBuild(BuildContext context, ChartInk ink) =>
    pieInteractive(context, ink, PieActiveScope.of(context));
