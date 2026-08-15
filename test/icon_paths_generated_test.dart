import 'dart:typed_data';
import 'dart:ui';

import 'package:elattar_design_system/src/components/icon.dart';
import 'package:elattar_design_system/src/components/icon_paths.dart';
import 'package:elattar_design_system/src/components/icon_paths.g.dart';
import 'package:elattar_design_system/src/components/icon_paths.g.index.dart';
import 'package:flutter_test/flutter_test.dart';

/// The generated lucide registry, judged against the hand transcription.
///
/// `lib/src/components/icon_paths.dart` embeds 78 glyphs transcribed by hand
/// from `design-system/node_modules/lucide-react/dist/esm/icons/`.
/// `icon_paths.g.dart` is the whole package — 1756 glyphs — emitted
/// mechanically from those same modules by `tool/generate_icons.mjs`.
///
/// Both read the same source, so **they must agree on their overlap**, and the
/// first group below asserts exactly that: every one of the 78, element for
/// element and character for character. That is what makes the generator
/// trustworthy for the 1678 glyphs no human has read — it is checked against
/// the ones a human did read. It also runs the other way: the hand file caught
/// details a careless generator would smooth over (`ticket`'s uppercase `Z`),
/// and this test fails if the generator smooths them.
///
/// Imported through `src/` for `icon_paths_test.dart`'s reason: these
/// assertions are about the geometry layer, not the public surface.

// ─── enum → module name ─────────────────────────────────────────────────────

/// `arrowLeft` → `arrow-left`, `rows3` → `rows-3`, `volumeX` → `volume-x`.
///
/// The hand enum is named after lucide's own file names, so the correspondence
/// is mechanical — which is worth deriving rather than tabulating, because a
/// table of 78 pairs can drift silently and a derivation cannot.
String _kebab(String camel) => camel
    .replaceAllMapped(
        RegExp('([A-Z])'), (Match m) => '-${m[1]!.toLowerCase()}')
    .replaceAllMapped(RegExp('([0-9]+)'), (Match m) => '-${m[1]}');

/// The three enum members named after a **curated** spelling rather than the
/// module the geometry lives in.
///
/// `filter.mjs`, `help-circle.mjs` and `alert-triangle.mjs` are one-line
/// re-exports in 1.28.0; the enum keeps the curated name because that is the
/// string the icons page prints. See [DsIconGlyph.filter]'s own doc.
const Map<DsIconGlyph, String> _aliasedNames = <DsIconGlyph, String>{
  DsIconGlyph.filter: 'funnel',
  DsIconGlyph.helpCircle: 'circle-question-mark',
  DsIconGlyph.alertTriangle: 'triangle-alert',
};

String _moduleOf(DsIconGlyph glyph) =>
    _aliasedNames[glyph] ?? _kebab(glyph.name);

// ─── signatures ─────────────────────────────────────────────────────────────

/// A double the way lucide writes it: `12`, not `12.0`; `0.5` for its `.5`.
String _n(double v) =>
    v == v.roundToDouble() ? v.toInt().toString() : v.toString();

String _points(List<Offset> points) =>
    points.map((Offset p) => '${_n(p.dx)} ${_n(p.dy)}').join(' ');

/// One element as `tag attr attr …`.
///
/// **One function, both halves.** Before the merge this file carried two — one
/// over the hand file's `DsIconElement`, one over the generator's own
/// `DsLucideNode` shim — because the two sets were held in two models. They are
/// now one sealed model, so the identity check below compares the same
/// rendering of the same types, and what is left to disagree is the only thing
/// that ever mattered: the data.
///
/// Every attribute lucide writes appears here, `fill` and both radii included,
/// so an element that silently loses one fails rather than passing on the
/// attributes that remain. An absent radius prints as `auto` — the word, not a
/// resolved number — so "lucide omitted `rx`" and "lucide wrote `rx: 0`" can
/// never render the same string.
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
        :final double? rx,
        :final double? ry
      ) =>
        'rect ${_n(x)} ${_n(y)} ${_n(width)} ${_n(height)} '
            '${rx == null ? 'auto' : _n(rx)}'
            '${ry == null ? '' : ' ry ${_n(ry)}'}',
      DsIconEllipseElement(
        :final double cx,
        :final double cy,
        :final double rx,
        :final double ry
      ) =>
        'ellipse ${_n(cx)} ${_n(cy)} ${_n(rx)} ${_n(ry)}',
      DsIconPolylineElement(:final List<Offset> points) =>
        'polyline ${_points(points)}',
      DsIconPolygonElement(:final List<Offset> points) =>
        'polygon ${_points(points)}',
    };

