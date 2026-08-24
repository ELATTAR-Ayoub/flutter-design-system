/// `lib/agent/mock-transport.ts`: a complete agent, with nothing behind it.
///
/// > The design system has no backend, no key and no socket, but `AgentConsole`
/// > is a shell around a transport and shows nothing without one. So this is a
/// > real `AgentTransport`: the same interface a live agent implements: that
/// > answers from a script instead of from a model.
/// >
/// > It exists for two reasons, and the second is the important one:
/// >
/// >  1. Every state in the machine becomes reachable on the documentation
/// >     page. Thinking, calling a tool, producing a file, holding an action for
/// >     approval, failing: none of those can be demonstrated by a transport
/// >     that only echoes, and a design system that cannot show a state cannot
/// >     be said to specify it.
/// >  2. **It is the reference implementation.** This is the file to read before
/// >     writing a real transport. Everything a live one must do is here and
/// >     nowhere else is it written down: own `turns`, fold events through
/// >     `reduceEvent`, flip `isLoading` around the round trip, honour `abort`,
/// >     publish `capabilities` honestly, and resolve the promise an approval is
/// >     blocking on.
/// >
/// > It is deterministic on purpose. A mock that varies makes the documentation
/// > page different on every reload, which turns a reference into a slot
/// > machine.
///
/// It lives under `example/lib/agent/` for the same reason the reference keeps
/// it in `lib/agent/` rather than in `components/agent/`: it is the *product's*
/// transport, not the system's. The console ships knowing nothing about it.
///
/// ## `reduceEvent` travels with it
///
/// `core/timeline.ts`'s reducer is not in `agent_core.dart`: that library's own
/// header records the decision and the reason (*"porting a 228-line state
/// machine no page exercises would be shipping untested surface"*). It is
/// exercised **here**, by this file and only by this file, so the four cases the
/// scripts actually emit are ported here beside their caller: `text` appends to
/// the turn already streaming, `tool_call` closes it and opens a call,
/// `tool_result` settles the last matching running call, `action_request` opens
/// an action, `error` appends a turn, `done` closes the stream.
///
/// ## The two timing tables
///
/// Both are the reference's, and its own comment says which kind they are:
/// *"the numbers below are the only ones in this file that were tuned by eye
/// rather than derived: fast enough not to waste a reader's time, slow enough
/// that the cursor, the shimmer and the state transitions are actually legible
/// on the documentation page."*
library;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:elattar_design_system/elattar_design_system.dart';

/* ── The script ──────────────────────────────────────────────────────────────
 *
 * Chosen to walk the state machine rather than to be impressive: a tool call
 * that succeeds and returns a file, prose streamed around it, and an action the
 * agent is not allowed to take by itself. Between them they light every part of
 * the transcript the console can draw.
 */

/// One instruction in a script.
sealed class _Beat {
  const _Beat();
}

/// *"Stream a string in, a few characters at a time."*
class _Say extends _Beat {
  const _Say(this.text);
  final String text;
}

/// *"Call a tool, wait, then settle it."*
class _Tool extends _Beat {
  const _Tool({
    required this.name,
    required this.params,
    required this.ms,
    required this.result,
    this.attachments = const <ElAgentAttachment>[],
  });

  final String name;
  final Map<String, Object?> params;
  final int ms;
  final Map<String, Object?> result;
  final List<ElAgentAttachment> attachments;
}

/// *"Ask to do something, and stop until a human answers."*
class _Ask extends _Beat {
  const _Ask({required this.action, required this.params});
  final String action;
  final Map<String, Object?> params;
}

/// *"Fail, recoverably."*
class _Fail extends _Beat {
  const _Fail(this.error);
  final String error;
}

