/// Public documentation metadata for the `content-change` motion primitive.
///
/// `content-change` is registry `type: "motion"` — `registry/components/content-change.json`,
/// not `registry/components/` — and [dependencies] is that manifest's own
/// `registryDependencies` list, copied verbatim: `keyframes`,
/// `source-foundation`.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry contentChangeDoc = ComponentDocEntry(
  name: 'content_change',
  title: 'Content Change',
  description:
      'A 250ms spring pop — opacity 0 to 1, scale 0.96 to 1 — for content '
      'replacing content in the same slot: a figure that just changed value, '
      'never a fresh mount that should read as an arrival from nowhere.',
  // registry/components/content-change.json's own registryDependencies, verbatim.
  dependencies: <String>['keyframes', 'source-foundation'],
  exports: <String>['ContentChange'],
  sourcePath: 'lib/src/components/ui/content_change.dart',
);
