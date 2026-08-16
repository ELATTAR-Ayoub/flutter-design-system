/// The three polar families — `PieChart`, `RadarChart` and `RadialBarChart`.
///
/// One convention runs through all three and is worth stating before anything
/// else, because every coordinate below depends on it: **degrees, counter-
/// clockwise from three o'clock, negated on the way into screen space.** That
/// is recharts' own `polarToCartesian` (`util/PolarUtils.js`), it is why a pie
/// that starts at 0° starts on the right-hand side and sweeps upward, and it is
/// why `radial.tsx` and `pie.tsx` both re-derive it by hand in their label
/// chips. Here it is one function, [dsPolarToCartesian].
///
/// The measured frame, identical on all 24 polar specimens:
///
/// * surface 482 × 256, centre **(241, 128)**;
/// * `maxRadius` = `min(482 − 10, 256 − 10) / 2` = **123**, the 10 being the
///   default 5px margin on each side;
/// * a `Pie`'s default `outerRadius="80%"` = **98.4**, which is the radius the
///   radar web draws at too.
///
/// A `RadialBarChart` is the exception: its `innerRadius`/`outerRadius` are
/// given in pixels on the chart itself, and the rings are a band scale over
/// that span with the same 10% category gap and the same JS int cast a `Bar`
/// gets — `RadialSimple`'s five background rings measure 31.6…43.6, 47.6…59.6,
/// … which is `(110 − 30) / 5 = 16` per band, 1.6 of gap each side, 12 of ring.
library;

import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../foundation/spacing.dart';
import '../foundation/theme.dart';
import '../theme_scope.dart';
import 'chart.dart';
import 'chart_cartesian.dart';
import 'chart_geometry.dart';

/* ── Shared ──────────────────────────────────────────────────────────────── */

/// `PolarGrid gridType` — the page's own note: *"Polygon makes the vertices —
/// the actual axes — easy to find; circle is quieter and reads better with two
/// overlapping series."*
enum DsPolarGridType { polygon, circle }

/// `PolarGrid`.
@immutable
class DsPolarGrid {
  const DsPolarGrid({
    this.gridType = DsPolarGridType.polygon,
    this.radialLines = true,
    this.polarRadius,
    this.stroke,
    this.fills,
    this.opacity = 1,
  });

  final DsPolarGridType gridType;

  /// The spokes. Turning them off with a circle grid leaves rings only, which
  /// the page calls "the calmest of the four combinations".
  final bool radialLines;

  /// An explicit ring list — `RadarGridCustom`'s `[90]` and `RadialText`'s
  /// `[86, 74]`. Null draws one ring per radius tick.
  final List<double>? polarRadius;

  /// Null takes `--border`, which is `ui/chart.tsx`'s
  /// `[&_.recharts-polar-grid_[stroke='#ccc']]:stroke-border` sweep.
  final Color? stroke;

  /// `className="first:fill-muted last:fill-background"` — the two-ring plate
  /// under `RadialText` and `RadialShape`.
  final List<Color>? fills;

  /// `opacity-20` on the two filled radar grids.
  final double opacity;
}

/// `PolarAngleAxis`.
@immutable
class DsPolarAngleAxis {
  const DsPolarAngleAxis({
    this.dataKey,
    this.tick = true,
    this.axisLine = true,
    this.tickLine = true,
    this.domain,
    this.tickBuilder,
  });

  final String? dataKey;
  final bool tick;
  final bool axisLine;
  final bool tickLine;

  /// `type="number" domain={[0, total]}` — the explicit widening a stacked
  /// radial needs. The page's own error note: left alone it *"silently drew one
  /// third of its data"*, because the domain runs to the largest single series
  /// rather than to the stack total.
  final ({double min, double max})? domain;

  /// `tick={RadarLabelCustomTick}` — the one custom tick on the page, a
  /// two-line `desktop / mobile` caption over the month name.
  final Widget Function(BuildContext context, int index, Offset anchor,
      TextAlign align)? tickBuilder;

  /// The 8px stub between the web's outer vertex and its label. Measured on
  /// `RadarDefault`: January's vertex is (241, 29.6) and its label anchor is
  /// (241, 21.6).
  static const double tickSize = 8;
}

/// `PolarRadiusAxis`.
@immutable
class DsPolarRadiusAxis {
  const DsPolarRadiusAxis({
    this.angle = 90,
    this.tick = true,
    this.axisLine = true,
    this.stroke,
    this.centerLabel,
  });

  /// Which spoke the scale runs along. `RadarRadius` sets 60.
  final double angle;

  final bool tick;
  final bool axisLine;
  final Color? stroke;

  /// `<Label content={…} />` — the number in the hole, on four specimens.
  final WidgetBuilder? centerLabel;
}

/* ── Pie ─────────────────────────────────────────────────────────────────── */

