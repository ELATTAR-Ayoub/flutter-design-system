import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/agent_core/meta.dart';
import 'package:example/components_docs/agent_core/page.dart';
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

/// The single `DocsDisclosure` whose title is [title] — see
/// `button_test.dart`'s own copy of this helper for why the lookup narrows
/// by title first.
Finder _disclosureTrigger(String title) => find.descendant(
  of: find.byWidgetPredicate(
    (Widget widget) => widget is DocsDisclosure && widget.title == title,
  ),
  matching: find.byKey(DocsDisclosure.triggerKey),
);

/// Every `DocsApiFact.name` this page's API Reference declares, across all
/// twenty-six tables — extracted mechanically from `page.dart` so this list
/// cannot silently drift from what the page actually renders.
const List<String> _agentCoreApiFactNames = <String>[
  '.wire / .label / .isBusy / .isNarrating / .glyph',
  'AgentDelivery.content()',
  'AgentDelivery.produced()',
  'AgentDelivery.reference(reason)',
  'BlurSwitchController({required open})',
  'BlurSwitchController.inDuration',
  'BlurSwitchController.outDuration',
  'ToolStateMap',
  'abort()',
  'action',
  'activeId',
  'approval',
  'approvals',
  'approve',
  'approved',
  'attachments',
  'attempt',
  'audio',
  'awaitingApproval',
  'awaitingFirstEvent',
  'blurIn',
  'callingTools',
  'capabilities',
  'code',
  'content',
  'conversations',
  'copyWith({delivery, text})',
  'copyWith({streaming})',
  'copyWith({title, pinned})',
  'create()',
  'data',
  'declared',
  'delegating',
  'delivery',
  'document',
  'done',
  'attachmentKind(mime, name)',
  'formatBytes(bytes)',
  'formatMs(ms)',
  'humaniseToolName(name)',
  'isTextual(attachment)',
  'relativeTime(then, {now})',
  'relativeTimeOf(context, then)',
  'resolveAgentState({turns, signals, toolStates})',
  'serialiseAttachments(text, attachments)',
  'stateForTool(name, map)',
  'stripProtocol(text)',
  'error',
  'fatal',
  'id',
  'idle',
  'image',
  'ingesting',
  'isLoading',
  'isReady',
  'kind',
  'message',
  'mime',
  'model',
  'models',
  'ms',
  'name',
  'none',
  'notStreaming()',
  'ok',
  'open(id)',
  'other',
  'out',
  'params',
  'pending',
  'pendingApprovals',
  'phase',
  'pin',
  'pinned',
  'planning',
  'preview',
  'processing',
  'produced',
  'queued',
  'reading',
  'reason',
  'recalling',
  'reference',
  'refresh()',
  'reject',
  'rejected',
  'remove(id)',
  'rename(id, title)',
  'reset()',
  'result',
  'retrieving',
  'retrying',
  'running',
  'searching',
  'send(text, [options])',
  'sent',
  'share',
  'size',
  'startedAt',
  'status',
  'streaming',
  'summarizing',
  'switchTo(id)',
  'text',
  'thinking',
  'title',
  'turnId',
  'turns',
  'updatedAt',
  'url',
  'validating',
  'wireText',
  'writing',
];

