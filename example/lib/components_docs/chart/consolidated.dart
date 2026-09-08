/// The one consolidated documentation page for the entire chart family.
///
/// **Why one page.** Four registry items — `chart`, `chart-cartesian`,
/// `chart-geometry`, `chart-polar` — used to carry four full pages, 5367
/// lines, each with its own exhaustive per-export API table. Since `/charts`
/// (`example/lib/site/pages/charts_gallery_page.dart`) now exists as a
/// seventy-chart gallery with copyable source for every one of them, these
/// four pages no longer need to teach by example: their job is reference
/// for someone extending or theming the engine, not a tutorial. The owner's
/// own words: "people just want to click on and copy it, use it, and have
/// the ability to change the theme if they want."
///
/// **Four routes, one body.** `[buildChartFamilySpec] `is called once per
/// registry item with that item's own [ComponentDocEntry] — so `/components/
/// chart`, `/components/chart_cartesian`, `/components/chart_geometry` and
/// `/components/chart_polar` all resolve (the install guard,
/// `example/test/docs/docs_install_test.dart`, still requires it), each
/// showing its own install command and source path, but otherwise reading
/// the same consolidated content. `example/test/docs/docs_page_shape_test.dart`
/// still gets four distinct specs, one per registered name, each with the
/// house shape.
///
/// **What got cut**, per the brief: the geometry primitives
/// (`BandScale`, `PointScale`, `LinearScale`, `chartNiceTicks`, `curvePath`,
/// `areaPath`, `polarToCartesian`, `sectorPath`, `sectorWithCornerPath`,
/// `polarPolygonPath`, `barSlots`, `barRRect`) and the painter-level types
/// (`BarRect`, `BarSeriesPainter`, `ChartLabelList`, `ChartLabelPosition`,
/// `ChartDot`, `ChartScope`, `ChartText`, `ChartMotion`) — needed only when
/// modifying the engine, not using it. They remain fully documented in the
/// four registry manifests and in the source itself; this page stops
/// enumerating them row by row. See `chart/page.dart`,
/// `chart_cartesian/page.dart`, `chart_geometry/page.dart` and
/// `chart_polar/page.dart` — now thin wrappers around this file — and the
/// task report for the full cut list with justification per assertion.
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

import '../../docs/component_doc_page.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../docs/docs_section.dart' show DocsAnchor;
import '../catalog.dart' show ComponentDocEntry;

/// Six months, two comparable series — the fixture every specimen below
/// (and every original page) already modelled on `pages/charts.dart`'s own.
const List<Map<String, Object?>> _monthlyVisitors = <Map<String, Object?>>[
  <String, Object?>{'month': 'Jan', 'desktop': 186, 'mobile': 80},
  <String, Object?>{'month': 'Feb', 'desktop': 305, 'mobile': 200},
  <String, Object?>{'month': 'Mar', 'desktop': 237, 'mobile': 120},
  <String, Object?>{'month': 'Apr', 'desktop': 173, 'mobile': 190},
  <String, Object?>{'month': 'May', 'desktop': 209, 'mobile': 130},
  <String, Object?>{'month': 'Jun', 'desktop': 214, 'mobile': 140},
];

