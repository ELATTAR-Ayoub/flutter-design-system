/// Documentation metadata for `separator` alone.
///
/// Previously this entry covered three components (`separator`, `empty`,
/// `kbd`) on one merged page. That merge is undone: `empty` and `kbd` now
/// have their own directories (`lib/components_docs/empty/`,
/// `lib/components_docs/kbd/`) and their own [ComponentDocEntry]s. This file
/// keeps the name `separatorDoc` and the route `/components/separator`
/// unchanged, since `catalog.dart` and `main.dart` already reference both by
/// name — only the content narrows to the one component the directory name
/// promises.
///
/// Not wired into `catalog.dart`'s `componentDocs` list beyond the reference
/// that already exists there: that file is supervisor-owned. `page.dart`
/// reads [separatorDoc] directly rather than going through
/// `componentDoc('separator')`.
library;

import '../catalog.dart' show ComponentDocEntry;

/// `separator` has no `registry/components/separator.json` yet: see
/// `page.dart`'s installation section for the shipped command and registry dependencies.
const ComponentDocEntry separatorDoc = ComponentDocEntry(
  name: 'separator',
  title: 'Separator',
  description:
      'A 1px hairline rule with no length of its own on its long axis: '
      'horizontal fills the parent width, vertical stretches to the '
      'parent height.',
  dependencies: <String>['source-foundation'],
  exports: <String>['ElSeparator', 'ElSeparatorOrientation'],
  sourcePath: 'lib/src/components/separator.dart',
);
