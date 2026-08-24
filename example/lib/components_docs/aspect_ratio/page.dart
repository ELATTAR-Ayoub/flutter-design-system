/// Public documentation page for the `aspect_ratio` component.
///
/// **New route, split out of `scroll_area`.** `ElAspectRatio` used to share
/// the `/components/scroll_area` route with `ElScrollArea` and
/// `ElResizablePanelGroup`, its sections prefixed `Aspect ratio: ` to tell
/// them apart from the sibling families' own. This page mirrors ONLY
/// `https://ui.shadcn.com/docs/components/base/aspect-ratio`'s own section
/// list, fetched fresh: Installation, Usage, Square, Portrait, RTL, API
/// Reference. Every section title below drops the redundant `Aspect ratio: `
/// prefix now that the page documents one component only. A live demo
/// renders ahead of any heading, the same as the reference's own
/// top-of-page preview: no Overview, Status, or Preview heading precedes
/// Installation.
///
/// The registry manifest ships with the CLI and installs through
/// `elattar add aspect-ratio`.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/docs_code.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../kit.dart';
import 'meta.dart';

class AspectRatioDocPage extends StatelessWidget {
  const AspectRatioDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: aspectRatioDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / BASE',
      title: aspectRatioDoc.title,
      description: aspectRatioDoc.description,
    ),
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Components'),
      ElBreadcrumbEntry.page('Aspect ratio'),
    ],
    sidebar: _sidebar,
    toc: const <DocsTocEntry>[
      DocsTocEntry(title: 'Installation', anchor: 'install'),
      DocsTocEntry(title: 'Usage', anchor: 'usage'),
      DocsTocEntry(title: 'Composition', anchor: 'composition'),
      DocsTocEntry(title: 'Square', anchor: 'square'),
      DocsTocEntry(title: 'Portrait', anchor: 'portrait'),
      DocsTocEntry(title: 'RTL', anchor: 'rtl'),
      DocsTocEntry(title: 'API Reference', anchor: 'api'),
      DocsTocEntry(title: 'States', anchor: 'states'),
      DocsTocEntry(title: 'Accessibility', anchor: 'accessibility'),
      DocsTocEntry(title: 'Responsive', anchor: 'responsive'),
      DocsTocEntry(title: 'Dependencies', anchor: 'dependencies'),
      DocsTocEntry(title: 'Theming', anchor: 'theming'),
      DocsTocEntry(title: 'Source', anchor: 'source'),
    ],
    previous: const DocsPageLink(
      title: 'Input OTP',
      route: '/components/input_otp',
    ),
    next: const DocsPageLink(
      title: 'Resizable',
      route: '/components/resizable',
    ),
    onNavigate: onNavigate,
    child: const _AspectRatioArticle(),
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

