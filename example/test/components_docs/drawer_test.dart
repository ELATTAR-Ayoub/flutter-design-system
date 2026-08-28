/// Tests for `components_docs/drawer/meta.dart` and
/// `components_docs/drawer/page.dart`: the public Drawer component
/// documentation page.
///
/// Split out of a former combined sheet+drawer test file: this file covers
/// `DrawerDocPage` alone. Sheet's own coverage lives in `sheet_test.dart`.
///
/// Re-housed onto `ComponentDocSpec`/`ComponentDocPage`, the same shape
/// `button_test.dart`, `alert_dialog_test.dart` and `sheet_test.dart` assert
/// against: sections read through `DocsSection.title`, and the API table
/// (now inside a `DocsDisclosure`, closed by default) is opened before its
/// rows are read.
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never a synthetic `MediaQuery`. Theme
/// coverage flips a single live `ThemeController` in place.
///
/// `Drawer` mounts its content through an `OverlayPortal`, so the live
/// specimen needs a real `Overlay`: the harness wraps the page in a
/// `MaterialApp`. No `pumpAndSettle` is used anywhere on this page: an exact
/// single-jump `pump(duration)` proved to undershoot the exit animation on
/// this family of pages (`sheet_test.dart` hit the same thing first), so
/// every open/close step below settles with a short, bounded loop of
/// `pump(const Duration(milliseconds: 50))` steps instead.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/drawer/meta.dart';
import 'package:example/components_docs/drawer/page.dart';
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
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const Size _wide = Size(1440, 900);
const Size _narrow = Size(390, 844);

const List<String> _sectionOrder = <String>[
  'Preview',
  'Installation',
  'Usage',
  'Composition',
  'Sizing',
  'API Reference',
  'States',
  'Accessibility',
  'Keyboard',
  'Responsive',
  'Dependencies',
  'Theming',
  'Source',
];

/// Every constructor parameter name declared on the public classes of
/// `lib/src/components/drawer.dart`. [DrawerHandle] takes no constructor
/// parameters of its own.
const List<String> _drawerParamNames = <String>[
  'trigger', // Drawer
  'content', // Drawer
  'children', // DrawerContent / DrawerHeader / DrawerFooter
  'text', // DrawerTitle / DrawerDescription
];

Finder _disclosureTrigger(String title) => find.descendant(
  of: find.byWidgetPredicate(
    (Widget widget) => widget is DocsDisclosure && widget.title == title,
  ),
  matching: find.byKey(DocsDisclosure.triggerKey),
);

/// Pumps in short, bounded steps rather than a single exact-duration jump:
/// the granularity that turned out to matter for this overlay family (see
/// the library note above).
Future<void> _settle(WidgetTester tester, {int steps = 12}) async {
  await tester.pump();
  for (int i = 0; i < steps; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

Future<ThemeController> _pumpDrawerDoc(
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
        home: SingleChildScrollView(
          child: DrawerDocPage(onNavigate: onNavigate),
        ),
      ),
    ),
  );
  await tester.pump();
  return theme;
}

