/// `/design-system/components/agent/transcript`: everything above the
/// composer: turns, tool chips, approval cards, a questionnaire, the markdown
/// contract, the welcome card, and attachments in both directions.
///
/// **The fidelity bar is that it moves.** Every chip on this page opens, the
/// questionnaire is a live three-step wizard you can answer with the keyboard,
/// the approval card's two buttons resolve, and the openable image expands over
/// a dimmed page. A port that rendered these as stills fails, however exact the
/// pixels.
///
/// ## Drift register: recorded, shipped as written
///
///  1. **`<QuestionnaireError />` with no children is not empty.** The
///     primitive supplies `Choose an answer to continue.` for a required item,
///     and the first question mounts a bare error. That string is on screen and
///     appears in no page source.
///  2. **The bare-URL rule swallows the sentence's full stop.** `MARKDOWN_
///     COMPLETE_SAMPLE` ends a sentence with `https://example.com.`; the
///     `[^\s<>()]+` class does not exclude `.`, so the link label: measured
///     149.22px wide: is `https://example.com.` including the period.
///  3. **`markdown-not-supported` is a `DsSection` nested inside a
///     `DsSection`.** Its 701.8px is part of `#markdown`'s 4706.3, and its own
///     `mb-20` collapses with the outer section's rather than adding to it.
///     [_MarginCollapse] is that collapse, spelled in Flutter.
///  4. **The state grid's six cells are two different heights.** A CSS grid row
///     is as tall as its tallest cell, and the *Skipped* cell (which alone
///     carries a `Skip` button and a note) sets 186.67 for the first row while
///     *Invalid* sets 177.69 for the second.
///  5. **The welcome card's capability chip loses its own font size.** It is
///     written `type-caption` and renders at **13px/17.55px**: the `sm` rung's
///     `text-small` wins the size from the utility layer while `.type-caption`
///     keeps the 1.35 leading.
///  6. **`duration-fast` on the chip's chevron is inert**: the class-list
///     transition runs the 250ms socket default, confirmed live.
///  7. **The stand-in photograph is not on this system's tokens, on purpose.**
///     The reference's own source says so: *"these are the pixels of a stand-in
///     PHOTOGRAPH, not colours this system is choosing. A file the user
///     actually uploads carries whatever colours their camera recorded: it
///     does not follow the theme, and it must not, or the specimen would prove
///     the wrong thing."* The three values are carried across with that
///     reasoning attached.
///  8. **The image arrives as a painter rather than as bytes.** The reference
///     inlines an `image/svg+xml` data URI; Flutter has no SVG decoder and no
///     third-party dependency may be added, so the page hands
///     [DsAgentAttachmentList] the same drawing through its `imageBuilder`
///     seam. Same 640×360 box, same three colours, same caption.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../kit.dart';
import '../nav.dart';
import '../shell.dart';

/* ── Shared fixtures ─────────────────────────────────────────────────────── */

/// `PERSONA`.
const String _personaName = 'Vault';
const String _personaBlurb = 'Ask about packs, pulls, prices and your wallet.';
const List<String> _suggestions = <String>[
  'What sealed boxes are left?',
  'Export my last 30 days',
  'Buy me an Eclipse Vault pack',
  'What is Eclipse Vault worth right now?',
];

/// `TOOL_STATES`: how this product's tools map onto the state machine.
///
/// Supplied by the caller rather than guessed, because only the caller knows
/// whether `export_activity` is reading, writing or running: and a status line
/// that guesses is a status line that lies.
const DsToolStateMap _toolStates = <String, DsAgentState>{
  'search_inventory': DsAgentState.searching,
  'read_wallet': DsAgentState.retrieving,
  'export_activity': DsAgentState.writing,
  'fetch_market_price': DsAgentState.retrieving,
};

/// `COMMANDS.filter(c => c.group === "skill")`: the three the welcome card
/// advertises.
const List<DsAgentCapability> _skills = <DsAgentCapability>[
  DsAgentCapability(
    id: 'inventory',
    label: 'inventory',
    hint: 'What is in stock',
    glyph: DsLucide.search,
  ),
  DsAgentCapability(
    id: 'wallet',
    label: 'wallet',
    hint: 'Balance and recent movement',
    glyph: DsLucide.wallet,
  ),
  DsAgentCapability(
    id: 'export',
    label: 'export',
    hint: 'Download activity as CSV',
    glyph: DsLucide.download,
  ),
];

/// `describeApproval`: turns a held action into a sentence a human can decide
/// on.
String _describeApproval(String action, Map<String, Object?> params) {
  if (action == 'purchase_pack') {
    return 'Buy ${params['pack']} for '
        r'$'
        '${(params['price']! as num).toStringAsFixed(2)}. '
        'This spends real money and cannot be undone.';
  }
  return 'Run $action.';
}

const DsUserTurn _userTurn = DsUserTurn(
  id: 'spec-user',
  text: 'What sealed boxes are left, and what is the best one?',
);

const DsTextTurn _agentTurn = DsTextTurn(
  id: 'spec-agent',
  text:
      'Three sealed boxes match. The strongest is '
      '**Eclipse Vault — 1st Edition**, with 24 packs left of an original '
      '250.\n\nWant me to put one on hold?',
);

const DsTextTurn _streamingTurn = DsTextTurn(
  id: 'spec-streaming',
  text: 'Checking the vault',
  streaming: true,
);

const DsToolTurn _toolRunning = DsToolTurn(
  id: 'spec-tool-running',
  name: 'search_inventory',
  params: <String, Object?>{'query': 'sealed booster boxes', 'limit': 3},
  status: DsAgentTurnStatus.running,
  attempt: 1,
);

const DsToolTurn _toolOk = DsToolTurn(
  id: 'spec-tool-ok',
  name: 'search_inventory',
  params: <String, Object?>{'query': 'sealed booster boxes', 'limit': 3},
  status: DsAgentTurnStatus.ok,
  result: <String, Object?>{
    'matches': 3,
    'topResult': 'Eclipse Vault — 1st Edition',
  },
  ms: 912,
  attempt: 1,
);

const DsToolTurn _toolError = DsToolTurn(
  id: 'spec-tool-error',
  name: 'fetch_market_price',
  params: <String, Object?>{'item': 'Eclipse Vault'},
  status: DsAgentTurnStatus.error,
  error: 'The pricing service did not respond in time.',
  ms: 8004,
  attempt: 2,
);

const DsAgentAttachment _produced = DsAgentAttachment(
  id: 'spec-csv',
  name: 'activity-30d.csv',
  mime: 'text/csv',
  kind: DsAgentAttachmentKind.data,
  size: 4821,
  delivery: DsAgentDelivery.produced(),
);

