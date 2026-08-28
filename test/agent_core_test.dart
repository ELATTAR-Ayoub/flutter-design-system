import 'package:elattar_design_system/elattar_design_system.dart';
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

/// `components/agent/core/*` — the transport-agnostic model, pinned.
///
/// Every case here is a pure function of its arguments (bar the two seams that
/// genuinely need a pump), which is the reference's whole design claim for this
/// layer: *"the face is derived, never set, so it cannot claim to be running
/// code when no tool is running."*
///
/// This file is the union of two builds' tests, merged when `agent_core.dart`
/// was: the console/composer half (attachments, serialisation, the resolver
/// ladder) and the transcript/history half (conversations, relative time, the
/// blur switch, the state machine's own members).
///
/// The nine-branch ladder in `resolve-state.ts` is specified by ITS ORDER —
/// *"first match wins"* — so the resolver's cases below are written as
/// precedence pairs wherever two branches are simultaneously true. Testing each
/// branch in isolation would pass against a resolver with the ladder shuffled.

AgentAttachment _file({
  String id = 'a1',
  required String name,
  required String mime,
  int size = 1024,
  String? text,
}) {
  return AgentAttachment(
    id: id,
    name: name,
    mime: mime,
    kind: attachmentKind(mime, name),
    size: size,
    text: text,
  );
}

