/// Public documentation page for the `bloom-cosmic` effect.
///
/// **Why `EffectSection`, not `ShowcaseSection`.** [ElBloomCosmic] paints a
/// corner light behind whatever `child` it wraps — there is no specimen of
/// its own to stage. A `ShowcaseSection` stages a specimen; `EffectSection`
/// names the host (a card-shaped surface, the same shape Alert uses) the
/// bloom is painted behind.
///
/// **Section list.** Preview contrasts a themed panel with
/// ElBloomCosmic.action mounted behind it against the identical panel with
/// no bloom at all. Variants stages all five of the named-constructor
/// presets this system's own Alert actually uses. Starfield shows the
/// `starfield` boolean this effect owns: true (the default, and what hangs
/// the thirteen sparkles over the light) against false.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/component_doc_page.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../docs/docs_section.dart' show DocsAnchor;
import 'meta.dart';

final ComponentDocSpec bloomCosmicDocSpec = ComponentDocSpec(
  name: 'bloom_cosmic',
  title: 'Bloom Cosmic',
  description:
      'The iridescence behind an Alert and a toast: two blurred, '
      'forever-drifting radial-gradient layers hung off a corner in the '
      'variant\'s own two hues, swelling on hover — with the starfield\'s '
      'sparkles riding along over the top.',
  sections: <DocsPageSection>[
    EffectSection(
      id: 'preview',
      title: 'Preview',
      description:
          'The left panel wraps ElBloomCosmic.action around the same '
          'card content the right panel renders alone. Both use theme.'
          'card as their fill and ElRadii.lg — the corner Alert itself '
          'uses.',
      host: const _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'bloom-cosmic has a real registry manifest: `elattar add '
          'bloom-cosmic` installs lib/src/effects/bloom_cosmic.dart and '
          'resolves its three registryDependencies automatically. The '
          'Manual tab is for a project not using the CLI.',
      command: bloomCosmicDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/effects/bloom_cosmic.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/effects/bloom_cosmic.dart's generated "
              '@effects/bloom_cosmic.dart payload into effects.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated bloom-cosmic source here when using '
              'manual mode.',
        ),
        DocsCodeFile(
          path: 'lib/effects/effects.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so ElBloomCosmic, ElBloomDrift, '
              'ElBloomDriftStop and ElBloomInk are reachable the same '
              'way the CLI path already makes them.',
          code: "export 'bloom_cosmic.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'Mount ElBloomCosmic INSIDE whatever draws the surface\'s '
          'border — its own overflow: hidden clips both layers to the '
          'padding box — and hand it the surface\'s own fill, which the '
          'blend composites against.',
      code: _usageCode,
    ),
    EffectSection(
      id: 'variants',
      title: 'Variants',
      description:
          'The five named-constructor presets Alert itself uses, each a '
          'fixed --bloom-1/--bloom-2 hue pair: .action (the utility\'s own '
          'default), .destructive, .success, .warning and .info. Two more '
          'named constructors exist for the toaster only — .toastWarning '
          'and .loading — see API Reference.',
      host: const _VariantsSpecimen(),
      code: _variantsCode,
      label: 'Variants specimen view',
    ),
    EffectSection(
      id: 'starfield',
      title: 'Starfield',
      description:
          'starfield: true (the default) hangs ElStarfield\'s thirteen '
          'sparkles over the bloom, exactly what Alert and every toast '
          'ship with. starfield: false is the corner light alone — an '
          'opt-out this effect owns, not a separate widget composition.',
      host: const _StarfieldToggleSpecimen(),
      code: _starfieldToggleCode,
      label: 'Starfield specimen view',
      minHeight: el(160),
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every parameter the general ElBloomCosmic constructor '
          'declares, and every named-constructor preset built on it.',
      children: const <DocsTocEntry>[
        DocsTocEntry(title: 'ElBloomCosmic', anchor: 'api-elbloomcosmic'),
        DocsTocEntry(
          title: 'Named constructors',
          anchor: 'api-named-constructors',
        ),
      ],
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      child: DocsStateMatrix(facts: _stateFacts),
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
            value: bloomCosmicDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'test/feedback_effects_test.dart',
            description:
                'Groups "ElBloomDrift — the keyframe tables", "the two '
                'min() caps" and "the bloom, rasterised" — the drift '
                'tables, the width caps on an Alert and a toast, and the '
                'stilled-under-reduced-motion behaviour.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/bloom_cosmic_test.dart',
            description:
                'Covers this page: the article mounts, both API tables, '
                'every named constructor rendering, and both themes.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/bloom_cosmic/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class BloomCosmicDocPage extends StatelessWidget {
  const BloomCosmicDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: bloomCosmicDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / EFFECTS',
      title: bloomCosmicDoc.title,
      description: bloomCosmicDoc.description,
    ),
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Components'),
      ElBreadcrumbEntry.page('Bloom Cosmic'),
    ],
    toc: bloomCosmicDocSpec.toc,
    previous: null,
    next: null,
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('bloom-cosmic-doc-article'),
      child: ComponentDocPage(spec: bloomCosmicDocSpec, header: false),
    ),
  );
}

