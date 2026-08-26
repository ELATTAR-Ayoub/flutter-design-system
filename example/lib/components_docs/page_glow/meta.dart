/// Public documentation metadata for the `page-glow` effect.
///
/// `page-glow` HAS a real `registry/effects/page-glow.json` manifest:
/// [dependencies] below is that manifest's own `registryDependencies` list,
/// copied verbatim: `source-foundation`. `page.dart` renders the real
/// `elattar add page-glow` command from it.
///
/// Not a component: `lib/src/effects/page_glow.dart` exports one
/// `StatelessWidget`, [ElPageGlow], with exactly one constructor parameter
/// (`child`) and no variant, no size, and — per the source's own comment —
/// no animation: it is the flat page floor every route in this system's own
/// example app is painted onto, `Positioned.fill` behind the scroll view so
/// the atmosphere never scrolls with the content.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry pageGlowDoc = ComponentDocEntry(
  name: 'page_glow',
  title: 'Page Glow',
  description:
      'The page atmosphere: a wide, off-centre radial gradient painted '
      'behind the background fill, fixed to the viewport rather than the '
      'scroll — the difference between a flat fill reading as paint and '
      'the same fill reading as a deep room.',
  // registry/effects/page-glow.json's own registryDependencies, verbatim.
  dependencies: <String>['source-foundation'],
  exports: <String>['ElPageGlow'],
  sourcePath: 'lib/src/effects/page_glow.dart',
);