/// One ring of a `PieChart`.
@immutable
class DsPieSpec {
  const DsPieSpec({
    required this.data,
    required this.dataKey,
    this.nameKey,
    this.innerRadius,
    this.outerRadius,
    this.startAngle = 0,
    this.endAngle = 360,
    this.paddingAngle = 0,
    this.strokeWidth = 1,
    this.activeIndex,
    this.activeGrow = 0,
    this.activeRing = false,
    this.outsideLabel = false,
    this.labelLine = true,
    this.labelBuilder,
    this.chipLabelKey,
  });

  final List<Map<String, Object?>> data;
  final String dataKey;
  final String? nameKey;

  /// Pixels, not a percentage — the registry's own value on every donut, kept
  /// per `radial.tsx`'s precedent that a polar radius is plot maths.
  final double? innerRadius;
  final double? outerRadius;

  final double startAngle;
  final double endAngle;
  final double paddingAngle;

  /// `stroke="#fff"` is recharts' default and `ui/chart.tsx` sweeps it to
  /// transparent, so what actually separates two wedges is this width of
  /// background. `PieSeparatorNone` passes 0.
  final double strokeWidth;

  /// The sector `activeShape` applies to — `defaultIndex` on the tooltip in
  /// recharts 3, which is where `activeIndex` moved to.
  final int? activeIndex;

  /// `outerRadius + 10` on the two active donuts.
  final double activeGrow;

  /// `PieInteractive`'s second `Sector`, a detached ring outside the grown one.
  final bool activeRing;

  /// `label` — the value printed outside the wedge with a leader line.
  final bool outsideLabel;
  final bool labelLine;

  /// A custom `label` render function.
  final String Function(Map<String, Object?> row)? labelBuilder;

  /// `<LabelList content={PieLabelListArcLabel} />` — the chip on the panel's
  /// own surface, at the wedge's mid-angle.
  final String? chipLabelKey;
}

/// `PieChart`.
class DsPieChart extends StatefulWidget {
  const DsPieChart({
    super.key,
    required this.pies,
    this.legend,
    this.tooltip,
    this.centerLabel,
    this.labelColor,
  });

  final List<DsPieSpec> pies;
  final DsChartLegendSpec? legend;
  final DsChartTooltipSpec? tooltip;

  /// `<Label content={…} />` inside a `Pie` — the donut's centred total.
  final WidgetBuilder? centerLabel;

  /// `[&_.recharts-pie-label-text]:fill-foreground` — the container sweep that
  /// takes the outside label off its slice's colour.
  ///
  /// The page's own finding: *"Pie labels took their slice's colour. Against
  /// `--background` the five chart tokens measure 4.34 · 10.75 · 1.88 · 13.19 ·
  /// 3.98 in dark … Three of five fail as text in dark, two in light. A fill is
  /// not text and is not held to that threshold — which is exactly why a chart
  /// token must not be reused as a label colour."*
  final Color? labelColor;

  @override
  State<DsPieChart> createState() => _DsPieChartState();
}

