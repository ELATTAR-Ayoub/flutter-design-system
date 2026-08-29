/// Public documentation page for the `icon` component, alone.
///
/// **Re-housed onto the kit.** This page used to hand-compose [Section]
/// panels; it now declares a [ComponentDocSpec]
/// (`example/lib/docs/component_doc_page.dart`) and hands it to
/// [ComponentDocPage], the same shape `button`, `field`, `popover`,
/// `hover_card`, `kbd`, and `item` established. Every specimen widget is
/// the one the hand-composed page carried; the unheaded live demo above
/// Installation is now the page's own `Preview` `ShowcaseSection`, with a
/// real Dart `code:` string reproducing it (the old page's toggle there
/// showed an unrelated one-line `checkmark` constant, not the specimen's
/// own source). A dedicated Keyboard disclosure is added, since none
/// existed before.
///
/// **Corrected, not carried across.** The hand-composed page's
/// Installation section said `elattar add icon` "installs
/// lib/src/components/ui/icon.dart and its two companion path files."
/// `registry/components/icon.json`'s own `files` array lists **three**
/// companions, not two — `icon_paths.dart`, `icon_paths.g.dart`, and
/// `icon_paths.g.index.dart` — plus a `licenses` entry
/// (`third_party/lucide/LICENSE`) the old text never mentioned at all.
/// Installation below lists all four files and the license, verbatim from
/// the manifest.
///
/// **API table, kept to the catalog's shape.** `icon_paths.g.dart` is a
/// generated, 1,756-glyph registry — nowhere near a table a reader would
/// scroll. The `Icon` and `Icon.lucide` tables below document the
/// constructor parameters and the two glyph sources (the curated
/// `IconGlyph` whitelist and the generated `LucideGlyph` registry) by
/// shape and count, never by enumerating individual glyphs — the Lucide
/// catalog section's live specimens are what demonstrate the registry
/// itself.
///
/// `icon` has no shadcn counterpart at all: shadcn does not ship an `Icon`
/// component, `lucide-react` icons are imported and used directly. So this
/// page's own sections (Sizes, Tones, Lucide catalog) are named for what
/// `Icon` does, in shadcn's own house style, rather than mirrored from a
/// page that does not exist.
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