class _AspectRatioArticle extends StatelessWidget {
  const _AspectRatioArticle();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      key: const ValueKey<String>('aspect-ratio-doc-article'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        // The live demo, ahead of any heading: the same shape the reference
        // opens with. No ElSection wraps it, so it carries no Overview/
        // Status/Preview heading of its own before Installation.
        _liveDemo(theme),
        SizedBox(height: el(8)),
        _install(),
        _usage(),
        _composition(),
        _square(theme),
        _portrait(theme),
        _rtl(theme),
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

  Widget _liveDemo(ElThemeData theme) => DocsCodeExample(
    title: 'Aspect ratio',
    description: 'A box locked to a 4:3 ratio.',
    preview: SizedBox(
      width: el(40),
      child: ElAspectRatio(
        ratio: 4 / 3,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: theme.border),
            color: theme.muted.withAlpha(32),
            borderRadius: BorderRadius.circular(ElRadii.lg),
          ),
          child: Center(child: ElText('4:3 ratio', ElType.small)),
        ),
      ),
    ),
  );

  Widget _install() => ElSection(
    id: 'install',
    title: 'Installation',
    description:
        '`elattar add aspect-ratio` installs the component and its declared '
        'dependency closure.',
    child: DocsInstallFacts(
      title: 'Installation facts',
      facts: <DocsInstallFact>[
        const DocsInstallFact(
          label: 'Registry item',
          value: 'registry/components/aspect_ratio.json',
          description:
              'Shipped and resolved by `elattar add aspect-ratio`. This is '
              'a source-only component today.',
        ),
        const DocsInstallFact(
          label: 'Destination',
          value: 'lib/components/ui/aspect_ratio.dart',
          description: 'Where a manual copy of the source belongs.',
        ),
        const DocsInstallFact(
          label: 'Dependencies',
          value: 'none',
          description:
              'aspect_ratio.dart imports only package:flutter/widgets.dart '
              'and wraps the framework\'s own AspectRatio: no foundation '
              'import at all.',
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
              'This page\'s live preview. No dedicated package-level unit '
              'tests.',
        ),
      ],
    ),
  );

  Widget _usage() => ElSection(
    id: 'usage',
    title: 'Usage',
    description: 'ElAspectRatio for a locked box.',
    child: ElPanel(
      label: 'DART',
      note: 'LOCKED BOX',
      child: DocsSelectableCodeBlock(code: _usageCode),
    ),
  );

  Widget _composition() => ElSection(
    id: 'composition',
    title: 'Composition',
    description:
        'What the constructor assembles internally: the shape read off '
        'the reference\'s own primitives in the source file\'s doc '
        'comment.',
    child: ElPanel(
      label: 'Aspect ratio',
      child: DocsSelectableCodeBlock(code: _compositionCode),
    ),
  );

  Widget _square(ElThemeData theme) => ElSection(
    id: 'square',
    title: 'Square',
    description: 'ratio: 1 / 1 for an even box, whatever width it is given.',
    child: DocsCodeExample(
      title: 'Square box',
      preview: SizedBox(
        width: el(30),
        child: ElAspectRatio(
          ratio: 1 / 1,
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: theme.border),
              color: theme.muted.withAlpha(32),
              borderRadius: BorderRadius.circular(ElRadii.lg),
            ),
            child: Center(child: ElText('1:1 ratio', ElType.small)),
          ),
        ),
      ),
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(path: 'square_aspect_ratio.dart', code: _squareCode),
      ],
    ),
  );

  Widget _portrait(ElThemeData theme) => ElSection(
    id: 'portrait',
    title: 'Portrait',
    description:
        'ratio: 9 / 16 for a tall box, the inverse of a widescreen '
        'frame.',
    child: DocsCodeExample(
      title: 'Portrait box',
      preview: SizedBox(
        width: el(20),
        child: ElAspectRatio(
          ratio: 9 / 16,
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: theme.border),
              color: theme.muted.withAlpha(32),
              borderRadius: BorderRadius.circular(ElRadii.lg),
            ),
            child: Center(child: ElText('9:16 ratio', ElType.small)),
          ),
        ),
      ),
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(path: 'portrait_aspect_ratio.dart', code: _portraitCode),
      ],
    ),
  );

  Widget _rtl(ElThemeData theme) => ElSection(
    id: 'rtl',
    title: 'RTL',
    description:
        'ElAspectRatio has no observable difference under a '
        'Directionality.rtl ambient direction: the ratio box is centered '
        'in flow with no reading-direction-sensitive offset of its own. '
        'Content inside the child still reads in whichever direction its '
        'own text sets.',
    child: DocsCodeExample(
      title: 'Right-to-left aspect ratio',
      preview: Directionality(
        textDirection: TextDirection.rtl,
        child: SizedBox(
          width: el(30),
          child: ElAspectRatio(
            ratio: 4 / 3,
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: theme.border),
                color: theme.muted.withAlpha(32),
                borderRadius: BorderRadius.circular(ElRadii.lg),
              ),
              child: Center(child: ElText('نسبة 4:3', ElType.small)),
            ),
          ),
        ),
      ),
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(path: 'rtl_aspect_ratio.dart', code: _rtlAspectCode),
      ],
    ),
  );

  Widget _api() => ElSection(
    id: 'api',
    title: 'API Reference',
    child: const DocsApiTable(
      title: 'ElAspectRatio',
      facts: <DocsApiFact>[
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
              'Defaults to EdgeInsets.zero. Applied to the inner, '
              'absolutely positioned box, shrinking it inside the '
              'aspect-locked slot rather than pushing anything after it '
              'down.',
        ),
      ],
    ),
  );

  Widget _states() => ElSection(
    id: 'states',
    title: 'States',
    description:
        'ElAspectRatio is static: it carries no interactive state '
        'of its own.',
    child: const DocsStateMatrix(
      facts: <DocsStateFact>[
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
      ],
    ),
  );

  Widget _accessibility(ElThemeData theme) => ElSection(
    id: 'accessibility',
    title: 'Accessibility',
    child: _bullets(theme, <String>[
      'Purely structural: ElAspectRatio builds no Semantics node of its '
          'own. Used to frame content that manages its own accessibility.',
      'Keyboard interactions: none, ElAspectRatio is never in the tab '
          'order, consistent with it not being interactive content.',
    ]),
  );

  Widget _responsive(ElThemeData theme) => ElSection(
    id: 'responsive',
    title: 'Responsive',
    child: _bullets(theme, <String>[
      'Locks to the ratio on every viewport. A 390px-wide box at 16:9 is '
          '390 × 219. The ratio is device-agnostic.',
      'Never overflows: it locks the box to the ratio rather than letting '
          'content grow past it.',
      'Platform-agnostic: no platform-branching code.',
    ]),
  );

  Widget _dependencies(ElThemeData theme) => ElSection(
    id: 'dependencies',
    title: 'Dependencies',
    child: _bullets(theme, <String>[
      'File: lib/src/components/aspect_ratio.dart (one file, no private '
          'helpers).',
      'Flutter import: package:flutter/widgets.dart only, for the '
          'framework\'s own AspectRatio and Padding.',
      'No foundation import: [margin] takes a caller-supplied EdgeInsets '
          'directly rather than a el()-derived default.',
      'Assets/fonts/shaders: none.',
      'Status: a stable primitive, installable through `elattar add aspect-ratio` (see '
          'Installation). Platforms: Android, iOS, Web, macOS, Windows, '
          'Linux.',
    ]),
  );

  Widget _theming(ElThemeData theme) => ElSection(
    id: 'theming',
    title: 'Theming',
    child: _bullets(theme, <String>[
      'Purely structural, no colours of its own: the child paints '
          'everything visible.',
      'ElAspectRatio declares no colour parameter at all, consistent with '
          'it being layout only.',
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
              'Covers this page: the API table, live specimens, and theme '
              'coverage.',
        ),
        const DocsInstallFact(
          label: 'Edit these docs',
          value: 'example/lib/components_docs/aspect_ratio/page.dart',
          description: 'This file.',
        ),
      ],
    ),
  );
}