/* ── Effect specimens ───────────────────────────────────────────────────── */

BorderRadius get _cardRadius => BorderRadius.circular(ElRadii.lg);

Widget _bordered(ElThemeData theme, BorderRadius radius, Widget child) =>
    DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: theme.border, width: ElWidths.hairline),
        borderRadius: radius,
      ),
      child: child,
    );

Widget _caption(BuildContext context, String label) =>
    ElText(label, ElType.caption, color: ElTheme.of(context).mutedForeground);

class _PreviewSpecimen extends StatelessWidget {
  const _PreviewSpecimen();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    Widget content() => Padding(
      padding: EdgeInsets.all(el(4)),
      child: SizedBox(
        width: el(56),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ElText('Heads up', ElType.h4, color: theme.foreground),
            SizedBox(height: el(1)),
            ElText(
              'This is what the corner light sits behind.',
              ElType.small,
              color: theme.mutedForeground,
            ),
          ],
        ),
      ),
    );
    return Wrap(
      spacing: el(6),
      runSpacing: el(4),
      crossAxisAlignment: WrapCrossAlignment.start,
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _caption(context, 'With ElBloomCosmic.action'),
            SizedBox(height: el(3)),
            KeyedSubtree(
              key: const ValueKey<String>('bloom-cosmic-preview:with'),
              child: _bordered(
                theme,
                _cardRadius,
                ElBloomCosmic.action(
                  radius: _cardRadius,
                  fill: theme.card,
                  child: content(),
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
              key: const ValueKey<String>('bloom-cosmic-preview:without'),
              child: _bordered(
                theme,
                _cardRadius,
                DecoratedBox(
                  decoration: BoxDecoration(color: theme.card),
                  child: content(),
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
    '// With ElBloomCosmic.action — the effect this page documents\n'
    'ElBloomCosmic.action(\n'
    '  radius: BorderRadius.circular(ElRadii.lg),\n'
    '  fill: theme.card,\n'
    '  child: cardContent,\n'
    ')\n\n'
    '// Without — the identical DecoratedBox, no bloom at all\n'
    'DecoratedBox(decoration: BoxDecoration(color: theme.card), child: cardContent)';

class _VariantChip extends StatelessWidget {
  const _VariantChip({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _caption(context, label),
        SizedBox(height: el(3)),
        _bordered(
          theme,
          _cardRadius,
          SizedBox(
            width: el(36),
            height: el(20),
            child: Center(child: child),
          ),
        ),
      ],
    );
  }
}

class _VariantsSpecimen extends StatelessWidget {
  const _VariantsSpecimen();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    Widget label(String text) => ElText(text, ElType.small, color: theme.foreground);
    return Wrap(
      spacing: el(6),
      runSpacing: el(4),
      crossAxisAlignment: WrapCrossAlignment.start,
      children: <Widget>[
        KeyedSubtree(
          key: const ValueKey<String>('bloom-cosmic-variant:action'),
          child: _VariantChip(
            label: 'action',
            child: ElBloomCosmic.action(
              radius: _cardRadius,
              fill: theme.card,
              child: label('Default'),
            ),
          ),
        ),
        KeyedSubtree(
          key: const ValueKey<String>('bloom-cosmic-variant:destructive'),
          child: _VariantChip(
            label: 'destructive',
            child: ElBloomCosmic.destructive(
              radius: _cardRadius,
              fill: theme.card,
              child: label('Destructive'),
            ),
          ),
        ),
        KeyedSubtree(
          key: const ValueKey<String>('bloom-cosmic-variant:success'),
          child: _VariantChip(
            label: 'success',
            child: ElBloomCosmic.success(
              radius: _cardRadius,
              fill: theme.card,
              child: label('Success'),
            ),
          ),
        ),
        KeyedSubtree(
          key: const ValueKey<String>('bloom-cosmic-variant:warning'),
          child: _VariantChip(
            label: 'warning',
            child: ElBloomCosmic.warning(
              radius: _cardRadius,
              fill: theme.card,
              child: label('Warning'),
            ),
          ),
        ),
        KeyedSubtree(
          key: const ValueKey<String>('bloom-cosmic-variant:info'),
          child: _VariantChip(
            label: 'info',
            child: ElBloomCosmic.info(
              radius: _cardRadius,
              fill: theme.card,
              child: label('Info'),
            ),
          ),
        ),
      ],
    );
  }
}

const String _variantsCode =
    'ElBloomCosmic.action(radius: radius, fill: theme.card, child: child)\n'
    'ElBloomCosmic.destructive(radius: radius, fill: theme.card, child: child)\n'
    'ElBloomCosmic.success(radius: radius, fill: theme.card, child: child)\n'
    'ElBloomCosmic.warning(radius: radius, fill: theme.card, child: child)\n'
    'ElBloomCosmic.info(radius: radius, fill: theme.card, child: child)';

class _StarfieldToggleSpecimen extends StatelessWidget {
  const _StarfieldToggleSpecimen();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    Widget box(bool starfield, String key) => KeyedSubtree(
      key: ValueKey<String>(key),
      child: _bordered(
        theme,
        _cardRadius,
        ElBloomCosmic.action(
          radius: _cardRadius,
          fill: theme.card,
          starfield: starfield,
          child: SizedBox(width: el(56), height: el(28)),
        ),
      ),
    );
    return Wrap(
      spacing: el(6),
      runSpacing: el(4),
      crossAxisAlignment: WrapCrossAlignment.start,
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _caption(context, 'starfield: true (default)'),
            SizedBox(height: el(3)),
            box(true, 'bloom-cosmic-starfield:on'),
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _caption(context, 'starfield: false'),
            SizedBox(height: el(3)),
            box(false, 'bloom-cosmic-starfield:off'),
          ],
        ),
      ],
    );
  }
}

