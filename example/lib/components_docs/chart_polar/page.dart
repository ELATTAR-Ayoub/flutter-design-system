/// Public documentation page for the `chart-polar` component.
///
/// **Three widgets, one convention.** `ElPieChart`, `ElRadarChart` and
/// `ElRadialBarChart` all read angles the same way —
/// `elPolarToCartesian` (`chart-geometry`): degrees, counter-clockwise from
/// three o'clock, negated on the way into screen space. That is why a pie
/// that starts at 0° starts on the right-hand side and sweeps upward, and
/// it is why `ElRadialBarChart.startAngle`/`endAngle` are written plainly
/// rather than through a token: an angle is plot maths, the same class of
/// number a margin or a band gap is.
///
/// **Section order.** Preview, Installation, Usage, then Pie, Active &
/// Labels, Radar, Radial Bar, Legend & Tooltip — then the eight standing
/// disclosures.
///
/// **Data.** Every specimen's data is modelled on the two fixtures
/// `example/lib/pages/charts.dart` already reuses across its own eleven pie,
/// five radar and five radial specimens: five browsers' worth of
/// `visitors`, and six months of `desktop` (radar's own fixture bumps April
/// from 73 to 273 — "a radar polygon whose fourth vertex sits at 27% of the
/// radius reads as a fold rather than as a shape," per that file's own
/// comment). Neither array is imported from that file — it lives under
/// `example/lib/pages/`, which this rollout does not touch — but the shape
/// and the numbers are the same fixture, not an invented one.
///
/// **Read, not inferred.** Every claim traces to a line in
/// `lib/src/components/chart_polar.dart`. `grep -n "Semantics\|FocusNode"
/// lib/src/components/chart_polar.dart` returns zero matches — Accessibility
/// and Keyboard both say so rather than inventing a story the file does not
/// tell.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/component_doc_page.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../docs/docs_section.dart' show DocsAnchor;
import '../chart/meta.dart' as chart;
import '../chart_cartesian/meta.dart' as chart_cartesian;
import '../chart_geometry/meta.dart' as chart_geometry;
import 'meta.dart';

/* ── Shared data ─────────────────────────────────────────────────────────── */

/// Modelled on `pages/charts.dart`'s own `BROWSERS` fixture, with each row's
/// `fill` resolved from the theme the way that file's `_ChartInk.rows` does.
List<Map<String, Object?>> _pieBrowsers(ElThemeData theme) =>
    <Map<String, Object?>>[
      <String, Object?>{'browser': 'Chrome', 'visitors': 275, 'fill': theme.chart1},
      <String, Object?>{'browser': 'Safari', 'visitors': 200, 'fill': theme.chart2},
      <String, Object?>{'browser': 'Firefox', 'visitors': 187, 'fill': theme.chart3},
      <String, Object?>{'browser': 'Edge', 'visitors': 173, 'fill': theme.chart4},
      <String, Object?>{'browser': 'Other', 'visitors': 90, 'fill': theme.chart5},
    ];

/// Modelled on `pages/charts.dart`'s own `_radarMonths` fixture: April reads
/// 273, not 73, for the reason that file's own comment gives.
const List<Map<String, Object?>> _radarMonths = <Map<String, Object?>>[
  <String, Object?>{'month': 'Jan', 'desktop': 186},
  <String, Object?>{'month': 'Feb', 'desktop': 305},
  <String, Object?>{'month': 'Mar', 'desktop': 237},
  <String, Object?>{'month': 'Apr', 'desktop': 273},
  <String, Object?>{'month': 'May', 'desktop': 209},
  <String, Object?>{'month': 'Jun', 'desktop': 214},
];

const List<Map<String, Object?>> _radarMonthsDesktopMobile = <Map<String, Object?>>[
  <String, Object?>{'month': 'Jan', 'desktop': 186, 'mobile': 80},
  <String, Object?>{'month': 'Feb', 'desktop': 305, 'mobile': 200},
  <String, Object?>{'month': 'Mar', 'desktop': 237, 'mobile': 120},
  <String, Object?>{'month': 'Apr', 'desktop': 273, 'mobile': 190},
  <String, Object?>{'month': 'May', 'desktop': 209, 'mobile': 130},
  <String, Object?>{'month': 'Jun', 'desktop': 214, 'mobile': 140},
];

