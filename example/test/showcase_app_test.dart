import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/showcase/showcase_app.dart';
import 'package:flutter/material.dart'
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
        TableColumnWidth,
        ActionChip,
        AlertDialog,
        Badge,
        Card,
        CarouselController,
        Checkbox,
        Dialog,
        DropdownMenu,
        Drawer,
        DrawerHeader,
        Slider,
        Switch,
        TextFormField,
        Tooltip;
import 'package:flutter_test/flutter_test.dart';

const Size _phone = Size(390, 844);
const double _gestureBar = 34;

Finder _navigationButton(String label) => find.byWidgetPredicate(
  (Widget widget) => widget is Button && widget.label == label,
);

Semantics _selectionSemantics(WidgetTester tester, String label) => tester
    .widgetList<Semantics>(
      find.ancestor(
        of: _navigationButton(label),
        matching: find.byType(Semantics),
      ),
    )
    .firstWhere((Semantics semantics) => semantics.properties.selected != null);

void main() {
  testWidgets(
    'Profile is the initial destination and navigation order is fixed',
    (WidgetTester tester) async {
      await tester.pumpWidget(const SignalStudioApp());

      expect(
        _selectionSemantics(tester, 'Profile').properties.selected,
        isTrue,
      );
      expect(
        _selectionSemantics(tester, 'Dashboard').properties.selected,
        isFalse,
      );
      expect(_selectionSemantics(tester, 'Reels').properties.selected, isFalse);
      expect(
        tester.getRect(_navigationButton('Profile')).left,
        lessThan(tester.getRect(_navigationButton('Dashboard')).left),
      );
      expect(
        tester.getRect(_navigationButton('Dashboard')).left,
        lessThan(tester.getRect(_navigationButton('Reels')).left),
      );
      expect(find.text('Signal Studio'), findsNothing);
      expect(find.text('CREATOR CONTROL ROOM'), findsNothing);
    },
  );

  testWidgets('the header identity returns from Dashboard to Profile', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SignalStudioApp());
    await tester.tap(_navigationButton('Dashboard'));
    await tester.pump();
    await tester.pump(MotionDurations.fast);

    expect(
      _selectionSemantics(tester, 'Dashboard').properties.selected,
      isTrue,
    );
    await tester.tap(find.byKey(const Key('showcase-header-profile')));
    await tester.pump();

    expect(_selectionSemantics(tester, 'Profile').properties.selected, isTrue);
    expect(find.bySemanticsLabel('Open Ari Rocha profile'), findsOneWidget);
    expect(find.byKey(const Key('showcase-header-avatar')), findsOneWidget);
  });

  testWidgets('compact header keeps avatar, name, and controls grouped', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = _phone;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(SignalStudioApp(onOpenDesignSystem: () {}));
    await tester.pump();

    final Finder identity = find.byKey(const Key('showcase-header-profile'));
    final Finder avatar = find.byKey(const Key('showcase-header-avatar'));
    final Finder name = find.descendant(
      of: identity,
      matching: find.text('Ari Rocha'),
    );
    final Finder back = find.byWidgetPredicate(
      (Widget widget) =>
          widget is Button && widget.label == 'Back to design system',
    );
    final Finder theme = find.bySemanticsLabel('Colour theme');

    expect(avatar, findsOneWidget);
    expect(name, findsOneWidget);
    expect(
      tester.getRect(name).left - tester.getRect(avatar).right,
      closeTo(space(2), BorderWidths.hairline),
    );
    expect(
      tester.getRect(back).left,
      greaterThanOrEqualTo(tester.getRect(identity).right),
    );
    expect(
      tester.getRect(theme).left - tester.getRect(back).right,
      closeTo(space(2), BorderWidths.hairline),
    );
    expect(tester.getRect(identity).left, greaterThanOrEqualTo(space(4)));
    expect(
      tester.getRect(theme).right,
      lessThanOrEqualTo(_phone.width - space(4)),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'compact dock owns one travelling selection pill over ghost buttons',
    (WidgetTester tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = _phone;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(const SignalStudioApp());
      await tester.pump();

      final Finder dock = find.byKey(const Key('showcase-compact-dock'));
      final Finder group = find.descendant(
        of: dock,
        matching: find.byType(ActiveIndicator),
      );
      final Finder buttons = find.descendant(
        of: dock,
        matching: find.byType(Button),
      );

      expect(group, findsOneWidget);
      expect(tester.widget<ActiveIndicator>(group).activeIndex, 0);
      expect(buttons, findsNWidgets(3));
      expect(
        tester
            .widgetList<Button>(buttons)
            .map((Button button) => button.variant),
        everyElement(ButtonVariant.ghost),
      );
      expect(_selectionSemantics(tester, 'Profile').properties.selected, true);

      final Surface pill = tester.widget<Surface>(
        find.byKey(const Key('showcase-destination-pill')),
      );
      expect(pill.spec, same(Shadows.compactControl));
      expect(pill.radius, BorderRadius.circular(Radii.lg));
      expect(pill.fill, ThemeScope.of(tester.element(dock)).secondary);
    },
  );

  testWidgets('compact destination pill travels old to between to new', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = _phone;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const SignalStudioApp());
    await tester.pump();
    await tester.pump();
    await tester.pump(MotionDurations.stateChange);

    final Finder pill = find.byKey(const Key('showcase-destination-pill'));
    final double oldCenter = tester.getCenter(pill).dx;
    final double newCenter = tester
        .getCenter(_navigationButton('Dashboard'))
        .dx;

    await tester.tap(_navigationButton('Dashboard'));
    await tester.pump();
    await tester.pump(MotionDurations.tick);

    final double travellingCenter = tester.getCenter(pill).dx;
    expect(travellingCenter, greaterThan(oldCenter));
    expect(travellingCenter, lessThan(newCenter));

    await tester.pump(MotionDurations.normal);
    expect(
      tester.getCenter(pill).dx,
      closeTo(newCenter, BorderWidths.hairline),
    );
  });

  testWidgets('compact destination pill snaps under reduced motion', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = _phone;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const SignalStudioApp(reduceMotion: true));
    await tester.pump();
    await tester.pump();

    final Finder pill = find.byKey(const Key('showcase-destination-pill'));
    await tester.tap(_navigationButton('Reels'));
    await tester.pump();
    await tester.pump();

    expect(
      tester.getCenter(pill).dx,
      closeTo(
        tester.getCenter(_navigationButton('Reels')).dx,
        BorderWidths.hairline,
      ),
    );
  });

  testWidgets('header avatar aligns with reel content at compact widths', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    for (final double width in <double>[390, 800]) {
      tester.view.physicalSize = Size(width, LayoutWidths.page);
      await tester.pumpWidget(const SignalStudioApp());
      await tester.pump();
      await tester.tap(_navigationButton('Reels'));
      await tester.pump();

      final double avatarLeft = tester
          .getRect(find.byKey(const Key('showcase-header-avatar')))
          .left;
      final double reelContentLeft = tester
          .getRect(find.text('A quiet system for louder work.'))
          .left;
      expect(
        avatarLeft,
        closeTo(reelContentLeft, BorderWidths.hairline),
        reason: 'compact width $width should share the reel content measure',
      );
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('compact dock overlays a full-height IndexedStack', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = _phone;
    tester.view.padding = const FakeViewPadding(bottom: _gestureBar);
    tester.view.viewPadding = const FakeViewPadding(bottom: _gestureBar);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const SignalStudioApp());
    await tester.pump();

    final Finder dock = find.byKey(const Key('showcase-compact-dock'));
    expect(dock, findsOneWidget);
    expect(
      find.descendant(of: dock, matching: find.byType(BackdropFilter)),
      findsOneWidget,
    );
    expect(_selectionSemantics(tester, 'Profile').properties.selected, isTrue);
    expect(tester.getRect(dock).bottom, _phone.height - _gestureBar - space(3));
    expect(
      tester.getRect(find.byType(IndexedStack)).bottom,
      greaterThan(tester.getRect(dock).top),
    );
  });

  testWidgets('collapsed reel title stays above the fixed compact dock', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = _phone;
    tester.view.padding = const FakeViewPadding(bottom: _gestureBar);
    tester.view.viewPadding = const FakeViewPadding(bottom: _gestureBar);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const SignalStudioApp());
    await tester.tap(_navigationButton('Reels'));
    await tester.pump();

    final Finder dock = find.byKey(const Key('showcase-compact-dock'));
    final Finder title = find.text('A quiet system for louder work.');

    expect(title, findsOneWidget);
    expect(
      tester.getRect(title).bottom,
      lessThanOrEqualTo(tester.getRect(dock).top),
    );
    expect(
      tester.getRect(find.byType(IndexedStack)).bottom,
      greaterThan(tester.getRect(dock).top),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('compact navigation preserves destination-local state', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      SignalStudioApp(
        profileBuilder: (_) => const _ProfileStateProbe(),
        reelsBuilder: (_) => const SizedBox.shrink(),
      ),
    );

    await tester.tap(find.bySemanticsLabel('Increase profile draft'));
    await tester.pump();
    expect(find.text('Profile draft 1'), findsOneWidget);

    await tester.tap(_navigationButton('Reels'));
    await tester.pump();
    await tester.tap(_navigationButton('Profile'));
    await tester.pump();

    expect(find.text('Profile draft 1'), findsOneWidget);
    expect(_selectionSemantics(tester, 'Profile').properties.selected, isTrue);
  });

  testWidgets('Dashboard refresh settles through the shared toaster', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SignalStudioApp());
    await tester.tap(_navigationButton('Dashboard'));
    await tester.pump(MotionDurations.fast);
    await tester.pump();

    await tester.tap(find.widgetWithText(Button, 'Refresh').first);
    await tester.pump();
    expect(find.byType(Skeleton), findsWidgets);

    await tester.pump(MotionDurations.fast);
    await tester.pump();
    expect(find.text('Studio data is current'), findsOneWidget);
  });
}

class _ProfileStateProbe extends StatefulWidget {
  const _ProfileStateProbe();

  @override
  State<_ProfileStateProbe> createState() => _ProfileStateProbeState();
}

class _ProfileStateProbeState extends State<_ProfileStateProbe> {
  int _draft = 0;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        StyledText('Profile draft $_draft', TextStyles.body),
        SizedBox(height: space(2)),
        Button(
          label: 'Increase profile draft',
          onPressed: () => setState(() => _draft += 1),
          child: StyledText('Increase', TextStyles.nav),
        ),
      ],
    ),
  );
}
