/// Public documentation metadata for the icon component.
///
/// `icon` has a real `registry/components/icon.json` manifest —
/// [dependencies] is the manifest's own `registryDependencies` list,
/// verbatim, `['source-foundation']`: so `page.dart`'s installation
/// section can render the real `elattar add icon` command.
library;

import '../catalog.dart';

const ComponentDocEntry iconDoc = ComponentDocEntry(
  name: 'icon',
  title: 'Icon',
  description:
      'Curated, token-sized icon renderer and generated path catalog used by interactive components.',
  // registry/components/icon.json's registryDependencies, verbatim.
  dependencies: <String>['source-foundation'],
  exports: <String>['Icon', 'IconGlyph', 'IconSize', 'IconTone'],
  sourcePath: 'lib/src/components/ui/icon.dart',
);
