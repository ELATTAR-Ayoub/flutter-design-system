/// The system bars, driven through the two shells that meet them.
///
/// USER-ORDERED MOBILE ADAPTATION (2026-08-16). Screenshots showed [DocsShell]'s
/// header behind the phone's clock and the reading column behind the gesture
/// bar; the ruling, which [ElSafeArea]'s library note carries in full, is that
/// backgrounds keep painting edge-to-edge and content clears the bars. Both
/// halves are asserted here, because a fix that satisfies only the first is the
/// bug and a fix that satisfies only the second is a letterbox.
///
/// The insets are set on the **view**, not on a [MediaQuery] wrapper: [DocsApp]
/// mounts a [MaterialApp], and [MediaQueryData.fromView] takes its geometry from
/// the window rather than from any ancestor — a wrapper above it would be
/// overwritten one layer down and the test would be measuring nothing. See
/// `main.dart`'s own note.
///
/// The desktop group is the other half of the proof: with no bars the shell
/// renders the geometry it always did, which is why the suite's existing pins —
/// `shell_test`'s 240px rail, `vertical_parity_probe_test`'s 1080px column —
/// stay green untouched.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/logo.dart';
import 'package:example/main.dart';
import 'package:example/nav.dart';
import 'package:example/pages/sidebar_demo.dart';
import 'package:example/shell.dart';
import 'package:example/theme_toggle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// A portrait phone with a notched status bar and a gesture pill.
const Size _phone = Size(390, 844);
const double _statusBar = 47;
const double _gestureBar = 34;

/// Wide enough for the sidebar demo's panel to be a column rather than a sheet
/// (`ElSidebarProvider.isMobileWidth`), and still carrying both bars — a large
/// foldable, or a phone in landscape with the notch on top.
const Size _tablet = Size(900, 700);

/// The frame the port is verified at, where every inset is zero.
const Size _desktop = Size(1440, 900);
const Key _contentKey = ValueKey<String>('safe-area-content');

/// What a top bar occupies once it has paid the status bar.
const double _headerWithBar = ElWidths.siteHeader + _statusBar;

extension on WidgetTester {
  /// Sizes the viewport and, unless [bars] is false, tells the window it has a
  /// status bar and a gesture bar.
  ///
  /// `viewPadding` is set beside `padding` because that is what a real device
  /// reports: the two differ only while a keyboard is up, and nothing here
  /// raises one.
  void useViewport(Size size, {bool bars = true}) {
    view.devicePixelRatio = 1;
    view.physicalSize = size;
    if (bars) {
      const FakeViewPadding padding = FakeViewPadding(
        top: _statusBar,
        bottom: _gestureBar,
      );
      view.padding = padding;
      view.viewPadding = padding;
    }
    addTearDown(view.resetPhysicalSize);
    addTearDown(view.resetDevicePixelRatio);
    addTearDown(view.resetPadding);
    addTearDown(view.resetViewPadding);
  }

