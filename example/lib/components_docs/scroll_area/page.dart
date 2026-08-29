/// Public documentation page for the `scroll_area` component.
///
/// **Re-housed onto the kit.** This page used to hand-compose `Section`
/// panels reshaped to mirror shadcn's own flat section list (Installation,
/// Usage, Composition, Horizontal, RTL, API Reference — fetched fresh from
/// https://ui.shadcn.com/docs/components/base/scroll-area); it now declares
/// a `ComponentDocSpec` (`example/lib/docs/component_doc_page.dart`) and
/// hands it to `ComponentDocPage`, the same shape `button` and `field`
/// established. Every specimen widget and every code string below is the
/// same one the hand-composed page carried; only where it lives changed,
/// plus the top-of-page live demo, which is now its own `Preview`
/// `ShowcaseSection` with a code toggle rather than a headless
/// `DocsCodeExample`.
///
/// **Corrected, not just moved.** `meta.dart` used to claim this entry was
/// "not wired into `catalog.dart`" and that [dependencies] was "left empty."
/// Both were false: `catalog.dart`'s `componentDocs` list already carries
/// `scrollAreaDoc`, and `registry/components/scroll-area.json` (hyphenated)
/// exists and lists exactly one registry dependency, `source-foundation`,
/// which [dependencies] already named. See `meta.dart` for the correction.
///
/// **Split off `resizable` and `aspect_ratio`.** This route used to carry
/// `ScrollArea`, `ResizablePanelGroup`, and `AspectRatio` on one page;
/// both siblings now have their own routes:
/// `example/lib/components_docs/resizable/` and `.../aspect_ratio/`. This
/// page documents `ScrollArea` and `ScrollAreaBehavior` only. The three
/// still share one small sidebar family (`_sidebar` below), unchanged by
/// the kit re-housing.
///
/// New: a Keyboard disclosure, between Accessibility and Responsive — the
/// "enclosing Scrollable still answers arrow keys" fact the old
/// Accessibility section folded in is moved there, read off the same
/// source (`lib/src/components/ui/scroll_area.dart` wires no `Focus` node and
/// no key handling of its own anywhere).
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

final ComponentDocSpec scrollAreaDocSpec = ComponentDocSpec(
  name: 'scroll-area',
  title: scrollAreaDoc.title,
  description: scrollAreaDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description: 'A scroll area with a hover-visible vertical scrollbar.',
      specimen: _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
      minHeight: space(160),
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'scroll_area has a real registry manifest, `elattar add '
          'scroll-area` installs lib/src/components/ui/scroll_area.dart and '
          'resolves source-foundation automatically. The Manual tab is '
          'for a project not using the CLI.',
      command: scrollAreaDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/scroll_area.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/ui/scroll_area.dart's generated "
              '@ui/scroll_area.dart payload into components/ui.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated scroll_area source here when using '
              'manual mode.',
        ),
        DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so ScrollArea and '
              'ScrollAreaBehavior are reachable the same way the CLI '
              'path already makes them.',
          code: "export 'scroll_area.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description: 'ScrollArea wrapping a list of items.',
      code: _usageScrollCode,
    ),
    SnippetSection(
      id: 'composition',
      title: 'Composition',
      description:
          "What the constructor assembles internally: the shape read off "
          "the reference's own primitives in the source file's doc "
          'comment, not a live specimen: there is nothing to toggle a '
          'view on beyond the specimens below.',
      code: _scrollAreaCompositionCode,
    ),
    ShowcaseSection(
      id: 'horizontal',
      title: 'Horizontal scrolling',
      description:
          'horizontalBar: true enables the horizontal axis. Without it, '
          'horizontal overflow is clipped (overflow-x: hidden), which is '
          'ScrollArea\'s default: the wrapper only ever renders one '
          'vertical rail unless asked for the other.',
      specimen: _HorizontalSpecimen(),
      code: _horizontalScrollCode,
      label: 'Horizontal scrolling specimen view',
    ),
    ShowcaseSection(
      id: 'rtl',
      title: 'RTL',
      description:
          'The one honest divergence in this component: the rail is '
          'placed with a literal right: 0, not a directional end offset, '
          'so it stays on the physical right edge under a '
          'Directionality.rtl ambient direction instead of moving to the '
          'reading-start edge. Content inside the viewport still reads in '
          'whichever direction its own text sets.',
      specimen: _RtlSpecimen(),
      code: _rtlScrollCode,
      label: 'RTL specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      children: const <DocsTocEntry>[
        DocsTocEntry(title: 'ScrollArea', anchor: 'api-elscrollarea'),
        DocsTocEntry(
          title: 'ScrollAreaBehavior',
          anchor: 'api-elscrollareabehavior',
        ),
      ],
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'ScrollArea shows and hides the scrollbar; nothing else '
          'about it changes state.',
      child: const DocsStateMatrix(facts: _stateFacts),
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
          'scroll_area.dart wires no Focus node and no key handling of '
          'its own anywhere — every fact here is about what the '
          'enclosing Scrollable does instead, read off '
          '_ScrollAreaState.build directly.',
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
                'Covers this page: the API tables, the live specimens, '
                'and theme coverage.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/scroll_area/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class ScrollAreaDocPage extends StatelessWidget {
  const ScrollAreaDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: scrollAreaDoc.route,
    intro: DocsPageIntro(
      title: scrollAreaDoc.title,
      description: scrollAreaDoc.description,
    ),
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Components'),
      BreadcrumbEntry.page('Scroll area'),
    ],
    sidebar: _sidebar,
    toc: scrollAreaDocSpec.toc,
    previous: const DocsPageLink(
      title: 'Resizable',
      route: '/components/resizable',
    ),
    next: const DocsPageLink(title: 'Layout', route: '/components/layout'),
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('scroll-area-doc-article'),
      child: ComponentDocPage(spec: scrollAreaDocSpec, header: false),
    ),
  );
}

