/// Public documentation page for four small presentational primitives:
/// `stat`, `item`, `empty`, and `kbd`.
///
/// Each is a focused composition: a labelled metric display with an optional
/// delta, a structured list row, an empty-state block, and a key-cap hint. All
/// four share one theme: static presentation with almost no state of its own.
/// This page documents all four together rather than four separate ones.
///
/// None of the four has a registry manifest yet
/// (`registry/components/stat.json`, `item.json`, `empty.json`, `kbd.json` do
/// not exist) — every install-facing panel below says so honestly rather than
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
      DocsTocEntry(title: 'Overview', anchor: 'overview'),
      DocsTocEntry(title: 'Preview', anchor: 'preview'),
      DocsTocEntry(title: 'Install', anchor: 'install'),
      DocsTocEntry(title: 'Usage', anchor: 'usage'),
      DocsTocEntry(title: 'API', anchor: 'api'),
      DocsTocEntry(title: 'Variants', anchor: 'variants'),
      DocsTocEntry(title: 'States', anchor: 'states'),
      DocsTocEntry(title: 'Accessibility', anchor: 'accessibility'),
      DocsTocEntry(title: 'Responsive', anchor: 'responsive'),
      DocsTocEntry(title: 'Dependencies', anchor: 'dependencies'),
      DocsTocEntry(title: 'Composition', anchor: 'composition'),
      DocsTocEntry(title: 'Theming', anchor: 'theming'),
      DocsTocEntry(title: 'Source', anchor: 'source'),
    ],
    onNavigate: onNavigate,
    child: const _StatArticle(),
  );
}

