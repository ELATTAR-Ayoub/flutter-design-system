/// `/design-system/components/base/charts`: seventy registry variants, two
/// discrete families, and the one page in this system whose motion has to be
/// read out of the stylesheet rather than written as a class.
///
/// ## What this page is
///
/// The reference builds it out of eleven files: `components/ui/chart.tsx` (the
/// shadcn wrapper), `components/space/chart-motion.ts` (the timing hook) and nine
/// modules under `components/space/charts/`, `data.ts`, `area`, `bar`, `line`,
/// `pie`, `radar`, `radial`, `tooltip`, `state`, `skeletons`, plus the two
/// hand-built figures `unit-activity` and `conversion-funnel`. The wrapper and
/// the drawing engine are ported into the package (`chart.dart`,
/// `chart_geometry.dart`, `chart_cartesian.dart`, `chart_polar.dart`); every
/// **specimen** lives here, because that is where the reference puts it: the
/// `components/space/` tree is this file's counterpart, exactly as `kit.dart` is
/// `components/space/kit.tsx`'s.
///
/// ## The three sweeps every family file carries, and what they became
///
/// `area.tsx`'s header states them once for all seventy:
///
///  1. `hsl(var(--chart-N))` → `var(--color-chart-N)`. The registry's pre-v4
///     spelling; `--chart-N` holds a whole colour here, so `hsl()` around it is
///     invalid and the series paints nothing. In Dart the tokens are
///     [ThemeTokens.chart1] … `chart5`, read off the theme.
///  2. `var(--color-<seriesKey>)` → the direct chart tokens. shadcn's
///     `ChartStyle` mints a per-container custom property at runtime, which
///     exists in the browser and nowhere in source; `check:refs` fails it.
///     There is no `ChartStyle` here for the same reason the page's own note
///     gives: the five tokens are already declared once per theme.
///  3. Every animated element takes `{...useChartMotion()}`. Here that is
///     [ChartMotion], and the caller never types a duration.
///
/// ## Drift register: recorded, shipped as written
///
///  1. **The five token descriptions do not match the tokens.** `CHART_TOKENS`
///     calls `--chart-2` *"Action, one step away. Dark in light mode, bright in
///     dark mode"* and `--chart-4` *"Value. The lime ramp enters here"* —
///     but `globals.css` gives `--chart-2: var(--color-value-dark)` in light
///     and `var(--color-value)` in dark, i.e. the **value** ramp, and
///     `--chart-4: var(--color-action-dark)` in light, i.e. the **action**
///     ramp. The prose has 2/3 and 4/5 the wrong way round. Copy ships as
///     written; the swatches render the real tokens, so the page contradicts
///     itself on screen exactly as the reference does.
///  2. **`aspect-video` is in `ChartContainer`'s class list and never
///     applies**, `PLOT`'s `h-64` beats it at all seventy call sites.
///     Recorded, not implemented.
///  3. **`AreaGradient`'s two `<linearGradient>`s are declared and one of them
///     is overridden.** Both `Area`s name a gradient `fill` **and** a
///     `fillOpacity={0.4}`, so the gradient's own 0.8→0.1 stops are multiplied
///     by 0.4 rather than replaced. `AreaInteractive`, the other gradient
///     variant, sets no `fillOpacity` at all. Reproduced.
///  4. **`PieDonut`'s note says "innerRadius as a percentage" and the value is
///     `60`, a pixel count.** `pie.tsx` explains it kept the registry's pixel
///     radius on purpose; the panel's own note was never updated.
///  5. **`data.ts` describes `pie-donut-text` as "+12 firefox / +100 other"
///     and the dataset is +100 on both.** `pie.tsx` flags this in its own
///     comment and does not reconcile it. Neither does this.
///  6. **`radial-shape`'s note says "a custom activeShape" and the vendored
///     source has none**: it is `chart-radial-text` with a different sweep and
///     a different number. `radial.tsx` flags it; the note ships as written.
///  7. **`RadarMultiple` and its four siblings paint the second polygon fully
///     opaque**, because the registry gives `mobile` no `fillOpacity`. The page
///     text one section down says two overlapping radars need both fills
///     translucent. Both ship.
///  8. **`PieLegend`'s legend keys are months read through a browser config.**
///     `PieLegend` passes `nameKey="browser"` over `BROWSERS`, which is right;
///     `PieInteractive`'s `Select` reads `PIE_MONTHS_CONFIG`. Two configs, one
///     family, and the legend variant is the only one that needs the key.
///  9. **`RadarLegend` and `RadarIcons` are the same chart.** The registry's
///     `chart-radar-icons` differs from `chart-radar-legend` only in
///     `chartConfig`, so the two panels are identical but for the two glyphs in
///     the legend.
/// 10. **Three interactive strips, three different heights.** `Area` and `Pie`
///     put a `Select` above the plot (+60px of panel), `Bar` and `Line` put a
///     pair of `Stat` tiles (+94.39px). CSS grid then lifts each strip's
///     row-mate to match, which is why `Axes` and `Negative` and `Custom label`
///     are taller than their own content: measured 393.39 / 453.39 / 487.78.
/// 11. **The `states` section demonstrates nothing of its own.** It is three
///     blocks of prose about the switch every other panel already carries.
/// 12. **`ChartStates` opens on `ready`, so nothing on the page is ever seen in
///     its loading state unless a reader presses for it**: which is what makes
///     drift 10's layout jump invisible until you cycle all three.
///
/// ## Divergence, flagged
///
/// **The entrance easing is deliberately wrong, and being right would be the
/// bug.** `chart-motion.ts` documents at length that recharts' types take five
/// easing keywords and no `cubic-bezier`, so `--ease-out` could not be threaded
/// through and the keyword `ease-out` was passed instead: a different curve,
/// documented on the page rather than hidden. The port has the token in hand
/// and uses CSS's `ease-out` anyway ([ChartMotion.curve]); reproducing the
/// system's own `--ease-out` here would make these charts move differently from
/// the reference's.
library;

import 'dart:math' as math;

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

import '../charts/chart_data.dart';
import '../charts/chart_ink.dart';
import '../charts/chart_specimen.dart';
import '../charts/chart_states.dart';
import '../kit.dart';
import '../nav.dart';
import '../token_swatch.dart';

/// `max-w-3xl`, `--container-3xl`, 48rem. Every prose block in the Animation
/// section.
// allow-hardcoded: framework container scale with no token to read it from.
const double _measure3xl = 768;

/// `min-w-xl`, `--container-xl`, 36rem. The unit-activity scroller's floor.
// allow-hardcoded: framework container scale with no token to read it from.
const double _measureXl = 576;

/// `MetaItem` is a record typedef, so a plain string value has to be wrapped
/// in the [InlineSpan] the row renders.
MetaItem _meta(String k, String v) => (k: k, v: TextSpan(text: v));

/* ── Formatters ──────────────────────────────────────────────────────────── */

/// `value.slice(0, 3)`: the three-letter month every cartesian axis prints.
String _month3(Object? value) => '$value'.substring(0, 3);

/// `new Date(v).toLocaleDateString("en-US", { month: "short", day: "numeric" })`.
String _shortDate(Object? value) {
  final DateTime d = DateTime.parse('$value');
  return '${DateFormat.monthsShort[d.month - 1]} ${d.day}';
}

/// …with `year: "numeric"`: the two interactive tooltips.
String _shortDateYear(Object? value) {
  final DateTime d = DateTime.parse('$value');
  return '${DateFormat.monthsShort[d.month - 1]} ${d.day}, ${d.year}';
}

/// `{ weekday: "short" }`: the tooltip family's whole X axis.
///
/// `DateFormat` carries the long names and the narrow ones; en-US's short
/// weekday is the long name's first three letters, so this derives rather than
/// declaring a seventh list.
String _weekdayShort(Object? value) {
  final DateTime d = DateTime.parse('$value');
  return DateFormat.weekdaysLong[d.weekday % 7].substring(0, 3);
}

/// `{ day: "numeric", month: "long", year: "numeric" }`, `TooltipLabelFormatter`.
String _longDate(Object? value) {
  final DateTime d = DateTime.parse('$value');
  return '${DateFormat.monthsLong[d.month - 1]} ${d.day}, ${d.year}';
}

/// The bar's corner radius, off the ladder.
///
/// `bar.tsx` reads `--radius-sm` from the live stylesheet rather than typing
/// the registry's 8 / 5 / 4, and says why at length: *"§0's radius family, 2 ·
/// 6 · 10 · 12 · 16 · 20 · 24 · 999: has no 8, no 5 and no 4 in it… The
/// registry's 8 / 5 / 4 are not a considered distinction: they are the same
/// bar drawn three ways across ten files: and 6px is where they average."*
/// The port names the rung instead of reading it, which is the same single
/// source of truth with one fewer indirection.
const double _barRadius = Radii.sm;

/// `[0, 0, r, r]`: the bottom of a stack.
const List<double> _radiiBottom = <double>[0, 0, _barRadius, _barRadius];

/// `[r, r, 0, 0]`: the top of one.
const List<double> _radiiTop = <double>[_barRadius, _barRadius, 0, 0];

/// All four corners.
const List<double> _radiiAll = <double>[
  _barRadius,
  _barRadius,
  _barRadius,
  _barRadius,
];

/// `radial.tsx`'s two rungs. *"`10` is exactly the `md` rung already, on a
/// 30px-thick single ring… `5` is not a rung at all and moves to `sm` (6), the
/// same rung every bar corner in this system already takes."*
const double _ringRadius = Radii.md;
const double _stackRadius = Radii.sm;

/* ── Area, `components/space/charts/area.tsx` ──────────────────────────────── */

/// The plot, in the container every specimen shares.
Widget _plot(ChartConfig config, Widget chart) =>
    ChartContainer(config: config, child: chart);

/// The X axis nine of the ten area variants share, byte for byte.
ChartAxis _monthAxis() => const ChartAxis(
  dataKey: 'month',
  tickLine: false,
  axisLine: false,
  tickMargin: 8,
  tickFormatter: _month3,
);

/// `chart-area-default`: one series, natural curve.
Widget _areaDefault(ChartInk ink) => _plot(
  ink.desktop,
  CartesianChart(
    data: monthsDesktop,
    // Plot maths, not the 8-point scale: recharts' own margin box.
    margin: const ChartMargin(left: 12, right: 12),
    grid: const ChartGrid(vertical: false),
    xAxis: _monthAxis(),
    tooltip: const ChartTooltipSpec(
      cursor: false,
      indicator: ChartIndicator.line,
    ),
    series: <ChartSeriesSpec>[
      ChartSeriesSpec(
        kind: ChartSeriesKind.area,
        dataKey: 'desktop',
        curve: CurveType.natural,
        fill: ink.slot(1),
        fillOpacity: 0.4,
        stroke: ink.slot(1),
      ),
    ],
  ),
);

Widget _areaLinear(ChartInk ink) => _plot(
  ink.desktop,
  CartesianChart(
    data: monthsDesktop,
    margin: const ChartMargin(left: 12, right: 12),
    grid: const ChartGrid(vertical: false),
    xAxis: _monthAxis(),
    tooltip: const ChartTooltipSpec(cursor: false, hideLabel: true),
    series: <ChartSeriesSpec>[
      ChartSeriesSpec(
        kind: ChartSeriesKind.area,
        dataKey: 'desktop',
        fill: ink.slot(1),
        fillOpacity: 0.4,
        stroke: ink.slot(1),
      ),
    ],
  ),
);

/// The registry's `chartConfig.desktop.icon` is `Activity`, unused by this
/// variant's own markup but read by the tooltip's indicator slot: the gap
/// `area.tsx` documents, where the config's icon bypasses `Icon` entirely.
/// Flutter's builder slot has no such constraint, so it goes through [Icon].
Widget _areaStep(ChartInk ink) => _plot(
  ChartConfig(<String, ChartSeries>{
    'desktop': ChartSeries(
      label: 'Desktop',
      color: ink.slot(1),
      icon: (BuildContext context) =>
          const Icon.lucide(Lucide.activity, size: IconSize.xs),
    ),
  }),
  CartesianChart(
    data: monthsDesktop,
    margin: const ChartMargin(left: 12, right: 12),
    grid: const ChartGrid(vertical: false),
    xAxis: _monthAxis(),
    tooltip: const ChartTooltipSpec(cursor: false, hideLabel: true),
    series: <ChartSeriesSpec>[
      ChartSeriesSpec(
        kind: ChartSeriesKind.area,
        dataKey: 'desktop',
        curve: CurveType.step,
        fill: ink.slot(1),
        fillOpacity: 0.4,
        stroke: ink.slot(1),
      ),
    ],
  ),
);

/// The two stacked areas six variants build on. `mobile` is declared first, so
/// it is drawn at the bottom of the stack.
List<ChartSeriesSpec> _stackedAreas(ChartInk ink) => <ChartSeriesSpec>[
  ChartSeriesSpec(
    kind: ChartSeriesKind.area,
    dataKey: 'mobile',
    curve: CurveType.natural,
    stackId: 'a',
    fill: ink.slot(2),
    fillOpacity: 0.4,
    stroke: ink.slot(2),
  ),
  ChartSeriesSpec(
    kind: ChartSeriesKind.area,
    dataKey: 'desktop',
    curve: CurveType.natural,
    stackId: 'a',
    fill: ink.slot(1),
    fillOpacity: 0.4,
    stroke: ink.slot(1),
  ),
];

Widget _areaStacked(ChartInk ink) => _plot(
  ink.desktopMobile,
  CartesianChart(
    data: monthsDesktopMobile,
    margin: const ChartMargin(left: 12, right: 12),
    grid: const ChartGrid(vertical: false),
    xAxis: _monthAxis(),
    tooltip: const ChartTooltipSpec(cursor: false),
    series: _stackedAreas(ink),
  ),
);

/// `data.ts` deliberately does not carry this shape, `MONTHS_DESKTOP_MOBILE`
/// plus an `other` series exists for exactly one variant, so it stays local
/// rather than becoming a ninth shared export.
const List<Map<String, Object?>> _areaExpandData = <Map<String, Object?>>[
  <String, Object?>{
    'month': 'January',
    'desktop': 186,
    'mobile': 80,
    'other': 45,
  },
  <String, Object?>{
    'month': 'February',
    'desktop': 305,
    'mobile': 200,
    'other': 100,
  },
  <String, Object?>{
    'month': 'March',
    'desktop': 237,
    'mobile': 120,
    'other': 150,
  },
  <String, Object?>{
    'month': 'April',
    'desktop': 73,
    'mobile': 190,
    'other': 50,
  },
  <String, Object?>{
    'month': 'May',
    'desktop': 209,
    'mobile': 130,
    'other': 100,
  },
  <String, Object?>{
    'month': 'June',
    'desktop': 214,
    'mobile': 140,
    'other': 160,
  },
];

Widget _areaStackedExpand(ChartInk ink) => _plot(
  ink.desktopMobile.plus(<String, ChartSeries>{
    'other': ChartSeries(label: 'Other', color: ink.slot(3)),
  }),
  CartesianChart(
    data: _areaExpandData,
    margin: const ChartMargin(left: 12, right: 12, top: 12),
    stackOffsetExpand: true,
    grid: const ChartGrid(vertical: false),
    xAxis: _monthAxis(),
    tooltip: const ChartTooltipSpec(
      cursor: false,
      indicator: ChartIndicator.line,
    ),
    series: <ChartSeriesSpec>[
      ChartSeriesSpec(
        kind: ChartSeriesKind.area,
        dataKey: 'other',
        curve: CurveType.natural,
        stackId: 'a',
        fill: ink.slot(3),
        fillOpacity: 0.1,
        stroke: ink.slot(3),
      ),
      ..._stackedAreas(ink),
    ],
  ),
);

Widget _areaLegend(ChartInk ink) => _plot(
  ink.desktopMobile,
  CartesianChart(
    data: monthsDesktopMobile,
    margin: const ChartMargin(left: 12, right: 12),
    grid: const ChartGrid(vertical: false),
    xAxis: _monthAxis(),
    tooltip: const ChartTooltipSpec(
      cursor: false,
      indicator: ChartIndicator.line,
    ),
    legend: const ChartLegendSpec(),
    series: _stackedAreas(ink),
  ),
);

/// `TrendingDown` on `desktop` and `TrendingUp` on `mobile` is the registry's
/// own pairing, not a claim these charts render onto that shape.
Widget _areaIcons(ChartInk ink) => _plot(
  ChartConfig(<String, ChartSeries>{
    'desktop': ChartSeries(
      label: 'Desktop',
      color: ink.slot(1),
      icon: (BuildContext context) =>
          const Icon.lucide(Lucide.trendingDown, size: IconSize.sm),
    ),
    'mobile': ChartSeries(
      label: 'Mobile',
      color: ink.slot(2),
      icon: (BuildContext context) =>
          const Icon.lucide(Lucide.trendingUp, size: IconSize.sm),
    ),
  }),
  CartesianChart(
    data: monthsDesktopMobile,
    margin: const ChartMargin(left: 12, right: 12),
    grid: const ChartGrid(vertical: false),
    xAxis: _monthAxis(),
    tooltip: const ChartTooltipSpec(
      cursor: false,
      indicator: ChartIndicator.line,
    ),
    legend: const ChartLegendSpec(),
    series: _stackedAreas(ink),
  ),
);

/// A `<linearGradient>` in `<defs>`, both stops on the token.
///
/// Drift 3: the `fillOpacity={0.4}` beside it multiplies the gradient's own
/// 0.8 → 0.1 stops rather than replacing them, so what actually paints on
/// `AreaGradient` is 0.32 → 0.04. `AreaInteractive`, the other gradient
/// variant, sets no `fillOpacity` at all and gets the declared stops.
LinearGradient _gradientFor(Color colour, {double opacity = 1}) =>
    LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: const <double>[0.05, 0.95],
      colors: <Color>[
        colour.withValues(alpha: 0.8 * opacity),
        colour.withValues(alpha: 0.1 * opacity),
      ],
    );

Widget _areaGradient(ChartInk ink) => _plot(
  ink.desktopMobile,
  CartesianChart(
    data: monthsDesktopMobile,
    margin: const ChartMargin(left: 12, right: 12),
    grid: const ChartGrid(vertical: false),
    xAxis: _monthAxis(),
    tooltip: const ChartTooltipSpec(cursor: false),
    series: <ChartSeriesSpec>[
      ChartSeriesSpec(
        kind: ChartSeriesKind.area,
        dataKey: 'mobile',
        curve: CurveType.natural,
        stackId: 'a',
        gradient: _gradientFor(ink.slot(2), opacity: 0.4),
        stroke: ink.slot(2),
      ),
      ChartSeriesSpec(
        kind: ChartSeriesKind.area,
        dataKey: 'desktop',
        curve: CurveType.natural,
        stackId: 'a',
        gradient: _gradientFor(ink.slot(1), opacity: 0.4),
        stroke: ink.slot(1),
      ),
    ],
  ),
);

/// Both axes labelled: and the one chart on the page with a negative margin,
/// which claws 20 of the Y axis's 60px back out of the plot's left edge.
Widget _areaAxes(ChartInk ink) => _plot(
  ink.desktopMobile,
  CartesianChart(
    data: monthsDesktopMobile,
    margin: const ChartMargin(left: -20, right: 12),
    grid: const ChartGrid(vertical: false),
    xAxis: _monthAxis(),
    yAxis: const ChartAxis(
      type: ChartAxisType.number,
      tickLine: false,
      axisLine: false,
      tickMargin: 8,
      tickCount: 3,
    ),
    tooltip: const ChartTooltipSpec(cursor: false),
    series: _stackedAreas(ink),
  ),
);

/// The range picker and the 91-day plot it filters.
///
/// The registry sits this `Select` in a `CardHeader`. Stripped of `Card` it
/// used to render inline above the plot, inside the component: which put it
/// inside the swapped slot, where it exists only in `ready`, and the panel then
/// grew 60px the moment you left Loading or Empty: 393.39 → 453.39, measured.
/// So the strip is hoisted out of the slot and the state comes with it.
class _AreaInteractive extends StatefulWidget {
  const _AreaInteractive({required this.ink, required this.child});