const DsToolTurn _toolWithFile = DsToolTurn(
  id: 'spec-tool-file',
  name: 'export_activity',
  params: <String, Object?>{'window': '30d', 'format': 'csv'},
  status: DsAgentTurnStatus.ok,
  result: <String, Object?>{'rows': 148},
  attachments: <DsAgentAttachment>[_produced],
  ms: 1204,
  attempt: 1,
);

/// The three delivery outcomes, sitting side by side.
///
/// `content` and `reference` use the same kind/mime logic `serialiseAttachments`
/// actually runs: a CSV is textual and gets inlined, a PDF is not and only its
/// name travels. `produced` is the shape `extractProduced` stamps on a tool's
/// own output. No `error` or `uploading` example lives here: the domain type
/// cannot express either.
const List<DsAgentAttachment> _deliverySpecimens = <DsAgentAttachment>[
  DsAgentAttachment(
    id: 'spec-delivery-content',
    name: 'collection-export.csv',
    mime: 'text/csv',
    kind: DsAgentAttachmentKind.data,
    size: 18422,
    delivery: DsAgentDelivery.content(),
  ),
  DsAgentAttachment(
    id: 'spec-delivery-reference',
    name: 'grading-report.pdf',
    mime: 'application/pdf',
    kind: DsAgentAttachmentKind.document,
    size: 2620000,
    delivery: DsAgentDelivery.reference(
      'This file is not text, so its contents could not be inlined.',
    ),
  ),
  DsAgentAttachment(
    id: 'spec-delivery-produced',
    name: 'activity-30d.csv',
    mime: 'text/csv',
    kind: DsAgentAttachmentKind.data,
    size: 4821,
    delivery: DsAgentDelivery.produced(),
  ),
];

/// The reference's `SPEC_IMAGE_URL`. Nothing fetches it, [_StandInPhotograph]
/// draws the same picture: but the model carries a url because a url is what
/// unlocks both behaviours this panel exists to prove.
const String _specImageUrl = 'data:image/svg+xml;utf8,pull-of-the-week';

const List<DsAgentAttachment> _openableSpecimens = <DsAgentAttachment>[
  DsAgentAttachment(
    id: 'spec-openable-image',
    name: 'pull-of-the-week.png',
    mime: 'image/png',
    kind: DsAgentAttachmentKind.image,
    size: 184220,
    url: _specImageUrl,
    delivery: DsAgentDelivery.content(),
  ),
  DsAgentAttachment(
    id: 'spec-openable-doc',
    name: 'grading-report.pdf',
    mime: 'application/pdf',
    kind: DsAgentAttachmentKind.document,
    size: 2620000,
    url: _specImageUrl,
    delivery: DsAgentDelivery.reference(
      'This file is not text, so its contents could not be inlined.',
    ),
  ),
];

const DsPendingApproval _heldAction = DsPendingApproval(
  turnId: 'spec-action',
  action: 'purchase_pack',
  params: <String, Object?>{
    'pack': 'Eclipse Vault — 1st Edition',
    'price': 129,
    'currency': 'USD',
  },
  approve: _noop,
  reject: _noopReject,
);

void _noop() {}
void _noopReject([String? reason]) {}

const List<String> _packStyleChoices = <String>[
  "Whatever's cheapest tonight",
  'Best odds on a chase card',
  'Whatever just dropped',
];
const List<String> _packStyleValues = <String>['price', 'odds', 'new'];

/* ── Markdown fixtures ───────────────────────────────────────────────────── */

const String _markdownSample = '''
The three boxes still sealed:

| Pack | Left | Last sale |
|:---|---:|---:|
| Eclipse Vault — 1st Ed. | 24 | \$240.00 |
| Aurora Prism | 61 | \$84.50 |
| Cobalt Run | 8 | \$72.00 |

Cobalt Run is the scarcest but the thinnest market — only two sales in thirty days.

```ts
const odds = pulls.filter((p) => p.rarity === "grail").length / pulls.length;
```

1. Scarcity is not the same as value
2. A thin market moves on one sale
3. Sealed is not the same as graded''';

const String _markdownComplete = r'''
# Inventory report

The **Eclipse Vault** is *still sealed*. Read the [grading guide](/design-system) or visit https://example.com.

> Scarcity is not the same as value.

- Twenty-four boxes remain
* Two sold this week
• One listing is under review

7. Compare recent sales
8) Check the remaining supply

| Pack | Left | Last sale |
|:---|---:|:---:|
| Eclipse Vault | 24 | $240.00 |
| Aurora \| Prism | 61 | $84.50 |

`inlineCode()` stays inside the sentence.

```ts
const sealed = packs.filter((pack) => pack.sealed);
```''';

const String _tableSource =
    '| Pack | Left | Status |\n|:---|---:|:---:|\n'
    '| Eclipse Vault | 24 | **Ready** |\n| Aurora \\| Prism | 61 | Review |';

/// `MARKDOWN_LIMITS`.
const List<(String, String)> _markdownLimits = <(String, String)>[
  (
    'Headings 5–6',
    'Not parsed. Lines beginning with ##### or ###### fall back to paragraph text.',
  ),
  (
    'Nested lists',
    'Not hierarchical. Indented bullets and numbers are flattened into the current list.',
  ),
  (
    'Task lists',
    'Not interactive. - [x] and - [ ] render as ordinary bullets with literal bracket text.',
  ),
  (
    'Images',
    'Not rendered. Image syntax is not an attachment API; use the transcript attachment model instead.',
  ),
  ('Strike-through', 'Not parsed. Double tildes remain visible text.'),
  ('Horizontal rules', 'Not parsed. A line of dashes remains paragraph text.'),
  (
    'Raw HTML',
    'Never interpreted. Tags render as text, which prevents model output from injecting markup or scripts.',
  ),
  (
    'Footnotes / definitions',
    'Not parsed. Reference links, footnotes, definition lists and abbreviations remain text.',
  ),
  (
    'Nested inline styles',
    'Not recursively parsed. Formatting inside bold, emphasis, links or inline code remains literal.',
  ),
];

/* ── Page-local geometry ─────────────────────────────────────────────────── */

Widget _mt(double steps, Widget child) => Padding(
  padding: EdgeInsets.only(top: ds(steps)),
  child: child,
);

/// `p-6` inside a flush panel.
double get _panelInset => ds(6);

/* ── The page ────────────────────────────────────────────────────────────── */

class TranscriptPage extends StatelessWidget {
  const TranscriptPage({super.key});

