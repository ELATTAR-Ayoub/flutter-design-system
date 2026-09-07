import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart'
    hide AspectRatio, Form, FormField, Icon, OverlayPortal, RadioGroup, RichText, SafeArea, ScrollPosition, Table, TableColumnWidth;
import 'package:flutter_test/flutter_test.dart';

// A real [Overlay] ancestor is required: [Tooltip] shows its content through
// an [OverlayPortal], which asserts one exists. `Overlay(initialEntries: …)`
// only reads its entries once (on first build), so a widget swapped in via a
// later `pumpWidget` call would never reach the screen; routing the `home`
// through [WidgetsApp] keeps every rebuild live.
Widget _host(Widget child) => MediaQuery(
  data: const MediaQueryData(size: Size(1440, 900)),
  child: Directionality(
    textDirection: TextDirection.ltr,
    child: ThemeScope(
      controller: ThemeController(mode: ColorMode.dark),
      child: WidgetsApp(
        color: const Color(0xFF000000),
        pageRouteBuilder: <T>(RouteSettings settings, WidgetBuilder builder) =>
            PageRouteBuilder<T>(
              settings: settings,
              pageBuilder: (BuildContext context, Animation<double> a, Animation<double> b) => builder(context),
            ),
        home: Center(child: child),
      ),
    ),
  ),
);

double _dim(WidgetTester t) => t
    .widgetList<Opacity>(find.descendant(of: find.byType(Disabled), matching: find.byType(Opacity)))
    .map((Opacity o) => o.opacity)
    .reduce((double a, double b) => a < b ? a : b);

void main() {
  testWidgets('enabled renders the child at full opacity and lets taps through', (WidgetTester t) async {
    int taps = 0;
    await t.pumpWidget(_host(Disabled(
      disabled: false,
      child: GestureDetector(behavior: HitTestBehavior.opaque, onTap: () => taps++, child: const SizedBox(width: 80, height: 40)),
    )));
    await t.pumpAndSettle();
    expect(_dim(t), 1);
    await t.tap(find.byType(SizedBox));
    expect(taps, 1);
  });

  testWidgets('disabled fades to the token and blocks the child', (WidgetTester t) async {
    int taps = 0;
    await t.pumpWidget(_host(Disabled(
      disabled: true,
      child: GestureDetector(behavior: HitTestBehavior.opaque, onTap: () => taps++, child: const SizedBox(width: 80, height: 40)),
    )));
    await t.pumpAndSettle();
    expect(_dim(t), SurfaceOpacity.disabled);
    await t.tap(find.byType(SizedBox), warnIfMissed: false);
    expect(taps, 0);
  });

  testWidgets('disabled with blockPointer false keeps the child hittable', (WidgetTester t) async {
    int taps = 0;
    await t.pumpWidget(_host(Disabled(
      disabled: true,
      blockPointer: false,
      child: GestureDetector(behavior: HitTestBehavior.opaque, onTap: () => taps++, child: const SizedBox(width: 80, height: 40)),
    )));
    await t.pumpAndSettle();
    await t.tap(find.byType(SizedBox));
    expect(taps, 1);
  });

  testWidgets('onDisabledTap fires only while disabled', (WidgetTester t) async {
    int hits = 0;
    Widget build(bool disabled) => _host(Disabled(
      disabled: disabled,
      onDisabledTap: () => hits++,
      child: const SizedBox(width: 80, height: 40),
    ));
    await t.pumpWidget(build(false));
    await t.tap(find.byType(SizedBox));
    expect(hits, 0);
    await t.pumpWidget(build(true));
    await t.pumpAndSettle();
    await t.tap(find.byType(SizedBox), warnIfMissed: false);
    expect(hits, 1);
  });

  testWidgets('no reason means no Tooltip in the tree', (WidgetTester t) async {
    await t.pumpWidget(_host(const Disabled(disabled: true, child: SizedBox(width: 80, height: 40))));
    expect(find.byType(Tooltip), findsNothing);
  });

  testWidgets('a reason shows on hover while disabled', (WidgetTester t) async {
    await t.pumpWidget(_host(const Disabled(
      disabled: true,
      reason: 'Finish the form first',
      child: SizedBox(width: 80, height: 40),
    )));
    final TestGesture mouse = await t.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    addTearDown(mouse.removePointer);
    await mouse.moveTo(t.getCenter(find.byType(SizedBox)));
    await t.pump(MotionDurations.tooltipShowDelay + MotionDurations.overlayEnter);
    await t.pumpAndSettle();
    expect(find.text('Finish the form first'), findsOneWidget);
  });

  testWidgets('a reason shows on touch tap while disabled', (WidgetTester t) async {
    await t.pumpWidget(_host(const Disabled(
      disabled: true,
      reason: 'Finish the form first',
      child: SizedBox(width: 80, height: 40),
    )));
    final TestGesture finger = await t.createGesture(kind: PointerDeviceKind.touch);
    await finger.down(t.getCenter(find.byType(SizedBox)));
    await finger.up();
    await t.pump(MotionDurations.overlayEnter);
    expect(find.text('Finish the form first'), findsOneWidget);
    await t.pump(Tooltip.touchDwell + MotionDurations.overlayExit);
    await t.pumpAndSettle();
  });

  testWidgets('a reason on an enabled control shows nothing', (WidgetTester t) async {
    await t.pumpWidget(_host(const Disabled(
      disabled: false,
      reason: 'never',
      child: SizedBox(width: 80, height: 40),
    )));
    final TestGesture mouse = await t.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    addTearDown(mouse.removePointer);
    await mouse.moveTo(t.getCenter(find.byType(SizedBox)));
    await t.pump(MotionDurations.tooltipShowDelay + MotionDurations.overlayEnter);
    await t.pumpAndSettle();
    expect(find.text('never'), findsNothing);
  });

  testWidgets('toggling disabled keeps the child State alive', (WidgetTester t) async {
    Widget build(bool disabled) => _host(Disabled(
      disabled: disabled,
      child: const _CounterChild(),
    ));

    await t.pumpWidget(build(false));
    final _CounterChildState state = t.state<_CounterChildState>(find.byType(_CounterChild));
    state.bump();
    expect(state.count, 1);

    await t.pumpWidget(build(true));
    await t.pumpAndSettle();
    expect(
      t.state<_CounterChildState>(find.byType(_CounterChild)).count,
      1,
    );

    await t.pumpWidget(build(false));
    await t.pumpAndSettle();
    expect(
      t.state<_CounterChildState>(find.byType(_CounterChild)).count,
      1,
    );
  });
}

/// A child whose [State] holds a counter, used to prove [Disabled] keeps the
/// same element (and therefore the same State) alive across a toggle.
class _CounterChild extends StatefulWidget {
  const _CounterChild();

  @override
  State<_CounterChild> createState() => _CounterChildState();
}

class _CounterChildState extends State<_CounterChild> {
  int count = 0;

  void bump() => setState(() => count++);

  @override
  Widget build(BuildContext context) => const SizedBox(width: 80, height: 40);
}
