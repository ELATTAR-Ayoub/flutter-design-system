/// Tests for `components_docs/toggle_group/page.dart`'s
/// [ToggleGroupDocPage].
///
/// **Re-housed onto the documentation kit.** This suite used to read the old
/// page's `Section`s directly; it now reads `DocsSection` (the kit's own
/// section widget) and opens each `DocsDisclosure` before reading what is
/// inside it — closed by default, it mounts no content at all — matching
/// `button_test.dart`'s own pattern, the worked reference for this rollout.
/// `Spacing` and `Vertical` are themselves `DisclosureSection`s now (they
/// carry no live specimen), so their own "what is missing" facts are behind
/// a trigger too.
///
/// Section order, matching
/// https://ui.shadcn.com/docs/components/base/toggle-group: Preview,
/// Installation, Usage, Composition, Outline, Sizes, Spacing, Vertical,
/// Disabled, Custom, RTL, then the eight fixed disclosures (API Reference,
/// States, Accessibility, Keyboard, Responsive, Dependencies, Theming,
/// Source). `Spacing` and `Vertical` render as what-is-missing disclosures
/// rather than demos: `toggle_group.dart` declares neither a `spacing` nor
/// an `orientation` parameter. `Changelog` is skipped: this package ships
/// from source, not a versioned registry entry.
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never synthetic `MediaQuery`. The live
/// `ThemeController` is flipped in place for theme coverage rather than
/// re-pumped under a new controller.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/toggle_group/meta.dart';
import 'package:example/components_docs/toggle_group/page.dart';
import 'package:example/docs/docs_disclosure.dart';
import 'package:example/docs/docs_facts.dart';
import 'package:example/docs/docs_install.dart' show DocsInstall;
import 'package:example/docs/docs_section.dart' show DocsSection;
import 'package:example/docs/docs_showcase.dart' show DocsShowcase;
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

/// The section titles this page must render, top to bottom, matching
/// `page.dart`'s own `toggleGroupDocSpec.sections` exactly.
const List<String> _sectionTitles = <String>[
  'Preview',
  'Installation',
  'Usage',
  'Composition',
  'Outline',
  'Sizes',
  'Spacing',
  'Vertical',
  'Disabled',
  'Custom',
  'RTL',
  'API Reference',
  'States',
  'Accessibility',
  'Keyboard',
  'Responsive',
  'Dependencies',
  'Theming',
  'Source',
];

/// Every named constructor parameter `ToggleGroup` declares, excluding
/// `key`, read directly from `lib/src/components/ui/toggle_group.dart`
/// (L144-L152).
const List<String> _groupParams = <String>[
  'items',
  'selectedIndex',
  'onChanged',
  'variant',
  'size',
  'label',
];

/// Every named constructor parameter `ToggleGroupItem` declares, excluding
/// `key` (`toggle_group.dart` L81-L85).
const List<String> _itemParams = <String>['label', 'child', 'enabled'];

/// `ToggleGroup`'s one static, named exactly as the API table names it
/// (`toggle_group.dart` L178).
const String _groupStatic = 'ToggleGroup.gap';

/// Every live `ToggleGroup` specimen this page's own source keys. Each one
/// must carry the horizontal-scroll mitigation: see the dedicated test.
const List<String> _specimenKeys = <String>[
  'toggle-group-live-specimen',
  'toggle-group-usage-specimen',
  'toggle-group-outline-specimen',
  'toggle-group-sizes-sm-specimen',
  'toggle-group-sizes-lg-specimen',
  'toggle-group-disabled-specimen',
  'toggle-group-custom-specimen',
  'toggle-group-rtl-specimen',
];

/// The single `DocsDisclosure` whose title is [title]. `DocsDisclosure`'s
/// own trigger key is one constant shared by every instance on the page, so
/// a bare `find.byKey` would match all instances — this narrows to the one
/// panel by its title first.
Finder _disclosureTrigger(String title) => find.descendant(
  of: find.byWidgetPredicate(
    (Widget widget) => widget is DocsDisclosure && widget.title == title,
  ),
  matching: find.byKey(DocsDisclosure.triggerKey),
);

Future<void> _open(WidgetTester tester, String title) async {
  final Finder trigger = _disclosureTrigger(title);
  await tester.ensureVisible(trigger);
  await tester.pump();
  await tester.tap(trigger);
  await tester.pump();
  await tester.pump(MotionDurations.normal);
}

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
            child: ToggleGroupDocPage(onNavigate: onNavigate),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  return theme;
}

/// Every `DocsApiFact.name` on the page, from every table.
Set<String> _documentedNames(WidgetTester tester) => <String>{
  for (final DocsApiTable table in tester.widgetList<DocsApiTable>(
    find.byType(DocsApiTable),
  ))
    for (final DocsApiFact fact in table.facts) fact.name,
};

