/// Documentation metadata for `item`.
///
/// `item` is a real, distinct component: `lib/src/components/ui/item.dart`
/// defines `Item`, `ItemGroup`, `ItemVariant`, `ItemMedia`,
/// `ItemContent`, `ItemTitle`, `ItemDescription`, and `ItemActions`,
/// verified by reading that file directly. It is not the same widget as
/// `Field` (a form-control wrapper, documented on its own page — see this
/// page's own "Item vs Field" section) and it is not a size/variant of
/// `Stat`, `Empty`, or `Kbd`. `stat/page.dart` used to carry `item`'s
/// content as one of four merged components; this is the first page that
/// owns it alone.
///
/// Not wired into `catalog.dart`'s `componentDocs` list: that file is
/// supervisor-owned. `page.dart` reads [itemDoc] directly rather than going
/// through `componentDoc('item')`, so this entry stands on its own until the
/// supervisor aggregates it.
library;

import '../catalog.dart' show ComponentDocEntry;

/// `registry/components/item.json` is a real manifest — `files`,
/// `registryDependencies: [source-foundation]`, a `documentationRoute` —
/// and `elattar add item` installs from it today. [dependencies] is that
/// manifest's own `registryDependencies` list, verbatim.
const ComponentDocEntry itemDoc = ComponentDocEntry(
  name: 'item',
  title: 'Item',
  description:
      'A structured list row: optional media, required content, and '
      'optional actions, with a border variant and an alignment override.',
  dependencies: <String>['source-foundation'],
  exports: <String>[
    'ItemGroup',
    'Item',
    'ItemVariant',
    'ItemMedia',
    'ItemContent',
    'ItemTitle',
    'ItemDescription',
    'ItemActions',
  ],
  sourcePath: 'lib/src/components/ui/item.dart',
);
