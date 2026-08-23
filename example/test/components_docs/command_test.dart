/// Tests for `components_docs/command/meta.dart` and
/// `components_docs/command/page.dart`: the paired public documentation
/// page for [DsCommand] and [DsCombobox].
///
/// Both are anchored/inline "filter as you type" surfaces documented on one
/// page: the same one-entry-two-components shape `sheet/page.dart` already
/// uses for Sheet and Drawer. `DsCombobox` mounts its popup through
/// [DsPopover] (an [OverlayPortal]), so the live specimen needs a real
/// [Overlay]: the harness wraps the page in a [MaterialApp], the same fix
/// `popover_test.dart` and `sheet_test.dart` needed. `DsCommand` is
/// deliberately **not** an overlay: it has nothing to anchor to and is
/// always mounted inline: so its own specimen needs no such wrapping, but
/// the shared harness below still supplies one for the combobox specimen
/// living beside it on the same page.
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never synthetic `MediaQuery`. Theme
/// coverage uses one live [DsThemeController] flipped in place.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/command/meta.dart';
import 'package:example/components_docs/command/page.dart';
import 'package:example/kit.dart' show DsSection;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const Size _wide = Size(1440, 900);
const Size _narrow = Size(390, 844);

const Key _commandSpecimenKey = ValueKey<String>(
  'command-doc-command-specimen',
);
const Key _comboboxSpecimenKey = ValueKey<String>(
  'command-doc-combobox-specimen',
);

