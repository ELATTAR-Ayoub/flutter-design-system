/// Public documentation page for the `scroll_area` component family: THREE
/// components on one page.
///
/// `DsScrollArea` mirrors `https://ui.shadcn.com/docs/components/base/scroll-area`,
/// `DsResizablePanelGroup` mirrors
/// `https://ui.shadcn.com/docs/components/base/resizable`, and `DsAspectRatio`
/// mirrors `https://ui.shadcn.com/docs/components/base/aspect-ratio`, each
/// section for section. A live demo renders ahead of any heading, the same as
/// the reference's own top-of-page preview: no Overview, Status, or Preview
/// heading precedes Installation. Then Installation, Usage, and Composition
/// are shared, single sections (each of the three carries its own facts,
/// usage panel, or composition tree inside), followed by each component's own
/// sections prefixed with its name, following the same
/// `<Component>: <Section>` convention `navigation_menu/page.dart` uses for
/// its own four-component merge. Resizable: Vertical has no counterpart here:
/// `DsResizablePanelGroup` lays panels out in a `Row` with no orientation
/// parameter (see the Resizable: Vertical note in the report). API Reference
/// follows, one table per class. States, Accessibility, Responsive,
/// Dependencies, Theming, and Source are this package's own six sections,
/// added after API Reference, named exactly that with no extra words.
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
    breadcrumbs: const <DsBreadcrumbEntry>[
      DsBreadcrumbEntry.link('Components'),
      DsBreadcrumbEntry.page('Scroll area'),
    ],
    sidebar: _sidebar,
    toc: const <DocsTocEntry>[
      DocsTocEntry(title: 'Installation', anchor: 'install'),
      DocsTocEntry(title: 'Usage', anchor: 'usage'),
      DocsTocEntry(title: 'Composition', anchor: 'composition'),
      DocsTocEntry(
        title: 'Scroll area: Horizontal scrolling',
        anchor: 'scroll-area-horizontal',
      ),
      DocsTocEntry(title: 'Scroll area: RTL', anchor: 'scroll-area-rtl'),
      DocsTocEntry(title: 'Resizable: Handle', anchor: 'resizable-handle'),
      DocsTocEntry(title: 'Resizable: RTL', anchor: 'resizable-rtl'),
      DocsTocEntry(title: 'Aspect ratio: Square', anchor: 'aspect-square'),
      DocsTocEntry(title: 'Aspect ratio: Portrait', anchor: 'aspect-portrait'),
      DocsTocEntry(title: 'Aspect ratio: RTL', anchor: 'aspect-rtl'),
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
    next: const DocsPageLink(title: 'Layout', route: '/components/layout'),
    onNavigate: onNavigate,
    child: const _ArticleContent(),
  );
}

const List<DocsSidebarEntry> _sidebar = <DocsSidebarEntry>[
  DocsSidebarEntry(title: 'Aspect ratio', route: '/components/aspect_ratio'),
  DocsSidebarEntry(title: 'Resizable', route: '/components/resizable'),
  DocsSidebarEntry(
    title: 'Scroll area',
    route: '/components/scroll_area',
    selected: true,
  ),
];

class _ArticleContent extends StatefulWidget {
  const _ArticleContent();

  @override
  State<_ArticleContent> createState() => _ArticleContentState();
}

