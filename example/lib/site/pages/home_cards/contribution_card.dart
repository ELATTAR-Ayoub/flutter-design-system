/// A contribution-history card: a bar chart of monthly amounts, two summary
/// tiles below it, and a footer button that toggles the chart's range.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
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
    final ThemeTokens theme = ThemeScope.of(context);
    return Card(
      children: <Widget>[
        CardContent(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              StyledText(
                tile.caption,
                TextStyles.caption,
                color: theme.mutedForeground,
              ),
              SizedBox(height: space(1)),
              StyledText(tile.value, TextStyles.h4),
              SizedBox(height: space(1)),
              StyledText(
                tile.sub,
                TextStyles.small,
                color: theme.mutedForeground,
              ),
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
      final int columns = constraints.maxWidth >= space(70) ? 2 : 1;
      final double gap = Card.spacing;
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
    final ThemeTokens theme = ThemeScope.of(context);
    final double gap = Card.spacing;

    return Card(
      children: <Widget>[
        CardHeader(
          title: const CardTitle('Contribution history'),
          description: CardDescription(
            'Last ${_data.length} months of activity',
          ),
        ),
        CardContent(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ChartContainer(
                height: space(48),
                config: ChartConfig(<String, ChartSeries>{
                  'amount': ChartSeries(
                    label: 'Contributions',
                    color: theme.chart1,
                  ),
                }),
                child: CartesianChart(
                  data: _data,
                  // `vertical: false`, not `horizontal: false`: the rules a
                  // bar chart wants run behind the bars, not between them.
                  grid: const ChartGrid(vertical: false),
                  xAxis: const ChartAxis(
                    dataKey: 'month',
                    tickLine: false,
                    axisLine: false,
                  ),
                  tooltip: const ChartTooltipSpec(),
                  series: <ChartSeriesSpec>[
                    ChartSeriesSpec(
                      kind: ChartSeriesKind.bar,
                      dataKey: 'amount',
                      fill: theme.chart1,
                      radii: <double>[Radii.sm, Radii.sm, Radii.sm, Radii.sm],
                    ),
                  ],
                ),
              ),
              SizedBox(height: gap),
              _tiles(context),
            ],
          ),
        ),
        CardFooter(
          child: Button(
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