Widget _bullets(ElThemeData theme, List<String> lines) => ConstrainedBox(
  constraints: const BoxConstraints(maxWidth: ElWidths.prose),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      for (final String line in lines) ...<Widget>[
        ElText('•  $line', ElType.small, color: theme.mutedForeground),
        SizedBox(height: el(2)),
      ],
    ],
  ),
);

const String _usageCode = '''ElAspectRatio(
  ratio: 5 / 7,
  margin: EdgeInsets.all(el(2)),
  child: DecoratedBox(
    decoration: BoxDecoration(
      border: Border.all(),
      borderRadius: BorderRadius.circular(ElRadii.lg),
    ),
  ),
)''';

const String _compositionCode = '''// AspectRatio(aspectRatio: ratio)
//  Padding(margin) -- only when margin is non-zero
//   child: the caller's own box''';

const String _squareCode = '''ElAspectRatio(
  ratio: 1 / 1,
  child: DecoratedBox(
    decoration: BoxDecoration(
      border: Border.all(),
      borderRadius: BorderRadius.circular(ElRadii.lg),
    ),
  ),
)''';

const String _portraitCode = '''ElAspectRatio(
  ratio: 9 / 16,
  child: DecoratedBox(
    decoration: BoxDecoration(
      border: Border.all(),
      borderRadius: BorderRadius.circular(ElRadii.lg),
    ),
  ),
)''';

const String _rtlAspectCode = '''Directionality(
  textDirection: TextDirection.rtl,
  child: ElAspectRatio(
    ratio: 4 / 3,
    child: DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(ElRadii.lg),
      ),
    ),
  ),
)''';
