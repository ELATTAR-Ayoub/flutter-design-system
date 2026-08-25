/// Public documentation page for the `agent-transcript` component.
///
/// **Written from nothing**, per the rollout's per-item brief:
/// `agent-transcript` has no page today. Everything on it is read off
/// `lib/src/components/agent_transcript.dart` directly.
///
/// **A family of parts, not one widget** — the same shape `field`
/// documents. `agent_transcript.dart` declares ten exported classes: the two
/// message shapes (`ElUserMessage`, `ElAgentMessage`), a disclosure chip for
/// a tool call and a plain one for a browser action (`ElToolChip`,
/// `ElActionChip`), the approval gate (`ElApprovalCard`), the
/// empty-conversation card (`ElWelcomeCard`), three small entrance
/// utilities (`ElTypingCursor`, `ElFadeUp`, `ElRowIn`), and the plain data
/// class the welcome card's grid renders (`ElAgentCapability`). API
/// Reference gives each of the ten its own `DocsApiTable`, with a rail
/// sub-anchor per table.
///
/// **Section order** follows the house shape: Preview, Installation, Usage,
/// then one `ShowcaseSection` per part (User message, Agent message, Tool
/// chip, Action chip, Approval card, Welcome card), then the eight
/// disclosures.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/component_doc_page.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../docs/docs_section.dart' show DocsAnchor;
import 'meta.dart';

final ComponentDocSpec agentTranscriptDocSpec = ComponentDocSpec(
  name: 'agent-transcript',
  title: agentTranscriptDoc.title,
  description: agentTranscriptDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'A short real slice of a conversation: a user bubble, a settled '
          'tool chip, and flush agent prose with a live typing cursor — '
          'three of the transcript\'s own row kinds stacked the way '
          'ElAgentConsole itself stacks turns.',
      specimen: _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
      minHeight: el(96),
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'agent-transcript has a real registry manifest: elattar add '
          'agent-transcript installs '
          'lib/src/components/agent_transcript.dart and resolves '
          'agent-attachments, agent-core, agent-markdown, button, icon, '
          'keyframes and source-foundation automatically. The Manual tab '
          'is for a project not using the CLI.',
      command: agentTranscriptDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/agent_transcript.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/agent_transcript.dart's generated "
              '@ui/agent_transcript.dart payload into components/ui.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated agent_transcript source here when '
              'using manual mode.',
        ),
        const DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so every type this file declares is '
              'reachable the same way the CLI path already makes them.',
          code: "export 'agent_transcript.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'The smallest correct construction: a settled text turn, drawn '
          'flush in the column like body copy.',
      code: _usageCode,
    ),
    ShowcaseSection(
      id: 'user-message',
      title: 'User message',
      description:
          'ElUserMessage: right-aligned, capped at 85% of the available '
          'width, agentMuted fill with a hairline agent/20 rim. '
          'Attachments render below the bubble in their own '
          'ElAgentAttachmentList, capped to the same width.',
      specimen: _UserMessageSpecimen(),
      code: _userMessageCode,
      label: 'User message specimen view',
    ),
    ShowcaseSection(
      id: 'agent-message',
      title: 'Agent message',
      description:
          'ElAgentMessage: no bubble, set flush in the column like body '
          'copy — the reference\'s own reasoning is that long prose in a '
          'speech bubble is harder to read for no gain. A ElTypingCursor '
          'follows the text only while turn.streaming is true.',
      specimen: _AgentMessageSpecimen(),
      code: _agentMessageCode,
      label: 'Agent message specimen view',
    ),
    ShowcaseSection(
      id: 'tool-chip',
      title: 'Tool chip',
      description:
          'ElToolChip: closed by default, one sentence. Tap it to open '
          'the real disclosure — arguments and result — the difference '
          'between a product that claims it did something and one that '
          'can be checked.',
      specimen: _ToolChipSpecimen(),
      code: _toolChipCode,
      label: 'Tool chip specimen view',
    ),
    ShowcaseSection(
      id: 'action-chip',
      title: 'Action chip',
      description:
          'ElActionChip: a step the browser performed rather than the '
          'server, kept visually distinct from a tool chip because the '
          'user can verify these themselves. Three real ElActionTurn '
          'outcomes: settled, failed, and declined.',
      specimen: _ActionChipSpecimen(),
      code: _actionChipCode,
      label: 'Action chip specimen view',
    ),
    ShowcaseSection(
      id: 'approval-card',
      title: 'Approval card',
      description:
          'ElApprovalCard: a real gate, not a rendering of one — pressing '
          'Approve or Decline below genuinely calls the ElPendingApproval\'s '
          'own callback and the card is replaced by the outcome, the same '
          'way a live console resolves the promise the agent is blocked '
          'on.',
      specimen: _ApprovalCardSpecimen(),
      code: _approvalCardCode,
      label: 'Approval card specimen view',
      minHeight: el(64),
    ),
    ShowcaseSection(
      id: 'welcome-card',
      title: 'Welcome card',
      description:
          'ElWelcomeCard: what the assistant is, before it has said '
          'anything — skills as chips (arm the composer), suggestions as '
          'lines (send immediately). avatar is left unfilled here on '
          'purpose: the live cube renderer belongs to a different family '
          'file, not to this one\'s own registryDependencies, so the '
          '80px box is shown empty rather than papered over with an '
          'invented avatar.',
      specimen: _WelcomeCardSpecimen(),
      code: _welcomeCardCode,
      label: 'Welcome card specimen view',
      minHeight: el(96),
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every named constructor parameter and every static member each '
          'of the ten exported classes declares: one table each.',
      children: const <DocsTocEntry>[
        DocsTocEntry(title: 'ElUserMessage', anchor: 'api-eluser-message'),
        DocsTocEntry(title: 'ElAgentMessage', anchor: 'api-elagent-message'),
        DocsTocEntry(title: 'ElTypingCursor', anchor: 'api-eltyping-cursor'),
        DocsTocEntry(title: 'ElToolChip', anchor: 'api-eltool-chip'),
        DocsTocEntry(title: 'ElActionChip', anchor: 'api-elaction-chip'),
        DocsTocEntry(title: 'ElApprovalCard', anchor: 'api-elapproval-card'),
        DocsTocEntry(title: 'ElFadeUp', anchor: 'api-elfade-up'),
        DocsTocEntry(title: 'ElRowIn', anchor: 'api-elrow-in'),
        DocsTocEntry(
          title: 'ElAgentCapability',
          anchor: 'api-elagent-capability',
        ),
        DocsTocEntry(title: 'ElWelcomeCard', anchor: 'api-elwelcome-card'),
      ],
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'Read off each part\'s own build method, not inferred: this '
          'family has no single "state matrix", since a bubble, a chip '
          'and a card each vary along their own axis.',
      child: DocsStateMatrix(facts: _stateFacts),
    ),
    DisclosureSection(
      id: 'accessibility',
      title: 'Accessibility',
      child: _AccessibilityContent(),
    ),
    DisclosureSection(
      id: 'keyboard',
      title: 'Keyboard',
      child: _KeyboardContent(),
    ),
    DisclosureSection(
      id: 'responsive',
      title: 'Responsive',
      child: _ResponsiveContent(),
    ),
    DisclosureSection(
      id: 'dependencies',
      title: 'Dependencies',
      child: _DependenciesContent(),
    ),
    DisclosureSection(
      id: 'theming',
      title: 'Theming',
      child: _ThemingContent(),
    ),
    DisclosureSection(
      id: 'source',
      title: 'Source',
      child: DocsInstallFacts(
        title: 'Reference',
        facts: <DocsInstallFact>[
          DocsInstallFact(
            label: 'Source',
            value: agentTranscriptDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'test/agent_transcript_test.dart',
            description:
                'Every row kind, the disclosure toggle, the approval '
                'gate\'s real callbacks, and the entrance utilities, '
                'exercised against the real widgets.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/agent_transcript_test.dart',
            description:
                "This page's own API-completeness, live-specimen, and "
                'theme coverage.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/agent_transcript/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class AgentTranscriptDocPage extends StatelessWidget {
  const AgentTranscriptDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: agentTranscriptDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / AGENT',
      title: agentTranscriptDoc.title,
      description: agentTranscriptDoc.description,
    ),
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Components'),
      ElBreadcrumbEntry.page('Agent Transcript'),
    ],
    toc: agentTranscriptDocSpec.toc,
    previous: const DocsPageLink(
      title: 'Agent Console',
      route: '/components/agent-console',
    ),
    next: null,
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('agent-transcript-doc-article'),
      child: ComponentDocPage(spec: agentTranscriptDocSpec, header: false),
    ),
  );
}

