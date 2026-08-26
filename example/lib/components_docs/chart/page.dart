/// Public documentation page for the `chart` component.
///
/// **A wrapper, not a plot.** `chart.dart` is `components/ui/chart.tsx`, the
/// official shadcn wrapper, ported: a themed [ElChartConfig], the
/// fixed-height [ElChartContainer] every plot mounts inside, the hover
/// [ElChartTooltipContent] panel, the [ElChartLegendContent] row, and
/// [elChartNumber], the one grouped-thousands formatter every chart figure
/// goes through. It draws no axis, no bar, no wedge — that is
/// `chart-cartesian` and `chart-polar`, both of which import this file and
/// wrap their own painted geometry in [ElChartContainer]. Every specimen
/// below is one of the five pieces this file actually owns, composed without
/// a real plot behind it.
///
/// **Section order.** Preview, Installation, Usage, then one section per
/// facet the wrapper owns: Container (the fixed-height box and its
/// `text-xs` cascade), Tooltip (the three [ElChartIndicator] styles),
/// Legend (row vs wrapped, and the two [ElChartLegendAlign] positions), and
/// Number formatting ([elChartNumber]'s grouped-thousands rule) — then the
/// eight standing disclosures.
///
/// **Read, not inferred.** Every claim here traces to a line in
/// `lib/src/components/chart.dart`. In particular: this file wires no
/// `Semantics` node, no `FocusNode`, and no keyboard handling anywhere —
/// checked with `grep -n "Semantics\|FocusNode" lib/src/components/chart.dart`,
/// zero matches — so Accessibility and Keyboard both say so rather than
/// inventing a story chart.dart does not tell.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/component_doc_page.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../docs/docs_section.dart' show DocsAnchor;
import '../chart_cartesian/meta.dart' as chart_cartesian;
import 'meta.dart';

