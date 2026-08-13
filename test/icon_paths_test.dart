import 'dart:math' as math;
import 'dart:ui';

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter_test/flutter_test.dart';

/// Value-for-value transcript check of the embedded lucide glyphs, plus a unit
/// test of the SVG path-data reader that turns them into a [Path].
///
/// Source of truth: `design-system/node_modules/lucide-react/dist/esm/icons/`
/// `{menu,x,sun,monitor,moon,arrow-left,arrow-right,check}.mjs` — lucide-react
/// 1.28.0, ISC.
///
/// Imported through `src/` on purpose: the package barrel is owned elsewhere,
/// and these assertions are about the geometry layer, not the public surface.

/// Builds a path from one raw `d` string, the way [DsIconPaths.pathFor] does.
Path _pathOf(String d) {
  final Path path = Path();
  DsIconPathElement(d).addTo(path);
  return path;
}

List<PathMetric> _contours(Path path) => path.computeMetrics().toList();

double _length(Path path) => _contours(path)
    .fold<double>(0, (double sum, PathMetric m) => sum + m.length);

/// Where the path actually goes, as opposed to [Path.getBounds], which is
/// allowed to include Bézier control points that the curve never reaches.
///
/// Walks every contour by arc length. 20 000 samples over a ~59-unit path is a
/// step of 0.003 units, an order of magnitude finer than the tolerances below.
Rect _tightBounds(Path path, {int samples = 20000}) {
  double left = double.infinity;
  double top = double.infinity;
  double right = -double.infinity;
  double bottom = -double.infinity;
  for (final PathMetric metric in path.computeMetrics()) {
    for (int i = 0; i <= samples; i++) {
      final Tangent? point =
          metric.getTangentForOffset(metric.length * i / samples);
      if (point == null) continue;
      left = math.min(left, point.position.dx);
      top = math.min(top, point.position.dy);
      right = math.max(right, point.position.dx);
      bottom = math.max(bottom, point.position.dy);
    }
  }
  return Rect.fromLTRB(left, top, right, bottom);
}

/// The point half way along the first contour, by arc length.
Offset _midpoint(Path path) {
  final PathMetric metric = _contours(path).first;
  return metric.getTangentForOffset(metric.length / 2)!.position;
}

