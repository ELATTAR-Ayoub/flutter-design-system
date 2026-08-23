/// Public documentation metadata for the tabs component.
///
/// Not yet added to `catalog.dart`'s `componentDocs` list — that aggregation,
/// and the registry manifest tabs does not have yet, are supervisor-owned
/// (Phase J plan, "Supervisor duties between waves"). This entry exists so
/// `TabsDocPage` has real install-target, export and source facts to render
/// without inventing them, the same shape the five already catalogued
/// components use.
library;

import '../catalog.dart';

const ComponentDocEntry tabsDoc = ComponentDocEntry(
  name: 'tabs',
  title: 'Tabs',
  description:
      'A track of triggers with one travelling mark, switching between the '
      'panels of a single page.',
  // No registry manifest exists for tabs yet (deliberately not added by this
  // worker — see the "Installation" section of the page itself), so there
  // are no registry dependencies to resolve automatically.
  dependencies: <String>[],
  exports: <String>['DsTabs', 'DsTabItem', 'DsTabsVariant'],
  sourcePath: 'lib/src/components/tabs.dart',
);