class _DsPieChartState extends State<DsPieChart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entrance =
      AnimationController(vsync: this, duration: DsChartMotion.duration);

  @override
  void initState() {
    super.initState();
    _entrance.value = 1;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Duration d = dsAnimationDuration(context, DsChartMotion.duration);
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
    final DsThemeData theme = DsTheme.of(context);
    final DsChartConfig config = DsChartScope.of(context);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints c) {
        final Size size = Size(c.maxWidth, c.maxHeight);
        final double legendReserve = widget.legend != null
            ? DsChartLegendSpec.reservedHeight
            : 0;
        final Size plot = Size(size.width, size.height - legendReserve);
        final Offset centre = Offset(plot.width / 2, plot.height / 2);
        final double maxRadius = dsPolarMaxRadius(plot.width, plot.height);
        final List<_Wedge> wedges = <_Wedge>[];
        final List<_ChipLabel> chips = <_ChipLabel>[];
        final List<_OutsideLabel> outside = <_OutsideLabel>[];
        for (final DsPieSpec pie in widget.pies) {
          _buildPie(pie, centre, maxRadius, wedges, chips, outside, theme);
        }
        return AnimatedBuilder(
          animation: _entrance,
          builder: (BuildContext context, Widget? _) => Stack(
            children: <Widget>[
              Positioned.fill(
                child: CustomPaint(
                  painter: _PiePainter(
                    wedges: wedges,
                    outside: outside,
                    theme: theme,
                    t: DsChartMotion.curve.transform(_entrance.value),
                    centre: centre,
                  ),
                ),
              ),
              for (final _OutsideLabel label in outside)
                _positioned(label.anchor, plot, _PolarText(
                  text: label.text,
                  color: widget.labelColor ?? theme.foreground,
                  align: label.align,
                )),
              for (final _ChipLabel chip in chips)
                _positioned(chip.anchor, plot, _ArcChip(text: chip.text)),
              if (widget.centerLabel != null)
                Positioned(
                  left: 0,
                  top: 0,
                  width: plot.width,
                  height: plot.height,
                  child: Center(child: widget.centerLabel!(context)),
                ),
              if (widget.legend != null)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: widget.legend!.offset,
                  child: DsChartLegendContent(
                    config: config,
                    wrap: widget.legend!.wrap,
                    gap: widget.legend!.gap,
                    items: <DsChartLegendItem>[
                      for (final Map<String, Object?> row in widget.pies.first.data)
                        DsChartLegendItem(
                          name: '${row[widget.legend!.nameKey ?? widget.pies.first.nameKey ?? 'name'] ?? ''}',
                          color: row['fill'] as Color?,
                        ),
                    ],
                  ),
                ),
              if (widget.tooltip?.defaultIndex != null)
                _pieTooltip(context, config, plot, centre),
            ],
          ),
        );
      },
    );
  }

  Widget _positioned(Offset at, Size plot, Widget child) => Positioned(
        left: 0,
        top: 0,
        width: plot.width,
        height: plot.height,
        child: IgnorePointer(
          child: Stack(children: <Widget>[
            Positioned(
              left: at.dx,
              top: at.dy,
              child: FractionalTranslation(
                translation: const Offset(-0.5, -0.5),
                child: child,
              ),
            ),
          ]),
        ),
      );

  Widget _pieTooltip(
    BuildContext context,
    DsChartConfig config,
    Size plot,
    Offset centre,
  ) {
    final DsChartTooltipSpec spec = widget.tooltip!;
    final DsPieSpec pie = widget.pies.first;
    final int i = spec.defaultIndex!.clamp(0, pie.data.length - 1);
    final Map<String, Object?> row = pie.data[i];
    return Positioned(
      left: centre.dx,
      top: ds(2),
      child: DsChartTooltipContent(
        config: config,
        items: <DsChartTooltipItem>[
          DsChartTooltipItem(
            name: '${row[pie.nameKey ?? 'name'] ?? pie.dataKey}',
            value: row[pie.dataKey] as num?,
            color: row['fill'] as Color?,
            payload: row,
            dataKey: pie.dataKey,
          ),
        ],
        indicator: spec.indicator,
        hideLabel: spec.hideLabel,
        hideIndicator: spec.hideIndicator,
        nameKey: spec.nameKey,
      ),
    );
  }

  void _buildPie(
    DsPieSpec pie,
    Offset centre,
    double maxRadius,
    List<_Wedge> wedges,
    List<_ChipLabel> chips,
    List<_OutsideLabel> outside,
    DsThemeData theme,
  ) {
    final double outer = pie.outerRadius ?? maxRadius * 0.8;
    final double inner = pie.innerRadius ?? 0;
    final double total = pie.data.fold<double>(
      0,
      (double a, Map<String, Object?> r) =>
          a + ((r[pie.dataKey] as num?) ?? 0).toDouble(),
    );
    final double sweepTotal = pie.endAngle - pie.startAngle;
    double angle = pie.startAngle;
    for (int i = 0; i < pie.data.length; i++) {
      final Map<String, Object?> row = pie.data[i];
      final double v = ((row[pie.dataKey] as num?) ?? 0).toDouble();
      final double sweep = total == 0 ? 0 : v / total * sweepTotal;
      final bool active = pie.activeIndex == i;
      final double grow = active ? pie.activeGrow : 0;
      wedges.add(_Wedge(
        centre: centre,
        inner: inner,
        outer: outer + grow,
        start: angle,
        end: angle + sweep,
        color: (row['fill'] as Color?) ?? theme.foreground,
        strokeWidth: pie.strokeWidth,
      ));
      if (active && pie.activeRing) {
        wedges.add(_Wedge(
          centre: centre,
          inner: outer + pie.activeGrow + 2,
          outer: outer + pie.activeGrow + 15,
          start: angle,
          end: angle + sweep,
          color: (row['fill'] as Color?) ?? theme.foreground,
          strokeWidth: pie.strokeWidth,
        ));
      }
      final double mid = angle + sweep / 2;
      if (pie.chipLabelKey != null) {
        chips.add(_ChipLabel(
          text: '${row[pie.chipLabelKey] ?? ''}',
          anchor: dsPolarToCartesian(
              centre.dx, centre.dy, (inner + outer) / 2, mid),
        ));
      }
      if (pie.outsideLabel || pie.labelBuilder != null) {
        // recharts puts the label on the same mid-angle, one third of the
        // outer radius beyond the arc.
        final Offset anchor = dsPolarToCartesian(
            centre.dx, centre.dy, outer + outer / 3, mid);
        final Offset elbow =
            dsPolarToCartesian(centre.dx, centre.dy, outer, mid);
        outside.add(_OutsideLabel(
          text: pie.labelBuilder != null
              ? pie.labelBuilder!(row)
              : dsChartNumber((row[pie.dataKey] as num?) ?? 0),
          anchor: anchor,
          elbow: elbow,
          align: math.cos(-mid * math.pi / 180) >= 0
              ? TextAlign.left
              : TextAlign.right,
          leader: pie.labelLine,
          color: (row['fill'] as Color?) ?? theme.foreground,
        ));
      }
      angle += sweep;
    }
  }
}

