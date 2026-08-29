/// Documentation metadata for the `sheet` component.
///
/// Split from a former combined sheet+drawer page: this file now documents
/// `lib/src/components/ui/sheet.dart` alone. `lib/src/components/ui/drawer.dart`
/// has its own page and its own `../drawer/meta.dart` now, not this one.
///
/// [dependencies] names the real modules `sheet.dart` imports (for the
/// dependencies panel), not a validated `registryDependencies` list: neither
/// `sheet` nor `drawer` has a `registry/components/*.json` manifest yet, so
/// `page.dart`'s Installation section says plainly that the component is
/// already usable through the published package (it is exported from the
/// barrel) but installable through `elattar add sheet`.
library;

import '../catalog.dart';

const ComponentDocEntry sheetDoc = ComponentDocEntry(
  name: 'sheet',
  title: 'Sheet',
  description:
      'An edge-anchored overlay panel, top, right, bottom, or left, that '
      'slides in and keeps the page behind it in place instead of '
      'interrupting it.',
  dependencies: <String>[
    'button',
    'dialog',
    'icon',
    'safe-area',
    'source-foundation',
  ],
  exports: <String>[
    'Sheet',
    'SheetPanel',
    'SheetSide',
    'SheetOverlay',
    'SheetTransition',
    'SheetContent',
    'SheetContentGroup',
    'SheetHeader',
    'SheetFooter',
    'SheetTitle',
    'SheetDescription',
  ],
  sourcePath: 'lib/src/components/ui/sheet.dart',
);
