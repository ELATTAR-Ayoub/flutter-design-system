/// Tests for `components_docs/toggle_group/page.dart`'s
/// [ToggleGroupDocPage].
///
/// **New with the split.** `ElToggleGroup` and `ElToggleGroupItem` used to be
/// documented on `components_docs/toggle/page.dart`; every group assertion
/// that lived in `toggle_test.dart` moved here, plus one that could not exist
/// before: that every live group carries its own horizontal-scroll
/// mitigation, since `ElSlidingPillGroup`'s internal `Row` neither wraps nor
/// scrolls and overflows a 390px column.
///
/// Section order, matching
/// https://ui.shadcn.com/docs/components/base/toggle-group: Installation,
/// Usage, Composition, Outline, Sizes, Spacing, Vertical, Disabled, Custom,
/// RTL, API Reference, then the six sections shadcn does not carry (States,
/// Accessibility, Responsive, Dependencies, Theming, Source), all behind the
/// un-headed hero demo. `Spacing` and `Vertical` render as
/// what-is-missing disclosures rather than demos: `toggle_group.dart` declares
/// neither a `spacing` nor an `orientation` parameter. `Changelog` is skipped:
/// this package ships from source, not a versioned registry entry.
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never synthetic `MediaQuery`. The live
/// `ElThemeController` is flipped in place for theme coverage rather than
/// re-pumped under a new controller.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/toggle_group/meta.dart';
import 'package:example/components_docs/toggle_group/page.dart';
import 'package:example/docs/docs_code.dart';
import 'package:example/docs/docs_facts.dart';
import 'package:example/docs/docs_layout.dart';
import 'package:example/kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const Size _wide = Size(1440, 900);
const Size _narrow = Size(390, 844);

/// The section anchors this page must render, top to bottom, behind the
/// un-headed `preview` hero demo. Matches page.dart's own `toc:` list exactly.
const List<String> _sectionOrder = <String>[
  'install',
  'usage',
  'composition',
  'outline',
  'sizes',
  'spacing',
  'vertical',
  'disabled',
  'custom',
  'rtl',
  'api',
  'states',
  'accessibility',
  'responsive',
  'dependencies',
  'theming',
  'source',
];

/// The same list as titles, in the same order: read off each mounted
/// [ElSection] rather than with `find.text`, since a section heading and its
/// own TOC link render the same string at wide widths.
const List<String> _sectionTitles = <String>[
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
  'Responsive',
  'Dependencies',
  'Theming',
  'Source',
];

/// Every named constructor parameter `ElToggleGroup` declares, excluding
/// `key`, read directly from `lib/src/components/toggle_group.dart`
/// (L144-L152).
const List<String> _groupParams = <String>[
  'items',
  'selectedIndex',
  'onChanged',
  'variant',
  'size',
  'label',
];

/// Every named constructor parameter `ElToggleGroupItem` declares, excluding
/// `key` (`toggle_group.dart` L81-L85).
const List<String> _itemParams = <String>['label', 'child', 'enabled'];

/// `ElToggleGroup`'s one static, named exactly as the API table names it
/// (`toggle_group.dart` L178).
const String _groupStatic = 'ElToggleGroup.gap';