/// The declaration: every section this page shows, in TOC order. `final`,
/// not `const`: `InstallSection.command` reads `iconDoc.command`, a
/// computed getter, which is not a constant expression.
final ComponentDocSpec iconDocSpec = ComponentDocSpec(
  name: 'icon',
  title: iconDoc.title,
  description: iconDoc.description,
  sections: <DocsPageSection>[
    const ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'Three curated glyphs at their default size and tone, side by '
          'side.',
      specimen: _PreviewSpecimen(),
      code: _previewCode,
      label: 'Icon specimen view',
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'icon has a real registry manifest, `elattar add icon` installs '
          'lib/src/components/ui/icon.dart, its three companion path files '
          '(icon_paths.dart, icon_paths.g.dart, icon_paths.g.index.dart), '
          "and lucide's ISC license file, and resolves source-foundation "
          'automatically.',
      command: iconDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/icon.dart',
          title: '1. Copy the source',
          description:
              "Copy icon.dart, icon_paths.dart, icon_paths.g.dart, and "
              "icon_paths.g.index.dart's generated payload into "
              'components/ui, plus third_party/lucide/LICENSE.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated icon source here when using manual '
              'mode.',
        ),
        const DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so Icon and its enums are reachable '
              'the same way the CLI path already makes them.',
          code: "export 'icon.dart';",
        ),
      ],
    ),
    const SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'The smallest correct import and construction. Every example '
          'below only changes named arguments on top of this.',
      code: _usageCode,
    ),
    ShowcaseSection(
      id: 'sizes',
      title: 'Sizes',
      description:
          'IconSize is a fixed seven-rung ladder, xs through xl3: 12, '
          '14, 16 (the default), 20, 24, 32, and 40px. Icon.pxFor(size) '
          "is the ladder's own lookup, and each rung's label below is "
          "IconSize.label, not .name: the top two rungs are spelled "
          "xl2/xl3 in Dart because an identifier cannot start with a "
          'digit, and that rename must not leak into rendered copy.',
      specimen: const _SizesSpecimen(),
      code: _sizesCode,
      label: 'Sizes specimen view',
    ),
    ShowcaseSection(
      id: 'tones',
      title: 'Tones',
      description:
          'IconTone resolves to one of ten theme tokens through '
          'Icon.colorFor, never a raw colour. inherit, the default, '
          'reads DefaultTextStyle and falls back to theme.foreground, so '
          'it is left out of this swatch: it paints whatever surrounds '
          'it, not a fixed colour of its own.',
      specimen: const _TonesSpecimen(),
      code: _tonesCode,
      label: 'Tones specimen view',
    ),
    ShowcaseSection(
      id: 'lucide',
      title: 'Lucide catalog',
      description:
          'IconGlyph is a curated whitelist, the icons this page names. '
          'Icon.lucide reaches past it into icon_paths.g.dart, the full '
          '1,756-glyph generated registry, through exactly the same '
          'paintGlyph the curated constructor uses: same 24-unit space, '
          'same stroke formula, same clip. strokeOverride exists for the '
          'one real caller that needs it: the theme toggle renders its '
          'three lucide icons directly at 14px with lucide\'s own default '
          'stroke, 2, not the 2.4 Icon.strokeFor(14) would compute for '
          'that size.',
      specimen: const _LucideSpecimen(),
      code: _lucideCode,
      label: 'Lucide catalog specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'One table per class or constructor, kept to the catalog\'s '
          'shape rather than one row per glyph: IconGlyph (the curated '
          'whitelist, ~63 entries) and LucideGlyph (the generated '
          'registry, 1,756 entries) are both documented by what they are '
          'and how many, not enumerated — the Lucide catalog specimen '
          'above is the live demonstration of the registry itself.',
      children: const <DocsTocEntry>[
        DocsTocEntry(title: 'Icon', anchor: 'api-elicon'),
        DocsTocEntry(
          title: 'Icon.lucide constructor',
          anchor: 'api-elicon-lucide',
        ),
        DocsTocEntry(
          title: 'Icon static methods and constants',
          anchor: 'api-elicon-static',
        ),
      ],
      child: const _ApiReferenceContent(),
    ),
    const DisclosureSection(
      id: 'states',
      title: 'States',
      child: DocsStateMatrix(facts: _stateFacts),
    ),
    const DisclosureSection(
      id: 'accessibility',
      title: 'Accessibility',
      child: _AccessibilityContent(),
    ),
    const DisclosureSection(
      id: 'keyboard',
      title: 'Keyboard',
      child: _KeyboardContent(),
    ),
    const DisclosureSection(
      id: 'responsive',
      title: 'Responsive',
      child: _ResponsiveContent(),
    ),
    const DisclosureSection(
      id: 'dependencies',
      title: 'Dependencies',
      child: _DependenciesContent(),
    ),
    const DisclosureSection(
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
            value: iconDoc.sourcePath,
            description: 'The icon component.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'test/components_test.dart',
            description:
                'Icon is covered inside the shared base-components '
                'suite.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/icon_test.dart',
            description:
                'Covers this page: every IconSize rung, every fixed '
                'IconTone, the lucide-registry constructor, and the API '
                'table.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/icon/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class IconDocPage extends StatelessWidget {
  const IconDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: iconDoc.route,
    intro: DocsPageIntro(
      title: iconDoc.title,
      description: iconDoc.description,
    ),
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Components'),
      BreadcrumbEntry.page('Icon'),
    ],
    toc: iconDocSpec.toc,
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('icon-doc-article'),
      child: ComponentDocPage(spec: iconDocSpec, header: false),
    ),
  );
}

/* ── Showcase specimens ─────────────────────────────────────────────────── */

class _PreviewSpecimen extends StatelessWidget {
  const _PreviewSpecimen();

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: space(6),
    runSpacing: space(4),
    crossAxisAlignment: WrapCrossAlignment.center,
    children: <Widget>[
      for (final (IconGlyph glyph, String name) in const <(IconGlyph, String)>[
        (IconGlyph.check, 'check'),
        (IconGlyph.star, 'star'),
        (IconGlyph.alertTriangle, 'alertTriangle'),
      ])
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(glyph, size: IconSize.lg),
            SizedBox(height: space(2)),
            StyledText(name, TextStyles.small),
          ],
        ),
    ],
  );
}

