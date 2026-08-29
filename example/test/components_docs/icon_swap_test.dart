import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/icon_swap/meta.dart';
import 'package:example/components_docs/icon_swap/page.dart';
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

/// The single `DocsDisclosure` whose title is [title]. `DocsDisclosure`'s own
/// trigger key is one constant shared by every instance on the page, so a
/// bare `find.byKey` would match all eight — this narrows to the one panel by
/// its title first, matching the kit's own convention.
Finder _disclosureTrigger(String title) => find.descendant(
  of: find.byWidgetPredicate(
    (Widget widget) => widget is DocsDisclosure && widget.title == title,
  ),
  matching: find.byKey(DocsDisclosure.triggerKey),
);

/// Every named constructor parameter `IconSwap`'s own class declares
/// (`lib/src/components/ui/icon_swap.dart`), excluding `key`: the same set the
/// page's `IconSwap` `DocsApiTable` claims to cover.
const List<String> _iconSwapConstructorParams = <String>[
  'icons',
  'activeIndex',
  'window',
  'cell',
];

void main() {
  group('icon-swap docs page', () {
    testWidgets(
      'renders the article, the full API table, and both real call sites '
      'this page claims to show',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        String? destination;
        await tester.pumpWidget(
          _harness(
            controller: ThemeController(mode: ColorMode.dark),
            child: IconSwapDocPage(
              onNavigate: (String route) => destination = route,
            ),
          ),
        );
        // One frame only: the mount squash plays once on every specimen and
        // must never be settled on — pumpAndSettle would hang if a roll is
        // ever mid-flight.
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('icon-swap-doc-article')),
          findsOneWidget,
        );

        final Finder apiTrigger = _disclosureTrigger('API Reference');
        await tester.ensureVisible(apiTrigger);
        await tester.pump();
        await tester.tap(apiTrigger);
        await tester.pump();
        await tester.pump(MotionDurations.open);

        for (final String param in _iconSwapConstructorParams) {
          expect(find.text(param), findsWidgets, reason: 'missing $param');
        }
        expect(find.text('resolveIndex(index, count)'), findsOneWidget);

        // A live IconSwap specimen mounts on Preview's "Rolls" column,
        // Sidebar Trigger, and Download Confirmation — three, since
        // Preview's "Swaps instantly" column deliberately carries none.
        // Not asserted as a page-wide `findsNWidgets`: `DocsCopyButton`
        // (`example/lib/docs/docs_copy_button.dart`) is itself built on
        // IconSwap and mounts on every always-visible code pane — Usage's
        // DocsSnippet and Installation's default CLI pane — so the page-wide
        // total is 5, not 3. The per-key checks below are the real
        // assertion: each of this page's own three specimens exists,
        // independent of how many copy buttons happen to share the page.
        for (final String key in <String>[
          'icon-swap-preview:rolling',
          'icon-swap-preview:instant',
          'icon-swap-example:sidebar-trigger',
          'icon-swap-example:download-confirmation',
        ]) {
          expect(
            find.byKey(ValueKey<String>(key)),
            findsOneWidget,
            reason: 'missing example specimen $key',
          );
        }

        expect(iconSwapDoc.name, 'icon_swap');
        expect(iconSwapDoc.exports, containsAll(<String>['IconSwap']));
        expect(iconSwapDoc.command, 'elattar add icon-swap');
        expect(destination, isNull);
      },
    );

    testWidgets(
      'tapping the sidebar-trigger specimen rolls to the other icon without '
      'settling',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ThemeController(mode: ColorMode.dark),
            child: const IconSwapDocPage(),
          ),
        );
        await tester.pump();

        final Finder specimen = find.descendant(
          of: find.byKey(
            const ValueKey<String>('icon-swap-example:sidebar-trigger'),
          ),
          matching: find.byType(IconSwap),
        );
        final int before = tester.widget<IconSwap>(specimen).activeIndex;

        await tester.ensureVisible(specimen);
        await tester.pump();
        await tester.tap(specimen);
        // A fraction of the roll's own 400ms (MotionDurations.slow): enough to
        // prove the state actually flipped, never `pumpAndSettle`.
        await tester.pump(const Duration(milliseconds: 50));

        final int after = tester.widget<IconSwap>(specimen).activeIndex;
        expect(after, isNot(before));
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
          child: const IconSwapDocPage(),
        ),
      );
      await tester.pump();

      // Three EffectSection stages: Preview, Sidebar Trigger, Download
      // Confirmation.
      expect(find.byType(DocsShowcase), findsNWidgets(3));
      expect(find.byType(DocsInstall), findsOneWidget);
      // Eight collapsed sections: API Reference, States, Accessibility,
      // Keyboard, Responsive, Dependencies, Theming, Source.
      expect(find.byType(DocsDisclosure), findsNWidgets(8));
    });

    test('the table of contents matches the declared sections', () {
      expect(
        iconSwapDocSpec.toc.map((DocsTocEntry entry) => entry.title).toList(),
        <String>[
          'Preview',
          'Installation',
          'Usage',
          'Sidebar Trigger',
          'Download Confirmation',
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

    testWidgets('sections render in declaration order, section for section', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _harness(
          controller: ThemeController(mode: ColorMode.dark),
          child: const IconSwapDocPage(),
        ),
      );
      await tester.pump();

      final List<String> titles = tester
          .widgetList<DocsSection>(find.byType(DocsSection))
          .map((DocsSection section) => section.title)
          .toList();

      expect(titles, <String>[
        'Preview',
        'Installation',
        'Usage',
        'Sidebar Trigger',
        'Download Confirmation',
        'API Reference',
        'States',
        'Accessibility',
        'Keyboard',
        'Responsive',
        'Dependencies',
        'Theming',
        'Source',
      ]);
    });

    testWidgets(
      'renders at narrow width with the anchor strip instead of a rail',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ThemeController(mode: ColorMode.dark),
            child: const IconSwapDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('icon-swap-doc-article')),
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
      'survives a live theme flip in place, at desktop width, without '
      'losing any example specimen',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        final ThemeController controller = ThemeController(
          mode: ColorMode.dark,
        );
        await tester.pumpWidget(
          _harness(controller: controller, child: const IconSwapDocPage()),
        );
        await tester.pump();

        final ThemeTokens darkTheme = ThemeScope.of(
          tester.element(
            find.byKey(const ValueKey<String>('icon-swap-doc-article')),
          ),
        );

        controller.setMode(ColorMode.light);
        await tester.pump();

        final ThemeTokens lightTheme = ThemeScope.of(
          tester.element(
            find.byKey(const ValueKey<String>('icon-swap-doc-article')),
          ),
        );

        expect(lightTheme.background, isNot(darkTheme.background));
        expect(lightTheme.foreground, isNot(darkTheme.foreground));

        for (final String key in <String>[
          'icon-swap-preview:rolling',
          'icon-swap-preview:instant',
          'icon-swap-example:sidebar-trigger',
          'icon-swap-example:download-confirmation',
        ]) {
          expect(find.byKey(ValueKey<String>(key)), findsOneWidget);
        }
      },
    );
  });
}
