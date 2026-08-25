/// Public documentation page for the `empty` component.
///
/// **Re-housed onto the kit.** This page used to hand-compose `ElSection`
/// panels; it now declares a `ComponentDocSpec`
/// (`example/lib/docs/component_doc_page.dart`) and hands it to
/// `ComponentDocPage`, the shape `button` established. Every specimen
/// widget and every code string the old page carried moves across
/// unchanged. Two things are new: the unheaded top-of-page preview is now a
/// real `Preview` section with its own rail entry (matching `button` and
/// `separator`), and a Keyboard disclosure sits between Accessibility and
/// Responsive.
///
/// **The manifest is real.** `registry/components/empty.json` ships today:
/// `elattar add empty` installs `lib/src/components/empty.dart` and
/// resolves `icon` and `source-foundation` automatically.
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
/// **Composition** has nothing live of its own to stage on top of what
/// Preview already shows: it is a part tree plus a real call site quoted
/// from elsewhere in this package, so it stays a `SnippetSection` rather
/// than manufacturing a second, redundant specimen.
///
/// [ComponentDocEntry.description] is the page's only rendered description;
/// no second hero paragraph renders beneath it.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/component_doc_page.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../docs/docs_section.dart' show DocsAnchor;
import 'meta.dart';

final ComponentDocSpec emptyDocSpec = ComponentDocSpec(
  name: 'empty',
  title: emptyDoc.title,
  description: emptyDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'ElEmpty is a structured empty state: an optional media tile, a '
          'title, a description, and one clear way out (ElEmptyContent), '
          'centred in a column with 16px between its parts. Reach for it '
          'whenever a collection, search, or workspace has nothing to show '
          'and the user needs to know why and what to do next. Reach for a '
          'spinner or skeleton instead when the empty appearance is '
          'temporary: ElEmpty never resolves itself, it has no loading '
          'concept.',
      specimen: _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'empty has a real registry manifest, `elattar add empty` '
          'installs lib/src/components/empty.dart and resolves icon and '
          'source-foundation automatically. The Manual tab is for a '
          'project not using the CLI.',
      command: emptyDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/empty.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/empty.dart's generated "
              '@ui/empty.dart payload into components/ui.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated empty source here when using manual '
              'mode.',
        ),
        const DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so ElEmpty and its five parts are '
              'reachable the same way the CLI path already makes them.',
          code: "export 'empty.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description: 'The smallest correct call for each part.',
      code: _usageCode,
    ),
    SnippetSection(
      id: 'composition',
      title: 'Composition',
      description:
          'ElEmpty has no size or variant axis: its shape comes entirely '
          'from which of the six parts a caller includes, not from a prop. '
          'Nothing live to stage beyond what Preview already shows, so '
          'here: the part tree, then a real composed shape from elsewhere '
          'in this package.',
      code: '$_compositionTree\n\n$_compositionSiteCode',
    ),
    ShowcaseSection(
      id: 'input-group',
      title: 'Input group',
      description:
          'ElEmptyContent\'s "way out" does not have to be a button: any '
          'widget is a valid child, including a ElInputGroup that lets the '
          'reader search again in place.',
      specimen: _InputGroupSpecimen(),
      code: _inputGroupCode,
      label: 'Input group specimen view',
    ),
    ShowcaseSection(
      id: 'rtl',
      title: 'RTL',
      description:
          'ElEmpty paints no direction-specific layout of its own: it is a '
          'centred column with a short-measure cap on both header and '
          'content, and it reads right-to-left under a plain '
          'Directionality.',
      specimen: _RtlSpecimen(),
      code: _rtlCode,
      label: 'RTL specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'One prop table per exported class, plus a static-tokens table '
          'for each.',
      children: const <DocsTocEntry>[
        DocsTocEntry(title: 'ElEmpty', anchor: 'api-elempty'),
        DocsTocEntry(title: 'ElEmptyHeader', anchor: 'api-elemptyheader'),
        DocsTocEntry(title: 'ElEmptyMedia', anchor: 'api-elemptymedia'),
        DocsTocEntry(title: 'ElEmptyTitle', anchor: 'api-elemptytitle'),
        DocsTocEntry(
          title: 'ElEmptyDescription',
          anchor: 'api-elemptydescription',
        ),
        DocsTocEntry(title: 'ElEmptyContent', anchor: 'api-elemptycontent'),
      ],
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'ElEmpty and every part are static, presentational '
          'StatelessWidgets: none owns onPressed/enabled, a '
          'GestureDetector, a FocusNode, or an async flag.',
      child: const DocsStateMatrix(facts: _stateFacts),
    ),
    DisclosureSection(
      id: 'accessibility',
      title: 'Accessibility',
      child: _AccessibilityContent(),
    ),
    DisclosureSection(
      id: 'keyboard',
      title: 'Keyboard',
      child: _OneSentence(
        'ElEmpty adds no keyboard behaviour of its own: nothing in '
        'empty.dart owns a Focus node or a key handler, so tab order on an '
        'empty state comes entirely from whatever interactive child '
        'ElEmptyContent happens to hold (the ElButton in Preview above, '
        'say), the same way that child supplies its own focus and '
        'keyboard handling anywhere else it is used.',
      ),
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
    ),
  ],
);

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
    toc: emptyDocSpec.toc,
    previous: null,
    next: null,
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('empty-doc-article'),
      child: ComponentDocPage(spec: emptyDocSpec, header: false),
    ),
  );
}

