/// Public documentation page for the `stat` component alone.
///
/// **Re-housed onto the kit.** This page used to hand-compose `Section`
/// panels; it now declares a `ComponentDocSpec`
/// (`example/lib/docs/component_doc_page.dart`) and hands it to
/// `ComponentDocPage`, the same shape `button` and `field` established.
/// Every specimen widget and every code string below is the one the
/// hand-composed page carried; only where it lives changed, plus a new
/// Keyboard disclosure — `Stat` is never focusable, and the disclosure
/// says so plainly rather than being skipped.
///
/// **Split from a merged page**, unchanged from before: `stat/page.dart`
/// used to document `stat`, `item`, `empty`, and `kbd` together. `item`,
/// `empty`, and `kbd` now have real pages of their own
/// (`lib/components_docs/item/`, `empty/`, `kbd/`); this file keeps only
/// what belongs to `Stat`.
///
/// **`stat` ships a real registry manifest.** `registry/components/
/// stat.json` exists (`registryDependencies: [icon, skeleton,
/// source-foundation, content-change]`), so `elattar add stat` installs today.
/// The previous version of this page said the opposite — "stat has no
/// registry/components/stat.json yet" — which was wrong; every
/// install-facing fact below reads off the shipped manifest instead.
///
/// **`stat` has no shadcn counterpart** (`components/ui/stat.tsx` is this
/// system's own file, not a port), so every component-specific section
/// below is ours-only and named for what it does rather than mirrored from
/// a reference page: Composition (the one real leaf-widget tree plus a real
/// composed shape), Delta and direction, Loading/error/empty, RTL, matching
/// the shape `button`/`field` established (Preview, Installation, Usage,
/// the component's own sections, then the eight required disclosures: API
/// Reference, States, Accessibility, Keyboard, Responsive, Dependencies,
/// Theming, Source).
///
/// [ComponentDocEntry.description] is the page's only rendered description;
/// no second hero paragraph renders beneath it.
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
import 'meta.dart';