  final ChartInk ink;

  /// The keyed slot, rendered exactly once and below the strip.
  final Widget child;

  /// The registry's own reference date.
  static final DateTime reference = DateTime(2024, 6, 30);

  /// Which range the plot draws. Defaulted, not nullable, so the chart still
  /// renders a real 90-day series if it is ever mounted without its strip.
  static const String defaultRange = '90d';

  static List<Map<String, Object?>> filtered(String range) {
    final int days = switch (range) {
      '30d' => 30,
      '7d' => 7,
      _ => 90,
    };
    final DateTime start = reference.subtract(Duration(days: days));
    return <Map<String, Object?>>[
      for (final Map<String, Object?> row in dailyVisits)
        if (!DateTime.parse('${row['date']}').isBefore(start)) row,
    ];
  }

  @override
  State<_AreaInteractive> createState() => _AreaInteractiveState();
}

class _AreaInteractiveState extends State<_AreaInteractive> {
  String _range = _AreaInteractive.defaultRange;

  @override
  Widget build(BuildContext context) => _RangeStrip(
    value: _range,
    onChanged: (String next) => setState(() => _range = next),
    child: _AreaInteractiveRange(range: _range, child: widget.child),
  );
}

/// The context the strip hands down through the keyed slot.
class _AreaInteractiveRange extends InheritedWidget {
  const _AreaInteractiveRange({required this.range, required super.child});

  final String range;

  static String of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<_AreaInteractiveRange>()
          ?.range ??
      _AreaInteractive.defaultRange;

  @override
  bool updateShouldNotify(_AreaInteractiveRange old) => old.range != range;
}

/// The plot only: no wrapper, so its footprint is `PLOT` exactly like the
/// other nine.
Widget _areaInteractive(BuildContext context, ChartInk ink) => _plot(
  ink.desktopMobile.plus(<String, ChartSeries>{
    'visitors': const ChartSeries(label: 'Visitors'),
  }),
  CartesianChart(
    data: _AreaInteractive.filtered(_AreaInteractiveRange.of(context)),
    grid: const ChartGrid(vertical: false),
    xAxis: const ChartAxis(
      dataKey: 'date',
      tickLine: false,
      axisLine: false,
      tickMargin: 8,
      minTickGap: 32,
      tickFormatter: _shortDate,
    ),
    tooltip: const ChartTooltipSpec(
      cursor: false,
      labelFormatter: _shortDateLabel,
    ),
    legend: const ChartLegendSpec(),
    series: <ChartSeriesSpec>[
      ChartSeriesSpec(
        kind: ChartSeriesKind.area,
        dataKey: 'mobile',
        curve: CurveType.natural,
        stackId: 'a',
        gradient: _gradientFor(ink.slot(2)),
        stroke: ink.slot(2),
      ),
      ChartSeriesSpec(
        kind: ChartSeriesKind.area,
        dataKey: 'desktop',
        curve: CurveType.natural,
        stackId: 'a',
        gradient: _gradientFor(ink.slot(1)),
        stroke: ink.slot(1),
      ),
    ],
  ),
);

String _shortDateLabel(String label, List<ChartTooltipItem> items) =>
    _shortDate(label);

String _shortDateYearLabel(String label, List<ChartTooltipItem> items) =>
    _shortDateYear(label);

String _longDateLabel(String label, List<ChartTooltipItem> items) =>
    _longDate(label);

/// The `Select` strip, rendering unconditionally with `children` exactly once —
/// the two obligations `state.tsx` puts on anything passed to `controls`.
class _RangeStrip extends StatelessWidget {
  const _RangeStrip({
    required this.value,
    required this.onChanged,
    required this.child,
    this.width,
    this.label = 'Select a range',
    this.placeholder = 'Last 3 months',
    this.options = _rangeOptions,
  });

  final String value;
  final ValueChanged<String> onChanged;
  final Widget child;
  final double? width;
  final String label;
  final String placeholder;
  final List<SelectOption<String>> options;

  /// `w-40` on the area strip.
  static double get rangeWidth => space(40);

  /// `w-36` on the pie strip.
  static double get monthWidth => space(36);

  static const List<SelectOption<String>> _rangeOptions =
      <SelectOption<String>>[
        SelectOption<String>(value: '90d', label: 'Last 3 months'),
        SelectOption<String>(value: '30d', label: 'Last 30 days'),
        SelectOption<String>(value: '7d', label: 'Last 7 days'),
      ];

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      Align(
        alignment: Alignment.centerRight,
        child: Select<String>(
          width: width ?? rangeWidth,
          label: label,
          placeholder: placeholder,
          value: value,
          onChanged: onChanged,
          options: options,
        ),
      ),
      // `mb-5`.
      SizedBox(height: space(5)),
      child,
    ],
  );
}

/* ── Bar, `components/space/charts/bar.tsx` ────────────────────────────────── */

/// The X axis six of the ten bar variants share (`tickMargin` 10, not 8).
const ChartAxis _barMonthAxis = ChartAxis(
  dataKey: 'month',
  tickLine: false,
  axisLine: false,
  tickMargin: 10,
  tickFormatter: _month3,
);

Widget _barDefault(ChartInk ink) => _plot(
  ink.desktop,
  CartesianChart(
    data: monthsDesktop,
    grid: const ChartGrid(vertical: false),
    xAxis: _barMonthAxis,
    tooltip: const ChartTooltipSpec(cursor: false, hideLabel: true),
    series: <ChartSeriesSpec>[
      ChartSeriesSpec(
        kind: ChartSeriesKind.bar,
        dataKey: 'desktop',
        fill: ink.slot(1),
        radii: _radiiAll,
      ),
    ],
  ),
);

/// `layout="vertical"`, `YAxis type="category"`: the same chart rotated, and
/// the one the page warns *"reads backwards until you have hit it once"*.
Widget _barHorizontal(ChartInk ink) => _plot(
  ink.desktop,
  CartesianChart(
    data: monthsDesktop,
    layout: ChartLayout.vertical,
    margin: const ChartMargin(left: -20),
    xAxis: const ChartAxis(
      type: ChartAxisType.number,
      dataKey: 'desktop',
      hide: true,
    ),
    yAxis: const ChartAxis(
      dataKey: 'month',
      tickLine: false,
      axisLine: false,
      tickMargin: 10,
      tickFormatter: _month3,
    ),
    tooltip: const ChartTooltipSpec(cursor: false, hideLabel: true),
    series: <ChartSeriesSpec>[
      ChartSeriesSpec(
        kind: ChartSeriesKind.bar,
        dataKey: 'desktop',
        fill: ink.slot(1),
        radii: _radiiAll,
      ),
    ],
  ),
);

Widget _barMultiple(ChartInk ink) => _plot(
  ink.desktopMobile,
  CartesianChart(
    data: monthsDesktopMobile,
    grid: const ChartGrid(vertical: false),
    xAxis: _barMonthAxis,
    tooltip: const ChartTooltipSpec(
      cursor: false,
      indicator: ChartIndicator.dashed,
    ),
    series: <ChartSeriesSpec>[
      ChartSeriesSpec(
        kind: ChartSeriesKind.bar,
        dataKey: 'desktop',
        fill: ink.slot(1),
        radii: _radiiAll,
      ),
      ChartSeriesSpec(
        kind: ChartSeriesKind.bar,
        dataKey: 'mobile',
        fill: ink.slot(2),
        radii: _radiiAll,
      ),
    ],
  ),
);

/// Two bars sharing a `stackId`. Only the zeros' position is geometry: the
/// radius itself is `--radius-sm`, one rung for the whole family.
Widget _barStacked(ChartInk ink) => _plot(
  ink.desktopMobile,
  CartesianChart(
    data: monthsDesktopMobile,
    grid: const ChartGrid(vertical: false),
    xAxis: _barMonthAxis,
    tooltip: const ChartTooltipSpec(hideLabel: true),
    legend: const ChartLegendSpec(),
    series: <ChartSeriesSpec>[
      ChartSeriesSpec(
        kind: ChartSeriesKind.bar,
        dataKey: 'desktop',
        stackId: 'a',
        fill: ink.slot(1),
        radii: _radiiBottom,
      ),
      ChartSeriesSpec(
        kind: ChartSeriesKind.bar,
        dataKey: 'mobile',
        stackId: 'a',
        fill: ink.slot(2),
        radii: _radiiTop,
      ),
    ],
  ),
);

/// The registry sets `fontSize={12}` on this `LabelList`: a raw SVG number
/// for a value the type scale already owns. `text-xs` reaches the same size
/// through CSS; here it is [ChartText.xs], which is the same statement.
Widget _barLabel(ChartInk ink, ThemeTokens theme) => _plot(
  ink.desktop,
  CartesianChart(
    data: monthsDesktop,
    margin: const ChartMargin(top: 20),
    grid: const ChartGrid(vertical: false),
    xAxis: _barMonthAxis,
    tooltip: const ChartTooltipSpec(cursor: false, hideLabel: true),
    series: <ChartSeriesSpec>[
      ChartSeriesSpec(
        kind: ChartSeriesKind.bar,
        dataKey: 'desktop',
        fill: ink.slot(1),
        radii: _radiiAll,
        labels: <ChartLabelList>[
          ChartLabelList(offset: 12, color: theme.foreground),
        ],
      ),
    ],
  ),
);

/// The registry mints a per-container `--color-label` so the in-bar month text
/// can contrast against the bar's own fill; `bar.tsx` replaces it with
/// `fill-background`, which is a themed utility rather than a runtime mint.
Widget _barLabelCustom(ChartInk ink, ThemeTokens theme) => _plot(
  ink.desktop,
  CartesianChart(
    data: monthsDesktop,
    layout: ChartLayout.vertical,
    margin: const ChartMargin(right: 16),
    grid: const ChartGrid(horizontal: false),
    yAxis: const ChartAxis(
      dataKey: 'month',
      tickLine: false,
      axisLine: false,
      hide: true,
    ),
    xAxis: const ChartAxis(
      dataKey: 'desktop',
      type: ChartAxisType.number,
      hide: true,
    ),
    tooltip: const ChartTooltipSpec(
      cursor: false,
      indicator: ChartIndicator.line,
    ),
    series: <ChartSeriesSpec>[
      ChartSeriesSpec(
        kind: ChartSeriesKind.bar,
        dataKey: 'desktop',
        fill: ink.slot(1),
        radii: _radiiAll,
        labels: <ChartLabelList>[
          ChartLabelList(
            dataKey: 'month',
            position: ChartLabelPosition.insideLeft,
            offset: 8,
            color: theme.background,
          ),
          ChartLabelList(
            dataKey: 'desktop',
            position: ChartLabelPosition.right,
            offset: 8,
            color: theme.foreground,
          ),
        ],
      ),
    ],
  ),
);

/// One `Bar`, a colour per datum. No `fill` on the series: each row in
/// `BROWSERS` already carries its own.
Widget _barMixed(ChartInk ink) => _plot(
  ink.browser,
  CartesianChart(
    data: browsers,
    layout: ChartLayout.vertical,
    margin: const ChartMargin(left: 0),
    yAxis: ChartAxis(
      dataKey: 'browser',
      tickLine: false,
      axisLine: false,
      tickMargin: 10,
      tickFormatter: (Object? v) => _browserLabel('$v'),
    ),
    xAxis: const ChartAxis(
      dataKey: 'visitors',
      type: ChartAxisType.number,
      hide: true,
    ),
    tooltip: const ChartTooltipSpec(cursor: false, hideLabel: true),
    series: <ChartSeriesSpec>[
      ChartSeriesSpec(
        kind: ChartSeriesKind.bar,
        dataKey: 'visitors',
        radii: _radiiAll,
        cellFills: <Color>[
          for (final Map<String, Object?> row in browsers) ink.ofRow(row),
        ],
      ),
    ],
  ),
);

/// `BROWSER_CONFIG`'s labels, as a formatter: the registry writes the same
/// lookup inline on three axes.
String _browserLabel(String key) => switch (key) {
  'chrome' => 'Chrome',
  'safari' => 'Safari',
  'firefox' => 'Firefox',
  'edge' => 'Edge',
  'other' => 'Other',
  _ => key,
};

/// `data.ts` names this shape as one of the eight kept local: `BROWSERS`
/// reordered, so the "active" third bar lands on firefox rather than chrome.
const List<Map<String, Object?>> _barActiveData = <Map<String, Object?>>[
  <String, Object?>{'browser': 'chrome', 'visitors': 187, 'slot': 1},
  <String, Object?>{'browser': 'safari', 'visitors': 200, 'slot': 2},
  <String, Object?>{'browser': 'firefox', 'visitors': 275, 'slot': 3},
  <String, Object?>{'browser': 'edge', 'visitors': 173, 'slot': 4},
  <String, Object?>{'browser': 'other', 'visitors': 90, 'slot': 5},
];

/// `activeIndex` moved off `Bar` between recharts v2 and v3: it is now
/// `Tooltip`'s `defaultIndex`, which is why this specimen shows a panel with no
/// pointer anywhere near it.
Widget _barActive(ChartInk ink) => _plot(
  ink.browser,
  CartesianChart(
    data: _barActiveData,
    grid: const ChartGrid(vertical: false),
    xAxis: ChartAxis(
      dataKey: 'browser',
      tickLine: false,
      axisLine: false,
      tickMargin: 10,
      tickFormatter: (Object? v) => _browserLabel('$v'),
    ),
    tooltip: const ChartTooltipSpec(
      cursor: false,
      defaultIndex: 2,
      hideLabel: true,
    ),
    series: <ChartSeriesSpec>[
      ChartSeriesSpec(
        kind: ChartSeriesKind.bar,
        dataKey: 'visitors',
        radii: _radiiAll,
        cellFills: <Color>[
          for (final Map<String, Object?> row in _barActiveData) ink.ofRow(row),
        ],
      ),
    ],
  ),
);

/// Kept local per `data.ts`, `{ month, visitors }` with two negative rows.
const List<Map<String, Object?>> _barNegativeData = <Map<String, Object?>>[
  <String, Object?>{'month': 'January', 'visitors': 186},
  <String, Object?>{'month': 'February', 'visitors': 205},
  <String, Object?>{'month': 'March', 'visitors': -207},
  <String, Object?>{'month': 'April', 'visitors': 173},
  <String, Object?>{'month': 'May', 'visitors': -209},
  <String, Object?>{'month': 'June', 'visitors': 214},
];

/// §1.4 / §5, *a delta is a shape before it is a hue*. A figure that can fall
/// is not an error, so the falling half does not reach for `destructive`: the
/// direction is already legible from each bar's own position above or below the
/// zero baseline, and the registry's own choice separates the two with
/// `--chart-1` / `--chart-2`, both neutral action-ramp hues.
Widget _barNegative(ChartInk ink, ThemeTokens theme) => _plot(
  ChartConfig(<String, ChartSeries>{
    'visitors': const ChartSeries(label: 'Visitors'),
  }),
  CartesianChart(
    data: _barNegativeData,
    grid: const ChartGrid(vertical: false),
    tooltip: const ChartTooltipSpec(
      cursor: false,
      hideLabel: true,
      hideIndicator: true,
    ),
    series: <ChartSeriesSpec>[
      ChartSeriesSpec(
        kind: ChartSeriesKind.bar,
        dataKey: 'visitors',
        cellFills: <Color>[
          for (final Map<String, Object?> row in _barNegativeData)
            (row['visitors']! as num) > 0 ? ink.slot(1) : ink.slot(2),
        ],
        labels: <ChartLabelList>[
          // No explicit fill in the registry means recharts' own untokenised
          // grey paints the month labels: the same class of failure
          // `ui/chart.tsx` measured on the axis ticks. `fill-foreground`
          // closes it.
          ChartLabelList(dataKey: 'month', color: theme.foreground),
        ],
      ),
    ],
  ),
);

/// The two clickable totals, and the series they switch between.
///
/// Inline, this strip made the panel 94px taller in `ready` than in the other
/// two states: measured 393.39 → 487.78: which is §5's *"a layout jump is
/// worse than the spinner it was meant to avoid"*.
///
/// **The selection travels.** §4: *"a group of options owns ONE pill that
/// physically slides from the old selection to the new one… Options never own
/// their own selected background… Applies to `ToggleGroup` and `Tabs`, and to
/// anything like them you add later."* `ToggleGroup` itself does not drop in —
/// its variants are built for label-sized items and these tiles carry a
/// `Stat`-sized figure: but the travel is [ActiveIndicator]'s, and that is
/// reusable on its own.
///
/// **The pill carries the series' colour, and only below the text.** `bar.tsx`
/// derives it in full: `--muted-foreground` measures 4.83:1 on `--card`, so the
/// only flat tint of a chart token that keeps an 11px `type-label` above AA is
/// 4%, and at 4% the two active states are the same colour. So the tint stops
/// before it reaches the text: the bottom half of the pill carries it, the top
/// half, where the label sits, carries none.
class _SeriesStrip extends StatefulWidget {
  const _SeriesStrip({
    required this.ink,
    required this.slot,
    required this.child,
  });

  final ChartInk ink;

  /// Which key the strip is for, `bar-series-option` or `line-series-option`.
  final String slot;

  final Widget child;

  /// `desktop` / `mobile`, in the registry's order.
  static const List<String> series = <String>['desktop', 'mobile'];

  /// The running totals over all 91 days.
  static int total(String key) => dailyVisits.fold<int>(
    0,
    (int acc, Map<String, Object?> row) => acc + (row[key]! as int),
  );

  @override
  State<_SeriesStrip> createState() => _SeriesStripState();
}

class _SeriesStripState extends State<_SeriesStrip> {
  int _active = 0;

  /// `to-50%`: the tint reaches exactly halfway and no further, which is what
  /// keeps the `type-label` on `--card` rather than on `--muted`.
  static const double _tintStop = 0.5;

  /// `from-chart-N/40`.
  static const double _tintAlpha = 0.4;

  /// `border-b-2`: full saturation where no text sits.
  static const double _ruleHeight = 2;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final Color colour = widget.ink.slot(_active + 1);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DecoratedBox(
          decoration: BoxDecoration(
            color: theme.card,
            borderRadius: BorderRadius.circular(Radii.lg),
            border: Border.all(
              color: theme.border,
              width: BorderWidths.hairline,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(Radii.lg),
            // Two `Stat` tiles at 200% text can outgrow the strip's own
            // width; [ActiveIndicator]'s row is intrinsically sized (it has
            // to be, to track the sliding fill under whichever tile is
            // active), so it scrolls horizontally rather than compressing
            // the figures it is tracking.
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ActiveIndicator(
                activeIndex: _active,
                indicator: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      stops: const <double>[0, _tintStop],
                      colors: <Color>[
                        colour.withValues(alpha: _tintAlpha),
                        colour.withValues(alpha: 0),
                      ],
                    ),
                    border: Border(
                      bottom: BorderSide(color: colour, width: _ruleHeight),
                    ),
                  ),
                  child: const SizedBox.expand(),
                ),
                children: <Widget>[
                  for (int i = 0; i < _SeriesStrip.series.length; i++)
                    _SeriesTile(
                      label: i == 0 ? 'Desktop' : 'Mobile',
                      value: chartNumber(
                        _SeriesStrip.total(_SeriesStrip.series[i]),
                      ),
                      swatch: widget.ink.slot(i + 1),
                      leadingBorder: i > 0,
                      onTap: () => setState(() => _active = i),
                    ),
                ],
              ),
            ),
          ),
        ),
        // `mb-5`.
        SizedBox(height: space(5)),
        _SeriesScope(series: _SeriesStrip.series[_active], child: widget.child),
      ],
    );
  }
}

/// One tile: a `Stat` and a swatch, in a control.
class _SeriesTile extends StatelessWidget {
  const _SeriesTile({
    required this.label,
    required this.value,
    required this.swatch,
    required this.leadingBorder,
    required this.onTap,
  });