/// The declaration: every section this page shows, in TOC order. `final`,
/// not `const`: `InstallSection.command` reads `chartDoc.command`, a computed
/// getter, not a constant expression.
final ComponentDocSpec chartDocSpec = ComponentDocSpec(
  name: 'chart',
  title: 'Chart',
  description: chartDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'The tooltip panel and the legend row, threaded through one '
          '`ElChartScope` so both resolve their colours and labels from the '
          'same `ElChartConfig` — the composition every real plot on the '
          'page builds on top of.',
      specimen: const _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
      minHeight: el(160),
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'chart has a real registry manifest, `elattar add chart` installs '
          'lib/src/components/chart.dart and resolves its one '
          'registryDependency, source-foundation, automatically. The Manual '
          'tab is for a project not using the CLI.',
      command: chartDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/chart.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/chart.dart's generated "
              '@ui/chart.dart payload into components/ui.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated chart source here when using manual '
              'mode.',
        ),
        DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so ElChartConfig, ElChartContainer and '
              'the rest are reachable the same way the CLI path already '
              'makes them.',
          code: "export 'chart.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'The smallest correct import and construction: a config, and a '
          'container that mounts it. `chart-cartesian` and `chart-polar` '
          "put a real plot in the container's child; this file does not "
          'supply one.',
      code: _usageCode,
    ),
    ShowcaseSection(
      id: 'container',
      title: 'Container',
      description:
          "ElChartContainer fixes its height at plotHeight (256, the 8-point "
          "grid's own el(64)) unless height overrides it, stretches to "
          "whatever width its parent offers, and wraps its child in a "
          "DefaultTextStyle at ElChartText.xs — text-xs, 12px/16px — which "
          "is why every label a plot draws (axis ticks, legend keys, "
          "tooltip rows) inherits the same small face without asking for it "
          "by name.",
      specimen: const _ContainerSpecimen(),
      code: _containerCode,
      label: 'Container specimen view',
      minHeight: el(160),
    ),
    ShowcaseSection(
      id: 'tooltip',
      title: 'Tooltip',
      description:
          "ElChartTooltipContent's three ElChartIndicator styles: dot (the "
          'default, a rounded 10px square), line (a full-height bar, cosmetic '
          'only), and dashed (the reference\'s own convention for a '
          'projected series — "do not spend it on a plain second series").',
      specimen: const _TooltipSpecimen(),
      code: _tooltipCode,
      label: 'Tooltip specimen view',
      minHeight: el(160),
    ),
    ShowcaseSection(
      id: 'legend',
      title: 'Legend',
      description:
          'ElChartLegendContent as a single centred row (the default, '
          'gap-4) and as a wrapped row (wrap: true, the shape PieLegend '
          'reaches for when a fourth or fifth key would overflow one line).',
      specimen: const _LegendSpecimen(),
      code: _legendCode,
      label: 'Legend specimen view',
      minHeight: el(160),
    ),
    ShowcaseSection(
      id: 'number-formatting',
      title: 'Number formatting',
      description:
          "elChartNumber — en-US grouped thousands, negatives spelled with a "
          'true minus sign rather than a hyphen, decimals trimmed to at most '
          'three digits with trailing zeros dropped. Every figure a chart on '
          'this page prints, a tooltip value, a donut\'s centred total, goes '
          'through this one function.',
      specimen: const _NumberFormattingSpecimen(),
      code: _numberFormattingCode,
      label: 'Number formatting specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every constructor parameter each exported class declares, every '
          'ElChartIndicator and ElChartLegendAlign value, ElChartText\'s own '
          'three type roles, and elChartNumber\'s own signature: one table '
          'per exported class, enum, or function.',
      children: const <DocsTocEntry>[
        DocsTocEntry(title: 'ElChartConfig', anchor: 'api-elchartconfig'),
        DocsTocEntry(title: 'ElChartSeries', anchor: 'api-elchartseries'),
        DocsTocEntry(title: 'ElChartScope', anchor: 'api-elchartscope'),
        DocsTocEntry(title: 'ElChartMotion', anchor: 'api-elchartmotion'),
        DocsTocEntry(title: 'ElChartContainer', anchor: 'api-elchartcontainer'),
        DocsTocEntry(
          title: 'ElChartTooltipItem',
          anchor: 'api-elcharttooltipitem',
        ),
        DocsTocEntry(
          title: 'ElChartTooltipContent',
          anchor: 'api-elcharttooltipcontent',
        ),
        DocsTocEntry(title: 'ElChartLegendItem', anchor: 'api-elchartlegenditem'),
        DocsTocEntry(
          title: 'ElChartLegendContent',
          anchor: 'api-elchartlegendcontent',
        ),
        DocsTocEntry(title: 'ElChartIndicator', anchor: 'api-elchartindicator'),
        DocsTocEntry(title: 'ElChartLegendAlign', anchor: 'api-elchartlegendalign'),
        DocsTocEntry(title: 'ElChartText', anchor: 'api-elcharttext'),
        DocsTocEntry(title: 'elChartNumber', anchor: 'api-elchartnumber'),
      ],
      child: const _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'chart.dart draws nothing interactive of its own: what varies '
          'below is configuration the caller passes in, not a state the '
          'widget reaches on its own. Hover and active-index belong to '
          'ElCartesianChart and ElPieChart in chart-cartesian and '
          'chart-polar.',
      child: DocsStateMatrix(facts: _stateFacts),
    ),
    DisclosureSection(
      id: 'accessibility',
      title: 'Accessibility',
      description:
          'Read straight off the source: chart.dart wires no `Semantics` '
          'node anywhere in the file.',
      child: const _AccessibilityContent(),
    ),
    DisclosureSection(
      id: 'keyboard',
      title: 'Keyboard',
      description:
          'chart.dart takes no focus and handles no key: it is presentation '
          'only.',
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
            value: chartDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/chart_test.dart',
            description:
                'Covers this page: the article mounts, every exported '
                'class and enum this page claims to document, the full API '
                'table, and both themes at two viewport widths.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/chart/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class ChartDocPage extends StatelessWidget {
  const ChartDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: chartDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / BASE',
      title: chartDoc.title,
      description: chartDoc.description,
    ),
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Components'),
      ElBreadcrumbEntry.page('Chart'),
    ],
    toc: chartDocSpec.toc,
    previous: null,
    next: DocsPageLink(
      title: chart_cartesian.chartCartesianDoc.title,
      route: chart_cartesian.chartCartesianDoc.route,
    ),
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('chart-doc-article'),
      child: ComponentDocPage(spec: chartDocSpec, header: false),
    ),
  );
}

