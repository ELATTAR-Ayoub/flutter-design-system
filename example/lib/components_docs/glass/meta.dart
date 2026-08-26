/// Public documentation metadata for the `glass` effect.
///
/// `glass` HAS a real `registry/effects/glass.json` manifest: [dependencies]
/// below is that manifest's own `registryDependencies` list, copied
/// verbatim: `machine-surface`, `source-foundation`. `page.dart` renders the
/// real `elattar add glass` command from it.
///
/// Not a component: `lib/src/effects/glass.dart` exports four
/// `StatelessWidget`s, none with a variant or size of their own —
/// `ElGlassPanel`, `ElGlassPanelClear`, `ElGlassPanelDeep`, and
/// `ElGlassControl`, one material split by scale (globals.css's own
/// `glass-panel` / `glass-panel-deep` / `glass-control` utilities).
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry glassDoc = ComponentDocEntry(
  name: 'glass',
  title: 'Glass',
  description:
      'A surface in front of the page rather than cut out of it: a '
      'translucent card fill, a backdrop blur, and a hairline rim, split '
      'by scale into a card-weight panel and a blur-free control. Reach '
      'for it over an opaque card when the page\'s own light should show '
      'through.',
  // registry/effects/glass.json's own registryDependencies, verbatim.
  dependencies: <String>['machine-surface', 'source-foundation'],
  exports: <String>[
    'ElGlassPanel',
    'ElGlassPanelClear',
    'ElGlassPanelDeep',
    'ElGlassControl',
  ],
  sourcePath: 'lib/src/effects/glass.dart',
);