/// The declaration every route builds from: the same eleven sections, once,
/// parameterised only by the calling route's own [ComponentDocEntry] —
/// which supplies the install command, source path, and page title each
/// route must still show as its own.
ComponentDocSpec buildChartFamilySpec({required ComponentDocEntry entry}) =>
    ComponentDocSpec(
      name: entry.name,
      title: entry.title,
      description: entry.description,
      sections: <DocsPageSection>[
        ShowcaseSection(
          id: 'preview',
          title: 'Preview',
          description:
              'One wrapper (`chart`) and three plot engines '
              '(`chart-cartesian`, `chart-geometry`, `chart-polar`) behind '
              'one API: a themed config, a fixed-height container, and a '
              'widget per plot family. This specimen is the smallest real '
              'one — a two-series area chart with its legend — not a tour; '
              'for seventy copyable charts across every family see the '
              '/charts gallery, linked again under Dependencies below.',
          specimen: const _PreviewSpecimen(),
          code: _previewCode,
          label: 'Preview specimen view',
          minHeight: space(160),
        ),
        InstallSection(
          id: 'install',
          title: 'Installation',
          description:
              'Four separate registry items make up the chart engine, and '
              'a project can install only what it needs:\n\n'
              '•  elattar add chart — the wrapper: ChartConfig, '
              'ChartContainer, the tooltip panel, the legend row, '
              'chartNumber. Every other chart item depends on this one.\n'
              '•  elattar add chart-cartesian — CartesianChart: area, bar '
              'and line, one widget with a different ChartSeriesKind.\n'
              '•  elattar add chart-geometry — the scale, tick and path '
              'maths chart-cartesian and chart-polar both draw through. No '
              'dependencies of its own.\n'
              '•  elattar add chart-polar — PieChart, RadarChart and '
              'RadialBarChart, three widgets sharing one polar convention.\n\n'
              'This page\'s own command, below, installs ${entry.sourcePath} '
              'and resolves that item\'s registryDependencies automatically. '
              'The Manual tab is for a project not using the CLI.',
          command: entry.command,
          manualFiles: <DocsCodeFile>[
            DocsCodeFile(
              path: 'lib/components/ui/${entry.sourcePath.split('/').last}',
              title: '1. Copy the source',
              description:
                  "Copy ${entry.sourcePath}'s generated payload into "
                  'components/ui.',
              code:
                  "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
                  '// Copy the generated source here when using manual mode.',
            ),
            DocsCodeFile(
              path: 'lib/components/ui/ui.dart',
              title: '2. Export it from your barrel',
              description:
                  'Add the export line so this item\'s exports are '
                  'reachable the same way the CLI path already makes them.',
              code: "export '${entry.sourcePath.split('/').last}';",
            ),
          ],
        ),
        SnippetSection(
          id: 'usage',
          title: 'Usage',
          description:
              'The smallest correct chart: a config, a container, and one '
              'CartesianChart series. PieChart, RadarChart and '
              'RadialBarChart (chart-polar) construct the same way — data, '
              'a list of specs, the same ChartContainer.',
          code: _usageCode,
        ),
        DisclosureSection(
          id: 'api',
          title: 'API Reference',
          description:
              'The types a consumer actually touches building or theming a '
              'chart — not an exhaustive row per export. The scale, tick '
              'and path maths under all of this (chart-geometry) is '
              'documented in the source and the registry manifest, not '
              'enumerated here; see Dependencies below.',
          children: const <DocsTocEntry>[
            DocsTocEntry(title: 'ChartConfig', anchor: 'api-elchartconfig'),
            DocsTocEntry(
              title: 'ChartContainer',
              anchor: 'api-elchartcontainer',
            ),
            DocsTocEntry(
              title: 'ChartTooltipContent',
              anchor: 'api-elcharttooltipcontent',
            ),
            DocsTocEntry(
              title: 'ChartLegendContent',
              anchor: 'api-elchartlegendcontent',
            ),
            DocsTocEntry(
              title: 'CartesianChart',
              anchor: 'api-elcartesianchart',
            ),
            DocsTocEntry(
              title: 'ChartSeriesSpec',
              anchor: 'api-elchartseriesspec',
            ),
            DocsTocEntry(title: 'Axes & Grid', anchor: 'api-elaxesgrid'),
            DocsTocEntry(title: 'PieChart', anchor: 'api-elpiechart'),
            DocsTocEntry(title: 'RadarChart', anchor: 'api-elradarchart'),
            DocsTocEntry(
              title: 'RadialBarChart',
              anchor: 'api-elradialbarchart',
            ),
            DocsTocEntry(title: 'chartNumber', anchor: 'api-elchartnumber'),
          ],
          child: const _ApiReferenceContent(),
        ),
        DisclosureSection(
          id: 'states',
          title: 'States',
          description:
              'The chart family owns exactly one interactive state — which '
              'datum the pointer is over — and one caller-set one — which '
              'wedge or bar `activeIndex` names. Everything else below is '
              'configuration passed in at construction, never a state a '
              'widget reaches on its own.',
          child: DocsStateMatrix(facts: _stateFacts),
        ),
        DisclosureSection(
          id: 'accessibility',
          title: 'Accessibility',
          description:
              'Read straight off the source, all four files: no '
              '`Semantics` node anywhere in `chart.dart`, '
              '`chart_cartesian.dart`, `chart_geometry.dart` or '
              '`chart_polar.dart` — checked with '
              '`grep -rn "Semantics" lib/src/components/ui/chart*.dart`, '
              'zero matches.',
          child: const _AccessibilityContent(),
        ),
        DisclosureSection(
          id: 'keyboard',
          title: 'Keyboard',
          description:
              'No `FocusNode`, no `Focus` widget, no key handler anywhere '
              'in the family: none of `CartesianChart`, `PieChart`, '
              '`RadarChart` or `RadialBarChart` can take keyboard focus or '
              'answer a key.',
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
          description:
              'The one thing the owner asked for by name. Five tokens, '
              'read live off `ThemeScope.of(context)` at build time — '
              'change the theme and every chart on the page repaints with '
              'it, with no chart-specific configuration required.',
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
                value: entry.sourcePath,
                description:
                    'Authoritative implementation: the truth this page was '
                    'written from.',
              ),
              const DocsInstallFact(
                label: 'Wrapper source',
                value: 'lib/src/components/ui/chart.dart',
                description: 'ChartConfig, ChartContainer, tooltip, legend.',
              ),
              const DocsInstallFact(
                label: 'Cartesian engine source',
                value: 'lib/src/components/ui/chart_cartesian.dart',
                description: 'CartesianChart: area, bar, line.',
              ),
              const DocsInstallFact(
                label: 'Geometry source',
                value: 'lib/src/components/ui/chart_geometry.dart',
                description: 'Scale, tick and path maths.',
              ),
              const DocsInstallFact(
                label: 'Polar engine source',
                value: 'lib/src/components/ui/chart_polar.dart',
                description: 'PieChart, RadarChart, RadialBarChart.',
              ),
              const DocsInstallFact(
                label: 'Docs test',
                value: 'example/test/components_docs/chart_test.dart',
                description:
                    'Covers this consolidated page — mounted from each of '
                    'the four routes.',
              ),
              const DocsInstallFact(
                label: 'Edit these docs',
                value: 'example/lib/components_docs/chart/consolidated.dart',
                description: 'The shared page body every route renders.',
              ),
            ],
          ),
        ),
      ],
    );

