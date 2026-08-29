/// Public documentation page for the `chart` component.
///
/// **A wrapper, not a plot.** `chart.dart` is `components/ui/chart.tsx`, the
/// official shadcn wrapper, ported: a themed [ChartConfig], the
/// fixed-height [ChartContainer] every plot mounts inside, the hover
/// [ChartTooltipContent] panel, the [ChartLegendContent] row, and
/// [chartNumber], the one grouped-thousands formatter every chart figure
/// goes through. It draws no axis, no bar, no wedge — that is
/// `chart-cartesian` and `chart-polar`, both of which import this file and
/// wrap their own painted geometry in [ChartContainer]. Every specimen
/// below is one of the five pieces this file actually owns, composed without
/// a real plot behind it.
///
/// **Section order.** Preview, Installation, Usage, then one section per
/// facet the wrapper owns: Container (the fixed-height box and its
/// `text-xs` cascade), Tooltip (the three [ChartIndicator] styles),
/// Legend (row vs wrapped, and the two [ChartLegendAlign] positions), and
/// Number formatting ([chartNumber]'s grouped-thousands rule) — then the
/// eight standing disclosures.
///
/// **Read, not inferred.** Every claim here traces to a line in
/// `lib/src/components/ui/chart.dart`. In particular: this file wires no
/// `Semantics` node, no `FocusNode`, and no keyboard handling anywhere —
/// checked with `grep -n "Semantics\|FocusNode" lib/src/components/ui/chart.dart`,
/// zero matches — so Accessibility and Keyboard both say so rather than
/// inventing a story chart.dart does not tell.
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
import '../chart_cartesian/meta.dart' as chart_cartesian;
import '../chart_polar/meta.dart' as chart_polar;
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
          '`ChartScope` so both resolve their colours and labels from the '
          'same `ChartConfig` — the composition every real plot on the '
          'page builds on top of.',
      specimen: const _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
      minHeight: space(160),
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'chart has a real registry manifest, `elattar add chart` installs '
          'lib/src/components/ui/chart.dart and resolves its one '
          'registryDependency, source-foundation, automatically. The Manual '
          'tab is for a project not using the CLI.',
      command: chartDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/chart.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/ui/chart.dart's generated "
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
              'Add the export line so ChartConfig, ChartContainer and '
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
          "ChartContainer fixes its height at plotHeight (256, the 8-point "
          "grid's own space(64)) unless height overrides it, stretches to "
          "whatever width its parent offers, and wraps its child in a "
          "DefaultTextStyle at ChartText.xs — text-xs, 12px/16px — which "
          "is why every label a plot draws (axis ticks, legend keys, "
          "tooltip rows) inherits the same small face without asking for it "
          "by name.",
      specimen: const _ContainerSpecimen(),
      code: _containerCode,
      label: 'Container specimen view',
      minHeight: space(160),
    ),
    ShowcaseSection(
      id: 'tooltip',
      title: 'Tooltip',
      description:
          "ChartTooltipContent's three ChartIndicator styles: dot (the "
          'default, a rounded 10px square), line (a full-height bar, cosmetic '
          'only), and dashed (the reference\'s own convention for a '
          'projected series — "do not spend it on a plain second series").',
      specimen: const _TooltipSpecimen(),
      code: _tooltipCode,
      label: 'Tooltip specimen view',
      minHeight: space(160),
    ),
    ShowcaseSection(
      id: 'legend',
      title: 'Legend',
      description:
          'ChartLegendContent as a single centred row (the default, '
          'gap-4) and as a wrapped row (wrap: true, the shape PieLegend '
          'reaches for when a fourth or fifth key would overflow one line).',
      specimen: const _LegendSpecimen(),
      code: _legendCode,
      label: 'Legend specimen view',
      minHeight: space(160),
    ),
    ShowcaseSection(
      id: 'number-formatting',
      title: 'Number formatting',
      description:
          "chartNumber — en-US grouped thousands, negatives spelled with a "
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
          'ChartIndicator and ChartLegendAlign value, ChartText\'s own '
          'three type roles, and chartNumber\'s own signature: one table '
          'per exported class, enum, or function.',
      children: const <DocsTocEntry>[
        DocsTocEntry(title: 'ChartConfig', anchor: 'api-elchartconfig'),
        DocsTocEntry(title: 'ChartSeries', anchor: 'api-elchartseries'),
        DocsTocEntry(title: 'ChartScope', anchor: 'api-elchartscope'),
        DocsTocEntry(title: 'ChartMotion', anchor: 'api-elchartmotion'),
        DocsTocEntry(title: 'ChartContainer', anchor: 'api-elchartcontainer'),
        DocsTocEntry(
          title: 'ChartTooltipItem',
          anchor: 'api-elcharttooltipitem',
        ),
        DocsTocEntry(
          title: 'ChartTooltipContent',
          anchor: 'api-elcharttooltipcontent',
        ),
        DocsTocEntry(title: 'ChartLegendItem', anchor: 'api-elchartlegenditem'),
        DocsTocEntry(
          title: 'ChartLegendContent',
          anchor: 'api-elchartlegendcontent',
        ),
        DocsTocEntry(title: 'ChartIndicator', anchor: 'api-elchartindicator'),
        DocsTocEntry(
          title: 'ChartLegendAlign',
          anchor: 'api-elchartlegendalign',
        ),
        DocsTocEntry(title: 'ChartText', anchor: 'api-elcharttext'),
        DocsTocEntry(title: 'chartNumber', anchor: 'api-elchartnumber'),
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
          'CartesianChart and PieChart in chart-cartesian and '
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
      title: chartDoc.title,
      description: chartDoc.description,
    ),
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Components'),
      BreadcrumbEntry.page('Chart'),
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
const List<ChartTooltipItem> _previewItems = <ChartTooltipItem>[
  ChartTooltipItem(name: 'running', dataKey: 'running', value: 450),
  ChartTooltipItem(name: 'swimming', dataKey: 'swimming', value: 300),
];

class _PreviewSpecimen extends StatelessWidget {
  const _PreviewSpecimen();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final ChartConfig config = ChartConfig(<String, ChartSeries>{
      'running': ChartSeries(label: 'Running', color: theme.chart1),
      'swimming': ChartSeries(label: 'Swimming', color: theme.chart2),
    });
    return ChartScope(
      config: config,
      child: Wrap(
        spacing: space(6),
        runSpacing: space(6),
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          KeyedSubtree(
            key: const ValueKey<String>('chart-preview:tooltip'),
            child: const ChartTooltipContent(
              label: 'Jul 15, 2024',
              items: _previewItems,
            ),
          ),
          KeyedSubtree(
            key: const ValueKey<String>('chart-preview:legend'),
            child: const ChartLegendContent(
              items: <ChartLegendItem>[
                ChartLegendItem(name: 'running'),
                ChartLegendItem(name: 'swimming'),
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
    'final config = ChartConfig({\n'
    "  'running': ChartSeries(label: 'Running', color: theme.chart1),\n"
    "  'swimming': ChartSeries(label: 'Swimming', color: theme.chart2),\n"
    '});\n\n'
    'ChartScope(\n'
    '  config: config,\n'
    '  child: Row(\n'
    '    children: [\n'
    '      ChartTooltipContent(\n'
    "        label: 'Jul 15, 2024',\n"
    '        items: [\n'
    "          ChartTooltipItem(name: 'running', dataKey: 'running', value: 450),\n"
    "          ChartTooltipItem(name: 'swimming', dataKey: 'swimming', value: 300),\n"
    '        ],\n'
    '      ),\n'
    '      ChartLegendContent(\n'
    '        items: [\n'
    "          ChartLegendItem(name: 'running'),\n"
    "          ChartLegendItem(name: 'swimming'),\n"
    '        ],\n'
    '      ),\n'
    '    ],\n'
    '  ),\n'
    ')';

const String _usageCode =
    "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
    'ChartContainer(\n'
    '  config: const ChartConfig({}),\n'
    "  child: Text('a real plot from chart-cartesian or chart-polar goes here'),\n"
    ')';

class _ContainerSpecimen extends StatelessWidget {
  const _ContainerSpecimen();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    Widget box(String label) => DecoratedBox(
      decoration: BoxDecoration(
        color: theme.muted,
        borderRadius: BorderRadius.circular(Radii.md),
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
              width: space(48),
              child: ChartContainer(
                config: const ChartConfig(<String, ChartSeries>{}),
                child: box('text-xs, height 256'),
              ),
            ),
          ),
          SizedBox(width: space(6)),
          KeyedSubtree(
            key: const ValueKey<String>(
              'chart-example:container-custom-height',
            ),
            child: SizedBox(
              width: space(48),
              child: ChartContainer(
                height: space(32),
                config: const ChartConfig(<String, ChartSeries>{}),
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
    'ChartContainer(\n'
    '  config: const ChartConfig({}),\n'
    "  child: Text('text-xs, inherited'), // height defaults to plotHeight, 256\n"
    ')\n\n'
    'ChartContainer(\n'
    '  height: 128,\n'
    '  config: const ChartConfig({}),\n'
    "  child: Text('a shorter container'),\n"
    ')';

class _TooltipSpecimen extends StatelessWidget {
  const _TooltipSpecimen();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final ChartConfig config = ChartConfig(<String, ChartSeries>{
      'running': ChartSeries(label: 'Running', color: theme.chart1),
      'swimming': ChartSeries(label: 'Swimming', color: theme.chart2),
    });
    return ChartScope(
      config: config,
      child: Wrap(
        spacing: space(6),
        runSpacing: space(6),
        children: <Widget>[
          KeyedSubtree(
            key: const ValueKey<String>('chart-example:tooltip-dot'),
            child: const ChartTooltipContent(
              label: 'Jul 15',
              items: _previewItems,
            ),
          ),
          KeyedSubtree(
            key: const ValueKey<String>('chart-example:tooltip-line'),
            child: const ChartTooltipContent(
              label: 'Jul 15',
              items: _previewItems,
              indicator: ChartIndicator.line,
            ),
          ),
          KeyedSubtree(
            key: const ValueKey<String>('chart-example:tooltip-dashed'),
            child: const ChartTooltipContent(
              label: 'Jul 15',
              items: _previewItems,
              indicator: ChartIndicator.dashed,
            ),
          ),
        ],
      ),
    );
  }
}

const String _tooltipCode =
    'ChartTooltipContent(\n'
    "  label: 'Jul 15',\n"
    '  items: items,\n'
    '  indicator: ChartIndicator.dashed, // dot | line | dashed\n'
    ')';

class _LegendSpecimen extends StatelessWidget {
  const _LegendSpecimen();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final ChartConfig config = ChartConfig(<String, ChartSeries>{
      'chrome': ChartSeries(label: 'Chrome', color: theme.chart1),
      'safari': ChartSeries(label: 'Safari', color: theme.chart2),
      'firefox': ChartSeries(label: 'Firefox', color: theme.chart3),
      'edge': ChartSeries(label: 'Edge', color: theme.chart4),
      'other': ChartSeries(label: 'Other', color: theme.chart5),
    });
    return ChartScope(
      config: config,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          KeyedSubtree(
            key: const ValueKey<String>('chart-example:legend-row'),
            child: const ChartLegendContent(
              items: <ChartLegendItem>[
                ChartLegendItem(name: 'chrome'),
                ChartLegendItem(name: 'safari'),
                ChartLegendItem(name: 'firefox'),
              ],
            ),
          ),
          SizedBox(height: space(4)),
          KeyedSubtree(
            key: const ValueKey<String>('chart-example:legend-wrap'),
            child: ChartLegendContent(
              wrap: true,
              gap: space(2),
              items: const <ChartLegendItem>[
                ChartLegendItem(name: 'chrome'),
                ChartLegendItem(name: 'safari'),
                ChartLegendItem(name: 'firefox'),
                ChartLegendItem(name: 'edge'),
                ChartLegendItem(name: 'other'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

const String _legendCode =
    'ChartLegendContent(\n'
    '  wrap: true, // PieLegend\'s own shape: gap-2 instead of the gap-4 default\n'
    '  gap: 8,\n'
    '  items: [\n'
    "    ChartLegendItem(name: 'chrome'),\n"
    "    ChartLegendItem(name: 'safari'),\n"
    "    ChartLegendItem(name: 'firefox'),\n"
    "    ChartLegendItem(name: 'edge'),\n"
    "    ChartLegendItem(name: 'other'),\n"
    '  ],\n'
    ')';

class _NumberFormattingSpecimen extends StatelessWidget {
  const _NumberFormattingSpecimen();

  static const List<num> _values = <num>[275, 1234, -42, 1000000, 12.5];

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Wrap(
      spacing: space(6),
      runSpacing: space(2),
      children: <Widget>[
        for (final num v in _values)
          KeyedSubtree(
            key: ValueKey<String>('chart-example:number-formatting-$v'),
            child: StyledText(
              'chartNumber($v) → ${chartNumber(v)}',
              TextStyles.code,
              color: theme.foreground,
            ),
          ),
      ],
    );
  }
}

const String _numberFormattingCode =
    "chartNumber(275)     // '275'\n"
    "chartNumber(1234)    // '1,234'\n"
    "chartNumber(-42)     // '−42'\n"
    "chartNumber(1000000) // '1,000,000'\n"
    "chartNumber(12.5)    // '12.5'";

/* ── Disclosure content ─────────────────────────────────────────────────── */

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
        id: 'api-elchartseries',
        child: DocsApiTable(title: 'ChartSeries', facts: _seriesFacts),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elchartscope',
        child: DocsApiTable(title: 'ChartScope', facts: _scopeFacts),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elchartmotion',
        child: DocsApiTable(title: 'ChartMotion', facts: _motionFacts),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elchartcontainer',
        child: DocsApiTable(title: 'ChartContainer', facts: _containerFacts),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elcharttooltipitem',
        child: DocsApiTable(
          title: 'ChartTooltipItem',
          facts: _tooltipItemFacts,
        ),
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
        id: 'api-elchartlegenditem',
        child: DocsApiTable(title: 'ChartLegendItem', facts: _legendItemFacts),
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
        id: 'api-elchartindicator',
        child: DocsApiTable(title: 'ChartIndicator', facts: _indicatorFacts),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elchartlegendalign',
        child: DocsApiTable(
          title: 'ChartLegendAlign',
          facts: _legendAlignFacts,
        ),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elcharttext',
        child: DocsApiTable(title: 'ChartText', facts: _chartTextFacts),
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
    name: 'entries',
    type: 'Map<String, ChartSeries>',
    description:
        'The constructor\'s one positional parameter. Every series key '
        'mapped to its label and colour — "the one piece of a chart that is '
        'worth writing before the chart itself."',
  ),
  DocsApiFact(
    name: 'operator []',
    type: 'ChartSeries? Function(String)',
    description: 'Looks a key up directly, config[key].',
  ),
  DocsApiFact(
    name: 'resolve',
    type: 'ChartSeries? Function(String, Map<String, Object?>?)',
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
    type: 'ChartConfig Function(Map<String, ChartSeries>)',
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
        'call site fills it with Icon.',
  ),
];

const List<DocsApiFact> _scopeFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'config',
    type: 'ChartConfig',
    description:
        'Threaded down through InheritedWidget to whatever renders inside '
        'ChartContainer.',
  ),
  DocsApiFact(name: 'child', type: 'Widget', description: 'Required.'),
  DocsApiFact(
    name: 'ChartScope.of',
    type: 'ChartConfig Function(BuildContext)',
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
        'MotionDurations.slow — --duration-slow, as useChartMotion reads it. '
        'chart-cartesian and chart-polar both read this for their entrance '
        'AnimationController.',
  ),
  DocsApiFact(
    name: 'curve',
    type: 'Curve (static getter)',
    description:
        'MotionCurves.cssEaseOut, not MotionCurves.enter. Documented drift: recharts '
        'can only receive the CSS keyword "ease-out" '
        '(cubic-bezier(0,0,0.58,1)), a visibly different curve from the '
        'design system\'s own MotionCurves.enter. Reproducing the reference '
        'means reproducing that failure rather than "fixing" it.',
  ),
];

const List<DocsApiFact> _containerFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'config',
    type: 'ChartConfig',
    description: 'Required. Threaded down via ChartScope.',
  ),
  DocsApiFact(
    name: 'child',
    type: 'Widget',
    description:
        'Required. The plot — usually CartesianChart or one of the three '
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
    description: 'The number the row prints, through chartNumber.',
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
    type: 'ChartConfig?',
    description:
        'Normally read from ChartScope; passed directly only by a test '
        'or a page-local label chip.',
  ),
  DocsApiFact(
    name: 'label',
    type: 'String?',
    description: 'The category under the cursor — a month, an ISO date.',
  ),
  DocsApiFact(
    name: 'items',
    type: 'List<ChartTooltipItem>',
    description: 'Required.',
  ),
  DocsApiFact(
    name: 'indicator',
    type: 'ChartIndicator',
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
    type: 'String Function(String, List<ChartTooltipItem>)?',
    description: 'Replaces the header row\'s text.',
  ),
  DocsApiFact(
    name: 'formatter',
    type: 'Widget Function(BuildContext, ChartTooltipItem, int)?',
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
  DocsApiFact(
    name: 'name',
    type: 'String',
    description: 'Required. The series key.',
  ),
  DocsApiFact(
    name: 'color',
    type: 'Color?',
    description: 'Overrides the config lookup.',
  ),
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
  DocsApiFact(
    name: 'config',
    type: 'ChartConfig?',
    description: 'Falls back to ChartScope.of.',
  ),
  DocsApiFact(
    name: 'items',
    type: 'List<ChartLegendItem>',
    description: 'Required.',
  ),
  DocsApiFact(
    name: 'verticalAlign',
    type: 'ChartLegendAlign',
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
    description:
        "flex-wrap — PieLegend's own shape, for four keys on two lines.",
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
    type: 'ChartIndicator',
    description: 'The default — a rounded 10px square.',
  ),
  DocsApiFact(
    name: 'line',
    type: 'ChartIndicator',
    description: 'A full-height bar beside the row. Cosmetic only.',
  ),
  DocsApiFact(
    name: 'dashed',
    type: 'ChartIndicator',
    description:
        'The reference\'s own convention for a projection: "do not spend '
        'it on a plain second series."',
  ),
];

const List<DocsApiFact> _legendAlignFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'top',
    type: 'ChartLegendAlign',
    description: 'pb-3 below the legend.',
  ),
  DocsApiFact(
    name: 'bottom',
    type: 'ChartLegendAlign',
    description: 'pt-3 above the legend. Default.',
  ),
];

const List<DocsApiFact> _chartTextFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'xs',
    type: 'TextStyleToken (static)',
    description:
        'text-xs — 12px/16px, weight 400. What ChartContainer puts on '
        'everything it contains.',
  ),
  DocsApiFact(
    name: 'xsMedium',
    type: 'TextStyleToken (static)',
    description:
        "font-medium on the tooltip's own label row: 12px/16px, weight 500.",
  ),
  DocsApiFact(
    name: 'xsTight',
    type: 'TextStyleToken (static)',
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
        "chartNumber(num value) → String. Number.prototype.toLocaleString() "
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
        "ChartTooltipContent.indicator picks which mark paints beside "
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
        'ChartLegendContent.wrap swaps a single centred Row for a Wrap '
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
      _bullets(ThemeScope.of(context), <String>[
        'No Semantics node anywhere in chart.dart — checked directly '
            'against the source, not inferred. ChartTooltipContent and '
            'ChartLegendContent render plain StyledText and DecoratedBox '
            'trees with no accessible role, name, or live-region marker of '
            'their own.',
        'A screen reader on a real plot hears whatever '
            'chart-cartesian/chart-polar wire around this file\'s widgets, '
            'not anything this file supplies — check each of those pages\' '
            'own Accessibility disclosure for what, if anything, that is.',
        'Colour is the only signal an ChartLegendContent swatch or an '
            'ChartTooltipContent indicator carries when icon is omitted: '
            'there is no text pattern, shape difference, or texture backing '
            'it up beyond the dot/line/dashed choice itself.',
      ]);
}

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'No FocusNode, no Focus widget, no key handling anywhere in '
            'chart.dart: none of its five widgets can take keyboard focus.',
        'CartesianChart (chart-cartesian) answers a pointer hover with '
            'MouseRegion.onHover; nothing in this family answers a keyboard '
            'event at all, on any of the six real plot widgets.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'ChartContainer is width: double.infinity — it stretches to '
            'whatever its parent offers — and a fixed height (plotHeight, '
            '256) unless height overrides it. No breakpoint branching '
            'anywhere in the file.',
        'ChartTooltipContent grows with its content: minWidth is a '
            'floor (min-w-32), not a fixed size, unless width is passed.',
        'ChartLegendContent wraps onto more than one line only when '
            'wrap: true is passed; the default Row shape overflows silently '
            'past its parent\'s width rather than reflowing on its own.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      _bullets(ThemeScope.of(context), <String>[
        'File: lib/src/components/ui/chart.dart — one file, no companions; '
            'the registry manifest lists exactly one entry under "files".',
        'Flutter imports: package:flutter/widgets.dart only — no '
            'package:flutter/material.dart anywhere in the file.',
        'Foundation imports: foundation/motion.dart (MotionDurations, '
            'MotionCurves), foundation/shadows.dart (Shadows.tailwindXl, the '
            "tooltip panel's own shadow), foundation/spacing.dart (space()), "
            'foundation/theme.dart, foundation/typography.dart (Fonts, '
            'TextStyleToken), theme_scope.dart (StyledText, ThemeScope, '
            'effectiveMotionDuration).',
        'registryDependencies, resolved automatically by `elattar add '
            'chart`: source-foundation only — copied verbatim from '
            'registry/components/chart.json.',
        'Nothing in chart.dart reads theme.chart1…5 itself: the five '
            'chart tokens are resolved by the caller (a page, or '
            'chart-cartesian/chart-polar) and handed in as an '
            'ChartSeries.color. This file only ever renders the colour it '
            'is given.',
      ]),
      SizedBox(height: space(2)),
      DocsLinkRow(
        links: <DocsLink>[
          DocsLink(
            label: chart_cartesian.chartCartesianDoc.title,
            route: chart_cartesian.chartCartesianDoc.route,
          ),
          DocsLink(
            label: chart_polar.chartPolarDoc.title,
            route: chart_polar.chartPolarDoc.route,
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
      _bullets(ThemeScope.of(context), <String>[
        'Every colour is read live off ThemeScope.of(context) at build time: '
            'theme.mutedForeground (the container\'s default text colour, '
            'and every legend/tooltip label that carries no series colour), '
            'theme.background and theme.border (the tooltip panel\'s own '
            'fill and hairline, at 50% alpha), theme.foreground (a row\'s '
            'printed value, and the fallback ink for an indicator or swatch '
            'with no colour of its own).',
        'The tooltip panel\'s shadow is Shadows.tailwindXl, a fixed '
            'token, not one that varies by state — there is no separate '
            '"open" or "pinned" elevation.',
        'Every label chart.dart draws is ChartText.xs, xsMedium, or '
            'xsTight — never a `.type-*` rung from the type scale. These '
            'three live in this file rather than in '
            'foundation/typography.dart because, as the source says, they '
            'are component roles, not rungs of the type scale.',
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
