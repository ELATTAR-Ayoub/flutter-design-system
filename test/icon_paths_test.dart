import 'dart:math' as math;
import 'dart:ui';

import 'package:elattar_design_system/src/components/icon.dart';
import 'package:elattar_design_system/src/components/icon_paths.dart';
import 'package:flutter_test/flutter_test.dart';

/// Value-for-value transcript check of the embedded lucide glyphs, plus a unit
/// test of the SVG path-data reader that turns them into a [Path].
///
/// Source of truth: `design-system/node_modules/lucide-react/dist/esm/icons/` —
/// lucide-react 1.28.0, ISC. One module per glyph; [_transcript] below names
/// every element of every one of them, independently of the comments in
/// `icon_paths.dart`, so the two have to agree.
///
/// Imported through `src/` on purpose: the package barrel is owned elsewhere,
/// and these assertions are about the geometry layer, not the public surface.

/// Builds a path from one raw `d` string, the way [DsIconPaths.pathFor] does.
Path _pathOf(String d) {
  final Path path = Path();
  DsIconPathElement(d).addTo(path);
  return path;
}

/// A double the way lucide writes it: `12`, not `12.0`; `0.5` for its `.5`.
String _n(double v) =>
    v == v.roundToDouble() ? v.toInt().toString() : v.toString();

/// One element rendered back into `tag attr attr …` form, so a whole glyph can
/// be asserted against one literal list in [_transcript].
///
/// Every attribute lucide writes appears here — including `fill` and `ry`,
/// the two the element model only learned this batch — so an element that
/// silently loses one fails rather than passing on the attributes that remain.
String _signature(DsIconElement element) => switch (element) {
      DsIconPathElement(:final String d) => 'path $d',
      DsIconLineElement(
        :final double x1,
        :final double y1,
        :final double x2,
        :final double y2
      ) =>
        'line ${_n(x1)} ${_n(y1)} ${_n(x2)} ${_n(y2)}',
      DsIconCircleElement(
        :final double cx,
        :final double cy,
        :final double r,
        :final bool filled
      ) =>
        'circle ${_n(cx)} ${_n(cy)} ${_n(r)}${filled ? ' fill' : ''}',
      DsIconRectElement(
        :final double x,
        :final double y,
        :final double width,
        :final double height,
        :final double rx,
        :final double? ry
      ) =>
        'rect ${_n(x)} ${_n(y)} ${_n(width)} ${_n(height)} ${_n(rx)}'
            '${ry == null ? '' : ' ry ${_n(ry)}'}',
      DsIconPolylineElement(:final List<Offset> points) => 'polyline '
          '${points.map((Offset p) => '${_n(p.dx)} ${_n(p.dy)}').join(' ')}',
    };

/// How many contours a glyph's [Path] must have: one per `M`/`m` in each `d`,
/// one per `circle`/`rect`/`line`/`polyline`.
int _expectedContours(DsIconGlyph glyph) => DsIconPaths.elements[glyph]!
    .fold<int>(0, (int n, DsIconElement e) => n + switch (e) {
          DsIconPathElement(:final String d) =>
            RegExp('[Mm]').allMatches(d).length,
          _ => 1,
        });

