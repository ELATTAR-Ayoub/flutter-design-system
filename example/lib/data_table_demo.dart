/// `components/el/data-table-demo.tsx`: the Data Table recipe, live.
///
/// The reference's own header says why it is not a component:
///
/// > Not a component in `ui/`: deliberately. shadcn ships Data Table as a
/// > RECIPE over `table.tsx`, not as a file, because the interesting part is
/// > always the column definitions and those belong to whatever is being
/// > listed. Wrapping it would mean inventing an API for something whose whole
/// > job is to differ per screen.
///
/// So it lives beside `kit.dart` rather than in the package, exactly as it
/// lives beside `kit.tsx` rather than in `components/ui/`. What the port
/// replaces is `@tanstack/react-table`: four features: sort, filter, select,
/// paginate: reproduced from the behaviour the library actually shows, probed
/// on the live page rather than read out of its docs.
///
/// ## The four behaviours, measured
///
///  * **Sorting cycles first → opposite → none**, and *first* is not always
///    ascending. TanStack picks the direction from the data: a column whose
///    first value is a number sorts **descending first**. *(Probed: three
///    clicks on Price give `$21,000 → $95 → unsorted`; three on Card give
///    `Celestial Strike → Shadow Core → unsorted`.)*
///  * **String columns compare as plain lower-cased text**, not as
///    alphanumeric chunks. *(Probed on Grade: ascending puts `PSA 10` before
///    `PSA 9`, which chunked comparison would reverse.)*
///  * **Filtering is a case-insensitive substring** on the Card column, and
///    the pager counts the filtered set: `Page 1 of 1 · 0 of 8 cards`.
///  * **Selection is keyed by `getRowId`**, so a sort does not move the ticks.
///
/// ## The geometry, measured
///
///  * The filter is `max-w-xs flex-1`, 320px: with the glyph absolutely
///    placed at `left-4`, and the input carries `pl-10` for it. *(Measured:
///    input 320×40 at x 325, glyph 14×14 at x 341.)*
///  * A sort header is `-mx-2 … px-2`, so its padding cancels the `th`'s and
///    the column measures **text + gap + glyph + the `th`'s own `px-2`**.
///    *(Measured: the `Card` column's max-content is 65.734: a 29.7px string
///    plus 36.)*
///  * `[&:has([role=checkbox])]:pr-0` drops the right padding of any cell with
///    a checkbox in it, which is why the select column measures **28** and not
///    36.
///  * The empty state's cell is `h-48`: a hard 192px: and the `Empty` inside
///    it is 167.69 tall, centred. Its dashed border never paints: `Empty`
///    writes `border-dashed` and no width. *(Measured: `border-top-width: 0px`,
///    `border-top-style: dashed`.)*
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

/// One row of `SALES`.
typedef _Sale = ({String id, String card, String set, String grade, int price});

/// `SALES`: the eight rows, in the file's own order.
const List<_Sale> _sales = <_Sale>[
  (id: '1', card: 'Eclipse Vault', set: 'Origin', grade: 'PSA 10', price: 4820),
  (id: '2', card: 'Golden Rift', set: 'Origin', grade: 'PSA 9', price: 1240),
  (id: '3', card: 'Mystic Surge', set: 'Celestial', grade: 'Raw', price: 320),
  (
    id: '4',
    card: 'Shadow Core',
    set: 'Celestial',
    grade: 'PSA 10',
    price: 7600,
  ),
  (id: '5', card: 'Origin Pulse', set: 'Origin', grade: 'PSA 9', price: 180),
  (
    id: '6',
    card: 'Celestial Strike',
    set: 'Celestial',
    grade: 'PSA 10',
    price: 21000,
  ),
  (id: '7', card: 'Ember Wake', set: 'Ember', grade: 'Raw', price: 95),
  (id: '8', card: 'Frost Herald', set: 'Ember', grade: 'PSA 9', price: 640),
];

/// `initialState: { pagination: { pageSize: 4 } }`.
const int _pageSize = 4;

/// `SKELETON_ROWS`, *"static keys: a skeleton row has no identity beyond its
/// position."*
const int _skeletonRows = 4;

/// The five columns, by id.
enum _Column {
  select,
  card,
  set,
  grade,
  price;

  /// `header`: the string `flexRender` draws, or null for the checkbox
  /// column.
  String? get header => switch (this) {
    _Column.select => null,
    _Column.card => 'Card',
    _Column.set => 'Set',
    _Column.grade => 'Grade',
    _Column.price => 'Price',
  };

  /// `enableSorting: false` on the select column; every other column sorts.
  bool get sortable => this != _Column.select;

