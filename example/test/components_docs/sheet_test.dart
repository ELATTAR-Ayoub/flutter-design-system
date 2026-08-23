/// Tests for the combined Sheet + Drawer documentation page.
///
/// Sheet and drawer are documented on one page because they are the same
/// idea — an edge-anchored panel that keeps the page behind it in place — at
/// different edges. This file proves both real widgets actually mount, open
/// and dismiss inside the page, not just that their names appear in prose.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/sheet/meta.dart';
import 'package:example/components_docs/sheet/page.dart';
import 'package:example/docs/docs_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Real test-view sizing only — [tester.view.physicalSize] plus
/// [WidgetTester.view]'s own reset, never a synthetic `MediaQuery` override.
/// [controller] is a single live [DsThemeController] the caller can flip in
/// place with [DsThemeController.setMode].
///
/// Wrapped in [MaterialApp] rather than a bare `Directionality`/`MediaQuery`
/// stack: sheet and drawer are [OverlayPortal]s that render into the nearest
/// [Overlay] theatre, which only a real [MaterialApp] (via its [Navigator])
/// supplies. Without it, both specimens would fail to build or would build
/// against the wrong [Overlay] and never actually open.
Widget _harness({
  required Widget child,
  required DsThemeController controller,
}) {
  return DsTheme(
    controller: controller,
    child: MaterialApp(home: SingleChildScrollView(child: child)),
  );
}

/// Every constructor parameter name declared on the public classes of
/// `lib/src/components/sheet.dart` — from [DsSheet.showLeft] and
/// [DsSheetPanel] through [DsSheetOverlay], [DsSheetTransition],
/// [DsSheetContent], [DsSheetContentGroup], [DsSheetHeader], [DsSheetFooter],
/// [DsSheetTitle] and [DsSheetDescription].
const List<String> _sheetParamNames = <String>[
  'builder', // DsSheet.showLeft
  'width', // DsSheetPanel / DsSheetContent
  'showCloseButton', // DsSheetPanel / DsSheetContent
  'child', // DsSheetPanel / DsSheetTransition
  'trigger', // DsSheetOverlay
  'content', // DsSheetOverlay
  'side', // DsSheetOverlay / DsSheetTransition / DsSheetContent
  'animation', // DsSheetTransition
  'children', // DsSheetContent / DsSheetHeader / DsSheetFooter
  'onClose', // DsSheetContent
  'fill', // DsSheetContent
  'text', // DsSheetTitle / DsSheetDescription
];

/// Every constructor parameter name declared on the public classes of
/// `lib/src/components/drawer.dart` — [DsDrawer], [DsDrawerContent],
/// [DsDrawerHeader], [DsDrawerFooter], [DsDrawerTitle], [DsDrawerDescription].
/// [DsDrawerHandle] takes no constructor parameters.
const List<String> _drawerParamNames = <String>[
  'trigger', // DsDrawer
  'content', // DsDrawer
  'children', // DsDrawerContent / DsDrawerHeader / DsDrawerFooter
  'text', // DsDrawerTitle / DsDrawerDescription
];

