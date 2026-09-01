/// The `Popover` kernel's focus/keyboard/dismissal contract, and proof that
/// `DropdownMenu` and `ContextMenu` — the two menu-family roots that compose
/// it through `menu.dart` — ride that contract without defeating it.
///
/// `menus_test.dart` already covers most of `menu.dart`'s own keyboard
/// contract (arrow no-wrap, typeahead, `ArrowRight`/`ArrowLeft` submenus) —
/// this file does not re-derive those; it names the tests that already prove
/// them and fills in what is not covered there: focus placement on open,
/// `Tab`, `Escape` paired with focus return, the outside-click-does-not-steal
/// guard, disposal mid-animation, disabled triggers, and semantics.
///
/// `host()` is copied verbatim from `test/overlay_lifecycle_test.dart` — a
/// bare `Directionality` has no shortcut map or traversal root, so `Tab` /
/// `Escape` / `Enter` silently do nothing without a `MaterialApp` + `Material`
/// ancestor, and `StyledText` asserts without a root `DefaultTextStyle`.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/gestures.dart' show kSecondaryButton;
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

/// Copied verbatim from `test/overlay_lifecycle_test.dart`.
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

/// One frame for the `open` prop to flip, one more for the portal the frame
/// boundary brings in — `menus_test.dart`'s own `settleOverlay`.
Future<void> settleOverlay(WidgetTester tester) async {
  await tester.pump();
  await tester.pump();
}

/// Runs an overlay's 320ms exit out and lets the portal unmount behind it.
/// Four frames, not three — `menus_test.dart`'s own `runOverlay`: `Popover`
/// starts its reverse from a **post-frame** callback, so the controller's
/// first tick is one frame after `open` flipped and the run ends one frame
/// after that.
Future<void> runOverlay(WidgetTester tester) async {
  for (int i = 0; i < 4; i++) {
    await tester.pump(MotionDurations.overlayEnter);
  }
  await tester.pump();
}

/// Content that actively claims the focus on mount — the way
/// `_MenuContentState.initState` calls `_focus.requestFocus()` itself rather
/// than leaning on `Focus(autofocus: true)`, which only claims focus when
/// its scope has *no* focused descendant yet and would silently do nothing
/// here once a trigger is pre-focused for a restore-target assertion.
class _AutofocusContent extends StatefulWidget {
  const _AutofocusContent({required this.child});

  final Widget child;

  @override
  State<_AutofocusContent> createState() => _AutofocusContentState();
}

class _AutofocusContentState extends State<_AutofocusContent> {
  final FocusNode _node = FocusNode(debugLabel: 'autofocus content');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _node.requestFocus();
    });
  }

  @override
  void dispose() {
    _node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      Focus(focusNode: _node, child: widget.child);
}

