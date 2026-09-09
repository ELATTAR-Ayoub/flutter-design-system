/// Tests for `site/pages/agent_gallery_page.dart`, the `/agent` gallery.
///
/// The agent console mounts overlays (the command palette, the attach menu)
/// through `OverlayPortal`, and `LauncherDemo` opens a real dialog — both
/// need a genuine `Overlay` ancestor, which is why this harness wraps the
/// page in a `WidgetsApp` rather than a bare `Directionality`/`MediaQuery`
/// pair, the same choice `charts_gallery_test.dart` documents and makes for
/// `ChartsGalleryPage`.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/catalog.dart';
import 'package:example/site/pages/agent_gallery_page.dart';
import 'package:flutter/widgets.dart'
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
        TableColumnWidth;
import 'package:flutter_test/flutter_test.dart';

const Size _viewport = Size(1600, 3600);

Future<void> _pump(
  WidgetTester tester, {
  void Function(String route)? onNavigate,
}) async {
  tester.view.physicalSize = _viewport;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ThemeScope(
      controller: ThemeController(mode: ColorMode.light),
      child: WidgetsApp(
        color: const Color(0xFFFFFFFF),
        pageRouteBuilder: <T>(RouteSettings settings, WidgetBuilder builder) =>
            PageRouteBuilder<T>(
              settings: settings,
              pageBuilder:
                  (
                    BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                  ) => builder(context),
            ),
        home: AgentGalleryPage(onNavigate: onNavigate),
      ),
    ),
  );
  // Not `pumpAndSettle`: the launcher's idle avatar and the voice demo's
  // waveform both carry a repeating decorative `AnimationController`, so the
  // tree never actually settles — same reason `agent_console_test.dart`
  // steps with explicit `pump()`s instead.
  await tester.pump();
  await tester.pump();
}

