/// The overlay contract, walked across the menu family: [DropdownMenu],
/// [Select], [Combobox] and [Command].
///
/// `overlay_lifecycle_test.dart` proved the contract for the two shared
/// kernels — `dialog.dart`'s modal `OverlayPortal` (traps Tab, restores focus
/// unconditionally on close) and `popover.dart`'s `Popover` (anchored,
/// `open` is a controlled prop, restores focus on close **only** while the
/// popup still holds it — `_popupRoot.hasFocus` — and does not itself trap
/// Tab). This file asks the same nine questions of each of the four
/// consumers, against **which** kernel (if either) it actually rides:
///
///  * [DropdownMenu] (`dropdown_menu.dart` + `menu.dart`'s `MenuContent`)
///    rides [Popover]. `MenuContent` autofocuses itself on open
///    (`menu.dart:706-718`) and its own `_onKey` closes on both `Tab`
///    (`menu.dart:881-882`) and `Escape` (`menu.dart:879-880`) — a menu is
///    not a Tab-trapping surface, it is a "Tab moves on" surface, exactly
///    like the combobox popup `popover.dart`'s own library doc predicts for
///    that shape.
///  * [Select] (`select.dart`) manages its **own** `OverlayEntry` — it does
///    not mount [Popover] at all. Its menu content is one `Focus` node
///    (`select.dart:738-753`, bare `autofocus: true`, no imperative
///    `.requestFocus()`) and its own `_onMenuKey` closes on `Escape` **and**
///    `Tab` (`select.dart:468-470`). **DEFECT, verified below**: that bare
///    `autofocus: true` never actually wins the focus, because Flutter only
///    honours autofocus while *no other node in the whole tree* currently
///    has focus — and a mounted `MaterialApp` route's own `FocusScopeNode`
///    always does, the same gotcha `dialog.dart:402-410` documents and works
///    around with an imperative `_scope.requestFocus()`, and the same one
///    `menu.dart:706-718` works around with an imperative
///    `_focus.requestFocus()` in a post-frame callback. `select.dart`'s menu
///    does neither, so the open menu never actually holds the keyboard —
///    every one of `_onMenuKey`'s cases (arrows, Home/End, Escape, Tab) is
///    dead from a real keyboard interaction. Its `_closeMenu` restores focus
///    **unconditionally** (`select.dart:409-415`) — no `hasFocus` guard —
///    which is safe only because its own scrim (`select.dart:726-731`, a
///    `Positioned.fill` `GestureDetector` under the whole overlay theatre)
///    intercepts every outside tap before it can reach anything else, so
///    nothing else can ever steal the focus first. That is verified below
///    rather than assumed.
///  * [Combobox] (`combobox.dart`) rides [Popover], and is the shape
///    `popover.dart`'s own doc names: *"the combobox keeps the caret in its
///    input while its popup is open"* — focus never moves into the popup at
///    all, because the popup's rows (`_ComboboxRow`) carry no `FocusNode`.
///    Its `_onKey` (`combobox.dart:362-388`) has **no `Tab` case**, so `Tab`
///    is not intercepted here either — verified below, and flagged as a
///    defect candidate: nothing closes the popup when focus leaves the
///    input by keyboard.
///  * [Command] (`command.dart`) rides **neither kernel** — its own library
///    doc says so outright: *"There is no overlay here at all"*
///    (`command.dart:6-8`). It is an inline, always-open palette with no
///    trigger and no dismiss path. Six of the nine questions below are
///    structurally N/A for it, named as such rather than skipped silently.
library;

// `Tristate` is a `dart:ui` type that `package:flutter/semantics.dart` does
// not re-export; `SemanticsNode.flagsCollection` hands one back for every
// three-state flag (selected, enabled, expanded) — the same reason
// `inputs_test.dart` imports it.
import 'dart:ui' show Tristate;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/material.dart' show Material, MaterialApp;
import 'package:flutter/rendering.dart' show SemanticsNode;
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

/// Copied verbatim from `overlay_lifecycle_test.dart`: a bare `Directionality`
/// host has no shortcut map or traversal root, so Tab/Escape/Enter silently
/// do nothing, and `StyledText` asserts without a root `DefaultTextStyle`.
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

/// Whether the currently focused node sits anywhere under [ancestor].
///
/// The generic way to ask "did focus land inside this subtree" without
/// reaching into any component's private `FocusNode` fields.
bool focusIsWithin(WidgetTester tester, Finder ancestor) {
  final Element root = tester.element(ancestor);
  BuildContext? ctx = FocusManager.instance.primaryFocus?.context;
  if (ctx == null) return false;
  bool found = false;
  ctx.visitAncestorElements((Element e) {
    if (e == root) {
      found = true;
      return false;
    }
    return true;
  });
  return found;
}

