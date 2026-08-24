/// Public documentation page for the `stat` component alone.
///
/// **Split from a merged page.** `stat/page.dart` used to document `stat`,
/// `item`, `empty`, and `kbd` together. `item`, `empty`, and `kbd` now have
/// real pages of their own (`lib/components_docs/item/`, `empty/`, `kbd/`);
/// this file keeps only what belongs to `ElStat`.
///
/// **`stat` has no shadcn counterpart** (`components/ui/stat.tsx` is this
/// system's own file, not a port), so every section below is ours-only and
/// named for what it does rather than mirrored from a reference page:
/// Composition (the one real leaf-widget tree plus a real composed shape),
/// Delta and direction, Loading/error/empty, RTL, matching the shape
/// `button/page.dart` established (unheaded live demo, Installation, Usage,
/// the component's own sections, API Reference last, then the six extra
/// sections).
///
/// [ComponentDocEntry.description] is the page's only rendered description;
/// no second hero paragraph renders beneath it.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/docs_code.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../kit.dart';
import 'meta.dart';

class StatDocPage extends StatelessWidget {
  const StatDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: statDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / BASE',
      title: statDoc.title,
      description: statDoc.description,
    ),
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Components'),
      ElBreadcrumbEntry.page('Stat'),
    ],
    sidebar: _sidebar,
    toc: const <DocsTocEntry>[
      DocsTocEntry(title: 'Installation', anchor: 'install'),
      DocsTocEntry(title: 'Usage', anchor: 'usage'),
      DocsTocEntry(title: 'Composition', anchor: 'composition'),
      DocsTocEntry(title: 'Delta and direction', anchor: 'delta'),
      DocsTocEntry(title: 'Loading, error, and empty', anchor: 'states-demo'),
      DocsTocEntry(title: 'RTL', anchor: 'rtl'),
      DocsTocEntry(title: 'API Reference', anchor: 'api'),
      DocsTocEntry(title: 'States', anchor: 'states'),
      DocsTocEntry(title: 'Accessibility', anchor: 'accessibility'),
      DocsTocEntry(title: 'Responsive', anchor: 'responsive'),
      DocsTocEntry(title: 'Dependencies', anchor: 'dependencies'),
      DocsTocEntry(title: 'Theming', anchor: 'theming'),
      DocsTocEntry(title: 'Source', anchor: 'source'),
    ],
    onNavigate: onNavigate,
    child: const _StatArticle(),
  );
}

/// The Wave 1 "base primitives" group this page belongs to (IA §7.3). Not
/// routes another worker's page is verified as wired: the supervisor
/// aggregates the real sidebar in `catalog.dart` and `site_routes.dart`.
const List<DocsSidebarEntry> _sidebar = <DocsSidebarEntry>[
  DocsSidebarEntry(title: 'Accordion', route: '/components/accordion'),
  DocsSidebarEntry(title: 'Alert', route: '/components/alert'),
  DocsSidebarEntry(title: 'Avatar', route: '/components/avatar'),
  DocsSidebarEntry(title: 'Badge', route: '/components/badge'),
  DocsSidebarEntry(title: 'Breadcrumb', route: '/components/breadcrumb'),
  DocsSidebarEntry(title: 'Checkbox', route: '/components/checkbox'),
  DocsSidebarEntry(title: 'Collapsible', route: '/components/collapsible'),
  DocsSidebarEntry(title: 'Progress', route: '/components/progress'),
  DocsSidebarEntry(title: 'Separator', route: '/components/separator'),
  DocsSidebarEntry(title: 'Skeleton', route: '/components/skeleton'),
  DocsSidebarEntry(title: 'Stat', route: '/components/stat', selected: true),
  DocsSidebarEntry(title: 'Switch', route: '/components/switch'),
  DocsSidebarEntry(title: 'Toggle', route: '/components/toggle'),
  DocsSidebarEntry(title: 'Tooltip', route: '/components/tooltip'),
];

