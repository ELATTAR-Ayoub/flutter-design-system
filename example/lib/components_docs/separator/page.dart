/// Public documentation page for three small presentational primitives:
/// `separator`, `empty`, and `kbd`.
///
/// Each is too small for a page of its own — a hairline rule that is one
/// class list, a six-part empty-state composition, and a 20px key cap — and
/// all three share one theme: static presentation with almost no state of
/// its own. This page documents all three together rather than three
/// near-empty pages, the way `meta.dart` explains. It mirrors
/// `badge/page.dart`'s use of the Phase C docs primitives (`DocsLayout`,
/// `DocsCodeExample`, `DocsApiTable`, `DocsStateMatrix`, `DocsInstallFacts`)
/// and `kit.dart`'s `DsSection` for titled, anchor-registered content
/// blocks, with each section internally split into three labelled groups —
/// one per component — instead of three pages each repeating the eighteen
/// sections mostly to say "N/A".
///
/// None of the three has a registry manifest yet
/// (`registry/components/separator.json`, `empty.json`, `kbd.json` do not
/// exist) — every install-facing panel below says so honestly rather than
/// presenting a CLI command that would fail.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/docs_code.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../kit.dart';
import 'meta.dart';

class SeparatorDocPage extends StatelessWidget {
  const SeparatorDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: separatorDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / BASE',
      title: separatorDoc.title,
      description: separatorDoc.description,
    ),
    breadcrumbs: const <DsBreadcrumbEntry>[
      DsBreadcrumbEntry.link('Components'),
      DsBreadcrumbEntry.page('Separator, Empty & Kbd'),
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
    previous: const DocsPageLink(
      title: 'Progress',
      route: '/components/progress',
    ),
    next: const DocsPageLink(title: 'Skeleton', route: '/components/skeleton'),
    onNavigate: onNavigate,
    child: const _SeparatorArticle(),
  );
}

/// The Wave 1 "base primitives" group this page belongs to (IA §7.3), listed
/// in the plan's own order — except `Empty` and `Kbd` do not get their own
/// rows: both are documented on this page (route `/components/separator`)
/// rather than at `/components/empty` and `/components/kbd`, so the merged
/// row sits where `separator` alphabetises. These are not routes other
/// workers are producing this same wave verified as wired — the supervisor
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
  DocsSidebarEntry(
    title: 'Separator, Empty & Kbd',
    route: '/components/separator',
    selected: true,
  ),
  DocsSidebarEntry(title: 'Skeleton', route: '/components/skeleton'),
  DocsSidebarEntry(title: 'Switch', route: '/components/switch'),
  DocsSidebarEntry(title: 'Toggle', route: '/components/toggle'),
  DocsSidebarEntry(title: 'Tooltip', route: '/components/tooltip'),
];

