/// The maths under every chart on `/design-system/components/base/charts`.
///
/// The reference draws with **recharts 3.8**, which draws with **d3-shape** and
/// **recharts-scale**. None of that exists in Flutter, so the geometry those
/// three libraries produce is ported here directly and then checked against the
/// rendered SVG rather than against their documentation. Every algorithm below
/// names the file it came from; every constant it carries is plot maths — a
/// margin box, a band gap, a sweep in degrees — which is the one class of
/// number §0 does not own. The values that ARE token-governed (the bar's corner
/// radius, the entrance duration, every series colour) are read off the
/// foundation by the callers and threaded in.
///
/// **Why the geometry was measured and not derived.** `chart.tsx`'s own header
/// records two AA failures found only by rasterising, and `radar.tsx` records a
/// fill that compiled, passed both guards and painted nothing. This file's
/// numbers were pinned the same way: a puppeteer pass over the live page dumped
/// all 72 specimens' `<svg>` subtrees, and the tick positions, grid rules, bar
/// rectangles, sector `d`s and radar polygons below reproduce those to the
/// hundredth of a pixel. The probe corrections are listed on the individual
/// functions that changed because of them.
library;

import 'dart:math' as math;
import 'dart:ui' show Offset, Path, Rect, RRect, Radius;

/* ── Nice ticks ──────────────────────────────────────────────────────────── */

/// `recharts/util/scale/getNiceTickValues.js` — the tick values a numeric axis
/// actually renders, which are also what fixes the axis **domain**.
///
/// This is the single most load-bearing routine in the file, because nothing
/// else on a cartesian chart can be placed until it has run: recharts nices the
/// data extent outward to round numbers and then scales against the niced
/// interval, not against the data. `MONTHS_DESKTOP` peaks at 305 and the plot
/// puts it at y=10.594 of 226 — which is 305/**320**, not 305/305. Reading the
/// path back is how the 320 was found.
///
/// [tickCount] is `CartesianAxis`'s own default of 5 at every call site on the
/// page; [allowDecimals] is likewise recharts' default `true`.
///
/// The reference runs this on `decimal.js-light` for exact decimal arithmetic.
/// Doubles are used here and the difference is unreachable at these magnitudes
/// — every domain on the page is a whole-number count under 3000 — but the two
/// places where binary rounding could show (`_modulo` and the `rangeStep`
/// accumulator) are written to snap, so a step of 80 cannot drift to 79.999.
List<double> chartNiceTicks(
  double min,
  double max, {
  int tickCount = 5,
  bool allowDecimals = true,
}) {
  final int count = math.max(tickCount, 2);
  double lo = math.min(min, max);
  double hi = math.max(min, max);
  if (lo == hi) return _tickOfSingleValue(lo, tickCount, allowDecimals);

  final _NiceStep step = _calculateStep(lo, hi, count, allowDecimals, 0);
  final List<double> values = <double>[];
  // `rangeStep(tickMin, tickMax + 0.1 * step, step)` — the 10% overshoot is
  // recharts' own guard against the last tick being lost to binary rounding.
  final double end = step.tickMax + 0.1 * step.step;
  double v = step.tickMin;
  int i = 0;
  while (v < end && i < 100000) {
    values.add(_snap(v));
    v += step.step;
    i++;
  }
  if (min > max) return values.reversed.toList();
  return values;
}

/// The domain a numeric axis ends up with: the niced ticks' own extremes.
///
/// recharts computes this as a side effect of ticking, which is why the two are
/// returned from one place here rather than derived twice.
({double min, double max}) chartNiceDomain(
  double min,
  double max, {
  int tickCount = 5,
  bool allowDecimals = true,
}) {
  final List<double> ticks = chartNiceTicks(
    min,
    max,
    tickCount: tickCount,
    allowDecimals: allowDecimals,
  );
  if (ticks.isEmpty) return (min: min, max: max);
  return (min: ticks.first, max: ticks.last);
}

class _NiceStep {
  const _NiceStep(this.step, this.tickMin, this.tickMax);
  final double step;
  final double tickMin;
  final double tickMax;
}