  final String label;
  final String value;
  final Color swatch;
  final bool leadingBorder;
  final VoidCallback onTap;

  /// `size-3 rounded-xs`: the same swatch `PieInteractiveControls` uses, so
  /// the two interactive pickers share one idiom rather than inventing a
  /// second.
  static double get swatchSize => space(3);

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: leadingBorder
              ? Border(
                  left: BorderSide(
                    color: theme.border,
                    width: BorderWidths.hairline,
                  ),
                )
              : null,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: space(4),
            vertical: space(3),
          ),
          child: Stack(
            children: <Widget>[
              Stat(label: label, value: value),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: swatchSize,
                  height: swatchSize,
                  decoration: BoxDecoration(
                    color: swatch,
                    borderRadius: BorderRadius.circular(Radii.xs),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The context the series strip hands down through the keyed slot.
class _SeriesScope extends InheritedWidget {
  const _SeriesScope({required this.series, required super.child});

  final String series;

  static String of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_SeriesScope>()?.series ??
      'desktop';

  @override
  bool updateShouldNotify(_SeriesScope old) => old.series != series;
}

/// The registry writes ``fill={`var(--color-${activeChart})`}``: at runtime
/// exactly `var(--color-desktop)`, the `--color-<seriesKey>` pattern rule 1
/// forbids. A lookup keeps the per-series colour without assembling that string.
Color _seriesColour(ChartInk ink, String key) =>
    key == 'desktop' ? ink.slot(1) : ink.slot(2);

Widget _barInteractive(BuildContext context, ChartInk ink) {
  final String active = _SeriesScope.of(context);
  return _plot(
    ink.desktopMobile.plus(<String, ChartSeries>{
      'views': const ChartSeries(label: 'Page Views'),
    }),
    CartesianChart(
      data: dailyVisits,
      margin: const ChartMargin(left: 12, right: 12),
      grid: const ChartGrid(vertical: false),
      xAxis: const ChartAxis(
        dataKey: 'date',
        tickLine: false,
        axisLine: false,
        tickMargin: 8,
        minTickGap: 32,
        tickFormatter: _shortDate,
      ),
      tooltip: const ChartTooltipSpec(
        nameKey: 'views',
        labelFormatter: _shortDateYearLabel,
      ),
      series: <ChartSeriesSpec>[
        ChartSeriesSpec(
          kind: ChartSeriesKind.bar,
          dataKey: active,
          fill: _seriesColour(ink, active),
        ),
      ],
    ),
  );
}

/* ── Line, `components/space/charts/line.tsx` ──────────────────────────────── */

/// The one line every `dot={false}` variant draws.
ChartSeriesSpec _lineSeries(
  Color colour,
  String key,
  CurveType curve, {
  ChartDot? dot,
  List<ChartLabelList> labels = const <ChartLabelList>[],
}) => ChartSeriesSpec(
  kind: ChartSeriesKind.line,
  dataKey: key,
  curve: curve,
  stroke: colour,
  strokeWidth: 2,
  dot: dot,
  labels: labels,
);

Widget _lineChart(
  ChartConfig config,
  List<Map<String, Object?>> data,
  List<ChartSeriesSpec> series, {
  ChartAxis? xAxis,
  ChartMargin margin = const ChartMargin(left: 12, right: 12),
  ChartTooltipSpec tooltip = const ChartTooltipSpec(
    cursor: false,
    hideLabel: true,
  ),
}) => _plot(
  config,
  CartesianChart(
    data: data,
    margin: margin,
    grid: const ChartGrid(vertical: false),
    xAxis: xAxis,
    tooltip: tooltip,
    series: series,
  ),
);

Widget _lineDefault(ChartInk ink) => _lineChart(
  ink.desktop,
  monthsDesktop,
  <ChartSeriesSpec>[_lineSeries(ink.slot(1), 'desktop', CurveType.natural)],
  xAxis: _monthAxis(),
);

Widget _lineLinear(ChartInk ink) => _lineChart(
  ink.desktop,
  monthsDesktop,
  <ChartSeriesSpec>[_lineSeries(ink.slot(1), 'desktop', CurveType.linear)],
  xAxis: _monthAxis(),
);

Widget _lineStep(ChartInk ink) => _lineChart(
  ink.desktop,
  monthsDesktop,
  <ChartSeriesSpec>[_lineSeries(ink.slot(1), 'desktop', CurveType.step)],
  xAxis: _monthAxis(),
);

Widget _lineMultiple(ChartInk ink) => _lineChart(
  ink.desktopMobile,
  monthsDesktopMobile,
  <ChartSeriesSpec>[
    _lineSeries(ink.slot(1), 'desktop', CurveType.monotone),
    _lineSeries(ink.slot(2), 'mobile', CurveType.monotone),
  ],
  xAxis: _monthAxis(),
  tooltip: const ChartTooltipSpec(),
);

Widget _lineDots(ChartInk ink) =>
    _lineChart(ink.desktopMobile, monthsDesktopMobile, <ChartSeriesSpec>[
      _lineSeries(
        ink.slot(1),
        'desktop',
        CurveType.natural,
        dot: ChartDot(fill: ink.slot(1)),
      ),
    ], xAxis: _monthAxis());

/// The registry hardcodes 24 for the glyph's box; `line.tsx` reads it off the
/// icon ladder instead, *"so `xl` is 24 in one place only"*.
Widget _lineDotsCustom(ChartInk ink, ThemeTokens theme) =>
    _lineChart(ink.desktopMobile, monthsDesktopMobile, <ChartSeriesSpec>[
      _lineSeries(
        ink.slot(1),
        'desktop',
        CurveType.natural,
        dot: ChartDot(
          radius: Icon.pxFor(IconSize.xl) / 2,
          fill: theme.background,
          stroke: ink.slot(1),
        ),
      ),
    ], xAxis: _monthAxis());

/// One line through five categorical points, coloured from each row rather than
/// from a series palette: five rows, five tokens, no cycling.
Widget _lineDotsColors(ChartInk ink) => _lineChart(
  ink.browser,
  browsers,
  <ChartSeriesSpec>[
    ChartSeriesSpec(
      kind: ChartSeriesKind.line,
      dataKey: 'visitors',
      curve: CurveType.natural,
      // `visitors` is the value key and carries no colour of its own, so
      // the stroke is the plain `--color-chart-2` the registry's config
      // resolves to, not a lookup through it.
      stroke: ink.slot(2),
      strokeWidth: 2,
      dot: const ChartDot(radius: 5),
      cellFills: <Color>[
        for (final Map<String, Object?> row in browsers) ink.ofRow(row),
      ],
    ),
  ],
  margin: const ChartMargin(top: 24, left: 24, right: 24),
  tooltip: const ChartTooltipSpec(
    cursor: false,
    indicator: ChartIndicator.line,
    nameKey: 'visitors',
    hideLabel: true,
  ),
);

Widget _lineLabel(ChartInk ink, ThemeTokens theme) => _lineChart(
  ink.desktopMobile,
  monthsDesktopMobile,
  <ChartSeriesSpec>[
    _lineSeries(
      ink.slot(1),
      'desktop',
      CurveType.natural,
      dot: ChartDot(fill: ink.slot(1)),
      labels: <ChartLabelList>[
        ChartLabelList(offset: 12, color: theme.foreground),
      ],
    ),
  ],
  xAxis: _monthAxis(),
  margin: const ChartMargin(top: 20, left: 12, right: 12),
  tooltip: const ChartTooltipSpec(
    cursor: false,
    indicator: ChartIndicator.line,
  ),
);

Widget _lineLabelCustom(ChartInk ink, ThemeTokens theme) => _lineChart(
  ink.browser,
  browsers,
  <ChartSeriesSpec>[
    _lineSeries(
      ink.slot(2),
      'visitors',
      CurveType.natural,
      dot: ChartDot(fill: ink.slot(2)),
      labels: <ChartLabelList>[
        ChartLabelList(
          dataKey: 'browser',
          offset: 12,
          color: theme.foreground,
          formatter: _browserLabelOf,
        ),
      ],
    ),
  ],
  margin: const ChartMargin(top: 24, left: 24, right: 24),
  tooltip: const ChartTooltipSpec(
    cursor: false,
    indicator: ChartIndicator.line,
    nameKey: 'visitors',
    hideLabel: true,
  ),
);

String _browserLabelOf(Object? value) => _browserLabel('$value');

Widget _lineInteractive(BuildContext context, ChartInk ink) {
  final String active = _SeriesScope.of(context);
  return _plot(
    ink.desktopMobile.plus(<String, ChartSeries>{
      'views': const ChartSeries(label: 'Page Views'),
    }),
    CartesianChart(
      data: dailyVisits,
      margin: const ChartMargin(left: 12, right: 12),
      grid: const ChartGrid(vertical: false),
      xAxis: const ChartAxis(
        dataKey: 'date',
        tickLine: false,
        axisLine: false,
        tickMargin: 8,
        minTickGap: 32,
        tickFormatter: _shortDate,
      ),
      tooltip: ChartTooltipSpec(
        nameKey: 'views',
        labelFormatter: _shortDateYearLabel,
        // `className="w-40"`.
        width: space(40),
      ),
      series: <ChartSeriesSpec>[
        _lineSeries(_seriesColour(ink, active), active, CurveType.monotone),
      ],
    ),
  );
}

/* ── Pie, `components/space/charts/pie.tsx` ────────────────────────────────── */

/// The bare `Pie` eight of the eleven variants start from.
PieSpec _browserPie(
  ChartInk ink, {
  double? innerRadius,
  double strokeWidth = 1,
  int? activeIndex,
  double activeGrow = 0,
  bool activeRing = false,
  bool outsideLabel = false,
  bool labelLine = true,
  String Function(Map<String, Object?>)? labelBuilder,
  String? chipLabelKey,
  List<Map<String, Object?>>? data,
}) => PieSpec(
  data: ink.rows(data ?? browsers),
  dataKey: 'visitors',
  nameKey: 'browser',
  innerRadius: innerRadius,
  strokeWidth: strokeWidth,
  activeIndex: activeIndex,
  activeGrow: activeGrow,
  activeRing: activeRing,
  outsideLabel: outsideLabel,
  labelLine: labelLine,
  labelBuilder: labelBuilder,
  chipLabelKey: chipLabelKey,
);

Widget _pieSimple(ChartInk ink) => _plot(
  ink.browser,
  PieChart(
    pies: <PieSpec>[_browserPie(ink)],
    tooltip: const ChartTooltipSpec(cursor: false, hideLabel: true),
  ),
);

/// `stroke="0"` is the registry's own value, kept verbatim: the wedge
/// separator is a stroke WIDTH here, not a hue, and there is nothing in it for
/// a token to own.
Widget _pieSeparatorNone(ChartInk ink) => _plot(
  ink.browser,
  PieChart(
    pies: <PieSpec>[_browserPie(ink, strokeWidth: 0)],
    tooltip: const ChartTooltipSpec(cursor: false, hideLabel: true),
  ),
);

/// The label sits OUTSIDE the wedge, on the panel background, so this is a
/// background-contrast case rather than the on-fill one `PieLabelList` answers.
Widget _pieLabel(ChartInk ink, ThemeTokens theme) => _plot(
  ink.browser,
  PieChart(
    pies: <PieSpec>[_browserPie(ink, outsideLabel: true)],
    labelColor: theme.foreground,
    tooltip: const ChartTooltipSpec(hideLabel: true),
  ),
);

/// The registry's custom `label` render function, swept once:
/// `fill="hsla(var(--foreground))"` → `--foreground`. It still lands outside
/// the wedge, so this is background contrast again.
Widget _pieLabelCustom(ChartInk ink, ThemeTokens theme) => _plot(
  ink.browser,
  PieChart(
    pies: <PieSpec>[
      _browserPie(
        ink,
        outsideLabel: true,
        labelLine: false,
        labelBuilder: (Map<String, Object?> row) =>
            chartNumber(row['visitors']! as num),
      ),
    ],
    labelColor: theme.foreground,
    tooltip: const ChartTooltipSpec(nameKey: 'visitors', hideLabel: true),
  ),
);

/// This family's real AA question, and the one the arithmetic decides —
/// see the chip widget in `chart_polar.dart` for the full derivation.
Widget _pieLabelList(ChartInk ink) => _plot(
  ink.browser,
  PieChart(
    pies: <PieSpec>[_browserPie(ink, chipLabelKey: 'browser')],
    tooltip: const ChartTooltipSpec(nameKey: 'visitors', hideLabel: true),
  ),
);

/// No tooltip in this variant: the legend is the whole point.
Widget _pieLegend(ChartInk ink) => _plot(
  ink.browser,
  PieChart(
    pies: <PieSpec>[_browserPie(ink)],
    legend: const ChartLegendSpec(
      nameKey: 'browser',
      wrap: true,
      // `-translate-y-2`.
      offset: 8,
    ),
  ),
);

/// `innerRadius={60}` is the registry's own pixel value, kept rather than
/// reinstated as a percentage (drift 4: the panel's note still says
/// "percentage").
Widget _pieDonut(ChartInk ink) => _plot(
  ink.browser,
  PieChart(
    pies: <PieSpec>[_browserPie(ink, innerRadius: 60)],
    tooltip: const ChartTooltipSpec(cursor: false, hideLabel: true),
  ),
);

Widget _pieDonutActive(ChartInk ink) => _plot(
  ink.browser,
  PieChart(
    pies: <PieSpec>[
      _browserPie(
        ink,
        innerRadius: 60,
        strokeWidth: 5,
        activeIndex: 0,
        activeGrow: 10,
      ),
    ],
    tooltip: const ChartTooltipSpec(
      cursor: false,
      defaultIndex: 0,
      hideLabel: true,
    ),
  ),
);

/// Drift 5: `data.ts` calls this "+12 firefox / +100 other" and both raised
/// rows are +100. `pie.tsx` flags it and does not reconcile it.
const List<Map<String, Object?>> _pieDonutTextData = <Map<String, Object?>>[
  <String, Object?>{'browser': 'chrome', 'visitors': 275, 'slot': 1},
  <String, Object?>{'browser': 'safari', 'visitors': 200, 'slot': 2},
  <String, Object?>{'browser': 'firefox', 'visitors': 287, 'slot': 3},
  <String, Object?>{'browser': 'edge', 'visitors': 173, 'slot': 4},
  <String, Object?>{'browser': 'other', 'visitors': 190, 'slot': 5},
];

/// The centred donut text: on the panel background rather than on any wedge
/// fill, which is the slot `RadialText` already proved clears AA in both
/// themes. `type-num-xl` replaces the registry's `text-3xl font-bold`, the
/// weight already living in the class.
Widget _donutCentre(BuildContext context, String figure, String caption) {
  final ThemeTokens theme = ThemeScope.of(context);
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      StyledText(figure, TextStyles.numberXl, color: theme.foreground),
      SizedBox(height: space(1)),
      StyledText(caption, ChartText.xs, color: theme.mutedForeground),
    ],
  );
}

Widget _pieDonutText(ChartInk ink) {
  final int total = _pieDonutTextData.fold<int>(
    0,
    (int acc, Map<String, Object?> row) => acc + (row['visitors']! as int),
  );
  return _plot(
    ink.browser,
    PieChart(
      pies: <PieSpec>[
        _browserPie(
          ink,
          innerRadius: 60,
          strokeWidth: 5,
          data: _pieDonutTextData,
        ),
      ],
      centerLabel: (BuildContext context) =>
          _donutCentre(context, chartNumber(total), 'Visitors'),
      tooltip: const ChartTooltipSpec(cursor: false, hideLabel: true),
    ),
  );
}

/// Two rings, one dataset each.
Widget _pieStacked(ChartInk ink) => _plot(
  ink.pieMonths,
  PieChart(
    pies: <PieSpec>[
      PieSpec(
        data: ink.rows(pieMonthsDesktop),
        dataKey: 'desktop',
        nameKey: 'month',
        outerRadius: 60,
      ),
      PieSpec(
        data: ink.rows(pieMonthsMobile),
        dataKey: 'mobile',
        nameKey: 'month',
        innerRadius: 70,
        outerRadius: 90,
      ),
    ],
    tooltip: const ChartTooltipSpec(
      labelKey: 'visitors',
      nameKey: 'month',
      indicator: ChartIndicator.line,
    ),
  ),
);

/// The slice picker. `defaultIndex` is what makes the `Select`'s choice
/// reactive, `Tooltip.js` re-dispatches whenever the prop's value changes,
/// which is also what moves `activeShape` from one wedge to the next.
class _PieInteractive extends StatefulWidget {
  const _PieInteractive({required this.ink, required this.builder});

  final ChartInk ink;
  final Widget Function(BuildContext context, int activeIndex) builder;

  static const List<String> months = <String>[
    'january',
    'february',
    'march',
    'april',
    'may',
  ];

  @override
  State<_PieInteractive> createState() => _PieInteractiveState();
}

class _PieInteractiveState extends State<_PieInteractive> {
  String _month = 'january';

  @override
  Widget build(BuildContext context) {
    final int index = _PieInteractive.months.indexOf(_month).clamp(0, 4);
    return _RangeStrip(
      value: _month,
      onChanged: (String next) => setState(() => _month = next),
      width: _RangeStrip.monthWidth,
      label: 'Select a month',
      placeholder: 'Select month',
      options: <SelectOption<String>>[
        for (int i = 0; i < _PieInteractive.months.length; i++)
          SelectOption<String>(
            value: _PieInteractive.months[i],
            label: _monthLabel(_PieInteractive.months[i]),
          ),
      ],
      child: widget.builder(context, index),
    );
  }
}

String _monthLabel(String key) => '${key[0].toUpperCase()}${key.substring(1)}';

Widget _pieInteractive(BuildContext context, ChartInk ink, int activeIndex) =>
    _plot(
      ink.pieMonths,
      PieChart(
        pies: <PieSpec>[
          PieSpec(
            data: ink.rows(pieMonthsDesktop),
            dataKey: 'desktop',
            nameKey: 'month',
            innerRadius: 60,
            strokeWidth: 5,
            activeIndex: activeIndex,
            activeGrow: 10,
            activeRing: true,
          ),
        ],
        centerLabel: (BuildContext context) => _donutCentre(
          context,
          chartNumber(pieMonthsDesktop[activeIndex]['desktop']! as num),
          'Visitors',
        ),
        tooltip: ChartTooltipSpec(
          cursor: false,
          defaultIndex: activeIndex,
          hideLabel: true,
        ),
      ),
    );

/* ── Radar, `components/space/charts/radar.tsx` ────────────────────────────── */

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

Widget _radarChart(
  ChartConfig config,
  List<Map<String, Object?>> data,
  List<RadarSpec> series, {
  PolarGrid? grid = const PolarGrid(),
  PolarAngleAxis? angleAxis = const PolarAngleAxis(dataKey: 'month'),
  PolarRadiusAxis? radiusAxis,
  ChartLegendSpec? legend,
  ChartMargin margin = ChartMargin.standard,
}) => _plot(
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

Widget _radarDefault(ChartInk ink) => _radarChart(
  ink.desktop,
  radarMonths,
  <RadarSpec>[_radar(ink.slot(1), 'desktop', fillOpacity: 0.6)],
);

Widget _radarDots(ChartInk ink) => _radarChart(
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

Widget _radarLinesOnly(ChartInk ink) =>
    _radarChart(ink.desktopMobile, _radarLinesOnlyData, <RadarSpec>[
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

Widget _radarLabelCustom(ChartInk ink) => _radarChart(
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
Widget _radarGridCustom(ChartInk ink) => _radarChart(
  ink.desktop,
  radarMonths,
  <RadarSpec>[_radar(ink.slot(1), 'desktop', fillOpacity: 0.6)],
  grid: const PolarGrid(radialLines: false, polarRadius: <double>[90]),
);

/// No `PolarGrid` at all, not even a hidden one.
Widget _radarGridNone(ChartInk ink) => _radarChart(
  ink.desktop,
  radarMonths,
  <RadarSpec>[
    _radar(ink.slot(1), 'desktop', fillOpacity: 0.6, dot: const ChartDotSpec()),
  ],
  grid: null,
);

Widget _radarGridCircle(ChartInk ink) => _radarChart(
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

Widget _radarGridCircleNoLines(ChartInk ink) => _radarChart(
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
Widget _radarGridCircleFill(ChartInk ink) => _radarChart(
  ink.desktop,
  radarMonthsFill,
  <RadarSpec>[_radar(ink.slot(1), 'desktop', fillOpacity: 0.5)],
  grid: PolarGrid(
    gridType: PolarGridType.circle,
    fills: <Color>[ink.slot(1)],
    opacity: 0.2,
  ),
);

Widget _radarGridFill(ChartInk ink) => _radarChart(
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

Widget _radarMultiple(ChartInk ink) =>
    _radarChart(ink.desktopMobile, monthsDesktopMobile, _radarPair(ink));

Widget _radarLegend(ChartInk ink) => _radarChart(
  ink.desktopMobile,
  monthsDesktopMobile,
  _radarPair(ink),
  legend: const ChartLegendSpec(),
  margin: const ChartMargin(top: -40, bottom: -10),
);

/// Drift 9: structurally identical to `RadarLegend`: the registry's own
/// `chart-radar-icons` differs only in `chartConfig`.
Widget _radarIcons(ChartInk ink) => _plot(
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
Widget _radarRadius(ChartInk ink, ThemeTokens theme) => _plot(
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

/* ── Radial, `components/space/charts/radial.tsx` ──────────────────────────── */

Widget _radialSimple(ChartInk ink) => _plot(
  ink.browser,
  RadialBarChart(
    data: ink.rows(browsers),
    innerRadius: 30,
    outerRadius: 110,
    series: const <RadialBarSpec>[
      RadialBarSpec(dataKey: 'visitors', background: true),
    ],
    tooltip: const ChartTooltipSpec(
      cursor: false,
      hideLabel: true,
      nameKey: 'browser',
    ),
  ),
);

Widget _radialGrid(ChartInk ink) => _plot(
  ink.browser,
  RadialBarChart(
    data: ink.rows(browsers),
    innerRadius: 30,
    outerRadius: 100,
    grid: const PolarGrid(gridType: PolarGridType.circle),
    series: const <RadialBarSpec>[RadialBarSpec(dataKey: 'visitors')],
    tooltip: const ChartTooltipSpec(
      cursor: false,
      hideLabel: true,
      nameKey: 'browser',
    ),
  ),
);

/// The labels sit at each arc's START angle, which is both the registry's own
/// position and the only placement where five of them cannot collide: at the
/// mid-angle they came out 19.9px apart for labels 48px wide.
Widget _radialLabel(ChartInk ink) => _plot(
  ink.browser,
  RadialBarChart(
    data: ink.rows(browsers),
    startAngle: -90,
    endAngle: 380,
    innerRadius: 30,
    outerRadius: 110,
    series: const <RadialBarSpec>[
      RadialBarSpec(
        dataKey: 'visitors',
        background: true,
        chipLabelKey: 'browser',
      ),
    ],
    tooltip: const ChartTooltipSpec(
      cursor: false,
      hideLabel: true,
      nameKey: 'browser',
    ),
  ),
);

/// A single browser row, used by nothing else.
const List<Map<String, Object?>> _radialTextData = <Map<String, Object?>>[
  <String, Object?>{'browser': 'safari', 'visitors': 200, 'slot': 2},
];

/// Drift 6: the panel's note calls this "a custom activeShape" and the vendored
/// source has none: it is `chart-radial-text` with a different sweep and a
/// different number (1260 rather than 200).
const List<Map<String, Object?>> _radialShapeData = <Map<String, Object?>>[
  <String, Object?>{'browser': 'safari', 'visitors': 1260, 'slot': 2},
];

PolarGrid _radialPlate(ThemeTokens theme) => PolarGrid(
  gridType: PolarGridType.circle,
  radialLines: false,
  // `className="first:fill-muted last:fill-background"`.
  fills: <Color>[theme.muted, theme.background],
  polarRadius: const <double>[86, 74],
);

Widget _radialText(ChartInk ink, ThemeTokens theme) => _plot(
  ChartConfig(<String, ChartSeries>{
    'visitors': const ChartSeries(label: 'Visitors'),
    'safari': ChartSeries(label: 'Safari', color: ink.slot(2)),
  }),
  RadialBarChart(
    data: ink.rows(_radialTextData),
    startAngle: 0,
    endAngle: 250,
    innerRadius: 80,
    outerRadius: 110,
    grid: _radialPlate(theme),
    series: const <RadialBarSpec>[
      RadialBarSpec(
        dataKey: 'visitors',
        background: true,
        cornerRadius: _ringRadius,
      ),
    ],
    radiusAxis: PolarRadiusAxis(
      tick: false,
      axisLine: false,
      centerLabel: (BuildContext context) =>
          _donutCentre(context, chartNumber(200), 'Visitors'),
    ),
  ),
);

Widget _radialShape(ChartInk ink, ThemeTokens theme) => _plot(
  ChartConfig(<String, ChartSeries>{
    'visitors': const ChartSeries(label: 'Visitors'),
    'safari': ChartSeries(label: 'Safari', color: ink.slot(2)),
  }),
  RadialBarChart(
    data: ink.rows(_radialShapeData),
    endAngle: 100,
    innerRadius: 80,
    outerRadius: 140,
    grid: _radialPlate(theme),
    series: const <RadialBarSpec>[
      RadialBarSpec(dataKey: 'visitors', background: true),
    ],
    radiusAxis: PolarRadiusAxis(
      tick: false,
      axisLine: false,
      centerLabel: (BuildContext context) =>
          _donutCentre(context, chartNumber(1260), 'Visitors'),
    ),
  ),
);

/// A single `{ month, desktop, mobile }` row. The registry names it
/// `"january"`; kept, though it plays no visual role: there is no category
/// axis rendering it.
const List<Map<String, Object?>> _radialStackedData = <Map<String, Object?>>[
  <String, Object?>{'month': 'january', 'desktop': 1260, 'mobile': 570},
];

/// The explicit `PolarAngleAxis domain` is the fix for this family's headline
/// error: left alone the angle-axis domain runs to the largest SINGLE series
/// rather than to the stack total, so the first ring fills the whole sweep and
/// the one behind it is clipped to nothing: no error, no warning.
Widget _radialStacked(ChartInk ink) {
  const int total = 1260 + 570;
  return _plot(
    ink.desktopMobile,
    RadialBarChart(
      data: _radialStackedData,
      endAngle: 180,
      innerRadius: 80,
      outerRadius: 130,
      angleAxis: PolarAngleAxis(
        tick: false,
        axisLine: false,
        domain: (min: 0, max: total.toDouble()),
      ),
      radiusAxis: PolarRadiusAxis(
        tick: false,
        axisLine: false,
        centerLabel: (BuildContext context) {
          final ThemeTokens theme = ThemeScope.of(context);
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              StyledText(
                chartNumber(total),
                TextStyles.numberLg,
                color: theme.foreground,
              ),
              SizedBox(height: space(1)),
              StyledText(
                'Visitors',
                ChartText.xs,
                color: theme.mutedForeground,
              ),
            ],
          );
        },
      ),
      series: <RadialBarSpec>[
        RadialBarSpec(
          dataKey: 'desktop',
          stackId: 'a',
          cornerRadius: _stackRadius,
          fill: ink.slot(1),
        ),
        RadialBarSpec(
          dataKey: 'mobile',
          stackId: 'a',
          cornerRadius: _stackRadius,
          fill: ink.slot(2),
        ),
      ],
      tooltip: const ChartTooltipSpec(cursor: false, hideLabel: true),
    ),
  );
}

/* ── Tooltips, `components/space/charts/tooltip.tsx` ───────────────────────── */

/// Every one of the nine is the SAME two-series stacked bar chart, because the
/// family's whole point is that only the tooltip's configuration changes. No
/// `CartesianGrid`, no `YAxis`: the registry source for all nine omits both.
Widget _tooltipChart(
  ChartInk ink,
  ChartConfig config,
  ChartTooltipSpec tooltip,
) => _plot(
  config,
  CartesianChart(
    data: sportDays,
    xAxis: const ChartAxis(
      dataKey: 'date',
      tickLine: false,
      tickMargin: 10,
      axisLine: false,
      tickFormatter: _weekdayShort,
    ),
    tooltip: tooltip,
    series: <ChartSeriesSpec>[
      ChartSeriesSpec(
        kind: ChartSeriesKind.bar,
        dataKey: 'running',
        stackId: 'a',
        fill: ink.slot(1),
        radii: _radiiBottom,
      ),
      ChartSeriesSpec(
        kind: ChartSeriesKind.bar,
        dataKey: 'swimming',
        stackId: 'a',
        fill: ink.slot(2),
        radii: _radiiTop,
      ),
    ],
  ),
);

Widget _tooltipDefault(ChartInk ink) => _tooltipChart(
  ink,
  ink.sport,
  const ChartTooltipSpec(cursor: false, defaultIndex: 1),
);

Widget _tooltipIndicatorLine(ChartInk ink) => _tooltipChart(
  ink,
  ink.sport,
  const ChartTooltipSpec(
    cursor: false,
    defaultIndex: 1,
    indicator: ChartIndicator.line,
  ),
);

Widget _tooltipIndicatorNone(ChartInk ink) => _tooltipChart(
  ink,
  ink.sport,
  const ChartTooltipSpec(cursor: false, defaultIndex: 1, hideIndicator: true),
);

/// The registry's one extra config key: a label that never comes from the
/// hovered row at all, so the header always reads "Activities" rather than the
/// day. `labelKey` routes the lookup at it, and the fallback in
/// `getPayloadConfigFromPayload` is what makes a key naming no field work.
Widget _tooltipLabelCustom(ChartInk ink) => _tooltipChart(
  ink,
  ink.sport.plus(<String, ChartSeries>{
    'activities': const ChartSeries(label: 'Activities'),
  }),
  const ChartTooltipSpec(
    cursor: false,
    defaultIndex: 1,
    labelKey: 'activities',
    indicator: ChartIndicator.line,
  ),
);

Widget _tooltipLabelFormatter(ChartInk ink) => _tooltipChart(
  ink,
  ink.sport,
  const ChartTooltipSpec(
    cursor: false,
    defaultIndex: 1,
    labelFormatter: _longDateLabel,
  ),
);

Widget _tooltipLabelNone(ChartInk ink) => _tooltipChart(
  ink,
  ink.sport,
  const ChartTooltipSpec(
    cursor: false,
    defaultIndex: 1,
    hideIndicator: true,
    hideLabel: true,
  ),
);

/// Supplying `formatter` opts a row out of the default renderer entirely, so
/// this one rebuilds by hand what the default already does: which is why
/// `min-w-[130px]` in the registry becomes `min-w-32`, the exact width the
/// default box opens with.
Widget _tooltipFormatter(ChartInk ink) => _tooltipChart(
  ink,
  ink.sport,
  ChartTooltipSpec(
    cursor: false,
    defaultIndex: 1,
    hideLabel: true,
    formatter: (BuildContext context, ChartTooltipItem item, int index) =>
        _KcalRow(item: item),
  ),
);

/// `flex min-w-32 items-center text-xs text-muted-foreground`, with the figure
/// and its unit pushed to the end.
class _KcalRow extends StatelessWidget {
  const _KcalRow({required this.item, this.showTotal = false, this.total = 0});

  final ChartTooltipItem item;
  final bool showTotal;
  final int total;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: ChartTooltipContent.minWidth),
          // `Wrap`, not a `Row`: the advanced tooltip fixes its own width at
          // `w-44` (a spec value, not a layout column), and at 200% text a
          // sport name plus its figure can still outgrow that regardless of
          // which side gives room. `Wrap` drops the figure to its own line
          // rather than asserting when even that is not enough.
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: space(2),
            runSpacing: space(0.5),
            children: <Widget>[
              StyledText(
                item.name == 'running' ? 'Running' : 'Swimming',
                ChartText.xs,
                color: theme.mutedForeground,
              ),
              _Kcal(value: item.value ?? 0),
            ],
          ),
        ),
        if (showTotal) ...<Widget>[
          SizedBox(height: space(1.5)),
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: theme.border,
                  width: BorderWidths.hairline,
                ),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(top: space(1.5)),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: space(2),
                runSpacing: space(0.5),
                children: <Widget>[
                  StyledText(
                    'Total',
                    ChartText.xsMedium,
                    color: theme.foreground,
                  ),
                  _Kcal(value: total),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _Kcal extends StatelessWidget {
  const _Kcal({required this.value});

  final num value;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: <Widget>[
        // Flexible so a tooltip squeezed to its `min-w` at 200% text can
        // still shrink the figure instead of asserting; `mainAxisSize.min`
        // alone only affects how much of the *given* space this row claims,
        // not whether the given space is enough.
        Flexible(
          child: StyledText(
            chartNumber(value),
            TextStyles.numberSm,
            color: theme.foreground,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: space(0.5)),
        // `font-normal text-muted-foreground`: the unit steps down out of the
        // figure's own weight.
        StyledText('kcal', ChartText.xs, color: theme.mutedForeground),
      ],
    );
  }
}

/// Faithful to the registry's own pairing, `Footprints`/running,
/// `Waves`/swimming. `tooltip.tsx` routes both through `Icon` by wrapping them
/// in a zero-arg component; the builder slot here needs no such wrapper.
Widget _tooltipIcons(ChartInk ink) => _tooltipChart(
  ink,
  ChartConfig(<String, ChartSeries>{
    'running': ChartSeries(
      label: 'Running',
      color: ink.slot(1),
      icon: (BuildContext context) => const Icon.lucide(
        Lucide.footprints,
        size: IconSize.xs,
        tone: IconTone.muted,
      ),
    ),
    'swimming': ChartSeries(
      label: 'Swimming',
      color: ink.slot(2),
      icon: (BuildContext context) => const Icon.lucide(
        Lucide.wavesHorizontal,
        size: IconSize.xs,
        tone: IconTone.muted,
      ),
    ),
  }),
  const ChartTooltipSpec(cursor: false, defaultIndex: 1, hideLabel: true),
);

/// The most involved of the nine: a swatch, the series label, the value with
/// its unit, and: after the last row: a totalled line.
Widget _tooltipAdvanced(ChartInk ink) => _tooltipChart(
  ink,
  ink.sport,
  ChartTooltipSpec(
    cursor: false,
    defaultIndex: 1,
    hideLabel: true,
    // `className="w-44"`, 176px, the nearest rung of the same scale
    // `min-w-32` uses, close enough that the fixed-width Total row does not
    // reflow between the two hovered series.
    width: space(44),
    formatter: (BuildContext context, ChartTooltipItem item, int index) =>
        _AdvancedRow(item: item, index: index, ink: ink),
  ),
);

class _AdvancedRow extends StatelessWidget {
  const _AdvancedRow({
    required this.item,
    required this.index,
    required this.ink,
  });

  final ChartTooltipItem item;
  final int index;
  final ChartInk ink;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final Map<String, Object?> row = item.payload ?? const <String, Object?>{};
    final int total =
        ((row['running'] as num?) ?? 0).toInt() +
        ((row['swimming'] as num?) ?? 0).toInt();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: space(0.5)),
          child: Container(
            width: space(2.5),
            height: space(2.5),
            decoration: BoxDecoration(
              color: ink.slot(item.name == 'running' ? 1 : 2),
              borderRadius: BorderRadius.circular(Radii.xs),
            ),
          ),
        ),
        SizedBox(width: space(2)),
        Expanded(
          child: DefaultTextStyle(
            style: StyledText.styleOf(
              context,
              ChartText.xs,
              color: theme.mutedForeground,
            ),
            child: _KcalRow(item: item, showTotal: index == 1, total: total),
          ),
        ),
      ],
    );
  }
}

/* ── Unit activity, `components/space/charts/unit-activity.tsx` ────────────── */

/// One labelled point in a day's row.
@immutable
class _UnitPoint {
  const _UnitPoint(this.label, this.current, [this.previous]);

  final String label;
  final int current;

  /// The comparison period. Null means the day has none, which is what
  /// separates Monday and Saturday from the other five.
  final int? previous;
}

@immutable
class _UnitDay {
  const _UnitDay(this.label, this.points);

  final String label;
  final List<_UnitPoint> points;
}

/// `SAMPLE`: the registry's own seven days, with the two flat days written as
/// bare `current` values exactly as the source does.
final List<_UnitDay> _unitSample = <_UnitDay>[
  _unitDay('Sun', const <List<int>>[
    <int>[1, 1],
    <int>[2, 2],
    <int>[5, 8],
    <int>[8, 11],
    <int>[7, 10],
    <int>[4, 9],
  ]),
  _unitDayFlat('Mon', const <int>[2, 6, 3, 7, 4, 6]),
  _unitDay('Tue', const <List<int>>[
    <int>[4, 9],
    <int>[10, 12],
    <int>[8, 11],
    <int>[5, 8],
    <int>[3, 3],
    <int>[2, 2],
  ]),
  _unitDay('Wed', const <List<int>>[
    <int>[4, 8],
    <int>[10, 12],
    <int>[7, 10],
    <int>[3, 3],
    <int>[2, 2],
    <int>[1, 1],
  ]),
  _unitDay('Thu', const <List<int>>[
    <int>[2, 2],
    <int>[4, 4],
    <int>[5, 5],
    <int>[6, 10],
    <int>[4, 8],
    <int>[3, 3],
  ]),
  _unitDay('Fri', const <List<int>>[
    <int>[4, 4],
    <int>[5, 5],
    <int>[6, 6],
    <int>[7, 7],
    <int>[9, 11],
    <int>[4, 4],
  ]),
  _unitDayFlat('Sat', const <int>[5, 3, 2, 1, 3, 2]),
];

_UnitDay _unitDay(String label, List<List<int>> pairs) =>
    _UnitDay(label, <_UnitPoint>[
      for (int i = 0; i < pairs.length; i++)
        _UnitPoint('${i * 4}:00', pairs[i][0], pairs[i][1]),
    ]);

_UnitDay _unitDayFlat(String label, List<int> values) =>
    _UnitDay(label, <_UnitPoint>[
      for (int i = 0; i < values.length; i++)
        _UnitPoint('${i * 4}:00', values[i]),
    ]);

/// A discrete density chart for activity over repeating time buckets.
///
/// Twelve rows per column, counted from the top down, so a cell is "on" when
/// its level is at or below the point's value. Current uses `chart-4`, the
/// comparison remainder uses `--muted`, and softer muted cells preserve the
/// complete matrix: three states out of two colours, which is what keeps the
/// grid readable without inventing another colour family.
class _UnitActivityChart extends StatelessWidget {
  const _UnitActivityChart();

  /// `LEVELS`: twelve discrete rows.
  static const int levels = 12;

  /// `min-w-xl` on the scroller, so the seven days never compress below the
  /// width the columns need.
  static double get minWidth => _measureXl;

  /// The `bg-muted/40` remainder: the cells that are in neither period.
  static const double _restAlpha = 0.4;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    // The plot below the header fills the rest of `plotHeight` through its
    // own `Expanded`, which needs that height to stay a real bound — a
    // `minHeight` here leaves it unbounded instead (Expanded inside an
    // unbounded Column asserts). The header is what grows at 200% text, so
    // it is the header's own lines that are capped, not the box around it.
    return SizedBox(
      height: plotHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    StyledText(
                      'Active users',
                      TextStyles.small,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: space(1)),
                    StyledText(
                      chartNumber(24815),
                      TextStyles.numberLg,
                      color: theme.foreground,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: space(1)),
                    StyledText(
                      '5.6k fewer in the last 7 days',
                      TextStyles.small,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(width: space(4)),
              // `Flexible`, not a bare non-flex child: a `Row` hands its
              // non-flexible children *unbounded* width, so this strip never
              // actually shrank — it just reported its full two-key width
              // back, which is what overflowed the row. A `Row` rather than
              // a `Wrap` here so the strip stays exactly one line tall (the
              // header's own height budget assumes that); each `_UnitKey`
              // shrinks its own label instead of the strip wrapping.
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Flexible(
                      child: _UnitKey(colour: theme.muted, label: 'Previous'),
                    ),
                    SizedBox(width: space(3)),
                    Flexible(
                      child: _UnitKey(colour: theme.chart4, label: 'Current'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: space(4)),
          Expanded(
            child: ClipRect(
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: minWidth),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    for (int d = 0; d < _unitSample.length; d++) ...<Widget>[
                      if (d > 0) SizedBox(width: space(2)),
                      Expanded(child: _UnitColumn(day: _unitSample[d])),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// One cell's colour: the current period, the comparison remainder, or the
  /// rest of the matrix.
  static Color cell(ThemeTokens theme, int level, _UnitPoint point) {
    if (level <= point.current) return theme.chart4;
    if (level <= (point.previous ?? point.current)) return theme.muted;
    return theme.muted.withValues(alpha: _restAlpha);
  }
}

class _UnitKey extends StatelessWidget {
  const _UnitKey({required this.colour, required this.label});

  final Color colour;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Container(
        width: space(2),
        height: space(2),
        decoration: BoxDecoration(
          color: colour,
          borderRadius: BorderRadius.circular(Radii.sm),
        ),
      ),
      SizedBox(width: space(1.5)),
      // Flexible so this key can still shrink once the header's own
      // `Flexible` has divided the row and left it less than its natural
      // width to work with.
      Flexible(
        child: StyledText(
          label,
          TextStyles.small,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
  );
}

class _UnitColumn extends StatelessWidget {
  const _UnitColumn({required this.day});

  final _UnitDay day;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 20,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              for (int p = 0; p < day.points.length; p++) ...<Widget>[
                if (p > 0) SizedBox(width: space(0.5)),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      for (
                        int i = 0;
                        i < _UnitActivityChart.levels;
                        i++
                      ) ...<Widget>[
                        if (i > 0) SizedBox(height: space(0.5)),
                        Expanded(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: _UnitActivityChart.cell(
                                theme,
                                _UnitActivityChart.levels - i,
                                day.points[p],
                              ),
                              borderRadius: BorderRadius.circular(Radii.sm),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        SizedBox(height: space(2)),
        // The column itself is given a tight height (its share of a fixed
        // plot height), and at 200% text a single line of the day label can
        // need more of it than the column's own share leaves — a `Column`
        // asserts on that regardless of the `ClipRect` around the whole
        // plot. `Expanded` keeps the label inside a real budget instead of
        // asking for its natural size: it clips rather than overflows.
        Expanded(
          flex: 3,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: StyledText(
              day.label,
              TextStyles.numberSm,
              align: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}

/* ── Conversion funnel, `components/space/charts/conversion-funnel.tsx` ────── */

@immutable
class _Stage {
  const _Stage(this.label, this.value, this.slot);

  final String label;
  final int value;

  /// One of the five chart tone slots. Stage order is funnel order.
  final int slot;
}

const List<_Stage> _funnelStages = <_Stage>[
  _Stage('Signed up', 9420, 1),
  _Stage('Created a project', 6180, 2),
  _Stage('Invited a teammate', 3940, 3),
  _Stage('Activated', 3190, 4),
];

/// A compact stage funnel: a segmented strip for the distribution, then rows
/// that keep the exact values as real text.
///
/// The strip is decorative and marked so; the accessible reading is the
/// figure's own summary plus the labelled rows underneath, which is what stops
/// the chart from being unreadable without colour.
class _ConversionFunnelChart extends StatelessWidget {
  const _ConversionFunnelChart();

  /// The cohort denominator. Percentages and the overall rate are derived,
  /// never entered twice.
  static const int total = 24815;

  /// `STRIP_UNITS`: how many segments the whole strip divides into.
  static const int stripUnits = 96;

  /// `h-12`: the strip's own height.
  static double get stripHeight => space(12);

  static String percentage(int value, int of) =>
      of > 0 ? '${(value / of * 100).toStringAsFixed(1)}%' : '0.0%';

  static int unitCount(int value, int of) =>
      of > 0 ? math.max(1, (value / of * stripUnits).round()) : 1;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final ChartInk ink = ChartInk(theme);
    final int stageTotal = _funnelStages.fold<int>(
      0,
      (int acc, _Stage s) => acc + s.value,
    );
    // An exact height, not a minimum — see `_UnitActivityChart` above: the
    // strip below fills the rest of it through its own sizing and needs a
    // real bound. The header lines are capped to one line each instead, so
    // 200% text cannot grow past what `plotHeight` holds.
    return SizedBox(
      height: plotHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Three single lines of real text, one of them `numberLg`, still
          // grow with 200% text even capped at one line each — enough that
          // the block can outgrow whatever fixed share of `plotHeight` it
          // is given. `Expanded` bounds the block; `FittedBox` is what
          // actually keeps its *own* Column (a Flex, which asserts the same
          // way the outer one does) from throwing once its natural content
          // no longer fits that bound, scaling it down in place instead.
          Expanded(
            flex: 5,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: AlignmentDirectional.centerStart,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  StyledText(
                    'Conversions',
                    TextStyles.small,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: space(1)),
                  StyledText(
                    chartNumber(total),
                    TextStyles.numberLg,
                    color: theme.foreground,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: space(1)),
                  StyledText(
                    '${percentage(_funnelStages.last.value, total)} overall conversion',
                    TextStyles.small,
                    color: theme.premiumText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: space(3)),
          SizedBox(
            height: stripHeight,
            child: Row(
              children: <Widget>[
                for (int i = 0; i < _funnelStages.length; i++) ...<Widget>[
                  if (i > 0) SizedBox(width: space(0.5)),
                  Expanded(
                    flex: _funnelStages[i].value,
                    child: Row(
                      children: <Widget>[
                        for (
                          int u = 0;
                          u < unitCount(_funnelStages[i].value, stageTotal);
                          u++
                        ) ...<Widget>[
                          if (u > 0) SizedBox(width: space(0.5)),
                          Expanded(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: ink.slot(_funnelStages[i].slot),
                                borderRadius: BorderRadius.circular(Radii.sm),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(height: space(2)),
          // Also given a real budget rather than its natural size, for the
          // same reason as the block above.
          Expanded(
            flex: 2,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                for (int i = 0; i < _funnelStages.length; i++) ...<Widget>[
                  if (i > 0) SizedBox(width: space(0.5)),
                  Expanded(
                    flex: _funnelStages[i].value,
                    child: StyledText(
                      percentage(_funnelStages[i].value, total),
                      TextStyles.numberSm,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(height: space(3)),
          Expanded(
            flex: 7,
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.symmetric(
                  horizontal: BorderSide(
                    color: theme.border,
                    width: BorderWidths.hairline,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  for (int i = 0; i < _funnelStages.length; i++) ...<Widget>[
                    if (i > 0)
                      SizedBox(
                        height: BorderWidths.hairline,
                        child: ColoredBox(color: theme.border),
                      ),
                    Expanded(child: _FunnelRow(stage: _funnelStages[i])),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FunnelRow extends StatelessWidget {
  const _FunnelRow({required this.stage});

  final _Stage stage;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final ChartInk ink = ChartInk(theme);
    return Row(
      children: <Widget>[
        Container(
          width: space(2.5),
          height: space(2.5),
          decoration: BoxDecoration(
            color: ink.slot(stage.slot),
            borderRadius: BorderRadius.circular(Radii.sm),
          ),
        ),
        SizedBox(width: space(2)),
        Expanded(
          child: StyledText(
            stage.label,
            TextStyles.small,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        StyledText(
          chartNumber(stage.value),
          TextStyles.numberSm,
          color: theme.foreground,
        ),
      ],
    );
  }
}

/* ── The page ────────────────────────────────────────────────────────────── */

/// `/design-system/components/base/charts`.
class ChartsPage extends StatelessWidget {
  const ChartsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CategoryHit here = findCategory('base', 'charts');
    final ThemeTokens theme = ThemeScope.of(context);
    final ChartInk ink = ChartInk(theme);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        PageHeader(
          eyebrow: '${here.group.title} · Base',
          title: here.category.title,
          blurb: here.category.blurb,
          contents: here.category.contents,
        ),
        // `className="mb-6"`.
        Padding(
          padding: EdgeInsets.only(bottom: space(6)),
          child: const Note(
            title: 'Built, not installed',
            child: _BuiltNotInstalled(),
          ),
        ),
        // `className="mb-12"`.
        Padding(
          padding: EdgeInsets.only(bottom: space(12)),
          child: const Note(
            tone: NoteTone.value,
            title: 'Read the Animation section before you copy any of this',
            child: _ReadAnimationFirst(),
          ),
        ),
        // `className="mb-14"`.
        Padding(
          padding: EdgeInsets.only(bottom: space(14)),
          child: const _TokensBlock(),
        ),
        _AreaSection(ink: ink),
        _BarSection(ink: ink, theme: theme),
        _LineSection(ink: ink, theme: theme),
        _PieSection(ink: ink, theme: theme),
        _RadarSection(ink: ink, theme: theme),
        _RadialSection(ink: ink, theme: theme),
        _TooltipSection(ink: ink),
        const _AnimationSection(),
        const _UnitActivitySection(),
        const _ConversionFunnelSection(),
        const _StatesSection(),
        const PageFootNav(groupId: 'base', slug: 'charts'),
      ],
    );
  }
}

class _BuiltNotInstalled extends StatelessWidget {
  const _BuiltNotInstalled();

  @override
  Widget build(BuildContext context) => RichText(
    TextSpan(
      children: <InlineSpan>[
        Code.span('components/ui/chart.tsx'),
        const TextSpan(
          text: ' is the official shadcn wrapper and it arrives with ',
        ),
        Code.span('npx shadcn add chart'),
        const TextSpan(
          text:
              '. The gallery variants on the shadcn site do not: '
              'querying the registry for “chart” returns three '
              'items — the ',
        ),
        Code.span('chart'),
        const TextSpan(
          text:
              ' component, one example and one dashboard block. '
              'Everything below was written here, against ',
        ),
        Code.span('recharts'),
        const TextSpan(
          text:
              ', and every colour on it comes from the five chart '
              'tokens.',
        ),
      ],
    ),
    TextStyles.small,
  );
}

class _ReadAnimationFirst extends StatelessWidget {
  const _ReadAnimationFirst();

  @override
  Widget build(BuildContext context) {
    final TextStyle base = StyledText.styleOf(context, TextStyles.small);
    return RichText(
      TextSpan(
        children: <InlineSpan>[
          const TextSpan(
            text: 'Recharts animates in JavaScript. It takes a duration as a ',
          ),
          TextSpan(
            text: 'number',
            style: base.copyWith(fontStyle: FontStyle.italic),
          ),
          const TextSpan(text: ' and an easing as a '),
          TextSpan(
            text: 'string',
            style: base.copyWith(fontStyle: FontStyle.italic),
          ),
          const TextSpan(
            text: ', so neither is a class and neither is visible to ',
          ),
          Code.span('check:tokens'),
          const TextSpan(
            text:
                '. That makes charts the one place in this system where §0 '
                'is upheld by reading the stylesheet rather than by writing a '
                'utility — and the one place a hardcoded value passes '
                'every guard in the repository and is still wrong.',
          ),
        ],
      ),
      TextStyles.small,
    );
  }
}

/// The five chart tokens, above the first section.
class _TokensBlock extends StatelessWidget {
  const _TokensBlock();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        StyledText(
          'The five chart tokens',
          TextStyles.h3,
          color: theme.foreground,
        ),
        SizedBox(height: space(2)),
        ConstrainedBox(
          // `max-w-2xl`.
          constraints: BoxConstraints(maxWidth: Containers.xl2),
          child: RichText(
            TextSpan(
              children: <InlineSpan>[
                const TextSpan(text: 'Declared once per theme in '),
                Code.span('app/globals.css'),
                const TextSpan(
                  text:
                      ', and mirrored between them on purpose: 2 and 3 swap, '
                      'and so do 4 and 5, so the reading order of a stack '
                      'survives the theme flip instead of inverting with it. '
                      'Series colours here name ',
                ),
                Code.span('var(--color-chart-1)'),
                const TextSpan(text: ' … '),
                Code.span('-5'),
                const TextSpan(
                  text:
                      ' directly. There is no sixth, and adding one needs a '
                      'written reason.',
                ),
              ],
            ),
            TextStyles.small,
          ),
        ),
        SizedBox(height: space(6)),
        const TokenSwatchList(
          rows: <Widget>[
            TokenSwatch(
              token: '--chart-1',
              name: 'Chart 1',
              use:
                  'Action. The primary series in both themes — the one the '
                  'reader is meant to follow.',
              measure: false,
            ),
            TokenSwatch(
              token: '--chart-2',
              name: 'Chart 2',
              use:
                  'Action, one step away. Dark in light mode, bright in dark '
                  'mode — the pair is mirrored so the second series stays the '
                  'second-loudest on either surface.',
              measure: false,
            ),
            TokenSwatch(
              token: '--chart-3',
              name: 'Chart 3',
              use:
                  'Action, the other step. Bright in light mode, dark in dark '
                  'mode.',
              measure: false,
            ),
            TokenSwatch(
              token: '--chart-4',
              name: 'Chart 4',
              use:
                  'Value. The lime ramp enters here, which is why a fourth '
                  'series reads as a different kind of quantity rather than a '
                  'fourth shade of the same one.',
              measure: false,
            ),
            TokenSwatch(
              token: '--chart-5',
              name: 'Chart 5',
              use:
                  'Value, one step away. Mirrored between the themes exactly '
                  'as 2 and 3 are.',
              measure: false,
            ),
          ],
        ),
      ],
    );
  }
}

/* ── Sections ────────────────────────────────────────────────────────────── */

/// `lg:grid-cols-2` with `gap-4`: every family section's own grid.
Widget _specimenGrid(List<Widget> children) => Grid(lg: 2, children: children);

class _AreaSection extends StatelessWidget {
  const _AreaSection({required this.ink});

  final ChartInk ink;

  @override
  Widget build(BuildContext context) => Section(
    id: 'area',
    title: 'Area',
    description:
        'A line with the region under it filled. Reach for it when the '
        'magnitude beneath the curve is part of the story — volume, '
        'holdings, cumulative spend — and for a plain trend reach for Line '
        'instead.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _specimenGrid(<Widget>[
          Panel(
            label: 'Default',
            note: 'one series, natural curve',
            child: ChartStateSwitch(
              groupLabel: 'Default — chart state',
              skeleton: ChartSkeletonKind.area,
              child: _areaDefault(ink),
            ),
          ),
          Panel(
            label: 'Linear',
            note: 'type=linear',
            child: ChartStateSwitch(
              groupLabel: 'Linear — chart state',
              skeleton: ChartSkeletonKind.area,
              child: _areaLinear(ink),
            ),
          ),
          Panel(
            label: 'Step',
            note: 'type=step',
            child: ChartStateSwitch(
              groupLabel: 'Step — chart state',
              skeleton: ChartSkeletonKind.area,
              child: _areaStep(ink),
            ),
          ),
          Panel(
            label: 'Stacked',
            note: 'shared stackId',
            child: ChartStateSwitch(
              groupLabel: 'Stacked — chart state',
              skeleton: ChartSkeletonKind.area,
              child: _areaStacked(ink),
            ),
          ),
          Panel(
            label: 'Stacked, expanded',
            note: 'stackOffset=expand — shares, not totals',
            child: ChartStateSwitch(
              groupLabel: 'Stacked, expanded — chart state',
              skeleton: ChartSkeletonKind.area,
              child: _areaStackedExpand(ink),
            ),
          ),
          Panel(
            label: 'Legend',
            note: 'ChartLegendContent',
            child: ChartStateSwitch(
              groupLabel: 'Legend — chart state',
              skeleton: ChartSkeletonKind.area,
              child: _areaLegend(ink),
            ),
          ),
          Panel(
            label: 'Icons',
            note: 'config icons in the legend',
            child: ChartStateSwitch(
              groupLabel: 'Icons — chart state',
              skeleton: ChartSkeletonKind.area,
              child: _areaIcons(ink),
            ),
          ),
          Panel(
            label: 'Gradient fill',
            note: 'a linearGradient in defs, both stops on the token',
            child: ChartStateSwitch(
              groupLabel: 'Gradient fill — chart state',
              skeleton: ChartSkeletonKind.area,
              child: _areaGradient(ink),
            ),
          ),
          Panel(
            label: 'Axes',
            note: 'both axes labelled',
            child: ChartStateSwitch(
              groupLabel: 'Axes — chart state',
              skeleton: ChartSkeletonKind.area,
              child: _areaAxes(ink),
            ),
          ),
          Panel(
            label: 'Interactive',
            note: 'range picker, above the plot',
            child: ChartStateSwitch(
              groupLabel: 'Interactive — chart state',
              skeleton: ChartSkeletonKind.area,
              controls: (BuildContext context, Widget child) =>
                  _AreaInteractive(ink: ink, child: child),
              child: Builder(
                builder: (BuildContext context) =>
                    _areaInteractive(context, ink),
              ),
            ),
          ),
        ]),
        SizedBox(height: space(4)),
        Meta(
          items: <MetaItem>[
            _meta(
              'type',
              'natural · monotone · linear · step. natural and monotone both '
                  'refuse to overshoot a data point, which linear cannot '
                  'promise once the curve is smoothed. Pick step for anything '
                  'that genuinely changes in jumps.',
            ),
            _meta(
              'stackId',
              'Any shared string stacks the areas that carry it. Order '
                  'matters: the first Area is drawn at the bottom of the '
                  'stack.',
            ),
            _meta(
              'fillOpacity',
              'Opacity is not one of the five token families — §0 owns '
                  'colour, typography, spacing, radius and motion — so a fade '
                  'is written plainly. The colour underneath it is still the '
                  'token.',
            ),
            _meta(
              'Gradient',
              'A <linearGradient> inside <defs>, referenced as '
                  'fill="url(#id)". Give the id a page-unique prefix; two '
                  'charts sharing one id share one gradient.',
            ),
          ],
        ),
      ],
    ),
  );
}

class _BarSection extends StatelessWidget {
  const _BarSection({required this.ink, required this.theme});

  final ChartInk ink;
  final ThemeTokens theme;

  @override
  Widget build(BuildContext context) => Section(
    id: 'bar',
    title: 'Bar',
    description:
        'Comparison across a small number of named things. Four '
        'arrangements, one of which is the same chart rotated — a '
        'horizontal bar chart is a BarChart with layout=vertical, which '
        'reads backwards until you have hit it once.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _specimenGrid(<Widget>[
          Panel(
            label: 'Default',
            note: 'one series',
            child: ChartStateSwitch(
              groupLabel: 'Default — chart state',
              skeleton: ChartSkeletonKind.bar,
              child: _barDefault(ink),
            ),
          ),
          Panel(
            label: 'Horizontal',
            note: 'layout=vertical, YAxis type=category',
            child: ChartStateSwitch(
              groupLabel: 'Horizontal — chart state',
              skeleton: ChartSkeletonKind.bar,
              child: _barHorizontal(ink),
            ),
          ),
          Panel(
            label: 'Multiple',
            note: 'two Bars, no stackId',
            child: ChartStateSwitch(
              groupLabel: 'Multiple — chart state',
              skeleton: ChartSkeletonKind.bar,
              child: _barMultiple(ink),
            ),
          ),
          Panel(
            label: 'Stacked',
            note: 'three Bars sharing a stackId',
            child: ChartStateSwitch(
              groupLabel: 'Stacked — chart state',
              skeleton: ChartSkeletonKind.bar,
              child: _barStacked(ink),
            ),
          ),
          Panel(
            label: 'Label',
            note: 'LabelList on the bar',
            child: ChartStateSwitch(
              groupLabel: 'Label — chart state',
              skeleton: ChartSkeletonKind.bar,
              child: _barLabel(ink, theme),
            ),
          ),
          Panel(
            label: 'Custom label',
            note: 'LabelList with a render function',
            child: ChartStateSwitch(
              groupLabel: 'Custom label — chart state',
              skeleton: ChartSkeletonKind.bar,
              child: _barLabelCustom(ink, theme),
            ),
          ),
          Panel(
            label: 'Mixed',
            note: 'one Bar, a colour per datum',
            child: ChartStateSwitch(
              groupLabel: 'Mixed — chart state',
              skeleton: ChartSkeletonKind.bar,
              child: _barMixed(ink),
            ),
          ),
          Panel(
            label: 'Active',
            note: 'activeIndex highlights one',
            child: ChartStateSwitch(
              groupLabel: 'Active — chart state',
              skeleton: ChartSkeletonKind.bar,
              child: _barActive(ink),
            ),
          ),
          Panel(
            label: 'Negative',
            note: 'values below zero — direction by position, not by red',
            child: ChartStateSwitch(
              groupLabel: 'Negative — chart state',
              skeleton: ChartSkeletonKind.bar,
              child: _barNegative(ink, theme),
            ),
          ),
          Panel(
            label: 'Interactive',
            note: 'series picker, travelling pill',
            child: ChartStateSwitch(
              groupLabel: 'Interactive — chart state',
              skeleton: ChartSkeletonKind.bar,
              controls: (BuildContext context, Widget child) => _SeriesStrip(
                ink: ink,
                slot: 'bar-series-option',
                child: child,
              ),
              child: Builder(
                builder: (BuildContext context) =>
                    _barInteractive(context, ink),
              ),
            ),
          ),
        ]),
        SizedBox(height: space(4)),
        const Note(
          title: 'Why these bars have square corners',
          child: _SquareCorners(),
        ),
        SizedBox(height: space(4)),
        Meta(
          items: <MetaItem>[
            _meta(
              'layout',
              'horizontal (default) or vertical. vertical is the one that '
                  'draws horizontal bars: it names the axis the CATEGORIES '
                  'run along, not the direction the bars point.',
            ),
            _meta(
              'XAxis / YAxis type',
              'number or category. Swapping the layout means swapping these '
                  'too — the horizontal specimen above sets XAxis type=number '
                  'and YAxis type=category.',
            ),
            _meta(
              'stackId',
              'Same rule as Area. Without one, bars sit side by side in a '
                  'group.',
            ),
            _meta(
              'CartesianGrid',
              'vertical={false} for a vertical bar chart, horizontal={false} '
                  'for a rotated one — the gridlines you want are the ones '
                  'crossing the bars, not running along them.',
            ),
            _meta(
              'hide',
              'On an axis, keeps the scale and drops the labels. The '
                  'horizontal specimen hides its value axis because the '
                  'tooltip already carries the number.',
            ),
          ],
        ),
      ],
    ),
  );
}

/// The note the port has to contradict, and says so.
///
/// The reference's bars ARE square, because `radius` is a number of pixels and
/// typing one would restate `--radius-sm` in a prop no guard reads. `bar.tsx`
/// then solved exactly that by reading the token off the live stylesheet, and
/// the note above it was never rewritten: so the page explains square corners
/// under a chart that has rounded ones. Both ship: the corners are the token,
/// the copy is the reference's.
class _SquareCorners extends StatelessWidget {
  const _SquareCorners();

  @override
  Widget build(BuildContext context) => RichText(
    TextSpan(
      children: <InlineSpan>[
        const TextSpan(
          text:
              'Recharts takes a bar’s corner radius as a number of '
              'pixels — ',
        ),
        Code.span('radius'),
        const TextSpan(text: ' is typed '),
        Code.span('RectRadius'),
        const TextSpan(
          text: ', a number or four of them, with no string form. Writing ',
        ),
        Code.span('radius={6}'),
        const TextSpan(text: ' there restates '),
        Code.span('--radius-sm'),
        const TextSpan(
          text:
              ' as a literal, in a prop no guard reads — the same failure '
              'the whole Animation section is about. It could be read off '
              'the stylesheet exactly as the duration is; that is simply a '
              'hook this page does not have, because motion was the thing '
              'worth solving first. Until it exists the bars are square, '
              'and that is a decision rather than an omission.',
        ),
      ],
    ),
    TextStyles.small,
  );
}

class _LineSection extends StatelessWidget {
  const _LineSection({required this.ink, required this.theme});

  final ChartInk ink;
  final ThemeTokens theme;

  @override
  Widget build(BuildContext context) => Section(
    id: 'line',
    title: 'Line',
    description:
        'Trend over an ordered axis, and the default choice for more than '
        'two series — three stacked areas fight each other for the same '
        'pixels, three lines do not.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _specimenGrid(<Widget>[
          Panel(
            label: 'Default',
            note: 'dot={false}',
            child: ChartStateSwitch(
              groupLabel: 'Default — chart state',
              skeleton: ChartSkeletonKind.line,
              child: _lineDefault(ink),
            ),
          ),
          Panel(
            label: 'Linear',
            note: 'type=linear',
            child: ChartStateSwitch(
              groupLabel: 'Linear — chart state',
              skeleton: ChartSkeletonKind.line,
              child: _lineLinear(ink),
            ),
          ),
          Panel(
            label: 'Step',
            note: 'type=step',
            child: ChartStateSwitch(
              groupLabel: 'Step — chart state',
              skeleton: ChartSkeletonKind.line,
              child: _lineStep(ink),
            ),
          ),
          Panel(
            label: 'Multi-series',
            note: 'three lines, three tokens',
            child: ChartStateSwitch(
              groupLabel: 'Multi-series — chart state',
              skeleton: ChartSkeletonKind.line,
              child: _lineMultiple(ink),
            ),
          ),
          Panel(
            label: 'Dots',
            note: 'a dot on every point',
            child: ChartStateSwitch(
              groupLabel: 'Dots — chart state',
              skeleton: ChartSkeletonKind.line,
              child: _lineDots(ink),
            ),
          ),
          Panel(
            label: 'Custom dots',
            note: 'dot as a render function',
            child: ChartStateSwitch(
              groupLabel: 'Custom dots — chart state',
              skeleton: ChartSkeletonKind.line,
              child: _lineDotsCustom(ink, theme),
            ),
          ),
          Panel(
            label: 'Dot colours',
            note: 'a token per dot',
            child: ChartStateSwitch(
              groupLabel: 'Dot colours — chart state',
              skeleton: ChartSkeletonKind.line,
              child: _lineDotsColors(ink),
            ),
          ),
          Panel(
            label: 'Label',
            note: 'LabelList above the line',
            child: ChartStateSwitch(
              groupLabel: 'Label — chart state',
              skeleton: ChartSkeletonKind.line,
              child: _lineLabel(ink, theme),
            ),
          ),
          Panel(
            label: 'Custom label',
            note: 'LabelList with a render function',
            child: ChartStateSwitch(
              groupLabel: 'Custom label — chart state',
              skeleton: ChartSkeletonKind.line,
              child: _lineLabelCustom(ink, theme),
            ),
          ),
          Panel(
            label: 'Interactive',
            note: 'series picker, travelling pill',
            child: ChartStateSwitch(
              groupLabel: 'Interactive — chart state',
              skeleton: ChartSkeletonKind.line,
              controls: (BuildContext context, Widget child) => _SeriesStrip(
                ink: ink,
                slot: 'line-series-option',
                child: child,
              ),
              child: Builder(
                builder: (BuildContext context) =>
                    _lineInteractive(context, ink),
              ),
            ),
          ),
        ]),
        SizedBox(height: space(4)),
        Meta(
          items: <MetaItem>[
            _meta(
              'dot',
              'false, true, an object of SVG props, or a render function. '
                  'Turn dots on when the reader is meant to read individual '
                  'points; leave them off when the shape is the message and '
                  'the points are noise.',
            ),
            _meta(
              'activeDot',
              "The dot the tooltip highlights. Left at recharts' default "
                  'here — overriding it means typing a radius in pixels.',
            ),
            _meta(
              'stroke',
              'The series colour. Lines have no fill, so this is the only '
                  'place the token appears — and it is what the legend swatch '
                  'and the tooltip indicator both read back.',
            ),
            _meta(
              'connectNulls',
              'Off by default, and usually right: a gap in the data should '
                  'look like a gap. Turn it on only when the missing point is '
                  'known to be missing rather than unknown.',
            ),
          ],
        ),
      ],
    ),
  );
}

class _PieSection extends StatelessWidget {
  const _PieSection({required this.ink, required this.theme});

  final ChartInk ink;
  final ThemeTokens theme;

  @override
  Widget build(BuildContext context) => Section(
    id: 'pie',
    title: 'Pie',
    description:
        'Parts of one whole, and only when the parts genuinely sum to that '
        'whole. Five slices is already near the ceiling — past that a bar '
        'chart is easier to read and easier to label.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _specimenGrid(<Widget>[
          Panel(
            label: 'Simple',
            note: 'fill carried on each datum',
            child: ChartStateSwitch(
              groupLabel: 'Simple — chart state',
              skeleton: ChartSkeletonKind.pie,
              child: _pieSimple(ink),
            ),
          ),
          Panel(
            label: 'No separator',
            note: 'paddingAngle={0}',
            child: ChartStateSwitch(
              groupLabel: 'No separator — chart state',
              skeleton: ChartSkeletonKind.pie,
              child: _pieSeparatorNone(ink),
            ),
          ),
          Panel(
            label: 'Label',
            note: 'labels outside, with leader lines',
            child: ChartStateSwitch(
              groupLabel: 'Label — chart state',
              skeleton: ChartSkeletonKind.pie,
              child: _pieLabel(ink, theme),
            ),
          ),
          Panel(
            label: 'Custom label',
            note: 'label as a render function',
            child: ChartStateSwitch(
              groupLabel: 'Custom label — chart state',
              skeleton: ChartSkeletonKind.pie,
              child: _pieLabelCustom(ink, theme),
            ),
          ),
          Panel(
            label: 'Label list',
            note: 'on a card chip — the fill cannot clear AA',
            child: ChartStateSwitch(
              groupLabel: 'Label list — chart state',
              skeleton: ChartSkeletonKind.pie,
              child: _pieLabelList(ink),
            ),
          ),
          Panel(
            label: 'Legend',
            note: 'ChartLegendContent, no tooltip',
            child: ChartStateSwitch(
              groupLabel: 'Legend — chart state',
              skeleton: ChartSkeletonKind.pie,
              child: _pieLegend(ink),
            ),
          ),
          Panel(
            label: 'Donut',
            note: 'innerRadius as a percentage',
            child: ChartStateSwitch(
              groupLabel: 'Donut — chart state',
              skeleton: ChartSkeletonKind.pie,
              child: _pieDonut(ink),
            ),
          ),
          Panel(
            label: 'Donut, active',
            note: 'activeIndex grows one slice',
            child: ChartStateSwitch(
              groupLabel: 'Donut, active — chart state',
              skeleton: ChartSkeletonKind.pie,
              child: _pieDonutActive(ink),
            ),
          ),
          Panel(
            label: 'Donut with text',
            note: 'the total in the hole',
            child: ChartStateSwitch(
              groupLabel: 'Donut with text — chart state',
              skeleton: ChartSkeletonKind.pie,
              child: _pieDonutText(ink),
            ),
          ),
          Panel(
            label: 'Stacked',
            note: 'two rings, one chart',
            child: ChartStateSwitch(
              groupLabel: 'Stacked — chart state',
              skeleton: ChartSkeletonKind.pie,
              child: _pieStacked(ink),
            ),
          ),
          Panel(
            label: 'Interactive',
            note: 'slice picker, travelling pill',
            child: ChartStateSwitch(
              groupLabel: 'Interactive — chart state',
              skeleton: ChartSkeletonKind.pie,
              controls: (BuildContext context, Widget child) => _PieInteractive(
                ink: ink,
                builder: (BuildContext context, int index) =>
                    _PieActiveScope(index: index, child: child),
              ),
              child: Builder(
                builder: (BuildContext context) =>
                    _pieInteractive(context, ink, _PieActiveScope.of(context)),
              ),
            ),
          ),
        ]),
        SizedBox(height: space(4)),
        Meta(
          items: <MetaItem>[
            _meta(
              'dataKey / nameKey',
              'dataKey is the number that sizes the slice; nameKey is the '
                  'string that names it. Pass nameKey to ChartTooltipContent '
                  'and ChartLegendContent too, or both fall back to the value '
                  'key and every row reads "Cards".',
            ),
            _meta(
              'fill',
              'Per slice, carried on the datum itself rather than on the Pie '
                  '— a Pie has one dataKey and many colours, which is the one '
                  'place the colour belongs to the data.',
            ),
            _meta(
              'innerRadius / outerRadius',
              'Percentages, never pixels. A fraction of the plot is derived '
                  'from the container, so it holds at every breakpoint and '
                  'never restates a spacing step.',
            ),
            _meta(
              'label / labelLine',
              'label renders the value outside the arc; labelLine draws the '
                  'leader to it. Leave room by pulling outerRadius in, or the '
                  'labels clip against the container.',
            ),
          ],
        ),
      ],
    ),
  );
}

/// The active slice, handed down through the keyed slot.
class _PieActiveScope extends InheritedWidget {
  const _PieActiveScope({required this.index, required super.child});

  final int index;

  static int of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_PieActiveScope>()?.index ?? 0;

  @override
  bool updateShouldNotify(_PieActiveScope old) => old.index != index;
}

class _RadarSection extends StatelessWidget {
  const _RadarSection({required this.ink, required this.theme});

  final ChartInk ink;
  final ThemeTokens theme;

  @override
  Widget build(BuildContext context) => Section(
    id: 'radar',
    title: 'Radar',
    description:
        'One subject measured on several axes at once, and best when the '
        'shape is the point — comparing two profiles rather than reading '
        'any single number off the grid.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _specimenGrid(<Widget>[
          Panel(
            label: 'Default',
            note: 'polygon grid, radial lines on',
            child: ChartStateSwitch(
              groupLabel: 'Default — chart state',
              skeleton: ChartSkeletonKind.radar,
              child: _radarDefault(ink),
            ),
          ),
          Panel(
            label: 'Dots',
            note: 'a dot at every vertex',
            child: ChartStateSwitch(
              groupLabel: 'Dots — chart state',
              skeleton: ChartSkeletonKind.radar,
              child: _radarDots(ink),
            ),
          ),
          Panel(
            label: 'Lines only',
            note: 'stroke, no fill',
            child: ChartStateSwitch(
              groupLabel: 'Lines only — chart state',
              skeleton: ChartSkeletonKind.radar,
              child: _radarLinesOnly(ink),
            ),
          ),
          Panel(
            label: 'Custom label',
            note: 'PolarAngleAxis tick as a render function',
            child: ChartStateSwitch(
              groupLabel: 'Custom label — chart state',
              skeleton: ChartSkeletonKind.radar,
              child: _radarLabelCustom(ink),
            ),
          ),
          Panel(
            label: 'Custom grid',
            note: 'PolarGrid with its own stroke',
            child: ChartStateSwitch(
              groupLabel: 'Custom grid — chart state',
              skeleton: ChartSkeletonKind.radar,
              child: _radarGridCustom(ink),
            ),
          ),
          Panel(
            label: 'No grid',
            note: 'PolarGrid omitted',
            child: ChartStateSwitch(
              groupLabel: 'No grid — chart state',
              skeleton: ChartSkeletonKind.radar,
              child: _radarGridNone(ink),
            ),
          ),
          Panel(
            label: 'Circle grid',
            note: 'gridType=circle',
            child: ChartStateSwitch(
              groupLabel: 'Circle grid — chart state',
              skeleton: ChartSkeletonKind.radar,
              child: _radarGridCircle(ink),
            ),
          ),
          Panel(
            label: 'Circle, no lines',
            note: 'circle grid, radialLines={false}',
            child: ChartStateSwitch(
              groupLabel: 'Circle, no lines — chart state',
              skeleton: ChartSkeletonKind.radar,
              child: _radarGridCircleNoLines(ink),
            ),
          ),
          Panel(
            label: 'Circle, filled',
            note: 'circle grid with a fill',
            child: ChartStateSwitch(
              groupLabel: 'Circle, filled — chart state',
              skeleton: ChartSkeletonKind.radar,
              child: _radarGridCircleFill(ink),
            ),
          ),
          Panel(
            label: 'Polygon, filled',
            note: 'polygon grid with a fill',
            child: ChartStateSwitch(
              groupLabel: 'Polygon, filled — chart state',
              skeleton: ChartSkeletonKind.radar,
              child: _radarGridFill(ink),
            ),
          ),
          Panel(
            label: 'Multiple',
            note: 'two profiles overlaid',
            child: ChartStateSwitch(
              groupLabel: 'Multiple — chart state',
              skeleton: ChartSkeletonKind.radar,
              child: _radarMultiple(ink),
            ),
          ),
          Panel(
            label: 'Legend',
            note: 'ChartLegendContent under the web',
            child: ChartStateSwitch(
              groupLabel: 'Legend — chart state',
              skeleton: ChartSkeletonKind.radar,
              child: _radarLegend(ink),
            ),
          ),
          Panel(
            label: 'Icons',
            note: 'config icons in the legend',
            child: ChartStateSwitch(
              groupLabel: 'Icons — chart state',
              skeleton: ChartSkeletonKind.radar,
              child: _radarIcons(ink),
            ),
          ),
          Panel(
            label: 'Radius axis',
            note: 'PolarRadiusAxis shown',
            child: ChartStateSwitch(
              groupLabel: 'Radius axis — chart state',
              skeleton: ChartSkeletonKind.radar,
              child: _radarRadius(ink, theme),
            ),
          ),
        ]),
        SizedBox(height: space(4)),
        Meta(
          items: <MetaItem>[
            _meta(
              'PolarGrid gridType',
              'polygon (default) or circle. Polygon makes the vertices — the '
                  'actual axes — easy to find; circle is quieter and reads '
                  'better with two overlapping series.',
            ),
            _meta(
              'PolarGrid radialLines',
              'The spokes. Turning them off with a circle grid leaves rings '
                  'only, which is the calmest of the four combinations.',
            ),
            _meta(
              'PolarAngleAxis dataKey',
              'The field naming each axis. Without it the axes are numbered '
                  'and the chart says nothing.',
            ),
            _meta(
              'PolarRadiusAxis',
              'The scale running out from the centre. Usually hidden — '
                  'tick={false} axisLine={false} — because a radar is read as '
                  'a shape, not as five separate readings.',
            ),
            _meta(
              'fillOpacity',
              'Two overlapping radars need both fills translucent or the '
                  'second one erases the first.',
            ),
          ],
        ),
      ],
    ),
  );
}

class _RadialSection extends StatelessWidget {
  const _RadialSection({required this.ink, required this.theme});

  final ChartInk ink;
  final ThemeTokens theme;

  @override
  Widget build(BuildContext context) => Section(
    id: 'radial',
    title: 'Radial',
    description:
        'A bar chart bent around a circle. It buys compactness and costs '
        'accuracy — the outer ring is longer than the inner one at the '
        'same value — so use it for a gauge or a rough share, never for a '
        'comparison the reader has to trust.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _specimenGrid(<Widget>[
          Panel(
            label: 'Simple',
            note: 'background rings, one bar per tier',
            child: ChartStateSwitch(
              groupLabel: 'Simple — chart state',
              skeleton: ChartSkeletonKind.radial,
              child: _radialSimple(ink),
            ),
          ),
          Panel(
            label: 'Grid',
            note: 'PolarGrid inside the ring',
            child: ChartStateSwitch(
              groupLabel: 'Grid — chart state',
              skeleton: ChartSkeletonKind.radial,
              child: _radialGrid(ink),
            ),
          ),
          Panel(
            label: 'Label',
            note: 'on a card chip — the arc cannot clear AA',
            child: ChartStateSwitch(
              groupLabel: 'Label — chart state',
              skeleton: ChartSkeletonKind.radial,
              child: _radialLabel(ink),
            ),
          ),
          Panel(
            label: 'Text',
            note: 'the total in the hole',
            child: ChartStateSwitch(
              groupLabel: 'Text — chart state',
              skeleton: ChartSkeletonKind.radial,
              child: _radialText(ink, theme),
            ),
          ),
          Panel(
            label: 'Shape',
            note: 'a custom activeShape',
            child: ChartStateSwitch(
              groupLabel: 'Shape — chart state',
              skeleton: ChartSkeletonKind.radial,
              child: _radialShape(ink, theme),
            ),
          ),
          Panel(
            label: 'Stacked half-gauge',
            note: 'startAngle 180 → endAngle 0',
            child: ChartStateSwitch(
              groupLabel: 'Stacked half-gauge — chart state',
              skeleton: ChartSkeletonKind.radial,
              child: _radialStacked(ink),
            ),
          ),
        ]),
        SizedBox(height: space(4)),
        const Note(
          tone: NoteTone.error,
          title: 'A stacked radial does not widen its own angle axis',
          child: _StackedRadialNote(),
        ),
        SizedBox(height: space(4)),
        Meta(
          items: <MetaItem>[
            _meta(
              'innerRadius / outerRadius',
              'On the RadialBarChart, not on the bar. Percentages again. A '
                  'wide gap between them gives thick rings; a narrow one '
                  'gives a dial.',
            ),
            _meta(
              'background',
              'Draws the unfilled remainder of each ring. ChartContainer '
                  'already paints it --muted, so it needs no colour of its '
                  'own.',
            ),
            _meta(
              'startAngle / endAngle',
              "Degrees, counter-clockwise from three o'clock. 180 → 0 is the "
                  'top half. Angles are not a token family, so these are '
                  'written plainly.',
            ),
            _meta(
              'stackId',
              'Stacks around the arc rather than up a column. With one datum '
                  'and three keys, that is a single segmented gauge.',
            ),
          ],
        ),
      ],
    ),
  );
}

class _StackedRadialNote extends StatelessWidget {
  const _StackedRadialNote();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      RichText(
        TextSpan(
          children: <InlineSpan>[
            const TextSpan(
              text:
                  'Left alone it silently drew one third of its data. The '
                  'angle axis domain runs to the largest single series '
                  'rather than to the stack total, so the first ring filled '
                  'the whole sweep and the two behind it were clipped to '
                  'nothing — no error, no warning, and a legend that still '
                  'listed all three. The fix is an explicit ',
            ),
            Code.span('<PolarAngleAxis type="number" domain={[0, total]} />'),
            const TextSpan(
              text:
                  ', with the total summed from the data rather than '
                  'typed, so it cannot fall out of step with it.',
            ),
          ],
        ),
        TextStyles.small,
      ),
      SizedBox(height: space(3)),
      RichText(
        TextSpan(
          children: <InlineSpan>[
            const TextSpan(
              text:
                  'The legend came off for a second reason: with one '
                  'datum and three series keys, ',
            ),
            Code.span('ChartLegendContent'),
            const TextSpan(
              text:
                  ' renders an empty row — a radial legend’s payload is '
                  'built per datum, not per series. The tooltip carries the '
                  'three names instead.',
            ),
          ],
        ),
        TextStyles.small,
      ),
    ],
  );
}

class _TooltipSection extends StatelessWidget {
  const _TooltipSection({required this.ink});

  final ChartInk ink;

  @override
  Widget build(BuildContext context) => Section(
    id: 'tooltips-legends',
    title: 'Tooltips & legends',
    description:
        'The two pieces of a chart that are made of text, and therefore '
        'the two that have to answer to §7. Hover any of these — the '
        'indicator shape is the only difference between them.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _specimenGrid(<Widget>[
          Panel(
            label: 'Default',
            note: 'ChartTooltipContent, dot indicator',
            child: ChartStateSwitch(
              groupLabel: 'Default — chart state',
              skeleton: ChartSkeletonKind.tooltip,
              child: _tooltipDefault(ink),
            ),
          ),
          Panel(
            label: 'Line indicator',
            note: 'indicator=line',
            child: ChartStateSwitch(
              groupLabel: 'Line indicator — chart state',
              skeleton: ChartSkeletonKind.tooltip,
              child: _tooltipIndicatorLine(ink),
            ),
          ),
          Panel(
            label: 'No indicator',
            note: 'hideIndicator',
            child: ChartStateSwitch(
              groupLabel: 'No indicator — chart state',
              skeleton: ChartSkeletonKind.tooltip,
              child: _tooltipIndicatorNone(ink),
            ),
          ),
          Panel(
            label: 'Custom label',
            note: 'labelKey plus a config label',
            child: ChartStateSwitch(
              groupLabel: 'Custom label — chart state',
              skeleton: ChartSkeletonKind.tooltip,
              child: _tooltipLabelCustom(ink),
            ),
          ),
          Panel(
            label: 'Label formatter',
            note: 'labelFormatter',
            child: ChartStateSwitch(
              groupLabel: 'Label formatter — chart state',
              skeleton: ChartSkeletonKind.tooltip,
              child: _tooltipLabelFormatter(ink),
            ),
          ),
          Panel(
            label: 'No label',
            note: 'hideLabel',
            child: ChartStateSwitch(
              groupLabel: 'No label — chart state',
              skeleton: ChartSkeletonKind.tooltip,
              child: _tooltipLabelNone(ink),
            ),
          ),
          Panel(
            label: 'Formatter',
            note: 'formatter render function',
            child: ChartStateSwitch(
              groupLabel: 'Formatter — chart state',
              skeleton: ChartSkeletonKind.tooltip,
              child: _tooltipFormatter(ink),
            ),
          ),
          Panel(
            label: 'Icons',
            note: 'config icons in the rows',
            child: ChartStateSwitch(
              groupLabel: 'Icons — chart state',
              skeleton: ChartSkeletonKind.tooltip,
              child: _tooltipIcons(ink),
            ),
          ),
          Panel(
            label: 'Advanced',
            note: 'formatter with a running total',
            child: ChartStateSwitch(
              groupLabel: 'Advanced — chart state',
              skeleton: ChartSkeletonKind.tooltip,
              child: _tooltipAdvanced(ink),
            ),
          ),
        ]),
        SizedBox(height: space(4)),
        const Note(
          title: 'ChartConfig is what makes a tooltip readable',
          child: _ConfigNote(),
        ),
        SizedBox(height: space(4)),
        const Note(
          tone: NoteTone.value,
          title: 'Why the fills here do not go through ChartStyle',
          child: _ChartStyleNote(),
        ),
        SizedBox(height: space(4)),
        const Note(
          tone: NoteTone.error,
          title: 'Building this page found two live AA failures in chart text',
          child: _AaNote(),
        ),
        SizedBox(height: space(4)),
        Meta(
          items: <MetaItem>[
            _meta(
              'ChartTooltip',
              "Recharts' Tooltip, re-exported unchanged. Pass "
                  'content={<ChartTooltipContent />} — on its own it renders '
                  "recharts' stock panel, which is on none of these tokens.",
            ),
            _meta(
              'ChartTooltipContent indicator',
              'dot (default) · line · dashed. Cosmetic, except that dashed '
                  'conventionally marks a projection — do not spend it on a '
                  'plain second series.',
            ),
            _meta(
              'hideLabel / hideIndicator',
              'hideLabel drops the header row, which is right when the '
                  'category is already on the axis under the cursor. '
                  'hideIndicator drops the colour chip.',
            ),
            _meta(
              'nameKey / labelKey',
              'Which field to look up in the config. Pies and radial bars '
                  'almost always need nameKey, because their series key is '
                  'the value and their name lives on the datum.',
            ),
            _meta(
              'ChartLegend',
              "Recharts' Legend, re-exported. Same rule: "
                  'content={<ChartLegendContent />} or it renders unstyled.',
            ),
            _meta(
              'formatter',
              'Takes (value, name, item, index, payload). Use it for currency '
                  'and units — a bare number in a tooltip is the most common '
                  'way a chart is misread.',
            ),
          ],
        ),
      ],
    ),
  );
}

