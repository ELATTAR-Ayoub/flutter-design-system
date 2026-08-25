/// Tests for `components_docs/combobox/meta.dart` and
/// `components_docs/combobox/page.dart`: the public documentation page for
/// [ElCombobox] alone.
///
/// Re-housed onto the kit alongside the page: the section-order test now
/// reads `DocsSection.id` (the kit's own section widget) instead of
/// `ElSection`'s title, and the API-table / state-matrix tests open the
/// relevant `DocsDisclosure` first — closed by default in the new kit.
///
/// [ElCombobox] mounts its list through a [ElPopover], which is an
/// [OverlayPortal], so every specimen on this page needs a real [Overlay]
/// above it: the [MaterialApp] in the harness below is what supplies one.
/// Without it the popup silently never opens and every "it filters"
/// assertion would pass against an untested path.
///
/// The popup's entrance is a real animation, so an open is pumped by
/// [ElDurations.overlay] rather than settled: `pumpAndSettle` is never used
/// here.
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never synthetic `MediaQuery`. Theme
/// coverage uses one live [ElThemeController] flipped in place.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/combobox/meta.dart';
import 'package:example/components_docs/combobox/page.dart';
import 'package:example/docs/docs_disclosure.dart';
import 'package:example/docs/docs_section.dart' show DocsSection;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const Size _wide = Size(1440, 900);
const Size _narrow = Size(390, 844);

const Key _comboboxSpecimenKey = ValueKey<String>(
  'combobox-doc-combobox-specimen',
);
const Key _invalidSpecimenKey = ValueKey<String>('combobox-example:invalid');
const Key _disabledSpecimenKey = ValueKey<String>('combobox-example:disabled');

/// The house-shape section order this page must render, top to bottom.
const List<String> _expectedSectionIds = <String>[
  'preview',
  'install',
  'usage',
  'composition',
  'filtering',
  'invalid',
  'disabled',
  'api',
  'states',
  'accessibility',
  'keyboard',
  'responsive',
  'dependencies',
  'theming',
  'source',
];

/// Every named constructor parameter `ElCombobox` declares, excluding `key`.
const List<String> _comboboxParams = <String>[
  'items',
  'value',
  'onChanged',
  'placeholder',
  'emptyLabel',
  'enabled',
  'invalid',
  'focusNode',
  'label',
  'hint',
  'filter',
];

/// Every public static `ElCombobox` exposes.
const List<String> _comboboxStatics = <String>[
  'ElCombobox.popupOffset',
  'ElCombobox.popupOvershoot',
  'ElCombobox.listMaxHeight',
  'ElCombobox.itemHeight',
  'ElCombobox.emptyHeight',
];

/// The single `DocsDisclosure` whose title is [title], matching
/// `checkbox_test.dart`'s own convention.
Finder _disclosureTrigger(String title) => find.descendant(
  of: find.byWidgetPredicate(
    (Widget widget) => widget is DocsDisclosure && widget.title == title,
  ),
  matching: find.byKey(DocsDisclosure.triggerKey),
);

