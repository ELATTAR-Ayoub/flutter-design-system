/// Documentation metadata for `navigation_menu`.
///
/// **Corrected.** This file used to claim no `registry/components/
/// navigation-menu.json` manifest existed and that [dependencies] was left
/// empty. Both are stale: `registry/components/navigation-menu.json` is a
/// real, shipped manifest today, `registry/generated/latest/registry.json`
/// carries `navigation-menu`, and `elattar add navigation-menu` is a
/// genuine, working command. [dependencies] below already matches the
/// manifest's own `registryDependencies` list, verbatim: `icon`, `popover`
/// (the [ElPopover] positioner this component builds on), `press-motion`,
/// and `source-foundation`.
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
