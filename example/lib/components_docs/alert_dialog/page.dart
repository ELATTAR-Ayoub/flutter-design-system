/// Public component documentation for the alert-dialog component.
///
/// The eighteen IA §9.1 sections map onto this page as: breadcrumb/family
/// comes from the eyebrow and [DocsLayout.breadcrumbs]; title and short
/// description come from [DocsLayout] itself; the expanded "when to use
/// this instead of a neighbour" guidance is [alertDialogExpandedDescription],
/// carried both in the page intro and as a dedicated decision-guide panel;
/// status, preview, installation, usage, API, variants, states,
/// accessibility, responsive behaviour, the install-facts disclosure, a
/// composition example, theming notes, and source/tests each get their own
/// [DsSection]; previous/next comes from [DocsLayout] again.
///
/// Two findings, resolved in favour of the real source
/// (`lib/src/components/alert_dialog.dart`), which is the documented source
/// of truth here:
///
///  * **`DsAlertDialogSize.sm` is only half-built.** The enum's own doc
///    comment says the whole value is "RECORDED, NOT BUILT", but
///    `DsAlertDialogContent.build` does branch on `size` for the panel's
///    `maxWidth` (`DsDialogContent.maxWidth` for `normal`, `DsContainers.xs`
///    for `sm`) — that part ships. What does not ship is the rest of the
///    reference's `sm` anatomy: `DsAlertDialogHeader` and
///    `DsAlertDialogFooter` take no `size` parameter at all, so the
///    centred header and the two-column footer grid the reference's own doc
///    comment describes never happen, for any value of `size`. The Variants
///    section below says both halves plainly instead of repeating the
///    "not built" label over a case that partially is.
///  * **Escape does not run Cancel's `onPressed`.** `DsModalPortalState._onKey`
///    calls its own `close()` directly — the same bare portal-close every
///    other modal in the family uses. Tapping Cancel calls the `onPressed`
///    a caller passed to `DsAlertDialogCancel`; pressing Escape never does.
///    For a caller that puts real work in Cancel's callback (resetting a
///    field, logging an abandonment), Escape silently skips it. Documented
///    in Accessibility below, not as an ideal-behaviour aspiration.
///
/// The focus story asked for by the task brief was verified with a live
/// `WidgetTester`, not assumed — see
/// `example/test/components_docs/alert_dialog_test.dart`'s `focus behavior`
/// group. Findings, in order:
///
///  1. **Moves in, but not onto a control.** `FocusScope(autofocus: true,
///     ...)` in `DsModalPortal` does move primary focus off whatever was
///     focused before the dialog opened — but the harness observed
///     `FocusManager.instance.primaryFocus` becoming the panel's own
///     `FocusScopeNode`, identity-equal to `FocusScope.of()` resolved from
///     inside the panel, not a leaf control. The dialog.dart library doc's
///     own note that Radix measures Cancel as the auto-focused element
///     describes the **reference's** behaviour; nothing paints a focus ring
///     at this point because no actual `Focus` leaf holds it yet.
///  2. **The first Tab lands on a real button, and stays trapped from
///     there.** One Tab press moves focus from the bare scope onto Cancel
///     or Action, and six consecutive presses after that never once moved
///     focus onto a `DsButton` planted outside the overlay. Flutter's
///     default focus-traversal policy scopes `next()`/`previous()` to the
///     nearest enclosing `FocusScopeNode`, and the alert dialog's own
///     `FocusScope` is exactly that boundary.
///  3. **Does not return.** Closing via Cancel does **not** hand focus back
///     to the trigger that opened it — nothing in `DsModalPortalState.close()`
///     saves or restores a previous `FocusNode`. This is a real, checked gap:
///     a keyboard user who opens the dialog and cancels it lands back with
///     focus resolved by Flutter's own framework default rather than
///     continuing exactly where they left off.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/docs_code.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../kit.dart';
import '../catalog.dart';
import 'meta.dart';

