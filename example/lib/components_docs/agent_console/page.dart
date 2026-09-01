/// Public documentation page for the `agent-console` component.
///
/// **Written from nothing**, per the rollout's per-item brief:
/// `agent-console` has no page today. Everything on it is read off
/// `lib/src/blocks/agent_console/agent_console.dart` directly.
///
/// **The mock transport is reused, not reinvented.** `example/lib/agent/
/// mock_transport.dart`'s own library doc names exactly why it exists:
/// *"a real AgentTransport… that answers from a script instead of from a
/// model… every state in the machine becomes reachable on the
/// documentation page."* Every specimen below drives a real
/// `MockTransport`, so typing and pressing send genuinely walks the
/// twenty-state machine `agent-core` documents — nothing here is a
/// screenshot standing in for that.
///
/// **The console composes seven other registry items** (`agent-avatar`,
/// `agent-composer`, `agent-core`, `agent-face`, `agent-history`,
/// `agent-slash-palette`, `agent-transcript`) that each already have — or
/// will have — their own page. This page's own job is what the console
/// itself adds on top: the props, the layout, and the feature switches —
/// not a second copy of what a tool chip or a composer already documents
/// elsewhere.
///
/// **Section order** follows the house shape: Preview, Installation, Usage,
/// then one `ShowcaseSection` per facet the console itself actually has
/// (Features, Header slot, Height), then the eight disclosures.
library;

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

import '../../agent/mock_transport.dart';
import '../../docs/component_doc_page.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../docs/docs_section.dart' show DocsAnchor;
import 'meta.dart';

