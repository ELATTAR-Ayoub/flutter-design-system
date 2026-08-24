/// `components/agent/core/*` — the vocabulary every agent family renders.
///
/// The reference splits this across `core/types.ts`, `core/states.ts`,
/// `core/resolve-state.ts`, `core/conversations.ts`, `core/attachments.ts`,
/// `core/timeline.ts` and `core/use-blur-switch.ts`. It arrives here as one
/// library because all seven are pure data and pure functions — no widget in
/// this file, and nothing that imports one — and the port's file unit is the
/// *family*, not the reference's directory.
///
/// Everything here is transport-agnostic on purpose. A transport adapter turns
/// one agent's wire protocol into these shapes; another agent gets another
/// adapter and the rest of the component does not move.
///
/// **Naming.** Types are prefixed `ElAgent…` where a bare name would collide
/// with the vendored chat primitives already in the corpus — `attachment.dart`
/// owns `ElAttachment`, and the agent's own attachment is a different object
/// with a different job (a domain record, not a row widget).
///
/// ## This file is the union of two builds
///
/// The console/composer builder and the transcript/history builder each wrote a
/// `core` independently and each named the same objects differently. Rather
/// than force one side to rewrite, the merged library declares **one canonical
/// name per object and a `typedef` for the other spelling**, so code written
/// against either vocabulary compiles unchanged. The aliases are listed beside
/// their canonical types and are not deprecated — both spellings are supported
/// surface.
///
/// The one place an alias could not be made: `ElAgentDelivery` is the delivery
/// *record* (a class), and the discriminant enum is `ElAgentDeliverySent`. A
/// build that used `ElAgentDelivery` as the enum must read
/// `ElAgentDeliverySent.content` instead — it is the only rename either side
/// has to absorb, and it fails loudly at compile time rather than silently.
///
/// ## What is deliberately absent
///
/// `reduceEvent` and the rest of `timeline.ts` build a timeline out of an event
/// stream. No page in the port runs one: the specimens are driven by a scripted
/// transport that owns its own turn list and settles its own tool calls. The
/// reducer is recorded, not built. `stripProtocol` is the one function the
/// console itself calls, so it is here.
library;

import 'package:flutter/widgets.dart';

import '../foundation/date_format.dart';
import '../foundation/motion.dart';
import 'icon_paths.g.dart';

/* ── Attachments ─────────────────────────────────────────────────────────────
 *
 * Deliberately one type in both directions. A file the user picks and a file
 * the agent produces are the same object to everything that draws them, which
 * is what stops the transcript growing two parallel renderers that drift.
 */

/// `AttachmentKind` — how a file is classified once MIME and extension have
/// been allowed to disagree.
enum ElAgentAttachmentKind { image, document, data, code, audio, other }

/// `AttachmentDelivery['sent']` — whether the agent can genuinely see the file.
enum ElAgentDeliverySent {
  /// Content was inlined into the message. The agent can read it.
  content,

  /// Only the filename and type travelled.
  reference,

  /// Produced by the agent, so delivery does not apply.
  produced,
}

/// `AttachmentDelivery`.
///
/// Stated rather than implied, because the honest answer varies by transport
/// and by file type, and a paperclip icon that means "we sent the name" looks
/// exactly like one that means "we sent the file".
@immutable
class ElAgentDelivery {
  const ElAgentDelivery.content()
    : sent = ElAgentDeliverySent.content,
      reason = null;

  const ElAgentDelivery.reference(String this.reason)
    : sent = ElAgentDeliverySent.reference;

  const ElAgentDelivery.produced()
    : sent = ElAgentDeliverySent.produced,
      reason = null;

  final ElAgentDeliverySent sent;

  /// Only `reference` carries one; the TS union makes it non-optional there.
  final String? reason;
}

/// Alias — the console build's spelling of [ElAgentDelivery].
typedef ElAgentAttachmentDelivery = ElAgentDelivery;

/// `Attachment` — one file, in either direction.
@immutable
class ElAgentAttachment {
  const ElAgentAttachment({
    required this.id,
    required this.name,
    required this.mime,
    required this.kind,
    required this.size,
    this.url,
    this.text,
    this.delivery,
  });

  final String id;
  final String name;

  /// MIME type as reported by the picker, or asserted by the producing tool.
  final String mime;
  final ElAgentAttachmentKind kind;

  /// Bytes. Shown to the user, and what the size cap is enforced against.
  final int size;

  /// Object URL for preview and download.
  final String? url;

  /// Decoded content, for the kinds where holding it is useful and cheap.
  final String? text;

  /// Set by the transport once it knows whether the content actually travelled.
  final ElAgentDelivery? delivery;

  ElAgentAttachment copyWith({ElAgentDelivery? delivery, String? text}) =>
      ElAgentAttachment(
        id: id,
        name: name,
        mime: mime,
        kind: kind,
        size: size,
        url: url,
        text: text ?? this.text,
        delivery: delivery ?? this.delivery,
      );
}

