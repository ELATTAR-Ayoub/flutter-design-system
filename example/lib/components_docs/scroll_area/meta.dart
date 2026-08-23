/// Documentation metadata for the `scroll_area` component family.
///
/// Not wired into `catalog.dart`'s `componentDocs` list: that file is
/// supervisor-owned. `page.dart` reads [scrollAreaDoc] directly rather than
/// going through `componentDoc('scroll_area')`, so this entry stands on its
/// own until the supervisor aggregates it.
library;

import '../catalog.dart' show ComponentDocEntry;

/// `scroll_area` has no registry manifest yet: see `page.dart`'s
/// installation section for the honest disclosure. [dependencies] is left
/// empty rather than naming items a manifest does not yet resolve.
const ComponentDocEntry scrollAreaDoc = ComponentDocEntry(
  name: 'scroll_area',
  title: 'Scroll area',
  description:
      'A styled scroll container with an optional hover-visible scrollbar, resizable panels, and aspect-ratio-locked boxes.',
  dependencies: <String>[],
  exports: <String>[
    'DsScrollArea',
    'DsScrollAreaBehavior',
    'DsResizablePanelGroup',
    'DsResizablePanel',
    'DsAspectRatio',
  ],
  sourcePath: 'lib/src/components/scroll_area.dart',
);
