/// Tests for `components_docs/agent_avatar/page.dart`'s [AgentAvatarDocPage]:
/// the agent-avatar component documentation page.
///
/// `agent-avatar` is a brand-new page — no `page.dart` existed for this
/// registry item before this file's counterpart. `ElCubeAvatar`'s own
/// constructor (`lib/src/components/agent_avatar.dart`) declares four named
/// parameters excluding `key`: `state`, `size`, `accent`, `speed`. The
/// API-completeness test below checks all four, plus every
/// `ElAgentAvatarSize` rung, appear in the `ElCubeAvatar` API table.
///
/// **No `pumpAndSettle` anywhere in this file.** `ElCubeAvatar` runs a bare
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
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness({
  required Widget child,
  required ElThemeController controller,
}) => ElTheme(
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

/// Every named constructor parameter `ElCubeAvatar`'s own class declares
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
      'renders the article, the full ElCubeAvatar API table, and a live '
      'specimen of every ElAgentState and ElAgentAvatarSize this page '
      'claims to show',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 4000);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        String? destination;
        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
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
        await tester.pump(ElDurations.jelly);

        for (final String param in _cubeAvatarConstructorParams) {
          expect(find.text(param), findsWidgets, reason: 'missing $param');
        }
        for (final ElAgentAvatarSize size in ElAgentAvatarSize.values) {
          expect(
            find.text(size.name),
            findsWidgets,
            reason: 'ElAgentAvatarSize.${size.name} missing from API table',
          );
        }
        // ElCubeScene's own table.
        for (final String param in <String>[
          'scene',
          'width',
          'elapsed',
          'frozen',
        ]) {
          expect(
            find.text(param),
            findsWidgets,
            reason: 'ElCubeScene.$param missing from API table',
          );
        }

        // A live ElCubeAvatar specimen of every ElAgentState value mounts
        // in the State Set section — this page's own promise, not just
        // prose.
        final Set<ElAgentState> mountedStates = tester
            .widgetList<ElCubeAvatar>(find.byType(ElCubeAvatar))
            .map((ElCubeAvatar avatar) => avatar.state)
            .toSet();
        expect(mountedStates, containsAll(ElAgentState.values));

        final Set<ElAgentAvatarSize> mountedSizes = tester
            .widgetList<ElCubeAvatar>(find.byType(ElCubeAvatar))
            .map((ElCubeAvatar avatar) => avatar.size)
            .toSet();
        expect(mountedSizes, containsAll(ElAgentAvatarSize.values));

        // Every state-set tile carries its own key.
        for (final ElAgentState state in ElAgentState.values) {
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
        final ElCubeAvatar defaultAccent = tester.widget<ElCubeAvatar>(
          find.descendant(
            of: find.byKey(
              const ValueKey<String>('agent-avatar-example:accent-default'),
            ),
            matching: find.byType(ElCubeAvatar),
          ),
        );
        expect(defaultAccent.accent, isNull);

        final ElCubeAvatar customAccent = tester.widget<ElCubeAvatar>(
          find.descendant(
            of: find.byKey(
              const ValueKey<String>('agent-avatar-example:accent-custom'),
            ),
            matching: find.byType(ElCubeAvatar),
          ),
        );
        expect(customAccent.accent, ElPalette.action);

        // The Speed example actually carries a non-default speed on the
        // second tile.
        final ElCubeAvatar fastSpeed = tester.widget<ElCubeAvatar>(
          find.descendant(
            of: find.byKey(
              const ValueKey<String>('agent-avatar-example:speed-fast'),
            ),
            matching: find.byType(ElCubeAvatar),
          ),
        );
        expect(fastSpeed.speed, 2.5);

        expect(agentAvatarDoc.name, 'agent_avatar');
        expect(
          agentAvatarDoc.exports,
          containsAll(<String>['ElCubeAvatar', 'ElAgentAvatarSize']),
        );
        expect(agentAvatarDoc.command, 'elattar add agent-avatar');
        expect(destination, isNull);
      },
    );

    testWidgets(
      'the page is declared, and every section is a kit component',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 6000);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
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
      },
    );

    test('the table of contents matches the declared sections', () {
      expect(
        agentAvatarDocSpec.toc.map((DocsTocEntry entry) => entry.title).toList(),
        _expectedSectionTitles,
      );
    });

    testWidgets(
      'sections render in the declared order, section for section',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 6000);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        final ElThemeController controller = ElThemeController(
          mode: ElThemeMode.dark,
        );
        await tester.pumpWidget(
          _harness(controller: controller, child: const AgentAvatarDocPage()),
        );
        await tester.pump();

        final List<String> titles = tester
            .widgetList<DocsSection>(find.byType(DocsSection))
            .map((DocsSection section) => section.title)
            .toList();

        expect(titles, _expectedSectionTitles);
      },
    );

    testWidgets(
      'renders at narrow width with the anchor strip instead of a rail',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(390, 4000);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
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

        final ElThemeController controller = ElThemeController(
          mode: ElThemeMode.dark,
        );
        await tester.pumpWidget(
          _harness(controller: controller, child: const AgentAvatarDocPage()),
        );
        await tester.pump();

        final ElThemeData darkTheme = ElTheme.of(
          tester.element(
            find.byKey(const ValueKey<String>('agent-avatar-doc-article')),
          ),
        );

        // Flip the SAME controller in place, never `pumpAndSettle`: the
        // idle cube's spin and every busy scene are genuinely looping.
        controller.setMode(ElThemeMode.light);
        await tester.pump();

        final ElThemeData lightTheme = ElTheme.of(
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

        final Set<ElAgentState> mountedStates = tester
            .widgetList<ElCubeAvatar>(find.byType(ElCubeAvatar))
            .map((ElCubeAvatar avatar) => avatar.state)
            .toSet();
        expect(mountedStates, containsAll(ElAgentState.values));
      },
    );
  });
}