class _SeparatorArticle extends StatelessWidget {
  const _SeparatorArticle();

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Column(
      key: const ValueKey<String>('separator-doc-article'),
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
            'Three components that share one theme: almost no state, and a '
            'single visual job each. None of the three owns a GestureDetector, '
            'a FocusNode, or an async flag anywhere in its build method — every '
            'row below that looks empty in the State matrix is empty for that '
            'reason, not because the template was left unfilled.',
            DsType.body,
          ),
          SizedBox(height: ds(5)),
          DsText('Separator', DsType.h4, color: theme.foreground),
          SizedBox(height: ds(2)),
          DsText(
            'DsSeparator renders one 1px hairline in theme.border, on '
            'whichever axis orientation names — the long axis is left unset so '
            'the parent constraint fills it, exactly like the reference\'s '
            'w-full / self-stretch.',
            DsType.body,
          ),
          SizedBox(height: ds(2)),
          DsText(
            'Reach for it, instead of plain whitespace, when the boundary '
            'itself must stay visible even on a quick scan — a settings list '
            'where each row has to read as a discrete unit, not merely spaced '
            'apart. Reach for whitespace alone when adjacency already implies '
            'grouping and a line would be one accent too many. Reach for a '
            'bordered DsCard/Container instead of a lone separator when the '
            '*region* needs a boundary on all four sides — a separator has no '
            'length of its own and only ever draws one edge.',
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
            'next. Reach for a spinner/skeleton instead when the empty '
            'appearance is temporary and about to resolve on its own — DsEmpty '
            'never resolves itself, it has no loading concept. Reach for '
            'simply rendering nothing only when the state never changes and '
            'there is genuinely no next step to suggest; the moment there is '
            'one, a bare "No results" string is an unfinished screen and '
            'DsEmpty is what finishes it.',
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
            'press — Ctrl, K, Esc, ⌘ — never a status word or a count (that is '
            'DsBadge) and never a snippet of code (that is the mono '
            'DsType.code role or a DsPanel code block, which read as *quoted '
            'text*, not as *a key you press*). DsKbdGroup composes several '
            'keys into one shortcut that should be read as a single '
            'combination, not as unrelated letters.',
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
        'One representative specimen of each: the balance/three-figure strip '
        'the separator source itself documents, a search "no results" empty '
        'state, and the shortcut list from the buttons page.',
    child: DocsCodeExample(
      title: 'Separator, Empty, and Kbd specimens',
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/separator.dart',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// None of the three has a registry manifest yet — copy\n'
              '// lib/src/components/separator.dart, empty.dart, and kbd.dart\n'
              '// from the package source directly. There is no generated\n'
              '// CLI payload to fetch.',
        ),
      ],
      preview: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DsText('Separator — horizontal and vertical', DsType.label),
          SizedBox(height: ds(3)),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: SizedBox(
              width: DsContainers.md,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  DsText('Available balance', DsType.small),
                  SizedBox(height: ds(4)),
                  KeyedSubtree(
                    key: const ValueKey<String>('separator-preview:horizontal'),
                    child: const DsSeparator(),
                  ),
                  SizedBox(height: ds(4)),
                  DsText('Bonus balance', DsType.small),
                ],
              ),
            ),
          ),
          SizedBox(height: ds(5)),
          SizedBox(
            height: ds(6),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  DsText('412 packs', DsType.numSm),
                  SizedBox(width: ds(4)),
                  KeyedSubtree(
                    key: const ValueKey<String>('separator-preview:vertical'),
                    child: const DsSeparator.vertical(),
                  ),
                  SizedBox(width: ds(4)),
                  DsText('1,284 cards', DsType.numSm),
                  SizedBox(width: ds(4)),
                  const DsSeparator.vertical(),
                  SizedBox(width: ds(4)),
                  DsText('8 sets', DsType.numSm),
                ],
              ),
            ),
          ),
          SizedBox(height: ds(8)),
          DsText('Empty — a no-results state, with a way out', DsType.label),
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
                    DsText('Close this dialog', DsType.small),
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
        'None of the three has a registry manifest yet, so `elattar add '
        'separator` / `empty` / `kbd` is not available — install by copying '
        'the source files manually.',
    child: DocsInstallFacts(
      title: 'Installation facts',
      facts: <DocsInstallFact>[
        const DocsInstallFact(
          label: 'Registry item',
          value: 'not yet registered (×3)',
          description:
              'No registry/components/separator.json, empty.json, or '
              'kbd.json exists. All three are source-only today.',
        ),
        const DocsInstallFact(
          label: 'Destination',
          value: 'lib/components/ui/separator.dart, empty.dart, kbd.dart',
          description: 'Where a manual copy of each source file belongs.',
        ),
        const DocsInstallFact(
          label: 'Foundation',
          value: 'source only',
          description: 'No package-backed alternative is offered yet.',
        ),
        const DocsInstallFact(
          label: 'Dependencies',
          value: 'source-foundation; empty → icon; kbd → machine-surface',
          description:
              'Separator needs only spacing/theme tokens. Empty additionally '
              'needs the icon component (DsEmptyMedia renders a DsIcon). Kbd '
              'additionally needs the machine-surface effect, though it '
              'paints through it with DsShadows.none — see Theming. None of '
              'this is resolved automatically today; copy the imports by '
              'hand.',
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
              'Kbd\'s machine surface renders DsShadows.none — a flat fill '
              'and border, not a fragment shader.',
        ),
        DocsInstallFact(
          label: 'Platforms',
          value: 'Android, iOS, Web, macOS, Windows, Linux',
          description:
              'No platform-conditional code in separator.dart, empty.dart, '
              'or kbd.dart.',
        ),
        const DocsInstallFact(
          label: 'Verified',
          value: 'docs specimen only',
          description:
              'This page\'s live preview and '
              'example/test/components_docs/separator_test.dart. No '
              'dedicated package-level unit test and no registry fixture '
              'install exist yet for any of the three — there is nothing to '
              'install.',
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
          title: 'DsSeparator properties',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'orientation',
              type: 'DsSeparatorOrientation',
              description:
                  'Defaults to horizontal. Selects which axis draws the '
                  'rule. DsSeparator.vertical() is equivalent to passing '
                  'DsSeparatorOrientation.vertical here.',
            ),
          ],
        ),
        SizedBox(height: ds(6)),
        const DocsApiTable(
          title: 'DsSeparator static tokens',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'DsSeparator.thickness',
              type: 'static double',
              description:
                  'The rule\'s thickness on its short axis — DsWidths.hairline '
                  '(1px). The long axis is left null on purpose so the '
                  'parent\'s own constraint fills it.',
            ),
          ],
        ),
        SizedBox(height: ds(8)),
        const DocsApiTable(
          title: 'Empty family properties',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'children',
              type: 'List<Widget>',
              description:
                  'Required (DsEmpty, DsEmptyHeader, DsEmptyContent). '
                  'DsEmpty: typically a DsEmptyHeader and a DsEmptyContent, '
                  'in order, joined by a 16px gap. DsEmptyHeader: the media, '
                  'the title, and the description, capped at a 384px measure '
                  'and joined by an 8px gap. DsEmptyContent: one or more '
                  'actions, capped at the same 384px measure, joined by a '
                  '10px gap.',
            ),
            DocsApiFact(
              name: 'glyph',
              type: 'DsIconGlyph',
              description:
                  '(DsEmptyMedia) Required. The icon drawn inside the '
                  '32px tile.',
            ),
            DocsApiFact(
              name: 'tone',
              type: 'DsIconTone',
              description: '(DsEmptyMedia) Defaults to DsIconTone.normal.',
            ),
            DocsApiFact(
              name: 'text',
              type: 'String (positional)',
              description:
                  '(DsEmptyTitle, DsEmptyDescription) Required. DsEmptyTitle: '
                  'the heading — 13px/500, −0.26px tracking. '
                  'DsEmptyDescription: the supporting sentence — 13px/400, '
                  '1.625 line height, theme.mutedForeground.',
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
                  'radius. radius shapes nothing today — see Theming.',
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
                  'deliberate drift, see Overview\'s source note and '
                  'Theming.',
            ),
            DocsApiFact(
              name: 'DsEmptyTitle.styleOf(context, {color})',
              type: 'static TextStyle Function',
              description:
                  'Resolves the title\'s text style so a caller building its '
                  'own title-shaped text can match it exactly.',
            ),
            DocsApiFact(
              name: 'DsEmptyDescription.spec',
              type: 'static DsTypeSpec',
              description:
                  'DsComponentType.textareaBody — the resolved rung the '
                  'description renders with.',
            ),
            DocsApiFact(
              name: 'DsEmptyContent.gap / .maxWidth',
              type: 'static double',
              description: '10px gap, 384px measure.',
            ),
          ],
        ),
        SizedBox(height: ds(8)),
        const DocsApiTable(
          title: 'Kbd family properties',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'text',
              type: 'String (positional)',
              description:
                  '(DsKbd) Required. The legend, as authored — "Ctrl", "K".',
            ),
            DocsApiFact(
              name: 'children',
              type: 'List<Widget>',
              description:
                  '(DsKbdGroup) Required. The keys, in order — typically '
                  'DsKbd widgets.',
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
        'None of the three has a size axis. Separator has exactly one enum; '
        'Empty and Kbd have none — their shape comes from composition, not a '
        'variant switch.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const DocsApiTable(
          title: 'DsSeparatorOrientation',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'horizontal',
              type: 'the default',
              description:
                  '1px tall, full parent width. Used between stacked rows.',
            ),
            DocsApiFact(
              name: 'vertical',
              type: 'DsSeparator.vertical()',
              description:
                  '1px wide, stretches to the parent\'s height (needs a '
                  'bounded-height ancestor, e.g. a fixed-height Row, exactly '
                  'as the Preview specimen above does).',
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
              'MergeSemantics wrapper described in Accessibility.',
        ]),
      ],
    ),
  );

  Widget _states() => DsSection(
    id: 'states',
    title: 'States and feedback',
    description:
        'All three are static, presentational StatelessWidgets: none owns '
        'onPressed/enabled, a GestureDetector, a FocusNode, or an async flag '
        'anywhere in its build method. Most of IA §9.7\'s rows genuinely do '
        'not apply, so they are grouped below with the reason, rather than '
        'invented.',
    child: const DocsStateMatrix(
      facts: <DocsStateFact>[
        DocsStateFact(
          state: 'Rest',
          treatment:
              'Separator paints its 1px theme.border fill. Empty paints a '
              'centred column — a muted 32px tile behind the glyph if '
              'DsEmptyMedia is present, the title in theme.foreground, the '
              'description in theme.mutedForeground. Kbd paints a flat '
              'theme.muted fill with theme.mutedForeground text.',
          userSignal: 'The resting paint is the only paint for all three.',
        ),
        DocsStateFact(
          state: '"Empty" (as a matrix row)',
          treatment:
              'This row usually asks what a stateful component looks like '
              'with no data. DsEmpty does not have that state — DsEmpty *is* '
              'the widget another component renders when its own data is '
              'empty. There is no "DsEmpty, but empty" to describe.',
          userSignal:
              'Named explicitly here so the row is not mistaken for an '
              'unfilled gap.',
        ),
        DocsStateFact(
          state: 'Loading / Error / Success',
          treatment:
              'N/A for all three — none owns an async flag. A caller renders '
              'a different DsEmpty (a different glyph/title/description) for '
              'an error versus an empty-by-design state, the same way '
              'DsBadge swaps variant instead of transitioning in place; '
              'DsSeparator and DsKbd carry no concept of either.',
          userSignal: 'A different specimen, not a live state change.',
        ),
        DocsStateFact(
          state: 'Hover / Focus-visible / Pressed / Selected / Disabled',
          treatment:
              'N/A — none of the three owns a GestureDetector, FocusNode, or '
              'onPressed/enabled parameter. DsEmptyContent can *hold* an '
              'interactive child (e.g. the DsButton in the Preview '
              'specimen), whose own states apply to it, not to DsEmpty.',
          userSignal:
              'Compose with an interactive component at the call site — '
              'DsKbd\'s own IgnorePointer makes the "not interactive" '
              'contract explicit for kbd specifically.',
        ),
        DocsStateFact(
          state: 'Reduced motion',
          treatment:
              'N/A — no AnimationController and no motion token appears in '
              'any of the three build methods.',
          userSignal: 'Nothing animates, so nothing needs to still.',
        ),
      ],
    ),
  );

  Widget _accessibility(DsThemeData theme) => DsSection(
    id: 'accessibility',
    title: 'Accessibility and keyboard behavior',
    description:
        'This is the one section where the three genuinely differ, and '
        'where the source has real gaps worth naming plainly rather than '
        'papering over.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DsText('Separator', DsType.label, color: theme.actionInk),
        SizedBox(height: ds(2)),
        _bullets(theme, <String>[
          'Semantic role: none — build() returns a bare SizedBox wrapping a '
              'ColoredBox; no Semantics widget appears anywhere in '
              'separator.dart.',
          'Hidden from assistive tech, but by omission rather than a guard: '
              'the source\'s own doc comment says the port "hides both" '
              '(decorative and orientation) because "a Semantics divider '
              'node carries no information a Flutter reader can use" — but '
              'the implementation reaches that outcome by simply never '
              'creating a semantics node, not via an explicit '
              'Semantics(excludeSemantics: true) or ExcludeSemantics '
              'wrapper. That hides it today (a bare SizedBox/ColoredBox '
              'produces no semantics node on its own), but there is no '
              'defensive marker keeping it hidden if an ancestor ever wraps '
              'it in a Semantics(container: true) — a real, currently '
              'harmless gap, reported rather than silently fixed.',
          'Keyboard: never focusable — no Focus widget or FocusNode exists.',
          'Touch target: not applicable — a rule is not interactive and '
              'makes no target-size guarantee.',
          'Non-colour signal: none needed — it is decorative geometry, not '
              'a status signal.',
          'Known platform differences: none — no platform branch in '
              'separator.dart.',
        ]),
        SizedBox(height: ds(5)),
        DsText('Empty', DsType.label, color: theme.actionInk),
        SizedBox(height: ds(2)),
        _bullets(theme, <String>[
          'Semantic role: none of its own. DsEmpty, DsEmptyHeader, '
              'DsEmptyMedia, and DsEmptyContent are plain Column/Padding/'
              'ConstrainedBox widgets with no Semantics wrapper.',
          'Not silent: DsEmptyTitle and DsEmptyDescription render through '
              'Text (via DsLineBox/DsText), which carries Flutter\'s default '
              'static-text semantics — the title and the description are '
              'individually reachable and readable by a screen reader.',
          'The gap: nothing announces the *arrival* of an empty state. '
              'There is no Semantics(liveRegion: true) anywhere in '
              'empty.dart and no heading semantics on DsEmptyTitle. When an '
              'app swaps a loading list, or an error DsEmpty, for a '
              '"no results" DsEmpty, nothing in this component tells an '
              'assistive-tech user that the content changed — they only '
              'discover the new text if they navigate back to that part of '
              'the tree. The text itself is not silent; its *appearance* '
              'is. Wiring a live announcement at the call site (e.g. '
              'Semantics(liveRegion: true) around the swap, or '
              'SemanticsService.announce) is on the caller today.',
          'DsEmptyMedia\'s icon carries no separate accessible label '
              'parameter of its own — appropriate, since the adjacent '
              'DsEmptyTitle already states the same information in text.',
          'Keyboard: DsEmptyContent commonly holds an interactive child '
              '(a DsButton in the Preview specimen above), which supplies '
              'its own focus and keyboard behavior; DsEmpty adds none.',
          'Known platform differences: none observed — no platform branch '
              'in empty.dart.',
        ]),
        SizedBox(height: ds(5)),
        DsText('Kbd', DsType.label, color: theme.actionInk),
        SizedBox(height: ds(2)),
        _bullets(theme, <String>[
          'Semantic role: none of its own — DsKbd wraps its DsText in '
              'IgnorePointer and SelectionContainer.disabled only; no '
              'Semantics override. The legend reaches assistive tech as '
              'ordinary static text.',
          'The gap: nothing marks it as "a key you press." There is no '
              'semanticLabel such as "key: Esc" and no custom Semantics '
              'role — a screen reader reads "Esc" exactly as it would read '
              'the word "Esc" anywhere else on the page, with no signal '
              'that it names a keyboard key rather than being prose.',
          'One deliberate exception: DsKbdGroup wraps its children in '
              'MergeSemantics, so a grouped shortcut *does* fold into a '
              'single announcement instead of two separate stops ("Ctrl K" '
              'as one node, not "Ctrl" then "K"). The source\'s own comment '
              'frames this directly: a nested kbd is "one keyboard object, '
              'not a container of two."',
          'pointer-events-none / select-none, matched exactly: IgnorePointer '
              'keeps it out of hit-testing, and SelectionContainer.disabled '
              'keeps it out of a SelectionArea\'s copy — the same pair of '
              'behaviors the reference\'s two classes name.',
          'Keyboard: never focusable, same as Separator and Empty.',
          'Touch target: not applicable — inert to touch by design '
              '(IgnorePointer).',
          'Known platform differences: none — no platform branch in '
              'kbd.dart.',
        ]),
      ],
    ),
  );

  Widget _responsive(DsThemeData theme) => DsSection(
    id: 'responsive',
    title: 'Responsive and platform behavior',
    child: _bullets(theme, <String>[
      'No responsive branching — none of the three reads a breakpoint from '
          'BuildContext; all render identically at 390px and 1440px.',
      'Separator has no length of its own on the long axis by design — '
          'width is null when horizontal, height is null when vertical, so '
          'the rule always fills whatever the parent gives it; only the '
          '1px short-axis thickness is fixed.',
      'Empty\'s DsEmptyHeader and DsEmptyContent both cap at 384px '
          '(DsContainers.sm) regardless of viewport. At 390px that cap '
          'rarely binds — the phone\'s own content width is already close '
          'to or narrower than it. At 1440px it is what keeps the title and '
          'description from stretching edge to edge inside a much wider '
          'DsEmpty panel.',
      'Kbd is a fixed 20px-tall, content-wide box with a 20px floor — the '
          'same footprint at 390px and 1440px; only the legend string '
          'changes the width it occupies.',
      'Platform parity: Android, iOS, Web, macOS, Windows, and Linux all '
          'render the same widget tree — no platform-conditional code exists '
          'in separator.dart, empty.dart, or kbd.dart.',
    ]),
  );

  Widget _dependencies(DsThemeData theme) => DsSection(
    id: 'dependencies',
    title: 'Dependencies, files, and assets',
    child: _bullets(theme, <String>[
      'Files: three, one component each, no companion parts — '
          'lib/src/components/separator.dart, empty.dart, kbd.dart.',
      'DsSeparator imports: foundation/spacing.dart (ds(), DsWidths), '
          'foundation/theme.dart (DsThemeData), theme_scope.dart (DsTheme). '
          'No component dependency.',
      'DsEmpty family imports: foundation/spacing.dart, foundation/'
          'theme.dart, foundation/typography.dart (DsComponentType, '
          'DsTypeSpec), text_layout.dart (DsLineBox), theme_scope.dart '
          '(DsText, DsTheme), icon.dart (DsIcon, DsIconTone), '
          'icon_paths.dart (DsIconGlyph). The one of the three with a real '
          'component dependency: DsEmptyMedia renders a DsIcon.',
      'DsKbd family imports: effects/machine_surface.dart (DsMachineSurface), '
          'foundation/shadows.dart (DsShadows.none — named explicitly, see '
          'Theming), foundation/spacing.dart, foundation/theme.dart, '
          'foundation/typography.dart (DsComponentType.kbdKey), '
          'theme_scope.dart. Depends on the machine-surface effect, though '
          'it paints through it with no elevation.',
      'Assets: none. Fonts: none beyond the system type scale every DsText '
          'call already depends on. Shaders: none — kbd\'s machine surface '
          'call is DsShadows.none, a flat fill and border, not a '
          'fragment-shader-backed paint.',
    ]),
  );

  Widget _composition() => DsSection(
    id: 'composition',
    title: 'Composition examples',
    description:
        'Real shapes each of the three is composed into elsewhere in this '
        'package, cited from their actual call sites.',
    child: DocsCodeExample(
      title: 'Composed elsewhere in this package',
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(
          path: 'example/lib/pages/data.dart',
          title: 'The Separator page\'s own specimen',
          description:
              'A balance/bonus divider, then a fixed-height row using '
              'DsSeparator.vertical() between three figures — the exact '
              'shape this page\'s Preview reproduces:',
          code: '''SizedBox(
  height: ds(6), // flex h-6 items-center gap-4
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      figure('412 packs'),
      SizedBox(width: gap),
      const DsSeparator.vertical(),
      SizedBox(width: gap),
      figure('1,284 cards'),
      SizedBox(width: gap),
      const DsSeparator.vertical(),
      SizedBox(width: gap),
      figure('8 sets'),
    ],
  ),
)''',
        ),
        DocsCodeFile(
          path: 'example/lib/site/site_shell.dart',
          title: 'The site search\'s empty state',
          description:
              'What the public site itself renders when a search finds '
              'nothing — glyph, title, description, and a way out:',
          code: '''DsEmpty(
  children: <Widget>[
    const DsEmptyHeader(
      children: <Widget>[
        DsEmptyMedia(glyph: DsIconGlyph.search),
        DsEmptyTitle('Nothing matched that search'),
        DsEmptyDescription(
          'Try a broader term, or jump straight into the documentation index.',
        ),
      ],
    ),
    DsEmptyContent(
      children: <Widget>[
        DsButton(
          variant: DsButtonVariant.secondary,
          onPressed: () => onNavigate(docsRoute),
          child: const Text('Open documentation'),
        ),
      ],
    ),
  ],
)''',
        ),
        DocsCodeFile(
          path: 'example/lib/pages/buttons.dart',
          title: 'The buttons page\'s shortcut list',
          description:
              'A single key and a two-key chord, each paired with the '
              'action it triggers — the exact shape this page\'s Preview '
              'reproduces:',
          code: '''DsRow(
  children: <Widget>[
    // DRIFT 19: a `<kbd>` nesting two `<kbd>`s — the group renders the same
    // element its members do while typed as a `div`.
    DsKbdGroup(children: <Widget>[DsKbd('Ctrl'), DsKbd('K')]),
    DsText('Open search', DsType.small),
  ],
)''',
        ),
      ],
    ),
  );

  Widget _theming(DsThemeData theme) => DsSection(
    id: 'theming',
    title: 'Theming notes',
    child: _bullets(theme, <String>[
      'Separator paints exactly one colour: DsTheme.of(context).border. '
          'Flipping DsThemeController between light and dark re-resolves it '
          'live — nothing is cached (see the Preview specimen, which the '
          'docs test flips in place).',
      'Empty reads theme.muted for the DsEmptyMedia tile, theme.foreground '
          'for the title, and theme.mutedForeground for the description; '
          'the glyph\'s tone is theme-resolved through DsIconTone. All '
          're-resolve on a live theme flip.',
      'Empty\'s corner radius (DsRadii.xl, 16px) shapes nothing today: '
          'there is no border to shape and no background fill on DsEmpty '
          'itself to clip. It is kept because it is what a future border '
          'width would follow, exactly as badge\'s own drift note for a '
          'similar radius explains.',
      'Kbd is the one object in this trio that owns an elevation token and '
          'never wears it: DsShadows.key and DsShadows.keyDown exist for '
          'exactly this object (documented one foundations page away, on '
          'Shadows, as a raised key with a side wall that travels into its '
          'socket) but DsKbd\'s DsMachineSurface call passes DsShadows.none '
          'explicitly — no border, no shadow, no press. It ships flat. The '
          'token set is aspirational; the component that renders is not '
          'using it.',
      'Kbd\'s fill (theme.muted) and ink (theme.mutedForeground) are the '
          'only theme-resolved colours it carries — both re-resolve on a '
          'live flip along with everything else on this page.',
      'None of the three exposes a colour-override parameter of its own — '
          'every colour is theme- or tone-derived, never a bare Color '
          'argument.',
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
          value: separatorDoc.sourcePath,
          description:
              'Authoritative implementations — the truth this page was '
              'written from.',
        ),
        const DocsInstallFact(
          label: 'Package tests',
          value: 'none yet',
          description:
              'No dedicated unit test exists for separator.dart, empty.dart, '
              'or kbd.dart in the package test suite as of this page.',
        ),
        const DocsInstallFact(
          label: 'Docs test',
          value: 'example/test/components_docs/separator_test.dart',
          description:
              'Covers this page: the API tables, a live specimen of every '
              'exported class, and the separator specimen\'s colour actually '
              'changing across a live theme flip.',
        ),
        const DocsInstallFact(
          label: 'Edit these docs',
          value: 'example/lib/components_docs/separator/page.dart',
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
// Separator — the smallest correct call, horizontal by default.
DsSeparator()

// The named constructor for the cross-axis rule.
DsSeparator.vertical()

// Empty — a title, a description, and one way out.
DsEmpty(
  children: [
    DsEmptyHeader(
      children: [
        DsEmptyMedia(glyph: DsIconGlyph.search, tone: DsIconTone.subtle),
        DsEmptyTitle('No results found'),
        DsEmptyDescription('Try a different search term.'),
      ],
    ),
    DsEmptyContent(
      children: [
        DsButton(
          variant: DsButtonVariant.secondary,
          size: DsButtonSize.sm,
          onPressed: () {},
          child: DsText('Clear filters', DsComponentType.buttonLabel),
        ),
      ],
    ),
  ],
)

// Kbd — a single key, and a chord.
DsKbd('Esc')
DsKbdGroup(children: [DsKbd('Ctrl'), DsKbd('K')])''';
