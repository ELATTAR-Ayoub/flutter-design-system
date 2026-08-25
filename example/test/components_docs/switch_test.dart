/// Tests for `components_docs/switch/page.dart`'s [SwitchDocPage]: the
/// switch component documentation page.
///
/// Re-housed onto the kit alongside the page: the section-order test now
/// reads `DocsSection.id` (the kit's own section widget) instead of
/// `ElSection.anchorKey`, and the API-table / state-matrix tests open the
/// relevant `DocsDisclosure` first — closed by default in the new kit.
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never synthetic `MediaQuery`. The live
/// `ElThemeController` is flipped in place for theme coverage. No
/// `pumpAndSettle` against the doc page itself: `switch.dart` composes
/// `ElSelectionControl`, whose colour tweens are finite, but a bare `pump()`
/// (plus an explicit duration where a tween needs to land) is enough and
/// keeps this suite immune to any future control on the page that loops.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/switch/meta.dart';
import 'package:example/components_docs/switch/page.dart';
import 'package:example/docs/docs_disclosure.dart';
import 'package:example/docs/docs_facts.dart';
import 'package:example/docs/docs_section.dart' show DocsSection;
import 'package:example/docs/docs_showcase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const Size _wide = Size(1440, 900);
const Size _narrow = Size(390, 844);

/// The house-shape section order this page must render, top to bottom:
/// Preview, Installation, Usage, one section per shadcn example, then the
/// eight disclosures.
const List<String> _expectedSectionIds = <String>[
  'preview',
  'install',
  'usage',
  'description',
  'choice-card',
  'disabled',
  'invalid',
  'size',
  'api',
  'states',
  'accessibility',
  'keyboard',
  'responsive',
  'dependencies',
  'theming',
  'source',
];

/// Every public constructor parameter of `ElSwitch`, enumerated by reading
/// `lib/src/components/switch.dart` directly. The API table must cover all
/// of these by name.
const List<String> _switchParams = <String>[
  'value',
  'onChanged',
  'size',
  'enabled',
  'invalid',
  'focusNode',
  'label',
  'hint',
];

/// The `ElApiTable` this page must render titled "ElSwitchSize", and every
/// enum rung it must document.
const List<String> _switchSizeMembers = <String>[
  'ElSwitchSize.sm',
  'ElSwitchSize.md',
];

/// The single `DocsDisclosure` whose title is [title], matching
/// `checkbox_test.dart`'s own convention: `DocsDisclosure.triggerKey` is one
/// constant shared by every instance on the page, so a bare `find.byKey`
/// would match every disclosure.
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
            child: SwitchDocPage(onNavigate: onNavigate),
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

      expect(find.text(switchDoc.title), findsWidgets);
      expect(find.byType(DocsShowcase), findsAtLeastNWidgets(1));
      expect(
        find.byKey(const ValueKey<String>('docs-layout-sidebar')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);

      await _pump(tester, size: _narrow);
      await tester.pump();

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
    'the API tables cover every ElSwitch constructor parameter and both '
    'ElSwitchSize rungs',
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

      final Set<String> documented = <String>{
        for (final DocsApiTable table in tables)
          for (final DocsApiFact fact in table.facts) fact.name,
      };

      for (final String param in _switchParams) {
        expect(
          documented,
          contains(param),
          reason: 'ElSwitch constructor parameter "$param" is undocumented',
        );
      }
      for (final String member in _switchSizeMembers) {
        expect(
          documented,
          contains(member),
          reason: 'ElSwitchSize member "$member" is undocumented',
        );
      }

      expect(
        tables.any((DocsApiTable t) => t.title == 'ElSwitchSize'),
        isTrue,
        reason: 'no ElApiTable titled "ElSwitchSize" was rendered',
      );
    },
  );

  testWidgets(
    'the live preview specimen mounts and actually toggles on tap',
    (WidgetTester tester) async {
      await _pump(tester);

      final Finder specimen = find.byKey(
        const ValueKey<String>('switch-doc-live-specimen'),
      );
      expect(specimen, findsOneWidget);
      await tester.ensureVisible(specimen);
      final bool before = tester.widget<ElSwitch>(specimen).value;

      await tester.tap(specimen);
      await tester.pump();
      await tester.pump(ElDurations.transitionDefault);

      final bool after = tester.widget<ElSwitch>(specimen).value;
      expect(after, !before);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('the state matrix documents on, focus, invalid, disabled and '
      'reduced motion', (WidgetTester tester) async {
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
      'On (selected)',
      'Focus-visible',
      'Invalid',
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
      expect(find.text(switchDoc.title), findsWidgets);

      theme.setMode(ElThemeMode.dark);
      await tester.pump();
      expect(find.text(switchDoc.title), findsWidgets);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'previous/next pager navigates through DocsLayout.onNavigate',
    (WidgetTester tester) async {
      String? destination;
      await _pump(tester, onNavigate: (String route) => destination = route);

      final Finder selectLink = find.text('Select').first;
      await tester.ensureVisible(selectLink);
      await tester.tap(selectLink);
      expect(destination, '/components/select');
    },
  );

  testWidgets('installation states that the component is installable', (
    WidgetTester tester,
  ) async {
    await _pump(tester);

    expect(find.textContaining('not yet a registry item'), findsNothing);
    expect(find.textContaining('elattar add switch'), findsWidgets);
  });
}
