/// Public documentation metadata for the `surface` effect.
///
/// `surface` HAS a real `registry/components/surface.json`
/// manifest: [dependencies] below is that manifest's own `registryDependencies`
/// list, copied verbatim: `source-foundation`. `page.dart` renders the real
/// `elattar add surface` command from it.
///
/// This is not a component: [Surface] paints the `--shadow-*`
/// specs Flutter's own `BoxDecoration` cannot — the inset layers CSS calls
/// `inset box-shadow` — around and inside a child. It carries no variant of
/// its own; every button variant but `primary` and `premium` is one.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry surfaceDoc = ComponentDocEntry(
  name: 'surface',
  title: 'Surface',
  description:
      'The shadow specs CSS can paint and Flutter cannot: outer drop '
      'shadows and inset highlight/shade layers, composited in CSS order '
      'around one child. What makes an outline button, an input, and every '
      'other flat control read as something with a socket to press into.',
  // registry/components/surface.json's own registryDependencies,
  // verbatim.
  dependencies: <String>['source-foundation'],
  exports: <String>['Surface'],
  sourcePath: 'lib/src/components/ui/surface.dart',
);
