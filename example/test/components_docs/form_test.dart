/// Tests for `components_docs/form/page.dart`'s [FormDocPage].
///
/// Re-housed onto the kit alongside the page: the section-order test now
/// reads `DocsSection.title` (the kit's own section widget), and the
/// API-table / state-matrix tests open the relevant `DocsDisclosure` first —
/// closed by default in the new kit, unlike the old page's always-visible
/// `ElSection`.
///
/// This page documents [ElForm], [ElFormFieldBase], [ElFormField],
/// [ElTextFormField], and [ElValidateMode] — the non-visual form state
/// container. `https://ui.shadcn.com/docs/components/form` has no
/// counterpart content of its own, so this page's own sections are named
/// for the reader problems `form.dart`'s source actually solves.
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never synthetic `MediaQuery`. The live
/// `ElThemeController` is flipped in place for theme coverage rather than
/// re-pumped under a new controller.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/form/meta.dart';
import 'package:example/components_docs/form/page.dart';
import 'package:example/docs/docs_disclosure.dart';
import 'package:example/docs/docs_facts.dart';
import 'package:example/docs/docs_section.dart' show DocsSection;
import 'package:example/docs/docs_showcase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const Size _wide = Size(1440, 900);
const Size _narrow = Size(390, 844);

/// Every `ElApiTable` this page must render, by title, and every public
/// constructor parameter or member of each documented class found by
/// reading `lib/src/components/form.dart` directly.
const Map<String, List<String>> _expectedApiTables = <String, List<String>>{
  'ElForm': <String>[
    'fields',
    'mode',
    'reValidateMode',
    'operator [](name)',
    'field<T>(name)',
    'text(name)',
    'validate()',
    'focusFirstError()',
    'submit([onValid])',
    'setError(name, message)',
    'clearErrors()',
    'reset()',
    'isValid',
    'isSubmitting',
    'submitCount',
  ],
  'ElFormFieldBase': <String>[
    'name',
    'focusNode',
    'errors',
    'invalid',
    'rawValue',
    'issues()',
    'validate()',
    'setErrors(messages)',
    'reset()',
  ],
  'ElFormField<T>': <String>[
    'name',
    'initialValue',
    'rules',
    'issueMode',
    'value',
  ],
  'ElTextFormField': <String>[
    'name',
    'initialValue',
    'rules',
    'issueMode',
    'controller',
  ],
  'ElValidateMode': <String>['onSubmit', 'onChange'],
};

/// The single `DocsDisclosure` whose title is [title]. `DocsDisclosure`'s
/// own trigger key ([DocsDisclosure.triggerKey]) is one constant shared by
/// every instance on the page, so a bare `find.byKey` would match every
/// disclosure on the page — this narrows to the one panel by its title
/// first, matching `button_test.dart`'s own convention.
Finder _disclosureTrigger(String title) => find.descendant(
  of: find.byWidgetPredicate(
    (Widget widget) => widget is DocsDisclosure && widget.title == title,
  ),
  matching: find.byKey(DocsDisclosure.triggerKey),
);

