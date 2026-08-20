import 'dart:io';

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/main.dart';
import 'package:example/nav.dart';
import 'package:example/pages/overview.dart';
import 'package:example/showcase/showcase_app.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('documentation and example app navigate in both directions', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1440, 900);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const DocsApp());
    await tester.pump();

    await tester.tap(find.widgetWithText(DsButton, 'Example app'));
    await tester.pump();
    expect(find.byType(SignalStudioShowcase), findsOneWidget);

    final Finder profileDestination = find.byWidgetPredicate(
      (Widget widget) => widget is DsButton && widget.label == 'Profile',
    );
    expect(
      find.descendant(of: profileDestination, matching: find.byType(DsIcon)),
      findsOneWidget,
    );
    expect(
      find.ancestor(of: profileDestination, matching: find.byType(DsCard)),
      findsOneWidget,
    );
    expect(
      find.ancestor(
        of: profileDestination,
        matching: find.byType(DsGlassPanelClear),
      ),
      findsNothing,
    );
    expect(find.byKey(const Key('showcase-header-avatar')), findsOneWidget);

    await tester.tap(
      find.byWidgetPredicate(
        (Widget widget) =>
            widget is DsButton && widget.label == 'Back to design system',
      ),
    );
    await tester.pump();
    expect(find.byType(OverviewPage), findsOneWidget);
  });

  testWidgets('showcase route boots inside the shared application router', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const DocsApp(initialRoute: showcaseRoute));
    await tester.pump();

    expect(find.byType(SignalStudioShowcase), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (Widget widget) =>
            widget is DsButton && widget.label == 'Back to design system',
      ),
      findsOneWidget,
    );
  });

  testWidgets('mobile documentation sheet opens the example app', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const DocsApp());
    await tester.pump();
    await tester.tap(
      find.byWidgetPredicate(
        (Widget widget) =>
            widget is DsButton &&
            widget.label == 'Open design system navigation',
      ),
    );
    await tester.pump(DsDurations.slow);
    await tester.pump();

    await tester.tap(
      find.byWidgetPredicate(
        (Widget widget) =>
            widget is DsButton && widget.label == 'Open example app',
      ),
    );
    await tester.pump(DsDurations.slow);
    await tester.pump();

    expect(find.byType(SignalStudioShowcase), findsOneWidget);
  });

  test('Android identity uses the design-system name and logo resource', () {
    final String manifest = File(
      'android/app/src/main/AndroidManifest.xml',
    ).readAsStringSync();
    final String launcher = File(
      'android/app/src/main/res/drawable/ic_launcher.xml',
    ).readAsStringSync();
    final String gradle = File(
      'android/app/build.gradle.kts',
    ).readAsStringSync();

    expect(manifest, contains('android:label="Elattar Design System"'));
    expect(manifest, contains('android:icon="@drawable/ic_launcher"'));
    expect(gradle, contains('applicationId = "com.elattar.designsystem"'));
    expect(launcher, contains('#1A6EF4'));
    expect(launcher, contains('#D9F99D'));
  });
}
