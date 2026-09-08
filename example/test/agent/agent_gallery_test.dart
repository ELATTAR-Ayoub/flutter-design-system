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
        pageRouteBuilder:
            <T>(RouteSettings settings, WidgetBuilder builder) =>
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

  testWidgets('the Documentation button navigates to /components/agent_core', (
    WidgetTester tester,
  ) async {
    final List<String> routes = <String>[];
    await _pump(tester, onNavigate: routes.add);

    await tester.tap(find.text('Documentation'));
    await tester.pump();

    expect(routes, <String>[componentDoc('agent-core').route]);
  });

  testWidgets(
    'the component reference lists every agent-family entry from the '
    'catalog, alphabetically',
    (WidgetTester tester) async {
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
    },
  );

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
