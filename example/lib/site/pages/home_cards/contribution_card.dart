/// A contribution-history card: a bar chart of monthly amounts, two summary
/// tiles below it, and a footer button that toggles the chart's range.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

/// One summary tile's content.
class _ContributionTile {
  const _ContributionTile({
    required this.caption,
    required this.value,
    required this.sub,
  });

  final String caption;
  final String value;
  final String sub;
}

const List<_ContributionTile> _contributionTiles = <_ContributionTile>[
  _ContributionTile(caption: 'UPCOMING', value: 'May 2024', sub: 'Scheduled'),
  _ContributionTile(
    caption: 'SAVINGS PLAN',
    value: 'Accelerated',
    sub: 'Recurring',
  ),
];

/// Six months of contribution amounts, oldest first.
const List<Map<String, Object?>> _contributionData = <Map<String, Object?>>[
  <String, Object?>{'month': 'Dec', 'amount': 180},
  <String, Object?>{'month': 'Jan', 'amount': 220},
  <String, Object?>{'month': 'Feb', 'amount': 165},
  <String, Object?>{'month': 'Mar', 'amount': 240},
  <String, Object?>{'month': 'Apr', 'amount': 205},
  <String, Object?>{'month': 'May', 'amount': 260},
];

class ContributionCard extends StatefulWidget {
  const ContributionCard({super.key});

  @override
  State<ContributionCard> createState() => _ContributionCardState();
}

class _ContributionCardState extends State<ContributionCard> {
  bool _fullRange = false;

  List<Map<String, Object?>> get _data => _fullRange
      ? _contributionData
      : _contributionData.sublist(_contributionData.length - 3);

  Widget _tile(BuildContext context, _ContributionTile tile) {
    final ElThemeData theme = ElTheme.of(context);
    return ElCard(
      children: <Widget>[
        ElCardContent(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ElText(
                tile.caption,
                ElType.caption,
                color: theme.mutedForeground,
              ),
              SizedBox(height: el(1)),
              ElText(tile.value, ElType.h4),
              SizedBox(height: el(1)),
              ElText(tile.sub, ElType.small, color: theme.mutedForeground),
            ],
          ),
        ),
      ],
    );
  }

  /// Two tiles abreast once the card has room for them, one otherwise. Read
  /// off this card's own constraints, never the window: a masonry cell can be
  /// narrow on a wide screen just as easily as on a phone.
  Widget _tiles(BuildContext context) => LayoutBuilder(
    builder: (BuildContext context, BoxConstraints constraints) {
      final int columns = constraints.maxWidth >= el(70) ? 2 : 1;
      final double gap = ElCard.spacing;
      final List<Widget> rows = <Widget>[];
      for (int start = 0; start < _contributionTiles.length; start += columns) {
        final List<Widget> cells = <Widget>[];
        for (int c = 0; c < columns; c++) {
          if (cells.isNotEmpty) cells.add(SizedBox(width: gap));
          final int index = start + c;
          cells.add(
            Expanded(
              child: index < _contributionTiles.length
                  ? _tile(context, _contributionTiles[index])
                  : const SizedBox.shrink(),
            ),
          );
        }
        if (rows.isNotEmpty) rows.add(SizedBox(height: gap));
        rows.add(
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: cells),
        );
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: rows,
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    final double gap = ElCard.spacing;

    return ElCard(
      children: <Widget>[
        ElCardHeader(
          title: const ElCardTitle('Contribution history'),
          description: ElCardDescription(
            'Last ${_data.length} months of activity',
          ),
        ),
        ElCardContent(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ElChartContainer(
                height: el(48),
                config: ElChartConfig(<String, ElChartSeries>{
                  'amount': ElChartSeries(
                    label: 'Contributions',
                    color: theme.chart1,
                  ),
                }),
                child: ElCartesianChart(
                  data: _data,
                  // `vertical: false`, not `horizontal: false`: the rules a
                  // bar chart wants run behind the bars, not between them.
                  grid: const ElChartGrid(vertical: false),
                  xAxis: const ElChartAxis(
                    dataKey: 'month',
                    tickLine: false,
                    axisLine: false,
                  ),
                  tooltip: const ElChartTooltipSpec(),
                  series: <ElChartSeriesSpec>[
                    ElChartSeriesSpec(
                      kind: ElChartSeriesKind.bar,
                      dataKey: 'amount',
                      fill: theme.chart1,
                      radii: <double>[
                        ElRadii.sm,
                        ElRadii.sm,
                        ElRadii.sm,
                        ElRadii.sm,
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: gap),
              _tiles(context),
            ],
          ),
        ),
        ElCardFooter(
          child: ElButton(
            key: const ValueKey<String>('home-contribution-toggle'),
            contentAlignment: AlignmentDirectional.center,
            onPressed: () => setState(() => _fullRange = !_fullRange),
            child: Text(_fullRange ? 'Show less' : 'View full report'),
          ),
        ),
      ],
    );
  }
}
