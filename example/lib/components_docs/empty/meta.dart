/// Documentation metadata for `empty`.
///
/// Split out of the old merged `separator/page.dart` (and the content
/// `stat/page.dart` also carried, since both former pages documented `empty`
/// independently, with different emphasis). This is the one page that owns
/// it now: `separator/` and `stat/` no longer render any `Empty*` content.
///
/// Not wired into `catalog.dart`'s `componentDocs` list: that file is
/// supervisor-owned. `page.dart` reads [emptyDoc] directly rather than going
/// through `componentDoc('empty')`, so this entry stands on its own until
/// the supervisor aggregates it.
library;

import '../catalog.dart' show ComponentDocEntry;

/// `registry/components/empty.json` ships today: [dependencies] is that
/// manifest's own `registryDependencies` list, verbatim, so `page.dart`'s
/// Installation section can render the real `elattar add empty` command.
const ComponentDocEntry emptyDoc = ComponentDocEntry(
  name: 'empty',
  title: 'Empty',
  description:
      'A structured empty state: an optional media tile, a title, a '
      'description, and one clear way out.',
  dependencies: <String>['icon', 'source-foundation'],
  exports: <String>[
    'Empty',
    'EmptyHeader',
    'EmptyMedia',
    'EmptyTitle',
    'EmptyDescription',
    'EmptyContent',
  ],
  sourcePath: 'lib/src/components/ui/empty.dart',
);
