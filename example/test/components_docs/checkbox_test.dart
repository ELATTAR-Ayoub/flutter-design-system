/// Tests for `components_docs/checkbox/page.dart`'s [CheckboxDocPage]:
/// the checkbox component documentation page.
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never synthetic `MediaQuery`, per the
/// Phase J brief. The live `ElThemeController` is flipped in place for theme
/// coverage rather than re-pumped under a new controller.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/checkbox/meta.dart';
import 'package:example/components_docs/checkbox/page.dart';
import 'package:example/docs/docs_code.dart';
import 'package:example/docs/docs_facts.dart';
import 'package:example/kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const Size _wide = Size(1440, 900);
const Size _narrow = Size(390, 844);

/// The shadcn-mirrored section order this page must render, top to bottom:
/// `https://ui.shadcn.com/docs/components/base/checkbox`'s own Installation
/// through API Reference (the live demo above them carries no heading, the
/// same as shadcn's own page), then the six Elattar-specific sections below
/// them.
const List<String> _expectedSectionIds = <String>[
  'install',
  'usage',
  'checked-state',
  'invalid-state',
  'basic',
  'description',
  'disabled',
  'group',
  'table',
  'rtl',
  'api',
  'states',
  'accessibility',
  'responsive',
  'dependencies',
  'theming',
  'source',
];

/// Every public constructor parameter of `ElCheckbox`, enumerated by reading
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

/// The rest of the public surface: the static helpers on `ElCheckbox` and
/// every member of the tri-state `ElCheckboxState` enum.
const List<String> _checkboxStatics = <String>[
  'ElCheckbox.size',
  'ElCheckbox.nextAfter',
  'ElCheckboxState.unchecked',
  'ElCheckboxState.checked',
  'ElCheckboxState.indeterminate',
];

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
  testWidgets('sections render in the shadcn-mirrored order, top to bottom', (
    WidgetTester tester,
  ) async {
    await _pump(tester);

    double previousDy = double.negativeInfinity;
    for (final String id in _expectedSectionIds) {
      final Finder finder = find.byKey(ElSection.anchorKey(id));
      expect(
        finder,
        findsOneWidget,
        reason: 'no ElSection with id "$id" is in the tree',
      );
      final double dy = tester.getTopLeft(finder).dy;
      expect(
        dy,
        greaterThan(previousDy),
        reason:
            'section "$id" does not come after the previous section in '
            'the expected order',
      );
      previousDy = dy;
    }
  });

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
    'the API table covers every ElCheckbox constructor parameter and every '
    'ElCheckboxState member',
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
          reason: 'ElCheckbox constructor parameter "$param" is undocumented',
        );
      }
      for (final String member in _checkboxStatics) {
        expect(
          documented,
          contains(member),
          reason: 'ElCheckbox/ElCheckboxState member "$member" is undocumented',
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
        tester.widget<ElCheckbox>(find.byKey(key)).state,
        ElCheckboxState.unchecked,
      );

      await tester.tap(find.byKey(key), warnIfMissed: false);
      await tester.pump();
      expect(
        tester.widget<ElCheckbox>(find.byKey(key)).state,
        ElCheckboxState.checked,
      );

      await tester.tap(find.byKey(key), warnIfMissed: false);
      await tester.pump();
      expect(
        tester.widget<ElCheckbox>(find.byKey(key)).state,
        ElCheckboxState.unchecked,
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
      final ElThemeController theme = await _pump(
        tester,
        mode: ElThemeMode.light,
      );
      expect(find.text(checkboxDoc.title), findsWidgets);

      theme.setMode(ElThemeMode.dark);
      await tester.pump();
      expect(find.text(checkboxDoc.title), findsWidgets);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('installation states that the component is installable', (
    WidgetTester tester,
  ) async {
    await _pump(tester);

    // This test used to assert the opposite, correctly: checkbox was not a
    // registry item, and holding the page to saying so was the right guard
    // against overclaiming. The registry now ships it, so the same guard
    // points the other way — the page must not tell a reader that a command
    // which works will not.
    expect(find.textContaining('not yet a registry item'), findsNothing);
    expect(find.textContaining('elattar add checkbox'), findsWidgets);
  });
}