/* ── Showcase specimens ─────────────────────────────────────────────────── */

class _PreviewSpecimen extends StatelessWidget {
  const _PreviewSpecimen();

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: ElContainers.sm),
    child: Column(
      key: const ValueKey<String>('agent-transcript-preview'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const ElUserMessage(
          turn: ElUserTurn(
            id: 'u1',
            text: 'Can you check the latest sales numbers?',
          ),
        ),
        SizedBox(height: el(4)),
        ElToolChip(
          turn: const ElToolTurn(
            id: 't1',
            name: 'fetch_sales',
            params: <String, Object?>{'window': '7d'},
            status: ElAgentTurnStatus.ok,
            attempt: 1,
            ms: 640,
            result: <String, Object?>{'total': 18240, 'currency': 'USD'},
          ),
        ),
        SizedBox(height: el(4)),
        const ElAgentMessage(
          turn: ElTextTurn(
            id: 'a1',
            text: 'The last seven days totalled **\$18,240**.',
          ),
        ),
      ],
    ),
  );
}

const String _previewCode = '''Column(
  children: [
    ElUserMessage(
      turn: ElUserTurn(id: 'u1', text: 'Can you check the latest sales numbers?'),
    ),
    ElToolChip(
      turn: ElToolTurn(
        id: 't1', name: 'fetch_sales', params: {'window': '7d'},
        status: ElAgentTurnStatus.ok, attempt: 1, ms: 640,
        result: {'total': 18240, 'currency': 'USD'},
      ),
    ),
    ElAgentMessage(
      turn: ElTextTurn(id: 'a1', text: 'The last seven days totalled **\\\$18,240**.'),
    ),
  ],
)''';

