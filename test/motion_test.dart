import 'dart:io';

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart'
    hide
        AspectRatio,
        Form,
        FormField,
        Icon,
        OverlayPortal,
        RadioGroup,
        RichText,
        SafeArea,
        ScrollPosition,
        Table,
        TableColumnWidth;
import 'package:flutter_test/flutter_test.dart';

/// Retired 2026-09-22 with the fourteen. A symbol here may appear only in
/// CHANGELOG.md and docs/references/motion-rename.md.
const List<String> kRetiredMotionSymbols = <String>[
  'EntranceMotion',
  'SpringEntranceMotion',
  'StateChangeMotion',
  'DiscreteProgressMotion',
  'TextRevealMotion',
  'TextRevealFrame',
  'RevealMotion',
  'LoadingShimmerMotion',
  'LivePulseMotion',
  'SweepMotion',
  'TravelMotion',
  'CheckmarkDrawMotion',
  'DashDrawMotion',
  'DotSelectionMotion',
  'ContentSwapMotion',
  'FadeUp',
  'RowMotion',
  'MenuMotion',
  'InteractiveCard',
  '_PanelIn',
  '_FadeIn',
  '_ConfirmSlide',
  'BlurSwitchController',
  'MotionDurations.reward',
  'MotionDurations.popIn',
  'MotionDurations.springUp',
  'MotionDurations.signOn',
  'MotionDurations.ratchet',
  'MotionDurations.checkDraw',
  'MotionDurations.dashDraw',
  'MotionDurations.dotPop',
  'MotionDurations.pressSpringUp',
  'MotionDurations.copyConfirmation',
  'MotionDurations.liftY',
  'MotionDurations.keyDownY',
  'MotionDurations.frame',
  'MotionDurations.overlayExit',
  'MotionDurations.close',
  'MotionDurations.collapse',
  'MotionTransforms.clickSpringScale',
  'MotionTransforms.pressSpringScale',
  'MotionTransforms.buttonPress',
  'MotionTransforms.sliderThumbHoverScale',
  'MotionTransforms.sliderThumbActiveScale',
  'MotionTransforms.liftY',
  'MotionTransforms.keyDownY',
  'MotionCurves.balanced',
  'MotionCurves.decelerate',
  'MotionCurves.symmetric',
  'MotionCurves.linear',
  'MotionCurves.vaul',
  'yuki-',
  'pulls-',
  'globals.css L',
];

/// The motion layer: the three interaction utilities the shell and the docs
/// pages are built out of — `press`, `lift`, and the travelling `slide-pill`
/// with its `anim-jelly` arrival — and the keyframe layer underneath the named
/// animations.

