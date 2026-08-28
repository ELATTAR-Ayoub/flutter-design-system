/// Public documentation metadata for the `chart_geometry` component.
///
/// `chart-geometry` HAS a real `registry/components/chart-geometry.json`
/// manifest: [dependencies] below is that manifest's own `registryDependencies`
/// list, copied verbatim — empty. Nothing here draws on its own: this file is
/// the maths every chart on the page is built from, ported from recharts
/// 3.8's own `d3-shape`/`recharts-scale` layer and checked against the
/// rendered SVG rather than against their documentation.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry chartGeometryDoc = ComponentDocEntry(
  name: 'chart_geometry',
  title: 'Chart Geometry',
  description:
      'The maths under every chart: nice-tick generation, band/point/linear '
      'scales, bar-slot layout, the four line and area curve interpolators, '
      'and the polar coordinate and sector-path routines every polar chart '
      'paints through.',
  // registry/components/chart-geometry.json's own registryDependencies,
  // verbatim — empty.
  dependencies: <String>[],
  exports: <String>[
    'chartNiceTicks',
    'chartNiceDomain',
    'BandScale',
    'PointScale',
    'LinearScale',
    'BarSlot',
    'barSlots',
    'barRRect',
    'CurveType',
    'curvePath',
    'areaPath',
    'polarToCartesian',
    'polarMaxRadius',
    'sectorPath',
    'sectorWithCornerPath',
    'polarPolygonPath',
  ],
  sourcePath: 'lib/src/components/chart_geometry.dart',
);
