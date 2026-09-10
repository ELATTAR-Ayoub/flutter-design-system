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
import '../charts/chart_plot.dart';
import '../charts/chart_specimen.dart';
import '../charts/chart_states.dart';
import '../charts/specimens_area.dart';
import '../charts/specimens_bar.dart';
import '../charts/specimens_line.dart';
import '../charts/specimens_pie.dart';
import '../charts/specimens_radar.dart';
import '../charts/specimens_radial.dart';
import '../charts/specimens_tooltip.dart';
import '../kit.dart';
import '../nav.dart';
import '../token_swatch.dart';

/// `max-w-3xl`, `--container-3xl`, 48rem. Every prose block in the Animation
/// section. Tailwind's container scale step between `Containers.xl2` (672)
/// and the next one up — not one `Containers` currently declares.
const double _measure3xl = Containers.xl3;

/// `min-w-xl`, `--container-xl`, 36rem. The unit-activity scroller's floor.
/// The container-scale step between `Containers.md` (448) and
/// `Containers.xl2` (672) — likewise not one `Containers` currently declares.
const double _measureXl = Containers.xl;

/// `MetaItem` is a record typedef, so a plain string value has to be wrapped
/// in the [InlineSpan] the row renders.
MetaItem _meta(String k, String v) => (k: k, v: TextSpan(text: v));

