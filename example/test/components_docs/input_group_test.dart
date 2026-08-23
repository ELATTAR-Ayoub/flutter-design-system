/// Tests for `components_docs/input_group/page.dart`'s [InputGroupDocPage] —
/// the ONE page documenting THREE grouping components: [DsInputGroup] (and
/// its addon/button/text family), [DsButtonGroup] (and its text/separator
/// members), and [DsInputOtp] (and its slot/separator parts).
///
/// All three read from `lib/src/components/input_group.dart`,
/// `button_group.dart`, and `input_otp.dart` directly (Step 1 of the task
/// cycle): every public class, enum, and constructor parameter enumerated
/// below is one this page's API tables must cover.
///
/// The completeness test checks each class's own [DocsApiTable] by title —
/// several classes share parameter names (`child`, `label`, `focusNode`,
/// `text`) and a flat merged set would not catch a class whose own table is
/// missing one.
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never synthetic `MediaQuery`. The live
/// `DsThemeController` is flipped in place for theme coverage.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/input_group/meta.dart';
import 'package:example/components_docs/input_group/page.dart';
import 'package:example/docs/docs_code.dart';
import 'package:example/docs/docs_facts.dart';
import 'package:example/kit.dart' show DsSection;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

/// The full section list, in order, this page must render: shared frame
/// first (Preview, Installation, Usage, Composition), each family's own
/// sections grouped under its own name (Input group, Button group, Input
/// OTP), one merged API Reference, then the six sections shadcn does not
/// have (States, Accessibility, Responsive, Dependencies, Theming, Source).
/// Mirrors https://ui.shadcn.com/docs/components/base/input-group,
/// https://ui.shadcn.com/docs/components/base/button-group, and
/// https://ui.shadcn.com/docs/components/base/input-otp, merged.
const List<String> _expectedSectionOrder = <String>[
  'Installation',
  'Usage',
  'Composition',
  'Input group',
  'Addon position',
  'Addon content',
  'Custom input',
  'RTL',
  'Button group',
  'Composing other members',
  'Separator',
  'Split',
  'Nested',
  'Sizes',
  'Vs. selection control',
  'RTL',
  'Input OTP',
  'Groups and separators',
  'Disabled',
  'Controlled',
  'Invalid',
  'Four digits',
  'Verification form',
  'RTL',
  'API Reference',
  'States and feedback',
  'Accessibility and keyboard behavior',
  'Responsive and platform behavior',
  'Dependencies, files, and assets',
  'Theming notes',
  'Source and tests',
];

const Size _wide = Size(1440, 900);
const Size _narrow = Size(390, 844);

