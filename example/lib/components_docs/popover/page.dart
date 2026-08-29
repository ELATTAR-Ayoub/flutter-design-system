/// Public documentation page for the `popover` component.
///
/// **Re-housed onto the kit.** This page used to hand-compose [Section]
/// panels; it now declares a [ComponentDocSpec]
/// (`example/lib/docs/component_doc_page.dart`) and hands it to
/// [ComponentDocPage], the same shape `button` and `field` established.
/// Every specimen widget and every code string below is the one the
/// hand-composed page carried; new in this pass: source code for the
/// Preview specimen (a live specimen with no quoted source before), live
/// specimens for Align and Variants (each a bare `DocsApiTable` before,
/// with no rendered popover at all), and a dedicated Keyboard disclosure
/// split out of the old combined Accessibility section.
///
/// `Popover` is the one primitive in this wave that is a positioning
/// engine as much as a component: [Select] and `HoverCard` both reuse its
/// placement math ([popoverPlacement]) and its paint ([PopoverSurface])
/// without mounting the widget itself, and nine other components —
/// `DropdownMenu`, `ContextMenu`, `Menubar`, `Menu`, the agent attach menu,
/// `Combobox`, `NativeSelect`, `Calendar`'s date picker, and
/// `NavigationMenu`: mount their popups through [Popover] directly. Both
/// facts are cited from the real source comments and are reflected in the
/// Composition and Dependencies sections below, not invented.
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

final ComponentDocSpec popoverDocSpec = ComponentDocSpec(
  name: 'popover',
  title: popoverDoc.title,
  description: popoverDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'Tap the trigger to open it; tap anywhere outside the popup, or '
          'press Escape once focus is inside it, to dismiss it.',
      specimen: _PopoverPreview(),
      code: _previewCode,
      label: 'Popover specimen',
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'popover already has a registry manifest: this installs '
          'lib/src/components/ui/popover.dart and its one dependency, '
          'source-foundation, resolved automatically.',
      command: popoverDoc.command,
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/popover.dart',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated popover source here when using '
              'manual mode.',
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'Popover reads open the way Radix reads its own open prop: '
          'the caller owns the boolean and reports it back on '
          'onDismiss. There is no controller with its own lifecycle to '
          'create or dispose. The three shapes below are the real ones '
          'this component ships for: a minimal share popover, a '
          'virtual-anchor context menu, and a non-modal barrier handoff.',
      code: '$_usageBasicCode\n\n$_usageAnchorPointCode\n\n$_usageNonModalCode',
    ),
    SnippetSection(
      id: 'composition',
      title: 'Composition',
      description:
          'shadcn splits Popover into Popover, PopoverTrigger, and '
          'PopoverContent. Popover is one widget instead: anchor is '
          'the trigger, rendered verbatim, and content is a builder that '
          'returns the popup, almost always wrapped in PopoverSurface '
          'for the shared fill, ring, and radius. The shape below is '
          "Combobox's own popup wiring, a real excerpt, not an "
          'invented one.',
      code: _compositionCode,
    ),
    ShowcaseSection(
      id: 'align',
      title: 'Align',
      description:
          "shadcn's own live demo for this section is a Start / Center / "
          'End tab switcher. Below are three independent popovers instead, '
          'one per PopoverAlign value, each with its own open state: how '
          'the popup lines up on the cross axis against its trigger.',
      specimen: _AlignSpecimen(),
      code: _alignCode,
      label: 'Align specimen view',
    ),
    ShowcaseSection(
      id: 'variants',
      title: 'Variants',
      description:
          'The reference has no section for this: Popover carries real '
          'behavioral forks beyond align, each measured off the reference '
          'this system ports rather than invented for symmetry. Below, one '
          'trigger per PopoverSide value. PopoverAnchorMode (which '
          'corner the zoom grows from) and PopoverBarrier (what the '
          'popup lays under itself) are documented in API Reference below '
          'instead of demonstrated live: both are subtler behavioral '
          'differences — a hit-testing rule and a transform-origin corner '
          '— that a static specimen cannot show honestly.',
      specimen: _SideSpecimen(),
      code: _sideCode,
      label: 'Side specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every public class, enum, top-level function, and constructor '
          'parameter the source declares.',
      children: const <DocsTocEntry>[
        DocsTocEntry(title: 'Popover', anchor: 'api-elpopover'),
        DocsTocEntry(title: 'PopoverAlign', anchor: 'api-elpopoveralign'),
        DocsTocEntry(title: 'PopoverSide', anchor: 'api-elpopoverside'),
        DocsTocEntry(
          title: 'PopoverAnchorMode',
          anchor: 'api-elpopoveroriginmodel',
        ),
        DocsTocEntry(title: 'PopoverBarrier', anchor: 'api-elpopoverbarrier'),
        DocsTocEntry(title: 'PopoverSurface', anchor: 'api-elpopoversurface'),
        DocsTocEntry(
          title: 'popoverPlacement()',
          anchor: 'api-elpopoverplacement-fn',
        ),
        DocsTocEntry(
          title: 'PopoverPlacement',
          anchor: 'api-elpopoverplacement',
        ),
        DocsTocEntry(
          title: 'PopoverAnchorMetrics',
          anchor: 'api-elpopoveranchormetrics',
        ),
        DocsTocEntry(
          title: 'PopoverContentBuilder',
          anchor: 'api-elpopovercontentbuilder',
        ),
      ],
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'Popover opens and closes on a caller-owned boolean, not on a '
          "pointer gesture of its own. Rows describing an internal "
          'trigger interaction are marked N/A for that reason rather than '
          'invented.',
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
          "Read straight off Popover's own Focus wrapper and _onKey "
          '(lib/src/components/ui/popover.dart), not inferred.',
      child: _KeyboardContent(),
    ),
    DisclosureSection(
      id: 'responsive',
      title: 'Responsive',
      description:
          'The one behavior this primitive must not produce is a popup '
          'that hangs off the screen: the positioner runs a real '
          'flip-then-shift-then-clamp algorithm against the overlay’s '
          'own box on every layout pass, not a fixed offset.',
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
        title: 'Source and tests',
        facts: <DocsInstallFact>[
          DocsInstallFact(
            label: 'Source',
            value: popoverDoc.sourcePath,
            description: 'The authoritative package source.',
          ),
          const DocsInstallFact(
            label: 'GitHub',
            value:
                'github.com/ELATTAR-Ayoub/flutter-design-system/blob/'
                'main/lib/src/components/ui/popover.dart',
            description: "The registry manifest's own sourceLink, verbatim.",
          ),
          const DocsInstallFact(
            label: 'Tests',
            value:
                "test/selects_test.dart (Popover) and "
                "test/menus_test.dart (Popover: what the menus added)",
            description:
                'Package-level behavioral coverage: placement, the '
                'collision flip, the barrier, and the four knobs the '
                'menu family measured onto this primitive.',
          ),
          const DocsInstallFact(
            label: 'Docs specimen',
            value: 'example/test/components_docs/popover_test.dart',
            description:
                "This page's own responsive, theme, API-completeness, "
                'and live open/dismiss coverage.',
          ),
        ],
      ),
    ),
  ],
);