@immutable
class _Wedge {
  const _Wedge({
    required this.centre,
    required this.inner,
    required this.outer,
    required this.start,
    required this.end,
    required this.color,
    required this.strokeWidth,
  });

  final Offset centre;
  final double inner;
  final double outer;
  final double start;
  final double end;
  final Color color;
  final double strokeWidth;
}

@immutable
class _ChipLabel {
  const _ChipLabel({required this.text, required this.anchor});
  final String text;
  final Offset anchor;
}

@immutable
class _OutsideLabel {
  const _OutsideLabel({
    required this.text,
    required this.anchor,
    required this.elbow,
    required this.align,
    required this.leader,
    required this.color,
  });

  final String text;
  final Offset anchor;
  final Offset elbow;
  final TextAlign align;
  final bool leader;
  final Color color;
}

class _PiePainter extends CustomPainter {
  const _PiePainter({
    required this.wedges,
    required this.outside,
    required this.theme,
    required this.t,
    required this.centre,
  });

  final List<_Wedge> wedges;
  final List<_OutsideLabel> outside;
  final DsThemeData theme;
  final double t;
  final Offset centre;

  @override
  void paint(Canvas canvas, Size size) {
    for (final _Wedge w in wedges) {
      // A pie enters by sweeping its own angle, which is recharts' own
      // interpolation and the reason §4.3 bites here: a half-swept pie is a
      // share the data does not contain.
      final double end = w.start + (w.end - w.start) * t;
      if ((end - w.start).abs() < 0.01) continue;
      final Path path = dsSectorPath(
        cx: w.centre.dx,
        cy: w.centre.dy,
        innerRadius: w.inner,
        outerRadius: w.outer,
        startAngle: w.start,
        endAngle: end,
      );
      canvas.drawPath(path, Paint()..color = w.color);
      if (w.strokeWidth > 0) {
        // `[&_.recharts-sector[stroke='#fff']]:stroke-transparent` — the wedge
        // separator is a stroke of the surface, not of a colour.
        canvas.drawPath(
          path,
          Paint()
            ..color = theme.background
            ..strokeWidth = w.strokeWidth
            ..style = PaintingStyle.stroke,
        );
      }
    }
    for (final _OutsideLabel label in outside) {
      if (!label.leader) continue;
      canvas.drawLine(
        label.elbow,
        label.anchor,
        Paint()
          ..color = label.color
          ..strokeWidth = DsWidths.hairline
          ..style = PaintingStyle.stroke,
      );
    }
  }

  @override
  bool shouldRepaint(_PiePainter old) => old.t != t || old.theme != theme;
}

/* ── Radar ───────────────────────────────────────────────────────────────── */

/// One `Radar` series.
@immutable
class DsRadarSpec {
  const DsRadarSpec({
    required this.dataKey,
    this.fill,
    this.fillOpacity = 1,
    this.stroke,
    this.strokeWidth = 1,
    this.dot,
  });

  final String dataKey;
  final Color? fill;

  /// The page's own note: *"Two overlapping radars need both fills translucent
  /// or the second one erases the first."* The registry gives `mobile` no
  /// `fillOpacity` at all on five variants, so the second polygon paints fully
  /// opaque over the first — kept, because it is the registry's own choice.
  final double fillOpacity;

  final Color? stroke;
  final double strokeWidth;
  final DsChartDotSpec? dot;
}

/// `dot={{ r: 4, fillOpacity: 1 }}`.
@immutable
class DsChartDotSpec {
  const DsChartDotSpec({this.radius = 4, this.fillOpacity = 1});
  final double radius;
  final double fillOpacity;
}

/// `RadarChart`.
class DsRadarChart extends StatefulWidget {
  const DsRadarChart({
    super.key,
    required this.data,
    required this.series,
    this.grid,
    this.angleAxis,
    this.radiusAxis,
    this.legend,
    this.margin = DsChartMargin.standard,
  });

  final List<Map<String, Object?>> data;
  final List<DsRadarSpec> series;
  final DsPolarGrid? grid;
  final DsPolarAngleAxis? angleAxis;
  final DsPolarRadiusAxis? radiusAxis;
  final DsChartLegendSpec? legend;
  final DsChartMargin margin;

  /// `RadarChart`'s own defaults — twelve o'clock, all the way round.
  static const double startAngle = 90;
  static const double endAngle = -270;

  @override
  State<DsRadarChart> createState() => _DsRadarChartState();
}

