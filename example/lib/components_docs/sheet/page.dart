/// Public component documentation for the paired sheet and drawer components.
///
/// One page, one [ComponentDocEntry] ([sheetDoc]) — see `meta.dart`'s library
/// doc for why. Both `lib/src/components/sheet.dart` and
/// `lib/src/components/drawer.dart` are read here and never modified.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/docs_code.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../kit.dart';
import '../catalog.dart';
import 'meta.dart';

class SheetDocPage extends StatelessWidget {
  const SheetDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) {
    final ComponentDocEntry entry = sheetDoc;
    return DocsLayout(
      route: entry.route,
      intro: DocsPageIntro(
        eyebrow: 'COMPONENTS / OVERLAYS',
        title: entry.title,
        description: entry.description,
      ),
      breadcrumbs: const <DsBreadcrumbEntry>[
        DsBreadcrumbEntry.link('Components'),
        DsBreadcrumbEntry.page('Sheet & Drawer'),
      ],
      toc: const <DocsTocEntry>[
        DocsTocEntry(title: 'Purpose', anchor: 'purpose'),
        DocsTocEntry(title: 'Status', anchor: 'status'),
        DocsTocEntry(title: 'Preview', anchor: 'preview'),
        DocsTocEntry(title: 'Installation', anchor: 'install'),
        DocsTocEntry(title: 'Usage', anchor: 'usage'),
        DocsTocEntry(title: 'API', anchor: 'api'),
        DocsTocEntry(title: 'Variants and sizes', anchor: 'variants'),
        DocsTocEntry(title: 'States', anchor: 'states'),
        DocsTocEntry(title: 'Accessibility', anchor: 'accessibility'),
        DocsTocEntry(title: 'Responsive behavior', anchor: 'responsive'),
        DocsTocEntry(title: 'Dependencies', anchor: 'dependencies'),
        DocsTocEntry(title: 'Composition', anchor: 'composition'),
        DocsTocEntry(title: 'Theming', anchor: 'theming'),
        DocsTocEntry(title: 'Source', anchor: 'source'),
      ],
      // Dialog is this page's real, already-routed neighbour (Phase F); the
      // reverse link lives on dialog_page.dart's own future edit, not here —
      // this worker never touches that file. Sidebar is the next overlay/nav
      // family member alphabetically in the Wave 3 plan, wired once the
      // supervisor routes it.
      previous: const DocsPageLink(
        title: 'Dialog',
        route: '/components/dialog',
      ),
      next: const DocsPageLink(title: 'Sidebar', route: '/components/sidebar'),
      onNavigate: onNavigate,
      child: const _SheetDrawerArticle(),
    );
  }
}

class _SheetDrawerArticle extends StatelessWidget {
  const _SheetDrawerArticle();