class _ConfigNote extends StatelessWidget {
  const _ConfigNote();

  @override
  Widget build(BuildContext context) => RichText(
    TextSpan(
      children: <InlineSpan>[
        const TextSpan(text: 'Without it a tooltip row says '),
        Code.span('sealed'),
        const TextSpan(text: ', because that is the key in the data. '),
        Code.span('ChartConfig'),
        const TextSpan(text: ' maps every series key to a '),
        Code.span('label'),
        const TextSpan(text: ' and a '),
        Code.span('color'),
        const TextSpan(text: ', and both '),
        Code.span('ChartTooltipContent'),
        const TextSpan(text: ' and '),
        Code.span('ChartLegendContent'),
        const TextSpan(
          text:
              ' read it out of context. It is the one piece of a chart '
              'that is worth writing before the chart itself.',
        ),
      ],
    ),
    TextStyles.small,
  );
}

class _ChartStyleNote extends StatelessWidget {
  const _ChartStyleNote();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      RichText(
        TextSpan(
          children: <InlineSpan>[
            const TextSpan(text: 'shadcn’s '),
            Code.span('ChartStyle'),
            const TextSpan(text: ' mints a '),
            Code.span('--color-<seriesKey>'),
            const TextSpan(
              text:
                  ' per container so one config can carry a light value '
                  'and a dark one. This system does not need that second '
                  'layer: ',
            ),
            Code.span('--chart-1'),
            const TextSpan(text: ' … '),
            Code.span('-5'),
            const TextSpan(
              text:
                  ' are already declared once in each theme block, so a '
                  'series that names ',
            ),
            Code.span('var(--color-chart-1)'),
            const TextSpan(text: ' gets the per-theme value for free.'),
          ],
        ),
        TextStyles.small,
      ),
      SizedBox(height: space(3)),
      RichText(
        TextSpan(
          children: <InlineSpan>[
            const TextSpan(
              text:
                  'It is also the difference between a reference the '
                  'guards can see and one they cannot. A fill naming ',
            ),
            Code.span('--color-sealed'),
            const TextSpan(
              text:
                  ', copied out of a shadcn example, reaches a custom '
                  'property that exists only inside a ',
            ),
            Code.span('<style>'),
            const TextSpan(text: ' tag injected at runtime — '),
            Code.span('check:refs'),
            const TextSpan(
              text:
                  ' reports it as undeclared, and it is right to. If you '
                  'want the per-series indirection, the fix is to declare '
                  'the names, not to widen the guard.',
            ),
          ],
        ),
        TextStyles.small,
      ),
      SizedBox(height: space(3)),
      RichText(
        TextSpan(
          children: <InlineSpan>[
            const TextSpan(
              text:
                  'This paragraph proved it on the way in. It first '
                  'spelled the example out as a full ',
            ),
            Code.span('var(…)'),
            const TextSpan(text: ' call, and '),
            Code.span('check:refs'),
            const TextSpan(
              text:
                  ' failed the build on this page’s own documentation — '
                  'which is the guard reading source rather than intent, '
                  'exactly as designed.',
            ),
          ],
        ),
        TextStyles.small,
      ),
    ],
  );
}