class AlertDialogDocPage extends StatelessWidget {
  const AlertDialogDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) {
    final ComponentDocEntry entry = alertDialogDoc;
    return DocsLayout(
      route: entry.route,
      intro: DocsPageIntro(
        eyebrow: 'COMPONENTS / OVERLAYS',
        title: entry.title,
        description: alertDialogExpandedDescription,
      ),
      breadcrumbs: const <DsBreadcrumbEntry>[
        DsBreadcrumbEntry.link('Components'),
        DsBreadcrumbEntry.page('Alert Dialog'),
      ],
      sidebar: const <DocsSidebarEntry>[
        DocsSidebarEntry(title: 'Dialog', route: '/components/dialog'),
        DocsSidebarEntry(
          title: 'Alert Dialog',
          route: '/components/alert-dialog',
          selected: true,
        ),
      ],
      toc: const <DocsTocEntry>[
        DocsTocEntry(title: 'Purpose', anchor: 'purpose'),
        DocsTocEntry(title: 'Status', anchor: 'status'),
        DocsTocEntry(title: 'Preview', anchor: 'preview'),
        DocsTocEntry(title: 'Install', anchor: 'install'),
        DocsTocEntry(title: 'Usage', anchor: 'usage'),
        DocsTocEntry(title: 'API', anchor: 'api'),
        DocsTocEntry(title: 'Variants', anchor: 'variants'),
        DocsTocEntry(title: 'States', anchor: 'states'),
        DocsTocEntry(title: 'Accessibility', anchor: 'accessibility'),
        DocsTocEntry(title: 'Responsive', anchor: 'responsive'),
        DocsTocEntry(title: 'Dependencies', anchor: 'dependencies'),
        DocsTocEntry(title: 'Composition', anchor: 'composition'),
        DocsTocEntry(title: 'Theming', anchor: 'theming'),
        DocsTocEntry(title: 'Source', anchor: 'source'),
      ],
      // alert-dialog is Wave 3's first entry. Dialog (Phase F, already
      // landed) is its closest built neighbour; Command is the next name in
      // Wave 3's own list — a forward reference to an unbuilt sibling, the
      // same shape `accordion/page.dart` used for its own `next`.
      previous: const DocsPageLink(
        title: 'Dialog',
        route: '/components/dialog',
      ),
      next: const DocsPageLink(title: 'Command', route: '/components/command'),
      onNavigate: onNavigate,
      child: _AlertDialogArticle(entry: entry),
    );
  }
}

class _AlertDialogArticle extends StatelessWidget {
  const _AlertDialogArticle({required this.entry});

  final ComponentDocEntry entry;

