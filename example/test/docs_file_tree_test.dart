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
  DocsCodeFile(path: 'lib/shots/demo/a.dart', code: 'class A {}'),
  DocsCodeFile(path: 'lib/shots/demo/b.dart', code: 'class B {}'),
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
      DocsCodeFile(path: 'lib/shots/demo/solo.dart', code: 'class Solo {}'),
    ];
    await _pumpTree(tester, files: single);

    expect(find.text('class Solo {}'), findsOneWidget);
    expect(find.bySemanticsLabel('Selected file solo.dart'), findsOneWidget);
    expect(find.byType(DsButton), findsOneWidget);

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
      expect(find.byType(DsButton), findsNWidgets(2));
    });

    testWidgets('flipping the theme in place preserves selection', (
      WidgetTester tester,
    ) async {
      final DsThemeController theme = await _pumpTree(
        tester,
        files: _twoFiles,
      );

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
}