class _AaNote extends StatelessWidget {
  const _AaNote();

  /// recharts' own inline default fills, quoted as the evidence for the two
  /// contrast failures they caused. Third-party literals this page is
  /// documenting, not colours it is choosing.
  // allow-hardcoded: recharts' own inline default tick fill, quoted as copy.
  static const String rechartsTickFill = '#666';

  // allow-hardcoded: the same exemption, for the polar tick's default fill.
  static const String rechartsPolarFill = '#808080';

  @override
  Widget build(BuildContext context) {
    final TextStyle base = StyledText.styleOf(context, TextStyles.small);
    final ThemeTokens theme = ThemeScope.of(context);
    final TextStyle strong = base.copyWith(
      color: theme.foreground,
      fontWeight: FontWeight.bold,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          TextSpan(
            children: <InlineSpan>[
              const TextSpan(
                text:
                    'Both were invisible to every guard in the repository, '
                    'because recharts writes the colour as an inline ',
              ),
              Code.span('fill'),
              const TextSpan(
                text:
                    ' attribute on the SVG. They were found by rasterising '
                    'the rendered pixels in both themes — the only method that '
                    'works here, since a ',
              ),
              Code.span('color-mix()'),
              const TextSpan(text: ' read as text parses as '),
              Code.span('oklab()'),
              const TextSpan(text: ' and not as RGB.'),
            ],
          ),
          TextStyles.small,
        ),
        SizedBox(height: space(3)),
        RichText(
          TextSpan(
            children: <InlineSpan>[
              TextSpan(
                text: 'Axis labels were not on a token at all.',
                style: strong,
              ),
              const TextSpan(text: ' '),
              Code.span('chart.tsx'),
              const TextSpan(text: ' carries '),
              Code.span(
                '[&_.recharts-cartesian-axis-tick_text]:fill-muted-foreground',
              ),
              const TextSpan(
                text: ', and recharts 3.8 renders the label inside ',
              ),
              Code.span('.recharts-cartesian-axis-tick-label'),
              const TextSpan(text: ' with the class '),
              Code.span('.recharts-cartesian-axis-tick-value'),
              const TextSpan(text: ' on the '),
              Code.span('<text>'),
              const TextSpan(
                text:
                    '. The selector matched nothing, so every one of the 78 '
                    'axis labels on this page kept recharts’ own ',
              ),
              Code.span(rechartsTickFill),
              const TextSpan(
                text:
                    ' — 3.46:1 in dark, 5.74:1 in light — and the polar ticks '
                    'kept ',
              ),
              Code.span(rechartsPolarFill),
              const TextSpan(
                text:
                    ', 5.04:1 dark and 3.95:1 light. Each theme was failing '
                    'AA on one of the two. On ',
              ),
              Code.span('--muted-foreground'),
              const TextSpan(text: ' they now measure 13.46:1 and 4.83:1.'),
            ],
          ),
          TextStyles.small,
        ),
        SizedBox(height: space(3)),
        RichText(
          TextSpan(
            children: <InlineSpan>[
              TextSpan(
                text: 'Pie labels took their slice’s colour.',
                style: strong,
              ),
              const TextSpan(text: ' Against '),
              Code.span('--background'),
              const TextSpan(
                text:
                    ' the five chart tokens measure 4.34 · 10.75 · 1.88 · '
                    '13.19 · 3.98 in dark and 4.58 · 10.58 · 1.85 · 4.99 · 1.51 '
                    'in light. Three of five fail as text in dark, two in '
                    'light. A fill is not text and is not held to that '
                    'threshold — which is exactly why a chart token must not be '
                    'reused as a label colour. The labelled pie sets ',
              ),
              Code.span('--foreground'),
              const TextSpan(
                text: ' instead and keeps the slice colour on the leader line.',
              ),
            ],
          ),
          TextStyles.small,
        ),
      ],
    );
  }
}

