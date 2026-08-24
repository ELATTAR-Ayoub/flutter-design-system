import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/showcase/showcase_app.dart';
import 'package:example/showcase/showcase_dashboard.dart';
import 'package:example/showcase/showcase_feedback.dart';
import 'package:example/showcase/showcase_shell_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pumpDashboard(WidgetTester tester, {required Size size}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.reset);
  final ElThemeController theme = ElThemeController();
  final ElToastController toasts = ElToastController();
  addTearDown(theme.dispose);
  addTearDown(toasts.dispose);
  await tester.pumpWidget(
    ElTheme(
      controller: theme,
      child: MaterialApp(
        home: ShowcaseFeedback(
          controller: toasts,
          child: const ShowcaseShellScope(
            compact: false,
            child: ShowcaseDashboard(),
          ),
        ),
      ),
    ),
  );
  await tester.pump(ElDurations.fast);
  await tester.pump();
}

Finder _navigationButton(String label) => find.byWidgetPredicate(
  (Widget widget) => widget is ElButton && widget.label == label,
);

void main() {
  testWidgets('dashboard gives the hero and chart distinct visual hierarchy', (
    WidgetTester tester,
  ) async {
    await _pumpDashboard(tester, size: const Size(ElBreakpoints.lg, 900));

    expect(find.byKey(const Key('dashboard-hero-surface')), findsOneWidget);
    expect(find.byKey(const Key('dashboard-chart-focus')), findsOneWidget);
    expect(find.byType(ElStat), findsNWidgets(4));
    expect(find.byType(ElItemGroup), findsNWidgets(2));
    expect(find.byType(ElCard), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('dashboard range and queue preserve useful inline decisions', (
    WidgetTester tester,
  ) async {
    await _pumpDashboard(tester, size: const Size(ElBreakpoints.lg, 900));

    await tester.tap(find.byType(ElSelect<String>));
    await tester.pump();
    await tester.tap(find.text('Last 30 days'));
    await tester.pump();
    expect(find.text('318.6K'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Content queue'),
      el(24),
      scrollable: find.descendant(
        of: find.byKey(const Key('dashboard-scroll')),
        matching: find.byType(Scrollable),
      ),
    );
    await tester.tap(find.widgetWithText(ElButton, 'Schedule').first);
    await tester.pump();
    expect(find.text('SCHEDULED'), findsOneWidget);
    expect(find.widgetWithText(ElButton, 'Undo'), findsOneWidget);
  });

  testWidgets('compact dashboard content scrolls clear of the fixed dock', (
    WidgetTester tester,
  ) async {
    const Size phone = Size(390, 844);
    const double gestureBar = 34;
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = phone;
    tester.view.padding = const FakeViewPadding(bottom: gestureBar);
    tester.view.viewPadding = const FakeViewPadding(bottom: gestureBar);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const SignalStudioApp());
    await tester.tap(_navigationButton('Dashboard'));
    await tester.pump(ElDurations.fast);
    await tester.pump();
    await tester.scrollUntilVisible(
      find.byKey(const Key('dashboard-scroll-end')),
      el(32),
      scrollable: find.descendant(
        of: find.byKey(const Key('dashboard-scroll')),
        matching: find.byType(Scrollable),
      ),
    );

    final Finder dock = find.ancestor(
      of: _navigationButton('Dashboard'),
      matching: find.byType(ElGlassPanelClear),
    );
    expect(
      tester.getRect(find.byKey(const Key('dashboard-scroll-end'))).bottom,
      lessThanOrEqualTo(tester.getRect(dock).top),
    );
  });
}