class PopoverDocPage extends StatelessWidget {
  const PopoverDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: popoverDoc.route,
    intro: DocsPageIntro(
      title: popoverDoc.title,
      description: popoverDoc.description,
    ),
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Components'),
      BreadcrumbEntry.page('Popover'),
    ],
    toc: popoverDocSpec.toc,
    previous: const DocsPageLink(title: 'Select', route: '/components/select'),
    // No next page is wired: no other overlay/navigation component had
    // landed a route when this page was written, and a guessed one would
    // risk pointing at a page that does not exist.
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('popover-doc-article'),
      child: ComponentDocPage(spec: popoverDocSpec, header: false),
    ),
  );
}

/* ── Showcase specimens ─────────────────────────────────────────────────── */

const String _previewCode = '''Popover(
  open: _open,
  side: PopoverSide.bottom,
  align: PopoverAlign.start,
  sideOffset: space(2),
  collisionPadding: space(2),
  onDismiss: () => setState(() => _open = false),
  anchor: Button(
    variant: ButtonVariant.outline,
    label: 'Open popover',
    onPressed: () => setState(() => _open = !_open),
    child: const Text('Open popover'),
  ),
  content: (context, metrics) => PopoverSurface(
    child: Container(
      width: math.max(metrics.anchorWidth, space(70)),
      padding: EdgeInsets.all(space(4)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          StyledText('Update dimensions', TextStyles.section),
          SizedBox(height: space(1)),
          StyledText(
            'Set the exact width and height for the selection.',
            TextStyles.small,
          ),
          SizedBox(height: space(4)),
          const Input(label: 'Width', initialValue: '100%'),
          SizedBox(height: space(3)),
          const Input(label: 'Height', initialValue: '25px'),
          SizedBox(height: space(4)),
          Button(
            variant: ButtonVariant.secondary,
            size: ButtonSize.sm,
            expanded: true,
            label: 'Done',
            onPressed: () => setState(() => _open = false),
            child: const Text('Done'),
          ),
        ],
      ),
    ),
  ),
)''';

const String _usageBasicCode = '''class _ShareButton extends StatefulWidget {
  const _ShareButton();
  @override
  State<_ShareButton> createState() => _ShareButtonState();
}

class _ShareButtonState extends State<_ShareButton> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return Popover(
      open: _open,
      onDismiss: () => setState(() => _open = false),
      anchor: Button(
        variant: ButtonVariant.outline,
        label: 'Share',
        onPressed: () => setState(() => _open = !_open),
        child: const StyledText('Share', TextStyles.buttonLabel),
      ),
      content: (BuildContext context, PopoverAnchorMetrics metrics) =>
          PopoverSurface(
        child: Padding(
          padding: EdgeInsets.all(space(4)),
          child: const StyledText('Share link content goes here.', TextStyles.small),
        ),
      ),
    );
  }
}''';

