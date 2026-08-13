/// Icon geometry — a transcript of lucide-react's own icon nodes.
///
/// Source of truth:
/// `design-system/node_modules/lucide-react/dist/esm/icons/{menu,x,sun,
/// monitor,moon,arrow-left,arrow-right,check}.mjs` — lucide-react **1.28.0**,
/// ISC, both confirmed in that package's `package.json`.
///
/// Each of those modules exports `__iconNode`: an ordered list of
/// `[tag, attributes]` SVG elements drawn on lucide's 24×24 grid and stroked
/// with `fill="none" stroke="currentColor" stroke-linecap="round"
/// stroke-linejoin="round"`. [DsIconPaths.elements] is that list transcribed
/// element for element and attribute for attribute — `d` strings copied
/// character for character, lowercase relative commands, packed signs and
/// leading-dot decimals included — with each element's lucide `key` kept as a
/// trailing comment so the transcription stays auditable against the package.
///
/// **Recorded decision: structure over stringification.** `line`, `circle` and
/// `rect` nodes are kept as their own element types rather than rewritten into
/// `d` strings. A rewrite would be a second, unverifiable transcription; these
/// map onto `moveTo`/`lineTo`, [Path.addOval] and [Path.addRRect] exactly.
///
/// **Recorded decision: geometry only.** No colour, no px size, no stroke
/// width lives here — `icon.dart` owns the size ladder, the tone map and the
/// web's stroke-width formula, and scales this 24-unit path to the rendered
/// box. That is also why this file is not a token file: it states no design
/// value, only the shape of a third-party glyph.
library;

import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// The eight glyphs the phase-1 surfaces use.
///
/// Named after their lucide file names (`arrow-left` → [arrowLeft]). Per
/// `docs/superpowers/research/assets-map.md` §3: [menu] and [x] for the mobile
/// nav sheet, [sun]/[monitor]/[moon] for the theme toggle, [arrowLeft] and
/// [arrowRight] for the foot nav and index cards, [check] (with [x]) for the
/// do/don't lists.
enum DsIconGlyph { menu, x, sun, monitor, moon, arrowLeft, arrowRight, check }

/// One SVG element from a lucide `__iconNode` list.
///
/// Sealed: lucide only ever emits `path`, `line`, `circle`, `rect`, `ellipse`
/// and `polyline` nodes, and these four cover every glyph this package
/// embeds. A new node type is a new subclass here, not a special case at the
/// call site.
@immutable
sealed class DsIconElement {
  const DsIconElement();

  /// Appends this element to [path] as its own subpath, in lucide's 24-unit
  /// coordinate space.
  void addTo(Path path);
}

/// `["path", { d: … }]` — the SVG path data, verbatim.
///
/// The string is parsed on every [addTo] rather than pre-baked into a [Path]:
/// a const element cannot hold a mutable [Path], and handing out a shared one
/// would let a caller mutate every future icon.
class DsIconPathElement extends DsIconElement {
  const DsIconPathElement(this.d);

  /// The `d` attribute, character for character as lucide ships it.
  final String d;

  @override
  void addTo(Path path) => _SvgPathParser(d).run(path);
}

/// `["line", { x1, y1, x2, y2 }]` — one straight stroke.
///
/// Constructor order is `(x1, y1, x2, y2)`, i.e. point-then-point; lucide
/// writes the attributes `x1, x2, y1, y2`, so the transcription below reorders
/// them deliberately.
class DsIconLineElement extends DsIconElement {
  const DsIconLineElement(this.x1, this.y1, this.x2, this.y2);

  /// `x1` — start x.
  final double x1;

  /// `y1` — start y.
  final double y1;

  /// `x2` — end x.
  final double x2;

  /// `y2` — end y.
  final double y2;

  @override
  void addTo(Path path) {
    path.moveTo(x1, y1);
    path.lineTo(x2, y2);
  }
}

/// `["circle", { cx, cy, r }]` — a closed circular subpath.
class DsIconCircleElement extends DsIconElement {
  const DsIconCircleElement(this.cx, this.cy, this.r);