void main() {
  group('sheetDoc', () {
    test(
      'documents the real public API surface of sheet.dart and drawer.dart',
      () {
        expect(sheetDoc.name, 'sheet');
        expect(sheetDoc.title, isNotEmpty);
        expect(sheetDoc.sourcePath, 'lib/src/components/sheet.dart');
        expect(sheetDoc.description, isNotEmpty);
        expect(sheetDoc.route, '/components/sheet');
        expect(
          sheetDoc.exports,
          containsAll(<String>[
            // lib/src/components/sheet.dart
            'DsSheet',
            'DsSheetPanel',
            'DsSheetSide',
            'DsSheetOverlay',
            'DsSheetTransition',
            'DsSheetContent',
            'DsSheetContentGroup',
            'DsSheetHeader',
            'DsSheetFooter',
            'DsSheetTitle',
            'DsSheetDescription',
            // lib/src/components/drawer.dart
            'DsDrawer',
            'DsDrawerContent',
            'DsDrawerHandle',
            'DsDrawerHeader',
            'DsDrawerFooter',
            'DsDrawerTitle',
            'DsDrawerDescription',
          ]),
        );
      },
    );
  });

  group('SheetDocPage', () {
    testWidgets('renders the article at desktop width with every documented '
        'constructor parameter of both components', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final DsThemeController controller = DsThemeController(
        mode: DsThemeMode.dark,
      );
      await tester.pumpWidget(
        _harness(controller: controller, child: const SheetDocPage()),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey<String>('sheet-doc-article')),
        findsOneWidget,
      );
      expect(find.textContaining('Sheet'), findsWidgets);
      expect(find.textContaining('Drawer'), findsWidgets);
      expect(find.byType(DocsCodeExample), findsAtLeastNWidgets(1));

      for (final String param in <String>{
        ..._sheetParamNames,
        ..._drawerParamNames,
      }) {
        expect(
          find.text(param),
          findsAtLeastNWidgets(1),
          reason: 'Parameter "$param" missing from an API table',
        );
      }

      // DsSheetSide's four values.
      for (final String value in <String>['top', 'right', 'bottom', 'left']) {
        expect(
          find.text(value),
          findsAtLeastNWidgets(1),
          reason: 'DsSheetSide.$value missing from the API table',
        );
      }

      expect(
        find.byKey(const ValueKey<String>('docs-layout-sidebar')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'drops the sidebar and shows the anchor strip at mobile width',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        final DsThemeController controller = DsThemeController(
          mode: DsThemeMode.light,
        );
        await tester.pumpWidget(
          _harness(controller: controller, child: const SheetDocPage()),
        );
        await tester.pumpAndSettle();

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

    testWidgets(
      'a live DsSheetOverlay opens a real DsSheetContent and dismisses on '
      'scrim tap',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        final DsThemeController controller = DsThemeController(
          mode: DsThemeMode.dark,
        );
        await tester.pumpWidget(
          _harness(controller: controller, child: const SheetDocPage()),
        );
        await tester.pumpAndSettle();

        expect(find.byType(DsSheetContent), findsNothing);
        final Finder trigger = find.byKey(
          const ValueKey<String>('sheet-trigger:right'),
        );
        await tester.ensureVisible(trigger);
        await tester.tap(trigger);
        await tester.pumpAndSettle();

        expect(find.byType(DsSheetContent), findsOneWidget);
        expect(find.text('Notification settings'), findsOneWidget);
        final Rect panel = tester.getRect(find.byType(DsSheetContent));
        // side: right — pinned to the trailing edge of a 1440-wide viewport.
        expect(panel.right, closeTo(1440, 1));

        // Tap the scrim, well clear of the right-hand panel, to dismiss.
        await tester.tapAt(const Offset(20, 20));
        await tester.pumpAndSettle();
        expect(find.byType(DsSheetContent), findsNothing);
      },
    );

    testWidgets('Escape dismisses an open sheet', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final DsThemeController controller = DsThemeController(
        mode: DsThemeMode.dark,
      );
      await tester.pumpWidget(
        _harness(controller: controller, child: const SheetDocPage()),
      );
      await tester.pumpAndSettle();

      final Finder trigger = find.byKey(
        const ValueKey<String>('sheet-trigger:right'),
      );
      await tester.ensureVisible(trigger);
      await tester.tap(trigger);
      await tester.pumpAndSettle();
      expect(find.byType(DsSheetContent), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.byType(DsSheetContent), findsNothing);
    });

    testWidgets(
      'a live DsDrawer opens full-bleed at the bottom, drags past the '
      'close threshold, and dismisses',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        final DsThemeController controller = DsThemeController(
          mode: DsThemeMode.dark,
        );
        await tester.pumpWidget(
          _harness(controller: controller, child: const SheetDocPage()),
        );
        await tester.pumpAndSettle();

        final Finder trigger = find.byKey(
          const ValueKey<String>('drawer-trigger'),
        );
        await tester.ensureVisible(trigger);
        await tester.tap(trigger);
        await tester.pumpAndSettle();

        expect(find.byType(DsDrawerContent), findsOneWidget);
        expect(find.text('Card actions'), findsOneWidget);
        final Rect panel = tester.getRect(find.byType(DsDrawerContent));
        expect(panel.width, 1440);
        expect(panel.bottom, closeTo(900, 1));
        // The grip handle is part of the anatomy, unconditionally.
        expect(find.byType(DsDrawerHandle), findsOneWidget);

        // Past vaul's own 0.25-of-height close threshold, the drawer unmounts.
        final TestGesture drag = await tester.startGesture(
          panel.topCenter + const Offset(0, 8),
        );
        await tester.pump();
        await drag.moveBy(Offset(0, panel.height * 0.6));
        await tester.pump();
        await drag.up();
        await tester.pump();
        // Not a single tester.pump(DsDurations.drawer): the reverse
        // AnimationController reaches value 0 within that frame, but its
        // whenComplete callback (which calls _portal.hide()) needs one more
        // pump to actually flush the OverlayPortal's removal from the tree.
        // pumpAndSettle is safe here — this is a bounded exit animation, not
        // a loop.
        await tester.pumpAndSettle();
        expect(find.byType(DsDrawerContent), findsNothing);
      },
    );

    testWidgets('a drag short of the threshold releases the drawer back open', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final DsThemeController controller = DsThemeController(
        mode: DsThemeMode.dark,
      );
      await tester.pumpWidget(
        _harness(controller: controller, child: const SheetDocPage()),
      );
      await tester.pumpAndSettle();

      final Finder trigger = find.byKey(
        const ValueKey<String>('drawer-trigger'),
      );
      await tester.ensureVisible(trigger);
      await tester.tap(trigger);
      await tester.pumpAndSettle();

      final Rect panel = tester.getRect(find.byType(DsDrawerContent));
      final TestGesture drag = await tester.startGesture(
        panel.topCenter + const Offset(0, 8),
      );
      await tester.pump();
      await drag.moveBy(Offset(0, panel.height * 0.1));
      await tester.pump();
      await drag.up();
      await tester.pumpAndSettle();
      expect(find.byType(DsDrawerContent), findsOneWidget);
    });

    testWidgets('opening the sheet moves focus into the overlay scope; Escape '
        'returns it to the trigger', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final DsThemeController controller = DsThemeController(
        mode: DsThemeMode.dark,
      );
      await tester.pumpWidget(
        _harness(controller: controller, child: const SheetDocPage()),
      );
      await tester.pumpAndSettle();

      final Finder trigger = find.byKey(
        const ValueKey<String>('sheet-trigger:right'),
      );
      await tester.ensureVisible(trigger);
      final DsButton triggerWidget = tester.widget<DsButton>(trigger);
      final FocusNode? triggerFocusNode = triggerWidget.focusNode;
      expect(
        triggerFocusNode,
        isNotNull,
        reason:
            'the specimen wires an explicit focusNode to the right-hand '
            'sheet trigger so this test can observe where focus goes',
      );
      triggerFocusNode!.requestFocus();
      await tester.pump();
      expect(FocusManager.instance.primaryFocus, same(triggerFocusNode));

      await tester.tap(trigger);
      await tester.pumpAndSettle();
      expect(find.byType(DsSheetContent), findsOneWidget);

      // DsModalPortal wraps its content in FocusScope(autofocus: true) —
      // the trigger's own node loses primary focus to that scope's own
      // FocusScopeNode (not to a leaf control inside it).
      final BuildContext panelContext = tester.element(
        find.byType(DsSheetContent),
      );
      final FocusScopeNode panelScope = FocusScope.of(panelContext);
      expect(
        FocusManager.instance.primaryFocus,
        same(panelScope),
        reason:
            'expected autofocus to land on the panel\'s own FocusScopeNode '
            '— observed: ${FocusManager.instance.primaryFocus}',
      );

      // Tab from the scope node itself moves focus to a real control inside
      // the panel — the scope still traps focus while Tab cycles through
      // the sheet's real controls.
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      final FocusNode? afterTab = FocusManager.instance.primaryFocus;
      expect(afterTab, isNotNull);
      expect(
        afterTab,
        isNot(same(panelScope)),
        reason: 'Tab should move focus from the scope to a real control',
      );

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.byType(DsSheetContent), findsNothing);

      // Confirmed rather than assumed, against the initial expectation:
      // DsModalPortal contains no explicit "restore focus to the trigger"
      // code, yet closing the sheet DOES return primary focus to the
      // trigger's own node. This is Flutter's FocusManager falling back to
      // the scope's previously-focused child once the overlay's own
      // FocusScope is removed from the tree — not something DsModalPortal
      // wires itself, and it depends on the trigger's FocusNode still being
      // mounted when the overlay closes.
      expect(FocusManager.instance.primaryFocus, same(triggerFocusNode));
    });

    testWidgets('flips between light and dark with one live controller', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final DsThemeController controller = DsThemeController(
        mode: DsThemeMode.dark,
      );
      await tester.pumpWidget(
        _harness(controller: controller, child: const SheetDocPage()),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      controller.setMode(DsThemeMode.light);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byType(SheetDocPage), findsOneWidget);
    });

    testWidgets(
      'tapping a previous/next link calls onNavigate without throwing',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        String? destination;
        final DsThemeController controller = DsThemeController(
          mode: DsThemeMode.dark,
        );
        await tester.pumpWidget(
          _harness(
            controller: controller,
            child: SheetDocPage(
              onNavigate: (String route) => destination = route,
            ),
          ),
        );
        await tester.pumpAndSettle();

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