/// `attachmentKind` — classify by MIME first, extension second.
///
/// Pickers lie about MIME often enough that the two are allowed to disagree.
///
/// DRIFT: `name.slice(name.lastIndexOf(".") + 1)` on a name with no dot is
/// `slice(0)` — the whole name. So a file called exactly `pdf` classifies as a
/// document and one called `csv` as data. Reproduced: the port matches the
/// reference's arithmetic, not its intent.
ElAgentAttachmentKind elAttachmentKind(String mime, String name) {
  if (mime.startsWith('image/')) return ElAgentAttachmentKind.image;
  if (mime.startsWith('audio/')) return ElAgentAttachmentKind.audio;
  final String ext = name.substring(name.lastIndexOf('.') + 1).toLowerCase();
  if (mime == 'application/pdf' || ext == 'pdf') {
    return ElAgentAttachmentKind.document;
  }
  if (RegExp(r'^(docx?|odt|rtf|pages)$').hasMatch(ext)) {
    return ElAgentAttachmentKind.document;
  }
  if (RegExp(r'^(csv|tsv|json|xlsx?|ods|parquet)$').hasMatch(ext)) {
    return ElAgentAttachmentKind.data;
  }
  if (mime == 'application/json' || mime == 'text/csv') {
    return ElAgentAttachmentKind.data;
  }
  if (RegExp(
    r'^(ts|tsx|js|jsx|py|rb|go|rs|java|c|h|cpp|sql|sh|yml|yaml|toml|css|html)$',
  ).hasMatch(ext)) {
    return ElAgentAttachmentKind.code;
  }
  if (mime.startsWith('text/') || RegExp(r'^(txt|md|log)$').hasMatch(ext)) {
    return ElAgentAttachmentKind.other;
  }
  return ElAgentAttachmentKind.other;
}

/// Alias — the transcript build's spelling of [elAttachmentKind].
ElAgentAttachmentKind elAgentAttachmentKind(String mime, String name) =>
    elAttachmentKind(mime, name);

/// `formatBytes` — `1023 B`, `18 KB`, `2.6 MB`.
///
/// The three branches and their rounding are the reference's own: bytes under
/// 1024 print raw, KB rounds to a whole number, MB takes one decimal.
String elFormatBytes(int bytes) {
  // allow-hardcoded: the KB/MB divisor is the unit definition itself, not a
  // spacing or type token — restating it in `foundation/` would put arithmetic
  // in the token layer.
  const int k = 1024;
  if (bytes < k) return '$bytes B';
  if (bytes < k * k) return '${(bytes / k).round()} KB';
  return '${(bytes / k / k).toStringAsFixed(1)} MB';
}

/// `MAX_INLINE_CHARS` — *"128k characters is roughly 32k tokens."*
// allow-hardcoded: a payload budget in characters, not a design token.
const int kElMaxInlineChars = 128000;

/// `MAX_FILE_BYTES` — above this the picker refuses the file rather than
/// reading it.
// allow-hardcoded: 25 MiB, a protocol limit that travels with the model.
const int kElMaxFileBytes = 25 * 1024 * 1024;

const Set<ElAgentAttachmentKind> _textualKinds = <ElAgentAttachmentKind>{
  ElAgentAttachmentKind.data,
  ElAgentAttachmentKind.code,
  ElAgentAttachmentKind.other,
};

/// `isTextual` — whether this file's bytes are meaningfully text.
bool elIsTextual(ElAgentAttachment attachment) {
  if (attachment.mime.startsWith('text/')) return true;
  if (attachment.mime == 'application/json') return true;
  return _textualKinds.contains(attachment.kind) &&
      attachment.kind != ElAgentAttachmentKind.audio;
}

String _escapeAttribute(String value) => value
    .replaceAll('&', '&amp;')
    .replaceAll('"', '&quot;')
    .replaceAll('<', '&lt;');

/// The two halves [elSerialiseAttachments] returns.
@immutable
class ElSerialisedMessage {
  const ElSerialisedMessage({required this.text, required this.attachments});

  /// What actually goes on the wire.
  final String text;

  /// The same attachments, with `delivery` stamped on each.
  final List<ElAgentAttachment> attachments;
}

