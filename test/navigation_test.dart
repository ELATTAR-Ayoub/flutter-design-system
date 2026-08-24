import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// The navigation family: `Tabs`, `Breadcrumb`, `Pagination`,
/// `NavigationMenu`, `Accordion` and `Collapsible`.
///
/// Numbers marked *(measured)* were read off the live reference at
/// `localhost:3000/design-system/components/base/navigation` on 2026-08-16 with
/// `getComputedStyle` / `getBoundingClientRect`, or sampled every frame through
/// a real pointer — not derived from a map. The page's own oracle lives in
/// `example/test/navigation_page_test.dart`; this file is the components alone,
/// so it asserts structure, state and token-derived geometry rather than line
/// boxes, which need the reference's font binaries the example harness loads.

Widget host(
  Widget child, {
  ElThemeMode mode = ElThemeMode.dark,
  Size size = const Size(1440, 900),
  TextDirection direction = TextDirection.ltr,
}) {
  return MediaQuery(
    data: MediaQueryData(size: size),
    child: Directionality(
      textDirection: direction,
      child: ElTheme(
        controller: ElThemeController(mode: mode),
        child: Center(child: child),
      ),
    ),
  );
}

/// What [overlayHost] is currently showing — `selects_test.dart`'s holder
/// trick, for its reason: `initialEntries` is read once, in `initState`.
Widget _hosted = const SizedBox.shrink();

