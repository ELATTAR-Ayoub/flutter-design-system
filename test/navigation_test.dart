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
  DsThemeMode mode = DsThemeMode.dark,
  Size size = const Size(1440, 900),
  TextDirection direction = TextDirection.ltr,
}) {
  return MediaQuery(
    data: MediaQueryData(size: size),
    child: Directionality(
      textDirection: direction,
      child: DsTheme(
        controller: DsThemeController(mode: mode),
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
  DsThemeMode mode = DsThemeMode.dark,
  Size size = const Size(1440, 900),
  Alignment align = Alignment.topCenter,
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
  await tester.pump(DsDurations.overlay);
  await tester.pump();
}

/// §3's first tab set.
List<DsTabItem> _liveTabs() => <DsTabItem>[
      const DsTabItem(label: 'Live Pulls', content: Text('live')),
      const DsTabItem(label: 'Top Hits', content: Text('hits')),
      const DsTabItem(label: 'My Pulls', content: Text('mine')),
    ];

void main() {
  /* ── Tabs ──────────────────────────────────────────────────────────────── */

  group('DsTabs — the ladder §3 states in prose', () {
    test('40px track, 4px inset, 32px triggers on 16px padding', () {
      // The section's own trailing caption, asserted as numbers *(measured:
      // the track is 40 tall on `p-1`, the triggers 32 on `px-4`)*.
      expect(DsTabs.trackHeight, 40);
      expect(DsTabs.trackPadding, 4);
      expect(DsTabs.triggerHeight, 32);
      expect(DsTabs.triggerPaddingX, 16);
      // Stock shadcn's 32 / 3 / 25 is what the caption is arguing against.
      expect(DsTabs.trackHeight, isNot(32));
    });

    test('the two variants gap differently', () {
      // `gap-1` on the filled track, `gap-2` on the bare one *(measured 4 and
      // 8)*.
      expect(DsTabs.gapFor(DsTabsVariant.standard), 4);
      expect(DsTabs.gapFor(DsTabsVariant.line), 8);
      // `h-0.5`.
      expect(DsTabs.ruleHeight, 2);
      // `flex gap-2` between the track and the view.
      expect(DsTabs.rootGap, 8);
    });

    testWidgets('the standard mark is a `--primary` pill under the label',
        (WidgetTester tester) async {
      await tester.pumpWidget(host(
        DsTabs(
          items: _liveTabs(),
          selectedIndex: 0,
          onChanged: (int _) {},
        ),
      ));
      await tester.pump();

      final DsThemeData theme = themeIn(tester, DsTabs);
      final DsMachineSurface pill = tester.widget<DsMachineSurface>(
        find.byType(DsMachineSurface).first,
      );
      expect(pill.fill, theme.primary);
      expect(pill.spec, DsShadows.chip);
      // The pill is painted FIRST, so the label is never behind it — the
      // reference gets the same result from `z-10` on the trigger.
      expect(find.text('Live Pulls'), findsOneWidget);
    });

    testWidgets('the line mark is a 2px `--action-ink` rule on the bottom edge',
        (WidgetTester tester) async {
      await tester.pumpWidget(host(
        DsTabs(
          variant: DsTabsVariant.line,
          items: _liveTabs(),
          selectedIndex: 0,
          onChanged: (int _) {},
        ),
      ));
      await tester.pump();

      final DsThemeData theme = themeIn(tester, DsTabs);
      final Iterable<BoxDecoration> rules = tester
          .widgetList<DecoratedBox>(find.byType(DecoratedBox))
          .map((DecoratedBox b) => b.decoration as BoxDecoration)
          .where((BoxDecoration d) => d.color == theme.actionInk);
      expect(rules, hasLength(1));
      expect(rules.first.borderRadius, BorderRadius.circular(DsRadii.pill));
      // No filled pill anywhere in this variant.
      expect(
        tester
            .widgetList<DsMachineSurface>(find.byType(DsMachineSurface))
            .where((DsMachineSurface s) => s.fill == theme.primary),
        isEmpty,
      );
    });

    testWidgets('the squash pivots on the rule\'s own edge, and only there',
        (WidgetTester tester) async {
      await tester.pumpWidget(host(
        DsTabs(
          variant: DsTabsVariant.line,
          items: _liveTabs(),
          selectedIndex: 0,
          onChanged: (int _) {},
        ),
      ));
      await tester.pump();
      expect(
        tester
            .widget<DsSlidingPillGroup>(find.byType(DsSlidingPillGroup))
            .jellyAlignment,
        Alignment.bottomCenter,
      );

      await tester.pumpWidget(host(
        DsTabs(
          items: _liveTabs(),
          selectedIndex: 0,
          onChanged: (int _) {},
        ),
      ));
      await tester.pump();
      expect(
        tester
            .widget<DsSlidingPillGroup>(find.byType(DsSlidingPillGroup))
            .jellyAlignment,
        Alignment.center,
      );
    });

    testWidgets('only the selected item\'s view is mounted',
        (WidgetTester tester) async {
      int selected = 0;
      await tester.pumpWidget(host(
        StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) => DsTabs(
            items: _liveTabs(),
            selectedIndex: selected,
            onChanged: (int i) => setState(() => selected = i),
          ),
        ),
      ));
      await tester.pump();
      expect(find.text('live'), findsOneWidget);
      expect(find.text('hits'), findsNothing);

      await tester.tap(find.text('Top Hits'));
      await tester.pump();
      expect(find.text('hits'), findsOneWidget);
      expect(find.text('live'), findsNothing);
      expect(selected, 1);
    });

    testWidgets('a trigger with no content leaves the set with no view',
        (WidgetTester tester) async {
      // Five triggers and one `TabsContent` is what §3's account set ships.
      await tester.pumpWidget(host(
        DsTabs(
          items: const <DsTabItem>[
            DsTabItem(label: 'Overview', content: Text('overview')),
            DsTabItem(label: 'Security'),
          ],
          selectedIndex: 1,
          onChanged: (int _) {},
        ),
      ));
      await tester.pump();
      expect(find.text('overview'), findsNothing);
      expect(find.text('Security'), findsOneWidget);
    });

    testWidgets('the active ink differs by variant', (WidgetTester tester) async {
      for (final (DsTabsVariant variant, bool onPrimary) in <(
        DsTabsVariant,
        bool
      )>[
        (DsTabsVariant.standard, true),
        (DsTabsVariant.line, false),
      ]) {
        await tester.pumpWidget(host(
          DsTabs(
            variant: variant,
            items: _liveTabs(),
            selectedIndex: 0,
            onChanged: (int _) {},
          ),
        ));
        await tester.pump();
        await tester.pump(DsDurations.transitionDefault);

        final DsThemeData theme = themeIn(tester, DsTabs);
        final DsText active = tester.widget<DsText>(
          find.ancestor(of: find.text('Live Pulls'), matching: find.byType(DsText))
              .first,
        );
        expect(
          active.color,
          onPrimary ? theme.primaryForeground : theme.foreground,
          reason: 'the filled pill carries white ink; the rule leaves the '
              'label on `--foreground`',
        );
        final DsText resting = tester.widget<DsText>(
          find.ancestor(of: find.text('My Pulls'), matching: find.byType(DsText))
              .first,
        );
        expect(resting.color, theme.mutedForeground);
      }
    });
  });

  /* ── Breadcrumb ────────────────────────────────────────────────────────── */

  group('DsBreadcrumb', () {
    test('the two spacings the list and its separator carry', () {
      // `gap-1.5` on the `ol`, `[&>svg]:size-3.5` on the separator
      // *(measured 6 and 14)*.
      expect(DsBreadcrumb.gap, 6);
      expect(DsBreadcrumb.separatorPx, 14);
    });

    testWidgets('a separator is derived between every pair, and nowhere else',
        (WidgetTester tester) async {
      await tester.pumpWidget(host(
        const DsBreadcrumb(
          items: <DsBreadcrumbEntry>[
            DsBreadcrumbEntry.link('Packs'),
            DsBreadcrumbEntry.link('Eclipse Vault'),
            DsBreadcrumbEntry.page('Origin Pulse — Series I'),
          ],
        ),
      ));
      await tester.pump();
      expect(
        tester
            .widgetList<DsIcon>(find.byType(DsIcon))
            .where((DsIcon i) => i.glyph == DsIconGlyph.chevronRight),
        hasLength(2),
      );

      await tester.pumpWidget(host(
        const DsBreadcrumb(
          items: <DsBreadcrumbEntry>[DsBreadcrumbEntry.page('Only')],
        ),
      ));
      await tester.pump();
      expect(find.byType(DsIcon), findsNothing);
    });

    testWidgets('the current page is `--foreground` and is not a link',
        (WidgetTester tester) async {
      int taps = 0;
      await tester.pumpWidget(host(
        DsBreadcrumb(
          items: <DsBreadcrumbEntry>[
            DsBreadcrumbEntry.link('Packs', onTap: () => taps++),
            const DsBreadcrumbEntry.page('Series I'),
          ],
        ),
      ));
      await tester.pump();
      final DsThemeData theme = themeIn(tester, DsBreadcrumb);

      final DsText page = tester.widget<DsText>(
        find.ancestor(of: find.text('Series I'), matching: find.byType(DsText))
            .first,
      );
      expect(page.color, theme.foreground);
      // `font-normal` on a `text-sm` list — 13px at the inherited 400.
      expect(page.spec, DsComponentType.textSm);

      final DsText link = tester.widget<DsText>(
        find.ancestor(of: find.text('Packs'), matching: find.byType(DsText))
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

    testWidgets('direction is context: the trail reverses under an RTL scope',
        (WidgetTester tester) async {
      const Widget trail = DsBreadcrumb(
        items: <DsBreadcrumbEntry>[
          DsBreadcrumbEntry.link('first'),
          DsBreadcrumbEntry.page('last'),
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

  group('DsPagination', () {
    test('the cells sit on `gap-0.5`, and the two ends break `px-4`', () {
      expect(DsPagination.gap, 2);
      // `pl-1.5!` / `pr-1.5!` against the `default` rung's own `px-4`
      // *(measured `padding: 0 16px 0 6px` on Previous)*.
      expect(DsPaginationStep.tightPadding, 6);
      expect(DsPaginationStep.loosePadding, 16);
      // `size-8` around a `size-4` glyph.
      expect(DsPaginationEllipsis.boxSize, 32);
      expect(DsPaginationEllipsis.glyphSize, 16);
    });

    testWidgets('the current page is `outline` and every other cell `ghost`',
        (WidgetTester tester) async {
      await tester.pumpWidget(host(
        const DsPagination(
          children: <Widget>[
            DsPaginationStep.previous(),
            DsPaginationLink(label: '1'),
            DsPaginationLink(label: '2', isActive: true),
            DsPaginationEllipsis(),
            DsPaginationStep.next(),
          ],
        ),
      ));
      await tester.pump();

      final List<DsButton> buttons =
          tester.widgetList<DsButton>(find.byType(DsButton)).toList();
      expect(buttons, hasLength(4));
      expect(
        buttons.map((DsButton b) => b.variant).toList(),
        <DsButtonVariant>[
          DsButtonVariant.ghost,
          DsButtonVariant.ghost,
          DsButtonVariant.outline,
          DsButtonVariant.ghost,
        ],
      );
      // Two squares and two word buttons.
      expect(
        buttons.map((DsButton b) => b.size).toList(),
        <DsButtonSize>[
          DsButtonSize.md,
          DsButtonSize.icon,
          DsButtonSize.icon,
          DsButtonSize.md,
        ],
      );
    });

    testWidgets('a numbered cell is a 40px square and the ellipsis a 32px one',
        (WidgetTester tester) async {
      await tester.pumpWidget(host(
        const DsPagination(
          children: <Widget>[
            DsPaginationLink(label: '2', isActive: true),
            DsPaginationEllipsis(),
          ],
        ),
      ));
      await tester.pump();
      expect(tester.getSize(find.byType(DsPaginationLink)), const Size(40, 40));
      expect(
        tester.getSize(find.byType(DsPaginationEllipsis)),
        const Size(32, 32),
      );
    });

    testWidgets('DRIFT — the numbers inherit the page\'s type, the words do '
        'not', (WidgetTester tester) async {
      // `size="icon"` is `size-10` and nothing else: no `text-*`, so the rung
      // answers null and the button merges only the ink *(measured
      // `16px/24px 500` on the squares against `13px/18.5714px 500` on the two
      // word buttons)*.
      expect(DsButton.typeFor(DsButtonSize.icon, DsButtonEmphasis.none), isNull);
      expect(
        DsButton.typeFor(DsButtonSize.md, DsButtonEmphasis.none),
        DsComponentType.buttonLabel,
      );
    });

    testWidgets('the chevron leads on Previous and trails on Next',
        (WidgetTester tester) async {
      await tester.pumpWidget(host(
        const DsPagination(
          children: <Widget>[
            DsPaginationStep.previous(),
            DsPaginationStep.next(),
          ],
        ),
      ));
      await tester.pump();
      expect(
        tester.getTopLeft(find.byType(DsIcon).first).dx <
            tester.getTopLeft(find.text('Previous')).dx,
        isTrue,
      );
      expect(
        tester.getTopLeft(find.byType(DsIcon).last).dx >
            tester.getTopLeft(find.text('Next')).dx,
        isTrue,
      );
    });
  });

  /* ── Navigation menu ───────────────────────────────────────────────────── */

  group('DsNavigationMenu', () {
    List<DsNavigationMenuItem> items() => <DsNavigationMenuItem>[
          const DsNavigationMenuItem.trigger(
            label: 'Packs',
            content: SizedBox(width: 200, height: 60, child: Text('packs')),
          ),
          const DsNavigationMenuItem.trigger(
            label: 'Marketplace',
            content: SizedBox(width: 200, height: 60, child: Text('market')),
          ),
          const DsNavigationMenuItem.link(label: 'Leaderboard'),
        ];

    test('the 40px pill on 16px clearance, and the panel\'s own 8 + 8', () {
      // *"The trigger is a 40px pill, not a 36px rounded rectangle."*
      expect(DsNavigationMenu.triggerHeight, 40);
      expect(DsNavigationMenu.triggerPaddingX, 16);
      expect(DsNavigationMenu.triggerGap, 6);
      expect(DsNavigationMenu.listGap, 4);
      // `mt-2` on the viewport and `p-2` inside it.
      expect(DsNavigationMenu.panelOffset, 8);
      expect(DsNavigationMenu.panelPadding, 8);
      // `h-2` around a `size-2` square — the same eight pixels the offset
      // spends, which is why a menu with an indicator does not pay both.
      expect(DsNavigationMenu.indicatorHeight, 8);
      expect(DsNavigationMenu.caretSize, 8);
      // `size="sm"` on the chevron.
      expect(DsNavigationMenu.chevronPx, 14);
    });

    test('`text-nav` is not `.type-nav`, and the difference is 4px of leading',
        () {
      // *(Measured: the trigger and its plain-link sibling read
      // `13.5px/20.25px 500`; the top-nav buttons three sections up, which wear
      // the `.type-nav` class, read `13.5px/16.2px 500`.)*
      expect(DsComponentType.navMenuTrigger.size, 13.5);
      expect(DsType.nav.size, 13.5);
      expect(DsComponentType.navMenuTrigger.height, 1.5);
      expect(DsType.nav.height, 1.2);
      expect(DsComponentType.navMenuTrigger.weight, DsType.nav.weight);
    });

    testWidgets('a tap opens the shared viewport and a second tap closes it',
        (WidgetTester tester) async {
      await tester.pumpWidget(overlayHost(DsNavigationMenu(items: items())));
      await tester.pump();
      expect(find.byType(DsPopoverSurface), findsNothing);

      await tester.tap(find.text('Packs'));
      await settleOverlay(tester);
      expect(find.byType(DsPopoverSurface), findsOneWidget);
      expect(find.text('packs'), findsOneWidget);

      await tester.tap(find.text('Packs'));
      await settleOverlay(tester);
      await tester.pump(DsDurations.overlay);
      await tester.pump();
      expect(find.text('packs'), findsNothing);
    });

    testWidgets('one panel at a time, and it swaps between triggers',
        (WidgetTester tester) async {
      await tester.pumpWidget(overlayHost(DsNavigationMenu(items: items())));
      await tester.pump();

      await tester.tap(find.text('Packs'));
      await settleOverlay(tester);
      expect(find.text('packs'), findsOneWidget);

      await tester.tap(find.text('Marketplace'));
      await settleOverlay(tester);
      expect(find.text('market'), findsOneWidget);
      expect(find.text('packs'), findsNothing);
      expect(find.byType(DsPopoverSurface), findsOneWidget);
    });

    testWidgets('the chevron rotates a half turn, on the spring',
        (WidgetTester tester) async {
      await tester.pumpWidget(overlayHost(DsNavigationMenu(items: items())));
      await tester.pump();

      double angleOf() => tester
          .widgetList<Transform>(find.byType(Transform))
          .map((Transform t) => t.transform.storage[1])
          .reduce((double a, double b) => a.abs() > b.abs() ? a : b);

      expect(angleOf().abs(), lessThan(0.01));

      await tester.tap(find.text('Packs'));
      await settleOverlay(tester);
      await tester.pump(DsDurations.transitionDefault);
      // sin(π) is 0 to the engine's precision, so the settled state is read
      // off the cosine instead: a half turn is −1.
      final double cos = tester
          .widgetList<Transform>(find.byType(Transform))
          .map((Transform t) => t.transform.storage[0])
          .reduce((double a, double b) => a < b ? a : b);
      expect(cos, closeTo(-1, 0.01));
    });

    testWidgets('a plain link is a trigger without a chevron',
        (WidgetTester tester) async {
      await tester.pumpWidget(overlayHost(DsNavigationMenu(items: items())));
      await tester.pump();
      // Two chevrons for three items.
      expect(
        tester
            .widgetList<DsIcon>(find.byType(DsIcon))
            .where((DsIcon i) => i.glyph == DsIconGlyph.chevronDown),
        hasLength(2),
      );
      // …and tapping it opens nothing.
      await tester.tap(find.text('Leaderboard'));
      await settleOverlay(tester);
      expect(find.byType(DsPopoverSurface), findsNothing);
    });

    testWidgets('DRIFT — the indicator takes the open trigger\'s width and '
        'stays at the list\'s leading edge', (WidgetTester tester) async {
      await tester.pumpWidget(overlayHost(
        DsNavigationMenu(indicator: true, items: items()),
      ));
      await tester.pump();

      final double listLeft = tester.getTopLeft(find.byType(Row).first).dx;

      await tester.tap(find.text('Packs'));
      await settleEntrance(tester);
      final Rect first = tester.getRect(find.byType(DsNavigationMenuIndicator));
      expect(first.height, DsNavigationMenu.indicatorHeight);
      expect(first.left, closeTo(listLeft, 0.5));

      await tester.tap(find.text('Marketplace'));
      await settleEntrance(tester);
      final Rect second = tester.getRect(find.byType(DsNavigationMenuIndicator));
      // The width follows the trigger…
      expect(second.width, greaterThan(first.width));
      // …and the position does not. Radix reads `offsetLeft`, and every
      // trigger's offset parent is its own `relative` list item.
      expect(second.left, closeTo(listLeft, 0.5));
    });

    testWidgets('an indicator spends the panel\'s own 8px rather than adding '
        'to them', (WidgetTester tester) async {
      for (final bool indicator in <bool>[false, true]) {
        await tester.pumpWidget(overlayHost(
          // Keyed per case: without it the second pump reuses the first
          // menu's State, whose panel is already open, and the tap below
          // closes it instead.
          DsNavigationMenu(
            key: ValueKey<bool>(indicator),
            indicator: indicator,
            items: items(),
          ),
        ));
        await tester.pump();
        await tester.tap(find.text('Packs'));
        await settleEntrance(tester);

        final double barBottom =
            tester.getRect(find.byType(DsNavigationMenu)).bottom;
        final double panelTop =
            tester.getRect(find.byType(DsPopoverSurface)).top;
        expect(panelTop - barBottom,
            closeTo(DsNavigationMenu.panelOffset, 0.5),
            reason: 'the panel is `mt-2` below the bar either way; with an '
                'indicator those eight pixels are the caret\'s clipping band');
      }
    });

    testWidgets('a panel link is muted at rest and `--accent` when current',
        (WidgetTester tester) async {
      await tester.pumpWidget(host(
        const Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            DsNavigationMenuLink(active: true, child: Text('Browse all')),
            DsNavigationMenuLink(child: Text('Trending')),
          ],
        ),
      ));
      await tester.pump();

      final DsThemeData theme = themeIn(tester, DsNavigationMenuLink);
      final List<BoxDecoration> fills = tester
          .widgetList<DecoratedBox>(find.descendant(
            of: find.byType(DsNavigationMenuLink),
            matching: find.byType(DecoratedBox),
          ))
          .map((DecoratedBox b) => b.decoration as BoxDecoration)
          .toList();
      expect(fills.first.color, theme.accent);
      expect(fills.last.color, dsTransparent);
      expect(fills.first.borderRadius, BorderRadius.circular(DsRadii.md));
      // `px-3 py-2 gap-2`.
      expect(DsNavigationMenuLink.paddingX, 12);
      expect(DsNavigationMenuLink.paddingY, 8);
      expect(DsNavigationMenuLink.gap, 8);
    });

    testWidgets('`viewport: false` anchors each panel to its own item',
        (WidgetTester tester) async {
      await tester.pumpWidget(overlayHost(
        DsNavigationMenu(viewport: false, items: items()),
      ));
      await tester.pump();

      await tester.tap(find.text('Marketplace'));
      await settleOverlay(tester);
      final double panelLeft =
          tester.getRect(find.byType(DsPopoverSurface)).left;
      final double itemLeft = tester.getTopLeft(find.text('Marketplace')).dx;
      final double barLeft = tester.getRect(find.byType(DsNavigationMenu)).left;
      // Its own item, not the bar: the second trigger's panel starts to the
      // right of the bar's own edge.
      expect(panelLeft, greaterThan(barLeft));
      expect(panelLeft, lessThan(itemLeft));
    });
  });

  /* ── Accordion ─────────────────────────────────────────────────────────── */

  group('DsAccordion', () {
    List<DsAccordionItem> items() => const <DsAccordionItem>[
          DsAccordionItem(title: 'odds', content: Text('rolled')),
          DsAccordionItem(title: 'sell', content: Text('sell-back')),
          DsAccordionItem(title: 'ship', content: Text('shipment')),
        ];

    test('`py-2.5` on the trigger and `pb-2.5` under the panel', () {
      expect(DsAccordion.triggerPaddingY, 10);
      expect(DsAccordion.contentPaddingBottom, 10);
      // `Icon`'s own `md` default, which is what renders — the `size-4` the
      // trigger declares through a dead variant agrees by accident.
      expect(DsAccordion.chevronPx, 16);
    });

    testWidgets('one open at a time, and the open one closes itself',
        (WidgetTester tester) async {
      int? open = 0;
      await tester.pumpWidget(host(
        StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) => DsAccordion(
            items: items(),
            openIndex: open,
            onChanged: (int? i) => setState(() => open = i),
          ),
        ),
      ));
      await tester.pump();
      expect(find.text('rolled'), findsOneWidget);

      await tester.tap(find.text('sell'));
      await tester.pump();
      await tester.pump(DsDurations.jelly);
      expect(open, 1);
      expect(find.text('sell-back'), findsOneWidget);
      expect(find.text('rolled'), findsNothing);

      // `collapsible`: the open item reports null rather than its own index.
      await tester.tap(find.text('sell'));
      await tester.pump();
      await tester.pump(DsDurations.jelly);
      expect(open, isNull);
      expect(find.text('sell-back'), findsNothing);
    });

    testWidgets('`not-last:border-b` — a seam under all but the last',
        (WidgetTester tester) async {
      await tester.pumpWidget(host(
        DsAccordion(items: items(), openIndex: null, onChanged: (int? _) {}),
      ));
      await tester.pump();
      final DsThemeData theme = themeIn(tester, DsAccordion);
      final Iterable<BoxDecoration> seams = tester
          .widgetList<Container>(find.byType(Container))
          .map((Container c) => c.decoration)
          .whereType<BoxDecoration>()
          .where((BoxDecoration d) => d.border is Border);
      expect(
        seams.where((BoxDecoration d) =>
            (d.border! as Border).bottom.color == theme.border),
        hasLength(2),
      );
    });

    testWidgets('the chevron is a swap, not a rotation',
        (WidgetTester tester) async {
      await tester.pumpWidget(host(
        DsAccordion(items: items(), openIndex: 1, onChanged: (int? _) {}),
      ));
      await tester.pump();
      final List<DsIconGlyph?> glyphs = tester
          .widgetList<DsIcon>(find.byType(DsIcon))
          .map((DsIcon i) => i.glyph)
          .toList();
      expect(glyphs.where((DsIconGlyph? g) => g == DsIconGlyph.chevronUp),
          hasLength(1));
      expect(glyphs.where((DsIconGlyph? g) => g == DsIconGlyph.chevronDown),
          hasLength(2));
      // Nothing on this control carries a rotation at all.
      expect(find.byType(RotationTransition), findsNothing);
    });

    testWidgets('DRIFT — the chevrons are `--foreground`, not muted',
        (WidgetTester tester) async {
      await tester.pumpWidget(host(
        DsAccordion(items: items(), openIndex: 0, onChanged: (int? _) {}),
      ));
      await tester.pump();
      // `**:data-[slot=accordion-trigger-icon]:text-muted-foreground` never
      // matches, because `Icon` does not forward `data-slot` — probed, the
      // selector returns zero elements.
      for (final DsIcon icon in tester.widgetList<DsIcon>(find.byType(DsIcon))) {
        expect(icon.tone, DsIconTone.normal);
      }
    });
  });

  /* ── Collapsible and the shared unfold ─────────────────────────────────── */

  group('DsUnfold — `anim-unfold` / `anim-fold`', () {
    testWidgets('a closed panel is not in the tree at all',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        host(const DsUnfold(open: false, child: Text('filters'))),
      );
      await tester.pump();
      expect(find.text('filters'), findsNothing);
      expect(tester.getSize(find.byType(DsUnfold)), Size.zero);
    });

    testWidgets('it opens on `--duration-jelly` and closes on `--duration-base`',
        (WidgetTester tester) async {
      bool open = false;
      late StateSetter set;
      await tester.pumpWidget(host(
        StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            set = setState;
            return SizedBox(
              width: 200,
              child: DsUnfold(
                open: open,
                child: const SizedBox(height: 100, child: Text('body')),
              ),
            );
          },
        ),
      ));
      await tester.pump();

      set(() => open = true);
      await tester.pump();
      // Halfway through `--duration-jelly` the spring is already past its
      // target, which is the overshoot `overflow-hidden` exists to contain.
      await tester.pump(DsDurations.jelly ~/ 2);
      final double mid = tester.getSize(find.byType(DsUnfold)).height;
      expect(mid, greaterThan(0));
      await tester.pump(DsDurations.jelly);
      expect(tester.getSize(find.byType(DsUnfold)).height, 100);

      set(() => open = false);
      await tester.pump();
      // The fold starts at `yuki-fold`'s own 0% — full height — rather than
      // reversing from wherever an interrupted unfold had reached, so the
      // first frame of a close is always the settled box.
      await tester.pump(const Duration(milliseconds: 1));
      expect(tester.getSize(find.byType(DsUnfold)).height, closeTo(100, 1));
      // `yuki-fold` runs `--duration-base`, not `--duration-jelly`.
      await tester.pump(DsDurations.base);
      await tester.pump();
      await tester.pump();
      expect(tester.getSize(find.byType(DsUnfold)).height, 0);
      expect(find.text('body'), findsNothing);
    });

    testWidgets('DsCollapsible stacks its trigger over the panel',
        (WidgetTester tester) async {
      bool open = false;
      await tester.pumpWidget(host(
        StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) =>
              SizedBox(
            width: 300,
            child: DsCollapsible(
              open: open,
              trigger: DsButton(
                variant: DsButtonVariant.outline,
                onPressed: () => setState(() => open = !open),
                child: const Text('Advanced filters'),
              ),
              content: const Text('Volatility'),
            ),
          ),
        ),
      ));
      await tester.pump();
      expect(find.text('Volatility'), findsNothing);

      await tester.tap(find.text('Advanced filters'));
      await tester.pump();
      await tester.pump(DsDurations.jelly);
      expect(find.text('Volatility'), findsOneWidget);
      expect(
        tester.getTopLeft(find.text('Volatility')).dy >
            tester.getTopLeft(find.text('Advanced filters')).dy,
        isTrue,
      );
    });
  });
}