/// `getAdaptiveStep` — round the rough step up to a readable one.
double _adaptiveStep(double roughStep, bool allowDecimals, int correction) {
  if (roughStep <= 0) return 0;
  final int digitCount = _digitCount(roughStep);
  final double magnitude = math.pow(10, digitCount).toDouble();
  final double stepRatio = roughStep / magnitude;
  final double scale = digitCount != 1 ? 0.05 : 0.1;
  final double amended =
      ((stepRatio / scale).ceil() + correction).toDouble() * scale;
  final double formatted = amended * magnitude;
  return allowDecimals ? _snap(formatted) : formatted.ceilToDouble();
}

_NiceStep _calculateStep(
  double min,
  double max,
  int tickCount,
  bool allowDecimals,
  int correction,
) {
  final double rough = (max - min) / (tickCount - 1);
  if (!rough.isFinite) return const _NiceStep(0, 0, 0);
  final double step = _adaptiveStep(rough, allowDecimals, correction);
  if (step <= 0) return const _NiceStep(0, 0, 0);

  double middle;
  if (min <= 0 && max >= 0) {
    // When 0 is inside the interval, 0 has to be a tick.
    middle = 0;
  } else {
    middle = (min + max) / 2;
    middle = middle - _modulo(middle, step);
  }
  int belowCount = ((middle - min) / step).ceil();
  int upCount = ((max - middle) / step).ceil();
  final int scaleCount = belowCount + upCount + 1;
  if (scaleCount > tickCount) {
    // More ticks are needed to cover the interval, so the step must grow.
    return _calculateStep(min, max, tickCount, allowDecimals, correction + 1);
  }
  if (scaleCount < tickCount) {
    if (max > 0) {
      upCount += tickCount - scaleCount;
    } else {
      belowCount += tickCount - scaleCount;
    }
  }
  return _NiceStep(
    step,
    _snap(middle - belowCount * step),
    _snap(middle + upCount * step),
  );
}

List<double> _tickOfSingleValue(double value, int tickCount, bool decimals) {
  double step = 1;
  double middle = value;
  if (middle != middle.roundToDouble() && decimals) {
    final double abs = value.abs();
    if (abs < 1) {
      step = math.pow(10, _digitCount(value) - 1).toDouble();
      middle = (middle / step).floorToDouble() * step;
    } else if (abs > 1) {
      middle = value.floorToDouble();
    }
  } else if (value == 0) {
    middle = ((tickCount - 1) / 2).floorToDouble();
  } else if (!decimals) {
    middle = value.floorToDouble();
  }
  final int middleIndex = ((tickCount - 1) / 2).floor();
  return <double>[
    for (int i = 0; i < tickCount; i++)
      _snap(middle + (i - middleIndex) * step),
  ];
}

/// `getDigitCount` — 0 for values in [0.1, 1), 1 for [1, 10), and so on.
int _digitCount(double value) {
  if (value == 0) return 1;
  return (math.log(value.abs()) / math.ln10).floor() + 1;
}

/// JS `%` on a double pair, which is `remainder` and not Dart's `%`.
double _modulo(double a, double b) => a.remainder(b);

/// Kills the 1e-13 tail a repeated `+= step` accumulates, so a tick that should
/// read 240 does not render as 239.99999999999997 in a label.
double _snap(double v) {
  final double r = double.parse(v.toStringAsPrecision(12));
  return r == 0 ? 0 : r;
}

/* ── Scales ──────────────────────────────────────────────────────────────── */

/// A categorical axis, `d3-scale`'s `scaleBand` as recharts configures it.
///
/// `paddingInner`/`paddingOuter` are both 0 on every chart on the page, so the
/// band is a plain even division — but the class keeps them because the
/// *bandwidth* is what `Bar` divides up and what `XAxis` centres a tick in, and
/// those are two different readings of the same number.
class BandScale {
  const BandScale({
    required this.count,
    required this.start,
    required this.extent,
    this.reversed = false,
  });

  final int count;

  /// The plot edge the first band starts at.
  final double start;

  /// The full run the bands divide.
  final double extent;

  /// Categories run the other way — a `layout="vertical"` chart's Y axis.
  final bool reversed;

