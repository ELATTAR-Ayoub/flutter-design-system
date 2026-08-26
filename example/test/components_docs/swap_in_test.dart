import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/swap_in/meta.dart';
import 'package:example/components_docs/swap_in/page.dart';
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

/// Every named constructor parameter `ElSwapIn`'s own class declares
/// (`lib/src/motion/swap_in.dart`), excluding `key`.
const List<String> _swapInConstructorParams = <String>['child', 'replayKey'];

void main() {
  group('swap-in docs page', () {
    testWidgets(
      'renders the article, the full API table, and every specimen this '
      'page claims to show',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        String? destination;
        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: SwapInDocPage(
              onNavigate: (String route) => destination = route,
            ),
          ),
        );
        // One frame: the mount spring plays once on every specimen and must
        // never be settled on.
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('swap-in-doc-article')),
          findsOneWidget,
        );

        final Finder apiTrigger = _disclosureTrigger('API Reference');
        await tester.ensureVisible(apiTrigger);
        await tester.pump();
        await tester.tap(apiTrigger);
        await tester.pump();
        await tester.pump(ElDurations.jelly);

        for (final String param in _swapInConstructorParams) {
          expect(find.text(param), findsWidgets, reason: 'missing $param');
        }
        expect(find.text('duration'), findsWidgets);
        expect(find.text('curve'), findsWidgets);

        // A live ElSwapIn specimen mounts on Preview's "Springs in" column,
        // Stat Figure, and both halves of Replay Key: four.
        expect(find.byType(ElSwapIn), findsNWidgets(4));

        for (final String key in <String>[
          'swap-in-preview:springs',
          'swap-in-preview:instant',
          'swap-in-example:stat-figure',
          'swap-in-example:replay-keyed',
          'swap-in-example:replay-unkeyed',
        ]) {
          expect(
            find.byKey(ValueKey<String>(key)),
            findsOneWidget,
            reason: 'missing example specimen $key',
          );
        }

        expect(swapInDoc.name, 'swap_in');
        expect(swapInDoc.exports, containsAll(<String>['ElSwapIn']));
        expect(swapInDoc.command, 'elattar add swap-in');
        expect(destination, isNull);
      },
    );

    testWidgets(
      'the keyed specimen changes its replayKey and the unkeyed one keeps '
      'null, exactly as the section claims',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: const SwapInDocPage(),
          ),
        );
        await tester.pump();

        final Finder keyed = find.descendant(
          of: find.byKey(
            const ValueKey<String>('swap-in-example:replay-keyed'),
          ),
          matching: find.byType(ElSwapIn),
        );
        final Finder unkeyed = find.descendant(
          of: find.byKey(
            const ValueKey<String>('swap-in-example:replay-unkeyed'),
          ),
          matching: find.byType(ElSwapIn),
        );

        expect(tester.widget<ElSwapIn>(unkeyed).replayKey, isNull);
        final Object? before = tester.widget<ElSwapIn>(keyed).replayKey;

        final Finder changeBoth = find.widgetWithText(ElButton, 'Change both');
        await tester.ensureVisible(changeBoth);
        await tester.pump();
        await tester.tap(changeBoth);
        // A fraction of the spring's own 250ms (ElDurations.base): enough
        // to prove the key actually changed, never `pumpAndSettle`.
        await tester.pump(const Duration(milliseconds: 40));

        expect(tester.widget<ElSwapIn>(keyed).replayKey, isNot(before));
        expect(tester.widget<ElSwapIn>(unkeyed).replayKey, isNull);
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
            child: const SwapInDocPage(),
          ),
        );
        await tester.pump();

        // Three EffectSection stages: Preview, Stat Figure, Replay Key.
        expect(find.byType(DocsShowcase), findsNWidgets(3));
        expect(find.byType(DocsInstall), findsOneWidget);
        expect(find.byType(DocsDisclosure), findsNWidgets(8));
      },
    );

    test('the table of contents matches the declared sections', () {
      expect(
        swapInDocSpec.toc.map((DocsTocEntry entry) => entry.title).toList(),
        <String>[
          'Preview',
          'Installation',
          'Usage',
          'Stat Figure',
          'Replay Key',
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
      'sections render in declaration order, section for section',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: const SwapInDocPage(),
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
          'Stat Figure',
          'Replay Key',
          'API Reference',
          'States',
          'Accessibility',
          'Keyboard',
          'Responsive',
          'Dependencies',
          'Theming',
          'Source',
        ]);
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
            child: const SwapInDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('swap-in-doc-article')),
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

        final ElThemeController controller = ElThemeController(
          mode: ElThemeMode.dark,
        );
        await tester.pumpWidget(
          _harness(controller: controller, child: const SwapInDocPage()),
        );
        await tester.pump();

        final ElThemeData darkTheme = ElTheme.of(
          tester.element(
            find.byKey(const ValueKey<String>('swap-in-doc-article')),
          ),
        );

        controller.setMode(ElThemeMode.light);
        await tester.pump();

        final ElThemeData lightTheme = ElTheme.of(
          tester.element(
            find.byKey(const ValueKey<String>('swap-in-doc-article')),
          ),
        );

        expect(lightTheme.background, isNot(darkTheme.background));
        expect(lightTheme.foreground, isNot(darkTheme.foreground));

        for (final String key in <String>[
          'swap-in-preview:springs',
          'swap-in-preview:instant',
          'swap-in-example:stat-figure',
          'swap-in-example:replay-keyed',
          'swap-in-example:replay-unkeyed',
        ]) {
          expect(find.byKey(ValueKey<String>(key)), findsOneWidget);
        }
      },
    );
  });
}
