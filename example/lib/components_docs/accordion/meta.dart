/// Documentation metadata for the accordion component.
///
/// A worker-owned file: the supervisor folds [accordionDoc] into
/// `catalog.dart`'s `componentDocs` list in a later, serialized pass. This
/// file only ever imports `catalog.dart` for the [ComponentDocEntry] shape —
/// it never edits it.
library;

import '../catalog.dart';

/// `accordion` has no `registry/components/accordion.json` yet, so
/// [dependencies] names the real modules the source imports (for the
/// dependencies panel) rather than a validated `registryDependencies` list.
/// `page.dart`'s installation section says plainly that the component is
/// already usable through the published package — it is exported from the
/// barrel — but not yet through `elattar add accordion`.
const ComponentDocEntry accordionDoc = ComponentDocEntry(
  name: 'accordion',
  title: 'Accordion',
  description:
      'A vertical stack of disclosures where opening one panel closes '
      'whichever other panel was open.',
  dependencies: <String>[
    'source-foundation',
    'machine-surface',
    'button',
    'icon',
    'collapsible',
  ],
  exports: <String>['DsAccordion', 'DsAccordionItem'],
  sourcePath: 'lib/src/components/accordion.dart',
);
