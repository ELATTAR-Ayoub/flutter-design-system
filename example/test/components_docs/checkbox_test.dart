/// Tests for `components_docs/checkbox/page.dart`'s [CheckboxDocPage]:
/// the checkbox component documentation page.
///
/// Re-housed onto the kit alongside the page: the section-order test now
/// reads `DocsSection.id` (the kit's own section widget) instead of the old
/// `Section.anchorKey`, and the API-table / state-matrix tests open the
/// relevant `DocsDisclosure` first — closed by default in the new kit,
/// unlike the old page's always-visible `Section`.
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never synthetic `MediaQuery`, per the
/// Phase J brief. The live `ThemeController` is flipped in place for theme
/// coverage rather than re-pumped under a new controller.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/checkbox/meta.dart';
import 'package:example/components_docs/checkbox/page.dart';
import 'package:example/docs/docs_disclosure.dart';
import 'package:example/docs/docs_facts.dart';
import 'package:example/docs/docs_section.dart' show DocsSection;
import 'package:example/docs/docs_showcase.dart';
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

const Size _wide = Size(1440, 900);
const Size _narrow = Size(390, 844);

/// The house-shape section order this page must render, top to bottom:
/// Preview, Installation, Usage, one section per state the live grid shows,
/// then the eight disclosures.
const List<String> _expectedSectionIds = <String>[
  'preview',
  'install',
  'usage',
  'checked-state',
  'invalid-state',
  'basic',
  'disabled',
  'group',
  'table',
  'api',
  'states',
  'accessibility',
  'keyboard',
  'responsive',
  'dependencies',
  'theming',
  'source',
];

/// Every public constructor parameter of `Checkbox`, enumerated by reading
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

/// The rest of the public surface: the static helpers on `Checkbox` and
/// every member of the tri-state `CheckboxState` enum.
const List<String> _checkboxStatics = <String>[
  'Checkbox.size',
  'Checkbox.nextAfter',
  'CheckboxState.unchecked',
  'CheckboxState.checked',
  'CheckboxState.indeterminate',
];

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

Future<ThemeController> _pump(
  WidgetTester tester, {
  Size size = _wide,
  ColorMode mode = ColorMode.dark,
  ValueChanged<String>? onNavigate,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final ThemeController theme = ThemeController(mode: mode);
  addTearDown(theme.dispose);

  await tester.pumpWidget(
    ThemeScope(
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
  testWidgets('sections render in the house-shape order, top to bottom', (
    WidgetTester tester,
  ) async {
    await _pump(tester);

    final List<String> ids = tester
        .widgetList<DocsSection>(find.byType(DocsSection))
        .map((DocsSection section) => section.id)
        .toList();

    expect(ids, _expectedSectionIds);
  });

  testWidgets(
    'renders the article at wide and narrow widths with no exceptions',
    (WidgetTester tester) async {
      await _pump(tester, size: _wide);

      expect(find.text(checkboxDoc.title), findsWidgets);
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
    'the API table covers every Checkbox constructor parameter and every '
    'CheckboxState member',
    (WidgetTester tester) async {
      await _pump(tester);

      final Finder apiTrigger = _disclosureTrigger('API Reference');
      await tester.ensureVisible(apiTrigger);
      await tester.tap(apiTrigger);
      await tester.pump();
      await tester.pump(MotionDurations.open);

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
          reason: 'Checkbox constructor parameter "$param" is undocumented',
        );
      }
      for (final String member in _checkboxStatics) {
        expect(
          documented,
          contains(member),
          reason: 'Checkbox/CheckboxState member "$member" is undocumented',
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
        tester.widget<Checkbox>(find.byKey(key)).state,
        CheckboxState.unchecked,
      );

      await tester.tap(find.byKey(key), warnIfMissed: false);
      await tester.pump();
      expect(
        tester.widget<Checkbox>(find.byKey(key)).state,
        CheckboxState.checked,
      );

      await tester.tap(find.byKey(key), warnIfMissed: false);
      await tester.pump();
      expect(
        tester.widget<Checkbox>(find.byKey(key)).state,
        CheckboxState.unchecked,
      );

      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('the state matrix documents the checked, indeterminate, inert, '
      'focus-visible, error and disabled states', (WidgetTester tester) async {
    await _pump(tester);

    final Finder statesTrigger = _disclosureTrigger('States');
    await tester.ensureVisible(statesTrigger);
    await tester.tap(statesTrigger);
    await tester.pump();
    await tester.pump(MotionDurations.open);

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
      final ThemeController theme = await _pump(tester, mode: ColorMode.light);
      expect(find.text(checkboxDoc.title), findsWidgets);

      theme.setMode(ColorMode.dark);
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
