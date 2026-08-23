/// Tests for `components_docs/toggle/page.dart`'s [ToggleDocPage] — the
/// combined toggle and toggle-group component documentation page.
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never synthetic `MediaQuery`, per the
/// Phase J brief. The live `DsThemeController` is flipped in place for theme
/// coverage rather than re-pumped under a new controller.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/toggle/meta.dart';
import 'package:example/components_docs/toggle/page.dart';
import 'package:example/docs/docs_code.dart';
import 'package:example/docs/docs_facts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const Size _wide = Size(1440, 900);
const Size _narrow = Size(390, 844);

/// Every public constructor parameter of `DsToggle`, read directly from
/// `lib/src/components/toggle.dart` (Step 1 of the task cycle). The API
/// table must cover all of these by name.
const List<String> _toggleParams = <String>[
  'child',
  'pressed',
  'onChanged',
  'variant',
  'size',
  'label',
  'focusNode',
  'pressedFill',
  'pressedInk',
  'inExclusiveGroup',
];

/// `DsToggle`'s static helpers and its two enums' members.
const List<String> _toggleStatics = <String>[
  'DsToggle.heightFor',
  'DsToggle.minWidthFor',
  'DsToggle.paddingX',
  'DsToggle.gap',
  'DsToggle.radiusFor',
  'DsToggle.iconSizeFor',
  'DsToggleVariant.standard',
  'DsToggleVariant.outline',
  'DsToggleSize.sm',
  'DsToggleSize.md',
  'DsToggleSize.lg',
];

/// Every public constructor parameter of `DsToggleGroup`, read directly from
/// `lib/src/components/toggle_group.dart`.
const List<String> _toggleGroupParams = <String>[
  'items',
  'selectedIndex',
  'onChanged',
  'variant',
  'size',
  'label',
];

/// Every public constructor parameter of `DsToggleGroupItem`, plus
/// `DsToggleGroup`'s one static.
const List<String> _toggleGroupItemParamsAndStatics = <String>[
  'label',
  'child',
  'enabled',
  'DsToggleGroup.gap',
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
            child: ToggleDocPage(onNavigate: onNavigate),
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

      expect(find.text(toggleDoc.title), findsWidgets);
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
    'the API table covers every DsToggle constructor parameter and every '
    'DsToggle/DsToggleVariant/DsToggleSize member',
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

      for (final String param in _toggleParams) {
        expect(
          documented,
          contains(param),
          reason: 'DsToggle constructor parameter "$param" is undocumented',
        );
      }
      for (final String member in _toggleStatics) {
        expect(
          documented,
          contains(member),
          reason: 'DsToggle/enum member "$member" is undocumented',
        );
      }
    },
  );

  testWidgets('the API table covers every DsToggleGroup and DsToggleGroupItem '
      'constructor parameter', (WidgetTester tester) async {
    await _pump(tester);

    final List<DocsApiTable> tables = tester
        .widgetList<DocsApiTable>(find.byType(DocsApiTable))
        .toList();

    final Set<String> documented = <String>{
      for (final DocsApiTable table in tables)
        for (final DocsApiFact fact in table.facts) fact.name,
    };

    for (final String param in _toggleGroupParams) {
      expect(
        documented,
        contains(param),
        reason: 'DsToggleGroup constructor parameter "$param" is undocumented',
      );
    }
    for (final String member in _toggleGroupItemParamsAndStatics) {
      expect(
        documented,
        contains(member),
        reason:
            'DsToggleGroupItem/DsToggleGroup member "$member" is '
            'undocumented',
      );
    }
  });

  testWidgets(
    'a live standalone toggle specimen mounts and flips pressed on tap',
    (WidgetTester tester) async {
      await _pump(tester);

      const Key key = ValueKey<String>('toggle-live-specimen');
      expect(find.byKey(key), findsOneWidget);
      await tester.ensureVisible(find.byKey(key));
      expect(tester.widget<DsToggle>(find.byKey(key)).pressed, isFalse);

      await tester.tap(find.byKey(key), warnIfMissed: false);
      await tester.pump();
      expect(tester.widget<DsToggle>(find.byKey(key)).pressed, isTrue);

      await tester.tap(find.byKey(key), warnIfMissed: false);
      await tester.pump();
      expect(tester.widget<DsToggle>(find.byKey(key)).pressed, isFalse);

      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'a live toggle group specimen mounts, selects a new option on tap, and '
    'deselects to null when the already-selected option is tapped again — '
    'the Radix single-select deselect semantics DsToggleGroup reproduces',
    (WidgetTester tester) async {
      await _pump(tester);

      const Key key = ValueKey<String>('toggle-group-live-specimen');
      expect(find.byKey(key), findsOneWidget);
      await tester.ensureVisible(find.byKey(key));

      DsToggleGroup group = tester.widget<DsToggleGroup>(find.byKey(key));
      expect(group.selectedIndex, 0);
      expect(group.items.map((DsToggleGroupItem i) => i.label), <String>[
        'Newest',
        'Price',
        'Popular',
      ]);

      // The Usage section renders its own live DsToggleGroup with the same
      // three labels, so a bare find.text('Price') is ambiguous — scope the
      // search to this specimen's own subtree.
      final Finder priceInSpecimen = find.descendant(
        of: find.byKey(key),
        matching: find.text('Price'),
      );
      expect(priceInSpecimen, findsOneWidget);

      // Tap a different option: selectedIndex moves to it.
      await tester.tap(priceInSpecimen, warnIfMissed: false);
      await tester.pump();
      group = tester.widget<DsToggleGroup>(find.byKey(key));
      expect(group.selectedIndex, 1);

      // Tap the now-selected option again: onChanged receives null and
      // selectedIndex follows it to null — the behaviour this page exists to
      // document precisely.
      await tester.tap(priceInSpecimen, warnIfMissed: false);
      await tester.pump();
      group = tester.widget<DsToggleGroup>(find.byKey(key));
      expect(group.selectedIndex, isNull);

      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'the state matrix documents the applicable toggle and group states',
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
        'Hover',
        'Selected (on) — standalone',
        'Selected — in a group',
        'Focus-visible',
        'Disabled',
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
    'both themes render the article with no exceptions when flipped in '
    'place',
    (WidgetTester tester) async {
      final DsThemeController theme = await _pump(
        tester,
        mode: DsThemeMode.light,
      );
      expect(find.text(toggleDoc.title), findsWidgets);

      theme.setMode(DsThemeMode.dark);
      await tester.pump();
      expect(find.text(toggleDoc.title), findsWidgets);
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

  testWidgets(
    'the page documents that onChanged can receive null on deselect, not '
    'just the affirmative selection path',
    (WidgetTester tester) async {
      await _pump(tester);

      expect(find.textContaining('null'), findsWidgets);
    },
  );
}
