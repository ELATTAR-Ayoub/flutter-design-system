/// Public documentation page for the `page-glow` effect.
///
/// **Why `EffectSection`, not `ShowcaseSection`.** [ElPageGlow] paints a
/// background and nothing else — there is no variant to switch between. A
/// `ShowcaseSection` stages a specimen; `EffectSection` names the host the
/// glow is painted behind, which is the only way to show what a wide,
/// off-centre radial gradient over a flat fill actually looks like.
///
/// **Section list.** Preview contrasts a panel painted by ElPageGlow
/// against the identical panel painted with a flat theme.background fill,
/// at `EffectSection.minHeight: el(160)` — the brief for this page names
/// page-glow specifically as an atmosphere effect that a 384-tall default
/// box shows almost nothing of. Page Backdrop reproduces the real
/// composition `example/lib/shell.dart` and `example/lib/site/
/// site_shell.dart` both use: `Positioned.fill(child: ElPageGlow())` as a
/// background layer with page content painted as a *sibling*, not as
/// ElPageGlow's own `child` parameter.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/component_doc_page.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import 'meta.dart';

final ComponentDocSpec pageGlowDocSpec = ComponentDocSpec(
  name: 'page_glow',
  title: 'Page Glow',
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
          'The left panel is ElPageGlow() alone — no child, so it expands '
          'to fill its box. The right panel is the identical box painted '
          'with a flat theme.background fill and nothing else.',
      host: _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
      minHeight: el(160),
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'page-glow has a real registry manifest: `elattar add '
          'page-glow` installs lib/src/effects/page_glow.dart and '
          'resolves its one registryDependency automatically. The Manual '
          'tab is for a project not using the CLI.',
      command: pageGlowDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/effects/page_glow.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/effects/page_glow.dart's generated "
              '@effects/page_glow.dart payload into effects.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated page-glow source here when using '
              'manual mode.',
        ),
        DocsCodeFile(
          path: 'lib/effects/effects.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so ElPageGlow is reachable the same '
              'way the CLI path already makes it.',
          code: "export 'page_glow.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'ElPageGlow belongs behind the scroll view, sized to the '
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
          'Stack with ElPageGlow as a Positioned.fill background layer '
          'and the page content as a sibling, not as ElPageGlow\'s own '
          'child parameter.',
      host: const _BackdropSpecimen(),
      code: _backdropCode,
      label: 'Page Backdrop specimen view',
      minHeight: el(160),
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description: 'The one constructor parameter ElPageGlow declares.',
      child: DocsApiTable(title: 'ElPageGlow', facts: _pageGlowApiFacts),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      child: _StatesContent(),
    ),
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
            value: pageGlowDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'test/machine_surface_test.dart',
            description:
                'Group "ElPageGlow": both themes paint without error, the '
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
            value: 'example/lib/components_docs/page_glow/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class PageGlowDocPage extends StatelessWidget {
  const PageGlowDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: pageGlowDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / EFFECTS',
      title: pageGlowDoc.title,
      description: pageGlowDoc.description,
    ),
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Components'),
      ElBreadcrumbEntry.page('Page Glow'),
    ],
    toc: pageGlowDocSpec.toc,
    previous: null,
    next: null,
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('page-glow-doc-article'),
      child: ComponentDocPage(spec: pageGlowDocSpec, header: false),
    ),
  );
}

/* ── Effect specimens ───────────────────────────────────────────────────── */

Widget _caption(BuildContext context, String label) =>
    ElText(label, ElType.caption, color: ElTheme.of(context).mutedForeground);

