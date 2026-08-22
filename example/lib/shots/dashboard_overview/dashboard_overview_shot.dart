/// Dashboard overview — an installable metrics screen.
///
/// A Shot: product-neutral application composition, assembled only from
/// registry items. Every `Ds*` symbol traces to one of this Shot's declared
/// registry dependencies — `source-foundation`, `card`, `button`, `select`,
/// `icon`, `tooltip`, `dialog`.
///
/// Three bands:
///
/// 1. A header carrying the screen's name, the range the figures are drawn
///    over, and the export action.
/// 2. A responsive row of stat tiles. The column count is hand-rolled from
///    `MediaQuery.sizeOf(context).width` against [DsBreakpoints], because the
///    registry ships no grid item and a Shot that reached outside the registry
///    would not compile once installed.
/// 3. A recent-activity card whose rows are ruled by a [Border] painted with
///    `theme.border` at [DsWidths.hairline] — the same reason: a separator is
///    not a registry item. Each row opens a [DsDialog] drill-in.
///
/// Nothing here animates on its own; the only motion is the press spring and
/// the dialog's entrance, both of which the design system already routes
/// through `prefers-reduced-motion`.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

/// One figure on the overview.
@immutable
class DashboardStat {
  const DashboardStat({
    required this.label,
    required this.value,
    required this.delta,
    required this.rising,
    required this.hint,
  });

  /// The tile's own name.
  final String label;

  /// The figure, already formatted. A Shot states no locale of its own.
  final String value;

  /// How the figure moved over the selected range.
  final String delta;

  /// Whether [delta] is an increase — which decides the glyph and its tone.
  final bool rising;

  /// The tooltip: what this figure counts, in one short label.
  final String hint;
}

/// One row of the recent-activity card.
@immutable
class DashboardActivity {
  const DashboardActivity({
    required this.title,
    required this.meta,
    required this.amount,
    required this.glyph,
    required this.detail,
  });

  final String title;
  final String meta;
  final String amount;
  final DsIconGlyph glyph;

  /// The drill-in's label/value pairs, in reading order.
  final List<(String, String)> detail;
}

/// A metrics overview with a range picker, responsive stat tiles, and a
/// row-detail drill-in.
class DashboardOverviewShot extends StatefulWidget {
  const DashboardOverviewShot({
    super.key,
    this.stats = defaultStats,
    this.activity = defaultActivity,
    this.initialRange = 'last-30-days',
    this.onExport,
    this.onViewAllActivity,
  });

  final List<DashboardStat> stats;
  final List<DashboardActivity> activity;

  /// The [DsSelectOption] value the range picker opens on.
  final String initialRange;

  /// Exports the selected range. Null leaves the action pressable and silent,
  /// which is what a documentation preview wants: the affordance is part of
  /// the composition even when nothing is wired behind it.
  final void Function(String range)? onExport;

  /// Leaves for the full activity log.
  final VoidCallback? onViewAllActivity;

  /// The ranges the figures may be drawn over.
  static const List<DsSelectOption<String>> ranges = <DsSelectOption<String>>[
    DsSelectOption<String>(value: 'last-7-days', label: 'Last 7 days'),
    DsSelectOption<String>(value: 'last-30-days', label: 'Last 30 days'),
    DsSelectOption<String>(value: 'last-90-days', label: 'Last 90 days'),
    DsSelectOption<String>(value: 'year-to-date', label: 'Year to date'),
  ];

  static const List<DashboardStat> defaultStats = <DashboardStat>[
    DashboardStat(
      label: 'Revenue',
      value: '48,120',
      delta: '+12.4% on the previous range',
      rising: true,
      hint: 'Net of refunds, in the account currency.',
    ),
    DashboardStat(
      label: 'Active users',
      value: '9,431',
      delta: '+4.1% on the previous range',
      rising: true,
      hint: 'Signed in at least once in the range.',
    ),
    DashboardStat(
      label: 'Conversion',
      value: '3.8%',
      delta: '+0.6pt on the previous range',
      rising: true,
      hint: 'Visits that finished a purchase.',
    ),
    DashboardStat(
      label: 'Churn',
      value: '1.9%',
      delta: '-0.3pt on the previous range',
      rising: false,
      hint: 'Subscriptions cancelled in the range.',
    ),
  ];

