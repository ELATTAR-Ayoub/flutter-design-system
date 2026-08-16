/// `/design-system/components/base/chat` — the page, against the numbers the
/// reference actually renders.
///
/// Two harnesses, the same split every page test in this suite uses:
///
///  * [pumpChatInShell] mounts the real `DocsShell` at the 1440 × 900 reference
///    frame and hands back the reading column's `RenderBox`. Every oracle
///    number is measured from that origin, **pristine** — nothing hovered,
///    nothing scrolled, no preview open — which is the state the oracle was
///    read in.
///  * [pumpChatPage] mounts the page alone in a tall frame so every specimen is
///    laid out and hit-testable at once. The fidelity bar for this page is that
///    all of them are live, and that is what this file proves.
///
/// The oracle is `node tool/verify/section-oracle.js
/// /design-system/components/base/chat light` plus `scratchpad/ba2-chat-inv.js`
/// for the reading column itself, both run on 2026-08-16. No clock is involved:
/// nothing on this page is dated.
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
import 'package:example/pages/chat.dart';
import 'package:example/shell.dart';
import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FontLoader;
import 'package:flutter_test/flutter_test.dart';

/* ── The frame and the oracle ────────────────────────────────────────────── */

/// Tall enough to lay the whole page out at once, so nothing needs scrolling
/// into view before it can be tapped.
const Size _desktop = Size(1440, 10000);

/// The frame the reference is measured at.
const Size _referenceFrame = Size(1440, 900);

const String _route = '$dsRoot/components/base/chat';

/// `--width-content`.
const double _columnWidth = 1080;

/// `main` at 64, plus its own 48px of top padding.
const double _columnTop = 112;

/// The reading column's own height — `main`'s 8478 less its `py-12` on both
/// edges, and the number `vertical_parity_probe_test.dart`'s
/// `_referenceHeight` takes for this route at integration.
const double _columnHeight = 8382.03;

/// `document.documentElement.scrollHeight` at 1440 × 900, for the record.
const double _documentHeight = 8542;

/// Each `section[id]`, as `(document top, border-box height)`.
///
/// The heights are the CSS border box, so `mb-20` — which this port pays as
/// padding inside the section's own box — comes back off before comparing.
const Map<String, ({double top, double height})> _sectionOracle =
    <String, ({double top, double height})>{
  'message': (top: 626.4, height: 867.6),
  'bubble': (top: 1574, height: 1876.4),
  'message-scroller': (top: 3530.4, height: 1027.7),
  'attachment': (top: 4638.1, height: 1813.1 + _wrapResidual),
  'why': (top: 6531.2 + _wrapResidual, height: 1781.8),
};

