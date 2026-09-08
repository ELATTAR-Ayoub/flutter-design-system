/// The radar specimens, and the list the gallery and the reference page read.
///
/// Each builder carries a `// specimen: <id>` marker directly above it. That
/// line is what `tool/chart_sources/extractor.dart` keys on, and it is the
/// only reason the code a reader copies is the code this file compiles.
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

import 'chart_data.dart';
import 'chart_ink.dart';
import 'chart_plot.dart';
import 'chart_specimen.dart';

/// One `Radar`, at the registry's own `fillOpacity`.
RadarSpec _radar(
  Color colour,
  String key, {
  double fillOpacity = 1,
  Color? stroke,
  double strokeWidth = 1,
  ChartDotSpec? dot,
}) => RadarSpec(
  dataKey: key,
  fill: colour,
  fillOpacity: fillOpacity,
  stroke: stroke,
  strokeWidth: strokeWidth,
  dot: dot,
);

Widget radarChart(
  ChartConfig config,
  List<Map<String, Object?>> data,
  List<RadarSpec> series, {
  PolarGrid? grid = const PolarGrid(),
  PolarAngleAxis? angleAxis = const PolarAngleAxis(dataKey: 'month'),
  PolarRadiusAxis? radiusAxis,
  ChartLegendSpec? legend,
  ChartMargin margin = ChartMargin.standard,
}) => plot(
  config,
  RadarChart(
    data: data,
    series: series,
    grid: grid,
    angleAxis: angleAxis,
    radiusAxis: radiusAxis,
    legend: legend,
    margin: margin,
  ),
);

// specimen: chart-radar-default
Widget radarDefault(ChartInk ink) => radarChart(
  ink.desktop,
  radarMonths,
  <RadarSpec>[_radar(ink.slot(1), 'desktop', fillOpacity: 0.6)],
);

// specimen: chart-radar-dots
Widget radarDots(ChartInk ink) => radarChart(
  ink.desktop,
  radarMonths,
  <RadarSpec>[
    _radar(ink.slot(1), 'desktop', fillOpacity: 0.6, dot: const ChartDotSpec()),
  ],
);

/// `data.ts` keeps this shape local: a six-row `{ month, desktop, mobile }`
/// set close to but not `MONTHS_DESKTOP_MOBILE` (every row differs).
const List<Map<String, Object?>> _radarLinesOnlyData = <Map<String, Object?>>[
  <String, Object?>{'month': 'January', 'desktop': 186, 'mobile': 160},
  <String, Object?>{'month': 'February', 'desktop': 185, 'mobile': 170},
  <String, Object?>{'month': 'March', 'desktop': 207, 'mobile': 180},
  <String, Object?>{'month': 'April', 'desktop': 173, 'mobile': 160},
  <String, Object?>{'month': 'May', 'desktop': 160, 'mobile': 190},
  <String, Object?>{'month': 'June', 'desktop': 174, 'mobile': 204},
];

// specimen: chart-radar-lines-only
Widget radarLinesOnly(ChartInk ink) =>
    radarChart(ink.desktopMobile, _radarLinesOnlyData, <RadarSpec>[
      _radar(
        ink.slot(1),
        'desktop',
        fillOpacity: 0,
        stroke: ink.slot(1),
        strokeWidth: 2,
      ),
      _radar(
        ink.slot(2),
        'mobile',
        fillOpacity: 0,
        stroke: ink.slot(2),
        strokeWidth: 2,
      ),
    ], grid: const PolarGrid(radialLines: false));

