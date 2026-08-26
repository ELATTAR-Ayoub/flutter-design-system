/// Public documentation page for the `chart-cartesian` component.
///
/// **One widget, three chart families.** `ElCartesianChart` stands in for
/// `AreaChart`, `BarChart` and `LineChart` — recharts makes the three one
/// widget too, `CartesianChart` with a different `chartName` — because the
/// only thing that actually differs between them is which scale the
/// category axis resolves to: a chart with a `ElChartSeriesKind.bar` series
/// gets a **band** scale (`ElBandScale`, from `chart-geometry`), a chart
/// without gets a **point** scale (`ElPointScale`). Every specimen below
/// wraps `ElCartesianChart` in a `ElChartContainer` from `chart`, exactly as
/// a real call site does.
///
/// **Section order.** Preview, Installation, Usage, then one section per
/// facet: Area, Bar, Line (the three drawn shapes), Stacking
/// (`stackId`/`stackOffsetExpand`), Curves (the four `ElCurveType`
/// interpolators), Axes & Grid (`ElChartAxis`/`ElChartGrid`), Tooltip &
/// Legend (`ElChartTooltipSpec`/`ElChartLegendSpec` wired into a real
/// chart) — then the eight standing disclosures.
///
/// **Data.** Every specimen's data is modelled on the two fixtures
/// `example/lib/pages/charts.dart` already reuses across the hand-composed
/// charts page: six months of `desktop`/`mobile` visits, and five browsers'
/// worth of `visitors`. Neither array is imported from that file — it lives
/// under `example/lib/pages/`, which this rollout does not touch — but the
/// shape and the numbers are the same fixture, not an invented one.
///
/// **Read, not inferred.** Every claim traces to a line in
/// `lib/src/components/chart_cartesian.dart`. `grep -n "Semantics\|FocusNode"
/// lib/src/components/chart_cartesian.dart` returns zero matches for
/// `Semantics` and exactly one `MouseRegion` for `FocusNode` context (there is
/// none) — Accessibility and Keyboard both say so rather than inventing a
/// story the file does not tell.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/component_doc_page.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../docs/docs_section.dart' show DocsAnchor;
import '../chart/meta.dart' as chart;
import '../chart_geometry/meta.dart' as chart_geometry;
import 'meta.dart';

/* ── Shared data ─────────────────────────────────────────────────────────── */

/// Modelled on `pages/charts.dart`'s own `MONTHS_DESKTOP_MOBILE` fixture:
/// six months, two comparable series.
const List<Map<String, Object?>> _monthlyVisitors = <Map<String, Object?>>[
  <String, Object?>{'month': 'Jan', 'desktop': 186, 'mobile': 80},
  <String, Object?>{'month': 'Feb', 'desktop': 305, 'mobile': 200},
  <String, Object?>{'month': 'Mar', 'desktop': 237, 'mobile': 120},
  <String, Object?>{'month': 'Apr', 'desktop': 173, 'mobile': 190},
  <String, Object?>{'month': 'May', 'desktop': 209, 'mobile': 130},
  <String, Object?>{'month': 'Jun', 'desktop': 214, 'mobile': 140},
];

/// Modelled on `pages/charts.dart`'s own `BROWSERS` fixture: five
/// categories, one value each.
const List<Map<String, Object?>> _browserVisitors = <Map<String, Object?>>[
  <String, Object?>{'browser': 'Chrome', 'visitors': 275},
  <String, Object?>{'browser': 'Safari', 'visitors': 200},
  <String, Object?>{'browser': 'Firefox', 'visitors': 187},
  <String, Object?>{'browser': 'Edge', 'visitors': 173},
  <String, Object?>{'browser': 'Other', 'visitors': 90},
];