  @override
  Widget build(BuildContext context) {
    final DsCategoryHit here = findCategory('agent', 'transcript');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DsPageHeader(
          eyebrow: '${here.group.title} · Components',
          title: here.category.title,
          blurb: here.category.blurb,
          contents: here.category.contents,
        ),
        const _TurnsSection(),
        const _ToolsSection(),
        const _ApprovalSection(),
        const _QuestionnaireSection(),
        const _MarkdownSection(),
        const _WelcomeSection(),
        const _AttachmentsSection(),
        const DsPageFootNav(groupId: 'agent', slug: 'transcript'),
      ],
    );
  }
}

/* ── §1 Turns ────────────────────────────────────────────────────────────── */

class _TurnsSection extends StatelessWidget {
  const _TurnsSection();

  @override
  Widget build(BuildContext context) => DsSection(
    id: 'turns',
    title: 'Turns',
    description:
        "The user's turn sits on --card; the agent's sits on --agent-muted, "
        'one step toward the action ramp. Enough that whose turn it is '
        'survives a squint, not so much that a long answer becomes a '
        'coloured slab.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const DsPanel(
          label: 'Message',
          note: 'user · agent · streaming',
          child: _TranscriptTurns(),
        ),
        _mt(6, const _TurnsNote()),
      ],
    ),
  );
}

class _TranscriptTurns extends StatelessWidget {
  const _TranscriptTurns();

  /// `gap-4`.
  static double get gap => ds(4);

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DsUserMessage(turn: _userTurn),
      SizedBox(height: gap),
      const DsAgentMessage(turn: _agentTurn),
      SizedBox(height: gap),
      const DsAgentMessage(turn: _streamingTurn),
    ],
  );
}

class _TurnsNote extends StatelessWidget {
  const _TurnsNote();

  @override
  Widget build(BuildContext context) => DsRichText(
    TextSpan(
      children: <InlineSpan>[
        const TextSpan(
          text: 'The third turn is mid-stream. The caret is the one place ',
        ),
        DsCode.span('--agent'),
        const TextSpan(
          text:
              ' is used as a solid fill rather than as a foreground — a '
              'mark a pixel and a half wide, pulsing on ',
        ),
        DsCode.span('anim-pulse-live'),
        const TextSpan(
          text: '. It is what tells a reader the agent has not stalled.',
        ),
      ],
    ),
    DsType.small,
  );
}

/* ── §2 Tool chips ───────────────────────────────────────────────────────── */

class _ToolsSection extends StatelessWidget {
  const _ToolsSection();

  @override
  Widget build(BuildContext context) => DsSection(
    id: 'tools',
    title: 'Tool chips',
    description:
        'What the agent did, while it is doing it. The glyph comes from the '
        'state the tool maps to, so one capability carries one mark '
        'everywhere it appears — in the chip, in the plus menu and in the '
        'slash palette.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const DsPanel(
          label: 'ToolChip',
          note: 'running · ok · produced a file · failed',
          child: _ToolChips(),
        ),
        _mt(
          6,
          const DsNote(
            tone: DsNoteTone.value,
            title: 'The failed chip is not decoration',
            child: _FailedChipNote(),
          ),
        ),
      ],
    ),
  );
}

class _FailedChipNote extends StatelessWidget {
  const _FailedChipNote();

  @override
  Widget build(BuildContext context) => DsText(
    'It carries the attempt count. A tool that succeeded on its second try '
    'is a different fact from one that succeeded outright, and hiding the '
    'retry makes an agent look more reliable than it is.',
    DsType.small,
  );
}

class _ToolChips extends StatelessWidget {
  const _ToolChips();

  /// `flex flex-col items-start gap-3`.
  static double get gap => ds(3);

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      const DsToolChip(turn: _toolRunning, toolStates: _toolStates),
      SizedBox(height: gap),
      const DsToolChip(turn: _toolOk, toolStates: _toolStates),
      SizedBox(height: gap),
      const DsToolChip(turn: _toolWithFile, toolStates: _toolStates),
      SizedBox(height: gap),
      const DsToolChip(turn: _toolError, toolStates: _toolStates),
    ],
  );
}

/* ── §3 Approval ─────────────────────────────────────────────────────────── */

class _ApprovalSection extends StatelessWidget {
  const _ApprovalSection();

  @override
  Widget build(BuildContext context) => DsSection(
    id: 'approval',
    title: 'Approval card',
    description:
        'Where the agent stops. Anything irreversible is held here rather '
        "than run, and the card's whole job is to turn a function call into "
        'a sentence a human can actually decide on.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const DsPanel(
          label: 'ApprovalCard',
          note: 'purchase_pack — held',
          child: DsApprovalCard(
            approval: _heldAction,
            describe: _describeApproval,
          ),
        ),
        _mt(
          6,
          const DsDoDont(
            dos: <String>[
              "Describe the consequence in the user's language — what it "
                  'costs, what it changes, whether it can be undone.',
              'Make declining a normal outcome. The user said no; the agent '
                  'should say so, not throw.',
              'Hold anything that spends money, sends a message, or deletes.',
            ],
            donts: <String>[
              'Print the raw action name and its JSON parameters and call '
                  'that a prompt.',
              'Default the confirming button to safe styling when the action '
                  'is not safe.',
              'Ask for approval on something reversible — an approval the '
                  'user learns to click through is worse than none.',
            ],
          ),
        ),
      ],
    ),
  );
}

/* ── §4 Questionnaire ────────────────────────────────────────────────────── */

class _QuestionnaireSection extends StatelessWidget {
  const _QuestionnaireSection();

  @override
  Widget build(BuildContext context) => DsSection(
    id: 'questionnaire',
    title: 'Questionnaire',
    description:
        'A structured question is the same interaction shape as an approval '
        'card — the agent speaks, the user answers inline — so it lives '
        'right beside it. Press A, B or C to answer the first question '
        'without a mouse; the keys are the ones drawn on the choices.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const DsPanel(
          label: 'Questionnaire',
          note:
              'unanswered · answered · skipped · invalid · submitting · complete',
          child: _QuestionnaireDemo(),
        ),
        _mt(
          6,
          const DsStateGrid(
            cols: 3,
            children: <Widget>[
              DsStateCell(label: 'Unanswered', child: _QuestionnaireCell()),
              DsStateCell(
                label: 'Answered',
                child: _QuestionnaireCell(checked: true),
              ),
              DsStateCell(
                label: 'Skipped',
                note: 'optional questions only',
                child: _QuestionnaireCell(withSkip: true),
              ),
              DsStateCell(label: 'Invalid', child: _QuestionnaireInvalidCell()),
              DsStateCell(
                label: 'Submitting',
                child: DsQuestionnaireSubmittingView(),
              ),
              DsStateCell(
                label: 'Complete',
                child: DsQuestionnaireCompleteView(),
              ),
            ],
          ),
        ),
        _mt(
          6,
          const DsNote(
            title: 'Shortcuts are drawn, not just bound',
            child: _ShortcutsNoteBody(),
          ),
        ),
      ],
    ),
  );
}

