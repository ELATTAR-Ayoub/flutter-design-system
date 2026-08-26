/// Public documentation page for the `agent-composer` component.
///
/// **Written from nothing**, per the rollout's per-item brief:
/// `agent-composer` has no page today. Everything on it is read off
/// `lib/src/components/agent_composer.dart` directly, and every specimen is
/// a real, functioning `ElAgentComposer` — typing, sending, removing an
/// attachment, and stopping a busy turn all genuinely run the widget's own
/// callbacks, not a screenshot standing in for them.
///
/// **Section order** follows the house shape: Preview, Installation, Usage,
/// then one `ShowcaseSection` per facet the composer actually has
/// (Attachments, Commands, Busy, Disabled, Accessory, Dictation error), then
/// the eight disclosures.
///
/// **Skipped, honestly.** Two behaviours documented in the source cannot be
/// demonstrated live and are named rather than faked: the plus menu's
/// *"Photos & files"* row (`_pickFiles`) is a deliberate no-op — a widget
/// layer cannot open an OS file dialog — and the refusal message under the
/// shell only fires from inside `_takeFiles`, which nothing on this page can
/// reach without a real drag-and-drop payload over `kElMaxFileBytes`. Both
/// are named in the Dependencies and States disclosures instead of staged
/// with an invented trigger.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/component_doc_page.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../docs/docs_section.dart' show DocsAnchor;
import 'meta.dart';