  @override
  Widget build(BuildContext context) => Column(
    key: const ValueKey<String>('alert-dialog-doc-article'),
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      DsSection(
        id: 'purpose',
        title: 'When to reach for it',
        description:
            'Three overlay-adjacent patterns live in this system and they '
            'are not interchangeable.',
        child: const _DecisionGuide(),
      ),
      DsSection(
        id: 'status',
        title: 'Status',
        child: const DocsInstallFacts(
          title: 'Status',
          facts: <DocsInstallFact>[
            DocsInstallFact(
              label: 'Status',
              value: 'Stable — registered in the registry',
              description:
                  'The whole DsAlertDialog family is exported from the '
                  'public barrel and installable through the CLI today.',
            ),
            DocsInstallFact(
              label: 'Version',
              value: '0.0.1',
              description: "The registry manifest's own version field.",
            ),
            DocsInstallFact(
              label: 'Dart / Flutter',
              value: '>=3.12.2 <4.0.0 / >=3.44.8',
              description: "The manifest's minDart and minFlutter constraints.",
            ),
            DocsInstallFact(
              label: 'Platforms',
              value: 'Android, iOS, Web, macOS, Windows, Linux',
              description:
                  'Pure widget composition on top of DsModalPortal — nothing '
                  'here is platform-gated, beyond the back-button dismissal '
                  'DsModalPortal already wires for every modal in the family.',
            ),
          ],
        ),
      ),
      DsSection(
        id: 'preview',
        title: 'Preview',
        description:
            'A destructive confirmation. Open it, then try to dismiss it by '
            'tapping outside the panel — the reference and this port both '
            'refuse. Escape and the two footer buttons still work.',
        child: DocsCodeExample(
          title: 'Alert dialog specimen',
          description:
              'Tap outside the panel to see the dismissal refused, or use '
              'Cancel, Action, or Escape.',
          preview: const _AlertDialogPreview(),
          command: DocsCodeCommand(command: entry.command),
        ),
      ),
      DsSection(
        id: 'install',
        title: 'Installation',
        description:
            'alert-dialog already has a registry manifest — this installs '
            'lib/src/components/alert_dialog.dart and its three '
            'dependencies, source-foundation, button, dialog and tooltip, '
            'resolved automatically.',
        child: DocsCodeExample(
          title: 'Installation',
          command: DocsCodeCommand(
            command: entry.command,
            description:
                'Installs alert_dialog.dart and resolves button, dialog and '
                'tooltip automatically.',
          ),
          manualFiles: const <DocsCodeFile>[
            DocsCodeFile(
              path: 'lib/components/ui/alert_dialog.dart',
              code:
                  "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
                  '// Copy the generated alert_dialog source here when using '
                  'manual mode.',
            ),
          ],
        ),
      ),
      DsSection(
        id: 'usage',
        title: 'Usage',
        description:
            'The smallest correct composition, then the shape the source '
            "itself is built around — a destructive Action beside a safe "
            'Cancel, both wired to the same close callback.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DsPanel(
              label: 'DART',
              note: 'MINIMAL',
              child: DocsSelectableCodeBlock(code: _usageBasicCode),
            ),
            SizedBox(height: ds(5)),
            DsPanel(
              label: 'DART',
              note: 'LOADING ACTION',
              child: DocsSelectableCodeBlock(code: _usageLoadingCode),
            ),
          ],
        ),
      ),
      DsSection(
        id: 'api',
        title: 'API',
        description:
            'Every public class and constructor parameter the source '
            'declares — nine exported symbols across five widgets and one '
            'enum.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const DocsApiTable(
              title: 'DsAlertDialog',
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'trigger',
                  type: 'DsModalTriggerBuilder',
                  description:
                      'Required. Widget Function(BuildContext, VoidCallback '
                      'open) — builds the control that opens the portal.',
                ),
                DocsApiFact(
                  name: 'content',
                  type: 'DsModalContentBuilder',
                  description:
                      'Required. Widget Function(BuildContext, VoidCallback '
                      'close) — builds the panel and receives its close '
                      'callback.',
                ),
                DocsApiFact(
                  name: 'onOpenChange',
                  type: 'ValueChanged<bool>?',
                  description:
                      'Default null. Fires with the new open state whenever '
                      'the overlay opens or closes.',
                ),
              ],
            ),
            SizedBox(height: ds(5)),
            const DocsApiTable(
              title: 'DsAlertDialogContent',
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'header',
                  type: 'DsAlertDialogHeader',
                  description: 'Required. The question, straight on the panel.',
                ),
                DocsApiFact(
                  name: 'footer',
                  type: 'DsAlertDialogFooter',
                  description:
                      'Required. The banded row that holds the '
                      'decision.',
                ),
                DocsApiFact(
                  name: 'size',
                  type: 'DsAlertDialogSize',
                  description:
                      'Default DsAlertDialogSize.normal. Only changes the '
                      "panel's maxWidth — see Variants below for what it "
                      'does not change.',
                ),
              ],
            ),
            SizedBox(height: ds(5)),
            const DocsApiTable(
              title: 'DsAlertDialogHeader',
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'title',
                  type: 'Widget',
                  description:
                      'Required. Almost always a DsAlertDialogTitle, but '
                      'typed as Widget rather than that concrete class.',
                ),
                DocsApiFact(
                  name: 'description',
                  type: 'Widget',
                  description:
                      'Required. Almost always a DsAlertDialogDescription, '
                      'for the same reason.',
                ),
              ],
            ),
            SizedBox(height: ds(5)),
            const DocsApiTable(
              title: 'DsAlertDialogTitle',
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'text',
                  type: 'String',
                  description:
                      'Required, positional: DsAlertDialogTitle(text). '
                      'Rendered at DsComponentType.overlayTitle with no '
                      'leading override.',
                ),
              ],
            ),
            SizedBox(height: ds(5)),
            const DocsApiTable(
              title: 'DsAlertDialogDescription',
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'text',
                  type: 'String',
                  description:
                      'Required, positional: DsAlertDialogDescription(text). '
                      'Rendered muted, wrapped greedily rather than balanced '
                      '— see Responsive below.',
                ),
              ],
            ),
            SizedBox(height: ds(5)),
            const DocsApiTable(
              title: 'DsAlertDialogFooter',
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'cancel',
                  type: 'Widget',
                  description:
                      'Required. Rendered first — the safe choice on the '
                      'left. Almost always a DsAlertDialogCancel.',
                ),
                DocsApiFact(
                  name: 'action',
                  type: 'Widget',
                  description: 'Required. Almost always a DsAlertDialogAction.',
                ),
              ],
            ),
            SizedBox(height: ds(5)),
            const DocsApiTable(
              title: 'DsAlertDialogAction',
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'label',
                  type: 'String',
                  description:
                      'Required. Rendered through an internal Text widget, '
                      'not forwarded to DsButton.label — see Accessibility.',
                ),
                DocsApiFact(
                  name: 'onPressed',
                  type: 'VoidCallback?',
                  description: 'Default null (disabled).',
                ),
                DocsApiFact(
                  name: 'variant',
                  type: 'DsButtonVariant',
                  description:
                      'Default DsButtonVariant.destructive — "that is what '
                      'an alert dialog is for."',
                ),
                DocsApiFact(
                  name: 'size',
                  type: 'DsButtonSize',
                  description: 'Default DsButtonSize.md.',
                ),
                DocsApiFact(
                  name: 'loading',
                  type: 'bool',
                  description:
                      'Default false. Prepends a spinner, forces '
                      'DsButton.enabled false, and the constructor\'s own '
                      'onPressed: loading ? null : onPressed blocks a second '
                      'press ahead of DsButton\'s own guard.',
                ),
                DocsApiFact(
                  name: 'tooltip',
                  type: 'String?',
                  description:
                      'Default null, which falls back to label — passing '
                      'null does NOT mean "no tooltip". See Accessibility.',
                ),
              ],
            ),
            SizedBox(height: ds(5)),
            const DocsApiTable(
              title: 'DsAlertDialogCancel',
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'label',
                  type: 'String',
                  description: 'Required. Same rendering path as Action\'s.',
                ),
                DocsApiFact(
                  name: 'onPressed',
                  type: 'VoidCallback?',
                  description: 'Default null (disabled).',
                ),
                DocsApiFact(
                  name: 'variant',
                  type: 'DsButtonVariant',
                  description: 'Default DsButtonVariant.outline.',
                ),
                DocsApiFact(
                  name: 'size',
                  type: 'DsButtonSize',
                  description: 'Default DsButtonSize.md.',
                ),
                DocsApiFact(
                  name: 'tooltip',
                  type: 'String?',
                  description:
                      'Default null, falls back to label — same rule as '
                      "Action's. DsAlertDialogCancel has no loading "
                      'parameter at all.',
                ),
              ],
            ),
          ],
        ),
      ),
      DsSection(
        id: 'variants',
        title: 'Variants',
        description:
            'DsAlertDialogSize is the only variant knob on this component, '
            "and it is only half-built — see the page's own library doc "
            'for the full finding.',
        child: const DocsApiTable(
          title: 'DsAlertDialogSize',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'normal',
              type: 'DsAlertDialogSize',
              description:
                  'The default. DsAlertDialogContent constrains the panel '
                  'to DsDialogContent.maxWidth (384) — the same width as a '
                  'plain DsDialog.',
            ),
            DocsApiFact(
              name: 'sm',
              type: 'DsAlertDialogSize',
              description:
                  'Narrows the panel to DsContainers.xs. That is the whole '
                  'of what is built: DsAlertDialogHeader and '
                  'DsAlertDialogFooter both take no size parameter at all, '
                  "so the reference's centred header and two-column footer "
                  'grid never happen for either value of size.',
            ),
          ],
        ),
      ),
      DsSection(
        id: 'states',
        title: 'States and feedback',
        description:
            'Cancel and Action are ordinary DsButton instances wrapped in a '
            'DsTooltip, so most of their state behavior is inherited '
            "verbatim rather than reimplemented here. Rows that do not "
            'apply to this decision-only primitive are marked N/A with the '
            'reason.',
        child: const DocsStateMatrix(
          facts: <DocsStateFact>[
            DocsStateFact(
              state: 'Rest',
              treatment:
                  'The portal content is not mounted; only the trigger '
                  'renders.',
              userSignal: 'Nothing besides the trigger is on screen.',
            ),
            DocsStateFact(
              state: 'Hover',
              treatment:
                  "Cancel and Action inherit their variant's own DsButton "
                  "hover fill (outline's and destructive's respectively) — "
                  'nothing alert-dialog-specific is added.',
              userSignal: 'Matches every other DsButton in the system.',
            ),
            DocsStateFact(
              state: 'Focus-visible',
              treatment:
                  "DsButton's own keyboard-only focus ring paints on "
                  'whichever of Cancel or Action Tab reaches; a pointer tap '
                  'does not paint it.',
              userSignal:
                  'Ring is visible only after keyboard traversal, never '
                  'after a mouse click — verified live in this page\'s own '
                  'focus tests.',
            ),
            DocsStateFact(
              state: 'Pressed',
              treatment:
                  "DsButton's own press-scale and active shadow apply "
                  'identically on both footer buttons.',
              userSignal: 'A brief squash on press, released on lift.',
            ),
            DocsStateFact(
              state: 'Selected',
              treatment:
                  'N/A — a decision dialog has no selection concept beyond '
                  'open or closed.',
              userSignal: 'N/A',
            ),
            DocsStateFact(
              state: 'Loading',
              treatment:
                  'Action-only: DsAlertDialogCancel has no loading '
                  'parameter. loading: true on Action prepends a spinner, '
                  "disables the button through DsButton's own enabled "
                  'logic, and the constructor guard blocks a second press.',
              userSignal:
                  'Spinner shows on Action; Cancel stays fully interactive.',
            ),
            DocsStateFact(
              state: 'Empty',
              treatment:
                  'N/A — label, title and description are all required '
                  'Strings; the API has no path to an empty one to design '
                  'for.',
              userSignal: 'N/A',
            ),
            DocsStateFact(
              state: 'Error',
              treatment:
                  'N/A — no validation or error state exists on this '
                  'component.',
              userSignal: 'N/A',
            ),
            DocsStateFact(
              state: 'Success',
              treatment:
                  'N/A — onPressed is a synchronous VoidCallback, not a '
                  'Future; there is no async outcome to confirm.',
              userSignal: 'N/A',
            ),
            DocsStateFact(
              state: 'Disabled',
              treatment:
                  'Neither Cancel nor Action has an explicit enabled/'
                  'disabled parameter — onPressed: null is the only path, '
                  'same as any DsButton.',
              userSignal:
                  "Matches DsButton's own disabled visual: lower opacity, "
                  'no pointer events.',
            ),
            DocsStateFact(
              state: 'Reduced motion',
              treatment:
                  'The whole panel rides DsJellyTransition through '
                  'dsAnimationDuration, exactly like the plain dialog — the '
                  '420ms/250ms jelly and the 320ms scrim fade collapse to '
                  'zero.',
              userSignal:
                  'The dialog still opens and closes, just without the '
                  'spring travel.',
            ),
          ],
        ),
      ),
      DsSection(
        id: 'accessibility',
        title: 'Accessibility and keyboard behavior',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DsPanel(
              label: 'What the semantics tree and keyboard path carry',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const _A11yRow(
                    'Semantic role',
                    'Cancel and Action each publish Semantics(button: true, '
                        'enabled: <onPressed != null && !loading>) through '
                        'the DsButton they wrap. Neither passes its label '
                        "to DsButton's own label parameter — the "
                        'accessible name instead comes from Semantics '
                        "merging upward over the internal Text child, "
                        'which still resolves to the same string.',
                  ),
                  const _A11yRow(
                    'Required labels',
                    'title, description, and both button labels are all '
                        'required — there is no path to a nameless control '
                        'or a captionless question.',
                  ),
                  const _A11yRow(
                    'Keyboard interactions',
                    'Tab moves between Cancel and Action and paints the '
                        'focus ring; Enter and Space activate whichever '
                        'one is focused, wired by DsButton\'s own key '
                        'handler. Escape closes the whole dialog.',
                  ),
                  const _A11yRow(
                    'Focus behavior — verified, not assumed',
                    'Opening moves focus off whatever held it before, but '
                        'not onto a control: FocusManager.primaryFocus '
                        "becomes the panel's own bare FocusScopeNode, "
                        "identity-checked live — not the Cancel button, "
                        'despite the dialog.dart library doc describing '
                        "that as what the reference (Radix) measures. One "
                        'Tab press moves focus from that scope onto a '
                        'real control (Cancel or Action), and from there '
                        'Tab is trapped — six consecutive presses in this '
                        "page's own test never reached a control planted "
                        'outside the overlay. Closing does NOT return '
                        'focus to the trigger: DsModalPortalState.close() '
                        'saves and restores no FocusNode of its own, so a '
                        'keyboard user who cancels lands wherever '
                        "Flutter's own framework default resolves focus "
                        'to, not necessarily back on the button they '
                        'pressed to get here.',
                  ),
                  const _A11yRow(
                    'Touch target',
                    "Cancel and Action are md DsButtons (40px tall) unless "
                        'a caller overrides size — no touch-target '
                        'reduction is applied inside the footer band.',
                  ),
                  const _A11yRow(
                    'Non-color signal',
                    "Action's destructive tint is never the only signal — "
                        'the label itself always states the consequence '
                        '("Delete account", not just a red button), and '
                        'the title/description pair states the question '
                        'in full sentences above it.',
                  ),
                  const _A11yRow(
                    'Error wiring',
                    'None — this family never participates in form '
                        'validation.',
                  ),
                  const _A11yRow(
                    'Screen-reader announcements',
                    'None beyond whatever the platform announces for a '
                        'newly focused control — opening the panel raises '
                        'no live region of its own, so a screen-reader '
                        'user learns the question only by having focus '
                        'land on Cancel and reading from there.',
                  ),
                  _A11yRow(
                    'Known platform differences',
                    'Android/predictive back always dismisses the dialog '
                        '(DsModalPortalState\'s own PopScope), unconditionally '
                        '— unlike Escape and the overlay tap, back admits '
                        'no destructive-action exception.',
                    last: true,
                  ),
                ],
              ),
            ),
            SizedBox(height: ds(5)),
            DsNote(
              tone: DsNoteTone.error,
              title: "Known gap — Escape skips Cancel's own onPressed",
              child: DsText(
                'DsModalPortalState._onKey calls close() directly on '
                'Escape — the same bare portal-close every modal in the '
                'family uses. Tapping the Cancel button calls whatever '
                'onPressed a caller passed to DsAlertDialogCancel; '
                'pressing Escape does not call it. If a caller relies on '
                "Cancel's callback for real work — resetting a field, "
                'logging an abandoned confirmation — Escape silently '
                'skips it while still closing the dialog.',
                DsType.small,
              ),
            ),
            SizedBox(height: ds(3)),
            DsNote(
              tone: DsNoteTone.error,
              title: 'Known gap — closing does not return focus to the trigger',
              child: DsText(
                "Verified live: after opening the panel and dismissing it "
                'via Cancel, focus does not return to the button that '
                'opened it. Nothing in DsModalPortalState.close() saves a '
                'FocusNode before autofocus moves it, so there is nothing '
                'to restore. A keyboard user who opens and cancels the '
                'dialog does not automatically land back on the trigger.',
                DsType.small,
              ),
            ),
          ],
        ),
      ),
      DsSection(
        id: 'responsive',
        title: 'Responsive and platform behavior',
        description:
            'Shares DsModalCompact with every other centred modal in the '
            'family — a phone-sized viewport clamps the panel rather than '
            'letting it run to the edges or off the screen.',
        child: DsPanel(
          label: 'The compact clamp, and what it does to the footer',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DsText(
                'At 600 logical pixels of viewport width or below, the '
                'panel is held inside 90vw x 75vh — DsModalCompact, shared '
                'with the plain dialog. Above that width the desktop '
                'geometry is untouched.',
                DsType.small,
              ),
              SizedBox(height: ds(3)),
              DsText(
                'The header and question scroll inside a loose Flexible; '
                'the footer band does not — the decision stays reachable '
                'even when the question runs long enough to need scrolling '
                'on a 375px phone.',
                DsType.small,
              ),
              SizedBox(height: ds(3)),
              DsText(
                "Cancel and Action are both wrapped in Flexible with "
                "min-width 0 inside the footer's Row, and DsButton's child "
                'is a single-line Text with TextOverflow.ellipsis — so a '
                'long consequence label truncates to fit a narrow footer '
                'instead of pushing the panel wider or overflowing it.',
                DsType.small,
              ),
              SizedBox(height: ds(3)),
              DsText(
                "text-balance and text-pretty on the description are "
                "recorded and unreachable: Flutter's line breaker has no "
                'balanced or pretty mode, so a long description wraps '
                'greedily rather than evenly.',
                DsType.small,
              ),
            ],
          ),
        ),
      ),
      DsSection(
        id: 'dependencies',
        title: 'Dependencies, files, and disclosure',
        description:
            "Elattar's own technical-transparency panel — what this "
            'component needs to install and run.',
        child: DocsInstallFacts(
          facts: <DocsInstallFact>[
            const DocsInstallFact(
              label: 'Registry item',
              value: 'alert-dialog',
              description:
                  'registry/components/alert-dialog.json exists and is '
                  'installable through the CLI today.',
            ),
            const DocsInstallFact(
              label: 'Destination',
              value: 'lib/components/ui/alert_dialog.dart',
              description:
                  'The same lib/components/ui/ target every component '
                  'installs to, in both foundation modes.',
            ),
            const DocsInstallFact(
              label: 'Foundation',
              value: 'source or package compatible',
              description:
                  "The manifest names source-foundation plus three "
                  'sibling components — nothing here is package-mode-only.',
            ),
            DocsInstallFact(
              label: 'Dependencies',
              value: entry.dependencies.join(', '),
              description:
                  "The manifest's registryDependencies, resolved "
                  'automatically by the registry client: button for Cancel '
                  'and Action, dialog for the shared panel machinery, and '
                  'tooltip for the two footer tooltips.',
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
              description:
                  'Pure widget composition; the only platform-shaped '
                  'behavior is the Android back button dismissing the '
                  'dialog, which every DsModalPortal already wires.',
            ),
            const DocsInstallFact(
              label: 'Verified',
              value: 'package tests + this docs specimen',
              description:
                  "test/dialogs_test.dart's own DsAlertDialog scrim/Escape "
                  "group, plus this page's own live open/close/Escape and "
                  'focus-behavior tests. No fixture install was run as '
                  'part of writing this page.',
            ),
          ],
        ),
      ),
      DsSection(
        id: 'composition',
        title: 'Composition example',
        description:
            "A danger-zone row — the exact shape the source's own library "
            'doc cites: a long consequence label beside a short safe one, '
            'inside a footer narrow enough that only Flexible/shrink keeps '
            'both readable.',
        child: const DocsCodeExample(
          title: 'Danger zone composition',
          preview: _AlertDialogComposition(),
        ),
      ),
      DsSection(
        id: 'theming',
        title: 'Theming notes',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DsPanel(
              label: 'What actually varies with the theme',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  DsText(
                    'The panel itself is DsDialogContent\'s own '
                    'DsMachineSurface — theme.popover fill, a single 1px '
                    'theme.foreground-at-10% ring, no elevation — reused '
                    'directly rather than restated, so the two panels '
                    'cannot drift apart.',
                    DsType.small,
                  ),
                  SizedBox(height: ds(3)),
                  DsText(
                    'The footer band is theme.muted at 50% alpha with a '
                    '1px theme.border rule on top — identical to the '
                    "dialog's own footer, unlike the header, which carries "
                    'no band at all here (see the library doc\'s own "no '
                    'band" note).',
                    DsType.small,
                  ),
                  SizedBox(height: ds(3)),
                  DsText(
                    "The title paints theme.foreground and the description "
                    'theme.mutedForeground — the same pairing as the plain '
                    "dialog's title and description.",
                    DsType.small,
                  ),
                  SizedBox(height: ds(3)),
                  DsText(
                    "Action's destructive variant and Cancel's outline "
                    'variant are the only per-instance color choices; both '
                    'can be overridden through the variant parameter, '
                    'though every real call site in the corpus leaves them '
                    'at their defaults.',
                    DsType.small,
                  ),
                ],
              ),
            ),
            SizedBox(height: ds(5)),
            const DocsApiTable(
              title: 'Layout tokens',
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'DsAlertDialogHeader.gap',
                  type: 'static double (get)',
                  description: 'gap-1.5, ~6px, between title and description.',
                ),
              ],
            ),
          ],
        ),
      ),
      DsSection(
        id: 'source',
        title: 'Source and tests',
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
                  'main/lib/src/components/alert_dialog.dart',
              description: "The registry manifest's own sourceLink, verbatim.",
            ),
            const DocsInstallFact(
              label: 'Tests',
              value:
                  'test/dialogs_test.dart (DsModalPortal — the alert '
                  'dialog scrim/Escape group)',
              description:
                  'Package-level behavioral coverage: the overlay-tap '
                  'refusal and the Escape-yields drift.',
            ),
            const DocsInstallFact(
              label: 'Docs specimen',
              value: 'example/test/components_docs/alert_dialog_test.dart',
              description:
                  "This page's own responsive, theme, API-completeness, "
                  'live open/close/Escape, and focus-behavior coverage.',
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
          name: 'Alert Dialog (this component)',
          body:
              'A single yes-or-no decision the interface must not let '
              'someone click past by accident — deleting an account, '
              'discarding unsaved work, confirming an irreversible charge. '
              'The panel refuses to close on a tap outside it; only '
              'Cancel, Action, or Escape get you out.',
        ),
        _ComparisonRow(
          name: 'Dialog',
          body:
              'A general modal container for a task — a form, a short '
              'flow, a details view. It shares alert-dialog\'s panel, '
              'motion and focus scope, but closes on an overlay tap, '
              'which alert-dialog deliberately does not.',
        ),
        _ComparisonRow(
          name: 'Alert',
          body:
              'Not a modal at all. A persistent inline message that lives '
              "directly in the page's own layout — no trigger, no scrim, "
              'no portal — for a status someone should see but does not '
              'have to act on immediately.',
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

class _A11yRow extends StatelessWidget {
  const _A11yRow(this.label, this.body, {this.last = false});

  final String label;
  final String body;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : ds(3)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DsText(label, DsType.label, color: theme.actionInk),
          SizedBox(height: ds(1)),
          DsText(body, DsType.small),
        ],
      ),
    );
  }
}

