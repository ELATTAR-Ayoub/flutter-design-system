/// The shared activation contract, tested once here so leaves need not repeat
/// it.
///
/// `Press` is the seam every clickable surface that is not a `Button` goes
/// through. If it is a complete control, nineteen call sites are complete
/// controls; if it is a squish with a tap handler, nineteen call sites are
/// unreachable by keyboard and unnamed to a screen reader. That is why the
/// contract lives at this level rather than being re-asserted per component.
library;

import 'dart:ui' show Tristate;
import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/material.dart' show MaterialApp, Material;
import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart'
    hide
        AspectRatio,
        Icon,
        OverlayPortal,
        RichText,
        SafeArea,
        ScrollPosition,
        Table,
        TableColumnWidth;
import 'package:flutter_test/flutter_test.dart';

/// A real app root.
///
/// Not decoration: `FocusableActionDetector` answers Enter and Space through
/// the ambient shortcut map, and Tab traverses through the root traversal
/// group. Both come from `WidgetsApp`, so a bare `Directionality` host would
/// test a control with no keyboard bindings in scope and call the silence a
/// pass.
Widget host(Widget child, {ColorMode mode = ColorMode.dark}) => ThemeScope(
  controller: ThemeController(mode: mode),
  child: MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Builder(
      builder: (BuildContext context) => DefaultTextStyle(
        style: StyledText.styleOf(
          context,
          TextStyles.body,
          color: ThemeScope.of(context).foreground,
        ),
        child: Material(child: Center(child: child)),
      ),
    ),
  ),
);

