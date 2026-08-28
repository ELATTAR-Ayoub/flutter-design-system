/// Tests for `components_docs/agent_avatar/page.dart`'s [AgentAvatarDocPage]:
/// the agent-avatar component documentation page.
///
/// `agent-avatar` is a brand-new page — no `page.dart` existed for this
/// registry item before this file's counterpart. `AgentAvatar`'s own
/// constructor (`lib/src/components/agent_avatar.dart`) declares four named
/// parameters excluding `key`: `state`, `size`, `accent`, `speed`. The
/// API-completeness test below checks all four, plus every
/// `AgentAvatarSize` rung, appear in the `AgentAvatar` API table.
///
/// **No `pumpAndSettle` anywhere in this file.** `AgentAvatar` runs a bare
/// `Ticker` off a state's own scene recipe and the idle cube spins on a 9s
/// `repeat`-shaped clock forever; settling on either would time out rather
/// than fail. Every test below uses `tester.pump()` (and, where a widget's
/// own transition needs to finish, `tester.pump(duration)`).
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never synthetic `MediaQuery`.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/agent_avatar/meta.dart';
import 'package:example/components_docs/agent_avatar/page.dart';
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

/// The single `DocsDisclosure` whose title is [title] — see
/// `button_test.dart`'s own note on why this narrows past
/// `DocsDisclosure.triggerKey` alone.
Finder _disclosureTrigger(String title) => find.descendant(
  of: find.byWidgetPredicate(
    (Widget widget) => widget is DocsDisclosure && widget.title == title,
  ),
  matching: find.byKey(DocsDisclosure.triggerKey),
);

/// Every named constructor parameter `AgentAvatar`'s own class declares
/// (`lib/src/components/agent_avatar.dart`), excluding `key`.
const List<String> _cubeAvatarConstructorParams = <String>[
  'state',
  'size',
  'accent',
  'speed',
];

