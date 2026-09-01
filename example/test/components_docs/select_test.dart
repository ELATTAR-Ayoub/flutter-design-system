import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/catalog.dart';
import 'package:example/components_docs/select/meta.dart';
import 'package:example/components_docs/select/page.dart';
import 'package:example/docs/component_doc_page.dart' show DocsTocEntry;
import 'package:example/docs/docs_disclosure.dart';
import 'package:example/docs/docs_install.dart';
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

// A bare `Material` has no `Overlay`, so `Select`'s popover menu — which
// inserts into `Overlay.maybeOf(context)` and silently no-ops without one
// (`_SelectState._openMenu`) — would never open under test. `MaterialApp`
// supplies the `Navigator`/`Overlay` this harness relies on for that reason.
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

Finder _disclosureTrigger(String title) => find.descendant(
  of: find.byWidgetPredicate(
    (Widget widget) => widget is DocsDisclosure && widget.title == title,
  ),
  matching: find.byKey(DocsDisclosure.triggerKey),
);

/// Every named constructor parameter `Select`'s own class declares
/// (`lib/src/components/ui/select.dart`), excluding `key`: the same set the
/// page's `Select` `DocsApiTable` claims to cover.
const List<String> _selectConstructorParams = <String>[
  'options',
  'value',
  'onChanged',
  'placeholder',
  'size',
  'enabled',
  'invalid',
  'expand',
  'width',
  'focusNode',
  'label',
  'hint',
];

void main() {
  group('select docs page', () {
    testWidgets(
      'renders the article, the full API table, and supports live menu '
      'interaction',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1280, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        String? destination;
        await tester.pumpWidget(
          _harness(
            controller: ThemeController(mode: ColorMode.dark),
            child: SelectDocPage(
              onNavigate: (String route) => destination = route,
            ),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('select-doc-article')),
          findsOneWidget,
        );
        expect(find.byType(Select<String>), findsAtLeastNWidgets(1));

        final Finder apiTrigger = _disclosureTrigger('API Reference');
        await tester.ensureVisible(apiTrigger);
        await tester.pump();
        await tester.tap(apiTrigger);
        await tester.pump();
        await tester.pump(MotionDurations.open);

        for (final String param in _selectConstructorParams) {
          expect(find.text(param), findsWidgets, reason: 'missing $param');
        }
        for (final String table in <String>[
          'Select',
          'SelectSize',
          'SelectOption',
          'SelectGroup',
          'SelectSeparator',
          'SelectMenu',
        ]) {
          expect(find.text(table), findsWidgets, reason: 'missing $table');
        }

        // Live menu interaction: open the Preview's select, pick a row, no
        // `pumpAndSettle` — the popover's own animation must never be
        // settled on. Opening the API Reference disclosure above scrolled
        // the article down to it, so the Preview trigger needs scrolling
        // back into view before it can be tapped.
        final Finder selectTrigger = find.text('Choose a sort order').first;
        await tester.ensureVisible(selectTrigger);
        await tester.pump();
        await tester.tap(selectTrigger);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 320));
        expect(find.text('Activity'), findsOneWidget);
        expect(find.text('Price'), findsOneWidget);
        expect(find.text('Most popular'), findsWidgets);

        await tester.tap(
          find
              .descendant(
                of: find.byType(SelectMenu<String>).first,
                matching: find.text('Most popular'),
              )
              .first,
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 320));
        expect(find.text('Selected: popular'), findsOneWidget);
        // The menu commits and closes itself on pick — nothing left open
        // to dismiss before the test ends.
        expect(find.byType(SelectMenu<String>), findsNothing);

        expect(selectDoc.name, 'select');
        expect(
          selectDoc.exports,
          containsAll(<String>[
            'Select',
            'SelectSize',
            'SelectOption',
            'SelectGroup',
            'SelectSeparator',
            'SelectMenu',
          ]),
        );
        expect(selectDoc.command, 'elattar add select');
        expect(destination, isNull);
      },
    );

    testWidgets('the page is declared, and every section is a kit component', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 4000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _harness(
          controller: ThemeController(mode: ColorMode.dark),
          child: const SelectDocPage(),
        ),
      );
      await tester.pump();

      // Three specimen stages: Preview, Grouped menu, Size & width.
      expect(find.byType(DocsShowcase), findsNWidgets(3));
      expect(find.byType(DocsInstall), findsOneWidget);
      expect(find.byType(DocsDisclosure), findsNWidgets(8));
    });

    test('the table of contents matches the declared sections', () {
      expect(
        selectDocSpec.toc.map((DocsTocEntry entry) => entry.title).toList(),
        <String>[
          'Preview',
          'Installation',
          'Usage',
          'Grouped menu',
          'Size & width',
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

    testWidgets(
      'renders at narrow width with the anchor strip instead of a rail, '
      'and the width demo toggle works',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(430, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ThemeController(mode: ColorMode.dark),
            child: const SelectDocPage(),
          ),
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

        final Finder expandToggle = find
            .widgetWithText(Button, 'Expand off')
            .first;
        await tester.ensureVisible(expandToggle);
        await tester.pump();
        await tester.tap(expandToggle);
        await tester.pump();
        expect(find.widgetWithText(Button, 'Expand on'), findsOneWidget);
      },
    );

    testWidgets('survives a live theme flip in place, at desktop width', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final ThemeController controller = ThemeController(mode: ColorMode.dark);
      await tester.pumpWidget(
        _harness(controller: controller, child: const SelectDocPage()),
      );
      await tester.pump();

      final ThemeTokens darkTheme = ThemeScope.of(
        tester.element(
          find.byKey(const ValueKey<String>('select-doc-article')),
        ),
      );

      controller.setMode(ColorMode.light);
      await tester.pump();

      final ThemeTokens lightTheme = ThemeScope.of(
        tester.element(
          find.byKey(const ValueKey<String>('select-doc-article')),
        ),
      );

      expect(lightTheme.background, isNot(darkTheme.background));
      expect(lightTheme.foreground, isNot(darkTheme.foreground));
      expect(find.byType(Select<String>), findsAtLeastNWidgets(1));
    });

    // Migrated from the retired component_docs_input_select_test.dart: the
    // pager's "next" link must fire onNavigate with a route that still
    // matches the real catalog entry, so a future rename of separator's
    // own title cannot leave this page's own DocsPageLink silently stale.
    testWidgets(
      'navigating next fires onNavigate with the linked page, and the '
      'label still matches the real catalog entry',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1280, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        final ComponentDocEntry separator = componentDoc('separator');

        String? destination;
        await tester.pumpWidget(
          _harness(
            controller: ThemeController(mode: ColorMode.dark),
            child: SelectDocPage(
              onNavigate: (String route) => destination = route,
            ),
          ),
        );
        await tester.pump();

        final Finder nextLink = find
            .widgetWithText(Button, separator.title)
            .last;
        await tester.ensureVisible(nextLink);
        await tester.pump();
        await tester.tap(nextLink);
        expect(destination, separator.route);
      },
    );
  });
}