const String _usageAnchorPointCode =
    '''// A context menu has no trigger box to anchor to, Radix anchors it to a
// virtual element at the pointer instead, which is what anchorPoint is for.
Popover(
  open: _at != null,
  anchorPoint: _at,
  side: PopoverSide.right,
  align: PopoverAlign.start,
  origin: PopoverAnchorMode.corner,
  onDismiss: _close,
  anchor: Listener(
    onPointerDown: (PointerDownEvent event) {
      if (event.buttons == kSecondaryMouseButton) {
        setState(() => _at = event.position);
      }
    },
    child: content,
  ),
  content: (BuildContext context, PopoverAnchorMetrics metrics) =>
      PopoverSurface(child: menuRows),
)''';

const String _usageNonModalCode =
    '''// A menubar's own menus hand over to a sibling trigger on hover: a modal
// barrier would swallow that hover before it ever reached the next trigger.
Popover(
  open: _openIndex == index,
  barrier: PopoverBarrier.nonModal,
  onDismiss: () => setState(() => _openIndex = null),
  anchor: menuTrigger,
  content: (BuildContext context, PopoverAnchorMetrics metrics) =>
      PopoverSurface(child: menuRows),
)''';

const String _compositionCode = '''input = Popover(
  open: _open && _enabled,
  side: PopoverSide.bottom,
  align: PopoverAlign.start,
  sideOffset: Combobox.popupOffset,
  collisionPadding: space(2),
  onDismiss: () => _closePopup(),
  anchor: input,
  content: (BuildContext context, PopoverAnchorMetrics metrics) =>
      _ComboboxPopup<T>(
    width: metrics.anchorWidth + Combobox.popupOvershoot,
    maxHeight: math.min(
      Combobox.listMaxHeight,
      metrics.availableHeight - space(9),
    ),
    items: visible,
    // ...
  ),
);''';

const String _alignCode =
    '''for (final PopoverAlign align in PopoverAlign.values)
  Popover(
    open: openAlign == align,
    align: align,
    onDismiss: () => setState(() => openAlign = null),
    anchor: Button(
      label: align.name,
      onPressed: () => setState(() => openAlign = align),
      child: Text(align.name),
    ),
    content: (context, metrics) => PopoverSurface(
      child: Padding(
        padding: EdgeInsets.all(space(4)),
        child: Text('align: \${align.name}'),
      ),
    ),
  )''';

const String _sideCode = '''for (final PopoverSide side in PopoverSide.values)
  Popover(
    open: openSide == side,
    side: side,
    onDismiss: () => setState(() => openSide = null),
    anchor: Button(
      label: side.name,
      onPressed: () => setState(() => openSide = side),
      child: Text(side.name),
    ),
    content: (context, metrics) => PopoverSurface(
      child: Padding(
        padding: EdgeInsets.all(space(4)),
        child: Text('side: \${side.name}'),
      ),
    ),
  )''';

/// One [Popover] trigger, whose own open state is independent of every
/// sibling instance: what lets [_AlignSpecimen] and [_SideSpecimen] mount
/// several without one closing another.
class _PopoverDemoTrigger extends StatefulWidget {
  const _PopoverDemoTrigger({
    required this.keyPrefix,
    required this.label,
    this.side = PopoverSide.bottom,
    this.align = PopoverAlign.center,
  });

  final String keyPrefix;
  final String label;
  final PopoverSide side;
  final PopoverAlign align;

  @override
  State<_PopoverDemoTrigger> createState() => _PopoverDemoTriggerState();
}

class _PopoverDemoTriggerState extends State<_PopoverDemoTrigger> {
  bool _open = false;

  @override
  Widget build(BuildContext context) => Popover(
    open: _open,
    side: widget.side,
    align: widget.align,
    sideOffset: space(2),
    onDismiss: () => setState(() => _open = false),
    anchor: Button(
      key: ValueKey<String>('${widget.keyPrefix}-trigger'),
      variant: ButtonVariant.outline,
      size: ButtonSize.sm,
      label: widget.label,
      onPressed: () => setState(() => _open = !_open),
      child: Text(widget.label),
    ),
    content: (BuildContext context, PopoverAnchorMetrics metrics) =>
        PopoverSurface(
          child: Padding(
            key: ValueKey<String>('${widget.keyPrefix}-content'),
            padding: EdgeInsets.all(space(4)),
            child: StyledText(widget.label, TextStyles.small),
          ),
        ),
  );
}

class _AlignSpecimen extends StatelessWidget {
  const _AlignSpecimen();

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: space(3),
    runSpacing: space(3),
    children: <Widget>[
      for (final PopoverAlign align in PopoverAlign.values)
        _PopoverDemoTrigger(
          keyPrefix: 'popover-example:align-${align.name}',
          label: align.name,
          align: align,
        ),
    ],
  );
}

class _SideSpecimen extends StatelessWidget {
  const _SideSpecimen();

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: space(3),
    runSpacing: space(3),
    children: <Widget>[
      for (final PopoverSide side in PopoverSide.values)
        _PopoverDemoTrigger(
          keyPrefix: 'popover-example:side-${side.name}',
          label: side.name,
          side: side,
        ),
    ],
  );
}

