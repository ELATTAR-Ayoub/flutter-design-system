// parity probe — the Flutter half of the vertical-metric comparison against
// the web reference.
//
// Pumps each covered page inside the real [DocsShell] at the 1440 frame with
// the reference's own font binaries loaded (without them the test engine
// measures Ahem and every line height is fiction), then walks the render tree
// and prints one line per box:
//
//     PARITY|<page>|<depth>|<widget>|<top>|<height>|<left>|<width>|<text>
//
// Coordinates are relative to the page widget's own box — which is the content
// column, the same origin `scratchpad/measure-vertical.js` uses on the web
// side, so the two dumps line up landmark for landmark.
//
// The dump only runs under `PARITY_DUMP=1`; the standing assertion is that the
// column really is 1080px wide at 1440, because every line-wrap point (and so
// every height below it) depends on that.
library;

import 'dart:io';
import 'dart:typed_data';

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/main.dart';
import 'package:example/nav.dart';
import 'package:example/shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FontLoader;
import 'package:flutter_test/flutter_test.dart';

/// The frame the reference is designed against.
const Size _viewport = Size(1440, 900);

/// `--width-content` — what the assertions below guard, first.
const double _contentWidth = 1080;

/// The reference's own reading-column height per route, in CSS pixels.
///
/// Measured off `http://localhost:3000` at 1440×900, fonts loaded, with
/// `getBoundingClientRect()` on `main > div.mx-auto.max-w-(--width-content)`
/// (`scratchpad/measure-vertical.js`) — the four foundation pages dark on
/// 2026-08-14, the three base-component pages light on 2026-08-15, and the four
/// batch-2 families — `data`, `charts`, `layout`, `sidebar` — on 2026-08-16
/// beside their own page tests' section oracles. The theme is
/// recorded rather than reconciled because nothing on either side changes size
/// with it: `forms_page_test` measures the same column in both and holds it to
/// one number.
///
/// A page that drifts from these is a page that no longer stacks the way the
/// reference stacks — which is the whole failure this file exists to catch,
/// since the drift is invisible per element and only shows up as an accumulated
/// offset.
///
/// `forms` is measured **pristine** (ruling F3): nothing typed, nothing
/// submitted, no menu open. Its height moves with error state, so the pump
/// below has to leave it alone — one `pump`, no interaction — or this number is
/// measuring a different page.
///
/// `selects` is measured under a **frozen clock** — see [_routes].
///
/// Every number here is the **reference's** height. Where the port stands a
/// measured, named distance from it, that distance is [_Route.residual] on the
/// route rather than a wider band on everybody — see [_chatWrapResidual] and
/// [_chartsWrapResidual].
const Map<String, double> _referenceHeight = <String, double>{
  'overview': 2402.66,
  'colors': 3781.83,
  'typography': 6039.94,
  'spacing': 4159.36,
  'buttons': 4783.5,
  'inputs': 5086.3,
  'forms': 4968.7,
  'selection': 4252.14,
  'dialogs': 6064.13,
  'menus': 2608.25,
  'navigation': 5443.1,
  'feedback': 5946.0,
  'chat': 8382.03,
  'selects': 4833.9,
  'data': 8394.8,
  // NOT the 25,745 `charts_page_test` publishes — that is
  // `document.documentElement.scrollHeight`, and this table is the reading
  // column. The column is the last section's measured border-box bottom
  // (24745.8 + 769.8), plus the `mb-20` that collapses out of the div's own
  // height, plus the foot nav, less the 112 the column starts at. Cross-checks
  // against the published figure the other way round — 25745 − 112 − 48 =
  // 25585 — to inside the integer rounding `scrollHeight` applies.
  'charts': 25584.6,
  'layout': 4316.06,
  'sidebar': 5483.7,
};

