/// Consumer-level lifecycle coverage for the three panels that ride
/// `dialog.dart`'s `OverlayPortal` kernel unmodified: [AlertDialog],
/// [SheetOverlay] and [Drawer].
///
/// `test/overlay_lifecycle_test.dart` already proves the kernel itself: focus
/// lands inside the panel on open, Tab/Shift+Tab cannot leave it, Escape
/// closes and restores focus, the scrim is a named `Dismiss` control only
/// when it dismisses, `BlockSemantics` covers the page behind, and a portal
/// that never opened disposes cleanly. Each of the three widgets here builds
/// its `content`/`transition` straight onto `OverlayPortal` — read directly
/// from `lib/src/components/ui/{alert_dialog,sheet,drawer}.dart` — with no
/// second focus-management path of their own, so the kernel tests already
/// stand in for: focus-inside-on-open, Tab/Shift+Tab containment, and clean
/// disposal of the portal's own controllers and focus nodes. What is tested
/// below is what is NOT generic: each consumer's own Escape/outside-tap
/// contract, its own trigger-disabling, its own focus-restore target, and its
/// own semantics.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/material.dart' show Material, MaterialApp;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart'
    hide
        AspectRatio,
        Icon,
        OverlayPortal,
        RichText,
        SafeArea,
        ScrollPosition,
        Table,
        TableColumnWidth;
import 'package:flutter_test/flutter_test.dart';

/// Copied verbatim from `test/overlay_lifecycle_test.dart` — a bare
/// `Directionality` host has no ambient shortcut map or traversal root, so
/// Tab/Escape/Enter silently do nothing, and `StyledText` asserts without a
/// root `DefaultTextStyle`.
Widget host(Widget child) => ThemeScope(
  controller: ThemeController(mode: ColorMode.dark),
  child: MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Builder(
      builder: (BuildContext context) => DefaultTextStyle(
        style: StyledText.styleOf(
          context,
          TextStyles.body,
          color: ThemeScope.of(context).foreground,
        ),
        child: Material(child: Center(child: child)),
      ),
    ),
  ),
);

/// Whether [node]'s context sits inside the element subtree rooted at
/// [ancestor] — proof that focus landed INSIDE the overlay's own content, not
/// merely somewhere that happens not to be the trigger. Duplicated from
/// `overlay_lifecycle_test.dart`'s `isInside` rather than imported, so this
/// file stays self-contained.
bool _isInside(FocusNode? node, Element ancestor) {
  final BuildContext? context = node?.context;
  if (context == null) return false;
  if (context == ancestor) return true;
  bool found = false;
  context.visitAncestorElements((Element e) {
    if (e == ancestor) {
      found = true;
      return false;
    }
    return true;
  });
  return found;
}

