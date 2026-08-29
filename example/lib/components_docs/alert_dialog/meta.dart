/// Public documentation metadata for the alert-dialog component.
///
/// `alert-dialog` already has a real `registry/components/alert-dialog.json`
/// manifest. [dependencies] below is that manifest's own
/// `registryDependencies`, verbatim: `['source-foundation', 'button',
/// 'dialog', 'tooltip']`: so `page.dart`'s installation section renders the
/// real `elattar add alert-dialog` command and shipped registry dependencies.
/// disclosure.
///
/// [ComponentDocEntry.name] is the registry/route slug `alert-dialog`
/// (kebab-case), which does **not** match the Dart source file
/// `lib/src/components/ui/alert_dialog.dart` (snake_case, because Dart file
/// names cannot carry a hyphen). The manifest, [ComponentDocEntry.route] and
/// [ComponentDocEntry.command] all agree on the kebab-case spelling: only
/// [sourcePath] stays snake_case, because it names a real file on disk.
///
/// [ComponentDocEntry.description] is the page's only rendered description:
/// the one-sentence form for nav, search, and the page's own hero line.
library;

import '../catalog.dart';

const ComponentDocEntry alertDialogDoc = ComponentDocEntry(
  name: 'alert-dialog',
  title: 'Alert Dialog',
  description:
      'A blocking confirmation overlay for a single decision the interface '
      'will not let someone dismiss by tapping outside the panel.',
  // registry/components/alert-dialog.json's own registryDependencies,
  // verbatim: a worker inventing a name here is exactly the failure mode
  // the Phase J supervisor notes warn about, and this one does not need to.
  dependencies: <String>[
    'button',
    'dialog',
    'surface',
    'source-foundation',
    'tooltip',
  ],
  exports: <String>[
    'AlertDialog',
    'AlertDialogSize',
    'AlertDialogContent',
    'AlertDialogHeader',
    'AlertDialogTitle',
    'AlertDialogDescription',
    'AlertDialogFooter',
    'AlertDialogAction',
    'AlertDialogCancel',
  ],
  sourcePath: 'lib/src/components/ui/alert_dialog.dart',
);