class _ShortcutsNoteBody extends StatelessWidget {
  const _ShortcutsNoteBody();

  @override
  Widget build(BuildContext context) => DsRichText(
    TextSpan(
      children: <InlineSpan>[
        DsCode.span('Questionnaire'),
        const TextSpan(text: ' can bind '),
        DsCode.span('A'),
        const TextSpan(text: '/'),
        DsCode.span('B'),
        const TextSpan(text: '/'),
        DsCode.span('C'),
        const TextSpan(text: ' (or '),
        DsCode.span('1'),
        const TextSpan(text: '/'),
        DsCode.span('2'),
        const TextSpan(text: '/'),
        DsCode.span('3'),
        const TextSpan(
          text:
              ') to each choice without showing anything for it — the key '
              'still works, it is just invisible. That is the same failure '
              '§7 rules out for a progress bar that announces nothing: a '
              'shortcut nobody can see is a shortcut nobody uses. Every '
              'choice above renders its key in a ',
        ),
        DsCode.span('Kbd'),
        const TextSpan(text: '.'),
      ],
    ),
    DsType.small,
  );
}

/// The full flow, live. All six states are reachable by clicking through it.
class _QuestionnaireDemo extends StatefulWidget {
  const _QuestionnaireDemo();

  @override
  State<_QuestionnaireDemo> createState() => _QuestionnaireDemoState();
}

enum _Phase { form, submitting, complete }

class _QuestionnaireDemoState extends State<_QuestionnaireDemo> {
  _Phase _phase = _Phase.form;
  int _generation = 0;

  /// `setTimeout(() => setPhase("complete"), 900)`: the transport round trip
  /// this specimen fakes so `submitting` and `complete` are both reachable.
  ///
  /// It is latency, not motion: nothing interpolates over it, no easing reads
  /// it, and retuning `--duration-*` must not move it. Same species as
  /// `forms.dart`'s `_accountLatency` / `_serverLatency`, and annotated the
  /// same way for the same reason.
  static const Duration _roundTrip = Duration(
    milliseconds: 900,
  ); // allow-hardcoded: the reference's simulated submit latency, not a --duration-* token

  void _submit() {
    setState(() => _phase = _Phase.submitting);
    final int generation = ++_generation;
    Future<void>.delayed(_roundTrip, () {
      if (mounted && generation == _generation) {
        setState(() => _phase = _Phase.complete);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_phase == _Phase.complete) {
      return DsQuestionnaireCompleteView(
        onRestart: () => setState(() => _phase = _Phase.form),
      );
    }
    if (_phase == _Phase.submitting) {
      return const DsQuestionnaireSubmittingView();
    }

    return DsQuestionnaire(
      shortcuts: DsQuestionnaireShortcuts.letters,
      onSubmit: _submit,
      children: <Widget>[
        const DsQuestionnaireProgress(),
        DsQuestionnaireItem(
          name: 'style',
          required: true,
          title: const DsQuestionnaireTitle('How do you usually pick a pack?'),
          children: <Widget>[
            DsQuestionnaireChoices(
              children: <DsQuestionnaireChoice>[
                for (int i = 0; i < _packStyleValues.length; i += 1)
                  DsQuestionnaireChoice(
                    value: _packStyleValues[i],
                    label: _packStyleChoices[i],
                  ),
              ],
            ),
            const DsQuestionnaireError(),
          ],
        ),
        const DsQuestionnaireItem(
          name: 'goal',
          title: DsQuestionnaireTitle('Chasing anything specific?'),
          description: DsQuestionnaireDescription(
            'Optional — Skip moves on without an answer.',
          ),
          children: <Widget>[
            DsQuestionnaireInput(placeholder: 'A card, a set, a rarity…'),
          ],
        ),
        const DsQuestionnaireItem(
          name: 'budget',
          required: true,
          title: DsQuestionnaireTitle("What's tonight's budget?"),
          children: <Widget>[
            DsQuestionnaireInput(
              placeholder: r'$',
              keyboardType: TextInputType.number,
            ),
            DsQuestionnaireError(text: 'Enter an amount before continuing.'),
          ],
        ),
        const DsQuestionnaireActions(
          children: <Widget>[
            DsQuestionnairePrevious(),
            DsQuestionnaireSkip(),
            DsQuestionnaireNext(),
            DsQuestionnaireSubmit(),
          ],
        ),
      ],
    );
  }
}

/// One state per cell, for the reference matrix. Each is its own isolated root
///, `onSubmit` swallows the event on every one of them, because a single-item
/// root with a visible Skip or Submit control will submit the moment it is
/// pressed, and this cell only exists to be looked at.
class _QuestionnaireCell extends StatelessWidget {
  const _QuestionnaireCell({this.checked = false, this.withSkip = false});

  /// `className="w-full gap-3"`.
  static double get gap => ds(3);

  final bool checked;
  final bool withSkip;

  @override
  Widget build(BuildContext context) => DsQuestionnaire(
    gap: gap,
    children: <Widget>[
      DsQuestionnaireItem(
        name: 'demo',
        children: <Widget>[
          DsQuestionnaireChoices(
            children: <DsQuestionnaireChoice>[
              DsQuestionnaireChoice(
                value: 'a',
                label: 'Option A',
                defaultChecked: checked,
              ),
            ],
          ),
          if (withSkip)
            const DsQuestionnaireActions(
              children: <Widget>[DsQuestionnaireSkip()],
            ),
        ],
      ),
    ],
  );
}

class _QuestionnaireInvalidCell extends StatelessWidget {
  const _QuestionnaireInvalidCell();

  @override
  Widget build(BuildContext context) => DsQuestionnaire(
    gap: _QuestionnaireCell.gap,
    children: const <Widget>[
      DsQuestionnaireItem(
        name: 'demo',
        required: true,
        invalid: true,
        title: DsQuestionnaireTitle('Budget'),
        children: <Widget>[
          DsQuestionnaireInput(placeholder: r'$'),
          DsQuestionnaireError(text: 'Enter an amount before continuing.'),
        ],
      ),
    ],
  );
}

/// `QuestionnaireSubmittingView`, `submitting` is not a state the primitive
/// tracks. It is the shape a transport's round trip actually takes once the
/// form validates, so this specimen owns it the same way a real integration
/// would.
class DsQuestionnaireSubmittingView extends StatelessWidget {
  const DsQuestionnaireSubmittingView({super.key});

  /// `flex flex-col items-center gap-3 py-6 text-center`.
  static double get gap => ds(3);
  static double get padY => ds(6);

  /// `size-6`.
  static double get spinnerPx => ds(6);

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: padY),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          DefaultTextStyle.merge(
            style: TextStyle(color: theme.actionInk),
            child: DsSpinner(size: spinnerPx),
          ),
          SizedBox(height: gap),
          DsText('Saving your answers…', DsType.small, align: TextAlign.center),
        ],
      ),
    );
  }
}