void main() {
  // ─── transcription ───────────────────────────────────────────────────────

  group('transcription of lucide-react 1.28.0 __iconNode', () {
    test('the viewBox is the 24×24 grid lucide authors on', () {
      expect(DsIconPaths.viewBox, 24);
    });

    test('every glyph is transcribed, element for element', () {
      // Element counts, per `__iconNode` in each .mjs file.
      const Map<DsIconGlyph, int> counts = <DsIconGlyph, int>{
        DsIconGlyph.menu: 3,
        DsIconGlyph.x: 2,
        DsIconGlyph.sun: 9,
        DsIconGlyph.monitor: 3,
        DsIconGlyph.moon: 1,
        DsIconGlyph.arrowLeft: 2,
        DsIconGlyph.arrowRight: 2,
        DsIconGlyph.check: 1,
      };
      expect(DsIconPaths.elements.keys, unorderedEquals(DsIconGlyph.values));
      for (final DsIconGlyph glyph in DsIconGlyph.values) {
        expect(DsIconPaths.elements[glyph], hasLength(counts[glyph]),
            reason: '${glyph.name}.mjs element count');
      }
    });

    test('path `d` strings are copied character for character', () {
      String d(DsIconGlyph glyph, int index) =>
          (DsIconPaths.elements[glyph]![index] as DsIconPathElement).d;

      // menu.mjs — absolute moveto + relative horizontal lineto.
      expect(d(DsIconGlyph.menu, 0), 'M4 5h16');
      expect(d(DsIconGlyph.menu, 1), 'M4 12h16');
      expect(d(DsIconGlyph.menu, 2), 'M4 19h16');
      // x.mjs — the two spellings lucide happens to use side by side.
      expect(d(DsIconGlyph.x, 0), 'M18 6 6 18');
      expect(d(DsIconGlyph.x, 1), 'm6 6 12 12');
      // check.mjs — implicit lineto then a relative one.
      expect(d(DsIconGlyph.check, 0), 'M20 6 9 17l-5-5');
      // sun.mjs — a ray whose second coordinate packs its sign.
      expect(d(DsIconGlyph.sun, 7), 'm6.34 17.66-1.41 1.41');
      // arrow-right.mjs / arrow-left.mjs.
      expect(d(DsIconGlyph.arrowRight, 0), 'M5 12h14');
      expect(d(DsIconGlyph.arrowRight, 1), 'm12 5 7 7-7 7');
      expect(d(DsIconGlyph.arrowLeft, 0), 'm12 19-7-7 7-7');
      expect(d(DsIconGlyph.arrowLeft, 1), 'M19 12H5');
      // moon.mjs — the one that carries arcs, leading-dot decimals and
      // no-space negatives all at once.
      expect(
        d(DsIconGlyph.moon, 0),
        'M20.985 12.486a9 9 0 1 1-9.473-9.472c.405-.022.617.46.402.803'
        'a6 6 0 0 0 8.268 8.268c.344-.215.825-.004.803.401',
      );
    });

    test('structured elements keep every lucide attribute', () {
      // sun.mjs: ["circle", { cx: 12, cy: 12, r: 4 }]
      final DsIconCircleElement circle =
          DsIconPaths.elements[DsIconGlyph.sun]!.first as DsIconCircleElement;
      expect(<double>[circle.cx, circle.cy, circle.r], <double>[12, 12, 4]);

      // monitor.mjs: ["rect", { width: 20, height: 14, x: 2, y: 3, rx: 2 }]
      final DsIconRectElement rect = DsIconPaths
          .elements[DsIconGlyph.monitor]!.first as DsIconRectElement;
      expect(
        <double>[rect.x, rect.y, rect.width, rect.height, rect.rx],
        <double>[2, 3, 20, 14, 2],
      );

      // monitor.mjs: ["line", { x1: 8, x2: 16, y1: 21, y2: 21 }] and
      //              ["line", { x1: 12, x2: 12, y1: 17, y2: 21 }]
      final DsIconLineElement foot =
          DsIconPaths.elements[DsIconGlyph.monitor]![1] as DsIconLineElement;
      expect(<double>[foot.x1, foot.y1, foot.x2, foot.y2],
          <double>[8, 21, 16, 21]);
      final DsIconLineElement neck =
          DsIconPaths.elements[DsIconGlyph.monitor]![2] as DsIconLineElement;
      expect(<double>[neck.x1, neck.y1, neck.x2, neck.y2],
          <double>[12, 17, 12, 21]);
    });
  });

  // ─── pathFor ─────────────────────────────────────────────────────────────

  group('DsIconPaths.pathFor', () {
    test('every glyph is drawn and stays on the 24×24 grid', () {
      for (final DsIconGlyph glyph in DsIconGlyph.values) {
        final Path path = DsIconPaths.pathFor(glyph);
        final Rect bounds = path.getBounds();
        expect(bounds.isEmpty, isFalse, reason: '${glyph.name} drew nothing');
        expect(_length(path), greaterThan(0),
            reason: '${glyph.name} has no stroke length');
        // A hair of tolerance: the arc glyph's bounds carry cubic control
        // points, and Skia stores bounds as float32.
        expect(bounds.left, greaterThanOrEqualTo(-0.01),
            reason: '${glyph.name} left');
        expect(bounds.top, greaterThanOrEqualTo(-0.01),
            reason: '${glyph.name} top');
        expect(bounds.right, lessThanOrEqualTo(DsIconPaths.viewBox + 0.01),
            reason: '${glyph.name} right');
        expect(bounds.bottom, lessThanOrEqualTo(DsIconPaths.viewBox + 0.01),
            reason: '${glyph.name} bottom');
      }
    });

    test('subpath counts match the element lists', () {
      // One contour per element: `circle`/`rect` add one closed contour each,
      // every `d` string above starts with exactly one moveto.
      expect(_contours(DsIconPaths.pathFor(DsIconGlyph.menu)), hasLength(3));
      expect(_contours(DsIconPaths.pathFor(DsIconGlyph.sun)), hasLength(9));
      expect(_contours(DsIconPaths.pathFor(DsIconGlyph.check)), hasLength(1));
      expect(
          _contours(DsIconPaths.pathFor(DsIconGlyph.arrowRight)), hasLength(2));
      expect(_contours(DsIconPaths.pathFor(DsIconGlyph.x)), hasLength(2));
      expect(_contours(DsIconPaths.pathFor(DsIconGlyph.monitor)), hasLength(3));
      expect(
          _contours(DsIconPaths.pathFor(DsIconGlyph.arrowLeft)), hasLength(2));
      expect(_contours(DsIconPaths.pathFor(DsIconGlyph.moon)), hasLength(1));
    });

    test('menu is three 16-unit rules', () {
      // `M4 5h16` / `M4 12h16` / `M4 19h16` — the relative `h` must land on
      // x = 20, not x = 16.
      for (final PathMetric rule
          in _contours(DsIconPaths.pathFor(DsIconGlyph.menu))) {
        expect(rule.length, closeTo(16, 0.01));
        expect(rule.isClosed, isFalse);
      }
      expect(DsIconPaths.pathFor(DsIconGlyph.menu).getBounds(),
          const Rect.fromLTRB(4, 5, 20, 19));
    });

    test('check is its two diagonals, absolute then relative', () {
      // `M20 6 9 17l-5-5`: an implicit absolute lineto (20,6)→(9,17) followed
      // by a relative one (9,17)→(4,12).
      final double expected =
          math.sqrt(11 * 11 + 11 * 11) + math.sqrt(5 * 5 + 5 * 5); // 22.627
      expect(_length(DsIconPaths.pathFor(DsIconGlyph.check)),
          closeTo(expected, 0.05));
      expect(DsIconPaths.pathFor(DsIconGlyph.check).getBounds(),
          const Rect.fromLTRB(4, 6, 20, 17));
    });

    test('returns a fresh Path every call', () {
      final Path first = DsIconPaths.pathFor(DsIconGlyph.check);
      final Path second = DsIconPaths.pathFor(DsIconGlyph.check);
      expect(identical(first, second), isFalse);
      // …and they are genuinely independent: mutating one must not move the
      // other. Paths are mutable, which is the whole reason for the rule.
      first.lineTo(0, 0);
      expect(first.getBounds(), isNot(second.getBounds()));
      expect(second.getBounds(), const Rect.fromLTRB(4, 6, 20, 17));
    });
  });

  // ─── the parser ──────────────────────────────────────────────────────────

  group('SVG path data — commands the glyphs do not use', () {
    test('H V h v move on one axis only', () {
      // (2,2) → (10,2) → (10,6) → (6,6) → (6,4): 8 + 4 + 4 + 2.
      final Path path = _pathOf('M2 2 H10 V6 h-4 v-2');
      expect(_length(path), closeTo(18, 0.001));
      expect(path.getBounds(), const Rect.fromLTRB(2, 2, 10, 6));
    });

    test('S mirrors the previous cubic control point', () {
      // Reflection of (10,10) through (10,0) is (10,-10).
      final Path shorthand = _pathOf('M0 0 C0 10 10 10 10 0 S20 -10 20 0');
      final Path written = _pathOf('M0 0 C0 10 10 10 10 0 C10 -10 20 -10 20 0');
      expect(shorthand.getBounds(), written.getBounds());
      expect(_length(shorthand), closeTo(_length(written), 1e-6));
      // The test has teeth: a control point that is *not* reflected differs.
      final Path wrong = _pathOf('M0 0 C0 10 10 10 10 0 C10 10 20 -10 20 0');
      expect(_length(wrong), isNot(closeTo(_length(written), 0.5)));
    });

    test('T mirrors the previous quadratic control point', () {
      // Reflection of (10,0) through (10,10) is (10,20).
      final Path shorthand = _pathOf('M0 0 Q10 0 10 10 T20 20');
      final Path written = _pathOf('M0 0 Q10 0 10 10 Q10 20 20 20');
      expect(shorthand.getBounds(), written.getBounds());
      expect(_length(shorthand), closeTo(_length(written), 1e-6));
      final Path wrong = _pathOf('M0 0 Q10 0 10 10 Q10 10 20 20');
      expect(_length(wrong), isNot(closeTo(_length(written), 0.5)));
    });

    test('Z closes the subpath — and nothing else does', () {
      final Path closed = _pathOf('M2 2 H10 V6 Z');
      expect(_contours(closed).single.isClosed, isTrue);
      // 8 + 4 + the closing diagonal back to (2,2).
      expect(_length(closed), closeTo(8 + 4 + math.sqrt(80), 0.001));

      // The stroke-only rule: without a `Z` the subpath stays open, which is
      // what every lucide glyph in this package relies on.
      final Path open = _pathOf('M2 2 H10 V6');
      expect(_contours(open).single.isClosed, isFalse);
      expect(_length(open), closeTo(12, 0.001));
      for (final DsIconGlyph glyph in <DsIconGlyph>[
        DsIconGlyph.menu,
        DsIconGlyph.x,
        DsIconGlyph.moon,
        DsIconGlyph.check,
        DsIconGlyph.arrowLeft,
        DsIconGlyph.arrowRight,
      ]) {
        for (final PathMetric contour
            in _contours(DsIconPaths.pathFor(glyph))) {
          expect(contour.isClosed, isFalse,
              reason: '${glyph.name} has no Z and must not be closed');
        }
      }
    });

    test('one synthetic d exercises H V Q T S Z together', () {
      final Path path =
          _pathOf('M2 2 H10 V6 Q14 6 14 10 T18 18 S22 14 22 10 L22 2 Z');
      final List<PathMetric> contours = _contours(path);
      expect(contours, hasLength(1));
      expect(contours.single.isClosed, isTrue);
      // Closed, so walking the full length returns to the moveto.
      final Offset end =
          contours.single.getTangentForOffset(contours.single.length)!.position;
      expect(end.dx, closeTo(2, 0.001));
      expect(end.dy, closeTo(2, 0.001));
      expect(path.getBounds(), const Rect.fromLTRB(2, 2, 22, 18));
    });
  });

  group('SVG path data — the number scanner', () {
    test('leading dots, packed signs and exponents all scan', () {
      // `.5.5` is two numbers, `1e1` is ten.
      final Path path = _pathOf('M.5.5L1e1 1e1');
      expect(path.getBounds(), const Rect.fromLTRB(0.5, 0.5, 10, 10));
      expect(_length(path), closeTo(math.sqrt(2 * 9.5 * 9.5), 0.001));

      // `-1.41` right up against the previous number (sun's rays).
      final Path ray = _pathOf('m6.34 17.66-1.41 1.41');
      expect(_length(ray), closeTo(math.sqrt(2 * 1.41 * 1.41), 0.001));
      expect(ray.getBounds().left, closeTo(4.93, 0.001));
    });

    test('a coordinate set may repeat without its command letter', () {
      // `M` degrades to `L` on repeat: (0,0) → (1,1) → (2,2).
      final Path path = _pathOf('M0 0 1 1 2 2');
      expect(_contours(path), hasLength(1));
      expect(_length(path), closeTo(2 * math.sqrt(2), 0.001));
      expect(path.getBounds(), const Rect.fromLTRB(0, 0, 2, 2));
    });

    test('malformed data throws rather than drawing something wrong', () {
      expect(() => _pathOf('M0 0 L'), throwsFormatException);
      expect(() => _pathOf('M0 0 A10 10 0 5 1 10 10'), throwsFormatException);
      expect(() => _pathOf('0 0'), throwsFormatException);
    });
  });

  // ─── arcs ────────────────────────────────────────────────────────────────

  group('elliptical arcs (SVG 1.1 F.6.5 / F.6.6)', () {
    test('the sweep flag chooses the centre', () {
      // Quarter circle (10,0) → (0,10), r = 10. sweep=1 runs the positive
      // angle direction about (0,0), so its midpoint is (10cos45°, 10sin45°).
      final Offset positive = _midpoint(_pathOf('M10 0A10 10 0 0 1 0 10'));
      expect(positive.dx, closeTo(10 / math.sqrt2, 0.01));
      expect(positive.dy, closeTo(10 / math.sqrt2, 0.01));
      // sweep=0 is the other centre, (10,10) — the same endpoints, the
      // opposite bulge: 10 − 10cos45°.
      final Offset negative = _midpoint(_pathOf('M10 0A10 10 0 0 0 0 10'));
      expect(negative.dx, closeTo(10 - 10 / math.sqrt2, 0.01));
      expect(negative.dy, closeTo(10 - 10 / math.sqrt2, 0.01));
    });

    test('the large-arc flag takes the long way round', () {
      // Same endpoints, largeArc=1 sweep=1: 270° about (10,10), midpoint at
      // 45° from that centre. Also proves the >90° split, since this needs
      // three cubic segments.
      final Path path = _pathOf('M10 0A10 10 0 1 1 0 10');
      expect(_midpoint(path).dx, closeTo(10 + 10 / math.sqrt2, 0.01));
      expect(_midpoint(path).dy, closeTo(10 + 10 / math.sqrt2, 0.01));
      expect(_tightBounds(path, samples: 4000),
          _rectCloseTo(const Rect.fromLTRB(0, 0, 20, 20), 0.01));
    });

    test('radii too small for the chord are scaled up (F.6.6)', () {
      // r = 1 cannot span a chord of 10, so both radii scale to exactly 5 and
      // the arc becomes a semicircle reaching y = −5.
      final Path path = _pathOf('M0 0A1 1 0 0 1 10 0');
      expect(_midpoint(path).dx, closeTo(5, 0.01));
      expect(_midpoint(path).dy, closeTo(-5, 0.01));
      expect(_tightBounds(path, samples: 4000),
          _rectCloseTo(const Rect.fromLTRB(0, -5, 10, 0), 0.01));
    });

    test('a zero radius degrades to a straight line (F.6.2)', () {
      final Path path = _pathOf('M0 0A0 0 0 0 1 10 0');
      expect(_length(path), closeTo(10, 0.001));
      expect(path.getBounds(), const Rect.fromLTRB(0, 0, 10, 0));
    });
  });

  group('moon — the glyph the arc maths is judged on', () {
    // `M20.985 12.486 a9 9 0 1 1 -9.473 -9.472 …`
    //
    // Solved by hand from the two endpoints and r = 9: the perpendicular
    // bisector of the chord puts the centre at (11.99788, 12.00107), and the
    // 263.8° sweep passes the 90° and 180° points of that circle but stops
    // 3.1° short of 270°. So the arc itself touches x = cx − 9 and y = cy + 9,
    // while its top and right edges are wherever the two cubic hooks end.
    const double cx = 11.99788;
    const double cy = 12.00107;
    const double r = 9;

    test('is a single open subpath', () {
      final List<PathMetric> contours =
          _contours(DsIconPaths.pathFor(DsIconGlyph.moon));
      expect(contours, hasLength(1));
      expect(contours.single.isClosed, isFalse);
    });

    test('the arc reaches the circle it was parameterised from', () {
      // MEASURED, not guessed: sampled at 20 000 points along the path, then
      // checked against the analytic circle above. Left and bottom are the
      // arc's own extremes; top and right belong to the cubic hooks and are
      // recorded from the same sampling run.
      final Rect tight = _tightBounds(DsIconPaths.pathFor(DsIconGlyph.moon));
      expect(tight.left, closeTo(cx - r, 0.005)); // 2.99788
      expect(tight.bottom, closeTo(cy + r, 0.005)); // 21.00107
      expect(tight.top, closeTo(3.0133, 0.005));
      expect(tight.right, closeTo(20.9857, 0.005));
    });

    test('its bounds are the measured ones', () {
      // MEASURED, not guessed: printed from this very path on Flutter 3.44.8
      // and pinned here. These are Path.getBounds(), which includes the cubic
      // control points of the arc approximation, so they sit a little outside
      // the sampled geometry above (left 2.9121 vs 2.9979, bottom 21.0863 vs
      // 21.0009). Both are asserted on purpose: the tight bounds prove the arc
      // maths, these prove the emitted control polygon has not drifted.
      final Rect bounds = DsIconPaths.pathFor(DsIconGlyph.moon).getBounds();
      expect(bounds.left, closeTo(2.9121, 0.001));
      expect(bounds.top, closeTo(2.9920, 0.001));
      expect(bounds.right, closeTo(21.0070, 0.001));
      expect(bounds.bottom, closeTo(21.0863, 0.001));
      expect(bounds.width, closeTo(18.0949, 0.001));
      expect(bounds.height, closeTo(18.0943, 0.001));
    });
  });
}

/// Matches a [Rect] edge by edge within [tolerance].
Matcher _rectCloseTo(Rect expected, double tolerance) => isA<Rect>()
    .having((Rect r) => r.left, 'left', closeTo(expected.left, tolerance))
    .having((Rect r) => r.top, 'top', closeTo(expected.top, tolerance))
    .having((Rect r) => r.right, 'right', closeTo(expected.right, tolerance))
    .having(
        (Rect r) => r.bottom, 'bottom', closeTo(expected.bottom, tolerance));