Widget host(Widget child, {ColorMode mode = ColorMode.dark}) {
  return MediaQuery(
    data: const MediaQueryData(size: Size(1440, 900)),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: ThemeScope(
        controller: ThemeController(mode: mode),
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
Widget stilledHost(Widget child, {ColorMode mode = ColorMode.dark}) => host(
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
  group('Press', () {
    testWidgets('squishes on pointer-down and springs back on up', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        host(Press(child: const SizedBox(width: 80, height: 32))),
      );

      final Finder press = find.byType(Press);
      expect(scaleOf(t, press).x, 1.0, reason: 'at rest');

      final TestGesture gesture = await t.startGesture(t.getCenter(press));
      await t.pump(); // the ticker's first frame is its zero point
      await t.pump(MotionDurations.pressIn);
      expect(scaleOf(t, press).x, closeTo(MotionTransforms.press, 1e-6));
      expect(scaleOf(t, press).y, closeTo(MotionTransforms.press, 1e-6));

      await gesture.up();
      await t.pump();
      await t.pump(MotionDurations.normal);
      expect(scaleOf(t, press).x, closeTo(1.0, 1e-6));
    });

    testWidgets('down is far quicker than the spring back', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        host(Press(child: const SizedBox(width: 80, height: 32))),
      );
      final Finder press = find.byType(Press);

      final TestGesture gesture = await t.startGesture(t.getCenter(press));
      await t.pump();
      await t.pump(MotionDurations.pressIn);
      await gesture.up();

      // The asymmetry globals.css calls "the whole feel": 40ms down, 250ms
      // back. One press-length into the return the surface is still squished.
      await t.pump();
      await t.pump(MotionDurations.pressIn);
      expect(scaleOf(t, press).x, lessThan(1.0));

      await t.pump(MotionDurations.normal);
      expect(scaleOf(t, press).x, closeTo(1.0, 1e-6));
    });

    testWidgets('a cancelled press still returns', (WidgetTester t) async {
      int taps = 0;
      await t.pumpWidget(
        host(
          Press(
            onTap: () => taps++,
            child: const SizedBox(width: 80, height: 32),
          ),
        ),
      );
      final Finder press = find.byType(Press);

      final TestGesture gesture = await t.startGesture(t.getCenter(press));
      await t.pump();
      await t.pump(MotionDurations.pressIn);
      await gesture.cancel();
      await t.pump();
      await t.pump(MotionDurations.normal);

      expect(scaleOf(t, press).x, closeTo(1.0, 1e-6));
      expect(taps, 0, reason: 'a cancelled press is not a tap');
    });

    testWidgets('fires onTap', (WidgetTester t) async {
      int taps = 0;
      await t.pumpWidget(
        host(
          Press(
            onTap: () => taps++,
            child: const SizedBox(width: 80, height: 32),
          ),
        ),
      );

      await t.tap(find.byType(Press));
      await t.pump(MotionDurations.normal);
      expect(taps, 1);
    });

    testWidgets('presses to MotionTransforms.press, the one click feel', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        host(Press(child: const SizedBox(width: 80, height: 32))),
      );
      final Finder press = find.byType(Press);

      await t.startGesture(t.getCenter(press));
      await t.pump();
      await t.pump(MotionDurations.pressIn);
      expect(scaleOf(t, press).x, closeTo(MotionTransforms.press, 1e-6));
    });
  });

  group('HoverBuilder', () {
    testWidgets('reports hover to its builder', (WidgetTester t) async {
      final List<bool> states = <bool>[];
      await t.pumpWidget(
        host(
          HoverBuilder(
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

      await mouse.moveTo(t.getCenter(find.byType(HoverBuilder)));
      await t.pump();
      expect(states.last, isTrue);

      await mouse.moveTo(Offset.zero);
      await t.pump();
      expect(states.last, isFalse);
    });
  });

  group('ActiveIndicator', () {
    const Key pillKey = Key('pill');
    final List<Key> itemKeys = List<Key>.generate(
      3,
      (int i) => ValueKey<int>(i),
    );

    Widget group(int active, {double itemWidth = 28, Duration? travel}) => host(
      SizedBox(
        width: 300,
        child: ActiveIndicator(
          activeIndex: active,
          indicator: const SizedBox.expand(key: pillKey),
          gap: 1,
          padding: EdgeInsets.all(space(0.5)),
          moveDuration: travel,
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
            of: find.byType(ActiveIndicator),
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
      expect(scaleOf(t, find.byType(ActiveIndicator)).x, 1.0);

      await t.pump(const Duration(milliseconds: 180));
      // 30% of yuki-jelly's 600ms: scale3d(1.18, 0.82, 1).
      final ({double x, double y}) squashed = scaleOf(
        t,
        find.byType(ActiveIndicator),
      );
      expect(squashed.x, closeTo(1.18, 0.01));
      expect(squashed.y, closeTo(0.82, 0.01));

      await t.pump(MotionDurations.stateChange);
      expect(scaleOf(t, find.byType(ActiveIndicator)).x, closeTo(1, 1e-6));
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

      await t.pump(MotionDurations.stateChange);
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
        find.byType(ActiveIndicator),
      );
      expect(squashed.x, closeTo(1.18, 0.03));
      expect(squashed.y, closeTo(0.82, 0.03));

      await t.pump(MotionDurations.stateChange);
      final ({double x, double y}) settled = scaleOf(
        t,
        find.byType(ActiveIndicator),
      );
      expect(settled.x, closeTo(1.0, 1e-6));
      expect(settled.y, closeTo(1.0, 1e-6));
    });

    testWidgets('T8/T8b — deselection fades in place: the rect is held, the '
        'squash does not replay', (WidgetTester t) async {
      await t.pumpWidget(group(1));
      await t.pump();
      await t.pump(MotionDurations.stateChange);
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
          scaleOf(t, find.byType(ActiveIndicator)).x,
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
      await t.pump(MotionDurations.stateChange);
      final Rect parked = t.getRect(find.byKey(pillKey));

      await t.pumpWidget(group(-1));
      await t.pump(MotionDurations.fast);
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
      await t.pump(MotionDurations.stateChange);
      expect(
        t.getRect(find.byKey(pillKey)),
        rectMoreOrLessEquals(t.getRect(find.byKey(itemKeys[0])), epsilon: 0.01),
      );
    });

    testWidgets('moveDuration: zero jumps and still squashes — the theme '
        'toggle\'s contract', (WidgetTester t) async {
      await t.pumpWidget(group(0, travel: Duration.zero));
      await t.pump();
      await t.pump(MotionDurations.stateChange);

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
      expect(scaleOf(t, find.byType(ActiveIndicator)).x, closeTo(1.18, 0.01));
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
      await t.pump(MotionDurations.stateChange);

      expect(t.getRect(find.byKey(pillKey)), isNot(before));
      expect(
        t.getRect(find.byKey(pillKey)),
        rectMoreOrLessEquals(t.getRect(find.byKey(itemKeys[1])), epsilon: 0.01),
      );
    });
  });

  // ── keyframes ─────────────────────────────────────────────────────────────

  group('StepCurve', () {
    test('steps(8) holds eight positions and never shows the wrap frame', () {
      const Curve steps = StepCurve(8);
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
    });

    test('jump-start is the other CSS variant', () {
      const Curve steps = StepCurve(2, jumpEnd: false);
      expect(
        steps.transform(0),
        closeTo(0.5, 1e-12),
        reason: 'jump-start takes its first step at t=0',
      );
      expect(steps.transform(0.75), 1);
      expect(steps.transform(1), 1);
    });
  });

  group('KeyframePlayer', () {
    Future<double> freezeFrame(
      WidgetTester t, {
      required Duration duration,
      required KeyframeFill fill,
      required bool repeat,
    }) async {
      double seen = -1;
      await t.pumpWidget(
        stilledHost(
          KeyframePlayer(
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
            duration: EnterMotion.duration,
            fill: EnterMotion.fill,
            repeat: false,
          ),
          1.0,
        );
        expect(EnterMotion.opacity.transform(1), 1);
        expect(EnterMotion.translateY.transform(1), 0);
      },
    );

    testWidgets('reduced motion reverts each no-fill looper to stop 0', (
      WidgetTester t,
    ) async {
      expect(
        await freezeFrame(
          t,
          duration: ShimmerMotion.duration,
          fill: ShimmerMotion.fill,
          repeat: true,
        ),
        0.0,
      );

      expect(
        await freezeFrame(
          t,
          duration: PulseMotion.duration,
          fill: PulseMotion.fill,
          repeat: true,
        ),
        0.0,
      );
      // Stop 0 is a ring of exactly the dot's radius, i.e. hidden behind it —
      // motion-map §8.2's "plain 8px dot, no ring, opacity 1".
      expect(PulseMotion.ringRadiusAt(0), PulseMotion.dotRadius);
      expect(PulseMotion.ringAlphaAt(0), PulseMotion.ringAlpha);
      expect(PulseMotion.dotOpacityAt(0), 1);
    });

    testWidgets('a looper runs, fenced off behind a RepaintBoundary', (
      WidgetTester t,
    ) async {
      double seen = -1;
      await t.pumpWidget(
        host(
          KeyframePlayer(
            duration: SpinMotion.duration,
            fill: SpinMotion.fill,
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
          of: find.byType(KeyframePlayer),
          matching: find.byType(RepaintBoundary),
        ),
        findsOneWidget,
      );

      // No pumpAndSettle: this one never settles.
      await t.pump();
      await t.pump(const Duration(milliseconds: 300));
      expect(seen, greaterThan(0));

      // Unmount so the infinite ticker is disposed with the test.
      await t.pumpWidget(const SizedBox());
    });

    testWidgets('a finite player starts at 0 and lands on its final stop', (
      WidgetTester t,
    ) async {
      double seen = -1;
      await t.pumpWidget(
        host(
          KeyframePlayer(
            duration: EnterMotion.duration,
            fill: EnterMotion.fill,
            builder: (BuildContext c, double progress, Widget? child) {
              seen = progress;
              return const SizedBox(width: 40, height: 40);
            },
          ),
        ),
      );

      await t.pump();
      expect(seen, 0, reason: 'a freshly mounted demo starts at t=0');
      await t.pump(EnterMotion.duration);
      expect(seen, 1.0);
    });
  });

  group('ActiveIndicator under reduced motion', () {
    const Key pillKey = Key('pill');

    Widget pillGroup(int active) => stilledHost(
      SizedBox(
        width: 300,
        child: ActiveIndicator(
          activeIndex: active,
          indicator: const SizedBox.expand(key: pillKey),
          gap: 1,
          padding: EdgeInsets.all(space(0.5)),
          children: <Widget>[
            for (int i = 0; i < 3; i++)
              SizedBox(key: ValueKey<int>(i), width: 28, height: 28),
          ],
        ),
      ),
    );

    // Regression: the arrival squash used to run at its full 600ms whatever the
    // platform asked for, because the controller's duration was set once at
    // field init instead of being re-read through effectiveMotionDuration.
    testWidgets('the arrival jelly does not squash', (WidgetTester t) async {
      await t.pumpWidget(pillGroup(0));
      await t.pump();

      await t.pumpWidget(pillGroup(1));
      await t.pump();

      final ({double x, double y}) scale = scaleOf(
        t,
        find.byType(ActiveIndicator),
      );
      expect(scale.x, 1.0);
      expect(scale.y, 1.0);
    });
  });

  group('the fourteen', () {
    final List<File> sources =
        <Directory>[
              Directory('lib'),
              Directory('example/lib'),
              Directory('test'),
            ]
            .expand((Directory d) => d.listSync(recursive: true))
            .whereType<File>()
            .where((File f) => f.path.endsWith('.dart'))
            .where((File f) => !f.path.endsWith('motion_test.dart'))
            .toList();

    test('no source names a retired motion symbol', () {
      final List<String> hits = <String>[];
      for (final File f in sources) {
        final String text = f.readAsStringSync();
        for (final String s in kRetiredMotionSymbols) {
          if (text.contains(s)) hits.add('${f.path}: $s');
        }
      }
      expect(hits, isEmpty, reason: hits.join('\n'));
    });

    test('keyframes.dart declares exactly the twelve recipes', () {
      final String text = File(
        'lib/src/components/ui/keyframes.dart',
      ).readAsStringSync();
      final Iterable<String> declared = RegExp(
        r'^class (\w+Motion) ',
        multiLine: true,
      ).allMatches(text).map((RegExpMatch m) => m.group(1)!);
      expect(declared.toSet(), <String>{
        'EnterMotion',
        'ExitMotion',
        'OpenMotion',
        'CloseMotion',
        'ExpandMotion',
        'ChangeMotion',
        'SpinMotion',
        'ShimmerMotion',
        'ProgressMotion',
        'PulseMotion',
        'CaretMotion',
        'SwapRollMotion',
      });
    });

    test('the press scale is 0.9 and there is only one', () {
      expect(MotionTransforms.press, 0.9);
    });

    test('EnterMotion rises 12 and fades in over slow on enter', () {
      expect(EnterMotion.duration, MotionDurations.slow);
      expect(EnterMotion.translateY.transform(0), 12);
      expect(EnterMotion.translateY.transform(1), 0);
      expect(EnterMotion.opacity.transform(1), 1);
      expect(EnterMotion.delayFor(2), MotionDurations.tick);
    });
    test('ExitMotion is faster than EnterMotion', () {
      expect(ExitMotion.duration < EnterMotion.duration, isTrue);
      expect(ExitMotion.opacity.transform(1), 0);
    });
    test('OpenMotion overshoots to 1.02 at 60% and CloseMotion drops 16', () {
      expect(OpenMotion.scale.transform(0.6), closeTo(1.02, 1e-9));
      expect(CloseMotion.translateY.transform(1), 16);
      expect(CloseMotion.duration < OpenMotion.duration, isTrue);
    });
    test('ChangeMotion squashes to 1.18×0.82 at 30%', () {
      expect(ChangeMotion.scale.transform(0.3), const Offset(1.18, 0.82));
    });
    test('CaretMotion is a hard blink', () {
      expect(CaretMotion.visibleAt(0.49), isTrue);
      expect(CaretMotion.visibleAt(0.5), isFalse);
    });
    test('ProgressMotion sweeps a third-width sliver off both edges', () {
      expect(ProgressMotion.fromFraction, -1);
      expect(ProgressMotion.toFraction, 3);
    });
  });
}
