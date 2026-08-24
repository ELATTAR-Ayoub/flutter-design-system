/// Tests for `components_docs/field/page.dart`'s [FieldDocPage]: the field
/// component documentation page.
///
/// `field` is a family of nine classes plus one enum
/// (`lib/src/components/field.dart`, read directly for Step 1 of the task
/// cycle): [ElField], [ElFieldScope], [ElFieldActivator],
/// [ElFieldOrientation], [ElFieldGroup], [ElFieldSet], [ElFieldLegend],
/// [ElFieldLabel], [ElFieldDescription], [ElFieldError]. The API-completeness
/// test below checks each class's own [DocsApiTable] by title rather than one
/// flat merged set, because several classes share parameter names (`label`,
/// `enabled`, `focusNode`, `child`/`children`) and a flat set would not catch
/// a class whose own table is missing one.
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never synthetic `MediaQuery`, per the
/// Phase J brief. The live `ElThemeController` is flipped in place for theme
/// coverage rather than re-pumped under a new controller.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/field/meta.dart';
import 'package:example/components_docs/field/page.dart';
import 'package:example/docs/docs_code.dart';
import 'package:example/docs/docs_facts.dart';
import 'package:example/kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

/// The shadcn parity section order (worker brief, 2026-08-23): every
/// `ElSection.id` this page renders, top to bottom. `overview` and
/// `variants` are gone (shadcn's own field page has neither heading; the
/// enum table now lives inside `api`), and the shadcn per-control headings
/// (`input`, `textarea`, `select`, `slider`, `fieldset`, `checkbox`,
/// `switch`, `field-group`, `validation-errors`) are new, promoted out of
/// the old single `composition` section rather than left nested under it.
const List<String> _expectedSectionOrder = <String>[
  'install',
  'usage',
  'composition',
  'anatomy',
  'form',
  'input',
  'textarea',
  'select',
  'slider',
  'fieldset',
  'checkbox',
  'switch',
  'field-group',
  'validation-errors',
  'api',
  'states',
  'accessibility',
  'responsive',
  'dependencies',
  'theming',
  'source',
];

const Size _wide = Size(1440, 900);
const Size _narrow = Size(390, 844);