// ─── rendered pixels ────────────────────────────────────────────────────────

/// The rasterised surface: the icon's own 24×24 box, plus 16 px of the space
/// "whatever sits to its right" would occupy.
const int _surfaceWidth = 40;
const int _surfaceHeight = 24;

/// Opaque black on a transparent ground, so "inked" is simply "alpha ≠ 0".
const Color _ink = Color(0xFF000000);

/// One glyph rendered at 24 units → 24 px, as raw RGBA.
Future<ByteData> _raster(WidgetTester t, void Function(Canvas) draw) async {
  final PictureRecorder recorder = PictureRecorder();
  draw(Canvas(recorder));
  final Image image = (await t.runAsync(() =>
      recorder.endRecording().toImage(_surfaceWidth, _surfaceHeight)))!;
  return (await t.runAsync(
      () => image.toByteData(format: ImageByteFormat.rawRgba)))!;
}

/// [DsIcon.paintGlyph] with the clip removed, and nothing else changed.
///
/// The control is written out by hand rather than driven by a flag so the two
/// renderings differ in exactly one canvas operation — which is what makes the
/// pins below bite instead of comparing a thing to itself.
void _paintUnclipped(Canvas canvas, Path path) {
  canvas.save();
  canvas.drawPath(
    path,
    Paint()
      ..color = _ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round,
  );
  canvas.restore();
}

Future<ByteData> _clipped(WidgetTester t, Path path) => _raster(
      t,
      (Canvas canvas) => DsIcon.paintGlyph(
        canvas,
        const Size(DsIconPaths.viewBox, DsIconPaths.viewBox),
        path: path,
        color: _ink,
        strokeWidth: 2,
      ),
    );

int _pixel(ByteData image, int x, int y) =>
    image.getUint32((y * _surfaceWidth + x) * 4);

/// The x of every pixel where two renderings disagree.
List<int> _differingColumns(ByteData a, ByteData b) {
  final Set<int> columns = <int>{};
  for (int y = 0; y < _surfaceHeight; y++) {
    for (int x = 0; x < _surfaceWidth; x++) {
      if (_pixel(a, x, y) != _pixel(b, x, y)) columns.add(x);
    }
  }
  return columns.toList()..sort();
}

/// The rightmost inked column, or −1 when nothing was drawn.
int _rightmostInkedColumn(ByteData image) {
  for (int x = _surfaceWidth - 1; x >= 0; x--) {
    for (int y = 0; y < _surfaceHeight; y++) {
      if (_pixel(image, x, y) != 0) return x;
    }
  }
  return -1;
}

/// Inked pixels beyond the 24-unit grid — the ones a browser never shows.
int _inkedOutsideGrid(ByteData image) {
  int n = 0;
  for (int y = 0; y < _surfaceHeight; y++) {
    for (int x = DsIconPaths.viewBox.toInt(); x < _surfaceWidth; x++) {
      if (_pixel(image, x, y) != 0) n++;
    }
  }
  return n;
}