const String _usageBasicCode =
    '''import 'package:elattar_design_system/elattar_design_system.dart';

DsAlertDialog(
  trigger: (context, open) => DsButton(
    variant: DsButtonVariant.destructive,
    label: 'Delete account',
    onPressed: open,
    child: const Text('Delete account'),
  ),
  content: (context, close) => DsAlertDialogContent(
    header: DsAlertDialogHeader(
      title: const DsAlertDialogTitle('Are you absolutely sure?'),
      description: const DsAlertDialogDescription(
        'This will permanently delete your account and remove your data '
        'from our servers. This action cannot be undone.',
      ),
    ),
    footer: DsAlertDialogFooter(
      cancel: DsAlertDialogCancel(label: 'Cancel', onPressed: close),
      action: DsAlertDialogAction(
        label: 'Delete account',
        onPressed: close,
      ),
    ),
  ),
)''';

const String _usageLoadingCode = '''// The confirming button owns its own
// loading flag — the source declares it here rather than inheriting
// Button's, because a caller has real async work to await (an API call
// that actually deletes the account) before the dialog should close.
class _DeleteAccountAction extends StatefulWidget {
  const _DeleteAccountAction({required this.close});
  final VoidCallback close;

  @override
  State<_DeleteAccountAction> createState() => _DeleteAccountActionState();
}

class _DeleteAccountActionState extends State<_DeleteAccountAction> {
  bool _loading = false;

  Future<void> _delete() async {
    setState(() => _loading = true);
    await deleteAccount(); // caller-owned async work
    if (mounted) widget.close();
  }

  @override
  Widget build(BuildContext context) => DsAlertDialogAction(
    label: 'Delete account',
    loading: _loading,
    onPressed: _delete,
  );
}''';

