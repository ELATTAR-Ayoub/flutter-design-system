/// Documentation metadata for the `aspect_ratio` component.
///
/// **New route, split out of `scroll_area`.** `ElAspectRatio` used to share
/// `/components/scroll_area` with `ElScrollArea` and
/// `ElResizablePanelGroup` under one shared `ComponentDocEntry` (see
/// `scroll_area/meta.dart`'s own note for the split). It now has its own
/// [name], its own route (`/components/aspect_ratio`), and its own page
/// class (`AspectRatioDocPage`).
///
/// Not wired into `catalog.dart`'s `componentDocs` list: that file is
/// supervisor-owned, and this entry is new. `page.dart` reads
/// [aspectRatioDoc] directly rather than going through
/// `componentDoc('aspect_ratio')`.
///
/// `registry/components/aspect_ratio.json` does not exist yet: see
/// `page.dart`'s installation section for the shipped command and registry dependencies.
/// [dependencies] is left empty rather than naming items a manifest does
/// not yet resolve.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry aspectRatioDoc = ComponentDocEntry(
  name: 'aspect_ratio',
  title: 'Aspect ratio',
  description:
      'A box locked to a width-to-height ratio, whatever width it is '
      'given.',
  dependencies: <String>[],
  exports: <String>['ElAspectRatio'],
  sourcePath: 'lib/src/components/aspect_ratio.dart',
);
