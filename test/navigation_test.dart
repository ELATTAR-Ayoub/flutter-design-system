import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:elattar_design_system/elattar_design_system.dart';
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
  ColorMode mode = ColorMode.dark,
  Size size = const Size(1440, 900),
  TextDirection direction = TextDirection.ltr,
}) {
  return MediaQuery(
    data: MediaQueryData(size: size),
    child: Directionality(
      textDirection: direction,
      child: ThemeScope(
        controller: ThemeController(mode: mode),
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
  ColorMode mode = ColorMode.dark,
  Size size = const Size(1440, 900),
  Alignment align = Alignment.topCenter,
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

ThemeTokens themeIn(WidgetTester t, Type of) =>
    ThemeScope.of(t.element(find.byType(of).first));

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
  await tester.pump(MotionDurations.overlayEnter);
  await tester.pump();
}

/// §3's first tab set.
List<TabItem> _liveTabs() => <TabItem>[
  const TabItem(label: 'Live Pulls', content: Text('live')),
  const TabItem(label: 'Top Hits', content: Text('hits')),
  const TabItem(label: 'My Pulls', content: Text('mine')),
];

void main() {
  group('the shared viewport follows the trigger that opened it', () {
    List<NavigationMenuItem> pair() => <NavigationMenuItem>[
      NavigationMenuItem.trigger(
        label: 'Products',
        content: const SizedBox(width: 120, height: 60),
      ),
      NavigationMenuItem.trigger(
        label: 'Company',
        content: const SizedBox(
          key: ValueKey<String>('company-panel'),
          width: 90,
          height: 60,
        ),
      ),
    ];

    Future<Rect> openSecond(
      WidgetTester tester,
      TextDirection direction,
    ) async {
      // `overlayHost` pins `TextDirection.ltr`, so the direction under test
      // has to be pushed *inside* it — an outer Directionality is shadowed
      // and the tree stays left-to-right, which quietly turns an RTL test
      // into a second LTR one.
      await tester.pumpWidget(
        overlayHost(
          Directionality(
            textDirection: direction,
            child: NavigationMenu(items: pair()),
          ),
        ),
      );
      await tester.pump();
      final TestGesture pointer = await tester.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      addTearDown(pointer.removePointer);
      await pointer.addPointer(
        location: tester.getCenter(find.text('Company')),
      );
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();
      return tester.getRect(
        find.byKey(const ValueKey<String>('company-panel')),
      );
    }

    testWidgets('left to right, the panel opens under the open trigger', (
      WidgetTester tester,
    ) async {
      final Rect panel = await openSecond(tester, TextDirection.ltr);
      final Rect trigger = tester.getRect(find.text('Company'));
      expect(
        panel.left,
        lessThanOrEqualTo(trigger.left + 1),
        reason:
            'the viewport was anchored to the whole row, so it opened under '
            'the first trigger no matter which one you hovered',
      );
      expect(panel.right, greaterThanOrEqualTo(trigger.left - 1));
    });

    testWidgets('right to left, it mirrors', (WidgetTester tester) async {
      final Rect panel = await openSecond(tester, TextDirection.rtl);
      final Rect trigger = tester.getRect(find.text('Company'));
      expect(
        panel.right,
        greaterThanOrEqualTo(trigger.right - 1),
        reason: 'PopoverAlign.start is physical, so RTL needs the far edge',
      );
      expect(panel.left, lessThanOrEqualTo(trigger.right + 1));
    });
  });
  /* ── Tabs ──────────────────────────────────────────────────────────────── */

  group('Tabs — the ladder §3 states in prose', () {
    test('40px track, 4px inset, 32px triggers on 16px padding', () {
      // The section's own trailing caption, asserted as numbers *(measured:
      // the track is 40 tall on `p-1`, the triggers 32 on `px-4`)*.
      expect(Tabs.trackHeight, 40);
      expect(Tabs.trackPadding, 4);
      expect(Tabs.triggerHeight, 32);
      expect(Tabs.triggerPaddingX, 16);
      // Stock shadcn's 32 / 3 / 25 is what the caption is arguing against.
      expect(Tabs.trackHeight, isNot(32));
    });

    test('the two variants gap differently', () {
      // `gap-1` on the filled track, `gap-2` on the bare one *(measured 4 and
      // 8)*.
      expect(Tabs.gapFor(TabsVariant.standard), 4);
      expect(Tabs.gapFor(TabsVariant.line), 8);
      // `h-0.5`.
      expect(Tabs.ruleHeight, 2);
      // `flex gap-2` between the track and the view.
      expect(Tabs.rootGap, 8);
    });

    testWidgets('the standard mark is a `--primary` pill under the label', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        host(Tabs(items: _liveTabs(), selectedIndex: 0, onChanged: (int _) {})),
      );
      await tester.pump();

      final ThemeTokens theme = themeIn(tester, Tabs);
      final Surface pill = tester.widget<Surface>(find.byType(Surface).first);
      expect(pill.fill, theme.primary);
      expect(pill.spec, Shadows.compactControl);
      // The pill is painted FIRST, so the label is never behind it — the
      // reference gets the same result from `z-10` on the trigger.
      expect(find.text('Live Pulls'), findsOneWidget);
    });

    testWidgets(
      'the line mark is a 2px `--action-ink` rule on the bottom edge',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          host(
            Tabs(
              variant: TabsVariant.line,
              items: _liveTabs(),
              selectedIndex: 0,
              onChanged: (int _) {},
            ),
          ),
        );
        await tester.pump();

        final ThemeTokens theme = themeIn(tester, Tabs);
        final Iterable<BoxDecoration> rules = tester
            .widgetList<DecoratedBox>(find.byType(DecoratedBox))
            .map((DecoratedBox b) => b.decoration as BoxDecoration)
            .where((BoxDecoration d) => d.color == theme.actionText);
        expect(rules, hasLength(1));
        expect(rules.first.borderRadius, BorderRadius.circular(Radii.full));
        // No filled pill anywhere in this variant.
        expect(
          tester
              .widgetList<Surface>(find.byType(Surface))
              .where((Surface s) => s.fill == theme.primary),
          isEmpty,
        );
      },
    );

    testWidgets('the squash pivots on the rule\'s own edge, and only there', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        host(
          Tabs(
            variant: TabsVariant.line,
            items: _liveTabs(),
            selectedIndex: 0,
            onChanged: (int _) {},
          ),
        ),
      );
      await tester.pump();
      expect(
        tester
            .widget<ActiveIndicator>(find.byType(ActiveIndicator))
            .jellyAlignment,
        Alignment.bottomCenter,
      );

      await tester.pumpWidget(
        host(Tabs(items: _liveTabs(), selectedIndex: 0, onChanged: (int _) {})),
      );
      await tester.pump();
      expect(
        tester
            .widget<ActiveIndicator>(find.byType(ActiveIndicator))
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
            builder: (BuildContext context, StateSetter setState) => Tabs(
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
          Tabs(
            items: const <TabItem>[
              TabItem(label: 'Overview', content: Text('overview')),
              TabItem(label: 'Security'),
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
      for (final (TabsVariant variant, bool onPrimary) in <(TabsVariant, bool)>[
        (TabsVariant.standard, true),
        (TabsVariant.line, false),
      ]) {
        await tester.pumpWidget(
          host(
            Tabs(
              variant: variant,
              items: _liveTabs(),
              selectedIndex: 0,
              onChanged: (int _) {},
            ),
          ),
        );
        await tester.pump();
        await tester.pump(MotionDurations.normal);

        final ThemeTokens theme = themeIn(tester, Tabs);
        final StyledText active = tester.widget<StyledText>(
          find
              .ancestor(
                of: find.text('Live Pulls'),
                matching: find.byType(StyledText),
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
        final StyledText resting = tester.widget<StyledText>(
          find
              .ancestor(
                of: find.text('My Pulls'),
                matching: find.byType(StyledText),
              )
              .first,
        );
        expect(resting.color, theme.mutedForeground);
      }
    });
  });

  /* ── Breadcrumb ────────────────────────────────────────────────────────── */

  group('Breadcrumb', () {
    test('the two spacings the list and its separator carry', () {
      // `gap-1.5` on the `ol`, `[&>svg]:size-3.5` on the separator
      // *(measured 6 and 14)*.
      expect(Breadcrumb.gap, 6);
      expect(Breadcrumb.separatorPx, 14);
    });

    testWidgets('a separator is derived between every pair, and nowhere else', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        host(
          const Breadcrumb(
            items: <BreadcrumbEntry>[
              BreadcrumbEntry.link('Packs'),
              BreadcrumbEntry.link('Eclipse Vault'),
              BreadcrumbEntry.page('Origin Pulse — Series I'),
            ],
          ),
        ),
      );
      await tester.pump();
      expect(
        tester
            .widgetList<Icon>(find.byType(Icon))
            .where((Icon i) => i.glyph == IconGlyph.chevronRight),
        hasLength(2),
      );

      await tester.pumpWidget(
        host(
          const Breadcrumb(
            items: <BreadcrumbEntry>[BreadcrumbEntry.page('Only')],
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(Icon), findsNothing);
    });

    testWidgets('the current page is `--foreground` and is not a link', (
      WidgetTester tester,
    ) async {
      int taps = 0;
      await tester.pumpWidget(
        host(
          Breadcrumb(
            items: <BreadcrumbEntry>[
              BreadcrumbEntry.link('Packs', onTap: () => taps++),
              const BreadcrumbEntry.page('Series I'),
            ],
          ),
        ),
      );
      await tester.pump();
      final ThemeTokens theme = themeIn(tester, Breadcrumb);

      final StyledText page = tester.widget<StyledText>(
        find
            .ancestor(
              of: find.text('Series I'),
              matching: find.byType(StyledText),
            )
            .first,
      );
      expect(page.color, theme.foreground);
      // `font-normal` on a `text-sm` list — 13px at the inherited 400.
      expect(page.spec, TextStyles.small);

      final StyledText link = tester.widget<StyledText>(
        find
            .ancestor(of: find.text('Packs'), matching: find.byType(StyledText))
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
      const Widget trail = Breadcrumb(
        items: <BreadcrumbEntry>[
          BreadcrumbEntry.link('first'),
          BreadcrumbEntry.page('last'),
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

  group('Pagination', () {
    test('the cells sit on `gap-0.5`, and the two ends break `px-4`', () {
      expect(Pagination.gap, 2);
      // `pl-1.5!` / `pr-1.5!` against the `default` rung's own `px-4`
      // *(measured `padding: 0 16px 0 6px` on Previous)*.
      expect(PaginationStep.tightPadding, 6);
      expect(PaginationStep.loosePadding, 16);
      // `size-8` around a `size-4` glyph.
      expect(PaginationEllipsis.boxSize, 32);
      expect(PaginationEllipsis.glyphSize, 16);
    });

    testWidgets('the current page is `outline` and every other cell `ghost`', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        host(
          const Pagination(
            children: <Widget>[
              PaginationStep.previous(),
              PaginationLink(label: '1'),
              PaginationLink(label: '2', isActive: true),
              PaginationEllipsis(),
              PaginationStep.next(),
            ],
          ),
        ),
      );
      await tester.pump();

      final List<Button> buttons = tester
          .widgetList<Button>(find.byType(Button))
          .toList();
      expect(buttons, hasLength(4));
      expect(buttons.map((Button b) => b.variant).toList(), <ButtonVariant>[
        ButtonVariant.ghost,
        ButtonVariant.ghost,
        ButtonVariant.outline,
        ButtonVariant.ghost,
      ]);
      // Two squares and two word buttons.
      expect(buttons.map((Button b) => b.size).toList(), <ButtonSize>[
        ButtonSize.md,
        ButtonSize.icon,
        ButtonSize.icon,
        ButtonSize.md,
      ]);
    });

    testWidgets(
      'a numbered cell is a 40px square and the ellipsis a 32px one',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          host(
            const Pagination(
              children: <Widget>[
                PaginationLink(label: '2', isActive: true),
                PaginationEllipsis(),
              ],
            ),
          ),
        );
        await tester.pump();
        expect(tester.getSize(find.byType(PaginationLink)), const Size(40, 40));
        expect(
          tester.getSize(find.byType(PaginationEllipsis)),
          const Size(32, 32),
        );
      },
    );

    testWidgets('DRIFT — the numbers inherit the page\'s type, the words do '
        'not', (WidgetTester tester) async {
      // A square rung owns no label type, so the button merges only its ink
      // into whatever the page is set in; a word rung states its own.
      expect(Button.typeFor(ButtonSize.icon, ButtonEmphasis.none), isNull);
      expect(
        Button.typeFor(ButtonSize.md, ButtonEmphasis.none)!.step,
        TextStyles.body.step,
      );
    });

    testWidgets('the chevron leads on Previous and trails on Next', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        host(
          const Pagination(
            children: <Widget>[
              PaginationStep.previous(),
              PaginationStep.next(),
            ],
          ),
        ),
      );
      await tester.pump();
      expect(
        tester.getTopLeft(find.byType(Icon).first).dx <
            tester.getTopLeft(find.text('Previous')).dx,
        isTrue,
      );
      expect(
        tester.getTopLeft(find.byType(Icon).last).dx >
            tester.getTopLeft(find.text('Next')).dx,
        isTrue,
      );
    });
  });

  /* ── Navigation menu ───────────────────────────────────────────────────── */

  group('NavigationMenu', () {
    List<NavigationMenuItem> items() => <NavigationMenuItem>[
      const NavigationMenuItem.trigger(
        label: 'Packs',
        content: SizedBox(width: 200, height: 60, child: Text('packs')),
      ),
      const NavigationMenuItem.trigger(
        label: 'Marketplace',
        content: SizedBox(width: 200, height: 60, child: Text('market')),
      ),
      const NavigationMenuItem.link(label: 'Leaderboard'),
    ];

    test('the 40px pill on 16px clearance, and the panel\'s own 8 + 8', () {
      // *"The trigger is a 40px pill, not a 36px rounded rectangle."*
      expect(NavigationMenu.triggerHeight, 40);
      expect(NavigationMenu.triggerPaddingX, 16);
      expect(NavigationMenu.triggerGap, 6);
      expect(NavigationMenu.listGap, 4);
      // `mt-2` on the viewport and `p-2` inside it.
      expect(NavigationMenu.panelOffset, 8);
      expect(NavigationMenu.panelPadding, 8);
      // `h-2` around a `size-2` square — the same eight pixels the offset
      // spends, which is why a menu with an indicator does not pay both.
      expect(NavigationMenu.indicatorHeight, 8);
      expect(NavigationMenu.caretSize, 8);
      // `size="sm"` on the chevron.
      expect(NavigationMenu.chevronPx, 14);
    });

    test('every navigation word is one role, at one size', () {
      // The retired catalog carried two spellings of a navigation label four
      // pixels of leading apart. A trigger, a plain link, and a panel title
      // now read identically.
      expect(TextStyles.nav.step, const TypeStep(16, 20));
      expect(TextStyles.nav.weight, FontWeight.w500);
      expect(TextStyles.nav.isStatic, isTrue);
    });

    testWidgets('a tap opens the shared viewport and a second tap closes it', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(overlayHost(NavigationMenu(items: items())));
      await tester.pump();
      expect(find.byType(PopoverSurface), findsNothing);

      await tester.tap(find.text('Packs'));
      await settleOverlay(tester);
      expect(find.byType(PopoverSurface), findsOneWidget);
      expect(find.text('packs'), findsOneWidget);

      await tester.tap(find.text('Packs'));
      await settleOverlay(tester);
      await tester.pump(MotionDurations.overlayEnter);
      await tester.pump();
      expect(find.text('packs'), findsNothing);
    });

    testWidgets('one panel at a time, and it swaps between triggers', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(overlayHost(NavigationMenu(items: items())));
      await tester.pump();

      await tester.tap(find.text('Packs'));
      await settleOverlay(tester);
      expect(find.text('packs'), findsOneWidget);

      await tester.tap(find.text('Marketplace'));
      await settleOverlay(tester);
      expect(find.text('market'), findsOneWidget);
      expect(find.text('packs'), findsNothing);
      expect(find.byType(PopoverSurface), findsOneWidget);
    });

    testWidgets('the chevron rotates a half turn, on the spring', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(overlayHost(NavigationMenu(items: items())));
      await tester.pump();

      double angleOf() => tester
          .widgetList<Transform>(find.byType(Transform))
          .map((Transform t) => t.transform.storage[1])
          .reduce((double a, double b) => a.abs() > b.abs() ? a : b);

      expect(angleOf().abs(), lessThan(0.01));

      await tester.tap(find.text('Packs'));
      await settleOverlay(tester);
      await tester.pump(MotionDurations.normal);
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
      await tester.pumpWidget(overlayHost(NavigationMenu(items: items())));
      await tester.pump();
      // Two chevrons for three items.
      expect(
        tester
            .widgetList<Icon>(find.byType(Icon))
            .where((Icon i) => i.glyph == IconGlyph.chevronDown),
        hasLength(2),
      );
      // …and tapping it opens nothing.
      await tester.tap(find.text('Leaderboard'));
      await settleOverlay(tester);
      expect(find.byType(PopoverSurface), findsNothing);
    });

    testWidgets('the indicator takes the open trigger\'s width and follows '
        'it', (WidgetTester tester) async {
      await tester.pumpWidget(
        overlayHost(NavigationMenu(indicator: true, items: items())),
      );
      await tester.pump();

      final double listLeft = tester.getTopLeft(find.byType(Row).first).dx;

      await tester.tap(find.text('Packs'));
      await settleEntrance(tester);
      final Rect first = tester.getRect(find.byType(NavigationMenuIndicator));
      expect(first.height, NavigationMenu.indicatorHeight);
      expect(first.left, closeTo(listLeft, 0.5));

      await tester.tap(find.text('Marketplace'));
      await settleEntrance(tester);
      final Rect second = tester.getRect(find.byType(NavigationMenuIndicator));
      // The width follows the trigger…
      expect(second.width, greaterThan(first.width));
      // …and so does the position now. Radix reads `offsetLeft` against
      // each trigger's own `relative` list item and leaves the caret at the
      // row's leading edge; this port does not reproduce that, because the
      // caret's whole job is to tie the open panel back to the trigger that
      // opened it, and a caret under the wrong trigger does the opposite.
      // See `_triggerRect` in navigation_menu.dart.
      expect(second.left, greaterThan(first.left));
    });

    testWidgets('an indicator spends the panel\'s own 8px rather than adding '
        'to them', (WidgetTester tester) async {
      for (final bool indicator in <bool>[false, true]) {
        await tester.pumpWidget(
          overlayHost(
            // Keyed per case: without it the second pump reuses the first
            // menu's State, whose panel is already open, and the tap below
            // closes it instead.
            NavigationMenu(
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
            .getRect(find.byType(NavigationMenu))
            .bottom;
        final double panelTop = tester.getRect(find.byType(PopoverSurface)).top;
        expect(
          panelTop - barBottom,
          closeTo(NavigationMenu.panelOffset, 0.5),
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
              NavigationMenuLink(active: true, child: Text('Browse all')),
              NavigationMenuLink(child: Text('Trending')),
            ],
          ),
        ),
      );
      await tester.pump();

      final ThemeTokens theme = themeIn(tester, NavigationMenuLink);
      final List<BoxDecoration> fills = tester
          .widgetList<DecoratedBox>(
            find.descendant(
              of: find.byType(NavigationMenuLink),
              matching: find.byType(DecoratedBox),
            ),
          )
          .map((DecoratedBox b) => b.decoration as BoxDecoration)
          .toList();
      expect(fills.first.color, theme.accent);
      expect(fills.last.color, transparent);
      expect(fills.first.borderRadius, BorderRadius.circular(Radii.md));
      // `px-3 py-2 gap-2`.
      expect(NavigationMenuLink.paddingX, 12);
      expect(NavigationMenuLink.paddingY, 8);
      expect(NavigationMenuLink.gap, 8);
    });

    testWidgets('`viewport: false` anchors each panel to its own item', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        overlayHost(NavigationMenu(viewport: false, items: items())),
      );
      await tester.pump();

      await tester.tap(find.text('Marketplace'));
      await settleOverlay(tester);
      final double panelLeft = tester.getRect(find.byType(PopoverSurface)).left;
      final double itemLeft = tester.getTopLeft(find.text('Marketplace')).dx;
      final double barLeft = tester.getRect(find.byType(NavigationMenu)).left;
      // Its own item, not the bar: the second trigger's panel starts to the
      // right of the bar's own edge.
      expect(panelLeft, greaterThan(barLeft));
      expect(panelLeft, lessThan(itemLeft));
    });
  });

  /* ── Accordion ─────────────────────────────────────────────────────────── */

  group('Accordion', () {
    List<AccordionItem> items() => const <AccordionItem>[
      AccordionItem(title: 'odds', content: Text('rolled')),
      AccordionItem(title: 'sell', content: Text('sell-back')),
      AccordionItem(title: 'ship', content: Text('shipment')),
    ];

    test('`py-2.5` on the trigger and `pb-2.5` under the panel', () {
      expect(Accordion.triggerPaddingY, 10);
      expect(Accordion.contentPaddingBottom, 10);
      // `Icon`'s own `md` default, which is what renders — the `size-4` the
      // trigger declares through a dead variant agrees by accident.
      expect(Accordion.chevronPx, 16);
    });

    testWidgets('one open at a time, and the open one closes itself', (
      WidgetTester tester,
    ) async {
      int? open = 0;
      await tester.pumpWidget(
        host(
          StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) => Accordion(
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
      await tester.pump(MotionDurations.open);
      expect(open, 1);
      expect(find.text('sell-back'), findsOneWidget);
      expect(find.text('rolled'), findsNothing);

      // `collapsible`: the open item reports null rather than its own index.
      await tester.tap(find.text('sell'));
      await tester.pump();
      await tester.pump(MotionDurations.open);
      expect(open, isNull);
      expect(find.text('sell-back'), findsNothing);
    });

    testWidgets('`not-last:border-b` — a seam under all but the last', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        host(
          Accordion(items: items(), openIndex: null, onChanged: (int? _) {}),
        ),
      );
      await tester.pump();
      final ThemeTokens theme = themeIn(tester, Accordion);
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
        host(Accordion(items: items(), openIndex: 1, onChanged: (int? _) {})),
      );
      await tester.pump();
      final List<IconGlyph?> glyphs = tester
          .widgetList<Icon>(find.byType(Icon))
          .map((Icon i) => i.glyph)
          .toList();
      expect(
        glyphs.where((IconGlyph? g) => g == IconGlyph.chevronUp),
        hasLength(1),
      );
      expect(
        glyphs.where((IconGlyph? g) => g == IconGlyph.chevronDown),
        hasLength(2),
      );
      // Nothing on this control carries a rotation at all.
      expect(find.byType(RotationTransition), findsNothing);
    });

    testWidgets('DRIFT — the chevrons are `--foreground`, not muted', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        host(Accordion(items: items(), openIndex: 0, onChanged: (int? _) {})),
      );
      await tester.pump();
      // `**:data-[slot=accordion-trigger-icon]:text-muted-foreground` never
      // matches, because `Icon` does not forward `data-slot` — probed, the
      // selector returns zero elements.
      for (final Icon icon in tester.widgetList<Icon>(find.byType(Icon))) {
        expect(icon.tone, IconTone.normal);
      }
    });
  });

  /* ── Collapsible and the shared unfold ─────────────────────────────────── */

  group('Unfold — `anim-unfold` / `anim-fold`', () {
    testWidgets('a closed panel is not in the tree at all', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        host(const Unfold(open: false, child: Text('filters'))),
      );
      await tester.pump();
      expect(find.text('filters'), findsNothing);
      expect(tester.getSize(find.byType(Unfold)), Size.zero);
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
                  child: Unfold(
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
        await tester.pump(MotionDurations.open ~/ 2);
        final double mid = tester.getSize(find.byType(Unfold)).height;
        expect(mid, greaterThan(0));
        await tester.pump(MotionDurations.open);
        expect(tester.getSize(find.byType(Unfold)).height, 100);

        set(() => open = false);
        await tester.pump();
        // The fold starts at `yuki-fold`'s own 0% — full height — rather than
        // reversing from wherever an interrupted unfold had reached, so the
        // first frame of a close is always the settled box.
        await tester.pump(const Duration(milliseconds: 1));
        expect(tester.getSize(find.byType(Unfold)).height, closeTo(100, 1));
        // `yuki-fold` runs `--duration-base`, not `--duration-jelly`.
        await tester.pump(MotionDurations.normal);
        await tester.pump();
        await tester.pump();
        expect(tester.getSize(find.byType(Unfold)).height, 0);
        expect(find.text('body'), findsNothing);
      },
    );

    testWidgets('Collapsible stacks its trigger over the panel', (
      WidgetTester tester,
    ) async {
      bool open = false;
      await tester.pumpWidget(
        host(
          StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) => SizedBox(
              width: 300,
              child: Collapsible(
                open: open,
                trigger: Button(
                  variant: ButtonVariant.outline,
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
      await tester.pump(MotionDurations.open);
      expect(find.text('Volatility'), findsOneWidget);
      expect(
        tester.getTopLeft(find.text('Volatility')).dy >
            tester.getTopLeft(find.text('Advanced filters')).dy,
        isTrue,
      );
    });
  });
}
