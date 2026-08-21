import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/input_select_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget host(Widget child, {Size size = const Size(1280, 900)}) {
    return MediaQuery(
      data: MediaQueryData(size: size),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: DsTheme(
          controller: DsThemeController(mode: DsThemeMode.dark),
          child: Material(child: SingleChildScrollView(child: child)),
        ),
      ),
    );
  }

  testWidgets('Input docs render wide article sections and state interaction', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final List<String> navigated = <String>[];
    await tester.pumpWidget(host(InputDocPage(onNavigate: navigated.add)));
    await tester.pumpAndSettle();

    expect(find.text('Input'), findsAtLeastNWidgets(1));
    expect(find.byKey(const ValueKey<String>('docs-layout-sidebar')), findsOne);
    expect(find.byType(DsInput), findsAtLeastNWidgets(1));
    expect(find.text('State matrix'), findsOneWidget);

    await tester.tap(find.widgetWithText(DsButton, 'Invalid').first);
    await tester.pumpAndSettle();
    expect(find.text('That address is missing a valid domain.'), findsWidgets);

    await tester.tap(find.widgetWithText(DsButton, 'Read only').first);
    await tester.pumpAndSettle();
    final EditableText editable = tester.widget<EditableText>(
      find.byType(EditableText).first,
    );
    expect(editable.readOnly, isTrue);

    await tester.tap(find.widgetWithText(DsButton, 'Card').last);
    await tester.pumpAndSettle();
    expect(navigated, contains('/components/card'));
  });

  testWidgets('Input docs render narrow anchor strip', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(420, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      host(const InputDocPage(), size: const Size(420, 900)),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey<String>('docs-layout-anchor-strip')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey<String>('docs-layout-sidebar')),
      findsNothing,
    );
  });

  testWidgets('Select docs render wide article and support menu interaction', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final List<String> navigated = <String>[];
    await tester.pumpWidget(host(SelectDocPage(onNavigate: navigated.add)));
    await tester.pumpAndSettle();

    expect(find.text('Select'), findsAtLeastNWidgets(1));
    expect(find.byType(DsSelect<String>), findsAtLeastNWidgets(1));
    expect(find.text('Grouped menu'), findsOneWidget);

    await tester.tap(find.widgetWithText(DsButton, 'Size sm').first);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Choose a sort order').first);
    await tester.pumpAndSettle();
    expect(find.text('Activity'), findsOneWidget);
    expect(find.text('Price'), findsOneWidget);
    expect(find.text('Most popular'), findsWidgets);

    await tester.tap(
      find
          .descendant(
            of: find.byType(DsSelectMenu<String>).first,
            matching: find.text('Most popular'),
          )
          .first,
    );
    await tester.pumpAndSettle();
    expect(find.text('Selected: popular'), findsOneWidget);

    await tester.tap(find.widgetWithText(DsButton, 'Dialog').last);
    await tester.pumpAndSettle();
    expect(navigated, contains('/components/dialog'));
  });

  testWidgets('Select docs show narrow layout and width demo toggle', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(430, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      host(const SelectDocPage(), size: const Size(430, 900)),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey<String>('docs-layout-anchor-strip')),
      findsOneWidget,
    );
    await tester.tap(find.widgetWithText(DsButton, 'Expand off').first);
    await tester.pumpAndSettle();
    expect(find.widgetWithText(DsButton, 'Expand on'), findsOneWidget);
  });
}
