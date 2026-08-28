/// Documentation metadata for the `user_menu` component.
///
/// Split out of `components_docs/carousel/` on 2026-08-24: `UserMenu`,
/// `UserMenuAccount`, and `UserMenuItem` are their own barrel export
/// (`export 'src/components/user_menu.dart';`) and now own their own page.
///
/// Not wired into `catalog.dart`'s `componentDocs` list: that file is
/// supervisor-owned. `page.dart` reads [userMenuDoc] directly.
library;

import '../catalog.dart' show ComponentDocEntry;

/// Install with `elattar add user-menu`; the shipped manifest lives at
/// `registry/components/user-menu.json`.
/// [ComponentDocEntry.dependencies] mirrors that manifest's
/// `registryDependencies`.
const ComponentDocEntry userMenuDoc = ComponentDocEntry(
  name: 'user_menu',
  title: 'User Menu',
  description:
      'The account block a sidebar footer is incomplete without: an avatar, a '
      'two-line identity, and a chevron, opening a menu that repeats the same '
      'identity at its head.',
  dependencies: <String>[
    'avatar',
    'dropdown-menu',
    'icon',
    'menu',
    'popover',
    'sidebar',
    'source-foundation',
  ],
  exports: <String>['UserMenu', 'UserMenuAccount', 'UserMenuItem'],
  sourcePath: 'lib/src/components/ui/user_menu.dart',
);
