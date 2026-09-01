import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/chart/meta.dart';
import 'package:example/components_docs/chart/page.dart';
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

/// The single `DocsDisclosure` whose title is [title], matching the kit's own
/// convention (`DocsDisclosure.triggerKey` is one constant shared by every
/// instance on the page).
Finder _disclosureTrigger(String title) => find.descendant(
  of: find.byWidgetPredicate(
    (Widget widget) => widget is DocsDisclosure && widget.title == title,
  ),
  matching: find.byKey(DocsDisclosure.triggerKey),
);

void main() {
  group('chart docs page', () {
    testWidgets(
      'renders the article and the full API table for every exported class, '
      'enum and function this page claims to document',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        String? destination;
        await tester.pumpWidget(
          _harness(
            controller: ThemeController(mode: ColorMode.dark),
            child: ChartDocPage(
              onNavigate: (String route) => destination = route,
            ),
          ),
        );
        // One frame is enough: nothing on this page loops.
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('chart-doc-article')),
          findsOneWidget,
        );

        final Finder apiTrigger = _disclosureTrigger('API Reference');
        await tester.ensureVisible(apiTrigger);
        await tester.pump();
        await tester.tap(apiTrigger);
        await tester.pump();
        await tester.pump(MotionDurations.open);

        // Every exported class, enum, and function chart.dart's own barrel
        // carries is named somewhere in the API Reference disclosure.
        for (final String export in chartDoc.exports) {
          expect(find.text(export), findsWidgets, reason: 'missing $export');
        }

        // Every ChartIndicator and ChartLegendAlign enum value the
        // ChartIndicator / ChartLegendAlign tables claim to document.
        for (final ChartIndicator value in ChartIndicator.values) {
          expect(
            find.text(value.name),
            findsWidgets,
            reason: 'ChartIndicator.${value.name} missing from API table',
          );
        }
        for (final ChartLegendAlign value in ChartLegendAlign.values) {
          expect(
            find.text(value.name),
            findsWidgets,
            reason: 'ChartLegendAlign.${value.name} missing from API table',
          );
        }

        // Live specimens actually mount: ChartTooltipContent in all three
        // ChartIndicator styles, and both wrap: false / wrap: true legends.
        final Set<ChartIndicator> mountedIndicators = tester
            .widgetList<ChartTooltipContent>(find.byType(ChartTooltipContent))
            .map((ChartTooltipContent w) => w.indicator)
            .toSet();
        expect(mountedIndicators, containsAll(ChartIndicator.values));

        final Set<bool> mountedWrap = tester
            .widgetList<ChartLegendContent>(find.byType(ChartLegendContent))
            .map((ChartLegendContent w) => w.wrap)
            .toSet();
        expect(mountedWrap, containsAll(<bool>[true, false]));

        // Every example specimen this page's own source keys carries its key
        // on the page.
        for (final String key in <String>[
          'chart-preview:tooltip',
          'chart-preview:legend',
          'chart-example:container-default',
          'chart-example:container-custom-height',
          'chart-example:tooltip-dot',
          'chart-example:tooltip-line',
          'chart-example:tooltip-dashed',
          'chart-example:legend-row',
          'chart-example:legend-wrap',
        ]) {
          expect(
            find.byKey(ValueKey<String>(key)),
            findsOneWidget,
            reason: 'missing example specimen $key',
          );
        }

        expect(chartDoc.name, 'chart');
        expect(chartDoc.command, 'elattar add chart');
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
          child: const ChartDocPage(),
        ),
      );
      await tester.pump();

      // Five specimen stages: Preview, Container, Tooltip, Legend, Number
      // formatting.
      expect(find.byType(DocsShowcase), findsNWidgets(5));
      expect(find.byType(DocsInstall), findsOneWidget);
      // Eight collapsed sections: API Reference, States, Accessibility,
      // Keyboard, Responsive, Dependencies, Theming, Source.
      expect(find.byType(DocsDisclosure), findsNWidgets(8));
    });

    test('the table of contents matches the declared sections', () {
      expect(
        chartDocSpec.toc.map((DocsTocEntry entry) => entry.title).toList(),
        <String>[
          'Preview',
          'Installation',
          'Usage',
          'Container',
          'Tooltip',
          'Legend',
          'Number formatting',
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

    testWidgets('sections render in declaration order', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final ThemeController controller = ThemeController(mode: ColorMode.dark);
      await tester.pumpWidget(
        _harness(controller: controller, child: const ChartDocPage()),
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
        'Container',
        'Tooltip',
        'Legend',
        'Number formatting',
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
            child: const ChartDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('chart-doc-article')),
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
          _harness(controller: controller, child: const ChartDocPage()),
        );
        await tester.pump();

        final ThemeTokens darkTheme = ThemeScope.of(
          tester.element(
            find.byKey(const ValueKey<String>('chart-doc-article')),
          ),
        );

        controller.setMode(ColorMode.light);
        await tester.pump();

        final ThemeTokens lightTheme = ThemeScope.of(
          tester.element(
            find.byKey(const ValueKey<String>('chart-doc-article')),
          ),
        );

        expect(lightTheme.background, isNot(darkTheme.background));
        expect(lightTheme.foreground, isNot(darkTheme.foreground));

        for (final String key in <String>[
          'chart-preview:tooltip',
          'chart-preview:legend',
          'chart-example:container-default',
          'chart-example:tooltip-dot',
          'chart-example:legend-row',
        ]) {
          expect(find.byKey(ValueKey<String>(key)), findsOneWidget);
        }
      },
    );
  });
}
