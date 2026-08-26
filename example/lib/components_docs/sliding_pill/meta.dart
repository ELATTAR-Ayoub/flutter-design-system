/// Public documentation metadata for the `sliding-pill` motion primitive.
///
/// `sliding-pill` is registry `type: "motion"` — `registry/motion/
/// sliding-pill.json`, not `registry/components/` — and [dependencies] is
/// that manifest's own `registryDependencies` list, copied verbatim:
/// `keyframes`, `source-foundation`.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry slidingPillDoc = ComponentDocEntry(
  name: 'sliding_pill',
  title: 'Sliding Pill',
  description:
      'A single travelling pill that measures the selected option and moves '
      'to it with a squash on arrival — selection travels, it never blinks '
      'on and off between options.',
  // registry/motion/sliding-pill.json's own registryDependencies, verbatim.
  dependencies: <String>['keyframes', 'source-foundation'],
  exports: <String>['ElSlidingPillGroup'],
  sourcePath: 'lib/src/motion/sliding_pill.dart',
);
