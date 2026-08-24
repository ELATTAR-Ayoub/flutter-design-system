/// Documentation metadata for the `marker` component.
///
/// Split out of `components_docs/carousel/` on 2026-08-24: `ElMarker` and
/// `ElMarkerVariant` are their own barrel export
/// (`export 'src/components/marker.dart';`) and now own their own page.
///
/// Not wired into `catalog.dart`'s `componentDocs` list: that file is
/// supervisor-owned. `page.dart` reads [markerDoc] directly.
library;

import '../catalog.dart' show ComponentDocEntry;

/// `marker` has no `registry/components/marker.json` yet.
/// [ComponentDocEntry.dependencies] is left empty rather than naming items a
/// manifest does not yet resolve.
const ComponentDocEntry markerDoc = ComponentDocEntry(
  name: 'marker',
  title: 'Marker',
  description:
      'A quiet row that says something happened between the rows around it: '
      '"Today", "Context cleared", "3 messages hidden". Not a highlight, and '
      'it draws no background.',
  dependencies: <String>['source-foundation'],
  exports: <String>['ElMarker', 'ElMarkerVariant'],
  sourcePath: 'lib/src/components/marker.dart',
);
