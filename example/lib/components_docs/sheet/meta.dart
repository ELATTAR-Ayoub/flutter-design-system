/// Documentation metadata for the paired sheet and drawer components.
///
/// A worker-owned file: the supervisor folds [sheetDoc] into `catalog.dart`'s
/// `componentDocs` list in a later, serialized pass. This file only ever
/// imports `catalog.dart` for the [ComponentDocEntry] shape: it never edits
/// it.
///
/// Sheet and drawer are documented on **one page, one entry** because they
/// are the same idea: an edge-anchored overlay that keeps the page behind
/// it in place, instead of a centred modal that interrupts: at different
/// edges. [ComponentDocEntry] carries one `sourcePath`; because both
/// components have real source files, this one names the primary of the
/// two (`sheet.dart`) and `page.dart`'s own Dependencies section names
/// `drawer.dart` explicitly as the second.
///
/// Neither `sheet` nor `drawer` has a `registry/components/*.json` manifest
/// yet, so [dependencies] names the real modules the two source files import
/// (for the dependencies panel), not a validated `registryDependencies` list.
/// `page.dart`'s installation section says plainly that both are already
/// usable through the published package: they are exported from the barrel
///: but neither is yet installable through `elattar add`.
library;

import '../catalog.dart';

/// IA §9.2's expanded description: sheet and drawer against dialog, and
/// sheet against drawer: not a restatement of either name.
const String sheetExpandedDescription =
    'Sheet and drawer are both edge-anchored overlay panels that slide in '
    'over the page and leave the page itself in place behind a scrim: the '
    'opposite choice from DsDialog, which centres itself and interrupts. '
    'Reach for one of these two instead of a dialog whenever the content is '
    'a side task the user is still oriented by the underlying page for: a '
    'filter panel, an account menu, a set of card actions: rather than a '
    'question that needs a direct, page-blocking answer. '
    'Between the two: DsSheetOverlay opens on any of four edges (top, '
    'right, bottom, left) and does not drag; DsDrawer is pinned to the '
    'bottom only, and is the one panel in the family a user can drag closed '
    'with a finger, which is what makes it the right container for card '
    'actions and other touch-first bottom sheets on a phone. They are not '
    'the same widget with a side parameter: see Variants and sizes below '
    'for exactly how the implementations diverge even where DsSheetSide.'
    'bottom and DsDrawer both anchor to the same edge.';

const ComponentDocEntry sheetDoc = ComponentDocEntry(
  name: 'sheet',
  title: 'Sheet & Drawer',
  description:
      'Edge-anchored overlay panels that slide in and keep the page behind '
      'them in place, Sheet on any of four sides, Drawer pinned to the '
      'bottom and draggable closed.',
  dependencies: <String>[
    'source-foundation',
    'dialog',
    'button',
    'icon',
    'ds-safe-area',
  ],
  exports: <String>[
    // lib/src/components/sheet.dart
    'DsSheet',
    'DsSheetPanel',
    'DsSheetSide',
    'DsSheetOverlay',
    'DsSheetTransition',
    'DsSheetContent',
    'DsSheetContentGroup',
    'DsSheetHeader',
    'DsSheetFooter',
    'DsSheetTitle',
    'DsSheetDescription',
    // lib/src/components/drawer.dart
    'DsDrawer',
    'DsDrawerContent',
    'DsDrawerHandle',
    'DsDrawerHeader',
    'DsDrawerFooter',
    'DsDrawerTitle',
    'DsDrawerDescription',
  ],
  sourcePath: 'lib/src/components/sheet.dart',
);

/// The second source file this one page documents. Named here rather than
/// only in prose so `page.dart` has one place to read it from.
const String drawerSourcePath = 'lib/src/components/drawer.dart';
