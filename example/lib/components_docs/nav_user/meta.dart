/// Documentation metadata for the `nav_user` component.
///
/// Split out of `components_docs/carousel/` on 2026-08-24: `ElNavUser`,
/// `ElNavUserAccount`, and `ElNavUserItem` are their own barrel export
/// (`export 'src/components/nav_user.dart';`) and now own their own page.
///
/// Not wired into `catalog.dart`'s `componentDocs` list: that file is
/// supervisor-owned. `page.dart` reads [navUserDoc] directly.
library;

import '../catalog.dart' show ComponentDocEntry;

/// Install with `elattar add nav-user`; the shipped manifest lives at
/// `registry/components/nav-user.json`.
/// [ComponentDocEntry.dependencies] mirrors that manifest's
/// `registryDependencies`.
const ComponentDocEntry navUserDoc = ComponentDocEntry(
  name: 'nav_user',
  title: 'Nav User',
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
  exports: <String>['ElNavUser', 'ElNavUserAccount', 'ElNavUserItem'],
  sourcePath: 'lib/src/components/nav_user.dart',
);
