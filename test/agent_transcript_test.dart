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

Future<void> _pump(
  WidgetTester tester,
  Widget child, {
  double width = 600,
}) async {
  final ElThemeController theme = ElThemeController(mode: ElThemeMode.light);
  addTearDown(theme.dispose);

  await tester.pumpWidget(
    ElTheme(
      controller: theme,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Builder(
          builder: (BuildContext context) => MediaQuery(
            data: MediaQuery.of(context).copyWith(disableAnimations: true),
            child: DefaultTextStyle(
              style: ElText.styleOf(
                context,
                ElType.body,
                color: ElTheme.of(context).foreground,
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
  (Widget widget) => widget is ElText && widget.text == text,
);

void main() {
  /* ── The parser ────────────────────────────────────────────────────────── */

  group('markdown parser', () {
    test('a blank line closes whatever is open', () {
      final List<ElMarkdownBlock> blocks = elParseMarkdown('one\ntwo\n\nthree');
      expect(blocks, hasLength(2));
      // Adjacent non-empty lines join into one paragraph.
      expect((blocks[0] as ElMarkdownParagraph).lines, <String>['one', 'two']);
      expect((blocks[1] as ElMarkdownParagraph).lines, <String>['three']);
    });

    test('headings one through four are parsed and five is not', () {
      expect(
        (elParseMarkdown('#### four').single as ElMarkdownHeading).level,
        4,
      );
      // `#####` falls back to paragraph text — one of the nine documented
      // limits.
      expect(elParseMarkdown('##### five').single, isA<ElMarkdownParagraph>());
    });

    test('dash, asterisk and bullet all open one unordered list', () {
      final ElMarkdownBullets list =
          elParseMarkdown('- a\n* b\n• c').single as ElMarkdownBullets;
      expect(list.items, <String>['a', 'b', 'c']);
    });

    test('a plain line under an item continues that item', () {
      final ElMarkdownBullets list =
          elParseMarkdown('- a finding\nwrapped on').single
              as ElMarkdownBullets;
      expect(list.items, <String>['a finding wrapped on']);
    });

    test("an ordered list keeps the author's own numbers", () {
      final ElMarkdownNumbers list =
          elParseMarkdown('4. one\n5) two\n7. three').single
              as ElMarkdownNumbers;
      expect(list.items.map((ElMarkdownOrderedItem i) => i.n), <int>[4, 5, 7]);
      expect(list.items.last.text, 'three');
    });

    test('consecutive quote lines join into one blockquote', () {
      final ElMarkdownQuote quote =
          elParseMarkdown('> one\n> two').single as ElMarkdownQuote;
      expect(quote.lines, <String>['one', 'two']);
    });

    test('an unterminated fence runs to the end rather than being dropped', () {
      final ElMarkdownFence fence =
          elParseMarkdown('```ts\nconst a = 1;\nconst b = 2;').single
              as ElMarkdownFence;
      expect(fence.lang, 'ts');
      expect(fence.lines, <String>['const a = 1;', 'const b = 2;']);
    });

    test('a fence is never scanned for other syntax', () {
      final ElMarkdownFence fence =
          elParseMarkdown('```\n# not a heading\n- not a bullet\n```').single
              as ElMarkdownFence;
      expect(fence.lines, <String>['# not a heading', '- not a bullet']);
    });

    test('a pipe without a delimiter row is a sentence, not a table', () {
      expect(
        elParseMarkdown('a | b is just prose').single,
        isA<ElMarkdownParagraph>(),
      );
    });

    test(
      'the delimiter row sets alignment and escaped pipes stay in cells',
      () {
        final ElMarkdownTable table =
            elParseMarkdown(
                  '| Pack | Left | Last |\n|:---|---:|:---:|\n'
                  r'| Aurora \| Prism | 61 | $84.50 |',
                ).single
                as ElMarkdownTable;
        expect(table.head, <String>['Pack', 'Left', 'Last']);
        expect(table.align, <ElMarkdownAlign>[
          ElMarkdownAlign.left,
          ElMarkdownAlign.right,
          ElMarkdownAlign.center,
        ]);
        expect(table.rows.single.first, 'Aurora | Prism');
      },
    );

    test('a ragged streaming row is padded to the header width', () {
      final ElMarkdownTable table =
          elParseMarkdown('| a | b | c |\n|---|---|---|\n| 1 |').single
              as ElMarkdownTable;
      expect(table.rows.single, <String>['1', '', '']);
    });

    test('empty source renders nothing at all', () {
      expect(elParseMarkdown(''), isEmpty);
    });
  });

  group('safeHref', () {
    test('root-relative paths and fragments pass through untouched', () {
      expect(elSafeHref('/design-system'), '/design-system');
      expect(elSafeHref('#markdown'), '#markdown');
    });

    test('http and https survive, every other scheme is refused', () {
      expect(elSafeHref('https://example.com/docs'), isNotNull);
      expect(elSafeHref('http://example.com'), isNotNull);
      // `javascript:` is the reason this function exists.
      expect(elSafeHref('javascript:alert(1)'), isNull);
      expect(elSafeHref('data:text/html,<script>'), isNull);
      expect(elSafeHref('mailto:a@b.c'), isNull);
      expect(elSafeHref('not a url'), isNull);
    });
  });

  group('code block', () {
    test('LANGUAGE_ALIASES normalises, and an unknown fence stays plain', () {
      expect(ElAgentCodeBlock.normalise('ts'), 'typescript');
      expect(ElAgentCodeBlock.normalise('TSX'), 'tsx');
      expect(ElAgentCodeBlock.normalise('sh'), 'bash');
      expect(ElAgentCodeBlock.normalise('md'), 'markdown');
      expect(ElAgentCodeBlock.normalise('rust'), isNull);
      expect(ElAgentCodeBlock.normalise(''), isNull);
      expect(ElAgentCodeBlock.normalise(null), isNull);
    });

    test('the tokeniser colours the five classes the palette paints', () {
      final List<ElCodeToken> line = elTokenise(
        'const odds = pulls.filter((p) => p.rarity === "grail").length;',
        'typescript',
      ).single;
      Color colourOf(String text) =>
          line.firstWhere((ElCodeToken t) => t.text == text).color;

      expect(colourOf('const'), ElPrismPalette.keyword);
      expect(colourOf('filter'), ElPrismPalette.function);
      expect(colourOf('"grail"'), ElPrismPalette.string);
      expect(colourOf('odds'), ElPrismPalette.plain);
    });

    test('a comment runs to the end of its line', () {
      final List<ElCodeToken> line = elTokenise(
        'const a = 1; // and the rest',
        'typescript',
      ).single;
      expect(line.last.color, ElPrismPalette.comment);
      expect(line.last.text, '// and the rest');
    });

    test('python and bash take their own comment marker', () {
      expect(
        elTokenise('# a note', 'python').single.single.color,
        ElPrismPalette.comment,
      );
      expect(
        elTokenise('# a note', 'bash').single.single.color,
        ElPrismPalette.comment,
      );
    });
  });

  /* ── Rendering ─────────────────────────────────────────────────────────── */

  group('markdown rendering', () {
    testWidgets('a fence names its normalised language over the body', (
      WidgetTester tester,
    ) async {
      await _pump(
        tester,
        const ElAgentMarkdown(text: '```ts\nconst a = 1;\n```'),
      );
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

    testWidgets('an unknown language gets no header strip at all', (
      WidgetTester tester,
    ) async {
      await _pump(
        tester,
        const ElAgentMarkdown(text: '```rust\nlet a = 1;\n```'),
      );
      expect(_copy('rust'), findsNothing);
      expect(find.byType(ElPreformattedCode), findsOneWidget);
    });

    testWidgets('a bare URL keeps the sentence full stop it swallowed', (
      WidgetTester tester,
    ) async {
      // DRIFT, reproduced: `[^\s<>()]+` does not exclude `.`, so the label the
      // reference measures is 149.22px of `https://example.com.` — period
      // included.
      await _pump(
        tester,
        const ElAgentMarkdown(text: 'Visit https://example.com.'),
      );
      final RichText paragraph = tester.widget<RichText>(
        find.byType(RichText).first,
      );
      expect(paragraph.text.toPlainText(), 'Visit https://example.com.');
    });

    testWidgets('an ordered list draws the authored numbers', (
      WidgetTester tester,
    ) async {
      await _pump(
        tester,
        const ElAgentMarkdown(text: '4. one\n5) two\n7. three'),
      );
      for (final String marker in <String>['4.', '5.', '7.']) {
        expect(find.text(marker), findsOneWidget, reason: marker);
      }
    });

    testWidgets('a table is a Table, and a lone pipe is not', (
      WidgetTester tester,
    ) async {
      await _pump(
        tester,
        const ElAgentMarkdown(text: '| a | b |\n|---|---|\n| 1 | 2 |'),
      );
      expect(find.byType(Table), findsOneWidget);

      await _pump(tester, const ElAgentMarkdown(text: 'a | b'));
      expect(find.byType(Table), findsNothing);
    });
  });

  /* ── Turns ─────────────────────────────────────────────────────────────── */

  group('turns', () {
    testWidgets('the user bubble is capped at 85% and squares one corner', (
      WidgetTester tester,
    ) async {
      await _pump(
        tester,
        const ElUserMessage(
          turn: ElUserTurn(id: 'u', text: 'What sealed boxes are left?'),
        ),
      );
      final Container bubble = tester.widget<Container>(
        find.byType(Container).first,
      );
      final BoxDecoration decoration = bubble.decoration! as BoxDecoration;
      expect(
        decoration.borderRadius,
        BorderRadius.only(
          topLeft: const Radius.circular(ElRadii.xl),
          topRight: const Radius.circular(ElRadii.xl),
          bottomRight: const Radius.circular(ElRadii.sm),
          bottomLeft: const Radius.circular(ElRadii.xl),
        ),
      );
      expect(
        tester.getSize(find.byType(Container).first).width,
        lessThanOrEqualTo(600 * ElUserMessage.maxWidthFraction + 0.01),
      );
    });

    testWidgets('the agent turn strips a half-arrived protocol tag', (
      WidgetTester tester,
    ) async {
      await _pump(
        tester,
        const ElAgentMessage(
          turn: ElTextTurn(id: 'a', text: 'Done.<complete> and <comp'),
        ),
      );
      final RichText paragraph = tester.widget<RichText>(
        find.byType(RichText).first,
      );
      // `stripProtocol` leaves a trailing space and the paragraph builder
      // trims it, exactly as the reference's `lines.join(" ")` does.
      expect(paragraph.text.toPlainText(), 'Done. and');
    });

    testWidgets('the caret is drawn only on a streaming turn', (
      WidgetTester tester,
    ) async {
      await _pump(
        tester,
        const ElAgentMessage(
          turn: ElTextTurn(id: 'a', text: 'Checking'),
        ),
      );
      expect(find.byType(ElTypingCursor), findsNothing);

      await _pump(
        tester,
        const ElAgentMessage(
          turn: ElTextTurn(id: 'a', text: 'Checking', streaming: true),
        ),
      );
      expect(find.byType(ElTypingCursor), findsOneWidget);
    });

    testWidgets('an empty turn with no attachments renders nothing', (
      WidgetTester tester,
    ) async {
      await _pump(
        tester,
        const ElAgentMessage(
          turn: ElTextTurn(id: 'a', text: '   '),
        ),
      );
      expect(find.byType(ElAgentMarkdown), findsNothing);
    });
  });

  /* ── Chips ─────────────────────────────────────────────────────────────── */

  group('tool chip', () {
    const ElToolTurn unmapped = ElToolTurn(
      id: 't',
      name: 'export_activity',
      params: <String, Object?>{'window': '30d'},
      status: ElAgentTurnStatus.ok,
      attempt: 1,
    );

    testWidgets('an unmapped tool falls back to its own humanised name', (
      WidgetTester tester,
    ) async {
      await _pump(tester, const ElToolChip(turn: unmapped));
      // The name is the most honest thing available — never "used a tool".
      expect(_copy('Export activity'), findsOneWidget);
    });

    testWidgets('a mapped tool takes AGENT_STATE_LABEL verbatim', (
      WidgetTester tester,
    ) async {
      await _pump(
        tester,
        const ElToolChip(
          turn: unmapped,
          toolStates: <String, ElAgentState>{
            'export_activity': ElAgentState.retrieving,
          },
        ),
      );
      expect(_copy('Retrieving knowledge'), findsOneWidget);
    });

    testWidgets('a second attempt is stated, not hidden', (
      WidgetTester tester,
    ) async {
      await _pump(
        tester,
        const ElToolChip(
          turn: ElToolTurn(
            id: 't',
            name: 'fetch_market_price',
            params: <String, Object?>{},
            status: ElAgentTurnStatus.error,
            attempt: 2,
            ms: 8004,
          ),
        ),
      );
      expect(_copy('Fetch market price · attempt 2'), findsOneWidget);
      // `formatMs` — a second and over takes one decimal.
      expect(_copy('8.0s'), findsOneWidget);
    });

    testWidgets('the produced envelope never reaches the disclosure', (
      WidgetTester tester,
    ) async {
      await _pump(
        tester,
        const ElToolChip(
          turn: ElToolTurn(
            id: 't',
            name: 'export_activity',
            params: <String, Object?>{},
            status: ElAgentTurnStatus.ok,
            attempt: 1,
            result: <String, Object?>{
              'rows': 148,
              '__attachments': <Object?>[],
            },
          ),
        ),
      );
      await tester.tap(find.byType(ElButton));
      await tester.pump();
      expect(find.text('{\n  "rows": 148\n}'), findsOneWidget);
    });

    testWidgets('an action the user declined says so in the label', (
      WidgetTester tester,
    ) async {
      await _pump(
        tester,
        const ElActionChip(
          turn: ElActionTurn(
            id: 'a',
            action: 'navigate',
            params: <String, Object?>{'url': '/vault'},
            status: ElAgentTurnStatus.ok,
            approval: ElApprovalOutcome.rejected,
          ),
        ),
      );
      expect(_copy('Declined: Navigate · /vault'), findsOneWidget);
    });
  });

  group('approval card', () {
    const ElPendingApproval bare = ElPendingApproval(
      turnId: 'x',
      action: 'open_page',
      params: <String, Object?>{'url': '/vault'},
      approve: _nothing,
      reject: _nothingReject,
    );

    testWidgets('with no describe it builds a sentence out of the target', (
      WidgetTester tester,
    ) async {
      await _pump(tester, const ElApprovalCard(approval: bare));
      expect(
        _copy('The assistant wants to run "open_page" on /vault.'),
        findsOneWidget,
      );
    });

    testWidgets("describe wins, and the params are printed under it", (
      WidgetTester tester,
    ) async {
      await _pump(
        tester,
        ElApprovalCard(
          approval: bare,
          describe: (String action, Map<String, Object?> params) =>
              'This spends real money.',
        ),
      );
      expect(_copy('This spends real money.'), findsOneWidget);
      expect(find.text('{\n  "url": "/vault"\n}'), findsOneWidget);
    });

    test('Decline hands back the reason in as many words', () {
      expect(ElApprovalCard.declineReason, 'The user declined this action.');
    });
  });

  /* ── Attachments ───────────────────────────────────────────────────────── */

  group('attachments', () {
    const ElAgentAttachment csv = ElAgentAttachment(
      id: 'a',
      name: 'export.csv',
      mime: 'text/csv',
      kind: ElAgentAttachmentKind.data,
      size: 18422,
      delivery: ElAgentDelivery.content(),
    );
    const ElAgentAttachment pdf = ElAgentAttachment(
      id: 'b',
      name: 'report.pdf',
      mime: 'application/pdf',
      kind: ElAgentAttachmentKind.document,
      size: 2620000,
      delivery: ElAgentDelivery.reference('It is not text.'),
    );
    const ElAgentAttachment made = ElAgentAttachment(
      id: 'c',
      name: 'made.csv',
      mime: 'text/csv',
      kind: ElAgentAttachmentKind.data,
      size: 4821,
      delivery: ElAgentDelivery.produced(),
    );

    testWidgets('each delivery says exactly as much as it can', (
      WidgetTester tester,
    ) async {
      await _pump(
        tester,
        const ElAgentAttachmentList(
          attachments: <ElAgentAttachment>[csv, pdf, made],
        ),
      );
      expect(_copy('Read'), findsOneWidget);
      expect(_copy('Name only'), findsOneWidget);
      // `produced` says nothing at all: delivery does not apply to a file the
      // agent made itself.
      expect(find.byType(ElAgentAttachmentCard), findsNWidgets(3));
      expect(_copy('18 KB'), findsOneWidget);
      // `formatBytes` — one decimal, and 2_620_000 bytes is 2.5 MiB.
      expect(_copy('2.5 MB'), findsOneWidget);
    });

    testWidgets('an image with a url gets the large treatment, not a row', (
      WidgetTester tester,
    ) async {
      await _pump(
        tester,
        ElAgentAttachmentList(
          attachments: const <ElAgentAttachment>[
            ElAgentAttachment(
              id: 'i',
              name: 'shot.png',
              mime: 'image/png',
              kind: ElAgentAttachmentKind.image,
              size: 1024,
              url: 'blob:shot',
              delivery: ElAgentDelivery.content(),
            ),
            csv,
          ],
          imageBuilder: (BuildContext _, ElAgentAttachment _) =>
              const SizedBox(width: 640, height: 360),
        ),
      );
      // The picture is not a card; the spreadsheet is.
      expect(find.byType(ElAgentAttachmentCard), findsOneWidget);
      expect(_copy('shot.png'), findsOneWidget);
      // And it is openable, because it has a url.
      expect(find.byType(ElAttachmentTrigger), findsOneWidget);
    });

    testWidgets('an empty list draws nothing', (WidgetTester tester) async {
      await _pump(
        tester,
        const ElAgentAttachmentList(attachments: <ElAgentAttachment>[]),
      );
      expect(find.byType(ElAttachment), findsNothing);
    });
  });

  /* ── The wizard ────────────────────────────────────────────────────────── */

  group('questionnaire', () {
    Widget threeStep({VoidCallback? onSubmit}) => ElQuestionnaire(
      shortcuts: ElQuestionnaireShortcuts.letters,
      onSubmit: onSubmit,
      children: <Widget>[
        const ElQuestionnaireProgress(),
        const ElQuestionnaireItem(
          name: 'style',
          required: true,
          title: ElQuestionnaireTitle('How do you pick?'),
          children: <Widget>[
            ElQuestionnaireChoices(
              children: <ElQuestionnaireChoice>[
                ElQuestionnaireChoice(value: 'price', label: 'Cheapest'),
                ElQuestionnaireChoice(value: 'odds', label: 'Best odds'),
              ],
            ),
            ElQuestionnaireError(),
          ],
        ),
        const ElQuestionnaireItem(
          name: 'goal',
          title: ElQuestionnaireTitle('Chasing anything?'),
          children: <Widget>[ElQuestionnaireInput()],
        ),
        const ElQuestionnaireItem(
          name: 'budget',
          required: true,
          title: ElQuestionnaireTitle('Budget?'),
          children: <Widget>[ElQuestionnaireInput()],
        ),
        const ElQuestionnaireActions(
          children: <Widget>[
            ElQuestionnairePrevious(),
            ElQuestionnaireSkip(),
            ElQuestionnaireNext(),
            ElQuestionnaireSubmit(),
          ],
        ),
      ],
    );

    testWidgets('one item is on screen at a time, and it is the first', (
      WidgetTester tester,
    ) async {
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

    testWidgets('Next validates before it advances', (
      WidgetTester tester,
    ) async {
      await _pump(tester, threeStep(), width: 1030);
      await tester.tap(find.text('Next'));
      await tester.pump();
      // DRIFT: a bare `<QuestionnaireError />` under a required item supplies
      // the primitive's own string.
      expect(_copy(ElQuestionnaireError.requiredDefault), findsOneWidget);
      expect(_copy('Question 1 of 3'), findsOneWidget);

      await tester.tap(_copy('Best odds'));
      await tester.pump();
      expect(_copy(ElQuestionnaireError.requiredDefault), findsNothing);
      await tester.tap(find.text('Next'));
      await tester.pump();
      expect(_copy('Question 2 of 3'), findsOneWidget);
    });

    testWidgets('Skip appears only on an optional item, and moves on', (
      WidgetTester tester,
    ) async {
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

    testWidgets('Previous walks back without validating', (
      WidgetTester tester,
    ) async {
      await _pump(tester, threeStep(), width: 1030);
      await tester.tap(_copy('Cheapest'));
      await tester.pump();
      await tester.tap(find.text('Next'));
      await tester.pump();
      await tester.tap(find.text('Previous'));
      await tester.pump();
      expect(_copy('Question 1 of 3'), findsOneWidget);
    });

    testWidgets('Submit fires only once every required item answers', (
      WidgetTester tester,
    ) async {
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

      await tester.enterText(find.byType(ElQuestionnaireInput), '40');
      await tester.pump();
      await tester.tap(find.text('Submit'));
      await tester.pump();
      expect(submitted, 1);
    });

    testWidgets('the drawn key is the bound key', (WidgetTester tester) async {
      await _pump(tester, threeStep(), width: 1030);
      expect(
        find.byWidgetPredicate((Widget w) => w is ElKbd && w.text == 'A'),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate((Widget w) => w is ElKbd && w.text == 'B'),
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
        const ElQuestionnaire(
          children: <Widget>[
            ElQuestionnaireItem(
              name: 'demo',
              children: <Widget>[
                ElQuestionnaireChoices(
                  children: <ElQuestionnaireChoice>[
                    ElQuestionnaireChoice(value: 'a', label: 'Option A'),
                  ],
                ),
              ],
            ),
          ],
        ),
        width: 320,
      );
      expect(find.byType(ElKbd), findsNothing);
    });

    testWidgets('an optional item gets the other default error string', (
      WidgetTester tester,
    ) async {
      await _pump(
        tester,
        const ElQuestionnaire(
          children: <Widget>[
            ElQuestionnaireItem(
              name: 'demo',
              invalid: true,
              children: <Widget>[ElQuestionnaireError()],
            ),
          ],
        ),
        width: 320,
      );
      expect(_copy(ElQuestionnaireError.optionalDefault), findsOneWidget);
      expect(
        ElQuestionnaireError.optionalDefault,
        'Choose an answer or skip this question.',
      );
    });

    testWidgets('defaultChecked seeds the answer on mount', (
      WidgetTester tester,
    ) async {
      await _pump(
        tester,
        const ElQuestionnaire(
          children: <Widget>[
            ElQuestionnaireItem(
              name: 'demo',
              children: <Widget>[
                ElQuestionnaireChoices(
                  children: <ElQuestionnaireChoice>[
                    ElQuestionnaireChoice(
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
      final ElThemeData theme = ElTheme.of(
        tester.element(find.byType(ElQuestionnaireChoice)),
      );
      final Iterable<DecoratedBox> boxes = tester
          .widgetList<DecoratedBox>(find.byType(DecoratedBox))
          .where(
            (DecoratedBox b) =>
                (b.decoration as BoxDecoration).shape == BoxShape.circle,
          );
      expect(
        boxes.any(
          (DecoratedBox b) =>
              (b.decoration as BoxDecoration).color == theme.primary,
        ),
        isTrue,
      );
    });
  });

  /* ── The welcome card's chips ──────────────────────────────────────────── */

  group('welcome card', () {
    testWidgets('GAP CLOSED: a capability chip takes hover:border-agent/50 beside '
        'hover:text-foreground', (WidgetTester tester) async {
      // The chip writes both utilities and only the second one used to land:
      // [ElButtonSurface] had no `hoverBorder`, so the label brightened while
      // the rim stayed the outline variant's own — a half-painted hover, and
      // the visible kind. The primitive grew the fifth override (the agent
      // launcher wanted the same one) and this is both halves arriving.
      await _pump(
        tester,
        ElWelcomeCard(
          name: 'Vault',
          capabilities: const <ElAgentCapability>[
            ElAgentCapability(
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
        matching: find.byType(ElButton),
      );
      Color rimOf() =>
          (tester
                      .widget<ElMachineSurface>(
                        find.descendant(
                          of: chip,
                          matching: find.byType(ElMachineSurface),
                        ),
                      )
                      .border!
                  as Border)
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

      final ElThemeData light = ElThemeData.light;
      final Color rim = light.agent.withValues(
        alpha: ElWelcomeCard.capabilityHoverRimAlpha,
      );
      // The bite: the hover rim may not equal the rim it replaces, or the
      // assertion below would pass with the override deleted.
      expect(rim, isNot(light.input));

      expect(rimOf(), light.input);
      expect(inkOf(), light.foreground);

      final TestGesture mouse = await tester.createGesture(
        kind: PointerDeviceKind.mouse,
      );
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
