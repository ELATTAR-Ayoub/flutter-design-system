import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/press_motion/meta.dart';
import 'package:example/components_docs/press_motion/page.dart';
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

/// The scale a widget is currently drawn at, read off the first [Transform]
/// under [of] — the same idiom `test/motion_test.dart` uses for `ElPress`.
double _scaleOf(WidgetTester tester, Finder of) {
  final Transform transform = tester.widget<Transform>(
    find.descendant(of: of, matching: find.byType(Transform)).first,
  );
  return transform.transform.storage[0];
}

/// Every named constructor parameter `ElPress`'s own class declares
/// (`lib/src/motion/press.dart`), excluding `key`.
const List<String> _pressConstructorParams = <String>[
  'scale',
  'child',
  'onTap',
  'behavior',
  'downDuration',
  'upDuration',
];

const List<String> _exampleKeys = <String>[
  'press-motion-example:wrapped',
  'press-motion-example:bare',
  'press-motion-example:press-scale',
  'press-motion-example:button-scale',
  'press-motion-example:click-spring-scale',
];

void main() {
  group('press-motion docs page', () {
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
            child: PressMotionDocPage(
              onNavigate: (String route) => destination = route,
            ),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('press-motion-doc-article')),
          findsOneWidget,
        );

        final Finder apiTrigger = _disclosureTrigger('API Reference');
        await tester.ensureVisible(apiTrigger);
        await tester.pump();
        await tester.tap(apiTrigger);
        await tester.pump();
        await tester.pump(ElDurations.jelly);

        for (final String param in _pressConstructorParams) {
          expect(find.text(param), findsWidgets, reason: 'missing $param');
        }

        for (final String key in _exampleKeys) {
          expect(
            find.byKey(ValueKey<String>(key)),
            findsOneWidget,
            reason: 'missing example specimen $key',
          );
        }

        // One live ElPress on Preview's wrapped chip, three more on the
        // Custom Scale specimens: four in total. The right-hand Preview
        // chip and none of the Custom Scale captions mount a second one.
        expect(find.byType(ElPress), findsNWidgets(4));

        expect(pressMotionDoc.name, 'press_motion');
        expect(pressMotionDoc.exports, containsAll(<String>['ElPress']));
        expect(pressMotionDoc.command, 'elattar add press-motion');
        expect(destination, isNull);
      },
    );

    testWidgets(
      'a live pointer down/up on the Preview specimen actually squishes '
      'and springs back',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: const PressMotionDocPage(),
          ),
        );
        await tester.pump();

        final Finder wrapped = find.byKey(
          const ValueKey<String>('press-motion-example:wrapped'),
        );
        await tester.ensureVisible(wrapped);
        await tester.pump();

        final Finder press = find.descendant(
          of: wrapped,
          matching: find.byType(ElPress),
        );
        expect(_scaleOf(tester, press), 1.0, reason: 'at rest');

        final TestGesture gesture = await tester.startGesture(
          tester.getCenter(press),
        );
        // Never pumpAndSettle: a bounded pump proves the controller ticked.
        await tester.pump();
        await tester.pump(ElDurations.pressDown);
        expect(_scaleOf(tester, press), closeTo(ElTransforms.pressScale, 1e-6));

        await gesture.up();
        await tester.pump();
        await tester.pump(ElDurations.base);
        expect(_scaleOf(tester, press), closeTo(1.0, 1e-6));
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
            child: const PressMotionDocPage(),
          ),
        );
        await tester.pump();

        // Two EffectSection stages: Preview, Custom Scale.
        expect(find.byType(DocsShowcase), findsNWidgets(2));
        expect(find.byType(DocsInstall), findsOneWidget);
        expect(find.byType(DocsDisclosure), findsNWidgets(8));
      },
    );

    test('the table of contents matches the declared sections', () {
      expect(
        pressMotionDocSpec.toc.map((DocsTocEntry entry) => entry.title).toList(),
        <String>[
          'Preview',
          'Installation',
          'Usage',
          'Custom Scale',
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

      await tester.pumpWidget(
        _harness(
          controller: ElThemeController(mode: ElThemeMode.dark),
          child: const PressMotionDocPage(),
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
        'Custom Scale',
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
            child: const PressMotionDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('press-motion-doc-article')),
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
            child: const PressMotionDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('press-motion-doc-article')),
          findsOneWidget,
          reason: '$mode',
        );
        expect(tester.takeException(), isNull, reason: '$mode');
      }
    });
  });
}
