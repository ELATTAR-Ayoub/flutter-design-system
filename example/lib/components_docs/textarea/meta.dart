/// Public documentation metadata for the textarea component.
///
/// Not yet added to `catalog.dart`'s `componentDocs` list: that aggregation,
/// and the registry manifest textarea does not have yet, are supervisor-owned
/// (Phase J plan, "Supervisor duties between waves"). This entry exists so
/// `TextareaDocPage` has real install-target, export and source facts to
/// render without inventing them, the same shape the already-catalogued
/// components use.
library;

import '../catalog.dart';

const ComponentDocEntry textareaDoc = ComponentDocEntry(
  name: 'textarea',
  title: 'Textarea',
  description: 'A multi-line text field that grows with what is typed into it.',
  // No registry manifest exists for textarea yet (deliberately not added by
  // this worker: see the "Installation" section of the page itself), so
  // there are no registry dependencies to resolve automatically.
  dependencies: <String>[],
  exports: <String>['DsTextarea'],
  sourcePath: 'lib/src/components/textarea.dart',
);