/// `serialiseAttachments` — fold attachments into the message the agent
/// receives.
///
/// *"A Lens message is a string… the only way an attachment reaches the model
/// is inside that string."* The fences are reproduced verbatim, including the
/// trailing sentence after the `<attached-but-not-readable>` block.
ElSerialisedMessage elSerialiseAttachments(
  String text,
  List<ElAgentAttachment> attachments,
) {
  if (attachments.isEmpty) {
    return ElSerialisedMessage(text: text, attachments: attachments);
  }

  final List<ElAgentAttachment> stamped = <ElAgentAttachment>[];
  final List<String> blocks = <String>[];
  final List<String> referenced = <String>[];

  for (final ElAgentAttachment attachment in attachments) {
    final String? body = attachment.text;

    // An image that has been through a vision pass carries its transcription on
    // `text`. It is fenced as an <image> rather than a <file> and labelled as a
    // reading, *"because the agent is receiving a description of a picture and
    // not the picture"*.
    if (attachment.kind == ElAgentAttachmentKind.image && body != null) {
      blocks.add(
        <String>[
          '<image name="${_escapeAttribute(attachment.name)}" '
              'type="${_escapeAttribute(attachment.mime)}">',
          'A vision model read this image on your behalf. Its reading follows.',
          body,
          '</image>',
        ].join('\n'),
      );
      stamped.add(
        attachment.copyWith(delivery: const ElAgentDelivery.content()),
      );
      continue;
    }

    if (body != null && elIsTextual(attachment)) {
      final bool truncated = body.length > kElMaxInlineChars;
      final String inlined = truncated
          ? body.substring(0, kElMaxInlineChars)
          : body;
      final String suffix = truncated
          ? ' truncated="true" of-bytes="${attachment.size}"'
          : '';
      blocks.add(
        <String>[
          '<file name="${_escapeAttribute(attachment.name)}" '
              'type="${_escapeAttribute(attachment.mime)}"$suffix>',
          inlined,
          '</file>',
        ].join('\n'),
      );
      stamped.add(
        attachment.copyWith(delivery: const ElAgentDelivery.content()),
      );
      continue;
    }

    referenced.add(
      '${attachment.name} (${attachment.mime}, '
      '${elFormatBytes(attachment.size)})',
    );
    stamped.add(
      attachment.copyWith(
        delivery: ElAgentDelivery.reference(
          attachment.kind == ElAgentAttachmentKind.image
              ? "This agent's protocol carries text, so the image itself was not sent."
              : 'This file is not text, so its contents could not be inlined.',
        ),
      ),
    );
  }

  final List<String> parts = <String>[text.trim()];
  if (blocks.isNotEmpty) parts.add(blocks.join('\n\n'));
  if (referenced.isNotEmpty) {
    parts.add(
      '<attached-but-not-readable>\n${referenced.join('\n')}\n'
      '</attached-but-not-readable>\nThe files above were attached by the '
      'user but their contents are not available to you. Ask the user to '
      'paste the relevant part if you need it.',
    );
  }

  return ElSerialisedMessage(
    text: parts.where((String p) => p.isNotEmpty).join('\n\n'),
    attachments: stamped,
  );
}

/// `stripProtocol` — strip the streaming protocol's own tags.
///
/// Two replacements: the closed `<complete>` pair anywhere, and a dangling
/// half-written tag at the very end of the buffer — which is what a stream
/// looks like mid-token.
String elStripProtocol(String text) => text
    .replaceAll(RegExp(r'</?complete>'), '')
    .replaceAll(RegExp(r'</?[a-z]*$', caseSensitive: false), '');

/* ── Turns ───────────────────────────────────────────────────────────────── */

/// `TurnStatus`.
enum ElAgentTurnStatus { running, ok, error }

/// `AgentTurn` — the sealed union the transcript switches over.
sealed class ElAgentTurn {
  const ElAgentTurn({required this.id});

  final String id;
}

/// `UserTurn`.
class ElUserTurn extends ElAgentTurn {
  const ElUserTurn({
    required super.id,
    required this.text,
    this.attachments = const <ElAgentAttachment>[],
  });

  final String text;
  final List<ElAgentAttachment> attachments;
}

/// Alias — the console build's spelling of [ElUserTurn].
typedef ElAgentUserTurn = ElUserTurn;

/// `TextTurn`.
class ElTextTurn extends ElAgentTurn {
  const ElTextTurn({
    required super.id,
    required this.text,
    this.attachments = const <ElAgentAttachment>[],
    this.streaming = false,
  });

  final String text;
  final List<ElAgentAttachment> attachments;

  /// True while this is the turn the model is still streaming into. The
  /// transcript uses it for the cursor.
  final bool streaming;

  ElTextTurn notStreaming() => copyWith(streaming: false);

  ElTextTurn copyWith({bool? streaming}) => ElTextTurn(
    id: id,
    text: text,
    attachments: attachments,
    streaming: streaming ?? this.streaming,
  );
}

/// Alias — the console build's spelling of [ElTextTurn].
typedef ElAgentTextTurn = ElTextTurn;

/// `ToolTurn`.
class ElToolTurn extends ElAgentTurn {
  const ElToolTurn({
    required super.id,
    required this.name,
    required this.params,
    required this.status,
    required this.attempt,
    this.startedAt = 0,
    this.result,
    this.error,
    this.attachments = const <ElAgentAttachment>[],
    this.ms,
  });

