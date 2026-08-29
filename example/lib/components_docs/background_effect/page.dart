/// Public documentation page for the `background-effect` effect.
///
/// **Why `EffectSection`, not `ShowcaseSection`.** [BackgroundEffect] paints a
/// background and nothing else — there is no variant to switch between. A
/// `ShowcaseSection` stages a specimen; `EffectSection` names the host the
/// glow is painted behind, which is the only way to show what a wide,
/// off-centre radial gradient over a flat fill actually looks like.
///
/// **Section list.** Preview contrasts a panel painted by BackgroundEffect
/// against the identical panel painted with a flat theme.background fill,
/// at `EffectSection.minHeight: space(160)` — the brief for this page names
/// background-effect specifically as an atmosphere effect that a 384-tall default
/// box shows almost nothing of. Page Backdrop reproduces the real
/// composition `example/lib/shell.dart` and `example/lib/site/
/// site_shell.dart` both use: `Positioned.fill(child: BackgroundEffect())` as a
/// background layer with page content painted as a *sibling*, not as
/// BackgroundEffect's own `child` parameter.
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
import 'meta.dart';

final ComponentDocSpec pageGlowDocSpec = ComponentDocSpec(
  name: 'background_effect',
  title: 'Background Effect',
  description:
      'The page atmosphere: a wide, off-centre radial gradient painted '
      'behind the background fill, fixed to the viewport rather than the '
      'scroll — the difference between a flat fill reading as paint and '
      'the same fill reading as a deep room.',
  sections: <DocsPageSection>[
    EffectSection(
      id: 'preview',
      title: 'Preview',
      description:
          'The left panel is BackgroundEffect() alone — no child, so it expands '
          'to fill its box. The right panel is the identical box painted '
          'with a flat theme.background fill and nothing else.',
      host: _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
      minHeight: space(160),
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'background-effect has a real registry manifest: `elattar add '
          'background-effect` installs lib/src/components/ui/background_effect.dart and '
          'resolves its one registryDependency automatically. The Manual '
          'tab is for a project not using the CLI.',
      command: backgroundEffectDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/effects/background_effect.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/ui/background_effect.dart's generated "
              '@ui/background_effect.dart payload into effects.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated background-effect source here when using '
              'manual mode.',
        ),
        DocsCodeFile(
          path: 'lib/effects/effects.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so BackgroundEffect is reachable the same '
              'way the CLI path already makes it.',
          code: "export 'background_effect.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'BackgroundEffect belongs behind the scroll view, sized to the '
          'viewport — background-attachment: fixed resolves the gradient '
          'against the viewport and pins it there, which is what scrolling '
          'it with the content would undo.',
      code: _usageCode,
    ),
    EffectSection(
      id: 'backdrop',
      title: 'Page Backdrop',
      description:
          'The real composition this system\'s own example app uses: a '
          'Stack with BackgroundEffect as a Positioned.fill background layer '
          'and the page content as a sibling, not as BackgroundEffect\'s own '
          'child parameter.',
      host: const _BackdropSpecimen(),
      code: _backdropCode,
      label: 'Page Backdrop specimen view',
      minHeight: space(160),
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description: 'The one constructor parameter BackgroundEffect declares.',
      child: DocsApiTable(title: 'BackgroundEffect', facts: _pageGlowApiFacts),
    ),
    DisclosureSection(id: 'states', title: 'States', child: _StatesContent()),
    DisclosureSection(
      id: 'accessibility',
      title: 'Accessibility',
      child: _AccessibilityContent(),
    ),
    DisclosureSection(
      id: 'keyboard',
      title: 'Keyboard',
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
            value: backgroundEffectDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'test/machine_surface_test.dart',
            description:
                'Group "BackgroundEffect": both themes paint without error, the '
                'ellipse\'s own 120%x90% geometry at 62%/34%, and the '
                'child rendering above the glow.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/page_glow_test.dart',
            description:
                'Covers this page: the article mounts, the API table, '
                'both example composition, and both themes.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/background_effect/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class BackgroundEffectDocPage extends StatelessWidget {
  const BackgroundEffectDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: backgroundEffectDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / EFFECTS',
      title: backgroundEffectDoc.title,
      description: backgroundEffectDoc.description,
    ),
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Components'),
      BreadcrumbEntry.page('Background Effect'),
    ],
    toc: pageGlowDocSpec.toc,
    previous: null,
    next: null,
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('background-effect-doc-article'),
      child: ComponentDocPage(spec: pageGlowDocSpec, header: false),
    ),
  );
}

/* ── Effect specimens ───────────────────────────────────────────────────── */

Widget _caption(BuildContext context, String label) => StyledText(
  label,
  TextStyles.caption,
  color: ThemeScope.of(context).mutedForeground,
);

