import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// The selects page's core: what phase 3 deferred on `DsSelect`, the anchored
/// overlay both new families mount on, the native select's by-construction
/// divergence, and the combobox.
///
/// Numbers marked *(measured)* were read off the live reference at
/// `localhost:3000/design-system/components/base/selects` on 2026-08-15 with
/// `getComputedStyle` / `getBoundingClientRect`, not derived from the map.

Widget host(Widget child, {DsThemeMode mode = DsThemeMode.dark, Size size = const Size(1440, 900)}) {
  return MediaQuery(
    data: MediaQueryData(size: size),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: DsTheme(
        controller: DsThemeController(mode: mode),
        child: Center(child: child),
      ),
    ),
  );
}

/// What [overlayHost] is currently showing — the same holder trick
/// `selection_feedback_test.dart` uses, for the same reason: `initialEntries`
/// is read once, in `initState`.
Widget _hosted = const SizedBox.shrink();

Widget overlayHost(
  Widget child, {
  DsThemeMode mode = DsThemeMode.dark,
  Size size = const Size(1440, 900),
  Alignment align = Alignment.center,
}) {
  _hosted = child;
  return MediaQuery(
    data: MediaQueryData(size: size),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: DsTheme(
        controller: DsThemeController(mode: mode),
        child: Overlay(
          initialEntries: <OverlayEntry>[
            OverlayEntry(
              builder: (BuildContext _) => Align(alignment: align, child: _hosted),
            ),
          ],
        ),
      ),
    ),
  );
}

DsThemeData themeIn(WidgetTester t, Type of) =>
    DsTheme.of(t.element(find.byType(of).first));

DsMachineSurface socketOf(WidgetTester t, Type of) => t.widget<DsMachineSurface>(
      find
          .descendant(of: find.byType(of), matching: find.byType(DsMachineSurface))
          .first,
    );

Color borderOf(DsMachineSurface surface) => (surface.border! as Border).top.color;

/// `s-sort` (selects-map §4.2) — a label, three items, a rule, a label, two
/// items. The list the old `(index + 0.5) × itemHeight` arithmetic cannot
/// place.
List<DsSelectChild<String>> sortMenu() => const <DsSelectChild<String>>[
      DsSelectGroup<String>(
        label: 'Activity',
        children: <DsSelectOption<String>>[
          DsSelectOption<String>(value: 'popular', label: 'Most popular'),
          DsSelectOption<String>(value: 'newest', label: 'Newest'),
          DsSelectOption<String>(value: 'volatility', label: 'Volatility'),
        ],
      ),
      DsSelectSeparator(),
      DsSelectGroup<String>(
        label: 'Price',
        children: <DsSelectOption<String>>[
          DsSelectOption<String>(value: 'low', label: 'Price: low to high'),
          DsSelectOption<String>(value: 'high', label: 'Price: high to low'),
        ],
      ),
    ];

/// `s-rarity` — six flat rows.
List<DsSelectChild<String>> rarityMenu() => const <DsSelectChild<String>>[
      DsSelectOption<String>(value: 'common', label: 'Common'),
      DsSelectOption<String>(value: 'uncommon', label: 'Uncommon'),
      DsSelectOption<String>(value: 'rare', label: 'Rare'),
      DsSelectOption<String>(value: 'epic', label: 'Epic'),
      DsSelectOption<String>(value: 'legendary', label: 'Legendary'),
      DsSelectOption<String>(value: 'mythic', label: 'Mythic'),
    ];

/// Opens (or closes) a [DsPopover]: one frame for the prop to flip, and one
/// more for the portal the frame boundary brings in or takes out.
Future<void> settleOverlay(WidgetTester t) async {
  await t.pump();
  await t.pump();
}

/// Runs a `--duration-overlay` transition out and lets the portal mount or
/// unmount behind it.
///
/// The extra beat is not padding: Flutter's interpolation simulation reports
/// itself done only *past* its duration, so a pump of exactly 320ms lands on
/// the final value without ever stopping the ticker — and the popup's exit
/// waits on that ticker.
Future<void> runOverlay(WidgetTester t) async {
  await t.pump(DsDurations.overlay);
  await t.pump(DsDurations.tick);
  await t.pump();
}

/// The box a menu row paints in — its own `py-2 pl-3 pr-9` padding.
///
/// Scoped to the open overlay on purpose: a chosen row's label is also printed
/// on the trigger, and the trigger's own padding box is 38px tall, which is a
/// very convincing wrong answer.
Rect rowRect(WidgetTester t, String text, {Finder? within}) => t.getRect(
      find
          .ancestor(
            of: find.descendant(
              of: within ?? find.byType(DsSelectMenu<String>),
              matching: find.text(text),
            ),
            matching: find.byType(Padding),
          )
          .first,
    );