/// The live specimen: a trigger that owns its own `open` state, and a
/// popup with real interactive content anchored to it: a genuine
/// [Popover] mounted through a real [Overlay], not a static illustration.
class _PopoverPreview extends StatefulWidget {
  const _PopoverPreview();

  @override
  State<_PopoverPreview> createState() => _PopoverPreviewState();
}

class _PopoverPreviewState extends State<_PopoverPreview> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        StyledText('Bottom side, start aligned', TextStyles.section),
        SizedBox(height: space(3)),
        Popover(
          open: _open,
          side: PopoverSide.bottom,
          align: PopoverAlign.start,
          sideOffset: space(2),
          collisionPadding: space(2),
          onDismiss: () => setState(() => _open = false),
          anchor: Button(
            key: const ValueKey<String>('popover-doc-specimen-trigger'),
            variant: ButtonVariant.outline,
            size: ButtonSize.md,
            label: 'Open popover',
            onPressed: () => setState(() => _open = !_open),
            child: StyledText('Open popover', TextStyles.buttonLabel),
          ),
          content: (BuildContext context, PopoverAnchorMetrics metrics) =>
              PopoverSurface(
                child: Container(
                  key: const ValueKey<String>('popover-doc-specimen-content'),
                  width: metrics.anchorWidth < space(70)
                      ? space(70)
                      : metrics.anchorWidth,
                  padding: EdgeInsets.all(space(4)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      StyledText(
                        'Update dimensions',
                        TextStyles.section,
                        color: theme.popoverForeground,
                      ),
                      SizedBox(height: space(1)),
                      StyledText(
                        'Set the exact width and height for the selection.',
                        TextStyles.small,
                        color: theme.mutedForeground,
                      ),
                      SizedBox(height: space(4)),
                      const Input(label: 'Width', initialValue: '100%'),
                      SizedBox(height: space(3)),
                      const Input(label: 'Height', initialValue: '25px'),
                      SizedBox(height: space(4)),
                      Button(
                        variant: ButtonVariant.secondary,
                        size: ButtonSize.sm,
                        expanded: true,
                        label: 'Done',
                        onPressed: () => setState(() => _open = false),
                        child: StyledText('Done', TextStyles.buttonLabel),
                      ),
                    ],
                  ),
                ),
              ),
        ),
        SizedBox(height: space(6)),
        StyledText(
          'Tap the trigger to open it; tap anywhere outside the popup, or '
          'press Escape once focus is inside it, to dismiss it.',
          TextStyles.small,
          color: theme.mutedForeground,
        ),
      ],
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
        id: 'api-elpopover',
        child: DocsApiTable(title: 'Popover', facts: _elPopoverFacts),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elpopoveralign',
        child: DocsApiTable(title: 'PopoverAlign', facts: _alignFacts),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elpopoverside',
        child: DocsApiTable(title: 'PopoverSide', facts: _sideFacts),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elpopoveroriginmodel',
        child: DocsApiTable(title: 'PopoverAnchorMode', facts: _originFacts),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elpopoverbarrier',
        child: DocsApiTable(title: 'PopoverBarrier', facts: _barrierFacts),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elpopoversurface',
        child: DocsApiTable(title: 'PopoverSurface', facts: _surfaceFacts),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elpopoverplacement-fn',
        child: DocsApiTable(
          title: 'popoverPlacement(): the positioner',
          facts: _placementFnFacts,
        ),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elpopoverplacement',
        child: DocsApiTable(
          title: 'PopoverPlacement (return value)',
          facts: _placementFacts,
        ),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elpopoveranchormetrics',
        child: DocsApiTable(
          title: 'PopoverAnchorMetrics',
          facts: _anchorMetricsFacts,
        ),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elpopovercontentbuilder',
        child: DocsApiTable(
          title: 'PopoverContentBuilder (typedef)',
          facts: _contentBuilderFacts,
        ),
      ),
    ],
  );
}

