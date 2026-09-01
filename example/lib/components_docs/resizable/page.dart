/// Public documentation page for the `resizable` component —
/// `lib/src/components/ui/resizable.dart`'s [ResizablePanelGroup] and
/// [ResizablePanel].
///
/// **Re-housed onto the kit.** This page used to hand-compose `Section`
/// panels (plus a manual `_sidebar` list standing in for the shared
/// `aspect_ratio` / `resizable` / `scroll_area` group, split out of that
/// route — see the original library note, preserved in git history); it
/// now declares a `ComponentDocSpec`
/// (`example/lib/docs/component_doc_page.dart`) and hands it to
/// `ComponentDocPage`, the shape `button` established. The hand-written
/// `_sidebar` list is dropped along with it: `DocsLayout` already
/// synthesizes its own sidebar from the shared catalog once neither
/// `sidebar` nor `sidebarGroups` is supplied.
///
/// **Reference shape**, mirrored from
/// `https://ui.shadcn.com/docs/components/base/resizable`'s own section
/// list: About, Installation, Usage, Composition, Vertical, Handle, RTL,
/// API Reference, Changelog. Every section title below drops the
/// redundant `Resizable: ` prefix the old shared-route page needed. A live
/// demo used to render ahead of any heading, the same as the reference's
/// own top-of-page preview; it is now `Preview`, this page's first
/// `ShowcaseSection`, so it finally owns a rail entry.
///
/// **Skipped, honestly**, unchanged from the original page's own ruling:
/// `About` and `Changelog` describe the upstream `react-resizable-panels`
/// package itself (its version, its own release notes) rather than a UI
/// affordance a Flutter port can show; there is nothing to mirror in
/// either. `Vertical` is skipped for a real reason, not an oversight:
/// [ResizablePanelGroup] takes no orientation parameter at all, its
/// `build` method always lays panels into a horizontal `Row`
/// (`resizable.dart`'s own `Row(crossAxisAlignment: ..., children: row)`),
/// so there is no vertical mode to demonstrate.
///
/// **Composition stays a `SnippetSection`.** It is the shape read off the
/// reference's own primitives in `resizable.dart`'s doc comment — a
/// structural sketch of what the constructor assembles internally
/// (`LayoutBuilder > Stack > Row + _GrabStrip`), not compilable Dart and
/// not a second live demo: Preview above already shows the real,
/// constructed thing.
///
/// New: a Keyboard disclosure, between Accessibility and Responsive, read
/// directly off `_GrabStripState._onKey` — the arrow/Home/End handling
/// used to live as prose folded into Accessibility and States; it gets
/// its own section now, matching the house shape.
///
/// No `registry/components/resizable.json` manifest exists yet: see the
/// Installation section for the shipped command and the honest statement
/// of that fact.
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

