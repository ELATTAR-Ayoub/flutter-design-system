import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/gestures.dart' show PointerDeviceKind;
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

Widget host(
  Widget child, {
  DsThemeMode mode = DsThemeMode.dark,
  Size size = const Size(1440, 900),
}) {
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
              builder: (BuildContext _) =>
                  Align(alignment: align, child: _hosted),
            ),
          ],
        ),
      ),
    ),
  );
}

DsThemeData themeIn(WidgetTester t, Type of) =>
    DsTheme.of(t.element(find.byType(of).first));

DsMachineSurface socketOf(WidgetTester t, Type of) =>
    t.widget<DsMachineSurface>(
      find
          .descendant(
            of: find.byType(of),
            matching: find.byType(DsMachineSurface),
          )
          .first,
    );

Color borderOf(DsMachineSurface surface) =>
    (surface.border! as Border).top.color;

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

    testWidgets('the grouped menu totals what the map derives', (
      WidgetTester t,
    ) async {
      // §4.2: 8 + 32 + 3×34.571 + 17 + 32 + 2×34.571 + 8 = 269.857.
      expect(DsSelectMenu.heightOf<String>(sortMenu()), closeTo(269.857, 0.01));
      // §4.2: 8 + 6×34.571 + 8 = 223.429.
      expect(
        DsSelectMenu.heightOf<String>(rarityMenu()),
        closeTo(223.429, 0.01),
      );
    });

    testWidgets('a group paints its label and a separator paints a rule', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        overlayHost(
          SizedBox(
            width: 384,
            child: DsSelect<String>(
              options: sortMenu(),
              value: 'popular',
              onChanged: (String _) {},
              expand: true,
            ),
          ),
        ),
      );
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

    testWidgets('the separator bleeds through the viewport padding — `-mx-2`', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        overlayHost(
          SizedBox(
            width: 384,
            child: DsSelect<String>(
              options: sortMenu(),
              value: 'popular',
              onChanged: (String _) {},
              expand: true,
            ),
          ),
        ),
      );
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

    testWidgets('RULING L5 — a menu with nothing selectable opens nothing', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        overlayHost(
          DsSelect<String>(
            options: const <DsSelectChild<String>>[],
            value: null,
            onChanged: (String _) {},
            placeholder: 'Unavailable',
          ),
        ),
      );
      await t.tap(find.byType(DsSelect<String>));
      await t.pump();
      expect(find.byType(DsSelectMenu<String>), findsNothing);
    });

    testWidgets('the keyboard walks items only, stepping over label and rule', (
      WidgetTester t,
    ) async {
      String? picked;
      await t.pumpWidget(
        overlayHost(
          SizedBox(
            width: 384,
            child: DsSelect<String>(
              options: sortMenu(),
              value: 'volatility',
              onChanged: (String v) => picked = v,
              expand: true,
            ),
          ),
        ),
      );
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
    testWidgets('the chosen row lands on the trigger, counting label and rule', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        overlayHost(
          SizedBox(
            width: 384,
            child: DsSelect<String>(
              options: sortMenu(),
              value: 'popular',
              onChanged: (String _) {},
              expand: true,
            ),
          ),
        ),
      );
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
      expect(
        chosen.center.dy - content.top,
        closeTo(40 + DsSelect.itemHeight / 2, 0.001),
      );
    });

    testWidgets('a flat list still lands where phase 3 put it', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        overlayHost(
          SizedBox(
            width: 384,
            child: DsSelect<String>(
              options: rarityMenu(),
              value: 'rare',
              onChanged: (String _) {},
              expand: true,
            ),
          ),
        ),
      );
      final Rect trigger = t.getRect(find.byType(DsSelect<String>));
      await t.tap(find.byType(DsSelect<String>));
      await t.pump();

      final Rect content = t.getRect(find.byType(DsSelectMenu<String>));
      final Rect chosen = rowRect(t, 'Rare');
      // Index 2 of a uniform list: the old arithmetic and the new one agree,
      // which is the whole point of the regression.
      expect(
        chosen.center.dy - content.top,
        closeTo(8 + 2.5 * DsSelect.itemHeight, 0.001),
      );
      expect(chosen.center.dy, closeTo(trigger.center.dy, 0.001));
    });

    testWidgets('with nothing chosen the first row takes the trigger', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        overlayHost(
          SizedBox(
            width: 384,
            child: DsSelect<String>(
              options: rarityMenu(),
              value: null,
              onChanged: (String _) {},
              placeholder: 'Any rarity',
              expand: true,
            ),
          ),
        ),
      );
      final Rect trigger = t.getRect(find.byType(DsSelect<String>));
      await t.tap(find.byType(DsSelect<String>));
      await t.pump();
      expect(rowRect(t, 'Common').center.dy, closeTo(trigger.center.dy, 0.001));
    });

    testWidgets('a menu too tall to place pins to the boundary and scrolls', (
      WidgetTester t,
    ) async {
      // Thirty rows is 1053px of content in an 800px window: the box cannot
      // move far enough, so the viewport carries the rest — and the caps
      // appear, exactly as the live `s-sort` menu did at its own 32px extent.
      final List<DsSelectChild<String>> many = <DsSelectChild<String>>[
        for (int i = 0; i < 30; i++)
          DsSelectOption<String>(value: '$i', label: 'Row $i'),
      ];
      await t.pumpWidget(
        overlayHost(
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
        ),
      );
      await t.tap(find.byType(DsSelect<String>));
      await t.pump();
      await t.pump();

      final Rect content = t.getRect(find.byType(DsSelectMenu<String>));
      // The boundary is the overlay's own box — the test surface, which
      // `MediaQuery` does not resize — less the 8px margin at each end.
      final Rect boundary = t.getRect(find.byType(Overlay));
      expect(
        content.height,
        closeTo(boundary.height - 16, 0.5),
        reason: 'capped by the boundary, less its 8px margins',
      );
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
      expect(
        t
            .getSize(
              find.ancestor(of: inMenu, matching: find.byType(SizedBox)).first,
            )
            .height,
        32,
      );
    });
  });

  group('DsSelect — RULING L4, the third width', () {
    testWidgets('`width` renders, and beats `expand`', (WidgetTester t) async {
      await t.pumpWidget(
        host(
          DsSelect<String>(
            options: rarityMenu(),
            value: null,
            onChanged: (String _) {},
            placeholder: 'Any rarity',
            // `className="w-40"` — 160px *(measured, `--spacing` × 40)*.
            width: 160,
          ),
        ),
      );
      expect(t.getSize(find.byType(DsSelect<String>)).width, 160);

      // In a loose cell, which is what the page's `StateCell` is: `expand`
      // asks for the whole measure and the utility overrules it.
      await t.pumpWidget(
        host(
          Row(
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
          ),
        ),
      );
      expect(
        t.getSize(find.byType(DsSelect<String>)).width,
        160,
        reason: 'an explicit utility beats the field cascade',
      );
    });

    testWidgets('`expand` and the bare class are unchanged', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        host(
          SizedBox(
            width: 384,
            child: DsSelect<String>(
              options: rarityMenu(),
              value: null,
              onChanged: (String _) {},
              placeholder: 'Any rarity',
              expand: true,
            ),
          ),
        ),
      );
      expect(t.getSize(find.byType(DsSelect<String>)).width, 384);

      await t.pumpWidget(
        host(
          DsSelect<String>(
            options: rarityMenu(),
            value: 'mythic',
            onChanged: (String _) {},
          ),
        ),
      );
      expect(
        t.getSize(find.byType(DsSelect<String>)).width,
        lessThan(384),
        reason: '`w-fit` — the trigger is as wide as its content',
      );
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

    test(
      'keeps the side with more room when neither fits, and stays on screen',
      () {
        final DsPopoverPlacement at = dsPopoverPlacement(
          anchor: const Rect.fromLTWH(50, 400, 344, 40),
          content: const Size(372, 880),
          viewport: viewport,
          align: DsPopoverAlign.start,
        );
        expect(
          at.side,
          DsPopoverSide.bottom,
          reason: '460 below beats 400 above',
        );
      },
    );

    test(
      'the cross axis shifts back inside the boundary rather than flipping',
      () {
        final DsPopoverPlacement at = dsPopoverPlacement(
          anchor: const Rect.fromLTWH(1300, 400, 100, 40),
          content: const Size(372, 167),
          viewport: viewport,
          align: DsPopoverAlign.start,
          collisionPadding: 8,
        );
        expect(at.offset.dx, 1440 - 8 - 372);
      },
    );

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
    Widget popoverHost({
      required bool open,
      bool animate = true,
      Size size = const Size(1440, 900),
    }) => overlayHost(
      _PopoverProbe(open: open, animate: animate),
      size: size,
    );

    testWidgets('opens under its anchor and dismisses on an outside tap', (
      WidgetTester t,
    ) async {
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

    testWidgets('the entrance is `--duration-overlay` on `--ease-out`', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(popoverHost(open: false));
      await t.tap(find.text('anchor'));
      await settleOverlay(t);

      // `zoom-in-95` — the first frame is at 95%.
      // `entry(0, 0)` is the x scale. Not `getMaxScaleOnAxis()`, which maxes
      // over the z column as well — and z is 1 in a 2D zoom, so it reports 1
      // for every scale under it.
      double scaleOf() => t
          .widget<Transform>(
            find
                .ancestor(
                  of: find.text('popped'),
                  matching: find.byType(Transform),
                )
                .first,
          )
          .transform
          .entry(0, 0);
      expect(scaleOf(), closeTo(0.95, 0.001));

      await runOverlay(t);
      expect(scaleOf(), closeTo(1, 0.001));
    });

    testWidgets('`animate: false` is `animate-none`, not a zero-length run', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(popoverHost(open: false, animate: false));
      await t.tap(find.text('anchor'));
      await settleOverlay(t);
      expect(find.text('popped'), findsOneWidget);
      expect(
        find.ancestor(
          of: find.text('popped'),
          matching: find.byType(Transform),
        ),
        findsNothing,
        reason: 'no transition is mounted at all',
      );
    });

    testWidgets('the surface is shadow-md under a 1px ring at 12px', (
      WidgetTester t,
    ) async {
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

    testWidgets('32px on a 12px corner with no socket at all', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        overlayHost(
          SizedBox(
            width: 384,
            child: DsNativeSelect<String>(
              options: countries(),
              value: 'us',
              onChanged: (String _) {},
              expand: true,
            ),
          ),
        ),
      );
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

    testWidgets('transparent in light, `--input` at 30% in dark', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        overlayHost(
          DsNativeSelect<String>(
            options: countries(),
            value: 'us',
            onChanged: (String _) {},
          ),
          mode: DsThemeMode.light,
        ),
      );
      await t.pump(DsDurations.transitionDefault);
      expect(socketOf(t, DsNativeSelect<String>).fill, dsTransparent);

      await t.pumpWidget(
        overlayHost(
          DsNativeSelect<String>(
            options: countries(),
            value: 'us',
            onChanged: (String _) {},
          ),
        ),
      );
      final DsThemeData dark = themeIn(t, DsNativeSelect<String>);
      await t.pump(DsDurations.transitionDefault);
      expect(
        socketOf(t, DsNativeSelect<String>).fill,
        dark.input.withValues(alpha: 0.30),
      );
      expect(borderOf(socketOf(t, DsNativeSelect<String>)), dark.input);
    });

    testWidgets('a closed control walks its own value on the arrows', (
      WidgetTester t,
    ) async {
      String value = 'us';
      await t.pumpWidget(
        overlayHost(
          StatefulBuilder(
            builder: (BuildContext context, StateSetter set) =>
                DsNativeSelect<String>(
                  options: countries(),
                  value: value,
                  onChanged: (String v) => set(() => value = v),
                ),
          ),
        ),
      );
      await t.tap(find.byType(DsNativeSelect<String>));
      await settleOverlay(t);
      // The tap opened it and took focus; close, then walk.
      await t.sendKeyEvent(LogicalKeyboardKey.escape);
      await settleOverlay(t);

      await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await t.pump();
      expect(value, 'gb');
      expect(
        find.byType(DsSelectMenu<String>),
        findsNothing,
        reason: 'a `<select>` arrow does not open the picker',
      );

      await t.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      await t.pump();
      expect(value, 'us');
      // …and it does not wrap: `<select>` stops at the ends.
      await t.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      await t.pump();
      expect(value, 'us');
    });

    testWidgets('DIVERGENCE — the list is the port\'s own menu, unanimated', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        overlayHost(
          SizedBox(
            width: 384,
            child: DsNativeSelect<String>(
              options: countries(),
              value: 'us',
              onChanged: (String _) {},
              expand: true,
            ),
          ),
        ),
      );
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
      await t.pumpWidget(
        overlayHost(
          DsNativeSelect<String>(
            options: countries(),
            value: 'us',
            onChanged: (String _) {},
            enabled: false,
          ),
        ),
      );
      final Opacity dim = t.widget<Opacity>(
        find
            .descendant(
              of: find.byType(DsNativeSelect<String>),
              matching: find.byType(Opacity),
            )
            .first,
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

    Widget combobox({String? value, ValueChanged<String>? onChanged}) =>
        overlayHost(
          SizedBox(
            width: 384,
            child: _ComboboxProbe(
              items: sets(),
              value: value,
              onChanged: onChanged,
            ),
          ),
          align: Alignment.topCenter,
        );

    testWidgets('the chassis is a 40px pill with a 24px trigger', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(combobox());
      // *(measured: the group is 40 × 384 at a 999px radius, and the input
      // inside it 344 with `4px 8px 4px 16px` of padding)*.
      expect(t.getSize(find.byType(DsInputGroup)).height, 40);
      expect(t.getSize(find.byType(DsInputGroup)).width, 384);
      expect(
        t.getSize(find.byType(DsInputGroupInput)).width,
        closeTo(344, 0.5),
      );
      expect(
        socketOf(t, DsInputGroup).spec.layers,
        isNotEmpty,
        reason: 'shadow-pressed — the combobox input keeps its socket',
      );
    });

    testWidgets('the popup is the anchor plus 28, not the field plus 28', (
      WidgetTester t,
    ) async {
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
      expect(
        popup.top,
        closeTo(group.top + 40 - 1 + 6, 1.5),
        reason: 'sideOffset 6 below the input, which sits inside the border',
      );
    });

    testWidgets('a row is 26.571px with the tick 8px in', (
      WidgetTester t,
    ) async {
      expect(DsCombobox.itemHeight, closeTo(26.571, 0.001));
      expect(DsCombobox.emptyHeight, closeTo(34.571, 0.001));
      expect(DsCombobox.listMaxHeight, 252);

      await t.pumpWidget(combobox(value: 'golden'));
      await t.tap(find.byType(DsInputGroupInput));
      await settleOverlay(t);
      await runOverlay(t);
      expect(
        rowRect(
          t,
          'Eclipse Vault',
          within: find.byType(DsPopoverSurface),
        ).height,
        closeTo(26.571, 0.001),
      );

      final Rect tick = t.getRect(
        find.byWidgetPredicate(
          (Widget w) => w is DsIcon && w.glyph == DsIconGlyph.check,
        ),
      );
      final Rect row = rowRect(
        t,
        'Golden Rift',
        within: find.byType(DsPopoverSurface),
      );
      expect(row.right - tick.right, closeTo(8, 0.001));
    });

    testWidgets('typing narrows the list by the collator', (
      WidgetTester t,
    ) async {
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

    testWidgets(
      '`autoHighlight: false` — nothing is highlighted until an arrow',
      (WidgetTester t) async {
        await t.pumpWidget(combobox());
        await t.tap(find.byType(DsInputGroupInput));
        await settleOverlay(t);
        await runOverlay(t);

        final DsThemeData theme = themeIn(t, DsInputGroup);
        List<Color?> fills() => t
            .widgetList<DecoratedBox>(
              find.descendant(
                of: find.byType(DsPopoverSurface),
                matching: find.byType(DecoratedBox),
              ),
            )
            .map((DecoratedBox b) => (b.decoration as BoxDecoration).color)
            .toList();
        expect(fills().where((Color? c) => c == theme.accent), isEmpty);

        await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await t.pump();
        expect(fills().where((Color? c) => c == theme.accent), hasLength(1));
      },
    );

    testWidgets('picking sets the input and closes; reopening shows all six', (
      WidgetTester t,
    ) async {
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

    testWidgets('the popup animates — the counterexample to drift 9', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(combobox());
      await t.tap(find.byType(DsInputGroupInput));
      await settleOverlay(t);
      double scale() => t
          .widget<Transform>(
            find
                .ancestor(
                  of: find.byType(DsPopoverSurface),
                  matching: find.byType(Transform),
                )
                .first,
          )
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

  // ═══════════════════════════════════════════════════════════════════════
  // B1 — the command palette
  //
  // Every number marked *(measured)* was read off
  // `localhost:3000/design-system/components/base/selects` on 2026-08-16 with
  // `getComputedStyle` / `getBoundingClientRect`, in both themes. Every score
  // pinned below was produced by running the reference's own
  // `cmdk@1.1.1/dist/command-score.js` in node — the port is checked against
  // the library, not against a re-derivation of it.
  // ═══════════════════════════════════════════════════════════════════════

  group('dsCommandScore — cmdk 1.1.1, ported verbatim (RULING L9)', () {
    // The four values the live palette carries, exactly as cmdk derives them
    // from the rendered text — the shortcut included, with nothing between.
    const String eclipse = r'Eclipse Vault$48.00';
    const String golden = r'Golden Rift$120.00';
    const String wallet = 'Open Wallet⌘W';
    const String stash = 'Go to Stash⌘S';

    test('a whole-string exact match is 1, and case costs a hair', () {
      expect(dsCommandScore(eclipse, eclipse), 1);
      // PENALTY_CASE_MISMATCH ^ 2, for the two letters that changed case.
      expect(
        dsCommandScore(eclipse, r'eclipse vault$48.00'),
        closeTo(0.9998000100000001, 1e-15),
      );
      expect(dsCommandScore('hello world', 'hello world'), 1);
    });

    test('a prefix that runs out early takes PENALTY_NOT_COMPLETE', () {
      expect(dsCommandScore('hello world', 'hello'), closeTo(0.99, 1e-15));
      expect(dsCommandScore('xyz', 'x'), closeTo(0.99, 1e-15));
      // An empty query matches everything at 0.99 — which is why cmdk guards
      // the filter on `!state.search` rather than on the score.
      expect(dsCommandScore('abc', ''), closeTo(0.99, 1e-15));
      // …and an empty subject matches nothing.
      expect(dsCommandScore('', 'a'), 0);
    });

    test('the three jump weights are distinguishable on real strings', () {
      // SCORE_SPACE_WORD_JUMP 0.9 — the break was a space.
      expect(dsCommandScore('hello world', 'hw'), closeTo(0.891, 1e-12));
      // …and a hyphen counts as a space, which is what folds `foo-bar` into
      // two words and leaves `fooBar` as one.
      expect(dsCommandScore('foo-bar', 'fb'), closeTo(0.891, 1e-12));
      // SCORE_NON_SPACE_WORD_JUMP 0.8 — the break was punctuation.
      expect(dsCommandScore('foo.bar', 'fb'), closeTo(0.792, 1e-12));
      expect(dsCommandScore('foo_bar', 'fb'), closeTo(0.792, 1e-12));
      // SCORE_CHARACTER_JUMP 0.17 — mid-word, and no break at all.
      expect(dsCommandScore('fooBar', 'fb'), closeTo(0.16794677194317, 1e-14));
    });

    test('every character in IS_GAP_REGEXP is a word break', () {
      for (final String gap in <String>[
        r'\',
        '/',
        '_',
        '+',
        '.',
        '#',
        '"',
        '@',
        '[',
        '(',
        '{',
        '&',
      ]) {
        expect(
          dsCommandScore('a${gap}b', 'ab'),
          closeTo(0.8, 1e-12),
          reason:
              'the gap character "\$gap" should score the non-space '
              'word jump',
        );
      }
    });

    test('PENALTY_SKIPPED compounds across the characters stepped over', () {
      expect(
        dsCommandScore('a/b/c', 'abc'),
        closeTo(0.6400000000000001, 1e-14),
      );
      expect(
        dsCommandScore('aa bb cc', 'abc'),
        closeTo(0.8019000000000001, 1e-14),
      );
      expect(
        dsCommandScore('aa-bb-cc', 'abc'),
        closeTo(0.8019000000000001, 1e-14),
      );
      expect(dsCommandScore('a b c d e', 'ae'), closeTo(0.8973026991, 1e-12));
      expect(
        dsCommandScore('abcdef', 'acf'),
        closeTo(0.028813386671100005, 1e-16),
      );
    });

    test('SCORE_TRANSPOSITION covers a swapped pair and a doubled letter', () {
      // The out-of-order clause: `ba` against `ab`.
      expect(dsCommandScore('ab', 'ba'), closeTo(0.1, 1e-14));
      expect(dsCommandScore('abc', 'acb'), closeTo(0.1, 1e-14));
      // The duplicate-letter clause upstream added for its issue #7428.
      expect(dsCommandScore('aab', 'ab'), closeTo(0.17, 1e-14));
      expect(dsCommandScore('banana', 'ana'), closeTo(0.17, 1e-14));
      expect(dsCommandScore('aaaaaaaaaab', 'ab'), closeTo(0.17, 1e-14));
    });

    test('PENALTY_CASE_MISMATCH fires per character, both directions', () {
      expect(dsCommandScore('Foo Bar', 'foo'), closeTo(0.989901, 1e-12));
      expect(dsCommandScore('Foo Bar', 'FOO'), closeTo(0.9898020099, 1e-13));
      expect(dsCommandScore('XYZ', 'x'), closeTo(0.989901, 1e-12));
      expect(dsCommandScore('xyz', 'X'), closeTo(0.989901, 1e-12));
    });

    test('no match at all is a hard 0 — which is what hides the row', () {
      expect(dsCommandScore('abcdef', 'fa'), 0);
      expect(dsCommandScore(eclipse, 'zzz'), 0);
      expect(dsCommandScore(golden, 'zzz'), 0);
      expect(dsCommandScore(wallet, 'zzz'), 0);
      expect(dsCommandScore(stash, 'zzz'), 0);
    });

    test('aliases join the searchable string rather than scoring apart', () {
      expect(dsCommandScore('Open Wallet', 'money'), 0);
      expect(
        dsCommandScore('Open Wallet', 'money', <String>['money', 'cash']),
        closeTo(0.891, 1e-12),
      );
    });

    test('the live palette scores exactly what cmdk scores', () {
      // Pinned from a node run of the reference's own bundle, per query, in
      // the page's own row order.
      final Map<String, List<double>> table = <String, List<double>>{
        's': <double>[0.1683, 0, 0, 0.8909109000000001],
        'st': <double>[0.028439762593208996, 0, 0, 0.8909109000000001],
        'sta': <double>[0, 0, 0, 0.8909109000000001],
        'o': <double>[0, 0.1683, 0.989901, 0.1683],
        'w': <double>[0, 0, 0.8909109000000001, 0],
        'g': <double>[0, 0.989901, 0, 0.989901],
        't': <double>[0.1683, 0.1683, 0.1683, 0.891],
        'to': <double>[0, 0, 0, 0.891],
        'ec': <double>[0.989901, 0, 0, 0],
        'vault': <double>[0.8909109000000001, 0, 0, 0],
        'ault': <double>[0.1683, 0, 0, 0],
        'GOLD': <double>[0, 0.98970302969901, 0, 0],
        'e v': <double>[0.16828317, 0, 0, 0],
        // The shortcut is part of the value, so a price is searchable.
        '48': <double>[0.1683, 0, 0, 0],
      };
      for (final MapEntry<String, List<double>> row in table.entries) {
        final List<String> values = <String>[eclipse, golden, wallet, stash];
        for (int i = 0; i < values.length; i++) {
          expect(
            dsCommandScore(values[i], row.key),
            closeTo(row.value[i], 1e-14),
            reason: 'score of ${values[i]} against "${row.key}"',
          );
        }
      }
    });
  });

  group('DsCommand — L7, the radius the map could not derive', () {
    testWidgets('the root renders --radius-xl on --card, not --radius-lg', (
      WidgetTester t,
    ) async {
      await pumpPalette(t);
      final DsThemeData theme = themeIn(t, DsCommand);
      final BoxDecoration root = rootDecoration(t);

      // *(Measured)* 16px in both themes. twMerge keeps `rounded-xl!` — the
      // important modifier lands it in a different group key from the call
      // site's `rounded-lg` — and `!important` then wins in the cascade.
      expect((root.borderRadius! as BorderRadius).topLeft.x, DsRadii.xl);
      expect(DsRadii.xl, 16);
      // The fill half of the derivation *was* right: `bg-popover` is stripped
      // and `bg-card` survives. Both tokens hold the same value in both themes
      // today, so this pins the one the class list actually carries.
      expect(root.color, theme.card);
      expect(root.border!.top.color, theme.border);
      expect(root.border!.top.width, DsWidths.hairline);
    });

    testWidgets('the radius holds in light as well', (WidgetTester t) async {
      await pumpPalette(t, mode: DsThemeMode.light);
      final DsThemeData theme = themeIn(t, DsCommand);
      final BoxDecoration root = rootDecoration(t);
      expect((root.borderRadius! as BorderRadius).topLeft.x, DsRadii.xl);
      expect(root.color, theme.card);
    });
  });

  group('DsCommand — measured geometry', () {
    testWidgets('every row kind states its own height', (WidgetTester t) async {
      // The browser lays out on a 1/64px grid and reports 34.5625 / 32 /
      // 66.5625; the port derives all three off the type scale, so it lands on
      // the exact ratio the browser is rounding — the same relationship
      // `DsSelect.itemHeight` already documents.
      expect(DsCommand.itemHeight, closeTo(34.571, 0.001));
      expect(DsCommand.headingHeight, 32);
      expect(DsCommand.emptyHeight, closeTo(66.571, 0.001));
      expect(DsCommand.inputHeight, 32);
      expect(DsCommand.listMaxHeight, 288);
    });

    testWidgets('the palette totals what the reference renders', (
      WidgetTester t,
    ) async {
      await pumpPalette(t);
      // §7.2 derives 293.29 and the browser renders **293.25** *(measured)* —
      // the same box, seen through the 1/64px grid. 2 border + 8 root pad +
      // 8 wrapper pad + 32 input + 235.29 list + 8 root pad.
      expect(t.getSize(find.byType(DsCommand)).height, closeTo(293.29, 0.01));

      // The list: two 117.14 groups with a 1px rule between them.
      final double listHeight = t
          .getSize(find.byType(SingleChildScrollView))
          .height;
      expect(listHeight, closeTo(235.29, 0.01));
    });

    testWidgets(
      'the separator is 1px of --border with no air, and full-bleed',
      (WidgetTester t) async {
        await pumpPalette(t);
        final DsThemeData theme = themeIn(t, DsCommand);

        final Finder rule = find.byWidgetPredicate(
          (Widget w) => w is ColoredBox && w.color == theme.border,
        );
        expect(rule, findsOneWidget);
        final Rect ruleRect = t.getRect(rule);
        expect(ruleRect.height, DsWidths.hairline);

        // `-mx-2` cancels the root's `p-2` exactly: the rule spans the root's
        // whole **content** box — *(measured)* 1028 inside a 1030 palette,
        // stopping at the 1px border on each side — while a group sits 8px in
        // from that on both sides.
        final Rect rootRect = t.getRect(find.byType(DsCommand));
        expect(ruleRect.width, rootRect.width - DsWidths.hairline * 2);
        expect(ruleRect.left, rootRect.left + DsWidths.hairline);

        // The root's `p-2`, then the group's own `p-2`, then the heading's
        // `px-3` — 28px from the rule's edge to the first glyph of "Packs".
        final Rect packs = t.getRect(find.text('Packs'));
        expect(
          packs.left,
          closeTo(ruleRect.left + DsCommand.padding + ds(2) + ds(3), 0.01),
        );

        // Drift 7: the rule contributes **no** vertical space of its own. The
        // only air around it is the two groups' own `p-2` — 8 above, 8 below —
        // where `SelectSeparator`'s `my-2` would add 16 more.
        final Rect lastRow = t.getRect(
          find
              .ancestor(
                of: find.text('Golden Rift'),
                matching: find.byType(DecoratedBox),
              )
              .first,
        );
        final Rect nextHeading = t.getRect(
          find
              .ancestor(
                of: find.text('Actions'),
                matching: find.byType(Padding),
              )
              .first,
        );
        expect(ruleRect.top - lastRow.bottom, closeTo(ds(2), 0.01));
        expect(nextHeading.top - ruleRect.bottom, closeTo(ds(2), 0.01));
        expect(DsSelect.separatorHeight, DsWidths.hairline + ds(2) * 2);
      },
    );

    testWidgets('the input group is 32px at radius 12 with no socket', (
      WidgetTester t,
    ) async {
      await pumpPalette(t);
      final DsThemeData theme = themeIn(t, DsCommand);

      final Finder groupBox = find.byWidgetPredicate(
        (Widget w) =>
            w is DecoratedBox &&
            (w.decoration as BoxDecoration).color ==
                theme.input.withValues(alpha: DsCommand.inputFillAlpha),
      );
      expect(groupBox, findsOneWidget);

      final BoxDecoration decoration =
          t.widget<DecoratedBox>(groupBox).decoration as BoxDecoration;
      // `rounded-lg!` — 12, where the family's own group is a pill.
      expect((decoration.borderRadius! as BorderRadius).topLeft.x, DsRadii.lg);
      // `bg-input/30` and `border-input/30`: one alpha, both properties.
      expect(
        decoration.border!.top.color,
        theme.input.withValues(alpha: DsCommand.inputFillAlpha),
      );
      // `shadow-none!` — the socket is removed, not restyled. Nothing in this
      // control paints a `DsMachineSurface` at all.
      expect(
        find.descendant(
          of: find.byType(DsCommand),
          matching: find.byType(DsMachineSurface),
        ),
        findsNothing,
      );
      expect(t.getSize(groupBox).height, DsCommand.inputHeight);

      // `p-2 pb-0` over the root's `p-2`: 1 border + 8 + 8 above the group.
      final Rect rootRect = t.getRect(find.byType(DsCommand));
      expect(
        t.getRect(groupBox).top - rootRect.top,
        DsWidths.hairline + DsCommand.padding + ds(2),
      );
    });

    testWidgets('the heading is the weight-500 member of drift 6', (
      WidgetTester t,
    ) async {
      await pumpPalette(t);
      final DsThemeData theme = themeIn(t, DsCommand);
      final Text heading = t.widget<Text>(find.text('Packs'));
      expect(heading.style!.fontSize, 12);
      expect(heading.style!.fontWeight, FontWeight.w500);
      expect(heading.style!.color, theme.mutedForeground);
      // `px-3 py-2` — 32px around a 16px line box *(measured)*.
      expect(
        t
            .getSize(
              find
                  .ancestor(
                    of: find.text('Packs'),
                    matching: find.byType(Padding),
                  )
                  .first,
            )
            .height,
        DsCommand.headingHeight,
      );
    });

    testWidgets('the shortcut is 12px sans at 0.1em — drift 4, shipped', (
      WidgetTester t,
    ) async {
      await pumpPalette(t);
      final Text price = t.widget<Text>(find.text(r'$48.00'));
      expect(price.style!.fontSize, 12);
      // Sans, not the mono numerical foundation the same page's Do 5 asks for.
      expect(price.style!.fontFamily, contains(DsFonts.sans));
      // `--tracking-widest` 0.1em → 1.2px at 12px *(measured)*.
      expect(price.style!.letterSpacing, closeTo(1.2, 0.001));
    });
  });

  group('DsCommand — the resting state cmdk paints before anyone types', () {
    testWidgets('the first item carries the highlight on first paint', (
      WidgetTester t,
    ) async {
      await pumpPalette(t);
      final DsThemeData theme = themeIn(t, DsCommand);
      // *(Measured)* `data-selected="true"` on Eclipse Vault at rest, over
      // `--muted` — a static, visible state and not a focus artefact.
      expect(selectedRow(t, theme), 'Eclipse Vault');
    });

    testWidgets('the highlight is --muted, the third token on one page', (
      WidgetTester t,
    ) async {
      await pumpPalette(t);
      final DsThemeData theme = themeIn(t, DsCommand);
      expect(rowFill(t, 'Eclipse Vault'), theme.muted);
      expect(rowFill(t, 'Golden Rift'), dsTransparent);
      // Drift 5: `SelectItem` highlights on `--accent`, so the two are not the
      // same token even though they are the same idea.
      expect(theme.muted, isNot(theme.accent));
    });

    testWidgets('the selected row brightens its shortcut and its glyph', (
      WidgetTester t,
    ) async {
      await pumpPalette(t);
      final DsThemeData theme = themeIn(t, DsCommand);
      // `group-data-selected/command-item:text-foreground`.
      expect(
        t.widget<Text>(find.text(r'$48.00')).style!.color,
        theme.foreground,
      );
      expect(
        t.widget<Text>(find.text(r'$120.00')).style!.color,
        theme.mutedForeground,
      );
      // `data-selected:*:[svg]:text-foreground` over `tone="subtle"`.
      final List<DsIcon> glyphs = t
          .widgetList<DsIcon>(find.byType(DsIcon))
          .where((DsIcon i) => i.glyph == DsIconGlyph.search)
          .toList();
      // The addon's Search glyph plus the two rows'.
      expect(glyphs.length, 3);
      expect(glyphs[1].tone, DsIconTone.normal);
      expect(glyphs[2].tone, DsIconTone.subtle);
      // Drift 15: `size="sm"` renders at 16 while the stroke stays 2.4.
      expect(glyphs[1].sizePx, 16);
      expect(DsIcon.strokeFor(16), DsIcon.strokeFor(14));
    });

    testWidgets(
      'the trailing check never paints beside a shortcut — drift 13',
      (WidgetTester t) async {
        await pumpPalette(t);
        // All four rows carry one, so the affordance the component ships is
        // `display:none` on every row the page has.
        expect(
          find.byWidgetPredicate(
            (Widget w) => w is DsIcon && w.glyph == DsIconGlyph.check,
          ),
          findsNothing,
        );
      },
    );
  });

  group('DsCommand — filter and re-sort (RULING L9)', () {
    testWidgets('rows re-sort inside their group as cmdk scores them', (
      WidgetTester t,
    ) async {
      final TextEditingController c = TextEditingController();
      addTearDown(c.dispose);
      await pumpPalette(t, controller: c);
      expect(paletteOrder(t), <String>[
        'Eclipse Vault',
        'Golden Rift',
        'Open Wallet',
        'Go to Stash',
      ]);

      // `t` after a space scores SCORE_SPACE_WORD_JUMP against `Go to Stash`
      // (0.891) and only SCORE_CHARACTER_JUMP mid-word against `Open Wallet`
      // (0.168), so Actions reverses. *(Measured on the live palette.)*
      c.text = 't';
      await t.pump();
      expect(paletteOrder(t), <String>[
        'Eclipse Vault',
        'Golden Rift',
        'Go to Stash',
        'Open Wallet',
      ]);
    });

    testWidgets(
      'groups never re-sort, even when their scores say they should',
      (WidgetTester t) async {
        final TextEditingController c = TextEditingController();
        addTearDown(c.dispose);
        await pumpPalette(t, controller: c);

        // `o` scores Open Wallet 0.99 against Golden Rift 0.168, so cmdk's
        // group pass *intends* to lift Actions above Packs. It cannot: it looks
        // the group element up by its React id against a `data-value` holding
        // the heading, and the selector matches nothing. *(Measured)* Packs
        // stays on top. Reproduced.
        c.text = 'o';
        await t.pump();
        expect(paletteOrder(t), <String>[
          'Golden Rift',
          'Open Wallet',
          'Go to Stash',
        ]);
        expect(DsCommand.sortsGroups, isFalse);
        expect(
          t.getRect(find.text('Packs')).top,
          lessThan(t.getRect(find.text('Actions')).top),
        );
      },
    );

    testWidgets('a group with nothing left stops occupying space', (
      WidgetTester t,
    ) async {
      final TextEditingController c = TextEditingController();
      addTearDown(c.dispose);
      await pumpPalette(t, controller: c);

      c.text = 'w';
      await t.pump();
      // *(Measured)* Packs takes the `hidden` attribute — heading, padding and
      // all — and the palette collapses to 140.56.
      expect(find.text('Packs'), findsNothing);
      expect(find.text('Actions'), findsOneWidget);
      expect(paletteOrder(t), <String>['Open Wallet']);
      expect(t.getSize(find.byType(DsCommand)).height, closeTo(140.57, 0.02));
    });

    testWidgets('the shortcut is part of what gets searched', (
      WidgetTester t,
    ) async {
      final TextEditingController c = TextEditingController();
      addTearDown(c.dispose);
      await pumpPalette(t, controller: c);

      // cmdk derives an item's value from its rendered text, and the shortcut
      // is rendered text: *(measured)* `data-value="Eclipse Vault$48.00"`.
      c.text = '48';
      await t.pump();
      expect(paletteOrder(t), <String>['Eclipse Vault']);
    });

    testWidgets('the query is case- and position-insensitive', (
      WidgetTester t,
    ) async {
      final TextEditingController c = TextEditingController();
      addTearDown(c.dispose);
      await pumpPalette(t, controller: c);

      c.text = 'GOLD';
      await t.pump();
      expect(paletteOrder(t), <String>['Golden Rift']);

      c.text = 'ault';
      await t.pump();
      expect(paletteOrder(t), <String>['Eclipse Vault']);

      c.text = 'e v';
      await t.pump();
      expect(paletteOrder(t), <String>['Eclipse Vault']);
    });

    testWidgets('the highlight returns to the top on every keystroke', (
      WidgetTester t,
    ) async {
      final TextEditingController c = TextEditingController();
      addTearDown(c.dispose);
      await pumpPalette(t, controller: c);
      final DsThemeData theme = themeIn(t, DsCommand);

      c.text = 'o';
      await t.pump();
      // `setState('search', …)` schedules `selectFirstItem()` unconditionally.
      expect(selectedRow(t, theme), 'Golden Rift');

      c.text = 'w';
      await t.pump();
      expect(selectedRow(t, theme), 'Open Wallet');
    });

    testWidgets('the separator leaves the moment anything is typed', (
      WidgetTester t,
    ) async {
      final TextEditingController c = TextEditingController();
      addTearDown(c.dispose);
      await pumpPalette(t, controller: c);
      final DsThemeData theme = themeIn(t, DsCommand);
      final Finder rule = find.byWidgetPredicate(
        (Widget w) => w is ColoredBox && w.color == theme.border,
      );

      expect(rule, findsOneWidget);
      final double whole = t.getSize(find.byType(DsCommand)).height;

      // cmdk's `Separator` renders only when `!state.search` — *(measured)* it
      // leaves the DOM on the first keystroke and comes back on clearing, a
      // 1px swing in the palette's height.
      c.text = 't';
      await t.pump();
      expect(rule, findsNothing);
      expect(
        t.getSize(find.byType(DsCommand)).height,
        closeTo(whole - DsWidths.hairline, 0.001),
      );

      c.text = '';
      await t.pump();
      expect(rule, findsOneWidget);
      expect(t.getSize(find.byType(DsCommand)).height, closeTo(whole, 0.001));
    });

    testWidgets('shouldFilter: false shows the source list untouched', (
      WidgetTester t,
    ) async {
      final TextEditingController c = TextEditingController();
      addTearDown(c.dispose);
      await pumpPalette(t, controller: c, shouldFilter: false);

      c.text = 'zzz';
      await t.pump();
      expect(paletteOrder(t), <String>[
        'Eclipse Vault',
        'Golden Rift',
        'Open Wallet',
        'Go to Stash',
      ]);
    });
  });

  group('DsCommand — the empty state', () {
    testWidgets('it mounts only when the filtered count reaches zero', (
      WidgetTester t,
    ) async {
      final TextEditingController c = TextEditingController();
      addTearDown(c.dispose);
      await pumpPalette(t, controller: c);

      expect(find.text('Nothing matches that.'), findsNothing);

      c.text = 'zzz';
      await t.pump();
      expect(find.text('Nothing matches that.'), findsOneWidget);
      expect(paletteOrder(t), isEmpty);
      expect(find.text('Packs'), findsNothing);
      expect(find.text('Actions'), findsNothing);
    });

    testWidgets('it is `py-6` of --popover-foreground, and not muted', (
      WidgetTester t,
    ) async {
      final TextEditingController c = TextEditingController();
      addTearDown(c.dispose);
      await pumpPalette(t, controller: c);
      final DsThemeData theme = themeIn(t, DsCommand);

      c.text = 'zzz';
      await t.pump();
      final Text empty = t.widget<Text>(find.text('Nothing matches that.'));
      // *(Measured)* rgb(250,250,250) — inherited from the root, where
      // `ComboboxEmpty` declares `text-muted-foreground` for itself.
      expect(empty.style!.color, theme.popoverForeground);
      expect(empty.textAlign, TextAlign.center);
      expect(
        t
            .getSize(
              find
                  .ancestor(
                    of: find.text('Nothing matches that.'),
                    matching: find.byType(Padding),
                  )
                  .first,
            )
            .height,
        closeTo(DsCommand.emptyHeight, 0.001),
      );
      // *(Measured)* 124.56 with only the empty row showing.
      expect(t.getSize(find.byType(DsCommand)).height, closeTo(124.57, 0.02));
    });

    testWidgets('with no emptyLabel nothing is rendered in its place', (
      WidgetTester t,
    ) async {
      final TextEditingController c = TextEditingController();
      addTearDown(c.dispose);
      await pumpPalette(t, controller: c, emptyLabel: null);
      c.text = 'zzz';
      await t.pump();
      expect(paletteOrder(t), isEmpty);
      expect(find.text('Nothing matches that.'), findsNothing);
    });
  });

  group('DsCommand — keyboard', () {
    testWidgets('the arrows step and then stop — `loop` is unset', (
      WidgetTester t,
    ) async {
      final FocusNode node = FocusNode();
      addTearDown(node.dispose);
      await pumpPalette(t, focusNode: node);
      final DsThemeData theme = themeIn(t, DsCommand);
      node.requestFocus();
      await t.pump();

      expect(selectedRow(t, theme), 'Eclipse Vault');
      for (final String expected in <String>[
        'Golden Rift', 'Open Wallet', 'Go to Stash',
        // *(Measured)* five ArrowDowns leave the fourth row selected: the
        // ring does not close, and it steps across the group boundary without
        // pausing on the heading.
        'Go to Stash', 'Go to Stash',
      ]) {
        await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await t.pump();
        expect(selectedRow(t, theme), expected);
      }

      await t.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      await t.pump();
      expect(selectedRow(t, theme), 'Open Wallet');
    });

    testWidgets('Home and End take the ends', (WidgetTester t) async {
      final FocusNode node = FocusNode();
      addTearDown(node.dispose);
      await pumpPalette(t, focusNode: node);
      final DsThemeData theme = themeIn(t, DsCommand);
      node.requestFocus();
      await t.pump();

      await t.sendKeyEvent(LogicalKeyboardKey.end);
      await t.pump();
      expect(selectedRow(t, theme), 'Go to Stash');

      await t.sendKeyEvent(LogicalKeyboardKey.home);
      await t.pump();
      expect(selectedRow(t, theme), 'Eclipse Vault');
    });

    testWidgets('vimBindings map Ctrl+N and Ctrl+P onto the arrows', (
      WidgetTester t,
    ) async {
      final FocusNode node = FocusNode();
      addTearDown(node.dispose);
      await pumpPalette(t, focusNode: node);
      final DsThemeData theme = themeIn(t, DsCommand);
      node.requestFocus();
      await t.pump();

      await sendCtrl(t, LogicalKeyboardKey.keyN);
      expect(selectedRow(t, theme), 'Golden Rift');
      await sendCtrl(t, LogicalKeyboardKey.keyJ);
      expect(selectedRow(t, theme), 'Open Wallet');
      await sendCtrl(t, LogicalKeyboardKey.keyP);
      expect(selectedRow(t, theme), 'Golden Rift');
      // The page advertises Ctrl+K as what *opens* the palette (drift 3,
      // nothing binds it); inside the palette it already means "up".
      await sendCtrl(t, LogicalKeyboardKey.keyK);
      expect(selectedRow(t, theme), 'Eclipse Vault');
    });

    testWidgets('vimBindings: false leaves Ctrl+N alone', (
      WidgetTester t,
    ) async {
      final FocusNode node = FocusNode();
      addTearDown(node.dispose);
      await pumpPalette(t, focusNode: node, vimBindings: false);
      final DsThemeData theme = themeIn(t, DsCommand);
      node.requestFocus();
      await t.pump();

      await sendCtrl(t, LogicalKeyboardKey.keyN);
      expect(selectedRow(t, theme), 'Eclipse Vault');
    });

    testWidgets('Enter fires the selected row and nothing else', (
      WidgetTester t,
    ) async {
      final FocusNode node = FocusNode();
      addTearDown(node.dispose);
      final List<String> fired = <String>[];
      await pumpPalette(t, focusNode: node, fired: fired);
      node.requestFocus();
      await t.pump();

      await t.sendKeyEvent(LogicalKeyboardKey.enter);
      await t.pump();
      expect(fired, <String>['Eclipse Vault']);

      await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await t.pump();
      await t.sendKeyEvent(LogicalKeyboardKey.enter);
      await t.pump();
      expect(fired, <String>['Eclipse Vault', 'Golden Rift']);
    });

    testWidgets('loop: true closes the ring, which the page does not ask for', (
      WidgetTester t,
    ) async {
      final FocusNode node = FocusNode();
      addTearDown(node.dispose);
      await pumpPalette(t, focusNode: node, loop: true);
      final DsThemeData theme = themeIn(t, DsCommand);
      node.requestFocus();
      await t.pump();

      for (int i = 0; i < 4; i++) {
        await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await t.pump();
      }
      expect(selectedRow(t, theme), 'Eclipse Vault');
    });
  });

  group('DsCommand — pointer', () {
    testWidgets(
      'hover takes the highlight and keeps it after the pointer goes',
      (WidgetTester t) async {
        await pumpPalette(t);
        final DsThemeData theme = themeIn(t, DsCommand);

        final TestGesture gesture = await t.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        await gesture.addPointer(location: Offset.zero);
        addTearDown(gesture.removePointer);

        // `onPointerMove` — `disablePointerSelection` defaults false.
        await gesture.moveTo(t.getCenter(find.text('Go to Stash')));
        await t.pump();
        expect(selectedRow(t, theme), 'Go to Stash');

        await gesture.moveTo(t.getCenter(find.text('Golden Rift')));
        await t.pump();
        expect(selectedRow(t, theme), 'Golden Rift');

        // *(Measured)* moving off the palette leaves the last-hovered row
        // highlighted: there is no matching pointer-leave handler.
        await gesture.moveTo(Offset.zero);
        await t.pump();
        expect(selectedRow(t, theme), 'Golden Rift');
      },
    );

    testWidgets('a tap commits the row it lands on', (WidgetTester t) async {
      final List<String> fired = <String>[];
      await pumpPalette(t, fired: fired);
      final DsThemeData theme = themeIn(t, DsCommand);

      await t.tap(find.text('Open Wallet'));
      await t.pump();
      expect(fired, <String>['Open Wallet']);
      expect(selectedRow(t, theme), 'Open Wallet');
    });

    testWidgets('a disabled row is skipped by the arrows and by the pointer', (
      WidgetTester t,
    ) async {
      final FocusNode node = FocusNode();
      addTearDown(node.dispose);
      final List<String> fired = <String>[];
      await pumpPalette(
        t,
        focusNode: node,
        fired: fired,
        groups: <DsCommandGroup>[
          DsCommandGroup(
            heading: 'Packs',
            items: <DsCommandItem>[
              DsCommandItem(
                label: 'Eclipse Vault',
                shortcut: r'$48.00',
                onSelect: () => fired.add('Eclipse Vault'),
              ),
              const DsCommandItem(
                label: 'Golden Rift',
                shortcut: r'$120.00',
                enabled: false,
              ),
              DsCommandItem(
                label: 'Open Wallet',
                shortcut: '⌘W',
                onSelect: () => fired.add('Open Wallet'),
              ),
            ],
          ),
        ],
      );
      final DsThemeData theme = themeIn(t, DsCommand);
      node.requestFocus();
      await t.pump();

      // `getValidItems()` filters `[aria-disabled="true"]` out of the ring
      // before the arrows ever see it.
      await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await t.pump();
      expect(selectedRow(t, theme), 'Open Wallet');

      await t.tap(find.text('Golden Rift'));
      await t.pump();
      expect(fired, isEmpty);
    });
  });

  group('DsComponentType.menuHeading — RULING L8, probe-confirmed', () {
    test('it is menuLabel at weight 500', () {
      final DsTypeSpec heading = DsComponentType.menuHeading;
      final DsTypeSpec label = DsComponentType.menuLabel;
      // *(Measured)* the live `CommandGroup` heading computes 12px / 16px
      // line box / weight 500 at `font-variation-settings: normal` — which is
      // what L8 made the fourth spec conditional on.
      expect(heading.size, 12);
      expect(heading.height! * heading.size!, 16);
      expect(heading.weight, FontWeight.w500);
      expect(heading.family, DsFonts.sans);
      expect(heading.tracking, isNull);
      // One weight step from `SelectLabel`'s, and that step is drift 6.
      expect(heading.size, label.size);
      expect(heading.height, label.height);
      expect(heading.weight, isNot(label.weight));
    });
  });

  group('DsInputGroupButton — the icon-xs rung, promoted', () {
    testWidgets('icon-xs is a 24×24 square where xs is content-width', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        host(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              DsInputGroupButton(
                size: DsInputGroupButtonSize.iconXs,
                onPressed: () {},
                child: const DsIcon(DsIconGlyph.chevronDown),
              ),
              // The same 16px chevron in the default rung, which is the
              // comparison `combobox.dart`'s promotion note was making.
              DsInputGroupButton(
                onPressed: () {},
                child: const DsIcon(DsIconGlyph.chevronDown),
              ),
            ],
          ),
        ),
      );

      final List<Size> sizes = t
          .widgetList<DsInputGroupButton>(find.byType(DsInputGroupButton))
          .map((DsInputGroupButton b) => t.getSize(find.byWidget(b)))
          .toList();
      // `size-6 p-0 has-[>svg]:p-0` — a 24 × 24 square.
      expect(
        sizes[0],
        Size(DsInputGroupButton.height, DsInputGroupButton.height),
      );
      // `h-6 px-1.5` — 24 tall, and as wide as its content. Around the same
      // glyph that is wider than the square, which is exactly why the combobox
      // trigger needed the `icon-xs` rung rather than the default one.
      expect(sizes[1].height, DsInputGroupButton.height);
      expect(sizes[1].width, greaterThan(sizes[0].width));

      expect(DsInputGroupButton.paddingXFor(DsInputGroupButtonSize.iconXs), 0);
      expect(
        DsInputGroupButton.paddingXFor(DsInputGroupButtonSize.xs),
        DsInputGroupButton.paddingX,
      );
      // Both rungs wear `calc(var(--radius) - 3px)`.
      expect(DsRadii.addonButton, 7);
    });

    testWidgets('cancelPressFill is `data-pressed:bg-transparent`', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        host(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              DsInputGroupButton(
                size: DsInputGroupButtonSize.iconXs,
                cancelPressFill: true,
                onPressed: () {},
                child: const DsIcon(DsIconGlyph.chevronDown),
              ),
              DsInputGroupButton(
                size: DsInputGroupButtonSize.iconXs,
                onPressed: () {},
                child: const DsIcon(DsIconGlyph.chevronUp),
              ),
            ],
          ),
        ),
      );
      final DsThemeData theme = themeIn(t, DsInputGroupButton);

      final TestGesture cancelled = await t.startGesture(
        t.getCenter(find.byType(DsIcon).first),
      );
      final TestGesture plain = await t.startGesture(
        t.getCenter(find.byType(DsIcon).last),
      );
      await t.pump(DsDurations.base);
      await t.pump(DsDurations.base);

      final List<DsMachineSurface> surfaces = t
          .widgetList<DsMachineSurface>(find.byType(DsMachineSurface))
          .toList();
      // The ghost variant's `active:bg-muted`, and the call-site class that
      // cancels it — press deepens one and leaves the other where it was.
      expect(surfaces[0].fill, dsTransparent);
      expect(surfaces[1].fill, theme.muted);

      await cancelled.up();
      await plain.up();
      await t.pump();
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

// ── B1 helpers ─────────────────────────────────────────────────────────────

/// The palette's own four rows (selects-map §7.3), verbatim and in order.
///
/// `Icon Search size="sm" tone="subtle"` leads the two packs; the two actions
/// carry no glyph. Every row carries a shortcut, which is what makes drift 13
/// unobservable on this page and what puts the prices inside the searchable
/// value.
List<DsCommandGroup> paletteGroups({List<String>? fired}) {
  DsCommandItem row(String label, String shortcut, {DsIconGlyph? icon}) =>
      DsCommandItem(
        label: label,
        icon: icon,
        shortcut: shortcut,
        onSelect: fired == null ? null : () => fired.add(label),
      );
  return <DsCommandGroup>[
    DsCommandGroup(
      heading: 'Packs',
      items: <DsCommandItem>[
        row('Eclipse Vault', r'$48.00', icon: DsIconGlyph.search),
        row('Golden Rift', r'$120.00', icon: DsIconGlyph.search),
      ],
    ),
    DsCommandGroup(
      heading: 'Actions',
      // The one `<CommandSeparator />` the page writes, between the groups.
      separatorBefore: true,
      items: <DsCommandItem>[
        row('Open Wallet', '⌘W'),
        row('Go to Stash', '⌘S'),
      ],
    ),
  ];
}

/// Mounts the palette at the Panel's measured width and lets the first-item
/// selection land.
///
/// The extra pump is not padding: cmdk selects the first item on the schedule
/// that follows the first render (`if (!state.value) selectFirstItem()`), and
/// the port puts that on the matching post-frame callback.
Future<void> pumpPalette(
  WidgetTester t, {
  TextEditingController? controller,
  FocusNode? focusNode,
  List<DsCommandGroup>? groups,
  List<String>? fired,
  DsThemeMode mode = DsThemeMode.dark,
  bool shouldFilter = true,
  bool loop = false,
  bool vimBindings = true,
  String? emptyLabel = 'Nothing matches that.',
}) async {
  await t.pumpWidget(
    host(
      SizedBox(
        // *(Measured)* the palette fills the Panel at 1030px on a 1440 viewport.
        width: 1030,
        child: DsCommand(
          groups: groups ?? paletteGroups(fired: fired),
          controller: controller,
          focusNode: focusNode,
          shouldFilter: shouldFilter,
          loop: loop,
          vimBindings: vimBindings,
          placeholder: 'Search packs, cards and actions\u2026',
          emptyLabel: emptyLabel,
        ),
      ),
      mode: mode,
    ),
  );
  await t.pump();
}

/// Every label the palette can show, in the order it was declared.
const List<String> _paletteLabels = <String>[
  'Eclipse Vault',
  'Golden Rift',
  'Open Wallet',
  'Go to Stash',
];

/// The rows the palette is showing, **top to bottom** — which is the thing
/// L9 is about: cmdk's sort is a DOM reorder, so paint position is the only
/// honest reading of it.
List<String> paletteOrder(WidgetTester t) {
  final List<(String, double)> seen = <(String, double)>[];
  for (final String label in _paletteLabels) {
    final Finder f = find.text(label);
    if (f.evaluate().isEmpty) continue;
    seen.add((label, t.getRect(f).top));
  }
  seen.sort(((String, double) a, (String, double) b) => a.$2.compareTo(b.$2));
  return seen.map(((String, double) e) => e.$1).toList();
}

/// The fill a row is painting — `data-selected:bg-muted`, or nothing.
Color rowFill(WidgetTester t, String label) {
  final BoxDecoration decoration = t
      .widgetList<DecoratedBox>(
        find.ancestor(
          of: find.text(label),
          matching: find.byType(DecoratedBox),
        ),
      )
      .map((DecoratedBox b) => b.decoration as BoxDecoration)
      .firstWhere((BoxDecoration d) => d.borderRadius != null);
  return decoration.color ?? dsTransparent;
}

/// Which row carries `data-selected` — the one over `--muted`.
String? selectedRow(WidgetTester t, DsThemeData theme) {
  for (final String label in _paletteLabels) {
    if (find.text(label).evaluate().isEmpty) continue;
    if (rowFill(t, label) == theme.muted) return label;
  }
  return null;
}

/// The palette root's own decoration — the L7 reading.
BoxDecoration rootDecoration(WidgetTester t) => t
    .widgetList<DecoratedBox>(
      find.descendant(
        of: find.byType(DsCommand),
        matching: find.byType(DecoratedBox),
      ),
    )
    .map((DecoratedBox b) => b.decoration as BoxDecoration)
    .firstWhere(
      (BoxDecoration d) => d.border != null && d.borderRadius != null,
    );

/// One `Ctrl`-modified keystroke, and a pump to settle it.
Future<void> sendCtrl(WidgetTester t, LogicalKeyboardKey key) async {
  await t.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
  await t.sendKeyEvent(key);
  await t.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
  await t.pump();
}