/* ── Showcase specimens ─────────────────────────────────────────────────── */

/// `_sportDays`' first row, the shape `pages/charts.dart` already reuses for
/// every tooltip specimen on the hand-composed charts page.
const List<ElChartTooltipItem> _previewItems = <ElChartTooltipItem>[
  ElChartTooltipItem(name: 'running', dataKey: 'running', value: 450),
  ElChartTooltipItem(name: 'swimming', dataKey: 'swimming', value: 300),
];

class _PreviewSpecimen extends StatelessWidget {
  const _PreviewSpecimen();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    final ElChartConfig config = ElChartConfig(<String, ElChartSeries>{
      'running': ElChartSeries(label: 'Running', color: theme.chart1),
      'swimming': ElChartSeries(label: 'Swimming', color: theme.chart2),
    });
    return ElChartScope(
      config: config,
      child: Wrap(
        spacing: el(6),
        runSpacing: el(6),
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          KeyedSubtree(
            key: const ValueKey<String>('chart-preview:tooltip'),
            child: const ElChartTooltipContent(
              label: 'Jul 15, 2024',
              items: _previewItems,
            ),
          ),
          KeyedSubtree(
            key: const ValueKey<String>('chart-preview:legend'),
            child: const ElChartLegendContent(
              items: <ElChartLegendItem>[
                ElChartLegendItem(name: 'running'),
                ElChartLegendItem(name: 'swimming'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

const String _previewCode =
    "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
    'final config = ElChartConfig({\n'
    "  'running': ElChartSeries(label: 'Running', color: theme.chart1),\n"
    "  'swimming': ElChartSeries(label: 'Swimming', color: theme.chart2),\n"
    '});\n\n'
    'ElChartScope(\n'
    '  config: config,\n'
    '  child: Row(\n'
    '    children: [\n'
    '      ElChartTooltipContent(\n'
    "        label: 'Jul 15, 2024',\n"
    '        items: [\n'
    "          ElChartTooltipItem(name: 'running', dataKey: 'running', value: 450),\n"
    "          ElChartTooltipItem(name: 'swimming', dataKey: 'swimming', value: 300),\n"
    '        ],\n'
    '      ),\n'
    '      ElChartLegendContent(\n'
    '        items: [\n'
    "          ElChartLegendItem(name: 'running'),\n"
    "          ElChartLegendItem(name: 'swimming'),\n"
    '        ],\n'
    '      ),\n'
    '    ],\n'
    '  ),\n'
    ')';

const String _usageCode =
    "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
    'ElChartContainer(\n'
    '  config: const ElChartConfig({}),\n'
    "  child: Text('a real plot from chart-cartesian or chart-polar goes here'),\n"
    ')';

class _ContainerSpecimen extends StatelessWidget {
  const _ContainerSpecimen();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    Widget box(String label) => DecoratedBox(
      decoration: BoxDecoration(
        color: theme.muted,
        borderRadius: BorderRadius.circular(ElRadii.md),
      ),
      child: Center(child: Text(label)),
    );
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        KeyedSubtree(
          key: const ValueKey<String>('chart-example:container-default'),
          child: SizedBox(
            width: el(48),
            child: ElChartContainer(
              config: const ElChartConfig(<String, ElChartSeries>{}),
              child: box('text-xs, height 256'),
            ),
          ),
        ),
        SizedBox(width: el(6)),
        KeyedSubtree(
          key: const ValueKey<String>('chart-example:container-custom-height'),
          child: SizedBox(
            width: el(48),
            child: ElChartContainer(
              height: el(32),
              config: const ElChartConfig(<String, ElChartSeries>{}),
              child: box('height: 128'),
            ),
          ),
        ),
      ],
      ),
    );
  }
}

const String _containerCode =
    "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
    'ElChartContainer(\n'
    '  config: const ElChartConfig({}),\n'
    "  child: Text('text-xs, inherited'), // height defaults to plotHeight, 256\n"
    ')\n\n'
    'ElChartContainer(\n'
    '  height: 128,\n'
    '  config: const ElChartConfig({}),\n'
    "  child: Text('a shorter container'),\n"
    ')';

class _TooltipSpecimen extends StatelessWidget {
  const _TooltipSpecimen();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    final ElChartConfig config = ElChartConfig(<String, ElChartSeries>{
      'running': ElChartSeries(label: 'Running', color: theme.chart1),
      'swimming': ElChartSeries(label: 'Swimming', color: theme.chart2),
    });
    return ElChartScope(
      config: config,
      child: Wrap(
        spacing: el(6),
        runSpacing: el(6),
        children: <Widget>[
          KeyedSubtree(
            key: const ValueKey<String>('chart-example:tooltip-dot'),
            child: const ElChartTooltipContent(
              label: 'Jul 15',
              items: _previewItems,
            ),
          ),
          KeyedSubtree(
            key: const ValueKey<String>('chart-example:tooltip-line'),
            child: const ElChartTooltipContent(
              label: 'Jul 15',
              items: _previewItems,
              indicator: ElChartIndicator.line,
            ),
          ),
          KeyedSubtree(
            key: const ValueKey<String>('chart-example:tooltip-dashed'),
            child: const ElChartTooltipContent(
              label: 'Jul 15',
              items: _previewItems,
              indicator: ElChartIndicator.dashed,
            ),
          ),
        ],
      ),
    );
  }
}

const String _tooltipCode =
    'ElChartTooltipContent(\n'
    "  label: 'Jul 15',\n"
    '  items: items,\n'
    '  indicator: ElChartIndicator.dashed, // dot | line | dashed\n'
    ')';

class _LegendSpecimen extends StatelessWidget {
  const _LegendSpecimen();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    final ElChartConfig config = ElChartConfig(<String, ElChartSeries>{
      'chrome': ElChartSeries(label: 'Chrome', color: theme.chart1),
      'safari': ElChartSeries(label: 'Safari', color: theme.chart2),
      'firefox': ElChartSeries(label: 'Firefox', color: theme.chart3),
      'edge': ElChartSeries(label: 'Edge', color: theme.chart4),
      'other': ElChartSeries(label: 'Other', color: theme.chart5),
    });
    return ElChartScope(
      config: config,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          KeyedSubtree(
            key: const ValueKey<String>('chart-example:legend-row'),
            child: const ElChartLegendContent(
              items: <ElChartLegendItem>[
                ElChartLegendItem(name: 'chrome'),
                ElChartLegendItem(name: 'safari'),
                ElChartLegendItem(name: 'firefox'),
              ],
            ),
          ),
          SizedBox(height: el(4)),
          KeyedSubtree(
            key: const ValueKey<String>('chart-example:legend-wrap'),
            child: ElChartLegendContent(
              wrap: true,
              gap: el(2),
              items: const <ElChartLegendItem>[
                ElChartLegendItem(name: 'chrome'),
                ElChartLegendItem(name: 'safari'),
                ElChartLegendItem(name: 'firefox'),
                ElChartLegendItem(name: 'edge'),
                ElChartLegendItem(name: 'other'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

const String _legendCode =
    'ElChartLegendContent(\n'
    '  wrap: true, // PieLegend\'s own shape: gap-2 instead of the gap-4 default\n'
    '  gap: 8,\n'
    '  items: [\n'
    "    ElChartLegendItem(name: 'chrome'),\n"
    "    ElChartLegendItem(name: 'safari'),\n"
    "    ElChartLegendItem(name: 'firefox'),\n"
    "    ElChartLegendItem(name: 'edge'),\n"
    "    ElChartLegendItem(name: 'other'),\n"
    '  ],\n'
    ')';

class _NumberFormattingSpecimen extends StatelessWidget {
  const _NumberFormattingSpecimen();

  static const List<num> _values = <num>[275, 1234, -42, 1000000, 12.5];

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Wrap(
      spacing: el(6),
      runSpacing: el(2),
      children: <Widget>[
        for (final num v in _values)
          KeyedSubtree(
            key: ValueKey<String>('chart-example:number-formatting-$v'),
            child: ElText(
              'elChartNumber($v) → ${elChartNumber(v)}',
              ElType.code,
              color: theme.foreground,
            ),
          ),
      ],
    );
  }
}

const String _numberFormattingCode =
    "elChartNumber(275)     // '275'\n"
    "elChartNumber(1234)    // '1,234'\n"
    "elChartNumber(-42)     // '−42'\n"
    "elChartNumber(1000000) // '1,000,000'\n"
    "elChartNumber(12.5)    // '12.5'";

/* ── Disclosure content ─────────────────────────────────────────────────── */

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsAnchor(
        id: 'api-elchartconfig',
        child: DocsApiTable(title: 'ElChartConfig', facts: _configFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elchartseries',
        child: DocsApiTable(title: 'ElChartSeries', facts: _seriesFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elchartscope',
        child: DocsApiTable(title: 'ElChartScope', facts: _scopeFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elchartmotion',
        child: DocsApiTable(title: 'ElChartMotion', facts: _motionFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elchartcontainer',
        child: DocsApiTable(title: 'ElChartContainer', facts: _containerFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elcharttooltipitem',
        child: DocsApiTable(
          title: 'ElChartTooltipItem',
          facts: _tooltipItemFacts,
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elcharttooltipcontent',
        child: DocsApiTable(
          title: 'ElChartTooltipContent',
          facts: _tooltipContentFacts,
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elchartlegenditem',
        child: DocsApiTable(title: 'ElChartLegendItem', facts: _legendItemFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elchartlegendcontent',
        child: DocsApiTable(
          title: 'ElChartLegendContent',
          facts: _legendContentFacts,
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elchartindicator',
        child: DocsApiTable(title: 'ElChartIndicator', facts: _indicatorFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elchartlegendalign',
        child: DocsApiTable(
          title: 'ElChartLegendAlign',
          facts: _legendAlignFacts,
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elcharttext',
        child: DocsApiTable(title: 'ElChartText', facts: _chartTextFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elchartnumber',
        child: DocsApiTable(title: 'elChartNumber', facts: _numberFacts),
      ),
    ],
  );
}

const List<DocsApiFact> _configFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'entries',
    type: 'Map<String, ElChartSeries>',
    description:
        'The constructor\'s one positional parameter. Every series key '
        'mapped to its label and colour — "the one piece of a chart that is '
        'worth writing before the chart itself."',
  ),
  DocsApiFact(
    name: 'operator []',
    type: 'ElChartSeries? Function(String)',
    description: 'Looks a key up directly, config[key].',
  ),
  DocsApiFact(
    name: 'resolve',
    type: 'ElChartSeries? Function(String, Map<String, Object?>?)',
    description:
        'getPayloadConfigFromPayload — checks the datum\'s own value at '
        'key first (for a Pie or RadialBar, whose key is the value and '
        'whose name lives on the row) and falls back to the key itself.',
  ),
  DocsApiFact(
    name: 'labelFor',
    type: 'String Function(String, [Map<String, Object?>?])',
    description: 'The label to print for a key, falling back to the key.',
  ),
  DocsApiFact(
    name: 'plus',
    type: 'ElChartConfig Function(Map<String, ElChartSeries>)',
    description:
        'A config with the extra entries merged over it — the '
        '"{...DESKTOP_MOBILE_CONFIG, other: {...}}" spread the reference '
        'uses to add one key.',
  ),
];

const List<DocsApiFact> _seriesFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'label',
    type: 'String?',
    description:
        'The human name a tooltip row and a legend key print. Without it a '
        "tooltip row falls back to the series' own data key.",
  ),
  DocsApiFact(
    name: 'color',
    type: 'Color?',
    description:
        "The series' own colour — always one of theme.chart1…5 at a real "
        'call site; null for a value key like visitors, which carries the '
        'axis label and deliberately has no colour of its own.',
  ),
  DocsApiFact(
    name: 'icon',
    type: 'WidgetBuilder?',
    description:
        "Rendered in the tooltip's indicator slot and the legend's swatch "
        "slot when present, in place of the plain coloured mark. Every real "
        'call site fills it with ElIcon.',
  ),
];

const List<DocsApiFact> _scopeFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'config',
    type: 'ElChartConfig',
    description:
        'Threaded down through InheritedWidget to whatever renders inside '
        'ElChartContainer.',
  ),
  DocsApiFact(name: 'child', type: 'Widget', description: 'Required.'),
  DocsApiFact(
    name: 'ElChartScope.of',
    type: 'ElChartConfig Function(BuildContext)',
    description:
        'useChart() — throws in the reference when there is no container; '
        'here it returns an empty config instead, so a widget test that '
        'mounts a tooltip on its own is legitimate.',
  ),
];

const List<DocsApiFact> _motionFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'duration',
    type: 'Duration (static getter)',
    description:
        'ElDurations.slow — --duration-slow, as useChartMotion reads it. '
        'chart-cartesian and chart-polar both read this for their entrance '
        'AnimationController.',
  ),
  DocsApiFact(
    name: 'curve',
    type: 'Curve (static getter)',
    description:
        'ElCurves.cssEaseOut, not ElCurves.out. Documented drift: recharts '
        'can only receive the CSS keyword "ease-out" '
        '(cubic-bezier(0,0,0.58,1)), a visibly different curve from the '
        'design system\'s own ElCurves.out. Reproducing the reference '
        'means reproducing that failure rather than "fixing" it.',
  ),
];

const List<DocsApiFact> _containerFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'config',
    type: 'ElChartConfig',
    description: 'Required. Threaded down via ElChartScope.',
  ),
  DocsApiFact(
    name: 'child',
    type: 'Widget',
    description:
        'Required. The plot — usually ElCartesianChart or one of the three '
        'chart-polar widgets.',
  ),
  DocsApiFact(
    name: 'height',
    type: 'double?',
    description: 'Overrides plotHeight, the 256px default.',
  ),
  DocsApiFact(
    name: 'plotHeight',
    type: 'double (static getter)',
    description:
        "h-64 — PLOT's own 256, and the number a loading skeleton is asked "
        'to match.',
  ),
];

const List<DocsApiFact> _tooltipItemFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'name',
    type: 'String',
    description: "Required. The series key — the row's own name field.",
  ),
  DocsApiFact(
    name: 'value',
    type: 'num?',
    description: 'The number the row prints, through elChartNumber.',
  ),
  DocsApiFact(
    name: 'color',
    type: 'Color?',
    description: "item.payload.fill ?? item.color — the indicator's colour.",
  ),
  DocsApiFact(
    name: 'payload',
    type: 'Map<String, Object?>?',
    description:
        'The whole row, for a formatter that needs its siblings — a '
        '"Total" line that reads two fields at once.',
  ),
  DocsApiFact(
    name: 'dataKey',
    type: 'String?',
    description: "Which field of the datum this row came from.",
  ),
];

const List<DocsApiFact> _tooltipContentFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'config',
    type: 'ElChartConfig?',
    description:
        'Normally read from ElChartScope; passed directly only by a test '
        'or a page-local label chip.',
  ),
  DocsApiFact(
    name: 'label',
    type: 'String?',
    description: 'The category under the cursor — a month, an ISO date.',
  ),
  DocsApiFact(name: 'items', type: 'List<ElChartTooltipItem>', description: 'Required.'),
  DocsApiFact(
    name: 'indicator',
    type: 'ElChartIndicator',
    description: 'dot (default), line, or dashed.',
  ),
  DocsApiFact(
    name: 'hideLabel',
    type: 'bool',
    description: 'Suppresses the header row. Default false.',
  ),
  DocsApiFact(
    name: 'hideIndicator',
    type: 'bool',
    description: 'Suppresses the coloured mark on every row. Default false.',
  ),
  DocsApiFact(
    name: 'labelFormatter',
    type: 'String Function(String, List<ElChartTooltipItem>)?',
    description: 'Replaces the header row\'s text.',
  ),
  DocsApiFact(
    name: 'formatter',
    type: 'Widget Function(BuildContext, ElChartTooltipItem, int)?',
    description:
        'Replaces a row entirely, in place of the built-in '
        'indicator/name/value trio.',
  ),
  DocsApiFact(
    name: 'nameKey',
    type: 'String?',
    description: "Which config key to look a row's name up under.",
  ),
  DocsApiFact(
    name: 'labelKey',
    type: 'String?',
    description: 'Which config key to look the header up under.',
  ),
  DocsApiFact(
    name: 'width',
    type: 'double?',
    description: 'Overrides minWidth with a fixed panel width.',
  ),
  DocsApiFact(
    name: 'minWidth',
    type: 'double (static getter)',
    description: 'min-w-32 — the panel\'s own floor.',
  ),
];

const List<DocsApiFact> _legendItemFacts = <DocsApiFact>[
  DocsApiFact(name: 'name', type: 'String', description: 'Required. The series key.'),
  DocsApiFact(name: 'color', type: 'Color?', description: 'Overrides the config lookup.'),
  DocsApiFact(
    name: 'label',
    type: 'String?',
    description:
        'Overrides the config lookup for the printed text — PieLegend '
        "passes nameKey: 'browser' and the rows are months rather than "
        'series.',
  ),
];

const List<DocsApiFact> _legendContentFacts = <DocsApiFact>[
  DocsApiFact(name: 'config', type: 'ElChartConfig?', description: 'Falls back to ElChartScope.of.'),
  DocsApiFact(name: 'items', type: 'List<ElChartLegendItem>', description: 'Required.'),
  DocsApiFact(
    name: 'verticalAlign',
    type: 'ElChartLegendAlign',
    description: 'top or bottom. Default bottom.',
  ),
  DocsApiFact(
    name: 'hideIcon',
    type: 'bool',
    description: "Suppresses itemConfig.icon. Default false.",
  ),
  DocsApiFact(
    name: 'wrap',
    type: 'bool',
    description: "flex-wrap — PieLegend's own shape, for four keys on two lines.",
  ),
  DocsApiFact(
    name: 'gap',
    type: 'double?',
    description: 'Overrides gap-4, the default spacing between keys.',
  ),
  DocsApiFact(
    name: 'swatchSize',
    type: 'double (static getter)',
    description: 'h-2 w-2 rounded-xs — the swatch.',
  ),
];

const List<DocsApiFact> _indicatorFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'dot',
    type: 'ElChartIndicator',
    description: 'The default — a rounded 10px square.',
  ),
  DocsApiFact(
    name: 'line',
    type: 'ElChartIndicator',
    description: 'A full-height bar beside the row. Cosmetic only.',
  ),
  DocsApiFact(
    name: 'dashed',
    type: 'ElChartIndicator',
    description:
        'The reference\'s own convention for a projection: "do not spend '
        'it on a plain second series."',
  ),
];