const String _usageCode =
    '''import 'package:elattar_design_system/elattar_design_system.dart';

const ElAgentMessage(
  turn: ElTextTurn(id: 'a1', text: 'Done.'),
)''';

class _UserMessageSpecimen extends StatelessWidget {
  const _UserMessageSpecimen();

  @override
  Widget build(BuildContext context) => const ElUserMessage(
    turn: ElUserTurn(
      id: 'u2',
      text: 'Here is the export you asked for.',
      attachments: <ElAgentAttachment>[
        ElAgentAttachment(
          id: 'f1',
          name: 'export.csv',
          mime: 'text/csv',
          kind: ElAgentAttachmentKind.data,
          size: 8192,
        ),
      ],
    ),
  );
}

const String _userMessageCode = '''ElUserMessage(
  turn: ElUserTurn(
    id: 'u2',
    text: 'Here is the export you asked for.',
    attachments: [
      ElAgentAttachment(
        id: 'f1', name: 'export.csv', mime: 'text/csv',
        kind: ElAgentAttachmentKind.data, size: 8192,
      ),
    ],
  ),
)''';

class _AgentMessageSpecimen extends StatelessWidget {
  const _AgentMessageSpecimen();

  @override
  Widget build(BuildContext context) => const Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      ElAgentMessage(
        turn: ElTextTurn(
          id: 'a2',
          text: 'Three sealed boxes match. The strongest is **Eclipse '
              'Vault — 1st Edition**.',
        ),
      ),
      SizedBox(height: 16),
      ElAgentMessage(
        key: ValueKey<String>('agent-transcript-message-streaming'),
        turn: ElTextTurn(
          id: 'a3',
          text: 'Checking the balance first',
          streaming: true,
        ),
      ),
    ],
  );
}

const String _agentMessageCode = '''ElAgentMessage(
  turn: ElTextTurn(
    id: 'a2',
    text: 'Three sealed boxes match. The strongest is **Eclipse Vault — 1st Edition**.',
  ),
)

// While the model is still writing, the cursor follows:
ElAgentMessage(
  turn: ElTextTurn(id: 'a3', text: 'Checking the balance first', streaming: true),
)''';

class _ToolChipSpecimen extends StatefulWidget {
  const _ToolChipSpecimen();

  @override
  State<_ToolChipSpecimen> createState() => _ToolChipSpecimenState();
}

class _ToolChipSpecimenState extends State<_ToolChipSpecimen> {
  @override
  Widget build(BuildContext context) => ElToolChip(
    key: const ValueKey<String>('agent-transcript-tool-chip'),
    turn: const ElToolTurn(
      id: 't2',
      name: 'search_inventory',
      params: <String, Object?>{'query': 'sealed booster boxes', 'limit': 3},
      status: ElAgentTurnStatus.ok,
      attempt: 1,
      ms: 900,
      result: <String, Object?>{
        'matches': 3,
        'topResult': 'Eclipse Vault — 1st Edition',
      },
    ),
  );
}

const String _toolChipCode = '''ElToolChip(
  turn: ElToolTurn(
    id: 't2', name: 'search_inventory',
    params: {'query': 'sealed booster boxes', 'limit': 3},
    status: ElAgentTurnStatus.ok, attempt: 1, ms: 900,
    result: {'matches': 3, 'topResult': 'Eclipse Vault — 1st Edition'},
  ),
)
// Tap the chip to open the arguments/result disclosure.''';

class _ActionChipSpecimen extends StatelessWidget {
  const _ActionChipSpecimen();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      const ElActionChip(
        key: ValueKey<String>('agent-transcript-action-ok'),
        turn: ElActionTurn(
          id: 'ac1',
          action: 'navigate',
          params: <String, Object?>{'url': '/orders/482'},
          status: ElAgentTurnStatus.ok,
          ms: 240,
        ),
      ),
      SizedBox(height: el(2)),
      const ElActionChip(
        key: ValueKey<String>('agent-transcript-action-error'),
        turn: ElActionTurn(
          id: 'ac2',
          action: 'click',
          params: <String, Object?>{'selector': '#confirm'},
          status: ElAgentTurnStatus.error,
          error: 'Element not found.',
        ),
      ),
      SizedBox(height: el(2)),
      const ElActionChip(
        key: ValueKey<String>('agent-transcript-action-declined'),
        turn: ElActionTurn(
          id: 'ac3',
          action: 'purchase_pack',
          params: <String, Object?>{'pack': 'Eclipse Vault', 'price': 129},
          status: ElAgentTurnStatus.error,
          approval: ElApprovalOutcome.rejected,
        ),
      ),
    ],
  );
}

