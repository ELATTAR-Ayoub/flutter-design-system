import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/input_select_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // A bare `Material` has no `Overlay`, so `ElSelect`'s popover menu — which
  // inserts into `Overlay.maybeOf(context)` and silently no-ops without one
  // (see `ElSelectState._openMenu`) — would never open under test. `MaterialApp`
  // supplies the `Navigator`/`Overlay` every other page harness in this suite
  // relies on for the same reason (see `component_docs_dialog_test.dart`).
  Widget host(Widget child, {Size size = const Size(1280, 900)}) {
    return MediaQuery(
      data: MediaQueryData(size: size),
      child: ElTheme(
        controller: ElThemeController(mode: ElThemeMode.dark),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: SingleChildScrollView(child: child),
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
    expect(find.byType(ElInput), findsAtLeastNWidgets(1));
    expect(find.text('State matrix'), findsOneWidget);

    await tester.tap(find.widgetWithText(ElButton, 'Invalid').first);
    await tester.pumpAndSettle();
    expect(find.text('That address is missing a valid domain.'), findsWidgets);

    await tester.tap(find.widgetWithText(ElButton, 'Read only').first);
    await tester.pumpAndSettle();
    final EditableText editable = tester.widget<EditableText>(
      find.byType(EditableText).first,
    );
    expect(editable.readOnly, isTrue);

    // `_pageLinkAfter('input')` walks the real, now-34-entry `componentDocs`
    // catalog rather than a hand-picked five-page list, so the pager's own
    // "next" neighbour is whichever entry actually follows `input` there —
    // `input_group`, not `card`. See `catalog.dart`'s declared order.
    final Finder nextLink = find.widgetWithText(ElButton, 'Input group').last;
    await tester.ensureVisible(nextLink);
    await tester.tap(nextLink);
    await tester.pumpAndSettle();
    expect(navigated, contains('/components/input_group'));
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
    expect(find.byType(ElSelect<String>), findsAtLeastNWidgets(1));
    expect(find.text('Grouped menu'), findsOneWidget);

    await tester.tap(find.widgetWithText(ElButton, 'Size sm').first);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Choose a sort order').first);
    await tester.pumpAndSettle();
    expect(find.text('Activity'), findsOneWidget);
    expect(find.text('Price'), findsOneWidget);
    expect(find.text('Most popular'), findsWidgets);

    await tester.tap(
      find
          .descendant(
            of: find.byType(ElSelectMenu<String>).first,
            matching: find.text('Most popular'),
          )
          .first,
    );
    await tester.pumpAndSettle();
    expect(find.text('Selected: popular'), findsOneWidget);

    // Same reasoning as the Input page's pager assertion above: `select`'s
    // real "next" neighbour in the 34-entry `componentDocs` catalog is
    // `separator`, not `dialog`.
    final Finder nextLink = find
        .widgetWithText(ElButton, 'Separator, Empty & Kbd')
        .last;
    await tester.ensureVisible(nextLink);
    await tester.tap(nextLink);
    await tester.pumpAndSettle();
    expect(navigated, contains('/components/separator'));
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
    final Finder expandToggle = find
        .widgetWithText(ElButton, 'Expand off')
        .first;
    await tester.ensureVisible(expandToggle);
    await tester.tap(expandToggle);
    await tester.pumpAndSettle();
    expect(find.widgetWithText(ElButton, 'Expand on'), findsOneWidget);
  });
}
