/// Documentation metadata for `stat` alone.
///
/// Previously this entry covered four components (`stat`, `item`, `empty`,
/// `kbd`) on one merged page. That merge is undone: `item`, `empty`, and
/// `kbd` now have their own directories (`lib/components_docs/item/`,
/// `empty/`, `kbd/`) and their own [ComponentDocEntry]s. This file keeps the
/// name `statDoc` and the route `/components/stat` unchanged, since
/// `catalog.dart` and `main.dart` already reference both by name — only the
/// content narrows to the one component the directory name promises.
///
/// Not wired into `catalog.dart`'s `componentDocs` list beyond the reference
/// that already exists there: that file is supervisor-owned. `page.dart`
/// reads [statDoc] directly rather than going through `componentDoc('stat')`.
///
/// `stat` ships `registry/components/stat.json`, so `elattar add stat`
/// resolves today. [dependencies] mirrors that manifest's
/// `registryDependencies`.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry statDoc = ComponentDocEntry(
  name: 'stat',
  title: 'Stat',
  description:
      'A labelled metric figure with an optional delta and trailing hint, '
      'and an identical footprint across ready, loading, error, empty, and '
      'disabled.',
  dependencies: <String>['icon', 'skeleton', 'source-foundation', 'swap-in'],
  exports: <String>[
    'ElStat',
    'ElStatDelta',
    'ElStatDirection',
    'ElStatDeltaMark',
    'ElStatState',
  ],
  sourcePath: 'lib/src/components/stat.dart',
);