final ComponentDocSpec statDocSpec = ComponentDocSpec(
  name: 'stat',
  title: statDoc.title,
  description: statDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'Stat renders a labelled metric figure with an optional delta '
          'and trailing hint. The metric sits in a fixed-height slot, the '
          'delta row is optional and wraps if it overflows, and the '
          'footprint is identical across every state (ready, loading, '
          'error, empty, disabled): the layout never reflows when the '
          'state changes. Reach for it on a dashboard, a summary card, or '
          'a data page to show a metric with direction: revenue with a '
          'trend, an uptime percentage with a change.',
      specimen: const _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'stat ships a real registry manifest: `elattar add stat` '
          'installs lib/src/components/ui/stat.dart and resolves icon, '
          'skeleton, source-foundation, and content-change automatically. The '
          'Manual tab is for a project not using the CLI.',
      command: statDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/stat.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/ui/stat.dart's generated @ui/stat.dart "
              'payload into components/ui.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated stat source here when using manual '
              'mode.',
        ),
        const DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so Stat and its companion types are '
              'reachable the same way the CLI path already makes them.',
          code: "export 'stat.dart';",
        ),
      ],
    ),
    const SnippetSection(
      id: 'usage',
      title: 'Usage',
      description: 'The smallest correct call, then a full metric.',
      code: _usageCode,
    ),
    ShowcaseSection(
      id: 'composition',
      title: 'Composition',
      description:
          'Stat is a single leaf: it takes data (label, value, delta, '
          'hint), not children, so there is no part-widget tree to '
          'assemble the way Item or Empty have. StatDeltaMark is the one '
          'piece exported separately, for a caller that already has its '
          'own label and wants to reuse just the direction mark (see API '
          'Reference). Below: one real composed use, a card header.',
      specimen: const _CompositionSpecimen(),
      code: _compositionCode,
      label: 'Composition specimen view',
    ),
    ShowcaseSection(
      id: 'delta',
      title: 'Delta and direction',
      description:
          'Direction is conveyed three ways before colour is considered: '
          'the glyph\'s shape, the sign written onto the number, and a '
          'visually hidden word for assistive tech (see Accessibility). '
          'betterWhen chooses which direction earns the success ink; the '
          'other gets plain foreground, and flat is always muted.',
      specimen: const _DeltaSpecimen(),
      code: _deltaCode,
      label: 'Delta and direction specimen view',
    ),
    ShowcaseSection(
      id: 'states-demo',
      title: 'Loading, error, and empty',
      description:
          'The figure slot holds the same line-box height in every '
          'state, so the layout never reflows when a metric moves from '
          'loading to ready. error and empty both replace the figure with '
          'an em dash and swap the delta row for a message; disabled dims '
          'the whole row and marks it Semantics(enabled: false).',
      specimen: const _StatesDemoSpecimen(),
      code: _statesDemoCode,
      label: 'Loading, error, and empty specimen view',
    ),
    ShowcaseSection(
      id: 'rtl',
      title: 'RTL',
      description:
          'Stat paints no direction-specific layout of its own: it '
          'sizes to its content and reads right-to-left under a plain '
          'Directionality, the same composition either way.',
      specimen: const _RtlSpecimen(),
      code: _rtlCode,
      label: 'RTL specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      children: const <DocsTocEntry>[
        DocsTocEntry(title: 'Stat', anchor: 'api-elstat'),
        DocsTocEntry(title: 'Stat static tokens', anchor: 'api-elstat-static'),
        DocsTocEntry(title: 'StatState', anchor: 'api-elstatstate'),
        DocsTocEntry(title: 'StatDeltaMark', anchor: 'api-elstatdeltamark'),
      ],
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'Stat is the only one of the four former sibling components '
          'with a real state machine: these rows read straight off the '
          'source.',
      child: DocsStateMatrix(facts: _stateFacts),
    ),
    DisclosureSection(
      id: 'accessibility',
      title: 'Accessibility',
      child: _AccessibilityContent(),
    ),
    DisclosureSection(
      id: 'keyboard',
      title: 'Keyboard',
      description:
          'Stat is read, never touched: it owns no GestureDetector, '
          'FocusNode, or onPressed/enabled parameter of its own, so every '
          'fact here is about what does NOT happen.',
      child: _KeyboardContent(),
    ),
    DisclosureSection(
      id: 'responsive',
      title: 'Responsive',
      child: _ResponsiveContent(),
    ),
    DisclosureSection(
      id: 'dependencies',
      title: 'Dependencies',
      child: _DependenciesContent(),
    ),
    DisclosureSection(
      id: 'theming',
      title: 'Theming',
      child: _ThemingContent(),
    ),
    DisclosureSection(
      id: 'source',
      title: 'Source',
      child: DocsInstallFacts(
        title: 'Reference',
        facts: <DocsInstallFact>[
          DocsInstallFact(
            label: 'Source',
            value: statDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'none yet',
            description:
                'No dedicated unit test exists for stat.dart in the '
                'package test suite as of this page.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/stat_test.dart',
            description:
                'Covers this page: the API tables, live specimens at both '
                'breakpoints, and both themes.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/stat/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class StatDocPage extends StatelessWidget {
  const StatDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: statDoc.route,
    intro: DocsPageIntro(
      title: statDocSpec.title,
      description: statDocSpec.description,
    ),
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Components'),
      BreadcrumbEntry.page('Stat'),
    ],
    toc: statDocSpec.toc,
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('stat-doc-article'),
      child: ComponentDocPage(spec: statDocSpec, header: false),
    ),
  );
}

/* ── Showcase specimens ─────────────────────────────────────────────────── */

class _PreviewSpecimen extends StatelessWidget {
  const _PreviewSpecimen();

  @override
  Widget build(BuildContext context) => const KeyedSubtree(
    key: ValueKey<String>('stat-preview'),
    child: Stat(
      label: 'Revenue',
      value: '\$12,480',
      delta: (value: '8.2%', direction: StatDirection.up),
      hint: 'vs last month',
    ),
  );
}

const String _previewCode = '''Stat(
  label: 'Revenue',
  value: '\\\$12,480',
  delta: (value: '8.2%', direction: StatDirection.up),
  hint: 'vs last month',
)''';

const String _usageCode = '''
import 'package:elattar_design_system/elattar_design_system.dart';

// The smallest correct call.
Stat(
  label: 'Revenue',
  value: '\\\$12,480',
)

// A full metric with delta and hint.
Stat(
  label: 'Revenue',
  value: '\\\$12,480',
  delta: (value: '8.2%', direction: StatDirection.up),
  betterWhen: StatDirection.up,
  hint: 'vs last month',
)''';

