/// `/sidebar-demo` — the four things that need a viewport, driven.
///
/// This page has no oracle: `section-oracle.js` measures a docs route's
/// document height inside the reading column, and this route has neither a
/// reading column nor a document that scrolls. Its contract is behavioural, so
/// that is what is pinned here — it mounts at the size of the viewport, the
/// panel collapses and expands by trigger and by `⌘B`, the three structural
/// knobs remount it, and the back link routes home.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/nav.dart';
import 'package:example/pages/sidebar_demo.dart';
import 'package:example/shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter_test/flutter_test.dart';

/// The frame the port is verified at.
const Size _frame = Size(1440, 900);

/// Where the back link goes.
const String _sidebarRoute = '$dsRoot/components/base/sidebar';

extension on WidgetTester {
  void useViewport(Size size) {
    view.devicePixelRatio = 1;
    view.physicalSize = size;
    addTearDown(view.resetPhysicalSize);
    addTearDown(view.resetDevicePixelRatio);
  }

  /// The demo alone, at the reference frame, under reduced motion.
  ///
  /// Reduced motion matters more here than on a static page: the panel's width
  /// is three chained [TweenAnimationBuilder]s, so without it every assertion
  /// about 256 or 48 would be reading a frame mid-tween.
  Future<AppRouter> pumpDemo({Size size = _frame}) async {
    useViewport(size);
    final DsThemeController theme = DsThemeController(mode: DsThemeMode.light);
    final AppRouter router = AppRouter(route: sidebarDemoRoute);
    addTearDown(theme.dispose);
    addTearDown(router.dispose);

    await pumpWidget(
      DsTheme(
        controller: theme,
        child: AppRouterScope(
          router: router,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Builder(
              builder: (BuildContext context) => MediaQuery(
                data: MediaQuery.of(context).copyWith(disableAnimations: true),
                child: DefaultTextStyle(
                  style: DsText.styleOf(
                    context,
                    DsType.body,
                    color: DsTheme.of(context).foreground,
                  ),
                  child: const SidebarDemoPage(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await pump();
    await pump(DsDurations.slow);
    return router;
  }

  /// `⌘B` — meta down, `b`, meta up, which is what the provider's
  /// [HardwareKeyboard] handler reads.
  Future<void> pressToggleShortcut() async {
    await sendKeyDownEvent(LogicalKeyboardKey.metaLeft);
    await sendKeyEvent(LogicalKeyboardKey.keyB);
    await sendKeyUpEvent(LogicalKeyboardKey.metaLeft);
    await pump();
    await pump(DsDurations.slow);
  }

  /// Taps one of the shell knobs, scrolling it into view first — the settings
  /// card sits below the fold at 900px.
  Future<void> tapOption(String label) async {
    final Finder button = find.widgetWithText(DsButton, label);
    await ensureVisible(button);
    await pump();
    await tap(button);
    await pump();
    await pump(DsDurations.slow);
  }
}

/// The gap the panel occupies in the shell row — 256 expanded, 48 once the
/// icon rail has closed, 0 off-canvas.
double _gap(WidgetTester tester) =>
    tester.getSize(find.byType(DsSidebar)).width;

void main() {
  testWidgets('mounts at the size of the viewport, panel plus inset', (
    WidgetTester tester,
  ) async {
    await tester.pumpDemo();

    // `min-h-svh` on the provider, and a home widget that is handed the screen.
    expect(tester.getSize(find.byType(SidebarDemoPage)), _frame);
    // `w-(--sidebar-width)` — the panel takes 256 of the 1440…
    expect(_gap(tester), DsWidths.sidebar);
    // …and `SidebarInset` is `flex-1`, so it takes the rest, full height.
    expect(
      tester.getSize(find.byType(DsSidebarInset)),
      Size(_frame.width - DsWidths.sidebar, _frame.height),
    );
    // The header is `h-16 shrink-0` against a body that fills what is left.
    expect(
      tester.getSize(find.byType(DsSidebarTrigger)).height,
      lessThan(DsWidths.siteHeader),
    );
  });

  testWidgets('the whole anatomy is on screen: header, two groups, footer', (
    WidgetTester tester,
  ) async {
    await tester.pumpDemo();

    // `SidebarHeader` — the workspace row and the search field.
    expect(find.text('Lumen'), findsOneWidget);
    expect(find.text('12 members'), findsOneWidget);
    expect(find.byType(DsSidebarInput), findsOneWidget);

    // Two `SidebarCollapsibleGroup`s, separated.
    expect(find.text('Essentials'), findsOneWidget);
    expect(find.text('Explore'), findsOneWidget);
    expect(find.byType(DsSidebarSeparator), findsOneWidget);
    // …and the second one carries the `SidebarGroupAction`.
    expect(find.byType(DsSidebarGroupAction), findsOneWidget);

    // Every `NAV` and `EXPLORE` row.
    for (final String label in const <String>[
      'Overview',
      'Funnels',
      'Retention',
      'Revenue',
      'Users',
      'Dashboard',
      'Segments',
      'Reports',
    ]) {
      expect(find.text(label), findsOneWidget, reason: '$label row missing');
    }

    // Three counts — two in the menu, one in the footer.
    expect(find.byType(DsSidebarMenuBadge), findsNWidgets(3));
    expect(find.text(r'$24.8k'), findsOneWidget);

    // `SidebarFooter`, and the rail the shell settings default to.
    expect(find.byType(DsSidebarFooter), findsOneWidget);
    expect(find.text("What's new"), findsOneWidget);
    expect(find.text('Docs'), findsOneWidget);
    expect(find.byType(DsSidebarRail), findsOneWidget);

    // The inset's own header: the `⌘` `B` hint the readout tells you to press.
    expect(find.byType(DsKbd), findsNWidgets(2));
    expect(find.text('⌘'), findsOneWidget);
    expect(find.text('B'), findsOneWidget);
  });

  testWidgets('the trigger collapses the panel to the 48px rail and back', (
    WidgetTester tester,
  ) async {
    await tester.pumpDemo();
    expect(_gap(tester), DsWidths.sidebar);

    await tester.tap(find.byType(DsSidebarTrigger));
    await tester.pump();
    await tester.pump(DsDurations.slow);
    // `collapsible="icon"` is the page's default: the panel narrows, it does
    // not leave.
    expect(_gap(tester), DsWidths.sidebarIcon);
    // The labels go with it; the glyphs stay.
    expect(find.text('Overview'), findsNothing);
    expect(find.byType(DsSidebarInput), findsNothing);
    // And the inset grows into what the panel gave up.
    expect(
      tester.getSize(find.byType(DsSidebarInset)).width,
      _frame.width - DsWidths.sidebarIcon,
    );

    await tester.tap(find.byType(DsSidebarTrigger));
    await tester.pump();
    await tester.pump(DsDurations.slow);
    expect(_gap(tester), DsWidths.sidebar);
    expect(find.text('Overview'), findsOneWidget);
  });

  testWidgets('⌘B toggles it from anywhere, with nothing focused', (
    WidgetTester tester,
  ) async {
    await tester.pumpDemo();
    expect(_gap(tester), DsWidths.sidebar);

    // The provider listens on [HardwareKeyboard], not on a subtree `Focus` —
    // which is the whole point of a `window` listener, and the state focus is
    // actually in until something is tapped.
    await tester.pressToggleShortcut();
    expect(_gap(tester), DsWidths.sidebarIcon);

    await tester.pressToggleShortcut();
    expect(_gap(tester), DsWidths.sidebar);
  });

  testWidgets('the collapsible knob remounts the shell: none drops the rail, '
      'offcanvas closes the gap', (WidgetTester tester) async {
    await tester.pumpDemo();

    // `{collapsible !== "none" && <SidebarRail />}`.
    await tester.tapOption('none');
    expect(find.byType(DsSidebarRail), findsNothing);
    // `collapsible="none"` is a plain flex column: the trigger cannot narrow
    // it, and the width is the component's own 256.
    expect(tester.getSize(find.byType(DsSidebar)).width, DsWidths.sidebar);

    await tester.tapOption('offcanvas');
    expect(find.byType(DsSidebarRail), findsOneWidget);
    expect(_gap(tester), DsWidths.sidebar);

    await tester.tap(find.byType(DsSidebarTrigger));
    await tester.pump();
    await tester.pump(DsDurations.slow);
    // Off-canvas takes the gap to nothing — the panel leaves rather than
    // narrowing, so the inset is the whole frame.
    expect(_gap(tester), 0);
    expect(tester.getSize(find.byType(DsSidebarInset)).width, _frame.width);
  });

  testWidgets('the side and variant knobs both take, and remount the panel', (
    WidgetTester tester,
  ) async {
    await tester.pumpDemo();

    /// Which option a knob currently marks: the selected one is `default`, the
    /// rest are `outline`.
    DsButtonVariant knob(String label) =>
        tester.widget<DsButton>(find.widgetWithText(DsButton, label)).variant;

    expect(knob('left'), DsButtonVariant.primary);
    expect(knob('right'), DsButtonVariant.outline);

    await tester.tapOption('right');
    expect(knob('right'), DsButtonVariant.primary);
    expect(knob('left'), DsButtonVariant.outline);
    // *"The gap is still the first flex item — the container is what moves"*
    // (`test/sidebar_test.dart`), so what `side="right"` changes is which edge
    // of the gap the panel ends on.
    expect(
      tester.getRect(find.byType(DsSidebarContent)).right,
      closeTo(DsWidths.sidebar, 0.5),
    );

    await tester.tapOption('inset');
    expect(knob('inset'), DsButtonVariant.primary);
    // `variant="inset"` makes the **main** column the card, and its own `m-2`
    // is what pulls it off three edges of the frame.
    // `.first` — the inset's own rounded card is the outermost [ClipRRect] in
    // the subtree; every pill button inside it is another one.
    expect(
      tester
          .getRect(
            find
                .descendant(
                  of: find.byType(DsSidebarInset),
                  matching: find.byType(ClipRRect),
                )
                .first,
          )
          .height,
      _frame.height - 2 * DsSidebarInset.margin,
    );
  });

  testWidgets('the back link routes to the sidebar page', (
    WidgetTester tester,
  ) async {
    final AppRouter router = await tester.pumpDemo();
    expect(router.route, sidebarDemoRoute);

    final Finder back = find.widgetWithText(DsButton, 'Back to Sidebar');
    await tester.ensureVisible(back);
    await tester.pump();
    await tester.tap(back);
    await tester.pump();

    expect(router.route, _sidebarRoute);
  });

  testWidgets('the readout ships all four items, cookie copy included — '
      'DRIFT 1', (WidgetTester tester) async {
    await tester.pumpDemo();

    expect(find.text('The live sidebar'), findsOneWidget);
    expect(
      find.text(
        'Four things here need a viewport and cannot be shown in a boxed '
        'specimen.',
      ),
      findsOneWidget,
    );
    // Four numbered `Badge variant="outline"` markers, in order. Matched on
    // the variant rather than on the text: `2` and `3` are also menu counts,
    // and `SidebarMenuBadge` is a `Badge` too.
    expect(
      tester
          .widgetList<DsBadge>(
            find.byWidgetPredicate(
              (Widget w) =>
                  w is DsBadge && w.variant == DsBadgeVariant.outline,
            ),
          )
          .map((DsBadge badge) => badge.label)
          .toList(),
      <String>['1', '2', '3', '4'],
    );
    // Readout 4 describes a seven-day cookie the port does not write
    // (`sidebar.dart` drift 6). The copy ships as authored.
    expect(
      find.textContaining('written to a cookie for seven days',
          findRichText: true),
      findsOneWidget,
    );
  });
}