/// How many of them must come out **closed**: one per `z`/`Z`, plus every
/// `circle` and `rect`, which are closed subpaths by construction. `line` and
/// `polyline` are always open — closing a polyline is what `polygon` means,
/// and lucide emits none.
int _expectedClosedContours(DsIconGlyph glyph) => DsIconPaths.elements[glyph]!
    .fold<int>(0, (int n, DsIconElement e) => n + switch (e) {
          DsIconPathElement(:final String d) =>
            RegExp('[zZ]').allMatches(d).length,
          DsIconCircleElement() || DsIconRectElement() => 1,
          DsIconLineElement() || DsIconPolylineElement() => 0,
        });

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
  // ─── printed keys ────────────────────────────────────────────────────────

  group('the keys icon.tsx prints', () {
    test('DsIconSize.label is the ICON_SIZES key, not the Dart member name',
        () {
      expect(
        DsIconSize.values.map((DsIconSize s) => s.label).toList(),
        <String>['xs', 'sm', 'md', 'lg', 'xl', '2xl', '3xl'],
      );
      // The three that differ from `.name` are the reason the mapping exists.
      expect(DsIconSize.xl2.name, 'xl2');
      expect(DsIconSize.xl2.label, '2xl');
      expect(DsIconSize.xl3.name, 'xl3');
      expect(DsIconSize.xl3.label, '3xl');
      // …and the other five must NOT have been renamed on the way past.
      for (final DsIconSize size in <DsIconSize>[
        DsIconSize.xs,
        DsIconSize.sm,
        DsIconSize.md,
        DsIconSize.lg,
        DsIconSize.xl,
      ]) {
        expect(size.label, size.name);
      }
      // Every rung on the ladder is labelled and every label is distinct.
      expect(DsIconSize.values.map((DsIconSize s) => s.label).toSet(),
          hasLength(7));
    });

    test('DsIconTone.label is the ICON_TONES key, not the Dart member name',
        () {
      // Render order is `Object.keys(ICON_TONES)` — icon.tsx's order, which is
      // this enum's declaration order (icons-map.md §4).
      expect(
        DsIconTone.values.map((DsIconTone t) => t.label).toList(),
        <String>[
          'default',
          'muted',
          'subtle',
          'action',
          'value',
          'success',
          'warning',
          'info',
          'error',
          'inherit',
        ],
      );
      // `default` is a Dart reserved word; `normal` is the only rename.
      expect(DsIconTone.normal.name, 'normal');
      expect(DsIconTone.normal.label, 'default');
      for (final DsIconTone tone
          in DsIconTone.values.where((DsIconTone t) => t != DsIconTone.normal)) {
        expect(tone.label, tone.name);
      }
      expect(DsIconTone.values.map((DsIconTone t) => t.label).toSet(),
          hasLength(10));
      // muted and subtle are two labels for one colour — the page ships both
      // swatches on purpose (icons-map.md §4, ruling I-Q6). The labels differ
      // even though the tokens do not.
      expect(DsIconTone.muted.label, isNot(DsIconTone.subtle.label));
    });
  });

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
        DsIconGlyph.package: 4,
        DsIconGlyph.radio: 5,
        DsIconGlyph.layers: 3,
        DsIconGlyph.gift: 4,
        DsIconGlyph.trophy: 6,
        DsIconGlyph.wallet: 2,
        DsIconGlyph.user: 2,
        DsIconGlyph.search: 2,
        DsIconGlyph.bell: 2,
        DsIconGlyph.settings: 2,
        DsIconGlyph.logOut: 3,
        DsIconGlyph.layoutGrid: 4,
        DsIconGlyph.rows3: 3,
        DsIconGlyph.chevronDown: 1,
        DsIconGlyph.chevronUp: 1,
        DsIconGlyph.chevronLeft: 1,
        DsIconGlyph.chevronRight: 1,
        DsIconGlyph.ellipsis: 3,
        DsIconGlyph.externalLink: 3,
        DsIconGlyph.packageOpen: 4,
        DsIconGlyph.shoppingCart: 3,
        DsIconGlyph.heart: 1,
        DsIconGlyph.eye: 2,
        DsIconGlyph.eyeOff: 4,
        DsIconGlyph.share2: 5,
        DsIconGlyph.copy: 2,
        DsIconGlyph.filter: 1,
        DsIconGlyph.slidersHorizontal: 9,
        DsIconGlyph.plus: 2,
        DsIconGlyph.minus: 1,
        DsIconGlyph.refreshCw: 4,
        DsIconGlyph.download: 3,
        DsIconGlyph.upload: 3,
        DsIconGlyph.truck: 5,
        DsIconGlyph.trash2: 5,
        DsIconGlyph.ban: 2,
        DsIconGlyph.sparkles: 4,
        DsIconGlyph.crown: 2,
        DsIconGlyph.flame: 1,
        DsIconGlyph.zap: 1,
        DsIconGlyph.star: 1,
        DsIconGlyph.tag: 2,
        DsIconGlyph.percent: 3,
        DsIconGlyph.medal: 6,
        DsIconGlyph.activity: 1,
        DsIconGlyph.trendingUp: 2,
        DsIconGlyph.trendingDown: 2,
        DsIconGlyph.circleDollarSign: 3,
        DsIconGlyph.creditCard: 2,
        DsIconGlyph.arrowDownLeft: 2,
        DsIconGlyph.arrowUpRight: 2,
        DsIconGlyph.hourglass: 4,
        DsIconGlyph.clock: 2,
        DsIconGlyph.lock: 2,
        DsIconGlyph.shield: 1,
        DsIconGlyph.shieldCheck: 2,
        DsIconGlyph.info: 3,
        DsIconGlyph.helpCircle: 3,
        DsIconGlyph.alertTriangle: 3,
        DsIconGlyph.rotateCcw: 2,
        DsIconGlyph.loaderCircle: 1,
        DsIconGlyph.play: 1,
        DsIconGlyph.pause: 2,
        DsIconGlyph.volume2: 3,
        DsIconGlyph.volumeX: 3,
        DsIconGlyph.circleCheck: 2,
        DsIconGlyph.octagonX: 3,
        DsIconGlyph.circleX: 3,
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

    test('every element of every glyph matches its module, attribute for '
        'attribute', () {
      // The whole-set version of the two tests above: [_transcript] restates
      // all 68 `__iconNode` lists independently of `icon_paths.dart`.
      expect(_transcript.keys, unorderedEquals(DsIconGlyph.values),
          reason: 'the transcript table must cover every glyph');
      for (final DsIconGlyph glyph in DsIconGlyph.values) {
        expect(
          DsIconPaths.elements[glyph]!.map(_signature).toList(),
          _transcript[glyph],
          reason: '${glyph.name} — element order and attributes',
        );
      }
    });

    test('the curated set is 63 glyphs, 59 of them new in this batch', () {
      expect(_curated, hasLength(63));
      expect(_curated.toSet(), hasLength(63), reason: 'no duplicates');
      expect(
        _curated.where(_curatedAlreadyPresent.contains),
        hasLength(4),
        reason: 'ArrowLeft, ArrowRight, X and Check were already embedded',
      );
      // Everything in the enum is either curated or docs chrome; the two
      // off-set glyphs are the deliberate exceptions — `rotateCcw` for the
      // motion page's replay control, `loaderCircle` for `DsSpinner`. Both are
      // rendered by components, neither is in `lib/ds/icons.ts`, and the icons
      // page's registry must keep excluding both.
      const List<DsIconGlyph> chrome = <DsIconGlyph>[
        DsIconGlyph.menu,
        DsIconGlyph.x,
        DsIconGlyph.sun,
        DsIconGlyph.monitor,
        DsIconGlyph.moon,
        DsIconGlyph.arrowLeft,
        DsIconGlyph.arrowRight,
        DsIconGlyph.check,
      ];
      expect(
        DsIconGlyph.values.where(
            (DsIconGlyph g) => !_curated.contains(g) && !chrome.contains(g)),
        <DsIconGlyph>[
          DsIconGlyph.rotateCcw,
          DsIconGlyph.loaderCircle,
          DsIconGlyph.play,
          DsIconGlyph.pause,
          DsIconGlyph.volume2,
          DsIconGlyph.volumeX,
          DsIconGlyph.circleCheck,
          DsIconGlyph.octagonX,
          DsIconGlyph.circleX,
        ],
      );
      // 8 chrome + 59 new curated + 9 off-set.
      expect(DsIconGlyph.values, hasLength(76));
    });

    test('the 59 new curated glyphs come to the ledger\'s 162 elements', () {
      // `icons-map.md` §12.3 counted these from the package: 162 elements —
      // 123 path, 25 circle, 9 rect, 4 line, 1 polyline.
      final Iterable<DsIconGlyph> fresh =
          _curated.where((DsIconGlyph g) => !_curatedAlreadyPresent.contains(g));
      expect(fresh, hasLength(59));
      final Map<Type, int> tally = <Type, int>{};
      for (final DsIconGlyph glyph in fresh) {
        for (final DsIconElement element in DsIconPaths.elements[glyph]!) {
          tally.update(element.runtimeType, (int n) => n + 1, ifAbsent: () => 1);
        }
      }
      expect(tally[DsIconPathElement], 123);
      expect(tally[DsIconCircleElement], 25);
      expect(tally[DsIconRectElement], 9);
      expect(tally[DsIconLineElement], 4);
      expect(tally[DsIconPolylineElement], 1);
      expect(tally.values.reduce((int a, int b) => a + b), 162);
    });

    test('`polyline` is transcribed as points, and package is the only one',
        () {
      // package.mjs: ["polyline", { points: "3.29 7 12 12 20.71 7" }]
      final DsIconPolylineElement lid = DsIconPaths
          .elements[DsIconGlyph.package]![2] as DsIconPolylineElement;
      expect(lid.points, <Offset>[
        const Offset(3.29, 7),
        const Offset(12, 12),
        const Offset(20.71, 7),
      ]);
      expect(
        DsIconGlyph.values.where((DsIconGlyph g) => DsIconPaths.elements[g]!
            .any((DsIconElement e) => e is DsIconPolylineElement)),
        <DsIconGlyph>[DsIconGlyph.package],
      );
    });

    test('`fill="currentColor"` is transcribed, and tag is the only one', () {
      // tag.mjs: ["circle", { cx: "7.5", cy: "7.5", r: ".5",
      //                       fill: "currentColor" }]
      final DsIconCircleElement dot =
          DsIconPaths.elements[DsIconGlyph.tag]![1] as DsIconCircleElement;
      expect(<double>[dot.cx, dot.cy, dot.r], <double>[7.5, 7.5, 0.5]);
      expect(dot.filled, isTrue);
      // Every other element in the package is unfilled — `filled` defaults
      // false on the sealed base, so this also proves nothing set it by
      // accident.
      final List<DsIconElement> filled = <DsIconElement>[
        for (final DsIconGlyph glyph in DsIconGlyph.values)
          ...DsIconPaths.elements[glyph]!.where((DsIconElement e) => e.filled),
      ];
      expect(filled, hasLength(1));
      expect(identical(filled.single, dot), isTrue);
    });

    test('lucide writes `ry` only where it equals `rx`', () {
      // §12.4.3: the old docstring claimed lucide never sets `ry`. copy.mjs and
      // lock.mjs both do — asserted equal here rather than assumed equal, which
      // is what made the claim safe to correct instead of just delete.
      final List<DsIconRectElement> rects = <DsIconRectElement>[
        for (final DsIconGlyph glyph in DsIconGlyph.values)
          ...DsIconPaths.elements[glyph]!.whereType<DsIconRectElement>(),
      ];
      // 9 curated + monitor's screen + pause's two bars.
      expect(rects, hasLength(12));
      final Iterable<DsIconRectElement> spelled =
          rects.where((DsIconRectElement r) => r.ry != null);
      expect(spelled, hasLength(2));
      for (final DsIconRectElement rect in spelled) {
        expect(rect.ry, rect.rx);
      }
      expect(
        DsIconGlyph.values.where((DsIconGlyph g) => DsIconPaths.elements[g]!
            .whereType<DsIconRectElement>()
            .any((DsIconRectElement r) => r.ry != null)),
        <DsIconGlyph>[DsIconGlyph.copy, DsIconGlyph.lock],
      );
    });

    test('the three deprecated aliases carry their target module\'s geometry',
        () {
      // §11.12 / ruling I-Q2: `filter.mjs`, `help-circle.mjs` and
      // `alert-triangle.mjs` are one-line re-exports in 1.28.0. The enum keeps
      // the curated name; the geometry must be the target module's. A funnel
      // opens with `M10 20`, a question mark's ring is the shared 10-unit
      // circle, and a warning triangle opens with `m21.73 18`.
      expect(
        (DsIconPaths.elements[DsIconGlyph.filter]!.single as DsIconPathElement)
            .d
            .startsWith('M10 20a1 1 0 0 0 .553.895'),
        isTrue,
      );
      expect(DsIconPaths.elements[DsIconGlyph.helpCircle]!.first,
          isA<DsIconCircleElement>());
      expect(
        (DsIconPaths.elements[DsIconGlyph.helpCircle]![1] as DsIconPathElement)
            .d,
        'M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3',
      );
      expect(
        (DsIconPaths.elements[DsIconGlyph.alertTriangle]!.first
                as DsIconPathElement)
            .d
            .startsWith('m21.73 18-8-14'),
        isTrue,
      );
    });
  });

  // ─── pathFor ─────────────────────────────────────────────────────────────

  group('DsIconPaths.pathFor', () {
    test('every glyph is drawn and stays on the 24×24 grid', () {
      for (final DsIconGlyph glyph in DsIconGlyph.values) {
        final Path path = DsIconPaths.pathFor(glyph);
        final Rect bounds = path.getBounds();
        // NOT `bounds.isEmpty`: `Rect.isEmpty` is true when *either* side is
        // zero, and `minus` is the single rule `M5 12h14` — 14 wide, 0 tall,
        // so a perfectly drawn glyph reports an "empty" rect. The honest
        // "drew something" checks are the extent and the stroke length.
        expect(bounds.longestSide, greaterThan(0),
            reason: '${glyph.name} drew nothing');
        expect(_length(path), greaterThan(0),
            reason: '${glyph.name} has no stroke length');
        // A hair of tolerance: the arc glyphs' bounds carry cubic control
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

    test('no glyph even approaches the grid edge — measured margin', () {
      // The question `icons-map.md` §12.4.4 and ruling I-Q7 raised: does the
      // grid assertion above survive 59 arc-heavy glyphs, given `getBounds()`
      // includes control points that bulge outside the drawn curve?
      //
      // MEASURED, not assumed: the worst excursion across all 68 glyphs is
      // **negative** — every control polygon lands strictly inside the grid,
      // and the tightest still clears the edge by a full unit. So the −0.01 /
      // +24.01 tolerance above never had to be widened, and `_tightBounds`
      // never had to be substituted for `getBounds()`.
      //
      // The tightest is `radio`, whose outer pair of 10-unit broadcast arcs
      // are drawn about the grid centre and reach x = 2 and x = 22; their
      // cubic control points sit at 1.0252 and 22.9748. `zap` is the tightest
      // *vertically* (control points at y = 1.8586 and 22.1417 around geometry
      // that stops at 2.0008 and 21.9992) — see the spike group below.
      double worst = double.negativeInfinity;
      DsIconGlyph worstGlyph = DsIconGlyph.menu;
      for (final DsIconGlyph glyph in DsIconGlyph.values) {
        final Rect b = DsIconPaths.pathFor(glyph).getBounds();
        final double excursion = <double>[
          -b.left,
          -b.top,
          b.right - DsIconPaths.viewBox,
          b.bottom - DsIconPaths.viewBox,
        ].reduce(math.max);
        if (excursion > worst) {
          worst = excursion;
          worstGlyph = glyph;
        }
      }
      expect(worstGlyph, DsIconGlyph.radio);
      expect(worst, closeTo(-1.0252, 0.001));
      expect(worst, lessThan(0));
    });

    test('subpath counts match the element lists', () {
      // One contour per `M`/`m` in a `d`, one per structured element. Checked
      // for every glyph rather than a hand-picked few: `circle` and `rect` add
      // one closed contour each, `line` and `polyline` one open contour each,
      // and no lucide `d` in the set carries a second moveto.
      for (final DsIconGlyph glyph in DsIconGlyph.values) {
        expect(_contours(DsIconPaths.pathFor(glyph)),
            hasLength(_expectedContours(glyph)),
            reason: '${glyph.name} contour count');
      }
      // Spot values, so the invariant above cannot drift into vacuity.
      expect(_contours(DsIconPaths.pathFor(DsIconGlyph.menu)), hasLength(3));
      expect(_contours(DsIconPaths.pathFor(DsIconGlyph.sun)), hasLength(9));
      expect(_contours(DsIconPaths.pathFor(DsIconGlyph.moon)), hasLength(1));
      expect(_contours(DsIconPaths.pathFor(DsIconGlyph.package)), hasLength(4));
      expect(_contours(DsIconPaths.pathFor(DsIconGlyph.slidersHorizontal)),
          hasLength(9));
    });

    test('fillPathFor is null for every glyph but tag', () {
      for (final DsIconGlyph glyph in DsIconGlyph.values) {
        final Path? fill = DsIconPaths.fillPathFor(glyph);
        if (glyph == DsIconGlyph.tag) {
          expect(fill, isNotNull, reason: 'tag has the one filled node');
        } else {
          expect(fill, isNull, reason: '${glyph.name} has no filled node');
        }
      }
      // The dot itself: r = 0.5 about (7.5, 7.5), and the point at its centre
      // is inside the region — i.e. it is a disc, not a ring.
      final Path dot = DsIconPaths.fillPathFor(DsIconGlyph.tag)!;
      expect(dot.getBounds(),
          _rectCloseTo(const Rect.fromLTRB(7, 7, 8, 8), 0.001));
      expect(dot.contains(const Offset(7.5, 7.5)), isTrue);
      // …and the stroke pass still carries it, because `fill` on a lucide node
      // overrides `fill="none"` and nothing else — the inherited stroke stays.
      // So `pathFor` is still *every* element, and the tag path has both its
      // closed label outline and the dot's own contour.
      expect(_contours(DsIconPaths.pathFor(DsIconGlyph.tag)), hasLength(2));
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

      // Across the whole set, rather than the six-glyph allowlist this test
      // used to carry: closed contours are exactly the `z`/`Z` commands plus
      // the `circle`s and `rect`s, and nothing else closes. Twelve of the 59
      // new glyphs carry a `z` — the first closed *path* subpaths in the
      // package — so an allowlist would have stopped covering the majority
      // (icons-map.md §12.4.4).
      int totalClosed = 0;
      for (final DsIconGlyph glyph in DsIconGlyph.values) {
        final int closed = _contours(DsIconPaths.pathFor(glyph))
            .where((PathMetric c) => c.isClosed)
            .length;
        expect(closed, _expectedClosedContours(glyph),
            reason: '${glyph.name} closed-contour count');
        totalClosed += closed;
      }
      // 17 `z` commands + 28 circles + 12 rects. Seventeen, not twelve: the map
      // counts twelve *glyphs* that carry a `z`, `packageOpen` spends two of
      // them (its second and fourth flaps both close), the off-set swap glyphs
      // add three — `play`'s triangle and the speaker body that `volume2` and
      // `volumeX` share — and `octagonX`'s plate is the seventeenth.
      expect(totalClosed, 57);
      expect(
        DsIconGlyph.values.where((DsIconGlyph g) => DsIconPaths.elements[g]!
            .whereType<DsIconPathElement>()
            .any((DsIconPathElement e) => e.d.contains(RegExp('[zZ]')))),
        <DsIconGlyph>[
          DsIconGlyph.package,
          DsIconGlyph.layers,
          DsIconGlyph.trophy,
          DsIconGlyph.packageOpen,
          DsIconGlyph.filter,
          DsIconGlyph.sparkles,
          DsIconGlyph.crown,
          DsIconGlyph.zap,
          DsIconGlyph.star,
          DsIconGlyph.tag,
          DsIconGlyph.shield,
          DsIconGlyph.shieldCheck,
          // The off-set glyphs that carry a `z`, in enum order. `circleCheck`
          // and `circleX` are absent on purpose: their rings close by being
          // `circle` nodes, not by a `z` command.
          DsIconGlyph.play,
          DsIconGlyph.volume2,
          DsIconGlyph.volumeX,
          DsIconGlyph.octagonX,
        ],
      );
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

  // ─── the arc spike ───────────────────────────────────────────────────────

  group('star, zap, sparkles, crown — the arc-heavy spike', () {
    // The four glyphs ruling I-Q7 required be transcribed and run *before* the
    // other 55, precisely because they are the ones whose rounded vertices
    // could push `getBounds()` off the grid. All four numbers below are
    // MEASURED on Flutter 3.44.8 and pinned: the tight bounds prove the arc
    // maths lands on the design's own round numbers, and the `getBounds()`
    // pins prove the emitted control polygon has not drifted.

    test('zap is drawn to a 4–20 × 2–22 box', () {
      // Every one of its 1.5-unit corner arcs lands on integers, which is the
      // clearest evidence the F.6.5 conversion is right on packed flags
      // (`a1.5 1.5 0 00-2.474-1.561` — two flags and a coordinate, no spaces).
      final Rect tight = _tightBounds(DsIconPaths.pathFor(DsIconGlyph.zap));
      expect(tight, _rectCloseTo(const Rect.fromLTRB(4, 2, 20, 22), 0.002));
      // …and its control points are the set's widest excursion, still 1.85
      // units clear of the grid edge.
      final Rect bounds = DsIconPaths.pathFor(DsIconGlyph.zap).getBounds();
      expect(bounds.left, closeTo(3.8823, 0.001));
      expect(bounds.top, closeTo(1.8586, 0.001));
      expect(bounds.right, closeTo(20.1176, 0.001));
      expect(bounds.bottom, closeTo(22.1417, 0.001));
    });

    test('star reaches its five points', () {
      final Rect tight = _tightBounds(DsIconPaths.pathFor(DsIconGlyph.star));
      expect(tight.left, closeTo(1.9982, 0.005));
      expect(tight.top, closeTo(2.0001, 0.005));
      expect(tight.right, closeTo(22.0000, 0.005));
      expect(tight.bottom, closeTo(21.0722, 0.005));
      final Rect bounds = DsIconPaths.pathFor(DsIconGlyph.star).getBounds();
      expect(bounds.left, closeTo(1.9616, 0.001));
      expect(bounds.right, closeTo(22.0364, 0.001));
    });

    test('sparkles is symmetric about the grid centre', () {
      // The four-point star's arcs are shallow enough that the control polygon
      // never leaves the drawn curve — tight bounds and `getBounds()` agree to
      // the last digit, which no other arc glyph in the set manages.
      final Path path = DsIconPaths.pathFor(DsIconGlyph.sparkles);
      final Rect tight = _tightBounds(path);
      expect(tight,
          _rectCloseTo(const Rect.fromLTRB(1.9976, 1.9976, 22.0024, 22.0024),
              0.001));
      expect(path.getBounds(), _rectCloseTo(tight, 0.0005));
    });

    test('crown sits on its base rule', () {
      final Rect tight = _tightBounds(DsIconPaths.pathFor(DsIconGlyph.crown));
      expect(tight.left, closeTo(2.0025, 0.005));
      expect(tight.top, closeTo(3.0072, 0.005));
      expect(tight.right, closeTo(21.9985, 0.005));
      // `M5 21h14` is the lowest thing it draws, exactly on 21.
      expect(tight.bottom, closeTo(21, 0.001));
    });
  });
}

/// Every element of every glyph, in lucide's own order, transcribed from the
/// `.mjs` modules a second time.
///
/// This is the guard the map asks for: `icon_paths.dart` is a transcript, and a
/// transcript is only trustworthy if something independent restates it. Written
/// in [_signature] form so one line covers one element and every attribute of
/// it — a dropped `fill`, a swapped `x`/`y`, a `ry` that stopped being
/// transcribed, or a `d` string that lost a character all fail here.
const Map<DsIconGlyph, List<String>> _transcript = <DsIconGlyph, List<String>>{
  // ─── docs chrome ───
  DsIconGlyph.menu: <String>[
    'path M4 5h16',
    'path M4 12h16',
    'path M4 19h16',
  ],
  DsIconGlyph.x: <String>[
    'path M18 6 6 18',
    'path m6 6 12 12',
  ],
  DsIconGlyph.sun: <String>[
    'circle 12 12 4',
    'path M12 2v2',
    'path M12 20v2',
    'path m4.93 4.93 1.41 1.41',
    'path m17.66 17.66 1.41 1.41',
    'path M2 12h2',
    'path M20 12h2',
    'path m6.34 17.66-1.41 1.41',
    'path m19.07 4.93-1.41 1.41',
  ],
  DsIconGlyph.monitor: <String>[
    'rect 2 3 20 14 2',
    'line 8 21 16 21',
    'line 12 17 12 21',
  ],
  DsIconGlyph.moon: <String>[
    'path M20.985 12.486a9 9 0 1 1-9.473-9.472c.405-.022.617.46.402.803a6 6 0 0 0 8.268 8.268c.344-.215.825-.004.803.401',
  ],
  DsIconGlyph.arrowLeft: <String>[
    'path m12 19-7-7 7-7',
    'path M19 12H5',
  ],
  DsIconGlyph.arrowRight: <String>[
    'path M5 12h14',
    'path m12 5 7 7-7 7',
  ],
  DsIconGlyph.check: <String>[
    'path M20 6 9 17l-5-5',
  ],

  // ─── curated · "Navigation & structure" ───
  DsIconGlyph.package: <String>[
    'path M11 21.73a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73z',
    'path M12 22V12',
    'polyline 3.29 7 12 12 20.71 7',
    'path m7.5 4.27 9 5.15',
  ],
  DsIconGlyph.radio: <String>[
    'path M16.247 7.761a6 6 0 0 1 0 8.478',
    'path M19.075 4.933a10 10 0 0 1 0 14.134',
    'path M4.925 19.067a10 10 0 0 1 0-14.134',
    'path M7.753 16.239a6 6 0 0 1 0-8.478',
    'circle 12 12 2',
  ],
  DsIconGlyph.layers: <String>[
    'path M12.83 2.18a2 2 0 0 0-1.66 0L2.6 6.08a1 1 0 0 0 0 1.83l8.58 3.91a2 2 0 0 0 1.66 0l8.58-3.9a1 1 0 0 0 0-1.83z',
    'path M2 12a1 1 0 0 0 .58.91l8.6 3.91a2 2 0 0 0 1.65 0l8.58-3.9A1 1 0 0 0 22 12',
    'path M2 17a1 1 0 0 0 .58.91l8.6 3.91a2 2 0 0 0 1.65 0l8.58-3.9A1 1 0 0 0 22 17',
  ],
  DsIconGlyph.gift: <String>[
    'path M12 7v14',
    'path M20 11v8a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2v-8',
    'path M7.5 7a1 1 0 0 1 0-5A4.8 8 0 0 1 12 7a4.8 8 0 0 1 4.5-5 1 1 0 0 1 0 5',
    'rect 3 7 18 4 1',
  ],
  DsIconGlyph.trophy: <String>[
    'path M10 14.66V17a1 1 0 0 1-1 1 2 2 0 0 0-2 2v2',
    'path M14 14.66V17a1 1 0 0 0 1 1 2 2 0 0 1 2 2v2',
    'path M17.916 10H19.5A2.5 2.5 0 0 0 22 7.5V5a1 1 0 0 0-1-1h-3',
    'path M4 22h16',
    'path M6 9a6 6 0 0 0 12 0V3a1 1 0 0 0-1-1H7a1 1 0 0 0-1 1z',
    'path M6.084 10H4.5A2.5 2.5 0 0 1 2 7.5V5a1 1 0 0 1 1-1h3',
  ],
  DsIconGlyph.wallet: <String>[
    'path M19 7V4a1 1 0 0 0-1-1H5a2 2 0 0 0 0 4h15a1 1 0 0 1 1 1v4h-3a2 2 0 0 0 0 4h3a1 1 0 0 0 1-1v-2a1 1 0 0 0-1-1',
    'path M3 5v14a2 2 0 0 0 2 2h15a1 1 0 0 0 1-1v-4',
  ],
  DsIconGlyph.user: <String>[
    'path M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2',
    'circle 12 7 4',
  ],
  DsIconGlyph.search: <String>[
    'path m21 21-4.34-4.34',
    'circle 11 11 8',
  ],
  DsIconGlyph.bell: <String>[
    'path M10.268 21a2 2 0 0 0 3.464 0',
    'path M3.262 15.326A1 1 0 0 0 4 17h16a1 1 0 0 0 .74-1.673C19.41 13.956 18 12.499 18 8A6 6 0 0 0 6 8c0 4.499-1.411 5.956-2.738 7.326',
  ],
  DsIconGlyph.settings: <String>[
    'path M9.671 4.136a2.34 2.34 0 0 1 4.659 0 2.34 2.34 0 0 0 3.319 1.915 2.34 2.34 0 0 1 2.33 4.033 2.34 2.34 0 0 0 0 3.831 2.34 2.34 0 0 1-2.33 4.033 2.34 2.34 0 0 0-3.319 1.915 2.34 2.34 0 0 1-4.659 0 2.34 2.34 0 0 0-3.32-1.915 2.34 2.34 0 0 1-2.33-4.033 2.34 2.34 0 0 0 0-3.831A2.34 2.34 0 0 1 6.35 6.051a2.34 2.34 0 0 0 3.319-1.915',
    'circle 12 12 3',
  ],
  DsIconGlyph.logOut: <String>[
    'path m16 17 5-5-5-5',
    'path M21 12H9',
    'path M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4',
  ],
  DsIconGlyph.layoutGrid: <String>[
    'rect 3 3 7 7 1',
    'rect 14 3 7 7 1',
    'rect 14 14 7 7 1',
    'rect 3 14 7 7 1',
  ],
  DsIconGlyph.rows3: <String>[
    'rect 3 3 18 18 2',
    'path M21 9H3',
    'path M21 15H3',
  ],
  DsIconGlyph.chevronDown: <String>['path m6 9 6 6 6-6'],
  DsIconGlyph.chevronUp: <String>['path m18 15-6-6-6 6'],
  DsIconGlyph.chevronLeft: <String>['path m15 18-6-6 6-6'],
  DsIconGlyph.chevronRight: <String>['path m9 18 6-6-6-6'],
  DsIconGlyph.ellipsis: <String>[
    'circle 12 12 1',
    'circle 19 12 1',
    'circle 5 12 1',
  ],
  DsIconGlyph.externalLink: <String>[
    'path M15 3h6v6',
    'path M10 14 21 3',
    'path M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6',
  ],

  // ─── curated · "Actions" ───
  DsIconGlyph.packageOpen: <String>[
    'path M12 22v-9',
    'path M15.17 2.21a1.67 1.67 0 0 1 1.63 0L21 4.57a1.93 1.93 0 0 1 0 3.36L8.82 14.79a1.655 1.655 0 0 1-1.64 0L3 12.43a1.93 1.93 0 0 1 0-3.36z',
    'path M20 13v3.87a2.06 2.06 0 0 1-1.11 1.83l-6 3.08a1.93 1.93 0 0 1-1.78 0l-6-3.08A2.06 2.06 0 0 1 4 16.87V13',
    'path M21 12.43a1.93 1.93 0 0 0 0-3.36L8.83 2.2a1.64 1.64 0 0 0-1.63 0L3 4.57a1.93 1.93 0 0 0 0 3.36l12.18 6.86a1.636 1.636 0 0 0 1.63 0z',
  ],
  DsIconGlyph.shoppingCart: <String>[
    'circle 8 21 1',
    'circle 19 21 1',
    'path M2.05 2.05h2l2.66 12.42a2 2 0 0 0 2 1.58h9.78a2 2 0 0 0 1.95-1.57l1.65-7.43H5.12',
  ],
  DsIconGlyph.heart: <String>[
    'path M2 9.5a5.5 5.5 0 0 1 9.591-3.676.56.56 0 0 0 .818 0A5.49 5.49 0 0 1 22 9.5c0 2.29-1.5 4-3 5.5l-5.492 5.313a2 2 0 0 1-3 .019L5 15c-1.5-1.5-3-3.2-3-5.5',
  ],
  DsIconGlyph.eye: <String>[
    'path M2.062 12.348a1 1 0 0 1 0-.696 10.75 10.75 0 0 1 19.876 0 1 1 0 0 1 0 .696 10.75 10.75 0 0 1-19.876 0',
    'circle 12 12 3',
  ],
  DsIconGlyph.eyeOff: <String>[
    'path M10.733 5.076a10.744 10.744 0 0 1 11.205 6.575 1 1 0 0 1 0 .696 10.747 10.747 0 0 1-1.444 2.49',
    'path M14.084 14.158a3 3 0 0 1-4.242-4.242',
    'path M17.479 17.499a10.75 10.75 0 0 1-15.417-5.151 1 1 0 0 1 0-.696 10.75 10.75 0 0 1 4.446-5.143',
    'path m2 2 20 20',
  ],
  DsIconGlyph.share2: <String>[
    'circle 18 5 3',
    'circle 6 12 3',
    'circle 18 19 3',
    'line 8.59 13.51 15.42 17.49',
    'line 15.41 6.51 8.59 10.49',
  ],
  DsIconGlyph.copy: <String>[
    'rect 8 8 14 14 2 ry 2',
    'path M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2',
  ],
  DsIconGlyph.filter: <String>[
    'path M10 20a1 1 0 0 0 .553.895l2 1A1 1 0 0 0 14 21v-7a2 2 0 0 1 .517-1.341L21.74 4.67A1 1 0 0 0 21 3H3a1 1 0 0 0-.742 1.67l7.225 7.989A2 2 0 0 1 10 14z',
  ],
  DsIconGlyph.slidersHorizontal: <String>[
    'path M10 5H3',
    'path M12 19H3',
    'path M14 3v4',
    'path M16 17v4',
    'path M21 12h-9',
    'path M21 19h-5',
    'path M21 5h-7',
    'path M8 10v4',
    'path M8 12H3',
  ],
  DsIconGlyph.plus: <String>[
    'path M5 12h14',
    'path M12 5v14',
  ],
  DsIconGlyph.minus: <String>['path M5 12h14'],
  DsIconGlyph.refreshCw: <String>[
    'path M3 12a9 9 0 0 1 9-9 9.75 9.75 0 0 1 6.74 2.74L21 8',
    'path M21 3v5h-5',
    'path M21 12a9 9 0 0 1-9 9 9.75 9.75 0 0 1-6.74-2.74L3 16',
    'path M8 16H3v5',
  ],
  DsIconGlyph.download: <String>[
    'path M12 15V3',
    'path M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4',
    'path m7 10 5 5 5-5',
  ],
  DsIconGlyph.upload: <String>[
    'path M12 3v12',
    'path m17 8-5-5-5 5',
    'path M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4',
  ],
  DsIconGlyph.truck: <String>[
    'path M14 18V6a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2v11a1 1 0 0 0 1 1h2',
    'path M15 18H9',
    'path M19 18h2a1 1 0 0 0 1-1v-3.65a1 1 0 0 0-.22-.624l-3.48-4.35A1 1 0 0 0 17.52 8H14',
    'circle 17 18 2',
    'circle 7 18 2',
  ],
  DsIconGlyph.trash2: <String>[
    'path M10 11v6',
    'path M14 11v6',
    'path M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6',
    'path M3 6h18',
    'path M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2',
  ],
  DsIconGlyph.ban: <String>[
    'circle 12 12 10',
    'path M4.929 4.929 19.07 19.071',
  ],

  // ─── curated · "Collectible domain" ───
  DsIconGlyph.sparkles: <String>[
    'path M11.017 2.814a1 1 0 0 1 1.966 0l1.051 5.558a2 2 0 0 0 1.594 1.594l5.558 1.051a1 1 0 0 1 0 1.966l-5.558 1.051a2 2 0 0 0-1.594 1.594l-1.051 5.558a1 1 0 0 1-1.966 0l-1.051-5.558a2 2 0 0 0-1.594-1.594l-5.558-1.051a1 1 0 0 1 0-1.966l5.558-1.051a2 2 0 0 0 1.594-1.594z',
    'path M20 2v4',
    'path M22 4h-4',
    'circle 4 20 2',
  ],
  DsIconGlyph.crown: <String>[
    'path M11.562 3.266a.5.5 0 0 1 .876 0L15.39 8.87a1 1 0 0 0 1.516.294L21.183 5.5a.5.5 0 0 1 .798.519l-2.834 10.246a1 1 0 0 1-.956.734H5.81a1 1 0 0 1-.957-.734L2.02 6.02a.5.5 0 0 1 .798-.519l4.276 3.664a1 1 0 0 0 1.516-.294z',
    'path M5 21h14',
  ],
  DsIconGlyph.flame: <String>[
    'path M12 3q1 4 4 6.5t3 5.5a1 1 0 0 1-14 0 5 5 0 0 1 1-3 1 1 0 0 0 5 0c0-2-1.5-3-1.5-5q0-2 2.5-4',
  ],
  DsIconGlyph.zap: <String>[
    'path M15.914 4a1.5 1.5 0 00-2.474-1.561l-9 9A1.5 1.5 0 005.5 14h4.002a.5.5 0 01.471.666L8.086 20a1.5 1.5 0 002.475 1.56l9-9A1.5 1.5 0 0018.5 10h-3.997a.5.5 0 01-.472-.667z',
  ],
  DsIconGlyph.star: <String>[
    'path M11.525 2.295a.53.53 0 0 1 .95 0l2.31 4.679a2.123 2.123 0 0 0 1.595 1.16l5.166.756a.53.53 0 0 1 .294.904l-3.736 3.638a2.123 2.123 0 0 0-.611 1.878l.882 5.14a.53.53 0 0 1-.771.56l-4.618-2.428a2.122 2.122 0 0 0-1.973 0L6.396 21.01a.53.53 0 0 1-.77-.56l.881-5.139a2.122 2.122 0 0 0-.611-1.879L2.16 9.795a.53.53 0 0 1 .294-.906l5.165-.755a2.122 2.122 0 0 0 1.597-1.16z',
  ],
  DsIconGlyph.tag: <String>[
    'path M12.586 2.586A2 2 0 0 0 11.172 2H4a2 2 0 0 0-2 2v7.172a2 2 0 0 0 .586 1.414l8.704 8.704a2.426 2.426 0 0 0 3.42 0l6.58-6.58a2.426 2.426 0 0 0 0-3.42z',
    'circle 7.5 7.5 0.5 fill',
  ],
  DsIconGlyph.percent: <String>[
    'line 19 5 5 19',
    'circle 6.5 6.5 2.5',
    'circle 17.5 17.5 2.5',
  ],
  DsIconGlyph.medal: <String>[
    'path M7.21 15 2.66 7.14a2 2 0 0 1 .13-2.2L4.4 2.8A2 2 0 0 1 6 2h12a2 2 0 0 1 1.6.8l1.6 2.14a2 2 0 0 1 .14 2.2L16.79 15',
    'path M11 12 5.12 2.2',
    'path m13 12 5.88-9.8',
    'path M8 7h8',
    'circle 12 17 5',
    'path M12 18v-2h-.5',
  ],
  DsIconGlyph.activity: <String>[
    'path M22 12h-2.48a2 2 0 0 0-1.93 1.46l-2.35 8.36a.25.25 0 0 1-.48 0L9.24 2.18a.25.25 0 0 0-.48 0l-2.35 8.36A2 2 0 0 1 4.49 12H2',
  ],
  DsIconGlyph.trendingUp: <String>[
    'path M16 7h6v6',
    'path m22 7-8.5 8.5-5-5L2 17',
  ],
  DsIconGlyph.trendingDown: <String>[
    'path M16 17h6v-6',
    'path m22 17-8.5-8.5-5 5L2 7',
  ],

  // ─── curated · "Money & status" ───
  DsIconGlyph.circleDollarSign: <String>[
    'circle 12 12 10',
    'path M16 8h-6a2 2 0 1 0 0 4h4a2 2 0 1 1 0 4H8',
    'path M12 18V6',
  ],
  DsIconGlyph.creditCard: <String>[
    'rect 2 5 20 14 2',
    'line 2 10 22 10',
  ],
  DsIconGlyph.arrowDownLeft: <String>[
    'path M17 7 7 17',
    'path M17 17H7V7',
  ],
  DsIconGlyph.arrowUpRight: <String>[
    'path M7 7h10v10',
    'path M7 17 17 7',
  ],
  DsIconGlyph.hourglass: <String>[
    'path M5 22h14',
    'path M5 2h14',
    'path M17 22v-4.172a2 2 0 0 0-.586-1.414L12 12l-4.414 4.414A2 2 0 0 0 7 17.828V22',
    'path M7 2v4.172a2 2 0 0 0 .586 1.414L12 12l4.414-4.414A2 2 0 0 0 17 6.172V2',
  ],
  DsIconGlyph.clock: <String>[
    'circle 12 12 10',
    'path M12 6v6l4 2',
  ],
  DsIconGlyph.lock: <String>[
    'rect 3 11 18 11 2 ry 2',
    'path M7 11V7a5 5 0 0 1 10 0v4',
  ],
  DsIconGlyph.shield: <String>[
    'path M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z',
  ],
  DsIconGlyph.shieldCheck: <String>[
    'path M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z',
    'path m9 12 2 2 4-4',
  ],
  DsIconGlyph.info: <String>[
    'circle 12 12 10',
    'path M12 16v-4',
    'path M12 8h.01',
  ],
  DsIconGlyph.helpCircle: <String>[
    'circle 12 12 10',
    'path M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3',
    'path M12 17h.01',
  ],
  DsIconGlyph.alertTriangle: <String>[
    'path m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3',
    'path M12 9v4',
    'path M12 17h.01',
  ],

  // ─── off-set ───
  DsIconGlyph.rotateCcw: <String>[
    'path M3 12a9 9 0 1 0 9-9 9.75 9.75 0 0 0-6.74 2.74L3 8',
    'path M3 3v5h5',
  ],
  // `loader-circle.mjs`, imported in the reference as `Loader2Icon`.
  DsIconGlyph.loaderCircle: <String>[
    'path M21 12a9 9 0 1 1-6.219-8.56',
  ],
  DsIconGlyph.play: <String>[
    'path M5 5a2 2 0 0 1 3.008-1.728l11.997 6.998a2 2 0 0 1 .003 3.458l-12 7A2 2 0 0 1 5 19z',
  ],
  // The right-hand bar is declared first — order is paint order, so it is kept.
  DsIconGlyph.pause: <String>[
    'rect 14 3 5 18 1',
    'rect 5 3 5 18 1',
  ],
  DsIconGlyph.volume2: <String>[
    'path M11 4.702a.705.705 0 0 0-1.203-.498L6.413 7.587A1.4 1.4 0 0 1 5.416 8H3a1 1 0 0 0-1 1v6a1 1 0 0 0 1 1h2.416a1.4 1.4 0 0 1 .997.413l3.383 3.384A.705.705 0 0 0 11 19.298z',
    'path M16 9a5 5 0 0 1 0 6',
    'path M19.364 18.364a9 9 0 0 0 0-12.728',
  ],
  DsIconGlyph.volumeX: <String>[
    'path M11 4.702a.705.705 0 0 0-1.203-.498L6.413 7.587A1.4 1.4 0 0 1 5.416 8H3a1 1 0 0 0-1 1v6a1 1 0 0 0 1 1h2.416a1.4 1.4 0 0 1 .997.413l3.383 3.384A.705.705 0 0 0 11 19.298z',
    'line 22 9 16 15',
    'line 16 9 22 15',
  ],
  DsIconGlyph.circleCheck: <String>[
    'circle 12 12 10',
    'path m9 12 2 2 4-4',
  ],
  // Stroke, plate, stroke — lucide declares the octagon BETWEEN its two
  // diagonals, and order is paint order.
  DsIconGlyph.octagonX: <String>[
    'path m15 9-6 6',
    'path M2.586 16.726A2 2 0 0 1 2 15.312V8.688a2 2 0 0 1 .586-1.414l4.688-4.688A2 2 0 0 1 8.688 2h6.624a2 2 0 0 1 1.414.586l4.688 4.688A2 2 0 0 1 22 8.688v6.624a2 2 0 0 1-.586 1.414l-4.688 4.688a2 2 0 0 1-1.414.586H8.688a2 2 0 0 1-1.414-.586z',
    'path m9 9 6 6',
  ],
  DsIconGlyph.circleX: <String>[
    'circle 12 12 10',
    'path m15 9-6 6',
    'path m9 9 6 6',
  ],
};

/// `ICON_GROUPS` from `lib/ds/icons.ts`, flattened — the 63 curated entries in
/// the order the icons page renders them.
///
/// `ICON_COUNT` there is a `reduce`, not a literal; 21 + 19 + 11 + 12 = 63.
const List<DsIconGlyph> _curated = <DsIconGlyph>[
  // navigation — 21
  DsIconGlyph.package, DsIconGlyph.radio, DsIconGlyph.layers, DsIconGlyph.gift,
  DsIconGlyph.trophy, DsIconGlyph.wallet, DsIconGlyph.user, DsIconGlyph.search,
  DsIconGlyph.bell, DsIconGlyph.settings, DsIconGlyph.logOut,
  DsIconGlyph.layoutGrid, DsIconGlyph.rows3, DsIconGlyph.chevronDown,
  DsIconGlyph.chevronUp, DsIconGlyph.chevronLeft, DsIconGlyph.chevronRight,
  DsIconGlyph.arrowLeft, DsIconGlyph.arrowRight, DsIconGlyph.ellipsis,
  DsIconGlyph.externalLink,
  // actions — 19
  DsIconGlyph.packageOpen, DsIconGlyph.shoppingCart, DsIconGlyph.heart,
  DsIconGlyph.eye, DsIconGlyph.eyeOff, DsIconGlyph.share2, DsIconGlyph.copy,
  DsIconGlyph.filter, DsIconGlyph.slidersHorizontal, DsIconGlyph.plus,
  DsIconGlyph.minus, DsIconGlyph.refreshCw, DsIconGlyph.download,
  DsIconGlyph.upload, DsIconGlyph.truck, DsIconGlyph.trash2, DsIconGlyph.ban,
  DsIconGlyph.x, DsIconGlyph.check,
  // domain — 11
  DsIconGlyph.sparkles, DsIconGlyph.crown, DsIconGlyph.flame, DsIconGlyph.zap,
  DsIconGlyph.star, DsIconGlyph.tag, DsIconGlyph.percent, DsIconGlyph.medal,
  DsIconGlyph.activity, DsIconGlyph.trendingUp, DsIconGlyph.trendingDown,
  // money & status — 12
  DsIconGlyph.circleDollarSign, DsIconGlyph.creditCard,
  DsIconGlyph.arrowDownLeft, DsIconGlyph.arrowUpRight, DsIconGlyph.hourglass,
  DsIconGlyph.clock, DsIconGlyph.lock, DsIconGlyph.shield,
  DsIconGlyph.shieldCheck, DsIconGlyph.info, DsIconGlyph.helpCircle,
  DsIconGlyph.alertTriangle,
];

/// The four curated glyphs that were already embedded as docs chrome before
/// this batch — so the batch itself transcribed 59, not 63.
const List<DsIconGlyph> _curatedAlreadyPresent = <DsIconGlyph>[
  DsIconGlyph.arrowLeft,
  DsIconGlyph.arrowRight,
  DsIconGlyph.x,
  DsIconGlyph.check,
];

/// Matches a [Rect] edge by edge within [tolerance].
Matcher _rectCloseTo(Rect expected, double tolerance) => isA<Rect>()
    .having((Rect r) => r.left, 'left', closeTo(expected.left, tolerance))
    .having((Rect r) => r.top, 'top', closeTo(expected.top, tolerance))
    .having((Rect r) => r.right, 'right', closeTo(expected.right, tolerance))
    .having(
        (Rect r) => r.bottom, 'bottom', closeTo(expected.bottom, tolerance));
