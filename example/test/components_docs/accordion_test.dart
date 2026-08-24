import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/accordion/meta.dart';
import 'package:example/components_docs/accordion/page.dart';
import 'package:example/docs/docs_code.dart';
import 'package:example/kit.dart' show ElSection;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Real test-view sizing only: [tester.view.physicalSize] plus
/// [WidgetTester.view]'s own reset, never a synthetic `MediaQuery` override.
/// [controller] is a single live [ElThemeController] the caller can flip in
/// place with [ElThemeController.setMode] instead of rebuilding a second tree
/// for the other theme.
Widget _harness({
  required Widget child,
  required ElThemeController controller,
}) {
  return ElTheme(
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
        containsAll(<String>['ElAccordion', 'ElAccordionItem']),
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

        final ElThemeController controller = ElThemeController(
          mode: ElThemeMode.dark,
        );
        await tester.pumpWidget(
          _harness(controller: controller, child: const AccordionDocPage()),
        );
        await tester.pumpAndSettle();

        final List<String> titles = tester
            .widgetList<ElSection>(find.byType(ElSection))
            .map((ElSection section) => section.title)
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

      final ElThemeController controller = ElThemeController(
        mode: ElThemeMode.dark,
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
      expect(find.byType(ElAccordion), findsWidgets);

      // ElAccordion's constructor parameters, from lib/src/components/
      // accordion.dart: items, openIndex, onChanged.
      for (final String param in <String>['items', 'openIndex', 'onChanged']) {
        expect(
          find.text(param),
          findsAtLeastNWidgets(1),
          reason: 'ElAccordion.$param missing from the API table',
        );
      }
      // ElAccordionItem's constructor parameters: title, content.
      for (final String param in <String>['title', 'content']) {
        expect(
          find.text(param),
          findsAtLeastNWidgets(1),
          reason: 'ElAccordionItem.$param missing from the API table',
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

      final ElThemeController controller = ElThemeController(
        mode: ElThemeMode.light,
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

    testWidgets('the live specimen mounts a real ElAccordion that opens, '
        'switches, and collapses to nothing', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final ElThemeController controller = ElThemeController(
        mode: ElThemeMode.dark,
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

      final ElThemeController controller = ElThemeController(
        mode: ElThemeMode.dark,
      );
      await tester.pumpWidget(
        _harness(controller: controller, child: const AccordionDocPage()),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      controller.setMode(ElThemeMode.light);
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
      final ElThemeController controller = ElThemeController(
        mode: ElThemeMode.dark,
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