  static const List<DashboardActivity> defaultActivity = <DashboardActivity>[
    DashboardActivity(
      title: 'Plan upgraded',
      meta: 'Team workspace · 2 hours ago',
      amount: '+240',
      glyph: DsIconGlyph.arrowUpRight,
      detail: <(String, String)>[
        ('Event', 'Plan upgraded'),
        ('Workspace', 'Team'),
        ('Seats', '12'),
        ('Net change', '+240'),
      ],
    ),
    DashboardActivity(
      title: 'Refund issued',
      meta: 'Order 4471 · 6 hours ago',
      amount: '-96',
      glyph: DsIconGlyph.arrowDownLeft,
      detail: <(String, String)>[
        ('Event', 'Refund issued'),
        ('Order', '4471'),
        ('Reason', 'Duplicate charge'),
        ('Net change', '-96'),
      ],
    ),
    DashboardActivity(
      title: 'Invoice settled',
      meta: 'Annual contract · yesterday',
      amount: '+1,880',
      glyph: DsIconGlyph.creditCard,
      detail: <(String, String)>[
        ('Event', 'Invoice settled'),
        ('Term', 'Annual'),
        ('Method', 'Bank transfer'),
        ('Net change', '+1,880'),
      ],
    ),
  ];

  /// The measure the overview column is held to.
  static double get columnWidth => DsWidths.content;

  /// How many tiles sit abreast at [width].
  ///
  /// Four from `lg` up, two from `sm`, one below — the ladder a stat row wants
  /// rather than a general grid, stated once so the layout and its test read
  /// the same rule.
  static int columnsFor(double width) {
    if (width >= DsBreakpoints.lg) return 4;
    if (width >= DsBreakpoints.sm) return 2;
    return 1;
  }

  @override
  State<DashboardOverviewShot> createState() => _DashboardOverviewShotState();
}

class _DashboardOverviewShotState extends State<DashboardOverviewShot> {
  late String _range = widget.initialRange;

  /// The gap between bands, and between tiles — one number, as a card's own
  /// spacing is.
  double get _gap => DsCard.spacing;

  /// [expand] is the trigger's `w-fit` giving way to `w-full`: the header row
  /// lets the picker hug its label, the stacked header hands it a column.
  Widget _rangePicker({required bool expand}) => DsSelect<String>(
    key: const ValueKey<String>('dashboard-range'),
    options: DashboardOverviewShot.ranges,
    value: _range,
    expand: expand,
    label: 'Range',
    placeholder: 'Pick a range',
    onChanged: (String value) => setState(() => _range = value),
  );

