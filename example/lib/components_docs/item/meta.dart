/// Documentation metadata for `item`.
///
/// `item` is a real, distinct component: `lib/src/components/item.dart`
/// defines `ElItem`, `ElItemGroup`, `ElItemVariant`, `ElItemMedia`,
/// `ElItemContent`, `ElItemTitle`, `ElItemDescription`, and `ElItemActions`,
/// verified by reading that file directly. It is not the same widget as
/// `ElField` (a form-control wrapper, documented on its own page — see this
/// page's own "Item vs Field" section) and it is not a size/variant of
/// `ElStat`, `ElEmpty`, or `ElKbd`. `stat/page.dart` used to carry `item`'s
/// content as one of four merged components; this is the first page that
/// owns it alone.
///
/// Not wired into `catalog.dart`'s `componentDocs` list: that file is
/// supervisor-owned. `page.dart` reads [itemDoc] directly rather than going
/// through `componentDoc('item')`, so this entry stands on its own until the
/// supervisor aggregates it.
library;

import '../catalog.dart' show ComponentDocEntry;

/// `item` has no `registry/components/item.json` yet: see `page.dart`'s
/// installation section for the shipped command and registry dependencies.
const ComponentDocEntry itemDoc = ComponentDocEntry(
  name: 'item',
  title: 'Item',
  description:
      'A structured list row: optional media, required content, and '
      'optional actions, with a border variant and an alignment override.',
  dependencies: <String>['source-foundation'],
  exports: <String>[
    'ElItemGroup',
    'ElItem',
    'ElItemVariant',
    'ElItemMedia',
    'ElItemContent',
    'ElItemTitle',
    'ElItemDescription',
    'ElItemActions',
  ],
  sourcePath: 'lib/src/components/item.dart',
);
