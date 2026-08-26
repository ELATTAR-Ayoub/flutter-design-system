/// Public documentation metadata for the `lift` motion primitive.
///
/// `lift` is registry `type: "motion"` — `registry/motion/lift.json`, not
/// `registry/components/` — and [dependencies] is that manifest's own
/// `registryDependencies` list, copied verbatim: `source-foundation`. The
/// file exports two classes, both documented here: [ElLift], the bare hover
/// reporter, and [ElLiftCard], the standard card appearance built on it.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry liftDoc = ComponentDocEntry(
  name: 'lift',
  title: 'Lift',
  description:
      'A hover rise — translateY(-3px) onto a deeper shadow, with an '
      'optional border-colour swap — for a card or tile that answers the '
      'pointer the way the whole docs site\'s own cards do.',
  // registry/motion/lift.json's own registryDependencies, verbatim.
  dependencies: <String>['source-foundation'],
  exports: <String>['ElLift', 'ElLiftCard'],
  sourcePath: 'lib/src/motion/lift.dart',
);
