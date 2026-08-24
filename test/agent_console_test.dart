/// `agent_console.dart`, `agent_face.dart`, `agent_launcher.dart` — the three
/// files the console family owns, against the numbers and behaviours measured
/// on `/design-system/components/agent/console`.
///
/// The transcript's own parts (`ElUserMessage`, `ElToolChip`, `ElApprovalCard`,
/// `ElWelcomeCard`, …) are another lane's and are tested there; what this file
/// pins is the **machine** — which of them the console builds, when, and out of
/// what state — plus the two things the console family draws itself: the status
/// line's shimmer and the launcher's shell.
///
/// Every number here was read off the live reference, not derived. Where a probe
/// contradicted the class list, the probe is what is pinned and the divergence
/// is named in the test's own description.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/* ── A transport with a script in a list ─────────────────────────────────── */

/// The smallest thing that satisfies [ElAgentTransport]: a turn list a test
/// writes directly, and the four flags around it.
class _FakeTransport extends ChangeNotifier implements ElAgentTransport {
  _FakeTransport({
    List<ElAgentTurn>? turns,
    List<ElPendingApproval>? approvals,
    this.isLoading = false,
    this.isReady = true,
    this.error,
    this.capabilities = const ElAgentCapabilities(),
  }) : _turns = turns ?? <ElAgentTurn>[],
       _approvals = approvals ?? <ElPendingApproval>[];

  final List<ElAgentTurn> _turns;
  final List<ElPendingApproval> _approvals;

  @override
  bool isLoading;

  @override
  bool isReady;

  @override
  Object? error;

  @override
  final ElAgentCapabilities capabilities;

  /// What the console asked this transport to send, in order.
  final List<({String text, ElAgentSendOptions options})> sent =
      <({String text, ElAgentSendOptions options})>[];

  int aborts = 0;
  int resets = 0;

  @override
  List<ElAgentTurn> get turns => _turns;

  @override
  List<ElPendingApproval> get pendingApprovals => _approvals;

  @override
  Future<void> send(
    String text, [
    ElAgentSendOptions options = const ElAgentSendOptions(),
  ]) async {
    sent.add((text: text, options: options));
    notifyListeners();
  }

  @override
  void abort() {
    aborts += 1;
    notifyListeners();
  }

  @override
  void reset() {
    resets += 1;
    _turns.clear();
    notifyListeners();
  }
}

const ElToolStateMap _toolStates = <String, ElAgentState>{
  'search_inventory': ElAgentState.searching,
  'export_activity': ElAgentState.writing,
};

const ElAgentPersona _persona = ElAgentPersona(
  name: 'Vault',
  blurb: 'Ask about packs, pulls, prices and your wallet.',
  suggestions: <String>['What sealed boxes are left?'],
  placeholder: 'Ask about a pack, a pull or your balance…',
);

