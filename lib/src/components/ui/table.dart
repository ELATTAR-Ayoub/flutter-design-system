/// `components/ui/table.tsx` — the eight slots, and the one thing about them
/// that is not in the file: **how CSS decides a column's width.**
///
/// ## The column model, probed rather than reasoned
///
/// Every cell in the corpus is `whitespace-nowrap`, so a column's min-content
/// width and its max-content width are the same number and no cell ever wraps.
/// The tables are then wider than their content, and how a browser spends the
/// slack is implementation-defined. Chrome's answer was measured on all four
/// tables of `/design-system/components/base/data` at 1440×900 (2026-08-16) by
/// cloning each table at `width: max-content` and comparing:
///
/// ```
/// used[i] == max[i] × tableWidth / Σ max
/// ```
///
/// — proportional to max-content width, exact to **0.03px** on every one of the
/// seventeen columns measured. That is reproduced here by
/// [TableColumnWidth], whose `flex` is its own `maxIntrinsicWidth`: Flutter's
/// [RenderTable] grows flexible columns to `remaining × flexᵢ / Σflex`, and with
/// no unflexed column the remaining width is the whole table, so the two
/// formulas are the same one.
///
/// ## The heights, and the half pixel
///
/// `border-collapse: collapse` splits the 1px rule between the two rows it
/// separates. The measured consequence, on every multi-row table on the page:
///
/// | row | measured |
/// |---|---|
/// | `thead` row | **40** — `h-10` on the `th`, rule included |
/// | body row, not last | content + `p-2` twice + **1** |
/// | body row, last, in a body of 2+ | content + `p-2` twice + **0.5** |
/// | body row, last, in a body of 1 | content + `p-2` twice |
///
/// The last row's half pixel is the top half of the rule above it; its own
/// border is removed by `[&_tr:last-child]:border-0`, so **nothing is painted
/// there** and the 0.5 is pure layout. It is reproduced as half a pixel of
/// transparent padding rather than as a faint line, and it is why a five-row
/// table stacks to 224.5 and not to 224.
///
/// ## The rest
///
/// * `TableRow` carries `transition-colors` with **no `duration-*` at all**, so
///   it runs the stylesheet's default — probed at **250ms `--ease-out`**, which
///   is [MotionDurations.normal]. The hover fill is `bg-muted/50`; a
///   selected row is `bg-muted` at full strength and beats it.
/// * `TableCaption` is `caption-bottom`, so it renders under the body inside
///   the table's own box, `mt-4` away from it — and it inherits the UA
///   stylesheet's `text-align: center`, which no class overrides. *(Measured:
///   `-webkit-center` on a 1078px caption box.)*
/// * The `<table>` sets `text-sm` once and every cell inherits **both** the
///   13px and the resolved 18.5714px line box — see [TextStyles.tableHead]
///   for why that matters.
///
/// **Not ported:** `TableFooter` (`border-t bg-muted/50 font-medium`) — no
/// table in the corpus has one; and `has-aria-expanded:bg-muted/50` on the row,
/// which needs a row that expands and there is none.
library;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart'
    hide
        AspectRatio,
        Icon,
        OverlayPortal,
        RichText,
        SafeArea,
        ScrollPosition,
        Table,
        TableColumnWidth;
import 'package:flutter/widgets.dart' as flutter show Table, TableColumnWidth;

import '../../design_system/foundation/motion.dart';
import '../../design_system/foundation/spacing.dart';
import '../../design_system/foundation/theme.dart';
import '../../design_system/foundation/typography.dart';
import '../../design_system/foundation/theme_scope.dart';

/// `bg-muted/50` — the hover fill, and `CardFooter`'s band elsewhere.
const double _hoverAlpha = 0.5;

/// The column-width rule the reference's own tables resolve to.
///
/// `maxIntrinsicWidth` is the column's widest unwrapped cell; `flex` returns
/// the same number, which is what turns [RenderTable]'s proportional growth
/// into Chrome's proportional distribution. See the library doc.
@immutable
class TableColumnWidth extends flutter.TableColumnWidth {
  const TableColumnWidth();

  @override
  double minIntrinsicWidth(Iterable<RenderBox> cells, double containerWidth) =>
      _widest(cells, min: true);

  @override
  double maxIntrinsicWidth(Iterable<RenderBox> cells, double containerWidth) =>
      _widest(cells, min: false);

  @override
  double? flex(Iterable<RenderBox> cells) {
    final double width = _widest(cells, min: false);
    // `flex` must be strictly positive or the column is treated as unflexed,
    // which would take it out of the distribution entirely.
    return width > 0 ? width : null;
  }