  @override
  Widget build(BuildContext context) => Column(
    key: const ValueKey<String>('sheet-doc-article'),
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      DsSection(
        id: 'purpose',
        title: 'When to reach for it',
        description: sheetExpandedDescription,
        child: const _DecisionGuide(),
      ),
      SizedBox(height: ds(2)),
      DsSection(
        id: 'status',
        title: 'Status',
        child: const DocsInstallFacts(
          title: 'Status',
          facts: <DocsInstallFact>[
            DocsInstallFact(
              label: 'Status',
              value: 'Experimental',
              description:
                  'No registry manifest yet for either component — see '
                  'Installation below for what that does and does not '
                  'block.',
            ),
            DocsInstallFact(
              label: 'Version',
              value: '0.0.1',
              description: 'Tracks the package version this page ships with.',
            ),
            DocsInstallFact(
              label: 'Platforms',
              value: 'Android, iOS, Web, macOS, Windows, Linux',
              description:
                  'Pure widgets layer — no platform channel of its own, so '
                  'behavior does not vary by platform. Drawer\'s drag '
                  'gesture uses PointerDeviceKind-agnostic drag recognizers, '
                  'so mouse and touch both drive it.',
            ),
          ],
        ),
      ),
      SizedBox(height: ds(2)),
      DsSection(
        id: 'preview',
        title: 'Live preview',
        description:
            'Every edge DsSheetOverlay actually supports, plus the '
            'draggable bottom drawer. Open one, then dismiss it by tapping '
            'the scrim, pressing Escape, the close button (sheet only), or '
            '— drawer only — dragging it down past the threshold.',
        child: DocsCodeExample(
          title: 'Sheet and drawer specimens',
          description:
              'Four DsSheetOverlay triggers, one per DsSheetSide value, and '
              'one DsDrawer trigger.',
          preview: const _SheetDrawerPreview(),
          manualFiles: const <DocsCodeFile>[
            DocsCodeFile(path: 'sheet_preview.dart', code: _sheetUsageCode),
            DocsCodeFile(path: 'drawer_preview.dart', code: _drawerUsageCode),
          ],
        ),
      ),
      SizedBox(height: ds(2)),
      DsSection(
        id: 'install',
        title: 'Installation',
        description:
            'Both components are already reachable today through the '
            'published package — they are exported from the barrel — but '
            'neither is yet installable through the elattar CLI.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DsPanel(
              label: 'PACKAGE IMPORT',
              note: 'DART',
              child: const DocsSelectableCodeBlock(
                code:
                    "import 'package:elattar_design_system/"
                    "elattar_design_system.dart';\n",
              ),
            ),
            SizedBox(height: ds(4)),
            DocsInstallFacts(
              title: 'Manual and CLI facts',
              facts: <DocsInstallFact>[
                const DocsInstallFact(
                  label: 'CLI',
                  value: 'Not available yet',
                  description:
                      'Neither sheet nor drawer has a registry/components '
                      'manifest, so "elattar add sheet" and "elattar add '
                      'drawer" both fail today. Use the package import '
                      'above, or copy the source files manually, in the '
                      'meantime.',
                ),
                DocsInstallFact(
                  label: 'Manual copy target — sheet',
                  value: 'lib/components/ui/sheet.dart',
                  description:
                      'Copy ${sheetDoc.sourcePath} into components/ui and keep '
                      'its relative imports pointed at the same foundation '
                      'and sibling-component files (dialog.dart in '
                      'particular — see Dependencies).',
                ),
                const DocsInstallFact(
                  label: 'Manual copy target — drawer',
                  value: 'lib/components/ui/drawer.dart',
                  description:
                      'Copy $drawerSourcePath alongside it, for the same '
                      'reason.',
                ),
                DocsInstallFact(
                  label: 'Registry dependencies',
                  value: sheetDoc.dependencies.join(', '),
                  description:
                      'What a future registry manifest would need to list '
                      'as registryDependencies, resolved by hand today.',
                ),
              ],
            ),
          ],
        ),
      ),
      SizedBox(height: ds(2)),
      DsSection(
        id: 'usage',
        title: 'Usage',
        description:
            'Both are uncontrolled, like DsDialog: the open/close boolean '
            'lives inside DsModalPortal and the trigger only ever gets a '
            'callback. Neither DsSheetOverlay nor DsDrawer exposes an '
            'onOpenChange callback the way DsDialog does — that is a real '
            'gap against the dialog\'s own API, not an omission from this '
            'page.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DsPanel(
              label: 'DART',
              note: 'SHEET — MINIMAL USAGE',
              child: const DocsSelectableCodeBlock(code: _sheetUsageCode),
            ),
            SizedBox(height: ds(4)),
            DsPanel(
              label: 'DART',
              note: 'DRAWER — MINIMAL USAGE',
              child: const DocsSelectableCodeBlock(code: _drawerUsageCode),
            ),
          ],
        ),
      ),
      SizedBox(height: ds(2)),
      DsSection(
        id: 'api',
        title: 'API',
        description:
            'Every public constructor parameter on every public class in '
            'both source files.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const DocsApiTable(
              title: 'DsSheetOverlay — the general-purpose sheet',
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'trigger',
                  type: 'DsModalTriggerBuilder',
                  description: 'Builds the control that opens the portal.',
                ),
                DocsApiFact(
                  name: 'content',
                  type: 'DsModalContentBuilder',
                  description:
                      'Builds the panel and receives its close callback.',
                ),
                DocsApiFact(
                  name: 'side',
                  type: 'DsSheetSide',
                  description:
                      'Which edge the panel anchors to. Defaults '
                      'to DsSheetSide.right, the component\'s own default.',
                ),
              ],
            ),
            SizedBox(height: ds(4)),
            const DocsApiTable(
              title: 'DsSheetContent — the panel',
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'children',
                  type: 'List<Widget>',
                  description:
                      'The column\'s contents, in order. A DsSheetFooter '
                      'among them is pushed to the bottom automatically.',
                ),
                DocsApiFact(
                  name: 'side',
                  type: 'DsSheetSide',
                  description:
                      'Which edge to render the panel against. Defaults to '
                      'DsSheetSide.right.',
                ),
                DocsApiFact(
                  name: 'showCloseButton',
                  type: 'bool',
                  description:
                      'Adds the labelled X in the corner; defaults to true.',
                ),
                DocsApiFact(
                  name: 'onClose',
                  type: 'VoidCallback?',
                  description: 'Wired by DsSheetOverlay; the X calls it.',
                ),
                DocsApiFact(
                  name: 'width',
                  type: 'double?',
                  description:
                      'Overrides the 384px default on a horizontal side. '
                      'One real consumer in the corpus: the mobile '
                      'sidebar\'s left sheet passes 288 here instead of the '
                      '384 default.',
                ),
                DocsApiFact(
                  name: 'fill',
                  type: 'Color?',
                  description:
                      'Overrides the panel\'s theme.popover background.',
                ),
              ],
            ),
            SizedBox(height: ds(4)),
            const DocsApiTable(
              title:
                  'Sheet anatomy — DsSheetHeader, DsSheetFooter, '
                  'DsSheetTitle, DsSheetDescription',
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'children',
                  type: 'List<Widget> (DsSheetHeader)',
                  description: 'The header\'s stacked contents.',
                ),
                DocsApiFact(
                  name: 'children',
                  type: 'List<Widget> (DsSheetFooter)',
                  description:
                      'The footer\'s stacked CTAs — a column, unlike '
                      'DsDialogFooter\'s row, because a sheet\'s actions '
                      'stack.',
                ),
                DocsApiFact(
                  name: 'text',
                  type: 'String (DsSheetTitle, positional)',
                  description: 'The title\'s only content.',
                ),
                DocsApiFact(
                  name: 'text',
                  type: 'String (DsSheetDescription, positional)',
                  description: 'The description\'s only content.',
                ),
              ],
            ),
            SizedBox(height: ds(4)),
            const DocsApiTable(
              title: 'DsDrawer — the draggable bottom panel',
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'trigger',
                  type: 'DsModalTriggerBuilder',
                  description: 'Builds the control that opens the portal.',
                ),
                DocsApiFact(
                  name: 'content',
                  type: 'DsModalContentBuilder',
                  description:
                      'Builds the panel and receives its close callback. '
                      'DsDrawer wraps the built content in its own drag '
                      'gesture detector before mounting it.',
                ),
              ],
            ),
            SizedBox(height: ds(4)),
            const DocsApiTable(
              title: 'DsDrawerContent and its anatomy',
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'children',
                  type: 'List<Widget> (DsDrawerContent)',
                  description:
                      'The column\'s contents. A DsDrawerHandle is '
                      'prepended automatically — it is not one of these '
                      'children and cannot be turned off.',
                ),
                DocsApiFact(
                  name: 'children',
                  type: 'List<Widget> (DsDrawerHeader)',
                  description:
                      'Centred, unlike the sheet\'s left-aligned '
                      'header.',
                ),
                DocsApiFact(
                  name: 'children',
                  type: 'List<Widget> (DsDrawerFooter)',
                  description: 'The footer\'s stacked CTAs.',
                ),
                DocsApiFact(
                  name: 'text',
                  type: 'String (DsDrawerTitle, positional)',
                  description: 'The title\'s only content, centre-aligned.',
                ),
                DocsApiFact(
                  name: 'text',
                  type: 'String (DsDrawerDescription, positional)',
                  description:
                      'The description\'s only content, centre-aligned.',
                ),
              ],
            ),
            SizedBox(height: ds(4)),
            const _NoConstructorParamsNote(
              title: 'DsDrawerHandle',
              note:
                  'Takes no constructor parameters. It is the grip — width '
                  'and height are fixed statics, not per-instance options — '
                  'see Variants and sizes.',
            ),
            SizedBox(height: ds(4)),
            const DocsApiTable(
              title:
                  'DsSheet.showLeft and DsSheetPanel — the mobile '
                  'navigation opener',
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'builder',
                  type: 'WidgetBuilder (DsSheet.showLeft)',
                  description:
                      'Builds the sheet\'s content. showLeft is a static '
                      'method, not a widget — it pushes a Navigator route '
                      'and returns a Future<void> that completes on close.',
                ),
                DocsApiFact(
                  name: 'width',
                  type: 'double (DsSheet.showLeft / DsSheetPanel)',
                  description:
                      'Defaults to DsWidths.sidebarMobile (288). On '
                      'DsSheetPanel it is required, not defaulted.',
                ),
                DocsApiFact(
                  name: 'showCloseButton',
                  type: 'bool (DsSheet.showLeft / DsSheetPanel)',
                  description: 'Defaults to true on both.',
                ),
                DocsApiFact(
                  name: 'child',
                  type: 'Widget (DsSheetPanel)',
                  description: 'The panel\'s content, required.',
                ),
              ],
            ),
            SizedBox(height: ds(4)),
            const _DecisionNote(
              text:
                  'DsSheet.showLeft and DsSheetPanel are a separate, '
                  'route-based (Navigator.push) left-edge opener that the '
                  'site\'s own mobile navigation uses — not the general-'
                  'purpose, portal-based Sheet documented as the primary '
                  'specimen above, even though both share this file and '
                  'the "Sheet" name. They are listed here for completeness '
                  'because they are public API in the same source file, '
                  'not because a typical caller should reach for them over '
                  'DsSheetOverlay.',
            ),
            SizedBox(height: ds(4)),
            const DocsApiTable(
              title:
                  'DsSheetTransition and DsSheetContentGroup — internal '
                  'wiring, exposed publicly',
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'animation',
                  type: 'Animation<double> (DsSheetTransition)',
                  description:
                      'The enter/exit driver DsSheetOverlay wires '
                      'in; not something a typical caller constructs.',
                ),
                DocsApiFact(
                  name: 'side',
                  type: 'DsSheetSide (DsSheetTransition)',
                  description:
                      'Which axis and direction to translate '
                      'along.',
                ),
                DocsApiFact(
                  name: 'child',
                  type: 'Widget (DsSheetTransition)',
                  description: 'The content being animated.',
                ),
                DocsApiFact(
                  name: 'showCloseButton',
                  type: 'bool (DsSheetContentGroup)',
                  description:
                      'The InheritedWidget DsSheetHeader reads its '
                      'close-button reservation off; set by DsSheetContent.',
                ),
                DocsApiFact(
                  name: 'child',
                  type: 'Widget (DsSheetContentGroup, via super.child)',
                  description: 'The subtree the group scopes over.',
                ),
              ],
            ),
          ],
        ),
      ),
      SizedBox(height: ds(2)),
      DsSection(
        id: 'variants',
        title: 'Variants and sizes',
        description:
            'DsSheetSide is Sheet\'s one variant axis. Drawer has none — it '
            'is always the bottom, and DsSheetSide.bottom is NOT the same '
            'component: a bottom-side Sheet has no grip handle and no drag '
            'gesture, and animates on the 320ms overlay ease-out curve, '
            'not vaul\'s 500ms cubic-bezier. Sheet and Drawer are two '
            'separate implementations, not one widget with a side '
            'parameter.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const DocsApiTable(
              title: 'DsSheetSide (enum)',
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'top',
                  type: 'DsSheetSide',
                  description: 'Panel spans the top edge, sized by height.',
                ),
                DocsApiFact(
                  name: 'right',
                  type: 'DsSheetSide',
                  description:
                      'The component\'s own default. Panel pins to the '
                      'trailing edge, sized by width.',
                ),
                DocsApiFact(
                  name: 'bottom',
                  type: 'DsSheetSide',
                  description:
                      'Panel spans the bottom edge, sized by '
                      'height. Not the same as Drawer — see above.',
                ),
                DocsApiFact(
                  name: 'left',
                  type: 'DsSheetSide',
                  description:
                      'Panel pins to the leading edge, sized by '
                      'width.',
                ),
                DocsApiFact(
                  name: 'isHorizontal',
                  type: 'bool getter',
                  description:
                      'True for left and right — the sides whose '
                      'panel is sized by width rather than height.',
                ),
              ],
            ),
            SizedBox(height: ds(4)),
            const DocsApiTable(
              title: 'Fixed layout tokens (not variants)',
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'DsSheetContent.maxWidth',
                  type: 'static double',
                  description:
                      '384px — the horizontal panel\'s default '
                      'width before the width override or the phone clamp.',
                ),
                DocsApiFact(
                  name: 'DsSheetContent.gap',
                  type: 'static double',
                  description: '16px between children in the column.',
                ),
                DocsApiFact(
                  name: 'DsSheetContent.widthFor(width, viewport)',
                  type: 'static double Function(double, Size)',
                  description:
                      'Clamps a horizontal panel to 90% of viewport width '
                      'at or below the 600px compact breakpoint.',
                ),
                DocsApiFact(
                  name: 'DsSheetTransition.fraction',
                  type: 'static double',
                  description:
                      '0.1 — the enter/exit travel, as a fraction of the '
                      'panel\'s own size on its axis.',
                ),
                DocsApiFact(
                  name: 'DsDrawerContent.topGutter',
                  type: 'static double',
                  description:
                      '96px — the strip of page the drawer may never '
                      'cover, even at its tallest.',
                ),
                DocsApiFact(
                  name: 'DsDrawerContent.maxHeightFraction',
                  type: 'static const double',
                  description:
                      '0.8 — the panel never exceeds 80% of the '
                      'viewport height.',
                ),
                DocsApiFact(
                  name: 'DsDrawerContent.radius',
                  type: 'static double',
                  description: 'DsRadii.xl — the top corners only.',
                ),
                DocsApiFact(
                  name: 'DsDrawerHandle.width',
                  type: 'static double',
                  description: '96px grip width.',
                ),
                DocsApiFact(
                  name: 'DsDrawerHandle.height',
                  type: 'static double',
                  description: '4px grip height.',
                ),
              ],
            ),
          ],
        ),
      ),
      SizedBox(height: ds(2)),
      DsSection(
        id: 'states',
        title: 'States',
        child: const DocsStateMatrix(
          facts: <DocsStateFact>[
            DocsStateFact(
              state: 'Closed',
              treatment: 'Portal content is not mounted on either.',
              userSignal: 'Trigger remains available.',
            ),
            DocsStateFact(
              state: 'Open — Sheet',
              treatment:
                  'Scrim fades in on --duration-overlay (320ms); panel '
                  'slides in 10% of its own size on the same clock and '
                  '--ease-out, fading in alongside it.',
              userSignal: 'Title, description, and CTAs are visible.',
            ),
            DocsStateFact(
              state: 'Open — Drawer',
              treatment:
                  'Scrim and panel both animate over 500ms on vaul\'s own '
                  'cubic-bezier(0.32, 0.72, 0, 1) — a different clock and '
                  'curve from every other overlay in the system.',
              userSignal:
                  'The grip handle signals the drawer is '
                  'draggable before the user touches it.',
            ),
            DocsStateFact(
              state: 'Dragging — Drawer only',
              treatment:
                  'The panel follows the pointer 1:1, downward only — an '
                  'upward drag is clamped to zero, since a bottom panel has '
                  'nowhere further to go.',
              userSignal:
                  'Releasing past 25% of the panel\'s own height closes it; '
                  'short of that, it springs back open.',
            ),
            DocsStateFact(
              state: 'Escape / back',
              treatment:
                  'Both dismiss on Escape (DsModalPortal\'s FocusScope) and '
                  'on Android back / predictive back (the shared PopScope '
                  'stack) — see Accessibility.',
              userSignal: 'The page remains in place.',
            ),
            DocsStateFact(
              state: 'Scrim tap',
              treatment:
                  'Both dismiss on a tap outside the panel — neither sets '
                  'dismissOnOverlayTap to false, so DsModalPortal\'s '
                  'true default applies to each.',
              userSignal: 'Any tap outside the panel closes it.',
            ),
            DocsStateFact(
              state: 'Long content',
              treatment:
                  'Neither DsSheetContent nor DsDrawerContent wraps its '
                  'body children in a Flexible + SingleChildScrollView the '
                  'way DsDialogContent does. DsDrawerContent additionally '
                  'clips to its own 80vh cap. A caller with content taller '
                  'than the panel needs to wrap the middle children in a '
                  'Scrollable itself.',
              userSignal:
                  'Overflow is a real risk on a short viewport unless the '
                  'caller adds their own scroll region — this is a gap '
                  'against DsDialogContent\'s built-in scrolling body, not '
                  'a designed behavior.',
            ),
            DocsStateFact(
              state: 'Disabled — N/A',
              treatment:
                  'Neither component exposes an enabled/disabled '
                  'parameter of its own.',
              userSignal:
                  'A caller wanting a disabled trigger gates DsButton\'s '
                  'own onPressed outside these widgets.',
            ),
            DocsStateFact(
              state: 'Loading / Empty / Error / Success — N/A',
              treatment:
                  'Both are structural overlays with no async or '
                  'validation concept of their own.',
              userSignal:
                  'None of the four states apply to either '
                  'primitive directly.',
            ),
            DocsStateFact(
              state: 'Reduced motion',
              treatment:
                  'Both ride DsModalPortal, whose durations resolve '
                  'through dsAnimationDuration(context, ...) — collapsing '
                  'to zero under the platform\'s disable-animations flag.',
              userSignal: 'Transitions still happen, instantly, on both.',
            ),
          ],
        ),
      ),
      SizedBox(height: ds(2)),
      DsSection(
        id: 'accessibility',
        title: 'Accessibility',
        description:
            'Verified against the real DsModalPortal implementation both '
            'components ride, not against ideal overlay behavior — see the '
            'live focus test in sheet_test.dart.',
        child: const _Bullets(
          items: <String>[
            'Focus moves INTO the panel on open: DsModalPortal wraps the '
                'content in FocusScope(autofocus: true), so the '
                'FocusScopeNode itself (not a leaf widget) claims primary '
                'focus the moment the overlay mounts.',
            'Focus is trapped while open in the sense that matters for '
                'Tab traversal: once Tab moves focus to a real control '
                'inside the panel, further presses cycle inside the panel '
                'rather than reaching page content behind the scrim.',
            'Confirmed by a live test rather than assumed: closing '
                'DOES return focus to the trigger that opened the overlay, '
                'even though DsModalPortal contains no explicit "restore '
                'focus" code of its own. That is Flutter\'s FocusManager '
                'falling back to the enclosing scope\'s previously-focused '
                'child once the overlay\'s own FocusScope is removed from '
                'the tree — it holds as long as the trigger\'s FocusNode is '
                'still mounted when the overlay closes, and is not '
                'something either sheet.dart or drawer.dart wires itself.',
            'Escape closes the topmost open overlay (DsModalPortalState\'s '
                'static stack), matching dialog\'s own Escape contract.',
            'Android back / predictive back dismisses the topmost overlay '
                'unconditionally — the same USER-ORDERED MOBILE ADAPTATION '
                'dialog.dart documents, shared by every DsModalPortal '
                'consumer including these two.',
            'Neither DsSheetContent nor DsDrawerContent wraps its body in '
                'a Semantics(scopesRoute: true) / named-route announcement '
                'the way a platform sheet sheet/dialog convention would; '
                'DsSheetTitle and DsSheetDescription are plain DsText, not '
                'wired to the panel as an accessible name/description pair.',
            'Sheet\'s close button carries an explicit accessible label '
                '("Close") via DsButton\'s own label parameter. Drawer has '
                'no built-in close button at all — a caller must compose '
                'one (as the live specimen above does) and give it its own '
                'label.',
            'DsSheetContent insets its body from the device\'s safe areas '
                'via DsSafeArea, per side. DsDrawerContent does NOT use '
                'DsSafeArea anywhere — a real gap: on a device with a '
                'bottom home indicator, drawer content is not inset from '
                'it the way sheet content is from its own edges.',
            'Touch target: the grip handle DsDrawerHandle renders is 96 x '
                '4 logical pixels — far under any reasonable touch-target '
                'guidance on its own. The full-width lane it sits in (the '
                'whole top strip of the panel) is what actually receives '
                'the drag gesture, not the visible bar.',
          ],
        ),
      ),
      SizedBox(height: ds(2)),
      DsSection(
        id: 'responsive',
        title: 'Responsive behavior',
        child: const _Bullets(
          items: <String>[
            'Both opt OUT of DsModalPortal\'s compact viewport clamp '
                '(clampToViewport: false) — a centred dialog is capped to '
                '90vw x 75vh on a phone, but an edge-anchored panel is '
                'already viewport-relative by definition, so that cap '
                'would crop it instead of protecting it.',
            'Sheet clamps its own horizontal width instead, through '
                'DsSheetContent.widthFor: 384px everywhere above the '
                '600px compact breakpoint, 90% of viewport width at or '
                'below it.',
            'Drawer clamps its own height instead: max-height is always '
                '80% of the viewport, on every screen size, with a fixed '
                '96px top gutter it may never cover.',
            'A vertical Sheet (top or bottom) has no analogous height '
                'clamp of its own — its content sizes the panel directly, '
                'so tall content on a short viewport can overflow (see '
                'the "Long content" state above).',
            'Drawer\'s body is deliberately NOT independently scrollable: '
                'a nested Scrollable would win the gesture arena against '
                'the drag-to-dismiss recognizer wrapped around the whole '
                'panel. vaul\'s own answer — only drag when the inner '
                'scroller is already at its top — is not ported.',
          ],
        ),
      ),
      SizedBox(height: ds(2)),
      DsSection(
        id: 'dependencies',
        title: 'Dependencies, files, and assets',
        child: DocsInstallFacts(
          title: 'Dependencies',
          facts: <DocsInstallFact>[
            DocsInstallFact(
              label: 'Files',
              value: '${sheetDoc.sourcePath}, $drawerSourcePath',
              description: 'Two source files, one page.',
            ),
            const DocsInstallFact(
              label: 'Component dependencies',
              value:
                  'dialog (DsModalPortal, DsModalTriggerBuilder, '
                  'DsModalContentBuilder, DsModalCompact, DsDialogOverlay), '
                  'button (DsButton — sheet\'s close affordance only), '
                  'icon (the X glyph — sheet only)',
              description:
                  'Sibling components imported directly. Drawer '
                  'imports only dialog.dart — it pulls in neither button '
                  'nor icon, matching its lack of a built-in close button.',
            ),
            const DocsInstallFact(
              label: 'Foundation dependencies',
              value: 'source-foundation, ds-safe-area',
              description:
                  'Motion, shadows, spacing, theme, typography — and '
                  'ds-safe-area, imported by sheet.dart only (see the '
                  'Accessibility gap above for what that means for '
                  'drawer).',
            ),
            const DocsInstallFact(
              label: 'Assets, fonts, shaders',
              value: 'None',
              description:
                  'No image, font, or shader assets. Drawer\'s motion is '
                  'the one exception worth flagging even though it needs '
                  'no asset: it is driven by DsCurves.vaul and '
                  'DsDurations.drawer rather than the shared overlay '
                  'tokens every other DsModalPortal consumer uses.',
            ),
          ],
        ),
      ),
      SizedBox(height: ds(2)),
      DsSection(
        id: 'composition',
        title: 'Composition',
        description:
            'children accepts any Widget, not just header/footer/title/'
            'description — the reference\'s own filter and card-action '
            'sheets on the dialogs page (example/lib/pages/dialogs.dart) '
            'put a live DsSlider and a set of DsCheckboxes straight inside '
            'a DsSheetContent.',
        child: DsPanel(
          label: 'DART',
          note: 'REAL EXCERPT — dialogs.dart\'s filter sheet',
          child: const DocsSelectableCodeBlock(code: _compositionCode),
        ),
      ),
      SizedBox(height: ds(2)),
      DsSection(
        id: 'theming',
        title: 'Theming notes',
        child: const _Bullets(
          items: <String>[
            'theme.popover fills both panels by default; DsSheetContent\'s '
                'fill parameter is the only override point — Drawer has no '
                'equivalent, always theme.popover.',
            'theme.border paints the single hairline seam each panel '
                'carries on the edge it detaches from the page along — '
                'right sheet: left edge; drawer: top edge; and so on.',
            'DsShadows.tailwindLg is the one elevation layer both panels '
                'render, on the same shadow spec dialog\'s content uses.',
            'theme.muted at the system\'s standard 0.5 alpha bands '
                'DsSheetHeader and DsSheetFooter — the same muted-band '
                'anatomy DsDialogHeader/DsDialogFooter use. DsDrawerHeader '
                'and DsDrawerFooter carry NO such band — they are plain '
                'padded columns with no fill or rule of their own, a real '
                'anatomy difference from Sheet worth knowing before '
                'assuming visual parity between the two families.',
            'DsRadii.xl rounds only Drawer\'s top corners (rounded-t-xl); '
                'Sheet has no radius at all — every side is a hard-edged '
                'rectangle flush with the viewport edge.',
          ],
        ),
      ),
      SizedBox(height: ds(2)),
      DsSection(
        id: 'source',
        title: 'Source',
        child: DocsInstallFacts(
          title: 'Source references',
          facts: <DocsInstallFact>[
            DocsInstallFact(
              label: 'Sheet source',
              value: sheetDoc.sourcePath,
              description: 'The authoritative Flutter source for Sheet.',
            ),
            const DocsInstallFact(
              label: 'Drawer source',
              value: drawerSourcePath,
              description: 'The authoritative Flutter source for Drawer.',
            ),
            DocsInstallFact(
              label: 'Exports',
              value: sheetDoc.exports.join(', '),
              description: 'Public symbols available after import.',
            ),
            const DocsInstallFact(
              label: 'Tests',
              value: 'example/test/components_docs/sheet_test.dart',
              description: 'This page\'s own test coverage.',
            ),
            const DocsInstallFact(
              label: 'Docs source',
              value: 'example/lib/components_docs/sheet/page.dart',
              description:
                  'Report an issue or propose an edit against this file in '
                  'the flutter-design-system repository.',
            ),
          ],
        ),
      ),
    ],
  );
}

