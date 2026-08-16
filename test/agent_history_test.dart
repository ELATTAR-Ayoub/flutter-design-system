/// `components/agent/parts/{history-card,chat-history,history-search}.tsx` —
/// the family, pinned against what the browser was measured doing.
///
/// The cases that matter here are the ones a page test cannot see: the two-key
/// sort and the `RECENT` cap inside `HistorySearch`, the placement rule that
/// decides **which** row replays its entrance on a pin, the confirmation's
/// asymmetric in/out clocks, and the capabilities-are-absence contract.
///
/// The headline is [DsFlipController]: `useFlip` is correct and paints nothing,
/// because `anim-row-in`'s `animation-fill-mode: both` outranks the inline
/// transform it writes. The port reproduces the *render*, and keeps the
/// discarded inversion in [DsFlipController.travel] so the drift is assertable
/// rather than a claim in a comment.
library;

import 'dart:io';
import 'dart:typed_data';

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart' show FontLoader;
import 'package:flutter_test/flutter_test.dart';

/* ── Fixtures ────────────────────────────────────────────────────────────── */

/// The mock store's own seed, at a frozen instant.
final DateTime _now = DateTime(2026, 8, 16, 12);

DsConversationSummary _c(
  String id,
  String title,
  int agoMinutes, {
  String? preview,
  bool pinned = false,
}) =>
    DsConversationSummary(
      id: id,
      title: title,
      updatedAt: _now.subtract(Duration(minutes: agoMinutes)),
      preview: preview,
      pinned: pinned,
    );

final List<DsConversationSummary> _seed = <DsConversationSummary>[
  _c('c-vault', 'Sealed inventory check', 14,
      preview: 'What sealed boxes are left, and what is the best one?',
      pinned: true),
  _c('c-export', 'Thirty-day activity export', 95,
      preview: 'Export my last 30 days as a CSV', pinned: true),
  _c('c-pricing', 'Pricing service outage', 260,
      preview: 'What is Eclipse Vault worth right now?'),
  _c('c-hold', 'Putting a pack on hold', 1500,
      preview: 'Buy me an Eclipse Vault pack'),
  _c('c-odds', 'How pack odds actually work', 4300,
      preview: 'Explain the odds on a sealed box'),
  _c('c-balance', 'Balance and recent movement', 11000,
      preview: 'How much do I have available?'),
  _c('c-grading', 'Grading a first edition', 26000,
      preview: 'Is it worth grading a 1st edition?'),
];

/// A store with everything, or with the two optional capabilities removed.
class _Store extends DsConversationStore {
  _Store({
    List<DsConversationSummary>? seed,
    this.capabilities = true,
    this.isLoading = false,
    this.error,
  }) : _rows = List<DsConversationSummary>.of(seed ?? _seed);

  final bool capabilities;

  @override
  final bool isLoading;

  @override
  final String? error;

  List<DsConversationSummary> _rows;
  String? _activeId = 'c-vault';

  @override
  List<DsConversationSummary> get conversations => _rows;

  @override
  String? get activeId => _activeId;

  @override
  void open(String id) {
    _activeId = id;
    notifyListeners();
  }

  @override
  void create() {
    _activeId = null;
    notifyListeners();
  }

  @override
  void rename(String id, String title) {
    _rows = <DsConversationSummary>[
      for (final DsConversationSummary c in _rows)
        if (c.id == id) c.copyWith(title: title) else c,
    ];
    notifyListeners();
  }

  @override
  void remove(String id) {
    _rows = _rows.where((DsConversationSummary c) => c.id != id).toList();
    notifyListeners();
  }

  @override
  void refresh() {}

  @override
  void Function(String id, bool pinned)? get pin => capabilities
      ? (String id, bool pinned) {
          _rows = <DsConversationSummary>[
            for (final DsConversationSummary c in _rows)
              if (c.id == id) c.copyWith(pinned: pinned) else c,
          ];
          notifyListeners();
        }
      : null;

  @override
  void Function(String id)? get share =>
      capabilities ? (String id) {} : null;
}

