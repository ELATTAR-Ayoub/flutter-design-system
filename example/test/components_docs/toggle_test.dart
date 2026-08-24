/// Tests for `components_docs/toggle/page.dart`'s [ToggleDocPage].
///
/// **Trimmed for the split.** This suite used to cover `ElToggle` AND
/// `ElToggleGroup` on one page. The group moved to its own page, so every
/// group assertion moved to `toggle_group_test.dart`, and one assertion was
/// added in their place: that no `ElToggleGroup` mounts here at all, which is
/// what keeps the split from silently regressing.
///
/// Section order, matching https://ui.shadcn.com/docs/components/base/toggle
/// with `Independent toggles` added in its style: Installation, Usage,
/// Outline, With text, Independent toggles, Sizes, Disabled, RTL, API
/// Reference, then the six sections shadcn does not carry (States,
/// Accessibility, Responsive, Dependencies, Theming, Source), all behind the
/// un-headed hero demo. `Changelog` is skipped: this package ships from
/// source, not a versioned registry entry.
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never synthetic `MediaQuery`. The live
/// `ElThemeController` is flipped in place for theme coverage rather than
/// re-pumped under a new controller.
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

/// The section anchors this page must render, top to bottom, behind the
/// un-headed `preview` hero demo. Matches page.dart's own `toc:` list exactly.
const List<String> _sectionOrder = <String>[
  'install',
  'usage',
  'outline',
  'with-text',
  'independent',
  'sizes',
  'disabled',
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
  'Outline',
  'With text',
  'Independent toggles',
  'Sizes',
  'Disabled',
  'RTL',
  'API Reference',
  'States',
  'Accessibility',
  'Responsive',
  'Dependencies',
  'Theming',
  'Source',
];

/// Every named constructor parameter `ElToggle` declares, excluding `key`,
/// read directly from `lib/src/components/toggle.dart` (L166-L178).
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

/// `ElToggle`'s six static helpers, named exactly as the API table names
/// them (`toggle.dart` L243-L306).
const List<String> _toggleStatics = <String>[
  'ElToggle.heightFor(size)',
  'ElToggle.minWidthFor(size)',
  'ElToggle.paddingX',
  'ElToggle.gap',
  'ElToggle.radiusFor(size)',
  'ElToggle.iconSizeFor(size)',
];