class _DecisionGuide extends StatelessWidget {
  const _DecisionGuide();

  @override
  Widget build(BuildContext context) => DsPanel(
    label: 'DECISION GUIDE',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: const <Widget>[
        _ComparisonRow(
          name: 'Dialog',
          body:
              'A centred, page-blocking question — confirm, name a thing, '
              'pick from a short list. The user\'s attention leaves the '
              'page entirely until they answer.',
        ),
        _ComparisonRow(
          name: 'Sheet (this page)',
          body:
              'An edge-anchored panel — filters, an account menu, a '
              'settings pane — that keeps the page visible and in place '
              'behind it. Any of four edges; no drag.',
        ),
        _ComparisonRow(
          name: 'Drawer (this page)',
          body:
              'The bottom-only, draggable member of the same family — the '
              'correct container for card actions and other touch-first '
              'bottom sheets on a phone, where a centred dialog would feel '
              'oversized. The one panel in the family a user can pull '
              'closed with a finger.',
        ),
      ],
    ),
  );
}

class _ComparisonRow extends StatelessWidget {
  const _ComparisonRow({required this.name, required this.body});

  final String name;
  final String body;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: ds(4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DsText(name, DsType.label, color: theme.actionInk),
          SizedBox(height: ds(1.5)),
          DsText(body, DsType.small),
        ],
      ),
    );
  }
}