class _PreviewSpecimen extends StatelessWidget {
  const _PreviewSpecimen();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Wrap(
      spacing: el(6),
      runSpacing: el(4),
      crossAxisAlignment: WrapCrossAlignment.start,
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _caption(context, 'With ElPageGlow'),
            SizedBox(height: el(3)),
            KeyedSubtree(
              key: const ValueKey<String>('page-glow-preview:with'),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: theme.border,
                    width: ElWidths.hairline,
                  ),
                ),
                child: SizedBox(
                  width: el(68),
                  height: el(48),
                  child: const ElPageGlow(),
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
            SizedBox(height: el(3)),
            KeyedSubtree(
              key: const ValueKey<String>('page-glow-preview:without'),
              child: Container(
                width: el(68),
                height: el(48),
                decoration: BoxDecoration(
                  color: theme.background,
                  border: Border.all(
                    color: theme.border,
                    width: ElWidths.hairline,
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
    '// With ElPageGlow — the effect this page documents\n'
    'SizedBox(width: 272, height: 192, child: ElPageGlow())\n\n'
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
    final ElThemeData theme = ElTheme.of(context);
    return Container(
      width: el(90),
      height: el(56),
      decoration: BoxDecoration(
        border: Border.all(color: theme.border, width: ElWidths.hairline),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          const Positioned.fill(child: ElPageGlow()),
          Padding(
            padding: EdgeInsets.all(el(5)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ElText('Documentation', ElType.h4, color: theme.foreground),
                SizedBox(height: el(2)),
                ElText(
                  'Content is a sibling of ElPageGlow in the Stack, not '
                  'its child — the same shape shell.dart uses for the '
                  'whole app.',
                  ElType.small,
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
    '    const Positioned.fill(child: ElPageGlow()),\n'
    '    Padding(\n'
    '      padding: EdgeInsets.all(el(5)),\n'
    '      child: pageContent, // a sibling, not ElPageGlow\'s child\n'
    '    ),\n'
    '  ],\n'
    ')';

const String _usageCode = '''
import 'package:elattar_design_system/elattar_design_system.dart';

Stack(
  fit: StackFit.expand,
  children: [
    const Positioned.fill(child: ElPageGlow()),
    scrollView,
  ],
)''';

/* ── Disclosure content ─────────────────────────────────────────────────── */

class _StatesContent extends StatelessWidget {
  const _StatesContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'ElPageGlow is a StatelessWidget over a CustomPaint: no hover, '
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
      _bullets(ElTheme.of(context), <String>[
        'ElPageGlow adds no Semantics node of its own around the '
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
      _bullets(ElTheme.of(context), <String>[
        'ElPageGlow takes no focus and handles no key: there is no '
            'Focus, no FocusNode and no onKeyEvent anywhere in '
            'page_glow.dart.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'No MediaQuery or breakpoint branching anywhere in page_glow.dart.',
        'The gradient\'s own geometry (120% x 90% of the box, centred at '
            '62%/34%, fading out at 64%) is expressed as fractions of '
            'whatever box ElPageGlow is given, so it scales '
            'proportionally with its host rather than snapping between '
            'fixed layouts at a breakpoint.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'File: lib/src/effects/page_glow.dart — one file, one class, no '
            'companions.',
        'Flutter imports: dart:ui, foundation.dart (@visibleForTesting), '
            'widgets.dart.',
        'Foundation imports: foundation/theme.dart, theme_scope.dart '
            '(ElTheme) — page_glow.dart reads no other foundation file.',
        'registryDependencies, resolved automatically by `elattar add '
            'page-glow`: source-foundation — copied verbatim from '
            'registry/effects/page-glow.json.',
        'Not a dependency of page_glow.dart itself, but its real '
            'consumers in the corpus: example/lib/shell.dart, example/'
            'lib/site/site_shell.dart, example/lib/scroll_bridge.dart and '
            'example/lib/showcase/showcase_app.dart all mount it as the '
            'app\'s own Positioned.fill backdrop — all site chrome under '
            'example/lib/, none of it a documented registry component to '
            'link here.',
      ]);
}

class _ThemingContent extends StatelessWidget {
  const _ThemingContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'Two theme colours, both read live off ElTheme.of(context) on '
            'every build: theme.background (the flat fill under the '
            'gradient) and theme.pageGlow (the gradient\'s own colour, '
            'fading to itself at alpha 0 rather than to a literal '
            'transparent black — see the source\'s own note on '
            'premultiplied interpolation).',
        '_PageGlowPainter.shouldRepaint compares exactly those two '
            'colours: a rebuild that changes neither costs nothing extra.',
        'Both dark and light declare their own background and pageGlow '
            'on ElThemeData — there is no third variant.',
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

const List<DocsApiFact> _pageGlowApiFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'child',
    type: 'Widget?',
    description:
        'Optional. Painted over the glow. Omit it when the glow is a '
        'Stack layer of its own (the real usage — see Page Backdrop '
        'above), in which case ElPageGlow expands to fill its own '
        'constraints via SizedBox.expand.',
  ),
];