/// Every live `ElToggle` specimen this page's own source keys.
const List<String> _specimenKeys = <String>[
  'toggle-live-specimen',
  'toggle-outline-bold-specimen',
  'toggle-with-text-specimen',
  'toggle-sizes-standard-sm-specimen',
  'toggle-sizes-standard-md-specimen',
  'toggle-sizes-standard-lg-specimen',
  'toggle-sizes-outline-sm-specimen',
  'toggle-sizes-outline-md-specimen',
  'toggle-sizes-outline-lg-specimen',
  'toggle-disabled-off-specimen',
  'toggle-disabled-on-specimen',
  'toggle-rtl-specimen',
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
            child: ToggleDocPage(onNavigate: onNavigate),
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

void main() {
  group('toggle docs page', () {
    testWidgets(
      'renders the article at wide and narrow widths with no exceptions',
      (WidgetTester tester) async {
        await _pump(tester, size: _wide);

        expect(
          find.byKey(const ValueKey<String>('toggle-doc-article')),
          findsOneWidget,
        );
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

        // Titles, in the same order, read off the mounted ElSections: a bare
        // find.text would match a heading and its own TOC link both.
        final List<String> titles = tester
            .widgetList<ElSection>(find.byType(ElSection))
            .map((ElSection section) => section.title)
            .toList();
        expect(titles, _sectionTitles);

        // The prefixed titles the merged page used are gone, and so are the
        // group's own anchors: checked by absent ElSection anchor, since
        // several of these words still appear as incidental text elsewhere.
        for (final String oldId in <String>[
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
          'composition',
        ]) {
          expect(
            find.byKey(ElSection.anchorKey(oldId)),
            findsNothing,
            reason: 'the old "$oldId" section should be gone',
          );
        }
      },
    );

    testWidgets(
      'the group half of the old page is gone: no ElToggleGroup mounts here',
      (WidgetTester tester) async {
        await _pump(tester);

        expect(
          find.byType(ElToggleGroup),
          findsNothing,
          reason:
              'ElToggleGroup belongs to toggle_group/page.dart after the '
              'split',
        );

        // And no group API row leaked into this page's tables either.
        final Set<String> documented = _documentedNames(tester);
        for (final String groupOnly in <String>[
          'items',
          'selectedIndex',
          'enabled',
          'ElToggleGroup.gap',
        ]) {
          expect(
            documented,
            isNot(contains(groupOnly)),
            reason:
                '"$groupOnly" is a ElToggleGroup/ElToggleGroupItem member '
                'and belongs on the toggle-group page',
          );
        }

        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'the API tables cover every ElToggle constructor parameter, every '
      'static helper, and every ElToggleVariant and ElToggleSize value',
      (WidgetTester tester) async {
        await _pump(tester);

        final List<DocsApiTable> tables = tester
            .widgetList<DocsApiTable>(find.byType(DocsApiTable))
            .toList();
        // One table per class or enum, plus one for the statics: never a
        // merged table.
        expect(tables.map((DocsApiTable t) => t.title), <String>[
          'ElToggle',
          'ElToggle static helpers',
          'ElToggleVariant',
          'ElToggleSize',
        ]);

        final Set<String> documented = _documentedNames(tester);

        for (final String param in _toggleParams) {
          expect(
            documented,
            contains(param),
            reason: 'ElToggle constructor parameter "$param" is undocumented',
          );
        }
        for (final String member in _toggleStatics) {
          expect(
            documented,
            contains(member),
            reason: 'ElToggle static "$member" is undocumented',
          );
        }
        for (final ElToggleVariant variant in ElToggleVariant.values) {
          expect(
            documented,
            contains(variant.name),
            reason: 'ElToggleVariant.${variant.name} is undocumented',
          );
        }
        for (final ElToggleSize size in ElToggleSize.values) {
          expect(
            documented,
            contains(size.name),
            reason: 'ElToggleSize.${size.name} is undocumented',
          );
        }
      },
    );

    testWidgets(
      'every live specimen this page keys is mounted, and every variant and '
      'size rung has a real ElToggle behind it',
      (WidgetTester tester) async {
        await _pump(tester);

        for (final String key in _specimenKeys) {
          expect(
            find.byKey(ValueKey<String>(key)),
            findsOneWidget,
            reason: 'missing specimen $key',
          );
        }

        final List<ElToggle> mounted = tester
            .widgetList<ElToggle>(find.byType(ElToggle))
            .toList();
        expect(
          mounted.map((ElToggle t) => t.variant).toSet(),
          containsAll(ElToggleVariant.values),
        );
        expect(
          mounted.map((ElToggle t) => t.size).toSet(),
          containsAll(ElToggleSize.values),
        );

        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('the live hero specimen flips pressed on tap, both ways', (
      WidgetTester tester,
    ) async {
      await _pump(tester);

      const Key key = ValueKey<String>('toggle-live-specimen');
      await tester.ensureVisible(find.byKey(key));
      expect(tester.widget<ElToggle>(find.byKey(key)).pressed, isFalse);

      await tester.tap(find.byKey(key), warnIfMissed: false);
      await tester.pump();
      expect(tester.widget<ElToggle>(find.byKey(key)).pressed, isTrue);

      await tester.tap(find.byKey(key), warnIfMissed: false);
      await tester.pump();
      expect(tester.widget<ElToggle>(find.byKey(key)).pressed, isFalse);

      expect(tester.takeException(), isNull);
    });

    testWidgets('the Outline and With text specimens mount and toggle on tap', (
      WidgetTester tester,
    ) async {
      await _pump(tester);

      const Key outlineKey = ValueKey<String>('toggle-outline-bold-specimen');
      await tester.ensureVisible(find.byKey(outlineKey));
      final ElToggle outline = tester.widget<ElToggle>(find.byKey(outlineKey));
      expect(outline.variant, ElToggleVariant.outline);
      expect(outline.pressed, isFalse);
      await tester.tap(find.byKey(outlineKey), warnIfMissed: false);
      await tester.pump();
      expect(tester.widget<ElToggle>(find.byKey(outlineKey)).pressed, isTrue);

      const Key withTextKey = ValueKey<String>('toggle-with-text-specimen');
      await tester.ensureVisible(find.byKey(withTextKey));
      expect(tester.widget<ElToggle>(find.byKey(withTextKey)).pressed, isFalse);
      await tester.tap(find.byKey(withTextKey), warnIfMissed: false);
      await tester.pump();
      expect(tester.widget<ElToggle>(find.byKey(withTextKey)).pressed, isTrue);

      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'the Disabled specimens really are disabled, at both pressed values',
      (WidgetTester tester) async {
        await _pump(tester);

        const Key off = ValueKey<String>('toggle-disabled-off-specimen');
        const Key on = ValueKey<String>('toggle-disabled-on-specimen');
        await tester.ensureVisible(find.byKey(off));

        final ElToggle offToggle = tester.widget<ElToggle>(find.byKey(off));
        final ElToggle onToggle = tester.widget<ElToggle>(find.byKey(on));
        expect(offToggle.onChanged, isNull);
        expect(onToggle.onChanged, isNull);
        expect(offToggle.pressed, isFalse);
        expect(onToggle.pressed, isTrue);

        // A null onChanged is the only disabled switch ElToggle has: tapping
        // must change nothing at all.
        await tester.tap(find.byKey(off), warnIfMissed: false);
        await tester.pump();
        expect(tester.widget<ElToggle>(find.byKey(off)).pressed, isFalse);

        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'the RTL specimen renders under Directionality.rtl and is still '
      'tappable',
      (WidgetTester tester) async {
        await _pump(tester);

        const Key key = ValueKey<String>('toggle-rtl-specimen');
        final Finder rtl = find.byKey(key);
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

        expect(tester.widget<ElToggle>(rtl).pressed, isFalse);
        await tester.tap(rtl, warnIfMissed: false);
        await tester.pump();
        expect(tester.widget<ElToggle>(rtl).pressed, isTrue);

        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'the state matrix documents the applicable standalone-toggle states, '
      'and no group-only row',
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
          'Selected (on)',
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
        expect(
          states,
          isNot(contains('Selected: in a group')),
          reason: 'the group-only row belongs on the toggle-group page',
        );
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
        expect(find.text(toggleDoc.title), findsWidgets);

        final ElThemeData light = ElTheme.of(
          tester.element(
            find.byKey(const ValueKey<String>('toggle-doc-article')),
          ),
        );

        theme.setMode(ElThemeMode.dark);
        await tester.pump();

        final ElThemeData dark = ElTheme.of(
          tester.element(
            find.byKey(const ValueKey<String>('toggle-doc-article')),
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

    testWidgets(
      'installation is honestly disclosed as not yet CLI-installable, for '
      'toggle alone',
      (WidgetTester tester) async {
        await _pump(tester);

        expect(
          find.textContaining('toggle is not yet a registry item'),
          findsWidgets,
        );
      },
    );

    testWidgets('the meta entry describes ElToggle alone', (
      WidgetTester tester,
    ) async {
      expect(toggleDoc.name, 'toggle');
      expect(toggleDoc.route, '/components/toggle');
      expect(toggleDoc.command, 'elattar add toggle');
      expect(toggleDoc.sourcePath, 'lib/src/components/toggle.dart');
      expect(toggleDoc.exports, <String>[
        'ElToggle',
        'ElToggleVariant',
        'ElToggleSize',
      ]);
      // The group's own exports moved to toggleGroupDoc.
      expect(toggleDoc.exports, isNot(contains('ElToggleGroup')));
      expect(toggleDoc.exports, isNot(contains('ElToggleGroupItem')));
    });
  });
}