  final String name;
  final Map<String, Object?> params;
  final ElAgentTurnStatus status;
  final Object? result;
  final String? error;
  final List<ElAgentAttachment> attachments;

  /// Wall-clock at dispatch. Defaulted rather than required: every specimen in
  /// the port supplies a scripted transcript where the value is never read, and
  /// the reference's own fixtures pass `startedAt: 0` for exactly that reason.
  final int startedAt;

  /// How long the call took once settled. Null while it is running.
  final int? ms;

  /// Incremented when the same tool is re-called after a failure.
  final int attempt;
}

/// Alias — the console build's spelling of [ElToolTurn].
typedef ElAgentToolTurn = ElToolTurn;

/// `ActionTurn` — a step the browser performed, rather than the server.
class ElActionTurn extends ElAgentTurn {
  const ElActionTurn({
    required super.id,
    required this.action,
    required this.params,
    required this.status,
    this.startedAt = 0,
    this.error,
    this.ms,
    this.approval,
  });

  final String action;
  final Map<String, Object?> params;
  final ElAgentTurnStatus status;
  final String? error;
  final int startedAt;
  final int? ms;

  /// Set when this action is held at an approval card rather than run.
  final ElApprovalOutcome? approval;
}

/// Alias — the console build's spelling of [ElActionTurn].
typedef ElAgentActionTurn = ElActionTurn;

/// `ActionTurn['approval']`.
enum ElApprovalOutcome { pending, approved, rejected }

/// Alias — the console build's spelling of [ElApprovalOutcome].
typedef ElAgentApprovalState = ElApprovalOutcome;

/// `ErrorTurn`.
class ElErrorTurn extends ElAgentTurn {
  const ElErrorTurn({
    required super.id,
    required this.message,
    required this.fatal,
  });

  final String message;
  final bool fatal;
}

/// Alias — the console build's spelling of [ElErrorTurn].
typedef ElAgentErrorTurn = ElErrorTurn;

/// `PendingApproval` — a request the transport is holding at a gate.
@immutable
class ElPendingApproval {
  const ElPendingApproval({
    required this.turnId,
    required this.action,
    required this.params,
    required this.approve,
    required this.reject,
  });

  /// The [ElActionTurn] this belongs to.
  final String turnId;
  final String action;
  final Map<String, Object?> params;
  final VoidCallback approve;

  /// `reject: (reason?: string) => void` — the reason is optional, so the
  /// parameter is optional-positional and `reject()` with no argument is legal.
  final void Function([String? reason]) reject;
}

/// Alias — the console build's spelling of [ElPendingApproval].
typedef ElAgentPendingApproval = ElPendingApproval;

/* ── States ──────────────────────────────────────────────────────────────── */

/// `AGENT_STATES` — the twenty-state machine the face and the chips share.
///
/// Order is `states.ts`'s own, which is the order the avatar page's matrix
/// prints them in.
enum ElAgentState {
  idle,
  queued,
  planning,
  retrieving,
  ingesting,
  running,
  delegating,
  awaitingApproval,
  validating,
  retrying,
  error,
  summarizing,
  thinking,
  processing,
  callingTools,
  searching,
  reading,
  recalling,
  writing,
  done;

  /// The wire spelling. `awaiting_approval` / `calling_tools` are snake_case in
  /// the source; the rest are their own names.
  String get wire => switch (this) {
    ElAgentState.awaitingApproval => 'awaiting_approval',
    ElAgentState.callingTools => 'calling_tools',
    _ => name,
  };

  /// `AGENT_STATE_LABEL` — the sentence shown beside the face, and the chip's
  /// own label. Transcribed from `states.ts`, not paraphrased.
  ///
  /// DRIFT: the source comment promises *"present participles with an ellipsis
  /// for anything ongoing"* and **not one label carries one**. Shipped as
  /// written.
  String get label => switch (this) {
    ElAgentState.idle => 'Ready',
    ElAgentState.queued => 'Queued',
    ElAgentState.planning => 'Planning',
    ElAgentState.retrieving => 'Retrieving knowledge',
    ElAgentState.ingesting => 'Ingesting data',
    ElAgentState.running => 'Running code',
    ElAgentState.delegating => 'Delegating to agent',
    ElAgentState.awaitingApproval => 'Awaiting approval',
    ElAgentState.validating => 'Validating',
    ElAgentState.retrying => 'Retrying',
    ElAgentState.error => 'Something went wrong',
    ElAgentState.summarizing => 'Summarizing',
    ElAgentState.thinking => 'Thinking',
    ElAgentState.processing => 'Processing',
    ElAgentState.callingTools => 'Calling tools',
    ElAgentState.searching => 'Searching',
    ElAgentState.reading => 'Reading files',
    ElAgentState.recalling => 'Recalling context',
    ElAgentState.writing => 'Writing',
    ElAgentState.done => 'Done',
  };

