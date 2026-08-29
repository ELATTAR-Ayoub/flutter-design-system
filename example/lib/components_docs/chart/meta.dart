/// Public documentation metadata for the `chart` component.
///
/// `chart` HAS a real `registry/components/chart.json` manifest:
/// [dependencies] below is that manifest's own `registryDependencies` list,
/// copied verbatim: `source-foundation` only. This is `components/ui/chart.tsx`,
/// the official shadcn wrapper, ported: the themed [ChartConfig], the
/// fixed-height [ChartContainer] every plot mounts inside, the hover
/// [ChartTooltipContent] panel, the [ChartLegendContent] row, and
/// [chartNumber], the one grouped-thousands formatter every chart figure on
/// the page goes through. It draws nothing itself — `chart-cartesian` and
/// `chart-polar` are the six widgets that actually paint a plot inside the
/// container this file provides.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry chartDoc = ComponentDocEntry(
  name: 'chart',
  title: 'Chart',
  description:
      'The shared chart wrapper ported from shadcn\'s ui/chart.tsx: a '
      'themed series config, the fixed-height container every plot mounts '
      'in, the hover tooltip panel, the legend row, and the one '
      'grouped-thousands number formatter every chart figure uses.',
  // registry/components/chart.json's own registryDependencies, verbatim.
  dependencies: <String>['source-foundation'],
  exports: <String>[
    'ChartText',
    'ChartSeries',
    'ChartConfig',
    'ChartScope',
    'ChartMotion',
    'ChartContainer',
    'ChartIndicator',
    'ChartTooltipItem',
    'ChartTooltipContent',
    'ChartLegendItem',
    'ChartLegendContent',
    'ChartLegendAlign',
    'chartNumber',
  ],
  sourcePath: 'lib/src/components/ui/chart.dart',
);