class _CompositionSpecimen extends StatelessWidget {
  const _CompositionSpecimen();

  @override
  Widget build(BuildContext context) => Card(
    children: <Widget>[
      CardContent(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Stat(
              label: 'Monthly revenue',
              value: '\$52,840',
              delta: (value: '12.5%', direction: StatDirection.up),
              hint: 'vs last month',
            ),
            SizedBox(height: space(4)),
            const Separator(),
            SizedBox(height: space(4)),
            StyledText('In the last 30 days', TextStyles.small),
          ],
        ),
      ),
    ],
  );
}

const String _compositionCode = '''Card(
  children: <Widget>[
    CardContent(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Stat(
            label: 'Monthly revenue',
            value: '\\\$52,840',
            delta: (value: '12.5%', direction: StatDirection.up),
            hint: 'vs last month',
          ),
          SizedBox(height: space(4)),
          const Separator(),
          SizedBox(height: space(4)),
          StyledText('In the last 30 days', TextStyles.small),
        ],
      ),
    ),
  ],
)''';

class _DeltaSpecimen extends StatelessWidget {
  const _DeltaSpecimen();

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: space(10),
    runSpacing: space(6),
    children: <Widget>[
      const KeyedSubtree(
        key: ValueKey<String>('stat-example:up'),
        child: Stat(
          label: 'Revenue',
          value: '\$12,480',
          delta: (value: '8.2%', direction: StatDirection.up),
          hint: 'vs last month',
        ),
      ),
      const KeyedSubtree(
        key: ValueKey<String>('stat-example:down'),
        child: Stat(
          label: 'Refunds',
          value: '\$1,204',
          delta: (value: '3.1%', direction: StatDirection.down),
          betterWhen: StatDirection.down,
          hint: 'vs last month',
        ),
      ),
      const KeyedSubtree(
        key: ValueKey<String>('stat-example:flat'),
        child: Stat(
          label: 'Signups',
          value: '482',
          delta: (value: '0.0%', direction: StatDirection.flat),
          hint: 'vs last month',
        ),
      ),
    ],
  );
}

const String _deltaCode = '''Stat(
  label: 'Revenue',
  value: '\\\$12,480',
  delta: (value: '8.2%', direction: StatDirection.up),
  hint: 'vs last month',
)

Stat(
  label: 'Refunds',
  value: '\\\$1,204',
  delta: (value: '3.1%', direction: StatDirection.down),
  betterWhen: StatDirection.down, // down is favourable here
  hint: 'vs last month',
)

Stat(
  label: 'Signups',
  value: '482',
  delta: (value: '0.0%', direction: StatDirection.flat),
  hint: 'vs last month',
)''';

class _StatesDemoSpecimen extends StatelessWidget {
  const _StatesDemoSpecimen();

  // Stat's error/empty message row is icon + `Text` with no ellipsis and no
  // caller hook to add one (see the library's own `stat.dart:318`), so at
  // 200% text scale "Failed to load" alone needs more than the full mobile
  // specimen width — not just its share of one `Wrap` run. Below the
  // breakpoint this switches from `Wrap` to a horizontally scrolling `Row`
  // of the same four cards, the last-resort technique, chosen because
  // there is no narrower text to fall back to without changing what the
  // states actually say.
  static const double _scrollBreakpoint = 480;

