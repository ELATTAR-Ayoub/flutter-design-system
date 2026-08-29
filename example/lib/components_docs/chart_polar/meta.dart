/// Public documentation metadata for the `chart_polar` component.
///
/// `chart-polar` HAS a real `registry/components/chart-polar.json` manifest:
/// [dependencies] below is that manifest's own `registryDependencies` list,
/// copied verbatim: `chart`, `chart-cartesian`, `chart-geometry`,
/// `source-foundation`. Three widgets share one convention: degrees,
/// counter-clockwise from three o'clock, negated on the way into screen
/// space — `polarToCartesian` from `chart-geometry`.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry chartPolarDoc = ComponentDocEntry(
  name: 'chart_polar',
  title: 'Chart Polar',
  description:
      'Three polar plot widgets sharing one convention — degrees, '
      'counter-clockwise from three o\'clock: PieChart, RadarChart and '
      'RadialBarChart.',
  // registry/components/chart-polar.json's own registryDependencies,
  // verbatim.
  dependencies: <String>[
    'chart',
    'chart-cartesian',
    'chart-geometry',
    'source-foundation',
  ],
  exports: <String>[
    'PolarGridType',
    'PolarGrid',
    'PolarAngleAxis',
    'PolarRadiusAxis',
    'PieSpec',
    'PieChart',
    'RadarSpec',
    'ChartDotSpec',
    'RadarChart',
    'RadialBarSpec',
    'RadialBarChart',
  ],
  sourcePath: 'lib/src/components/ui/chart_polar.dart',
);