const String _actionChipCode = '''ElActionChip(
  turn: ElActionTurn(
    id: 'ac1', action: 'navigate', params: {'url': '/orders/482'},
    status: ElAgentTurnStatus.ok, ms: 240,
  ),
)

// A step the user declined:
ElActionChip(
  turn: ElActionTurn(
    id: 'ac3', action: 'purchase_pack', params: {'pack': 'Eclipse Vault'},
    status: ElAgentTurnStatus.error, approval: ElApprovalOutcome.rejected,
  ),
)''';

class _ApprovalCardSpecimen extends StatefulWidget {
  const _ApprovalCardSpecimen();

  @override
  State<_ApprovalCardSpecimen> createState() => _ApprovalCardSpecimenState();
}

class _ApprovalCardSpecimenState extends State<_ApprovalCardSpecimen> {
  String? _outcome;

  @override
  Widget build(BuildContext context) {
    if (_outcome != null) {
      return ElText(
        _outcome!,
        ElType.small,
        color: ElTheme.of(context).mutedForeground,
        key: const ValueKey<String>('agent-transcript-approval-outcome'),
      );
    }
    return ElApprovalCard(
      key: const ValueKey<String>('agent-transcript-approval-card'),
      approval: ElPendingApproval(
        turnId: 'ac4',
        action: 'purchase_pack',
        params: const <String, Object?>{
          'pack': 'Eclipse Vault — 1st Edition',
          'price': 129,
          'currency': 'USD',
        },
        approve: () => setState(() => _outcome = 'Approved.'),
        reject: ([String? reason]) =>
            setState(() => _outcome = reason ?? 'Declined.'),
      ),
    );
  }
}

const String _approvalCardCode = '''ElApprovalCard(
  approval: ElPendingApproval(
    turnId: 'ac4',
    action: 'purchase_pack',
    params: {'pack': 'Eclipse Vault — 1st Edition', 'price': 129, 'currency': 'USD'},
    approve: () => resolve(true),
    reject: ([reason]) => resolve(false, reason),
  ),
)''';

class _WelcomeCardSpecimen extends StatelessWidget {
  const _WelcomeCardSpecimen();

  @override
  Widget build(BuildContext context) => ElWelcomeCard(
    key: const ValueKey<String>('agent-transcript-welcome-card'),
    name: 'Vault Assistant',
    blurb: 'Ask about inventory, pricing, or your account.',
    capabilities: const <ElAgentCapability>[
      ElAgentCapability(
        id: 'search',
        label: 'Search inventory',
        hint: 'Find a card or a sealed box',
        glyph: ElLucide.search,
      ),
      ElAgentCapability(
        id: 'report',
        label: 'Export activity',
        hint: 'Download the last 30 days as CSV',
        glyph: ElLucide.scrollText,
      ),
    ],
    suggestions: const <String>[
      'What is Eclipse Vault worth right now?',
      'Show me everything under \$50.',
    ],
    onPick: (String text) {},
    onUseCapability: (ElAgentCapability capability) {},
  );
}

const String _welcomeCardCode = '''ElWelcomeCard(
  name: 'Vault Assistant',
  blurb: 'Ask about inventory, pricing, or your account.',
  capabilities: const [
    ElAgentCapability(id: 'search', label: 'Search inventory', glyph: ElLucide.search),
    ElAgentCapability(id: 'report', label: 'Export activity', glyph: ElLucide.scrollText),
  ],
  suggestions: const ['What is Eclipse Vault worth right now?'],
  onPick: (text) => send(text),         // sends immediately
  onUseCapability: (c) => armComposer(c), // writes into the composer instead
)''';

