/// `/design-system/components/base/menus` — the page, against the numbers the
/// reference actually renders.
///
/// Two harnesses, and the split is load-bearing:
///
///  * [pumpMenusInShell] mounts the real `DocsShell` at the 1440 × 900
///    reference frame and hands back the reading column's `RenderBox`. Every
///    oracle number below is measured from that origin, **pristine** — no menu
///    opened, nothing right-clicked — which is the state the reference was
///    measured in.
///  * [pumpMenusPage] mounts the page alone in a tall frame so every specimen
///    is laid out and hit-testable at once. All five of them answer a pointer,
///    and this file's job is to prove it.
///
/// The oracle was read off `http://localhost:3000` at 1440 × 900 on
/// 2026-08-16 with `node tool/verify/section-oracle.js
/// /design-system/components/base/menus`, and the specimen boxes with a
/// `getBoundingClientRect` sweep in the same session. Coordinates are the
/// reference's document coordinates; the reading column starts 112px down
/// (`main` at 64 plus its own `py-12`), so every oracle number here is the
/// measured top less 112.
library;

import 'dart:io';
import 'dart:typed_data';

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/kit.dart';
import 'package:example/nav.dart';
import 'package:example/pages/menus.dart';
import 'package:example/shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart' show PointerDeviceKind, kSecondaryButton;
import 'package:flutter/services.dart' show FontLoader, LogicalKeyboardKey;
import 'package:flutter_test/flutter_test.dart';

/* ── The frame and the oracle ────────────────────────────────────────────── */

/// The behaviour frame: tall enough to lay the whole page out at once, so
/// nothing needs scrolling into view before it can be tapped.
const Size _desktop = Size(1440, 3200);

/// The frame the reference is measured at, and the only width these numbers
/// mean anything at.
const Size _referenceFrame = Size(1440, 900);

const String _route = '$dsRoot/components/base/menus';

/// `--width-content` — the reading column every wrap on the page follows.
const double _columnWidth = 1080;

/// Where the reading column starts in the reference's document coordinates:
/// `main` at 64, plus its own 48px of top padding.
const double _columnTop = 112;

/// The reading column's own height — `main`'s 2704.22 less its `py-12` on both
/// edges.
///
/// This is the number `vertical_parity_probe_test.dart`'s `_referenceHeight`
/// takes for this route at integration.
const double _columnHeight = 2608.22;

/// Each `section[id]`, as `(document top, border-box height)`.
///
/// Measured pristine. The heights are the CSS border box, so `mb-20` — which
/// this port pays as padding inside the section's own box — comes back off
/// before comparing.
const Map<String, ({double top, double height})> _sectionOracle =
    <String, ({double top, double height})>{
  'dropdown': (top: 379.84, height: 445.3),
  'context': (top: 905.14, height: 383.8),
  'menubar': (top: 1368.94, height: 259.19),
  'api': (top: 1708.13, height: 274.8),
  'rules': (top: 2062.92, height: 476.3),
};

/// The specimens whose own box the reference reports, in document coordinates.
const Map<String, ({double top, double height, double width})> _specimenOracle =
    <String, ({double top, double height, double width})>{
  // `<Button variant="ghost" className="gap-2.5 px-2">` — 8 + 28 + 10 + 55.41
  // + 8, plus a 1px transparent border each side.
  'account-trigger': (top: 539.14, height: 40, width: 111.41),
  // The card: `h-40 max-w-xs`.
  'card': (top: 1064.44, height: 160, width: 320),
  // `flex h-8 … border p-1`, stretched to the panel body.
  'menubar': (top: 1531.63, height: 32, width: 1030),
};

/// The two outline triggers share a row, so only their shared top is pinned.
const double _optionTriggersTop = 720.64;