/* ── Animation ───────────────────────────────────────────────────────────── */

/// The reason this page exists.
///
/// The readout prints what the port actually resolved, exactly as
/// `MotionReadout` prints what the hook resolved, *"nothing on this row is
/// typed by hand, so the page cannot claim a timing the code did not use."*
class _AnimationSection extends StatelessWidget {
  const _AnimationSection();

  @override
  Widget build(BuildContext context) => Section(
    id: 'animation',
    title: 'Animation',
    description:
        'The reason this page exists. Every other component in this system '
        'declares its motion as a class, which check:tokens can read. '
        'Recharts cannot be told anything in classes, so its motion is read '
        'out of the stylesheet at runtime instead — and one half of that '
        'read failed, which is documented here rather than hidden.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const Note(
          title: 'The guard is the enforcement, not the rule',
          child: _GuardNote(),
        ),
        SizedBox(height: space(6)),
        _AnimationHeading('What the hook resolved, live'),
        SizedBox(height: space(3)),
        const _MotionReadout(),
        SizedBox(height: space(8)),
        _AnimationHeading('Why slow, and not base or jelly'),
        SizedBox(height: space(3)),
        const _WhySlow(),
        SizedBox(height: space(8)),
        _AnimationHeading('Why ease-out, and not ease-spring'),
        SizedBox(height: space(3)),
        const _Prose(
          '{--ease-spring} overshoots and settles, and that is exactly what '
          'makes it wrong here. A bar that overshoots its own value shows the '
          'reader a number the data does not contain — for about ninety '
          'milliseconds, the chart is lying. Springs are for controls, where '
          'the overshoot carries no meaning because a button has no value to '
          'exceed. Everything that draws data decelerates into its final '
          'position and stops.',
        ),
        SizedBox(height: space(8)),
        _AnimationHeading(
          'The curve did not make it through. Only the keyword did.',
        ),
        SizedBox(height: space(3)),
        const _CurveFailed(),
        SizedBox(height: space(8)),
        _AnimationHeading(
          'Reduced motion is resolved in the hook, and not for the reason '
          'you would expect',
        ),
        SizedBox(height: space(3)),
        const _ReducedMotion(),
        SizedBox(height: space(8)),
        _AnimationHeading('Why useSyncExternalStore'),
        SizedBox(height: space(3)),
        const _Prose(
          '{Bar} alone is wider. Its {animationEasing} is {EasingInput}, '
          'which is {NamedBezier | "spring" | EasingFunction}, and '
          '{NamedBezier} is those same five keywords plus one template '
          'literal: '
          '{`cubic-bezier(\${number},\${number},\${number},\${number})`}. Two '
          'things rule it out anyway. The template admits no spaces, and the '
          'token’s value has three of them. And a value read back from '
          '{getComputedStyle} is typed {string}, which is not assignable to a '
          'template literal type however it is spelled.',
        ),
        SizedBox(height: space(8)),
        _AnimationHeading(
          'The tooltip too — and its default only looked right',
        ),
        SizedBox(height: space(3)),
        const _Prose(
          'So the duration is read from the system and the curve is not. What '
          'is passed is the keyword {ease-out}, which names the token rather '
          'than copying its value. The two are not the same curve — the row '
          'above prints both, and they visibly differ. The alternatives were '
          'worse: a cast puts a string recharts’ own parser may not read into '
          'a typed slot and calls it safe, and writing the four control '
          'points out by hand duplicates a token as a literal, which is the '
          'exact drift {check:tokens} exists to catch.',
        ),
        SizedBox(height: space(8)),
        const Note(
          tone: NoteTone.value,
          title:
              'The two SSR fallbacks are duplicated token values, on purpose',
          child: _SsrNote(),
        ),
        SizedBox(height: space(6)),
        const DoDont(
          dos: <String>[
            'Call useChartMotion() once per demo and spread the whole result '
                'onto every animated element in it.',
            'Read a timing out of the stylesheet whenever a library takes it '
                'as a number rather than a class.',
            'Say on the page when a token could not be threaded through a '
                "library's types, and what was passed instead.",
            "Leave a numeric prop at the library's default rather than "
                'typing a value from one of the five token families into it.',
          ],
          donts: <String>[
            "Don't type animationDuration={800}. It passes check:tokens, "
                'check:refs, typecheck, lint and build, and it is still a '
                'violation of §0.',
            "Don't cast the token's cubic-bezier through `as` to satisfy the "
                'type. A cast makes a claim about a parser you have not '
                'tested.',
            "Don't write the four control points out by hand. That is a "
                'token duplicated as a literal, which is the drift the guard '
                'exists to catch.',
            "Don't assume the global reduced-motion rule covers a chart. It "
                'animates in JavaScript; CSS never sees it.',
          ],
        ),
      ],
    ),
  );
}