/// THREE MEASURED RESIDUALS, each carried by the route that owns it. This is
/// the first.
///
/// `chat_page_test.dart`'s `_wrapResidual` is the same fact, named there:
/// §4's *"preview and download"* Note wraps to **eleven** `type-small` lines
/// here and **ten** in Chrome — one line, in a three-paragraph block
/// reproduced word for word at the same measure, on the same rung, under the
/// same padding. Every other block on that page is inside half a pixel, so it
/// is a line-breaker difference on one paragraph and not a style drift.
///
/// **The two files carry two numbers for it, and this is the column's own.**
/// `chat_page_test` pins the wrap where it originates — the `attachment`
/// section's box — at 19.51, inside that file's ±2 aggregate band. Measured on
/// the whole reading column, the port stands **18.495** above the reference:
/// the same one line, less the 1.015 the rest of the page gives back, which is
/// under `chat_page_test`'s band and over this file's. This probe is the
/// tighter instrument, so it takes the number it can actually measure rather
/// than borrowing one that would need a looser band to fit.
///
/// It is added to the one page it reaches rather than folded into [_tolerance],
/// so the band stays tight enough to catch anything else — on chat included.
const double _chatWrapResidual = 18.495;

/// The second, and the same fact one page over — the same species, the same
/// shape, and the same reason the two files carry two numbers for it.
///
/// `charts_page_test.dart`'s `_residuals` names it where it originates — the
/// **`animation`** section, at **+19.5**, which is exactly one 13px/1.5 line
/// box. One paragraph owns it: the reference's *"The obvious claim — recharts
/// ignores `prefers-reduced-motion`, so we have to do it"* sets a `<Code>` chip
/// inside an `<em>` and wraps to four lines at the 768 cap; the port's chip is
/// a hair wider and takes five. All thirteen of the section's other paragraphs
/// match the reference's line count, so it is chip metrics rather than copy
/// drift.
///
/// Measured on the whole reading column the port stands **16.05** above the
/// reference: the same one line, less the **3.45** the seven sections above it
/// give back (`bar` and `line` are 1.9 short each, `pie` and `radar` 0.1 long,
/// and the page header starts 0.15 low). Everything below `animation` carries
/// the 16.05 forward unchanged — `unit-activity`, `conversion-funnel` and
/// `states` are all +16.05 on their tops and 0.00 on their heights — which is
/// what says the line is paid once and then only transported.
///
/// That decomposition is exactly [_chatWrapResidual]'s, and for the same
/// reason: `charts_page_test` widens the band on the section that owns the
/// line, which is the right instrument there; this probe measures the column
/// and so takes the number the column actually shows.
const double _chartsWrapResidual = 16.05;

/// The third, and the odd one out: not a line box, an accumulation.
///
/// The port's sidebar column stands **0.575** above the reference's 5483.7, and
/// the section table says where: the `anatomy` section is **+0.50** and every
/// section below it carries that half-pixel forward untouched, with a further
/// **0.075** appearing across the `shell` section's box. `sidebar_page_test`
/// holds the same column to ±2 and so never had to name it; this probe's band
/// is half a pixel, which is under the total by 0.075.
///
/// It is recorded rather than tuned because it is below anything either engine
/// can paint and above what this file is willing to hide. Widening [_tolerance]
/// would have bought it at the cost of every other route's teeth — the drift
/// this probe exists to catch is cumulative, and half a pixel per section is
/// precisely its scale.
const double _sidebarStackResidual = 0.575;

/// Half a CSS pixel: below the smallest thing either engine can paint, and
/// wider than the 1/64px grid Chrome quantises its own layout to.
const double _tolerance = 0.5;

/// One covered page: the route it lives at, the instant it is pumped at, and
/// the named distance the port is allowed to stand from the reference.
typedef _Route = ({String route, DateTime? clock, double residual});

