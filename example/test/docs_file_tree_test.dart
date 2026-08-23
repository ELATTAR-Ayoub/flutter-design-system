/// Tests for `docs/docs_file_tree.dart`'s [DocsFileTree] — the file
/// selector + single-file code pane that replaces stacking every
/// `DocsCodeFile` the way `docs_code.dart`'s manual pane does.
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), not synthetic `MediaQuery` — a Phase F
/// review correction carried forward from `buttons_page_test.dart`.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/docs/docs_code.dart';
import 'package:example/docs/docs_file_tree.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const Size _wide = Size(1440, 900);
const Size _narrow = Size(390, 844);

const List<DocsCodeFile> _twoFiles = <DocsCodeFile>[
  DocsCodeFile(path: 'lib/widgets/demo/a.dart', code: 'class A {}'),
  DocsCodeFile(path: 'lib/widgets/demo/b.dart', code: 'class B {}'),
];

const List<DocsCodeFile> _threeFiles = <DocsCodeFile>[
  DocsCodeFile(path: 'lib/widgets/demo/a.dart', code: 'class A {}'),
  DocsCodeFile(path: 'lib/widgets/demo/b.dart', code: 'class B {}'),
  DocsCodeFile(path: 'lib/widgets/demo/c.dart', code: 'class C {}'),
];

const List<DocsCodeFile> _duplicateBasenames = <DocsCodeFile>[
  DocsCodeFile(path: 'lib/widgets/one/config.dart', code: 'class ConfigOne {}'),
  DocsCodeFile(path: 'lib/widgets/two/config.dart', code: 'class ConfigTwo {}'),
];

