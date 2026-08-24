/// Tests for `components_docs/command/meta.dart` and
/// `components_docs/command/page.dart`: the public documentation page for
/// [ElCommand] alone.
///
/// **Trimmed for the split.** This file used to cover one page documenting
/// both [ElCommand] and [ElCombobox]. `ElCombobox` now has its own page and
/// its own `combobox_test.dart`; every combobox assertion moved there, and
/// the ones left here assert it is *gone* from this page rather than
/// re-testing it.
///
/// [ElCommand] is deliberately **not** an overlay: it has nothing to anchor
/// to and is always mounted inline, so its specimen needs no [Overlay] to
/// work. The harness below still supplies a [MaterialApp] for the ordinary
/// reasons a docs page wants one (directionality, media query, text
/// selection), not to make the palette open.
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never synthetic `MediaQuery`. Theme
/// coverage uses one live [ElThemeController] flipped in place. Never
/// `pumpAndSettle`: nothing on this page loops, and a single `pump` is the
/// habit that keeps it that way.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/command/meta.dart';
import 'package:example/components_docs/command/page.dart';
import 'package:example/kit.dart' show ElSection;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const Size _wide = Size(1440, 900);
const Size _narrow = Size(390, 844);

const Key _commandSpecimenKey = ValueKey<String>(
  'command-doc-command-specimen',
);

