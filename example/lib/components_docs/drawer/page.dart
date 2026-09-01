/// Public documentation page for the `drawer` component.
///
/// **Split from a combined page.** `sheet` and `drawer` used to share one
/// page and one `ComponentDocEntry` because they read as the same idea at
/// different edges. The owner asked for one component per page instead: this
/// file documents `lib/src/components/ui/drawer.dart` alone.
/// `lib/src/components/ui/sheet.dart` has its own page and its own directory,
/// `../sheet/page.dart`, not this one.
///
/// **Re-housed onto the kit.** This page used to hand-compose [Section]
/// panels shaped to mirror shadcn's own drawer page section for section; it
/// now declares a [ComponentDocSpec]
/// (`example/lib/docs/component_doc_page.dart`) and hands it to
/// [ComponentDocPage], the same shape `button` and `sheet` established.
/// Every specimen widget and every code string below is the one the
/// hand-composed page carried; new in this pass: the unheaded live demo is
/// now its own Preview `ShowcaseSection`, and a dedicated Keyboard
/// disclosure is split out of the old combined "Accessibility and keyboard
/// behavior" section.
///
/// **Skipped, honestly.** Eight of the reference's own sections describe a
/// capability this port genuinely does not have, and rather than fake one,
/// each is recorded in the Sizing section's own code comment instead of
/// getting a section of its own: Styling, Position, Swipe handle, Nested,
/// Non modal, Snap points, Responsive-by-composition, and Migrating from
/// Vaul.
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

final ComponentDocSpec drawerDocSpec = ComponentDocSpec(
  name: 'drawer',
  title: drawerDoc.title,
  description: drawerDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'Open it, then dismiss it by tapping the scrim, pressing '
          'Escape, or dragging it down past the threshold.',
      specimen: _DrawerPreview(keyPrefix: 'drawer-preview'),
      code: _drawerUsageCode,
      label: 'Drawer specimen',
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'Already reachable today through both the published package and '
          'the registry: it is barrel-exported and elattar add drawer '
          'resolves its shipped manifest, whose registryDependencies are '
          '${drawerDoc.dependencies.join(', ')}.',
      command: drawerDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/drawer.dart',
          description:
              'Copy ${drawerDoc.sourcePath} into components/ui and keep '
              'its relative imports pointed at the same foundation and '
              'sibling-component files (dialog.dart in particular: see '
              'Dependencies).',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated drawer source here when using manual '
              'mode.',
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'Uncontrolled, like Dialog: the open/close boolean lives '
          'inside OverlayPortal and the trigger only ever gets a '
          'callback. Drawer exposes no onOpenChange callback the way '
          "Dialog does: a real gap against the dialog's own API, not "
          'an omission from this page.',
      code: _drawerUsageCode,
    ),
    SnippetSection(
      id: 'composition',
      title: 'Composition',
      description:
          'Read directly off drawer.dart rather than carried from a '
          'live specimen: DrawerHandle mounts itself automatically '
          'ahead of DrawerContent.children and never appears in '
          'caller code.',
      code: _drawerCompositionCode,
    ),
    SnippetSection(
      id: 'sizing',
      title: 'Sizing',
      description:
          'DrawerContent takes no width or height parameter of its '
          'own: max-height is always DrawerContent.maxHeightFraction '
          '(80% of the viewport) below a fixed DrawerContent.topGutter '
          '(96px) strip of page it may never cover. Where the reference '
          'lets a caller override height per instance with a Tailwind '
          'class, Drawer exposes no matching parameter: every drawer '
          'in the app is sized identically. See DrawerContent below in '
          'API Reference for the fixed layout tokens.',
      code: _sizingSkippedCode,
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every public constructor parameter declared on every public '
          'class in lib/src/components/ui/drawer.dart: one table each.',
      children: const <DocsTocEntry>[
        DocsTocEntry(title: 'Drawer', anchor: 'api-eldrawer'),
        DocsTocEntry(title: 'DrawerContent', anchor: 'api-eldrawercontent'),
        DocsTocEntry(
          title: 'DrawerContent static helpers',
          anchor: 'api-eldrawercontent-static',
        ),
        DocsTocEntry(title: 'DrawerHandle', anchor: 'api-eldrawerhandle'),
        DocsTocEntry(title: 'DrawerHeader', anchor: 'api-eldrawerheader'),
        DocsTocEntry(title: 'DrawerFooter', anchor: 'api-eldrawerfooter'),
        DocsTocEntry(title: 'DrawerTitle', anchor: 'api-eldrawertitle'),
        DocsTocEntry(
          title: 'DrawerDescription',
          anchor: 'api-eldrawerdescription',
        ),
      ],
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'Read straight off Drawer, DrawerContent, and the shared '
          'OverlayPortal it rides.',
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
          'drawer.dart wires no key handling of its own: every fact '
          'here belongs to the shared OverlayPortal it rides '
          '(lib/src/components/ui/dialog.dart).',
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
            value: drawerDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'test/dialogs_test.dart',
            description:
                'Drawer is covered inside this suite; there is no '
                'dedicated drawer_test.dart in the package itself.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/drawer_test.dart',
            description:
                'Covers this page: the article mounts, every documented '
                'constructor parameter appears in an API table, the '
                'section order matches this file, and a live Drawer '
                'actually opens, drags past the close threshold, and '
                'dismisses.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/drawer/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class DrawerDocPage extends StatelessWidget {
  const DrawerDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: drawerDoc.route,
    intro: DocsPageIntro(
      title: drawerDoc.title,
      description: drawerDoc.description,
    ),
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Components'),
      BreadcrumbEntry.page('Drawer'),
    ],
    toc: drawerDocSpec.toc,
    previous: const DocsPageLink(title: 'Dialog', route: '/components/dialog'),
    next: const DocsPageLink(
      title: 'Dropdown Menu',
      route: '/components/dropdown-menu',
    ),
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('drawer-doc-article'),
      child: ComponentDocPage(spec: drawerDocSpec, header: false),
    ),
  );
}