  static double _widest(Iterable<RenderBox> cells, {required bool min}) {
    double result = 0;
    for (final RenderBox cell in cells) {
      final double width = min
          ? cell.getMinIntrinsicWidth(double.infinity)
          : cell.getMaxIntrinsicWidth(double.infinity);
      if (width > result) result = width;
    }
    return result;
  }

  @override
  String toString() => 'TableColumnWidth()';
}

/// `text-left` (the `th` default) or the `text-right` a numeric column carries.
enum TableAlign {
  /// `text-left align-middle`.
  start,

  /// `className="text-right"` — required on numeric columns, per the page's
  /// own rule list.
  end;

  Alignment get alignment =>
      this == TableAlign.start ? Alignment.centerLeft : Alignment.centerRight;
}

/// One `<th>` or `<td>`.
class TableCellSpec {
  const TableCellSpec({
    required this.child,
    this.align = TableAlign.start,
    this.checkbox = false,
  });

  final Widget child;
  final TableAlign align;

  /// `[&:has([role=checkbox])]:pr-0` — a cell holding a checkbox drops its
  /// **right** padding, on both `th` and `td`.
  ///
  /// Written as a flag rather than detected, because Flutter has no `:has()`
  /// and a widget tree walk would be a worse lie than a parameter. It is
  /// visible in the numbers: the data table's select column measures a
  /// max-content of **28** — a 20px checkbox plus one 8px side — where 36
  /// would leave the ticks a column too wide.
  final bool checkbox;
}

/// One `<tr>` in the body.
class TableRowSpec {
  const TableRowSpec({required this.cells, this.selected = false})
    : span = null,
      spanHeight = null;

  /// A row whose single cell carries `colSpan={columns.length}` — the data
  /// table's empty state, `<TableCell colSpan={5} className="h-48">`.
  ///
  /// Flutter's [Table] has no column spanning, so a spanning row is laid out
  /// as its own full-width box beside the table rather than inside it. It is
  /// the only row when it appears, which is what makes that legal here and
  /// what the assertion in [Table] enforces.
  const TableRowSpec.span(Widget this.span, {this.spanHeight})
    : cells = const <TableCellSpec>[],
      selected = false;

  final List<TableCellSpec> cells;

  /// `data-[state=selected]:bg-muted`.
  final bool selected;

  final Widget? span;

  /// `className="h-48"` on the spanning cell.
  final double? spanHeight;

  bool get isSpan => span != null;
}

/// A `<table>` in its `relative w-full overflow-x-auto` container.
class Table extends StatefulWidget {
  const Table({
    super.key,
    required this.header,
    required this.rows,
    this.caption,
  });

  /// The single `<TableRow>` inside `<TableHeader>`. Every table in the corpus
  /// has exactly one header row.
  final List<TableCellSpec> header;

  final List<TableRowSpec> rows;

  /// `<TableCaption>` — `mt-4 text-sm text-muted-foreground`, centred, under
  /// the body.
  final String? caption;

  /// `h-10` on a `th` — the header row's whole box, rule included.
  static double get headerHeight => space(10);

  /// `px-2` on a `th`, `p-2` on a `td`.
  static double get cellPadding => space(2);

  /// `mt-4` on the caption.
  static double get captionGap => space(4);

  /// The rule between two rows.
  static double get ruleWidth => BorderWidths.hairline;

  /// The half of that rule the last row keeps as layout and does not paint.
  static double get collapsedRemainder => BorderWidths.hairline / 2;

  @override
  State<Table> createState() => _TableState();
}

class _TableState extends State<Table> {
  /// The body row under the pointer, or null.
  int? _hovered;

  void _enter(int row) {
    if (_hovered != row) setState(() => _hovered = row);
  }

  void _leave() {
    if (_hovered != null) setState(() => _hovered = null);
  }

  Color? _fill(ThemeTokens theme, TableRowSpec row, int index) {
    // `data-[state=selected]:bg-muted` is written after the hover rule and at
    // equal specificity, so selection wins on a hovered selected row.
    if (row.selected) return theme.muted;
    if (_hovered == index) return theme.muted.withValues(alpha: _hoverAlpha);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final List<TableRowSpec> rows = widget.rows;
    final bool spanning = rows.any((TableRowSpec r) => r.isSpan);
    assert(
      !spanning || rows.length == 1,
      'A colSpan row is laid out beside the table, so it has to be the only '
      'row — which is what the corpus does: the empty state replaces the body.',
    );

    final List<Widget> stack = <Widget>[
      flutter.Table(
        defaultColumnWidth: const TableColumnWidth(),
        defaultVerticalAlignment: TableCellVerticalAlignment.intrinsicHeight,
        children: <TableRow>[
          TableRow(
            children: <Widget>[
              for (final TableCellSpec cell in widget.header)
                _HeaderCell(spec: cell),
            ],
          ),
          if (!spanning)
            for (int i = 0; i < rows.length; i++)
              TableRow(
                children: <Widget>[
                  for (final TableCellSpec cell in rows[i].cells)
                    _BodyCell(
                      spec: cell,
                      fill: _fill(theme, rows[i], i),
                      last: i == rows.length - 1,
                      alone: rows.length == 1,
                      onEnter: () => _enter(i),
                    ),
                ],
              ),
        ],
      ),
      if (spanning)
        SizedBox(
          // `className="h-48"` — the cell's own box, `p-2` inside it.
          height: rows.single.spanHeight,
          child: Padding(
            padding: EdgeInsets.all(Table.cellPadding),
            // `align-middle` on a full-width cell: centred down the page,
            // stretched across it.
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[rows.single.span!],
            ),
          ),
        ),
      if (widget.caption != null) ...<Widget>[
        SizedBox(height: Table.captionGap),
        // The UA stylesheet centres a `<caption>` and nothing overrides it.
        StyledText(
          widget.caption!,
          TextStyles.bodySmall,
          color: theme.mutedForeground,
          align: TextAlign.center,
        ),
      ],
    ];