void main() {
  group('Press without a callback is a decoration', () {
    testWidgets('it adds no button to the semantics tree', (
      WidgetTester t,
    ) async {
      final SemanticsHandle handle = t.ensureSemantics();
      await t.pumpWidget(host(const Press(child: Text('inert'))));

      expect(
        find.byWidgetPredicate(
          (Widget w) => w is Semantics && (w.properties.button ?? false),
        ),
        findsNothing,
      );
      handle.dispose();
    });

    testWidgets('it takes no focus', (WidgetTester t) async {
      await t.pumpWidget(host(const Press(child: Text('inert'))));
      expect(find.byType(FocusableActionDetector), findsNothing);
    });

    testWidgets('it still squishes under a pointer', (WidgetTester t) async {
      await t.pumpWidget(
        host(const Press(child: SizedBox.square(dimension: 40))),
      );
      final TestGesture gesture = await t.startGesture(
        t.getCenter(find.byType(Press)),
      );
      await t.pump();
      await t.pump(MotionDurations.pressIn);

      final Transform transform = t.widget<Transform>(
        find.descendant(
          of: find.byType(Press),
          matching: find.byType(Transform),
        ),
      );
      // storage[0] is the x scale. `getMaxScaleOnAxis` would answer 1.0
      // forever: a 2D scale leaves z alone, and z is the largest axis.
      expect(
        transform.transform.storage[0],
        closeTo(MotionTransforms.press, 1e-6),
        reason: 'the feel is the part a decoration keeps',
      );
      await gesture.up();
    });
  });

  group('Press with a callback is a complete control', () {
    testWidgets('it is announced as a button, with the name it was given', (
      WidgetTester t,
    ) async {
      final SemanticsHandle handle = t.ensureSemantics();
      await t.pumpWidget(
        host(
          Press(
            semanticLabel: 'Open settings',
            onTap: () {},
            child: const SizedBox.square(dimension: 24),
          ),
        ),
      );

      expect(find.bySemanticsLabel('Open settings'), findsOneWidget);
      final SemanticsNode node = t.getSemantics(
        find.bySemanticsLabel('Open settings'),
      );
      expect(node.flagsCollection.isButton, isTrue);
      expect(node.flagsCollection.isEnabled, Tristate.isTrue);
      expect(node.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);
      handle.dispose();
    });

    testWidgets('a tap runs the callback exactly once', (WidgetTester t) async {
      int taps = 0;
      await t.pumpWidget(
        host(
          Press(
            onTap: () => taps++,
            child: const SizedBox.square(dimension: 40),
          ),
        ),
      );
      await t.tap(find.byType(Press));
      await t.pumpAndSettle();
      expect(taps, 1);
    });

    testWidgets('Enter and Space activate it, like every other control', (
      WidgetTester t,
    ) async {
      int taps = 0;
      await t.pumpWidget(
        host(
          Press(
            autofocus: true,
            onTap: () => taps++,
            child: const SizedBox.square(dimension: 40),
          ),
        ),
      );
      await t.pump();

      await t.sendKeyEvent(LogicalKeyboardKey.enter);
      await t.pumpAndSettle();
      expect(taps, 1, reason: 'Enter');

      await t.sendKeyEvent(LogicalKeyboardKey.space);
      await t.pumpAndSettle();
      expect(taps, 2, reason: 'Space');
    });

    testWidgets('it is reachable by Tab', (WidgetTester t) async {
      await t.pumpWidget(
        host(
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Press(onTap: () {}, child: const Text('first')),
              Press(onTap: () {}, child: const Text('second')),
            ],
          ),
        ),
      );
      await t.pump();

      await t.sendKeyEvent(LogicalKeyboardKey.tab);
      await t.pump();
      final FocusNode? first = FocusManager.instance.primaryFocus;
      expect(first, isNotNull);

      await t.sendKeyEvent(LogicalKeyboardKey.tab);
      await t.pump();
      expect(FocusManager.instance.primaryFocus, isNot(first));
    });

    testWidgets('keyboard focus paints a ring; a pointer does not', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        host(Press(onTap: () {}, child: const SizedBox.square(dimension: 40))),
      );

      bool ringPainted() => t
          .widgetList<CustomPaint>(find.byType(CustomPaint))
          .any((CustomPaint p) => p.foregroundPainter != null);

      expect(ringPainted(), isFalse, reason: 'at rest');

      await t.tap(find.byType(Press));
      await t.pumpAndSettle();
      expect(
        ringPainted(),
        isFalse,
        reason: 'a pointer does not raise the focus highlight',
      );

      await t.sendKeyEvent(LogicalKeyboardKey.tab);
      await t.pumpAndSettle();
      expect(ringPainted(), isTrue, reason: 'keyboard focus is visible');
    });

    testWidgets('disabled: announced, not focusable, not activatable', (
      WidgetTester t,
    ) async {
      final SemanticsHandle handle = t.ensureSemantics();
      int taps = 0;
      await t.pumpWidget(
        host(
          Press(
            enabled: false,
            semanticLabel: 'Open settings',
            onTap: () => taps++,
            child: const SizedBox.square(dimension: 40),
          ),
        ),
      );

      final SemanticsNode node = t.getSemantics(
        find.bySemanticsLabel('Open settings'),
      );
      expect(node.flagsCollection.isEnabled, Tristate.isFalse);
      expect(
        // `SemanticsFlags` exposes the enabled state as a tristate rather
        // than as two booleans: "not stated" is a third answer, and it is the
        // wrong one here — a control that omits the state announces as
        // ordinary text.
        node.flagsCollection.isEnabled,
        isNot(Tristate.none),
        reason: 'a disabled control says so rather than going quiet',
      );

      await t.tap(find.byType(Press), warnIfMissed: false);
      await t.pumpAndSettle();
      expect(taps, 0);

      await t.sendKeyEvent(LogicalKeyboardKey.tab);
      await t.pump();
      await t.sendKeyEvent(LogicalKeyboardKey.enter);
      await t.pumpAndSettle();
      expect(taps, 0, reason: 'nor by keyboard');
      handle.dispose();
    });

    testWidgets('it wears the click cursor while enabled', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        host(Press(onTap: () {}, child: const SizedBox.square(dimension: 40))),
      );
      final TestGesture gesture = await t.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      await gesture.moveTo(t.getCenter(find.byType(Press)));
      await t.pump();

      expect(
        RendererBinding.instance.mouseTracker.debugDeviceActiveCursor(1),
        SystemMouseCursors.click,
      );
    });

    testWidgets('reduced motion stills the squish without losing the tap', (
      WidgetTester t,
    ) async {
      int taps = 0;
      await t.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: host(
            Press(
              onTap: () => taps++,
              child: const SizedBox.square(dimension: 40),
            ),
          ),
        ),
      );

      await t.tap(find.byType(Press));
      await t.pumpAndSettle();
      expect(taps, 1);
    });
  });

  group('a small control still answers a finger', () {
    testWidgets('the hit target is at least the platform minimum', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        host(Press(onTap: () {}, child: const SizedBox.square(dimension: 16))),
      );

      final Rect target = TapTarget.debugTarget(
        t.renderObject(find.byType(TapTarget)),
      );
      expect(target.width, greaterThanOrEqualTo(TouchTargets.minimum));
      expect(target.height, greaterThanOrEqualTo(TouchTargets.minimum));
    });

    testWidgets('layout is untouched — the box is still its own size', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        host(Press(onTap: () {}, child: const SizedBox.square(dimension: 16))),
      );
      expect(t.getSize(find.byType(TapTarget)), const Size(16, 16));
    });

    testWidgets('a tap just outside the visual box still activates it', (
      WidgetTester t,
    ) async {
      int taps = 0;
      await t.pumpWidget(
        host(
          Press(
            onTap: () => taps++,
            child: const SizedBox.square(dimension: 16),
          ),
        ),
      );

      final Rect box = t.getRect(find.byType(TapTarget));
      // Ten pixels past the visual edge, inside the 44px floor.
      await t.tapAt(Offset(box.right + 10, box.center.dy));
      await t.pumpAndSettle();
      expect(taps, 1);
    });

    testWidgets('a target already big enough is not grown', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        host(Press(onTap: () {}, child: const SizedBox.square(dimension: 60))),
      );
      final Rect target = TapTarget.debugTarget(
        t.renderObject(find.byType(TapTarget)),
      );
      expect(target, const Rect.fromLTWH(0, 0, 60, 60));
    });
  });
}
