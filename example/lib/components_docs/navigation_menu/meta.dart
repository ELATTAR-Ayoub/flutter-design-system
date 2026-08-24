/// Documentation metadata for `navigation_menu`.
///
/// No `registry/components/navigation-menu.json` manifest yet: unregistered.
/// [dependencies] is left empty; the page states in prose that this component
/// builds on [ElPopover].
///
/// Phase F/J split: this file used to cover `navigation_menu`, `menubar`,
/// `context_menu`, and `hover_card` together (they all build on ElPopover).
/// Each now has its own `meta.dart`/`page.dart` under its own directory,
/// shaped like `button/page.dart`. This entry keeps only what
/// `ElNavigationMenu`, `ElNavigationMenuItem`, `ElNavigationMenuIndicator`,
/// and `ElNavigationMenuLink` actually export.
library;

import '../catalog.dart';

const ComponentDocEntry navigationMenuDoc = ComponentDocEntry(
  name: 'navigation-menu',
  title: 'Navigation Menu',
  description:
      'A top bar whose items can open a shared or per-item panel, built on '
      'ElPopover: for a section with more than a link to offer.',
  dependencies: <String>[
    'icon',
    'popover',
    'press-motion',
    'source-foundation',
  ],
  exports: <String>[
    'ElNavigationMenu',
    'ElNavigationMenuItem',
    'ElNavigationMenuIndicator',
    'ElNavigationMenuLink',
  ],
  sourcePath: 'lib/src/components/navigation_menu.dart',
);