void main() {
  group('DsSelect — the deferred row kinds', () {
    testWidgets('every row kind states its own height', (WidgetTester t) async {
      // *(measured)*: the label row computes 32px and the item 34.563 on the
      // live page; the port derives both off the type scale, so the item lands
      // on the exact 34.5714 the browser rounds.
      expect(DsSelect.itemHeight, closeTo(34.571, 0.001));
      expect(DsSelect.labelHeight, 32);
      expect(DsSelect.separatorHeight, 17);
      expect(DsSelect.scrollButtonHeight, 32);
    });

    testWidgets('the grouped menu totals what the map derives',
        (WidgetTester t) async {
      // §4.2: 8 + 32 + 3×34.571 + 17 + 32 + 2×34.571 + 8 = 269.857.
      expect(DsSelectMenu.heightOf<String>(sortMenu()), closeTo(269.857, 0.01));
      // §4.2: 8 + 6×34.571 + 8 = 223.429.
      expect(DsSelectMenu.heightOf<String>(rarityMenu()), closeTo(223.429, 0.01));
    });

    testWidgets('a group paints its label and a separator paints a rule',
        (WidgetTester t) async {
      await t.pumpWidget(overlayHost(SizedBox(
        width: 384,
        child: DsSelect<String>(
          options: sortMenu(),
          value: 'popular',
          onChanged: (String _) {},
          expand: true,
        ),
      )));
      await t.tap(find.byType(DsSelect<String>));
      await t.pump();

      expect(find.text('Activity'), findsOneWidget);
      expect(find.text('Price'), findsOneWidget);
      expect(rowRect(t, 'Activity').height, 32);
      expect(rowRect(t, 'Most popular').height, closeTo(34.571, 0.001));

      // The rule is 1px inside 17px of box, and it is `--border`.
      final DsThemeData theme = themeIn(t, DsSelect<String>);
      final ColoredBox rule = t.widget<ColoredBox>(
        find.descendant(
          of: find.byType(DsSelectMenu<String>),
          matching: find.byType(ColoredBox),
        ),
      );
      expect(rule.color, theme.border);
      expect(t.getSize(find.byType(ColoredBox)).height, 1);
    });

    testWidgets('the separator bleeds through the viewport padding — `-mx-2`',
        (WidgetTester t) async {
      await t.pumpWidget(overlayHost(SizedBox(
        width: 384,
        child: DsSelect<String>(
          options: sortMenu(),
          value: 'popular',
          onChanged: (String _) {},
          expand: true,
        ),
      )));
      await t.tap(find.byType(DsSelect<String>));
      await t.pump();

      final Rect content = t.getRect(find.byType(DsSelectMenu<String>));
      final Rect rule = t.getRect(find.byType(ColoredBox));
      final Rect row = rowRect(t, 'Most popular');

      // *(measured)*: the rule renders 387 wide inside a 387 content while the
      // rows render 371 — the full content width against the padded one.
      expect(rule.width, content.width);
      expect(row.left - content.left, 8);
      expect(content.right - row.right, 8);
    });

    testWidgets('RULING L5 — a menu with nothing selectable opens nothing',
        (WidgetTester t) async {
      await t.pumpWidget(overlayHost(DsSelect<String>(
        options: const <DsSelectChild<String>>[],
        value: null,
        onChanged: (String _) {},
        placeholder: 'Unavailable',
      )));
      await t.tap(find.byType(DsSelect<String>));
      await t.pump();
      expect(find.byType(DsSelectMenu<String>), findsNothing);
    });

    testWidgets('the keyboard walks items only, stepping over label and rule',
        (WidgetTester t) async {
      String? picked;
      await t.pumpWidget(overlayHost(SizedBox(
        width: 384,
        child: DsSelect<String>(
          options: sortMenu(),
          value: 'volatility',
          onChanged: (String v) => picked = v,
          expand: true,
        ),
      )));
      await t.tap(find.byType(DsSelect<String>));
      await t.pump();

      // From the last row of group 1, one step down lands on the first row of
      // group 2 — the separator and the second label are not stops.
      await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await t.pump();
      await t.sendKeyEvent(LogicalKeyboardKey.enter);
      await t.pump();
      expect(picked, 'low');
    });
  });

  group('DsSelect — item-aligned placement over a heterogeneous list', () {
    testWidgets('the chosen row lands on the trigger, counting label and rule',
        (WidgetTester t) async {
      await t.pumpWidget(overlayHost(
        SizedBox(
          width: 384,
          child: DsSelect<String>(
            options: sortMenu(),
            value: 'popular',
            onChanged: (String _) {},
            expand: true,
          ),
        ),
      ));
      final Rect trigger = t.getRect(find.byType(DsSelect<String>));
      await t.tap(find.byType(DsSelect<String>));
      await t.pump();

      final Rect content = t.getRect(find.byType(DsSelectMenu<String>));
      final Rect chosen = rowRect(t, 'Most popular');

      // *(measured on the live reference: `offsetInContent: 40`)* — the
      // viewport's 8px of padding plus a 32px label, and nothing else.
      expect(chosen.top - content.top, closeTo(40, 0.001));

      // …which is what puts its middle on the trigger's middle.
      expect(chosen.center.dy, closeTo(trigger.center.dy, 0.001));

      // ANTI-ASSERTION. Phase 3 computed the chosen row's centre as
      // `ds(2) + (index + 0.5) × itemHeight` = 25.29 for index 0, which would
      // sit the row 17.3px into the content instead of 40 and hang the menu
      // 22.7px too low. If this ever passes again, the running offset is gone.
      final double shipped = 8 + 0.5 * DsSelect.itemHeight;
      expect(chosen.center.dy - content.top, isNot(closeTo(shipped, 0.001)));
      expect(chosen.center.dy - content.top, closeTo(40 + DsSelect.itemHeight / 2, 0.001));
    });

    testWidgets('a flat list still lands where phase 3 put it',
        (WidgetTester t) async {
      await t.pumpWidget(overlayHost(SizedBox(
        width: 384,
        child: DsSelect<String>(
          options: rarityMenu(),
          value: 'rare',
          onChanged: (String _) {},
          expand: true,
        ),
      )));
      final Rect trigger = t.getRect(find.byType(DsSelect<String>));
      await t.tap(find.byType(DsSelect<String>));
      await t.pump();

      final Rect content = t.getRect(find.byType(DsSelectMenu<String>));
      final Rect chosen = rowRect(t, 'Rare');
      // Index 2 of a uniform list: the old arithmetic and the new one agree,
      // which is the whole point of the regression.
      expect(chosen.center.dy - content.top,
          closeTo(8 + 2.5 * DsSelect.itemHeight, 0.001));
      expect(chosen.center.dy, closeTo(trigger.center.dy, 0.001));
    });

    testWidgets('with nothing chosen the first row takes the trigger',
        (WidgetTester t) async {
      await t.pumpWidget(overlayHost(SizedBox(
        width: 384,
        child: DsSelect<String>(
          options: rarityMenu(),
          value: null,
          onChanged: (String _) {},
          placeholder: 'Any rarity',
          expand: true,
        ),
      )));
      final Rect trigger = t.getRect(find.byType(DsSelect<String>));
      await t.tap(find.byType(DsSelect<String>));
      await t.pump();
      expect(rowRect(t, 'Common').center.dy, closeTo(trigger.center.dy, 0.001));
    });

    testWidgets('a menu too tall to place pins to the boundary and scrolls',
        (WidgetTester t) async {
      // Thirty rows is 1053px of content in an 800px window: the box cannot
      // move far enough, so the viewport carries the rest — and the caps
      // appear, exactly as the live `s-sort` menu did at its own 32px extent.
      final List<DsSelectChild<String>> many = <DsSelectChild<String>>[
        for (int i = 0; i < 30; i++)
          DsSelectOption<String>(value: '$i', label: 'Row $i'),
      ];
      await t.pumpWidget(overlayHost(
        SizedBox(
          width: 384,
          child: DsSelect<String>(
            options: many,
            value: '2',
            onChanged: (String _) {},
            expand: true,
          ),
        ),
        size: const Size(1440, 800),
        align: Alignment.bottomCenter,
      ));
      await t.tap(find.byType(DsSelect<String>));
      await t.pump();
      await t.pump();

      final Rect content = t.getRect(find.byType(DsSelectMenu<String>));
      // The boundary is the overlay's own box — the test surface, which
      // `MediaQuery` does not resize — less the 8px margin at each end.
      final Rect boundary = t.getRect(find.byType(Overlay));
      expect(content.height, closeTo(boundary.height - 16, 0.5),
          reason: 'capped by the boundary, less its 8px margins');
      expect(content.top, closeTo(8, 0.5));

      // The clamp stole more alignment than the viewport can give back, so it
      // sits at its own scroll extent — the up cap mounted, the down cap gone.
      // That is the state the live `s-sort` menu was measured in.
      final Finder inMenu = find.descendant(
        of: find.byType(DsSelectMenu<String>),
        matching: find.byWidgetPredicate(
          (Widget w) => w is DsIcon && w.glyph == DsIconGlyph.chevronUp,
        ),
      );
      expect(inMenu, findsOneWidget);
      expect(t.getSize(find.ancestor(of: inMenu, matching: find.byType(SizedBox)).first).height, 32);
    });
  });

  group('DsSelect — RULING L4, the third width', () {
    testWidgets('`width` renders, and beats `expand`', (WidgetTester t) async {
      await t.pumpWidget(host(DsSelect<String>(
        options: rarityMenu(),
        value: null,
        onChanged: (String _) {},
        placeholder: 'Any rarity',
        // `className="w-40"` — 160px *(measured, `--spacing` × 40)*.
        width: 160,
      )));
      expect(t.getSize(find.byType(DsSelect<String>)).width, 160);

      // In a loose cell, which is what the page's `StateCell` is: `expand`
      // asks for the whole measure and the utility overrules it.
      await t.pumpWidget(host(Row(
        children: <Widget>[
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: DsSelect<String>(
                options: rarityMenu(),
                value: null,
                onChanged: (String _) {},
                placeholder: 'Any rarity',
                expand: true,
                width: 160,
              ),
            ),
          ),
        ],
      )));
      expect(t.getSize(find.byType(DsSelect<String>)).width, 160,
          reason: 'an explicit utility beats the field cascade');
    });

    testWidgets('`expand` and the bare class are unchanged',
        (WidgetTester t) async {
      await t.pumpWidget(host(SizedBox(
        width: 384,
        child: DsSelect<String>(
          options: rarityMenu(),
          value: null,
          onChanged: (String _) {},
          placeholder: 'Any rarity',
          expand: true,
        ),
      )));
      expect(t.getSize(find.byType(DsSelect<String>)).width, 384);

      await t.pumpWidget(host(DsSelect<String>(
        options: rarityMenu(),
        value: 'mythic',
        onChanged: (String _) {},
      )));
      expect(t.getSize(find.byType(DsSelect<String>)).width, lessThan(384),
          reason: '`w-fit` — the trigger is as wide as its content');
    });
  });

  group('dsPopoverPlacement', () {
    const Size viewport = Size(1440, 900);
    final Rect anchor = const Rect.fromLTWH(50, 400, 344, 40);

    test('bottom / start, with room: under the trigger at the offset', () {
      final DsPopoverPlacement at = dsPopoverPlacement(
        anchor: anchor,
        content: const Size(372, 167),
        viewport: viewport,
        align: DsPopoverAlign.start,
        sideOffset: 6,
      );
      expect(at.side, DsPopoverSide.bottom);
      expect(at.offset, const Offset(50, 446));
    });

    test('flips when the side it was asked for has no room', () {
      final DsPopoverPlacement at = dsPopoverPlacement(
        anchor: const Rect.fromLTWH(50, 700, 344, 40),
        content: const Size(372, 300),
        viewport: viewport,
        align: DsPopoverAlign.start,
        sideOffset: 6,
      );
      // 900 − 740 − 6 = 154 below, 694 above.
      expect(at.side, DsPopoverSide.top);
      expect(at.offset.dy, 700 - 6 - 300);
    });

    test('keeps the side with more room when neither fits, and stays on screen',
        () {
      final DsPopoverPlacement at = dsPopoverPlacement(
        anchor: const Rect.fromLTWH(50, 400, 344, 40),
        content: const Size(372, 880),
        viewport: viewport,
        align: DsPopoverAlign.start,
      );
      expect(at.side, DsPopoverSide.bottom, reason: '460 below beats 400 above');
    });

    test('the cross axis shifts back inside the boundary rather than flipping',
        () {
      final DsPopoverPlacement at = dsPopoverPlacement(
        anchor: const Rect.fromLTWH(1300, 400, 100, 40),
        content: const Size(372, 167),
        viewport: viewport,
        align: DsPopoverAlign.start,
        collisionPadding: 8,
      );
      expect(at.offset.dx, 1440 - 8 - 372);
    });

    test('the transform origin points at the trigger, not at a corner', () {
      // *(measured: an open combobox popup computes
      // `--transform-origin: 172px calc(100% + 6px)`)* — 172 is half of the
      // 344px anchor, and the main axis is the popup's own edge plus the gap.
      final DsPopoverPlacement at = dsPopoverPlacement(
        anchor: anchor,
        content: const Size(372, 167),
        viewport: viewport,
        align: DsPopoverAlign.start,
        sideOffset: 6,
      );
      expect(at.origin.x, closeTo(2 * (172 / 372) - 1, 0.0001));
      expect(at.origin.y, closeTo(-1 - 2 * 6 / 167, 0.0001));
    });
  });

  group('DsPopover', () {
    Widget popoverHost({required bool open, bool animate = true, Size size = const Size(1440, 900)}) =>
        overlayHost(
          _PopoverProbe(open: open, animate: animate),
          size: size,
        );

    testWidgets('opens under its anchor and dismisses on an outside tap',
        (WidgetTester t) async {
      await t.pumpWidget(popoverHost(open: false));
      expect(find.text('popped'), findsNothing);

      await t.tap(find.text('anchor'));
      await settleOverlay(t);
      await runOverlay(t);
      expect(find.text('popped'), findsOneWidget);

      final Rect anchor = t.getRect(find.text('anchor'));
      final Rect popup = t.getRect(find.byType(DsPopoverSurface));
      expect(popup.top, closeTo(anchor.bottom + 4, 0.001));
      expect(popup.left, closeTo(anchor.left, 0.001));

      await t.tapAt(const Offset(10, 10));
      await settleOverlay(t);
      await runOverlay(t);
      await settleOverlay(t);
      expect(find.text('popped'), findsNothing);
    });

    testWidgets('the entrance is `--duration-overlay` on `--ease-out`',
        (WidgetTester t) async {
      await t.pumpWidget(popoverHost(open: false));
      await t.tap(find.text('anchor'));
      await settleOverlay(t);

      // `zoom-in-95` — the first frame is at 95%.
      // `entry(0, 0)` is the x scale. Not `getMaxScaleOnAxis()`, which maxes
      // over the z column as well — and z is 1 in a 2D zoom, so it reports 1
      // for every scale under it.
      double scaleOf() => t
          .widget<Transform>(
            find.ancestor(of: find.text('popped'), matching: find.byType(Transform)).first,
          )
          .transform
          .entry(0, 0);
      expect(scaleOf(), closeTo(0.95, 0.001));

      await runOverlay(t);
      expect(scaleOf(), closeTo(1, 0.001));
    });

    testWidgets('`animate: false` is `animate-none`, not a zero-length run',
        (WidgetTester t) async {
      await t.pumpWidget(popoverHost(open: false, animate: false));
      await t.tap(find.text('anchor'));
      await settleOverlay(t);
      expect(find.text('popped'), findsOneWidget);
      expect(
        find.ancestor(of: find.text('popped'), matching: find.byType(Transform)),
        findsNothing,
        reason: 'no transition is mounted at all',
      );
    });

    testWidgets('the surface is shadow-md under a 1px ring at 12px',
        (WidgetTester t) async {
      await t.pumpWidget(popoverHost(open: true));
      await settleOverlay(t);
      await t.pump();
      await runOverlay(t);
      final DsMachineSurface surface = t.widget<DsMachineSurface>(
        find.descendant(
          of: find.byType(DsPopoverSurface),
          matching: find.byType(DsMachineSurface),
        ),
      );
      expect(surface.spec.layers.skip(1).toList(), DsShadows.tailwindMd.layers);
      expect(surface.spec.layers.first.spread, DsWidths.hairline);
      expect(surface.radius, BorderRadius.circular(DsRadii.lg));
      expect(surface.fill, themeIn(t, DsPopoverSurface).popover);
    });
  });

  group('DsNativeSelect — RULING L6', () {
    List<DsSelectChild<String>> countries() => const <DsSelectChild<String>>[
          DsSelectOption<String>(value: 'us', label: 'United States'),
          DsSelectOption<String>(value: 'gb', label: 'United Kingdom'),
          DsSelectOption<String>(value: 'ca', label: 'Canada'),
          DsSelectOption<String>(value: 'de', label: 'Germany'),
          DsSelectOption<String>(value: 'jp', label: 'Japan'),
        ];

    testWidgets('32px on a 12px corner with no socket at all',
        (WidgetTester t) async {
      await t.pumpWidget(overlayHost(SizedBox(
        width: 384,
        child: DsNativeSelect<String>(
          options: countries(),
          value: 'us',
          onChanged: (String _) {},
          expand: true,
        ),
      )));
      // *(measured: h 32, radius 12px, box-shadow **none**, padding
      // `4px 32px 4px 10px`, width 384)*.
      expect(t.getSize(find.byType(DsNativeSelect<String>)).height, 32);
      expect(t.getSize(find.byType(DsNativeSelect<String>)).width, 384);
      final DsMachineSurface surface = socketOf(t, DsNativeSelect<String>);
      expect(surface.radius, BorderRadius.circular(DsRadii.lg));
      expect(surface.spec.layers, isEmpty, reason: 'no shadow-pressed');
      expect(DsNativeSelectSize.md.height, 32);
      expect(DsNativeSelectSize.sm.height, 28);
      expect(DsNativeSelectSize.sm.radius, DsRadii.md);
      expect(DsNativeSelectSize.md.label, 'default');
    });

    testWidgets('transparent in light, `--input` at 30% in dark',
        (WidgetTester t) async {
      await t.pumpWidget(overlayHost(
        DsNativeSelect<String>(
          options: countries(),
          value: 'us',
          onChanged: (String _) {},
        ),
        mode: DsThemeMode.light,
      ));
      await t.pump(DsDurations.transitionDefault);
      expect(socketOf(t, DsNativeSelect<String>).fill, dsTransparent);

      await t.pumpWidget(overlayHost(DsNativeSelect<String>(
        options: countries(),
        value: 'us',
        onChanged: (String _) {},
      )));
      final DsThemeData dark = themeIn(t, DsNativeSelect<String>);
      await t.pump(DsDurations.transitionDefault);
      expect(socketOf(t, DsNativeSelect<String>).fill,
          dark.input.withValues(alpha: 0.30));
      expect(borderOf(socketOf(t, DsNativeSelect<String>)), dark.input);
    });

    testWidgets('a closed control walks its own value on the arrows',
        (WidgetTester t) async {
      String value = 'us';
      await t.pumpWidget(overlayHost(StatefulBuilder(
        builder: (BuildContext context, StateSetter set) => DsNativeSelect<String>(
          options: countries(),
          value: value,
          onChanged: (String v) => set(() => value = v),
        ),
      )));
      await t.tap(find.byType(DsNativeSelect<String>));
      await settleOverlay(t);
      // The tap opened it and took focus; close, then walk.
      await t.sendKeyEvent(LogicalKeyboardKey.escape);
      await settleOverlay(t);

      await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await t.pump();
      expect(value, 'gb');
      expect(find.byType(DsSelectMenu<String>), findsNothing,
          reason: 'a `<select>` arrow does not open the picker');

      await t.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      await t.pump();
      expect(value, 'us');
      // …and it does not wrap: `<select>` stops at the ends.
      await t.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      await t.pump();
      expect(value, 'us');
    });

    testWidgets('DIVERGENCE — the list is the port\'s own menu, unanimated',
        (WidgetTester t) async {
      await t.pumpWidget(overlayHost(SizedBox(
        width: 384,
        child: DsNativeSelect<String>(
          options: countries(),
          value: 'us',
          onChanged: (String _) {},
          expand: true,
        ),
      )));
      await t.tap(find.byType(DsNativeSelect<String>));
      await settleOverlay(t);

      expect(find.byType(DsSelectMenu<String>), findsOneWidget);
      expect(find.text('Japan'), findsOneWidget);
      // Whole in one frame — no zoom, because an OS picker does not zoom.
      expect(
        find.ancestor(
          of: find.byType(DsSelectMenu<String>),
          matching: find.byType(Transform),
        ),
        findsNothing,
      );
      final Rect control = t.getRect(find.byType(DsNativeSelect<String>));
      final Rect menu = t.getRect(find.byType(DsSelectMenu<String>));
      expect(menu.top, closeTo(control.bottom + 4, 0.001));
      expect(menu.left, closeTo(control.left, 0.001));
      expect(menu.width, closeTo(control.width, 0.001));
    });

    testWidgets('the disabled dim is on the wrapper', (WidgetTester t) async {
      await t.pumpWidget(overlayHost(DsNativeSelect<String>(
        options: countries(),
        value: 'us',
        onChanged: (String _) {},
        enabled: false,
      )));
      final Opacity dim = t.widget<Opacity>(
        find.descendant(
          of: find.byType(DsNativeSelect<String>),
          matching: find.byType(Opacity),
        ).first,
      );
      expect(dim.opacity, 0.50);
      await t.tap(find.byType(DsNativeSelect<String>));
      await settleOverlay(t);
      expect(find.byType(DsSelectMenu<String>), findsNothing);
    });
  });

  group('dsCollatorContains — base-ui\'s default filter', () {
    test('is case-insensitive', () {
      // The exact query typed into the live reference.
      expect(dsCollatorContains('Golden Rift', 'GOL'), isTrue);
      expect(dsCollatorContains('Golden Rift', 'rift'), isTrue);
      expect(dsCollatorContains('Eclipse Vault', 'GOL'), isFalse);
    });

    test('is accent-insensitive — `sensitivity: base`', () {
      expect(dsCollatorContains('Éclipse Vault', 'eclipse'), isTrue);
      expect(dsCollatorContains('Eclipse Vault', 'éclipse'), isTrue);
      expect(dsCollatorContains('Crème Brûlée', 'creme brulee'), isTrue);
    });

    test('ignores punctuation and whitespace on both sides', () {
      expect(dsCollatorContains('Shadow Core', 'shadowcore'), isTrue);
      expect(dsCollatorContains('Origin: Pulse', 'origin pulse'), isTrue);
    });

    test('an empty query matches everything', () {
      expect(dsCollatorContains('Anything', ''), isTrue);
      expect(dsCollatorContains('Anything', '   '), isTrue);
    });
  });

  group('DsCombobox', () {
    List<DsComboboxItem<String>> sets() => const <DsComboboxItem<String>>[
          DsComboboxItem<String>(value: 'eclipse', label: 'Eclipse Vault'),
          DsComboboxItem<String>(value: 'golden', label: 'Golden Rift'),
          DsComboboxItem<String>(value: 'mystic', label: 'Mystic Surge'),
          DsComboboxItem<String>(value: 'shadow', label: 'Shadow Core'),
          DsComboboxItem<String>(value: 'celestial', label: 'Celestial Strike'),
          DsComboboxItem<String>(value: 'origin', label: 'Origin Pulse'),
        ];

    Widget combobox({
      String? value,
      ValueChanged<String>? onChanged,
    }) =>
        overlayHost(
          SizedBox(
            width: 384,
            child: _ComboboxProbe(items: sets(), value: value, onChanged: onChanged),
          ),
          align: Alignment.topCenter,
        );

    testWidgets('the chassis is a 40px pill with a 24px trigger',
        (WidgetTester t) async {
      await t.pumpWidget(combobox());
      // *(measured: the group is 40 × 384 at a 999px radius, and the input
      // inside it 344 with `4px 8px 4px 16px` of padding)*.
      expect(t.getSize(find.byType(DsInputGroup)).height, 40);
      expect(t.getSize(find.byType(DsInputGroup)).width, 384);
      expect(t.getSize(find.byType(DsInputGroupInput)).width, closeTo(344, 0.5));
      expect(socketOf(t, DsInputGroup).spec.layers, isNotEmpty,
          reason: 'shadow-pressed — the combobox input keeps its socket');
    });

    testWidgets('the popup is the anchor plus 28, not the field plus 28',
        (WidgetTester t) async {
      await t.pumpWidget(combobox());
      await t.tap(find.byType(DsInputGroupInput));
      await settleOverlay(t);
      await runOverlay(t);

      final double input = t.getSize(find.byType(DsInputGroupInput)).width;
      final Rect popup = t.getRect(find.byType(DsPopoverSurface));
      // *(measured: `--anchor-width: 344px`, popup 372 — 11px narrower than the
      // 384 pill, not the derived 412)*.
      expect(popup.width, closeTo(input + 28, 0.5));
      expect(popup.width, closeTo(372, 0.5));
      expect(popup.width, lessThan(384));

      final Rect group = t.getRect(find.byType(DsInputGroup));
      expect(popup.top, closeTo(group.top + 40 - 1 + 6, 1.5),
          reason: 'sideOffset 6 below the input, which sits inside the border');
    });

    testWidgets('a row is 26.571px with the tick 8px in', (WidgetTester t) async {
      expect(DsCombobox.itemHeight, closeTo(26.571, 0.001));
      expect(DsCombobox.emptyHeight, closeTo(34.571, 0.001));
      expect(DsCombobox.listMaxHeight, 252);

      await t.pumpWidget(combobox(value: 'golden'));
      await t.tap(find.byType(DsInputGroupInput));
      await settleOverlay(t);
      await runOverlay(t);
      expect(rowRect(t, 'Eclipse Vault', within: find.byType(DsPopoverSurface)).height, closeTo(26.571, 0.001));

      final Rect tick = t.getRect(find.byWidgetPredicate(
        (Widget w) => w is DsIcon && w.glyph == DsIconGlyph.check,
      ));
      final Rect row = rowRect(t, 'Golden Rift', within: find.byType(DsPopoverSurface));
      expect(row.right - tick.right, closeTo(8, 0.001));
    });

    testWidgets('typing narrows the list by the collator', (WidgetTester t) async {
      await t.pumpWidget(combobox());
      await t.tap(find.byType(DsInputGroupInput));
      await settleOverlay(t);
      await runOverlay(t);
      expect(find.text('Eclipse Vault'), findsOneWidget);

      await t.enterText(find.byType(EditableText), 'GOL');
      await t.pump();
      expect(find.text('Golden Rift'), findsOneWidget);
      expect(find.text('Eclipse Vault'), findsNothing);
    });

    testWidgets('the empty state says what happened', (WidgetTester t) async {
      await t.pumpWidget(combobox());
      await t.tap(find.byType(DsInputGroupInput));
      await settleOverlay(t);
      await runOverlay(t);

      await t.enterText(find.byType(EditableText), 'zzzz');
      await t.pump();
      expect(find.text('No matching set.'), findsOneWidget);
      expect(find.text('Origin Pulse'), findsNothing);
      // `data-empty:p-0` — the row is full-bleed inside the popup.
      final Rect popup = t.getRect(find.byType(DsPopoverSurface));
      final Rect empty = t.getRect(find.text('No matching set.'));
      expect(empty.width, closeTo(popup.width, 0.5));
    });

    testWidgets('`autoHighlight: false` — nothing is highlighted until an arrow',
        (WidgetTester t) async {
      await t.pumpWidget(combobox());
      await t.tap(find.byType(DsInputGroupInput));
      await settleOverlay(t);
      await runOverlay(t);

      final DsThemeData theme = themeIn(t, DsInputGroup);
      List<Color?> fills() => t
          .widgetList<DecoratedBox>(find.descendant(
            of: find.byType(DsPopoverSurface),
            matching: find.byType(DecoratedBox),
          ))
          .map((DecoratedBox b) => (b.decoration as BoxDecoration).color)
          .toList();
      expect(fills().where((Color? c) => c == theme.accent), isEmpty);

      await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await t.pump();
      expect(fills().where((Color? c) => c == theme.accent), hasLength(1));
    });

    testWidgets('picking sets the input and closes; reopening shows all six',
        (WidgetTester t) async {
      String? picked;
      await t.pumpWidget(combobox(onChanged: (String v) => picked = v));
      await t.tap(find.byType(DsInputGroupInput));
      await settleOverlay(t);
      await runOverlay(t);

      await t.tap(find.text('Mystic Surge'));
      await settleOverlay(t);
      await runOverlay(t);
      expect(picked, 'mystic');
      expect(find.byType(DsPopoverSurface), findsNothing);
      expect(
        t.widget<EditableText>(find.byType(EditableText)).controller.text,
        'Mystic Surge',
      );

      // The single-selection bypass: the query has not changed since opening,
      // so the list is not narrowed to the selected label.
      await t.tap(find.byType(DsInputGroupInput));
      await settleOverlay(t);
      await runOverlay(t);
      for (final String label in <String>[
        'Eclipse Vault',
        'Golden Rift',
        'Mystic Surge',
        'Shadow Core',
        'Celestial Strike',
        'Origin Pulse',
      ]) {
        // Scoped to the popup: the picked label is also sitting in the input.
        expect(
          find.descendant(
            of: find.byType(DsPopoverSurface),
            matching: find.text(label),
          ),
          findsOneWidget,
          reason: label,
        );
      }
    });

    testWidgets('the popup animates — the counterexample to drift 9',
        (WidgetTester t) async {
      await t.pumpWidget(combobox());
      await t.tap(find.byType(DsInputGroupInput));
      await settleOverlay(t);
      double scale() => t
          .widget<Transform>(find
              .ancestor(
                of: find.byType(DsPopoverSurface),
                matching: find.byType(Transform),
              )
              .first)
          .transform
          .entry(0, 0);
      expect(scale(), closeTo(0.95, 0.001));
      await runOverlay(t);
      expect(scale(), closeTo(1, 0.001));
    });
  });

  group('DsComponentType — the menu family', () {
    test('menuLabel is 12/400 in a 16px line box', () {
      final DsTypeSpec spec = DsComponentType.menuLabel;
      expect(spec.size, 12);
      expect(spec.height! * spec.size!, 16);
      expect(spec.weight, FontWeight.w400);
      expect(spec.tracking, isNull);
      expect(spec.family, DsFonts.sans);
    });

    test('menuShortcut adds `--tracking-widest` and nothing else', () {
      final DsTypeSpec spec = DsComponentType.menuShortcut;
      expect(spec.size, DsComponentType.menuLabel.size);
      expect(spec.height, DsComponentType.menuLabel.height);
      expect(spec.weight, FontWeight.w400);
      expect(spec.tracking, 0.1);
      // Sans, not mono — selects-map drift 4: the palette's prices ride this
      // class instead of the numerical foundation the same page prescribes.
      expect(spec.family, DsFonts.sans);
    });
  });
}