final ComponentDocSpec agentConsoleDocSpec = ComponentDocSpec(
  name: 'agent-console',
  title: agentConsoleDoc.title,
  description: agentConsoleDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'A real, functioning console over a real MockTransport '
          '(example/lib/agent/mock_transport.dart) — type a message and '
          'send it. Try a word like "buy" for the approval path, '
          '"report" for a tool call that returns a file, or "price" for '
          'the error path: the mock keys its script off the words in the '
          'message, exactly as the file\'s own doc describes.',
      specimen: _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
      minHeight: space(160),
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'agent-console has a real registry manifest: elattar add '
          'agent-console installs lib/src/blocks/agent_console/agent_console.dart '
          'and resolves agent-avatar, agent-composer, agent-core, '
          'agent-face, agent-history, agent-slash-palette, '
          'agent-transcript, button, dropdown-menu, icon, marker, menu, '
          'popover and source-foundation automatically. The Manual tab is '
          'for a project not using the CLI.',
      command: agentConsoleDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/agent_console.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/blocks/agent_console/agent_console.dart's generated "
              '@ui/agent_console.dart payload into components/ui.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated agent_console source here when using '
              'manual mode.',
        ),
        const DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so AgentConsole, AgentFeatures, '
              'AgentPersona and AgentModel are reachable the same way '
              'the CLI path already makes them.',
          code: "export 'agent_console.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'The smallest correct construction: a transport is the one '
          'required argument — everything else is a caller\'s own '
          'product knowledge layered on top.',
      code: _usageCode,
    ),
    ShowcaseSection(
      id: 'features',
      title: 'Features',
      description:
          'AgentFeatures: nine switches, all on by default. Every one '
          'is turned off here — *"a console with everything turned off '
          'is still a console"*, the source\'s own test that the parts '
          'are genuinely separable rather than merely arranged. Compare '
          'against Preview above, where every default is left on.',
      specimen: _FeaturesSpecimen(),
      code: _featuresCode,
      label: 'Features specimen view',
      minHeight: space(88),
    ),
    ShowcaseSection(
      id: 'header-slot',
      title: 'Header slot',
      description:
          'headerSlot renders controls at the right of the header — chat '
          'history, and whatever else a surface needs there. A slot '
          'rather than a fixed set, because what belongs beside a '
          'persona differs between a docked panel and a full page. The '
          'plain outline button below stands in for a real history '
          'trigger (agent-history\'s own job, not this file\'s).',
      specimen: _HeaderSlotSpecimen(),
      code: _headerSlotCode,
      label: 'Header slot specimen view',
      minHeight: space(160),
    ),
    ShowcaseSection(
      id: 'height',
      title: 'Height',
      description:
          'height is the className the reference\'s own two demo boxes '
          'pass, measured at 1440×900: h-152 (608px, live, everything on) '
          'and h-80 (320px, minimal). Null — the default — lets the '
          'console fill whatever box it is given instead, which is what '
          'min-h-0 flex-1 does inside a launcher\'s dialog.',
      specimen: _HeightSpecimen(),
      code: _heightCode,
      label: 'Height specimen view',
      minHeight: space(240),
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every named constructor parameter AgentConsole declares, its '
          'seven static geometry getters, and the three small data '
          'classes a caller composes it with.',
      children: const <DocsTocEntry>[
        DocsTocEntry(title: 'AgentConsole', anchor: 'api-elagentconsole'),
        DocsTocEntry(
          title: 'AgentConsole statics',
          anchor: 'api-elagentconsole-static',
        ),
        DocsTocEntry(title: 'AgentFeatures', anchor: 'api-elagentfeatures'),
        DocsTocEntry(title: 'AgentPersona', anchor: 'api-elagentpersona'),
        DocsTocEntry(title: 'AgentModel', anchor: 'api-elagentmodel'),
      ],
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'The console itself draws no interaction states — hover, '
          'press, focus belong to the buttons and fields it composes, '
          'each documented on its own page. What varies here is which '
          'AgentState the resolver picks, and what the console shows '
          'for it — see the Agent Core page\'s own Resolve agent state '
          'section for the real precedence ladder.',
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
            value: agentConsoleDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'test/agent_console_test.dart',
            description:
                'The resolver wiring, the feature switches, the '
                'welcome-card composition, and the keyboard-avoidance '
                'hook, exercised against the real widget.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/agent_console_test.dart',
            description:
                "This page's own API-completeness, live-specimen, and "
                'theme coverage.',
          ),
          const DocsInstallFact(
            label: 'Mock transport',
            value: 'example/lib/agent/mock_transport.dart',
            description:
                'The scripted AgentTransport every specimen on this '
                'page drives — see that file\'s own doc for why it '
                'exists and what it is a reference implementation of.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/agent_console/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class AgentConsoleDocPage extends StatelessWidget {
  const AgentConsoleDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: agentConsoleDoc.route,
    intro: DocsPageIntro(
      title: agentConsoleDoc.title,
      description: agentConsoleDoc.description,
    ),
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Components'),
      BreadcrumbEntry.page('Agent Console'),
    ],
    toc: agentConsoleDocSpec.toc,
    previous: const DocsPageLink(
      title: 'Agent Composer',
      route: '/components/agent-composer',
    ),
    next: const DocsPageLink(
      title: 'Agent Transcript',
      route: '/components/agent-transcript',
    ),
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('agent-console-doc-article'),
      child: ComponentDocPage(spec: agentConsoleDocSpec, header: false),
    ),
  );
}

/* ── Showcase specimens ─────────────────────────────────────────────────── */

const List<AgentCommand> _demoCommands = <AgentCommand>[
  AgentCommand(
    id: 'find',
    label: 'Find a card',
    hint: 'Search the catalogue for a card or a sealed box',
    group: AgentCommandGroup.skill,
    icon: Lucide.search,
  ),
];

class _PreviewSpecimen extends StatefulWidget {
  const _PreviewSpecimen();

  @override
  State<_PreviewSpecimen> createState() => _PreviewSpecimenState();
}

class _PreviewSpecimenState extends State<_PreviewSpecimen> {
  final MockTransport _transport = MockTransport();