void main() {
  group('agent-core docs page', () {
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
            child: AgentCoreDocPage(
              onNavigate: (String route) => destination = route,
            ),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('agent-core-doc-article')),
          findsOneWidget,
        );

        // The API table lives inside the API Reference disclosure, closed
        // by default.
        final Finder apiTrigger = _disclosureTrigger('API Reference');
        await tester.ensureVisible(apiTrigger);
        await tester.pump();
        await tester.tap(apiTrigger);
        await tester.pump();
        await tester.pump(MotionDurations.open);

        for (final String name in _agentCoreApiFactNames) {
          expect(find.text(name), findsWidgets, reason: 'missing $name');
        }

        // Every AgentState.values member is named in the AgentState
        // table (via its enum value name) AND rendered live in Preview
        // above (via its chip key).
        for (final AgentState state in AgentState.values) {
          expect(
            find.text(state.name),
            findsWidgets,
            reason: 'AgentState.${state.name} missing from API table',
          );
          expect(
            find.byKey(ValueKey<String>('agent-core-preview:${state.name}')),
            findsOneWidget,
            reason: 'AgentState.${state.name} missing a Preview chip',
          );
        }

        // Resolve agent state: every scenario mounts, and a spot check of
        // the precedence ladder's own real outputs.
        final Map<String, String> resolved = <String, String>{
          for (final AgentState state in AgentState.values)
            state.label: state.name,
        };
        expect(resolved, isNotEmpty);
        expect(
          find.byKey(
            const ValueKey<String>('agent-core-resolve:0. Empty conversation'),
          ),
          findsOneWidget,
        );
        expect(find.text('Ready'), findsWidgets); // idle.label
        expect(find.text('Queued'), findsWidgets); // awaitingFirstEvent
        expect(find.text('Thinking'), findsWidgets); // isLoading alone
        expect(find.text('Retrying'), findsWidgets); // attempt > 1
        expect(find.text('Awaiting approval'), findsWidgets);
        expect(find.text('Something went wrong'), findsWidgets); // fatal
        expect(find.text('Done'), findsWidgets);

        // Tool state mapping: exact match, prefix, longest-prefix-wins,
        // and the unmapped fallback — all real stateForTool calls.
        expect(
          find.byKey(
            const ValueKey<String>('agent-core-tool-mapping:search_inventory'),
          ),
          findsOneWidget,
        );
        expect(find.text('Searching'), findsWidgets);
        expect(find.text('Retrieving knowledge'), findsWidgets);
        expect(find.text('Processing'), findsWidgets);
        expect(
          find.textContaining('falls back to "Export activity"'),
          findsOneWidget,
        );

        // Formatting helpers: real formatBytes/formatMs/
        // humaniseToolName/relativeTime outputs.
        expect(find.text('512 B'), findsOneWidget);
        expect(find.text('2 KB'), findsOneWidget);
        expect(find.text('2.5 MB'), findsOneWidget);
        expect(find.text('320ms'), findsOneWidget);
        expect(find.text('8.0s'), findsOneWidget);
        expect(find.text('Search inventory'), findsOneWidget);
        expect(find.text('Export activity report'), findsOneWidget);
        expect(find.text('yesterday'), findsOneWidget);
        expect(find.text('in 3 hours'), findsOneWidget);

        // Serialise attachments: the real serialiseAttachments output —
        // a textual file inlined, an unreadable image referenced instead.
        // Scoped to the specimen's own output container: several of these
        // substrings (the file names, the fence name) also appear in the
        // section's own prose and in the Code toggle pane.
        Finder inSerialiseOutput(String substring) => find.descendant(
          of: find.byKey(const ValueKey<String>('agent-core-serialise-output')),
          matching: find.textContaining(substring),
        );
        expect(inSerialiseOutput('<file name="notes.md"'), findsOneWidget);
        expect(inSerialiseOutput('# Notes'), findsOneWidget);
        expect(
          inSerialiseOutput('<attached-but-not-readable>'),
          findsOneWidget,
        );
        expect(inSerialiseOutput('diagram.png'), findsOneWidget);

        expect(agentCoreDoc.name, 'agent-core');
        expect(
          agentCoreDoc.exports,
          containsAll(<String>[
            'AgentState',
            'AgentTurn',
            'AgentTransport',
            'AgentDelivery',
          ]),
        );
        expect(agentCoreDoc.command, 'elattar add agent-core');
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
          child: const AgentCoreDocPage(),
        ),
      );
      await tester.pump();

      // Five specimen stages: Preview, Resolve agent state, Tool state
      // mapping, Formatting helpers, Serialise attachments.
      expect(find.byType(DocsShowcase), findsNWidgets(5));
      expect(find.byType(DocsInstall), findsOneWidget);
      // Eight collapsed sections: API Reference, States, Accessibility,
      // Keyboard, Responsive, Dependencies, Theming, Source.
      expect(find.byType(DocsDisclosure), findsNWidgets(8));
    });

    test('the table of contents matches the declared sections', () {
      expect(
        agentCoreDocSpec.toc.map((DocsTocEntry entry) => entry.title).toList(),
        <String>[
          'Preview',
          'Installation',
          'Usage',
          'Resolve agent state',
          'Tool state mapping',
          'Formatting helpers',
          'Serialise attachments',
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
      // API Reference contributes one sub-anchor per class/enum/typedef
      // table, plus one for the top-level functions: twenty-six in total.
      expect(
        agentCoreDocSpec.toc
            .singleWhere((DocsTocEntry e) => e.anchor == 'api')
            .children,
        hasLength(26),
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
          child: const AgentCoreDocPage(),
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
        'Resolve agent state',
        'Tool state mapping',
        'Formatting helpers',
        'Serialise attachments',
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
            child: const AgentCoreDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('agent-core-doc-article')),
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
          _harness(controller: controller, child: const AgentCoreDocPage()),
        );
        await tester.pump();

        final ThemeTokens darkTheme = ThemeScope.of(
          tester.element(
            find.byKey(const ValueKey<String>('agent-core-doc-article')),
          ),
        );

        controller.setMode(ColorMode.light);
        await tester.pump();

        final ThemeTokens lightTheme = ThemeScope.of(
          tester.element(
            find.byKey(const ValueKey<String>('agent-core-doc-article')),
          ),
        );

        expect(lightTheme.background, isNot(darkTheme.background));
        expect(lightTheme.foreground, isNot(darkTheme.foreground));

        expect(find.byType(DocsShowcase), findsNWidgets(5));
        for (final AgentState state in AgentState.values) {
          expect(
            find.byKey(ValueKey<String>('agent-core-preview:${state.name}')),
            findsOneWidget,
          );
        }
      },
    );
  });
}
