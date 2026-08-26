/// Public documentation metadata for the `starfield` effect.
///
/// `starfield` HAS a real `registry/effects/starfield.json` manifest:
/// [dependencies] below is that manifest's own `registryDependencies` list,
/// copied verbatim: `icon`, `source-foundation` — `icon` because
/// `lib/src/effects/starfield.dart` paints each sparkle from
/// `ElIconPaths.sparkleElement` / `ElIconPaths.viewBox` rather than declaring
/// its own path data. `page.dart` renders the real `elattar add starfield`
/// command from it.
///
/// Not a component: the file exports three classes and none of them has a
/// variant enum. [ElStarfield] is the widget a caller mounts —
/// `Positioned.fill` over a host's box, taking the host's own resolved
/// `--bloom-2` and its live hover boolean. [ElStarfieldCluster] and
/// [ElSparkle] are the two data records the widget is built from: a cluster
/// is a corner, a sway and eight or five hand-placed sparkles; a sparkle is
/// an opacity/position/scale triple. In this design system's own source,
/// [ElStarfield] is never constructed directly by an app widget — it is
/// always mounted by `ElBloomCosmic`, which is why this page's own specimens
/// hang it over a bare themed panel rather than reproducing that nesting.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry starfieldDoc = ComponentDocEntry(
  name: 'starfield',
  title: 'Starfield',
  description:
      'Thirteen hand-placed sparkles across two independently-swaying '
      'clusters, anchored to a corner and clipped to whatever box they '
      'hang off — the dust that rides along wherever bloom-cosmic hangs '
      'its corner light.',
  // registry/effects/starfield.json's own registryDependencies, verbatim.
  dependencies: <String>['icon', 'source-foundation'],
  exports: <String>['ElStarfield', 'ElStarfieldCluster', 'ElSparkle'],
  sourcePath: 'lib/src/effects/starfield.dart',
);