class _StatArticle extends StatelessWidget {
  const _StatArticle();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      key: const ValueKey<String>('stat-doc-article'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _preview(theme),
        SizedBox(height: el(6)),
        _install(),
        SizedBox(height: el(6)),
        _usage(),
        _composition(),
        _delta(),
        _statesDemo(),
        _rtl(theme),
        _api(theme),
        _states(),
        _accessibility(theme),
        _responsive(theme),
        _dependencies(theme),
        _theming(theme),
        _source(),
      ],
    );
  }

  Widget _preview(ElThemeData theme) => DocsCodeExample(
    title: 'Stat',
    description:
        'ElStat renders a labelled metric figure with an optional delta and '
        'trailing hint. The metric sits in a fixed-height slot, the delta '
        'row is optional and wraps if it overflows, and the footprint is '
        'identical across every state (ready, loading, error, empty, '
        'disabled): the layout never reflows when the state changes. Reach '
        'for it on a dashboard, a summary card, or a data page to show a '
        'metric with direction: revenue with a trend, an uptime percentage '
        'with a change.',
    manualFiles: const <DocsCodeFile>[
      DocsCodeFile(
        path: 'lib/components/ui/stat.dart',
        code:
            "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
            '// Install with: elattar add stat',
      ),
    ],
    preview: KeyedSubtree(
      key: const ValueKey<String>('stat-preview'),
      child: ElPanel(
        child: Padding(
          padding: EdgeInsets.all(el(4)),
          child: ElStat(
            label: 'Revenue',
            value: '\$12,480',
            delta: (value: '8.2%', direction: ElStatDirection.up),
            hint: 'vs last month',
          ),
        ),
      ),
    ),
  );

  Widget _install() => ElSection(
    id: 'install',
    title: 'Installation',
    description:
        '`elattar add stat` installs the component and its declared '
        'dependency closure.',
    child: DocsInstallFacts(
      title: 'Installation facts',
      facts: <DocsInstallFact>[
        const DocsInstallFact(
          label: 'Registry item',
          value: 'registry/components/stat.json',
          description: 'Shipped and resolved by `elattar add stat`.',
        ),
        const DocsInstallFact(
          label: 'Destination',
          value: 'lib/components/ui/stat.dart',
          description: 'Where a manual copy of the source file belongs.',
        ),
        const DocsInstallFact(
          label: 'Foundation',
          value: 'source only',
          description: 'No package-backed alternative is offered yet.',
        ),
        const DocsInstallFact(
          label: 'Dependencies',
          value: 'source-foundation, motion, icon, skeleton',
          description:
              'ElStat needs spacing/theme/typography, the swap-in motion '
              'effect for its state transition, ElIcon for the delta '
              'glyphs, and ElSkeleton for the loading state. None of this '
              'is resolved automatically today; copy the imports by hand.',
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
          value: 'docs specimen only',
          description:
              'This page\'s live preview and '
              'example/test/components_docs/stat_test.dart. No dedicated '
              'package-level unit test and no registry fixture install '
              'exist yet.',
        ),
      ],
    ),
  );

  Widget _usage() => ElSection(
    id: 'usage',
    title: 'Usage',
    description: 'The smallest correct call, then a full metric.',
    child: ElPanel(
      label: 'DART',
      note: 'COMPOSE',
      child: DocsSelectableCodeBlock(code: _usageCode),
    ),
  );

  Widget _composition() => ElSection(
    id: 'composition',
    title: 'Composition',
    description:
        'ElStat is a single leaf: it takes data (label, value, delta, hint), '
        'not children, so there is no part-widget tree to assemble the way '
        'Item or Empty have. ElStatDeltaMark is the one piece exported '
        'separately, for a caller that already has its own label and wants '
        'to reuse just the direction mark (see API Reference). Below: the '
        'leaf\'s own shape, then one real composed use, a card header.',
    child: DocsCodeExample(
      title: 'ElStat on a card header',
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(
          path: 'stat_tree.txt',
          title: 'The leaf',
          code: '''ElStat
├─ label
├─ value
├─ delta        → ElStatDeltaMark (exported separately)
└─ hint / message''',
        ),
      ],
      preview: ElCard(
        children: <Widget>[
          ElCardContent(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ElStat(
                  label: 'Monthly revenue',
                  value: '\$52,840',
                  delta: (value: '12.5%', direction: ElStatDirection.up),
                  hint: 'vs last month',
                ),
                SizedBox(height: el(4)),
                const ElSeparator(),
                SizedBox(height: el(4)),
                ElText('In the last 30 days', ElType.small),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  Widget _delta() => ElSection(
    id: 'delta',
    title: 'Delta and direction',
    description:
        'Direction is conveyed three ways before colour is considered: the '
        'glyph\'s shape, the sign written onto the number, and a visually '
        'hidden word for assistive tech (see Accessibility). betterWhen '
        'chooses which direction earns the success ink; the other gets '
        'plain foreground, and flat is always muted.',
    child: ElPanel(
      label: 'PREVIEW',
      child: Wrap(
        spacing: el(10),
        runSpacing: el(6),
        children: <Widget>[
          const KeyedSubtree(
            key: ValueKey<String>('stat-example:up'),
            child: ElStat(
              label: 'Revenue',
              value: '\$12,480',
              delta: (value: '8.2%', direction: ElStatDirection.up),
              hint: 'vs last month',
            ),
          ),
          KeyedSubtree(
            key: const ValueKey<String>('stat-example:down'),
            child: ElStat(
              label: 'Refunds',
              value: '\$1,204',
              delta: (value: '3.1%', direction: ElStatDirection.down),
              betterWhen: ElStatDirection.down,
              hint: 'vs last month',
            ),
          ),
          const KeyedSubtree(
            key: ValueKey<String>('stat-example:flat'),
            child: ElStat(
              label: 'Signups',
              value: '482',
              delta: (value: '0.0%', direction: ElStatDirection.flat),
              hint: 'vs last month',
            ),
          ),
        ],
      ),
    ),
  );

  Widget _statesDemo() => ElSection(
    id: 'states-demo',
    title: 'Loading, error, and empty',
    description:
        'The figure slot holds the same line-box height in every state, so '
        'the layout never reflows when a metric moves from loading to '
        'ready. error and empty both replace the figure with an em dash and '
        'swap the delta row for a message; disabled dims the whole row and '
        'marks it Semantics(enabled: false).',
    child: ElPanel(
      label: 'PREVIEW',
      child: Wrap(
        spacing: el(10),
        runSpacing: el(6),
        children: <Widget>[
          const KeyedSubtree(
            key: ValueKey<String>('stat-example:loading'),
            child: ElStat(
              label: 'Revenue',
              value: '\$12,480',
              delta: (value: '8.2%', direction: ElStatDirection.up),
              state: ElStatState.loading,
            ),
          ),
          const KeyedSubtree(
            key: ValueKey<String>('stat-example:error'),
            child: ElStat(
              label: 'Uptime',
              value: 'N/A',
              state: ElStatState.error,
              message: 'Failed to load',
            ),
          ),
          const KeyedSubtree(
            key: ValueKey<String>('stat-example:empty'),
            child: ElStat(
              label: 'Uptime',
              value: 'N/A',
              state: ElStatState.empty,
              message: 'No data yet',
            ),
          ),
          KeyedSubtree(
            key: const ValueKey<String>('stat-example:disabled'),
            child: ElStat(
              label: 'Churn',
              value: '4.1%',
              delta: (value: '0.4%', direction: ElStatDirection.down),
              betterWhen: ElStatDirection.down,
              hint: 'vs last month',
              disabled: true,
            ),
          ),
        ],
      ),
    ),
  );

  Widget _rtl(ElThemeData theme) => ElSection(
    id: 'rtl',
    title: 'RTL',
    description:
        'ElStat paints no direction-specific layout of its own: it sizes '
        'to its content and reads right-to-left under a plain '
        'Directionality, the same composition either way.',
    child: ElPanel(
      label: 'PREVIEW',
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: const KeyedSubtree(
          key: ValueKey<String>('rtl-example:stat'),
          child: ElStat(
            label: 'الإيرادات',
            value: '\$12,480',
            delta: (value: '8.2%', direction: ElStatDirection.up),
            hint: 'مقارنة بالشهر الماضي',
          ),
        ),
      ),
    ),
  );

  Widget _api(ElThemeData theme) => ElSection(
    id: 'api',
    title: 'API Reference',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        KeyedSubtree(
          key: docsAnchorKey('api-elstat'),
          child: const DocsApiTable(
            title: 'ElStat',
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
                type: 'ElStatDelta?',
                description:
                    'Optional. Defaults to null. A record, (value: "8.2%", '
                    'direction: ElStatDirection.up). Presence reserves the '
                    'delta row even while loading.',
              ),
              DocsApiFact(
                name: 'betterWhen',
                type: 'ElStatDirection',
                description:
                    'Optional. Defaults to ElStatDirection.up. Which '
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
                type: 'ElStatState',
                description:
                    'Optional. Defaults to ElStatState.ready. Controls what '
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
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-elstat-static'),
          child: const DocsApiTable(
            title: 'ElStat static tokens',
            facts: <DocsApiFact>[
              DocsApiFact(
                name: 'ElStat.rowGap',
                type: 'static double',
                description: '8px: under the label, and under the figure slot.',
              ),
              DocsApiFact(
                name: 'ElStat.deltaGap',
                type: 'static double',
                description: '8px gap on the delta row (flex-wrap).',
              ),
              DocsApiFact(
                name: 'ElStat.messageGap',
                type: 'static double',
                description:
                    '6px gap between the error triangle-alert icon and its '
                    'message.',
              ),
              DocsApiFact(
                name: 'ElStat.figureSkeleton',
                type: 'static Size',
                description: '112px × 20px: the loading figure placeholder.',
              ),
              DocsApiFact(
                name: 'ElStat.deltaSkeleton',
                type: 'static Size',
                description: '56px × 10px: the loading delta placeholder.',
              ),
              DocsApiFact(
                name: 'ElStat.figureHeight',
                type: 'static double',
                description:
                    'The fixed line-box height the figure slot maintains '
                    'in every state: prevents reflow on loading → ready.',
              ),
            ],
          ),
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-elstatstate'),
          child: const DocsApiTable(
            title: 'ElStatState',
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
                    'Renders skeleton placeholders for the value and '
                    'delta, keeping the full slot height.',
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
                    'Renders an em dash and a plain-text message (no '
                    'icon).',
              ),
            ],
          ),
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-elstatdeltamark'),
          child: const DocsApiTable(
            title: 'ElStatDeltaMark',
            facts: <DocsApiFact>[
              DocsApiFact(
                name: 'delta',
                type: 'ElStatDelta',
                description:
                    'Required. The same record type ElStat.delta takes.',
              ),
              DocsApiFact(
                name: 'betterWhen',
                type: 'ElStatDirection',
                description:
                    'Required, not defaulted: a caller reaching for the '
                    'mark alone is already thinking about direction and '
                    'must say which one it means.',
              ),
              DocsApiFact(
                name: 'ElStatDeltaMark.gap',
                type: 'static double',
                description: '4px between the glyph and the sign+value text.',
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _states() => ElSection(
    id: 'states',
    title: 'States',
    description:
        'ElStat is the only one of the four former sibling components with '
        'a real state machine: this page rows read straight off the source.',
    child: const DocsStateMatrix(
      facts: <DocsStateFact>[
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
              'Renders skeleton placeholders for the value and delta, '
              'keeping the same figureHeight so the layout does not '
              'reflow. A ElSwapIn replay fires on the loading → ready '
              'transition (a key change, not an AnimationController).',
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
              'N/A: ElStat owns no GestureDetector, FocusNode, or '
              'onPressed/enabled parameter. It is read, never touched.',
          userSignal: 'Nothing responds to a pointer or keyboard here.',
        ),
        DocsStateFact(
          state: 'Reduced motion',
          treatment:
              'N/A: no AnimationController exists. ElSwapIn is a '
              'key-change replay, not a running animation to still.',
          userSignal: 'Nothing to still.',
        ),
      ],
    ),
  );

  Widget _accessibility(ElThemeData theme) => ElSection(
    id: 'accessibility',
    title: 'Accessibility',
    child: _bullets(theme, <String>[
      'Semantic role: none of its own, ElStat and ElStatDeltaMark render '
          'plain Column/Row widgets and static text via ElText, with no '
          'custom Semantics wrapper.',
      'Delta direction is conveyed three ways, not colour alone. '
          'ElStatDeltaMark wraps the mark in '
          'Semantics(label: direction.word), where the word is "Up", '
          '"Down", or "No change": read before the number by assistive '
          'tech. The glyph shape (arrow up, arrow down, minus) and the '
          'sign character (+/−/nothing) provide two additional signals, '
          'so the direction reads even if colour is removed. This is Trap '
          '11: a mark whose only difference is hue is one signal, not two.',
      'Blank states: ElStat.build renders Semantics(label: "No value") '
          'around the em dash when state is error or empty, so the '
          'absence announces itself.',
      'Disabled: opacity 45% plus Semantics(enabled: false) makes '
          'disabled clear to assistive tech.',
      'Keyboard: never focusable: no Focus widget or FocusNode exists.',
      'Known platform differences: none observed.',
    ]),
  );

  Widget _responsive(ElThemeData theme) => ElSection(
    id: 'responsive',
    title: 'Responsive',
    child: _bullets(theme, <String>[
      'No responsive branching: renders identically at 390px and 1440px. '
          'The slot heights are fixed, the figure width is intrinsic to '
          'the string (subject to ElType.numLg\'s own line breaking), and '
          'the label row and delta row wrap if needed.',
      'Platform parity: Android, iOS, Web, macOS, Windows, and Linux all '
          'render the same widget tree.',
    ]),
  );

  Widget _dependencies(ElThemeData theme) => ElSection(
    id: 'dependencies',
    title: 'Dependencies',
    child: _bullets(theme, <String>[
      'File: lib/src/components/stat.dart, one file, no companions.',
      'Imports: foundation/spacing.dart, foundation/theme.dart, '
          'foundation/typography.dart, motion/swap_in.dart (ElSwapIn), '
          'theme_scope.dart, icon.dart (ElIcon), icon_paths.g.dart '
          '(ElLucide), skeleton.dart (ElSkeleton).',
      'Assets: none. Fonts: none beyond the system type scale every '
          'ElText call already depends on. Shaders: none.',
    ]),
  );

  Widget _theming(ElThemeData theme) => ElSection(
    id: 'theming',
    title: 'Theming',
    child: _bullets(theme, <String>[
      'Every colour comes from the live theme. ElStatDeltaMark uses '
          'theme.successInk when the move is favourable, theme.foreground '
          'when it is not, and theme.mutedForeground when flat. Flipping '
          'ElThemeController between light and dark re-resolves all '
          'three.',
      'No colour-override parameter of its own: every colour is theme- '
          'or direction-derived, never a bare Color argument.',
    ]),
  );

  Widget _source() => ElSection(
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
              'No dedicated unit test exists for stat.dart in the package '
              'test suite as of this page.',
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
  );
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

const String _usageCode = '''
import 'package:elattar_design_system/elattar_design_system.dart';

// The smallest correct call.
ElStat(
  label: 'Revenue',
  value: '\$12,480',
)

// A full metric with delta and hint.
ElStat(
  label: 'Revenue',
  value: '\$12,480',
  delta: (value: '8.2%', direction: ElStatDirection.up),
  betterWhen: ElStatDirection.up,
  hint: 'vs last month',
)''';
