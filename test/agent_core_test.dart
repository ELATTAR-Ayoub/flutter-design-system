import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';
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

DsAgentAttachment _file({
  String id = 'a1',
  required String name,
  required String mime,
  int size = 1024,
  String? text,
}) {
  return DsAgentAttachment(
    id: id,
    name: name,
    mime: mime,
    kind: dsAttachmentKind(mime, name),
    size: size,
    text: text,
  );
}

void main() {
  group('attachmentKind — MIME first, extension second', () {
    test('MIME wins for image and audio', () {
      expect(dsAttachmentKind('image/png', 'whatever.txt'),
          DsAgentAttachmentKind.image);
      expect(dsAttachmentKind('audio/mpeg', 'whatever.txt'),
          DsAgentAttachmentKind.audio);
    });

    test('extension rescues a lying picker', () {
      // The reason the reference checks both: browsers report
      // `application/octet-stream` for ordinary files depending on the OS.
      expect(dsAttachmentKind('application/octet-stream', 'export.csv'),
          DsAgentAttachmentKind.data);
      expect(dsAttachmentKind('application/octet-stream', 'report.pdf'),
          DsAgentAttachmentKind.document);
      expect(dsAttachmentKind('application/octet-stream', 'main.dart'),
          DsAgentAttachmentKind.other);
      expect(dsAttachmentKind('application/octet-stream', 'main.ts'),
          DsAgentAttachmentKind.code);
    });

    test('the two MIME shortcuts for data', () {
      expect(dsAttachmentKind('application/json', 'blob'),
          DsAgentAttachmentKind.data);
      expect(dsAttachmentKind('text/csv', 'blob'), DsAgentAttachmentKind.data);
    });

    test('anything else lands on other', () {
      expect(dsAttachmentKind('text/plain', 'notes'),
          DsAgentAttachmentKind.other);
      expect(dsAttachmentKind('application/x-tar', 'bundle'),
          DsAgentAttachmentKind.other);
    });

    test('DRIFT: a dotless name IS its own extension', () {
      // `name.slice(name.lastIndexOf(".") + 1)` on a dotless name is
      // `slice(0)` — the whole name. So a file called exactly `pdf`, with no
      // extension at all, classifies as a document, and one called `csv`
      // classifies as data. Reproduced rather than corrected: the port matches
      // the reference's arithmetic, not its intent.
      expect(dsAttachmentKind('application/octet-stream', 'pdf'),
          DsAgentAttachmentKind.document);
      expect(dsAttachmentKind('application/octet-stream', 'csv'),
          DsAgentAttachmentKind.data);
      // A dotless name that matches no extension pattern still lands on other,
      // and nothing throws on the -1.
      expect(dsAttachmentKind('application/octet-stream', 'README'),
          DsAgentAttachmentKind.other);
    });

    test('the transcript build\'s alias resolves to the same function', () {
      expect(dsAgentAttachmentKind('text/csv', 'a.csv'),
          dsAttachmentKind('text/csv', 'a.csv'));
    });
  });

  group('formatBytes — the reference ladder', () {
    test('bytes below 1 KiB', () {
      expect(dsFormatBytes(0), '0 B');
      expect(dsFormatBytes(1023), '1023 B');
    });

    test('rounded KB below 1 MiB', () {
      expect(dsFormatBytes(1024), '1 KB');
      expect(dsFormatBytes(18422), '18 KB');
      expect(dsFormatBytes(184220), '180 KB');
      expect(dsFormatBytes(4821), '5 KB');
    });

    test('MB to one decimal above', () {
      expect(dsFormatBytes(2620000), '2.5 MB');
      expect(dsFormatBytes(kDsMaxFileBytes), '25.0 MB');
    });
  });

  group('formatMs', () {
    test('milliseconds under a second, one decimal above', () {
      // The tool-chip fixtures on the transcript page.
      expect(dsFormatMs(912), '912ms');
      expect(dsFormatMs(1204), '1.2s');
      expect(dsFormatMs(8004), '8.0s');
      expect(dsFormatMs(999), '999ms');
      expect(dsFormatMs(1000), '1.0s');
    });
  });

  group('humanise', () {
    test('underscores, dots and camelCase all become one sentence case', () {
      expect(dsHumaniseToolName('search_inventory'), 'Search inventory');
      expect(dsHumaniseToolName('fetch_market_price'), 'Fetch market price');
      expect(dsHumaniseToolName('browser.navigate'), 'Browser navigate');
      expect(dsHumaniseToolName('readWallet'), 'Read wallet');
      expect(dsHumaniseToolName(''), '');
    });
  });

  group('isTextual', () {
    test('any text/* MIME, and JSON, regardless of kind', () {
      expect(dsIsTextual(_file(name: 'a.png', mime: 'text/plain')), isTrue);
      expect(
          dsIsTextual(_file(name: 'a.bin', mime: 'application/json')), isTrue);
    });

    test('data, code and other are textual; image, document, audio are not', () {
      expect(dsIsTextual(_file(name: 'a.csv', mime: 'text/csv')), isTrue);
      expect(dsIsTextual(_file(name: 'a.ts', mime: 'application/octet-stream')),
          isTrue);
      expect(dsIsTextual(_file(name: 'a.pdf', mime: 'application/pdf')),
          isFalse);
      expect(dsIsTextual(_file(name: 'a.png', mime: 'image/png')), isFalse);
      expect(dsIsTextual(_file(name: 'a.mp3', mime: 'audio/mpeg')), isFalse);
    });
  });

  group('serialiseAttachments', () {
    test('no attachments is the identity', () {
      final DsSerialisedMessage out =
          dsSerialiseAttachments('hello', const <DsAgentAttachment>[]);
      expect(out.text, 'hello');
      expect(out.attachments, isEmpty);
    });

    test('a textual file is fenced and stamped content', () {
      final DsSerialisedMessage out = dsSerialiseAttachments(
        'what is in here?',
        <DsAgentAttachment>[
          _file(name: 'export.csv', mime: 'text/csv', text: 'a,b\n1,2'),
        ],
      );
      expect(out.attachments.single.delivery!.sent, DsAgentDeliverySent.content);
      expect(
        out.text,
        'what is in here?\n\n'
        '<file name="export.csv" type="text/csv">\n'
        'a,b\n1,2\n'
        '</file>',
      );
    });

    test('a binary travels as a name and says why', () {
      final DsSerialisedMessage out = dsSerialiseAttachments(
        'read this',
        <DsAgentAttachment>[
          _file(name: 'report.pdf', mime: 'application/pdf', size: 2620000),
        ],
      );
      final DsAgentDelivery delivery = out.attachments.single.delivery!;
      expect(delivery.sent, DsAgentDeliverySent.reference);
      expect(delivery.reason,
          'This file is not text, so its contents could not be inlined.');
      expect(out.text, contains('<attached-but-not-readable>'));
      expect(out.text, contains('report.pdf (application/pdf, 2.5 MB)'));
      expect(
        out.text,
        endsWith('The files above were attached by the user but their contents '
            'are not available to you. Ask the user to paste the relevant part '
            'if you need it.'),
      );
    });

    test('an image with no reading gets its own reason', () {
      final DsSerialisedMessage out = dsSerialiseAttachments(
        'look',
        <DsAgentAttachment>[_file(name: 'shot.png', mime: 'image/png')],
      );
      expect(
        out.attachments.single.delivery!.reason,
        "This agent's protocol carries text, so the image itself was not sent.",
      );
    });

    test('an image WITH a reading is fenced as <image>, not <file>', () {
      final DsSerialisedMessage out = dsSerialiseAttachments(
        'look',
        <DsAgentAttachment>[
          _file(name: 'shot.png', mime: 'image/png', text: 'A blue circle.'),
        ],
      );
      expect(out.attachments.single.delivery!.sent, DsAgentDeliverySent.content);
      expect(
        out.text,
        contains('<image name="shot.png" type="image/png">\n'
            'A vision model read this image on your behalf. Its reading follows.\n'
            'A blue circle.\n'
            '</image>'),
      );
    });

    test('over the inline cap the fence declares the truncation', () {
      final String long = 'x' * (kDsMaxInlineChars + 10);
      final DsSerialisedMessage out = dsSerialiseAttachments(
        'summarise',
        <DsAgentAttachment>[
          _file(name: 'big.csv', mime: 'text/csv', size: 999, text: long),
        ],
      );
      expect(out.text, contains('truncated="true" of-bytes="999"'));
      // Announced rather than done silently — and cut at exactly the cap.
      expect(out.text, contains('x' * kDsMaxInlineChars));
      expect(out.text.contains('x' * (kDsMaxInlineChars + 1)), isFalse);
    });

    test('attribute values are escaped', () {
      final DsSerialisedMessage out = dsSerialiseAttachments(
        '',
        <DsAgentAttachment>[
          _file(name: 'a&"b<c.csv', mime: 'text/csv', text: 'x'),
        ],
      );
      expect(out.text, contains('name="a&amp;&quot;b&lt;c.csv"'));
    });

    test('mixed: readable and unreadable both appear, in the reference order',
        () {
      final DsSerialisedMessage out = dsSerialiseAttachments(
        'both',
        <DsAgentAttachment>[
          _file(id: '1', name: 'a.csv', mime: 'text/csv', text: 'x'),
          _file(id: '2', name: 'b.pdf', mime: 'application/pdf'),
        ],
      );
      expect(out.text.indexOf('<file'),
          lessThan(out.text.indexOf('<attached-but-not-readable>')));
      expect(
        out.attachments.map((DsAgentAttachment a) => a.delivery!.sent),
        <DsAgentDeliverySent>[
          DsAgentDeliverySent.content,
          DsAgentDeliverySent.reference,
        ],
      );
    });
  });

  group('stripProtocol', () {
    test('closed complete tags go, anywhere', () {
      expect(dsStripProtocol('<complete>done</complete>'), 'done');
      expect(dsStripProtocol('a<complete>b</complete>c'), 'abc');
    });

    test('a half-written tag at the very end goes', () {
      expect(dsStripProtocol('Checking the vault<comp'), 'Checking the vault');
      expect(dsStripProtocol('Checking<'), 'Checking');
    });

    test('a tag-like fragment mid-string stays', () {
      // The trailing anchor is the whole point: only the buffer's tail is a
      // partially-arrived tag.
      expect(dsStripProtocol('a < b and c'), 'a < b and c');
    });
  });

  group('relativeTime', () {
    // `Intl.RelativeTimeFormat(undefined, { numeric: "auto" })` — the `en`
    // output, which is what a reader of the reference actually sees. `auto` is
    // why one day is "yesterday" rather than "1 day ago".
    final DateTime now = DateTime(2026, 8, 16, 12);
    String at(Duration ago) => dsRelativeTime(now.subtract(ago), now: now);

    test('under a minute is "just now", in both directions', () {
      expect(at(const Duration(seconds: 12)), 'just now');
      expect(at(const Duration(seconds: 59)), 'just now');
      expect(dsRelativeTime(now.add(const Duration(seconds: 30)), now: now),
          'just now');
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

  group('DsAgentState', () {
    test('twenty states, in the source\'s order', () {
      expect(DsAgentState.values.length, 20);
      expect(DsAgentState.values.first, DsAgentState.idle);
      expect(DsAgentState.values.last, DsAgentState.done);
    });

    test('the two snake_case wire spellings survive the Dart rename', () {
      expect(DsAgentState.awaitingApproval.wire, 'awaiting_approval');
      expect(DsAgentState.callingTools.wire, 'calling_tools');
      expect(DsAgentState.searching.wire, 'searching');
    });

    test('AGENT_STATE_LABEL, where the label is not the name', () {
      expect(DsAgentState.idle.label, 'Ready');
      expect(DsAgentState.retrieving.label, 'Retrieving knowledge');
      expect(DsAgentState.ingesting.label, 'Ingesting data');
      expect(DsAgentState.running.label, 'Running code');
      expect(DsAgentState.delegating.label, 'Delegating to agent');
      expect(DsAgentState.awaitingApproval.label, 'Awaiting approval');
      expect(DsAgentState.error.label, 'Something went wrong');
      expect(DsAgentState.callingTools.label, 'Calling tools');
      expect(DsAgentState.reading.label, 'Reading files');
      expect(DsAgentState.recalling.label, 'Recalling context');
    });

    test('isBusy: the three resting states, and awaiting_approval is not one',
        () {
      expect(DsAgentState.idle.isBusy, isFalse);
      expect(DsAgentState.done.isBusy, isFalse);
      expect(DsAgentState.error.isBusy, isFalse);
      expect(DsAgentState.awaitingApproval.isBusy, isTrue);
      expect(DsAgentState.thinking.isBusy, isTrue);
    });

    test('isNarrating: the three the model is emitting prose in', () {
      expect(
        DsAgentState.values.where((DsAgentState s) => s.isNarrating).toSet(),
        <DsAgentState>{
          DsAgentState.planning,
          DsAgentState.summarizing,
          DsAgentState.writing,
        },
      );
    });

    test('STATE_ICON: retrieving and reading deliberately share a glyph', () {
      expect(DsAgentState.retrieving.glyph, DsAgentState.reading.glyph);
    });

    test('the console build\'s top-level aliases agree with the members', () {
      for (final DsAgentState state in DsAgentState.values) {
        expect(kDsAgentStateLabel[state], state.label, reason: '$state');
        expect(kDsAgentStateId[state], state.wire, reason: '$state');
        expect(dsAgentIsBusy(state), state.isBusy, reason: '$state');
        expect(dsAgentIsNarrating(state), state.isNarrating, reason: '$state');
      }
      expect(kDsAgentStateLabel.length, DsAgentState.values.length);
    });

    test('DRIFT: the labels carry no ellipsis, though the comment promises one',
        () {
      // `states.ts` L43: "Present participles with an ellipsis for anything
      // ongoing". Not one label has one. Reproduced as written.
      for (final DsAgentState state in DsAgentState.values) {
        expect(state.label.contains('…'), isFalse, reason: state.label);
      }
    });
  });

  group('stateForTool — exact, then longest prefix', () {
    const DsToolStateMap map = <String, DsAgentState>{
      'search_inventory': DsAgentState.searching,
      'finance.': DsAgentState.retrieving,
      'finance.forecast.': DsAgentState.writing,
    };

    test('no map is no answer', () {
      expect(dsStateForTool('anything', null), isNull);
    });

    test('exact beats everything', () {
      expect(dsStateForTool('search_inventory', map), DsAgentState.searching);
    });

    test('longest prefix wins regardless of declaration order', () {
      expect(
          dsStateForTool('finance.forecast.q3', map), DsAgentState.writing);
      expect(dsStateForTool('finance.ledger', map), DsAgentState.retrieving);
    });

    test('a prefix key must end on a . or _ boundary', () {
      // `finance` without the dot is not a prefix key at all.
      expect(
        dsStateForTool('financials', const <String, DsAgentState>{
          'finance': DsAgentState.retrieving,
        }),
        isNull,
      );
    });

    test('an unmapped name is null, never a guess', () {
      expect(dsStateForTool('format_hard_drive', map), isNull);
    });

    test('the console build\'s alias resolves to the same function', () {
      expect(dsAgentStateForTool('finance.ledger', map),
          dsStateForTool('finance.ledger', map));
    });
  });

  group('resolveState — the ladder, in order', () {
    DsAgentState resolve(
      List<DsAgentTurn> turns, {
      DsAgentSignals signals = const DsAgentSignals(),
      DsToolStateMap? toolStates,
    }) {
      return dsResolveAgentState(
        turns: turns,
        signals: signals,
        toolStates: toolStates,
      );
    }

    DsToolTurn tool(
      String name, {
      DsAgentTurnStatus status = DsAgentTurnStatus.running,
      int attempt = 1,
      String id = 't',
    }) {
      return DsToolTurn(
        id: id,
        name: name,
        params: const <String, Object?>{},
        status: status,
        attempt: attempt,
      );
    }

    test('0. a declared state short-circuits the whole ladder', () {
      expect(
        resolve(
          <DsAgentTurn>[
            const DsErrorTurn(id: 'e', message: 'x', fatal: true),
          ],
          signals: const DsAgentSignals(declared: DsAgentState.recalling),
        ),
        DsAgentState.recalling,
      );
    });

    test('1. a FATAL error outranks a running tool', () {
      // Order proof: the tool branch is #3 and would otherwise win.
      expect(
        resolve(<DsAgentTurn>[
          tool('search_inventory'),
          const DsErrorTurn(id: 'e', message: 'x', fatal: true),
        ]),
        DsAgentState.error,
      );
    });

    test('1b. a NON-fatal error does not — the agent recovers from those', () {
      expect(
        resolve(<DsAgentTurn>[
          const DsErrorTurn(id: 'e', message: 'x', fatal: false),
        ]),
        DsAgentState.done,
      );
    });

    test('2. a pending approval outranks a running tool', () {
      expect(
        resolve(<DsAgentTurn>[
          const DsActionTurn(
            id: 'a',
            action: 'purchase_pack',
            params: <String, Object?>{},
            status: DsAgentTurnStatus.running,
            approval: DsApprovalOutcome.pending,
          ),
          tool('search_inventory'),
        ]),
        DsAgentState.awaitingApproval,
      );
    });

    test('3. a running tool resolves through the caller map', () {
      expect(
        resolve(
          <DsAgentTurn>[tool('search_inventory')],
          toolStates: const <String, DsAgentState>{
            'search_inventory': DsAgentState.searching,
          },
        ),
        DsAgentState.searching,
      );
    });

    test('3b. an unmapped running tool is the honest fallback', () {
      expect(resolve(<DsAgentTurn>[tool('mystery')]), DsAgentState.callingTools);
    });

    test('3c. a retry is a retry FIRST and whatever it does second', () {
      expect(
        resolve(
          <DsAgentTurn>[tool('search_inventory', attempt: 2)],
          toolStates: const <String, DsAgentState>{
            'search_inventory': DsAgentState.searching,
          },
        ),
        DsAgentState.retrying,
      );
    });

    test('4. a running action is processing', () {
      expect(
        resolve(<DsAgentTurn>[
          const DsActionTurn(
            id: 'a',
            action: 'click',
            params: <String, Object?>{},
            status: DsAgentTurnStatus.running,
          ),
        ]),
        DsAgentState.processing,
      );
    });

    test('5. prose before any work in this turn is planning', () {
      expect(
        resolve(<DsAgentTurn>[
          const DsUserTurn(id: 'u', text: 'hi'),
          const DsTextTurn(id: 't', text: 'Let me look', streaming: true),
        ]),
        DsAgentState.planning,
      );
    });

    test('5b. prose after a settled tool in this turn is summarizing', () {
      expect(
        resolve(<DsAgentTurn>[
          const DsUserTurn(id: 'u', text: 'hi'),
          tool('search_inventory', status: DsAgentTurnStatus.ok),
          const DsTextTurn(id: 't', text: 'I found', streaming: true),
        ]),
        DsAgentState.summarizing,
      );
    });

    test('5c. the scan stops at the user turn — prior turns do not leak in', () {
      expect(
        resolve(<DsAgentTurn>[
          tool('search_inventory', status: DsAgentTurnStatus.ok, id: 'old'),
          const DsUserTurn(id: 'u', text: 'again'),
          const DsTextTurn(id: 't', text: 'Let me look', streaming: true),
        ]),
        DsAgentState.planning,
      );
    });

    test('6. sent, nothing back yet is queued — not thinking', () {
      expect(
        resolve(
          const <DsAgentTurn>[],
          signals: const DsAgentSignals(
            awaitingFirstEvent: true,
            isLoading: true,
          ),
        ),
        DsAgentState.queued,
      );
    });

    test('7. loading with nothing else to say is thinking', () {
      expect(
        resolve(const <DsAgentTurn>[],
            signals: const DsAgentSignals(isLoading: true)),
        DsAgentState.thinking,
      );
    });

    test('8. a settled last turn is done', () {
      expect(
        resolve(<DsAgentTurn>[
          const DsTextTurn(id: 't', text: 'Here you are'),
        ]),
        DsAgentState.done,
      );
    });

    test('8b. a user turn is not settled work — an empty-handed send is idle',
        () {
      expect(
        resolve(<DsAgentTurn>[const DsUserTurn(id: 'u', text: 'hi')]),
        DsAgentState.idle,
      );
    });

    test('an empty transcript with no signals is idle', () {
      expect(resolve(const <DsAgentTurn>[]), DsAgentState.idle);
    });
  });

  group('DsBlurSwitchController', () {
    test('the two measured legs, and the store call in the middle', () {
      expect(DsBlurSwitchController.outDuration, DsDurations.fast);
      expect(DsBlurSwitchController.inDuration, DsDurations.base);
      expect(DsBlurSwitchController.outDuration.inMilliseconds, 150);
      expect(DsBlurSwitchController.inDuration.inMilliseconds, 250);
    });

    testWidgets('blurs out, swaps at the darkest point, blurs in',
        (WidgetTester tester) async {
      final List<String> opened = <String>[];
      final DsBlurSwitchController controller =
          DsBlurSwitchController(open: opened.add);
      addTearDown(controller.dispose);

      expect(controller.phase, DsSwitchPhase.idle);

      controller.switchTo('c-export');
      expect(controller.phase, DsSwitchPhase.out);
      // THE point of the hook: the store has not been called yet. Calling it
      // now would blur the *new* conversation out and then back in.
      expect(opened, isEmpty);

      await tester.pump(DsBlurSwitchController.outDuration);
      expect(opened, <String>['c-export']);
      expect(controller.phase, DsSwitchPhase.blurIn);

      await tester.pump(DsBlurSwitchController.inDuration);
      expect(controller.phase, DsSwitchPhase.idle);
    });

    testWidgets('a second switch supersedes the first',
        (WidgetTester tester) async {
      final List<String> opened = <String>[];
      final DsBlurSwitchController controller =
          DsBlurSwitchController(open: opened.add);
      addTearDown(controller.dispose);

      controller.switchTo('a');
      await tester.pump(const Duration(milliseconds: 100));
      controller.switchTo('b');
      await tester.pump(DsBlurSwitchController.outDuration);
      // The first sequence's deferred `open` is dropped, not replayed.
      expect(opened, <String>['b']);
      await tester.pump(DsBlurSwitchController.inDuration);
      expect(controller.phase, DsSwitchPhase.idle);
      expect(opened, <String>['b']);
    });

    test('blurClass maps each phase to its utility', () {
      expect(DsSwitchPhase.out.className, 'anim-blur-out');
      expect(DsSwitchPhase.blurIn.className, 'anim-blur-in');
      expect(DsSwitchPhase.idle.className, '');
    });
  });

  group('DsClock seam', () {
    testWidgets('relativeTime reads the injected instant, not the wall clock',
        (WidgetTester tester) async {
      final DateTime frozen = DateTime(2026, 8, 16, 12);
      late String rendered;

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: DsClock(
            now: frozen,
            child: Builder(
              builder: (BuildContext context) {
                rendered = dsRelativeTimeOf(
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
      final DsConversationSummary base = DsConversationSummary(
        id: 'c1',
        title: 'Sealed inventory check',
        updatedAt: stamp,
        preview: preview,
      );

      final DsConversationSummary renamed = base.copyWith(title: 'Renamed');
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
