/// Tests for `components_docs/accordion/page.dart`'s [AccordionDocPage]:
/// the public documentation page for `Accordion` and `AccordionItem`.
///
/// Re-housed onto the kit alongside the page: the section-order test now
/// reads `DocsSection.id` (the kit's own section widget), and the
/// API-table / state-matrix reads open the relevant `DocsDisclosure`
/// first — closed by default in the new kit, unlike the old page's
/// always-visible `Section`.
///
/// `DocsDisclosure`'s own trigger key is one constant shared by every
/// disclosure instance on the page: [_disclosureTrigger] narrows to the one
/// panel by its title first, matching `button_test.dart`'s own convention.
/// The kit's `DocsDisclosure` is built on the same `Unfold` this page's
/// own live specimens exercise (`Accordion`), so every finder below is
/// scoped to a `ValueKey` or an ancestor first rather than a bare
/// `find.text`, which would otherwise also match a `DocsDisclosure`
/// trigger's own label.
///
/// No `pumpAndSettle` anywhere: `tester.pump()` plus an explicit duration
/// pump instead, per the rollout brief.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/accordion/meta.dart';
import 'package:example/components_docs/accordion/page.dart'
    show AccordionDocPage, accordionDocSpec;
import 'package:example/docs/component_doc_page.dart' show DocsTocEntry;
import 'package:example/docs/docs_disclosure.dart';
import 'package:example/docs/docs_install.dart';
import 'package:example/docs/docs_section.dart' show DocsSection;
import 'package:example/docs/docs_showcase.dart';
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

Widget _harness({required Widget child, required ThemeController controller}) =>
    ThemeScope(
      controller: controller,
      child: MaterialApp(home: SingleChildScrollView(child: child)),
    );

/// The single `DocsDisclosure` whose title is [title].
Finder _disclosureTrigger(String title) => find.descendant(
  of: find.byWidgetPredicate(
    (Widget widget) => widget is DocsDisclosure && widget.title == title,
  ),
  matching: find.byKey(DocsDisclosure.triggerKey),
);

void main() {
  group('accordionDoc', () {
    test('documents the real public API surface', () {
      expect(accordionDoc.name, 'accordion');
      expect(accordionDoc.title, 'Accordion');
      expect(accordionDoc.sourcePath, 'lib/src/components/accordion.dart');
      expect(
        accordionDoc.exports,
        containsAll(<String>['Accordion', 'AccordionItem']),
      );
      expect(accordionDoc.description, isNotEmpty);
      expect(accordionDoc.route, '/components/accordion');
      expect(accordionDoc.command, 'elattar add accordion');
    });
  });

  group('AccordionDocPage', () {
    testWidgets('sections render in the house order, section for section', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 4000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final ThemeController controller = ThemeController(mode: ColorMode.dark);
      await tester.pumpWidget(
        _harness(controller: controller, child: const AccordionDocPage()),
      );
      await tester.pump();

      final List<String> ids = tester
          .widgetList<DocsSection>(find.byType(DocsSection))
          .map((DocsSection section) => section.id)
          .toList();

      expect(ids, <String>[
        'preview',
        'install',
        'usage',
        'composition',
        'basic',
        'card',
        'api',
        'states',
        'accessibility',
        'keyboard',
        'responsive',
        'dependencies',
        'theming',
        'source',
      ]);

      // Six specimen stages (Preview, Composition, Basic, Card), one
      // install section, eight collapsed disclosures.
      expect(find.byType(DocsShowcase), findsNWidgets(4));
      expect(find.byType(DocsInstall), findsOneWidget);
      expect(find.byType(DocsDisclosure), findsNWidgets(8));
    });

    testWidgets('renders the article at desktop width with every documented '
        'constructor parameter', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      String? destination;
      final ThemeController controller = ThemeController(mode: ColorMode.dark);
      await tester.pumpWidget(
        _harness(
          controller: controller,
          child: AccordionDocPage(
            onNavigate: (String route) => destination = route,
          ),
        ),
      );
      await tester.pump();

      expect(
        find.byKey(const ValueKey<String>('accordion-doc-article')),
        findsOneWidget,
      );
      expect(find.text('Accordion'), findsWidgets);
      expect(find.byType(Accordion), findsWidgets);

      final Finder apiTrigger = _disclosureTrigger('API Reference');
      await tester.ensureVisible(apiTrigger);
      await tester.pump();
      await tester.tap(apiTrigger);
      await tester.pump();
      await tester.pump(MotionDurations.open);

      // Accordion's constructor parameters, from
      // lib/src/components/accordion.dart: items, openIndex, onChanged.
      for (final String param in <String>['items', 'openIndex', 'onChanged']) {
        expect(
          find.text(param),
          findsAtLeastNWidgets(1),
          reason: 'Accordion.$param missing from the API table',
        );
      }
      // AccordionItem's constructor parameters: title, content.
      for (final String param in <String>['title', 'content']) {
        expect(
          find.text(param),
          findsAtLeastNWidgets(1),
          reason: 'AccordionItem.$param missing from the API table',
        );
      }

      expect(
        find.byKey(const ValueKey<String>('docs-layout-sidebar')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
      expect(destination, isNull);
    });

    testWidgets('renders the narrow anchor strip and drops the sidebar '
        'at mobile width', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final ThemeController controller = ThemeController(mode: ColorMode.light);
      await tester.pumpWidget(
        _harness(controller: controller, child: const AccordionDocPage()),
      );
      await tester.pump();

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

    testWidgets('the live specimen mounts a real Accordion that opens, '
        'switches, and collapses to nothing', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final ThemeController controller = ThemeController(mode: ColorMode.dark);
      await tester.pumpWidget(
        _harness(controller: controller, child: const AccordionDocPage()),
      );
      await tester.pump();

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
      await tester.pump();
      await tester.pump(MotionDurations.open);
      expect(
        find.textContaining('Nothing on the icon animates'),
        findsOneWidget,
      );
      expect(find.textContaining('Only one panel can stay open'), findsNothing);

      // Tapping the open trigger again closes it (collapsible -> null).
      await tester.ensureVisible(secondTrigger);
      await tester.tap(secondTrigger);
      await tester.pump();
      await tester.pump(MotionDurations.open);
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

      final ThemeController controller = ThemeController(mode: ColorMode.dark);
      await tester.pumpWidget(
        _harness(controller: controller, child: const AccordionDocPage()),
      );
      await tester.pump();
      expect(tester.takeException(), isNull);

      controller.setMode(ColorMode.light);
      await tester.pump();
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
      final ThemeController controller = ThemeController(mode: ColorMode.dark);
      await tester.pumpWidget(
        _harness(
          controller: controller,
          child: AccordionDocPage(
            onNavigate: (String route) => destination = route,
          ),
        ),
      );
      await tester.pump();

      final Finder selectLink = find.text('Select').first;
      await tester.ensureVisible(selectLink);
      await tester.tap(selectLink);
      expect(destination, '/components/select');
    });

    test('the table of contents matches the declared sections', () {
      expect(
        accordionDocSpec.toc.map((DocsTocEntry entry) => entry.title).toList(),
        <String>[
          'Preview',
          'Installation',
          'Usage',
          'Composition',
          'Basic',
          'Card',
          'API Reference',
          'States',
          'Accessibility',
          'Keyboard',
          'Responsive',
          'Dependencies',
          'Theming',
          'Source',
        ],
      );
    });
  });
}
