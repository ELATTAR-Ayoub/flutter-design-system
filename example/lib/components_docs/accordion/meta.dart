/// Documentation metadata for the accordion component.
///
/// A worker-owned file: the supervisor folds [accordionDoc] into
/// `catalog.dart`'s `componentDocs` list in a later, serialized pass. This
/// file only ever imports `catalog.dart` for the [ComponentDocEntry] shape —
/// it never edits it.
///
/// [ComponentDocEntry.description] is the page's only rendered description:
/// the one-sentence form for nav, search, and the page's own hero line.
library;

import '../catalog.dart';

/// `accordion` has no `registry/components/accordion.json` yet, so
/// [dependencies] names the real modules the source imports (for the
/// dependencies panel) rather than a validated `registryDependencies` list.
/// `page.dart`'s installation section says plainly that the component is
/// already usable through the published package: it is exported from the
/// barrel: but not yet through `elattar add accordion`.
const ComponentDocEntry accordionDoc = ComponentDocEntry(
  name: 'accordion',
  title: 'Accordion',
  description:
      'A vertical stack of disclosures where opening one panel closes '
      'whichever other panel was open.',
  dependencies: <String>[
    'button',
    'collapsible',
    'icon',
    'surface',
    'source-foundation',
  ],
  exports: <String>['Accordion', 'AccordionItem'],
  sourcePath: 'lib/src/components/ui/accordion.dart',
);