  double get bandwidth => count == 0 ? 0 : extent / count;

  /// The band's leading edge.
  double bandStart(int index) {
    final int i = reversed ? count - 1 - index : index;
    return start + bandwidth * i;
  }

  /// The band's centre — where a tick label and a `Line`/`Area` vertex sit.
  double center(int index) => bandStart(index) + bandwidth / 2;
}

/// A categorical axis as recharts renders it for `Line`/`Area` — the "point"
/// reading of the same band scale, with the first and last points ON the plot
/// edges rather than inside their bands.
///
/// Measured: `AreaDefault`'s six vertices land at 12 · 103.6 · 195.2 · 286.8 ·
/// 378.4 · 470 across a 458-wide plot — a 91.6 step, which is `extent/(n-1)`
/// and not `extent/n`. A band reading would have put January at 50.17.
class PointScale {
  const PointScale({
    required this.count,
    required this.start,
    required this.extent,
  });

  final int count;
  final double start;
  final double extent;

  double get step => count < 2 ? 0 : extent / (count - 1);

  double at(int index) => count < 2 ? start + extent / 2 : start + step * index;
}

/// A numeric axis: linear, over the **niced** domain.
class LinearScale {
  const LinearScale({
    required this.domainMin,
    required this.domainMax,
    required this.rangeStart,
    required this.rangeEnd,
  });

  /// Builds the scale recharts builds for a value axis: nice the extent, then
  /// map the niced interval onto the range.
  ///
  /// [includeZero] is recharts' `domain={[0, 'auto']}` default for a value axis
  /// on `Area`/`Bar`/`Line` — the baseline is always in the domain unless the
  /// data itself crosses zero, in which case it already is.
  factory LinearScale.nice({
    required double dataMin,
    required double dataMax,
    required double rangeStart,
    required double rangeEnd,
    int tickCount = 5,
    bool includeZero = true,
  }) {
    double lo = includeZero ? math.min(0, dataMin) : dataMin;
    double hi = includeZero ? math.max(0, dataMax) : dataMax;
    if (lo == hi) hi = lo + 1;
    final ({double min, double max}) d = chartNiceDomain(
      lo,
      hi,
      tickCount: tickCount,
    );
    return LinearScale(
      domainMin: d.min,
      domainMax: d.max,
      rangeStart: rangeStart,
      rangeEnd: rangeEnd,
    );
  }

  final double domainMin;
  final double domainMax;

  /// Where `domainMin` lands. For a Y axis this is the BOTTOM of the plot, so
  /// [rangeStart] is the larger pixel value — the flip is in the caller's
  /// arguments, never in the arithmetic.
  final double rangeStart;
  final double rangeEnd;

  double scale(double value) {
    final double span = domainMax - domainMin;
    if (span == 0) return rangeStart;
    return rangeStart + (value - domainMin) / span * (rangeEnd - rangeStart);
  }

  List<double> ticks({int tickCount = 5}) =>
      chartNiceTicks(domainMin, domainMax, tickCount: tickCount);
}

/* ── Bar layout ──────────────────────────────────────────────────────────── */

/// One `Bar`'s offset inside its band, and its width.
typedef BarSlot = ({double offset, double size});

/// `recharts/state/selectors/combiners/combineAllBarPositions.js`.
///
/// [barCategoryGapRatio] is the `'10%'` default expressed as a fraction, and
/// [barGap] the 4px default between two bars in one category.
///
/// **The truncation is not incidental.** recharts writes `originalSize >>= 0`,
/// a JS int cast, so a computed 62.933 becomes **62** and the band ends up with
/// an asymmetric right gap — measured 7.8667 left and 8.8 right on
/// `BarDefault`. Rounding instead of truncating shifts every bar on the page by
/// up to half a pixel and lands the last one outside the grid.
List<BarSlot> barSlots({
  required double bandSize,
  required int barCount,
  double barCategoryGapRatio = 0.1,
  double barGap = 4,
}) {
  if (barCount < 1) return const <BarSlot>[];
  final double offset = bandSize * barCategoryGapRatio;
  double gap = barGap;
  if (bandSize - 2 * offset - (barCount - 1) * gap <= 0) gap = 0;
  double original = (bandSize - 2 * offset - (barCount - 1) * gap) / barCount;
  if (original > 1) original = original.truncateToDouble();
  return <BarSlot>[
    for (int i = 0; i < barCount; i++)
      (offset: offset + (original + gap) * i, size: original),
  ];
}