const List<String> _expectedSectionTitles = <String>[
  'Preview',
  'Installation',
  'Usage',
  'State Set',
  'Sizes',
  'Accent',
  'Speed',
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
  group('agent-avatar docs page', () {
    testWidgets(
      'renders the article, the full AgentAvatar API table, and a live '
      'specimen of every AgentState and AgentAvatarSize this page '
      'claims to show',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 4000);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        String? destination;
        await tester.pumpWidget(
          _harness(
            controller: ThemeController(mode: ColorMode.dark),
            child: AgentAvatarDocPage(
              onNavigate: (String route) => destination = route,
            ),
          ),
        );
        // One frame is enough: nothing on this page may ever be settled on,
        // the idle cube spins forever and every working state loops its own
        // scene.
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('agent-avatar-doc-article')),
          findsOneWidget,
        );

        final Finder apiTrigger = _disclosureTrigger('API Reference');
        await tester.ensureVisible(apiTrigger);
        await tester.pump();
        await tester.tap(apiTrigger);
        await tester.pump();
        await tester.pump(MotionDurations.open);

        for (final String param in _cubeAvatarConstructorParams) {
          expect(find.text(param), findsWidgets, reason: 'missing $param');
        }
        for (final AgentAvatarSize size in AgentAvatarSize.values) {
          expect(
            find.text(size.name),
            findsWidgets,
            reason: 'AgentAvatarSize.${size.name} missing from API table',
          );
        }
        // CubeScene's own table.
        for (final String param in <String>[
          'scene',
          'width',
          'elapsed',
          'frozen',
        ]) {
          expect(
            find.text(param),
            findsWidgets,
            reason: 'CubeScene.$param missing from API table',
          );
        }

        // A live AgentAvatar specimen of every AgentState value mounts
        // in the State Set section — this page's own promise, not just
        // prose.
        final Set<AgentState> mountedStates = tester
            .widgetList<AgentAvatar>(find.byType(AgentAvatar))
            .map((AgentAvatar avatar) => avatar.state)
            .toSet();
        expect(mountedStates, containsAll(AgentState.values));

        final Set<AgentAvatarSize> mountedSizes = tester
            .widgetList<AgentAvatar>(find.byType(AgentAvatar))
            .map((AgentAvatar avatar) => avatar.size)
            .toSet();
        expect(mountedSizes, containsAll(AgentAvatarSize.values));

        // Every state-set tile carries its own key.
        for (final AgentState state in AgentState.values) {
          expect(
            find.byKey(
              ValueKey<String>('agent-avatar-example:state-${state.name}'),
            ),
            findsOneWidget,
            reason: 'missing state-set tile for ${state.name}',
          );
        }

        // The Accent example actually carries a non-null override on the
        // second tile and the default (null) on the first.
        final AgentAvatar defaultAccent = tester.widget<AgentAvatar>(
          find.descendant(
            of: find.byKey(
              const ValueKey<String>('agent-avatar-example:accent-default'),
            ),
            matching: find.byType(AgentAvatar),
          ),
        );
        expect(defaultAccent.accent, isNull);

        final AgentAvatar customAccent = tester.widget<AgentAvatar>(
          find.descendant(
            of: find.byKey(
              const ValueKey<String>('agent-avatar-example:accent-custom'),
            ),
            matching: find.byType(AgentAvatar),
          ),
        );
        expect(customAccent.accent, Palette.action);

        // The Speed example actually carries a non-default speed on the
        // second tile.
        final AgentAvatar fastSpeed = tester.widget<AgentAvatar>(
          find.descendant(
            of: find.byKey(
              const ValueKey<String>('agent-avatar-example:speed-fast'),
            ),
            matching: find.byType(AgentAvatar),
          ),
        );
        expect(fastSpeed.speed, 2.5);

        expect(agentAvatarDoc.name, 'agent_avatar');
        expect(
          agentAvatarDoc.exports,
          containsAll(<String>['AgentAvatar', 'AgentAvatarSize']),
        );
        expect(agentAvatarDoc.command, 'elattar add agent-avatar');
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
          child: const AgentAvatarDocPage(),
        ),
      );
      await tester.pump();

      // Five specimen stages: Preview, State Set, Sizes, Accent, Speed.
      expect(find.byType(DocsShowcase), findsNWidgets(5));
      expect(find.byType(DocsInstall), findsOneWidget);
      // Eight collapsed sections: API Reference, States, Accessibility,
      // Keyboard, Responsive, Dependencies, Theming, Source.
      expect(find.byType(DocsDisclosure), findsNWidgets(8));
    });

    test('the table of contents matches the declared sections', () {
      expect(
        agentAvatarDocSpec.toc
            .map((DocsTocEntry entry) => entry.title)
            .toList(),
        _expectedSectionTitles,
      );
    });

    testWidgets('sections render in the declared order, section for section', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 6000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final ThemeController controller = ThemeController(mode: ColorMode.dark);
      await tester.pumpWidget(
        _harness(controller: controller, child: const AgentAvatarDocPage()),
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
            child: const AgentAvatarDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('agent-avatar-doc-article')),
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
        tester.view.physicalSize = const Size(1440, 6000);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        final ThemeController controller = ThemeController(
          mode: ColorMode.dark,
        );
        await tester.pumpWidget(
          _harness(controller: controller, child: const AgentAvatarDocPage()),
        );
        await tester.pump();

        final ThemeTokens darkTheme = ThemeScope.of(
          tester.element(
            find.byKey(const ValueKey<String>('agent-avatar-doc-article')),
          ),
        );

        // Flip the SAME controller in place, never `pumpAndSettle`: the
        // idle cube's spin and every busy scene are genuinely looping.
        controller.setMode(ColorMode.light);
        await tester.pump();

        final ThemeTokens lightTheme = ThemeScope.of(
          tester.element(
            find.byKey(const ValueKey<String>('agent-avatar-doc-article')),
          ),
        );

        expect(lightTheme.background, isNot(darkTheme.background));
        expect(lightTheme.foreground, isNot(darkTheme.foreground));

        for (final String key in <String>[
          'agent-avatar-example:size-sm',
          'agent-avatar-example:size-md',
          'agent-avatar-example:size-lg',
          'agent-avatar-example:size-xl',
          'agent-avatar-example:accent-default',
          'agent-avatar-example:accent-custom',
          'agent-avatar-example:speed-default',
          'agent-avatar-example:speed-fast',
        ]) {
          expect(find.byKey(ValueKey<String>(key)), findsOneWidget);
        }

        final Set<AgentState> mountedStates = tester
            .widgetList<AgentAvatar>(find.byType(AgentAvatar))
            .map((AgentAvatar avatar) => avatar.state)
            .toSet();
        expect(mountedStates, containsAll(AgentState.values));
      },
    );
  });
}