void main() {
  group('AlertDialog', () {
    Widget alertDialog({bool triggerEnabled = true}) => AlertDialog(
      trigger: (BuildContext context, VoidCallback open) => Button(
        label: 'Delete',
        onPressed: triggerEnabled ? open : null,
        child: const Text('Delete'),
      ),
      content: (BuildContext context, VoidCallback close) => AlertDialogContent(
        header: const AlertDialogHeader(
          title: AlertDialogTitle('Delete this pack?'),
          description: AlertDialogDescription('This cannot be undone.'),
        ),
        footer: AlertDialogFooter(
          cancel: AlertDialogCancel(label: 'Cancel', onPressed: close),
          action: AlertDialogAction(label: 'Delete', onPressed: close),
        ),
      ),
    );

    testWidgets(
      'Escape closes it, despite the copy promising no escape-to-cancel — '
      'the reference itself was measured closing on Escape (see the '
      "library doc's drift 1), and the kernel's Escape handler makes no "
      'exception for the alert dialog',
      (WidgetTester t) async {
        await t.pumpWidget(host(alertDialog()));
        await t.tap(find.text('Delete'));
        await t.pumpAndSettle();
        expect(find.byType(AlertDialogContent), findsOneWidget);

        await t.sendKeyEvent(LogicalKeyboardKey.escape);
        await t.pumpAndSettle();
        expect(find.byType(AlertDialogContent), findsNothing);
      },
    );

    testWidgets('a tap on the scrim does NOT close it — measured, and wired as '
        'dismissOnOverlayTap: false', (WidgetTester t) async {
      await t.pumpWidget(host(alertDialog()));
      await t.tap(find.text('Delete'));
      await t.pumpAndSettle();

      // The scrim covers the corners; the panel sits centred over them.
      await t.tapAt(const Offset(5, 5));
      await t.pumpAndSettle();
      expect(
        find.byType(AlertDialogContent),
        findsOneWidget,
        reason: "the alert dialog's own contract refuses outside dismissal",
      );
    });

    testWidgets('focus returns to the trigger once Cancel closes it', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(host(alertDialog()));
      await t.sendKeyEvent(LogicalKeyboardKey.tab);
      await t.pumpAndSettle();
      final FocusNode? trigger = FocusManager.instance.primaryFocus;

      await t.tap(find.text('Delete'));
      await t.pumpAndSettle();
      await t.tap(find.text('Cancel'));
      await t.pumpAndSettle();

      expect(FocusManager.instance.primaryFocus, trigger);
    });

    testWidgets('a disabled trigger does not open it', (WidgetTester t) async {
      await t.pumpWidget(host(alertDialog(triggerEnabled: false)));
      await t.tap(find.text('Delete'), warnIfMissed: false);
      await t.pumpAndSettle();
      expect(find.byType(AlertDialogContent), findsNothing);
    });

    testWidgets('title and description surface as reader-visible labels', (
      WidgetTester t,
    ) async {
      final SemanticsHandle handle = t.ensureSemantics();
      await t.pumpWidget(host(alertDialog()));
      await t.tap(find.text('Delete'));
      await t.pumpAndSettle();

      expect(find.text('Delete this pack?'), findsOneWidget);
      expect(find.text('This cannot be undone.'), findsOneWidget);
      expect(
        t
            .widgetList<Semantics>(find.byType(Semantics))
            .any((Semantics s) => s.properties.scopesRoute ?? false),
        isTrue,
        reason:
            'AlertDialog rides the same OverlayPortal kernel as Dialog, so '
            'it scopes its own route the same way',
      );
      handle.dispose();
    });

    testWidgets('disposes cleanly if torn down mid-open', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(host(alertDialog()));
      await t.tap(find.text('Delete'));
      await t.pump();
      await t.pumpWidget(host(const SizedBox.shrink()));
      await t.pumpAndSettle();
      expect(t.takeException(), isNull);
    });

    testWidgets(
      'opening moves focus onto a descendant of the panel, not merely off '
      'the trigger',
      (WidgetTester t) async {
        await t.pumpWidget(host(alertDialog()));
        await t.tap(find.text('Delete'));
        await t.pumpAndSettle();
        final Element panel = t.element(find.byType(AlertDialogContent));
        expect(
          _isInside(FocusManager.instance.primaryFocus, panel),
          isTrue,
          reason: 'Radix moves focus to the first tabbable child — Cancel',
        );
      },
    );

    testWidgets('Tab and Shift+Tab never leave the panel', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(host(alertDialog()));
      await t.tap(find.text('Delete'));
      await t.pumpAndSettle();
      final Element panel = t.element(find.byType(AlertDialogContent));

      for (int i = 0; i < 6; i++) {
        await t.sendKeyEvent(LogicalKeyboardKey.tab);
        await t.pump();
        expect(
          _isInside(FocusManager.instance.primaryFocus, panel),
          isTrue,
          reason: 'Tab #$i escaped the panel',
        );
      }
      await t.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
      for (int i = 0; i < 6; i++) {
        await t.sendKeyEvent(LogicalKeyboardKey.tab);
        await t.pump();
        expect(
          _isInside(FocusManager.instance.primaryFocus, panel),
          isTrue,
          reason: 'Shift+Tab #$i escaped the panel',
        );
      }
      await t.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
    });
  });

  group('SheetOverlay', () {
    Widget sheet({bool triggerEnabled = true}) => SheetOverlay(
      trigger: (BuildContext context, VoidCallback open) => Button(
        label: 'Open sheet',
        onPressed: triggerEnabled ? open : null,
        child: const Text('Open sheet'),
      ),
      content: (BuildContext context, VoidCallback close) => SheetContent(
        onClose: close,
        children: <Widget>[
          SheetHeader(children: <Widget>[SheetTitle('Filters')]),
          Press(onTap: close, semanticLabel: 'Done', child: const Text('Done')),
        ],
      ),
    );

    testWidgets('Escape closes it and focus returns to the trigger', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(host(sheet()));
      await t.sendKeyEvent(LogicalKeyboardKey.tab);
      await t.pumpAndSettle();
      final FocusNode? trigger = FocusManager.instance.primaryFocus;

      await t.tap(find.text('Open sheet'));
      await t.pumpAndSettle();
      expect(find.byType(SheetContent), findsOneWidget);

      await t.sendKeyEvent(LogicalKeyboardKey.escape);
      await t.pumpAndSettle();
      expect(find.byType(SheetContent), findsNothing);
      expect(FocusManager.instance.primaryFocus, trigger);
    });

    testWidgets('a disabled trigger does not open it', (WidgetTester t) async {
      await t.pumpWidget(host(sheet(triggerEnabled: false)));
      await t.tap(find.text('Open sheet'), warnIfMissed: false);
      await t.pumpAndSettle();
      expect(find.byType(SheetContent), findsNothing);
    });

    testWidgets('the close button drives the same close/restore path', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(host(sheet()));
      await t.sendKeyEvent(LogicalKeyboardKey.tab);
      await t.pumpAndSettle();
      final FocusNode? trigger = FocusManager.instance.primaryFocus;

      await t.tap(find.text('Open sheet'));
      await t.pumpAndSettle();
      await t.tap(find.text('Done'));
      await t.pumpAndSettle();

      expect(find.byType(SheetContent), findsNothing);
      expect(FocusManager.instance.primaryFocus, trigger);
    });

    testWidgets('the panel scopes its own route, distinct from the page', (
      WidgetTester t,
    ) async {
      final SemanticsHandle handle = t.ensureSemantics();
      await t.pumpWidget(host(sheet()));
      await t.tap(find.text('Open sheet'));
      await t.pumpAndSettle();

      expect(
        t
            .widgetList<Semantics>(find.byType(Semantics))
            .any((Semantics s) => s.properties.scopesRoute ?? false),
        isTrue,
      );
      handle.dispose();
    });

    testWidgets('disposes cleanly if torn down mid-open', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(host(sheet()));
      await t.tap(find.text('Open sheet'));
      await t.pump();
      await t.pumpWidget(host(const SizedBox.shrink()));
      await t.pumpAndSettle();
      expect(t.takeException(), isNull);
    });

    testWidgets(
      'opening moves focus onto a descendant of the panel, not merely off '
      'the trigger',
      (WidgetTester t) async {
        await t.pumpWidget(host(sheet()));
        await t.tap(find.text('Open sheet'));
        await t.pumpAndSettle();
        final Element panel = t.element(find.byType(SheetContent));
        expect(_isInside(FocusManager.instance.primaryFocus, panel), isTrue);
      },
    );

    testWidgets('Tab and Shift+Tab never leave the panel', (
      WidgetTester t,
    ) async {
      // Two tabbables: the header's built-in close X and the manual Done.
      await t.pumpWidget(host(sheet()));
      await t.tap(find.text('Open sheet'));
      await t.pumpAndSettle();
      final Element panel = t.element(find.byType(SheetContent));

      for (int i = 0; i < 6; i++) {
        await t.sendKeyEvent(LogicalKeyboardKey.tab);
        await t.pump();
        expect(
          _isInside(FocusManager.instance.primaryFocus, panel),
          isTrue,
          reason: 'Tab #$i escaped the panel',
        );
      }
      await t.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
      for (int i = 0; i < 6; i++) {
        await t.sendKeyEvent(LogicalKeyboardKey.tab);
        await t.pump();
        expect(
          _isInside(FocusManager.instance.primaryFocus, panel),
          isTrue,
          reason: 'Shift+Tab #$i escaped the panel',
        );
      }
      await t.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
    });

    testWidgets('a tap on the scrim closes it — SheetOverlay leaves '
        'dismissOnOverlayTap at its default (true), unlike AlertDialog', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(host(sheet()));
      await t.tap(find.text('Open sheet'));
      await t.pumpAndSettle();

      await t.tapAt(const Offset(5, 5));
      await t.pumpAndSettle();
      expect(find.byType(SheetContent), findsNothing);
    });

    testWidgets('the header title reads, and so does the Done control', (
      WidgetTester t,
    ) async {
      final SemanticsHandle handle = t.ensureSemantics();
      await t.pumpWidget(host(sheet()));
      await t.tap(find.text('Open sheet'));
      await t.pumpAndSettle();

      expect(find.bySemanticsLabel('Filters'), findsOneWidget);
      // Two nodes carry the label: the merged container and the raw text's
      // own auto-generated one — either is proof a reader hears "Done".
      expect(find.bySemanticsLabel('Done'), findsWidgets);
      handle.dispose();
    });
  });

  group('Drawer', () {
    Widget drawer({bool triggerEnabled = true}) => Drawer(
      trigger: (BuildContext context, VoidCallback open) => Button(
        label: 'Open drawer',
        onPressed: triggerEnabled ? open : null,
        child: const Text('Open drawer'),
      ),
      content: (BuildContext context, VoidCallback close) => DrawerContent(
        children: <Widget>[
          DrawerHeader(children: <Widget>[DrawerTitle('Add pack')]),
          Press(
            onTap: close,
            semanticLabel: 'Close',
            child: const Text('Close'),
          ),
        ],
      ),
    );

    testWidgets('Escape closes it and focus returns to the trigger', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(host(drawer()));
      await t.sendKeyEvent(LogicalKeyboardKey.tab);
      await t.pumpAndSettle();
      final FocusNode? trigger = FocusManager.instance.primaryFocus;

      await t.tap(find.text('Open drawer'));
      await t.pumpAndSettle();
      expect(find.byType(DrawerContent), findsOneWidget);

      await t.sendKeyEvent(LogicalKeyboardKey.escape);
      await t.pumpAndSettle();
      expect(find.byType(DrawerContent), findsNothing);
      expect(FocusManager.instance.primaryFocus, trigger);
    });

    testWidgets('a disabled trigger does not open it', (WidgetTester t) async {
      await t.pumpWidget(host(drawer(triggerEnabled: false)));
      await t.tap(find.text('Open drawer'), warnIfMissed: false);
      await t.pumpAndSettle();
      expect(find.byType(DrawerContent), findsNothing);
    });

    testWidgets(
      'focus returns to the trigger once the footer Close closes it',
      (WidgetTester t) async {
        await t.pumpWidget(host(drawer()));
        await t.sendKeyEvent(LogicalKeyboardKey.tab);
        await t.pumpAndSettle();
        final FocusNode? trigger = FocusManager.instance.primaryFocus;

        await t.tap(find.text('Open drawer'));
        await t.pumpAndSettle();
        await t.tap(find.text('Close'));
        await t.pumpAndSettle();

        expect(find.byType(DrawerContent), findsNothing);
        expect(FocusManager.instance.primaryFocus, trigger);
      },
    );

    testWidgets(
      'opening moves focus onto a descendant of the panel, not merely off '
      'the trigger',
      (WidgetTester t) async {
        await t.pumpWidget(host(drawer()));
        await t.tap(find.text('Open drawer'));
        await t.pumpAndSettle();
        final Element panel = t.element(find.byType(DrawerContent));
        expect(_isInside(FocusManager.instance.primaryFocus, panel), isTrue);
      },
    );

    testWidgets(
      'Tab and Shift+Tab never leave the panel — the footer Close is the '
      'only tabbable, so the trap has one item to stay on rather than '
      'cycle across',
      (WidgetTester t) async {
        await t.pumpWidget(host(drawer()));
        await t.tap(find.text('Open drawer'));
        await t.pumpAndSettle();
        final Element panel = t.element(find.byType(DrawerContent));

        for (int i = 0; i < 4; i++) {
          await t.sendKeyEvent(LogicalKeyboardKey.tab);
          await t.pump();
          expect(
            _isInside(FocusManager.instance.primaryFocus, panel),
            isTrue,
            reason: 'Tab #$i escaped the panel',
          );
        }
        await t.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
        for (int i = 0; i < 4; i++) {
          await t.sendKeyEvent(LogicalKeyboardKey.tab);
          await t.pump();
          expect(
            _isInside(FocusManager.instance.primaryFocus, panel),
            isTrue,
            reason: 'Shift+Tab #$i escaped the panel',
          );
        }
        await t.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
      },
    );

    testWidgets(
      'a tap on the scrim closes it — Drawer leaves dismissOnOverlayTap at '
      'its default (true) too; drag-to-dismiss is a second, separate path '
      'this file does not exercise',
      (WidgetTester t) async {
        await t.pumpWidget(host(drawer()));
        await t.tap(find.text('Open drawer'));
        await t.pumpAndSettle();

        await t.tapAt(const Offset(5, 5));
        await t.pumpAndSettle();
        expect(find.byType(DrawerContent), findsNothing);
      },
    );

    testWidgets(
      'the title reads, and so does the footer Close — the drag handle is '
      'purely visual and carries no semantic role of its own',
      (WidgetTester t) async {
        final SemanticsHandle handle = t.ensureSemantics();
        await t.pumpWidget(host(drawer()));
        await t.tap(find.text('Open drawer'));
        await t.pumpAndSettle();

        expect(find.bySemanticsLabel('Add pack'), findsOneWidget);
        // Two nodes carry the label — see the sheet's equivalent test.
        expect(find.bySemanticsLabel('Close'), findsWidgets);
        handle.dispose();
      },
    );

    testWidgets(
      'disposes cleanly if torn down mid-drag, with the drag recognizer '
      'and the portal both live',
      (WidgetTester t) async {
        await t.pumpWidget(host(drawer()));
        await t.tap(find.text('Open drawer'));
        await t.pumpAndSettle();

        final TestGesture gesture = await t.startGesture(
          t.getCenter(find.byType(DrawerContent)),
        );
        await gesture.moveBy(const Offset(0, 40));
        await t.pump();

        await t.pumpWidget(host(const SizedBox.shrink()));
        await t.pumpAndSettle();
        expect(t.takeException(), isNull);
      },
    );

    testWidgets('the panel scopes its own route', (WidgetTester t) async {
      final SemanticsHandle handle = t.ensureSemantics();
      await t.pumpWidget(host(drawer()));
      await t.tap(find.text('Open drawer'));
      await t.pumpAndSettle();

      expect(
        t
            .widgetList<Semantics>(find.byType(Semantics))
            .any((Semantics s) => s.properties.scopesRoute ?? false),
        isTrue,
      );
      handle.dispose();
    });
  });
}