const List<DocsApiFact> _elPopoverFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'open',
    type: 'bool',
    description:
        'Required. Caller-owned, Popover mounts on the frame after '
        'this turns true and unmounts after it turns false and any exit '
        'animation finishes.',
  ),
  DocsApiFact(
    name: 'anchor',
    type: 'Widget',
    description:
        'Required. The trigger. Measured, never wrapped in a gesture of '
        'its own: it renders verbatim and keeps whatever onPressed the '
        'caller already gave it.',
  ),
  DocsApiFact(
    name: 'content',
    type: 'PopoverContentBuilder',
    description:
        'Required. Builds the popup from the metrics the positioner '
        "knows about the trigger before the popup itself is measured.",
  ),
  DocsApiFact(
    name: 'side',
    type: 'PopoverSide',
    description:
        'Default PopoverSide.bottom. Which edge of the anchor the '
        'popup opens against.',
  ),
  DocsApiFact(
    name: 'align',
    type: 'PopoverAlign',
    description:
        'Default PopoverAlign.center. How the popup lines up on the '
        'cross axis.',
  ),
  DocsApiFact(
    name: 'sideOffset',
    type: 'double',
    description:
        'Default 0. The gap between the anchor and the popup along the '
        'main axis, 6px on the combobox positioner, 4px on the date '
        "picker's.",
  ),
  DocsApiFact(
    name: 'collisionPadding',
    type: 'double',
    description:
        'Default 0. Minimum distance kept from every edge of the '
        'overlay while placing and sizing the popup.',
  ),
  DocsApiFact(
    name: 'animate',
    type: 'bool',
    description:
        'Default true. Whether the fade/zoom/slide transition runs at '
        'all. False is what NativeSelect mounts its menu under: the '
        'popup appears whole, in one frame, the way an operating-system '
        'picker does not zoom.',
  ),
  DocsApiFact(
    name: 'animateOut',
    type: 'bool',
    description:
        'Default true. Whether the exit half of that transition exists. '
        'False unmounts the popup on the frame open goes false: the one '
        'shipped consumer of this is a menubar menu, which zooms in and '
        'simply vanishes.',
  ),
  DocsApiFact(
    name: 'origin',
    type: 'PopoverAnchorMode',
    description:
        "Default PopoverAnchorMode.anchor. Whose transform-origin "
        'model the zoom grows from.',
  ),
  DocsApiFact(
    name: 'slideSides',
    type: 'Set<PopoverSide>',
    description:
        'Default {PopoverSide.bottom}. The resolved sides whose '
        "entrance carries a slide, travelling toward the trigger's "
        'side.',
  ),
  DocsApiFact(
    name: 'anchorPoint',
    type: 'Offset?',
    description:
        'Default null. A virtual, zero-size anchor at this point '
        'instead of the measured anchor box: how a context menu opens '
        "at the pointer rather than at a widget's corner. anchor still "
        'renders and is still hit-tested; it is simply no longer the '
        'placement box.',
  ),
  DocsApiFact(
    name: 'barrier',
    type: 'PopoverBarrier',
    description:
        'Default PopoverBarrier.modal. What the popup lays under '
        'itself to catch a pointer aimed elsewhere.',
  ),
  DocsApiFact(
    name: 'onDismiss',
    type: 'VoidCallback?',
    description:
        'Default null. Called on an outside pointer (unless barrier is '
        'none) or on Escape while focus is already inside the popup '
        'content.',
  ),
];

const List<DocsApiFact> _alignFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'start',
    type: 'PopoverAlign',
    description:
        "Leading edges flush: what the combobox's own popover "
        'positioner uses.',
  ),
  DocsApiFact(
    name: 'center',
    type: 'PopoverAlign',
    description: 'Centred on the trigger. The default.',
  ),
  DocsApiFact(
    name: 'end',
    type: 'PopoverAlign',
    description: 'Trailing edges flush.',
  ),
];

const List<DocsApiFact> _sideFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'top',
    type: 'PopoverSide',
    description: 'Above the trigger. opposite resolves to bottom.',
  ),
  DocsApiFact(
    name: 'bottom',
    type: 'PopoverSide',
    description:
        "The default: both consumers on the selects page use it. "
        'opposite resolves to top.',
  ),
  DocsApiFact(
    name: 'left',
    type: 'PopoverSide',
    description: 'To the left of the trigger. opposite resolves to right.',
  ),
  DocsApiFact(
    name: 'right',
    type: 'PopoverSide',
    description:
        'To the right: a context-menu submenu opens here. opposite '
        'resolves to left.',
  ),
];

const List<DocsApiFact> _originFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'anchor',
    type: 'PopoverAnchorMode',
    description:
        "The default. The zoom grows from a point on the trigger's own "
        "centre line, measured from base-ui's popups (the combobox, "
        'the date picker).',
  ),
  DocsApiFact(
    name: 'corner',
    type: 'PopoverAnchorMode',
    description:
        "The zoom grows from the popup's own nearest corner to the "
        "trigger: what every menu family's Radix positioner measures "
        'instead.',
  ),
  DocsApiFact(
    name: 'selfCenter',
    type: 'PopoverAnchorMode',
    description:
        "The popup's own middle, CSS's initial transform-origin value, "
        'reached on the reference by an unmatched Tailwind class rather '
        'than a deliberate choice, and reproduced here as a named model '
        'rather than a wrong side.',
  ),
];

const List<DocsApiFact> _barrierFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'modal',
    type: 'PopoverBarrier',
    description:
        'The default. An opaque layer under the popup, nothing outside '
        'it can be hovered or clicked while it is open, and a pointer '
        'there dismisses instead. Every popover shipped in this port '
        'uses this.',
  ),
  DocsApiFact(
    name: 'nonModal',
    type: 'PopoverBarrier',
    description:
        'A translucent layer: an outside pointer both dismisses and '
        'still reaches whatever it landed on. What lets a menubar hand '
        'its open menu over to a sibling trigger on hover.',
  ),
  DocsApiFact(
    name: 'none',
    type: 'PopoverBarrier',
    description:
        "No layer at all: a submenu. A layer here would sit over the "
        "parent's own rows and a pointer moving from the submenu back "
        'onto a sibling row would hit the barrier instead of the row.',
  ),
];

