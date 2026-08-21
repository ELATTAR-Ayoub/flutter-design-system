import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/dialog_page.dart';
import 'package:example/docs/docs_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness({required Widget child, required Size size}) => MediaQuery(
  data: MediaQueryData(size: size),
  child: DsTheme(
    controller: DsThemeController(mode: DsThemeMode.dark),
    child: MaterialApp(home: SingleChildScrollView(child: child)),
  ),
);

void main() {
  testWidgets('dialog docs expose the article at wide and narrow widths', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      _harness(child: const DialogDocPage(), size: const Size(1440, 900)),
    );
    expect(find.text('Dialog'), findsWidgets);
    expect(find.byType(DocsCodeExample), findsAtLeastNWidgets(1));
    expect(find.text('elattar add dialog'), findsOneWidget);
    expect(find.text('Dependencies and source'), findsOneWidget);
    expect(
      find.byKey(const ValueKey<String>('docs-layout-sidebar')),
      findsOneWidget,
    );

    await tester.pumpWidget(
      _harness(child: const DialogDocPage(), size: const Size(390, 844)),
    );
    await tester.pumpAndSettle();
    expect(find.text('States and accessibility'), findsOneWidget);
    expect(
      find.byKey(const ValueKey<String>('docs-layout-anchor-strip')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey<String>('docs-layout-sidebar')),
      findsNothing,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('live normal and media dialog previews open and close', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(900, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      _harness(child: const DialogDocPage(), size: const Size(900, 900)),
    );
    await tester.ensureVisible(find.text('Open normal'));
    await tester.tap(find.text('Open normal'));
    await tester.pumpAndSettle();
    expect(find.byType(DsDialogContent), findsOneWidget);
    expect(find.text('Confirm action'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.byType(DsDialogContent), findsNothing);

    await tester.tap(find.text('Open media'));
    await tester.pumpAndSettle();
    expect(find.byType(DsDialogMedia), findsOneWidget);
    expect(find.text('A visual lead'), findsOneWidget);
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.byType(DsDialogMedia), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