  @override
  void dispose() {
    _transport.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AgentConsole(
    key: const ValueKey<String>('agent-console-preview'),
    transport: _transport,
    persona: const AgentPersona(
      name: 'Vault Assistant',
      blurb: 'Ask about inventory, pricing, or your account.',
      suggestions: <String>['What is Eclipse Vault worth right now?'],
      placeholder: 'Ask about your collection…',
    ),
    models: const <AgentModel>[
      AgentModel(id: 'fast', label: 'Fast', hint: 'Quick answers, less depth'),
      AgentModel(id: 'deep', label: 'Deep', hint: 'Slower, more thorough'),
    ],
    commands: _demoCommands,
    height: space(152),
  );
}

const String _previewCode = '''final transport = MockTransport();

AgentConsole(
  transport: transport,
  persona: const AgentPersona(
    name: 'Vault Assistant',
    blurb: 'Ask about inventory, pricing, or your account.',
    suggestions: ['What is Eclipse Vault worth right now?'],
  ),
  models: const [
    AgentModel(id: 'fast', label: 'Fast'),
    AgentModel(id: 'deep', label: 'Deep'),
  ],
  height: 608,
)''';

const String _usageCode =
    '''import 'package:elattar_design_system/elattar_design_system.dart';

AgentConsole(
  transport: myTransport, // implements AgentTransport
)''';

class _FeaturesSpecimen extends StatefulWidget {
  const _FeaturesSpecimen();

  @override
  State<_FeaturesSpecimen> createState() => _FeaturesSpecimenState();
}

class _FeaturesSpecimenState extends State<_FeaturesSpecimen> {
  final MockTransport _transport = MockTransport();

  @override
  void dispose() {
    _transport.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AgentConsole(
    key: const ValueKey<String>('agent-console-features'),
    transport: _transport,
    features: const AgentFeatures(
      avatar: false,
      suggestions: false,
      toolTrace: false,
      microphone: false,
      speech: false,
      attachments: false,
      commands: false,
      models: false,
      reset: false,
    ),
    height: space(80),
  );
}

const String _featuresCode = '''AgentConsole(
  transport: transport,
  features: const AgentFeatures(
    avatar: false,
    suggestions: false,
    toolTrace: false,
    microphone: false,
    speech: false,
    attachments: false,
    commands: false,
    models: false,
    reset: false,
  ),
  height: 320,
)''';

class _HeaderSlotSpecimen extends StatefulWidget {
  const _HeaderSlotSpecimen();

  @override
  State<_HeaderSlotSpecimen> createState() => _HeaderSlotSpecimenState();
}

class _HeaderSlotSpecimenState extends State<_HeaderSlotSpecimen> {
  final MockTransport _transport = MockTransport();

  @override
  void dispose() {
    _transport.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AgentConsole(
    key: const ValueKey<String>('agent-console-header-slot'),
    transport: _transport,
    persona: const AgentPersona(name: 'Vault Assistant'),
    headerSlot: Button(
      key: const ValueKey<String>('agent-console-header-slot-button'),
      variant: ButtonVariant.ghost,
      size: ButtonSize.iconSm,
      label: 'History',
      onPressed: () {},
      child: const Icon.lucide(Lucide.rotateCcwClock, sizePx: 16),
    ),
    height: space(152),
  );
}

const String _headerSlotCode = '''AgentConsole(
  transport: transport,
  persona: const AgentPersona(name: 'Vault Assistant'),
  headerSlot: Button(
    variant: ButtonVariant.ghost,
    size: ButtonSize.iconSm,
    label: 'History',
    onPressed: openHistory,
    child: const Icon.lucide(Lucide.rotateCcwClock, sizePx: 16),
  ),
)''';

class _HeightSpecimen extends StatefulWidget {
  const _HeightSpecimen();

  @override
  State<_HeightSpecimen> createState() => _HeightSpecimenState();
}

class _HeightSpecimenState extends State<_HeightSpecimen> {
  final MockTransport _live = MockTransport();
  final MockTransport _minimal = MockTransport();