const List<DocsApiFact> _legendAlignFacts = <DocsApiFact>[
  DocsApiFact(name: 'top', type: 'ElChartLegendAlign', description: 'pb-3 below the legend.'),
  DocsApiFact(name: 'bottom', type: 'ElChartLegendAlign', description: 'pt-3 above the legend. Default.'),
];

const List<DocsApiFact> _chartTextFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'xs',
    type: 'ElTypeSpec (static)',
    description:
        'text-xs — 12px/16px, weight 400. What ChartContainer puts on '
        'everything it contains.',
  ),
  DocsApiFact(
    name: 'xsMedium',
    type: 'ElTypeSpec (static)',
    description: "font-medium on the tooltip's own label row: 12px/16px, weight 500.",
  ),
  DocsApiFact(
    name: 'xsTight',
    type: 'ElTypeSpec (static)',
    description:
        "leading-none — the tooltip's series name, 12px at ratio 1 rather "
        'than 16/12: measured 14.4px total for a row set by the value '
        "beside it, not by this label.",
  ),
];

const List<DocsApiFact> _numberFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'value',
    type: 'num',
    description:
        "elChartNumber(num value) → String. Number.prototype.toLocaleString() "
        "in en-US: grouped thousands, a true minus sign for a negative "
        "value, and at most three fraction digits with trailing zeros "
        "trimmed. Every figure a chart on this page prints goes through "
        "this.",
  ),
];

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Indicator: dot / line / dashed',
    treatment:
        "ElChartTooltipContent.indicator picks which mark paints beside "
        'each row: a 10px rounded square, a full-height bar, or a dashed '
        'stroke.',
    userSignal: 'Visual only; nothing else on the row reads it.',
  ),
  DocsStateFact(
    state: 'hideLabel / hideIndicator',
    treatment:
        "Suppresses the tooltip's header row, or every row's indicator "
        'mark. Both default to false.',
    userSignal: 'A caller-only switch — chart.dart never sets either itself.',
  ),
  DocsStateFact(
    state: 'Legend: row vs wrap',
    treatment:
        'ElChartLegendContent.wrap swaps a single centred Row for a Wrap '
        'that reflows onto more than one line once it runs out of width.',
    userSignal:
        'Chosen once per plot at construction, never toggled at runtime by '
        'the widget itself.',
  ),
  DocsStateFact(
    state: 'Hover / press / focus',
    treatment:
        'N/A. chart.dart wires no pointer or keyboard handling anywhere: '
        'every widget it declares is presentation only.',
    userSignal: 'N/A — see Accessibility and Keyboard below.',
  ),
];

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'No Semantics node anywhere in chart.dart — checked directly '
            'against the source, not inferred. ElChartTooltipContent and '
            'ElChartLegendContent render plain ElText and DecoratedBox '
            'trees with no accessible role, name, or live-region marker of '
            'their own.',
        'A screen reader on a real plot hears whatever '
            'chart-cartesian/chart-polar wire around this file\'s widgets, '
            'not anything this file supplies — check each of those pages\' '
            'own Accessibility disclosure for what, if anything, that is.',
        'Colour is the only signal an ElChartLegendContent swatch or an '
            'ElChartTooltipContent indicator carries when icon is omitted: '
            'there is no text pattern, shape difference, or texture backing '
            'it up beyond the dot/line/dashed choice itself.',
      ]);
}

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'No FocusNode, no Focus widget, no key handling anywhere in '
            'chart.dart: none of its five widgets can take keyboard focus.',
        'ElCartesianChart (chart-cartesian) answers a pointer hover with '
            'MouseRegion.onHover; nothing in this family answers a keyboard '
            'event at all, on any of the six real plot widgets.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'ElChartContainer is width: double.infinity — it stretches to '
            'whatever its parent offers — and a fixed height (plotHeight, '
            '256) unless height overrides it. No breakpoint branching '
            'anywhere in the file.',
        'ElChartTooltipContent grows with its content: minWidth is a '
            'floor (min-w-32), not a fixed size, unless width is passed.',
        'ElChartLegendContent wraps onto more than one line only when '
            'wrap: true is passed; the default Row shape overflows silently '
            'past its parent\'s width rather than reflowing on its own.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'File: lib/src/components/chart.dart — one file, no companions; '
            'the registry manifest lists exactly one entry under "files".',
        'Flutter imports: package:flutter/widgets.dart only — no '
            'package:flutter/material.dart anywhere in the file.',
        'Foundation imports: foundation/motion.dart (ElDurations, '
            'ElCurves), foundation/shadows.dart (ElShadows.tailwindXl, the '
            "tooltip panel's own shadow), foundation/spacing.dart (el()), "
            'foundation/theme.dart, foundation/typography.dart (ElFonts, '
            'ElTypeSpec), theme_scope.dart (ElText, ElTheme, '
            'elAnimationDuration).',
        'registryDependencies, resolved automatically by `elattar add '
            'chart`: source-foundation only — copied verbatim from '
            'registry/components/chart.json.',
        'Nothing in chart.dart reads theme.chart1…5 itself: the five '
            'chart tokens are resolved by the caller (a page, or '
            'chart-cartesian/chart-polar) and handed in as an '
            'ElChartSeries.color. This file only ever renders the colour it '
            'is given.',
      ]);
}

class _ThemingContent extends StatelessWidget {
  const _ThemingContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'Every colour is read live off ElTheme.of(context) at build time: '
            'theme.mutedForeground (the container\'s default text colour, '
            'and every legend/tooltip label that carries no series colour), '
            'theme.background and theme.border (the tooltip panel\'s own '
            'fill and hairline, at 50% alpha), theme.foreground (a row\'s '
            'printed value, and the fallback ink for an indicator or swatch '
            'with no colour of its own).',
        'The tooltip panel\'s shadow is ElShadows.tailwindXl, a fixed '
            'token, not one that varies by state — there is no separate '
            '"open" or "pinned" elevation.',
        'Every label chart.dart draws is ElChartText.xs, xsMedium, or '
            'xsTight — never a `.type-*` rung from the type scale. These '
            'three live in this file rather than in '
            'foundation/typography.dart because, as the source says, they '
            'are component roles, not rungs of the type scale.',
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
