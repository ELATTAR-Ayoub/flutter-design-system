import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/agent_transcript/meta.dart';
import 'package:example/components_docs/agent_transcript/page.dart';
import 'package:example/docs/component_doc_page.dart' show DocsTocEntry;
import 'package:example/docs/docs_disclosure.dart';
import 'package:example/docs/docs_install.dart';
import 'package:example/docs/docs_section.dart' show DocsSection;
import 'package:example/docs/docs_showcase.dart';
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
import 'package:flutter_test/flutter_test.dart';

Widget _harness({required Widget child, required ThemeController controller}) =>
    ThemeScope(
      controller: controller,
      child: MaterialApp(
        home: Builder(
          // The ambient ink every route inherits, as the docs shell sets it
          // for the real app. Without it this subtree sits under WidgetsApp's
          // red fallback style, which StyledText asserts on rather than
          // quietly painting over.
          builder: (BuildContext context) => DefaultTextStyle(
            style: StyledText.styleOf(
              context,
              TextStyles.body,
              color: ThemeScope.of(context).foreground,
            ),
            child: SingleChildScrollView(child: child),
          ),
        ),
      ),
    );

Finder _disclosureTrigger(String title) => find.descendant(
  of: find.byWidgetPredicate(
    (Widget widget) => widget is DocsDisclosure && widget.title == title,
  ),
  matching: find.byKey(DocsDisclosure.triggerKey),
);

/// Every `DocsApiFact.name` this page's API Reference declares, across all
/// ten tables — extracted mechanically from `page.dart` so this list cannot
/// silently drift from what the page actually renders.
const List<String> _agentTranscriptApiFactNames = <String>[
  'ActionChip.padX / padY / gap',
  'ActionChip.rimAlpha',
  'AgentMessage.gap',
  'ApprovalCard.actionGap',
  'ApprovalCard.declineReason',
  'ApprovalCard.defaultSentence(approval)',
  'ApprovalCard.glyphPx / glyphTop',
  'ApprovalCard.headGap / headLineGap',
  'ApprovalCard.pad / gap',
  'ApprovalCard.paramsMaxHeight / paramsPad',
  'ApprovalCard.rimAlpha / washAlpha',
  'FadeUp.rise',
  'RowIn.delayFor(index)',
  'RowIn.slide',
  'ToolChip.chevronAlpha',
  'ToolChip.chevronPx',
  'ToolChip.contentGap',
  'ToolChip.detailGap',
  'ToolChip.errorRimAlpha',
  'ToolChip.gap',
  'ToolChip.padX / padY',
  'ToolChip.panelFillAlpha',
  'ToolChip.panelPad / panelGap',
  'ToolChip.valueMaxHeight',
  'TypingCursor.inset',
  'TypingCursor.markHeight',
  'TypingCursor.markWidth',
  'UserMessage.gap',
  'UserMessage.maxWidthFraction',
  'UserMessage.padX / padY',
  'UserMessage.radius',
  'UserMessage.rimAlpha',
  'WelcomeCard.avatarPx',
  'WelcomeCard.capabilityGlyphPx',
  'WelcomeCard.capabilityHoverRimAlpha',
  'WelcomeCard.capabilityLabel',
  'WelcomeCard.columnWidth',
  'WelcomeCard.gridGap',
  'WelcomeCard.maxCapabilities',
  'WelcomeCard.nameTop / blurbTop / listTop',
  'WelcomeCard.outerPadY',
  'WelcomeCard.suggestionGap',
  'WelcomeCard.suggestionLabel',
  'approval',
  'avatar',
  'blurb',
  'capabilities',
  'child',
  'describe',
  'disabled',
  'glyph',
  'hint',
  'id',
  'imageBuilder',
  'index',
  'label',
  'name',
  'onDownload',
  'onPick',
  'onUseCapability',
  'renderResult',
  'suggestions',
  'toolStates',
  'turn',
];