class _DsRadarChartState extends State<DsRadarChart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entrance =
      AnimationController(vsync: this, duration: DsChartMotion.duration);

  @override
  void initState() {
    super.initState();
    _entrance.value = 1;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Duration d = dsAnimationDuration(context, DsChartMotion.duration);
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
    final DsThemeData theme = DsTheme.of(context);
    final DsChartConfig config = DsChartScope.of(context);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints c) {
        final double legendReserve =
            widget.legend != null ? DsChartLegendSpec.reservedHeight : 0;
        final Rect box = Rect.fromLTRB(
          widget.margin.left,
          widget.margin.top,
          c.maxWidth - widget.margin.right,
          c.maxHeight - widget.margin.bottom - legendReserve,
        );
        final Offset centre = box.center;
        final double radius =
            dsPolarMaxRadius(box.width + 10, box.height + 10) * 0.8;
        final int n = widget.data.length;
        final double step =
            n == 0 ? 0 : (DsRadarChart.endAngle - DsRadarChart.startAngle) / n;
        final List<double> angles = <double>[
          for (int i = 0; i < n; i++) DsRadarChart.startAngle + step * i,
        ];

        double maxValue = 0;
        for (final Map<String, Object?> row in widget.data) {
          for (final DsRadarSpec s in widget.series) {
            maxValue = math.max(
                maxValue, ((row[s.dataKey] as num?) ?? 0).toDouble());
          }
        }
        final DsLinearScale scale = DsLinearScale.nice(
          dataMin: 0,
          dataMax: maxValue,
          rangeStart: 0,
          rangeEnd: radius,
        );
        final List<double> ringRadii = widget.grid?.polarRadius ??
            <double>[for (final double v in scale.ticks()) scale.scale(v)];

        return AnimatedBuilder(
          animation: _entrance,
          builder: (BuildContext context, Widget? _) => Stack(
            children: <Widget>[
              Positioned.fill(
                child: CustomPaint(
                  painter: _RadarPainter(
                    data: widget.data,
                    series: widget.series,
                    grid: widget.grid,
                    angleAxis: widget.angleAxis,
                    radiusAxis: widget.radiusAxis,
                    centre: centre,
                    radius: radius,
                    angles: angles,
                    ringRadii: ringRadii,
                    scale: scale,
                    theme: theme,
                    t: DsChartMotion.curve.transform(_entrance.value),
                  ),
                ),
              ),
              if (widget.angleAxis?.tick ?? false)
                ..._angleLabels(context, centre, radius, angles, theme, box),
              if ((widget.radiusAxis?.tick ?? false))
                ..._radiusLabels(context, centre, scale, theme, box),
              if (widget.legend != null)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: widget.legend!.offset,
                  child: DsChartLegendContent(
                    config: config,
                    items: <DsChartLegendItem>[
                      for (final DsRadarSpec s in widget.series)
                        DsChartLegendItem(name: s.dataKey, color: s.fill),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _angleLabels(
    BuildContext context,
    Offset centre,
    double radius,
    List<double> angles,
    DsThemeData theme,
    Rect box,
  ) {
    final DsPolarAngleAxis axis = widget.angleAxis!;
    return <Widget>[
      for (int i = 0; i < angles.length; i++)
        _PolarLabel(
          box: box,
          anchor: dsPolarToCartesian(
            centre.dx,
            centre.dy,
            radius + DsPolarAngleAxis.tickSize,
            angles[i],
          ),
          angle: angles[i],
          child: axis.tickBuilder != null
              ? axis.tickBuilder!(
                  context,
                  i,
                  dsPolarToCartesian(centre.dx, centre.dy,
                      radius + DsPolarAngleAxis.tickSize, angles[i]),
                  _alignFor(angles[i]),
                )
              : DsText(
                  '${widget.data[i][axis.dataKey] ?? ''}',
                  DsChartText.xs,
                  color: theme.mutedForeground,
                ),
        ),
    ];
  }

  List<Widget> _radiusLabels(
    BuildContext context,
    Offset centre,
    DsLinearScale scale,
    DsThemeData theme,
    Rect box,
  ) {
    final DsPolarRadiusAxis axis = widget.radiusAxis!;
    return <Widget>[
      for (final double v in scale.ticks())
        _PolarLabel(
          box: box,
          anchor: dsPolarToCartesian(
              centre.dx, centre.dy, scale.scale(v), axis.angle),
          angle: axis.angle,
          child: DsText(
            dsChartNumber(v),
            DsChartText.xs,
            color: theme.mutedForeground,
          ),
        ),
    ];
  }

  static TextAlign _alignFor(double angle) {
    final double c = math.cos(-angle * math.pi / 180);
    if (c > 0.2) return TextAlign.left;
    if (c < -0.2) return TextAlign.right;
    return TextAlign.center;
  }
}

/// A label pinned to a polar anchor, centred on it.
class _PolarLabel extends StatelessWidget {
  const _PolarLabel({
    required this.box,
    required this.anchor,
    required this.angle,
    required this.child,
  });

  final Rect box;
  final Offset anchor;
  final double angle;
  final Widget child;

  @override
  Widget build(BuildContext context) => Positioned(
        left: anchor.dx,
        top: anchor.dy,
        child: FractionalTranslation(
          translation: _shift(angle),
          child: child,
        ),
      );

  /// recharts anchors a polar tick by `text-anchor` and a `dy`, which is a
  /// horizontal alignment chosen from the angle's cosine and a vertical one
  /// from its sine. The same choice, as a fractional offset.
  static Offset _shift(double angle) {
    final double c = math.cos(-angle * math.pi / 180);
    final double s = math.sin(-angle * math.pi / 180);
    final double dx = c > 0.2 ? 0 : (c < -0.2 ? -1 : -0.5);
    final double dy = s > 0.2 ? 0 : (s < -0.2 ? -1 : -0.5);
    return Offset(dx, dy);
  }
}

class _RadarPainter extends CustomPainter {
  const _RadarPainter({
    required this.data,
    required this.series,
    required this.grid,
    required this.angleAxis,
    required this.radiusAxis,
    required this.centre,
    required this.radius,
    required this.angles,
    required this.ringRadii,
    required this.scale,
    required this.theme,
    required this.t,
  });

  final List<Map<String, Object?>> data;
  final List<DsRadarSpec> series;
  final DsPolarGrid? grid;
  final DsPolarAngleAxis? angleAxis;
  final DsPolarRadiusAxis? radiusAxis;
  final Offset centre;
  final double radius;
  final List<double> angles;
  final List<double> ringRadii;
  final DsLinearScale scale;
  final DsThemeData theme;
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final DsPolarGrid? g = grid;
    if (g != null) {
      final Paint stroke = Paint()
        ..color = (g.stroke ?? theme.border).withValues(alpha: g.opacity)
        ..strokeWidth = DsWidths.hairline
        ..style = PaintingStyle.stroke;
      for (int r = 0; r < ringRadii.length; r++) {
        final double rr = ringRadii[r];
        final Path ring = g.gridType == DsPolarGridType.circle
            ? (Path()
              ..addOval(Rect.fromCircle(center: centre, radius: rr)))
            : dsPolarPolygonPath(<Offset>[
                for (final double a in angles)
                  dsPolarToCartesian(centre.dx, centre.dy, rr, a),
              ]);
        final List<Color>? fills = g.fills;
        if (fills != null && fills.isNotEmpty) {
          final Color fill = r == 0
              ? fills.first
              : (r == ringRadii.length - 1 ? fills.last : fills.first);
          canvas.drawPath(ring, Paint()..color = fill.withValues(alpha: g.opacity));
        }
        canvas.drawPath(ring, stroke);
      }
      if (g.radialLines) {
        for (final double a in angles) {
          canvas.drawLine(
            centre,
            dsPolarToCartesian(centre.dx, centre.dy, radius, a),
            stroke,
          );
        }
      }
    }

    for (final DsRadarSpec s in series) {
      final List<Offset> points = <Offset>[
        for (int i = 0; i < data.length; i++)
          dsPolarToCartesian(
            centre.dx,
            centre.dy,
            scale.scale(((data[i][s.dataKey] as num?) ?? 0).toDouble()) * t,
            angles[i],
          ),
      ];
      final Path path = dsPolarPolygonPath(points);
      if (s.fill != null && s.fillOpacity > 0) {
        canvas.drawPath(
          path,
          Paint()..color = s.fill!.withValues(alpha: s.fillOpacity),
        );
      }
      if (s.stroke != null) {
        canvas.drawPath(
          path,
          Paint()
            ..color = s.stroke!
            ..strokeWidth = s.strokeWidth
            ..style = PaintingStyle.stroke,
        );
      }
      final DsChartDotSpec? dot = s.dot;
      if (dot != null) {
        for (final Offset p in points) {
          canvas.drawCircle(
            p,
            dot.radius,
            Paint()
              ..color = (s.fill ?? theme.foreground)
                  .withValues(alpha: dot.fillOpacity),
          );
        }
      }
    }

    // The angle axis's own outline and its 8px tick stubs.
    final DsPolarAngleAxis? axis = angleAxis;
    if (axis != null) {
      final Paint stroke = Paint()
        ..color = theme.border
        ..strokeWidth = DsWidths.hairline
        ..style = PaintingStyle.stroke;
      if (axis.axisLine) {
        canvas.drawPath(
          dsPolarPolygonPath(<Offset>[
            for (final double a in angles)
              dsPolarToCartesian(centre.dx, centre.dy, radius, a),
          ]),
          stroke,
        );
      }
      if (axis.tickLine) {
        for (final double a in angles) {
          canvas.drawLine(
            dsPolarToCartesian(centre.dx, centre.dy, radius, a),
            dsPolarToCartesian(
                centre.dx, centre.dy, radius + DsPolarAngleAxis.tickSize, a),
            stroke,
          );
        }
      }
    }

    final DsPolarRadiusAxis? rAxis = radiusAxis;
    if (rAxis != null && rAxis.axisLine) {
      canvas.drawLine(
        centre,
        dsPolarToCartesian(centre.dx, centre.dy, radius, rAxis.angle),
        Paint()
          ..color = rAxis.stroke ?? theme.border
          ..strokeWidth = DsWidths.hairline
          ..style = PaintingStyle.stroke,
      );
    }
  }

  @override
  bool shouldRepaint(_RadarPainter old) => old.t != t || old.theme != theme;
}

/* ── Radial bar ──────────────────────────────────────────────────────────── */

/// One `RadialBar`.
@immutable
class DsRadialBarSpec {
  const DsRadialBarSpec({
    required this.dataKey,
    this.fill,
    this.background = false,
    this.cornerRadius = 0,
    this.stackId,
    this.chipLabelKey,
  });

  final String dataKey;

  /// Null reads each row's own `fill`, which is how `RadialSimple` gets five
  /// colours out of one series.
  final Color? fill;

  /// *"Draws the unfilled remainder of each ring. `ChartContainer` already
  /// paints it `--muted`, so it needs no colour of its own."*
  final bool background;

  /// From the radius ladder, read by the caller — `--radius-md` on the single
  /// ring and `--radius-sm` on the stacked bands.
  final double cornerRadius;

  final String? stackId;

  /// `<LabelList content={RadialArcLabel} />` — the chip at the arc's START
  /// angle, which is the only placement where five labels cannot collide.
  final String? chipLabelKey;
}

/// `RadialBarChart`.
class DsRadialBarChart extends StatefulWidget {
  const DsRadialBarChart({
    super.key,
    required this.data,
    required this.series,
    required this.innerRadius,
    required this.outerRadius,
    this.startAngle = 0,
    this.endAngle = 360,
    this.grid,
    this.angleAxis,
    this.radiusAxis,
    this.tooltip,
  });

  final List<Map<String, Object?>> data;
  final List<DsRadialBarSpec> series;
  final double innerRadius;
  final double outerRadius;

  /// *"Degrees, counter-clockwise from three o'clock. 180 → 0 is the top half.
  /// Angles are not a token family, so these are written plainly."*
  final double startAngle;
  final double endAngle;

  final DsPolarGrid? grid;
  final DsPolarAngleAxis? angleAxis;
  final DsPolarRadiusAxis? radiusAxis;
  final DsChartTooltipSpec? tooltip;

  @override
  State<DsRadialBarChart> createState() => _DsRadialBarChartState();
}

class _DsRadialBarChartState extends State<DsRadialBarChart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entrance =
      AnimationController(vsync: this, duration: DsChartMotion.duration);

  @override
  void initState() {
    super.initState();
    _entrance.value = 1;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Duration d = dsAnimationDuration(context, DsChartMotion.duration);
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
    final DsThemeData theme = DsTheme.of(context);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints c) {
        final Offset centre = Offset(c.maxWidth / 2, c.maxHeight / 2);
        final int rows = widget.data.length;
        final double bandSize =
            rows == 0 ? 0 : (widget.outerRadius - widget.innerRadius) / rows;
        final List<DsBarSlot> slots =
            dsBarSlots(bandSize: bandSize, barCount: 1);
        final double slotOffset = slots.isEmpty ? 0 : slots.single.offset;
        final double slotSize = slots.isEmpty ? 0 : slots.single.size;

        // The angle axis's domain: the explicit one when a stacked chart
        // widened it, otherwise the largest single value.
        double domainMax = widget.angleAxis?.domain?.max ?? 0;
        if (widget.angleAxis?.domain == null) {
          for (final Map<String, Object?> row in widget.data) {
            for (final DsRadialBarSpec s in widget.series) {
              domainMax = math.max(
                  domainMax, ((row[s.dataKey] as num?) ?? 0).toDouble());
            }
          }
        }

        final List<_Arc> arcs = <_Arc>[];
        final List<_ChipLabel> chips = <_ChipLabel>[];
        final double sweepTotal = widget.endAngle - widget.startAngle;
        for (int i = 0; i < rows; i++) {
          final Map<String, Object?> row = widget.data[i];
          final double inner =
              widget.innerRadius + bandSize * i + slotOffset;
          final double outer = inner + slotSize;
          double accumulated = 0;
          for (final DsRadialBarSpec s in widget.series) {
            final double v = ((row[s.dataKey] as num?) ?? 0).toDouble();
            final double from = widget.startAngle +
                (domainMax == 0 ? 0 : accumulated / domainMax * sweepTotal);
            final double to = widget.startAngle +
                (domainMax == 0
                    ? 0
                    : (accumulated + v) / domainMax * sweepTotal);
            if (s.background && s.stackId == null) {
              arcs.add(_Arc(
                inner: inner,
                outer: outer,
                start: widget.startAngle,
                end: widget.endAngle,
                color: theme.muted,
                cornerRadius: s.cornerRadius,
                background: true,
              ));
            }
            arcs.add(_Arc(
              inner: inner,
              outer: outer,
              start: from,
              end: to,
              color: s.fill ?? (row['fill'] as Color?) ?? theme.foreground,
              cornerRadius: s.cornerRadius,
              background: false,
            ));
            if (s.chipLabelKey != null) {
              chips.add(_ChipLabel(
                text: '${row[s.chipLabelKey] ?? ''}',
                anchor: dsPolarToCartesian(
                    centre.dx, centre.dy, (inner + outer) / 2, from),
              ));
            }
            if (s.stackId != null) accumulated += v;
          }
        }

        return AnimatedBuilder(
          animation: _entrance,
          builder: (BuildContext context, Widget? _) => Stack(
            children: <Widget>[
              Positioned.fill(
                child: CustomPaint(
                  painter: _RadialPainter(
                    arcs: arcs,
                    grid: widget.grid,
                    centre: centre,
                    theme: theme,
                    t: DsChartMotion.curve.transform(_entrance.value),
                  ),
                ),
              ),
              for (final _ChipLabel chip in chips)
                Positioned(
                  left: chip.anchor.dx,
                  top: chip.anchor.dy,
                  child: FractionalTranslation(
                    translation: const Offset(-0.5, -0.5),
                    child: _ArcChip(text: chip.text),
                  ),
                ),
              if (widget.radiusAxis?.centerLabel != null)
                Positioned.fill(
                  child: Center(
                      child: widget.radiusAxis!.centerLabel!(context)),
                ),
            ],
          ),
        );
      },
    );
  }
}

@immutable
class _Arc {
  const _Arc({
    required this.inner,
    required this.outer,
    required this.start,
    required this.end,
    required this.color,
    required this.cornerRadius,
    required this.background,
  });

  final double inner;
  final double outer;
  final double start;
  final double end;
  final Color color;
  final double cornerRadius;
  final bool background;
}

class _RadialPainter extends CustomPainter {
  const _RadialPainter({
    required this.arcs,
    required this.grid,
    required this.centre,
    required this.theme,
    required this.t,
  });

  final List<_Arc> arcs;
  final DsPolarGrid? grid;
  final Offset centre;
  final DsThemeData theme;
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final DsPolarGrid? g = grid;
    if (g != null) {
      final List<double> radii = g.polarRadius ?? const <double>[];
      for (int i = 0; i < radii.length; i++) {
        final Path ring = Path()
          ..addOval(Rect.fromCircle(center: centre, radius: radii[i]));
        final List<Color>? fills = g.fills;
        if (fills != null && fills.isNotEmpty) {
          canvas.drawPath(
            ring,
            Paint()
              ..color = i == 0 ? fills.first : fills.last,
          );
        }
        if (g.stroke != null) {
          canvas.drawPath(
            ring,
            Paint()
              ..color = g.stroke!
              ..strokeWidth = DsWidths.hairline
              ..style = PaintingStyle.stroke,
          );
        }
      }
    }
    for (final _Arc arc in arcs) {
      final double end =
          arc.background ? arc.end : arc.start + (arc.end - arc.start) * t;
      if ((end - arc.start).abs() < 0.01) continue;
      final Path path = arc.cornerRadius > 0
          ? dsSectorWithCornerPath(
              cx: centre.dx,
              cy: centre.dy,
              innerRadius: arc.inner,
              outerRadius: arc.outer,
              startAngle: arc.start,
              endAngle: end,
              cornerRadius: arc.cornerRadius,
            )
          : dsSectorPath(
              cx: centre.dx,
              cy: centre.dy,
              innerRadius: arc.inner,
              outerRadius: arc.outer,
              startAngle: arc.start,
              endAngle: end,
            );
      canvas.drawPath(path, Paint()..color = arc.color);
    }
  }

  @override
  bool shouldRepaint(_RadialPainter old) => old.t != t || old.theme != theme;
}

