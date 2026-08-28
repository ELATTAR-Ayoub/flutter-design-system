import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/agent_console/meta.dart';
import 'package:example/components_docs/agent_console/page.dart';
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
      child: MaterialApp(home: SingleChildScrollView(child: child)),
    );

Finder _disclosureTrigger(String title) => find.descendant(
  of: find.byWidgetPredicate(
    (Widget widget) => widget is DocsDisclosure && widget.title == title,
  ),
  matching: find.byKey(DocsDisclosure.triggerKey),
);

/// Every `DocsApiFact.name` this page's API Reference declares, across all
/// five tables — extracted mechanically from `page.dart` so this list
/// cannot silently drift from what the page actually renders.
const List<String> _agentConsoleApiFactNames = <String>[
  'AgentConsole.gap',
  'AgentConsole.headerGap',
  'AgentConsole.headerInset',
  'AgentConsole.padding',
  'AgentConsole.pinTolerance',
  'AgentConsole.scrollerInset',
  'AgentConsole.turnGap',
  'AgentFeatures.all',
  'accent',
  'attachments',
  'avatar',
  'blurb',
  'commands',
  'describeApproval',
  'features',
  'headerSlot',
  'height',
  'hint',
  'id',
  'label',
  'microphone',
  'models',
  'name',
  'persona',
  'placeholder',
  'renderToolResult',
  'reset',
  'speech',
  'speed',
  'suggestions',
  'switchPhase',
  'toolStates',
  'toolTrace',
  'transport',
];

void main() {
  group('agent-console docs page', () {
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
            child: AgentConsoleDocPage(
              onNavigate: (String route) => destination = route,
            ),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('agent-console-doc-article')),
          findsOneWidget,
        );

        final Finder apiTrigger = _disclosureTrigger('API Reference');
        await tester.ensureVisible(apiTrigger);
        await tester.pump();
        await tester.tap(apiTrigger);
        await tester.pump();
        await tester.pump(MotionDurations.open);

        for (final String name in _agentConsoleApiFactNames) {
          expect(find.text(name), findsWidgets, reason: 'missing $name');
        }

        // Preview: a real console over a real MockTransport. It starts
        // with an empty transcript, so the welcome card renders with the
        // real persona, suggestion and skill this page configured.
        //
        // Deliberately not pressing send anywhere on this page: the mock
        // transport's script runs on real Future.delayed timers, and
        // draining every one of them for a page this size is not worth
        // the fragility. Typing (below) exercises real, synchronous state
        // instead.
        final Finder preview = find.byKey(
          const ValueKey<String>('agent-console-preview'),
        );
        expect(preview, findsOneWidget);
        expect(find.text('Vault Assistant'), findsWidgets);
        expect(
          find.text('Ask about inventory, pricing, or your account.'),
          findsOneWidget,
        );
        expect(
          find.text('What is Eclipse Vault worth right now?'),
          findsOneWidget,
        );
        expect(find.text('Find a card'), findsOneWidget);

        // Typing enables the composer's send button — real, synchronous
        // canSend state, no transport call involved.
        final Finder previewInput = find.descendant(
          of: preview,
          matching: find.byType(EditableText),
        );
        await tester.ensureVisible(previewInput);
        await tester.pump();
        final Finder previewSend = find.descendant(
          of: preview,
          matching: find.byWidgetPredicate(
            (Widget w) => w is Button && w.label == 'Send',
          ),
        );
        expect(tester.widget<Button>(previewSend).onPressed, isNull);
        await tester.enterText(previewInput, 'How much is Eclipse Vault?');
        await tester.pump();
        expect(tester.widget<Button>(previewSend).onPressed, isNotNull);

        // Features: every switch off — no avatar/header row, no
        // suggestions, no model picker, no reset/stop command. The
        // welcome card still renders (an empty transport), but with
        // nothing configured (no persona, no commands on this specimen).
        final Finder features = find.byKey(
          const ValueKey<String>('agent-console-features'),
        );
        expect(features, findsOneWidget);

        // Header slot: the caller's own widget mounts where documented.
        expect(
          find.byKey(
            const ValueKey<String>('agent-console-header-slot-button'),
          ),
          findsOneWidget,
        );

        // Height: both pinned heights render, each its own console.
        expect(
          find.byKey(const ValueKey<String>('agent-console-height-live')),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey<String>('agent-console-height-minimal')),
          findsOneWidget,
        );

        expect(agentConsoleDoc.name, 'agent-console');
        expect(
          agentConsoleDoc.exports,
          containsAll(<String>[
            'AgentConsole',
            'AgentFeatures',
            'AgentPersona',
            'AgentModel',
          ]),
        );
        expect(agentConsoleDoc.command, 'elattar add agent-console');
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
          child: const AgentConsoleDocPage(),
        ),
      );
      await tester.pump();

      // Four specimen stages: Preview, Features, Header slot, Height.
      expect(find.byType(DocsShowcase), findsNWidgets(4));
      expect(find.byType(DocsInstall), findsOneWidget);
      expect(find.byType(DocsDisclosure), findsNWidgets(8));
    });

    test('the table of contents matches the declared sections', () {
      expect(
        agentConsoleDocSpec.toc
            .map((DocsTocEntry entry) => entry.title)
            .toList(),
        <String>[
          'Preview',
          'Installation',
          'Usage',
          'Features',
          'Header slot',
          'Height',
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
        agentConsoleDocSpec.toc
            .singleWhere((DocsTocEntry e) => e.anchor == 'api')
            .children,
        hasLength(5),
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
          child: const AgentConsoleDocPage(),
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
        'Features',
        'Header slot',
        'Height',
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
            child: const AgentConsoleDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('agent-console-doc-article')),
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
          _harness(controller: controller, child: const AgentConsoleDocPage()),
        );
        await tester.pump();

        final ThemeTokens darkTheme = ThemeScope.of(
          tester.element(
            find.byKey(const ValueKey<String>('agent-console-doc-article')),
          ),
        );

        controller.setMode(ColorMode.light);
        await tester.pump();

        final ThemeTokens lightTheme = ThemeScope.of(
          tester.element(
            find.byKey(const ValueKey<String>('agent-console-doc-article')),
          ),
        );

        expect(lightTheme.background, isNot(darkTheme.background));
        expect(lightTheme.foreground, isNot(darkTheme.foreground));

        expect(find.byType(DocsShowcase), findsNWidgets(4));
        for (final String key in <String>[
          'agent-console-preview',
          'agent-console-features',
          'agent-console-header-slot',
          'agent-console-height-live',
          'agent-console-height-minimal',
        ]) {
          expect(find.byKey(ValueKey<String>(key)), findsOneWidget);
        }
      },
    );
  });
}