/// The CSV `export_activity` hands back, *"so the attachment renderer has
/// something to draw in the direction that is easy to forget: agent to user."*
final ElAgentAttachment _activityCsv = ElAgentAttachment(
  id: 'mock-activity-csv',
  name: 'activity-30d.csv',
  mime: 'text/csv',
  kind: ElAgentAttachmentKind.data,
  size: 4821,
  text: <String>[
    'date,event,item,value',
    '2026-07-08,pull,Eclipse Vault,129.00',
    '2026-07-11,sale,Aurora Prism,84.50',
    '2026-07-19,pull,Cobalt Run,72.00',
    '2026-08-02,sale,Eclipse Vault,240.00',
  ].join('\n'),
  delivery: const ElAgentDelivery.produced(),
);

const List<_Beat> _defaultScript = <_Beat>[
  _Say('Let me look that up.'),
  _Tool(
    name: 'search_inventory',
    params: <String, Object?>{'query': 'sealed booster boxes', 'limit': 3},
    ms: 900,
    result: <String, Object?>{
      'matches': 3,
      'topResult': 'Eclipse Vault — 1st Edition',
    },
  ),
  _Say(
    'Three sealed boxes match. The strongest is **Eclipse Vault — 1st '
    'Edition**, with 24 packs left of an original 250.\n\nWant me to put one '
    'on hold?',
  ),
];

/// *"The path that ends at a decision a human has to make."*
const List<_Beat> _approvalScript = <_Beat>[
  _Say('I can do that. Checking the balance first.'),
  _Tool(
    name: 'read_wallet',
    params: <String, Object?>{},
    ms: 700,
    result: <String, Object?>{'available': 2481, 'currency': 'USD'},
  ),
  _Say(
    'There is enough available. This one spends real money, so it is yours '
    'to confirm rather than mine.',
  ),
  _Ask(
    action: 'purchase_pack',
    params: <String, Object?>{
      'pack': 'Eclipse Vault — 1st Edition',
      'price': 129,
      'currency': 'USD',
    },
  ),
];

/// *"The unhappy path. A design system that only documents success is
/// documenting half a component."*
const List<_Beat> _errorScript = <_Beat>[
  _Say('Trying the pricing service.'),
  _Tool(
    name: 'fetch_market_price',
    params: <String, Object?>{'item': 'Eclipse Vault'},
    ms: 800,
    result: <String, Object?>{'success': false},
  ),
  _Fail('The pricing service did not respond in time.'),
];

List<_Beat> get _reportScript => <_Beat>[
  const _Say('Pulling the last thirty days.'),
  _Tool(
    name: 'export_activity',
    params: const <String, Object?>{'window': '30d', 'format': 'csv'},
    ms: 1200,
    result: const <String, Object?>{'rows': 148},
    attachments: <ElAgentAttachment>[_activityCsv],
  ),
  const _Say(
    '148 rows, attached above. Net position over the window is '
    '**+\$123.50**.',
  ),
];

final RegExp _approvalWords = RegExp(r'\b(buy|purchase|order|hold|reserve)\b');
final RegExp _reportWords = RegExp(
  r'\b(report|export|csv|activity|download)\b',
);
final RegExp _errorWords = RegExp(
  r'\b(price|worth|value|market|fail|error|broken)\b',
);

/// *"Which script a message runs, chosen by keyword so the page can drive it."*
List<_Beat> _scriptFor(String text) {
  final String t = text.toLowerCase();
  if (_approvalWords.hasMatch(t)) return _approvalScript;
  if (_reportWords.hasMatch(t)) return _reportScript;
  if (_errorWords.hasMatch(t)) return _errorScript;
  return _defaultScript;
}

/* ── Timing ──────────────────────────────────────────────────────────────── */

/// *"Streaming is what makes an agent feel like it is thinking rather than
/// returning."*
// allow-hardcoded: `CHUNK`, `CHAR_MS` and `THINK_MS` are this mock's own
// pacing, tuned by eye in `mock-transport.ts` and stated there. They are not
// design tokens: nothing renders them and no other surface shares them.
const int _chunk = 3;
const int _charMs = 12;
const int _thinkMs = 420;

/// The transport's own cancellation token. `AbortController`, minus the DOM.
class _Abort {
  bool cancelled = false;
}

