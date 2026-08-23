import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/accordion/meta.dart';
import 'package:example/components_docs/accordion/page.dart';
import 'package:example/docs/docs_code.dart';
import 'package:example/kit.dart' show DsSection;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Real test-view sizing only: [tester.view.physicalSize] plus
/// [WidgetTester.view]'s own reset, never a synthetic `MediaQuery` override.
/// [controller] is a single live [DsThemeController] the caller can flip in
/// place with [DsThemeController.setMode] instead of rebuilding a second tree
/// for the other theme.
Widget _harness({
  required Widget child,
  required DsThemeController controller,
}) {
  return DsTheme(
    controller: controller,
    child: MaterialApp(home: SingleChildScrollView(child: child)),
  );
}

void main() {
  group('accordionDoc', () {
    test('documents the real public API surface', () {
      expect(accordionDoc.name, 'accordion');
      expect(accordionDoc.title, 'Accordion');
      expect(accordionDoc.sourcePath, 'lib/src/components/accordion.dart');
      expect(
        accordionDoc.exports,
        containsAll(<String>['DsAccordion', 'DsAccordionItem']),
      );
      expect(accordionDoc.description, isNotEmpty);
      expect(accordionDoc.route, '/components/accordion');
    });
  });

  group('AccordionDocPage', () {
    testWidgets(
      'sections render in the shadcn-mirrored order, section for section',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        final DsThemeController controller = DsThemeController(
          mode: DsThemeMode.dark,
        );
        await tester.pumpWidget(
          _harness(controller: controller, child: const AccordionDocPage()),
        );
        await tester.pumpAndSettle();

        final List<String> titles = tester
            .widgetList<DsSection>(find.byType(DsSection))
            .map((DsSection section) => section.title)
            .toList();

        expect(titles, <String>[
          'Installation',
          'Usage',
          'Composition',
          'Basic',
          'Card',
          'API Reference',
          'States',
          'Accessibility',
          'Responsive',
          'Dependencies',
          'Theming',
          'Source',
        ]);
      },
    );

    testWidgets('renders the article at desktop width with every '
        'documented constructor parameter', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final DsThemeController controller = DsThemeController(
        mode: DsThemeMode.dark,
      );
      await tester.pumpWidget(
        _harness(controller: controller, child: const AccordionDocPage()),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey<String>('accordion-doc-article')),
        findsOneWidget,
      );
      expect(find.text('Accordion'), findsWidgets);
      expect(find.byType(DocsCodeExample), findsAtLeastNWidgets(1));
      expect(find.byType(DsAccordion), findsWidgets);

      // DsAccordion's constructor parameters, from lib/src/components/
      // accordion.dart: items, openIndex, onChanged.
      for (final String param in <String>['items', 'openIndex', 'onChanged']) {
        expect(
          find.text(param),
          findsAtLeastNWidgets(1),
          reason: 'DsAccordion.$param missing from the API table',
        );
      }
      // DsAccordionItem's constructor parameters: title, content.
      for (final String param in <String>['title', 'content']) {
        expect(
          find.text(param),
          findsAtLeastNWidgets(1),
          reason: 'DsAccordionItem.$param missing from the API table',
        );
      }

      expect(
        find.byKey(const ValueKey<String>('docs-layout-sidebar')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders the narrow anchor strip and drops the sidebar '
        'at mobile width', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final DsThemeController controller = DsThemeController(
        mode: DsThemeMode.light,
      );
      await tester.pumpWidget(
        _harness(controller: controller, child: const AccordionDocPage()),
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
      expect(tester.takeException(), isNull);
    });

    testWidgets('the live specimen mounts a real DsAccordion that opens, '
        'switches, and collapses to nothing', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final DsThemeController controller = DsThemeController(
        mode: DsThemeMode.dark,
      );
      await tester.pumpWidget(
        _harness(controller: controller, child: const AccordionDocPage()),
      );
      await tester.pumpAndSettle();

      // The first specimen item opens by default.
      expect(
        find.text('What does single and collapsible mean here?'),
        findsOneWidget,
      );
      expect(
        find.textContaining('Only one panel can stay open'),
        findsOneWidget,
      );
      expect(find.textContaining('Nothing on the icon animates'), findsNothing);

      // Opening the second item closes the first (single-open).
      final Finder secondTrigger = find.text('Does the chevron rotate?');
      await tester.ensureVisible(secondTrigger);
      await tester.tap(secondTrigger);
      await tester.pumpAndSettle();
      expect(
        find.textContaining('Nothing on the icon animates'),
        findsOneWidget,
      );
      expect(find.textContaining('Only one panel can stay open'), findsNothing);

      // Tapping the open trigger again closes it (collapsible -> null).
      await tester.ensureVisible(secondTrigger);
      await tester.tap(secondTrigger);
      await tester.pumpAndSettle();
      expect(find.textContaining('Nothing on the icon animates'), findsNothing);
      expect(find.textContaining('Only one panel can stay open'), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('flips between light and dark with one live controller', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final DsThemeController controller = DsThemeController(
        mode: DsThemeMode.dark,
      );
      await tester.pumpWidget(
        _harness(controller: controller, child: const AccordionDocPage()),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      controller.setMode(DsThemeMode.light);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byType(AccordionDocPage), findsOneWidget);
    });

    testWidgets('tapping Purpose neighbours does not navigate away', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      String? destination;
      final DsThemeController controller = DsThemeController(
        mode: DsThemeMode.dark,
      );
      await tester.pumpWidget(
        _harness(
          controller: controller,
          child: AccordionDocPage(
            onNavigate: (String route) => destination = route,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final Finder selectLink = find.text('Select').first;
      await tester.ensureVisible(selectLink);
      await tester.tap(selectLink);
      expect(destination, '/components/select');
    });
  });
}