final ComponentDocSpec agentComposerDocSpec = ComponentDocSpec(
  name: 'agent-composer',
  title: agentComposerDoc.title,
  description: agentComposerDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'A real, functioning composer: type a message and press send (or '
          'Enter) to see it land in the list below, exactly what onSubmit '
          'is for. canSend is real too — the send button stays disabled '
          'until there is text or an attachment.',
      specimen: _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
      minHeight: el(64),
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'agent-composer has a real registry manifest: elattar add '
          'agent-composer installs lib/src/components/agent_composer.dart '
          'and resolves agent-attach-menu, agent-attachments, agent-core, '
          'agent-slash-palette, button, icon, input, machine-surface and '
          'source-foundation automatically. The Manual tab is for a '
          'project not using the CLI.',
      command: agentComposerDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/agent_composer.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/agent_composer.dart's generated "
              '@ui/agent_composer.dart payload into components/ui.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated agent_composer source here when using '
              'manual mode.',
        ),
        const DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so ElAgentComposer is reachable the '
              'same way the CLI path already makes it.',
          code: "export 'agent_composer.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'The smallest correct construction: a controller the caller '
          'owns, and onSubmit to read it. Every example below only adds '
          'named arguments on top of this.',
      code: _usageCode,
    ),
    ShowcaseSection(
      id: 'attachments',
      title: 'Attachments',
      description:
          'attachments != null mounts the file tray above the input, one '
          'border-b panel of ElAgentAttachmentList in compact mode. Remove '
          'is real here: onRemoveAttachment actually drops the row. Adding '
          'a new one is not demonstrated: onAttach is wired to a real '
          'callback, but nothing can produce a real ElAgentAttachment on '
          'this page without a file picker, which onPickFiles cannot open '
          '(the widget layer has no such API — see Dependencies).',
      specimen: _AttachmentsSpecimen(),
      code: _attachmentsCode,
      label: 'Attachments specimen view',
      minHeight: el(64),
    ),
    ShowcaseSection(
      id: 'commands',
      title: 'Commands',
      description:
          'commands != null and a leading "/" opens the slash palette: '
          'the controller below starts with the text "/" already in it, '
          'so the palette is open on load rather than after a simulated '
          'keystroke. DOCUMENTED DRIFT, reproduced rather than fixed: the '
          'source\'s own library doc records that the palette paints '
          'above the composer without contributing to its layout height, '
          'so a short stage like this one clips it exactly the way the '
          'reference does inside its own bounded panel.',
      specimen: _CommandsSpecimen(),
      code: _commandsCode,
      label: 'Commands specimen view',
      minHeight: el(96),
    ),
    ShowcaseSection(
      id: 'busy',
      title: 'Busy',
      description:
          'busy: true swaps the send arrow for a stop square, disabled: '
          'false lets it still be pressed. Tapping it here really calls '
          'onStop and flips the specimen back to its resting state.',
      specimen: _BusySpecimen(),
      code: _busyCode,
      label: 'Busy specimen view',
    ),
    ShowcaseSection(
      id: 'disabled',
      title: 'Disabled',
      description:
          'disabled: true — "the transport is not ready to carry a '
          'message at all" — dims the input to 60% opacity (not the 45% '
          'the button family dims to) and disables send regardless of '
          'canSend.',
      specimen: _DisabledSpecimen(),
      code: _disabledCode,
      label: 'Disabled specimen view',
    ),
    ShowcaseSection(
      id: 'accessory',
      title: 'Accessory',
      description:
          'accessory is a bare slot rendered on the left of the control '
          'row, beside the plus menu. agent_composer.dart builds no model '
          'picker of its own — ElAgentConsole is the real caller, and '
          'fills this slot with its own ModelPicker. The plain outline '
          'button below stands in for that, to show where the slot sits '
          'without documenting a widget this file does not declare.',
      specimen: _AccessorySpecimen(),
      code: _accessoryCode,
      label: 'Accessory specimen view',
    ),
    ShowcaseSection(
      id: 'dictation-error',
      title: 'Dictation error',
      description:
          'dictationError renders the same type-caption '
          'text-destructive-ink line as a refused attachment, mt-2 below '
          'the shell. agent_composer.dart reads only this one field of a '
          'dictation session — it owns no microphone or speech logic '
          'itself, see Dependencies.',
      specimen: _DictationErrorSpecimen(),
      code: _dictationErrorCode,
      label: 'Dictation error specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every named constructor parameter ElAgentComposer declares, '
          'plus the fifteen static geometry getters that give a consumer '
          '(agent-console, principally) the composer\'s own measurements '
          'rather than restating them.',
      children: const <DocsTocEntry>[
        DocsTocEntry(title: 'ElAgentComposer', anchor: 'api-elagentcomposer'),
        DocsTocEntry(
          title: 'ElAgentComposer statics',
          anchor: 'api-elagentcomposer-static',
        ),
      ],
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'Read off _ElAgentComposerState.build and the class doc\'s own '
          'drift register, not inferred.',
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
            value: agentComposerDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'test/agent_composer_test.dart',
            description:
                'The key router, the drag target, the grow-to-fit cap, '
                'and the refusal message, exercised against the real '
                'widget.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/agent_composer_test.dart',
            description:
                "This page's own API-completeness, live-specimen, and "
                'theme coverage.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/agent_composer/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class AgentComposerDocPage extends StatelessWidget {
  const AgentComposerDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: agentComposerDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / AGENT',
      title: agentComposerDoc.title,
      description: agentComposerDoc.description,
    ),
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Components'),
      ElBreadcrumbEntry.page('Agent Composer'),
    ],
    toc: agentComposerDocSpec.toc,
    previous: const DocsPageLink(
      title: 'Agent Core',
      route: '/components/agent-core',
    ),
    next: const DocsPageLink(
      title: 'Agent Console',
      route: '/components/agent-console',
    ),
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('agent-composer-doc-article'),
      child: ComponentDocPage(spec: agentComposerDocSpec, header: false),
    ),
  );
}

/* ── Showcase specimens ─────────────────────────────────────────────────── */

class _PreviewSpecimen extends StatefulWidget {
  const _PreviewSpecimen();

  @override
  State<_PreviewSpecimen> createState() => _PreviewSpecimenState();
}

class _PreviewSpecimenState extends State<_PreviewSpecimen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focus = FocusNode();
  final List<String> _sent = <String>[];

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _submit() {
    final String text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _sent.add(text);
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ElAgentComposer(
          key: const ValueKey<String>('agent-composer-preview'),
          controller: _controller,
          focusNode: _focus,
          onSubmit: _submit,
        ),
        if (_sent.isNotEmpty) ...<Widget>[
          SizedBox(height: el(3)),
          ElText('Sent', ElType.section, color: theme.mutedForeground),
          SizedBox(height: el(1)),
          for (final String message in _sent)
            ElText(message, ElType.small, color: theme.foreground),
        ],
      ],
    );
  }
}

