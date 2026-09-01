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
import 'package:flutter/material.dart'
    hide
        AspectRatio,
        Form,
        FormField,
        Icon,
        OverlayPortal,
        RadioGroup,
        RichText,
        SafeArea,
        ScrollPosition,
        Table,
        TableColumnWidth,
        ActionChip,
        AlertDialog,
        Badge,
        Card,
        CarouselController,
        Checkbox,
        Dialog,
        DropdownMenu,
        Drawer,
        DrawerHeader,
        Slider,
        Switch,
        TextFormField,
        Tooltip;
import 'package:flutter/widgets.dart' as flutter show RichText, Table;
import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter_test/flutter_test.dart';

/* ── Harness ─────────────────────────────────────────────────────────────── */

Future<void> _pump(
  WidgetTester tester,
  Widget child, {
  double width = 600,
}) async {
  final ThemeController theme = ThemeController(mode: ColorMode.light);
  addTearDown(theme.dispose);

  await tester.pumpWidget(
    ThemeScope(
      controller: theme,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Builder(
          builder: (BuildContext context) => MediaQuery(
            data: MediaQuery.of(context).copyWith(disableAnimations: true),
            child: DefaultTextStyle(
              style: StyledText.styleOf(
                context,
                TextStyles.body,
                color: ThemeScope.of(context).foreground,
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
  (Widget widget) => widget is StyledText && widget.text == text,
);

void main() {
  /* ── The parser ────────────────────────────────────────────────────────── */

  group('markdown parser', () {
    test('a blank line closes whatever is open', () {
      final List<MarkdownBlock> blocks = parseMarkdown('one\ntwo\n\nthree');
      expect(blocks, hasLength(2));
      // Adjacent non-empty lines join into one paragraph.
      expect((blocks[0] as MarkdownParagraph).lines, <String>['one', 'two']);
      expect((blocks[1] as MarkdownParagraph).lines, <String>['three']);
    });

    test('headings one through four are parsed and five is not', () {
      expect((parseMarkdown('#### four').single as MarkdownHeading).level, 4);
      // `#####` falls back to paragraph text — one of the nine documented
      // limits.
      expect(parseMarkdown('##### five').single, isA<MarkdownParagraph>());
    });

    test('dash, asterisk and bullet all open one unordered list', () {
      final MarkdownBullets list =
          parseMarkdown('- a\n* b\n• c').single as MarkdownBullets;
      expect(list.items, <String>['a', 'b', 'c']);
    });

    test('a plain line under an item continues that item', () {
      final MarkdownBullets list =
          parseMarkdown('- a finding\nwrapped on').single as MarkdownBullets;
      expect(list.items, <String>['a finding wrapped on']);
    });

    test("an ordered list keeps the author's own numbers", () {
      final MarkdownNumbers list =
          parseMarkdown('4. one\n5) two\n7. three').single as MarkdownNumbers;
      expect(list.items.map((MarkdownOrderedItem i) => i.n), <int>[4, 5, 7]);
      expect(list.items.last.text, 'three');
    });

    test('consecutive quote lines join into one blockquote', () {
      final MarkdownQuote quote =
          parseMarkdown('> one\n> two').single as MarkdownQuote;
      expect(quote.lines, <String>['one', 'two']);
    });

    test('an unterminated fence runs to the end rather than being dropped', () {
      final MarkdownFence fence =
          parseMarkdown('```ts\nconst a = 1;\nconst b = 2;').single
              as MarkdownFence;
      expect(fence.lang, 'ts');
      expect(fence.lines, <String>['const a = 1;', 'const b = 2;']);
    });

    test('a fence is never scanned for other syntax', () {
      final MarkdownFence fence =
          parseMarkdown('```\n# not a heading\n- not a bullet\n```').single
              as MarkdownFence;
      expect(fence.lines, <String>['# not a heading', '- not a bullet']);
    });

    test('a pipe without a delimiter row is a sentence, not a table', () {
      expect(
        parseMarkdown('a | b is just prose').single,
        isA<MarkdownParagraph>(),
      );
    });

    test(
      'the delimiter row sets alignment and escaped pipes stay in cells',
      () {
        final MarkdownTable table =
            parseMarkdown(
                  '| Pack | Left | Last |\n|:---|---:|:---:|\n'
                  r'| Aurora \| Prism | 61 | $84.50 |',
                ).single
                as MarkdownTable;
        expect(table.head, <String>['Pack', 'Left', 'Last']);
        expect(table.align, <MarkdownAlign>[
          MarkdownAlign.left,
          MarkdownAlign.right,
          MarkdownAlign.center,
        ]);
        expect(table.rows.single.first, 'Aurora | Prism');
      },
    );

    test('a ragged streaming row is padded to the header width', () {
      final MarkdownTable table =
          parseMarkdown('| a | b | c |\n|---|---|---|\n| 1 |').single
              as MarkdownTable;
      expect(table.rows.single, <String>['1', '', '']);
    });

    test('empty source renders nothing at all', () {
      expect(parseMarkdown(''), isEmpty);
    });
  });

  group('safeHref', () {
    test('root-relative paths and fragments pass through untouched', () {
      expect(safeHref('/design-system'), '/design-system');
      expect(safeHref('#markdown'), '#markdown');
    });

    test('http and https survive, every other scheme is refused', () {
      expect(safeHref('https://example.com/docs'), isNotNull);
      expect(safeHref('http://example.com'), isNotNull);
      // `javascript:` is the reason this function exists.
      expect(safeHref('javascript:alert(1)'), isNull);
      expect(safeHref('data:text/html,<script>'), isNull);
      expect(safeHref('mailto:a@b.c'), isNull);
      expect(safeHref('not a url'), isNull);
    });
  });

  group('code block', () {
    test('LANGUAGE_ALIASES normalises, and an unknown fence stays plain', () {
      expect(AgentCodeBlock.normalise('ts'), 'typescript');
      expect(AgentCodeBlock.normalise('TSX'), 'tsx');
      expect(AgentCodeBlock.normalise('sh'), 'bash');
      expect(AgentCodeBlock.normalise('md'), 'markdown');
      expect(AgentCodeBlock.normalise('rust'), isNull);
      expect(AgentCodeBlock.normalise(''), isNull);
      expect(AgentCodeBlock.normalise(null), isNull);
    });

    test('the tokeniser colours the five classes the palette paints', () {
      final List<CodeToken> line = tokenise(
        'const odds = pulls.filter((p) => p.rarity === "grail").length;',
        'typescript',
      ).single;
      Color colourOf(String text) =>
          line.firstWhere((CodeToken t) => t.text == text).color;

      expect(colourOf('const'), PrismPalette.keyword);
      expect(colourOf('filter'), PrismPalette.function);
      expect(colourOf('"grail"'), PrismPalette.string);
      expect(colourOf('odds'), PrismPalette.plain);
    });

    test('a comment runs to the end of its line', () {
      final List<CodeToken> line = tokenise(
        'const a = 1; // and the rest',
        'typescript',
      ).single;
      expect(line.last.color, PrismPalette.comment);
      expect(line.last.text, '// and the rest');
    });

    test('python and bash take their own comment marker', () {
      expect(
        tokenise('# a note', 'python').single.single.color,
        PrismPalette.comment,
      );
      expect(
        tokenise('# a note', 'bash').single.single.color,
        PrismPalette.comment,
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
        const AgentMarkdown(text: '```ts\nconst a = 1;\n```'),
      );
      // The strip sets the name in caps and keeps the authored name as its
      // accessible label.
      expect(_copy('TYPESCRIPT'), findsOneWidget);
      expect(find.bySemanticsLabel('typescript'), findsOneWidget);
      // The body is a span tree, one span per Prism token, so it is read back
      // off the paragraph rather than found as a `Text`.
      expect(
        tester
            .widgetList<flutter.RichText>(find.byType(flutter.RichText))
            .map((flutter.RichText r) => r.text.toPlainText()),
        contains('const a = 1;'),
      );
    });

    testWidgets('an unknown language gets no header strip at all', (
      WidgetTester tester,
    ) async {
      await _pump(
        tester,
        const AgentMarkdown(text: '```rust\nlet a = 1;\n```'),
      );
      expect(_copy('rust'), findsNothing);
      expect(find.byType(PreformattedCode), findsOneWidget);
    });

    testWidgets('a bare URL keeps the sentence full stop it swallowed', (
      WidgetTester tester,
    ) async {
      // DRIFT, reproduced: `[^\s<>()]+` does not exclude `.`, so the label the
      // reference measures is 149.22px of `https://example.com.` — period
      // included.
      await _pump(
        tester,
        const AgentMarkdown(text: 'Visit https://example.com.'),
      );
      final flutter.RichText paragraph = tester.widget<flutter.RichText>(
        find.byType(flutter.RichText).first,
      );
      expect(paragraph.text.toPlainText(), 'Visit https://example.com.');
    });

    testWidgets('an ordered list draws the authored numbers', (
      WidgetTester tester,
    ) async {
      await _pump(
        tester,
        const AgentMarkdown(text: '4. one\n5) two\n7. three'),
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
        const AgentMarkdown(text: '| a | b |\n|---|---|\n| 1 | 2 |'),
      );
      expect(find.byType(flutter.Table), findsOneWidget);

      await _pump(tester, const AgentMarkdown(text: 'a | b'));
      expect(find.byType(flutter.Table), findsNothing);
    });
  });

  /* ── Turns ─────────────────────────────────────────────────────────────── */

  group('turns', () {
    testWidgets('the user bubble is capped at 85% and squares one corner', (
      WidgetTester tester,
    ) async {
      await _pump(
        tester,
        const UserMessage(
          turn: UserTurn(id: 'u', text: 'What sealed boxes are left?'),
        ),
      );
      final Container bubble = tester.widget<Container>(
        find.byType(Container).first,
      );
      final BoxDecoration decoration = bubble.decoration! as BoxDecoration;
      expect(
        decoration.borderRadius,
        BorderRadius.only(
          topLeft: const Radius.circular(Radii.xl),
          topRight: const Radius.circular(Radii.xl),
          bottomRight: const Radius.circular(Radii.sm),
          bottomLeft: const Radius.circular(Radii.xl),
        ),
      );
      expect(
        tester.getSize(find.byType(Container).first).width,
        lessThanOrEqualTo(600 * UserMessage.maxWidthFraction + 0.01),
      );
    });

    testWidgets('the agent turn strips a half-arrived protocol tag', (
      WidgetTester tester,
    ) async {
      await _pump(
        tester,
        const AgentMessage(
          turn: TextTurn(id: 'a', text: 'Done.<complete> and <comp'),
        ),
      );
      final flutter.RichText paragraph = tester.widget<flutter.RichText>(
        find.byType(flutter.RichText).first,
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
        const AgentMessage(
          turn: TextTurn(id: 'a', text: 'Checking'),
        ),
      );
      expect(find.byType(TypingCursor), findsNothing);

      await _pump(
        tester,
        const AgentMessage(
          turn: TextTurn(id: 'a', text: 'Checking', streaming: true),
        ),
      );
      expect(find.byType(TypingCursor), findsOneWidget);
    });

    testWidgets('an empty turn with no attachments renders nothing', (
      WidgetTester tester,
    ) async {
      await _pump(
        tester,
        const AgentMessage(
          turn: TextTurn(id: 'a', text: '   '),
        ),
      );
      expect(find.byType(AgentMarkdown), findsNothing);
    });
  });

  /* ── Chips ─────────────────────────────────────────────────────────────── */

  group('tool chip', () {
    const ToolTurn unmapped = ToolTurn(
      id: 't',
      name: 'export_activity',
      params: <String, Object?>{'window': '30d'},
      status: AgentTurnStatus.ok,
      attempt: 1,
    );

    testWidgets('an unmapped tool falls back to its own humanised name', (
      WidgetTester tester,
    ) async {
      await _pump(tester, const ToolChip(turn: unmapped));
      // The name is the most honest thing available — never "used a tool".
      expect(_copy('Export activity'), findsOneWidget);
    });

    testWidgets('a mapped tool takes AGENT_STATE_LABEL verbatim', (
      WidgetTester tester,
    ) async {
      await _pump(
        tester,
        const ToolChip(
          turn: unmapped,
          toolStates: <String, AgentState>{
            'export_activity': AgentState.retrieving,
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
        const ToolChip(
          turn: ToolTurn(
            id: 't',
            name: 'fetch_market_price',
            params: <String, Object?>{},
            status: AgentTurnStatus.error,
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
        const ToolChip(
          turn: ToolTurn(
            id: 't',
            name: 'export_activity',
            params: <String, Object?>{},
            status: AgentTurnStatus.ok,
            attempt: 1,
            result: <String, Object?>{
              'rows': 148,
              '__attachments': <Object?>[],
            },
          ),
        ),
      );
      await tester.tap(find.byType(Button));
      await tester.pump();
      expect(find.text('{\n  "rows": 148\n}'), findsOneWidget);
    });

    testWidgets('an action the user declined says so in the label', (
      WidgetTester tester,
    ) async {
      await _pump(
        tester,
        const ActionChip(
          turn: ActionTurn(
            id: 'a',
            action: 'navigate',
            params: <String, Object?>{'url': '/vault'},
            status: AgentTurnStatus.ok,
            approval: ApprovalOutcome.rejected,
          ),
        ),
      );
      expect(_copy('Declined: Navigate · /vault'), findsOneWidget);
    });
  });

  group('approval card', () {
    const PendingApproval bare = PendingApproval(
      turnId: 'x',
      action: 'open_page',
      params: <String, Object?>{'url': '/vault'},
      approve: _nothing,
      reject: _nothingReject,
    );

    testWidgets('with no describe it builds a sentence out of the target', (
      WidgetTester tester,
    ) async {
      await _pump(tester, const ApprovalCard(approval: bare));
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
        ApprovalCard(
          approval: bare,
          describe: (String action, Map<String, Object?> params) =>
              'This spends real money.',
        ),
      );
      expect(_copy('This spends real money.'), findsOneWidget);
      expect(find.text('{\n  "url": "/vault"\n}'), findsOneWidget);
    });

    test('Decline hands back the reason in as many words', () {
      expect(ApprovalCard.declineReason, 'The user declined this action.');
    });
  });

  /* ── Attachments ───────────────────────────────────────────────────────── */

  group('attachments', () {
    const AgentAttachment csv = AgentAttachment(
      id: 'a',
      name: 'export.csv',
      mime: 'text/csv',
      kind: AgentAttachmentKind.data,
      size: 18422,
      delivery: AgentDelivery.content(),
    );
    const AgentAttachment pdf = AgentAttachment(
      id: 'b',
      name: 'report.pdf',
      mime: 'application/pdf',
      kind: AgentAttachmentKind.document,
      size: 2620000,
      delivery: AgentDelivery.reference('It is not text.'),
    );
    const AgentAttachment made = AgentAttachment(
      id: 'c',
      name: 'made.csv',
      mime: 'text/csv',
      kind: AgentAttachmentKind.data,
      size: 4821,
      delivery: AgentDelivery.produced(),
    );

    testWidgets('each delivery says exactly as much as it can', (
      WidgetTester tester,
    ) async {
      await _pump(
        tester,
        const AgentAttachmentList(
          attachments: <AgentAttachment>[csv, pdf, made],
        ),
      );
      expect(_copy('Read'), findsOneWidget);
      expect(_copy('Name only'), findsOneWidget);
      // `produced` says nothing at all: delivery does not apply to a file the
      // agent made itself.
      expect(find.byType(AgentAttachmentCard), findsNWidgets(3));
      expect(_copy('18 KB'), findsOneWidget);
      // `formatBytes` — one decimal, and 2_620_000 bytes is 2.5 MiB.
      expect(_copy('2.5 MB'), findsOneWidget);
    });

    testWidgets('an image with a url gets the large treatment, not a row', (
      WidgetTester tester,
    ) async {
      await _pump(
        tester,
        AgentAttachmentList(
          attachments: const <AgentAttachment>[
            AgentAttachment(
              id: 'i',
              name: 'shot.png',
              mime: 'image/png',
              kind: AgentAttachmentKind.image,
              size: 1024,
              url: 'blob:shot',
              delivery: AgentDelivery.content(),
            ),
            csv,
          ],
          imageBuilder: (BuildContext _, AgentAttachment _) =>
              const SizedBox(width: 640, height: 360),
        ),
      );
      // The picture is not a card; the spreadsheet is.
      expect(find.byType(AgentAttachmentCard), findsOneWidget);
      expect(_copy('shot.png'), findsOneWidget);
      // And it is openable, because it has a url.
      expect(find.byType(AttachmentTrigger), findsOneWidget);
    });

    testWidgets('an empty list draws nothing', (WidgetTester tester) async {
      await _pump(
        tester,
        const AgentAttachmentList(attachments: <AgentAttachment>[]),
      );
      expect(find.byType(Attachment), findsNothing);
    });
  });

  /* ── The wizard ────────────────────────────────────────────────────────── */

  group('questionnaire', () {
    Widget threeStep({VoidCallback? onSubmit}) => Questionnaire(
      shortcuts: QuestionnaireShortcuts.letters,
      onSubmit: onSubmit,
      children: <Widget>[
        const QuestionnaireProgress(),
        const QuestionnaireItem(
          name: 'style',
          required: true,
          title: QuestionnaireTitle('How do you pick?'),
          children: <Widget>[
            QuestionnaireChoices(
              children: <QuestionnaireChoice>[
                QuestionnaireChoice(value: 'price', label: 'Cheapest'),
                QuestionnaireChoice(value: 'odds', label: 'Best odds'),
              ],
            ),
            QuestionnaireError(),
          ],
        ),
        const QuestionnaireItem(
          name: 'goal',
          title: QuestionnaireTitle('Chasing anything?'),
          children: <Widget>[QuestionnaireInput()],
        ),
        const QuestionnaireItem(
          name: 'budget',
          required: true,
          title: QuestionnaireTitle('Budget?'),
          children: <Widget>[QuestionnaireInput()],
        ),
        const QuestionnaireActions(
          children: <Widget>[
            QuestionnairePrevious(),
            QuestionnaireSkip(),
            QuestionnaireNext(),
            QuestionnaireSubmit(),
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
      expect(_copy(QuestionnaireError.requiredDefault), findsOneWidget);
      expect(_copy('Question 1 of 3'), findsOneWidget);

      await tester.tap(_copy('Best odds'));
      await tester.pump();
      expect(_copy(QuestionnaireError.requiredDefault), findsNothing);
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

      await tester.enterText(find.byType(QuestionnaireInput), '40');
      await tester.pump();
      await tester.tap(find.text('Submit'));
      await tester.pump();
      expect(submitted, 1);
    });

    testWidgets('the drawn key is the bound key', (WidgetTester tester) async {
      await _pump(tester, threeStep(), width: 1030);
      expect(
        find.byWidgetPredicate((Widget w) => w is Kbd && w.text == 'A'),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate((Widget w) => w is Kbd && w.text == 'B'),
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
        const Questionnaire(
          children: <Widget>[
            QuestionnaireItem(
              name: 'demo',
              children: <Widget>[
                QuestionnaireChoices(
                  children: <QuestionnaireChoice>[
                    QuestionnaireChoice(value: 'a', label: 'Option A'),
                  ],
                ),
              ],
            ),
          ],
        ),
        width: 320,
      );
      expect(find.byType(Kbd), findsNothing);
    });

    testWidgets('an optional item gets the other default error string', (
      WidgetTester tester,
    ) async {
      await _pump(
        tester,
        const Questionnaire(
          children: <Widget>[
            QuestionnaireItem(
              name: 'demo',
              invalid: true,
              children: <Widget>[QuestionnaireError()],
            ),
          ],
        ),
        width: 320,
      );
      expect(_copy(QuestionnaireError.optionalDefault), findsOneWidget);
      expect(
        QuestionnaireError.optionalDefault,
        'Choose an answer or skip this question.',
      );
    });

    testWidgets('defaultChecked seeds the answer on mount', (
      WidgetTester tester,
    ) async {
      await _pump(
        tester,
        const Questionnaire(
          children: <Widget>[
            QuestionnaireItem(
              name: 'demo',
              children: <Widget>[
                QuestionnaireChoices(
                  children: <QuestionnaireChoice>[
                    QuestionnaireChoice(
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
      final ThemeTokens theme = ThemeScope.of(
        tester.element(find.byType(QuestionnaireChoice)),
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
      // [ButtonStyleRecipe] had no `hoverBorder`, so the label brightened while
      // the rim stayed the outline variant's own — a half-painted hover, and
      // the visible kind. The primitive grew the fifth override (the agent
      // launcher wanted the same one) and this is both halves arriving.
      await _pump(
        tester,
        WelcomeCard(
          name: 'Vault',
          capabilities: const <AgentCapability>[
            AgentCapability(
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
        matching: find.byType(Button),
      );
      Color rimOf() =>
          (tester
                      .widget<Surface>(
                        find.descendant(
                          of: chip,
                          matching: find.byType(Surface),
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

      final ThemeTokens light = ThemeTokens.light;
      final Color rim = light.agentAccent.withValues(
        alpha: WelcomeCard.capabilityHoverRimAlpha,
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
