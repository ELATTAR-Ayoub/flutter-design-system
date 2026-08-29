/// Public documentation metadata for the `active-indicator` motion primitive.
///
/// `active-indicator` is registry `type: "motion"` — `registry/components/
/// active-indicator.json`, not `registry/components/` — and [dependencies] is
/// that manifest's own `registryDependencies` list, copied verbatim:
/// `keyframes`, `source-foundation`.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry activeIndicatorDoc = ComponentDocEntry(
  name: 'active_indicator',
  title: 'Active Indicator',
  description:
      'A single travelling pill that measures the selected option and moves '
      'to it with a squash on arrival — selection travels, it never blinks '
      'on and off between options.',
  // registry/components/active-indicator.json's own registryDependencies, verbatim.
  dependencies: <String>['keyframes', 'source-foundation'],
  exports: <String>['ActiveIndicator'],
  sourcePath: 'lib/src/components/ui/active_indicator.dart',
);