/* ── Disclosure content ─────────────────────────────────────────────────── */

/// One honest sentence, for a disclosure this component has nothing more to
/// say under.
class _OneSentence extends StatelessWidget {
  const _OneSentence(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: ElWidths.prose),
    child: ElText(
      text,
      ElType.small,
      color: ElTheme.of(context).mutedForeground,
    ),
  );
}

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsAnchor(
        id: 'api-elempty',
        child: DocsApiTable(
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
      const DocsAnchor(
        id: 'api-elemptyheader',
        child: DocsApiTable(
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
      const DocsAnchor(
        id: 'api-elemptymedia',
        child: DocsApiTable(
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
      const DocsAnchor(
        id: 'api-elemptytitle',
        child: DocsApiTable(
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
      const DocsAnchor(
        id: 'api-elemptydescription',
        child: DocsApiTable(
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
      const DocsAnchor(
        id: 'api-elemptycontent',
        child: DocsApiTable(
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
  );
}

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'Semantic role: none of its own. ElEmpty, ElEmptyHeader, '
            'ElEmptyMedia, and ElEmptyContent are plain Column/Padding/'
            'ConstrainedBox widgets with no Semantics wrapper.',
        'Not silent: ElEmptyTitle and ElEmptyDescription render through '
            'Text (via ElLineBox/ElText), which carries Flutter\'s default '
            'static-text semantics: the title and the description are '
            'individually reachable and readable by a screen reader.',
        'The gap: nothing announces the *arrival* of an empty state. '
            'There is no Semantics(liveRegion: true) anywhere in '
            'empty.dart and no heading semantics on ElEmptyTitle. Wiring a '
            'live announcement at the call site (e.g. Semantics(liveRegion: '
            'true) around the swap, or SemanticsService.announce) is on '
            'the caller today.',
        'ElEmptyMedia\'s icon carries no separate accessible label '
            'parameter of its own: appropriate, since the adjacent '
            'ElEmptyTitle already states the same information in text.',
        'Known platform differences: none observed: no platform branch in '
            'empty.dart.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'No responsive branching: BuildContext width is never read for a '
            'layout decision; the same widget tree renders at 390px and '
            '1440px.',
        'ElEmptyHeader and ElEmptyContent both cap at 384px '
            '(ElContainers.sm) regardless of viewport. At 390px that cap '
            'rarely binds: the phone\'s own content width is already '
            'close to or narrower than it. At 1440px it keeps the title '
            'and description from stretching edge to edge inside a much '
            'wider ElEmpty panel.',
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
        title: 'Dependencies',
        facts: <DocsInstallFact>[
          DocsInstallFact(
            label: 'Files',
            value: emptyDoc.sourcePath,
            description: 'One file, no companions.',
          ),
          const DocsInstallFact(
            label: 'Imports',
            value: 'foundation/spacing.dart, foundation/theme.dart, '
                'foundation/typography.dart (ElComponentType, '
                'ElTypeSpec), text_layout.dart (ElLineBox), '
                'theme_scope.dart (ElText, ElTheme), icon.dart (ElIcon, '
                'ElIconTone), icon_paths.dart (ElIconGlyph)',
            description:
                'The one real component dependency: ElEmptyMedia renders '
                'a ElIcon.',
          ),
          const DocsInstallFact(
            label: 'Assets, fonts, shaders',
            value: 'None',
            description:
                'No images, icon fonts, or binary assets; no shader-'
                'backed paint.',
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
                'example/test/components_docs/empty_test.dart. No '
                'dedicated package-level unit test and no registry '
                'fixture install exist yet.',
          ),
        ],
      ),
      SizedBox(height: el(4)),
      DocsLinkRow(
        links: <DocsLink>[
          const DocsLink(label: 'Icon', route: '/components/icon'),
          const DocsLink(
            label: 'Input Group',
            route: '/components/input_group',
          ),
        ],
      ),
      SizedBox(height: el(2)),
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: ElWidths.prose),
        child: ElText(
          'Icon is a real dependency: ElEmptyMedia renders one. Input '
          'Group is not: it is shown composed inside ElEmptyContent in '
          'the Input group section above, a relationship at the call '
          'site rather than something empty.dart imports.',
          ElType.small,
          color: ElTheme.of(context).mutedForeground,
        ),
      ),
    ],
  );
}

class _ThemingContent extends StatelessWidget {
  const _ThemingContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'Media background is theme.muted, title is theme.foreground, '
            'description is theme.mutedForeground; the glyph\'s tone is '
            'theme-resolved through ElIconTone. All re-resolve on a live '
            'theme flip.',
        'The corner radius (ElRadii.xl, 16px) shapes nothing today: there '
            'is no border to shape and no background fill on ElEmpty '
            'itself to clip. It is kept because it is what a future '
            'border width would follow.',
        'ElEmptyMedia\'s icon is a deliberate drift, not an oversight: it '
            'draws at a forced 16px with the stroke width computed for '
            '24px (2, not the 2.4 a genuine 16px glyph gets elsewhere in '
            'this package), matching the reference\'s own '
            '`[&_svg:not([class*=\'size-\'])]:size-4` override.',
        'No colour-override parameter of its own: every colour is theme- '
            'or tone-derived, never a bare Color argument.',
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

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Rest',
    treatment:
        'Paints a centred column: a muted 32px tile behind the glyph if '
        'ElEmptyMedia is present, the title in theme.foreground, the '
        'description in theme.mutedForeground.',
    userSignal: 'The resting paint is the only paint.',
  ),
  DocsStateFact(
    state: '"Empty" (as a matrix row)',
    treatment:
        'This row usually asks what a stateful component looks like with '
        'no data. ElEmpty does not have that state: ElEmpty *is* the '
        'widget another component renders when its own data is empty.',
    userSignal:
        'Named explicitly so this row is not mistaken for an unfilled '
        'gap.',
  ),
  DocsStateFact(
    state: 'Loading / Error / Success',
    treatment:
        'N/A: ElEmpty owns no async flag. A caller renders a different '
        'ElEmpty (a different glyph/title/description) for an error '
        'versus an empty-by-design state.',
    userSignal: 'A different specimen, not a live state change.',
  ),
  DocsStateFact(
    state: 'Hover / Focus-visible / Pressed / Selected / Disabled',
    treatment:
        'N/A: ElEmpty owns none of these. ElEmptyContent can *hold* an '
        'interactive child (the ElButton in Preview above), whose own '
        'states apply to it, not to ElEmpty.',
    userSignal: 'Compose with an interactive component at the call site.',
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment:
        'N/A: no AnimationController and no motion token appears in '
        'empty.dart.',
    userSignal: 'Nothing animates, so nothing needs to still.',
  ),
];

/* ── Showcase specimens ─────────────────────────────────────────────────── */

class _PreviewSpecimen extends StatelessWidget {
  const _PreviewSpecimen();

  @override
  Widget build(BuildContext context) => const KeyedSubtree(
    key: ValueKey<String>('empty-preview'),
    child: ElEmpty(
      children: <Widget>[
        ElEmptyHeader(
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
            _ClearFiltersButton(),
          ],
        ),
      ],
    ),
  );
}

class _ClearFiltersButton extends StatelessWidget {
  const _ClearFiltersButton();

  @override
  Widget build(BuildContext context) => ElButton(
    variant: ElButtonVariant.secondary,
    size: ElButtonSize.sm,
    onPressed: () {},
    child: ElText('Clear filters', ElComponentType.buttonLabel),
  );
}

class _InputGroupSpecimen extends StatelessWidget {
  const _InputGroupSpecimen();

  @override
  Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<String>('empty-example:input-group'),
    child: ElEmpty(
      children: <Widget>[
        const ElEmptyHeader(
          children: <Widget>[
            ElEmptyMedia(glyph: ElIconGlyph.search, tone: ElIconTone.subtle),
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
              child: const ElInputGroupInput(placeholder: 'Search again...'),
            ),
          ],
        ),
      ],
    ),
  );
}