/// `QuestionnaireCompleteView`. The blurb and the restart control appear only
/// when a caller supplies [onRestart]: which is why the state-grid cell shows
/// the icon and the headline alone.
class DsQuestionnaireCompleteView extends StatelessWidget {
  const DsQuestionnaireCompleteView({super.key, this.onRestart});

  final VoidCallback? onRestart;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: DsQuestionnaireSubmittingView.padY,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const DsIcon.lucide(
            DsLucide.circleCheck,
            size: DsIconSize.xl,
            tone: DsIconTone.success,
          ),
          SizedBox(height: DsQuestionnaireSubmittingView.gap),
          DsText(
            'That’s everything.',
            DsType.h4,
            color: theme.foreground,
            align: TextAlign.center,
          ),
          if (onRestart != null) ...<Widget>[
            SizedBox(height: DsQuestionnaireSubmittingView.gap),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: DsContainers.xs),
              child: DsText(
                'Vault will use this to surface packs you’d actually open.',
                DsType.small,
                align: TextAlign.center,
              ),
            ),
            SizedBox(height: DsQuestionnaireSubmittingView.gap),
            DsButton(
              size: DsButtonSize.sm,
              variant: DsButtonVariant.outline,
              onPressed: onRestart,
              child: const Text('Answer again'),
            ),
          ],
        ],
      ),
    );
  }
}

/* ── §5 Markdown ─────────────────────────────────────────────────────────── */

class _MarkdownSection extends StatelessWidget {
  const _MarkdownSection();

  @override
  Widget build(BuildContext context) => DsSection(
    id: 'markdown',
    title: 'Markdown',
    description:
        'The complete contract of the hand-written, injection-safe Markdown '
        'subset used for both user and agent turns. Each row shows the '
        'source the transport supplies beside the React output the '
        'transcript renders.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const DsPanel(
          label: 'Transcript example',
          note: 'table · code · ordered list',
          child: DsAgentMarkdown(text: _markdownSample),
        ),
        _mt(
          4,
          const DsNote(title: 'A deliberate subset', child: _SubsetNoteBody()),
        ),
        _mt(8, const _MarkdownCaseList(_blockCases)),
        _mt(8, const _MarkdownCaseList(_inlineCases)),
        _mt(8, const _TablesPanel()),
        _mt(
          8,
          const DsPanel(
            label: 'Everything together',
            child: DsAgentMarkdown(text: _markdownComplete),
          ),
        ),
        // `mt-12` on a section already inside a section: its own `mb-20`
        // collapses with the outer one's rather than adding to it.
        _mt(12, const _MarginCollapse(child: _NotSupportedSection())),
      ],
    ),
  );
}

class _SubsetNoteBody extends StatelessWidget {
  const _SubsetNoteBody();

  @override
  Widget build(BuildContext context) => DsRichText(
    TextSpan(
      children: <InlineSpan>[
        const TextSpan(
          text:
              'This is not a CommonMark or GitHub-Flavored Markdown '
              'package. It recognizes the syntax an agent routinely writes, '
              'builds React elements directly, and leaves everything else '
              'as visible text. That smaller contract is what makes raw '
              'model output safe without',
        ),
        DsCode.span('dangerouslySetInnerHTML'),
        const TextSpan(text: ' or an HTML sanitizer.'),
      ],
    ),
    DsType.small,
  );
}

typedef _Case = ({String syntax, String use, String source});

const List<_Case> _blockCases = <_Case>[
  (
    syntax: '# through ####',
    use:
        'Heading levels one through four are accepted. All four use the '
        "transcript's type-h4 treatment, so model output cannot create "
        'page-level hierarchy inside a message.',
    source:
        '# Heading one\n## Heading two\n### Heading three\n#### Heading four',
  ),
  (
    syntax: 'Paragraphs',
    use:
        'Adjacent non-empty lines join into one paragraph. A blank line starts '
        'a new paragraph.',
    source:
        'A wrapped sentence can continue\non the next source line.\n\n'
        'A blank line starts the next paragraph.',
  ),
  (
    syntax: '-  *  •',
    use:
        'Dash, asterisk and literal bullet markers create one unordered list. '
        'A plain line after an item continues that item.',
    source:
        '- Dash marker\n* Asterisk marker\n• Literal bullet\n'
        'This line continues the bullet above.',
  ),
  (
    syntax: '1.  2)',
    use:
        'Period and closing-parenthesis markers create ordered lists. Authored '
        'numbers are preserved, including a list that starts above one or skips '
        'a value.',
    source: '4. Inspect the file\n5) Compare the totals\n7. Record the gap',
  ),
  (
    syntax: '> quote',
    use:
        'Consecutive quote lines join into one blockquote. Inline formatting is '
        'supported inside it.',
    source:
        '> **Value** is not the same as price.\n'
        '> Keep the distinction explicit.',
  ),
  (
    syntax: '```lang',
    use:
        'Fenced code preserves whitespace and scrolls horizontally. A supported '
        'language selects Prism tokenization with the VS Code Dark Plus '
        'palette. An unfinished streaming fence safely runs to the end.',
    source:
        '```ts\nconst total = rows.reduce((sum, row) => sum + row.value, 0);'
        '\n```',
  ),
];

const List<_Case> _inlineCases = <_Case>[
  (
    syntax: '**strong** and *emphasis*',
    use:
        'Double asterisks make strong text. Single asterisks or boundary-safe '
        'underscores make emphasis.',
    source: 'A **strong result**, an *emphasized note*, and _another note_.',
  ),
  (
    syntax: '`inline code`',
    use:
        'Single-backtick spans render as code and are matched before other '
        'inline syntax, so asterisks inside code stay literal.',
    source: 'Call `calculate("**raw**")` before rendering the total.',
  ),
  (
    syntax: '[label](url)',
    use:
        'Markdown links accept root-relative paths, page fragments and absolute '
        'HTTP(S) URLs. Unsafe or malformed destinations keep their label but '
        'lose the link.',
    source:
        'Open [the design system](/design-system), [this section](#markdown),'
        ' or [the web](https://example.com).',
  ),
  (
    syntax: 'https://example.com',
    use:
        'Bare HTTP and HTTPS URLs become external links. Other schemes do not. '
        'External links open in a new tab with noopener and noreferrer.',
    source: 'Reference: https://example.com/docs',
  ),
];

class _MarkdownCaseList extends StatelessWidget {
  const _MarkdownCaseList(this.cases);