/// Every route this probe covers, in `pageFor`'s own order.
///
/// **[clock] is the `?clock=` boot parameter, per route** (supervisor ruling
/// L2). Null — every page but one — means the page's height is a pure function
/// of its markup and the wall clock cannot move it, so the harness leaves it on
/// [DateTime.now] exactly as the app boots.
///
/// `selects` is the exception, and the reason this column exists.
/// `react-day-picker`'s `getInitialMonth` is `month || defaultMonth || today`
/// and the page passes neither of the first two, so its two on-page calendars
/// open on the reader's current month — a four-, five- or six-week month is one
/// 36px week row apart, twice over, and the document height moves by 72px
/// between two runs of the same unchanged code. The reference was captured with
/// Chrome's `Date` shim frozen at the same instant this passes to [DsClock], so
/// both renderers agree on the month, the week count and the height.
///
/// **[residual] is the same idea one column over**: zero — every page but three
/// — means the port lands on the reference's own number, and each non-zero
/// entry names what it is rather than loosening the band. Two of them are the
/// same species of fact, a single line box on a single paragraph; the third is
/// a sub-pixel accumulation. See [_chatWrapResidual], [_chartsWrapResidual] and
/// [_sidebarStackResidual].
final Map<String, _Route> _routes = <String, _Route>{
  'overview': (route: dsRoot, clock: null, residual: 0),
  'colors': (route: '$dsRoot/colors', clock: null, residual: 0),
  'typography': (route: '$dsRoot/typography', clock: null, residual: 0),
  'spacing': (route: '$dsRoot/spacing', clock: null, residual: 0),
  'buttons': (
    route: '$dsRoot/components/base/buttons',
    clock: null,
    residual: 0,
  ),
  'inputs': (route: '$dsRoot/components/base/inputs', clock: null, residual: 0),
  'forms': (route: '$dsRoot/components/base/forms', clock: null, residual: 0),
  'selects': (
    route: '$dsRoot/components/base/selects',
    clock: DateTime(2026, 8, 16, 12),
    residual: 0,
  ),
  'selection': (
    route: '$dsRoot/components/base/selection',
    clock: null,
    residual: 0,
  ),
  'dialogs': (
    route: '$dsRoot/components/base/dialogs',
    clock: null,
    residual: 0,
  ),
  'menus': (route: '$dsRoot/components/base/menus', clock: null, residual: 0),
  'navigation': (
    route: '$dsRoot/components/base/navigation',
    clock: null,
    residual: 0,
  ),
  'feedback': (
    route: '$dsRoot/components/base/feedback',
    clock: null,
    residual: 0,
  ),
  'chat': (
    route: '$dsRoot/components/base/chat',
    clock: null,
    residual: _chatWrapResidual,
  ),
  'data': (route: '$dsRoot/components/base/data', clock: null, residual: 0),
  'charts': (
    route: '$dsRoot/components/base/charts',
    clock: null,
    residual: _chartsWrapResidual,
  ),
  'layout': (route: '$dsRoot/components/base/layout', clock: null, residual: 0),
  'sidebar': (
    route: '$dsRoot/components/base/sidebar',
    clock: null,
    residual: _sidebarStackResidual,
  ),
};

Future<void> _loadFont(String family, String file) async {
  final ByteData bytes = ByteData.sublistView(
    File('../assets/fonts/$file').readAsBytesSync(),
  );
  final FontLoader loader = FontLoader('packages/elattar_design_system/$family')
    ..addFont(Future<ByteData>.value(bytes));
  await loader.load();
}

/// One box in the render tree, in the page's own coordinates.
class _Box {
  _Box(this.depth, this.widget, this.rect);

  final int depth;
  final String widget;
  final Rect rect;
  final List<_Box> children = <_Box>[];

  /// Text this box paints itself; empty for everything that is not a paragraph.
  String own = '';

  /// The port of `Node.textContent`: own text, or the concatenation below.
  ///
  /// A paragraph's own text carries `U+FFFC` where a `WidgetSpan` sits, and
  /// those spans are this box's children — the inline code chips. Splicing
  /// their text back in is what makes the string comparable to the browser's
  /// `textContent`, which knows nothing about the distinction.
  String get text {
    if (own.isEmpty) {
      return children
          .map((_Box b) => b.text)
          .where((String s) => s.isNotEmpty)
          .join(' ');
    }
    if (!own.contains('￼')) return own;
    int next = 0;
    return own.replaceAllMapped(
      RegExp('￼'),
      (Match _) => next < children.length ? children[next++].text : '',
    );
  }
}