  /// `cx` — centre x.
  final double cx;

  /// `cy` — centre y.
  final double cy;

  /// `r` — radius.
  final double r;

  @override
  void addTo(Path path) =>
      path.addOval(Rect.fromCircle(center: Offset(cx, cy), radius: r));
}

/// `["rect", { x, y, width, height, rx }]` — a closed rounded-rect subpath.
///
/// lucide never sets `ry`, so SVG's "`ry` defaults to `rx`" rule applies and
/// the corner radius is uniform. Constructor order is `(x, y, width, height,
/// rx)`; lucide writes `width, height, x, y, rx`.
class DsIconRectElement extends DsIconElement {
  const DsIconRectElement(this.x, this.y, this.width, this.height, this.rx);

  /// `x` — left edge.
  final double x;

  /// `y` — top edge.
  final double y;

  /// `width`.
  final double width;

  /// `height`.
  final double height;

  /// `rx` — corner radius, used for both axes.
  final double rx;

  @override
  void addTo(Path path) => path.addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, width, height),
          Radius.circular(rx),
        ),
      );
}

/// The embedded lucide glyphs.
class DsIconPaths {
  const DsIconPaths._();

  /// The viewBox lucide authors on: `viewBox="0 0 24 24"`, so 24×24.
  ///
  /// Every number in [elements] is in these units. Callers scale by
  /// `renderedPx / viewBox` — never by re-authoring the geometry.
  static const double viewBox = 24;

  /// Verbatim `__iconNode` per glyph, in file order.
  ///
  /// Order matters twice: it is the paint order, and it is what makes this a
  /// diffable transcript of the eight `.mjs` files.
  static const Map<DsIconGlyph, List<DsIconElement>> elements =
      <DsIconGlyph, List<DsIconElement>>{
    // `menu.mjs` — three 16-unit rules at y = 5 / 12 / 19.
    DsIconGlyph.menu: <DsIconElement>[
      DsIconPathElement('M4 5h16'), // key: 1tepv9
      DsIconPathElement('M4 12h16'), // key: 1lakjw
      DsIconPathElement('M4 19h16'), // key: 1djgab
    ],

    // `x.mjs` — two diagonals. The first is absolute with an implicit
    // `lineto`, the second is the relative spelling of the same idea; both are
    // kept exactly as authored.
    DsIconGlyph.x: <DsIconElement>[
      DsIconPathElement('M18 6 6 18'), // key: 1bl5f8
      DsIconPathElement('m6 6 12 12'), // key: d8bk6v
    ],

    // `sun.mjs` — a circle plus eight rays; nine subpaths in total.
    DsIconGlyph.sun: <DsIconElement>[
      DsIconCircleElement(12, 12, 4), // key: 4exip2
      DsIconPathElement('M12 2v2'), // key: tus03m
      DsIconPathElement('M12 20v2'), // key: 1lh1kg
      DsIconPathElement('m4.93 4.93 1.41 1.41'), // key: 149t6j
      DsIconPathElement('m17.66 17.66 1.41 1.41'), // key: ptbguv
      DsIconPathElement('M2 12h2'), // key: 1t8f8n
      DsIconPathElement('M20 12h2'), // key: 1q8mjw
      DsIconPathElement('m6.34 17.66-1.41 1.41'), // key: 1m8zz5
      DsIconPathElement('m19.07 4.93-1.41 1.41'), // key: 1shlcs
    ],

    // `monitor.mjs` — screen, stand foot, stand neck.
    DsIconGlyph.monitor: <DsIconElement>[
      // width: 20, height: 14, x: 2, y: 3, rx: 2
      DsIconRectElement(2, 3, 20, 14, 2), // key: 48i651
      // x1: 8, x2: 16, y1: 21, y2: 21
      DsIconLineElement(8, 21, 16, 21), // key: 1svkeh
      // x1: 12, x2: 12, y1: 17, y2: 21
      DsIconLineElement(12, 17, 12, 21), // key: vw1qmm
    ],

    // `moon.mjs` — one subpath: a 9-unit large arc, a cubic hook, a 6-unit arc
    // back and a second hook. The only glyph in this set that uses `A`/`a`, and
    // therefore the only one that exercises the arc conversion.
    DsIconGlyph.moon: <DsIconElement>[
      DsIconPathElement(
          'M20.985 12.486a9 9 0 1 1-9.473-9.472c.405-.022.617.46.402.803a6 6 0 0 0 8.268 8.268c.344-.215.825-.004.803.401'), // key: kfwtm
    ],

    // `arrow-left.mjs` — head first, then the shaft.
    DsIconGlyph.arrowLeft: <DsIconElement>[
      DsIconPathElement('m12 19-7-7 7-7'), // key: 1l729n
      DsIconPathElement('M19 12H5'), // key: x3x0zl
    ],

    // `arrow-right.mjs` — shaft first, then the head. Mirrors arrow-left
    // geometrically but not in element order — kept as lucide ships it.
    DsIconGlyph.arrowRight: <DsIconElement>[
      DsIconPathElement('M5 12h14'), // key: 1ays0h
      DsIconPathElement('m12 5 7 7-7 7'), // key: xquz4c
    ],

    // `check.mjs` — one stroke: the long fall, then the relative short rise.
    DsIconGlyph.check: <DsIconElement>[
      DsIconPathElement('M20 6 9 17l-5-5'), // key: 1gmf2c
    ],
  };

