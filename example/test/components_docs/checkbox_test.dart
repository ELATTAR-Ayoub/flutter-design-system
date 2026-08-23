/// Tests for `components_docs/checkbox/page.dart`'s [CheckboxDocPage] —
/// the checkbox component documentation page.
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never synthetic `MediaQuery`, per the
/// Phase J brief. The live `DsThemeController` is flipped in place for theme
/// coverage rather than re-pumped under a new controller.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/checkbox/meta.dart';
import 'package:example/components_docs/checkbox/page.dart';
import 'package:example/docs/docs_code.dart';
import 'package:example/docs/docs_facts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const Size _wide = Size(1440, 900);
const Size _narrow = Size(390, 844);

/// Every public constructor parameter of `DsCheckbox`, enumerated by reading
/// `lib/src/components/checkbox.dart` directly (Step 1 of the task cycle).
/// The API table must cover all of these by name.
const List<String> _checkboxParams = <String>[
  'state',
  'onChanged',
  'enabled',
  'inert',
  'invalid',
  'forceFocusRing',
  'focusNode',
  'label',
  'hint',
];

/// The rest of the public surface: the static helpers on `DsCheckbox` and
/// every member of the tri-state `DsCheckboxState` enum.
const List<String> _checkboxStatics = <String>[
  'DsCheckbox.size',
  'DsCheckbox.nextAfter',
  'DsCheckboxState.unchecked',
  'DsCheckboxState.checked',
  'DsCheckboxState.indeterminate',
];

Future<DsThemeController> _pump(
  WidgetTester tester, {
  Size size = _wide,
  DsThemeMode mode = DsThemeMode.dark,
  ValueChanged<String>? onNavigate,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final DsThemeController theme = DsThemeController(mode: mode);
  addTearDown(theme.dispose);

  await tester.pumpWidget(
    DsTheme(
      controller: theme,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: SingleChildScrollView(
            child: CheckboxDocPage(onNavigate: onNavigate),
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

      expect(find.text(checkboxDoc.title), findsWidgets);
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
    'the API table covers every DsCheckbox constructor parameter and every '
    'DsCheckboxState member',
    (WidgetTester tester) async {
      await _pump(tester);

      final List<DocsApiTable> tables = tester
          .widgetList<DocsApiTable>(find.byType(DocsApiTable))
          .toList();
      expect(tables, isNotEmpty);

      final Set<String> documented = <String>{
        for (final DocsApiTable table in tables)
          for (final DocsApiFact fact in table.facts) fact.name,
      };

      for (final String param in _checkboxParams) {
        expect(
          documented,
          contains(param),
          reason: 'DsCheckbox constructor parameter "$param" is undocumented',
        );
      }
      for (final String member in _checkboxStatics) {
        expect(
          documented,
          contains(member),
          reason: 'DsCheckbox/DsCheckboxState member "$member" is undocumented',
        );
      }
    },
  );

  testWidgets(
    'a live checkbox specimen mounts and toggles from unchecked to checked '
    'and back on tap',
    (WidgetTester tester) async {
      await _pump(tester);

      const Key key = ValueKey<String>('checkbox-live-specimen');
      expect(find.byKey(key), findsOneWidget);
      await tester.ensureVisible(find.byKey(key));
      expect(
        tester.widget<DsCheckbox>(find.byKey(key)).state,
        DsCheckboxState.unchecked,
      );

      await tester.tap(find.byKey(key), warnIfMissed: false);
      await tester.pump();
      expect(
        tester.widget<DsCheckbox>(find.byKey(key)).state,
        DsCheckboxState.checked,
      );

      await tester.tap(find.byKey(key), warnIfMissed: false);
      await tester.pump();
      expect(
        tester.widget<DsCheckbox>(find.byKey(key)).state,
        DsCheckboxState.unchecked,
      );

      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('the state matrix documents the checked, indeterminate, inert, '
      'focus-visible, error and disabled states', (WidgetTester tester) async {
    await _pump(tester);

    final DocsStateMatrix matrix = tester.widget<DocsStateMatrix>(
      find.byType(DocsStateMatrix),
    );
    final Set<String> states = matrix.facts
        .map((DocsStateFact fact) => fact.state)
        .toSet();

    for (final String expected in <String>[
      'Selected (checked)',
      'Indeterminate',
      'Inert',
      'Focus-visible',
      'Error',
      'Disabled',
      'Reduced motion',
    ]) {
      expect(
        states,
        contains(expected),
        reason: 'state matrix is missing the "$expected" row',
      );
    }
  });

  testWidgets(
    'both themes render the article with no exceptions when flipped in place',
    (WidgetTester tester) async {
      final DsThemeController theme = await _pump(
        tester,
        mode: DsThemeMode.light,
      );
      expect(find.text(checkboxDoc.title), findsWidgets);

      theme.setMode(DsThemeMode.dark);
      await tester.pump();
      expect(find.text(checkboxDoc.title), findsWidgets);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('installation is honestly disclosed as not yet CLI-installable', (
    WidgetTester tester,
  ) async {
    await _pump(tester);

    // The honest disclosure is intentionally repeated (Status and
    // Installation each state it in their own words), so this asserts
    // presence, not a specific count.
    expect(find.textContaining('not yet a registry item'), findsWidgets);
  });
}