  @override
  void dispose() {
    _live.dispose();
    _minimal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        StyledText(
          'height: 608 ("live")',
          TextStyles.small,
          color: theme.mutedForeground,
        ),
        SizedBox(height: space(2)),
        AgentConsole(
          key: const ValueKey<String>('agent-console-height-live'),
          transport: _live,
          persona: const AgentPersona(name: 'Vault Assistant'),
          height: space(152),
        ),
        SizedBox(height: space(6)),
        StyledText(
          'height: 320 ("minimal")',
          TextStyles.small,
          color: theme.mutedForeground,
        ),
        SizedBox(height: space(2)),
        AgentConsole(
          key: const ValueKey<String>('agent-console-height-minimal'),
          transport: _minimal,
          height: space(80),
        ),
      ],
    );
  }
}

const String _heightCode =
    '''AgentConsole(transport: transport, height: 608) // 'live'
AgentConsole(transport: transport, height: 320) // 'minimal\'''';

/* ── Disclosure content ─────────────────────────────────────────────────── */

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsAnchor(
        id: 'api-elagentconsole',
        child: DocsApiTable(title: 'AgentConsole', facts: _consoleFacts),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elagentconsole-static',
        child: DocsApiTable(
          title: 'AgentConsole statics',
          facts: _consoleStaticFacts,
        ),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elagentfeatures',
        child: DocsApiTable(title: 'AgentFeatures', facts: _featuresFacts),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elagentpersona',
        child: DocsApiTable(title: 'AgentPersona', facts: _personaFacts),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elagentmodel',
        child: DocsApiTable(title: 'AgentModel', facts: _modelFacts),
      ),
    ],
  );
}

const List<DocsApiFact> _consoleFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'transport',
    type: 'AgentTransport',
    description:
        'Required. What it talks to — the whole reason this widget is '
        'reusable.',
  ),
  DocsApiFact(
    name: 'persona',
    type: 'AgentPersona?',
    description: 'Optional. Name, blurb, suggestions, and a placeholder.',
  ),
  DocsApiFact(
    name: 'toolStates',
    type: 'ToolStateMap?',
    description:
        'Optional. What this agent\'s tools mean, so the face and the '
        'chips can describe them honestly.',
  ),
  DocsApiFact(
    name: 'models',
    type: 'List<AgentModel>',
    description:
        'Defaults to []. The model picker hides itself below two '
        'entries.',
  ),
  DocsApiFact(
    name: 'commands',
    type: 'List<AgentCommand>',
    description:
        'Defaults to []. Skills and browser commands offered under "/" '
        'and from the plus menu; clear and stop are added automatically.',
  ),
  DocsApiFact(
    name: 'avatar',
    type: 'AgentAvatarBuilder?',
    description:
        'Optional. What it looks like — swap the renderer, keep the '
        'machine. Defaults to AgentAvatarRegistry.renderer.',
  ),
  DocsApiFact(
    name: 'features',
    type: 'AgentFeatures',
    description: 'Defaults to AgentFeatures.all — every switch on.',
  ),
  DocsApiFact(
    name: 'accent',
    type: 'Color?',
    description: 'Optional. Recolours the whole avatar set.',
  ),
  DocsApiFact(
    name: 'speed',
    type: 'double?',
    description: 'Optional. Avatar animation speed multiplier.',
  ),
  DocsApiFact(
    name: 'renderToolResult',
    type: 'Widget Function(ToolTurn)?',
    description:
        'Optional. Turns a settled tool result into the product\'s own '
        'components.',
  ),
  DocsApiFact(
    name: 'describeApproval',
    type: 'String Function(String action, Map<String, Object?> params)?',
    description:
        'Optional. Turns a held action into a sentence a human can '
        'decide on.',
  ),
  DocsApiFact(
    name: 'headerSlot',
    type: 'Widget?',
    description:
        'Optional. Controls rendered at the right of the header — chat '
        'history, and whatever else a surface needs there.',
  ),
  DocsApiFact(
    name: 'switchPhase',
    type: 'SwitchPhase',
    description:
        'Defaults to SwitchPhase.idle. The transcript\'s cross-fade '
        'phase while switching conversations — supplied by '
        'BlurSwitchController (agent-core), never derived here.',
  ),
  DocsApiFact(
    name: 'height',
    type: 'double?',
    description:
        'Optional. The className the reference\'s own demo boxes pass. '
        'Null lets the console fill the box it is given instead.',
  ),
];