void main() {
  group('meta', () {
    test('drawerDoc names the real public API surface', () {
      expect(drawerDoc.name, 'drawer');
      expect(drawerDoc.title, 'Drawer');
      expect(drawerDoc.route, '/components/drawer');
      expect(drawerDoc.sourcePath, 'lib/src/components/drawer.dart');
      expect(drawerDoc.description, isNotEmpty);
      expect(drawerDoc.description, isNot(contains('..')));
      expect(drawerDoc.description.trim(), drawerDoc.description);
      expect(
        drawerDoc.exports,
        containsAll(<String>[
          'Drawer',
          'DrawerContent',
          'DrawerHandle',
          'DrawerHeader',
          'DrawerFooter',
          'DrawerTitle',
          'DrawerDescription',
        ]),
      );
      // No sheet symbols on this page's export list.
      expect(drawerDoc.exports, isNot(contains('SheetOverlay')));
      expect(drawerDoc.dependencies, <String>['dialog', 'source-foundation']);
    });
  });

  group('DrawerDocPage house shape', () {
    testWidgets('renders every section, in order', (WidgetTester tester) async {
      await _pumpDrawerDoc(tester, size: const Size(1440, 3600));

      final List<String> titles = tester
          .widgetList<DocsSection>(find.byType(DocsSection))
          .map((DocsSection section) => section.title)
          .toList();

      expect(titles, _sectionOrder);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Sizing carries the consolidated, honest SKIPPED note', (
      WidgetTester tester,
    ) async {
      await _pumpDrawerDoc(tester, size: const Size(1440, 3600));

      expect(find.textContaining('SKIPPED'), findsWidgets);
      expect(tester.takeException(), isNull);
    });
  });

  group('DrawerDocPage', () {
    testWidgets(
      'renders the article with every documented constructor parameter',
      (WidgetTester tester) async {
        await _pumpDrawerDoc(tester, size: const Size(1440, 3600));

        expect(
          find.byKey(const ValueKey<String>('drawer-doc-article')),
          findsOneWidget,
        );
        expect(find.textContaining('Drawer'), findsWidgets);

        final Finder apiTrigger = _disclosureTrigger('API Reference');
        await tester.ensureVisible(apiTrigger);
        await tester.pump();
        await tester.tap(apiTrigger);
        await tester.pump();
        await tester.pump(MotionDurations.open);

        for (final String param in _drawerParamNames) {
          expect(
            find.text(param),
            findsAtLeastNWidgets(1),
            reason: 'Parameter "$param" missing from an API table',
          );
        }

        expect(
          find.byKey(const ValueKey<String>('docs-layout-sidebar')),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('installation names the real manual copy target', (
      WidgetTester tester,
    ) async {
      await _pumpDrawerDoc(tester);

      expect(find.textContaining('elattar add drawer'), findsWidgets);
      expect(find.textContaining('source-foundation'), findsWidgets);

      // The manual copy target only renders once the Manual tab is
      // selected: DocsInstall defaults to the CLI tab.
      final Finder manualTab = find.text('Manual');
      await tester.ensureVisible(manualTab);
      await tester.tap(manualTab);
      await tester.pump();

      expect(
        find.textContaining('lib/components/ui/drawer.dart'),
        findsWidgets,
      );
    });

    testWidgets(
      'drops the sidebar and shows the anchor strip at mobile width',
      (WidgetTester tester) async {
        await _pumpDrawerDoc(tester, size: _narrow, mode: ColorMode.light);

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

    testWidgets('a live Drawer opens full-bleed at the bottom, drags past the '
        'close threshold, and dismisses', (WidgetTester tester) async {
      await _pumpDrawerDoc(tester);

      final Finder trigger = find.byKey(
        const ValueKey<String>('drawer-preview-trigger'),
      );
      await tester.ensureVisible(trigger);
      await tester.tap(trigger);
      await _settle(tester);

      expect(find.byType(DrawerContent), findsOneWidget);
      expect(find.text('Card actions'), findsOneWidget);
      final Rect panel = tester.getRect(find.byType(DrawerContent));
      expect(panel.width, 1440);
      expect(panel.bottom, closeTo(900, 1));
      // The grip handle is part of the anatomy, unconditionally.
      expect(find.byType(DrawerHandle), findsOneWidget);

      // Past vaul's own 0.25-of-height close threshold, the drawer
      // unmounts.
      final TestGesture drag = await tester.startGesture(
        panel.topCenter + const Offset(0, 8),
      );
      await tester.pump();
      await drag.moveBy(Offset(0, panel.height * 0.6));
      await tester.pump();
      await drag.up();
      await _settle(tester);
      expect(find.byType(DrawerContent), findsNothing);
    });

    testWidgets('a drag short of the threshold releases the drawer back open', (
      WidgetTester tester,
    ) async {
      await _pumpDrawerDoc(tester);

      final Finder trigger = find.byKey(
        const ValueKey<String>('drawer-preview-trigger'),
      );
      await tester.ensureVisible(trigger);
      await tester.tap(trigger);
      await _settle(tester);

      final Rect panel = tester.getRect(find.byType(DrawerContent));
      final TestGesture drag = await tester.startGesture(
        panel.topCenter + const Offset(0, 8),
      );
      await tester.pump();
      await drag.moveBy(Offset(0, panel.height * 0.1));
      await tester.pump();
      await drag.up();
      await _settle(tester);
      expect(find.byType(DrawerContent), findsOneWidget);
    });

    testWidgets('Escape dismisses an open drawer', (WidgetTester tester) async {
      await _pumpDrawerDoc(tester);

      final Finder trigger = find.byKey(
        const ValueKey<String>('drawer-preview-trigger'),
      );
      await tester.ensureVisible(trigger);
      await tester.tap(trigger);
      await _settle(tester);
      expect(find.byType(DrawerContent), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await _settle(tester);
      expect(find.byType(DrawerContent), findsNothing);
    });

    testWidgets('flips between light and dark with one live controller', (
      WidgetTester tester,
    ) async {
      final ThemeController controller = await _pumpDrawerDoc(tester);
      expect(tester.takeException(), isNull);

      controller.setMode(ColorMode.light);
      await tester.pump();
      expect(tester.takeException(), isNull);
      expect(find.byType(DrawerDocPage), findsOneWidget);
    });

    testWidgets(
      'tapping a previous/next link calls onNavigate without throwing',
      (WidgetTester tester) async {
        String? destination;
        await _pumpDrawerDoc(
          tester,
          onNavigate: (String route) => destination = route,
        );

        final Finder link = find.byKey(
          const ValueKey<String>('docs-layout-prev-next'),
        );
        await tester.ensureVisible(link);
        final Finder dialogLink = find.text('Dialog').first;
        await tester.ensureVisible(dialogLink);
        await tester.tap(dialogLink);
        expect(destination, isNotNull);
      },
    );
  });
}
