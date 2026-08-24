/// Public documentation page for the `empty` component.
///
/// **Reference shape**, mirrored from shadcn's own
/// `ui.shadcn.com/docs/components/base/empty`, fetched fresh: Installation,
/// Usage, Composition, Outline, Background, Avatar, Avatar Group,
/// InputGroup, RTL, API Reference.
///
/// **Skipped, honestly**, four of those ten:
/// * Outline / Background: the reference's own `<Empty>` always ships
///   `rounded-xl border-dashed` in its base class list (empty.tsx L10, no
///   width class), and its docs demo overrides that with a real `border`
///   utility passed through `className` to make it visible — a prop this
///   Flutter `ElEmpty` does not expose at all. `ElEmpty.build` is
///   `Padding(child: Column(...))`: no `Container`, no `BoxDecoration`, no
///   border or background of any kind. A caller wanting either wraps
///   `ElEmpty` in its own `DecoratedBox` — composition at the call site, not
///   a capability this component owns — so faking a section around a
///   decoration the widget itself never paints would misrepresent it.
/// * Avatar / Avatar Group: `ElEmptyMedia`'s constructor takes `required
///   this.glyph` — a `ElIconGlyph`, not an arbitrary `Widget` child. Unlike
///   `ElItemMedia` (which accepts any widget, see the `item` page's own
///   Avatar section), `ElEmptyMedia` cannot host a `ElAvatar`: there is no
///   avatar variant to build a section around.
///
/// **Composition**'s tree diagram and one real composed shape follow the
/// same convention `stat/page.dart` established for its own Composition
/// section: a leaf/part-widget tree, then a real call site from elsewhere in
/// this package (`example/lib/site/site_shell.dart`'s own search-empty
/// state).
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

class EmptyDocPage extends StatelessWidget {
  const EmptyDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: emptyDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / BASE',
      title: emptyDoc.title,
      description: emptyDoc.description,
    ),
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Components'),
      ElBreadcrumbEntry.page('Empty'),
    ],
    sidebar: _sidebar,
    toc: const <DocsTocEntry>[
      DocsTocEntry(title: 'Installation', anchor: 'install'),
      DocsTocEntry(title: 'Usage', anchor: 'usage'),
      DocsTocEntry(title: 'Composition', anchor: 'composition'),
      DocsTocEntry(title: 'Input group', anchor: 'input-group'),
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
    child: const _EmptyArticle(),
  );
}

const List<DocsSidebarEntry> _sidebar = <DocsSidebarEntry>[
  DocsSidebarEntry(title: 'Accordion', route: '/components/accordion'),
  DocsSidebarEntry(title: 'Alert', route: '/components/alert'),
  DocsSidebarEntry(title: 'Avatar', route: '/components/avatar'),
  DocsSidebarEntry(title: 'Badge', route: '/components/badge'),
  DocsSidebarEntry(title: 'Breadcrumb', route: '/components/breadcrumb'),
  DocsSidebarEntry(title: 'Checkbox', route: '/components/checkbox'),
  DocsSidebarEntry(title: 'Collapsible', route: '/components/collapsible'),
  DocsSidebarEntry(title: 'Empty', route: '/components/empty', selected: true),
  DocsSidebarEntry(title: 'Item', route: '/components/item'),
  DocsSidebarEntry(title: 'Kbd', route: '/components/kbd'),
  DocsSidebarEntry(title: 'Progress', route: '/components/progress'),
  DocsSidebarEntry(title: 'Separator', route: '/components/separator'),
  DocsSidebarEntry(title: 'Skeleton', route: '/components/skeleton'),
  DocsSidebarEntry(title: 'Stat', route: '/components/stat'),
  DocsSidebarEntry(title: 'Switch', route: '/components/switch'),
  DocsSidebarEntry(title: 'Toggle', route: '/components/toggle'),
  DocsSidebarEntry(title: 'Tooltip', route: '/components/tooltip'),
];

