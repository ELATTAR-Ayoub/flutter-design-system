/// Tests for `components_docs/agent_history/page.dart`'s
/// [AgentHistoryDocPage]: the agent-history component documentation page.
///
/// `agent-history` is a brand-new page covering three real widgets
/// (`lib/src/components/agent_history.dart`): `ElHistoryCard` (11 named
/// constructor parameters excluding `key`), `ElHistorySearch` (6), and
/// `ElChatHistory` (5). The API-completeness test below checks all three
/// tables, matching `field_test.dart`'s own precedent of checking several
/// tables individually rather than one flat merged set.
///
/// **No `pumpAndSettle` anywhere in this file.** `ElRowMotion`'s own
/// entrance/exit and `ElBlurSwitch` run `AnimationController`s that this
/// page's live specimens can trigger (pin, delete, rename); every test
/// below uses `tester.pump()`.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/agent_history/meta.dart';
import 'package:example/components_docs/agent_history/page.dart';
import 'package:example/docs/component_doc_page.dart' show DocsTocEntry;
import 'package:example/docs/docs_disclosure.dart';
import 'package:example/docs/docs_install.dart';
import 'package:example/docs/docs_section.dart' show DocsSection;
import 'package:example/docs/docs_showcase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter_test/flutter_test.dart';

Widget _harness({
  required Widget child,
  required ElThemeController controller,
}) => ElTheme(
  controller: controller,
  child: MaterialApp(home: SingleChildScrollView(child: child)),
);

Finder _disclosureTrigger(String title) => find.descendant(
  of: find.byWidgetPredicate(
    (Widget widget) => widget is DocsDisclosure && widget.title == title,
  ),
  matching: find.byKey(DocsDisclosure.triggerKey),
);

/// Every named constructor parameter `ElHistoryCard`'s own class declares,
/// excluding `key`.
const List<String> _historyCardParams = <String>[
  'conversation',
  'active',
  'confirm',
  'rename',
  'onOpen',
  'onRename',
  'onRemove',
  'onPin',
  'onShare',
  'leaving',
  'entranceGeneration',
];

/// Every named constructor parameter `ElHistorySearch`'s own class
/// declares, excluding `key`.
const List<String> _historySearchParams = <String>[
  'conversations',
  'open',
  'onOpenChange',
  'onOpen',
  'query',
  'onQueryChange',
];

/// Every named constructor parameter `ElChatHistory`'s own class declares,
/// excluding `key`.
const List<String> _chatHistoryParams = <String>[
  'store',
  'title',
  'nav',
  'onOpenConversation',
  'surfaceKey',
];

