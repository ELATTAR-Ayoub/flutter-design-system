/// Documentation metadata for the toaster component.
///
/// `toaster` has no `registry/components/*.json` manifest yet (its siblings
/// `alert-dialog`, `popover`, and `tooltip` do; `alert` does not either) —
/// see `docs/superpowers/plans/2026-08-23-phase-j-full-component-documentation.md`.
/// [toasterDoc.dependencies] is therefore left empty rather than naming
/// registry items that do not exist; the page's own install section states
/// the CLI gap in prose instead.
library;

import '../catalog.dart';

/// [ComponentDocEntry.description] is the one-sentence form for nav and
/// search. The page's own "Purpose" section carries the expanded,
/// decision-guidance description IA §9.2 also asks for: agreeing with the
/// same trio (alert / alert-dialog / toaster) the alert page's own Purpose
/// section already states.
///
/// [ComponentDocEntry.exports] names both halves of the public surface:
/// [ElToaster] itself is only the overlay host: every constructor a caller
/// actually fires (`toast.success(...)` and friends) lives on
/// [ElToastController], and both are documented in full on the page.
const ComponentDocEntry toasterDoc = ComponentDocEntry(
  name: 'toaster',
  title: 'Toaster',
  description:
      'A transient, self-dismissing notification stack mounted once at the '
      'app root, fired into from anywhere through a queue-backed controller.',
  dependencies: <String>[
    'bloom-cosmic',
    'icon',
    'machine-surface',
    'safe-area',
    'source-foundation',
  ],
  exports: <String>[
    'ElToaster',
    'ElToastController',
    'ElToastMessage',
    'ElToastAction',
    'ElToastType',
    'ElToastPosition',
    'ElToast',
  ],
  sourcePath: 'lib/src/components/toaster.dart',
);