/// The article frame every route wraps [buildChartFamilySpec]'s output in.
/// Identical across all four routes except the entry, the article key (for
/// tests to find their own route's mount) and the breadcrumb title.
class ChartFamilyDocPage extends StatelessWidget {
  const ChartFamilyDocPage({
    super.key,
    required this.entry,
    required this.spec,
    required this.articleKey,
    required this.breadcrumbTitle,
    this.onNavigate,
  });

  final ComponentDocEntry entry;
  final ComponentDocSpec spec;
  final String articleKey;
  final String breadcrumbTitle;
  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: entry.route,
    intro: DocsPageIntro(title: entry.title, description: entry.description),
    breadcrumbs: <BreadcrumbEntry>[
      const BreadcrumbEntry.link('Components'),
      BreadcrumbEntry.page(breadcrumbTitle),
    ],
    toc: spec.toc,
    // The four routes now render one body: chaining "next" from one to
    // another would send a reader who just read this page back to the same
    // page under a different URL. Each stands alone.
    previous: null,
    next: null,
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: ValueKey<String>(articleKey),
      child: ComponentDocPage(spec: spec, header: false),
    ),
  );
}

/* ── Preview / Usage ────────────────────────────────────────────────────── */

class _PreviewSpecimen extends StatelessWidget {
  const _PreviewSpecimen();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return KeyedSubtree(
      key: const ValueKey<String>('chart-family-preview:area'),
      child: ChartContainer(
        height: space(56),
        config: ChartConfig(<String, ChartSeries>{
          'desktop': ChartSeries(label: 'Desktop', color: theme.chart1),
          'mobile': ChartSeries(label: 'Mobile', color: theme.chart2),
        }),
        child: CartesianChart(
          data: _monthlyVisitors,
          xAxis: const ChartAxis(
            dataKey: 'month',
            tickLine: false,
            axisLine: false,
          ),
          legend: const ChartLegendSpec(),
          tooltip: const ChartTooltipSpec(defaultIndex: 3),
          series: <ChartSeriesSpec>[
            ChartSeriesSpec(
              kind: ChartSeriesKind.area,
              dataKey: 'mobile',
              curve: CurveType.natural,
              fill: theme.chart2,
              fillOpacity: 0.4,
              stroke: theme.chart2,
            ),
            ChartSeriesSpec(
              kind: ChartSeriesKind.area,
              dataKey: 'desktop',
              curve: CurveType.natural,
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

const String _previewCode =
    "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
    'ChartContainer(\n'
    "  config: ChartConfig({\n"
    "    'desktop': ChartSeries(label: 'Desktop', color: theme.chart1),\n"
    "    'mobile': ChartSeries(label: 'Mobile', color: theme.chart2),\n"
    '  }),\n'
    '  child: CartesianChart(\n'
    '    data: months,\n'
    "    xAxis: const ChartAxis(dataKey: 'month'),\n"
    '    legend: const ChartLegendSpec(),\n'
    '    series: [\n'
    "      ChartSeriesSpec(kind: ChartSeriesKind.area, dataKey: 'mobile', fill: theme.chart2, fillOpacity: 0.4, stroke: theme.chart2),\n"
    "      ChartSeriesSpec(kind: ChartSeriesKind.area, dataKey: 'desktop', fill: theme.chart1, fillOpacity: 0.4, stroke: theme.chart1),\n"
    '    ],\n'
    '  ),\n'
    ')';

const String _usageCode =
    "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
    "final config = ChartConfig({'value': ChartSeries(color: theme.chart1)});\n\n"
    'ChartContainer(\n'
    '  config: config,\n'
    '  child: CartesianChart(\n'
    "    data: [\n"
    "      {'x': 'Jan', 'value': 186},\n"
    "      {'x': 'Feb', 'value': 305},\n"
    '    ],\n'
    "    xAxis: const ChartAxis(dataKey: 'x'),\n"
    '    series: [\n'
    "      ChartSeriesSpec(kind: ChartSeriesKind.line, dataKey: 'value', stroke: theme.chart1),\n"
    '    ],\n'
    '  ),\n'
    ')';

/* ── API Reference ─────────────────────────────────────────────────────── */

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsAnchor(
        id: 'api-elchartconfig',
        child: DocsApiTable(title: 'ChartConfig', facts: _configFacts),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elchartcontainer',
        child: DocsApiTable(title: 'ChartContainer', facts: _containerFacts),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elcharttooltipcontent',
        child: DocsApiTable(
          title: 'ChartTooltipContent',
          facts: _tooltipContentFacts,
        ),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elchartlegendcontent',
        child: DocsApiTable(
          title: 'ChartLegendContent',
          facts: _legendContentFacts,
        ),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elcartesianchart',
        child: DocsApiTable(title: 'CartesianChart', facts: _cartesianFacts),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elchartseriesspec',
        child: DocsApiTable(
          title: 'ChartSeriesSpec',
          facts: _seriesSpecFacts,
        ),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elaxesgrid',
        child: DocsApiTable(title: 'Axes & Grid', facts: _axesGridFacts),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elpiechart',
        child: DocsApiTable(title: 'PieChart', facts: _pieChartFacts),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elradarchart',
        child: DocsApiTable(title: 'RadarChart', facts: _radarChartFacts),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elradialbarchart',
        child: DocsApiTable(
          title: 'RadialBarChart',
          facts: _radialBarChartFacts,
        ),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elchartnumber',
        child: DocsApiTable(title: 'chartNumber', facts: _numberFacts),
      ),
    ],
  );
}

const List<DocsApiFact> _configFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'ChartConfig(entries)',
    type: 'Map<String, ChartSeries>',
    description:
        'One series key mapped to its label and colour. ChartSeries '
        'carries label (String?), color (Color?, normally theme.chart1…5) '
        'and icon (WidgetBuilder?, rendered in place of a plain swatch).',
  ),
  DocsApiFact(
    name: 'resolve / labelFor / plus',
    type: '(methods)',
    description:
        'resolve(key, datum) looks a series up, falling back to the '
        'datum\'s own field for a Pie or RadialBar whose key is the value; '
        'labelFor(key) is the printed name, falling back to the key '
        'itself; plus(entries) returns a config with more entries merged '
        'in.',
  ),
];

const List<DocsApiFact> _containerFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'config',
    type: 'ChartConfig',
    description: 'Required. Threaded to every descendant via ChartScope.',
  ),
  DocsApiFact(
    name: 'child',
    type: 'Widget',
    description:
        'Required. The plot — CartesianChart or one of the three '
        'chart-polar widgets.',
  ),
  DocsApiFact(
    name: 'height / plotHeight',
    type: 'double? / double (static)',
    description:
        'height overrides plotHeight, the 256px default every plot mounts '
        'at unless told otherwise. Width always stretches to the parent.',
  ),
];

