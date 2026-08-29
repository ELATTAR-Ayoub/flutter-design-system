/// Public documentation page for the `aspect_ratio` component.
///
/// **Re-housed onto the kit.** This page used to hand-compose `Section`
/// panels reshaped to mirror shadcn's own flat section list (Installation,
/// Usage, Square, Portrait, RTL, API Reference — fetched fresh from
/// https://ui.shadcn.com/docs/components/base/aspect-ratio); it now
/// declares a `ComponentDocSpec` (`example/lib/docs/component_doc_page.dart`)
/// and hands it to `ComponentDocPage`, the same shape `button` and `field`
/// established. Every specimen widget and every code string below is the
/// same one the hand-composed page carried; only where it lives changed,
/// plus the top-of-page live demo, which is now its own `Preview`
/// `ShowcaseSection` with a code toggle rather than a headless
/// `DocsCodeExample`.
///
/// **Corrected, not just moved.** This page's own `meta.dart` used to claim
/// `registry/components/aspect_ratio.json` "does not exist yet" and that
/// the entry was "not wired into `catalog.dart`". Both were false:
/// `registry/components/aspect-ratio.json` exists (hyphenated, matching
/// every other registry file name), lists `aspect_ratio.dart` with **no**
/// registry dependencies, and `catalog.dart`'s `componentDocs` list already
/// carries this entry. See `meta.dart` for the correction.
///
/// **Eleven lines, no styling of its own** — `lib/src/components/ui/
/// aspect_ratio.dart`'s own library doc counts them. The widget wraps only
/// Flutter's own `AspectRatio` and, when `margin` is non-zero, `Padding`: no
/// foundation import, no colour, no Semantics node, no key handling. States,
/// Keyboard, and Accessibility below say exactly that and nothing more —
/// padding a static, structural primitive with invented behaviour would
/// misdescribe it.
///
/// New: a Keyboard disclosure, between Accessibility and Responsive.
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

final ComponentDocSpec aspectRatioDocSpec = ComponentDocSpec(
  name: 'aspect-ratio',
  title: aspectRatioDoc.title,
  description: aspectRatioDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description: 'A box locked to a 4:3 ratio.',
      specimen: _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'aspect_ratio has a real registry manifest, `elattar add '
          'aspect-ratio` installs lib/src/components/ui/aspect_ratio.dart. It '
          'declares no registry dependencies at all: the source imports '
          'only package:flutter/widgets.dart, not even the foundation. '
          'The Manual tab is for a project not using the CLI.',
      command: aspectRatioDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/aspect_ratio.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/ui/aspect_ratio.dart's generated "
              '@ui/aspect_ratio.dart payload into components/ui.',
          code:
              "import 'package:flutter/widgets.dart' hide AspectRatio, Form, FormField, Icon, OverlayPortal, RadioGroup, RichText, SafeArea, ScrollPosition, Table, TableColumnWidth;\n\n"
              '// Copy the generated aspect_ratio source here when using '
              'manual mode.',
        ),
        DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so AspectRatio is reachable the '
              'same way the CLI path already makes it.',
          code: "export 'aspect_ratio.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description: 'AspectRatio for a locked box.',
      code: _usageCode,
    ),
    SnippetSection(
      id: 'composition',
      title: 'Composition',
      description:
          "What the constructor assembles internally: the shape read off "
          "the reference's own primitives in the source file's doc "
          'comment, not a live specimen: there is nothing to toggle a '
          'view on beyond the box itself, shown below.',
      code: _compositionCode,
    ),
    ShowcaseSection(
      id: 'square',
      title: 'Square',
      description: 'ratio: 1 / 1 for an even box, whatever width it is given.',
      specimen: _SquareSpecimen(),
      code: _squareCode,
      label: 'Square specimen view',
    ),
    ShowcaseSection(
      id: 'portrait',
      title: 'Portrait',
      description:
          'ratio: 9 / 16 for a tall box, the inverse of a widescreen frame.',
      specimen: _PortraitSpecimen(),
      code: _portraitCode,
      label: 'Portrait specimen view',
    ),
    ShowcaseSection(
      id: 'rtl',
      title: 'RTL',
      description:
          'AspectRatio has no observable difference under a '
          'Directionality.rtl ambient direction: the ratio box is centered '
          'in flow with no reading-direction-sensitive offset of its own. '
          'Content inside the child still reads in whichever direction its '
          'own text sets.',
      specimen: _RtlSpecimen(),
      code: _rtlAspectCode,
      label: 'RTL specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      child: const DocsApiTable(title: 'AspectRatio', facts: _apiFacts),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'One honest sentence: AspectRatio is static and carries no '
          'interactive state of its own, so every row below but Rest is '
          'N/A.',
      child: const DocsStateMatrix(facts: _stateFacts),
    ),
    DisclosureSection(
      id: 'accessibility',
      title: 'Accessibility',
      description:
          'One honest sentence: aspect_ratio.dart builds no Semantics '
          'node and no gesture or focus handling, so there is nothing '
          'here beyond "frame content that manages its own '
          'accessibility."',
      child: _AccessibilityContent(),
    ),
    DisclosureSection(
      id: 'keyboard',
      title: 'Keyboard',
      description:
          'One honest sentence: aspect_ratio.dart wires no Focus node and '
          'no key handling at all, so AspectRatio is never in the tab '
          'order.',
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
      description:
          "Elattar's own technical-transparency panel: what this "
          'component needs to install and run.',
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
            value: aspectRatioDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'none yet',
            description: 'No dedicated unit tests in the package test suite.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/aspect_ratio_test.dart',
            description:
                "Covers this page: the API table, live specimens, and "
                'theme coverage.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/aspect_ratio/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class AspectRatioDocPage extends StatelessWidget {
  const AspectRatioDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: aspectRatioDoc.route,
    intro: DocsPageIntro(
      title: aspectRatioDoc.title,
      description: aspectRatioDoc.description,
    ),
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Components'),
      BreadcrumbEntry.page('Aspect ratio'),
    ],
    sidebar: _sidebar,
    toc: aspectRatioDocSpec.toc,
    previous: const DocsPageLink(
      title: 'Input OTP',
      route: '/components/input_otp',
    ),
    next: const DocsPageLink(
      title: 'Resizable',
      route: '/components/resizable',
    ),
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('aspect-ratio-doc-article'),
      child: ComponentDocPage(spec: aspectRatioDocSpec, header: false),
    ),
  );
}