Future<DsThemeController> _pumpTree(
  WidgetTester tester, {
  required List<DocsCodeFile> files,
  Size size = _wide,
  DsThemeMode mode = DsThemeMode.dark,
  String label = 'Files',
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
            child: DocsFileTree(label: label, files: files),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  return theme;
}

void main() {
  testWidgets('the first file is selected by default', (
    WidgetTester tester,
  ) async {
    await _pumpTree(tester, files: _twoFiles);

    expect(find.text('class A {}'), findsOneWidget);
    expect(find.text('class B {}'), findsNothing);
    expect(find.bySemanticsLabel('Selected file a.dart'), findsOneWidget);
    expect(find.bySemanticsLabel('Select file b.dart'), findsOneWidget);
  });

  testWidgets('switching the selected file changes the visible code', (
    WidgetTester tester,
  ) async {
    await _pumpTree(tester, files: _twoFiles);

    await tester.tap(find.bySemanticsLabel('Select file b.dart'));
    await tester.pump();

    expect(find.text('class A {}'), findsNothing);
    expect(find.text('class B {}'), findsOneWidget);
    expect(find.bySemanticsLabel('Selected file b.dart'), findsOneWidget);
    expect(find.bySemanticsLabel('Select file a.dart'), findsOneWidget);

    // Selecting the already-selected file is a no-op, not a rebuild trap.
    await tester.tap(find.bySemanticsLabel('Selected file b.dart'));
    await tester.pump();
    expect(find.text('class B {}'), findsOneWidget);
  });

  testWidgets('a single-file list still renders sensibly', (
    WidgetTester tester,
  ) async {
    const List<DocsCodeFile> single = <DocsCodeFile>[
      DocsCodeFile(path: 'lib/widgets/demo/solo.dart', code: 'class Solo {}'),
    ];
    await _pumpTree(tester, files: single);

    expect(find.text('class Solo {}'), findsOneWidget);
    expect(find.bySemanticsLabel('Selected file solo.dart'), findsOneWidget);
    // The one file-entry row, plus the copy control for its source — not
    // the bare 1 this used to assert before the copy affordance existed.
    expect(find.byType(DsButton), findsNWidgets(2));

    // Tapping the only, already-selected entry must not throw or blank the
    // pane.
    await tester.tap(find.bySemanticsLabel('Selected file solo.dart'));
    await tester.pump();
    expect(find.text('class Solo {}'), findsOneWidget);
  });

  testWidgets('file entries are real focusable buttons, not painted text', (
    WidgetTester tester,
  ) async {
    await _pumpTree(tester, files: _twoFiles);

    final Iterable<DsButton> entries = tester
        .widgetList<DsButton>(find.byType(DsButton))
        .where((DsButton b) => b.key is ValueKey<String>);
    expect(entries.length, 2);
    for (final DsButton entry in entries) {
      // A DsButton always carries a callback and an accessible label — a
      // disabled or unlabeled control here would mean the row degraded to
      // decoration.
      expect(entry.onPressed, isNotNull);
      expect(entry.label, isNotNull);
    }
  });

  testWidgets(
    'a wide viewport puts the file list beside the code pane, full-width rows',
    (WidgetTester tester) async {
      await _pumpTree(tester, files: _twoFiles, size: _wide);

      final List<DsButton> entries = tester
          .widgetList<DsButton>(find.byType(DsButton))
          .where((DsButton b) => b.key is ValueKey<String>)
          .toList();
      expect(entries, isNotEmpty);
      for (final DsButton entry in entries) {
        expect(entry.expanded, isTrue);
      }
    },
  );

  testWidgets(
    'a narrow viewport stacks the file list above the code pane, compact chips',
    (WidgetTester tester) async {
      await _pumpTree(tester, files: _twoFiles, size: _narrow);

      final List<DsButton> entries = tester
          .widgetList<DsButton>(find.byType(DsButton))
          .where((DsButton b) => b.key is ValueKey<String>)
          .toList();
      expect(entries, isNotEmpty);
      for (final DsButton entry in entries) {
        expect(entry.expanded, isFalse);
      }

      // Still fully functional stacked: the code pane still updates.
      await tester.tap(find.bySemanticsLabel('Select file b.dart'));
      await tester.pump();
      expect(find.text('class B {}'), findsOneWidget);
    },
  );

  group('both themes', () {
    testWidgets('renders the same structure on light', (
      WidgetTester tester,
    ) async {
      await _pumpTree(tester, files: _twoFiles, mode: DsThemeMode.light);

      expect(find.text('class A {}'), findsOneWidget);
      // 2 file-entry rows + 1 copy control for the selected file.
      expect(find.byType(DsButton), findsNWidgets(3));
    });

    testWidgets('flipping the theme in place preserves selection', (
      WidgetTester tester,
    ) async {
      final DsThemeController theme = await _pumpTree(tester, files: _twoFiles);

      await tester.tap(find.bySemanticsLabel('Select file b.dart'));
      await tester.pump();
      expect(find.text('class B {}'), findsOneWidget);

      theme.setMode(DsThemeMode.light);
      await tester.pump();

      // The theme flip must not reset internal selection state.
      expect(find.text('class B {}'), findsOneWidget);
      expect(find.bySemanticsLabel('Selected file b.dart'), findsOneWidget);
    });
  });

  group('a shrinking files list', () {
    testWidgets(
      'resets an out-of-range selection to the first file instead of throwing',
      (WidgetTester tester) async {
        tester.view.physicalSize = _wide;
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        final DsThemeController theme = DsThemeController(
          mode: DsThemeMode.dark,
        );
        addTearDown(theme.dispose);

        Widget host(List<DocsCodeFile> files) => DsTheme(
          controller: theme,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: SingleChildScrollView(child: DocsFileTree(files: files)),
            ),
          ),
        );

        await tester.pumpWidget(host(_threeFiles));
        await tester.pump();

        await tester.tap(find.bySemanticsLabel('Select file c.dart'));
        await tester.pump();
        expect(find.bySemanticsLabel('Selected file c.dart'), findsOneWidget);

        // Re-pump the *same* element tree (same widget types, no keys, so
        // the framework updates rather than recreates it) with a shorter
        // list. This is exactly what `didUpdateWidget` exists to guard:
        // delete that override and `files[_selected]` — `files[2]` against a
        // 1-file list — is a RangeError.
        await tester.pumpWidget(host(<DocsCodeFile>[_threeFiles.first]));
        await tester.pump();

        expect(tester.takeException(), isNull);
        expect(find.text('class A {}'), findsOneWidget);
        expect(find.bySemanticsLabel('Selected file a.dart'), findsOneWidget);
      },
    );
  });

  group('an empty files list', () {
    testWidgets('renders a placeholder instead of indexing into nothing', (
      WidgetTester tester,
    ) async {
      await _pumpTree(tester, files: const <DocsCodeFile>[]);

      expect(tester.takeException(), isNull);
      expect(
        find.byKey(const ValueKey<String>('docs-file-tree-empty')),
        findsOneWidget,
      );
      expect(find.byType(DsButton), findsNothing);
    });
  });

  group('files sharing a basename', () {
    testWidgets('are shown with enough path to tell them apart', (
      WidgetTester tester,
    ) async {
      await _pumpTree(tester, files: _duplicateBasenames);

      expect(
        find.bySemanticsLabel('Selected file lib/widgets/one/config.dart'),
        findsOneWidget,
      );
      expect(
        find.bySemanticsLabel('Select file lib/widgets/two/config.dart'),
        findsOneWidget,
      );
      // The bare, ambiguous basename must not be used for either row once
      // there is a collision — that was the whole bug.
      expect(find.bySemanticsLabel('Selected file config.dart'), findsNothing);
      expect(find.bySemanticsLabel('Select file config.dart'), findsNothing);
    });
  });

  group('copy control', () {
    testWidgets('the selected file has a copy control labelled for that file', (
      WidgetTester tester,
    ) async {
      await _pumpTree(tester, files: _twoFiles);

      expect(
        find.bySemanticsLabel('Copy lib/widgets/demo/a.dart'),
        findsOneWidget,
      );
      expect(find.bySemanticsLabel('Copy lib/widgets/demo/b.dart'), findsNothing);

      await tester.tap(find.bySemanticsLabel('Select file b.dart'));
      await tester.pump();

      expect(
        find.bySemanticsLabel('Copy lib/widgets/demo/b.dart'),
        findsOneWidget,
      );
      expect(find.bySemanticsLabel('Copy lib/widgets/demo/a.dart'), findsNothing);
    });

    testWidgets(
      "pressing copy writes the selected file's source through the injected writer",
      (WidgetTester tester) async {
        final List<String> copied = <String>[];
        tester.view.physicalSize = _wide;
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        final DsThemeController theme = DsThemeController(
          mode: DsThemeMode.dark,
        );
        addTearDown(theme.dispose);

        await tester.pumpWidget(
          DsTheme(
            controller: theme,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: SingleChildScrollView(
                  child: DocsFileTree(
                    files: _twoFiles,
                    clipboardWriter: (String text) async => copied.add(text),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pump();

        await tester.tap(find.bySemanticsLabel('Copy lib/widgets/demo/a.dart'));
        await tester.pump();

        expect(copied, <String>['class A {}']);
      },
    );

    // Catches: dropping the "Copied" state back to a bare press highlight.
    // The audit's F7 — the control dipped and came back, and nothing on
    // screen distinguished a successful copy from a mis-tap.
    testWidgets('a successful copy is confirmed, then returns to rest', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = _wide;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final DsThemeController theme = DsThemeController(mode: DsThemeMode.dark);
      addTearDown(theme.dispose);

      await tester.pumpWidget(
        DsTheme(
          controller: theme,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: SingleChildScrollView(
                child: DocsFileTree(
                  files: _twoFiles,
                  clipboardWriter: (String text) async {},
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.text('Copy'), findsOneWidget);

      await tester.tap(find.bySemanticsLabel('Copy lib/widgets/demo/a.dart'));
      await tester.pump();

      expect(find.text('Copied'), findsOneWidget);
      expect(find.text('Copy'), findsNothing);
      expect(
        find.bySemanticsLabel('Copied lib/widgets/demo/a.dart'),
        findsOneWidget,
      );

      await tester.pumpAndSettle();
      expect(find.text('Copy'), findsOneWidget);
      expect(find.text('Copied'), findsNothing);
    });
  });

  group('a source listing is readable, not clipped', () {
    /// Wide enough to overflow any column, and deep enough that an uncapped
    /// block would carry its scrollbar off the bottom of the screen.
    final String longSource = <String>[
      'class SomeVeryLongWidgetClassName extends StatefulWidget with AVeryLongMixinName implements SomethingElseEntirely {',
      for (int i = 0; i < 400; i++) '  // line $i',
      '}',
    ].join('\n');

    List<DocsCodeFile> filesWith(String code) => <DocsCodeFile>[
      DocsCodeFile(path: 'lib/widgets/demo/long.dart', code: code),
    ];

    // Catches: removing the `maxHeight` the file tree passes, which is what
    // put the horizontal scrollbar hundreds of pixels below the fold and left
    // the reader with `class SomeVeryLongWidgetClassName extends Statefu` and no way
    // to reach the rest of the line.
    testWidgets('the pane is capped and its long lines are reachable', (
      WidgetTester tester,
    ) async {
      await _pumpTree(tester, files: filesWith(longSource));

      final Size block = tester.getSize(find.byType(DocsSelectableCodeBlock));
      expect(
        block.height,
        lessThanOrEqualTo(DocsSelectableCodeBlock.sourceMaxHeight + 2),
        reason: 'an uncapped listing takes its scrollbar off screen with it',
      );

      final ScrollableState horizontal = tester.state<ScrollableState>(
        find.descendant(
          of: find.byKey(const ValueKey<String>('docs-code-scroll')),
          matching: find.byType(Scrollable),
        ),
      );
      expect(horizontal.position.axis, Axis.horizontal);
      expect(
        horizontal.position.maxScrollExtent,
        greaterThan(0),
        reason: 'the long line has somewhere to scroll to',
      );

      // Both thumbs ride the capped box rather than the 400-line column: no
      // scrollbar is painted *inside* the scrolling content, which is exactly
      // what put the horizontal thumb off screen before.
      expect(
        find.descendant(
          of: find.byKey(const ValueKey<String>('docs-code-scroll-vertical')),
          matching: find.byType(RawScrollbar),
        ),
        findsNothing,
      );
      expect(
        find.ancestor(
          of: find.byKey(const ValueKey<String>('docs-code-scroll-vertical')),
          matching: find.byType(RawScrollbar),
        ),
        findsNWidgets(2),
        reason: 'one bar per axis, both outside the content',
      );

      // And the wheel has a vertical viewport of its own now. `firstState`:
      // the horizontal view is nested inside this one, so two `Scrollable`s
      // answer the descendant query and the outer — vertical — one is first.
      final ScrollableState vertical = tester.firstState<ScrollableState>(
        find.descendant(
          of: find.byKey(const ValueKey<String>('docs-code-scroll-vertical')),
          matching: find.byType(Scrollable),
        ),
      );
      expect(vertical.position.axis, Axis.vertical);
      expect(vertical.position.maxScrollExtent, greaterThan(0));
    });

    // Catches: re-wrapping a multi-line listing in `DsLineBox`. That widget
    // restores a paragraph's CSS height by growing the *paragraph* and
    // centring the difference, so 400 lines of half-pixel correction landed as
    // one lump of dead air above the first line — the audit's F6.
    testWidgets('a multi-line listing starts at the top of its own padding', (
      WidgetTester tester,
    ) async {
      await _pumpTree(tester, files: filesWith(longSource));

      expect(
        find.descendant(
          of: find.byType(DocsSelectableCodeBlock),
          matching: find.byType(DsLineBox),
        ),
        findsNothing,
        reason: 'a whole-paragraph leading correction belongs to one line',
      );

      final double blockTop = tester
          .getRect(find.byType(DocsSelectableCodeBlock))
          .top;
      final double firstLineTop = tester
          .getRect(
            find.descendant(
              of: find.text(longSource),
              matching: find.byType(RichText),
            ),
          )
          .top;
      // `p-5` and the hairline the frame is paid out of — nothing else.
      expect(firstLineTop - blockTop, closeTo(ds(5) + DsWidths.hairline, 1));
    });

    // The single-line command block keeps its line box: there the correction
    // is one line's worth, which is exactly what `DsLineBox` is for.
    testWidgets('a one-line block keeps its CSS line box', (
      WidgetTester tester,
    ) async {
      await _pumpTree(tester, files: filesWith('class A {}'));

      expect(
        find.descendant(
          of: find.byType(DocsSelectableCodeBlock),
          matching: find.byType(DsLineBox),
        ),
        findsOneWidget,
      );
    });
  });
}