/// The panels, in document coordinates. Two in §1, one each in §2 and §3.
const List<({double top, double height})> _panelOracle =
    <({double top, double height})>[
  (top: 478.14, height: 165.5),
  (top: 659.64, height: 165.5),
  (top: 1003.44, height: 285.5),
  (top: 1467.23, height: 160.89),
];

/// Two logical pixels — the band the aggregates hold, where a different Skia
/// build's rounding has the most room to accumulate.
const double _tolerance = 2;

/// Half a pixel — the band every *anchor* holds.
const double _fineTolerance = 0.5;

/* ── Harness ─────────────────────────────────────────────────────────────── */

/// The reference's own font binaries.
///
/// **Load-bearing, not hygiene.** Every number above is a line box; without
/// these the engine measures a fallback face and this file becomes a structure
/// test.
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
  Future<void> pumpMenusPage({DsThemeMode mode = DsThemeMode.light}) async {
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
                  child: const SingleChildScrollView(child: MenusPage()),
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
Future<RenderBox> pumpMenusInShell(
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

  const Widget page = MenusPage();
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
  // No settle: geometry is settled on the first laid-out frame, and PRISTINE is
  // the state the oracle was measured in.
  await tester.pump();

  return tester.renderObject<RenderBox>(find.byWidget(page));
}

/// Opens (or closes) an overlay: one frame for the prop to flip, and one more
/// for the portal the frame boundary brings in.
Future<void> settleOverlay(WidgetTester tester) async {
  await tester.pump();
  await tester.pump();
}

/// A pointer that can hover, with a fresh id each time — two live mouse
/// pointers sharing a device trip `MouseTracker`'s add/remove assertion.
int _pointer = 200;

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

Color? _fillOf(WidgetTester tester, String label) {
  final Finder box = find
      .ancestor(of: find.text(label), matching: find.byType(DecoratedBox))
      .first;
  return (tester.widget<DecoratedBox>(box).decoration as BoxDecoration).color;
}

void main() {
  setUpAll(() async {
    await _loadFont('InterLocal', 'InterVariable.ttf');
    await _loadFont('GeistMono', 'GeistMono-Variable.ttf');
    await _loadFont('Redaction35', 'Redaction35-Italic.ttf');
  });

  /* ── Structure ─────────────────────────────────────────────────────────── */

  group('structure', () {
    testWidgets('the five sections exist, in the reference\'s order',
        (WidgetTester tester) async {
      await pumpMenusInShell(tester);
      for (final String id in _sectionOracle.keys) {
        expect(_section(id), findsOneWidget, reason: 'section #$id');
      }
      expect(find.byType(DsSection), findsNWidgets(_sectionOracle.length));
    });

    testWidgets('the header eyebrow says "Base" twice — DRIFT 1',
        (WidgetTester tester) async {
      await pumpMenusInShell(tester);
      final DsPageHeader header =
          tester.widget<DsPageHeader>(find.byType(DsPageHeader));
      expect(header.eyebrow, 'Base Components · Base');
      expect(header.title, 'Menus');
      expect(header.contents,
          <String>['Dropdown Menu', 'Context Menu', 'Menubar']);
    });

    testWidgets('the four panels carry the reference\'s captions',
        (WidgetTester tester) async {
      await pumpMenusInShell(tester);
      for (final String label in <String>[
        'Account dropdown',
        'Checkbox and radio items',
        'Right-click the card',
        'Admin menubar',
      ]) {
        expect(_panel(label), findsOneWidget, reason: label);
      }
      expect(
        tester.widget<DsPanel>(_panel('Admin menubar')).note,
        'Future admin surface',
      );
    });
  });

  /* ── Geometry ──────────────────────────────────────────────────────────── */

  group('geometry against the oracle', () {
    testWidgets('the reading column is 1080 wide and 2608.22 tall',
        (WidgetTester tester) async {
      final RenderBox column = await pumpMenusInShell(tester);
      expect(column.size.width, _columnWidth);
      expect(column.size.height, closeTo(_columnHeight, _tolerance));
    });

    testWidgets('every section lands where the reference puts it',
        (WidgetTester tester) async {
      final RenderBox column = await pumpMenusInShell(tester);
      _sectionOracle.forEach(
          (String id, ({double top, double height}) want) {
        final ({double top, double height}) got =
            _sectionBox(tester, column, id);
        expect(got.top, closeTo(want.top - _columnTop, _fineTolerance),
            reason: '#$id top');
        expect(got.height, closeTo(want.height, _tolerance),
            reason: '#$id height');
      });
    });

    testWidgets('the four panels land where the reference puts them',
        (WidgetTester tester) async {
      final RenderBox column = await pumpMenusInShell(tester);
      final List<Finder> panels = <Finder>[
        _panel('Account dropdown'),
        _panel('Checkbox and radio items'),
        _panel('Right-click the card'),
        _panel('Admin menubar'),
      ];
      for (int i = 0; i < panels.length; i++) {
        final ({double top, double height}) got =
            _boxIn(tester, column, panels[i]);
        expect(got.top, closeTo(_panelOracle[i].top - _columnTop, _tolerance),
            reason: 'panel $i top');
        expect(got.height, closeTo(_panelOracle[i].height, _tolerance),
            reason: 'panel $i height');
      }
    });

    testWidgets('the account trigger is 111.41 × 40', (WidgetTester t) async {
      // 8 (`px-2`) + 28 (`size-7`) + 10 (`gap-2.5`) + 55.41 (13px "voidwing")
      // + 8, plus the transparent 1px border on each side.
      final RenderBox column = await pumpMenusInShell(t);
      final ({double top, double height}) want = (
        top: _specimenOracle['account-trigger']!.top,
        height: _specimenOracle['account-trigger']!.height,
      );
      final Finder trigger = _in('dropdown', find.byType(DsButton)).first;
      final ({double top, double height}) got = _boxIn(t, column, trigger);
      expect(got.top, closeTo(want.top - _columnTop, _tolerance));
      expect(got.height, want.height);
      expect(
        t.renderObject<RenderBox>(trigger).size.width,
        closeTo(_specimenOracle['account-trigger']!.width, _tolerance),
      );
    });

    testWidgets('the Columns and Sort triggers share a row at 40 tall',
        (WidgetTester t) async {
      final RenderBox column = await pumpMenusInShell(t);
      final Finder buttons = _in('dropdown', find.byType(DsButton));
      // Three buttons in §1: the account trigger and these two.
      expect(buttons, findsNWidgets(3));
      for (int i = 1; i < 3; i++) {
        final ({double top, double height}) got =
            _boxIn(t, column, buttons.at(i));
        expect(got.top, closeTo(_optionTriggersTop - _columnTop, _tolerance),
            reason: 'trigger $i');
        expect(got.height, 40);
      }
    });

    testWidgets('the card is 320 × 160', (WidgetTester t) async {
      final RenderBox column = await pumpMenusInShell(t);
      final Finder card = _in('context', find.byType(DsContextMenu));
      final ({double top, double height}) got = _boxIn(t, column, card);
      expect(got.top, closeTo(_specimenOracle['card']!.top - _columnTop,
          _tolerance));
      expect(got.height, _specimenOracle['card']!.height);
      expect(t.renderObject<RenderBox>(card).size.width,
          _specimenOracle['card']!.width);
    });

    testWidgets('DRIFT 2 — the menubar is 32 tall and its triggers are too',
        (WidgetTester t) async {
      final RenderBox column = await pumpMenusInShell(t);
      final Finder bar = _in('menubar', find.byType(DsMenubar));
      final ({double top, double height}) got = _boxIn(t, column, bar);
      expect(got.top, closeTo(_specimenOracle['menubar']!.top - _columnTop,
          _tolerance));
      expect(got.height, _specimenOracle['menubar']!.height);
      // `flex` with no `w-fit` — the bar fills the panel body.
      expect(t.renderObject<RenderBox>(bar).size.width,
          closeTo(_specimenOracle['menubar']!.width, _tolerance));

      // The overflow itself: a 32px trigger inside a 32px bar with 4px of
      // padding is flush with the bar at both edges.
      final Rect barRect = t.getRect(bar);
      final Rect trigger = t.getRect(find
          .ancestor(of: find.text('Packs'), matching: find.byType(DecoratedBox))
          .first);
      expect(trigger.height, 32);
      expect(trigger.top, closeTo(barRect.top, _fineTolerance));
      expect(trigger.left - barRect.left, closeTo(5, _fineTolerance));
    });
  });

  /* ── Behaviour ─────────────────────────────────────────────────────────── */

  group('every specimen is live', () {
    testWidgets('the account menu opens with the reference\'s rows',
        (WidgetTester t) async {
      await t.pumpMenusPage();
      await t.tap(_in('dropdown', find.byType(DsButton)).first);
      await settleOverlay(t);

      // Scoped: "Wallet" is also a menubar trigger three sections down.
      expect(
        find.descendant(
          of: find.byType(DsMenuContent),
          matching: find.text('Wallet'),
        ),
        findsOneWidget,
      );
      expect(find.text(r'$1,204.80'), findsOneWidget);
      expect(find.text('Favourites'), findsOneWidget);
      expect(find.text('Preferences'), findsOneWidget);
      expect(find.text('Sign out'), findsOneWidget);
      // `.type-micro` carries `text-transform: uppercase`, and this port
      // applies the transform at paint the way CSS does — so the rendered
      // string is the shouted one while the source stays as authored.
      expect(find.text('VERIFIED · RANK 24'), findsOneWidget);

      // `w-60`, and 8 + 48 (a two-line label) + 17 + 3×34.5625 + 17 + 34.5625
      // + 8 = 236.25.
      final Rect content = t.getRect(find.byType(DsMenuContent));
      expect(content.width, ds(60));
      expect(content.height, closeTo(236.25, _tolerance));
    });

    testWidgets('the destructive row is last, under a rule, in destructive ink',
        (WidgetTester t) async {
      await t.pumpMenusPage();
      await t.tap(_in('dropdown', find.byType(DsButton)).first);
      await settleOverlay(t);

      final DsThemeData theme =
          DsTheme.of(t.element(find.byType(DsMenuContent)));
      final DsText label = t.widget<DsText>(find.byWidgetPredicate(
        (Widget w) => w is DsText && w.text == 'Sign out',
      ));
      expect(label.color, theme.destructiveInk);
      // Below every other row.
      expect(
        t.getCenter(find.text('Sign out')).dy,
        greaterThan(t.getCenter(find.text('Preferences')).dy),
      );
    });

    testWidgets('the Columns menu opens two ticked rows and two bare ones',
        (WidgetTester t) async {
      await t.pumpMenusPage();
      await t.tap(_in('dropdown', find.byType(DsButton)).at(1));
      await settleOverlay(t);

      expect(find.text('Visible columns'), findsOneWidget);
      for (final String row in <String>[
        'Rarity',
        'Value',
        'Condition',
        'Acquired',
      ]) {
        expect(find.text(row), findsOneWidget, reason: row);
      }
      // DRIFT 6's other half: two ticks, and clicking never moves them.
      expect(
        find.descendant(
          of: find.byType(DsMenuContent),
          matching: find.byWidgetPredicate(
              (Widget w) => w is DsIcon && w.glyph == DsIconGlyph.check),
        ),
        findsNWidgets(2),
      );
      // `w-52`, and 8 + 32 + 17 + 4×34.5625 + 8 = 203.25.
      final Rect content = t.getRect(find.byType(DsMenuContent));
      expect(content.width, ds(52));
      expect(content.height, closeTo(203.25, _tolerance));
    });

    testWidgets('the Sort menu opens one ticked radio row',
        (WidgetTester t) async {
      await t.pumpMenusPage();
      await t.tap(_in('dropdown', find.byType(DsButton)).at(2));
      await settleOverlay(t);

      expect(find.text('Sort cards by'), findsOneWidget);
      expect(find.text('Highest value'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(DsMenuContent),
          matching: find.byWidgetPredicate(
              (Widget w) => w is DsIcon && w.glyph == DsIconGlyph.check),
        ),
        findsOneWidget,
      );
      // 8 + 32 + 17 + 3×34.5625 + 8 = 168.69.
      expect(t.getRect(find.byType(DsMenuContent)).height,
          closeTo(168.6875, _tolerance));
    });

    testWidgets('the card answers a right click and not a left one',
        (WidgetTester t) async {
      await t.pumpMenusPage();
      final Finder card = _in('context', find.byType(DsContextMenu));

      await t.tap(card);
      await settleOverlay(t);
      expect(find.text('Favourite'), findsNothing,
          reason: 'a left click opens nothing');

      await t.tapAt(t.getCenter(card), buttons: kSecondaryButton);
      await settleOverlay(t);
      expect(find.text('Favourite'), findsOneWidget);
      expect(find.text('F'), findsOneWidget);
      expect(find.text('Share pull'), findsOneWidget);
      expect(find.text('Shipping'), findsOneWidget);
      expect(find.text(r'Sell for $1,240.00'), findsOneWidget);

      // `w-56`, and 8 + 3×34.5625 + 17 + 34.5625 + 8 = 171.25.
      final Rect content = t.getRect(find.byType(DsMenuContent));
      expect(content.width, ds(56));
      expect(content.height, closeTo(171.25, _tolerance));
      // Opened at the pointer + (2, 0).
      expect(content.left - t.getCenter(card).dx, closeTo(2, _fineTolerance));
    });

    testWidgets('the Shipping row grows a submenu one level deep',
        (WidgetTester t) async {
      await t.pumpMenusPage();
      final Finder card = _in('context', find.byType(DsContextMenu));
      await t.tapAt(t.getCenter(card), buttons: kSecondaryButton);
      await settleOverlay(t);

      await hover(t, find.text('Shipping'));
      // Radix's own 100ms timer.
      await t.pump(const Duration(milliseconds: 120));
      await settleOverlay(t);
      expect(find.text('Add to shipment'), findsOneWidget);
      expect(find.text('Ship immediately'), findsOneWidget);
      // Two contents, and no third: one level only.
      expect(find.byType(DsMenuContent), findsNWidgets(2));

      // DRIFT 4 — 8 + 2×34.5625 + 8, plus the 1px border on each side.
      expect(t.getRect(find.byType(DsMenuContent).last).height,
          closeTo(87.125, _tolerance));
    });

    testWidgets('the menubar hands one open menu between three triggers',
        (WidgetTester t) async {
      await t.pumpMenusPage();
      await t.tap(find.text('Packs'));
      await settleOverlay(t);
      expect(find.text('New pack'), findsOneWidget);
      expect(find.text('⌘N'), findsOneWidget);
      // `min-w-36` beats a 128.45 intrinsic; 8 + 2×34.5625 + 17 + 34.5625 + 8.
      final Rect content = t.getRect(find.byType(DsMenuContent));
      expect(content.width, closeTo(144, _tolerance));
      expect(content.height, closeTo(136.6875, _tolerance));

      // One pointer, moved twice: two live mouse gestures share a device id
      // and `MouseTracker` asserts on the second add.
      final TestGesture pointer = await hover(t, find.text('Users'));
      await settleOverlay(t);
      expect(find.text('New pack'), findsNothing);
      expect(find.text('Search users'), findsOneWidget);

      await pointer.moveTo(t.getCenter(_in('menubar', find.text('Wallet'))));
      await t.pump();
      await settleOverlay(t);
      expect(find.text('Withdrawal approvals'), findsOneWidget);
    });

    testWidgets('a menu row highlights on hover and commits on a tap',
        (WidgetTester t) async {
      await t.pumpMenusPage();
      await t.tap(_in('dropdown', find.byType(DsButton)).first);
      await settleOverlay(t);

      final DsThemeData theme =
          DsTheme.of(t.element(find.byType(DsMenuContent)));
      expect(_fillOf(t, 'Favourites'), isNull);
      await hover(t, find.text('Favourites'));
      expect(_fillOf(t, 'Favourites'), theme.accent);

      await t.tap(find.text('Favourites'));
      await settleOverlay(t);
      await t.pump(DsDurations.overlay);
      expect(find.text('Favourites'), findsNothing);
    });

    testWidgets('the keyboard walks the account menu without wrapping',
        (WidgetTester t) async {
      await t.pumpMenusPage();
      await t.tap(_in('dropdown', find.byType(DsButton)).first);
      await settleOverlay(t);

      final DsThemeData theme =
          DsTheme.of(t.element(find.byType(DsMenuContent)));
      await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await t.pump();
      expect(_fillOf(t, 'Wallet'), theme.accent);

      await t.sendKeyEvent(LogicalKeyboardKey.end);
      await t.pump();
      await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await t.pump();
      // The destructive row keeps the highlight — no loop.
      expect(_fillOf(t, 'Wallet'), isNull);
    });
  });

  /* ── Copy ──────────────────────────────────────────────────────────────── */

  group('copy', () {
    testWidgets('the API list names all five props', (WidgetTester t) async {
      await pumpMenusInShell(t);
      final DsMeta meta = t.widget<DsMeta>(_in('api', find.byType(DsMeta)));
      expect(meta.items.map((DsMetaItem i) => i.k).toList(), <String>[
        'DropdownMenuItem variant',
        'DropdownMenuShortcut',
        'DropdownMenuCheckboxItem',
        'DropdownMenuRadioGroup',
        'ContextMenuSub',
      ]);
    });

    testWidgets('the Rules section ships four dos, four don\'ts and two notes',
        (WidgetTester t) async {
      await pumpMenusInShell(t);
      final DsDoDont rules =
          t.widget<DsDoDont>(_in('rules', find.byType(DsDoDont)));
      expect(rules.dos, hasLength(4));
      expect(rules.donts, hasLength(4));
      expect(rules.dos.first,
          'Put destructive items last, separated from everything above them.');
      expect(rules.donts.last,
          "Don't put Sign out next to Preferences without a separator.");
      expect(_in('rules', find.byType(DsNote)), findsNWidgets(2));
      expect(
        t.widget<DsNote>(_in('rules', find.byType(DsNote)).at(1)).title,
        'Geometry, and why it drifts',
      );
    });

    testWidgets('the three captions are the reference\'s',
        (WidgetTester t) async {
      await pumpMenusInShell(t);
      expect(
        find.textContaining('The balance rides in the shortcut slot'),
        findsOneWidget,
      );
      expect(
        find.textContaining('Checkbox items for independent toggles'),
        findsOneWidget,
      );
      expect(
        find.textContaining('Submenus are allowed one level deep'),
        findsOneWidget,
      );
      expect(
        find.textContaining('absorb the admin panel later'),
        findsOneWidget,
      );
    });
  });

  /* ── Both themes ───────────────────────────────────────────────────────── */

  testWidgets('the dark theme lays out identically', (WidgetTester t) async {
    final RenderBox column = await pumpMenusInShell(t, mode: DsThemeMode.dark);
    expect(column.size.height, closeTo(_columnHeight, _tolerance));
    _sectionOracle.forEach((String id, ({double top, double height}) want) {
      expect(_sectionBox(t, column, id).top,
          closeTo(want.top - _columnTop, _fineTolerance),
          reason: '#$id top');
    });
  });
}