const String _starfieldToggleCode =
    'ElBloomCosmic.action(\n'
    '  radius: radius,\n'
    '  fill: theme.card,\n'
    '  starfield: true, // vs. false\n'
    '  child: child,\n'
    ')';

const String _usageCode = '''
import 'package:elattar_design_system/elattar_design_system.dart';

DecoratedBox(
  decoration: BoxDecoration(
    border: Border.all(color: theme.border, width: ElWidths.hairline),
    borderRadius: BorderRadius.circular(ElRadii.lg),
  ),
  child: ElBloomCosmic.action(
    radius: BorderRadius.circular(ElRadii.lg),
    fill: theme.card,
    child: cardContent,
  ),
)''';

/* ── Disclosure content ─────────────────────────────────────────────────── */

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsAnchor(
        id: 'api-elbloomcosmic',
        child: DocsApiTable(
          title: 'ElBloomCosmic',
          facts: _bloomCosmicApiFacts,
        ),
      ),
      SizedBox(height: el(6)),
      const DocsAnchor(
        id: 'api-named-constructors',
        child: DocsApiTable(
          title: 'Named constructors',
          facts: _namedConstructorFacts,
        ),
      ),
    ],
  );
}

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'ElBloomCosmic adds no Semantics node of its own: it is a '
            'MouseRegion plus a ClipRRect plus a CustomPaint around '
            'whatever child it is given, and the child\'s own semantics '
            '(an Alert\'s title and description, say) pass through '
            'unmodified.',
        'The corner light, the drift and the starfield it optionally '
            'hangs over itself are all purely visual — none of it is '
            'announced to a screen reader.',
      ]);
}

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'ElBloomCosmic takes no focus and handles no key: there is no '
            'Focus, no FocusNode and no onKeyEvent anywhere in '
            'bloom_cosmic.dart.',
        'The MouseRegion it does own only watches pointer enter/exit — '
            'opaque: false, so it never claims the region from whatever '
            'is underneath — and never fires from keyboard traversal.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'No MediaQuery or breakpoint branching anywhere in '
            'bloom_cosmic.dart.',
        'Both layers DO respond to their host\'s own size, not the '
            'viewport: each is min(a fraction of the box, a fixed cap) '
            'wide — min(95%, 416) for the deep layer, min(86%, 336) for '
            'the near one — so the corner light is roughly the same '
            'PHYSICAL size on a 356px toast and a 1030px Alert. Both caps '
            'bite on the Alert; neither bites on the toast.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      _bullets(ElTheme.of(context), <String>[
        'File: lib/src/effects/bloom_cosmic.dart — one file, four public '
            'classes: ElBloomCosmic itself, plus ElBloomDrift, '
            'ElBloomDriftStop and ElBloomInk, the derivation records the '
            'drift and the ink are built from.',
        'Flutter imports: dart:math, dart:ui, foundation.dart, '
            'gestures.dart (PointerEnterEvent/PointerExitEvent), '
            'widgets.dart.',
        'Foundation imports: foundation/colors.dart (ElOklab), '
            'foundation/motion.dart (elAnimationDuration, ElDurations, '
            'ElCurves), foundation/spacing.dart, foundation/theme.dart, '
            'motion/keyframes.dart (ElKeyframes), theme_scope.dart, and '
            'starfield.dart for the ElStarfield it mounts internally.',
        'registryDependencies, resolved automatically by `elattar add '
            'bloom-cosmic`: keyframes, source-foundation, starfield — '
            'copied verbatim from registry/effects/bloom-cosmic.json.',
        'Not a dependency of bloom_cosmic.dart itself, but its real '
            'consumers in the corpus: Alert\'s five variants and every '
            'toaster type (two of which — .toastWarning and .loading — '
            'are named constructors that exist only for the toaster).',
      ]),
      SizedBox(height: el(3)),
      DocsLinkRow(
        links: <DocsLink>[
          const DocsLink(label: 'Alert', route: '/components/alert'),
          const DocsLink(label: 'Toaster', route: '/components/toaster'),
          const DocsLink(
            label: 'Starfield',
            route: '/components/starfield',
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
      _bullets(ElTheme.of(context), <String>[
        'Nothing here is frozen: --bloom-core, --bloom-glow and '
            '--bloom-hot are all derived at paint time from the '
            'variant\'s own bloom1/bloom2 hues through relative-OKLCH '
            'math (theme.bloomL, theme.bloomC, theme.bloomLift, theme.'
            'bloomHotC) — a rebrand of the action ramp carries through '
            'untouched.',
        '--bloom-void is the identity operand of the blend: white on '
            'light (multiply), black on dark (screen). Both gradients '
            'end on it rather than on transparent, which is the whole '
            'mechanism — fading to the colour the blend cannot see, '
            'rather than to alpha 0, is what avoids a visible '
            'rectangular edge where the blur runs out.',
        'The group opacity flips too: 0.34 on light, 0.75 on dark — '
            'the same theme-blend split sheen-action carries for its own '
            'reason.',
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

const List<DocsApiFact> _bloomCosmicApiFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'bloom1',
    type: 'Color Function(ElThemeData)',
    description:
        'Required on the general constructor (fixed by every named one). '
        '--bloom-1, the companion hue thrown clear to the opposite '
        'diagonal.',
  ),
  DocsApiFact(
    name: 'bloom2',
    type: 'Color Function(ElThemeData)',
    description:
        'Required on the general constructor (fixed by every named one). '
        '--bloom-2, the core hue — also what ElStarfield.glowFor reads on '
        'light when starfield is on.',
  ),
  DocsApiFact(
    name: 'radius',
    type: 'BorderRadius',
    description:
        'Required. The surface\'s own corner; overflow: hidden clips '
        'both layers to it.',
  ),
  DocsApiFact(
    name: 'fill',
    type: 'Color',
    description:
        'Required. The surface\'s background-color, painted first so '
        'the blend has the destination CSS gives it.',
  ),
  DocsApiFact(
    name: 'child',
    type: 'Widget',
    description: 'Required. Painted over both bloom layers.',
  ),
  DocsApiFact(
    name: 'starfield',
    type: 'bool',
    description:
        'Optional, defaults to true. Whether ElStarfield hangs over the '
        'two bloom layers — see the Starfield facet above.',
  ),
];

const List<DocsApiFact> _namedConstructorFacts = <DocsApiFact>[
  DocsApiFact(
    name: '.action',
    type: 'actionBright / action',
    description: 'The utility\'s own default. Alert variant: normal.',
  ),
  DocsApiFact(
    name: '.destructive',
    type: 'theme.destructive / action',
    description: 'Alert variant: destructive; toast type: error.',
  ),
  DocsApiFact(
    name: '.success',
    type: 'success / value',
    description: 'Alert variant: success; toast type: success.',
  ),
  DocsApiFact(
    name: '.warning',
    type: 'warning / action',
    description:
        'Alert variant: warning. DOCUMENTED DRIFT: the toast\'s own '
        'warning uses .toastWarning below instead, a different pair.',
  ),
  DocsApiFact(
    name: '.info',
    type: 'info / action',
    description: 'Alert variant: info; toast type: info.',
  ),
  DocsApiFact(
    name: '.toastWarning',
    type: 'valueBright / valueDark',
    description:
        'Toast type: warning only. The pair .warning was moved OFF — a '
        'warning Alert glows amber, a warning toast still glows lime.',
  ),
  DocsApiFact(
    name: '.loading',
    type: 'actionBright / value',
    description: 'Toast type: loading only.',
  ),
];

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Drifting (default)',
    treatment:
        'Two AnimationControllers (_deep 18s, _near 11s) both call '
        'repeat(reverse: true) forever from didChangeDependencies, on '
        'deliberately coprime-ish periods.',
    userSignal:
        'Each layer travels its own keyframe table of translate/rotate/'
        'scale, endlessly, taking minutes to return to the same relative '
        'arrangement — the two never read as a synchronised loop.',
  ),
  DocsStateFact(
    state: 'Hovered',
    treatment:
        'A shared _hover controller drives the standalone CSS scale '
        'property (2.2 deep, 2.5 near) over ElDurations.bloom (1000ms) '
        'on ElCurves.out — multiplied onto the drift, not overwriting '
        'it, since the two are independent transform components.',
    userSignal:
        'Both layers swell noticeably outward from their own anchored '
        'origin, on top of wherever the drift currently has them.',
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment:
        'elAnimationDuration collapses both drift durations to '
        'Duration.zero, both controllers stop, and the painter switches '
        'to restingMatrixFor — the element\'s own transform: none, with '
        'the hover swell still multiplied on since a transition is '
        'collapsed rather than removed.',
    userSignal:
        'For the deep layer, resting happens to equal its own stop 0. '
        'For the near layer it does NOT: stop 0 is scale(1.04) but the '
        'resting frame is scale(1) — a real, measured 4% difference '
        'between a stilled browser and a moving one, not an artefact.',
  ),
];
