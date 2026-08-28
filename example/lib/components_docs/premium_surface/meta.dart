/// Public documentation metadata for the `premium-surface` effect.
///
/// `premium-surface` HAS a real `registry/components/premium-surface.json` manifest:
/// [dependencies] below is that manifest's own `registryDependencies` list,
/// copied verbatim: `surface`, `source-foundation`. `page.dart`
/// renders the real `elattar add premium-surface` command from it.
///
/// Not a component: `lib/src/components/ui/premium_surface.dart` exports one
/// `StatefulWidget`, `PremiumSurface`, with no enum or size of its own — the
/// premium Button's surface, and only the premium Button's surface: a
/// seven-stop metal ramp, a drifting foil layer, and a sweeping glint, all
/// on one shared clock.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry premiumSurfaceDoc = ComponentDocEntry(
  name: 'premium_surface',
  title: 'Foil Value',
  description:
      'The premium Button\'s surface: a seven-stop metal ramp under a '
      'drifting foil sheen and a sweeping glint, both perpetual, both on '
      'one shared elapsed clock. Rationed by design — reserve it for '
      'reward and money actions, never as a general-purpose gradient.',
  // registry/components/premium-surface.json's own registryDependencies, verbatim.
  dependencies: <String>['surface', 'source-foundation'],
  exports: <String>['PremiumSurface'],
  sourcePath: 'lib/src/components/ui/premium_surface.dart',
);