/* ── Showcase specimens ─────────────────────────────────────────────────── */

const String _drawerUsageCode = '''Drawer(
  trigger: (context, open) => Button(
    onPressed: open,
    child: const Text('Card actions'),
  ),
  content: (context, close) => DrawerContent(
    children: <Widget>[
      DrawerHeader(children: <Widget>[
        DrawerTitle('Voidwing Ascendant'),
        DrawerDescription('Eclipse Vault · #044 · Legendary'),
      ]),
      DrawerFooter(children: <Widget>[
        Button(onPressed: close, child: const Text('Sell for \$1,240.00')),
      ]),
    ],
  ),
)''';

/// Drawer's anatomy, read directly off drawer.dart rather than carried from
/// a live specimen: DrawerHandle mounts itself automatically ahead of
/// [DrawerContent.children] and never appears in caller code.
const String _drawerCompositionCode = '''Drawer(
  trigger: (context, open) => ..., // builds the opener
  content: (context, close) => DrawerContent(
    children: <Widget>[
      // DrawerHandle is NOT listed here: DrawerContent prepends it
      // to the column itself, unconditionally, ahead of these children.
      DrawerHeader(children: <Widget>[
        DrawerTitle('...'),
        DrawerDescription('...'),
      ]),
      ..., // the body: any widget, not independently scrollable
      DrawerFooter(children: <Widget>[
        Button(onPressed: close, child: const Text('...')),
      ]),
    ],
  ),
)''';

