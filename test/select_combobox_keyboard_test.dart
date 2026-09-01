/// Two keyboard-reachability defects, fixed in the same files this batch
/// already touches for target sizing.
///
/// **Select.** `Focus(autofocus: true)` on the open menu never actually won
/// focus: autofocus only wins while nothing else in the tree holds it, and a
/// mounted route's `FocusScopeNode` always has *something* focused — the
/// trigger, in this case. Every branch of `_onMenuKey` (arrows, Home, End,
/// Escape) was therefore dead from a real keyboard. Fixed the way
/// `menu.dart`'s `_MenuContentState.initState` already does it: an owned
/// `FocusNode`, requested explicitly at the frame boundary.
///
/// **Combobox.** Tabbing away from an open combobox moved focus off the
/// input and left the popup open with no keyboard path back to it — `_onKey`
/// had no `Tab` case and nothing listened for blur. Fixed by closing on
/// blur, the way a native `<input>`'s own listbox does.
///
/// Both need a real app root — a bare `Directionality` host has no default
/// focus holder, which is exactly the condition that let autofocus win by
/// accident and the original bug go unnoticed.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/material.dart' show MaterialApp, Material;
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

/// Copied from `test/interaction_kernel_test.dart`'s `host()`.
Widget host(Widget child, {ColorMode mode = ColorMode.dark}) => ThemeScope(
  controller: ThemeController(mode: mode),
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

void main() {
  group('Select — the open menu really holds the keyboard', () {
    const List<SelectOption<String>> options = <SelectOption<String>>[
      SelectOption<String>(value: 'a', label: 'Alpha'),
      SelectOption<String>(value: 'b', label: 'Bravo'),
      SelectOption<String>(value: 'c', label: 'Charlie'),
    ];

    testWidgets(
      'opening moves focus off the trigger and ArrowDown + Enter really '
      'drives the selection',
      (WidgetTester t) async {
        String? picked;
        final FocusNode trigger = FocusNode(debugLabel: 'trigger');
        addTearDown(trigger.dispose);

        await t.pumpWidget(
          host(
            Select<String>(
              options: options,
              value: null,
              onChanged: (String v) => picked = v,
              focusNode: trigger,
            ),
          ),
        );

        // The trigger holds real focus before the menu opens — the exact
        // condition `autofocus` cannot win against.
        trigger.requestFocus();
        await t.pump();
        expect(FocusManager.instance.primaryFocus, trigger);

        await t.tap(find.byType(Select<String>));
        await t.pumpAndSettle();

        expect(
          FocusManager.instance.primaryFocus,
          isNot(trigger),
          reason: 'the open menu, not the trigger, should hold focus now',
        );

        // Nothing is chosen, so the menu opens with row 0 (Alpha) live.
        // ArrowDown should move that to row 1 (Bravo), and Enter commits it.
        await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await t.pump();
        await t.sendKeyEvent(LogicalKeyboardKey.enter);
        await t.pump();

        expect(picked, 'b');
      },
    );

    testWidgets('Home and End jump to the first and last row', (
      WidgetTester t,
    ) async {
      String? picked;
      await t.pumpWidget(
        host(
          Select<String>(
            options: options,
            value: null,
            onChanged: (String v) => picked = v,
          ),
        ),
      );

      await t.tap(find.byType(Select<String>));
      await t.pumpAndSettle();

      await t.sendKeyEvent(LogicalKeyboardKey.end);
      await t.pump();
      await t.sendKeyEvent(LogicalKeyboardKey.enter);
      await t.pump();
      expect(picked, 'c');

      await t.tap(find.byType(Select<String>));
      await t.pumpAndSettle();

      await t.sendKeyEvent(LogicalKeyboardKey.home);
      await t.pump();
      await t.sendKeyEvent(LogicalKeyboardKey.enter);
      await t.pump();
      expect(picked, 'a');
    });

    testWidgets('Escape closes the menu without choosing', (
      WidgetTester t,
    ) async {
      String? picked;
      await t.pumpWidget(
        host(
          Select<String>(
            options: options,
            value: null,
            onChanged: (String v) => picked = v,
          ),
        ),
      );

      await t.tap(find.byType(Select<String>));
      await t.pumpAndSettle();
      expect(find.text('Bravo'), findsOneWidget);

      await t.sendKeyEvent(LogicalKeyboardKey.escape);
      await t.pump();

      expect(find.text('Bravo'), findsNothing);
      expect(picked, isNull);
    });
  });

  group('Combobox — a blur closes the popup', () {
    testWidgets('tabbing away from an open combobox closes it', (
      WidgetTester t,
    ) async {
      final FocusNode next = FocusNode(debugLabel: 'next stop');
      addTearDown(next.dispose);

      await t.pumpWidget(
        host(
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                width: 320,
                child: Combobox<String>(
                  items: const <ComboboxItem<String>>[
                    ComboboxItem<String>(value: 'a', label: 'Alpha'),
                    ComboboxItem<String>(value: 'b', label: 'Bravo'),
                  ],
                  value: null,
                  onChanged: (String _) {},
                ),
              ),
              // Somewhere for Tab to land, so traversal has a real next stop.
              Focus(
                focusNode: next,
                child: const SizedBox(width: 10, height: 10),
              ),
            ],
          ),
        ),
      );

      await t.tap(find.byType(InputGroupInput));
      await t.pumpAndSettle();
      final FocusNode input = FocusManager.instance.primaryFocus!;
      await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await t.pumpAndSettle();

      expect(find.byType(PopoverSurface), findsOneWidget);

      await t.sendKeyEvent(LogicalKeyboardKey.tab);
      await t.pumpAndSettle();

      // Tab's own next stop is the combobox's trigger button — still inside
      // the control, one traversal hop from `next` — so the assertion that
      // matters is that focus genuinely left the input, not where it landed.
      expect(
        FocusManager.instance.primaryFocus,
        isNot(input),
        reason: 'Tab should have actually moved focus off the input',
      );
      expect(find.byType(PopoverSurface), findsNothing);
    });
  });
}