  /// `isBusy` — everything but the three resting states.
  ///
  /// `awaiting_approval` is busy but not blocking — the whole point is that the
  /// user is the one who has to act — so it counts as busy here and is handled
  /// separately wherever that distinction matters.
  bool get isBusy => !const <ElAgentState>{
    ElAgentState.idle,
    ElAgentState.done,
    ElAgentState.error,
  }.contains(this);

  /// `isNarrating` — the states that are the agent's own voice rather than its
  /// hands. The transcript reads this to decide whether a typing cursor is
  /// honest.
  bool get isNarrating => const <ElAgentState>{
    ElAgentState.planning,
    ElAgentState.summarizing,
    ElAgentState.writing,
  }.contains(this);

  /// `STATE_ICON` — one glyph per state, shared by the chip, the plus menu and
  /// the slash palette so a capability carries one mark everywhere.
  ElLucideGlyph get glyph => switch (this) {
    ElAgentState.idle => ElLucide.circle,
    ElAgentState.queued => ElLucide.clock,
    ElAgentState.planning => ElLucide.listChecks,
    ElAgentState.retrieving => ElLucide.bookOpen,
    ElAgentState.ingesting => ElLucide.database,
    ElAgentState.running => ElLucide.terminal,
    ElAgentState.delegating => ElLucide.arrowRightLeft,
    ElAgentState.awaitingApproval => ElLucide.shieldQuestionMark,
    ElAgentState.validating => ElLucide.checkCheck,
    ElAgentState.retrying => ElLucide.rotateCw,
    ElAgentState.error => ElLucide.triangleAlert,
    ElAgentState.summarizing => ElLucide.scrollText,
    ElAgentState.thinking => ElLucide.brain,
    ElAgentState.processing => ElLucide.chartColumn,
    ElAgentState.callingTools => ElLucide.wrench,
    ElAgentState.searching => ElLucide.search,
    ElAgentState.reading => ElLucide.bookOpen,
    // `HistoryIcon` — lucide's alias for `rotate-ccw-clock`, which is the
    // name the generated registry keys the geometry under.
    ElAgentState.recalling => ElLucide.rotateCcwClock,
    ElAgentState.writing => ElLucide.pencil,
    ElAgentState.done => ElLucide.check,
  };
}

/// Alias — the console build reads the labels as a top-level map.
Map<ElAgentState, String> get kElAgentStateLabel => <ElAgentState, String>{
  for (final ElAgentState s in ElAgentState.values) s: s.label,
};

/// Alias — the console build reads the wire spellings as a top-level map.
Map<ElAgentState, String> get kElAgentStateId => <ElAgentState, String>{
  for (final ElAgentState s in ElAgentState.values) s: s.wire,
};

/// Alias — the console build's spelling of [ElAgentState.isBusy].
bool elAgentIsBusy(ElAgentState state) => state.isBusy;

/// Alias — the console build's spelling of [ElAgentState.isNarrating].
bool elAgentIsNarrating(ElAgentState state) => state.isNarrating;

/// `ToolStateMap` — how a product's tools map onto the state machine.
///
/// Supplied by the caller rather than guessed, because only the caller knows
/// whether `export_activity` is reading, writing or running.
typedef ElToolStateMap = Map<String, ElAgentState>;

/// Alias — the console build's spelling of [ElToolStateMap].
typedef ElAgentToolStateMap = ElToolStateMap;

/// `stateForTool` — exact match first, then prefix on a `.` or `_` boundary.
///
/// The prefix pass is what lets a caller map a whole family (`finance.` →
/// retrieving) without listing every member. **Longest prefix wins**, so a
/// specific `finance.forecast` mapping beats a blanket `finance.` one
/// regardless of declaration order — which is the reference's own rule and the
/// reason this is a loop rather than a lookup.
ElAgentState? elStateForTool(String name, ElToolStateMap? map) {
  if (map == null) return null;
  final ElAgentState? exact = map[name];
  if (exact != null) return exact;

  String? bestKey;
  ElAgentState? best;
  for (final MapEntry<String, ElAgentState> entry in map.entries) {
    final String key = entry.key;
    if (!key.endsWith('.') && !key.endsWith('_')) continue;
    if (!name.startsWith(key)) continue;
    if (bestKey == null || key.length > bestKey.length) {
      bestKey = key;
      best = entry.value;
    }
  }
  return best;
}

/// Alias — the console build's spelling of [elStateForTool].
ElAgentState? elAgentStateForTool(String name, ElToolStateMap? map) =>
    elStateForTool(name, map);

