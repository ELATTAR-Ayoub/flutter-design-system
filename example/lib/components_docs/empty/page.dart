/// Public documentation page for the `empty` component.
///
/// **Re-housed onto the kit.** This page used to hand-compose `Section`
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
///   Flutter `Empty` does not expose at all. `Empty.build` is
///   `Padding(child: Column(...))`: no `Container`, no `BoxDecoration`, no
///   border or background of any kind. A caller wanting either wraps
///   `Empty` in its own `DecoratedBox` — composition at the call site, not
///   a capability this component owns — so faking a section around a
///   decoration the widget itself never paints would misrepresent it.
/// * Avatar / Avatar Group: `EmptyMedia`'s constructor takes `required
///   this.glyph` — a `IconGlyph`, not an arbitrary `Widget` child. Unlike
///   `ItemMedia` (which accepts any widget, see the `item` page's own
///   Avatar section), `EmptyMedia` cannot host a `Avatar`: there is no
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

final ComponentDocSpec emptyDocSpec = ComponentDocSpec(
  name: 'empty',
  title: emptyDoc.title,
  description: emptyDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'Empty is a structured empty state: an optional media tile, a '
          'title, a description, and one clear way out (EmptyContent), '
          'centred in a column with 16px between its parts. Reach for it '
          'whenever a collection, search, or workspace has nothing to show '
          'and the user needs to know why and what to do next. Reach for a '
          'spinner or skeleton instead when the empty appearance is '
          'temporary: Empty never resolves itself, it has no loading '
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
              'Add the export line so Empty and its five parts are '
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
          'Empty has no size or variant axis: its shape comes entirely '
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
          'EmptyContent\'s "way out" does not have to be a button: any '
          'widget is a valid child, including a InputGroup that lets the '
          'reader search again in place.',
      specimen: _InputGroupSpecimen(),
      code: _inputGroupCode,
      label: 'Input group specimen view',
    ),
    ShowcaseSection(
      id: 'rtl',
      title: 'RTL',
      description:
          'Empty paints no direction-specific layout of its own: it is a '
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
        DocsTocEntry(title: 'Empty', anchor: 'api-elempty'),
        DocsTocEntry(title: 'EmptyHeader', anchor: 'api-elemptyheader'),
        DocsTocEntry(title: 'EmptyMedia', anchor: 'api-elemptymedia'),
        DocsTocEntry(title: 'EmptyTitle', anchor: 'api-elemptytitle'),
        DocsTocEntry(
          title: 'EmptyDescription',
          anchor: 'api-elemptydescription',
        ),
        DocsTocEntry(title: 'EmptyContent', anchor: 'api-elemptycontent'),
      ],
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'Empty and every part are static, presentational '
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
        'Empty adds no keyboard behaviour of its own: nothing in '
        'empty.dart owns a Focus node or a key handler, so tab order on an '
        'empty state comes entirely from whatever interactive child '
        'EmptyContent happens to hold (the Button in Preview above, '
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
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Components'),
      BreadcrumbEntry.page('Empty'),
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
    constraints: const BoxConstraints(maxWidth: LayoutWidths.prose),
    child: StyledText(
      text,
      TextStyles.small,
      color: ThemeScope.of(context).mutedForeground,
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
          title: 'Empty',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'children',
              type: 'List<Widget>',
              description:
                  'Required. Typically a EmptyHeader and a '
                  'EmptyContent, in order, joined by a 16px gap '
                  '(Empty.gap).',
            ),
          ],
        ),
      ),
      SizedBox(height: space(4)),
      const DocsApiTable(
        title: 'Empty static tokens',
        facts: <DocsApiFact>[
          DocsApiFact(
            name: 'Empty.padding',
            type: 'static double',
            description: '24px outer padding.',
          ),
          DocsApiFact(
            name: 'Empty.gap',
            type: 'static double',
            description: '16px between children.',
          ),
          DocsApiFact(
            name: 'Empty.radius',
            type: 'static double',
            description:
                '16px corner radius. Shapes nothing today: Empty paints '
                'no border or background to clip (see Theming).',
          ),
        ],
      ),
      SizedBox(height: space(6)),
      const DocsAnchor(
        id: 'api-elemptyheader',
        child: DocsApiTable(
          title: 'EmptyHeader',
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
      SizedBox(height: space(4)),
      const DocsApiTable(
        title: 'EmptyHeader static tokens',
        facts: <DocsApiFact>[
          DocsApiFact(
            name: 'EmptyHeader.gap',
            type: 'static double',
            description: '8px between children.',
          ),
          DocsApiFact(
            name: 'EmptyHeader.maxWidth',
            type: 'static double',
            description: '384px (Containers.sm).',
          ),
        ],
      ),
      SizedBox(height: space(6)),
      const DocsAnchor(
        id: 'api-elemptymedia',
        child: DocsApiTable(
          title: 'EmptyMedia',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'glyph',
              type: 'IconGlyph',
              description:
                  'Required. The icon drawn inside the 32px tile. Not an '
                  'arbitrary widget slot: EmptyMedia cannot host a '
                  'Avatar (compare ItemMedia on the item page, which '
                  'takes any Widget).',
            ),
            DocsApiFact(
              name: 'tone',
              type: 'IconTone',
              description: 'Optional. Defaults to IconTone.normal.',
            ),
          ],
        ),
      ),
      SizedBox(height: space(4)),
      const DocsApiTable(
        title: 'EmptyMedia static tokens',
        facts: <DocsApiFact>[
          DocsApiFact(
            name: 'EmptyMedia.box',
            type: 'static double',
            description: '32px tile.',
          ),
          DocsApiFact(
            name: 'EmptyMedia.radius',
            type: 'static double',
            description: '12px corners.',
          ),
          DocsApiFact(
            name: 'EmptyMedia.marginBottom',
            type: 'static double',
            description: '8px gap to the title.',
          ),
          DocsApiFact(
            name: 'EmptyMedia.glyphSize',
            type: 'static double',
            description:
                '16px: the glyph box actually drawn, forced regardless of '
                'the IconSize rung passed elsewhere (a deliberate '
                'drift, see Theming).',
          ),
          DocsApiFact(
            name: 'EmptyMedia.glyphStroke',
            type: 'static double',
            description:
                'The stroke width computed for a 24px glyph (2), not the '
                '16px rung\'s own 2.4: the same deliberate drift.',
          ),
        ],
      ),
      SizedBox(height: space(6)),
      const DocsAnchor(
        id: 'api-elemptytitle',
        child: DocsApiTable(
          title: 'EmptyTitle',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'text',
              type: 'String (positional)',
              description: 'Required. The heading, 13px/500, −0.26px tracking.',
            ),
          ],
        ),
      ),
      SizedBox(height: space(4)),
      const DocsApiTable(
        title: 'EmptyTitle static members',
        facts: <DocsApiFact>[
          DocsApiFact(
            name: 'EmptyTitle.styleOf(context, {color})',
            type: 'static TextStyle Function',
            description:
                'Resolves the title\'s text style so a caller building '
                'its own title-shaped text can match it exactly.',
          ),
        ],
      ),
      SizedBox(height: space(6)),
      const DocsAnchor(
        id: 'api-elemptydescription',
        child: DocsApiTable(
          title: 'EmptyDescription',
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
      SizedBox(height: space(4)),
      const DocsApiTable(
        title: 'EmptyDescription static members',
        facts: <DocsApiFact>[
          DocsApiFact(
            name: 'EmptyDescription.spec',
            type: 'static TextStyleToken',
            description:
                'TextStyles.textareaBody: the resolved rung the '
                'description renders with.',
          ),
        ],
      ),
      SizedBox(height: space(6)),
      const DocsAnchor(
        id: 'api-elemptycontent',
        child: DocsApiTable(
          title: 'EmptyContent',
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
      SizedBox(height: space(4)),
      const DocsApiTable(
        title: 'EmptyContent static tokens',
        facts: <DocsApiFact>[
          DocsApiFact(
            name: 'EmptyContent.gap',
            type: 'static double',
            description: '10px between children.',
          ),
          DocsApiFact(
            name: 'EmptyContent.maxWidth',
            type: 'static double',
            description: '384px (Containers.sm).',
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
      _bullets(ThemeScope.of(context), <String>[
        'Semantic role: none of its own. Empty, EmptyHeader, '
            'EmptyMedia, and EmptyContent are plain Column/Padding/'
            'ConstrainedBox widgets with no Semantics wrapper.',
        'Not silent: EmptyTitle and EmptyDescription render through '
            'Text (via LineBox/StyledText), which carries Flutter\'s default '
            'static-text semantics: the title and the description are '
            'individually reachable and readable by a screen reader.',
        'The gap: nothing announces the *arrival* of an empty state. '
            'There is no Semantics(liveRegion: true) anywhere in '
            'empty.dart and no heading semantics on EmptyTitle. Wiring a '
            'live announcement at the call site (e.g. Semantics(liveRegion: '
            'true) around the swap, or SemanticsService.announce) is on '
            'the caller today.',
        'EmptyMedia\'s icon carries no separate accessible label '
            'parameter of its own: appropriate, since the adjacent '
            'EmptyTitle already states the same information in text.',
        'Known platform differences: none observed: no platform branch in '
            'empty.dart.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'No responsive branching: BuildContext width is never read for a '
            'layout decision; the same widget tree renders at 390px and '
            '1440px.',
        'EmptyHeader and EmptyContent both cap at 384px '
            '(Containers.sm) regardless of viewport. At 390px that cap '
            'rarely binds: the phone\'s own content width is already '
            'close to or narrower than it. At 1440px it keeps the title '
            'and description from stretching edge to edge inside a much '
            'wider Empty panel.',
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
            value:
                'foundation/spacing.dart, foundation/theme.dart, '
                'foundation/typography.dart (ComponentTextStyles, '
                'TextStyleToken), text_layout.dart (LineBox), '
                'theme_scope.dart (StyledText, ThemeScope), icon.dart (Icon, '
                'IconTone), icon_paths.dart (IconGlyph)',
            description:
                'The one real component dependency: EmptyMedia renders '
                'a Icon.',
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
      SizedBox(height: space(4)),
      DocsLinkRow(
        links: <DocsLink>[
          const DocsLink(label: 'Icon', route: '/components/icon'),
          const DocsLink(
            label: 'Input Group',
            route: '/components/input_group',
          ),
        ],
      ),
      SizedBox(height: space(2)),
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: LayoutWidths.prose),
        child: StyledText(
          'Icon is a real dependency: EmptyMedia renders one. Input '
          'Group is not: it is shown composed inside EmptyContent in '
          'the Input group section above, a relationship at the call '
          'site rather than something empty.dart imports.',
          TextStyles.small,
          color: ThemeScope.of(context).mutedForeground,
        ),
      ),
    ],
  );
}

class _ThemingContent extends StatelessWidget {
  const _ThemingContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Media background is theme.muted, title is theme.foreground, '
            'description is theme.mutedForeground; the glyph\'s tone is '
            'theme-resolved through IconTone. All re-resolve on a live '
            'theme flip.',
        'The corner radius (Radii.xl, 16px) shapes nothing today: there '
            'is no border to shape and no background fill on Empty '
            'itself to clip. It is kept because it is what a future '
            'border width would follow.',
        'EmptyMedia\'s icon is a deliberate drift, not an oversight: it '
            'draws at a forced 16px with the stroke width computed for '
            '24px (2, not the 2.4 a genuine 16px glyph gets elsewhere in '
            'this package), matching the reference\'s own '
            '`[&_svg:not([class*=\'size-\'])]:size-4` override.',
        'No colour-override parameter of its own: every colour is theme- '
            'or tone-derived, never a bare Color argument.',
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

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Rest',
    treatment:
        'Paints a centred column: a muted 32px tile behind the glyph if '
        'EmptyMedia is present, the title in theme.foreground, the '
        'description in theme.mutedForeground.',
    userSignal: 'The resting paint is the only paint.',
  ),
  DocsStateFact(
    state: '"Empty" (as a matrix row)',
    treatment:
        'This row usually asks what a stateful component looks like with '
        'no data. Empty does not have that state: Empty *is* the '
        'widget another component renders when its own data is empty.',
    userSignal:
        'Named explicitly so this row is not mistaken for an unfilled '
        'gap.',
  ),
  DocsStateFact(
    state: 'Loading / Error / Success',
    treatment:
        'N/A: Empty owns no async flag. A caller renders a different '
        'Empty (a different glyph/title/description) for an error '
        'versus an empty-by-design state.',
    userSignal: 'A different specimen, not a live state change.',
  ),
  DocsStateFact(
    state: 'Hover / Focus-visible / Pressed / Selected / Disabled',
    treatment:
        'N/A: Empty owns none of these. EmptyContent can *hold* an '
        'interactive child (the Button in Preview above), whose own '
        'states apply to it, not to Empty.',
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
    child: Empty(
      children: <Widget>[
        EmptyHeader(
          children: <Widget>[
            EmptyMedia(glyph: IconGlyph.search, tone: IconTone.subtle),
            EmptyTitle('No results found'),
            EmptyDescription(
              'Try a different search term or clear your filters.',
            ),
          ],
        ),
        EmptyContent(children: <Widget>[_ClearFiltersButton()]),
      ],
    ),
  );
}

class _ClearFiltersButton extends StatelessWidget {
  const _ClearFiltersButton();

  @override
  Widget build(BuildContext context) => Button(
    variant: ButtonVariant.secondary,
    size: ButtonSize.sm,
    onPressed: () {},
    child: StyledText('Clear filters', TextStyles.buttonLabel),
  );
}

class _InputGroupSpecimen extends StatelessWidget {
  const _InputGroupSpecimen();

  @override
  Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<String>('empty-example:input-group'),
    child: Empty(
      children: <Widget>[
        const EmptyHeader(
          children: <Widget>[
            EmptyMedia(glyph: IconGlyph.search, tone: IconTone.subtle),
            EmptyTitle('No results found'),
            EmptyDescription('Try a broader search term.'),
          ],
        ),
        EmptyContent(
          children: <Widget>[
            InputGroup(
              startAddon: InputGroupAddon(
                child: Icon(
                  IconGlyph.search,
                  size: IconSize.sm,
                  tone: IconTone.inherit,
                ),
              ),
              child: const InputGroupInput(placeholder: 'Search again...'),
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
      child: Empty(
        children: <Widget>[
          EmptyHeader(
            children: <Widget>[
              EmptyMedia(glyph: IconGlyph.search),
              EmptyTitle('لا توجد نتائج'),
              EmptyDescription('جرب كلمة بحث مختلفة.'),
            ],
          ),
          EmptyContent(children: <Widget>[_ClearFiltersArButton()]),
        ],
      ),
    ),
  );
}

class _ClearFiltersArButton extends StatelessWidget {
  const _ClearFiltersArButton();

  @override
  Widget build(BuildContext context) => Button(
    variant: ButtonVariant.secondary,
    size: ButtonSize.sm,
    onPressed: () {},
    child: StyledText('مسح الفلاتر', TextStyles.buttonLabel),
  );
}

/* ── Code strings ───────────────────────────────────────────────────────── */

const String _previewCode = '''
Empty(
  children: [
    EmptyHeader(
      children: [
        EmptyMedia(glyph: IconGlyph.search, tone: IconTone.subtle),
        EmptyTitle('No results found'),
        EmptyDescription('Try a different search term or clear your filters.'),
      ],
    ),
    EmptyContent(
      children: [
        Button(
          variant: ButtonVariant.secondary,
          size: ButtonSize.sm,
          onPressed: () {},
          child: StyledText('Clear filters', TextStyles.buttonLabel),
        ),
      ],
    ),
  ],
)''';

const String _usageCode = '''
import 'package:elattar_design_system/elattar_design_system.dart';

Empty(
  children: [
    EmptyHeader(
      children: [
        EmptyMedia(glyph: IconGlyph.search, tone: IconTone.subtle),
        EmptyTitle('No results found'),
        EmptyDescription('Try a different search term.'),
      ],
    ),
    EmptyContent(
      children: [
        Button(
          variant: ButtonVariant.secondary,
          size: ButtonSize.sm,
          onPressed: () {},
          child: StyledText('Clear filters', TextStyles.buttonLabel),
        ),
      ],
    ),
  ],
)''';

const String _compositionTree = '''Empty
├─ EmptyHeader
│  ├─ EmptyMedia        (optional)
│  ├─ EmptyTitle
│  └─ EmptyDescription
└─ EmptyContent''';

const String _compositionSiteCode =
    '''// example/lib/site/site_shell.dart — the site search's empty state
Empty(
  children: <Widget>[
    const EmptyHeader(
      children: <Widget>[
        EmptyMedia(glyph: IconGlyph.search),
        EmptyTitle('Nothing matched that search'),
        EmptyDescription(
          'Try a broader term, or jump straight into the documentation index.',
        ),
      ],
    ),
    EmptyContent(
      children: <Widget>[
        Button(
          variant: ButtonVariant.secondary,
          onPressed: () => onNavigate(docsRoute),
          child: const Text('Open documentation'),
        ),
      ],
    ),
  ],
)''';

const String _inputGroupCode = '''Empty(
  children: [
    const EmptyHeader(
      children: [
        EmptyMedia(glyph: IconGlyph.search, tone: IconTone.subtle),
        EmptyTitle('No results found'),
        EmptyDescription('Try a broader search term.'),
      ],
    ),
    EmptyContent(
      children: [
        InputGroup(
          startAddon: InputGroupAddon(
            child: Icon(IconGlyph.search, size: IconSize.sm),
          ),
          child: InputGroupInput(placeholder: 'Search again...'),
        ),
      ],
    ),
  ],
)''';

const String _rtlCode = '''Directionality(
  textDirection: TextDirection.rtl,
  child: Empty(
    children: [
      EmptyHeader(
        children: [
          EmptyMedia(glyph: IconGlyph.search),
          EmptyTitle('لا توجد نتائج'),
          EmptyDescription('جرب كلمة بحث مختلفة.'),
        ],
      ),
      EmptyContent(
        children: [
          Button(
            variant: ButtonVariant.secondary,
            size: ButtonSize.sm,
            onPressed: () {},
            child: StyledText('مسح الفلاتر', TextStyles.buttonLabel),
          ),
        ],
      ),
    ],
  ),
)''';
