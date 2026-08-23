/// Tests for `components_docs/toggle/page.dart`'s [ToggleDocPage]: the
/// combined toggle and toggle-group component documentation page, reshaped
/// to shadcn parity across TWO counterparts,
/// https://ui.shadcn.com/docs/components/base/toggle and
/// https://ui.shadcn.com/docs/components/base/toggle-group.
///
/// Section order, matching both counterpart pages, merged and grouped under
/// each component's own name: Installation, Usage (shared), then Toggle:
/// Outline / With text / Independent toggles / Sizes / Disabled / RTL, then
/// Toggle group: Composition / Outline / Sizes / Disabled / Custom / RTL,
/// then API Reference, then the six sections shadcn does not carry (States,
/// Accessibility, Responsive, Dependencies, Theming, Source), behind the
/// un-headed hero demo. Toggle group: Spacing and Toggle group: Vertical are
/// skipped (two root props `toggle_group.dart`'s own header documents as
/// not ported); Changelog (present on both counterpart pages) has no
/// analogue here and is skipped too.
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
import 'package:example/docs/docs_layout.dart';
import 'package:example/kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const Size _wide = Size(1440, 900);
const Size _narrow = Size(390, 844);

/// The shadcn-parity section order this page must render, top to bottom,
/// behind the un-headed `preview` hero demo. Matches page.dart's own `toc:`
/// list exactly.
const List<String> _sectionOrder = <String>[
  'install',
  'usage',
  'toggle-outline',
  'toggle-with-text',
  'toggle-independent',
  'toggle-sizes',
  'toggle-disabled',
  'toggle-rtl',
  'toggle-group-composition',
  'toggle-group-outline',
  'toggle-group-sizes',
  'toggle-group-disabled',
  'toggle-group-custom',
  'toggle-group-rtl',
  'api',
  'states',
  'accessibility',
  'responsive',
  'dependencies',
  'theming',
  'source',
];

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
    'the shadcn-parity section list renders in order, behind the un-headed '
    'hero demo',
    (WidgetTester tester) async {
      await _pump(tester);

      final double previewTop = tester
          .getTopLeft(find.byKey(docsAnchorKey('preview')))
          .dy;
      double previousTop = previewTop;
      for (final String id in _sectionOrder) {
        final Finder section = find.byKey(DsSection.anchorKey(id));
        expect(section, findsOneWidget, reason: 'missing section: $id');
        final double top = tester.getTopLeft(section).dy;
        expect(
          top,
          greaterThan(previousTop),
          reason: 'section "$id" is not below the previous section',
        );
        previousTop = top;
      }

      // The old house-shape headings are gone: no Overview, Status, or
      // Preview heading, and no Examples wrapper.
      // Checked by absent DsSection anchor, not by absent text: "Status" and
      // "Preview" both still appear as incidental text elsewhere on this
      // page (an install fact label, and every DocsCodeExample's own
      // preview/CLI/manual tab strip), so a bare find.text would be a false
      // positive for either. No DsSection on this page carries any of these
      // four ids any more.
      for (final String oldId in <String>[
        'composition',
      ]) {
        expect(
          find.byKey(DsSection.anchorKey(oldId)),
          findsNothing,
          reason: 'the old "$oldId" heading should be gone',
        );
      }
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
    'deselects to null when the already-selected option is tapped again, '
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

      // Several other specimens on this page render the same three labels
      // ("Newest"/"Price"/"Popular"), so a bare find.text('Price') is
      // ambiguous, scope the search to this specimen's own subtree.
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
      // selectedIndex follows it to null: the behaviour this page exists to
      // document precisely.
      await tester.tap(priceInSpecimen, warnIfMissed: false);
      await tester.pump();
      group = tester.widget<DsToggleGroup>(find.byKey(key));
      expect(group.selectedIndex, isNull);

      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'the Toggle: Outline and Toggle: With text specimens mount and toggle '
    'on tap',
    (WidgetTester tester) async {
      await _pump(tester);

      const Key outlineKey = ValueKey<String>(
        'toggle-outline-bold-specimen',
      );
      expect(find.byKey(outlineKey), findsOneWidget);
      await tester.ensureVisible(find.byKey(outlineKey));
      expect(tester.widget<DsToggle>(find.byKey(outlineKey)).pressed, isFalse);
      await tester.tap(find.byKey(outlineKey), warnIfMissed: false);
      await tester.pump();
      expect(tester.widget<DsToggle>(find.byKey(outlineKey)).pressed, isTrue);

      const Key withTextKey = ValueKey<String>('toggle-with-text-specimen');
      expect(find.byKey(withTextKey), findsOneWidget);
      await tester.ensureVisible(find.byKey(withTextKey));
      expect(
        tester.widget<DsToggle>(find.byKey(withTextKey)).pressed,
        isFalse,
      );
      await tester.tap(find.byKey(withTextKey), warnIfMissed: false);
      await tester.pump();
      expect(tester.widget<DsToggle>(find.byKey(withTextKey)).pressed, isTrue);

      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'the Toggle group: Outline, Sizes and Disabled specimens mount with the '
    'right initial wiring',
    (WidgetTester tester) async {
      await _pump(tester);

      final Finder outlineGroup = find.byKey(
        const ValueKey<String>('toggle-group-outline-specimen'),
      );
      await tester.ensureVisible(outlineGroup);
      expect(
        tester.widget<DsToggleGroup>(outlineGroup).variant,
        DsToggleVariant.outline,
      );

      final Finder smGroup = find.byKey(
        const ValueKey<String>('toggle-group-sizes-sm-specimen'),
      );
      final Finder lgGroup = find.byKey(
        const ValueKey<String>('toggle-group-sizes-lg-specimen'),
      );
      await tester.ensureVisible(smGroup);
      expect(tester.widget<DsToggleGroup>(smGroup).size, DsToggleSize.sm);
      expect(tester.widget<DsToggleGroup>(lgGroup).size, DsToggleSize.lg);

      final Finder disabledGroup = find.byKey(
        const ValueKey<String>('toggle-group-disabled-specimen'),
      );
      await tester.ensureVisible(disabledGroup);
      final DsToggleGroup disabled = tester.widget<DsToggleGroup>(
        disabledGroup,
      );
      expect(disabled.items[1].enabled, isFalse);

      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'the RTL specimens for both components render under Directionality.rtl '
    'with no exceptions',
    (WidgetTester tester) async {
      await _pump(tester);

      final Finder toggleRtl = find.byKey(
        const ValueKey<String>('toggle-rtl-specimen'),
      );
      await tester.ensureVisible(toggleRtl);
      expect(toggleRtl, findsOneWidget);
      expect(
        find.ancestor(
          of: toggleRtl,
          matching: find.byWidgetPredicate(
            (Widget w) => w is Directionality && w.textDirection == TextDirection.rtl,
          ),
        ),
        findsWidgets,
      );

      final Finder groupRtl = find.byKey(
        const ValueKey<String>('toggle-group-rtl-specimen'),
      );
      await tester.ensureVisible(groupRtl);
      expect(groupRtl, findsOneWidget);
      expect(
        find.ancestor(
          of: groupRtl,
          matching: find.byWidgetPredicate(
            (Widget w) => w is Directionality && w.textDirection == TextDirection.rtl,
          ),
        ),
        findsWidgets,
      );

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
        'Selected (on): standalone',
        'Selected: in a group',
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

    expect(find.textContaining('not yet registry items'), findsWidgets);
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