  @override
  Widget build(BuildContext context) {
    final List<Widget> cards = <Widget>[
      const KeyedSubtree(
        key: ValueKey<String>('stat-example:loading'),
        child: Stat(
          label: 'Revenue',
          value: '\$12,480',
          delta: (value: '8.2%', direction: StatDirection.up),
          state: StatState.loading,
        ),
      ),
      const KeyedSubtree(
        key: ValueKey<String>('stat-example:error'),
        child: Stat(
          label: 'Uptime',
          value: 'N/A',
          state: StatState.error,
          message: 'Failed to load',
        ),
      ),
      const KeyedSubtree(
        key: ValueKey<String>('stat-example:empty'),
        child: Stat(
          label: 'Uptime',
          value: 'N/A',
          state: StatState.empty,
          message: 'No data yet',
        ),
      ),
      const KeyedSubtree(
        key: ValueKey<String>('stat-example:disabled'),
        child: Stat(
          label: 'Churn',
          value: '4.1%',
          delta: (value: '0.4%', direction: StatDirection.down),
          betterWhen: StatDirection.down,
          hint: 'vs last month',
          disabled: true,
        ),
      ),
    ];
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth < _scrollBreakpoint) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                for (int i = 0; i < cards.length; i++) ...<Widget>[
                  if (i > 0) SizedBox(width: space(10)),
                  cards[i],
                ],
              ],
            ),
          );
        }
        return Wrap(spacing: space(10), runSpacing: space(6), children: cards);
      },
    );
  }
}

const String _statesDemoCode = '''Stat(
  label: 'Revenue',
  value: '\\\$12,480',
  delta: (value: '8.2%', direction: StatDirection.up),
  state: StatState.loading,
)

Stat(
  label: 'Uptime',
  value: 'N/A',
  state: StatState.error,
  message: 'Failed to load',
)

Stat(
  label: 'Uptime',
  value: 'N/A',
  state: StatState.empty,
  message: 'No data yet',
)

Stat(
  label: 'Churn',
  value: '4.1%',
  delta: (value: '0.4%', direction: StatDirection.down),
  betterWhen: StatDirection.down,
  hint: 'vs last month',
  disabled: true,
)''';

class _RtlSpecimen extends StatelessWidget {
  const _RtlSpecimen();

  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: TextDirection.rtl,
    child: const KeyedSubtree(
      key: ValueKey<String>('rtl-example:stat'),
      child: Stat(
        label: 'الإيرادات',
        value: '\$12,480',
        delta: (value: '8.2%', direction: StatDirection.up),
        hint: 'مقارنة بالشهر الماضي',
      ),
    ),
  );
}

const String _rtlCode = '''Directionality(
  textDirection: TextDirection.rtl,
  child: Stat(
    label: 'الإيرادات',
    value: '\\\$12,480',
    delta: (value: '8.2%', direction: StatDirection.up),
    hint: 'مقارنة بالشهر الماضي',
  ),
)''';

