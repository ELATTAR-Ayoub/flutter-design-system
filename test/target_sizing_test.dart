/// TARGET SIZING — batch 1: every interactive row is a real 44 logical pixel
/// minimum layout height, not a grown, invisible hit area over an
/// undersized paint box.
///
/// Each case here asserts a `RenderBox.size.height` — the box the widget
/// actually occupies in the layout tree, which is what a background fill, a
/// highlight, and a screen reader's focus rectangle all agree on — rather
/// than a `TapTarget`-style hit-test rect that grows the answerable region
/// without growing what is there. The two are not the same question: a
/// [TapTarget] can make a 28px control answer a tap two rows away from
/// wherever it visually sits, and the owner has ruled that overlapping
/// invisible hit areas are not an acceptable answer to a small target.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/material.dart' show MaterialApp, Material;
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

/// A real app root — copied from `test/interaction_kernel_test.dart`'s
/// `host()`. Not decoration: a bare `Directionality` host would test these
/// controls with no `Overlay`, no ambient shortcut map and no traversal
/// group in scope, and several of the rows below open inside an overlay.
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

/// The rendered layout height of the row whose accessible name is [label] —
/// the outer `Semantics` node every row in this batch wraps itself in, which
/// proxies its size from the same box that paints the row's fill and answers
/// its taps. Not a hit-test rect: `tester.getSize` reads `RenderBox.size`.
double rowHeight(WidgetTester t, String label) {
  final Finder finder = find
      .byWidgetPredicate(
        (Widget w) => w is Semantics && w.properties.label == label,
      )
      .first;
  return t.getSize(finder).height;
}

void main() {
  group('Target sizing — a real 44px minimum, not a grown hit rect', () {
    testWidgets('a menu row', (WidgetTester t) async {
      await t.pumpWidget(
        host(
          MenuContent(
            children: const <MenuChild>[MenuItem(label: 'Row')],
            onClose: () {},
          ),
        ),
      );
      await t.pump();

      expect(rowHeight(t, 'Row'), greaterThanOrEqualTo(TouchTargets.minimum));
      // And it is exactly the number `Menu.itemHeight` states, not merely
      // clear of the floor — the row's layout and the getter agree.
      expect(rowHeight(t, 'Row'), closeTo(Menu.itemHeight, 0.01));
    });

    testWidgets('a select option', (WidgetTester t) async {
      await t.pumpWidget(
        host(
          Select<String>(
            options: const <SelectChild<String>>[
              SelectOption<String>(value: 'a', label: 'Option A'),
            ],
            value: null,
            onChanged: (String _) {},
          ),
        ),
      );
      await t.tap(find.byType(Select<String>));
      await t.pumpAndSettle();

      expect(
        rowHeight(t, 'Option A'),
        greaterThanOrEqualTo(TouchTargets.minimum),
      );
      expect(rowHeight(t, 'Option A'), closeTo(Select.itemHeight, 0.01));
    });

    testWidgets('a combobox option', (WidgetTester t) async {
      await t.pumpWidget(
        host(
          Combobox<String>(
            items: const <ComboboxItem<String>>[
              ComboboxItem<String>(value: 'a', label: 'Option A'),
            ],
            value: null,
            onChanged: (String _) {},
          ),
        ),
      );
      await t.tap(find.byType(Combobox<String>));
      await t.pumpAndSettle();

      expect(
        rowHeight(t, 'Option A'),
        greaterThanOrEqualTo(TouchTargets.minimum),
      );
      expect(rowHeight(t, 'Option A'), closeTo(Combobox.itemHeight, 0.01));
    });

    testWidgets('a command row', (WidgetTester t) async {
      await t.pumpWidget(
        host(
          const Command(
            groups: <CommandGroup>[
              CommandGroup(items: <CommandItem>[CommandItem(label: 'Row')]),
            ],
          ),
        ),
      );
      await t.pump();

      expect(rowHeight(t, 'Row'), greaterThanOrEqualTo(TouchTargets.minimum));
      expect(rowHeight(t, 'Row'), closeTo(Command.itemHeight, 0.01));
    });

    testWidgets('a toggle inside a ToggleGroup', (WidgetTester t) async {
      await t.pumpWidget(
        host(
          ToggleGroup(
            items: const <ToggleGroupItem>[
              ToggleGroupItem(label: 'Newest'),
              ToggleGroupItem(label: 'Price'),
              ToggleGroupItem(label: 'Popular'),
            ],
            selectedIndex: 0,
            onChanged: (int? _) {},
          ),
        ),
      );
      await t.pump();

      // Adjacency is not an exemption — the middle item, packed on both
      // sides, still clears the floor.
      expect(rowHeight(t, 'Price'), greaterThanOrEqualTo(TouchTargets.minimum));
    });

    testWidgets('a standalone toggle', (WidgetTester t) async {
      await t.pumpWidget(
        host(
          Toggle(
            pressed: false,
            onChanged: (bool _) {},
            label: 'Favorite',
            child: const Icon(IconGlyph.heart),
          ),
        ),
      );
      await t.pump();

      final Finder finder = find
          .byWidgetPredicate(
            (Widget w) => w is Semantics && w.properties.label == 'Favorite',
          )
          .first;
      final Size size = t.getSize(finder);

      expect(size.height, greaterThanOrEqualTo(TouchTargets.minimum));
      expect(size.width, greaterThanOrEqualTo(TouchTargets.minimum));
    });
  });
}