/// `h3.type-h4.text-foreground`.
class _AnimationHeading extends StatelessWidget {
  const _AnimationHeading(this.text);

  final String text;

  @override
  Widget build(BuildContext context) =>
      StyledText(text, TextStyles.h4, color: ThemeScope.of(context).foreground);
}

/// `max-w-3xl` on a block box, and why it is an [Align] rather than a bare
/// [ConstrainedBox].
///
/// CSS caps a block box's width and leaves it at the start of its line. A bare
/// [ConstrainedBox] handed a **tight** width: which is what every
/// `CrossAxisAlignment.stretch` column passes down, *enforces* that width and
/// the cap is silently lost. Measured before this existed: four of the
/// Animation section's thirteen paragraphs rendered at the full column instead
/// of 768 and wrapped five lines short, which is `selection.dart`'s `_measured`
/// trap exactly. [Align] is what turns the incoming constraint loose again.
Widget _capped(Widget child) => Align(
  alignment: Alignment.centerLeft,
  child: ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: _measure3xl),
    child: child,
  ),
);

/// `p.type-small.max-w-3xl`, with its `<Code>` chips marked in the copy.
///
/// **The chips are not decoration and dropping them changes the layout.** A
/// `Code` chip is `px-1.5` plus a hairline on each side, so every one of them
/// is ~13px wider than the same characters set as prose: and this section
/// carries about forty of them across six blocks. Written as plain strings the
/// Animation section measured **2439.9** against the reference's 2646.9, and
/// the whole page came out 227px short; the chips are most of that gap.
///
/// `{…}` in the template is a chip, `*…*` is an `<em>`, and `**…**` is a
/// `<strong>` stepping up to `--foreground`. Three markers, so the copy stays
/// one greppable string per paragraph instead of a span list nobody can read
/// against the reference.
class _Prose extends StatelessWidget {
  const _Prose(this.text);