const List<DocsApiFact> _tooltipContentFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'items / label',
    type: 'List<ChartTooltipItem> / String?',
    description:
        'items is required — one row per series, each with name, value, '
        'color and the raw payload. label is the category header, e.g. a '
        'date.',
  ),
  DocsApiFact(
    name: 'indicator',
    type: 'ChartIndicator',
    description:
        'dot (default, a rounded square), line (a full-height bar), or '
        'dashed (the reference\'s own convention for a projected series).',
  ),
  DocsApiFact(
    name: 'hideLabel / hideIndicator',
    type: 'bool',
    description: 'Suppress the header row, or every row\'s mark. Both false.',
  ),
  DocsApiFact(
    name: 'formatter / labelFormatter / nameKey / labelKey / width',
    type: '(customisation)',
    description:
        'formatter replaces a row entirely; labelFormatter replaces just '
        'the header text; nameKey/labelKey redirect which config entry a '
        'row or the header reads; width fixes the panel instead of letting '
        'it float above minWidth (min-w-32).',
  ),
];

const List<DocsApiFact> _legendContentFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'items',
    type: 'List<ChartLegendItem>',
    description:
        'Required. Each item is a series key, with an optional colour or '
        'label override — the shape a Pie legend uses to show months '
        'rather than series.',
  ),
  DocsApiFact(
    name: 'verticalAlign',
    type: 'ChartLegendAlign',
    description: 'top or bottom (default).',
  ),
  DocsApiFact(
    name: 'wrap / gap / hideIcon',
    type: 'bool / double? / bool',
    description:
        'wrap reflows onto more than one line once it runs out of width '
        '(false draws a single Row that overflows silently instead); gap '
        'overrides the 4-token default spacing; hideIcon suppresses a '
        'series\' own icon builder.',
  ),
];