class _RtlSpecimen extends StatelessWidget {
  const _RtlSpecimen();

  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: TextDirection.rtl,
    child: const KeyedSubtree(
      key: ValueKey<String>('rtl-example:empty'),
      child: ElEmpty(
        children: <Widget>[
          ElEmptyHeader(
            children: <Widget>[
              ElEmptyMedia(glyph: ElIconGlyph.search),
              ElEmptyTitle('لا توجد نتائج'),
              ElEmptyDescription('جرب كلمة بحث مختلفة.'),
            ],
          ),
          ElEmptyContent(children: <Widget>[_ClearFiltersArButton()]),
        ],
      ),
    ),
  );
}

class _ClearFiltersArButton extends StatelessWidget {
  const _ClearFiltersArButton();

  @override
  Widget build(BuildContext context) => ElButton(
    variant: ElButtonVariant.secondary,
    size: ElButtonSize.sm,
    onPressed: () {},
    child: ElText('مسح الفلاتر', ElComponentType.buttonLabel),
  );
}

/* ── Code strings ───────────────────────────────────────────────────────── */

const String _previewCode = '''
ElEmpty(
  children: [
    ElEmptyHeader(
      children: [
        ElEmptyMedia(glyph: ElIconGlyph.search, tone: ElIconTone.subtle),
        ElEmptyTitle('No results found'),
        ElEmptyDescription('Try a different search term or clear your filters.'),
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

const String _compositionTree = '''ElEmpty
├─ ElEmptyHeader
│  ├─ ElEmptyMedia        (optional)
│  ├─ ElEmptyTitle
│  └─ ElEmptyDescription
└─ ElEmptyContent''';

const String _compositionSiteCode = '''// example/lib/site/site_shell.dart — the site search's empty state
ElEmpty(
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
)''';

const String _inputGroupCode = '''ElEmpty(
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
)''';

const String _rtlCode = '''Directionality(
  textDirection: TextDirection.rtl,
  child: ElEmpty(
    children: [
      ElEmptyHeader(
        children: [
          ElEmptyMedia(glyph: ElIconGlyph.search),
          ElEmptyTitle('لا توجد نتائج'),
          ElEmptyDescription('جرب كلمة بحث مختلفة.'),
        ],
      ),
      ElEmptyContent(
        children: [
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
)''';
