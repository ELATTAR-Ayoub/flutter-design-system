/// `/design-system/components/agent/transcript` — the page, against the
/// numbers the reference actually renders.
///
/// Two harnesses, the same split every page test in this suite uses:
///
///  * [pumpTranscriptInShell] mounts the real `DocsShell` at the 1440 × 900
///    reference frame and hands back the reading column's `RenderBox`. Every
///    oracle number is measured from that origin, **pristine** — nothing
///    hovered, nothing opened, nothing scrolled — which is the state the oracle
///    was read in.
///  * [pumpTranscriptPage] mounts the page alone in a tall frame so every
///    specimen is laid out and hit-testable at once. The fidelity bar for this
///    page is that all of them are live, and that is what this file proves.
///
/// The oracle is `node tool/verify/section-oracle.js
/// /design-system/components/agent/transcript` plus `scratchpad/ag-inv-t1..t3`
/// for the boxes inside, all read on 2026-08-16. No clock is involved: nothing
/// on this page is dated.
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
import 'package:example/pages/transcript.dart';
import 'package:example/shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FontLoader, LogicalKeyboardKey;
import 'package:flutter_test/flutter_test.dart';

/* ── The frame and the oracle ────────────────────────────────────────────── */

/// Tall enough to lay the whole page out at once, so nothing needs scrolling
/// into view before it can be tapped.
const Size _desktop = Size(1440, 12000);

/// The frame the reference is measured at.
const Size _referenceFrame = Size(1440, 900);

const String _route = '$dsRoot/components/agent/transcript';

/// `--width-content`.
const double _columnWidth = 1080;

/// `main` at 64, plus its own 48px of top padding.
const double _columnTop = 112;

/// The reading column's own height at 1440 × 900.
const double _columnHeight = 10466.11;

/// Each `section[id]`, as `(document top, border-box height)`.
///
/// The heights are the CSS border box, so `mb-20` — which this port pays as
/// padding inside the section's own box — comes back off before comparing.
const Map<String, ({double top, double height})> _sectionOracle =
    <String, ({double top, double height})>{
  'turns': (top: 407.89, height: 438.19),
  'tools': (top: 926.08, height: 510.20),
  'approval': (top: 1516.28, height: 624.19),
  'questionnaire': (top: 2220.47, height: 995.17),
  'markdown': (top: 3295.64, height: 4706.30),
  'welcome': (top: 8081.94, height: 610.09),
  'attachments': (top: 8772.03, height: 1625.08),
};

/// `#markdown-not-supported` sits **inside** `#markdown`, so its 701.8 is part
/// of that section's 4706.3 rather than added to it.
const ({double top, double height}) _nestedOracle =
    (top: 7300.14, height: 701.8);

/// Two logical pixels — the band the aggregates hold.
const double _tolerance = 2;