  /// The glyph as one [Path] in 24-unit coordinates — the caller scales.
  ///
  /// A **fresh** path every call: [Path] is mutable, and a shared instance
  /// would let one painter's `transform`/`addPath` corrupt every other icon.
  static Path pathFor(DsIconGlyph glyph) {
    final Path path = Path();
    for (final DsIconElement element in elements[glyph]!) {
      element.addTo(path);
    }
    return path;
  }
}

// ─── SVG path data ──────────────────────────────────────────────────────────

/// A single-pass reader for one SVG `d` string.
///
/// Implements the whole grammar — `M m L l H h V v C c S s Q q T t A a Z z` —
/// even though the eight glyphs above only reach for `M/m`, `L/l`, `C/c` and
/// `A/a`. The parser is the reusable half of this file: later batches embed
/// more lucide glyphs, and a partial parser would fail on them silently rather
/// than loudly.
///
/// Two SVG rules make the scanner less obvious than it looks, and both appear
/// in the data above:
///
///  * **separators are optional.** `-1.41 1.41` and `1 1-9.473` pack a sign
///    straight against the previous number, and `.405-.022` packs two
///    leading-dot decimals. A number therefore ends where the next one can
///    legally begin, not at whitespace.
///  * **a command letter is sticky.** One letter may be followed by many
///    argument sets (`m12 5 7 7-7 7` is a moveto and two linetos), and a
///    repeated `M`/`m` degrades to `L`/`l` — the *implicit lineto* rule.
///
/// Deliberate omission: this reader raises on malformed data instead of
/// recovering the way a browser does. The input is a const string checked into
/// the repo, so a throw is a build-time transcription bug, not a runtime risk.
class _SvgPathParser {
  _SvgPathParser(this._d);

  final String _d;
  int _i = 0;

  /// The current point. A `d` string starts at the origin: each lucide element
  /// is its own `<path>`, so a leading relative `m6 6` means (6, 6).
  Offset _current = Offset.zero;

  /// Where the current subpath began — the target of `Z`/`z`.
  Offset _subpathStart = Offset.zero;

  /// Second control point of the previous `C c S s`, for `S`/`s` to reflect.
  /// Null after any other command, which is the spec's "assume the first
  /// control point is coincident with the current point".
  Offset? _cubicControl;

  /// Control point of the previous `Q q T t`, for `T`/`t` to reflect.
  Offset? _quadControl;

  static const int _zero = 0x30; // '0'
  static const int _nine = 0x39; // '9'

  static bool _isDigit(int code) => code >= _zero && code <= _nine;

  static bool _isCommand(String c) {
    final int code = c.codeUnitAt(0);
    return (code >= 0x41 && code <= 0x5A) || (code >= 0x61 && code <= 0x7A);
  }