Future<DsThemeController> _pumpCommandDoc(
  WidgetTester tester, {
  ValueChanged<String>? onNavigate,
  Size size = _wide,
  DsThemeMode mode = DsThemeMode.dark,
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
            child: CommandDocPage(onNavigate: onNavigate),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  return theme;
}

/// The single search field inside the live command palette specimen.
Finder _commandInput() => find.descendant(
  of: find.byKey(_commandSpecimenKey),
  matching: find.byType(EditableText),
);

/// The single text field inside the live combobox specimen.
Finder _comboboxInput() => find.descendant(
  of: find.byKey(_comboboxSpecimenKey),
  matching: find.byType(DsInputGroupInput),
);

/// The shadcn-parity section order (worker brief, `command` component,
/// which covers two shadcn counterparts: `command` and `combobox`). The live
/// demo sits unheaded above Installation, so it carries no entry here.
/// Composition and Filtering are shared, cross-cutting sections; Shortcuts,
/// Groups, Scrollable and In a panel are Command's own; Invalid and Disabled
/// are Combobox's own; the trailing six are this package's fixed extras.
const List<String> _expectedSectionHeadings = <String>[
  'Installation',
  'Usage',
  'Composition',
  'Filtering',
  'Shortcuts',
  'Groups',
  'Scrollable',
  'In a panel',
  'Invalid',
  'Disabled',
  'API Reference',
  'States',
  'Accessibility',
  'Responsive',
  'Dependencies',
  'Theming',
  'Source',
];

void main() {
  group('meta', () {
    test('commandDoc names the real public API surface of both components', () {
      expect(commandDoc.name, 'command');
      expect(commandDoc.title, isNotEmpty);
      expect(commandDoc.route, '/components/command');
      expect(commandDoc.command, 'elattar add command');
      expect(commandDoc.sourcePath, 'lib/src/components/command.dart');
      expect(comboboxSourcePath, 'lib/src/components/combobox.dart');
      expect(
        commandDoc.exports,
        containsAll(<String>[
          'DsCommand',
          'DsCommandItem',
          'DsCommandGroup',
          'dsCommandScore',
          'DsCombobox',
          'DsComboboxItem',
          'dsCollatorContains',
        ]),
      );
      // Short description: one sentence, no trailing ellipsis.
      expect(commandDoc.description, isNot(contains('..')));
      expect(commandDoc.description.trim(), commandDoc.description);
      // The expanded, decision-guidance description is a distinct constant
      // that names both jobs, not a restatement of the short one.
      expect(commandExpandedDescription, isNot(equals(commandDoc.description)));
      expect(commandExpandedDescription.trim(), commandExpandedDescription);
      expect(commandExpandedDescription, contains('anchor'));
      expect(commandExpandedDescription, contains('Combobox'));
      expect(commandExpandedDescription, contains('Command'));
    });
  });

  group('rendered page', () {
    testWidgets('renders the article and both live specimens', (
      WidgetTester tester,
    ) async {
      await _pumpCommandDoc(tester);

      expect(
        find.byKey(const ValueKey<String>('command-doc-article')),
        findsOneWidget,
      );
      expect(find.byKey(_commandSpecimenKey), findsOneWidget);
      expect(find.byKey(_comboboxSpecimenKey), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'renders the shadcn-parity section headings in order, with no '
      'heading before Installation and no Overview, Preview or Variants '
      'heading left over from the old shape',
      (WidgetTester tester) async {
        await _pumpCommandDoc(tester);

        final List<String> headings = tester
            .widgetList<DsText>(find.byType(DsText))
            .where((DsText text) => text.spec == DsType.h3)
            .map((DsText text) => text.text)
            .toList();

        expect(headings, _expectedSectionHeadings);

        // Section headings only: DocsCodeExample renders its own "Preview"
        // tab label as free text, so a plain find.text('Preview') finds that
        // affordance rather than a leftover heading. Read the mounted
        // DsSection titles instead, which are immune to that collision.
        final List<String> sectionTitles = tester
            .widgetList<DsSection>(find.byType(DsSection))
            .map((DsSection section) => section.title)
            .toList();
        expect(sectionTitles, isNot(contains('Overview')));
        expect(sectionTitles, isNot(contains('Preview')));
        expect(sectionTitles, isNot(contains('Variants')));
      },
    );

    testWidgets(
      'the API tables cover every constructor parameter of DsCommand, '
      'DsCommandItem, DsCommandGroup and dsCommandScore',
      (WidgetTester tester) async {
        await _pumpCommandDoc(tester);

        for (final String name in <String>[
          // DsCommand
          'groups', 'placeholder', 'emptyLabel', 'controller', 'focusNode',
          'shouldFilter', 'filter', 'loop', 'vimBindings', 'label',
          'onValueChanged', 'inDialog',
          // DsCommandItem
          'icon', 'lucideIcon', 'iconTone', 'subtitle', 'meta', 'shortcut',
          'value', 'keywords', 'enabled', 'onSelect',
          // DsCommandGroup
          'items', 'heading', 'separatorBefore',
          // dsCommandScore(string, abbreviation, [aliases])
          'string', 'abbreviation', 'aliases',
        ]) {
          expect(
            find.text(name),
            findsAtLeastNWidgets(1),
            reason: 'Parameter "$name" missing from a Command API table',
          );
        }
      },
    );

    testWidgets(
      'the API tables cover every constructor parameter of DsCombobox, '
      'DsComboboxItem and dsCollatorContains',
      (WidgetTester tester) async {
        await _pumpCommandDoc(tester);

        for (final String name in <String>[
          // DsCombobox
          'items', 'value', 'onChanged', 'placeholder', 'emptyLabel',
          'enabled', 'invalid', 'focusNode', 'label', 'hint', 'filter',
          // dsCollatorContains(label, query)
          'query',
        ]) {
          expect(
            find.text(name),
            findsAtLeastNWidgets(1),
            reason: 'Parameter "$name" missing from a Combobox API table',
          );
        }
      },
    );

    testWidgets(
      'installation says plainly that neither CLI command works yet',
      (WidgetTester tester) async {
        await _pumpCommandDoc(tester);

        expect(find.textContaining('Not available yet'), findsWidgets);
        expect(find.textContaining('elattar add command'), findsNothing);
        expect(find.textContaining('elattar add combobox'), findsNothing);
      },
    );

    testWidgets(
      'the filtering section documents both real algorithms with a worked example',
      (WidgetTester tester) async {
        await _pumpCommandDoc(tester);

        // Command's fuzzy scorer: the source's own measured worked example.
        expect(find.textContaining('Go to Stash'), findsWidgets);
        expect(find.textContaining('0.891'), findsWidgets);
        // Combobox's plain substring matcher.
        expect(find.textContaining('contains'), findsWidgets);
        expect(find.textContaining('Golden Rift'), findsWidgets);
      },
    );

    testWidgets(
      'accessibility plainly documents the missing live region and the '
      'combobox highlight gap',
      (WidgetTester tester) async {
        await _pumpCommandDoc(tester);

        expect(find.textContaining('live region'), findsWidgets);
        expect(find.textContaining('Known gap'), findsWidgets);
      },
    );

    testWidgets(
      'navigating previous fires onNavigate with the already-routed neighbour',
      (WidgetTester tester) async {
        String? destination;
        await _pumpCommandDoc(
          tester,
          onNavigate: (String route) => destination = route,
        );

        await tester.ensureVisible(find.text('Alert Dialog').first);
        await tester.tap(find.text('Alert Dialog').first);
        expect(destination, '/components/alert-dialog');
      },
    );
  });

  group('live specimen: command palette filters and re-sorts as you type', () {
    testWidgets('typing narrows the list and the empty state appears', (
      WidgetTester tester,
    ) async {
      await _pumpCommandDoc(tester);

      final Finder input = _commandInput();
      await tester.ensureVisible(input);
      expect(find.text('Eclipse Vault'), findsOneWidget);

      await tester.enterText(input, 'zzzzzznomatch');
      await tester.pump();

      expect(find.text('Nothing matches that.'), findsOneWidget);
      expect(find.text('Eclipse Vault'), findsNothing);
      expect(find.text('Open Wallet'), findsNothing);
    });

    testWidgets(
      'typing "t" re-sorts Go to Stash above Open Wallet, matching the '
      'ported cmdk scorer',
      (WidgetTester tester) async {
        await _pumpCommandDoc(tester);

        final Finder input = _commandInput();
        await tester.ensureVisible(input);

        // Source order, before anything is typed: Open Wallet above Go to
        // Stash.
        expect(
          tester.getTopLeft(find.text('Open Wallet')).dy,
          lessThan(tester.getTopLeft(find.text('Go to Stash')).dy),
        );

        await tester.enterText(input, 't');
        await tester.pump();

        expect(find.text('Open Wallet'), findsOneWidget);
        expect(find.text('Go to Stash'), findsOneWidget);
        expect(
          tester.getTopLeft(find.text('Go to Stash')).dy,
          lessThan(tester.getTopLeft(find.text('Open Wallet')).dy),
        );
      },
    );

    testWidgets('Enter commits the highlighted row and fires its onSelect', (
      WidgetTester tester,
    ) async {
      await _pumpCommandDoc(tester);

      final Finder input = _commandInput();
      await tester.ensureVisible(input);
      expect(find.textContaining('Nothing picked yet'), findsOneWidget);

      await tester.tap(input);
      await tester.pump();
      // cmdk selects the first item once the items register, before anyone
      // has touched anything: Eclipse Vault is the first row of the first
      // group.
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();

      expect(find.textContaining('Last picked: Eclipse Vault'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group(
    'live specimen: combobox opens, filters, and selects a real value',
    () {
      testWidgets('tapping the input opens the popup showing every card set', (
        WidgetTester tester,
      ) async {
        await _pumpCommandDoc(tester);

        final Finder input = _comboboxInput();
        await tester.ensureVisible(input);
        expect(find.text('Mystic Surge'), findsNothing);

        await tester.tap(input);
        await tester.pump();
        await tester.pump(DsDurations.overlay);
        await tester.pump();

        expect(find.text('Mystic Surge'), findsOneWidget);
        expect(find.text('Eclipse Vault'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('typing narrows by substring, not by prefix', (
        WidgetTester tester,
      ) async {
        await _pumpCommandDoc(tester);

        final Finder input = _comboboxInput();
        await tester.ensureVisible(input);
        await tester.tap(input);
        await tester.pump();
        await tester.pump(DsDurations.overlay);
        await tester.pump();

        // "rift" is a mid-word substring of "Golden Rift", not a prefix.
        await tester.enterText(input, 'rift');
        await tester.pump();

        expect(find.text('Golden Rift'), findsOneWidget);
        expect(
          find.descendant(
            of: find.byType(DsPopoverSurface),
            matching: find.text('Eclipse Vault'),
          ),
          findsNothing,
        );
        expect(
          find.descendant(
            of: find.byType(DsPopoverSurface),
            matching: find.text('Mystic Surge'),
          ),
          findsNothing,
        );
      });

      testWidgets('tapping a row commits the value and closes the popup', (
        WidgetTester tester,
      ) async {
        await _pumpCommandDoc(tester);

        final Finder input = _comboboxInput();
        await tester.ensureVisible(input);
        await tester.tap(input);
        await tester.pump();
        await tester.pump(DsDurations.overlay);
        await tester.pump();

        await tester.tap(find.text('Golden Rift'));
        await tester.pump();
        await tester.pump(DsDurations.overlay);
        await tester.pump();

        expect(find.textContaining('Selected: Golden Rift'), findsOneWidget);
        // The popup is closed: a sibling row is no longer in the tree.
        expect(find.text('Mystic Surge'), findsNothing);
        expect(tester.takeException(), isNull);
      });
    },
  );

  group('viewport widths', () {
    testWidgets('a wide viewport exposes the table of contents', (
      WidgetTester tester,
    ) async {
      await _pumpCommandDoc(tester, size: _wide);

      expect(
        find.byKey(const ValueKey<String>('docs-layout-toc')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('command-doc-article')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('a narrow viewport drops to the anchor strip', (
      WidgetTester tester,
    ) async {
      await _pumpCommandDoc(tester, size: _narrow);

      expect(
        find.byKey(const ValueKey<String>('docs-layout-anchor-strip')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('command-doc-article')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });
  });

  group('both themes', () {
    testWidgets('renders on light', (WidgetTester tester) async {
      await _pumpCommandDoc(tester, mode: DsThemeMode.light);
      expect(find.byKey(_commandSpecimenKey), findsOneWidget);
      expect(find.byKey(_comboboxSpecimenKey), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders on dark', (WidgetTester tester) async {
      await _pumpCommandDoc(tester, mode: DsThemeMode.dark);
      expect(find.byKey(_commandSpecimenKey), findsOneWidget);
      expect(find.byKey(_comboboxSpecimenKey), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('flipping the theme in place keeps the page intact', (
      WidgetTester tester,
    ) async {
      final DsThemeController theme = await _pumpCommandDoc(
        tester,
        mode: DsThemeMode.dark,
      );
      expect(find.byKey(_comboboxSpecimenKey), findsOneWidget);

      theme.setMode(DsThemeMode.light);
      await tester.pump();

      expect(find.byKey(_commandSpecimenKey), findsOneWidget);
      expect(find.byKey(_comboboxSpecimenKey), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
