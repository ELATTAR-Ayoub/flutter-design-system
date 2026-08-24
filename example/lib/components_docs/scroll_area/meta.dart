/// Documentation metadata for the `scroll_area` component.
///
/// **Split.** This route used to carry `ElScrollArea`, `ElResizablePanelGroup`
/// and `ElAspectRatio` together under one [ComponentDocEntry] (see the git
/// history of this file for that shape). `ElResizablePanelGroup` and
/// `ElAspectRatio` now have their own routes and their own entries:
/// `example/lib/components_docs/resizable/meta.dart`'s `resizableDoc` and
/// `example/lib/components_docs/aspect_ratio/meta.dart`'s `aspectRatioDoc`.
/// [name], [route] (`/components/scroll_area`), and the page class
/// (`ScrollAreaDocPage`) are unchanged, so `catalog.dart`'s
/// `scroll_area.scrollAreaDoc` reference and `main.dart`'s route table
/// needed no edit for this third of the split.
///
/// Not wired into `catalog.dart`'s `componentDocs` list beyond the entry it
/// already carries: that file is supervisor-owned. `page.dart` reads
/// [scrollAreaDoc] directly rather than going through
/// `componentDoc('scroll_area')`.
///
/// `scroll_area` installs through `elattar add scroll-area`: see `page.dart`'s
/// installation section for the shipped command and registry dependencies. [dependencies] is left
/// empty rather than naming items a manifest does not yet resolve.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry scrollAreaDoc = ComponentDocEntry(
  name: 'scroll_area',
  title: 'Scroll area',
  description:
      'A styled scroll container with an optional hover-visible scrollbar '
      'for either axis.',
  dependencies: <String>['source-foundation'],
  exports: <String>['ElScrollArea', 'ElScrollAreaBehavior'],
  sourcePath: 'lib/src/components/scroll_area.dart',
);
