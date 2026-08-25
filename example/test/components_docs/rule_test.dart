import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/rule/meta.dart';
import 'package:example/components_docs/rule/page.dart';
import 'package:example/kit.dart' show ElSection;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// This page's own section order: see
/// `example/lib/components_docs/rule/page.dart`'s own library doc.
/// `rule` has no shadcn counterpart, so its own sections (Composing a
/// rule list, Collecting issues, Deduplicating messages) are named for what
/// `ElRule` does rather than mirrored from a page that does not exist.
const List<String> _dsRuleSectionOrder = <String>[
  'install',
  'usage',
  'composing',
  'collecting',
  'deduping',
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
  group('rule docs page', () {
    testWidgets('renders the article and every live validation demo', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      String? destination;
      await tester.pumpWidget(
        _harness(
          controller: ElThemeController(mode: ElThemeMode.dark),
          child: ElRuleDocPage(
            onNavigate: (String route) => destination = route,
          ),
        ),
      );

      expect(
        find.byKey(const ValueKey<String>('rule-doc-article')),
        findsOneWidget,
      );

      // The hero demo's own failing-email message renders.
      expect(find.text('That is not an email address.'), findsWidgets);

      // Composing a rule list: both checks fail for 'AB' and both render,
      // each prefixed with the bullet the section's own ElText builds.
      expect(find.text('• At least 3 characters.'), findsOneWidget);
      expect(
        find.text('• Lowercase letters, digits, or underscore only.'),
        findsOneWidget,
      );

      // Collecting issues: ElIssueMode.first shows 1, ElIssueMode.all
      // shows 3, for the same failing password value. The caption now
      // renders through ElType.section, which does not uppercase.
      expect(find.text('ElIssueMode.first (1 shown)'), findsOneWidget);
      expect(find.text('ElIssueMode.all (3 shown)'), findsOneWidget);

      // Deduplicating messages: the repeated 'Required.' collapses to one.
      expect(find.text('Required., Too short.'), findsOneWidget);

      // Metadata reads correctly.
      expect(elRuleDoc.name, 'rule');
      expect(elRuleDoc.dependencies, isEmpty);
      expect(
        elRuleDoc.exports,
        containsAll(<String>['ElRule', 'ElRules', 'ElIssueMode']),
      );
      expect(elRuleDoc.command, 'elattar add rule');

      expect(destination, isNull);

      // Every section renders, in exactly the order the page declares.
      double? previousTop;
      for (final String id in _dsRuleSectionOrder) {
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
        'Composing a rule list',
        'Collecting issues',
        'Deduplicating messages',
        'API Reference',
        'States',
        'Accessibility',
        'Responsive',
        'Dependencies',
        'Theming',
        'Source',
      ]);

      // The corrected API fact: emailPattern is `static final`, not
      // `static const` (a RegExp built from a raw-string literal is not a
      // compile-time constant in Dart) — the bug this split fixed.
      expect(find.textContaining('static final RegExp'), findsOneWidget);
      expect(find.textContaining('static const RegExp'), findsNothing);
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
            child: const ElRuleDocPage(),
          ),
        );

        expect(
          find.byKey(const ValueKey<String>('rule-doc-article')),
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

    testWidgets('rule validation runs without error', (
      WidgetTester tester,
    ) async {
      // Exercises the real API shapes directly, matching the API Reference
      // table's own claims.
      final ElRule<String> minRule = ElRule.minLength(
        3,
        'At least 3 characters.',
      );
      expect(minRule.issue('ab'), isNotNull);
      expect(minRule.issue('abc'), isNull);

      final ElRule<String> maxRule = ElRule.maxLength(
        5,
        'At most 5 characters.',
      );
      expect(maxRule.issue('abcdef'), isNotNull);
      expect(maxRule.issue('abc'), isNull);

      final ElRule<String> emailRule = ElRule.email(
        'That is not an email address.',
      );
      expect(emailRule.issue('a@b'), isNotNull, reason: 'a@b should fail');
      expect(emailRule.issue('test@example.com'), isNull);

      final ElRule<String> patternRule = ElRule.pattern(
        RegExp(r'^[a-z0-9_]+$'),
        'Must be lowercase letters, digits, or underscore.',
      );
      expect(patternRule.issue('Test'), isNotNull);
      expect(patternRule.issue('test_123'), isNull);

      final ElRule<bool> acceptRule = ElRule.accepted(
        'You must accept the terms.',
      );
      expect(acceptRule.issue(false), isNotNull);
      expect(acceptRule.issue(true), isNull);

      final ElRule<String?> oneOfRule = ElRule.oneOf(<String>[
        'option1',
        'option2',
      ], 'Choose one.');
      expect(oneOfRule.issue(null), isNotNull);
      expect(oneOfRule.issue('option3'), isNotNull);
      expect(oneOfRule.issue('option1'), isNull);

      final List<ElRule<String>> rules = <ElRule<String>>[
        ElRule.minLength(3, 'Too short.'),
        ElRule.pattern(RegExp(r'^[a-z]'), 'Must start lowercase.'),
      ];
      final List<String> firstIssues = ElRules.check(
        'A',
        rules,
        mode: ElIssueMode.first,
      );
      expect(firstIssues.length, 1, reason: 'first mode should stop at first');

      final List<String> allIssues = ElRules.check(
        'A',
        rules,
        mode: ElIssueMode.all,
      );
      expect(allIssues.length, 2, reason: 'all mode should collect all');

      final List<String> deduped = ElRules.dedupe(<String>[
        'msg1',
        'msg2',
        'msg1',
      ]);
      expect(deduped, <String>['msg1', 'msg2']);

      // The API table's own claim: emailPattern is a real, matchable
      // static final RegExp, not a placeholder.
      expect(ElRule.emailPattern.hasMatch('test@example.com'), isTrue);
      expect(ElRule.emailPattern.hasMatch('a@b'), isFalse);
    });
  });
}