class _PreviewSpecimen extends StatelessWidget {
  const _PreviewSpecimen();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Wrap(
      spacing: space(6),
      runSpacing: space(4),
      crossAxisAlignment: WrapCrossAlignment.start,
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _caption(context, 'With BackgroundEffect'),
            SizedBox(height: space(3)),
            KeyedSubtree(
              key: const ValueKey<String>('background-effect-preview:with'),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: theme.border,
                    width: BorderWidths.hairline,
                  ),
                ),
                child: SizedBox(
                  width: space(68),
                  height: space(48),
                  child: const BackgroundEffect(),
                ),
              ),
            ),
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _caption(context, 'Without'),
            SizedBox(height: space(3)),
            KeyedSubtree(
              key: const ValueKey<String>('background-effect-preview:without'),
              child: Container(
                width: space(68),
                height: space(48),
                decoration: BoxDecoration(
                  color: theme.background,
                  border: Border.all(
                    color: theme.border,
                    width: BorderWidths.hairline,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

const String _previewCode =
    '// With BackgroundEffect — the effect this page documents\n'
    'SizedBox(width: 272, height: 192, child: BackgroundEffect())\n\n'
    '// Without — the identical box, a flat theme.background fill\n'
    'Container(\n'
    '  width: 272,\n'
    '  height: 192,\n'
    '  color: theme.background,\n'
    ')';

class _BackdropSpecimen extends StatelessWidget {
  const _BackdropSpecimen();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Container(
      width: space(90),
      height: space(56),
      decoration: BoxDecoration(
        border: Border.all(color: theme.border, width: BorderWidths.hairline),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          const Positioned.fill(child: BackgroundEffect()),
          Padding(
            padding: EdgeInsets.all(space(5)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                StyledText(
                  'Documentation',
                  TextStyles.h4,
                  color: theme.foreground,
                ),
                SizedBox(height: space(2)),
                StyledText(
                  'Content is a sibling of BackgroundEffect in the Stack, not '
                  'its child — the same shape shell.dart uses for the '
                  'whole app.',
                  TextStyles.small,
                  color: theme.mutedForeground,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

const String _backdropCode =
    'Stack(\n'
    '  fit: StackFit.expand,\n'
    '  children: [\n'
    '    const Positioned.fill(child: BackgroundEffect()),\n'
    '    Padding(\n'
    '      padding: EdgeInsets.all(space(5)),\n'
    '      child: pageContent, // a sibling, not BackgroundEffect\'s child\n'
    '    ),\n'
    '  ],\n'
    ')';

const String _usageCode = '''
import 'package:elattar_design_system/elattar_design_system.dart';

Stack(
  fit: StackFit.expand,
  children: [
    const Positioned.fill(child: BackgroundEffect()),
    scrollView,
  ],
)''';

/* ── Disclosure content ─────────────────────────────────────────────────── */

class _StatesContent extends StatelessWidget {
  const _StatesContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'BackgroundEffect is a StatelessWidget over a CustomPaint: no hover, '
            'press, focus or internal state of any kind — no States matrix '
            'in the sense a control has one.',
        'Its own class doc states the fact directly: "it does not '
            'animate" — RULES section 4 allows exactly two perpetual '
            'motions in this system and this is neither.',
        'The only thing that changes what it paints is the ambient theme '
            '(background and pageGlow), which shouldRepaint compares on '
            'every rebuild — see Theming below.',
      ]);
}

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'BackgroundEffect adds no Semantics node of its own around the '
            'gradient: it is a plain CustomPaint, purely decorative.',
        'When a child is passed, that child\'s own semantics tree is '
            'unaffected — CustomPaint does not suppress or alter the '
            'semantics of whatever it wraps, confirmed by the package '
            'test "renders its child above the glow".',
      ]);
}

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'BackgroundEffect takes no focus and handles no key: there is no '
            'Focus, no FocusNode and no onKeyEvent anywhere in '
            'background_effect.dart.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(
    BuildContext context,
  ) => _bullets(ThemeScope.of(context), <String>[
    'No MediaQuery or breakpoint branching anywhere in background_effect.dart.',
    'The gradient\'s own geometry (120% x 90% of the box, centred at '
        '62%/34%, fading out at 64%) is expressed as fractions of '
        'whatever box BackgroundEffect is given, so it scales '
        'proportionally with its host rather than snapping between '
        'fixed layouts at a breakpoint.',
  ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      _bullets(ThemeScope.of(context), <String>[
        'File: lib/src/components/ui/background_effect.dart — one file, one class, no '
            'companions.',
        'Flutter imports: dart:ui, foundation.dart (@visibleForTesting), '
            'widgets.dart.',
        'Foundation imports: foundation/theme.dart, theme_scope.dart '
            '(ThemeScope) — background_effect.dart reads no other foundation file.',
        'registryDependencies, resolved automatically by `elattar add '
            'background-effect`: source-foundation — copied verbatim from '
            'registry/components/background-effect.json.',
        'Not a dependency of background_effect.dart itself, but its real '
            'consumers in the corpus: example/lib/shell.dart, example/'
            'lib/site/site_shell.dart, example/lib/scroll_bridge.dart and '
            'example/lib/showcase/showcase_app.dart all mount it as the '
            'app\'s own Positioned.fill backdrop — all site chrome under '
            'example/lib/, none of it a documented registry component to '
            'link here.',
      ]),
      SizedBox(height: space(2)),
      DocsLinkRow(
        links: <DocsLink>[
          DocsLink(
            label: 'Source Foundation',
            route: '/components/source_foundation',
          ),
        ],
      ),
    ],
  );
}

class _ThemingContent extends StatelessWidget {
  const _ThemingContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Two theme colours, both read live off ThemeScope.of(context) on '
            'every build: theme.background (the flat fill under the '
            'gradient) and theme.pageGlow (the gradient\'s own colour, '
            'fading to itself at alpha 0 rather than to a literal '
            'transparent black — see the source\'s own note on '
            'premultiplied interpolation).',
        "The painter's shouldRepaint compares exactly those two "
            'colours: a rebuild that changes neither costs nothing extra.',
        'Both dark and light declare their own background and pageGlow '
            'on ThemeTokens — there is no third variant.',
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

const List<DocsApiFact> _pageGlowApiFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'child',
    type: 'Widget?',
    description:
        'Optional. Painted over the glow. Omit it when the glow is a '
        'Stack layer of its own (the real usage — see Page Backdrop '
        'above), in which case BackgroundEffect expands to fill its own '
        'constraints via SizedBox.expand.',
  ),
];
