/// `/design-system/components/agent/console` — the page, against the numbers
/// the reference actually renders.
///
/// Two harnesses, and the split is the one `selects_page_test.dart` established:
///
///  * [pumpConsoleInShell] mounts the real `DocsShell` at the 1440 × 900
///    reference frame and hands back the reading column's [RenderBox]. Every
///    oracle number is measured from that origin, **pristine** — nothing typed,
///    no chip opened, no launcher clicked, which is the state the reference was
///    measured in.
///  * [pumpConsolePage] mounts the page alone in a tall frame so every specimen
///    is laid out and hit-testable at once. The page's own thesis is that
///    nothing on it is a screenshot, and this half is where that is proved.
///
/// Coordinates are the reference's document coordinates; the reading column
/// starts 112px down (`main` at 64 plus its own `py-12`), so every oracle
/// number below is the measured top less 112.
///
/// ## The consoles are boxed, and that is what makes this test cheap
///
/// `h-152` (608), `h-80` (320) and `h-56` (224) are explicit heights on the
/// three specimens, so the transcript, the composer and the welcome card cannot
/// move the document however they lay out. What the section pins actually
/// measure is the kit — `DsSection`'s heading block, `DsPanel`'s chrome,
/// `DsMeta`'s ten rows and two paragraphs — plus those three constants.
library;

import 'dart:io';
import 'dart:typed_data';

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/kit.dart';
import 'package:example/nav.dart';
import 'package:example/pages/console.dart';
import 'package:example/shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FontLoader;
import 'package:flutter_test/flutter_test.dart';

/* ── The frame and the oracle ────────────────────────────────────────────── */

/// Tall enough to lay the whole page out at once, so nothing needs scrolling
/// into view before it can be tapped.
const Size _desktop = Size(1440, 4000);

/// The frame the reference is measured at, and the only width these numbers
/// mean anything at.
const Size _referenceFrame = Size(1440, 900);

const String _route = '$dsRoot/components/agent/console';

/// Where the reading column starts in the reference's document coordinates:
/// `main` at 64, plus its own 48px of top padding.
const double _columnTop = 112;

/// The reading column's own height — `main`'s 3140.97 less its `py-12` on both
/// edges. This is the number `vertical_parity_probe_test.dart` takes for this
/// route at integration.
const double _columnHeight = 3044.97;

/// The document the reference reports: the 64px site header plus `main`.
const double _documentHeight = 3204.97;

/// Each `section[id]`, as `(document top, border-box height)`.
///
/// Measured pristine at 1440×900, light, by `tool/verify/section-oracle.js`.
/// The heights are the CSS border box, so `mb-20` — which this port pays as
/// padding inside the section's own box — is already in them.
const Map<String, ({double top, double height})> _sectionOracle =
    <String, ({double top, double height})>{
  'live': (top: 555.9, height: 708.3),
  'transport': (top: 1344.2, height: 607.3),
  'features': (top: 2031.5, height: 459.7),
  'launcher': (top: 2571.2, height: 404.8),
};

/// The three explicit specimen heights, which the sections are built out of.
const double _liveConsoleHeight = 608;
const double _minimalConsoleHeight = 320;
const double _launcherPanelHeight = 224;

/// Two logical pixels — the band the aggregates hold, where a different Skia
/// build's rounding has the most room to accumulate.
const double _tolerance = 2;