/// The one custom tick on the page: two figures over the month name, with the
/// separator and the caption in `--muted-foreground`.
///
/// `fontSize={13}` / `fontWeight={500}` in the registry are raw SVG props for a
/// value §0 already owns; `radar.tsx` replaces both with `text-xs`, *"the one
/// alias close enough to the registry's 13px that this system exposes without
/// inventing a new token for a one-pixel difference"*.
Widget _radarCustomTick(
  BuildContext context,
  int index,
  Offset anchor,
  TextAlign align,
) {
  final ThemeTokens theme = ThemeScope.of(context);
  final Map<String, Object?> row = monthsDesktopMobile[index];
  final TextStyle base = StyledText.styleOf(
    context,
    ChartText.xs,
    color: theme.foreground,
  );
  final TextStyle muted = base.copyWith(color: theme.mutedForeground);
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      RichText(
        TextSpan(
          style: base,
          children: <InlineSpan>[
            TextSpan(text: '${row['desktop']}'),
            TextSpan(text: '/', style: muted),
            TextSpan(text: '${row['mobile']}'),
          ],
        ),
        ChartText.xs,
      ),
      StyledText('${row['month']}', ChartText.xs, color: theme.mutedForeground),
    ],
  );
}

// specimen: chart-radar-label-custom
Widget radarLabelCustom(ChartInk ink) => radarChart(
  ink.desktopMobile,
  monthsDesktopMobile,
  <RadarSpec>[
    _radar(ink.slot(1), 'desktop', fillOpacity: 0.6),
    _radar(ink.slot(2), 'mobile'),
  ],
  angleAxis: const PolarAngleAxis(
    dataKey: 'month',
    tickBuilder: _radarCustomTick,
  ),
  margin: const ChartMargin(top: 10, right: 10, bottom: 10, left: 10),
);

/// `polarRadius`/`strokeWidth` are plot maths: the grid ring's own radius and
/// line weight: not the 8-point scale.
// specimen: chart-radar-grid-custom
Widget radarGridCustom(ChartInk ink) => radarChart(
  ink.desktop,
  radarMonths,
  <RadarSpec>[_radar(ink.slot(1), 'desktop', fillOpacity: 0.6)],
  grid: const PolarGrid(radialLines: false, polarRadius: <double>[90]),
);

/// No `PolarGrid` at all, not even a hidden one.
// specimen: chart-radar-grid-none
Widget radarGridNone(ChartInk ink) => radarChart(
  ink.desktop,
  radarMonths,
  <RadarSpec>[
    _radar(ink.slot(1), 'desktop', fillOpacity: 0.6, dot: const ChartDotSpec()),
  ],
  grid: null,
);

// specimen: chart-radar-grid-circle
Widget radarGridCircle(ChartInk ink) => radarChart(
  ink.desktop,
  radarMonths,
  <RadarSpec>[
    _radar(ink.slot(1), 'desktop', fillOpacity: 0.6, dot: const ChartDotSpec()),
  ],
  grid: const PolarGrid(gridType: PolarGridType.circle),
);

/// `data.ts` keeps this local too: only April moves (273 → 203), so it is a
/// third variant of the six-month series rather than a re-export.
const List<Map<String, Object?>> _radarCircleNoLinesData =
    <Map<String, Object?>>[
      <String, Object?>{'month': 'January', 'desktop': 186},
      <String, Object?>{'month': 'February', 'desktop': 305},
      <String, Object?>{'month': 'March', 'desktop': 237},
      <String, Object?>{'month': 'April', 'desktop': 203},
      <String, Object?>{'month': 'May', 'desktop': 209},
      <String, Object?>{'month': 'June', 'desktop': 214},
    ];

// specimen: chart-radar-grid-circle-no-lines
Widget radarGridCircleNoLines(ChartInk ink) => radarChart(
  ink.desktop,
  _radarCircleNoLinesData,
  <RadarSpec>[
    _radar(ink.slot(1), 'desktop', fillOpacity: 0.6, dot: const ChartDotSpec()),
  ],
  grid: const PolarGrid(gridType: PolarGridType.circle, radialLines: false),
);

/// `className="fill-[--color-desktop] opacity-20"` in the registry is the
/// `--color-<seriesKey>` pattern wearing Tailwind's arbitrary-property
/// shorthand: and the direct swap to a bare custom property compiled to
/// nothing at all, silently keeping recharts' `fill="none"`. `radar.tsx` found
/// it by rasterising. Here the fill is simply a colour.
// specimen: chart-radar-grid-circle-fill
Widget radarGridCircleFill(ChartInk ink) => radarChart(
  ink.desktop,
  radarMonthsFill,
  <RadarSpec>[_radar(ink.slot(1), 'desktop', fillOpacity: 0.5)],
  grid: PolarGrid(
    gridType: PolarGridType.circle,
    fills: <Color>[ink.slot(1)],
    opacity: 0.2,
  ),
);