/* ── Disclosure content ─────────────────────────────────────────────────── */

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsAnchor(
        id: 'api-eluser-message',
        child: DocsApiTable(title: 'ElUserMessage', facts: _userMessageFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elagent-message',
        child: DocsApiTable(
          title: 'ElAgentMessage',
          facts: _agentMessageFacts,
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-eltyping-cursor',
        child: DocsApiTable(
          title: 'ElTypingCursor',
          facts: _typingCursorFacts,
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-eltool-chip',
        child: DocsApiTable(title: 'ElToolChip', facts: _toolChipFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elaction-chip',
        child: DocsApiTable(title: 'ElActionChip', facts: _actionChipFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elapproval-card',
        child: DocsApiTable(
          title: 'ElApprovalCard',
          facts: _approvalCardFacts,
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elfade-up',
        child: DocsApiTable(title: 'ElFadeUp', facts: _fadeUpFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elrow-in',
        child: DocsApiTable(title: 'ElRowIn', facts: _rowInFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elagent-capability',
        child: DocsApiTable(
          title: 'ElAgentCapability',
          facts: _capabilityFacts,
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elwelcome-card',
        child: DocsApiTable(title: 'ElWelcomeCard', facts: _welcomeCardFacts),
      ),
    ],
  );
}

const List<DocsApiFact> _userMessageFacts = <DocsApiFact>[
  DocsApiFact(name: 'turn', type: 'ElUserTurn', description: 'Required.'),
  DocsApiFact(
    name: 'imageBuilder',
    type: 'Widget Function(BuildContext, ElAgentAttachment)?',
    description: 'Optional. Passed through to the attachment list.',
  ),
  DocsApiFact(
    name: 'onDownload',
    type: 'void Function(String name)?',
    description: 'Optional. Passed through to the attachment list.',
  ),
  DocsApiFact(
    name: 'ElUserMessage.maxWidthFraction',
    type: 'static const double',
    description: '0.85 — the bubble\'s cap against the available width.',
  ),
  DocsApiFact(
    name: 'ElUserMessage.gap',
    type: 'static double (get)',
    description: '8px between the bubble and the attachment tray below it.',
  ),
  DocsApiFact(
    name: 'ElUserMessage.padX / padY',
    type: 'static double (get)',
    description: '16px / 12px, the bubble\'s own padding.',
  ),
  DocsApiFact(
    name: 'ElUserMessage.rimAlpha',
    type: 'static const double',
    description: '0.20 — theme.agent at 20% for the bubble\'s hairline rim.',
  ),
  DocsApiFact(
    name: 'ElUserMessage.radius',
    type: 'static BorderRadius (get)',
    description: '16 / 16 / 6 / 16 — rounded-xl with a squared bottom-right '
        'corner.',
  ),
];

const List<DocsApiFact> _agentMessageFacts = <DocsApiFact>[
  DocsApiFact(name: 'turn', type: 'ElTextTurn', description: 'Required.'),
  DocsApiFact(
    name: 'imageBuilder',
    type: 'Widget Function(BuildContext, ElAgentAttachment)?',
    description: 'Optional.',
  ),
  DocsApiFact(
    name: 'onDownload',
    type: 'void Function(String name)?',
    description: 'Optional.',
  ),
  DocsApiFact(
    name: 'ElAgentMessage.gap',
    type: 'static double (get)',
    description: '12px between the prose and the attachment tray below it.',
  ),
];

const List<DocsApiFact> _typingCursorFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'ElTypingCursor.markHeight',
    type: 'static double (get)',
    description: '16px — the caret\'s own height.',
  ),
  DocsApiFact(
    name: 'ElTypingCursor.markWidth',
    type: 'static const double',
    description: 'ElWidths.hairline — one device pixel wide.',
  ),
  DocsApiFact(
    name: 'ElTypingCursor.inset',
    type: 'static double (get)',
    description: '4px — the gap after the preceding text.',
  ),
];

const List<DocsApiFact> _toolChipFacts = <DocsApiFact>[
  DocsApiFact(name: 'turn', type: 'ElToolTurn', description: 'Required.'),
  DocsApiFact(
    name: 'toolStates',
    type: 'ElToolStateMap?',
    description:
        'Optional. Same map the console reads, so the chip and the face '
        'never describe the same call differently.',
  ),
  DocsApiFact(
    name: 'renderResult',
    type: 'Widget Function(ElToolTurn)?',
    description:
        'Optional. Turns a settled result into the product\'s own '
        'components, shown outside the disclosure — the answer, not the '
        'evidence.',
  ),
  DocsApiFact(
    name: 'imageBuilder',
    type: 'Widget Function(BuildContext, ElAgentAttachment)?',
    description: 'Optional.',
  ),
  DocsApiFact(
    name: 'onDownload',
    type: 'void Function(String name)?',
    description: 'Optional.',
  ),
  DocsApiFact(
    name: 'ElToolChip.gap',
    type: 'static double (get)',
    description: '8px between the chip and whatever it opens.',
  ),
  DocsApiFact(
    name: 'ElToolChip.padX / padY',
    type: 'static double (get)',
    description: '12px / 4px — the chip\'s own override of the sm button '
        'rung.',
  ),
  DocsApiFact(
    name: 'ElToolChip.contentGap',
    type: 'static double (get)',
    description:
        '8px between the glyph, the label, the elapsed time and the '
        'chevron.',
  ),
  DocsApiFact(
    name: 'ElToolChip.chevronPx',
    type: 'static double (get)',
    description: '12px.',
  ),
  DocsApiFact(
    name: 'ElToolChip.chevronAlpha',
    type: 'static const double',
    description: '0.60 — mutedForeground at 60%.',
  ),
  DocsApiFact(
    name: 'ElToolChip.errorRimAlpha',
    type: 'static const double',
    description: '0.40 — destructive at 40% on a failed chip.',
  ),
  DocsApiFact(
    name: 'ElToolChip.panelPad / panelGap',
    type: 'static double (get)',
    description: '12px each, inside the disclosure panel.',
  ),
  DocsApiFact(
    name: 'ElToolChip.panelFillAlpha',
    type: 'static const double',
    description: '0.40 — theme.muted at 40%.',
  ),
  DocsApiFact(
    name: 'ElToolChip.detailGap',
    type: 'static double (get)',
    description: '4px inside one labelled detail.',
  ),
  DocsApiFact(
    name: 'ElToolChip.valueMaxHeight',
    type: 'static double (get)',
    description: '256px cap on a raw argument or result value.',
  ),
];

const List<DocsApiFact> _actionChipFacts = <DocsApiFact>[
  DocsApiFact(name: 'turn', type: 'ElActionTurn', description: 'Required.'),
  DocsApiFact(
    name: 'ElActionChip.padX / padY / gap',
    type: 'static double (get)',
    description: '12px / 4px / 8px.',
  ),
  DocsApiFact(
    name: 'ElActionChip.rimAlpha',
    type: 'static const double',
    description:
        '0.40 — destructive/40 on a failed action, warning/40 on one the '
        'user declined.',
  ),
];

const List<DocsApiFact> _approvalCardFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'approval',
    type: 'ElPendingApproval',
    description: 'Required.',
  ),
  DocsApiFact(
    name: 'describe',
    type: 'String Function(String action, Map<String, Object?> params)?',
    description:
        'Optional. Turns the raw action into a sentence a human can '
        'decide on; falls back to ElApprovalCard.defaultSentence.',
  ),
  DocsApiFact(
    name: 'ElApprovalCard.pad / gap',
    type: 'static double (get)',
    description: '16px / 12px.',
  ),
  DocsApiFact(
    name: 'ElApprovalCard.headGap / headLineGap',
    type: 'static double (get)',
    description: '12px / 4px.',
  ),
  DocsApiFact(
    name: 'ElApprovalCard.glyphPx / glyphTop',
    type: 'static double (get)',
    description: '16px / 4px.',
  ),
  DocsApiFact(
    name: 'ElApprovalCard.rimAlpha / washAlpha',
    type: 'static const double',
    description: '0.40 / 0.08 — ElPalette.warning at each alpha.',
  ),
  DocsApiFact(
    name: 'ElApprovalCard.paramsMaxHeight / paramsPad',
    type: 'static double (get)',
    description: '160px / 8px, on the parameter block.',
  ),
  DocsApiFact(
    name: 'ElApprovalCard.actionGap',
    type: 'static double (get)',
    description: '8px between Approve and Decline.',
  ),
  DocsApiFact(
    name: 'ElApprovalCard.declineReason',
    type: 'static const String',
    description: '"The user declined this action." — handed to reject() '
        'verbatim.',
  ),
  DocsApiFact(
    name: 'ElApprovalCard.defaultSentence(approval)',
    type: 'static String Function',
    description:
        '"The assistant wants to run \\"{action}\\"{ on target}." when no '
        'describe is supplied.',
  ),
];

const List<DocsApiFact> _fadeUpFacts = <DocsApiFact>[
  DocsApiFact(name: 'child', type: 'Widget', description: 'Required.'),
  DocsApiFact(
    name: 'ElFadeUp.rise',
    type: 'static double (get)',
    description:
        '10px — the translateY the child rises from as it fades in, over '
        'ElDurations.slow on ElCurves.out.',
  ),
];

const List<DocsApiFact> _rowInFacts = <DocsApiFact>[
  DocsApiFact(name: 'index', type: 'int', description: 'Required.'),
  DocsApiFact(name: 'child', type: 'Widget', description: 'Required.'),
  DocsApiFact(
    name: 'ElRowIn.slide',
    type: 'static double (get)',
    description: '10px — the translateX the child slides in from.',
  ),
  DocsApiFact(
    name: 'ElRowIn.delayFor(index)',
    type: 'static Duration Function',
    description:
        'ElDurations.tick × (1 + index / 2) — 80ms, then 40ms more per '
        'row.',
  ),
];

const List<DocsApiFact> _capabilityFacts = <DocsApiFact>[
  DocsApiFact(name: 'id', type: 'String', description: 'Required.'),
  DocsApiFact(name: 'label', type: 'String', description: 'Required.'),
  DocsApiFact(
    name: 'hint',
    type: 'String?',
    description: 'Optional. The chip\'s own title/tooltip text.',
  ),
  DocsApiFact(
    name: 'glyph',
    type: 'ElLucideGlyph?',
    description: 'Optional. Defaults to ElLucide.sparkles when omitted.',
  ),
];

const List<DocsApiFact> _welcomeCardFacts = <DocsApiFact>[
  DocsApiFact(name: 'name', type: 'String?', description: 'Optional.'),
  DocsApiFact(name: 'blurb', type: 'String?', description: 'Optional.'),
  DocsApiFact(
    name: 'capabilities',
    type: 'List<ElAgentCapability>',
    description:
        'Defaults to []. Skills, as chips; clicking one arms the composer '
        'rather than sending.',
  ),
  DocsApiFact(
    name: 'suggestions',
    type: 'List<String>',
    description:
        'Defaults to []. Starter prompts, as lines; clicking one sends '
        'immediately.',
  ),
  DocsApiFact(
    name: 'onPick',
    type: 'void Function(String text)',
    description: 'Required.',
  ),
  DocsApiFact(
    name: 'onUseCapability',
    type: 'void Function(ElAgentCapability)?',
    description: 'Optional.',
  ),
  DocsApiFact(
    name: 'disabled',
    type: 'bool',
    description: 'Defaults to false.',
  ),
  DocsApiFact(
    name: 'avatar',
    type: 'Widget Function(BuildContext, double size)?',
    description:
        'Optional. The live face at the size the card asks for; reserves '
        'the 80px box either way.',
  ),
  DocsApiFact(
    name: 'ElWelcomeCard.maxCapabilities',
    type: 'static const int',
    description: '4 — capabilities beyond the fourth are not shown.',
  ),
  DocsApiFact(
    name: 'ElWelcomeCard.outerPadY',
    type: 'static double (get)',
    description: '16px.',
  ),
  DocsApiFact(
    name: 'ElWelcomeCard.columnWidth',
    type: 'static double (get)',
    description: 'ElContainers.md — the card\'s own max width.',
  ),
  DocsApiFact(
    name: 'ElWelcomeCard.avatarPx',
    type: 'static double (get)',
    description: '80px.',
  ),
  DocsApiFact(
    name: 'ElWelcomeCard.nameTop / blurbTop / listTop',
    type: 'static double (get)',
    description: '12px / 4px / 16px.',
  ),
  DocsApiFact(
    name: 'ElWelcomeCard.gridGap',
    type: 'static double (get)',
    description: '8px between capability chips.',
  ),
  DocsApiFact(
    name: 'ElWelcomeCard.suggestionGap',
    type: 'static double (get)',
    description: 'ElWidths.hairline — one device pixel between suggestion '
        'rows.',
  ),
  DocsApiFact(
    name: 'ElWelcomeCard.capabilityGlyphPx',
    type: 'static double (get)',
    description: '14px.',
  ),
  DocsApiFact(
    name: 'ElWelcomeCard.capabilityHoverRimAlpha',
    type: 'static const double',
    description: '0.50 — theme.agent at 50% on hover.',
  ),
  DocsApiFact(
    name: 'ElWelcomeCard.capabilityLabel',
    type: 'static ElTypeSpec (get)',
    description: 'small\'s size with caption\'s leading, weight 500.',
  ),
  DocsApiFact(
    name: 'ElWelcomeCard.suggestionLabel',
    type: 'static ElTypeSpec (get)',
    description: 'small\'s own size and leading, weight 500.',
  ),
];

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Tool chip: running',
    treatment:
        'A spinning loaderCircle (or rotateCw on attempt > 1), theme.agent '
        '(or warningInk on a retry), anim-spin at ElDurations.spin, '
        'linear — "a spinner that eases is a spinner that looks broken."',
    userSignal: 'A spinning glyph in front of the tool\'s name.',
  ),
  DocsStateFact(
    state: 'Tool chip: ok / error',
    treatment:
        'A static check (success) or triangleAlert (error) glyph; a '
        'failed chip also gains a destructive/40 border.',
    userSignal: 'A checkmark or a warning triangle in place of the '
        'spinner.',
  ),
  DocsStateFact(
    state: 'Tool chip: open / closed',
    treatment:
        'Local bool _open toggled on press; the chevron rotates a quarter '
        'turn over ElDurations.transitionDefault, and the disclosure '
        'panel mounts or unmounts entirely rather than collapsing to '
        'zero height.',
    userSignal: 'Arguments and result appear or disappear on tap.',
  ),
  DocsStateFact(
    state: 'Agent message: streaming',
    treatment: 'turn.streaming true appends a ElTypingCursor, pulsing on '
        'anim-pulse-live.',
    userSignal: 'A blinking mark follows the last character.',
  ),
  DocsStateFact(
    state: 'Approval card: resolved',
    treatment:
        'Not a state of the card itself — the card is a rendering of a '
        'pending request, and once approve or reject fires the caller is '
        'expected to stop rendering it. This page\'s own specimen swaps '
        'it for a plain sentence, exactly that contract.',
    userSignal: 'The card disappears once a decision is made.',
  ),
  DocsStateFact(
    state: 'Welcome card: entrance',
    treatment:
        'ElSpringUpEntrance on the column, ElPopInEntrance on the avatar '
        'slot (running independently of each other), ElRowIn staggered '
        'per capability chip at 80ms + 40ms×index.',
    userSignal:
        'The whole card springs up and the avatar pops in on arrival; '
        'each capability chip slides in a beat after the last.',
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment:
        'Every AnimationController in this file routes its duration '
        'through elAnimationDuration, which is Duration.zero under '
        'MediaQuery.disableAnimations.',
    userSignal:
        'Every entrance and the typing cursor\'s pulse land on their end '
        'frame immediately.',
  ),
];

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'ElToolChip is a Button underneath (aria-expanded\'s Flutter '
            'analogue): pressing it toggles Semantics.expanded through '
            'ElButton\'s own contract, documented on the Button page.',
        'ElActionChip carries no Semantics of its own beyond what its '
            'child ElText nodes contribute — it is not interactive, '
            'unlike a tool chip.',
        'ElApprovalCard wraps itself in Semantics(container: true, '
            'label: "The assistant is asking permission"), so a screen '
            'reader announces the gate as a unit before reading into it.',
        'ElWelcomeCard\'s suggestion rows and capability chips are both '
            'real ElButtons, so both carry a real accessible name and '
            'both are properly disabled together via the one disabled '
            'flag.',
        'ElUserMessage and ElAgentMessage carry no Semantics of their '
            'own: the markdown text underneath (ElAgentMarkdown) and the '
            'attachment list are where any live-region or role behaviour '
            'in this family actually lives, and both are documented on '
            'their own pages.',
      ]);
}

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'ElToolChip\'s disclosure trigger is a real ElButton, so it '
            'inherits that widget\'s own Enter/Space activation and '
            'focus-visible ring — see the Button page for the exact '
            'ladder.',
        'ElApprovalCard\'s Approve and Decline are both real ElButtons '
            'too, keyboard-operable the same way.',
        'ElUserMessage, ElAgentMessage, and ElActionChip take no focus '
            'and handle no key of their own: they are read-only rows.',
        'No custom FocusTraversalPolicy anywhere in this file: Tab and '
            'Shift+Tab walk whatever order the surrounding transcript '
            'already declares.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'ElUserMessage is the one width-aware part: a LayoutBuilder caps '
            'the bubble at maxWidthFraction (85%) of whatever it is '
            'given, so the same tree reads correctly whether the console '
            'is 360px or 1440px wide.',
        'Every other part in this file (ElAgentMessage, the chips, the '
            'cards) fills whatever width its parent hands it and reads '
            'no MediaQuery for layout.',
        'ElWelcomeCard caps itself at columnWidth (ElContainers.md) and '
            'centres inside whatever it is given, rather than growing '
            'with the viewport.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      DocsInstallFacts(
        facts: <DocsInstallFact>[
          const DocsInstallFact(
            label: 'File',
            value: 'lib/src/components/agent_transcript.dart',
            description:
                'One file, no companions; the registry manifest lists '
                'exactly one entry under "files".',
          ),
          const DocsInstallFact(
            label: 'Component imports',
            value: 'agent_attachments.dart, agent_core.dart, '
                'agent_markdown.dart, button.dart, icon.dart, '
                'icon_paths.g.dart',
            description:
                'agent_markdown.dart renders every message\'s text — '
                'both the bubble and the flush prose go through the same '
                'renderer, so a pasted code block round-trips faithfully '
                'either direction.',
          ),
          const DocsInstallFact(
            label: 'Foundation imports',
            value: 'foundation/colors.dart, foundation/motion.dart, '
                'foundation/spacing.dart, foundation/theme.dart, '
                'foundation/typography.dart, motion/keyframes.dart, '
                'text_layout.dart, theme_scope.dart',
            description:
                'motion/keyframes.dart supplies ElPulseLive (the typing '
                'cursor\'s pulse) and ElSpringUp/ElPopIn (the welcome '
                'card\'s entrance) — the registry\'s own keyframes '
                'dependency.',
          ),
          DocsInstallFact(
            label: 'registryDependencies',
            value: agentTranscriptDoc.dependencies.join(', '),
            description:
                "The manifest's own list, resolved automatically by "
                'elattar add agent-transcript.',
          ),
        ],
      ),
      SizedBox(height: el(4)),
      const DocsLinkRow(
        links: <DocsLink>[
          DocsLink(label: 'Agent Core', route: '/components/agent-core'),
          DocsLink(label: 'Agent Console', route: '/components/agent-console'),
          DocsLink(label: 'Button', route: '/components/button'),
          DocsLink(label: 'Icon', route: '/components/icon'),
        ],
      ),
    ],
  );
}

