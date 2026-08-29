/// Documentation metadata for the `carousel` component.
///
/// **Split, 2026-08-24.** This directory used to carry three separately
/// barrel-exported components on one page: `Carousel`, `UserMenu`, and
/// `Marker`. `user_menu` and `marker` now own
/// `example/lib/components_docs/user_menu/` and
/// `example/lib/components_docs/marker/`, each with its own `meta.dart` and
/// `page.dart`. [carouselDoc] below is `Carousel` only; the two others are
/// `userMenuDoc` and `markerDoc`, in their own directories.
///
/// [carouselDoc] stays in `catalog.dart`'s `componentDocs` list, which is
/// supervisor-owned: wiring the two new entries in is not this file's job.
///
/// `carousel` ships `registry/components/carousel.json`, so `elattar add
/// carousel` resolves today. [dependencies] mirrors that manifest's
/// `registryDependencies`.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry carouselDoc = ComponentDocEntry(
  name: 'carousel',
  title: 'Carousel',
  description:
      'A horizontal snapping track driven by a reimplementation of Embla '
      "Carousel's own integrator physics: drag it, click either arrow, or "
      'press ArrowLeft/ArrowRight.',
  dependencies: <String>['button', 'icon', 'source-foundation'],
  exports: <String>['Carousel', 'CarouselController'],
  sourcePath: 'lib/src/components/ui/carousel.dart',
);