Future<ElThemeController> _pumpComboboxDoc(
  WidgetTester tester, {
  ValueChanged<String>? onNavigate,
  Size size = _wide,
  ElThemeMode mode = ElThemeMode.dark,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final ElThemeController theme = ElThemeController(mode: mode);
  addTearDown(theme.dispose);

  await tester.pumpWidget(
    ElTheme(
      controller: theme,
      // MaterialApp, not a bare ElTheme: the popup is an OverlayPortal and
      // needs a real Overlay ancestor or it never mounts.
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: SingleChildScrollView(
            child: ComboboxDocPage(onNavigate: onNavigate),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  return theme;
}

/// The text field inside the live combobox specimen at the top of the page.
Finder _comboboxInput() => find.descendant(
  of: find.byKey(_comboboxSpecimenKey),
  matching: find.byType(ElInputGroupInput),
);

/// Opens the live specimen's popup and lets its entrance run.
Future<void> _openPopup(WidgetTester tester) async {
  final Finder input = _comboboxInput();
  await tester.ensureVisible(input);
  await tester.tap(input);
  await tester.pump();
  // Never pumpAndSettle: the popup entrance is a real animation and this is
  // the duration it runs for.
  await tester.pump(ElDurations.overlay);
  await tester.pump();
}

void main() {
  group('meta', () {
    test('comboboxDoc names the real public API surface of ElCombobox', () {
      expect(comboboxDoc.name, 'combobox');
      expect(comboboxDoc.title, 'Combobox');
      expect(comboboxDoc.route, '/components/combobox');
      expect(comboboxDoc.command, 'elattar add combobox');
      expect(comboboxDoc.sourcePath, 'lib/src/components/combobox.dart');
      expect(comboboxDoc.exports, <String>[
        'ElCombobox',
        'ElComboboxItem',
        'elCollatorContains',
      ]);
      // The split: nothing command-shaped is claimed by this entry.
      expect(comboboxDoc.exports, isNot(contains('ElCommand')));
      expect(comboboxDoc.exports, isNot(contains('elCommandScore')));
      // Short description: one sentence, no trailing ellipsis.
      expect(comboboxDoc.description, isNot(contains('..')));
      expect(comboboxDoc.description.trim(), comboboxDoc.description);
    });

    test('dependencies match the combobox registry manifest', () {
      expect(comboboxDoc.dependencies, <String>[
        'field',
        'icon',
        'input-group',
        'popover',
        'select',
        'source-foundation',
      ]);
      // command.dart imports input.dart for its search field; this file
      // reaches for ElInputGroupInput instead.
      expect(comboboxDoc.dependencies, isNot(contains('input')));
    });
  });

  group('rendered page', () {
    testWidgets('renders the article and all three live specimens', (
      WidgetTester tester,
    ) async {
      await _pumpComboboxDoc(tester);

      expect(
        find.byKey(const ValueKey<String>('combobox-doc-article')),
        findsOneWidget,
      );
      expect(find.byKey(_comboboxSpecimenKey), findsOneWidget);
      expect(find.byKey(_invalidSpecimenKey), findsOneWidget);
      expect(find.byKey(_disabledSpecimenKey), findsOneWidget);
      expect(find.byType(ElCombobox<String>), findsNWidgets(3));
      expect(tester.takeException(), isNull);
    });

    testWidgets('sections render in the house-shape order, top to bottom', (
      WidgetTester tester,
    ) async {
      await _pumpComboboxDoc(tester);

      final List<String> ids = tester
          .widgetList<DocsSection>(find.byType(DocsSection))
          .map((DocsSection section) => section.id)
          .toList();

      expect(ids, _expectedSectionIds);
    });

    testWidgets('nothing command-shaped leaked onto this page', (
      WidgetTester tester,
    ) async {
      await _pumpComboboxDoc(tester);

      expect(find.byType(ElCommand), findsNothing);
      expect(find.text('ElCommand'), findsNothing);
      expect(find.text('ElCommandItem'), findsNothing);
      expect(
        find.text('elCommandScore(string, abbreviation, [aliases]) → double'),
        findsNothing,
      );
      final List<String> ids = tester
          .widgetList<DocsSection>(find.byType(DocsSection))
          .map((DocsSection section) => section.id)
          .toList();
      expect(ids, isNot(contains('shortcuts')));
      expect(ids, isNot(contains('groups')));
      expect(ids, isNot(contains('in-a-panel')));
    });

    testWidgets(
      'the API tables cover every parameter, static and top-level function '
      'combobox.dart declares',
      (WidgetTester tester) async {
        await _pumpComboboxDoc(tester);

        final Finder apiTrigger = _disclosureTrigger('API Reference');
        await tester.ensureVisible(apiTrigger);
        await tester.tap(apiTrigger);
        await tester.pump();
        await tester.pump(ElDurations.jelly);

        for (final String name in <String>[
          ..._comboboxParams,
          ..._comboboxStatics,
          // ElComboboxItem<T> = ElSelectOption<T>: value, label, enabled are
          // already in _comboboxParams; the typedef row names itself.
          'ElComboboxItem<T>',
          // elCollatorContains(label, query)
          'query',
          'returns',
        ]) {
          expect(
            find.text(name),
            findsAtLeastNWidgets(1),
            reason: 'Member "$name" missing from an API table',
          );
        }

        // One table per exported symbol. findsAtLeastNWidgets, not
        // findsOneWidget: each of these is also a nested TOC entry at this
        // width, so a bare find.text matches twice.
        for (final String title in <String>[
          'ElCombobox<T>',
          'ElCombobox static helpers',
          'ElComboboxItem<T> (= ElSelectOption<T>)',
          'elCollatorContains(label, query) → bool',
        ]) {
          expect(
            find.text(title),
            findsAtLeastNWidgets(1),
            reason: 'API table "$title" missing',
          );
        }
      },
    );

    testWidgets(
      'the API tables carry the REAL declared types and the corrected hint '
      'behaviour',
      (WidgetTester tester) async {
        await _pumpComboboxDoc(tester);

        final Finder apiTrigger = _disclosureTrigger('API Reference');
        await tester.ensureVisible(apiTrigger);
        await tester.tap(apiTrigger);
        await tester.pump();
        await tester.pump(ElDurations.jelly);

        expect(find.text('List<ElComboboxItem<T>>'), findsAtLeastNWidgets(1));
        expect(find.text('ValueChanged<T>?'), findsAtLeastNWidgets(1));
        expect(
          find.text('bool Function(String label, String query)?'),
          findsAtLeastNWidgets(1),
        );
        expect(find.text('typedef = ElSelectOption<T>'), findsOneWidget);
        // The old merged table called hint "helper text under the field". It
        // is an accessible description only and is never painted.
        expect(find.textContaining('never painted'), findsAtLeastNWidgets(1));
      },
    );

    testWidgets('installation shows the shipped registry command', (
      WidgetTester tester,
    ) async {
      await _pumpComboboxDoc(tester);

      expect(find.textContaining('elattar add combobox'), findsWidgets);
    });

    testWidgets(
      'the filtering section documents the real matcher and its divergence',
      (WidgetTester tester) async {
        await _pumpComboboxDoc(tester);

        expect(find.textContaining('elCollatorContains'), findsWidgets);
        expect(find.textContaining('substring'), findsWidgets);
        expect(find.textContaining('DIVERGENCE'), findsWidgets);
      },
    );

    testWidgets(
      'accessibility plainly documents the missing live region and the '
      'no-way-back-to-empty gap',
      (WidgetTester tester) async {
        await _pumpComboboxDoc(tester);

        final Finder a11yTrigger = _disclosureTrigger('Accessibility');
        await tester.ensureVisible(a11yTrigger);
        await tester.tap(a11yTrigger);
        await tester.pump();
        await tester.pump(ElDurations.jelly);

        expect(find.textContaining('live region'), findsWidgets);
        expect(find.textContaining('Known gap'), findsWidgets);
      },
    );

    testWidgets(
      'the skipped shadcn capabilities are named rather than silently '
      'dropped',
      (WidgetTester tester) async {
        await _pumpComboboxDoc(tester);

        expect(find.textContaining('Clear Button'), findsWidgets);
        expect(find.textContaining('Auto Highlight'), findsWidgets);
      },
    );

    testWidgets(
      'navigating previous fires onNavigate with the split-off sibling',
      (WidgetTester tester) async {
        String? destination;
        await _pumpComboboxDoc(
          tester,
          onNavigate: (String route) => destination = route,
        );

        await tester.ensureVisible(find.text('Command').first);
        await tester.tap(find.text('Command').first);
        expect(destination, '/components/command');
      },
    );
  });

  group('live specimen: the field opens, filters, and commits a value', () {
    testWidgets('tapping the input opens the popup showing every card set', (
      WidgetTester tester,
    ) async {
      await _pumpComboboxDoc(tester);

      expect(find.text('Mystic Surge'), findsNothing);

      await _openPopup(tester);

      expect(find.text('Mystic Surge'), findsOneWidget);
      expect(find.text('Golden Rift'), findsOneWidget);
      expect(find.text('Eclipse Vault'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('typing narrows by substring, not by prefix', (
      WidgetTester tester,
    ) async {
      await _pumpComboboxDoc(tester);
      await _openPopup(tester);

      // "rift" is a mid-word substring of "Golden Rift", not a prefix.
      await tester.enterText(_comboboxInput(), 'rift');
      await tester.pump();

      expect(find.text('Golden Rift'), findsOneWidget);
      for (final String gone in <String>[
        'Mystic Surge',
        'Shadow Core',
        'Eclipse Vault',
      ]) {
        expect(
          find.descendant(
            of: find.byType(ElPopoverSurface),
            matching: find.text(gone),
          ),
          findsNothing,
          reason: '"$gone" should not survive the query "rift"',
        );
      }
    });

    testWidgets('a query nothing matches shows the empty row', (
      WidgetTester tester,
    ) async {
      await _pumpComboboxDoc(tester);
      await _openPopup(tester);

      await tester.enterText(_comboboxInput(), 'zzzzzznomatch');
      await tester.pump();

      expect(find.text('No set by that name.'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(ElPopoverSurface),
          matching: find.text('Golden Rift'),
        ),
        findsNothing,
      );
    });

    testWidgets('tapping a row commits the value and closes the popup', (
      WidgetTester tester,
    ) async {
      await _pumpComboboxDoc(tester);
      await _openPopup(tester);

      await tester.tap(find.text('Golden Rift'));
      await tester.pump();
      await tester.pump(ElDurations.overlay);
      await tester.pump();

      expect(find.textContaining('Selected: Golden Rift'), findsOneWidget);
      // The popup is closed: a sibling row is no longer in the tree.
      expect(find.text('Mystic Surge'), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Escape closes the popup without committing anything', (
      WidgetTester tester,
    ) async {
      await _pumpComboboxDoc(tester);
      await _openPopup(tester);
      expect(find.text('Mystic Surge'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();
      await tester.pump(ElDurations.overlay);
      await tester.pump();

      expect(find.text('Mystic Surge'), findsNothing);
      expect(find.textContaining('Nothing selected yet'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('invalid and disabled specimens are real, not labelled', () {
    testWidgets('the invalid specimen actually carries invalid: true', (
      WidgetTester tester,
    ) async {
      await _pumpComboboxDoc(tester);

      final ElCombobox<String> invalid = tester.widget<ElCombobox<String>>(
        find.descendant(
          of: find.byKey(_invalidSpecimenKey),
          matching: find.byType(ElCombobox<String>),
        ),
      );
      expect(invalid.invalid, isTrue);
      expect(invalid.onChanged, isNotNull);
      // The message is the surrounding field's, not the control's.
      expect(find.text('Pick a card set to continue.'), findsOneWidget);
    });

    testWidgets(
      'the disabled specimen actually carries a null onChanged, and its '
      'popup never opens',
      (WidgetTester tester) async {
        await _pumpComboboxDoc(tester);

        final Finder specimen = find.byKey(_disabledSpecimenKey);
        final ElCombobox<String> disabled = tester.widget<ElCombobox<String>>(
          find.descendant(
            of: specimen,
            matching: find.byType(ElCombobox<String>),
          ),
        );
        expect(disabled.onChanged, isNull);

        final Finder input = find.descendant(
          of: specimen,
          matching: find.byType(ElInputGroupInput),
        );
        await tester.ensureVisible(input);
        await tester.tap(input, warnIfMissed: false);
        await tester.pump();
        await tester.pump(ElDurations.overlay);
        await tester.pump();

        // No popup mounted anywhere on the page.
        expect(find.byType(ElPopoverSurface), findsNothing);
        expect(tester.takeException(), isNull);
      },
    );
  });

  group('viewport widths', () {
    testWidgets('a wide viewport exposes the table of contents', (
      WidgetTester tester,
    ) async {
      await _pumpComboboxDoc(tester, size: _wide);

      expect(
        find.byKey(const ValueKey<String>('docs-layout-toc')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('combobox-doc-article')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('a narrow viewport drops to the anchor strip', (
      WidgetTester tester,
    ) async {
      await _pumpComboboxDoc(tester, size: _narrow);

      expect(
        find.byKey(const ValueKey<String>('docs-layout-anchor-strip')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('combobox-doc-article')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });
  });

  group('both themes', () {
    testWidgets('renders on light', (WidgetTester tester) async {
      await _pumpComboboxDoc(tester, mode: ElThemeMode.light);
      expect(find.byKey(_comboboxSpecimenKey), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders on dark', (WidgetTester tester) async {
      await _pumpComboboxDoc(tester, mode: ElThemeMode.dark);
      expect(find.byKey(_comboboxSpecimenKey), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('flipping the theme in place keeps every specimen', (
      WidgetTester tester,
    ) async {
      final ElThemeController theme = await _pumpComboboxDoc(
        tester,
        mode: ElThemeMode.dark,
      );
      final ElThemeData dark = ElTheme.of(
        tester.element(
          find.byKey(const ValueKey<String>('combobox-doc-article')),
        ),
      );

      theme.setMode(ElThemeMode.light);
      await tester.pump();

      final ElThemeData light = ElTheme.of(
        tester.element(
          find.byKey(const ValueKey<String>('combobox-doc-article')),
        ),
      );
      expect(light.background, isNot(dark.background));
      expect(light.foreground, isNot(dark.foreground));

      expect(find.byKey(_comboboxSpecimenKey), findsOneWidget);
      expect(find.byKey(_invalidSpecimenKey), findsOneWidget);
      expect(find.byKey(_disabledSpecimenKey), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