class _SizesSpecimen extends StatelessWidget {
  const _SizesSpecimen();

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: space(5),
    runSpacing: space(4),
    crossAxisAlignment: WrapCrossAlignment.end,
    children: <Widget>[
      for (final IconSize size in IconSize.values)
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(IconGlyph.star, size: size),
            SizedBox(height: space(2)),
            StyledText(
              '${size.label} (${Icon.pxFor(size).toInt()}px)',
              TextStyles.small,
            ),
          ],
        ),
    ],
  );
}

class _TonesSpecimen extends StatelessWidget {
  const _TonesSpecimen();

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: space(5),
    runSpacing: space(4),
    crossAxisAlignment: WrapCrossAlignment.center,
    children: <Widget>[
      for (final IconTone tone in IconTone.values)
        if (tone != IconTone.inherit)
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(IconGlyph.alertTriangle, size: IconSize.lg, tone: tone),
              SizedBox(height: space(2)),
              StyledText(tone.label, TextStyles.small),
            ],
          ),
    ],
  );
}

class _LucideSpecimen extends StatelessWidget {
  const _LucideSpecimen();

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: space(6),
    runSpacing: space(4),
    crossAxisAlignment: WrapCrossAlignment.center,
    children: <Widget>[
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Icon.lucide(Lucide.bot, size: IconSize.lg),
          SizedBox(height: space(2)),
          StyledText('Lucide.bot (default stroke)', TextStyles.small),
        ],
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Icon.lucide(Lucide.bot, sizePx: 14, strokeOverride: 2),
          SizedBox(height: space(2)),
          StyledText('sizePx: 14, strokeOverride: 2', TextStyles.small),
        ],
      ),
    ],
  );
}

const String _previewCode = '''Wrap(
  spacing: space(6),
  runSpacing: space(4),
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    for (final (IconGlyph glyph, String name) in const [
      (IconGlyph.check, 'check'),
      (IconGlyph.star, 'star'),
      (IconGlyph.alertTriangle, 'alertTriangle'),
    ])
      Column(
        children: [
          Icon(glyph, size: IconSize.lg),
          StyledText(name, TextStyles.small),
        ],
      ),
  ],
)''';

const String _usageCode = '''
import 'package:elattar_design_system/elattar_design_system.dart';

const Icon checkmark = Icon(IconGlyph.check);''';

const String _sizesCode =
    'for (final IconSize size in IconSize.values)\n'
    '  Icon(IconGlyph.star, size: size)';

const String _tonesCode =
    'Icon(IconGlyph.alertTriangle, size: IconSize.lg, tone: IconTone.warning)';

const String _lucideCode =
    "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
    '// Any glyph in the generated registry, not only the curated set.\n'
    'const Icon.lucide(Lucide.bot, size: IconSize.lg)\n\n'
    "// The theme toggle's own case: lucide's authored stroke (2),\n"
    '// not the 2.4 Icon.strokeFor(14) would compute.\n'
    'const Icon.lucide(Lucide.bot, sizePx: 14, strokeOverride: 2)';