class _Bullets extends StatelessWidget {
  const _Bullets({required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return DsPanel(
      label: 'GUIDANCE',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          for (int index = 0; index < items.length; index++) ...<Widget>[
            if (index > 0) SizedBox(height: ds(3)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: ds(1.5)),
                  child: Container(
                    width: ds(1.5),
                    height: ds(1.5),
                    decoration: BoxDecoration(
                      color: theme.actionInk,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                SizedBox(width: ds(3)),
                Expanded(child: DsText(items[index], DsType.small)),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _DecisionNote extends StatelessWidget {
  const _DecisionNote({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) =>
      DsPanel(label: 'NOTE', child: DsText(text, DsType.small));
}

class _NoConstructorParamsNote extends StatelessWidget {
  const _NoConstructorParamsNote({required this.title, required this.note});

  final String title;
  final String note;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return DsPanel(
      label: title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DsText(note, DsType.small, color: theme.mutedForeground),
        ],
      ),
    );
  }
}

/// The primary live specimen: one [DsSheetOverlay] per [DsSheetSide] value,
/// plus one [DsDrawer]. Every trigger is real, so tapping one opens the real
/// widget the API tables above describe.
class _SheetDrawerPreview extends StatefulWidget {
  const _SheetDrawerPreview();

  @override
  State<_SheetDrawerPreview> createState() => _SheetDrawerPreviewState();
}

class _SheetDrawerPreviewState extends State<_SheetDrawerPreview> {
  /// Wired to the right-hand sheet trigger only, so a live test can observe
  /// exactly where keyboard focus goes on open and on close — see
  /// sheet_test.dart's focus test and the Accessibility section above.
  final FocusNode _rightTriggerFocus = FocusNode(
    debugLabel: 'sheet-trigger-right',
  );

  @override
  void dispose() {
    _rightTriggerFocus.dispose();
    super.dispose();
  }

  Widget _sheetSpecimen(DsSheetSide side) => DsSheetOverlay(
    side: side,
    trigger: (BuildContext context, VoidCallback open) => DsButton(
      key: ValueKey<String>('sheet-trigger:${side.name}'),
      variant: DsButtonVariant.outline,
      focusNode: side == DsSheetSide.right ? _rightTriggerFocus : null,
      onPressed: () {
        // Clear focus from the button before opening the sheet, allowing
        // the overlay's FocusScope to take focus when it opens.
        FocusScope.of(context).unfocus();
        open();
      },
      child: Text('Open ${side.name}'),
    ),
    content: (BuildContext context, VoidCallback close) {
      // Request focus on the sheet content's focus scope to ensure focus
      // transfers from the trigger to the overlay when opened.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus();
      });
      return DsSheetContent(
        side: side,
        onClose: close,
        children: <Widget>[
          const DsSheetHeader(
            children: <Widget>[
              DsSheetTitle('Notification settings'),
              DsSheetDescription('Choose what you want to hear about.'),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ds(4)),
            child: DsText(
              'This panel opened from the ${side.name} edge.',
              DsType.body,
            ),
          ),
          DsSheetFooter(
            children: <Widget>[
              DsButton(onPressed: close, child: const Text('Save changes')),
            ],
          ),
        ],
      );
    },
  );

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: ds(3),
    runSpacing: ds(3),
    children: <Widget>[
      for (final DsSheetSide side in DsSheetSide.values) _sheetSpecimen(side),
      DsDrawer(
        trigger: (BuildContext context, VoidCallback open) => DsButton(
          key: const ValueKey<String>('drawer-trigger'),
          variant: DsButtonVariant.secondary,
          onPressed: open,
          child: const Text('Open drawer'),
        ),
        content: (BuildContext context, VoidCallback close) => DsDrawerContent(
          children: <Widget>[
            const DsDrawerHeader(
              children: <Widget>[
                DsDrawerTitle('Card actions'),
                DsDrawerDescription(
                  'Drag down to dismiss, or use the buttons below.',
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ds(4)),
              child: DsButton(
                expanded: true,
                onPressed: close,
                child: const Text('Close'),
              ),
            ),
            DsDrawerFooter(
              children: <Widget>[
                DsButton(
                  variant: DsButtonVariant.outline,
                  onPressed: close,
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}

const String _sheetUsageCode = '''DsSheetOverlay(
  side: DsSheetSide.right,
  trigger: (context, open) => DsButton(
    onPressed: open,
    child: const Text('Open filters'),
  ),
  content: (context, close) => DsSheetContent(
    onClose: close,
    children: <Widget>[
      DsSheetHeader(children: <Widget>[
        DsSheetTitle('Filter packs'),
        DsSheetDescription('184 packs match your current filters.'),
      ]),
      DsSheetFooter(children: <Widget>[
        DsButton(onPressed: close, child: const Text('Apply filters')),
      ]),
    ],
  ),
)''';

const String _drawerUsageCode = '''DsDrawer(
  trigger: (context, open) => DsButton(
    onPressed: open,
    child: const Text('Card actions'),
  ),
  content: (context, close) => DsDrawerContent(
    children: <Widget>[
      DsDrawerHeader(children: <Widget>[
        DsDrawerTitle('Voidwing Ascendant'),
        DsDrawerDescription('Eclipse Vault · #044 · Legendary'),
      ]),
      DsDrawerFooter(children: <Widget>[
        DsButton(onPressed: close, child: const Text('Sell for \$1,240.00')),
      ]),
    ],
  ),
)''';

/// A trimmed, real excerpt of `example/lib/pages/dialogs.dart`'s own filter
/// sheet — proof that `children` takes live, stateful controls and not only
/// the header/footer/title/description anatomy.
const String _compositionCode = '''DsSheetContent(
  side: side,
  onClose: close,
  children: <Widget>[
    DsSheetHeader(children: <Widget>[
      DsSheetTitle('Filter packs'),
      DsSheetDescription('184 packs match your current filters.'),
    ]),
    Padding(
      padding: EdgeInsets.symmetric(horizontal: ds(4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          DsText('Price range', DsType.label),
          SizedBox(height: ds(4)),
          DsSlider(
            values: price,
            max: 500,
            step: 5,
            onChanged: (values) => setState(() => price = values),
          ),
        ],
      ),
    ),
    DsSheetFooter(children: <Widget>[
      DsButton(onPressed: () {}, child: const Text('Apply filters')),
    ]),
  ],
)''';