void main() {
  group('attachmentKind — MIME first, extension second', () {
    test('MIME wins for image and audio', () {
      expect(
        attachmentKind('image/png', 'whatever.txt'),
        AgentAttachmentKind.image,
      );
      expect(
        attachmentKind('audio/mpeg', 'whatever.txt'),
        AgentAttachmentKind.audio,
      );
    });

    test('extension rescues a lying picker', () {
      // The reason the reference checks both: browsers report
      // `application/octet-stream` for ordinary files depending on the OS.
      expect(
        attachmentKind('application/octet-stream', 'export.csv'),
        AgentAttachmentKind.data,
      );
      expect(
        attachmentKind('application/octet-stream', 'report.pdf'),
        AgentAttachmentKind.document,
      );
      expect(
        attachmentKind('application/octet-stream', 'main.dart'),
        AgentAttachmentKind.other,
      );
      expect(
        attachmentKind('application/octet-stream', 'main.ts'),
        AgentAttachmentKind.code,
      );
    });

    test('the two MIME shortcuts for data', () {
      expect(
        attachmentKind('application/json', 'blob'),
        AgentAttachmentKind.data,
      );
      expect(attachmentKind('text/csv', 'blob'), AgentAttachmentKind.data);
    });

    test('anything else lands on other', () {
      expect(attachmentKind('text/plain', 'notes'), AgentAttachmentKind.other);
      expect(
        attachmentKind('application/x-tar', 'bundle'),
        AgentAttachmentKind.other,
      );
    });

    test('DRIFT: a dotless name IS its own extension', () {
      // `name.slice(name.lastIndexOf(".") + 1)` on a dotless name is
      // `slice(0)` — the whole name. So a file called exactly `pdf`, with no
      // extension at all, classifies as a document, and one called `csv`
      // classifies as data. Reproduced rather than corrected: the port matches
      // the reference's arithmetic, not its intent.
      expect(
        attachmentKind('application/octet-stream', 'pdf'),
        AgentAttachmentKind.document,
      );
      expect(
        attachmentKind('application/octet-stream', 'csv'),
        AgentAttachmentKind.data,
      );
      // A dotless name that matches no extension pattern still lands on other,
      // and nothing throws on the -1.
      expect(
        attachmentKind('application/octet-stream', 'README'),
        AgentAttachmentKind.other,
      );
    });

    test('the transcript build\'s alias resolves to the same function', () {
      expect(
        agentAttachmentKind('text/csv', 'a.csv'),
        attachmentKind('text/csv', 'a.csv'),
      );
    });
  });

  group('formatBytes — the reference ladder', () {
    test('bytes below 1 KiB', () {
      expect(formatBytes(0), '0 B');
      expect(formatBytes(1023), '1023 B');
    });

    test('rounded KB below 1 MiB', () {
      expect(formatBytes(1024), '1 KB');
      expect(formatBytes(18422), '18 KB');
      expect(formatBytes(184220), '180 KB');
      expect(formatBytes(4821), '5 KB');
    });

    test('MB to one decimal above', () {
      expect(formatBytes(2620000), '2.5 MB');
      expect(formatBytes(maxFileBytes), '25.0 MB');
    });
  });

  group('formatMs', () {
    test('milliseconds under a second, one decimal above', () {
      // The tool-chip fixtures on the transcript page.
      expect(formatMs(912), '912ms');
      expect(formatMs(1204), '1.2s');
      expect(formatMs(8004), '8.0s');
      expect(formatMs(999), '999ms');
      expect(formatMs(1000), '1.0s');
    });
  });

  group('humanise', () {
    test('underscores, dots and camelCase all become one sentence case', () {
      expect(humaniseToolName('search_inventory'), 'Search inventory');
      expect(humaniseToolName('fetch_market_price'), 'Fetch market price');
      expect(humaniseToolName('browser.navigate'), 'Browser navigate');
      expect(humaniseToolName('readWallet'), 'Read wallet');
      expect(humaniseToolName(''), '');
    });
  });

  group('isTextual', () {
    test('any text/* MIME, and JSON, regardless of kind', () {
      expect(isTextual(_file(name: 'a.png', mime: 'text/plain')), isTrue);
      expect(isTextual(_file(name: 'a.bin', mime: 'application/json')), isTrue);
    });

    test(
      'data, code and other are textual; image, document, audio are not',
      () {
        expect(isTextual(_file(name: 'a.csv', mime: 'text/csv')), isTrue);
        expect(
          isTextual(_file(name: 'a.ts', mime: 'application/octet-stream')),
          isTrue,
        );
        expect(
          isTextual(_file(name: 'a.pdf', mime: 'application/pdf')),
          isFalse,
        );
        expect(isTextual(_file(name: 'a.png', mime: 'image/png')), isFalse);
        expect(isTextual(_file(name: 'a.mp3', mime: 'audio/mpeg')), isFalse);
      },
    );
  });

  group('serialiseAttachments', () {
    test('no attachments is the identity', () {
      final SerialisedMessage out = serialiseAttachments(
        'hello',
        const <AgentAttachment>[],
      );
      expect(out.text, 'hello');
      expect(out.attachments, isEmpty);
    });

    test('a textual file is fenced and stamped content', () {
      final SerialisedMessage out = serialiseAttachments(
        'what is in here?',
        <AgentAttachment>[
          _file(name: 'export.csv', mime: 'text/csv', text: 'a,b\n1,2'),
        ],
      );
      expect(out.attachments.single.delivery!.sent, AgentDeliverySent.content);
      expect(
        out.text,
        'what is in here?\n\n'
        '<file name="export.csv" type="text/csv">\n'
        'a,b\n1,2\n'
        '</file>',
      );
    });

    test('a binary travels as a name and says why', () {
      final SerialisedMessage out = serialiseAttachments(
        'read this',
        <AgentAttachment>[
          _file(name: 'report.pdf', mime: 'application/pdf', size: 2620000),
        ],
      );
      final AgentDelivery delivery = out.attachments.single.delivery!;
      expect(delivery.sent, AgentDeliverySent.reference);
      expect(
        delivery.reason,
        'This file is not text, so its contents could not be inlined.',
      );
      expect(out.text, contains('<attached-but-not-readable>'));
      expect(out.text, contains('report.pdf (application/pdf, 2.5 MB)'));
      expect(
        out.text,
        endsWith(
          'The files above were attached by the user but their contents '
          'are not available to you. Ask the user to paste the relevant part '
          'if you need it.',
        ),
      );
    });

    test('an image with no reading gets its own reason', () {
      final SerialisedMessage out = serialiseAttachments(
        'look',
        <AgentAttachment>[_file(name: 'shot.png', mime: 'image/png')],
      );
      expect(
        out.attachments.single.delivery!.reason,
        "This agent's protocol carries text, so the image itself was not sent.",
      );
    });

    test('an image WITH a reading is fenced as <image>, not <file>', () {
      final SerialisedMessage out = serialiseAttachments(
        'look',
        <AgentAttachment>[
          _file(name: 'shot.png', mime: 'image/png', text: 'A blue circle.'),
        ],
      );
      expect(out.attachments.single.delivery!.sent, AgentDeliverySent.content);
      expect(
        out.text,
        contains(
          '<image name="shot.png" type="image/png">\n'
          'A vision model read this image on your behalf. Its reading follows.\n'
          'A blue circle.\n'
          '</image>',
        ),
      );
    });

    test('over the inline cap the fence declares the truncation', () {
      final String long = 'x' * (maxInlineChars + 10);
      final SerialisedMessage out = serialiseAttachments(
        'summarise',
        <AgentAttachment>[
          _file(name: 'big.csv', mime: 'text/csv', size: 999, text: long),
        ],
      );
      expect(out.text, contains('truncated="true" of-bytes="999"'));
      // Announced rather than done silently — and cut at exactly the cap.
      expect(out.text, contains('x' * maxInlineChars));
      expect(out.text.contains('x' * (maxInlineChars + 1)), isFalse);
    });

    test('attribute values are escaped', () {
      final SerialisedMessage out = serialiseAttachments('', <AgentAttachment>[
        _file(name: 'a&"b<c.csv', mime: 'text/csv', text: 'x'),
      ]);
      expect(out.text, contains('name="a&amp;&quot;b&lt;c.csv"'));
    });

    test(
      'mixed: readable and unreadable both appear, in the reference order',
      () {
        final SerialisedMessage out =
            serialiseAttachments('both', <AgentAttachment>[
              _file(id: '1', name: 'a.csv', mime: 'text/csv', text: 'x'),
              _file(id: '2', name: 'b.pdf', mime: 'application/pdf'),
            ]);
        expect(
          out.text.indexOf('<file'),
          lessThan(out.text.indexOf('<attached-but-not-readable>')),
        );
        expect(
          out.attachments.map((AgentAttachment a) => a.delivery!.sent),
          <AgentDeliverySent>[
            AgentDeliverySent.content,
            AgentDeliverySent.reference,
          ],
        );
      },
    );
  });

  group('stripProtocol', () {
    test('closed complete tags go, anywhere', () {
      expect(stripProtocol('<complete>done</complete>'), 'done');
      expect(stripProtocol('a<complete>b</complete>c'), 'abc');
    });

    test('a half-written tag at the very end goes', () {
      expect(stripProtocol('Checking the vault<comp'), 'Checking the vault');
      expect(stripProtocol('Checking<'), 'Checking');
    });

    test('a tag-like fragment mid-string stays', () {
      // The trailing anchor is the whole point: only the buffer's tail is a
      // partially-arrived tag.
      expect(stripProtocol('a < b and c'), 'a < b and c');
    });
  });

  group('relativeTime', () {
    // `Intl.RelativeTimeFormat(undefined, { numeric: "auto" })` — the `en`
    // output, which is what a reader of the reference actually sees. `auto` is
    // why one day is "yesterday" rather than "1 day ago".
    final DateTime now = DateTime(2026, 8, 16, 12);
    String at(Duration ago) => relativeTime(now.subtract(ago), now: now);

    test('under a minute is "just now", in both directions', () {
      expect(at(const Duration(seconds: 12)), 'just now');
      expect(at(const Duration(seconds: 59)), 'just now');
      expect(
        relativeTime(now.add(const Duration(seconds: 30)), now: now),
        'just now',
      );
    });

    test('the mock store\'s own seven offsets', () {
      expect(at(const Duration(minutes: 14)), '14 minutes ago');
      expect(at(const Duration(minutes: 95)), '2 hours ago');
      expect(at(const Duration(minutes: 260)), '4 hours ago');
      expect(at(const Duration(minutes: 1500)), 'yesterday');
      expect(at(const Duration(minutes: 4300)), '3 days ago');
      expect(at(const Duration(minutes: 11000)), 'last week');
      expect(at(const Duration(minutes: 26000)), '3 weeks ago');
    });

    test('numeric:"auto" replaces every singular', () {
      expect(at(const Duration(days: 1)), 'yesterday');
      expect(at(const Duration(days: 7)), 'last week');
      expect(at(const Duration(days: 30)), 'last month');
      expect(at(const Duration(days: 365)), 'last year');
    });
  });

  group('AgentState', () {
    test('twenty states, in the source\'s order', () {
      expect(AgentState.values.length, 20);
      expect(AgentState.values.first, AgentState.idle);
      expect(AgentState.values.last, AgentState.done);
    });

    test('the two snake_case wire spellings survive the Dart rename', () {
      expect(AgentState.awaitingApproval.wire, 'awaiting_approval');
      expect(AgentState.callingTools.wire, 'calling_tools');
      expect(AgentState.searching.wire, 'searching');
    });

    test('AGENT_STATE_LABEL, where the label is not the name', () {
      expect(AgentState.idle.label, 'Ready');
      expect(AgentState.retrieving.label, 'Retrieving knowledge');
      expect(AgentState.ingesting.label, 'Ingesting data');
      expect(AgentState.running.label, 'Running code');
      expect(AgentState.delegating.label, 'Delegating to agent');
      expect(AgentState.awaitingApproval.label, 'Awaiting approval');
      expect(AgentState.error.label, 'Something went wrong');
      expect(AgentState.callingTools.label, 'Calling tools');
      expect(AgentState.reading.label, 'Reading files');
      expect(AgentState.recalling.label, 'Recalling context');
    });

    test(
      'isBusy: the three resting states, and awaiting_approval is not one',
      () {
        expect(AgentState.idle.isBusy, isFalse);
        expect(AgentState.done.isBusy, isFalse);
        expect(AgentState.error.isBusy, isFalse);
        expect(AgentState.awaitingApproval.isBusy, isTrue);
        expect(AgentState.thinking.isBusy, isTrue);
      },
    );

    test('isNarrating: the three the model is emitting prose in', () {
      expect(
        AgentState.values.where((AgentState s) => s.isNarrating).toSet(),
        <AgentState>{
          AgentState.planning,
          AgentState.summarizing,
          AgentState.writing,
        },
      );
    });

    test('STATE_ICON: retrieving and reading deliberately share a glyph', () {
      expect(AgentState.retrieving.glyph, AgentState.reading.glyph);
    });

    test('the console build\'s top-level aliases agree with the members', () {
      for (final AgentState state in AgentState.values) {
        expect(agentStateLabel[state], state.label, reason: '$state');
        expect(agentStateId[state], state.wire, reason: '$state');
        expect(agentIsBusy(state), state.isBusy, reason: '$state');
        expect(agentIsNarrating(state), state.isNarrating, reason: '$state');
      }
      expect(agentStateLabel.length, AgentState.values.length);
    });

    test(
      'DRIFT: the labels carry no ellipsis, though the comment promises one',
      () {
        // `states.ts` L43: "Present participles with an ellipsis for anything
        // ongoing". Not one label has one. Reproduced as written.
        for (final AgentState state in AgentState.values) {
          expect(state.label.contains('…'), isFalse, reason: state.label);
        }
      },
    );
  });

  group('stateForTool — exact, then longest prefix', () {
    const ToolStateMap map = <String, AgentState>{
      'search_inventory': AgentState.searching,
      'finance.': AgentState.retrieving,
      'finance.forecast.': AgentState.writing,
    };

    test('no map is no answer', () {
      expect(stateForTool('anything', null), isNull);
    });

    test('exact beats everything', () {
      expect(stateForTool('search_inventory', map), AgentState.searching);
    });

    test('longest prefix wins regardless of declaration order', () {
      expect(stateForTool('finance.forecast.q3', map), AgentState.writing);
      expect(stateForTool('finance.ledger', map), AgentState.retrieving);
    });

    test('a prefix key must end on a . or _ boundary', () {
      // `finance` without the dot is not a prefix key at all.
      expect(
        stateForTool('financials', const <String, AgentState>{
          'finance': AgentState.retrieving,
        }),
        isNull,
      );
    });

    test('an unmapped name is null, never a guess', () {
      expect(stateForTool('format_hard_drive', map), isNull);
    });

    test('the console build\'s alias resolves to the same function', () {
      expect(
        agentStateForTool('finance.ledger', map),
        stateForTool('finance.ledger', map),
      );
    });
  });

  group('resolveState — the ladder, in order', () {
    AgentState resolve(
      List<AgentTurn> turns, {
      AgentSignals signals = const AgentSignals(),
      ToolStateMap? toolStates,
    }) {
      return resolveAgentState(
        turns: turns,
        signals: signals,
        toolStates: toolStates,
      );
    }

    ToolTurn tool(
      String name, {
      AgentTurnStatus status = AgentTurnStatus.running,
      int attempt = 1,
      String id = 't',
    }) {
      return ToolTurn(
        id: id,
        name: name,
        params: const <String, Object?>{},
        status: status,
        attempt: attempt,
      );
    }

    test('0. a declared state short-circuits the whole ladder', () {
      expect(
        resolve(<AgentTurn>[
          const ErrorTurn(id: 'e', message: 'x', fatal: true),
        ], signals: const AgentSignals(declared: AgentState.recalling)),
        AgentState.recalling,
      );
    });

    test('1. a FATAL error outranks a running tool', () {
      // Order proof: the tool branch is #3 and would otherwise win.
      expect(
        resolve(<AgentTurn>[
          tool('search_inventory'),
          const ErrorTurn(id: 'e', message: 'x', fatal: true),
        ]),
        AgentState.error,
      );
    });

    test('1b. a NON-fatal error does not — the agent recovers from those', () {
      expect(
        resolve(<AgentTurn>[
          const ErrorTurn(id: 'e', message: 'x', fatal: false),
        ]),
        AgentState.done,
      );
    });

    test('2. a pending approval outranks a running tool', () {
      expect(
        resolve(<AgentTurn>[
          const ActionTurn(
            id: 'a',
            action: 'purchase_pack',
            params: <String, Object?>{},
            status: AgentTurnStatus.running,
            approval: ApprovalOutcome.pending,
          ),
          tool('search_inventory'),
        ]),
        AgentState.awaitingApproval,
      );
    });

    test('3. a running tool resolves through the caller map', () {
      expect(
        resolve(
          <AgentTurn>[tool('search_inventory')],
          toolStates: const <String, AgentState>{
            'search_inventory': AgentState.searching,
          },
        ),
        AgentState.searching,
      );
    });

    test('3b. an unmapped running tool is the honest fallback', () {
      expect(resolve(<AgentTurn>[tool('mystery')]), AgentState.callingTools);
    });

    test('3c. a retry is a retry FIRST and whatever it does second', () {
      expect(
        resolve(
          <AgentTurn>[tool('search_inventory', attempt: 2)],
          toolStates: const <String, AgentState>{
            'search_inventory': AgentState.searching,
          },
        ),
        AgentState.retrying,
      );
    });

    test('4. a running action is processing', () {
      expect(
        resolve(<AgentTurn>[
          const ActionTurn(
            id: 'a',
            action: 'click',
            params: <String, Object?>{},
            status: AgentTurnStatus.running,
          ),
        ]),
        AgentState.processing,
      );
    });

    test('5. prose before any work in this turn is planning', () {
      expect(
        resolve(<AgentTurn>[
          const UserTurn(id: 'u', text: 'hi'),
          const TextTurn(id: 't', text: 'Let me look', streaming: true),
        ]),
        AgentState.planning,
      );
    });

    test('5b. prose after a settled tool in this turn is summarizing', () {
      expect(
        resolve(<AgentTurn>[
          const UserTurn(id: 'u', text: 'hi'),
          tool('search_inventory', status: AgentTurnStatus.ok),
          const TextTurn(id: 't', text: 'I found', streaming: true),
        ]),
        AgentState.summarizing,
      );
    });

    test(
      '5c. the scan stops at the user turn — prior turns do not leak in',
      () {
        expect(
          resolve(<AgentTurn>[
            tool('search_inventory', status: AgentTurnStatus.ok, id: 'old'),
            const UserTurn(id: 'u', text: 'again'),
            const TextTurn(id: 't', text: 'Let me look', streaming: true),
          ]),
          AgentState.planning,
        );
      },
    );

    test('6. sent, nothing back yet is queued — not thinking', () {
      expect(
        resolve(
          const <AgentTurn>[],
          signals: const AgentSignals(
            awaitingFirstEvent: true,
            isLoading: true,
          ),
        ),
        AgentState.queued,
      );
    });

    test('7. loading with nothing else to say is thinking', () {
      expect(
        resolve(
          const <AgentTurn>[],
          signals: const AgentSignals(isLoading: true),
        ),
        AgentState.thinking,
      );
    });

    test('8. a settled last turn is done', () {
      expect(
        resolve(<AgentTurn>[const TextTurn(id: 't', text: 'Here you are')]),
        AgentState.done,
      );
    });

    test(
      '8b. a user turn is not settled work — an empty-handed send is idle',
      () {
        expect(
          resolve(<AgentTurn>[const UserTurn(id: 'u', text: 'hi')]),
          AgentState.idle,
        );
      },
    );

    test('an empty transcript with no signals is idle', () {
      expect(resolve(const <AgentTurn>[]), AgentState.idle);
    });
  });

  group('BlurSwitchController', () {
    test('the two measured legs, and the store call in the middle', () {
      expect(BlurSwitchController.outDuration, MotionDurations.fast);
      expect(BlurSwitchController.inDuration, MotionDurations.normal);
      expect(BlurSwitchController.outDuration.inMilliseconds, 150);
      expect(BlurSwitchController.inDuration.inMilliseconds, 250);
    });

    testWidgets('blurs out, swaps at the darkest point, blurs in', (
      WidgetTester tester,
    ) async {
      final List<String> opened = <String>[];
      final BlurSwitchController controller = BlurSwitchController(
        open: opened.add,
      );
      addTearDown(controller.dispose);

      expect(controller.phase, SwitchPhase.idle);

      controller.switchTo('c-export');
      expect(controller.phase, SwitchPhase.out);
      // THE point of the hook: the store has not been called yet. Calling it
      // now would blur the *new* conversation out and then back in.
      expect(opened, isEmpty);

      await tester.pump(BlurSwitchController.outDuration);
      expect(opened, <String>['c-export']);
      expect(controller.phase, SwitchPhase.blurIn);

      await tester.pump(BlurSwitchController.inDuration);
      expect(controller.phase, SwitchPhase.idle);
    });

    testWidgets('a second switch supersedes the first', (
      WidgetTester tester,
    ) async {
      final List<String> opened = <String>[];
      final BlurSwitchController controller = BlurSwitchController(
        open: opened.add,
      );
      addTearDown(controller.dispose);

      controller.switchTo('a');
      await tester.pump(const Duration(milliseconds: 100));
      controller.switchTo('b');
      await tester.pump(BlurSwitchController.outDuration);
      // The first sequence's deferred `open` is dropped, not replayed.
      expect(opened, <String>['b']);
      await tester.pump(BlurSwitchController.inDuration);
      expect(controller.phase, SwitchPhase.idle);
      expect(opened, <String>['b']);
    });

    test('blurClass maps each phase to its utility', () {
      expect(SwitchPhase.out.className, 'anim-blur-out');
      expect(SwitchPhase.blurIn.className, 'anim-blur-in');
      expect(SwitchPhase.idle.className, '');
    });
  });

  group('Clock seam', () {
    testWidgets('relativeTime reads the injected instant, not the wall clock', (
      WidgetTester tester,
    ) async {
      final DateTime frozen = DateTime(2026, 8, 16, 12);
      late String rendered;

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Clock(
            now: frozen,
            child: Builder(
              builder: (BuildContext context) {
                rendered = relativeTimeOf(
                  context,
                  frozen.subtract(const Duration(minutes: 14)),
                );
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      expect(rendered, '14 minutes ago');
    });
  });

  group('conversations', () {
    test('copyWith moves only title and pinned', () {
      final DateTime stamp = DateTime(2026, 8, 16, 12);
      const String preview = 'What sealed boxes are left?';
      final ConversationSummary base = ConversationSummary(
        id: 'c1',
        title: 'Sealed inventory check',
        updatedAt: stamp,
        preview: preview,
      );

      final ConversationSummary renamed = base.copyWith(title: 'Renamed');
      expect(renamed.title, 'Renamed');
      expect(renamed.id, 'c1');
      expect(renamed.updatedAt, stamp);
      expect(renamed.preview, preview);
      expect(renamed.pinned, isFalse);

      expect(base.copyWith(pinned: true).pinned, isTrue);
      // The original is untouched — the store replaces entries, never mutates.
      expect(base.title, 'Sealed inventory check');
      expect(base.pinned, isFalse);
    });
  });
}