const List<DocsApiFact> _consoleStaticFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'AgentConsole.padding',
    type: 'static double (get)',
    description: '20px — the console\'s own inset, on every edge.',
  ),
  DocsApiFact(
    name: 'AgentConsole.gap',
    type: 'static double (get)',
    description: '16px between the header, the scroller and the composer.',
  ),
  DocsApiFact(
    name: 'AgentConsole.headerGap',
    type: 'static double (get)',
    description: '12px inside the header.',
  ),
  DocsApiFact(
    name: 'AgentConsole.headerInset',
    type: 'static double (get)',
    description:
        '24px right padding on the header, clearing a dialog\'s '
        'own close button.',
  ),
  DocsApiFact(
    name: 'AgentConsole.turnGap',
    type: 'static double (get)',
    description: '16px between rows in the scroller.',
  ),
  DocsApiFact(
    name: 'AgentConsole.scrollerInset',
    type: 'static double (get)',
    description: '4px, beside the scrollbar.',
  ),
  DocsApiFact(
    name: 'AgentConsole.pinTolerance',
    type: 'static double (get)',
    description:
        '32px. A reader within this of the bottom stays pinned there as '
        'new content arrives; further up, autoscroll leaves them alone.',
  ),
];

const List<DocsApiFact> _featuresFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'avatar',
    type: 'bool',
    description: 'Defaults to true. The face and the status line beside it.',
  ),
  DocsApiFact(
    name: 'suggestions',
    type: 'bool',
    description:
        'Defaults to true. Starter prompts, on an empty '
        'conversation.',
  ),
  DocsApiFact(
    name: 'toolTrace',
    type: 'bool',
    description:
        'Defaults to true. Tool chips and action chips, and the '
        'generative renderers for their results.',
  ),
  DocsApiFact(
    name: 'microphone',
    type: 'bool',
    description:
        'Defaults to true. Dictation, with the live waveform — honoured '
        'as a flag only: the port ships no speech adapter, see '
        'Dependencies.',
  ),
  DocsApiFact(
    name: 'speech',
    type: 'bool',
    description:
        'Defaults to true. Read answers aloud — the same honoured-as-a-'
        'flag caveat as microphone.',
  ),
  DocsApiFact(
    name: 'attachments',
    type: 'bool',
    description:
        'Defaults to true. The file tray, drag-and-drop and '
        'paste.',
  ),
  DocsApiFact(
    name: 'commands',
    type: 'bool',
    description: 'Defaults to true. The "/" palette.',
  ),
  DocsApiFact(
    name: 'models',
    type: 'bool',
    description: 'Defaults to true. The model picker.',
  ),
  DocsApiFact(
    name: 'reset',
    type: 'bool',
    description: 'Defaults to true. Clear the conversation.',
  ),
  DocsApiFact(
    name: 'AgentFeatures.all',
    type: 'static const AgentFeatures',
    description: 'Every switch on — the constructor default itself.',
  ),
];

const List<DocsApiFact> _personaFacts = <DocsApiFact>[
  DocsApiFact(name: 'name', type: 'String', description: 'Required.'),
  DocsApiFact(name: 'blurb', type: 'String?', description: 'Optional.'),
  DocsApiFact(
    name: 'suggestions',
    type: 'List<String>',
    description: 'Defaults to []. Starter prompts on the welcome card.',
  ),
  DocsApiFact(
    name: 'placeholder',
    type: 'String?',
    description:
        'Optional. Overrides the composer\'s own '
        'AgentComposer.defaultPlaceholder.',
  ),
];

