/// The three cartesian families — `AreaChart`, `BarChart` and `LineChart`.
///
/// Everything here is recharts 3.8's own layout, ported and then checked
/// against the rendered SVG. The four numbers that decide a plot's box are
/// worth stating once, because every specimen on the page is one of them:
///
/// | measured on | margin | axes | plot box |
/// |---|---|---|---|
/// | `AreaDefault` | `{left:12,right:12}` | X only | x 12…470, y 0…226 |
/// | `BarDefault` | none → `{5,5,5,5}` | X only | x 5…477, y 5…221 |
/// | `AreaLegend` | `{left:12,right:12}` | X + legend | x 12…470, y 0…**198** |
/// | `AreaAxes` | `{left:-20,right:12}` | X + Y | x **40**…470, y 0…226 |
///
/// Three things fall out of that table and none of them is guessable:
///
///  1. **A partial `margin` prop replaces the whole default.** React merges
///     `defaultProps` shallowly, so `margin={{left:12,right:12}}` leaves top and
///     bottom at **0**, not at 5. `AreaDefault`'s grid starts at y=0 and
///     `BarDefault`'s at y=5, which is the whole proof.
///  2. **An axis costs its own size out of the plot**, 30px for an X axis and
///     60px for a Y axis, and a negative margin is how `AreaAxes` claws 20 of
///     that 60 back.
///  3. **A legend costs 28px of plot height** — `pt-3` plus one 16px line box —
///     even though it renders absolutely positioned over the surface.
library;

import 'dart:math' as math;

import 'package:flutter/gestures.dart' show PointerHoverEvent;
import 'package:flutter/widgets.dart'
    hide
        AspectRatio,
        Icon,
        OverlayPortal,
        RichText,
        SafeArea,
        ScrollPosition,
        Table,
        TableColumnWidth;

import '../../design_system/foundation/colors.dart';
import '../../design_system/foundation/spacing.dart';
import '../../design_system/foundation/theme.dart';
import '../../design_system/foundation/theme_scope.dart';
import './chart.dart';
import './chart_geometry.dart';

/* ── Shared plumbing ─────────────────────────────────────────────────────── */

/// recharts' own `margin` prop — abstract plot-coordinate space, which is why
/// the numbers here are written plainly. The page says so in as many words:
/// *"Plot maths, not the 8-point scale — recharts' own margin box."*
@immutable
class ChartMargin {
  const ChartMargin({
    this.top = 0,
    this.right = 0,
    this.bottom = 0,
    this.left = 0,
  });

  /// What a chart gets when it passes **no** `margin` at all.
  ///
  /// Naming it rather than defaulting to it is the point: a caller that writes
  /// `ChartMargin(left: 12, right: 12)` gets zeros on the other two axes,
  /// which is exactly what React's shallow `defaultProps` merge does and what
  /// the measured plot boxes above show.
  static const ChartMargin standard = ChartMargin(
    top: 5,
    right: 5,
    bottom: 5,
    left: 5,
  );

  final double top;
  final double right;
  final double bottom;
  final double left;
}

/// Which way the categories run.
///
/// The page's own warning: *"a horizontal bar chart is a `BarChart` with
/// `layout=vertical`, which reads backwards until you have hit it once"* — the
/// prop names the axis the CATEGORIES run along, not the direction the bars
/// point.
enum ChartLayout { horizontal, vertical }

/// `XAxis` / `YAxis` — `type={"number" | "category"}`.
enum ChartAxisType { category, number }

/// One axis.
@immutable
class ChartAxis {
  const ChartAxis({
    this.dataKey,
    this.type = ChartAxisType.category,
    this.tickLine = true,
    this.axisLine = true,
    this.tickMargin = 0,
    this.minTickGap = 5,
    this.tickCount = 5,
    this.hide = false,
    this.tickFormatter,
    this.size,
  });

  /// The field each tick reads. Without it a category axis is numbered and,
  /// as the radar section puts it, "the chart says nothing".
  final String? dataKey;

  final ChartAxisType type;

  /// The 6px stub between the axis and its label. Every axis on the page turns
  /// it off — and it still counts toward where the label sits, which is the one
  /// thing about it that has to be measured rather than assumed. `AreaDefault`
  /// puts its labels at y=240 with the plot ending at 226 and `tickMargin={8}`:
  /// 226 + **6** + 8.
  final bool tickLine;

  final bool axisLine;
  final double tickMargin;

  /// The clearance `preserveEnd` insists on between two labels. recharts'
  /// default is 5; the three interactive variants raise it to 32 so a 91-day
  /// axis prints seven dates rather than ninety-one.
  final double minTickGap;

  /// Only read on a number axis. `AreaAxes` is the one specimen that lowers it,
  /// to 3, and prints 0 · 300 · 600.
  final int tickCount;

  /// `hide` — keeps the scale and drops the labels, which is what the
  /// horizontal bar specimen does to its value axis because the tooltip already
  /// carries the number.
  final bool hide;

  final String Function(Object? value)? tickFormatter;

  /// Overrides the axis's own 30 (X) / 60 (Y).
  final double? size;

  /// `XAxis`'s default `height`.
  static const double defaultXSize = 30;

  /// `YAxis`'s default `width`.
  static const double defaultYSize = 60;

  /// `tickSize` — recharts' own 6, applied whether or not [tickLine] draws.
  static const double tickSize = 6;
}

/// `CartesianGrid`.
@immutable
class ChartGrid {
  const ChartGrid({this.horizontal = true, this.vertical = true});

  final bool horizontal;
  final bool vertical;

  /// `[&_.recharts-cartesian-grid_line[stroke='#ccc']]:stroke-border/50` — the
  /// sweep in `ui/chart.tsx` that replaces recharts' own untokenised grey.
  static const double strokeAlpha = 0.5;
}