void main() {
  group('agent-transcript docs page', () {
    testWidgets(
      'renders the article, the full API table, and every live specimen '
      'this page claims to show',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        String? destination;
        await tester.pumpWidget(
          _harness(
            controller: ThemeController(mode: ColorMode.dark),
            child: AgentTranscriptDocPage(
              onNavigate: (String route) => destination = route,
            ),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('agent-transcript-doc-article')),
          findsOneWidget,
        );

        final Finder apiTrigger = _disclosureTrigger('API Reference');
        await tester.ensureVisible(apiTrigger);
        await tester.pump();
        await tester.tap(apiTrigger);
        await tester.pump();
        await tester.pump(MotionDurations.open);

        for (final String name in _agentTranscriptApiFactNames) {
          expect(find.text(name), findsWidgets, reason: 'missing $name');
        }

        // Preview: the three composed rows really mount.
        expect(
          find.byKey(const ValueKey<String>('agent-transcript-preview')),
          findsOneWidget,
        );
        expect(find.byType(UserMessage), findsWidgets);
        expect(find.byType(ToolChip), findsWidgets);
        expect(find.byType(AgentMessage), findsWidgets);

        // User message: the bubble text and its attachment both render.
        expect(find.text('Here is the export you asked for.'), findsOneWidget);
        expect(find.textContaining('export.csv'), findsOneWidget);

        // Agent message: a streaming turn really mounts a typing cursor,
        // a settled one does not.
        final Finder streamingMessage = find.byKey(
          const ValueKey<String>('agent-transcript-message-streaming'),
        );
        expect(
          find.descendant(
            of: streamingMessage,
            matching: find.byType(TypingCursor),
          ),
          findsOneWidget,
        );

        // Tool chip: closed by default (no arguments panel mounted), and
        // tapping it really opens the disclosure.
        final Finder toolChip = find.byKey(
          const ValueKey<String>('agent-transcript-tool-chip'),
        );
        expect(toolChip, findsOneWidget);
        expect(find.text('Tool'), findsNothing);
        final Finder toolChipTrigger = find.descendant(
          of: toolChip,
          matching: find.byType(Button),
        );
        await tester.ensureVisible(toolChipTrigger);
        await tester.pump();
        await tester.tap(toolChipTrigger);
        await tester.pump();
        expect(find.text('Tool'), findsOneWidget);
        expect(find.text('search_inventory'), findsWidgets);

        // Action chip: three real outcomes.
        expect(
          find.byKey(const ValueKey<String>('agent-transcript-action-ok')),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey<String>('agent-transcript-action-error')),
          findsOneWidget,
        );
        expect(
          find.byKey(
            const ValueKey<String>('agent-transcript-action-declined'),
          ),
          findsOneWidget,
        );
        expect(find.textContaining('Declined:'), findsOneWidget);

        // Approval card: a real gate. Pressing Approve genuinely calls the
        // PendingApproval's own callback and the card is replaced.
        final Finder approvalCard = find.byKey(
          const ValueKey<String>('agent-transcript-approval-card'),
        );
        expect(approvalCard, findsOneWidget);
        final Finder approveButton = find.descendant(
          of: approvalCard,
          matching: find.text('Approve'),
        );
        await tester.ensureVisible(approveButton);
        await tester.pump();
        await tester.tap(approveButton);
        await tester.pump();
        expect(approvalCard, findsNothing);
        expect(
          find.byKey(
            const ValueKey<String>('agent-transcript-approval-outcome'),
          ),
          findsOneWidget,
        );
        expect(find.text('Approved.'), findsOneWidget);

        // Welcome card: name, blurb, capabilities and suggestions all
        // render live.
        expect(
          find.byKey(const ValueKey<String>('agent-transcript-welcome-card')),
          findsOneWidget,
        );
        expect(find.text('Vault Assistant'), findsOneWidget);
        final Finder welcomeCard = find.byKey(
          const ValueKey<String>('agent-transcript-welcome-card'),
        );
        // 'Search inventory' also appears as the Tool chip specimen's own
        // humanised label (humaniseToolName('search_inventory')) — scoped
        // to the welcome card to avoid that collision.
        expect(
          find.descendant(
            of: welcomeCard,
            matching: find.text('Search inventory'),
          ),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: welcomeCard,
            matching: find.text('Export activity'),
          ),
          findsOneWidget,
        );
        expect(
          find.text('What is Eclipse Vault worth right now?'),
          findsOneWidget,
        );

        expect(agentTranscriptDoc.name, 'agent-transcript');
        expect(
          agentTranscriptDoc.exports,
          containsAll(<String>[
            'UserMessage',
            'AgentMessage',
            'ToolChip',
            'ActionChip',
            'ApprovalCard',
            'WelcomeCard',
          ]),
        );
        expect(agentTranscriptDoc.command, 'elattar add agent-transcript');
        expect(destination, isNull);
      },
    );

    testWidgets('the page is declared, and every section is a kit component', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 6000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _harness(
          controller: ThemeController(mode: ColorMode.dark),
          child: const AgentTranscriptDocPage(),
        ),
      );
      await tester.pump();

      // Seven specimen stages: Preview, User message, Agent message,
      // Tool chip, Action chip, Approval card, Welcome card.
      expect(find.byType(DocsShowcase), findsNWidgets(7));
      expect(find.byType(DocsInstall), findsOneWidget);
      expect(find.byType(DocsDisclosure), findsNWidgets(8));
    });

    test('the table of contents matches the declared sections', () {
      expect(
        agentTranscriptDocSpec.toc
            .map((DocsTocEntry entry) => entry.title)
            .toList(),
        <String>[
          'Preview',
          'Installation',
          'Usage',
          'User message',
          'Agent message',
          'Tool chip',
          'Action chip',
          'Approval card',
          'Welcome card',
          'API Reference',
          'States',
          'Accessibility',
          'Keyboard',
          'Responsive',
          'Dependencies',
          'Theming',
          'Source',
        ],
      );
      expect(
        agentTranscriptDocSpec.toc
            .singleWhere((DocsTocEntry e) => e.anchor == 'api')
            .children,
        hasLength(10),
      );
    });

    testWidgets('sections render in declaration order, section for section', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _harness(
          controller: ThemeController(mode: ColorMode.dark),
          child: const AgentTranscriptDocPage(),
        ),
      );
      await tester.pump();

      final List<String> titles = tester
          .widgetList<DocsSection>(find.byType(DocsSection))
          .map((DocsSection section) => section.title)
          .toList();

      expect(titles, <String>[
        'Preview',
        'Installation',
        'Usage',
        'User message',
        'Agent message',
        'Tool chip',
        'Action chip',
        'Approval card',
        'Welcome card',
        'API Reference',
        'States',
        'Accessibility',
        'Keyboard',
        'Responsive',
        'Dependencies',
        'Theming',
        'Source',
      ]);
    });

    testWidgets(
      'renders at narrow width with the anchor strip instead of a rail',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ThemeController(mode: ColorMode.dark),
            child: const AgentTranscriptDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('agent-transcript-doc-article')),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey<String>('docs-layout-anchor-strip')),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey<String>('docs-layout-sidebar')),
          findsNothing,
        );
      },
    );

    testWidgets(
      'survives a live theme flip in place, at desktop width, without '
      'losing any showcase specimen',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        final ThemeController controller = ThemeController(
          mode: ColorMode.dark,
        );
        await tester.pumpWidget(
          _harness(
            controller: controller,
            child: const AgentTranscriptDocPage(),
          ),
        );
        await tester.pump();

        final ThemeTokens darkTheme = ThemeScope.of(
          tester.element(
            find.byKey(const ValueKey<String>('agent-transcript-doc-article')),
          ),
        );

        controller.setMode(ColorMode.light);
        await tester.pump();

        final ThemeTokens lightTheme = ThemeScope.of(
          tester.element(
            find.byKey(const ValueKey<String>('agent-transcript-doc-article')),
          ),
        );

        expect(lightTheme.background, isNot(darkTheme.background));
        expect(lightTheme.foreground, isNot(darkTheme.foreground));

        expect(find.byType(DocsShowcase), findsNWidgets(7));
        for (final String key in <String>[
          'agent-transcript-preview',
          'agent-transcript-tool-chip',
          'agent-transcript-approval-card',
          'agent-transcript-welcome-card',
        ]) {
          expect(find.byKey(ValueKey<String>(key)), findsOneWidget);
        }
      },
    );
  });
}
