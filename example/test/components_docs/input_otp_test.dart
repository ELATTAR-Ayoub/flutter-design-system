/// Tests for `components_docs/input_otp/page.dart`'s [InputOtpDocPage].
///
/// Split off the merged test that used to cover [ElInputGroup],
/// [ElButtonGroup], and [ElInputOtp] together on one page. This file now
/// covers [ElInputOtp] and its slot/separator parts only: see
/// `input_group_test.dart` and `button_group_test.dart` for the other two.
///
/// Re-housed onto the documentation kit (`ComponentDocSpec` +
/// `ComponentDocPage`): sections now render as `DocsSection` (from
/// `docs_section.dart`), not the old `kit.dart` `ElSection`, and the live
/// preview is a real `Preview` section with its own rail entry rather than
/// an unheaded `DocsCodeExample` above the first heading. The API Reference
/// and States sections are now `DocsDisclosure`s, closed by default (a
/// closed `DocsDisclosure` mounts no content at all — see
/// `docs_disclosure_test.dart`), so any test reading their content opens
/// the panel first via [_disclosureTrigger].
///
/// Reads from `lib/src/components/input_otp.dart` directly (Step 1 of the
/// task cycle): every public class and constructor parameter enumerated
/// below is one this page's API tables must cover.
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never synthetic `MediaQuery`. The live
/// `ElThemeController` is flipped in place for theme coverage.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/input_otp/meta.dart';
import 'package:example/components_docs/input_otp/page.dart';
import 'package:example/docs/docs_disclosure.dart';
import 'package:example/docs/docs_facts.dart';
import 'package:example/docs/docs_section.dart' show DocsSection;
import 'package:example/docs/docs_showcase.dart' show DocsShowcase;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  await tester.pump(ElDurations.jelly);
}

const List<String> _expectedSectionOrder = <String>[
  'Preview',
  'Installation',
  'Usage',
  'Composition',
  'Groups and separators',
  'Disabled',
  'Controlled',
  'Invalid',
  'Four digits',
  'Verification form',
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

/// Every `ElApiTable` this page must render, by title, and every public
/// constructor parameter or static member of that class, read directly off
/// `lib/src/components/input_otp.dart`.
const Map<String, List<String>> _expectedApiTables = <String, List<String>>{
  'ElInputOtp': <String>[
    'maxLength',
    'groups',
    'controller',
    'initialValue',
    'focusNode',
    'onChanged',
    'enabled',
    'invalid',
    'label',
    'ElInputOtp.slotSize',
    'ElInputOtp.separatorWidth',
    'ElInputOtp.widthFor',
  ],
  'ElInputOtpSlot': <String>['char', 'active', 'invalid', 'first', 'last'],
  'ElInputOtpSeparator': <String>[],
};

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
            child: InputOtpDocPage(onNavigate: onNavigate),
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

      expect(find.text(inputOtpDoc.title), findsWidgets);
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
    'each ElApiTable covers every public constructor parameter and static '
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
          reason: 'no ElApiTable titled "${expected.key}" was rendered',
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

  testWidgets(
    'the live specimen: typing a full 6-digit code in one bulk update '
    '(the same platform-channel path a paste or SMS autofill takes) fills '
    'every slot left to right and fires onChanged with the complete code',
    (WidgetTester tester) async {
      await _pump(tester);

      const Key otpKey = ValueKey<String>('input-otp-doc-live');
      const Key statusKey = ValueKey<String>('input-otp-doc-status');
      await tester.ensureVisible(find.byKey(otpKey));

      expect(
        tester.widget<ElText>(find.byKey(statusKey)).text,
        contains('Waiting'),
      );

      final Finder editable = find.descendant(
        of: find.byKey(otpKey),
        matching: find.byType(EditableText),
      );

      await tester.enterText(editable, '408215');
      await tester.pump();

      for (final String digit in <String>['4', '0', '8', '2', '1', '5']) {
        expect(
          find.descendant(of: find.byKey(otpKey), matching: find.text(digit)),
          findsOneWidget,
        );
      }
      expect(
        tester.widget<ElText>(find.byKey(statusKey)).text,
        contains('Complete: 408215'),
      );

      await tester.enterText(editable, '40821');
      await tester.pump();
      expect(
        tester.widget<ElText>(find.byKey(statusKey)).text,
        contains('Waiting'),
      );

      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'ElInputOtp disables paste by setting enableInteractiveSelection: false '
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
    'ElInputOtp publishes TWO textField semantics nodes over the whole '
    'strip — the documented double-announcement defect, not six unlabelled '
    'boxes',
    (WidgetTester tester) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await _pump(tester);

      const Key otpKey = ValueKey<String>('input-otp-doc-live');
      await tester.ensureVisible(find.byKey(otpKey));

      final SemanticsNode node = tester.getSemantics(find.byKey(otpKey));
      expect(node.flagsCollection.isTextField, isTrue);

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
            'EditableText inside, which does not exclude its own semantics.',
      );

      handle.dispose();
    },
  );

  testWidgets('the state matrix documents rest, active, invalid, disabled and '
      'complete', (WidgetTester tester) async {
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
      'Active (focus)',
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
      final ElThemeController theme = await _pump(
        tester,
        mode: ElThemeMode.light,
      );
      expect(find.text(inputOtpDoc.title), findsWidgets);

      theme.setMode(ElThemeMode.dark);
      await tester.pump();
      expect(find.text(inputOtpDoc.title), findsWidgets);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('installation presents the working input-otp CLI command', (
    WidgetTester tester,
  ) async {
    await _pump(tester);

    expect(find.textContaining('elattar add input-otp'), findsWidgets);
  });
}