const List<DocsApiFact> _modelFacts = <DocsApiFact>[
  DocsApiFact(name: 'id', type: 'String', description: 'Required.'),
  DocsApiFact(name: 'label', type: 'String', description: 'Required.'),
  DocsApiFact(
    name: 'hint',
    type: 'String?',
    description:
        'Optional. Shown under the label in the model menu\'s own '
        'two-line row.',
  ),
];

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Empty conversation',
    treatment:
        'transport.turns.isEmpty renders WelcomeCard instead of '
        'the scroller\'s own rows.',
    userSignal:
        'The persona, its blurb, skill chips and suggestions, '
        'centred.',
  ),
  DocsStateFact(
    state: 'Turn arrives',
    treatment:
        'The transport notifies; the console rebuilds and, while '
        'pinned, autoscrolls to the new bottom on the next frame.',
    userSignal:
        'The transcript grows and the view follows it, unless '
        'the reader has scrolled up to read.',
  ),
  DocsStateFact(
    state: 'Approval pending',
    treatment:
        'transport.pendingApprovals renders an ApprovalCard after '
        'every turn, not in the transcript position the action turn '
        'occupies — drift, reproduced as the reference has it.',
    userSignal: 'A card with Approve/Decline appears at the bottom.',
  ),
  DocsStateFact(
    state: 'Stopped mid-stream',
    treatment:
        'Pressing stop calls transport.abort() and marks the turn '
        'stopped locally; the half-written text renders unstreaming, '
        'with a "Stopped by you" marker after it.',
    userSignal:
        'The cursor disappears and a small marker names what '
        'happened.',
  ),
  DocsStateFact(
    state: 'Keyboard open (mobile)',
    treatment:
        'USER-ORDERED MOBILE ADAPTATION: a spacer of '
        'MediaQuery.viewInsets.bottom at the end of the column lifts the '
        'composer by the keyboard\'s height; the scroller\'s Expanded '
        'gives up the same amount.',
    userSignal:
        'The composer stays above the keyboard instead of '
        'hiding behind it.',
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment:
        'Every animated part this console composes (the typing cursor, '
        'the welcome card\'s entrance, the avatar) routes its own '
        'duration through effectiveMotionDuration.',
    userSignal:
        'Every entrance and pulse lands on its end frame '
        'immediately.',
  ),
];

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'The console itself sets no top-level Semantics container — each '
            'part it composes (the composer\'s textField Semantics, the '
            'approval card\'s liveRegion, a tool chip\'s expanded state) '
            'carries its own, documented on that part\'s own page.',
        'The error banner (a turn-level error or the transport\'s own '
            'standing one) is plain StyledText with no Semantics.liveRegion '
            'of its own — unlike FieldError\'s live region (Field '
            'page), a screen reader is not proactively told the '
            'transport failed.',
        'The model picker\'s trigger reads the chosen model\'s label as '
            'its own visible text, so its accessible name always '
            'reflects the current choice.',
      ]);
}

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Every keyboard interaction this page can show — Enter to send, '
            'arrow keys in the slash palette — belongs to the composer, '
            'documented on the Agent Composer page.',
        'The console itself wires no Focus.onKeyEvent of its own: it '
            'only owns the FocusNode it hands the composer.',
        'No custom FocusTraversalPolicy: Tab and Shift+Tab walk whatever '
            'order this file\'s own Column declares — header, scroller, '
            'composer.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'No breakpoint branching: the same widget tree renders at 390px '
            'and 1440px; only the keyboard-inset spacer (below) ever '
            'changes the tree shape, and only on a phone.',
        'USER-ORDERED MOBILE ADAPTATION: MediaQuery.viewInsets.bottom is '
            'read in didChangeDependencies and turned into a trailing '
            'SizedBox, lifting the composer clear of a software keyboard '
            'inside a Scaffold with no bottom-inset handling of its own. '
            'Zero, and built, on every desktop frame.',
        'BOUNDARY, recorded rather than patched: a console pinned to a '
            'height shorter than its own chrome plus the keyboard has '
            'nowhere to put the lift, and the column overflows — the '
            'source names this directly rather than papering over it.',
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
            value: 'lib/src/blocks/agent_console/agent_console.dart',
            description:
                'One file, no companions; the registry manifest lists '
                'exactly one entry under "files".',
          ),
          const DocsInstallFact(
            label: 'Component imports',
            value:
                'agent_avatar.dart, agent_composer.dart, '
                'agent_core.dart, agent_face.dart, agent_history.dart '
                '(BlurSwitch only), agent_slash_palette.dart, '
                'agent_transcript.dart, button.dart, dropdown_menu.dart, '
                'icon.dart, icon_paths.g.dart, marker.dart, menu.dart, '
                'popover.dart',
            description:
                'agent_history.dart is imported for BlurSwitch alone — '
                'the widget form of blurClass, kept to that one owner '
                'rather than a second copy here.',
          ),
          DocsInstallFact(
            label: 'registryDependencies',
            value: agentConsoleDoc.dependencies.join(', '),
            description:
                "The manifest's own list, resolved automatically by "
                'elattar add agent-console.',
          ),
          const DocsInstallFact(
            label: 'What this port cannot do',
            value: 'Web Speech API dictation and read-aloud',
            description:
                'useBrowserSpeech and useDictation are browser hooks '
                'with no Flutter equivalent, and this port invents none: '
                'AgentFeatures.speech and .microphone are honoured as '
                'flags only, AgentVoice stays at rest, and the '
                'built-in "voice" command never appears.',
          ),
        ],
      ),
      SizedBox(height: space(4)),
      const DocsLinkRow(
        links: <DocsLink>[
          DocsLink(label: 'Agent Avatar', route: '/components/agent_avatar'),
          DocsLink(label: 'Agent Core', route: '/components/agent-core'),
          DocsLink(
            label: 'Agent Composer',
            route: '/components/agent-composer',
          ),
          DocsLink(label: 'Agent Face', route: '/components/agent_face'),
          DocsLink(label: 'Agent History', route: '/components/agent_history'),
          DocsLink(
            label: 'Agent Slash Palette',
            route: '/components/agent_slash_palette',
          ),
          DocsLink(
            label: 'Agent Transcript',
            route: '/components/agent-transcript',
          ),
          DocsLink(label: 'Button', route: '/components/button'),
          DocsLink(label: 'Dropdown Menu', route: '/components/dropdown-menu'),
          DocsLink(label: 'Icon', route: '/components/icon'),
          DocsLink(label: 'Marker', route: '/components/marker'),
          DocsLink(label: 'Menu', route: '/components/menu'),
          DocsLink(label: 'Popover', route: '/components/popover'),
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
        label: 'theme.destructive / theme.destructiveText',
        value: 'the error banner',
        description:
            '8% fill, 30% border, on a turn-level or a '
            'transport-level error.',
      ),
      DocsInstallFact(
        label: 'accent',
        value: 'the whole avatar set',
        description:
            'Any colour, recolouring every avatar frame — a prop this '
            'file passes straight through to AgentFace, not a theme '
            'token of its own.',
      ),
      DocsInstallFact(
        label: 'Everything else',
        value: 'delegated',
        description:
            'The console\'s own Column, Padding and SizedBox carry no '
            'colour at all: every other surface (the composer\'s shell, '
            'a message bubble, a chip) reads its own theme tokens, '
            'documented on that part\'s own page.',
      ),
    ],
  );
}

Widget _bullets(ThemeTokens theme, List<String> lines) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: <Widget>[
    for (final String line in lines) ...<Widget>[
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: LayoutWidths.prose),
        child: StyledText(
          '•  $line',
          TextStyles.small,
          color: theme.mutedForeground,
        ),
      ),
      SizedBox(height: space(2)),
    ],
  ],
);
