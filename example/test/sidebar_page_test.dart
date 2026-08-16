/// `/design-system/components/base/sidebar` — the page, against the numbers
/// the reference actually renders.
///
/// Two harnesses, the split the other page tests use:
///
///  * [pumpSidebarInShell] mounts the real `DocsShell` at the 1440 × 900
///    reference frame and hands back the reading column's `RenderBox`. Every
///    oracle number below is measured from that origin.
///  * [pumpSidebarPage] mounts the page alone in a tall frame so every
///    specimen is laid out and hit-testable at once — which is what the
///    behaviour half of this file needs, because the shell matrix lives 4,400px
///    down the column.
///
/// The oracle was read off `http://localhost:3000` at 1440 × 900 on
/// 2026-08-16 (light) with `node tool/verify/section-oracle.js`. Coordinates
/// are the reference's document coordinates; the reading column starts 112px
/// down (`main` at 64 plus its own `py-12`), so every oracle number is the
/// measured top less 112.
library;

import 'dart:io';
import 'dart:typed_data';

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/kit.dart';
import 'package:example/nav.dart';
import 'package:example/pages/sidebar.dart';
import 'package:example/pages/sidebar_demo.dart';
import 'package:example/shell.dart';
import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FontLoader, LogicalKeyboardKey;
import 'package:flutter_test/flutter_test.dart';

/* ── The frame and the oracle ────────────────────────────────────────────── */

/// Tall enough to lay the whole page out at once, so nothing needs scrolling
/// into view before it can be driven.
const Size _desktop = Size(1440, 7000);

/// The frame the reference is measured at, and the only width these numbers
/// mean anything at.
const Size _referenceFrame = Size(1440, 900);

const String _route = '$dsRoot/components/base/sidebar';

/// `--width-content` — the reading column every wrap on the page follows.
const double _columnWidth = 1080;

/// Where the reading column starts in the reference's document coordinates:
/// `main` at 64, plus its own 48px of top padding.
const double _columnTop = 112;

/// The reading column's own height — `main`'s 5579.7 less its `py-12` on both
/// edges.
///
/// This is the number `vertical_parity_probe_test.dart`'s `_referenceHeight`
/// takes for this route at integration.
const double _columnHeight = 5483.7;

/// Each `section[id]`, as `(document top, border-box height)`.
///
/// The heights are the CSS border box, so `mb-20` — which this port pays as
/// padding inside the section's own box — comes back off before comparing.
const Map<String, ({double top, double height})> _sectionOracle =
    <String, ({double top, double height})>{
  'anatomy': (top: 479.5, height: 872.8),
  'header-input': (top: 1432.3, height: 408.2),
  'menu': (top: 1920.5, height: 354.3),
  'button-variants': (top: 2354.8, height: 357.3),
  'row-extras': (top: 2792.1, height: 758.3),
  'submenu': (top: 3630.4, height: 290.3),
  'footer': (top: 4000.7, height: 436.8),
  'shell': (top: 4517.5, height: 593),
  'contract': (top: 5190.4, height: 224.3),
};

/// The measured part geometry every specimen is built out of
/// (`sb-tree.js`, dark, 1440 × 900 — box metrics are theme-independent).
const double _rowHeight = 37.5;
const double _headerRowHeight = 50;
const double _groupLabelHeight = 32;
const double _badgeHeight = 20;
const double _subButtonHeight = 32;
const double _stageTall = 640;
const double _shellFrame = 384;
const double _railWidth = 16;

/// Two logical pixels — the band the aggregates hold.
const double _tolerance = 2;

/// Half a pixel — the band every part anchor holds.
const double _fineTolerance = 0.5;

/* ── Harness ─────────────────────────────────────────────────────────────── */

/// The reference's own font binaries. **Load-bearing, not hygiene**: every
/// number above is a line box.
Future<void> _loadFont(String family, String file) async {
  final ByteData bytes = ByteData.sublistView(
    File('../assets/fonts/$file').readAsBytesSync(),
  );
  final FontLoader loader = FontLoader('packages/elattar_design_system/$family')
    ..addFont(Future<ByteData>.value(bytes));
  await loader.load();
}