const List<DocsApiFact> _surfaceFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'child',
    type: 'Widget',
    description: "Required. The popup's own content.",
  ),
  DocsApiFact(
    name: 'radius',
    type: 'BorderRadius?',
    description:
        'Default null, which resolves to BorderRadius.circular('
        'Radii.lg), 12px.',
  ),
  DocsApiFact(
    name: 'shadow',
    type: 'ShadowStyle?',
    description:
        'Default null, which resolves to Shadows.tailwindMd. Every '
        '*SubContent in the menu family passes shadow-lg here instead.',
  ),
  DocsApiFact(
    name: 'ring',
    type: 'bool',
    description:
        'Default true: a 1px theme.foreground at 10% alpha ring. False '
        'for the one overlay in the corpus that writes a real border '
        'instead of a ring (ContextMenuSubContent).',
  ),
  DocsApiFact(
    name: 'border',
    type: 'BoxBorder?',
    description:
        'Default null. A real border, when a caller writes one: it '
        'costs the box extra width the way box-sizing: border-box does '
        'not.',
  ),
  DocsApiFact(
    name: 'spec(theme)',
    type: 'static ShadowStyle',
    description: "The family's shared shadow-plus-ring recipe at its defaults.",
  ),
  DocsApiFact(
    name: 'specOf({shadow, ring})',
    type: 'static ShadowStyle',
    description:
        'The same recipe with either half swapped out: what radius and '
        'shadow above are built from.',
  ),
];

const List<DocsApiFact> _placementFnFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'anchor',
    type: 'Rect',
    description:
        "Required. The trigger's box, in the overlay's coordinate "
        'space.',
  ),
  DocsApiFact(
    name: 'content',
    type: 'Size',
    description: "Required. The popup's own measured size.",
  ),
  DocsApiFact(
    name: 'viewport',
    type: 'Size',
    description: "Required. The overlay's own box: the collision boundary.",
  ),
  DocsApiFact(
    name: 'side',
    type: 'PopoverSide',
    description: 'Default PopoverSide.bottom.',
  ),
  DocsApiFact(
    name: 'align',
    type: 'PopoverAlign',
    description: 'Default PopoverAlign.center.',
  ),
  DocsApiFact(name: 'sideOffset', type: 'double', description: 'Default 0.'),
  DocsApiFact(
    name: 'collisionPadding',
    type: 'double',
    description: 'Default 0.',
  ),
  DocsApiFact(
    name: 'origin',
    type: 'PopoverAnchorMode',
    description: 'Default PopoverAnchorMode.anchor.',
  ),
];

const List<DocsApiFact> _placementFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'offset',
    type: 'Offset',
    description:
        "The popup's resolved top-left, in the overlay's coordinate "
        'space.',
  ),
  DocsApiFact(
    name: 'side',
    type: 'PopoverSide',
    description:
        'The side it actually landed on: the requested side, or its '
        'opposite when the flip fired.',
  ),
  DocsApiFact(
    name: 'origin',
    type: 'Alignment',
    description:
        'The resolved transform-origin the zoom grows from. A value '
        'class with structural equality.',
  ),
];

const List<DocsApiFact> _anchorMetricsFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'rect',
    type: 'Rect',
    description: "The trigger's box, in the overlay's coordinate space.",
  ),
  DocsApiFact(
    name: 'viewport',
    type: 'Size',
    description: "The overlay's own box.",
  ),
  DocsApiFact(
    name: 'availableWidth',
    type: 'double',
    description: 'How much horizontal room the collision boundary leaves.',
  ),
  DocsApiFact(
    name: 'availableHeight',
    type: 'double',
    description:
        'How much room the requested side leaves, read before the '
        "flip: the number a content builder caps its own max height "
        "against, the way the combobox popup's maxHeight does.",
  ),
  DocsApiFact(
    name: 'anchorWidth',
    type: 'double (get)',
    description:
        "rect.width. What the combobox popup's own width is seeded "
        'from before its min-width override.',
  ),
];

