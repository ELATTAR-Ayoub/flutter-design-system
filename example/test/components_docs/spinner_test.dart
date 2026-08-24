import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/spinner/meta.dart';
import 'package:example/components_docs/spinner/page.dart';
import 'package:example/kit.dart' show ElSection;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// This page's own section order: see
/// `example/lib/components_docs/spinner/page.dart`'s own library doc. Only
/// Customization is skipped from the reference's own section list:
/// [ElSpinner] exposes no `icon`/`glyph` constructor parameter, so there is
/// nothing to swap. Button, Badge, Input Group, Empty and RTL are all real
/// compositions with [ElButton], [ElBadge], [ElInputGroup], [ElEmpty] and a
/// [Directionality] wrapper. API Reference is last, ahead of the corpus's
/// fixed closing five.
const List<String> _spinnerSectionOrder = <String>[
  'install',
  'usage',
  'size',
  'button',
  'badge',
  'input-group',
  'empty',
  'rtl',
  'api',
  'states',
  'accessibility',
  'responsive',
  'dependencies',
  'theming',
  'source',
];

Widget _harness({
  required Widget child,
  required ElThemeController controller,
}) => ElTheme(
  controller: controller,
  child: MaterialApp(home: SingleChildScrollView(child: child)),
);

void main() {
  group('spinner docs page', () {
    testWidgets('renders the article, never settling on the spinner', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      String? destination;
      await tester.pumpWidget(
        _harness(
          controller: ElThemeController(mode: ElThemeMode.dark),
          child: SpinnerDocPage(
            onNavigate: (String route) => destination = route,
          ),
        ),
      );
      // One bounded pump only: ElSpinner's AnimationController.repeat()
      // never settles, so pumpAndSettle() would hang forever.
      await tester.pump();

      expect(
        find.byKey(const ValueKey<String>('spinner-doc-article')),
        findsOneWidget,
      );

      // At least one spinner mounts per composed example (hero, size x2,
      // button x2, badge x2, input group, empty, rtl).
      expect(find.byType(ElSpinner), findsWidgets);
      final int spinnerCount = tester
          .widgetList<ElSpinner>(find.byType(ElSpinner))
          .length;
      expect(spinnerCount, greaterThanOrEqualTo(9));

      // Metadata reads correctly.
      expect(spinnerDoc.name, 'spinner');
      expect(spinnerDoc.dependencies, <String>['icon', 'source-foundation']);
      expect(spinnerDoc.exports, <String>['ElSpinner']);
      expect(spinnerDoc.command, 'elattar add spinner');

      expect(destination, isNull);

      // Every section renders, in exactly the order the page declares.
      double? previousTop;
      for (final String id in _spinnerSectionOrder) {
        final Finder finder = find.byKey(ElSection.anchorKey(id));
        expect(finder, findsOneWidget, reason: 'missing section "$id"');
        final double top = tester.getTopLeft(finder).dy;
        if (previousTop != null) {
          expect(
            top,
            greaterThan(previousTop),
            reason: '"$id" is out of order',
          );
        }
        previousTop = top;
      }

      final List<String> titles = tester
          .widgetList<ElSection>(find.byType(ElSection))
          .map((ElSection section) => section.title)
          .toList();
      expect(titles, <String>[
        'Installation',
        'Usage',
        'Size',
        'Button',
        'Badge',
        'Input Group',
        'Empty',
        'RTL',
        'API Reference',
        'States',
        'Accessibility',
        'Responsive',
        'Dependencies',
        'Theming',
        'Source',
      ]);

      // No "Customization" heading: the honestly-skipped section.
      expect(find.text('Customization'), findsNothing);
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
            child: const SpinnerDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('spinner-doc-article')),
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
      'spinner rotates under normal motion, holds under reduced motion',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        final ElThemeController controller = ElThemeController(
          mode: ElThemeMode.dark,
        );

        // Normal motion: rotation progresses across two bounded pumps.
        await tester.pumpWidget(
          _harness(controller: controller, child: const SpinnerDocPage()),
        );
        await tester.pump();

        final Finder rotationFinder = find.byType(RotationTransition);
        expect(rotationFinder, findsWidgets);

        final RotationTransition rotation1 = tester.widget<RotationTransition>(
          rotationFinder.first,
        );
        final double value1 = rotation1.turns.value;

        await tester.pump(const Duration(milliseconds: 100));

        final RotationTransition rotation2 = tester.widget<RotationTransition>(
          rotationFinder.first,
        );
        final double value2 = rotation2.turns.value;

        expect(
          value2,
          greaterThan(value1),
          reason: 'spinner did not rotate under normal motion',
        );
      },
    );

    testWidgets('spinner holds still under reduced motion', (
      WidgetTester tester,
    ) async {
      // `MediaQuery(disableAnimations: true)` sits BELOW `MaterialApp`, the
      // same discipline `collapsible_test.dart` and `buttons_page_test.dart`
      // use, so it reaches every descendant `ElSpinner` through the real
      // `elAnimationDuration` reduced-motion path.
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        ElTheme(
          controller: ElThemeController(mode: ElThemeMode.dark),
          child: MaterialApp(
            home: Builder(
              builder: (BuildContext context) => MediaQuery(
                data: MediaQuery.of(context).copyWith(disableAnimations: true),
                child: const SingleChildScrollView(child: SpinnerDocPage()),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      final Finder rotationFinder = find.byType(RotationTransition);
      expect(rotationFinder, findsWidgets);

      final RotationTransition rotation1 = tester.widget<RotationTransition>(
        rotationFinder.first,
      );
      final double value1 = rotation1.turns.value;

      await tester.pump(const Duration(milliseconds: 500));

      final RotationTransition rotation2 = tester.widget<RotationTransition>(
        rotationFinder.first,
      );
      final double value2 = rotation2.turns.value;

      expect(
        value2,
        value1,
        reason: 'spinner rotated even though disableAnimations was set',
      );
    });
  });
}
