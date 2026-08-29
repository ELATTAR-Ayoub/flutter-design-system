/// Public documentation metadata for the textarea component.
///
/// This entry feeds `TextareaDocPage` directly and matches the shipped
/// `elattar add textarea` install path.
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
  // Registry dependencies resolved by `elattar add textarea`.
  dependencies: <String>['field', 'input', 'source-foundation'],
  exports: <String>['Textarea'],
  sourcePath: 'lib/src/components/ui/textarea.dart',
);
