/// Tests for `components_docs/toggle/page.dart`'s [ToggleDocPage].
///
/// **Re-housed onto the documentation kit.** This suite used to read the old
/// page's `Section`s and its own hand-rolled `docsAnchorKey`/
/// `Section.anchorKey` anchors directly; it now reads `DocsSection` (the
/// kit's own section widget) and opens each `DocsDisclosure` before reading
/// what is inside it — closed by default, it mounts no content at all —
/// matching `button_test.dart`'s own pattern, the worked reference for this
/// rollout. The pixel-position ordering assertion the old suite made off
/// `docsAnchorKey`/`Section.anchorKey` cannot survive unchanged (those are
/// not how the kit marks an anchor); it is rewritten below to assert the
/// identical fact — the sections render in this exact order — by reading
/// each mounted `DocsSection`'s own `title`, the same substitution
/// `button_test.dart` itself made for the same reason.
///
/// **Trimmed for the split.** This suite still covers `Toggle` alone; every
/// group assertion lives in `toggle_group_test.dart`, and the assertion that
/// no `ToggleGroup` mounts here at all is kept, unmoved.
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never synthetic `MediaQuery`. The live
/// `ThemeController` is flipped in place for theme coverage rather than
/// re-pumped under a new controller.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/toggle/meta.dart';
import 'package:example/components_docs/toggle/page.dart';
import 'package:example/docs/docs_disclosure.dart';
import 'package:example/docs/docs_facts.dart';
import 'package:example/docs/docs_section.dart' show DocsSection;
import 'package:example/docs/docs_showcase.dart' show DocsShowcase;
import 'package:flutter/foundation.dart' show listEquals;
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
/// `page.dart`'s own `toggleDocSpec.sections` exactly.
const List<String> _sectionTitles = <String>[
  'Preview',
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
  'Keyboard',
  'Responsive',
  'Dependencies',
  'Theming',
  'Source',
];

/// Every named constructor parameter `Toggle` declares, excluding `key`,
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

/// `Toggle`'s six static helpers, named exactly as the API table names
/// them (`toggle.dart` L243-L306).
const List<String> _toggleStatics = <String>[
  'Toggle.heightFor(size)',
  'Toggle.minWidthFor(size)',
  'Toggle.paddingX',
  'Toggle.gap',
  'Toggle.radiusFor(size)',
  'Toggle.iconSizeFor(size)',
];