/// Every `DocsInstallFact` on the page, from every panel.
List<DocsInstallFact> _installFacts(WidgetTester tester) => <DocsInstallFact>[
  for (final DocsInstallFacts panel in tester.widgetList<DocsInstallFacts>(
    find.byType(DocsInstallFacts),
  ))
    ...panel.facts,
];

void main() {
  group('toggle-group docs page', () {
    testWidgets(
      'renders the article at wide and narrow widths with no exceptions',
      (WidgetTester tester) async {
        await _pump(tester, size: _wide);

        expect(
          find.byKey(const ValueKey<String>('toggle-group-doc-article')),
          findsOneWidget,
        );
        expect(find.text(toggleGroupDoc.title), findsWidgets);
        expect(find.byType(DocsShowcase), findsAtLeastNWidgets(1));
        expect(
          find.byKey(const ValueKey<String>('docs-layout-sidebar')),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);

        // 390px is where ActiveIndicator's Row overflowed before the
        // mitigation landed: the whole page must still render clean here.
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

    testWidgets('the section list renders in order, exactly once each', (
      WidgetTester tester,
    ) async {
      await _pump(tester);

      final List<String> titles = tester
          .widgetList<DocsSection>(find.byType(DocsSection))
          .map((DocsSection section) => section.title)
          .toList();
      expect(titles, _sectionTitles);
    });

    testWidgets(
      'every live group specimen keeps its horizontal-scroll mitigation: '
      'ActiveIndicator\'s Row neither wraps nor scrolls on its own',
      (WidgetTester tester) async {
        await _pump(tester);

        for (final String key in _specimenKeys) {
          final Finder specimen = find.byKey(ValueKey<String>(key));
          expect(specimen, findsOneWidget, reason: 'missing specimen $key');

          // Not just any SingleChildScrollView: the harness itself wraps the
          // page in a VERTICAL one, so the axis is the whole assertion.
          expect(
            find.ancestor(
              of: specimen,
              matching: find.byWidgetPredicate(
                (Widget w) =>
                    w is SingleChildScrollView &&
                    w.scrollDirection == Axis.horizontal,
              ),
            ),
            findsAtLeastNWidgets(1),
            reason:
                'specimen "$key" lost its '
                'SingleChildScrollView(scrollDirection: Axis.horizontal) '
                'overflow mitigation',
          );
        }

        // One mitigation per live group, and no live group without one.
        // Not a bare `findsNWidgets` on ToggleGroup: the kit's own
        // Preview/Code (DocsShowcase) and CLI/Manual (DocsInstall) chrome is
        // itself built from ToggleGroup, unkeyed. Scope to the keyed,
        // component-level specimens only.
        final List<ToggleGroup> keyedGroups = tester
            .widgetList<ToggleGroup>(find.byType(ToggleGroup))
            .where((ToggleGroup g) => g.key is ValueKey<String>)
            .toList();
        expect(keyedGroups, hasLength(_specimenKeys.length));

        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('the API tables cover every ToggleGroup and ToggleGroupItem '
        'constructor parameter, plus the one static, one table per class', (
      WidgetTester tester,
    ) async {
      await _pump(tester);
      await _open(tester, 'API Reference');

      final List<DocsApiTable> tables = tester
          .widgetList<DocsApiTable>(find.byType(DocsApiTable))
          .toList();
      expect(tables.map((DocsApiTable t) => t.title), <String>[
        'ToggleGroup',
        'ToggleGroup static helpers',
        'ToggleGroupItem',
      ]);

      // Each table covers its own class, not a merged pile: the group's
      // constructor table carries no static and no item field.
      final DocsApiTable groupTable = tables.first;
      expect(
        groupTable.facts.map((DocsApiFact f) => f.name),
        _groupParams,
        reason:
            'the ToggleGroup table must be exactly its constructor '
            'parameters, in declaration order',
      );
      expect(tables[1].facts.map((DocsApiFact f) => f.name), <String>[
        _groupStatic,
      ]);
      expect(tables[2].facts.map((DocsApiFact f) => f.name), _itemParams);

      final Set<String> documented = _documentedNames(tester);
      for (final String name in <String>[
        ..._groupParams,
        ..._itemParams,
        _groupStatic,
      ]) {
        expect(documented, contains(name), reason: '"$name" is undocumented');
      }

      // toggle.dart's own members stay on the toggle page: this page names
      // the two enums as types, never as its own rows.
      for (final String toggleOnly in <String>[
        'pressed',
        'inExclusiveGroup',
        'pressedFill',
        'pressedInk',
        'Toggle.gap',
      ]) {
        expect(
          documented,
          isNot(contains(toggleOnly)),
          reason:
              '"$toggleOnly" is a Toggle member and belongs on the '
              'toggle page',
        );
      }
    });

    testWidgets(
      'the API tables report the real types the constructors declare',
      (WidgetTester tester) async {
        await _pump(tester);
        await _open(tester, 'API Reference');

        final Map<String, String> types = <String, String>{
          for (final DocsApiTable table in tester.widgetList<DocsApiTable>(
            find.byType(DocsApiTable),
          ))
            for (final DocsApiFact fact in table.facts) fact.name: fact.type,
        };

        expect(types['items'], 'List<ToggleGroupItem>');
        expect(types['selectedIndex'], 'int?');
        expect(types['onChanged'], 'ValueChanged<int?>');
        expect(types['variant'], 'ToggleVariant');
        expect(types['size'], 'ToggleSize');
        expect(types[_groupStatic], 'static double');
        // ToggleGroupItem.child is the last 'child' row on the page, and
        // ToggleGroupItem is the only class here with one.
        expect(types['child'], 'Widget?');
        expect(types['enabled'], 'bool');
      },
    );

    testWidgets(
      'the hero specimen selects a new option on tap and deselects to null '
      'when the already-selected option is tapped again, the single-select '
      'deselect semantics ToggleGroup reproduces',
      (WidgetTester tester) async {
        await _pump(tester);

        const Key key = ValueKey<String>('toggle-group-live-specimen');
        expect(find.byKey(key), findsOneWidget);
        await tester.ensureVisible(find.byKey(key));

        ToggleGroup group = tester.widget<ToggleGroup>(find.byKey(key));
        expect(group.selectedIndex, 0);
        expect(group.items.map((ToggleGroupItem i) => i.label), <String>[
          'Newest',
          'Price',
          'Popular',
        ]);

        // Several specimens on this page render the same three labels, so a
        // bare find.text('Price') is ambiguous: scope it to this subtree.
        final Finder priceInSpecimen = find.descendant(
          of: find.byKey(key),
          matching: find.text('Price'),
        );
        expect(priceInSpecimen, findsOneWidget);

        await tester.tap(priceInSpecimen, warnIfMissed: false);
        await tester.pump();
        group = tester.widget<ToggleGroup>(find.byKey(key));
        expect(group.selectedIndex, 1);

        await tester.tap(priceInSpecimen, warnIfMissed: false);
        await tester.pump();
        group = tester.widget<ToggleGroup>(find.byKey(key));
        expect(group.selectedIndex, isNull);

        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'the Outline, Sizes, Disabled and Custom specimens mount with the '
      'right wiring',
      (WidgetTester tester) async {
        await _pump(tester);

        final Finder outlineGroup = find.byKey(
          const ValueKey<String>('toggle-group-outline-specimen'),
        );
        await tester.ensureVisible(outlineGroup);
        expect(
          tester.widget<ToggleGroup>(outlineGroup).variant,
          ToggleVariant.outline,
        );

        final Finder smGroup = find.byKey(
          const ValueKey<String>('toggle-group-sizes-sm-specimen'),
        );
        final Finder lgGroup = find.byKey(
          const ValueKey<String>('toggle-group-sizes-lg-specimen'),
        );
        await tester.ensureVisible(smGroup);
        expect(tester.widget<ToggleGroup>(smGroup).size, ToggleSize.sm);
        expect(tester.widget<ToggleGroup>(lgGroup).size, ToggleSize.lg);

        final Finder disabledGroup = find.byKey(
          const ValueKey<String>('toggle-group-disabled-specimen'),
        );
        await tester.ensureVisible(disabledGroup);
        final ToggleGroup disabled = tester.widget<ToggleGroup>(disabledGroup);
        expect(disabled.items[1].enabled, isFalse);
        expect(disabled.items[0].enabled, isTrue);

        // Custom: two items supply their own child, the third falls back to
        // a bare Text(label).
        final Finder customGroup = find.byKey(
          const ValueKey<String>('toggle-group-custom-specimen'),
        );
        await tester.ensureVisible(customGroup);
        final ToggleGroup custom = tester.widget<ToggleGroup>(customGroup);
        expect(custom.items[0].child, isNotNull);
        expect(custom.items[1].child, isNotNull);
        expect(custom.items[2].child, isNull);
        expect(custom.items[2].label, 'Table');

        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'the Arabic-label RTL specimen renders under Directionality.rtl, '
      'inside its own horizontal-scroll mitigation',
      (WidgetTester tester) async {
        await _pump(tester);

        final Finder rtl = find.byKey(
          const ValueKey<String>('toggle-group-rtl-specimen'),
        );
        await tester.ensureVisible(rtl);
        expect(rtl, findsOneWidget);
        expect(
          find.ancestor(
            of: rtl,
            matching: find.byWidgetPredicate(
              (Widget w) =>
                  w is Directionality && w.textDirection == TextDirection.rtl,
            ),
          ),
          findsWidgets,
        );
        expect(
          tester
              .widget<ToggleGroup>(rtl)
              .items
              .map((ToggleGroupItem i) => i.label)
              .first,
          'الأحدث',
        );

        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'Spacing and Vertical disclose the two unported root props honestly, '
      'without implying they work',
      (WidgetTester tester) async {
        await _pump(tester);
        await _open(tester, 'Spacing');
        await _open(tester, 'Vertical');

        // DocsDisclosure carries the section's own `description:` in its
        // trigger row, not the DocsSection: read it off the DisclosureSection
        // titles rendered as DocsSection (title + description both flow
        // through DocsSection).
        final Map<String, String?> descriptions = <String, String?>{
          for (final DocsSection section in tester.widgetList<DocsSection>(
            find.byType(DocsSection),
          ))
            section.title: section.description,
        };
        expect(descriptions['Spacing'], contains('no spacing parameter'));
        expect(descriptions['Vertical'], contains('no orientation parameter'));

        // And the props really are absent from the API tables, which is what
        // makes the disclosure true rather than decorative.
        await _open(tester, 'API Reference');
        final Set<String> documented = _documentedNames(tester);
        expect(documented, isNot(contains('spacing')));
        expect(documented, isNot(contains('orientation')));

        // Each disclosure names the consequence, not just the gap.
        final List<String> values = _installFacts(
          tester,
        ).map((DocsInstallFact fact) => fact.value).toList();
        expect(values, contains('Connected segments are not expressible'));
        expect(values, contains('A vertical group is not expressible'));
      },
    );

    testWidgets(
      'the state matrix documents the applicable group states, including the '
      'nothing-selected one',
      (WidgetTester tester) async {
        await _pump(tester);
        await _open(tester, 'States');

        final DocsStateMatrix matrix = tester.widget<DocsStateMatrix>(
          find.byType(DocsStateMatrix),
        );
        final Set<String> states = matrix.facts
            .map((DocsStateFact fact) => fact.state)
            .toSet();

        for (final String expected in <String>[
          'Rest (unselected item)',
          'Hover',
          'Selected',
          'Nothing selected',
          'Focus-visible',
          'Disabled (per item)',
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
      'place, losing no specimen',
      (WidgetTester tester) async {
        final ThemeController theme = await _pump(
          tester,
          mode: ColorMode.light,
        );
        expect(find.text(toggleGroupDoc.title), findsWidgets);

        final ThemeTokens light = ThemeScope.of(
          tester.element(
            find.byKey(const ValueKey<String>('toggle-group-doc-article')),
          ),
        );

        theme.setMode(ColorMode.dark);
        await tester.pump();

        final ThemeTokens dark = ThemeScope.of(
          tester.element(
            find.byKey(const ValueKey<String>('toggle-group-doc-article')),
          ),
        );
        expect(light.background, isNot(dark.background));
        expect(light.foreground, isNot(dark.foreground));

        for (final String key in _specimenKeys) {
          expect(find.byKey(ValueKey<String>(key)), findsOneWidget);
        }
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('installation states that the component is installable, and '
        'names the two sibling files a manual copy also needs', (
      WidgetTester tester,
    ) async {
      await _pump(tester);

      expect(
        find.textContaining('toggle-group is not yet a registry item'),
        findsNothing,
      );
      expect(find.textContaining('elattar add toggle-group'), findsWidgets);

      // The sibling-files note lives on the Manual tab of Installation, not
      // the default CLI tab: switch to it before reading its text.
      final Finder manualTab = find.descendant(
        of: find.byType(DocsInstall),
        matching: find.text('Manual'),
      );
      await tester.ensureVisible(manualTab);
      await tester.tap(manualTab);
      await tester.pump();
      expect(find.textContaining('active_indicator.dart'), findsWidgets);
    });

    testWidgets('the meta entry describes the group alone', (
      WidgetTester tester,
    ) async {
      expect(toggleGroupDoc.name, 'toggle-group');
      expect(toggleGroupDoc.route, '/components/toggle-group');
      expect(toggleGroupDoc.command, 'elattar add toggle-group');
      expect(
        toggleGroupDoc.sourcePath,
        'lib/src/components/ui/toggle_group.dart',
      );
      expect(toggleGroupDoc.exports, <String>[
        'ToggleGroup',
        'ToggleGroupItem',
      ]);
      // The enums stay claimed by toggleDoc: the group declares neither.
      expect(toggleGroupDoc.exports, isNot(contains('Toggle')));
      expect(toggleGroupDoc.exports, isNot(contains('ToggleVariant')));
      expect(toggleGroupDoc.exports, isNot(contains('ToggleSize')));
      expect(toggleItemSourcePath, 'lib/src/components/ui/toggle.dart');
      expect(
        slidingPillSourcePath,
        'lib/src/components/ui/active_indicator.dart',
      );
    });
  });
}
