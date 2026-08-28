/// Public documentation metadata for the `feedback-surface` effect.
///
/// `feedback-surface` HAS a real `registry/components/feedback-surface.json` manifest:
/// [dependencies] below is that manifest's own `registryDependencies` list,
/// copied verbatim: `keyframes`, `source-foundation`, `starfield` —
/// `keyframes` because the two drifts are built through `Keyframes.doubles`
/// keyframe tables, and `starfield` because [FeedbackSurface] mounts
/// `AmbientPattern` itself whenever its own `starfield` parameter is true (the
/// default). `page.dart` renders the real `elattar add feedback-surface`
/// command from it.
///
/// Not a component in the variant-enum sense: `lib/src/components/ui/
/// feedback_surface.dart` exports one widget, [FeedbackSurface], with one general
/// constructor plus seven named ones that are fixed hue-pair presets — the
/// same five this system's own Alert paints (`.action`, `.destructive`,
/// `.success`, `.warning`, `.info`) plus the two toaster adds
/// (`.toastWarning`, `.loading`). The file also exports the two derivation
/// records the drift and the ink are built from, [BloomDrift] and
/// [BloomInk], and their [BloomDriftStop] keyframe entries — documented
/// here as what the widget itself declares rather than as a fourth table,
/// since a caller constructs [FeedbackSurface] and nothing else.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry feedbackSurfaceDoc = ComponentDocEntry(
  name: 'feedback_surface',
  title: 'Bloom Cosmic',
  description:
      'The iridescence behind an Alert and a toast: two blurred, '
      'forever-drifting radial-gradient layers hung off a corner in the '
      'variant\'s own two hues, swelling on hover — with the starfield\'s '
      'sparkles riding along over the top.',
  // registry/components/feedback-surface.json's own registryDependencies, verbatim.
  dependencies: <String>['keyframes', 'source-foundation', 'starfield'],
  exports: <String>[
    'FeedbackSurface',
    'BloomDrift',
    'BloomDriftStop',
    'BloomInk',
  ],
  sourcePath: 'lib/src/components/ui/feedback_surface.dart',
);
