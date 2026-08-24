/// Public documentation metadata for the popover component.
///
/// `popover` already has a real `registry/components/popover.json` manifest
///: like `tooltip`, [dependencies] is that manifest's own
/// `registryDependencies` list, verbatim: `['source-foundation']`. `page.dart`
/// renders the real `elattar add popover` command from it rather than the
/// shipped install command and registry dependencies for this routed component.
///
/// [ComponentDocEntry.description] is the page's only rendered description:
/// the one-sentence form for nav, search, and the page's own hero line.
library;

import '../catalog.dart';

const ComponentDocEntry popoverDoc = ComponentDocEntry(
  name: 'popover',
  title: 'Popover',
  description:
      'An anchored overlay with semantic side, alignment, and collision '
      'handling that other overlays in this system build their own '
      'placement on.',
  // registry/components/popover.json's own registryDependencies, verbatim —
  // a worker that invented a name here is exactly the failure mode the
  // Phase J supervisor notes warn about, and this one does not need to.
  dependencies: <String>['machine-surface', 'source-foundation'],
  exports: <String>[
    'ElPopover',
    'ElPopoverSide',
    'ElPopoverAlign',
    'ElPopoverOriginModel',
    'ElPopoverBarrier',
    'ElPopoverPlacement',
    'ElPopoverAnchorMetrics',
    'ElPopoverContentBuilder',
    'ElPopoverSurface',
    'elPopoverPlacement',
  ],
  sourcePath: 'lib/src/components/popover.dart',
);
