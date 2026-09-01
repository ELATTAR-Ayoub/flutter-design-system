import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/chart_cartesian/meta.dart';
import 'package:example/components_docs/chart_cartesian/page.dart';
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

/// Every named constructor parameter `CartesianChart`'s own class declares
/// (`lib/src/components/ui/chart_cartesian.dart`), excluding `key`.
const List<String> _cartesianConstructorParams = <String>[
  'data',
  'series',
  'margin',
  'layout',
  'grid',
  'xAxis',
  'yAxis',
  'legend',
  'tooltip',
  'stackOffsetExpand',
];

const List<String> _exampleKeys = <String>[
  'chart-cartesian-preview:area',
  'chart-cartesian-preview:bar',
  'chart-cartesian-preview:line',
  'chart-cartesian-example:area-default',
  'chart-cartesian-example:area-stacked',
  'chart-cartesian-example:bar-vertical',
  'chart-cartesian-example:bar-horizontal',
  'chart-cartesian-example:line-dots',
  'chart-cartesian-example:stacked-totals',
  'chart-cartesian-example:stacked-percent',
  'chart-cartesian-example:curve-linear',
  'chart-cartesian-example:curve-step',
  'chart-cartesian-example:curve-natural',
  'chart-cartesian-example:curve-monotone',
  'chart-cartesian-example:axes-grid',
  'chart-cartesian-example:tooltip-legend',
];

const List<String> _sectionTitles = <String>[
  'Preview',
  'Installation',
  'Usage',
  'Area',
  'Bar',
  'Line',
  'Stacking',
  'Curves',
  'Axes & Grid',
  'Tooltip & Legend',
  'API Reference',
  'States',
  'Accessibility',
  'Keyboard',
  'Responsive',
  'Dependencies',
  'Theming',
  'Source',
];

void main() {
  group('chart-cartesian docs page', () {
    testWidgets('renders the article and the full API table for every exported '
        'class, enum and constructor parameter this page claims to document', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 4000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      String? destination;
      await tester.pumpWidget(
        _harness(
          controller: ThemeController(mode: ColorMode.dark),
          child: ChartCartesianDocPage(
            onNavigate: (String route) => destination = route,
          ),
        ),
      );
      // One frame is enough: nothing on this page loops.
      await tester.pump();

      expect(
        find.byKey(const ValueKey<String>('chart-cartesian-doc-article')),
        findsOneWidget,
      );

      final Finder apiTrigger = _disclosureTrigger('API Reference');
      await tester.ensureVisible(apiTrigger);
      await tester.pump();
      await tester.tap(apiTrigger);
      await tester.pump();
      await tester.pump(MotionDurations.open);

      // Every exported class, enum, and function chart_cartesian.dart's
      // own barrel carries is named somewhere in the API Reference
      // disclosure.
      for (final String export in chartCartesianDoc.exports) {
        expect(find.text(export), findsWidgets, reason: 'missing $export');
      }

      // Every named constructor parameter CartesianChart itself
      // declares gets a row.
      for (final String param in _cartesianConstructorParams) {
        expect(
          find.text(param),
          findsWidgets,
          reason:
              '$param is a constructor parameter and must be '
              'documented',
        );
      }

      // Every example specimen this page's own source keys carries its
      // key on the page.
      for (final String key in _exampleKeys) {
        expect(
          find.byKey(ValueKey<String>(key)),
          findsOneWidget,
          reason: 'missing example specimen $key',
        );
      }

      expect(chartCartesianDoc.name, 'chart_cartesian');
      expect(chartCartesianDoc.command, 'elattar add chart-cartesian');
      expect(destination, isNull);
    });

    testWidgets('the page is declared, and every section is a kit component', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 6000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _harness(
          controller: ThemeController(mode: ColorMode.dark),
          child: const ChartCartesianDocPage(),
        ),
      );
      await tester.pump();

      // Eight specimen stages: Preview, Area, Bar, Line, Stacking,
      // Curves, Axes & Grid, Tooltip & Legend.
      expect(find.byType(DocsShowcase), findsNWidgets(8));
      expect(find.byType(DocsInstall), findsOneWidget);
      // Eight collapsed sections: API Reference, States, Accessibility,
      // Keyboard, Responsive, Dependencies, Theming, Source.
      expect(find.byType(DocsDisclosure), findsNWidgets(8));
    });

    test('the table of contents matches the declared sections', () {
      expect(
        chartCartesianDocSpec.toc
            .map((DocsTocEntry entry) => entry.title)
            .toList(),
        _sectionTitles,
      );
    });

    testWidgets('sections render in declaration order', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 6000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final ThemeController controller = ThemeController(mode: ColorMode.dark);
      await tester.pumpWidget(
        _harness(controller: controller, child: const ChartCartesianDocPage()),
      );
      await tester.pump();

      final List<String> titles = tester
          .widgetList<DocsSection>(find.byType(DocsSection))
          .map((DocsSection section) => section.title)
          .toList();

      expect(titles, _sectionTitles);
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
            child: const ChartCartesianDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('chart-cartesian-doc-article')),
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
        tester.view.physicalSize = const Size(1440, 4000);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        final ThemeController controller = ThemeController(
          mode: ColorMode.dark,
        );
        await tester.pumpWidget(
          _harness(
            controller: controller,
            child: const ChartCartesianDocPage(),
          ),
        );
        await tester.pump();

        final ThemeTokens darkTheme = ThemeScope.of(
          tester.element(
            find.byKey(const ValueKey<String>('chart-cartesian-doc-article')),
          ),
        );

        controller.setMode(ColorMode.light);
        await tester.pump();

        final ThemeTokens lightTheme = ThemeScope.of(
          tester.element(
            find.byKey(const ValueKey<String>('chart-cartesian-doc-article')),
          ),
        );

        expect(lightTheme.background, isNot(darkTheme.background));
        expect(lightTheme.foreground, isNot(darkTheme.foreground));

        for (final String key in <String>[
          'chart-cartesian-preview:area',
          'chart-cartesian-example:area-default',
          'chart-cartesian-example:bar-vertical',
          'chart-cartesian-example:line-dots',
        ]) {
          expect(find.byKey(ValueKey<String>(key)), findsOneWidget);
        }
      },
    );
  });
}
