/// `/design-system/components/agent/composer` — the page, against the numbers
/// the reference actually renders.
///
/// Two harnesses, and the split is load-bearing:
///
///  * [pumpComposerInShell] mounts the real `DocsShell` at the 1440 × 900
///    reference frame and hands back the reading column's `RenderBox`. Every
///    oracle number below is measured from that origin, **pristine** — nothing
///    typed, no palette open, no menu open — which is the state the reference
///    was measured in.
///  * [pumpComposerPage] mounts the page alone in a tall frame so all four
///    composers are laid out and hit-testable at once. Every one of them
///    answers a pointer and a keyboard, and this file's job is to prove it.
///
/// **The fidelity bar is that all four specimens are live.** A reader can type
/// into any composer and watch it grow, open the slash palette with `/` and
/// walk it, open the plus menu, take the attachment back out of the tray, and
/// see busy and disabled differ. There is not one still on this page.
///
/// **No `pumpAndSettle`**: the palette's entrance is a 400ms tween, and both
/// harnesses run under `MediaQuery(disableAnimations: true)` — the port's
/// `prefers-reduced-motion` — so it lands on its resting frame, which is the
/// frame the reference was measured in.
///
/// The oracle was read off `http://localhost:3000` at 1440 × 900 on 2026-08-16
/// with `getBoundingClientRect()`, in document coordinates; the reading column
/// starts 112px down (`main` at 64 plus its own `py-12`), so every number here
/// is the measured top less 112.
library;

import 'dart:io';
import 'dart:typed_data';

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/kit.dart';
import 'package:example/nav.dart';
import 'package:example/pages/composer.dart';
import 'package:example/shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FontLoader, LogicalKeyboardKey;
import 'package:flutter_test/flutter_test.dart';

/* ── The frame and the oracle ────────────────────────────────────────────── */

/// The behaviour frame: tall enough to lay the whole page out at once.
const Size _desktop = Size(1440, 3600);

/// The frame the reference is measured at, and the only width these numbers
/// mean anything at.
const Size _referenceFrame = Size(1440, 900);

const String _route = '$dsRoot/components/agent/composer';

/// `--width-content` — the reading column every wrap on the page follows.
const double _columnWidth = 1080;

/// Where the reading column starts in the reference's document coordinates:
/// `main` at 64, plus its own 48px of top padding.
const double _columnTop = 112;

/// The reading column's own height — `main`'s 2970.3 less its `py-12` on both
/// edges.
///
/// This is the number `vertical_parity_probe_test.dart`'s `_referenceHeight`
/// takes for this route at integration.
const double _columnHeight = 2874.3;

/// `document.documentElement.scrollHeight`.
const double _documentHeight = 3034;

/// Each `section[id]`, as `(document top, border-box height)`.
///
/// Measured pristine. The heights are the CSS border box, so `mb-20` — which
/// this port pays as padding inside the section's own box — comes back off
/// before comparing.
const Map<String, ({double top, double height})> _sectionOracle =
    <String, ({double top, double height})>{
  'rest': (top: 407.9, height: 283.7),
  'states': (top: 771.6, height: 512.6),
  'attachments': (top: 1364.2, height: 490.7),
  'slash': (top: 1934.8, height: 226.7),
  'props': (top: 2241.5, height: 563.8),
};

/// The four composers' own shells, in document coordinates — `(top, height)`.
///
/// Three at rest and one carrying a file, which is the whole geometric claim of
/// the page: a tray adds **83** to a 96px composer.
const Map<String, ({double top, double height})> _composerOracle =
    <String, ({double top, double height})>{
  'rest': (top: 570.58, height: 96),
  'busy': (top: 953.77, height: 96),
  'disabled': (top: 1163.16, height: 96),
  'tray': (top: 1526.84, height: 179),
};

