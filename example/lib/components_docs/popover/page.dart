/// Public component documentation for the popover component.
///
/// `popover` is Wave 3 of the component-documentation plan, and: like
/// `tooltip` before it: already carries a real
/// `registry/components/popover.json` manifest, so the Installation section
/// below renders the genuine `elattar add popover` command rather than a
/// shipped install command and registry dependencies.
///
/// The eighteen IA §9.1 sections map onto this page exactly as
/// `tooltip/page.dart`'s own library doc describes: breadcrumb/family from
/// the eyebrow and [DocsLayout.breadcrumbs]; title and short description
/// from [DocsLayout] itself; status, preview, installation, usage, API,
/// variants, states, accessibility, responsive behaviour, the install-facts
/// disclosure, a composition example, theming notes, and source/tests each
/// get their own [ElSection]; previous/next comes from [DocsLayout] again.
///
/// No Wave 3 sibling has landed yet at the time this page was written: the
/// sidebar and previous link therefore reuse the same already-routed pages
/// `switch/page.dart` does (Button, Card, Input, Dialog, Select) rather than
/// guessing at a Wave 3 route that may not exist, the same caution that
/// file's own comment documents.
///
/// `ElPopover` is the one primitive in this wave that is a positioning
/// engine as much as a component: [ElSelect] and `HoverCard` both reuse its
/// placement math ([elPopoverPlacement]) and its paint ([ElPopoverSurface])
/// without mounting the widget itself, and nine other components —
/// `DropdownMenu`, `ContextMenu`, `Menubar`, `Menu`, the agent attach menu,
/// `Combobox`, `NativeSelect`, `Calendar`'s date picker, and
/// `NavigationMenu`: mount their popups through [ElPopover] directly. Both
/// facts are cited from the real source comments and are reflected in the
/// Composition and Dependencies sections below, not invented.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/docs_code.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../kit.dart';
import '../catalog.dart';
import 'meta.dart';

class PopoverDocPage extends StatelessWidget {
  const PopoverDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) {
    final ComponentDocEntry entry = popoverDoc;
    return DocsLayout(
      route: entry.route,
      intro: DocsPageIntro(
        eyebrow: 'COMPONENTS / BASE',
        title: entry.title,
        description: entry.description,
      ),
      breadcrumbs: const <ElBreadcrumbEntry>[
        ElBreadcrumbEntry.link('Components'),
        ElBreadcrumbEntry.page('Popover'),
      ],
      sidebar: _sidebar(entry.route),
      toc: const <DocsTocEntry>[
        DocsTocEntry(title: 'Installation', anchor: 'install'),
        DocsTocEntry(title: 'Usage', anchor: 'usage'),
        DocsTocEntry(title: 'Composition', anchor: 'composition'),
        DocsTocEntry(title: 'Align', anchor: 'align'),
        DocsTocEntry(title: 'Variants', anchor: 'variants'),
        DocsTocEntry(title: 'API Reference', anchor: 'api'),
        DocsTocEntry(title: 'States', anchor: 'states'),
        DocsTocEntry(title: 'Accessibility', anchor: 'accessibility'),
        DocsTocEntry(title: 'Responsive', anchor: 'responsive'),
        DocsTocEntry(title: 'Dependencies', anchor: 'dependencies'),
        DocsTocEntry(title: 'Theming', anchor: 'theming'),
        DocsTocEntry(title: 'Source', anchor: 'source'),
      ],
      previous: const DocsPageLink(
        title: 'Select',
        route: '/components/select',
      ),
      // No next page is wired: no other Wave 3 (overlay and navigation)
      // component had landed a route when this page was written, and a
      // guessed one would risk pointing at a page that does not exist: the
      // same caution `switch/page.dart`'s own comment documents.
      onNavigate: onNavigate,
      child: _PopoverArticle(entry: entry),
    );
  }
}

/// The five already-routed component pages, plus this one. Static rather
/// than derived from `catalog.dart#componentDocs`: that list does not carry
/// [popoverDoc] yet, and this file must not edit the supervisor-owned
/// catalog to make it do so.
List<DocsSidebarEntry> _sidebar(String route) => <DocsSidebarEntry>[
  const DocsSidebarEntry(title: 'Button', route: '/components/button'),
  const DocsSidebarEntry(title: 'Card', route: '/components/card'),
  const DocsSidebarEntry(title: 'Input', route: '/components/input'),
  const DocsSidebarEntry(title: 'Dialog', route: '/components/dialog'),
  const DocsSidebarEntry(title: 'Select', route: '/components/select'),
  DocsSidebarEntry(title: 'Popover', route: route, selected: true),
];

class _PopoverArticle extends StatelessWidget {
  const _PopoverArticle({required this.entry});

  final ComponentDocEntry entry;