  final List<_Case> cases;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(DsRadii.xl),
        border: Border.all(color: theme.border, width: DsWidths.hairline),
      ),
      child: Padding(
        padding: const EdgeInsets.all(DsWidths.hairline),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(DsRadii.xl - DsWidths.hairline),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              for (int i = 0; i < cases.length; i += 1)
                // `Container`, not `DecoratedBox`: `border-b` is a *box* the
                // row grows for, and only `Container` folds a decoration's
                // border into the layout. Measured 278 against the reference's
                // 279 on every bordered row before this.
                Container(
                  decoration: BoxDecoration(
                    border: i == cases.length - 1
                        ? null
                        : Border(
                            bottom: BorderSide(
                              color: theme.border,
                              width: DsWidths.hairline,
                            ),
                          ),
                  ),
                  child: _MarkdownCase(cases[i]),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// `grid gap-4 border-b border-border px-6 py-7 last:border-b-0 lg:grid-cols-2
/// lg:gap-8`.
class _MarkdownCase extends StatelessWidget {
  const _MarkdownCase(this.data);

  static double get padX => ds(6);
  static double get padY => ds(7);
  static double get gapNarrow => ds(4);
  static double get gapWide => ds(8);

  final _Case data;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final bool wide = MediaQuery.sizeOf(context).width >= DsBreakpoints.lg;

    final Widget left = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        DsText(data.syntax, DsType.code, color: theme.actionInk),
        _mt(2, DsText(data.use, DsType.small)),
        _mt(4, _SourceBlock(data.source)),
      ],
    );

    final Widget right = Container(
      padding: EdgeInsets.all(ds(5)),
      decoration: BoxDecoration(
        color: theme.background,
        borderRadius: BorderRadius.circular(DsRadii.lg),
        border: Border.all(color: theme.border, width: DsWidths.hairline),
      ),
      child: DsAgentMarkdown(text: data.source),
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padX, vertical: padY),
      child: wide
          ? IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Align(
                      alignment: AlignmentDirectional.topStart,
                      child: left,
                    ),
                  ),
                  SizedBox(width: gapWide),
                  Expanded(child: right),
                ],
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                left,
                SizedBox(height: gapNarrow),
                right,
              ],
            ),
    );
  }
}

/// `pre.scrollbar-thin overflow-x-auto rounded-md border border-border bg-muted
/// p-3` holding `code.type-code text-foreground`.
class _SourceBlock extends StatelessWidget {
  const _SourceBlock(this.source);

  final String source;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Container(
      padding: EdgeInsets.all(ds(3)),
      decoration: BoxDecoration(
        color: theme.muted,
        borderRadius: BorderRadius.circular(DsRadii.md),
        border: Border.all(color: theme.border, width: DsWidths.hairline),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        // The `pre` keeps the page's own 16px/24px strut, `.type-code` is on
        // the `<code>` inside it, not on the block. Measured 122 for four
        // lines, which is 24 + 2 + 4 × 24.
        child: DsPreformattedCode(code: source, color: theme.foreground),
      ),
    );
  }
}

class _TablesPanel extends StatelessWidget {
  const _TablesPanel();

  @override
  Widget build(BuildContext context) {
    final bool wide = MediaQuery.sizeOf(context).width >= DsBreakpoints.lg;
    final Widget source = const _SourceBlock(_tableSource);
    const Widget rendered = DsAgentMarkdown(text: _tableSource);

    return DsPanel(
      label: 'Tables',
      note: 'header · delimiter · rows · alignment · escaped pipes',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (wide)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(child: source),
                SizedBox(width: ds(6)),
                const Expanded(child: rendered),
              ],
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                source,
                SizedBox(height: ds(6)),
                rendered,
              ],
            ),
          _mt(
            5,
            DsText(
              'A table requires a header followed immediately by a delimiter '
              'row. Colons set left, center or right alignment; right-aligned '
              'cells use tabular figures. Escaped pipes stay inside a cell. '
              'Ragged streaming rows are padded to the header width, and wide '
              'tables scroll inside their own border instead of widening the '
              'transcript.',
              DsType.small,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotSupportedSection extends StatelessWidget {
  const _NotSupportedSection();

  @override
  Widget build(BuildContext context) => DsSection(
    id: 'markdown-not-supported',
    title: 'Markdown not supported',
    description:
        'These forms are outside the transcript contract today. They remain '
        'readable text or degrade to an ordinary list; none should be '
        'generated when a richer supported form exists.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DsMeta(
          items: <DsMetaItem>[
            for (final (String k, String v) in _markdownLimits)
              (k: k, v: TextSpan(text: v)),
          ],
        ),
        const DsDoDont(
          dos: <String>[
            'Use headings one through four, flat lists, quotes, fenced code '
                'and delimiter-row tables.',
            'Send images and files through Attachment rather than embedding '
                'Markdown image syntax.',
            'Treat Markdown as untrusted text; keep the renderer on React '
                'elements and safe URL schemes.',
          ],
          donts: <String>[
            'Promise full CommonMark or GFM compatibility—the parser '
                'intentionally implements a smaller contract.',
            'Depend on nested lists, checkboxes, strike-through, footnotes '
                'or raw HTML.',
            'Put meaningful formatting inside another inline mark; nested '
                'inline syntax is not recursively parsed.',
          ],
        ),
      ],
    ),
  );
}

/// CSS margin collapsing, as a render object.
///
/// Two adjoining bottom margins collapse to the larger of the two; the kit pays
/// `mb-20` as padding *inside* a section's own box, so a section nested as the
/// last child of another would pay it twice. This reports the child one
/// section-margin shorter and paints it unmoved, which is exactly what the
/// browser does.
class _MarginCollapse extends SingleChildRenderObjectWidget {
  const _MarginCollapse({required Widget child}) : super(child: child);

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderMarginCollapse(ds(20));

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    (renderObject as _RenderMarginCollapse).amount = ds(20);
  }
}

class _RenderMarginCollapse extends RenderProxyBox {
  _RenderMarginCollapse(this._amount);

  double _amount;
  set amount(double value) {
    if (value == _amount) return;
    _amount = value;
    markNeedsLayout();
  }

  double _shrink(double height) => (height - _amount).clamp(0, double.infinity);

  @override
  double computeMinIntrinsicHeight(double width) =>
      _shrink(super.computeMinIntrinsicHeight(width));

  @override
  double computeMaxIntrinsicHeight(double width) =>
      _shrink(super.computeMaxIntrinsicHeight(width));

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final RenderBox? child = this.child;
    if (child == null) return constraints.smallest;
    final Size size = child.getDryLayout(constraints);
    return constraints.constrain(Size(size.width, _shrink(size.height)));
  }

  @override
  void performLayout() {
    final RenderBox? child = this.child;
    if (child == null) {
      size = computeSizeForNoChild(constraints);
      return;
    }
    child.layout(constraints, parentUsesSize: true);
    size = constraints.constrain(
      Size(child.size.width, _shrink(child.size.height)),
    );
  }
}