  /// TanStack's `getAutoSortDir`: **descending first when the value is a
  /// number**, ascending otherwise. Probed, not assumed: see the library doc.
  bool get descFirst => this == _Column.price;
}

/// `new Intl.NumberFormat("en-US", { style: "currency", currency: "USD",
/// maximumFractionDigits: 0 })`, *"money is mono, tabular and right-aligned."*
String _money(int value) {
  final String digits = value.toString();
  final StringBuffer grouped = StringBuffer();
  for (int i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) grouped.write(',');
    grouped.write(digits[i]);
  }
  return '\$$grouped';
}

/// `sortingFns.text`, `compareBasic(a.toLowerCase(), b.toLowerCase())`.
int _text(String a, String b) => a.toLowerCase().compareTo(b.toLowerCase());

/// The demo.
class DataTableDemo extends StatefulWidget {
  const DataTableDemo({super.key, this.loading = false});

  /// The second panel: *"skeleton rows on the real footprint."*
  final bool loading;

  /// `space-y-4`: between the filter row, the table and the pager.
  static double get stackGap => el(4);

  /// `max-w-xs` on the filter.
  // allow-hardcoded: framework container scale with no token to read it from.
  static const double filterWidth = 320;

  /// `pl-10`: the room the glyph needs.
  static double get filterInset => el(10);

  /// `left-4`: where the glyph sits.
  static double get glyphInset => el(4);

  /// `rounded-lg border border-border overflow-hidden` around the table.
  static double get frameRadius => ElRadii.lg;

  /// `className="h-48"` on the empty state's cell.
  static double get emptyCellHeight => el(48);

  @override
  State<DataTableDemo> createState() => _DataTableDemoState();
}

class _DataTableDemoState extends State<DataTableDemo> {
  /// `useState<SortingState>([])`: at most one column, TanStack's default.
  _Column? _sortBy;
  bool _sortDesc = false;

  /// `useState<ColumnFiltersState>([])`, on the `card` column only.
  final TextEditingController _filter = TextEditingController();

  /// `useState<RowSelectionState>({})`, keyed by `getRowId`: the row's own id.
  final Set<String> _selected = <String>{};

  int _page = 0;

  @override
  void initState() {
    super.initState();
    _filter.addListener(_onFilter);
  }

  @override
  void dispose() {
    _filter.removeListener(_onFilter);
    _filter.dispose();
    super.dispose();
  }

  void _onFilter() => setState(() => _page = 0);

  /// `getToggleSortingHandler()`: first → opposite → none.
  void _toggleSort(_Column column) {
    setState(() {
      if (_sortBy != column) {
        _sortBy = column;
        _sortDesc = column.descFirst;
      } else if (_sortDesc == column.descFirst) {
        _sortDesc = !_sortDesc;
      } else {
        // `enableSortingRemoval` defaults to true.
        _sortBy = null;
        _sortDesc = false;
      }
    });
  }

  /// `getFilteredRowModel()`: the built-in `includesString` filter fn.
  List<_Sale> get _filtered {
    final String query = _filter.text.toLowerCase();
    if (query.isEmpty) return _sales;
    return _sales
        .where((_Sale row) => row.card.toLowerCase().contains(query))
        .toList();
  }

  /// `getSortedRowModel()`: a stable sort, so equal keys keep source order.
  List<_Sale> get _sorted {
    final List<_Sale> rows = List<_Sale>.of(_filtered);
    final _Column? by = _sortBy;
    if (by == null) return rows;

    int compare(_Sale a, _Sale b) => switch (by) {
      _Column.card => _text(a.card, b.card),
      _Column.set => _text(a.set, b.set),
      _Column.grade => _text(a.grade, b.grade),
      _Column.price => a.price.compareTo(b.price),
      _Column.select => 0,
    };

    // Dart's `sort` is not stable; decorating with the source index makes it
    // so, which is what TanStack's own sort guarantees.
    final List<({int i, _Sale row})> decorated =
        <({int i, _Sale row})>[
          for (int i = 0; i < rows.length; i++) (i: i, row: rows[i]),
        ]..sort((({int i, _Sale row}) a, ({int i, _Sale row}) b) {
          final int result = compare(a.row, b.row) * (_sortDesc ? -1 : 1);
          return result != 0 ? result : a.i.compareTo(b.i);
        });
    return <_Sale>[for (final ({int i, _Sale row}) e in decorated) e.row];
  }

  int get _pageCount => (_sorted.length / _pageSize).ceil();

  List<_Sale> get _rows {
    final List<_Sale> rows = _sorted;
    final int start = _page * _pageSize;
    if (start >= rows.length) return const <_Sale>[];
    final int end = start + _pageSize > rows.length
        ? rows.length
        : start + _pageSize;
    return rows.sublist(start, end);
  }