Future<void> _pump(
  WidgetTester tester,
  Widget child, {
  Size size = const Size(1000, 700),
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.reset);

  final ElThemeController theme = ElThemeController(mode: ElThemeMode.light);
  addTearDown(theme.dispose);

  await tester.pumpWidget(
    ElTheme(
      controller: theme,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Builder(
          builder: (BuildContext context) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              size: size,
              // Every entrance in the family is `both`-filled, so reduced
              // motion holds the final stop — which is the resting state every
              // number below was measured in.
              disableAnimations: true,
            ),
            child: DefaultTextStyle(
              style: ElText.styleOf(
                context,
                ElType.body,
                color: ElTheme.of(context).foreground,
              ),
              // A fresh key per pump: `Overlay` reads `initialEntries` once
              // and ignores every later change, so a test that pumps twice
              // would silently keep the first tree.
              child: Overlay(
                key: UniqueKey(),
                initialEntries: <OverlayEntry>[
                  OverlayEntry(builder: (BuildContext context) => child),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  /* ── The status line ───────────────────────────────────────────────────── */

  group('StatusLine', () {
    test(
      'anim-shimmer-text is 2.6s over a 220% tile, not the shimmer utility',
      () {
        // PROBE CORRECTION. `ElShimmerText` (attachment.dart) is shadcn's
        // `shimmer`: 2s linear, a `3ch + 40px` band. The status line wears
        // `anim-shimmer-text`, measured live mid-turn as `pulls-shimmer 2.6s
        // cubic-bezier(0.65,0,0.35,1) infinite` over `background-size: 220%`.
        expect(ElAgentShimmerText.period, ElDurations.shimmerText);
        expect(ElAgentShimmerText.period, const Duration(milliseconds: 2600));
        expect(ElAgentShimmerText.tileFactor, 2.2);
        // `linear-gradient(100deg, --muted-foreground 30%, --agent 50%,
        //  --muted-foreground 70%)`.
        expect(ElAgentShimmerText.stops, <double>[0.30, 0.50, 0.70]);
      },
    );

    test('the tile travels 200% → −200%, which on a 220% tile is ∓2.4W', () {
      // `background-position: X%` puts the tile's left edge at `(W − S)·X/100`.
      // With `S = 2.2W` that is `−1.2·W·X/100`: −2.4W at the `200%` stop and
      // +2.4W at `−200%`.
      const double w = 100;
      expect(ElAgentShimmerText.offsetAt(0, w), closeTo(-2.4 * w, 0.001));
      expect(ElAgentShimmerText.offsetAt(1, w), closeTo(2.4 * w, 0.001));
      // `--ease-in-out` is symmetric, so the midpoint is the midpoint.
      expect(ElAgentShimmerText.offsetAt(0.5, w), closeTo(0, 0.001));
    });

    testWidgets('Ready sits still and every busy state shimmers', (
      WidgetTester tester,
    ) async {
      await _pump(
        tester,
        const Center(child: ElAgentStatusLine(state: ElAgentState.idle)),
      );
      expect(find.text('Ready'), findsOneWidget);
      expect(find.byType(ElAgentShimmerText), findsNothing);

      await _pump(
        tester,
        const Center(child: ElAgentStatusLine(state: ElAgentState.searching)),
      );
      expect(find.text('Searching'), findsOneWidget);
      expect(find.byType(ElAgentShimmerText), findsOneWidget);
    });

    testWidgets('the three resting states are the only still ones', (
      WidgetTester tester,
    ) async {
      for (final ElAgentState state in ElAgentState.values) {
        await _pump(tester, Center(child: ElAgentStatusLine(state: state)));
        expect(
          find.byType(ElAgentShimmerText),
          state.isBusy ? findsOneWidget : findsNothing,
          reason: state.name,
        );
      }
    });

    testWidgets('voice wins over the machine, in both directions', (
      WidgetTester tester,
    ) async {
      // *"Voice wins while it is active, because a live microphone is the more
      // urgent fact."*
      await _pump(
        tester,
        const Center(
          child: ElAgentStatusLine(
            state: ElAgentState.searching,
            voice: ElAgentVoice(listening: true),
          ),
        ),
      );
      expect(find.text('Listening'), findsOneWidget);
      expect(find.text('Searching'), findsNothing);

      await _pump(
        tester,
        const Center(
          child: ElAgentStatusLine(
            state: ElAgentState.idle,
            voice: ElAgentVoice(speaking: true),
          ),
        ),
      );
      expect(find.text('Speaking'), findsOneWidget);
      // `isBusy(idle)` is false, but voice makes the line live anyway.
      expect(find.byType(ElAgentShimmerText), findsOneWidget);
    });

    test('no label carries the ellipsis its own doc comment promises', () {
      // DRIFT, carried from `agent_core.dart`: `states.ts` L43 says *"present
      // participles with an ellipsis for anything ongoing"* and not one label
      // has one. Reproduced, never repaired.
      for (final ElAgentState state in ElAgentState.values) {
        expect(state.label, isNot(contains('…')), reason: state.name);
      }
    });
  });

  /* ── The face ──────────────────────────────────────────────────────────── */

  group('AgentFace', () {
    test('FACE_SIZE is the avatar ladder, exactly', () {
      // `agent-face.tsx` L34: `{ sm: 32, md: 48, lg: 80, xl: 128 }`.
      expect(elAgentFaceSize(ElAgentAvatarSize.sm), 32);
      expect(elAgentFaceSize(ElAgentAvatarSize.md), 48);
      expect(elAgentFaceSize(ElAgentAvatarSize.lg), 80);
      expect(elAgentFaceSize(ElAgentAvatarSize.xl), 128);
    });

    testWidgets('the registry supplies the default renderer', (
      WidgetTester tester,
    ) async {
      // `avatar: Avatar = CubeAvatar` — the seam is a default, not a
      // requirement, so a console with no `avatar` prop still has a face.
      await _pump(
        tester,
        const Center(child: ElAgentFace(state: ElAgentState.idle)),
      );
      expect(find.byType(ElCubeAvatar), findsOneWidget);
    });

    testWidgets('an explicit builder wins, and is handed every prop', (
      WidgetTester tester,
    ) async {
      ElAgentState? sawState;
      ElAgentAvatarSize? sawSize;
      Color? sawAccent;
      double? sawSpeed;

      await _pump(
        tester,
        Center(
          child: ElAgentFace(
            state: ElAgentState.retrying,
            size: ElAgentAvatarSize.xl,
            accent: const Color(0xFF00FF00),
            speed: 2,
            avatar:
                (
                  BuildContext context,
                  ElAgentState state,
                  ElAgentAvatarSize size,
                  Color? accent,
                  double? speed,
                ) {
                  sawState = state;
                  sawSize = size;
                  sawAccent = accent;
                  sawSpeed = speed;
                  return const SizedBox.square(dimension: 10);
                },
          ),
        ),
      );

      expect(find.byType(ElCubeAvatar), findsNothing);
      expect(sawState, ElAgentState.retrying);
      expect(sawSize, ElAgentAvatarSize.xl);
      expect(sawAccent, const Color(0xFF00FF00));
      expect(sawSpeed, 2);
    });

    testWidgets('an active voice replaces the avatar with the orb, at its box', (
      WidgetTester tester,
    ) async {
      double? sawSize;
      ElOrbState? sawState;
      final ElAgentOrbBuilder original = ElAgentAvatarRegistry.orb;
      addTearDown(() => ElAgentAvatarRegistry.orb = original);
      ElAgentAvatarRegistry.orb =
          (
            BuildContext context,
            ElOrbState state,
            ValueListenable<double>? level,
            double size,
          ) {
            sawState = state;
            sawSize = size;
            return SizedBox.square(dimension: size);
          };

      await _pump(
        tester,
        const Center(
          child: ElAgentFace(
            state: ElAgentState.searching,
            size: ElAgentAvatarSize.lg,
            voice: ElAgentVoice(listening: true),
          ),
        ),
      );

      expect(find.byType(ElCubeAvatar), findsNothing);
      expect(sawState, ElOrbState.listening);
      // The orb takes a *number* where the avatar takes a rung; `FACE_SIZE` is
      // what bridges them.
      expect(sawSize, elAgentFaceSize(ElAgentAvatarSize.lg));
    });
  });

  /* ── The console ───────────────────────────────────────────────────────── */

  group('AgentConsole', () {
    testWidgets('the avatar flag is what brings the header', (
      WidgetTester tester,
    ) async {
      final _FakeTransport transport = _FakeTransport();
      addTearDown(transport.dispose);

      await _pump(
        tester,
        ElAgentConsole(transport: transport, persona: _persona, height: 600),
      );
      expect(find.byType(ElAgentStatusLine), findsOneWidget);

      await _pump(
        tester,
        ElAgentConsole(
          transport: transport,
          persona: _persona,
          features: const ElAgentFeatures(avatar: false),
          height: 600,
        ),
      );
      expect(find.byType(ElAgentStatusLine), findsNothing);
    });

    testWidgets('an empty transport draws the welcome card and nothing else', (
      WidgetTester tester,
    ) async {
      final _FakeTransport transport = _FakeTransport();
      addTearDown(transport.dispose);

      await _pump(
        tester,
        ElAgentConsole(
          transport: transport,
          persona: _persona,
          commands: const <ElAgentCommand>[
            ElAgentCommand(
              id: 'inventory',
              label: 'inventory',
              group: ElAgentCommandGroup.skill,
            ),
            ElAgentCommand(
              id: 'guide',
              label: 'guide',
              group: ElAgentCommandGroup.command,
            ),
          ],
          height: 600,
        ),
      );

      expect(find.byType(ElWelcomeCard), findsOneWidget);
      // Only skills become chips — the console filters, because
      // `ElAgentCapability` carries no group of its own.
      expect(find.text('inventory'), findsOneWidget);
      expect(find.text('guide'), findsNothing);
    });

    testWidgets('the suggestions flag empties the starter prompts', (
      WidgetTester tester,
    ) async {
      final _FakeTransport transport = _FakeTransport();
      addTearDown(transport.dispose);

      await _pump(
        tester,
        ElAgentConsole(
          transport: transport,
          persona: _persona,
          features: const ElAgentFeatures(suggestions: false),
          height: 600,
        ),
      );
      expect(find.text('What sealed boxes are left?'), findsNothing);
    });

    testWidgets('a starter prompt sends immediately, with the model attached', (
      WidgetTester tester,
    ) async {
      final _FakeTransport transport = _FakeTransport();
      addTearDown(transport.dispose);

      await _pump(
        tester,
        ElAgentConsole(
          transport: transport,
          persona: _persona,
          models: const <ElAgentModel>[
            ElAgentModel(id: 'fast', label: 'Fast'),
            ElAgentModel(id: 'deep', label: 'Deep'),
          ],
          height: 600,
        ),
      );

      await tester.tap(find.text('What sealed boxes are left?'));
      await tester.pump();

      expect(transport.sent.length, 1);
      expect(transport.sent.single.text, 'What sealed boxes are left?');
      // *"Derived rather than synced"* — the picker has not been touched, so
      // the first entry is what goes on the wire.
      expect(transport.sent.single.options.model, 'fast');
    });

    testWidgets('every turn kind reaches the renderer it belongs to', (
      WidgetTester tester,
    ) async {
      final _FakeTransport transport = _FakeTransport(
        turns: <ElAgentTurn>[
          const ElUserTurn(id: 'u', text: 'What sealed boxes are left?'),
          const ElTextTurn(id: 't', text: 'Let me look that up.'),
          const ElToolTurn(
            id: 'tool',
            name: 'search_inventory',
            params: <String, Object?>{'limit': 3},
            status: ElAgentTurnStatus.ok,
            attempt: 1,
            ms: 897,
          ),
          const ElActionTurn(
            id: 'act',
            action: 'purchase_pack',
            params: <String, Object?>{},
            status: ElAgentTurnStatus.ok,
            ms: 694,
          ),
          const ElErrorTurn(
            id: 'err',
            message: 'The pricing service did not respond in time.',
            fatal: false,
          ),
        ],
      );
      addTearDown(transport.dispose);

      await _pump(
        tester,
        ElAgentConsole(
          transport: transport,
          persona: _persona,
          toolStates: _toolStates,
          height: 600,
        ),
        size: const Size(1000, 1400),
      );

      expect(find.byType(ElWelcomeCard), findsNothing);
      expect(find.byType(ElUserMessage), findsOneWidget);
      expect(find.byType(ElAgentMessage), findsOneWidget);
      expect(find.byType(ElToolChip), findsOneWidget);
      expect(find.byType(ElActionChip), findsOneWidget);
      // The `error` turn is an inline paragraph the console draws itself.
      expect(
        find.text('The pricing service did not respond in time.'),
        findsOneWidget,
      );
      // The chip's label comes from the same map that drives the face.
      expect(find.text(ElAgentState.searching.label), findsOneWidget);
      // `humanise("purchase_pack")`.
      expect(find.text('Purchase pack'), findsOneWidget);
    });

    testWidgets('toolTrace off drops both chips and keeps everything else', (
      WidgetTester tester,
    ) async {
      final _FakeTransport transport = _FakeTransport(
        turns: <ElAgentTurn>[
          const ElUserTurn(id: 'u', text: 'hello'),
          const ElToolTurn(
            id: 'tool',
            name: 'search_inventory',
            params: <String, Object?>{},
            status: ElAgentTurnStatus.ok,
            attempt: 1,
          ),
          const ElActionTurn(
            id: 'act',
            action: 'purchase_pack',
            params: <String, Object?>{},
            status: ElAgentTurnStatus.ok,
          ),
        ],
      );
      addTearDown(transport.dispose);

      await _pump(
        tester,
        ElAgentConsole(
          transport: transport,
          features: const ElAgentFeatures(toolTrace: false),
          height: 600,
        ),
      );

      expect(find.byType(ElToolChip), findsNothing);
      expect(find.byType(ElActionChip), findsNothing);
      expect(find.byType(ElUserMessage), findsOneWidget);
    });

    testWidgets(
      'a pending approval draws its card, with the caller\'s sentence',
      (WidgetTester tester) async {
        final _FakeTransport transport = _FakeTransport(
          turns: <ElAgentTurn>[
            const ElActionTurn(
              id: 'mock-purchase_pack-1',
              action: 'purchase_pack',
              params: <String, Object?>{'pack': 'Eclipse Vault', 'price': 129},
              status: ElAgentTurnStatus.running,
            ),
          ],
          approvals: <ElPendingApproval>[
            ElPendingApproval(
              turnId: 'mock-purchase_pack-1',
              action: 'purchase_pack',
              params: const <String, Object?>{'pack': 'Eclipse Vault'},
              approve: () {},
              reject: ([String? reason]) {},
            ),
          ],
          isLoading: true,
        );
        addTearDown(transport.dispose);

        await _pump(
          tester,
          ElAgentConsole(
            transport: transport,
            persona: _persona,
            height: 600,
            describeApproval: (String action, Map<String, Object?> params) =>
                'Buy ${params['pack']} for \$129.00.',
          ),
          size: const Size(1000, 1400),
        );

        expect(find.byType(ElApprovalCard), findsOneWidget);
        expect(find.text('Buy Eclipse Vault for \$129.00.'), findsOneWidget);
      },
    );

    testWidgets(
      'DRIFT: the gate never reaches awaiting_approval — it reads Processing',
      (WidgetTester tester) async {
        // PROBE, on the live console with the card up. `reduceEvent` builds the
        // action turn with `status: "running"` and **no** `approval` field;
        // `markApproval` only runs once the user has answered. So the resolver's
        // branch 2 cannot match while the card is on screen and branch 4 wins.
        // One of the twenty states is unreachable through this transport.
        final _FakeTransport transport = _FakeTransport(
          turns: <ElAgentTurn>[
            const ElActionTurn(
              id: 'mock-purchase_pack-1',
              action: 'purchase_pack',
              params: <String, Object?>{},
              status: ElAgentTurnStatus.running,
            ),
          ],
          approvals: <ElPendingApproval>[
            ElPendingApproval(
              turnId: 'mock-purchase_pack-1',
              action: 'purchase_pack',
              params: const <String, Object?>{},
              approve: () {},
              reject: ([String? reason]) {},
            ),
          ],
          isLoading: true,
        );
        addTearDown(transport.dispose);

        await _pump(
          tester,
          ElAgentConsole(transport: transport, persona: _persona, height: 600),
          size: const Size(1000, 1400),
        );

        expect(find.text(ElAgentState.processing.label), findsOneWidget);
        expect(find.text(ElAgentState.awaitingApproval.label), findsNothing);
      },
    );

    testWidgets('the transport\'s standing error is a banner, not a turn', (
      WidgetTester tester,
    ) async {
      // *"`transport.error` is the standing banner above the composer and means
      // something else entirely — the connection is down."*
      final _FakeTransport transport = _FakeTransport(
        turns: <ElAgentTurn>[const ElUserTurn(id: 'u', text: 'hello')],
        error: 'Connection lost.',
      );
      addTearDown(transport.dispose);

      await _pump(tester, ElAgentConsole(transport: transport, height: 600));
      expect(find.text('Connection lost.'), findsOneWidget);
    });

    testWidgets('the model picker hides below two models', (
      WidgetTester tester,
    ) async {
      // `if (models.length < 2) return null` — *"a picker with one option is a
      // control that cannot do anything, and offering it implies the choice
      // matters."*
      final _FakeTransport transport = _FakeTransport();
      addTearDown(transport.dispose);

      await _pump(
        tester,
        ElAgentConsole(
          transport: transport,
          models: const <ElAgentModel>[ElAgentModel(id: 'fast', label: 'Fast')],
          height: 600,
        ),
      );
      expect(find.text('Fast'), findsNothing);

      await _pump(
        tester,
        ElAgentConsole(
          transport: transport,
          models: const <ElAgentModel>[
            ElAgentModel(id: 'fast', label: 'Fast'),
            ElAgentModel(id: 'deep', label: 'Deep'),
          ],
          height: 600,
        ),
      );
      expect(find.text('Fast'), findsOneWidget);
    });

    testWidgets('DIVERGENCE 2 CLOSED: a model hint stacks under its label', (
      WidgetTester tester,
    ) async {
      // `ModelPicker` writes `flex-col items-start gap-1`. The hint rode
      // [ElMenuItem.shortcut] — and so sat at the *other end of the row* — for
      // as long as the primitive had no second line; it has one now, on
      // `ElCommandItem.subtitle`'s terms, and this call site passes it.
      final _FakeTransport transport = _FakeTransport();
      addTearDown(transport.dispose);

      await _pump(
        tester,
        ElAgentConsole(
          transport: transport,
          models: const <ElAgentModel>[
            ElAgentModel(
              id: 'fast',
              label: 'Fast',
              hint: 'Answers in a second',
            ),
            ElAgentModel(
              id: 'deep',
              label: 'Deep',
              hint: 'Slower, checks its work',
            ),
          ],
          height: 600,
        ),
      );

      await tester.tap(find.text('Fast'));
      await tester.pump();
      await tester.pump();

      final Finder row = find.byType(ElMenuContent);
      expect(row, findsOneWidget);
      final Rect label = tester.getRect(
        find.descendant(of: row, matching: find.text('Deep')),
      );
      final Rect hint = tester.getRect(
        find.descendant(
          of: row,
          matching: find.text('Slower, checks its work'),
        ),
      );
      // Under and flush-left, not beside and right-aligned. A shortcut would
      // have put the hint's left edge well right of the label's and its top
      // level with it — which is exactly the shape the divergence described.
      expect(hint.top, greaterThan(label.top));
      expect(hint.left, closeTo(label.left, 0.01));
    });

    testWidgets('models off hides the picker however long the list is', (
      WidgetTester tester,
    ) async {
      final _FakeTransport transport = _FakeTransport();
      addTearDown(transport.dispose);

      await _pump(
        tester,
        ElAgentConsole(
          transport: transport,
          features: const ElAgentFeatures(models: false),
          models: const <ElAgentModel>[
            ElAgentModel(id: 'fast', label: 'Fast'),
            ElAgentModel(id: 'deep', label: 'Deep'),
          ],
          height: 600,
        ),
      );
      expect(find.text('Fast'), findsNothing);
    });

    testWidgets('isReady false disables rather than dropping the first message', (
      WidgetTester tester,
    ) async {
      // *"False while the transport is still acquiring whatever it needs before
      // it can carry a message. The composer disables rather than dropping the
      // first message on the floor."* The welcome card is disabled with it, so
      // a starter prompt cannot fire into a transport that cannot carry it.
      final _FakeTransport transport = _FakeTransport(isReady: false);
      addTearDown(transport.dispose);

      await _pump(
        tester,
        ElAgentConsole(transport: transport, persona: _persona, height: 600),
      );

      await tester.tap(find.text('What sealed boxes are left?'));
      await tester.pump();
      expect(transport.sent, isEmpty);
    });

    testWidgets('capabilities are advertised, not assumed', (
      WidgetTester tester,
    ) async {
      // *"Advertised so the console can render only what this agent can
      // actually do."* The default is a fully-featured agent, which is what the
      // mock transport publishes and what every specimen on the page runs on.
      final _FakeTransport transport = _FakeTransport(
        capabilities: const ElAgentCapabilities(
          attachments: ElAgentAttachmentSupport.none,
          models: false,
          approvals: false,
        ),
      );
      addTearDown(transport.dispose);

      expect(transport.capabilities.models, isFalse);
      expect(transport.capabilities.approvals, isFalse);
      expect(transport.capabilities.attachments, ElAgentAttachmentSupport.none);

      await _pump(
        tester,
        ElAgentConsole(transport: transport, persona: _persona, height: 600),
      );
      // KNOWN GAP, and it is the reference's: `AgentConsole` reads
      // `transport.capabilities` **nowhere**. Every switch it honours is a
      // `features` flag the caller sets, so a transport that advertises
      // `models: false` still gets a model picker if the console was given one.
      // Reproduced rather than repaired — see the console's own register.
      expect(find.byType(ElAgentConsole), findsOneWidget);
    });

    test('the console pays its own inset, and the reference says why', () {
      // *"Padding belongs here rather than on each parent, so it is right on
      // every surface instead of right on the ones that remembered."*
      expect(ElAgentConsole.padding, el(5));
      expect(ElAgentConsole.gap, el(4));
      expect(ElAgentConsole.headerGap, el(3));
      expect(ElAgentConsole.headerInset, el(6));
      expect(ElAgentConsole.turnGap, el(4));
      expect(ElAgentConsole.scrollerInset, el(1));
      // *"A 32px tolerance, so a user who is essentially at the bottom stays
      // pinned and one who has scrolled up to read is left alone."*
      expect(ElAgentConsole.pinTolerance, 32);
    });

    testWidgets('h-152 resolves the measured 608, and its parts sum to it', (
      WidgetTester tester,
    ) async {
      final _FakeTransport transport = _FakeTransport();
      addTearDown(transport.dispose);

      await _pump(
        tester,
        Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 1078,
            child: ElAgentConsole(
              transport: transport,
              persona: _persona,
              height: el(152),
            ),
          ),
        ),
        size: const Size(1200, 900),
      );

      // `608 = 20 + 48 + 16 + scroller + 16 + composer + 20`, measured live.
      expect(tester.getSize(find.byType(ElAgentConsole)).height, 608);
      // Two faces, and the pair is the point: the header's is `md` and the
      // welcome card's is `lg`, so *"the thing you click is the thing that then
      // talks to you"* holds at both scales off one renderer.
      final Iterable<Size> faces = find
          .byType(ElAgentFace)
          .evaluate()
          .map((Element e) => (e.renderObject! as RenderBox).size);
      expect(faces.length, 2);
      expect(faces.map((Size s) => s.height).toSet(), <double>{
        elAgentFaceSize(ElAgentAvatarSize.md),
        elAgentFaceSize(ElAgentAvatarSize.lg),
      });
    });
  });

  /* ── switchPhase ───────────────────────────────────────────────────────── */

  /// `agent-console.tsx` puts `blurClass(switchPhase)` on the `overflow-y-auto`
  /// div and NOWHERE else. These cases are written to bite in both directions:
  /// remove the wrap and the first fails; let it creep up onto the console root
  /// and the second and third fail.
  ///
  /// `_pump` runs with `disableAnimations: true`, so [ElBlurSwitch] holds its
  /// final stop — which makes each phase a single deterministic tree rather
  /// than a moment in a tween.
  group('AgentConsole switchPhase', () {
    Future<void> pumpAt(WidgetTester tester, ElSwitchPhase phase) async {
      final _FakeTransport transport = _FakeTransport(
        turns: <ElAgentTurn>[
          const ElUserTurn(id: 'u', text: 'What sealed boxes are left?'),
          const ElTextTurn(id: 't', text: 'Three sealed boxes match.'),
        ],
      );
      addTearDown(transport.dispose);

      await _pump(
        tester,
        ElAgentConsole(
          transport: transport,
          persona: _persona,
          switchPhase: phase,
          height: 600,
        ),
      );
    }

    testWidgets('the transcript is inside the blur', (
      WidgetTester tester,
    ) async {
      await pumpAt(tester, ElSwitchPhase.out);
      expect(
        find.ancestor(
          of: find.byType(ElAgentMessage),
          matching: find.byType(ElBlurSwitch),
        ),
        findsOneWidget,
      );
    });

    testWidgets('the composer is NOT — the user is about to type into it', (
      WidgetTester tester,
    ) async {
      await pumpAt(tester, ElSwitchPhase.out);
      expect(find.byType(ElAgentComposer), findsOneWidget);
      expect(
        find.ancestor(
          of: find.byType(ElAgentComposer),
          matching: find.byType(ElBlurSwitch),
        ),
        findsNothing,
      );
    });

    testWidgets('the header is NOT — only the transcript is being replaced', (
      WidgetTester tester,
    ) async {
      await pumpAt(tester, ElSwitchPhase.out);
      expect(find.byType(ElAgentStatusLine), findsOneWidget);
      expect(
        find.ancestor(
          of: find.byType(ElAgentStatusLine),
          matching: find.byType(ElBlurSwitch),
        ),
        findsNothing,
      );
    });

    testWidgets('idle costs nothing — no saveLayer over the transcript', (
      WidgetTester tester,
    ) async {
      await pumpAt(tester, ElSwitchPhase.idle);
      // The widget is still in the tree; what it must not do is filter.
      expect(
        find.ancestor(
          of: find.byType(ElAgentMessage),
          matching: find.byType(ElBlurSwitch),
        ),
        findsOneWidget,
      );
      expect(
        find.ancestor(
          of: find.byType(ElAgentMessage),
          matching: find.byType(ImageFiltered),
        ),
        findsNothing,
      );
    });

    testWidgets('out ends blurred and invisible', (WidgetTester tester) async {
      await pumpAt(tester, ElSwitchPhase.out);
      final ImageFiltered filtered = tester.widget<ImageFiltered>(
        find
            .ancestor(
              of: find.byType(ElAgentMessage),
              matching: find.byType(ImageFiltered),
            )
            .first,
      );
      expect(filtered.imageFilter, isNotNull);
      // `pulls-blur-out` ends on blur(6px); the port halves it to a Gaussian σ.
      expect(ElBlurSwitch.outRadius, 6);
      final Opacity opacity = tester.widget<Opacity>(
        find
            .ancestor(
              of: find.byType(ElAgentMessage),
              matching: find.byType(Opacity),
            )
            .first,
      );
      expect(opacity.opacity, 0);
    });

    testWidgets('in ends sharp and opaque — the swap is finished', (
      WidgetTester tester,
    ) async {
      await pumpAt(tester, ElSwitchPhase.blurIn);
      // `pulls-blur-in` runs blur(8px) → 0, so its resting stop filters nothing.
      expect(ElBlurSwitch.inRadius, 8);
      expect(
        find.ancestor(
          of: find.byType(ElAgentMessage),
          matching: find.byType(ImageFiltered),
        ),
        findsNothing,
      );
      final Opacity opacity = tester.widget<Opacity>(
        find
            .ancestor(
              of: find.byType(ElAgentMessage),
              matching: find.byType(Opacity),
            )
            .first,
      );
      expect(opacity.opacity, 1);
    });

    test('the two legs are the measured durations', () {
      expect(ElBlurSwitchController.outDuration, ElDurations.fast); // 150ms
      expect(ElBlurSwitchController.inDuration, ElDurations.base); // 250ms
    });

    test('the default is idle — a console with no history behind it', () {
      expect(
        ElAgentConsole(
          transport: _FakeTransport(),
          persona: _persona,
        ).switchPhase,
        ElSwitchPhase.idle,
      );
    });
  });

  /* ── The launcher ──────────────────────────────────────────────────────── */

  group('AgentLauncher', () {
    test('the button and its label are the measured boxes', () {
      expect(ElAgentLauncher.size, 64); // `size-16`
      expect(ElAgentLauncher.inset, 24); // `right-6 bottom-6`
      expect(ElAgentLauncher.labelGap, 12); // `mr-3`
      expect(ElAgentLauncher.labelRest, 8); // `translate-x-2`
      expect(
        ElAgentLauncher.labelPadding,
        const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // `px-3 py-2`
      );
    });

    test('the dialog resolves 78vw against a 60vw floor and an 80rem cap', () {
      // Measured at 1440×900: 1123.19 × 792.
      final Size at1440 = ElAgentLauncher.dialogSize(const Size(1440, 900));
      expect(at1440.width, closeTo(1123.2, 0.05));
      expect(at1440.height, 792);

      // `--width-console` is 80rem = 1280, and it binds in the middle band.
      expect(ElAgentLauncher.dialogMaxWidth, 1280);
      expect(
        ElAgentLauncher.dialogSize(const Size(1800, 900)).width,
        closeTo(1280, 0.05),
      );

      // `min(88vh, 52rem)` — the 52rem arm, on a tall viewport.
      expect(ElAgentLauncher.dialogMaxHeight, 832);
      expect(ElAgentLauncher.dialogSize(const Size(1440, 1400)).height, 832);
    });

    test('min-width is applied after max-width, so past ~2133 the cap loses', () {
      // CSS resolves the used width as `max(min-width, min(max-width, width))`.
      // Both bounds here are viewport-relative against a fixed 80rem cap, so on
      // an ultrawide `60vw` overtakes it: a 2400px window gets 1440, not 1280.
      // A naive `clamp(min, max)` throws at exactly this input.
      expect(
        ElAgentLauncher.dialogSize(const Size(2400, 1400)).width,
        closeTo(1440, 0.05),
      );
      // The crossover: 60vw = 1280 at 2133.33.
      expect(
        ElAgentLauncher.dialogSize(const Size(2133.33, 900)).width,
        closeTo(1280, 0.05),
      );
    });

    testWidgets(
      'the trigger has no layout box, so the section keeps its height',
      (WidgetTester tester) async {
        await _pump(
          tester,
          const Align(
            alignment: Alignment.topLeft,
            child: ElAgentLauncher(
              label: 'Ask the assistant',
              title: 'Vault',
              description: 'Ask about packs, pulls, prices and your wallet.',
              child: SizedBox.shrink(),
            ),
          ),
        );

        // `position: fixed` — out of flow. The launcher section on the console
        // page measures 404.8 with a 224px panel in it, and a launcher that took
        // part in layout would push it.
        expect(tester.getSize(find.byType(ElAgentLauncher)), Size.zero);
        // …while the control itself is drawn, into the overlay.
        expect(find.text('Ask the assistant'), findsOneWidget);
        expect(find.byType(ElCubeAvatar), findsOneWidget);
      },
    );

    testWidgets('PROBE: the label snaps 8px and only its opacity rides the 250ms', (
      WidgetTester tester,
    ) async {
      // `translate-x-2` compiles to the standalone `translate` property, which
      // is NOT in `transition-[opacity,transform]`. Traced with a real pointer:
      // `translate` goes 8px → 0px in one frame at `pointerover`, while opacity
      // is still 0 and takes 248ms to reach 1 on `--ease-out-flex`.
      await _pump(
        tester,
        const Align(
          alignment: Alignment.topLeft,
          child: ElAgentLauncher(
            label: 'Ask the assistant',
            title: 'Vault',
            description: 'x',
            child: SizedBox.shrink(),
          ),
        ),
      );

      double labelX() => tester.getTopLeft(find.text('Ask the assistant')).dx;
      double labelOpacity() => tester
          .widget<AnimatedOpacity>(
            find.ancestor(
              of: find.text('Ask the assistant'),
              matching: find.byType(AnimatedOpacity),
            ),
          )
          .opacity;

      final double atRest = labelX();
      expect(labelOpacity(), 0);

      final TestGesture gesture = await tester.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      addTearDown(gesture.removePointer);
      await gesture.addPointer(location: Offset.zero);
      await gesture.moveTo(tester.getCenter(find.byType(ElCubeAvatar)));
      await tester.pump();

      // One frame, and the 8px is already gone — no intermediate value.
      expect(atRest - labelX(), closeTo(ElAgentLauncher.labelRest, 0.01));
      // The fade is what the 250ms governs.
      expect(labelOpacity(), 1);
    });

    testWidgets('GAP CLOSED: hover:border-agent/50 is painted on the pill', (
      WidgetTester tester,
    ) async {
      // It was not, for as long as [ElButtonSurface] had `fill` / `hoverFill` /
      // `border` / `ink` / `hoverInk` and no `hoverBorder`: the resting rim was
      // right and the hover rim never moved. The fix was one field on the
      // primitive — reported from here rather than forked into this file — and
      // this is the test that says it arrived.
      await _pump(
        tester,
        const Align(
          alignment: Alignment.topLeft,
          child: ElAgentLauncher(
            label: 'Ask the assistant',
            title: 'Vault',
            description: 'x',
            child: SizedBox.shrink(),
          ),
        ),
      );

      Color rimOf() =>
          (tester
                      .widget<ElMachineSurface>(find.byType(ElMachineSurface))
                      .border!
                  as Border)
              .top
              .color;

      final ElThemeData light = ElThemeData.light;
      final Color rim = light.agent.withValues(
        alpha: ElAgentLauncher.hoverRimAlpha,
      );
      // The bite: the two colours have to differ, or the assertions below pass
      // with the override deleted.
      expect(rim, isNot(light.input));

      // `variant="outline"` supplies the resting hairline, and the class list
      // overrides nothing at rest.
      expect(rimOf(), light.input);

      final TestGesture mouse = await tester.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      addTearDown(mouse.removePointer);
      await mouse.addPointer(location: Offset.zero);
      await mouse.moveTo(tester.getCenter(find.byType(ElCubeAvatar)));
      await tester.pump();

      // `--agent` at half alpha. The harness runs reduced-motion, so the
      // 250ms `--ease-spring` this rides on the reference lands on its final
      // stop in one frame — the value is what is pinned here, and the spring
      // itself is `components_test`'s.
      expect(rimOf(), rim);

      await mouse.moveTo(Offset.zero);
      await tester.pump();
      expect(rimOf(), light.input);
    });
  });

  /* ── USER-ORDERED MOBILE ADAPTATION ──────────────────────────────────────
     The console's composer is bottom-anchored, so on a phone it was the one
     field guaranteed to sit behind the software keyboard — including inside
     the launcher's dialog, which is where it was reported. The console pays it
     with a spacer of `viewInsets.bottom` at the end of its own column: the
     composer lifts by the keyboard's height and the `flex-1` scroller gives up
     exactly that much. Nothing here is a translation; what is pinned is the
     rule, the arithmetic, and the fact that a desktop frame is untouched.   */

  group('AgentConsole — the composer rises off the software keyboard', () {
    const Size phone = Size(375, 812);
    const double keyboard = 300;

    /// The console under a MediaQuery whose bottom inset a test can move
    /// without rebuilding the console — the keyboard opening is a change of
    /// dependency, not a change of tree, exactly as it is on a device.
    Future<void> pumpConsole(
      WidgetTester tester,
      ValueNotifier<double> inset, {
      required ElAgentTransport transport,
    }) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = phone;
      addTearDown(tester.view.reset);

      final ElThemeController theme = ElThemeController(
        mode: ElThemeMode.light,
      );
      addTearDown(theme.dispose);

      await tester.pumpWidget(
        ElTheme(
          controller: theme,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: ValueListenableBuilder<double>(
              valueListenable: inset,
              // Held outside the builder, so the console's element — and its
              // state, its scroll offset, its draft — survives the keyboard.
              child: ElAgentConsole(transport: transport),
              builder: (BuildContext context, double bottom, Widget? console) =>
                  MediaQuery(
                    data: MediaQueryData(
                      size: phone,
                      viewInsets: EdgeInsets.only(bottom: bottom),
                      disableAnimations: true,
                    ),
                    child: Builder(
                      builder: (BuildContext context) => DefaultTextStyle(
                        style: ElText.styleOf(
                          context,
                          ElType.body,
                          color: ElTheme.of(context).foreground,
                        ),
                        child: console!,
                      ),
                    ),
                  ),
            ),
          ),
        ),
      );
      await tester.pump();
    }

    ScrollPosition scrollerOf(WidgetTester tester) => tester
        .state<ScrollableState>(
          find
              .descendant(
                of: find.byType(ElAgentConsole),
                matching: find.byType(Scrollable),
              )
              .first,
        )
        .position;

    _FakeTransport chatty() => _FakeTransport(
      turns: <ElAgentTurn>[
        for (int i = 0; i < 20; i++)
          ElUserTurn(id: 'u$i', text: 'A message long enough to stack up $i'),
      ],
    );

    testWidgets('the composer sits fully above a 300pt keyboard at 375×812', (
      WidgetTester tester,
    ) async {
      await pumpConsole(
        tester,
        ValueNotifier<double>(keyboard),
        transport: chatty(),
      );

      final Rect composer = tester.getRect(find.byType(ElAgentComposer));
      // The order's own test: fully above the keyboard's top edge.
      expect(composer.bottom, lessThanOrEqualTo(phone.height - keyboard));
      // And by exactly the console's own `p-5` and not a pixel more — the lift
      // is the keyboard's height, not a guess at it.
      expect(
        composer.bottom,
        closeTo(phone.height - keyboard - ElAgentConsole.padding, 0.01),
      );
      // The console itself did not move or resize; the spacer is internal.
      expect(
        tester.getRect(find.byType(ElAgentConsole)),
        Rect.fromLTWH(0, 0, phone.width, phone.height),
      );
      // And the composer wears the family's own hook as well, so it is covered
      // on the surfaces where nothing above it has made the room.
      expect(
        find.descendant(
          of: find.byType(ElAgentComposer),
          matching: find.byType(ElFieldVisibility),
        ),
        findsOneWidget,
      );
    });

    testWidgets('the scroller gives up exactly what the composer gains', (
      WidgetTester tester,
    ) async {
      final ValueNotifier<double> inset = ValueNotifier<double>(0);
      await pumpConsole(tester, inset, transport: chatty());

      // The scroller's own box, read off its position rather than off the
      // content it holds — the transcript is longer than the viewport here,
      // which is the case the order is about.
      final double restingScroller = scrollerOf(tester).viewportDimension;
      final double restingComposer = tester
          .getRect(find.byType(ElAgentComposer))
          .bottom;
      // With no keyboard the composer sits on the console's own bottom inset.
      expect(
        restingComposer,
        closeTo(phone.height - ElAgentConsole.padding, 0.01),
      );

      inset.value = keyboard;
      await tester.pump();

      expect(
        restingComposer - tester.getRect(find.byType(ElAgentComposer)).bottom,
        closeTo(keyboard, 0.01),
      );
      expect(
        restingScroller - scrollerOf(tester).viewportDimension,
        closeTo(keyboard, 0.01),
      );
    });

    testWidgets('stick-to-bottom survives the keyboard opening', (
      WidgetTester tester,
    ) async {
      final ValueNotifier<double> inset = ValueNotifier<double>(0);
      final _FakeTransport transport = chatty();
      await pumpConsole(tester, inset, transport: transport);

      // Ride the bottom the way a reader does: any transport notification
      // autoscrolls while pinned.
      transport.abort();
      await tester.pump();
      await tester.pump();
      // Read as numbers, not as a handle: the position object is live and
      // would report the new extent under the old name.
      final double restingExtent = scrollerOf(tester).maxScrollExtent;
      expect(scrollerOf(tester).pixels, restingExtent);
      expect(restingExtent, greaterThan(0));

      inset.value = keyboard;
      await tester.pump();
      await tester.pump();

      final ScrollPosition after = scrollerOf(tester);
      // The viewport lost the keyboard's height, so there is more to scroll —
      // and the reader is still at the bottom of it, which is the console's
      // one scroll promise.
      expect(after.maxScrollExtent - restingExtent, closeTo(keyboard, 0.01));
      expect(after.pixels, after.maxScrollExtent);
    });

    testWidgets('and inside the launcher dialog, where it was reported', (
      WidgetTester tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = phone;
      addTearDown(tester.view.reset);

      final ElThemeController theme = ElThemeController(
        mode: ElThemeMode.light,
      );
      addTearDown(theme.dispose);

      await tester.pumpWidget(
        ElTheme(
          controller: theme,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: MediaQuery(
              data: const MediaQueryData(
                size: phone,
                viewInsets: EdgeInsets.only(bottom: keyboard),
                disableAnimations: true,
              ),
              child: Builder(
                builder: (BuildContext context) => DefaultTextStyle(
                  style: ElText.styleOf(
                    context,
                    ElType.body,
                    color: ElTheme.of(context).foreground,
                  ),
                  child: Overlay(
                    initialEntries: <OverlayEntry>[
                      OverlayEntry(
                        builder: (BuildContext context) => Align(
                          alignment: Alignment.topLeft,
                          child: ElAgentLauncher(
                            label: 'Ask the assistant',
                            title: 'Vault',
                            description: 'x',
                            child: ElAgentConsole(transport: chatty()),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      // Open it: the console is now inside a dialog the console does not size,
      // which is the surface the bug was reported against.
      await tester.tap(find.byType(ElCubeAvatar));
      await tester.pumpAndSettle();

      expect(find.byType(ElAgentComposer), findsOneWidget);
      expect(
        tester.getRect(find.byType(ElAgentComposer)).bottom,
        lessThanOrEqualTo(phone.height - keyboard),
      );
    });

    testWidgets('with no keyboard the console builds the tree it always did', (
      WidgetTester tester,
    ) async {
      await pumpConsole(tester, ValueNotifier<double>(0), transport: chatty());

      // The spacer is built ONLY when there is a keyboard, so a desktop tree is
      // identical widget for widget to the one before this change. Nothing but
      // the composer's own gap sits under it.
      expect(
        tester.getRect(find.byType(ElAgentComposer)).bottom,
        closeTo(phone.height - ElAgentConsole.padding, 0.01),
      );
      final Column column = tester.widget<Column>(
        find
            .descendant(
              of: find.byType(ElAgentConsole),
              matching: find.byType(Column),
            )
            .first,
      );
      expect(
        column.children.whereType<SizedBox>().where(
          (SizedBox box) => box.height == 0,
        ),
        isEmpty,
      );
    });
  });
}
