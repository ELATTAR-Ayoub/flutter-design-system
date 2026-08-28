/// Tests for `components_docs/agent_face/page.dart`'s [AgentFaceDocPage]:
/// the agent-face component documentation page.
///
/// `agent-face` is a brand-new page. `AgentFace`'s own constructor
/// (`lib/src/components/agent_face.dart`) declares six named parameters
/// excluding `key`: `state`, `voice`, `avatar`, `size`, `accent`, `speed`.
/// The API-completeness test below checks all six appear in the
/// `AgentFace` API table.
///
/// **No `pumpAndSettle` anywhere in this file.** The renderer this page
/// defaults to (`AgentAvatar`) runs a bare `Ticker`; the "live" status
/// line specimens shimmer on an infinite `KeyframePlayer`. Every test
/// below uses `tester.pump()`.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/agent_face/meta.dart';
import 'package:example/components_docs/agent_face/page.dart';
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

/// Every named constructor parameter `AgentFace`'s own class declares
/// (`lib/src/components/agent_face.dart`), excluding `key`.
const List<String> _agentFaceConstructorParams = <String>[
  'state',
  'voice',
  'avatar',
  'size',
  'accent',
  'speed',
];

const List<String> _expectedSectionTitles = <String>[
  'Preview',
  'Installation',
  'Usage',
  'Voice',
  'Status Line',
  'Custom Renderer',
  'API Reference',
  'States',
  'Accessibility',
  'Keyboard',
  'Responsive',
  'Dependencies',
  'Theming',
  'Source',
];