Widget overlayHost(
  Widget child, {
  ElThemeMode mode = ElThemeMode.dark,
  Size size = const Size(1440, 900),
  Alignment align = Alignment.topCenter,
}) {
  _hosted = child;
  return MediaQuery(
    data: MediaQueryData(size: size),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: ElTheme(
        controller: ElThemeController(mode: mode),
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

ElThemeData themeIn(WidgetTester t, Type of) =>
    ElTheme.of(t.element(find.byType(of).first));

/// Opens (or closes) an overlay: one frame for the prop, one for the portal.
Future<void> settleOverlay(WidgetTester tester) async {
  await tester.pump();
  await tester.pump();
}

/// …and then runs the entrance out.
///
/// Load-bearing wherever a rect is read: the panel enters at `zoom-in-95`
/// about its own centre, so a box measured mid-flight is 95% of itself and
/// 2.5% of its height further down. Every geometry assertion below waits.
Future<void> settleEntrance(WidgetTester tester) async {
  await settleOverlay(tester);
  await tester.pump(ElDurations.overlay);
  await tester.pump();
}

/// §3's first tab set.
List<ElTabItem> _liveTabs() => <ElTabItem>[
  const ElTabItem(label: 'Live Pulls', content: Text('live')),
  const ElTabItem(label: 'Top Hits', content: Text('hits')),
  const ElTabItem(label: 'My Pulls', content: Text('mine')),
];

void main() {
  /* ── Tabs ──────────────────────────────────────────────────────────────── */

  group('ElTabs — the ladder §3 states in prose', () {
    test('40px track, 4px inset, 32px triggers on 16px padding', () {
      // The section's own trailing caption, asserted as numbers *(measured:
      // the track is 40 tall on `p-1`, the triggers 32 on `px-4`)*.
      expect(ElTabs.trackHeight, 40);
      expect(ElTabs.trackPadding, 4);
      expect(ElTabs.triggerHeight, 32);
      expect(ElTabs.triggerPaddingX, 16);
      // Stock shadcn's 32 / 3 / 25 is what the caption is arguing against.
      expect(ElTabs.trackHeight, isNot(32));
    });

    test('the two variants gap differently', () {
      // `gap-1` on the filled track, `gap-2` on the bare one *(measured 4 and
      // 8)*.
      expect(ElTabs.gapFor(ElTabsVariant.standard), 4);
      expect(ElTabs.gapFor(ElTabsVariant.line), 8);
      // `h-0.5`.
      expect(ElTabs.ruleHeight, 2);
      // `flex gap-2` between the track and the view.
      expect(ElTabs.rootGap, 8);
    });

    testWidgets('the standard mark is a `--primary` pill under the label', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        host(
          ElTabs(items: _liveTabs(), selectedIndex: 0, onChanged: (int _) {}),
        ),
      );
      await tester.pump();

      final ElThemeData theme = themeIn(tester, ElTabs);
      final ElMachineSurface pill = tester.widget<ElMachineSurface>(
        find.byType(ElMachineSurface).first,
      );
      expect(pill.fill, theme.primary);
      expect(pill.spec, ElShadows.chip);
      // The pill is painted FIRST, so the label is never behind it — the
      // reference gets the same result from `z-10` on the trigger.
      expect(find.text('Live Pulls'), findsOneWidget);
    });

    testWidgets(
      'the line mark is a 2px `--action-ink` rule on the bottom edge',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          host(
            ElTabs(
              variant: ElTabsVariant.line,
              items: _liveTabs(),
              selectedIndex: 0,
              onChanged: (int _) {},
            ),
          ),
        );
        await tester.pump();

        final ElThemeData theme = themeIn(tester, ElTabs);
        final Iterable<BoxDecoration> rules = tester
            .widgetList<DecoratedBox>(find.byType(DecoratedBox))
            .map((DecoratedBox b) => b.decoration as BoxDecoration)
            .where((BoxDecoration d) => d.color == theme.actionInk);
        expect(rules, hasLength(1));
        expect(rules.first.borderRadius, BorderRadius.circular(ElRadii.pill));
        // No filled pill anywhere in this variant.
        expect(
          tester
              .widgetList<ElMachineSurface>(find.byType(ElMachineSurface))
              .where((ElMachineSurface s) => s.fill == theme.primary),
          isEmpty,
        );
      },
    );

    testWidgets('the squash pivots on the rule\'s own edge, and only there', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        host(
          ElTabs(
            variant: ElTabsVariant.line,
            items: _liveTabs(),
            selectedIndex: 0,
            onChanged: (int _) {},
          ),
        ),
      );
      await tester.pump();
      expect(
        tester
            .widget<ElSlidingPillGroup>(find.byType(ElSlidingPillGroup))
            .jellyAlignment,
        Alignment.bottomCenter,
      );

      await tester.pumpWidget(
        host(
          ElTabs(items: _liveTabs(), selectedIndex: 0, onChanged: (int _) {}),
        ),
      );
      await tester.pump();
      expect(
        tester
            .widget<ElSlidingPillGroup>(find.byType(ElSlidingPillGroup))
            .jellyAlignment,
        Alignment.center,
      );
    });

    testWidgets('only the selected item\'s view is mounted', (
      WidgetTester tester,
    ) async {
      int selected = 0;
      await tester.pumpWidget(
        host(
          StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) => ElTabs(
              items: _liveTabs(),
              selectedIndex: selected,
              onChanged: (int i) => setState(() => selected = i),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.text('live'), findsOneWidget);
      expect(find.text('hits'), findsNothing);

      await tester.tap(find.text('Top Hits'));
      await tester.pump();
      expect(find.text('hits'), findsOneWidget);
      expect(find.text('live'), findsNothing);
      expect(selected, 1);
    });

    testWidgets('a trigger with no content leaves the set with no view', (
      WidgetTester tester,
    ) async {
      // Five triggers and one `TabsContent` is what §3's account set ships.
      await tester.pumpWidget(
        host(
          ElTabs(
            items: const <ElTabItem>[
              ElTabItem(label: 'Overview', content: Text('overview')),
              ElTabItem(label: 'Security'),
            ],
            selectedIndex: 1,
            onChanged: (int _) {},
          ),
        ),
      );
      await tester.pump();
      expect(find.text('overview'), findsNothing);
      expect(find.text('Security'), findsOneWidget);
    });

    testWidgets('the active ink differs by variant', (
      WidgetTester tester,
    ) async {
      for (final (ElTabsVariant variant, bool onPrimary)
          in <(ElTabsVariant, bool)>[
            (ElTabsVariant.standard, true),
            (ElTabsVariant.line, false),
          ]) {
        await tester.pumpWidget(
          host(
            ElTabs(
              variant: variant,
              items: _liveTabs(),
              selectedIndex: 0,
              onChanged: (int _) {},
            ),
          ),
        );
        await tester.pump();
        await tester.pump(ElDurations.transitionDefault);

        final ElThemeData theme = themeIn(tester, ElTabs);
        final ElText active = tester.widget<ElText>(
          find
              .ancestor(
                of: find.text('Live Pulls'),
                matching: find.byType(ElText),
              )
              .first,
        );
        expect(
          active.color,
          onPrimary ? theme.primaryForeground : theme.foreground,
          reason:
              'the filled pill carries white ink; the rule leaves the '
              'label on `--foreground`',
        );
        final ElText resting = tester.widget<ElText>(
          find
              .ancestor(
                of: find.text('My Pulls'),
                matching: find.byType(ElText),
              )
              .first,
        );
        expect(resting.color, theme.mutedForeground);
      }
    });
  });

  /* ── Breadcrumb ────────────────────────────────────────────────────────── */

  group('ElBreadcrumb', () {
    test('the two spacings the list and its separator carry', () {
      // `gap-1.5` on the `ol`, `[&>svg]:size-3.5` on the separator
      // *(measured 6 and 14)*.
      expect(ElBreadcrumb.gap, 6);
      expect(ElBreadcrumb.separatorPx, 14);
    });

    testWidgets('a separator is derived between every pair, and nowhere else', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        host(
          const ElBreadcrumb(
            items: <ElBreadcrumbEntry>[
              ElBreadcrumbEntry.link('Packs'),
              ElBreadcrumbEntry.link('Eclipse Vault'),
              ElBreadcrumbEntry.page('Origin Pulse — Series I'),
            ],
          ),
        ),
      );
      await tester.pump();
      expect(
        tester
            .widgetList<ElIcon>(find.byType(ElIcon))
            .where((ElIcon i) => i.glyph == ElIconGlyph.chevronRight),
        hasLength(2),
      );

      await tester.pumpWidget(
        host(
          const ElBreadcrumb(
            items: <ElBreadcrumbEntry>[ElBreadcrumbEntry.page('Only')],
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(ElIcon), findsNothing);
    });

    testWidgets('the current page is `--foreground` and is not a link', (
      WidgetTester tester,
    ) async {
      int taps = 0;
      await tester.pumpWidget(
        host(
          ElBreadcrumb(
            items: <ElBreadcrumbEntry>[
              ElBreadcrumbEntry.link('Packs', onTap: () => taps++),
              const ElBreadcrumbEntry.page('Series I'),
            ],
          ),
        ),
      );
      await tester.pump();
      final ElThemeData theme = themeIn(tester, ElBreadcrumb);

      final ElText page = tester.widget<ElText>(
        find
            .ancestor(of: find.text('Series I'), matching: find.byType(ElText))
            .first,
      );
      expect(page.color, theme.foreground);
      // `font-normal` on a `text-sm` list — 13px at the inherited 400.
      expect(page.spec, ElComponentType.textSm);

      final ElText link = tester.widget<ElText>(
        find
            .ancestor(of: find.text('Packs'), matching: find.byType(ElText))
            .first,
      );
      expect(link.color, theme.mutedForeground);

      await tester.tap(find.text('Series I'));
      await tester.pump();
      expect(taps, 0, reason: 'a BreadcrumbPage is aria-disabled and inert');
      await tester.tap(find.text('Packs'));
      await tester.pump();
      expect(taps, 1);
    });

    testWidgets('direction is context: the trail reverses under an RTL scope', (
      WidgetTester tester,
    ) async {
      const Widget trail = ElBreadcrumb(
        items: <ElBreadcrumbEntry>[
          ElBreadcrumbEntry.link('first'),
          ElBreadcrumbEntry.page('last'),
        ],
      );
      await tester.pumpWidget(host(trail));
      await tester.pump();
      expect(
        tester.getTopLeft(find.text('first')).dx <
            tester.getTopLeft(find.text('last')).dx,
        isTrue,
      );

      await tester.pumpWidget(host(trail, direction: TextDirection.rtl));
      await tester.pump();
      expect(
        tester.getTopLeft(find.text('first')).dx >
            tester.getTopLeft(find.text('last')).dx,
        isTrue,
        reason: 'the same composition, one provider, the other reading order',
      );
    });
  });

  /* ── Pagination ────────────────────────────────────────────────────────── */

  group('ElPagination', () {
    test('the cells sit on `gap-0.5`, and the two ends break `px-4`', () {
      expect(ElPagination.gap, 2);
      // `pl-1.5!` / `pr-1.5!` against the `default` rung's own `px-4`
      // *(measured `padding: 0 16px 0 6px` on Previous)*.
      expect(ElPaginationStep.tightPadding, 6);
      expect(ElPaginationStep.loosePadding, 16);
      // `size-8` around a `size-4` glyph.
      expect(ElPaginationEllipsis.boxSize, 32);
      expect(ElPaginationEllipsis.glyphSize, 16);
    });

    testWidgets('the current page is `outline` and every other cell `ghost`', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        host(
          const ElPagination(
            children: <Widget>[
              ElPaginationStep.previous(),
              ElPaginationLink(label: '1'),
              ElPaginationLink(label: '2', isActive: true),
              ElPaginationEllipsis(),
              ElPaginationStep.next(),
            ],
          ),
        ),
      );
      await tester.pump();

      final List<ElButton> buttons = tester
          .widgetList<ElButton>(find.byType(ElButton))
          .toList();
      expect(buttons, hasLength(4));
      expect(buttons.map((ElButton b) => b.variant).toList(), <ElButtonVariant>[
        ElButtonVariant.ghost,
        ElButtonVariant.ghost,
        ElButtonVariant.outline,
        ElButtonVariant.ghost,
      ]);
      // Two squares and two word buttons.
      expect(buttons.map((ElButton b) => b.size).toList(), <ElButtonSize>[
        ElButtonSize.md,
        ElButtonSize.icon,
        ElButtonSize.icon,
        ElButtonSize.md,
      ]);
    });

    testWidgets(
      'a numbered cell is a 40px square and the ellipsis a 32px one',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          host(
            const ElPagination(
              children: <Widget>[
                ElPaginationLink(label: '2', isActive: true),
                ElPaginationEllipsis(),
              ],
            ),
          ),
        );
        await tester.pump();
        expect(
          tester.getSize(find.byType(ElPaginationLink)),
          const Size(40, 40),
        );
        expect(
          tester.getSize(find.byType(ElPaginationEllipsis)),
          const Size(32, 32),
        );
      },
    );

    testWidgets('DRIFT — the numbers inherit the page\'s type, the words do '
        'not', (WidgetTester tester) async {
      // `size="icon"` is `size-10` and nothing else: no `text-*`, so the rung
      // answers null and the button merges only the ink *(measured
      // `16px/24px 500` on the squares against `13px/18.5714px 500` on the two
      // word buttons)*.
      expect(
        ElButton.typeFor(ElButtonSize.icon, ElButtonEmphasis.none),
        isNull,
      );
      expect(
        ElButton.typeFor(ElButtonSize.md, ElButtonEmphasis.none),
        ElComponentType.buttonLabel,
      );
    });

    testWidgets('the chevron leads on Previous and trails on Next', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        host(
          const ElPagination(
            children: <Widget>[
              ElPaginationStep.previous(),
              ElPaginationStep.next(),
            ],
          ),
        ),
      );
      await tester.pump();
      expect(
        tester.getTopLeft(find.byType(ElIcon).first).dx <
            tester.getTopLeft(find.text('Previous')).dx,
        isTrue,
      );
      expect(
        tester.getTopLeft(find.byType(ElIcon).last).dx >
            tester.getTopLeft(find.text('Next')).dx,
        isTrue,
      );
    });
  });

  /* ── Navigation menu ───────────────────────────────────────────────────── */

  group('ElNavigationMenu', () {
    List<ElNavigationMenuItem> items() => <ElNavigationMenuItem>[
      const ElNavigationMenuItem.trigger(
        label: 'Packs',
        content: SizedBox(width: 200, height: 60, child: Text('packs')),
      ),
      const ElNavigationMenuItem.trigger(
        label: 'Marketplace',
        content: SizedBox(width: 200, height: 60, child: Text('market')),
      ),
      const ElNavigationMenuItem.link(label: 'Leaderboard'),
    ];

    test('the 40px pill on 16px clearance, and the panel\'s own 8 + 8', () {
      // *"The trigger is a 40px pill, not a 36px rounded rectangle."*
      expect(ElNavigationMenu.triggerHeight, 40);
      expect(ElNavigationMenu.triggerPaddingX, 16);
      expect(ElNavigationMenu.triggerGap, 6);
      expect(ElNavigationMenu.listGap, 4);
      // `mt-2` on the viewport and `p-2` inside it.
      expect(ElNavigationMenu.panelOffset, 8);
      expect(ElNavigationMenu.panelPadding, 8);
      // `h-2` around a `size-2` square — the same eight pixels the offset
      // spends, which is why a menu with an indicator does not pay both.
      expect(ElNavigationMenu.indicatorHeight, 8);
      expect(ElNavigationMenu.caretSize, 8);
      // `size="sm"` on the chevron.
      expect(ElNavigationMenu.chevronPx, 14);
    });

    test(
      '`text-nav` is not `.type-nav`, and the difference is 4px of leading',
      () {
        // *(Measured: the trigger and its plain-link sibling read
        // `13.5px/20.25px 500`; the top-nav buttons three sections up, which wear
        // the `.type-nav` class, read `13.5px/16.2px 500`.)*
        expect(ElComponentType.navMenuTrigger.size, 13.5);
        expect(ElType.nav.size, 13.5);
        expect(ElComponentType.navMenuTrigger.height, 1.5);
        expect(ElType.nav.height, 1.2);
        expect(ElComponentType.navMenuTrigger.weight, ElType.nav.weight);
      },
    );

    testWidgets('a tap opens the shared viewport and a second tap closes it', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(overlayHost(ElNavigationMenu(items: items())));
      await tester.pump();
      expect(find.byType(ElPopoverSurface), findsNothing);

      await tester.tap(find.text('Packs'));
      await settleOverlay(tester);
      expect(find.byType(ElPopoverSurface), findsOneWidget);
      expect(find.text('packs'), findsOneWidget);

      await tester.tap(find.text('Packs'));
      await settleOverlay(tester);
      await tester.pump(ElDurations.overlay);
      await tester.pump();
      expect(find.text('packs'), findsNothing);
    });

    testWidgets('one panel at a time, and it swaps between triggers', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(overlayHost(ElNavigationMenu(items: items())));
      await tester.pump();

      await tester.tap(find.text('Packs'));
      await settleOverlay(tester);
      expect(find.text('packs'), findsOneWidget);

      await tester.tap(find.text('Marketplace'));
      await settleOverlay(tester);
      expect(find.text('market'), findsOneWidget);
      expect(find.text('packs'), findsNothing);
      expect(find.byType(ElPopoverSurface), findsOneWidget);
    });

    testWidgets('the chevron rotates a half turn, on the spring', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(overlayHost(ElNavigationMenu(items: items())));
      await tester.pump();

      double angleOf() => tester
          .widgetList<Transform>(find.byType(Transform))
          .map((Transform t) => t.transform.storage[1])
          .reduce((double a, double b) => a.abs() > b.abs() ? a : b);

      expect(angleOf().abs(), lessThan(0.01));

      await tester.tap(find.text('Packs'));
      await settleOverlay(tester);
      await tester.pump(ElDurations.transitionDefault);
      // sin(π) is 0 to the engine's precision, so the settled state is read
      // off the cosine instead: a half turn is −1.
      final double cos = tester
          .widgetList<Transform>(find.byType(Transform))
          .map((Transform t) => t.transform.storage[0])
          .reduce((double a, double b) => a < b ? a : b);
      expect(cos, closeTo(-1, 0.01));
    });

    testWidgets('a plain link is a trigger without a chevron', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(overlayHost(ElNavigationMenu(items: items())));
      await tester.pump();
      // Two chevrons for three items.
      expect(
        tester
            .widgetList<ElIcon>(find.byType(ElIcon))
            .where((ElIcon i) => i.glyph == ElIconGlyph.chevronDown),
        hasLength(2),
      );
      // …and tapping it opens nothing.
      await tester.tap(find.text('Leaderboard'));
      await settleOverlay(tester);
      expect(find.byType(ElPopoverSurface), findsNothing);
    });

    testWidgets('DRIFT — the indicator takes the open trigger\'s width and '
        'stays at the list\'s leading edge', (WidgetTester tester) async {
      await tester.pumpWidget(
        overlayHost(ElNavigationMenu(indicator: true, items: items())),
      );
      await tester.pump();

      final double listLeft = tester.getTopLeft(find.byType(Row).first).dx;

      await tester.tap(find.text('Packs'));
      await settleEntrance(tester);
      final Rect first = tester.getRect(find.byType(ElNavigationMenuIndicator));
      expect(first.height, ElNavigationMenu.indicatorHeight);
      expect(first.left, closeTo(listLeft, 0.5));

      await tester.tap(find.text('Marketplace'));
      await settleEntrance(tester);
      final Rect second = tester.getRect(
        find.byType(ElNavigationMenuIndicator),
      );
      // The width follows the trigger…
      expect(second.width, greaterThan(first.width));
      // …and the position does not. Radix reads `offsetLeft`, and every
      // trigger's offset parent is its own `relative` list item.
      expect(second.left, closeTo(listLeft, 0.5));
    });

    testWidgets('an indicator spends the panel\'s own 8px rather than adding '
        'to them', (WidgetTester tester) async {
      for (final bool indicator in <bool>[false, true]) {
        await tester.pumpWidget(
          overlayHost(
            // Keyed per case: without it the second pump reuses the first
            // menu's State, whose panel is already open, and the tap below
            // closes it instead.
            ElNavigationMenu(
              key: ValueKey<bool>(indicator),
              indicator: indicator,
              items: items(),
            ),
          ),
        );
        await tester.pump();
        await tester.tap(find.text('Packs'));
        await settleEntrance(tester);

        final double barBottom = tester
            .getRect(find.byType(ElNavigationMenu))
            .bottom;
        final double panelTop = tester
            .getRect(find.byType(ElPopoverSurface))
            .top;
        expect(
          panelTop - barBottom,
          closeTo(ElNavigationMenu.panelOffset, 0.5),
          reason:
              'the panel is `mt-2` below the bar either way; with an '
              'indicator those eight pixels are the caret\'s clipping band',
        );
      }
    });

    testWidgets('a panel link is muted at rest and `--accent` when current', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        host(
          const Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ElNavigationMenuLink(active: true, child: Text('Browse all')),
              ElNavigationMenuLink(child: Text('Trending')),
            ],
          ),
        ),
      );
      await tester.pump();

      final ElThemeData theme = themeIn(tester, ElNavigationMenuLink);
      final List<BoxDecoration> fills = tester
          .widgetList<DecoratedBox>(
            find.descendant(
              of: find.byType(ElNavigationMenuLink),
              matching: find.byType(DecoratedBox),
            ),
          )
          .map((DecoratedBox b) => b.decoration as BoxDecoration)
          .toList();
      expect(fills.first.color, theme.accent);
      expect(fills.last.color, elTransparent);
      expect(fills.first.borderRadius, BorderRadius.circular(ElRadii.md));
      // `px-3 py-2 gap-2`.
      expect(ElNavigationMenuLink.paddingX, 12);
      expect(ElNavigationMenuLink.paddingY, 8);
      expect(ElNavigationMenuLink.gap, 8);
    });

    testWidgets('`viewport: false` anchors each panel to its own item', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        overlayHost(ElNavigationMenu(viewport: false, items: items())),
      );
      await tester.pump();

      await tester.tap(find.text('Marketplace'));
      await settleOverlay(tester);
      final double panelLeft = tester
          .getRect(find.byType(ElPopoverSurface))
          .left;
      final double itemLeft = tester.getTopLeft(find.text('Marketplace')).dx;
      final double barLeft = tester.getRect(find.byType(ElNavigationMenu)).left;
      // Its own item, not the bar: the second trigger's panel starts to the
      // right of the bar's own edge.
      expect(panelLeft, greaterThan(barLeft));
      expect(panelLeft, lessThan(itemLeft));
    });
  });

  /* ── Accordion ─────────────────────────────────────────────────────────── */

  group('ElAccordion', () {
    List<ElAccordionItem> items() => const <ElAccordionItem>[
      ElAccordionItem(title: 'odds', content: Text('rolled')),
      ElAccordionItem(title: 'sell', content: Text('sell-back')),
      ElAccordionItem(title: 'ship', content: Text('shipment')),
    ];

    test('`py-2.5` on the trigger and `pb-2.5` under the panel', () {
      expect(ElAccordion.triggerPaddingY, 10);
      expect(ElAccordion.contentPaddingBottom, 10);
      // `Icon`'s own `md` default, which is what renders — the `size-4` the
      // trigger declares through a dead variant agrees by accident.
      expect(ElAccordion.chevronPx, 16);
    });

    testWidgets('one open at a time, and the open one closes itself', (
      WidgetTester tester,
    ) async {
      int? open = 0;
      await tester.pumpWidget(
        host(
          StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) =>
                ElAccordion(
                  items: items(),
                  openIndex: open,
                  onChanged: (int? i) => setState(() => open = i),
                ),
          ),
        ),
      );
      await tester.pump();
      expect(find.text('rolled'), findsOneWidget);

      await tester.tap(find.text('sell'));
      await tester.pump();
      await tester.pump(ElDurations.jelly);
      expect(open, 1);
      expect(find.text('sell-back'), findsOneWidget);
      expect(find.text('rolled'), findsNothing);

      // `collapsible`: the open item reports null rather than its own index.
      await tester.tap(find.text('sell'));
      await tester.pump();
      await tester.pump(ElDurations.jelly);
      expect(open, isNull);
      expect(find.text('sell-back'), findsNothing);
    });

    testWidgets('`not-last:border-b` — a seam under all but the last', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        host(
          ElAccordion(items: items(), openIndex: null, onChanged: (int? _) {}),
        ),
      );
      await tester.pump();
      final ElThemeData theme = themeIn(tester, ElAccordion);
      final Iterable<BoxDecoration> seams = tester
          .widgetList<Container>(find.byType(Container))
          .map((Container c) => c.decoration)
          .whereType<BoxDecoration>()
          .where((BoxDecoration d) => d.border is Border);
      expect(
        seams.where(
          (BoxDecoration d) =>
              (d.border! as Border).bottom.color == theme.border,
        ),
        hasLength(2),
      );
    });

    testWidgets('the chevron is a swap, not a rotation', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        host(ElAccordion(items: items(), openIndex: 1, onChanged: (int? _) {})),
      );
      await tester.pump();
      final List<ElIconGlyph?> glyphs = tester
          .widgetList<ElIcon>(find.byType(ElIcon))
          .map((ElIcon i) => i.glyph)
          .toList();
      expect(
        glyphs.where((ElIconGlyph? g) => g == ElIconGlyph.chevronUp),
        hasLength(1),
      );
      expect(
        glyphs.where((ElIconGlyph? g) => g == ElIconGlyph.chevronDown),
        hasLength(2),
      );
      // Nothing on this control carries a rotation at all.
      expect(find.byType(RotationTransition), findsNothing);
    });

    testWidgets('DRIFT — the chevrons are `--foreground`, not muted', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        host(ElAccordion(items: items(), openIndex: 0, onChanged: (int? _) {})),
      );
      await tester.pump();
      // `**:data-[slot=accordion-trigger-icon]:text-muted-foreground` never
      // matches, because `Icon` does not forward `data-slot` — probed, the
      // selector returns zero elements.
      for (final ElIcon icon in tester.widgetList<ElIcon>(
        find.byType(ElIcon),
      )) {
        expect(icon.tone, ElIconTone.normal);
      }
    });
  });

  /* ── Collapsible and the shared unfold ─────────────────────────────────── */

  group('ElUnfold — `anim-unfold` / `anim-fold`', () {
    testWidgets('a closed panel is not in the tree at all', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        host(const ElUnfold(open: false, child: Text('filters'))),
      );
      await tester.pump();
      expect(find.text('filters'), findsNothing);
      expect(tester.getSize(find.byType(ElUnfold)), Size.zero);
    });

    testWidgets(
      'it opens on `--duration-jelly` and closes on `--duration-base`',
      (WidgetTester tester) async {
        bool open = false;
        late StateSetter set;
        await tester.pumpWidget(
          host(
            StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                set = setState;
                return SizedBox(
                  width: 200,
                  child: ElUnfold(
                    open: open,
                    child: const SizedBox(height: 100, child: Text('body')),
                  ),
                );
              },
            ),
          ),
        );
        await tester.pump();

        set(() => open = true);
        await tester.pump();
        // Halfway through `--duration-jelly` the spring is already past its
        // target, which is the overshoot `overflow-hidden` exists to contain.
        await tester.pump(ElDurations.jelly ~/ 2);
        final double mid = tester.getSize(find.byType(ElUnfold)).height;
        expect(mid, greaterThan(0));
        await tester.pump(ElDurations.jelly);
        expect(tester.getSize(find.byType(ElUnfold)).height, 100);

        set(() => open = false);
        await tester.pump();
        // The fold starts at `yuki-fold`'s own 0% — full height — rather than
        // reversing from wherever an interrupted unfold had reached, so the
        // first frame of a close is always the settled box.
        await tester.pump(const Duration(milliseconds: 1));
        expect(tester.getSize(find.byType(ElUnfold)).height, closeTo(100, 1));
        // `yuki-fold` runs `--duration-base`, not `--duration-jelly`.
        await tester.pump(ElDurations.base);
        await tester.pump();
        await tester.pump();
        expect(tester.getSize(find.byType(ElUnfold)).height, 0);
        expect(find.text('body'), findsNothing);
      },
    );

    testWidgets('ElCollapsible stacks its trigger over the panel', (
      WidgetTester tester,
    ) async {
      bool open = false;
      await tester.pumpWidget(
        host(
          StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) => SizedBox(
              width: 300,
              child: ElCollapsible(
                open: open,
                trigger: ElButton(
                  variant: ElButtonVariant.outline,
                  onPressed: () => setState(() => open = !open),
                  child: const Text('Advanced filters'),
                ),
                content: const Text('Volatility'),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.text('Volatility'), findsNothing);

      await tester.tap(find.text('Advanced filters'));
      await tester.pump();
      await tester.pump(ElDurations.jelly);
      expect(find.text('Volatility'), findsOneWidget);
      expect(
        tester.getTopLeft(find.text('Volatility')).dy >
            tester.getTopLeft(find.text('Advanced filters')).dy,
        isTrue,
      );
    });
  });
}