class _Aborted implements Exception {
  const _Aborted();
}

/* ── The transport ───────────────────────────────────────────────────────── */

/// `useMockTransport`, as a [ChangeNotifier].
///
/// The reference is a hook whose consumer re-renders because React re-runs it;
/// the port's console listens, so this is the notifier. Every `setTurns` in the
/// original is a mutation followed by [notifyListeners] here.
class ElMockTransport extends ChangeNotifier implements ElAgentTransport {
  ElMockTransport({
    this.latency = const Duration(milliseconds: _thinkMs),
    this.capabilities = const ElAgentCapabilities(),
  });

  /// *"Delay before the first event. The console shows `awaitingFirstEvent`
  /// during it, which is a distinct state from `thinking` and otherwise has no
  /// way to be seen."*
  final Duration latency;

  @override
  final ElAgentCapabilities capabilities;

  final List<ElAgentTurn> _turns = <ElAgentTurn>[];
  final List<ElPendingApproval> _pending = <ElPendingApproval>[];

  _Abort? _abort;
  bool _isLoading = false;
  Object? _error;
  int _seq = 0;
  int _askCount = 0;

  @override
  List<ElAgentTurn> get turns => List<ElAgentTurn>.unmodifiable(_turns);

  @override
  List<ElPendingApproval> get pendingApprovals =>
      List<ElPendingApproval>.unmodifiable(_pending);

  @override
  bool get isLoading => _isLoading;

  /// *"`isReady: true`"*: nothing to acquire.
  @override
  bool get isReady => true;

  @override
  Object? get error => _error;

  String get _nextId => 'turn-${++_seq}';

  Future<void> _sleep(Duration d, _Abort signal) async {
    if (signal.cancelled) throw const _Aborted();
    await Future<void>.delayed(d);
    if (signal.cancelled) throw const _Aborted();
  }

  /* ── The reducer ───────────────────────────────────────────────────────── */

  /// `closeStreaming`, *"mark the trailing text turn as finished streaming.
  /// Called whenever something other than more text arrives. Without it the
  /// cursor keeps blinking on a paragraph the model stopped writing several
  /// tool calls ago, and `resolveState` cannot tell 'writing' from 'wrote'."*
  void _closeStreaming() {
    if (_turns.isEmpty) return;
    final ElAgentTurn last = _turns.last;
    if (last is! ElTextTurn || !last.streaming) return;
    _turns[_turns.length - 1] = last.notStreaming();
  }

  /// `priorFailures`, *"a model that calls the same tool again after an error
  /// is retrying, and that is worth showing… The count is scoped to the tool
  /// name rather than to its arguments, because a retry with corrected
  /// arguments is still a retry."*
  int _priorFailures(String name) {
    int count = 0;
    for (final ElAgentTurn turn in _turns) {
      if (turn is ElToolTurn &&
          turn.name == name &&
          turn.status == ElAgentTurnStatus.error) {
        count += 1;
      }
    }
    return count;
  }

  /// `reduceEvent`'s `text` arm.
  void _emitText(String content) {
    if (content.isEmpty) return;
    final ElAgentTurn? last = _turns.isEmpty ? null : _turns.last;
    if (last is ElTextTurn) {
      _turns[_turns.length - 1] = ElTextTurn(
        id: last.id,
        text: last.text + content,
        attachments: last.attachments,
        streaming: true,
      );
    } else {
      _turns.add(ElTextTurn(id: _nextId, text: content, streaming: true));
    }
    notifyListeners();
  }

  /// `reduceEvent`'s `tool_call` arm.
  void _emitToolCall(String name, Map<String, Object?> params) {
    _closeStreaming();
    _turns.add(
      ElToolTurn(
        id: _nextId,
        name: name,
        params: params,
        status: ElAgentTurnStatus.running,
        startedAt: DateTime.now().millisecondsSinceEpoch,
        attempt: _priorFailures(name) + 1,
      ),
    );
    notifyListeners();
  }