/// The live specimen: a real DsAlertDialog with an overlay-tap probe built
/// in — the [DsPanel] frame around it is itself outside the dialog's own
/// tree, so a tap that lands on the frame (not the panel) exercises the
/// same "does the scrim refuse it" path the reference measured.
class _AlertDialogPreview extends StatelessWidget {
  const _AlertDialogPreview();

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        DsAlertDialog(
          trigger: (BuildContext context, VoidCallback open) => DsButton(
            key: const ValueKey<String>('alert-dialog-doc-trigger'),
            variant: DsButtonVariant.destructive,
            label: 'Delete account',
            onPressed: open,
            child: const Text('Delete account'),
          ),
          content: (BuildContext context, VoidCallback close) =>
              DsAlertDialogContent(
                header: DsAlertDialogHeader(
                  title: const DsAlertDialogTitle('Are you absolutely sure?'),
                  description: const DsAlertDialogDescription(
                    'This will permanently delete your account and remove '
                    'your data from our servers. This action cannot be '
                    'undone.',
                  ),
                ),
                footer: DsAlertDialogFooter(
                  cancel: DsAlertDialogCancel(
                    key: const ValueKey<String>('alert-dialog-doc-cancel'),
                    label: 'Cancel',
                    onPressed: close,
                  ),
                  action: DsAlertDialogAction(
                    key: const ValueKey<String>('alert-dialog-doc-action'),
                    label: 'Delete account',
                    onPressed: close,
                  ),
                ),
              ),
        ),
        SizedBox(height: ds(4)),
        DsText(
          'Tapping outside the panel leaves it open; Cancel, the '
          'destructive Action, and Escape all close it.',
          DsType.small,
          color: theme.mutedForeground,
        ),
      ],
    );
  }
}

