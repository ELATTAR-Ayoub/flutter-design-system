/// Public documentation page for the `resizable` component.
///
/// **New route, split out of `scroll_area`.** `ElResizablePanelGroup` used
/// to share the `/components/scroll_area` route with `ElScrollArea` and
/// `ElAspectRatio`, its sections prefixed `Resizable: ` to tell them apart
/// from the sibling families' own. This page mirrors ONLY
/// `https://ui.shadcn.com/docs/components/base/resizable`'s own section
/// list, fetched fresh: About, Installation, Usage, Composition, Vertical,
/// Handle, RTL, API Reference, Changelog. Every section title below drops
/// the redundant `Resizable: ` prefix now that the page documents one
/// component only. A live demo renders ahead of any heading, the same as
/// the reference's own top-of-page preview: no Overview, Status, or Preview
/// heading precedes Installation.
///
/// **Skipped, honestly.** `About` and `Changelog` describe the upstream
/// `react-resizable-panels` package itself (its version, its own release
/// notes) rather than a UI affordance a Flutter port can show; there is
/// nothing to mirror in either. `Vertical` is skipped for a real reason,
/// not an oversight: [ElResizablePanelGroup] takes no orientation parameter
/// at all, its `build` method always lays panels into a horizontal `Row`
/// (`resizable.dart`'s own `Row(crossAxisAlignment: ..., children: row)`),
/// so there is no vertical mode to demonstrate.
///
/// The registry manifest ships with the CLI and installs through
/// `elattar add resizable`.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/docs_code.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../kit.dart';
import 'meta.dart';

class ResizableDocPage extends StatelessWidget {
  const ResizableDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: resizableDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / BASE',
      title: resizableDoc.title,
      description: resizableDoc.description,
    ),
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Components'),
      ElBreadcrumbEntry.page('Resizable'),
    ],
    sidebar: _sidebar,
    toc: const <DocsTocEntry>[
      DocsTocEntry(title: 'Installation', anchor: 'install'),
      DocsTocEntry(title: 'Usage', anchor: 'usage'),
      DocsTocEntry(title: 'Composition', anchor: 'composition'),
      DocsTocEntry(title: 'Handle', anchor: 'handle'),
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
      title: 'Aspect ratio',
      route: '/components/aspect_ratio',
    ),
    next: const DocsPageLink(
      title: 'Scroll area',
      route: '/components/scroll_area',
    ),
    onNavigate: onNavigate,
    child: const _ResizableArticle(),
  );
}

/// `aspect_ratio`, `resizable`, and `scroll_area`'s own small family: see
/// `scroll_area/page.dart`'s own note on this scope.
const List<DocsSidebarEntry> _sidebar = <DocsSidebarEntry>[
  DocsSidebarEntry(title: 'Aspect ratio', route: '/components/aspect_ratio'),
  DocsSidebarEntry(
    title: 'Resizable',
    route: '/components/resizable',
    selected: true,
  ),
  DocsSidebarEntry(title: 'Scroll area', route: '/components/scroll_area'),
];

