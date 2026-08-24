/// Public documentation page for the `scroll_area` component.
///
/// **Split off `resizable` and `aspect_ratio`.** This route used to carry
/// `ElScrollArea`, `ElResizablePanelGroup`, and `ElAspectRatio` on one page,
/// each family's sections prefixed with its own name
/// (`navigation_menu/page.dart`'s own `<Component>: <Section>` convention
/// for a merge). Both siblings now have their own routes:
/// `example/lib/components_docs/resizable/` and `.../aspect_ratio/`. This
/// page mirrors ONLY `https://ui.shadcn.com/docs/components/base/scroll-area`'s
/// own section list, fetched fresh: Installation, Usage, Composition,
/// Horizontal, RTL, API Reference. Every section title below drops the
/// redundant `Scroll area: ` prefix now that the page documents one
/// component only. A live demo renders ahead of any heading, the same as
/// the reference's own top-of-page preview: no Overview, Status, or Preview
/// heading precedes Installation.
///
/// The registry manifest ships with the CLI and installs through
/// `elattar add scroll-area`.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/docs_code.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../kit.dart';
import 'meta.dart';

class ScrollAreaDocPage extends StatelessWidget {
  const ScrollAreaDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: scrollAreaDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / BASE',
      title: scrollAreaDoc.title,
      description: scrollAreaDoc.description,
    ),
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Components'),
      ElBreadcrumbEntry.page('Scroll area'),
    ],
    sidebar: _sidebar,
    toc: const <DocsTocEntry>[
      DocsTocEntry(title: 'Installation', anchor: 'install'),
      DocsTocEntry(title: 'Usage', anchor: 'usage'),
      DocsTocEntry(title: 'Composition', anchor: 'composition'),
      DocsTocEntry(title: 'Horizontal scrolling', anchor: 'horizontal'),
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
      title: 'Resizable',
      route: '/components/resizable',
    ),
    next: const DocsPageLink(title: 'Layout', route: '/components/layout'),
    onNavigate: onNavigate,
    child: const _ArticleContent(),
  );
}

/// `aspect_ratio`, `resizable`, and `scroll_area`'s own small family, now
/// three routes instead of one: the same scope the merged page already used
/// for this list, kept unchanged by the split.
const List<DocsSidebarEntry> _sidebar = <DocsSidebarEntry>[
  DocsSidebarEntry(title: 'Aspect ratio', route: '/components/aspect_ratio'),
  DocsSidebarEntry(title: 'Resizable', route: '/components/resizable'),
  DocsSidebarEntry(
    title: 'Scroll area',
    route: '/components/scroll_area',
    selected: true,
  ),
];