/// `humanise` — `search_inventory` → `Search inventory`.
///
/// The chip's fallback when a tool is unmapped: the tool's own name is the most
/// honest thing available, and more honest than a generic "used a tool".
String elHumaniseToolName(String name) {
  final String spaced = name
      .replaceAll(RegExp(r'[._]'), ' ')
      .replaceAllMapped(
        RegExp(r'([a-z0-9])([A-Z])'),
        (Match m) => '${m[1]} ${m[2]}',
      )
      .toLowerCase();
  if (spaced.isEmpty) return spaced;
  return spaced[0].toUpperCase() + spaced.substring(1);
}

/// `formatMs` — `912ms` under a second, `8.0s` above it.
String elFormatMs(int ms) {
  // allow-hardcoded: the second is the unit boundary, not a duration token.
  const int second = 1000;
  return ms < second ? '${ms}ms' : '${(ms / second).toStringAsFixed(1)}s';
}

/* ── Transport ───────────────────────────────────────────────────────────── */

/// `TransportCapabilities['attachments']`.
enum ElAgentAttachmentSupport { content, reference, none }

/// `TransportCapabilities` — advertised so the console renders only what this
/// agent can actually do.
@immutable
class ElAgentCapabilities {
  const ElAgentCapabilities({
    this.attachments = ElAgentAttachmentSupport.content,
    this.models = true,
    this.approvals = true,
  });

  /// Can carry attachment *content*, not just filenames.
  final ElAgentAttachmentSupport attachments;

  /// Can the model be chosen per message.
  final bool models;

  /// Can a tool call or action be held for the user to approve.
  final bool approvals;
}

/// `SendOptions` — what `send` carries beyond the sentence.
@immutable
class ElAgentSendOptions {
  const ElAgentSendOptions({
    this.attachments = const <ElAgentAttachment>[],
    this.model,
    this.wireText,
  });

  final List<ElAgentAttachment> attachments;

  /// Chosen in the model picker. A transport that cannot switch models ignores
  /// it.
  final String? model;

  /// *"What actually goes on the wire, when that differs from what the user
  /// wrote."* The transcript keeps `text`; the transport sends this.
  final String? wireText;
}

/// `AgentTransport` — *"The one interface that has to be implemented to point
/// this console at a different agent."*
///
/// A [Listenable] rather than a hook: the reference's transport is a React hook
/// returning a fresh object every render, and the console re-renders because
/// React does. A Flutter console has to be told, so the port's transport is the
/// notifier and the console listens.
abstract class ElAgentTransport implements Listenable {
  /// The transcript, in order. Owned by the transport so it can settle its own
  /// tool calls.
  List<ElAgentTurn> get turns;

  Future<void> send(String text, [ElAgentSendOptions options]);

  /// *"The user pressed stop. Not an error."*
  void abort();

  void reset();

  bool get isLoading;

  /// False while the transport is still acquiring whatever it needs before it
  /// can carry a message. The composer disables rather than dropping the first
  /// message on the floor.
  bool get isReady;

  Object? get error;

  /// Requests the transport is holding at an approval gate, keyed by turn id.
  List<ElPendingApproval> get pendingApprovals;

  ElAgentCapabilities get capabilities;
}

/* ── Resolver ────────────────────────────────────────────────────────────── */

/// `AgentSignals` — everything outside the transcript that changes what the
/// face should show.
@immutable
class ElAgentSignals {
  const ElAgentSignals({
    this.isLoading = false,
    this.awaitingFirstEvent = false,
    this.declared,
  });

  final bool isLoading;

  /// True between hitting send and the first event coming back.
  final bool awaitingFirstEvent;

  /// A state the agent asserted about itself. Wins over everything derived.
  final ElAgentState? declared;
}

/// `resolveState` — which of the twenty states is true right now.
///
/// *"Order is the specification. First match wins, and the ladder runs from
/// 'the user must act' down through 'the agent is acting' to 'nothing is
/// happening'."* The nine numbered branches below are the reference's, in its
/// order — which is why the tests for this function are written as precedence
/// pairs rather than one case per branch.
ElAgentState elResolveAgentState({
  required List<ElAgentTurn> turns,
  required ElAgentSignals signals,
  ElToolStateMap? toolStates,
}) {
  // 0. An agent that reports its own state is believed.
  final ElAgentState? declared = signals.declared;
  if (declared != null) return declared;

  final ElAgentTurn? last = turns.isEmpty ? null : turns.last;

  // 1. A fatal error outranks everything. A non-fatal one does not.
  if (last is ElErrorTurn && last.fatal) return ElAgentState.error;

  // 2. Something is waiting on a human.
  final bool heldForApproval = turns.any(
    (ElAgentTurn turn) =>
        turn is ElActionTurn && turn.approval == ElApprovalOutcome.pending,
  );
  if (heldForApproval) return ElAgentState.awaitingApproval;

  // 3. A tool in flight.
  final ElToolTurn? runningTool = _findLast<ElToolTurn>(
    turns,
    (ElToolTurn t) => t.status == ElAgentTurnStatus.running,
  );
  if (runningTool != null) {
    // A retry first, and whatever it does second.
    if (runningTool.attempt > 1) return ElAgentState.retrying;
    return elStateForTool(runningTool.name, toolStates) ??
        ElAgentState.callingTools;
  }

  // 4. The browser is doing something on the agent's behalf.
  final ElActionTurn? runningAction = _findLast<ElActionTurn>(
    turns,
    (ElActionTurn t) => t.status == ElAgentTurnStatus.running,
  );
  if (runningAction != null) return ElAgentState.processing;

  // 5. Prose is arriving.
  if (last is ElTextTurn && last.streaming) {
    return _narrationState(turns, last);
  }

  // 6. Sent, nothing back yet.
  if (signals.awaitingFirstEvent) return ElAgentState.queued;

  // 7. Loading with nothing else to say about it.
  if (signals.isLoading) return ElAgentState.thinking;

  // 8. A turn that finished.
  if (last != null && _isSettled(last)) return ElAgentState.done;

  return ElAgentState.idle;
}