  /// `reduceEvent`'s `tool_result` arm: settles the **last** running call of
  /// that name, in place.
  void _emitToolResult(
    String name, {
    required bool success,
    Object? result,
    String? error,
    List<ElAgentAttachment> attachments = const <ElAgentAttachment>[],
  }) {
    for (int i = _turns.length - 1; i >= 0; i -= 1) {
      final ElAgentTurn turn = _turns[i];
      if (turn is! ElToolTurn ||
          turn.name != name ||
          turn.status != ElAgentTurnStatus.running) {
        continue;
      }
      _turns[i] = ElToolTurn(
        id: turn.id,
        name: turn.name,
        params: turn.params,
        status: success ? ElAgentTurnStatus.ok : ElAgentTurnStatus.error,
        startedAt: turn.startedAt,
        result: result,
        error: error,
        attachments: attachments.isNotEmpty ? attachments : turn.attachments,
        ms: DateTime.now().millisecondsSinceEpoch - turn.startedAt,
        attempt: turn.attempt,
      );
      notifyListeners();
      return;
    }
  }

  /// `reduceEvent`'s `action_request` arm.
  ///
  /// *"The correlation id is already unique per request and is what the action
  /// bridge will quote back when the browser reports the outcome."* Note what
  /// it does **not** set: `approval`. The card is on screen and the turn is
  /// merely `running`, which is why `resolveState` answers `processing` rather
  /// than `awaiting_approval`: see the console's drift register.
  void _emitActionRequest(
    String correlationId,
    String action,
    Map<String, Object?> params,
  ) {
    _closeStreaming();
    _turns.add(
      ElActionTurn(
        id: correlationId,
        action: action,
        params: params,
        status: ElAgentTurnStatus.running,
        startedAt: DateTime.now().millisecondsSinceEpoch,
      ),
    );
    notifyListeners();
  }

  /// `settleAction`, *"called once the browser has actually performed a DOM
  /// action."*
  void _settleAction(String action, {required bool success, String? error}) {
    for (int i = _turns.length - 1; i >= 0; i -= 1) {
      final ElAgentTurn turn = _turns[i];
      if (turn is! ElActionTurn ||
          turn.action != action ||
          turn.status != ElAgentTurnStatus.running) {
        continue;
      }
      _turns[i] = ElActionTurn(
        id: turn.id,
        action: turn.action,
        params: turn.params,
        status: success ? ElAgentTurnStatus.ok : ElAgentTurnStatus.error,
        startedAt: turn.startedAt,
        error: error,
        ms: DateTime.now().millisecondsSinceEpoch - turn.startedAt,
        approval: turn.approval,
      );
      notifyListeners();
      return;
    }
  }

  /// `markApproval`, *"flag an action turn as held at an approval gate."*
  void _markApproval(String turnId, ElApprovalOutcome outcome) {
    for (int i = _turns.length - 1; i >= 0; i -= 1) {
      final ElAgentTurn turn = _turns[i];
      if (turn is! ElActionTurn || turn.id != turnId) continue;
      _turns[i] = ElActionTurn(
        id: turn.id,
        action: turn.action,
        params: turn.params,
        status: turn.status,
        startedAt: turn.startedAt,
        error: turn.error,
        ms: turn.ms,
        approval: outcome,
      );
      notifyListeners();
      return;
    }
  }

  /// `reduceEvent`'s `error` arm.
  void _emitError(String message, {required bool fatal}) {
    _closeStreaming();
    _turns.add(ElErrorTurn(id: _nextId, message: message, fatal: fatal));
    notifyListeners();
  }

  /// `reduceEvent`'s `done` arm.
  void _emitDone() {
    _closeStreaming();
    notifyListeners();
  }

  /* ── Driving ───────────────────────────────────────────────────────────── */

  Future<void> _stream(String text, _Abort signal) async {
    for (int i = 0; i < text.length; i += _chunk) {
      await _sleep(const Duration(milliseconds: _charMs * _chunk), signal);
      _emitText(text.substring(i, (i + _chunk).clamp(0, text.length)));
    }
  }

