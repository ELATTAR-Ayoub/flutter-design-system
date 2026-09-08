/// The tooltip specimens, and the list the gallery and the reference page
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

/// `{ weekday: "short" }`: the tooltip family's whole X axis.
///
/// `DateFormat` carries the long names and the narrow ones; en-US's short
/// weekday is the long name's first three letters, so this derives rather than
/// declaring a seventh list.
String _weekdayShort(Object? value) {
  final DateTime d = DateTime.parse('$value');
  return DateFormat.weekdaysLong[d.weekday % 7].substring(0, 3);
}

/// `{ day: "numeric", month: "long", year: "numeric" }`, `TooltipLabelFormatter`.
String _longDate(Object? value) {
  final DateTime d = DateTime.parse('$value');
  return '${DateFormat.monthsLong[d.month - 1]} ${d.day}, ${d.year}';
}

String _longDateLabel(String label, List<ChartTooltipItem> items) =>
    _longDate(label);

/// Every one of the nine is the SAME two-series stacked bar chart, because the
/// family's whole point is that only the tooltip's configuration changes. No
/// `CartesianGrid`, no `YAxis`: the registry source for all nine omits both.
Widget tooltipChart(
  ChartInk ink,
  ChartConfig config,
  ChartTooltipSpec tooltip,
) => plot(
  config,
  CartesianChart(
    data: sportDays,
    xAxis: const ChartAxis(
      dataKey: 'date',
      tickLine: false,
      tickMargin: 10,
      axisLine: false,
      tickFormatter: _weekdayShort,
    ),
    tooltip: tooltip,
    series: <ChartSeriesSpec>[
      ChartSeriesSpec(
        kind: ChartSeriesKind.bar,
        dataKey: 'running',
        stackId: 'a',
        fill: ink.slot(1),
        radii: radiiBottom,
      ),
      ChartSeriesSpec(
        kind: ChartSeriesKind.bar,
        dataKey: 'swimming',
        stackId: 'a',
        fill: ink.slot(2),
        radii: radiiTop,
      ),
    ],
  ),
);

// specimen: chart-tooltip-default
Widget tooltipDefault(ChartInk ink) => tooltipChart(
  ink,
  ink.sport,
  const ChartTooltipSpec(cursor: false, defaultIndex: 1),
);

// specimen: chart-tooltip-indicator-line
Widget tooltipIndicatorLine(ChartInk ink) => tooltipChart(
  ink,
  ink.sport,
  const ChartTooltipSpec(
    cursor: false,
    defaultIndex: 1,
    indicator: ChartIndicator.line,
  ),
);

// specimen: chart-tooltip-indicator-none
Widget tooltipIndicatorNone(ChartInk ink) => tooltipChart(
  ink,
  ink.sport,
  const ChartTooltipSpec(cursor: false, defaultIndex: 1, hideIndicator: true),
);

/// The registry's one extra config key: a label that never comes from the
/// hovered row at all, so the header always reads "Activities" rather than the
/// day. `labelKey` routes the lookup at it, and the fallback in
/// `getPayloadConfigFromPayload` is what makes a key naming no field work.
// specimen: chart-tooltip-label-custom
Widget tooltipLabelCustom(ChartInk ink) => tooltipChart(
  ink,
  ink.sport.plus(<String, ChartSeries>{
    'activities': const ChartSeries(label: 'Activities'),
  }),
  const ChartTooltipSpec(
    cursor: false,
    defaultIndex: 1,
    labelKey: 'activities',
    indicator: ChartIndicator.line,
  ),
);

// specimen: chart-tooltip-label-formatter
Widget tooltipLabelFormatter(ChartInk ink) => tooltipChart(
  ink,
  ink.sport,
  const ChartTooltipSpec(
    cursor: false,
    defaultIndex: 1,
    labelFormatter: _longDateLabel,
  ),
);

// specimen: chart-tooltip-label-none
Widget tooltipLabelNone(ChartInk ink) => tooltipChart(
  ink,
  ink.sport,
  const ChartTooltipSpec(
    cursor: false,
    defaultIndex: 1,
    hideIndicator: true,
    hideLabel: true,
  ),
);

