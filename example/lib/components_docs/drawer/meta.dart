/// Documentation metadata for the `drawer` component.
///
/// Split out of a former combined sheet+drawer page: this file documents
/// `lib/src/components/ui/drawer.dart` alone. `lib/src/components/ui/sheet.dart`
/// has its own page and its own `../sheet/meta.dart`, not this one.
///
/// [dependencies] names the real modules `drawer.dart` imports (for the
/// dependencies panel), not a validated `registryDependencies` list: there is
/// no `registry/components/drawer.json` manifest yet, so `page.dart`'s
/// Installation section says plainly that the component is already usable
/// through the published package (it is exported from the barrel) but not
/// yet installable through `elattar add`. Unlike `sheet.dart`, `drawer.dart`
/// imports only `dialog.dart` besides foundation modules: no `button.dart`,
/// no `icon.dart`, matching its lack of a built-in close button.
library;

import '../catalog.dart';

const ComponentDocEntry drawerDoc = ComponentDocEntry(
  name: 'drawer',
  title: 'Drawer',
  description:
      'A draggable, bottom-anchored overlay panel: the correct container '
      'for card actions and other touch-first bottom sheets on a phone.',
  dependencies: <String>['dialog', 'source-foundation'],
  exports: <String>[
    'Drawer',
    'DrawerContent',
    'DrawerHandle',
    'DrawerHeader',
    'DrawerFooter',
    'DrawerTitle',
    'DrawerDescription',
  ],
  sourcePath: 'lib/src/components/ui/drawer.dart',
);
