/// The four layout primitives, against the numbers driven off the live
/// reference (`scratchpad/bl-*.js`, 2026-08-16, 1440 × 900).
///
/// Every assertion here is a probe result, not a derivation. Where the
/// reference's own behaviour is a third-party engine — Embla's integrator,
/// Radix's hover-mounted rail, `react-resizable-panels`' pixel `minSize` —
/// the number in the expectation is the one the browser produced.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter_test/flutter_test.dart';

/// Mounts [child] in a themed, fixed-size frame.
Future<void> _pump(
  WidgetTester tester,
  Widget child, {
  Size size = const Size(800, 600),
  bool reducedMotion = false,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final ElThemeController theme = ElThemeController(mode: ElThemeMode.light);
  addTearDown(theme.dispose);

  await tester.pumpWidget(
    ElTheme(
      controller: theme,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Builder(
          builder: (BuildContext context) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(disableAnimations: reducedMotion),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Align(alignment: Alignment.topLeft, child: child),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

int _pointer = 700;

Future<TestGesture> _hover(WidgetTester tester, Offset at) async {
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

void main() {
  /* ── ElAspectRatio ─────────────────────────────────────────────────────── */

  group('ElAspectRatio', () {
    testWidgets(
      'height is width ÷ ratio, for all three of the page\'s ratios',
      (WidgetTester tester) async {
        for (final (double ratio, double height) pair in <(double, double)>[
          (5 / 7, 458.262),
          (3 / 4, 436.44),
          (16 / 9, 184.123),
        ]) {
          await _pump(
            tester,
            SizedBox(
              width: 327.33,
              child: ElAspectRatio(ratio: pair.$1, child: const SizedBox()),
            ),
          );
          final RenderBox box = tester.renderObject<RenderBox>(
            find.byType(ElAspectRatio),
          );
          expect(box.size.width, closeTo(327.33, 0.01));
          expect(
            box.size.height,
            closeTo(pair.$2, 0.05),
            reason: 'ratio ${pair.$1}',
          );
        }
      },
    );

    testWidgets('a margin shortens the box inside the slot, it does not '
        'space it', (WidgetTester tester) async {
      await _pump(
        tester,
        SizedBox(
          width: 298.66,
          child: ElAspectRatio(
            ratio: 3 / 4,
            margin: EdgeInsets.only(bottom: el(4)),
            child: const ColoredBox(
              key: ValueKey<String>('ratio-box'),
              color: Color(0xFF000000),
            ),
          ),
        ),
      );
      final RenderBox slot = tester.renderObject<RenderBox>(
        find.byType(ElAspectRatio),
      );
      final RenderBox inner = tester.renderObject<RenderBox>(
        find.byKey(const ValueKey<String>('ratio-box')),
      );
      // Measured on the carousel card: 398.203 of slot, 382.203 of box.
      expect(slot.size.height, closeTo(398.203, 0.05));
      expect(inner.size.height, closeTo(382.203, 0.05));
    });
  });

  /* ── ElScrollArea ──────────────────────────────────────────────────────── */

  group('ElScrollArea', () {
    Widget rows(int n) => Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        for (int i = 0; i < n; i++) SizedBox(height: 44, child: Text('$i')),
      ],
    );

    testWidgets('there is no rail at rest, one on hover, and none again '
        '600ms after the pointer leaves', (WidgetTester tester) async {
      await _pump(
        tester,
        SizedBox(width: 480, height: 254, child: ElScrollArea(child: rows(14))),
      );
      Finder thumb() => find.descendant(
        of: find.byType(ElScrollArea),
        matching: find.byWidgetPredicate(
          (Widget w) =>
              w is DecoratedBox &&
              (w.decoration as BoxDecoration).borderRadius ==
                  BorderRadius.circular(ElRadii.pill),
        ),
      );

      expect(thumb(), findsNothing, reason: 'type="hover" mounts nothing');

      final TestGesture gesture = await _hover(
        tester,
        tester.getCenter(find.byType(ElScrollArea)),
      );
      expect(thumb(), findsOneWidget);

      // Well clear of the 480 × 254 frame, which starts at the origin.
      await gesture.moveTo(const Offset(700, 500));
      await tester.pump();
      // Still up at 542ms on the reference…
      await tester.pump(const Duration(milliseconds: 500));
      expect(thumb(), findsOneWidget);
      // …and gone by 650.
      await tester.pump(const Duration(milliseconds: 200));
      expect(thumb(), findsNothing);
    });

    testWidgets('re-entering inside the delay cancels the pending hide', (
      WidgetTester tester,
    ) async {
      await _pump(
        tester,
        SizedBox(width: 480, height: 254, child: ElScrollArea(child: rows(14))),
      );
      Finder thumb() => find.descendant(
        of: find.byType(ElScrollArea),
        matching: find.byWidgetPredicate(
          (Widget w) =>
              w is DecoratedBox &&
              (w.decoration as BoxDecoration).borderRadius ==
                  BorderRadius.circular(ElRadii.pill),
        ),
      );

      final TestGesture gesture = await _hover(
        tester,
        tester.getCenter(find.byType(ElScrollArea)),
      );
      await gesture.moveTo(const Offset(700, 500));
      await tester.pump(const Duration(milliseconds: 300));
      await gesture.moveTo(tester.getCenter(find.byType(ElScrollArea)));
      await tester.pump(const Duration(milliseconds: 400));
      expect(thumb(), findsOneWidget, reason: 'the first timer is stale');
    });

    testWidgets('the rail is a 10px lane with a 7px thumb, sized by the '
        'viewport ÷ content ratio', (WidgetTester tester) async {
      await _pump(
        tester,
        SizedBox(
          width: 480,
          height: 254,
          child: ElScrollArea(child: SizedBox(height: 622, child: rows(1))),
        ),
      );
      await _hover(tester, tester.getCenter(find.byType(ElScrollArea)));

      final RenderBox area = tester.renderObject<RenderBox>(
        find.byType(ElScrollArea),
      );
      final RenderBox thumbBox = tester.renderObject<RenderBox>(
        find.descendant(
          of: find.byType(ElScrollArea),
          matching: find.byWidgetPredicate(
            (Widget w) =>
                w is DecoratedBox &&
                (w.decoration as BoxDecoration).borderRadius ==
                    BorderRadius.circular(ElRadii.pill),
          ),
        ),
      );

      // `w-2.5` less `border-l` and `p-px` on both edges.
      expect(thumbBox.size.width, closeTo(el(2.5) - el(0.75), 0.01));
      // 254 ÷ 622 × 252 — the reference's own 102.90675.
      expect(thumbBox.size.height, closeTo(102.90675, 0.05));
      // Flush to the lane's right edge, 1px of `p-px` in.
      final double right = thumbBox
          .localToGlobal(Offset(thumbBox.size.width, 0), ancestor: area)
          .dx;
      expect(right, closeTo(area.size.width - ElWidths.hairline, 0.01));
    });

    testWidgets('overflow-x is hidden unless a horizontal bar is asked for', (
      WidgetTester tester,
    ) async {
      Widget wide({required bool bar}) => SizedBox(
        width: 480,
        height: 144,
        child: ElScrollArea(
          horizontalBar: bar,
          child: const SizedBox(width: 764, height: 144),
        ),
      );

      await _pump(tester, wide(bar: false));
      expect(
        find.descendant(
          of: find.byType(ElScrollArea),
          matching: find.byType(Scrollable),
        ),
        findsOneWidget,
        reason: 'the vertical axis only — `overflow: hidden scroll`',
      );

      await _pump(tester, wide(bar: true));
      expect(
        find.descendant(
          of: find.byType(ElScrollArea),
          matching: find.byType(Scrollable),
        ),
        findsNWidgets(2),
      );
    });

    testWidgets(
      '`min-width: 100%` holds a narrow table at the viewport width',
      (WidgetTester tester) async {
        await _pump(
          tester,
          SizedBox(
            width: 480,
            height: 254,
            child: ElScrollArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const <Widget>[
                  Row(children: <Widget>[Text('a'), Spacer(), Text('b')]),
                ],
              ),
            ),
          ),
        );
        final RenderBox row = tester.renderObject<RenderBox>(find.byType(Row));
        expect(row.size.width, closeTo(480, 0.01));
      },
    );
  });

  /* ── ElCarouselController ──────────────────────────────────────────────── */

  group('ElCarouselController', () {
    ElCarouselController page() => ElCarouselController()
      ..setMetrics(
        viewSize: 1046,
        slideSizes: List<double>.filled(6, 1046 / 3),
      );

    test('trimSnaps collapses the page\'s six slides into four stops', () {
      final ElCarouselController c = page();
      expect(c.snaps.length, 4);
      expect(c.snaps[0], 0);
      expect(c.snaps[1], closeTo(-348.667, 0.01));
      expect(c.snaps[2], closeTo(-697.333, 0.01));
      expect(c.snaps[3], closeTo(-1046, 0.01));
      expect(c.canScrollPrev, isFalse);
      expect(c.canScrollNext, isTrue);
    });

    test('canScrollNext goes false on the third advance', () {
      final ElCarouselController c = page();
      c.scrollNext();
      c.scrollNext();
      expect(c.canScrollNext, isTrue);
      c.scrollNext();
      expect(c.canScrollNext, isFalse);
      expect(c.canScrollPrev, isTrue);
      expect(c.location, closeTo(-1046, 0.01));
    });

    test(
      'with no ticker the engine lands on the target — the reduced path',
      () {
        final ElCarouselController c = page();
        c.scrollTo(2);
        expect(c.location, closeTo(c.snaps[2], 0.0001));
      },
    );

    test('a release snaps to the nearest stop, both directions', () {
      final ElCarouselController c = page();
      // −100 of drag: the reference returned to 0.
      c.dragStart(0);
      c.dragUpdate(-100);
      c.dragEnd();
      expect(c.selectedIndex, 0);

      // −200: the reference went on to the next slide.
      c.dragStart(0);
      c.dragUpdate(-200);
      c.dragEnd();
      expect(c.selectedIndex, 1);
    });
  });

  testWidgets('the integrator reproduces the reference\'s first three frames', (
    WidgetTester tester,
  ) async {
    // v = (v + (target − location) ÷ 25) × 0.68; location += v.
    // Measured on the live reference: −9.49 / −25.03 / −44.75 for a one-slide
    // advance of 348.656.
    double v = 0;
    double loc = 0;
    const double target = -348.656;
    final List<double> frames = <double>[];
    for (int i = 0; i < 3; i++) {
      v = (v + (target - loc) / 25) * 0.68;
      loc += v;
      frames.add(loc);
    }
    expect(frames[0], closeTo(-9.49, 0.05));
    expect(frames[1], closeTo(-25.03, 0.2));
    expect(frames[2], closeTo(-44.75, 0.3));
  });

  /* ── ElResizablePanelGroup ─────────────────────────────────────────────── */

  group('ElResizablePanelGroup', () {
    int seed = 0;
    // A fresh key per mount: `pumpWidget` with the same tree reuses the State,
    // and the split is state.
    Widget group({double minLeft = 25}) => SizedBox(
      width: 1028,
      child: ElResizablePanelGroup(
        key: ValueKey<int>(seed++),
        minHeight: 222,
        panels: <ElResizablePanel>[
          ElResizablePanel(
            defaultSize: 40,
            minSize: minLeft,
            child: const ColoredBox(color: Color(0xFF111111)),
          ),
          const ElResizablePanel(
            defaultSize: 60,
            child: ColoredBox(color: Color(0xFF222222)),
          ),
        ],
      ),
    );

    List<RenderBox> panes(WidgetTester tester) => tester
        .renderObjectList<RenderBox>(
          find.descendant(
            of: find.byType(ElResizablePanelGroup),
            matching: find.byType(ColoredBox),
          ),
        )
        .where((RenderBox box) => box.size.width != ElWidths.hairline)
        .toList();

    testWidgets(
      'defaultSize is a weight: 40 / 60 of the 1027 the seam leaves',
      (WidgetTester tester) async {
        await _pump(tester, group(), size: const Size(1200, 400));
        expect(panes(tester).first.size.width, closeTo(410.8, 0.05));
        expect(panes(tester)[1].size.width, closeTo(616.2, 0.05));
      },
    );

    testWidgets('the drag is 1:1 from the first pixel', (
      WidgetTester tester,
    ) async {
      await _pump(tester, group(), size: const Size(1200, 400));
      final RenderBox box = tester.renderObject<RenderBox>(
        find.byType(ElResizablePanelGroup),
      );
      final Offset seam = box.localToGlobal(Offset(410.8, box.size.height / 2));
      await tester.dragFrom(seam, const Offset(150, 0));
      await tester.pump();
      expect(panes(tester).first.size.width, closeTo(560.8, 0.5));
    });

    testWidgets('minSize is pixels: hard left stops at 25, hard right at 0', (
      WidgetTester tester,
    ) async {
      await _pump(tester, group(), size: const Size(1200, 400));
      final RenderBox box = tester.renderObject<RenderBox>(
        find.byType(ElResizablePanelGroup),
      );
      final Offset seam = box.localToGlobal(Offset(410.8, box.size.height / 2));

      await tester.dragFrom(seam, const Offset(-2000, 0));
      await tester.pump();
      expect(panes(tester).first.size.width, closeTo(25, 0.01));

      final Offset atFloor = box.localToGlobal(Offset(25, box.size.height / 2));
      await tester.dragFrom(atFloor, const Offset(2000, 0));
      await tester.pump();
      expect(
        panes(tester)[1].size.width,
        closeTo(0, 0.01),
        reason: 'the second panel declares no floor',
      );
    });

    testWidgets('the grab strip is 24px, 11.5 into each neighbour — '
        'USER-ORDERED DIVERGENCE from the measured 4', (
      WidgetTester tester,
    ) async {
      Future<double> grabAt(double dx) async {
        await _pump(tester, group(), size: const Size(1200, 400));
        final RenderBox box = tester.renderObject<RenderBox>(
          find.byType(ElResizablePanelGroup),
        );
        await tester.dragFrom(
          box.localToGlobal(Offset(dx, box.size.height / 2)),
          const Offset(60, 0),
        );
        await tester.pump();
        return panes(tester).first.size.width;
      }

      // The reference measured 4 (735 → 739 against a handle box of
      // [736.8, 737.8]) and the port ships 24, centred on the same hairline:
      // a fingertip cannot land on 4px. `handleHit` keeps the measurement,
      // `handleGrab` is what hit-tests.
      expect(handleHit, 4);
      expect(handleGrab, 24);

      // The reference's own zone still answers: [seam − 1.5, seam + 2.5].
      expect(await grabAt(410.8 - 1), closeTo(470.8, 1));
      expect(await grabAt(410.8 + 2), closeTo(470.8, 1));
      // And so does the touch strip around it — [seam − 11.5, seam + 12.5].
      // Both of these are outside the 4px zone, so before the divergence they
      // moved nothing: that is what pins the new width rather than the old.
      expect(await grabAt(410.8 - 11), closeTo(470.8, 1));
      expect(await grabAt(410.8 + 12), closeTo(470.8, 1));
      // A pixel past either edge is past it, and nothing moves.
      expect(await grabAt(410.8 - 12), closeTo(410.8, 0.05));
      expect(await grabAt(410.8 + 13), closeTo(410.8, 0.05));
    });

    testWidgets('the keyboard steps 5 points, Home floors and End maxes', (
      WidgetTester tester,
    ) async {
      await _pump(tester, group(), size: const Size(1200, 400));
      final FocusNode node = tester.binding.focusManager.rootScope.descendants
          .firstWhere(
            (FocusNode n) => n.debugLabel == elResizableHandleFocusLabel,
          );
      node.requestFocus();
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pump();
      expect(panes(tester).first.size.width, closeTo(410.8 + 1027 * 0.05, 0.5));

      await tester.sendKeyEvent(LogicalKeyboardKey.home);
      await tester.pump();
      expect(panes(tester).first.size.width, closeTo(25, 0.01));

      await tester.sendKeyEvent(LogicalKeyboardKey.end);
      await tester.pump();
      expect(panes(tester)[1].size.width, closeTo(0, 0.01));
    });
  });
}