/// Half a pixel — the band every anchor holds.
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
  Future<void> pumpConsolePage({DsThemeMode mode = DsThemeMode.light}) async {
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
                  child: const SingleChildScrollView(child: ConsolePage()),
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
/// The page is handed to the shell directly rather than looked up through
/// `pageFor`: `main.dart` is the supervisor's at integration.
Future<RenderBox> pumpConsoleInShell(
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

  const Widget page = ConsolePage();
  await tester.pumpWidget(
    DsTheme(
      controller: theme,
      child: AppRouterScope(
        router: router,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          // Reduced motion, for the same reason every other page harness sets
          // it: the welcome card's `anim-row-in` chips schedule a real delay
          // per row and the cube avatar runs a ticker forever, and neither
          // moves a single pixel of layout. Stilled they hold their **final**
          // stop — `both` fill — which is the state the oracle was read in.
          home: Builder(
            builder: (BuildContext context) => MediaQuery(
              data: MediaQuery.of(context).copyWith(disableAnimations: true),
              child: const DocsShell(route: _route, child: page),
            ),
          ),
        ),
      ),
    ),
  );
  // No settle: geometry is settled on the first laid-out frame, and PRISTINE is
  // the state the oracle was measured in. The welcome card's entrance keyframes
  // and the cube's ticker are loopers; pumping them out is exactly what a
  // `pumpAndSettle` must never do here.
  await tester.pump();

  return tester.renderObject<RenderBox>(find.byWidget(page));
}

/* ── Finders ─────────────────────────────────────────────────────────────── */

Finder _section(String id) => find.byWidgetPredicate(
      (Widget widget) => widget is DsSection && widget.id == id,
    );

/// A section's `(top, height)` in the reading column's coordinates.
({double top, double height}) _sectionBox(WidgetTester tester, String id,
    RenderBox column) {
  final RenderBox box = tester.renderObject<RenderBox>(_section(id));
  final Offset origin = box.localToGlobal(Offset.zero, ancestor: column);
  return (top: origin.dy, height: box.size.height);
}

