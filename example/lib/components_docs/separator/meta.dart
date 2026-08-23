/// Documentation metadata for three small presentational primitives —
/// `separator`, `empty`, and `kbd`: sharing one entry and one page.
///
/// Each is too small for a page of its own (a hairline rule, a six-part
/// empty-state composition, and a key-cap label) and all three share one
/// theme: static, almost stateless presentation, not control. Rather than
/// three near-empty pages this entry documents all three together, the way
/// `badge/meta.dart` documents one, [route] resolves to `/components/separator`
/// because [name] is `separator`; `empty` and `kbd` are not separately
/// routed.
///
/// Not wired into `catalog.dart`'s `componentDocs` list: that file is
/// supervisor-owned. `page.dart` reads [separatorDoc] directly rather than
/// going through `componentDoc('separator')`, so this entry stands on its own
/// until the supervisor aggregates it.
library;

import '../catalog.dart' show ComponentDocEntry;

/// None of the three has a `registry/components/*.json` manifest yet: see
/// `page.dart`'s installation section for the honest disclosure.
/// [dependencies] is left empty rather than naming items a manifest does not
/// yet resolve; the page states in prose what each would need once
/// registered (`source-foundation` for all three, `icon` for `empty`,
/// `machine-surface` for `kbd`).
///
/// [sourcePath] names all three source files: one per line: since
/// [ComponentDocEntry] has a single source-path field and this entry covers
/// three components.
const ComponentDocEntry separatorDoc = ComponentDocEntry(
  name: 'separator',
  title: 'Separator, Empty & Kbd',
  description:
      'Three static, presentational primitives with almost no state of '
      'their own: a hairline rule, a structured empty-state composition, '
      'and a keyboard-key label.',
  dependencies: <String>[],
  exports: <String>[
    'DsSeparator',
    'DsSeparatorOrientation',
    'DsEmpty',
    'DsEmptyHeader',
    'DsEmptyMedia',
    'DsEmptyTitle',
    'DsEmptyDescription',
    'DsEmptyContent',
    'DsKbd',
    'DsKbdGroup',
  ],
  sourcePath:
      'lib/src/components/separator.dart, '
      'lib/src/components/empty.dart, '
      'lib/src/components/kbd.dart',
);
