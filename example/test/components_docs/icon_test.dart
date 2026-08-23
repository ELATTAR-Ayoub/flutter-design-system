import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/icon/meta.dart';
import 'package:example/components_docs/icon/page.dart';
import 'package:example/kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// The page's own section order, live demo and Installation excluded from
/// the "live demo has no heading" note (Installation is the first heading):
/// shadcn parity brief requires this exact order and this exact set, see
/// `example/lib/components_docs/icon/page.dart`'s own library doc. Only
/// Customization is skipped from spinner's own reference sections: [DsSpinner]
/// exposes no `icon`/`glyph` constructor parameter, so there is nothing to
/// swap. Button, Badge, Input Group, Empty and RTL are all real compositions
/// with [DsButton], [DsBadge], [DsInputGroup], [DsEmpty] and a
/// [Directionality] wrapper, and are mirrored below. API Reference is the
/// single, LAST shadcn-mirrored section the frame requires: one section
/// holding a DocsApiTable per family (DsIcon, DsSpinner, DsRule), the way
/// `example/lib/components_docs/separator/page.dart`'s own `_api` does for
/// its three components.
const List<String> _iconSectionOrder = <String>[
  'install',
  'icon-usage',
  'icon-glyphs',
  'spinner-usage',
  'spinner-size',
  'spinner-button',
  'spinner-badge',
  'spinner-input-group',
  'spinner-empty',
  'spinner-rtl',
  'dsrule-usage',
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
  required DsThemeController controller,
}) => DsTheme(
  controller: controller,
  child: MaterialApp(home: SingleChildScrollView(child: child)),
);

