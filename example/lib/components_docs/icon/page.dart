/// Public documentation page for the `icon` component, alone.
///
/// **Split from a three-component page.** `icon`, `spinner` and `rule`
/// used to share one route (`components_docs/icon/page.dart`), the smallest
/// three registry primitives read together. They now get one page each:
/// `../spinner/page.dart` and `../rule/page.dart` are their own files,
/// reshaped to the same frame this page uses.
///
/// `icon` has no shadcn counterpart at all: shadcn does not ship an `Icon`
/// component, `lucide-react` icons are imported and used directly. So this
/// page's own sections (Sizes, Tones, Lucide catalog) are named for what
/// `ElIcon` does, in shadcn's own house style, rather than mirrored from a
/// page that does not exist.
///
/// **Shape.** Matches `../button/page.dart`: an unheaded live demo, then
/// Installation, then Usage, then this component's own sections, then API
/// Reference last of the shadcn-shaped sections (one prop table per class,
/// nested under it), then exactly States, Accessibility, Responsive,
/// Dependencies, Theming, Source.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/docs_code.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../kit.dart';
import 'meta.dart';

class IconDocPage extends StatelessWidget {
  const IconDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: iconDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / PRIMITIVES',
      title: iconDoc.title,
      description: iconDoc.description,
    ),
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Components'),
      ElBreadcrumbEntry.page('Icon'),
    ],
    toc: const <DocsTocEntry>[
      DocsTocEntry(title: 'Installation', anchor: 'install'),
      DocsTocEntry(title: 'Usage', anchor: 'usage'),
      DocsTocEntry(title: 'Sizes', anchor: 'sizes'),
      DocsTocEntry(title: 'Tones', anchor: 'tones'),
      DocsTocEntry(title: 'Lucide catalog', anchor: 'lucide'),
      DocsTocEntry(
        title: 'API Reference',
        anchor: 'api',
        children: <DocsTocEntry>[
          DocsTocEntry(title: 'ElIcon', anchor: 'api-elicon'),
          DocsTocEntry(
            title: 'ElIcon.lucide constructor',
            anchor: 'api-elicon-lucide',
          ),
          DocsTocEntry(
            title: 'ElIcon static methods and constants',
            anchor: 'api-elicon-static',
          ),
        ],
      ),
      DocsTocEntry(title: 'States', anchor: 'states'),
      DocsTocEntry(title: 'Accessibility', anchor: 'accessibility'),
      DocsTocEntry(title: 'Responsive', anchor: 'responsive'),
      DocsTocEntry(title: 'Dependencies', anchor: 'dependencies'),
      DocsTocEntry(title: 'Theming', anchor: 'theming'),
      DocsTocEntry(title: 'Source', anchor: 'source'),
    ],
    onNavigate: onNavigate,
    child: const _IconArticle(),
  );
}