    return MouseRegion(
      onExit: (_) => _leave(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        // A `<table>` is as tall as its rows and no taller.
        mainAxisSize: MainAxisSize.min,
        children: stack,
      ),
    );
  }
}

/// `<th>` — `h-10 px-2 text-left align-middle font-medium whitespace-nowrap
/// text-foreground`, over `[&_tr]:border-b` on the header row.
class _HeaderCell extends StatelessWidget {
  const _HeaderCell({required this.spec});

  final TableCellSpec spec;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Container(
      height: Table.headerHeight,
      alignment: spec.align.alignment,
      padding: EdgeInsets.only(
        left: Table.cellPadding,
        right: spec.checkbox ? 0 : Table.cellPadding,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.border, width: Table.ruleWidth),
        ),
      ),
      child: DefaultTextStyle(
        style: StyledText.styleOf(
          context,
          TextStyles.tableHead,
          color: theme.foreground,
        ),
        child: spec.child,
      ),
    );
  }
}

/// `<td>` — `p-2 align-middle whitespace-nowrap`, plus the row's rule.
class _BodyCell extends StatelessWidget {
  const _BodyCell({
    required this.spec,
    required this.fill,
    required this.last,
    required this.alone,
    required this.onEnter,
  });

  final TableCellSpec spec;

  /// The **row's** fill, painted per cell.
  ///
  /// The fill belongs to the `<tr>` in CSS and [TableRow.decoration] is where
  /// it would go here — except that a decoration is a value and this one has
  /// to travel over 250ms. The cells tile the row exactly, so painting each
  /// one is the same rectangle, and it puts the colour where a
  /// [TweenAnimationBuilder] can reach it.
  final Color? fill;

  final bool last;
  final bool alone;
  final VoidCallback onEnter;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final EdgeInsets padding = EdgeInsets.fromLTRB(
      Table.cellPadding,
      Table.cellPadding,
      spec.checkbox ? 0 : Table.cellPadding,
      Table.cellPadding,
    );

    // The last row draws no rule. In a body of two or more it still *pays* for
    // the top half of the one above it — see the library doc's table.
    final BoxBorder? rule = last
        ? null
        : Border(
            bottom: BorderSide(color: theme.border, width: Table.ruleWidth),
          );
    final EdgeInsets box = last && !alone
        ? padding.copyWith(bottom: padding.bottom + Table.collapsedRemainder)
        : padding;

    return MouseRegion(
      onEnter: (_) => onEnter(),
      child: TweenAnimationBuilder<Color?>(
        // `transition-colors` with no `duration-*`: the stylesheet default.
        duration: effectiveMotionDuration(context, tableHoverDuration),
        curve: tableHoverCurve,
        tween: ColorTween(end: fill ?? theme.muted.withValues(alpha: 0)),
        builder: (BuildContext context, Color? paint, Widget? child) =>
            Container(
              alignment: spec.align.alignment,
              padding: box,
              decoration: BoxDecoration(color: paint, border: rule),
              child: child,
            ),
        child: DefaultTextStyle(
          style: StyledText.styleOf(
            context,
            TextStyles.bodySmall,
            color: theme.foreground,
          ),
          child: spec.child,
        ),
      ),
    );
  }
}

/// The 250ms `--ease-out` every `transition-colors` on a row runs.
///
/// Exposed so a page test can name the number it drives rather than restating
/// it: `TableRow` writes no `duration-*`, and the probe reads
/// `transition-duration: 0.25s` with `cubic-bezier(0.22, 1, 0.36, 1)`.
Duration get tableHoverDuration => MotionDurations.normal;

/// The curve that transition runs on.
Curve get tableHoverCurve => MotionCurves.enter;