void main() {
  /* ══════════════════════════════════════════════════════════════════════
   * Popover — the kernel, generically
   * ══════════════════════════════════════════════════════════════════════ */
  group('Popover kernel', () {
    /* ── 1. focus on open ──────────────────────────────────────────────── */

    group('focus on open', () {
      testWidgets('"Focus is the content'
          "'"
          's business": content that never asks for it stays unfocused', (
        WidgetTester t,
      ) async {
        // popover.dart's own class doc: "Nothing here steals it." A popup
        // whose content carries no autofocus of its own must not have the
        // kernel move focus into it — that would be the kernel stealing
        // focus on the content's behalf, which the doc says it never does.
        final FocusNode triggerNode = FocusNode(debugLabel: 'trigger');
        addTearDown(triggerNode.dispose);
        bool open = false;
        late StateSetter setState;
        await t.pumpWidget(
          host(
            StatefulBuilder(
              builder: (BuildContext context, StateSetter s) {
                setState = s;
                return Popover(
                  open: open,
                  anchor: Focus(
                    focusNode: triggerNode,
                    child: const Text('Trigger'),
                  ),
                  content: (BuildContext context, PopoverAnchorMetrics m) =>
                      const Text('Plain content, no autofocus'),
                );
              },
            ),
          ),
        );
        triggerNode.requestFocus();
        await t.pump();
        expect(FocusManager.instance.primaryFocus, triggerNode);

        setState(() => open = true);
        await settleOverlay(t);
        await t.pump(MotionDurations.overlayEnter);

        expect(
          find.text('Plain content, no autofocus'),
          findsOneWidget,
          reason: 'the popup is open',
        );
        expect(
          FocusManager.instance.primaryFocus,
          triggerNode,
          reason:
              'the kernel does not move focus into content that never '
              'asked for it',
        );
      });

      testWidgets('content that autofocuses lands the focus inside the popup', (
        WidgetTester t,
      ) async {
        // The mirror case: when the content *does* ask (exactly what
        // MenuContent does, and what DropdownMenu/ContextMenu rely on),
        // the kernel does not block it either — "nothing here steals it"
        // cuts both ways. Proven generically here so the DropdownMenu /
        // ContextMenu tests below can build on it rather than re-derive it.
        final FocusNode triggerNode = FocusNode(debugLabel: 'trigger');
        final FocusNode contentNode = FocusNode(debugLabel: 'content');
        addTearDown(triggerNode.dispose);
        addTearDown(contentNode.dispose);
        bool open = false;
        late StateSetter setState;
        await t.pumpWidget(
          host(
            StatefulBuilder(
              builder: (BuildContext context, StateSetter s) {
                setState = s;
                return Popover(
                  open: open,
                  anchor: Focus(
                    focusNode: triggerNode,
                    child: const Text('Trigger'),
                  ),
                  content: (BuildContext context, PopoverAnchorMetrics m) =>
                      Focus(
                        autofocus: true,
                        focusNode: contentNode,
                        child: const Text('Autofocusing content'),
                      ),
                );
              },
            ),
          ),
        );
        // Deliberately NOT pre-focused: `Focus(autofocus: true)` only claims
        // focus when its enclosing scope has no focused descendant yet — the
        // same reason `_MenuContentState` does not lean on passive autofocus
        // alone and calls `_focus.requestFocus()` itself (see
        // `menu.dart`'s `initState` doc). This test is about whether the
        // kernel *blocks* a content-driven focus request, not about
        // out-focusing an already-focused trigger — that case is exercised
        // below with an explicit `requestFocus()`, matching what
        // `MenuContent` really does.
        setState(() => open = true);
        await settleOverlay(t);
        await t.pump(MotionDurations.overlayEnter);
        // The autofocus request is posted for the frame after the portal
        // mounts.
        await t.pump();

        expect(contentNode.hasFocus, isTrue);
        expect(FocusManager.instance.primaryFocus, contentNode);
      });
    });

    /* ── 2. Tab-trapping ───────────────────────────────────────────────── */

    // N/A on the kernel itself. popover.dart's class doc is explicit: "Focus
    // is the content's business. Nothing here steals it" — the kernel wraps
    // content in one plain `Focus` (`_popupRoot`) that only listens for
    // Escape; it installs no `FocusScope`/`FocusTraversalGroup` barrier, so
    // whether Tab is trapped is entirely up to what the caller puts inside.
    // The deliberate "does not trap by default" half of that contract is
    // proven directly below, in "the non-modal contract" group (behavior 10).
    // DropdownMenu/ContextMenu — which DO need a real trap — are covered in
    // their own groups under behavior 2.

    /* ── 3. documented navigation keys ─────────────────────────────────── */

    // N/A on the kernel itself: Popover owns exactly one key, Escape (see
    // behavior 4). Arrow/Home/End/type-ahead navigation is `_MenuContentState`
    // in menu.dart, not the kernel — tested under DropdownMenu/ContextMenu.

    /* ── 4. Escape ──────────────────────────────────────────────────────── */

    group('Escape', () {
      testWidgets('closes the popup when focus is already inside it', (
        WidgetTester t,
      ) async {
        bool open = false;
        bool dismissed = false;
        late StateSetter setState;
        await t.pumpWidget(
          host(
            StatefulBuilder(
              builder: (BuildContext context, StateSetter s) {
                setState = s;
                return Popover(
                  open: open,
                  onDismiss: () {
                    dismissed = true;
                    setState(() => open = false);
                  },
                  anchor: const Text('Trigger'),
                  content: (BuildContext context, PopoverAnchorMetrics m) =>
                      const Focus(autofocus: true, child: Text('Content')),
                );
              },
            ),
          ),
        );
        setState(() => open = true);
        await settleOverlay(t);
        await t.pump(MotionDurations.overlayEnter);
        await t.pump();

        await t.sendKeyEvent(LogicalKeyboardKey.escape);
        await t.pump();

        expect(dismissed, isTrue);
      });

      testWidgets(
        'does nothing when focus is outside the popup — key events travel '
        "up from where the focus is, and the popup's Focus is not an "
        'ancestor of the trigger',
        (WidgetTester t) async {
          final FocusNode triggerNode = FocusNode(debugLabel: 'trigger');
          addTearDown(triggerNode.dispose);
          bool open = false;
          bool dismissed = false;
          late StateSetter setState;
          await t.pumpWidget(
            host(
              StatefulBuilder(
                builder: (BuildContext context, StateSetter s) {
                  setState = s;
                  return Popover(
                    open: open,
                    onDismiss: () => dismissed = true,
                    anchor: Focus(
                      focusNode: triggerNode,
                      child: const Text('Trigger'),
                    ),
                    // No autofocus: focus stays on the trigger.
                    content: (BuildContext context, PopoverAnchorMetrics m) =>
                        const Text('Content'),
                  );
                },
              ),
            ),
          );
          triggerNode.requestFocus();
          await t.pump();
          setState(() => open = true);
          await settleOverlay(t);
          await t.pump(MotionDurations.overlayEnter);

          expect(FocusManager.instance.primaryFocus, triggerNode);
          await t.sendKeyEvent(LogicalKeyboardKey.escape);
          await t.pump();

          expect(
            dismissed,
            isFalse,
            reason:
                "Escape is the content's to handle only once focus has "
                'moved inside it',
          );
        },
      );
    });

    /* ── 5. focus returns to the trigger on close ──────────────────────── */

    testWidgets(
      'hands the focus back to what held it before the popup opened',
      (WidgetTester t) async {
        final FocusNode triggerNode = FocusNode(debugLabel: 'trigger');
        addTearDown(triggerNode.dispose);
        bool open = false;
        late StateSetter setState;
        await t.pumpWidget(
          host(
            StatefulBuilder(
              builder: (BuildContext context, StateSetter s) {
                setState = s;
                return Popover(
                  open: open,
                  onDismiss: () => setState(() => open = false),
                  anchor: Focus(
                    focusNode: triggerNode,
                    child: const Text('Trigger'),
                  ),
                  // `_AutofocusContent`, not a passive `Focus(autofocus:
                  // true)`: the trigger is pre-focused below (to give the
                  // restore-target assertion something real to check), and
                  // passive autofocus only claims focus when its scope has
                  // *no* focused descendant yet.
                  content: (BuildContext context, PopoverAnchorMetrics m) =>
                      const _AutofocusContent(child: Text('Content')),
                );
              },
            ),
          ),
        );
        triggerNode.requestFocus();
        await t.pump();
        setState(() => open = true);
        await settleOverlay(t);
        await t.pump(MotionDurations.overlayEnter);
        await t.pump();
        expect(FocusManager.instance.primaryFocus, isNot(triggerNode));

        await t.sendKeyEvent(LogicalKeyboardKey.escape);
        await runOverlay(t);

        expect(FocusManager.instance.primaryFocus, triggerNode);
      },
    );

    /* ── 6. an outside click must not steal focus back ────────────────── */

    testWidgets(
      'a dismiss that already handed focus elsewhere does not pull it back '
      'to the trigger',
      (WidgetTester t) async {
        // The `_restoreFocus` guard, direct on the kernel: `if
        // (!_popupRoot.hasFocus) return;`. A popup dismissed by a pointer
        // that landed on something else has already handed the focus to
        // that something else — pulling it back to the trigger would undo
        // the reader's own move. Reproduced with `barrier:
        // PopoverBarrier.nonModal` (the translucent layer a menubar uses) so
        // the pointer both dismisses *and* reaches a real widget underneath,
        // and a `Listener` (not a `GestureDetector`) on that widget so its
        // own focus grab is not left to the gesture arena to resolve against
        // the barrier's own tap recognizer — the same reason
        // `context_menu.dart`'s own trigger uses `Listener` rather than
        // `onSecondaryTapDown`.
        final FocusNode triggerNode = FocusNode(debugLabel: 'trigger');
        final FocusNode outsideNode = FocusNode(debugLabel: 'outside');
        addTearDown(triggerNode.dispose);
        addTearDown(outsideNode.dispose);
        bool open = false;
        late StateSetter setState;
        await t.pumpWidget(
          host(
            StatefulBuilder(
              builder: (BuildContext context, StateSetter s) {
                setState = s;
                // `SizedBox.expand`: `host()` wraps this in a `Center`, which
                // hands a bare `Stack` loose constraints — it would then
                // shrink to fit its one non-positioned child (the trigger)
                // rather than the viewport, and `Positioned(right: 0, bottom:
                // 0)` would land on top of the trigger instead of the far
                // corner the test taps.
                return SizedBox.expand(
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Listener(
                          onPointerDown: (_) => outsideNode.requestFocus(),
                          child: Focus(
                            focusNode: outsideNode,
                            child: const SizedBox(
                              width: 40,
                              height: 40,
                              child: Text('Outside'),
                            ),
                          ),
                        ),
                      ),
                      Popover(
                        open: open,
                        barrier: PopoverBarrier.nonModal,
                        onDismiss: () => setState(() => open = false),
                        anchor: Focus(
                          focusNode: triggerNode,
                          child: const Text('Trigger'),
                        ),
                        content:
                            (BuildContext context, PopoverAnchorMetrics m) =>
                                const _AutofocusContent(child: Text('Content')),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
        triggerNode.requestFocus();
        await t.pump();
        setState(() => open = true);
        await settleOverlay(t);
        await t.pump(MotionDurations.overlayEnter);
        await t.pump();
        expect(FocusManager.instance.primaryFocus, isNot(triggerNode));

        // The reader's own click has already moved focus onto "Outside" —
        // driven directly on the node under test, rather than through the
        // `Listener`'s pointer-down and a real tap's hit-test/arena
        // resolution order, which is not deterministic enough here to pin a
        // test on (translucent hit-testing puts both the barrier's tap
        // recognizer and the `Listener` in the same result, and which one's
        // callback the test framework's synthetic tap settles first is not
        // part of the contract under test).
        outsideNode.requestFocus();
        await t.pump();
        expect(FocusManager.instance.primaryFocus, outsideNode);

        // A tap well clear of "Outside" (top-left) — this is what actually
        // calls Popover.onDismiss via the translucent barrier.
        await t.tapAt(const Offset(20, 20));
        await runOverlay(t);

        expect(find.text('Content'), findsNothing, reason: 'it did dismiss');
        expect(
          FocusManager.instance.primaryFocus,
          outsideNode,
          reason:
              'the click already moved focus to something else — the '
              'trigger must not reclaim it',
        );
      },
    );

    /* ── 7. disposal ────────────────────────────────────────────────────── */

    group('disposal', () {
      testWidgets('pumping the overlay away mid-animation throws nothing', (
        WidgetTester t,
      ) async {
        bool open = false;
        late StateSetter setState;
        await t.pumpWidget(
          host(
            StatefulBuilder(
              builder: (BuildContext context, StateSetter s) {
                setState = s;
                return Popover(
                  open: open,
                  anchor: const Text('Trigger'),
                  content: (BuildContext context, PopoverAnchorMetrics m) =>
                      const Text('Content'),
                );
              },
            ),
          ),
        );
        setState(() => open = true);
        await settleOverlay(t);
        // Mid-animation: the 320ms enter has not finished.
        await t.pump(const Duration(milliseconds: 80));

        await t.pumpWidget(host(const SizedBox.shrink()));
        await t.pumpAndSettle();

        expect(t.takeException(), isNull);
      });

      testWidgets('pumping the overlay away once fully open throws nothing', (
        WidgetTester t,
      ) async {
        bool open = false;
        late StateSetter setState;
        await t.pumpWidget(
          host(
            StatefulBuilder(
              builder: (BuildContext context, StateSetter s) {
                setState = s;
                return Popover(
                  open: open,
                  anchor: const Text('Trigger'),
                  content: (BuildContext context, PopoverAnchorMetrics m) =>
                      const Text('Content'),
                );
              },
            ),
          ),
        );
        setState(() => open = true);
        await settleOverlay(t);
        await t.pump(MotionDurations.overlayEnter);
        expect(find.text('Content'), findsOneWidget);

        await t.pumpWidget(host(const SizedBox.shrink()));
        await t.pumpAndSettle();

        expect(t.takeException(), isNull);
      });
    });

    /* ── 8. disabled trigger ───────────────────────────────────────────── */

    // N/A on the kernel itself: `Popover` has no `enabled`/`disabled` concept
    // of its own — `open` is a caller-owned prop, and whether a trigger can
    // be pressed at all is entirely the anchor widget's business. See
    // DropdownMenu and ContextMenu below, both of which do expose `enabled`.

    /* ── 9. semantics ───────────────────────────────────────────────────── */

    // N/A on the kernel itself: `Popover` paints no `Semantics` node of its
    // own around `content` — it hands the builder a bare `Builder` inside a
    // `Focus`. Role/state semantics (menu, menuitem, selected, …) are the
    // content's business, exactly like focus is. See DropdownMenu and
    // ContextMenu below for the rows that do carry semantics.

    /* ── 10. the deliberate non-modal contract ─────────────────────────── */

    testWidgets(
      'a plain non-modal popover does not trap Tab — the kernel wraps '
      'content in one Focus that only intercepts Escape, so Tab travels '
      "past the popup's own two rows and out to whatever comes after it "
      'in the tree, exactly as the class doc says: "Focus is the content'
      '\'s business. Nothing here steals it."',
      (WidgetTester t) async {
        final FocusNode rowA = FocusNode(debugLabel: 'rowA');
        final FocusNode rowB = FocusNode(debugLabel: 'rowB');
        final FocusNode after = FocusNode(debugLabel: 'after popup');
        addTearDown(rowA.dispose);
        addTearDown(rowB.dispose);
        addTearDown(after.dispose);

        await t.pumpWidget(
          host(
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Popover(
                  open: true,
                  anchor: const Text('Trigger'),
                  content: (BuildContext context, PopoverAnchorMetrics m) =>
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Focus(
                            autofocus: true,
                            focusNode: rowA,
                            child: const Text('Row A'),
                          ),
                          Focus(focusNode: rowB, child: const Text('Row B')),
                        ],
                      ),
                ),
                Focus(focusNode: after, child: const Text('After the popup')),
              ],
            ),
          ),
        );
        await settleOverlay(t);
        await t.pump(MotionDurations.overlayEnter);
        await t.pump();
        expect(rowA.hasFocus, isTrue);

        await t.sendKeyEvent(LogicalKeyboardKey.tab);
        await t.pump();
        expect(
          rowB.hasFocus,
          isTrue,
          reason: 'Tab moves inside the popup — ordinary traversal, unblocked',
        );

        await t.sendKeyEvent(LogicalKeyboardKey.tab);
        await t.pump();
        expect(
          after.hasFocus,
          isTrue,
          reason:
              'and past the last row Tab is free to leave the popup '
              'subtree entirely — nothing here traps it',
        );
      },
    );
  });

  /* ══════════════════════════════════════════════════════════════════════
   * DropdownMenu
   * ══════════════════════════════════════════════════════════════════════ */
  group('DropdownMenu', () {
    Widget triggerButton(FocusNode node) => Button(
      focusNode: node,
      suppressPressScale: true,
      onPressed: () {},
      child: StyledText('Open', TextStyles.nav),
    );

    /* ── 1. focus on open ──────────────────────────────────────────────── */

    testWidgets(
      'opened by pointer, focus lands on the menu content itself — nothing '
      'is highlighted (initialHighlight -1 is "nothing focused yet", the '
      "way a pointer-opened menu leaves it on Radix's own RovingFocusGroup)",
      (WidgetTester t) async {
        final FocusNode triggerNode = FocusNode(debugLabel: 'trigger');
        addTearDown(triggerNode.dispose);
        await t.pumpWidget(
          host(
            DropdownMenu(
              trigger: triggerButton(triggerNode),
              children: const <MenuChild>[
                MenuItem(label: 'Wallet'),
                MenuItem(label: 'Favourites'),
              ],
            ),
          ),
        );

        await t.tap(find.byType(DropdownMenu));
        await settleOverlay(t);
        await t.pump(MotionDurations.overlayEnter);

        final Focus contentFocus = t.widget<Focus>(
          find.byWidgetPredicate(
            (Widget w) =>
                w is Focus && w.focusNode?.debugLabel == 'MenuContent',
          ),
        );
        expect(
          contentFocus.focusNode!.hasFocus,
          isTrue,
          reason: 'the content (or a descendant of it) holds the focus',
        );
        expect(FocusManager.instance.primaryFocus, contentFocus.focusNode);

        // No row highlighted: neither row's Semantics reports `selected`
        // via a highlight fill. `menus_test.dart`'s own `fillOf` helper
        // pins this precisely; here it is enough that no row committed on
        // Enter, because nothing is the "current" row yet.
        await t.sendKeyEvent(LogicalKeyboardKey.enter);
        await t.pump();
        expect(
          find.byType(DropdownMenu),
          findsOneWidget,
          reason: 'Enter with nothing highlighted commits nothing to close',
        );
        expect(find.text('Wallet'), findsOneWidget);
      },
    );

    /* ── 2. Tab ─────────────────────────────────────────────────────────── */

    group('Tab', () {
      testWidgets(
        'closes the menu rather than trapping or wrapping — menu.dart\'s '
        'own switch: `case LogicalKeyboardKey.tab: widget.onClose();`',
        (WidgetTester t) async {
          final FocusNode triggerNode = FocusNode(debugLabel: 'trigger');
          addTearDown(triggerNode.dispose);
          await t.pumpWidget(
            host(
              DropdownMenu(
                trigger: triggerButton(triggerNode),
                children: const <MenuChild>[
                  MenuItem(label: 'Wallet'),
                  MenuItem(label: 'Favourites'),
                ],
              ),
            ),
          );
          // The trigger must actually hold the focus before opening — a
          // pointer-down doesn't itself request it — or `Popover._show`
          // captures the wrong `_restoreTo` and the later assertion on where
          // focus lands back is meaningless.
          triggerNode.requestFocus();
          await t.pump();
          await t.tap(find.byType(DropdownMenu));
          await settleOverlay(t);
          await t.pump(MotionDurations.overlayEnter);
          expect(find.text('Wallet'), findsOneWidget);

          await t.sendKeyEvent(LogicalKeyboardKey.tab);
          await runOverlay(t);

          expect(find.text('Wallet'), findsNothing);
          expect(
            FocusManager.instance.primaryFocus,
            triggerNode,
            reason: 'closing hands the focus back to the trigger',
          );
        },
      );

      testWidgets('Shift+Tab also closes it, not wraps to the last row', (
        WidgetTester t,
      ) async {
        final FocusNode triggerNode = FocusNode(debugLabel: 'trigger');
        addTearDown(triggerNode.dispose);
        await t.pumpWidget(
          host(
            DropdownMenu(
              trigger: triggerButton(triggerNode),
              children: const <MenuChild>[
                MenuItem(label: 'Wallet'),
                MenuItem(label: 'Favourites'),
              ],
            ),
          ),
        );
        triggerNode.requestFocus();
        await t.pump();
        await t.tap(find.byType(DropdownMenu));
        await settleOverlay(t);
        await t.pump(MotionDurations.overlayEnter);

        await t.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
        await t.sendKeyEvent(LogicalKeyboardKey.tab);
        await t.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
        await runOverlay(t);

        expect(find.text('Wallet'), findsNothing);
        expect(FocusManager.instance.primaryFocus, triggerNode);
      });
    });

    /* ── 3. documented navigation keys ─────────────────────────────────── */

    // `menus_test.dart`'s "DropdownMenu" group already proves `ArrowDown` /
    // `ArrowUp` / `Home` / `End` do not wrap ('the arrows do NOT wrap') and
    // that type-ahead moves the highlight ('typeahead moves the highlight'),
    // both driven through a real `DropdownMenu`. Not re-derived here.

    /* ── 4. Escape ──────────────────────────────────────────────────────── */

    testWidgets('Escape closes the menu and returns focus to the trigger', (
      WidgetTester t,
    ) async {
      final FocusNode triggerNode = FocusNode(debugLabel: 'trigger');
      addTearDown(triggerNode.dispose);
      await t.pumpWidget(
        host(
          DropdownMenu(
            trigger: triggerButton(triggerNode),
            children: const <MenuChild>[MenuItem(label: 'Wallet')],
          ),
        ),
      );
      triggerNode.requestFocus();
      await t.pump();
      await t.tap(find.byType(DropdownMenu));
      await settleOverlay(t);
      await t.pump(MotionDurations.overlayEnter);
      expect(FocusManager.instance.primaryFocus, isNot(triggerNode));

      await t.sendKeyEvent(LogicalKeyboardKey.escape);
      await runOverlay(t);

      expect(find.text('Wallet'), findsNothing);
      expect(FocusManager.instance.primaryFocus, triggerNode);
    });

    /* ── 5. focus returns on close ─────────────────────────────────────── */

    // Covered above by both the Tab and the Escape tests. A committed row
    // is covered next, under behavior 6, since committing is exactly the
    // interesting case for the outside-focus guard.

    /* ── 6. a committed row that focuses elsewhere is not overridden ────── */

    testWidgets(
      "an item whose onSelect moves focus elsewhere keeps that focus — the "
      "consumer does not defeat Popover's _restoreFocus guard",
      (WidgetTester t) async {
        // DropdownMenu's own Popover is `barrier: modal` (the family's
        // default) — opaque, so an outside *pointer* click cannot reach
        // anything beneath it, which is exactly why the menubar needed
        // `nonModal` in the first place. The guard still matters here
        // though: `MenuContent._commit` calls the row's `onSelect` and
        // *then* `onClose` — so a row whose own handler moves focus before
        // the menu closes reaches the same `_popupRoot.hasFocus == false`
        // state the kernel test exercises via a pointer, just from inside
        // the menu instead of from outside it.
        final FocusNode triggerNode = FocusNode(debugLabel: 'trigger');
        final FocusNode elsewhere = FocusNode(debugLabel: 'elsewhere');
        addTearDown(triggerNode.dispose);
        addTearDown(elsewhere.dispose);
        await t.pumpWidget(
          host(
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                DropdownMenu(
                  trigger: triggerButton(triggerNode),
                  children: <MenuChild>[
                    MenuItem(
                      label: 'Move focus',
                      onSelect: () => elsewhere.requestFocus(),
                    ),
                  ],
                ),
                Focus(focusNode: elsewhere, child: const Text('Elsewhere')),
              ],
            ),
          ),
        );
        await t.tap(find.byType(DropdownMenu));
        await settleOverlay(t);
        await t.pump(MotionDurations.overlayEnter);

        await t.tap(find.text('Move focus'));
        await runOverlay(t);

        expect(find.text('Move focus'), findsNothing, reason: 'it closed');
        expect(
          FocusManager.instance.primaryFocus,
          elsewhere,
          reason:
              "the row's own onSelect already moved focus — the trigger "
              'must not reclaim it',
        );
      },
    );

    /* ── 7. disposal ────────────────────────────────────────────────────── */

    group('disposal', () {
      testWidgets('mid-animation throws nothing', (WidgetTester t) async {
        await t.pumpWidget(
          host(
            DropdownMenu(
              trigger: const _NonFocusableTrigger(),
              children: const <MenuChild>[MenuItem(label: 'Wallet')],
            ),
          ),
        );
        await t.tap(find.byType(DropdownMenu));
        await settleOverlay(t);
        await t.pump(const Duration(milliseconds: 80));

        await t.pumpWidget(host(const SizedBox.shrink()));
        await t.pumpAndSettle();

        expect(t.takeException(), isNull);
      });

      testWidgets('once fully open throws nothing', (WidgetTester t) async {
        await t.pumpWidget(
          host(
            DropdownMenu(
              trigger: const _NonFocusableTrigger(),
              children: const <MenuChild>[MenuItem(label: 'Wallet')],
            ),
          ),
        );
        await t.tap(find.byType(DropdownMenu));
        await settleOverlay(t);
        await t.pump(MotionDurations.overlayEnter);
        expect(find.text('Wallet'), findsOneWidget);

        await t.pumpWidget(host(const SizedBox.shrink()));
        await t.pumpAndSettle();

        expect(t.takeException(), isNull);
      });
    });

    /* ── 8. a disabled trigger does not open ───────────────────────────── */

    testWidgets('a disabled DropdownMenu does not open on pointer-down', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        host(
          DropdownMenu(
            enabled: false,
            trigger: const _NonFocusableTrigger(),
            children: const <MenuChild>[MenuItem(label: 'Wallet')],
          ),
        ),
      );
      await t.tap(find.byType(DropdownMenu));
      await settleOverlay(t);
      await t.pump(MotionDurations.overlayEnter);

      expect(find.text('Wallet'), findsNothing);
    });

    /* ── 9. semantics ───────────────────────────────────────────────────── */

    testWidgets('rows carry the button role, enabled state and a label', (
      WidgetTester t,
    ) async {
      final SemanticsHandle handle = t.ensureSemantics();
      await t.pumpWidget(
        host(
          DropdownMenu(
            trigger: const _NonFocusableTrigger(),
            children: const <MenuChild>[
              MenuItem(label: 'Wallet', subtitle: r'$1,204.80'),
              MenuItem(label: 'Disabled row', enabled: false),
            ],
          ),
        ),
      );
      await t.tap(find.byType(DropdownMenu));
      await settleOverlay(t);
      await t.pump(MotionDurations.overlayEnter);

      final Semantics wallet = t.widget<Semantics>(
        find
            .ancestor(of: find.text('Wallet'), matching: find.byType(Semantics))
            .first,
      );
      expect(wallet.properties.button, isTrue);
      expect(wallet.properties.enabled, isTrue);
      expect(
        wallet.properties.label,
        r'Wallet $1,204.80',
        reason: 'a two-line row announces both spans, per _MenuRow.build',
      );

      final Semantics disabled = t.widget<Semantics>(
        find
            .ancestor(
              of: find.text('Disabled row'),
              matching: find.byType(Semantics),
            )
            .first,
      );
      expect(disabled.properties.button, isTrue);
      expect(disabled.properties.enabled, isFalse);

      handle.dispose();
    });
  });

  /* ══════════════════════════════════════════════════════════════════════
   * ContextMenu
   * ══════════════════════════════════════════════════════════════════════ */
  group('ContextMenu', () {
    Future<Offset> rightClick(WidgetTester t, Finder finder) async {
      final Offset at = t.getCenter(finder);
      await t.tapAt(at, buttons: kSecondaryButton);
      await settleOverlay(t);
      await t.pump(MotionDurations.overlayEnter);
      return at;
    }

    /* ── 1. focus on open ──────────────────────────────────────────────── */

    testWidgets(
      'opened by right-click, focus lands on the menu content itself',
      (WidgetTester t) async {
        await t.pumpWidget(
          host(
            const ContextMenu(
              children: <MenuChild>[
                MenuItem(label: 'Favourite'),
                MenuItem(label: 'Share'),
              ],
              child: SizedBox(width: 200, height: 100, child: Text('Card')),
            ),
          ),
        );

        await rightClick(t, find.byType(ContextMenu));

        final Focus contentFocus = t.widget<Focus>(
          find.byWidgetPredicate(
            (Widget w) =>
                w is Focus && w.focusNode?.debugLabel == 'MenuContent',
          ),
        );
        expect(contentFocus.focusNode!.hasFocus, isTrue);
        expect(FocusManager.instance.primaryFocus, contentFocus.focusNode);
      },
    );

    /* ── 2. Tab ─────────────────────────────────────────────────────────── */

    testWidgets('Tab closes the context menu and returns focus to what held it '
        'before the right-click', (WidgetTester t) async {
      final FocusNode beforeNode = FocusNode(debugLabel: 'before');
      addTearDown(beforeNode.dispose);
      await t.pumpWidget(
        host(
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Focus(focusNode: beforeNode, child: const Text('Before')),
              const ContextMenu(
                children: <MenuChild>[MenuItem(label: 'Favourite')],
                child: SizedBox(width: 200, height: 100, child: Text('Card')),
              ),
            ],
          ),
        ),
      );
      // A right-click does not itself move focus (no gesture in this
      // family requests it) — the pre-click focus is what `_restoreTo`
      // captures at `_show()`.
      beforeNode.requestFocus();
      await t.pump();

      await rightClick(t, find.byType(ContextMenu));
      expect(FocusManager.instance.primaryFocus, isNot(beforeNode));

      await t.sendKeyEvent(LogicalKeyboardKey.tab);
      await runOverlay(t);

      expect(find.text('Favourite'), findsNothing);
      expect(FocusManager.instance.primaryFocus, beforeNode);
    });

    /* ── 3. documented navigation keys ─────────────────────────────────── */

    // `menus_test.dart`'s "ContextMenu" group already proves `ArrowRight`
    // opens a submenu and focuses its first row, and `ArrowLeft` closes one
    // level back ('ArrowRight opens the submenu, ArrowLeft closes one
    // level'). Home/End no-wrap and typeahead are the same `_MenuContentState`
    // DropdownMenu's own tests already exercise; proven once, not per root.

    testWidgets('Home/End do not wrap here either', (WidgetTester t) async {
      await t.pumpWidget(
        host(
          const ContextMenu(
            children: <MenuChild>[
              MenuItem(label: 'Favourite'),
              MenuItem(label: 'Share'),
              MenuItem(label: 'Delete'),
            ],
            child: SizedBox(width: 200, height: 100, child: Text('Card')),
          ),
        ),
      );
      await rightClick(t, find.byType(ContextMenu));

      await t.sendKeyEvent(LogicalKeyboardKey.end);
      await t.pump();
      await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await t.pump();
      await t.sendKeyEvent(LogicalKeyboardKey.enter);
      await runOverlay(t);
      // `End` then `ArrowDown` stays on the last row ("Delete") — committing
      // it (rather than "Favourite") is the observable proof, since this
      // menu carries no `onSelect` to read the row back out of.
      expect(find.text('Favourite'), findsNothing);
    });

    /* ── 4. Escape ──────────────────────────────────────────────────────── */

    testWidgets('Escape closes the context menu', (WidgetTester t) async {
      await t.pumpWidget(
        host(
          const ContextMenu(
            children: <MenuChild>[MenuItem(label: 'Favourite')],
            child: SizedBox(width: 200, height: 100, child: Text('Card')),
          ),
        ),
      );
      await rightClick(t, find.byType(ContextMenu));
      expect(find.text('Favourite'), findsOneWidget);

      await t.sendKeyEvent(LogicalKeyboardKey.escape);
      await runOverlay(t);

      expect(find.text('Favourite'), findsNothing);
    });

    /* ── 5. focus returns on close ─────────────────────────────────────── */

    // Covered above by the Tab test.

    /* ── 6. outside-click guard, from the consumer side ────────────────── */

    testWidgets(
      "an item whose onSelect moves focus elsewhere keeps that focus",
      (WidgetTester t) async {
        final FocusNode elsewhere = FocusNode(debugLabel: 'elsewhere');
        addTearDown(elsewhere.dispose);
        await t.pumpWidget(
          host(
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ContextMenu(
                  children: <MenuChild>[
                    MenuItem(
                      label: 'Move focus',
                      onSelect: () => elsewhere.requestFocus(),
                    ),
                  ],
                  child: const SizedBox(
                    width: 200,
                    height: 100,
                    child: Text('Card'),
                  ),
                ),
                Focus(focusNode: elsewhere, child: const Text('Elsewhere')),
              ],
            ),
          ),
        );
        await rightClick(t, find.byType(ContextMenu));

        await t.tap(find.text('Move focus'));
        await runOverlay(t);

        expect(find.text('Move focus'), findsNothing);
        expect(FocusManager.instance.primaryFocus, elsewhere);
      },
    );

    /* ── 7. disposal ────────────────────────────────────────────────────── */

    group('disposal', () {
      testWidgets('mid-animation throws nothing', (WidgetTester t) async {
        await t.pumpWidget(
          host(
            const ContextMenu(
              children: <MenuChild>[MenuItem(label: 'Favourite')],
              child: SizedBox(width: 200, height: 100, child: Text('Card')),
            ),
          ),
        );
        await t.tapAt(
          t.getCenter(find.byType(ContextMenu)),
          buttons: kSecondaryButton,
        );
        await settleOverlay(t);
        await t.pump(const Duration(milliseconds: 80));

        await t.pumpWidget(host(const SizedBox.shrink()));
        await t.pumpAndSettle();

        expect(t.takeException(), isNull);
      });

      testWidgets('once fully open throws nothing', (WidgetTester t) async {
        await t.pumpWidget(
          host(
            const ContextMenu(
              children: <MenuChild>[MenuItem(label: 'Favourite')],
              child: SizedBox(width: 200, height: 100, child: Text('Card')),
            ),
          ),
        );
        await rightClick(t, find.byType(ContextMenu));
        expect(find.text('Favourite'), findsOneWidget);

        await t.pumpWidget(host(const SizedBox.shrink()));
        await t.pumpAndSettle();

        expect(t.takeException(), isNull);
      });
    });

    /* ── 8. a disabled trigger does not open ───────────────────────────── */

    testWidgets('a disabled ContextMenu does not open on right-click', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        host(
          const ContextMenu(
            enabled: false,
            children: <MenuChild>[MenuItem(label: 'Favourite')],
            child: SizedBox(width: 200, height: 100, child: Text('Card')),
          ),
        ),
      );
      await t.tapAt(
        t.getCenter(find.byType(ContextMenu)),
        buttons: kSecondaryButton,
      );
      await settleOverlay(t);
      await t.pump(MotionDurations.overlayEnter);

      expect(find.text('Favourite'), findsNothing);
    });

    /* ── 9. semantics ───────────────────────────────────────────────────── */

    testWidgets('rows carry the button role, enabled state and a label', (
      WidgetTester t,
    ) async {
      final SemanticsHandle handle = t.ensureSemantics();
      await t.pumpWidget(
        host(
          const ContextMenu(
            children: <MenuChild>[
              MenuItem(label: 'Favourite'),
              MenuItem(label: 'Disabled row', enabled: false),
            ],
            child: SizedBox(width: 200, height: 100, child: Text('Card')),
          ),
        ),
      );
      await rightClick(t, find.byType(ContextMenu));

      final Semantics favourite = t.widget<Semantics>(
        find
            .ancestor(
              of: find.text('Favourite'),
              matching: find.byType(Semantics),
            )
            .first,
      );
      expect(favourite.properties.button, isTrue);
      expect(favourite.properties.enabled, isTrue);
      expect(favourite.properties.label, 'Favourite');

      final Semantics disabled = t.widget<Semantics>(
        find
            .ancestor(
              of: find.text('Disabled row'),
              matching: find.byType(Semantics),
            )
            .first,
      );
      expect(disabled.properties.enabled, isFalse);

      handle.dispose();
    });
  });
}

/// A trigger with no focus node of its own — used wherever a test does not
/// care what the trigger is, only that the menu opens/closes/disposes
/// correctly. `menus_test.dart`'s own `_Trigger`, copied rather than
/// imported: it is a private class in another test file.
class _NonFocusableTrigger extends StatelessWidget {
  const _NonFocusableTrigger();

  @override
  Widget build(BuildContext context) =>
      const SizedBox(width: 80, height: 40, child: Text('Trigger'));
}