  /// Whitespace and commas, per the `wsp`/`comma-wsp` productions.
  static bool _isSeparator(String c) =>
      c == ' ' ||
      c == ',' ||
      c == '\t' ||
      c == '\n' ||
      c == '\r' ||
      c == '\f';

  void _skip() {
    while (_i < _d.length && _isSeparator(_d[_i])) {
      _i++;
    }
  }

  /// Reads one number: optional sign, integer part, fraction, exponent — any
  /// part of which may be absent, so `.5`, `-.5`, `5.`, `5e-3` all scan.
  double _number() {
    _skip();
    final int start = _i;
    if (_i < _d.length && (_d[_i] == '+' || _d[_i] == '-')) {
      _i++;
    }
    while (_i < _d.length && _isDigit(_d.codeUnitAt(_i))) {
      _i++;
    }
    if (_i < _d.length && _d[_i] == '.') {
      _i++;
      while (_i < _d.length && _isDigit(_d.codeUnitAt(_i))) {
        _i++;
      }
    }
    if (_i < _d.length && (_d[_i] == 'e' || _d[_i] == 'E')) {
      // An `e` only belongs to this number if a (signed) digit follows;
      // otherwise it is the next command letter and must be given back.
      final int mark = _i;
      _i++;
      if (_i < _d.length && (_d[_i] == '+' || _d[_i] == '-')) {
        _i++;
      }
      if (_i < _d.length && _isDigit(_d.codeUnitAt(_i))) {
        while (_i < _d.length && _isDigit(_d.codeUnitAt(_i))) {
          _i++;
        }
      } else {
        _i = mark;
      }
    }
    if (_i == start) {
      throw FormatException('expected a number', _d, _i);
    }
    final double? value = double.tryParse(_d.substring(start, _i));
    if (value == null) {
      throw FormatException('malformed number', _d, start);
    }
    return value;
  }

  /// Reads an arc flag: exactly **one** character, `0` or `1`.
  ///
  /// Not a number — the grammar lets `1 1-9.473` and even `11-9.473` pack two
  /// flags together, so scanning a flag as a number would swallow the second.
  bool _flag() {
    _skip();
    if (_i >= _d.length || (_d[_i] != '0' && _d[_i] != '1')) {
      throw FormatException('expected an arc flag (0 or 1)', _d, _i);
    }
    return _d[_i++] == '1';
  }

  /// Two numbers as a point.
  Offset _point() => Offset(_number(), _number());

  /// The command an unlettered argument set repeats: `M`/`m` degrade to
  /// `L`/`l`, everything else repeats itself.
  static String _implicitRepeat(String command) => switch (command) {
        'M' => 'L',
        'm' => 'l',
        _ => command,
      };

  void run(Path path) {
    _skip();
    while (_i < _d.length) {
      final String letter = _d[_i];
      if (!_isCommand(letter)) {
        throw FormatException('expected a command letter', _d, _i);
      }
      _i++;
      if (letter == 'Z' || letter == 'z') {
        path.close();
        _current = _subpathStart;
        _cubicControl = null;
        _quadControl = null;
        _skip();
        continue;
      }
      String command = letter;
      do {
        _execute(path, command);
        _skip();
        command = _implicitRepeat(command);
      } while (_i < _d.length && !_isCommand(_d[_i]));
    }
  }