/* ── Disclosure content ─────────────────────────────────────────────────── */

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsAnchor(
        id: 'api-elicon',
        child: DocsApiTable(
          title: 'Icon properties',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'glyph',
              type: 'IconGlyph',
              description:
                  'Required (primary constructor). The curated glyph from '
                  'the whitelist: menu, search, star, check, x, and 59 '
                  'others.',
            ),
            DocsApiFact(
              name: 'size',
              type: 'IconSize',
              description:
                  'Defaults to md (16px). One of: xs (12px), sm (14px), '
                  'md (16px), lg (20px), xl (24px), xl2 (32px), xl3 '
                  '(40px). Ignored when sizePx is given.',
            ),
            DocsApiFact(
              name: 'tone',
              type: 'IconTone',
              description:
                  'Defaults to inherit (the text colour). One of: normal '
                  '(foreground), muted, subtle, action, value, success, '
                  'warning, info, error, inherit.',
            ),
            DocsApiFact(
              name: 'label',
              type: 'String?',
              description:
                  'The accessible name, required for icon-only controls, '
                  'omitted for decorative icons beside explanatory text. '
                  'Given, wraps the icon in Semantics(label:, image: '
                  'true); omitted, wraps it in ExcludeSemantics.',
            ),
            DocsApiFact(
              name: 'sizePx',
              type: 'double?',
              description:
                  'An off-ladder px size, overriding size. Use sparingly; '
                  'the ladder exists for a reason.',
            ),
            DocsApiFact(
              name: 'strokeOverride',
              type: 'double?',
              description:
                  'The stroke width in lucide\'s 24-unit space. Null '
                  "means the formula computes it from the rendered px; 2 "
                  "is lucide's authored value; 2.4 and 1.6 are the snap "
                  'bounds strokeFor resolves to above/below it.',
            ),
          ],
        ),
      ),
      SizedBox(height: space(6)),
      const DocsAnchor(
        id: 'api-elicon-lucide',
        child: DocsApiTable(
          title: 'Icon.lucide constructor',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'lucide',
              type: 'LucideGlyph',
              description:
                  'Required. A glyph from the generated registry '
                  '(icon_paths.g.dart, 1,756 entries), for when the '
                  'curated whitelist does not carry the shape you need. '
                  'Takes the same size, tone, label, sizePx, and '
                  'strokeOverride parameters as the primary constructor.',
            ),
          ],
        ),
      ),
      SizedBox(height: space(6)),
      const DocsAnchor(
        id: 'api-elicon-static',
        child: DocsApiTable(
          title: 'Icon static methods and constants',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'Icon.pxFor(IconSize)',
              type: 'static double',
              description:
                  'Returns the pixel size for a rung: xs to 12, sm to 14, '
                  'md to 16, lg to 20, xl to 24, xl2 to 32, xl3 to 40.',
            ),
            DocsApiFact(
              name: 'Icon.strokeFor(double)',
              type: 'static double',
              description:
                  'Computes the stroke width for a rendered px size. '
                  'scaled = 48 / px; above 2.6 snaps to 2.4, below 1.5 '
                  'snaps to 1.6, otherwise the literal authored value 2.',
            ),
            DocsApiFact(
              name: 'Icon.colorFor(context, tone)',
              type: 'static Color',
              description:
                  'Resolves the tone to the theme colour. '
                  'IconTone.inherit reads '
                  'DefaultTextStyle.of(context).style.color, falling '
                  'back to theme.foreground.',
            ),
            DocsApiFact(
              name:
                  'Icon.paintGlyph(canvas, size, {path, color, '
                  'strokeWidth, fill})',
              type: '@visibleForTesting static void',
              description:
                  'The shared paint routine both constructors resolve '
                  'to: scales the canvas to the 24-unit grid, clips to '
                  'the viewBox rect, strokes path, then fills fill (only '
                  'the glyphs that carry fill="currentColor" in the '
                  "source, e.g. tag's 0.5-unit dot).",
            ),
          ],
        ),
      ),
    ],
  );
}

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: LayoutWidths.prose),
    child: StyledText(
      'Accessibility is mandatory, not a default. Every Icon either '
      'carries a label (rendered as an accessible name, announced by '
      'screen readers) or carries none and is hidden from assistive tech '
      'via ExcludeSemantics: there is no middle ground, a caller must '
      'choose. A decorative icon beside explanatory text passes label: '
      'null, hiding it entirely; an icon-only button label passes the '
      'label string.',
      TextStyles.body,
    ),
  );
}