// specimen: chart-radar-grid-fill
Widget radarGridFill(ChartInk ink) => radarChart(
  ink.desktop,
  radarMonthsFill,
  <RadarSpec>[_radar(ink.slot(1), 'desktop', fillOpacity: 0.5)],
  grid: PolarGrid(fills: <Color>[ink.slot(1)], opacity: 0.2),
);

/// Drift 7: the registry gives `mobile` no `fillOpacity` at all, so the second
/// polygon paints fully opaque over the first. Kept: it is the registry's own
/// choice, repeated identically on five variants.
List<RadarSpec> _radarPair(ChartInk ink) => <RadarSpec>[
  _radar(ink.slot(1), 'desktop', fillOpacity: 0.6),
  _radar(ink.slot(2), 'mobile'),
];

// specimen: chart-radar-multiple
Widget radarMultiple(ChartInk ink) =>
    radarChart(ink.desktopMobile, monthsDesktopMobile, _radarPair(ink));

// specimen: chart-radar-legend
Widget radarLegend(ChartInk ink) => radarChart(
  ink.desktopMobile,
  monthsDesktopMobile,
  _radarPair(ink),
  legend: const ChartLegendSpec(),
  margin: const ChartMargin(top: -40, bottom: -10),
);

/// Drift 9: structurally identical to `RadarLegend`: the registry's own
/// `chart-radar-icons` differs only in `chartConfig`.
// specimen: chart-radar-icons
Widget radarIcons(ChartInk ink) => plot(
  ChartConfig(<String, ChartSeries>{
    'desktop': ChartSeries(
      label: 'Desktop',
      color: ink.slot(1),
      icon: (BuildContext context) =>
          const Icon.lucide(Lucide.arrowDownFromLine, size: IconSize.sm),
    ),
    'mobile': ChartSeries(
      label: 'Mobile',
      color: ink.slot(2),
      icon: (BuildContext context) =>
          const Icon.lucide(Lucide.arrowUpFromLine, size: IconSize.sm),
    ),
  }),
  RadarChart(
    data: monthsDesktopMobile,
    series: _radarPair(ink),
    grid: const PolarGrid(),
    angleAxis: const PolarAngleAxis(dataKey: 'month'),
    legend: const ChartLegendSpec(),
    margin: const ChartMargin(top: -40, bottom: -10),
  ),
);

/// The first chart in the whole effort to render a `PolarRadiusAxis`'s own
/// numeric ticks: five `<text>` nodes reading `0 80 160 240 320`, and the
/// first real contact with `ui/chart.tsx`'s pre-emptive defence for that axis
/// family. `stroke="hsla(var(--foreground))"` is the same invalid-colour trap
/// as `hsl(var(--chart-N))` and becomes `--foreground`.
// specimen: chart-radar-radius
Widget radarRadius(ChartInk ink, ThemeTokens theme) => plot(
  ink.desktopMobile,
  RadarChart(
    data: monthsDesktopMobile,
    series: _radarPair(ink),
    grid: const PolarGrid(),
    angleAxis: null,
    radiusAxis: PolarRadiusAxis(
      angle: 60,
      stroke: theme.foreground,
      axisLine: false,
    ),
  ),
);

