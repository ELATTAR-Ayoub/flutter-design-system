/// Tests for `components_docs/radio/page.dart`'s [RadioDocPage] — the radio
/// group component documentation page.
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never synthetic `MediaQuery`, per the
/// Phase J brief. The live `DsThemeController` is flipped in place for theme
/// coverage rather than re-pumped under a new controller.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/radio/meta.dart';
import 'package:example/components_docs/radio/page.dart';
import 'package:example/docs/docs_code.dart';
import 'package:example/docs/docs_facts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const Size _wide = Size(1440, 900);
const Size _narrow = Size(390, 844);

/// Every public constructor parameter of `DsRadioGroup<T>`, enumerated by
/// reading `lib/src/components/radio.dart` directly (Step 1 of the task
/// cycle). The API table must cover all of these by name.
const List<String> _radioGroupParams = <String>[
  'value',
  'onChanged',
  'children',
  'gap',
  'enabled',
  'invalid',
  'focusNode',
  'label',
  'hint',
];

/// Every public constructor parameter of `DsRadioGroupItem<T>`.
const List<String> _radioGroupItemParams = <String>[
  'value',
  'enabled',
  'invalid',
  'forceFocusRing',
  'label',
  'hint',
];

/// The rest of the public surface: the static helpers on `DsRadioGroup` and
/// `DsRadioGroupItem`. Neither type exposes an enum the way `DsCheckboxState`
/// does — a radio item's checked-ness is derived by comparing the group's
/// `value` against the item's own, not read off a state field.
const List<String> _radioStatics = <String>[
  'DsRadioGroup.defaultGap',
  'DsRadioGroupItem.size',
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
            child: RadioDocPage(onNavigate: onNavigate),
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

      expect(find.text(radioDoc.title), findsWidgets);
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

  testWidgets('the API table covers every DsRadioGroup and DsRadioGroupItem '
      'constructor parameter and every static helper', (
    WidgetTester tester,
  ) async {
    await _pump(tester);

    final List<DocsApiTable> tables = tester
        .widgetList<DocsApiTable>(find.byType(DocsApiTable))
        .toList();
    expect(tables, isNotEmpty);

    final Set<String> documented = <String>{
      for (final DocsApiTable table in tables)
        for (final DocsApiFact fact in table.facts) fact.name,
    };

    for (final String param in _radioGroupParams) {
      expect(
        documented,
        contains(param),
        reason: 'DsRadioGroup constructor parameter "$param" is undocumented',
      );
    }
    for (final String param in _radioGroupItemParams) {
      expect(
        documented,
        contains(param),
        reason:
            'DsRadioGroupItem constructor parameter "$param" is undocumented',
      );
    }
    for (final String member in _radioStatics) {
      expect(documented, contains(member), reason: '$member is undocumented');
    }
  });

  testWidgets(
    'a live radio group mounts and selecting one option deselects the '
    'previous one',
    (WidgetTester tester) async {
      await _pump(tester);

      const Key key = ValueKey<String>('radio-live-specimen');
      final Finder group = find.byKey(key);
      expect(group, findsOneWidget);
      await tester.ensureVisible(group);

      expect(tester.widget<DsRadioGroup<String>>(group).value, 'daily');

      final Finder items = find.descendant(
        of: group,
        matching: find.byType(DsRadioGroupItem<String>),
      );
      expect(items, findsNWidgets(3));

      // Selecting "weekly" (index 1) moves the group's value off "daily" —
      // DsRadioGroup.value is a single nullable T, so this alone proves the
      // control cannot hold two selections: setting it to a new value is what
      // "deselects the previous one" means for a component with exactly one
      // value field.
      await tester.tap(items.at(1), warnIfMissed: false);
      await tester.pump();
      expect(tester.widget<DsRadioGroup<String>>(group).value, 'weekly');

      // …and selecting a third option moves it again, off "weekly" this time
      // — proof that at most one item is ever "the" value, since the group
      // holds exactly one T? and nothing else.
      await tester.tap(items.at(2), warnIfMissed: false);
      await tester.pump();
      expect(tester.widget<DsRadioGroup<String>>(group).value, 'monthly');

      // …and back to the first option, off "monthly".
      await tester.tap(items.at(0), warnIfMissed: false);
      await tester.pump();
      expect(tester.widget<DsRadioGroup<String>>(group).value, 'daily');

      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('the state matrix documents the selected, focus-visible, error, '
      'disabled and reduced-motion states', (WidgetTester tester) async {
    await _pump(tester);

    final DocsStateMatrix matrix = tester.widget<DocsStateMatrix>(
      find.byType(DocsStateMatrix),
    );
    final Set<String> states = matrix.facts
        .map((DocsStateFact fact) => fact.state)
        .toSet();

    for (final String expected in <String>[
      'Selected',
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
    'both themes render the article with no exceptions when flipped in '
    'place',
    (WidgetTester tester) async {
      final DsThemeController theme = await _pump(
        tester,
        mode: DsThemeMode.light,
      );
      expect(find.text(radioDoc.title), findsWidgets);

      theme.setMode(DsThemeMode.dark);
      await tester.pump();
      expect(find.text(radioDoc.title), findsWidgets);
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
