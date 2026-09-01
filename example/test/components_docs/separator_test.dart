/// Tests for `components_docs/separator/page.dart`'s [SeparatorDocPage]:
/// the public documentation page for `Separator`.
///
/// Re-housed onto the kit alongside the page: the section-order test now
/// reads `DocsSection.id`, and the API-table reads open the `DocsDisclosure`
/// first — closed by default, unlike the old page's always-visible
/// `Section`.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/separator/meta.dart';
import 'package:example/components_docs/separator/page.dart'
    show SeparatorDocPage, separatorDocSpec;
import 'package:example/docs/component_doc_page.dart' show DocsTocEntry;
import 'package:example/docs/docs_disclosure.dart';
import 'package:example/docs/docs_section.dart' show DocsSection;
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
      child: MaterialApp(
        home: Builder(
          // The ambient ink every route inherits, as the docs shell sets it
          // for the real app. Without it this subtree sits under WidgetsApp's
          // red fallback style, which StyledText asserts on rather than
          // quietly painting over.
          builder: (BuildContext context) => DefaultTextStyle(
            style: StyledText.styleOf(
              context,
              TextStyles.body,
              color: ThemeScope.of(context).foreground,
            ),
            child: SingleChildScrollView(child: child),
          ),
        ),
      ),
    );

/// The single `DocsDisclosure` whose title is [title].
Finder _disclosureTrigger(String title) => find.descendant(
  of: find.byWidgetPredicate(
    (Widget widget) => widget is DocsDisclosure && widget.title == title,
  ),
  matching: find.byKey(DocsDisclosure.triggerKey),
);

void main() {
  group('separator docs page', () {
    testWidgets(
      'renders the article, the API tables, and a live specimen of both '
      'orientations',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        String? destination;
        await tester.pumpWidget(
          _harness(
            controller: ThemeController(mode: ColorMode.dark),
            child: SeparatorDocPage(
              onNavigate: (String route) => destination = route,
            ),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('separator-doc-article')),
          findsOneWidget,
        );

        final Finder apiTrigger = _disclosureTrigger('API Reference');
        await tester.ensureVisible(apiTrigger);
        await tester.tap(apiTrigger);
        await tester.pump();
        await tester.pump(MotionDurations.open);

        expect(find.text('orientation'), findsWidgets);

        expect(
          find.byWidgetPredicate(
            (Widget w) =>
                w is Separator &&
                w.orientation == SeparatorOrientation.horizontal,
          ),
          findsWidgets,
        );
        expect(
          find.byWidgetPredicate(
            (Widget w) =>
                w is Separator &&
                w.orientation == SeparatorOrientation.vertical,
          ),
          findsWidgets,
        );

        expect(separatorDoc.name, 'separator');
        expect(
          separatorDoc.exports,
          containsAll(<String>['Separator', 'SeparatorOrientation']),
        );
        expect(separatorDoc.command, 'elattar add separator');
        expect(destination, isNull);
      },
    );

    testWidgets(
      'renders at narrow width with the anchor strip instead of a rail',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ThemeController(mode: ColorMode.dark),
            child: const SeparatorDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('separator-doc-article')),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey<String>('docs-layout-anchor-strip')),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey<String>('docs-layout-sidebar')),
          findsNothing,
        );
      },
    );

    testWidgets(
      'the separator specimen reads the live theme and repaints when it '
      'flips, in place',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        final ThemeController controller = ThemeController(
          mode: ColorMode.dark,
        );
        await tester.pumpWidget(
          _harness(controller: controller, child: const SeparatorDocPage()),
        );
        await tester.pump();

        final Finder horizontalKey = find.byKey(
          const ValueKey<String>('separator-preview:horizontal'),
        );
        expect(horizontalKey, findsOneWidget);
        final ColoredBox darkBox = tester.widget<ColoredBox>(
          find
              .descendant(of: horizontalKey, matching: find.byType(ColoredBox))
              .first,
        );
        final Color darkColor = darkBox.color;

        // Flip the SAME controller in place, not a fresh widget tree: the
        // same object every real theme toggle mutates.
        controller.setMode(ColorMode.light);
        await tester.pump();

        final ColoredBox lightBox = tester.widget<ColoredBox>(
          find
              .descendant(of: horizontalKey, matching: find.byType(ColoredBox))
              .first,
        );
        final Color lightColor = lightBox.color;

        expect(
          lightColor,
          isNot(darkColor),
          reason:
              'the separator hairline is theme.border and must actually '
              'move when the live theme flips, not just render once',
        );
      },
    );

    testWidgets('renders the house-shape section list, in order: Preview, '
        'Installation, Usage, separator\'s own promoted sections, then the '
        'eight disclosures', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1440, 4000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _harness(
          controller: ThemeController(mode: ColorMode.dark),
          child: const SeparatorDocPage(),
        ),
      );
      await tester.pump();

      final List<String> sectionIds = tester
          .widgetList<DocsSection>(find.byType(DocsSection))
          .map((DocsSection section) => section.id)
          .toList();

      expect(sectionIds, <String>[
        'preview',
        'install',
        'usage',
        'vertical',
        'menu',
        'list',
        'rtl',
        'api',
        'states',
        'accessibility',
        'keyboard',
        'responsive',
        'dependencies',
        'theming',
        'source',
      ]);

      // No leftover "empty"/"kbd" content: those are their own pages now.
      expect(find.text('Empty: Input group'), findsNothing);
      expect(find.text('Kbd: Group'), findsNothing);
      expect(find.byType(Empty), findsNothing);
      expect(find.byType(Kbd), findsNothing);

      final Finder article = find.byKey(
        const ValueKey<String>('separator-doc-article'),
      );
      for (final String title in <String>['Menu', 'List', 'RTL']) {
        expect(
          find.descendant(of: article, matching: find.text(title)),
          findsOneWidget,
          reason: 'missing $title',
        );
      }

      // Once, and only once. The title lives on the `DocsDisclosure`'s
      // trigger row — the control itself, with the chevron beside it —
      // and `DocsSection` prints no heading above a disclosure, so the
      // name is not stacked on itself. This used to expect two; that was
      // the duplication, encoded.
      expect(
        find.descendant(of: article, matching: find.text('API Reference')),
        findsOneWidget,
      );
    });

    test('the table of contents matches the declared sections', () {
      expect(
        separatorDocSpec.toc.map((DocsTocEntry entry) => entry.title).toList(),
        <String>[
          'Preview',
          'Installation',
          'Usage',
          'Vertical',
          'Menu',
          'List',
          'RTL',
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