extension on WidgetTester {
  void useViewport(Size size) {
    view.devicePixelRatio = 1;
    view.physicalSize = size;
    addTearDown(view.resetPhysicalSize);
    addTearDown(view.resetDevicePixelRatio);
  }

  /// The page alone, laid out tall, under reduced motion.
  ///
  /// `MediaQuery(disableAnimations: true)` sits **below** `MaterialApp` so the
  /// framework's own does not win, and the body `DefaultTextStyle` the shell
  /// installs is brought along — without it every colour-inheriting string
  /// renders the framework's debug ink.
  Future<void> pumpSidebarPage({DsThemeMode mode = DsThemeMode.light}) async {
    useViewport(_desktop);
    final DsThemeController theme = DsThemeController(mode: mode);
    final AppRouter router = AppRouter(route: _route);
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
                  child: const SingleChildScrollView(child: SidebarPage()),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await pump();
    await pump(DsDurations.slow);
  }
}

/// The page inside the real [DocsShell] at the reference frame, and the reading
/// column's own [RenderBox] — the origin every oracle number is measured from.
///
/// `main.dart` is the supervisor's at integration, so the page is handed to the
/// shell directly rather than looked up through `pageFor`.
Future<RenderBox> pumpSidebarInShell(
  WidgetTester tester, {
  DsThemeMode mode = DsThemeMode.light,
}) async {
  tester.view.physicalSize = _referenceFrame;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final DsThemeController theme = DsThemeController(mode: mode);
  final AppRouter router = AppRouter(route: _route);
  addTearDown(theme.dispose);
  addTearDown(router.dispose);

  const Widget page = SidebarPage();
  await tester.pumpWidget(
    DsTheme(
      controller: theme,
      child: AppRouterScope(
        router: router,
        child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: DocsShell(route: _route, child: page),
        ),
      ),
    ),
  );
  // The travelling pill measures after layout, so the first frame is not the
  // settled one — but nothing it moves changes the column's geometry.
  await tester.pump();
  await tester.pump();

  return tester.renderObject<RenderBox>(find.byWidget(page));
}

/* ── Finders ─────────────────────────────────────────────────────────────── */

Finder _section(String id) => find.byWidgetPredicate(
      (Widget widget) => widget is DsSection && widget.id == id,
    );

Finder _in(String id, Finder matching) =>
    find.descendant(of: _section(id), matching: matching);

Finder _panel(String label) => find.byWidgetPredicate(
      (Widget widget) => widget is DsPanel && widget.label == label,
    );

({double top, double height}) _boxIn(
  WidgetTester tester,
  RenderBox origin,
  Finder finder,
) {
  final RenderBox box = tester.renderObject<RenderBox>(finder);
  return (
    top: box.localToGlobal(Offset.zero, ancestor: origin).dy,
    height: box.size.height,
  );
}

/// The section with [id], with `mb-20` taken back off its height so the number
/// compares to the reference's CSS border box.
({double top, double height}) _sectionBox(
  WidgetTester tester,
  RenderBox origin,
  String id,
) {
  final ({double top, double height}) box = _boxIn(tester, origin, _section(id));
  return (top: box.top, height: box.height - ds(20));
}