  void _execute(Path path, String command) {
    switch (command) {
      case 'M':
        _moveTo(path, _point());
      case 'm':
        _moveTo(path, _current + _point());

      case 'L':
        _lineTo(path, _point());
      case 'l':
        _lineTo(path, _current + _point());

      case 'H':
        _lineTo(path, Offset(_number(), _current.dy));
      case 'h':
        _lineTo(path, Offset(_current.dx + _number(), _current.dy));
      case 'V':
        _lineTo(path, Offset(_current.dx, _number()));
      case 'v':
        _lineTo(path, Offset(_current.dx, _current.dy + _number()));

      case 'C':
        _cubicTo(path, _point(), _point(), _point());
      case 'c':
        final Offset origin = _current;
        _cubicTo(
          path,
          origin + _point(),
          origin + _point(),
          origin + _point(),
        );
      case 'S':
        _cubicTo(path, _reflectedCubic, _point(), _point());
      case 's':
        final Offset origin = _current;
        final Offset control1 = _reflectedCubic;
        _cubicTo(path, control1, origin + _point(), origin + _point());

      case 'Q':
        _quadTo(path, _point(), _point());
      case 'q':
        final Offset origin = _current;
        _quadTo(path, origin + _point(), origin + _point());
      case 'T':
        _quadTo(path, _reflectedQuad, _point());
      case 't':
        final Offset origin = _current;
        _quadTo(path, _reflectedQuad, origin + _point());

      case 'A':
        _arc(path, absolute: true);
      case 'a':
        _arc(path, absolute: false);

      default:
        throw FormatException('unknown command "$command"', _d, _i);
    }
  }

  /// The reflection of the previous cubic's second control point through the
  /// current point — or the current point itself when the previous command was
  /// not a cubic (SVG 1.1 §8.3.6).
  Offset get _reflectedCubic =>
      _cubicControl == null ? _current : _current * 2 - _cubicControl!;

  /// Same rule for quadratics (§8.3.7).
  Offset get _reflectedQuad =>
      _quadControl == null ? _current : _current * 2 - _quadControl!;

  void _moveTo(Path path, Offset to) {
    path.moveTo(to.dx, to.dy);
    _current = to;
    _subpathStart = to;
    _cubicControl = null;
    _quadControl = null;
  }

  void _lineTo(Path path, Offset to) {
    path.lineTo(to.dx, to.dy);
    _current = to;
    _cubicControl = null;
    _quadControl = null;
  }

  void _cubicTo(Path path, Offset control1, Offset control2, Offset to) {
    path.cubicTo(control1.dx, control1.dy, control2.dx, control2.dy, to.dx,
        to.dy);
    _current = to;
    _cubicControl = control2;
    _quadControl = null;
  }

  void _quadTo(Path path, Offset control, Offset to) {
    path.quadraticBezierTo(control.dx, control.dy, to.dx, to.dy);
    _current = to;
    _cubicControl = null;
    _quadControl = control;
  }

  void _arc(Path path, {required bool absolute}) {
    final double rx = _number();
    final double ry = _number();
    final double rotation = _number();
    final bool largeArc = _flag();
    final bool sweep = _flag();
    final Offset raw = _point();
    _arcTo(
      path,
      rx: rx,
      ry: ry,
      rotationDegrees: rotation,
      largeArc: largeArc,
      sweep: sweep,
      end: absolute ? raw : _current + raw,
    );
    _cubicControl = null;
    _quadControl = null;
  }