/// The Sizing section's own "missing half": eight capabilities the
/// reference's own drawer page documents that this port genuinely does not
/// have, recorded here rather than faked as a live specimen.
const String _sizingSkippedCode =
    '''// SKIPPED: styling, position, swipe handle, nested, non modal,
// snap points, responsive, migrating from vaul.

// Styling: the reference's data-[state], data-[vaul-drawer-direction],
// and CSS custom-property hooks have no Flutter analogue; Drawer
// exposes no styling surface beyond the fixed fill/border/radius
// documented under DrawerContent in API Reference.

// Position: Drawer opens from the bottom only. drawer.dart's own doc
// comment records left, right, and top as "not ported": there is no
// swipeDirection-equivalent parameter.

// Swipe handle: DrawerHandle always mounts, unconditionally,
// prepended by DrawerContent itself. There is no showSwipeHandle-style
// toggle to turn it off.

// Nested: opening a second Drawer from within an open one is not
// demonstrated anywhere in the corpus. OverlayPortal's own stack could
// plausibly support it, but no specimen exists to verify the
// reference's parent-stays-mounted behavior against.

// Non modal: Drawer always mounts a dismissing scrim; there is no
// modal: false to let the page keep receiving input while it is open.

// Snap points: also recorded as "not ported" in drawer.dart's own doc
// comment. The panel is either open at its natural height or closed;
// there is no intermediate resting height.

// Responsive (pairing Dialog and Drawer by breakpoint): a real, valid
// pattern, but no specimen in this corpus composes the two by
// MediaQuery width the way the reference's own example does; see this
// page's own Responsive section for how the drawer is individually
// viewport-aware instead.

// Migrating from Vaul: the reference's own guidance for updating an
// existing Vaul integration. Nothing to migrate on a from-scratch
// Flutter port.''';

/// The primary live specimen: one real [Drawer], keyed by [keyPrefix] so
/// the same specimen shape can be reused at more than one call site on this
/// page without a duplicate-key collision.
class _DrawerPreview extends StatelessWidget {
  const _DrawerPreview({required this.keyPrefix});

  final String keyPrefix;

  @override
  Widget build(BuildContext context) => Drawer(
    trigger: (BuildContext context, VoidCallback open) => Button(
      key: ValueKey<String>('$keyPrefix-trigger'),
      variant: ButtonVariant.secondary,
      onPressed: open,
      child: const Text('Open drawer'),
    ),
    content: (BuildContext context, VoidCallback close) => DrawerContent(
      children: <Widget>[
        const DrawerHeader(
          children: <Widget>[
            DrawerTitle('Card actions'),
            DrawerDescription(
              'Drag down to dismiss, or use the buttons below.',
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: space(4)),
          child: Button(
            expanded: true,
            onPressed: close,
            child: const Text('Close'),
          ),
        ),
        DrawerFooter(
          children: <Widget>[
            Button(
              variant: ButtonVariant.outline,
              onPressed: close,
              child: const Text('Cancel'),
            ),
          ],
        ),
      ],
    ),
  );
}

/* ── Disclosure content ─────────────────────────────────────────────────── */

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsAnchor(
        id: 'api-eldrawer',
        child: DocsApiTable(title: 'Drawer', facts: _drawerFacts),
      ),
      SizedBox(height: space(6)),
      const DocsAnchor(
        id: 'api-eldrawercontent',
        child: DocsApiTable(title: 'DrawerContent', facts: _contentFacts),
      ),
      SizedBox(height: space(6)),
      const DocsAnchor(
        id: 'api-eldrawercontent-static',
        child: DocsApiTable(
          title: 'DrawerContent static helpers',
          facts: _contentStaticFacts,
        ),
      ),
      SizedBox(height: space(6)),
      const DocsAnchor(
        id: 'api-eldrawerhandle',
        child: DocsApiTable(title: 'DrawerHandle', facts: _handleFacts),
      ),
      SizedBox(height: space(6)),
      const DocsAnchor(
        id: 'api-eldrawerheader',
        child: DocsApiTable(title: 'DrawerHeader', facts: _headerFacts),
      ),
      SizedBox(height: space(6)),
      const DocsAnchor(
        id: 'api-eldrawerfooter',
        child: DocsApiTable(title: 'DrawerFooter', facts: _footerFacts),
      ),
      SizedBox(height: space(6)),
      const DocsAnchor(
        id: 'api-eldrawertitle',
        child: DocsApiTable(title: 'DrawerTitle', facts: _titleFacts),
      ),
      SizedBox(height: space(6)),
      const DocsAnchor(
        id: 'api-eldrawerdescription',
        child: DocsApiTable(
          title: 'DrawerDescription',
          facts: _descriptionFacts,
        ),
      ),
    ],
  );
}

