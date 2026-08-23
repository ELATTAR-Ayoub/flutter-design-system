/// Documentation metadata for `stat`, `item`, `empty`, and `kbd` components.
///
/// Not wired into `catalog.dart`'s `componentDocs` list: that file is
/// supervisor-owned. `page.dart` reads [statDoc] directly rather than going
/// through `componentDoc('stat')`, so this entry stands on its own until the
/// supervisor aggregates it.
library;

import '../catalog.dart' show ComponentDocEntry;

/// `stat` has no `registry/components/stat.json` yet: see `page.dart`'s
/// installation section for the honest disclosure. [dependencies] is left
/// empty rather than naming items a manifest does not yet resolve; the page
/// states in prose what the component would need once registered.
const ComponentDocEntry statDoc = ComponentDocEntry(
  name: 'stat',
  title: 'Stat',
  description:
      'A labelled metric figure with an optional delta and trailing hint.',
  dependencies: <String>[],
  exports: <String>[
    'DsStat',
    'DsStatDelta',
    'DsStatDirection',
    'DsStatDeltaMark',
    'DsStatState',
    'DsItemGroup',
    'DsItem',
    'DsItemMedia',
    'DsItemContent',
    'DsItemTitle',
    'DsItemDescription',
    'DsItemActions',
    'DsItemVariant',
    'DsEmpty',
    'DsEmptyHeader',
    'DsEmptyMedia',
    'DsEmptyTitle',
    'DsEmptyDescription',
    'DsEmptyContent',
    'DsKbd',
    'DsKbdGroup',
  ],
  sourcePath: 'lib/src/components/stat.dart',
);
