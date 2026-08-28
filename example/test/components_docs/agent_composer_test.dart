import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/agent_composer/meta.dart';
import 'package:example/components_docs/agent_composer/page.dart';
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

/// Every named constructor parameter `AgentComposer`'s own class
/// declares (`lib/src/components/agent_composer.dart`), excluding `key`.
const List<String> _composerConstructorParams = <String>[
  'controller',
  'focusNode',
  'onSubmit',
  'onStop',
  'disabled',
  'busy',
  'placeholder',
  'commands',
  'attachments',
  'onAttach',
  'onRemoveAttachment',
  'accessory',
  'micControl',
  'dictationError',
];

/// Every static geometry getter `AgentComposer` declares.
const List<String> _composerStaticNames = <String>[
  'AgentComposer.defaultPlaceholder',
  'AgentComposer.dropPlaceholder',
  'AgentComposer.inputLabel',
  'AgentComposer.maxRowsPx',
  'AgentComposer.inputInsets',
  'AgentComposer.controlInsets',
  'AgentComposer.controlGap',
  'AgentComposer.trayPadding',
  'AgentComposer.inlineGap',
  'AgentComposer.controlSize',
  'AgentComposer.sendGlyphSize',
  'AgentComposer.stopGlyphSize',
  'AgentComposer.dragFillAlpha',
  'AgentComposer.disabledInputOpacity',
  'AgentComposer.messageTopGap',
];

Finder _sendButton() => find.byWidgetPredicate(
  (Widget widget) => widget is Button && widget.label == 'Send',
);

Finder _stopButton() => find.byWidgetPredicate(
  (Widget widget) => widget is Button && widget.label == 'Stop',
);