const List<DocsApiFact> _cartesianFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'data / series',
    type: 'List<Map<String, Object?>> / List<ChartSeriesSpec>',
    description: 'Both required. One row per datum, one spec per drawn shape.',
  ),
  DocsApiFact(
    name: 'xAxis / yAxis / grid',
    type: 'ChartAxis? / ChartAxis? / ChartGrid?',
    description:
        'Each null omits that element entirely and reserves no space for '
        'it — see Axes & Grid below.',
  ),
  DocsApiFact(
    name: 'legend / tooltip',
    type: 'ChartLegendSpec? / ChartTooltipSpec?',
    description:
        'Both null by default; either turns the corresponding feature on. '
        'ChartTooltipSpec.defaultIndex pins the panel open with no pointer '
        'over the chart — how a static specimen shows one at all.',
  ),
  DocsApiFact(
    name: 'layout / margin / stackOffsetExpand',
    type: 'ChartLayout / ChartMargin / bool',
    description:
        'layout: horizontal (default) or vertical — which axis the '
        'categories run along, independent of which way a bar points; '
        'margin defaults to ChartMargin.standard (5 on every side); '
        'stackOffsetExpand turns a stack into a 0…1 share rather than a '
        'running total.',
  ),
];

const List<DocsApiFact> _seriesSpecFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'kind / dataKey',
    type: 'ChartSeriesKind / String',
    description: 'Both required. area, bar, or line; the field it reads.',
  ),
  DocsApiFact(
    name: 'stroke / fill / fillOpacity / strokeWidth',
    type: 'Color? / Color? / double / double',
    description:
        'The line/border and fill colours. fillOpacity (default 1) is '
        'folded into fill by the caller, since opacity is not its own '
        'token family.',
  ),
  DocsApiFact(
    name: 'curve',
    type: 'CurveType',
    description:
        'linear (default), natural, monotone, or step — an area or line '
        'series only.',
  ),
  DocsApiFact(
    name: 'stackId',
    type: 'String?',
    description:
        'Any shared string stacks the series that carry it; the first '
        'declared draws at the bottom.',
  ),
  DocsApiFact(
    name: 'dot / radii / cellFills / labels / gradient',
    type: '(per-shape styling)',
    description:
        'dot draws a marker at every vertex of a line (null draws none); '
        'radii rounds a bar\'s four corners; cellFills overrides fill per '
        'datum; labels prints a value beside its own datum; gradient '
        'paints over fill when present.',
  ),
];

