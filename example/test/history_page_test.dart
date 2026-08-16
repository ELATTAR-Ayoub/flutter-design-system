/// `/design-system/components/agent/history` — the page, against the numbers
/// the reference actually renders.
///
/// Two harnesses, the split every page test in this suite uses:
///
///  * [pumpHistoryInShell] mounts the real `DocsShell` at the 1440 × 900
///    reference frame and hands back the reading column's `RenderBox`. Every
///    oracle number is measured from that origin, **pristine** — nothing
///    hovered, nothing open, nothing renamed.
///  * `pumpHistoryPage` mounts the page alone in a tall frame so all nine
///    specimens are laid out and hit-testable at once. The fidelity bar for
///    this page is that every card is live, and that is what this file proves.
///
/// ## The clock is part of the harness
///
/// Every row on this page carries a relative timestamp, and the seeds are
/// offsets from the store's own "now" — which the port takes from [DsClock].
/// Both harnesses freeze the same instant the reference's capture was frozen
/// on, so *"14 minutes ago"* is *"14 minutes ago"* on both sides. Nothing on
/// this page changes **height** with the clock (every timestamp is one line
/// inside a fixed row), so the oracle is clock-independent even though the
/// strings are not.
///
/// The oracle is `node tool/verify/section-oracle.js
/// /design-system/components/agent/history light` plus
/// `scratchpad/ag-inv-h1.txt` for the reading column, both on 2026-08-16.
library;

import 'dart:io';
import 'dart:typed_data';

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/kit.dart';
import 'package:example/nav.dart';
import 'package:example/pages/history.dart';
import 'package:example/shell.dart';
import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FontLoader;
import 'package:flutter_test/flutter_test.dart';

/* ── The frame, the clock and the oracle ─────────────────────────────────── */

/// Tall enough to lay the whole page out at once, so nothing needs scrolling
/// into view before it can be tapped.
const Size _desktop = Size(1440, 8000);

/// The frame the reference is measured at.
const Size _referenceFrame = Size(1440, 900);

/// The instant BOTH renderers are frozen on.
final DateTime _frozen = DateTime(2026, 8, 16, 12);

const String _route = '$dsRoot/components/agent/history';

/// `--width-content`.
const double _columnWidth = 1080;

/// `main` at 64, plus its own 48px of top padding.
const double _columnTop = 112;

/// The reading column's own height.
const double _columnHeight = 5585.33;

/// Each `section[id]`, as `(document top, border-box height)`.
///
/// The heights are the CSS border box, so `mb-20` — which this port pays as
/// padding inside the section's own box — comes back off before comparing.
const Map<String, ({double top, double height})> _sectionOracle =
    <String, ({double top, double height})>{
  'list': (top: 555.89, height: 832.86),
  'rename': (top: 1468.75, height: 420.19),
  'delete': (top: 1968.94, height: 626.69),
  'pin': (top: 2675.63, height: 276.69),
  'capabilities': (top: 3032.31, height: 813.36),
  'search': (top: 3925.67, height: 416.86),
  'switch': (top: 4422.53, height: 1093.80),
};

/// Two logical pixels — the band the aggregates hold.
const double _tolerance = 2;

