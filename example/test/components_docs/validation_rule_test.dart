/// Tests for `components_docs/validation_rule/page.dart`'s [ValidationRuleDocPage].
///
/// Re-housed onto the kit alongside the page: the section-order test now
/// reads `DocsSection.id`/`.title`, and the API-table reads open the
/// `DocsDisclosure` first — closed by default, unlike the old page's
/// always-visible `Section`.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/validation_rule/meta.dart';
import 'package:example/components_docs/validation_rule/page.dart';
import 'package:example/docs/component_doc_page.dart' show DocsTocEntry;
import 'package:example/docs/docs_disclosure.dart';
import 'package:example/docs/docs_section.dart' show DocsSection;
import 'package:flutter/material.dart'
    hide
        AspectRatio,
        Form,
        FormField,
        Icon,
        OverlayPortal,
        RadioGroup,
        RichText,
        SafeArea,
        ScrollPosition,
        Table,
        TableColumnWidth,
        ActionChip,
        AlertDialog,
        Badge,
        Card,
        CarouselController,
        Checkbox,
        Dialog,
        DropdownMenu,
        Drawer,
        DrawerHeader,
        Slider,
        Switch,
        TextFormField,
        Tooltip;
import 'package:flutter_test/flutter_test.dart';

/// This page's own section order: see
/// `example/lib/components_docs/validation_rule/page.dart`'s own library doc.
/// `rule` has no shadcn counterpart, so its own sections (Composing a
/// rule list, Collecting issues, Deduplicating messages) are named for what
/// `ValidationRule` does rather than mirrored from a page that does not exist.
const List<String> _sectionIds = <String>[
  'preview',
  'install',
  'usage',
  'composing',
  'collecting',
  'deduping',
  'api',
  'states',
  'accessibility',
  'keyboard',
  'responsive',
  'dependencies',
  'theming',
  'source',
];

const List<String> _sectionTitles = <String>[
  'Preview',
  'Installation',
  'Usage',
  'Composing a rule list',
  'Collecting issues',
  'Deduplicating messages',
  'API Reference',
  'States',
  'Accessibility',
  'Keyboard',
  'Responsive',
  'Dependencies',
  'Theming',
  'Source',
];

Widget _harness({required Widget child, required ThemeController controller}) =>
    ThemeScope(
      controller: controller,
      child: MaterialApp(
        home: Builder(
          // The ambient ink every route inherits, as the docs shell sets it
          // for the real app. Without it this subtree sits under WidgetsApp's
          // red fallback style, which StyledText asserts on rather than
          // quietly painting over.
          builder: (BuildContext context) => DefaultTextStyle(
            style: StyledText.styleOf(
              context,
              TextStyles.body,
              color: ThemeScope.of(context).foreground,
            ),
            child: SingleChildScrollView(child: child),
          ),
        ),
      ),
    );

