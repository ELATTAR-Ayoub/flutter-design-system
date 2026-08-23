/// Documentation metadata for the `table` component.
///
/// Not wired into `catalog.dart`'s `componentDocs` list — that file is
/// supervisor-owned. `page.dart` reads [tableDoc] directly rather than going
/// through `componentDoc('table')`, so this entry stands on its own until the
/// supervisor aggregates it.
library;

import '../catalog.dart' show ComponentDocEntry;

/// `table` has no `registry/components/table.json` yet — see `page.dart`'s
/// installation section for the honest disclosure. [dependencies] is left
/// empty rather than naming items a manifest does not yet resolve; the page
/// states in prose what the component would need once registered
/// (`source-foundation` for its colour, spacing, typography and motion
/// tokens — table.dart declares no dependency on any other component file).
const ComponentDocEntry tableDoc = ComponentDocEntry(
  name: 'table',
  title: 'Table',
  description:
      'A presentational data table — header row, body rows, optional '
      'caption — with no sorting, selection, or pagination of its own.',
  dependencies: <String>[],
  exports: <String>[
    'DsTable',
    'DsTableCellSpec',
    'DsTableRowSpec',
    'DsTableAlign',
    'DsTableColumnWidth',
    'dsTableHoverDuration',
    'dsTableHoverCurve',
  ],
  sourcePath: 'lib/src/components/table.dart',
);
