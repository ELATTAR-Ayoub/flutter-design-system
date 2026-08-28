/// Documentation metadata for the `aspect_ratio` component.
///
/// **New route, split out of `scroll_area`.** `AspectRatio` used to share
/// `/components/scroll_area` with `ScrollArea` and
/// `ResizablePanelGroup` under one shared `ComponentDocEntry` (see
/// `scroll_area/meta.dart`'s own note for the split). It now has its own
/// [name], its own route (`/components/aspect_ratio`), and its own page
/// class (`AspectRatioDocPage`).
///
/// **Both wired in, and corrected.** `catalog.dart`'s `componentDocs` list
/// already carries `aspect_ratio.aspectRatioDoc` — the "not wired in yet"
/// claim this file used to make was stale. So was the claim that
/// `registry/components/aspect_ratio.json` "does not exist yet":
/// `registry/components/aspect-ratio.json` (hyphenated, matching the
/// registry's own naming) exists, lists exactly one file
/// (`lib/src/components/aspect_ratio.dart`) and **no** registry
/// dependencies. [dependencies] is empty because the manifest's own
/// `registryDependencies` array is empty — not because nothing has
/// resolved it.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry aspectRatioDoc = ComponentDocEntry(
  name: 'aspect_ratio',
  title: 'Aspect ratio',
  description:
      'A box locked to a width-to-height ratio, whatever width it is '
      'given.',
  dependencies: <String>[],
  exports: <String>['AspectRatio'],
  sourcePath: 'lib/src/components/aspect_ratio.dart',
);