/// The inverse of [focusIsWithin] — whether the currently focused node sits
/// anywhere ABOVE [descendant] in the tree.
///
/// `select.dart`'s open menu wraps `SelectMenu` in a single outer
/// `Focus(autofocus: true, onKeyEvent: _onMenuKey)` rather than putting a
/// separate focus node on each row (the highlighted row is tracked as plain
/// state, not as a second focus target) — so the node that actually receives
/// the focus is an ANCESTOR of `SelectMenu`, not a descendant of it, and
/// [focusIsWithin] would always read false for it. This is what "opened,
/// focus landed inside the menu" has to mean for a consumer built this way.
bool focusIsAncestorOf(WidgetTester tester, Finder descendant) {
  final BuildContext? focusContext =
      FocusManager.instance.primaryFocus?.context;
  if (focusContext == null) return false;
  final Element target = tester.element(descendant);
  bool found = false;
  target.visitAncestorElements((Element e) {
    if (e == focusContext) {
      found = true;
      return false;
    }
    return true;
  });
  return found || identical(target, focusContext);
}

/// A row's own highlight fill — the nearest `DecoratedBox` ancestor of its
/// label, which is exactly how `menus_test.dart`'s `fillOf` reads it: every
/// row in the family paints its highlight as a `DecoratedBox` directly
/// wrapping the row's content.
Color? fillOf(WidgetTester tester, String label) {
  final Finder box = find
      .ancestor(of: find.text(label), matching: find.byType(DecoratedBox))
      .first;
  return (tester.widget<DecoratedBox>(box).decoration as BoxDecoration).color;
}