  Widget _export() => DsButton(
    key: const ValueKey<String>('dashboard-export'),
    variant: DsButtonVariant.outline,
    onPressed: () => widget.onExport?.call(_range),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const DsIcon(DsIconGlyph.download, size: DsIconSize.sm),
        SizedBox(width: ds(2)),
        DsText('Export', DsComponentType.buttonLabel),
      ],
    ),
  );

  Widget _header(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final bool wide =
        MediaQuery.sizeOf(context).width >= DsBreakpoints.md;

    final Widget heading = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        DsText('Overview', DsType.h2),
        SizedBox(height: ds(1)),
        DsText(
          'How the account moved over the selected range.',
          DsType.small,
          color: theme.mutedForeground,
        ),
      ],
    );

    if (!wide) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          heading,
          SizedBox(height: _gap),
          Row(
            children: <Widget>[
              Expanded(child: _rangePicker(expand: true)),
              SizedBox(width: ds(2)),
              _export(),
            ],
          ),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(child: heading),
        SizedBox(width: ds(2)),
        _rangePicker(expand: false),
        SizedBox(width: ds(2)),
        _export(),
      ],
    );
  }

  Widget _tile(BuildContext context, DashboardStat stat) {
    final DsThemeData theme = DsTheme.of(context);
    return DsTooltip(
      label: stat.hint,
      child: DsCard(
        children: <Widget>[
          DsCardHeader(
            title: DsCardTitle(stat.label),
            action: DsIcon(
              stat.rising ? DsIconGlyph.trendingUp : DsIconGlyph.trendingDown,
              size: DsIconSize.sm,
              tone: stat.rising ? DsIconTone.success : DsIconTone.warning,
            ),
          ),
          DsCardContent(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                DsText(stat.value, DsType.numLg),
                SizedBox(height: ds(1)),
                DsText(
                  stat.delta,
                  DsType.caption,
                  color: theme.mutedForeground,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// The stat row, laid out by hand.
  Widget _tiles(BuildContext context) {
    final int columns = DashboardOverviewShot.columnsFor(
      MediaQuery.sizeOf(context).width,
    );
    final List<DashboardStat> stats = widget.stats;
    final List<Widget> rows = <Widget>[];

    for (int start = 0; start < stats.length; start += columns) {
      final List<Widget> cells = <Widget>[];
      for (int column = 0; column < columns; column++) {
        if (cells.isNotEmpty) cells.add(SizedBox(width: _gap));
        final int index = start + column;
        cells.add(
          Expanded(
            child: index < stats.length
                ? _tile(context, stats[index])
                // A short last row keeps its gutters rather than stretching
                // the tiles that are in it, so the column rhythm survives.
                : const SizedBox.shrink(),
          ),
        );
      }
      if (rows.isNotEmpty) rows.add(SizedBox(height: _gap));
      rows.add(
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: cells),
      );
    }

    return Column(
      key: const ValueKey<String>('dashboard-tiles'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: rows,
    );
  }

  Widget _detailRow(BuildContext context, (String, String) pair) {
    final DsThemeData theme = DsTheme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: ds(2)),
      child: Row(
        children: <Widget>[
          Expanded(
            child: DsText(
              pair.$1,
              DsType.small,
              color: theme.mutedForeground,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: ds(2)),
          DsText(pair.$2, DsType.numSm),
        ],
      ),
    );
  }

  Widget _activityRow(BuildContext context, DashboardActivity entry) {
    final DsThemeData theme = DsTheme.of(context);

    return DsDialog(
      trigger: (BuildContext context, VoidCallback open) => DsButton(
        variant: DsButtonVariant.ghost,
        autoHeight: true,
        suppressPressScale: true,
        radius: BorderRadius.zero,
        contentAlignment: AlignmentDirectional.centerStart,
        padding: EdgeInsets.symmetric(
          horizontal: ds(2),
          vertical: ds(1),
        ),
        onPressed: open,
        child: Row(
          children: <Widget>[
            DsIcon(entry.glyph, size: DsIconSize.sm, tone: DsIconTone.muted),
            SizedBox(width: ds(2)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  DsText(
                    entry.title,
                    DsComponentType.textSm,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  DsText(
                    entry.meta,
                    DsType.caption,
                    color: theme.mutedForeground,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(width: ds(2)),
            DsText(entry.amount, DsType.numSm),
            SizedBox(width: ds(1)),
            const DsIcon(
              DsIconGlyph.chevronRight,
              size: DsIconSize.sm,
              tone: DsIconTone.muted,
            ),
          ],
        ),
      ),
      content: (BuildContext context, VoidCallback close) => DsDialogContent(
        key: const ValueKey<String>('dashboard-activity-dialog'),
        onClose: close,
        children: <Widget>[
          DsDialogHeader(
            children: <Widget>[
              DsDialogTitle(entry.title),
              DsDialogDescription(entry.meta),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for (final (String, String) pair in entry.detail)
                _detailRow(context, pair),
            ],
          ),
          DsDialogFooter(
            children: <Widget>[
              DsButton(
                variant: DsButtonVariant.outline,
                onPressed: close,
                child: DsText('Close', DsComponentType.buttonLabel),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _activityCard(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final List<DashboardActivity> entries = widget.activity;

    return DsCard(
      key: const ValueKey<String>('dashboard-activity'),
      children: <Widget>[
        DsCardHeader(
          title: const DsCardTitle('Recent activity'),
          description: const DsCardDescription(
            'The last movements on the account. Open a row for its detail.',
          ),
          action: DsButton(
            key: const ValueKey<String>('dashboard-view-all'),
            variant: DsButtonVariant.ghost,
            size: DsButtonSize.sm,
            onPressed: () => widget.onViewAllActivity?.call(),
            child: DsText('View all', DsComponentType.buttonLabelSm),
          ),
        ),
        DsCardContent(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for (int i = 0; i < entries.length; i++)
                // The rule between rows: a hairline of `theme.border`, on
                // every row but the first. Hand-painted because a separator is
                // not a registry item.
                DecoratedBox(
                  decoration: BoxDecoration(
                    border: i == 0
                        ? null
                        : Border(
                            top: BorderSide(
                              color: theme.border,
                              width: DsWidths.hairline,
                            ),
                          ),
                  ),
                  child: _activityRow(context, entries[i]),
                ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.topCenter,
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: DashboardOverviewShot.columnWidth),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _header(context),
          SizedBox(height: _gap),
          _tiles(context),
          SizedBox(height: _gap),
          _activityCard(context),
        ],
      ),
    ),
  );
}
