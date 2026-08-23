/// Public documentation metadata for the checkbox component.
///
/// Not yet added to `catalog.dart`'s `componentDocs` list — that aggregation,
/// and the registry manifest checkbox does not have yet, are supervisor-owned
/// (Phase J plan, "Supervisor duties between waves"). This entry exists so
/// `CheckboxDocPage` has real install-target, export and source facts to
/// render without inventing them, exactly the same shape the five already
/// catalogued components use.
library;

import '../catalog.dart';

const ComponentDocEntry checkboxDoc = ComponentDocEntry(
  name: 'checkbox',
  title: 'Checkbox',
  description:
      'A tri-state control for one value a user can toggle independently of '
      'any other option.',
  // No registry manifest exists for checkbox yet (deliberately not added by
  // this worker — see the "Installation" section of the page itself), so
  // there are no registry dependencies to resolve automatically.
  dependencies: <String>[],
  exports: <String>['DsCheckbox', 'DsCheckboxState'],
  sourcePath: 'lib/src/components/checkbox.dart',
);
