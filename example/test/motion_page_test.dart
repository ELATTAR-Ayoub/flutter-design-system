/// The motion page's contract: every specimen is a clock, one counter replays
/// sixteen of them, three loop forever and are deliberately not replayable, and
/// with motion switched off each one freezes on the frame its own
/// `animation-fill-mode` names — which for `.anim-sign-on` is *lit*.
///
/// Nothing here settles. Three demos animate forever, so `pumpAndSettle` would
/// hang rather than fail; every frame below is pumped explicitly, and the tests
/// that are not about timing run under `disableAnimations`, which is this
/// port's `prefers-reduced-motion: reduce`.
library;

import 'dart:io';
import 'dart:typed_data';

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/kit.dart';
import 'package:example/nav.dart';
import 'package:example/pages/motion.dart';
import 'package:example/shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FontLoader;
import 'package:flutter_test/flutter_test.dart';

/// The design frame, tall enough that the whole page is laid out *and*
/// hit-testable at once — the replay buttons are tapped for real.
const Size _desktop = Size(1440, 6400);

/// `h-28` — the `<svg>` viewport an easing graph is drawn inside.
final double _graphHeight = ds(28);

/// `h-4 w-0.5` — the ratchet's needle, and the only box on the page with both
/// of these measures.
final double _needleWidth = ds(0.5);
final double _needleHeight = ds(4);

/// The sixteen elements the run counter keys, in the reference's own spelling
/// (motion-map §11). The three infinite demos are absent, and their absence is
/// the assertion: a loop has nothing to replay.
Set<String> _keysAt(int run) => <String>{
      for (final String token in <String>[
        '--duration-tick',
        '--duration-fast',
        '--duration-base',
        '--duration-slow',
        '--duration-overlay',
        '--duration-reward',
      ])
        '$token-$run',
      for (final String token in <String>[
        '--ease-spring',
        '--ease-out',
        '--ease-in-out',
        '--ease-out-flex',
      ])
        '$token-$run',
      'pop-$run',
      'jelly-$run',
      'springup-$run',
      'jellyin-$run',
      'sign-$run',
      'reveal-$run',
    };

extension on WidgetTester {
  /// Sizes the viewport in logical pixels, so `MediaQuery` breakpoints read the
  /// numbers the CSS media queries would.
  void useViewport(Size size) {
    view.devicePixelRatio = 1;
    view.physicalSize = size;
    addTearDown(view.resetPhysicalSize);
    addTearDown(view.resetDevicePixelRatio);
  }