/// A realistic danger-zone row — a long consequence beside a short safe
/// choice, the exact shape `alert_dialog.dart`'s own library doc cites.
class _AlertDialogComposition extends StatelessWidget {
  const _AlertDialogComposition();

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              DsText(
                'Delete this workspace',
                DsType.label,
                color: theme.foreground,
              ),
              SizedBox(height: ds(1)),
              DsText(
                'Every project, member, and file inside it is removed '
                'immediately.',
                DsType.small,
                color: theme.mutedForeground,
              ),
            ],
          ),
        ),
        SizedBox(width: ds(4)),
        DsAlertDialog(
          trigger: (BuildContext context, VoidCallback open) => DsButton(
            variant: DsButtonVariant.destructive,
            size: DsButtonSize.sm,
            label: 'Delete workspace',
            onPressed: open,
            child: const Text('Delete'),
          ),
          content: (BuildContext context, VoidCallback close) =>
              DsAlertDialogContent(
                header: DsAlertDialogHeader(
                  title: const DsAlertDialogTitle('Delete this workspace?'),
                  description: const DsAlertDialogDescription(
                    'Every project, member, and file inside it is removed '
                    'immediately and cannot be recovered.',
                  ),
                ),
                footer: DsAlertDialogFooter(
                  cancel: DsAlertDialogCancel(
                    label: 'Keep workspace',
                    onPressed: close,
                  ),
                  action: DsAlertDialogAction(
                    label: 'Delete my workspace and all its files',
                    onPressed: close,
                  ),
                ),
              ),
        ),
      ],
    );
  }
}
