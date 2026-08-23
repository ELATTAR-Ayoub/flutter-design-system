/// Public documentation metadata for the radio group component.
///
/// Not yet added to `catalog.dart`'s `componentDocs` list — that aggregation,
/// and the registry manifest radio does not have yet, are supervisor-owned
/// (Phase J plan, "Supervisor duties between waves"). This entry exists so
/// `RadioDocPage` has real install-target, export and source facts to render
/// without inventing them, exactly the same shape `checkboxDoc` uses.
library;

import '../catalog.dart';

const ComponentDocEntry radioDoc = ComponentDocEntry(
  name: 'radio',
  title: 'Radio group',
  description:
      'An exclusive choice among a small, fully visible set of mutually '
      'exclusive options.',
  // No registry manifest exists for radio yet (deliberately not added by
  // this worker — see the "Installation" section of the page itself), so
  // there are no registry dependencies to resolve automatically.
  dependencies: <String>[],
  exports: <String>['DsRadioGroup', 'DsRadioGroupItem'],
  sourcePath: 'lib/src/components/radio.dart',
);
