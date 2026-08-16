/// `components/agent/parts/*` + `components/ui/questionnaire.tsx` — the
/// package half of the transcript family.
///
/// Three things are proved here that the page test cannot reach: the markdown
/// **parser** as a pure function (every branch of it, including the ones the
/// transcript page never renders), the questionnaire **wizard** as a state
/// machine, and the handful of copy strings the primitives supply when the call
/// site supplies none.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter_test/flutter_test.dart';

/* ── Harness ─────────────────────────────────────────────────────────────── */

Future<void> _pump(WidgetTester tester, Widget child, {double width = 600}) async {
  final DsThemeController theme = DsThemeController(mode: DsThemeMode.light);
  addTearDown(theme.dispose);

  await tester.pumpWidget(
    DsTheme(
      controller: theme,
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
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: SizedBox(width: width, child: child),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

Finder _copy(String text) => find.byWidgetPredicate(
      (Widget widget) => widget is DsText && widget.text == text,
    );

void main() {
  /* ── The parser ────────────────────────────────────────────────────────── */

  group('markdown parser', () {
    test('a blank line closes whatever is open', () {
      final List<DsMarkdownBlock> blocks =
          dsParseMarkdown('one\ntwo\n\nthree');
      expect(blocks, hasLength(2));
      // Adjacent non-empty lines join into one paragraph.
      expect((blocks[0] as DsMarkdownParagraph).lines, <String>['one', 'two']);
      expect((blocks[1] as DsMarkdownParagraph).lines, <String>['three']);
    });

    test('headings one through four are parsed and five is not', () {
      expect(
        (dsParseMarkdown('#### four').single as DsMarkdownHeading).level,
        4,
      );
      // `#####` falls back to paragraph text — one of the nine documented
      // limits.
      expect(dsParseMarkdown('##### five').single, isA<DsMarkdownParagraph>());
    });

    test('dash, asterisk and bullet all open one unordered list', () {
      final DsMarkdownBullets list =
          dsParseMarkdown('- a\n* b\n• c').single as DsMarkdownBullets;
      expect(list.items, <String>['a', 'b', 'c']);
    });

    test('a plain line under an item continues that item', () {
      final DsMarkdownBullets list =
          dsParseMarkdown('- a finding\nwrapped on').single
              as DsMarkdownBullets;
      expect(list.items, <String>['a finding wrapped on']);
    });

    test("an ordered list keeps the author's own numbers", () {
      final DsMarkdownNumbers list =
          dsParseMarkdown('4. one\n5) two\n7. three').single
              as DsMarkdownNumbers;
      expect(list.items.map((DsMarkdownOrderedItem i) => i.n), <int>[4, 5, 7]);
      expect(list.items.last.text, 'three');
    });

    test('consecutive quote lines join into one blockquote', () {
      final DsMarkdownQuote quote =
          dsParseMarkdown('> one\n> two').single as DsMarkdownQuote;
      expect(quote.lines, <String>['one', 'two']);
    });

    test('an unterminated fence runs to the end rather than being dropped', () {
      final DsMarkdownFence fence =
          dsParseMarkdown('```ts\nconst a = 1;\nconst b = 2;').single
              as DsMarkdownFence;
      expect(fence.lang, 'ts');
      expect(fence.lines, <String>['const a = 1;', 'const b = 2;']);
    });

    test('a fence is never scanned for other syntax', () {
      final DsMarkdownFence fence =
          dsParseMarkdown('```\n# not a heading\n- not a bullet\n```').single
              as DsMarkdownFence;
      expect(fence.lines, <String>['# not a heading', '- not a bullet']);
    });

    test('a pipe without a delimiter row is a sentence, not a table', () {
      expect(
        dsParseMarkdown('a | b is just prose').single,
        isA<DsMarkdownParagraph>(),
      );
    });

    test('the delimiter row sets alignment and escaped pipes stay in cells',
        () {
      final DsMarkdownTable table = dsParseMarkdown(
        '| Pack | Left | Last |\n|:---|---:|:---:|\n'
        r'| Aurora \| Prism | 61 | $84.50 |',
      ).single as DsMarkdownTable;
      expect(table.head, <String>['Pack', 'Left', 'Last']);
      expect(table.align, <DsMarkdownAlign>[
        DsMarkdownAlign.left,
        DsMarkdownAlign.right,
        DsMarkdownAlign.center,
      ]);
      expect(table.rows.single.first, 'Aurora | Prism');
    });

    test('a ragged streaming row is padded to the header width', () {
      final DsMarkdownTable table = dsParseMarkdown(
        '| a | b | c |\n|---|---|---|\n| 1 |',
      ).single as DsMarkdownTable;
      expect(table.rows.single, <String>['1', '', '']);
    });

    test('empty source renders nothing at all', () {
      expect(dsParseMarkdown(''), isEmpty);
    });
  });

  group('safeHref', () {
    test('root-relative paths and fragments pass through untouched', () {
      expect(dsSafeHref('/design-system'), '/design-system');
      expect(dsSafeHref('#markdown'), '#markdown');
    });

    test('http and https survive, every other scheme is refused', () {
      expect(dsSafeHref('https://example.com/docs'), isNotNull);
      expect(dsSafeHref('http://example.com'), isNotNull);
      // `javascript:` is the reason this function exists.
      expect(dsSafeHref('javascript:alert(1)'), isNull);
      expect(dsSafeHref('data:text/html,<script>'), isNull);
      expect(dsSafeHref('mailto:a@b.c'), isNull);
      expect(dsSafeHref('not a url'), isNull);
    });
  });

  group('code block', () {
    test('LANGUAGE_ALIASES normalises, and an unknown fence stays plain', () {
      expect(DsAgentCodeBlock.normalise('ts'), 'typescript');
      expect(DsAgentCodeBlock.normalise('TSX'), 'tsx');
      expect(DsAgentCodeBlock.normalise('sh'), 'bash');
      expect(DsAgentCodeBlock.normalise('md'), 'markdown');
      expect(DsAgentCodeBlock.normalise('rust'), isNull);
      expect(DsAgentCodeBlock.normalise(''), isNull);
      expect(DsAgentCodeBlock.normalise(null), isNull);
    });

    test('the tokeniser colours the five classes the palette paints', () {
      final List<DsCodeToken> line = dsTokenise(
        'const odds = pulls.filter((p) => p.rarity === "grail").length;',
        'typescript',
      ).single;
      Color colourOf(String text) =>
          line.firstWhere((DsCodeToken t) => t.text == text).color;

      expect(colourOf('const'), DsPrismPalette.keyword);
      expect(colourOf('filter'), DsPrismPalette.function);
      expect(colourOf('"grail"'), DsPrismPalette.string);
      expect(colourOf('odds'), DsPrismPalette.plain);
    });

    test('a comment runs to the end of its line', () {
      final List<DsCodeToken> line =
          dsTokenise('const a = 1; // and the rest', 'typescript').single;
      expect(line.last.color, DsPrismPalette.comment);
      expect(line.last.text, '// and the rest');
    });

    test('python and bash take their own comment marker', () {
      expect(
        dsTokenise('# a note', 'python').single.single.color,
        DsPrismPalette.comment,
      );
      expect(
        dsTokenise('# a note', 'bash').single.single.color,
        DsPrismPalette.comment,
      );
    });
  });

  /* ── Rendering ─────────────────────────────────────────────────────────── */

  group('markdown rendering', () {
    testWidgets('a fence names its normalised language over the body',
        (WidgetTester tester) async {
      await _pump(tester, const DsAgentMarkdown(text: '```ts\nconst a = 1;\n```'));
      expect(_copy('typescript'), findsOneWidget);
      // The body is a span tree, one span per Prism token, so it is read back
      // off the paragraph rather than found as a `Text`.
      expect(
        tester
            .widgetList<RichText>(find.byType(RichText))
            .map((RichText r) => r.text.toPlainText()),
        contains('const a = 1;'),
      );
    });

    testWidgets('an unknown language gets no header strip at all',
        (WidgetTester tester) async {
      await _pump(
        tester,
        const DsAgentMarkdown(text: '```rust\nlet a = 1;\n```'),
      );
      expect(_copy('rust'), findsNothing);
      expect(find.byType(DsPreformattedCode), findsOneWidget);
    });

    testWidgets('a bare URL keeps the sentence full stop it swallowed',
        (WidgetTester tester) async {
      // DRIFT, reproduced: `[^\s<>()]+` does not exclude `.`, so the label the
      // reference measures is 149.22px of `https://example.com.` — period
      // included.
      await _pump(tester, const DsAgentMarkdown(text: 'Visit https://example.com.'));
      final RichText paragraph = tester.widget<RichText>(
        find.byType(RichText).first,
      );
      expect(paragraph.text.toPlainText(), 'Visit https://example.com.');
    });

    testWidgets('an ordered list draws the authored numbers',
        (WidgetTester tester) async {
      await _pump(tester, const DsAgentMarkdown(text: '4. one\n5) two\n7. three'));
      for (final String marker in <String>['4.', '5.', '7.']) {
        expect(find.text(marker), findsOneWidget, reason: marker);
      }
    });

    testWidgets('a table is a Table, and a lone pipe is not',
        (WidgetTester tester) async {
      await _pump(
        tester,
        const DsAgentMarkdown(text: '| a | b |\n|---|---|\n| 1 | 2 |'),
      );
      expect(find.byType(Table), findsOneWidget);

      await _pump(tester, const DsAgentMarkdown(text: 'a | b'));
      expect(find.byType(Table), findsNothing);
    });
  });

  /* ── Turns ─────────────────────────────────────────────────────────────── */

  group('turns', () {
    testWidgets('the user bubble is capped at 85% and squares one corner',
        (WidgetTester tester) async {
      await _pump(
        tester,
        const DsUserMessage(
          turn: DsUserTurn(id: 'u', text: 'What sealed boxes are left?'),
        ),
      );
      final Container bubble = tester.widget<Container>(
        find.byType(Container).first,
      );
      final BoxDecoration decoration = bubble.decoration! as BoxDecoration;
      expect(
        decoration.borderRadius,
        BorderRadius.only(
          topLeft: const Radius.circular(DsRadii.xl),
          topRight: const Radius.circular(DsRadii.xl),
          bottomRight: const Radius.circular(DsRadii.sm),
          bottomLeft: const Radius.circular(DsRadii.xl),
        ),
      );
      expect(
        tester.getSize(find.byType(Container).first).width,
        lessThanOrEqualTo(600 * DsUserMessage.maxWidthFraction + 0.01),
      );
    });

    testWidgets('the agent turn strips a half-arrived protocol tag',
        (WidgetTester tester) async {
      await _pump(
        tester,
        const DsAgentMessage(
          turn: DsTextTurn(id: 'a', text: 'Done.<complete> and <comp'),
        ),
      );
      final RichText paragraph =
          tester.widget<RichText>(find.byType(RichText).first);
      // `stripProtocol` leaves a trailing space and the paragraph builder
      // trims it, exactly as the reference's `lines.join(" ")` does.
      expect(paragraph.text.toPlainText(), 'Done. and');
    });

    testWidgets('the caret is drawn only on a streaming turn',
        (WidgetTester tester) async {
      await _pump(
        tester,
        const DsAgentMessage(turn: DsTextTurn(id: 'a', text: 'Checking')),
      );
      expect(find.byType(DsTypingCursor), findsNothing);

      await _pump(
        tester,
        const DsAgentMessage(
          turn: DsTextTurn(id: 'a', text: 'Checking', streaming: true),
        ),
      );
      expect(find.byType(DsTypingCursor), findsOneWidget);
    });

    testWidgets('an empty turn with no attachments renders nothing',
        (WidgetTester tester) async {
      await _pump(
        tester,
        const DsAgentMessage(turn: DsTextTurn(id: 'a', text: '   ')),
      );
      expect(find.byType(DsAgentMarkdown), findsNothing);
    });
  });

  /* ── Chips ─────────────────────────────────────────────────────────────── */

  group('tool chip', () {
    const DsToolTurn unmapped = DsToolTurn(
      id: 't',
      name: 'export_activity',
      params: <String, Object?>{'window': '30d'},
      status: DsAgentTurnStatus.ok,
      attempt: 1,
    );

    testWidgets('an unmapped tool falls back to its own humanised name',
        (WidgetTester tester) async {
      await _pump(tester, const DsToolChip(turn: unmapped));
      // The name is the most honest thing available — never "used a tool".
      expect(_copy('Export activity'), findsOneWidget);
    });

    testWidgets('a mapped tool takes AGENT_STATE_LABEL verbatim',
        (WidgetTester tester) async {
      await _pump(
        tester,
        const DsToolChip(
          turn: unmapped,
          toolStates: <String, DsAgentState>{
            'export_activity': DsAgentState.retrieving,
          },
        ),
      );
      expect(_copy('Retrieving knowledge'), findsOneWidget);
    });

    testWidgets('a second attempt is stated, not hidden',
        (WidgetTester tester) async {
      await _pump(
        tester,
        const DsToolChip(
          turn: DsToolTurn(
            id: 't',
            name: 'fetch_market_price',
            params: <String, Object?>{},
            status: DsAgentTurnStatus.error,
            attempt: 2,
            ms: 8004,
          ),
        ),
      );
      expect(_copy('Fetch market price · attempt 2'), findsOneWidget);
      // `formatMs` — a second and over takes one decimal.
      expect(_copy('8.0s'), findsOneWidget);
    });

    testWidgets('the produced envelope never reaches the disclosure',
        (WidgetTester tester) async {
      await _pump(
        tester,
        const DsToolChip(
          turn: DsToolTurn(
            id: 't',
            name: 'export_activity',
            params: <String, Object?>{},
            status: DsAgentTurnStatus.ok,
            attempt: 1,
            result: <String, Object?>{
              'rows': 148,
              '__attachments': <Object?>[],
            },
          ),
        ),
      );
      await tester.tap(find.byType(DsButton));
      await tester.pump();
      expect(find.text('{\n  "rows": 148\n}'), findsOneWidget);
    });

    testWidgets('an action the user declined says so in the label',
        (WidgetTester tester) async {
      await _pump(
        tester,
        const DsActionChip(
          turn: DsActionTurn(
            id: 'a',
            action: 'navigate',
            params: <String, Object?>{'url': '/vault'},
            status: DsAgentTurnStatus.ok,
            approval: DsApprovalOutcome.rejected,
          ),
        ),
      );
      expect(_copy('Declined: Navigate · /vault'), findsOneWidget);
    });
  });

  group('approval card', () {
    const DsPendingApproval bare = DsPendingApproval(
      turnId: 'x',
      action: 'open_page',
      params: <String, Object?>{'url': '/vault'},
      approve: _nothing,
      reject: _nothingReject,
    );

    testWidgets('with no describe it builds a sentence out of the target',
        (WidgetTester tester) async {
      await _pump(tester, const DsApprovalCard(approval: bare));
      expect(
        _copy('The assistant wants to run "open_page" on /vault.'),
        findsOneWidget,
      );
    });

    testWidgets("describe wins, and the params are printed under it",
        (WidgetTester tester) async {
      await _pump(
        tester,
        DsApprovalCard(
          approval: bare,
          describe: (String action, Map<String, Object?> params) =>
              'This spends real money.',
        ),
      );
      expect(_copy('This spends real money.'), findsOneWidget);
      expect(find.text('{\n  "url": "/vault"\n}'), findsOneWidget);
    });

    test('Decline hands back the reason in as many words', () {
      expect(
        DsApprovalCard.declineReason,
        'The user declined this action.',
      );
    });
  });

  /* ── Attachments ───────────────────────────────────────────────────────── */

  group('attachments', () {
    const DsAgentAttachment csv = DsAgentAttachment(
      id: 'a',
      name: 'export.csv',
      mime: 'text/csv',
      kind: DsAgentAttachmentKind.data,
      size: 18422,
      delivery: DsAgentDelivery.content(),
    );
    const DsAgentAttachment pdf = DsAgentAttachment(
      id: 'b',
      name: 'report.pdf',
      mime: 'application/pdf',
      kind: DsAgentAttachmentKind.document,
      size: 2620000,
      delivery: DsAgentDelivery.reference('It is not text.'),
    );
    const DsAgentAttachment made = DsAgentAttachment(
      id: 'c',
      name: 'made.csv',
      mime: 'text/csv',
      kind: DsAgentAttachmentKind.data,
      size: 4821,
      delivery: DsAgentDelivery.produced(),
    );

    testWidgets('each delivery says exactly as much as it can',
        (WidgetTester tester) async {
      await _pump(
        tester,
        const DsAgentAttachmentList(
          attachments: <DsAgentAttachment>[csv, pdf, made],
        ),
      );
      expect(_copy('Read'), findsOneWidget);
      expect(_copy('Name only'), findsOneWidget);
      // `produced` says nothing at all: delivery does not apply to a file the
      // agent made itself.
      expect(find.byType(DsAgentAttachmentCard), findsNWidgets(3));
      expect(_copy('18 KB'), findsOneWidget);
      // `formatBytes` — one decimal, and 2_620_000 bytes is 2.5 MiB.
      expect(_copy('2.5 MB'), findsOneWidget);
    });

    testWidgets('an image with a url gets the large treatment, not a row',
        (WidgetTester tester) async {
      await _pump(
        tester,
        DsAgentAttachmentList(
          attachments: const <DsAgentAttachment>[
            DsAgentAttachment(
              id: 'i',
              name: 'shot.png',
              mime: 'image/png',
              kind: DsAgentAttachmentKind.image,
              size: 1024,
              url: 'blob:shot',
              delivery: DsAgentDelivery.content(),
            ),
            csv,
          ],
          imageBuilder: (BuildContext _, DsAgentAttachment _) =>
              const SizedBox(width: 640, height: 360),
        ),
      );
      // The picture is not a card; the spreadsheet is.
      expect(find.byType(DsAgentAttachmentCard), findsOneWidget);
      expect(_copy('shot.png'), findsOneWidget);
      // And it is openable, because it has a url.
      expect(find.byType(DsAttachmentTrigger), findsOneWidget);
    });

    testWidgets('an empty list draws nothing', (WidgetTester tester) async {
      await _pump(
        tester,
        const DsAgentAttachmentList(attachments: <DsAgentAttachment>[]),
      );
      expect(find.byType(DsAttachment), findsNothing);
    });
  });

  /* ── The wizard ────────────────────────────────────────────────────────── */

  group('questionnaire', () {
    Widget threeStep({VoidCallback? onSubmit}) => DsQuestionnaire(
          shortcuts: DsQuestionnaireShortcuts.letters,
          onSubmit: onSubmit,
          children: <Widget>[
            const DsQuestionnaireProgress(),
            const DsQuestionnaireItem(
              name: 'style',
              required: true,
              title: DsQuestionnaireTitle('How do you pick?'),
              children: <Widget>[
                DsQuestionnaireChoices(
                  children: <DsQuestionnaireChoice>[
                    DsQuestionnaireChoice(value: 'price', label: 'Cheapest'),
                    DsQuestionnaireChoice(value: 'odds', label: 'Best odds'),
                  ],
                ),
                DsQuestionnaireError(),
              ],
            ),
            const DsQuestionnaireItem(
              name: 'goal',
              title: DsQuestionnaireTitle('Chasing anything?'),
              children: <Widget>[DsQuestionnaireInput()],
            ),
            const DsQuestionnaireItem(
              name: 'budget',
              required: true,
              title: DsQuestionnaireTitle('Budget?'),
              children: <Widget>[DsQuestionnaireInput()],
            ),
            const DsQuestionnaireActions(
              children: <Widget>[
                DsQuestionnairePrevious(),
                DsQuestionnaireSkip(),
                DsQuestionnaireNext(),
                DsQuestionnaireSubmit(),
              ],
            ),
          ],
        );

    testWidgets('one item is on screen at a time, and it is the first',
        (WidgetTester tester) async {
      await _pump(tester, threeStep(), width: 1030);
      expect(_copy('Question 1 of 3'), findsOneWidget);
      expect(_copy('How do you pick?'), findsOneWidget);
      expect(_copy('Chasing anything?'), findsNothing);
      // Step one has nothing behind it and is required, so two controls hide.
      expect(find.text('Previous'), findsNothing);
      expect(find.text('Skip'), findsNothing);
      expect(find.text('Next'), findsOneWidget);
      expect(find.text('Submit'), findsNothing);
    });

    testWidgets('Next validates before it advances', (WidgetTester tester) async {
      await _pump(tester, threeStep(), width: 1030);
      await tester.tap(find.text('Next'));
      await tester.pump();
      // DRIFT: a bare `<QuestionnaireError />` under a required item supplies
      // the primitive's own string.
      expect(_copy(DsQuestionnaireError.requiredDefault), findsOneWidget);
      expect(_copy('Question 1 of 3'), findsOneWidget);

      await tester.tap(_copy('Best odds'));
      await tester.pump();
      expect(_copy(DsQuestionnaireError.requiredDefault), findsNothing);
      await tester.tap(find.text('Next'));
      await tester.pump();
      expect(_copy('Question 2 of 3'), findsOneWidget);
    });

    testWidgets('Skip appears only on an optional item, and moves on',
        (WidgetTester tester) async {
      await _pump(tester, threeStep(), width: 1030);
      await tester.tap(_copy('Cheapest'));
      await tester.pump();
      await tester.tap(find.text('Next'));
      await tester.pump();
      expect(find.text('Skip'), findsOneWidget);
      expect(find.text('Previous'), findsOneWidget);

      await tester.tap(find.text('Skip'));
      await tester.pump();
      expect(_copy('Question 3 of 3'), findsOneWidget);
      // The last step swaps Next for Submit, and Skip is gone again.
      expect(find.text('Next'), findsNothing);
      expect(find.text('Submit'), findsOneWidget);
      expect(find.text('Skip'), findsNothing);
    });

    testWidgets('Previous walks back without validating',
        (WidgetTester tester) async {
      await _pump(tester, threeStep(), width: 1030);
      await tester.tap(_copy('Cheapest'));
      await tester.pump();
      await tester.tap(find.text('Next'));
      await tester.pump();
      await tester.tap(find.text('Previous'));
      await tester.pump();
      expect(_copy('Question 1 of 3'), findsOneWidget);
    });

    testWidgets('Submit fires only once every required item answers',
        (WidgetTester tester) async {
      int submitted = 0;
      await _pump(
        tester,
        threeStep(onSubmit: () => submitted += 1),
        width: 1030,
      );
      await tester.tap(_copy('Cheapest'));
      await tester.pump();
      await tester.tap(find.text('Next'));
      await tester.pump();
      await tester.tap(find.text('Skip'));
      await tester.pump();

      await tester.tap(find.text('Submit'));
      await tester.pump();
      expect(submitted, 0);

      await tester.enterText(find.byType(DsQuestionnaireInput), '40');
      await tester.pump();
      await tester.tap(find.text('Submit'));
      await tester.pump();
      expect(submitted, 1);
    });

    testWidgets('the drawn key is the bound key', (WidgetTester tester) async {
      await _pump(tester, threeStep(), width: 1030);
      expect(
        find.byWidgetPredicate((Widget w) => w is DsKbd && w.text == 'A'),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate((Widget w) => w is DsKbd && w.text == 'B'),
        findsOneWidget,
      );

      // The handler is `onKeyDown` on the root form, so focus has to be inside
      // it first — which a click on a choice puts there.
      await tester.tap(_copy('Cheapest'));
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.keyB);
      await tester.pump();
      await tester.tap(find.text('Next'));
      await tester.pump();
      expect(_copy('Question 2 of 3'), findsOneWidget);
    });

    testWidgets('no shortcuts means no badge', (WidgetTester tester) async {
      await _pump(
        tester,
        const DsQuestionnaire(
          children: <Widget>[
            DsQuestionnaireItem(
              name: 'demo',
              children: <Widget>[
                DsQuestionnaireChoices(
                  children: <DsQuestionnaireChoice>[
                    DsQuestionnaireChoice(value: 'a', label: 'Option A'),
                  ],
                ),
              ],
            ),
          ],
        ),
        width: 320,
      );
      expect(find.byType(DsKbd), findsNothing);
    });

    testWidgets('an optional item gets the other default error string',
        (WidgetTester tester) async {
      await _pump(
        tester,
        const DsQuestionnaire(
          children: <Widget>[
            DsQuestionnaireItem(
              name: 'demo',
              invalid: true,
              children: <Widget>[DsQuestionnaireError()],
            ),
          ],
        ),
        width: 320,
      );
      expect(_copy(DsQuestionnaireError.optionalDefault), findsOneWidget);
      expect(
        DsQuestionnaireError.optionalDefault,
        'Choose an answer or skip this question.',
      );
    });

    testWidgets('defaultChecked seeds the answer on mount',
        (WidgetTester tester) async {
      await _pump(
        tester,
        const DsQuestionnaire(
          children: <Widget>[
            DsQuestionnaireItem(
              name: 'demo',
              children: <Widget>[
                DsQuestionnaireChoices(
                  children: <DsQuestionnaireChoice>[
                    DsQuestionnaireChoice(
                      value: 'a',
                      label: 'Option A',
                      defaultChecked: true,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        width: 320,
      );
      await tester.pump();
      // The checked control carries the primary fill; the unchecked one does
      // not, and that is the only difference the specimen exists to show.
      final DsThemeData theme =
          DsTheme.of(tester.element(find.byType(DsQuestionnaireChoice)));
      final Iterable<DecoratedBox> boxes = tester
          .widgetList<DecoratedBox>(find.byType(DecoratedBox))
          .where((DecoratedBox b) =>
              (b.decoration as BoxDecoration).shape == BoxShape.circle);
      expect(
        boxes.any((DecoratedBox b) =>
            (b.decoration as BoxDecoration).color == theme.primary),
        isTrue,
      );
    });
  });

  /* ── The welcome card's chips ──────────────────────────────────────────── */

  group('welcome card', () {
    testWidgets(
        'GAP CLOSED: a capability chip takes hover:border-agent/50 beside '
        'hover:text-foreground', (WidgetTester tester) async {
      // The chip writes both utilities and only the second one used to land:
      // [DsButtonSurface] had no `hoverBorder`, so the label brightened while
      // the rim stayed the outline variant's own — a half-painted hover, and
      // the visible kind. The primitive grew the fifth override (the agent
      // launcher wanted the same one) and this is both halves arriving.
      await _pump(
        tester,
        DsWelcomeCard(
          name: 'Vault',
          capabilities: const <DsAgentCapability>[
            DsAgentCapability(
              id: 'inventory',
              label: 'inventory',
              hint: 'Look up what you hold',
            ),
          ],
          onPick: (String _) {},
        ),
      );

      final Finder chip = find.ancestor(
        of: _copy('inventory'),
        matching: find.byType(DsButton),
      );
      Color rimOf() => (tester
              .widget<DsMachineSurface>(
                find.descendant(of: chip, matching: find.byType(DsMachineSurface)),
              )
              .border! as Border)
          .top
          .color;
      /// The button's ambient ink — what `hover:text-foreground` moves, and
      /// what the glyph beside the label reads. The label span carries a colour
      /// of its own (`text-muted-foreground`) and is deliberately not it.
      Color inkOf() => tester
          .widget<DefaultTextStyle>(
            find
                .descendant(of: chip, matching: find.byType(DefaultTextStyle))
                .first,
          )
          .style
          .color!;

      final DsThemeData light = DsThemeData.light;
      final Color rim = light.agent.withValues(
        alpha: DsWelcomeCard.capabilityHoverRimAlpha,
      );
      // The bite: the hover rim may not equal the rim it replaces, or the
      // assertion below would pass with the override deleted.
      expect(rim, isNot(light.input));

      expect(rimOf(), light.input);
      expect(inkOf(), light.foreground);

      final TestGesture mouse =
          await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(mouse.removePointer);
      await mouse.addPointer(location: Offset.zero);
      await mouse.moveTo(tester.getCenter(chip));
      await tester.pump();

      // `hover:border-agent/50` — the half that was missing.
      expect(rimOf(), rim);
      // …and `hover:text-foreground`, the half that always landed. On the
      // outline variant the resting ink is already `--foreground`, so this one
      // asserts continuity rather than change: the fifth override must not have
      // disturbed the four that were already there.
      expect(inkOf(), light.foreground);
    });
  });
}

void _nothing() {}
void _nothingReject([String? reason]) {}