const List<DocsApiFact> _axesGridFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'ChartAxis(dataKey, type)',
    type: 'String? / ChartAxisType',
    description:
        'dataKey is the field each tick reads (a numbered axis without '
        'it); type is category (default) or number.',
  ),
  DocsApiFact(
    name: 'tickLine / axisLine / hide / tickFormatter',
    type: 'bool / bool / bool / Function?',
    description:
        'tickLine and axisLine (both default true) draw the tick stub '
        'and the axis rule; hide keeps the scale but drops the labels — '
        'what a chart reaches for when a tooltip already carries the '
        'number; tickFormatter overrides the printed text.',
  ),
  DocsApiFact(
    name: 'size / defaultXSize / defaultYSize',
    type: 'double? / 30 / 60',
    description:
        'An axis costs its own size out of the plot: 30px for X, 60px for '
        'Y, unless size overrides it.',
  ),
  DocsApiFact(
    name: 'ChartGrid(horizontal, vertical)',
    type: 'bool / bool',
    description:
        'Both default true. Rules draw at theme.border, 50% alpha — the '
        'sweep replacing recharts\' own untokenised grey.',
  ),
];

const List<DocsApiFact> _pieChartFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'pies',
    type: 'List<PieSpec>',
    description: 'Required. One or more concentric rings.',
  ),
  DocsApiFact(
    name: 'PieSpec(data, dataKey)',
    type: 'List<Map> / String',
    description:
        'Both required. dataKey is the field each wedge\'s sweep is '
        'proportional to; nameKey names a wedge in the tooltip and legend.',
  ),
  DocsApiFact(
    name: 'innerRadius / outerRadius',
    type: 'double? / double?',
    description:
        'Pixels, not a percentage. Null inner draws a full pie with no '
        'hole; null outer defaults to 80% of the plot\'s max radius — a '
        'donut is just a non-null innerRadius.',
  ),
  DocsApiFact(
    name: 'activeIndex / activeGrow / activeRing',
    type: 'int? / double / bool',
    description:
        'activeIndex names one wedge; activeGrow (extra outer radius) and '
        'activeRing (a second, detached ring) then style THAT wedge. '
        'Caller-set, never toggled by PieChart itself.',
  ),
  DocsApiFact(
    name: 'centerLabel / labelColor / outsideLabel',
    type: 'WidgetBuilder? / Color? / bool',
    description:
        "A donut's centred content (usually a total); labelColor exists "
        "because a wedge's own fill often fails as text — see "
        'Accessibility; outsideLabel draws the value outside the wedge '
        'with a leader line.',
  ),
];

const List<DocsApiFact> _radarChartFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'data / series',
    type: 'List<Map> / List<RadarSpec>',
    description: 'Both required.',
  ),
  DocsApiFact(
    name: 'grid / angleAxis / radiusAxis',
    type: 'PolarGrid? / PolarAngleAxis? / PolarRadiusAxis?',
    description:
        'Each null omits that element: no web, no category label around '
        'it, no value label along a spoke.',
  ),
  DocsApiFact(
    name: 'RadarSpec(dataKey, fill, stroke, dot)',
    type: 'String / Color? / Color? / ChartDotSpec?',
    description:
        'fillOpacity defaults to 1 — two overlapping radars need at least '
        'one translucent series or the second erases the first. dot draws '
        'a marker at every vertex; null draws none.',
  ),
];

