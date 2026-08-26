/// Public documentation metadata for the `foil-value` effect.
///
/// `foil-value` HAS a real `registry/effects/foil-value.json` manifest:
/// [dependencies] below is that manifest's own `registryDependencies` list,
/// copied verbatim: `machine-surface`, `source-foundation`. `page.dart`
/// renders the real `elattar add foil-value` command from it.
///
/// Not a component: `lib/src/effects/foil_value.dart` exports one
/// `StatefulWidget`, `ElFoilValue`, with no enum or size of its own — the
/// premium Button's surface, and only the premium Button's surface: a
/// seven-stop metal ramp, a drifting foil layer, and a sweeping glint, all
/// on one shared clock.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry foilValueDoc = ComponentDocEntry(
  name: 'foil_value',
  title: 'Foil Value',
  description:
      'The premium Button\'s surface: a seven-stop metal ramp under a '
      'drifting foil sheen and a sweeping glint, both perpetual, both on '
      'one shared elapsed clock. Rationed by design — reserve it for '
      'reward and money actions, never as a general-purpose gradient.',
  // registry/effects/foil-value.json's own registryDependencies, verbatim.
  dependencies: <String>['machine-surface', 'source-foundation'],
  exports: <String>['ElFoilValue'],
  sourcePath: 'lib/src/effects/foil_value.dart',
);