  /// `shell_test`'s own boot, plus the viewport this file is arguing about.
  Future<void> pumpApp(Size size, {bool bars = true}) async {
    useViewport(size, bars: bars);
    final ElThemeController theme = ElThemeController(mode: ElThemeMode.light);
    final AppRouter router = AppRouter(route: elRoot);
    addTearDown(theme.dispose);
    addTearDown(router.dispose);

    await pumpWidget(
      ElTheme(
        controller: theme,
        child: AppRouterScope(
          router: router,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: DocsShell(
              route: elRoot,
              child: SelectionArea(
                key: _contentKey,
                child: SizedBox(
                  height: 2000,
                  child: ElText('Safe area fixture', ElType.body),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await pump();
    await pump(ElDurations.slow);
  }

  /// The demo alone, under reduced motion — `sidebar_demo_test`'s harness, so
  /// the panel's three chained tweens are not measured mid-flight.
  Future<void> pumpDemo(Size size, {bool bars = true}) async {
    useViewport(size, bars: bars);
    final ElThemeController theme = ElThemeController(mode: ElThemeMode.light);
    final AppRouter router = AppRouter(route: sidebarDemoRoute);
    addTearDown(theme.dispose);
    addTearDown(router.dispose);

    await pumpWidget(
      ElTheme(
        controller: theme,
        child: AppRouterScope(
          router: router,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Builder(
              builder: (BuildContext context) => MediaQuery(
                data: MediaQuery.of(context).copyWith(disableAnimations: true),
                child: const SidebarDemoPage(),
              ),
            ),
          ),
        ),
      ),
    );
    await pump();
    await pump(ElDurations.slow);
  }

  /// The docs header's painted box — the blurred, washed, bottom-ruled band.
  Rect get headerBox => getRect(
    find.ancestor(of: find.byType(Logo), matching: find.byType(ClipRect)).last,
  );

  /// The reading column's scroll view — named by the page it carries, since
  /// above `lg` the rail is a second [ElThinScrollbar] beside it.
  SingleChildScrollView get readingColumn => widget<SingleChildScrollView>(
    find
        .ancestor(
          of: find.byKey(_contentKey),
          matching: find.byType(SingleChildScrollView),
        )
        .first,
  );
}

void main() {
  group('DocsShell on a phone', () {
    testWidgets('the header grows by the status bar and keeps painting under '
        'it', (WidgetTester tester) async {
      await tester.pumpApp(_phone);

      // The wash, the blur and the bottom rule still start at the top of the
      // screen — the status bar's own pixels have something to blur, which is
      // the whole reason the header is translucent.
      final Rect header = tester.headerBox;
      expect(header.top, 0);
      expect(header.left, 0);
      expect(header.width, _phone.width);
      // …and the band is 64px of header *below* the clock, not 64px total.
      expect(header.height, _headerWithBar);

      // The controls inside it cleared the bar.
      expect(
        tester.getTopLeft(find.byType(Logo)).dy,
        greaterThanOrEqualTo(_statusBar),
      );
      expect(
        tester.getTopLeft(find.byType(ThemeToggle)).dy,
        greaterThanOrEqualTo(_statusBar),
      );
    });

    testWidgets('the reading column starts below the header and ends above the '
        'gesture bar', (WidgetTester tester) async {
      await tester.pumpApp(_phone);

      // Top: the header's full occupied height, so the page scrolls under a
      // header that is taller here than it is on a desktop.
      // Bottom: the gesture bar, paid at the end of the content rather than as
      // a margin — the last section can still be dragged clear of it.
      expect(
        tester.readingColumn.padding,
        const EdgeInsets.only(top: _headerWithBar, bottom: _gestureBar),
      );

      // Spent, not merely declared: at rest the page's first pixel is below the
      // header rather than behind it.
      expect(
        tester.getTopLeft(find.byKey(_contentKey)).dy,
        greaterThanOrEqualTo(_headerWithBar),
      );
    });

    testWidgets('the glow still bleeds off every edge', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(_phone);

      // `background-attachment: fixed`, and the half of the ruling that says
      // what not to inset: the atmosphere is outside the frame's safe area and
      // fills the window, bars included.
      expect(
        tester.getRect(find.byType(ElPageGlow)),
        Rect.fromLTWH(0, 0, _phone.width, _phone.height),
      );
    });

    testWidgets('the burger clears the bar too, and the sheet it opens is '
        'reachable', (WidgetTester tester) async {
      await tester.pumpApp(_phone);

      final Finder burger = find.bySemanticsLabel(
        'Open design system navigation',
      );
      expect(tester.getTopLeft(burger).dy, greaterThanOrEqualTo(_statusBar));

      // The trigger is not merely drawn clear of the status bar, it is hittable
      // there — a control under a system bar takes no taps, which is the half
      // of this bug a screenshot cannot show.
      await tester.tap(burger);
      await tester.pumpAndSettle();
      expect(find.byType(NavTree), findsOneWidget);
    });
  });

  group('DocsShell on a desktop', () {
    testWidgets('renders the geometry it always did', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(_desktop, bars: false);

      // Every number here is the number from before this adaptation existed.
      // The pins in `shell_test` and `vertical_parity_probe_test` say the same
      // thing about the rail and the column; this says it about the two boxes
      // this file changed.
      final Rect header = tester.headerBox;
      expect(header.top, 0);
      expect(header.height, ElWidths.siteHeader);
      expect(
        tester.readingColumn.padding,
        const EdgeInsets.only(top: ElWidths.siteHeader),
      );
    });

    testWidgets('the rail still starts exactly under the header', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(_desktop, bars: false);

      final Finder rail = find.ancestor(
        of: find.byType(NavTree),
        matching: find.byType(SingleChildScrollView),
      );
      expect(tester.getTopLeft(rail).dy, ElWidths.siteHeader);
      // `sticky top-(--height-site-header)`: the rail owns the window from the
      // header's edge to the floor, and with no bars there is nothing else to
      // pay for.
      expect(tester.getRect(rail).bottom, _desktop.height);
    });
  });

  group('the sidebar demo — the one route that is the viewport', () {
    testWidgets('its own top bar pays the status bar', (
      WidgetTester tester,
    ) async {
      await tester.pumpDemo(_phone);

      final Rect bar = tester.getRect(
        find
            .ancestor(
              of: find.byType(ElSidebarTrigger),
              matching: find.byType(Container),
            )
            .first,
      );
      expect(bar.top, 0);
      expect(bar.height, _headerWithBar);
      expect(
        tester.getTopLeft(find.byType(ElSidebarTrigger)).dy,
        greaterThanOrEqualTo(_statusBar),
      );
    });

    testWidgets('its content column ends above the gesture bar', (
      WidgetTester tester,
    ) async {
      await tester.pumpDemo(_phone);

      final SingleChildScrollView scroller = tester.widget(
        find.descendant(
          of: find.byType(ElSidebarInset),
          matching: find.byType(SingleChildScrollView),
        ),
      );
      // `p-6` on all four sides, plus the bar on the one side that has one.
      expect(
        scroller.padding,
        EdgeInsets.fromLTRB(el(6), el(6), el(6), el(6) + _gestureBar),
      );
    });

    testWidgets('the panel fills the window while its rows clear both bars', (
      WidgetTester tester,
    ) async {
      await tester.pumpDemo(_tablet);

      // The panel is a column at this width, not a sheet, so its own fill is
      // what reaches the top and bottom of the screen…
      final Rect panel = tester.getRect(find.byType(ElSidebar));
      expect(panel.top, 0);
      expect(panel.bottom, _tablet.height);

      // …and the two rows at its ends are the ones that must not.
      expect(tester.getRect(find.byType(ElSidebarHeader)).top, _statusBar);
      expect(
        tester.getRect(find.byType(ElSidebarFooter)).bottom,
        _tablet.height - _gestureBar,
      );
    });

    testWidgets('and on a desktop the panel is flush with the window', (
      WidgetTester tester,
    ) async {
      await tester.pumpDemo(_desktop, bars: false);

      expect(tester.getRect(find.byType(ElSidebarHeader)).top, 0);
      expect(
        tester.getRect(find.byType(ElSidebarFooter)).bottom,
        _desktop.height,
      );
    });
  });
}