const List<DocsApiFact> _drawerFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'trigger',
    type: 'ModalTriggerBuilder',
    description: 'Required. Builds the control that opens the portal.',
  ),
  DocsApiFact(
    name: 'content',
    type: 'ModalContentBuilder',
    description:
        'Required. Builds the panel and receives its close callback. '
        'Drawer wraps the built content in its own vertical drag '
        'gesture detector before mounting it.',
  ),
];

const List<DocsApiFact> _contentFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'children',
    type: 'List<Widget>',
    description:
        'Required. The column\'s contents. A DrawerHandle is '
        'prepended automatically ahead of these; it is not one of '
        'these children and cannot be turned off.',
  ),
];

const List<DocsApiFact> _contentStaticFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'DrawerContent.topGutter',
    type: 'static double',
    description:
        '96px (space(24)): the strip of page the drawer may never cover, '
        'even at its tallest.',
  ),
  DocsApiFact(
    name: 'DrawerContent.maxHeightFraction',
    type: 'static const double',
    description: '0.8: the panel never exceeds 80% of the viewport height.',
  ),
  DocsApiFact(
    name: 'DrawerContent.radius',
    type: 'static double',
    description: 'Radii.xl (16px): the top corners only.',
  ),
];

const List<DocsApiFact> _handleFacts = <DocsApiFact>[
  DocsApiFact(
    name: '(none)',
    type: 'const DrawerHandle({super.key})',
    description:
        'Takes no constructor parameters of its own beyond key. It is '
        'the grip: width and height are fixed statics below, not '
        'per-instance options.',
  ),
  DocsApiFact(
    name: 'DrawerHandle.width',
    type: 'static double',
    description: '96px (space(24)) grip width.',
  ),
  DocsApiFact(
    name: 'DrawerHandle.height',
    type: 'static double',
    description: '4px (space(1)) grip height.',
  ),
];

const List<DocsApiFact> _headerFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'children',
    type: 'List<Widget>',
    description:
        'Required. The header\'s stacked contents (2px gap), centred: '
        'unlike Sheet\'s left-aligned header.',
  ),
];

const List<DocsApiFact> _footerFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'children',
    type: 'List<Widget>',
    description:
        'Required. The footer\'s stacked CTAs (8px gap). The mt-auto '
        'class has nothing to push against here: the panel is h-auto, '
        'so it resolves to zero; the footer\'s top is simply its '
        'predecessor\'s bottom.',
  ),
];

const List<DocsApiFact> _titleFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'text',
    type: 'String (positional)',
    description:
        'Required. The title\'s only content, centre-aligned, rendered '
        'in theme.foreground.',
  ),
];