/// Every live `ElToggleGroup` specimen this page's own source keys. Each one
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
        expect(find.byType(DocsCodeExample), findsAtLeastNWidgets(1));
        expect(
          find.byKey(const ValueKey<String>('docs-layout-sidebar')),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);

        // 390px is where ElSlidingPillGroup's Row overflowed before the
        // mitigation landed: the whole page must still render clean here.
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
      'the section list renders in order, behind the un-headed hero demo',
      (WidgetTester tester) async {
        await _pump(tester);

        final double previewTop = tester
            .getTopLeft(find.byKey(docsAnchorKey('preview')))
            .dy;
        double previousTop = previewTop;
        for (final String id in _sectionOrder) {
          final Finder section = find.byKey(ElSection.anchorKey(id));
          expect(section, findsOneWidget, reason: 'missing section: $id');
          final double top = tester.getTopLeft(section).dy;
          expect(
            top,
            greaterThan(previousTop),
            reason: 'section "$id" is not below the previous section',
          );
          previousTop = top;
        }

        final List<String> titles = tester
            .widgetList<ElSection>(find.byType(ElSection))
            .map((ElSection section) => section.title)
            .toList();
        expect(titles, _sectionTitles);

        // The prefixed titles the merged page used are gone, and so are the
        // standalone toggle's own sections.
        for (final String oldId in <String>[
          'toggle-group-composition',
          'toggle-group-outline',
          'toggle-group-sizes',
          'toggle-group-disabled',
          'toggle-group-custom',
          'toggle-group-rtl',
          'with-text',
          'independent',
        ]) {
          expect(
            find.byKey(ElSection.anchorKey(oldId)),
            findsNothing,
            reason: 'the old "$oldId" section should not be on this page',
          );
        }
      },
    );

    testWidgets(
      'every live group specimen keeps its horizontal-scroll mitigation: '
      'ElSlidingPillGroup\'s Row neither wraps nor scrolls on its own',
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
        expect(find.byType(ElToggleGroup), findsNWidgets(_specimenKeys.length));

        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'the API tables cover every ElToggleGroup and ElToggleGroupItem '
      'constructor parameter, plus the one static, one table per class',
      (WidgetTester tester) async {
        await _pump(tester);

        final List<DocsApiTable> tables = tester
            .widgetList<DocsApiTable>(find.byType(DocsApiTable))
            .toList();
        expect(tables.map((DocsApiTable t) => t.title), <String>[
          'ElToggleGroup',
          'ElToggleGroup static helpers',
          'ElToggleGroupItem',
        ]);

        // Each table covers its own class, not a merged pile: the group's
        // constructor table carries no static and no item field.
        final DocsApiTable groupTable = tables.first;
        expect(
          groupTable.facts.map((DocsApiFact f) => f.name),
          _groupParams,
          reason:
              'the ElToggleGroup table must be exactly its constructor '
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
          'ElToggle.gap',
        ]) {
          expect(
            documented,
            isNot(contains(toggleOnly)),
            reason:
                '"$toggleOnly" is a ElToggle member and belongs on the '
                'toggle page',
          );
        }
      },
    );

    testWidgets(
      'the API tables report the real types the constructors declare',
      (WidgetTester tester) async {
        await _pump(tester);

        final Map<String, String> types = <String, String>{
          for (final DocsApiTable table in tester.widgetList<DocsApiTable>(
            find.byType(DocsApiTable),
          ))
            for (final DocsApiFact fact in table.facts) fact.name: fact.type,
        };

        expect(types['items'], 'List<ElToggleGroupItem>');
        expect(types['selectedIndex'], 'int?');
        expect(types['onChanged'], 'ValueChanged<int?>');
        expect(types['variant'], 'ElToggleVariant');
        expect(types['size'], 'ElToggleSize');
        expect(types[_groupStatic], 'static double');
        // ElToggleGroupItem.child is the last 'child' row on the page, and
        // ElToggleGroupItem is the only class here with one.
        expect(types['child'], 'Widget?');
        expect(types['enabled'], 'bool');
      },
    );

    testWidgets(
      'the hero specimen selects a new option on tap and deselects to null '
      'when the already-selected option is tapped again, the single-select '
      'deselect semantics ElToggleGroup reproduces',
      (WidgetTester tester) async {
        await _pump(tester);

        const Key key = ValueKey<String>('toggle-group-live-specimen');
        expect(find.byKey(key), findsOneWidget);
        await tester.ensureVisible(find.byKey(key));

        ElToggleGroup group = tester.widget<ElToggleGroup>(find.byKey(key));
        expect(group.selectedIndex, 0);
        expect(group.items.map((ElToggleGroupItem i) => i.label), <String>[
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
        group = tester.widget<ElToggleGroup>(find.byKey(key));
        expect(group.selectedIndex, 1);

        await tester.tap(priceInSpecimen, warnIfMissed: false);
        await tester.pump();
        group = tester.widget<ElToggleGroup>(find.byKey(key));
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
          tester.widget<ElToggleGroup>(outlineGroup).variant,
          ElToggleVariant.outline,
        );

        final Finder smGroup = find.byKey(
          const ValueKey<String>('toggle-group-sizes-sm-specimen'),
        );
        final Finder lgGroup = find.byKey(
          const ValueKey<String>('toggle-group-sizes-lg-specimen'),
        );
        await tester.ensureVisible(smGroup);
        expect(tester.widget<ElToggleGroup>(smGroup).size, ElToggleSize.sm);
        expect(tester.widget<ElToggleGroup>(lgGroup).size, ElToggleSize.lg);

        final Finder disabledGroup = find.byKey(
          const ValueKey<String>('toggle-group-disabled-specimen'),
        );
        await tester.ensureVisible(disabledGroup);
        final ElToggleGroup disabled = tester.widget<ElToggleGroup>(
          disabledGroup,
        );
        expect(disabled.items[1].enabled, isFalse);
        expect(disabled.items[0].enabled, isTrue);

        // Custom: two items supply their own child, the third falls back to
        // a bare Text(label).
        final Finder customGroup = find.byKey(
          const ValueKey<String>('toggle-group-custom-specimen'),
        );
        await tester.ensureVisible(customGroup);
        final ElToggleGroup custom = tester.widget<ElToggleGroup>(customGroup);
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
              .widget<ElToggleGroup>(rtl)
              .items
              .map((ElToggleGroupItem i) => i.label)
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

        // ElSection.anchorKey is attached to an inner wrapper, not the
        // ElSection element itself, so look the section up by its own id.
        final Map<String, String?> descriptions = <String, String?>{
          for (final ElSection section in tester.widgetList<ElSection>(
            find.byType(ElSection),
          ))
            section.id: section.description,
        };
        expect(descriptions['spacing'], contains('no spacing parameter'));
        expect(descriptions['vertical'], contains('no orientation parameter'));

        // And the props really are absent from the API tables, which is what
        // makes the disclosure true rather than decorative.
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
        final ElThemeController theme = await _pump(
          tester,
          mode: ElThemeMode.light,
        );
        expect(find.text(toggleGroupDoc.title), findsWidgets);

        final ElThemeData light = ElTheme.of(
          tester.element(
            find.byKey(const ValueKey<String>('toggle-group-doc-article')),
          ),
        );

        theme.setMode(ElThemeMode.dark);
        await tester.pump();

        final ElThemeData dark = ElTheme.of(
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
      expect(find.textContaining('sliding_pill.dart'), findsWidgets);
    });

    testWidgets('the meta entry describes the group alone', (
      WidgetTester tester,
    ) async {
      expect(toggleGroupDoc.name, 'toggle-group');
      expect(toggleGroupDoc.route, '/components/toggle-group');
      expect(toggleGroupDoc.command, 'elattar add toggle-group');
      expect(toggleGroupDoc.sourcePath, 'lib/src/components/toggle_group.dart');
      expect(toggleGroupDoc.exports, <String>[
        'ElToggleGroup',
        'ElToggleGroupItem',
      ]);
      // The enums stay claimed by toggleDoc: the group declares neither.
      expect(toggleGroupDoc.exports, isNot(contains('ElToggle')));
      expect(toggleGroupDoc.exports, isNot(contains('ElToggleVariant')));
      expect(toggleGroupDoc.exports, isNot(contains('ElToggleSize')));
      expect(toggleItemSourcePath, 'lib/src/components/toggle.dart');
      expect(slidingPillSourcePath, 'lib/src/motion/sliding_pill.dart');
    });
  });
}