/// Supplying `formatter` opts a row out of the default renderer entirely, so
/// this one rebuilds by hand what the default already does: which is why
/// `min-w-[130px]` in the registry becomes `min-w-32`, the exact width the
/// default box opens with.
// specimen: chart-tooltip-formatter
Widget tooltipFormatter(ChartInk ink) => tooltipChart(
  ink,
  ink.sport,
  ChartTooltipSpec(
    cursor: false,
    defaultIndex: 1,
    hideLabel: true,
    formatter: (BuildContext context, ChartTooltipItem item, int index) =>
        _KcalRow(item: item),
  ),
);

/// `flex min-w-32 items-center text-xs text-muted-foreground`, with the figure
/// and its unit pushed to the end.
class _KcalRow extends StatelessWidget {
  const _KcalRow({required this.item, this.showTotal = false, this.total = 0});

  final ChartTooltipItem item;
  final bool showTotal;
  final int total;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: ChartTooltipContent.minWidth),
          // `Wrap`, not a `Row`: the advanced tooltip fixes its own width at
          // `w-44` (a spec value, not a layout column), and at 200% text a
          // sport name plus its figure can still outgrow that regardless of
          // which side gives room. `Wrap` drops the figure to its own line
          // rather than asserting when even that is not enough.
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: space(2),
            runSpacing: space(0.5),
            children: <Widget>[
              StyledText(
                item.name == 'running' ? 'Running' : 'Swimming',
                ChartText.xs,
                color: theme.mutedForeground,
              ),
              _Kcal(value: item.value ?? 0),
            ],
          ),
        ),
        if (showTotal) ...<Widget>[
          SizedBox(height: space(1.5)),
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: theme.border,
                  width: BorderWidths.hairline,
                ),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(top: space(1.5)),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: space(2),
                runSpacing: space(0.5),
                children: <Widget>[
                  StyledText(
                    'Total',
                    ChartText.xsMedium,
                    color: theme.foreground,
                  ),
                  _Kcal(value: total),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _Kcal extends StatelessWidget {
  const _Kcal({required this.value});

  final num value;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: <Widget>[
        // Flexible so a tooltip squeezed to its `min-w` at 200% text can
        // still shrink the figure instead of asserting; `mainAxisSize.min`
        // alone only affects how much of the *given* space this row claims,
        // not whether the given space is enough.
        Flexible(
          child: StyledText(
            chartNumber(value),
            TextStyles.numberSm,
            color: theme.foreground,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: space(0.5)),
        // `font-normal text-muted-foreground`: the unit steps down out of the
        // figure's own weight.
        StyledText('kcal', ChartText.xs, color: theme.mutedForeground),
      ],
    );
  }
}

/// Faithful to the registry's own pairing, `Footprints`/running,
/// `Waves`/swimming. `tooltip.tsx` routes both through `Icon` by wrapping them
/// in a zero-arg component; the builder slot here needs no such wrapper.
// specimen: chart-tooltip-icons
Widget tooltipIcons(ChartInk ink) => tooltipChart(
  ink,
  ChartConfig(<String, ChartSeries>{
    'running': ChartSeries(
      label: 'Running',
      color: ink.slot(1),
      icon: (BuildContext context) => const Icon.lucide(
        Lucide.footprints,
        size: IconSize.xs,
        tone: IconTone.muted,
      ),
    ),
    'swimming': ChartSeries(
      label: 'Swimming',
      color: ink.slot(2),
      icon: (BuildContext context) => const Icon.lucide(
        Lucide.wavesHorizontal,
        size: IconSize.xs,
        tone: IconTone.muted,
      ),
    ),
  }),
  const ChartTooltipSpec(cursor: false, defaultIndex: 1, hideLabel: true),
);

/// The most involved of the nine: a swatch, the series label, the value with
/// its unit, and: after the last row: a totalled line.
// specimen: chart-tooltip-advanced
Widget tooltipAdvanced(ChartInk ink) => tooltipChart(
  ink,
  ink.sport,
  ChartTooltipSpec(
    cursor: false,
    defaultIndex: 1,
    hideLabel: true,
    // `className="w-44"`, 176px, the nearest rung of the same scale
    // `min-w-32` uses, close enough that the fixed-width Total row does not
    // reflow between the two hovered series.
    width: space(44),
    formatter: (BuildContext context, ChartTooltipItem item, int index) =>
        _AdvancedRow(item: item, index: index, ink: ink),
  ),
);