/// `narrationState` — planning or summarizing.
///
/// *"Text after work is an account of it; text before work is a plan for it."*
/// The scan walks back only as far as the user's last message.
ElAgentState _narrationState(List<ElAgentTurn> turns, ElTextTurn current) {
  for (int i = turns.length - 1; i >= 0; i -= 1) {
    final ElAgentTurn turn = turns[i];
    if (identical(turn, current)) continue;
    if (turn is ElUserTurn) break;
    if (turn is ElToolTurn || turn is ElActionTurn) {
      return ElAgentState.summarizing;
    }
  }
  return ElAgentState.planning;
}

/// `isSettled` — a turn that represents finished work.
bool _isSettled(ElAgentTurn turn) => switch (turn) {
  ElTextTurn() => !turn.streaming,
  ElToolTurn() => turn.status != ElAgentTurnStatus.running,
  ElActionTurn() => turn.status != ElAgentTurnStatus.running,
  ElErrorTurn() => true,
  ElUserTurn() => false,
};

T? _findLast<T extends ElAgentTurn>(
  List<ElAgentTurn> turns,
  bool Function(T) predicate,
) {
  for (int i = turns.length - 1; i >= 0; i -= 1) {
    final ElAgentTurn turn = turns[i];
    if (turn is T && predicate(turn)) return turn;
  }
  return null;
}

/* ── Conversations ───────────────────────────────────────────────────────── */

/// `ConversationSummary`.
@immutable
class ElConversationSummary {
  const ElConversationSummary({
    required this.id,
    required this.title,
    required this.updatedAt,
    this.preview,
    this.pinned = false,
  });

  final String id;
  final String title;

  /// Rendered relative — "2 hours ago" — by the list.
  final DateTime updatedAt;

  /// First line of the opening message. The list degrades without it.
  final String? preview;

  /// Held at the top of the list, above the time-ordered rest.
  final bool pinned;

  ElConversationSummary copyWith({String? title, bool? pinned}) =>
      ElConversationSummary(
        id: id,
        title: title ?? this.title,
        updatedAt: updatedAt,
        preview: preview,
        pinned: pinned ?? this.pinned,
      );
}

/// `ConversationStore` — the fourth seam.
///
/// A caller with Prisma, localStorage, an API, or nothing at all satisfies the
/// same type, and the list renders identically over any of them.
///
/// **Capabilities are absence, not flags.** [pin] and [share] are nullable: a
/// store that cannot persist a pin simply does not supply one, and the list
/// draws no pin button and no pinned section. A `ChangeNotifier` so the widgets
/// above it rebuild when the list moves — the React original re-renders through
/// `useState`, and this is that mechanism spelled in Flutter.
abstract class ElConversationStore extends ChangeNotifier {
  List<ElConversationSummary> get conversations;

  /// The conversation on screen, or null for an unsaved new one.
  String? get activeId;

  bool get isLoading;
  String? get error;

  void open(String id);
  void create();
  void rename(String id, String title);
  void remove(String id);
  void refresh();

  /// Null when the store cannot pin. The affordance goes with it.
  void Function(String id, bool pinned)? get pin;

  /// Null when the store cannot share.
  void Function(String id)? get share;
}