const List<DocsApiFact> _contentBuilderFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'content',
    type: 'Widget Function(BuildContext, PopoverAnchorMetrics)',
    description:
        "The content parameter's own signature: the popup is built "
        "from the caller's own build scope, so a list that narrows on "
        'a keystroke narrows in the same frame the keystroke was '
        'handled in.',
  ),
];

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Rest',
    treatment:
        'open is false: the OverlayPortal is not showing and only '
        'anchor is mounted.',
    userSignal: 'Nothing besides the trigger itself is on screen.',
  ),
  DocsStateFact(
    state: 'Hover',
    treatment:
        'N/A: anchor is rendered verbatim with no MouseRegion or '
        "gesture of Popover's own added to it; a hover effect on the "
        "trigger is entirely the caller's own widget.",
    userSignal: 'N/A',
  ),
  DocsStateFact(
    state: 'Focus-visible',
    treatment:
        'N/A on the trigger: same reason as Hover. Inside the popup, '
        'Escape is wired only once something in content already holds '
        'focus; see Keyboard below for what that means in practice.',
    userSignal: 'N/A',
  ),
  DocsStateFact(
    state: 'Pressed',
    treatment:
        "N/A, Popover applies no press paint of its own to anchor; "
        "open is a prop the caller flips from whatever gesture its own "
        'trigger widget already wires (a Button onPressed, in every '
        'shipped consumer).',
    userSignal: 'N/A',
  ),
  DocsStateFact(
    state: 'Selected',
    treatment:
        'N/A: open/closed is the only binary state this primitive '
        'represents; there is no selection concept.',
    userSignal: 'N/A',
  ),
  DocsStateFact(
    state: 'Loading',
    treatment:
        'N/A: content is built synchronously from the current frame; '
        'there is no async step to represent.',
    userSignal: 'N/A',
  ),
  DocsStateFact(
    state: 'Empty',
    treatment:
        'N/A: content is a required builder; the API has no path to an '
        'empty popup to design for.',
    userSignal: 'N/A',
  ),
  DocsStateFact(
    state: 'Error',
    treatment: 'N/A: no validation or error state exists on this component.',
    userSignal: 'N/A',
  ),
  DocsStateFact(
    state: 'Success',
    treatment: 'N/A: no async outcome to confirm.',
    userSignal: 'N/A',
  ),
  DocsStateFact(
    state: 'Disabled',
    treatment:
        'N/A, Popover has no enabled or disabled parameter; a caller '
        'wanting a disabled trigger disables its own anchor widget and '
        'never sets open to true.',
    userSignal: 'N/A',
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment:
        'The fade/zoom/slide transition runs through '
        'effectiveMotionDuration, so its MotionDurations.overlayEnter duration '
        'collapses to zero under reduced motion: the same collapse '
        'animate and animateOut already model at false.',
    userSignal:
        'The popup still opens and closes instantly, without animated '
        'travel.',
  ),
];

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: const <Widget>[
      _A11yRow(
        'Semantic role',
        'Popover renders no Semantics node of its own: no dialog or '
            'popup role, and no aria-expanded-style relationship wired '
            'between anchor and its popup.',
      ),
      _A11yRow(
        'Required labels',
        'None are set automatically. anchor keeps whatever accessible '
            'name its own widget already carries; content is arbitrary '
            'and must label itself.',
      ),
      _A11yRow(
        'Focus behavior',
        "Focus is the content's own business, by design: the source's "
            'own words. Nothing here moves focus into the popup when '
            'it opens or restores it to anchor when it closes; each '
            'real consumer decides for itself (the combobox keeps the '
            'caret in its own input while its popup is open; the date '
            "picker's calendar carries autoFocus and takes focus for "
            'itself).',
      ),
      _A11yRow(
        'Known gap: Escape does nothing unless a caller moves focus '
            'itself',
        'Focus is the content’s business is a deliberate design '
            'decision, and it has a real cost: a caller who opens a '
            'popup and never calls requestFocus() on anything inside '
            'it gets no Escape-to-close path at all, because the key '
            'event has nowhere to travel up from. The two consumers '
            'this component ships for both handle it (the combobox '
            'keeps focus in its own input; the date picker autofocuses '
            'its calendar), but that handling is each '
            'consumer’s own responsibility, not something '
            'Popover verifies or falls back to.',
      ),
      _A11yRow(
        'Touch target',
        'Popover adds no padding of its own around anchor; the tap '
            "target is whatever the wrapped trigger already provides.",
      ),
      _A11yRow(
        'Non-colour signal',
        "The popup's surface is a fixed fill and ring; nothing here "
            'communicates information by color alone.',
      ),
      _A11yRow(
        'Error wiring',
        'None, Popover never participates in form validation or an '
            'error state of its own.',
      ),
      _A11yRow(
        'Screen-reader announcements',
        'None. Opening or closing the overlay announces nothing on its '
            'own; a screen-reader user learns the popup opened only if '
            'content itself takes focus or announces something.',
      ),
      _A11yRow(
        'Known platform differences',
        'None observed in the paint or gesture logic: the barrier and '
            'layout code route on geometry and PopoverBarrier, never '
            'on platform.',
        last: true,
      ),
    ],
  );
}