const List<DocsApiFact> _radialBarChartFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'data / series',
    type: 'List<Map> / List<RadialBarSpec>',
    description: 'Both required.',
  ),
  DocsApiFact(
    name: 'innerRadius / outerRadius',
    type: 'double / double',
    description: 'Both required, in pixels — unlike PieSpec, neither infers.',
  ),
  DocsApiFact(
    name: 'startAngle / endAngle',
    type: 'double / double',
    description:
        'Degrees, counter-clockwise from three o\'clock — the convention '
        'every chart-polar widget shares. Defaults 0 and 360.',
  ),
  DocsApiFact(
    name: 'RadialBarSpec(dataKey, fill, background)',
    type: 'String / Color? / bool',
    description:
        'Null fill reads each row\'s own fill field; background (default '
        'false) draws the unfilled remainder of the ring in theme.muted.',
  ),
];

const List<DocsApiFact> _numberFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'chartNumber(value)',
    type: 'num → String',
    description:
        "Number.prototype.toLocaleString() in en-US: grouped thousands, a "
        'true minus sign for a negative value, at most three fraction '
        'digits with trailing zeros trimmed. Every figure a chart on this '
        'page prints — a tooltip value, a donut\'s centred total — goes '
        'through this one function.',
  ),
];

/* ── States / Accessibility / Keyboard / Responsive ────────────────────── */

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Hover',
    treatment:
        'CartesianChart answers MouseRegion.onHover by picking the '
        'nearest datum and repainting its tooltip and cursor highlight. '
        'None of the three chart-polar widgets wires a MouseRegion or '
        'GestureDetector of their own.',
    userSignal:
        'The tooltip panel, cursor band (Cartesian) or pinned defaultIndex '
        '(any family) — see Preview and the /charts gallery for a live '
        'hover.',
  ),
  DocsStateFact(
    state: 'activeIndex / activeGrow / activeRing',
    treatment:
        'PieSpec names one wedge; activeGrow and activeRing then change '
        'how that wedge alone paints.',
    userSignal: 'Caller-set — there is no hover-to-activate wiring in the '
        'source.',
  ),
  DocsStateFact(
    state: 'Entrance animation',
    treatment:
        'Every plot widget owns one AnimationController, driven by '
        'ChartMotion.duration/curve, and passes its progress into its own '
        'painter: an area or bar grows from its baseline, a pie sweeps its '
        'own angle, a radar polygon and a radial arc grow toward their '
        'final value.',
    userSignal: 'Purely visual; no datum is added or removed by it.',
  ),
];

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Every wedge, spoke, bar and area is one CustomPaint; every label '
            'is a plain StyledText. No accessible role, name, or '
            'live-region marker anywhere in the family.',
        'Colour is the only signal separating two series, two wedges or '
            'two rings when a legend is absent — there is no pattern or '
            'texture difference beyond the caller\'s own fill.',
        "PieChart.labelColor exists specifically because a wedge's own "
            "fill fails as text: chart-1's measured relative luminance "
            '(0.179) sits within a thousandth of the value at which black '
            'and white read equally, so 4.58:1 is the ceiling for any ink '
            'on it, in either theme — a label reads on the panel '
            'background instead.',
      ]);
}

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) => _bullets(ThemeScope.of(context), <
    String
  >[
    'No FocusNode, no Focus widget, no key handling in any of the four '
        'files. None of ChartTooltipContent, ChartLegendContent, '
        'CartesianChart, PieChart, RadarChart or RadialBarChart can take '
        'keyboard focus, and none answers a key.',
  ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'ChartContainer stretches to whatever width its parent offers '
            'and holds a fixed height (plotHeight, 256) unless overridden. '
            'No breakpoint branching anywhere in the family.',
        'Every plot widget reads its own size from a LayoutBuilder and '
            'recomputes its layout on every build rather than caching one '
            'across a resize — which is what makes a chart resize '
            'correctly at all.',
        'ChartTooltipContent grows with its content (minWidth is a floor, '
            'not a fixed size); ChartLegendContent reflows onto more than '
            'one line only when wrap: true is passed.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      _bullets(ThemeScope.of(context), <String>[
        'Four files, no companions beyond each other: chart.dart, '
            'chart_cartesian.dart, chart_geometry.dart, chart_polar.dart, '
            'each the registry manifest\'s own single "files" entry.',
        'Flutter imports across all four: package:flutter/widgets.dart '
            'only. No package:flutter/material.dart anywhere in the '
            'family.',
        'chart-geometry has zero registryDependencies and zero Flutter or '
            'theme import — the one file in the family with no colour, '
            'shadow or type-role dependency of its own. chart-cartesian '
            'and chart-polar both depend on it for scale, tick and path '
            'maths (BandScale, PointScale, LinearScale, curvePath, '
            'areaPath, polarToCartesian, sectorPath, sectorWithCornerPath, '
            'polarPolygonPath) — not reproduced here; see the source and '
            'registry/components/chart-geometry.json.',
        'chart-polar depends on chart, chart-cartesian and '
            'chart-geometry — its label-chip radial-bar geometry reuses '
            "chart-cartesian's own barSlots.",
        'No series colour is read from the theme by any of the four '
            'files themselves: every fill and stroke a plot paints is '
            'supplied by the caller, normally one of theme.chart1…5.',
      ]),
      SizedBox(height: space(4)),
      const DocsLinkRow(
        links: <DocsLink>[
          DocsLink(label: 'Charts gallery — 70 copyable charts', route: '/charts'),
        ],
      ),
    ],
  );
}