/// The declaration: every section this page shows, in TOC order. `final`,
/// not `const`: `InstallSection.command` reads `chartCartesianDoc.command`,
/// a computed getter, not a constant expression.
final ComponentDocSpec chartCartesianDocSpec = ComponentDocSpec(
  name: 'chart_cartesian',
  title: 'Chart Cartesian',
  description: chartCartesianDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'The three drawn shapes, stacked: an area, a bar, and a line '
          'chart, each the same `ElCartesianChart` widget with a different '
          '`ElChartSeriesKind` — the one thing recharts itself varies '
          'between `AreaChart`, `BarChart` and `LineChart`.',
      specimen: const _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
      minHeight: el(160),
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'chart-cartesian has a real registry manifest, `elattar add '
          'chart-cartesian` installs lib/src/components/chart_cartesian.dart '
          'and resolves its two registryDependencies, chart and '
          'chart-geometry, automatically. The Manual tab is for a project '
          'not using the CLI.',
      command: chartCartesianDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/chart_cartesian.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/chart_cartesian.dart's generated "
              '@ui/chart_cartesian.dart payload into components/ui.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated chart_cartesian source here when using '
              'manual mode.',
        ),
        DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so ElCartesianChart and the rest are '
              'reachable the same way the CLI path already makes them.',
          code: "export 'chart_cartesian.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'The smallest correct construction: an `ElChartConfig`, an '
          '`ElChartContainer` to mount in, and one `ElChartSeriesSpec` for '
          'the plot itself.',
      code: _usageCode,
    ),
    ShowcaseSection(
      id: 'area',
      title: 'Area',
      description:
          '`ElChartSeriesKind.area`: `fillOpacity` folded into the fill '
          'colour by the caller, since opacity is not one of the five token '
          'families. A `stackId` shared by two series stacks the second on '
          "top of the first — the reference's own `AreaStacked`.",
      specimen: const _AreaSpecimen(),
      code: _areaCode,
      label: 'Area specimen view',
      minHeight: el(160),
    ),
    ShowcaseSection(
      id: 'bar',
      title: 'Bar',
      description:
          '`ElChartSeriesKind.bar`, under a band scale: six categories, '
          'each an equal band, with a 10% category gap on each side. '
          '`layout: ElChartLayout.vertical` is what the reference calls "a '
          'horizontal bar chart" — the prop names the axis the CATEGORIES '
          'run along, not the direction the bars point.',
      specimen: const _BarSpecimen(),
      code: _barCode,
      label: 'Bar specimen view',
      minHeight: el(160),
    ),
    ShowcaseSection(
      id: 'line',
      title: 'Line',
      description:
          '`ElChartSeriesKind.line`, under a point scale: the first and '
          'last vertex land ON the plot edges rather than inside a band. '
          '`dot:` draws a marker at every vertex; without it a line is bare '
          'stroke.',
      specimen: const _LineSpecimen(),
      code: _lineCode,
      label: 'Line specimen view',
      minHeight: el(160),
    ),
    ShowcaseSection(
      id: 'stacking',
      title: 'Stacking',
      description:
          'Two series sharing one `stackId` stack: the second draws from '
          "where the first ends. `stackOffsetExpand: true` on the chart "
          'itself turns that same stack into a share of the total — the '
          'value axis runs 0…1 whatever the data sums to, rather than 0…the '
          'stack total.',
      specimen: const _StackingSpecimen(),
      code: _stackingCode,
      label: 'Stacking specimen view',
      minHeight: el(160),
    ),
    ShowcaseSection(
      id: 'curves',
      title: 'Curves',
      description:
          'The four `ElCurveType` interpolators a `Line` or `Area` series '
          'can draw through the same six points: linear (straight '
          'segments), step (a flat run then a jump), natural (a cubic '
          'spline), and monotone (Steffen tangents — the one guaranteed not '
          'to overshoot a local peak, and the only one any specimen on the '
          'page reaches for on a horizontal chart).',
      specimen: const _CurvesSpecimen(),
      code: _curvesCode,
      label: 'Curves specimen view',
      minHeight: el(160),
    ),
    ShowcaseSection(
      id: 'axes-grid',
      title: 'Axes & Grid',
      description:
          'An axis costs its own size out of the plot — 30px for an X '
          'axis, 60px for a Y axis — and `ElChartGrid` draws horizontal '
          'and/or vertical rules at `--border` and half strength. This '
          'specimen shows both axes and a full grid; `hide: true` on either '
          'axis keeps its scale but drops the labels, which is what a chart '
          'reaches for when a tooltip already carries the number.',
      specimen: const _AxesGridSpecimen(),
      code: _axesGridCode,
      label: 'Axes and grid specimen view',
      minHeight: el(160),
    ),
    ShowcaseSection(
      id: 'tooltip-legend',
      title: 'Tooltip & Legend',
      description:
          '`ElChartTooltipSpec.defaultIndex` pins the panel open without a '
          'pointer, exactly as the reference\'s own `defaultIndex` prop '
          'does — useful here so the specimen is not a screenshot of empty '
          'space. `ElChartLegendSpec` costs the plot 28px of height (`pt-3` '
          'plus one 16px line box), taken out of the bottom by default.',
      specimen: const _TooltipLegendSpecimen(),
      code: _tooltipLegendCode,
      label: 'Tooltip and legend specimen view',
      minHeight: el(160),
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every constructor parameter each exported class declares, and '
          'every value of every exported enum: one table per class or enum.',
      children: const <DocsTocEntry>[
        DocsTocEntry(title: 'ElCartesianChart', anchor: 'api-elcartesianchart'),
        DocsTocEntry(title: 'ElChartSeriesSpec', anchor: 'api-elchartseriesspec'),
        DocsTocEntry(title: 'ElChartAxis', anchor: 'api-elchartaxis'),
        DocsTocEntry(title: 'ElChartGrid', anchor: 'api-elchartgrid'),
        DocsTocEntry(title: 'ElChartMargin', anchor: 'api-elchartmargin'),
        DocsTocEntry(title: 'ElChartDot', anchor: 'api-elchartdot'),
        DocsTocEntry(title: 'ElChartLabelList', anchor: 'api-elchartlabellist'),
        DocsTocEntry(
          title: 'ElChartTooltipSpec',
          anchor: 'api-elcharttooltipspec',
        ),
        DocsTocEntry(title: 'ElChartLegendSpec', anchor: 'api-elchartlegendspec'),
        DocsTocEntry(title: 'ElBarRect', anchor: 'api-elbarrect'),
        DocsTocEntry(
          title: 'ElBarSeriesPainter',
          anchor: 'api-elbarseriespainter',
        ),
        DocsTocEntry(title: 'ElChartLayout', anchor: 'api-elchartlayout'),
        DocsTocEntry(title: 'ElChartAxisType', anchor: 'api-elchartaxistype'),
        DocsTocEntry(
          title: 'ElChartSeriesKind',
          anchor: 'api-elchartserieskind',
        ),
        DocsTocEntry(
          title: 'ElChartLabelPosition',
          anchor: 'api-elchartlabelposition',
        ),
      ],
      child: const _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'ElCartesianChart owns exactly one interactive state: which datum '
          'the pointer is over. Everything else below is configuration the '
          'caller passes in at construction, never a state the widget '
          'reaches on its own.',
      child: DocsStateMatrix(facts: _stateFacts),
    ),
    DisclosureSection(
      id: 'accessibility',
      title: 'Accessibility',
      description:
          'Read straight off the source: chart_cartesian.dart wires no '
          '`Semantics` node anywhere in the file.',
      child: const _AccessibilityContent(),
    ),
    DisclosureSection(
      id: 'keyboard',
      title: 'Keyboard',
      description:
          'No `FocusNode`, no `Focus` widget, and no key handler anywhere '
          'in chart_cartesian.dart: `ElCartesianChart` takes no keyboard '
          'focus and answers no key.',
      child: const _KeyboardContent(),
    ),
    DisclosureSection(
      id: 'responsive',
      title: 'Responsive',
      child: const _ResponsiveContent(),
    ),
    DisclosureSection(
      id: 'dependencies',
      title: 'Dependencies',
      child: const _DependenciesContent(),
    ),
    DisclosureSection(
      id: 'theming',
      title: 'Theming',
      child: const _ThemingContent(),
    ),
    DisclosureSection(
      id: 'source',
      title: 'Source',
      child: DocsInstallFacts(
        title: 'Reference',
        facts: <DocsInstallFact>[
          DocsInstallFact(
            label: 'Source',
            value: chartCartesianDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/chart_cartesian_test.dart',
            description:
                'Covers this page: the article mounts, every exported '
                'class and enum this page claims to document, the full API '
                'table, and both themes at two viewport widths.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/chart_cartesian/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class ChartCartesianDocPage extends StatelessWidget {
  const ChartCartesianDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: chartCartesianDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / BASE',
      title: chartCartesianDoc.title,
      description: chartCartesianDoc.description,
    ),
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Components'),
      ElBreadcrumbEntry.page('Chart Cartesian'),
    ],
    toc: chartCartesianDocSpec.toc,
    previous: DocsPageLink(title: chart.chartDoc.title, route: chart.chartDoc.route),
    next: DocsPageLink(
      title: chart_geometry.chartGeometryDoc.title,
      route: chart_geometry.chartGeometryDoc.route,
    ),
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('chart-cartesian-doc-article'),
      child: ComponentDocPage(spec: chartCartesianDocSpec, header: false),
    ),
  );
}