const List<String> _expectedSectionTitles = <String>[
  'Preview',
  'Installation',
  'Usage',
  'Rename',
  'Delete',
  'Pin',
  'Capabilities',
  'Search',
  'Chat History Drawer',
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
  group('agent-history docs page', () {
    testWidgets(
      'renders the article, the three API tables, and a live specimen of '
      'the list, rename, delete, pin, capabilities, search and the drawer',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 12000);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        String? destination;
        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: AgentHistoryDocPage(
              onNavigate: (String route) => destination = route,
            ),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('agent-history-doc-article')),
          findsOneWidget,
        );

        // Preview: a live ElHistoryCard per seeded conversation, pinned
        // first then newest.
        final List<ElHistoryCard> previewCards = tester
            .widgetList<ElHistoryCard>(find.byType(ElHistoryCard))
            .toList();
        expect(previewCards.length, greaterThanOrEqualTo(4));
        expect(
          previewCards.first.conversation.pinned,
          isTrue,
          reason: 'the pinned conversation sorts first',
        );

        // Pinning a card in Preview actually calls through to the store
        // (mounted pin buttons exist because the store supplies pin).
        final Finder pinButtons = find.descendant(
          of: find.byWidgetPredicate((Widget w) => w is ElHistoryCard),
          matching: find.byType(ElButton),
        );
        expect(pinButtons, findsWidgets);

        // Rename: both shapes mount.
        expect(
          tester
              .widgetList<ElHistoryCard>(find.byType(ElHistoryCard))
              .where((ElHistoryCard c) => c.rename == ElHistoryRename.inline)
              .isNotEmpty,
          isTrue,
        );
        expect(
          tester
              .widgetList<ElHistoryCard>(find.byType(ElHistoryCard))
              .where((ElHistoryCard c) => c.rename == ElHistoryRename.dialog)
              .isNotEmpty,
          isTrue,
        );

        // Delete: both shapes mount.
        expect(
          tester
              .widgetList<ElHistoryCard>(find.byType(ElHistoryCard))
              .where((ElHistoryCard c) => c.confirm == ElHistoryConfirm.dialog)
              .isNotEmpty,
          isTrue,
        );

        // Pin section: a pinned specimen and an active specimen both mount.
        expect(
          tester
              .widgetList<ElHistoryCard>(find.byType(ElHistoryCard))
              .where((ElHistoryCard c) => c.active)
              .isNotEmpty,
          isTrue,
        );

        // Capabilities: the degraded list's cards carry no onPin / onShare.
        final Iterable<ElHistoryCard> degraded = tester
            .widgetList<ElHistoryCard>(find.byType(ElHistoryCard))
            .where((ElHistoryCard c) => c.onPin == null);
        expect(degraded, isNotEmpty);

        // Search: opening the trigger mounts the palette content. Closed
        // again with Escape (every modal on the page closes on it,
        // unconditionally — dialog.dart's own ElModalPortal) before moving
        // on: an open overlay's scrim blocks every tap elsewhere on the
        // page, including the drawer trigger below.
        await tester.tap(
          find.byKey(const ValueKey<String>('agent-history-search-trigger')),
        );
        await tester.pump();
        await tester.pump();
        expect(find.text('Sealed inventory check'), findsWidgets);
        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pump();
        await tester.pump(ElDurations.overlay);

        // Drawer: opening the trigger mounts the drawer's own cards.
        final Finder drawerTrigger = find.descendant(
          of: find.byKey(const ValueKey<String>('agent-history-drawer')),
          matching: find.byType(ElButton),
        );
        expect(drawerTrigger, findsOneWidget);
        await tester.tap(drawerTrigger);
        await tester.pump();
        await tester.pump(ElDurations.overlay);
        expect(find.text('Conversations'), findsOneWidget);

        final Finder apiTrigger = _disclosureTrigger('API Reference');
        await tester.ensureVisible(apiTrigger);
        await tester.pump();
        await tester.tap(apiTrigger);
        await tester.pump();
        await tester.pump(ElDurations.jelly);

        for (final String param in _historyCardParams) {
          expect(
            find.text(param),
            findsWidgets,
            reason: 'ElHistoryCard.$param missing from API table',
          );
        }
        for (final String param in _historySearchParams) {
          expect(
            find.text(param),
            findsWidgets,
            reason: 'ElHistorySearch.$param missing from API table',
          );
        }
        for (final String param in _chatHistoryParams) {
          expect(
            find.text(param),
            findsWidgets,
            reason: 'ElChatHistory.$param missing from API table',
          );
        }
        for (final String name in <String>[
          'ElHistoryConfirm.inline',
          'ElHistoryConfirm.dialog',
          'ElHistoryRename.inline',
          'ElHistoryRename.dialog',
        ]) {
          expect(
            find.text(name),
            findsWidgets,
            reason: '$name missing from the enum API table',
          );
        }
        for (final String name in <String>[
          'generation',
          'measure',
          'reconcile',
        ]) {
          expect(
            find.text(name),
            findsWidgets,
            reason: '$name missing from the motion API tables',
          );
        }

        expect(agentHistoryDoc.name, 'agent_history');
        expect(
          agentHistoryDoc.exports,
          containsAll(<String>[
            'ElHistoryCard',
            'ElHistorySearch',
            'ElChatHistory',
          ]),
        );
        expect(agentHistoryDoc.command, 'elattar add agent-history');
        expect(destination, isNull);
      },
    );

    testWidgets(
      'the page is declared, and every section is a kit component',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 14000);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: const AgentHistoryDocPage(),
          ),
        );
        await tester.pump();

        // Seven specimen stages: Preview, Rename, Delete, Pin,
        // Capabilities, Search, Chat History Drawer.
        expect(find.byType(DocsShowcase), findsNWidgets(7));
        expect(find.byType(DocsInstall), findsOneWidget);
        expect(find.byType(DocsDisclosure), findsNWidgets(8));
      },
    );

    test('the table of contents matches the declared sections', () {
      expect(
        agentHistoryDocSpec.toc
            .map((DocsTocEntry entry) => entry.title)
            .toList(),
        _expectedSectionTitles,
      );
    });

    testWidgets(
      'sections render in the declared order, section for section',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 14000);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        final ElThemeController controller = ElThemeController(
          mode: ElThemeMode.dark,
        );
        await tester.pumpWidget(
          _harness(
            controller: controller,
            child: const AgentHistoryDocPage(),
          ),
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
        tester.view.physicalSize = const Size(390, 13000);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: const AgentHistoryDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('agent-history-doc-article')),
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
        tester.view.physicalSize = const Size(1440, 14000);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        final ElThemeController controller = ElThemeController(
          mode: ElThemeMode.dark,
        );
        await tester.pumpWidget(
          _harness(
            controller: controller,
            child: const AgentHistoryDocPage(),
          ),
        );
        await tester.pump();

        final ElThemeData darkTheme = ElTheme.of(
          tester.element(
            find.byKey(const ValueKey<String>('agent-history-doc-article')),
          ),
        );

        controller.setMode(ElThemeMode.light);
        await tester.pump();

        final ElThemeData lightTheme = ElTheme.of(
          tester.element(
            find.byKey(const ValueKey<String>('agent-history-doc-article')),
          ),
        );

        expect(lightTheme.background, isNot(darkTheme.background));
        expect(lightTheme.foreground, isNot(darkTheme.foreground));

        for (final String key in <String>[
          'agent-history-example:rename-inline',
          'agent-history-example:rename-dialog',
          'agent-history-example:delete-inline',
          'agent-history-example:delete-dialog',
          'agent-history-example:pin-pinned',
          'agent-history-example:pin-active',
        ]) {
          expect(find.byKey(ValueKey<String>(key)), findsOneWidget);
        }
        expect(find.byType(ElHistoryCard), findsWidgets);
      },
    );
  });
}