/* ── §6 Welcome ──────────────────────────────────────────────────────────── */

class _WelcomeSection extends StatelessWidget {
  const _WelcomeSection();

  @override
  Widget build(BuildContext context) => DsSection(
    id: 'welcome',
    title: 'Welcome card',
    description:
        'The empty transcript. Starter prompts send immediately because each '
        'one is already a whole question; skills only write themselves into '
        'the composer, because a skill on its own is not a question and '
        "firing 'search the catalogue' with nothing to search for wastes a "
        'turn.',
    child: DsPanel(
      label: 'WelcomeCard',
      flush: true,
      child: Padding(
        padding: EdgeInsets.all(_panelInset),
        child: DsWelcomeCard(
          name: _personaName,
          blurb: _personaBlurb,
          suggestions: _suggestions,
          capabilities: _skills,
          onPick: (String _) {},
          onUseCapability: (DsAgentCapability _) {},
        ),
      ),
    ),
  );
}

/* ── §7 Attachments ──────────────────────────────────────────────────────── */

class _AttachmentsSection extends StatelessWidget {
  const _AttachmentsSection();

  static Widget _photograph(BuildContext context, DsAgentAttachment a) =>
      const _StandInPhotograph();

  /// **`Saving`, never `Saved`.** A plain `download` anchor gives the page no
  /// completion event, so claiming the bytes reached the disk would assert a
  /// capability this component does not have.
  static void _saving(String name) => docsToasts.show(
    DsToastMessage(
      title: 'Saving $name',
      description: 'Your browser is handling the download.',
    ),
  );