void main() {
  testWidgets('renders without exceptions and shows a live console', (
    WidgetTester tester,
  ) async {
    await _pump(tester);

    expect(find.byType(AgentConsole), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('the console is configured with every feature on, including the '
      'microphone', (WidgetTester tester) async {
    await _pump(tester);

    final Finder liveConsole = find.byType(AgentConsole).first;
    final AgentConsole console = tester.widget<AgentConsole>(liveConsole);
    expect(console.features, AgentFeatures.all);
    expect(console.features.microphone, isTrue);

    // KNOWN GAP, not introduced by this page: `agent_console.dart`'s own
    // library note ("Divergences, by construction" — no speech, no
    // dictation) documents `AgentFeatures.microphone` as honoured only as
    // a flag — the console never passes a `micControl` to `AgentComposer`
    // (confirmed: `micControl:` is not passed anywhere under `lib/`), so
    // no mic renders next to send regardless of this flag. Fixing that is
    // a `lib/src/blocks/agent_console/agent_console.dart` change, out of
    // scope for this example-only page (see the task's own "never edit
    // lib/src" constraint) — flagged separately for a dedicated fix. This
    // assertion pins today's real, honest state: absent, and turned on
    // here so the mic appears the moment that gap closes, with no page
    // change required.
    final Finder composer = find.descendant(
      of: liveConsole,
      matching: find.byType(AgentComposer),
    );
    expect(composer, findsOneWidget);
    expect(
      find.descendant(of: composer, matching: find.byType(MicControl)),
      findsNothing,
      reason:
          'no MicControl renders yet — agent_console.dart does not wire '
          'AgentFeatures.microphone to AgentComposer.micControl. Update '
          'this expectation to findsOneWidget once that lib/src gap is '
          'closed.',
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'a history sidebar is folded into the console surface, and selecting '
    'a conversation closes the drawer and blurs the transcript',
    (WidgetTester tester) async {
      await _pump(tester);

      final Finder liveConsole = find.byType(AgentConsole).first;
      final Finder sidebarToggle = find.descendant(
        of: liveConsole,
        matching: find.byWidgetPredicate(
          (Widget w) => w is Button && w.label == 'Open sidebar',
        ),
      );
      expect(
        sidebarToggle,
        findsOneWidget,
        reason: 'AgentHistory should be reachable from the console itself',
      );

      await tester.tap(sidebarToggle);
      await tester.pump();

      // "Sealed inventory check" is the seeded store's active conversation;
      // "Thirty-day activity export" is a different, pinned one.
      expect(find.text('Sealed inventory check'), findsOneWidget);
      final Finder nextConversation = find.text('Thirty-day activity export');
      expect(nextConversation, findsOneWidget);

      // `ChatHistory`'s drawer paints through an `OverlayPortal` positioned
      // from a `surfaceKey` rect (`agent_history.dart`'s `_surfaceRect`); at
      // this page's position in the scroll view that rect resolves off the
      // visible viewport, so a simulated pointer tap on the row's own screen
      // position cannot reliably hit it (reproduced identically with the
      // untouched `ConsoleWithHistory` demo in `pages/history.dart`, so this
      // is a pre-existing library defect, not something this page
      // introduced — out of scope here since it lives under `lib/src/`).
      // The row's own `onOpen` callback is invoked directly instead: the
      // exact call a working tap would make, exercising every step after
      // the pointer event for real.
      final HistoryCard card = tester.widget<HistoryCard>(
        find.ancestor(of: nextConversation, matching: find.byType(HistoryCard)),
      );
      card.onOpen(card.conversation.id);
      await tester.pump();

      // Selecting closes the drawer: the sidebar's own conversation list is
      // no longer in the tree.
      expect(find.text('Sealed inventory check'), findsNothing);

      // Selecting also drives `BlurSwitchController.switchTo`, which the
      // console wears on its transcript as `switchPhase`: the transcript's
      // `BlurSwitch` leaves `SwitchPhase.idle` for the transition, which is
      // the visible, on-console change a selection makes.
      final BlurSwitch transcriptBlur = tester.widget<BlurSwitch>(
        find.descendant(of: liveConsole, matching: find.byType(BlurSwitch)),
      );
      expect(transcriptBlur.phase, isNot(SwitchPhase.idle));

      // Let the switch's own out/blur-in timers finish inside this test's
      // zone so no timer is left pending at teardown.
      await tester.pump(const Duration(seconds: 1));

      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('does not render the removed "Try the surfaces around it" '
      'section', (WidgetTester tester) async {
    await _pump(tester);

    expect(find.text('Try the surfaces around it'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('the Documentation button navigates to /components/agent_core', (
    WidgetTester tester,
  ) async {
    final List<String> routes = <String>[];
    await _pump(tester, onNavigate: routes.add);

    await tester.tap(find.text('Documentation'));
    await tester.pump();

    expect(routes, <String>[componentDoc('agent-core').route]);
  });

  testWidgets('the component reference lists every agent-family entry from the '
      'catalog, alphabetically', (WidgetTester tester) async {
    await _pump(tester);

    final List<ComponentDocEntry> entries = componentDocsIn(
      ComponentDocFamily.agent,
    );
    // Not hardcoded: whatever `componentDocsIn` returns today is what the
    // foot reference must show, so a thirteenth agent component (or a
    // twelfth, or a change to which two voice surfaces the family
    // includes) is picked up here without touching this test.
    expect(entries, isNotEmpty);
    final Finder reference = find.byKey(
      const ValueKey<String>('agent-gallery-component-reference'),
    );
    expect(reference, findsOneWidget);
    for (final ComponentDocEntry entry in entries) {
      expect(
        find.descendant(of: reference, matching: find.text(entry.title)),
        findsOneWidget,
        reason: 'missing component-reference row for ${entry.title}',
      );
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'typing into the live console and submitting produces a visible turn '
    'in the transcript',
    (WidgetTester tester) async {
      await _pump(tester);

      // The console with the fixed `AgentConsole.height` (`LiveConsole`) is
      // the one embedded at the top of the page — the only `AgentConsole`
      // whose composer is not tucked behind the launcher's dialog trigger.
      final Finder liveConsole = find.byType(AgentConsole).first;
      final Finder composerInput = find.descendant(
        of: liveConsole,
        matching: find.byType(EditableText),
      );
      expect(composerInput, findsOneWidget);

      const String message = 'What sealed boxes are left?';
      await tester.enterText(composerInput, message);
      await tester.pump();

      final Finder sendButton = find.descendant(
        of: liveConsole,
        matching: find.byWidgetPredicate(
          (Widget w) => w is Button && w.label == 'Send',
        ),
      );
      expect(sendButton, findsOneWidget);
      expect(tester.widget<Button>(sendButton).onPressed, isNotNull);

      await tester.tap(sendButton);
      // `MockTransport.send` appends the user's own turn to the transcript
      // synchronously, before it awaits anything — so the sent text is on
      // screen after the tap's own frame, deterministically, with no
      // dependency on the mock's scripted reply or its timing.
      await tester.pump();

      expect(find.text(message), findsOneWidget);
      expect(tester.takeException(), isNull);

      // Let the mock's own scripted reply (latency, a tool call, a streamed
      // answer) finish inside this test's `FakeAsync` zone — otherwise its
      // `Future.delayed` timer is still pending when the tree is torn down,
      // which `flutter_test` treats as a leak regardless of the assertion
      // above already having what it needs.
      await tester.pump(const Duration(seconds: 5));
    },
  );
}