/// `aspect_ratio`, `resizable`, and `scroll_area`'s own small family: see
/// the page's own library doc for the split this list survived unchanged.
const List<DocsSidebarEntry> _sidebar = <DocsSidebarEntry>[
  DocsSidebarEntry(title: 'Aspect ratio', route: '/components/aspect_ratio'),
  DocsSidebarEntry(title: 'Resizable', route: '/components/resizable'),
  DocsSidebarEntry(
    title: 'Scroll area',
    route: '/components/scroll_area',
    selected: true,
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
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: theme.border),
          borderRadius: BorderRadius.circular(Radii.lg),
        ),
        child: ScrollArea(
          key: const ValueKey<String>('scroll-area-doc-preview'),
          borderRadius: BorderRadius.circular(Radii.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for (int i = 0; i < 20; i++)
                Padding(
                  padding: EdgeInsets.all(space(2)),
                  child: StyledText(
                    'Item $i: scroll to reveal the scrollbar',
                    TextStyles.body,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HorizontalSpecimen extends StatelessWidget {
  const _HorizontalSpecimen();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return SizedBox(
      height: space(24),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: theme.border),
          borderRadius: BorderRadius.circular(Radii.lg),
        ),
        child: ScrollArea(
          borderRadius: BorderRadius.circular(Radii.lg),
          horizontalBar: true,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for (int i = 0; i < 6; i++)
                Padding(
                  padding: EdgeInsets.all(space(2)),
                  child: SizedBox(
                    width: space(20),
                    height: space(16),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(color: theme.border),
                        borderRadius: BorderRadius.circular(Radii.lg),
                      ),
                      child: Center(
                        child: StyledText('Card $i', TextStyles.small),
                      ),
                    ),
                  ),
                ),
            ],
          ),
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
        height: space(24),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: theme.border),
            borderRadius: BorderRadius.circular(Radii.lg),
          ),
          child: ScrollArea(
            borderRadius: BorderRadius.circular(Radii.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                for (int i = 0; i < 8; i++)
                  Padding(
                    padding: EdgeInsets.all(space(2)),
                    child: StyledText('عنصر $i', TextStyles.body),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/* ── Disclosure content ─────────────────────────────────────────────────── */

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsAnchor(
        id: 'api-elscrollarea',
        child: DocsApiTable(title: 'ScrollArea', facts: _scrollAreaFacts),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elscrollareabehavior',
        child: DocsApiTable(title: 'ScrollAreaBehavior', facts: _behaviorFacts),
      ),
    ],
  );
}

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'The scrollbar is not a focusable element. Scroll is available '
            'through standard wheel/trackpad gestures. Content inside '
            'maintains its own semantics and focus order.',
        'Non-colour signal: the scrollbar is theme.border, no semantic '
            'colour: it carries no status meaning to communicate.',
      ]);
}

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'No key handling of its own: scroll_area.dart wires no '
            'Focus.onKeyEvent anywhere, and the scrollbar rail '
            '(_RailState.build) is built from a bare GestureDetector, '
            'never a Focus node.',
        'The enclosing Scrollable still answers: PageUp/PageDown and the '
            'arrow keys scroll normally whenever focus lands inside an '
            'ScrollArea, because that behaviour belongs to Flutter\'s '
            'own Scrollable, not to anything scroll_area.dart adds or '
            'removes.',
        'Tab order: scroll_area.dart declares no FocusTraversalPolicy of '
            'its own. Tab and Shift+Tab walk whatever order the wrapped '
            'content already declares; the rail itself is never a stop.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Renders the same scroll container at 390px and 1440px. Width '
            'and height are driven by the surrounding layout. The '
            'scrollbar is always 10px wide (the rail) with a 7px thumb.',
        'Overflow: horizontalBar controls whether horizontal overflow '
            'scrolls or clips.',
        'Platform-agnostic: no platform-branching code.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      DocsInstallFacts(
        facts: <DocsInstallFact>[
          const DocsInstallFact(
            label: 'Registry item',
            value: 'scroll-area',
            description:
                'registry/components/scroll-area.json exists and is '
                'installable through the CLI today.',
          ),
          const DocsInstallFact(
            label: 'Destination',
            value: 'lib/components/ui/scroll_area.dart',
            description:
                'The same lib/components/ui/ target every component '
                'installs to.',
          ),
          DocsInstallFact(
            label: 'Dependencies',
            value: scrollAreaDoc.dependencies.join(', '),
            description:
                "The manifest's registryDependencies, resolved "
                'automatically by the registry client: '
                'foundation/spacing.dart (space()) and foundation/theme.dart '
                '(ThemeTokens). No effects, no colors, no shadows: just '
                'layout and theming.',
          ),
          const DocsInstallFact(
            label: 'Assets',
            value: 'none',
            description:
                'The scrollbar thumb is a DecoratedBox with '
                'BorderRadius.circular: no image, font, or shader asset.',
          ),
          const DocsInstallFact(
            label: 'Platforms',
            value: 'Android, iOS, Web, macOS, Windows, Linux',
            description:
                'Pure widget composition: no platform-conditional code.',
          ),
          const DocsInstallFact(
            label: 'Verified',
            value: 'docs specimen only',
            description:
                "This page's live specimens. No dedicated package-level "
                'unit tests.',
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
        'The scrollbar thumb is theme.border at rest. No hover state: '
            'the rail is always present when visible, the thumb just '
            'moves.',
        'Reads from the live theme: flipping ThemeController updates '
            'the scrollbar colour immediately.',
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

const String _previewCode = '''ScrollArea(
  borderRadius: BorderRadius.circular(Radii.lg),
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      for (var i = 0; i < 20; i++)
        Padding(
          padding: EdgeInsets.all(space(2)),
          child: Text('Item \$i: scroll to reveal the scrollbar'),
        ),
    ],
  ),
)''';

const String _usageScrollCode = '''ScrollArea(
  borderRadius: BorderRadius.circular(Radii.lg),
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: items.map((item) {
      return Padding(
        padding: EdgeInsets.all(space(2)),
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

const String _horizontalScrollCode = '''ScrollArea(
  borderRadius: BorderRadius.circular(Radii.lg),
  horizontalBar: true,
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: cards,
  ),
)''';

const String _rtlScrollCode = '''Directionality(
  textDirection: TextDirection.rtl,
  child: ScrollArea(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: items,
    ),
  ),
)''';

const List<DocsApiFact> _scrollAreaFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'child',
    type: 'Widget',
    description: 'Required. The content to scroll.',
  ),
  DocsApiFact(
    name: 'borderRadius',
    type: 'BorderRadius?',
    description:
        "The viewport's inner corner radius. The scrollbar respects "
        'this.',
  ),
  DocsApiFact(
    name: 'horizontalBar',
    type: 'bool',
    description:
        'Defaults to false. Without it, horizontal overflow is clipped '
        '(overflow-x: hidden).',
  ),
  DocsApiFact(
    name: 'controller',
    type: 'ScrollController?',
    description: 'Drives the vertical scroll from outside.',
  ),
];

const List<DocsApiFact> _behaviorFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'ScrollAreaBehavior',
    type: 'class',
    description:
        'A ScrollBehavior for nested scroll views. Suppresses overscroll '
        'and platform scrollbars. Use `ScrollConfiguration(behavior: '
        'ScrollAreaBehavior(), child: ScrollArea(...))` when nesting.',
  ),
];

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Rest',
    treatment: 'No scrollbar visible.',
    userSignal: 'Plain appearance.',
  ),
  DocsStateFact(
    state: 'Hover',
    treatment:
        'Scrollbar fades in on pointerenter. Stays visible for all '
        'gestures until pointerleave starts the 600ms hide delay.',
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
        'N/A: the scroll area itself has no such state. Content inside '
        'manages its own states, and the scrollbar is not a focusable '
        'element.',
    userSignal: "Refer to the content's own state handling.",
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment:
        'N/A: no animations. The scrollbar\'s 600ms hide delay is not a '
        'motion token and does not respond to prefers-reduced-motion.',
    userSignal: 'No motion to still.',
  ),
];