final ComponentDocSpec resizableDocSpec = ComponentDocSpec(
  name: 'resizable',
  title: resizableDoc.title,
  description: resizableDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'Two panels sharing a row, split by a draggable separator. Drag '
          'the seam, or Tab to it and use the arrow keys.',
      specimen: _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          '`elattar add resizable` installs the component and its '
          'declared dependency closure. No registry/components/'
          'resizable.json exists yet: copy lib/src/components/ui/'
          'resizable.dart manually until it does.',
      command: resizableDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/resizable.dart',
          title: '1. Copy the source',
          description:
              'Copy ${resizableDoc.sourcePath} into components/ui and '
              'keep its relative imports pointed at the same foundation '
              'files, plus package:flutter/services.dart and '
              'package:flutter/gestures.dart for the key and drag '
              'handling.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// No registry manifest yet: copy lib/src/components/ui/'
              'resizable.dart into lib/components/ui/ in your project.',
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description: 'ResizablePanelGroup with two panels.',
      code: _usageCode,
    ),
    SnippetSection(
      id: 'composition',
      title: 'Composition',
      description:
          'A structural sketch, not compilable source: what the '
          'constructor assembles internally, read off resizable.dart\'s '
          'own doc comment. There is nothing new to stage live here that '
          'Preview above does not already show.',
      code: _compositionCode,
    ),
    ShowcaseSection(
      id: 'handle',
      title: 'Handle',
      description:
          'withHandle draws a 4×24 grip on the separator, true by '
          'default. Setting it to false leaves the hairline draggable '
          'with no visible affordance: the 24px grab strip still answers '
          'the pointer either way.',
      specimen: _HandleSpecimen(),
      code: _handleCode,
      label: 'Handle specimen view',
    ),
    ShowcaseSection(
      id: 'rtl',
      title: 'RTL',
      description:
          'The same two-panel group read right-to-left under a '
          'Directionality. Nothing in ResizablePanelGroup mirrors by '
          'hand: the Row it lays panels into reverses child order '
          'automatically, so the first panel declared renders on the '
          'reading-start (here, physical right) side.',
      specimen: _RtlSpecimen(),
      code: _rtlResizableCode,
      label: 'RTL specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'ResizablePanelGroup handles drag and keyboard on its '
          'separator.',
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
      description:
          'Read directly off _GrabStripState._onKey '
          '(lib/src/components/ui/resizable.dart): every key it recognises, '
          'and what it ignores.',
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
            value: resizableDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'none yet',
            description:
                'No dedicated unit tests in the package test '
                'suite.',
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
    ),
  ],
);

class ResizableDocPage extends StatelessWidget {
  const ResizableDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: resizableDoc.route,
    intro: DocsPageIntro(
      title: resizableDoc.title,
      description: resizableDoc.description,
    ),
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Components'),
      BreadcrumbEntry.page('Resizable'),
    ],
    toc: resizableDocSpec.toc,
    previous: const DocsPageLink(
      title: 'Aspect ratio',
      route: '/components/aspect_ratio',
    ),
    next: const DocsPageLink(
      title: 'Scroll area',
      route: '/components/scroll_area',
    ),
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('resizable-doc-article'),
      child: ComponentDocPage(spec: resizableDocSpec, header: false),
    ),
  );
}

