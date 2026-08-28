/// Tests for `components_docs/context_menu/meta.dart` and
/// `components_docs/context_menu/page.dart`: the public documentation page
/// for Context Menu.
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never synthetic `MediaQuery`. Theme
/// coverage uses a live `ThemeController` flipped in place rather than two
/// independent pumps.
///
/// ContextMenu mounts its menu through [OverlayPortal] (via Popover), so
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
import 'package:example/docs/docs_disclosure.dart';
import 'package:example/docs/docs_section.dart' show DocsSection;
import 'package:flutter/material.dart'
    hide
        AspectRatio,
        Form,
        FormField,
        Icon,
        OverlayPortal,
        RadioGroup,
        RichText,
        SafeArea,
        ScrollPosition,
        Table,
        TableColumnWidth,
        ActionChip,
        AlertDialog,
        Badge,
        Card,
        CarouselController,
        Checkbox,
        Dialog,
        DropdownMenu,
        Drawer,
        DrawerHeader,
        Slider,
        Switch,
        TextFormField,
        Tooltip;
import 'package:flutter_test/flutter_test.dart';

/// The single `DocsDisclosure` whose title is [title]. `DocsDisclosure`'s
/// own trigger key (`DocsDisclosure.triggerKey`) is one constant shared by
/// every instance on the page, so a bare `find.byKey` would match all eight
/// — this narrows to the one panel by its title first.
Finder _disclosureTrigger(String title) => find.descendant(
  of: find.byWidgetPredicate(
    (Widget widget) => widget is DocsDisclosure && widget.title == title,
  ),
  matching: find.byKey(DocsDisclosure.triggerKey),
);

/// Opens the disclosure titled [title]: scrolls its trigger into view (no
/// `pumpAndSettle` — see the library note), taps it, and lets the panel's
/// own expand animation finish.
Future<void> _openDisclosure(WidgetTester tester, String title) async {
  final Finder trigger = _disclosureTrigger(title);
  await tester.ensureVisible(trigger);
  await tester.pump();
  await tester.tap(trigger);
  await tester.pump();
  await tester.pump(MotionDurations.open);
}

const Size _wide = Size(1440, 900);
const Size _narrow = Size(390, 844);

Future<ThemeController> _pumpPage(
  WidgetTester tester, {
  ValueChanged<String>? onNavigate,
  Size size = _wide,
  ColorMode mode = ColorMode.dark,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final ThemeController theme = ThemeController(mode: mode);
  addTearDown(theme.dispose);

  await tester.pumpWidget(
    ThemeScope(
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
      expect(contextMenuDoc.exports, containsAll(<String>['ContextMenu']));
      // Short description: one sentence, no trailing ellipsis.
      expect(contextMenuDoc.description, isNot(contains('..')));
      expect(contextMenuDoc.description.trim(), contextMenuDoc.description);
    });
  });

  group('rendered page', () {
    testWidgets('sections render in the shadcn-mirrored order', (
      WidgetTester tester,
    ) async {
      await _pumpPage(tester, size: const Size(1440, 4000));

      final List<String> titles = tester
          .widgetList<DocsSection>(find.byType(DocsSection))
          .map((DocsSection section) => section.title)
          .toList();

      expect(titles, <String>[
        'Preview',
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
        'Keyboard',
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
        await _pumpPage(tester, size: const Size(1440, 4000));
        await _openDisclosure(tester, 'API Reference');

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

    testWidgets('accessibility and keyboard sections document the touch '
        'gap and the keyboard-open gap', (WidgetTester tester) async {
      await _pumpPage(tester, size: const Size(1440, 4000));
      await _openDisclosure(tester, 'Accessibility');
      await _openDisclosure(tester, 'Keyboard');

      expect(find.textContaining('No touch path'), findsWidgets);
      expect(find.textContaining('Right-click only'), findsWidgets);
      expect(
        find.textContaining('no keyboard route to open the menu'),
        findsWidgets,
      );
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
      await tester.pump();

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
      await _pumpPage(tester, mode: ColorMode.light);
      expect(
        find.byKey(const ValueKey<String>('context-menu-specimen')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders on dark', (WidgetTester tester) async {
      await _pumpPage(tester, mode: ColorMode.dark);
      expect(
        find.byKey(const ValueKey<String>('context-menu-specimen')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('flipping the theme in place keeps the page intact', (
      WidgetTester tester,
    ) async {
      final ThemeController theme = await _pumpPage(
        tester,
        mode: ColorMode.dark,
      );
      expect(
        find.byKey(const ValueKey<String>('context-menu-specimen')),
        findsOneWidget,
      );

      theme.setMode(ColorMode.light);
      await tester.pump();

      expect(
        find.byKey(const ValueKey<String>('context-menu-specimen')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });
  });
}
