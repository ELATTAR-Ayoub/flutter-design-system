/// Public documentation metadata for the `machine-surface` effect.
///
/// `machine-surface` HAS a real `registry/effects/machine-surface.json`
/// manifest: [dependencies] below is that manifest's own `registryDependencies`
/// list, copied verbatim: `source-foundation`. `page.dart` renders the real
/// `elattar add machine-surface` command from it.
///
/// This is not a component: [ElMachineSurface] paints the `--shadow-*`
/// specs Flutter's own `BoxDecoration` cannot — the inset layers CSS calls
/// `inset box-shadow` — around and inside a child. It carries no variant of
/// its own; every button variant but `primary` and `premium` is one.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry machineSurfaceDoc = ComponentDocEntry(
  name: 'machine_surface',
  title: 'Machine Surface',
  description:
      'The shadow specs CSS can paint and Flutter cannot: outer drop '
      'shadows and inset highlight/shade layers, composited in CSS order '
      'around one child. What makes an outline button, an input, and every '
      'other flat control read as something with a socket to press into.',
  // registry/effects/machine-surface.json's own registryDependencies,
  // verbatim.
  dependencies: <String>['source-foundation'],
  exports: <String>['ElMachineSurface'],
  sourcePath: 'lib/src/effects/machine_surface.dart',
);
