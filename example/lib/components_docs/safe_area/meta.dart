/// Public documentation metadata for the `safe-area` component.
///
/// **A user-ordered mobile adaptation, not a port.** Ordered 2026-08-16,
/// after screenshots showed the docs header sitting behind a phone's clock
/// and the reading column running under the gesture bar. The reference has
/// no counterpart to reproduce: a desktop browser has no status bar, and
/// `env(safe-area-inset-*)` — the one CSS spelling of this idea — appears
/// nowhere in `app/globals.css`. `lib/src/components/safe_area.dart` is
/// written to the ruling rather than to a source line: *"Backgrounds paint
/// edge-to-edge; content and interactive chrome respect
/// MediaQueryData.padding."*
///
/// `registry/components/safe-area.json` carries an empty
/// `registryDependencies` — [dependencies] below is that list, copied
/// verbatim (empty).
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry safeAreaDoc = ComponentDocEntry(
  name: 'safe_area',
  title: 'Safe Area',
  description:
      'The system-bar contract — a user-ordered mobile adaptation, not a '
      'port. Backgrounds paint edge-to-edge; content and interactive '
      'chrome move to clear the status bar and the gesture pill.',
  // registry/components/safe-area.json's own registryDependencies,
  // verbatim: empty.
  dependencies: <String>[],
  exports: <String>['ElSafeArea'],
  sourcePath: 'lib/src/components/safe_area.dart',
);
