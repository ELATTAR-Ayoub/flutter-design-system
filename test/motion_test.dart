import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// The motion layer: the three interaction utilities the shell and the docs
/// pages are built out of — `press`, `lift`, and the travelling `slide-pill`
/// with its `anim-jelly` arrival.

Widget host(Widget child, {DsThemeMode mode = DsThemeMode.dark}) {
  return MediaQuery(
    data: const MediaQueryData(size: Size(1440, 900)),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: DsTheme(
        controller: DsThemeController(mode: mode),
        child: Center(child: child),
      ),
    ),
  );
}

/// The scale a widget is currently drawn at, read off the first [Transform]
/// under [of].
({double x, double y}) scaleOf(WidgetTester t, Finder of) {
  final Transform transform = t.widget<Transform>(
    find.descendant(of: of, matching: find.byType(Transform)).first,
  );
  return (x: transform.transform.storage[0], y: transform.transform.storage[5]);
}

/// The y translation currently applied by the first [Transform] under [of].
double translationYOf(WidgetTester t, Finder of) {
  final Transform transform = t.widget<Transform>(
    find.descendant(of: of, matching: find.byType(Transform)).first,
  );
  return transform.transform.storage[13];
}

void main() {
  group('DsPress', () {
    testWidgets('squishes on pointer-down and springs back on up',
        (WidgetTester t) async {
      await t.pumpWidget(host(
        DsPress(child: const SizedBox(width: 80, height: 32)),
      ));

      final Finder press = find.byType(DsPress);
      expect(scaleOf(t, press).x, 1.0, reason: 'at rest');

      final TestGesture gesture = await t.startGesture(t.getCenter(press));
      await t.pump(); // the ticker's first frame is its zero point
      await t.pump(DsDurations.pressDown);
      expect(scaleOf(t, press).x, closeTo(DsTransforms.pressScale, 1e-6));
      expect(scaleOf(t, press).y, closeTo(DsTransforms.pressScale, 1e-6));

      await gesture.up();
      await t.pump();
      await t.pump(DsDurations.base);
      expect(scaleOf(t, press).x, closeTo(1.0, 1e-6));
    });

    testWidgets('down is far quicker than the spring back',
        (WidgetTester t) async {
      await t.pumpWidget(host(
        DsPress(child: const SizedBox(width: 80, height: 32)),
      ));
      final Finder press = find.byType(DsPress);

      final TestGesture gesture = await t.startGesture(t.getCenter(press));
      await t.pump();
      await t.pump(DsDurations.pressDown);
      await gesture.up();

      // The asymmetry globals.css calls "the whole feel": 40ms down, 250ms
      // back. One press-length into the return the surface is still squished.
      await t.pump();
      await t.pump(DsDurations.pressDown);
      expect(scaleOf(t, press).x, lessThan(1.0));

      await t.pump(DsDurations.base);
      expect(scaleOf(t, press).x, closeTo(1.0, 1e-6));
    });

    testWidgets('a cancelled press still returns', (WidgetTester t) async {
      int taps = 0;
      await t.pumpWidget(host(
        DsPress(
          onTap: () => taps++,
          child: const SizedBox(width: 80, height: 32),
        ),
      ));
      final Finder press = find.byType(DsPress);

      final TestGesture gesture = await t.startGesture(t.getCenter(press));
      await t.pump();
      await t.pump(DsDurations.pressDown);
      await gesture.cancel();
      await t.pump();
      await t.pump(DsDurations.base);

      expect(scaleOf(t, press).x, closeTo(1.0, 1e-6));
      expect(taps, 0, reason: 'a cancelled press is not a tap');
    });

    testWidgets('fires onTap', (WidgetTester t) async {
      int taps = 0;
      await t.pumpWidget(host(
        DsPress(
          onTap: () => taps++,
          child: const SizedBox(width: 80, height: 32),
        ),
      ));

      await t.tap(find.byType(DsPress));
      await t.pump(DsDurations.base);
      expect(taps, 1);
    });

    testWidgets('honours a custom scale', (WidgetTester t) async {
      await t.pumpWidget(host(
        DsPress(
          scale: DsTransforms.buttonScale,
          child: const SizedBox(width: 80, height: 32),
        ),
      ));
      final Finder press = find.byType(DsPress);

      await t.startGesture(t.getCenter(press));
      await t.pump();
      await t.pump(DsDurations.pressDown);
      expect(scaleOf(t, press).x, closeTo(DsTransforms.buttonScale, 1e-6));
    });
  });

  group('DsLift', () {
    testWidgets('reports hover to its builder', (WidgetTester t) async {
      final List<bool> states = <bool>[];
      await t.pumpWidget(host(
        DsLift(builder: (BuildContext c, bool hovered) {
          states.add(hovered);
          return const SizedBox(width: 200, height: 120);
        }),
      ));
      expect(states.last, isFalse);

      final TestGesture mouse =
          await t.createGesture(kind: PointerDeviceKind.mouse);
      await mouse.addPointer(location: Offset.zero);
      addTearDown(mouse.removePointer);
      await t.pump();

      await mouse.moveTo(t.getCenter(find.byType(DsLift)));
      await t.pump();
      expect(states.last, isTrue);

      await mouse.moveTo(Offset.zero);
      await t.pump();
      expect(states.last, isFalse);
    });
  });

  group('DsLiftCard', () {
    Future<TestGesture> hoverOver(WidgetTester t, Finder target) async {
      final TestGesture mouse =
          await t.createGesture(kind: PointerDeviceKind.mouse);
      await mouse.addPointer(location: Offset.zero);
      addTearDown(mouse.removePointer);
      await t.pump();
      await mouse.moveTo(t.getCenter(target));
      return mouse;
    }

    BoxDecoration decorationOf(WidgetTester t) => t
        .widget<DecoratedBox>(find
            .descendant(
              of: find.byType(DsLiftCard),
              matching: find.byType(DecoratedBox),
            )
            .first)
        .decoration as BoxDecoration;

    testWidgets('rises 3px onto an e3 shadow and swaps its border',
        (WidgetTester t) async {
      final Color hoverBorder = DsPalette.action.withValues(alpha: 0.45);
      await t.pumpWidget(host(
        SizedBox(
          width: 240,
          height: 140,
          child: DsLiftCard(
            hoverBorderColor: hoverBorder,
            builder: (BuildContext c, bool hovered) => const SizedBox.expand(),
          ),
        ),
      ));

      final Finder card = find.byType(DsLiftCard);
      expect(translationYOf(t, card), 0);
      expect(decorationOf(t).boxShadow, isEmpty);
      expect((decorationOf(t).border! as Border).top.color,
          DsThemeData.dark.border);

      await hoverOver(t, card);
      await t.pump();
      await t.pump(DsDurations.base);

      expect(translationYOf(t, card), closeTo(DsTransforms.liftY, 1e-6));
      final List<BoxShadow> lifted = DsShadows.e3.outerShadows(DsThemeData.dark);
      expect(decorationOf(t).boxShadow, hasLength(lifted.length));
      expect(decorationOf(t).boxShadow!.last.color, lifted.last.color);
      expect((decorationOf(t).border! as Border).top.color, hoverBorder);
    });

    testWidgets('settles back when the pointer leaves', (WidgetTester t) async {
      await t.pumpWidget(host(
        SizedBox(
          width: 240,
          height: 140,
          child: DsLiftCard(
            builder: (BuildContext c, bool hovered) => const SizedBox.expand(),
          ),
        ),
      ));
      final Finder card = find.byType(DsLiftCard);

      final TestGesture mouse = await hoverOver(t, card);
      await t.pump();
      await t.pump(DsDurations.base);
      expect(translationYOf(t, card), closeTo(DsTransforms.liftY, 1e-6));

      await mouse.moveTo(Offset.zero);
      await t.pump();
      await t.pump(DsDurations.base);
      expect(translationYOf(t, card), closeTo(0, 1e-6));
    });

    testWidgets('hands hover to its builder for the arrow quirk',
        (WidgetTester t) async {
      bool seen = false;
      await t.pumpWidget(host(
        SizedBox(
          width: 240,
          height: 140,
          child: DsLiftCard(
            builder: (BuildContext c, bool hovered) {
              seen = hovered;
              return const SizedBox.expand();
            },
          ),
        ),
      ));

      await hoverOver(t, find.byType(DsLiftCard));
      await t.pump();
      expect(seen, isTrue);
    });

    // `box-sizing: border-box`, the rule the whole system is laid out under:
    // a bordered, padded box gives its content `width − 2·padding − 2·border`.
    // Two pixels is not cosmetic — the overview's index-card blurbs measured
    // 309.33px here against 307.33px in Chrome, and that is the difference
    // between "every contrast ratio" wrapping after `contrast` and after
    // `ratio`.
    testWidgets('the border is paid for out of the content box',
        (WidgetTester t) async {
      const Key content = Key('content');
      const double outer = 240;
      final double pad = ds(5); // `p-5`, the index card

      await t.pumpWidget(host(
        SizedBox(
          width: outer,
          height: 140,
          child: DsLiftCard(
            padding: EdgeInsets.all(pad),
            builder: (BuildContext c, bool hovered) =>
                const SizedBox.expand(key: content),
          ),
        ),
      ));

      expect(
        t.getSize(find.byKey(content)).width,
        outer - 2 * pad - 2 * DsWidths.hairline,
      );
      expect(
        t.getSize(find.byKey(content)).height,
        140 - 2 * pad - 2 * DsWidths.hairline,
      );
      // And the border it is paying for is the token, not `Border.all`'s
      // coincidentally-identical default.
      expect((decorationOf(t).border! as Border).top.width, DsWidths.hairline);
    });
  });

  group('DsSlidingPillGroup', () {
    const Key pillKey = Key('pill');
    final List<Key> itemKeys =
        List<Key>.generate(3, (int i) => ValueKey<int>(i));

    Widget group(int active, {double itemWidth = 28}) => host(
          SizedBox(
            width: 300,
            child: DsSlidingPillGroup(
              activeIndex: active,
              pill: const SizedBox.expand(key: pillKey),
              gap: 1,
              padding: EdgeInsets.all(ds(0.5)),
              children: <Widget>[
                for (int i = 0; i < 3; i++)
                  SizedBox(key: itemKeys[i], width: itemWidth, height: 28),
              ],
            ),
          ),
        );

    testWidgets('is hidden until the first layout has been measured',
        (WidgetTester t) async {
      await t.pumpWidget(group(0));

      // Frame one: nothing has been measured, so there is nowhere honest to
      // put the pill. The web sets opacity 0 for exactly this reason.
      expect(t.widget<AnimatedOpacity>(find.byType(AnimatedOpacity)).opacity, 0);

      await t.pump();
      expect(t.widget<AnimatedOpacity>(find.byType(AnimatedOpacity)).opacity, 1);
    });

    testWidgets('first placement lands without travelling',
        (WidgetTester t) async {
      await t.pumpWidget(group(0));
      await t.pump();

      // No pumping past a transition: it is already there.
      expect(t.getRect(find.byKey(pillKey)),
          rectMoreOrLessEquals(t.getRect(find.byKey(itemKeys[0])), epsilon: 0.01));
      expect(scaleOf(t, find.byType(DsSlidingPillGroup)).x, 1.0,
          reason: 'and it does not squash on arrival the first time');
    });

    testWidgets('travels to the new selection', (WidgetTester t) async {
      await t.pumpWidget(group(0));
      await t.pump();

      await t.pumpWidget(group(2));
      await t.pump(const Duration(milliseconds: 16));
      expect(
        t.getRect(find.byKey(pillKey)).center.dx,
        lessThan(t.getRect(find.byKey(itemKeys[2])).center.dx),
        reason: 'still in flight one frame in',
      );

      await t.pump(DsDurations.animJelly);
      expect(t.getRect(find.byKey(pillKey)),
          rectMoreOrLessEquals(t.getRect(find.byKey(itemKeys[2])), epsilon: 0.01));
    });

    testWidgets('replays the jelly on every arrival after the first',
        (WidgetTester t) async {
      await t.pumpWidget(group(0));
      await t.pump();

      await t.pumpWidget(group(1));
      // 30% of yuki-jelly's 600ms: the squash keyframe, scale3d(1.18, 0.82, 1).
      await t.pump(const Duration(milliseconds: 180));
      final ({double x, double y}) squashed =
          scaleOf(t, find.byType(DsSlidingPillGroup));
      expect(squashed.x, closeTo(1.18, 0.03));
      expect(squashed.y, closeTo(0.82, 0.03));

      await t.pump(DsDurations.animJelly);
      final ({double x, double y}) settled =
          scaleOf(t, find.byType(DsSlidingPillGroup));
      expect(settled.x, closeTo(1.0, 1e-6));
      expect(settled.y, closeTo(1.0, 1e-6));
    });

    testWidgets('re-measures when the row is laid out again',
        (WidgetTester t) async {
      await t.pumpWidget(group(1));
      await t.pump();
      final Rect before = t.getRect(find.byKey(pillKey));

      // Wider options move the selected one and change its size — the web
      // catches this with a ResizeObserver, and so must this.
      await t.pumpWidget(group(1, itemWidth: 44));
      await t.pump();
      await t.pump(DsDurations.animJelly);

      expect(t.getRect(find.byKey(pillKey)), isNot(before));
      expect(t.getRect(find.byKey(pillKey)),
          rectMoreOrLessEquals(t.getRect(find.byKey(itemKeys[1])), epsilon: 0.01));
    });
  });
}