/// `aspect_ratio`, `resizable`, and `scroll_area`'s own small family: see
/// `scroll_area/page.dart`'s own note on this scope.
const List<DocsSidebarEntry> _sidebar = <DocsSidebarEntry>[
  DocsSidebarEntry(
    title: 'Aspect ratio',
    route: '/components/aspect_ratio',
    selected: true,
  ),
  DocsSidebarEntry(title: 'Resizable', route: '/components/resizable'),
  DocsSidebarEntry(title: 'Scroll area', route: '/components/scroll_area'),
];

/* ── Showcase specimens ─────────────────────────────────────────────────── */

class _PreviewSpecimen extends StatelessWidget {
  const _PreviewSpecimen();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return SizedBox(
      width: space(40),
      child: AspectRatio(
        ratio: 4 / 3,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: theme.border),
            color: theme.muted.withAlpha(32),
            borderRadius: BorderRadius.circular(Radii.lg),
          ),
          child: Center(child: StyledText('4:3 ratio', TextStyles.small)),
        ),
      ),
    );
  }
}

class _SquareSpecimen extends StatelessWidget {
  const _SquareSpecimen();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return SizedBox(
      width: space(30),
      child: AspectRatio(
        ratio: 1 / 1,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: theme.border),
            color: theme.muted.withAlpha(32),
            borderRadius: BorderRadius.circular(Radii.lg),
          ),
          child: Center(child: StyledText('1:1 ratio', TextStyles.small)),
        ),
      ),
    );
  }
}

class _PortraitSpecimen extends StatelessWidget {
  const _PortraitSpecimen();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return SizedBox(
      width: space(20),
      child: AspectRatio(
        ratio: 9 / 16,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: theme.border),
            color: theme.muted.withAlpha(32),
            borderRadius: BorderRadius.circular(Radii.lg),
          ),
          child: Center(child: StyledText('9:16 ratio', TextStyles.small)),
        ),
      ),
    );
  }
}

class _RtlSpecimen extends StatelessWidget {
  const _RtlSpecimen();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SizedBox(
        width: space(30),
        child: AspectRatio(
          ratio: 4 / 3,
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: theme.border),
              color: theme.muted.withAlpha(32),
              borderRadius: BorderRadius.circular(Radii.lg),
            ),
            child: Center(child: StyledText('نسبة 4:3', TextStyles.small)),
          ),
        ),
      ),
    );
  }
}