class _ArticleContentState extends State<_ArticleContent> {
  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Column(
      key: const ValueKey<String>('scroll-area-doc-article'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        // The live demo, ahead of any heading: the same shape the reference
        // pages themselves open with. No DsSection wraps it, so it carries no
        // Overview/Status/Preview heading of its own before Installation.
        _liveDemo(theme),
        SizedBox(height: ds(8)),
        _install(),
        _usage(),
        _composition(),
        _scrollAreaHorizontal(theme),
        _scrollAreaRtl(theme),
        _resizableHandle(theme),
        _resizableRtl(theme),
        _aspectSquare(theme),
        _aspectPortrait(theme),
        _aspectRtl(theme),
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

  Widget _liveDemo(DsThemeData theme) => DocsCodeExample(
    title: 'Scroll area family specimens',
    description:
        'A scroll area with vertical scrollbar, a two-panel resizable '
        'layout, and an aspect-ratio-locked card.',
    preview: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: ds(6),
      children: <Widget>[
        DsText('Scroll area with hover scrollbar', DsType.label),
        SizedBox(height: ds(3)),
        SizedBox(
          height: ds(40),
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: theme.border),
              borderRadius: BorderRadius.circular(DsRadii.lg),
            ),
            child: DsScrollArea(
              key: const ValueKey<String>('scroll-area-doc-preview'),
              borderRadius: BorderRadius.circular(DsRadii.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  for (int i = 0; i < 20; i++)
                    Padding(
                      padding: EdgeInsets.all(ds(2)),
                      child: DsText(
                        'Item $i: scroll to reveal the scrollbar',
                        DsType.body,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: ds(4)),
        DsText('Resizable panel group', DsType.label),
        SizedBox(height: ds(3)),
        SizedBox(
          height: ds(40),
          child: DsResizablePanelGroup(
            panels: <DsResizablePanel>[
              DsResizablePanel(
                defaultSize: 50,
                minSize: 32,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.border),
                    color: theme.muted.withAlpha(32),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(ds(3)),
                    child: DsText('Left panel: drag to resize', DsType.body),
                  ),
                ),
              ),
              DsResizablePanel(
                defaultSize: 50,
                minSize: 32,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.border),
                    color: theme.background,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(ds(3)),
                    child: DsText('Right panel', DsType.body),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: ds(4)),
        DsText('Aspect ratio box', DsType.label),
        SizedBox(height: ds(3)),
        SizedBox(
          width: ds(40),
          child: DsAspectRatio(
            ratio: 4 / 3,
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: theme.border),
                color: theme.muted.withAlpha(32),
                borderRadius: BorderRadius.circular(DsRadii.lg),
              ),
              child: Center(child: DsText('4:3 ratio', DsType.small)),
            ),
          ),
        ),
      ],
    ),
  );

  Widget _install() => DsSection(
    id: 'install',
    title: 'Installation',
    description:
        'None of the three components have registry manifests yet, '
        'install by copying the source files manually.',
    child: DocsInstallFacts(
      title: 'Installation facts',
      facts: <DocsInstallFact>[
        const DocsInstallFact(
          label: 'Scroll area',
          value: 'Not available',
          description: 'No registry manifest exists. Copy the source manually.',
        ),
        const DocsInstallFact(
          label: 'Resizable',
          value: 'Not available',
          description: 'No registry manifest exists. Copy the source manually.',
        ),
        const DocsInstallFact(
          label: 'Aspect ratio',
          value: 'Not available',
          description: 'No registry manifest exists. Copy the source manually.',
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
              'This page\'s live preview. No dedicated package-level unit '
              'tests.',
        ),
      ],
    ),
  );

  Widget _usage() => DsSection(
    id: 'usage',
    title: 'Usage',
    description:
        'DsScrollArea with a list, DsResizablePanelGroup with two '
        'panels, and DsAspectRatio for a locked box.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DsPanel(
          label: 'DART',
          note: 'DsScrollArea WITH CONTENT',
          child: DocsSelectableCodeBlock(code: _usageScrollCode),
        ),
        SizedBox(height: ds(5)),
        DsPanel(
          label: 'DART',
          note: 'DsResizablePanelGroup TWO-PANEL LAYOUT',
          child: DocsSelectableCodeBlock(code: _usageResizableCode),
        ),
        SizedBox(height: ds(5)),
        DsPanel(
          label: 'DART',
          note: 'DsAspectRatio LOCKED BOX',
          child: DocsSelectableCodeBlock(code: _usageAspectCode),
        ),
      ],
    ),
  );

  Widget _composition() => DsSection(
    id: 'composition',
    title: 'Composition',
    description:
        'What each constructor assembles internally, one tree per '
        'component: the shape read off the reference\'s own primitives in '
        'each source file\'s doc comment.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DsPanel(
          label: 'Scroll area',
          child: DocsSelectableCodeBlock(code: _scrollAreaCompositionCode),
        ),
        SizedBox(height: ds(5)),
        DsPanel(
          label: 'Resizable',
          child: DocsSelectableCodeBlock(code: _resizableCompositionCode),
        ),
        SizedBox(height: ds(5)),
        DsPanel(
          label: 'Aspect ratio',
          child: DocsSelectableCodeBlock(code: _aspectRatioCompositionCode),
        ),
      ],
    ),
  );

  Widget _scrollAreaHorizontal(DsThemeData theme) => DsSection(
    id: 'scroll-area-horizontal',
    title: 'Scroll area: Horizontal scrolling',
    description:
        'horizontalBar: true enables the horizontal axis. Without it, '
        'horizontal overflow is clipped (overflow-x: hidden), which is '
        'DsScrollArea\'s default: the wrapper only ever renders one '
        'vertical rail unless asked for the other.',
    child: DocsCodeExample(
      title: 'Horizontal card rail',
      preview: SizedBox(
        height: ds(24),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: theme.border),
            borderRadius: BorderRadius.circular(DsRadii.lg),
          ),
          child: DsScrollArea(
            borderRadius: BorderRadius.circular(DsRadii.lg),
            horizontalBar: true,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                for (int i = 0; i < 6; i++)
                  Padding(
                    padding: EdgeInsets.all(ds(2)),
                    child: SizedBox(
                      width: ds(20),
                      height: ds(16),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border.all(color: theme.border),
                          borderRadius: BorderRadius.circular(DsRadii.lg),
                        ),
                        child: Center(child: DsText('Card $i', DsType.small)),
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

  Widget _scrollAreaRtl(DsThemeData theme) => DsSection(
    id: 'scroll-area-rtl',
    title: 'Scroll area: RTL',
    description:
        'The one honest divergence in this family: the rail is placed '
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
          height: ds(24),
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: theme.border),
              borderRadius: BorderRadius.circular(DsRadii.lg),
            ),
            child: DsScrollArea(
              borderRadius: BorderRadius.circular(DsRadii.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  for (int i = 0; i < 8; i++)
                    Padding(
                      padding: EdgeInsets.all(ds(2)),
                      child: DsText('عنصر $i', DsType.body),
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

  Widget _resizableHandle(DsThemeData theme) => DsSection(
    id: 'resizable-handle',
    title: 'Resizable: Handle',
    description:
        'withHandle draws a 4×24 grip on the separator, true by default. '
        'Setting it to false leaves the hairline draggable with no '
        'visible affordance: the 24px grab strip still answers the '
        'pointer either way.',
    child: DocsCodeExample(
      title: 'Handle on and off',
      preview: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: ds(6),
        children: <Widget>[
          DsText('withHandle: true (default)', DsType.label),
          SizedBox(height: ds(2)),
          SizedBox(
            height: ds(20),
            child: DsResizablePanelGroup(
              panels: <DsResizablePanel>[
                DsResizablePanel(
                  defaultSize: 50,
                  minSize: 32,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(color: theme.border),
                    ),
                    child: Center(child: DsText('Left', DsType.small)),
                  ),
                ),
                DsResizablePanel(
                  defaultSize: 50,
                  minSize: 32,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(color: theme.border),
                    ),
                    child: Center(child: DsText('Right', DsType.small)),
                  ),
                ),
              ],
            ),
          ),
          DsText('withHandle: false', DsType.label),
          SizedBox(height: ds(2)),
          SizedBox(
            height: ds(20),
            child: DsResizablePanelGroup(
              withHandle: false,
              panels: <DsResizablePanel>[
                DsResizablePanel(
                  defaultSize: 50,
                  minSize: 32,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(color: theme.border),
                    ),
                    child: Center(child: DsText('Left', DsType.small)),
                  ),
                ),
                DsResizablePanel(
                  defaultSize: 50,
                  minSize: 32,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(color: theme.border),
                    ),
                    child: Center(child: DsText('Right', DsType.small)),
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

  Widget _resizableRtl(DsThemeData theme) => DsSection(
    id: 'resizable-rtl',
    title: 'Resizable: RTL',
    description:
        'The same two-panel group read right-to-left under a '
        'Directionality. Nothing in DsResizablePanelGroup mirrors by '
        'hand: the Row it lays panels into reverses child order '
        'automatically, so the first panel declared renders on the '
        'reading-start (here, physical right) side.',
    child: DocsCodeExample(
      title: 'Right-to-left resizable panels',
      preview: Directionality(
        textDirection: TextDirection.rtl,
        child: SizedBox(
          height: ds(20),
          child: DsResizablePanelGroup(
            panels: <DsResizablePanel>[
              DsResizablePanel(
                defaultSize: 50,
                minSize: 32,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.border),
                  ),
                  child: Center(child: DsText('أول', DsType.small)),
                ),
              ),
              DsResizablePanel(
                defaultSize: 50,
                minSize: 32,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.border),
                  ),
                  child: Center(child: DsText('ثاني', DsType.small)),
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

  Widget _aspectSquare(DsThemeData theme) => DsSection(
    id: 'aspect-square',
    title: 'Aspect ratio: Square',
    description: 'ratio: 1 / 1 for an even box, whatever width it is given.',
    child: DocsCodeExample(
      title: 'Square box',
      preview: SizedBox(
        width: ds(30),
        child: DsAspectRatio(
          ratio: 1 / 1,
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: theme.border),
              color: theme.muted.withAlpha(32),
              borderRadius: BorderRadius.circular(DsRadii.lg),
            ),
            child: Center(child: DsText('1:1 ratio', DsType.small)),
          ),
        ),
      ),
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(path: 'square_aspect_ratio.dart', code: _squareCode),
      ],
    ),
  );

  Widget _aspectPortrait(DsThemeData theme) => DsSection(
    id: 'aspect-portrait',
    title: 'Aspect ratio: Portrait',
    description: 'ratio: 9 / 16 for a tall box, the inverse of a widescreen '
        'frame.',
    child: DocsCodeExample(
      title: 'Portrait box',
      preview: SizedBox(
        width: ds(20),
        child: DsAspectRatio(
          ratio: 9 / 16,
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: theme.border),
              color: theme.muted.withAlpha(32),
              borderRadius: BorderRadius.circular(DsRadii.lg),
            ),
            child: Center(child: DsText('9:16 ratio', DsType.small)),
          ),
        ),
      ),
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(path: 'portrait_aspect_ratio.dart', code: _portraitCode),
      ],
    ),
  );

  Widget _aspectRtl(DsThemeData theme) => DsSection(
    id: 'aspect-rtl',
    title: 'Aspect ratio: RTL',
    description:
        'DsAspectRatio has no observable difference under a '
        'Directionality.rtl ambient direction: the ratio box is centered '
        'in flow with no reading-direction-sensitive offset of its own. '
        'Content inside the child still reads in whichever direction its '
        'own text sets.',
    child: DocsCodeExample(
      title: 'Right-to-left aspect ratio',
      preview: Directionality(
        textDirection: TextDirection.rtl,
        child: SizedBox(
          width: ds(30),
          child: DsAspectRatio(
            ratio: 4 / 3,
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: theme.border),
                color: theme.muted.withAlpha(32),
                borderRadius: BorderRadius.circular(DsRadii.lg),
              ),
              child: Center(child: DsText('نسبة 4:3', DsType.small)),
            ),
          ),
        ),
      ),
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(path: 'rtl_aspect_ratio.dart', code: _rtlAspectCode),
      ],
    ),
  );

  Widget _api() => DsSection(
    id: 'api',
    title: 'API Reference',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const DocsApiTable(
          title: 'DsScrollArea',
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
        SizedBox(height: ds(6)),
        const DocsApiTable(
          title: 'DsScrollAreaBehavior',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'DsScrollAreaBehavior',
              type: 'class',
              description:
                  'A ScrollBehavior for nested scroll views. '
                  'Suppresses overscroll and platform scrollbars. Use '
                  '`ScrollConfiguration(behavior: DsScrollAreaBehavior(), '
                  'child: DsScrollArea(...))` when nesting.',
            ),
          ],
        ),
        SizedBox(height: ds(6)),
        const DocsApiTable(
          title: 'DsResizablePanelGroup',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'panels',
              type: 'List<DsResizablePanel>',
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
        SizedBox(height: ds(6)),
        const DocsApiTable(
          title: 'DsResizablePanel',
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
        SizedBox(height: ds(6)),
        const DocsApiTable(
          title: 'DsAspectRatio',
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
                  'The content box. The ratio box inside respects any '
                  'margin applied.',
            ),
            DocsApiFact(
              name: 'margin',
              type: 'EdgeInsets',
              description:
                  'Defaults to EdgeInsets.zero. Applied to the inner '
                  'box, shrinking it inside the aspect-locked slot.',
            ),
          ],
        ),
      ],
    ),
  );

  Widget _states() => DsSection(
    id: 'states',
    title: 'States',
    description:
        'DsScrollArea shows/hides the scrollbar. DsResizablePanelGroup '
        'handles drag and keyboard. DsAspectRatio is static.',
    child: const DocsStateMatrix(
      facts: <DocsStateFact>[
        DocsStateFact(
          state: 'Rest',
          treatment:
              'DsScrollArea: no scrollbar visible. DsResizablePanelGroup: '
              'separator at rest colour. DsAspectRatio: static.',
          userSignal: 'Plain appearance.',
        ),
        DocsStateFact(
          state: 'Hover',
          treatment:
              'DsScrollArea: scrollbar fades in on pointerenter. Stays '
              'visible for all gestures. DsResizablePanelGroup: separator '
              'cursor changes to resize-left-right on pointer over.',
          userSignal: 'Scrollbar appears. Drag affordance shown.',
        ),
        DocsStateFact(
          state: 'Drag',
          treatment:
              'DsScrollArea: thumb follows pointer 1:1, no easing. '
              'DsResizablePanelGroup: live resize, panels move as you drag, '
              'clamped to minSize floors.',
          userSignal: 'Smooth drag feedback.',
        ),
        DocsStateFact(
          state: 'Focus',
          treatment:
              'DsResizablePanelGroup separator: tabIndex=0, '
              'accepts arrow keys and Home/End. No visible focus ring.',
          userSignal:
              'Keyboard: arrow keys ±5%, Home/End snap to '
              'min/max.',
        ),
        DocsStateFact(
          state: 'Disabled / Loading / Selected',
          treatment:
              'N/A: the scroll area itself has no state beyond visible '
              'scrollbar. Content inside manages its own states.',
          userSignal: 'Refer to the content\'s own state handling.',
        ),
        DocsStateFact(
          state: 'Reduced motion',
          treatment:
              'N/A: no animations. Scrollbar hide (600ms) is not a '
              'motion token and does not respond to prefers-reduced-motion.',
          userSignal: 'No motion to still.',
        ),
      ],
    ),
  );

  Widget _accessibility(DsThemeData theme) => DsSection(
    id: 'accessibility',
    title: 'Accessibility',
    child: _bullets(theme, <String>[
      'DsScrollArea: the scrollbar is not a focusable element. Scroll is '
          'available through standard wheel/trackpad gestures. Content '
          'inside maintains its own semantics and focus order.',
      'DsResizablePanelGroup separator: tabIndex=0 makes it focusable. '
          'Keyboard control: arrow keys move 5%, Home goes to minimum, End '
          'to maximum. The separator announces nothing on its own; panels '
          'announce through their content.',
      'DsAspectRatio: purely structural. No semantics. Used to frame '
          'content that manages its own accessibility.',
      'Touch target: DsResizablePanelGroup drag strip is 24px wide, '
          'centered on the 1px separator (wider than the reference\'s 4px '
          'for pointer-only use).',
      'Non-colour signal: DsScrollArea scrollbar is theme.border: no '
          'semantic colour. Resize cursor on the separator is the only drag '
          'affordance.',
      'Known platform differences: DsResizablePanelGroup uses '
          'SystemMouseCursors.resizeLeftRight on hover: not available on '
          'touch, where the cursor is invisible but drag still works.',
    ]),
  );

  Widget _responsive(DsThemeData theme) => DsSection(
    id: 'responsive',
    title: 'Responsive',
    child: _bullets(theme, <String>[
      'DsScrollArea: renders the same scroll container at 390px and 1440px. '
          'Width and height are driven by the surrounding layout. The scrollbar '
          'is always 10px wide (the rail) with a 7px thumb.',
      'DsResizablePanelGroup: equally responsive. The separator is always 1px. '
          'Panel widths and the minSize constraint are in pixels and need '
          'explicit design on narrow screens.',
      'DsAspectRatio: locks to the ratio on every viewport. A 390px-wide box '
          'at 16:9 is 390 × 219. The ratio is device-agnostic.',
      'Overflow: DsScrollArea has a horizontalBar switch that controls '
          'whether horizontal overflow scrolls or clips. DsResizablePanelGroup '
          'never overflows: it redistributes when dragged. DsAspectRatio never '
          'overflows: it locks the box to the ratio.',
      'All three are platform-agnostic: no platform-branching code.',
    ]),
  );

  Widget _dependencies(DsThemeData theme) => DsSection(
    id: 'dependencies',
    title: 'Dependencies',
    child: _bullets(theme, <String>[
      'Files: lib/src/components/scroll_area.dart (377 lines), '
          'resizable.dart (379 lines), aspect_ratio.dart (68 lines). '
          'scroll_area.dart includes DsScrollAreaBehavior and private '
          'layout classes.',
      'Foundation imports: spacing.dart, theme.dart. No effects, no colors, '
          'no shadows: just layout and theming.',
      'Assets: none. Fonts: none. Shaders: none. The scrollbar thumb is a '
          'DecoratedBox with BorderRadius.circular.',
      'DsResizablePanelGroup: uses LayoutBuilder and the Flex algorithm to '
          'redistribute space on drag. No external resizing library is '
          'called: it is self-contained.',
      'Status: stable primitives, not yet registered in the CLI (see '
          'Installation). Platforms: Android, iOS, Web, macOS, Windows, '
          'Linux.',
    ]),
  );

  Widget _theming(DsThemeData theme) => DsSection(
    id: 'theming',
    title: 'Theming',
    child: _bullets(theme, <String>[
      'DsScrollArea: scrollbar thumb is theme.border (resting). No '
          'hover state: the rail is always present when visible, the thumb '
          'just moves.',
      'DsResizablePanelGroup: separator is theme.border (1px). No state '
          'colours: hover adds a cursor, not a visual change. The grip is '
          'theme.border, 4px wide and 24px tall.',
      'DsAspectRatio: purely structural, no colours of its own. Content '
          'paints.',
      'All three read from the live theme. Flipping DsThemeController '
          'updates the scrollbar and separator colours immediately.',
    ]),
  );

  Widget _source() => DsSection(
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
              'Covers this page: API tables, live specimens, and theme '
              'coverage for all three components.',
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

Widget _bullets(DsThemeData theme, List<String> lines) => ConstrainedBox(
  constraints: const BoxConstraints(maxWidth: DsWidths.prose),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      for (final String line in lines) ...<Widget>[
        DsText('•  $line', DsType.small, color: theme.mutedForeground),
        SizedBox(height: ds(2)),
      ],
    ],
  ),
);