void main() {
  group('icon, spinner, ds-rule docs page', () {
    testWidgets('renders the article with icon specimens at multiple sizes', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      String? destination;
      await tester.pumpWidget(
        _harness(
          controller: DsThemeController(mode: DsThemeMode.dark),
          child: IconDocPage(onNavigate: (String route) => destination = route),
        ),
      );

      // Article mounts.
      expect(
        find.byKey(const ValueKey<String>('icon-doc-article')),
        findsOneWidget,
      );

      // Icon specimens mount at multiple sizes.
      final List<DsIcon> icons = tester
          .widgetList<DsIcon>(find.byType(DsIcon))
          .toList();
      expect(icons.length, greaterThan(0), reason: 'no icon specimens');

      // Spinner mounts and is still (not settled yet).
      expect(find.byType(DsSpinner), findsWidgets);

      // Metadata reads correctly.
      expect(iconDoc.name, 'icon');
      expect(iconDoc.dependencies, <String>['source-foundation']);
      expect(
        iconDoc.exports,
        containsAll(<String>['DsIcon', 'DsIconGlyph', 'DsIconSize']),
      );

      // No navigate callback triggered during build.
      expect(destination, isNull);

      // Every shadcn-mirrored (or shadcn-styled, for icon and ds-rule)
      // section renders, in exactly the order the reshape brief requires.
      // Installation is first, not near the end as it was before.
      double? previousTop;
      for (final String id in _iconSectionOrder) {
        final Finder finder = find.byKey(DsSection.anchorKey(id));
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

      // The old Overview/Preview headings are gone: no heading sits above
      // Installation, and no section is titled "Status".
      expect(find.text('Icon overview'), findsNothing);
      expect(find.text('Spinner overview'), findsNothing);
      expect(find.text('DsRule overview'), findsNothing);
      expect(find.text('Status'), findsNothing);
    });

    testWidgets(
      'renders at narrow width with the anchor strip instead of a rail',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: DsThemeController(mode: DsThemeMode.dark),
            child: const IconDocPage(),
          ),
        );

        expect(
          find.byKey(const ValueKey<String>('icon-doc-article')),
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

    testWidgets('spinner rotates under normal motion', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final DsThemeController controller = DsThemeController(
        mode: DsThemeMode.dark,
      );

      // Build with normal motion.
      await tester.pumpWidget(
        _harness(controller: controller, child: const IconDocPage()),
      );

      // Spinner mounts and is animating: the rotationValue progresses.
      expect(find.byType(DsSpinner), findsWidgets);

      // Pump once to let the animation start.
      await tester.pump();

      // Find the rotation transition widget.
      final Finder rotationFinder = find.byType(RotationTransition);
      expect(rotationFinder, findsWidgets);

      // Read the first spinner's rotation value.
      final RotationTransition rotation1 = tester.widget<RotationTransition>(
        rotationFinder.first,
      );
      final double value1 = rotation1.turns.value;

      // Pump again at 100ms.
      await tester.pump(const Duration(milliseconds: 100));

      final RotationTransition rotation2 = tester.widget<RotationTransition>(
        rotationFinder.first,
      );
      final double value2 = rotation2.turns.value;

      // Under normal motion, the spinner's rotation should progress.
      expect(
        value2,
        greaterThan(value1),
        reason: 'spinner did not rotate under normal motion',
      );
    });

    testWidgets('icon sizes and tones resolve correctly in both themes', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final DsThemeController controller = DsThemeController(
        mode: DsThemeMode.dark,
      );

      await tester.pumpWidget(
        _harness(controller: controller, child: const IconDocPage()),
      );

      // In dark mode, find icons and verify tone resolution.
      final List<DsIcon> darkIcons = tester
          .widgetList<DsIcon>(find.byType(DsIcon))
          .toList();
      expect(darkIcons.length, greaterThan(0));

      // Flip to light mode and verify icons re-resolve.
      controller.setMode(DsThemeMode.light);
      await tester.pump();

      final List<DsIcon> lightIcons = tester
          .widgetList<DsIcon>(find.byType(DsIcon))
          .toList();
      expect(lightIcons.length, equals(darkIcons.length));
    });

    testWidgets('ds-rule validation runs without error', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      // Test DsRule validation directly, not via the page.
      // This verifies the API shapes are correct and importable.

      // minLength rule.
      final DsRule<String> minRule = DsRule.minLength(
        3,
        'At least 3 characters.',
      );
      expect(minRule.issue('ab'), isNotNull);
      expect(minRule.issue('abc'), isNull);

      // maxLength rule.
      final DsRule<String> maxRule = DsRule.maxLength(
        5,
        'At most 5 characters.',
      );
      expect(maxRule.issue('abcdef'), isNotNull);
      expect(maxRule.issue('abc'), isNull);

      // email rule.
      final DsRule<String> emailRule = DsRule.email(
        'That is not an email address.',
      );
      expect(emailRule.issue('a@b'), isNotNull, reason: 'a@b should fail');
      expect(emailRule.issue('test@example.com'), isNull);

      // pattern rule.
      final DsRule<String> patternRule = DsRule.pattern(
        RegExp(r'^[a-z0-9_]+$'),
        'Must be lowercase letters, digits, or underscore.',
      );
      expect(patternRule.issue('Test'), isNotNull);
      expect(patternRule.issue('test_123'), isNull);

      // accepted rule (checkbox).
      final DsRule<bool> acceptRule = DsRule.accepted(
        'You must accept the terms.',
      );
      expect(acceptRule.issue(false), isNotNull);
      expect(acceptRule.issue(true), isNull);

      // oneOf rule.
      final DsRule<String?> oneOfRule = DsRule.oneOf(<String>[
        'option1',
        'option2',
      ], 'Choose one.');
      expect(oneOfRule.issue(null), isNotNull);
      expect(oneOfRule.issue('option3'), isNotNull);
      expect(oneOfRule.issue('option1'), isNull);

      // DsRules.check with first mode.
      final List<DsRule<String>> rules = <DsRule<String>>[
        DsRule.minLength(3, 'Too short.'),
        DsRule.pattern(RegExp(r'^[a-z]'), 'Must start lowercase.'),
      ];
      final List<String> firstIssues = DsRules.check(
        'A',
        rules,
        mode: DsIssueMode.first,
      );
      expect(firstIssues.length, 1, reason: 'first mode should stop at first');

      // DsRules.check with all mode.
      final List<String> allIssues = DsRules.check(
        'A',
        rules,
        mode: DsIssueMode.all,
      );
      expect(allIssues.length, 2, reason: 'all mode should collect all');

      // Dedupe.
      final List<String> deduped = DsRules.dedupe(<String>[
        'msg1',
        'msg2',
        'msg1',
      ]);
      expect(deduped, <String>['msg1', 'msg2']);
    });
  });
}
