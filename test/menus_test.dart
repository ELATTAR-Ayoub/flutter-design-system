import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/gestures.dart' show PointerDeviceKind, kSecondaryButton;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart'
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
        TableColumnWidth;
import 'package:flutter_test/flutter_test.dart';

/// The menu family: `dropdown-menu.tsx`, `context-menu.tsx`, `menubar.tsx` and
/// the five knobs they added to `Popover`.
///
/// Numbers marked *(measured)* / *(probed)* were read off the live reference at
/// `localhost:3000/design-system/components/base/menus` on 2026-08-16 by
/// driving real input and sampling with `getComputedStyle` /
/// `getBoundingClientRect` — never derived from the class list.

/// What [overlayHost] is currently showing. `initialEntries` is read once, in
/// `initState`, so the child has to reach the entry through a holder.
Widget _hosted = const SizedBox.shrink();

Widget overlayHost(
  Widget child, {
  ColorMode mode = ColorMode.dark,
  Size size = const Size(1440, 900),
  Alignment align = Alignment.center,
}) {
  _hosted = child;
  return MediaQuery(
    data: MediaQueryData(size: size),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: ThemeScope(
        controller: ThemeController(mode: mode),
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

/// The reference frame. **Load-bearing for the context menu**: its submenu
/// flips to the left when the viewport cannot hold it, which is a real
/// behaviour and not the one under test.
void useFrame(WidgetTester tester, [Size size = const Size(1440, 900)]) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

/// One frame for the prop to flip, one more for the portal the frame boundary
/// brings in.
Future<void> settleOverlay(WidgetTester tester) async {
  await tester.pump();
  await tester.pump();
}

/// Runs an overlay's 320ms exit out and lets the portal unmount behind it.
///
/// Four frames, not three: `Popover` starts its reverse from a **post-frame**
/// callback, so the controller's first tick is one frame after `open` flipped
/// and the run ends one frame after that.
Future<void> runOverlay(WidgetTester tester) async {
  for (int i = 0; i < 4; i++) {
    await tester.pump(MotionDurations.overlayEnter);
  }
  await tester.pump();
}

/// Hovers [finder]'s centre, the way a pointer moving over a menu does.
///
/// Each call takes its own pointer id: two live pointers with the same id trip
/// `MouseTracker`'s add/remove assertion, and a test that drives two themes in
/// one body hovers twice.
int _pointer = 100;

Future<TestGesture> hover(WidgetTester tester, Finder finder) async {
  final TestGesture gesture = await tester.createGesture(
    kind: PointerDeviceKind.mouse,
    pointer: _pointer++,
  );
  await gesture.addPointer(location: Offset.zero);
  addTearDown(gesture.removePointer);
  await gesture.moveTo(tester.getCenter(finder));
  await tester.pump();
  return gesture;
}

/// The account menu, verbatim from the page.
List<MenuChild> accountMenu({VoidCallback? onSignOut}) => <MenuChild>[
  const MenuLabel('voidwing'),
  const MenuSeparator(),
  const MenuGroup(
    children: <MenuChild>[
      MenuItem(label: 'Wallet', icon: IconGlyph.wallet, shortcut: r'$1,204.80'),
      MenuItem(label: 'Favourites', icon: IconGlyph.heart),
      MenuItem(label: 'Preferences', icon: IconGlyph.settings),
    ],
  ),
  const MenuSeparator(),
  MenuItem(
    label: 'Sign out',
    icon: IconGlyph.logOut,
    variant: MenuItemVariant.destructive,
    onSelect: onSignOut,
  ),
];

/// The context menu, verbatim from the page.
const List<MenuChild> stashMenu = <MenuChild>[
  MenuItem(label: 'Favourite', icon: IconGlyph.heart, shortcut: 'F'),
  MenuItem(label: 'Share pull', icon: IconGlyph.share2),
  MenuSub(
    label: 'Shipping',
    icon: IconGlyph.truck,
    children: <MenuChild>[
      MenuItem(label: 'Add to shipment'),
      MenuItem(label: 'Ship immediately'),
    ],
  ),
  MenuSeparator(),
  MenuItem(
    label: r'Sell for $1,240.00',
    icon: IconGlyph.trash2,
    variant: MenuItemVariant.destructive,
  ),
];

Finder rowText(String text) => find.text(text);

Color? fillOf(WidgetTester tester, String label) {
  final Finder box = find
      .ancestor(of: find.text(label), matching: find.byType(DecoratedBox))
      .first;
  return (tester.widget<DecoratedBox>(box).decoration as BoxDecoration).color;
}

void main() {
  /* ── Geometry ──────────────────────────────────────────────────────────── */

  group('Menu geometry', () {
    test('a row is `py-2` around one `text-sm` line box', () {
      // *(Measured: every `*MenuItem` on the page is 34.5625 tall — Chrome's
      // quantisation of the 18.5714px line box.)*
      expect(Menu.itemHeight, closeTo(34.571, 0.001));
      // The select's rows are the same rung, and must stay the same number.
      expect(Menu.itemHeight, Select.itemHeight);
    });

    test('a two-line row is that plus `gap-1` and a caption line box', () {
      // `flex-col items-start gap-1` — the shape the agent console's
      // `ModelPicker` writes, and the only two-line row in the corpus:
      // 16 (`py-2`) + 18.5714 (`text-sm`) + 4 (`gap-1`) + 14.175
      // (`.type-caption`).
      expect(Menu.twoLineItemHeight, closeTo(52.746, 0.001));
      expect(
        Menu.twoLineItemHeight - Menu.itemHeight,
        closeTo(4 + 14.175, 0.001),
      );
      // The command palette's two-line row is the same two line boxes in the
      // same padding and **48.7**, because a command row writes no gap between
      // them. Two components, two numbers, one reference — so this is the
      // assertion that catches the first one being copied onto the second.
      expect(Menu.twoLineItemHeight - 48.7, closeTo(4, 0.05));
    });

    test('a subtitle is what makes a row two lines, and nothing else does', () {
      const List<MenuChild> oneLine = <MenuChild>[
        MenuItem(label: 'Fast', shortcut: 'Answers in a second'),
      ];
      const List<MenuChild> twoLine = <MenuChild>[
        MenuItem(label: 'Fast', subtitle: 'Answers in a second'),
      ];
      // The same string in the two slots: beside the label it costs nothing,
      // under it costs a line box and the gap. That difference is the whole of
      // the console's divergence 2, in one number.
      expect(
        MenuContent.heightOf(oneLine),
        closeTo(Menu.contentPadding * 2 + Menu.itemHeight, 0.001),
      );
      expect(
        MenuContent.heightOf(twoLine),
        closeTo(Menu.contentPadding * 2 + Menu.twoLineItemHeight, 0.001),
      );
    });

    test('a label is 12px/500 in a 16px line box, `py-2` — 32', () {
      // *(Measured: "Visible columns" occupies exactly 32.)*
      expect(Menu.labelHeight, 32);
      // `font-medium` — `menuHeading`, not `menuLabel`. `SelectLabel` writes
      // no `font-*` class and this one does; the sizes match, the weights do
      // not.
      expect(Menu.labelHeight, Select.labelHeight);
      expect(TextStyles.menuHeading.weight, FontWeight.w500);
      expect(TextStyles.menuLabel.weight, FontWeight.w400);
    });

    test('a separator occupies 17', () {
      expect(Menu.separatorHeight, 17);
    });

    test('the account menu adds up to the 236.25 the reference renders', () {
      // 8 + 32 + 17 + 3×34.5625 + 17 + 34.5625 + 8. The page's own label is a
      // two-line block (48 rather than 32), which is the 16px difference
      // between this sum and the measured 236.25.
      expect(MenuContent.heightOf(accountMenu()), closeTo(236.25 - 16, 0.05));
    });

    test('the context menu adds up to the 171.25 the reference renders', () {
      // 8 + 3×34.5625 + 17 + 34.5625 + 8 = 171.25. A `MenuSub` row is one
      // item tall, and the separator is 17.
      expect(MenuContent.heightOf(stashMenu), closeTo(171.25, 0.05));
    });

    test('the min-widths are the three the family writes', () {
      expect(Menu.minWidthDropdown, 160); // `min-w-40`
      expect(Menu.minWidthMenu, 144); // `min-w-36`
      expect(Menu.minWidthSub, 160); // `min-w-40`
      expect(Menu.minWidthSubDropdown, 96); // `min-w-24`
    });

    test('a `*MenuGroup` paints nothing and adds nothing', () {
      // *(Measured: the account menu's group is exactly 3 × 34.5625 with no
      // gap above, below or between.)*
      const List<MenuChild> flat = <MenuChild>[
        MenuItem(label: 'a'),
        MenuItem(label: 'b'),
      ];
      const List<MenuChild> grouped = <MenuChild>[MenuGroup(children: flat)];
      expect(MenuContent.heightOf(grouped), MenuContent.heightOf(flat));
    });
  });

  /* ── The dropdown ──────────────────────────────────────────────────────── */

  group('DropdownMenu', () {
    testWidgets('opens on pointer-DOWN, not on the tap', (
      WidgetTester t,
    ) async {
      useFrame(t);
      // *(Measured: the `enter` animation backdates to the physical press at
      // t=146.7, 93ms before the `pointerup` at t=240.1.)*
      await t.pumpWidget(
        overlayHost(
          DropdownMenu(
            trigger: const _Trigger(width: 111),
            children: accountMenu(),
          ),
        ),
      );

      final TestGesture gesture = await t.startGesture(
        t.getCenter(find.byType(DropdownMenu)),
      );
      await settleOverlay(t);
      expect(
        find.text('Wallet'),
        findsOneWidget,
        reason: 'the menu is open before the finger lifts',
      );
      await gesture.up();
      await t.pump();
      expect(find.text('Wallet'), findsOneWidget);
    });

    testWidgets('places the content 4px under the trigger, edges flush', (
      WidgetTester t,
    ) async {
      useFrame(t);
      // *(Measured: trigger bottom 579.14, content top 583 — `sideOffset={4}`
      // and `align="start"`.)*
      await t.pumpWidget(
        overlayHost(
          DropdownMenu(
            width: 240,
            trigger: const _Trigger(width: 111.40625),
            children: accountMenu(),
          ),
          align: Alignment.topLeft,
        ),
      );
      await t.tap(find.byType(DropdownMenu));
      await settleOverlay(t);
      await t.pump(MotionDurations.overlayEnter);

      final Rect trigger = t.getRect(find.byType(_Trigger));
      final Rect content = t.getRect(find.byType(MenuContent));
      expect(content.top - trigger.bottom, closeTo(4, 0.01));
      expect(content.left, closeTo(trigger.left, 0.01));
      expect(content.width, 240, reason: '`w-60` beats the trigger width');
    });

    testWidgets('GAP CLOSED: a subtitle stacks UNDER the label, and the row '
        'grows for it', (WidgetTester t) async {
      useFrame(t);
      // The agent console's `ModelPicker`, in miniature. Its hint rode the
      // `shortcut` slot for as long as [MenuItem] had no second line, which
      // put it *beside* the label — recorded as the console's divergence 2 and
      // closed by this slot.
      const List<MenuChild> models = <MenuChild>[
        MenuItem(label: 'Fast', subtitle: 'Answers in a second'),
        MenuItem(label: 'Deep', subtitle: 'Slower, checks its work'),
      ];
      await t.pumpWidget(
        overlayHost(
          const DropdownMenu(trigger: _Trigger(width: 111), children: models),
        ),
      );
      await t.tap(find.byType(DropdownMenu));
      await settleOverlay(t);
      await t.pump(MotionDurations.overlayEnter);

      final Rect label = t.getRect(find.text('Fast'));
      final Rect hint = t.getRect(find.text('Answers in a second'));
      // Under, and left-aligned with it — `flex-col items-start`. Beside is
      // exactly what the divergence was, so this is the assertion that bites.
      expect(hint.top, greaterThan(label.top));
      expect(hint.left, closeTo(label.left, 0.01));
      // `gap-1`, measured between the two **painted** text boxes and so a
      // tenth short of the declared 4: this suite loads no font binaries, and
      // the test engine's fallback face paints a `text-sm` run a hair taller
      // than the 18.5714 line box the layout reserves for it. The overshoot
      // comes off the label's bottom edge rather than out of the gap — which
      // is why the row's own height below is the number to hold, and this one
      // is only here to say the gap exists at all.
      expect(hint.top - label.bottom, closeTo(space(1), 0.2));

      // …and the popup really is two tall rows and its own `p-2`, rather than
      // two short rows with an overflowing child.
      expect(
        t.getSize(find.byType(MenuContent)).height,
        closeTo(MenuContent.heightOf(models), 0.05),
      );
      expect(
        t.getSize(find.byType(MenuContent)).height,
        closeTo(Menu.contentPadding * 2 + Menu.twoLineItemHeight * 2, 0.05),
      );
      expect(t.takeException(), isNull);
    });

    testWidgets('the highlight snaps, and recolours icon and shortcut too', (
      WidgetTester t,
    ) async {
      useFrame(t);
      // *(Measured: `transition-property: all` at `transition-duration: 0s` on
      // every row, and a highlighted row's `<svg>` and `*MenuShortcut` both
      // compute `--accent-foreground`.)*
      await t.pumpWidget(
        overlayHost(
          DropdownMenu(
            trigger: const _Trigger(width: 111),
            children: accountMenu(),
          ),
        ),
      );
      await t.tap(find.byType(DropdownMenu));
      await settleOverlay(t);
      await t.pump(MotionDurations.overlayEnter);

      final ThemeTokens theme = ThemeScope.of(
        t.element(find.byType(MenuContent)),
      );
      expect(fillOf(t, 'Wallet'), isNull);

      await hover(t, find.text('Wallet'));
      // One frame. No tween, no curve.
      expect(fillOf(t, 'Wallet'), theme.accent);

      final StyledText shortcut = t.widget<StyledText>(
        find.byWidgetPredicate(
          (Widget w) => w is StyledText && w.text == r'$1,204.80',
        ),
      );
      expect(shortcut.color, theme.accentForeground);
      expect(shortcut.spec, TextStyles.menuShortcut);
    });

    // *(Measured: `--destructive` at 20% on dark, 10% on light, with
    // `--destructive-ink` kept for the label and the glyph.)* One theme per
    // test body: two live mouse pointers in one body share a device id, and
    // `MouseTracker` asserts on the second add.
    Future<void> destructiveTint(
      WidgetTester t,
      ColorMode mode,
      double alpha,
    ) async {
      useFrame(t);
      await t.pumpWidget(
        overlayHost(
          DropdownMenu(
            trigger: const _Trigger(width: 111),
            children: accountMenu(),
          ),
          mode: mode,
        ),
      );
      await t.tap(find.byType(DropdownMenu));
      await settleOverlay(t);
      await t.pump(MotionDurations.overlayEnter);

      final ThemeTokens theme = ThemeScope.of(
        t.element(find.byType(MenuContent)),
      );
      expect(
        t
            .widget<StyledText>(
              find.byWidgetPredicate(
                (Widget w) => w is StyledText && w.text == 'Sign out',
              ),
            )
            .color,
        theme.destructiveText,
      );

      await hover(t, find.text('Sign out'));
      expect(fillOf(t, 'Sign out'), theme.destructive.withValues(alpha: alpha));
      // Still destructive ink, not accent-foreground.
      expect(
        t
            .widget<StyledText>(
              find.byWidgetPredicate(
                (Widget w) => w is StyledText && w.text == 'Sign out',
              ),
            )
            .color,
        theme.destructiveText,
      );
    }

    testWidgets('a destructive row tints at 20% on dark', (
      WidgetTester t,
    ) async {
      await destructiveTint(t, ColorMode.dark, 0.20);
    });

    testWidgets('a destructive row tints at 10% on light', (
      WidgetTester t,
    ) async {
      await destructiveTint(t, ColorMode.light, 0.10);
    });

    testWidgets('a committed row closes the menu', (WidgetTester t) async {
      useFrame(t);
      int signOuts = 0;
      await t.pumpWidget(
        overlayHost(
          DropdownMenu(
            trigger: const _Trigger(width: 111),
            children: accountMenu(onSignOut: () => signOuts++),
          ),
        ),
      );
      await t.tap(find.byType(DropdownMenu));
      await settleOverlay(t);
      await t.pump(MotionDurations.overlayEnter);

      await t.tap(find.text('Sign out'));
      await runOverlay(t);
      expect(signOuts, 1);
      expect(find.text('Sign out'), findsNothing);
    });

    testWidgets('the arrows do NOT wrap', (WidgetTester t) async {
      useFrame(t);
      // *(Probed: `End` then `ArrowDown` stays on "Sign out"; `Home` then
      // `ArrowUp` stays on "Wallet".)* The opposite of `Select`'s menu.
      await t.pumpWidget(
        overlayHost(
          DropdownMenu(
            trigger: const _Trigger(width: 111),
            children: accountMenu(),
          ),
        ),
      );
      await t.tap(find.byType(DropdownMenu));
      await settleOverlay(t);
      await t.pump(MotionDurations.overlayEnter);
      final ThemeTokens theme = ThemeScope.of(
        t.element(find.byType(MenuContent)),
      );

      await t.sendKeyEvent(LogicalKeyboardKey.end);
      await t.pump();
      expect(fillOf(t, 'Sign out'), isNotNull);

      await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await t.pump();
      expect(
        fillOf(t, 'Sign out'),
        isNotNull,
        reason: 'no loop — the last row keeps the highlight',
      );
      expect(fillOf(t, 'Wallet'), isNull);

      await t.sendKeyEvent(LogicalKeyboardKey.home);
      await t.pump();
      expect(fillOf(t, 'Wallet'), theme.accent);
      await t.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      await t.pump();
      expect(fillOf(t, 'Wallet'), theme.accent);
    });

    testWidgets('typeahead moves the highlight', (WidgetTester t) async {
      useFrame(t);
      // *(Probed: pressing `p` in the open account menu focuses
      // "Preferences".)*
      await t.pumpWidget(
        overlayHost(
          DropdownMenu(
            trigger: const _Trigger(width: 111),
            children: accountMenu(),
          ),
        ),
      );
      await t.tap(find.byType(DropdownMenu));
      await settleOverlay(t);
      await t.pump(MotionDurations.overlayEnter);

      await t.sendKeyEvent(LogicalKeyboardKey.keyP);
      await t.pump();
      final ThemeTokens theme = ThemeScope.of(
        t.element(find.byType(MenuContent)),
      );
      expect(fillOf(t, 'Preferences'), theme.accent);
    });

    testWidgets('Escape closes it', (WidgetTester t) async {
      useFrame(t);
      await t.pumpWidget(
        overlayHost(
          DropdownMenu(
            trigger: const _Trigger(width: 111),
            children: accountMenu(),
          ),
        ),
      );
      await t.tap(find.byType(DropdownMenu));
      await settleOverlay(t);
      await t.pump(MotionDurations.overlayEnter);
      await t.sendKeyEvent(LogicalKeyboardKey.escape);
      await runOverlay(t);
      expect(find.text('Wallet'), findsNothing);
    });

    testWidgets('a check row mounts its tick only while checked', (
      WidgetTester t,
    ) async {
      useFrame(t);
      // *(Probed: an unchecked `DropdownMenuCheckboxItem` holds no `<svg>` at
      // all — `ItemIndicator` is conditional.)*
      await t.pumpWidget(
        overlayHost(
          const DropdownMenu(
            width: 208,
            trigger: _Trigger(width: 88),
            children: <MenuChild>[
              MenuLabel('Visible columns'),
              MenuSeparator(),
              MenuCheckboxItem(label: 'Rarity', checked: true),
              MenuCheckboxItem(label: 'Condition', checked: false),
            ],
          ),
        ),
      );
      await t.tap(find.byType(DropdownMenu));
      await settleOverlay(t);
      await t.pump(MotionDurations.overlayEnter);

      Finder tickIn(String label) => find.descendant(
        of: find
            .ancestor(of: find.text(label), matching: find.byType(Stack))
            .first,
        matching: find.byWidgetPredicate(
          (Widget w) => w is Icon && w.glyph == IconGlyph.check,
        ),
      );
      expect(tickIn('Rarity'), findsOneWidget);
      expect(tickIn('Condition'), findsNothing);
    });

    testWidgets('a controlled check row with no handler only closes', (
      WidgetTester t,
    ) async {
      useFrame(t);
      // DRIFT 6 — *(probed: the four states read the same before the click and
      // after reopening)*. `onSelect: null` is the page's own state.
      await t.pumpWidget(
        overlayHost(
          const DropdownMenu(
            width: 208,
            trigger: _Trigger(width: 88),
            children: <MenuChild>[
              MenuCheckboxItem(label: 'Condition', checked: false),
            ],
          ),
        ),
      );
      await t.tap(find.byType(DropdownMenu));
      await settleOverlay(t);
      await t.pump(MotionDurations.overlayEnter);
      await t.tap(find.text('Condition'));
      await runOverlay(t);
      expect(find.text('Condition'), findsNothing);

      await t.tap(find.byType(DropdownMenu));
      await settleOverlay(t);
      await t.pump(MotionDurations.overlayEnter);
      expect(
        find.descendant(
          of: find.byType(MenuContent),
          matching: find.byWidgetPredicate(
            (Widget w) => w is Icon && w.glyph == IconGlyph.check,
          ),
        ),
        findsNothing,
        reason: 'the tick never moved',
      );
    });

    testWidgets('exactly one radio row wears the tick', (WidgetTester t) async {
      useFrame(t);
      await t.pumpWidget(
        overlayHost(
          const DropdownMenu(
            width: 208,
            trigger: _Trigger(width: 60),
            children: <MenuChild>[
              MenuRadioGroup(
                value: 'value',
                children: <MenuRadioItem>[
                  MenuRadioItem(value: 'value', label: 'Highest value'),
                  MenuRadioItem(value: 'rarity', label: 'Rarity'),
                  MenuRadioItem(value: 'recent', label: 'Recently acquired'),
                ],
              ),
            ],
          ),
        ),
      );
      await t.tap(find.byType(DropdownMenu));
      await settleOverlay(t);
      await t.pump(MotionDurations.overlayEnter);
      expect(
        find.descendant(
          of: find.byType(MenuContent),
          matching: find.byWidgetPredicate(
            (Widget w) => w is Icon && w.glyph == IconGlyph.check,
          ),
        ),
        findsOneWidget,
      );
    });

    test('GAP CLOSED 1 is recorded, not silently assumed', () {
      // The reference's menu triggers do not squish (`aria-haspopup="menu"`
      // cancels `active:not-aria-[haspopup]:scale-95`), and neither do the
      // port's: `Button.suppressPressScale` is that attribute.
      expect(DropdownMenu.pressScaleSuppressed, isTrue);
      // Its counterpart on the selects page — the same drift, one file over.
      expect(DatePicker.pressScaleSuppressed, isTrue);
    });

    testWidgets('GAP CLOSED 1, with teeth: a trigger holds unity while held', (
      WidgetTester t,
    ) async {
      useFrame(t);
      await t.pumpWidget(
        overlayHost(
          DropdownMenu(
            width: 240,
            trigger: const _GhostTrigger(),
            children: accountMenu(),
          ),
        ),
      );

      double scaleOf() => t
          .widget<Transform>(
            find
                .descendant(
                  of: find.byType(Button),
                  matching: find.byType(Transform),
                )
                .first,
          )
          .transform
          .storage[0];

      expect(scaleOf(), 1.0);
      final TestGesture press = await t.startGesture(
        t.getCenter(find.byType(Button)),
      );
      await settleOverlay(t);
      expect(
        find.byType(MenuContent),
        findsOneWidget,
        reason: 'the menu opens on pointer-down, before this asserts',
      );
      expect(scaleOf(), 1.0, reason: 'the trigger is exempt from scale-95');
      await press.up();
      await t.pump();
      expect(scaleOf(), 1.0);
    });

    testWidgets('GAP CLOSED 2: the open fill outlives the pointer', (
      WidgetTester t,
    ) async {
      useFrame(t);
      await t.pumpWidget(
        overlayHost(
          DropdownMenu(
            width: 240,
            trigger: const _GhostTrigger(),
            children: accountMenu(),
          ),
        ),
      );

      Surface surface() => t.widget<Surface>(
        find.descendant(
          of: find.byType(Button),
          matching: find.byType(Surface),
        ),
      );

      final ThemeTokens theme = ThemeTokens.dark;
      expect(surface().fill, transparent, reason: 'ghost at rest');

      // Opened by a tap that leaves no pointer resting on the trigger — the
      // one case the port used to drop the fill in.
      await t.tap(find.byType(Button));
      await settleOverlay(t);
      await t.pump(MotionDurations.normal);
      await t.pump(MotionDurations.normal);

      expect(find.byType(MenuContent), findsOneWidget);
      // `aria-expanded:bg-secondary` — the hover fill, held by the open menu.
      expect(surface().fill, theme.secondary);
    });
  });

  /* ── The context menu ──────────────────────────────────────────────────── */

  group('ContextMenu', () {
    /// Right-clicks the card's own centre and hands the point back, so the
    /// placement can be asserted against the thing the pointer actually hit.
    Future<Offset> rightClick(WidgetTester t) async {
      final Offset at = t.getCenter(find.byType(ContextMenu));
      await t.tapAt(at, buttons: kSecondaryButton);
      await settleOverlay(t);
      await t.pump(MotionDurations.overlayEnter);
      return at;
    }

    testWidgets('a LEFT click opens nothing', (WidgetTester t) async {
      useFrame(t);
      // *(Probed: `page.mouse.click` on the card leaves the DOM without a
      // `[data-slot=context-menu-content]`.)*
      await t.pumpWidget(
        overlayHost(
          const ContextMenu(
            width: 224,
            children: stashMenu,
            child: _Trigger(width: 320, height: 160),
          ),
        ),
      );
      await t.tap(find.byType(ContextMenu));
      await settleOverlay(t);
      expect(find.text('Favourite'), findsNothing);
    });

    testWidgets('a right click opens at the pointer + (2, 0)', (
      WidgetTester t,
    ) async {
      useFrame(t);
      // *(Measured: right-clicked at (485, 498.44), content landed at
      // (487, 498) — `side="right" sideOffset={2} align="start"`.)*
      await t.pumpWidget(
        overlayHost(
          const ContextMenu(
            width: 224,
            children: stashMenu,
            child: _Trigger(width: 320, height: 160),
          ),
        ),
      );
      final Offset at = await rightClick(t);

      final Rect content = t.getRect(find.byType(MenuContent).first);
      expect(content.left - at.dx, closeTo(2, 0.01));
      expect(content.top - at.dy, closeTo(0, 0.01));
      expect(content.width, 224);
      expect(content.height, closeTo(171.25, 0.05));
    });

    testWidgets('a submenu opens ~100ms after the pointer arrives, to the '
        'right of its trigger', (WidgetTester t) async {
      useFrame(t);
      // *(Measured: `pointerover` on "Shipping" at t=131.7, the sub-content
      // mounted between 243 and 259.5 — Radix's own `setTimeout(…, 100)`.)*
      // *(Measured: its left edge lands exactly on the trigger's right edge.)*
      await t.pumpWidget(
        overlayHost(
          const ContextMenu(
            width: 224,
            children: stashMenu,
            child: _Trigger(width: 320, height: 160),
          ),
        ),
      );
      await rightClick(t);

      await hover(t, find.text('Shipping'));
      await t.pump(const Duration(milliseconds: 90));
      expect(
        find.text('Add to shipment'),
        findsNothing,
        reason: 'the timer has not fired yet',
      );
      await t.pump(const Duration(milliseconds: 20));
      await settleOverlay(t);
      await t.pump(MotionDurations.overlayEnter);
      expect(find.text('Add to shipment'), findsOneWidget);

      final Rect trigger = t.getRect(
        find
            .ancestor(
              of: find.text('Shipping'),
              matching: find.byType(DecoratedBox),
            )
            .first,
      );
      final Rect sub = t.getRect(find.byType(MenuContent).last);
      expect(sub.left, closeTo(trigger.right, 0.01));
      expect(sub.top, closeTo(trigger.top, 0.01));
      // 8 + 2×34.5625 + 8, plus the 1px border on each side — the one overlay
      // in the corpus that writes `border` rather than `ring-1`.
      expect(sub.height, closeTo(87.125, 0.05));
      expect(sub.width, greaterThanOrEqualTo(Menu.minWidthSub));
    });

    testWidgets('the submenu closes when the pointer reaches a sibling row', (
      WidgetTester t,
    ) async {
      useFrame(t);
      await t.pumpWidget(
        overlayHost(
          const ContextMenu(
            width: 224,
            children: stashMenu,
            child: _Trigger(width: 320, height: 160),
          ),
        ),
      );
      await rightClick(t);

      final TestGesture gesture = await hover(t, find.text('Shipping'));
      await t.pump(const Duration(milliseconds: 120));
      await settleOverlay(t);
      await t.pump(MotionDurations.overlayEnter);
      expect(find.text('Add to shipment'), findsOneWidget);

      await gesture.moveTo(t.getCenter(find.text('Favourite')));
      await t.pump();
      await runOverlay(t);
      expect(find.text('Add to shipment'), findsNothing);
    });

    testWidgets('ArrowRight opens the submenu, ArrowLeft closes one level', (
      WidgetTester t,
    ) async {
      useFrame(t);
      // *(Probed: three `ArrowDown`s reach "Shipping", `ArrowRight` opens it
      // and focuses "Add to shipment", `ArrowLeft` closes it and puts focus
      // back on "Shipping".)*
      await t.pumpWidget(
        overlayHost(
          const ContextMenu(
            width: 224,
            children: stashMenu,
            child: _Trigger(width: 320, height: 160),
          ),
        ),
      );
      await rightClick(t);

      for (int i = 0; i < 3; i++) {
        await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await t.pump();
      }
      final ThemeTokens theme = ThemeScope.of(
        t.element(find.byType(MenuContent).first),
      );
      expect(fillOf(t, 'Shipping'), theme.accent);

      await t.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await settleOverlay(t);
      await t.pump(MotionDurations.overlayEnter);
      expect(find.text('Add to shipment'), findsOneWidget);
      expect(fillOf(t, 'Add to shipment'), theme.accent);

      await t.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await runOverlay(t);
      expect(find.text('Add to shipment'), findsNothing);
      expect(
        find.text('Favourite'),
        findsOneWidget,
        reason: 'only one level closed',
      );
    });
  });

  /* ── The menubar ───────────────────────────────────────────────────────── */

  group('Menubar', () {
    const List<MenubarMenu> admin = <MenubarMenu>[
      MenubarMenu(
        label: 'Packs',
        children: <MenuChild>[
          MenuItem(label: 'New pack', shortcut: '⌘N'),
          MenuItem(label: 'Import card set'),
          MenuSeparator(),
          MenuItem(label: 'Publish queue'),
        ],
      ),
      MenubarMenu(
        label: 'Users',
        children: <MenuChild>[
          MenuItem(label: 'Search users'),
          MenuItem(label: 'Verification queue'),
        ],
      ),
      MenubarMenu(
        label: 'Wallet',
        children: <MenuChild>[
          MenuItem(label: 'Withdrawal approvals'),
          MenuItem(label: 'Transaction audit'),
        ],
      ),
    ];

    testWidgets('DRIFT 1 — the 32px triggers overflow the 32px bar', (
      WidgetTester t,
    ) async {
      useFrame(t);
      // *(Measured: the root's box is y=1531.63 h=32 and the first trigger's
      // is y=1531.63 h=32 — the `p-1` is spent entirely on overflow.)*
      await t.pumpWidget(overlayHost(const Menubar(menus: admin)));
      await t.pump();

      final Rect bar = t.getRect(find.byType(Menubar));
      final Rect trigger = t.getRect(
        find
            .ancestor(
              of: find.text('Packs'),
              matching: find.byType(DecoratedBox),
            )
            .first,
      );
      expect(bar.height, 32);
      expect(trigger.height, 32);
      expect(trigger.top, closeTo(bar.top, 0.01));
      expect(trigger.bottom, closeTo(bar.bottom, 0.01));
      // `border` + `p-1` — the first trigger starts 5px in.
      expect(trigger.left - bar.left, closeTo(5, 0.01));
    });

    testWidgets('the content lands 8 under and 4 left of its trigger', (
      WidgetTester t,
    ) async {
      useFrame(t);
      // *(Measured: dx = −4 (`alignOffset={-4}`), dy = 8.38
      // (`sideOffset={8}`), `min-w-36` → 144 wide, 136.688 tall.)*
      await t.pumpWidget(
        overlayHost(const Menubar(menus: admin), align: Alignment.topLeft),
      );
      await t.tap(find.text('Packs'));
      await settleOverlay(t);
      await t.pump(MotionDurations.overlayEnter);

      final Rect trigger = t.getRect(
        find
            .ancestor(
              of: find.text('Packs'),
              matching: find.byType(DecoratedBox),
            )
            .first,
      );
      final Rect content = t.getRect(find.byType(MenuContent));
      expect(content.top - trigger.bottom, closeTo(8, 0.01));
      expect(content.left - trigger.left, closeTo(-4, 0.01));
      // The exact 144 is the `min-w-36` floor beating a 128.45 intrinsic, and
      // that comparison needs the reference's own face — the page test pins
      // the number under real fonts. Here the floor is what is assertable.
      expect(content.width, greaterThanOrEqualTo(144));
      expect(content.height, closeTo(136.6875, 0.05));
    });

    testWidgets('hovering a sibling while open switches instantly', (
      WidgetTester t,
    ) async {
      useFrame(t);
      // *(Measured: `pointerover` at t=167.3, both `data-state`s flipped by
      // t=168.5 — no intent delay.)*
      await t.pumpWidget(overlayHost(const Menubar(menus: admin)));
      await t.tap(find.text('Packs'));
      await settleOverlay(t);
      await t.pump(MotionDurations.overlayEnter);
      expect(find.text('New pack'), findsOneWidget);

      await hover(t, find.text('Users'));
      await settleOverlay(t);
      expect(find.text('New pack'), findsNothing);
      expect(find.text('Search users'), findsOneWidget);
    });

    testWidgets('DRIFT 2 — the content has no exit animation', (
      WidgetTester t,
    ) async {
      useFrame(t);
      // Its class list stops at `data-open:zoom-in-95`; the `animate-out` trio
      // its three siblings carry is absent, so the popup is gone on the frame
      // the state flips rather than 320ms later.
      await t.pumpWidget(overlayHost(const Menubar(menus: admin)));
      await t.tap(find.text('Packs'));
      await settleOverlay(t);
      await t.pump(MotionDurations.overlayEnter);

      await t.sendKeyEvent(LogicalKeyboardKey.escape);
      await t.pump();
      await t.pump();
      expect(
        find.text('New pack'),
        findsNothing,
        reason: 'no 320ms exit to wait out',
      );
    });

    testWidgets('ArrowRight walks to the next menu', (WidgetTester t) async {
      useFrame(t);
      // *(Probed: from "Users" open, `ArrowRight` opened "Wallet".)*
      await t.pumpWidget(overlayHost(const Menubar(menus: admin)));
      await t.tap(find.text('Packs'));
      await settleOverlay(t);
      await t.pump(MotionDurations.overlayEnter);

      await t.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await settleOverlay(t);
      await t.pump(MotionDurations.overlayEnter);
      expect(find.text('Search users'), findsOneWidget);

      await t.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await settleOverlay(t);
      await t.pump(MotionDurations.overlayEnter);
      expect(find.text('New pack'), findsOneWidget);
    });

    testWidgets('a hovered or open trigger takes `--muted`, and it snaps', (
      WidgetTester t,
    ) async {
      useFrame(t);
      await t.pumpWidget(overlayHost(const Menubar(menus: admin)));
      await t.pump();
      final ThemeTokens theme = ThemeScope.of(t.element(find.byType(Menubar)));

      Color? triggerFill(String label) {
        final Finder box = find
            .ancestor(of: find.text(label), matching: find.byType(DecoratedBox))
            .first;
        return (t.widget<DecoratedBox>(box).decoration as BoxDecoration).color;
      }

      expect(triggerFill('Packs'), isNull);
      await hover(t, find.text('Packs'));
      expect(triggerFill('Packs'), theme.muted);
    });
  });

  /* ── The Popover extensions ──────────────────────────────────────────── */

  group('Popover — what the menus added', () {
    test('the corner origin is Radix\'s, the anchor origin is base-ui\'s', () {
      const Rect anchor = Rect.fromLTWH(325, 539.14, 111.40625, 40);
      const Size content = Size(240, 236.25);
      const Size viewport = Size(1440, 900);

      // *(Measured: `--radix-dropdown-menu-content-transform-origin: 0% 0px`
      // — the content's own top-left, whatever the anchor's width.)*
      final PopoverPlacement corner = popoverPlacement(
        anchor: anchor,
        content: content,
        viewport: viewport,
        side: PopoverSide.bottom,
        align: PopoverAlign.start,
        sideOffset: 4,
        origin: PopoverAnchorMode.corner,
      );
      expect(corner.origin, const Alignment(-1, -1));

      // base-ui's, unchanged: it points at the anchor's centre and pays for
      // the `sideOffset`. This is the default, so no shipped consumer moves.
      final PopoverPlacement anchored = popoverPlacement(
        anchor: anchor,
        content: content,
        viewport: viewport,
        side: PopoverSide.bottom,
        align: PopoverAlign.start,
        sideOffset: 4,
      );
      expect(anchored.origin.x, isNot(closeTo(-1, 0.01)));
      expect(anchored.origin.y, lessThan(-1));
    });

    test('the corner origin follows the side, not the anchor', () {
      // *(Measured: a `ContextMenuContent` at `side=right align=start`
      // computes `0px 0%`.)*
      const Rect point = Rect.fromLTWH(485, 498, 0, 0);
      final PopoverPlacement right = popoverPlacement(
        anchor: point,
        content: const Size(224, 171.25),
        viewport: const Size(1440, 900),
        side: PopoverSide.right,
        align: PopoverAlign.start,
        sideOffset: 2,
        origin: PopoverAnchorMode.corner,
      );
      expect(right.side, PopoverSide.right);
      expect(right.origin, const Alignment(-1, -1));
      expect(right.offset.dx, closeTo(487, 0.01));
      expect(right.offset.dy, closeTo(498, 0.01));
    });

    testWidgets('a submenu lays no barrier of its own', (WidgetTester t) async {
      useFrame(t);
      // A barrier would sit over the parent's rows, so the pointer moving from
      // an open submenu back to a sibling row would never reach it — which is
      // the mechanism the "closes on sibling hover" test depends on.
      await t.pumpWidget(
        overlayHost(
          const ContextMenu(
            width: 224,
            children: stashMenu,
            child: _Trigger(width: 320, height: 160),
          ),
        ),
      );
      final TestGesture gesture = await t.createGesture(
        kind: PointerDeviceKind.mouse,
        buttons: kSecondaryButton,
      );
      await gesture.downWithCustomEvent(
        const Offset(400, 300),
        const PointerDownEvent(
          position: Offset(400, 300),
          buttons: kSecondaryButton,
        ),
      );
      await gesture.up();
      await settleOverlay(t);
      await t.pump(MotionDurations.overlayEnter);

      final int barriersBefore = t
          .widgetList<Popover>(find.byType(Popover))
          .where((Popover p) => p.barrier != PopoverBarrier.none)
          .length;
      expect(
        barriersBefore,
        1,
        reason: 'the root menu lays one; the sub-trigger\'s lays none',
      );
    });

    testWidgets('the slide runs on the side the class list names', (
      WidgetTester t,
    ) async {
      useFrame(t);
      // `popover.tsx` writes one `slide-in-from-*`; the menus write four. The
      // default is still the one, so the combobox and the date picker do not
      // move.
      const Popover popover = Popover(
        open: false,
        anchor: SizedBox.shrink(),
        content: _noContent,
      );
      expect(popover.slideSides, <PopoverSide>{PopoverSide.bottom});
      expect(popover.origin, PopoverAnchorMode.anchor);
      expect(popover.animateOut, isTrue);
      expect(popover.barrier, PopoverBarrier.modal);
      expect(MenuMotion.slideSides.length, 4);
      expect(MenuMotion.duration, MotionDurations.overlayEnter);
    });
  });
}

Widget _noContent(BuildContext context, PopoverAnchorMetrics metrics) =>
    const SizedBox.shrink();

/// A stand-in for the page's real trigger.
///
/// It **paints**, because `MenuPointerDown` is `asChild`: it defers hit
/// testing to the control it wraps, the way Radix's `Trigger asChild` puts its
/// handlers on a real `<button>` rather than on a wrapper of its own. A bare
/// [SizedBox] is not hit-testable and would be a harness artefact, not a
/// behaviour.
/// The page's account trigger in miniature: a `ghost` Button carrying the two
/// attributes `DropdownMenuTrigger asChild` merges into it.
///
/// `aria-haspopup` is a constant of the arrangement; `aria-expanded` belongs to
/// the menu, so it is read from the scope the trigger publishes it on.
class _GhostTrigger extends StatelessWidget {
  const _GhostTrigger();

  @override
  Widget build(BuildContext context) => Button(
    variant: ButtonVariant.ghost,
    suppressPressScale: true,
    expanded: MenuTriggerScope.openOf(context),
    onPressed: () {},
    child: StyledText('voidwing', TextStyles.small),
  );
}

class _Trigger extends StatelessWidget {
  const _Trigger({required this.width, this.height = 40});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) =>
      Container(width: width, height: height, color: const Color(0x00000000));
}
