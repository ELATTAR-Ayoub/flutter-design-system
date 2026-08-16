/// `/design-system/components/agent/voice` — the page, against the numbers the
/// reference actually renders.
///
/// Two harnesses, the split every page test in this suite uses:
///
///  * [pumpVoiceInShell] mounts the real `DocsShell` at the 1440 × 900
///    reference frame and hands back the reading column's `RenderBox`. Every
///    oracle number is measured from that origin, **pristine** — nothing
///    hovered, nothing armed — which is the state the oracle was read in, and
///    on this page it is also the only state the reference itself can be
///    captured in.
///  * [pumpVoicePage] mounts the page alone in a tall frame so every specimen
///    is laid out and hit-testable at once.
///
/// The oracle is `node tool/verify/section-oracle.js
/// /design-system/components/agent/voice light` (identical in dark), plus
/// `scratchpad/ag-voice-inv.js` for the controls inside the reading column,
/// both run on 2026-08-16.
///
/// Coordinates are the reference's document coordinates; the reading column
/// starts 112px down (`main` at 64 plus its own `py-12`), so every oracle
/// number is the measured top less 112.
///
/// ## What this file deliberately does not assert
///
/// The orb's pixels — `test/agent_voice_test.dart` owns those, and the browser
/// half of the painter rule was taken against a CanvasKit build
/// (`scratchpad/ag-orb-web.js`: the disc measures 102px across a 112px box
/// starting at x=5, the reference's own numbers exactly). What this file
/// asserts is the part that survives even a programme that failed to load: the
/// orb occupies its 112px box either way, so the page's geometry holds whether
/// or not the disc draws.
library;

import 'dart:io';
import 'dart:typed_data';

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/kit.dart';
import 'package:example/nav.dart';
import 'package:example/pages/agent_voice.dart';
import 'package:example/shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FontLoader;
import 'package:flutter_test/flutter_test.dart';

/// Tall enough to lay the whole page out at once.
const Size _desktop = Size(1440, 6000);

/// The frame the reference is measured at.
const Size _referenceFrame = Size(1440, 900);

const String _route = '$dsRoot/components/agent/voice';

/// `--width-content`.
const double _columnWidth = 1080;

/// `main` at 64, plus its own 48px of top padding.
const double _columnTop = 112;

/// `document.documentElement.scrollHeight` at 1440 × 900 — the number
/// `vertical_parity_probe_test.dart` takes for this route at integration.
const double _documentHeight = 2393;

/// `main`'s own height less its `py-12` on both edges.
const double _columnHeight = 2328.9 - 96;

/// Each `section[id]`, as `(document top, border-box height)`.
///
/// The heights are the CSS border box, so `mb-20` — which this port pays as
/// padding inside the section's own box — comes back off before comparing.
const Map<String, ({double top, double height})> _sectionOracle =
    <String, ({double top, double height})>{
  'live': (top: 575.4, height: 341.3),
  'orb': (top: 996.7, height: 369.3),
  'dictation': (top: 1446, height: 420.1),
  'speech': (top: 1946.1, height: 217.8),
};

