import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/item/meta.dart';
import 'package:example/components_docs/item/page.dart';
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
  group('item docs page', () {
    testWidgets(
      'renders the article, the API tables, and live specimens of every part',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        String? destination;
        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: ItemDocPage(
              onNavigate: (String route) => destination = route,
            ),
          ),
        );

        expect(
          find.byKey(const ValueKey<String>('item-doc-article')),
          findsOneWidget,
        );

        for (final String param in <String>[
          'media',
          'content',
          'actions',
          'variant',
          'alignStart',
        ]) {
          expect(find.text(param), findsWidgets, reason: 'missing $param');
        }

        expect(find.byType(ElItemGroup), findsWidgets);
        expect(find.byType(ElItem), findsWidgets);
        expect(find.byType(ElItemMedia), findsWidgets);
        expect(find.byType(ElItemContent), findsWidgets);
        expect(find.byType(ElItemTitle), findsWidgets);
        expect(find.byType(ElItemDescription), findsWidgets);
        expect(find.byType(ElItemActions), findsWidgets);
        expect(find.byType(ElAvatar), findsWidgets);

        // Every ElItemVariant gets a live specimen.
        for (final ElItemVariant variant in ElItemVariant.values) {
          expect(
            find.byWidgetPredicate(
              (Widget w) => w is ElItem && w.variant == variant,
            ),
            findsWidgets,
            reason: 'missing a $variant specimen',
          );
        }

        expect(itemDoc.name, 'item');
        expect(
          itemDoc.exports,
          containsAll(<String>[
            'ElItemGroup',
            'ElItem',
            'ElItemVariant',
            'ElItemMedia',
            'ElItemContent',
            'ElItemTitle',
            'ElItemDescription',
            'ElItemActions',
          ]),
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
            child: const ItemDocPage(),
          ),
        );

        expect(
          find.byKey(const ValueKey<String>('item-doc-article')),
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
      'renders the shadcn-shaped section list, in order, with Size/Image/'
      'Header/Link/Dropdown honestly skipped',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: const ItemDocPage(),
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
          'item-vs-field',
          'variant',
          'icon',
          'avatar',
          'group',
          'rtl',
          'api',
          'states',
          'accessibility',
          'responsive',
          'dependencies',
          'theming',
          'source',
        ]);

        expect(sectionTitles, isNot(contains('Size')));
        expect(sectionTitles, isNot(contains('Image')));
        expect(sectionTitles, isNot(contains('Header')));
        expect(sectionTitles, isNot(contains('Link')));
        expect(sectionTitles, isNot(contains('Dropdown')));
      },
    );

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
              _harness(controller: controller, child: const ItemDocPage()),
            );

            expect(
              find.byKey(const ValueKey<String>('item-doc-article')),
              findsOneWidget,
              reason: 'at $size in $mode',
            );
            expect(find.byType(ElItem), findsWidgets);
          }
        }
      },
    );
  });
}
