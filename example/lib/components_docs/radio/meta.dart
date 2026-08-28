/// Public documentation metadata for the radio group component.
///
/// This entry feeds `RadioDocPage` directly and matches the shipped
/// `elattar add radio` install path.
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
  // Registry dependencies resolved by `elattar add radio`.
  dependencies: <String>[
    'field',
    'keyframes',
    'surface',
    'selection-control',
    'source-foundation',
  ],
  exports: <String>['RadioGroup', 'RadioGroupItem'],
  sourcePath: 'lib/src/components/radio.dart',
);