class _ThemingContent extends StatelessWidget {
  const _ThemingContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'theme.chart1 … theme.chart5 — the five series colours every '
            'specimen on this page and every chart in the /charts gallery '
            'draws from. Nothing in the four source files reads them for '
            'you: a caller supplies one to ChartSeries.color, or directly '
            'to a spec\'s fill/stroke. Change the five tokens on '
            'ThemeTokens (light and dark both carry their own set) and '
            'every chart in the app repaints with the new palette, with no '
            'chart-specific configuration anywhere.',
        'Structural colour, read live off ThemeScope.of(context) at build '
            'time rather than cached: theme.border (grid rules, axis '
            'lines, and the polar family\'s grid rings/spokes, all at 50% '
            'alpha), theme.muted (the Cartesian hover-cursor band and a '
            'radial bar\'s own unfilled background arc), theme.mutedForeground '
            '/ theme.foreground (axis tick labels and printed values), '
            'theme.background (the tooltip panel\'s fill, and a pie '
            'wedge\'s separator stroke, in place of recharts\' own fixed '
            'stroke="#fff"), and theme.card + theme.cardForeground (the '
            'radial family\'s arc label chip — the same pairing every Card '
            'already uses, measured 16.97:1 dark and 19.90:1 light).',
        'Motion: ChartMotion.duration is MotionDurations.slow; '
            'ChartMotion.curve is MotionCurves.decelerate rather than '
            'MotionCurves.enter — a documented drift, not an oversight. '
            'recharts can only receive the CSS keyword ease-out '
            '(cubic-bezier(0,0,0.58,1)), a visibly different curve from '
            'the design system\'s own MotionCurves.enter; reproducing the '
            'reference means reproducing that curve rather than "fixing" '
            'it. Both tokens drive every entrance animation across all '
            'three engines.',
        'Type: every label the family draws is ChartText.xs (12px/16px), '
            'xsMedium (the tooltip header, weight 500) or xsTight (the '
            'tooltip\'s series name, leading-none) — never a `.type-*` '
            'rung off the type scale. These three live in chart.dart '
            'itself rather than in foundation/typography.dart because, as '
            'the source says, they are component roles, not rungs of the '
            'type scale. ChartContainer sets the xs face as a '
            'DefaultTextStyle over its whole subtree, which is why every '
            'label a plot draws inherits it without asking by name.',
        'Elevation: the tooltip panel\'s shadow is Shadows.dataTooltip, a '
            'fixed token — there is no separate "open" or "pinned" '
            'elevation state.',
      ]);
}

Widget _bullets(ThemeTokens theme, List<String> lines) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: <Widget>[
    for (final String line in lines) ...<Widget>[
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: LayoutWidths.prose),
        child: StyledText(
          '•  $line',
          TextStyles.small,
          color: theme.mutedForeground,
        ),
      ),
      SizedBox(height: space(2)),
    ],
  ],
);