/* ── Rectangles ──────────────────────────────────────────────────────────── */

/// `recharts/shape/Rectangle.js` — `getRectanglePath`, as an [RRect].
///
/// [radii] is the `radius={[tl, tr, br, bl]}` tuple in recharts' own order.
/// Each corner is clamped to `min(|w|, |h|) / 2`, which is what stops a stacked
/// segment shorter than its own radius from turning into a lens.
RRect barRRect(Rect rect, List<double> radii) {
  final double maxRadius = math.min(rect.width.abs(), rect.height.abs()) / 2;
  double clamp(int i) {
    final double r = i < radii.length ? radii[i] : 0;
    return r > maxRadius ? maxRadius : math.max(r, 0);
  }

  return RRect.fromRectAndCorners(
    rect,
    topLeft: Radius.circular(clamp(0)),
    topRight: Radius.circular(clamp(1)),
    bottomRight: Radius.circular(clamp(2)),
    bottomLeft: Radius.circular(clamp(3)),
  );
}

/* ── Curves ──────────────────────────────────────────────────────────────── */

/// The four `type=` values the page uses on `Area` and `Line`.
///
/// `monotone` resolves to `curveMonotoneX` on a horizontal chart, which is the
/// only layout any monotone series on the page runs in.
enum CurveType { linear, natural, monotone, step }

/// Builds the open curve through [points] — `d3-shape`'s `line()` with the
/// matching `curve*` factory.
///
/// The three interpolators are ported from
/// `victory-vendor/lib-vendor/d3-shape/src/curve/{natural,monotone,step}.js`.
/// Nothing is smoothed, resampled or approximated: `natural` solves the same
/// tridiagonal system, `monotone` runs the same Steffen slopes, and `step`
/// breaks at the same midpoint, so the cubic control points come out identical
/// to the `C` triples in the rendered `d`.
Path curvePath(List<Offset> points, CurveType type) {
  final Path path = Path();
  _emitCurve(path, points, type, moveToFirst: true, stepT: 0.5);
  return path;
}

/// The filled band between [top] and [base] — `d3-shape`'s `area()`.
///
/// d3 walks the top edge forward and the baseline backward through the SAME
/// curve object, and for `step` that reversal flips the interpolator's `t`
/// (`lineEnd` does `this._t = 1 - this._t`). That detail is why a stepped area
/// closes flush instead of leaving a sawtooth along the bottom, and it is
/// reproduced rather than approximated.
Path areaPath(List<Offset> top, List<Offset> base, CurveType type) {
  if (top.isEmpty) return Path();
  final Path path = Path();
  _emitCurve(path, top, type, moveToFirst: true, stepT: 0.5);
  final List<Offset> back = base.reversed.toList();
  _emitCurve(path, back, type, moveToFirst: false, stepT: 0.5);
  path.close();
  return path;
}

void _emitCurve(
  Path path,
  List<Offset> pts,
  CurveType type, {
  required bool moveToFirst,
  required double stepT,
}) {
  if (pts.isEmpty) return;
  void start(Offset p) {
    if (moveToFirst) {
      path.moveTo(p.dx, p.dy);
    } else {
      path.lineTo(p.dx, p.dy);
    }
  }

  switch (type) {
    case CurveType.linear:
      start(pts.first);
      for (int i = 1; i < pts.length; i++) {
        path.lineTo(pts[i].dx, pts[i].dy);
      }
    case CurveType.step:
      start(pts.first);
      for (int i = 1; i < pts.length; i++) {
        final Offset prev = pts[i - 1];
        final Offset cur = pts[i];
        final double x1 = prev.dx * (1 - stepT) + cur.dx * stepT;
        path.lineTo(x1, prev.dy);
        path.lineTo(x1, cur.dy);
      }
      path.lineTo(pts.last.dx, pts.last.dy);
    case CurveType.natural:
      _emitNatural(path, pts, start);
    case CurveType.monotone:
      _emitMonotoneX(path, pts, start);
  }
}

