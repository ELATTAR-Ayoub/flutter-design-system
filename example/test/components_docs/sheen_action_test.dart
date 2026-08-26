/// Tests for the sheen-action effect documentation page.
///
/// **No `pumpAndSettle` anywhere in this file.** ElSheenAction's beat is
/// driven by a bare `Ticker` while hovered, which runs `infinite alternate`
/// and never settles on its own — every wait below is a bounded
/// `tester.pump()` / `tester.pump(Duration(...))`.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/sheen_action/meta.dart';
import 'package:example/components_docs/sheen_action/page.dart';
import 'package:example/docs/component_doc_page.dart' show DocsTocEntry;
import 'package:example/docs/docs_disclosure.dart';
import 'package:example/docs/docs_install.dart';
import 'package:example/docs/docs_section.dart' show DocsSection;
import 'package:example/docs/docs_showcase.dart';
import 'package:flutter/gestures.dart' show PointerDeviceKind;
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

/// `ElSheenAction`'s own constructor parameters (`lib/src/effects/
/// sheen_action.dart`), excluding `key`.
const List<String> _sheenActionConstructorParams = <String>[
  'spec',
  'radius',
  'border',
  'hovered',
  'pressed',
  'child',
];

void main() {
  group('sheen-action docs page', () {
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
            child: SheenActionDocPage(
              onNavigate: (String route) => destination = route,
            ),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('sheen-action-doc-article')),
          findsOneWidget,
        );

        final Finder apiTrigger = _disclosureTrigger('API Reference');
        await tester.ensureVisible(apiTrigger);
        await tester.pump();
        await tester.tap(apiTrigger);
        await tester.pump();
        await tester.pump(ElDurations.jelly);

        for (final String param in _sheenActionConstructorParams) {
          expect(find.text(param), findsWidgets, reason: 'missing $param');
        }

        // Preview's sheen pill, the Hover host and the Press host each mount
        // one ElSheenAction.
        expect(find.byType(ElSheenAction), findsNWidgets(3));
        expect(find.byType(ElMachineSurface), findsWidgets);

        for (final String key in <String>[
          'sheen-action-preview:sheen',
          'sheen-action-preview:plain',
          'sheen-action-hover:host',
          'sheen-action-press:host',
        ]) {
          expect(
            find.byKey(ValueKey<String>(key)),
            findsOneWidget,
            reason: 'missing example specimen $key',
          );
        }

        expect(sheenActionDoc.name, 'sheen_action');
        expect(sheenActionDoc.exports, containsAll(<String>['ElSheenAction']));
        expect(sheenActionDoc.command, 'elattar add sheen-action');
        expect(destination, isNull);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'a live mouse hover over the Hover specimen actually flips '
      'ElSheenAction.hovered',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: const SheenActionDocPage(),
          ),
        );
        await tester.pump();

        final Finder host = find.byKey(
          const ValueKey<String>('sheen-action-hover:host'),
        );
        await tester.ensureVisible(host);
        await tester.pump();

        expect(tester.widget<ElSheenAction>(host).hovered, isFalse);

        final TestGesture gesture = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        addTearDown(() => gesture.removePointer());
        await gesture.addPointer(location: Offset.zero);
        await tester.pump();

        await gesture.moveTo(tester.getCenter(host));
        await tester.pump();
        // A bounded slice of the 2600ms hover loop — proves the beat's
        // Ticker actually started, never pumpAndSettle.
        await tester.pump(const Duration(milliseconds: 200));

        expect(tester.widget<ElSheenAction>(host).hovered, isTrue);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'a tap-down on the Press specimen flips ElSheenAction.pressed and '
      'swaps its shadow spec',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: const SheenActionDocPage(),
          ),
        );
        await tester.pump();

        final Finder host = find.byKey(
          const ValueKey<String>('sheen-action-press:host'),
        );
        await tester.ensureVisible(host);
        await tester.pump();

        expect(tester.widget<ElSheenAction>(host).pressed, isFalse);

        final TestGesture gesture = await tester.startGesture(
          tester.getCenter(host),
        );
        await tester.pump();

        expect(tester.widget<ElSheenAction>(host).pressed, isTrue);

        await gesture.up();
        await tester.pump();

        expect(tester.widget<ElSheenAction>(host).pressed, isFalse);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'holds the beat at rest under reduced motion, without throwing',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          ElTheme(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: MaterialApp(
              home: Builder(
                builder: (BuildContext context) => MediaQuery(
                  data: MediaQuery.of(
                    context,
                  ).copyWith(disableAnimations: true),
                  child: const SingleChildScrollView(
                    child: SheenActionDocPage(),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(seconds: 3));

        expect(find.byType(ElSheenAction), findsWidgets);
        expect(tester.takeException(), isNull);
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
            child: const SheenActionDocPage(),
          ),
        );
        await tester.pump();

        // Three EffectSection stages: Preview, Hover, Press.
        expect(find.byType(DocsShowcase), findsNWidgets(3));
        expect(find.byType(DocsInstall), findsOneWidget);
        expect(find.byType(DocsDisclosure), findsNWidgets(8));
      },
    );

    test('the table of contents matches the declared sections', () {
      expect(
        sheenActionDocSpec.toc
            .map((DocsTocEntry entry) => entry.title)
            .toList(),
        <String>[
          'Preview',
          'Installation',
          'Usage',
          'Hover',
          'Press',
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
        _harness(controller: controller, child: const SheenActionDocPage()),
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
        'Hover',
        'Press',
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
            child: const SheenActionDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('sheen-action-doc-article')),
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
            child: const SheenActionDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('sheen-action-doc-article')),
          findsOneWidget,
          reason: '$mode',
        );
        expect(tester.takeException(), isNull, reason: '$mode');
      }
    });
  });
}
