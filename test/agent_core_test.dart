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

ElAgentAttachment _file({
  String id = 'a1',
  required String name,
  required String mime,
  int size = 1024,
  String? text,
}) {
  return ElAgentAttachment(
    id: id,
    name: name,
    mime: mime,
    kind: elAttachmentKind(mime, name),
    size: size,
    text: text,
  );
}

void main() {
  group('attachmentKind — MIME first, extension second', () {
    test('MIME wins for image and audio', () {
      expect(
        elAttachmentKind('image/png', 'whatever.txt'),
        ElAgentAttachmentKind.image,
      );
      expect(
        elAttachmentKind('audio/mpeg', 'whatever.txt'),
        ElAgentAttachmentKind.audio,
      );
    });

    test('extension rescues a lying picker', () {
      // The reason the reference checks both: browsers report
      // `application/octet-stream` for ordinary files depending on the OS.
      expect(
        elAttachmentKind('application/octet-stream', 'export.csv'),
        ElAgentAttachmentKind.data,
      );
      expect(
        elAttachmentKind('application/octet-stream', 'report.pdf'),
        ElAgentAttachmentKind.document,
      );
      expect(
        elAttachmentKind('application/octet-stream', 'main.dart'),
        ElAgentAttachmentKind.other,
      );
      expect(
        elAttachmentKind('application/octet-stream', 'main.ts'),
        ElAgentAttachmentKind.code,
      );
    });

    test('the two MIME shortcuts for data', () {
      expect(
        elAttachmentKind('application/json', 'blob'),
        ElAgentAttachmentKind.data,
      );
      expect(elAttachmentKind('text/csv', 'blob'), ElAgentAttachmentKind.data);
    });

    test('anything else lands on other', () {
      expect(
        elAttachmentKind('text/plain', 'notes'),
        ElAgentAttachmentKind.other,
      );
      expect(
        elAttachmentKind('application/x-tar', 'bundle'),
        ElAgentAttachmentKind.other,
      );
    });

    test('DRIFT: a dotless name IS its own extension', () {
      // `name.slice(name.lastIndexOf(".") + 1)` on a dotless name is
      // `slice(0)` — the whole name. So a file called exactly `pdf`, with no
      // extension at all, classifies as a document, and one called `csv`
      // classifies as data. Reproduced rather than corrected: the port matches
      // the reference's arithmetic, not its intent.
      expect(
        elAttachmentKind('application/octet-stream', 'pdf'),
        ElAgentAttachmentKind.document,
      );
      expect(
        elAttachmentKind('application/octet-stream', 'csv'),
        ElAgentAttachmentKind.data,
      );
      // A dotless name that matches no extension pattern still lands on other,
      // and nothing throws on the -1.
      expect(
        elAttachmentKind('application/octet-stream', 'README'),
        ElAgentAttachmentKind.other,
      );
    });

    test('the transcript build\'s alias resolves to the same function', () {
      expect(
        elAgentAttachmentKind('text/csv', 'a.csv'),
        elAttachmentKind('text/csv', 'a.csv'),
      );
    });
  });

  group('formatBytes — the reference ladder', () {
    test('bytes below 1 KiB', () {
      expect(elFormatBytes(0), '0 B');
      expect(elFormatBytes(1023), '1023 B');
    });

    test('rounded KB below 1 MiB', () {
      expect(elFormatBytes(1024), '1 KB');
      expect(elFormatBytes(18422), '18 KB');
      expect(elFormatBytes(184220), '180 KB');
      expect(elFormatBytes(4821), '5 KB');
    });

    test('MB to one decimal above', () {
      expect(elFormatBytes(2620000), '2.5 MB');
      expect(elFormatBytes(kElMaxFileBytes), '25.0 MB');
    });
  });

  group('formatMs', () {
    test('milliseconds under a second, one decimal above', () {
      // The tool-chip fixtures on the transcript page.
      expect(elFormatMs(912), '912ms');
      expect(elFormatMs(1204), '1.2s');
      expect(elFormatMs(8004), '8.0s');
      expect(elFormatMs(999), '999ms');
      expect(elFormatMs(1000), '1.0s');
    });
  });

  group('humanise', () {
    test('underscores, dots and camelCase all become one sentence case', () {
      expect(elHumaniseToolName('search_inventory'), 'Search inventory');
      expect(elHumaniseToolName('fetch_market_price'), 'Fetch market price');
      expect(elHumaniseToolName('browser.navigate'), 'Browser navigate');
      expect(elHumaniseToolName('readWallet'), 'Read wallet');
      expect(elHumaniseToolName(''), '');
    });
  });

  group('isTextual', () {
    test('any text/* MIME, and JSON, regardless of kind', () {
      expect(elIsTextual(_file(name: 'a.png', mime: 'text/plain')), isTrue);
      expect(
        elIsTextual(_file(name: 'a.bin', mime: 'application/json')),
        isTrue,
      );
    });

    test(
      'data, code and other are textual; image, document, audio are not',
      () {
        expect(elIsTextual(_file(name: 'a.csv', mime: 'text/csv')), isTrue);
        expect(
          elIsTextual(_file(name: 'a.ts', mime: 'application/octet-stream')),
          isTrue,
        );
        expect(
          elIsTextual(_file(name: 'a.pdf', mime: 'application/pdf')),
          isFalse,
        );
        expect(elIsTextual(_file(name: 'a.png', mime: 'image/png')), isFalse);
        expect(elIsTextual(_file(name: 'a.mp3', mime: 'audio/mpeg')), isFalse);
      },
    );
  });

  group('serialiseAttachments', () {
    test('no attachments is the identity', () {
      final ElSerialisedMessage out = elSerialiseAttachments(
        'hello',
        const <ElAgentAttachment>[],
      );
      expect(out.text, 'hello');
      expect(out.attachments, isEmpty);
    });

    test('a textual file is fenced and stamped content', () {
      final ElSerialisedMessage out = elSerialiseAttachments(
        'what is in here?',
        <ElAgentAttachment>[
          _file(name: 'export.csv', mime: 'text/csv', text: 'a,b\n1,2'),
        ],
      );
      expect(
        out.attachments.single.delivery!.sent,
        ElAgentDeliverySent.content,
      );
      expect(
        out.text,
        'what is in here?\n\n'
        '<file name="export.csv" type="text/csv">\n'
        'a,b\n1,2\n'
        '</file>',
      );
    });

    test('a binary travels as a name and says why', () {
      final ElSerialisedMessage out = elSerialiseAttachments(
        'read this',
        <ElAgentAttachment>[
          _file(name: 'report.pdf', mime: 'application/pdf', size: 2620000),
        ],
      );
      final ElAgentDelivery delivery = out.attachments.single.delivery!;
      expect(delivery.sent, ElAgentDeliverySent.reference);
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
      final ElSerialisedMessage out = elSerialiseAttachments(
        'look',
        <ElAgentAttachment>[_file(name: 'shot.png', mime: 'image/png')],
      );
      expect(
        out.attachments.single.delivery!.reason,
        "This agent's protocol carries text, so the image itself was not sent.",
      );
    });

    test('an image WITH a reading is fenced as <image>, not <file>', () {
      final ElSerialisedMessage out = elSerialiseAttachments(
        'look',
        <ElAgentAttachment>[
          _file(name: 'shot.png', mime: 'image/png', text: 'A blue circle.'),
        ],
      );
      expect(
        out.attachments.single.delivery!.sent,
        ElAgentDeliverySent.content,
      );
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
      final String long = 'x' * (kElMaxInlineChars + 10);
      final ElSerialisedMessage out = elSerialiseAttachments(
        'summarise',
        <ElAgentAttachment>[
          _file(name: 'big.csv', mime: 'text/csv', size: 999, text: long),
        ],
      );
      expect(out.text, contains('truncated="true" of-bytes="999"'));
      // Announced rather than done silently — and cut at exactly the cap.
      expect(out.text, contains('x' * kElMaxInlineChars));
      expect(out.text.contains('x' * (kElMaxInlineChars + 1)), isFalse);
    });

    test('attribute values are escaped', () {
      final ElSerialisedMessage out = elSerialiseAttachments(
        '',
        <ElAgentAttachment>[
          _file(name: 'a&"b<c.csv', mime: 'text/csv', text: 'x'),
        ],
      );
      expect(out.text, contains('name="a&amp;&quot;b&lt;c.csv"'));
    });

    test(
      'mixed: readable and unreadable both appear, in the reference order',
      () {
        final ElSerialisedMessage out =
            elSerialiseAttachments('both', <ElAgentAttachment>[
              _file(id: '1', name: 'a.csv', mime: 'text/csv', text: 'x'),
              _file(id: '2', name: 'b.pdf', mime: 'application/pdf'),
            ]);
        expect(
          out.text.indexOf('<file'),
          lessThan(out.text.indexOf('<attached-but-not-readable>')),
        );
        expect(
          out.attachments.map((ElAgentAttachment a) => a.delivery!.sent),
          <ElAgentDeliverySent>[
            ElAgentDeliverySent.content,
            ElAgentDeliverySent.reference,
          ],
        );
      },
    );
  });

  group('stripProtocol', () {
    test('closed complete tags go, anywhere', () {
      expect(elStripProtocol('<complete>done</complete>'), 'done');
      expect(elStripProtocol('a<complete>b</complete>c'), 'abc');
    });

    test('a half-written tag at the very end goes', () {
      expect(elStripProtocol('Checking the vault<comp'), 'Checking the vault');
      expect(elStripProtocol('Checking<'), 'Checking');
    });

    test('a tag-like fragment mid-string stays', () {
      // The trailing anchor is the whole point: only the buffer's tail is a
      // partially-arrived tag.
      expect(elStripProtocol('a < b and c'), 'a < b and c');
    });
  });

  group('relativeTime', () {
    // `Intl.RelativeTimeFormat(undefined, { numeric: "auto" })` — the `en`
    // output, which is what a reader of the reference actually sees. `auto` is
    // why one day is "yesterday" rather than "1 day ago".
    final DateTime now = DateTime(2026, 8, 16, 12);
    String at(Duration ago) => elRelativeTime(now.subtract(ago), now: now);

    test('under a minute is "just now", in both directions', () {
      expect(at(const Duration(seconds: 12)), 'just now');
      expect(at(const Duration(seconds: 59)), 'just now');
      expect(
        elRelativeTime(now.add(const Duration(seconds: 30)), now: now),
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

  group('ElAgentState', () {
    test('twenty states, in the source\'s order', () {
      expect(ElAgentState.values.length, 20);
      expect(ElAgentState.values.first, ElAgentState.idle);
      expect(ElAgentState.values.last, ElAgentState.done);
    });

    test('the two snake_case wire spellings survive the Dart rename', () {
      expect(ElAgentState.awaitingApproval.wire, 'awaiting_approval');
      expect(ElAgentState.callingTools.wire, 'calling_tools');
      expect(ElAgentState.searching.wire, 'searching');
    });

    test('AGENT_STATE_LABEL, where the label is not the name', () {
      expect(ElAgentState.idle.label, 'Ready');
      expect(ElAgentState.retrieving.label, 'Retrieving knowledge');
      expect(ElAgentState.ingesting.label, 'Ingesting data');
      expect(ElAgentState.running.label, 'Running code');
      expect(ElAgentState.delegating.label, 'Delegating to agent');
      expect(ElAgentState.awaitingApproval.label, 'Awaiting approval');
      expect(ElAgentState.error.label, 'Something went wrong');
      expect(ElAgentState.callingTools.label, 'Calling tools');
      expect(ElAgentState.reading.label, 'Reading files');
      expect(ElAgentState.recalling.label, 'Recalling context');
    });

    test(
      'isBusy: the three resting states, and awaiting_approval is not one',
      () {
        expect(ElAgentState.idle.isBusy, isFalse);
        expect(ElAgentState.done.isBusy, isFalse);
        expect(ElAgentState.error.isBusy, isFalse);
        expect(ElAgentState.awaitingApproval.isBusy, isTrue);
        expect(ElAgentState.thinking.isBusy, isTrue);
      },
    );

    test('isNarrating: the three the model is emitting prose in', () {
      expect(
        ElAgentState.values.where((ElAgentState s) => s.isNarrating).toSet(),
        <ElAgentState>{
          ElAgentState.planning,
          ElAgentState.summarizing,
          ElAgentState.writing,
        },
      );
    });

    test('STATE_ICON: retrieving and reading deliberately share a glyph', () {
      expect(ElAgentState.retrieving.glyph, ElAgentState.reading.glyph);
    });

    test('the console build\'s top-level aliases agree with the members', () {
      for (final ElAgentState state in ElAgentState.values) {
        expect(kElAgentStateLabel[state], state.label, reason: '$state');
        expect(kElAgentStateId[state], state.wire, reason: '$state');
        expect(elAgentIsBusy(state), state.isBusy, reason: '$state');
        expect(elAgentIsNarrating(state), state.isNarrating, reason: '$state');
      }
      expect(kElAgentStateLabel.length, ElAgentState.values.length);
    });

    test(
      'DRIFT: the labels carry no ellipsis, though the comment promises one',
      () {
        // `states.ts` L43: "Present participles with an ellipsis for anything
        // ongoing". Not one label has one. Reproduced as written.
        for (final ElAgentState state in ElAgentState.values) {
          expect(state.label.contains('…'), isFalse, reason: state.label);
        }
      },
    );
  });

  group('stateForTool — exact, then longest prefix', () {
    const ElToolStateMap map = <String, ElAgentState>{
      'search_inventory': ElAgentState.searching,
      'finance.': ElAgentState.retrieving,
      'finance.forecast.': ElAgentState.writing,
    };

    test('no map is no answer', () {
      expect(elStateForTool('anything', null), isNull);
    });

    test('exact beats everything', () {
      expect(elStateForTool('search_inventory', map), ElAgentState.searching);
    });

    test('longest prefix wins regardless of declaration order', () {
      expect(elStateForTool('finance.forecast.q3', map), ElAgentState.writing);
      expect(elStateForTool('finance.ledger', map), ElAgentState.retrieving);
    });

    test('a prefix key must end on a . or _ boundary', () {
      // `finance` without the dot is not a prefix key at all.
      expect(
        elStateForTool('financials', const <String, ElAgentState>{
          'finance': ElAgentState.retrieving,
        }),
        isNull,
      );
    });

    test('an unmapped name is null, never a guess', () {
      expect(elStateForTool('format_hard_drive', map), isNull);
    });

    test('the console build\'s alias resolves to the same function', () {
      expect(
        elAgentStateForTool('finance.ledger', map),
        elStateForTool('finance.ledger', map),
      );
    });
  });

  group('resolveState — the ladder, in order', () {
    ElAgentState resolve(
      List<ElAgentTurn> turns, {
      ElAgentSignals signals = const ElAgentSignals(),
      ElToolStateMap? toolStates,
    }) {
      return elResolveAgentState(
        turns: turns,
        signals: signals,
        toolStates: toolStates,
      );
    }

    ElToolTurn tool(
      String name, {
      ElAgentTurnStatus status = ElAgentTurnStatus.running,
      int attempt = 1,
      String id = 't',
    }) {
      return ElToolTurn(
        id: id,
        name: name,
        params: const <String, Object?>{},
        status: status,
        attempt: attempt,
      );
    }

    test('0. a declared state short-circuits the whole ladder', () {
      expect(
        resolve(<ElAgentTurn>[
          const ElErrorTurn(id: 'e', message: 'x', fatal: true),
        ], signals: const ElAgentSignals(declared: ElAgentState.recalling)),
        ElAgentState.recalling,
      );
    });

    test('1. a FATAL error outranks a running tool', () {
      // Order proof: the tool branch is #3 and would otherwise win.
      expect(
        resolve(<ElAgentTurn>[
          tool('search_inventory'),
          const ElErrorTurn(id: 'e', message: 'x', fatal: true),
        ]),
        ElAgentState.error,
      );
    });

    test('1b. a NON-fatal error does not — the agent recovers from those', () {
      expect(
        resolve(<ElAgentTurn>[
          const ElErrorTurn(id: 'e', message: 'x', fatal: false),
        ]),
        ElAgentState.done,
      );
    });

    test('2. a pending approval outranks a running tool', () {
      expect(
        resolve(<ElAgentTurn>[
          const ElActionTurn(
            id: 'a',
            action: 'purchase_pack',
            params: <String, Object?>{},
            status: ElAgentTurnStatus.running,
            approval: ElApprovalOutcome.pending,
          ),
          tool('search_inventory'),
        ]),
        ElAgentState.awaitingApproval,
      );
    });

    test('3. a running tool resolves through the caller map', () {
      expect(
        resolve(
          <ElAgentTurn>[tool('search_inventory')],
          toolStates: const <String, ElAgentState>{
            'search_inventory': ElAgentState.searching,
          },
        ),
        ElAgentState.searching,
      );
    });

    test('3b. an unmapped running tool is the honest fallback', () {
      expect(
        resolve(<ElAgentTurn>[tool('mystery')]),
        ElAgentState.callingTools,
      );
    });

    test('3c. a retry is a retry FIRST and whatever it does second', () {
      expect(
        resolve(
          <ElAgentTurn>[tool('search_inventory', attempt: 2)],
          toolStates: const <String, ElAgentState>{
            'search_inventory': ElAgentState.searching,
          },
        ),
        ElAgentState.retrying,
      );
    });

    test('4. a running action is processing', () {
      expect(
        resolve(<ElAgentTurn>[
          const ElActionTurn(
            id: 'a',
            action: 'click',
            params: <String, Object?>{},
            status: ElAgentTurnStatus.running,
          ),
        ]),
        ElAgentState.processing,
      );
    });

    test('5. prose before any work in this turn is planning', () {
      expect(
        resolve(<ElAgentTurn>[
          const ElUserTurn(id: 'u', text: 'hi'),
          const ElTextTurn(id: 't', text: 'Let me look', streaming: true),
        ]),
        ElAgentState.planning,
      );
    });

    test('5b. prose after a settled tool in this turn is summarizing', () {
      expect(
        resolve(<ElAgentTurn>[
          const ElUserTurn(id: 'u', text: 'hi'),
          tool('search_inventory', status: ElAgentTurnStatus.ok),
          const ElTextTurn(id: 't', text: 'I found', streaming: true),
        ]),
        ElAgentState.summarizing,
      );
    });

    test(
      '5c. the scan stops at the user turn — prior turns do not leak in',
      () {
        expect(
          resolve(<ElAgentTurn>[
            tool('search_inventory', status: ElAgentTurnStatus.ok, id: 'old'),
            const ElUserTurn(id: 'u', text: 'again'),
            const ElTextTurn(id: 't', text: 'Let me look', streaming: true),
          ]),
          ElAgentState.planning,
        );
      },
    );

    test('6. sent, nothing back yet is queued — not thinking', () {
      expect(
        resolve(
          const <ElAgentTurn>[],
          signals: const ElAgentSignals(
            awaitingFirstEvent: true,
            isLoading: true,
          ),
        ),
        ElAgentState.queued,
      );
    });

    test('7. loading with nothing else to say is thinking', () {
      expect(
        resolve(
          const <ElAgentTurn>[],
          signals: const ElAgentSignals(isLoading: true),
        ),
        ElAgentState.thinking,
      );
    });

    test('8. a settled last turn is done', () {
      expect(
        resolve(<ElAgentTurn>[const ElTextTurn(id: 't', text: 'Here you are')]),
        ElAgentState.done,
      );
    });

    test(
      '8b. a user turn is not settled work — an empty-handed send is idle',
      () {
        expect(
          resolve(<ElAgentTurn>[const ElUserTurn(id: 'u', text: 'hi')]),
          ElAgentState.idle,
        );
      },
    );

    test('an empty transcript with no signals is idle', () {
      expect(resolve(const <ElAgentTurn>[]), ElAgentState.idle);
    });
  });

  group('ElBlurSwitchController', () {
    test('the two measured legs, and the store call in the middle', () {
      expect(ElBlurSwitchController.outDuration, ElDurations.fast);
      expect(ElBlurSwitchController.inDuration, ElDurations.base);
      expect(ElBlurSwitchController.outDuration.inMilliseconds, 150);
      expect(ElBlurSwitchController.inDuration.inMilliseconds, 250);
    });

    testWidgets('blurs out, swaps at the darkest point, blurs in', (
      WidgetTester tester,
    ) async {
      final List<String> opened = <String>[];
      final ElBlurSwitchController controller = ElBlurSwitchController(
        open: opened.add,
      );
      addTearDown(controller.dispose);

      expect(controller.phase, ElSwitchPhase.idle);

      controller.switchTo('c-export');
      expect(controller.phase, ElSwitchPhase.out);
      // THE point of the hook: the store has not been called yet. Calling it
      // now would blur the *new* conversation out and then back in.
      expect(opened, isEmpty);

      await tester.pump(ElBlurSwitchController.outDuration);
      expect(opened, <String>['c-export']);
      expect(controller.phase, ElSwitchPhase.blurIn);

      await tester.pump(ElBlurSwitchController.inDuration);
      expect(controller.phase, ElSwitchPhase.idle);
    });

    testWidgets('a second switch supersedes the first', (
      WidgetTester tester,
    ) async {
      final List<String> opened = <String>[];
      final ElBlurSwitchController controller = ElBlurSwitchController(
        open: opened.add,
      );
      addTearDown(controller.dispose);

      controller.switchTo('a');
      await tester.pump(const Duration(milliseconds: 100));
      controller.switchTo('b');
      await tester.pump(ElBlurSwitchController.outDuration);
      // The first sequence's deferred `open` is dropped, not replayed.
      expect(opened, <String>['b']);
      await tester.pump(ElBlurSwitchController.inDuration);
      expect(controller.phase, ElSwitchPhase.idle);
      expect(opened, <String>['b']);
    });

    test('blurClass maps each phase to its utility', () {
      expect(ElSwitchPhase.out.className, 'anim-blur-out');
      expect(ElSwitchPhase.blurIn.className, 'anim-blur-in');
      expect(ElSwitchPhase.idle.className, '');
    });
  });

  group('ElClock seam', () {
    testWidgets('relativeTime reads the injected instant, not the wall clock', (
      WidgetTester tester,
    ) async {
      final DateTime frozen = DateTime(2026, 8, 16, 12);
      late String rendered;

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: ElClock(
            now: frozen,
            child: Builder(
              builder: (BuildContext context) {
                rendered = elRelativeTimeOf(
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
      final ElConversationSummary base = ElConversationSummary(
        id: 'c1',
        title: 'Sealed inventory check',
        updatedAt: stamp,
        preview: preview,
      );

      final ElConversationSummary renamed = base.copyWith(title: 'Renamed');
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