/// Which shape a series draws.
enum ChartSeriesKind { area, bar, line }

/// A dot on a `Line` or `Radar` vertex.
@immutable
class ChartDot {
  const ChartDot({
    this.radius = 3,
    this.fill,
    this.stroke,
    this.strokeWidth = 1,
  });

  /// recharts' own default `r` for a `Line` dot.
  final double radius;
  final Color? fill;
  final Color? stroke;
  final double strokeWidth;
}

/// `LabelList` — a value printed beside its own datum.
@immutable
class ChartLabelList {
  const ChartLabelList({
    this.dataKey,
    this.position = ChartLabelPosition.top,
    this.offset = 5,
    this.color,
    this.formatter,
  });

  /// Which field to print. Null prints the series' own value.
  final String? dataKey;
  final ChartLabelPosition position;
  final double offset;

  /// `fill-foreground` / `fill-background` — the two the page uses.
  final Color? color;
  final String Function(Object? value)? formatter;
}

/// The four `LabelList` positions the page reaches for.
enum ChartLabelPosition { top, right, insideLeft, insideEnd }

/// One drawn series.
@immutable
class ChartSeriesSpec {
  const ChartSeriesSpec({
    required this.kind,
    required this.dataKey,
    this.stroke,
    this.fill,
    this.fillOpacity = 1,
    this.strokeWidth = 1,
    this.curve = CurveType.linear,
    this.stackId,
    this.radii,
    this.cellFills,
    this.dot,
    this.labels = const <ChartLabelList>[],
    this.gradient,
  });

  final ChartSeriesKind kind;
  final String dataKey;
  final Color? stroke;
  final Color? fill;

  /// The page's own note: *"Opacity is not one of the five token families — §0
  /// owns colour, typography, spacing, radius and motion — so a fade is written
  /// plainly. The colour underneath it is still the token."*
  final double fillOpacity;

  final double strokeWidth;
  final CurveType curve;

  /// Any shared string stacks the series that carry it. Order matters: the
  /// first one declared is drawn at the bottom of the stack.
  final String? stackId;

  /// `radius={[tl, tr, br, bl]}` on a `Bar`. The zeros in `BarStacked`'s
  /// `[0, 0, r, r]` say WHICH corners are cut, which is geometry; the `r`
  /// itself is `--radius-sm`, read off the ladder by the caller.
  final List<double>? radii;

  /// `<Cell fill=…>` per datum — `BarNegative`'s two-colour split, and the
  /// `fill` every `BROWSERS` row already carries.
  final List<Color>? cellFills;

  final ChartDot? dot;
  final List<ChartLabelList> labels;

  /// `fill="url(#…)"` — the `<linearGradient>` in `<defs>`.
  final Gradient? gradient;
}

/// A tooltip pinned open without a pointer — recharts' `defaultIndex`.
///
/// Nine of the tooltip specimens and three others use it, which is why those
/// charts render a panel at rest. It moved off `Bar`/`Pie` between recharts v2
/// and v3, where it used to be `activeIndex`.
@immutable
class ChartTooltipSpec {
  const ChartTooltipSpec({
    this.indicator = ChartIndicator.dot,
    this.hideLabel = false,
    this.hideIndicator = false,
    this.defaultIndex,
    this.cursor = true,
    this.nameKey,
    this.labelKey,
    this.labelFormatter,
    this.formatter,
    this.width,
  });

  final ChartIndicator indicator;
  final bool hideLabel;
  final bool hideIndicator;

  /// Which datum to show at rest.
  final int? defaultIndex;

  /// `cursor={false}` on most of the page — the highlight band behind the
  /// hovered category.
  final bool cursor;

  final String? nameKey;
  final String? labelKey;
  final String Function(String label, List<ChartTooltipItem> items)?
  labelFormatter;
  final Widget Function(BuildContext, ChartTooltipItem, int)? formatter;
  final double? width;
}

/// `ChartLegend content={<ChartLegendContent />}`.
@immutable
class ChartLegendSpec {
  const ChartLegendSpec({
    this.align = ChartLegendAlign.bottom,
    this.nameKey,
    this.wrap = false,
    this.gap,
    this.offset = 0,
  });

  final ChartLegendAlign align;
  final String? nameKey;
  final bool wrap;
  final double? gap;

  /// `className="mt-8"` / `"-translate-y-2"` — the two nudges the page applies.
  final double offset;

  /// Measured: a bottom legend takes **28px** out of the plot — `pt-3` (12)
  /// plus one `text-xs` line box (16). `AreaStacked` ends at y=226 and
  /// `AreaLegend`, identical but for the legend, ends at 198.
  static double get reservedHeight => space(3) + 16;
}

/* ── The chart ───────────────────────────────────────────────────────────── */

/// One cartesian plot: `AreaChart`, `BarChart` or `LineChart`.
///
/// The three are one widget here because recharts makes them one widget too —
/// `CartesianChart` with a different `chartName` — and because the only thing
/// that actually differs is which scale the category axis resolves to. That
/// difference IS load-bearing and is the single most visible measurement on the
/// page: a chart with bars in it gets a **band** scale (six categories, each
/// 78.667 wide, ticks at the band centres 44.33 · 123 · …), and a chart without
/// gets a **point** scale (six vertices ON the plot edges, 12 · 103.6 · … ·
/// 470). Reading `AreaDefault`'s path back is how that was settled.
class CartesianChart extends StatefulWidget {
  const CartesianChart({
    super.key,
    required this.data,
    required this.series,
    this.margin = ChartMargin.standard,
    this.layout = ChartLayout.horizontal,
    this.grid,
    this.xAxis,
    this.yAxis,
    this.legend,
    this.tooltip,
    this.stackOffsetExpand = false,
  });

  /// The rows, as the reference's own fixtures: a `Map` per datum.
  final List<Map<String, Object?>> data;