void _emitNatural(Path path, List<Offset> pts, void Function(Offset) start) {
  final int n = pts.length;
  start(pts.first);
  if (n == 1) return;
  if (n == 2) {
    path.lineTo(pts[1].dx, pts[1].dy);
    return;
  }
  final List<double> xs = <double>[for (final Offset p in pts) p.dx];
  final List<double> ys = <double>[for (final Offset p in pts) p.dy];
  final List<List<double>> px = _naturalControlPoints(xs);
  final List<List<double>> py = _naturalControlPoints(ys);
  for (int i0 = 0, i1 = 1; i1 < n; ++i0, ++i1) {
    path.cubicTo(px[0][i0], py[0][i0], px[1][i0], py[1][i0], xs[i1], ys[i1]);
  }
}

/// `natural.js`'s `controlPoints` — the Thomas-algorithm solve behind a natural
/// cubic spline. See https://www.particleincell.com/2012/bezier-splines/.
List<List<double>> _naturalControlPoints(List<double> x) {
  final int n = x.length - 1;
  final List<double> a = List<double>.filled(n, 0);
  final List<double> b = List<double>.filled(n, 0);
  final List<double> r = List<double>.filled(n, 0);
  a[0] = 0;
  b[0] = 2;
  r[0] = x[0] + 2 * x[1];
  for (int i = 1; i < n - 1; ++i) {
    a[i] = 1;
    b[i] = 4;
    r[i] = 4 * x[i] + 2 * x[i + 1];
  }
  a[n - 1] = 2;
  b[n - 1] = 7;
  r[n - 1] = 8 * x[n - 1] + x[n];
  for (int i = 1; i < n; ++i) {
    final double m = a[i] / b[i - 1];
    b[i] -= m;
    r[i] -= m * r[i - 1];
  }
  a[n - 1] = r[n - 1] / b[n - 1];
  for (int i = n - 2; i >= 0; --i) {
    a[i] = (r[i] - a[i + 1]) / b[i];
  }
  b[n - 1] = (x[n] + a[n - 1]) / 2;
  for (int i = 0; i < n - 1; ++i) {
    b[i] = 2 * x[i + 1] - a[i + 1];
  }
  return <List<double>>[a, b];
}

/// `monotone.js`'s `MonotoneX` — Steffen 1990 tangents, emitted as the cubic
/// Bézier equivalent of the Hermite segment.
void _emitMonotoneX(Path path, List<Offset> pts, void Function(Offset) start) {
  if (pts.isEmpty) return;
  double x0 = double.nan;
  double y0 = double.nan;
  double x1 = double.nan;
  double y1 = double.nan;
  double t0 = double.nan;
  int point = 0;

  double sign(double v) => v < 0 ? -1 : 1;

  double slope3(double x2, double y2) {
    final double h0 = x1 - x0;
    final double h1 = x2 - x1;
    final double s0 = (y1 - y0) / (h0 != 0 ? h0 : (h1 < 0 ? -0.0 : h0));
    final double s1 = (y2 - y1) / (h1 != 0 ? h1 : (h0 < 0 ? -0.0 : h1));
    final double p = (s0 * h1 + s1 * h0) / (h0 + h1);
    final double v =
        (sign(s0) + sign(s1)) *
        math.min(math.min(s0.abs(), s1.abs()), 0.5 * p.abs());
    return v.isNaN ? 0 : v;
  }

  double slope2(double t) {
    final double h = x1 - x0;
    return h != 0 ? (3 * (y1 - y0) / h - t) / 2 : t;
  }

  void emit(double ta, double tb) {
    final double dx = (x1 - x0) / 3;
    path.cubicTo(x0 + dx, y0 + dx * ta, x1 - dx, y1 - dx * tb, x1, y1);
  }

  for (final Offset p in pts) {
    final double x = p.dx;
    final double y = p.dy;
    if (x == x1 && y == y1) continue; // Coincident points are ignored.
    double t1 = double.nan;
    switch (point) {
      case 0:
        point = 1;
        start(p);
      case 1:
        point = 2;
      case 2:
        point = 3;
        t1 = slope3(x, y);
        emit(slope2(t1), t1);
      default:
        t1 = slope3(x, y);
        emit(t0, t1);
    }
    x0 = x1;
    x1 = x;
    y0 = y1;
    y1 = y;
    t0 = t1;
  }
  // `lineEnd`: the run-out segment.
  if (point == 2) {
    path.lineTo(x1, y1);
  } else if (point == 3) {
    emit(t0, slope2(t0));
  }
}

