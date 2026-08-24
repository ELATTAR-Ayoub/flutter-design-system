/// Tests for `components_docs/context_menu/meta.dart` and
/// `components_docs/context_menu/page.dart`: the public documentation page
/// for Context Menu.
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never synthetic `MediaQuery`. Theme
/// coverage uses a live `ElThemeController` flipped in place rather than two
/// independent pumps.
///
/// ElContextMenu mounts its menu through [OverlayPortal] (via ElPopover), so
/// the live specimens need a real [Overlay]: the harness wraps the page in a
/// `MaterialApp`, the same fix Popover and Select needed.
///
/// This page mounts `_ContextMenuSpecimen` twice (the unheaded live demo and
/// Destructive), each under its own `specimenKey` — the known-bug guard the
/// page's own doc comment explains.
///
/// Split out of the former merged `navigation_menu_test.dart` (Phase F/J),
/// which covered `navigation_menu`, `menubar`, `context_menu`, and
/// `hover_card` together.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/context_menu/meta.dart';
import 'package:example/components_docs/context_menu/page.dart';
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
            child: ContextMenuDocPage(onNavigate: onNavigate),
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
    test('contextMenuDoc names the real public API surface', () {
      expect(contextMenuDoc.name, 'context-menu');
      expect(contextMenuDoc.title, 'Context Menu');
      expect(contextMenuDoc.route, '/components/context-menu');
      expect(contextMenuDoc.dependencies, <String>[
        'menu',
        'popover',
        'source-foundation',
      ]);
      expect(contextMenuDoc.sourcePath, 'lib/src/components/context_menu.dart');
      expect(contextMenuDoc.exports, containsAll(<String>['ElContextMenu']));
      // Short description: one sentence, no trailing ellipsis.
      expect(contextMenuDoc.description, isNot(contains('..')));
      expect(contextMenuDoc.description.trim(), contextMenuDoc.description);
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
        'Basic',
        'Submenu',
        'Shortcuts',
        'Groups',
        'Icons',
        'Checkboxes',
        'Radio',
        'Destructive',
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

    testWidgets(
      'renders the article and both live specimens under distinct keys',
      (WidgetTester tester) async {
        await _pumpPage(tester);

        expect(
          find.byKey(const ValueKey<String>('context-menu-doc-article')),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey<String>('context-menu-specimen')),
          findsOneWidget,
        );
        expect(
          find.byKey(
            const ValueKey<String>('context-menu-destructive-specimen'),
          ),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'the API table documents constructor parameters from the source',
      (WidgetTester tester) async {
        await _pumpPage(tester);

        expect(find.text('child'), findsWidgets);
        expect(find.text('children'), findsWidgets);
        expect(find.text('width'), findsOneWidget);
        expect(find.text('enabled'), findsOneWidget);
      },
    );

    testWidgets('documents the working context-menu CLI install', (
      WidgetTester tester,
    ) async {
      await _pumpPage(tester);

      expect(find.textContaining('elattar add context-menu'), findsWidgets);
    });

    testWidgets('accessibility section documents the touch gap', (
      WidgetTester tester,
    ) async {
      await _pumpPage(tester);

      expect(find.textContaining('No touch path'), findsWidgets);
      expect(find.textContaining('Right-click only'), findsWidgets);
    });
  });

  group('live specimens', () {
    testWidgets('both mounts render without colliding', (
      WidgetTester tester,
    ) async {
      await _pumpPage(tester);

      final Finder top = find.byKey(
        const ValueKey<String>('context-menu-specimen'),
      );
      final Finder destructive = find.byKey(
        const ValueKey<String>('context-menu-destructive-specimen'),
      );
      await tester.ensureVisible(destructive);
      await tester.pumpAndSettle();

      expect(top, findsOneWidget);
      expect(destructive, findsOneWidget);
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
        find.byKey(const ValueKey<String>('context-menu-doc-article')),
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
          find.byKey(const ValueKey<String>('context-menu-doc-article')),
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
        find.byKey(const ValueKey<String>('context-menu-specimen')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders on dark', (WidgetTester tester) async {
      await _pumpPage(tester, mode: ElThemeMode.dark);
      expect(
        find.byKey(const ValueKey<String>('context-menu-specimen')),
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
        find.byKey(const ValueKey<String>('context-menu-specimen')),
        findsOneWidget,
      );

      theme.setMode(ElThemeMode.light);
      await tester.pump();

      expect(
        find.byKey(const ValueKey<String>('context-menu-specimen')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });
  });
}
