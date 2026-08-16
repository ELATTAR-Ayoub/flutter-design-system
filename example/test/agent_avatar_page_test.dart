/// `/design-system/components/agent/avatar` — the page, against the numbers
/// the reference actually renders.
///
/// Two harnesses, the same split every page test in this suite uses:
///
///  * [pumpAvatarInShell] mounts the real `DocsShell` at the 1440 × 900
///    reference frame and hands back the reading column's `RenderBox`. Every
///    oracle number is measured from that origin, **pristine** — nothing
///    hovered, nothing clicked — which is the state the oracle was read in.
///  * [pumpAvatarPage] mounts the page alone in a tall frame so every specimen
///    is laid out and hit-testable at once.
///
/// The oracle is `node tool/verify/section-oracle.js
/// /design-system/components/agent/avatar light`, run 2026-08-16, and it
/// reports the **same** numbers in dark. No clock is involved: nothing on this
/// page is dated.
///
/// Coordinates are the reference's document coordinates; the reading column
/// starts 112px down (`main` at 64 plus its own `py-12`), so every oracle
/// number is the measured top less 112.
library;

import 'dart:io';
import 'dart:typed_data';

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/kit.dart';
import 'package:example/nav.dart';
import 'package:example/pages/agent_avatar.dart';
import 'package:example/shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FontLoader;
import 'package:flutter_test/flutter_test.dart';

/* ── The frame and the oracle ────────────────────────────────────────────── */

/// Tall enough to lay the whole page out at once.
const Size _desktop = Size(1440, 6000);

/// The frame the reference is measured at.
const Size _referenceFrame = Size(1440, 900);

const String _route = '$dsRoot/components/agent/avatar';

/// `--width-content`.
const double _columnWidth = 1080;

/// `main` at 64, plus its own 48px of top padding.
const double _columnTop = 112;

/// `document.documentElement.scrollHeight` at 1440 × 900, for the record.
const double _documentHeight = 3931;

/// `main`'s own border box — 64 down the document, 3867.2 tall — less its
/// `py-12` on both edges.
const double _columnHeight = 3867.2 - 96;

/// Each `section[id]`, as `(document top, border-box height)`.
///
/// The heights are the CSS border box, so `mb-20` — which this port pays as
/// padding inside the section's own box — comes back off before comparing.
const Map<String, ({double top, double height})> _sectionOracle =
    <String, ({double top, double height})>{
  'states': (top: 575.4, height: 703.3),
  'playground': (top: 1358.7, height: 372.3),
  'sizes': (top: 1811, height: 315),
  'accent': (top: 2206, height: 267),
  'orb': (top: 2552.9, height: 474.7),
  'renderer': (top: 3107.6, height: 296.8),
  'reduced-motion': (top: 3484.4, height: 217.8),
};

/// Two logical pixels — the band the aggregates hold.
const double _tolerance = 2;

/// Half a pixel — the band every anchor holds.
const double _fineTolerance = 0.5;

/* ── Harness ─────────────────────────────────────────────────────────────── */

/// The reference's own font binaries. Load-bearing: every number above is a
/// line box.
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
  /// framework's own does not win — which also stills two hundred and
  /// thirty-one cubes and the status line, and is the only reason this file
  /// can end a test without a live ticker.
  Future<void> pumpAvatarPage({DsThemeMode mode = DsThemeMode.light}) async {
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
                  child: const SingleChildScrollView(child: AgentAvatarPage()),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await pump();
    await pump(DsDurations.slow);
    _drainStageError(this);
  }
}

/// The page inside the real [DocsShell] at the reference frame.
Future<RenderBox> pumpAvatarInShell(
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

  const Widget page = AgentAvatarPage();
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
  // No settle: geometry is settled on the first laid-out frame, and this page
  // carries two hundred and thirty-one loopers that would never let one return.
  await tester.pump();
  await tester.pump();
  _drainStageError(tester);

  return tester.renderObject<RenderBox>(find.byWidget(page));
}

