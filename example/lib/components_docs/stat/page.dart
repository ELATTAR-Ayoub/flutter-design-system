/// Public documentation page for four small presentational primitives:
/// `stat`, `item`, `empty`, and `kbd`.
///
/// Each is a focused composition: a labelled metric display with an optional
/// delta, a structured list row, an empty-state block, and a key-cap hint. All
/// four share one theme: static presentation with almost no state of its own.
/// This page documents all four together rather than four separate ones.
///
/// `stat` has no shadcn counterpart, so its sections below are named for what
/// they do rather than mirrored from a reference page. `item`, `empty`, and
/// `kbd` each have one (`ui.shadcn.com/docs/components/item`, `/empty`,
/// `/kbd`), and their promoted sections below carry a `Component: Section`
/// title, the same convention `separator/page.dart` uses for its own
/// `empty`/`kbd` coverage. Sections shadcn shows that this port genuinely
/// cannot do are skipped, not faked: see each section's own note.
///
/// None of the four has a registry manifest yet
/// (`registry/components/stat.json`, `item.json`, `empty.json`, `kbd.json` do
/// not exist): every install-facing panel below says so honestly rather than
/// presenting a CLI command that would fail.
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
    breadcrumbs: const <DsBreadcrumbEntry>[
      DsBreadcrumbEntry.link('Components'),
      DsBreadcrumbEntry.page('Stat'),
    ],
    sidebar: _sidebar,
    toc: const <DocsTocEntry>[
      DocsTocEntry(title: 'Installation', anchor: 'install'),
      DocsTocEntry(title: 'Usage', anchor: 'usage'),
      DocsTocEntry(title: 'Composition', anchor: 'composition'),
      DocsTocEntry(title: 'Stat: Delta and direction', anchor: 'stat-delta'),
      DocsTocEntry(
        title: 'Stat: Loading, error, and empty',
        anchor: 'stat-states',
      ),
      DocsTocEntry(title: 'Item: Item vs Field', anchor: 'item-vs-field'),
      DocsTocEntry(title: 'Item: Variant', anchor: 'item-variant'),
      DocsTocEntry(title: 'Item: Icon', anchor: 'item-icon'),
      DocsTocEntry(title: 'Item: Avatar', anchor: 'item-avatar'),
      DocsTocEntry(title: 'Item: Group', anchor: 'item-group'),
      DocsTocEntry(title: 'Empty: Input group', anchor: 'empty-input-group'),
      DocsTocEntry(title: 'Kbd: Group', anchor: 'kbd-group'),
      DocsTocEntry(title: 'Kbd: Button', anchor: 'kbd-button'),
      DocsTocEntry(title: 'Kbd: Input group', anchor: 'kbd-input-group'),
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

/// The Wave 1 "base primitives" group this page belongs to (IA §7.3), listed
/// in the plan's own order. These are not routes other workers are producing
/// this same wave verified as wired: the supervisor aggregates the real
/// sidebar in `catalog.dart` and `site_routes.dart`.
const List<DocsSidebarEntry> _sidebar = <DocsSidebarEntry>[
  DocsSidebarEntry(title: 'Accordion', route: '/components/accordion'),
  DocsSidebarEntry(title: 'Alert', route: '/components/alert'),
  DocsSidebarEntry(title: 'Avatar', route: '/components/avatar'),
  DocsSidebarEntry(title: 'Badge', route: '/components/badge'),
  DocsSidebarEntry(title: 'Breadcrumb', route: '/components/breadcrumb'),
  DocsSidebarEntry(title: 'Checkbox', route: '/components/checkbox'),
  DocsSidebarEntry(title: 'Collapsible', route: '/components/collapsible'),
  DocsSidebarEntry(title: 'Progress', route: '/components/progress'),
  DocsSidebarEntry(
    title: 'Separator, Empty & Kbd',
    route: '/components/separator',
  ),
  DocsSidebarEntry(title: 'Skeleton', route: '/components/skeleton'),
  DocsSidebarEntry(title: 'Switch', route: '/components/switch'),
  DocsSidebarEntry(title: 'Toggle', route: '/components/toggle'),
  DocsSidebarEntry(title: 'Tooltip', route: '/components/tooltip'),
];

class _StatArticle extends StatelessWidget {
  const _StatArticle();

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Column(
      key: const ValueKey<String>('stat-doc-article'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _preview(theme),
        _install(),
        _usage(),
        _composition(),
        _statDelta(),
        _statStates(),
        _itemVsField(),
        _itemVariant(),
        _itemIcon(),
        _itemAvatar(),
        _itemGroup(),
        _emptyInputGroup(),
        _kbdGroup(),
        _kbdButton(),
        _kbdInputGroup(),
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

  /// The live-demo slot shadcn's own component pages render before their
  /// first heading: this port's `DsSection` always carries a heading, so
  /// `Preview` stands in for it, carrying the framing prose for all four
  /// primitives (what each is, when to reach for it) ahead of one
  /// representative specimen of each.
  Widget _preview(DsThemeData theme) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: DsWidths.prose),
        child: DsText(
          'One representative specimen of each: a revenue metric with a trend, '
        'a history card row, a no-results empty state, and a shortcut hint.',
          DsType.body,
        ),
      ),
      SizedBox(height: ds(6)),
      Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: DsWidths.prose),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DsText(
                'Four components that share one theme: almost no state, and '
                'a single visual job each. None of the four owns a '
                'GestureDetector, a FocusNode, or an async flag anywhere in '
                'its build method: every row below that looks empty in the '
                'State matrix is empty for that reason, not because the '
                'template was left unfilled.',
                DsType.body,
              ),
              SizedBox(height: ds(5)),
              DsText('Stat', DsType.h4, color: theme.foreground),
              SizedBox(height: ds(2)),
              DsText(
                'DsStat renders a labelled metric figure with an optional '
                'delta and trailing hint. The metric sits in a fixed-height '
                'slot, the delta row is optional and wraps if the delta '
                'overflows, and the footprint is identical across all '
                'states (ready, loading, error, empty, disabled): the '
                'layout does not reflow when the state changes.',
                DsType.body,
              ),
              SizedBox(height: ds(2)),
              DsText(
                'Reach for it on a dashboard, a summary card, or a data page '
                'to show a metric with direction: revenue with a trend, an '
                'uptime percentage with a change. Use DsStatState.empty or '
                '.error and a message to explain why the value is not '
                'available.',
                DsType.body,
              ),
              SizedBox(height: ds(5)),
              DsText('Item', DsType.h4, color: theme.foreground),
              SizedBox(height: ds(2)),
              DsText(
                'DsItem is a structured list row: optional media (usually an '
                'icon), required content (usually a title and description), '
                'and optional actions. The row carries a border option '
                '(normal, outline, muted) and an alignment override (center '
                'or top).',
                DsType.body,
              ),
              SizedBox(height: ds(2)),
              DsText(
                'Reach for it over a bare Row when the content has a '
                'standard shape: icon, title, description, buttons, and the '
                'container needs semantic consistency across several rows. '
                'DsItemGroup is the list wrapper: it enforces a vertical gap '
                'and stretches all children to the column width.',
                DsType.body,
              ),
              SizedBox(height: ds(5)),
              DsText('Empty', DsType.h4, color: theme.foreground),
              SizedBox(height: ds(2)),
              DsText(
                'DsEmpty is a structured empty state: an optional media '
                'tile, a title, a description, and one clear way out '
                '(DsEmptyContent), centred in a column with 16px between '
                'its parts.',
                DsType.body,
              ),
              SizedBox(height: ds(2)),
              DsText(
                'Reach for it whenever a collection, search, or workspace '
                'has nothing to show and the user needs to know why and '
                'what to do next. Reach for a spinner or skeleton instead '
                'when the empty appearance is temporary.',
                DsType.body,
              ),
              SizedBox(height: ds(5)),
              DsText('Kbd', DsType.h4, color: theme.foreground),
              SizedBox(height: ds(2)),
              DsText(
                'DsKbd renders a 20px-tall, 20px-minimum-wide key cap: muted '
                'fill, 6px corners, 12px/500 label, inert to touch and text '
                'selection.',
                DsType.body,
              ),
              SizedBox(height: ds(2)),
              DsText(
                'Reach for it when the content is a literal key the reader '
                'would press, Ctrl, K, Esc: never a status word (that is '
                'DsBadge) or a code snippet. DsKbdGroup composes several '
                'keys into one shortcut and merges their semantics into a '
                'single announcement.',
                DsType.body,
              ),
            ],
          ),
        ),
        SizedBox(height: ds(6)),
        DocsCodeExample(
          title: 'Stat, Item, Empty, and Kbd specimens',
          manualFiles: const <DocsCodeFile>[
            DocsCodeFile(
              path: 'lib/components/ui/stat.dart',
              code:
                  "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
                  '// None of the four has a registry manifest yet: copy\n'
                  '// lib/src/components/stat.dart, item.dart, empty.dart, and\n'
                  '// kbd.dart from the package source directly. There is no\n'
                  '// generated CLI payload to fetch.',
            ),
          ],
          preview: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DsText('Stat: a metric with direction', DsType.label),
              SizedBox(height: ds(3)),
              KeyedSubtree(
                key: const ValueKey<String>('stat-preview'),
                child: DsPanel(
                  child: Padding(
                    padding: EdgeInsets.all(ds(4)),
                    child: DsStat(
                      label: 'Revenue',
                      value: '\$12,480',
                      delta: (value: '8.2%', direction: DsStatDirection.up),
                      hint: 'vs last month',
                    ),
                  ),
                ),
              ),
              SizedBox(height: ds(8)),
              DsText('Item: a structured list row', DsType.label),
              SizedBox(height: ds(3)),
              KeyedSubtree(
                key: const ValueKey<String>('item-preview'),
                child: DsItem(
                  media: DsItemMedia(
                    child: DsIcon.lucide(
                      DsLucide.messageSquare,
                      size: DsIconSize.sm,
                      tone: DsIconTone.normal,
                    ),
                  ),
                  content: DsItemContent(
                    children: <Widget>[
                      const DsItemTitle('Draft response'),
                      DsItemDescription(
                        'You started typing something here on August 14',
                      ),
                    ],
                  ),
                  actions: DsItemActions(
                    children: <Widget>[
                      DsButton(
                        variant: DsButtonVariant.ghost,
                        size: DsButtonSize.sm,
                        onPressed: () {},
                        child: DsText('Edit', DsComponentType.buttonLabel),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: ds(8)),
              DsText('Empty: no results, with a way out', DsType.label),
              SizedBox(height: ds(3)),
              KeyedSubtree(
                key: const ValueKey<String>('empty-preview'),
                child: DsEmpty(
                  children: <Widget>[
                    const DsEmptyHeader(
                      children: <Widget>[
                        DsEmptyMedia(
                          glyph: DsIconGlyph.search,
                          tone: DsIconTone.subtle,
                        ),
                        DsEmptyTitle('No results found'),
                        DsEmptyDescription(
                          'Try a different search term or clear your filters.',
                        ),
                      ],
                    ),
                    DsEmptyContent(
                      children: <Widget>[
                        DsButton(
                          variant: DsButtonVariant.secondary,
                          size: DsButtonSize.sm,
                          onPressed: () {},
                          child: DsText(
                            'Clear filters',
                            DsComponentType.buttonLabel,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: ds(8)),
              DsText('Kbd: shortcut hints', DsType.label),
              SizedBox(height: ds(3)),
              KeyedSubtree(
                key: const ValueKey<String>('kbd-preview'),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    DsRow(
                      children: <Widget>[
                        const DsKbdGroup(
                          children: <Widget>[DsKbd('Ctrl'), DsKbd('K')],
                        ),
                        DsText('Open search', DsType.small),
                      ],
                    ),
                    SizedBox(height: ds(4)),
                    DsRow(
                      children: <Widget>[
                        const DsKbd('Esc'),
                        DsText('Close dialog', DsType.small),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
    ],
  );

  Widget _install() => DsSection(
    id: 'install',
    title: 'Installation',
    description:
        'None of the four has a registry manifest yet, so `elattar add stat` / '
        '`item` / `empty` / `kbd` is not available: install by copying the '
        'source files manually.',
    child: DocsInstallFacts(
      title: 'Installation facts',
      facts: <DocsInstallFact>[
        const DocsInstallFact(
          label: 'Registry item',
          value: 'not yet registered (×4)',
          description:
              'No registry/components/stat.json, item.json, empty.json, or '
              'kbd.json exists. All four are source-only today.',
        ),
        const DocsInstallFact(
          label: 'Destination',
          value: 'lib/components/ui/stat.dart, item.dart, empty.dart, kbd.dart',
          description: 'Where a manual copy of each source file belongs.',
        ),
        const DocsInstallFact(
          label: 'Foundation',
          value: 'source only',
          description: 'No package-backed alternative is offered yet.',
        ),
        const DocsInstallFact(
          label: 'Dependencies',
          value:
              'source-foundation; stat → motion; item → no deps; empty → '
              'icon; kbd → machine-surface',
          description:
              'Stat, Item, Empty, and Kbd all need spacing/theme/typography. '
              'Stat additionally needs the swap-in motion effect. Empty needs '
              'the icon component (DsEmptyMedia renders a DsIcon). Kbd needs '
              'the machine-surface effect for its background. None of this is '
              'resolved automatically today; copy the imports by hand.',
        ),
        const DocsInstallFact(
          label: 'Assets',
          value: 'none',
          description: 'No images, icon fonts, or binary assets.',
        ),
        const DocsInstallFact(
          label: 'Shaders',
          value: 'none',
          description:
              'Kbd\'s machine surface renders a flat fill and border, not a '
              'fragment shader.',
        ),
        DocsInstallFact(
          label: 'Platforms',
          value: 'Android, iOS, Web, macOS, Windows, Linux',
          description:
              'No platform-conditional code in stat.dart, item.dart, '
              'empty.dart, or kbd.dart.',
        ),
        const DocsInstallFact(
          label: 'Verified',
          value: 'docs specimen only',
          description:
              'This page\'s live preview and '
              'example/test/components_docs/stat_test.dart. No dedicated '
              'package-level unit test and no registry fixture install exist '
              'yet for any of the four: there is nothing to install.',
        ),
      ],
    ),
  );

  Widget _usage() => DsSection(
    id: 'usage',
    title: 'Usage',
    description: 'The smallest correct call for each, then the shapes above.',
    child: DsPanel(
      label: 'DART',
      note: 'COMPOSE',
      child: DocsSelectableCodeBlock(code: _usageCode),
    ),
  );

  /// shadcn shows Composition as a tree diagram for Item, Empty, and Kbd;
  /// Stat's own counterpart page has no such section, since Stat has no
  /// counterpart page at all. Below is the same idea for all four: the tree
  /// each one nests into, read top down, then one real composed shape (a
  /// card header that reaches for DsStat, not a list of parts).
  Widget _composition() => DsSection(
    id: 'composition',
    title: 'Composition',
    description:
        'None of the four has a size or variant axis that reshapes the '
        'tree: Empty and Kbd get their shape entirely from which parts a '
        'caller includes, Item\'s only axis is the border (see Item: '
        'Variant), and Stat is a single leaf that takes data, not children.',
    child: DocsCodeExample(
      title: 'Composed with other primitives',
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(
          path: 'stat_tree.txt',
          title: 'Stat',
          description: 'A leaf widget: no nested part-widgets to assemble.',
          code: '''DsStat
├─ label
├─ value
├─ delta        → DsStatDeltaMark (exported separately, see API Reference)
└─ hint / message''',
        ),
        DocsCodeFile(
          path: 'item_tree.txt',
          title: 'Item',
          code: '''DsItemGroup
└─ DsItem
   ├─ DsItemMedia      (optional)
   ├─ DsItemContent
   │  ├─ DsItemTitle
   │  └─ DsItemDescription
   └─ DsItemActions    (optional)''',
        ),
        DocsCodeFile(
          path: 'empty_tree.txt',
          title: 'Empty',
          code: '''DsEmpty
├─ DsEmptyHeader
│  ├─ DsEmptyMedia        (optional)
│  ├─ DsEmptyTitle
│  └─ DsEmptyDescription
└─ DsEmptyContent''',
        ),
        DocsCodeFile(
          path: 'kbd_tree.txt',
          title: 'Kbd',
          code: '''DsKbdGroup
├─ DsKbd
└─ DsKbd    (one or more)''',
        ),
      ],
      preview: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DsText('Stat on a card header', DsType.label),
          SizedBox(height: ds(3)),
          DsCard(
            children: <Widget>[
              DsCardContent(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    DsStat(
                      label: 'Monthly revenue',
                      value: '\$52,840',
                      delta: (value: '12.5%', direction: DsStatDirection.up),
                      hint: 'vs last month',
                    ),
                    SizedBox(height: ds(4)),
                    const DsSeparator(),
                    SizedBox(height: ds(4)),
                    DsText('In the last 30 days', DsType.small),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  Widget _statDelta() => DsSection(
    id: 'stat-delta',
    title: 'Stat: Delta and direction',
    description:
        'Direction is conveyed three ways before colour is considered: the '
        'glyph\'s shape, the sign written onto the number, and a visually '
        'hidden word for assistive tech (see Accessibility). betterWhen '
        'chooses which direction earns the success ink; the other gets plain '
        'foreground, and flat is always muted.',
    child: DsPanel(
      label: 'PREVIEW',
      child: Wrap(
        spacing: ds(10),
        runSpacing: ds(6),
        children: <Widget>[
          const KeyedSubtree(
            key: ValueKey<String>('stat-example:up'),
            child: DsStat(
              label: 'Revenue',
              value: '\$12,480',
              delta: (value: '8.2%', direction: DsStatDirection.up),
              hint: 'vs last month',
            ),
          ),
          KeyedSubtree(
            key: const ValueKey<String>('stat-example:down'),
            child: DsStat(
              label: 'Refunds',
              value: '\$1,204',
              delta: (value: '3.1%', direction: DsStatDirection.down),
              betterWhen: DsStatDirection.down,
              hint: 'vs last month',
            ),
          ),
          const KeyedSubtree(
            key: ValueKey<String>('stat-example:flat'),
            child: DsStat(
              label: 'Signups',
              value: '482',
              delta: (value: '0.0%', direction: DsStatDirection.flat),
              hint: 'vs last month',
            ),
          ),
        ],
      ),
    ),
  );

  Widget _statStates() => DsSection(
    id: 'stat-states',
    title: 'Stat: Loading, error, and empty',
    description:
        'The figure slot holds the same line-box height in every state, so '
        'the layout never reflows when a metric moves from loading to ready. '
        'error and empty both replace the figure with an em dash and swap '
        'the delta row for a message; disabled dims the whole row and marks '
        'it Semantics(enabled: false).',
    child: DsPanel(
      label: 'PREVIEW',
      child: Wrap(
        spacing: ds(10),
        runSpacing: ds(6),
        children: <Widget>[
          const KeyedSubtree(
            key: ValueKey<String>('stat-example:loading'),
            child: DsStat(
              label: 'Revenue',
              value: '\$12,480',
              delta: (value: '8.2%', direction: DsStatDirection.up),
              state: DsStatState.loading,
            ),
          ),
          const KeyedSubtree(
            key: ValueKey<String>('stat-example:error'),
            child: DsStat(
              label: 'Uptime',
              value: 'N/A',
              state: DsStatState.error,
              message: 'Failed to load',
            ),
          ),
          const KeyedSubtree(
            key: ValueKey<String>('stat-example:empty'),
            child: DsStat(
              label: 'Uptime',
              value: 'N/A',
              state: DsStatState.empty,
              message: 'No data yet',
            ),
          ),
          KeyedSubtree(
            key: const ValueKey<String>('stat-example:disabled'),
            child: DsStat(
              label: 'Churn',
              value: '4.1%',
              delta: (value: '0.4%', direction: DsStatDirection.down),
              betterWhen: DsStatDirection.down,
              hint: 'vs last month',
              disabled: true,
            ),
          ),
        ],
      ),
    ),
  );

  Widget _itemVsField() => DsSection(
    id: 'item-vs-field',
    title: 'Item: Item vs Field',
    description:
        'Both stack a label-like part over supporting text, and it is easy '
        'to reach for the wrong one.',
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: DsWidths.prose),
      child: DsText(
        'DsItem is a display row: media, a title, a description, and '
        'actions, with no form semantics and no validation state. DsField '
        '(documented on its own page) is a form control wrapper: it owns a '
        'label, a control, a description, and an error, wired so a screen '
        'reader announces them as one field with Semantics(hint:) and '
        'Semantics(validationResult:). Reach for DsItem for a notification, '
        'a search result, or a list row a user reads. Reach for DsField the '
        'moment the row holds something the user types into, checks, or '
        'submits.',
        DsType.body,
      ),
    ),
  );

  Widget _itemVariant() => DsSection(
    id: 'item-variant',
    title: 'Item: Variant',
    description:
        'DsItemVariant is Item\'s only enum: no separate size axis exists '
        '(sm and xs are byte-identical to the default and were never built; '
        'see API Reference).',
    child: DsPanel(
      label: 'PREVIEW',
      child: DsItemGroup(
        children: <Widget>[
          KeyedSubtree(
            key: const ValueKey<String>('item-example:variant-normal'),
            child: const DsItem(
              content: DsItemContent(
                children: <Widget>[
                  DsItemTitle('Normal'),
                  DsItemDescription('border-transparent: no border, no fill.'),
                ],
              ),
            ),
          ),
          KeyedSubtree(
            key: const ValueKey<String>('item-example:variant-outline'),
            child: const DsItem(
              variant: DsItemVariant.outline,
              content: DsItemContent(
                children: <Widget>[
                  DsItemTitle('Outline'),
                  DsItemDescription('A 1px border in theme.border.'),
                ],
              ),
            ),
          ),
          KeyedSubtree(
            key: const ValueKey<String>('item-example:variant-muted'),
            child: const DsItem(
              variant: DsItemVariant.muted,
              content: DsItemContent(
                children: <Widget>[
                  DsItemTitle('Muted'),
                  DsItemDescription('A semi-transparent muted fill.'),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _itemIcon() => DsSection(
    id: 'item-icon',
    title: 'Item: Icon',
    description:
        'DsItemMedia forces its child into a 16px square and, whenever the '
        'row carries a description, nudges it 2px down so it lines up with '
        'the title\'s cap height instead of the row\'s centre.',
    child: DsPanel(
      label: 'PREVIEW',
      child: KeyedSubtree(
        key: const ValueKey<String>('item-example:icon'),
        child: DsItem(
          media: DsItemMedia(
            child: DsIcon.lucide(
              DsLucide.bell,
              size: DsIconSize.sm,
              tone: DsIconTone.normal,
            ),
          ),
          content: const DsItemContent(
            children: <Widget>[
              DsItemTitle('New comment'),
              DsItemDescription('Sarah replied to your thread'),
            ],
          ),
        ),
      ),
    ),
  );

  Widget _itemAvatar() => DsSection(
    id: 'item-avatar',
    title: 'Item: Avatar',
    description:
        'DsItemMedia takes any widget, including DsAvatar: passing '
        'sizePx: DsItemMedia.size keeps the fallback initials centred in '
        'the same 16px square an icon would occupy, instead of relying on '
        'the forced square to squash a larger default.',
    child: DsPanel(
      label: 'PREVIEW',
      child: KeyedSubtree(
        key: const ValueKey<String>('item-example:avatar'),
        child: DsItem(
          media: DsItemMedia(
            child: DsAvatar(fallback: 'JD', sizePx: DsItemMedia.size),
          ),
          content: const DsItemContent(
            children: <Widget>[
              DsItemTitle('Jordan Diaz'),
              DsItemDescription('Commented 2 hours ago'),
            ],
          ),
        ),
      ),
    ),
  );

  Widget _itemGroup() => DsSection(
    id: 'item-group',
    title: 'Item: Group',
    description:
        'DsItemGroup is the list wrapper: it enforces a vertical gap and '
        'stretches every row to the column width. The gap tightens from '
        '10px to a hidden 2.5px when the rows contain size=sm buttons, a '
        'CSS descendant-selector quirk reproduced as measured (see '
        'Theming).',
    child: DsPanel(
      label: 'PREVIEW',
      child: KeyedSubtree(
        key: const ValueKey<String>('item-example:group'),
        child: DsItemGroup(
          children: <Widget>[
            DsItem(
              media: DsItemMedia(
                child: DsIcon.lucide(DsLucide.fileText, size: DsIconSize.sm),
              ),
              content: const DsItemContent(
                children: <Widget>[
                  DsItemTitle('Quarterly report'),
                  DsItemDescription('Jan 1 – Mar 31, 2026'),
                ],
              ),
            ),
            DsItem(
              media: DsItemMedia(
                child: DsIcon.lucide(DsLucide.download, size: DsIconSize.sm),
              ),
              content: const DsItemContent(
                children: <Widget>[DsItemTitle('Download Q4 data')],
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _emptyInputGroup() => DsSection(
    id: 'empty-input-group',
    title: 'Empty: Input group',
    description:
        'DsEmptyContent\'s "way out" does not have to be a button: any '
        'widget is a valid child, including a DsInputGroup that lets the '
        'reader search again in place.',
    child: DsPanel(
      label: 'PREVIEW',
      child: KeyedSubtree(
        key: const ValueKey<String>('empty-example:input-group'),
        child: DsEmpty(
          children: <Widget>[
            const DsEmptyHeader(
              children: <Widget>[
                DsEmptyMedia(
                  glyph: DsIconGlyph.search,
                  tone: DsIconTone.subtle,
                ),
                DsEmptyTitle('No components matched'),
                DsEmptyDescription(
                  'Try a different name, or browse the full catalog.',
                ),
              ],
            ),
            DsEmptyContent(
              children: <Widget>[
                DsInputGroup(
                  startAddon: DsInputGroupAddon(
                    child: DsIcon(
                      DsIconGlyph.search,
                      size: DsIconSize.sm,
                      tone: DsIconTone.inherit,
                    ),
                  ),
                  child: const DsInputGroupInput(
                    placeholder: 'Search components...',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );

  Widget _kbdGroup() => DsSection(
    id: 'kbd-group',
    title: 'Kbd: Group',
    description:
        'DsKbdGroup composes several keys into one shortcut, read by '
        'assistive tech as a single combination rather than unrelated '
        'letters (see Accessibility).',
    child: DsPanel(
      label: 'PREVIEW',
      child: KeyedSubtree(
        key: const ValueKey<String>('kbd-example:group'),
        child: DsRow(
          children: <Widget>[
            const DsKbdGroup(
              children: <Widget>[DsKbd('⌘'), DsKbd('⇧'), DsKbd('P')],
            ),
            DsText('Command palette', DsType.small),
          ],
        ),
      ),
    ),
  );

  Widget _kbdButton() => DsSection(
    id: 'kbd-button',
    title: 'Kbd: Button',
    description:
        'A DsKbd composed inside a DsButton\'s own child, so the key cap '
        'rides along with the label as one control.',
    child: DsPanel(
      label: 'PREVIEW',
      child: KeyedSubtree(
        key: const ValueKey<String>('kbd-example:button'),
        child: DsButton(
          onPressed: () {},
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              DsText('Save', DsComponentType.buttonLabel),
              SizedBox(width: ds(2)),
              const DsKbd('⌘S'),
            ],
          ),
        ),
      ),
    ),
  );

  Widget _kbdInputGroup() => DsSection(
    id: 'kbd-input-group',
    title: 'Kbd: Input group',
    description:
        'A DsKbd inside a DsInputGroupAddon, hinting at the shortcut that '
        'focuses the field it sits in.',
    child: DsPanel(
      label: 'PREVIEW',
      child: KeyedSubtree(
        key: const ValueKey<String>('kbd-example:input-group'),
        child: DsInputGroup(
          endAddon: const DsInputGroupAddon(
            align: DsInputGroupAlign.end,
            child: DsKbd('⌘K'),
          ),
          child: const DsInputGroupInput(placeholder: 'Jump to component...'),
        ),
      ),
    ),
  );

  Widget _rtl(DsThemeData theme) => DsSection(
    id: 'rtl',
    title: 'RTL',
    description:
        'None of the four paints direction-specific layout of its own: '
        'each sizes to its content and reads right-to-left under a plain '
        'Directionality, the same composition either way.',
    child: DsPanel(
      label: 'PREVIEW',
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            DsText('Item', DsType.label, color: theme.actionInk),
            SizedBox(height: ds(3)),
            const KeyedSubtree(
              key: ValueKey<String>('rtl-example:item'),
              child: DsItem(
                content: DsItemContent(
                  children: <Widget>[
                    DsItemTitle('المستند النهائي'),
                    DsItemDescription('تم التحديث اليوم'),
                  ],
                ),
              ),
            ),
            SizedBox(height: ds(6)),
            DsText('Empty', DsType.label, color: theme.actionInk),
            SizedBox(height: ds(3)),
            KeyedSubtree(
              key: const ValueKey<String>('rtl-example:empty'),
              child: DsEmpty(
                children: <Widget>[
                  const DsEmptyHeader(
                    children: <Widget>[
                      DsEmptyMedia(glyph: DsIconGlyph.search),
                      DsEmptyTitle('لا توجد نتائج'),
                      DsEmptyDescription('جرب كلمة بحث مختلفة.'),
                    ],
                  ),
                  DsEmptyContent(
                    children: <Widget>[
                      DsButton(
                        variant: DsButtonVariant.secondary,
                        size: DsButtonSize.sm,
                        onPressed: () {},
                        child: DsText(
                          'مسح الفلاتر',
                          DsComponentType.buttonLabel,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: ds(6)),
            DsText('Kbd', DsType.label, color: theme.actionInk),
            SizedBox(height: ds(3)),
            KeyedSubtree(
              key: const ValueKey<String>('rtl-example:kbd'),
              child: DsRow(
                children: <Widget>[
                  const DsKbdGroup(
                    children: <Widget>[DsKbd('Ctrl'), DsKbd('K')],
                  ),
                  DsText('فتح البحث', DsType.small),
                ],
              ),
            ),
            SizedBox(height: ds(6)),
            DsText('Stat', DsType.label, color: theme.actionInk),
            SizedBox(height: ds(3)),
            const KeyedSubtree(
              key: ValueKey<String>('rtl-example:stat'),
              child: DsStat(
                label: 'الإيرادات',
                value: '\$12,480',
                delta: (value: '8.2%', direction: DsStatDirection.up),
                hint: 'مقارنة بالشهر الماضي',
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _api(DsThemeData theme) => DsSection(
    id: 'api',
    title: 'API Reference',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const DocsApiTable(
          title: 'Stat properties',
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
                  'Required. The figure to display, "\$12,480". '
                  'Slot height is fixed regardless of content.',
            ),
            DocsApiFact(
              name: 'delta',
              type: 'DsStatDelta?',
              description:
                  'Optional. A value and direction (up/down/flat), '
                  '(value: "8.2%", direction: DsStatDirection.up). '
                  'Presence reserves the delta row even while loading.',
            ),
            DocsApiFact(
              name: 'betterWhen',
              type: 'DsStatDirection',
              description:
                  'Defaults to up. Determines which direction gets the '
                  'success ink (green); the other gets foreground. Flat is '
                  'always muted.',
            ),
            DocsApiFact(
              name: 'hint',
              type: 'String?',
              description:
                  'Optional comparison, one word or phrase, "vs last month". '
                  'Shown below the delta when the state is ready.',
            ),
            DocsApiFact(
              name: 'state',
              type: 'DsStatState',
              description:
                  'Defaults to ready. Controls what the figure and delta '
                  'render as: a skeleton while loading, an em dash while '
                  'error or empty, the real value while ready.',
            ),
            DocsApiFact(
              name: 'message',
              type: 'String?',
              description:
                  'Optional. Shown in the delta row while error (with a '
                  'triangle-alert icon) or empty. Replaces hint in those '
                  'states.',
            ),
            DocsApiFact(
              name: 'disabled',
              type: 'bool',
              description:
                  'Defaults to false. Sets opacity and disables the semantics '
                  'enabled flag when true.',
            ),
          ],
        ),
        SizedBox(height: ds(6)),
        const DocsApiTable(
          title: 'Stat static tokens and mark class',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'DsStat.rowGap / .deltaGap / .messageGap',
              type: 'static double',
              description:
                  '8px gap under label and under figure, 8px gap in the delta '
                  'row (flex-wrap), 12px gap between error icon and message.',
            ),
            DocsApiFact(
              name: 'DsStat.figureSkeleton / .deltaSkeleton',
              type: 'static Size',
              description: '112px × 20px figure skeleton, 56px × 10px delta.',
            ),
            DocsApiFact(
              name: 'DsStat.figureHeight',
              type: 'static double',
              description:
                  'Fixed line-box height the figure slot maintains in every '
                  'state: prevents reflow when loading → ready.',
            ),
            DocsApiFact(
              name: 'DsStatDeltaMark',
              type: 'StatelessWidget',
              description:
                  'Exported for callers that already have a label and want to '
                  'reuse just the direction mark. Takes required delta and '
                  'betterWhen parameters.',
            ),
          ],
        ),
        SizedBox(height: ds(6)),
        const DocsApiTable(
          title: 'DsStatState',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'ready',
              type: 'the default',
              description:
                  'Renders the value, the delta mark, and the hint: the full '
                  'metric.',
            ),
            DocsApiFact(
              name: 'loading',
              type: 'skeleton state',
              description:
                  'Renders skeleton placeholders for the value and delta, '
                  'keeping the full slot height so the layout does not '
                  'reflow.',
            ),
            DocsApiFact(
              name: 'error',
              type: 'blank state',
              description:
                  'Renders an em dash in the value slot and the error message '
                  'with a triangle-alert icon in the delta row.',
            ),
            DocsApiFact(
              name: 'empty',
              type: 'blank state',
              description:
                  'Renders an em dash and a plain-text message (no icon) in '
                  'the delta row.',
            ),
          ],
        ),
        SizedBox(height: ds(6)),
        const DocsApiTable(
          title: 'Item family properties',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'DsItemGroup.children',
              type: 'List<Widget>',
              description: 'Required. List rows, joined by a gap.',
            ),
            DocsApiFact(
              name: 'DsItemGroup.gapOverride',
              type: 'double?',
              description:
                  'Optional. Overrides the default gap for this group only. '
                  'Used when a call site has tighter spacing.',
            ),
            DocsApiFact(
              name: 'DsItem.media',
              type: 'Widget?',
              description:
                  'Optional. Usually a DsItemMedia with an icon or avatar. '
                  'Sits at the row start.',
            ),
            DocsApiFact(
              name: 'DsItem.content',
              type: 'Widget',
              description:
                  'Required. Usually DsItemContent with title and description. '
                  'Fills the middle space.',
            ),
            DocsApiFact(
              name: 'DsItem.actions',
              type: 'Widget?',
              description:
                  'Optional. Usually DsItemActions with buttons. Sits at the '
                  'row end.',
            ),
            DocsApiFact(
              name: 'DsItem.variant',
              type: 'DsItemVariant',
              description:
                  'Defaults to normal. Selects the border: transparent, '
                  'border colour, or muted fill. Item\'s only enum: no '
                  'separate size axis (sm/xs are byte-identical to default, '
                  'not built).',
            ),
            DocsApiFact(
              name: 'DsItem.alignStart',
              type: 'bool',
              description:
                  'Defaults to false. When true, aligns media and actions to '
                  'the top instead of the center.',
            ),
            DocsApiFact(
              name: 'DsItemContent.children',
              type: 'List<Widget>',
              description:
                  'Required. Usually DsItemTitle and DsItemDescription, '
                  'joined by a 4px gap.',
            ),
            DocsApiFact(
              name: 'DsItemActions.children',
              type: 'List<Widget>',
              description:
                  'Required. Buttons or other controls, joined by an 8px gap.',
            ),
          ],
        ),
        SizedBox(height: ds(6)),
        const DocsApiTable(
          title: 'Item family static tokens',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'DsItemGroup.gap',
              type: 'static double',
              description:
                  '10px between rows. Tightens to 2.5px (hidden) when the '
                  'rows contain size=sm buttons: read Item: Group for the '
                  'drift.',
            ),
            DocsApiFact(
              name: 'DsItem.gap / .padding / .radius',
              type: 'static double',
              description:
                  '10px between media, content, actions; 12px/10px padding; '
                  '12px corners.',
            ),
            DocsApiFact(
              name: 'DsItemMedia.size / .nudge',
              type: 'static double',
              description:
                  '16px icon square, and a 2px top nudge when the row has a '
                  'description.',
            ),
            DocsApiFact(
              name: 'DsItemContent.gap',
              type: 'static double',
              description: '4px between title and description.',
            ),
            DocsApiFact(
              name: 'DsItemActions.gap',
              type: 'static double',
              description: '8px between actions.',
            ),
          ],
        ),
        SizedBox(height: ds(6)),
        DsText(
          'Empty has no DsEmptyVariant: its shape comes entirely from '
          'which of the six parts a caller includes, not from a prop.',
          DsType.small,
          color: theme.mutedForeground,
        ),
        SizedBox(height: ds(3)),
        const DocsApiTable(
          title: 'Empty family properties',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'DsEmpty.children',
              type: 'List<Widget>',
              description:
                  'Required. Typically a DsEmptyHeader and a DsEmptyContent, '
                  'in order, joined by a 16px gap.',
            ),
            DocsApiFact(
              name: 'DsEmptyHeader.children',
              type: 'List<Widget>',
              description:
                  'Required. The media, the title, and the description, '
                  'capped at a 384px measure and joined by an 8px gap.',
            ),
            DocsApiFact(
              name: 'DsEmptyMedia.glyph',
              type: 'DsIconGlyph',
              description:
                  'Required. The icon drawn inside the 32px tile. Not an '
                  'arbitrary widget slot: DsEmptyMedia cannot host a '
                  'DsAvatar (see Empty: Input group\'s note on what it can '
                  'hold instead).',
            ),
            DocsApiFact(
              name: 'DsEmptyMedia.tone',
              type: 'DsIconTone',
              description: 'Defaults to DsIconTone.normal.',
            ),
            DocsApiFact(
              name: 'DsEmptyTitle.text',
              type: 'String (positional)',
              description: 'Required. The heading, 13px/500, −0.26px tracking.',
            ),
            DocsApiFact(
              name: 'DsEmptyDescription.text',
              type: 'String (positional)',
              description:
                  'Required. The supporting sentence, 13px/400, 1.625 line '
                  'height, theme.mutedForeground.',
            ),
            DocsApiFact(
              name: 'DsEmptyContent.children',
              type: 'List<Widget>',
              description:
                  'Required. The way out: one or more actions, capped at '
                  'the same 384px measure, joined by a 10px gap.',
            ),
          ],
        ),
        SizedBox(height: ds(6)),
        const DocsApiTable(
          title: 'Empty family static tokens',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'DsEmpty.padding / .gap / .radius',
              type: 'static double',
              description:
                  '24px outer padding, 16px between children, 16px corner '
                  'radius (shapes nothing today: see Theming).',
            ),
            DocsApiFact(
              name: 'DsEmptyHeader.gap / .maxWidth',
              type: 'static double',
              description: '8px gap, 384px measure (DsContainers.sm).',
            ),
            DocsApiFact(
              name:
                  'DsEmptyMedia.box / .radius / .marginBottom / .glyphSize / '
                  '.glyphStroke',
              type: 'static double',
              description:
                  '32px tile, 12px corners, 8px gap to the title, a 16px '
                  'glyph drawn with the stroke width computed for 24px: a '
                  'deliberate drift, see Theming.',
            ),
            DocsApiFact(
              name: 'DsEmptyContent.gap / .maxWidth',
              type: 'static double',
              description: '10px gap, 384px measure.',
            ),
          ],
        ),
        SizedBox(height: ds(6)),
        DsText(
          'Kbd has no DsKbdSize or DsKbdVariant: DsKbdGroup composes many '
          'keys, it is not a variant of DsKbd.',
          DsType.small,
          color: theme.mutedForeground,
        ),
        SizedBox(height: ds(3)),
        const DocsApiTable(
          title: 'Kbd family properties',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'DsKbd.text',
              type: 'String (positional)',
              description: 'Required. The legend, as authored, "Ctrl", "K".',
            ),
            DocsApiFact(
              name: 'DsKbdGroup.children',
              type: 'List<Widget>',
              description:
                  'Required. The keys, in order: typically DsKbd widgets.',
            ),
          ],
        ),
        SizedBox(height: ds(6)),
        const DocsApiTable(
          title: 'Kbd family static tokens',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'DsKbd.height / .minWidth / .paddingX / .gap',
              type: 'static double',
              description:
                  '20px tall, 20px minimum wide, 4px horizontal padding, and '
                  'a 4px gap exposed for a caller composing an icon beside '
                  'the text (nothing on this page uses it).',
            ),
            DocsApiFact(
              name: 'DsKbdGroup.gap',
              type: 'static double',
              description: '4px between keys in a group.',
            ),
          ],
        ),
      ],
    ),
  );

  Widget _states() => DsSection(
    id: 'states',
    title: 'States',
    description:
        'All four are static, presentational StatelessWidgets: none owns '
        'onPressed/enabled, a GestureDetector, a FocusNode, or an async flag '
        'anywhere in its build method. Most of IA §9.7\'s rows genuinely do '
        'not apply, so they are grouped below with the reason, rather than '
        'invented.',
    child: const DocsStateMatrix(
      facts: <DocsStateFact>[
        DocsStateFact(
          state: 'Rest',
          treatment:
              'Stat paints its label, the figure in a fixed slot, and the delta '
              'mark or message. Item paints its variant border, the media icon, '
              'content rows, and action buttons. Empty paints a centred column '
              'with an optional muted tile, the title, description, and action '
              'buttons. Kbd paints a flat theme.muted fill with 12px/500 text.',
          userSignal: 'The resting paint is the only paint for all four.',
        ),
        DocsStateFact(
          state: 'Loading / Error / Success',
          treatment:
              'Stat owns a loading state (skeleton placeholders) and error/empty '
              'states (em dash + message). Item, Empty, and Kbd carry no concept '
              'of these states: a caller renders a different specimen, the same '
              'way DsBadge swaps variant instead of transitioning in place.',
          userSignal:
              'A different specimen for Item/Empty/Kbd, a live state for Stat.',
        ),
        DocsStateFact(
          state: 'Disabled',
          treatment:
              'Stat owns a disabled flag that sets opacity and disables '
              'semantics.enabled. Item, Empty, and Kbd carry no disabled state, '
              'wrap them in an interactive control at the call site if the rows '
              'must be disabled as a group.',
          userSignal: 'A state property on Stat only.',
        ),
        DocsStateFact(
          state: 'Hover / Focus-visible / Pressed / Selected',
          treatment:
              'N/A for all four: none owns a GestureDetector, FocusNode, or '
              'onPressed/enabled parameter. Item.content and Empty.children can '
              '*hold* interactive children (buttons) whose own states apply to '
              'them, not to the parent.',
          userSignal:
              'Compose with an interactive component at the call site: the '
              'parent components do not.',
        ),
        DocsStateFact(
          state: 'Reduced motion',
          treatment:
              'N/A: no AnimationController and no motion token appears in any '
              'of the four build methods. (Stat mentions DsSwapIn for a loading '
              '→ ready transition in the source, but no motion is involved: it '
              'is a key-change that replays the swapIn effect, not an '
              'AnimationController.)',
          userSignal: 'Nothing animates, so nothing needs to still.',
        ),
      ],
    ),
  );

  Widget _accessibility(DsThemeData theme) => DsSection(
    id: 'accessibility',
    title: 'Accessibility',
    description:
        'This is where the four genuinely differ, and where some sources have '
        'real gaps worth naming plainly rather than papering over.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DsText('Stat', DsType.label, color: theme.actionInk),
        SizedBox(height: ds(2)),
        _bullets(theme, <String>[
          'Semantic role: none of its own, DsStat and DsStatDeltaMark render '
              'plain Column/Row widgets and static text via DsText, with no '
              'custom Semantics wrapper.',
          'Delta direction is conveyed three ways, not colour alone. '
              'DsStatDeltaMark wraps the mark in Semantics(label: direction.word) '
              'where the word is "Up", "Down", or "No change": read before '
              'the number by assistive tech. The glyph shape (arrow up, arrow '
              'down, minus) and the sign character (+/−/nothing) provide two '
              'additional signals, so the direction reads even if colour is '
              'removed. This is Trap 11: a mark whose only difference is hue '
              'is one signal, not two.',
          'Blank states: DsStat.build renders Semantics(label: "No value", ...) '
              'around the em dash when state is error or empty, so the absence '
              'announces itself.',
          'Disabled: opacity 45% plus Semantics(enabled: false) makes disabled '
              'clear to assistive tech.',
          'Keyboard: never focusable: no Focus widget or FocusNode exists.',
          'Known platform differences: none observed.',
        ]),
        SizedBox(height: ds(5)),
        DsText('Item', DsType.label, color: theme.actionInk),
        SizedBox(height: ds(2)),
        _bullets(theme, <String>[
          'Semantic role: none of its own, DsItem, DsItemContent, and '
              'DsItemActions are plain Row/Column widgets with no Semantics '
              'wrapper.',
          'Text is not silent: DsItemTitle and DsItemDescription render '
              'through DsText, which carries Flutter\'s default static-text '
              'semantics: both are individually reachable by a screen reader.',
          'Actions inherit semantics from DsItemActions\' children (buttons), '
              'which own their own focus and labels.',
          'Keyboard: DsItemActions typically holds button children that own '
              'their own focus behavior; Item itself adds none.',
          'Known platform differences: none observed.',
        ]),
        SizedBox(height: ds(5)),
        DsText('Empty', DsType.label, color: theme.actionInk),
        SizedBox(height: ds(2)),
        _bullets(theme, <String>[
          'Semantic role: none of its own, DsEmpty, DsEmptyHeader, and '
              'DsEmptyContent are plain Column/Padding widgets with no Semantics '
              'wrapper.',
          'Title and description are readable: DsEmptyTitle and '
              'DsEmptyDescription render through Text (via DsLineBox/DsText), '
              'which carries Flutter\'s default static-text semantics.',
          'The gap: nothing announces the *arrival* of an empty state. There is '
              'no Semantics(liveRegion: true) in empty.dart and no heading '
              'semantics on DsEmptyTitle. When an app swaps a loading state for '
              'a "no results" DsEmpty, nothing in this component tells an '
              'assistive-tech user that the content changed: they only discover '
              'the new text if they navigate back to that region. The text is '
              'not silent; its *arrival* is. Wire a live announcement at the '
              'call site (e.g. Semantics(liveRegion: true) around the swap, or '
              'SemanticsService.announce) if it matters.',
          'Media icon: carries no separate label parameter: the adjacent title '
              'already states the same information.',
          'Keyboard: DsEmptyContent commonly holds an interactive child (button) '
              'that supplies its own focus and keyboard behavior; Empty adds '
              'none.',
          'Known platform differences: none observed.',
        ]),
        SizedBox(height: ds(5)),
        DsText('Kbd', DsType.label, color: theme.actionInk),
        SizedBox(height: ds(2)),
        _bullets(theme, <String>[
          'Semantic role: none of its own, DsKbd wraps its text in '
              'IgnorePointer and SelectionContainer.disabled only; no Semantics '
              'override. The legend reaches assistive tech as ordinary static '
              'text.',
          'The gap: nothing marks it as "a key you press." There is no '
              'semanticLabel such as "key: Esc" and no custom Semantics role, '
              'a screen reader reads "Esc" exactly as it would read the word '
              '"Esc" anywhere else, with no signal that it names a keyboard key.',
          'One exception: DsKbdGroup wraps its children in MergeSemantics, so a '
              'grouped shortcut *does* fold into a single announcement instead of '
              'two separate stops. "Ctrl K" reads as one node, not "Ctrl" then '
              '"K", because a nested kbd is "one keyboard object, not a container '
              'of two."',
          'IgnorePointer and SelectionContainer.disabled match the reference\'s '
              'CSS pointer-events-none and select-none exactly.',
          'Keyboard: never focusable: no Focus widget or FocusNode exists.',
          'Touch target: not applicable: inert to touch by design (IgnorePointer).',
          'No tooltip integration: kbd.dart\'s own doc comment records a '
              'tooltip-context recolour class as not built, because this port '
              'has no DsTooltip for the context selector to match against yet '
              '(this is why Kbd: Tooltip is skipped above).',
          'Known platform differences: none observed.',
        ]),
      ],
    ),
  );

  Widget _responsive(DsThemeData theme) => DsSection(
    id: 'responsive',
    title: 'Responsive',
    child: _bullets(theme, <String>[
      'Stat: no responsive branching: renders identically at 390px and 1440px. '
          'The slot heights are fixed, the figure width is intrinsic to the '
          'string (subject to DsType.numLg\'s own line breaking), and the '
          'label row and delta row wrap if needed.',
      'Item: no responsive branching: renders identically across widths. Media '
          'is fixed-square, content fills flex space, actions are right-aligned '
          'or top-aligned depending on the alignStart flag. Long titles/descriptions '
          'clip to one or two lines and ellipsize.',
      'Empty: no responsive branching: the centred column adapts to available '
          'width up to the 384px measure cap. The media tile, title, description, '
          'and actions all reflow within that constraint.',
      'Kbd: no responsive branching, 20px height everywhere, 20px minimum width, '
          'content-width capped by the legend text. DsKbdGroup wraps on a new '
          'line if space is tight.',
      'Platform parity: Android, iOS, Web, macOS, Windows, and Linux all render '
          'the same widget tree for all four.',
    ]),
  );

  Widget _dependencies(DsThemeData theme) => DsSection(
    id: 'dependencies',
    title: 'Dependencies',
    child: _bullets(theme, <String>[
      'Files: lib/src/components/stat.dart, item.dart, empty.dart, kbd.dart '
          '(four files, no companion parts).',
      'Stat imports: foundation/* (colors, spacing, theme, typography), '
          'motion/swap_in.dart (DsSwapIn), icon.dart (DsIcon), '
          'icon_paths.g.dart (DsLucide enum), skeleton.dart (DsSkeleton).',
      'Item imports: foundation/* (colors, spacing, theme, typography).',
      'Empty imports: foundation/* (spacing, theme, typography), icon.dart, '
          'icon_paths.dart, text_layout.dart (DsLineBox).',
      'Kbd imports: foundation/* (shadows, spacing, theme, typography), '
          'effects/machine_surface.dart (DsMachineSurface).',
      'Assets: none. Fonts: none beyond the system type scale every DsText '
          'call already depends on. Shaders: none: flat fills and borders.',
    ]),
  );

  Widget _theming(DsThemeData theme) => DsSection(
    id: 'theming',
    title: 'Theming',
    child: _bullets(theme, <String>[
      'Stat: every colour comes from the live theme. DsStatDeltaMark uses '
          'theme.successInk when the move is favourable, theme.foreground when '
          'it is not, and theme.mutedForeground when flat. Flipping '
          'DsThemeController between light and dark re-resolves all three.',
      'Item: borders use theme.border (variant=outline) or no border (variant='
          'normal), and fills use theme.muted (variant=muted). Content text uses '
          'theme.foreground/mutedForeground from DsItemContent and '
          'DsItemDescription.',
      'Empty: media background is theme.muted, title is theme.foreground, '
          'description is theme.mutedForeground. The corner radius (16px) shapes '
          'nothing today (drift 8: no border to shape) and is recorded rather '
          'than built.',
      'Kbd: the fill is theme.muted, the text is theme.mutedForeground. The '
          'component owns an elevation token (DsShadows.key, DsShadows.keyDown) '
          'and never wears it, Kbd renders with DsShadows.none, so the shadow '
          'is aspirational and the component is flat.',
    ]),
  );

  Widget _source() => DsSection(
    id: 'source',
    title: 'Source',
    child: DocsInstallFacts(
      title: 'Reference',
      facts: <DocsInstallFact>[
        DocsInstallFact(
          label: 'Source',
          value: statDoc.sourcePath,
          description:
              'Four authoritative implementations: the truth this page was '
              'written from. (Note: sourcePath names stat.dart; item.dart, '
              'empty.dart, and kbd.dart are siblings.)',
        ),
        const DocsInstallFact(
          label: 'Package tests',
          value: 'none yet',
          description:
              'No dedicated unit tests exist for any of the four in the '
              'package test suite as of this page.',
        ),
        const DocsInstallFact(
          label: 'Docs test',
          value: 'example/test/components_docs/stat_test.dart',
          description:
              'Covers this page: the API table, live specimens at both '
              'breakpoints, and both themes. (Note: the test file covers all '
              'four components on one page.)',
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

Widget _bullets(DsThemeData theme, List<String> lines) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: <Widget>[
    for (final String line in lines) ...<Widget>[
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: DsWidths.prose),
        child: DsText('•  $line', DsType.small, color: theme.mutedForeground),
      ),
      SizedBox(height: ds(2)),
    ],
  ],
);

const String _usageCode = '''
// Stat: the smallest call, then a full metric with delta and hint.
DsStat(
  label: 'Revenue',
  value: '\$12,480',
)

DsStat(
  label: 'Revenue',
  value: '\$12,480',
  delta: (value: '8.2%', direction: DsStatDirection.up),
  betterWhen: DsStatDirection.up,
  hint: 'vs last month',
)

// Item: a row in a group or standalone.
DsItemGroup(
  children: [
    DsItem(
      media: DsItemMedia(child: DsIcon(DsLucide.mail, ...)),
      content: DsItemContent(
        children: [
          DsItemTitle('Inbox'),
          DsItemDescription('12 unread messages'),
        ],
      ),
      actions: DsItemActions(
        children: [DsButton(..., child: DsText('Mark read', ...))],
      ),
    ),
  ],
)

// Empty: a no-results state with a way out.
DsEmpty(
  children: [
    DsEmptyHeader(
      children: [
        DsEmptyMedia(glyph: DsIconGlyph.search),
        DsEmptyTitle('No results'),
        DsEmptyDescription('Try different keywords.'),
      ],
    ),
    DsEmptyContent(
      children: [
        DsButton(
          variant: DsButtonVariant.secondary,
          onPressed: () {},
          child: DsText('Clear filters', ...),
        ),
      ],
    ),
  ],
)

// Kbd: single key or group.
DsKbd('Escape')

DsKbdGroup(
  children: [DsKbd('Ctrl'), DsKbd('K')],
)''';
