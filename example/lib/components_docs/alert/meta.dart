/// Documentation metadata for the alert component.
///
/// `alert` has a real `registry/components/alert.json` manifest --
/// [dependencies] is that manifest's own `registryDependencies` list,
/// verbatim, so `page.dart`'s installation section can render the real
/// `elattar add alert` command.
library;

import '../catalog.dart';

/// [ComponentDocEntry.description] is the one-sentence form for nav and
/// search. `page.dart`'s Dependencies disclosure carries the expanded,
/// decision-guidance prose naming ElAlert's nearest neighbours (alert
/// dialog, toaster) that IA §9.2 also asks for.
const ComponentDocEntry alertDoc = ComponentDocEntry(
  name: 'alert',
  title: 'Alert',
  description:
      'A persistent inline message that shares one bordered card surface '
      'across five variants, told apart only by icon color and bloom.',
  dependencies: <String>['bloom-cosmic', 'source-foundation'],
  exports: <String>['ElAlert', 'ElAlertVariant'],
  sourcePath: 'lib/src/components/alert.dart',
);
