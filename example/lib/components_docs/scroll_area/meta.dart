/// Documentation metadata for the `scroll_area` component.
///
/// **Split.** This route used to carry `ScrollArea`, `ResizablePanelGroup`
/// and `AspectRatio` together under one [ComponentDocEntry] (see the git
/// history of this file for that shape). `ResizablePanelGroup` and
/// `AspectRatio` now have their own routes and their own entries:
/// `example/lib/components_docs/resizable/meta.dart`'s `resizableDoc` and
/// `example/lib/components_docs/aspect_ratio/meta.dart`'s `aspectRatioDoc`.
/// [name], [route] (`/components/scroll_area`), and the page class
/// (`ScrollAreaDocPage`) are unchanged, so `catalog.dart`'s
/// `scroll_area.scrollAreaDoc` reference and `main.dart`'s route table
/// needed no edit for this third of the split.
///
/// `catalog.dart`'s `componentDocs` list already carries
/// `scroll_area.scrollAreaDoc`. `page.dart` reads [scrollAreaDoc] directly
/// rather than going through `componentDoc('scroll_area')`.
///
/// `scroll_area` has a real registry manifest,
/// `registry/components/scroll-area.json` (hyphenated, matching the
/// registry's own naming), which installs through `elattar add
/// scroll-area` and lists exactly one registry dependency:
/// `source-foundation`. [dependencies] mirrors that shipped manifest, not
/// an invented list — a previous version of this comment claimed
/// [dependencies] was "left empty," which was never true.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry scrollAreaDoc = ComponentDocEntry(
  name: 'scroll_area',
  title: 'Scroll area',
  description:
      'A styled scroll container with an optional hover-visible scrollbar '
      'for either axis.',
  dependencies: <String>['source-foundation'],
  exports: <String>['ScrollArea', 'ScrollAreaBehavior'],
  sourcePath: 'lib/src/components/ui/scroll_area.dart',
);