/* ── Disclosure content ─────────────────────────────────────────────────── */

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Purely structural: AspectRatio builds no Semantics node of its '
            'own. Used to frame content that manages its own accessibility.',
      ]);
}

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'No key handling of its own: aspect_ratio.dart wires no Focus '
            'node anywhere, so AspectRatio is never in the tab order, '
            'consistent with it not being interactive content.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Locks to the ratio on every viewport. A 390px-wide box at 16:9 is '
            '390 × 219. The ratio is device-agnostic.',
        'Never overflows: it locks the box to the ratio rather than '
            'letting content grow past it.',
        'Platform-agnostic: no platform-branching code.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => DocsInstallFacts(
    facts: <DocsInstallFact>[
      const DocsInstallFact(
        label: 'Registry item',
        value: 'aspect-ratio',
        description:
            'registry/components/aspect-ratio.json exists and is '
            'installable through the CLI today.',
      ),
      const DocsInstallFact(
        label: 'Destination',
        value: 'lib/components/ui/aspect_ratio.dart',
        description:
            'The same lib/components/ui/ target every component installs '
            'to.',
      ),
      DocsInstallFact(
        label: 'Dependencies',
        value: aspectRatioDoc.dependencies.isEmpty
            ? 'none'
            : aspectRatioDoc.dependencies.join(', '),
        description:
            'The manifest\'s own registryDependencies array is empty: '
            'aspect_ratio.dart imports only package:flutter/widgets.dart, '
            'not even the foundation.',
      ),
      const DocsInstallFact(
        label: 'Assets',
        value: 'none',
        description: 'No image, font, or shader asset is referenced.',
      ),
      const DocsInstallFact(
        label: 'Platforms',
        value: 'Android, iOS, Web, macOS, Windows, Linux',
        description: 'Pure widget composition: no platform-conditional code.',
      ),
      const DocsInstallFact(
        label: 'Verified',
        value: 'docs specimen only',
        description:
            "This page's live specimens. No dedicated package-level unit "
            'tests.',
      ),
    ],
  );
}

class _ThemingContent extends StatelessWidget {
  const _ThemingContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Purely structural, no colours of its own: the child paints '
            'everything visible.',
        'AspectRatio declares no colour parameter at all, consistent '
            'with it being layout only.',
      ]);
}

Widget _bullets(ThemeTokens theme, List<String> lines) => ConstrainedBox(
  constraints: const BoxConstraints(maxWidth: LayoutWidths.prose),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      for (final String line in lines) ...<Widget>[
        StyledText('•  $line', TextStyles.small, color: theme.mutedForeground),
        SizedBox(height: space(2)),
      ],
    ],
  ),
);

const String _previewCode = '''AspectRatio(
  ratio: 4 / 3,
  child: DecoratedBox(
    decoration: BoxDecoration(
      border: Border.all(),
      borderRadius: BorderRadius.circular(Radii.lg),
    ),
    child: const Center(child: Text('4:3 ratio')),
  ),
)''';

const String _usageCode = '''AspectRatio(
  ratio: 5 / 7,
  margin: EdgeInsets.all(space(2)),
  child: DecoratedBox(
    decoration: BoxDecoration(
      border: Border.all(),
      borderRadius: BorderRadius.circular(Radii.lg),
    ),
  ),
)''';

const String _compositionCode = '''// AspectRatio(aspectRatio: ratio)
//  Padding(margin) -- only when margin is non-zero
//   child: the caller's own box''';

const String _squareCode = '''AspectRatio(
  ratio: 1 / 1,
  child: DecoratedBox(
    decoration: BoxDecoration(
      border: Border.all(),
      borderRadius: BorderRadius.circular(Radii.lg),
    ),
  ),
)''';

const String _portraitCode = '''AspectRatio(
  ratio: 9 / 16,
  child: DecoratedBox(
    decoration: BoxDecoration(
      border: Border.all(),
      borderRadius: BorderRadius.circular(Radii.lg),
    ),
  ),
)''';

const String _rtlAspectCode = '''Directionality(
  textDirection: TextDirection.rtl,
  child: AspectRatio(
    ratio: 4 / 3,
    child: DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(Radii.lg),
      ),
    ),
  ),
)''';

const List<DocsApiFact> _apiFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'ratio',
    type: 'double',
    description: 'Required. Width ÷ height (e.g., 16/9, 4/3, 5/7).',
  ),
  DocsApiFact(
    name: 'child',
    type: 'Widget?',
    description:
        'The content box. The ratio box inside respects any margin '
        'applied.',
  ),
  DocsApiFact(
    name: 'margin',
    type: 'EdgeInsets',
    description:
        'Defaults to EdgeInsets.zero. Applied to the inner, absolutely '
        'positioned box, shrinking it inside the aspect-locked slot '
        'rather than pushing anything after it down.',
  ),
];

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Rest (its only state)',
    treatment: 'A fixed-ratio box; the child paints whatever it is.',
    userSignal: 'A box that keeps its ratio no matter how wide it is.',
  ),
  DocsStateFact(
    state:
        'Hover / Focus / Pressed / Selected / Disabled / Loading / '
        'Reduced motion',
    treatment:
        'N/A: the widget carries no gesture, focus, or async-flag '
        'parameter to hold any of these; it is pure layout, and it '
        'animates nothing of its own.',
    userSignal:
        'It does not respond to pointer or keyboard input; there is '
        'nothing to hover, focus, press, select, or disable.',
  ),
];