void main() {
  group('agent-face docs page', () {
    testWidgets('renders the article, the full AgentFace API table, and a live '
        'specimen of the avatar path, the voice path, and a custom renderer', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 4000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      String? destination;
      await tester.pumpWidget(
        _harness(
          controller: ThemeController(mode: ColorMode.dark),
          child: AgentFaceDocPage(
            onNavigate: (String route) => destination = route,
          ),
        ),
      );
      await tester.pump();

      expect(
        find.byKey(const ValueKey<String>('agent-face-doc-article')),
        findsOneWidget,
      );

      final Finder apiTrigger = _disclosureTrigger('API Reference');
      await tester.ensureVisible(apiTrigger);
      await tester.pump();
      await tester.tap(apiTrigger);
      await tester.pump();
      await tester.pump(MotionDurations.open);

      for (final String param in _agentFaceConstructorParams) {
        expect(find.text(param), findsWidgets, reason: 'missing $param');
      }
      // AgentVoice's own table.
      for (final String param in <String>[
        'listening',
        'speaking',
        'samples',
        'spectrum',
        'level',
      ]) {
        expect(
          find.text(param),
          findsWidgets,
          reason: 'AgentVoice.$param missing from API table',
        );
      }
      // AgentStatusLine's own table.
      for (final String param in <String>['gap', 'waveformBox', 'barsBox']) {
        expect(
          find.text(param),
          findsWidgets,
          reason: 'AgentStatusLine.$param missing from API table',
        );
      }
      // AgentAvatarRegistry's own table.
      for (final String param in <String>['renderer', 'orb', 'waveform']) {
        expect(
          find.text(param),
          findsWidgets,
          reason: 'AgentAvatarRegistry.$param missing from API table',
        );
      }

      // The Voice section shows AgentFace at rest, listening, and
      // speaking — three live specimens, not just prose.
      expect(
        find.byKey(const ValueKey<String>('agent-face-example:voice-rest')),
        findsOneWidget,
      );
      final AgentFace listening = tester.widget<AgentFace>(
        find.descendant(
          of: find.byKey(
            const ValueKey<String>('agent-face-example:voice-listening'),
          ),
          matching: find.byType(AgentFace),
        ),
      );
      expect(listening.voice.listening, isTrue);
      expect(listening.voice.isActive, isTrue);

      final AgentFace speaking = tester.widget<AgentFace>(
        find.descendant(
          of: find.byKey(
            const ValueKey<String>('agent-face-example:voice-speaking'),
          ),
          matching: find.byType(AgentFace),
        ),
      );
      expect(speaking.voice.speaking, isTrue);

      // The Custom Renderer section actually swaps the renderer: the
      // second tile's AgentFace carries a non-null avatar builder, the
      // first's does not.
      final AgentFace defaultRenderer = tester.widget<AgentFace>(
        find.descendant(
          of: find.byKey(
            const ValueKey<String>('agent-face-example:renderer-default'),
          ),
          matching: find.byType(AgentFace),
        ),
      );
      expect(defaultRenderer.avatar, isNull);

      final AgentFace customRenderer = tester.widget<AgentFace>(
        find.descendant(
          of: find.byKey(
            const ValueKey<String>('agent-face-example:renderer-custom'),
          ),
          matching: find.byType(AgentFace),
        ),
      );
      expect(customRenderer.avatar, isNotNull);

      // The Status Line section shows all four branches: idle (still),
      // thinking (shimmering), listening (waveform), speaking (bars).
      for (final String key in <String>[
        'agent-face-example:status-idle',
        'agent-face-example:status-thinking',
        'agent-face-example:status-listening',
        'agent-face-example:status-speaking',
      ]) {
        expect(find.byKey(ValueKey<String>(key)), findsOneWidget);
      }
      expect(find.byType(LiveWaveform), findsOneWidget);
      expect(find.byType(BarVisualizer), findsOneWidget);

      expect(agentFaceDoc.name, 'agent_face');
      expect(agentFaceDoc.exports, contains('AgentFace'));
      expect(agentFaceDoc.command, 'elattar add agent-face');
      expect(destination, isNull);
    });

    testWidgets('the page is declared, and every section is a kit component', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 5000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _harness(
          controller: ThemeController(mode: ColorMode.dark),
          child: const AgentFaceDocPage(),
        ),
      );
      await tester.pump();

      // Four specimen stages: Preview, Voice, Status Line, Custom
      // Renderer.
      expect(find.byType(DocsShowcase), findsNWidgets(4));
      expect(find.byType(DocsInstall), findsOneWidget);
      expect(find.byType(DocsDisclosure), findsNWidgets(8));
    });

    test('the table of contents matches the declared sections', () {
      expect(
        agentFaceDocSpec.toc.map((DocsTocEntry entry) => entry.title).toList(),
        _expectedSectionTitles,
      );
    });

    testWidgets('sections render in the declared order, section for section', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 5000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final ThemeController controller = ThemeController(mode: ColorMode.dark);
      await tester.pumpWidget(
        _harness(controller: controller, child: const AgentFaceDocPage()),
      );
      await tester.pump();

      final List<String> titles = tester
          .widgetList<DocsSection>(find.byType(DocsSection))
          .map((DocsSection section) => section.title)
          .toList();

      expect(titles, _expectedSectionTitles);
    });

    testWidgets(
      'renders at narrow width with the anchor strip instead of a rail',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(390, 4000);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ThemeController(mode: ColorMode.dark),
            child: const AgentFaceDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('agent-face-doc-article')),
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
      'losing any example specimen',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 5000);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        final ThemeController controller = ThemeController(
          mode: ColorMode.dark,
        );
        await tester.pumpWidget(
          _harness(controller: controller, child: const AgentFaceDocPage()),
        );
        await tester.pump();

        final ThemeTokens darkTheme = ThemeScope.of(
          tester.element(
            find.byKey(const ValueKey<String>('agent-face-doc-article')),
          ),
        );

        controller.setMode(ColorMode.light);
        await tester.pump();

        final ThemeTokens lightTheme = ThemeScope.of(
          tester.element(
            find.byKey(const ValueKey<String>('agent-face-doc-article')),
          ),
        );

        expect(lightTheme.background, isNot(darkTheme.background));
        expect(lightTheme.foreground, isNot(darkTheme.foreground));

        for (final String key in <String>[
          'agent-face-example:voice-rest',
          'agent-face-example:voice-listening',
          'agent-face-example:voice-speaking',
          'agent-face-example:status-idle',
          'agent-face-example:status-thinking',
          'agent-face-example:status-listening',
          'agent-face-example:status-speaking',
          'agent-face-example:renderer-default',
          'agent-face-example:renderer-custom',
        ]) {
          expect(find.byKey(ValueKey<String>(key)), findsOneWidget);
        }
      },
    );
  });
}