/// Two logical pixels — the band the aggregates hold.
const double _tolerance = 2;

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
  Future<void> pumpVoicePage({DsThemeMode mode = DsThemeMode.light}) async {
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
                  child: const SingleChildScrollView(child: AgentVoicePage()),
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
Future<RenderBox> pumpVoiceInShell(
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

  const Widget page = AgentVoicePage();
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
  // No settle: the orb runs a ticker that never returns, and geometry is
  // settled on the first laid-out frame anyway.
  await tester.pump();
  await tester.pump();
  _drainStageError(tester);

  return tester.renderObject<RenderBox>(find.byWidget(page));
}

/// [DsVoiceOrb] reports a programme it could not load through [FlutterError]
/// rather than swallowing it — the right behaviour, and the reason such a
/// failure lands in whichever test pumped first. That happens under
/// `--no-test-assets`, where there is no bundle to load it from.
///
/// Matching on the recorded error object keeps this from being a blanket
/// catch: anything the orb did not raise rethrows.
void _drainStageError(WidgetTester tester) {
  final Object? thrown = tester.takeException();
  if (thrown == null) return;
  final Object? recorded = DsOrbProgram.lastError;
  if (recorded != null && thrown.toString() == recorded.toString()) return;
  throw thrown;
}

/* ── Finders ─────────────────────────────────────────────────────────────── */

Finder _section(String id) => find.byWidgetPredicate(
      (Widget widget) => widget is DsSection && widget.id == id,
    );

Finder _in(String id, Finder matching) =>
    find.descendant(of: _section(id), matching: matching);

/// A string as the page *authors* it — three of the kit's rungs paint
/// uppercase, so `idle` is found as `IDLE` or not at all by `find.text`.
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
      final RenderBox column = await pumpVoiceInShell(tester);
      expect(column.size.width, _columnWidth);
    });

    testWidgets('the column stacks to the reference height',
        (WidgetTester tester) async {
      final RenderBox column = await pumpVoiceInShell(tester);
      expect(column.size.height, closeTo(_columnHeight, _tolerance));
      // The document number the same run reports, kept so a reader can check
      // the derivation: column + `main`'s own py-12 twice + the header.
      expect(
        _columnHeight + ds(12) * 2 + DsWidths.siteHeader,
        closeTo(_documentHeight, _tolerance),
      );
    });

    testWidgets('every section starts and ends where the reference does',
        (WidgetTester tester) async {
      final RenderBox column = await pumpVoiceInShell(tester);

      // Collected rather than asserted one at a time: a vertical drift is
      // cumulative, so the first mismatch hides every section under it.
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

    testWidgets('dark stacks identically — the oracle is the same both ways',
        (WidgetTester tester) async {
      final RenderBox light = await pumpVoiceInShell(tester);
      final double lightHeight = light.size.height;
      final RenderBox dark =
          await pumpVoiceInShell(tester, mode: DsThemeMode.dark);
      expect(dark.size.height, closeTo(lightHeight, 0.01));
    });
  });

  /* ── The listening surface ─────────────────────────────────────────────── */

  group('§live', () {
    testWidgets('the pill is 34 x 34 with one half, never two',
        (WidgetTester tester) async {
      await tester.pumpVoicePage();
      final Finder pill = _in('live', find.byType(DsMicControl));
      expect(pill, findsOneWidget);
      // PROBE 1: `hasMenu` is false on this page, so the chevron half never
      // renders. A pair would have measured 59 wide.
      expect(tester.getSize(pill), const Size(34, 34));
      expect(_in('live', find.byType(DsButton)), findsOneWidget);
    });

    testWidgets('the mic button is 32px around a 16px glyph',
        (WidgetTester tester) async {
      await tester.pumpVoicePage();
      // PROBE 2: the box takes `size-8` and the glyph takes `size-4`, which is
      // NOT the 14px an `iconSm` button would give it on its own.
      expect(
        tester.getSize(_in('live', find.byType(DsButton))),
        const Size(32, 32),
      );
      final DsIcon glyph =
          tester.widget<DsIcon>(_in('live', find.byType(DsIcon)));
      expect(glyph.sizePx, 16);
    });

    testWidgets('the waveform is the fixed 320 x 48 the call site asks for',
        (WidgetTester tester) async {
      await tester.pumpVoicePage();
      // PROBE 7: its lane is 852 wide and the canvas does not fill it.
      final Finder wave = _in('live', find.byType(DsLiveWaveform));
      expect(tester.getSize(wave), const Size(320, 48));
    });

    testWidgets('the bars are the component default, 96 x 24',
        (WidgetTester tester) async {
      await tester.pumpVoicePage();
      final Finder bars = _in('live', find.byType(DsBarVisualizer));
      expect(tester.getSize(bars), const Size(96, 24));
      final DsBarVisualizer widget = tester.widget<DsBarVisualizer>(bars);
      expect(widget.bars, 12);
      // PROBE 8 / the honest-degradation rule: nothing on this page is active,
      // so the meter sits at its floor rather than inventing a signal.
      expect(widget.active, isFalse);
      expect(widget.spectrum, isNull);
    });

    testWidgets('the row is the reference lane: 34 + 24 + slack + 24 + 96',
        (WidgetTester tester) async {
      final RenderBox column = await pumpVoiceInShell(tester);
      final ({double top, double height}) pill =
          _boxIn(tester, column, _in('live', find.byType(DsMicControl)));
      final ({double top, double height}) bars =
          _boxIn(tester, column, _in('live', find.byType(DsBarVisualizer)));
      // Both sit on the same 48px row, vertically centred against the taller
      // waveform: the pill is 34 and the bars 24, so their tops differ by 5.
      expect(bars.top - pill.top, closeTo(5, 0.51));
    });

    testWidgets('the Heard box reserves its line and carries the placeholder',
        (WidgetTester tester) async {
      await tester.pumpVoicePage();
      // PROBE 6 — Chrome always exposes `webkitSpeechRecognition`, so this is
      // the branch the reference renders.
      expect(_copy('Arm the microphone and say something.'), findsOneWidget);
      expect(_copy('This browser has no speech recognition.'), findsNothing);
      // DRIFT 5: `min-h-6`.
      expect(
        tester.getSize(_copy('Arm the microphone and say something.')).height,
        greaterThanOrEqualTo(ds(6)),
      );
    });

    testWidgets('arming it changes the control and nothing else',
        (WidgetTester tester) async {
      await tester.pumpVoicePage();
      final Finder pill = _in('live', find.byType(DsMicControl));
      expect(tester.widget<DsMicControl>(pill).listening, isFalse);
      expect(
        tester.widget<DsButton>(_in('live', find.byType(DsButton))).label,
        'Dictate',
      );

      await tester.tap(_in('live', find.byType(DsButton)));
      await tester.pump();

      expect(tester.widget<DsMicControl>(pill).listening, isTrue);
      expect(
        tester.widget<DsButton>(_in('live', find.byType(DsButton))).label,
        'Stop dictation',
      );
      // The divergence, asserted rather than described: there is no stream, so
      // the waveform stays on its resting branch even while armed.
      expect(
        tester.widget<DsLiveWaveform>(_in('live', find.byType(DsLiveWaveform)))
            .samples,
        isNull,
      );
      expect(tester.getSize(pill), const Size(34, 34));
    });
  });

  /* ── Orb states ────────────────────────────────────────────────────────── */

  group('§orb', () {
    testWidgets('four cells, in the reference order, labelled by state',
        (WidgetTester tester) async {
      await tester.pumpVoicePage();
      expect(_in('orb', find.byType(DsVoiceOrb)), findsNWidgets(4));
      for (final String label in <String>[
        'idle',
        'listening',
        'thinking',
        'talking',
      ]) {
        expect(_in('orb', _copy(label.toUpperCase())), findsOneWidget);
      }
    });

    testWidgets('every orb is 112px and carries its own phase',
        (WidgetTester tester) async {
      await tester.pumpVoicePage();
      final List<DsVoiceOrb> orbs = tester
          .widgetList<DsVoiceOrb>(_in('orb', find.byType(DsVoiceOrb)))
          .toList();
      expect(orbs, hasLength(4));
      for (final DsVoiceOrb orb in orbs) {
        expect(orb.size, 112);
        expect(tester.getSize(find.byWidget(orb)), const Size(112, 112));
        // PROBE 3: with no level there is nothing to react to, which is why
        // the four look alike in the reference too.
        expect(orb.level, isNull);
      }
      // …and yet no two are in phase, which is the only thing that separates
      // them upstream.
      final Set<int?> seeds = orbs.map((DsVoiceOrb o) => o.seed).toSet();
      expect(seeds, hasLength(4));
      final Set<double> firstOffsets = <double>{
        for (final DsVoiceOrb orb in orbs)
          DsVoiceOrb.offsetsForSeed(orb.seed!).first,
      };
      expect(firstOffsets, hasLength(4));
    });

    testWidgets('the states are carried even though nothing reads them here',
        (WidgetTester tester) async {
      await tester.pumpVoicePage();
      final List<DsOrbState> states = tester
          .widgetList<DsVoiceOrb>(_in('orb', find.byType(DsVoiceOrb)))
          .map((DsVoiceOrb o) => o.state)
          .toList();
      expect(states, <DsOrbState>[
        DsOrbState.idle,
        DsOrbState.listening,
        DsOrbState.thinking,
        DsOrbState.talking,
      ]);
    });
  });

  /* ── The two contract sections ─────────────────────────────────────────── */

  group('§dictation and §speech', () {
    testWidgets('the dictation contract lists all seven rows',
        (WidgetTester tester) async {
      await tester.pumpVoicePage();
      final DsMeta meta = tester.widget<DsMeta>(_in('dictation', find.byType(DsMeta)));
      expect(meta.items.map((DsMetaItem i) => i.k), <String>[
        'isSupported',
        'isListening',
        'level',
        'analyser',
        'devices / deviceId / setDeviceId',
        'start / stop / toggle',
        'error',
      ]);
    });

    testWidgets('§speech is a Note, not a specimen', (WidgetTester tester) async {
      await tester.pumpVoicePage();
      expect(_in('speech', find.byType(DsNote)), findsOneWidget);
      expect(
        tester.widget<DsNote>(_in('speech', find.byType(DsNote))).title,
        'Markdown is not speakable',
      );
    });
  });

  /* ── The page's own frame ──────────────────────────────────────────────── */

  group('the page frame', () {
    testWidgets('the eyebrow carries the reference drift',
        (WidgetTester tester) async {
      await tester.pumpVoicePage();
      final DsPageHeader header =
          tester.widget<DsPageHeader>(find.byType(DsPageHeader));
      // DRIFT 1.
      expect(header.eyebrow, 'Agent · Components');
      expect(header.title, 'Voice');
    });

    testWidgets('the four sections are in the nav order and nothing is missing',
        (WidgetTester tester) async {
      await tester.pumpVoicePage();
      for (final String id in _sectionOracle.keys) {
        expect(_section(id), findsOneWidget, reason: '#$id is missing');
      }
      expect(find.byType(DsSection), findsNWidgets(_sectionOracle.length));
    });

    testWidgets('the opening note is the value tone, above the first section',
        (WidgetTester tester) async {
      await tester.pumpVoicePage();
      final DsNote note = tester.widgetList<DsNote>(find.byType(DsNote)).first;
      expect(note.tone, DsNoteTone.value);
      expect(note.title, 'This specimen opens your microphone');
    });
  });
}
