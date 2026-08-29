/// Tests for `components_docs/input_group/page.dart`'s [InputGroupDocPage].
///
/// Split off the merged test that used to cover [InputGroup],
/// [ButtonGroup], and [InputOtp] together on one page. This file now
/// covers [InputGroup] and its addon/button/text family only: see
/// `button_group_test.dart` and `input_otp_test.dart` for the other two.
///
/// Re-housed onto the documentation kit (`ComponentDocSpec` +
/// `ComponentDocPage`): sections now render as `DocsSection` (from
/// `docs_section.dart`), not the old `kit.dart` `Section`, and the live
/// preview is a real `Preview` section with its own rail entry rather than
/// an unheaded `DocsCodeExample` above the first heading. The API Reference
/// and States sections are now `DocsDisclosure`s, closed by default (a
/// closed `DocsDisclosure` mounts no content at all — see
/// `docs_disclosure_test.dart`), so any test reading their content opens
/// the panel first via [_disclosureTrigger].
///
/// Reads from `lib/src/components/ui/input_group.dart` directly (Step 1 of the
/// task cycle): every public class, enum, and constructor parameter
/// enumerated below is one this page's API tables must cover.
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never synthetic `MediaQuery`. The live
/// `ThemeController` is flipped in place for theme coverage.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/input_group/meta.dart';
import 'package:example/components_docs/input_group/page.dart';
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
/// every instance on the page, so a bare `find.byKey` would match all
/// eight — this narrows to the one panel by its title first, matching
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

/// The full section list, in order, this page must render: Preview,
/// Installation, Usage, then InputGroup's own sections, API Reference,
/// then the eight fixed disclosures.
const List<String> _expectedSectionOrder = <String>[
  'Preview',
  'Installation',
  'Usage',
  'Composition',
  'Addon position',
  'Addon content',
  'Dropdown addon',
  'Custom input',
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

const Size _wide = Size(1440, 900);
const Size _narrow = Size(390, 844);

/// Every `ApiTable` this page must render, by title, and every public
/// constructor parameter or static member of that class, read directly off
/// `lib/src/components/ui/input_group.dart`.
const Map<String, List<String>> _expectedApiTables = <String, List<String>>{
  'InputGroup': <String>[
    'child',
    'startAddon',
    'endAddon',
    'invalid',
    'enabled',
    'focusNode',
    'InputGroup.height',
    'InputGroup.addonInset',
    'InputGroup.addonButtonPull',
    'InputGroup.clearance',
  ],
  'InputGroupInput': <String>[
    'controller',
    'initialValue',
    'placeholder',
    'onChanged',
    'onSubmitted',
    'readOnly',
    'obscureText',
    'keyboardType',
    'autofillHints',
    'textSpec',
    'label',
  ],
  'InputGroupAddon': <String>[
    'child',
    'align',
    'holdsButton',
    'InputGroupAddon.insetY',
    'InputGroupAddon.gap',
  ],
  'InputGroupText': <String>['text', 'spec'],
  'InputGroupButton': <String>[
    'child',
    'onPressed',
    'label',
    'toggled',
    'focusNode',
    'size',
    'cancelPressFill',
    'InputGroupButton.height',
    'InputGroupButton.paddingX',
    'InputGroupButton.paddingXFor',
    'InputGroupButton.gap',
  ],
  'InputGroupAlign': <String>['start', 'end'],
  'InputGroupButtonSize': <String>['xs', 'iconXs'],
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
            child: InputGroupDocPage(onNavigate: onNavigate),
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

      expect(find.text(inputGroupDoc.title), findsWidgets);
      expect(find.byType(DocsShowcase), findsAtLeastNWidgets(1));
      expect(
        find.byKey(const ValueKey<String>('docs-layout-sidebar')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);

      await _pump(tester, size: _narrow);
      // Not pumpAndSettle(): the "Spinner addon: loading state" specimen
      // holds a live Spinner, which repeat()s its AnimationController
      // forever and never reaches quiescence. Bounded pumps instead.
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
    'the spinner addon specimen animates under normal motion: no TickerMode '
    'above it mutes the loading spinner it exists to demonstrate',
    (WidgetTester tester) async {
      await _pump(tester);

      final Finder spinner = find.byType(Spinner);
      await tester.ensureVisible(spinner.first);
      expect(spinner, findsWidgets);

      expect(
        find.ancestor(
          of: spinner.first,
          matching: find.byWidgetPredicate(
            (Widget w) => w is TickerMode && !w.enabled,
          ),
        ),
        findsNothing,
      );

      await tester.pump();

      final Finder rotationFinder = find.byType(RotationTransition);
      expect(rotationFinder, findsWidgets);

      final RotationTransition rotation1 = tester.widget<RotationTransition>(
        rotationFinder.first,
      );
      final double value1 = rotation1.turns.value;

      await tester.pump(const Duration(milliseconds: 100));

      final RotationTransition rotation2 = tester.widget<RotationTransition>(
        rotationFinder.first,
      );
      final double value2 = rotation2.turns.value;

      expect(
        value2,
        greaterThan(value1),
        reason: 'spinner did not rotate under normal motion',
      );
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

  testWidgets('renders the sections in order, exactly once each', (
    WidgetTester tester,
  ) async {
    await _pump(tester);

    final List<String> rendered = tester
        .widgetList<DocsSection>(find.byType(DocsSection))
        .map((DocsSection section) => section.title)
        .toList();

    expect(rendered, _expectedSectionOrder);
    expect(tester.takeException(), isNull);
  });

  testWidgets('the live specimen: a password InputGroupInput with a '
      'InputGroupButton visibility toggle that flips obscureText', (
    WidgetTester tester,
  ) async {
    await _pump(tester);

    const Key fieldKey = ValueKey<String>('input-group-doc-password-field');
    const Key toggleKey = ValueKey<String>('input-group-doc-password-toggle');
    await tester.ensureVisible(find.byKey(fieldKey));

    final Finder input = find.descendant(
      of: find.byKey(fieldKey),
      matching: find.byType(Input),
    );
    expect(tester.widget<Input>(input).obscureText, isTrue);

    await tester.ensureVisible(find.byKey(toggleKey));
    await tester.tap(find.byKey(toggleKey));
    await tester.pump();

    expect(tester.widget<Input>(input).obscureText, isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets('the state matrix documents rest, focus, invalid, and disabled', (
    WidgetTester tester,
  ) async {
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
      'Focus-within',
      'Invalid',
      'Disabled',
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
      final ThemeController theme = await _pump(tester, mode: ColorMode.light);
      expect(find.text(inputGroupDoc.title), findsWidgets);

      theme.setMode(ColorMode.dark);
      await tester.pump();
      expect(find.text(inputGroupDoc.title), findsWidgets);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('installation presents the working input-group CLI command', (
    WidgetTester tester,
  ) async {
    await _pump(tester);

    expect(find.textContaining('elattar add input-group'), findsWidgets);
  });
}