void main() {
  setUpAll(() async {
    await _loadFont('InterLocal', 'InterVariable.ttf');
    await _loadFont('GeistMono', 'GeistMono-Variable.ttf');
    await _loadFont('Redaction35', 'Redaction35-Italic.ttf');
  });

  /* ── Geometry ──────────────────────────────────────────────────────────── */

  group('vertical parity', () {
    testWidgets('every section lands on its measured top and height',
        (WidgetTester tester) async {
      final RenderBox column = await pumpConsoleInShell(tester);

      for (final MapEntry<String, ({double top, double height})> entry
          in _sectionOracle.entries) {
        final ({double top, double height}) actual =
            _sectionBox(tester, entry.key, column);
        expect(
          actual.top,
          closeTo(entry.value.top - _columnTop, _fineTolerance),
          reason: '${entry.key} top',
        );
        expect(
          // `mb-20` is a margin on the reference and padding inside the
          // section's own box here, so it comes back off before comparing.
          actual.height - ds(20),
          closeTo(entry.value.height, _tolerance),
          reason: '${entry.key} height',
        );
      }
    });

    testWidgets('the reading column is the measured height',
        (WidgetTester tester) async {
      final RenderBox column = await pumpConsoleInShell(tester);
      expect(column.size.height, closeTo(_columnHeight, _tolerance));
    });

    testWidgets('the document is the measured height',
        (WidgetTester tester) async {
      final RenderBox column = await pumpConsoleInShell(tester);
      // `main`'s `py-12` on both edges, plus the 64px site header.
      expect(
        column.size.height + ds(12) * 2 + DsWidths.siteHeader,
        closeTo(_documentHeight, _tolerance),
      );
    });

    testWidgets('the reading column is --width-content wide',
        (WidgetTester tester) async {
      final RenderBox column = await pumpConsoleInShell(tester);
      expect(column.size.width, closeTo(1080, _fineTolerance));
    });
  });

  /* ── The three boxed specimens ─────────────────────────────────────────── */

  group('the specimens are boxed', () {
    testWidgets('h-152, h-80 and h-56 are the heights that ship',
        (WidgetTester tester) async {
      await tester.pumpConsolePage();

      expect(
        tester.getSize(find.byType(LiveConsole)).height,
        closeTo(_liveConsoleHeight, _fineTolerance),
      );
      expect(
        tester.getSize(find.byType(MinimalConsole)).height,
        closeTo(_minimalConsoleHeight, _fineTolerance),
      );
      expect(
        tester.getSize(find.byType(LauncherDemo)).height,
        closeTo(_launcherPanelHeight, _fineTolerance),
      );
    });

    testWidgets('the live console carries a header and the minimal one does not',
        (WidgetTester tester) async {
      await tester.pumpConsolePage();

      // `features.avatar` is the flag, and the status line is what it brings.
      expect(
        find.descendant(
          of: find.byType(LiveConsole),
          matching: find.byType(DsAgentStatusLine),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byType(MinimalConsole),
          matching: find.byType(DsAgentStatusLine),
        ),
        findsNothing,
      );
    });

    testWidgets('the header is what the avatar flag brings, not the name',
        (WidgetTester tester) async {
      await tester.pumpConsolePage();
      // Both consoles carry the same persona, and both welcome cards print its
      // name. Only the live one *also* prints it in a header, so the count is
      // the flag: two against one.
      expect(
        find.descendant(
          of: find.byType(LiveConsole),
          matching: find.text('Vault'),
        ),
        findsNWidgets(2),
      );
      expect(
        find.descendant(
          of: find.byType(MinimalConsole),
          matching: find.text('Vault'),
        ),
        findsOneWidget,
      );
    });
  });

  /* ── The page's own copy ───────────────────────────────────────────────── */

  group('copy', () {
    testWidgets('the header carries the registry\'s six chips, in its order',
        (WidgetTester tester) async {
      await tester.pumpConsolePage();
      // DRIFT 2 and 3: six chips, a different order from the page's four
      // sections, and two with nothing behind them.
      final DsCategoryHit here = findCategory('agent', 'console');
      expect(here.category.contents, <String>[
        'Live console',
        'The four seams',
        'Feature flags',
        'Personas',
        'Launcher',
        'Transport contract',
      ]);
      for (final String chip in here.category.contents) {
        // `Feature flags` and `Launcher` are chips *and* section titles, which
        // is drift 2 seen from the other side — a chip that names a section is
        // the only kind that works.
        expect(find.text(chip), findsWidgets, reason: chip);
      }
    });

    testWidgets('the note titles itself "This is running"',
        (WidgetTester tester) async {
      await tester.pumpConsolePage();
      // `.type-label` carries `text-transform: uppercase`, and `DsText`
      // applies it at paint rather than to the source — so the string is
      // authored in sentence case and rendered in caps.
      expect(find.text('THIS IS RUNNING'), findsOneWidget);
    });

    testWidgets('the four section titles ship verbatim',
        (WidgetTester tester) async {
      await tester.pumpConsolePage();
      for (final String title in <String>[
        'The console',
        'The transport contract',
      ]) {
        expect(find.text(title), findsOneWidget, reason: title);
      }
      // …and these two are also chips in the header (drift 2).
      for (final String title in <String>['Feature flags', 'Launcher']) {
        expect(find.text(title), findsNWidgets(2), reason: title);
      }
    });

    testWidgets('the transport contract lists all ten members',
        (WidgetTester tester) async {
      await tester.pumpConsolePage();
      for (final String key in <String>[
        'turns',
        'send',
        'abort',
        'reset',
        'isLoading',
        'isReady',
        'error',
        'pendingApprovals',
        'capabilities',
        // DRIFT 6 — documented, never called.
        'restore?',
      ]) {
        expect(find.text(key), findsOneWidget, reason: key);
      }
    });

    testWidgets('the welcome card shows three skills, not four',
        (WidgetTester tester) async {
      await tester.pumpConsolePage();
      // DRIFT 5 — `MAX_CAPABILITIES` is four; `COMMANDS` holds three skills and
      // one command, and only skills are chips.
      final Finder card = find.descendant(
        of: find.byType(LiveConsole),
        matching: find.byType(DsWelcomeCard),
      );
      expect(card, findsOneWidget);
      for (final String skill in <String>['inventory', 'wallet', 'export']) {
        expect(
          find.descendant(of: card, matching: find.text(skill)),
          findsOneWidget,
          reason: skill,
        );
      }
      expect(
        find.descendant(of: card, matching: find.text('guide')),
        findsNothing,
      );
    });

    testWidgets('all four starter prompts are on the welcome card',
        (WidgetTester tester) async {
      await tester.pumpConsolePage();
      for (final String suggestion in kVaultPersona.suggestions) {
        expect(
          find.descendant(
            of: find.byType(LiveConsole),
            matching: find.text(suggestion),
          ),
          findsOneWidget,
          reason: suggestion,
        );
      }
      // `features.suggestions: false` on the minimal console.
      expect(
        find.descendant(
          of: find.byType(MinimalConsole),
          matching: find.text(kVaultPersona.suggestions.first),
        ),
        findsNothing,
      );
    });
  });

  /* ── Nothing here is a screenshot ──────────────────────────────────────── */

  group('the specimens are live', () {
    testWidgets('a starter prompt sends, streams and settles',
        (WidgetTester tester) async {
      await tester.pumpConsolePage();

      await tester.tap(
        find.descendant(
          of: find.byType(LiveConsole),
          matching: find.text('What sealed boxes are left?'),
        ),
      );
      await tester.pump();

      // The user's own turn lands before the transport has said anything.
      expect(
        find.descendant(
          of: find.byType(LiveConsole),
          matching: find.byType(DsUserMessage),
        ),
        findsOneWidget,
      );

      // `THINK_MS` (420) of latency, then the first `say` streams at
      // `CHAR_MS * CHUNK` = 36ms a chunk. Pumped past the whole default script:
      // 420 + 20 chunks + a 900ms tool + the closing paragraph.
      await tester.pump(const Duration(milliseconds: 500));
      for (int i = 0; i < 60; i += 1) {
        await tester.pump(const Duration(milliseconds: 40));
      }
      await tester.pump(const Duration(milliseconds: 1000));
      for (int i = 0; i < 90; i += 1) {
        await tester.pump(const Duration(milliseconds: 40));
      }

      // The tool chip is the evidence the script ran rather than an echo.
      expect(
        find.descendant(
          of: find.byType(LiveConsole),
          matching: find.byType(DsToolChip),
        ),
        findsOneWidget,
      );
      // `search_inventory` maps to `searching`, so the chip says so.
      expect(
        find.descendant(
          of: find.byType(LiveConsole),
          matching: find.text(DsAgentState.searching.label),
        ),
        findsOneWidget,
      );
      // And the welcome card is gone, because the conversation is not empty.
      expect(
        find.descendant(
          of: find.byType(LiveConsole),
          matching: find.byType(DsWelcomeCard),
        ),
        findsNothing,
      );
    });

    testWidgets('asking to buy stops at an approval card',
        (WidgetTester tester) async {
      await tester.pumpConsolePage();

      await tester.tap(
        find.descendant(
          of: find.byType(LiveConsole),
          matching: find.text('Buy me an Eclipse Vault pack'),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      for (int i = 0; i < 120; i += 1) {
        await tester.pump(const Duration(milliseconds: 40));
      }
      await tester.pump(const Duration(milliseconds: 800));
      for (int i = 0; i < 120; i += 1) {
        await tester.pump(const Duration(milliseconds: 40));
      }

      expect(find.byType(DsApprovalCard), findsOneWidget);
      expect(find.text('NEEDS YOUR APPROVAL'), findsOneWidget);
      // `describeApproval` writes the sentence, and it quotes a real price.
      expect(
        find.text(
          'Buy Eclipse Vault — 1st Edition for \$129.00. This spends real '
          'money and cannot be undone.',
        ),
        findsOneWidget,
      );
      expect(find.text('Approve'), findsOneWidget);
      expect(find.text('Decline'), findsOneWidget);
    });

    testWidgets('asking about a price fails, on purpose',
        (WidgetTester tester) async {
      await tester.pumpConsolePage();

      await tester.tap(
        find.descendant(
          of: find.byType(LiveConsole),
          matching: find.text('What is Eclipse Vault worth right now?'),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      for (int i = 0; i < 60; i += 1) {
        await tester.pump(const Duration(milliseconds: 40));
      }
      await tester.pump(const Duration(milliseconds: 900));
      await tester.pump();

      expect(
        find.text('The pricing service did not respond in time.'),
        findsOneWidget,
      );
    });

    testWidgets('the export prompt hands back a produced file',
        (WidgetTester tester) async {
      await tester.pumpConsolePage();

      await tester.tap(
        find.descendant(
          of: find.byType(LiveConsole),
          matching: find.text('Export my last 30 days'),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      for (int i = 0; i < 40; i += 1) {
        await tester.pump(const Duration(milliseconds: 40));
      }
      await tester.pump(const Duration(milliseconds: 1300));
      for (int i = 0; i < 90; i += 1) {
        await tester.pump(const Duration(milliseconds: 40));
      }

      expect(find.text('activity-30d.csv'), findsOneWidget);
      // `dsFormatBytes(4821)` — the KB branch rounds.
      expect(find.text(dsFormatBytes(4821)), findsOneWidget);
    });
  });

  /* ── The launcher ──────────────────────────────────────────────────────── */

  group('launcher', () {
    testWidgets('it is fixed to the viewport, not to the panel',
        (WidgetTester tester) async {
      await tester.pumpConsolePage();

      final Size viewport = tester.view.physicalSize /
          tester.view.devicePixelRatio;
      final Rect button = tester.getRect(find.byType(DsAgentLauncher).first);
      // `SizedBox.shrink()` — the trigger has no layout box at all, which is
      // what keeps the launcher section at its measured 404.8.
      expect(button.size, Size.zero);

      final Finder face = find.descendant(
        of: find.byType(Overlay),
        matching: find.text('Ask the assistant'),
      );
      expect(face, findsOneWidget);
      final Rect label = tester.getRect(face);
      // Bottom-right, `right-6 bottom-6`, with the 64px pill beside it.
      expect(label.right, lessThan(viewport.width));
      expect(label.bottom, greaterThan(viewport.height / 2));
    });

    testWidgets('the dialog resolves 78vw, floored and capped',
        (WidgetTester tester) async {
      // At 1440 the reference measures 1123.19 × 792.
      expect(
        DsAgentLauncher.dialogSize(const Size(1440, 900)).width,
        closeTo(1123.2, _fineTolerance),
      );
      expect(
        DsAgentLauncher.dialogSize(const Size(1440, 900)).height,
        closeTo(792, _fineTolerance),
      );
      // `min-width: 60vw` is a floor `78vw` never falls through — the two are
      // both viewport-relative, so the min can only bind against the `80rem`
      // cap. At 800 the width is plain 78vw.
      expect(
        DsAgentLauncher.dialogSize(const Size(800, 900)).width,
        closeTo(800 * 0.78, _fineTolerance),
      );
      // The cap binds between the two: at 1800, `78vw` is 1404 and `80rem`
      // pulls it back to 1280, which is still above `60vw`'s 1080.
      expect(
        DsAgentLauncher.dialogSize(const Size(1800, 900)).width,
        closeTo(1280, _fineTolerance),
      );
      // And past ~2133 the cap stops binding, because CSS applies `min-width`
      // after `max-width`: a 2400px window gets `60vw` = 1440, not 1280.
      expect(
        DsAgentLauncher.dialogSize(const Size(2400, 1400)).width,
        closeTo(1440, _fineTolerance),
      );
      // `min(88vh, 52rem)` — the 52rem arm.
      expect(
        DsAgentLauncher.dialogSize(const Size(2400, 1400)).height,
        closeTo(832, _fineTolerance),
      );
    });
  });
}