  bool get _canPrevious => _page > 0;
  bool get _canNext => _page + 1 < _pageCount;

  /// `table.getIsAllPageRowsSelected()` / `getIsSomePageRowsSelected()`.
  ElCheckboxState get _headerState {
    final List<_Sale> page = _rows;
    if (page.isEmpty) return ElCheckboxState.unchecked;
    final int ticked = page
        .where((_Sale row) => _selected.contains(row.id))
        .length;
    if (ticked == page.length) return ElCheckboxState.checked;
    return ticked == 0
        ? ElCheckboxState.unchecked
        : ElCheckboxState.indeterminate;
  }

  void _toggleAll(ElCheckboxState next) {
    setState(() {
      final bool on = next == ElCheckboxState.checked;
      for (final _Sale row in _rows) {
        if (on) {
          _selected.add(row.id);
        } else {
          _selected.remove(row.id);
        }
      }
    });
  }

  void _toggleRow(_Sale row, ElCheckboxState next) {
    setState(() {
      if (next == ElCheckboxState.checked) {
        _selected.add(row.id);
      } else {
        _selected.remove(row.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    final bool loading = widget.loading;
    final List<_Sale> rows = _rows;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _FilterRow(
          controller: _filter,
          enabled: !loading,
          selected: _selected.length,
        ),
        SizedBox(height: DataTableDemo.stackGap),
        // `overflow-hidden rounded-lg border border-border`.
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(DataTableDemo.frameRadius),
            border: Border.all(color: theme.border, width: ElWidths.hairline),
          ),
          child: Padding(
            padding: const EdgeInsets.all(ElWidths.hairline),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                DataTableDemo.frameRadius - ElWidths.hairline,
              ),
              child: ElTable(
                header: <ElTableCellSpec>[
                  for (final _Column column in _Column.values)
                    ElTableCellSpec(
                      checkbox: column == _Column.select,
                      child: column == _Column.select
                          ? ElCheckbox(
                              state: _headerState,
                              label: 'Select all rows on this page',
                              onChanged: loading ? null : _toggleAll,
                            )
                          : _SortHeader(
                              label: column.header!,
                              sorted: _sortBy == column
                                  ? (_sortDesc ? _Sorted.desc : _Sorted.asc)
                                  : _Sorted.none,
                              onPressed: loading
                                  ? null
                                  : () => _toggleSort(column),
                            ),
                    ),
                ],
                rows: <ElTableRowSpec>[
                  if (loading)
                    for (int i = 0; i < _skeletonRows; i++)
                      ElTableRowSpec(
                        cells: <ElTableCellSpec>[
                          for (final _Column column in _Column.values)
                            ElTableCellSpec(
                              checkbox: column == _Column.select,
                              // `<Skeleton className="h-4 w-full"/>`.
                              child: ElSkeleton(height: el(4)),
                            ),
                        ],
                      )
                  else if (rows.isEmpty)
                    ElTableRowSpec.span(
                      _EmptyState(
                        query: _filter.text,
                        onClear: () => _filter.clear(),
                      ),
                      spanHeight: DataTableDemo.emptyCellHeight,
                    )
                  else
                    for (final _Sale row in rows)
                      ElTableRowSpec(
                        selected: _selected.contains(row.id),
                        cells: <ElTableCellSpec>[
                          ElTableCellSpec(
                            checkbox: true,
                            child: ElCheckbox(
                              state: _selected.contains(row.id)
                                  ? ElCheckboxState.checked
                                  : ElCheckboxState.unchecked,
                              label: 'Select ${row.card}',
                              onChanged: (ElCheckboxState next) =>
                                  _toggleRow(row, next),
                            ),
                          ),
                          ElTableCellSpec(child: Text(row.card)),
                          ElTableCellSpec(child: Text(row.set)),
                          ElTableCellSpec(
                            child: ElBadge(
                              label: row.grade,
                              variant: row.grade == 'PSA 10'
                                  ? ElBadgeVariant.premium
                                  : ElBadgeVariant.outline,
                            ),
                          ),
                          ElTableCellSpec(
                            // `block text-right` inside a cell that is not
                            // itself right-aligned.
                            align: ElTableAlign.end,
                            child: ElText(
                              _money(row.price),
                              ElType.numSm,
                              color: theme.foreground,
                            ),
                          ),
                        ],
                      ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: DataTableDemo.stackGap),
        _PagerRow(
          caption: loading
              ? 'Loading…'
              : 'Page ${_page + 1} of ${_pageCount < 1 ? 1 : _pageCount} · '
                    '${_filtered.length} of ${_sales.length} cards',
          onPrevious: loading || !_canPrevious
              ? null
              : () => setState(() => _page -= 1),
          onNext: loading || !_canNext
              ? null
              : () => setState(() => _page += 1),
        ),
      ],
    );
  }
}

/// `flex flex-wrap items-center gap-3`: the filter and the selection count.
class _FilterRow extends StatelessWidget {
  const _FilterRow({
    required this.controller,
    required this.enabled,
    required this.selected,
  });

  final TextEditingController controller;
  final bool enabled;
  final int selected;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          width: DataTableDemo.filterWidth,
          child: Stack(
            alignment: AlignmentDirectional.centerStart,
            children: <Widget>[
              ElInput(
                controller: controller,
                placeholder: 'Filter by card',
                label: 'Filter by card',
                enabled: enabled,
                // `className="pl-10"` over the component's own `px-4`.
                padding: EdgeInsetsDirectional.fromSTEB(
                  DataTableDemo.filterInset,
                  el(1),
                  el(4),
                  el(1),
                ),
              ),
              // `pointer-events-none absolute top-1/2 left-4 -translate-y-1/2`.
              PositionedDirectional(
                start: DataTableDemo.glyphInset,
                child: const IgnorePointer(
                  child: ElIcon.lucide(
                    ElLucide.search,
                    size: ElIconSize.sm,
                    tone: ElIconTone.muted,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (selected > 0) ...<Widget>[
          // `gap-3`.
          SizedBox(width: el(3)),
          ElText(
            '$selected selected',
            ElType.caption,
            color: theme.mutedForeground,
          ),
        ],
      ],
    );
  }
}

/// Which arrow a sortable header shows.
enum _Sorted { none, asc, desc }

/// The `<button className="click-spring -mx-2 flex items-center gap-1.5 …">`
/// inside a `TableHead`.
///
/// *"A real button, not a click handler on the `<th>`. Sorting is an action, so
/// it has to be reachable by keyboard and announced as a control (§7)."*
///
/// Its `-mx-2` cancels its own `px-2` exactly, so the painted box overhangs the
/// `th`'s padding and contributes nothing to the column's width: which is why
/// this is the row of content and not a padded box. `hover:text-foreground` is
/// a no-op here: a `th` is already `text-foreground`.
class _SortHeader extends StatelessWidget {
  const _SortHeader({
    required this.label,
    required this.sorted,
    required this.onPressed,
  });

  final String label;
  final _Sorted sorted;
  final VoidCallback? onPressed;

  /// `gap-1.5`.
  static double get gap => el(1.5);

  @override
  Widget build(BuildContext context) => ElPress(
    scale: ElTransforms.clickSpringScale,
    onTap: onPressed,
    behavior: HitTestBehavior.opaque,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(label),
        SizedBox(width: gap),
        ElIcon.lucide(
          switch (sorted) {
            _Sorted.asc => ElLucide.arrowUp,
            _Sorted.desc => ElLucide.arrowDown,
            _Sorted.none => ElLucide.arrowUpDown,
          },
          size: ElIconSize.sm,
          tone: sorted == _Sorted.none ? ElIconTone.muted : ElIconTone.action,
        ),
      ],
    ),
  );
}

/// The filtered-to-nothing state.
class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.query, required this.onClear});