/// Every `DsApiTable` this page must render, by title, and every public
/// constructor parameter or static member of that class, read directly off
/// `lib/src/components/input_group.dart`, `button_group.dart`, and
/// `input_otp.dart`. The two enums (`DsInputGroupAlign`,
/// `DsInputGroupButtonSize`) are documented in Variants, but checked the same
/// way: by their own table title.
const Map<String, List<String>> _expectedApiTables = <String, List<String>>{
  // ── input_group.dart ──
  'DsInputGroup': <String>[
    'child',
    'startAddon',
    'endAddon',
    'invalid',
    'enabled',
    'focusNode',
    'DsInputGroup.height',
    'DsInputGroup.addonInset',
    'DsInputGroup.addonButtonPull',
    'DsInputGroup.clearance',
  ],
  'DsInputGroupInput': <String>[
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
  'DsInputGroupAddon': <String>[
    'child',
    'align',
    'holdsButton',
    'DsInputGroupAddon.insetY',
    'DsInputGroupAddon.gap',
  ],
  'DsInputGroupText': <String>['text', 'spec'],
  'DsInputGroupButton': <String>[
    'child',
    'onPressed',
    'label',
    'toggled',
    'focusNode',
    'size',
    'cancelPressFill',
    'DsInputGroupButton.height',
    'DsInputGroupButton.paddingX',
    'DsInputGroupButton.paddingXFor',
    'DsInputGroupButton.gap',
  ],
  'DsInputGroupAlign': <String>['start', 'end'],
  'DsInputGroupButtonSize': <String>['xs', 'iconXs'],
  // ── button_group.dart ──
  'DsButtonGroup': <String>[
    'children',
    'DsButtonGroup.radiiOf',
    'DsButtonGroup.hasLeftBorder',
  ],
  'DsButtonGroupText': <String>[
    'text',
    'numeric',
    'DsButtonGroupText.paddingX',
    'DsButtonGroupText.gap',
  ],
  'DsButtonGroupSeparator': <String>[],
  // ── input_otp.dart ──
  'DsInputOtp': <String>[
    'maxLength',
    'groups',
    'controller',
    'initialValue',
    'focusNode',
    'onChanged',
    'enabled',
    'invalid',
    'label',
    'DsInputOtp.slotSize',
    'DsInputOtp.separatorWidth',
    'DsInputOtp.widthFor',
  ],
  'DsInputOtpSlot': <String>['char', 'active', 'invalid', 'first', 'last'],
  'DsInputOtpSeparator': <String>[],
};

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
      expect(find.byType(DocsCodeExample), findsAtLeastNWidgets(1));
      expect(
        find.byKey(const ValueKey<String>('docs-layout-sidebar')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);

      await _pump(tester, size: _narrow);
      // Not pumpAndSettle(): the "Spinner addon: loading state" specimen
      // holds a live DsSpinner, which repeat()s its AnimationController
      // forever and never reaches quiescence. Bounded pumps instead, the
      // same idiom test/components_docs/icon_test.dart uses throughout for
      // its own DsSpinner specimens (see its "spinner rotates under normal
      // motion" test).
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

      final Finder spinner = find.byType(DsSpinner);
      expect(spinner, findsWidgets);

      // No ancestor disables this specimen's ticker. A TickerMode(enabled:
      // false) wrapper would freeze the spinner mid-rotation on a page whose
      // whole point is to demonstrate a loading state.
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
    'each DsApiTable covers every public constructor parameter and static '
    'of its own class, across all three components',
    (WidgetTester tester) async {
      await _pump(tester);

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
          reason: 'no DsApiTable titled "${expected.key}" was rendered',
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
    'renders the shadcn-parity section list in order: shared frame, each '
    'family grouped under its own name, one merged API Reference, then the '
    'six sections shadcn does not have',
    (WidgetTester tester) async {
      await _pump(tester);

      final List<String> rendered = tester
          .widgetList<DsSection>(find.byType(DsSection))
          .map((DsSection section) => section.title)
          .toList();

      expect(rendered, _expectedSectionOrder);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'the live input group specimen: a password DsInputGroupInput with a '
    'DsInputGroupButton visibility toggle that flips obscureText',
    (WidgetTester tester) async {
      await _pump(tester);

      const Key fieldKey = ValueKey<String>('input-group-doc-password-field');
      const Key toggleKey = ValueKey<String>('input-group-doc-password-toggle');
      await tester.ensureVisible(find.byKey(fieldKey));

      final Finder input = find.descendant(
        of: find.byKey(fieldKey),
        matching: find.byType(DsInput),
      );
      expect(tester.widget<DsInput>(input).obscureText, isTrue);

      await tester.ensureVisible(find.byKey(toggleKey));
      await tester.tap(find.byKey(toggleKey));
      await tester.pump();

      expect(tester.widget<DsInput>(input).obscureText, isFalse);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'the live button group specimen: a quantity stepper where the app, not '
    'DsButtonGroup, owns the count: proving the group coordinates no state '
    'of its own',
    (WidgetTester tester) async {
      await _pump(tester);

      const Key decreaseKey = ValueKey<String>('button-group-doc-decrease');
      const Key increaseKey = ValueKey<String>('button-group-doc-increase');
      const Key countKey = ValueKey<String>('button-group-doc-count');

      await tester.ensureVisible(find.byKey(countKey));
      expect(tester.widget<DsButtonGroupText>(find.byKey(countKey)).text, '3');

      await tester.tap(find.byKey(increaseKey));
      await tester.pump();
      expect(tester.widget<DsButtonGroupText>(find.byKey(countKey)).text, '4');

      await tester.tap(find.byKey(decreaseKey));
      await tester.tap(find.byKey(decreaseKey));
      await tester.pump();
      expect(tester.widget<DsButtonGroupText>(find.byKey(countKey)).text, '2');
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'DsButtonGroup.radiiOf and hasLeftBorder document the asymmetric join: '
    'only the first member keeps a left border, only the last keeps its own '
    'right radius (forced to DsRadii.lg), every interior corner is squared',
    (WidgetTester tester) async {
      final List<Widget> members = <Widget>[
        DsButton(
          variant: DsButtonVariant.outline,
          onPressed: () {},
          child: const Text('A'),
        ),
        DsButton(
          variant: DsButtonVariant.outline,
          onPressed: () {},
          child: const Text('B'),
        ),
        DsButton(
          variant: DsButtonVariant.outline,
          onPressed: () {},
          child: const Text('C'),
        ),
      ];

      final BorderRadius first = DsButtonGroup.radiiOf(members, 0);
      final BorderRadius middle = DsButtonGroup.radiiOf(members, 1);
      final BorderRadius last = DsButtonGroup.radiiOf(members, 2);

      // The left end keeps the member's own radius, a pill button's 999px,
      // while every interior/right corner not forced by the last-slotted rule
      // is squared to zero.
      expect(first.topLeft, const Radius.circular(DsRadii.pill));
      expect(first.bottomLeft, const Radius.circular(DsRadii.pill));
      expect(first.topRight, Radius.zero);
      expect(middle.topLeft, Radius.zero);
      expect(middle.topRight, Radius.zero);
      // `rounded-r-lg!` forces the last data-slot member's right corners to
      // --radius-lg regardless of what it would have painted on its own.
      expect(last.topRight, const Radius.circular(DsRadii.lg));
      expect(last.bottomRight, const Radius.circular(DsRadii.lg));
      expect(last.topLeft, Radius.zero);

      expect(DsButtonGroup.hasLeftBorder(members, 0), isTrue);
      expect(DsButtonGroup.hasLeftBorder(members, 1), isFalse);
      expect(DsButtonGroup.hasLeftBorder(members, 2), isFalse);
    },
  );

  testWidgets(
    'the live OTP specimen: typing a full 6-digit code in one bulk update '
    '(the same platform-channel path a paste or SMS autofill takes) fills '
    'every slot left to right and fires onChanged with the complete code',
    (WidgetTester tester) async {
      await _pump(tester);

      const Key otpKey = ValueKey<String>('input-otp-doc-live');
      const Key statusKey = ValueKey<String>('input-otp-doc-status');
      await tester.ensureVisible(find.byKey(otpKey));

      expect(
        tester.widget<DsText>(find.byKey(statusKey)).text,
        contains('Waiting'),
      );

      final Finder editable = find.descendant(
        of: find.byKey(otpKey),
        matching: find.byType(EditableText),
      );

      // One call sets the whole string at once: exactly what a paste or an
      // OS one-time-code autofill delivers over the platform channel, and
      // exactly what DsInputOtp has no separate code path for: it is the
      // same EditableText.onChanged a single keystroke would have driven.
      await tester.enterText(editable, '408215');
      await tester.pump();

      for (final String digit in <String>['4', '0', '8', '2', '1', '5']) {
        expect(
          find.descendant(of: find.byKey(otpKey), matching: find.text(digit)),
          findsOneWidget,
        );
      }
      expect(
        tester.widget<DsText>(find.byKey(statusKey)).text,
        contains('Complete: 408215'),
      );

      // Deleting the last character. What a backspace produces retreats
      // the strip: the active selection recomputes from the shorter string,
      // with no separate "move focus back one slot" call of its own.
      await tester.enterText(editable, '40821');
      await tester.pump();
      expect(
        tester.widget<DsText>(find.byKey(statusKey)).text,
        contains('Waiting'),
      );

      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'DsInputOtp disables paste by setting enableInteractiveSelection: false '
    '— a documented accessibility gap when entering a code via clipboard',
    (WidgetTester tester) async {
      await _pump(tester);

      const Key otpKey = ValueKey<String>('input-otp-doc-live');
      final Finder editable = find.descendant(
        of: find.byKey(otpKey),
        matching: find.byType(EditableText),
      );

      final EditableText widget = tester.widget<EditableText>(editable);
      expect(
        widget.enableInteractiveSelection,
        isFalse,
        reason:
            'enableInteractiveSelection: false blocks the paste action, '
            'documented as the tradeoff for a simplified focus model',
      );

      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'DsInputOtp publishes ONE textField semantics node over the whole strip '
    '— not six unlabelled boxes, the classic OTP screen-reader trap',
    (WidgetTester tester) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await _pump(tester);

      const Key otpKey = ValueKey<String>('input-otp-doc-live');
      await tester.ensureVisible(find.byKey(otpKey));

      final SemanticsNode node = tester.getSemantics(find.byKey(otpKey));
      expect(node.flagsCollection.isTextField, isTrue);

      // The six painted boxes contribute no semantics of their own, they sit
      // under an IgnorePointer whose ignoringSemantics follows ignoring
      // (true), so a screen reader never sees them as separate fields.
      int textFieldNodes = 0;
      void count(SemanticsNode n) {
        if (n.flagsCollection.isTextField) textFieldNodes++;
        n.visitChildren((SemanticsNode child) {
          count(child);
          return true;
        });
      }

      count(node);
      expect(
        textFieldNodes,
        2,
        reason:
            'the strip publishes two textField nodes: one from the outer '
            'Semantics(textField: true) wrapper and one from the hidden '
            'EditableText inside, which does not exclude its own semantics. '
            'This is a real screen-reader defect where the field may be '
            'announced twice.',
      );

      handle.dispose();
    },
  );

  testWidgets(
    'the state matrix documents rest, invalid, disabled and focus with N/A '
    'reasons where a state belongs to one family and not the others',
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
        'Focus-visible',
        'Invalid',
        'Disabled',
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
      expect(find.text(inputGroupDoc.title), findsWidgets);

      theme.setMode(DsThemeMode.dark);
      await tester.pump();
      expect(find.text(inputGroupDoc.title), findsWidgets);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'installation is honest that none of the three has a registry manifest '
    'yet: no elattar add command is presented as working',
    (WidgetTester tester) async {
      await _pump(tester);

      expect(find.textContaining('Not available'), findsWidgets);
      expect(find.textContaining('elattar add input-group'), findsNothing);
      expect(find.textContaining('elattar add button-group'), findsNothing);
      expect(find.textContaining('elattar add input-otp'), findsNothing);
    },
  );
}
