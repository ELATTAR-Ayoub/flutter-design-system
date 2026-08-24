import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/button_card_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness({required Widget child, required Size size}) => MediaQuery(
  data: MediaQueryData(size: size),
  child: ElTheme(
    controller: ElThemeController(mode: ElThemeMode.dark),
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
    expect(find.byType(ElButton), findsAtLeastNWidgets(3));
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

    // `find.text('Card')` matches twice on this page: the "IN THIS GUIDE"
    // sidebar entry near the top, and the "previous" footer link at the
    // bottom of the article (the next link there reads "Input", so 'Card'
    // is unambiguous within that region). The test means to exercise page
    // navigation via the article's own prev/next pager, not the sidebar, so
    // scope to `docs-layout-prev-next` rather than pick an ordinal `.first`.
    // That footer sits well past the 1440x900 viewport this test runs at,
    // so it must be scrolled into view before it can be tapped.
    final Finder cardFooterLink = find.descendant(
      of: find.byKey(const ValueKey<String>('docs-layout-prev-next')),
      matching: find.text('Card'),
    );
    expect(cardFooterLink, findsOneWidget);
    await tester.ensureVisible(cardFooterLink);
    await tester.pumpAndSettle();
    await tester.tap(cardFooterLink);
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
    expect(find.byType(ElCard), findsOneWidget);
    expect(find.byType(ElCardHeader), findsOneWidget);
    expect(find.byType(ElCardContent), findsOneWidget);
    expect(find.byType(ElCardFooter), findsOneWidget);
    expect(find.textContaining('foundation dependency'), findsOneWidget);
  });
}
