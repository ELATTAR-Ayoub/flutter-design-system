/// Documentation metadata for the `marker` component.
///
/// Split out of `components_docs/carousel/` on 2026-08-24: `Marker` and
/// `MarkerVariant` are their own barrel export
/// (`export 'src/components/marker.dart';`) and now own their own page.
///
/// Not wired into `catalog.dart`'s `componentDocs` list: that file is
/// supervisor-owned. `page.dart` reads [markerDoc] directly.
library;

import '../catalog.dart' show ComponentDocEntry;

/// `registry/components/marker.json` ships today: [dependencies] is that
/// manifest's own `registryDependencies` list, verbatim, so `page.dart`'s
/// Installation section can render the real `elattar add marker` command.
const ComponentDocEntry markerDoc = ComponentDocEntry(
  name: 'marker',
  title: 'Marker',
  description:
      'A quiet row that says something happened between the rows around it: '
      '"Today", "Context cleared", "3 messages hidden". Not a highlight, and '
      'it draws no background.',
  dependencies: <String>['source-foundation'],
  exports: <String>['Marker', 'MarkerVariant'],
  sourcePath: 'lib/src/components/marker.dart',
);
