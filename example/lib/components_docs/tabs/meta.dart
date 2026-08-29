/// Public documentation metadata for the tabs component.
///
/// This entry feeds `TabsDocPage` directly and matches the shipped
/// `elattar add tabs` install path.
/// (Phase J plan, "Supervisor duties between waves"). This entry exists so
/// `TabsDocPage` has real install-target, export and source facts to render
/// without inventing them, the same shape the five already catalogued
/// components use.
///
/// [ComponentDocEntry.description] is the page's only rendered description:
/// the one-sentence form for nav, search, and the page's own hero line.
library;

import '../catalog.dart';

const ComponentDocEntry tabsDoc = ComponentDocEntry(
  name: 'tabs',
  title: 'Tabs',
  description:
      'A track of triggers with one travelling mark, switching between the '
      'panels of a single page.',
  // Registry dependencies resolved by `elattar add tabs`.
  dependencies: <String>[
    'button',
    'surface',
    'active-indicator',
    'source-foundation',
  ],
  exports: <String>['Tabs', 'TabItem', 'TabsVariant'],
  sourcePath: 'lib/src/components/ui/tabs.dart',
);