/// Half a pixel — the band every fixed box holds, and the column with them.
///
/// Measured **5585.425** against the reference's 5585.33: **+0.095**, which is
/// under the ±0.5 `vertical_parity_probe_test` holds every route to, so this
/// route carries **no residual** and needs no entry beside `chat`, `charts` and
/// `sidebar` in that file's register.
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

  /// The page alone, laid out tall, under reduced motion and the frozen clock.
  Future<void> pumpHistoryPage({DsThemeMode mode = DsThemeMode.light}) async {
    useViewport(_desktop);
    final DsThemeController theme = DsThemeController(mode: mode);
    final AppRouter router = AppRouter(route: _route);
    addTearDown(theme.dispose);
    addTearDown(router.dispose);

    await pumpWidget(
      DsClock(
        now: _frozen,
        child: DsTheme(
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
                    child: const SingleChildScrollView(child: HistoryPage()),
                  ),
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

/// The page inside the real [DocsShell] at the reference frame.
///
/// `main.dart` is the supervisor's at integration, so the page is handed to the
/// shell directly rather than looked up through `pageFor`.
Future<RenderBox> pumpHistoryInShell(
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

  const Widget page = HistoryPage();
  await tester.pumpWidget(
    DsClock(
      now: _frozen,
      child: DsTheme(
        controller: theme,
        child: AppRouterScope(
          router: router,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: DocsShell(
              route: _route,
              // Reduced motion inside the shell as well as in the tall
              // harness. Every entrance on this page finishes at its resting
              // state — `anim-row-in` ends at `opacity: 1; transform: none` —
              // so the geometry is identical either way, and §7's console
              // mounts a welcome card whose own stagger schedules real timers
              // that a two-frame pump would otherwise leave pending.
              child: Builder(
                builder: (BuildContext context) => MediaQuery(
                  data: MediaQuery.of(context).copyWith(disableAnimations: true),
                  child: page,
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
  // No settle: PRISTINE is the state the oracle was measured in.
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

/// A string as the page *authors* it — three of the kit's rungs paint
/// uppercase, so a label written `pinned` is found as `PINNED` or not at all.
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

/// One frame for the prop to flip, one more for the portal the frame boundary
/// brings in.
Future<void> _settleOverlay(WidgetTester tester) async {
  await tester.pump();
  await tester.pump();
}

/// Opens a card's action menu the way a reader does: the trigger is
/// `opacity-0` until the card is hovered, so the pointer has to arrive first.
Future<void> _openCardMenu(WidgetTester tester, Finder card) async {
  await _hover(tester, card);
  await tester.pump(DsDurations.transitionDefault);
  await tester.tap(find.descendant(
    of: card,
    matching: find.byWidgetPredicate(
      (Widget w) => w is DsButton && w.label == 'Conversation actions',
    ),
  ));
  await _settleOverlay(tester);
}

Future<TestGesture> _hover(WidgetTester tester, Finder target) async {
  final TestGesture pointer =
      await tester.createGesture(kind: PointerDeviceKind.mouse);
  addTearDown(pointer.removePointer);
  await pointer.addPointer(location: Offset.zero);
  await tester.pump();
  await pointer.moveTo(tester.getCenter(target));
  await tester.pump();
  return pointer;
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
      final RenderBox column = await pumpHistoryInShell(tester);
      expect(column.size.width, _columnWidth);
    });

    testWidgets('the column stacks to the reference height',
        (WidgetTester tester) async {
      final RenderBox column = await pumpHistoryInShell(tester);
      expect(column.size.height, closeTo(_columnHeight, _fineTolerance));
    });

    testWidgets('every section starts and ends where the reference does',
        (WidgetTester tester) async {
      final RenderBox column = await pumpHistoryInShell(tester);

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

    testWidgets('a full-width card is 69.5 tall and the list pitch is 73.5',
        (WidgetTester tester) async {
      final RenderBox column = await pumpHistoryInShell(tester);
      final Finder cards = _in('list', find.byType(DsHistoryCard));
      expect(cards, findsNWidgets(7));

      final ({double top, double height}) first =
          _boxIn(tester, column, cards.at(0));
      final ({double top, double height}) second =
          _boxIn(tester, column, cards.at(1));
      expect(first.height, closeTo(69.5, _fineTolerance));
      expect(second.top - first.top, closeTo(73.5, _fineTolerance));
      expect(tester.getSize(cards.at(0)).width, closeTo(1030, _fineTolerance));
    });

    testWidgets('a half-width specimen card is 89 tall — the preview wraps',
        (WidgetTester tester) async {
      final RenderBox column = await pumpHistoryInShell(tester);
      final ({double top, double height}) card = _boxIn(
        tester,
        column,
        _in('rename', find.byType(DsHistoryCard)).first,
      );
      expect(card.height, closeTo(89, _fineTolerance));
      expect(
        tester.getSize(_in('rename', find.byType(DsHistoryCard)).first).width,
        closeTo(482, _fineTolerance),
      );
    });

    testWidgets('the console panel body is exactly h-152',
        (WidgetTester tester) async {
      await pumpHistoryInShell(tester);
      expect(
        tester.getSize(find.byType(ConsoleWithHistory)).height,
        closeTo(608, _fineTolerance),
      );
    });

    testWidgets('the page renders in both themes at the same height',
        (WidgetTester tester) async {
      final RenderBox light = await pumpHistoryInShell(tester);
      final double lightHeight = light.size.height;
      final RenderBox dark =
          await pumpHistoryInShell(tester, mode: DsThemeMode.dark);
      expect(dark.size.height, closeTo(lightHeight, 0.01));
    });
  });

  /* ── Structure ─────────────────────────────────────────────────────────── */

  group('structure', () {
    testWidgets('the six sections the nav promises all exist',
        (WidgetTester tester) async {
      await tester.pumpHistoryPage();
      final DsCategoryHit here = findCategory('agent', 'history');
      expect(here.category.contents, hasLength(6));
      for (final String id in <String>[
        'list',
        'rename',
        'delete',
        'pin',
        'capabilities',
        'search',
        'switch',
      ]) {
        expect(_section(id), findsOneWidget, reason: id);
      }
      // DRIFT — seven sections behind six chips, the same mismatch the
      // selection page's register opens with.
      expect(here.category.contents.length, lessThan(7));
    });

    testWidgets('§1 is ONE flat group with no Pinned/Recents headings',
        (WidgetTester tester) async {
      await tester.pumpHistoryPage();
      expect(_in('list', find.byType(DsItemGroup)), findsOneWidget);
      expect(_in('list', _copy('Pinned')), findsNothing);
      expect(_in('list', _copy('Recents')), findsNothing);
      // The strip above it names the open conversation.
      expect(
        _in('list', _copy('Open: Sealed inventory check')),
        findsOneWidget,
      );
    });

    testWidgets('the seven seeded conversations are in the measured order',
        (WidgetTester tester) async {
      await tester.pumpHistoryPage();
      const List<String> titles = <String>[
        'Sealed inventory check',
        'Thirty-day activity export',
        'Pricing service outage',
        'Putting a pack on hold',
        'How pack odds actually work',
        'Balance and recent movement',
        'Grading a first edition',
      ];
      final Finder cards = _in('list', find.byType(DsHistoryCard));
      for (int i = 0; i < titles.length; i++) {
        expect(
          tester.widget<DsHistoryCard>(cards.at(i)).conversation.title,
          titles[i],
          reason: 'row $i',
        );
      }
    });

    testWidgets('the relative timestamps are the formatter\'s own strings',
        (WidgetTester tester) async {
      await tester.pumpHistoryPage();
      // `numeric: "auto"` is why one day is "yesterday" and one week is
      // "last week" rather than "1 day ago".
      for (final String line in <String>[
        '14 minutes ago · What sealed boxes are left, and what is the best one?',
        '2 hours ago · Export my last 30 days as a CSV',
        'yesterday · Buy me an Eclipse Vault pack',
        'last week · How much do I have available?',
        '3 weeks ago · Is it worth grading a 1st edition?',
      ]) {
        expect(_in('list', _copy(line)), findsOneWidget, reason: line);
      }
    });

    testWidgets('§5 draws no pin button and no Share item',
        (WidgetTester tester) async {
      await tester.pumpHistoryPage();
      final Finder cards = _in('capabilities', find.byType(DsHistoryCard));
      expect(cards, findsNWidgets(7));
      for (int i = 0; i < 7; i++) {
        expect(tester.widget<DsHistoryCard>(cards.at(i)).onPin, isNull);
        expect(tester.widget<DsHistoryCard>(cards.at(i)).onShare, isNull);
      }
      // …and §1's identical list does draw both.
      expect(
        tester
            .widget<DsHistoryCard>(_in('list', find.byType(DsHistoryCard)).first)
            .onPin,
        isNotNull,
      );
    });

    testWidgets('both rename shapes and both confirm shapes are on the page',
        (WidgetTester tester) async {
      await tester.pumpHistoryPage();
      expect(_panel('rename=inline'), findsOneWidget);
      expect(_panel('rename=dialog'), findsOneWidget);
      expect(_panel('confirm=inline'), findsOneWidget);
      expect(_panel('confirm=dialog'), findsOneWidget);
      expect(_panel('pinned'), findsOneWidget);
      expect(_panel('unpinned · active'), findsOneWidget);
    });
  });

  /* ── Behaviour: every specimen answers a pointer ───────────────────────── */

  group('live specimens', () {
    testWidgets('renaming inline moves nothing — the card holds its height',
        (WidgetTester tester) async {
      await tester.pumpHistoryPage();
      final Finder card = _in('rename', find.byType(DsHistoryCard)).first;
      final double before = tester.getSize(card).height;
      final Offset descriptionBefore = tester.getTopLeft(
        find.descendant(of: card, matching: find.byType(DsItemDescription)),
      );

      await _openCardMenu(tester, card);
      await tester.tap(find.text('Rename'));
      await _settleOverlay(tester);

      expect(find.descendant(of: card, matching: find.byType(DsInput)),
          findsOneWidget);
      expect(tester.getSize(card).height, closeTo(before, 0.01));
      expect(
        tester.getTopLeft(
          find.descendant(of: card, matching: find.byType(DsItemDescription)),
        ),
        descriptionBefore,
      );
      // The whole value is selected on entry.
      final EditableText field = tester.widget<EditableText>(
        find.descendant(of: card, matching: find.byType(EditableText)),
      );
      expect(field.controller.selection.baseOffset, 0);
      expect(
        field.controller.selection.extentOffset,
        'Sealed inventory check'.length,
      );
    });

    testWidgets('Enter commits the rename', (WidgetTester tester) async {
      await tester.pumpHistoryPage();
      final Finder card = _in('rename', find.byType(DsHistoryCard)).first;
      await _openCardMenu(tester, card);
      await tester.tap(find.text('Rename'));
      await _settleOverlay(tester);

      await tester.enterText(
        find.descendant(of: card, matching: find.byType(DsInput)),
        'Renamed by the test',
      );
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      expect(
        tester.widget<DsHistoryCard>(card).conversation.title,
        'Renamed by the test',
      );
    });

    testWidgets('the inline confirm covers the row and Keep dismisses it',
        (WidgetTester tester) async {
      await tester.pumpHistoryPage();
      final Finder card =
          find.descendant(of: _panel('confirm=inline'), matching: find.byType(DsHistoryCard));
      final Size box = tester.getSize(card);

      await _openCardMenu(tester, card);
      await tester.tap(find.text('Delete'));
      await _settleOverlay(tester);

      expect(find.descendant(of: card, matching: find.text('Delete this?')),
          findsOneWidget);
      // `absolute inset-0` — it covers the row rather than pushing it around.
      expect(tester.getSize(card), box);

      await tester.tap(find.descendant(of: card, matching: find.text('Keep')));
      await tester.pump();
      // `CONFIRM_EXIT_MS` — the row stays mounted for the exit.
      await tester.pump(DsHistoryCard.confirmExit);
      await tester.pump();
      expect(find.text('Delete this?'), findsNothing);
    });

    testWidgets('the inline Delete removes the card and it can be put back',
        (WidgetTester tester) async {
      await tester.pumpHistoryPage();
      final Finder panel = _panel('confirm=inline');
      await _openCardMenu(
        tester,
        find.descendant(of: panel, matching: find.byType(DsHistoryCard)),
      );
      await tester.tap(find.text('Delete'));
      await _settleOverlay(tester);
      await tester.tap(find.descendant(of: panel, matching: find.text('Delete')));
      await tester.pump();

      expect(find.descendant(of: panel, matching: find.byType(DsHistoryCard)),
          findsNothing);
      expect(
        find.descendant(of: panel, matching: _copy('Deleted.')),
        findsOneWidget,
      );
      await tester.tap(
        find.descendant(of: panel, matching: find.text('Put it back')),
      );
      await tester.pump();
      expect(find.descendant(of: panel, matching: find.byType(DsHistoryCard)),
          findsOneWidget);
    });

    testWidgets('the dialog shape raises the system AlertDialog instead',
        (WidgetTester tester) async {
      await tester.pumpHistoryPage();
      await _openCardMenu(
        tester,
        find.descendant(
          of: _panel('confirm=dialog'),
          matching: find.byType(DsHistoryCard),
        ),
      );
      await tester.tap(find.text('Delete'));
      await _settleOverlay(tester);

      expect(find.byType(DsDialogOverlay), findsOneWidget);
      expect(find.text('Delete this conversation?'), findsOneWidget);
      expect(find.text('Keep it'), findsOneWidget);
    });

    testWidgets('pinning reorders the list and the pin lights up',
        (WidgetTester tester) async {
      await tester.pumpHistoryPage();
      final Finder cards = _in('list', find.byType(DsHistoryCard));
      expect(
        tester.widget<DsHistoryCard>(cards.at(3)).conversation.id,
        'c-hold',
      );

      await _hover(tester, cards.at(3));
      await tester.pump(DsDurations.transitionDefault);
      await tester.tap(find.descendant(
        of: cards.at(3),
        matching: find.byWidgetPredicate(
          (Widget w) => w is DsButton && w.label == 'Pin conversation',
        ),
      ));
      await tester.pump();

      // Pinned first, then newest — c-hold is the oldest pinned, so it lands
      // third.
      expect(
        tester.widget<DsHistoryCard>(cards.at(2)).conversation.id,
        'c-hold',
      );
      expect(
        tester.widget<DsHistoryCard>(cards.at(2)).conversation.pinned,
        isTrue,
      );
    });

    testWidgets('a pinned row holds its pin lit; an unpinned one reveals it',
        (WidgetTester tester) async {
      await tester.pumpHistoryPage();
      final Finder pinnedCard = find.descendant(
        of: _panel('pinned'),
        matching: find.byType(DsHistoryCard),
      );
      final Finder unpinnedCard = find.descendant(
        of: _panel('unpinned · active'),
        matching: find.byType(DsHistoryCard),
      );

      double opacityOfPin(Finder card) => tester
          .widgetList<AnimatedOpacity>(
            find.descendant(of: card, matching: find.byType(AnimatedOpacity)),
          )
          .first
          .opacity;

      expect(opacityOfPin(pinnedCard), 1);
      expect(opacityOfPin(unpinnedCard), 0);

      await _hover(tester, unpinnedCard);
      await tester.pump(DsDurations.transitionDefault);
      expect(opacityOfPin(unpinnedCard), 1);
    });

    testWidgets('clicking a title runs the blur switch and the strip follows',
        (WidgetTester tester) async {
      await tester.pumpHistoryPage();
      expect(_in('list', _copy('Open: Sealed inventory check')), findsOneWidget);

      await tester.tap(
        _in('list', find.text('Pricing service outage')),
      );
      // `switchTo` blurs OUT first — the store is called at the darkest point,
      // so the strip still reads the old title for `--duration-fast`.
      await tester.pump();
      expect(_in('list', _copy('Open: Sealed inventory check')), findsOneWidget);

      await tester.pump(DsBlurSwitchController.outDuration);
      await tester.pump();
      expect(_in('list', _copy('Open: Pricing service outage')), findsOneWidget);

      await tester.pump(DsBlurSwitchController.inDuration);
      await tester.pump();
    });

    testWidgets('the palette opens on Pinned + Recent and filters to 1 match',
        (WidgetTester tester) async {
      await tester.pumpHistoryPage();
      expect(find.byType(DsCommand), findsNothing);

      await tester.tap(find.text('Search conversations'));
      await _settleOverlay(tester);
      expect(find.byType(DsCommand), findsOneWidget);
      expect(_copy('Pinned'), findsOneWidget);
      expect(_copy('Recent'), findsOneWidget);
      // `RECENT = 6`, and only five conversations are unpinned.
      expect(find.byType(DsCommandItem), findsNothing); // it is not a Widget
      expect(
        tester.widget<DsCommand>(find.byType(DsCommand)).groups.length,
        2,
      );

      await tester.enterText(
        find.descendant(
          of: find.byType(DsCommand),
          matching: find.byType(DsInput),
        ),
        'odds',
      );
      await tester.pump();
      final DsCommand command =
          tester.widget<DsCommand>(find.byType(DsCommand));
      expect(command.groups, hasLength(1));
      expect(command.groups.first.heading, '1 match');
      expect(command.groups.first.items.first.label,
          'How pack odds actually work');
    });

    testWidgets('the palette matches the PREVIEW, not just the title',
        (WidgetTester tester) async {
      await tester.pumpHistoryPage();
      await tester.tap(find.text('Search conversations'));
      await _settleOverlay(tester);
      await tester.enterText(
        find.descendant(
          of: find.byType(DsCommand),
          matching: find.byType(DsInput),
        ),
        'CSV',
      );
      await tester.pump();
      final DsCommand command =
          tester.widget<DsCommand>(find.byType(DsCommand));
      // "Export my last 30 days as a CSV" — the word is nowhere in the title.
      expect(command.groups.first.items.first.label,
          'Thirty-day activity export');
      expect(command.groups.first.heading, '1 match');
    });

    testWidgets('the drawer opens inside the console and closes on its scrim',
        (WidgetTester tester) async {
      await tester.pumpHistoryPage();
      expect(find.text('Conversations'), findsNothing);

      await tester.tap(find.byWidgetPredicate(
        (Widget w) => w is DsButton && w.label == 'Open sidebar',
      ));
      await _settleOverlay(tester);
      expect(find.text('Conversations'), findsOneWidget);
      expect(find.text('New chat'), findsOneWidget);
      // The drawer splits what §1's flat list does not.
      expect(_copy('Pinned'), findsOneWidget);
      expect(_copy('Recents'), findsOneWidget);
      // `max-w-sm`, full height of the console.
      final Size drawer = tester.getSize(find.text('Conversations').first);
      expect(drawer.width, lessThan(DsChatHistory.width));

      await tester.tap(find.byWidgetPredicate(
        (Widget w) => w is DsButton && w.label == 'Close sidebar',
      ));
      await _settleOverlay(tester);
      expect(find.text('Conversations'), findsNothing);
    });
  });
}
