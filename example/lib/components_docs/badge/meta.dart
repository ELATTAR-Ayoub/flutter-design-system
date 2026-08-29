/// Documentation metadata for the `badge` component.
///
/// Not wired into `catalog.dart`'s `componentDocs` list: that file is
/// supervisor-owned. `page.dart` reads [badgeDoc] directly rather than going
/// through `componentDoc('badge')`, so this entry stands on its own until the
/// supervisor aggregates it.
library;

import '../catalog.dart' show ComponentDocEntry;

/// `badge` has no `registry/components/badge.json` yet: see `page.dart`'s
/// installation section for the shipped command and registry dependencies. [dependencies] is left
/// empty rather than naming items a manifest does not yet resolve; the page
/// states in prose what the component would need once registered
/// (`source-foundation`, the surface shadow effect).
const ComponentDocEntry badgeDoc = ComponentDocEntry(
  name: 'badge',
  title: 'Badge',
  description:
      'A small pill-shaped label for status, counts, or metadata: not a control.',
  dependencies: <String>['surface', 'source-foundation'],
  exports: <String>['Badge', 'BadgeVariant'],
  sourcePath: 'lib/src/components/ui/badge.dart',
);