/// A trigger and a popover, driven by a bool the test flips with a tap.
class _PopoverProbe extends StatefulWidget {
  const _PopoverProbe({required this.open, required this.animate});

  final bool open;
  final bool animate;

  @override
  State<_PopoverProbe> createState() => _PopoverProbeState();
}

class _PopoverProbeState extends State<_PopoverProbe> {
  late bool _open = widget.open;

  @override
  Widget build(BuildContext context) {
    return DsPopover(
      open: _open,
      animate: widget.animate,
      align: DsPopoverAlign.start,
      sideOffset: 4,
      onDismiss: () => setState(() => _open = false),
      content: (BuildContext context, DsPopoverAnchorMetrics metrics) =>
          const DsPopoverSurface(
        child: SizedBox(
          width: 200,
          height: 120,
          child: Text('popped', textDirection: TextDirection.ltr),
        ),
      ),
      anchor: GestureDetector(
        onTap: () => setState(() => _open = !_open),
        child: const SizedBox(
          width: 344,
          height: 40,
          child: Text('anchor', textDirection: TextDirection.ltr),
        ),
      ),
    );
  }
}

/// A combobox that holds its own value, so a pick is visible to the next pump.
class _ComboboxProbe extends StatefulWidget {
  const _ComboboxProbe({
    required this.items,
    required this.value,
    required this.onChanged,
  });

  final List<DsComboboxItem<String>> items;
  final String? value;
  final ValueChanged<String>? onChanged;

  @override
  State<_ComboboxProbe> createState() => _ComboboxProbeState();
}

class _ComboboxProbeState extends State<_ComboboxProbe> {
  late String? _value = widget.value;

  @override
  Widget build(BuildContext context) {
    return DsCombobox<String>(
      items: widget.items,
      value: _value,
      placeholder: 'Search card sets',
      emptyLabel: 'No matching set.',
      onChanged: (String value) {
        setState(() => _value = value);
        widget.onChanged?.call(value);
      },
    );
  }
}