const List<DocsApiFact> _descriptionFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'text',
    type: 'String (positional)',
    description:
        'Required. The description\'s only content, centre-aligned, '
        'rendered in theme.mutedForeground.',
  ),
];

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Closed',
    treatment: 'Portal content is not mounted.',
    userSignal: 'Trigger remains available.',
  ),
  DocsStateFact(
    state: 'Open',
    treatment:
        'Scrim and panel both animate over 500ms on vaul\'s own '
        'cubic-bezier(0.32, 0.72, 0, 1) (MotionDurations.drawerOpen / '
        'MotionCurves.vaul): a different clock and curve from every other '
        'overlay in the system.',
    userSignal:
        'The grip handle signals the drawer is draggable before the '
        'user touches it.',
  ),
  DocsStateFact(
    state: 'Dragging',
    treatment:
        'The panel follows the pointer 1:1, downward only: an upward '
        'drag is clamped to zero, since a bottom panel has nowhere '
        'further to go.',
    userSignal:
        'Releasing past 25% of the panel\'s own height (vaul\'s default '
        'closeThreshold) closes it; short of that, it springs back '
        'open.',
  ),
  DocsStateFact(
    state: 'Escape / back',
    treatment:
        'Dismisses on Escape (OverlayPortal\'s FocusScope) and on '
        'Android back / predictive back (the shared PopScope stack).',
    userSignal: 'The page remains in place.',
  ),
  DocsStateFact(
    state: 'Scrim tap',
    treatment:
        'Dismisses on a tap outside the panel: dismissOnOverlayTap is '
        'not set to false, so OverlayPortal\'s true default applies.',
    userSignal: 'Any tap outside the panel closes it.',
  ),
  DocsStateFact(
    state: 'Long content',
    treatment:
        'DrawerContent clips to its own 80vh cap and does not wrap '
        'its body in a Flexible + SingleChildScrollView. The body is '
        'deliberately NOT independently scrollable: a nested '
        'Scrollable would win the gesture arena against the '
        'drag-to-dismiss recognizer wrapped around the whole panel.',
    userSignal:
        'Content taller than the 80vh cap is clipped, not scrollable, '
        'unless the caller adds their own scroll region below the '
        'cap.',
  ),
  DocsStateFact(
    state: 'Disabled, N/A',
    treatment: 'Exposes no enabled/disabled parameter of its own.',
    userSignal:
        'A caller wanting a disabled trigger gates Button\'s own '
        'onPressed outside this widget.',
  ),
  DocsStateFact(
    state: 'Loading / Empty / Error / Success, N/A',
    treatment: 'A structural overlay with no async or validation concept.',
    userSignal: 'None of the four states apply directly.',
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment:
        'Rides OverlayPortal, whose durations resolve through '
        'effectiveMotionDuration(context, ...): collapsing to zero under '
        'the platform\'s disable-animations flag.',
    userSignal: 'The transition still happens, instantly.',
  ),
];

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Focus moves INTO the panel on open: OverlayPortal wraps the '
            'content in FocusScope(autofocus: true), so the '
            'FocusScopeNode itself (not a leaf widget) claims primary '
            'focus the moment the overlay mounts.',
        'Closing DOES return focus to the trigger that opened the '
            'overlay, even though OverlayPortal contains no explicit '
            '"restore focus" code of its own: Flutter\'s FocusManager '
            'falls back to the enclosing scope\'s previously-focused '
            'child once the overlay\'s own FocusScope is removed from '
            'the tree, as long as the trigger\'s FocusNode is still '
            'mounted when the overlay closes.',
        'No built-in close button at all: unlike Sheet, drawer.dart '
            'imports neither button.dart nor icon.dart. A caller must '
            'compose one and give it its own accessible label.',
        'DrawerContent does NOT use SafeArea anywhere: a real gap. '
            'On a device with a bottom home indicator, drawer content '
            'is not inset from it.',
        'Touch target: the grip handle DrawerHandle renders is 96 x '
            '4 logical pixels, far under any reasonable touch-target '
            'guidance on its own. The full-width lane it sits in (the '
            'whole top strip of the panel) is what actually receives '
            'the drag gesture, not the visible bar.',
        'DrawerTitle and DrawerDescription are plain, centred '
            'StyledText, not wired to the panel as a Semantics('
            'scopesRoute: true) accessible name/description pair.',
      ]);
}

