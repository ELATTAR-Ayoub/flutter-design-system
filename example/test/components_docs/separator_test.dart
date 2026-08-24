import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/separator/meta.dart';
import 'package:example/components_docs/separator/page.dart';
import 'package:example/kit.dart' show ElSection;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness({
  required Widget child,
  required ElThemeController controller,
}) => ElTheme(
  controller: controller,
  child: MaterialApp(home: SingleChildScrollView(child: child)),
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
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: SeparatorDocPage(
              onNavigate: (String route) => destination = route,
            ),
          ),
        );

        expect(
          find.byKey(const ValueKey<String>('separator-doc-article')),
          findsOneWidget,
        );

        expect(find.text('orientation'), findsWidgets);

        expect(
          find.byWidgetPredicate(
            (Widget w) =>
                w is ElSeparator &&
                w.orientation == ElSeparatorOrientation.horizontal,
          ),
          findsWidgets,
        );
        expect(
          find.byWidgetPredicate(
            (Widget w) =>
                w is ElSeparator &&
                w.orientation == ElSeparatorOrientation.vertical,
          ),
          findsWidgets,
        );

        expect(separatorDoc.name, 'separator');
        expect(
          separatorDoc.exports,
          containsAll(<String>['ElSeparator', 'ElSeparatorOrientation']),
        );
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
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: const SeparatorDocPage(),
          ),
        );

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

        final ElThemeController controller = ElThemeController(
          mode: ElThemeMode.dark,
        );
        await tester.pumpWidget(
          _harness(controller: controller, child: const SeparatorDocPage()),
        );

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
        controller.setMode(ElThemeMode.light);
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

    testWidgets(
      'renders the shadcn-shaped section list, in order: Installation, '
      'Usage, then separator\'s own promoted sections, then API Reference, '
      'then the six extra sections',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: const SeparatorDocPage(),
          ),
        );

        final List<String> sectionIds = tester
            .widgetList<ElSection>(find.byType(ElSection))
            .map((ElSection section) => section.id)
            .toList();

        expect(sectionIds, <String>[
          'install',
          'usage',
          'vertical',
          'menu',
          'list',
          'rtl',
          'api',
          'states',
          'accessibility',
          'responsive',
          'dependencies',
          'theming',
          'source',
        ]);

        // No leftover "empty"/"kbd" content: those are their own pages now.
        expect(find.text('Empty: Input group'), findsNothing);
        expect(find.text('Kbd: Group'), findsNothing);
        expect(find.byType(ElEmpty), findsNothing);
        expect(find.byType(ElKbd), findsNothing);

        final Finder article = find.byKey(
          const ValueKey<String>('separator-doc-article'),
        );
        for (final String title in <String>[
          'Vertical',
          'Menu',
          'List',
          'RTL',
        ]) {
          expect(
            find.descendant(of: article, matching: find.text(title)),
            findsOneWidget,
            reason: 'missing $title',
          );
        }

        expect(
          find.descendant(of: article, matching: find.text('API Reference')),
          findsOneWidget,
        );
      },
    );
  });
}
