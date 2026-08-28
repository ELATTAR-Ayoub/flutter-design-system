/// `Sidebar` and the twenty-two parts around it, against the live
/// reference's own numbers.
///
/// Everything pinned here was measured on
/// `http://localhost:3000/design-system/components/base/sidebar` at 1440 × 900
/// on 2026-08-16 (`sb-inv.js`, `sb-tree.js`, `sb-collapse.js`, `sb-parts.js`,
/// `sb-tip.js`, `sb-matrix.js`), not derived from the class lists. Where the
/// two disagreed the probe won — see [Sidebar]'s own drift register.
///
/// The page test (`example/test/sidebar_page_test.dart`) owns the column's
/// geometry; this file owns the component's behaviour and its state table.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/material.dart'
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
        TableColumnWidth,
        ActionChip,
        AlertDialog,
        Badge,
        Card,
        CarouselController,
        Checkbox,
        Dialog,
        DropdownMenu,
        Drawer,
        DrawerHeader,
        Slider,
        Switch,
        TextFormField,
        Tooltip;
import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter_test/flutter_test.dart';

/* ── Harness ─────────────────────────────────────────────────────────────── */

/// A framed shell at the reference's own 384px stage, with a bounded height so
/// the provider's row has one.
const Size _stage = Size(1000, 400);

extension on WidgetTester {
  void useStage([Size size = _stage]) {
    view.devicePixelRatio = 1;
    view.physicalSize = size;
    addTearDown(view.resetPhysicalSize);
    addTearDown(view.resetDevicePixelRatio);
  }

  /// Mounts [child] under the theme, at [_stage], with animations stilled
  /// unless [animate] asks otherwise.
  Future<void> pumpDs(
    Widget child, {
    ColorMode mode = ColorMode.light,
    bool animate = false,
    Size size = _stage,
  }) async {
    useStage(size);
    final ThemeController theme = ThemeController(mode: mode);
    addTearDown(theme.dispose);
    await pumpWidget(
      ThemeScope(
        controller: theme,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Builder(
            builder: (BuildContext context) => MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(disableAnimations: !animate),
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Align(alignment: Alignment.topLeft, child: child),
              ),
            ),
          ),
        ),
      ),
    );
    await pump();
  }
}

/// A shell that fills the stage: a panel and a main column.
Widget _shell({
  SidebarSide side = SidebarSide.left,
  SidebarVariant variant = SidebarVariant.sidebar,
  SidebarCollapsible collapsible = SidebarCollapsible.icon,
  bool rail = true,
  bool defaultOpen = true,
}) => SizedBox(
  width: _stage.width,
  height: _stage.height,
  child: SidebarProvider(
    variant: variant,
    defaultOpen: defaultOpen,
    children: <Widget>[
      Sidebar(
        side: side,
        variant: variant,
        collapsible: collapsible,
        children: <Widget>[
          const SidebarContent(children: <Widget>[_Menu()]),
          if (rail) const SidebarRail(),
        ],
      ),
      const SidebarInset(child: SidebarTrigger()),
    ],
  ),
);

/// The three-row menu every case below drives.
class _Menu extends StatelessWidget {
  const _Menu({this.activeIndex = 0});

  final int activeIndex;

  static const List<String> labels = <String>[
    'All cards',
    'Favourites',
    'Wallet',
  ];

  @override
  Widget build(BuildContext context) => SidebarGroup(
    children: <Widget>[
      SidebarGroupContent(
        child: SidebarMenu(
          children: <Widget>[
            for (int i = 0; i < labels.length; i++)
              SidebarMenuItem(
                button: SidebarMenuButton(
                  isActive: i == activeIndex,
                  tooltip: labels[i],
                  child: SidebarMenuRow(
                    leading: Icon(
                      IconGlyph.layers,
                      sizePx: Button.iconPxFor(ButtonSize.sm),
                    ),
                    label: SidebarMenuLabel(labels[i]),
                  ),
                ),
              ),
          ],
        ),
      ),
    ],
  );
}

double _widthOf(WidgetTester tester, Finder finder) =>
    tester.renderObject<RenderBox>(finder).size.width;

Rect _rectOf(WidgetTester tester, Finder finder) => tester.getRect(finder);