void main() {
  group('agent-composer docs page', () {
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
            child: AgentComposerDocPage(
              onNavigate: (String route) => destination = route,
            ),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('agent-composer-doc-article')),
          findsOneWidget,
        );

        final Finder apiTrigger = _disclosureTrigger('API Reference');
        await tester.ensureVisible(apiTrigger);
        await tester.pump();
        await tester.tap(apiTrigger);
        await tester.pump();
        await tester.pump(MotionDurations.open);

        for (final String param in _composerConstructorParams) {
          expect(find.text(param), findsWidgets, reason: 'missing $param');
        }
        for (final String name in _composerStaticNames) {
          expect(find.text(name), findsWidgets, reason: 'missing $name');
        }

        // Preview: a real composer. The send button starts disabled
        // (canSend is false with no text), typing enables it, and pressing
        // it genuinely calls onSubmit and clears the field.
        final Finder previewComposer = find.byKey(
          const ValueKey<String>('agent-composer-preview'),
        );
        expect(previewComposer, findsOneWidget);
        final Finder previewSend = find.descendant(
          of: previewComposer,
          matching: _sendButton(),
        );
        expect(
          tester.widget<Button>(previewSend).onPressed,
          isNull,
          reason: 'send must start disabled with nothing to send',
        );

        final Finder previewInput = find.descendant(
          of: previewComposer,
          matching: find.byType(EditableText),
        );
        await tester.ensureVisible(previewInput);
        await tester.pump();
        await tester.enterText(previewInput, 'Hello there');
        await tester.pump();
        expect(
          tester.widget<Button>(previewSend).onPressed,
          isNotNull,
          reason: 'send must enable once there is text',
        );
        await tester.ensureVisible(previewSend);
        await tester.pump();
        await tester.tap(previewSend);
        await tester.pump();
        expect(find.text('Hello there'), findsOneWidget);

        // Attachments: both pre-populated files render live.
        final Finder attachmentsComposer = find.byKey(
          const ValueKey<String>('agent-composer-attachments'),
        );
        expect(attachmentsComposer, findsOneWidget);
        expect(find.text('roadmap.md'), findsOneWidget);
        expect(find.text('cover.png'), findsOneWidget);

        // Commands: the palette opens because the controller starts with
        // '/', and both real commands render.
        expect(
          find.byKey(const ValueKey<String>('agent-composer-commands')),
          findsOneWidget,
        );
        // The row renders '/' + command.id (an RichText), with hint as a
        // plain caption line beneath it — not command.label, which this
        // particular row never reads. The hint is what a plain find.text
        // can safely match.
        expect(find.text('Summarize the conversation so far'), findsOneWidget);
        expect(find.text('Start a new conversation'), findsOneWidget);

        // Busy: a real stop button, and pressing it really flips busy off.
        final Finder busyComposer = find.byKey(
          const ValueKey<String>('agent-composer-busy'),
        );
        expect(busyComposer, findsOneWidget);
        final Finder busyStop = find.descendant(
          of: busyComposer,
          matching: _stopButton(),
        );
        expect(busyStop, findsOneWidget);
        await tester.ensureVisible(busyStop);
        await tester.pump();
        await tester.tap(busyStop);
        await tester.pump();
        expect(
          find.descendant(of: busyComposer, matching: _sendButton()),
          findsOneWidget,
          reason: 'onStop must flip busy back to false',
        );

        // Disabled: real disabled state, send stays unpressable regardless
        // of the pre-filled text.
        final Finder disabledComposer = find.byKey(
          const ValueKey<String>('agent-composer-disabled'),
        );
        expect(disabledComposer, findsOneWidget);
        expect(find.text('Waiting on the transport…'), findsOneWidget);
        expect(
          tester
              .widget<Button>(
                find.descendant(of: disabledComposer, matching: _sendButton()),
              )
              .onPressed,
          isNull,
        );

        // Accessory: the caller's slot content mounts where documented.
        expect(
          find.byKey(const ValueKey<String>('agent-composer-accessory-slot')),
          findsOneWidget,
        );

        // Dictation error: the real caption line renders.
        expect(
          find.text('The microphone could not be reached.'),
          findsOneWidget,
        );

        expect(agentComposerDoc.name, 'agent-composer');
        expect(agentComposerDoc.exports, <String>['AgentComposer']);
        expect(agentComposerDoc.command, 'elattar add agent-composer');
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
          child: const AgentComposerDocPage(),
        ),
      );
      await tester.pump();

      // Seven specimen stages: Preview, Attachments, Commands, Busy,
      // Disabled, Accessory, Dictation error.
      expect(find.byType(DocsShowcase), findsNWidgets(7));
      expect(find.byType(DocsInstall), findsOneWidget);
      expect(find.byType(DocsDisclosure), findsNWidgets(8));
    });

    test('the table of contents matches the declared sections', () {
      expect(
        agentComposerDocSpec.toc
            .map((DocsTocEntry entry) => entry.title)
            .toList(),
        <String>[
          'Preview',
          'Installation',
          'Usage',
          'Attachments',
          'Commands',
          'Busy',
          'Disabled',
          'Accessory',
          'Dictation error',
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
          child: const AgentComposerDocPage(),
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
        'Attachments',
        'Commands',
        'Busy',
        'Disabled',
        'Accessory',
        'Dictation error',
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
            child: const AgentComposerDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('agent-composer-doc-article')),
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
          _harness(controller: controller, child: const AgentComposerDocPage()),
        );
        await tester.pump();

        final ThemeTokens darkTheme = ThemeScope.of(
          tester.element(
            find.byKey(const ValueKey<String>('agent-composer-doc-article')),
          ),
        );

        controller.setMode(ColorMode.light);
        await tester.pump();

        final ThemeTokens lightTheme = ThemeScope.of(
          tester.element(
            find.byKey(const ValueKey<String>('agent-composer-doc-article')),
          ),
        );

        expect(lightTheme.background, isNot(darkTheme.background));
        expect(lightTheme.foreground, isNot(darkTheme.foreground));

        expect(find.byType(DocsShowcase), findsNWidgets(7));
        for (final String key in <String>[
          'agent-composer-preview',
          'agent-composer-attachments',
          'agent-composer-commands',
          'agent-composer-busy',
          'agent-composer-disabled',
          'agent-composer-accessory',
          'agent-composer-dictation-error',
        ]) {
          expect(find.byKey(ValueKey<String>(key)), findsOneWidget);
        }
      },
    );
  });
}
