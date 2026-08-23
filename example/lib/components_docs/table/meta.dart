/// Documentation metadata for the `table` component.
///
/// Not wired into `catalog.dart`'s `componentDocs` list: that file is
/// supervisor-owned. `page.dart` reads [tableDoc] directly rather than going
/// through `componentDoc('table')`, so this entry stands on its own until the
/// supervisor aggregates it.
library;

import '../catalog.dart' show ComponentDocEntry;

/// `table` has no `registry/components/table.json` yet: see `page.dart`'s
/// installation section for the honest disclosure. [dependencies] is left
/// empty rather than naming items a manifest does not yet resolve; the page
/// states in prose what the component would need once registered
/// (`source-foundation` for its colour, spacing, typography and motion
/// tokens: table.dart declares no dependency on any other component file).
const ComponentDocEntry tableDoc = ComponentDocEntry(
  name: 'table',
  title: 'Table',
  description:
      'DsTable renders a presentational table: one header row, a list of '
      'body rows, and an optional centred caption underneath, with no '
      'onSort, onSelectionChanged, or page parameter anywhere in its '
      'constructor. Reach for it over an Item list or a grid of cards when '
      'the data is genuinely rows-and-columns, the same fields repeated '
      'down a header, most naturally scanned by column (a ledger, a '
      'transaction history, a leaderboard). Reach for a list or card grid '
      'instead the moment rows stop sharing one shape, or a row needs more '
      'room than a single cell gives it: every DsTable cell is exactly as '
      'tall as the tallest sibling in its row and no taller.',
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
