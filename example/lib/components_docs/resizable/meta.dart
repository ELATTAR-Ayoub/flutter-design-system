/// Documentation metadata for the `resizable` component.
///
/// **New route, split out of `scroll_area`.** `ResizablePanelGroup` used
/// to share `/components/scroll_area` with `ScrollArea` and
/// `AspectRatio` under one shared `ComponentDocEntry` (see
/// `scroll_area/meta.dart`'s own note for the split). It now has its own
/// [name], its own route (`/components/resizable`), and its own page class
/// (`ResizableDocPage`).
///
/// **Corrected.** This file used to claim the entry was not wired into
/// `catalog.dart`'s `componentDocs` list and that `registry/components/
/// resizable.json` did not exist yet, with [dependencies] left empty for
/// that reason. All three are stale: `catalog.dart`'s `componentDocs` list
/// carries `resizable.resizableDoc`, `registry/components/resizable.json`
/// is a real, shipped manifest today, `registry/generated/latest/
/// registry.json` carries `resizable`, and `elattar add resizable` is a
/// genuine, working command. [dependencies] below already matches the
/// manifest's own `registryDependencies` list, verbatim:
/// `source-foundation` only.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry resizableDoc = ComponentDocEntry(
  name: 'resizable',
  title: 'Resizable',
  description:
      'A row of panels with a draggable separator between every pair, '
      'each with its own pixel floor.',
  dependencies: <String>['source-foundation'],
  exports: <String>['ResizablePanelGroup', 'ResizablePanel'],
  sourcePath: 'lib/src/components/ui/resizable.dart',
);