  final String text;

  @override
  Widget build(BuildContext context) =>
      _capped(RichText(_markup(context, text), TextStyles.small));

  /// `{{…}}` is a chip whose own text contains braces: the one instance is
  /// the spread `{...motion}` the Animation section quotes.
  static final RegExp _marker = RegExp(
    r'\{\{(.*?)\}\}|\{([^{}]*)\}|\*\*([^*]*)\*\*|\*([^*]*)\*',
  );

  static InlineSpan _markup(BuildContext context, String source) {
    final ThemeTokens theme = ThemeScope.of(context);
    final TextStyle base = StyledText.styleOf(context, TextStyles.small);
    final List<InlineSpan> spans = <InlineSpan>[];
    int cursor = 0;
    for (final RegExpMatch match in _marker.allMatches(source)) {
      if (match.start > cursor) {
        spans.add(TextSpan(text: source.substring(cursor, match.start)));
      }
      final String? braced = match.group(1);
      final String? code = match.group(2);
      final String? strong = match.group(3);
      final String? emphasis = match.group(4);
      if (braced != null) {
        spans.add(Code.span('{$braced}'));
      } else if (code != null) {
        spans.add(Code.span(code));
      } else if (strong != null) {
        // Nested, because the reference puts `<Code>` chips inside its `<em>`
        // and `<strong>` runs and a flat scan would swallow the braces.
        spans.add(
          TextSpan(
            children: <InlineSpan>[_markup(context, strong)],
            style: base.copyWith(
              color: theme.foreground,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      } else if (emphasis != null) {
        spans.add(
          TextSpan(
            children: <InlineSpan>[_markup(context, emphasis)],
            style: base.copyWith(fontStyle: FontStyle.italic),
          ),
        );
      }
      cursor = match.end;
    }
    if (cursor < source.length) {
      spans.add(TextSpan(text: source.substring(cursor)));
    }
    return TextSpan(children: spans);
  }
}

class _GuardNote extends StatelessWidget {
  const _GuardNote();

  @override
  Widget build(BuildContext context) => RichText(
    TextSpan(
      children: <InlineSpan>[
        Code.span('check:tokens'),
        const TextSpan(
          text:
              ' scans classNames and CSS. A bare JavaScript number in a '
              'JSX prop slips past it completely. That does not make it '
              'allowed — §0 is the rule, and ',
        ),
        Code.span('animationDuration={800}'),
        const TextSpan(
          text:
              ' typed into a chart passes every guard in this repository '
              'and is still a violation. The whole of ',
        ),
        Code.span('components/space/chart-motion.ts'),
        const TextSpan(
          text:
              ' exists to make the right thing the easy thing: call the '
              'hook, spread the result, and there is no number left to type.',
        ),
      ],
    ),
    TextStyles.small,
  );
}

/// What the port actually resolved, printed rather than asserted.
class _MotionReadout extends StatelessWidget {
  const _MotionReadout();

  @override
  Widget build(BuildContext context) {
    final Duration resolved = effectiveMotionDuration(
      context,
      ChartMotion.duration,
    );
    return Meta(
      items: <MetaItem>[
        _meta(
          '--duration-slow',
          '${ChartMotion.duration.inMilliseconds}ms · '
              'named by ChartMotion, not read off a stylesheet',
        ),
        _meta(
          'animationDuration',
          '${resolved.inMilliseconds} · the number the entrance controller '
              'received, in milliseconds',
        ),
        _meta(
          '--ease-out',
          'cubic-bezier(0.22, 1, 0.36, 1) · the curve this should have used',
        ),
        _meta(
          'animationEasing',
          '"ease-out" · the keyword recharts received instead, because its '
              'types take no cubic-bezier here — reproduced as '
              'MotionCurves.decelerate',
        ),
        _meta(
          'isAnimationActive',
          '${resolved != Duration.zero} · false the moment prefers-reduced-'
              'motion is reduce, without a reload',
        ),
      ],
    );
  }
}

class _WhySlow extends StatelessWidget {
  const _WhySlow();

  @override
  Widget build(BuildContext context) => _capped(
    RichText(
      TextSpan(
        children: <InlineSpan>[
          Code.span('--duration-base'),
          const TextSpan(
            text:
                ' is a control duration. It is the right length for a '
                'button settling under a thumb, and across a plot four '
                'hundred pixels wide it reads as a flicker rather than as a '
                'drawing-on. ',
          ),
          Code.span('--duration-jelly'),
          const TextSpan(text: ' and '),
          Code.span('--duration-reward'),
          const TextSpan(
            text:
                ' belong to celebration — a pack opening, a payout landing '
                '— and a sales chart is neither. ',
          ),
          Code.span('--duration-bloom'),
          const TextSpan(text: ' belongs to light. That leaves '),
          Code.span('--duration-slow'),
          const TextSpan(
            text:
                ', which is long enough for the eye to follow a bar up and '
                'short enough that nobody waits for it.',
          ),
        ],
      ),
      TextStyles.small,
    ),
  );
}

class _CurveFailed extends StatelessWidget {
  const _CurveFailed();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      _capped(
        RichText(
          TextSpan(
            children: <InlineSpan>[
              const TextSpan(
                text:
                    'This is the half that failed, and it is a limit in '
                    'recharts’ types rather than a shortcut taken here. ',
              ),
              Code.span('node_modules/recharts/types/util/types.d.ts'),
              const TextSpan(text: ' declares '),
              Code.span('AnimationTiming'),
              const TextSpan(text: ' as five keywords — '),
              Code.span('ease'),
              const TextSpan(text: ', '),
              Code.span('ease-in'),
              const TextSpan(text: ', '),
              Code.span('ease-out'),
              const TextSpan(text: ', '),
              Code.span('ease-in-out'),
              const TextSpan(text: ', '),
              Code.span('linear'),
              const TextSpan(text: ' — and '),
              Code.span('Area'),
              const TextSpan(text: ', '),
              Code.span('Line'),
              const TextSpan(text: ', '),
              Code.span('Pie'),
              const TextSpan(text: ', '),
              Code.span('Radar'),
              const TextSpan(text: ', '),
              Code.span('RadialBar'),
              const TextSpan(text: ' and '),
              Code.span('Tooltip'),
              const TextSpan(text: ' all type '),
              Code.span('animationEasing'),
              const TextSpan(text: ' as that. A '),
              Code.span('cubic-bezier()'),
              const TextSpan(text: ' string cannot be assigned to it.'),
            ],
          ),
          TextStyles.small,
        ),
      ),
      SizedBox(height: space(3)),
      const _Prose(
        'The obvious shape — {useState} plus a {useEffect} that sets a '
        'mount flag — does not compile here. This repository lints under '
        'the React Compiler rules and {react-hooks/set-state-in-effect} '
        'rejects it. {useSyncExternalStore} is the intended tool for '
        'reading a browser value: it subscribes, reads on the client, and '
        'returns a defined server snapshot. {hooks/use-mobile.ts} and '
        '{components/space/token-swatch.tsx} are the two models, and the '
        'second is where the {MutationObserver} on {<html>} comes from — it '
        'watches {class} for the theme flip and {style} for a runtime '
        'override, so a duration that changes under a mounted chart is '
        'followed rather than missed.',
      ),
      SizedBox(height: space(3)),
      const _Prose(
        'Every {ChartTooltip} in {chart-demos.tsx} takes the same '
        '{{...motion}} as the series beside it. It was the last holdout, '
        'and it is the most instructive one. Recharts’ own default for '
        '{Tooltip} is {animationDuration: 400} — which is exactly what '
        '{--duration-slow} is worth. So the tooltip was animating at the '
        'right length while reading that length out of {node_modules} '
        'rather than out of the stylesheet. Nothing would have failed the '
        'day the token moved; the tooltip would simply have stopped '
        'agreeing with the chart it belongs to. That is the *passes every '
        'guard and is still a violation* case in its quietest form — a '
        'coincidence doing the work of a token — and the fix is one spread.',
      ),
      SizedBox(height: space(3)),
      const _Prose(
        'Two things change with it. The easing was recharts’ {ease} and '
        'is now {ease-out}, the keyword that names {--ease-out}. And '
        '{prefers-reduced-motion} now stops the tooltip along with '
        'everything else, through this hook, rather than through the '
        '{"auto"} default the section above explains why this system does '
        'not rely on.',
      ),
    ],
  );
}

class _ReducedMotion extends StatelessWidget {
  const _ReducedMotion();

  @override
  Widget build(BuildContext context) => const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      _Prose(
        'The obvious claim — *recharts ignores {prefers-reduced-motion}, so '
        'we have to do it* — is not true of recharts 3.8, and was written '
        'into this page’s own plan before anyone opened the package. Every '
        'series defaults to {isAnimationActive: "auto"}, and '
        '{animation/JavascriptAnimate.js} resolves {auto} through its own '
        '{util/usePrefersReducedMotion.js}. Left entirely alone, recharts '
        'honours the preference.',
      ),
      _ProseGap(),
      _Prose(
        'The real reasons are narrower and they hold. {auto} stops applying '
        'the moment you pass a boolean, which every shadcn chart example '
        'does. It is a 3.x default that did not exist before it, so it is a '
        'vendored behaviour that has already moved once. And the hook has '
        'to know the preference regardless, because it is also what decides '
        'whether a duration is worth reading at all — one source of truth, '
        'in code this repository can test, beats a default in '
        '{node_modules}.',
      ),
      _ProseGap(),
      _Prose(
        'What is not negotiable is why it matters. §4.3: **no information '
        'may exist only inside an animation**. Recharts animates by '
        'interpolating the geometry it draws, so a bar starts at zero '
        'height and arrives at its value — for the length of the animation '
        'the chart shows a number the data does not contain. That was '
        'measured here rather than assumed: in a tab where '
        '{requestAnimationFrame} never fires, animation on left 0 of 84 bar '
        'rectangles with a path and every pie empty, while '
        '{isAnimationActive: false} drew all 84 at their exact data ratios '
        'on the first frame.',
      ),
      _ProseGap(),
      _Prose(
        'The two halves of that measurement are not worth the same, and it '
        'matters which one you carry away. The {isAnimationActive: false} '
        'half is a real result: the geometry is complete on the first frame '
        'with nothing running. The other half proves only that *that tab* '
        'never animates — in a live browser the entrance completes in '
        '{--duration-slow} and the bars arrive normally. It is not evidence '
        'that recharts fails §4.3 on a working screen.',
      ),
      _ProseGap(),
      _Prose(
        'What it does expose is where the geometry lives. '
        '{JavascriptAnimate} opens on {useState(isActive ? from : to)}, so '
        'with animation on there is nothing painted at all until the first '
        'frame advances. That is not a reduced-motion problem — '
        '{prefers-reduced-motion} does not suspend {requestAnimationFrame}, '
        'and a reader who has asked for less motion is the one reader '
        'guaranteed to see the chart immediately. It is everyone else’s: '
        'any tab that is backgrounded, hidden or throttled shows an empty '
        'chart for exactly as long as its frames stay suspended. A chart '
        'that has drawn its data does not care whether the tab is in front.',
      ),
    ],
  );
}

/// `className="mt-3"` between two paragraphs of a block.
class _ProseGap extends StatelessWidget {
  const _ProseGap();

  @override
  Widget build(BuildContext context) => SizedBox(height: space(3));
}

class _SsrNote extends StatelessWidget {
  const _SsrNote();

  @override
  Widget build(BuildContext context) => RichText(
    TextSpan(
      children: <InlineSpan>[
        Code.span('chart-motion.ts'),
        const TextSpan(
          text:
              ' carries a millisecond constant and an easing keyword that '
              'restate what the tokens say. §0 would normally forbid that. '
              'They are kept because ',
        ),
        Code.span('getComputedStyle'),
        const TextSpan(
          text:
              ' does not exist on the server, and without them a chart '
              'renders nothing at all until hydration — a worse failure than '
              'a duplicated constant. They are unreachable in a browser: the '
              'store getters win the moment there is a ',
        ),
        Code.span('document'),
        const TextSpan(
          text:
              '. If a token moves and one of these does not, the only '
              'visible consequence is one frame of server-rendered markup at '
              'the old timing.',
        ),
      ],
    ),
    TextStyles.small,
  );
}

/* ── The two discrete families ───────────────────────────────────────────── */

class _UnitActivitySection extends StatelessWidget {
  const _UnitActivitySection();

  @override
  Widget build(BuildContext context) => Section(
    id: 'unit-activity',
    title: 'Unit activity',
    description:
        'A discrete density chart for activity over repeating time buckets. '
        'Current values occupy the foreground units; comparison values '
        'remain visible behind them without inventing another colour family.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const Panel(
          label: 'Weekly activity',
          note: 'current and previous periods',
          child: ChartStateSwitch(
            groupLabel: 'Weekly activity — chart state',
            skeleton: ChartSkeletonKind.bar,
            child: _UnitActivityChart(),
          ),
        ),
        SizedBox(height: space(4)),
        Meta(
          items: <MetaItem>[
            _meta(
              'data',
              'UnitActivityDay[] — each day owns labelled points with current '
                  'and optional previous levels.',
            ),
            _meta(
              'Levels',
              'Twelve discrete rows. Current uses chart-4, the comparison '
                  'remainder uses muted, and softer muted cells preserve the '
                  'complete matrix.',
            ),
            _meta(
              'Typography',
              'Labels use the text foundation; totals, days and measured '
                  'values use type-num-* (Geist Mono).',
            ),
          ],
        ),
      ],
    ),
  );
}

class _ConversionFunnelSection extends StatelessWidget {
  const _ConversionFunnelSection();

  @override
  Widget build(BuildContext context) => Section(
    id: 'conversion-funnel',
    title: 'Conversion funnel',
    description:
        'A compact stage funnel for showing how a cohort narrows. The '
        'segmented strip gives the distribution at a glance; the rows '
        'preserve exact values and labels.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const Panel(
          label: 'Stage conversion',
          note: 'distribution strip and exact totals',
          child: ChartStateSwitch(
            groupLabel: 'Stage conversion — chart state',
            skeleton: ChartSkeletonKind.bar,
            child: _ConversionFunnelChart(),
          ),
        ),
        SizedBox(height: space(4)),
        Meta(
          items: <MetaItem>[
            _meta(
              'stages',
              'ConversionStage[] — label, value and one of the five chart '
                  'tone slots. Stage order is funnel order.',
            ),
            _meta(
              'total',
              'The cohort denominator. Percentages and the overall conversion '
                  'rate are derived, never entered twice.',
            ),
            _meta(
              'Accessibility',
              'The figure has a concise summary; exact stage labels and '
                  'totals remain real text below the decorative strip.',
            ),
          ],
        ),
      ],
    ),
  );
}

class _StatesSection extends StatelessWidget {
  const _StatesSection();

  @override
  Widget build(BuildContext context) => Section(
    id: 'states',
    title: 'States',
    description:
        'Every chart above carries its own Empty · Loading · Ready switch. '
        'There is no separate states demo, because a shared one only ever '
        'proves the state machinery — not that this chart’s skeleton matches '
        'this chart’s footprint.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const Note(
          title: 'The skeleton is the chart, with the data taken out',
          child: _SkeletonNote(),
        ),
        SizedBox(height: space(4)),
        const DoDont(
          dos: <String>[
            'Match the skeleton to the family — a ring where a pie will '
                'land, bars where bars will.',
            'Swap once: anim-content-change on the arriving content, nothing on the '
                'leaving content.',
            'Give the empty state a way forward. Every one here loads the '
                'data.',
            'Keep any control strip outside the swapped slot, or the box '
                'grows on Ready.',
          ],
          donts: <String>[
            "Don't use a grey rectangle. It is the layout jump you were "
                'trying to avoid.',
            "Don't fade the skeleton out and the content in — that animates "
                'one thing twice.',
            "Don't leave an empty chart with no explanation; a blank plot "
                'reads as broken.',
            "Don't measure only the Ready state. The jump is invisible until "
                'you cycle all three.',
          ],
        ),
        SizedBox(height: space(4)),
        Meta(
          items: <MetaItem>[
            _meta(
              'ChartStates title / note',
              "The variant's name and the registry prop it demonstrates. They "
                  "render in the panel's label and meta slots.",
            ),
            _meta(
              'ChartStates skeleton',
              'area | bar | line | pie | radar | radial | tooltip. Pick the '
                  'one whose shape matches what will land there.',
            ),
            _meta(
              'ChartStates controls',
              'A component type, not a node — it wraps the state slot so it '
                  'survives the keyed swap and can own the strip’s state. Used '
                  'by the four interactive variants.',
            ),
            _meta(
              'Coverage',
              '70 variants: Area 10 · Bar 10 · Line 10 · Pie 11 · Radar 14 · '
                  'Radial 6 · Tooltip 9. That is every chart in shadcn’s '
                  'registry, probed rather than remembered — the registry '
                  'serves 14 radar and 11 pie where the gallery page renders '
                  '12 of each.',
            ),
          ],
        ),
      ],
    ),
  );
}

class _SkeletonNote extends StatelessWidget {
  const _SkeletonNote();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      StyledText(
        'Seven skeletons, one per family — a sloped band for Area, five '
        'bars for Bar, a polyline for Line, a ring for Pie, a polygon for '
        'Radar, concentric arcs for Radial, a plot plus a floating frame for '
        'Tooltip. Each is drawn at the plot’s real footprint, so the box '
        'does not move when the state changes.',
        TextStyles.small,
      ),
      SizedBox(height: space(3)),
      RichText(
        TextSpan(
          children: <InlineSpan>[
            const TextSpan(text: 'That is measurable and it was measured: '),
            Code.span('256px'),
            const TextSpan(
              text:
                  ' in the plot slot for all seven skeletons in all three '
                  'states, and the panels that carry a control strip hold '
                  'their full height too — the interactive variants used to '
                  'grow from ',
            ),
            Code.span('393px'),
            const TextSpan(text: ' to '),
            Code.span('453px'),
            const TextSpan(
              text:
                  ' when you switched to Ready, which is the layout jump '
                  '§5 calls worse than the spinner it was avoiding. The '
                  'strip now sits above the swapped slot rather than inside '
                  'it.',
            ),
          ],
        ),
        TextStyles.small,
      ),
    ],
  );
}
