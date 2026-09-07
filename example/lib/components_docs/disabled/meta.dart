/// Public documentation metadata for the `disabled` component.
///
/// `disabled` has a real `registry/components/disabled.json` manifest —
/// [dependencies] is that manifest's own `registryDependencies`, copied
/// verbatim (`['tooltip', 'source-foundation']`), not a guess at
/// `disabled.dart`'s internal imports.
///
/// The file `lib/src/components/ui/disabled.dart` exports [Disabled] — the
/// one shared `.disabled` class every control in this system goes through:
/// the fade, the pointer block, the cursor swap, the reason tooltip and the
/// tap hook live here and nowhere else.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry disabledDoc = ComponentDocEntry(
  name: 'disabled',
  title: 'Disabled',
  description:
      'The shared disabled-state wrapper: dims through the surface opacity '
      'token, blocks pointer input, swaps the cursor and shows a reason '
      'tooltip on hover or touch tap.',
  // registry/components/disabled.json's own registryDependencies, verbatim.
  dependencies: <String>['tooltip', 'source-foundation'],
  exports: <String>['Disabled'],
  sourcePath: 'lib/src/components/ui/disabled.dart',
);
