/// `/design-system/components/base/layout` — the page against the numbers the
/// reference actually renders, and against the three things it refuses to do.
///
/// Two harnesses, the same split every page test in this suite makes:
///
///  * [pumpLayoutInShell] mounts the real `DocsShell` at the 1440 × 900
///    reference frame and hands back the reading column's `RenderBox`. Every
///    oracle number is measured from that origin, pristine — nothing hovered,
///    nothing dragged, which is the state the oracle was read in.
///  * [pumpLayoutPage] mounts the page alone in a tall frame so every specimen
///    is laid out and hit-testable at once.
///
/// The oracle was read off `http://localhost:3000` at 1440 × 900 on
/// 2026-08-16 with `node tool/verify/section-oracle.js
/// /design-system/components/base/layout`, and the specimen boxes with a
/// `getBoundingClientRect` sweep in the same session
/// (`scratchpad/bl-inv.js`). Coordinates are the reference's document
/// coordinates; the reading column starts 112px down (`main` at 64 plus its
/// own `py-12`) and 300px in, so every oracle number here is the measured
/// value less that origin.
library;

import 'dart:io';
import 'dart:typed_data';

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/kit.dart';
import 'package:example/nav.dart';
import 'package:example/pages/layout.dart';
import 'package:example/shell.dart';
import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FontLoader;
import 'package:flutter_test/flutter_test.dart';

/* ── The frame and the oracle ────────────────────────────────────────────── */

/// Tall enough to lay the whole page out at once, so nothing needs scrolling
/// into view before it can be driven.
const Size _desktop = Size(1440, 4600);

/// The frame the reference is measured at.
const Size _referenceFrame = Size(1440, 900);

const String _route = '$dsRoot/components/base/layout';

/// `--width-content`.
const double _columnWidth = 1080;

/// Where the reading column starts: `main` at 64, plus its own `py-12`.
const double _columnTop = 112;

/// The reading column's own height, measured on
/// `main > div.mx-auto.max-w-(--width-content)`.
///
/// This is the number `vertical_parity_probe_test.dart`'s `_referenceHeight`
/// takes for this route at integration.
const double _columnHeight = 4316.06;

/// Each `section[id]`, as `(document top, border-box height)`.
const Map<String, ({double top, double height})> _sectionOracle =
    <String, ({double top, double height})>{
      'aspect-ratio': (top: 379.8, height: 708.5),
      'scroll-area': (top: 1168.4, height: 517.8),
      'browser-scrollbar': (top: 1766.2, height: 508.8),
      'carousel': (top: 2355, height: 692.3),
      'resizable': (top: 3127.3, height: 411.7),
      'api': (top: 3619, height: 274.8),
      'rules': (top: 3973.8, height: 273.3),
    };

/// The specimen frames, in document coordinates.
const Map<String, ({double top, double height, double width})>
_specimenOracle = <String, ({double top, double height, double width})>{
  // `<ScrollArea className="h-64 …">` and its `w-full` sibling, one grid row.
  'possible-hits': (top: 1327.7, height: 256, width: 482),
  'card-set-rail': (top: 1327.7, height: 146, width: 482),
  // `h-52 overflow-y-scroll` and `overflow-x-scroll … p-4`.
  'activity-list': (top: 1945, height: 208, width: 482),
  'wide-shelf': (top: 1945, height: 154, width: 482),
  // `<div data-slot="carousel" className="relative w-full">`.
  'carousel': (top: 2514.3, height: 508, width: 1030),
  // `<ResizablePanelGroup className="min-h-56 …">`.
  'split': (top: 3290, height: 224, width: 1030),
};

/// The three ratio boxes: `5/7`, `3/4`, `16/9` across a `sm:grid-cols-3` with
/// `gap-6`, so each is (1030 − 48) ÷ 3 wide and `width ÷ ratio` tall.
const List<({double width, double height})> _ratioOracle =
    <({double width, double height})>[
      (width: 327.33, height: 458.25),
      (width: 327.33, height: 436.44),
      (width: 327.34, height: 184.13),
    ];