  /// The page as the shell mounts it.
  ///
  /// [reduceMotion] goes *below* [MaterialApp], which installs its own
  /// [MediaQuery] from the view and would otherwise win. It defaults to true:
  /// the ratchet, the shimmer and the live dot never stop, so a tree that runs
  /// them cannot be settled, and every assertion that is not about timing is
  /// cheaper and steadier against the page at rest. The timing tests pass
  /// `false` and pump named durations by hand.
  Future<void> pumpMotionPage({
    DsThemeMode mode = DsThemeMode.dark,
    bool reduceMotion = true,
  }) async {
    useViewport(_desktop);
    await pumpWidget(
      DsTheme(
        controller: DsThemeController(mode: mode),
        child: AppRouterScope(
          router: AppRouter(route: '$dsRoot/motion'),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Builder(
              builder: (BuildContext context) => MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(disableAnimations: reduceMotion),
                // The shell's own scroll view: the page is far taller than any
                // viewport, and a `SingleChildScrollView` lays all of it out.
                child: const SingleChildScrollView(child: MotionPage()),
              ),
            ),
          ),
        ),
      ),
    );
    // One frame to build; one more so every player has resolved its clock.
    await pump();
    await pump(Duration.zero);
  }

  /// The page inside the **real** [DocsShell] at the reference's own frame.
  ///
  /// The copy tests above mount [MotionPage] bare, which is cheaper and lets
  /// the whole page be hit-tested at once; vertical parity cannot be measured
  /// that way, because the reading column is only 1080px wide once the 240px
  /// rail and the shell's `lg:px-12` gutters have taken their share.
  Future<void> pumpMotionShell({DsThemeMode mode = DsThemeMode.light}) async {
    useViewport(_shellFrame);
    final DsThemeController theme = DsThemeController(mode: mode);
    final AppRouter router = AppRouter(route: '$dsRoot/motion');
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
                child: const DocsShell(
                  route: '$dsRoot/motion',
                  child: MotionPage(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    // The shell's own sliding pill measures after layout, so its first paint
    // is a frame behind everything else. Still never settled: three demos on
    // this page animate forever.
    await pump();
    await pump(const Duration(milliseconds: 500));
  }
}

/// Every `ValueKey<String>` the page hangs on a [KeyedSubtree] — which is the
/// replay mechanism, and nothing else.
Set<String> _runKeys(WidgetTester tester) => tester
    .widgetList<KeyedSubtree>(find.byType(KeyedSubtree))
    .map((KeyedSubtree subtree) => subtree.key)
    .whereType<ValueKey<String>>()
    .map((ValueKey<String> key) => key.value)
    .toSet();

/// The six `ds-sweep` bars' width factors, in row order.
List<double> _sweepFactors(WidgetTester tester) => tester
    .widgetList<FractionallySizedBox>(find.byType(FractionallySizedBox))
    .map((FractionallySizedBox bar) => bar.widthFactor!)
    .toList();

/// The `.anim-ratchet` needle: `block h-4 w-0.5 bg-action-bright`.
final Finder _needle = find.byWidgetPredicate(
  (Widget widget) =>
      widget is SizedBox &&
      widget.width == _needleWidth &&
      widget.height == _needleHeight,
);

/* ── Vertical parity ─────────────────────────────────────────────────────── */

/// The frame the reference is measured against — and the one the shell's
/// `lg:` breakpoints are written for.
const Size _shellFrame = Size(1440, 900);

/// Half a rendered pixel either way would be tighter, but the oracle is quoted
/// to one decimal off `getBoundingClientRect()` and Chrome quantises its own
/// layout to a 1/64px grid.
const double _parityTolerance = 2;

/// One section's border box on the web, in document coordinates.
typedef _WebBox = ({double top, double height});

/// The same box in Flutter, in the reading column's own coordinates.
typedef _SectionBox = ({double top, double height});

/// The reference's own per-section geometry, measured live at 1440×900, light,
/// fonts loaded, with `getBoundingClientRect()` on each `<section>`.
///
/// Insertion order is the page's own, which is what the rhythm test walks.
const Map<String, _WebBox> _oracle = <String, _WebBox>{
  'durations': (top: 555.9, height: 713.7),
  'easing': (top: 1349.6, height: 754.1),
  'interaction': (top: 2183.7, height: 735.2),
  'named': (top: 2998.8, height: 923.0),
  'choreography': (top: 4001.8, height: 435.8),
  'reduced': (top: 4517.6, height: 390.3),
  'rules': (top: 4987.9, height: 302.3),
};

Future<void> _loadFont(String family, String file) async {
  final ByteData bytes = ByteData.sublistView(
    File('../assets/fonts/$file').readAsBytesSync(),
  );
  final FontLoader loader = FontLoader('packages/elattar_design_system/$family')
    ..addFont(Future<ByteData>.value(bytes));
  await loader.load();
}

/// The reading column — `main > div.mx-auto.max-w-(--width-content)`, which is
/// the page widget's own box and the origin every measurement below uses.
RenderBox _column(WidgetTester tester) =>
    tester.renderObject<RenderBox>(find.byType(MotionPage));

/// One `DsSection`'s box, in the column's coordinates.
///
/// The height subtracts `mb-20`: a `DsSection` renders as a [Padding] carrying
/// its own bottom margin, so its render box is 80px taller than the `<section>`
/// border box the browser measures. The gap belongs between two sections, not
/// inside one, which is what the rhythm test asserts separately.
_SectionBox _sectionBox(WidgetTester tester, String id) {
  final RenderBox box = DsSection.anchorKey(id).currentContext!
      .findRenderObject()! as RenderBox;
  return (
    top: box.localToGlobal(Offset.zero, ancestor: _column(tester)).dy,
    height: box.size.height - ds(20),
  );
}

/// The four `CurveGraph` SVGs, found by the accessible name they carry.
Iterable<String> _graphLabels(WidgetTester tester) => tester
    .widgetList<Semantics>(find.byType(Semantics))
    .map((Semantics node) => node.properties.label)
    .whereType<String>()
    .where((String label) => label.startsWith('Easing curve'));

void main() {
  group('structure and copy', () {
    testWidgets('the header places the page and names its six chips', (
      WidgetTester tester,
    ) async {
      await tester.pumpMotionPage();

      expect(find.text('FOUNDATIONS'), findsOneWidget);
      expect(find.text('Motion'), findsOneWidget);
      expect(
        find.text(
          'Durations, easing curves and the named animations — each one '
          'running live so timing can be judged, not guessed.',
        ),
        findsOneWidget,
      );

      // DRIFT D13: six chips, seven sections. Three chips do not name their
      // section and `#rules` has no chip at all — the registry's strings ship
      // exactly as registered.
      for (final String chip in <String>[
        'Durations',
        'Easing',
        'Interaction utilities',
        'Named animations',
        'Reveal choreography',
        'Reduced motion',
      ]) {
        expect(find.text(chip), findsWidgets, reason: 'chip "$chip"');
      }
      expect(find.text('Interaction utilities'), findsOneWidget);
      expect(find.text('Reveal choreography'), findsOneWidget);
      // …and the sections those two chips are pointing at are titled
      // something else entirely.
      expect(find.text('The click feel'), findsOneWidget);
      expect(find.text('Pack-opening choreography'), findsOneWidget);
      expect(find.text('Rules'), findsOneWidget);
    });

    testWidgets('the standing note says everything here is live', (
      WidgetTester tester,
    ) async {
      await tester.pumpMotionPage();

      // A `Note` title is always `--muted-foreground`, never tone ink, and
      // `.type-label` uppercases it.
      expect(find.text('EVERYTHING ON THIS PAGE IS LIVE'), findsOneWidget);
      expect(
        find.text(
          'Timings are judged, not read. Hover the interaction demos and use '
          'the replay buttons to re-run the entrances. If your system is set '
          'to reduce motion, every animation here collapses to near-zero — '
          'which is the correct behaviour, not a bug.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('the duration scale prints six tokens, out of order', (
      WidgetTester tester,
    ) async {
      await tester.pumpMotionPage();

      expect(find.text('SAME DISTANCE, SIX SPEEDS'), findsOneWidget);
      // The panel note is the live read-out of the replay counter.
      expect(find.text('run 0'), findsOneWidget);

      const List<String> tokens = <String>[
        '--duration-tick',
        '--duration-fast',
        '--duration-base',
        '--duration-slow',
        '--duration-overlay',
        '--duration-reward',
      ];
      for (final String token in tokens) {
        expect(find.text(token), findsOneWidget);
      }

      // Array order, which is NOT ascending: 400 sits above 320. Kept.
      final List<String> printed = tester
          .widgetList<Text>(find.byType(Text))
          .map((Text text) => text.data)
          .whereType<String>()
          .where((String text) => RegExp(r'^\d+ms$').hasMatch(text))
          .toList();
      expect(printed, <String>['80ms', '150ms', '250ms', '400ms', '320ms',
          '550ms']);

      // DRIFT D3: the description promises 350ms; `--duration-overlay` is 320
      // and no 350ms token exists.
      expect(
        find.textContaining('overlays get up to 350ms', findRichText: true),
        findsOneWidget,
      );
      expect(DsDurations.overlay.inMilliseconds, 320);

      // The use copy, spliced out of a mono span and a sentence.
      expect(
        find.textContaining(
          'The machine beat. A press registers in this long',
          findRichText: true,
        ),
        findsOneWidget,
      );
    });

    testWidgets('the four easing panels print their curve verbatim', (
      WidgetTester tester,
    ) async {
      await tester.pumpMotionPage();

      // The panel label is `.type-label`, so the token uppercases…
      for (final String token in <String>[
        '--EASE-SPRING',
        '--EASE-OUT',
        '--EASE-IN-OUT',
        '--EASE-OUT-FLEX',
      ]) {
        expect(find.text(token), findsOneWidget);
      }
      // …and the printed string is `.type-num-sm`, so it does not: spaces
      // after commas, `1` and not `1.0`, exactly as authored.
      for (final String curve in <String>[
        'cubic-bezier(0.34, 1.56, 0.64, 1)',
        'cubic-bezier(0.22, 1, 0.36, 1)',
        'cubic-bezier(0.65, 0, 0.35, 1)',
        'cubic-bezier(0.05, 0.6, 0.4, 0.9)',
      ]) {
        expect(find.text(curve), findsOneWidget);
      }

      // The accessible name, `pts.join(", ")`, with JS's integer printing.
      expect(_graphLabels(tester), <String>[
        'Easing curve 0.34, 1.56, 0.64, 1',
        'Easing curve 0.22, 1, 0.36, 1',
        'Easing curve 0.65, 0, 0.35, 1',
        'Easing curve 0.05, 0.6, 0.4, 0.9',
      ]);

      // DRIFT D4: `--ease-standard` is named by the description and is not one
      // of the four panels.
      expect(
        find.textContaining('things you operate use ease-standard',
            findRichText: true),
        findsOneWidget,
      );
      expect(find.text('--EASE-STANDARD'), findsNothing);
    });

    testWidgets('the click feel shows three utilities at their real numbers', (
      WidgetTester tester,
    ) async {
      await tester.pumpMotionPage();

      expect(find.text('.CLICK-SPRING'), findsOneWidget);
      expect(find.text('.PRESS-SPRING'), findsOneWidget);
      expect(find.text('.PRESS-KEY'), findsOneWidget);
      expect(find.text('.LIFT — CARDS AND PACKS'), findsOneWidget);

      // DRIFT D2. The section description promises 40/250 for the family…
      expect(
        find.textContaining('40ms down, 250ms spring back', findRichText: true),
        findsOneWidget,
      );
      // …while the panel notes, on this same page, are accurate per utility.
      expect(find.text('40ms down · scale 0.9'), findsOneWidget);
      expect(find.text('40ms down · scale 0.92'), findsOneWidget);
      expect(find.text('80ms linear · 3px travel'), findsOneWidget);
      // And the demos run the real numbers: 220ms, not 250.
      expect(DsDurations.pressSpringUp.inMilliseconds, 220);

      expect(find.text('Press and hold'), findsNWidgets(3));
      expect(find.text('Hover me'), findsOneWidget);
      expect(find.text('CONTENT BOUNCES; CONTROLS CLICK'), findsOneWidget);
      expect(
        find.textContaining('Yuki’s governing rule', findRichText: true),
        findsOneWidget,
      );
    });

    testWidgets('the nine named animations render in order, notes and all', (
      WidgetTester tester,
    ) async {
      await tester.pumpMotionPage();

      const List<(String, String)> panels = <(String, String)>[
        ('.ANIM-POP-IN', '550ms · from 25%'),
        ('.ANIM-JELLY', '600ms · squash & stretch'),
        ('.ANIM-SPRING-UP', '800ms · settle'),
        ('.ANIM-JELLY-IN', '420ms · spring'),
        ('.ANIM-RATCHET', '1.4s · steps(8)'),
        ('.ANIM-SIGN-ON', '900ms · TEXT only'),
        ('.ANIM-REVEAL', '550ms · our own'),
        ('.ANIM-SHIMMER', '1.4s loop · our own'),
        ('.ANIM-PULSE-LIVE', '2s loop · our own'),
      ];
      for (final (String label, String note) in panels) {
        expect(find.text(label), findsOneWidget, reason: label);
        expect(find.text(note), findsOneWidget, reason: note);
      }

      // The demo contents.
      expect(find.text('Jelly pop'), findsOneWidget);
      expect(find.text(r'+$1,240'), findsOneWidget);
      expect(find.text('Section entering'), findsOneWidget);
      expect(find.text('Screen entering'), findsOneWidget);
      expect(find.text('LEGENDARY'), findsOneWidget);
      expect(_needle, findsOneWidget);
      // `.type-micro` uppercases the live pill's label.
      expect(find.text('LIVE'), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (Widget widget) =>
              widget is DsIcon && widget.glyph == DsIconGlyph.sparkles,
        ),
        findsOneWidget,
      );

      // Nineteen clocks: six sweeps, four travels, nine named — and exactly
      // three of them loop, which is exactly the three with no fill mode.
      final List<DsKeyframePlayer> players = tester
          .widgetList<DsKeyframePlayer>(find.byType(DsKeyframePlayer))
          .toList();
      expect(players, hasLength(19));
      final List<DsKeyframePlayer> loopers =
          players.where((DsKeyframePlayer p) => p.repeat).toList();
      expect(loopers, hasLength(3));
      expect(
        loopers.every((DsKeyframePlayer p) => p.fill == DsKeyframeFill.none),
        isTrue,
        reason: 'a looper declares no fill mode, so it reverts to stop 0',
      );
      expect(
        players
            .where((DsKeyframePlayer p) => !p.repeat)
            .every((DsKeyframePlayer p) => p.fill == DsKeyframeFill.both),
        isTrue,
        reason: 'every finite animation on this page declares `both`',
      );
    });

    testWidgets('the choreography Meta is eight static stages', (
      WidgetTester tester,
    ) async {
      await tester.pumpMotionPage();

      for (final String stage in <String>[
        '1 · Pack selected',
        '2 · Purchase confirmed',
        '3 · Pack enters',
        '4 · Tear',
        '5 · Cards reveal',
        '6 · Rare escalation',
        '7 · Summary',
        'Skip / Turbo',
      ]) {
        expect(find.text(stage), findsOneWidget, reason: stage);
      }

      // DRIFT D11: 550 + 5×60 is 850ms. The copy's own arithmetic, kept.
      expect(
        find.textContaining('resolve in roughly 900ms', findRichText: true),
        findsOneWidget,
      );
      // DRIFT D12: 300ms is not a duration token.
      expect(
        find.textContaining('stages 3–6 to 300ms total', findRichText: true),
        findsOneWidget,
      );
    });

    testWidgets('the reduced-motion panel lists five bullets and a chip', (
      WidgetTester tester,
    ) async {
      await tester.pumpMotionPage();

      expect(
        find.text('WHAT PREFERS-REDUCED-MOTION: REDUCE DOES'),
        findsOneWidget,
      );
      expect(
        find.text('All durations and transitions collapse to 0.01ms.'),
        findsOneWidget,
      );
      // DRIFT D10: only `forwards`/`both` hold, and all three loopers on this
      // page declare no fill mode at all. Copy verbatim; mechanism per demo.
      expect(
        find.text('Looping animations run exactly once, then hold.'),
        findsOneWidget,
      );
      expect(
        find.text(
          'Nothing is hidden or removed. No information exists only inside an '
          'animation.',
        ),
        findsOneWidget,
      );
      expect(
        find.textContaining('so a new component inherits it',
            findRichText: true),
        findsOneWidget,
      );
      expect(
        tester
            .widgetList<DsCode>(find.byType(DsCode))
            .where((DsCode code) => code.chip == 'app/globals.css'),
        isNotEmpty,
      );
    });

    testWidgets('the rules pair ships four dos and four donts, drift included',
        (WidgetTester tester) async {
      await tester.pumpMotionPage();

      expect(find.text('DO'), findsOneWidget);
      expect(find.text('DON’T'), findsOneWidget);

      // DRIFT D7: 100 and 200 are not tokens; 80 and 400 are, and are tabled
      // three sections above on this very page.
      expect(
        find.text(
          'Use a duration token — 100, 150, 200, 250, 320 or 550ms. Nothing in '
          'between.',
        ),
        findsOneWidget,
      );
      // DRIFT D5/D6: the `--ease-spring` use copy on this page calls it "THE
      // curve … every press release".
      expect(
        find.text(
          'Reserve ease-spring for reward moments; it reads as celebration.',
        ),
        findsOneWidget,
      );
      expect(
        find.textContaining('Every press release', findRichText: true),
        findsOneWidget,
      );
      // DRIFT D8: six animations on this page run longer than 550ms.
      expect(
        find.text(
          "Don't animate anything for longer than 550ms outside the opening "
          'sequence.',
        ),
        findsOneWidget,
      );
      // DRIFT D9: `anim-sign-on` is exactly the behaviour this rule names.
      expect(
        find.text(
          "Don't flash, strobe or rapidly alternate brightness; it is an "
          'accessibility hazard.',
        ),
        findsOneWidget,
      );
      expect(DsSignOn.frames, hasLength(6));
    });

    testWidgets('the foot nav sits between shadows and icons', (
      WidgetTester tester,
    ) async {
      await tester.pumpMotionPage();

      expect(find.text('PREVIOUS'), findsOneWidget);
      expect(find.text('Shadows'), findsOneWidget);
      expect(find.text('NEXT'), findsOneWidget);
      expect(find.text('Icons'), findsOneWidget);
    });
  });

  group('the curve graph', () {
    testWidgets('letterboxes to a 65px square rather than filling its box', (
      WidgetTester tester,
    ) async {
      await tester.pumpMotionPage();

      // The reference's own 482 × 112 panel, landmark for landmark
      // (motion-map §4.1). `meet` is height-bound here, so the 100×100 unit box
      // renders 65.116px square with its left edge 208.44px into the panel.
      final Rect box = MotionPage.debugCurveBox(const Size(482, 112));
      expect(box.left, moreOrLessEquals(208.4419, epsilon: 0.01));
      expect(box.top, moreOrLessEquals(37.7674, epsilon: 0.01));
      expect(box.right, moreOrLessEquals(273.5581, epsilon: 0.01));
      expect(box.bottom, moreOrLessEquals(102.8837, epsilon: 0.01));
      expect(box.width, moreOrLessEquals(65.1163, epsilon: 0.01));
      expect(box.height, moreOrLessEquals(box.width, epsilon: 1e-9));

      // …and the painter really is mounted at `h-28` full width, so the square
      // is adrift in it rather than stretched to it.
      final Finder painted = find.descendant(
        of: find.byWidgetPredicate(
          (Widget widget) =>
              widget is Semantics &&
              (widget.properties.label?.startsWith('Easing curve') ?? false),
        ),
        matching: find.byType(CustomPaint),
      );
      expect(painted, findsNWidgets(4));
      final Size viewport = tester.getSize(painted.first);
      expect(viewport.height, _graphHeight);
      expect(
        MotionPage.debugCurveBox(viewport).width / viewport.width,
        lessThan(0.2),
        reason: 'roughly 85% of the SVG is empty; a painter that fills its '
            'box is visibly wrong',
      );
    });
  });

  group('replay', () {
    testWidgets('one counter keys sixteen elements and no looper', (
      WidgetTester tester,
    ) async {
      await tester.pumpMotionPage();

      expect(_runKeys(tester), _keysAt(0));
      expect(_runKeys(tester), hasLength(16));
      // The three infinite demos are absent from that set, and their absence
      // is the point: a looping animation has nothing to replay.
      for (final String never in <String>['ratchet', 'shimmer', 'pulse']) {
        expect(
          _runKeys(tester).any((String key) => key.startsWith(never)),
          isFalse,
          reason: '$never is unkeyed on purpose',
        );
      }
    });

    testWidgets('any of the three buttons re-runs every keyed demo', (
      WidgetTester tester,
    ) async {
      // Real time, so the bars can actually finish and be seen to restart.
      await tester.pumpMotionPage(reduceMotion: false);

      // t = 0: nothing has swept.
      expect(_sweepFactors(tester), hasLength(6));
      expect(_sweepFactors(tester).every((double f) => f == 0), isTrue);

      // Past the longest of the six, so all of them hold `to`.
      await tester.pump(DsDurations.reward);
      await tester.pump(const Duration(milliseconds: 16));
      expect(
        _sweepFactors(tester).every((double f) => f == 1),
        isTrue,
        reason: 'ds-sweep fills `both`, so a finished bar holds full width',
      );

      // "Replay curves" lives in `#easing`, three sections below the bars —
      // and restarts them anyway. There is no per-section scoping.
      await tester.tap(find.text('Replay curves'));
      await tester.pump();

      expect(find.text('run 1'), findsOneWidget);
      expect(_runKeys(tester), _keysAt(1));
      expect(
        _sweepFactors(tester).every((double f) => f == 0),
        isTrue,
        reason: 'a re-keyed element remounts, and a fresh player starts at t=0',
      );

      // The other two buttons drive the same counter.
      await tester.tap(find.text('Replay'));
      await tester.pump();
      expect(find.text('run 2'), findsOneWidget);

      await tester.tap(find.text('Replay all'));
      await tester.pump();
      expect(find.text('run 3'), findsOneWidget);
      expect(_runKeys(tester), _keysAt(3));
    });

    testWidgets('a demo caught mid-flight restarts rather than continuing', (
      WidgetTester tester,
    ) async {
      await tester.pumpMotionPage(reduceMotion: false);

      // Half way through `--duration-base`'s 250ms bar, which is row three.
      await tester.pump(const Duration(milliseconds: 120));
      final double midFlight = _sweepFactors(tester)[2];
      expect(midFlight, greaterThan(0));
      expect(midFlight, lessThan(1));

      await tester.tap(find.text('Replay'));
      await tester.pump();
      expect(_sweepFactors(tester)[2], 0);
    });
  });

  group('live', () {
    testWidgets('sign-on opens dark and unlit, then holds the 70% frame', (
      WidgetTester tester,
    ) async {
      await tester.pumpMotionPage(reduceMotion: false);

      // The 0% stop: opacity 0.12, `text-shadow: none`, brightness 0.5. Six
      // hard cuts follow — `steps(1, end)` between every pair, so nothing
      // tweens.
      expect(tester.widget<Text>(find.text('LEGENDARY')).style!.shadows,
          isEmpty);
      expect(
        tester
            .widget<Opacity>(find.ancestor(
              of: find.text('LEGENDARY'),
              matching: find.byType(Opacity),
            ))
            .opacity,
        DsSignOn.frames.first.opacity,
      );

      // Past the run, `both` holds the 70% frame — and holds it for good.
      await tester.pump(DsSignOn.duration);
      await tester.pump(const Duration(milliseconds: 16));
      expect(tester.widget<Text>(find.text('LEGENDARY')).style!.shadows,
          hasLength(2));
    });

    testWidgets('jelly-in clamps the opacity its spring overshoots', (
      WidgetTester tester,
    ) async {
      await tester.pumpMotionPage(reduceMotion: false);

      // `--ease-spring`'s 1.56 control point carries the interpolated `0 → 1`
      // opacity **above 1** for most of the first 60%. The track keeps the
      // overshoot, because the same curve drives the scale and the rise where
      // the overshoot is the whole animation; the property clamps it, which is
      // what CSS does at used-value time.
      expect(DsJellyIn.opacity.transform(0.3), greaterThan(1));

      // 30% of `--duration-jelly`, well inside the band where it overshoots.
      await tester.pump(const Duration(milliseconds: 126));
      expect(
        tester
            .widget<Opacity>(find.ancestor(
              of: find.text('Screen entering'),
              matching: find.byType(Opacity),
            ))
            .opacity,
        1,
      );
    });
  });

  group('reduced motion', () {
    testWidgets('every bar freezes full width — the section undone by design', (
      WidgetTester tester,
    ) async {
      await tester.pumpMotionPage();

      // `ds-sweep` fills `both`, and the blanket rule touches neither fill mode
      // nor delay: all six hold `to`, identically, and the panel that exists to
      // show six different speeds shows one.
      expect(_sweepFactors(tester), <double>[1, 1, 1, 1, 1, 1]);

      // Still true a second later: the clock is stopped, not merely fast.
      await tester.pump(const Duration(seconds: 1));
      expect(_sweepFactors(tester), <double>[1, 1, 1, 1, 1, 1]);
    });

    testWidgets('sign-on freezes lit, on the 70% frame it holds forever', (
      WidgetTester tester,
    ) async {
      await tester.pumpMotionPage();

      final Text legendary = tester.widget<Text>(find.text('LEGENDARY'));
      // The 70% stop: `text-shadow: 0 0 6px currentColor, 0 0 18px
      // currentColor` at brightness 1.15. Not a neutral resting state.
      expect(legendary.style!.shadows, hasLength(2));
      expect(
        legendary.style!.shadows!.first.blurRadius,
        moreOrLessEquals(DsSignOn.blurRadiusFor(6), epsilon: 1e-9),
      );
      expect(
        legendary.style!.shadows!.last.blurRadius,
        moreOrLessEquals(DsSignOn.blurRadiusFor(18), epsilon: 1e-9),
      );

      final Opacity fade = tester.widget<Opacity>(
        find.ancestor(
          of: find.text('LEGENDARY'),
          matching: find.byType(Opacity),
        ),
      );
      expect(fade.opacity, 1);

      // …and the filter really is the 70% frame's, not the 0% frame's.
      final ColorFiltered filtered = tester.widget<ColorFiltered>(
        find.ancestor(
          of: find.text('LEGENDARY'),
          matching: find.byType(ColorFiltered),
        ),
      );
      expect(filtered.colorFilter, DsSignOn.frames.last.brightnessFilter);
      expect(DsSignOn.frames.last.percent, 70);
    });

    testWidgets('the entrances resolve to their final state', (
      WidgetTester tester,
    ) async {
      await tester.pumpMotionPage();

      // `.anim-pop-in` and `.anim-reveal` carry a belt-and-braces special case
      // in the blanket rule (`opacity: 1; transform: none !important`) that the
      // `both` fill already delivers: the final stop *is* opacity 1 and
      // identity. The other two hold their last stop for the same reason.
      for (final String demo in <String>[
        'Jelly pop',
        'Section entering',
        'Screen entering',
      ]) {
        final Opacity fade = tester.widget<Opacity>(
          find.ancestor(
            of: find.text(demo),
            matching: find.byType(Opacity),
          ),
        );
        expect(fade.opacity, 1, reason: demo);
      }

      // …and no rotateY flash. `.anim-reveal` starts at `rotateY(-38deg)
      // scale(0.9)`, which — orthographically, with no perspective anywhere
      // (ruling M4) — would paint its 24px glyph 17.0 × 21.6. Frozen on the
      // `to` stop it measures 24 square, on the nose.
      final Rect sparkles = tester.getRect(
        find.byWidgetPredicate(
          (Widget widget) =>
              widget is DsIcon && widget.glyph == DsIconGlyph.sparkles,
        ),
      );
      final double xl = DsIcon.pxFor(DsIconSize.xl);
      expect(sparkles.width, moreOrLessEquals(xl, epsilon: 0.01));
      expect(sparkles.height, moreOrLessEquals(xl, epsilon: 0.01));
    });

    testWidgets('the loopers revert to stop 0 rather than holding', (
      WidgetTester tester,
    ) async {
      await tester.pumpMotionPage();

      // The ratchet has no fill mode, so one collapsed iteration leaves it on
      // the element's own transform: 0°, not 315° and not the 360° frame
      // `steps(8, jump-end)` never displays (ruling M7). At 0° the 2×16 needle
      // still measures 2×16 in the page's own coordinates; at any other stop
      // its bounding box would be square-ish.
      Rect needle = tester.getRect(_needle);
      expect(needle.width, moreOrLessEquals(_needleWidth, epsilon: 0.01));
      expect(needle.height, moreOrLessEquals(_needleHeight, epsilon: 0.01));

      // Frozen, not merely slow: a second later it has not stepped.
      await tester.pump(const Duration(seconds: 2));
      needle = tester.getRect(_needle);
      expect(needle.width, moreOrLessEquals(_needleWidth, epsilon: 0.01));
      expect(needle.height, moreOrLessEquals(_needleHeight, epsilon: 0.01));
      expect(DsRatchet.degreesAt(0), 0);

      // The other two loopers are configured the same way, and their frozen
      // frames follow from it: the shimmer's tile sits one whole period left of
      // the box (which repeats to the same pixels as `background-position: 0`),
      // and the live dot's ring is exactly the dot's own radius, hidden behind
      // it, at full opacity.
      expect(DsShimmer.fill, DsKeyframeFill.none);
      expect(DsPulseLive.fill, DsKeyframeFill.none);
      expect(DsPulseLive.ringRadiusAt(0), DsPulseLive.dotRadius);
      expect(DsPulseLive.dotOpacityAt(0), 1);
    });

    testWidgets('the travel chips were already still — nothing to freeze', (
      WidgetTester tester,
    ) async {
      await tester.pumpMotionPage();

      // DRIFT D1, ruling M1. `translateX(calc(100% − 1.5rem))` on a `size-6`
      // element is `24px − 24px`, and the reduced-motion freeze holds `to`,
      // which is the same zero. Verified live on the reference: all four chips
      // hold `matrix(1,0,0,1,0,0)` for the whole run.
      expect(DsTravel.distanceFor(ds(6)), 0);
      for (final Cubic curve in <Cubic>[
        DsCurves.spring,
        DsCurves.out,
        DsCurves.inOut,
        DsCurves.outFlex,
      ]) {
        for (final double t in <double>[0, 0.25, 0.5, 0.75, 1]) {
          expect(
            DsTravel.translationAt(t, ds(6), curve: curve),
            0,
            reason: 'the chip never moves, at any t, under any curve',
          );
        }
      }
    });

    testWidgets('the press demos still squish — they just teleport', (
      WidgetTester tester,
    ) async {
      await tester.pumpMotionPage();

      // The blanket rule collapses `transition-duration`; it does not disable
      // the state change. Three [DsPress] surfaces plus one on each foot-nav
      // card, and all of them still respond.
      expect(find.byType(DsPress), findsWidgets);

      final Finder key = find.text('Press and hold').last;
      final Offset centre = tester.getCenter(key);
      final TestGesture gesture = await tester.startGesture(centre);
      await tester.pump();
      // `press-key` travels 3px down into its socket, instantly.
      expect(tester.getCenter(key).dy - centre.dy, DsTransforms.keyDownY);

      await gesture.up();
      await tester.pump();
      expect(tester.getCenter(key).dy, moreOrLessEquals(centre.dy));
    });
  });

  group('themes', () {
    testWidgets('light renders the same page, re-inked', (
      WidgetTester tester,
    ) async {
      await tester.pumpMotionPage(mode: DsThemeMode.light);

      expect(tester.takeException(), isNull);

      // Same clocks, same demos, same copy.
      expect(find.byType(DsKeyframePlayer), findsNWidgets(19));
      expect(_runKeys(tester), _keysAt(0));
      expect(find.text('LEGENDARY'), findsOneWidget);
      expect(find.text('Press and hold'), findsNWidgets(3));
      expect(find.text('run 0'), findsOneWidget);
      expect(_graphLabels(tester), hasLength(4));

      // …and the ink flipped: a duration token prints `text-action-ink`, which
      // is #92C2FC on dark and #143694 here.
      expect(
        tester.widget<Text>(find.text('--duration-tick')).style!.color,
        DsThemeData.light.actionInk,
      );
      expect(DsThemeData.light.actionInk, isNot(DsThemeData.dark.actionInk));

      // `text-value-ink` flips too, and `.anim-sign-on`'s `currentColor` is
      // exactly that — the glow follows the theme rather than being frozen.
      final Text legendary = tester.widget<Text>(find.text('LEGENDARY'));
      expect(legendary.style!.color, DsThemeData.light.valueInk);
      expect(legendary.style!.shadows!.first.color, DsThemeData.light.valueInk);
    });

    testWidgets('dark inks the same specimens off the dark theme', (
      WidgetTester tester,
    ) async {
      await tester.pumpMotionPage();

      expect(
        tester.widget<Text>(find.text('--duration-tick')).style!.color,
        DsThemeData.dark.actionInk,
      );
      expect(
        tester.widget<Text>(find.text('LEGENDARY')).style!.color,
        DsThemeData.dark.valueInk,
      );
      // DRIFT D14: the live dot and the ring around it are different greens,
      // in both themes, and neither is themed.
      expect(DsPulseLive.dotColor, DsPalette.success);
      expect(DsPulseLive.ringColor, isNot(DsPulseLive.dotColor));
    });
  });

  group('vertical parity at the 1440 frame', () {
    // Real font binaries, loaded once for this group and only this group: the
    // test engine measures Ahem otherwise, and every height below is a text
    // measurement wearing a layout's clothes.
    setUpAll(() async {
      await _loadFont('InterLocal', 'InterVariable.ttf');
      await _loadFont('GeistMono', 'GeistMono-Variable.ttf');
      await _loadFont('Redaction35', 'Redaction35-Italic.ttf');
    });

    testWidgets('the reading column is --width-content wide', (
      WidgetTester tester,
    ) async {
      await tester.pumpMotionShell();

      // First, because every wrap point on the page — and therefore every
      // height in the oracle below — depends on this one number.
      expect(_column(tester).size.width, DsWidths.content);
    });

    testWidgets('the sections stack on an unbroken 80px rhythm', (
      WidgetTester tester,
    ) async {
      await tester.pumpMotionShell();

      // `DsSection`'s `mb-20`, seven times over. This holds today: the 28.8px
      // the page is currently long by is inside two section boxes, not in the
      // gaps between them.
      final List<String> ids = _oracle.keys.toList();
      for (int i = 1; i < ids.length; i++) {
        final _SectionBox above = _sectionBox(tester, ids[i - 1]);
        final _SectionBox below = _sectionBox(tester, ids[i]);
        expect(
          below.top - (above.top + above.height),
          moreOrLessEquals(ds(20), epsilon: _parityTolerance),
          reason: 'gap between #${ids[i - 1]} and #${ids[i]}',
        );
      }
    });

    testWidgets(
      'the whole stack lands where the reference lands',
      (WidgetTester tester) async {
        await tester.pumpMotionShell();

        // Every section height, every offset down the column, and the column
        // itself — the complete oracle, measured on the live reference at
        // 1440×900 (light; the two themes measure equal).
        for (final MapEntry<String, _WebBox> entry in _oracle.entries) {
          final _SectionBox got = _sectionBox(tester, entry.key);
          expect(
            got.height,
            moreOrLessEquals(entry.value.height, epsilon: _parityTolerance),
            reason: '#${entry.key} height',
          );
          expect(
            got.top - _sectionBox(tester, 'durations').top,
            moreOrLessEquals(
              entry.value.top - _oracle['durations']!.top,
              epsilon: _parityTolerance,
            ),
            reason: '#${entry.key} offset from #durations',
          );
        }

        // `main` measures 5455.2 tall and carries `lg:py-12` — 48 above and 48
        // below — so the reading column inside it is 5359.2.
        expect(
          _column(tester).size.height,
          moreOrLessEquals(5359.2, epsilon: _parityTolerance),
        );
      },
      // REGRESSION GUARD. This test ran 28.8px long until `_PanelStrip`
      // (`example/lib/kit.dart`) learned CSS `flex: 0 1 auto`. It had offered
      // each of its two runs *half* the strip, where CSS gives each its
      // content width and shrinks only once the line overflows — invisible on
      // the four full-width pages that came before, and 14.4px per grid row
      // here, because motion is the first page with three-up panels. On one
      // of those the strip is 307.33px, so each run was offered 145.67px, and
      // four notes are wider than that:
      //
      //   `40ms down · scale 0.9`     148.68  (#interaction)
      //   `40ms down · scale 0.92`    155.76  (#interaction)
      //   `80ms linear · 3px travel`  169.92  (#interaction)
      //   `600ms · squash & stretch`  169.92  (#named, row 1)
      //
      // Each wrapped to a second `.type-num-sm` line: #interaction +14.4,
      // #named +14.4. Nothing wraps in CSS — the widest pairing is roughly
      // 70 + 16 + 169.92 = 256px inside 307.33 — so the strip must never go
      // back to splitting itself evenly.
    );
  });
}
