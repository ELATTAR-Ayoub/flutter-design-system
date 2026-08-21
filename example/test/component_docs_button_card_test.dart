import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/button_card_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness({required Widget child, required Size size}) => MediaQuery(
  data: MediaQueryData(size: size),
  child: DsTheme(
    controller: DsThemeController(mode: DsThemeMode.dark),
    child: MaterialApp(home: SingleChildScrollView(child: child)),
  ),
);

void main() {
  testWidgets('button docs render responsive article and live preview', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    String? destination;
    await tester.pumpWidget(
      _harness(
        size: const Size(1440, 900),
        child: ButtonDocPage(onNavigate: (String route) => destination = route),
      ),
    );

    expect(
      find.byKey(const ValueKey<String>('button-doc-article')),
      findsOneWidget,
    );
    expect(find.byType(DsButton), findsAtLeastNWidgets(3));
    expect(
      find.text(
        'primary, premium, secondary, outline, ghost, destructive, link.',
      ),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey<String>('docs-layout-sidebar')),
      findsOneWidget,
    );

    await tester.tap(find.text('Card').first);
    expect(destination, '/components/card');
  });

  testWidgets('card docs expose narrow anchors and composed regions', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      _harness(size: const Size(390, 844), child: const CardDocPage()),
    );

    expect(
      find.byKey(const ValueKey<String>('card-doc-article')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey<String>('docs-layout-anchor-strip')),
      findsOneWidget,
    );
    expect(find.byType(DsCard), findsOneWidget);
    expect(find.byType(DsCardHeader), findsOneWidget);
    expect(find.byType(DsCardContent), findsOneWidget);
    expect(find.byType(DsCardFooter), findsOneWidget);
    expect(find.textContaining('foundation dependency'), findsOneWidget);
  });
}