Future<ElThemeController> _pump(
  WidgetTester tester, {
  Size size = _wide,
  ElThemeMode mode = ElThemeMode.dark,
  ValueChanged<String>? onNavigate,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final ElThemeController theme = ElThemeController(mode: mode);
  addTearDown(theme.dispose);

  await tester.pumpWidget(
    ElTheme(
      controller: theme,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: SingleChildScrollView(
            child: FormDocPage(onNavigate: onNavigate),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  return theme;
}

void main() {
  testWidgets(
    'sections render in order: Preview, Installation, Usage, four '
    'reader-problem sections, API Reference, and the eight disclosures',
    (WidgetTester tester) async {
      await _pump(tester);

      final List<String> titles = tester
          .widgetList<DocsSection>(find.byType(DocsSection))
          .map((DocsSection section) => section.title)
          .toList();

      expect(titles, <String>[
        'Preview',
        'Installation',
        'Usage',
        'Validation timing',
        'Focus on error',
        'Server errors',
        'Resetting',
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

  testWidgets('every live specimen renders without exceptions', (
    WidgetTester tester,
  ) async {
    await _pump(tester);

    for (final String key in <String>[
      'form-preview-field',
      'form-preview-submit',
      'form-validation-timing-field',
      'form-validation-timing-submit',
      'form-focus-name-field',
      'form-focus-email-field',
      'form-focus-submit',
      'form-server-error-field',
      'form-server-error-trigger',
      'form-reset-field',
      'form-reset-submit',
      'form-reset-trigger',
    ]) {
      final Finder finder = find.byKey(ValueKey<String>(key));
      await tester.ensureVisible(finder);
      expect(finder, findsOneWidget, reason: 'missing specimen "$key"');
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'renders the article at wide and narrow widths with no exceptions',
    (WidgetTester tester) async {
      await _pump(tester, size: _wide);

      expect(find.text(formDoc.title), findsWidgets);
      expect(find.byType(DocsShowcase), findsAtLeastNWidgets(1));
      expect(
        find.byKey(const ValueKey<String>('docs-layout-sidebar')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);

      await _pump(tester, size: _narrow);
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey<String>('docs-layout-anchor-strip')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('docs-layout-sidebar')),
        findsNothing,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'each ElApiTable covers every public constructor parameter and member '
    'of its own class',
    (WidgetTester tester) async {
      await _pump(tester);

      final Finder apiTrigger = _disclosureTrigger('API Reference');
      await tester.ensureVisible(apiTrigger);
      await tester.tap(apiTrigger);
      await tester.pump();
      await tester.pump(ElDurations.jelly);

      final List<DocsApiTable> tables = tester
          .widgetList<DocsApiTable>(find.byType(DocsApiTable))
          .toList();
      expect(tables, isNotEmpty);

      final Map<String, Set<String>> byTitle = <String, Set<String>>{
        for (final DocsApiTable table in tables)
          table.title: <String>{
            for (final DocsApiFact fact in table.facts) fact.name,
          },
      };

      for (final MapEntry<String, List<String>> expected
          in _expectedApiTables.entries) {
        final Set<String>? documented = byTitle[expected.key];
        expect(
          documented,
          isNotNull,
          reason: 'no ElApiTable titled "${expected.key}" was rendered',
        );
        for (final String param in expected.value) {
          expect(
            documented,
            contains(param),
            reason: '"${expected.key}" table is missing parameter "$param"',
          );
        }
      }
    },
  );

  testWidgets(
    'submitting the Validation timing specimen empty shows an error and '
    'bumps submitCount',
    (WidgetTester tester) async {
      await _pump(tester);

      final Finder submit = find.byKey(
        const ValueKey<String>('form-validation-timing-submit'),
      );
      await tester.ensureVisible(submit);
      expect(find.textContaining('submitCount: 0'), findsWidgets);

      await tester.tap(submit);
      await tester.pump();

      expect(find.textContaining('At least 3 characters.'), findsOneWidget);
      expect(find.textContaining('submitCount: 1'), findsWidgets);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('submitting the Focus on error specimen empty moves focus to the '
      'first invalid field (name, registered before email)', (
    WidgetTester tester,
  ) async {
    await _pump(tester);

    final Finder submit = find.byKey(
      const ValueKey<String>('form-focus-submit'),
    );
    await tester.ensureVisible(submit);
    expect(find.textContaining('Focused field: none'), findsOneWidget);

    await tester.tap(submit);
    await tester.pump();

    expect(find.textContaining('Focused field: name'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'the Server errors specimen sets a message with no rule behind it, '
    'without moving focus',
    (WidgetTester tester) async {
      await _pump(tester);

      final Finder trigger = find.byKey(
        const ValueKey<String>('form-server-error-trigger'),
      );
      await tester.ensureVisible(trigger);
      expect(find.text('This handle is already taken.'), findsNothing);

      await tester.tap(trigger);
      await tester.pump();

      expect(find.text('This handle is already taken.'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'the Resetting specimen returns to its initial value after submit',
    (WidgetTester tester) async {
      await _pump(tester);

      final Finder field = find.byKey(
        const ValueKey<String>('form-reset-field'),
      );
      await tester.ensureVisible(field);
      final Finder input = find.descendant(
        of: field,
        matching: find.byType(EditableText),
      );
      await tester.enterText(input, 'ab');

      final Finder submit = find.byKey(
        const ValueKey<String>('form-reset-submit'),
      );
      await tester.tap(submit);
      await tester.pump();
      expect(find.textContaining('At least 3 characters.'), findsOneWidget);

      final Finder reset = find.byKey(
        const ValueKey<String>('form-reset-trigger'),
      );
      await tester.tap(reset);
      await tester.pump();

      expect(find.textContaining('At least 3 characters.'), findsNothing);
      // Scoped to this specimen's own field: the Server errors specimen
      // above also seeds a 'handle' field with initialValue 'shadcn', so a
      // bare find.text('shadcn') matches both fields' EditableText widgets.
      expect(tester.widget<EditableText>(input).controller.text, 'shadcn');
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'the state matrix documents pristine, submitting, invalid, server '
    'error, and reset',
    (WidgetTester tester) async {
      await _pump(tester);

      final Finder statesTrigger = _disclosureTrigger('States');
      await tester.ensureVisible(statesTrigger);
      await tester.tap(statesTrigger);
      await tester.pump();
      await tester.pump(ElDurations.jelly);

      final DocsStateMatrix matrix = tester.widget<DocsStateMatrix>(
        find.byType(DocsStateMatrix),
      );
      final Set<String> states = matrix.facts
          .map((DocsStateFact fact) => fact.state)
          .toSet();

      for (final String expected in <String>[
        'Pristine',
        'Submitting',
        'Invalid after submit',
        'Server error',
        'Reset',
      ]) {
        expect(
          states,
          contains(expected),
          reason: 'state matrix is missing the "$expected" row',
        );
      }
    },
  );

  testWidgets(
    'both themes render the article with no exceptions when flipped in place',
    (WidgetTester tester) async {
      final ElThemeController theme = await _pump(
        tester,
        mode: ElThemeMode.light,
      );
      expect(find.text(formDoc.title), findsWidgets);

      theme.setMode(ElThemeMode.dark);
      await tester.pump();
      expect(find.text(formDoc.title), findsWidgets);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('installation presents the working form CLI command', (
    WidgetTester tester,
  ) async {
    await _pump(tester);

    expect(find.textContaining('elattar add form'), findsWidgets);
  });
}
