/// Documentation metadata for the `resizable` component.
///
/// **New route, split out of `scroll_area`.** `ElResizablePanelGroup` used
/// to share `/components/scroll_area` with `ElScrollArea` and
/// `ElAspectRatio` under one shared `ComponentDocEntry` (see
/// `scroll_area/meta.dart`'s own note for the split). It now has its own
/// [name], its own route (`/components/resizable`), and its own page class
/// (`ResizableDocPage`).
///
/// Not wired into `catalog.dart`'s `componentDocs` list: that file is
/// supervisor-owned, and this entry is new. `page.dart` reads [resizableDoc]
/// directly rather than going through `componentDoc('resizable')`.
///
/// `registry/components/resizable.json` does not exist yet: see `page.dart`'s
/// installation section for the shipped command and registry dependencies. [dependencies] is left
/// empty rather than naming items a manifest does not yet resolve.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry resizableDoc = ComponentDocEntry(
  name: 'resizable',
  title: 'Resizable',
  description:
      'A row of panels with a draggable separator between every pair, '
      'each with its own pixel floor.',
  dependencies: <String>['source-foundation'],
  exports: <String>['ElResizablePanelGroup', 'ElResizablePanel'],
  sourcePath: 'lib/src/components/resizable.dart',
);