  /// *"An approval is a promise the agent is blocked on. The console renders the
  /// card; answering it resolves this, and the script continues. Rejecting is a
  /// normal outcome, not an error: the user said no, and the agent should say
  /// so rather than throw."*
  Future<bool> _askPermission(
    String turnId,
    String action,
    Map<String, Object?> params,
  ) {
    final Completer<bool> completer = Completer<bool>();
    void settle(bool approved) {
      if (completer.isCompleted) return;
      _pending.removeWhere((ElPendingApproval p) => p.turnId == turnId);
      _markApproval(
        turnId,
        approved ? ElApprovalOutcome.approved : ElApprovalOutcome.rejected,
      );
      completer.complete(approved);
    }

    _pending.add(
      ElPendingApproval(
        turnId: turnId,
        action: action,
        params: params,
        approve: () => settle(true),
        reject: ([String? reason]) => settle(false),
      ),
    );
    notifyListeners();
    return completer.future;
  }

  @override
  Future<void> send(
    String text, [
    ElAgentSendOptions options = const ElAgentSendOptions(),
  ]) async {
    _abort?.cancelled = true;
    final _Abort signal = _Abort();
    _abort = signal;

    _error = null;
    _isLoading = true;
    _turns.add(
      ElUserTurn(id: _nextId, text: text, attachments: options.attachments),
    );
    notifyListeners();

    try {
      await _sleep(latency, signal);

      for (final _Beat beat in _scriptFor(text)) {
        if (signal.cancelled) break;

        switch (beat) {
          case _Say():
            await _stream(beat.text, signal);

          case _Tool():
            _emitToolCall(beat.name, beat.params);
            await _sleep(Duration(milliseconds: beat.ms), signal);
            // `(beat.result as { success?: boolean })?.success !== false`.
            final bool ok = beat.result['success'] != false;
            _emitToolResult(
              beat.name,
              success: ok,
              result: ok ? beat.result : null,
              error: ok ? null : 'Upstream returned no data.',
              attachments: beat.attachments,
            );

          case _Ask():
            // *"Counted per request so asking twice in one conversation
            // produces two turns rather than one that gets answered twice."*
            final String correlationId = 'mock-${beat.action}-${++_askCount}';
            _emitActionRequest(correlationId, beat.action, beat.params);
            final bool approved = await _askPermission(
              correlationId,
              beat.action,
              beat.params,
            );
            _settleAction(
              beat.action,
              success: approved,
              error: approved ? null : 'Declined.',
            );
            await _stream(
              approved
                  ? '\n\nDone — it is on hold under your name for 24 hours.'
                  : '\n\nUnderstood, nothing was bought. Say the word if you '
                        'change your mind.',
              signal,
            );

          case _Fail():
            /* A turn that failed, not a transport that broke: and the two are
               rendered differently, so a transport must not report both.

               An `error` event becomes a turn in the transcript: this question
               did not work out, the conversation continues, and the failure
               stays in place in the history where it happened.
               `transport.error` is the standing banner above the composer and
               means something else entirely: the connection is down, nothing
               will work until it is fixed. Setting both for one upstream
               timeout printed the same sentence twice, once in each place. */
            _emitError(beat.error, fatal: false);
        }
      }

      if (!signal.cancelled) _emitDone();
    } on _Aborted {
      // *"Abort is the user pressing stop. It is the transport working, not the
      // transport failing, so it must not surface as an error."*
    } catch (cause) {
      _error = cause;
      _emitError('$cause', fatal: true);
    } finally {
      if (identical(_abort, signal)) {
        _abort = null;
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  @override
  void abort() {
    _abort?.cancelled = true;
    _abort = null;
    _isLoading = false;
    notifyListeners();
  }

  @override
  void reset() {
    _abort?.cancelled = true;
    _abort = null;
    _turns.clear();
    _pending.clear();
    _error = null;
    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _abort?.cancelled = true;
    super.dispose();
  }
}