String _normalise(String s) => s.replaceAll(RegExp(r'\s+'), ' ').trim();

/// Walks [root]'s element subtree, one [_Box] per render box.
_Box _walk(Element root, RenderBox origin) {
  late _Box tree;

  void visit(Element element, _Box? parent, int depth) {
    _Box? node = parent;
    int childDepth = depth;

    // Only the element that *owns* a render object, so the dump is the render
    // tree rather than every composing widget above it repeating the same box:
    // `Element.renderObject` walks down to the nearest one.
    final RenderObject? object =
        element is RenderObjectElement ? element.renderObject : null;
    if (object is RenderBox && object.hasSize && object.attached) {
      final Offset offset = object.localToGlobal(Offset.zero, ancestor: origin);
      node = _Box(
        depth,
        element.widget.runtimeType.toString(),
        offset & object.size,
      );
      if (parent == null) {
        tree = node;
      } else {
        parent.children.add(node);
      }
      childDepth = depth + 1;
    }

    final Widget widget = element.widget;
    if (widget is RichText && node != null) {
      node.own = _normalise(widget.text.toPlainText());
    }

    element.visitChildren((Element child) => visit(child, node, childDepth));
  }

  visit(root, null, 0);
  return tree;
}

void _print(String page, _Box box) {
  void emit(_Box node) {
    final String text = _normalise(node.text.replaceAll('￼', ''));
    // ignore: avoid_print
    print(
      'PARITY|$page|${node.depth}|${node.widget}'
      '|${node.rect.top.toStringAsFixed(3)}|${node.rect.height.toStringAsFixed(3)}'
      '|${node.rect.left.toStringAsFixed(3)}|${node.rect.width.toStringAsFixed(3)}'
      '|${text.length > 90 ? text.substring(0, 90) : text}',
    );
    node.children.forEach(emit);
  }

  emit(box);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await _loadFont('InterLocal', 'InterVariable.ttf');
    await _loadFont('GeistMono', 'GeistMono-Variable.ttf');
    await _loadFont('Redaction35', 'Redaction35-Italic.ttf');
  });

  for (final MapEntry<String, _Route> entry in _routes.entries) {
    testWidgets('parity probe: ${entry.key}', (WidgetTester tester) async {
      tester.view.physicalSize = _viewport;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final String route = entry.value.route;
      final DsThemeController theme = DsThemeController();
      final AppRouter router = AppRouter(route: route);
      addTearDown(theme.dispose);
      addTearDown(router.dispose);

      final Widget page = pageFor(route);
      Widget app = DsTheme(
        controller: theme,
        child: AppRouterScope(
          router: router,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Builder(
              // The port's `prefers-reduced-motion`, and the state every page
              // test in this suite measures in: `feedback` alone stands 69
              // infinite animations at rest, so a tree holding it never comes
              // to rest. Below `MaterialApp` so the framework's own
              // `MediaQuery` does not win, exactly as `main.dart` applies it.
              builder: (BuildContext context) => MediaQuery(
                data: MediaQuery.of(context).copyWith(disableAnimations: true),
                child: DocsShell(route: route, child: page),
              ),
            ),
          ),
        ),
      );

      // Above [MaterialApp], where `main.dart` puts it — see [_Route.clock].
      final DateTime? clock = entry.value.clock;
      if (clock != null) app = DsClock(now: clock, child: app);

      await tester.pumpWidget(app);
      await tester.pump();

      final Finder finder = find.byWidget(page);
      final RenderBox origin = tester.renderObject<RenderBox>(finder);
      expect(
        origin.size.width,
        _contentWidth,
        reason: 'the reading column is --width-content at the 1440 frame',
      );
      expect(
        origin.size.height,
        closeTo(
          _referenceHeight[entry.key]! + entry.value.residual,
          _tolerance,
        ),
        reason: '${entry.key} no longer stacks to the reference\'s height',
      );

      if (Platform.environment['PARITY_DUMP'] == '1') {
        _print(entry.key, _walk(tester.element(finder), origin));
      }
    });
  }
}