const String _usageScrollCode = '''DsScrollArea(
  borderRadius: BorderRadius.circular(DsRadii.lg),
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: items.map((item) {
      return Padding(
        padding: EdgeInsets.all(ds(2)),
        child: Text(item),
      );
    }).toList(),
  ),
)''';

const String _usageResizableCode = '''DsResizablePanelGroup(
  withHandle: true,
  panels: <DsResizablePanel>[
    DsResizablePanel(
      defaultSize: 40,
      minSize: 32,
      child: Container(child: Text('Left')),
    ),
    DsResizablePanel(
      defaultSize: 60,
      minSize: 48,
      child: Container(child: Text('Right')),
    ),
  ],
)''';

const String _usageAspectCode = '''DsAspectRatio(
  ratio: 5 / 7,
  margin: EdgeInsets.all(ds(2)),
  child: DecoratedBox(
    decoration: BoxDecoration(
      border: Border.all(),
      borderRadius: BorderRadius.circular(DsRadii.lg),
    ),
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

const String _resizableCompositionCode =
    '''// LayoutBuilder
//  Stack
//   Row: one SizedBox(width: weight%) per panel, a 1px _Seam between
//        every adjacent pair
//   _GrabStrip (per seam): a 24px hit strip, hoisted to the group's own
//              Stack so it is never clipped by the 1px seam it straddles.
//              tabIndex=0, arrow keys, Home/End.
//    _Seam: the 1px hairline, plus a 4×24 grip when withHandle is true''';