  final List<ChartSeriesSpec> series;
  final ChartMargin margin;
  final ChartLayout layout;
  final ChartGrid? grid;
  final ChartAxis? xAxis;
  final ChartAxis? yAxis;
  final ChartLegendSpec? legend;
  final ChartTooltipSpec? tooltip;

  /// `stackOffset="expand"` — shares rather than totals, so the value axis runs
  /// 0…1 whatever the data sums to.
  final bool stackOffsetExpand;

  @override
  State<CartesianChart> createState() => _CartesianChartState();
}

class _CartesianChartState extends State<CartesianChart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entrance = AnimationController(
    vsync: this,
    duration: ChartMotion.duration,
  );

  /// The datum the pointer is over, or the `defaultIndex` when it is nowhere.
  int? _hover;

  @override
  void initState() {
    super.initState();
    _entrance.value = 1;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Duration d = effectiveMotionDuration(context, ChartMotion.duration);
    _entrance.duration = d;
    if (d == Duration.zero) {
      _entrance.value = 1;
    } else if (!_entrance.isAnimating && _entrance.value == 1) {
      _entrance
        ..value = 0
        ..forward();
    }
  }

  @override
  void dispose() {
    _entrance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final ChartConfig config = ChartScope.of(context);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final Size size = Size(
          constraints.maxWidth.isFinite ? constraints.maxWidth : 0,
          constraints.maxHeight.isFinite
              ? constraints.maxHeight
              : ChartContainer.plotHeight,
        );
        final _CartesianLayout layout = _CartesianLayout.resolve(
          context: context,
          widget: widget,
          size: size,
        );
        final int? active = _hover ?? widget.tooltip?.defaultIndex;
        return MouseRegion(
          onHover: (PointerHoverEvent e) => _onHover(layout, e.localPosition),
          onExit: (_) => setState(() => _hover = null),
          child: AnimatedBuilder(
            animation: _entrance,
            builder: (BuildContext context, Widget? _) => Stack(
              children: <Widget>[
                Positioned.fill(
                  child: CustomPaint(
                    painter: _CartesianPainter(
                      layout: layout,
                      theme: theme,
                      t: ChartMotion.curve.transform(_entrance.value),
                      activeIndex: active,
                      cursor: widget.tooltip?.cursor ?? true,
                    ),
                  ),
                ),
                ..._axisLabels(context, layout, theme),
                ..._seriesLabels(context, layout, theme),
                if (widget.legend != null) _legend(context, layout, config),
                if (active != null && widget.tooltip != null)
                  _tooltip(context, layout, config, active),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onHover(_CartesianLayout layout, Offset local) {
    final int? index = layout.indexAt(local);
    if (index != _hover) setState(() => _hover = index);
  }

  List<Widget> _axisLabels(
    BuildContext context,
    _CartesianLayout layout,
    ThemeTokens theme,
  ) => <Widget>[
    for (final _AxisTick tick in layout.xTicks)
      Positioned(
        left: 0,
        top: 0,
        width: layout.size.width,
        child: _TickLabel(
          tick: tick,
          color: theme.mutedForeground,
          anchor: _TickAnchor.middle,
        ),
      ),
    for (final _AxisTick tick in layout.yTicks)
      Positioned(
        left: 0,
        top: 0,
        width: layout.size.width,
        child: _TickLabel(
          tick: tick,
          color: theme.mutedForeground,
          anchor: _TickAnchor.end,
        ),
      ),
  ];

  List<Widget> _seriesLabels(
    BuildContext context,
    _CartesianLayout layout,
    ThemeTokens theme,
  ) => <Widget>[
    for (final _SeriesLabel label in layout.labels)
      Positioned(
        left: 0,
        top: 0,
        width: layout.size.width,
        child: _TickLabel(
          tick: _AxisTick(
            text: label.text,
            x: label.x,
            baseline: label.baseline,
          ),
          color: label.color ?? theme.foreground,
          anchor: label.anchor,
        ),
      ),
  ];

  Widget _legend(
    BuildContext context,
    _CartesianLayout layout,
    ChartConfig config,
  ) {
    final ChartLegendSpec spec = widget.legend!;
    return Positioned(
      left: layout.frame.left,
      width: layout.frame.width,
      bottom: spec.align == ChartLegendAlign.bottom ? spec.offset : null,
      top: spec.align == ChartLegendAlign.top ? spec.offset : null,
      child: ChartLegendContent(
        config: config,
        verticalAlign: spec.align,
        wrap: spec.wrap,
        gap: spec.gap,
        items: <ChartLegendItem>[
          for (final ChartSeriesSpec s in widget.series)
            ChartLegendItem(
              name: spec.nameKey ?? s.dataKey,
              color: s.stroke ?? s.fill,
            ),
        ],
      ),
    );
  }

  Widget _tooltip(
    BuildContext context,
    _CartesianLayout layout,
    ChartConfig config,
    int index,
  ) {
    final ChartTooltipSpec spec = widget.tooltip!;
    final Map<String, Object?> row = widget.data[index];
    final List<ChartTooltipItem> items = <ChartTooltipItem>[
      for (final ChartSeriesSpec s in widget.series)
        ChartTooltipItem(
          name: s.dataKey,
          dataKey: s.dataKey,
          value: (row[s.dataKey] as num?),
          color: s.cellFills != null && index < s.cellFills!.length
              ? s.cellFills![index]
              : (s.fill ?? s.stroke),
          payload: row,
        ),
    ];
    final String label = '${row[layout.categoryKey] ?? ''}';
    // recharts positions the panel beside the active datum and clamps it to the
    // plot. Measured on `TooltipDefault`: translate(133, 140.5) inside a 482
    // box for the second of six categories.
    final double x = layout.categoryCoord(index);
    return Positioned(
      left: math.min(
        math.max(x + space(3), 0),
        math.max(layout.size.width - ChartTooltipContent.minWidth, 0),
      ),
      top: layout.frame.top + layout.frame.height / 2,
      child: ChartTooltipContent(
        config: config,
        label: label,
        items: items,
        indicator: spec.indicator,
        hideLabel: spec.hideLabel,
        hideIndicator: spec.hideIndicator,
        nameKey: spec.nameKey,
        labelKey: spec.labelKey,
        labelFormatter: spec.labelFormatter,
        formatter: spec.formatter,
        width: spec.width,
      ),
    );
  }
}

/* ── Layout ──────────────────────────────────────────────────────────────── */

/// One resolved tick: the string, where it is centred, and the baseline it
/// sits on.
@immutable
class _AxisTick {
  const _AxisTick({
    required this.text,
    required this.x,
    required this.baseline,
  });

  final String text;
  final double x;
  final double baseline;
}

enum _TickAnchor { start, middle, end }

/// A `LabelList` entry, resolved.
@immutable
class _SeriesLabel {
  const _SeriesLabel({
    required this.text,
    required this.x,
    required this.baseline,
    required this.anchor,
    this.color,
  });

  final String text;
  final double x;
  final double baseline;
  final _TickAnchor anchor;
  final Color? color;
}

/// A bar, ready to paint.
@immutable
class BarRect {
  const BarRect({
    required this.rect,
    required this.radii,
    required this.color,
    this.baseline,
  });

  final Rect rect;
  final List<double> radii;
  final Color color;

  /// The y (or x) the bar grows from, so the entrance can scale it in place.
  final double? baseline;
}

/// Everything a cartesian plot needs, computed once per build.
class _CartesianLayout {
  _CartesianLayout({
    required this.size,
    required this.frame,
    required this.categoryKey,
    required this.categoryCount,
    required this.horizontal,
    required this.gridLines,
    required this.xTicks,
    required this.yTicks,
    required this.areas,
    required this.lines,
    required this.bars,
    required this.dots,
    required this.labels,
    required this.categoryCoords,
  });

  final Size size;

  /// recharts' `offset` — the plot rectangle inside the margins and axes.
  final Rect frame;

  final String categoryKey;
  final int categoryCount;
  final bool horizontal;

  final List<_GridLine> gridLines;
  final List<_AxisTick> xTicks;
  final List<_AxisTick> yTicks;
  final List<_AreaShape> areas;
  final List<_LineShape> lines;
  final List<BarRect> bars;
  final List<_DotShape> dots;
  final List<_SeriesLabel> labels;
  final List<double> categoryCoords;

  double categoryCoord(int index) =>
      index >= 0 && index < categoryCoords.length ? categoryCoords[index] : 0;

  /// Which datum a pointer at [local] is over.
  int? indexAt(Offset local) {
    if (categoryCoords.isEmpty) return null;
    if (!frame.inflate(1).contains(local)) return null;
    final double p = horizontal ? local.dx : local.dy;
    int best = 0;
    double bestGap = double.infinity;
    for (int i = 0; i < categoryCoords.length; i++) {
      final double gap = (categoryCoords[i] - p).abs();
      if (gap < bestGap) {
        bestGap = gap;
        best = i;
      }
    }
    return best;
  }

  static _CartesianLayout resolve({
    required BuildContext context,
    required CartesianChart widget,
    required Size size,
  }) {
    final bool horizontal = widget.layout == ChartLayout.horizontal;
    final ChartAxis? xAxis = widget.xAxis;
    final ChartAxis? yAxis = widget.yAxis;

    final double legendReserve =
        widget.legend != null && widget.legend!.align == ChartLegendAlign.bottom
        ? ChartLegendSpec.reservedHeight
        : 0;
    final double legendTopReserve =
        widget.legend != null && widget.legend!.align == ChartLegendAlign.top
        ? ChartLegendSpec.reservedHeight
        : 0;

    final double left =
        widget.margin.left +
        (yAxis != null && !yAxis.hide
            ? (yAxis.size ?? ChartAxis.defaultYSize)
            : 0);
    final double right = widget.margin.right;
    final double top = widget.margin.top + legendTopReserve;
    final double bottom =
        widget.margin.bottom +
        (xAxis != null && !xAxis.hide
            ? (xAxis.size ?? ChartAxis.defaultXSize)
            : 0) +
        legendReserve;
    final Rect frame = Rect.fromLTRB(
      left,
      top,
      size.width - right,
      size.height - bottom,
    );

    // The category axis is whichever one is `type: category`.
    final ChartAxis? categoryAxis = horizontal ? xAxis : yAxis;
    final ChartAxis? valueAxis = horizontal ? yAxis : xAxis;
    final String categoryKey =
        categoryAxis?.dataKey ??
        (widget.data.isEmpty ? '' : widget.data.first.keys.first);
    final int n = widget.data.length;

    final bool hasBars = widget.series.any(
      (ChartSeriesSpec s) => s.kind == ChartSeriesKind.bar,
    );

    // ── the category scale ────────────────────────────────────────────────
    final double catStart = horizontal ? frame.left : frame.top;
    final double catExtent = horizontal ? frame.width : frame.height;
    final BandScale band = BandScale(
      count: n,
      start: catStart,
      extent: catExtent,
    );
    final PointScale point = PointScale(
      count: n,
      start: catStart,
      extent: catExtent,
    );
    final List<double> categoryCoords = <double>[
      for (int i = 0; i < n; i++) hasBars ? band.center(i) : point.at(i),
    ];

    // ── the value scale ───────────────────────────────────────────────────
    final _Stacks stacks = _Stacks.build(widget);
    final double valueStart = horizontal ? frame.bottom : frame.left;
    final double valueEnd = horizontal ? frame.top : frame.right;
    final LinearScale value = LinearScale.nice(
      dataMin: stacks.min,
      dataMax: stacks.max,
      rangeStart: valueStart,
      rangeEnd: valueEnd,
      tickCount: valueAxis?.tickCount ?? 5,
    );

    // ── grid ──────────────────────────────────────────────────────────────
    final List<_GridLine> gridLines = <_GridLine>[];
    final ChartGrid? grid = widget.grid;
    if (grid != null) {
      final List<double> vTicks = value.ticks();
      if (grid.horizontal) {
        for (final double v in vTicks) {
          final double y = horizontal ? value.scale(v) : 0;
          if (horizontal) {
            gridLines.add(
              _GridLine(Offset(frame.left, y), Offset(frame.right, y)),
            );
          }
        }
        if (!horizontal) {
          for (int i = 0; i < n; i++) {
            final double y = band.center(i);
            gridLines.add(
              _GridLine(Offset(frame.left, y), Offset(frame.right, y)),
            );
          }
        }
      }
      if (grid.vertical) {
        if (horizontal) {
          for (int i = 0; i < n; i++) {
            final double x = categoryCoords[i];
            gridLines.add(
              _GridLine(Offset(x, frame.top), Offset(x, frame.bottom)),
            );
          }
        } else {
          for (final double v in vTicks) {
            final double x = value.scale(v);
            gridLines.add(
              _GridLine(Offset(x, frame.top), Offset(x, frame.bottom)),
            );
          }
        }
      }
    }

    // ── ticks ─────────────────────────────────────────────────────────────
    final List<_AxisTick> xTicks = <_AxisTick>[];
    final List<_AxisTick> yTicks = <_AxisTick>[];
    if (xAxis != null && !xAxis.hide) {
      final double baseline =
          frame.bottom + ChartAxis.tickSize + xAxis.tickMargin + _capOffset;
      if (horizontal) {
        xTicks.addAll(
          _preserveEndTicks(
            context: context,
            labels: <String>[
              for (int i = 0; i < n; i++)
                _format(xAxis.tickFormatter, widget.data[i][categoryKey]),
            ],
            coords: categoryCoords,
            minTickGap: xAxis.minTickGap,
            viewportEnd: size.width,
            baseline: baseline,
          ),
        );
      } else {
        for (final double v in value.ticks()) {
          xTicks.add(
            _AxisTick(
              text: _format(xAxis.tickFormatter, v),
              x: value.scale(v),
              baseline: baseline,
            ),
          );
        }
      }
    }
    if (yAxis != null && !yAxis.hide) {
      final double x = frame.left - ChartAxis.tickSize - yAxis.tickMargin;
      if (horizontal) {
        for (final double v in value.ticks()) {
          yTicks.add(
            _AxisTick(
              text: _format(yAxis.tickFormatter, v),
              x: x,
              baseline: value.scale(v) + _midOffset,
            ),
          );
        }
      } else {
        for (int i = 0; i < n; i++) {
          yTicks.add(
            _AxisTick(
              text: _format(yAxis.tickFormatter, widget.data[i][categoryKey]),
              x: x,
              baseline: band.center(i) + _midOffset,
            ),
          );
        }
      }
    }

    // ── series ────────────────────────────────────────────────────────────
    final List<_AreaShape> areas = <_AreaShape>[];
    final List<_LineShape> lines = <_LineShape>[];
    final List<BarRect> bars = <BarRect>[];
    final List<_DotShape> dots = <_DotShape>[];
    final List<_SeriesLabel> labels = <_SeriesLabel>[];

    final List<ChartSeriesSpec> barSeries = widget.series
        .where((ChartSeriesSpec s) => s.kind == ChartSeriesKind.bar)
        .toList();
    final Map<String?, int> barStackColumn = <String?, int>{};
    int barColumns = 0;
    for (final ChartSeriesSpec s in barSeries) {
      final String? key = s.stackId;
      if (key == null) {
        barStackColumn[s.dataKey] = barColumns++;
      } else if (!barStackColumn.containsKey(key)) {
        barStackColumn[key] = barColumns++;
      }
    }
    final List<BarSlot> slots = barSlots(
      bandSize: band.bandwidth,
      barCount: math.max(barColumns, 1),
    );

    for (final ChartSeriesSpec s in widget.series) {
      final List<double> lo = stacks.lower(s.dataKey);
      final List<double> hi = stacks.upper(s.dataKey);
      switch (s.kind) {
        case ChartSeriesKind.area:
          final List<Offset> topPts = <Offset>[
            for (int i = 0; i < n; i++)
              Offset(categoryCoords[i], value.scale(hi[i])),
          ];
          final List<Offset> basePts = <Offset>[
            for (int i = 0; i < n; i++)
              Offset(categoryCoords[i], value.scale(lo[i])),
          ];
          areas.add(
            _AreaShape(
              fill: areaPath(topPts, basePts, s.curve),
              stroke: curvePath(topPts, s.curve),
              spec: s,
            ),
          );
        case ChartSeriesKind.line:
          final List<Offset> pts = <Offset>[
            for (int i = 0; i < n; i++)
              Offset(categoryCoords[i], value.scale(hi[i])),
          ];
          lines.add(_LineShape(path: curvePath(pts, s.curve), spec: s));
          if (s.dot != null) {
            for (int i = 0; i < n; i++) {
              // `LineDotsColors` colours each dot from its own row rather than
              // from a series palette — five `BROWSERS` rows, five tokens.
              final Color? cell = s.cellFills != null && i < s.cellFills!.length
                  ? s.cellFills![i]
                  : null;
              dots.add(
                _DotShape(
                  center: pts[i],
                  dot: cell == null
                      ? s.dot!
                      : ChartDot(
                          radius: s.dot!.radius,
                          fill: cell,
                          stroke: cell,
                          strokeWidth: s.dot!.strokeWidth,
                        ),
                  fallback: s.stroke,
                ),
              );
            }
          }
          _collectLabels(
            labels,
            s,
            widget.data,
            pts,
            hi,
            ChartLayout.horizontal,
          );
        case ChartSeriesKind.bar:
          final int column = barStackColumn[s.stackId ?? s.dataKey] ?? 0;
          final BarSlot slot = slots[math.min(column, slots.length - 1)];
          for (int i = 0; i < n; i++) {
            final double a = value.scale(lo[i]);
            final double b = value.scale(hi[i]);
            final double start = band.bandStart(i) + slot.offset;
            final Rect rect = horizontal
                ? Rect.fromLTRB(
                    start,
                    math.min(a, b),
                    start + slot.size,
                    math.max(a, b),
                  )
                : Rect.fromLTRB(
                    math.min(a, b),
                    start,
                    math.max(a, b),
                    start + slot.size,
                  );
            bars.add(
              BarRect(
                rect: rect,
                radii: s.radii ?? const <double>[0, 0, 0, 0],
                color: s.cellFills != null && i < s.cellFills!.length
                    ? s.cellFills![i]
                    : (s.fill ?? transparent),
                baseline: horizontal ? value.scale(lo[i]) : value.scale(lo[i]),
              ),
            );
          }
          _collectLabels(
            labels,
            s,
            widget.data,
            <Offset>[
              for (int i = 0; i < n; i++)
                horizontal
                    ? Offset(
                        band.bandStart(i) + slot.offset + slot.size / 2,
                        value.scale(hi[i]),
                      )
                    : Offset(
                        value.scale(hi[i]),
                        band.bandStart(i) + slot.offset + slot.size / 2,
                      ),
            ],
            hi,
            widget.layout,
            barStart: <double>[for (int i = 0; i < n; i++) value.scale(lo[i])],
          );
      }
    }

    return _CartesianLayout(
      size: size,
      frame: frame,
      categoryKey: categoryKey,
      categoryCount: n,
      horizontal: horizontal,
      gridLines: gridLines,
      xTicks: xTicks,
      yTicks: yTicks,
      areas: areas,
      lines: lines,
      bars: bars,
      dots: dots,
      labels: labels,
      categoryCoords: categoryCoords,
    );
  }

  /// `<tspan dy="0.71em">` on a bottom axis — the offset from the tick's own
  /// anchor to the label's alphabetic baseline, in a 12px face.
  static const double _capOffset = 0.71 * 12;

  /// `<tspan dy="0.355em">` on a left axis, which centres the label on the tick.
  static const double _midOffset = 0.355 * 12;

  static String _format(String Function(Object?)? f, Object? v) =>
      f != null ? f(v) : (v is num ? chartNumber(v) : '${v ?? ''}');

  static void _collectLabels(
    List<_SeriesLabel> out,
    ChartSeriesSpec s,
    List<Map<String, Object?>> data,
    List<Offset> anchors,
    List<double> values,
    ChartLayout layout, {
    List<double>? barStart,
  }) {
    for (final ChartLabelList spec in s.labels) {
      for (int i = 0; i < anchors.length; i++) {
        final Object? raw = spec.dataKey != null
            ? data[i][spec.dataKey]
            : values[i];
        final String text = spec.formatter != null
            ? spec.formatter!(raw)
            : (raw is num ? chartNumber(raw) : '${raw ?? ''}');
        switch (spec.position) {
          case ChartLabelPosition.top:
            out.add(
              _SeriesLabel(
                text: text,
                x: anchors[i].dx,
                baseline: anchors[i].dy - spec.offset,
                anchor: _TickAnchor.middle,
                color: spec.color,
              ),
            );
          case ChartLabelPosition.right:
            out.add(
              _SeriesLabel(
                text: text,
                x: anchors[i].dx + spec.offset,
                baseline: anchors[i].dy + _midOffset,
                anchor: _TickAnchor.start,
                color: spec.color,
              ),
            );
          case ChartLabelPosition.insideLeft:
            out.add(
              _SeriesLabel(
                text: text,
                x: (barStart?[i] ?? anchors[i].dx) + spec.offset,
                baseline: anchors[i].dy + _midOffset,
                anchor: _TickAnchor.start,
                color: spec.color,
              ),
            );
          case ChartLabelPosition.insideEnd:
            out.add(
              _SeriesLabel(
                text: text,
                x: anchors[i].dx - spec.offset,
                baseline: anchors[i].dy + _midOffset,
                anchor: _TickAnchor.end,
                color: spec.color,
              ),
            );
        }
      }
    }
  }

  /// `cartesian/getTicks.js` — `interval="preserveEnd"`, recharts' own default.
  ///
  /// It walks from the LAST tick backwards, keeps a label only when it clears
  /// the previously kept one by [minTickGap], and clamps the final label so its
  /// right edge lands on the surface's own edge rather than on the plot's.
  ///
  /// **The viewport is the whole SVG, not the plot box** — measured, and it is
  /// the one part of this that cannot be reasoned out. `AreaInteractive` (plot
  /// 5…477) and `BarInteractive` (plot 12…470) both clamp "Jun 30" to
  /// x = **462.296875**, which is only one number if the boundary is the 482
  /// surface both share.
  static List<_AxisTick> _preserveEndTicks({
    required BuildContext context,
    required List<String> labels,
    required List<double> coords,
    required double minTickGap,
    required double viewportEnd,
    required double baseline,
  }) {
    final List<_AxisTick> kept = <_AxisTick>[];
    double end = viewportEnd;
    for (int i = labels.length - 1; i >= 0; i--) {
      final double width = _measure(context, labels[i]);
      double coord = coords[i];
      if (i == labels.length - 1) {
        final double gap = coord + width / 2 - end;
        if (gap > 0) coord -= gap;
      }
      final bool visible = coord - width / 2 >= 0 && coord + width / 2 <= end;
      if (!visible) continue;
      end = coord - (width / 2 + minTickGap);
      kept.add(_AxisTick(text: labels[i], x: coord, baseline: baseline));
    }
    return kept.reversed.toList();
  }

  static final Map<String, double> _widths = <String, double>{};

  static double _measure(BuildContext context, String text) =>
      _widths.putIfAbsent(text, () {
        final TextPainter painter = TextPainter(
          text: TextSpan(
            text: text,
            style: StyledText.styleOf(context, ChartText.xs),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        final double w = painter.width;
        painter.dispose();
        return w;
      });
}

/// Which value each series occupies on the value axis, once stacking is
/// applied.
class _Stacks {
  _Stacks(this._lower, this._upper, this.min, this.max);

  final Map<String, List<double>> _lower;
  final Map<String, List<double>> _upper;
  final double min;
  final double max;

  List<double> lower(String key) => _lower[key] ?? const <double>[];
  List<double> upper(String key) => _upper[key] ?? const <double>[];

  static _Stacks build(CartesianChart widget) {
    final int n = widget.data.length;
    final Map<String, List<double>> lower = <String, List<double>>{};
    final Map<String, List<double>> upper = <String, List<double>>{};
    final Map<String, List<double>> running = <String, List<double>>{};
    double min = 0;
    double max = 0;

    // `stackOffset="expand"` needs every stack's own total first.
    final Map<String, List<double>> totals = <String, List<double>>{};
    if (widget.stackOffsetExpand) {
      for (final ChartSeriesSpec s in widget.series) {
        final String key = s.stackId ?? s.dataKey;
        final List<double> t = totals.putIfAbsent(
          key,
          () => List<double>.filled(n, 0),
        );
        for (int i = 0; i < n; i++) {
          t[i] += ((widget.data[i][s.dataKey] as num?) ?? 0).toDouble();
        }
      }
    }

    for (final ChartSeriesSpec s in widget.series) {
      final List<double> lo = List<double>.filled(n, 0);
      final List<double> hi = List<double>.filled(n, 0);
      final String? stack = s.stackId;
      final List<double>? acc = stack == null
          ? null
          : running.putIfAbsent(stack, () => List<double>.filled(n, 0));
      for (int i = 0; i < n; i++) {
        double v = ((widget.data[i][s.dataKey] as num?) ?? 0).toDouble();
        if (widget.stackOffsetExpand) {
          final double t = totals[stack ?? s.dataKey]![i];
          v = t == 0 ? 0 : v / t;
        }
        final double base = acc == null ? 0 : acc[i];
        lo[i] = base;
        hi[i] = base + v;
        if (acc != null) acc[i] = hi[i];
        min = math.min(min, math.min(lo[i], hi[i]));
        max = math.max(max, math.max(lo[i], hi[i]));
      }
      lower[s.dataKey] = lo;
      upper[s.dataKey] = hi;
    }
    return _Stacks(lower, upper, min, max);
  }
}

@immutable
class _GridLine {
  const _GridLine(this.a, this.b);
  final Offset a;
  final Offset b;
}

@immutable
class _AreaShape {
  const _AreaShape({
    required this.fill,
    required this.stroke,
    required this.spec,
  });
  final Path fill;
  final Path stroke;
  final ChartSeriesSpec spec;
}

@immutable
class _LineShape {
  const _LineShape({required this.path, required this.spec});
  final Path path;
  final ChartSeriesSpec spec;
}

@immutable
class _DotShape {
  const _DotShape({required this.center, required this.dot, this.fallback});
  final Offset center;
  final ChartDot dot;
  final Color? fallback;
}

/* ── Painters ────────────────────────────────────────────────────────────── */

/// Everything a cartesian plot draws, in recharts' own z-order: grid, then
/// areas, then bars, then lines, then dots.
class _CartesianPainter extends CustomPainter {
  const _CartesianPainter({
    required this.layout,
    required this.theme,
    required this.t,
    required this.activeIndex,
    required this.cursor,
  });

  final _CartesianLayout layout;
  final ThemeTokens theme;

  /// The entrance's own progress, already through the curve.
  final double t;

  final int? activeIndex;
  final bool cursor;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint grid = Paint()
      ..color = theme.border.withValues(alpha: ChartGrid.strokeAlpha)
      ..strokeWidth = BorderWidths.hairline
      ..style = PaintingStyle.stroke;
    for (final _GridLine line in layout.gridLines) {
      canvas.drawLine(line.a, line.b, grid);
    }

    // `[&_.recharts-rectangle.recharts-tooltip-cursor]:fill-muted` — the band
    // behind the hovered category.
    if (cursor && activeIndex != null && layout.bars.isNotEmpty) {
      final double x = layout.categoryCoord(activeIndex!);
      final double half = layout.frame.width / layout.categoryCount / 2;
      canvas.drawRect(
        Rect.fromLTRB(
          x - half,
          layout.frame.top,
          x + half,
          layout.frame.bottom,
        ),
        Paint()..color = theme.muted,
      );
    }

    // Areas and lines enter by revealing left to right — recharts clips them
    // with an `animationClipPath` rect whose width grows, measured as
    // `<rect x="12" y="0" width="458" height="227">` on `AreaDefault`.
    canvas.save();
    canvas.clipRect(
      Rect.fromLTWH(
        layout.frame.left,
        layout.frame.top - 1,
        layout.frame.width * t,
        layout.frame.height + 2,
      ),
    );
    for (final _AreaShape area in layout.areas) {
      final Paint fill = Paint()..style = PaintingStyle.fill;
      if (area.spec.gradient != null) {
        // The gradient carries its own stops, including the `fillOpacity` the
        // caller folded into them — a `color` beside a `shader` is ignored, so
        // there is nothing to set here.
        fill.shader = area.spec.gradient!.createShader(layout.frame);
      } else {
        fill.color = (area.spec.fill ?? theme.foreground).withValues(
          alpha: area.spec.fillOpacity,
        );
      }
      canvas.drawPath(area.fill, fill);
      if (area.spec.stroke != null) {
        canvas.drawPath(
          area.stroke,
          Paint()
            ..color = area.spec.stroke!
            ..strokeWidth = area.spec.strokeWidth
            ..style = PaintingStyle.stroke,
        );
      }
    }
    for (final _LineShape line in layout.lines) {
      canvas.drawPath(
        line.path,
        Paint()
          ..color = line.spec.stroke ?? theme.foreground
          ..strokeWidth = line.spec.strokeWidth
          ..strokeCap = StrokeCap.butt
          ..strokeJoin = StrokeJoin.round
          ..style = PaintingStyle.stroke,
      );
    }
    for (final _DotShape dot in layout.dots) {
      canvas.drawCircle(
        dot.center,
        dot.dot.radius,
        Paint()..color = dot.dot.fill ?? dot.fallback ?? theme.foreground,
      );
      if (dot.dot.stroke != null) {
        canvas.drawCircle(
          dot.center,
          dot.dot.radius,
          Paint()
            ..color = dot.dot.stroke!
            ..strokeWidth = dot.dot.strokeWidth
            ..style = PaintingStyle.stroke,
        );
      }
    }
    canvas.restore();

    // A bar grows out of its own baseline instead — recharts interpolates the
    // rectangle's height, which is why §4.3 matters here: for the length of the
    // entrance the bar shows a number the data does not contain.
    for (final BarRect bar in layout.bars) {
      final Rect rect = _grow(bar, t);
      if (rect.isEmpty) continue;
      canvas.drawRRect(barRRect(rect, bar.radii), Paint()..color = bar.color);
    }
  }

  Rect _grow(BarRect bar, double t) {
    if (t >= 1) return bar.rect;
    final double base = bar.baseline ?? bar.rect.bottom;
    if (layout.horizontal) {
      return Rect.fromLTRB(
        bar.rect.left,
        base + (bar.rect.top - base) * t,
        bar.rect.right,
        base + (bar.rect.bottom - base) * t,
      );
    }
    return Rect.fromLTRB(
      base + (bar.rect.left - base) * t,
      bar.rect.top,
      base + (bar.rect.right - base) * t,
      bar.rect.bottom,
    );
  }

  @override
  bool shouldRepaint(_CartesianPainter old) =>
      old.t != t ||
      old.activeIndex != activeIndex ||
      old.theme != theme ||
      !identical(old.layout, layout);
}

/// One `<text>` on an axis or a `LabelList`, positioned by its **baseline**.
///
/// SVG anchors a tick label at a y and then pushes the glyphs down by a `dy` in
/// ems, so the only stable thing to line up across two renderers is the
/// alphabetic baseline. Placing the box instead would make every label's
/// position depend on the half-leading of a 16px line box, which is a different
/// number in Skia than it is in Blink.
class _TickLabel extends StatelessWidget {
  const _TickLabel({
    required this.tick,
    required this.color,
    required this.anchor,
  });

  final _AxisTick tick;
  final Color color;
  final _TickAnchor anchor;

  @override
  Widget build(BuildContext context) {
    final Widget text = StyledText(tick.text, ChartText.xs, color: color);
    return Transform.translate(
      offset: Offset(0, tick.baseline),
      child: Row(
        mainAxisAlignment: switch (anchor) {
          _TickAnchor.start => MainAxisAlignment.start,
          _TickAnchor.middle => MainAxisAlignment.center,
          _TickAnchor.end => MainAxisAlignment.end,
        },
        children: <Widget>[
          // The row is the full surface width, so a middle anchor is reached by
          // padding it to twice the distance from the edge the anchor is
          // measured from.
          if (anchor == _TickAnchor.middle)
            _CenteredAt(
              x: tick.x,
              child: _BaselineBox(child: text),
            )
          else if (anchor == _TickAnchor.start)
            Padding(
              padding: EdgeInsets.only(left: tick.x),
              child: _BaselineBox(child: text),
            )
          else
            _EndedAt(
              x: tick.x,
              child: _BaselineBox(child: text),
            ),
        ],
      ),
    );
  }
}

/// Lifts [child] so its alphabetic baseline sits on the enclosing translate.
class _BaselineBox extends StatelessWidget {
  const _BaselineBox({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => Baseline(
    baseline: 0,
    baselineType: TextBaseline.alphabetic,
    child: child,
  );
}

class _CenteredAt extends StatelessWidget {
  const _CenteredAt({required this.x, required this.child});
  final double x;
  final Widget child;

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.centerLeft,
    child: FractionalTranslation(
      translation: const Offset(-0.5, 0),
      child: Transform.translate(offset: Offset(x, 0), child: child),
    ),
  );
}

class _EndedAt extends StatelessWidget {
  const _EndedAt({required this.x, required this.child});
  final double x;
  final Widget child;

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.centerLeft,
    child: FractionalTranslation(
      translation: const Offset(-1, 0),
      child: Transform.translate(offset: Offset(x, 0), child: child),
    ),
  );
}

/// The painter behind `BarRect`, exposed so the package test can pin a bar's
/// rendered pixels without standing a whole chart up.
class BarSeriesPainter extends CustomPainter {
  const BarSeriesPainter({required this.bars});

  final List<BarRect> bars;

  @override
  void paint(Canvas canvas, Size size) {
    for (final BarRect bar in bars) {
      canvas.drawRRect(
        barRRect(bar.rect, bar.radii),
        Paint()..color = bar.color,
      );
    }
  }

  @override
  bool shouldRepaint(BarSeriesPainter old) => old.bars != bars;
}