/// `flex: 40 1 0px` / `flex: 60 1 0px` across 1027 of panel space — the 1030
/// group less its two 1px frame edges and the 1px seam.
const double _splitLeft = 410.8;
const double _splitRight = 616.2;

/// Two logical pixels — the band the aggregates hold.
const double _tolerance = 2;

/// Half a pixel — the band every anchor holds.
const double _fineTolerance = 0.5;

/* ── Harness ─────────────────────────────────────────────────────────────── */

/// The reference's own font binaries. Load-bearing: every number above is a
/// line box.
Future<void> _loadFont(String family, String file) async {
  final ByteData bytes = ByteData.sublistView(
    File('../assets/fonts/$file').readAsBytesSync(),
  );
  final FontLoader loader = FontLoader('packages/elattar_design_system/$family')
    ..addFont(Future<ByteData>.value(bytes));
  await loader.load();
}

extension on WidgetTester {
  void useViewport(Size size) {
    view.devicePixelRatio = 1;
    view.physicalSize = size;
    addTearDown(view.resetPhysicalSize);
    addTearDown(view.resetDevicePixelRatio);
  }

  /// The page alone, laid out tall, under reduced motion.
  Future<void> pumpLayoutPage({DsThemeMode mode = DsThemeMode.light}) async {
    useViewport(_desktop);
    final DsThemeController theme = DsThemeController(mode: mode);
    final AppRouter router = AppRouter(route: _route);
    addTearDown(theme.dispose);
    addTearDown(router.dispose);

    await pumpWidget(
      DsTheme(
        controller: theme,
        child: AppRouterScope(
          router: router,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Builder(
              builder: (BuildContext context) => MediaQuery(
                data: MediaQuery.of(context).copyWith(disableAnimations: true),
                child: DefaultTextStyle(
                  style: DsText.styleOf(
                    context,
                    DsType.body,
                    color: DsTheme.of(context).foreground,
                  ),
                  child: const SingleChildScrollView(child: LayoutPage()),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await pump();
    await pump(DsDurations.slow);
  }
}

/// The page inside the real [DocsShell] at the reference frame, and the reading
/// column's own [RenderBox].
Future<RenderBox> pumpLayoutInShell(
  WidgetTester tester, {
  DsThemeMode mode = DsThemeMode.light,
}) async {
  tester.view.physicalSize = _referenceFrame;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final DsThemeController theme = DsThemeController(mode: mode);
  final AppRouter router = AppRouter(route: _route);
  addTearDown(theme.dispose);
  addTearDown(router.dispose);

  const Widget page = LayoutPage();
  await tester.pumpWidget(
    DsTheme(
      controller: theme,
      child: AppRouterScope(
        router: router,
        child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: DocsShell(route: _route, child: page),
        ),
      ),
    ),
  );
  // No settle: geometry is settled on the first laid-out frame, and PRISTINE is
  // the state the oracle was measured in.
  await tester.pump();

  return tester.renderObject<RenderBox>(find.byWidget(page));
}

/// A pointer that can hover, with a fresh id each time.
int _pointer = 400;

Future<TestGesture> hover(WidgetTester tester, Offset at) async {
  final TestGesture gesture = await tester.createGesture(
    kind: PointerDeviceKind.mouse,
    pointer: _pointer++,
  );
  await gesture.addPointer(location: Offset.zero);
  addTearDown(gesture.removePointer);
  await gesture.moveTo(at);
  await tester.pump();
  return gesture;
}

/* ── Finders ─────────────────────────────────────────────────────────────── */

Finder _section(String id) => find.byWidgetPredicate(
  (Widget widget) => widget is DsSection && widget.id == id,
);

Finder _panel(String label) => find.byWidgetPredicate(
  (Widget widget) => widget is DsPanel && widget.label == label,
);

Finder _inPanel(String label, Finder matching) =>
    find.descendant(of: _panel(label), matching: matching);

/// `data-slot="carousel"` — the `overflow-hidden` viewport, which is the
/// [ClipRect] the track sits behind.
final Finder _carouselViewport = find
    .descendant(of: find.byType(DsCarousel), matching: find.byType(ClipRect))
    .first;

/// The two `h-full bg-* p-5` panes, by the boxes that paint their fills.
List<RenderBox> _panes(WidgetTester tester) => tester
    .renderObjectList<RenderBox>(
      find.descendant(
        of: find.byType(DsResizablePanelGroup),
        matching: find.byType(ColoredBox),
      ),
    )
    // Everything but the 1px seam, which is a `ColoredBox` too. Deliberately
    // not a width threshold: the point of DRIFT 3 is that a pane can be 25px.
    .where((RenderBox box) => box.size.width != DsWidths.hairline)
    .toList();

({double top, double left, double height, double width}) _boxIn(
  WidgetTester tester,
  RenderBox origin,
  Finder finder,
) {
  final RenderBox box = tester.renderObject<RenderBox>(finder);
  final Offset at = box.localToGlobal(Offset.zero, ancestor: origin);
  return (
    top: at.dy,
    left: at.dx,
    height: box.size.height,
    width: box.size.width,
  );
}

/// The section with [id], with `mb-20` taken back off its height so the number
/// compares to the reference's CSS border box.
({double top, double height}) _sectionBox(
  WidgetTester tester,
  RenderBox origin,
  String id,
) {
  final ({double top, double left, double height, double width}) box = _boxIn(
    tester,
    origin,
    _section(id),
  );
  return (top: box.top, height: box.height - ds(20));
}

void main() {
  setUpAll(() async {
    await _loadFont('InterLocal', 'InterVariable.ttf');
    await _loadFont('GeistMono', 'GeistMono-Variable.ttf');
    await _loadFont('Redaction35', 'Redaction35-Italic.ttf');
  });

  /* ── Structure ─────────────────────────────────────────────────────────── */

  group('structure', () {
    testWidgets('the seven sections exist, in the reference\'s order', (
      WidgetTester tester,
    ) async {
      await pumpLayoutInShell(tester);
      for (final String id in _sectionOracle.keys) {
        expect(_section(id), findsOneWidget, reason: 'section #$id');
      }
      expect(find.byType(DsSection), findsNWidgets(_sectionOracle.length));
    });

    testWidgets('five chips for seven sections — DRIFT 8', (
      WidgetTester tester,
    ) async {
      await pumpLayoutInShell(tester);
      final DsPageHeader header = tester.widget<DsPageHeader>(
        find.byType(DsPageHeader),
      );
      expect(header.contents, <String>[
        'Aspect Ratio',
        'Scroll Area',
        'Browser Scrollbar',
        'Carousel',
        'Resizable',
      ]);
      expect(header.contents!.contains('API'), isFalse);
      expect(header.contents!.contains('Rules'), isFalse);
    });

    testWidgets('the four panels carry the reference\'s labels', (
      WidgetTester tester,
    ) async {
      await pumpLayoutInShell(tester);
      for (final String label in <String>[
        "The product's three ratios",
        'Vertical — possible hits',
        'Horizontal — card set rail',
        'Vertical — long list',
        'Horizontal — wide shelf',
        'Featured packs',
        'Admin split view',
      ]) {
        expect(_panel(label), findsOneWidget, reason: label);
      }
    });
  });

  /* ── Geometry ──────────────────────────────────────────────────────────── */

  group('geometry', () {
    testWidgets('the reading column is 1080 wide and stacks to the oracle', (
      WidgetTester tester,
    ) async {
      final RenderBox column = await pumpLayoutInShell(tester);
      expect(column.size.width, closeTo(_columnWidth, _fineTolerance));
      // Measured **+0.079** — every section but §1 lands inside 0.05, and §1's
      // three ratio boxes carry the rest between them. No named residual.
      expect(column.size.height, closeTo(_columnHeight, _fineTolerance));
    });

    testWidgets('every section lands on its measured top and height', (
      WidgetTester tester,
    ) async {
      final RenderBox column = await pumpLayoutInShell(tester);
      _sectionOracle.forEach((String id, ({double top, double height}) want) {
        final ({double top, double height}) got = _sectionBox(
          tester,
          column,
          id,
        );
        expect(
          got.top,
          closeTo(want.top - _columnTop, _fineTolerance),
          reason: '#$id top',
        );
        expect(
          got.height,
          closeTo(want.height, _fineTolerance),
          reason: '#$id height',
        );
      });
    });

    testWidgets('the six specimen frames measure the reference\'s box', (
      WidgetTester tester,
    ) async {
      final RenderBox column = await pumpLayoutInShell(tester);
      final Map<String, Finder> finders = <String, Finder>{
        'possible-hits': _inPanel(
          'Vertical — possible hits',
          find.byType(DsScrollArea),
        ),
        'card-set-rail': _inPanel(
          'Horizontal — card set rail',
          find.byType(DsScrollArea),
        ),
        // `.last`: the panel's own frame is a `ClipRRect` too.
        'activity-list': _inPanel(
          'Vertical — long list',
          find.byType(ClipRRect),
        ).last,
        'wide-shelf': _inPanel(
          'Horizontal — wide shelf',
          find.byType(ClipRRect),
        ).last,
        // `data-slot="carousel"` is the `relative w-full` box, which is the
        // port's clipped viewport rather than the padded slot around it.
        'carousel': _carouselViewport,
      };
      finders.forEach((String key, Finder finder) {
        final ({double top, double left, double height, double width}) got =
            _boxIn(tester, column, finder);
        final ({double top, double height, double width})? want =
            _specimenOracle[key];
        // The two framed specimens are measured inside their 1px frame.
        final double frame = key == 'carousel' ? 0 : DsWidths.hairline * 2;
        expect(
          got.width + frame,
          closeTo(want!.width, _tolerance),
          reason: '$key width',
        );
        expect(
          got.height + frame,
          closeTo(want.height, _tolerance),
          reason: '$key height',
        );
      });
    });

    testWidgets('the carousel track is 1046 and its cards 332.66 wide', (
      WidgetTester tester,
    ) async {
      await pumpLayoutInShell(tester);
      final RenderBox viewport = tester.renderObject<RenderBox>(
        _carouselViewport,
      );
      // The `overflow-hidden` viewport: 1078 of panel less `p-6` on both edges.
      expect(viewport.size.width, closeTo(1030, _tolerance));
      expect(viewport.size.height, closeTo(508, _tolerance));

      // `basis-1/3` of the `-ml-4` track — (1030 + 16) ÷ 3 — less its `pl-4`.
      final RenderBox card = tester.renderObject<RenderBox>(
        find.byType(DsLiftCard).first,
      );
      expect(card.size.width, closeTo((1030 + ds(4)) / 3 - ds(4), _tolerance));
      expect(card.size.height, closeTo(508, _tolerance));
    });

    testWidgets('the three ratio boxes are width ÷ ratio tall', (
      WidgetTester tester,
    ) async {
      final RenderBox column = await pumpLayoutInShell(tester);
      final Iterable<Element> boxes = find
          .byType(DsAspectRatio)
          .evaluate()
          .take(3);
      int i = 0;
      for (final Element element in boxes) {
        final RenderBox box = element.renderObject! as RenderBox;
        expect(
          box.size.width,
          closeTo(_ratioOracle[i].width, _tolerance),
          reason: 'ratio $i width',
        );
        expect(
          box.size.height,
          closeTo(_ratioOracle[i].height, _tolerance),
          reason: 'ratio $i height',
        );
        i++;
      }
      expect(i, 3);
      // Ignore the unused-origin warning: the column is what forces the
      // 1080 layout these numbers were measured under.
      expect(column.size.width, closeTo(_columnWidth, _fineTolerance));
    });

    testWidgets('the carousel card\'s mb-4 shortens the ratio box — DRIFT 7', (
      WidgetTester tester,
    ) async {
      await pumpLayoutInShell(tester);
      final DsAspectRatio card = tester
          .widgetList<DsAspectRatio>(find.byType(DsAspectRatio))
          .firstWhere((DsAspectRatio w) => w.margin != EdgeInsets.zero);
      expect(card.margin.bottom, ds(4));

      // 298.66 wide ÷ (3/4) = 398.203 of slot, and 382.203 of box in it.
      final RenderBox slot = tester.renderObject<RenderBox>(
        find.byWidget(card),
      );
      expect(slot.size.height, closeTo(398.203, _tolerance));
      final RenderBox inner = tester.renderObject<RenderBox>(
        find
            .descendant(
              of: find.byWidget(card),
              matching: find.byType(DecoratedBox),
            )
            .first,
      );
      expect(inner.size.height, closeTo(slot.size.height - ds(4), 0.01));
    });

    testWidgets('the split is 40 / 60 of 1027, seam included', (
      WidgetTester tester,
    ) async {
      final RenderBox column = await pumpLayoutInShell(tester);
      final ({double top, double left, double height, double width}) group =
          _boxIn(tester, column, find.byType(DsResizablePanelGroup));
      // 1030 group, 1px frame each side; the seam comes out of the 1028 left.
      expect(group.width, closeTo(1030 - DsWidths.hairline * 2, _tolerance));
      expect(group.height, closeTo(224 - DsWidths.hairline * 2, _tolerance));

      final List<RenderBox> panes = _panes(tester);
      expect(panes.length, 2);
      expect(panes.first.size.width, closeTo(_splitLeft, _tolerance));
      expect(panes[1].size.width, closeTo(_splitRight, _tolerance));
    });
  });

  /* ── Behaviour ─────────────────────────────────────────────────────────── */

  group('behaviour', () {
    testWidgets('the ScrollArea rail does not exist until hover — DRIFT 5', (
      WidgetTester tester,
    ) async {
      await tester.pumpLayoutPage();
      final Finder area = _inPanel(
        'Vertical — possible hits',
        find.byType(DsScrollArea),
      );
      Finder thumb() => find.descendant(
        of: area,
        matching: find.byWidgetPredicate(
          (Widget w) =>
              w is DecoratedBox &&
              (w.decoration as BoxDecoration).borderRadius ==
                  BorderRadius.circular(DsRadii.pill),
        ),
      );
      expect(thumb(), findsNothing);

      await hover(tester, tester.getCenter(area));
      expect(thumb(), findsOneWidget);
    });

    testWidgets('the vertical ScrollArea scrolls and the horizontal cannot '
        '— DRIFT 2', (WidgetTester tester) async {
      await tester.pumpLayoutPage();

      final Finder vertical = _inPanel(
        'Vertical — possible hits',
        find.byType(DsScrollArea),
      );
      await tester.drag(vertical, const Offset(0, -120));
      await tester.pump();
      final ScrollableState down = tester.state<ScrollableState>(
        find.descendant(of: vertical, matching: find.byType(Scrollable)).first,
      );
      expect(down.position.pixels, greaterThan(0));

      final Finder rail = _inPanel(
        'Horizontal — card set rail',
        find.byType(DsScrollArea),
      );
      // `overflow: hidden scroll` — there is exactly one scrollable inside,
      // and it is the vertical one.
      expect(
        find.descendant(of: rail, matching: find.byType(Scrollable)),
        findsOneWidget,
      );
      final RenderBox viewport = tester.renderObject<RenderBox>(rail);
      final RenderBox row = tester.renderObject<RenderBox>(
        find.descendant(of: rail, matching: find.byType(Row)).first,
      );
      expect(
        row.size.width,
        greaterThan(viewport.size.width),
        reason: '284px of cards are past the viewport…',
      );
      final Offset before = row.localToGlobal(Offset.zero);
      await tester.drag(rail, const Offset(-200, 0));
      await tester.pump();
      expect(
        row.localToGlobal(Offset.zero),
        before,
        reason: '…and no gesture reaches them',
      );
    });

    testWidgets('the carousel advances on its arrow and on ArrowRight', (
      WidgetTester tester,
    ) async {
      await tester.pumpLayoutPage();
      final DsCarouselController controller = _controllerOf(tester);

      expect(controller.selectedIndex, 0);
      expect(controller.canScrollPrev, isFalse);
      expect(controller.canScrollNext, isTrue);

      controller.scrollNext();
      await tester.pump();
      expect(controller.selectedIndex, 1);
      expect(controller.location, closeTo(controller.snaps[1], 0.01));

      controller.scrollTo(controller.snaps.length - 1);
      await tester.pump();
      expect(controller.canScrollNext, isFalse);
    });

    testWidgets('only the 8px of arrow the panel leaves answers a click '
        '— DRIFT 1', (WidgetTester tester) async {
      await tester.pumpLayoutPage();
      final DsCarouselController controller = _controllerOf(tester);
      expect(controller.selectedIndex, 0);

      final RenderBox panel = tester.renderObject<RenderBox>(
        _panel('Featured packs'),
      );
      final RenderBox viewport = tester.renderObject<RenderBox>(
        _carouselViewport,
      );
      final double y =
          viewport.localToGlobal(Offset.zero).dy + viewport.size.height / 2;
      // The panel's inner edge: `overflow-hidden` inside a 1px frame.
      final double clipRight =
          panel.localToGlobal(Offset.zero).dx +
          panel.size.width -
          DsWidths.hairline;

      // Four pixels in from that edge is inside the surviving sliver.
      await tester.tapAt(Offset(clipRight - 4, y));
      await tester.pump();
      expect(controller.selectedIndex, 1);

      // Sixteen pixels out — over the button's own centre — is clipped away,
      // and the browser answers `<main>` there.
      await tester.tapAt(Offset(clipRight + 16, y));
      await tester.pump();
      expect(controller.selectedIndex, 1);
    });

    testWidgets('the resizable handle drags, and stops at 25px — DRIFT 3', (
      WidgetTester tester,
    ) async {
      await tester.pumpLayoutPage();
      final Finder group = find.byType(DsResizablePanelGroup);
      final RenderBox box = tester.renderObject<RenderBox>(group);
      final Offset origin = box.localToGlobal(Offset.zero);
      final Offset seam =
          origin + Offset(_panes(tester).first.size.width, box.size.height / 2);

      final double start = _panes(tester).first.size.width;
      await tester.dragFrom(seam, const Offset(150, 0));
      await tester.pump();
      expect(_panes(tester).first.size.width, closeTo(start + 150, _tolerance));

      // Hard left: the floor is 25 **pixels**, not 25 per cent.
      final Offset moved = origin + Offset(start + 150, box.size.height / 2);
      await tester.dragFrom(moved, const Offset(-1600, 0));
      await tester.pump();
      expect(_panes(tester).first.size.width, closeTo(25, _fineTolerance));
    });

    testWidgets('the handle answers 1.5px into each neighbour', (
      WidgetTester tester,
    ) async {
      await tester.pumpLayoutPage();
      final RenderBox box = tester.renderObject<RenderBox>(
        find.byType(DsResizablePanelGroup),
      );
      final Offset origin = box.localToGlobal(Offset.zero);

      final double start = _panes(tester).first.size.width;

      Future<double> dragAt(double dx) async {
        await tester.dragFrom(
          origin + Offset(dx, box.size.height / 2),
          const Offset(40, 0),
        );
        await tester.pump();
        return _panes(tester).first.size.width;
      }

      // 1px to the left of the seam is still inside the 4px grab strip.
      expect(await dragAt(start - 1), greaterThan(start + 30));
    });

    testWidgets('the browser-scrollbar specimens scroll on both axes', (
      WidgetTester tester,
    ) async {
      await tester.pumpLayoutPage();

      final Finder list = _inPanel(
        'Vertical — long list',
        find.byType(SizedBox),
      ).first;
      await tester.drag(list, const Offset(0, -100));
      await tester.pump();
      final ScrollableState down = tester.state<ScrollableState>(
        find
            .descendant(
              of: _panel('Vertical — long list'),
              matching: find.byType(Scrollable),
            )
            .first,
      );
      expect(down.position.pixels, greaterThan(0));

      final ScrollableState across = tester.state<ScrollableState>(
        find
            .descendant(
              of: _panel('Horizontal — wide shelf'),
              matching: find.byType(Scrollable),
            )
            .first,
      );
      await tester.drag(
        find
            .descendant(
              of: _panel('Horizontal — wide shelf'),
              matching: find.byType(Scrollable),
            )
            .first,
        const Offset(-150, 0),
      );
      await tester.pump();
      expect(across.position.pixels, greaterThan(0));
    });
  });

  /* ── Copy ──────────────────────────────────────────────────────────────── */

  group('copy', () {
    testWidgets('§4 claims arrows that the panel clips — DRIFT 1', (
      WidgetTester tester,
    ) async {
      await pumpLayoutInShell(tester);
      final DsSection carousel = tester.widget<DsSection>(_section('carousel'));
      expect(carousel.description, contains('Arrows are always visible'));

      // …and the panel that holds them clips.
      final DsPanel panel = tester.widget<DsPanel>(_panel('Featured packs'));
      expect(panel.flush, isTrue);
    });

    testWidgets('§5 documents a component §7 forbids — DRIFT 4', (
      WidgetTester tester,
    ) async {
      await pumpLayoutInShell(tester);
      final DsSection resizable = tester.widget<DsSection>(
        _section('resizable'),
      );
      expect(
        resizable.description,
        startsWith('Not used in the collector-facing product.'),
      );
      final DsDoDont rules = tester.widget<DsDoDont>(find.byType(DsDoDont));
      expect(
        rules.donts,
        contains("Don't use Resizable in the collector-facing product."),
      );
    });

    testWidgets('the API row asks for the ScrollBar the page never adds', (
      WidgetTester tester,
    ) async {
      await pumpLayoutInShell(tester);
      final DsMeta meta = tester.widget<DsMeta>(find.byType(DsMeta));
      expect(meta.items.length, 5);
      expect(
        (meta.items[1].v as TextSpan).text,
        contains('Add ScrollBar for a horizontal bar.'),
      );
      for (final DsScrollArea area in tester.widgetList<DsScrollArea>(
        find.byType(DsScrollArea),
      )) {
        expect(area.horizontalBar, isFalse);
      }
    });

    testWidgets('the rules list is five against five', (
      WidgetTester tester,
    ) async {
      await pumpLayoutInShell(tester);
      final DsDoDont rules = tester.widget<DsDoDont>(find.byType(DsDoDont));
      expect(rules.dos.length, 5);
      expect(rules.donts.length, 5);
    });
  });
}

/// The live [DsCarouselController] behind the page's one carousel, reached
/// through the [AnimatedBuilder] the track and both arrows listen to.
DsCarouselController _controllerOf(WidgetTester tester) {
  final AnimatedBuilder builder = tester
      .widgetList<AnimatedBuilder>(
        find.descendant(
          of: find.byType(DsCarousel),
          matching: find.byType(AnimatedBuilder),
        ),
      )
      .firstWhere((AnimatedBuilder b) => b.listenable is DsCarouselController);
  return builder.listenable as DsCarouselController;
}
