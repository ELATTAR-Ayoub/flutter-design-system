/// A live analytics card for the home grid: a `ElStat`, a `ElToggleGroup`
/// and a sparkline `ElCartesianChart`, all three driven by one selected
/// metric so the header's "Switch metric" button and the toggle group below
/// it are two controls over a single source of truth.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

/// One metric's figure, delta and sparkline series.
@immutable
class _Metric {
  const _Metric({
    required this.toggleLabel,
    required this.statLabel,
    required this.value,
    required this.deltaValue,
    required this.direction,
    required this.betterWhen,
    required this.series,
  });

  /// The toggle group's own label for this metric.
  final String toggleLabel;

  /// The `ElStat` label — the same word for two of the three, its own for
  /// the third.
  final String statLabel;

  final String value;

  /// The delta's unsigned magnitude — the component writes the sign.
  final String deltaValue;

  final ElStatDirection direction;
  final ElStatDirection betterWhen;

  /// Twelve points, oldest first, ending on [value].
  final List<double> series;
}

const List<_Metric> _metrics = <_Metric>[
  _Metric(
    toggleLabel: 'Visitors',
    statLabel: 'Visitors',
    value: '418.2K',
    deltaValue: '10%',
    direction: ElStatDirection.up,
    betterWhen: ElStatDirection.up,
    series: <double>[
      380,
      386,
      392,
      388,
      395,
      402,
      398,
      405,
      410,
      408,
      414,
      418.2,
    ],
  ),
  _Metric(
    toggleLabel: 'Sessions',
    statLabel: 'Sessions',
    value: '612.9K',
    deltaValue: '4.2%',
    direction: ElStatDirection.up,
    betterWhen: ElStatDirection.up,
    series: <double>[
      560,
      570,
      575,
      582,
      578,
      590,
      595,
      600,
      598,
      605,
      610,
      612.9,
    ],
  ),
  _Metric(
    toggleLabel: 'Bounce',
    statLabel: 'Bounce rate',
    value: '38.1%',
    deltaValue: '2.4pt',
    direction: ElStatDirection.down,
    betterWhen: ElStatDirection.down,
    series: <double>[
      44,
      43.2,
      42.8,
      43.5,
      42.1,
      41.6,
      40.9,
      40.2,
      39.8,
      39.1,
      38.6,
      38.1,
    ],
  ),
];

/// A stat plus its own sparkline, with a toggle group and a header button
/// both selecting which of the three metrics is shown.
class AnalyticsCard extends StatefulWidget {
  const AnalyticsCard({super.key});

  @override
  State<AnalyticsCard> createState() => _AnalyticsCardState();
}

class _AnalyticsCardState extends State<AnalyticsCard> {
  /// The width the three-segment toggle needs. Measured, not guessed: at the
  /// 344px a two-column grid gives a cell, the group overflowed by 18px.
  static double get _toggleFloor => el(96);

  int _metric = 0;

  void _cycle() => setState(() => _metric = (_metric + 1) % _metrics.length);

  void _select(int index) => setState(() => _metric = index);

  /// The metric picker, in whichever form the cell is wide enough to hold.
  ///
  /// A [ElToggleGroup] is intrinsically sized — three labelled segments have a
  /// width and cannot give it back — so in a masonry column narrow enough it
  /// overflows rather than shrinking. Past [_toggleFloor] it is the better
  /// control; under it, a select says the same thing in one line's width.
  Widget _picker() => LayoutBuilder(
    builder: (BuildContext context, BoxConstraints constraints) {
      if (constraints.maxWidth >= _toggleFloor) {
        return ElToggleGroup(
          key: const ValueKey<String>('home-analytics-toggle'),
          size: ElToggleSize.sm,
          label: 'Metric',
          items: <ElToggleGroupItem>[
            for (final _Metric m in _metrics)
              ElToggleGroupItem(label: m.toggleLabel),
          ],
          selectedIndex: _metric,
          onChanged: (int? next) => _select(next ?? _metric),
        );
      }
      return ElSelect<int>(
        key: const ValueKey<String>('home-analytics-select'),
        expand: true,
        options: <ElSelectOption<int>>[
          for (int i = 0; i < _metrics.length; i++)
            ElSelectOption<int>(value: i, label: _metrics[i].toggleLabel),
        ],
        value: _metric,
        onChanged: _select,
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    final _Metric metric = _metrics[_metric];

    return ElCard(
      children: <Widget>[
        ElCardHeader(
          title: const ElCardTitle('Analytics'),
          action: ElButton(
            key: const ValueKey<String>('home-analytics-switch'),
            variant: ElButtonVariant.outline,
            size: ElButtonSize.sm,
            onPressed: _cycle,
            child: const Text('Switch metric'),
          ),
        ),
        ElCardContent(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ElStat(
                label: metric.statLabel,
                value: metric.value,
                delta: (value: metric.deltaValue, direction: metric.direction),
                betterWhen: metric.betterWhen,
              ),
              SizedBox(height: el(3)),
              _picker(),
              SizedBox(height: el(3)),
              ElChartContainer(
                height: el(16),
                config: ElChartConfig(<String, ElChartSeries>{
                  'value': ElChartSeries(
                    label: metric.statLabel,
                    color: theme.chart1,
                  ),
                }),
                child: ElCartesianChart(
                  data: <Map<String, Object?>>[
                    for (final double v in metric.series)
                      <String, Object?>{'value': v},
                  ],
                  series: <ElChartSeriesSpec>[
                    ElChartSeriesSpec(
                      kind: ElChartSeriesKind.area,
                      dataKey: 'value',
                      curve: ElCurveType.natural,
                      fill: theme.chart1,
                      fillOpacity: 0.35,
                      stroke: theme.chart1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
