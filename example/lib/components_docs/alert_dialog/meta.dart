/// Public documentation metadata for the alert-dialog component.
///
/// `alert-dialog` already has a real `registry/components/alert-dialog.json`
/// manifest. [dependencies] below is that manifest's own
/// `registryDependencies`, verbatim: `['source-foundation', 'button',
/// 'dialog', 'tooltip']` — so `page.dart`'s installation section renders the
/// real `elattar add alert-dialog` command rather than a "not available yet"
/// disclosure.
///
/// [ComponentDocEntry.name] is the registry/route slug `alert-dialog`
/// (kebab-case), which does **not** match the Dart source file
/// `lib/src/components/alert_dialog.dart` (snake_case, because Dart file
/// names cannot carry a hyphen). The manifest, [ComponentDocEntry.route] and
/// [ComponentDocEntry.command] all agree on the kebab-case spelling — only
/// [sourcePath] stays snake_case, because it names a real file on disk.
///
/// [ComponentDocEntry.description] is the one-sentence form for nav and
/// search. [alertDialogExpandedDescription] carries the IA §9.2 "when to use
/// this instead of a neighbour" guidance against alert-dialog's two closest
/// neighbours, Dialog and Alert — kept as a second top-level constant, the
/// same shape `tooltip`'s `tooltipExpandedDescription` uses, because
/// [ComponentDocEntry] itself carries only one description field and is
/// supervisor-owned.
library;

import '../catalog.dart';

/// IA §9.2's expanded description: alert dialog against Dialog and Alert, not
/// a restatement of what an alert dialog is.
const String alertDialogExpandedDescription =
    'Reach for an alert dialog only when the interaction is a single '
    'yes-or-no decision the interface must not let someone click past by '
    'accident — deleting an account, discarding unsaved work, confirming an '
    "irreversible charge. It shares Dialog's panel, motion, and focus "
    'scope, and departs from it in exactly one place: DsAlertDialog refuses '
    'to close on a tap outside the panel, so the only way out is an '
    'explicit Cancel, an explicit Action, or Escape. Reach for Dialog '
    'instead once the overlay holds more than one decision, a form, or '
    'content someone might legitimately want to dismiss by tapping away — '
    'a plain dialog closes on an overlay tap and an alert dialog does not. '
    'Reach for Alert instead of either when nothing needs a decision at '
    'all: Alert is not an overlay — it has no trigger, no scrim, and no '
    "portal, and sits directly in the page's own layout as a persistent "
    'status message someone can read and move past without responding.';

const ComponentDocEntry alertDialogDoc = ComponentDocEntry(
  name: 'alert-dialog',
  title: 'Alert Dialog',
  description:
      'A blocking confirmation overlay for a single decision the interface '
      'will not let someone dismiss by tapping outside the panel.',
  // registry/components/alert-dialog.json's own registryDependencies,
  // verbatim — a worker inventing a name here is exactly the failure mode
  // the Phase J supervisor notes warn about, and this one does not need to.
  dependencies: <String>['source-foundation', 'button', 'dialog', 'tooltip'],
  exports: <String>[
    'DsAlertDialog',
    'DsAlertDialogSize',
    'DsAlertDialogContent',
    'DsAlertDialogHeader',
    'DsAlertDialogTitle',
    'DsAlertDialogDescription',
    'DsAlertDialogFooter',
    'DsAlertDialogAction',
    'DsAlertDialogCancel',
  ],
  sourcePath: 'lib/src/components/alert_dialog.dart',
);
