/// Documentation metadata for the `carousel`, `nav_user`, and `marker` components.
///
/// Not wired into `catalog.dart`'s `componentDocs` list — that file is
/// supervisor-owned. `page.dart` reads [carouselDoc], [navUserDoc], and
/// [markerDoc] directly rather than going through `componentDoc()`, so
/// these entries stand on their own until the supervisor aggregates them.
library;

import '../catalog.dart' show ComponentDocEntry;

/// `carousel` has no `registry/components/carousel.json` yet.
/// [dependencies] is left empty rather than naming items a manifest does not yet resolve.
const ComponentDocEntry carouselDoc = ComponentDocEntry(
  name: 'carousel',
  title: 'Carousel, Nav User, Marker',
  description:
      'A horizontal scrolling carousel with Embla physics, a sidebar account block, and a quiet separator row for lists.',
  dependencies: <String>[],
  exports: <String>[
    'DsCarousel',
    'DsCarouselController',
    'DsNavUser',
    'DsNavUserAccount',
    'DsNavUserItem',
    'DsMarker',
    'DsMarkerVariant',
  ],
  sourcePath: 'lib/src/components/carousel.dart',
);