/// `relativeTime` — the largest unit that still reads as a whole number.
///
/// `Intl.RelativeTimeFormat(undefined, { numeric: "auto" })` in the reference;
/// the strings below are the `en` output that formatter produces, which is what
/// a reader of the reference actually sees. `numeric: "auto"` is why one day is
/// **"yesterday"** and one week is **"last week"** rather than "1 day ago".
///
/// Under a minute is "just now" rather than "in 12 seconds": clock skew between
/// a server timestamp and a browser makes small values read as the future.
String elRelativeTime(DateTime then, {DateTime? now}) {
  final DateTime reference = now ?? DateTime.now();
  final int deltaMs = then.difference(reference).inMilliseconds;
  final int magnitude = deltaMs.abs();

  // allow-hardcoded: calendar arithmetic — the unit table is the formatter's
  // own, not a token.
  const int minute = 60000;
  const int hour = 60 * minute;
  const int day = 24 * hour;
  const int week = 7 * day;
  const int month = 30 * day;
  const int year = 365 * day;

  if (magnitude < minute) return 'just now';

  const List<(String, int)> units = <(String, int)>[
    ('year', year),
    ('month', month),
    ('week', week),
    ('day', day),
    ('hour', hour),
    ('minute', minute),
  ];

  for (final (String unit, int ms) in units) {
    if (magnitude < ms) continue;
    final int n = (deltaMs / ms).round();
    return _relative(unit, n);
  }
  return 'just now';
}

/// The `en` strings `Intl.RelativeTimeFormat` with `numeric: "auto"` emits.
String _relative(String unit, int n) {
  final int abs = n.abs();
  if (abs == 1) {
    return switch ((unit, n.isNegative)) {
      ('year', true) => 'last year',
      ('year', false) => 'next year',
      ('month', true) => 'last month',
      ('month', false) => 'next month',
      ('week', true) => 'last week',
      ('week', false) => 'next week',
      ('day', true) => 'yesterday',
      ('day', false) => 'tomorrow',
      _ => n.isNegative ? '1 $unit ago' : 'in 1 $unit',
    };
  }
  final String plural = '$abs ${unit}s';
  return n.isNegative ? '$plural ago' : 'in $plural';
}

/// [elRelativeTime] against the nearest [ElClock] — the `?clock=` seam, so a
/// rig can freeze both sides of a parity measurement on the same instant.
String elRelativeTimeOf(BuildContext context, DateTime then) =>
    elRelativeTime(then, now: ElClock.nowOf(context));

/* ── Switching conversations ─────────────────────────────────────────────── */

/// `SwitchPhase` — what the transcript wears while a conversation is swapped.
enum ElSwitchPhase {
  idle,
  out,

  /// The reference's `"in"`, which is a Dart reserved word.
  blurIn;

  /// `blurClass(phase)` — the utility a transcript wears for that phase. Kept
  /// as the class name it ports so the mapping stays checkable against source.
  String get className => switch (this) {
    ElSwitchPhase.out => 'anim-blur-out',
    ElSwitchPhase.blurIn => 'anim-blur-in',
    ElSwitchPhase.idle => '',
  };
}

/// `useBlurSwitch` — changing conversations without cutting.
///
/// **The swap is deferred, and that is the entire reason this exists.** The
/// obvious implementation — watch the conversation id and animate when it
/// changes — cannot work, because by the time the id has changed the old
/// messages are already gone. It would blur the *new* conversation out and then
/// back in: a flicker with extra steps.
///
/// So the order is inverted. This owns the transition and calls the store in
/// the middle of it: blur out over [outDuration] while the old conversation is
/// still on screen, swap at the point where nothing is legible anyway, then
/// blur in over [inDuration].
///
/// Measured on the reference (`ag-h-inter.js` §6): `pulls-blur-out` runs from
/// t≈112ms after the click to t≈374, then `pulls-blur-in` from 374 to ≈586 —
/// 150ms out, 250ms in, exactly the two duration tokens named below.
class ElBlurSwitchController extends ChangeNotifier {
  ElBlurSwitchController({required this.open});

  /// The store call. Made at the darkest point of the transition.
  final void Function(String id) open;

  /// `anim-blur-out` — `--duration-fast`.
  static Duration get outDuration => ElDurations.fast;

  /// `anim-blur-in` — `--duration-base`.
  static Duration get inDuration => ElDurations.base;

  ElSwitchPhase _phase = ElSwitchPhase.idle;
  ElSwitchPhase get phase => _phase;

  /// Bumped on every [switchTo] so an in-flight sequence can tell that a newer
  /// one has replaced it — the Dart stand-in for the reference's timer list,
  /// which it clears at the top of `switchTo`.
  int _generation = 0;
  bool _disposed = false;

  /// What a history row calls instead of `store.open`.
  void switchTo(String id) {
    final int generation = ++_generation;
    _set(ElSwitchPhase.out);
    Future<void>.delayed(outDuration, () {
      if (_disposed || generation != _generation) return;
      open(id);
      _set(ElSwitchPhase.blurIn);
      Future<void>.delayed(inDuration, () {
        if (_disposed || generation != _generation) return;
        _set(ElSwitchPhase.idle);
      });
    });
  }

  void _set(ElSwitchPhase next) {
    if (_phase == next) return;
    _phase = next;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
