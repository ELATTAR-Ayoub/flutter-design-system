/// Public documentation metadata for the `press` motion primitive.
///
/// `press` is registry `type: "motion"` — `registry/components/press.json`,
/// not `registry/components/` — and [dependencies] is that manifest's own
/// `registryDependencies` list, copied verbatim: `source-foundation`. The
/// file `lib/src/components/ui/press.dart` exports exactly one class, [Press]: a
/// wrapper that gives its `child` the CSS `press` utility's own click feel —
/// an instant squish on pointer-down, a springy return on release.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry pressDoc = ComponentDocEntry(
  name: 'press',
  title: 'Press Motion',
  description:
      'The click feel: squishes a child to a token-backed scale on '
      'pointer-down and springs it back on release, 40ms in and 250ms '
      'out — for anything clickable that is not a Button.',
  // registry/components/press.json's own registryDependencies, verbatim.
  dependencies: <String>['source-foundation'],
  exports: <String>['Press'],
  sourcePath: 'lib/src/components/ui/press.dart',
);