class _AdvancedRow extends StatelessWidget {
  const _AdvancedRow({
    required this.item,
    required this.index,
    required this.ink,
  });

  final ChartTooltipItem item;
  final int index;
  final ChartInk ink;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final Map<String, Object?> row = item.payload ?? const <String, Object?>{};
    final int total =
        ((row['running'] as num?) ?? 0).toInt() +
        ((row['swimming'] as num?) ?? 0).toInt();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: space(0.5)),
          child: Container(
            width: space(2.5),
            height: space(2.5),
            decoration: BoxDecoration(
              color: ink.slot(item.name == 'running' ? 1 : 2),
              borderRadius: BorderRadius.circular(Radii.xs),
            ),
          ),
        ),
        SizedBox(width: space(2)),
        Expanded(
          child: DefaultTextStyle(
            style: StyledText.styleOf(
              context,
              ChartText.xs,
              color: theme.mutedForeground,
            ),
            child: _KcalRow(item: item, showTotal: index == 1, total: total),
          ),
        ),
      ],
    );
  }
}

/// The tooltip specimens, and the list the gallery and the reference page
/// read.
const List<ChartSpecimen> tooltipSpecimens = <ChartSpecimen>[
  ChartSpecimen(
    id: 'chart-tooltip-default',
    note: 'ChartTooltipContent, dot indicator',
    skeleton: ChartSkeletonKind.tooltip,
    build: _tooltipDefaultBuild,
  ),
  ChartSpecimen(
    id: 'chart-tooltip-indicator-line',
    note: 'indicator=line',
    skeleton: ChartSkeletonKind.tooltip,
    build: _tooltipIndicatorLineBuild,
  ),
  ChartSpecimen(
    id: 'chart-tooltip-indicator-none',
    note: 'hideIndicator',
    skeleton: ChartSkeletonKind.tooltip,
    build: _tooltipIndicatorNoneBuild,
  ),
  ChartSpecimen(
    id: 'chart-tooltip-label-custom',
    note: 'labelKey plus a config label',
    skeleton: ChartSkeletonKind.tooltip,
    build: _tooltipLabelCustomBuild,
  ),
  ChartSpecimen(
    id: 'chart-tooltip-label-formatter',
    note: 'labelFormatter',
    skeleton: ChartSkeletonKind.tooltip,
    build: _tooltipLabelFormatterBuild,
  ),
  ChartSpecimen(
    id: 'chart-tooltip-label-none',
    note: 'hideLabel',
    skeleton: ChartSkeletonKind.tooltip,
    build: _tooltipLabelNoneBuild,
  ),
  ChartSpecimen(
    id: 'chart-tooltip-formatter',
    note: 'formatter render function',
    skeleton: ChartSkeletonKind.tooltip,
    build: _tooltipFormatterBuild,
  ),
  ChartSpecimen(
    id: 'chart-tooltip-icons',
    note: 'config icons in the rows',
    skeleton: ChartSkeletonKind.tooltip,
    build: _tooltipIconsBuild,
  ),
  ChartSpecimen(
    id: 'chart-tooltip-advanced',
    note: 'formatter with a running total',
    skeleton: ChartSkeletonKind.tooltip,
    build: _tooltipAdvancedBuild,
  ),
];

Widget _tooltipDefaultBuild(BuildContext context, ChartInk ink) =>
    tooltipDefault(ink);
Widget _tooltipIndicatorLineBuild(BuildContext context, ChartInk ink) =>
    tooltipIndicatorLine(ink);
Widget _tooltipIndicatorNoneBuild(BuildContext context, ChartInk ink) =>
    tooltipIndicatorNone(ink);
Widget _tooltipLabelCustomBuild(BuildContext context, ChartInk ink) =>
    tooltipLabelCustom(ink);
Widget _tooltipLabelFormatterBuild(BuildContext context, ChartInk ink) =>
    tooltipLabelFormatter(ink);
Widget _tooltipLabelNoneBuild(BuildContext context, ChartInk ink) =>
    tooltipLabelNone(ink);
Widget _tooltipFormatterBuild(BuildContext context, ChartInk ink) =>
    tooltipFormatter(ink);
Widget _tooltipIconsBuild(BuildContext context, ChartInk ink) =>
    tooltipIcons(ink);
Widget _tooltipAdvancedBuild(BuildContext context, ChartInk ink) =>
    tooltipAdvanced(ink);