/* ── Polar ───────────────────────────────────────────────────────────────── */

/// `recharts/util/PolarUtils.js` — degrees, counter-clockwise from three
/// o'clock, negated on the way in because SVG's y grows downward.
///
/// Every polar chart on the page reads through this one function, including the
/// two `foreignObject` label chips (`RadialArcLabel`, `PieLabelListArcLabel`)
/// which do the conversion by hand in the reference and are pointed here
/// instead.
Offset polarToCartesian(double cx, double cy, double radius, double angle) {
  final double rad = -angle * math.pi / 180;
  return Offset(cx + math.cos(rad) * radius, cy + math.sin(rad) * radius);
}

/// The radius a polar chart fills — `getMaxRadius`.
///
/// Measured 98.4 on every 482 × 256 pie: `min(482 - 10, 256 - 10) / 2 = 123`,
/// times the 80% default.
double polarMaxRadius(double width, double height, {double inset = 10}) =>
    math.min((width - inset).abs(), (height - inset).abs()) / 2;

/// `recharts/shape/Sector.js` — `getSectorPath`, the corner-free case.
///
/// The 359.999 clamp is recharts' own: a full 360° sweep would put the arc's
/// start and end on the same point, where SVG (and Skia) draw nothing at all.
Path sectorPath({
  required double cx,
  required double cy,
  required double innerRadius,
  required double outerRadius,
  required double startAngle,
  required double endAngle,
}) {
  final double delta = _deltaAngle(startAngle, endAngle);
  final double tempEnd = startAngle + delta;
  final Path path = Path();
  final Offset outerStart = polarToCartesian(cx, cy, outerRadius, startAngle);
  path.moveTo(outerStart.dx, outerStart.dy);
  _arc(path, cx, cy, outerRadius, startAngle, tempEnd);
  if (innerRadius > 0) {
    final Offset innerEnd = polarToCartesian(cx, cy, innerRadius, tempEnd);
    path.lineTo(innerEnd.dx, innerEnd.dy);
    _arc(path, cx, cy, innerRadius, tempEnd, startAngle);
  } else {
    path.lineTo(cx, cy);
  }
  path.close();
  return path;
}

