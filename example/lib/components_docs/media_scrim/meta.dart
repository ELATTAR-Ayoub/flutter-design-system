/// Public documentation metadata for the `media-scrim` effect.
///
/// `media-scrim` HAS a real `registry/components/media-scrim.json` manifest:
/// [dependencies] below is that manifest's own `registryDependencies` list,
/// copied verbatim: `source-foundation`. `page.dart` renders the real
/// `elattar add media-scrim` command from it.
///
/// Not a component: `lib/src/components/ui/media_scrim.dart` exports one
/// `StatelessWidget`, `MediaScrim`, with no variant, no size, and exactly
/// one constructor parameter (`child`). It is a sizing-preserving,
/// top-to-bottom readability gradient for copy placed directly on media —
/// the same treatment `showcase_reels.dart`'s reels overlay uses.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry mediaScrimDoc = ComponentDocEntry(
  name: 'media_scrim',
  title: 'Media Scrim',
  description:
      'Bottom-up media contrast that keeps overlaid title and action copy '
      'readable without adding an opaque information card: fully '
      'transparent at the top, rising to a readable neutral ink only '
      'toward the bottom edge.',
  // registry/components/media-scrim.json's own registryDependencies, verbatim.
  dependencies: <String>['source-foundation'],
  exports: <String>['MediaScrim'],
  sourcePath: 'lib/src/components/ui/media_scrim.dart',
);