/// The largest alpha difference between two renderings **inside** the grid, on
/// a 0–255 scale.
///
/// Skia does not rasterise a clipped draw and an unclipped one down the same
/// code path, so a handful of interior pixels land a step or two apart even
/// where the clip removes nothing. That is antialiasing noise rather than lost
/// geometry, and measuring its size is how the two are told apart.
int _maxAlphaDeltaInsideGrid(ByteData a, ByteData b) {
  int max = 0;
  for (int y = 0; y < _surfaceHeight; y++) {
    for (int x = 0; x < DsIconPaths.viewBox.toInt(); x++) {
      final int delta =
          ((_pixel(a, x, y) & 0xFF) - (_pixel(b, x, y) & 0xFF)).abs();
      if (delta > max) max = delta;
    }
  }
  return max;
}

void main() {
  // ─── the identity check ──────────────────────────────────────────────────

  group('the generated set reproduces the hand transcription', () {
    test('every one of the 78 resolves to a generated module', () {
      for (final DsIconGlyph glyph in DsIconGlyph.values) {
        expect(dsLucideByName[_moduleOf(glyph)], isNotNull,
            reason: '${glyph.name} → ${_moduleOf(glyph)}.mjs is not in the '
                'generated set');
      }
      // The derivation, not just its results: three names are overridden and
      // the other 75 are pure camel→kebab. If someone adds a fourth alias to
      // the enum without recording it here, the check above fails rather than
      // this one passing vacuously.
      expect(_aliasedNames, hasLength(3));
      expect(_kebab('arrowLeft'), 'arrow-left');
      expect(_kebab('rows3'), 'rows-3');
      expect(_kebab('volumeX'), 'volume-x');
      expect(_kebab('circleDollarSign'), 'circle-dollar-sign');
      expect(_kebab('x'), 'x');
    });

    test('element for element, character for character', () {
      final List<String> mismatches = <String>[];
      for (final DsIconGlyph glyph in DsIconGlyph.values) {
        final DsLucideGlyph generated = dsLucideByName[_moduleOf(glyph)]!;
        final List<String> hand =
            DsIconPaths.elements[glyph]!.map(_signature).toList();
        final List<String> mechanical =
            generated.nodes.map(_signature).toList();
        if (hand.length != mechanical.length) {
          mismatches.add('${glyph.name}: hand has ${hand.length} elements, '
              '${generated.name}.mjs has ${mechanical.length}');
          continue;
        }
        for (int i = 0; i < hand.length; i++) {
          if (hand[i] != mechanical[i]) {
            mismatches.add('${glyph.name}[$i]:\n'
                '      hand: ${hand[i]}\n'
                ' generated: ${mechanical[i]}');
          }
        }
      }
      expect(mismatches, isEmpty,
          reason: 'the hand transcription and the generator read the same '
              'modules, so every difference is a bug in one of them:\n'
              '${mismatches.join('\n')}');
    });

    test('the details the hand transcription was written to catch survive', () {
      String d(String module, int i) =>
          (dsLucideByName[module]!.nodes[i] as DsIconPathElement).d;

      // `ticket` is the one glyph in the curated set whose `d` closes with an
      // UPPERCASE `Z`. The parser treats the two spellings identically, so a
      // generator that lowercased on the way past would never fail a rendering
      // test — which is exactly why this is asserted on the character.
      expect(d('ticket', 0).endsWith('Z'), isTrue);
      expect(d('ticket', 0).contains('z'), isFalse);

      // `x.mjs` writes one diagonal absolute and the other relative. Same
      // shape, two spellings, both kept.
      expect(d('x', 0), 'M18 6 6 18');
      expect(d('x', 1), 'm6 6 12 12');

      // `zap`'s packed arc flags: `0 00-2.474` is two flags and a coordinate
      // with no separator at all.
      expect(d('zap', 0).contains('a1.5 1.5 0 00-2.474-1.561'), isTrue);

      // `flame` is the only curated glyph using `q` and `t`.
      expect(d('flame', 0).contains('q1 4 4 6.5t3 5.5'), isTrue);

      // lucide's keys are content hashes, so shared geometry is shared
      // verbatim: `shield` and `shield-check` open with the same crest.
      expect(d('shield', 0), d('shield-check', 0));
      // …and `circle-x` borrows every node it has.
      expect(_signature(dsLucideByName['circle-x']!.nodes[0]),
          _signature(dsLucideByName['circle-check']!.nodes[0]));
      expect(d('circle-x', 1), d('octagon-x', 0));
      expect(d('circle-x', 2), d('octagon-x', 2));

      // `tag`'s 0.5-unit dot is the curated set's only `fill="currentColor"`.
      final DsIconCircleElement dot =
          dsLucideByName['tag']!.nodes[1] as DsIconCircleElement;
      expect(<double>[dot.cx, dot.cy, dot.r], <double>[7.5, 7.5, 0.5]);
      expect(dot.filled, isTrue);
    });
  });

  // ─── the whole set ───────────────────────────────────────────────────────

  group('the whole package', () {
    test('is the version the header pins', () {
      // 1756 modules that export `__iconNode`, plus 250 that are nothing but a
      // re-export, is lucide-react 1.28.0's `dist/esm/icons/` exactly.
      expect(dsLucideByName, hasLength(1756));
      expect(dsLucideAliases, hasLength(250));
      // Every alias resolves to a real module — no dangling re-exports.
      for (final MapEntry<String, String> alias in dsLucideAliases.entries) {
        expect(dsLucideByName[alias.value], isNotNull,
            reason: '${alias.key} → ${alias.value} does not exist');
      }
      // …and no alias shadows a real module.
      for (final String alias in dsLucideAliases.keys) {
        expect(dsLucideByName.containsKey(alias), isFalse,
            reason: '$alias is both an alias and a module');
      }
    });

    test('every glyph knows its own name', () {
      for (final MapEntry<String, DsLucideGlyph> entry
          in dsLucideByName.entries) {
        expect(entry.value.name, entry.key);
        expect(entry.value.nodes, isNotEmpty);
      }
    });

    test('every one of the 7032 nodes parses, and only save-off leaves the '
        'grid', () {
      // The real exercise of the port's own reader: 5932 `d` strings, none of
      // which any human has read. A malformed one throws — the parser raises
      // on bad data rather than recovering — so this test failing is a parser
      // gap or a generator bug, never a silent wrong shape.
      //
      // MEASURED, not assumed, in `icon_paths_test.dart`'s discipline: the
      // excursion below is `getBounds()` against the 24×24 grid, so it
      // includes the cubic control points of the arc approximation and is
      // *stricter* than the drawn geometry. Across all 1756 glyphs exactly one
      // value is positive.
      int nodes = 0;
      final Map<String, double> excursions = <String, double>{};
      for (final DsLucideGlyph glyph in dsLucideByName.values) {
        nodes += glyph.nodes.length;
        final Rect b = glyph.toPath().getBounds();
        expect(b.longestSide, greaterThan(0),
            reason: '${glyph.name} drew nothing');
        excursions[glyph.name] = <double>[
          -b.left,
          -b.top,
          b.right - DsLucide.viewBox,
          b.bottom - DsLucide.viewBox,
        ].reduce((double a, double c) => a > c ? a : c);
      }
      expect(nodes, 7032);

      final List<String> outside = <String>[
        for (final MapEntry<String, double> e in excursions.entries)
          if (e.value > 0) '${e.key} by ${e.value}',
      ];
      expect(outside, <String>['save-off by 10.5'],
          reason: 'a glyph outside lucide\'s own viewBox is either a parser '
              'bug or an upstream data defect — see the test below');
      // The runner-up touches the edge and no more, so the one positive value
      // is a cliff, not the top of a slope.
      final List<double> rest = <double>[
        for (final MapEntry<String, double> e in excursions.entries)
          if (e.key != 'save-off') e.value,
      ]..sort();
      expect(rest.last, 0, reason: 'line-squiggle touches x = 24 exactly');
    });

    test('save-off is an upstream defect, reproduced deliberately', () {
      // `save-off.mjs` node 6 is `"M29.5 11.5s5 5 4 5"` — a stroke that starts
      // at x = 29.5 and runs to x = 34.5, entirely outside the `viewBox="0 0
      // 24 24"` every other node is drawn in. lucide-react 1.28.0 ships it
      // that way; a browser never shows it, because the outermost `<svg>`
      // clips to its viewport by default.
      //
      // The generator reproduces it VERBATIM, which is the correct behaviour
      // for a transcript — silently dropping or "fixing" a node would make the
      // registry disagree with its source and hide the defect. The consequence
      // for the port was a renderer decision, not a data one, and it has since
      // been taken: `DsIcon.paintGlyph` clips to the 24-grid exactly as the
      // outermost `<svg>` does, so this data stays wrong in the same way its
      // source is wrong and the port still renders what the browser renders.
      // The group at the bottom of this file pins that in rendered pixels.
      final DsLucideGlyph glyph = DsLucide.saveOff;
      expect(glyph.nodes, hasLength(7));
      expect((glyph.nodes[5] as DsIconPathElement).d, 'M29.5 11.5s5 5 4 5');
      expect(glyph.toPath().getBounds().right, 34.5);

      // The other six nodes are all on the grid, so the glyph is one bad node
      // rather than a bad glyph.
      final Path good = Path();
      for (int i = 0; i < glyph.nodes.length; i++) {
        if (i == 5) continue;
        glyph.nodes[i].addTo(good);
      }
      expect(good.getBounds().right, lessThanOrEqualTo(DsLucide.viewBox));
    });
  });

  // ─── the two primitives the curated 78 never used ────────────────────────

  group('primitives new to the generated set', () {
    test('ellipse is a real ellipse, not a circle', () {
      // 16 nodes across 15 glyphs. `database`'s lid is the canonical one:
      // ["ellipse", { cx: 12, cy: 5, rx: 9, ry: 3 }].
      final DsIconEllipseElement lid =
          dsLucideByName['database']!.nodes.first as DsIconEllipseElement;
      expect(<double>[lid.cx, lid.cy, lid.rx, lid.ry], <double>[12, 5, 9, 3]);
      // The distinguishing property: 18 wide and 6 tall, which a
      // single-radius circle element could not have expressed.
      final Path path = Path();
      lid.addTo(path);
      expect(path.getBounds(), const Rect.fromLTRB(3, 2, 21, 8));
      expect(path.computeMetrics().single.isClosed, isTrue);

      // Every ellipse in the package, and every one is genuinely non-circular
      // — so none of them could have been demoted to a circle.
      final List<DsIconEllipseElement> all = <DsIconEllipseElement>[
        for (final DsLucideGlyph g in dsLucideByName.values)
          ...g.nodes.whereType<DsIconEllipseElement>(),
      ];
      expect(all, hasLength(16));
      for (final DsIconEllipseElement e in all) {
        expect(e.rx, isNot(e.ry));
      }
    });

    test('polygon closes and polyline does not', () {
      // The two polygons are `navigation` and `navigation-2`; the six
      // polylines include `package`'s lid ridge, the one the curated set has.
      final List<String> polygons = <String>[
        for (final MapEntry<String, DsLucideGlyph> e in dsLucideByName.entries)
          if (e.value.nodes.any((DsIconElement n) => n is DsIconPolygonElement))
            e.key,
      ];
      expect(polygons, unorderedEquals(<String>['navigation', 'navigation-2']));

      final Path closed = Path();
      (dsLucideByName['navigation']!.nodes.single as DsIconPolygonElement)
          .addTo(closed);
      expect(closed.computeMetrics().single.isClosed, isTrue);

      final Path open = Path();
      (dsLucideByName['package']!.nodes[2] as DsIconPolylineElement).addTo(open);
      expect(open.computeMetrics().single.isClosed, isFalse);

      // `mailbox` is the one module whose `points` are comma-separated
      // (`"15,9 18,9 18,11"`), so it proves the generator splits on both.
      final DsIconPolylineElement mailbox = dsLucideByName['mailbox']!
          .nodes
          .whereType<DsIconPolylineElement>()
          .single;
      expect(mailbox.points, <Offset>[
        const Offset(15, 9),
        const Offset(18, 9),
        const Offset(18, 11),
      ]);
    });

    test('a rect with no `rx` takes `ry`, and with neither is square', () {
      // Four nodes in the package spell `ry` WITHOUT `rx` — which the curated
      // 78 never do, and which `icon_paths.dart` states as "lucide sets `ry`
      // only where it equals `rx`". True of the 78, not of the package.
      final DsIconRectElement rounded = dsLucideByName['arrow-down-0-1']!
          .nodes
          .whereType<DsIconRectElement>()
          .single;
      expect(<double>[rounded.x, rounded.y, rounded.width, rounded.height],
          <double>[15, 4, 4, 6]);
      // SVG's mutual-auto rule: `rx` absent takes `ry`'s value.
      expect(rounded.rx, 2);
      expect(rounded.ry, 2);

      // `spray-can` writes neither, so the corners are square.
      final DsIconRectElement square = dsLucideByName['spray-can']!
          .nodes
          .whereType<DsIconRectElement>()
          .single;
      expect(<double>[square.x, square.y, square.width, square.height],
          <double>[15, 5, 4, 4]);
      expect(square.rx, 0);
      expect(square.ry, isNull);
      final Path path = Path();
      square.addTo(path);
      expect(path.getBounds(), const Rect.fromLTRB(15, 5, 19, 9));
    });

    test('19 nodes carry `fill="currentColor"`, and toFillPath finds them', () {
      final List<String> filled = <String>[
        for (final MapEntry<String, DsLucideGlyph> e in dsLucideByName.entries)
          if (e.value.toFillPath() != null) e.key,
      ];
      // 9 glyphs, 19 nodes — `chart-scatter` carries five and `vault` four,
      // which is why the node count is more than double the glyph count.
      expect(filled, hasLength(9));
      expect(filled, contains('tag'));
      expect(filled, contains('palette'));
      expect(filled, contains('vault'));
      final int nodes = <int>[
        for (final String name in filled)
          dsLucideByName[name]!
              .nodes
              .where((DsIconElement n) => n.filled)
              .length,
      ].reduce((int a, int b) => a + b);
      expect(nodes, 19);
      // A glyph with no filled node returns null rather than an empty Path, so
      // the painter can skip the second `drawPath` outright.
      expect(dsLucideByName['menu']!.toFillPath(), isNull);
    });
  });

  // ─── names ───────────────────────────────────────────────────────────────

  group('the name index', () {
    test('resolves deprecated aliases to the module that holds the geometry',
        () {
      // The three the curated set renames, checked through the public lookup.
      expect(dsLucideAliases['filter'], 'funnel');
      expect(dsLucideAliases['help-circle'], 'circle-question-mark');
      expect(dsLucideAliases['alert-triangle'], 'triangle-alert');
      expect(dsLucideLookup('filter')!.name, 'funnel');
      expect(dsLucideLookup('loader-2')!.name, 'loader-circle');
      expect(dsLucideLookup('x-circle')!.name, 'circle-x');
      // A name lucide does not ship.
      expect(dsLucideLookup('not-an-icon'), isNull);
      // A real module resolves to itself.
      expect(dsLucideLookup('zap')!.name, 'zap');
      expect(identical(dsLucideLookup('zap'), DsLucide.zap), isTrue);
    });

    test('the identifier convention round-trips for every module', () {
      // The generator turns `circle-dollar-sign` into `circleDollarSign`. That
      // has to be collision-free across 1756 names or two glyphs would share a
      // field — and a const map with a duplicate key would not even compile,
      // so the length check above already proves it. This pins the convention
      // itself against a few shapes that could go wrong.
      expect(identical(dsLucideByName['a-arrow-down'], DsLucide.aArrowDown),
          isTrue);
      expect(identical(dsLucideByName['arrow-down-0-1'], DsLucide.arrowDown01),
          isTrue);
      expect(identical(dsLucideByName['arrow-down-1-0'], DsLucide.arrowDown10),
          isTrue);
      expect(identical(dsLucideByName['rows-3'], DsLucide.rows3), isTrue);
      expect(identical(dsLucideByName['volume-x'], DsLucide.volumeX), isTrue);
      // Four module names collide with Dart built-in identifiers. They are
      // legal as member names, so they need no mangling — asserted because a
      // future generator "fix" that renames them would break call sites.
      expect(DsLucide.factory.name, 'factory');
      expect(DsLucide.import.name, 'import');
      expect(DsLucide.library.name, 'library');
      expect(DsLucide.type.name, 'type');
    });
  });

  // ─── the shared path contract ────────────────────────────────────────────

  // ─── the renderer's half of the save-off defect ──────────────────────────

  group('the painter clips to the 24-grid, as the browser does', () {
    testWidgets('save-off\'s escaping stroke is clipped away', (
      WidgetTester t,
    ) async {
      final Path glyph = DsLucide.saveOff.toPath();

      // The control first, so the pin cannot pass vacuously: WITHOUT the clip
      // the defective node paints as far as pixel column 34 — nine columns
      // past the icon's own box, straight through whatever is laid out beside
      // it. That is the bug this clip exists for, in pixels.
      final ByteData unclipped =
          await _raster(t, (Canvas c) => _paintUnclipped(c, glyph));
      expect(_rightmostInkedColumn(unclipped), 34);

      expect(_inkedOutsideGrid(unclipped), 31);

      // With the clip, not one of those 31 pixels is drawn, and the rightmost
      // ink on the surface is back inside the icon's own box.
      final ByteData clipped = await _clipped(t, glyph);
      expect(_inkedOutsideGrid(clipped), 0);
      expect(_rightmostInkedColumn(clipped), 22);

      // …while the six good nodes are still there. What the clip costs inside
      // the grid is 21 pixels sitting at most 13/255 apart from the unclipped
      // rendering — Skia rasterising a clipped draw slightly differently, not
      // geometry going missing, which the byte-for-byte anti-assertion below
      // separates from a real loss. The bound is measured, and generous by
      // three steps.
      expect(_maxAlphaDeltaInsideGrid(clipped, unclipped),
          lessThanOrEqualTo(16));
    });

    testWidgets('a glyph inside the grid loses nothing', (
      WidgetTester t,
    ) async {
      // The anti-assertion. `at-sign` is the hand-transcribed glyph that comes
      // closest to the edge — its worst excursion is −0.9817, i.e. 0.98 units
      // INSIDE the grid, so its 2-unit stroke overhangs by 0.018 of a unit and
      // a careless clip could be seen shaving it. It is not: the clip boundary
      // falls on a pixel boundary at 24 px, and clipped and unclipped come out
      // byte for byte identical over the whole surface.
      expect(
        _differingColumns(
          await _clipped(t, DsIconPaths.pathFor(DsIconGlyph.atSign)),
          await _raster(
              t,
              (Canvas c) =>
                  _paintUnclipped(c, DsIconPaths.pathFor(DsIconGlyph.atSign))),
        ),
        isEmpty,
      );

      // `line-squiggle` is the whole package's runner-up: it touches x = 24
      // exactly and no further. Same result — the cliff between it and
      // `save-off` is real on the canvas, not only in `getBounds`.
      final Path squiggle = DsLucide.lineSquiggle.toPath();
      expect(
        _differingColumns(
          await _clipped(t, squiggle),
          await _raster(t, (Canvas c) => _paintUnclipped(c, squiggle)),
        ),
        isEmpty,
      );
    });
  });

  test('toPath returns a fresh Path every call', () {
    // The hand file's rule, restated for the generated model: [Path] is
    // mutable, so a shared instance would let one painter corrupt every icon.
    final Path first = DsLucide.zap.toPath();
    final Path second = DsLucide.zap.toPath();
    expect(identical(first, second), isFalse);
    first.lineTo(0, 0);
    expect(first.getBounds(), isNot(second.getBounds()));
  });
}