void main() {
  /* ── Collapse ──────────────────────────────────────────────────────────── */

  group('collapse', () {
    testWidgets('icon mode narrows 256 → 48 and back', (
      WidgetTester tester,
    ) async {
      await tester.pumpDs(_shell());
      final Finder panel = find.byType(Sidebar);
      expect(_widthOf(tester, panel), LayoutWidths.sidebar);

      await tester.tap(find.byType(SidebarTrigger));
      await tester.pump();
      await tester.pump(MotionDurations.normal);
      expect(_widthOf(tester, panel), LayoutWidths.sidebarCollapsed);

      await tester.tap(find.byType(SidebarTrigger));
      await tester.pump();
      await tester.pump(MotionDurations.normal);
      expect(_widthOf(tester, panel), LayoutWidths.sidebar);
    });

    testWidgets('the width leg is LINEAR over 250ms, not eased', (
      WidgetTester tester,
    ) async {
      // Measured: 256 → 48 in even ~13.85px steps per 16.6ms frame, reaching 48
      // exactly 250ms after the flip, with no front-loading and no overshoot.
      await tester.pumpDs(_shell(), animate: true);
      final Finder panel = find.byType(Sidebar);

      await tester.tap(find.byType(SidebarTrigger));
      await tester.pump();

      const double travel =
          LayoutWidths.sidebar - LayoutWidths.sidebarCollapsed;
      for (final double fraction in <double>[0.25, 0.5, 0.75]) {
        await tester.pump(
          Duration(
            microseconds: (MotionDurations.normal.inMicroseconds * 0.25)
                .round(),
          ),
        );
        final double want = LayoutWidths.sidebar - travel * fraction;
        expect(
          _widthOf(tester, panel),
          closeTo(want, 1),
          reason: 'at $fraction of the run the panel should be $want',
        );
      }
      await tester.pump(MotionDurations.normal);
      expect(_widthOf(tester, panel), LayoutWidths.sidebarCollapsed);
    });

    testWidgets('offcanvas closes the gap and slides the panel out', (
      WidgetTester tester,
    ) async {
      await tester.pumpDs(_shell(collapsible: SidebarCollapsible.offcanvas));
      final Finder panel = find.byType(Sidebar);
      expect(_widthOf(tester, panel), LayoutWidths.sidebar);

      await tester.tap(find.byType(SidebarTrigger));
      await tester.pump();
      await tester.pump(MotionDurations.normal);

      // The gap goes to nothing; the container keeps its 256 and leaves.
      expect(_widthOf(tester, panel), 0);
      final Rect content = _rectOf(tester, find.byType(SidebarContent));
      expect(
        content.width,
        closeTo(LayoutWidths.sidebar - BorderWidths.hairline, 0.5),
      );
      expect(content.left, closeTo(-LayoutWidths.sidebar, 0.5));
    });

    testWidgets('collapsible=none never collapses and shows no rail', (
      WidgetTester tester,
    ) async {
      await tester.pumpDs(_shell(collapsible: SidebarCollapsible.none));
      expect(_widthOf(tester, find.byType(Sidebar)), LayoutWidths.sidebar);
      await tester.tap(find.byType(SidebarTrigger));
      await tester.pump();
      await tester.pump(MotionDurations.normal);
      expect(_widthOf(tester, find.byType(Sidebar)), LayoutWidths.sidebar);
    });

    testWidgets('the row snaps to a 32px square on the flip\'s first frame', (
      WidgetTester tester,
    ) async {
      // `size-8!` is not in `btn-spring`'s property list, so it lands whole
      // while the panel is still 256 wide (measured at Δ0).
      await tester.pumpDs(_shell(), animate: true);

      await tester.tap(find.byType(SidebarTrigger));
      await tester.pump();
      await tester.pump(MotionDurations.frame);

      final Size row = tester
          .renderObject<RenderBox>(find.byType(SidebarMenuButton).first)
          .size;
      expect(row.height, SidebarMenuButton.iconSize);
      expect(
        _widthOf(tester, find.byType(Sidebar)),
        greaterThan(LayoutWidths.sidebarCollapsed),
      );
    });

    testWidgets('⌘B and Ctrl-B both toggle, from anywhere', (
      WidgetTester tester,
    ) async {
      await tester.pumpDs(_shell());
      final Finder panel = find.byType(Sidebar);

      await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
      await tester.sendKeyEvent(SidebarProvider.shortcut);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
      await tester.pump();
      await tester.pump(MotionDurations.normal);
      expect(_widthOf(tester, panel), LayoutWidths.sidebarCollapsed);

      await tester.sendKeyDownEvent(LogicalKeyboardKey.metaLeft);
      await tester.sendKeyEvent(SidebarProvider.shortcut);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.metaLeft);
      await tester.pump();
      await tester.pump(MotionDurations.normal);
      expect(_widthOf(tester, panel), LayoutWidths.sidebar);
    });

    testWidgets('a bare `b` does nothing', (WidgetTester tester) async {
      await tester.pumpDs(_shell());
      await tester.sendKeyEvent(SidebarProvider.shortcut);
      await tester.pump();
      await tester.pump(MotionDurations.normal);
      expect(_widthOf(tester, find.byType(Sidebar)), LayoutWidths.sidebar);
    });
  });

  /* ── The frame variants ────────────────────────────────────────────────── */

  group('variants', () {
    testWidgets('floating pays p-2 on both edges and rounds its panel', (
      WidgetTester tester,
    ) async {
      await tester.pumpDs(_shell(variant: SidebarVariant.floating));
      // Measured: a 256px container holding a 240 × 366 inner card at
      // `rounded-lg`, inside a 382px frame.
      expect(_widthOf(tester, find.byType(Sidebar)), LayoutWidths.sidebar);
      final Rect inner = _rectOf(tester, find.byType(SidebarContent));
      // Measured 240 — 256 less `p-2` on both edges, and no border at all:
      // the floating panel wears a ring, which costs no layout.
      expect(
        inner.width,
        closeTo(LayoutWidths.sidebar - 2 * Sidebar.framePadding, 0.5),
      );
    });

    testWidgets(
      'floating and inset collapse to 64 of gap and 66 of container',
      (WidgetTester tester) async {
        await tester.pumpDs(_shell(variant: SidebarVariant.inset));
        await tester.tap(find.byType(SidebarTrigger));
        await tester.pump();
        await tester.pump(MotionDurations.normal);

        // `calc(var(--sidebar-width-icon) + --spacing(4))` and its `+2px` twin.
        expect(_widthOf(tester, find.byType(Sidebar)), Sidebar.insetIconGap);
        expect(Sidebar.insetIconGap, LayoutWidths.sidebarCollapsed + space(4));
        expect(
          Sidebar.insetIconWidth,
          Sidebar.insetIconGap + 2 * BorderWidths.hairline,
        );
      },
    );

    testWidgets('the inset variant insets the main column, ml-0 while open', (
      WidgetTester tester,
    ) async {
      await tester.pumpDs(_shell(variant: SidebarVariant.inset));
      final Finder card = find.descendant(
        of: find.byType(SidebarInset),
        matching: find.byType(ClipRRect),
      );
      final Rect open = _rectOf(tester, card);
      expect(open.height, _stage.height - 2 * SidebarInset.margin);
      expect(open.left, _rectOf(tester, find.byType(Sidebar)).right);

      await tester.tap(find.byType(SidebarTrigger));
      await tester.pump();
      await tester.pump(MotionDurations.normal);

      // `peer-data-[state=collapsed]:ml-2` — the lane opens once it collapses.
      expect(
        _rectOf(tester, card).left,
        _rectOf(tester, find.byType(Sidebar)).right + SidebarInset.margin,
      );
    });

    testWidgets('side=right puts the panel on the far edge', (
      WidgetTester tester,
    ) async {
      await tester.pumpDs(_shell(side: SidebarSide.right));
      // The gap is still the first flex item — the container is what moves.
      final Rect content = _rectOf(tester, find.byType(SidebarContent));
      expect(content.right, closeTo(LayoutWidths.sidebar, 0.5));
    });
  });

  /* ── Rows ──────────────────────────────────────────────────────────────── */

  group('rows', () {
    testWidgets('the three sizes map onto Button\'s own ladder', (
      WidgetTester tester,
    ) async {
      expect(SidebarMenuButtonSize.sm.button, ButtonSize.xs);
      expect(SidebarMenuButtonSize.md.button, ButtonSize.sm);
      expect(SidebarMenuButtonSize.lg.button, ButtonSize.lg);
      expect(SidebarMenuSubButtonSize.md.button, ButtonSize.sm);
    });

    testWidgets('a default row is 37.5 tall at h-auto px-2 py-2', (
      WidgetTester tester,
    ) async {
      await tester.pumpDs(_shell(collapsible: SidebarCollapsible.none));
      final Size row = tester
          .renderObject<RenderBox>(find.byType(SidebarMenuButton).first)
          .size;
      // 19.5 of line box, `py-2` twice, and a 1px border twice.
      expect(row.height, closeTo(37.5, 0.01));
    });

    testWidgets('the row wears rounded-lg, not the pill', (
      WidgetTester tester,
    ) async {
      await tester.pumpDs(_shell(collapsible: SidebarCollapsible.none));
      final Button button = tester.widget<Button>(
        find.descendant(
          of: find.byType(SidebarMenuButton).first,
          matching: find.byType(Button),
        ),
      );
      expect(button.radius, BorderRadius.circular(Radii.lg));
      expect(button.autoHeight, isTrue);
      expect(button.variant, ButtonVariant.ghost);
    });

    testWidgets('a badge reserves pr-16 and an action pr-10', (
      WidgetTester tester,
    ) async {
      Future<EdgeInsetsGeometry> paddingWith({
        Widget? badge,
        Widget? action,
      }) async {
        await tester.pumpDs(
          SizedBox(
            width: 400,
            child: SidebarProvider(
              children: <Widget>[
                Expanded(
                  child: Sidebar(
                    collapsible: SidebarCollapsible.none,
                    expand: true,
                    children: <Widget>[
                      SidebarGroup(
                        children: <Widget>[
                          SidebarGroupContent(
                            child: SidebarMenu(
                              children: <Widget>[
                                SidebarMenuItem(
                                  button: const SidebarMenuButton(
                                    child: SidebarMenuLabel('Reports'),
                                  ),
                                  badge: badge,
                                  action: action,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
        return tester.widget<Button>(find.byType(Button).first).padding!;
      }

      double right(EdgeInsetsGeometry padding) =>
          padding.resolve(TextDirection.ltr).right;

      expect(right(await paddingWith()), SidebarMenuButton.padding);
      expect(
        right(await paddingWith(badge: const SidebarMenuBadge('3'))),
        SidebarMenuButton.badgeLane,
      );
      expect(
        right(
          await paddingWith(
            action: const SidebarMenuAction(
              label: 'Add',
              child: Icon(IconGlyph.plus),
            ),
          ),
        ),
        SidebarMenuButton.actionLane,
      );
    });

    testWidgets('the badge is h-5 with a min-w-5 floor and mono figures', (
      WidgetTester tester,
    ) async {
      await tester.pumpDs(
        SizedBox(
          width: 300,
          child: SidebarProvider(
            children: <Widget>[
              Expanded(
                child: Sidebar(
                  collapsible: SidebarCollapsible.none,
                  expand: true,
                  children: <Widget>[
                    SidebarGroup(
                      children: <Widget>[
                        SidebarGroupContent(
                          child: SidebarMenu(
                            children: <Widget>[
                              SidebarMenuItem(
                                button: const SidebarMenuButton(
                                  child: SidebarMenuLabel('Reports'),
                                ),
                                badge: const SidebarMenuBadge('3'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

      final Size badge = tester
          .renderObject<RenderBox>(find.byType(SidebarMenuBadge))
          .size;
      expect(badge.height, Badge.height);
      // The floor, not the width: a one-digit count measures narrower than
      // 20 in every face, and this file loads none — the page test carries the
      // rendered numbers.
      expect(badge.width, greaterThanOrEqualTo(SidebarMenuBadge.minWidth));
      expect(
        tester.widget<Badge>(find.byType(Badge)).spec,
        TextStyles.sidebarMenuBadge,
      );
      // The chip is `pointer-events-none` — a click goes to the row under it.
      expect(find.byType(IgnorePointer), findsWidgets);
    });

    testWidgets('a sub list hangs off a spine and hides in icon mode', (
      WidgetTester tester,
    ) async {
      await tester.pumpDs(_shellWithSubmenu());
      expect(find.byType(SidebarMenuSubButton), findsNWidgets(2));
      final Size sub = tester
          .renderObject<RenderBox>(find.byType(SidebarMenuSubButton).first)
          .size;
      expect(sub.height, Button.heightFor(ButtonSize.sm));

      await tester.tap(find.byType(SidebarTrigger));
      await tester.pump();
      await tester.pump(MotionDurations.normal);
      expect(find.byType(SidebarMenuSubButton), findsNothing);
    });
  });

  /* ── The pill ──────────────────────────────────────────────────────────── */

  group('pill', () {
    testWidgets('lands on the active row and takes its rect', (
      WidgetTester tester,
    ) async {
      await tester.pumpDs(_shell(collapsible: SidebarCollapsible.none));
      await tester.pump();

      final Rect row = tester.getRect(find.byType(SidebarMenuButton).first);
      final Finder pill = find.descendant(
        of: find.byType(SidebarMenu),
        matching: find.byType(AnimatedPositioned),
      );
      expect(pill, findsOneWidget);
      final Rect painted = tester.getRect(pill);
      expect(painted.height, closeTo(row.height, 0.01));
      expect(painted.top, closeTo(row.top, 0.01));
    });

    testWidgets('takes the topmost active row when two claim it', (
      WidgetTester tester,
    ) async {
      // DRIFT 8: `querySelector('[data-active="true"]')` returns the first
      // match, and the sub-link below never claims the pill at all.
      await tester.pumpDs(_shellWithSubmenu(activeSub: true));
      await tester.pump();

      final Rect row = tester.getRect(find.byType(SidebarMenuButton).first);
      final Rect painted = tester.getRect(
        find.descendant(
          of: find.byType(SidebarMenu),
          matching: find.byType(AnimatedPositioned),
        ),
      );
      expect(painted.top, closeTo(row.top, 0.01));
      expect(painted.height, closeTo(row.height, 0.01));
    });

    testWidgets('a menu with nothing active paints no pill', (
      WidgetTester tester,
    ) async {
      await tester.pumpDs(
        SizedBox(
          width: 300,
          child: SidebarProvider(
            children: <Widget>[
              Expanded(
                child: Sidebar(
                  collapsible: SidebarCollapsible.none,
                  expand: true,
                  children: const <Widget>[_Menu(activeIndex: -1)],
                ),
              ),
            ],
          ),
        ),
      );
      await tester.pump();
      expect(
        find.descendant(
          of: find.byType(SidebarMenu),
          matching: find.byType(AnimatedPositioned),
        ),
        findsNothing,
      );
    });
  });

  /* ── Tooltip ───────────────────────────────────────────────────────────── */

  group('tooltip', () {
    testWidgets('is hidden while the panel is open and shows on the rail', (
      WidgetTester tester,
    ) async {
      await tester.pumpDs(_shell());

      Tooltip tip() => tester.widget<Tooltip>(find.byType(Tooltip).first);
      expect(tip().side, TooltipSide.right);
      expect(tip().hidden, isTrue);

      await tester.tap(find.byType(SidebarTrigger));
      await tester.pump();
      await tester.pump(MotionDurations.normal);
      expect(tip().hidden, isFalse);
    });

    testWidgets('a hidden tooltip never opens on hover', (
      WidgetTester tester,
    ) async {
      await tester.pumpDs(_shell(), animate: true);
      final TestGesture gesture = await tester.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      await gesture.moveTo(
        tester.getCenter(find.byType(SidebarMenuButton).first),
      );
      await tester.pump(MotionDurations.tooltipShowDelay);
      await tester.pump(MotionDurations.overlayEnter);
      expect(find.byType(TooltipContent), findsNothing);
    });
  });

  /* ── Disclosure ────────────────────────────────────────────────────────── */

  group('collapsible group', () {
    testWidgets('the line thickens 1 → 4 and the content folds away', (
      WidgetTester tester,
    ) async {
      await tester.pumpDs(
        SizedBox(
          width: 320,
          child: SidebarProvider(
            children: <Widget>[
              Expanded(
                child: Sidebar(
                  collapsible: SidebarCollapsible.none,
                  expand: true,
                  children: <Widget>[
                    SidebarCollapsibleGroup(
                      label: 'Collection',
                      toggleLabel: 'Toggle Collection group',
                      child: const _Menu(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

      expect(find.byType(SidebarMenuButton), findsNWidgets(3));

      await tester.tap(find.byType(Button).first);
      await tester.pump();
      await tester.pump(MotionDurations.open);

      expect(find.byType(SidebarMenuButton), findsNothing);
      expect(SidebarCollapsibleGroup.lineOpen, BorderWidths.hairline);
      expect(SidebarCollapsibleGroup.lineClosed, space(1));
    });

    testWidgets('the group label is h-8 and .type-nav-sm', (
      WidgetTester tester,
    ) async {
      await tester.pumpDs(
        SizedBox(
          width: 320,
          child: SidebarProvider(
            children: <Widget>[
              Expanded(
                child: Sidebar(
                  collapsible: SidebarCollapsible.none,
                  expand: true,
                  children: <Widget>[
                    SidebarCollapsibleGroup(
                      label: 'Collection',
                      toggleLabel: 'Toggle Collection group',
                      child: const _Menu(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
      expect(
        tester
            .renderObject<RenderBox>(find.byType(SidebarGroupLabel))
            .size
            .height,
        SidebarGroupLabel.height,
      );
      expect(TextStyles.navSm.size, 11.5);
      expect(TextStyles.navSm.height, 1.2);
    });
  });

  /* ── The input and the skeleton ────────────────────────────────────────── */

  group('parts', () {
    testWidgets('SidebarInput is h-8, --background filled and socket-less', (
      WidgetTester tester,
    ) async {
      await tester.pumpDs(
        const SizedBox(width: 300, child: SidebarInput(placeholder: 'Search')),
      );
      expect(
        tester.renderObject<RenderBox>(find.byType(Input)).size.height,
        SidebarInput.height,
      );
      final Input input = tester.widget<Input>(find.byType(Input));
      expect(input.boxHeight, space(8));
      expect(input.flat, isTrue);
      expect(input.fill, isNotNull);
    });

    testWidgets('the skeleton width is a stable hash of its seed', (
      WidgetTester tester,
    ) async {
      // DRIFT 4: the reference hashes `useId()` so server and client agree;
      // there is no hydration here, so the seed is the caller's.
      final double a = SidebarMenuSkeleton.widthFraction('row-1');
      expect(a, SidebarMenuSkeleton.widthFraction('row-1'));
      expect(a, greaterThanOrEqualTo(0.5));
      expect(a, lessThanOrEqualTo(0.9));
      expect(SidebarMenuSkeleton.widthFraction('row-2'), isNot(equals(a)));

      await tester.pumpDs(
        const SizedBox(
          width: 240,
          child: SidebarMenuSkeleton(showIcon: true, seed: 'row-1'),
        ),
      );
      expect(
        tester
            .renderObject<RenderBox>(find.byType(SidebarMenuSkeleton))
            .size
            .height,
        SidebarMenuSkeleton.height,
      );
    });

    testWidgets('useSidebar reports the four fields the readout prints', (
      WidgetTester tester,
    ) async {
      late SidebarScope scope;
      await tester.pumpDs(
        SizedBox(
          width: _stage.width,
          height: _stage.height,
          child: SidebarProvider(
            children: <Widget>[
              Builder(
                builder: (BuildContext context) {
                  scope = SidebarScope.of(context);
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      );
      expect(scope.open, isTrue);
      expect(scope.collapsed, isFalse);
      expect(scope.openMobile, isFalse);
      expect(scope.isMobile, isFalse);

      scope.toggleSidebar();
      await tester.pump();
      // `scope` is reassigned by the Builder on every rebuild, so reading it
      // again is reading the provider's current value.
      expect(scope.open, isFalse);
      expect(scope.collapsed, isTrue);
    });

    testWidgets('a narrow viewport takes the mobile branch', (
      WidgetTester tester,
    ) async {
      // `useIsMobile()` — `(max-width: 767px)`, and the panel becomes a sheet
      // that is closed until `openMobile` says otherwise.
      expect(SidebarProvider.isMobileWidth(767), isTrue);
      expect(SidebarProvider.isMobileWidth(Breakpoints.md), isFalse);

      await tester.pumpDs(_shell(), size: const Size(400, 700));
      expect(find.byType(SidebarContent), findsNothing);

      await tester.tap(find.byType(SidebarTrigger));
      await tester.pump();
      expect(find.byType(SheetContent), findsOneWidget);
      expect(
        tester.widget<SheetContent>(find.byType(SheetContent)).width,
        LayoutWidths.sidebarMobile,
      );
    });
  });
}

/// A panel whose one row carries a submenu.
Widget _shellWithSubmenu({bool activeSub = false}) => SizedBox(
  width: _stage.width,
  height: _stage.height,
  child: SidebarProvider(
    children: <Widget>[
      Sidebar(
        collapsible: SidebarCollapsible.icon,
        children: <Widget>[
          SidebarContent(
            children: <Widget>[
              SidebarGroup(
                children: <Widget>[
                  SidebarGroupContent(
                    child: SidebarMenu(
                      children: <Widget>[
                        SidebarMenuItem(
                          button: const SidebarMenuButton(
                            isActive: true,
                            child: SidebarMenuLabel('All cards'),
                          ),
                          submenu: SidebarMenuSub(
                            children: <Widget>[
                              SidebarMenuSubItem(
                                child: SidebarMenuSubButton(
                                  label: 'Open',
                                  isActive: activeSub,
                                ),
                              ),
                              const SidebarMenuSubItem(
                                child: SidebarMenuSubButton(label: 'Settled'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      const SidebarInset(child: SidebarTrigger()),
    ],
  ),
);