/* ── Disclosure content ─────────────────────────────────────────────────── */

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: const <Widget>[
      DocsApiTable(
        title: 'ResizablePanelGroup',
        facts: <DocsApiFact>[
          DocsApiFact(
            name: 'panels',
            type: 'List<ResizablePanel>',
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
      SizedBox(height: 24),
      DocsApiTable(
        title: 'ResizablePanel',
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
  );
}

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Semantic role: Semantics(container: true, label: \'Resize\') on '
            'the grab strip; the group and its panels add no Semantics '
            'node of their own, content inside each panel announces '
            'itself.',
        'Touch target: the drag strip is 24px wide, centred on the 1px '
            'separator (wider than the reference\'s 4px, a deliberate '
            'divergence for pointer-only use, see resizable.dart\'s own '
            'class doc).',
        'Non-colour signal: the resize cursor '
            '(SystemMouseCursors.resizeLeftRight) on the separator is the '
            'only drag affordance; the seam itself is a plain '
            'theme.border hairline.',
        'Known platform difference: the resize cursor on hover is not '
            'available on touch, where the cursor is invisible but drag '
            'still works.',
        'See Keyboard below for what the separator listens to, and what '
            'it ignores.',
      ]);
}

/// Read directly off `_GrabStripState._onKey`
/// (`lib/src/components/ui/resizable.dart`): the strip only inspects
/// `KeyDownEvent` and `KeyRepeatEvent`, and only four logical keys.
class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Focus: the grab strip carries tabIndex={0}\'s equivalent (a '
            'Focus widget with its own FocusNode, debugLabel '
            'resizableHandleFocusLabel), so Tab and Shift+Tab reach it '
            'in the surrounding page\'s own order.',
        'ArrowLeft / ArrowRight: move the separator by keyboardStep, five '
            'percentage points of the panel space, toward or away from '
            'the panel before the seam.',
        'Home: snaps the panel before the seam to its own minSize floor.',
        'End: snaps the panel before the seam to fill the space, down to '
            'the following panel\'s minSize floor.',
        'Every other key: ignored. _onKey only inspects KeyDownEvent and '
            'KeyRepeatEvent (a matching KeyUpEvent is not handled '
            'separately), and returns KeyEventResult.ignored for '
            'anything outside those four keys, so it keeps propagating.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Renders the same separator at 390px and 1440px: the separator '
            'is always 1px. Panel widths and the minSize constraint are '
            'in pixels and need explicit design on narrow screens.',
        'Never overflows: the group redistributes weights when dragged '
            'rather than growing past its own constraints.',
        'Platform-agnostic: no platform-branching code beyond the '
            'cursor shown on hover.',
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
            value: resizableDoc.sourcePath,
            description:
                'One file, includes the private _Seam and _GrabStrip '
                'widgets.',
          ),
          const DocsInstallFact(
            label: 'Foundation imports',
            value:
                'foundation/spacing.dart (space(), LayoutWidths, Radii), '
                'foundation/theme.dart (ThemeTokens)',
            description: 'Colour and geometry tokens only.',
          ),
          const DocsInstallFact(
            label: 'Flutter imports',
            value:
                'package:flutter/gestures.dart (DragStartBehavior), '
                'package:flutter/services.dart (LogicalKeyboardKey)',
            description:
                'For the drag start behavior and the '
                'arrow/Home/End key handling.',
          ),
          const DocsInstallFact(
            label: 'Scope import',
            value: 'theme_scope.dart (ThemeScope)',
            description: 'No other component or effect file is imported.',
          ),
          const DocsInstallFact(
            label: 'registryDependencies',
            value: 'source-foundation',
            description:
                'Resolved automatically by `elattar add resizable` — '
                'copied verbatim from the manifest.',
          ),
          const DocsInstallFact(
            label: 'Platforms',
            value: 'Android, iOS, Web, macOS, Windows, Linux',
            description:
                'Pure widget composition: no platform-conditional code. '
                'The resize cursor only shows on a platform with a '
                'mouse.',
          ),
          const DocsInstallFact(
            label: 'Verified',
            value: 'docs specimen only',
            description:
                'This page\'s live preview. No dedicated package-level '
                'unit tests and no registry fixture install exist yet.',
          ),
        ],
      ),
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
        'The separator is theme.border, 1px. No state colours: hover '
            'adds a cursor, not a visual change. The grip is theme.border '
            'too, 4px wide and 24px tall.',
        'Reads from the live theme: flipping ThemeController updates '
            'the separator colour immediately.',
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
    treatment: 'Separator at rest colour (theme.border).',
    userSignal: 'Plain hairline appearance.',
  ),
  DocsStateFact(
    state: 'Hover',
    treatment:
        'Separator cursor changes to resize-left-right on pointer over '
        'the 24px grab strip.',
    userSignal: 'Drag affordance shown, on a platform with a mouse.',
  ),
  DocsStateFact(
    state: 'Drag',
    treatment:
        'Live resize: panels move as you drag, clamped to minSize '
        'floors. Sampled every frame at exactly the pointer\'s delta, no '
        'easing, no commit-on-release.',
    userSignal: 'Smooth, 1:1 drag feedback.',
  ),
  DocsStateFact(
    state: 'Focus',
    treatment:
        'The separator accepts focus (tabIndex={0}\'s equivalent). '
        'No visible focus ring.',
    userSignal:
        'See Keyboard below for what a focused separator '
        'responds to.',
  ),
  DocsStateFact(
    state: 'Disabled / Loading / Selected',
    treatment:
        'N/A: the group itself has no such state. Content inside each '
        'panel manages its own states.',
    userSignal: 'Refer to each panel\'s own content.',
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment:
        'N/A: no animations. The drag is live and unanimated by design, '
        'not gated by effectiveMotionDuration.',
    userSignal: 'No motion to still.',
  ),
];