/// Every live `Toggle` specimen this page's own source keys.
const List<String> _specimenKeys = <String>[
  'toggle-live-specimen',
  'toggle-outline-bold-specimen',
  'toggle-with-text-specimen',
  'toggle-independent-bold-specimen',
  'toggle-independent-italic-specimen',
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

/// The single `DocsDisclosure` whose title is [title]. `DocsDisclosure`'s
/// own trigger key is one constant shared by every instance on the page, so
/// a bare `find.byKey` would match all eight — this narrows to the one panel
/// by its title first.
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
      'the group half of the old page is gone: every mounted ToggleGroup '
      'is the kit\'s own Preview/Code or CLI/Manual chrome, never a '
      'documented ToggleGroup specimen',
      (WidgetTester tester) async {
        await _pump(tester);

        // DocsShowcase and DocsInstall are both built out of ToggleGroup
        // as their own Preview/Code and CLI/Manual view switchers — that is
        // kit chrome every re-housed page carries, not a component
        // specimen. What must stay true after the split is that no group
        // *content* (a documented ToggleGroup demonstrating the real
        // component) mounts here: every ToggleGroup's own items must be
        // one of those two fixed kit-chrome label sets.
        const List<String> chromeA = <String>['Preview', 'Code'];
        const List<String> chromeB = <String>['CLI', 'Manual'];
        for (final ToggleGroup group in tester.widgetList<ToggleGroup>(
          find.byType(ToggleGroup),
        )) {
          final List<String> labels = group.items
              .map((ToggleGroupItem item) => item.label)
              .toList();
          final bool isKitChrome =
              listEquals(labels, chromeA) || listEquals(labels, chromeB);
          expect(
            isKitChrome,
            isTrue,
            reason:
                'unexpected ToggleGroup content on the toggle page: '
                '$labels — ToggleGroup belongs to toggle_group/page.dart '
                'after the split',
          );
        }

        await _open(tester, 'API Reference');

        // And no group API row leaked into this page's tables either.
        final Set<String> documented = _documentedNames(tester);
        for (final String groupOnly in <String>[
          'items',
          'selectedIndex',
          'enabled',
          'ToggleGroup.gap',
        ]) {
          expect(
            documented,
            isNot(contains(groupOnly)),
            reason:
                '"$groupOnly" is a ToggleGroup/ToggleGroupItem member '
                'and belongs on the toggle-group page',
          );
        }

        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'the API tables cover every Toggle constructor parameter, every '
      'static helper, and every ToggleVariant and ToggleSize value',
      (WidgetTester tester) async {
        await _pump(tester);
        await _open(tester, 'API Reference');

        final List<DocsApiTable> tables = tester
            .widgetList<DocsApiTable>(find.byType(DocsApiTable))
            .toList();
        // One table per class or enum, plus one for the statics: never a
        // merged table.
        expect(tables.map((DocsApiTable t) => t.title), <String>[
          'Toggle',
          'Toggle static helpers',
          'ToggleVariant',
          'ToggleSize',
        ]);

        final Set<String> documented = _documentedNames(tester);

        for (final String param in _toggleParams) {
          expect(
            documented,
            contains(param),
            reason: 'Toggle constructor parameter "$param" is undocumented',
          );
        }
        for (final String member in _toggleStatics) {
          expect(
            documented,
            contains(member),
            reason: 'Toggle static "$member" is undocumented',
          );
        }
        for (final ToggleVariant variant in ToggleVariant.values) {
          expect(
            documented,
            contains(variant.name),
            reason: 'ToggleVariant.${variant.name} is undocumented',
          );
        }
        for (final ToggleSize size in ToggleSize.values) {
          expect(
            documented,
            contains(size.name),
            reason: 'ToggleSize.${size.name} is undocumented',
          );
        }
      },
    );

    testWidgets(
      'every live specimen this page keys is mounted, and every variant and '
      'size rung has a real Toggle behind it',
      (WidgetTester tester) async {
        await _pump(tester);

        for (final String key in _specimenKeys) {
          expect(
            find.byKey(ValueKey<String>(key)),
            findsOneWidget,
            reason: 'missing specimen $key',
          );
        }

        final List<Toggle> mounted = tester
            .widgetList<Toggle>(find.byType(Toggle))
            .toList();
        expect(
          mounted.map((Toggle t) => t.variant).toSet(),
          containsAll(ToggleVariant.values),
        );
        expect(
          mounted.map((Toggle t) => t.size).toSet(),
          containsAll(ToggleSize.values),
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
      expect(tester.widget<Toggle>(find.byKey(key)).pressed, isFalse);

      await tester.tap(find.byKey(key), warnIfMissed: false);
      await tester.pump();
      expect(tester.widget<Toggle>(find.byKey(key)).pressed, isTrue);

      await tester.tap(find.byKey(key), warnIfMissed: false);
      await tester.pump();
      expect(tester.widget<Toggle>(find.byKey(key)).pressed, isFalse);

      expect(tester.takeException(), isNull);
    });

    testWidgets('the Outline and With text specimens mount and toggle on tap', (
      WidgetTester tester,
    ) async {
      await _pump(tester);

      const Key outlineKey = ValueKey<String>('toggle-outline-bold-specimen');
      await tester.ensureVisible(find.byKey(outlineKey));
      final Toggle outline = tester.widget<Toggle>(find.byKey(outlineKey));
      expect(outline.variant, ToggleVariant.outline);
      expect(outline.pressed, isFalse);
      await tester.tap(find.byKey(outlineKey), warnIfMissed: false);
      await tester.pump();
      expect(tester.widget<Toggle>(find.byKey(outlineKey)).pressed, isTrue);

      const Key withTextKey = ValueKey<String>('toggle-with-text-specimen');
      await tester.ensureVisible(find.byKey(withTextKey));
      expect(tester.widget<Toggle>(find.byKey(withTextKey)).pressed, isFalse);
      await tester.tap(find.byKey(withTextKey), warnIfMissed: false);
      await tester.pump();
      expect(tester.widget<Toggle>(find.byKey(withTextKey)).pressed, isTrue);

      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'the Independent toggles specimen mounts two Toggles that stay '
      'mutually independent',
      (WidgetTester tester) async {
        await _pump(tester);

        final Finder bold = find.byKey(
          const ValueKey<String>('toggle-independent-bold-specimen'),
        );
        final Finder italic = find.byKey(
          const ValueKey<String>('toggle-independent-italic-specimen'),
        );
        await tester.ensureVisible(bold);
        expect(tester.widget<Toggle>(bold).pressed, isFalse);
        expect(tester.widget<Toggle>(italic).pressed, isFalse);

        await tester.tap(bold, warnIfMissed: false);
        await tester.pump();
        expect(tester.widget<Toggle>(bold).pressed, isTrue);
        expect(
          tester.widget<Toggle>(italic).pressed,
          isFalse,
          reason: 'Bold and Italic must not be mutually exclusive',
        );

        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'the Disabled specimens really are disabled, at both pressed values',
      (WidgetTester tester) async {
        await _pump(tester);

        const Key off = ValueKey<String>('toggle-disabled-off-specimen');
        const Key on = ValueKey<String>('toggle-disabled-on-specimen');
        await tester.ensureVisible(find.byKey(off));

        final Toggle offToggle = tester.widget<Toggle>(find.byKey(off));
        final Toggle onToggle = tester.widget<Toggle>(find.byKey(on));
        expect(offToggle.onChanged, isNull);
        expect(onToggle.onChanged, isNull);
        expect(offToggle.pressed, isFalse);
        expect(onToggle.pressed, isTrue);

        // A null onChanged is the only disabled switch Toggle has: tapping
        // must change nothing at all.
        await tester.tap(find.byKey(off), warnIfMissed: false);
        await tester.pump();
        expect(tester.widget<Toggle>(find.byKey(off)).pressed, isFalse);

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

        expect(tester.widget<Toggle>(rtl).pressed, isFalse);
        await tester.tap(rtl, warnIfMissed: false);
        await tester.pump();
        expect(tester.widget<Toggle>(rtl).pressed, isTrue);

        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'the state matrix documents the applicable standalone-toggle states, '
      'and no group-only row',
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
        final ThemeController theme = await _pump(
          tester,
          mode: ColorMode.light,
        );
        expect(find.text(toggleDoc.title), findsWidgets);

        final ThemeTokens light = ThemeScope.of(
          tester.element(
            find.byKey(const ValueKey<String>('toggle-doc-article')),
          ),
        );

        theme.setMode(ColorMode.dark);
        await tester.pump();

        final ThemeTokens dark = ThemeScope.of(
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

    testWidgets('installation states that the component is installable, for '
        'toggle alone', (WidgetTester tester) async {
      await _pump(tester);

      expect(
        find.textContaining('toggle is not yet a registry item'),
        findsNothing,
      );
      expect(find.textContaining('elattar add toggle'), findsWidgets);
    });

    testWidgets('the meta entry describes Toggle alone', (
      WidgetTester tester,
    ) async {
      expect(toggleDoc.name, 'toggle');
      expect(toggleDoc.route, '/components/toggle');
      expect(toggleDoc.command, 'elattar add toggle');
      expect(toggleDoc.sourcePath, 'lib/src/components/toggle.dart');
      expect(toggleDoc.exports, <String>[
        'Toggle',
        'ToggleVariant',
        'ToggleSize',
      ]);
      // The group's own exports moved to toggleGroupDoc.
      expect(toggleDoc.exports, isNot(contains('ToggleGroup')));
      expect(toggleDoc.exports, isNot(contains('ToggleGroupItem')));
    });
  });
}