  final String query;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) => ElEmpty(
    children: <Widget>[
      ElEmptyTitle('No cards match “$query”'),
      const ElEmptyDescription(
        'Try a shorter search, or clear the filter to see all eight.',
      ),
      Padding(
        // `className="mt-4"`: on top of the `Empty`'s own `gap-4`.
        padding: EdgeInsets.only(top: el(4)),
        child: ElButton(
          variant: ElButtonVariant.outline,
          size: ElButtonSize.sm,
          onPressed: onClear,
          child: const Text('Clear filter'),
        ),
      ),
    ],
  );
}

/// `flex flex-wrap items-center justify-between gap-3`.
class _PagerRow extends StatelessWidget {
  const _PagerRow({
    required this.caption,
    required this.onPrevious,
    required this.onNext,
  });

  final String caption;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          child: ElText(caption, ElType.caption, color: theme.mutedForeground),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ElButton(
              variant: ElButtonVariant.outline,
              size: ElButtonSize.sm,
              onPressed: onPrevious,
              child: const Text('Previous'),
            ),
            // `gap-2`.
            SizedBox(width: el(2)),
            ElButton(
              variant: ElButtonVariant.outline,
              size: ElButtonSize.sm,
              onPressed: onNext,
              child: const Text('Next'),
            ),
          ],
        ),
      ],
    );
  }
}