/* ── Showcase specimens ─────────────────────────────────────────────────── */

class _PreviewSpecimen extends StatelessWidget {
  const _PreviewSpecimen();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        KeyedSubtree(
          key: const ValueKey<String>('chart-cartesian-preview:area'),
          child: ElChartContainer(
            height: el(48),
            config: ElChartConfig(<String, ElChartSeries>{
              'desktop': ElChartSeries(label: 'Desktop', color: theme.chart1),
            }),
            child: ElCartesianChart(
              data: _monthlyVisitors,
              xAxis: const ElChartAxis(
                dataKey: 'month',
                tickLine: false,
                axisLine: false,
              ),
              series: <ElChartSeriesSpec>[
                ElChartSeriesSpec(
                  kind: ElChartSeriesKind.area,
                  dataKey: 'desktop',
                  curve: ElCurveType.natural,
                  fill: theme.chart1,
                  fillOpacity: 0.35,
                  stroke: theme.chart1,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: el(4)),
        KeyedSubtree(
          key: const ValueKey<String>('chart-cartesian-preview:bar'),
          child: ElChartContainer(
            height: el(48),
            config: ElChartConfig(<String, ElChartSeries>{
              'visitors': ElChartSeries(label: 'Visitors', color: theme.chart2),
            }),
            child: ElCartesianChart(
              data: _browserVisitors,
              grid: const ElChartGrid(vertical: false),
              xAxis: const ElChartAxis(
                dataKey: 'browser',
                tickLine: false,
                axisLine: false,
              ),
              series: <ElChartSeriesSpec>[
                ElChartSeriesSpec(
                  kind: ElChartSeriesKind.bar,
                  dataKey: 'visitors',
                  fill: theme.chart2,
                  radii: const <double>[
                    ElRadii.sm,
                    ElRadii.sm,
                    ElRadii.sm,
                    ElRadii.sm,
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: el(4)),
        KeyedSubtree(
          key: const ValueKey<String>('chart-cartesian-preview:line'),
          child: ElChartContainer(
            height: el(48),
            config: ElChartConfig(<String, ElChartSeries>{
              'desktop': ElChartSeries(label: 'Desktop', color: theme.chart3),
            }),
            child: ElCartesianChart(
              data: _monthlyVisitors,
              xAxis: const ElChartAxis(
                dataKey: 'month',
                tickLine: false,
                axisLine: false,
              ),
              series: <ElChartSeriesSpec>[
                ElChartSeriesSpec(
                  kind: ElChartSeriesKind.line,
                  dataKey: 'desktop',
                  curve: ElCurveType.monotone,
                  stroke: theme.chart3,
                  strokeWidth: 2,
                  dot: ElChartDot(fill: theme.chart3, stroke: theme.chart3),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

const String _previewCode =
    "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
    'ElChartContainer(\n'
    "  config: ElChartConfig({'desktop': ElChartSeries(color: theme.chart1)}),\n"
    '  child: ElCartesianChart(\n'
    '    data: months,\n'
    "    xAxis: const ElChartAxis(dataKey: 'month'),\n"
    '    series: [\n'
    '      ElChartSeriesSpec(\n'
    '        kind: ElChartSeriesKind.area, // .bar / .line\n'
    "        dataKey: 'desktop',\n"
    '        fill: theme.chart1,\n'
    '      ),\n'
    '    ],\n'
    '  ),\n'
    ')';

const String _usageCode =
    "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
    'ElChartContainer(\n'
    "  config: ElChartConfig({'value': ElChartSeries(color: theme.chart1)}),\n"
    '  child: ElCartesianChart(\n'
    "    data: [ {'x': 'Jan', 'value': 186}, {'x': 'Feb', 'value': 305} ],\n"
    '    series: [\n'
    '      ElChartSeriesSpec(\n'
    '        kind: ElChartSeriesKind.line,\n'
    "        dataKey: 'value',\n"
    '        stroke: theme.chart1,\n'
    '      ),\n'
    '    ],\n'
    '  ),\n'
    ')';

class _AreaSpecimen extends StatelessWidget {
  const _AreaSpecimen();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        KeyedSubtree(
          key: const ValueKey<String>('chart-cartesian-example:area-default'),
          child: ElChartContainer(
            config: ElChartConfig(<String, ElChartSeries>{
              'desktop': ElChartSeries(label: 'Desktop', color: theme.chart1),
            }),
            child: ElCartesianChart(
              data: _monthlyVisitors,
              margin: const ElChartMargin(left: 12, right: 12),
              xAxis: const ElChartAxis(
                dataKey: 'month',
                tickLine: false,
                axisLine: false,
              ),
              series: <ElChartSeriesSpec>[
                ElChartSeriesSpec(
                  kind: ElChartSeriesKind.area,
                  dataKey: 'desktop',
                  curve: ElCurveType.natural,
                  fill: theme.chart1,
                  fillOpacity: 0.4,
                  stroke: theme.chart1,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: el(4)),
        KeyedSubtree(
          key: const ValueKey<String>('chart-cartesian-example:area-stacked'),
          child: ElChartContainer(
            config: ElChartConfig(<String, ElChartSeries>{
              'desktop': ElChartSeries(label: 'Desktop', color: theme.chart1),
              'mobile': ElChartSeries(label: 'Mobile', color: theme.chart2),
            }),
            child: ElCartesianChart(
              data: _monthlyVisitors,
              margin: const ElChartMargin(left: 12, right: 12),
              xAxis: const ElChartAxis(
                dataKey: 'month',
                tickLine: false,
                axisLine: false,
              ),
              series: <ElChartSeriesSpec>[
                ElChartSeriesSpec(
                  kind: ElChartSeriesKind.area,
                  dataKey: 'mobile',
                  curve: ElCurveType.natural,
                  stackId: 'a',
                  fill: theme.chart2,
                  fillOpacity: 0.4,
                  stroke: theme.chart2,
                ),
                ElChartSeriesSpec(
                  kind: ElChartSeriesKind.area,
                  dataKey: 'desktop',
                  curve: ElCurveType.natural,
                  stackId: 'a',
                  fill: theme.chart1,
                  fillOpacity: 0.4,
                  stroke: theme.chart1,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

const String _areaCode =
    'ElChartSeriesSpec(\n'
    '  kind: ElChartSeriesKind.area,\n'
    "  dataKey: 'desktop',\n"
    '  curve: ElCurveType.natural,\n'
    '  fill: theme.chart1,\n'
    '  fillOpacity: 0.4,\n'
    '  stroke: theme.chart1,\n'
    ')\n\n'
    '// A second series with the same stackId stacks on top:\n'
    "ElChartSeriesSpec(kind: ElChartSeriesKind.area, dataKey: 'mobile', stackId: 'a', ...)\n"
    "ElChartSeriesSpec(kind: ElChartSeriesKind.area, dataKey: 'desktop', stackId: 'a', ...)";

class _BarSpecimen extends StatelessWidget {
  const _BarSpecimen();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        KeyedSubtree(
          key: const ValueKey<String>('chart-cartesian-example:bar-vertical'),
          child: ElChartContainer(
            config: ElChartConfig(<String, ElChartSeries>{
              'visitors': ElChartSeries(label: 'Visitors', color: theme.chart1),
            }),
            child: ElCartesianChart(
              data: _browserVisitors,
              grid: const ElChartGrid(vertical: false),
              xAxis: const ElChartAxis(
                dataKey: 'browser',
                tickLine: false,
                axisLine: false,
              ),
              series: <ElChartSeriesSpec>[
                ElChartSeriesSpec(
                  kind: ElChartSeriesKind.bar,
                  dataKey: 'visitors',
                  fill: theme.chart1,
                  radii: const <double>[
                    ElRadii.sm,
                    ElRadii.sm,
                    ElRadii.sm,
                    ElRadii.sm,
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: el(4)),
        KeyedSubtree(
          key: const ValueKey<String>(
            'chart-cartesian-example:bar-horizontal',
          ),
          child: ElChartContainer(
            config: ElChartConfig(<String, ElChartSeries>{
              'visitors': ElChartSeries(label: 'Visitors', color: theme.chart2),
            }),
            child: ElCartesianChart(
              data: _browserVisitors,
              layout: ElChartLayout.vertical,
              grid: const ElChartGrid(horizontal: false),
              xAxis: const ElChartAxis(type: ElChartAxisType.number, hide: true),
              yAxis: const ElChartAxis(
                dataKey: 'browser',
                tickLine: false,
                axisLine: false,
              ),
              series: <ElChartSeriesSpec>[
                ElChartSeriesSpec(
                  kind: ElChartSeriesKind.bar,
                  dataKey: 'visitors',
                  fill: theme.chart2,
                  radii: const <double>[
                    0,
                    ElRadii.sm,
                    ElRadii.sm,
                    0,
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

const String _barCode =
    'ElCartesianChart(\n'
    '  data: browsers,\n'
    "  xAxis: const ElChartAxis(dataKey: 'browser'),\n"
    '  series: [\n'
    '    ElChartSeriesSpec(\n'
    '      kind: ElChartSeriesKind.bar,\n'
    "      dataKey: 'visitors',\n"
    '      fill: theme.chart1,\n'
    '      radii: [radiusSm, radiusSm, radiusSm, radiusSm],\n'
    '    ),\n'
    '  ],\n'
    ')\n\n'
    '// A "horizontal" bar chart is layout: vertical — categories run along Y:\n'
    'ElCartesianChart(layout: ElChartLayout.vertical, yAxis: ..., ...)';

class _LineSpecimen extends StatelessWidget {
  const _LineSpecimen();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return KeyedSubtree(
      key: const ValueKey<String>('chart-cartesian-example:line-dots'),
      child: ElChartContainer(
        config: ElChartConfig(<String, ElChartSeries>{
          'desktop': ElChartSeries(label: 'Desktop', color: theme.chart1),
          'mobile': ElChartSeries(label: 'Mobile', color: theme.chart2),
        }),
        child: ElCartesianChart(
          data: _monthlyVisitors,
          margin: const ElChartMargin(left: 12, right: 12),
          xAxis: const ElChartAxis(
            dataKey: 'month',
            tickLine: false,
            axisLine: false,
          ),
          series: <ElChartSeriesSpec>[
            ElChartSeriesSpec(
              kind: ElChartSeriesKind.line,
              dataKey: 'desktop',
              curve: ElCurveType.monotone,
              stroke: theme.chart1,
              strokeWidth: 2,
              dot: ElChartDot(fill: theme.chart1, stroke: theme.chart1),
            ),
            ElChartSeriesSpec(
              kind: ElChartSeriesKind.line,
              dataKey: 'mobile',
              curve: ElCurveType.monotone,
              stroke: theme.chart2,
              strokeWidth: 2,
              dot: ElChartDot(fill: theme.chart2, stroke: theme.chart2),
            ),
          ],
        ),
      ),
    );
  }
}

const String _lineCode =
    'ElChartSeriesSpec(\n'
    '  kind: ElChartSeriesKind.line,\n'
    "  dataKey: 'desktop',\n"
    '  curve: ElCurveType.monotone,\n'
    '  stroke: theme.chart1,\n'
    '  strokeWidth: 2,\n'
    '  dot: ElChartDot(fill: theme.chart1, stroke: theme.chart1),\n'
    ')';

class _StackingSpecimen extends StatelessWidget {
  const _StackingSpecimen();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    List<ElChartSeriesSpec> series({required bool expand}) => <ElChartSeriesSpec>[
      ElChartSeriesSpec(
        kind: ElChartSeriesKind.bar,
        dataKey: 'mobile',
        stackId: 'a',
        fill: theme.chart2,
        radii: expand ? null : const <double>[0, 0, 0, 0],
      ),
      ElChartSeriesSpec(
        kind: ElChartSeriesKind.bar,
        dataKey: 'desktop',
        stackId: 'a',
        fill: theme.chart1,
        radii: const <double>[ElRadii.sm, ElRadii.sm, 0, 0],
      ),
    ];
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        KeyedSubtree(
          key: const ValueKey<String>('chart-cartesian-example:stacked-totals'),
          child: ElChartContainer(
            config: ElChartConfig(<String, ElChartSeries>{
              'desktop': ElChartSeries(label: 'Desktop', color: theme.chart1),
              'mobile': ElChartSeries(label: 'Mobile', color: theme.chart2),
            }),
            child: ElCartesianChart(
              data: _monthlyVisitors,
              grid: const ElChartGrid(vertical: false),
              xAxis: const ElChartAxis(
                dataKey: 'month',
                tickLine: false,
                axisLine: false,
              ),
              series: series(expand: false),
            ),
          ),
        ),
        SizedBox(height: el(4)),
        KeyedSubtree(
          key: const ValueKey<String>('chart-cartesian-example:stacked-percent'),
          child: ElChartContainer(
            config: ElChartConfig(<String, ElChartSeries>{
              'desktop': ElChartSeries(label: 'Desktop', color: theme.chart1),
              'mobile': ElChartSeries(label: 'Mobile', color: theme.chart2),
            }),
            child: ElCartesianChart(
              data: _monthlyVisitors,
              stackOffsetExpand: true,
              grid: const ElChartGrid(vertical: false),
              xAxis: const ElChartAxis(
                dataKey: 'month',
                tickLine: false,
                axisLine: false,
              ),
              yAxis: const ElChartAxis(
                type: ElChartAxisType.number,
                tickFormatter: _percentTick,
              ),
              series: series(expand: true),
            ),
          ),
        ),
      ],
    );
  }
}

String _percentTick(Object? value) =>
    '${((value as num? ?? 0) * 100).round()}%';

const String _stackingCode =
    "// Two series sharing one stackId stack:\n"
    "ElChartSeriesSpec(kind: ElChartSeriesKind.bar, dataKey: 'mobile', stackId: 'a', ...)\n"
    "ElChartSeriesSpec(kind: ElChartSeriesKind.bar, dataKey: 'desktop', stackId: 'a', ...)\n\n"
    '// stackOffsetExpand turns the same stack into a 0…1 share:\n'
    'ElCartesianChart(stackOffsetExpand: true, series: [...])';

class _CurvesSpecimen extends StatelessWidget {
  const _CurvesSpecimen();

  static const List<ElCurveType> _types = <ElCurveType>[
    ElCurveType.linear,
    ElCurveType.step,
    ElCurveType.natural,
    ElCurveType.monotone,
  ];

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        for (final ElCurveType type in _types) ...<Widget>[
          KeyedSubtree(
            key: ValueKey<String>('chart-cartesian-example:curve-${type.name}'),
            child: ElChartContainer(
              height: el(20),
              config: ElChartConfig(<String, ElChartSeries>{
                'desktop': ElChartSeries(label: type.name, color: theme.chart1),
              }),
              child: ElCartesianChart(
                data: _monthlyVisitors,
                xAxis: const ElChartAxis(hide: true),
                yAxis: const ElChartAxis(type: ElChartAxisType.number, hide: true),
                series: <ElChartSeriesSpec>[
                  ElChartSeriesSpec(
                    kind: ElChartSeriesKind.line,
                    dataKey: 'desktop',
                    curve: type,
                    stroke: theme.chart1,
                    strokeWidth: 2,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: el(2)),
        ],
      ],
    );
  }
}

const String _curvesCode =
    "elCurvePath(points, ElCurveType.linear);   // straight segments\n"
    "elCurvePath(points, ElCurveType.step);     // flat run, then a jump\n"
    "elCurvePath(points, ElCurveType.natural);  // cubic spline\n"
    "elCurvePath(points, ElCurveType.monotone); // Steffen tangents, no overshoot\n\n"
    "ElChartSeriesSpec(kind: ElChartSeriesKind.line, dataKey: 'desktop', curve: ElCurveType.monotone)";

class _AxesGridSpecimen extends StatelessWidget {
  const _AxesGridSpecimen();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return KeyedSubtree(
      key: const ValueKey<String>('chart-cartesian-example:axes-grid'),
      child: ElChartContainer(
        config: ElChartConfig(<String, ElChartSeries>{
          'desktop': ElChartSeries(label: 'Desktop', color: theme.chart1),
        }),
        child: ElCartesianChart(
          data: _monthlyVisitors,
          margin: const ElChartMargin(left: -20, right: 12),
          grid: const ElChartGrid(),
          xAxis: const ElChartAxis(
            dataKey: 'month',
            tickMargin: 8,
            tickLine: false,
          ),
          yAxis: const ElChartAxis(type: ElChartAxisType.number, tickCount: 3),
          series: <ElChartSeriesSpec>[
            ElChartSeriesSpec(
              kind: ElChartSeriesKind.area,
              dataKey: 'desktop',
              curve: ElCurveType.natural,
              fill: theme.chart1,
              fillOpacity: 0.4,
              stroke: theme.chart1,
            ),
          ],
        ),
      ),
    );
  }
}

const String _axesGridCode =
    'ElCartesianChart(\n'
    '  margin: const ElChartMargin(left: -20, right: 12), // claws back an axis\n'
    '  grid: const ElChartGrid(), // horizontal: true, vertical: true\n'
    "  xAxis: const ElChartAxis(dataKey: 'month', tickMargin: 8, tickLine: false),\n"
    '  yAxis: const ElChartAxis(type: ElChartAxisType.number, tickCount: 3),\n'
    '  series: [...],\n'
    ')';

class _TooltipLegendSpecimen extends StatelessWidget {
  const _TooltipLegendSpecimen();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return KeyedSubtree(
      key: const ValueKey<String>('chart-cartesian-example:tooltip-legend'),
      child: ElChartContainer(
        config: ElChartConfig(<String, ElChartSeries>{
          'desktop': ElChartSeries(label: 'Desktop', color: theme.chart1),
          'mobile': ElChartSeries(label: 'Mobile', color: theme.chart2),
        }),
        child: ElCartesianChart(
          data: _monthlyVisitors,
          margin: const ElChartMargin(left: 12, right: 12),
          xAxis: const ElChartAxis(
            dataKey: 'month',
            tickLine: false,
            axisLine: false,
          ),
          tooltip: const ElChartTooltipSpec(defaultIndex: 1),
          legend: const ElChartLegendSpec(),
          series: <ElChartSeriesSpec>[
            ElChartSeriesSpec(
              kind: ElChartSeriesKind.area,
              dataKey: 'mobile',
              curve: ElCurveType.natural,
              stackId: 'a',
              fill: theme.chart2,
              fillOpacity: 0.4,
              stroke: theme.chart2,
            ),
            ElChartSeriesSpec(
              kind: ElChartSeriesKind.area,
              dataKey: 'desktop',
              curve: ElCurveType.natural,
              stackId: 'a',
              fill: theme.chart1,
              fillOpacity: 0.4,
              stroke: theme.chart1,
            ),
          ],
        ),
      ),
    );
  }
}

const String _tooltipLegendCode =
    'ElCartesianChart(\n'
    '  tooltip: const ElChartTooltipSpec(defaultIndex: 1), // pinned open\n'
    '  legend: const ElChartLegendSpec(), // bottom, by default\n'
    '  series: [...],\n'
    ')';

/* ── Disclosure content ─────────────────────────────────────────────────── */

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsAnchor(
        id: 'api-elcartesianchart',
        child: DocsApiTable(title: 'ElCartesianChart', facts: _chartFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elchartseriesspec',
        child: DocsApiTable(title: 'ElChartSeriesSpec', facts: _seriesSpecFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elchartaxis',
        child: DocsApiTable(title: 'ElChartAxis', facts: _axisFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elchartgrid',
        child: DocsApiTable(title: 'ElChartGrid', facts: _gridFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elchartmargin',
        child: DocsApiTable(title: 'ElChartMargin', facts: _marginFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elchartdot',
        child: DocsApiTable(title: 'ElChartDot', facts: _dotFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elchartlabellist',
        child: DocsApiTable(title: 'ElChartLabelList', facts: _labelListFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elcharttooltipspec',
        child: DocsApiTable(
          title: 'ElChartTooltipSpec',
          facts: _tooltipSpecFacts,
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elchartlegendspec',
        child: DocsApiTable(title: 'ElChartLegendSpec', facts: _legendSpecFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elbarrect',
        child: DocsApiTable(title: 'ElBarRect', facts: _barRectFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elbarseriespainter',
        child: DocsApiTable(
          title: 'ElBarSeriesPainter',
          facts: _barPainterFacts,
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elchartlayout',
        child: DocsApiTable(title: 'ElChartLayout', facts: _chartLayoutFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elchartaxistype',
        child: DocsApiTable(
          title: 'ElChartAxisType',
          facts: _chartAxisTypeFacts,
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elchartserieskind',
        child: DocsApiTable(
          title: 'ElChartSeriesKind',
          facts: _chartSeriesKindFacts,
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elchartlabelposition',
        child: DocsApiTable(
          title: 'ElChartLabelPosition',
          facts: _chartLabelPositionFacts,
        ),
      ),
    ],
  );
}

const List<DocsApiFact> _chartFacts = <DocsApiFact>[
  DocsApiFact(name: 'data', type: 'List<Map<String, Object?>>', description: 'Required. The rows, one Map per datum.'),
  DocsApiFact(name: 'series', type: 'List<ElChartSeriesSpec>', description: 'Required. One entry per drawn shape.'),
  DocsApiFact(name: 'margin', type: 'ElChartMargin', description: 'Default ElChartMargin.standard (5 on every side).'),
  DocsApiFact(name: 'layout', type: 'ElChartLayout', description: 'horizontal (default) or vertical — which axis the categories run along.'),
  DocsApiFact(name: 'grid', type: 'ElChartGrid?', description: 'Null draws no grid at all.'),
  DocsApiFact(name: 'xAxis', type: 'ElChartAxis?', description: 'Null draws no X axis and reserves no space for one.'),
  DocsApiFact(name: 'yAxis', type: 'ElChartAxis?', description: 'Null draws no Y axis and reserves no space for one.'),
  DocsApiFact(name: 'legend', type: 'ElChartLegendSpec?', description: 'Null renders no legend.'),
  DocsApiFact(name: 'tooltip', type: 'ElChartTooltipSpec?', description: 'Null answers no hover with a panel at all.'),
  DocsApiFact(
    name: 'stackOffsetExpand',
    type: 'bool',
    description: 'stackOffset="expand" — shares rather than totals, so the value axis runs 0…1. Default false.',
  ),
];

const List<DocsApiFact> _seriesSpecFacts = <DocsApiFact>[
  DocsApiFact(name: 'kind', type: 'ElChartSeriesKind', description: 'Required. area, bar, or line.'),
  DocsApiFact(name: 'dataKey', type: 'String', description: 'Required. The field this series reads off each datum.'),
  DocsApiFact(name: 'stroke', type: 'Color?', description: 'The line/border colour.'),
  DocsApiFact(name: 'fill', type: 'Color?', description: 'The fill colour.'),
  DocsApiFact(
    name: 'fillOpacity',
    type: 'double',
    description: 'Folded into fill by the caller since opacity is not a token family. Default 1.',
  ),
  DocsApiFact(name: 'strokeWidth', type: 'double', description: 'Default 1.'),
  DocsApiFact(name: 'curve', type: 'ElCurveType', description: 'linear (default), natural, monotone, or step.'),
  DocsApiFact(
    name: 'stackId',
    type: 'String?',
    description: 'Any shared string stacks the series that carry it. The first declared draws at the bottom.',
  ),
  DocsApiFact(
    name: 'radii',
    type: 'List<double>?',
    description: 'radius={[tl, tr, br, bl]} on a Bar, in that order.',
  ),
  DocsApiFact(
    name: 'cellFills',
    type: 'List<Color>?',
    description: 'One fill per datum, overriding fill for that bar or dot.',
  ),
  DocsApiFact(name: 'dot', type: 'ElChartDot?', description: 'Draws a marker at every vertex of a line. Null draws none.'),
  DocsApiFact(name: 'labels', type: 'List<ElChartLabelList>', description: 'Values printed beside their own datum. Default empty.'),
  DocsApiFact(name: 'gradient', type: 'Gradient?', description: 'fill="url(#…)" — paints over fill when present.'),
];

const List<DocsApiFact> _axisFacts = <DocsApiFact>[
  DocsApiFact(name: 'dataKey', type: 'String?', description: 'The field each tick reads. Without it a category axis is numbered.'),
  DocsApiFact(name: 'type', type: 'ElChartAxisType', description: 'category (default) or number.'),
  DocsApiFact(name: 'tickLine', type: 'bool', description: 'The 6px stub between the axis and its label. Default true.'),
  DocsApiFact(name: 'axisLine', type: 'bool', description: 'Default true.'),
  DocsApiFact(name: 'tickMargin', type: 'double', description: 'Default 0.'),
  DocsApiFact(name: 'minTickGap', type: 'double', description: 'The clearance preserveEnd insists on between two labels. Default 5.'),
  DocsApiFact(name: 'tickCount', type: 'int', description: 'Only read on a number axis. Default 5.'),
  DocsApiFact(name: 'hide', type: 'bool', description: 'Keeps the scale, drops the labels. Default false.'),
  DocsApiFact(name: 'tickFormatter', type: 'String Function(Object?)?', description: 'Overrides the printed tick text.'),
  DocsApiFact(name: 'size', type: 'double?', description: 'Overrides the axis\'s own default 30 (X) / 60 (Y).'),
  DocsApiFact(name: 'defaultXSize', type: 'double (static)', description: '30 — XAxis\'s own default height.'),
  DocsApiFact(name: 'defaultYSize', type: 'double (static)', description: '60 — YAxis\'s own default width.'),
  DocsApiFact(name: 'tickSize', type: 'double (static)', description: '6 — the tick stub, drawn whether or not tickLine is on.'),
];

const List<DocsApiFact> _gridFacts = <DocsApiFact>[
  DocsApiFact(name: 'horizontal', type: 'bool', description: 'Default true.'),
  DocsApiFact(name: 'vertical', type: 'bool', description: 'Default true.'),
  DocsApiFact(name: 'strokeAlpha', type: 'double (static)', description: '0.5 — border/50, the sweep replacing recharts\' own untokenised grey.'),
];

const List<DocsApiFact> _marginFacts = <DocsApiFact>[
  DocsApiFact(name: 'top', type: 'double', description: 'Default 0.'),
  DocsApiFact(name: 'right', type: 'double', description: 'Default 0.'),
  DocsApiFact(name: 'bottom', type: 'double', description: 'Default 0.'),
  DocsApiFact(name: 'left', type: 'double', description: 'Default 0.'),
  DocsApiFact(
    name: 'standard',
    type: 'ElChartMargin (static)',
    description: '5 on every side — what a chart gets when it passes no margin at all.',
  ),
];

const List<DocsApiFact> _dotFacts = <DocsApiFact>[
  DocsApiFact(name: 'radius', type: 'double', description: 'Default 3.'),
  DocsApiFact(name: 'fill', type: 'Color?', description: 'Falls back to the series\' own stroke, then to theme.foreground.'),
  DocsApiFact(name: 'stroke', type: 'Color?', description: 'None.'),
  DocsApiFact(name: 'strokeWidth', type: 'double', description: 'Default 1.'),
];

const List<DocsApiFact> _labelListFacts = <DocsApiFact>[
  DocsApiFact(name: 'dataKey', type: 'String?', description: 'Which field to print. Null prints the series\' own value.'),
  DocsApiFact(name: 'position', type: 'ElChartLabelPosition', description: 'top (default), right, insideLeft, or insideEnd.'),
  DocsApiFact(name: 'offset', type: 'double', description: 'Default 5.'),
  DocsApiFact(name: 'color', type: 'Color?', description: 'fill-foreground / fill-background at real call sites.'),
  DocsApiFact(name: 'formatter', type: 'String Function(Object?)?', description: 'Overrides the printed text.'),
];

const List<DocsApiFact> _tooltipSpecFacts = <DocsApiFact>[
  DocsApiFact(name: 'indicator', type: 'ElChartIndicator', description: 'dot (default), line, or dashed.'),
  DocsApiFact(name: 'hideLabel', type: 'bool', description: 'Default false.'),
  DocsApiFact(name: 'hideIndicator', type: 'bool', description: 'Default false.'),
  DocsApiFact(name: 'defaultIndex', type: 'int?', description: 'Which datum to show at rest, without a pointer over the chart.'),
  DocsApiFact(name: 'cursor', type: 'bool', description: 'The highlight band behind the hovered category. Default true.'),
  DocsApiFact(name: 'nameKey', type: 'String?', description: 'None.'),
  DocsApiFact(name: 'labelKey', type: 'String?', description: 'None.'),
  DocsApiFact(name: 'labelFormatter', type: 'String Function(String, List<ElChartTooltipItem>)?', description: 'None.'),
  DocsApiFact(name: 'formatter', type: 'Widget Function(BuildContext, ElChartTooltipItem, int)?', description: 'None.'),
  DocsApiFact(name: 'width', type: 'double?', description: 'None.'),
];

const List<DocsApiFact> _legendSpecFacts = <DocsApiFact>[
  DocsApiFact(name: 'align', type: 'ElChartLegendAlign', description: 'top or bottom. Default bottom.'),
  DocsApiFact(name: 'nameKey', type: 'String?', description: 'None.'),
  DocsApiFact(name: 'wrap', type: 'bool', description: 'Default false.'),
  DocsApiFact(name: 'gap', type: 'double?', description: 'Overrides gap-4, the default spacing between keys.'),
  DocsApiFact(name: 'offset', type: 'double', description: 'className="mt-8" / "-translate-y-2" — the nudges a real specimen applies. Default 0.'),
  DocsApiFact(
    name: 'reservedHeight',
    type: 'double (static getter)',
    description: '28 — pt-3 (12) plus one text-xs line box (16), the plot height a bottom legend costs.',
  ),
];

const List<DocsApiFact> _barRectFacts = <DocsApiFact>[
  DocsApiFact(name: 'rect', type: 'Rect', description: 'Required.'),
  DocsApiFact(name: 'radii', type: 'List<double>', description: 'Required. [tl, tr, br, bl].'),
  DocsApiFact(name: 'color', type: 'Color', description: 'Required.'),
  DocsApiFact(name: 'baseline', type: 'double?', description: 'The y (or x) the bar grows from, so the entrance can scale it in place.'),
];

const List<DocsApiFact> _barPainterFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'bars',
    type: 'List<ElBarRect>',
    description: 'Required. Exposed so a package test can pin a bar\'s rendered pixels without standing a whole chart up.',
  ),
];

const List<DocsApiFact> _chartLayoutFacts = <DocsApiFact>[
  DocsApiFact(name: 'horizontal', type: 'ElChartLayout', description: 'Categories run along X. Default.'),
  DocsApiFact(name: 'vertical', type: 'ElChartLayout', description: 'Categories run along Y — a "horizontal bar chart".'),
];

const List<DocsApiFact> _chartAxisTypeFacts = <DocsApiFact>[
  DocsApiFact(name: 'category', type: 'ElChartAxisType', description: 'Default.'),
  DocsApiFact(name: 'number', type: 'ElChartAxisType', description: 'A value axis.'),
];

const List<DocsApiFact> _chartSeriesKindFacts = <DocsApiFact>[
  DocsApiFact(name: 'area', type: 'ElChartSeriesKind', description: 'None.'),
  DocsApiFact(name: 'bar', type: 'ElChartSeriesKind', description: 'None.'),
  DocsApiFact(name: 'line', type: 'ElChartSeriesKind', description: 'None.'),
];

const List<DocsApiFact> _chartLabelPositionFacts = <DocsApiFact>[
  DocsApiFact(name: 'top', type: 'ElChartLabelPosition', description: 'Default.'),
  DocsApiFact(name: 'right', type: 'ElChartLabelPosition', description: 'None.'),
  DocsApiFact(name: 'insideLeft', type: 'ElChartLabelPosition', description: 'None.'),
  DocsApiFact(name: 'insideEnd', type: 'ElChartLabelPosition', description: 'None.'),
];

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Hover',
    treatment:
        'MouseRegion.onHover resolves the nearest category by pixel distance '
        'and calls setState; onExit clears it back to the tooltip\'s own '
        'defaultIndex, if one was given.',
    userSignal:
        'The cursor highlight band (if tooltip.cursor is true) and the '
        'tooltip panel both track the hovered category.',
  ),
  DocsStateFact(
    state: 'Entrance',
    treatment:
        'An AnimationController runs once on mount (or on a reduced-motion '
        'context, jumps straight to 1): areas and lines reveal left to '
        'right under a clip rect, and bars grow from their own baseline.',
    userSignal: 'Purely visual; no data is added or removed by the animation.',
  ),
  DocsStateFact(
    state: 'stackOffsetExpand',
    treatment: 'Turns every stack into a 0…1 share of its own total rather than an absolute sum.',
    userSignal: 'Chosen once per chart at construction, never toggled by the widget itself.',
  ),
];

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'No Semantics node anywhere in chart_cartesian.dart — checked '
            'directly against the source. The whole plot is one CustomPaint '
            'plus a handful of Positioned ElText labels, none of which carry '
            'an accessible role or name.',
        'Colour is the only signal that tells two series apart when a '
            'legend is absent: there is no pattern, texture, or shape '
            'difference between an area, a bar and a line beyond what the '
            'caller\'s own fill and stroke say.',
        'The tooltip panel (ElChartTooltipContent, from chart) is not '
            'wired to any focus or live-region behaviour here: it appears on '
            'MouseRegion.onHover only, so a keyboard-only or screen-reader '
            'user cannot reach it at all.',
      ]);
}

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'No FocusNode, no Focus widget, no key handler anywhere in '
            'chart_cartesian.dart. ElCartesianChart answers a pointer hover '
            '(MouseRegion.onHover) and nothing else.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'The whole layout is recomputed every build inside a LayoutBuilder: '
            'a resize reruns _CartesianLayout.resolve with the new size, not '
            'a cached one.',
        'Axis label text is measured with a TextPainter and preserveEnd '
            'drops labels that would collide, so a category axis on a '
            'narrow viewport prints fewer dates rather than overlapping '
            'ones.',
        'No breakpoint token is read anywhere in the file: every number is '
            'plot maths (a margin, an axis size, a tick gap), not a '
            'responsive rule keyed to ElBreakpoints.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      _bullets(ElTheme.of(context), <String>[
        'File: lib/src/components/chart_cartesian.dart — one file, no '
            'companions.',
        'Flutter imports: package:flutter/gestures.dart (PointerHoverEvent) '
            'and package:flutter/widgets.dart only — no '
            'package:flutter/material.dart anywhere in the file.',
        'registryDependencies, resolved automatically by `elattar add '
            'chart-cartesian`: chart and chart-geometry, copied verbatim '
            'from registry/components/chart-cartesian.json.',
        'chart supplies ElChartContainer, ElChartConfig, '
            'ElChartTooltipContent and ElChartLegendContent, every one of '
            'which chart_cartesian.dart composes rather than reimplements.',
        'chart-geometry supplies every scale and path routine: '
            'ElBandScale, ElPointScale, ElLinearScale, elBarSlots, '
            'elBarRRect, elCurvePath, and elAreaPath.',
      ]),
      SizedBox(height: el(4)),
      DocsLinkRow(
        links: <DocsLink>[
          DocsLink(label: chart.chartDoc.title, route: chart.chartDoc.route),
          DocsLink(
            label: chart_geometry.chartGeometryDoc.title,
            route: chart_geometry.chartGeometryDoc.route,
          ),
        ],
      ),
    ],
  );
}

class _ThemingContent extends StatelessWidget {
  const _ThemingContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'chart_cartesian.dart reads theme.border (the grid, at 50% alpha, '
            'and the cursor highlight band via theme.muted) and '
            'theme.mutedForeground/theme.foreground for tick labels — the '
            'same colours chart.dart\'s ElChartContainer already sets up.',
        'No series colour is read from the theme by this file itself: '
            'ElChartSeriesSpec.fill/stroke are always supplied by the '
            'caller, normally one of theme.chart1…5.',
        'ElChartMotion.duration (ElDurations.slow) and ElChartMotion.curve '
            '(ElCurves.cssEaseOut, not ElCurves.out — a documented drift, '
            'see chart\'s own Theming disclosure) drive every entrance '
            'animation.',
        'Every label is ElChartText.xs — never a `.type-*` rung from the '
            'type scale — inherited from the DefaultTextStyle chart.dart\'s '
            'ElChartContainer sets on the whole subtree.',
      ]);
}

Widget _bullets(ElThemeData theme, List<String> lines) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: <Widget>[
    for (final String line in lines) ...<Widget>[
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: ElWidths.prose),
        child: ElText('•  $line', ElType.small, color: theme.mutedForeground),
      ),
      SizedBox(height: el(2)),
    ],
  ],
);
