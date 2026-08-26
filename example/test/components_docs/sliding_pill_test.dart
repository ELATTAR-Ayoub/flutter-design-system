import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/sliding_pill/meta.dart';
import 'package:example/components_docs/sliding_pill/page.dart';
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

/// Every named constructor parameter `ElSlidingPillGroup`'s own class
/// declares (`lib/src/motion/sliding_pill.dart`), excluding `key`.
const List<String> _pillConstructorParams = <String>[
  'activeIndex',
  'pill',
  'children',
  'padding',
  'gap',
  'travelDuration',
  'jellyAlignment',
];

void main() {
  group('sliding-pill docs page', () {
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
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: SlidingPillDocPage(
              onNavigate: (String route) => destination = route,
            ),
          ),
        );
        // A sliding pill re-measures via a post-frame callback: one extra
        // pump settles that without ever approaching pumpAndSettle.
        await tester.pump();
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('sliding-pill-doc-article')),
          findsOneWidget,
        );

        final Finder apiTrigger = _disclosureTrigger('API Reference');
        await tester.ensureVisible(apiTrigger);
        await tester.pump();
        await tester.tap(apiTrigger);
        await tester.pump();
        await tester.pump(ElDurations.jelly);

        for (final String param in _pillConstructorParams) {
          expect(find.text(param), findsWidgets, reason: 'missing $param');
        }

        // A live ElSlidingPillGroup mounts for Preview's "Travels" column,
        // Toggle Group, Tabs — Line, and Deselection: four. Not asserted as
        // a page-wide `findsNWidgets`: `ElToggleGroup` (the docs kit's own
        // Preview/Code and CLI/Manual toggles, in `DocsShowcase` and
        // `DocsInstall`) is itself built on ElSlidingPillGroup and mounts
        // one per showcase plus one for Installation, so the page-wide
        // total is 9, not 4. The per-key checks below are the real
        // assertion.
        for (final String key in <String>[
          'sliding-pill-preview:travels',
          'sliding-pill-preview:blinks',
          'sliding-pill-example:toggle-group',
          'sliding-pill-example:tabs-line',
          'sliding-pill-example:deselection',
        ]) {
          expect(
            find.byKey(ValueKey<String>(key)),
            findsOneWidget,
            reason: 'missing example specimen $key',
          );
        }

        expect(slidingPillDoc.name, 'sliding_pill');
        expect(
          slidingPillDoc.exports,
          containsAll(<String>['ElSlidingPillGroup']),
        );
        expect(slidingPillDoc.command, 'elattar add sliding-pill');
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
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: const SlidingPillDocPage(),
          ),
        );
        await tester.pump();
        await tester.pump();

        final Finder group = find.descendant(
          of: find.byKey(
            const ValueKey<String>('sliding-pill-example:toggle-group'),
          ),
          matching: find.byType(ElSlidingPillGroup),
        );
        expect(tester.widget<ElSlidingPillGroup>(group).activeIndex, 0);

        final Finder firstToggle = find
            .descendant(
              of: find.byKey(
                const ValueKey<String>('sliding-pill-example:toggle-group'),
              ),
              matching: find.byType(ElToggle),
            )
            .first;
        await tester.ensureVisible(firstToggle);
        await tester.pump();
        await tester.tap(firstToggle);
        // A fraction of the fade (ElDurations.fast, 150ms): enough to prove
        // the state actually flipped, never `pumpAndSettle`.
        await tester.pump(const Duration(milliseconds: 40));

        expect(tester.widget<ElSlidingPillGroup>(group).activeIndex, -1);
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
            child: const SlidingPillDocPage(),
          ),
        );
        await tester.pump();
        await tester.pump();

        // Four EffectSection stages: Preview, Toggle Group, Tabs — Line,
        // Deselection.
        expect(find.byType(DocsShowcase), findsNWidgets(4));
        expect(find.byType(DocsInstall), findsOneWidget);
        expect(find.byType(DocsDisclosure), findsNWidgets(8));
      },
    );

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

    testWidgets(
      'sections render in declaration order, section for section',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: const SlidingPillDocPage(),
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
            child: const SlidingPillDocPage(),
          ),
        );
        await tester.pump();
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('sliding-pill-doc-article')),
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
          _harness(controller: controller, child: const SlidingPillDocPage()),
        );
        await tester.pump();
        await tester.pump();

        final ElThemeData darkTheme = ElTheme.of(
          tester.element(
            find.byKey(const ValueKey<String>('sliding-pill-doc-article')),
          ),
        );

        controller.setMode(ElThemeMode.light);
        await tester.pump();
        await tester.pump();

        final ElThemeData lightTheme = ElTheme.of(
          tester.element(
            find.byKey(const ValueKey<String>('sliding-pill-doc-article')),
          ),
        );

        expect(lightTheme.background, isNot(darkTheme.background));
        expect(lightTheme.foreground, isNot(darkTheme.foreground));

        for (final String key in <String>[
          'sliding-pill-preview:travels',
          'sliding-pill-preview:blinks',
          'sliding-pill-example:toggle-group',
          'sliding-pill-example:tabs-line',
          'sliding-pill-example:deselection',
        ]) {
          expect(find.byKey(ValueKey<String>(key)), findsOneWidget);
        }
      },
    );
  });
}