/* ── Disclosure content ─────────────────────────────────────────────────── */

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsAnchor(
        id: 'api-elstat',
        child: DocsApiTable(
          title: 'Stat',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'label',
              type: 'String',
              description: 'Required. The metric name, "Revenue".',
            ),
            DocsApiFact(
              name: 'value',
              type: 'String',
              description:
                  'Required. The figure to display, "\$12,480". Slot '
                  'height is fixed regardless of content.',
            ),
            DocsApiFact(
              name: 'delta',
              type: 'StatDelta?',
              description:
                  'Optional. Defaults to null. A record, (value: "8.2%", '
                  'direction: StatDirection.up). Presence reserves the '
                  'delta row even while loading.',
            ),
            DocsApiFact(
              name: 'betterWhen',
              type: 'StatDirection',
              description:
                  'Optional. Defaults to StatDirection.up. Which '
                  'direction gets the success ink; the other gets plain '
                  'foreground. Flat is always muted.',
            ),
            DocsApiFact(
              name: 'hint',
              type: 'String?',
              description:
                  'Optional. Defaults to null. A trailing comparison, '
                  '"vs last month". Shown below the delta while ready.',
            ),
            DocsApiFact(
              name: 'state',
              type: 'StatState',
              description:
                  'Optional. Defaults to StatState.ready. Controls what '
                  'the figure and delta render as.',
            ),
            DocsApiFact(
              name: 'message',
              type: 'String?',
              description:
                  'Optional. Defaults to null. Shown in the delta row '
                  'while error (with a triangle-alert icon) or empty; '
                  'replaces hint in those states.',
            ),
            DocsApiFact(
              name: 'disabled',
              type: 'bool',
              description:
                  'Optional. Defaults to false. Sets 45% opacity and '
                  'Semantics(enabled: false) when true.',
            ),
          ],
        ),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elstat-static',
        child: DocsApiTable(
          title: 'Stat static tokens',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'Stat.rowGap',
              type: 'static double',
              description: '8px: under the label, and under the figure slot.',
            ),
            DocsApiFact(
              name: 'Stat.deltaGap',
              type: 'static double',
              description: '8px gap on the delta row (flex-wrap).',
            ),
            DocsApiFact(
              name: 'Stat.messageGap',
              type: 'static double',
              description:
                  '6px gap between the error triangle-alert icon and its '
                  'message.',
            ),
            DocsApiFact(
              name: 'Stat.figureSkeleton',
              type: 'static Size',
              description: '112px × 20px: the loading figure placeholder.',
            ),
            DocsApiFact(
              name: 'Stat.deltaSkeleton',
              type: 'static Size',
              description: '56px × 10px: the loading delta placeholder.',
            ),
            DocsApiFact(
              name: 'Stat.figureHeight',
              type: 'static double',
              description:
                  'The fixed line-box height the figure slot maintains in '
                  'every state: prevents reflow on loading → ready.',
            ),
          ],
        ),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elstatstate',
        child: DocsApiTable(
          title: 'StatState',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'ready',
              type: 'the default',
              description: 'Renders the value, the delta mark, and the hint.',
            ),
            DocsApiFact(
              name: 'loading',
              type: 'enum value',
              description:
                  'Renders skeleton placeholders for the value and delta, '
                  'keeping the full slot height.',
            ),
            DocsApiFact(
              name: 'error',
              type: 'enum value, blank',
              description:
                  'Renders an em dash and the error message with a '
                  'triangle-alert icon.',
            ),
            DocsApiFact(
              name: 'empty',
              type: 'enum value, blank',
              description:
                  'Renders an em dash and a plain-text message (no icon).',
            ),
          ],
        ),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elstatdeltamark',
        child: DocsApiTable(
          title: 'StatDeltaMark',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'delta',
              type: 'StatDelta',
              description: 'Required. The same record type Stat.delta takes.',
            ),
            DocsApiFact(
              name: 'betterWhen',
              type: 'StatDirection',
              description:
                  'Required, not defaulted: a caller reaching for the '
                  'mark alone is already thinking about direction and '
                  'must say which one it means.',
            ),
            DocsApiFact(
              name: 'StatDeltaMark.gap',
              type: 'static double',
              description: '4px between the glyph and the sign+value text.',
            ),
          ],
        ),
      ),
    ],
  );
}

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Rest / ready',
    treatment:
        'Paints the label, the figure in a fixed slot, and the delta '
        'mark or hint.',
    userSignal: 'The resting paint.',
  ),
  DocsStateFact(
    state: 'Loading',
    treatment:
        'Renders skeleton placeholders for the value and delta, keeping '
        'the same figureHeight so the layout does not reflow. A ContentChange '
        'replay fires on the loading → ready transition (a key change, '
        'not an AnimationController).',
    userSignal: 'A shimmer where the figure and delta will be.',
  ),
  DocsStateFact(
    state: 'Error / Empty',
    treatment:
        'Both replace the figure with an em dash '
        '(Semantics(label: "No value")) and swap the delta row for a '
        'message: error adds a triangle-alert icon, empty does not.',
    userSignal: 'An em dash and an explanatory message.',
  ),
  DocsStateFact(
    state: 'Disabled',
    treatment: '45% opacity, Semantics(enabled: false).',
    userSignal: 'Faded and marked unavailable to assistive tech.',
  ),
  DocsStateFact(
    state: 'Hover / Focus-visible / Pressed / Selected',
    treatment:
        'N/A: Stat owns no GestureDetector, FocusNode, or '
        'onPressed/enabled parameter. It is read, never touched.',
    userSignal: 'Nothing responds to a pointer or keyboard here.',
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment:
        'N/A: no AnimationController exists. ContentChange is a key-change '
        'replay, not a running animation to still.',
    userSignal: 'Nothing to still.',
  ),
];

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Semantic role: none of its own, Stat and StatDeltaMark '
            'render plain Column/Row widgets and static text via StyledText, '
            'with no custom Semantics wrapper.',
        'Delta direction is conveyed three ways, not colour alone. '
            'StatDeltaMark wraps the mark in '
            'Semantics(label: direction.word), where the word is "Up", '
            '"Down", or "No change": read before the number by assistive '
            'tech. The glyph shape (arrow up, arrow down, minus) and the '
            'sign character (+/−/nothing) provide two additional signals, '
            'so the direction reads even if colour is removed. This is '
            'Trap 11: a mark whose only difference is hue is one signal, '
            'not two.',
        'Blank states: Stat.build renders Semantics(label: "No value") '
            'around the em dash when state is error or empty, so the '
            'absence announces itself.',
        'Disabled: opacity 45% plus Semantics(enabled: false) makes '
            'disabled clear to assistive tech.',
        'Known platform differences: none observed.',
      ]);
}

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Never focusable: no Focus widget or FocusNode exists anywhere '
            'in stat.dart. Stat cannot receive keyboard focus and has '
            'no key binding.',
        'Not in the tab order: a keyboard user tabs straight past a '
            'Stat, whether it stands alone or sits inside a card '
            'header, because there is nothing here to land on.',
        'No activation: Stat takes no onPressed and no onTap of any '
            'kind. It is a figure to read, not a control to operate.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'No responsive branching: renders identically at 390px and '
            '1440px. The slot heights are fixed, the figure width is '
            'intrinsic to the string (subject to TextStyles.numberLg\'s own '
            'line breaking), and the label row and delta row wrap if '
            'needed.',
        'Platform parity: Android, iOS, Web, macOS, Windows, and Linux '
            'all render the same widget tree.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      DocsInstallFacts(
        facts: <DocsInstallFact>[
          const DocsInstallFact(
            label: 'Registry item',
            value: 'stat',
            description:
                'registry/components/stat.json exists and is installable '
                'through the CLI today.',
          ),
          const DocsInstallFact(
            label: 'Destination',
            value: 'lib/components/ui/stat.dart',
            description: 'Where a manual copy of the source file belongs.',
          ),
          DocsInstallFact(
            label: 'Dependencies',
            value: statDoc.dependencies.join(', '),
            description:
                "The manifest's registryDependencies, resolved "
                'automatically by the registry client: Icon for the '
                'delta glyphs, Skeleton for the loading placeholders, '
                'source-foundation for spacing/theme/typography, and the '
                'content-change motion effect for the loading-to-ready replay.',
          ),
          const DocsInstallFact(
            label: 'Assets',
            value: 'none',
            description: 'No images, icon fonts, or binary assets.',
          ),
          const DocsInstallFact(
            label: 'Shaders',
            value: 'none',
            description: 'No fragment-shader-backed paint.',
          ),
          const DocsInstallFact(
            label: 'Platforms',
            value: 'Android, iOS, Web, macOS, Windows, Linux',
            description: 'No platform-conditional code in stat.dart.',
          ),
          const DocsInstallFact(
            label: 'Verified',
            value: 'docs specimens only',
            description:
                "This page's live specimens and "
                'example/test/components_docs/stat_test.dart. No dedicated '
                'package-level unit test exists yet, and no registry '
                'fixture install was run as part of writing this page.',
          ),
        ],
      ),
      SizedBox(height: space(4)),
      const DocsLinkRow(
        links: <DocsLink>[
          DocsLink(label: 'Icon', route: '/components/icon'),
          DocsLink(label: 'Skeleton', route: '/components/skeleton'),
          DocsLink(
            label: 'Source Foundation',
            route: '/components/source_foundation',
          ),
          DocsLink(
            label: 'Content Change',
            route: '/components/content_change',
          ),
        ],
      ),
    ],
  );
}

class _ThemingContent extends StatelessWidget {
  const _ThemingContent();

  @override
  Widget build(BuildContext context) => DocsInstallFacts(
    title: 'What actually varies with the theme',
    facts: const <DocsInstallFact>[
      DocsInstallFact(
        label: 'StatDeltaMark ink',
        value: 'theme.successText / theme.foreground / theme.mutedForeground',
        description:
            'theme.successText when the move is favourable, '
            'theme.foreground when it is not, and theme.mutedForeground '
            'when flat. Flipping ThemeController between light and '
            'dark re-resolves all three.',
      ),
      DocsInstallFact(
        label: 'No colour override parameter',
        value: 'none',
        description:
            'Every colour is theme- or direction-derived, never a bare '
            'Color argument on Stat itself.',
      ),
    ],
  );
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
