import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/foil_value/meta.dart';
import 'package:example/components_docs/foil_value/page.dart';
import 'package:example/docs/component_doc_page.dart' show DocsTocEntry;
import 'package:example/docs/docs_disclosure.dart';
import 'package:example/docs/docs_install.dart';
import 'package:example/docs/docs_section.dart' show DocsSection;
import 'package:example/docs/docs_showcase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness({
  required Widget child,
  required ElThemeController controller,
}) => ElTheme(
  controller: controller,
  child: MaterialApp(home: SingleChildScrollView(child: child)),
);

Finder _disclosureTrigger(String title) => find.descendant(
  of: find.byWidgetPredicate(
    (Widget widget) => widget is DocsDisclosure && widget.title == title,
  ),
  matching: find.byKey(DocsDisclosure.triggerKey),
);

/// Every named constructor parameter `ElFoilValue`'s own class declares
/// (`lib/src/effects/foil_value.dart`), excluding `key`.
const List<String> _foilValueConstructorParams = <String>[
  'spec',
  'radius',
  'border',
  'hovered',
  'child',
];

void main() {
  group('foil-value docs page', () {
    testWidgets(
      'renders the article and the full API table',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        String? destination;
        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: FoilValueDocPage(
              onNavigate: (String route) => destination = route,
            ),
          ),
        );
        // One frame only — never pumpAndSettle: the foil drift and the
        // glint sweep both run on a Ticker that repeats forever.
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('foil-value-doc-article')),
          findsOneWidget,
        );

        final Finder apiTrigger = _disclosureTrigger('API Reference');
        await tester.ensureVisible(apiTrigger);
        await tester.pump();
        await tester.tap(apiTrigger);
        await tester.pump();
        await tester.pump(ElDurations.jelly);

        for (final String param in _foilValueConstructorParams) {
          expect(find.text(param), findsWidgets, reason: 'missing $param');
        }

        for (final String key in <String>[
          'foil-value-example:flat',
          'foil-value-example:preview',
          'foil-value-example:rest',
          'foil-value-example:hovered',
          'foil-value-example:motion',
          'foil-value-example:reduced-motion',
        ]) {
          expect(
            find.byKey(ValueKey<String>(key)),
            findsOneWidget,
            reason: 'missing example specimen $key',
          );
        }

        // A live ElFoilValue specimen mounts for preview, hovered (x2)
        // and reduced motion (x2) — five in total.
        expect(find.byType(ElFoilValue), findsNWidgets(5));

        // The Hovered example specimens actually carry the hovered value
        // their key claims.
        final ElFoilValue rest = tester.widget<ElFoilValue>(
          find.descendant(
            of: find.byKey(const ValueKey<String>('foil-value-example:rest')),
            matching: find.byType(ElFoilValue),
          ),
        );
        expect(rest.hovered, isFalse);
        final ElFoilValue hovered = tester.widget<ElFoilValue>(
          find.descendant(
            of: find.byKey(
              const ValueKey<String>('foil-value-example:hovered'),
            ),
            matching: find.byType(ElFoilValue),
          ),
        );
        expect(hovered.hovered, isTrue);

        expect(foilValueDoc.name, 'foil_value');
        expect(foilValueDoc.exports, containsAll(<String>['ElFoilValue']));
        expect(foilValueDoc.command, 'elattar add foil-value');
        expect(destination, isNull);
      },
    );

    testWidgets(
      'advances the foil and glint clocks by a frame without throwing',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: const FoilValueDocPage(),
          ),
        );
        await tester.pump();
        // Advance the shared Ticker by a bounded duration — never
        // pumpAndSettle, which would hang on a perpetual animation.
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(seconds: 2));

        expect(tester.takeException(), isNull);
        expect(find.byType(ElFoilValue), findsNWidgets(5));
      },
    );

    testWidgets(
      'the page is declared, and every section is a kit component',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 4000);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: const FoilValueDocPage(),
          ),
        );
        await tester.pump();

        // Three specimen stages: Preview, Hovered, Reduced Motion.
        expect(find.byType(DocsShowcase), findsNWidgets(3));
        expect(find.byType(DocsInstall), findsOneWidget);
        expect(find.byType(DocsDisclosure), findsNWidgets(8));
      },
    );

    test('the table of contents matches the declared sections', () {
      expect(
        foilValueDocSpec.toc.map((DocsTocEntry entry) => entry.title).toList(),
        <String>[
          'Preview',
          'Installation',
          'Usage',
          'Hovered',
          'Reduced Motion',
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

      final ElThemeController controller = ElThemeController(
        mode: ElThemeMode.dark,
      );
      await tester.pumpWidget(
        _harness(controller: controller, child: const FoilValueDocPage()),
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
        'Hovered',
        'Reduced Motion',
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
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: const FoilValueDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('foil-value-doc-article')),
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

    testWidgets('renders in both themes without throwing', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      for (final ElThemeMode mode in <ElThemeMode>[
        ElThemeMode.dark,
        ElThemeMode.light,
      ]) {
        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: mode),
            child: const FoilValueDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('foil-value-doc-article')),
          findsOneWidget,
          reason: '$mode',
        );
        expect(tester.takeException(), isNull, reason: '$mode');
      }
    });
  });
}