/// ONE MEASURED RESIDUAL, recorded rather than tuned away.
///
/// §4's *"preview and download"* Note wraps to **eleven** `type-small` lines
/// here and **ten** in Chrome — one 19.5px line, in a three-paragraph block of
/// 219px of copy reproduced word for word. Every other block on the page is
/// inside half a pixel, so this is a line-breaker difference on one paragraph
/// and not a style drift: the Note is the same 1030px wide, on the same
/// 13px/1.5 rung, under the same padding, and the panel around it differs by
/// exactly one line.
///
/// It is added to the two numbers it reaches — the `attachment` section's own
/// height and everything stacked under it — rather than folded into
/// [_tolerance], so the band stays tight enough to catch anything else.
const double _wrapResidual = 19.51;

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
  /// framework's own does not win — which also stills the shimmer, and is the
  /// only reason this file can end a test without a live ticker.
  Future<void> pumpChatPage({DsThemeMode mode = DsThemeMode.light}) async {
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
                  child: const SingleChildScrollView(child: ChatPage()),
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
Future<RenderBox> pumpChatInShell(
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

  const Widget page = ChatPage();
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
  // No settle: geometry is settled on the first laid-out frame, and the page
  // carries a repeating shimmer that would never let a settle return.
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

/// A string as the page *authors* it.
///
/// `find.text` matches the rendered `Text`, and three of the kit's rungs
/// (`.type-micro`, `.type-caption`, `.type-label`) paint uppercase — so a
/// specimen labelled `secondary` is found as `SECONDARY` or not at all.
/// [DsText] keeps the source string, which is what this reads.
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
      final RenderBox column = await pumpChatInShell(tester);
      expect(column.size.width, _columnWidth);
    });

    testWidgets('the column stacks to the reference height',
        (WidgetTester tester) async {
      final RenderBox column = await pumpChatInShell(tester);
      expect(
        column.size.height,
        closeTo(_columnHeight + _wrapResidual, _tolerance),
      );
      // The document number the same run reports, kept so a reader can check
      // the derivation: column + `main`'s own py-12 twice + the header.
      expect(
        _columnHeight + ds(12) * 2 + DsWidths.siteHeader,
        closeTo(_documentHeight, _tolerance),
      );
    });

    testWidgets('every section starts and ends where the reference does',
        (WidgetTester tester) async {
      final RenderBox column = await pumpChatInShell(tester);

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

    testWidgets('the scroller panel body is exactly h-80',
        (WidgetTester tester) async {
      final RenderBox column = await pumpChatInShell(tester);
      final ({double top, double height}) frame = _boxIn(
        tester,
        column,
        _in('message-scroller', find.byType(DsMessageScroller)),
      );
      expect(frame.height, closeTo(320, _fineTolerance));
    });

    testWidgets('the two count panels sit on --card, the others on --background',
        (WidgetTester tester) async {
      await pumpChatInShell(tester);
      final DsThemeData theme =
          DsTheme.of(tester.element(find.byType(ChatPage)));
      // DRIFT 3 — the ring assumes a card surface.
      expect(tester.widget<DsPanel>(_panel('Reactions')).bodyFill, theme.card);
      expect(
        tester.widget<DsPanel>(_panel('Reactions with counts')).bodyFill,
        theme.card,
      );
      expect(tester.widget<DsPanel>(_panel('Alignment')).bodyFill, isNull);
    });

    testWidgets('the page renders in both themes at the same height',
        (WidgetTester tester) async {
      final RenderBox light = await pumpChatInShell(tester);
      final double lightHeight = light.size.height;
      final RenderBox dark =
          await pumpChatInShell(tester, mode: DsThemeMode.dark);
      expect(dark.size.height, closeTo(lightHeight, 0.01));
    });
  });

  /* ── Structure ─────────────────────────────────────────────────────────── */

  group('structure', () {
    testWidgets('the five sections the nav promises all exist',
        (WidgetTester tester) async {
      await tester.pumpChatPage();
      final DsCategoryHit here = findCategory('base', 'chat');
      expect(here.category.contents, hasLength(5));
      for (final String id in <String>[
        'message',
        'bubble',
        'message-scroller',
        'attachment',
        'why',
      ]) {
        expect(_section(id), findsOneWidget, reason: id);
      }
    });

    testWidgets('the state grid shows all seven variants plus asChild',
        (WidgetTester tester) async {
      await tester.pumpChatPage();
      for (final DsBubbleVariant v in DsBubbleVariant.values) {
        // `findsWidgets`, not one: a cell's own note repeats some of these
        // words, and the claim here is that every variant is on screen.
        expect(_in('bubble', _copy(v.label)), findsWidgets, reason: v.label);
      }
      expect(_in('bubble', _copy('asChild')), findsOneWidget);
      expect(_in('bubble', find.text('Open the set')), findsOneWidget);
    });

    testWidgets('the five attachment states are all on screen',
        (WidgetTester tester) async {
      await tester.pumpChatPage();
      for (final String label in <String>[
        'idle',
        'uploading',
        'processing',
        'error',
        'done',
      ]) {
        expect(_in('attachment', _copy(label)), findsOneWidget);
      }
      // The error row's own copy.
      expect(_in('attachment', _copy('Upload failed')), findsOneWidget);
      // Two shimmering titles, and only two.
      expect(find.byType(DsShimmerText), findsNWidgets(2));
    });

    testWidgets('the transcript is eleven turns, alternating sides',
        (WidgetTester tester) async {
      await tester.pumpChatPage();
      expect(
        _in('message-scroller', find.byType(DsMessageScrollerItem)),
        findsNWidgets(11),
      );
      expect(
        _in('message-scroller', find.text('Which three?')),
        findsOneWidget,
      );
    });

    testWidgets('the tray holds six cards and the sizes row three',
        (WidgetTester tester) async {
      await tester.pumpChatPage();
      expect(
        find.descendant(
          of: find.byType(DsAttachmentGroup),
          matching: find.byType(DsAttachment),
        ),
        findsNWidgets(6),
      );
      expect(
        find.descendant(
          of: _panel('Horizontal, at all three sizes'),
          matching: find.byType(DsAttachment),
        ),
        findsNWidgets(3),
      );
      for (final String label in <String>[
        'size=default',
        'size=sm',
        'size=xs',
      ]) {
        expect(_copy(label), findsOneWidget);
      }
    });

    testWidgets('§5 prints both halves for all four primitives',
        (WidgetTester tester) async {
      await tester.pumpChatPage();
      expect(_in('why', _copy('What it is for')), findsNWidgets(4));
      expect(
        _in('why', _copy('What the console does instead')),
        findsNWidgets(4),
      );
      for (final String name in <String>[
        'Message',
        'Bubble',
        'Message Scroller',
        'Attachment',
      ]) {
        expect(_in('why', _panel(name)), findsOneWidget, reason: name);
      }
    });
  });

  /* ── Behaviour: every specimen answers a pointer ───────────────────────── */

  group('live specimens', () {
    testWidgets('the scroller opens at the top with the button showing',
        (WidgetTester tester) async {
      await tester.pumpChatPage();
      final DsMessageScrollerController c =
          DsMessageScrollerProvider.of(tester.element(
        find.byType(DsMessageScrollerViewport),
      ));
      expect(c.offset, 0);
      expect(c.scrollable(DsScrollDirection.end), isTrue);
      final AnimatedOpacity fade = tester.widget<AnimatedOpacity>(
        find.descendant(
          of: find.byType(DsMessageScrollerButton),
          matching: find.byType(AnimatedOpacity),
        ),
      );
      expect(fade.opacity, 1);
    });

    testWidgets('pressing the button jumps to the end and hides it',
        (WidgetTester tester) async {
      await tester.pumpChatPage();
      final DsMessageScrollerController c =
          DsMessageScrollerProvider.of(tester.element(
        find.byType(DsMessageScrollerViewport),
      ));
      final double max = c.maxOffset;
      expect(max, greaterThan(0));

      await tester.tap(find.byType(DsMessageScrollerButton));
      await tester.pump();
      // `ScrollPosition.animateTo` runs on its own ticker and takes no notice
      // of `disableAnimations`, so the smooth scroll is pumped rather than
      // collapsed: `frame x sqrt(397)` is 332ms.
      await tester.pump(const Duration(milliseconds: 600));
      expect(c.offset, closeTo(max, 1));
      expect(c.scrollable(DsScrollDirection.end), isFalse);

      final AnimatedOpacity fade = tester.widget<AnimatedOpacity>(
        find.descendant(
          of: find.byType(DsMessageScrollerButton),
          matching: find.byType(AnimatedOpacity),
        ),
      );
      expect(fade.opacity, 0);
    });

    testWidgets('the asChild bubble takes a tap', (WidgetTester tester) async {
      await tester.pumpChatPage();
      await tester.tap(_in('bubble', find.text('Open the set')));
      await tester.pump();
      // Nothing to assert but that it did not throw: the reference's own
      // handler is empty too.
      expect(_in('bubble', find.text('Open the set')), findsOneWidget);
    });

    testWidgets('a reaction pill opens its count under a pointer',
        (WidgetTester tester) async {
      await tester.pumpChatPage();
      // Both counts are in the tree at rest — that is the whole point of §7's
      // rule. What the hover changes is the pill's width.
      expect(find.text('12'), findsNWidgets(2));

      final Finder pill = find
          .descendant(
            of: _panel('Reactions with counts'),
            matching: find.byType(DsPress),
          )
          .first;
      final double collapsed = tester.getSize(pill).width;

      final TestGesture pointer =
          await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(pointer.removePointer);
      await pointer.addPointer(location: Offset.zero);
      await tester.pump();
      await pointer.moveTo(tester.getCenter(pill));
      await tester.pump();
      await tester.pump(DsDurations.transitionDefault);

      // Measured on the reference: 39.86 collapsed, 55.86 open — the count's
      // own `w-4` plus nothing else.
      expect(tester.getSize(pill).width - collapsed, closeTo(16, 0.5));
    });

    testWidgets('the save control rolls and raises the Saving toast',
        (WidgetTester tester) async {
      await tester.pumpChatPage();
      addTearDown(docsToasts.clear);

      final Finder action = find.byType(DsAttachmentAction).last;
      expect(tester.widget<DsIconSwap>(
        find.descendant(of: action, matching: find.byType(DsIconSwap)),
      ).activeIndex, 0);

      await tester.tap(action);
      await tester.pump();
      expect(tester.widget<DsIconSwap>(
        find.descendant(of: action, matching: find.byType(DsIconSwap)),
      ).activeIndex, 1);
      // *Saving*, never *Saved*.
      expect(docsToasts.length, 1);

      await tester.pump(DsAttachmentAction.savingWindow);
      await tester.pump();
      expect(tester.widget<DsIconSwap>(
        find.descendant(of: action, matching: find.byType(DsIconSwap)),
      ).activeIndex, 0);
    });

    testWidgets('the sample card opens full size over the dimmed page',
        (WidgetTester tester) async {
      await tester.pumpChatPage();
      expect(find.byType(DsDialogOverlay), findsNothing);

      await tester.tap(find.byType(DsAttachmentTrigger));
      await tester.pump();
      await tester.pump();
      expect(find.byType(DsDialogOverlay), findsOneWidget);

      // The close control is a `secondary` 40px icon button, and it closes.
      final Finder close = find.byWidgetPredicate(
        (Widget w) =>
            w is DsButton &&
            w.label == 'Close' &&
            w.variant == DsButtonVariant.secondary &&
            w.size == DsButtonSize.icon,
      );
      expect(close, findsOneWidget);
      expect(tester.getSize(close), const Size(40, 40));
      await tester.tap(close);
      await tester.pump();
      await tester.pump(DsDurations.base);
      await tester.pump();
      expect(find.byType(DsDialogOverlay), findsNothing);
    });

    testWidgets('the tray scrolls sideways', (WidgetTester tester) async {
      // The shell harness, not the tall one: the tray only overflows inside
      // the 1080px reading column, which is the frame it was measured in
      // (1030 visible over 1055 of cards).
      await pumpChatInShell(tester);
      final Finder tray = find.byType(DsAttachmentGroup);
      final ScrollableState scrollable = tester.state<ScrollableState>(
        find.descendant(of: tray, matching: find.byType(Scrollable)),
      );
      final double max = scrollable.position.maxScrollExtent;
      expect(max, greaterThan(0));

      scrollable.position.jumpTo(max);
      await tester.pump();
      expect(scrollable.position.pixels, closeTo(max, 0.5));
      // At the far end the trailing fade has closed and the leading one has
      // opened — the mask is scroll-driven, not static.
      expect(find.byType(ShaderMask), findsWidgets);
      // The snap runs on the next frame and holds the edge, because the edge
      // *is* a snap target once the travel is shorter than one card.
      await tester.pump();
      await tester.pump(DsDurations.transitionDefault);
      expect(scrollable.position.pixels, closeTo(max, 0.5));
    });
  });
}
