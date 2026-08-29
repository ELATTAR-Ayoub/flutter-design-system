/// Tests for `components_docs/agent_launcher/page.dart`'s
/// [AgentLauncherDocPage]: the agent-launcher component documentation page.
///
/// `agent-launcher` is a brand-new page. `AgentLauncher`'s own
/// constructor (`lib/src/components/ui/agent_launcher.dart`) declares five
/// named parameters excluding `key`: `label`, `title`, `description`,
/// `child`, `avatar`. The API-completeness test below checks all five
/// appear in the `AgentLauncher` API table.
///
/// **No `pumpAndSettle` anywhere in this file.** The trigger's own face
/// defaults to `AgentAvatar`, which runs a bare `Ticker`. Every test below
/// uses `tester.pump()` and `tester.pump(duration)` for the dialog's own
/// jelly transition.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/agent_launcher/meta.dart';
import 'package:example/components_docs/agent_launcher/page.dart';
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

/// Every named constructor parameter `AgentLauncher`'s own class declares
/// (`lib/src/components/ui/agent_launcher.dart`), excluding `key`.
const List<String> _launcherConstructorParams = <String>[
  'label',
  'title',
  'description',
  'child',
  'avatar',
];

const List<String> _expectedSectionTitles = <String>[
  'Preview',
  'Installation',
  'Usage',
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
  group('agent-launcher docs page', () {
    testWidgets(
      'renders the article, the full AgentLauncher API table, and opens '
      'the dialog when the preview trigger is tapped',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 3000);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        String? destination;
        await tester.pumpWidget(
          _harness(
            controller: ThemeController(mode: ColorMode.dark),
            child: AgentLauncherDocPage(
              onNavigate: (String route) => destination = route,
            ),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('agent-launcher-doc-article')),
          findsOneWidget,
        );

        // One live AgentLauncher instance, its avatar swapped by a
        // toggle rather than by a second instance: two fixed-position
        // launchers would pin to the exact same corner.
        expect(find.byType(AgentLauncher), findsOneWidget);

        AgentLauncher preview() => tester.widget<AgentLauncher>(
          find.byKey(const ValueKey<String>('agent-launcher-preview')),
        );
        expect(preview().label, 'Ask the assistant');
        expect(preview().title, 'Vault');
        expect(preview().avatar, isNull);

        // The custom-renderer toggle actually swaps AgentLauncher.avatar.
        await tester.tap(
          find.byKey(
            const ValueKey<String>('agent-launcher-preview-toggle-custom'),
          ),
        );
        await tester.pump();
        expect(preview().avatar, isNotNull);

        await tester.tap(
          find.byKey(
            const ValueKey<String>('agent-launcher-preview-toggle-default'),
          ),
        );
        await tester.pump();
        expect(preview().avatar, isNull);

        final Finder apiTrigger = _disclosureTrigger('API Reference');
        await tester.ensureVisible(apiTrigger);
        await tester.pump();
        await tester.tap(apiTrigger);
        await tester.pump();
        await tester.pump(MotionDurations.open);

        for (final String param in _launcherConstructorParams) {
          expect(find.text(param), findsWidgets, reason: 'missing $param');
        }
        for (final String staticName in <String>[
          'size',
          'inset',
          'labelGap',
          'labelRest',
          'labelPadding',
          'hoverRimAlpha',
          'dialogViewportFraction',
          'dialogMinFraction',
          'dialogMaxWidth',
          'dialogHeightFraction',
          'dialogMaxHeight',
          'dialogSize',
        ]) {
          expect(
            find.text(staticName),
            findsWidgets,
            reason: 'AgentLauncher.$staticName missing from API table',
          );
        }

        // Tapping the preview trigger opens the dialog and shows its own
        // placeholder child. Done last: the dialog stays open and covers
        // the rest of the page, so nothing else can be tapped after it.
        final Finder previewButton = find.descendant(
          of: find.byKey(const ValueKey<String>('agent-launcher-preview')),
          matching: find.byType(Button),
        );
        expect(previewButton, findsOneWidget);
        await tester.tap(previewButton);
        await tester.pump();
        await tester.pump(MotionDurations.open);

        expect(
          find.byKey(const ValueKey<String>('agent-launcher-preview-child')),
          findsOneWidget,
        );

        expect(agentLauncherDoc.name, 'agent_launcher');
        expect(agentLauncherDoc.exports, <String>['AgentLauncher']);
        expect(agentLauncherDoc.command, 'elattar add agent-launcher');
        expect(destination, isNull);
      },
    );

    testWidgets('the page is declared, and every section is a kit component', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 3500);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _harness(
          controller: ThemeController(mode: ColorMode.dark),
          child: const AgentLauncherDocPage(),
        ),
      );
      await tester.pump();

      // One specimen stage: Preview.
      expect(find.byType(DocsShowcase), findsNWidgets(1));
      expect(find.byType(DocsInstall), findsOneWidget);
      expect(find.byType(DocsDisclosure), findsNWidgets(8));
    });

    test('the table of contents matches the declared sections', () {
      expect(
        agentLauncherDocSpec.toc
            .map((DocsTocEntry entry) => entry.title)
            .toList(),
        _expectedSectionTitles,
      );
    });

    testWidgets('sections render in the declared order, section for section', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 3500);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final ThemeController controller = ThemeController(mode: ColorMode.dark);
      await tester.pumpWidget(
        _harness(controller: controller, child: const AgentLauncherDocPage()),
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
        tester.view.physicalSize = const Size(390, 3200);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ThemeController(mode: ColorMode.dark),
            child: const AgentLauncherDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('agent-launcher-doc-article')),
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
      'losing the launcher specimen',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 3500);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        final ThemeController controller = ThemeController(
          mode: ColorMode.dark,
        );
        await tester.pumpWidget(
          _harness(controller: controller, child: const AgentLauncherDocPage()),
        );
        await tester.pump();

        final ThemeTokens darkTheme = ThemeScope.of(
          tester.element(
            find.byKey(const ValueKey<String>('agent-launcher-doc-article')),
          ),
        );

        controller.setMode(ColorMode.light);
        await tester.pump();

        final ThemeTokens lightTheme = ThemeScope.of(
          tester.element(
            find.byKey(const ValueKey<String>('agent-launcher-doc-article')),
          ),
        );

        expect(lightTheme.background, isNot(darkTheme.background));
        expect(lightTheme.foreground, isNot(darkTheme.foreground));

        expect(
          find.byKey(const ValueKey<String>('agent-launcher-preview')),
          findsOneWidget,
        );
      },
    );
  });
}