Future<ElThemeController> _pumpCommandDoc(
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

/// The section order this page promises, after the split.
///
/// The live demo sits unheaded above Installation, so it carries no entry.
/// Composition, Filtering, Shortcuts, Groups, Scrollable and In a panel are
/// Command's own; API Reference is last of those; the trailing six are this
/// package's fixed extras. Nothing combobox-shaped survives.
const List<String> _expectedSectionTitles = <String>[
  'Installation',
  'Usage',
  'Composition',
  'Filtering',
  'Shortcuts',
  'Groups',
  'Scrollable',
  'In a panel',
  'API Reference',
  'States',
  'Accessibility',
  'Responsive',
  'Dependencies',
  'Theming',
  'Source',
];

/// Every named constructor parameter `ElCommand` declares, excluding `key`.
const List<String> _commandParams = <String>[
  'groups',
  'placeholder',
  'emptyLabel',
  'controller',
  'focusNode',
  'shouldFilter',
  'filter',
  'loop',
  'vimBindings',
  'label',
  'onValueChanged',
  'inDialog',
];

/// Every named constructor parameter `ElCommandItem` declares, plus the
/// derived `searchValue` getter the matcher actually reads.
const List<String> _commandItemMembers = <String>[
  'label',
  'icon',
  'lucideIcon',
  'iconTone',
  'subtitle',
  'meta',
  'shortcut',
  'value',
  'keywords',
  'enabled',
  'onSelect',
  'searchValue',
];

/// Every named constructor parameter `ElCommandGroup` declares.
const List<String> _commandGroupParams = <String>[
  'items',
  'heading',
  'separatorBefore',
];

/// Every public static `ElCommand` exposes.
const List<String> _commandStatics = <String>[
  'ElCommand.padding',
  'ElCommand.listMaxHeight',
  'ElCommand.inputHeight',
  'ElCommand.inputFillAlpha',
  'ElCommand.searchGlyphOpacity',
  'ElCommand.disabledOpacity',
  'ElCommand.itemHeight',
  'ElCommand.headingHeight',
  'ElCommand.emptyHeight',
  'ElCommand.sortsGroups',
];

void main() {
  group('meta', () {
    test('commandDoc names the real public API surface of ElCommand', () {
      expect(commandDoc.name, 'command');
      expect(commandDoc.title, 'Command');
      expect(commandDoc.route, '/components/command');
      expect(commandDoc.command, 'elattar add command');
      expect(commandDoc.sourcePath, 'lib/src/components/command.dart');
      expect(commandDoc.exports, <String>[
        'ElCommand',
        'ElCommandItem',
        'ElCommandGroup',
        'elCommandScore',
      ]);
      // The split: nothing combobox-shaped is claimed by this entry any more.
      expect(commandDoc.exports, isNot(contains('ElCombobox')));
      expect(commandDoc.exports, isNot(contains('ElComboboxItem')));
      expect(commandDoc.exports, isNot(contains('elCollatorContains')));
      // Short description: one sentence, no trailing ellipsis.
      expect(commandDoc.description, isNot(contains('..')));
      expect(commandDoc.description.trim(), commandDoc.description);
    });

    test('dependencies match the command registry manifest', () {
      expect(commandDoc.dependencies, <String>[
        'icon',
        'input',
        'input-group',
        'source-foundation',
      ]);
    });
  });

  group('rendered page', () {
    testWidgets('renders the article and the live palette', (
      WidgetTester tester,
    ) async {
      await _pumpCommandDoc(tester);

      expect(
        find.byKey(const ValueKey<String>('command-doc-article')),
        findsOneWidget,
      );
      expect(find.byKey(_commandSpecimenKey), findsOneWidget);
      expect(find.byType(ElCommand), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'sections render in the reference-shape order, with no heading before '
      'Installation',
      (WidgetTester tester) async {
        await _pumpCommandDoc(tester);

        // Read the mounted ElSection titles rather than find.text: a section
        // title also renders in the right-rail TOC at this width, so a bare
        // find.text would match twice.
        final List<String> titles = tester
            .widgetList<ElSection>(find.byType(ElSection))
            .map((ElSection section) => section.title)
            .toList();

        expect(titles, _expectedSectionTitles);
        expect(titles, isNot(contains('Overview')));
        expect(titles, isNot(contains('Preview')));
        expect(titles, isNot(contains('Variants')));
        // No component-name prefix survives on any section title.
        for (final String title in titles) {
          expect(title.startsWith('Command'), isFalse, reason: title);
        }
      },
    );

    testWidgets('every combobox section and specimen is gone from this page', (
      WidgetTester tester,
    ) async {
      await _pumpCommandDoc(tester);

      final List<String> titles = tester
          .widgetList<ElSection>(find.byType(ElSection))
          .map((ElSection section) => section.title)
          .toList();
      // Combobox's own two sections moved out with it.
      expect(titles, isNot(contains('Invalid')));
      expect(titles, isNot(contains('Disabled')));

      // The live combobox and its API table went too.
      expect(find.byType(ElCombobox<String>), findsNothing);
      expect(
        find.byKey(const ValueKey<String>('command-doc-combobox-specimen')),
        findsNothing,
      );
      expect(find.text('ElCombobox<T>'), findsNothing);
      expect(
        find.text('elCollatorContains(label, query) → bool'),
        findsNothing,
      );
    });

    testWidgets(
      'the API tables cover every parameter, static and top-level function '
      'command.dart declares',
      (WidgetTester tester) async {
        await _pumpCommandDoc(tester);

        for (final String name in <String>[
          ..._commandParams,
          ..._commandItemMembers,
          ..._commandGroupParams,
          ..._commandStatics,
          // elCommandScore(string, abbreviation, [aliases])
          'string',
          'abbreviation',
          'aliases',
        ]) {
          expect(
            find.text(name),
            findsAtLeastNWidgets(1),
            reason: 'Member "$name" missing from an API table',
          );
        }

        // One table per exported class, plus the statics and the function.
        // findsAtLeastNWidgets, not findsOneWidget: each of these is also a
        // nested TOC entry at this width, so a bare find.text matches twice.
        for (final String title in <String>[
          'ElCommand',
          'ElCommand static helpers',
          'ElCommandItem',
          'ElCommandGroup',
          'elCommandScore(string, abbreviation, [aliases]) → double',
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
      'the API tables carry the REAL declared types, not the ones the '
      'combined page guessed',
      (WidgetTester tester) async {
        await _pumpCommandDoc(tester);

        // The old merged table typed lucideIcon String?. It is a curated
        // generated-glyph enum.
        expect(find.text('ElLucideGlyph?'), findsOneWidget);
        expect(find.text('String?'), findsAtLeastNWidgets(1));
        // filter's real signature names its three parameters.
        expect(
          find.text(
            'double Function(String value, String search, '
            'List<String> keywords)?',
          ),
          findsOneWidget,
        );
        // onValueChanged carries the highlighted row's searchValue, which the
        // old table described as the query.
        expect(find.textContaining('HIGHLIGHTED'), findsAtLeastNWidgets(1));
      },
    );

    testWidgets('installation shows the shipped registry command', (
      WidgetTester tester,
    ) async {
      await _pumpCommandDoc(tester);

      expect(find.textContaining('elattar add command'), findsWidgets);
      expect(find.textContaining('command.json'), findsWidgets);
    });

    testWidgets(
      'the filtering section documents the real scorer with a worked example',
      (WidgetTester tester) async {
        await _pumpCommandDoc(tester);

        expect(find.textContaining('elCommandScore'), findsWidgets);
        expect(find.textContaining('Go to Stash'), findsWidgets);
        expect(find.textContaining('0.891'), findsWidgets);
      },
    );

    testWidgets(
      'accessibility plainly documents the missing live region and the '
      'focus-affordance gap',
      (WidgetTester tester) async {
        await _pumpCommandDoc(tester);

        expect(find.textContaining('live region'), findsWidgets);
        expect(find.textContaining('Known gap'), findsWidgets);
      },
    );

    testWidgets(
      'the skipped shadcn sections are named rather than silently dropped',
      (WidgetTester tester) async {
        await _pumpCommandDoc(tester);

        expect(find.textContaining('RTL'), findsWidgets);
        expect(find.textContaining('CommandDialog'), findsWidgets);
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

  group('live specimen: the palette filters and re-sorts as you type', () {
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

    testWidgets(
      'the meta text is searchable, which is what searchValue means',
      (WidgetTester tester) async {
        await _pumpCommandDoc(tester);

        final Finder input = _commandInput();
        await tester.ensureVisible(input);

        // Eclipse Vault's meta is a price; nothing in its label is a digit.
        await tester.enterText(input, '48');
        await tester.pump();

        expect(find.text('Eclipse Vault'), findsOneWidget);
        expect(find.text('Open Wallet'), findsNothing);
        expect(find.text('Go to Stash'), findsNothing);
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
      await _pumpCommandDoc(tester, mode: ElThemeMode.light);
      expect(find.byKey(_commandSpecimenKey), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders on dark', (WidgetTester tester) async {
      await _pumpCommandDoc(tester, mode: ElThemeMode.dark);
      expect(find.byKey(_commandSpecimenKey), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('flipping the theme in place keeps the page intact', (
      WidgetTester tester,
    ) async {
      final ElThemeController theme = await _pumpCommandDoc(
        tester,
        mode: ElThemeMode.dark,
      );
      final ElThemeData dark = ElTheme.of(
        tester.element(
          find.byKey(const ValueKey<String>('command-doc-article')),
        ),
      );

      theme.setMode(ElThemeMode.light);
      await tester.pump();

      final ElThemeData light = ElTheme.of(
        tester.element(
          find.byKey(const ValueKey<String>('command-doc-article')),
        ),
      );
      expect(light.background, isNot(dark.background));
      expect(light.foreground, isNot(dark.foreground));

      expect(find.byKey(_commandSpecimenKey), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