class _ResizableArticle extends StatelessWidget {
  const _ResizableArticle();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      key: const ValueKey<String>('resizable-doc-article'),
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
        _handle(theme),
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
    title: 'Resizable panel group',
    description: 'Two panels sharing a row, split by a draggable separator.',
    preview: SizedBox(
      height: el(40),
      child: ElResizablePanelGroup(
        panels: <ElResizablePanel>[
          ElResizablePanel(
            defaultSize: 50,
            minSize: 32,
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: theme.border),
                color: theme.muted.withAlpha(32),
              ),
              child: Padding(
                padding: EdgeInsets.all(el(3)),
                child: ElText('Left panel: drag to resize', ElType.body),
              ),
            ),
          ),
          ElResizablePanel(
            defaultSize: 50,
            minSize: 32,
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: theme.border),
                color: theme.background,
              ),
              child: Padding(
                padding: EdgeInsets.all(el(3)),
                child: ElText('Right panel', ElType.body),
              ),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _install() => ElSection(
    id: 'install',
    title: 'Installation',
    description:
        '`elattar add resizable` installs the component and its declared '
        'dependency closure.',
    child: DocsInstallFacts(
      title: 'Installation facts',
      facts: <DocsInstallFact>[
        const DocsInstallFact(
          label: 'Registry item',
          value: 'registry/components/resizable.json',
          description:
              'Shipped and resolved by `elattar add resizable`. This is a '
              'source-only component today.',
        ),
        const DocsInstallFact(
          label: 'Destination',
          value: 'lib/components/ui/resizable.dart',
          description: 'Where a manual copy of the source belongs.',
        ),
        const DocsInstallFact(
          label: 'Dependencies',
          value: 'source-foundation',
          description:
              'foundation/spacing.dart and foundation/theme.dart for the '
              'seam colour, plus package:flutter/services.dart for the '
              'arrow/Home/End key handling.',
        ),
        const DocsInstallFact(
          label: 'Platforms',
          value: 'Android, iOS, Web, macOS, Windows, Linux',
          description:
              'Pure widget composition: no platform-conditional code. The '
              'resize cursor (SystemMouseCursors.resizeLeftRight) only '
              'shows on a platform with a mouse.',
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
    description: 'ElResizablePanelGroup with two panels.',
    child: ElPanel(
      label: 'DART',
      note: 'TWO-PANEL LAYOUT',
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
      label: 'Resizable',
      child: DocsSelectableCodeBlock(code: _compositionCode),
    ),
  );

  Widget _handle(ElThemeData theme) => ElSection(
    id: 'handle',
    title: 'Handle',
    description:
        'withHandle draws a 4×24 grip on the separator, true by default. '
        'Setting it to false leaves the hairline draggable with no '
        'visible affordance: the 24px grab strip still answers the '
        'pointer either way.',
    child: DocsCodeExample(
      title: 'Handle on and off',
      preview: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: el(6),
        children: <Widget>[
          ElText('withHandle: true (default)', ElType.label),
          SizedBox(height: el(2)),
          SizedBox(
            height: el(20),
            child: ElResizablePanelGroup(
              panels: <ElResizablePanel>[
                ElResizablePanel(
                  defaultSize: 50,
                  minSize: 32,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(color: theme.border),
                    ),
                    child: Center(child: ElText('Left', ElType.small)),
                  ),
                ),
                ElResizablePanel(
                  defaultSize: 50,
                  minSize: 32,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(color: theme.border),
                    ),
                    child: Center(child: ElText('Right', ElType.small)),
                  ),
                ),
              ],
            ),
          ),
          ElText('withHandle: false', ElType.label),
          SizedBox(height: el(2)),
          SizedBox(
            height: el(20),
            child: ElResizablePanelGroup(
              withHandle: false,
              panels: <ElResizablePanel>[
                ElResizablePanel(
                  defaultSize: 50,
                  minSize: 32,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(color: theme.border),
                    ),
                    child: Center(child: ElText('Left', ElType.small)),
                  ),
                ),
                ElResizablePanel(
                  defaultSize: 50,
                  minSize: 32,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(color: theme.border),
                    ),
                    child: Center(child: ElText('Right', ElType.small)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(path: 'resizable_handle.dart', code: _handleCode),
      ],
    ),
  );

  Widget _rtl(ElThemeData theme) => ElSection(
    id: 'rtl',
    title: 'RTL',
    description:
        'The same two-panel group read right-to-left under a '
        'Directionality. Nothing in ElResizablePanelGroup mirrors by '
        'hand: the Row it lays panels into reverses child order '
        'automatically, so the first panel declared renders on the '
        'reading-start (here, physical right) side.',
    child: DocsCodeExample(
      title: 'Right-to-left resizable panels',
      preview: Directionality(
        textDirection: TextDirection.rtl,
        child: SizedBox(
          height: el(20),
          child: ElResizablePanelGroup(
            panels: <ElResizablePanel>[
              ElResizablePanel(
                defaultSize: 50,
                minSize: 32,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.border),
                  ),
                  child: Center(child: ElText('أول', ElType.small)),
                ),
              ),
              ElResizablePanel(
                defaultSize: 50,
                minSize: 32,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.border),
                  ),
                  child: Center(child: ElText('ثاني', ElType.small)),
                ),
              ),
            ],
          ),
        ),
      ),
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(path: 'rtl_resizable.dart', code: _rtlResizableCode),
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
          title: 'ElResizablePanelGroup',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'panels',
              type: 'List<ElResizablePanel>',
              description: 'Required. The panels to arrange.',
            ),
            DocsApiFact(
              name: 'withHandle',
              type: 'bool',
              description:
                  'Defaults to true. Draws a visible 4×24 grip on the '
                  'separator.',
            ),
            DocsApiFact(
              name: 'minHeight',
              type: 'double?',
              description: 'A minimum height for the entire group.',
            ),
          ],
        ),
        SizedBox(height: el(6)),
        const DocsApiTable(
          title: 'ElResizablePanel',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'child',
              type: 'Widget',
              description: 'Required. The panel\'s content.',
            ),
            DocsApiFact(
              name: 'defaultSize',
              type: 'double',
              description:
                  'Required. A flex-grow weight, not a percentage. Only '
                  'the ratio between panels matters.',
            ),
            DocsApiFact(
              name: 'minSize',
              type: 'double',
              description:
                  'Defaults to 0. The minimum width in pixels that this '
                  'panel can be dragged to.',
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
        'ElResizablePanelGroup handles drag and keyboard on its '
        'separator.',
    child: const DocsStateMatrix(
      facts: <DocsStateFact>[
        DocsStateFact(
          state: 'Rest',
          treatment: 'Separator at rest colour (theme.border).',
          userSignal: 'Plain hairline appearance.',
        ),
        DocsStateFact(
          state: 'Hover',
          treatment:
              'Separator cursor changes to resize-left-right on pointer '
              'over the 24px grab strip.',
          userSignal: 'Drag affordance shown, on a platform with a mouse.',
        ),
        DocsStateFact(
          state: 'Drag',
          treatment:
              'Live resize: panels move as you drag, clamped to minSize '
              'floors. Sampled every frame at exactly the pointer\'s '
              'delta, no easing, no commit-on-release.',
          userSignal: 'Smooth, 1:1 drag feedback.',
        ),
        DocsStateFact(
          state: 'Focus',
          treatment:
              'The separator: tabIndex=0, accepts arrow keys and '
              'Home/End. No visible focus ring.',
          userSignal: 'Keyboard: arrow keys ±5%, Home/End snap to min/max.',
        ),
        DocsStateFact(
          state: 'Disabled / Loading / Selected',
          treatment:
              'N/A: the group itself has no such state. Content inside '
              'each panel manages its own states.',
          userSignal: 'Refer to each panel\'s own content.',
        ),
        DocsStateFact(
          state: 'Reduced motion',
          treatment:
              'N/A: no animations. The drag is live and unanimated by '
              'design, not gated by elAnimationDuration.',
          userSignal: 'No motion to still.',
        ),
      ],
    ),
  );

  Widget _accessibility(ElThemeData theme) => ElSection(
    id: 'accessibility',
    title: 'Accessibility',
    child: _bullets(theme, <String>[
      'The separator: tabIndex=0 makes it focusable. Keyboard control: '
          'arrow keys move 5%, Home goes to the minimum, End to the '
          'maximum. The separator announces nothing on its own; panels '
          'announce through their content.',
      'Touch target: the drag strip is 24px wide, centred on the 1px '
          'separator (wider than the reference\'s 4px, a deliberate '
          'divergence for pointer-only use — see resizable.dart\'s own '
          'class doc).',
      'Non-colour signal: the resize cursor on the separator is the only '
          'drag affordance; the seam itself is a plain theme.border '
          'hairline.',
      'Known platform difference: SystemMouseCursors.resizeLeftRight on '
          'hover is not available on touch, where the cursor is invisible '
          'but drag still works.',
    ]),
  );

  Widget _responsive(ElThemeData theme) => ElSection(
    id: 'responsive',
    title: 'Responsive',
    child: _bullets(theme, <String>[
      'Renders the same separator at 390px and 1440px: the separator is '
          'always 1px. Panel widths and the minSize constraint are in '
          'pixels and need explicit design on narrow screens.',
      'Never overflows: the group redistributes weights when dragged '
          'rather than growing past its own constraints.',
      'Platform-agnostic: no platform-branching code beyond the cursor '
          'shown on hover.',
    ]),
  );

  Widget _dependencies(ElThemeData theme) => ElSection(
    id: 'dependencies',
    title: 'Dependencies',
    child: _bullets(theme, <String>[
      'File: lib/src/components/resizable.dart (one file, includes the '
          'private _Seam and _GrabStrip widgets).',
      'Foundation imports: foundation/spacing.dart (el(), ElWidths, '
          'ElRadii), foundation/theme.dart (ElThemeData).',
      'Flutter imports: package:flutter/gestures.dart (DragStartBehavior), '
          'package:flutter/services.dart (LogicalKeyboardKey).',
      'Scope import: theme_scope.dart (ElTheme).',
      'Uses LayoutBuilder and the Flex algorithm to redistribute space on '
          'drag. No external resizing library is called: it is '
          'self-contained.',
      'Status: a stable primitive, installable through `elattar add resizable` (see '
          'Installation). Platforms: Android, iOS, Web, macOS, Windows, '
          'Linux.',
    ]),
  );

  Widget _theming(ElThemeData theme) => ElSection(
    id: 'theming',
    title: 'Theming',
    child: _bullets(theme, <String>[
      'The separator is theme.border, 1px. No state colours: hover adds '
          'a cursor, not a visual change. The grip is theme.border too, '
          '4px wide and 24px tall.',
      'Reads from the live theme: flipping ElThemeController updates the '
          'separator colour immediately.',
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
          value: resizableDoc.sourcePath,
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
          value: 'example/test/components_docs/resizable_test.dart',
          description:
              'Covers this page: the API tables, live specimens, drag '
              'behaviour, and theme coverage.',
        ),
        const DocsInstallFact(
          label: 'Edit these docs',
          value: 'example/lib/components_docs/resizable/page.dart',
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

const String _usageCode = '''ElResizablePanelGroup(
  withHandle: true,
  panels: <ElResizablePanel>[
    ElResizablePanel(
      defaultSize: 40,
      minSize: 32,
      child: Container(child: Text('Left')),
    ),
    ElResizablePanel(
      defaultSize: 60,
      minSize: 48,
      child: Container(child: Text('Right')),
    ),
  ],
)''';

const String _compositionCode = '''// LayoutBuilder
//  Stack
//   Row: one SizedBox(width: weight%) per panel, a 1px _Seam between
//        every adjacent pair
//   _GrabStrip (per seam): a 24px hit strip, hoisted to the group's own
//              Stack so it is never clipped by the 1px seam it straddles.
//              tabIndex=0, arrow keys, Home/End.
//    _Seam: the 1px hairline, plus a 4×24 grip when withHandle is true''';

const String _handleCode = '''ElResizablePanelGroup(
  withHandle: false, // no visible grip, still draggable
  panels: <ElResizablePanel>[
    ElResizablePanel(defaultSize: 50, minSize: 32, child: left),
    ElResizablePanel(defaultSize: 50, minSize: 32, child: right),
  ],
)''';

const String _rtlResizableCode = '''Directionality(
  textDirection: TextDirection.rtl,
  child: ElResizablePanelGroup(
    panels: <ElResizablePanel>[
      ElResizablePanel(defaultSize: 50, minSize: 32, child: first),
      ElResizablePanel(defaultSize: 50, minSize: 32, child: second),
    ],
  ),
)''';
