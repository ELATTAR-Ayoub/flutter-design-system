/// Tests for `components_docs/menubar/meta.dart` and
/// `components_docs/menubar/page.dart`: the public documentation page for
/// Menubar.
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never synthetic `MediaQuery`. Theme
/// coverage uses a live `ElThemeController` flipped in place rather than two
/// independent pumps.
///
/// ElMenubar mounts its open menu through [OverlayPortal] (via ElPopover),
/// so the live specimen needs a real [Overlay]: the harness wraps the page
/// in a `MaterialApp`, the same fix Popover and Select needed.
///
/// Split out of the former merged `navigation_menu_test.dart` (Phase F/J),
/// which covered `navigation_menu`, `menubar`, `context_menu`, and
/// `hover_card` together.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/menubar/meta.dart';
import 'package:example/components_docs/menubar/page.dart';
import 'package:example/kit.dart' show ElSection;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const Size _wide = Size(1440, 900);
const Size _narrow = Size(390, 844);

Future<ElThemeController> _pumpPage(
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
            child: MenubarDocPage(onNavigate: onNavigate),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  return theme;
}

void main() {
  group('meta', () {
    test('menubarDoc names the real public API surface', () {
      expect(menubarDoc.name, 'menubar');
      expect(menubarDoc.title, 'Menubar');
      expect(menubarDoc.route, '/components/menubar');
      expect(menubarDoc.dependencies, <String>[
        'menu',
        'popover',
        'source-foundation',
      ]);
      expect(menubarDoc.sourcePath, 'lib/src/components/menubar.dart');
      expect(
        menubarDoc.exports,
        containsAll(<String>['ElMenubar', 'ElMenubarMenu']),
      );
      // Short description: one sentence, no trailing ellipsis.
      expect(menubarDoc.description, isNot(contains('..')));
      expect(menubarDoc.description.trim(), menubarDoc.description);
    });
  });

  group('rendered page', () {
    testWidgets('sections render in the shadcn-mirrored order', (
      WidgetTester tester,
    ) async {
      await _pumpPage(tester);

      final List<String> titles = tester
          .widgetList<ElSection>(find.byType(ElSection))
          .map((ElSection section) => section.title)
          .toList();

      expect(titles, <String>[
        'Installation',
        'Usage',
        'Composition',
        'Checkbox',
        'Radio',
        'Submenu',
        'With Icons',
        'RTL',
        'API Reference',
        'States',
        'Accessibility',
        'Responsive',
        'Dependencies',
        'Theming',
        'Source',
      ]);
    });

    testWidgets('renders the article and the live specimen', (
      WidgetTester tester,
    ) async {
      await _pumpPage(tester);

      expect(
        find.byKey(const ValueKey<String>('menubar-doc-article')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('menubar-specimen')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'the API table documents constructor parameters from the source',
      (WidgetTester tester) async {
        await _pumpPage(tester);

        // ElMenubar.
        expect(find.text('menus'), findsWidgets);

        // ElMenubarMenu.
        expect(find.text('label'), findsWidgets);
        expect(find.text('children'), findsWidgets);
      },
    );

    testWidgets('documents the working menubar CLI install', (
      WidgetTester tester,
    ) async {
      await _pumpPage(tester);

      expect(find.textContaining('elattar add menubar'), findsWidgets);
    });

    testWidgets('documents that the component is built on ElPopover', (
      WidgetTester tester,
    ) async {
      await _pumpPage(tester);

      expect(find.textContaining('ElPopover'), findsWidgets);
    });
  });

  group('live specimen', () {
    testWidgets('renders and shows its trigger labels', (
      WidgetTester tester,
    ) async {
      await _pumpPage(tester);

      final Finder specimen = find.byKey(
        const ValueKey<String>('menubar-specimen'),
      );
      await tester.ensureVisible(specimen);
      await tester.pumpAndSettle();

      expect(find.text('File'), findsWidgets);
      expect(find.text('Edit'), findsWidgets);
      expect(tester.takeException(), isNull);
    });
  });

  group('viewport widths', () {
    testWidgets('a wide viewport exposes the sidebar and table of contents', (
      WidgetTester tester,
    ) async {
      await _pumpPage(tester, size: _wide);

      expect(
        find.byKey(const ValueKey<String>('docs-layout-sidebar')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('docs-layout-toc')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('menubar-doc-article')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'a narrow viewport drops to the anchor strip and stays reachable',
      (WidgetTester tester) async {
        await _pumpPage(tester, size: _narrow);

        expect(
          find.byKey(const ValueKey<String>('docs-layout-sidebar')),
          findsNothing,
        );
        expect(
          find.byKey(const ValueKey<String>('docs-layout-anchor-strip')),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey<String>('menubar-doc-article')),
          findsOneWidget,
        );
        tester.takeException();
      },
    );
  });

  group('both themes', () {
    testWidgets('renders on light', (WidgetTester tester) async {
      await _pumpPage(tester, mode: ElThemeMode.light);
      expect(
        find.byKey(const ValueKey<String>('menubar-specimen')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders on dark', (WidgetTester tester) async {
      await _pumpPage(tester, mode: ElThemeMode.dark);
      expect(
        find.byKey(const ValueKey<String>('menubar-specimen')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('flipping the theme in place keeps the page intact', (
      WidgetTester tester,
    ) async {
      final ElThemeController theme = await _pumpPage(
        tester,
        mode: ElThemeMode.dark,
      );
      expect(
        find.byKey(const ValueKey<String>('menubar-specimen')),
        findsOneWidget,
      );

      theme.setMode(ElThemeMode.light);
      await tester.pump();

      expect(
        find.byKey(const ValueKey<String>('menubar-specimen')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });
  });
}
