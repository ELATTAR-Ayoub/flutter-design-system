/// Documentation metadata for the toaster component.
///
/// `toaster` has a real `registry/components/toaster.json` manifest --
/// [dependencies] is that manifest's own `registryDependencies` list,
/// verbatim, so `page.dart`'s installation section can render the real
/// `elattar add toaster` command.
library;

import '../catalog.dart';

/// [ComponentDocEntry.description] is the one-sentence form for nav and
/// search. `page.dart`'s Dependencies disclosure carries the expanded,
/// decision-guidance prose naming the same trio (alert / alert-dialog /
/// toaster) `alert/page.dart`'s own Dependencies disclosure already states.
///
/// [ComponentDocEntry.exports] names both halves of the public surface:
/// [Toaster] itself is only the overlay host: every constructor a caller
/// actually fires (`toast.success(...)` and friends) lives on
/// [ToastController], and both are documented in full on the page.
const ComponentDocEntry toasterDoc = ComponentDocEntry(
  name: 'toaster',
  title: 'Toaster',
  description:
      'A transient, self-dismissing notification stack mounted once at the '
      'app root, fired into from anywhere through a queue-backed controller.',
  dependencies: <String>[
    'feedback-surface',
    'icon',
    'surface',
    'safe-area',
    'source-foundation',
  ],
  exports: <String>[
    'Toaster',
    'ToastController',
    'ToastMessage',
    'ToastAction',
    'ToastType',
    'ToastPosition',
    'Toast',
  ],
  sourcePath: 'lib/src/components/toaster.dart',
);