/// Every `ElApiTable` this page must render, by title, and every public
/// constructor parameter or static member of that class found by reading
/// `lib/src/components/field.dart` directly (Step 1). The completeness test
/// asserts each list is a subset of that specific table's own facts: not of
/// a set merged across every table on the page.
const Map<String, List<String>> _expectedApiTables = <String, List<String>>{
  'ElField': <String>[
    'child',
    'label',
    'description',
    'errors',
    'invalid',
    'enabled',
    'focusNode',
    'orientation',
    'ElField.gap',
    'ElField.describedGap',
  ],
  'ElFieldScope': <String>[
    'label',
    'describedBy',
    'invalid',
    'enabled',
    'focusNode',
    'activator',
    'child',
    'ElFieldScope.maybeOf',
  ],
  'ElFieldActivator': <String>['callback'],
  'ElFieldGroup': <String>[
    'children',
    'nested',
    'ElFieldGroup.gap',
    'ElFieldGroup.nestedGap',
  ],
  'ElFieldSet': <String>[
    'children',
    'tightForGroup',
    'ElFieldSet.gap',
    'ElFieldSet.groupGap',
  ],
  'ElFieldLegend': <String>['text', 'ElFieldLegend.spaceBelow'],
  'ElFieldLabel': <String>[
    'text',
    'spec',
    'focusNode',
    'activator',
    'enabled',
    'onTap',
    'ElFieldLabel.normal',
    'ElFieldLabel.disabledOpacity',
  ],
  'ElFieldDescription': <String>['text'],
  'ElFieldError': <String>[
    'messages',
    'ElFieldError.listIndent',
    'ElFieldError.itemGap',
  ],
  'ElFieldOrientation': <String>['vertical', 'horizontal'],
};

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
            child: FieldDocPage(onNavigate: onNavigate),
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
    'renders the article at wide and narrow widths with no exceptions',
    (WidgetTester tester) async {
      await _pump(tester, size: _wide);

      expect(find.text(fieldDoc.title), findsWidgets);
      expect(find.byType(DocsCodeExample), findsAtLeastNWidgets(1));
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
    'renders the shadcn field page section order, section for section',
    (WidgetTester tester) async {
      await _pump(tester);

      final List<String> ids = tester
          .widgetList<ElSection>(find.byType(ElSection))
          .map((ElSection section) => section.id)
          .toList();

      expect(ids, _expectedSectionOrder);
    },
  );

  testWidgets(
    'each ElApiTable covers every public constructor parameter and static '
    'of its own class',
    (WidgetTester tester) async {
      await _pump(tester);

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
    'the live vertical field specimen toggles from rest to an announced '
    'error and back',
    (WidgetTester tester) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await _pump(tester);

      const Key inputKey = ValueKey<String>('field-doc-specimen-email');
      const Key toggleKey = ValueKey<String>('field-doc-toggle-error');
      // Scoped to this one toggleable specimen: the page's static
      // "Separable" pairing further down deliberately keeps a second,
      // permanent ElFieldError mounted elsewhere on the same page, so a
      // page-wide byType(ElFieldError) search cannot tell "this specimen's
      // error" from "that unrelated, always-on specimen's error".
      final Finder toggleField = find.byKey(
        const ValueKey<String>('field-doc-toggle-field'),
      );
      final Finder toggleFieldError = find.descendant(
        of: toggleField,
        matching: find.byType(ElFieldError),
      );
      await tester.ensureVisible(find.byKey(inputKey));

      // Rest: no error message, and ElFieldError builds no widget at all —
      // not a zero-height live region, per ElFieldError.build's own
      // "returns null when valid" contract.
      expect(toggleFieldError, findsNothing);

      await tester.ensureVisible(find.byKey(toggleKey));
      await tester.tap(find.byKey(toggleKey));
      await tester.pump();

      // Error: the message is on screen and its container is a live region —
      // the whole contract of role="alert".
      expect(toggleFieldError, findsOneWidget);
      final SemanticsNode node = tester.getSemantics(toggleFieldError);
      expect(node.flagsCollection.isLiveRegion, isTrue);

      await tester.tap(find.byKey(toggleKey));
      await tester.pump();
      expect(toggleFieldError, findsNothing);

      expect(tester.takeException(), isNull);
      handle.dispose();
    },
  );

  testWidgets(
    'the live horizontal field specimen toggles its wrapped checkbox on tap, '
    'and the visible ElFieldLabel activates it too: ElFieldLabel\'s own '
    'activator ladder, not just the checkbox\'s own hit area',
    (WidgetTester tester) async {
      await _pump(tester);

      const Key key = ValueKey<String>('field-doc-specimen-checkbox');
      await tester.ensureVisible(find.byKey(key));
      expect(
        tester.widget<ElCheckbox>(find.byKey(key)).state,
        ElCheckboxState.unchecked,
      );

      await tester.tap(find.byKey(key), warnIfMissed: false);
      await tester.pump();
      expect(
        tester.widget<ElCheckbox>(find.byKey(key)).state,
        ElCheckboxState.checked,
      );

      // The field's own visible label, a plain ElText, not the checkbox's
      // hit area, activates the control through ElFieldScope.activator,
      // exactly as an HTML <label for> click would.
      await tester.tap(
        find.text('Email me about product updates'),
        warnIfMissed: false,
      );
      await tester.pump();
      expect(
        tester.widget<ElCheckbox>(find.byKey(key)).state,
        ElCheckboxState.unchecked,
      );

      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'the state matrix documents rest, error, disabled and empty with N/A '
    'reasons for the states that belong to the wrapped control instead',
    (WidgetTester tester) async {
      await _pump(tester);

      final DocsStateMatrix matrix = tester.widget<DocsStateMatrix>(
        find.byType(DocsStateMatrix),
      );
      final Set<String> states = matrix.facts
          .map((DocsStateFact fact) => fact.state)
          .toSet();

      for (final String expected in <String>[
        'Rest',
        'Error',
        'Disabled',
        'Empty (no errors)',
        'Reduced motion',
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
      expect(find.text(fieldDoc.title), findsWidgets);

      theme.setMode(ElThemeMode.dark);
      await tester.pump();
      expect(find.text(fieldDoc.title), findsWidgets);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'installation shows the real elattar add field command, not a "not yet '
    'available" disclosure',
    (WidgetTester tester) async {
      await _pump(tester);

      expect(find.textContaining('elattar add field'), findsWidgets);
    },
  );
}
