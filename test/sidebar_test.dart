/// `ElSidebar` and the twenty-two parts around it, against the live
/// reference's own numbers.
///
/// Everything pinned here was measured on
/// `http://localhost:3000/design-system/components/base/sidebar` at 1440 × 900
/// on 2026-08-16 (`sb-inv.js`, `sb-tree.js`, `sb-collapse.js`, `sb-parts.js`,
/// `sb-tip.js`, `sb-matrix.js`), not derived from the class lists. Where the
/// two disagreed the probe won — see [ElSidebar]'s own drift register.
///
/// The page test (`example/test/sidebar_page_test.dart`) owns the column's
/// geometry; this file owns the component's behaviour and its state table.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/material.dart';
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
    ElThemeMode mode = ElThemeMode.light,
    bool animate = false,
    Size size = _stage,
  }) async {
    useStage(size);
    final ElThemeController theme = ElThemeController(mode: mode);
    addTearDown(theme.dispose);
    await pumpWidget(
      ElTheme(
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
  ElSidebarSide side = ElSidebarSide.left,
  ElSidebarVariant variant = ElSidebarVariant.sidebar,
  ElSidebarCollapsible collapsible = ElSidebarCollapsible.icon,
  bool rail = true,
  bool defaultOpen = true,
}) => SizedBox(
  width: _stage.width,
  height: _stage.height,
  child: ElSidebarProvider(
    variant: variant,
    defaultOpen: defaultOpen,
    children: <Widget>[
      ElSidebar(
        side: side,
        variant: variant,
        collapsible: collapsible,
        children: <Widget>[
          const ElSidebarContent(children: <Widget>[_Menu()]),
          if (rail) const ElSidebarRail(),
        ],
      ),
      const ElSidebarInset(child: ElSidebarTrigger()),
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
  Widget build(BuildContext context) => ElSidebarGroup(
    children: <Widget>[
      ElSidebarGroupContent(
        child: ElSidebarMenu(
          children: <Widget>[
            for (int i = 0; i < labels.length; i++)
              ElSidebarMenuItem(
                button: ElSidebarMenuButton(
                  isActive: i == activeIndex,
                  tooltip: labels[i],
                  child: ElSidebarMenuRow(
                    leading: ElIcon(
                      ElIconGlyph.layers,
                      sizePx: ElButton.iconPxFor(ElButtonSize.sm),
                    ),
                    label: ElSidebarMenuLabel(labels[i]),
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
      final Finder panel = find.byType(ElSidebar);
      expect(_widthOf(tester, panel), ElWidths.sidebar);

      await tester.tap(find.byType(ElSidebarTrigger));
      await tester.pump();
      await tester.pump(ElDurations.base);
      expect(_widthOf(tester, panel), ElWidths.sidebarIcon);

      await tester.tap(find.byType(ElSidebarTrigger));
      await tester.pump();
      await tester.pump(ElDurations.base);
      expect(_widthOf(tester, panel), ElWidths.sidebar);
    });

    testWidgets('the width leg is LINEAR over 250ms, not eased', (
      WidgetTester tester,
    ) async {
      // Measured: 256 → 48 in even ~13.85px steps per 16.6ms frame, reaching 48
      // exactly 250ms after the flip, with no front-loading and no overshoot.
      await tester.pumpDs(_shell(), animate: true);
      final Finder panel = find.byType(ElSidebar);

      await tester.tap(find.byType(ElSidebarTrigger));
      await tester.pump();

      const double travel = ElWidths.sidebar - ElWidths.sidebarIcon;
      for (final double fraction in <double>[0.25, 0.5, 0.75]) {
        await tester.pump(
          Duration(
            microseconds: (ElDurations.base.inMicroseconds * 0.25).round(),
          ),
        );
        final double want = ElWidths.sidebar - travel * fraction;
        expect(
          _widthOf(tester, panel),
          closeTo(want, 1),
          reason: 'at $fraction of the run the panel should be $want',
        );
      }
      await tester.pump(ElDurations.base);
      expect(_widthOf(tester, panel), ElWidths.sidebarIcon);
    });

    testWidgets('offcanvas closes the gap and slides the panel out', (
      WidgetTester tester,
    ) async {
      await tester.pumpDs(_shell(collapsible: ElSidebarCollapsible.offcanvas));
      final Finder panel = find.byType(ElSidebar);
      expect(_widthOf(tester, panel), ElWidths.sidebar);

      await tester.tap(find.byType(ElSidebarTrigger));
      await tester.pump();
      await tester.pump(ElDurations.base);

      // The gap goes to nothing; the container keeps its 256 and leaves.
      expect(_widthOf(tester, panel), 0);
      final Rect content = _rectOf(tester, find.byType(ElSidebarContent));
      expect(content.width, closeTo(ElWidths.sidebar - ElWidths.hairline, 0.5));
      expect(content.left, closeTo(-ElWidths.sidebar, 0.5));
    });

    testWidgets('collapsible=none never collapses and shows no rail', (
      WidgetTester tester,
    ) async {
      await tester.pumpDs(_shell(collapsible: ElSidebarCollapsible.none));
      expect(_widthOf(tester, find.byType(ElSidebar)), ElWidths.sidebar);
      await tester.tap(find.byType(ElSidebarTrigger));
      await tester.pump();
      await tester.pump(ElDurations.base);
      expect(_widthOf(tester, find.byType(ElSidebar)), ElWidths.sidebar);
    });

    testWidgets('the row snaps to a 32px square on the flip\'s first frame', (
      WidgetTester tester,
    ) async {
      // `size-8!` is not in `btn-spring`'s property list, so it lands whole
      // while the panel is still 256 wide (measured at Δ0).
      await tester.pumpDs(_shell(), animate: true);

      await tester.tap(find.byType(ElSidebarTrigger));
      await tester.pump();
      await tester.pump(ElDurations.frame);

      final Size row = tester
          .renderObject<RenderBox>(find.byType(ElSidebarMenuButton).first)
          .size;
      expect(row.height, ElSidebarMenuButton.iconSize);
      expect(
        _widthOf(tester, find.byType(ElSidebar)),
        greaterThan(ElWidths.sidebarIcon),
      );
    });

    testWidgets('⌘B and Ctrl-B both toggle, from anywhere', (
      WidgetTester tester,
    ) async {
      await tester.pumpDs(_shell());
      final Finder panel = find.byType(ElSidebar);

      await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
      await tester.sendKeyEvent(ElSidebarProvider.shortcut);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
      await tester.pump();
      await tester.pump(ElDurations.base);
      expect(_widthOf(tester, panel), ElWidths.sidebarIcon);

      await tester.sendKeyDownEvent(LogicalKeyboardKey.metaLeft);
      await tester.sendKeyEvent(ElSidebarProvider.shortcut);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.metaLeft);
      await tester.pump();
      await tester.pump(ElDurations.base);
      expect(_widthOf(tester, panel), ElWidths.sidebar);
    });

    testWidgets('a bare `b` does nothing', (WidgetTester tester) async {
      await tester.pumpDs(_shell());
      await tester.sendKeyEvent(ElSidebarProvider.shortcut);
      await tester.pump();
      await tester.pump(ElDurations.base);
      expect(_widthOf(tester, find.byType(ElSidebar)), ElWidths.sidebar);
    });
  });

  /* ── The frame variants ────────────────────────────────────────────────── */

  group('variants', () {
    testWidgets('floating pays p-2 on both edges and rounds its panel', (
      WidgetTester tester,
    ) async {
      await tester.pumpDs(_shell(variant: ElSidebarVariant.floating));
      // Measured: a 256px container holding a 240 × 366 inner card at
      // `rounded-lg`, inside a 382px frame.
      expect(_widthOf(tester, find.byType(ElSidebar)), ElWidths.sidebar);
      final Rect inner = _rectOf(tester, find.byType(ElSidebarContent));
      // Measured 240 — 256 less `p-2` on both edges, and no border at all:
      // the floating panel wears a ring, which costs no layout.
      expect(
        inner.width,
        closeTo(ElWidths.sidebar - 2 * ElSidebar.framePadding, 0.5),
      );
    });

    testWidgets(
      'floating and inset collapse to 64 of gap and 66 of container',
      (WidgetTester tester) async {
        await tester.pumpDs(_shell(variant: ElSidebarVariant.inset));
        await tester.tap(find.byType(ElSidebarTrigger));
        await tester.pump();
        await tester.pump(ElDurations.base);

        // `calc(var(--sidebar-width-icon) + --spacing(4))` and its `+2px` twin.
        expect(
          _widthOf(tester, find.byType(ElSidebar)),
          ElSidebar.insetIconGap,
        );
        expect(ElSidebar.insetIconGap, ElWidths.sidebarIcon + el(4));
        expect(
          ElSidebar.insetIconWidth,
          ElSidebar.insetIconGap + 2 * ElWidths.hairline,
        );
      },
    );

    testWidgets('the inset variant insets the main column, ml-0 while open', (
      WidgetTester tester,
    ) async {
      await tester.pumpDs(_shell(variant: ElSidebarVariant.inset));
      final Finder card = find.descendant(
        of: find.byType(ElSidebarInset),
        matching: find.byType(ClipRRect),
      );
      final Rect open = _rectOf(tester, card);
      expect(open.height, _stage.height - 2 * ElSidebarInset.margin);
      expect(open.left, _rectOf(tester, find.byType(ElSidebar)).right);

      await tester.tap(find.byType(ElSidebarTrigger));
      await tester.pump();
      await tester.pump(ElDurations.base);

      // `peer-data-[state=collapsed]:ml-2` — the lane opens once it collapses.
      expect(
        _rectOf(tester, card).left,
        _rectOf(tester, find.byType(ElSidebar)).right + ElSidebarInset.margin,
      );
    });

    testWidgets('side=right puts the panel on the far edge', (
      WidgetTester tester,
    ) async {
      await tester.pumpDs(_shell(side: ElSidebarSide.right));
      // The gap is still the first flex item — the container is what moves.
      final Rect content = _rectOf(tester, find.byType(ElSidebarContent));
      expect(content.right, closeTo(ElWidths.sidebar, 0.5));
    });
  });

  /* ── Rows ──────────────────────────────────────────────────────────────── */

  group('rows', () {
    testWidgets('the three sizes map onto Button\'s own ladder', (
      WidgetTester tester,
    ) async {
      expect(ElSidebarMenuButtonSize.sm.button, ElButtonSize.xs);
      expect(ElSidebarMenuButtonSize.md.button, ElButtonSize.sm);
      expect(ElSidebarMenuButtonSize.lg.button, ElButtonSize.lg);
      expect(ElSidebarMenuSubButtonSize.md.button, ElButtonSize.sm);
    });

    testWidgets('a default row is 37.5 tall at h-auto px-2 py-2', (
      WidgetTester tester,
    ) async {
      await tester.pumpDs(_shell(collapsible: ElSidebarCollapsible.none));
      final Size row = tester
          .renderObject<RenderBox>(find.byType(ElSidebarMenuButton).first)
          .size;
      // 19.5 of line box, `py-2` twice, and a 1px border twice.
      expect(row.height, closeTo(37.5, 0.01));
    });

    testWidgets('the row wears rounded-lg, not the pill', (
      WidgetTester tester,
    ) async {
      await tester.pumpDs(_shell(collapsible: ElSidebarCollapsible.none));
      final ElButton button = tester.widget<ElButton>(
        find.descendant(
          of: find.byType(ElSidebarMenuButton).first,
          matching: find.byType(ElButton),
        ),
      );
      expect(button.radius, BorderRadius.circular(ElRadii.lg));
      expect(button.autoHeight, isTrue);
      expect(button.variant, ElButtonVariant.ghost);
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
            child: ElSidebarProvider(
              children: <Widget>[
                Expanded(
                  child: ElSidebar(
                    collapsible: ElSidebarCollapsible.none,
                    expand: true,
                    children: <Widget>[
                      ElSidebarGroup(
                        children: <Widget>[
                          ElSidebarGroupContent(
                            child: ElSidebarMenu(
                              children: <Widget>[
                                ElSidebarMenuItem(
                                  button: const ElSidebarMenuButton(
                                    child: ElSidebarMenuLabel('Reports'),
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
        return tester.widget<ElButton>(find.byType(ElButton).first).padding!;
      }

      double right(EdgeInsetsGeometry padding) =>
          padding.resolve(TextDirection.ltr).right;

      expect(right(await paddingWith()), ElSidebarMenuButton.padding);
      expect(
        right(await paddingWith(badge: const ElSidebarMenuBadge('3'))),
        ElSidebarMenuButton.badgeLane,
      );
      expect(
        right(
          await paddingWith(
            action: const ElSidebarMenuAction(
              label: 'Add',
              child: ElIcon(ElIconGlyph.plus),
            ),
          ),
        ),
        ElSidebarMenuButton.actionLane,
      );
    });

    testWidgets('the badge is h-5 with a min-w-5 floor and mono figures', (
      WidgetTester tester,
    ) async {
      await tester.pumpDs(
        SizedBox(
          width: 300,
          child: ElSidebarProvider(
            children: <Widget>[
              Expanded(
                child: ElSidebar(
                  collapsible: ElSidebarCollapsible.none,
                  expand: true,
                  children: <Widget>[
                    ElSidebarGroup(
                      children: <Widget>[
                        ElSidebarGroupContent(
                          child: ElSidebarMenu(
                            children: <Widget>[
                              ElSidebarMenuItem(
                                button: const ElSidebarMenuButton(
                                  child: ElSidebarMenuLabel('Reports'),
                                ),
                                badge: const ElSidebarMenuBadge('3'),
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
          .renderObject<RenderBox>(find.byType(ElSidebarMenuBadge))
          .size;
      expect(badge.height, ElBadge.height);
      // The floor, not the width: a one-digit count measures narrower than
      // 20 in every face, and this file loads none — the page test carries the
      // rendered numbers.
      expect(badge.width, greaterThanOrEqualTo(ElSidebarMenuBadge.minWidth));
      expect(
        tester.widget<ElBadge>(find.byType(ElBadge)).spec,
        ElComponentType.sidebarMenuBadge,
      );
      // The chip is `pointer-events-none` — a click goes to the row under it.
      expect(find.byType(IgnorePointer), findsWidgets);
    });

    testWidgets('a sub list hangs off a spine and hides in icon mode', (
      WidgetTester tester,
    ) async {
      await tester.pumpDs(_shellWithSubmenu());
      expect(find.byType(ElSidebarMenuSubButton), findsNWidgets(2));
      final Size sub = tester
          .renderObject<RenderBox>(find.byType(ElSidebarMenuSubButton).first)
          .size;
      expect(sub.height, ElButton.heightFor(ElButtonSize.sm));

      await tester.tap(find.byType(ElSidebarTrigger));
      await tester.pump();
      await tester.pump(ElDurations.base);
      expect(find.byType(ElSidebarMenuSubButton), findsNothing);
    });
  });

  /* ── The pill ──────────────────────────────────────────────────────────── */

  group('pill', () {
    testWidgets('lands on the active row and takes its rect', (
      WidgetTester tester,
    ) async {
      await tester.pumpDs(_shell(collapsible: ElSidebarCollapsible.none));
      await tester.pump();

      final Rect row = tester.getRect(find.byType(ElSidebarMenuButton).first);
      final Finder pill = find.descendant(
        of: find.byType(ElSidebarMenu),
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

      final Rect row = tester.getRect(find.byType(ElSidebarMenuButton).first);
      final Rect painted = tester.getRect(
        find.descendant(
          of: find.byType(ElSidebarMenu),
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
          child: ElSidebarProvider(
            children: <Widget>[
              Expanded(
                child: ElSidebar(
                  collapsible: ElSidebarCollapsible.none,
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
          of: find.byType(ElSidebarMenu),
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

      ElTooltip tip() => tester.widget<ElTooltip>(find.byType(ElTooltip).first);
      expect(tip().side, ElTooltipSide.right);
      expect(tip().hidden, isTrue);

      await tester.tap(find.byType(ElSidebarTrigger));
      await tester.pump();
      await tester.pump(ElDurations.base);
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
        tester.getCenter(find.byType(ElSidebarMenuButton).first),
      );
      await tester.pump(ElDurations.tooltipDelay);
      await tester.pump(ElDurations.overlay);
      expect(find.byType(ElTooltipContent), findsNothing);
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
          child: ElSidebarProvider(
            children: <Widget>[
              Expanded(
                child: ElSidebar(
                  collapsible: ElSidebarCollapsible.none,
                  expand: true,
                  children: <Widget>[
                    ElSidebarCollapsibleGroup(
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

      expect(find.byType(ElSidebarMenuButton), findsNWidgets(3));

      await tester.tap(find.byType(ElButton).first);
      await tester.pump();
      await tester.pump(ElDurations.jelly);

      expect(find.byType(ElSidebarMenuButton), findsNothing);
      expect(ElSidebarCollapsibleGroup.lineOpen, ElWidths.hairline);
      expect(ElSidebarCollapsibleGroup.lineClosed, el(1));
    });

    testWidgets('the group label is h-8 and .type-nav-sm', (
      WidgetTester tester,
    ) async {
      await tester.pumpDs(
        SizedBox(
          width: 320,
          child: ElSidebarProvider(
            children: <Widget>[
              Expanded(
                child: ElSidebar(
                  collapsible: ElSidebarCollapsible.none,
                  expand: true,
                  children: <Widget>[
                    ElSidebarCollapsibleGroup(
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
            .renderObject<RenderBox>(find.byType(ElSidebarGroupLabel))
            .size
            .height,
        ElSidebarGroupLabel.height,
      );
      expect(ElType.navSm.size, 11.5);
      expect(ElType.navSm.height, 1.2);
    });
  });

  /* ── The input and the skeleton ────────────────────────────────────────── */

  group('parts', () {
    testWidgets('SidebarInput is h-8, --background filled and socket-less', (
      WidgetTester tester,
    ) async {
      await tester.pumpDs(
        const SizedBox(
          width: 300,
          child: ElSidebarInput(placeholder: 'Search'),
        ),
      );
      expect(
        tester.renderObject<RenderBox>(find.byType(ElInput)).size.height,
        ElSidebarInput.height,
      );
      final ElInput input = tester.widget<ElInput>(find.byType(ElInput));
      expect(input.boxHeight, el(8));
      expect(input.flat, isTrue);
      expect(input.fill, isNotNull);
    });

    testWidgets('the skeleton width is a stable hash of its seed', (
      WidgetTester tester,
    ) async {
      // DRIFT 4: the reference hashes `useId()` so server and client agree;
      // there is no hydration here, so the seed is the caller's.
      final double a = ElSidebarMenuSkeleton.widthFraction('row-1');
      expect(a, ElSidebarMenuSkeleton.widthFraction('row-1'));
      expect(a, greaterThanOrEqualTo(0.5));
      expect(a, lessThanOrEqualTo(0.9));
      expect(ElSidebarMenuSkeleton.widthFraction('row-2'), isNot(equals(a)));

      await tester.pumpDs(
        const SizedBox(
          width: 240,
          child: ElSidebarMenuSkeleton(showIcon: true, seed: 'row-1'),
        ),
      );
      expect(
        tester
            .renderObject<RenderBox>(find.byType(ElSidebarMenuSkeleton))
            .size
            .height,
        ElSidebarMenuSkeleton.height,
      );
    });

    testWidgets('useSidebar reports the four fields the readout prints', (
      WidgetTester tester,
    ) async {
      late ElSidebarScope scope;
      await tester.pumpDs(
        SizedBox(
          width: _stage.width,
          height: _stage.height,
          child: ElSidebarProvider(
            children: <Widget>[
              Builder(
                builder: (BuildContext context) {
                  scope = ElSidebarScope.of(context);
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
      expect(ElSidebarProvider.isMobileWidth(767), isTrue);
      expect(ElSidebarProvider.isMobileWidth(ElBreakpoints.md), isFalse);

      await tester.pumpDs(_shell(), size: const Size(400, 700));
      expect(find.byType(ElSidebarContent), findsNothing);

      await tester.tap(find.byType(ElSidebarTrigger));
      await tester.pump();
      expect(find.byType(ElSheetContent), findsOneWidget);
      expect(
        tester.widget<ElSheetContent>(find.byType(ElSheetContent)).width,
        ElWidths.sidebarMobile,
      );
    });
  });
}

/// A panel whose one row carries a submenu.
Widget _shellWithSubmenu({bool activeSub = false}) => SizedBox(
  width: _stage.width,
  height: _stage.height,
  child: ElSidebarProvider(
    children: <Widget>[
      ElSidebar(
        collapsible: ElSidebarCollapsible.icon,
        children: <Widget>[
          ElSidebarContent(
            children: <Widget>[
              ElSidebarGroup(
                children: <Widget>[
                  ElSidebarGroupContent(
                    child: ElSidebarMenu(
                      children: <Widget>[
                        ElSidebarMenuItem(
                          button: const ElSidebarMenuButton(
                            isActive: true,
                            child: ElSidebarMenuLabel('All cards'),
                          ),
                          submenu: ElSidebarMenuSub(
                            children: <Widget>[
                              ElSidebarMenuSubItem(
                                child: ElSidebarMenuSubButton(
                                  label: 'Open',
                                  isActive: activeSub,
                                ),
                              ),
                              const ElSidebarMenuSubItem(
                                child: ElSidebarMenuSubButton(label: 'Settled'),
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
      const ElSidebarInset(child: ElSidebarTrigger()),
    ],
  ),
);