/// `drawer.dart` wires no key handling of its own — every fact here belongs
/// to the shared `OverlayPortal` it rides (`lib/src/components/ui/dialog.dart`).
class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Focus is trapped while open in the sense that matters for Tab '
            'traversal: once Tab moves focus to a real control inside '
            'the panel, further presses cycle inside the panel rather '
            'than reaching page content behind the scrim.',
        'Escape closes the topmost open overlay '
            '(OverlayPortalState\'s static stack), matching dialog\'s '
            'own Escape contract.',
        'Android back / predictive back dismisses the topmost overlay '
            'unconditionally, the same USER-ORDERED MOBILE ADAPTATION '
            'dialog.dart documents, shared by every OverlayPortal '
            'consumer.',
        'No custom ordering: drawer.dart declares no '
            'FocusTraversalPolicy of its own. Tab and Shift+Tab walk '
            'whatever order the panel\'s own children (header, body, '
            'footer) declare; there is no close button in that order '
            'at all, see Accessibility.',
        'The drag-to-dismiss gesture has no keyboard equivalent: a '
            'keyboard-only user closes the drawer with Escape, never '
            'by "dragging" it.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Opts OUT of OverlayPortal\'s compact viewport clamp '
            '(clampToViewport: false): the drawer already IS the phone '
            'container, inset-x-0 is a full-bleed width a 90vw cap '
            'would break.',
        'Clamps its own height instead: max-height is always 80% of '
            'the viewport (DrawerContent.maxHeightFraction), on '
            'every screen size, with a fixed 96px top gutter '
            '(DrawerContent.topGutter) it may never cover.',
        'The body is deliberately NOT independently scrollable: a '
            'nested Scrollable would win the gesture arena against the '
            'drag-to-dismiss recognizer wrapped around the whole '
            'panel. vaul\'s own answer, only drag when the inner '
            'scroller is already at its top, is not ported.',
        'No breakpoint branching for the layout decision itself: the '
            'same widget tree renders at 390px and 1440px, only the '
            'resolved max-height value changes.',
        'Platform parity: the drag gesture uses '
            'PointerDeviceKind-agnostic recognizers (RawGestureDetector '
            '+ VerticalDragGestureRecognizer), so mouse and touch both '
            'drive it identically; no dart:io Platform branch anywhere '
            'in the file.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      _bullets(ThemeScope.of(context), <String>[
        'File: lib/src/components/ui/drawer.dart: one file, no '
            'companions.',
        'Flutter imports: package:flutter/gestures.dart '
            '(VerticalDragGestureRecognizer), '
            'package:flutter/rendering.dart (RenderProxyBox, for the '
            'internal height-measuring render object), '
            'package:flutter/widgets.dart.',
        'Foundation imports: foundation/motion.dart, '
            'foundation/spacing.dart, foundation/theme.dart, '
            'foundation/typography.dart, theme_scope.dart (StyledText, '
            'ThemeScope).',
        'Component imports: dialog.dart only (OverlayPortal, '
            'ModalTriggerBuilder, ModalContentBuilder). No '
            'button.dart, no icon.dart: matching the lack of a '
            'built-in close button.',
        'registryDependencies, read directly from the shipped '
            'manifest: ${drawerDoc.dependencies.join(', ')}.',
        'Assets, fonts, shaders: none, though its motion is worth '
            'flagging even without an asset: driven by MotionCurves.vaul '
            'and MotionDurations.drawerOpen rather than the shared '
            'MotionDurations.overlayEnter / MotionCurves.enter tokens every other '
            'OverlayPortal consumer uses.',
      ]),
      SizedBox(height: space(2)),
      const DocsLinkRow(
        links: <DocsLink>[
          DocsLink(label: 'Dialog', route: '/components/dialog'),
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
        'theme.popover always fills the panel; there is no fill '
            'override parameter, a real gap against Sheet\'s own fill '
            'parameter.',
        'theme.border paints the single hairline seam on the panel\'s '
            'top edge.',
        'theme.muted paints DrawerHandle\'s grip pill. drawer.dart '
            'never reads Shadows: the panel carries no '
            'elevation/shadow spec at all, unlike Sheet\'s '
            'Shadows.overlay.',
        'Radii.xl (16px) rounds the top corners only (rounded-t-xl); '
            'the bottom stays square, flush with the viewport edge.',
        'DrawerHeader and DrawerFooter carry NO muted band or rule '
            'of their own: plain padded columns, a real anatomy '
            'difference from Sheet\'s own header/footer, which do band '
            'and rule.',
        'Every colour is read live off ThemeScope.of(context) at build '
            'time. Flipping ThemeController re-resolves every one '
            'on the next frame: nothing is cached.',
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
