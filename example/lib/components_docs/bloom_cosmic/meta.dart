/// Public documentation metadata for the `bloom-cosmic` effect.
///
/// `bloom-cosmic` HAS a real `registry/effects/bloom-cosmic.json` manifest:
/// [dependencies] below is that manifest's own `registryDependencies` list,
/// copied verbatim: `keyframes`, `source-foundation`, `starfield` —
/// `keyframes` because the two drifts are built through `ElKeyframes.doubles`
/// keyframe tables, and `starfield` because [ElBloomCosmic] mounts
/// `ElStarfield` itself whenever its own `starfield` parameter is true (the
/// default). `page.dart` renders the real `elattar add bloom-cosmic`
/// command from it.
///
/// Not a component in the variant-enum sense: `lib/src/effects/
/// bloom_cosmic.dart` exports one widget, [ElBloomCosmic], with one general
/// constructor plus seven named ones that are fixed hue-pair presets — the
/// same five this system's own Alert paints (`.action`, `.destructive`,
/// `.success`, `.warning`, `.info`) plus the two toaster adds
/// (`.toastWarning`, `.loading`). The file also exports the two derivation
/// records the drift and the ink are built from, [ElBloomDrift] and
/// [ElBloomInk], and their [ElBloomDriftStop] keyframe entries — documented
/// here as what the widget itself declares rather than as a fourth table,
/// since a caller constructs [ElBloomCosmic] and nothing else.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry bloomCosmicDoc = ComponentDocEntry(
  name: 'bloom_cosmic',
  title: 'Bloom Cosmic',
  description:
      'The iridescence behind an Alert and a toast: two blurred, '
      'forever-drifting radial-gradient layers hung off a corner in the '
      'variant\'s own two hues, swelling on hover — with the starfield\'s '
      'sparkles riding along over the top.',
  // registry/effects/bloom-cosmic.json's own registryDependencies, verbatim.
  dependencies: <String>['keyframes', 'source-foundation', 'starfield'],
  exports: <String>[
    'ElBloomCosmic',
    'ElBloomDrift',
    'ElBloomDriftStop',
    'ElBloomInk',
  ],
  sourcePath: 'lib/src/effects/bloom_cosmic.dart',
);