const String _previewCode = '''final controller = TextEditingController();

ElAgentComposer(
  controller: controller,
  onSubmit: () {
    send(controller.text.trim());
    controller.clear();
  },
)''';

const String _usageCode =
    '''import 'package:elattar_design_system/elattar_design_system.dart';

final TextEditingController controller = TextEditingController();

ElAgentComposer(
  controller: controller,
  onSubmit: () => send(controller.text),
)''';

class _AttachmentsSpecimen extends StatefulWidget {
  const _AttachmentsSpecimen();

  @override
  State<_AttachmentsSpecimen> createState() => _AttachmentsSpecimenState();
}

class _AttachmentsSpecimenState extends State<_AttachmentsSpecimen> {
  final TextEditingController _controller = TextEditingController();

  List<ElAgentAttachment> _attachments = const <ElAgentAttachment>[
    ElAgentAttachment(
      id: 'a1',
      name: 'roadmap.md',
      mime: 'text/markdown',
      kind: ElAgentAttachmentKind.other,
      size: 1892,
    ),
    ElAgentAttachment(
      id: 'a2',
      name: 'cover.png',
      mime: 'image/png',
      kind: ElAgentAttachmentKind.image,
      size: 204800,
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ElAgentComposer(
    key: const ValueKey<String>('agent-composer-attachments'),
    controller: _controller,
    onSubmit: () {},
    attachments: _attachments,
    onAttach: (List<ElAgentAttachment> files) => setState(
      () => _attachments = <ElAgentAttachment>[..._attachments, ...files],
    ),
    onRemoveAttachment: (String id) => setState(
      () => _attachments = _attachments
          .where((ElAgentAttachment a) => a.id != id)
          .toList(),
    ),
  );
}

const String _attachmentsCode = '''ElAgentComposer(
  controller: controller,
  onSubmit: send,
  attachments: attachments, // List<ElAgentAttachment>
  onAttach: (files) => setState(() => attachments = [...attachments, ...files]),
  onRemoveAttachment: (id) => setState(
    () => attachments = attachments.where((a) => a.id != id).toList(),
  ),
)''';

class _CommandsSpecimen extends StatefulWidget {
  const _CommandsSpecimen();

  @override
  State<_CommandsSpecimen> createState() => _CommandsSpecimenState();
}

class _CommandsSpecimenState extends State<_CommandsSpecimen> {
  final TextEditingController _controller = TextEditingController(text: '/');

  static const List<ElAgentCommand> _commands = <ElAgentCommand>[
    ElAgentCommand(
      id: 'summarize',
      label: 'Summarize',
      hint: 'Summarize the conversation so far',
      group: ElAgentCommandGroup.skill,
      icon: ElLucide.scrollText,
    ),
    ElAgentCommand(
      id: 'clear',
      label: 'Clear',
      hint: 'Start a new conversation',
      group: ElAgentCommandGroup.command,
      icon: ElLucide.rotateCcw,
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ElAgentComposer(
    key: const ValueKey<String>('agent-composer-commands'),
    controller: _controller,
    onSubmit: () {},
    commands: _commands,
  );
}

const String _commandsCode = '''ElAgentComposer(
  controller: controller, // starts with '/' to show the palette open
  onSubmit: send,
  commands: const [
    ElAgentCommand(
      id: 'summarize',
      label: 'Summarize',
      hint: 'Summarize the conversation so far',
      group: ElAgentCommandGroup.skill,
      icon: ElLucide.scrollText,
    ),
    ElAgentCommand(
      id: 'clear',
      label: 'Clear',
      hint: 'Start a new conversation',
      group: ElAgentCommandGroup.command,
      icon: ElLucide.rotateCcw,
    ),
  ],
)''';

class _BusySpecimen extends StatefulWidget {
  const _BusySpecimen();

  @override
  State<_BusySpecimen> createState() => _BusySpecimenState();
}

class _BusySpecimenState extends State<_BusySpecimen> {
  final TextEditingController _controller = TextEditingController();
  bool _busy = true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ElAgentComposer(
    key: const ValueKey<String>('agent-composer-busy'),
    controller: _controller,
    onSubmit: () {},
    busy: _busy,
    onStop: () => setState(() => _busy = false),
  );
}

const String _busyCode = '''ElAgentComposer(
  controller: controller,
  onSubmit: send,
  busy: isAnswering,
  onStop: transport.abort,
)''';

class _DisabledSpecimen extends StatefulWidget {
  const _DisabledSpecimen();

  @override
  State<_DisabledSpecimen> createState() => _DisabledSpecimenState();
}

class _DisabledSpecimenState extends State<_DisabledSpecimen> {
  final TextEditingController _controller = TextEditingController(
    text: 'Waiting on the transport…',
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ElAgentComposer(
    key: const ValueKey<String>('agent-composer-disabled'),
    controller: _controller,
    onSubmit: () {},
    disabled: true,
  );
}

const String _disabledCode = '''ElAgentComposer(
  controller: controller,
  onSubmit: send,
  disabled: !transport.isReady,
)''';

class _AccessorySpecimen extends StatefulWidget {
  const _AccessorySpecimen();

  @override
  State<_AccessorySpecimen> createState() => _AccessorySpecimenState();
}

class _AccessorySpecimenState extends State<_AccessorySpecimen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ElAgentComposer(
    key: const ValueKey<String>('agent-composer-accessory'),
    controller: _controller,
    onSubmit: () {},
    accessory: ElButton(
      key: const ValueKey<String>('agent-composer-accessory-slot'),
      variant: ElButtonVariant.ghost,
      size: ElButtonSize.sm,
      onPressed: () {},
      child: const Text('Model'),
    ),
  );
}

const String _accessoryCode = '''// A caller's own slot content — ElAgentConsole fills this with its
// ModelPicker; agent_composer.dart declares neither.
ElAgentComposer(
  controller: controller,
  onSubmit: send,
  accessory: ElButton(
    variant: ElButtonVariant.ghost,
    size: ElButtonSize.sm,
    onPressed: openModelMenu,
    child: const Text('Model'),
  ),
)''';

class _DictationErrorSpecimen extends StatefulWidget {
  const _DictationErrorSpecimen();

  @override
  State<_DictationErrorSpecimen> createState() =>
      _DictationErrorSpecimenState();
}

class _DictationErrorSpecimenState extends State<_DictationErrorSpecimen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ElAgentComposer(
    key: const ValueKey<String>('agent-composer-dictation-error'),
    controller: _controller,
    onSubmit: () {},
    dictationError: 'The microphone could not be reached.',
  );
}

const String _dictationErrorCode = '''ElAgentComposer(
  controller: controller,
  onSubmit: send,
  dictationError: dictation?.error, // 'The microphone could not be reached.'
)''';

/* ── Disclosure content ─────────────────────────────────────────────────── */

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsAnchor(
        id: 'api-elagentcomposer',
        child: DocsApiTable(
          title: 'ElAgentComposer',
          facts: _composerFacts,
        ),
      ),
      SizedBox(height: el(6)),
      const DocsAnchor(
        id: 'api-elagentcomposer-static',
        child: DocsApiTable(
          title: 'ElAgentComposer statics',
          facts: _composerStaticFacts,
        ),
      ),
    ],
  );
}