/// New: no Keyboard disclosure existed on the hand-composed page.
/// `icon.dart`'s own `Icon` is a `StatelessWidget` painting through a
/// bare `CustomPaint`: no `Focus`, `FocusNode`, or key handler appears
/// anywhere in the file.
class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: LayoutWidths.prose),
    child: StyledText(
      'No keyboard behaviour of its own: Icon wires no Focus, '
      'FocusNode, or onKeyEvent, so it never appears in Tab order and '
      'carries no key handler. An icon becomes reachable by keyboard '
      'only when a parent control — Button, a menu item — wraps it in '
      'its own focusable node; icon.dart contributes nothing beyond the '
      'painted glyph and its optional accessible label.',
      TextStyles.body,
    ),
  );
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: LayoutWidths.prose),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        StyledText(
          'A stable primitive, registered in the CLI, with no '
          'platform-conditional code anywhere in icon.dart: Android, '
          'iOS, Web, macOS, Windows, and Linux all render the same '
          'widget tree.',
          TextStyles.body,
        ),
        SizedBox(height: space(4)),
        StyledText(
          'Icon never reads MediaQuery for layout: it is a fixed-size '
          'widget (width == height == the resolved px) that a '
          'responsive parent, a Wrap, a breakpoint-driven Row, '
          'positions.',
          TextStyles.body,
        ),
      ],
    ),
  );
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      _bullets(ThemeScope.of(context), <String>[
        'File: lib/src/components/ui/icon.dart (Icon widget, IconSize/'
            'IconTone enums, the glyph painter).',
        'Companion: icon_paths.dart (the sealed IconElement/'
            'IconPaths model every glyph is expressed in).',
        'Companion: icon_paths.g.dart (1,756 glyphs, 15.9 KB, generated '
            'from lucide-react 1.28.0 ISC by tool/generate_icons.mjs; '
            'regenerate, never hand-edit).',
        'Companion: icon_paths.g.index.dart, the fourth file the '
            'manifest lists under "files" — a lookup index over the '
            'generated registry.',
        'License: third_party/lucide/LICENSE, installed to '
            '@license/Lucide-ISC.txt: lucide-react ships under ISC, and '
            'the manifest carries it as a licenses entry, not a files '
            'entry.',
        'registryDependencies, resolved automatically by `elattar add '
            'icon`: source-foundation (theme, typography for '
            'DefaultTextStyle).',
        'Used by many other components: button, spinner, badge, input '
            'group, menu items, and more all compose Icon rather than '
            'painting their own glyphs.',
      ]),
      SizedBox(height: space(2)),
      const DocsLinkRow(
        links: <DocsLink>[
          DocsLink(label: 'Badge', route: '/components/badge'),
          DocsLink(label: 'Button', route: '/components/button'),
          DocsLink(label: 'Input group', route: '/components/input_group'),
          DocsLink(label: 'Spinner', route: '/components/spinner'),
        ],
      ),
    ],
  );
}

class _ThemingContent extends StatelessWidget {
  const _ThemingContent();

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: LayoutWidths.prose),
    child: StyledText(
      'Colour always comes from Icon.colorFor(context, tone), never a '
      'raw Color: nine of the ten tones read a fixed ThemeTokens getter '
      '(theme.foreground, theme.mutedForeground, theme.actionText, '
      'theme.premiumText, theme.successText, theme.warningText, '
      'theme.infoText, theme.destructiveText), and the tenth, inherit, '
      'reads DefaultTextStyle instead so an icon inside a coloured '
      'button or link picks up that colour without a tone override. '
      'Flipping ThemeController re-resolves every one on the next '
      'frame; nothing here is cached.',
      TextStyles.body,
    ),
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

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Static',
    treatment:
        'Painted once at the requested size and tone token, inside a '
        'CustomPaint. No AnimationController, no listener, no rebuild '
        'triggered by Icon itself.',
    userSignal:
        'A fixed glyph. Interaction states belong to whatever control '
        'contains it (Button, MenuItem), not to Icon itself.',
  ),
  DocsStateFact(
    state: 'Labeled',
    treatment: 'Semantics(label: label, image: true).',
    userSignal:
        'Announced by assistive tech as an image with that name: use '
        'for an icon-only control where nothing else names it.',
  ),
  DocsStateFact(
    state: 'Unlabeled (decorative)',
    treatment: 'ExcludeSemantics wraps the painted box.',
    userSignal:
        'Invisible to assistive tech: for an icon that sits beside '
        'text already saying the same thing.',
  ),
];