/// The radar specimens, and the list the gallery and the reference page read.
const List<ChartSpecimen> radarSpecimens = <ChartSpecimen>[
  ChartSpecimen(
    id: 'chart-radar-default',
    note: 'polygon grid, radial lines on',
    skeleton: ChartSkeletonKind.radar,
    build: _radarDefaultBuild,
  ),
  ChartSpecimen(
    id: 'chart-radar-dots',
    note: 'a dot at every vertex',
    skeleton: ChartSkeletonKind.radar,
    build: _radarDotsBuild,
  ),
  ChartSpecimen(
    id: 'chart-radar-lines-only',
    note: 'stroke, no fill',
    skeleton: ChartSkeletonKind.radar,
    build: _radarLinesOnlyBuild,
  ),
  ChartSpecimen(
    id: 'chart-radar-label-custom',
    note: 'PolarAngleAxis tick as a render function',
    skeleton: ChartSkeletonKind.radar,
    build: _radarLabelCustomBuild,
  ),
  ChartSpecimen(
    id: 'chart-radar-grid-custom',
    note: 'PolarGrid with its own stroke',
    skeleton: ChartSkeletonKind.radar,
    build: _radarGridCustomBuild,
  ),
  ChartSpecimen(
    id: 'chart-radar-grid-none',
    note: 'PolarGrid omitted',
    skeleton: ChartSkeletonKind.radar,
    build: _radarGridNoneBuild,
  ),
  ChartSpecimen(
    id: 'chart-radar-grid-circle',
    note: 'gridType=circle',
    skeleton: ChartSkeletonKind.radar,
    build: _radarGridCircleBuild,
  ),
  ChartSpecimen(
    id: 'chart-radar-grid-circle-no-lines',
    note: 'circle grid, radialLines={false}',
    skeleton: ChartSkeletonKind.radar,
    build: _radarGridCircleNoLinesBuild,
  ),
  ChartSpecimen(
    id: 'chart-radar-grid-circle-fill',
    note: 'circle grid with a fill',
    skeleton: ChartSkeletonKind.radar,
    build: _radarGridCircleFillBuild,
  ),
  ChartSpecimen(
    id: 'chart-radar-grid-fill',
    note: 'polygon grid with a fill',
    skeleton: ChartSkeletonKind.radar,
    build: _radarGridFillBuild,
  ),
  ChartSpecimen(
    id: 'chart-radar-multiple',
    note: 'two profiles overlaid',
    skeleton: ChartSkeletonKind.radar,
    build: _radarMultipleBuild,
  ),
  ChartSpecimen(
    id: 'chart-radar-legend',
    note: 'ChartLegendContent under the web',
    skeleton: ChartSkeletonKind.radar,
    build: _radarLegendBuild,
  ),
  ChartSpecimen(
    id: 'chart-radar-icons',
    note: 'config icons in the legend',
    skeleton: ChartSkeletonKind.radar,
    build: _radarIconsBuild,
  ),
  ChartSpecimen(
    id: 'chart-radar-radius',
    note: 'PolarRadiusAxis shown',
    skeleton: ChartSkeletonKind.radar,
    build: _radarRadiusBuild,
  ),
];

Widget _radarDefaultBuild(BuildContext context, ChartInk ink) =>
    radarDefault(ink);
Widget _radarDotsBuild(BuildContext context, ChartInk ink) => radarDots(ink);
Widget _radarLinesOnlyBuild(BuildContext context, ChartInk ink) =>
    radarLinesOnly(ink);
Widget _radarLabelCustomBuild(BuildContext context, ChartInk ink) =>
    radarLabelCustom(ink);
Widget _radarGridCustomBuild(BuildContext context, ChartInk ink) =>
    radarGridCustom(ink);
Widget _radarGridNoneBuild(BuildContext context, ChartInk ink) =>
    radarGridNone(ink);
Widget _radarGridCircleBuild(BuildContext context, ChartInk ink) =>
    radarGridCircle(ink);
Widget _radarGridCircleNoLinesBuild(BuildContext context, ChartInk ink) =>
    radarGridCircleNoLines(ink);
Widget _radarGridCircleFillBuild(BuildContext context, ChartInk ink) =>
    radarGridCircleFill(ink);
Widget _radarGridFillBuild(BuildContext context, ChartInk ink) =>
    radarGridFill(ink);
Widget _radarMultipleBuild(BuildContext context, ChartInk ink) =>
    radarMultiple(ink);
Widget _radarLegendBuild(BuildContext context, ChartInk ink) =>
    radarLegend(ink);
Widget _radarIconsBuild(BuildContext context, ChartInk ink) =>
    radarIcons(ink);
Widget _radarRadiusBuild(BuildContext context, ChartInk ink) =>
    radarRadius(ink, ThemeScope.of(context));