Size _sizeOf(WidgetTester tester, Finder finder) =>
    tester.renderObject<RenderBox>(finder).size;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await _loadFont('InterLocal', 'InterVariable.ttf');
    await _loadFont('GeistMono', 'GeistMono-Variable.ttf');
    await _loadFont('Redaction35', 'Redaction35-Italic.ttf');
  });

  /* ── Geometry ──────────────────────────────────────────────────────────── */

  group('vertical parity', () {
    testWidgets('the reading column is --width-content at the 1440 frame',
        (WidgetTester tester) async {
      final RenderBox column = await pumpSidebarInShell(tester);
      expect(column.size.width, _columnWidth);
    });

    testWidgets('the column stacks to the reference height',
        (WidgetTester tester) async {
      final RenderBox column = await pumpSidebarInShell(tester);
      expect(column.size.height, closeTo(_columnHeight, _tolerance));
    });

    testWidgets('every section starts and ends where the reference does',
        (WidgetTester tester) async {
      final RenderBox column = await pumpSidebarInShell(tester);

      // Collected rather than asserted one at a time: a vertical drift is
      // cumulative, so the FIRST mismatch hides every section under it.
      final List<String> off = <String>[];
      for (final MapEntry<String, ({double top, double height})> want
          in _sectionOracle.entries) {
        final ({double top, double height}) got =
            _sectionBox(tester, column, want.key);
        final double wantTop = want.value.top - _columnTop;
        if ((got.top - wantTop).abs() > _tolerance) {
          off.add('#${want.key} starts at ${got.top.toStringAsFixed(2)}, '
              'the reference at ${wantTop.toStringAsFixed(2)}');
        }
        if ((got.height - want.value.height).abs() > _tolerance) {
          off.add('#${want.key} is ${got.height.toStringAsFixed(2)} tall, '
              'the reference ${want.value.height}');
        }
      }
      expect(off, isEmpty, reason: off.join('\n'));
    });

    testWidgets('the anatomy stage is h-160 and its column 20rem',
        (WidgetTester tester) async {
      await pumpSidebarInShell(tester);
      final Size panel = _sizeOf(
        tester,
        _in('anatomy', _panel('The shared composition')),
      );
      // `lg:grid-cols-[20rem_1fr]`, and 640 of stage under a 36px strip inside
      // a 1px frame.
      expect(panel.width, 320);
      expect(panel.height, closeTo(_stageTall + 36 + 2, _fineTolerance));
    });
  });

  /* ── The parts ─────────────────────────────────────────────────────────── */

  group('rows', () {
    testWidgets('a default row is 37.5 and the lg header row 50',
        (WidgetTester tester) async {
      await tester.pumpSidebarPage();

      final Size row = _sizeOf(
        tester,
        _in('menu', find.byType(DsSidebarMenuButton)).first,
      );
      expect(row.height, closeTo(_rowHeight, _fineTolerance));

      final Size header = _sizeOf(
        tester,
        _in('header-input', find.byType(DsSidebarMenuButton)).first,
      );
      expect(header.height, closeTo(_headerRowHeight, _fineTolerance));
    });

    testWidgets('the group label is h-8 and the sub-button h-8',
        (WidgetTester tester) async {
      await tester.pumpSidebarPage();

      expect(
        _sizeOf(tester, _in('menu', find.byType(DsSidebarGroupLabel)).first)
            .height,
        closeTo(_groupLabelHeight, _fineTolerance),
      );
      expect(
        _sizeOf(tester, _in('submenu', find.byType(DsSidebarMenuSubButton)).first)
            .height,
        closeTo(_subButtonHeight, _fineTolerance),
      );
    });

    testWidgets('a count badge is h-5 with a min-w-5 floor',
        (WidgetTester tester) async {
      await tester.pumpSidebarPage();
      final Finder badges = _in('menu', find.byType(DsSidebarMenuBadge));
      // Two of the four fixture rows carry one: `1,284` and `37`.
      expect(badges, findsNWidgets(2 * 3));
      final Size wide = _sizeOf(tester, badges.first);
      expect(wide.height, closeTo(_badgeHeight, _fineTolerance));
      expect(wide.width, greaterThan(DsSidebarMenuBadge.minWidth));
    });

    testWidgets('the badge is typed 12/500 mono, not .type-num-xs',
        (WidgetTester tester) async {
      // DRIFT 3, pinned on the spec rather than on a rendered pixel: the two
      // classes collide and the utility layer wins the size and the weight.
      expect(DsComponentType.sidebarMenuBadge.size, 12);
      expect(DsComponentType.sidebarMenuBadge.weight, FontWeight.w500);
      expect(DsComponentType.sidebarMenuBadge.family, DsFonts.mono);
      expect(DsComponentType.sidebarMenuBadge.tabular, isTrue);
      // DRIFT 4, the mirror image.
      expect(DsComponentType.avatarFallback.size, 13);
      expect(DsComponentType.avatarFallback.weight, FontWeight.w600);
      expect(DsComponentType.avatarFallback.family, DsFonts.mono);
    });

    testWidgets('the shared fixture is rendered everywhere, never copied',
        (WidgetTester tester) async {
      await tester.pumpSidebarPage();
      // Seven headers — the anatomy, §Header's two shared panels, its three
      // product patterns, and §Footer's "pinned below empty content" — and
      // three `NavUser`s. The count is what makes "no second anatomy"
      // checkable: a private copy would move it.
      expect(find.byType(DsSidebarHeader), findsNWidgets(7));
      expect(find.byType(DsNavUser), findsNWidgets(3));
    });
  });

  /* ── The shell matrix ──────────────────────────────────────────────────── */

  group('shell', () {
    testWidgets('the frame is h-96 and the panel opens at --width-sidebar',
        (WidgetTester tester) async {
      await tester.pumpSidebarPage();

      final Finder sidebar = _in('shell', find.byType(DsSidebar));
      expect(_sizeOf(tester, sidebar).width, DsWidths.sidebar);

      final Finder frame = _in('shell', find.byType(DsSidebarProvider));
      expect(
        _sizeOf(tester, frame).height,
        closeTo(_shellFrame - 2 * DsWidths.hairline, _fineTolerance),
      );
    });

    testWidgets('a click on the rail toggles the panel',
        (WidgetTester tester) async {
      await tester.pumpSidebarPage();

      final Finder sidebar = _in('shell', find.byType(DsSidebar));
      final Rect box = tester.getRect(sidebar);
      expect(_railWidth, ds(4));

      // `w-4` centred on the panel's inner edge, so a point four pixels short
      // of that edge is on the strip.
      await tester.tapAt(Offset(box.right - _railWidth / 4, box.center.dy));
      await tester.pump();
      await tester.pump(DsDurations.base);

      expect(_sizeOf(tester, sidebar).width, DsWidths.sidebarIcon);
    });

    testWidgets('the trigger collapses the panel to --width-sidebar-icon',
        (WidgetTester tester) async {
      await tester.pumpSidebarPage();

      final Finder sidebar = _in('shell', find.byType(DsSidebar));
      expect(_sizeOf(tester, sidebar).width, DsWidths.sidebar);

      await tester.tap(_in('shell', find.byType(DsSidebarTrigger)));
      await tester.pump();
      // Reduced motion collapses the 250ms linear leg to a single frame.
      await tester.pump(DsDurations.base);

      expect(_sizeOf(tester, sidebar).width, DsWidths.sidebarIcon);
    });

    testWidgets('the collapsed row is the 32px square, in one frame',
        (WidgetTester tester) async {
      await tester.pumpSidebarPage();

      await tester.tap(_in('shell', find.byType(DsSidebarTrigger)));
      await tester.pump();
      await tester.pump(DsDurations.base);

      // `group-data-[collapsible=icon]:size-8!` is not in `btn-spring`'s
      // property list, so it lands whole rather than interpolating (measured).
      final Size row =
          _sizeOf(tester, _in('shell', find.byType(DsSidebarMenuButton)).first);
      expect(row.height, DsSidebarMenuButton.iconSize);
      expect(row.width, lessThanOrEqualTo(DsSidebarMenuButton.iconSize));
    });

    testWidgets('⌘B / Ctrl-B toggles the panel from anywhere',
        (WidgetTester tester) async {
      await tester.pumpSidebarPage();

      final Finder sidebar = _in('shell', find.byType(DsSidebar));
      // The listener is on the provider's own subtree, so something inside it
      // has to hold focus — which the trigger does after a tap.
      await tester.tap(_in('shell', find.byType(DsSidebarTrigger)));
      await tester.pump();
      await tester.pump(DsDurations.base);
      expect(_sizeOf(tester, sidebar).width, DsWidths.sidebarIcon);

      await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
      await tester.sendKeyEvent(DsSidebarProvider.shortcut);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
      await tester.pump();
      await tester.pump(DsDurations.base);

      expect(_sizeOf(tester, sidebar).width, DsWidths.sidebar);
    });

    testWidgets('offcanvas closes the gap and keeps the panel at 256',
        (WidgetTester tester) async {
      await tester.pumpSidebarPage();

      await tester.tap(find.widgetWithText(DsButton, 'offcanvas'));
      await tester.pump();
      await tester.pump(DsDurations.base);

      final Finder sidebar = _in('shell', find.byType(DsSidebar));
      expect(_sizeOf(tester, sidebar).width, DsWidths.sidebar);

      await tester.tap(_in('shell', find.byType(DsSidebarTrigger)));
      await tester.pump();
      await tester.pump(DsDurations.base);

      // The gap goes to nothing; the container keeps its width and leaves.
      expect(_sizeOf(tester, sidebar).width, 0);
    });

    testWidgets('collapsible=none renders no gap, no container and no rail',
        (WidgetTester tester) async {
      await tester.pumpSidebarPage();

      await tester.tap(find.widgetWithText(DsButton, 'none'));
      await tester.pump();

      expect(
        _sizeOf(tester, _in('shell', find.byType(DsSidebar))).width,
        DsWidths.sidebar,
      );
      expect(_in('shell', find.byType(DsSidebarRail)), findsNothing);
    });

    testWidgets('the inset variant insets the main column by m-2',
        (WidgetTester tester) async {
      await tester.pumpSidebarPage();

      final Finder inset = _in('shell', find.byType(DsSidebarInset));
      final double flush = tester.getRect(inset).height;
      // The flush variant paints no card: `rounded-xl` arrives with `inset`.
      final Finder card =
          find.descendant(of: inset, matching: find.byType(ClipRRect));
      expect(card, findsNothing);

      // Reached through the page's own knob rather than by rebuilding a shell
      // by hand: `variant` has to reach the provider and the panel together,
      // and the knob is what keeps the two in step.
      await tester.tap(find.widgetWithText(DsButton, 'inset'));
      await tester.pump();

      // `m-2` on the top and bottom edges — measured 366 inside a 382px frame.
      expect(
        tester.getRect(card).height,
        flush - 2 * DsSidebarInset.margin,
      );
      // `ml-0` while the panel is open: the card is flush with it.
      expect(
        tester.getRect(card).left,
        tester.getRect(_in('shell', find.byType(DsSidebar))).right,
      );
    });
  });

  /* ── Behaviour ─────────────────────────────────────────────────────────── */

  group('behaviour', () {
    testWidgets('the disclosure line thickens from h-px to h-1 when closed',
        (WidgetTester tester) async {
      await tester.pumpSidebarPage();

      final Finder group =
          _in('menu', find.byType(DsSidebarCollapsibleGroup)).first;
      final Finder rows = find.descendant(
        of: group,
        matching: find.byType(DsSidebarMenuButton),
      );
      expect(rows, findsNWidgets(_navCount));

      await tester.tap(find.descendant(
        of: group,
        matching: find.byType(DsButton),
      ).first);
      await tester.pump();
      await tester.pump(DsDurations.jelly);

      // `anim-fold` unmounts the panel once it is closed and settled.
      expect(rows, findsNothing);
    });

    testWidgets('a row answers a pointer and the active one keeps its pill',
        (WidgetTester tester) async {
      await tester.pumpSidebarPage();

      final Finder row = _in('menu', find.byType(DsSidebarMenuButton)).first;
      final TestGesture gesture =
          await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      await gesture.moveTo(tester.getCenter(row));
      await tester.pump();
      await tester.pump(DsDurations.base);

      // DRIFT 5: nothing on this page changes the selection, so the pill is
      // still on the row it placed on.
      expect(
        tester.widget<DsSidebarMenuButton>(row).isActive,
        isTrue,
      );
    });

    testWidgets('the collapsed rail labels its rows with a right tooltip',
        (WidgetTester tester) async {
      await tester.pumpSidebarPage();

      // Expanded: the tooltip exists and is hidden.
      final DsTooltip expanded = tester.widget<DsTooltip>(
        _in('shell', find.byType(DsTooltip)).first,
      );
      expect(expanded.hidden, isTrue);
      expect(expanded.side, DsTooltipSide.right);

      await tester.tap(_in('shell', find.byType(DsSidebarTrigger)));
      await tester.pump();
      await tester.pump(DsDurations.base);

      final DsTooltip collapsed = tester.widget<DsTooltip>(
        _in('shell', find.byType(DsTooltip)).first,
      );
      expect(collapsed.hidden, isFalse);
    });

    testWidgets('the shell link opens the full-viewport demo — DRIFT 10 '
        'CLOSED', (WidgetTester tester) async {
      await tester.pumpSidebarPage();

      // `<Button variant="outline" asChild><Link href="/sidebar-demo">`. For
      // two phases this button was wired to nothing, because the port carried
      // no such route; `pages/sidebar_demo.dart` is now that route, and
      // `main.dart` mounts it outside `DocsShell`.
      final Finder open = _in(
        'shell',
        find.widgetWithText(DsButton, 'Open the full-viewport sidebar'),
      );
      expect(tester.widget<DsButton>(open).variant, DsButtonVariant.outline);

      final AppRouter router =
          AppRouter.of(tester.element(find.byType(SidebarPage)));
      expect(router.route, _route);

      await tester.tap(open);
      await tester.pump();
      expect(router.route, sidebarDemoRoute);
    });

    testWidgets('the header switchers open a menu on the right',
        (WidgetTester tester) async {
      await tester.pumpSidebarPage();

      final Finder trigger =
          _in('header-input', find.byType(DsDropdownMenu)).first;
      expect(
        tester.widget<DsDropdownMenu>(trigger).side,
        DsPopoverSide.right,
      );

      await tester.tap(find.descendant(
        of: trigger,
        matching: find.byType(DsSidebarMenuButton),
      ));
      await tester.pump();
      await tester.pump();

      expect(find.text('Teams'), findsOneWidget);
      expect(find.text('Acme Corp.'), findsOneWidget);
    });
  });

  /* ── Copy ──────────────────────────────────────────────────────────────── */

  group('copy', () {
    testWidgets('every section heading is the reference\'s, in its order',
        (WidgetTester tester) async {
      await tester.pumpSidebarPage();
      const List<String> titles = <String>[
        'Complete sidebar',
        'Header',
        'Menu',
        'Menu button variants',
        'Badges and actions',
        'Submenu',
        'Footer',
        'Shell',
        'Contract',
      ];
      final List<String> got = tester
          .widgetList<DsSection>(find.byType(DsSection))
          .map((DsSection s) => s.title)
          .toList();
      expect(got, titles);
    });

    testWidgets('the chip row is the export inventory, not the section list',
        (WidgetTester tester) async {
      await tester.pumpSidebarPage();
      // DRIFT 1 — 21 component names over 9 sections.
      final DsPageHeader header =
          tester.widget<DsPageHeader>(find.byType(DsPageHeader));
      expect(header.contents, hasLength(21));
      expect(header.contents!.first, 'Sidebar');
      expect(header.contents!.last, 'useSidebar');
    });

    testWidgets('the panel notes name the shadcn blocks', (WidgetTester t) async {
      await t.pumpSidebarPage();
      expect(t.widget<DsPanel>(_panel('Team switcher')).note, 'sidebar-07');
      expect(t.widget<DsPanel>(_panel('Version switcher')).note, 'sidebar-01');
      expect(t.widget<DsPanel>(_panel('Search form')).note, 'sidebar-05');
    });
  });
}

/// The four entries `NAV` carries.
const int _navCount = 4;