/// The single `DocsDisclosure` whose title is [title].
Finder _disclosureTrigger(String title) => find.descendant(
  of: find.byWidgetPredicate(
    (Widget widget) => widget is DocsDisclosure && widget.title == title,
  ),
  matching: find.byKey(DocsDisclosure.triggerKey),
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
          controller: ThemeController(mode: ColorMode.dark),
          child: ValidationRuleDocPage(
            onNavigate: (String route) => destination = route,
          ),
        ),
      );
      await tester.pump();

      expect(
        find.byKey(const ValueKey<String>('rule-doc-article')),
        findsOneWidget,
      );

      // The hero demo's own failing-email message renders.
      expect(find.text('That is not an email address.'), findsWidgets);

      // Composing a rule list: both checks fail for 'AB' and both render,
      // each prefixed with the bullet the section's own StyledText builds.
      expect(find.text('• At least 3 characters.'), findsOneWidget);
      expect(
        find.text('• Lowercase letters, digits, or underscore only.'),
        findsOneWidget,
      );

      // Collecting issues: IssueMode.first shows 1, IssueMode.all
      // shows 3, for the same failing password value.
      expect(find.text('IssueMode.first (1 shown)'), findsOneWidget);
      expect(find.text('IssueMode.all (3 shown)'), findsOneWidget);

      // Deduplicating messages: the repeated 'Required.' collapses to one.
      expect(find.text('Required., Too short.'), findsOneWidget);

      // Metadata reads correctly.
      expect(validationRuleDoc.name, 'validation_rule');
      expect(validationRuleDoc.dependencies, isEmpty);
      expect(
        validationRuleDoc.exports,
        containsAll(<String>['ValidationRule', 'Validators', 'IssueMode']),
      );
      expect(validationRuleDoc.command, 'elattar add validation-rule');

      expect(destination, isNull);

      // Every section renders, in exactly the order the page declares.
      final List<String> sectionIds = tester
          .widgetList<DocsSection>(find.byType(DocsSection))
          .map((DocsSection section) => section.id)
          .toList();
      expect(sectionIds, _sectionIds);

      final List<String> titles = tester
          .widgetList<DocsSection>(find.byType(DocsSection))
          .map((DocsSection section) => section.title)
          .toList();
      expect(titles, _sectionTitles);

      // The API Reference disclosure holds the corrected API fact:
      // emailPattern is `static final`, not `static const` (a RegExp built
      // from a raw-string literal is not a compile-time constant in Dart) —
      // the bug the original split fixed.
      final Finder apiTrigger = _disclosureTrigger('API Reference');
      await tester.ensureVisible(apiTrigger);
      await tester.pump();
      await tester.tap(apiTrigger);
      await tester.pump();
      await tester.pump(MotionDurations.open);

      expect(find.textContaining('static final RegExp'), findsOneWidget);
      expect(find.textContaining('static const RegExp'), findsNothing);
    });

    test('the table of contents matches the declared sections', () {
      expect(
        elRuleDocSpec.toc.map((DocsTocEntry entry) => entry.title).toList(),
        _sectionTitles,
      );
    });

    testWidgets('the page is declared, and every section is a kit component', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 4000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _harness(
          controller: ThemeController(mode: ColorMode.dark),
          child: const ValidationRuleDocPage(),
        ),
      );
      await tester.pump();

      // Eight collapsed sections: API Reference, States, Accessibility,
      // Keyboard, Responsive, Dependencies, Theming, Source.
      expect(find.byType(DocsDisclosure), findsNWidgets(8));
    });

    testWidgets(
      'renders at narrow width with the anchor strip instead of a rail',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ThemeController(mode: ColorMode.dark),
            child: const ValidationRuleDocPage(),
          ),
        );
        await tester.pump();

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
      final ValidationRule<String> minRule = ValidationRule.minLength(
        3,
        'At least 3 characters.',
      );
      expect(minRule.issue('ab'), isNotNull);
      expect(minRule.issue('abc'), isNull);

      final ValidationRule<String> maxRule = ValidationRule.maxLength(
        5,
        'At most 5 characters.',
      );
      expect(maxRule.issue('abcdef'), isNotNull);
      expect(maxRule.issue('abc'), isNull);

      final ValidationRule<String> emailRule = ValidationRule.email(
        'That is not an email address.',
      );
      expect(emailRule.issue('a@b'), isNotNull, reason: 'a@b should fail');
      expect(emailRule.issue('test@example.com'), isNull);

      final ValidationRule<String> patternRule = ValidationRule.pattern(
        RegExp(r'^[a-z0-9_]+$'),
        'Must be lowercase letters, digits, or underscore.',
      );
      expect(patternRule.issue('Test'), isNotNull);
      expect(patternRule.issue('test_123'), isNull);

      final ValidationRule<bool> acceptRule = ValidationRule.accepted(
        'You must accept the terms.',
      );
      expect(acceptRule.issue(false), isNotNull);
      expect(acceptRule.issue(true), isNull);

      final ValidationRule<String?> oneOfRule = ValidationRule.oneOf(<String>[
        'option1',
        'option2',
      ], 'Choose one.');
      expect(oneOfRule.issue(null), isNotNull);
      expect(oneOfRule.issue('option3'), isNotNull);
      expect(oneOfRule.issue('option1'), isNull);

      final List<ValidationRule<String>> rules = <ValidationRule<String>>[
        ValidationRule.minLength(3, 'Too short.'),
        ValidationRule.pattern(RegExp(r'^[a-z]'), 'Must start lowercase.'),
      ];
      final List<String> firstIssues = Validators.check(
        'A',
        rules,
        mode: IssueMode.first,
      );
      expect(firstIssues.length, 1, reason: 'first mode should stop at first');

      final List<String> allIssues = Validators.check(
        'A',
        rules,
        mode: IssueMode.all,
      );
      expect(allIssues.length, 2, reason: 'all mode should collect all');

      final List<String> deduped = Validators.dedupe(<String>[
        'msg1',
        'msg2',
        'msg1',
      ]);
      expect(deduped, <String>['msg1', 'msg2']);

      // The API table's own claim: emailPattern is a real, matchable
      // static final RegExp, not a placeholder.
      expect(ValidationRule.emailPattern.hasMatch('test@example.com'), isTrue);
      expect(ValidationRule.emailPattern.hasMatch('a@b'), isFalse);
    });
  });
}
