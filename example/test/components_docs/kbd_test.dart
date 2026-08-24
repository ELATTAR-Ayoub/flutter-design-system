import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/kbd/meta.dart';
import 'package:example/components_docs/kbd/page.dart';
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
  group('kbd docs page', () {
    testWidgets(
      'renders the article, the API tables, and live specimens of ElKbd '
      'and ElKbdGroup',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        String? destination;
        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: KbdDocPage(
              onNavigate: (String route) => destination = route,
            ),
          ),
        );

        expect(
          find.byKey(const ValueKey<String>('kbd-doc-article')),
          findsOneWidget,
        );

        expect(find.text('text'), findsWidgets);
        expect(find.text('children'), findsWidgets);

        expect(find.byType(ElKbd), findsWidgets);
        expect(find.byType(ElKbdGroup), findsWidgets);

        expect(kbdDoc.name, 'kbd');
        expect(kbdDoc.exports, containsAll(<String>['ElKbd', 'ElKbdGroup']));
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
            child: const KbdDocPage(),
          ),
        );

        expect(
          find.byKey(const ValueKey<String>('kbd-doc-article')),
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
      'renders the shadcn-shaped section list, in order, with Tooltip '
      'honestly skipped',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: const KbdDocPage(),
          ),
        );

        final List<ElSection> sections = tester
            .widgetList<ElSection>(find.byType(ElSection))
            .toList();
        final List<String> sectionIds = sections
            .map((ElSection section) => section.id)
            .toList();
        final List<String> sectionTitles = sections
            .map((ElSection section) => section.title)
            .toList();

        expect(sectionIds, <String>[
          'install',
          'usage',
          'composition',
          'group',
          'button',
          'input-group',
          'rtl',
          'api',
          'states',
          'accessibility',
          'responsive',
          'dependencies',
          'theming',
          'source',
        ]);

        expect(sectionTitles, isNot(contains('Tooltip')));
      },
    );

    testWidgets('ElKbdGroup merges its children\'s semantics into one node', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _harness(
          controller: ElThemeController(mode: ElThemeMode.dark),
          child: const KbdDocPage(),
        ),
      );

      expect(find.byType(MergeSemantics), findsWidgets);
    });

    testWidgets(
      'components render correctly in both themes at both breakpoints',
      (WidgetTester tester) async {
        for (final Size size in <Size>[
          const Size(390, 844),
          const Size(1440, 900),
        ]) {
          for (final ElThemeMode mode in <ElThemeMode>[
            ElThemeMode.light,
            ElThemeMode.dark,
          ]) {
            tester.view.physicalSize = size;
            tester.view.devicePixelRatio = 1;
            addTearDown(tester.view.reset);

            final ElThemeController controller = ElThemeController(mode: mode);
            await tester.pumpWidget(
              _harness(controller: controller, child: const KbdDocPage()),
            );

            expect(
              find.byKey(const ValueKey<String>('kbd-doc-article')),
              findsOneWidget,
              reason: 'at $size in $mode',
            );
            expect(find.byType(ElKbd), findsWidgets);
          }
        }
      },
    );
  });
}