class _EmptyArticle extends StatelessWidget {
  const _EmptyArticle();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      key: const ValueKey<String>('empty-doc-article'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _preview(),
        SizedBox(height: el(6)),
        _install(),
        SizedBox(height: el(6)),
        _usage(),
        _composition(),
        _inputGroup(),
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

  Widget _preview() => DocsCodeExample(
    title: 'Empty',
    description:
        'ElEmpty is a structured empty state: an optional media tile, a '
        'title, a description, and one clear way out (ElEmptyContent), '
        'centred in a column with 16px between its parts. Reach for it '
        'whenever a collection, search, or workspace has nothing to show '
        'and the user needs to know why and what to do next. Reach for a '
        'spinner or skeleton instead when the empty appearance is '
        'temporary: ElEmpty never resolves itself, it has no loading '
        'concept.',
    manualFiles: const <DocsCodeFile>[
      DocsCodeFile(
        path: 'lib/components/ui/empty.dart',
        code:
            "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
            '// Install with: elattar add empty',
      ),
    ],
    preview: KeyedSubtree(
      key: const ValueKey<String>('empty-preview'),
      child: ElEmpty(
        children: <Widget>[
          const ElEmptyHeader(
            children: <Widget>[
              ElEmptyMedia(glyph: ElIconGlyph.search, tone: ElIconTone.subtle),
              ElEmptyTitle('No results found'),
              ElEmptyDescription(
                'Try a different search term or clear your filters.',
              ),
            ],
          ),
          ElEmptyContent(
            children: <Widget>[
              ElButton(
                variant: ElButtonVariant.secondary,
                size: ElButtonSize.sm,
                onPressed: () {},
                child: ElText('Clear filters', ElComponentType.buttonLabel),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  Widget _install() => ElSection(
    id: 'install',
    title: 'Installation',
    description:
        '`elattar add empty` installs the component and its declared '
        'dependency closure.',
    child: DocsInstallFacts(
      title: 'Installation facts',
      facts: <DocsInstallFact>[
        const DocsInstallFact(
          label: 'Registry item',
          value: 'registry/components/empty.json',
          description: 'Shipped and resolved by `elattar add empty`.',
        ),
        const DocsInstallFact(
          label: 'Destination',
          value: 'lib/components/ui/empty.dart',
          description: 'Where a manual copy of the source file belongs.',
        ),
        const DocsInstallFact(
          label: 'Foundation',
          value: 'source only',
          description: 'No package-backed alternative is offered yet.',
        ),
        const DocsInstallFact(
          label: 'Dependencies',
          value: 'source-foundation, icon',
          description:
              'ElEmpty needs spacing/theme/typography plus the icon '
              'component (ElEmptyMedia renders a ElIcon). Not resolved '
              'automatically today; copy the imports by hand.',
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
          description: 'No platform-conditional code in empty.dart.',
        ),
        const DocsInstallFact(
          label: 'Verified',
          value: 'docs specimen only',
          description:
              'This page\'s live preview and '
              'example/test/components_docs/empty_test.dart. No dedicated '
              'package-level unit test and no registry fixture install '
              'exist yet.',
        ),
      ],
    ),
  );

  Widget _usage() => ElSection(
    id: 'usage',
    title: 'Usage',
    description: 'The smallest correct call for each part.',
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
        'ElEmpty has no size or variant axis: its shape comes entirely '
        'from which of the six parts a caller includes, not from a prop. '
        'Below: the part tree, then a real composed shape from elsewhere in '
        'this package.',
    child: DocsCodeExample(
      title: 'Composed elsewhere in this package',
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(
          path: 'empty_tree.txt',
          title: 'The part tree',
          code: '''ElEmpty
├─ ElEmptyHeader
│  ├─ ElEmptyMedia        (optional)
│  ├─ ElEmptyTitle
│  └─ ElEmptyDescription
└─ ElEmptyContent''',
        ),
        DocsCodeFile(
          path: 'example/lib/site/site_shell.dart',
          title: 'The site search\'s empty state',
          description:
              'What the public site itself renders when a search finds '
              'nothing: glyph, title, description, and a way out.',
          code: '''ElEmpty(
  children: <Widget>[
    const ElEmptyHeader(
      children: <Widget>[
        ElEmptyMedia(glyph: ElIconGlyph.search),
        ElEmptyTitle('Nothing matched that search'),
        ElEmptyDescription(
          'Try a broader term, or jump straight into the documentation index.',
        ),
      ],
    ),
    ElEmptyContent(
      children: <Widget>[
        ElButton(
          variant: ElButtonVariant.secondary,
          onPressed: () => onNavigate(docsRoute),
          child: const Text('Open documentation'),
        ),
      ],
    ),
  ],
)''',
        ),
      ],
    ),
  );

  Widget _inputGroup() => ElSection(
    id: 'input-group',
    title: 'Input group',
    description:
        'ElEmptyContent\'s "way out" does not have to be a button: any '
        'widget is a valid child, including a ElInputGroup that lets the '
        'reader search again in place.',
    child: DocsCodeExample(
      title: 'An empty state whose action is a search field',
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(
          path: 'empty_input_group.dart',
          code: '''ElEmpty(
  children: [
    const ElEmptyHeader(
      children: [
        ElEmptyMedia(glyph: ElIconGlyph.search, tone: ElIconTone.subtle),
        ElEmptyTitle('No results found'),
        ElEmptyDescription('Try a broader search term.'),
      ],
    ),
    ElEmptyContent(
      children: [
        ElInputGroup(
          startAddon: ElInputGroupAddon(
            child: ElIcon(ElIconGlyph.search, size: ElIconSize.sm),
          ),
          child: ElInputGroupInput(placeholder: 'Search again...'),
        ),
      ],
    ),
  ],
)''',
        ),
      ],
      preview: KeyedSubtree(
        key: const ValueKey<String>('empty-example:input-group'),
        child: ElEmpty(
          children: <Widget>[
            const ElEmptyHeader(
              children: <Widget>[
                ElEmptyMedia(
                  glyph: ElIconGlyph.search,
                  tone: ElIconTone.subtle,
                ),
                ElEmptyTitle('No results found'),
                ElEmptyDescription('Try a broader search term.'),
              ],
            ),
            ElEmptyContent(
              children: <Widget>[
                ElInputGroup(
                  startAddon: ElInputGroupAddon(
                    child: ElIcon(
                      ElIconGlyph.search,
                      size: ElIconSize.sm,
                      tone: ElIconTone.inherit,
                    ),
                  ),
                  child: const ElInputGroupInput(
                    placeholder: 'Search again...',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );

  Widget _rtl(ElThemeData theme) => ElSection(
    id: 'rtl',
    title: 'RTL',
    description:
        'ElEmpty paints no direction-specific layout of its own: it is a '
        'centred column with a short-measure cap on both header and '
        'content, and it reads right-to-left under a plain Directionality.',
    child: ElPanel(
      label: 'PREVIEW',
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: KeyedSubtree(
          key: const ValueKey<String>('rtl-example:empty'),
          child: ElEmpty(
            children: <Widget>[
              const ElEmptyHeader(
                children: <Widget>[
                  ElEmptyMedia(glyph: ElIconGlyph.search),
                  ElEmptyTitle('لا توجد نتائج'),
                  ElEmptyDescription('جرب كلمة بحث مختلفة.'),
                ],
              ),
              ElEmptyContent(
                children: <Widget>[
                  ElButton(
                    variant: ElButtonVariant.secondary,
                    size: ElButtonSize.sm,
                    onPressed: () {},
                    child: ElText('مسح الفلاتر', ElComponentType.buttonLabel),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );

  Widget _api(ElThemeData theme) => ElSection(
    id: 'api',
    title: 'API Reference',
    description:
        'One prop table per exported class, plus a static-tokens table for '
        'each.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        KeyedSubtree(
          key: docsAnchorKey('api-elempty'),
          child: const DocsApiTable(
            title: 'ElEmpty',
            facts: <DocsApiFact>[
              DocsApiFact(
                name: 'children',
                type: 'List<Widget>',
                description:
                    'Required. Typically a ElEmptyHeader and a '
                    'ElEmptyContent, in order, joined by a 16px gap '
                    '(ElEmpty.gap).',
              ),
            ],
          ),
        ),
        SizedBox(height: el(4)),
        const DocsApiTable(
          title: 'ElEmpty static tokens',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'ElEmpty.padding',
              type: 'static double',
              description: '24px outer padding.',
            ),
            DocsApiFact(
              name: 'ElEmpty.gap',
              type: 'static double',
              description: '16px between children.',
            ),
            DocsApiFact(
              name: 'ElEmpty.radius',
              type: 'static double',
              description:
                  '16px corner radius. Shapes nothing today: ElEmpty paints '
                  'no border or background to clip (see Theming).',
            ),
          ],
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-elemptyheader'),
          child: const DocsApiTable(
            title: 'ElEmptyHeader',
            facts: <DocsApiFact>[
              DocsApiFact(
                name: 'children',
                type: 'List<Widget>',
                description:
                    'Required. The media, the title, and the description, '
                    'capped at a 384px measure and joined by an 8px gap.',
              ),
            ],
          ),
        ),
        SizedBox(height: el(4)),
        const DocsApiTable(
          title: 'ElEmptyHeader static tokens',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'ElEmptyHeader.gap',
              type: 'static double',
              description: '8px between children.',
            ),
            DocsApiFact(
              name: 'ElEmptyHeader.maxWidth',
              type: 'static double',
              description: '384px (ElContainers.sm).',
            ),
          ],
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-elemptymedia'),
          child: const DocsApiTable(
            title: 'ElEmptyMedia',
            facts: <DocsApiFact>[
              DocsApiFact(
                name: 'glyph',
                type: 'ElIconGlyph',
                description:
                    'Required. The icon drawn inside the 32px tile. Not an '
                    'arbitrary widget slot: ElEmptyMedia cannot host a '
                    'ElAvatar (compare ElItemMedia on the item page, which '
                    'takes any Widget).',
              ),
              DocsApiFact(
                name: 'tone',
                type: 'ElIconTone',
                description: 'Optional. Defaults to ElIconTone.normal.',
              ),
            ],
          ),
        ),
        SizedBox(height: el(4)),
        const DocsApiTable(
          title: 'ElEmptyMedia static tokens',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'ElEmptyMedia.box',
              type: 'static double',
              description: '32px tile.',
            ),
            DocsApiFact(
              name: 'ElEmptyMedia.radius',
              type: 'static double',
              description: '12px corners.',
            ),
            DocsApiFact(
              name: 'ElEmptyMedia.marginBottom',
              type: 'static double',
              description: '8px gap to the title.',
            ),
            DocsApiFact(
              name: 'ElEmptyMedia.glyphSize',
              type: 'static double',
              description:
                  '16px: the glyph box actually drawn, forced regardless of '
                  'the ElIconSize rung passed elsewhere (a deliberate '
                  'drift, see Theming).',
            ),
            DocsApiFact(
              name: 'ElEmptyMedia.glyphStroke',
              type: 'static double',
              description:
                  'The stroke width computed for a 24px glyph (2), not the '
                  '16px rung\'s own 2.4: the same deliberate drift.',
            ),
          ],
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-elemptytitle'),
          child: const DocsApiTable(
            title: 'ElEmptyTitle',
            facts: <DocsApiFact>[
              DocsApiFact(
                name: 'text',
                type: 'String (positional)',
                description:
                    'Required. The heading, 13px/500, −0.26px tracking.',
              ),
            ],
          ),
        ),
        SizedBox(height: el(4)),
        const DocsApiTable(
          title: 'ElEmptyTitle static members',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'ElEmptyTitle.styleOf(context, {color})',
              type: 'static TextStyle Function',
              description:
                  'Resolves the title\'s text style so a caller building '
                  'its own title-shaped text can match it exactly.',
            ),
          ],
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-elemptydescription'),
          child: const DocsApiTable(
            title: 'ElEmptyDescription',
            facts: <DocsApiFact>[
              DocsApiFact(
                name: 'text',
                type: 'String (positional)',
                description:
                    'Required. The supporting sentence, 13px/400, 1.625 '
                    'line height, theme.mutedForeground.',
              ),
            ],
          ),
        ),
        SizedBox(height: el(4)),
        const DocsApiTable(
          title: 'ElEmptyDescription static members',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'ElEmptyDescription.spec',
              type: 'static ElTypeSpec',
              description:
                  'ElComponentType.textareaBody: the resolved rung the '
                  'description renders with.',
            ),
          ],
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-elemptycontent'),
          child: const DocsApiTable(
            title: 'ElEmptyContent',
            facts: <DocsApiFact>[
              DocsApiFact(
                name: 'children',
                type: 'List<Widget>',
                description:
                    'Required. The way out: one or more actions, capped at '
                    'a 384px measure, joined by a 10px gap.',
              ),
            ],
          ),
        ),
        SizedBox(height: el(4)),
        const DocsApiTable(
          title: 'ElEmptyContent static tokens',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'ElEmptyContent.gap',
              type: 'static double',
              description: '10px between children.',
            ),
            DocsApiFact(
              name: 'ElEmptyContent.maxWidth',
              type: 'static double',
              description: '384px (ElContainers.sm).',
            ),
          ],
        ),
      ],
    ),
  );

  Widget _states() => ElSection(
    id: 'states',
    title: 'States',
    description:
        'ElEmpty and every part are static, presentational '
        'StatelessWidgets: none owns onPressed/enabled, a GestureDetector, '
        'a FocusNode, or an async flag.',
    child: const DocsStateMatrix(
      facts: <DocsStateFact>[
        DocsStateFact(
          state: 'Rest',
          treatment:
              'Paints a centred column: a muted 32px tile behind the glyph '
              'if ElEmptyMedia is present, the title in theme.foreground, '
              'the description in theme.mutedForeground.',
          userSignal: 'The resting paint is the only paint.',
        ),
        DocsStateFact(
          state: '"Empty" (as a matrix row)',
          treatment:
              'This row usually asks what a stateful component looks like '
              'with no data. ElEmpty does not have that state: ElEmpty *is* '
              'the widget another component renders when its own data is '
              'empty.',
          userSignal:
              'Named explicitly so this row is not mistaken for an '
              'unfilled gap.',
        ),
        DocsStateFact(
          state: 'Loading / Error / Success',
          treatment:
              'N/A: ElEmpty owns no async flag. A caller renders a '
              'different ElEmpty (a different glyph/title/description) for '
              'an error versus an empty-by-design state.',
          userSignal: 'A different specimen, not a live state change.',
        ),
        DocsStateFact(
          state: 'Hover / Focus-visible / Pressed / Selected / Disabled',
          treatment:
              'N/A: ElEmpty owns none of these. ElEmptyContent can *hold* '
              'an interactive child (the ElButton in Preview above), whose '
              'own states apply to it, not to ElEmpty.',
          userSignal: 'Compose with an interactive component at the call site.',
        ),
        DocsStateFact(
          state: 'Reduced motion',
          treatment:
              'N/A: no AnimationController and no motion token appears in '
              'empty.dart.',
          userSignal: 'Nothing animates, so nothing needs to still.',
        ),
      ],
    ),
  );

  Widget _accessibility(ElThemeData theme) => ElSection(
    id: 'accessibility',
    title: 'Accessibility',
    child: _bullets(theme, <String>[
      'Semantic role: none of its own. ElEmpty, ElEmptyHeader, '
          'ElEmptyMedia, and ElEmptyContent are plain Column/Padding/'
          'ConstrainedBox widgets with no Semantics wrapper.',
      'Not silent: ElEmptyTitle and ElEmptyDescription render through '
          'Text (via ElLineBox/ElText), which carries Flutter\'s default '
          'static-text semantics: the title and the description are '
          'individually reachable and readable by a screen reader.',
      'The gap: nothing announces the *arrival* of an empty state. There '
          'is no Semantics(liveRegion: true) anywhere in empty.dart and no '
          'heading semantics on ElEmptyTitle. When an app swaps a loading '
          'list, or an error ElEmpty, for a "no results" ElEmpty, nothing '
          'in this component tells an assistive-tech user that the '
          'content changed: they only discover the new text if they '
          'navigate back to that part of the tree. Wiring a live '
          'announcement at the call site (e.g. '
          'Semantics(liveRegion: true) around the swap, or '
          'SemanticsService.announce) is on the caller today.',
      'ElEmptyMedia\'s icon carries no separate accessible label '
          'parameter of its own: appropriate, since the adjacent '
          'ElEmptyTitle already states the same information in text.',
      'Keyboard: ElEmptyContent commonly holds an interactive child (a '
          'ElButton in the Preview specimen above), which supplies its '
          'own focus and keyboard behavior; ElEmpty adds none.',
      'Known platform differences: none observed: no platform branch in '
          'empty.dart.',
    ]),
  );

  Widget _responsive(ElThemeData theme) => ElSection(
    id: 'responsive',
    title: 'Responsive',
    child: _bullets(theme, <String>[
      'No responsive branching: BuildContext width is never read for a '
          'layout decision; the same widget tree renders at 390px and '
          '1440px.',
      'ElEmptyHeader and ElEmptyContent both cap at 384px '
          '(ElContainers.sm) regardless of viewport. At 390px that cap '
          'rarely binds: the phone\'s own content width is already close '
          'to or narrower than it. At 1440px it keeps the title and '
          'description from stretching edge to edge inside a much wider '
          'ElEmpty panel.',
      'Platform parity: Android, iOS, Web, macOS, Windows, and Linux all '
          'render the same widget tree.',
    ]),
  );

  Widget _dependencies(ElThemeData theme) => ElSection(
    id: 'dependencies',
    title: 'Dependencies',
    child: _bullets(theme, <String>[
      'File: lib/src/components/empty.dart, one file, no companions.',
      'Imports: foundation/spacing.dart, foundation/theme.dart, '
          'foundation/typography.dart (ElComponentType, ElTypeSpec), '
          'text_layout.dart (ElLineBox), theme_scope.dart (ElText, '
          'ElTheme), icon.dart (ElIcon, ElIconTone), icon_paths.dart '
          '(ElIconGlyph). The one real component dependency: ElEmptyMedia '
          'renders a ElIcon.',
      'Assets: none. Fonts: none beyond the system type scale every '
          'ElText call already depends on. Shaders: none.',
    ]),
  );

  Widget _theming(ElThemeData theme) => ElSection(
    id: 'theming',
    title: 'Theming',
    child: _bullets(theme, <String>[
      'Media background is theme.muted, title is theme.foreground, '
          'description is theme.mutedForeground; the glyph\'s tone is '
          'theme-resolved through ElIconTone. All re-resolve on a live '
          'theme flip.',
      'The corner radius (ElRadii.xl, 16px) shapes nothing today: there '
          'is no border to shape and no background fill on ElEmpty itself '
          'to clip. It is kept because it is what a future border width '
          'would follow.',
      'ElEmptyMedia\'s icon is a deliberate drift, not an oversight: it '
          'draws at a forced 16px with the stroke width computed for '
          '24px (2, not the 2.4 a genuine 16px glyph gets elsewhere in '
          'this package), matching the reference\'s own '
          '`[&_svg:not([class*=\'size-\'])]:size-4` override.',
      'No colour-override parameter of its own: every colour is theme- '
          'or tone-derived, never a bare Color argument.',
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
          value: emptyDoc.sourcePath,
          description:
              'Authoritative implementation: the truth this page was '
              'written from.',
        ),
        const DocsInstallFact(
          label: 'Package tests',
          value: 'none yet',
          description:
              'No dedicated unit test exists for empty.dart in the '
              'package test suite as of this page.',
        ),
        const DocsInstallFact(
          label: 'Docs test',
          value: 'example/test/components_docs/empty_test.dart',
          description:
              'Covers this page: the API tables, live specimens, and '
              'both themes.',
        ),
        const DocsInstallFact(
          label: 'Edit these docs',
          value: 'example/lib/components_docs/empty/page.dart',
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

ElEmpty(
  children: [
    ElEmptyHeader(
      children: [
        ElEmptyMedia(glyph: ElIconGlyph.search, tone: ElIconTone.subtle),
        ElEmptyTitle('No results found'),
        ElEmptyDescription('Try a different search term.'),
      ],
    ),
    ElEmptyContent(
      children: [
        ElButton(
          variant: ElButtonVariant.secondary,
          size: ElButtonSize.sm,
          onPressed: () {},
          child: ElText('Clear filters', ElComponentType.buttonLabel),
        ),
      ],
    ),
  ],
)''';