  @override
  Widget build(BuildContext context) => Column(
    key: const ValueKey<String>('popover-doc-article'),
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      // The live demo sits above the first heading, unheaded, the same
      // shape https://ui.shadcn.com/docs/components/base/popover itself
      // uses before its own Installation heading: a trigger button that
      // owns its own open state, and a popup anchored to it with real
      // interactive content (two ElInput fields and a Done button). Tap
      // the trigger to open it; tap anywhere outside the popup, or press
      // Escape once focus is inside it, to dismiss it.
      Padding(
        padding: EdgeInsets.only(bottom: el(20)),
        child: DocsCodeExample(
          title: 'Popover specimen',
          description: 'Tap to open. Tap outside, or press Escape, to close.',
          preview: const _PopoverPreview(),
          command: DocsCodeCommand(command: entry.command),
        ),
      ),
      ElSection(
        id: 'install',
        title: 'Installation',
        description:
            'popover already has a registry manifest: this installs '
            'lib/src/components/popover.dart and its one dependency, '
            'source-foundation, resolved automatically.',
        child: DocsCodeExample(
          title: 'Installation',
          command: DocsCodeCommand(
            command: entry.command,
            description:
                'Installs popover.dart and resolves source-foundation '
                'automatically.',
          ),
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
      ),
      ElSection(
        id: 'usage',
        title: 'Usage',
        description:
            'ElPopover reads open the way Radix reads its own open prop: '
            'the caller owns the boolean and reports it back on '
            'onDismiss. There is no controller with its own lifecycle to '
            'create or dispose. The three shapes below are the real ones '
            'this component ships for.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ElPanel(
              label: 'DART',
              note: 'MINIMAL: inside a State',
              child: DocsSelectableCodeBlock(code: _usageBasicCode),
            ),
            SizedBox(height: el(5)),
            ElPanel(
              label: 'DART',
              note: 'VIRTUAL ANCHOR: a context menu',
              child: DocsSelectableCodeBlock(code: _usageAnchorPointCode),
            ),
            SizedBox(height: el(5)),
            ElPanel(
              label: 'DART',
              note: 'NON-MODAL BARRIER: a menu strip handoff',
              child: DocsSelectableCodeBlock(code: _usageNonModalCode),
            ),
          ],
        ),
      ),
      ElSection(
        id: 'composition',
        title: 'Composition',
        description:
            'shadcn splits Popover into Popover, PopoverTrigger, and '
            'PopoverContent. ElPopover is one widget instead: anchor is '
            'the trigger, rendered verbatim, and content is a builder that '
            'returns the popup, almost always wrapped in ElPopoverSurface '
            'for the shared fill, ring, and radius. The real shape below '
            'is ElCombobox\'s own popup wiring, not an invented one.',
        child: ElPanel(
          label: 'DART',
          note: 'REAL CONSUMER, ElCombobox’s own popup',
          child: DocsSelectableCodeBlock(code: _compositionCode),
        ),
      ),
      ElSection(
        id: 'align',
        title: 'Align',
        description:
            "shadcn's own live demo for this section is a Start / Center / "
            'End tab switcher. Every variant table on this docs site is a '
            'data table rather than a re-rendered live tab strip, so the '
            'three values below carry the same facts in that established '
            'format: ElPopoverAlign is the one enum that lines up exactly '
            "with shadcn's own Align section.",
        child: const DocsApiTable(
          title: 'ElPopoverAlign',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'start',
              type: 'ElPopoverAlign',
              description:
                  "Leading edges flush: what the combobox's own popover "
                  'positioner uses.',
            ),
            DocsApiFact(
              name: 'center',
              type: 'ElPopoverAlign',
              description: 'Centred on the trigger. The default.',
            ),
            DocsApiFact(
              name: 'end',
              type: 'ElPopoverAlign',
              description: 'Trailing edges flush.',
            ),
          ],
        ),
      ),
      ElSection(
        id: 'variants',
        title: 'Variants',
        description:
            'The reference has no section for these: ElPopover carries '
            'three more real behavioral forks beyond align, each a fact '
            'measured on the reference this system ports, not a tuning '
            'knob invented for symmetry.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const DocsApiTable(
              title: 'ElPopoverSide',
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'top',
                  type: 'ElPopoverSide',
                  description:
                      'Above the trigger. opposite resolves to bottom.',
                ),
                DocsApiFact(
                  name: 'bottom',
                  type: 'ElPopoverSide',
                  description:
                      "The default: both consumers on the selects page "
                      'use it. opposite resolves to top.',
                ),
                DocsApiFact(
                  name: 'left',
                  type: 'ElPopoverSide',
                  description:
                      'To the left of the trigger. opposite resolves to '
                      'right.',
                ),
                DocsApiFact(
                  name: 'right',
                  type: 'ElPopoverSide',
                  description:
                      'To the right: a context-menu submenu opens here. '
                      'opposite resolves to left.',
                ),
              ],
            ),
            SizedBox(height: el(5)),
            const DocsApiTable(
              title: 'ElPopoverOriginModel',
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'anchor',
                  type: 'ElPopoverOriginModel',
                  description:
                      "The default. The zoom grows from a point on the "
                      "trigger's own centre line, measured from base-ui's "
                      'popups (the combobox, the date picker).',
                ),
                DocsApiFact(
                  name: 'corner',
                  type: 'ElPopoverOriginModel',
                  description:
                      "The zoom grows from the popup's own nearest corner "
                      "to the trigger: what every menu family's Radix "
                      'positioner measures instead.',
                ),
                DocsApiFact(
                  name: 'selfCenter',
                  type: 'ElPopoverOriginModel',
                  description:
                      "The popup's own middle, CSS's initial "
                      "transform-origin value, reached on the reference by "
                      'an unmatched Tailwind class rather than a deliberate '
                      'choice, and reproduced here as a named model rather '
                      'than a wrong side.',
                ),
              ],
            ),
            SizedBox(height: el(5)),
            const DocsApiTable(
              title: 'ElPopoverBarrier',
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'modal',
                  type: 'ElPopoverBarrier',
                  description:
                      'The default. An opaque layer under the popup, '
                      'nothing outside it can be hovered or clicked while '
                      "it is open, and a pointer there dismisses instead. "
                      "Every popover shipped in this port uses this.",
                ),
                DocsApiFact(
                  name: 'nonModal',
                  type: 'ElPopoverBarrier',
                  description:
                      "A translucent layer: an outside pointer both "
                      "dismisses and still reaches whatever it landed on. "
                      "What lets a menubar hand its open menu over to a "
                      'sibling trigger on hover.',
                ),
                DocsApiFact(
                  name: 'none',
                  type: 'ElPopoverBarrier',
                  description:
                      "No layer at all: a submenu. A layer here would sit "
                      "over the parent's own rows and a pointer moving "
                      "from the submenu back onto a sibling row would hit "
                      'the barrier instead of the row.',
                ),
              ],
            ),
          ],
        ),
      ),
      ElSection(
        id: 'api',
        title: 'API Reference',
        description:
            'Every public class, enum, top-level function, and constructor '
            'parameter the source declares.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const DocsApiTable(
              title: 'ElPopover',
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'open',
                  type: 'bool',
                  description:
                      'Required. Caller-owned, ElPopover mounts on the '
                      'frame after this turns true and unmounts after it '
                      'turns false and any exit animation finishes.',
                ),
                DocsApiFact(
                  name: 'anchor',
                  type: 'Widget',
                  description:
                      'Required. The trigger. Measured, never wrapped in a '
                      "gesture of its own: it renders verbatim and keeps "
                      'whatever onPressed the caller already gave it.',
                ),
                DocsApiFact(
                  name: 'content',
                  type: 'ElPopoverContentBuilder',
                  description:
                      'Required. Builds the popup from the metrics the '
                      "positioner knows about the trigger before the "
                      'popup itself is measured.',
                ),
                DocsApiFact(
                  name: 'side',
                  type: 'ElPopoverSide',
                  description:
                      'Default ElPopoverSide.bottom. Which edge of the '
                      'anchor the popup opens against.',
                ),
                DocsApiFact(
                  name: 'align',
                  type: 'ElPopoverAlign',
                  description:
                      'Default ElPopoverAlign.center. How the popup lines '
                      'up on the cross axis.',
                ),
                DocsApiFact(
                  name: 'sideOffset',
                  type: 'double',
                  description:
                      'Default 0. The gap between the anchor and the popup '
                      'along the main axis, 6px on the combobox '
                      "positioner, 4px on the date picker's.",
                ),
                DocsApiFact(
                  name: 'collisionPadding',
                  type: 'double',
                  description:
                      'Default 0. Minimum distance kept from every edge of '
                      'the overlay while placing and sizing the popup.',
                ),
                DocsApiFact(
                  name: 'animate',
                  type: 'bool',
                  description:
                      'Default true. Whether the fade/zoom/slide transition '
                      'runs at all. False is what ElNativeSelect mounts its '
                      "menu under: the popup appears whole, in one frame, "
                      'the way an operating-system picker does not zoom.',
                ),
                DocsApiFact(
                  name: 'animateOut',
                  type: 'bool',
                  description:
                      'Default true. Whether the exit half of that '
                      'transition exists. False unmounts the popup on the '
                      'frame open goes false: the one shipped consumer of '
                      'this is a menubar menu, which zooms in and simply '
                      'vanishes.',
                ),
                DocsApiFact(
                  name: 'origin',
                  type: 'ElPopoverOriginModel',
                  description:
                      'Default ElPopoverOriginModel.anchor. Whose '
                      'transform-origin model the zoom grows from.',
                ),
                DocsApiFact(
                  name: 'slideSides',
                  type: 'Set<ElPopoverSide>',
                  description:
                      'Default {ElPopoverSide.bottom}. The resolved sides '
                      "whose entrance carries a slide, travelling toward "
                      "the trigger's side.",
                ),
                DocsApiFact(
                  name: 'anchorPoint',
                  type: 'Offset?',
                  description:
                      'Default null. A virtual, zero-size anchor at this '
                      'point instead of the measured anchor box: how a '
                      'context menu opens at the pointer rather than at a '
                      "widget's corner. anchor still renders and is still "
                      'hit-tested; it is simply no longer the placement box.',
                ),
                DocsApiFact(
                  name: 'barrier',
                  type: 'ElPopoverBarrier',
                  description:
                      'Default ElPopoverBarrier.modal. What the popup lays '
                      'under itself to catch a pointer aimed elsewhere.',
                ),
                DocsApiFact(
                  name: 'onDismiss',
                  type: 'VoidCallback?',
                  description:
                      'Default null. Called on an outside pointer (unless '
                      'barrier is none) or on Escape while focus is '
                      'already inside the popup content.',
                ),
              ],
            ),
            SizedBox(height: el(5)),
            const DocsApiTable(
              title: 'ElPopoverSurface',
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'child',
                  type: 'Widget',
                  description: "Required. The popup's own content.",
                ),
                DocsApiFact(
                  name: 'radius',
                  type: 'BorderRadius?',
                  description:
                      'Default null, which resolves to '
                      'BorderRadius.circular(ElRadii.lg), 12px.',
                ),
                DocsApiFact(
                  name: 'shadow',
                  type: 'ElShadowSpec?',
                  description:
                      'Default null, which resolves to '
                      "ElShadows.tailwindMd. Every *SubContent in the menu "
                      'family passes shadow-lg here instead.',
                ),
                DocsApiFact(
                  name: 'ring',
                  type: 'bool',
                  description:
                      'Default true: a 1px theme.foreground at 10% alpha '
                      'ring. False for the one overlay in the corpus that '
                      "writes a real border instead of a ring "
                      '(ContextMenuSubContent).',
                ),
                DocsApiFact(
                  name: 'border',
                  type: 'BoxBorder?',
                  description:
                      'Default null. A real border, when a caller writes '
                      'one: it costs the box extra width the way '
                      'box-sizing: border-box does not.',
                ),
                DocsApiFact(
                  name: 'spec(theme)',
                  type: 'static ElShadowSpec',
                  description:
                      "The family's shared shadow-plus-ring recipe at its "
                      'defaults.',
                ),
                DocsApiFact(
                  name: 'specOf({shadow, ring})',
                  type: 'static ElShadowSpec',
                  description:
                      'The same recipe with either half swapped out: what '
                      'radius and shadow above are built from.',
                ),
              ],
            ),
            SizedBox(height: el(5)),
            const DocsApiTable(
              title: 'elPopoverPlacement(): the positioner',
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'anchor',
                  type: 'Rect',
                  description:
                      "Required. The trigger's box, in the overlay's "
                      'coordinate space.',
                ),
                DocsApiFact(
                  name: 'content',
                  type: 'Size',
                  description: "Required. The popup's own measured size.",
                ),
                DocsApiFact(
                  name: 'viewport',
                  type: 'Size',
                  description:
                      "Required. The overlay's own box: the collision "
                      'boundary.',
                ),
                DocsApiFact(
                  name: 'side',
                  type: 'ElPopoverSide',
                  description: 'Default ElPopoverSide.bottom.',
                ),
                DocsApiFact(
                  name: 'align',
                  type: 'ElPopoverAlign',
                  description: 'Default ElPopoverAlign.center.',
                ),
                DocsApiFact(
                  name: 'sideOffset',
                  type: 'double',
                  description: 'Default 0.',
                ),
                DocsApiFact(
                  name: 'collisionPadding',
                  type: 'double',
                  description: 'Default 0.',
                ),
                DocsApiFact(
                  name: 'origin',
                  type: 'ElPopoverOriginModel',
                  description: 'Default ElPopoverOriginModel.anchor.',
                ),
              ],
            ),
            SizedBox(height: el(5)),
            const DocsApiTable(
              title: 'ElPopoverPlacement (return value)',
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'offset',
                  type: 'Offset',
                  description:
                      "The popup's resolved top-left, in the overlay's "
                      'coordinate space.',
                ),
                DocsApiFact(
                  name: 'side',
                  type: 'ElPopoverSide',
                  description:
                      "The side it actually landed on: the requested "
                      'side, or its opposite when the flip fired.',
                ),
                DocsApiFact(
                  name: 'origin',
                  type: 'Alignment',
                  description:
                      'The resolved transform-origin the zoom grows from. '
                      'A value class with structural equality.',
                ),
              ],
            ),
            SizedBox(height: el(5)),
            const DocsApiTable(
              title: 'ElPopoverAnchorMetrics',
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'rect',
                  type: 'Rect',
                  description:
                      "The trigger's box, in the overlay's coordinate "
                      'space.',
                ),
                DocsApiFact(
                  name: 'viewport',
                  type: 'Size',
                  description: "The overlay's own box.",
                ),
                DocsApiFact(
                  name: 'availableWidth',
                  type: 'double',
                  description:
                      'How much horizontal room the collision boundary '
                      'leaves.',
                ),
                DocsApiFact(
                  name: 'availableHeight',
                  type: 'double',
                  description:
                      'How much room the requested side leaves, read '
                      'before the flip: the number a content builder '
                      'caps its own max height against, the way the '
                      "combobox popup's maxHeight does.",
                ),
                DocsApiFact(
                  name: 'anchorWidth',
                  type: 'double (get)',
                  description:
                      "rect.width. What the combobox popup's own width is "
                      'seeded from before its min-width override.',
                ),
              ],
            ),
            SizedBox(height: el(5)),
            const DocsApiTable(
              title: 'ElPopoverContentBuilder (typedef)',
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'content',
                  type: 'Widget Function(BuildContext, ElPopoverAnchorMetrics)',
                  description:
                      "The content parameter's own signature: the popup "
                      "is built from the caller's own build scope, so a "
                      'list that narrows on a keystroke narrows in the '
                      'same frame the keystroke was handled in.',
                ),
              ],
            ),
          ],
        ),
      ),
      ElSection(
        id: 'states',
        title: 'States',
        description:
            'ElPopover opens and closes on a caller-owned boolean, not on a '
            "pointer gesture of its own. Rows describing an internal "
            'trigger interaction are marked N/A for that reason rather than '
            'invented.',
        child: const DocsStateMatrix(
          facts: <DocsStateFact>[
            DocsStateFact(
              state: 'Rest',
              treatment:
                  'open is false: the OverlayPortal is not showing and '
                  'only anchor is mounted.',
              userSignal: 'Nothing besides the trigger itself is on screen.',
            ),
            DocsStateFact(
              state: 'Hover',
              treatment:
                  'N/A: anchor is rendered verbatim with no MouseRegion '
                  "or gesture of ElPopover's own added to it; a hover "
                  "effect on the trigger is entirely the caller's own "
                  'widget.',
              userSignal: 'N/A',
            ),
            DocsStateFact(
              state: 'Focus-visible',
              treatment:
                  'N/A on the trigger: same reason as Hover. Inside the '
                  'popup, Escape is wired only once something in content '
                  'already holds focus; see Accessibility below for what '
                  'that means in practice.',
              userSignal: 'N/A',
            ),
            DocsStateFact(
              state: 'Pressed',
              treatment:
                  "N/A, ElPopover applies no press paint of its own to "
                  "anchor; open is a prop the caller flips from whatever "
                  "gesture its own trigger widget already wires (a "
                  'ElButton onPressed, in every shipped consumer).',
              userSignal: 'N/A',
            ),
            DocsStateFact(
              state: 'Selected',
              treatment:
                  'N/A: open/closed is the only binary state this '
                  'primitive represents; there is no selection concept.',
              userSignal: 'N/A',
            ),
            DocsStateFact(
              state: 'Loading',
              treatment:
                  'N/A: content is built synchronously from the current '
                  'frame; there is no async step to represent.',
              userSignal: 'N/A',
            ),
            DocsStateFact(
              state: 'Empty',
              treatment:
                  'N/A: content is a required builder; the API has no '
                  'path to an empty popup to design for.',
              userSignal: 'N/A',
            ),
            DocsStateFact(
              state: 'Error',
              treatment:
                  'N/A: no validation or error state exists on this '
                  'component.',
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
                  'N/A, ElPopover has no enabled or disabled parameter; a '
                  'caller wanting a disabled trigger disables its own '
                  'anchor widget and never sets open to true.',
              userSignal: 'N/A',
            ),
            DocsStateFact(
              state: 'Reduced motion',
              treatment:
                  'The fade/zoom/slide transition runs through '
                  'elAnimationDuration, so its ElDurations.overlay '
                  'duration collapses to zero under reduced motion: the '
                  'same collapse animate and animateOut already model at '
                  'false.',
              userSignal:
                  'The popup still opens and closes instantly, without '
                  'animated travel.',
            ),
          ],
        ),
      ),
      ElSection(
        id: 'accessibility',
        title: 'Accessibility',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ElPanel(
              label: 'What the semantics tree actually carries',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const _A11yRow(
                    'Semantic role',
                    'ElPopover renders no Semantics node of its own: no '
                        'dialog or popup role, and no aria-expanded-style '
                        'relationship wired between anchor and its popup.',
                  ),
                  const _A11yRow(
                    'Required labels',
                    'None are set automatically. anchor keeps whatever '
                        'accessible name its own widget already carries; '
                        'content is arbitrary and must label itself.',
                  ),
                  const _A11yRow(
                    'Keyboard interactions',
                    'Escape closes the popup, but only once focus is '
                        'already inside content: key events travel up '
                        'from whichever node holds focus, and the Focus '
                        'ElPopover wraps around content only listens; it '
                        'never requests focus for itself '
                        '(canRequestFocus: false, skipTraversal: true).',
                  ),
                  const _A11yRow(
                    'Focus behavior',
                    "Focus is the content's own business, by design: the "
                        "source's own words. Nothing here moves focus into "
                        'the popup when it opens or restores it to anchor '
                        'when it closes; each real consumer decides for '
                        'itself (the combobox keeps the caret in its own '
                        "input while its popup is open; the date "
                        "picker's calendar carries autoFocus and takes "
                        'focus for itself).',
                  ),
                  const _A11yRow(
                    'Touch target',
                    'ElPopover adds no padding of its own around anchor; '
                        "the tap target is whatever the wrapped trigger "
                        'already provides.',
                  ),
                  const _A11yRow(
                    'Non-color signal',
                    "The popup's surface is a fixed fill and ring; nothing "
                        'here communicates information by color alone.',
                  ),
                  const _A11yRow(
                    'Error wiring',
                    'None, ElPopover never participates in form '
                        'validation or an error state of its own.',
                  ),
                  const _A11yRow(
                    'Screen-reader announcements',
                    'None. Opening or closing the overlay announces '
                        'nothing on its own; a screen-reader user learns '
                        'the popup opened only if content itself takes '
                        'focus or announces something.',
                  ),
                  _A11yRow(
                    'Known platform differences',
                    'None observed in the paint or gesture logic: the '
                        'barrier and layout code route on geometry and '
                        'ElPopoverBarrier, never on platform.',
                    last: true,
                  ),
                ],
              ),
            ),
            SizedBox(height: el(5)),
            ElNote(
              tone: ElNoteTone.error,
              title:
                  'Known gap, Escape does nothing unless a caller '
                  'moves focus itself',
              child: ElText(
                'Focus is the content’s business is a deliberate '
                'design decision, and it has a real cost this page '
                'reports plainly rather than glossing over: a caller who '
                'opens a popup and never calls requestFocus() on anything '
                'inside it gets no Escape-to-close path at all, because '
                'the key event has nowhere to travel up from. The two '
                'consumers this component ships for both handle it '
                '(the combobox keeps focus in its own input; the date '
                'picker autofocuses its calendar), but that handling is '
                'each consumer’s own responsibility, not something '
                'ElPopover verifies or falls back to. A caller building a '
                'new popup on top of this primitive must move focus into '
                'content itself, or Escape silently does nothing.',
                ElType.small,
              ),
            ),
          ],
        ),
      ),
      ElSection(
        id: 'responsive',
        title: 'Responsive',
        description:
            'The one behavior this primitive must not produce is a popup '
            'that hangs off the screen: the positioner runs a real '
            'flip-then-shift-then-clamp algorithm against the overlay’s '
            'own box on every layout pass, not a fixed offset.',
        child: ElPanel(
          label: 'The collision algorithm, as it actually runs',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ElText(
                "Main axis: the flip: elPopoverPlacement measures the "
                'room side leaves against the anchor and the collision '
                'boundary. If the requested side has enough room for the '
                "content's size, it is used as-is. If not, the opposite "
                'side is tried. If neither side has enough room, whichever '
                'of the two has more room wins, and the popup is capped '
                'instead, CustomSingleChildLayout constrains the popup to '
                'that available space rather than letting it overflow.',
                ElType.small,
              ),
              SizedBox(height: el(3)),
              ElText(
                'Cross axis: the shift: align places the popup relative '
                'to the anchor (leading edge, centred, or trailing edge), '
                'then the result is clamped back inside '
                'viewport − collisionPadding on both ends. A popup '
                'sliding along its trigger keeps it attached; the cross '
                'axis is never flipped, only shifted.',
                ElType.small,
              ),
              SizedBox(height: el(3)),
              ElText(
                'The result is reported back out as ElPopoverPlacement '
                'once layout knows it, on the next frame: a popup whose '
                'side flips therefore zooms from the requested corner for '
                'one frame and the resolved one for the rest of the '
                'transition; every popup on a page with room to spare is '
                'correct from the first frame.',
                ElType.small,
              ),
              SizedBox(height: el(3)),
              ElText(
                'None of this branches on platform or pointer kind: the '
                'same geometry runs whether the app is a phone, a tablet, '
                'or a desktop window, and content builders that want to '
                'respond to the room available read it themselves off '
                'ElPopoverAnchorMetrics.availableWidth / '
                'availableHeight, the way the combobox popup caps its own '
                'maxHeight against it.',
                ElType.small,
              ),
            ],
          ),
        ),
      ),
      ElSection(
        id: 'dependencies',
        title: 'Dependencies',
        description:
            "Elattar's own technical-transparency panel: what this "
            'component needs to install and run.',
        child: DocsInstallFacts(
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
              value: entry.dependencies.join(', '),
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
              label: 'Built on by',
              value:
                  'DropdownMenu, ContextMenu, Menubar, Menu, the agent '
                  'attach menu, Combobox, NativeSelect, the calendar date '
                  'picker, NavigationMenu',
              description:
                  'Every real ElPopover(...) call site in the package '
                  'source: mounts the widget directly and inherits its '
                  'placement, animation, and barrier behavior whole.',
            ),
            const DocsInstallFact(
              label: 'Reused in part by',
              value: 'ElSelect, HoverCard',
              description:
                  'Reuse elPopoverPlacement and/or ElPopoverSurface: the '
                  "positioning math and the paint: without mounting "
                  'ElPopover itself. HoverCard cannot: its outside-tap '
                  'barrier would fight a hover-driven open/close cycle.',
            ),
            const DocsInstallFact(
              label: 'Verified',
              value:
                  "test/selects_test.dart's ElPopover group, "
                  "test/menus_test.dart's ElPopover: what the menus "
                  'added group, plus this docs specimen',
              description:
                  'Package-level behavioral coverage: placement, the flip, '
                  'the barrier, and the four knobs the menu family added. '
                  'No fixture install was run as part of writing this '
                  'page.',
            ),
          ],
        ),
      ),
      ElSection(
        id: 'theming',
        title: 'Theming',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ElPanel(
              label: 'What actually varies with the theme',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ElText(
                    "ElPopoverSurface fills with theme.popover and inks "
                    "its text with theme.popoverForeground through a "
                    'DefaultTextStyle: content built inside content picks '
                    'this up automatically unless it overrides its own '
                    'color.',
                    ElType.small,
                  ),
                  SizedBox(height: el(3)),
                  ElText(
                    'The ring is a flat 10% of theme.foreground over the '
                    'shadow layer, on every instance that leaves ring at '
                    'its true default: the corner radius (ElRadii.lg, '
                    '12px) and the elevation (ElShadows.tailwindMd) are '
                    'each overridable per instance through radius and '
                    'shadow, unlike the fixed pill ElTooltip renders.',
                    ElType.small,
                  ),
                  SizedBox(height: el(3)),
                  ElText(
                    'The open/close transition: an 8px slide on whichever '
                    'sides slideSides names, a 95%→100% zoom, and a '
                    'fade: runs over ElDurations.overlay through '
                    'elAnimationDuration on ElCurves.out, so it resolves '
                    'instantly under reduced motion rather than being '
                    'skipped as a special case.',
                    ElType.small,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      ElSection(
        id: 'source',
        title: 'Source',
        child: DocsInstallFacts(
          title: 'Source and tests',
          facts: <DocsInstallFact>[
            DocsInstallFact(
              label: 'Source',
              value: entry.sourcePath,
              description: 'The authoritative package source.',
            ),
            const DocsInstallFact(
              label: 'GitHub',
              value:
                  'github.com/ELATTAR-Ayoub/flutter-design-system/blob/'
                  'main/lib/src/components/popover.dart',
              description: "The registry manifest's own sourceLink, verbatim.",
            ),
            const DocsInstallFact(
              label: 'Tests',
              value:
                  "test/selects_test.dart (ElPopover) and "
                  "test/menus_test.dart (ElPopover: what the menus added)",
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
}

const String _usageBasicCode = '''class _ShareButton extends StatefulWidget {
  const _ShareButton();
  @override
  State<_ShareButton> createState() => _ShareButtonState();
}

class _ShareButtonState extends State<_ShareButton> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return ElPopover(
      open: _open,
      onDismiss: () => setState(() => _open = false),
      anchor: ElButton(
        variant: ElButtonVariant.outline,
        label: 'Share',
        onPressed: () => setState(() => _open = !_open),
        child: const ElText('Share', ElComponentType.buttonLabel),
      ),
      content: (BuildContext context, ElPopoverAnchorMetrics metrics) =>
          ElPopoverSurface(
        child: Padding(
          padding: EdgeInsets.all(el(4)),
          child: const ElText('Share link content goes here.', ElType.small),
        ),
      ),
    );
  }
}''';

const String _usageAnchorPointCode =
    '''// A context menu has no trigger box to anchor to, Radix anchors it to a
// virtual element at the pointer instead, which is what anchorPoint is for.
ElPopover(
  open: _at != null,
  anchorPoint: _at,
  side: ElPopoverSide.right,
  align: ElPopoverAlign.start,
  origin: ElPopoverOriginModel.corner,
  onDismiss: _close,
  anchor: Listener(
    onPointerDown: (PointerDownEvent event) {
      if (event.buttons == kSecondaryMouseButton) {
        setState(() => _at = event.position);
      }
    },
    child: content,
  ),
  content: (BuildContext context, ElPopoverAnchorMetrics metrics) =>
      ElPopoverSurface(child: menuRows),
)''';

const String _usageNonModalCode =
    '''// A menubar's own menus hand over to a sibling trigger on hover: a modal
// barrier would swallow that hover before it ever reached the next trigger.
ElPopover(
  open: _openIndex == index,
  barrier: ElPopoverBarrier.nonModal,
  onDismiss: () => setState(() => _openIndex = null),
  anchor: menuTrigger,
  content: (BuildContext context, ElPopoverAnchorMetrics metrics) =>
      ElPopoverSurface(child: menuRows),
)''';

const String _compositionCode = '''input = ElPopover(
  open: _open && _enabled,
  side: ElPopoverSide.bottom,
  align: ElPopoverAlign.start,
  sideOffset: ElCombobox.popupOffset,
  collisionPadding: el(2),
  onDismiss: () => _closePopup(),
  anchor: input,
  content: (BuildContext context, ElPopoverAnchorMetrics metrics) =>
      _ComboboxPopup<T>(
    width: metrics.anchorWidth + ElCombobox.popupOvershoot,
    maxHeight: math.min(
      ElCombobox.listMaxHeight,
      metrics.availableHeight - el(9),
    ),
    items: visible,
    // ...
  ),
);''';

class _A11yRow extends StatelessWidget {
  const _A11yRow(this.label, this.body, {this.last = false});

  final String label;
  final String body;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : el(3)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ElText(label, ElType.section, color: theme.actionInk),
          SizedBox(height: el(1)),
          ElText(body, ElType.small),
        ],
      ),
    );
  }
}

/// The live specimen: a trigger that owns its own `open` state, and a
/// popup with real interactive content anchored to it: a genuine
/// [ElPopover] mounted through a real [Overlay], not a static illustration.
class _PopoverPreview extends StatefulWidget {
  const _PopoverPreview();

  @override
  State<_PopoverPreview> createState() => _PopoverPreviewState();
}

class _PopoverPreviewState extends State<_PopoverPreview> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ElText('Bottom side, start aligned', ElType.section),
        SizedBox(height: el(3)),
        ElPopover(
          open: _open,
          side: ElPopoverSide.bottom,
          align: ElPopoverAlign.start,
          sideOffset: el(2),
          collisionPadding: el(2),
          onDismiss: () => setState(() => _open = false),
          anchor: ElButton(
            key: const ValueKey<String>('popover-doc-specimen-trigger'),
            variant: ElButtonVariant.outline,
            size: ElButtonSize.md,
            label: 'Open popover',
            onPressed: () => setState(() => _open = !_open),
            child: ElText('Open popover', ElComponentType.buttonLabel),
          ),
          content: (BuildContext context, ElPopoverAnchorMetrics metrics) =>
              ElPopoverSurface(
                child: Container(
                  key: const ValueKey<String>('popover-doc-specimen-content'),
                  width: metrics.anchorWidth < el(70)
                      ? el(70)
                      : metrics.anchorWidth,
                  padding: EdgeInsets.all(el(4)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ElText(
                        'Update dimensions',
                        ElType.section,
                        color: theme.popoverForeground,
                      ),
                      SizedBox(height: el(1)),
                      ElText(
                        'Set the exact width and height for the selection.',
                        ElType.small,
                        color: theme.mutedForeground,
                      ),
                      SizedBox(height: el(4)),
                      const ElInput(label: 'Width', initialValue: '100%'),
                      SizedBox(height: el(3)),
                      const ElInput(label: 'Height', initialValue: '25px'),
                      SizedBox(height: el(4)),
                      ElButton(
                        variant: ElButtonVariant.secondary,
                        size: ElButtonSize.sm,
                        expanded: true,
                        label: 'Done',
                        onPressed: () => setState(() => _open = false),
                        child: ElText('Done', ElComponentType.buttonLabel),
                      ),
                    ],
                  ),
                ),
              ),
        ),
        SizedBox(height: el(6)),
        ElText(
          'Tap the trigger to open it; tap anywhere outside the popup, or '
          'press Escape once focus is inside it, to dismiss it.',
          ElType.small,
          color: theme.mutedForeground,
        ),
      ],
    );
  }
}