class _ArticleContent extends StatelessWidget {
  const _ArticleContent();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      key: const ValueKey<String>('scroll-area-doc-article'),
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
        _horizontal(theme),
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
    title: 'Scroll area',
    description: 'A scroll area with a hover-visible vertical scrollbar.',
    preview: SizedBox(
      height: el(40),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: theme.border),
          borderRadius: BorderRadius.circular(ElRadii.lg),
        ),
        child: ElScrollArea(
          key: const ValueKey<String>('scroll-area-doc-preview'),
          borderRadius: BorderRadius.circular(ElRadii.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for (int i = 0; i < 20; i++)
                Padding(
                  padding: EdgeInsets.all(el(2)),
                  child: ElText(
                    'Item $i: scroll to reveal the scrollbar',
                    ElType.body,
                  ),
                ),
            ],
          ),
        ),
      ),
    ),
  );

  Widget _install() => ElSection(
    id: 'install',
    title: 'Installation',
    description:
        '`elattar add scroll-area` installs the component and its declared '
        'dependency closure.',
    child: DocsInstallFacts(
      title: 'Installation facts',
      facts: <DocsInstallFact>[
        const DocsInstallFact(
          label: 'Registry item',
          value: 'registry/components/scroll_area.json',
          description:
              'Shipped and resolved by `elattar add scroll-area`. This is a '
              'source-only component today.',
        ),
        const DocsInstallFact(
          label: 'Destination',
          value: 'lib/components/ui/scroll_area.dart',
          description: 'Where a manual copy of the source belongs.',
        ),
        const DocsInstallFact(
          label: 'Dependencies',
          value: 'source-foundation',
          description:
              'foundation/spacing.dart and foundation/theme.dart: no '
              'effects, no colors, no shadows, just layout and theming.',
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
    description: 'ElScrollArea wrapping a list of items.',
    child: ElPanel(
      label: 'DART',
      note: 'ElScrollArea WITH CONTENT',
      child: DocsSelectableCodeBlock(code: _usageScrollCode),
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
      label: 'Scroll area',
      child: DocsSelectableCodeBlock(code: _scrollAreaCompositionCode),
    ),
  );

  Widget _horizontal(ElThemeData theme) => ElSection(
    id: 'horizontal',
    title: 'Horizontal scrolling',
    description:
        'horizontalBar: true enables the horizontal axis. Without it, '
        'horizontal overflow is clipped (overflow-x: hidden), which is '
        'ElScrollArea\'s default: the wrapper only ever renders one '
        'vertical rail unless asked for the other.',
    child: DocsCodeExample(
      title: 'Horizontal card rail',
      preview: SizedBox(
        height: el(24),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: theme.border),
            borderRadius: BorderRadius.circular(ElRadii.lg),
          ),
          child: ElScrollArea(
            borderRadius: BorderRadius.circular(ElRadii.lg),
            horizontalBar: true,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                for (int i = 0; i < 6; i++)
                  Padding(
                    padding: EdgeInsets.all(el(2)),
                    child: SizedBox(
                      width: el(20),
                      height: el(16),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border.all(color: theme.border),
                          borderRadius: BorderRadius.circular(ElRadii.lg),
                        ),
                        child: Center(child: ElText('Card $i', ElType.small)),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(
          path: 'horizontal_scroll_area.dart',
          code: _horizontalScrollCode,
        ),
      ],
    ),
  );

  Widget _rtl(ElThemeData theme) => ElSection(
    id: 'rtl',
    title: 'RTL',
    description:
        'The one honest divergence in this component: the rail is placed '
        'with a literal right: 0, not a directional end offset, so it '
        'stays on the physical right edge under a Directionality.rtl '
        'ambient direction instead of moving to the reading-start edge. '
        'Content inside the viewport still reads in whichever direction '
        'its own text sets.',
    child: DocsCodeExample(
      title: 'Right-to-left scroll area',
      preview: Directionality(
        textDirection: TextDirection.rtl,
        child: SizedBox(
          height: el(24),
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: theme.border),
              borderRadius: BorderRadius.circular(ElRadii.lg),
            ),
            child: ElScrollArea(
              borderRadius: BorderRadius.circular(ElRadii.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  for (int i = 0; i < 8; i++)
                    Padding(
                      padding: EdgeInsets.all(el(2)),
                      child: ElText('عنصر $i', ElType.body),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(path: 'rtl_scroll_area.dart', code: _rtlScrollCode),
      ],
    ),
  );

  Widget _api() => ElSection(
    id: 'api',
    title: 'API Reference',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const DocsApiTable(
          title: 'ElScrollArea',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'child',
              type: 'Widget',
              description: 'Required. The content to scroll.',
            ),
            DocsApiFact(
              name: 'borderRadius',
              type: 'BorderRadius?',
              description:
                  'The viewport\'s inner corner radius. The scrollbar '
                  'respects this.',
            ),
            DocsApiFact(
              name: 'horizontalBar',
              type: 'bool',
              description:
                  'Defaults to false. Without it, horizontal overflow is '
                  'clipped (overflow-x: hidden).',
            ),
            DocsApiFact(
              name: 'controller',
              type: 'ScrollController?',
              description: 'Drives the vertical scroll from outside.',
            ),
          ],
        ),
        SizedBox(height: el(6)),
        const DocsApiTable(
          title: 'ElScrollAreaBehavior',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'ElScrollAreaBehavior',
              type: 'class',
              description:
                  'A ScrollBehavior for nested scroll views. Suppresses '
                  'overscroll and platform scrollbars. Use '
                  '`ScrollConfiguration(behavior: ElScrollAreaBehavior(), '
                  'child: ElScrollArea(...))` when nesting.',
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
        'ElScrollArea shows and hides the scrollbar; nothing else '
        'about it changes state.',
    child: const DocsStateMatrix(
      facts: <DocsStateFact>[
        DocsStateFact(
          state: 'Rest',
          treatment: 'No scrollbar visible.',
          userSignal: 'Plain appearance.',
        ),
        DocsStateFact(
          state: 'Hover',
          treatment:
              'Scrollbar fades in on pointerenter. Stays visible for '
              'all gestures until pointerleave starts the 600ms hide '
              'delay.',
          userSignal: 'Scrollbar appears.',
        ),
        DocsStateFact(
          state: 'Drag',
          treatment: 'Thumb follows pointer 1:1, no easing.',
          userSignal: 'Smooth drag feedback.',
        ),
        DocsStateFact(
          state: 'Disabled / Loading / Selected / Focus',
          treatment:
              'N/A: the scroll area itself has no such state. Content '
              'inside manages its own states, and the scrollbar is not a '
              'focusable element.',
          userSignal: 'Refer to the content\'s own state handling.',
        ),
        DocsStateFact(
          state: 'Reduced motion',
          treatment:
              'N/A: no animations. The scrollbar\'s 600ms hide delay is '
              'not a motion token and does not respond to '
              'prefers-reduced-motion.',
          userSignal: 'No motion to still.',
        ),
      ],
    ),
  );

  Widget _accessibility(ElThemeData theme) => ElSection(
    id: 'accessibility',
    title: 'Accessibility',
    child: _bullets(theme, <String>[
      'The scrollbar is not a focusable element. Scroll is available '
          'through standard wheel/trackpad gestures. Content inside '
          'maintains its own semantics and focus order.',
      'Non-colour signal: the scrollbar is theme.border, no semantic '
          'colour: it carries no status meaning to communicate.',
      'Keyboard interactions: none of ElScrollArea\'s own; the enclosing '
          'Scrollable still answers PageUp/PageDown/arrow-key scroll when '
          'focus is inside it.',
    ]),
  );

  Widget _responsive(ElThemeData theme) => ElSection(
    id: 'responsive',
    title: 'Responsive',
    child: _bullets(theme, <String>[
      'Renders the same scroll container at 390px and 1440px. Width and '
          'height are driven by the surrounding layout. The scrollbar is '
          'always 10px wide (the rail) with a 7px thumb.',
      'Overflow: horizontalBar controls whether horizontal overflow '
          'scrolls or clips.',
      'Platform-agnostic: no platform-branching code.',
    ]),
  );

  Widget _dependencies(ElThemeData theme) => ElSection(
    id: 'dependencies',
    title: 'Dependencies',
    child: _bullets(theme, <String>[
      'File: lib/src/components/scroll_area.dart (one file, includes '
          'ElScrollAreaBehavior and the private _Viewport/_Rail layout '
          'classes).',
      'Foundation imports: foundation/spacing.dart (el()), '
          'foundation/theme.dart (ElThemeData). No effects, no colors, no '
          'shadows: just layout and theming.',
      'Scope import: theme_scope.dart (ElTheme).',
      'Assets/fonts/shaders: none. The scrollbar thumb is a DecoratedBox '
          'with BorderRadius.circular.',
      'Status: a stable primitive, installable through `elattar add scroll-area` (see '
          'Installation). Platforms: Android, iOS, Web, macOS, Windows, '
          'Linux.',
    ]),
  );

  Widget _theming(ElThemeData theme) => ElSection(
    id: 'theming',
    title: 'Theming',
    child: _bullets(theme, <String>[
      'The scrollbar thumb is theme.border at rest. No hover state: the '
          'rail is always present when visible, the thumb just moves.',
      'Reads from the live theme: flipping ElThemeController updates the '
          'scrollbar colour immediately.',
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
          value: scrollAreaDoc.sourcePath,
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
          value: 'example/test/components_docs/scroll_area_test.dart',
          description:
              'Covers this page: the API tables, the live specimen, and '
              'theme coverage.',
        ),
        const DocsInstallFact(
          label: 'Edit these docs',
          value: 'example/lib/components_docs/scroll_area/page.dart',
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

const String _usageScrollCode = '''ElScrollArea(
  borderRadius: BorderRadius.circular(ElRadii.lg),
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: items.map((item) {
      return Padding(
        padding: EdgeInsets.all(el(2)),
        child: Text(item),
      );
    }).toList(),
  ),
)''';

const String _scrollAreaCompositionCode =
    '''// MouseRegion(onEnter/onExit: show/schedule-hide the rail)
//  ClipRRect(borderRadius: your inner corner)
//   Stack
//    _Viewport: SingleChildScrollView(vertical) around an IntrinsicWidth
//               table box, horizontal SingleChildScrollView only when
//               horizontalBar is true
//    _Rail (only while visible): the 10px lane, 7px thumb, drag and
//           tap-to-centre wired directly on it''';

const String _horizontalScrollCode = '''ElScrollArea(
  borderRadius: BorderRadius.circular(ElRadii.lg),
  horizontalBar: true,
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: cards,
  ),
)''';

const String _rtlScrollCode = '''Directionality(
  textDirection: TextDirection.rtl,
  child: ElScrollArea(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: items,
    ),
  ),
)''';
