/// Public documentation metadata for the `chart_cartesian` component.
///
/// `chart-cartesian` HAS a real `registry/components/chart-cartesian.json`
/// manifest: [dependencies] below is that manifest's own `registryDependencies`
/// list, copied verbatim: `chart`, `chart-geometry`, `source-foundation`. One
/// widget, [CartesianChart], stands in for `AreaChart`, `BarChart` and
/// `LineChart` — recharts makes the three one widget with a different
/// `chartName` too — because the only thing that actually differs between
/// them is which scale the category axis resolves to.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry chartCartesianDoc = ComponentDocEntry(
  name: 'chart_cartesian',
  title: 'Chart Cartesian',
  description:
      'One plot widget standing in for AreaChart, BarChart and LineChart: '
      'recharts\' own layout, ported and checked against the rendered SVG, '
      'a band scale under bars and a point scale under areas and lines.',
  // registry/components/chart-cartesian.json's own registryDependencies,
  // verbatim.
  dependencies: <String>['chart', 'chart-geometry', 'source-foundation'],
  exports: <String>[
    'ChartMargin',
    'ChartLayout',
    'ChartAxisType',
    'ChartAxis',
    'ChartGrid',
    'ChartSeriesKind',
    'ChartDot',
    'ChartLabelList',
    'ChartLabelPosition',
    'ChartSeriesSpec',
    'ChartTooltipSpec',
    'ChartLegendSpec',
    'CartesianChart',
    'BarRect',
    'BarSeriesPainter',
  ],
  sourcePath: 'lib/src/components/ui/chart_cartesian.dart',
);