/* ── Pie, `components/space/charts/pie.tsx` ────────────────────────────────── */

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
    return RangeStrip(
      value: _month,
      onChanged: (String next) => setState(() => _month = next),
      width: RangeStrip.monthWidth,
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
              child: areaDefault(ink),
            ),
          ),
          Panel(
            label: 'Linear',
            note: 'type=linear',
            child: ChartStateSwitch(
              groupLabel: 'Linear — chart state',
              skeleton: ChartSkeletonKind.area,
              child: areaLinear(ink),
            ),
          ),
          Panel(
            label: 'Step',
            note: 'type=step',
            child: ChartStateSwitch(
              groupLabel: 'Step — chart state',
              skeleton: ChartSkeletonKind.area,
              child: areaStep(ink),
            ),
          ),
          Panel(
            label: 'Stacked',
            note: 'shared stackId',
            child: ChartStateSwitch(
              groupLabel: 'Stacked — chart state',
              skeleton: ChartSkeletonKind.area,
              child: areaStacked(ink),
            ),
          ),
          Panel(
            label: 'Stacked, expanded',
            note: 'stackOffset=expand — shares, not totals',
            child: ChartStateSwitch(
              groupLabel: 'Stacked, expanded — chart state',
              skeleton: ChartSkeletonKind.area,
              child: areaStackedExpand(ink),
            ),
          ),
          Panel(
            label: 'Legend',
            note: 'ChartLegendContent',
            child: ChartStateSwitch(
              groupLabel: 'Legend — chart state',
              skeleton: ChartSkeletonKind.area,
              child: areaLegend(ink),
            ),
          ),
          Panel(
            label: 'Icons',
            note: 'config icons in the legend',
            child: ChartStateSwitch(
              groupLabel: 'Icons — chart state',
              skeleton: ChartSkeletonKind.area,
              child: areaIcons(ink),
            ),
          ),
          Panel(
            label: 'Gradient fill',
            note: 'a linearGradient in defs, both stops on the token',
            child: ChartStateSwitch(
              groupLabel: 'Gradient fill — chart state',
              skeleton: ChartSkeletonKind.area,
              child: areaGradient(ink),
            ),
          ),
          Panel(
            label: 'Axes',
            note: 'both axes labelled',
            child: ChartStateSwitch(
              groupLabel: 'Axes — chart state',
              skeleton: ChartSkeletonKind.area,
              child: areaAxes(ink),
            ),
          ),
          Panel(
            label: 'Interactive',
            note: 'range picker, above the plot',
            child: ChartStateSwitch(
              groupLabel: 'Interactive — chart state',
              skeleton: ChartSkeletonKind.area,
              controls: (BuildContext context, Widget child) =>
                  AreaInteractive(ink: ink, child: child),
              child: Builder(
                builder: (BuildContext context) =>
                    areaInteractive(context, ink),
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
              child: barDefault(ink),
            ),
          ),
          Panel(
            label: 'Horizontal',
            note: 'layout=vertical, YAxis type=category',
            child: ChartStateSwitch(
              groupLabel: 'Horizontal — chart state',
              skeleton: ChartSkeletonKind.bar,
              child: barHorizontal(ink),
            ),
          ),
          Panel(
            label: 'Multiple',
            note: 'two Bars, no stackId',
            child: ChartStateSwitch(
              groupLabel: 'Multiple — chart state',
              skeleton: ChartSkeletonKind.bar,
              child: barMultiple(ink),
            ),
          ),
          Panel(
            label: 'Stacked',
            note: 'three Bars sharing a stackId',
            child: ChartStateSwitch(
              groupLabel: 'Stacked — chart state',
              skeleton: ChartSkeletonKind.bar,
              child: barStacked(ink),
            ),
          ),
          Panel(
            label: 'Label',
            note: 'LabelList on the bar',
            child: ChartStateSwitch(
              groupLabel: 'Label — chart state',
              skeleton: ChartSkeletonKind.bar,
              child: barLabel(ink, theme),
            ),
          ),
          Panel(
            label: 'Custom label',
            note: 'LabelList with a render function',
            child: ChartStateSwitch(
              groupLabel: 'Custom label — chart state',
              skeleton: ChartSkeletonKind.bar,
              child: barLabelCustom(ink, theme),
            ),
          ),
          Panel(
            label: 'Mixed',
            note: 'one Bar, a colour per datum',
            child: ChartStateSwitch(
              groupLabel: 'Mixed — chart state',
              skeleton: ChartSkeletonKind.bar,
              child: barMixed(ink),
            ),
          ),
          Panel(
            label: 'Active',
            note: 'activeIndex highlights one',
            child: ChartStateSwitch(
              groupLabel: 'Active — chart state',
              skeleton: ChartSkeletonKind.bar,
              child: barActive(ink),
            ),
          ),
          Panel(
            label: 'Negative',
            note: 'values below zero — direction by position, not by red',
            child: ChartStateSwitch(
              groupLabel: 'Negative — chart state',
              skeleton: ChartSkeletonKind.bar,
              child: barNegative(ink, theme),
            ),
          ),
          Panel(
            label: 'Interactive',
            note: 'series picker, travelling pill',
            child: ChartStateSwitch(
              groupLabel: 'Interactive — chart state',
              skeleton: ChartSkeletonKind.bar,
              controls: (BuildContext context, Widget child) => SeriesStrip(
                ink: ink,
                slot: 'bar-series-option',
                child: child,
              ),
              child: Builder(
                builder: (BuildContext context) => barInteractive(context, ink),
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
              child: lineDefault(ink),
            ),
          ),
          Panel(
            label: 'Linear',
            note: 'type=linear',
            child: ChartStateSwitch(
              groupLabel: 'Linear — chart state',
              skeleton: ChartSkeletonKind.line,
              child: lineLinear(ink),
            ),
          ),
          Panel(
            label: 'Step',
            note: 'type=step',
            child: ChartStateSwitch(
              groupLabel: 'Step — chart state',
              skeleton: ChartSkeletonKind.line,
              child: lineStep(ink),
            ),
          ),
          Panel(
            label: 'Multi-series',
            note: 'three lines, three tokens',
            child: ChartStateSwitch(
              groupLabel: 'Multi-series — chart state',
              skeleton: ChartSkeletonKind.line,
              child: lineMultiple(ink),
            ),
          ),
          Panel(
            label: 'Dots',
            note: 'a dot on every point',
            child: ChartStateSwitch(
              groupLabel: 'Dots — chart state',
              skeleton: ChartSkeletonKind.line,
              child: lineDots(ink),
            ),
          ),
          Panel(
            label: 'Custom dots',
            note: 'dot as a render function',
            child: ChartStateSwitch(
              groupLabel: 'Custom dots — chart state',
              skeleton: ChartSkeletonKind.line,
              child: lineDotsCustom(ink, theme),
            ),
          ),
          Panel(
            label: 'Dot colours',
            note: 'a token per dot',
            child: ChartStateSwitch(
              groupLabel: 'Dot colours — chart state',
              skeleton: ChartSkeletonKind.line,
              child: lineDotsColors(ink),
            ),
          ),
          Panel(
            label: 'Label',
            note: 'LabelList above the line',
            child: ChartStateSwitch(
              groupLabel: 'Label — chart state',
              skeleton: ChartSkeletonKind.line,
              child: lineLabel(ink, theme),
            ),
          ),
          Panel(
            label: 'Custom label',
            note: 'LabelList with a render function',
            child: ChartStateSwitch(
              groupLabel: 'Custom label — chart state',
              skeleton: ChartSkeletonKind.line,
              child: lineLabelCustom(ink, theme),
            ),
          ),
          Panel(
            label: 'Interactive',
            note: 'series picker, travelling pill',
            child: ChartStateSwitch(
              groupLabel: 'Interactive — chart state',
              skeleton: ChartSkeletonKind.line,
              controls: (BuildContext context, Widget child) => SeriesStrip(
                ink: ink,
                slot: 'line-series-option',
                child: child,
              ),
              child: Builder(
                builder: (BuildContext context) =>
                    lineInteractive(context, ink),
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
              child: pieSimple(ink),
            ),
          ),
          Panel(
            label: 'No separator',
            note: 'paddingAngle={0}',
            child: ChartStateSwitch(
              groupLabel: 'No separator — chart state',
              skeleton: ChartSkeletonKind.pie,
              child: pieSeparatorNone(ink),
            ),
          ),
          Panel(
            label: 'Label',
            note: 'labels outside, with leader lines',
            child: ChartStateSwitch(
              groupLabel: 'Label — chart state',
              skeleton: ChartSkeletonKind.pie,
              child: pieLabel(ink, theme),
            ),
          ),
          Panel(
            label: 'Custom label',
            note: 'label as a render function',
            child: ChartStateSwitch(
              groupLabel: 'Custom label — chart state',
              skeleton: ChartSkeletonKind.pie,
              child: pieLabelCustom(ink, theme),
            ),
          ),
          Panel(
            label: 'Label list',
            note: 'on a card chip — the fill cannot clear AA',
            child: ChartStateSwitch(
              groupLabel: 'Label list — chart state',
              skeleton: ChartSkeletonKind.pie,
              child: pieLabelList(ink),
            ),
          ),
          Panel(
            label: 'Legend',
            note: 'ChartLegendContent, no tooltip',
            child: ChartStateSwitch(
              groupLabel: 'Legend — chart state',
              skeleton: ChartSkeletonKind.pie,
              child: pieLegend(ink),
            ),
          ),
          Panel(
            label: 'Donut',
            note: 'innerRadius as a percentage',
            child: ChartStateSwitch(
              groupLabel: 'Donut — chart state',
              skeleton: ChartSkeletonKind.pie,
              child: pieDonut(ink),
            ),
          ),
          Panel(
            label: 'Donut, active',
            note: 'activeIndex grows one slice',
            child: ChartStateSwitch(
              groupLabel: 'Donut, active — chart state',
              skeleton: ChartSkeletonKind.pie,
              child: pieDonutActive(ink),
            ),
          ),
          Panel(
            label: 'Donut with text',
            note: 'the total in the hole',
            child: ChartStateSwitch(
              groupLabel: 'Donut with text — chart state',
              skeleton: ChartSkeletonKind.pie,
              child: pieDonutText(ink),
            ),
          ),
          Panel(
            label: 'Stacked',
            note: 'two rings, one chart',
            child: ChartStateSwitch(
              groupLabel: 'Stacked — chart state',
              skeleton: ChartSkeletonKind.pie,
              child: pieStacked(ink),
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
                    PieActiveScope(index: index, child: child),
              ),
              child: Builder(
                builder: (BuildContext context) =>
                    pieInteractive(context, ink, PieActiveScope.of(context)),
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
              child: radarDefault(ink),
            ),
          ),
          Panel(
            label: 'Dots',
            note: 'a dot at every vertex',
            child: ChartStateSwitch(
              groupLabel: 'Dots — chart state',
              skeleton: ChartSkeletonKind.radar,
              child: radarDots(ink),
            ),
          ),
          Panel(
            label: 'Lines only',
            note: 'stroke, no fill',
            child: ChartStateSwitch(
              groupLabel: 'Lines only — chart state',
              skeleton: ChartSkeletonKind.radar,
              child: radarLinesOnly(ink),
            ),
          ),
          Panel(
            label: 'Custom label',
            note: 'PolarAngleAxis tick as a render function',
            child: ChartStateSwitch(
              groupLabel: 'Custom label — chart state',
              skeleton: ChartSkeletonKind.radar,
              child: radarLabelCustom(ink),
            ),
          ),
          Panel(
            label: 'Custom grid',
            note: 'PolarGrid with its own stroke',
            child: ChartStateSwitch(
              groupLabel: 'Custom grid — chart state',
              skeleton: ChartSkeletonKind.radar,
              child: radarGridCustom(ink),
            ),
          ),
          Panel(
            label: 'No grid',
            note: 'PolarGrid omitted',
            child: ChartStateSwitch(
              groupLabel: 'No grid — chart state',
              skeleton: ChartSkeletonKind.radar,
              child: radarGridNone(ink),
            ),
          ),
          Panel(
            label: 'Circle grid',
            note: 'gridType=circle',
            child: ChartStateSwitch(
              groupLabel: 'Circle grid — chart state',
              skeleton: ChartSkeletonKind.radar,
              child: radarGridCircle(ink),
            ),
          ),
          Panel(
            label: 'Circle, no lines',
            note: 'circle grid, radialLines={false}',
            child: ChartStateSwitch(
              groupLabel: 'Circle, no lines — chart state',
              skeleton: ChartSkeletonKind.radar,
              child: radarGridCircleNoLines(ink),
            ),
          ),
          Panel(
            label: 'Circle, filled',
            note: 'circle grid with a fill',
            child: ChartStateSwitch(
              groupLabel: 'Circle, filled — chart state',
              skeleton: ChartSkeletonKind.radar,
              child: radarGridCircleFill(ink),
            ),
          ),
          Panel(
            label: 'Polygon, filled',
            note: 'polygon grid with a fill',
            child: ChartStateSwitch(
              groupLabel: 'Polygon, filled — chart state',
              skeleton: ChartSkeletonKind.radar,
              child: radarGridFill(ink),
            ),
          ),
          Panel(
            label: 'Multiple',
            note: 'two profiles overlaid',
            child: ChartStateSwitch(
              groupLabel: 'Multiple — chart state',
              skeleton: ChartSkeletonKind.radar,
              child: radarMultiple(ink),
            ),
          ),
          Panel(
            label: 'Legend',
            note: 'ChartLegendContent under the web',
            child: ChartStateSwitch(
              groupLabel: 'Legend — chart state',
              skeleton: ChartSkeletonKind.radar,
              child: radarLegend(ink),
            ),
          ),
          Panel(
            label: 'Icons',
            note: 'config icons in the legend',
            child: ChartStateSwitch(
              groupLabel: 'Icons — chart state',
              skeleton: ChartSkeletonKind.radar,
              child: radarIcons(ink),
            ),
          ),
          Panel(
            label: 'Radius axis',
            note: 'PolarRadiusAxis shown',
            child: ChartStateSwitch(
              groupLabel: 'Radius axis — chart state',
              skeleton: ChartSkeletonKind.radar,
              child: radarRadius(ink, theme),
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
              child: radialSimple(ink),
            ),
          ),
          Panel(
            label: 'Grid',
            note: 'PolarGrid inside the ring',
            child: ChartStateSwitch(
              groupLabel: 'Grid — chart state',
              skeleton: ChartSkeletonKind.radial,
              child: radialGrid(ink),
            ),
          ),
          Panel(
            label: 'Label',
            note: 'on a card chip — the arc cannot clear AA',
            child: ChartStateSwitch(
              groupLabel: 'Label — chart state',
              skeleton: ChartSkeletonKind.radial,
              child: radialLabel(ink),
            ),
          ),
          Panel(
            label: 'Text',
            note: 'the total in the hole',
            child: ChartStateSwitch(
              groupLabel: 'Text — chart state',
              skeleton: ChartSkeletonKind.radial,
              child: radialText(ink, theme),
            ),
          ),
          Panel(
            label: 'Shape',
            note: 'a custom activeShape',
            child: ChartStateSwitch(
              groupLabel: 'Shape — chart state',
              skeleton: ChartSkeletonKind.radial,
              child: radialShape(ink, theme),
            ),
          ),
          Panel(
            label: 'Stacked half-gauge',
            note: 'startAngle 180 → endAngle 0',
            child: ChartStateSwitch(
              groupLabel: 'Stacked half-gauge — chart state',
              skeleton: ChartSkeletonKind.radial,
              child: radialStacked(ink),
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
              child: tooltipDefault(ink),
            ),
          ),
          Panel(
            label: 'Line indicator',
            note: 'indicator=line',
            child: ChartStateSwitch(
              groupLabel: 'Line indicator — chart state',
              skeleton: ChartSkeletonKind.tooltip,
              child: tooltipIndicatorLine(ink),
            ),
          ),
          Panel(
            label: 'No indicator',
            note: 'hideIndicator',
            child: ChartStateSwitch(
              groupLabel: 'No indicator — chart state',
              skeleton: ChartSkeletonKind.tooltip,
              child: tooltipIndicatorNone(ink),
            ),
          ),
          Panel(
            label: 'Custom label',
            note: 'labelKey plus a config label',
            child: ChartStateSwitch(
              groupLabel: 'Custom label — chart state',
              skeleton: ChartSkeletonKind.tooltip,
              child: tooltipLabelCustom(ink),
            ),
          ),
          Panel(
            label: 'Label formatter',
            note: 'labelFormatter',
            child: ChartStateSwitch(
              groupLabel: 'Label formatter — chart state',
              skeleton: ChartSkeletonKind.tooltip,
              child: tooltipLabelFormatter(ink),
            ),
          ),
          Panel(
            label: 'No label',
            note: 'hideLabel',
            child: ChartStateSwitch(
              groupLabel: 'No label — chart state',
              skeleton: ChartSkeletonKind.tooltip,
              child: tooltipLabelNone(ink),
            ),
          ),
          Panel(
            label: 'Formatter',
            note: 'formatter render function',
            child: ChartStateSwitch(
              groupLabel: 'Formatter — chart state',
              skeleton: ChartSkeletonKind.tooltip,
              child: tooltipFormatter(ink),
            ),
          ),
          Panel(
            label: 'Icons',
            note: 'config icons in the rows',
            child: ChartStateSwitch(
              groupLabel: 'Icons — chart state',
              skeleton: ChartSkeletonKind.tooltip,
              child: tooltipIcons(ink),
            ),
          ),
          Panel(
            label: 'Advanced',
            note: 'formatter with a running total',
            child: ChartStateSwitch(
              groupLabel: 'Advanced — chart state',
              skeleton: ChartSkeletonKind.tooltip,
              child: tooltipAdvanced(ink),
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
  /// documenting, not colours it is choosing — the same historical defaults
  /// `lib/src/components/ui/chart.dart`'s own header explains and does not
  /// use.
  static const String rechartsTickFill = '#666';

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