  @override
  Widget build(BuildContext context) => DsSection(
    id: 'attachments',
    title: 'Attachments travel in both directions',
    description:
        'A file the user picks and a file the agent produced are the same '
        'object to everything that draws them, which is what stops the '
        'transcript growing two parallel renderers that drift apart.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const DsNote(
          title: 'Delivery is stated, never implied',
          child: _DeliveryNoteBody(),
        ),
        _mt(
          4,
          const DsPanel(
            label: 'AttachmentList',
            note: 'content · reference · produced',
            child: DsAgentAttachmentList(attachments: _deliverySpecimens),
          ),
        ),
        _mt(
          4,
          DsPanel(
            label: 'Openable — media expands, documents download',
            note: 'both need a url',
            child: DsAgentAttachmentList(
              attachments: _openableSpecimens,
              imageBuilder: _photograph,
              onDownload: _saving,
            ),
          ),
        ),
        _mt(
          4,
          const DsNote(
            title: 'A url changes what an attachment can do',
            child: _UrlNoteBody(),
          ),
        ),
        _mt(
          4,
          const DsNote(
            tone: DsNoteTone.value,
            title: 'Built on ui/attachment.tsx, not beside it',
            child: _BuiltOnNoteBody(),
          ),
        ),
        _mt(
          4,
          DsMeta(
            items: <DsMetaItem>[
              (
                k: 'AttachmentCard',
                v: const TextSpan(
                  text:
                      'One file. Renders through ui/attachment.tsx at its '
                      'default size and horizontal orientation, state always '
                      '"done". Shows a download action when url and no '
                      'onRemove, a remove action when onRemove is passed — '
                      'never both.',
                ),
              ),
              (
                k: 'AttachmentList',
                v: const TextSpan(
                  text:
                      'attachments, onRemove?, compact?. Splits images '
                      '(kind === "image" && url) from everything else and '
                      'lays each group out separately — a picture wants '
                      'width, a spreadsheet wants a row.',
                ),
              ),
              (
                k: 'ImageAttachment',
                v: const TextSpan(
                  text:
                      'Module-private, kept outside ui/attachment.tsx on '
                      'purpose. Its AttachmentMedia is a fixed 40px well; a '
                      'screenshot shown at that size is not the thing '
                      'someone attached a screenshot to show. compact caps '
                      'it at 128px in the composer tray, 320px in the '
                      'transcript.',
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _DeliveryNoteBody extends StatelessWidget {
  const _DeliveryNoteBody();

  @override
  Widget build(BuildContext context) {
    final TextStyle italic = DsText.styleOf(
      context,
      DsType.small,
    ).copyWith(fontStyle: FontStyle.italic);
    return DsRichText(
      TextSpan(
        children: <InlineSpan>[
          const TextSpan(
            text:
                'The honest answer to “can the agent see this file?” '
                'varies by transport and by file type, and a paperclip that '
                'means ',
          ),
          TextSpan(text: 'we sent the filename', style: italic),
          const TextSpan(text: ' looks exactly like one that means '),
          TextSpan(text: 'we sent the file', style: italic),
          const TextSpan(text: '. So an attachment carries a '),
          DsCode.span('delivery'),
          const TextSpan(text: ' field — '),
          DsCode.span('content'),
          const TextSpan(text: ', '),
          DsCode.span('reference'),
          const TextSpan(text: ' with a reason, or '),
          DsCode.span('produced'),
          const TextSpan(
            text:
                ' — and the transcript renders it. A 40MB PDF that only '
                'travelled as a name says so.',
          ),
        ],
      ),
      DsType.small,
    );
  }
}

class _UrlNoteBody extends StatelessWidget {
  const _UrlNoteBody();

  @override
  Widget build(BuildContext context) {
    final TextStyle italic = DsText.styleOf(
      context,
      DsType.small,
    ).copyWith(fontStyle: FontStyle.italic);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DsRichText(
          TextSpan(
            children: <InlineSpan>[
              const TextSpan(text: 'Media opens '),
              TextSpan(text: 'in place', style: italic),
              const TextSpan(text: ', in a '),
              DsCode.span('Dialog'),
              const TextSpan(
                text:
                    ' over a dimmed page — §5’s table calls a dialog the '
                    'reversible one, and there is nothing here to decide. '
                    'Opening a new tab instead would hand the reader to the '
                    'browser’s own viewer and lose the conversation. The '
                    'close control is a ',
              ),
              DsCode.span('secondary'),
              const TextSpan(
                text:
                    ' Button rather than the stock ghost ✕: this panel has no '
                    'header band for the ✕ to sit on, and a ghost control '
                    'disappears into whatever pixel of the photograph it lands '
                    'on.',
              ),
            ],
          ),
          DsType.small,
        ),
        _mt(
          3,
          DsRichText(
            TextSpan(
              children: <InlineSpan>[
                const TextSpan(
                  text:
                      'Everything else — a PDF, a spreadsheet, a document — '
                      'gets a download control with both signals §5 demands. '
                      'The glyph rolls to a check through ',
                ),
                DsCode.span('IconSwap'),
                const TextSpan(
                  text:
                      ' so the control confirms it heard you, and a toast '
                      'reports the outcome. It says ',
                ),
                TextSpan(text: 'Saving', style: italic),
                const TextSpan(text: ', not '),
                TextSpan(text: 'Saved', style: italic),
                const TextSpan(text: ': a plain '),
                DsCode.span('download'),
                const TextSpan(
                  text:
                      ' anchor gives the page no completion event, so claiming '
                      'the bytes landed would be a capability this component '
                      'does not have — the same honesty the delivery badge above '
                      'exists for.',
                ),
              ],
            ),
            DsType.small,
          ),
        ),
      ],
    );
  }
}

class _BuiltOnNoteBody extends StatelessWidget {
  const _BuiltOnNoteBody();

  @override
  Widget build(BuildContext context) {
    final TextStyle italic = DsText.styleOf(
      context,
      DsType.small,
    ).copyWith(fontStyle: FontStyle.italic);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DsRichText(
          TextSpan(
            children: <InlineSpan>[
              DsCode.span('components/agent/parts/attachments.tsx'),
              const TextSpan(
                text:
                    ' is a thin wrapper over the vendored primitive documented '
                    'on ',
              ),
              DsCode.span('/design-system/components/base/chat#attachment'),
              const TextSpan(text: ' — '),
              DsCode.span('AttachmentCard'),
              const TextSpan(text: ' composes '),
              DsCode.span('Attachment'),
              const TextSpan(text: ', '),
              DsCode.span('AttachmentMedia'),
              const TextSpan(text: ' and '),
              DsCode.span('AttachmentContent'),
              const TextSpan(
                text:
                    ' directly rather than drawing its own row. The one '
                    'addition is the delivery badge above: ',
              ),
              TextSpan(text: 'Read', style: italic),
              const TextSpan(
                text: ' (content, hover for nothing more to say), ',
              ),
              TextSpan(text: 'Name only', style: italic),
              const TextSpan(
                text: ' (reference — hover it, the tooltip carries ',
              ),
              DsCode.span('delivery.reason'),
              const TextSpan(text: '), and nothing at all for '),
              DsCode.span('produced'),
              const TextSpan(
                text:
                    ', since delivery does not apply to a file the agent made '
                    'itself.',
              ),
            ],
          ),
          DsType.small,
        ),
        _mt(
          3,
          DsRichText(
            TextSpan(
              children: <InlineSpan>[
                const TextSpan(text: 'There is no '),
                DsCode.span('error'),
                const TextSpan(text: ' or '),
                DsCode.span('uploading'),
                const TextSpan(text: ' specimen on this page. '),
                DsCode.span('core/types.ts'),
                const TextSpan(text: '’s '),
                DsCode.span('Attachment'),
                const TextSpan(
                  text:
                      ' carries no upload lifecycle at all — every attachment '
                      'this console can construct has already arrived by the '
                      'time it renders, so the wrapper always passes ',
                ),
                DsCode.span('state="done"'),
                const TextSpan(
                  text:
                      '. Those two states are real on the primitive and shown '
                      'honestly on the ',
                ),
                DsCode.span('base/chat'),
                const TextSpan(
                  text:
                      ' page, against data this domain type cannot produce — '
                      'putting them here would be a lie this component tells '
                      'about itself.',
                ),
              ],
            ),
            DsType.small,
          ),
        ),
      ],
    );
  }
}

/* ── The stand-in photograph ─────────────────────────────────────────────── */

/*
 * allow-hardcoded: these are the pixels of a stand-in PHOTOGRAPH, not colours
 * this system is choosing. A file the user actually uploads carries whatever
 * colours their camera recorded: it does not follow the theme, and it must
 * not, or the specimen would prove the wrong thing: that media in the
 * transcript is token-coloured. The token rule governs the frame around it,
 * which is where the image well and the lightbox both draw from `--card` and
 * `--muted`. Carried across from the reference's own `agent-demo.tsx`, which
 * states exactly this reasoning above the same three values.
 */
const Color _photoBase = Color(
  0xFF1E293B,
); // allow-hardcoded: a stand-in photograph's own pixels
const Color _photoSubject = Color(0xFF1A6EF4); // allow-hardcoded: as above
const Color _photoCaption = Color(0xFFE2E8F0); // allow-hardcoded: as above

/// The reference's inline SVG, drawn.
///
/// ```svg
/// <svg viewBox="0 0 640 360">
///   <rect width="640" height="360" fill="#1e293b"/>
///   <circle cx="320" cy="180" r="96" fill="#1a6ef4"/>
///   <text x="320" y="330" fill="#e2e8f0" font-family="sans-serif"
///         font-size="22" text-anchor="middle">pull-of-the-week.png</text>
/// </svg>
/// ```
class _StandInPhotograph extends StatelessWidget {
  const _StandInPhotograph();

  /// The `viewBox`.
  static const Size viewBox = Size(640, 360);

  @override
  Widget build(BuildContext context) => SizedBox.fromSize(
    size: viewBox,
    child: CustomPaint(
      painter: _PhotoPainter(
        caption: DsText.styleOf(
          context,
          DsType.body,
          color: _photoCaption,
          // `font-size="22"` on the SVG's own text node.
          fontSize: 22, // allow-hardcoded: the stand-in photograph's own SVG
        ),
      ),
    ),
  );
}

class _PhotoPainter extends CustomPainter {
  const _PhotoPainter({required this.caption});

  /// `cx="320" cy="180" r="96"`.
  static const Offset subjectCentre = Offset(320, 180);
  static const double subjectRadius = 96;

  /// `x="320" y="330"`: an SVG text baseline.
  static const Offset captionAnchor = Offset(320, 330);

  final TextStyle caption;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = _photoBase,
    );
    canvas.drawCircle(
      subjectCentre,
      subjectRadius,
      Paint()..color = _photoSubject,
    );

    final TextPainter painter = TextPainter(
      text: TextSpan(text: 'pull-of-the-week.png', style: caption),
      textDirection: TextDirection.ltr,
    )..layout();
    // `text-anchor="middle"` centres on x; the SVG `y` is the baseline, so the
    // box is lifted by the painter's own ascent.
    painter.paint(
      canvas,
      Offset(
        captionAnchor.dx - painter.width / 2,
        captionAnchor.dy -
            painter.computeDistanceToActualBaseline(TextBaseline.alphabetic),
      ),
    );
    painter.dispose();
  }

  @override
  bool shouldRepaint(_PhotoPainter old) => old.caption != caption;
}
