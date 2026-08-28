/// Public documentation metadata for the `starfield` effect.
///
/// `starfield` HAS a real `registry/components/starfield.json` manifest:
/// [dependencies] below is that manifest's own `registryDependencies` list,
/// copied verbatim: `icon`, `source-foundation` — `icon` because
/// `lib/src/components/ui/starfield.dart` paints each sparkle from
/// `IconPaths.sparkleElement` / `IconPaths.viewBox` rather than declaring
/// its own path data. `page.dart` renders the real `elattar add ambient-pattern`
/// command from it.
///
/// Not a component: the file exports three classes and none of them has a
/// variant enum. [AmbientPattern] is the widget a caller mounts —
/// `Positioned.fill` over a host's box, taking the host's own resolved
/// `--bloom-2` and its live hover boolean. [StarfieldCluster] and
/// [Sparkle] are the two data records the widget is built from: a cluster
/// is a corner, a sway and eight or five hand-placed sparkles; a sparkle is
/// an opacity/position/scale triple. In this design system's own source,
/// [AmbientPattern] is never constructed directly by an app widget — it is
/// always mounted by `FeedbackSurface`, which is why this page's own specimens
/// hang it over a bare themed panel rather than reproducing that nesting.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry ambientPatternDoc = ComponentDocEntry(
  name: 'ambient_pattern',
  title: 'Ambient Pattern',
  description:
      'Thirteen hand-placed sparkles across two independently-swaying '
      'clusters, anchored to a corner and clipped to whatever box they '
      'hang off — the dust that rides along wherever feedback-surface hangs '
      'its corner light.',
  // registry/components/starfield.json's own registryDependencies, verbatim.
  dependencies: <String>['icon', 'source-foundation'],
  exports: <String>['AmbientPattern', 'StarfieldCluster', 'Sparkle'],
  sourcePath: 'lib/src/components/ui/ambient_pattern.dart',
);