/* ── The label chip ──────────────────────────────────────────────────────── */

/// `RadialArcLabel` / `PieLabelListArcLabel` — the label on a chip of the
/// panel's own surface rather than on the arc.
///
/// The reasoning is the most consequential measurement in the whole family and
/// belongs with the widget rather than in a page comment:
///
/// > `--chart-1` is `var(--color-action)`, `#1a6ef4`, and its measured relative
/// > luminance is **0.179** — within a thousandth of √(1.05 × 0.05) − 0.05 =
/// > 0.1791, the luminance at which black and white are EQUALLY legible and
/// > every colour is at its least. Pure white reads **4.58:1** on it and pure
/// > black reads **4.58:1** on it. So 4.58 is the ceiling for any ink
/// > whatsoever, in either theme, and only the two extremes reach it — which
/// > `literal-bw` forbids writing in any case.
///
/// So the label stops sitting on the fill. `bg-card` + `text-card-foreground`
/// is the pair every `Card` and `Panel` already pairs, and on a `Panel` — which
/// is `bg-card` — what you see is the label written on the panel with the arc
/// broken behind it. Measured after the change: **16.97:1** dark, **19.90:1**
/// light, for all five slots instead of ten separate ratios.
class _ArcChip extends StatelessWidget {
  const _ArcChip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ds(2)),
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(DsRadii.pill),
      ),
      child: DsText(
        // `capitalize`.
        text.isEmpty ? text : '${text[0].toUpperCase()}${text.substring(1)}',
        DsChartText.xs,
        color: theme.cardForeground,
      ),
    );
  }
}

/// A pie's outside label — `<text>` on `--foreground`, never on the slice.
class _PolarText extends StatelessWidget {
  const _PolarText({
    required this.text,
    required this.color,
    required this.align,
  });

  final String text;
  final Color color;
  final TextAlign align;

  @override
  Widget build(BuildContext context) =>
      DsText(text, DsChartText.xs, color: color, align: align);
}