/// `getSectorWithCorner` — the rounded-arc case, used by `RadialText`,
/// `RadialShape` and `RadialStacked`.
///
/// Falls back to [sectorPath] when the sweep is too narrow to hold two corner
/// circles, which is recharts' own `outerArcAngle < 0` branch and is what keeps
/// a nearly-empty gauge from inverting itself.
Path sectorWithCornerPath({
  required double cx,
  required double cy,
  required double innerRadius,
  required double outerRadius,
  required double startAngle,
  required double endAngle,
  required double cornerRadius,
}) {
  if (cornerRadius <= 0 || (startAngle - endAngle).abs() >= 360) {
    return sectorPath(
      cx: cx,
      cy: cy,
      innerRadius: innerRadius,
      outerRadius: outerRadius,
      startAngle: startAngle,
      endAngle: endAngle,
    );
  }
  final double sign = endAngle - startAngle < 0 ? -1 : 1;
  final _Tangent so = _tangentCircle(
    cx,
    cy,
    outerRadius,
    startAngle,
    sign,
    false,
    cornerRadius,
  );
  final _Tangent eo = _tangentCircle(
    cx,
    cy,
    outerRadius,
    endAngle,
    -sign,
    false,
    cornerRadius,
  );
  final double outerArc = (startAngle - endAngle).abs() - so.theta - eo.theta;
  if (outerArc < 0) {
    return sectorPath(
      cx: cx,
      cy: cy,
      innerRadius: innerRadius,
      outerRadius: outerRadius,
      startAngle: startAngle,
      endAngle: endAngle,
    );
  }
  final Path path = Path();
  path.moveTo(so.lineTangency.dx, so.lineTangency.dy);
  _arcTo(path, so.circleTangency, cornerRadius, false, sign < 0);
  _arc(
    path,
    cx,
    cy,
    outerRadius,
    startAngle + sign * so.theta,
    endAngle - sign * eo.theta,
  );
  _arcTo(path, eo.lineTangency, cornerRadius, false, sign < 0);
  if (innerRadius > 0) {
    final _Tangent si = _tangentCircle(
      cx,
      cy,
      innerRadius,
      startAngle,
      sign,
      true,
      cornerRadius,
    );
    final _Tangent ei = _tangentCircle(
      cx,
      cy,
      innerRadius,
      endAngle,
      -sign,
      true,
      cornerRadius,
    );
    final double innerArc = (startAngle - endAngle).abs() - si.theta - ei.theta;
    if (innerArc < 0) {
      path.lineTo(cx, cy);
      path.close();
      return path;
    }
    path.lineTo(ei.lineTangency.dx, ei.lineTangency.dy);
    _arcTo(path, ei.circleTangency, cornerRadius, false, sign < 0);
    _arc(
      path,
      cx,
      cy,
      innerRadius,
      endAngle - sign * ei.theta,
      startAngle + sign * si.theta,
    );
    _arcTo(path, si.lineTangency, cornerRadius, false, sign < 0);
  } else {
    path.lineTo(cx, cy);
  }
  path.close();
  return path;
}

class _Tangent {
  const _Tangent(this.circleTangency, this.lineTangency, this.theta);
  final Offset circleTangency;
  final Offset lineTangency;
  final double theta;
}

_Tangent _tangentCircle(
  double cx,
  double cy,
  double radius,
  double angle,
  double sign,
  bool isExternal,
  double cornerRadius,
) {
  final double centerRadius = cornerRadius * (isExternal ? 1 : -1) + radius;
  final double theta = math.asin(cornerRadius / centerRadius) * 180 / math.pi;
  final double centerAngle = angle + sign * theta;
  final Offset circleTangency = polarToCartesian(cx, cy, radius, centerAngle);
  final Offset lineTangency = polarToCartesian(
    cx,
    cy,
    centerRadius * math.cos(theta * math.pi / 180),
    angle,
  );
  return _Tangent(circleTangency, lineTangency, theta);
}

double _deltaAngle(double start, double end) {
  final double sign = end - start < 0 ? -1 : 1;
  return sign * math.min((end - start).abs(), 359.999);
}

/// Sweeps [path] along the circle of [radius] from [from]° to [to]°.
void _arc(
  Path path,
  double cx,
  double cy,
  double radius,
  double from,
  double to,
) {
  // Chart degrees run counter-clockwise from three o'clock; Flutter's sweep
  // runs clockwise from three o'clock in screen space. Negating both is the
  // same statement `polarToCartesian` already makes.
  final double startRad = -from * math.pi / 180;
  final double sweepRad = -(to - from) * math.pi / 180;
  path.arcTo(
    Rect.fromCircle(center: Offset(cx, cy), radius: radius),
    startRad,
    sweepRad,
    false,
  );
}

/// An `A r,r,0,large,sweep,x,y` corner, as Flutter's own arc-to-point.
void _arcTo(
  Path path,
  Offset to,
  double radius,
  bool largeArc,
  bool clockwise,
) {
  path.arcToPoint(
    to,
    radius: Radius.circular(radius),
    largeArc: largeArc,
    // SVG's sweep flag is "positive angle direction" in a y-down space, which
    // is Flutter's `clockwise`.
    clockwise: clockwise,
  );
}

/// The closed polygon a `Radar` series or a polygon `PolarGrid` ring draws.
Path polarPolygonPath(List<Offset> points) {
  final Path path = Path();
  if (points.isEmpty) return path;
  path.moveTo(points.first.dx, points.first.dy);
  for (int i = 1; i < points.length; i++) {
    path.lineTo(points[i].dx, points[i].dy);
  }
  path.close();
  return path;
}