class _ThemingContent extends StatelessWidget {
  const _ThemingContent();

  @override
  Widget build(BuildContext context) => DocsInstallFacts(
    title: 'What actually varies with the theme',
    facts: const <DocsInstallFact>[
      DocsInstallFact(
        label: 'theme.agent / theme.agentMuted',
        value: 'the user bubble',
        description:
            'agentMuted fills the bubble; agent at 20% rims it and at '
            '100% paints the typing cursor — "the one place --agent is a '
            'solid fill rather than a foreground."',
      ),
      DocsInstallFact(
        label: 'theme.foreground',
        value: 'agent prose',
        description: 'Merged over the whole flush-text subtree via '
            'DefaultTextStyle.',
      ),
      DocsInstallFact(
        label: 'theme.destructive / theme.destructiveInk',
        value: 'a failed tool or action chip',
        description: 'The rim and, on the tool chip, the error message '
            'text.',
      ),
      DocsInstallFact(
        label: 'ElPalette.warning',
        value: 'the approval card',
        description:
            'A fixed token, not a theme.* getter — the same reasoning '
            'ElButtonVariant.premium uses on the Button page: a warning '
            'reads as the same colour in both themes.',
      ),
      DocsInstallFact(
        label: 'theme.popover / theme.border / theme.card',
        value: 'chip and card surfaces',
        description:
            'The disclosure panel, the parameter block, and the welcome '
            'card\'s capability chips each read their own base surface '
            'token.',
      ),
    ],
  );
}

Widget _bullets(ElThemeData theme, List<String> lines) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: <Widget>[
    for (final String line in lines) ...<Widget>[
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: ElWidths.prose),
        child: ElText('•  $line', ElType.small, color: theme.mutedForeground),
      ),
      SizedBox(height: el(2)),
    ],
  ],
);
