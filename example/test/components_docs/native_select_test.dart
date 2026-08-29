/// Tests for `components_docs/native_select/page.dart`'s [NativeSelectDocPage].
///
/// This page documents exactly one component: [NativeSelect] and
/// [NativeSelectSize]. `selection_control` and `form` — previously
/// documented on this same page — now have their own pages, and their own
/// tests: `selection_control_test.dart` and `form_test.dart`.
///
/// Re-housed onto the documentation kit (`ComponentDocSpec` +
/// `ComponentDocPage`): sections now render as `DocsSection` (from
/// `docs_section.dart`), not the old `kit.dart` `Section`, and the live
/// demo is a real `Preview` section with its own rail entry rather than an
/// unheaded `DocsCodeExample` above the first heading.
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never synthetic `MediaQuery`. The live
/// `ThemeController` is flipped in place for theme coverage rather than
/// re-pumped under a new controller.
///
/// `pumpAndSettle` is forbidden in a documentation-page test (several
/// components run controllers that `repeat(reverse: true)` forever), so the
/// call this file used to make is replaced with bounded `pump()` calls.
///
/// The API Reference and States sections are now `DocsDisclosure`s, closed
/// by default (a closed `DocsDisclosure` mounts no content at all — see
/// `docs_disclosure_test.dart`), so any test reading their content opens
/// the panel first via [_disclosureTrigger].
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/native_select/meta.dart';
import 'package:example/components_docs/native_select/page.dart';
import 'package:example/docs/docs_disclosure.dart';
import 'package:example/docs/docs_facts.dart';
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

/// The single `DocsDisclosure` whose title is [title]. `DocsDisclosure`'s
/// own trigger key ([DocsDisclosure.triggerKey]) is one constant shared by
/// every instance on the page, so a bare `find.byKey` would match every
/// one — this narrows to the one panel by its title first, matching
/// `button_test.dart`'s own convention.
Finder _disclosureTrigger(String title) => find.descendant(
  of: find.byWidgetPredicate(
    (Widget widget) => widget is DocsDisclosure && widget.title == title,
  ),
  matching: find.byKey(DocsDisclosure.triggerKey),
);

/// Opens the named disclosure: scrolls its trigger into view, taps it, and
/// pumps through the open animation.
Future<void> _openDisclosure(WidgetTester tester, String title) async {
  final Finder trigger = _disclosureTrigger(title);
  await tester.ensureVisible(trigger);
  await tester.pump();
  await tester.tap(trigger);
  await tester.pump();
  await tester.pump(MotionDurations.open);
}

const Size _wide = Size(1440, 900);
const Size _narrow = Size(390, 844);

/// Every `ApiTable` this page must render, by title, and every public
/// constructor parameter or static member of each documented class found by
/// reading `lib/src/components/ui/native_select.dart` directly.
const Map<String, List<String>> _expectedApiTables = <String, List<String>>{
  'NativeSelect': <String>[
    'options',
    'value',
    'onChanged',
    'size',
    'enabled',
    'invalid',
    'expand',
    'width',
    'focusNode',
    'label',
    'hint',
    'NativeSelect.menuOffset',
  ],
  'NativeSelectSize': <String>[
    'sm',
    'md',
    'label',
    'height',
    'radius',
    'insetY',
  ],
};

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
            child: NativeSelectDocPage(onNavigate: onNavigate),
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
    'sections render in the shadcn-mirrored order, section for section',
    (WidgetTester tester) async {
      await _pump(tester);

      final List<String> titles = tester
          .widgetList<DocsSection>(find.byType(DocsSection))
          .map((DocsSection section) => section.title)
          .toList();

      expect(titles, <String>[
        'Preview',
        'Installation',
        'Usage',
        'Composition',
        'Groups',
        'Disabled',
        'Invalid',
        'Native select vs select',
        'RTL',
        'API Reference',
        'States',
        'Accessibility',
        'Keyboard',
        'Responsive',
        'Dependencies',
        'Theming',
        'Source',
      ]);
    },
  );

  testWidgets('the Groups, Disabled, Invalid, and RTL specimens render without '
      'exceptions', (WidgetTester tester) async {
    await _pump(tester);

    for (final String key in <String>[
      'native-select-groups-preview',
      'native-select-disabled-preview',
      'native-select-disabled-option-preview',
      'native-select-invalid-preview',
      'native-select-rtl-preview',
    ]) {
      final Finder finder = find.byKey(ValueKey<String>(key));
      await tester.ensureVisible(finder);
      expect(finder, findsOneWidget, reason: 'missing specimen "$key"');
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'renders the article at wide and narrow widths with no exceptions',
    (WidgetTester tester) async {
      await _pump(tester, size: _wide);

      expect(find.text(nativeSelectDoc.title), findsWidgets);
      expect(find.byType(DocsShowcase), findsAtLeastNWidgets(1));
      expect(
        find.byKey(const ValueKey<String>('docs-layout-sidebar')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);

      await _pump(tester, size: _narrow);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

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
    'each ApiTable covers every public constructor parameter and static '
    'of its own class',
    (WidgetTester tester) async {
      await _pump(tester);
      await _openDisclosure(tester, 'API Reference');

      final List<DocsApiTable> tables = tester
          .widgetList<DocsApiTable>(find.byType(DocsApiTable))
          .toList();
      expect(tables, isNotEmpty);

      final Map<String, Set<String>> byTitle = <String, Set<String>>{
        for (final DocsApiTable table in tables)
          table.title: <String>{
            for (final DocsApiFact fact in table.facts) fact.name,
          },
      };

      for (final MapEntry<String, List<String>> expected
          in _expectedApiTables.entries) {
        final Set<String>? documented = byTitle[expected.key];
        expect(
          documented,
          isNotNull,
          reason: 'no ApiTable titled "${expected.key}" was rendered',
        );
        for (final String param in expected.value) {
          expect(
            documented,
            contains(param),
            reason: '"${expected.key}" table is missing parameter "$param"',
          );
        }
      }
    },
  );

  testWidgets(
    'the live NativeSelect specimen is accessible and can be opened',
    (WidgetTester tester) async {
      await _pump(tester);

      const Key selectKey = ValueKey<String>('native-select-preview');
      await tester.ensureVisible(find.byKey(selectKey));
      expect(tester.takeException(), isNull);
      expect(find.byKey(selectKey), findsOneWidget);
    },
  );

  testWidgets(
    'the state matrix documents rest, focus, invalid, disabled, and open '
    'states',
    (WidgetTester tester) async {
      await _pump(tester);
      await _openDisclosure(tester, 'States');

      final DocsStateMatrix matrix = tester.widget<DocsStateMatrix>(
        find.byType(DocsStateMatrix),
      );
      final Set<String> states = matrix.facts
          .map((DocsStateFact fact) => fact.state)
          .toSet();

      for (final String expected in <String>[
        'Rest',
        'Focus-visible',
        'Invalid',
        'Disabled',
        'Hover',
        'Open',
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
    'both themes render the article with no exceptions when flipped in place',
    (WidgetTester tester) async {
      final ThemeController theme = await _pump(tester, mode: ColorMode.light);
      expect(find.text(nativeSelectDoc.title), findsWidgets);

      theme.setMode(ColorMode.dark);
      await tester.pump();
      expect(find.text(nativeSelectDoc.title), findsWidgets);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('installation presents the working native-select CLI command', (
    WidgetTester tester,
  ) async {
    await _pump(tester);

    expect(find.textContaining('elattar add native-select'), findsWidgets);
  });
}