const List<DocsApiFact> _composerFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'controller',
    type: 'TextEditingController',
    description:
        'Required. value + onChange + the writable half of inputRef, as '
        'one object — the design a controlled Flutter text field already '
        'is.',
  ),
  DocsApiFact(
    name: 'focusNode',
    type: 'FocusNode?',
    description: 'Optional. The focus half of inputRef.',
  ),
  DocsApiFact(
    name: 'onSubmit',
    type: 'VoidCallback',
    description:
        'Required. Called on a pressed send AND on Enter without Shift, '
        'whenever the composer is not disabled — regardless of whether '
        'there is anything to send; the caller decides.',
  ),
  DocsApiFact(
    name: 'onStop',
    type: 'VoidCallback?',
    description:
        'Optional. Renders the stop square in place of send while busy.',
  ),
  DocsApiFact(
    name: 'disabled',
    type: 'bool',
    description:
        'Defaults to false. "The transport is not ready to carry a '
        'message at all."',
  ),
  DocsApiFact(
    name: 'busy',
    type: 'bool',
    description: 'Defaults to false. "The agent is answering" — send '
        'becomes stop.',
  ),
  DocsApiFact(
    name: 'placeholder',
    type: 'String?',
    description: 'Optional. Defaults to ElAgentComposer.defaultPlaceholder.',
  ),
  DocsApiFact(
    name: 'commands',
    type: 'List<ElAgentCommand>?',
    description:
        'Optional. Skills and browser commands offered under "/" — see '
        'the Agent Slash Palette page for ElAgentCommand itself.',
  ),
  DocsApiFact(
    name: 'attachments',
    type: 'List<ElAgentAttachment>?',
    description: 'Optional. Non-null mounts the file tray above the input.',
  ),
  DocsApiFact(
    name: 'onAttach',
    type: 'ValueChanged<List<ElAgentAttachment>>?',
    description:
        'Optional. Non-null is the composer\'s own condition for '
        'mounting the plus menu\'s "Photos & files" row and for accepting '
        'a drag-and-drop drop.',
  ),
  DocsApiFact(
    name: 'onRemoveAttachment',
    type: 'ValueChanged<String>?',
    description: 'Optional. Called with the attachment id.',
  ),
  DocsApiFact(
    name: 'accessory',
    type: 'Widget?',
    description:
        'Optional. Slot for the model picker, rendered on the left of '
        'the control row. ElAgentConsole is the real caller that fills '
        'it; this file declares no picker of its own.',
  ),
  DocsApiFact(
    name: 'micControl',
    type: 'Widget?',
    description:
        'Optional. The whole microphone control, supplied by the '
        'console because it also carries the speech settings. Rendered '
        'immediately left of send.',
  ),
  DocsApiFact(
    name: 'dictationError',
    type: 'String?',
    description:
        'Optional. dictation?.error — the only field of a dictation '
        'session this component reads.',
  ),
];

