/// Public documentation metadata for the checkbox component.
///
/// This entry feeds `CheckboxDocPage` directly and matches the shipped
/// `elattar add checkbox` install path.
/// (Phase J plan, "Supervisor duties between waves"). This entry exists so
/// `CheckboxDocPage` has real install-target, export and source facts to
/// render without inventing them, exactly the same shape the five already
/// catalogued components use.
///
/// [ComponentDocEntry.description] is the page's only rendered description:
/// the one-sentence form for nav, search, and the page's own hero line.
library;

import '../catalog.dart';

const ComponentDocEntry checkboxDoc = ComponentDocEntry(
  name: 'checkbox',
  title: 'Checkbox',
  description:
      'A tri-state control for one value a user can toggle independently of '
      'any other option.',
  // Registry dependencies resolved by `elattar add checkbox`.
  dependencies: <String>[
    'field',
    'icon',
    'keyframes',
    'selection-control',
    'source-foundation',
  ],
  exports: <String>['Checkbox', 'CheckboxState'],
  sourcePath: 'lib/src/components/checkbox.dart',
);