/// Half a pixel — the band the column itself holds. Measured 10466.246
/// against the reference's 10466.11, and no section anchor is more than 0.12
/// off, so the aggregate claim is the tight one.
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
  /// framework's own does not win — which also stills the typing caret's
  /// perpetual pulse, and is the only reason this file can end a test without
  /// a live ticker.
  Future<void> pumpTranscriptPage({DsThemeMode mode = DsThemeMode.light}) async {
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
                  child: const SingleChildScrollView(
                    child: SizedBox(
                      width: _columnWidth,
                      child: TranscriptPage(),
                    ),
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
Future<RenderBox> pumpTranscriptInShell(
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

  const Widget page = TranscriptPage();
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
  // carries a perpetual caret pulse that would never let a settle return.
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
/// uppercase, so a cell labelled `Skipped` is found as `SKIPPED` or not at all.
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
      final RenderBox column = await pumpTranscriptInShell(tester);
      expect(column.size.width, _columnWidth);
    });

    testWidgets('the column stacks to the reference height',
        (WidgetTester tester) async {
      final RenderBox column = await pumpTranscriptInShell(tester);
      expect(column.size.height, closeTo(_columnHeight, _fineTolerance));
    });

    testWidgets('every section starts and ends where the reference does',
        (WidgetTester tester) async {
      final RenderBox column = await pumpTranscriptInShell(tester);

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

    testWidgets('markdown-not-supported is nested inside markdown',
        (WidgetTester tester) async {
      final RenderBox column = await pumpTranscriptInShell(tester);
      // The finder is a descendant lookup, which is the claim: the inner
      // section is *inside* the outer one, not beside it.
      expect(
        _in('markdown', _section('markdown-not-supported')),
        findsOneWidget,
      );
      final ({double top, double height}) got =
          _boxIn(tester, column, _section('markdown-not-supported'));
      expect(got.top, closeTo(_nestedOracle.top - _columnTop, _fineTolerance));
      expect(
        got.height - ds(20),
        closeTo(_nestedOracle.height, _fineTolerance),
      );
    });

    testWidgets('the page renders in both themes at the same height',
        (WidgetTester tester) async {
      final RenderBox light = await pumpTranscriptInShell(tester);
      final double lightHeight = light.size.height;
      final RenderBox dark =
          await pumpTranscriptInShell(tester, mode: DsThemeMode.dark);
      expect(dark.size.height, closeTo(lightHeight, 0.01));
    });
  });

  /* ── Structure ─────────────────────────────────────────────────────────── */

  group('structure', () {
    testWidgets('the eight sections the nav promises all exist',
        (WidgetTester tester) async {
      await tester.pumpTranscriptPage();
      final DsCategoryHit here = findCategory('agent', 'transcript');
      expect(here.category.contents, hasLength(8));
      for (final String id in <String>[
        'turns',
        'tools',
        'approval',
        'questionnaire',
        'markdown',
        'markdown-not-supported',
        'welcome',
        'attachments',
      ]) {
        expect(_section(id), findsOneWidget, reason: id);
      }
    });

    testWidgets('the four tool chips carry the mapped state labels',
        (WidgetTester tester) async {
      await tester.pumpTranscriptPage();
      expect(_in('tools', find.byType(DsToolChip)), findsNWidgets(4));
      // `AGENT_STATE_LABEL`, not a paraphrase — and the failed chip states its
      // attempt count, which is the whole point of §2's Note.
      expect(_in('tools', _copy('Searching')), findsNWidgets(2));
      expect(_in('tools', _copy('Writing')), findsOneWidget);
      expect(
        _in('tools', _copy('Retrieving knowledge · attempt 2')),
        findsOneWidget,
      );
      // The produced CSV rides beside its chip.
      expect(_in('tools', _copy('activity-30d.csv')), findsOneWidget);
    });

    testWidgets('the approval card says what it costs, in words',
        (WidgetTester tester) async {
      await tester.pumpTranscriptPage();
      expect(
        _in('approval', _copy('Needs your approval')),
        findsOneWidget,
      );
      expect(
        _in(
          'approval',
          _copy(
            r'Buy Eclipse Vault — 1st Edition for $129.00. This spends real '
            'money and cannot be undone.',
          ),
        ),
        findsOneWidget,
      );
      expect(_in('approval', find.text('Approve')), findsOneWidget);
      expect(_in('approval', find.text('Decline')), findsOneWidget);
    });

    testWidgets('the state grid shows all six questionnaire states',
        (WidgetTester tester) async {
      await tester.pumpTranscriptPage();
      for (final String label in <String>[
        'Unanswered',
        'Answered',
        'Skipped',
        'Invalid',
        'Submitting',
        'Complete',
      ]) {
        expect(_in('questionnaire', _copy(label)), findsOneWidget,
            reason: label);
      }
      expect(
        _in('questionnaire', _copy('optional questions only')),
        findsOneWidget,
      );
      expect(
        _in('questionnaire', _copy('Saving your answers…')),
        findsOneWidget,
      );
      expect(_in('questionnaire', _copy('That’s everything.')), findsOneWidget);
    });

    testWidgets('the three delivery outcomes are drawn and only two speak',
        (WidgetTester tester) async {
      await tester.pumpTranscriptPage();
      // `content` says Read, `reference` says Name only, `produced` says
      // nothing at all.
      expect(_in('attachments', _copy('Read')), findsNWidgets(2));
      expect(_in('attachments', _copy('Name only')), findsNWidgets(2));
      expect(
        _in('attachments', find.byType(DsAgentAttachmentList)),
        findsNWidgets(2),
      );
    });

    testWidgets('every markdown case renders both halves',
        (WidgetTester tester) async {
      await tester.pumpTranscriptPage();
      // Six block cases plus four inline ones, each with a source block and a
      // rendered block, plus the three standalone renders (specimen, tables,
      // everything-together).
      expect(
        _in('markdown', find.byType(DsAgentMarkdown)),
        findsNWidgets(10 + 3),
      );
      expect(_in('markdown', _panel('Tables')), findsOneWidget);
      expect(_in('markdown', _panel('Everything together')), findsOneWidget);
      expect(
        _in('markdown-not-supported', _copy('Headings 5–6')),
        findsOneWidget,
      );
    });

    testWidgets('the welcome card advertises three skills and four prompts',
        (WidgetTester tester) async {
      await tester.pumpTranscriptPage();
      expect(_in('welcome', find.text('inventory')), findsOneWidget);
      expect(_in('welcome', find.text('wallet')), findsOneWidget);
      expect(_in('welcome', find.text('export')), findsOneWidget);
      for (final String prompt in <String>[
        'What sealed boxes are left?',
        'Export my last 30 days',
        'Buy me an Eclipse Vault pack',
        'What is Eclipse Vault worth right now?',
      ]) {
        expect(_in('welcome', _copy(prompt)), findsOneWidget, reason: prompt);
      }
    });
  });

  /* ── Behaviour: every specimen answers a pointer ───────────────────────── */

  group('live specimens', () {
    testWidgets('a tool chip opens its evidence and closes again',
        (WidgetTester tester) async {
      await tester.pumpTranscriptPage();
      expect(_in('tools', _copy('Arguments')), findsNothing);

      // The chip's own control, not the column: once open, the column's centre
      // is inside the disclosure panel rather than on the button.
      Finder chipButton(int index) => find.descendant(
            of: _in('tools', find.byType(DsToolChip)).at(index),
            matching: find.byType(DsButton),
          );

      await tester.tap(chipButton(0));
      await tester.pump();
      expect(_in('tools', _copy('Tool')), findsOneWidget);
      expect(_in('tools', _copy('Arguments')), findsOneWidget);
      // The raw call, exactly as `JSON.stringify(value, null, 2)` writes it.
      expect(
        find.text(
          '{\n  "query": "sealed booster boxes",\n  "limit": 3\n}',
        ),
        findsOneWidget,
      );

      await tester.tap(chipButton(0));
      await tester.pump();
      expect(_in('tools', _copy('Arguments')), findsNothing);
    });

    testWidgets('the failed chip shows its error rather than a result',
        (WidgetTester tester) async {
      await tester.pumpTranscriptPage();
      await tester.tap(
        find.descendant(
          of: _in('tools', find.byType(DsToolChip)).last,
          matching: find.byType(DsButton),
        ),
      );
      await tester.pump();
      expect(_in('tools', _copy('Error')), findsOneWidget);
      expect(
        _in('tools', _copy('The pricing service did not respond in time.')),
        findsOneWidget,
      );
      expect(_in('tools', _copy('Result')), findsNothing);
    });

    testWidgets('the questionnaire refuses to advance on a required blank',
        (WidgetTester tester) async {
      await tester.pumpTranscriptPage();
      final Finder demo = _in('questionnaire', _panel('Questionnaire'));
      expect(
        find.descendant(of: demo, matching: _copy('Question 1 of 3')),
        findsOneWidget,
      );
      // DRIFT: `<QuestionnaireError />` with no children is not empty.
      expect(
        find.descendant(
          of: demo,
          matching: _copy('Choose an answer to continue.'),
        ),
        findsNothing,
      );

      await tester.tap(find.descendant(of: demo, matching: find.text('Next')));
      await tester.pump();
      expect(
        find.descendant(
          of: demo,
          matching: _copy('Choose an answer to continue.'),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(of: demo, matching: _copy('Question 1 of 3')),
        findsOneWidget,
      );
    });

    testWidgets('answering, skipping and submitting walks the whole wizard',
        (WidgetTester tester) async {
      await tester.pumpTranscriptPage();
      final Finder demo = _in('questionnaire', _panel('Questionnaire'));

      await tester.tap(
        find.descendant(of: demo, matching: _copy('Best odds on a chase card')),
      );
      await tester.pump();
      await tester.tap(find.descendant(of: demo, matching: find.text('Next')));
      await tester.pump();
      expect(
        find.descendant(of: demo, matching: _copy('Question 2 of 3')),
        findsOneWidget,
      );
      // Step 2 is optional, so Skip is on screen and Previous has arrived.
      expect(find.descendant(of: demo, matching: find.text('Skip')),
          findsOneWidget);
      expect(find.descendant(of: demo, matching: find.text('Previous')),
          findsOneWidget);

      await tester.tap(find.descendant(of: demo, matching: find.text('Skip')));
      await tester.pump();
      expect(
        find.descendant(of: demo, matching: _copy('Question 3 of 3')),
        findsOneWidget,
      );
      // The last step swaps Next for Submit, and Skip is gone: it is required.
      expect(find.descendant(of: demo, matching: find.text('Next')),
          findsNothing);
      expect(find.descendant(of: demo, matching: find.text('Submit')),
          findsOneWidget);
      expect(find.descendant(of: demo, matching: find.text('Skip')),
          findsNothing);

      await tester.enterText(
        find.descendant(of: demo, matching: find.byType(DsQuestionnaireInput)),
        '40',
      );
      await tester.pump();
      await tester.tap(find.descendant(of: demo, matching: find.text('Submit')));
      await tester.pump();
      expect(
        find.descendant(of: demo, matching: _copy('Saving your answers…')),
        findsOneWidget,
      );

      await tester.pump(const Duration(seconds: 1));
      expect(
        find.descendant(of: demo, matching: _copy('That’s everything.')),
        findsOneWidget,
      );
      expect(find.descendant(of: demo, matching: find.text('Answer again')),
          findsOneWidget);
    });

    testWidgets('the drawn shortcut is the bound one', (WidgetTester tester) async {
      await tester.pumpTranscriptPage();
      final Finder demo = _in('questionnaire', _panel('Questionnaire'));
      // Every choice renders its key in a `Kbd`.
      for (final String key in <String>['A', 'B', 'C']) {
        expect(
          find.descendant(
            of: demo,
            matching: find.byWidgetPredicate(
              (Widget w) => w is DsKbd && w.text == key,
            ),
          ),
          findsOneWidget,
          reason: key,
        );
      }

      // The handler is `onKeyDown` on the root form, so focus has to be inside
      // it — a click on a choice puts it there, exactly as it does on the web.
      await tester.tap(
        find.descendant(of: demo, matching: _copy("Whatever's cheapest tonight")),
      );
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.keyC);
      await tester.pump();

      // C is the third choice; advancing now must succeed, which it only can
      // if the shortcut actually answered the question.
      await tester.tap(find.descendant(of: demo, matching: find.text('Next')));
      await tester.pump();
      expect(
        find.descendant(of: demo, matching: _copy('Question 2 of 3')),
        findsOneWidget,
      );
    });

    testWidgets('the approval card resolves both ways',
        (WidgetTester tester) async {
      await tester.pumpTranscriptPage();
      // The reference's own handlers are empty; the claim is that both
      // controls are live and neither throws.
      await tester.tap(_in('approval', find.text('Approve')));
      await tester.pump();
      await tester.tap(_in('approval', find.text('Decline')));
      await tester.pump();
      expect(_in('approval', find.byType(DsApprovalCard)), findsOneWidget);
    });

    testWidgets('the openable image expands over the dimmed page',
        (WidgetTester tester) async {
      await tester.pumpTranscriptPage();
      expect(find.byType(DsDialogOverlay), findsNothing);

      await tester.tap(_in('attachments', find.byType(DsAttachmentTrigger)));
      await tester.pump();
      await tester.pump();
      expect(find.byType(DsDialogOverlay), findsOneWidget);

      final Finder close = find.byWidgetPredicate(
        (Widget w) =>
            w is DsButton &&
            w.label == 'Close' &&
            w.variant == DsButtonVariant.secondary,
      );
      expect(close, findsOneWidget);
      await tester.tap(close);
      await tester.pump();
      await tester.pump(DsDurations.base);
      await tester.pump();
      expect(find.byType(DsDialogOverlay), findsNothing);
    });

    testWidgets('the document offers a save and says Saving, never Saved',
        (WidgetTester tester) async {
      await tester.pumpTranscriptPage();
      addTearDown(docsToasts.clear);

      final Finder action =
          _in('attachments', find.byType(DsAttachmentAction)).last;
      await tester.tap(action);
      await tester.pump();
      expect(docsToasts.length, 1);
      expect(
        docsToasts.messageOf(0)!.title,
        'Saving grading-report.pdf',
      );
      // The glyph rolls back after `savingWindow`; letting that timer run is
      // what keeps the teardown clean.
      await tester.pump(DsAttachmentAction.savingWindow);
      await tester.pump();
    });

    testWidgets('a welcome prompt and a skill are both pressable',
        (WidgetTester tester) async {
      await tester.pumpTranscriptPage();
      await tester.tap(_in('welcome', _copy('Export my last 30 days')));
      await tester.pump();
      await tester.tap(_in('welcome', find.text('inventory')));
      await tester.pump();
      expect(_in('welcome', find.byType(DsWelcomeCard)), findsOneWidget);
    });
  });

  /* ── The markdown contract ─────────────────────────────────────────────── */

  group('markdown', () {
    testWidgets('the fence names its normalised language, not the alias',
        (WidgetTester tester) async {
      await tester.pumpTranscriptPage();
      // Three fences on the page, all opened ` ```ts ` and all labelled
      // `typescript`.
      expect(_in('markdown', _copy('typescript')), findsNWidgets(3));
    });

    testWidgets('an ordered list keeps the numbers the author wrote',
        (WidgetTester tester) async {
      await tester.pumpTranscriptPage();
      // `4. / 5) / 7.` — not 1, 2, 3.
      for (final String marker in <String>['4.', '5.', '7.']) {
        expect(find.text(marker), findsWidgets, reason: marker);
      }
    });

    testWidgets('an escaped pipe stays inside its cell',
        (WidgetTester tester) async {
      await tester.pumpTranscriptPage();
      expect(find.text('Aurora | Prism'), findsWidgets);
    });

    testWidgets('a refused scheme keeps its label and loses its link', (
      WidgetTester tester,
    ) async {
      expect(dsSafeHref('/design-system'), '/design-system');
      expect(dsSafeHref('#markdown'), '#markdown');
      expect(dsSafeHref('https://example.com'), isNotNull);
      expect(dsSafeHref('javascript:alert(1)'), isNull);
      expect(dsSafeHref('data:text/html,<script>'), isNull);
    });
  });
}
