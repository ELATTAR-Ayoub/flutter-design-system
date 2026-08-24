/// Documentation metadata for `kbd`.
///
/// Split out of the old merged `separator/page.dart` (and the content
/// `stat/page.dart` also carried, since both former pages documented `kbd`
/// independently, with different emphasis). This is the one page that owns
/// it now: `separator/` and `stat/` no longer render any `ElKbd*` content.
///
/// Not wired into `catalog.dart`'s `componentDocs` list: that file is
/// supervisor-owned. `page.dart` reads [kbdDoc] directly rather than going
/// through `componentDoc('kbd')`, so this entry stands on its own until the
/// supervisor aggregates it.
library;

import '../catalog.dart' show ComponentDocEntry;

/// `kbd` has no `registry/components/kbd.json` yet: see `page.dart`'s
/// installation section for the shipped command and registry dependencies.
const ComponentDocEntry kbdDoc = ComponentDocEntry(
  name: 'kbd',
  title: 'Kbd',
  description:
      'A 20px-tall, 20px-minimum-wide keyboard key cap: muted fill, 6px '
      'corners, inert to touch and text selection.',
  dependencies: <String>['machine-surface', 'source-foundation'],
  exports: <String>['ElKbd', 'ElKbdGroup'],
  sourcePath: 'lib/src/components/kbd.dart',
);