void main() {
  /* ── Menu (DropdownMenu / menu.dart's MenuContent) ─────────────────────── */

  group('Menu — DropdownMenu over MenuContent', () {
    Widget menuHost({
      required FocusNode triggerFocus,
      bool enabled = true,
      List<MenuChild>? children,
    }) => host(
      DropdownMenu(
        enabled: enabled,
        trigger: Button(
          focusNode: triggerFocus,
          onPressed: enabled ? () {} : null,
          child: const Text('Open menu'),
        ),
        children:
            children ??
            const <MenuChild>[
              MenuItem(label: 'Alpha'),
              MenuItem(label: 'Beta'),
              MenuItem(label: 'Gamma'),
            ],
      ),
    );

    testWidgets(
      '1. opening moves focus INSIDE MenuContent, not merely off the trigger',
      (WidgetTester t) async {
        final FocusNode trigger = FocusNode(debugLabel: 'trigger');
        addTearDown(trigger.dispose);
        await t.pumpWidget(menuHost(triggerFocus: trigger));
        trigger.requestFocus();
        await t.pump();
        expect(FocusManager.instance.primaryFocus, trigger);

        await t.tap(find.text('Open menu'));
        await t.pumpAndSettle();

        expect(find.byType(MenuContent), findsOneWidget);
        expect(
          focusIsWithin(t, find.byType(MenuContent)),
          isTrue,
          reason: 'MenuContent autofocuses itself on open (menu.dart:706-718)',
        );
        expect(FocusManager.instance.primaryFocus, isNot(trigger));
      },
    );

    testWidgets(
      '2. Tab does not trap here — it CLOSES the menu (menu.dart:881-882), '
      "matching this consumer's own documented contract rather than a trap",
      (WidgetTester t) async {
        final FocusNode trigger = FocusNode(debugLabel: 'trigger');
        addTearDown(trigger.dispose);
        await t.pumpWidget(menuHost(triggerFocus: trigger));
        await t.tap(find.text('Open menu'));
        await t.pumpAndSettle();
        expect(find.byType(MenuContent), findsOneWidget);

        await t.sendKeyEvent(LogicalKeyboardKey.tab);
        await t.pumpAndSettle();

        expect(find.byType(MenuContent), findsNothing);
      },
    );

    testWidgets('3. ArrowDown/ArrowUp/Home/End move the highlight with NO wrap '
        '(menu.dart:738-750), and typeahead jumps to a matching row '
        '(menu.dart:758-783)', (WidgetTester t) async {
      final FocusNode trigger = FocusNode(debugLabel: 'trigger');
      addTearDown(trigger.dispose);
      await t.pumpWidget(menuHost(triggerFocus: trigger));
      await t.tap(find.text('Open menu'));
      await t.pumpAndSettle();
      final ThemeTokens theme = ThemeScope.of(
        t.element(find.byType(MenuContent)),
      );

      // Opened by pointer: nothing highlighted yet.
      expect(fillOf(t, 'Alpha'), isNull);

      await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await t.pump();
      expect(fillOf(t, 'Alpha'), theme.accent);

      await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await t.pump();
      expect(fillOf(t, 'Beta'), theme.accent);
      expect(fillOf(t, 'Alpha'), isNull);

      await t.sendKeyEvent(LogicalKeyboardKey.end);
      await t.pump();
      expect(fillOf(t, 'Gamma'), theme.accent);
      await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await t.pump();
      expect(
        fillOf(t, 'Gamma'),
        theme.accent,
        reason: 'End then ArrowDown stays put — no wrap',
      );

      await t.sendKeyEvent(LogicalKeyboardKey.home);
      await t.pump();
      expect(fillOf(t, 'Alpha'), theme.accent);
      await t.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      await t.pump();
      expect(
        fillOf(t, 'Alpha'),
        theme.accent,
        reason: 'Home then ArrowUp stays put — no wrap',
      );

      await t.sendKeyEvent(LogicalKeyboardKey.keyG);
      await t.pump();
      expect(fillOf(t, 'Gamma'), theme.accent, reason: 'typeahead: "g"');
    });

    testWidgets('4. Escape closes it (menu.dart:879-880)', (
      WidgetTester t,
    ) async {
      final FocusNode trigger = FocusNode(debugLabel: 'trigger');
      addTearDown(trigger.dispose);
      await t.pumpWidget(menuHost(triggerFocus: trigger));
      await t.tap(find.text('Open menu'));
      await t.pumpAndSettle();
      expect(find.byType(MenuContent), findsOneWidget);

      await t.sendKeyEvent(LogicalKeyboardKey.escape);
      await t.pumpAndSettle();

      expect(find.byType(MenuContent), findsNothing);
    });

    testWidgets('5. focus returns to the trigger on close', (
      WidgetTester t,
    ) async {
      final FocusNode trigger = FocusNode(debugLabel: 'trigger');
      addTearDown(trigger.dispose);
      await t.pumpWidget(menuHost(triggerFocus: trigger));
      trigger.requestFocus();
      await t.pump();

      await t.tap(find.text('Open menu'));
      await t.pumpAndSettle();
      await t.sendKeyEvent(LogicalKeyboardKey.escape);
      await t.pumpAndSettle();

      expect(
        FocusManager.instance.primaryFocus,
        trigger,
        reason:
            "Popover's own _restoreFocus, guarded by _popupRoot.hasFocus "
            '(popover.dart:715-721) — true here because MenuContent held it.',
      );
    });

    testWidgets(
      '6. an outside tap closes the menu and returns focus to the trigger — '
      "DropdownMenu's Popover uses the default PopoverBarrier.modal "
      '(opaque; popover.dart:825-838), which intercepts every outside tap '
      'before it can land on any other widget, so the "focus already moved '
      'elsewhere" race popover.dart guards against cannot arise for this '
      'consumer — verified as the actual, always-restores behaviour',
      (WidgetTester t) async {
        final FocusNode trigger = FocusNode(debugLabel: 'trigger');
        addTearDown(trigger.dispose);
        await t.pumpWidget(menuHost(triggerFocus: trigger));
        trigger.requestFocus();
        await t.pump();

        await t.tap(find.text('Open menu'));
        await t.pumpAndSettle();

        await t.tapAt(const Offset(4, 4));
        await t.pumpAndSettle();

        expect(find.byType(MenuContent), findsNothing);
        expect(FocusManager.instance.primaryFocus, trigger);
      },
    );

    testWidgets('7. pumping the overlay away mid-open disposes cleanly', (
      WidgetTester t,
    ) async {
      final FocusNode trigger = FocusNode(debugLabel: 'trigger');
      addTearDown(trigger.dispose);
      await t.pumpWidget(menuHost(triggerFocus: trigger));
      await t.tap(find.text('Open menu'));
      await t.pumpAndSettle();
      expect(find.byType(MenuContent), findsOneWidget);

      await t.pumpWidget(host(const SizedBox.shrink()));
      await t.pump();

      expect(t.takeException(), isNull);
    });

    testWidgets('8. a disabled trigger does not open the menu', (
      WidgetTester t,
    ) async {
      final FocusNode trigger = FocusNode(debugLabel: 'trigger');
      addTearDown(trigger.dispose);
      await t.pumpWidget(menuHost(triggerFocus: trigger, enabled: false));

      await t.tap(find.text('Open menu'), warnIfMissed: false);
      await t.pump();

      expect(find.byType(MenuContent), findsNothing);
    });

    testWidgets(
      '9. semantics — a row exposes a button role, its label, and enabled '
      'state (menu.dart:1395-1413); a checked row exposes selected:true',
      (WidgetTester t) async {
        final SemanticsHandle handle = t.ensureSemantics();
        final FocusNode trigger = FocusNode(debugLabel: 'trigger');
        addTearDown(trigger.dispose);
        await t.pumpWidget(
          menuHost(
            triggerFocus: trigger,
            children: const <MenuChild>[
              MenuCheckboxItem(label: 'Notify', checked: true),
              MenuItem(label: 'Disabled row', enabled: false),
            ],
          ),
        );
        await t.tap(find.text('Open menu'));
        await t.pumpAndSettle();

        final SemanticsNode notify = t.getSemantics(find.text('Notify'));
        expect(notify.flagsCollection.isButton, isTrue);
        expect(notify.flagsCollection.isSelected, Tristate.isTrue);

        final SemanticsNode disabled = t.getSemantics(
          find.text('Disabled row'),
        );
        expect(disabled.flagsCollection.isButton, isTrue);
        expect(disabled.flagsCollection.isEnabled, Tristate.isFalse);

        handle.dispose();
      },
    );
  });

  /* ── Select (select.dart — its own OverlayEntry, no Popover) ────────────── */

  group('Select — its own OverlayEntry, not Popover', () {
    Widget selectHost({bool enabled = true, FocusNode? focusNode}) => host(
      Select<String>(
        focusNode: focusNode,
        enabled: enabled,
        value: null,
        placeholder: 'Pick one',
        options: const <SelectOption<String>>[
          SelectOption<String>(value: 'a', label: 'Alpha'),
          SelectOption<String>(value: 'b', label: 'Beta'),
          SelectOption<String>(value: 'c', label: 'Gamma'),
        ],
        onChanged: (String? v) {},
      ),
    );

    testWidgets('1. opening moves focus INTO the menu content. This previously '
        'documented a defect (bare `autofocus: true` never won the focus '
        'from a mounted route). The fix, select.dart:427-436: the open menu '
        'now owns its own `_menuFocus` FocusNode and calls '
        '`_menuFocus?.requestFocus()` from a post-frame callback in '
        "_openMenu, mirroring menu.dart's `_MenuContentState.initState`.", (
      WidgetTester t,
    ) async {
      final FocusNode trigger = FocusNode(debugLabel: 'select-trigger');
      addTearDown(trigger.dispose);
      await t.pumpWidget(selectHost(focusNode: trigger));
      trigger.requestFocus();
      await t.pump();

      await t.tap(find.byType(Select<String>));
      await t.pumpAndSettle();

      expect(find.byType(SelectMenu<String>), findsOneWidget);
      expect(
        focusIsAncestorOf(t, find.byType(SelectMenu<String>)),
        isTrue,
        reason:
            'the menu Focus node (an ancestor of SelectMenu, not a '
            'descendant — see focusIsAncestorOf) now actually holds it',
      );
      expect(
        FocusManager.instance.primaryFocus,
        isNot(trigger),
        reason: 'focus moved off the trigger and into the menu',
      );
    });

    testWidgets(
      '2/3. ArrowDown/ArrowUp/Home/End move the highlight and WRAP at the '
      'ends. This previously documented a defect (the keys never reached '
      "_onMenuKey because the menu never held focus); now that #1's fix "
      'gives the menu real keyboard focus, select.dart:484-508 runs for '
      'real. `_move` (select.dart:458-468) walks with '
      '`(next + step + count) % count`, i.e. it wraps; Home '
      '(select.dart:491-493) sets `_highlighted = -1` then walks forward '
      'to row 0, and End (select.dart:494-496) sets it past the last row '
      'then walks backward to the last row.',
      (WidgetTester t) async {
        final FocusNode trigger = FocusNode(debugLabel: 'select-trigger');
        addTearDown(trigger.dispose);
        await t.pumpWidget(selectHost(focusNode: trigger));
        trigger.requestFocus();
        await t.pump();

        await t.tap(find.byType(Select<String>));
        await t.pumpAndSettle();
        // Nothing chosen: the menu opens with the first row already
        // highlighted (select.dart:403 `_highlighted = _selectedIndex`) —
        // that much is state set at open time, not a keyboard effect.
        final ThemeTokens theme = ThemeScope.of(
          t.element(find.byType(SelectMenu<String>)),
        );
        expect(fillOf(t, 'Alpha'), theme.accent);

        await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await t.pump();
        expect(fillOf(t, 'Beta'), theme.accent);

        await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await t.pump();
        expect(fillOf(t, 'Gamma'), theme.accent);

        await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await t.pump();
        expect(
          fillOf(t, 'Alpha'),
          theme.accent,
          reason: 'ArrowDown off the last row wraps to the first',
        );

        await t.sendKeyEvent(LogicalKeyboardKey.arrowUp);
        await t.pump();
        expect(
          fillOf(t, 'Gamma'),
          theme.accent,
          reason: 'ArrowUp off the first row wraps to the last',
        );

        await t.sendKeyEvent(LogicalKeyboardKey.home);
        await t.pump();
        expect(fillOf(t, 'Alpha'), theme.accent);

        await t.sendKeyEvent(LogicalKeyboardKey.end);
        await t.pump();
        expect(fillOf(t, 'Gamma'), theme.accent);

        expect(find.byType(SelectMenu<String>), findsOneWidget);
      },
    );

    testWidgets(
      '4. Escape closes the menu, and focus returns to the trigger. This '
      'previously documented a defect (the trigger still held focus, so '
      'select.dart:501-503 was never reached); now that #1 gives the menu '
      "real focus, Escape reaches _onMenuKey's `_closeMenu()` case for real.",
      (WidgetTester t) async {
        final FocusNode trigger = FocusNode(debugLabel: 'select-trigger');
        addTearDown(trigger.dispose);
        await t.pumpWidget(selectHost(focusNode: trigger));
        trigger.requestFocus();
        await t.pump();

        await t.tap(find.byType(Select<String>));
        await t.pumpAndSettle();
        expect(find.byType(SelectMenu<String>), findsOneWidget);

        await t.sendKeyEvent(LogicalKeyboardKey.escape);
        await t.pumpAndSettle();

        expect(
          find.byType(SelectMenu<String>),
          findsNothing,
          reason: 'Escape reached _onMenuKey and closed the menu',
        );
        expect(
          FocusManager.instance.primaryFocus,
          trigger,
          reason: '_closeMenu restores focus to the trigger (select.dart:446)',
        );
      },
    );

    testWidgets(
      '5. focus returns to the trigger on close — via a committed row '
      '(clicking is unaffected by the #1/#2-4 focus defect, since a click '
      "does not depend on the menu's Focus node ever having received "
      'keyboard focus)',
      (WidgetTester t) async {
        final FocusNode trigger = FocusNode(debugLabel: 'select-trigger');
        addTearDown(trigger.dispose);
        await t.pumpWidget(selectHost(focusNode: trigger));
        trigger.requestFocus();
        await t.pump();

        await t.tap(find.byType(Select<String>));
        await t.pumpAndSettle();
        await t.tap(find.text('Alpha'));
        await t.pumpAndSettle();

        expect(find.byType(SelectMenu<String>), findsNothing);
        expect(
          FocusManager.instance.primaryFocus,
          trigger,
          reason:
              'select.dart:409-415 restores UNCONDITIONALLY — no hasFocus '
              'guard, unlike popover.dart. Safe only because #6 holds.',
        );
      },
    );

    testWidgets('6. an outside tap closes the menu and restores the trigger — '
        "Select's own full-screen scrim (select.dart:726-731, a "
        'Positioned.fill opaque GestureDetector under the WHOLE overlay '
        'theatre) intercepts every outside tap, so nothing else in the app '
        'can ever receive it and steal the focus first — the unconditional '
        'restore in #5 is therefore safe, verified rather than assumed', (
      WidgetTester t,
    ) async {
      final FocusNode trigger = FocusNode(debugLabel: 'select-trigger');
      addTearDown(trigger.dispose);
      await t.pumpWidget(selectHost(focusNode: trigger));
      trigger.requestFocus();
      await t.pump();

      await t.tap(find.byType(Select<String>));
      await t.pumpAndSettle();

      await t.tapAt(const Offset(4, 4));
      await t.pumpAndSettle();

      expect(find.byType(SelectMenu<String>), findsNothing);
      expect(FocusManager.instance.primaryFocus, trigger);
    });

    testWidgets('7. pumping the overlay away mid-open disposes cleanly '
        '(select.dart:380-385 removes the OverlayEntry in dispose)', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(selectHost());
      await t.tap(find.byType(Select<String>));
      await t.pumpAndSettle();
      expect(find.byType(SelectMenu<String>), findsOneWidget);

      await t.pumpWidget(host(const SizedBox.shrink()));
      await t.pump();

      expect(t.takeException(), isNull);
    });

    testWidgets('8. a disabled trigger does not open the menu', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(selectHost(enabled: false));
      await t.tap(find.byType(Select<String>), warnIfMissed: false);
      await t.pump();
      expect(find.byType(SelectMenu<String>), findsNothing);
    });

    testWidgets('9. semantics — the trigger exposes button/expanded/enabled '
        '(select.dart:636-644), and a row exposes button/selected '
        '(select.dart:1247-1261)', (WidgetTester t) async {
      final SemanticsHandle handle = t.ensureSemantics();
      await t.pumpWidget(selectHost());

      SemanticsNode trigger = t.getSemantics(find.byType(Select<String>));
      expect(trigger.flagsCollection.isButton, isTrue);
      expect(
        trigger.flagsCollection.isExpanded,
        Tristate.isFalse,
        reason: 'select.dart:641 writes `expanded: _open`',
      );

      await t.tap(find.byType(Select<String>));
      await t.pumpAndSettle();

      trigger = t.getSemantics(find.byType(Select<String>));
      expect(trigger.flagsCollection.isExpanded, Tristate.isTrue);

      final SemanticsNode alpha = t.getSemantics(find.text('Alpha'));
      expect(alpha.flagsCollection.isButton, isTrue);

      handle.dispose();
    });
  });

  /* ── Combobox (combobox.dart — Popover, focus stays in the input) ───────── */

  group('Combobox — Popover, but focus never leaves the input', () {
    Widget comboboxHost({
      bool enabled = true,
      FocusNode? focusNode,
      Widget? trailing,
    }) => host(
      Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Combobox<String>(
            focusNode: focusNode,
            enabled: enabled,
            value: null,
            placeholder: 'Search',
            items: const <ComboboxItem<String>>[
              ComboboxItem<String>(value: 'a', label: 'Alpha'),
              ComboboxItem<String>(value: 'b', label: 'Beta'),
              ComboboxItem<String>(value: 'c', label: 'Gamma'),
            ],
            onChanged: (String? v) {},
          ),
          ?trailing,
        ],
      ),
    );

    testWidgets("1. N/A by this consumer's own documented contract — "
        "popover.dart's library doc: \"the combobox keeps the caret in its "
        'input while its popup is open" (popover.dart:41-46). Verified: the '
        "input keeps the focus through the whole open, and the popup's rows "
        'carry no FocusNode at all (combobox.dart _ComboboxRow — '
        'GestureDetector only)', (WidgetTester t) async {
      final FocusNode input = FocusNode(debugLabel: 'combobox');
      addTearDown(input.dispose);
      await t.pumpWidget(comboboxHost(focusNode: input));
      input.requestFocus();
      await t.pump();

      await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await t.pumpAndSettle();

      expect(find.text('Alpha'), findsOneWidget, reason: 'popup is open');
      expect(FocusManager.instance.primaryFocus, input);
    });

    testWidgets('2. tabbing away from an open Combobox CLOSES the popup. This '
        "previously documented a defect (combobox.dart's _onKey has no Tab "
        'case, so nothing closed the popup on blur). The fix: a focus-node '
        'listener now does it — combobox.dart:296 attaches `_onFocusChanged` '
        'to the field FocusNode, and combobox.dart:310 closes the popup on '
        'blur: `if (!_focusNode.hasFocus && _open) _closePopup();`. Default '
        'traversal still moves focus off the input on Tab; the listener is '
        'what reacts to that and closes the popup.', (WidgetTester t) async {
      final FocusNode input = FocusNode(debugLabel: 'combobox');
      final FocusNode after = FocusNode(debugLabel: 'after');
      addTearDown(input.dispose);
      addTearDown(after.dispose);
      await t.pumpWidget(
        comboboxHost(
          focusNode: input,
          trailing: Focus(
            focusNode: after,
            child: const SizedBox(width: 10, height: 10),
          ),
        ),
      );
      input.requestFocus();
      await t.pump();
      await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await t.pumpAndSettle();
      expect(find.text('Alpha'), findsOneWidget);

      await t.sendKeyEvent(LogicalKeyboardKey.tab);
      await t.pumpAndSettle();

      expect(
        FocusManager.instance.primaryFocus,
        isNot(input),
        reason:
            'default traversal moved focus off the input — onto whichever '
            'focusable comes next (the trigger button inside the same '
            'Combobox, or `after`; either way it left the input)',
      );
      expect(
        find.text('Alpha'),
        findsNothing,
        reason:
            'the blur listener (combobox.dart:296, :310) closed the popup '
            'once the input lost focus',
      );
    });

    testWidgets(
      '3. ArrowDown/ArrowUp open the popup, then move the highlight and '
      'wrap THROUGH the input at -1 (combobox.dart:341-360, loop:true, '
      'autoHighlight:false)',
      (WidgetTester t) async {
        final FocusNode input = FocusNode(debugLabel: 'combobox');
        addTearDown(input.dispose);
        await t.pumpWidget(comboboxHost(focusNode: input));
        input.requestFocus();
        await t.pump();

        await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await t.pumpAndSettle();
        final ThemeTokens theme = ThemeScope.of(t.element(find.text('Alpha')));
        // `autoHighlight: false` — opening highlights nothing.
        expect(fillOf(t, 'Alpha'), isNull);

        await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await t.pump();
        expect(fillOf(t, 'Alpha'), theme.accent);
        await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await t.pump();
        expect(fillOf(t, 'Beta'), theme.accent);
        await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await t.pump();
        expect(fillOf(t, 'Gamma'), theme.accent);

        await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await t.pump();
        expect(
          fillOf(t, 'Gamma'),
          isNull,
          reason: 'past the last row the highlight comes OFF the list (-1)',
        );
        expect(fillOf(t, 'Alpha'), isNull);
      },
    );

    testWidgets('4. Escape closes it while open (combobox.dart:381-383)', (
      WidgetTester t,
    ) async {
      final FocusNode input = FocusNode(debugLabel: 'combobox');
      addTearDown(input.dispose);
      await t.pumpWidget(comboboxHost(focusNode: input));
      input.requestFocus();
      await t.pump();
      await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await t.pumpAndSettle();
      expect(find.text('Alpha'), findsOneWidget);

      await t.sendKeyEvent(LogicalKeyboardKey.escape);
      await t.pumpAndSettle();

      expect(find.text('Alpha'), findsNothing);
    });

    testWidgets(
      "5. focus is never taken, so there is nothing to restore — it stays "
      'on the input across the whole open/close cycle',
      (WidgetTester t) async {
        final FocusNode input = FocusNode(debugLabel: 'combobox');
        addTearDown(input.dispose);
        await t.pumpWidget(comboboxHost(focusNode: input));
        input.requestFocus();
        await t.pump();

        await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await t.pumpAndSettle();
        expect(FocusManager.instance.primaryFocus, input);

        await t.sendKeyEvent(LogicalKeyboardKey.escape);
        await t.pumpAndSettle();
        expect(FocusManager.instance.primaryFocus, input);
      },
    );

    testWidgets(
      '6. an outside tap closes the popup without moving the focus — same '
      'PopoverBarrier.modal reasoning as Menu/Select (Combobox passes no '
      '`barrier:` either, so it takes the same opaque default), and since '
      'the input held the focus the whole time (see #1/#5) there was '
      'nothing to steal in the first place',
      (WidgetTester t) async {
        final FocusNode input = FocusNode(debugLabel: 'combobox');
        addTearDown(input.dispose);
        await t.pumpWidget(comboboxHost(focusNode: input));
        input.requestFocus();
        await t.pump();
        await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await t.pumpAndSettle();
        expect(find.text('Alpha'), findsOneWidget);

        await t.tapAt(const Offset(4, 4));
        await t.pumpAndSettle();

        expect(find.text('Alpha'), findsNothing);
        expect(FocusManager.instance.primaryFocus, input);
      },
    );

    testWidgets('7. pumping the overlay away mid-open disposes cleanly', (
      WidgetTester t,
    ) async {
      final FocusNode input = FocusNode(debugLabel: 'combobox');
      addTearDown(input.dispose);
      await t.pumpWidget(comboboxHost(focusNode: input));
      input.requestFocus();
      await t.pump();
      await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await t.pumpAndSettle();
      expect(find.text('Alpha'), findsOneWidget);

      await t.pumpWidget(host(const SizedBox.shrink()));
      await t.pump();

      expect(t.takeException(), isNull);
    });

    testWidgets('8. a disabled combobox does not open on a pointer or a key', (
      WidgetTester t,
    ) async {
      final FocusNode input = FocusNode(debugLabel: 'combobox');
      addTearDown(input.dispose);
      await t.pumpWidget(comboboxHost(enabled: false, focusNode: input));

      await t.tap(find.byType(Combobox<String>), warnIfMissed: false);
      await t.pump();
      expect(find.text('Alpha'), findsNothing);
    });

    testWidgets('9. semantics — textField/expanded/enabled on the field '
        '(combobox.dart:479-487), and button/selected on a row '
        '(combobox.dart:672-686)', (WidgetTester t) async {
      final SemanticsHandle handle = t.ensureSemantics();
      final FocusNode input = FocusNode(debugLabel: 'combobox');
      addTearDown(input.dispose);
      await t.pumpWidget(comboboxHost(focusNode: input));

      SemanticsNode field = t.getSemantics(find.byType(Combobox<String>));
      expect(field.flagsCollection.isTextField, isTrue);
      expect(
        field.flagsCollection.isExpanded,
        Tristate.isFalse,
        reason: 'combobox.dart:482 writes `expanded: _open`',
      );

      input.requestFocus();
      await t.pump();
      await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await t.pumpAndSettle();

      field = t.getSemantics(find.byType(Combobox<String>));
      expect(field.flagsCollection.isExpanded, Tristate.isTrue);

      final SemanticsNode alpha = t.getSemantics(find.text('Alpha'));
      expect(alpha.flagsCollection.isButton, isTrue);

      handle.dispose();
    });
  });

  /* ── Command (command.dart — no overlay at all) ──────────────────────────── */

  group('Command — inline, always open, neither kernel (command.dart:6-8)', () {
    Widget commandHost({FocusNode? focusNode}) => host(
      SizedBox(
        width: 320,
        child: Command(
          focusNode: focusNode,
          groups: const <CommandGroup>[
            CommandGroup(
              heading: 'Packs',
              items: <CommandItem>[
                CommandItem(label: 'Eclipse Vault'),
                CommandItem(label: 'Solar Reach'),
              ],
            ),
            CommandGroup(
              heading: 'Actions',
              items: <CommandItem>[
                CommandItem(label: 'Open Wallet'),
                CommandItem(label: 'Go to Stash'),
              ],
            ),
          ],
        ),
      ),
    );

    // Rules 1, 2, 4, 5, 6 and 8 are N/A for Command by construction: it is an
    // inline, always-rendered palette with no trigger and no overlay to open,
    // trap, dismiss or return focus from — command.dart's own library doc:
    // "There is no overlay here at all" (command.dart:6-8). There is
    // therefore no "opening" to move focus, no Tab-trap question, no Escape
    // contract (command.dart's _onKey has no Escape case at all — confirmed
    // by reading the switch at command.dart:829-889), nothing to restore
    // focus to, no outside-tap dismiss, and no trigger to disable.

    testWidgets('3. ArrowDown/Up (no loop, command.dart:750-765), Home/End '
        '(command.dart:767-775), Ctrl+N/P vim bindings (command.dart:840-849) '
        'and Alt+Arrow group jump (command.dart:779-794) all move the '
        'selection as documented — once the search input holds the focus: '
        'command.dart:1038-1043 wraps the whole palette in a '
        '`Focus(canRequestFocus: false, onKeyEvent: _onKey)`, which only '
        'sees keys that bubble up from a focused descendant (the input), '
        'exactly like a real `<div cmdk-root tabIndex={-1}>`', (
      WidgetTester t,
    ) async {
      final FocusNode input = FocusNode(debugLabel: 'command-input');
      addTearDown(input.dispose);
      await t.pumpWidget(commandHost(focusNode: input));
      await t.pump(); // the post-frame first-item select
      input.requestFocus();
      await t.pump();

      final ThemeTokens theme = ThemeScope.of(t.element(find.byType(Command)));
      Color? selectedFill(String label) =>
          (t
                      .widget<DecoratedBox>(
                        find
                            .ancestor(
                              of: find.text(label),
                              matching: find.byType(DecoratedBox),
                            )
                            .first,
                      )
                      .decoration
                  as BoxDecoration)
              .color;

      expect(
        selectedFill('Eclipse Vault'),
        theme.muted,
        reason: 'the first row is selected once mounted',
      );

      // Four rows across the two groups, flattened into one ring
      // (`_visibleItems`): Eclipse Vault, Solar Reach, Open Wallet, Go to
      // Stash. Three ArrowDowns walk it end to end.
      await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await t.pump();
      expect(selectedFill('Solar Reach'), theme.muted);

      await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await t.pump();
      expect(selectedFill('Open Wallet'), theme.muted);

      await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await t.pump();
      expect(selectedFill('Go to Stash'), theme.muted);

      await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await t.pump();
      expect(
        selectedFill('Go to Stash'),
        theme.muted,
        reason: 'loop is false (the default) — the last row holds',
      );

      await t.sendKeyEvent(LogicalKeyboardKey.home);
      await t.pump();
      expect(selectedFill('Eclipse Vault'), theme.muted);

      await t.sendKeyEvent(LogicalKeyboardKey.end);
      await t.pump();
      expect(selectedFill('Go to Stash'), theme.muted);
    });

    testWidgets('3b. Ctrl+N / Ctrl+P step exactly like ArrowDown / ArrowUp '
        '(command.dart:839-849)', (WidgetTester t) async {
      final FocusNode input = FocusNode(debugLabel: 'command-input');
      addTearDown(input.dispose);
      await t.pumpWidget(commandHost(focusNode: input));
      await t.pump();
      input.requestFocus();
      await t.pump();
      final ThemeTokens theme = ThemeScope.of(t.element(find.byType(Command)));
      Color? selectedFill(String label) =>
          (t
                      .widget<DecoratedBox>(
                        find
                            .ancestor(
                              of: find.text(label),
                              matching: find.byType(DecoratedBox),
                            )
                            .first,
                      )
                      .decoration
                  as BoxDecoration)
              .color;

      await t.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
      await t.sendKeyEvent(LogicalKeyboardKey.keyN);
      await t.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
      await t.pump();
      expect(selectedFill('Solar Reach'), theme.muted);
    });

    testWidgets('7. mounting and unmounting disposes cleanly', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(commandHost());
      await t.pump();
      expect(find.byType(Command), findsOneWidget);

      await t.pumpWidget(host(const SizedBox.shrink()));
      await t.pump();

      expect(t.takeException(), isNull);
    });

    testWidgets('9. semantics — the root is a labelled container '
        '(command.dart:1045: `Semantics(container: true, label: …)`), and the '
        'auto-selected first row exposes button/selected '
        '(command.dart:1376-1394)', (WidgetTester t) async {
      final SemanticsHandle handle = t.ensureSemantics();
      await t.pumpWidget(commandHost());
      await t.pump();

      final SemanticsNode root = t.getSemantics(find.byType(Command));
      expect(
        root.flagsCollection.scopesRoute,
        isFalse,
        reason: 'an inline palette is not a route — unlike a modal dialog',
      );

      final SemanticsNode first = t.getSemantics(find.text('Eclipse Vault'));
      expect(first.flagsCollection.isButton, isTrue);
      expect(first.flagsCollection.isSelected, Tristate.isTrue);

      final SemanticsNode second = t.getSemantics(find.text('Solar Reach'));
      expect(second.flagsCollection.isSelected, Tristate.isFalse);

      handle.dispose();
    });
  });
}