class _IconArticle extends StatelessWidget {
  const _IconArticle();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      key: const ValueKey<String>('icon-doc-article'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _heroDemo(),
        SizedBox(height: el(6)),
        _install(),
        SizedBox(height: el(6)),
        _usage(),
        SizedBox(height: el(6)),
        _sizes(),
        _tones(),
        _lucide(),
        _api(),
        _states(),
        _accessibility(theme),
        _responsive(theme),
        _dependencies(theme),
        _theming(theme),
        _source(),
      ],
    );
  }

  // ── LIVE DEMO (unheaded) ────────────────────────────────────────────────

  Widget _heroDemo() => DocsCodeExample(
    title: 'Icon',
    description:
        'Three curated glyphs at their default size and tone, side by side.',
    preview: Wrap(
      spacing: el(6),
      runSpacing: el(4),
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        for (final (ElIconGlyph glyph, String name)
            in const <(ElIconGlyph, String)>[
              (ElIconGlyph.check, 'check'),
              (ElIconGlyph.star, 'star'),
              (ElIconGlyph.alertTriangle, 'alertTriangle'),
            ])
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ElIcon(glyph, size: ElIconSize.lg),
              SizedBox(height: el(2)),
              ElText(name, ElType.small),
            ],
          ),
      ],
    ),
    manualFiles: const <DocsCodeFile>[
      DocsCodeFile(
        path: 'lib/components/ui/icon.dart',
        code:
            "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
            'const ElIcon checkmark = ElIcon(ElIconGlyph.check, size: ElIconSize.lg);',
      ),
    ],
  );

  // ── SHARED SECTIONS ────────────────────────────────────────────────────

  Widget _install() => ElSection(
    id: 'install',
    title: 'Installation',
    description:
        'icon has a real registry manifest, `elattar add icon` installs '
        'lib/src/components/icon.dart and its two companion path files and '
        'resolves source-foundation automatically.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DocsCodeExample(
          title: 'Install icon',
          command: DocsCodeCommand(
            command: iconDoc.command,
            description:
                'Installs icon.dart, icon_paths.dart and icon_paths.g.dart, '
                'and resolves source-foundation automatically.',
          ),
          manualFiles: const <DocsCodeFile>[
            DocsCodeFile(
              path: 'lib/components/ui/icon.dart',
              title: '1. Copy the source',
              description:
                  "Copy icon.dart, icon_paths.dart and icon_paths.g.dart's "
                  'generated payload into components/ui.',
              code:
                  "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
                  '// Copy the generated icon source here when using manual mode.',
            ),
            DocsCodeFile(
              path: 'lib/components/ui/ui.dart',
              title: '2. Export it from your barrel',
              description:
                  'Add the export line so ElIcon and its enums are reachable '
                  'the same way the CLI path already makes them.',
              code: "export 'icon.dart';",
            ),
          ],
        ),
        SizedBox(height: el(5)),
        DocsInstallFacts(
          title: 'Manual install facts',
          facts: <DocsInstallFact>[
            DocsInstallFact(
              label: 'Registry dependencies',
              value: iconDoc.dependencies.join(', '),
              description:
                  "registry/components/icon.json's own registryDependencies, "
                  'verbatim.',
            ),
            const DocsInstallFact(
              label: 'Manual copy target',
              value: 'lib/components/ui/icon.dart',
              description: 'Where the CLI itself would place the file.',
            ),
            const DocsInstallFact(
              label: 'Generated companion',
              value: 'lib/components/ui/icon_paths.g.dart',
              description:
                  '1,756 glyphs, 15.9 KB, generated from lucide-react 1.28.0 '
                  '(ISC) by tool/generate_icons.mjs. Copy verbatim; do not '
                  'hand-edit.',
            ),
          ],
        ),
      ],
    ),
  );

  Widget _usage() => ElSection(
    id: 'usage',
    title: 'Usage',
    description:
        'The smallest correct import and construction. Every example below '
        'only changes named arguments on top of this.',
    child: ElPanel(
      label: 'DART',
      note: 'MINIMAL',
      child: DocsSelectableCodeBlock(code: _usageCode),
    ),
  );

  Widget _sizes() => ElSection(
    id: 'sizes',
    title: 'Sizes',
    description:
        'ElIconSize is a fixed seven-rung ladder, xs through xl3: 12, 14, '
        '16 (the default), 20, 24, 32, and 40px. ElIcon.pxFor(size) is the '
        "ladder's own lookup, and each rung's label below is ElIconSize."
        "label, not .name: the top two rungs are spelled xl2/xl3 in Dart "
        "because an identifier cannot start with a digit, and that rename "
        "must not leak into rendered copy.",
    child: DocsCodeExample(
      title: 'Every ElIconSize rung',
      preview: Wrap(
        spacing: el(5),
        runSpacing: el(4),
        crossAxisAlignment: WrapCrossAlignment.end,
        children: <Widget>[
          for (final ElIconSize size in ElIconSize.values)
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ElIcon(ElIconGlyph.star, size: size),
                SizedBox(height: el(2)),
                ElText(
                  '${size.label} (${ElIcon.pxFor(size).toInt()}px)',
                  ElType.small,
                ),
              ],
            ),
        ],
      ),
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(
          path: 'icon_sizes.dart',
          code:
              'for (final ElIconSize size in ElIconSize.values)\n'
              '  ElIcon(ElIconGlyph.star, size: size)',
        ),
      ],
    ),
  );

  Widget _tones() => ElSection(
    id: 'tones',
    title: 'Tones',
    description:
        'ElIconTone resolves to one of ten theme tokens through '
        'ElIcon.colorFor, never a raw colour. inherit, the default, reads '
        'DefaultTextStyle and falls back to theme.foreground, so it is left '
        'out of this swatch: it paints whatever surrounds it, not a fixed '
        'colour of its own.',
    child: DocsCodeExample(
      title: 'Every fixed ElIconTone',
      preview: Wrap(
        spacing: el(5),
        runSpacing: el(4),
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          for (final ElIconTone tone in ElIconTone.values)
            if (tone != ElIconTone.inherit)
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ElIcon(
                    ElIconGlyph.alertTriangle,
                    size: ElIconSize.lg,
                    tone: tone,
                  ),
                  SizedBox(height: el(2)),
                  ElText(tone.label, ElType.small),
                ],
              ),
        ],
      ),
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(
          path: 'icon_tones.dart',
          code:
              'ElIcon(ElIconGlyph.alertTriangle, size: ElIconSize.lg, tone: ElIconTone.warning)',
        ),
      ],
    ),
  );

  Widget _lucide() => ElSection(
    id: 'lucide',
    title: 'Lucide catalog',
    description:
        'ElIconGlyph is a curated whitelist, the icons this page names. '
        'ElIcon.lucide reaches past it into icon_paths.g.dart, the full '
        '1,756-glyph generated registry, through exactly the same '
        'paintGlyph the curated constructor uses: same 24-unit space, same '
        'stroke formula, same clip. strokeOverride exists for the one real '
        'caller that needs it: the theme toggle renders its three lucide '
        'icons directly at 14px with lucide\'s own default stroke, 2, not '
        'the 2.4 ElIcon.strokeFor(14) would compute for that size.',
    child: DocsCodeExample(
      title: 'ElIcon.lucide, with and without strokeOverride',
      preview: Wrap(
        spacing: el(6),
        runSpacing: el(4),
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const ElIcon.lucide(ElLucide.bot, size: ElIconSize.lg),
              SizedBox(height: el(2)),
              ElText('ElLucide.bot (default stroke)', ElType.small),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const ElIcon.lucide(ElLucide.bot, sizePx: 14, strokeOverride: 2),
              SizedBox(height: el(2)),
              ElText('sizePx: 14, strokeOverride: 2', ElType.small),
            ],
          ),
        ],
      ),
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(
          path: 'icon_lucide.dart',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Any glyph in the generated registry, not only the curated set.\n'
              'const ElIcon.lucide(ElLucide.bot, size: ElIconSize.lg)\n\n'
              "// The theme toggle's own case: lucide's authored stroke (2),\n"
              '// not the 2.4 ElIcon.strokeFor(14) would compute.\n'
              'const ElIcon.lucide(ElLucide.bot, sizePx: 14, strokeOverride: 2)',
        ),
      ],
    ),
  );

  Widget _api() => ElSection(
    id: 'api',
    title: 'API Reference',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        KeyedSubtree(
          key: docsAnchorKey('api-elicon'),
          child: const DocsApiTable(
            title: 'ElIcon properties',
            facts: <DocsApiFact>[
              DocsApiFact(
                name: 'glyph',
                type: 'ElIconGlyph',
                description:
                    'Required (primary constructor). The curated glyph from '
                    'the whitelist: menu, search, star, check, x, and 59 '
                    'others.',
              ),
              DocsApiFact(
                name: 'size',
                type: 'ElIconSize',
                description:
                    'Defaults to md (16px). One of: xs (12px), sm (14px), md '
                    '(16px), lg (20px), xl (24px), xl2 (32px), xl3 (40px). '
                    'Ignored when sizePx is given.',
              ),
              DocsApiFact(
                name: 'tone',
                type: 'ElIconTone',
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
                    'Given, wraps the icon in Semantics(label:, image: true); '
                    'omitted, wraps it in ExcludeSemantics.',
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
                    'The stroke width in lucide\'s 24-unit space. Null means '
                    'the formula computes it from the rendered px; 2 is '
                    'lucide\'s authored value; 2.4 and 1.6 are the snap '
                    'bounds strokeFor resolves to above/below it.',
              ),
            ],
          ),
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-elicon-lucide'),
          child: const DocsApiTable(
            title: 'ElIcon.lucide constructor',
            facts: <DocsApiFact>[
              DocsApiFact(
                name: 'lucide',
                type: 'ElLucideGlyph',
                description:
                    'Required. A glyph from the generated registry '
                    '(icon_paths.g.dart), for when the curated whitelist '
                    'does not carry the shape you need. Takes the same '
                    'size, tone, label, sizePx, and strokeOverride '
                    'parameters as the primary constructor.',
              ),
            ],
          ),
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-elicon-static'),
          child: const DocsApiTable(
            title: 'ElIcon static methods and constants',
            facts: <DocsApiFact>[
              DocsApiFact(
                name: 'ElIcon.pxFor(ElIconSize)',
                type: 'static double',
                description:
                    'Returns the pixel size for a rung: xs to 12, sm to 14, '
                    'md to 16, lg to 20, xl to 24, xl2 to 32, xl3 to 40.',
              ),
              DocsApiFact(
                name: 'ElIcon.strokeFor(double)',
                type: 'static double',
                description:
                    'Computes the stroke width for a rendered px size. '
                    'scaled = 48 / px; above 2.6 snaps to 2.4, below 1.5 '
                    'snaps to 1.6, otherwise the literal authored value 2.',
              ),
              DocsApiFact(
                name: 'ElIcon.colorFor(context, tone)',
                type: 'static Color',
                description:
                    'Resolves the tone to the theme colour. ElIconTone.'
                    'inherit reads DefaultTextStyle.of(context).style.'
                    'color, falling back to theme.foreground.',
              ),
              DocsApiFact(
                name:
                    'ElIcon.paintGlyph(canvas, size, {path, color, '
                    'strokeWidth, fill})',
                type: '@visibleForTesting static void',
                description:
                    'The shared paint routine both constructors resolve to: '
                    'scales the canvas to the 24-unit grid, clips to the '
                    'viewBox rect, strokes path, then fills fill (only the '
                    'glyphs that carry fill="currentColor" in the source, '
                    'e.g. tag\'s 0.5-unit dot).',
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
    child: const DocsStateMatrix(
      facts: <DocsStateFact>[
        DocsStateFact(
          state: 'Static',
          treatment:
              'Painted once at the requested size and tone token, inside a '
              'CustomPaint. No AnimationController, no listener, no rebuild '
              'triggered by ElIcon itself.',
          userSignal:
              'A fixed glyph. Interaction states belong to whatever control '
              'contains it (ElButton, ElMenuItem), not to ElIcon itself.',
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
      ],
    ),
  );

  Widget _accessibility(ElThemeData theme) => ElSection(
    id: 'accessibility',
    title: 'Accessibility',
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: ElWidths.prose),
      child: ElText(
        'Accessibility is mandatory, not a default. Every ElIcon either '
        'carries a label (rendered as an accessible name, announced by '
        'screen readers) or carries none and is hidden from assistive tech '
        'via ExcludeSemantics: there is no middle ground, a caller must '
        'choose. A decorative icon beside explanatory text passes label: '
        'null, hiding it entirely; an icon-only button label passes the '
        'label string.',
        ElType.body,
      ),
    ),
  );

  Widget _responsive(ElThemeData theme) => ElSection(
    id: 'responsive',
    title: 'Responsive',
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: ElWidths.prose),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ElText(
            'A stable primitive, registered in the CLI, with no '
            'platform-conditional code anywhere in icon.dart: Android, iOS, '
            'Web, macOS, Windows, and Linux all render the same widget '
            'tree.',
            ElType.body,
          ),
          SizedBox(height: el(4)),
          ElText(
            'ElIcon never reads MediaQuery for layout: it is a fixed-size '
            'widget (width == height == the resolved px) that a responsive '
            'parent, a Wrap, a breakpoint-driven Row, positions.',
            ElType.body,
          ),
        ],
      ),
    ),
  );

  Widget _dependencies(ElThemeData theme) => ElSection(
    id: 'dependencies',
    title: 'Dependencies',
    child: _bullets(theme, <String>[
      'File: lib/src/components/icon.dart (ElIcon widget, ElIconSize/'
          'ElIconTone enums, the glyph painter).',
      'Companion: icon_paths.dart (the sealed ElIconElement/ElIconPaths '
          'model every glyph is expressed in).',
      'Companion: icon_paths.g.dart (1,756 glyphs, 15.9 KB, generated from '
          'lucide-react 1.28.0 ISC by tool/generate_icons.mjs; regenerate, '
          'never hand-edit).',
      'registryDependencies, resolved automatically by `elattar add icon`: '
          'source-foundation (theme, typography for DefaultTextStyle).',
      'Used by many other components: button, spinner, badge, input group, '
          'menu items, and more all compose ElIcon rather than painting '
          'their own glyphs.',
    ]),
  );

  Widget _theming(ElThemeData theme) => ElSection(
    id: 'theming',
    title: 'Theming',
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: ElWidths.prose),
      child: ElText(
        'Colour always comes from ElIcon.colorFor(context, tone), never a '
        'raw Color: nine of the ten tones read a fixed ElThemeData getter '
        '(theme.foreground, theme.mutedForeground, theme.actionInk, '
        'theme.valueInk, theme.successInk, theme.warningInk, theme.infoInk, '
        'theme.destructiveInk), and the tenth, inherit, reads '
        'DefaultTextStyle instead so an icon inside a coloured button or '
        'link picks up that colour without a tone override. Flipping '
        'ElThemeController re-resolves every one on the next frame; '
        'nothing here is cached.',
        ElType.body,
      ),
    ),
  );

  Widget _source() => ElSection(
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
              'ElIcon is covered inside the shared base-components suite.',
        ),
        const DocsInstallFact(
          label: 'Docs test',
          value: 'example/test/components_docs/icon_test.dart',
          description:
              'Covers this page: every ElIconSize rung, every fixed '
              'ElIconTone, the lucide-registry constructor, and the API '
              'table.',
        ),
        const DocsInstallFact(
          label: 'Edit these docs',
          value: 'example/lib/components_docs/icon/page.dart',
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

const ElIcon checkmark = ElIcon(ElIconGlyph.check);''';
