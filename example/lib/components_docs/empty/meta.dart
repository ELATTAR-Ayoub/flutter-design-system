/// Documentation metadata for `empty`.
///
/// Split out of the old merged `separator/page.dart` (and the content
/// `stat/page.dart` also carried, since both former pages documented `empty`
/// independently, with different emphasis). This is the one page that owns
/// it now: `separator/` and `stat/` no longer render any `ElEmpty*` content.
///
/// Not wired into `catalog.dart`'s `componentDocs` list: that file is
/// supervisor-owned. `page.dart` reads [emptyDoc] directly rather than going
/// through `componentDoc('empty')`, so this entry stands on its own until
/// the supervisor aggregates it.
library;

import '../catalog.dart' show ComponentDocEntry;

/// `empty` has no `registry/components/empty.json` yet: see `page.dart`'s
/// installation section for the shipped command and registry dependencies.
const ComponentDocEntry emptyDoc = ComponentDocEntry(
  name: 'empty',
  title: 'Empty',
  description:
      'A structured empty state: an optional media tile, a title, a '
      'description, and one clear way out.',
  dependencies: <String>['icon', 'source-foundation'],
  exports: <String>[
    'ElEmpty',
    'ElEmptyHeader',
    'ElEmptyMedia',
    'ElEmptyTitle',
    'ElEmptyDescription',
    'ElEmptyContent',
  ],
  sourcePath: 'lib/src/components/empty.dart',
);