const List<DocsApiFact> _composerStaticFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'ElAgentComposer.defaultPlaceholder',
    type: 'static const String',
    description: '"Ask anything…" — a real horizontal ellipsis.',
  ),
  DocsApiFact(
    name: 'ElAgentComposer.dropPlaceholder',
    type: 'static const String',
    description: '"Drop files here" — shown while dragging.',
  ),
  DocsApiFact(
    name: 'ElAgentComposer.inputLabel',
    type: 'static const String',
    description: '"Message" — the input\'s accessible name.',
  ),
  DocsApiFact(
    name: 'ElAgentComposer.maxRowsPx',
    type: 'static double (get)',
    description:
        '200px. The input grows to fit, up to this cap, then scrolls.',
  ),
  DocsApiFact(
    name: 'ElAgentComposer.inputInsets',
    type: 'static EdgeInsets (get)',
    description: '16px horizontal, 12px vertical, on the input.',
  ),
  DocsApiFact(
    name: 'ElAgentComposer.controlInsets',
    type: 'static EdgeInsets (get)',
    description: '8px left/right, 8px bottom, on the control row.',
  ),
  DocsApiFact(
    name: 'ElAgentComposer.controlGap',
    type: 'static double (get)',
    description: '4px between the controls in the row.',
  ),
  DocsApiFact(
    name: 'ElAgentComposer.trayPadding',
    type: 'static double (get)',
    description: '12px on the file tray.',
  ),
  DocsApiFact(
    name: 'ElAgentComposer.inlineGap',
    type: 'static double (get)',
    description:
        '6px. The inline-block descent under the input the reference\'s '
        'own line box leaves — reproduced as real geometry, not a bug.',
  ),
  DocsApiFact(
    name: 'ElAgentComposer.controlSize',
    type: 'static ElButtonSize (get)',
    description:
        'ElButtonSize.iconSm — the send, stop and plus controls are all '
        'one rung, 32px.',
  ),
  DocsApiFact(
    name: 'ElAgentComposer.sendGlyphSize',
    type: 'static double (get)',
    description: '16px, the base class list\'s own icon size at this rung.',
  ),
  DocsApiFact(
    name: 'ElAgentComposer.stopGlyphSize',
    type: 'static double (get)',
    description: '14px, written explicitly at the call site.',
  ),
  DocsApiFact(
    name: 'ElAgentComposer.dragFillAlpha',
    type: 'static const double',
    description: '0.08 — the agent-tinted fill while a file is dragged over.',
  ),
  DocsApiFact(
    name: 'ElAgentComposer.disabledInputOpacity',
    type: 'static const double',
    description:
        '0.60 — the input alone, deliberately not the 45% the button '
        'family dims to.',
  ),
  DocsApiFact(
    name: 'ElAgentComposer.messageTopGap',
    type: 'static double (get)',
    description: '8px above the refusal and dictation-error lines.',
  ),
];

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Rest',
    treatment:
        'ElMachineSurface at ElShadows.pressed, theme.card fill, '
        'theme.border rim, rounded-xl.',
    userSignal: 'A neutral, slightly recessed shell.',
  ),
  DocsStateFact(
    state: 'Typing / growing',
    treatment:
        'The EditableText grows a line at a time up to maxRowsPx (200), '
        'then scrolls inside the cap rather than growing the shell '
        'further.',
    userSignal: 'The box gets taller as a message gets longer, to a point.',
  ),
  DocsStateFact(
    state: 'Palette open',
    treatment:
        'A leading "/" with no space or newline before the caret opens '
        'ElAgentSlashPalette, painted above the shell without adding to '
        'its layout height (a MultiChildRenderObjectWidget, not a Stack): '
        'see Commands above.',
    userSignal: 'A floating list of commands appears above the composer.',
  ),
  DocsStateFact(
    state: 'Dragging a file over',
    treatment:
        'onAttach != null makes the shell a DragTarget: fill and border '
        'both swap to theme.agent (8% and solid), and the placeholder '
        'reads "Drop files here".',
    userSignal: 'The shell tints and the placeholder changes while '
        'something is dragged over it.',
  ),
  DocsStateFact(
    state: 'Busy',
    treatment: 'busy: true swaps the send button for a stop square, '
        'onStop permitting.',
    userSignal: 'Send becomes stop while the agent is answering.',
  ),
  DocsStateFact(
    state: 'Disabled',
    treatment:
        'disabled: true dims the input to 60% opacity (disabledInputOpacity, '
        'not the button family\'s 45%) and forces canSend false regardless '
        'of content.',
    userSignal: 'Faded input, an unresponsive send.',
  ),
  DocsStateFact(
    state: 'Refused attachment',
    treatment:
        'A file over kElMaxFileBytes (25 MiB) is dropped from the '
        'accepted list and named in a type-caption destructiveInk line '
        'below the shell, via _takeFiles — not reachable from outside on '
        'this page, see the section note above.',
    userSignal: 'A red line names the file and the byte limit.',
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment:
        'The rotation-transform chevron the composer shares with '
        'ElToolChip and the palette\'s own fade-up both route through '
        'elAnimationDuration, which is Duration.zero under '
        'MediaQuery.disableAnimations.',
    userSignal: 'The palette appears instantly instead of fading up.',
  ),
];

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'The input is Semantics(textField: true, multiline: true, label: '
            "'Message', enabled: widget.enabled) — a stable accessible "
            'name regardless of the live placeholder text swapping to '
            '"Drop files here" while dragging.',
        'Send and stop both carry label: (\'Send\' / \'Stop\'): '
            'ElButton.label replaces the icon-only child\'s name, so an '
            'icon button never announces as unlabelled.',
        'The plus menu (ElAgentAttachMenu) and the file tray '
            '(ElAgentAttachmentList) each carry their own Semantics, '
            'documented on their own pages, not repeated here.',
        'Known gap: the refusal message and the dictation-error message '
            'are plain type-caption text with no Semantics(liveRegion: '
            'true) of their own — unlike ElFieldError\'s live region '
            '(see the Field page), a screen reader is not proactively '
            'told a file was refused.',
      ]);
}

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'A Focus wraps the whole composer (canRequestFocus: false, '
            'skipTraversal: true) above the field\'s own node, so a key '
            'reaches it before DefaultTextEditingShortcuts.',
        'Enter (and NumpadEnter) without Shift calls onSubmit, whenever '
            'the composer is not disabled — Shift+Enter is left to the '
            'field\'s own newline handling.',
        'While the palette is open: ArrowDown/ArrowUp move the active '
            'row, Enter or Tab applies it, and Escape is meant to close '
            'it — DOCUMENTED DRIFT: it sets the caret to −1 on key-down, '
            'but the very same physical keypress\'s key-up restores the '
            'real caret, so the palette does not actually close. '
            'Reproduced exactly as the reference behaves.',
        'No custom FocusTraversalPolicy: Tab and Shift+Tab walk whatever '
            'order the surrounding page already declares.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'No breakpoint branching of its own: the same widget tree '
            'renders at 390px and 1440px.',
        'USER-ORDERED MOBILE ADAPTATION: the composer wears '
            'ElFieldVisibility directly (it holds a bare EditableText, '
            'not a ElInput), so focusing it inside a scroller on a phone '
            'scrolls the whole shell clear of the software keyboard. '
            'Inert on every desktop frame.',
        'The shell has no fixed width: it fills whatever its parent '
            'gives it (ElAgentConsole passes it the console\'s own '
            'measure).',
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
            value: 'lib/src/components/agent_composer.dart',
            description:
                'One file, no companions; the registry manifest lists '
                'exactly one entry under "files".',
          ),
          const DocsInstallFact(
            label: 'Component imports',
            value: 'agent_attachments.dart, agent_attach_menu.dart, '
                'agent_core.dart, agent_slash_palette.dart, button.dart, '
                'icon.dart, icon_paths.g.dart, input.dart',
            description:
                'input.dart is imported for ElFieldVisibility and '
                'ElFieldSurface.selectionAlpha only — the composer holds '
                'its own EditableText, never a ElInput itself.',
          ),
          const DocsInstallFact(
            label: 'Effect import',
            value: 'effects/machine_surface.dart',
            description: 'ElMachineSurface paints the shell.',
          ),
          DocsInstallFact(
            label: 'registryDependencies',
            value: agentComposerDoc.dependencies.join(', '),
            description:
                "The manifest's own list, resolved automatically by "
                'elattar add agent-composer.',
          ),
          const DocsInstallFact(
            label: 'What a widget layer cannot do',
            value: 'Open an OS file picker; read event.clipboardData.files',
            description:
                'Two recorded divergences from the reference: the plus '
                'menu\'s "Photos & files" row mounts (onAttach != null is '
                'the same condition the reference uses) but its press is '
                'inert, and paste-to-attach is not built at all — '
                "Flutter's clipboard carries text, never files.",
          ),
        ],
      ),
      SizedBox(height: el(4)),
      const DocsLinkRow(
        links: <DocsLink>[
          DocsLink(
            label: 'Agent Attach Menu',
            route: '/components/agent_attach_menu',
          ),
          DocsLink(
            label: 'Agent Attachments',
            route: '/components/agent_attachments',
          ),
          DocsLink(label: 'Agent Core', route: '/components/agent-core'),
          DocsLink(label: 'Agent Console', route: '/components/agent-console'),
          DocsLink(
            label: 'Agent Slash Palette',
            route: '/components/agent_slash_palette',
          ),
          DocsLink(label: 'Button', route: '/components/button'),
          DocsLink(label: 'Icon', route: '/components/icon'),
          DocsLink(label: 'Input', route: '/components/input'),
          DocsLink(
            label: 'Machine Surface',
            route: '/components/machine_surface',
          ),
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
        label: 'theme.card / theme.border',
        value: 'the shell, at rest',
        description: 'ElMachineSurface\'s fill and rim.',
      ),
      DocsInstallFact(
        label: 'theme.agent',
        value: 'the shell, while dragging',
        description:
            'Both fill (8% alpha) and border (solid) swap to theme.agent — '
            'twMerge drops the resting pair outright rather than layering '
            'on top of them.',
      ),
      DocsInstallFact(
        label: 'theme.foreground / theme.mutedForeground',
        value: 'input text and placeholder',
        description: 'The EditableText\'s cursor and text colour, and the '
            'placeholder\'s own ink.',
      ),
      DocsInstallFact(
        label: 'theme.primary',
        value: 'text selection',
        description: 'ElFieldSurface.selectionAlpha over theme.primary.',
      ),
      DocsInstallFact(
        label: 'theme.destructiveInk',
        value: 'the refusal and dictation-error lines',
        description: 'Both share the same _Message widget and colour.',
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