const String _aspectRatioCompositionCode =
    '''// AspectRatio(aspectRatio: ratio)
//  Padding(margin) -- only when margin is non-zero
//   child: the caller's own box''';

const String _horizontalScrollCode = '''DsScrollArea(
  borderRadius: BorderRadius.circular(DsRadii.lg),
  horizontalBar: true,
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: cards,
  ),
)''';

const String _rtlScrollCode = '''Directionality(
  textDirection: TextDirection.rtl,
  child: DsScrollArea(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: items,
    ),
  ),
)''';

const String _handleCode = '''DsResizablePanelGroup(
  withHandle: false, // no visible grip, still draggable
  panels: <DsResizablePanel>[
    DsResizablePanel(defaultSize: 50, minSize: 32, child: left),
    DsResizablePanel(defaultSize: 50, minSize: 32, child: right),
  ],
)''';

const String _rtlResizableCode = '''Directionality(
  textDirection: TextDirection.rtl,
  child: DsResizablePanelGroup(
    panels: <DsResizablePanel>[
      DsResizablePanel(defaultSize: 50, minSize: 32, child: first),
      DsResizablePanel(defaultSize: 50, minSize: 32, child: second),
    ],
  ),
)''';

const String _squareCode = '''DsAspectRatio(
  ratio: 1 / 1,
  child: DecoratedBox(
    decoration: BoxDecoration(
      border: Border.all(),
      borderRadius: BorderRadius.circular(DsRadii.lg),
    ),
  ),
)''';

const String _portraitCode = '''DsAspectRatio(
  ratio: 9 / 16,
  child: DecoratedBox(
    decoration: BoxDecoration(
      border: Border.all(),
      borderRadius: BorderRadius.circular(DsRadii.lg),
    ),
  ),
)''';

const String _rtlAspectCode = '''Directionality(
  textDirection: TextDirection.rtl,
  child: DsAspectRatio(
    ratio: 4 / 3,
    child: DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(DsRadii.lg),
      ),
    ),
  ),
)''';
