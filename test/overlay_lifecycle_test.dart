/// What an overlay owes the reader it borrowed the page from.
///
/// Opening one is the easy half. The half that gets skipped is the return: a
/// modal that takes the focus and never gives it back leaves the next Tab
/// starting from the top of the document, and a scrim that stops the pointer
/// and nothing else leaves a screen reader free to walk straight out of the
/// modal it was never told had opened.
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

/// A dialog behind a named trigger, so the focus can be watched leaving and
/// coming back.
Widget dialog({bool dismissOnOverlayTap = true}) => OverlayPortal(
  dismissOnOverlayTap: dismissOnOverlayTap,
  transition: (BuildContext context, Animation<double> a, Widget child) =>
      child,
  trigger: (BuildContext context, VoidCallback open) =>
      Press(onTap: open, semanticLabel: 'Open', child: const Text('Open')),
  content: (BuildContext context, VoidCallback close) => DialogContent(
    showCloseButton: false,
    children: <Widget>[
      Press(onTap: close, semanticLabel: 'Close', child: const Text('Close')),
    ],
  ),
);

/// A dialog with two named focusable controls, for the trap test below —
/// [dialog]'s single `Close` is not enough to prove Tab is actually being
/// walked rather than merely refusing to leave a one-item scope.
Widget dialogWithTwoFocusables() => OverlayPortal(
  transition: (BuildContext context, Animation<double> a, Widget child) =>
      child,
  trigger: (BuildContext context, VoidCallback open) =>
      Press(onTap: open, semanticLabel: 'Open', child: const Text('Open')),
  content: (BuildContext context, VoidCallback close) => DialogContent(
    showCloseButton: false,
    children: <Widget>[
      Press(onTap: () {}, semanticLabel: 'First', child: const Text('First')),
      Press(onTap: close, semanticLabel: 'Close', child: const Text('Close')),
    ],
  ),
);

/// Whether [node]'s context sits inside the element subtree rooted at
/// [ancestor] — proof that focus landed INSIDE the overlay's own content, not
/// merely somewhere that happens not to be the trigger. [OverlayPortal]'s own
/// doc promises the overlay child stays a child of the portal in the
/// **element** tree, which is what makes this ancestor walk meaningful.
bool isInside(FocusNode? node, Element ancestor) {
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
  group('A modal gives the focus back', () {
    testWidgets('closing returns it to the trigger it was opened from', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(host(dialog()));
      await t.sendKeyEvent(LogicalKeyboardKey.tab);
      await t.pumpAndSettle();
      final FocusNode? trigger = FocusManager.instance.primaryFocus;
      expect(trigger, isNotNull);

      await t.tap(find.text('Open'));
      await t.pumpAndSettle();
      expect(FocusManager.instance.primaryFocus, isNot(trigger));

      await t.tap(find.text('Close'));
      await t.pumpAndSettle();

      expect(FocusManager.instance.primaryFocus, trigger);
    });

    testWidgets('Escape closes, and the focus comes back with it', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(host(dialog()));
      await t.sendKeyEvent(LogicalKeyboardKey.tab);
      await t.pumpAndSettle();
      final FocusNode? trigger = FocusManager.instance.primaryFocus;

      await t.tap(find.text('Open'));
      await t.pumpAndSettle();
      await t.sendKeyEvent(LogicalKeyboardKey.escape);
      await t.pumpAndSettle();

      expect(find.text('Close'), findsNothing);
      expect(FocusManager.instance.primaryFocus, trigger);
    });

    testWidgets(
      'opening moves focus onto a descendant of the content, not merely '
      'off the trigger',
      (WidgetTester t) async {
        await t.pumpWidget(host(dialog()));
        await t.tap(find.text('Open'));
        await t.pumpAndSettle();

        final Element content = t.element(find.byType(DialogContent));
        expect(
          isInside(FocusManager.instance.primaryFocus, content),
          isTrue,
          reason:
              'Radix moves focus to the first tabbable child inside the '
              'panel, not just anywhere off the trigger',
        );
      },
    );

    testWidgets('Tab and Shift+Tab keep the focus inside the panel', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(host(dialogWithTwoFocusables()));
      await t.tap(find.text('Open'));
      await t.pumpAndSettle();
      final Element content = t.element(find.byType(DialogContent));

      for (int i = 0; i < 6; i++) {
        await t.sendKeyEvent(LogicalKeyboardKey.tab);
        await t.pump();
        expect(
          isInside(FocusManager.instance.primaryFocus, content),
          isTrue,
          reason: 'Tab #$i escaped the panel',
        );
      }

      await t.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
      for (int i = 0; i < 6; i++) {
        await t.sendKeyEvent(LogicalKeyboardKey.tab);
        await t.pump();
        expect(
          isInside(FocusManager.instance.primaryFocus, content),
          isTrue,
          reason: 'Shift+Tab #$i escaped the panel',
        );
      }
      await t.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
    });
  });

  group('A modal is modal to a screen reader too', () {
    testWidgets('the page behind an open dialog is blocked', (
      WidgetTester t,
    ) async {
      final SemanticsHandle handle = t.ensureSemantics();
      await t.pumpWidget(host(dialog()));

      final int before = t.widgetList(find.byType(BlockSemantics)).length;
      await t.tap(find.text('Open'));
      await t.pumpAndSettle();

      expect(
        t.widgetList(find.byType(BlockSemantics)).length,
        before + 1,
        reason: 'the modal lays one of its own over the page it covers',
      );
      handle.dispose();
    });

    testWidgets('the panel scopes the route and reads its children apart', (
      WidgetTester t,
    ) async {
      final SemanticsHandle handle = t.ensureSemantics();
      await t.pumpWidget(host(dialog()));
      await t.tap(find.text('Open'));
      await t.pumpAndSettle();

      expect(
        t
            .widgetList<Semantics>(find.byType(Semantics))
            .any(
              (Semantics s) =>
                  (s.properties.scopesRoute ?? false) &&
                  s.excludeSemantics == false,
            ),
        isTrue,
      );
      handle.dispose();
    });

    testWidgets('a dismissible scrim is a named control, and an inert one is '
        'not', (WidgetTester t) async {
      final SemanticsHandle handle = t.ensureSemantics();

      await t.pumpWidget(host(dialog()));
      await t.tap(find.text('Open'));
      await t.pumpAndSettle();
      expect(
        t
            .widgetList<Semantics>(find.byType(Semantics))
            .any((Semantics s) => s.properties.label == 'Dismiss'),
        isTrue,
      );

      // A clean tree: the dialog above is still open, and its scrim would
      // swallow the tap that is meant to open the second one.
      await t.pumpWidget(host(const SizedBox.shrink()));
      await t.pumpAndSettle();
      await t.pumpWidget(host(dialog(dismissOnOverlayTap: false)));
      await t.tap(find.text('Open'));
      await t.pumpAndSettle();
      expect(find.text('Close'), findsOneWidget);
      expect(
        t
            .widgetList<Semantics>(find.byType(Semantics))
            .any((Semantics s) => s.properties.label == 'Dismiss'),
        isFalse,
        reason: 'a scrim that dismisses nothing is not a dismiss button',
      );
      handle.dispose();
    });
  });

  testWidgets('an overlay that never opened still disposes cleanly', (
    WidgetTester t,
  ) async {
    await t.pumpWidget(host(dialog()));
    await t.pumpWidget(host(const SizedBox.shrink()));
    await t.pumpAndSettle();

    expect(t.takeException(), isNull);
  });
}