/// Two logical pixels — the band the aggregates hold.
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
  Future<void> pumpComposerPage({DsThemeMode mode = DsThemeMode.light}) async {
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
                  child: const SingleChildScrollView(child: ComposerPage()),
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
/// `pageFor`: `main.dart` belongs to the integration step, and this file pins
/// the page rather than the routing table.
Future<RenderBox> pumpComposerInShell(
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

  const Widget page = ComposerPage();
  await tester.pumpWidget(
    DsTheme(
      controller: theme,
      child: AppRouterScope(
        router: router,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
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

/* ── Finders ─────────────────────────────────────────────────────────────── */

Finder _section(String id) => find.byWidgetPredicate(
      (Widget widget) => widget is DsSection && widget.id == id,
    );

Finder _in(String id, Finder matching) =>
    find.descendant(of: _section(id), matching: matching);

/// The four composers, in document order — rest, busy, disabled, tray.
Finder _composer(String which) => switch (which) {
      'rest' => _in('rest', find.byType(DsAgentComposer)),
      'busy' => _in('states', find.byType(DsAgentComposer)).at(0),
      'disabled' => _in('states', find.byType(DsAgentComposer)).at(1),
      _ => _in('attachments', find.byType(DsAgentComposer)),
    };

/// A composer's own shell — the `rounded-xl border shadow-pressed` box, which
/// is the box the oracle measures.
Finder _shell(String which) => find.descendant(
      of: _composer(which),
      matching: find.byType(DsMachineSurface),
    ).first;

Finder _input(String which) =>
    find.descendant(of: _composer(which), matching: find.byType(EditableText));

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

String? _panelNote(WidgetTester tester, String label, {int at = 0}) =>
    tester
        .widgetList<DsPanel>(find.byWidgetPredicate(
          (Widget w) => w is DsPanel && w.label == label,
        ))
        .elementAt(at)
        .note;

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
      final RenderBox column = await pumpComposerInShell(tester);
      expect(column.size.width, _columnWidth);
    });

    testWidgets('the column stacks to the reference height',
        (WidgetTester tester) async {
      final RenderBox column = await pumpComposerInShell(tester);
      // The number `_referenceHeight['composer']` takes at integration, and
      // `main`'s own 2970.3 less its `py-12` at each end.
      expect(column.size.height, closeTo(_columnHeight, _tolerance));
      // …and the document the shell wraps it in.
      expect(
        column.size.height + _columnTop * 2 - ds(12) * 2 + ds(16) * 2 + 64,
        closeTo(_documentHeight, 200),
        reason: 'the document is the column plus the shell chrome; the shell '
            'is pinned by `shell_test.dart` and only the column is this '
            'file\'s business',
      );
    });

    testWidgets('every section starts and ends where the reference does',
        (WidgetTester tester) async {
      final RenderBox column = await pumpComposerInShell(tester);

      // Collected rather than asserted one at a time: a vertical drift is
      // cumulative, so the FIRST mismatch hides every section under it and the
      // useful diagnosis is the whole column at once.
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

    testWidgets('the four composers land on the reference\'s anchors',
        (WidgetTester tester) async {
      final RenderBox column = await pumpComposerInShell(tester);

      final List<String> off = <String>[];
      for (final MapEntry<String, ({double top, double height})> want
          in _composerOracle.entries) {
        final ({double top, double height}) got =
            _boxIn(tester, column, _shell(want.key));
        final double wantTop = want.value.top - _columnTop;
        if ((got.top - wantTop).abs() > _fineTolerance) {
          off.add('${want.key} starts at ${got.top.toStringAsFixed(2)}, '
              'the reference at ${wantTop.toStringAsFixed(2)}');
        }
        if ((got.height - want.value.height).abs() > _fineTolerance) {
          off.add('${want.key} is ${got.height.toStringAsFixed(2)} tall, '
              'the reference ${want.value.height}');
        }
      }
      expect(off, isEmpty, reason: off.join('\n'));
    });

    testWidgets('every composer is the Panel body\'s full 1030',
        (WidgetTester tester) async {
      await pumpComposerInShell(tester);
      for (final String which in <String>[
        'rest',
        'busy',
        'disabled',
        'tray',
      ]) {
        expect(tester.getSize(_shell(which)).width, 1030,
            reason: '$which: `w-full` inside a `p-6` Panel body');
      }
    });

    testWidgets('the geometry holds in dark as well as light',
        (WidgetTester tester) async {
      final RenderBox column =
          await pumpComposerInShell(tester, mode: DsThemeMode.dark);
      expect(column.size.width, _columnWidth);
      expect(column.size.height, closeTo(_columnHeight, _tolerance));
    });
  });

  /* ── Copy ──────────────────────────────────────────────────────────────── */

  group('copy — verbatim', () {
    testWidgets('the header carries the nav\'s own strings, drift 1 included',
        (WidgetTester tester) async {
      await pumpComposerInShell(tester);
      final DsCategoryHit here = findCategory('agent', 'composer');
      expect(here.category.title, 'Composer');
      // DRIFT 1: "Agent · Components", where every base page says
      // "<group> · Base". `.type-label` is `text-transform: uppercase` and
      // `DsText` performs the transform, so this is the string that renders.
      expect(find.text('AGENT · COMPONENTS'), findsOneWidget);
      // Twice: the page's own `h1` and the shell's nav entry beside it.
      expect(find.text('Composer'), findsWidgets);
      expect(
        find.text('Everything below the transcript: the input, the file tray, '
            'the slash palette, dictation and the model picker.'),
        findsOneWidget,
      );
      // DRIFT 2: five chips against five sections, and only ONE of the five
      // names a section on the page.
      expect(here.category.contents, <String>[
        'Composer',
        'Attach menu',
        'Slash palette',
        'Dictation',
        'Model picker',
      ]);
      expect(find.text('Dictation'), findsOneWidget,
          reason: 'the chip is printed; the section behind it does not exist');
      expect(find.text('Model picker'), findsOneWidget);
    });

    testWidgets('five sections, in order, with the reference\'s titles',
        (WidgetTester tester) async {
      await pumpComposerInShell(tester);
      const List<String> ids = <String>[
        'rest',
        'states',
        'attachments',
        'slash',
        'props',
      ];
      final List<DsSection> sections =
          tester.widgetList<DsSection>(find.byType(DsSection)).toList();
      expect(sections.map((DsSection s) => s.id).toList(), ids);
      expect(
        sections.map((DsSection s) => s.title).toList(),
        <String>[
          'At rest',
          'Busy and disabled',
          'File tray',
          'Slash palette',
          'Props',
        ],
      );
      // Every one of the five carries a description; none of them is null.
      expect(
        sections.where((DsSection s) => s.description == null),
        isEmpty,
      );
      expect(
        sections.first.description,
        contains('Enter sends and Shift-Enter breaks the line'),
      );
      expect(
        sections[1].description,
        contains('dropping the first message on the floor'),
      );
    });

    testWidgets('the five Panels and the notes on them',
        (WidgetTester tester) async {
      await pumpComposerInShell(tester);
      final List<DsPanel> panels =
          tester.widgetList<DsPanel>(find.byType(DsPanel)).toList();
      expect(
        panels.map((DsPanel p) => p.label).toList(),
        <String>['Composer', 'Composer', 'Composer', 'Composer', 'SlashPalette'],
      );
      // DRIFT 4: `idle` describes the absence of the other two states.
      expect(panels[0].note, 'idle');
      expect(panels[1].note, 'busy — send becomes stop');
      expect(panels[2].note, 'disabled — transport not ready');
      expect(panels[3].note, 'one attachment, content delivered');
      expect(_panelNote(tester, 'SlashPalette'), 'type / in any composer above');
      // Every Panel on this page carries a note.
      expect(panels.where((DsPanel p) => p.note == null), isEmpty);
    });

    testWidgets('§3\'s Note is the only one, and it is tone=value',
        (WidgetTester tester) async {
      await pumpComposerInShell(tester);
      final List<DsNote> notes =
          tester.widgetList<DsNote>(find.byType(DsNote)).toList();
      expect(notes, hasLength(1));
      expect(notes.single.tone, DsNoteTone.value);
      // `.type-label` uppercases on render, like the eyebrow.
      expect(find.text('THE BORDER IS THE DROP TARGET'), findsOneWidget);
      expect(_in('attachments', find.byType(DsNote)), findsOneWidget);
      // The curly quotes are the reference's `&ldquo;` / `&rdquo;`.
      expect(
        _in(
          'attachments',
          find.textContaining('“you may drop here”', findRichText: true),
        ),
        findsOneWidget,
      );
      // …and the code chip inside it.
      expect(
        tester
            .widgetList<DsCode>(find.byType(DsCode))
            .map((DsCode c) => c.chip),
        contains('border-agent bg-agent/8'),
      );
    });

    testWidgets('§4 documents the palette in prose, and §5 lists ten props',
        (WidgetTester tester) async {
      await pumpComposerInShell(tester);
      // DRIFT 3 — the section about the palette holds a paragraph about it.
      expect(
        _in(
          'slash',
          find.textContaining('anchored to the composer rather than portalled',
              findRichText: true),
        ),
        findsOneWidget,
      );
      expect(
        tester
            .widgetList<DsCode>(find.byType(DsCode))
            .map((DsCode c) => c.chip),
        containsAll(<String>['filterCommands', 'slashQuery']),
      );

      final List<DsMeta> metas =
          tester.widgetList<DsMeta>(find.byType(DsMeta)).toList();
      expect(metas, hasLength(1));
      expect(metas.single.items, hasLength(10));
      // DRIFT 5 — the reference's own API, including the two props this port
      // folds into one controller.
      expect(metas.single.items.first.k, 'value / onChange');
      expect(metas.single.items.last.k, 'inputRef');
      expect(
        metas.single.items[6].v.toPlainText(),
        contains('from useDictation'),
      );
    });
  });

  /* ── Behaviour — every specimen is live ────────────────────────────────── */

  group('§1 at rest', () {
    testWidgets('typing grows the composer and arms send',
        (WidgetTester tester) async {
      await tester.pumpComposerPage();
      final double before = tester.getSize(_shell('rest')).height;
      expect(before, closeTo(96, _fineTolerance));

      await tester.enterText(_input('rest'), 'How many packs are left?');
      await tester.pump();
      expect(tester.getSize(_shell('rest')).height, closeTo(96, _fineTolerance),
          reason: 'one line still');

      await tester.enterText(_input('rest'), 'one\ntwo\nthree');
      await tester.pump();
      expect(
        tester.getSize(_shell('rest')).height,
        closeTo(144, _fineTolerance),
        reason: '+24 a line',
      );
    });

    testWidgets('Enter empties it — the specimen\'s whole onSubmit',
        (WidgetTester tester) async {
      await tester.pumpComposerPage();
      await tester.enterText(_input('rest'), 'send me');
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(
        tester.widget<EditableText>(_input('rest')).controller.text,
        '',
      );
      expect(tester.getSize(_shell('rest')).height, closeTo(96, _fineTolerance));
    });

    testWidgets('the placeholder is the persona\'s, ellipsis included',
        (WidgetTester tester) async {
      await pumpComposerInShell(tester);
      expect(
        find.text('Ask about a pack, a pull or your balance…'),
        findsNWidgets(4),
        reason: 'all four composers carry it',
      );
    });
  });

  group('§2 busy and disabled', () {
    testWidgets('busy holds Stop and disabled holds a dead Send',
        (WidgetTester tester) async {
      await tester.pumpComposerPage();

      final DsButton busy = tester.widget<DsButton>(
        find.descendant(of: _composer('busy'), matching: find.byType(DsButton))
            .last,
      );
      expect(busy.label, 'Stop');
      expect(busy.variant, DsButtonVariant.outline);
      expect(busy.onPressed, isNotNull);

      final DsButton disabled = tester.widget<DsButton>(
        find
            .descendant(
                of: _composer('disabled'), matching: find.byType(DsButton))
            .last,
      );
      expect(disabled.label, 'Send');
      expect(disabled.onPressed, isNull);
    });

    testWidgets('the busy composer still takes text; the disabled one does not '
        'send', (WidgetTester tester) async {
      await tester.pumpComposerPage();
      await tester.enterText(_input('busy'), 'queued behind the answer');
      await tester.pump();
      expect(
        tester.widget<EditableText>(_input('busy')).controller.text,
        'queued behind the answer',
      );

      // *"…which the composer says by refusing input rather than by dropping
      // the first message on the floor."* Refusing input is literal: the
      // disabled field takes no text at all, so there is never a message to
      // drop.
      await tester.enterText(_input('disabled'), 'nowhere to go');
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(
        tester.widget<EditableText>(_input('disabled')).controller.text,
        '',
        reason: 'the box refuses the keystrokes; that is the whole mechanism',
      );
      expect(tester.getSize(_shell('disabled')).height,
          closeTo(96, _fineTolerance));
    });

    testWidgets('neither state moves the box', (WidgetTester tester) async {
      await pumpComposerInShell(tester);
      expect(tester.getSize(_shell('busy')).height, closeTo(96, _fineTolerance));
      expect(tester.getSize(_shell('disabled')).height,
          closeTo(96, _fineTolerance));
    });
  });

  group('§3 the file tray', () {
    testWidgets('the seeded file prints its name, its size and its delivery',
        (WidgetTester tester) async {
      await pumpComposerInShell(tester);
      expect(_in('attachments', find.text('collection-export.csv')),
          findsOneWidget);
      expect(_in('attachments', find.text('18 KB')), findsOneWidget);
      // `delivery: { sent: "content" }` — the agent can read it.
      expect(_in('attachments', find.text('Read')), findsOneWidget);
    });

    testWidgets('removing it takes 83px of tray with it',
        (WidgetTester tester) async {
      await tester.pumpComposerPage();
      expect(tester.getSize(_shell('tray')).height,
          closeTo(179, _fineTolerance));

      await tester.tap(find.byWidgetPredicate(
        (Widget w) =>
            w is DsButton && w.label == 'Remove collection-export.csv',
      ));
      await tester.pump();

      expect(find.text('collection-export.csv'), findsNothing);
      expect(tester.getSize(_shell('tray')).height, closeTo(96, _fineTolerance));
    });
  });

  group('§4 the slash palette', () {
    testWidgets('typing / in any composer opens it, as the note says',
        (WidgetTester tester) async {
      await tester.pumpComposerPage();
      expect(find.byType(DsAgentSlashPalette), findsNothing);

      await tester.enterText(_input('rest'), '/');
      await tester.pump();
      expect(find.byType(DsAgentSlashPalette), findsOneWidget);
      expect(find.text('Skills'), findsOneWidget);
      expect(find.text('Commands'), findsOneWidget);
      for (final String hint in <String>[
        'What is in stock',
        'Balance and recent movement',
        'Download activity as CSV',
        'How pack odds work',
      ]) {
        expect(find.text(hint), findsOneWidget);
      }
    });

    testWidgets('its rows and headings are the reference\'s own line boxes',
        (WidgetTester tester) async {
      await tester.pumpComposerPage();
      await tester.enterText(_input('rest'), '/');
      await tester.pump();

      double boxOf(String text) => tester
          .getSize(find
              .ancestor(of: find.text(text), matching: find.byType(Padding))
              .first)
          .height;

      // `px-3 pt-3 pb-1` around a 14.175px caption line.
      expect(boxOf('Skills'), closeTo(30.175, _fineTolerance));
      // `py-2` around 19.5 + 4 + 14.175 — the hints all fit on one line at
      // 1030, which is what makes this the reference's number.
      expect(boxOf('What is in stock'), closeTo(53.675, _fineTolerance));
      // `max-h-64`, and the four rows plus two headings overflow it.
      expect(
        tester.getSize(find.byType(DsAgentSlashPalette)).height,
        closeTo(256, _fineTolerance),
      );
      // `w-full` of the composer it is anchored to — this harness lays the
      // page out without the shell's reading column, so the number to hold is
      // the relationship, not 1030. The 1030 case is pinned in the shell
      // harness by the clipping test below.
      expect(
        tester.getSize(find.byType(DsAgentSlashPalette)).width,
        tester.getSize(_shell('rest')).width,
      );
    });

    testWidgets('it is out of flow — the section does not move',
        (WidgetTester tester) async {
      await tester.pumpComposerPage();
      final double before = tester.getSize(_section('rest')).height;
      await tester.enterText(_input('rest'), '/');
      await tester.pump();
      expect(tester.getSize(_section('rest')).height,
          closeTo(before, _fineTolerance));
    });

    testWidgets('the keyboard walks it and commits a command',
        (WidgetTester tester) async {
      await tester.pumpComposerPage();
      await tester.enterText(_input('rest'), '/');
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(
        tester.widget<EditableText>(_input('rest')).controller.text,
        '/wallet ',
      );
      expect(find.byType(DsAgentSlashPalette), findsNothing);
    });

    testWidgets('filtering narrows it to the matching skill',
        (WidgetTester tester) async {
      await tester.pumpComposerPage();
      await tester.enterText(_input('rest'), '/exp');
      await tester.pump();
      expect(find.text('Download activity as CSV'), findsOneWidget);
      expect(find.text('What is in stock'), findsNothing);
      expect(find.text('Commands'), findsNothing);
    });

    testWidgets('DRIFT — Escape does not close it', (WidgetTester tester) async {
      await tester.pumpComposerPage();
      await tester.enterText(_input('rest'), '/');
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();
      expect(find.byType(DsAgentSlashPalette), findsOneWidget,
          reason: 'the handler\'s comment says it closes; the key-up of the '
              'same press restores the caret before the next frame, and '
              '`"/".slice(0, -1)` was an empty query rather than null anyway');
    });

    testWidgets('DRIFT — the Panel clips all but a sliver of it',
        (WidgetTester tester) async {
      final RenderBox column = await pumpComposerInShell(tester);
      await tester.enterText(_input('rest'), '/');
      await tester.pump();

      final ({double top, double height}) palette =
          _boxIn(tester, column, find.byType(DsAgentSlashPalette));
      final ({double top, double height}) panel =
          _boxIn(tester, column, _in('rest', find.byType(DsPanel)));

      // `bottom-full mb-2` lifts a 256px panel clear of the composer…
      expect(palette.height, closeTo(256, _fineTolerance));
      // …and out of the top of a Panel card that is `overflow-hidden`, so only
      // the bottom of it is ever on screen. *(Probed on the reference:
      // 56.4px of 256, and `elementFromPoint` at its own top centre returns
      // the page header's chip list.)*
      final double visible = palette.top + palette.height - panel.top;
      expect(visible, lessThan(palette.height));
      expect(visible, closeTo(56.4, _tolerance));

      // ACCEPTED LIMITATION, not an open defect. Of those 56.4 visible pixels
      // the port makes roughly the bottom 16 hit-reachable — the band that
      // falls inside the Panel body's own box — because Flutter's ancestors
      // bounds-check before `_ComposerStack`'s own skipped check is ever
      // consulted. That is the family-wide limitation commit 4f01eeb recorded,
      // and the supervisor ruled it shipped as-is: *"paint fidelity over hit
      // reachability … portalling to gain the clicks at the cost of showing
      // the full 256px would be the wrong trade."* Keyboard selection is
      // complete — see the commit test above, which is the path the
      // reference's own source comment calls the point of the component. This
      // case pins the behaviour exactly as it stands.
    });
  });

  group('the plus menu', () {
    testWidgets('every composer carries one, and it opens upwards',
        (WidgetTester tester) async {
      await tester.pumpComposerPage();
      expect(
        find.byWidgetPredicate(
          (Widget w) => w is DsButton && w.label == 'Add files or use a skill',
        ),
        findsNWidgets(4),
      );

      await tester.tap(find.descendant(
        of: _composer('rest'),
        matching: find.byWidgetPredicate(
          (Widget w) => w is DsButton && w.label == 'Add files or use a skill',
        ),
      ));
      await settleOverlay(tester);

      expect(find.text('Photos & files'), findsOneWidget);
      expect(find.text('Images, documents, spreadsheets'), findsOneWidget);
      // Skills only — `guide` is a browser command and lives under `/`.
      expect(find.text('inventory'), findsOneWidget);
      expect(find.text('wallet'), findsOneWidget);
      expect(find.text('export'), findsOneWidget);
      expect(find.text('guide'), findsNothing);
    });

    testWidgets('its rows are 49.675 — DRIFT, one `flex` short of the '
        'palette\'s 53.675', (WidgetTester tester) async {
      await tester.pumpComposerPage();
      await tester.tap(find.descendant(
        of: _composer('rest'),
        matching: find.byWidgetPredicate(
          (Widget w) => w is DsButton && w.label == 'Add files or use a skill',
        ),
      ));
      await settleOverlay(tester);

      final double row = tester
          .getSize(find
              .ancestor(
                of: find.text('Images, documents, spreadsheets'),
                matching: find.byType(Padding),
              )
              .first)
          .height;
      // `min-w-0 flex-col gap-1` with no `flex`: 8 + 19.5 + 14.175 + 8.
      expect(row, closeTo(49.675, _fineTolerance));
      expect(DsAgentAttachMenu.rowLinesHaveNoGap, isTrue);
      expect(tester.getSize(find.text('Photos & files')).width, lessThan(320));
    });

    testWidgets('picking a skill writes it into that composer',
        (WidgetTester tester) async {
      await tester.pumpComposerPage();
      await tester.tap(find.descendant(
        of: _composer('rest'),
        matching: find.byWidgetPredicate(
          (Widget w) => w is DsButton && w.label == 'Add files or use a skill',
        ),
      ));
      await settleOverlay(tester);
      await tester.tap(find.text('export'));
      await settleOverlay(tester);

      expect(
        tester.widget<EditableText>(_input('rest')).controller.text,
        '/export ',
      );
      // …and only that one.
      expect(
        tester.widget<EditableText>(_input('busy')).controller.text,
        '',
      );
    });
  });
}
