import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/lift/meta.dart';
import 'package:example/components_docs/lift/page.dart';
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

/// Every named constructor parameter each exported class declares
/// (`lib/src/motion/lift.dart`), excluding `key`.
const List<String> _liftConstructorParams = <String>['builder', 'cursor'];
const List<String> _liftCardConstructorParams = <String>[
  'builder',
  'radius',
  'fill',
  'borderColor',
  'hoverBorderColor',
  'shadow',
  'padding',
  'onTap',
  'cursor',
];

void main() {
  group('lift docs page', () {
    testWidgets(
      'renders the article, both API tables, and every specimen this page '
      'claims to show',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        String? destination;
        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: LiftDocPage(
              onNavigate: (String route) => destination = route,
            ),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('lift-doc-article')),
          findsOneWidget,
        );

        final Finder apiTrigger = _disclosureTrigger('API Reference');
        await tester.ensureVisible(apiTrigger);
        await tester.pump();
        await tester.tap(apiTrigger);
        await tester.pump();
        await tester.pump(ElDurations.jelly);

        for (final String param in _liftConstructorParams) {
          expect(find.text(param), findsWidgets, reason: 'missing $param');
        }
        for (final String param in _liftCardConstructorParams) {
          expect(find.text(param), findsWidgets, reason: 'missing $param');
        }

        // A live ElLiftCard mounts on Preview's "Lifts on hover" column and
        // on Index Card: two. A live bare ElLift mounts on Bare Lift, and
        // ElLiftCard itself is built on ElLift, so ElLift totals three.
        expect(find.byType(ElLiftCard), findsNWidgets(2));
        expect(find.byType(ElLift), findsNWidgets(3));

        for (final String key in <String>[
          'lift-preview:lifts',
          'lift-preview:static',
          'lift-example:index-card',
          'lift-example:bare',
        ]) {
          expect(
            find.byKey(ValueKey<String>(key)),
            findsOneWidget,
            reason: 'missing example specimen $key',
          );
        }

        expect(liftDoc.name, 'lift');
        expect(
          liftDoc.exports,
          containsAll(<String>['ElLift', 'ElLiftCard']),
        );
        expect(liftDoc.command, 'elattar add lift');
        expect(destination, isNull);
      },
    );

    testWidgets(
      'a live mouse hover over the Preview lifting card actually starts '
      'the rise, without settling',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: const LiftDocPage(),
          ),
        );
        await tester.pump();

        final Finder card = find.byKey(
          const ValueKey<String>('lift-preview:lifts'),
        );
        await tester.ensureVisible(card);
        await tester.pump();

        final TestGesture gesture = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        addTearDown(() => gesture.removePointer());
        await gesture.addPointer(location: Offset.zero);
        await tester.pump();

        await gesture.moveTo(tester.getCenter(card));
        // One zero-duration pump lets MouseRegion.onEnter's setState land
        // and call AnimationController.forward() before the clock moves; a
        // fraction of the rise's own 250ms (ElDurations.base) then proves
        // the controller actually ticked — never `pumpAndSettle` (which
        // would hang on nothing here, but the house rule is never to reach
        // for it on a docs page regardless).
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        final Transform transform = tester.widget<Transform>(
          find
              .descendant(of: card, matching: find.byType(Transform))
              .first,
        );
        expect(transform.transform.getTranslation().y, lessThan(-0.01));
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
            child: const LiftDocPage(),
          ),
        );
        await tester.pump();

        // Three EffectSection stages: Preview, Index Card, Bare Lift.
        expect(find.byType(DocsShowcase), findsNWidgets(3));
        expect(find.byType(DocsInstall), findsOneWidget);
        expect(find.byType(DocsDisclosure), findsNWidgets(8));
      },
    );

    test('the table of contents matches the declared sections', () {
      expect(
        liftDocSpec.toc.map((DocsTocEntry entry) => entry.title).toList(),
        <String>[
          'Preview',
          'Installation',
          'Usage',
          'Index Card',
          'Bare Lift',
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
            child: const LiftDocPage(),
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
          'Index Card',
          'Bare Lift',
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
            child: const LiftDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('lift-doc-article')),
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
          _harness(controller: controller, child: const LiftDocPage()),
        );
        await tester.pump();

        final ElThemeData darkTheme = ElTheme.of(
          tester.element(
            find.byKey(const ValueKey<String>('lift-doc-article')),
          ),
        );

        controller.setMode(ElThemeMode.light);
        await tester.pump();

        final ElThemeData lightTheme = ElTheme.of(
          tester.element(
            find.byKey(const ValueKey<String>('lift-doc-article')),
          ),
        );

        expect(lightTheme.background, isNot(darkTheme.background));
        expect(lightTheme.foreground, isNot(darkTheme.foreground));

        for (final String key in <String>[
          'lift-preview:lifts',
          'lift-preview:static',
          'lift-example:index-card',
          'lift-example:bare',
        ]) {
          expect(find.byKey(ValueKey<String>(key)), findsOneWidget);
        }
      },
    );
  });
}