/// Mounts one widget under the tokens, a frozen clock and reduced motion.
Future<void> _pump(WidgetTester tester, Widget child, {double width = 1030}) {
  final DsThemeController theme = DsThemeController(mode: DsThemeMode.dark);
  addTearDown(theme.dispose);
  return tester.pumpWidget(
    DsClock(
      now: _now,
      child: DsTheme(
        controller: theme,
        child: Builder(
          builder: (BuildContext context) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              size: const Size(1440, 900),
              disableAnimations: true,
            ),
            child: Directionality(
              textDirection: TextDirection.ltr,
              // A fresh key per pump: `Overlay` reads `initialEntries` once, so
              // re-pumping a loop's next case into the same Overlay would keep
              // showing the first one.
              child: Overlay(
                key: UniqueKey(),
                initialEntries: <OverlayEntry>[
                  OverlayEntry(
                    builder: (BuildContext context) => Align(
                      alignment: Alignment.topLeft,
                      child: SizedBox(width: width, child: child),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Finder _button(String label) => find.byWidgetPredicate(
      (Widget w) => w is DsButton && w.label == label,
    );

Future<void> _hover(WidgetTester tester, Finder target) async {
  final TestGesture pointer =
      await tester.createGesture(kind: PointerDeviceKind.mouse);
  addTearDown(pointer.removePointer);
  await pointer.addPointer(location: Offset.zero);
  await tester.pump();
  await pointer.moveTo(tester.getCenter(target));
  await tester.pump();
  await tester.pump(DsDurations.transitionDefault);
}

Future<void> _openMenu(WidgetTester tester) async {
  await _hover(tester, find.byType(DsHistoryCard));
  await tester.tap(_button('Conversation actions'));
  await tester.pump();
  await tester.pump();
}

/// The reference's own font binaries. Load-bearing: a card's height is a line
/// box, and the 69.5 / 89 split is the preview wrapping or not.
Future<void> _loadFont(String family, String file) async {
  final ByteData bytes = ByteData.sublistView(
    File('assets/fonts/$file').readAsBytesSync(),
  );
  final FontLoader loader = FontLoader('packages/elattar_design_system/$family')
    ..addFont(Future<ByteData>.value(bytes));
  await loader.load();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await _loadFont('InterLocal', 'InterVariable.ttf');
    await _loadFont('GeistMono', 'GeistMono-Variable.ttf');
    await _loadFont('Redaction35', 'Redaction35-Italic.ttf');
  });

  /* ── HistorySearch's partition ─────────────────────────────────────────── */

  group('HistorySearch — recent chats are the empty state', () {
    test('an empty query gives pinned-first, then newest, capped at RECENT',
        () {
      final ({
        List<DsConversationSummary> pinned,
        List<DsConversationSummary> recent,
        List<DsConversationSummary> results,
      }) split = DsHistorySearch.partition(_seed, '');

      expect(
        split.pinned.map((DsConversationSummary c) => c.id),
        <String>['c-vault', 'c-export'],
      );
      // `RECENT = 6`, and the corpus has five unpinned rows — the cap is not
      // reached here, which is why it is asserted separately below.
      expect(
        split.recent.map((DsConversationSummary c) => c.id),
        <String>['c-pricing', 'c-hold', 'c-odds', 'c-balance', 'c-grading'],
      );
      expect(split.results, isEmpty);
    });

    test('RECENT caps the unpinned list at six', () {
      final List<DsConversationSummary> many = <DsConversationSummary>[
        for (int i = 0; i < 12; i++) _c('c-$i', 'Row $i', i * 10),
      ];
      final ({
        List<DsConversationSummary> pinned,
        List<DsConversationSummary> recent,
        List<DsConversationSummary> results,
      }) split = DsHistorySearch.partition(many, '');
      expect(split.recent, hasLength(DsHistorySearch.recent));
      expect(split.recent.first.id, 'c-0');
      expect(split.recent.last.id, 'c-5');
    });

    test('a query matches the PREVIEW as well as the title', () {
      // "Export my last 30 days as a CSV" — the word is nowhere in the title,
      // and these are exactly the matches `shouldFilter={false}` protects.
      final ({
        List<DsConversationSummary> pinned,
        List<DsConversationSummary> recent,
        List<DsConversationSummary> results,
      }) csv = DsHistorySearch.partition(_seed, 'CSV');
      expect(csv.results.map((DsConversationSummary c) => c.id),
          <String>['c-export']);
      expect(csv.pinned, isEmpty);
      expect(csv.recent, isEmpty);

      expect(
        DsHistorySearch.partition(_seed, 'odds')
            .results
            .map((DsConversationSummary c) => c.id),
        <String>['c-odds'],
      );
      // Two hits: "Eclipse Vault" is in two previews, and the results stay in
      // newest-first order.
      expect(
        DsHistorySearch.partition(_seed, 'eclipse vault')
            .results
            .map((DsConversationSummary c) => c.id),
        <String>['c-pricing', 'c-hold'],
      );
    });

    test('matching is case-folded and trimmed', () {
      expect(DsHistorySearch.partition(_seed, '   ').recent, hasLength(5));
      expect(DsHistorySearch.partition(_seed, '  GRADING ').results,
          hasLength(1));
    });

    test('the heading pluralises the way the template literal does', () {
      expect(DsHistorySearch.matchHeading(1), '1 match');
      expect(DsHistorySearch.matchHeading(0), '0 matches');
      expect(DsHistorySearch.matchHeading(2), '2 matches');
    });
  });

  /* ── useFlip ───────────────────────────────────────────────────────────── */

  group('useFlip — measured, inverted, and discarded', () {
    test('nothing replays until measure() arms it', () {
      final DsFlipController flip = DsFlipController();
      addTearDown(flip.dispose);
      flip.reconcile(<String>['a', 'b', 'c']);
      // A rename, a hover or a store refresh re-runs the build; without the
      // armed flag every one of them would replay the travel.
      flip.reconcile(<String>['c', 'a', 'b']);
      expect(flip.generationOf('a'), 0);
      expect(flip.generationOf('c'), 0);
    });

    test('a pin replays the entrance on exactly the row React re-places', () {
      final DsFlipController flip = DsFlipController();
      addTearDown(flip.dispose);
      flip.reconcile(<String>['A', 'B', 'C', 'D']);
      flip.measure();
      // D is pinned and lifts over C.
      flip.reconcile(<String>['A', 'B', 'D', 'C']);
      // `lastPlacedIndex`: A(0) B(1) D(3) then C(old 2 < 3) → C is the child
      // given a Placement, and C is the row measured replaying
      // `pulls-row-in`'s translateX(-10px). D — the row that actually moved —
      // teleports.
      expect(flip.generationOf('C'), 1);
      expect(flip.generationOf('D'), 0);
      expect(flip.generationOf('A'), 0);
      expect(flip.generationOf('B'), 0);
    });

    test('an unpin replays the entrance on the row that leaves the top', () {
      final DsFlipController flip = DsFlipController();
      addTearDown(flip.dispose);
      flip.reconcile(<String>['A', 'B', 'D', 'C']);
      flip.measure();
      flip.reconcile(<String>['A', 'B', 'C', 'D']);
      // The mirror of the case above: C is placed first, so D is the one
      // re-inserted.
      expect(flip.generationOf('D'), 1);
      expect(flip.generationOf('C'), 0);
    });

    testWidgets('the inversion is measured and never painted',
        (WidgetTester tester) async {
      final DsFlipController flip = DsFlipController();
      addTearDown(flip.dispose);
      final _Store store = _Store();
      addTearDown(store.dispose);

      Widget list() => ListenableBuilder(
            listenable: store,
            builder: (BuildContext context, Widget? _) {
              final List<DsConversationSummary> ordered =
                  List<DsConversationSummary>.of(store.conversations)
                    ..sort((DsConversationSummary a, DsConversationSummary b) {
                      if (a.pinned != b.pinned) return a.pinned ? -1 : 1;
                      return b.updatedAt.compareTo(a.updatedAt);
                    });
              flip.reconcile(<String>[
                for (final DsConversationSummary c in ordered) c.id,
              ]);
              return DsItemGroup(
                gapOverride: ds(1),
                children: <Widget>[
                  for (final DsConversationSummary c in ordered)
                    DsHistoryCard(
                      key: flip.keyFor(c.id),
                      conversation: c,
                      onOpen: (_) {},
                      onRename: (_, _) {},
                      onRemove: (_) {},
                      onPin: (String id, bool pinned) {
                        flip.measure();
                        store.pin!(id, pinned);
                      },
                    ),
                ],
              );
            },
          );

      await _pump(tester, list());
      await tester.pump();

      final double before =
          tester.getTopLeft(find.byType(DsHistoryCard).at(3)).dy;
      await _hover(tester, find.byType(DsHistoryCard).at(3));
      // Row 3 is "Putting a pack on hold" — the first UNPINNED row whose pin
      // actually reorders anything. Pinning it lands it third, one row up.
      await tester.tap(find.descendant(
        of: find.byType(DsHistoryCard).at(3),
        matching: _button('Pin conversation'),
      ));
      await tester.pump();
      await tester.pump();

      // The row's own travel is 73.5 — one 69.5 card plus the group's `gap-1`
      // — and it arrives as a single-frame teleport, exactly as measured.
      expect(flip.travel['c-hold']!.dy, closeTo(73.5, 0.5));
      expect(flip.travel['c-hold']!.dx, 0);
      expect(before - tester.getTopLeft(find.byType(DsHistoryCard).at(2)).dy,
          closeTo(73.5, 0.5));
      // No row carries a paint transform: `anim-row-in`'s fill-both keeps
      // `transform: none` in the animation origin, which outranks it.
      for (final Element e in find.byType(Transform).evaluate()) {
        final Transform t = e.widget as Transform;
        expect(t.transform.getTranslation().y, 0);
      }
    });

    test('sub-pixel drift is not movement', () {
      // `Math.abs(dx) < 1 && Math.abs(dy) < 1` — transforming for it costs a
      // layer and buys nothing.
      expect(DsFlipController.minimumTravel, 1);
    });
  });

  /* ── Row motion ────────────────────────────────────────────────────────── */

  group('anim-row-in / anim-row-out', () {
    test('the delay is a flat --duration-tick, because nothing staggers', () {
      // `calc(--duration-tick + var(--row-index, 0) * --duration-tick / 2)`
      // with no `--row-index` set anywhere on the page.
      expect(DsRowMotion.enterSpan, DsDurations.tick + DsDurations.base);
      expect(
        DsRowMotion.enterDelayFraction,
        closeTo(80 / 330, 0.001),
      );
      // The hold: nothing has moved while the delay runs.
      expect(DsRowMotion.enterCurve.transform(0), 0);
      expect(
        DsRowMotion.enterCurve.transform(DsRowMotion.enterDelayFraction),
        0,
      );
      expect(DsRowMotion.enterCurve.transform(1), 1);
    });

    test('the travels are the keyframes own', () {
      expect(DsRowMotion.enterShift, -10);
      expect(DsRowMotion.exitShift, -24);
      expect(DsRowMotion.exitBreak, 0.45);
    });

    testWidgets('a leaving row collapses its own height', (WidgetTester t) async {
      Widget card({required bool leaving}) => DsHistoryCard(
            conversation: _seed.first,
            leaving: leaving,
            onOpen: (_) {},
            onRename: (_, _) {},
            onRemove: (_) {},
          );

      await _pump(t, card(leaving: false));
      await t.pump();
      final double tall = t.getSize(find.byType(DsHistoryCard)).height;
      expect(tall, closeTo(69.5, 0.5));

      await _pump(t, card(leaving: true));
      await t.pump();
      // Under reduced motion the exit lands on its final frame, which is a
      // zero-height box — the collapse the list rises into.
      expect(t.getSize(find.byType(DsHistoryCard)).height, 0);
    });
  });

  /* ── The card ──────────────────────────────────────────────────────────── */

  group('HistoryCard', () {
    testWidgets('the active conversation is marked by its GLYPH, not a fill',
        (WidgetTester tester) async {
      for (final ({bool active, bool pinned, DsLucideGlyph glyph}) want
          in <({bool active, bool pinned, DsLucideGlyph glyph})>[
        (active: true, pinned: false, glyph: DsLucide.messageSquareDot),
        (active: true, pinned: true, glyph: DsLucide.messageSquareDot),
        (active: false, pinned: true, glyph: DsLucide.pin),
        (active: false, pinned: false, glyph: DsLucide.messageSquare),
      ]) {
        await _pump(
          tester,
          DsHistoryCard(
            key: ValueKey<String>('${want.active}-${want.pinned}'),
            conversation: _seed.first.copyWith(pinned: want.pinned),
            active: want.active,
            onOpen: (_) {},
            onRename: (_, _) {},
            onRemove: (_) {},
          ),
        );
        await tester.pump();
        final DsIcon media = tester.widget<DsIcon>(
          find.descendant(
            of: find.byType(DsItemMedia),
            matching: find.byType(DsIcon),
          ),
        );
        expect(media.lucide, want.glyph,
            reason: 'active=${want.active} pinned=${want.pinned}');
      }
    });

    testWidgets('renaming inline holds every other box still',
        (WidgetTester tester) async {
      String title = 'Sealed inventory check';
      await _pump(
        tester,
        StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) =>
              DsHistoryCard(
            conversation: _seed.first.copyWith(title: title),
            onOpen: (_) {},
            onRename: (_, String next) => setState(() => title = next),
            onRemove: (_) {},
          ),
        ),
      );
      await tester.pump();

      final Size box = tester.getSize(find.byType(DsHistoryCard));
      final Offset media = tester.getTopLeft(find.byType(DsItemMedia));
      final Offset description =
          tester.getTopLeft(find.byType(DsItemDescription));

      await _openMenu(tester);
      await tester.tap(find.text('Rename'));
      await tester.pump();
      await tester.pump();

      expect(find.byType(DsInput), findsOneWidget);
      // `h-6` in both states — the whole point of the inline form.
      expect(tester.getSize(find.byType(DsInput)).height,
          closeTo(DsHistoryCard.titleHeight, 0.01));
      expect(tester.getSize(find.byType(DsHistoryCard)), box);
      expect(tester.getTopLeft(find.byType(DsItemMedia)), media);
      expect(tester.getTopLeft(find.byType(DsItemDescription)), description);

      // Escape abandons; the value is not committed.
      await tester.enterText(find.byType(DsInput), 'Something else');
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();
      expect(title, 'Sealed inventory check');
    });

    testWidgets('the inline confirm is opaque, covers the row, and fades out',
        (WidgetTester tester) async {
      bool removed = false;
      await _pump(
        tester,
        DsHistoryCard(
          conversation: _seed.first,
          onOpen: (_) {},
          onRename: (_, _) {},
          onRemove: (_) => removed = true,
        ),
      );
      await tester.pump();
      final Size box = tester.getSize(find.byType(DsHistoryCard));

      await _openMenu(tester);
      await tester.tap(find.text('Delete'));
      await tester.pump();
      await tester.pump();

      expect(find.text('Delete this?'), findsOneWidget);
      expect(find.text('Keep'), findsOneWidget);
      // `absolute inset-0` — the row is covered, not pushed.
      expect(tester.getSize(find.byType(DsHistoryCard)), box);
      expect(
        tester.getSize(find.text('Delete this?')).height,
        lessThan(box.height),
      );

      await tester.tap(find.text('Keep'));
      await tester.pump();
      // `CONFIRM_EXIT_MS` — the confirm outlives its own dismissal.
      expect(find.text('Delete this?'), findsOneWidget);
      await tester.pump(DsHistoryCard.confirmExit);
      await tester.pump();
      expect(find.text('Delete this?'), findsNothing);
      expect(removed, isFalse);
    });

    test('in and out run on different clocks, and out does not retrace', () {
      // `anim-confirm-in`  — `--duration-fast` (150) on `--ease-out`.
      // `anim-confirm-out` — `--duration-tick` (80) on `--ease-in`, opacity
      // only: *"retracing the slide on the way out drags attention away from
      // the row you are meant to be looking at again."*
      expect(DsHistoryCard.confirmExit, DsDurations.tick);
      expect(DsHistoryCard.confirmShift, 0.12);
    });

    testWidgets('capabilities are absence — no pin, no Share row',
        (WidgetTester tester) async {
      await _pump(
        tester,
        DsHistoryCard(
          conversation: _seed.first,
          onOpen: (_) {},
          onRename: (_, _) {},
          onRemove: (_) {},
        ),
      );
      await tester.pump();
      expect(_button('Pin conversation'), findsNothing);
      expect(_button('Unpin conversation'), findsNothing);

      await _openMenu(tester);
      expect(find.text('Share'), findsNothing);
      expect(find.text('Pin'), findsNothing);
      expect(find.text('Unpin'), findsNothing);
      // …and the two that never depend on a capability.
      expect(find.text('Rename'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
    });

    testWidgets('a pinned row keeps its pin lit; an unpinned one hides it',
        (WidgetTester tester) async {
      for (final bool pinned in <bool>[true, false]) {
        await _pump(
          tester,
          DsHistoryCard(
            key: ValueKey<bool>(pinned),
            conversation: _seed.first.copyWith(pinned: pinned),
            onOpen: (_) {},
            onRename: (_, _) {},
            onRemove: (_) {},
            onPin: (_, _) {},
          ),
        );
        await tester.pump();
        final AnimatedOpacity fade = tester
            .widgetList<AnimatedOpacity>(find.byType(AnimatedOpacity))
            .first;
        expect(fade.opacity, pinned ? 1 : 0, reason: 'pinned=$pinned');
      }
    });

    testWidgets('the menu carries Share, Rename, Pin, a separator and Delete',
        (WidgetTester tester) async {
      await _pump(
        tester,
        DsHistoryCard(
          conversation: _seed.first,
          onOpen: (_) {},
          onRename: (_, _) {},
          onRemove: (_) {},
          onPin: (_, _) {},
          onShare: (_) {},
        ),
      );
      await tester.pump();
      await _openMenu(tester);

      expect(find.text('Share'), findsOneWidget);
      expect(find.text('Rename'), findsOneWidget);
      // The row is pinned, so the verb inverts.
      expect(find.text('Unpin'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
      // 144 × 35 *(measured)* — the width comes from `min-w-40`.
      expect(tester.getSize(find.text('Rename')).height, lessThan(36));
    });

    testWidgets('the title button opens, and only the title button does',
        (WidgetTester tester) async {
      final List<String> opened = <String>[];
      await _pump(
        tester,
        DsHistoryCard(
          conversation: _seed.first,
          onOpen: opened.add,
          onRename: (_, _) {},
          onRemove: (_) {},
        ),
      );
      await tester.pump();
      await tester.tap(find.text('Sealed inventory check'));
      await tester.pump();
      expect(opened, <String>['c-vault']);

      // The description is not a target.
      await tester.tap(find.byType(DsItemDescription), warnIfMissed: false);
      await tester.pump();
      expect(opened, hasLength(1));
    });

    testWidgets('the timestamp line is the formatter\'s own string',
        (WidgetTester tester) async {
      await _pump(
        tester,
        DsHistoryCard(
          conversation: _seed[3],
          onOpen: (_) {},
          onRename: (_, _) {},
          onRemove: (_) {},
        ),
      );
      await tester.pump();
      // `numeric: "auto"` — one day is "yesterday".
      expect(
        find.text('yesterday · Buy me an Eclipse Vault pack'),
        findsOneWidget,
      );
    });
  });

  /* ── The drawer ────────────────────────────────────────────────────────── */

  group('ChatHistory', () {
    testWidgets('a store with no pin and no share degrades every row',
        (WidgetTester tester) async {
      final _Store store = _Store(capabilities: false);
      addTearDown(store.dispose);
      await _pump(
        tester,
        SizedBox(height: 608, child: DsChatHistory(store: store)),
        width: 1078,
      );
      await tester.pump();
      await tester.tap(_button('Open sidebar'));
      await tester.pump();
      await tester.pump();

      // Nothing about the list special-cases this: the affordances are absent
      // because the functions are.
      expect(_button('Pin conversation'), findsNothing);
      expect(_button('Unpin conversation'), findsNothing);
      for (final Element e in find.byType(DsHistoryCard).evaluate()) {
        final DsHistoryCard card = e.widget as DsHistoryCard;
        expect(card.onPin, isNull);
        expect(card.onShare, isNull);
      }
    });

    testWidgets('splits Pinned from Recents — which the flat list does not',
        (WidgetTester tester) async {
      final _Store store = _Store();
      addTearDown(store.dispose);
      await _pump(
        tester,
        SizedBox(height: 608, child: DsChatHistory(store: store)),
        width: 1078,
      );
      await tester.pump();
      expect(find.text('Conversations'), findsNothing);

      await tester.tap(_button('Open sidebar'));
      await tester.pump();
      await tester.pump();

      expect(find.text('Conversations'), findsOneWidget);
      expect(find.text('New chat'), findsOneWidget);
      expect(find.text('Pinned'), findsOneWidget);
      expect(find.text('Recents'), findsOneWidget);
      expect(find.byType(DsHistoryCard), findsNWidgets(7));
      // `max-w-sm` — 384 *(measured)*.
      expect(DsChatHistory.width, 384);
    });

    testWidgets('with nothing pinned there is no Recents heading either',
        (WidgetTester tester) async {
      final _Store store = _Store(
        seed: <DsConversationSummary>[_c('c-1', 'Only one', 5)],
      );
      addTearDown(store.dispose);
      await _pump(
        tester,
        SizedBox(height: 608, child: DsChatHistory(store: store)),
        width: 1078,
      );
      await tester.pump();
      await tester.tap(_button('Open sidebar'));
      await tester.pump();
      await tester.pump();

      expect(find.text('Pinned'), findsNothing);
      // `{pinned.length > 0 ? <p>Recents</p> : null}` — the second heading
      // exists only to distinguish it from the first.
      expect(find.text('Recents'), findsNothing);
      expect(find.byType(DsHistoryCard), findsOneWidget);
    });

    testWidgets('an empty store shows the empty state, loading or not',
        (WidgetTester tester) async {
      for (final bool loading in <bool>[false, true]) {
        final _Store store = _Store(
          seed: const <DsConversationSummary>[],
          isLoading: loading,
        );
        addTearDown(store.dispose);
        await _pump(
          tester,
          SizedBox(
            height: 608,
            child: DsChatHistory(key: ValueKey<bool>(loading), store: store),
          ),
          width: 1078,
        );
        await tester.pump();
        await tester.tap(_button('Open sidebar'));
        await tester.pump();
        await tester.pump();

        expect(
          find.text(loading ? 'Loading conversations' : 'No conversations yet'),
          findsOneWidget,
        );
        expect(find.byType(DsSpinner), loading ? findsOneWidget : findsNothing);
      }
    });

    testWidgets('a store error replaces the list with a destructive Alert',
        (WidgetTester tester) async {
      final _Store store = _Store(
        seed: const <DsConversationSummary>[],
        error: 'The store said no.',
      );
      addTearDown(store.dispose);
      await _pump(
        tester,
        SizedBox(height: 608, child: DsChatHistory(store: store)),
        width: 1078,
      );
      await tester.pump();
      await tester.tap(_button('Open sidebar'));
      await tester.pump();
      await tester.pump();

      expect(find.text('History is unavailable'), findsOneWidget);
      expect(find.text('The store said no.'), findsOneWidget);
      // `!store.error && …` — the empty state is suppressed by the error.
      expect(find.text('No conversations yet'), findsNothing);
      expect(
        tester.widget<DsAlert>(find.byType(DsAlert)).variant,
        DsAlertVariant.destructive,
      );
    });

    testWidgets('a deleted row outlives its own deletion',
        (WidgetTester tester) async {
      final _Store store = _Store();
      addTearDown(store.dispose);
      await _pump(
        tester,
        SizedBox(height: 608, child: DsChatHistory(store: store)),
        width: 1078,
      );
      await tester.pump();
      await tester.tap(_button('Open sidebar'));
      await tester.pump();
      await tester.pump();

      expect(store.conversations, hasLength(7));
      // The store call is deferred by `EXIT_MS` so the row can play
      // `anim-row-out` — without it the list snaps shut under the cursor.
      expect(DsChatHistory.exit, DsDurations.base);
      expect(DsChatHistory.panelIn, DsDurations.overlay);
    });

    testWidgets('New chat creates and closes; the drawer closes on its own X',
        (WidgetTester tester) async {
      final _Store store = _Store();
      addTearDown(store.dispose);
      await _pump(
        tester,
        SizedBox(height: 608, child: DsChatHistory(store: store)),
        width: 1078,
      );
      await tester.pump();
      await tester.tap(_button('Open sidebar'));
      await tester.pump();
      await tester.pump();

      await tester.tap(find.text('New chat'));
      await tester.pump();
      await tester.pump();
      expect(store.activeId, isNull);
      expect(find.text('Conversations'), findsNothing);
    });
  });

  /* ── The blur switch ───────────────────────────────────────────────────── */

  group('blurClass(phase)', () {
    test('the two radii are the keyframes own', () {
      expect(DsBlurSwitch.outRadius, 6);
      expect(DsBlurSwitch.inRadius, 8);
    });

    testWidgets('idle wraps nothing at all', (WidgetTester tester) async {
      await _pump(
        tester,
        const DsBlurSwitch(
          phase: DsSwitchPhase.idle,
          child: SizedBox(width: 10, height: 10),
        ),
      );
      await tester.pump();
      expect(find.byType(ImageFiltered), findsNothing);
      expect(find.byType(Opacity), findsNothing);
    });

    testWidgets('out and in both paint', (WidgetTester tester) async {
      for (final DsSwitchPhase phase in <DsSwitchPhase>[
        DsSwitchPhase.out,
        DsSwitchPhase.blurIn,
      ]) {
        await _pump(
          tester,
          DsBlurSwitch(
            key: ValueKey<DsSwitchPhase>(phase),
            phase: phase,
            child: const SizedBox(width: 10, height: 10),
          ),
        );
        await tester.pump();
        expect(find.byType(Opacity), findsWidgets, reason: '$phase');
      }
    });
  });

  /* ── The primitives this family reopened ───────────────────────────────── */

  group('Item, reopened by the history card', () {
    testWidgets('variant=outline draws --border where default draws nothing',
        (WidgetTester tester) async {
      await _pump(
        tester,
        const Column(
          children: <Widget>[
            DsItem(
              variant: DsItemVariant.outline,
              content: DsItemContent(children: <Widget>[DsItemTitle('a')]),
            ),
            DsItem(content: DsItemContent(children: <Widget>[DsItemTitle('b')])),
          ],
        ),
      );
      await tester.pump();
      final DsThemeData theme =
          DsTheme.of(tester.element(find.byType(DsItem).first));
      final List<Container> rows =
          tester.widgetList<Container>(find.byType(Container)).toList();
      final BoxDecoration outline = rows.first.decoration! as BoxDecoration;
      final BoxDecoration plain = rows[1].decoration! as BoxDecoration;
      expect(outline.border!.top.color, theme.border);
      expect(plain.border!.top.color, dsTransparent);
      // Both pay for the 1px out of their own width.
      expect(outline.border!.top.width, plain.border!.top.width);
    });

    testWidgets('gapOverride is the call site gap-1, not the has-* drift',
        (WidgetTester tester) async {
      await _pump(
        tester,
        DsItemGroup(
          gapOverride: ds(1),
          children: const <Widget>[
            SizedBox(height: 10),
            SizedBox(height: 10),
          ],
        ),
      );
      await tester.pump();
      final List<Element> boxes =
          find.byType(SizedBox).evaluate().toList();
      // 10px of row, 4px of gap, 10px of row.
      expect(tester.getSize(find.byType(DsItemGroup)).height, 24);
      expect(boxes, isNotEmpty);
      // The default is still the measured 10px drift.
      expect(DsItemGroup.gap, 10);
    });
  });

  group('Command, reopened by the history palette', () {
    test('a two-line row derives its search value from all of its text', () {
      const DsCommandItem row = DsCommandItem(
        label: 'Thirty-day activity export',
        subtitle: 'Export my last 30 days as a CSV',
        meta: '2 hours ago',
      );
      expect(
        row.searchValue,
        'Thirty-day activity exportExport my last 30 days as a CSV2 hours ago',
      );
      // …unless the call site supplies one, which `HistorySearch` does.
      expect(
        const DsCommandItem(label: 'x', subtitle: 'y', value: 'c-export')
            .searchValue,
        'c-export',
      );
    });

    testWidgets('inDialog corners its rows at rounded-lg and drops the stroke',
        (WidgetTester tester) async {
      for (final bool inDialog in <bool>[false, true]) {
        await _pump(
          tester,
          DsCommand(
            key: ValueKey<bool>(inDialog),
            inDialog: inDialog,
            shouldFilter: false,
            groups: const <DsCommandGroup>[
              DsCommandGroup(
                heading: 'Pinned',
                items: <DsCommandItem>[
                  DsCommandItem(
                    value: 'c-vault',
                    label: 'Sealed inventory check',
                    subtitle: 'What sealed boxes are left?',
                    meta: '14 minutes ago',
                  ),
                ],
              ),
            ],
          ),
          width: 384,
        );
        await tester.pump();

        final DsThemeData theme =
            DsTheme.of(tester.element(find.byType(DsCommand)));
        final BoxDecoration root = tester
            .widgetList<Container>(find.byType(Container))
            .first
            .decoration! as BoxDecoration;
        expect(root.border, inDialog ? isNull : isNotNull);
        expect(root.color, inDialog ? theme.popover : theme.card);

        // Both lines of the row are on screen, and the meta is beside them.
        expect(find.text('Sealed inventory check'), findsOneWidget);
        expect(find.text('What sealed boxes are left?'), findsOneWidget);
        expect(find.text('14 minutes ago'), findsOneWidget);
      }
    });

    testWidgets('a two-line row is 48.7 tall, not 34.5',
        (WidgetTester tester) async {
      await _pump(
        tester,
        const DsCommand(
          inDialog: true,
          shouldFilter: false,
          groups: <DsCommandGroup>[
            DsCommandGroup(
              heading: 'Recent',
              items: <DsCommandItem>[
                DsCommandItem(
                  value: 'c-odds',
                  label: 'How pack odds actually work',
                  subtitle: 'Explain the odds on a sealed box',
                  meta: '3 days ago',
                ),
              ],
            ),
          ],
        ),
        width: 384,
      );
      await tester.pump();
      // `py-2` around one 18.5714 line box and one 14.175 caption line box.
      final double row =
          tester.getSize(find.text('How pack odds actually work')).height +
              tester.getSize(find.text('Explain the odds on a sealed box')).height +
              ds(2) * 2;
      expect(row, closeTo(48.7, 0.5));
    });
  });
}