/// The declaration: every section this page shows, in TOC order. `final`,
/// not `const`: `InstallSection.command` reads `chartPolarDoc.command`, a
/// computed getter, not a constant expression.
final ComponentDocSpec chartPolarDocSpec = ComponentDocSpec(
  name: 'chart_polar',
  title: 'Chart Polar',
  description: chartPolarDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'The three polar families, stacked: a pie, a radar, and a radial '
          'bar chart, each reading the same degrees-counter-clockwise-from-'
          'three-o\'clock convention through `elPolarToCartesian`.',
      specimen: const _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
      minHeight: el(160),
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'chart-polar has a real registry manifest, `elattar add '
          'chart-polar` installs lib/src/components/chart_polar.dart and '
          'resolves its three registryDependencies, chart, chart-cartesian '
          'and chart-geometry, automatically. The Manual tab is for a '
          'project not using the CLI.',
      command: chartPolarDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/chart_polar.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/chart_polar.dart's generated "
              '@ui/chart_polar.dart payload into components/ui.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated chart_polar source here when using '
              'manual mode.',
        ),
        DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so ElPieChart, ElRadarChart, '
              'ElRadialBarChart and the rest are reachable the same way the '
              'CLI path already makes them.',
          code: "export 'chart_polar.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'The smallest correct construction: an `ElChartConfig`, an '
          '`ElChartContainer` to mount in, and one `ElPieSpec` for the '
          'wedges themselves.',
      code: _usageCode,
    ),
    ShowcaseSection(
      id: 'pie',
      title: 'Pie',
      description:
          'A plain pie, and a donut: `innerRadius` is pixels, not a '
          'percentage, kept per `radial.tsx`\'s own precedent that a polar '
          'radius is plot maths rather than a token.',
      specimen: const _PieSpecimen(),
      code: _pieCode,
      label: 'Pie specimen view',
      minHeight: el(160),
    ),
    ShowcaseSection(
      id: 'active-labels',
      title: 'Active & Labels',
      description:
          'An `activeIndex` wedge grown by `activeGrow` with a detached '
          '`activeRing` outside it, and `outsideLabel`, whose text is drawn '
          'on the panel background — never on the wedge\'s own fill, which '
          '`--chart-1`\'s measured luminance (0.179, within a thousandth of '
          'the value at which black and white are equally legible) makes '
          'unsafe for text at any of the five chart tokens.',
      specimen: const _ActiveLabelsSpecimen(),
      code: _activeLabelsCode,
      label: 'Active and labels specimen view',
      minHeight: el(160),
    ),
    ShowcaseSection(
      id: 'radar',
      title: 'Radar',
      description:
          'A filled radar, and two overlapping series with vertex dots. '
          'The registry gives the second series no `fillOpacity` at all, so '
          'it paints fully opaque over the first — kept here as the '
          'registry\'s own choice, not corrected to something translucent.',
      specimen: const _RadarSpecimen(),
      code: _radarCode,
      label: 'Radar specimen view',
      minHeight: el(160),
    ),
    ShowcaseSection(
      id: 'radial-bar',
      title: 'Radial Bar',
      description:
          '`background: true` paints the unfilled remainder of each ring '
          'in `theme.muted` — `ChartContainer` already carries that colour, '
          'so the series needs none of its own. `chipLabelKey` draws a '
          'label chip at each arc\'s START angle, the only placement where '
          'five of them cannot collide.',
      specimen: const _RadialBarSpecimen(),
      code: _radialBarCode,
      label: 'Radial bar specimen view',
      minHeight: el(160),
    ),
    ShowcaseSection(
      id: 'legend-tooltip',
      title: 'Legend & Tooltip',
      description:
          'A `ElChartLegendSpec` wired into a pie (`wrap: true`, the shape '
          '`PieLegend` reaches for once a fourth or fifth key would '
          'overflow one line), and a pie tooltip pinned open via '
          '`ElChartTooltipSpec.defaultIndex` so the specimen is not a '
          'screenshot of empty space.',
      specimen: const _LegendTooltipSpecimen(),
      code: _legendTooltipCode,
      label: 'Legend and tooltip specimen view',
      minHeight: el(160),
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every constructor parameter each exported class declares, and '
          'every value of every exported enum: one table per class or enum.',
      children: const <DocsTocEntry>[
        DocsTocEntry(title: 'ElPieChart', anchor: 'api-elpiechart'),
        DocsTocEntry(title: 'ElPieSpec', anchor: 'api-elpiespec'),
        DocsTocEntry(title: 'ElRadarChart', anchor: 'api-elradarchart'),
        DocsTocEntry(title: 'ElRadarSpec', anchor: 'api-elradarspec'),
        DocsTocEntry(title: 'ElChartDotSpec', anchor: 'api-elchartdotspec'),
        DocsTocEntry(
          title: 'ElRadialBarChart',
          anchor: 'api-elradialbarchart',
        ),
        DocsTocEntry(title: 'ElRadialBarSpec', anchor: 'api-elradialbarspec'),
        DocsTocEntry(title: 'ElPolarGrid', anchor: 'api-elpolargrid'),
        DocsTocEntry(
          title: 'ElPolarAngleAxis',
          anchor: 'api-elpolarangleaxis',
        ),
        DocsTocEntry(
          title: 'ElPolarRadiusAxis',
          anchor: 'api-elpolarradiusaxis',
        ),
        DocsTocEntry(title: 'ElPolarGridType', anchor: 'api-elpolargridtype'),
      ],
      child: const _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'All three widgets own exactly one entrance animation and no '
          'other internal state; ElPieChart additionally reads a caller-set '
          '`activeIndex` to grow one wedge. Everything else below is '
          'configuration passed in at construction.',
      child: DocsStateMatrix(facts: _stateFacts),
    ),
    DisclosureSection(
      id: 'accessibility',
      title: 'Accessibility',
      description:
          'Read straight off the source: chart_polar.dart wires no '
          '`Semantics` node anywhere in the file.',
      child: const _AccessibilityContent(),
    ),
    DisclosureSection(
      id: 'keyboard',
      title: 'Keyboard',
      description:
          'No `FocusNode`, no `Focus` widget, and no key handler anywhere '
          'in chart_polar.dart: none of the three widgets take keyboard '
          'focus or answer a key.',
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
            value: chartPolarDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/chart_polar_test.dart',
            description:
                'Covers this page: the article mounts, every exported '
                'class and enum this page claims to document, the full API '
                'table, and both themes at two viewport widths.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/chart_polar/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class ChartPolarDocPage extends StatelessWidget {
  const ChartPolarDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: chartPolarDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / BASE',
      title: chartPolarDoc.title,
      description: chartPolarDoc.description,
    ),
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Components'),
      ElBreadcrumbEntry.page('Chart Polar'),
    ],
    toc: chartPolarDocSpec.toc,
    previous: DocsPageLink(
      title: chart_geometry.chartGeometryDoc.title,
      route: chart_geometry.chartGeometryDoc.route,
    ),
    next: null,
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('chart-polar-doc-article'),
      child: ComponentDocPage(spec: chartPolarDocSpec, header: false),
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
          key: const ValueKey<String>('chart-polar-preview:pie'),
          child: ElChartContainer(
            config: const ElChartConfig(<String, ElChartSeries>{}),
            child: ElPieChart(
              pies: <ElPieSpec>[
                ElPieSpec(
                  data: _pieBrowsers(theme),
                  dataKey: 'visitors',
                  nameKey: 'browser',
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: el(4)),
        KeyedSubtree(
          key: const ValueKey<String>('chart-polar-preview:radar'),
          child: ElChartContainer(
            config: ElChartConfig(<String, ElChartSeries>{
              'desktop': ElChartSeries(label: 'Desktop', color: theme.chart1),
            }),
            child: ElRadarChart(
              data: _radarMonths,
              series: <ElRadarSpec>[
                ElRadarSpec(
                  dataKey: 'desktop',
                  fill: theme.chart1,
                  fillOpacity: 0.6,
                  stroke: theme.chart1,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: el(4)),
        KeyedSubtree(
          key: const ValueKey<String>('chart-polar-preview:radial'),
          child: ElChartContainer(
            config: const ElChartConfig(<String, ElChartSeries>{}),
            child: ElRadialBarChart(
              data: _pieBrowsers(theme),
              innerRadius: 30,
              outerRadius: 110,
              series: const <ElRadialBarSpec>[
                ElRadialBarSpec(dataKey: 'visitors', background: true),
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
    '  config: const ElChartConfig({}),\n'
    '  child: ElPieChart(\n'
    '    pies: [\n'
    "      ElPieSpec(data: browsers, dataKey: 'visitors', nameKey: 'browser'),\n"
    '    ],\n'
    '  ),\n'
    ')';

const String _usageCode =
    "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
    'ElChartContainer(\n'
    '  config: const ElChartConfig({}),\n'
    '  child: ElPieChart(\n'
    '    pies: [\n'
    "      ElPieSpec(\n"
    "        data: [ {'name': 'Chrome', 'value': 275, 'fill': theme.chart1} ],\n"
    "        dataKey: 'value',\n"
    "        nameKey: 'name',\n"
    '      ),\n'
    '    ],\n'
    '  ),\n'
    ')';

class _PieSpecimen extends StatelessWidget {
  const _PieSpecimen();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        KeyedSubtree(
          key: const ValueKey<String>('chart-polar-example:pie-simple'),
          child: ElChartContainer(
            config: const ElChartConfig(<String, ElChartSeries>{}),
            child: ElPieChart(
              pies: <ElPieSpec>[
                ElPieSpec(
                  data: _pieBrowsers(theme),
                  dataKey: 'visitors',
                  nameKey: 'browser',
                ),
              ],
              tooltip: const ElChartTooltipSpec(cursor: false, hideLabel: true),
            ),
          ),
        ),
        SizedBox(height: el(4)),
        KeyedSubtree(
          key: const ValueKey<String>('chart-polar-example:pie-donut'),
          child: ElChartContainer(
            config: const ElChartConfig(<String, ElChartSeries>{}),
            child: ElPieChart(
              pies: <ElPieSpec>[
                ElPieSpec(
                  data: _pieBrowsers(theme),
                  dataKey: 'visitors',
                  nameKey: 'browser',
                  innerRadius: 60,
                ),
              ],
              tooltip: const ElChartTooltipSpec(cursor: false, hideLabel: true),
              centerLabel: (BuildContext context) {
                final int total = _pieBrowsers(
                  theme,
                ).fold<int>(0, (int a, Map<String, Object?> r) => a + (r['visitors']! as int));
                return ElText(elChartNumber(total), ElType.h4, color: theme.foreground);
              },
            ),
          ),
        ),
      ],
    );
  }
}

const String _pieCode =
    'ElPieSpec(data: browsers, dataKey: \'visitors\', nameKey: \'browser\')\n\n'
    '// A donut: innerRadius is pixels, not a percentage.\n'
    'ElPieSpec(data: browsers, dataKey: \'visitors\', nameKey: \'browser\', innerRadius: 60)\n\n'
    '// centerLabel prints in the hole:\n'
    'ElPieChart(pies: [...], centerLabel: (context) => Text(elChartNumber(total)))';

class _ActiveLabelsSpecimen extends StatelessWidget {
  const _ActiveLabelsSpecimen();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        KeyedSubtree(
          key: const ValueKey<String>('chart-polar-example:pie-active'),
          child: ElChartContainer(
            config: const ElChartConfig(<String, ElChartSeries>{}),
            child: ElPieChart(
              pies: <ElPieSpec>[
                ElPieSpec(
                  data: _pieBrowsers(theme),
                  dataKey: 'visitors',
                  nameKey: 'browser',
                  innerRadius: 60,
                  activeIndex: 0,
                  activeGrow: 10,
                  activeRing: true,
                ),
              ],
              tooltip: const ElChartTooltipSpec(cursor: false, hideLabel: true),
            ),
          ),
        ),
        SizedBox(height: el(4)),
        KeyedSubtree(
          key: const ValueKey<String>('chart-polar-example:pie-outside-label'),
          child: ElChartContainer(
            config: const ElChartConfig(<String, ElChartSeries>{}),
            child: ElPieChart(
              pies: <ElPieSpec>[
                ElPieSpec(
                  data: _pieBrowsers(theme),
                  dataKey: 'visitors',
                  nameKey: 'browser',
                  outsideLabel: true,
                ),
              ],
              labelColor: theme.foreground,
              tooltip: const ElChartTooltipSpec(hideLabel: true),
            ),
          ),
        ),
      ],
    );
  }
}

const String _activeLabelsCode =
    'ElPieSpec(\n'
    '  data: browsers, dataKey: \'visitors\', nameKey: \'browser\',\n'
    '  activeIndex: 0, activeGrow: 10, activeRing: true,\n'
    ')\n\n'
    '// The label draws on the panel background, never on the wedge\'s fill:\n'
    'ElPieChart(\n'
    '  pies: [ElPieSpec(..., outsideLabel: true)],\n'
    '  labelColor: theme.foreground,\n'
    ')';

class _RadarSpecimen extends StatelessWidget {
  const _RadarSpecimen();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        KeyedSubtree(
          key: const ValueKey<String>('chart-polar-example:radar-filled'),
          child: ElChartContainer(
            config: ElChartConfig(<String, ElChartSeries>{
              'desktop': ElChartSeries(label: 'Desktop', color: theme.chart1),
            }),
            child: ElRadarChart(
              data: _radarMonths,
              grid: const ElPolarGrid(),
              angleAxis: const ElPolarAngleAxis(dataKey: 'month'),
              series: <ElRadarSpec>[
                ElRadarSpec(
                  dataKey: 'desktop',
                  fill: theme.chart1,
                  fillOpacity: 0.6,
                  stroke: theme.chart1,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: el(4)),
        KeyedSubtree(
          key: const ValueKey<String>('chart-polar-example:radar-two-series'),
          child: ElChartContainer(
            config: ElChartConfig(<String, ElChartSeries>{
              'desktop': ElChartSeries(label: 'Desktop', color: theme.chart1),
              'mobile': ElChartSeries(label: 'Mobile', color: theme.chart2),
            }),
            child: ElRadarChart(
              data: _radarMonthsDesktopMobile,
              grid: const ElPolarGrid(),
              angleAxis: const ElPolarAngleAxis(dataKey: 'month'),
              series: <ElRadarSpec>[
                ElRadarSpec(
                  dataKey: 'desktop',
                  fill: theme.chart1,
                  fillOpacity: 0.6,
                  stroke: theme.chart1,
                  dot: const ElChartDotSpec(),
                ),
                ElRadarSpec(
                  dataKey: 'mobile',
                  fill: theme.chart2,
                  stroke: theme.chart2,
                  dot: const ElChartDotSpec(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

const String _radarCode =
    'ElRadarChart(\n'
    '  data: months,\n'
    "  angleAxis: const ElPolarAngleAxis(dataKey: 'month'),\n"
    '  series: [\n'
    '    ElRadarSpec(\n'
    "      dataKey: 'desktop',\n"
    '      fill: theme.chart1,\n'
    '      fillOpacity: 0.6,\n'
    '      stroke: theme.chart1,\n'
    '      dot: const ElChartDotSpec(),\n'
    '    ),\n'
    '  ],\n'
    ')';

class _RadialBarSpecimen extends StatelessWidget {
  const _RadialBarSpecimen();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        KeyedSubtree(
          key: const ValueKey<String>('chart-polar-example:radial-simple'),
          child: ElChartContainer(
            config: const ElChartConfig(<String, ElChartSeries>{}),
            child: ElRadialBarChart(
              data: _pieBrowsers(theme),
              innerRadius: 30,
              outerRadius: 110,
              series: const <ElRadialBarSpec>[
                ElRadialBarSpec(dataKey: 'visitors', background: true),
              ],
              tooltip: const ElChartTooltipSpec(
                cursor: false,
                hideLabel: true,
                nameKey: 'browser',
              ),
            ),
          ),
        ),
        SizedBox(height: el(4)),
        KeyedSubtree(
          key: const ValueKey<String>('chart-polar-example:radial-label'),
          child: ElChartContainer(
            config: const ElChartConfig(<String, ElChartSeries>{}),
            child: ElRadialBarChart(
              data: _pieBrowsers(theme),
              startAngle: -90,
              endAngle: 380,
              innerRadius: 30,
              outerRadius: 110,
              grid: const ElPolarGrid(gridType: ElPolarGridType.circle),
              series: const <ElRadialBarSpec>[
                ElRadialBarSpec(
                  dataKey: 'visitors',
                  background: true,
                  chipLabelKey: 'browser',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

const String _radialBarCode =
    'ElRadialBarChart(\n'
    '  data: browsers,\n'
    '  innerRadius: 30,\n'
    '  outerRadius: 110,\n'
    '  series: [\n'
    "    ElRadialBarSpec(dataKey: 'visitors', background: true, chipLabelKey: 'browser'),\n"
    '  ],\n'
    ')';

class _LegendTooltipSpecimen extends StatelessWidget {
  const _LegendTooltipSpecimen();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        KeyedSubtree(
          key: const ValueKey<String>('chart-polar-example:pie-legend'),
          child: ElChartContainer(
            config: const ElChartConfig(<String, ElChartSeries>{}),
            child: ElPieChart(
              pies: <ElPieSpec>[
                ElPieSpec(
                  data: _pieBrowsers(theme),
                  dataKey: 'visitors',
                  nameKey: 'browser',
                ),
              ],
              legend: const ElChartLegendSpec(nameKey: 'browser', wrap: true, offset: 8),
            ),
          ),
        ),
        SizedBox(height: el(4)),
        KeyedSubtree(
          key: const ValueKey<String>('chart-polar-example:pie-tooltip-pinned'),
          child: ElChartContainer(
            config: const ElChartConfig(<String, ElChartSeries>{}),
            child: ElPieChart(
              pies: <ElPieSpec>[
                ElPieSpec(
                  data: _pieBrowsers(theme),
                  dataKey: 'visitors',
                  nameKey: 'browser',
                ),
              ],
              tooltip: const ElChartTooltipSpec(
                defaultIndex: 1,
                nameKey: 'browser',
              ),
            ),
          ),
        ),
      ],
    );
  }
}

const String _legendTooltipCode =
    'ElPieChart(\n'
    '  pies: [...],\n'
    "  legend: const ElChartLegendSpec(nameKey: 'browser', wrap: true, offset: 8),\n"
    ')\n\n'
    '// Pinned open without a pointer:\n'
    "ElPieChart(pies: [...], tooltip: const ElChartTooltipSpec(defaultIndex: 1))";

/* ── Disclosure content ─────────────────────────────────────────────────── */

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsAnchor(
        id: 'api-elpiechart',
        child: DocsApiTable(title: 'ElPieChart', facts: _pieChartFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elpiespec',
        child: DocsApiTable(title: 'ElPieSpec', facts: _pieSpecFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elradarchart',
        child: DocsApiTable(title: 'ElRadarChart', facts: _radarChartFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elradarspec',
        child: DocsApiTable(title: 'ElRadarSpec', facts: _radarSpecFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elchartdotspec',
        child: DocsApiTable(title: 'ElChartDotSpec', facts: _chartDotSpecFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elradialbarchart',
        child: DocsApiTable(
          title: 'ElRadialBarChart',
          facts: _radialBarChartFacts,
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elradialbarspec',
        child: DocsApiTable(
          title: 'ElRadialBarSpec',
          facts: _radialBarSpecFacts,
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elpolargrid',
        child: DocsApiTable(title: 'ElPolarGrid', facts: _polarGridFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elpolarangleaxis',
        child: DocsApiTable(
          title: 'ElPolarAngleAxis',
          facts: _polarAngleAxisFacts,
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elpolarradiusaxis',
        child: DocsApiTable(
          title: 'ElPolarRadiusAxis',
          facts: _polarRadiusAxisFacts,
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elpolargridtype',
        child: DocsApiTable(title: 'ElPolarGridType', facts: _polarGridTypeFacts),
      ),
    ],
  );
}

const List<DocsApiFact> _pieChartFacts = <DocsApiFact>[
  DocsApiFact(name: 'pies', type: 'List<ElPieSpec>', description: 'Required. One or more concentric rings.'),
  DocsApiFact(name: 'legend', type: 'ElChartLegendSpec?', description: 'Null renders no legend.'),
  DocsApiFact(name: 'tooltip', type: 'ElChartTooltipSpec?', description: 'Null answers no hover with a panel.'),
  DocsApiFact(name: 'centerLabel', type: 'WidgetBuilder?', description: 'The donut\'s centred content — usually a total.'),
  DocsApiFact(
    name: 'labelColor',
    type: 'Color?',
    description: 'Takes an outsideLabel off its slice\'s own fill — the container sweep that keeps a label legible.',
  ),
];

const List<DocsApiFact> _pieSpecFacts = <DocsApiFact>[
  DocsApiFact(name: 'data', type: 'List<Map<String, Object?>>', description: 'Required.'),
  DocsApiFact(name: 'dataKey', type: 'String', description: 'Required. The field each wedge\'s sweep is proportional to.'),
  DocsApiFact(name: 'nameKey', type: 'String?', description: 'Which field names a wedge in the tooltip and legend.'),
  DocsApiFact(name: 'innerRadius', type: 'double?', description: 'Pixels, not a percentage. Null draws a full pie, no hole.'),
  DocsApiFact(name: 'outerRadius', type: 'double?', description: 'Pixels. Null defaults to 80% of the plot\'s max radius.'),
  DocsApiFact(name: 'startAngle', type: 'double', description: 'Default 0.'),
  DocsApiFact(name: 'endAngle', type: 'double', description: 'Default 360.'),
  DocsApiFact(name: 'paddingAngle', type: 'double', description: 'Default 0.'),
  DocsApiFact(name: 'strokeWidth', type: 'double', description: 'The gap between wedges, painted in the surface colour. Default 1.'),
  DocsApiFact(name: 'activeIndex', type: 'int?', description: 'Which wedge activeGrow/activeRing apply to.'),
  DocsApiFact(name: 'activeGrow', type: 'double', description: 'Extra outer radius on the active wedge. Default 0.'),
  DocsApiFact(name: 'activeRing', type: 'bool', description: 'A second, detached ring outside the grown wedge. Default false.'),
  DocsApiFact(name: 'outsideLabel', type: 'bool', description: 'The value printed outside the wedge with a leader line. Default false.'),
  DocsApiFact(name: 'labelLine', type: 'bool', description: 'Default true.'),
  DocsApiFact(name: 'labelBuilder', type: 'String Function(Map<String, Object?>)?', description: 'Overrides the printed outside label.'),
  DocsApiFact(name: 'chipLabelKey', type: 'String?', description: 'Draws a label chip on the panel, at each wedge\'s mid-angle.'),
];

const List<DocsApiFact> _radarChartFacts = <DocsApiFact>[
  DocsApiFact(name: 'data', type: 'List<Map<String, Object?>>', description: 'Required.'),
  DocsApiFact(name: 'series', type: 'List<ElRadarSpec>', description: 'Required.'),
  DocsApiFact(name: 'grid', type: 'ElPolarGrid?', description: 'Null draws no web at all.'),
  DocsApiFact(name: 'angleAxis', type: 'ElPolarAngleAxis?', description: 'Null draws no category label around the web.'),
  DocsApiFact(name: 'radiusAxis', type: 'ElPolarRadiusAxis?', description: 'Null draws no value label along a spoke.'),
  DocsApiFact(name: 'legend', type: 'ElChartLegendSpec?', description: 'Null renders no legend.'),
  DocsApiFact(name: 'margin', type: 'ElChartMargin', description: 'Default ElChartMargin.standard.'),
  DocsApiFact(name: 'startAngle', type: 'double (static)', description: '90 — twelve o\'clock.'),
  DocsApiFact(name: 'endAngle', type: 'double (static)', description: '-270 — all the way round.'),
];

const List<DocsApiFact> _radarSpecFacts = <DocsApiFact>[
  DocsApiFact(name: 'dataKey', type: 'String', description: 'Required.'),
  DocsApiFact(name: 'fill', type: 'Color?', description: 'None.'),
  DocsApiFact(
    name: 'fillOpacity',
    type: 'double',
    description: 'Default 1 — two overlapping radars need at least one translucent or the second erases the first.',
  ),
  DocsApiFact(name: 'stroke', type: 'Color?', description: 'None.'),
  DocsApiFact(name: 'strokeWidth', type: 'double', description: 'Default 1.'),
  DocsApiFact(name: 'dot', type: 'ElChartDotSpec?', description: 'Draws a marker at every vertex. Null draws none.'),
];

const List<DocsApiFact> _chartDotSpecFacts = <DocsApiFact>[
  DocsApiFact(name: 'radius', type: 'double', description: 'Default 4.'),
  DocsApiFact(name: 'fillOpacity', type: 'double', description: 'Default 1.'),
];

const List<DocsApiFact> _radialBarChartFacts = <DocsApiFact>[
  DocsApiFact(name: 'data', type: 'List<Map<String, Object?>>', description: 'Required.'),
  DocsApiFact(name: 'series', type: 'List<ElRadialBarSpec>', description: 'Required.'),
  DocsApiFact(name: 'innerRadius', type: 'double', description: 'Required. Pixels.'),
  DocsApiFact(name: 'outerRadius', type: 'double', description: 'Required. Pixels.'),
  DocsApiFact(
    name: 'startAngle',
    type: 'double',
    description: 'Degrees, counter-clockwise from three o\'clock. Default 0.',
  ),
  DocsApiFact(name: 'endAngle', type: 'double', description: 'Default 360.'),
  DocsApiFact(name: 'grid', type: 'ElPolarGrid?', description: 'None.'),
  DocsApiFact(name: 'angleAxis', type: 'ElPolarAngleAxis?', description: 'domain widens the ring for a stacked chart.'),
  DocsApiFact(name: 'radiusAxis', type: 'ElPolarRadiusAxis?', description: 'centerLabel is the only field a radial reads.'),
  DocsApiFact(name: 'tooltip', type: 'ElChartTooltipSpec?', description: 'None.'),
];

const List<DocsApiFact> _radialBarSpecFacts = <DocsApiFact>[
  DocsApiFact(name: 'dataKey', type: 'String', description: 'Required.'),
  DocsApiFact(name: 'fill', type: 'Color?', description: 'Null reads each row\'s own fill field.'),
  DocsApiFact(
    name: 'background',
    type: 'bool',
    description: 'Draws the unfilled remainder of the ring in theme.muted. Default false.',
  ),
  DocsApiFact(name: 'cornerRadius', type: 'double', description: 'From the radius ladder, read by the caller. Default 0.'),
  DocsApiFact(name: 'stackId', type: 'String?', description: 'Shared by several series to stack within one ring.'),
  DocsApiFact(name: 'chipLabelKey', type: 'String?', description: 'A label chip at the arc\'s START angle.'),
];

const List<DocsApiFact> _polarGridFacts = <DocsApiFact>[
  DocsApiFact(name: 'gridType', type: 'ElPolarGridType', description: 'polygon (default) or circle.'),
  DocsApiFact(name: 'radialLines', type: 'bool', description: 'The spokes. Default true.'),
  DocsApiFact(name: 'polarRadius', type: 'List<double>?', description: 'An explicit ring list. Null draws one ring per radius tick.'),
  DocsApiFact(name: 'stroke', type: 'Color?', description: 'Null takes theme.border.'),
  DocsApiFact(name: 'fills', type: 'List<Color>?', description: 'The two-ring plate under a filled radial gauge.'),
  DocsApiFact(name: 'opacity', type: 'double', description: 'Default 1.'),
];

const List<DocsApiFact> _polarAngleAxisFacts = <DocsApiFact>[
  DocsApiFact(name: 'dataKey', type: 'String?', description: 'None.'),
  DocsApiFact(name: 'tick', type: 'bool', description: 'Default true.'),
  DocsApiFact(name: 'axisLine', type: 'bool', description: 'Default true.'),
  DocsApiFact(name: 'tickLine', type: 'bool', description: 'Default true.'),
  DocsApiFact(
    name: 'domain',
    type: '({double min, double max})?',
    description: 'The explicit widening a stacked radial needs — left alone it silently draws only the largest single series.',
  ),
  DocsApiFact(
    name: 'tickBuilder',
    type: 'Widget Function(BuildContext, int, Offset, TextAlign)?',
    description: 'A custom tick render.',
  ),
  DocsApiFact(name: 'tickSize', type: 'double (static)', description: '8 — the stub between the web\'s outer vertex and its label.'),
];

const List<DocsApiFact> _polarRadiusAxisFacts = <DocsApiFact>[
  DocsApiFact(name: 'angle', type: 'double', description: 'Which spoke the scale runs along. Default 90.'),
  DocsApiFact(name: 'tick', type: 'bool', description: 'Default true.'),
  DocsApiFact(name: 'axisLine', type: 'bool', description: 'Default true.'),
  DocsApiFact(name: 'stroke', type: 'Color?', description: 'None.'),
  DocsApiFact(name: 'centerLabel', type: 'WidgetBuilder?', description: 'The number in the hole, on a radial gauge.'),
];

const List<DocsApiFact> _polarGridTypeFacts = <DocsApiFact>[
  DocsApiFact(name: 'polygon', type: 'ElPolarGridType', description: 'The vertices — the actual axes — easy to find. Default.'),
  DocsApiFact(name: 'circle', type: 'ElPolarGridType', description: 'Quieter, reads better with two overlapping series.'),
];

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Entrance',
    treatment:
        'An AnimationController runs once on mount (or, under reduced '
        'motion, jumps straight to 1): a pie sweeps its own angle, a radar '
        'polygon and a radial arc grow toward their final value.',
    userSignal: 'Purely visual; no datum is added or removed by the animation.',
  ),
  DocsStateFact(
    state: 'activeIndex / activeGrow / activeRing',
    treatment: 'ElPieSpec.activeIndex names one wedge; activeGrow and activeRing then change how THAT wedge paints.',
    userSignal: 'A caller-set value, not something ElPieChart reaches on its own — there is no hover-to-activate wiring in this file.',
  ),
  DocsStateFact(
    state: 'Hover',
    treatment: 'N/A on any of the three widgets: none wires a MouseRegion or GestureDetector of its own.',
    userSignal: 'A pinned defaultIndex tooltip is the only way a specimen on this page shows a tooltip panel.',
  ),
];

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'No Semantics node anywhere in chart_polar.dart — checked directly '
            'against the source. Every wedge, spoke and arc is one '
            'CustomPaint; every label is a plain ElText with no accessible '
            'role of its own.',
        'Colour is the only signal separating two wedges, two radar '
            'series or two radial rings when a legend is absent — there is '
            'no pattern or texture difference beyond the caller\'s own fill.',
        'ElPieChart.labelColor exists specifically because a wedge\'s own '
            'fill fails as text: chart-1\'s measured relative luminance '
            '(0.179) sits within a thousandth of the value at which black '
            'and white read equally, so 4.58:1 is the ceiling for ANY ink '
            'on it, in either theme — a label reads on the panel '
            'background instead.',
      ]);
}

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'No FocusNode, no key handling anywhere in chart_polar.dart: none '
            'of ElPieChart, ElRadarChart or ElRadialBarChart can take '
            'keyboard focus, and none answers a key.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'Every widget reads its own size from a LayoutBuilder and recomputes '
            'centre and max radius on every build — elPolarMaxRadius(width, '
            'height), from chart-geometry — rather than caching a layout '
            'across a resize.',
        'No breakpoint token is read anywhere in the file: an angle, a '
            'radius and a margin are plot maths, not a responsive rule keyed '
            'to ElBreakpoints.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      _bullets(ElTheme.of(context), <String>[
        'File: lib/src/components/chart_polar.dart — one file, no '
            'companions.',
        'Flutter imports: package:flutter/widgets.dart only — no '
            'package:flutter/material.dart anywhere in the file.',
        'registryDependencies, resolved automatically by `elattar add '
            'chart-polar`: chart, chart-cartesian and chart-geometry, '
            'copied verbatim from registry/components/chart-polar.json.',
        'chart-cartesian supplies ElChartMargin, ElChartDot\'s sibling '
            'shapes and ElBarSlot layout — the label-chip radial-bar '
            'geometry reuses elBarSlots for its own ring bands.',
        'chart-geometry supplies elPolarToCartesian, elPolarMaxRadius, '
            'elSectorPath, elSectorWithCornerPath and elPolarPolygonPath — '
            'every path this file paints.',
      ]),
      SizedBox(height: el(4)),
      DocsLinkRow(
        links: <DocsLink>[
          DocsLink(label: chart.chartDoc.title, route: chart.chartDoc.route),
          DocsLink(
            label: chart_cartesian.chartCartesianDoc.title,
            route: chart_cartesian.chartCartesianDoc.route,
          ),
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
        'chart_polar.dart reads theme.border (grid rings and spokes), '
            'theme.muted (a radial bar\'s own background arc), theme.card '
            '+ theme.cardForeground (the arc label chip\'s own pill — the '
            'pair every Card already pairs, measured 16.97:1 dark and '
            '19.90:1 light), and theme.background (a pie wedge\'s '
            'separator stroke, in place of recharts\' own stroke="#fff").',
        'No series colour is read from the theme by this file itself: '
            'every fill and stroke on a pie, radar or radial series is '
            'supplied by the caller.',
        'ElChartMotion.duration and ElChartMotion.curve (from chart) drive '
            'every entrance animation; every label is ElChartText.xs.',
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
