import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// The motion layer: the three interaction utilities the shell and the docs
/// pages are built out of — `press`, `lift`, and the travelling `slide-pill`
/// with its `anim-jelly` arrival — and the keyframe layer underneath the named
/// animations.

Widget host(Widget child, {ElThemeMode mode = ElThemeMode.dark}) {
  return MediaQuery(
    data: const MediaQueryData(size: Size(1440, 900)),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: ElTheme(
        controller: ElThemeController(mode: mode),
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

/// [host], with `prefers-reduced-motion` switched on.
///
/// The [MediaQuery] goes *inside* [host]'s own, because the nearer one wins and
/// [host] declares a size the widgets under test need.
Widget stilledHost(Widget child, {ElThemeMode mode = ElThemeMode.dark}) => host(
  MediaQuery(
    data: const MediaQueryData(size: Size(1440, 900), disableAnimations: true),
    child: child,
  ),
  mode: mode,
);

/// The slack a keyframe stop is sampled with.
///
/// Not the table's. At 0%, at 100%, and on every held tail the values are
/// exact. It is Flutter's [Cubic]: it solves its x-parameter by binary search to
/// a documented bound of 0.001, so it is inexact for a local `t` that is not
/// literally zero — and a stop lands on a literal zero only when the sequence's
/// cumulative weight is a representable double. `yuki-jelly`'s 45% is not
/// (`0.3 + 0.15 == 0.44999999999999996`), so a sample at 0.45 reads 4e-16 into
/// the next segment and the solver answers 0.0041 where the curve is 0. That
/// costs ~7e-4 of one segment, against keyframe values never closer together
/// than 0.02.
const double stopTolerance = 1e-3;

void main() {
  group('ElPress', () {
    testWidgets('squishes on pointer-down and springs back on up', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        host(ElPress(child: const SizedBox(width: 80, height: 32))),
      );

      final Finder press = find.byType(ElPress);
      expect(scaleOf(t, press).x, 1.0, reason: 'at rest');

      final TestGesture gesture = await t.startGesture(t.getCenter(press));
      await t.pump(); // the ticker's first frame is its zero point
      await t.pump(ElDurations.pressDown);
      expect(scaleOf(t, press).x, closeTo(ElTransforms.pressScale, 1e-6));
      expect(scaleOf(t, press).y, closeTo(ElTransforms.pressScale, 1e-6));

      await gesture.up();
      await t.pump();
      await t.pump(ElDurations.base);
      expect(scaleOf(t, press).x, closeTo(1.0, 1e-6));
    });

    testWidgets('down is far quicker than the spring back', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        host(ElPress(child: const SizedBox(width: 80, height: 32))),
      );
      final Finder press = find.byType(ElPress);

      final TestGesture gesture = await t.startGesture(t.getCenter(press));
      await t.pump();
      await t.pump(ElDurations.pressDown);
      await gesture.up();

      // The asymmetry globals.css calls "the whole feel": 40ms down, 250ms
      // back. One press-length into the return the surface is still squished.
      await t.pump();
      await t.pump(ElDurations.pressDown);
      expect(scaleOf(t, press).x, lessThan(1.0));

      await t.pump(ElDurations.base);
      expect(scaleOf(t, press).x, closeTo(1.0, 1e-6));
    });

    testWidgets('a cancelled press still returns', (WidgetTester t) async {
      int taps = 0;
      await t.pumpWidget(
        host(
          ElPress(
            onTap: () => taps++,
            child: const SizedBox(width: 80, height: 32),
          ),
        ),
      );
      final Finder press = find.byType(ElPress);

      final TestGesture gesture = await t.startGesture(t.getCenter(press));
      await t.pump();
      await t.pump(ElDurations.pressDown);
      await gesture.cancel();
      await t.pump();
      await t.pump(ElDurations.base);

      expect(scaleOf(t, press).x, closeTo(1.0, 1e-6));
      expect(taps, 0, reason: 'a cancelled press is not a tap');
    });

    testWidgets('fires onTap', (WidgetTester t) async {
      int taps = 0;
      await t.pumpWidget(
        host(
          ElPress(
            onTap: () => taps++,
            child: const SizedBox(width: 80, height: 32),
          ),
        ),
      );

      await t.tap(find.byType(ElPress));
      await t.pump(ElDurations.base);
      expect(taps, 1);
    });

    testWidgets('honours a custom scale', (WidgetTester t) async {
      await t.pumpWidget(
        host(
          ElPress(
            scale: ElTransforms.buttonScale,
            child: const SizedBox(width: 80, height: 32),
          ),
        ),
      );
      final Finder press = find.byType(ElPress);

      await t.startGesture(t.getCenter(press));
      await t.pump();
      await t.pump(ElDurations.pressDown);
      expect(scaleOf(t, press).x, closeTo(ElTransforms.buttonScale, 1e-6));
    });
  });

  group('ElLift', () {
    testWidgets('reports hover to its builder', (WidgetTester t) async {
      final List<bool> states = <bool>[];
      await t.pumpWidget(
        host(
          ElLift(
            builder: (BuildContext c, bool hovered) {
              states.add(hovered);
              return const SizedBox(width: 200, height: 120);
            },
          ),
        ),
      );
      expect(states.last, isFalse);

      final TestGesture mouse = await t.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      await mouse.addPointer(location: Offset.zero);
      addTearDown(mouse.removePointer);
      await t.pump();

      await mouse.moveTo(t.getCenter(find.byType(ElLift)));
      await t.pump();
      expect(states.last, isTrue);

      await mouse.moveTo(Offset.zero);
      await t.pump();
      expect(states.last, isFalse);
    });
  });

  group('ElLiftCard', () {
    Future<TestGesture> hoverOver(WidgetTester t, Finder target) async {
      final TestGesture mouse = await t.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      await mouse.addPointer(location: Offset.zero);
      addTearDown(mouse.removePointer);
      await t.pump();
      await mouse.moveTo(t.getCenter(target));
      return mouse;
    }

    BoxDecoration decorationOf(WidgetTester t) =>
        t
                .widget<DecoratedBox>(
                  find
                      .descendant(
                        of: find.byType(ElLiftCard),
                        matching: find.byType(DecoratedBox),
                      )
                      .first,
                )
                .decoration
            as BoxDecoration;

    testWidgets('rises 3px onto an e3 shadow and swaps its border', (
      WidgetTester t,
    ) async {
      final Color hoverBorder = ElPalette.action.withValues(alpha: 0.45);
      await t.pumpWidget(
        host(
          SizedBox(
            width: 240,
            height: 140,
            child: ElLiftCard(
              hoverBorderColor: hoverBorder,
              builder: (BuildContext c, bool hovered) =>
                  const SizedBox.expand(),
            ),
          ),
        ),
      );

      final Finder card = find.byType(ElLiftCard);
      expect(translationYOf(t, card), 0);
      expect(decorationOf(t).boxShadow, isEmpty);
      expect(
        (decorationOf(t).border! as Border).top.color,
        ElThemeData.dark.border,
      );

      await hoverOver(t, card);
      await t.pump();
      await t.pump(ElDurations.base);

      expect(translationYOf(t, card), closeTo(ElTransforms.liftY, 1e-6));
      final List<BoxShadow> lifted = ElShadows.e3.outerShadows(
        ElThemeData.dark,
      );
      expect(decorationOf(t).boxShadow, hasLength(lifted.length));
      expect(decorationOf(t).boxShadow!.last.color, lifted.last.color);
      expect((decorationOf(t).border! as Border).top.color, hoverBorder);
    });

    testWidgets('settles back when the pointer leaves', (WidgetTester t) async {
      await t.pumpWidget(
        host(
          SizedBox(
            width: 240,
            height: 140,
            child: ElLiftCard(
              builder: (BuildContext c, bool hovered) =>
                  const SizedBox.expand(),
            ),
          ),
        ),
      );
      final Finder card = find.byType(ElLiftCard);

      final TestGesture mouse = await hoverOver(t, card);
      await t.pump();
      await t.pump(ElDurations.base);
      expect(translationYOf(t, card), closeTo(ElTransforms.liftY, 1e-6));

      await mouse.moveTo(Offset.zero);
      await t.pump();
      await t.pump(ElDurations.base);
      expect(translationYOf(t, card), closeTo(0, 1e-6));
    });

    testWidgets('hands hover to its builder for the arrow quirk', (
      WidgetTester t,
    ) async {
      bool seen = false;
      await t.pumpWidget(
        host(
          SizedBox(
            width: 240,
            height: 140,
            child: ElLiftCard(
              builder: (BuildContext c, bool hovered) {
                seen = hovered;
                return const SizedBox.expand();
              },
            ),
          ),
        ),
      );

      await hoverOver(t, find.byType(ElLiftCard));
      await t.pump();
      expect(seen, isTrue);
    });

    // `box-sizing: border-box`, the rule the whole system is laid out under:
    // a bordered, padded box gives its content `width − 2·padding − 2·border`.
    // Two pixels is not cosmetic — the overview's index-card blurbs measured
    // 309.33px here against 307.33px in Chrome, and that is the difference
    // between "every contrast ratio" wrapping after `contrast` and after
    // `ratio`.
    testWidgets('the border is paid for out of the content box', (
      WidgetTester t,
    ) async {
      const Key content = Key('content');
      const double outer = 240;
      final double pad = el(5); // `p-5`, the index card

      await t.pumpWidget(
        host(
          SizedBox(
            width: outer,
            height: 140,
            child: ElLiftCard(
              padding: EdgeInsets.all(pad),
              builder: (BuildContext c, bool hovered) =>
                  const SizedBox.expand(key: content),
            ),
          ),
        ),
      );

      expect(
        t.getSize(find.byKey(content)).width,
        outer - 2 * pad - 2 * ElWidths.hairline,
      );
      expect(
        t.getSize(find.byKey(content)).height,
        140 - 2 * pad - 2 * ElWidths.hairline,
      );
      // And the border it is paying for is the token, not `Border.all`'s
      // coincidentally-identical default.
      expect((decorationOf(t).border! as Border).top.width, ElWidths.hairline);
    });
  });

  group('ElSlidingPillGroup', () {
    const Key pillKey = Key('pill');
    final List<Key> itemKeys = List<Key>.generate(
      3,
      (int i) => ValueKey<int>(i),
    );

    Widget group(int active, {double itemWidth = 28, Duration? travel}) => host(
      SizedBox(
        width: 300,
        child: ElSlidingPillGroup(
          activeIndex: active,
          pill: const SizedBox.expand(key: pillKey),
          gap: 1,
          padding: EdgeInsets.all(el(0.5)),
          travelDuration: travel,
          children: <Widget>[
            for (int i = 0; i < 3; i++)
              SizedBox(key: itemKeys[i], width: itemWidth, height: 28),
          ],
        ),
      ),
    );

    /// The opacity the pill is actually **painted** at, not the target the
    /// [AnimatedOpacity] is aiming for — which is the whole question in T6.
    double paintedOpacity(WidgetTester t) => t
        .widget<FadeTransition>(
          find.descendant(
            of: find.byType(ElSlidingPillGroup),
            matching: find.byType(FadeTransition),
          ),
        )
        .opacity
        .value;

    testWidgets('is hidden until the first layout has been measured', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(group(0));

      // Frame one: nothing has been measured, so there is nowhere honest to
      // put the pill. The web sets opacity 0 for exactly this reason.
      expect(
        t.widget<AnimatedOpacity>(find.byType(AnimatedOpacity)).opacity,
        0,
      );

      await t.pump();
      expect(
        t.widget<AnimatedOpacity>(find.byType(AnimatedOpacity)).opacity,
        1,
      );
    });

    testWidgets('T6 — first placement POPS: it lands without travelling and '
        'without fading', (WidgetTester t) async {
      await t.pumpWidget(group(0));
      expect(paintedOpacity(t), 0, reason: 'nothing measured yet');

      await t.pump();
      // No pumping past a transition: it is already there, at full opacity.
      // Measured from before hydration — the hook's first `move()` writes
      // opacity 0→1, width 0→W and the transform in ONE frame, with
      // `transition: none`. The port used to fade this in over 150ms.
      expect(
        t.getRect(find.byKey(pillKey)),
        rectMoreOrLessEquals(t.getRect(find.byKey(itemKeys[0])), epsilon: 0.01),
      );
      expect(paintedOpacity(t), 1, reason: 'popped, not faded');
    });

    testWidgets('T7 — …and then squashes once, on its own', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(group(0));
      await t.pump();
      // The reference's squash is not the first `move()` — that one returns on
      // `isFirstMove` before the jelly. It is the ResizeObserver's mandatory
      // initial callback re-entering `move()` ~117ms later with identical
      // geometry, which does take the jelly branch. The port's analogue is the
      // post-frame re-measure, so the squash starts a frame after the pop; this
      // pump is that frame, and the jelly's own zero point.
      await t.pump();
      expect(scaleOf(t, find.byType(ElSlidingPillGroup)).x, 1.0);

      await t.pump(const Duration(milliseconds: 180));
      // 30% of yuki-jelly's 600ms: scale3d(1.18, 0.82, 1).
      final ({double x, double y}) squashed = scaleOf(
        t,
        find.byType(ElSlidingPillGroup),
      );
      expect(squashed.x, closeTo(1.18, 0.01));
      expect(squashed.y, closeTo(0.82, 0.01));

      await t.pump(ElDurations.animJelly);
      expect(scaleOf(t, find.byType(ElSlidingPillGroup)).x, closeTo(1, 1e-6));
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

      await t.pump(ElDurations.animJelly);
      expect(
        t.getRect(find.byKey(pillKey)),
        rectMoreOrLessEquals(t.getRect(find.byKey(itemKeys[2])), epsilon: 0.01),
      );
    });

    testWidgets('replays the jelly on every arrival after the first', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(group(0));
      await t.pump();

      await t.pumpWidget(group(1));
      // 30% of yuki-jelly's 600ms: the squash keyframe, scale3d(1.18, 0.82, 1).
      await t.pump(const Duration(milliseconds: 180));
      final ({double x, double y}) squashed = scaleOf(
        t,
        find.byType(ElSlidingPillGroup),
      );
      expect(squashed.x, closeTo(1.18, 0.03));
      expect(squashed.y, closeTo(0.82, 0.03));

      await t.pump(ElDurations.animJelly);
      final ({double x, double y}) settled = scaleOf(
        t,
        find.byType(ElSlidingPillGroup),
      );
      expect(settled.x, closeTo(1.0, 1e-6));
      expect(settled.y, closeTo(1.0, 1e-6));
    });

    testWidgets('T8/T8b — deselection fades in place: the rect is held, the '
        'squash does not replay', (WidgetTester t) async {
      await t.pumpWidget(group(1));
      await t.pump();
      await t.pump(ElDurations.animJelly);
      final Rect parked = t.getRect(find.byKey(pillKey));
      expect(paintedOpacity(t), 1);

      // The `MutationObserver` recorded exactly ONE style write on the live
      // reference: `width: 51.89px; height: 32px; transform: translate(74.89px,
      // 0px); opacity: 0` — width, height and transform unchanged from the
      // selection being left. The port used to re-target left/top/width/height
      // to 0/0/0/0, sliding the pill to the group origin under the fade.
      await t.pumpWidget(group(-1));
      final List<double> opacities = <double>[];
      for (int f = 0; f < 12; f++) {
        await t.pump(const Duration(milliseconds: 16));
        expect(
          t.getRect(find.byKey(pillKey)),
          parked,
          reason: 'frame ${f + 1}: the rect must not move at all',
        );
        expect(
          scaleOf(t, find.byType(ElSlidingPillGroup)).x,
          1.0,
          reason: 'frame ${f + 1}: the jelly held 1.000 on the reference',
        );
        opacities.add(paintedOpacity(t));
      }

      // 150ms `--ease-out`, which is extremely front-loaded: measured 0.562 at
      // Δ29 and 0.024 at Δ89 on the reference.
      expect(opacities.first, lessThan(1));
      expect(
        opacities[9],
        0,
        reason: 'gone by 160ms — a 150ms leg plus a frame',
      );
      for (int i = 1; i < opacities.length; i++) {
        expect(opacities[i], lessThanOrEqualTo(opacities[i - 1]));
      }
    });

    testWidgets('a deselected pill re-selects from where it was parked', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(group(2));
      await t.pump();
      await t.pump(ElDurations.animJelly);
      final Rect parked = t.getRect(find.byKey(pillKey));

      await t.pumpWidget(group(-1));
      await t.pump(ElDurations.fast);
      await t.pump();
      expect(t.getRect(find.byKey(pillKey)), parked, reason: 'still parked');

      // Re-selecting writes the transform and `opacity: 1` together, and both
      // legs are transitioned again — so it travels from where it stands.
      await t.pumpWidget(group(0));
      await t.pump(const Duration(milliseconds: 16));
      expect(
        t.getRect(find.byKey(pillKey)).left,
        greaterThan(t.getRect(find.byKey(itemKeys[0])).left),
        reason: 'in flight, still short of its target',
      );
      await t.pump(ElDurations.animJelly);
      expect(
        t.getRect(find.byKey(pillKey)),
        rectMoreOrLessEquals(t.getRect(find.byKey(itemKeys[0])), epsilon: 0.01),
      );
    });

    testWidgets('travelDuration: zero jumps and still squashes — the theme '
        'toggle\'s contract', (WidgetTester t) async {
      await t.pumpWidget(group(0, travel: Duration.zero));
      await t.pump();
      await t.pump(ElDurations.animJelly);

      await t.pumpWidget(group(2, travel: Duration.zero));
      await t.pump();
      // No travel at all: the pill is on its target in the first frame after
      // the change, where a 250ms spring would still be in flight.
      expect(
        t.getRect(find.byKey(pillKey)),
        rectMoreOrLessEquals(t.getRect(find.byKey(itemKeys[2])), epsilon: 0.01),
      );

      // …and the arrival squash still plays: the class is re-added in the same
      // batch and runs its full 600ms whatever the travel did.
      await t.pump(const Duration(milliseconds: 180));
      expect(
        scaleOf(t, find.byType(ElSlidingPillGroup)).x,
        closeTo(1.18, 0.01),
      );
    });

    testWidgets('re-measures when the row is laid out again', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(group(1));
      await t.pump();
      final Rect before = t.getRect(find.byKey(pillKey));

      // Wider options move the selected one and change its size — the web
      // catches this with a ResizeObserver, and so must this.
      await t.pumpWidget(group(1, itemWidth: 44));
      await t.pump();
      await t.pump(ElDurations.animJelly);

      expect(t.getRect(find.byKey(pillKey)), isNot(before));
      expect(
        t.getRect(find.byKey(pillKey)),
        rectMoreOrLessEquals(t.getRect(find.byKey(itemKeys[1])), epsilon: 0.01),
      );
    });
  });

  // ── keyframes ─────────────────────────────────────────────────────────────

  group('ElSteps', () {
    test('steps(8) holds eight positions and never shows the wrap frame', () {
      const Curve steps = ElSteps(8);
      final Set<double> seen = <double>{};
      for (int i = 0; i < 800; i++) {
        final double value = steps.transform(i / 800);
        expect(value, lessThan(1.0), reason: '360° is never displayed');
        seen.add(value);
      }
      expect(seen, hasLength(8));

      // One per 45°, which is what makes it read as a mechanism.
      final List<double> ordered = seen.toList()..sort();
      for (int i = 0; i < 8; i++) {
        expect(ordered[i] * 360, closeTo(i * 45, 1e-9));
      }

      // The frame `Curve.transform` is contractually asked for, and the one
      // CSS never paints: it holds the last position instead of reaching 1.
      expect(steps.transform(1), closeTo(7 / 8, 1e-12));
      expect(ElRatchet.degreesAt(1), closeTo(315, 1e-9));
      expect(ElRatchet.radiansAt(0), 0);
      expect(ElRatchet.step, ElDurations.ratchetStep);
    });

    test('jump-start is the other CSS variant', () {
      const Curve steps = ElSteps(2, jumpEnd: false);
      expect(
        steps.transform(0),
        closeTo(0.5, 1e-12),
        reason: 'jump-start takes its first step at t=0',
      );
      expect(steps.transform(0.75), 1);
      expect(steps.transform(1), 1);
    });
  });

  group('the finite keyframe tables', () {
    test('yuki-pop-in matches globals.css at every stop', () {
      expect(
        ElPopIn.scale.transform(0),
        offsetMoreOrLessEquals(const Offset(0.25, 0.25), epsilon: 1e-9),
      );
      expect(
        ElPopIn.scale.transform(0.55),
        offsetMoreOrLessEquals(
          const Offset(0.92, 1.08),
          epsilon: stopTolerance,
        ),
      );
      expect(
        ElPopIn.scale.transform(0.80),
        offsetMoreOrLessEquals(
          const Offset(1.04, 0.97),
          epsilon: stopTolerance,
        ),
      );
      expect(
        ElPopIn.scale.transform(0.92),
        offsetMoreOrLessEquals(
          const Offset(0.99, 1.01),
          epsilon: stopTolerance,
        ),
      );
      expect(
        ElPopIn.scale.transform(1),
        offsetMoreOrLessEquals(const Offset(1, 1), epsilon: 1e-9),
      );

      // Declared at 0% and 55% only — and then it HOLDS, exactly, because the
      // tail is modelled rather than left to emerge.
      expect(ElPopIn.opacity.transform(0), 0);
      expect(ElPopIn.opacity.transform(0.55), closeTo(1, stopTolerance));
      expect(ElPopIn.opacity.transform(0.8), 1);
      expect(ElPopIn.opacity.transform(1), 1);
    });

    test('yuki-jelly matches globals.css at every stop', () {
      expect(
        ElJelly.scale.transform(0),
        offsetMoreOrLessEquals(const Offset(1, 1), epsilon: 1e-9),
      );
      expect(
        ElJelly.scale.transform(0.30),
        offsetMoreOrLessEquals(
          const Offset(1.18, 0.82),
          epsilon: stopTolerance,
        ),
      );
      expect(
        ElJelly.scale.transform(0.45),
        offsetMoreOrLessEquals(
          const Offset(0.88, 1.12),
          epsilon: stopTolerance,
        ),
      );
      expect(
        ElJelly.scale.transform(0.60),
        offsetMoreOrLessEquals(
          const Offset(1.06, 0.94),
          epsilon: stopTolerance,
        ),
      );
      expect(
        ElJelly.scale.transform(0.78),
        offsetMoreOrLessEquals(
          const Offset(0.98, 1.02),
          epsilon: stopTolerance,
        ),
      );
      expect(
        ElJelly.scale.transform(1),
        offsetMoreOrLessEquals(const Offset(1, 1), epsilon: 1e-9),
      );
    });

    test('check-draw slides a 22-unit dash into view over 280ms', () {
      // `from { stroke-dashoffset: 22 } to { stroke-dashoffset: 0 }`, and the
      // utility's own `stroke-dasharray: 22` is what makes one dash cover the
      // whole path.
      expect(ElCheckDraw.dashArray, 22);
      expect(ElCheckDraw.dashOffset.transform(0), 22);
      expect(ElCheckDraw.dashOffset.transform(1), closeTo(0, 1e-9));
      expect(ElCheckDraw.duration, ElDurations.checkDraw);
      expect(ElCheckDraw.duration.inMilliseconds, 280);
      expect(ElCheckDraw.curve, ElCurves.out);

      // Read the other way round: nothing painted at 0, all of it at 1.
      expect(ElCheckDraw.drawnFractionAt(0), closeTo(0, 1e-9));
      expect(ElCheckDraw.drawnFractionAt(1), closeTo(1, 1e-9));
      // And the two readings are one table, not two — the fraction is the
      // offset, inverted, at every point in between.
      expect(
        ElCheckDraw.drawnFractionAt(0.4),
        closeTo(1 - ElCheckDraw.dashOffset.transform(0.4) / 22, 1e-12),
      );
    });

    test('dash-draw is the same mechanism over a 12-unit stroke, in 200ms', () {
      expect(ElDashDraw.dashArray, 12);
      expect(ElDashDraw.dashOffset.transform(0), 12);
      expect(ElDashDraw.dashOffset.transform(1), closeTo(0, 1e-9));
      expect(ElDashDraw.duration.inMilliseconds, 200);
      expect(ElDashDraw.curve, ElCurves.out);
      // Shorter stroke, shorter run — the pair is why both numbers exist.
      expect(ElDashDraw.duration, lessThan(ElCheckDraw.duration));
      expect(ElDashDraw.dashArray, lessThan(ElCheckDraw.dashArray));
    });

    test('dot-pop overshoots to 1.35 at 55%, on the spring', () {
      expect(ElDotPop.scale.transform(0), 0);
      expect(ElDotPop.scale.transform(0.55), closeTo(1.35, stopTolerance));
      expect(ElDotPop.scale.transform(1), closeTo(1, 1e-9));

      // Opacity reaches 1 at the same stop the dot is widest, so the flash and
      // the peak land together.
      expect(ElDotPop.opacity.transform(0), 0);
      expect(ElDotPop.opacity.transform(0.55), closeTo(1, stopTolerance));
      expect(ElDotPop.opacity.transform(1), 1);

      expect(ElDotPop.duration.inMilliseconds, 320);
      expect(
        ElDotPop.curve,
        ElCurves.spring,
        reason: 'the one selection-control table that is not --ease-out',
      );
    });

    test('swap-roll is a transition: 400ms spring, 160% a step', () {
      expect(ElSwapRoll.duration, ElDurations.slow);
      expect(ElSwapRoll.duration.inMilliseconds, 400);
      expect(ElSwapRoll.curve, ElCurves.spring);
      expect(ElSwapRoll.squashDelay, ElDurations.fast);
      expect(ElSwapRoll.squashDelay.inMilliseconds, 150);

      // A CSS percentage translate resolves against the element's OWN box, and
      // every strip cell is centred on one glyph — so a step is 1.6 × the
      // glyph, never 1.6 × the clip window.
      expect(ElSwapRoll.travelFor(16), closeTo(25.6, 1e-9));
      expect(ElSwapRoll.travelFor(20), closeTo(32, 1e-9));
      expect(ElTransforms.swapRollTravel, 1.6);

      // The spring exceeds 1 mid-flight, which is what sails the arriving
      // glyph past centre before it settles.
      final double peak = <double>[
        for (int i = 0; i <= 100; i++) ElSwapRoll.curve.transform(i / 100),
      ].reduce((double a, double b) => a > b ? a : b);
      expect(peak, greaterThan(1));
      expect(peak, closeTo(1.098, 1e-2));
    });

    test('yuki-spring-up rises 32, overshoots 4, settles in three bounces', () {
      expect(ElSpringUp.translateY.transform(0), 32);
      expect(ElSpringUp.translateY.transform(0.55), closeTo(-4, stopTolerance));
      expect(
        ElSpringUp.translateY.transform(0.76),
        closeTo(1.5, stopTolerance),
      );
      expect(
        ElSpringUp.translateY.transform(0.90),
        closeTo(-0.5, stopTolerance),
      );
      expect(ElSpringUp.translateY.transform(1), closeTo(0, 1e-9));

      expect(ElSpringUp.opacity.transform(0), 0);
      expect(ElSpringUp.opacity.transform(0.55), closeTo(1, stopTolerance));
      expect(ElSpringUp.opacity.transform(1), 1);
      expect(
        ElSpringUp.curve,
        ElCurves.settle,
        reason: 'the one table that is not --ease-out',
      );
    });

    test('yuki-jelly-in matches globals.css at every stop', () {
      expect(ElJellyIn.scale.transform(0), 0.92);
      expect(ElJellyIn.scale.transform(0.60), closeTo(1.02, stopTolerance));
      expect(ElJellyIn.scale.transform(1), closeTo(1, 1e-9));

      expect(ElJellyIn.translateY.transform(0), 24);
      expect(ElJellyIn.translateY.transform(0.60), closeTo(-4, stopTolerance));
      expect(ElJellyIn.translateY.transform(1), closeTo(0, 1e-9));

      expect(ElJellyIn.opacity.transform(0), 0);
      expect(ElJellyIn.opacity.transform(0.60), closeTo(1, stopTolerance));
      expect(ElJellyIn.opacity.transform(1), 1);
    });

    test('pulls-reveal turns the card face-up flat, not in perspective', () {
      expect(ElReveal.opacity.transform(0), 0);
      expect(ElReveal.opacity.transform(1), 1);
      expect(
        ElReveal.rotationY.transform(0),
        closeTo(ElReveal.fromRadians, 1e-12),
      );
      expect(ElReveal.rotationY.transform(1), closeTo(0, 1e-9));
      expect(ElReveal.scale.transform(0), ElReveal.fromScale);
      expect(ElReveal.scale.transform(1), closeTo(1, 1e-9));

      // cos(38°) = 0.78801, and the 0.9 uniform scale on top of it.
      final Matrix4 start = ElReveal.transformAt(0);
      expect(start.storage[0], closeTo(0.9 * 0.78801, 1e-4));
      // Ruling M4: no perspective on the element or any ancestor, so the
      // matrix's perspective entry stays untouched.
      expect(start.storage[11], 0);
      expect(ElReveal.transformAt(1).storage[0], closeTo(1, stopTolerance));
    });

    test('the sweep bar grows 0 → 1 on --ease-out', () {
      expect(ElSweep.widthFactor.transform(0), 0);
      expect(ElSweep.widthFactor.transform(1), 1);
      expect(
        ElSweep.widthFactor.transform(0.5),
        greaterThan(0.5),
        reason: '--ease-out is front-loaded',
      );
    });
  });

  group('yuki-sign-on', () {
    test('cuts rather than interpolates', () {
      for (final ElSignOnFrame frame in ElSignOn.frames.skip(1)) {
        final double t = frame.percent / 100;
        expect(ElSignOn.frameAt(t), same(frame));

        final ElSignOnFrame before = ElSignOn.frameAt(t - 1e-9);
        expect(before.percent, lessThan(frame.percent));
        expect(before.opacity, isNot(frame.opacity));

        // Just before the cut is still wholly the old frame, just after is
        // wholly the new one. Nothing in between is ever produced.
        expect(ElSignOn.frameAt(t - 1e-6).opacity, before.opacity);
        expect(ElSignOn.frameAt(t + 1e-6).opacity, frame.opacity);
      }
    });

    test('opens dark at 0.12 and brightness 0.5, unlit', () {
      final ElSignOnFrame first = ElSignOn.frameAt(0);
      expect(first.percent, 0);
      expect(first.opacity, 0.12);
      expect(first.brightness, 0.5);
      expect(first.glowBlurs, isEmpty, reason: 'text-shadow: none');
    });

    test('rests lit, not neutral — `both` holds the 70% frame', () {
      final ElSignOnFrame resting = ElSignOn.frameAt(1);
      expect(resting.percent, 70);
      expect(resting.opacity, 1);
      expect(resting.brightness, 1.15);
      expect(resting.glowBlurs, <double>[6, 18]);

      // Ruling M3: the live filter ships, the map's colour table is the oracle.
      expect(
        resting.brightnessFilter,
        const ColorFilter.matrix(<double>[
          1.15, 0, 0, 0, 0, //
          0, 1.15, 0, 0, 0, //
          0, 0, 1.15, 0, 0, //
          0, 0, 0, 1, 0, //
        ]),
      );

      // `text-shadow: 0 0 Npx` → offset 0, blur N, σ = N/2 — inverted through
      // the same arithmetic ElShadowLayer.blurRadius uses for box-shadow.
      final List<Shadow> glow = resting.shadows(ElThemeData.dark.valueInk);
      expect(glow, hasLength(2));
      expect(glow.first.offset, Offset.zero);
      expect(glow.first.color, ElThemeData.dark.valueInk);
      expect(glow.first.blurRadius, closeTo((6 / 2 - 0.5) / 0.57735, 1e-9));
      expect(glow.last.blurRadius, closeTo((18 / 2 - 0.5) / 0.57735, 1e-9));
    });
  });

  group('pulls-shimmer', () {
    // The named-animation panel body at the 1440 frame.
    const double w = 299.333;

    test('slides one 2W tile from -2W to +2W, band -W to +3W', () {
      expect(ElShimmer.tileWidth(w), closeTo(2 * w, 1e-9));
      expect(ElShimmer.offsetAt(0, w), closeTo(-2 * w, 1e-9));
      expect(ElShimmer.offsetAt(1, w), closeTo(2 * w, 1e-9));
      expect(ElShimmer.bandCenterAt(0, w), closeTo(-w, 1e-9));
      expect(ElShimmer.bandCenterAt(1, w), closeTo(3 * w, 1e-9));

      // One crossing per cycle, left to right, never back.
      double previous = ElShimmer.bandCenterAt(0, w);
      for (int i = 1; i <= 20; i++) {
        final double next = ElShimmer.bandCenterAt(i / 20, w);
        expect(next, greaterThan(previous));
        previous = next;
      }
    });

    test('takes its colours from the live theme, never frozen', () {
      expect(ElShimmer.gradient(ElThemeData.dark).colors, <Color>[
        ElThemeData.dark.popover,
        ElThemeData.dark.accent,
        ElThemeData.dark.popover,
      ]);
      expect(
        ElShimmer.gradient(ElThemeData.light).colors.first,
        ElThemeData.light.popover,
      );
      expect(ElShimmer.gradient(ElThemeData.dark).stops, <double>[0, 0.5, 1]);
    });
  });

  group('travel chip', () {
    test('is the verified no-op on a 24px chip (ruling M1)', () {
      expect(ElTravel.inset, el(6));
      expect(ElTravel.inset, 24);

      // `calc(100% - 1.5rem)` where `100%` is the chip's own 24px border box.
      expect(ElTravel.distanceFor(24), 0);
      expect(ElTravel.translationAt(0, 24, curve: ElCurves.out), 0);
      expect(ElTravel.translationAt(0.5, 24, curve: ElCurves.spring), 0);
      expect(ElTravel.translationAt(1, 24, curve: ElCurves.out), 0);

      // …and stays honest if the utility is ever put on a wider element.
      expect(ElTravel.distanceFor(482), 458);
      expect(ElTravel.translationAt(0, 482, curve: ElCurves.out), 0);
      expect(
        ElTravel.translationAt(1, 482, curve: ElCurves.out),
        closeTo(458, 1e-9),
      );
    });
  });

  group('ElKeyframePlayer', () {
    Future<double> freezeFrame(
      WidgetTester t, {
      required Duration duration,
      required ElKeyframeFill fill,
      required bool repeat,
    }) async {
      double seen = -1;
      await t.pumpWidget(
        stilledHost(
          ElKeyframePlayer(
            duration: duration,
            fill: fill,
            repeat: repeat,
            builder: (BuildContext c, double progress, Widget? child) {
              seen = progress;
              return const SizedBox(width: 40, height: 40);
            },
          ),
        ),
      );
      await t.pump();
      return seen;
    }

    testWidgets(
      'reduced motion holds a both-fill animation at its final stop',
      (WidgetTester t) async {
        expect(
          await freezeFrame(
            t,
            duration: ElPopIn.duration,
            fill: ElPopIn.fill,
            repeat: false,
          ),
          1.0,
        );
        expect(ElPopIn.opacity.transform(1), 1);
        expect(
          ElPopIn.scale.transform(1),
          offsetMoreOrLessEquals(const Offset(1, 1), epsilon: 1e-9),
        );
      },
    );

    testWidgets('reduced motion reverts each no-fill looper to stop 0', (
      WidgetTester t,
    ) async {
      // Ruling M7: one collapsed iteration and no fill mode means the element's
      // own transform — the ratchet lands on 0°, not 315° and not 360°.
      expect(
        await freezeFrame(
          t,
          duration: ElRatchet.duration,
          fill: ElRatchet.fill,
          repeat: true,
        ),
        0.0,
      );
      expect(ElRatchet.degreesAt(0), 0);

      expect(
        await freezeFrame(
          t,
          duration: ElShimmer.duration,
          fill: ElShimmer.fill,
          repeat: true,
        ),
        0.0,
      );

      expect(
        await freezeFrame(
          t,
          duration: ElPulseLive.duration,
          fill: ElPulseLive.fill,
          repeat: true,
        ),
        0.0,
      );
      // Stop 0 is a ring of exactly the dot's radius, i.e. hidden behind it —
      // motion-map §8.2's "plain 8px dot, no ring, opacity 1".
      expect(ElPulseLive.ringRadiusAt(0), ElPulseLive.dotRadius);
      expect(ElPulseLive.ringAlphaAt(0), ElPulseLive.ringAlpha);
      expect(ElPulseLive.dotOpacityAt(0), 1);
    });

    testWidgets('a looper runs, fenced off behind a RepaintBoundary', (
      WidgetTester t,
    ) async {
      double seen = -1;
      await t.pumpWidget(
        host(
          ElKeyframePlayer(
            duration: ElRatchet.duration,
            fill: ElRatchet.fill,
            repeat: true,
            builder: (BuildContext c, double progress, Widget? child) {
              seen = progress;
              return const SizedBox(width: 40, height: 40);
            },
          ),
        ),
      );

      expect(
        find.descendant(
          of: find.byType(ElKeyframePlayer),
          matching: find.byType(RepaintBoundary),
        ),
        findsOneWidget,
      );

      // No pumpAndSettle: this one never settles.
      await t.pump();
      for (int i = 0; i < 4; i++) {
        await t.pump(ElDurations.ratchetStep);
      }
      expect(seen, greaterThan(0));
      expect(ElRatchet.degreesAt(seen) % 45, closeTo(0, 1e-9));

      // Unmount so the infinite ticker is disposed with the test.
      await t.pumpWidget(const SizedBox());
    });

    testWidgets('a finite player starts at 0 and lands on its final stop', (
      WidgetTester t,
    ) async {
      double seen = -1;
      await t.pumpWidget(
        host(
          ElKeyframePlayer(
            duration: ElPopIn.duration,
            fill: ElPopIn.fill,
            builder: (BuildContext c, double progress, Widget? child) {
              seen = progress;
              return const SizedBox(width: 40, height: 40);
            },
          ),
        ),
      );

      await t.pump();
      expect(seen, 0, reason: 'a freshly mounted demo starts at t=0');
      await t.pump(ElDurations.popIn);
      expect(seen, 1.0);
    });
  });

  group('ElSlidingPillGroup under reduced motion', () {
    const Key pillKey = Key('pill');

    Widget pillGroup(int active) => stilledHost(
      SizedBox(
        width: 300,
        child: ElSlidingPillGroup(
          activeIndex: active,
          pill: const SizedBox.expand(key: pillKey),
          gap: 1,
          padding: EdgeInsets.all(el(0.5)),
          children: <Widget>[
            for (int i = 0; i < 3; i++)
              SizedBox(key: ValueKey<int>(i), width: 28, height: 28),
          ],
        ),
      ),
    );

    // Regression: the arrival squash used to run at its full 600ms whatever the
    // platform asked for, because the controller's duration was set once at
    // field init instead of being re-read through elAnimationDuration.
    testWidgets('the arrival jelly does not squash', (WidgetTester t) async {
      await t.pumpWidget(pillGroup(0));
      await t.pump();

      await t.pumpWidget(pillGroup(1));
      await t.pump();

      final ({double x, double y}) scale = scaleOf(
        t,
        find.byType(ElSlidingPillGroup),
      );
      expect(scale.x, 1.0);
      expect(scale.y, 1.0);
    });
  });
}
