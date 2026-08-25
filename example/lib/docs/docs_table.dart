/// The documentation tables, on the package's own table.
///
/// These were hand-rolled rows with their own header strip. They are
/// `ElTable` now, so a reference table hovers, aligns and rules exactly like
/// every other table in the system — and so a fix to the table is a fix here.
///
/// `DocsApiTable` itself still lives in `docs_facts.dart`: it wraps a
/// [DocsTable] in the titled panel chrome (`_DocsFactPanel`) that
/// `DocsStateMatrix` and `DocsInstallFacts` also use, and that panel is
/// private to that file. This library re-exports it so every import site —
/// new or the 64 existing component pages that only ever imported
/// `docs_facts.dart` — resolves it from either file.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

export 'docs_facts.dart' show DocsApiTable;

/// One column, and the fraction of the table's width it takes.
///
/// Fractions rather than intrinsic widths: the table must fill its column
/// exactly, and an intrinsic measure leaves whatever it does not need.
class DocsTableColumn {
  const DocsTableColumn({required this.header, required this.flex});

  final String header;
  final double flex;
}

class DocsTable extends StatelessWidget {
  const DocsTable({super.key, required this.columns, required this.rows});

  final List<DocsTableColumn> columns;

  /// One list of cell strings per row, in [columns] order.
  final List<List<String>> rows;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);

    // `ElTable` sizes every column to its widest cell and exposes no width
    // hook, so the table would end at its content and leave a gap. Giving
    // each cell an exact width makes "widest cell" the width we chose, and
    // the columns then sum to the container. The padding `ElTable` adds
    // inside each cell is subtracted first, or the sum overshoots.
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double gutters = columns.length * ElTable.cellPadding * 2;
        final double content = (constraints.maxWidth - gutters).clamp(
          0,
          constraints.maxWidth,
        );

        Widget sized(int column, Widget child) =>
            SizedBox(width: content * columns[column].flex, child: child);

        return ElTable(
          header: <ElTableCellSpec>[
            for (int i = 0; i < columns.length; i++)
              ElTableCellSpec(
                child: sized(
                  i,
                  ElText(
                    columns[i].header,
                    ElComponentType.textSm,
                    color: theme.mutedForeground,
                  ),
                ),
              ),
          ],
          rows: <ElTableRowSpec>[
            for (final List<String> row in rows)
              ElTableRowSpec(
                cells: <ElTableCellSpec>[
                  for (int i = 0; i < row.length; i++)
                    ElTableCellSpec(
                      child: sized(i, ElText(row[i], ElType.small)),
                    ),
                ],
              ),
          ],
        );
      },
    );
  }
}
