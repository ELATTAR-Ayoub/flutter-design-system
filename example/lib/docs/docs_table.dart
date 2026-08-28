/// The documentation tables, on the package's own table.
///
/// These were hand-rolled rows with their own header strip. They are
/// `Table` now, so a reference table hovers, aligns and rules exactly like
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
import 'package:flutter/material.dart' show SelectableText;
import 'package:flutter/widgets.dart'
    hide
        AspectRatio,
        Form,
        FormField,
        Icon,
        OverlayPortal,
        RadioGroup,
        RichText,
        SafeArea,
        ScrollPosition,
        Table,
        TableColumnWidth;

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

  /// The same floor `_FactScroll` (`docs_facts.dart`) uses for
  /// `DocsStateMatrix`, so the two table styles agree on where a narrow
  /// column stops cramming cells and starts scrolling instead.
  static double get _minContentWidth => space(132);

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    // `Table` sizes every column to its widest cell and exposes no width
    // hook, so the table would end at its content and leave a gap. Giving
    // each cell an exact width makes "widest cell" the width we chose, and
    // the columns then sum to the table. The padding `Table` adds inside
    // each cell is subtracted first, or the sum overshoots.
    //
    // The table's own width is `max(available, _minContentWidth)`: a wide
    // container is filled exactly as before, but a container narrower than
    // the floor keeps the table at the floor width and lets the surrounding
    // `SingleChildScrollView` scroll it horizontally, rather than shrinking
    // every cell until the text crams.
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double tableWidth = constraints.maxWidth < _minContentWidth
            ? _minContentWidth
            : constraints.maxWidth;
        final double gutters = columns.length * Table.cellPadding * 2;
        final double content = (tableWidth - gutters).clamp(0, tableWidth);

        Widget sized(int column, Widget child) =>
            SizedBox(width: content * columns[column].flex, child: child);

        final Widget table = Table(
          header: <TableCellSpec>[
            for (int i = 0; i < columns.length; i++)
              TableCellSpec(
                child: sized(
                  i,
                  StyledText(
                    columns[i].header,
                    TextStyles.bodySmall,
                    color: theme.mutedForeground,
                  ),
                ),
              ),
          ],
          rows: <TableRowSpec>[
            for (final List<String> row in rows)
              TableRowSpec(
                cells: <TableCellSpec>[
                  for (int i = 0; i < row.length; i++)
                    TableCellSpec(
                      child: sized(
                        i,
                        // A reader can select a property name or a type
                        // string to copy it — same approach and the same
                        // per-column type/colour split `_SelectableFactText`
                        // used in `_FactRow` (`docs_facts.dart`) before this
                        // table moved onto `Table`. Headers stay plain
                        // `StyledText`: they were not selectable before either.
                        _SelectableCellText(
                          text: row[i],
                          spec: i == 0 ? TextStyles.body : TextStyles.small,
                          color: i == 0
                              ? theme.foreground
                              : theme.mutedForeground,
                        ),
                      ),
                    ),
                ],
              ),
          ],
        );

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(width: tableWidth, child: table),
        );
      },
    );
  }
}

/// A body cell's text, selectable — the same wrapper `_SelectableFactText`
/// (`docs_facts.dart`) was, before `DocsApiTable`'s rows moved onto
/// [DocsTable]: a reference table's property names and type strings are
/// worth copying, so plain [StyledText] is not enough here.
class _SelectableCellText extends StatelessWidget {
  const _SelectableCellText({
    required this.text,
    required this.spec,
    required this.color,
  });

  final String text;
  final TextStyleToken spec;
  final Color color;

  @override
  Widget build(BuildContext context) => SelectableText(
    text,
    style: StyledText.styleOf(context, spec, color: color),
  );
}
