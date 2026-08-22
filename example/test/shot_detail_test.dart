/// Tests for `shots_docs/shot_detail_page.dart`'s [ShotDetailPage] — the
/// install command, file tree, dependency list and preview link for one
/// [ShotDocEntry].
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), not synthetic `MediaQuery` — a Phase F
/// review correction carried forward from `buttons_page_test.dart`.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/shots_docs/catalog.dart';
import 'package:example/shots_docs/shot_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const Size _wide = Size(1440, 900);
const Size _narrow = Size(390, 844);

final ShotDocEntry _entry = shotDoc('settings-profile');

Future<DsThemeController> _pumpDetail(
  WidgetTester tester, {
  ShotDocEntry? entry,
  Map<String, String> fileSource = const <String, String>{},
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
            child: ShotDetailPage(
              entry: entry ?? _entry,
              fileSource: fileSource,
              onNavigate: onNavigate,
            ),
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
    'renders the header, the install command, and the dependency list',
    (WidgetTester tester) async {
      await _pumpDetail(tester);

      expect(find.text(_entry.title), findsWidgets);
      expect(find.text(_entry.description), findsOneWidget);
      expect(find.text(_entry.command), findsOneWidget);

      for (final String dependency in _entry.dependencies) {
        expect(
          find.text(dependency),
          findsOneWidget,
          reason: 'expected a dependency chip for $dependency',
        );
      }
    },
  );

  testWidgets(
    'renders the file tree over the shot files, placeholder source by default',
    (WidgetTester tester) async {
      await _pumpDetail(tester);

      final String onlyFile = _entry.files.single;
      expect(find.bySemanticsLabel('Selected file $onlyFile'), findsOneWidget);
      expect(
        find.textContaining('Source for $onlyFile is not loaded'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'a supplied fileSource renders the real code instead of the placeholder',
    (WidgetTester tester) async {
      final String onlyFile = _entry.files.single;
      await _pumpDetail(
        tester,
        fileSource: <String, String>{onlyFile: 'class SettingsProfileShot {}'},
      );

      expect(find.text('class SettingsProfileShot {}'), findsOneWidget);
      expect(
        find.textContaining('Source for $onlyFile is not loaded'),
        findsNothing,
      );
    },
  );

  testWidgets('renders a link to the preview route that invokes onNavigate', (
    WidgetTester tester,
  ) async {
    final List<String> navigated = <String>[];
    await _pumpDetail(tester, onNavigate: navigated.add);

    expect(find.text(_entry.previewRoute), findsOneWidget);
    expect(find.text('Open live preview'), findsOneWidget);

    // The preview link sits below the fold of a long article; scroll it
    // into view before tapping rather than hit-testing an off-screen point.
    await tester.ensureVisible(find.text('Open live preview'));
    await tester.pump();
    await tester.tap(find.text('Open live preview'));
    await tester.pump();

    expect(navigated, <String>[_entry.previewRoute]);
  });

  testWidgets(
    'a wide viewport exposes the DocsLayout sidebar and table of contents',
    (WidgetTester tester) async {
      await _pumpDetail(tester, size: _wide);

      expect(
        find.byKey(const ValueKey<String>('docs-layout-sidebar')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('docs-layout-toc')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('docs-layout-anchor-strip')),
        findsNothing,
      );
    },
  );

  testWidgets(
    'a narrow viewport drops the sidebar and toc for an anchor strip, and keeps content reachable',
    (WidgetTester tester) async {
      await _pumpDetail(tester, size: _narrow);

      expect(
        find.byKey(const ValueKey<String>('docs-layout-sidebar')),
        findsNothing,
      );
      expect(
        find.byKey(const ValueKey<String>('docs-layout-toc')),
        findsNothing,
      );
      expect(
        find.byKey(const ValueKey<String>('docs-layout-anchor-strip')),
        findsOneWidget,
      );

      // The article itself — command, dependencies, file tree — still renders
      // in full on a narrow viewport; only the surrounding chrome collapses.
      expect(find.text(_entry.command), findsOneWidget);
      for (final String dependency in _entry.dependencies) {
        expect(find.text(dependency), findsOneWidget);
      }
      expect(
        find.bySemanticsLabel('Selected file ${_entry.files.single}'),
        findsOneWidget,
      );
    },
  );

  group('both themes', () {
    testWidgets('renders the same structure on light', (
      WidgetTester tester,
    ) async {
      await _pumpDetail(tester, mode: DsThemeMode.light);

      expect(find.text(_entry.title), findsWidgets);
      expect(find.text(_entry.command), findsOneWidget);
    });

    testWidgets('flipping the theme in place preserves the selected file', (
      WidgetTester tester,
    ) async {
      final DsThemeController theme = await _pumpDetail(tester);

      final String onlyFile = _entry.files.single;
      expect(find.bySemanticsLabel('Selected file $onlyFile'), findsOneWidget);

      theme.setMode(DsThemeMode.light);
      await tester.pump();

      expect(find.bySemanticsLabel('Selected file $onlyFile'), findsOneWidget);
      expect(find.text(_entry.command), findsOneWidget);
    });
  });

  // `_pumpDetail`'s `entry` parameter, unlike every test above, is actually
  // exercised here — the whole suite otherwise only ever renders
  // `shotDocs.first`, leaving `_siblings`' bounds and the sidebar's
  // `selected` flag wholly unasserted.
  group('siblings across the catalog', () {
    testWidgets(
      'the first shot has no previous link but does have a next link',
      (WidgetTester tester) async {
        await _pumpDetail(tester, entry: shotDocs.first);

        expect(tester.takeException(), isNull);
        final Finder prevNext = find.byKey(
          const ValueKey<String>('docs-layout-prev-next'),
        );
        expect(
          find.descendant(of: prevNext, matching: find.byType(DsButton)),
          findsOneWidget,
        );
        expect(
          find.bySemanticsLabel('Open ${shotDocs[1].title}'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'the last shot has a previous link but no next link, and does not throw',
      (WidgetTester tester) async {
        await _pumpDetail(tester, entry: shotDocs.last);

        // The regression this guards: mutating `_siblings`' upper bound
        // from `index < shotDocs.length - 1` to `index <= shotDocs.length -
        // 1` indexes one past the end of `shotDocs` for the last entry —
        // a `RangeError` thrown during build, caught here via
        // `takeException`.
        expect(tester.takeException(), isNull);
        final Finder prevNext = find.byKey(
          const ValueKey<String>('docs-layout-prev-next'),
        );
        expect(
          find.descendant(of: prevNext, matching: find.byType(DsButton)),
          findsOneWidget,
        );
        expect(
          find.bySemanticsLabel('Open ${shotDocs[shotDocs.length - 2].title}'),
          findsOneWidget,
        );
      },
    );

    testWidgets('a middle shot has both a previous link and a next link', (
      WidgetTester tester,
    ) async {
      final ShotDocEntry middle = shotDocs[1];
      await _pumpDetail(tester, entry: middle);

      expect(tester.takeException(), isNull);
      final Finder prevNext = find.byKey(
        const ValueKey<String>('docs-layout-prev-next'),
      );
      expect(
        find.descendant(of: prevNext, matching: find.byType(DsButton)),
        findsNWidgets(2),
      );
      expect(
        find.bySemanticsLabel('Open ${shotDocs[0].title}'),
        findsOneWidget,
      );
      expect(
        find.bySemanticsLabel('Open ${shotDocs[2].title}'),
        findsOneWidget,
      );
    });

    testWidgets('the sidebar marks only the current shot selected', (
      WidgetTester tester,
    ) async {
      final ShotDocEntry current = shotDocs[1];
      await _pumpDetail(tester, entry: current, size: _wide);

      for (final ShotDocEntry shot in shotDocs) {
        final Finder row = find.byKey(
          ValueKey<String>('docs-sidebar:${shot.route}'),
        );
        expect(row, findsOneWidget, reason: shot.name);

        final Semantics semantics = tester.widget<Semantics>(
          find.ancestor(of: row, matching: find.byType(Semantics)).first,
        );
        expect(
          semantics.properties.selected,
          shot.name == current.name,
          reason: shot.name,
        );
      }
    });
  });
}
