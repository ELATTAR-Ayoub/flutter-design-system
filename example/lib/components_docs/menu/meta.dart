/// Public documentation metadata for the `menu` component.
///
/// `menu` is not a control a reader places directly. Its own registry
/// manifest (`registry/components/menu.json`) says so in its first line:
/// *"The shared body of `dropdown-menu.tsx`, `context-menu.tsx` and
/// `menubar.tsx`"* — one Radix `Menu` primitive, wrapped by three different
/// roots. `lib/src/components/menu.dart` is the row model (`ElMenuItem`,
/// `ElMenuCheckboxItem`, `ElMenuRadioItem`/`ElMenuRadioGroup`, `ElMenuLabel`,
/// `ElMenuSeparator`, `ElMenuGroup`, `ElMenuSub`), the geometry and surface
/// (`ElMenu`, `ElMenuSurface`, `ElMenuSurfaceKind`, `ElMenuIndicatorSide`),
/// the open content and its keyboard (`ElMenuContent`), and the two shared
/// primitives every trigger root needs (`ElMenuPointerDown`,
/// `ElMenuMotion`) — everything a dropdown menu, a context menu and a
/// menubar mount identically. Each of those three roots already has its own
/// page; this page is the engine underneath them, and its Dependencies
/// disclosure links to all three.
///
/// [dependencies] is `registry/components/menu.json`'s own
/// `registryDependencies`, copied verbatim: `icon`, `popover`,
/// `source-foundation`.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry menuDoc = ComponentDocEntry(
  name: 'menu',
  title: 'Menu',
  description:
      'The shared row model, geometry, surface and keyboard behaviour a '
      'dropdown menu, a context menu and a menubar all mount identically.',
  // registry/components/menu.json's own registryDependencies, verbatim.
  dependencies: <String>['icon', 'popover', 'source-foundation'],
  exports: <String>[
    'ElMenuChild',
    'ElMenuItemVariant',
    'ElMenuItem',
    'ElMenuCheckboxItem',
    'ElMenuRadioItem',
    'ElMenuRadioGroup',
    'ElMenuLabel',
    'ElMenuSeparator',
    'ElMenuGroup',
    'ElMenuSub',
    'ElMenuIndicatorSide',
    'ElMenuSurfaceKind',
    'ElMenu',
    'ElMenuSurface',
    'ElMenuContent',
    'ElMenuPointerDown',
    'ElMenuMotion',
  ],
  sourcePath: 'lib/src/components/menu.dart',
);