/// §orb's programme cannot load in the host test VM — `shaders:` compiles it
/// for the app's backend (Vulkan on this machine) and flutter_test wants SkSL —
/// and [DsVoiceOrb] reports that failure through [FlutterError] rather than
/// swallowing it, which is the right behaviour and would otherwise fail
/// whichever test happens to pump first. The orb still lays out its full 160px
/// box, so every number in this file is unaffected.
///
/// Drained here, and ONLY this exception: anything else rethrows.
void _drainStageError(WidgetTester tester) {
  final Object? thrown = tester.takeException();
  if (thrown == null) return;
  if (thrown.toString().contains('runtime stage data')) return;
  throw thrown;
}

/* ── Finders ─────────────────────────────────────────────────────────────── */

Finder _section(String id) => find.byWidgetPredicate(
      (Widget widget) => widget is DsSection && widget.id == id,
    );

Finder _in(String id, Finder matching) =>
    find.descendant(of: _section(id), matching: matching);

/// A string as the page *authors* it — three of the kit's rungs paint
/// uppercase, so a cell labelled `sm` is found as `SM` or not at all.
Finder _copy(String text) => find.byWidgetPredicate(
      (Widget widget) => widget is DsText && widget.text == text,
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

({double top, double height}) _sectionBox(
  WidgetTester tester,
  RenderBox origin,
  String id,
) {
  final ({double top, double height}) box = _boxIn(tester, origin, _section(id));
  return (top: box.top, height: box.height - ds(20));
}

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
      final RenderBox column = await pumpAvatarInShell(tester);
      expect(column.size.width, _columnWidth);
    });

    testWidgets('every section anchor lands where the oracle put it',
        (WidgetTester tester) async {
      final RenderBox column = await pumpAvatarInShell(tester);
      for (final MapEntry<String, ({double top, double height})> entry
          in _sectionOracle.entries) {
        final ({double top, double height}) box =
            _sectionBox(tester, column, entry.key);
        expect(
          box.top + _columnTop,
          closeTo(entry.value.top, _fineTolerance),
          reason: '${entry.key} top',
        );
        expect(
          box.height,
          closeTo(entry.value.height, _fineTolerance),
          reason: '${entry.key} height',
        );
      }
    });

    testWidgets('the column stacks to the reference height',
        (WidgetTester tester) async {
      final RenderBox column = await pumpAvatarInShell(tester);
      expect(column.size.height, closeTo(_columnHeight, _tolerance));
    });

    testWidgets('the document height matches the reference',
        (WidgetTester tester) async {
      final RenderBox column = await pumpAvatarInShell(tester);
      // `main`'s own `py-12` on both edges, plus the 64px header above it.
      // Measured 3931.25 against the reference's 3931 — a quarter of a pixel
      // over seven sections and 3771 of stacked column.
      expect(
        column.size.height + 96 + 64,
        closeTo(_documentHeight, _fineTolerance),
      );
    });

    testWidgets('dark reports the same geometry', (WidgetTester tester) async {
      final RenderBox column =
          await pumpAvatarInShell(tester, mode: DsThemeMode.dark);
      expect(column.size.height, closeTo(_columnHeight, _tolerance));
      for (final MapEntry<String, ({double top, double height})> entry
          in _sectionOracle.entries) {
        expect(
          _sectionBox(tester, column, entry.key).top + _columnTop,
          closeTo(entry.value.top, _fineTolerance),
          reason: entry.key,
        );
      }
    });
  });

  /* ── §1 · states ───────────────────────────────────────────────────────── */

  group('the matrix', () {
    testWidgets('twenty cells, five to a row, at lg',
        (WidgetTester tester) async {
      final RenderBox column = await pumpAvatarInShell(tester);
      final Finder cells = _in('states', find.byType(DsCubeAvatar));
      expect(cells, findsNWidgets(20));

      // 5 columns of 214.797 + one of 214.812, `gap: 1px`.
      final List<double> tops = <double>[
        for (final Element e in cells.evaluate())
          (e.renderObject! as RenderBox)
              .localToGlobal(Offset.zero, ancestor: column)
              .dy,
      ];
      expect(tops.take(5).toSet().length, 1, reason: 'row 1 is one row');
      expect(tops[5], greaterThan(tops[0]));

      // `size-20` on every one of them.
      for (final Element e in cells.evaluate()) {
        expect((e.renderObject! as RenderBox).size, const Size(80, 80));
      }
    });

    testWidgets('the grid is 1080 wide with 214.8 cells',
        (WidgetTester tester) async {
      final RenderBox column = await pumpAvatarInShell(tester);
      final RenderBox grid = tester.renderObject<RenderBox>(
        _in('states', find.byType(DsStateGrid)),
      );
      expect(grid.size.width, closeTo(_columnWidth, _fineTolerance));
      final RenderBox cell = tester.renderObject<RenderBox>(
        _in('states', find.byType(DsStateCell)).first,
      );
      expect(cell.size.width, closeTo(214.8, _tolerance));
      expect(grid.localToGlobal(Offset.zero, ancestor: column).dx, 0);
    });

    testWidgets('the labels are the state sentences, in declaration order',
        (WidgetTester tester) async {
      await tester.pumpAvatarPage();
      // `.type-micro` only — the section's own `h2` and its description are
      // `DsText` too, and both sit inside the same subtree.
      final List<String> labels = <String>[
        for (final Element e in _in(
          'states',
          find.byWidgetPredicate(
            (Widget w) => w is DsText && w.spec == DsType.micro,
          ),
        ).evaluate())
          (e.widget as DsText).text,
      ];
      expect(
        labels,
        <String>[for (final DsAgentState s in DsAgentState.values) s.label],
      );
      // The first and the last, spelled out — `Ready` and `Done`.
      expect(labels.first, 'Ready');
      expect(labels.last, 'Done');
    });
  });

  /* ── §2 · playground ───────────────────────────────────────────────────── */

  group('the playground', () {
    testWidgets('twenty buttons, labelled with the wire ids',
        (WidgetTester tester) async {
      await tester.pumpAvatarPage();
      final Finder buttons = _in('playground', find.byType(DsButton));
      expect(buttons, findsNWidgets(20));
      // DRIFT 3 — snake_case ids beside a sentence-case status line.
      expect(_in('playground', find.text('awaiting_approval')), findsOneWidget);
      expect(_in('playground', find.text('calling_tools')), findsOneWidget);
      expect(_in('playground', find.text('Awaiting approval')), findsNothing);
      // `size="sm"` — h-8.
      for (final Element e in buttons.evaluate()) {
        expect((e.widget as DsButton).size, DsButtonSize.sm);
      }
    });

    testWidgets('exactly one button is `default` and it is the live state',
        (WidgetTester tester) async {
      await tester.pumpAvatarPage();
      List<String> filled() => <String>[
            for (final Element e
                in _in('playground', find.byType(DsButton)).evaluate())
              if ((e.widget as DsButton).variant == DsButtonVariant.primary)
                ((e.widget as DsButton).child as Text).data!,
          ];
      // `useState<AgentState>("thinking")`.
      expect(filled(), <String>['thinking']);

      await tester.tap(_in('playground', find.text('error')));
      await tester.pump();
      expect(filled(), <String>['error']);
    });

    testWidgets('the face is xl and the status line is the state sentence',
        (WidgetTester tester) async {
      await tester.pumpAvatarPage();
      final DsCubeAvatar face = tester.widget<DsCubeAvatar>(
        _in('playground', find.byType(DsCubeAvatar)),
      );
      expect(face.size, DsAgentAvatarSize.xl);
      expect(face.state, DsAgentState.thinking);
      expect(_in('playground', _copy('Thinking')), findsOneWidget);

      // The label follows the buttons.
      await tester.tap(_in('playground', find.text('done')));
      await tester.pump();
      expect(_in('playground', _copy('Done')), findsOneWidget);
      expect(_in('playground', _copy('Thinking')), findsNothing);
    });

    testWidgets('the status line shimmers only while the agent is busy',
        (WidgetTester tester) async {
      await tester.pumpAvatarPage();
      // `thinking` is busy — a ShaderMask clips the gradient to the glyphs.
      expect(_in('playground', find.byType(ShaderMask)), findsOneWidget);

      // The three resting states sit still in `--muted-foreground`.
      for (final String resting in <String>['idle', 'done', 'error']) {
        await tester.tap(_in('playground', find.text(resting)));
        await tester.pump();
        expect(
          _in('playground', find.byType(ShaderMask)),
          findsNothing,
          reason: resting,
        );
      }

      await tester.tap(_in('playground', find.text('searching')));
      await tester.pump();
      expect(_in('playground', find.byType(ShaderMask)), findsOneWidget);
    });

    testWidgets('the panel is 1080 × 178 and the button row 1080 × 72',
        (WidgetTester tester) async {
      final RenderBox column = await pumpAvatarInShell(tester);
      final RenderBox panel = tester.renderObject<RenderBox>(
        _in('playground', find.byType(Container)).first,
      );
      expect(panel.size.width, closeTo(_columnWidth, _fineTolerance));
      // `p-6` twice plus the xl avatar, plus the 1px frame.
      expect(panel.size.height, closeTo(178, _tolerance));
      expect(panel.localToGlobal(Offset.zero, ancestor: column).dx, 0);

      final RenderBox row =
          tester.renderObject<RenderBox>(_in('playground', find.byType(Wrap)));
      expect(row.size.width, closeTo(_columnWidth, _fineTolerance));
      // Two 32px rows and one 8px gutter.
      expect(row.size.height, closeTo(72, _tolerance));
    });
  });

  /* ── §3 · sizes and §4 · accent ────────────────────────────────────────── */

  group('sizes and the accent knob', () {
    testWidgets('four scales, four boxes', (WidgetTester tester) async {
      await tester.pumpAvatarPage();
      final List<DsCubeAvatar> avatars = <DsCubeAvatar>[
        for (final Element e in _in('sizes', find.byType(DsCubeAvatar))
            .evaluate())
          e.widget as DsCubeAvatar,
      ];
      expect(
        avatars.map((DsCubeAvatar a) => a.size).toList(),
        DsAgentAvatarSize.values,
      );
      for (final DsCubeAvatar a in avatars) {
        expect(a.state, DsAgentState.thinking);
      }
      for (final String note in <String>[
        '32px · inline, beside a chip',
        '48px · launcher, console header',
        '80px · welcome card',
        '128px · empty state, hero',
      ]) {
        expect(_in('sizes', _copy(note)), findsOneWidget);
      }
    });

    testWidgets('one knob, four products', (WidgetTester tester) async {
      await tester.pumpAvatarPage();
      final List<DsCubeAvatar> avatars = <DsCubeAvatar>[
        for (final Element e in _in('accent', find.byType(DsCubeAvatar))
            .evaluate())
          e.widget as DsCubeAvatar,
      ];
      expect(
        avatars.map((DsCubeAvatar a) => a.accent).toList(),
        <Color?>[null, DsPalette.value, DsPalette.success, DsPalette.info],
      );
      for (final DsCubeAvatar a in avatars) {
        expect(a.state, DsAgentState.callingTools);
        expect(a.size, DsAgentAvatarSize.lg);
      }
      // The labels are the CSS the caller would write.
      for (final String label in <String>[
        'var(--agent)',
        'var(--color-value)',
        'var(--color-success)',
        'var(--color-info)',
      ]) {
        expect(_in('accent', _copy(label)), findsOneWidget);
      }
    });
  });

  /* ── §5 · orb ──────────────────────────────────────────────────────────── */

  group('the orb', () {
    testWidgets('one 160px orb in a py-8 well, under a labelled Panel',
        (WidgetTester tester) async {
      await tester.pumpAvatarPage();
      final Finder panel = _in(
        'orb',
        find.byWidgetPredicate(
          (Widget w) => w is DsPanel && w.label == 'Orb',
        ),
      );
      expect(panel, findsOneWidget);
      expect(
        tester.widget<DsPanel>(panel).note,
        'three.js · reads --orb-from and --orb-to',
      );
      final Finder orb = _in('orb', find.byType(DsVoiceOrb));
      expect(orb, findsOneWidget);
      expect(tester.widget<DsVoiceOrb>(orb).size, 160);
      expect(tester.widget<DsVoiceOrb>(orb).state, DsOrbState.idle);
    });

    testWidgets('the well is 1030 × 224 inside the panel body',
        (WidgetTester tester) async {
      await pumpAvatarInShell(tester);
      // The orb's own `py-8` wrapper — the nearest Padding above it, not the
      // section header's.
      final RenderBox well = tester.renderObject<RenderBox>(
        find
            .ancestor(
              of: find.byType(DsVoiceOrb),
              matching: find.byType(Padding),
            )
            .first,
      );
      expect(well.size.width, closeTo(1030, _tolerance));
      // `py-8` twice around a 160px orb.
      expect(well.size.height, closeTo(224, _tolerance));
    });
  });

  /* ── §6 · renderer and §7 · reduced motion ─────────────────────────────── */

  group('the contract and the trap', () {
    testWidgets('four rows for a five-member type',
        (WidgetTester tester) async {
      await tester.pumpAvatarPage();
      final DsMeta meta =
          tester.widget<DsMeta>(_in('renderer', find.byType(DsMeta)));
      // DRIFT 4 — `className` is on the type and off the page.
      expect(
        meta.items.map((DsMetaItem i) => i.k).toList(),
        <String>['state', 'size?', 'accent?', 'speed?'],
      );
    });

    testWidgets('the reduced-motion note is the value tone',
        (WidgetTester tester) async {
      await tester.pumpAvatarPage();
      final DsNote note =
          tester.widget<DsNote>(_in('reduced-motion', find.byType(DsNote)));
      expect(note.tone, DsNoteTone.value);
      expect(note.title, 'Why the blanket rule is not enough');
      // The section has no specimen at all — DRIFT 10.
      expect(_in('reduced-motion', find.byType(DsCubeAvatar)), findsNothing);
    });
  });

  /* ── Copy ──────────────────────────────────────────────────────────────── */

  group('copy', () {
    testWidgets('the header, verbatim', (WidgetTester tester) async {
      await tester.pumpAvatarPage();
      final DsCategoryHit here = findCategory('agent', 'avatar');
      // DRIFT 1 — "Agent · Components" against a group called "Agent".
      expect(_copy('Agent · Components'), findsOneWidget);
      expect(_copy('Avatar'), findsOneWidget);
      expect(_copy(here.category.blurb), findsOneWidget);
      // DRIFT 2 — five chips, seven sections.
      expect(here.category.contents.length, 5);
      expect(_sectionOracle.length, 7);
    });

    testWidgets('the seven section titles, in order',
        (WidgetTester tester) async {
      await tester.pumpAvatarPage();
      expect(
        <String>[
          for (final Element e in find.byType(DsSection).evaluate())
            (e.widget as DsSection).title,
        ],
        <String>[
          'Twenty states',
          'Face and status line',
          'Sizes',
          'One knob',
          'Voice orb',
          'The renderer contract',
          'Reduced motion is handled explicitly',
        ],
      );
      expect(
        <String>[
          for (final Element e in find.byType(DsSection).evaluate())
            (e.widget as DsSection).id,
        ],
        _sectionOracle.keys.toList(),
      );
    });

    testWidgets('the page Note is the action tone, outside every section',
        (WidgetTester tester) async {
      await tester.pumpAvatarPage();
      final Finder outside = find.byWidgetPredicate(
        (Widget w) => w is DsNote && w.tone == DsNoteTone.action,
      );
      expect(outside, findsOneWidget);
      expect(
        tester.widget<DsNote>(outside).title,
        'The agent acts, so the agent is blue',
      );
      // The one Note in this page's tree that is not inside a DsSection.
      expect(
        find.descendant(of: find.byType(DsSection), matching: outside),
        findsNothing,
      );
    });

    testWidgets('the page Note is the full 1080', (WidgetTester tester) async {
      final RenderBox column = await pumpAvatarInShell(tester);
      final RenderBox note = tester.renderObject<RenderBox>(
        find.byWidgetPredicate(
          (Widget w) => w is DsNote && w.tone == DsNoteTone.action,
        ),
      );
      expect(note.size.width, closeTo(_columnWidth, _fineTolerance));
      expect(note.localToGlobal(Offset.zero, ancestor: column).dx, 0);
    });
  });
}
