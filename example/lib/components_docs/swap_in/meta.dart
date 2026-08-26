/// Public documentation metadata for the `swap-in` motion primitive.
///
/// `swap-in` is registry `type: "motion"` — `registry/motion/swap-in.json`,
/// not `registry/components/` — and [dependencies] is that manifest's own
/// `registryDependencies` list, copied verbatim: `keyframes`,
/// `source-foundation`.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry swapInDoc = ComponentDocEntry(
  name: 'swap_in',
  title: 'Swap In',
  description:
      'A 250ms spring pop — opacity 0 to 1, scale 0.96 to 1 — for content '
      'replacing content in the same slot: a figure that just changed value, '
      'never a fresh mount that should read as an arrival from nowhere.',
  // registry/motion/swap-in.json's own registryDependencies, verbatim.
  dependencies: <String>['keyframes', 'source-foundation'],
  exports: <String>['ElSwapIn'],
  sourcePath: 'lib/src/motion/swap_in.dart',
);