/// The Wave 1 "base primitives" group this page belongs to (IA §7.3), listed
/// in the plan's own order. These are not routes other workers are producing
/// this same wave verified as wired — the supervisor aggregates the real
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
        _overview(theme),
        _preview(),
        _install(),
        _usage(),
        _api(),
        _variants(theme),
        _states(),
        _accessibility(theme),
        _responsive(theme),
        _dependencies(theme),
        _composition(),
        _theming(theme),
        _source(),
      ],
    );
  }

  Widget _overview(DsThemeData theme) => DsSection(
    id: 'overview',
    title: 'Overview',
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: DsWidths.prose),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DsText(
            'Four components that share one theme: almost no state, and a '
            'single visual job each. None of the four owns a GestureDetector, '
            'a FocusNode, or an async flag anywhere in its build method — every '
            'row below that looks empty in the State matrix is empty for that '
            'reason, not because the template was left unfilled.',
            DsType.body,
          ),
          SizedBox(height: ds(5)),
          DsText('Stat', DsType.h4, color: theme.foreground),
          SizedBox(height: ds(2)),
          DsText(
            'DsStat renders a labelled metric figure with an optional delta '
            'and trailing hint. The metric sits in a fixed-height slot, the '
            'delta row is optional and wraps if the delta overflows, and the '
            'footprint is identical across all states (ready, loading, error, '
            'empty, disabled) — the layout does not reflow when the state '
            'changes.',
            DsType.body,
          ),
          SizedBox(height: ds(2)),
          DsText(
            'Reach for it on a dashboard, a summary card, or a data page to '
            'show a metric with direction — revenue with a trend, an uptime '
            'percentage with a change. Use DsStatState.empty or .error and a '
            'message to explain why the value is not available. The delta\'s '
            'direction is conveyed three ways — glyph shape (up arrow, down '
            'arrow, minus), the sign character (+/−/nothing), and a visually '
            'hidden word ("Up", "Down", "No change") — so the direction reads '
            'correctly even when colour is removed.',
            DsType.body,
          ),
          SizedBox(height: ds(5)),
          DsText('Item', DsType.h4, color: theme.foreground),
          SizedBox(height: ds(2)),
          DsText(
            'DsItem is a structured list row: optional media (usually an '
            'icon), required content (usually a title and description), and '
            'optional actions. The row carries a border option (normal, outline, '
            'muted) and an alignment override (center or top).',
            DsType.body,
          ),
          SizedBox(height: ds(2)),
          DsText(
            'Reach for it over a bare Row when the content has a standard '
            'shape — icon, title, description, buttons — and the container '
            'needs semantic consistency across several rows. DsItemGroup is '
            'the list wrapper: it enforces a vertical gap and stretches all '
            'children to the column width. Reach for whitespace alone when the '
            'row is one-off or the layout does not repeat.',
            DsType.body,
          ),
          SizedBox(height: ds(5)),
          DsText('Empty', DsType.h4, color: theme.foreground),
          SizedBox(height: ds(2)),
          DsText(
            'DsEmpty is a structured empty state: an optional media tile, a '
            'title, a description, and one clear way out (DsEmptyContent), '
            'centred in a column with 16px between its parts.',
            DsType.body,
          ),
          SizedBox(height: ds(2)),
          DsText(
            'Reach for it whenever a collection, search, or workspace has '
            'nothing to show and the user needs to know why and what to do '
            'next. The text itself announces its content through normal text '
            'semantics, but there is no live-region announcement when the empty '
            'state arrives — wire that at the call site if it matters. Reach '
            'for a spinner/skeleton instead when the empty appearance is '
            'temporary; reach for no render at all only when the state never '
            'changes and there is no next step.',
            DsType.body,
          ),
          SizedBox(height: ds(5)),
          DsText('Kbd', DsType.h4, color: theme.foreground),
          SizedBox(height: ds(2)),
          DsText(
            'DsKbd renders a 20px-tall, 20px-minimum-wide key cap: muted fill, '
            '6px corners, 12px/500 label, inert to touch and text selection.',
            DsType.body,
          ),
          SizedBox(height: ds(2)),
          DsText(
            'Reach for it when the content is a literal key the reader would '
            'press — Ctrl, K, Esc — never a status word (that is DsBadge) or '
            'a code snippet (that is DsType.code or a code block). A screen '
            'reader reads it as the text alone with no "key" label — it is '
            'solely visual markup. DsKbdGroup composes several keys into one '
            'shortcut and merges their semantics into a single announcement.',
            DsType.body,
          ),
          SizedBox(height: ds(4)),
          DsText(
            'Status: stable primitives, not yet registered in the CLI (see '
            'Install). Platforms: Android, iOS, Web, macOS, Windows, Linux — '
            'the same six every widget in this package targets.',
            DsType.small,
            color: theme.mutedForeground,
          ),
        ],
      ),
    ),
  );

  Widget _preview() => DsSection(
    id: 'preview',
    title: 'Preview',
    description:
        'One representative specimen of each: a revenue metric with a trend, '
        'a history card row, a no-results empty state, and a shortcut hint.',
    child: DocsCodeExample(
      title: 'Stat, Item, Empty, and Kbd specimens',
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/stat.dart',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// None of the four has a registry manifest yet — copy\n'
              '// lib/src/components/stat.dart, item.dart, empty.dart, and\n'
              '// kbd.dart from the package source directly. There is no\n'
              '// generated CLI payload to fetch.',
        ),
      ],
      preview: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DsText('Stat — a metric with direction', DsType.label),
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
          DsText('Item — a structured list row', DsType.label),
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
          DsText('Empty — no results, with a way out', DsType.label),
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
          DsText('Kbd — shortcut hints', DsType.label),
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
  );

  Widget _install() => DsSection(
    id: 'install',
    title: 'Installation',
    description:
        'None of the four has a registry manifest yet, so `elattar add stat` / '
        '`item` / `empty` / `kbd` is not available — install by copying the '
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
              'yet for any of the four — there is nothing to install.',
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

  Widget _api() => DsSection(
    id: 'api',
    title: 'API',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const DocsApiTable(
          title: 'Stat properties',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'label',
              type: 'String',
              description: 'Required. The metric name — "Revenue".',
            ),
            DocsApiFact(
              name: 'value',
              type: 'String',
              description:
                  'Required. The figure to display — "\$12,480". '
                  'Slot height is fixed regardless of content.',
            ),
            DocsApiFact(
              name: 'delta',
              type: 'DsStatDelta?',
              description:
                  'Optional. A value and direction (up/down/flat) — '
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
                  'Optional comparison, one word or phrase — "vs last month". '
                  'Shown below the delta when the state is ready.',
            ),
            DocsApiFact(
              name: 'state',
              type: 'DsStatState',
              description:
                  'Defaults to ready. Controls what the figure and delta '
                  'render as — a skeleton while loading, an em dash while '
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
                  'state — prevents reflow when loading → ready.',
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
                  'Optional. Usually a DsItemMedia with an icon. Sits at the '
                  'row start.',
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
                  'Defaults to normal. Selects the border — transparent, '
                  'border colour, or muted fill.',
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
                  'rows contain size=sm buttons — read Composition for the '
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
              description: 'Required. The icon drawn inside the 32px tile.',
            ),
            DocsApiFact(
              name: 'DsEmptyMedia.tone',
              type: 'DsIconTone',
              description: 'Defaults to DsIconTone.normal.',
            ),
            DocsApiFact(
              name: 'DsEmptyTitle.text',
              type: 'String (positional)',
              description:
                  'Required. The heading — 13px/500, −0.26px tracking.',
            ),
            DocsApiFact(
              name: 'DsEmptyDescription.text',
              type: 'String (positional)',
              description:
                  'Required. The supporting sentence — 13px/400, 1.625 line '
                  'height, theme.mutedForeground.',
            ),
            DocsApiFact(
              name: 'DsEmptyContent.children',
              type: 'List<Widget>',
              description:
                  'Required. The way out — one or more actions, capped at '
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
                  'radius (shapes nothing today — see Theming).',
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
                  'glyph drawn with the stroke width computed for 24px — a '
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
        const DocsApiTable(
          title: 'Kbd family properties',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'DsKbd.text',
              type: 'String (positional)',
              description: 'Required. The legend, as authored — "Ctrl", "K".',
            ),
            DocsApiFact(
              name: 'DsKbdGroup.children',
              type: 'List<Widget>',
              description:
                  'Required. The keys, in order — typically DsKbd widgets.',
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

  Widget _variants(DsThemeData theme) => DsSection(
    id: 'variants',
    title: 'Variants and sizes',
    description:
        'None of the four has a size axis. Stat and Item have enums; Empty '
        'and Kbd have none — their shape comes from composition, not a variant '
        'switch.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const DocsApiTable(
          title: 'DsStatState',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'ready',
              type: 'the default',
              description:
                  'Renders the value, the delta mark, and the hint — the full '
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
        SizedBox(height: ds(4)),
        const DocsApiTable(
          title: 'DsItemVariant',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'normal',
              type: 'the default',
              description: 'A transparent border; no background.',
            ),
            DocsApiFact(
              name: 'outline',
              type: 'bordered',
              description: 'A 1px border in theme.border.',
            ),
            DocsApiFact(
              name: 'muted',
              type: 'filled',
              description: 'A semi-transparent muted background.',
            ),
          ],
        ),
        SizedBox(height: ds(4)),
        _bullets(theme, <String>[
          'Empty has no DsEmptyVariant. Its "variants" are which of the six '
              'parts a caller includes — a media tile is optional, multiple '
              'actions in DsEmptyContent are optional — not an enum switch.',
          'Kbd has no DsKbdSize or DsKbdVariant either. DsKbdGroup is the '
              '"many keys" composition, not a variant of DsKbd — it renders '
              'its own children unchanged and only adds the 4px gap and the '
              'MergeSemantics wrapper.',
        ]),
      ],
    ),
  );

  Widget _states() => DsSection(
    id: 'states',
    title: 'States and feedback',
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
              'of these states — a caller renders a different specimen, the same '
              'way DsBadge swaps variant instead of transitioning in place.',
          userSignal:
              'A different specimen for Item/Empty/Kbd, a live state for Stat.',
        ),
        DocsStateFact(
          state: 'Disabled',
          treatment:
              'Stat owns a disabled flag that sets opacity and disables '
              'semantics.enabled. Item, Empty, and Kbd carry no disabled state — '
              'wrap them in an interactive control at the call site if the rows '
              'must be disabled as a group.',
          userSignal: 'A state property on Stat only.',
        ),
        DocsStateFact(
          state: 'Hover / Focus-visible / Pressed / Selected',
          treatment:
              'N/A for all four — none owns a GestureDetector, FocusNode, or '
              'onPressed/enabled parameter. Item.content and Empty.children can '
              '*hold* interactive children (buttons) whose own states apply to '
              'them, not to the parent.',
          userSignal:
              'Compose with an interactive component at the call site — the '
              'parent components do not.',
        ),
        DocsStateFact(
          state: 'Reduced motion',
          treatment:
              'N/A — no AnimationController and no motion token appears in any '
              'of the four build methods. (Stat mentions DsSwapIn for a loading '
              '→ ready transition in the source, but no motion is involved — it '
              'is a key-change that replays the swapIn effect, not an '
              'AnimationController.)',
          userSignal: 'Nothing animates, so nothing needs to still.',
        ),
      ],
    ),
  );

  Widget _accessibility(DsThemeData theme) => DsSection(
    id: 'accessibility',
    title: 'Accessibility and keyboard behavior',
    description:
        'This is where the four genuinely differ, and where some sources have '
        'real gaps worth naming plainly rather than papering over.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DsText('Stat', DsType.label, color: theme.actionInk),
        SizedBox(height: ds(2)),
        _bullets(theme, <String>[
          'Semantic role: none of its own — DsStat and DsStatDeltaMark render '
              'plain Column/Row widgets and static text via DsText, with no '
              'custom Semantics wrapper.',
          'Delta direction is conveyed three ways, not colour alone. '
              'DsStatDeltaMark wraps the mark in Semantics(label: direction.word) '
              'where the word is "Up", "Down", or "No change" — read before '
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
          'Keyboard: never focusable — no Focus widget or FocusNode exists.',
          'Known platform differences: none observed.',
        ]),
        SizedBox(height: ds(5)),
        DsText('Item', DsType.label, color: theme.actionInk),
        SizedBox(height: ds(2)),
        _bullets(theme, <String>[
          'Semantic role: none of its own — DsItem, DsItemContent, and '
              'DsItemActions are plain Row/Column widgets with no Semantics '
              'wrapper.',
          'Text is not silent: DsItemTitle and DsItemDescription render '
              'through DsText, which carries Flutter\'s default static-text '
              'semantics — both are individually reachable by a screen reader.',
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
          'Semantic role: none of its own — DsEmpty, DsEmptyHeader, and '
              'DsEmptyContent are plain Column/Padding widgets with no Semantics '
              'wrapper.',
          'Title and description are readable: DsEmptyTitle and '
              'DsEmptyDescription render through Text (via DsLineBox/DsText), '
              'which carries Flutter\'s default static-text semantics.',
          'The gap: nothing announces the *arrival* of an empty state. There is '
              'no Semantics(liveRegion: true) in empty.dart and no heading '
              'semantics on DsEmptyTitle. When an app swaps a loading state for '
              'a "no results" DsEmpty, nothing in this component tells an '
              'assistive-tech user that the content changed — they only discover '
              'the new text if they navigate back to that region. The text is '
              'not silent; its *arrival* is. Wire a live announcement at the '
              'call site (e.g. Semantics(liveRegion: true) around the swap, or '
              'SemanticsService.announce) if it matters.',
          'Media icon: carries no separate label parameter — the adjacent title '
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
          'Semantic role: none of its own — DsKbd wraps its text in '
              'IgnorePointer and SelectionContainer.disabled only; no Semantics '
              'override. The legend reaches assistive tech as ordinary static '
              'text.',
          'The gap: nothing marks it as "a key you press." There is no '
              'semanticLabel such as "key: Esc" and no custom Semantics role — '
              'a screen reader reads "Esc" exactly as it would read the word '
              '"Esc" anywhere else, with no signal that it names a keyboard key.',
          'One exception: DsKbdGroup wraps its children in MergeSemantics, so a '
              'grouped shortcut *does* fold into a single announcement instead of '
              'two separate stops. "Ctrl K" reads as one node, not "Ctrl" then '
              '"K", because a nested kbd is "one keyboard object, not a container '
              'of two."',
          'IgnorePointer and SelectionContainer.disabled match the reference\'s '
              'CSS pointer-events-none and select-none exactly.',
          'Keyboard: never focusable — no Focus widget or FocusNode exists.',
          'Touch target: not applicable — inert to touch by design (IgnorePointer).',
          'Known platform differences: none observed.',
        ]),
      ],
    ),
  );

  Widget _responsive(DsThemeData theme) => DsSection(
    id: 'responsive',
    title: 'Responsive and platform behavior',
    child: _bullets(theme, <String>[
      'Stat: no responsive branching — renders identically at 390px and 1440px. '
          'The slot heights are fixed, the figure width is intrinsic to the '
          'string (subject to DsType.numLg\'s own line breaking), and the '
          'label row and delta row wrap if needed.',
      'Item: no responsive branching — renders identically across widths. Media '
          'is fixed-square, content fills flex space, actions are right-aligned '
          'or top-aligned depending on the alignStart flag. Long titles/descriptions '
          'clip to one or two lines and ellipsize.',
      'Empty: no responsive branching — the centred column adapts to available '
          'width up to the 384px measure cap. The media tile, title, description, '
          'and actions all reflow within that constraint.',
      'Kbd: no responsive branching — 20px height everywhere, 20px minimum width, '
          'content-width capped by the legend text. DsKbdGroup wraps on a new '
          'line if space is tight.',
      'Platform parity: Android, iOS, Web, macOS, Windows, and Linux all render '
          'the same widget tree for all four.',
    ]),
  );

  Widget _dependencies(DsThemeData theme) => DsSection(
    id: 'dependencies',
    title: 'Dependencies, files, and assets',
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
          'call already depends on. Shaders: none — flat fills and borders.',
    ]),
  );

  Widget _composition() => DsSection(
    id: 'composition',
    title: 'Composition examples',
    description:
        'Real shapes these four compose into elsewhere in this package.',
    child: DocsCodeExample(
      title: 'Composed with other primitives',
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
          SizedBox(height: ds(8)),
          DsText('Item group with multiple rows', DsType.label),
          SizedBox(height: ds(3)),
          DsItemGroup(
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
        ],
      ),
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(
          path: 'stat_item_composition_note.md',
          title: 'Composition notes',
          description:
              'DsItem is a generic row; when the rows have a standard shape '
              'repeated across several rows, DsItemGroup enforces consistency '
              'and spacing. DsStat is a labelled metric, self-contained; on a '
              'card header it sits alongside separator lines and headings '
              'rather than inside a list. Reach for DsItemGroup when you have '
              'a list of structured rows; reach for individual components '
              'when rows are one-off or the layout does not repeat.',
          code:
              '''// A group of item rows — consistent spacing, alignment, and borders.
DsItemGroup(
  children: [
    DsItem(
      media: ...,
      content: ...,
      actions: ...,
    ),
    DsItem(...),
  ],
)

// A stat on its own — a card header, a dashboard cell.
DsCard(
  child: DsStat(
    label: 'Revenue',
    value: '\$12,480',
    delta: (value: '8.2%', direction: DsStatDirection.up),
  ),
)''',
        ),
      ],
    ),
  );

  Widget _theming(DsThemeData theme) => DsSection(
    id: 'theming',
    title: 'Theming notes',
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
          'and never wears it — Kbd renders with DsShadows.none, so the shadow '
          'is aspirational and the component is flat.',
    ]),
  );

  Widget _source() => DsSection(
    id: 'source',
    title: 'Source, tests, and docs',
    child: DocsInstallFacts(
      title: 'Reference',
      facts: <DocsInstallFact>[
        DocsInstallFact(
          label: 'Source',
          value: statDoc.sourcePath,
          description:
              'Four authoritative implementations — the truth this page was '
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
// Stat — the smallest call, then a full metric with delta and hint.
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

// Item — a row in a group or standalone.
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

// Empty — a no-results state with a way out.
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

// Kbd — single key or group.
DsKbd('Escape')

DsKbdGroup(
  children: [DsKbd('Ctrl'), DsKbd('K')],
)''';