/// Read straight off `Popover`'s own `Focus` wrapper and `_onKey`
/// (`lib/src/components/ui/popover.dart`), not inferred.
class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Popover requests no focus for itself: the Focus wrapper '
            'around content is built with canRequestFocus: false, '
            'skipTraversal: true, so Tab never lands on it and it is '
            'never the thing holding focus.',
        'Escape closes the popup, but only once focus is already '
            'inside content: _onKey only inspects KeyDownEvent for '
            'LogicalKeyboardKey.escape and calls onDismiss?.call(); any '
            'other key, or an Escape press before content holds focus, '
            'returns KeyEventResult.ignored and keeps propagating.',
        'No Tab trap: Popover imposes no FocusScope of its own '
            'around content, unlike OverlayPortal. Tab order inside '
            'the popup, and whether Tab can leave it, is entirely up '
            'to whatever content builds.',
        'anchor keeps whatever tab order and key bindings its own '
            'widget already had: Popover adds no key handling to the '
            'trigger.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      _bullets(ThemeScope.of(context), <String>[
        "Main axis: the flip: popoverPlacement measures the room "
            'side leaves against the anchor and the collision boundary. '
            "If the requested side has enough room for the content's "
            'size, it is used as-is. If not, the opposite side is '
            'tried. If neither side has enough room, whichever of the '
            'two has more room wins, and the popup is capped instead, '
            'CustomSingleChildLayout constrains the popup to that '
            'available space rather than letting it overflow.',
        'Cross axis: the shift: align places the popup relative to the '
            'anchor (leading edge, centred, or trailing edge), then '
            'the result is clamped back inside viewport − '
            'collisionPadding on both ends. A popup sliding along its '
            'trigger keeps it attached; the cross axis is never '
            'flipped, only shifted.',
        'The result is reported back out as PopoverPlacement once '
            'layout knows it, on the next frame: a popup whose side '
            'flips therefore zooms from the requested corner for one '
            'frame and the resolved one for the rest of the '
            'transition; every popup on a page with room to spare is '
            'correct from the first frame.',
        'None of this branches on platform or pointer kind: the same '
            'geometry runs whether the app is a phone, a tablet, or a '
            'desktop window, and content builders that want to respond '
            'to the room available read it themselves off '
            'PopoverAnchorMetrics.availableWidth / availableHeight, '
            'the way the combobox popup caps its own maxHeight against '
            'it.',
      ]),
    ],
  );
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
            value: 'popover',
            description:
                'registry/components/popover.json exists and is '
                'installable through the CLI today.',
          ),
          const DocsInstallFact(
            label: 'Destination',
            value: 'lib/components/ui/popover.dart',
            description:
                'The same lib/components/ui/ target every component '
                'installs to, in both foundation modes.',
          ),
          const DocsInstallFact(
            label: 'Foundation',
            value: 'source or package compatible',
            description:
                'The manifest names only source-foundation: nothing '
                'here is package-mode-only.',
          ),
          DocsInstallFact(
            label: 'Dependencies',
            value: popoverDoc.dependencies.join(', '),
            description:
                "The manifest's registryDependencies, resolved "
                'automatically by the registry client.',
          ),
          const DocsInstallFact(
            label: 'Assets',
            value: 'none',
            description: 'No image, font, or shader asset is referenced.',
          ),
          const DocsInstallFact(
            label: 'Shaders',
            value: 'none',
            description: 'Not applicable.',
          ),
          const DocsInstallFact(
            label: 'Platforms',
            value: 'Android, iOS, Web, macOS, Windows, Linux',
            description: 'Pure widget composition; nothing platform-gated.',
          ),
          const DocsInstallFact(
            label: 'Verified',
            value:
                "test/selects_test.dart's Popover group, "
                "test/menus_test.dart's Popover: what the menus "
                'added group, plus this docs specimen',
            description:
                'Package-level behavioral coverage: placement, the '
                'flip, the barrier, and the four knobs the menu family '
                'added. No fixture install was run as part of writing '
                'this page.',
          ),
        ],
      ),
      SizedBox(height: space(4)),
      const DocsLinkRow(
        links: <DocsLink>[
          DocsLink(label: 'Dropdown Menu', route: '/components/dropdown-menu'),
          DocsLink(label: 'Context Menu', route: '/components/context-menu'),
          DocsLink(label: 'Menubar', route: '/components/menubar'),
          DocsLink(
            label: 'Navigation Menu',
            route: '/components/navigation-menu',
          ),
          DocsLink(label: 'Combobox', route: '/components/combobox'),
          DocsLink(label: 'Native Select', route: '/components/native_select'),
          DocsLink(label: 'Calendar', route: '/components/calendar'),
          DocsLink(label: 'Hover Card', route: '/components/hover-card'),
          DocsLink(label: 'Surface', route: '/components/surface'),
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
        "PopoverSurface fills with theme.popover and inks its text with "
            "theme.popoverForeground through a DefaultTextStyle: content "
            'built inside content picks this up automatically unless it '
            'overrides its own color.',
        'The ring is a flat 10% of theme.foreground over the shadow layer, '
            'on every instance that leaves ring at its true default: the '
            'corner radius (Radii.lg, 12px) and the elevation '
            '(Shadows.tailwindMd) are each overridable per instance '
            'through radius and shadow, unlike the fixed pill Tooltip '
            'renders.',
        'The open/close transition: an 8px slide on whichever sides '
            'slideSides names, a 95%→100% zoom, and a fade: runs over '
            'MotionDurations.overlayEnter through effectiveMotionDuration on '
            'MotionCurves.enter, so it resolves instantly under reduced motion '
            'rather than being skipped as a special case.',
      ]);
}

class _A11yRow extends StatelessWidget {
  const _A11yRow(this.label, this.body, {this.last = false});

  final String label;
  final String body;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : space(3)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          StyledText(label, TextStyles.section, color: theme.actionText),
          SizedBox(height: space(1)),
          StyledText(body, TextStyles.small),
        ],
      ),
    );
  }
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