  /// Emits an SVG elliptical arc as cubic segments.
  ///
  /// Endpoint→centre parameterisation per SVG 1.1 appendix **F.6.5**, with the
  /// out-of-range radii correction of **F.6.6** applied before the centre is
  /// solved. The out-of-range checks of F.6.2 come first: a zero-length arc is
  /// dropped entirely, and a zero radius degrades to a straight line.
  ///
  /// The sweep is then cut into equal segments of **at most 90°** and each is
  /// approximated by one cubic whose control points sit `4/3·tan(θ/4)` of the
  /// tangent out from the endpoints — the standard construction, exact at the
  /// two ends and within ~2.7e-4·r in the middle at 90°.
  ///
  /// The final segment lands on the caller's `end` verbatim rather than on the
  /// re-derived point, so accumulated float error can never leave a hairline
  /// gap where a subsequent command continues the subpath.
  void _arcTo(
    Path path, {
    required double rx,
    required double ry,
    required double rotationDegrees,
    required bool largeArc,
    required bool sweep,
    required Offset end,
  }) {
    final Offset start = _current;
    if (start == end) {
      return; // F.6.2: coincident endpoints — the arc is omitted.
    }
    if (rx == 0 || ry == 0) {
      _lineTo(path, end); // F.6.2: a zero radius is a straight line.
      return;
    }
    rx = rx.abs();
    ry = ry.abs();

    final double phi = rotationDegrees * math.pi / 180;
    final double cosPhi = math.cos(phi);
    final double sinPhi = math.sin(phi);

    // F.6.5 step 1 — the endpoint midpoint, rotated into the ellipse's frame.
    final double halfDx = (start.dx - end.dx) / 2;
    final double halfDy = (start.dy - end.dy) / 2;
    final double x1p = cosPhi * halfDx + sinPhi * halfDy;
    final double y1p = -sinPhi * halfDx + cosPhi * halfDy;

    // F.6.6 — radii too small to span the chord are scaled up until they fit.
    final double lambda = (x1p * x1p) / (rx * rx) + (y1p * y1p) / (ry * ry);
    if (lambda > 1) {
      final double scale = math.sqrt(lambda);
      rx *= scale;
      ry *= scale;
    }

    // F.6.5 step 2 — the centre, still in the ellipse's frame.
    final double rx2 = rx * rx;
    final double ry2 = ry * ry;
    final double x1p2 = x1p * x1p;
    final double y1p2 = y1p * y1p;
    final double denominator = rx2 * y1p2 + ry2 * x1p2;
    double radicand =
        denominator == 0 ? 0 : (rx2 * ry2 - denominator) / denominator;
    if (radicand < 0) {
      radicand = 0; // F.6.6 leaves this at exactly 0; float error can dip below.
    }
    final double coefficient =
        (largeArc == sweep ? -1 : 1) * math.sqrt(radicand);
    final double cxp = coefficient * rx * y1p / ry;
    final double cyp = -coefficient * ry * x1p / rx;

    // F.6.5 step 3 — rotate the centre back into user space.
    final double cx = cosPhi * cxp - sinPhi * cyp + (start.dx + end.dx) / 2;
    final double cy = sinPhi * cxp + cosPhi * cyp + (start.dy + end.dy) / 2;

    // F.6.5 step 4 — start angle and sweep, as angles on the unit circle the
    // ellipse maps from.
    final double ux = (x1p - cxp) / rx;
    final double uy = (y1p - cyp) / ry;
    final double vx = (-x1p - cxp) / rx;
    final double vy = (-y1p - cyp) / ry;
    final double theta1 = math.atan2(uy, ux);
    double delta = math.atan2(ux * vy - uy * vx, ux * vx + uy * vy);
    if (!sweep && delta > 0) {
      delta -= 2 * math.pi;
    } else if (sweep && delta < 0) {
      delta += 2 * math.pi;
    }

    final int segments = math.max(1, (delta.abs() / (math.pi / 2)).ceil());
    final double step = delta / segments;
    final double alpha = 4 / 3 * math.tan(step / 4);

    Offset pointAt(double theta) {
      final double cosT = math.cos(theta);
      final double sinT = math.sin(theta);
      return Offset(
        cx + rx * cosT * cosPhi - ry * sinT * sinPhi,
        cy + rx * cosT * sinPhi + ry * sinT * cosPhi,
      );
    }

    Offset tangentAt(double theta) {
      final double cosT = math.cos(theta);
      final double sinT = math.sin(theta);
      return Offset(
        -rx * sinT * cosPhi - ry * cosT * sinPhi,
        -rx * sinT * sinPhi + ry * cosT * cosPhi,
      );
    }

    for (int segment = 0; segment < segments; segment++) {
      final double thetaA = theta1 + step * segment;
      final double thetaB = thetaA + step;
      final Offset pointA = pointAt(thetaA);
      final bool last = segment == segments - 1;
      final Offset pointB = last ? end : pointAt(thetaB);
      final Offset control1 = pointA + tangentAt(thetaA) * alpha;
      final Offset control2 = pointAt(thetaB) - tangentAt(thetaB) * alpha;
      path.cubicTo(
        control1.dx,
        control1.dy,
        control2.dx,
        control2.dy,
        pointB.dx,
        pointB.dy,
      );
    }
    _current = end;
  }
}
