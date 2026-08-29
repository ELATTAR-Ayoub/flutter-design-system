/// Documentation metadata for the `table` component.
///
/// Not wired into `catalog.dart`'s `componentDocs` list: that file is
/// supervisor-owned. `page.dart` reads [tableDoc] directly rather than going
/// through `componentDoc('table')`, so this entry stands on its own until the
/// supervisor aggregates it.
///
/// `table` ships `registry/components/table.json`, so `elattar add table`
/// resolves today. [dependencies] mirrors that manifest's
/// `registryDependencies`, which is also the real import list at the top of
/// `lib/src/components/ui/table.dart`: colour, spacing, theme, typography and
/// motion tokens, and no other component or effect file.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry tableDoc = ComponentDocEntry(
  name: 'table',
  title: 'Table',
  description:
      'Table renders a presentational table: one header row, a list of '
      'body rows, and an optional centred caption underneath, with no '
      'onSort, onSelectionChanged, or page parameter anywhere in its '
      'constructor. Reach for it over an Item list or a grid of cards when '
      'the data is genuinely rows-and-columns, the same fields repeated '
      'down a header, most naturally scanned by column (a ledger, a '
      'transaction history, a leaderboard). Reach for a list or card grid '
      'instead the moment rows stop sharing one shape, or a row needs more '
      'room than a single cell gives it: every Table cell is exactly as '
      'tall as the tallest sibling in its row and no taller.',
  dependencies: <String>['source-foundation'],
  exports: <String>[
    'Table',
    'TableCellSpec',
    'TableRowSpec',
    'TableAlign',
    'TableColumnWidth',
    'tableHoverDuration',
    'tableHoverCurve',
  ],
  sourcePath: 'lib/src/components/ui/table.dart',
);
