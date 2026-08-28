import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/active_indicator/meta.dart';
import 'package:example/components_docs/active_indicator/page.dart';
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

Finder _disclosureTrigger(String title) => find.descendant(
  of: find.byWidgetPredicate(
    (Widget widget) => widget is DocsDisclosure && widget.title == title,
  ),
  matching: find.byKey(DocsDisclosure.triggerKey),
);

/// Every named constructor parameter `ActiveIndicator`'s own class
/// declares (`lib/src/components/ui/active_indicator.dart`), excluding `key`.
const List<String> _pillConstructorParams = <String>[
  'activeIndex',
  'pill',
  'children',
  'padding',
  'gap',
  'moveDuration',
  'jellyAlignment',
];

void main() {
  group('active-indicator docs page', () {
    testWidgets(
      'renders the article, the full API table, and every real call site '
      'this page claims to show',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        String? destination;
        await tester.pumpWidget(
          _harness(
            controller: ThemeController(mode: ColorMode.dark),
            child: ActiveIndicatorDocPage(
              onNavigate: (String route) => destination = route,
            ),
          ),
        );
        // A sliding pill re-measures via a post-frame callback: one extra
        // pump settles that without ever approaching pumpAndSettle.
        await tester.pump();
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('active-indicator-doc-article')),
          findsOneWidget,
        );

        final Finder apiTrigger = _disclosureTrigger('API Reference');
        await tester.ensureVisible(apiTrigger);
        await tester.pump();
        await tester.tap(apiTrigger);
        await tester.pump();
        await tester.pump(MotionDurations.open);

        for (final String param in _pillConstructorParams) {
          expect(find.text(param), findsWidgets, reason: 'missing $param');
        }

        // A live ActiveIndicator mounts for Preview's "Travels" column,
        // Toggle Group, Tabs — Line, and Deselection: four. Not asserted as
        // a page-wide `findsNWidgets`: `ToggleGroup` (the docs kit's own
        // Preview/Code and CLI/Manual toggles, in `DocsShowcase` and
        // `DocsInstall`) is itself built on ActiveIndicator and mounts
        // one per showcase plus one for Installation, so the page-wide
        // total is 9, not 4. The per-key checks below are the real
        // assertion.
        for (final String key in <String>[
          'active-indicator-preview:travels',
          'active-indicator-preview:blinks',
          'active-indicator-example:toggle-group',
          'active-indicator-example:tabs-line',
          'active-indicator-example:deselection',
        ]) {
          expect(
            find.byKey(ValueKey<String>(key)),
            findsOneWidget,
            reason: 'missing example specimen $key',
          );
        }

        expect(activeIndicatorDoc.name, 'active_indicator');
        expect(
          activeIndicatorDoc.exports,
          containsAll(<String>['ActiveIndicator']),
        );
        expect(activeIndicatorDoc.command, 'elattar add active-indicator');
        expect(destination, isNull);
      },
    );

    testWidgets(
      'tapping the selected Toggle Group option deselects it — the pill '
      'holds its rect rather than travelling to the origin',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ThemeController(mode: ColorMode.dark),
            child: const ActiveIndicatorDocPage(),
          ),
        );
        await tester.pump();
        await tester.pump();

        final Finder group = find.descendant(
          of: find.byKey(
            const ValueKey<String>('active-indicator-example:toggle-group'),
          ),
          matching: find.byType(ActiveIndicator),
        );
        expect(tester.widget<ActiveIndicator>(group).activeIndex, 0);

        final Finder firstToggle = find
            .descendant(
              of: find.byKey(
                const ValueKey<String>('active-indicator-example:toggle-group'),
              ),
              matching: find.byType(Toggle),
            )
            .first;
        await tester.ensureVisible(firstToggle);
        await tester.pump();
        await tester.tap(firstToggle);
        // A fraction of the fade (MotionDurations.fast, 150ms): enough to prove
        // the state actually flipped, never `pumpAndSettle`.
        await tester.pump(const Duration(milliseconds: 40));

        expect(tester.widget<ActiveIndicator>(group).activeIndex, -1);
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
          child: const ActiveIndicatorDocPage(),
        ),
      );
      await tester.pump();
      await tester.pump();

      // Four EffectSection stages: Preview, Toggle Group, Tabs — Line,
      // Deselection.
      expect(find.byType(DocsShowcase), findsNWidgets(4));
      expect(find.byType(DocsInstall), findsOneWidget);
      expect(find.byType(DocsDisclosure), findsNWidgets(8));
    });

    test('the table of contents matches the declared sections', () {
      expect(
        slidingPillDocSpec.toc
            .map((DocsTocEntry entry) => entry.title)
            .toList(),
        <String>[
          'Preview',
          'Installation',
          'Usage',
          'Toggle Group',
          'Tabs — Line',
          'Deselection',
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
          child: const ActiveIndicatorDocPage(),
        ),
      );
      await tester.pump();
      await tester.pump();

      final List<String> titles = tester
          .widgetList<DocsSection>(find.byType(DocsSection))
          .map((DocsSection section) => section.title)
          .toList();

      expect(titles, <String>[
        'Preview',
        'Installation',
        'Usage',
        'Toggle Group',
        'Tabs — Line',
        'Deselection',
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
            child: const ActiveIndicatorDocPage(),
          ),
        );
        await tester.pump();
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('active-indicator-doc-article')),
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
          _harness(
            controller: controller,
            child: const ActiveIndicatorDocPage(),
          ),
        );
        await tester.pump();
        await tester.pump();

        final ThemeTokens darkTheme = ThemeScope.of(
          tester.element(
            find.byKey(const ValueKey<String>('active-indicator-doc-article')),
          ),
        );

        controller.setMode(ColorMode.light);
        await tester.pump();
        await tester.pump();

        final ThemeTokens lightTheme = ThemeScope.of(
          tester.element(
            find.byKey(const ValueKey<String>('active-indicator-doc-article')),
          ),
        );

        expect(lightTheme.background, isNot(darkTheme.background));
        expect(lightTheme.foreground, isNot(darkTheme.foreground));

        for (final String key in <String>[
          'active-indicator-preview:travels',
          'active-indicator-preview:blinks',
          'active-indicator-example:toggle-group',
          'active-indicator-example:tabs-line',
          'active-indicator-example:deselection',
        ]) {
          expect(find.byKey(ValueKey<String>(key)), findsOneWidget);
        }
      },
    );
  });
}