/* ── Showcase specimens ─────────────────────────────────────────────────── */

class _PreviewSpecimen extends StatelessWidget {
  const _PreviewSpecimen();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return SizedBox(
      height: space(40),
      child: ResizablePanelGroup(
        panels: <ResizablePanel>[
          ResizablePanel(
            defaultSize: 50,
            minSize: 32,
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: theme.border),
                color: theme.muted.withAlpha(32),
              ),
              child: Padding(
                padding: EdgeInsets.all(space(3)),
                child: StyledText(
                  'Left panel: drag to resize',
                  TextStyles.body,
                ),
              ),
            ),
          ),
          ResizablePanel(
            defaultSize: 50,
            minSize: 32,
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: theme.border),
                color: theme.background,
              ),
              child: Padding(
                padding: EdgeInsets.all(space(3)),
                child: StyledText('Right panel', TextStyles.body),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

const String _previewCode = '''
SizedBox(
  height: 160,
  child: ResizablePanelGroup(
    panels: [
      ResizablePanel(
        defaultSize: 50,
        minSize: 32,
        child: Container(child: const Text('Left panel: drag to resize')),
      ),
      ResizablePanel(
        defaultSize: 50,
        minSize: 32,
        child: Container(child: const Text('Right panel')),
      ),
    ],
  ),
)''';

const String _usageCode = '''ResizablePanelGroup(
  withHandle: true,
  panels: <ResizablePanel>[
    ResizablePanel(
      defaultSize: 40,
      minSize: 32,
      child: Container(child: Text('Left')),
    ),
    ResizablePanel(
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

class _HandleSpecimen extends StatelessWidget {
  const _HandleSpecimen();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    Widget group({required bool withHandle}) => SizedBox(
      height: space(20),
      child: ResizablePanelGroup(
        withHandle: withHandle,
        panels: <ResizablePanel>[
          ResizablePanel(
            defaultSize: 50,
            minSize: 32,
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: theme.border),
              ),
              child: Center(child: StyledText('Left', TextStyles.small)),
            ),
          ),
          ResizablePanel(
            defaultSize: 50,
            minSize: 32,
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: theme.border),
              ),
              child: Center(child: StyledText('Right', TextStyles.small)),
            ),
          ),
        ],
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        StyledText('withHandle: true (default)', TextStyles.small),
        SizedBox(height: space(2)),
        group(withHandle: true),
        SizedBox(height: space(6)),
        StyledText('withHandle: false', TextStyles.small),
        SizedBox(height: space(2)),
        group(withHandle: false),
      ],
    );
  }
}

const String _handleCode = '''ResizablePanelGroup(
  withHandle: false, // no visible grip, still draggable
  panels: <ResizablePanel>[
    ResizablePanel(defaultSize: 50, minSize: 32, child: left),
    ResizablePanel(defaultSize: 50, minSize: 32, child: right),
  ],
)''';

class _RtlSpecimen extends StatelessWidget {
  const _RtlSpecimen();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SizedBox(
        height: space(20),
        child: ResizablePanelGroup(
          panels: <ResizablePanel>[
            ResizablePanel(
              defaultSize: 50,
              minSize: 32,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: theme.border),
                ),
                child: Center(child: StyledText('أول', TextStyles.small)),
              ),
            ),
            ResizablePanel(
              defaultSize: 50,
              minSize: 32,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: theme.border),
                ),
                child: Center(child: StyledText('ثاني', TextStyles.small)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const String _rtlResizableCode = '''Directionality(
  textDirection: TextDirection.rtl,
  child: ResizablePanelGroup(
    panels: <ResizablePanel>[
      ResizablePanel(defaultSize: 50, minSize: 32, child: first),
      ResizablePanel(defaultSize: 50, minSize: 32, child: second),
    ],
  ),
)''';
