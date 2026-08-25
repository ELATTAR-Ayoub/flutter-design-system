/// Public documentation page for the `agent-attach-menu` component.
///
/// `agent_attach_menu.dart` declares one widget, [ElAgentAttachMenu]. API
/// Reference gives it one table for its constructor parameters and a second
/// for its own public statics.
///
/// **Not built on the arrow-key-navigable menu.** The source's own library
/// doc says why: the reference overrides `DropdownMenuItem` with a two-line
/// child the stock [ElMenuItem] has no slot for, so this file composes
/// [ElMenuSurface] and [ElMenuPointerDown] over [ElPopover] directly rather
/// than [ElDropdownMenu]. That choice has a real consequence this page does
/// not skip: [ElMenuContent] — the class that actually implements
/// ArrowDown/ArrowUp/Home/End/Enter navigation in `menu.dart` — is never
/// used here, and neither `_AttachMenuState` nor `_MenuRow` binds a
/// [FocusNode] or a [Focus.onKeyEvent] of its own. [ElPopover] does supply
/// Escape, but only "when focus is already inside the popup" (its own class
/// doc) — and nothing in this menu ever puts focus there. The Keyboard
/// disclosure below documents exactly that reachable state, rather than the
/// conventional shape a menu is assumed to have.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/component_doc_page.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../docs/docs_section.dart' show DocsAnchor;
import 'meta.dart';

final ComponentDocSpec agentAttachMenuDocSpec = ComponentDocSpec(
  name: 'agent_attach_menu',
  title: 'Agent Attach Menu',
  description:
      'The plus beside the composer: one control for picking a file or '
      'running a skill, built on ElMenuSurface and ElMenuPointerDown over '
      'ElPopover rather than the arrow-key-navigable ElDropdownMenu.',
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'Both rows the composer can offer: a Photos & files row (when '
          'onPickFiles is given) and the skill-group commands from '
          'commands, separated by one hairline. Only ElAgentCommand values '
          'whose group is skill ever reach this menu — see Skills only '
          'below.',
      specimen: _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
      minHeight: el(64),
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'agent-attach-menu has a real registry manifest, `elattar add '
          'agent-attach-menu` installs lib/src/components/'
          'agent_attach_menu.dart and resolves all seven '
          'registryDependencies automatically. The Manual tab is for a '
          'project not using the CLI.',
      command: agentAttachMenuDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/agent_attach_menu.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/agent_attach_menu.dart's generated "
              '@ui/agent_attach_menu.dart payload into components/ui.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated agent_attach_menu source here when '
              'using manual mode.',
        ),
        DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so ElAgentAttachMenu is reachable the '
              'same way the CLI path already makes it.',
          code: "export 'agent_attach_menu.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'The smallest correct import and construction. The widget mounts '
          'nothing at all (SizedBox.shrink()) when onPickFiles is null and '
          'commands has no skill-group entries — see States below.',
      code: _usageCode,
    ),
    ShowcaseSection(
      id: 'skills-only',
      title: 'Skills only',
      description:
          'onPickFiles omitted: no Photos & files row, and no separator '
          'either — `if (hasFiles && hasSkills)` is false, so the rule '
          'never mounts. commands is still the full mixed list; only its '
          'skill-group entries render.',
      specimen: _SkillsOnlySpecimen(),
      code: _skillsOnlyCode,
      label: 'Skills only specimen view',
      minHeight: el(64),
    ),
    ShowcaseSection(
      id: 'disabled',
      title: 'Disabled',
      description:
          'disabled: true does two things at once: ElMenuPointerDown stops '
          'calling onPointerDown at all (enabled: !disabled), and the '
          'trigger ElButton itself receives onPressed: null, which is '
          "ElButton's own disabled switch — 45% opacity, no pointer "
          'events, on the same clock every disabled button uses.',
      specimen: _DisabledSpecimen(),
      code: _disabledCode,
      label: 'Disabled specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every constructor parameter ElAgentAttachMenu declares, plus its '
          'own public statics. ElAgentCommand and ElAgentCommandGroup — the '
          'type commands is built from — are documented on the Agent Slash '
          'Palette page instead, since this file imports them rather than '
          'declaring them.',
      children: const <DocsTocEntry>[
        DocsTocEntry(
          title: 'ElAgentAttachMenu',
          anchor: 'api-elagentattachmenu',
        ),
        DocsTocEntry(
          title: 'ElAgentAttachMenu static values',
          anchor: 'api-elagentattachmenu-static',
        ),
      ],
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'Read off ElAgentAttachMenu.build and _AttachMenuState, not '
          'inferred.',
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
            value: agentAttachMenuDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/agent_attach_menu_test.dart',
            description:
                'Covers this page: the article mounts, the full API table, '
                'and every live specimen this page claims to show.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/agent_attach_menu/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class AgentAttachMenuDocPage extends StatelessWidget {
  const AgentAttachMenuDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: agentAttachMenuDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / AGENT',
      title: agentAttachMenuDoc.title,
      description: agentAttachMenuDoc.description,
    ),
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Components'),
      ElBreadcrumbEntry.page('Agent Attach Menu'),
    ],
    toc: agentAttachMenuDocSpec.toc,
    previous: null,
    next: null,
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('agent-attach-menu-doc-article'),
      child: ComponentDocPage(spec: agentAttachMenuDocSpec, header: false),
    ),
  );
}

/* ── Sample data ─────────────────────────────────────────────────────────── */

const List<ElAgentCommand> _menuCommands = <ElAgentCommand>[
  ElAgentCommand(
    id: 'find-comps',
    label: 'Find comps',
    hint: 'Find comparable sold listings for this card',
    group: ElAgentCommandGroup.skill,
    icon: ElLucide.search,
  ),
  ElAgentCommand(
    id: 'summarize',
    label: 'Summarize',
    hint: 'Summarize this conversation',
    group: ElAgentCommandGroup.skill,
    icon: ElLucide.sparkles,
  ),
  ElAgentCommand(
    id: 'clear',
    label: 'Clear',
    hint: 'Clear this conversation — never reaches this menu',
    group: ElAgentCommandGroup.command,
    icon: ElLucide.trash2,
  ),
];

/* ── Showcase specimens ─────────────────────────────────────────────────── */

class _PreviewSpecimen extends StatefulWidget {
  const _PreviewSpecimen();

  @override
  State<_PreviewSpecimen> createState() => _PreviewSpecimenState();
}

class _PreviewSpecimenState extends State<_PreviewSpecimen> {
  String _status = 'Nothing run yet.';

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ElAgentAttachMenu(
          key: const ValueKey<String>('agent-attach-menu-preview:trigger'),
          onPickFiles: () =>
              setState(() => _status = 'Opened the file picker.'),
          commands: _menuCommands,
          onRunCommand: (ElAgentCommand command) =>
              setState(() => _status = 'Ran: ${command.label}'),
        ),
        SizedBox(height: el(3)),
        ElText(
          _status,
          ElType.small,
          key: const ValueKey<String>('agent-attach-menu-preview:status'),
          color: theme.mutedForeground,
        ),
      ],
    );
  }
}

const String _previewCode = '''
ElAgentAttachMenu(
  onPickFiles: () => openFilePicker(),
  commands: commands, // only group == skill renders
  onRunCommand: (command) => runCommand(command),
)''';

class _SkillsOnlySpecimen extends StatelessWidget {
  const _SkillsOnlySpecimen();

  @override
  Widget build(BuildContext context) => ElAgentAttachMenu(
    key: const ValueKey<String>('agent-attach-menu-example:skills-only'),
    commands: _menuCommands,
    onRunCommand: (ElAgentCommand _) {},
  );
}

const String _skillsOnlyCode = '''
ElAgentAttachMenu(
  // onPickFiles omitted — no Photos & files row, no separator.
  commands: commands,
  onRunCommand: (command) => runCommand(command),
)''';

class _DisabledSpecimen extends StatelessWidget {
  const _DisabledSpecimen();

  @override
  Widget build(BuildContext context) => ElAgentAttachMenu(
    key: const ValueKey<String>('agent-attach-menu-example:disabled'),
    onPickFiles: () {},
    commands: _menuCommands,
    onRunCommand: (ElAgentCommand _) {},
    disabled: true,
  );
}

const String _disabledCode = '''
ElAgentAttachMenu(
  onPickFiles: () => openFilePicker(),
  commands: commands,
  onRunCommand: (command) => runCommand(command),
  disabled: true,
)''';

/* ── Disclosure content ─────────────────────────────────────────────────── */

const String _usageCode = '''
import 'package:elattar_design_system/elattar_design_system.dart';

ElAgentAttachMenu(
  onPickFiles: () => openFilePicker(),
  commands: commands,
  onRunCommand: (command) => runCommand(command),
)''';

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsAnchor(
        id: 'api-elagentattachmenu',
        child: DocsApiTable(
          title: 'ElAgentAttachMenu',
          facts: _attachMenuFacts,
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elagentattachmenu-static',
        child: DocsApiTable(
          title: 'ElAgentAttachMenu static values',
          facts: _attachMenuStaticFacts,
        ),
      ),
    ],
  );
}

const List<DocsApiFact> _attachMenuFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'onPickFiles',
    type: 'VoidCallback?',
    description:
        'Optional. Opens the file picker. Omitted when attachments are '
        'off — no Photos & files row renders, and no separator either.',
  ),
  DocsApiFact(
    name: 'commands',
    type: 'List<ElAgentCommand>?',
    description:
        "Optional. The full list the composer holds — this widget's own "
        '_skills getter filters it down to group == skill and ignores '
        'everything else: browser commands never reach this menu.',
  ),
  DocsApiFact(
    name: 'onRunCommand',
    type: 'ValueChanged<ElAgentCommand>',
    description: 'Required. Fires with the selected skill after the menu '
        'closes.',
  ),
  DocsApiFact(
    name: 'disabled',
    type: 'bool',
    description:
        'Optional. Defaults to false. Stops the trigger from opening and '
        'renders the underlying ElButton in its own disabled paint.',
  ),
];

const List<DocsApiFact> _attachMenuStaticFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'triggerSize',
    type: 'ElButtonSize',
    description:
        'ElButtonSize.iconSm — the trigger is a plain icon-only ElButton.',
  ),
  DocsApiFact(
    name: 'width',
    type: 'double',
    description: 'el(80) — 320. Fixed content width, unrelated to the '
        'viewport.',
  ),
  DocsApiFact(
    name: 'maxHeight',
    type: 'double',
    description: 'el(96) — 384. The scrolling content never grows past '
        'this.',
  ),
  DocsApiFact(
    name: 'rowInsets',
    type: 'EdgeInsets',
    description: 'symmetric(horizontal: el(3), vertical: el(2)) on a row.',
  ),
  DocsApiFact(
    name: 'rowGap',
    type: 'double',
    description: "el(3) — 12. Between a row's glyph and its text.",
  ),
  DocsApiFact(
    name: 'rowRadius',
    type: 'double',
    description: 'ElRadii.md — 10. The highlighted-row fill\'s corner '
        'radius.',
  ),
  DocsApiFact(
    name: 'rowLinesHaveNoGap',
    type: 'bool',
    description:
        "true, always. DRIFT, reproduced: the reference's two-line child "
        'writes flex-col gap-1 with no flex, so gap-1 never applies and '
        "the title and hint lines sit with no gap between them — unlike "
        'the slash palette\'s equivalent, which does have the flex and '
        'does show the gap.',
  ),
  DocsApiFact(
    name: 'glyphSize',
    type: 'double',
    description: 'el(4) — 16.',
  ),
];

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'Trigger: a plain ElButton with label: "Add files or use a '
            'skill", which is its accessible name (the plus icon carries '
            'no name of its own).',
        'Trigger also wraps ElMenuTriggerScope(open: _isOpen), the same '
            "scope ElDropdownMenu's own trigger reads — a caller building "
            'a custom trigger can read ElMenuTriggerScope.openOf to '
            'reflect aria-expanded, and suppressPressScale: true cancels '
            'the press-scale animation the way a real aria-haspopup '
            'trigger does.',
        'Each row wraps Semantics(button: true) and nothing else: no '
            'selected, no expanded, no hint. A screen reader hears "Find '
            'comps, button", not which row (if any) is highlighted.',
        'Highlight is pointer-only: _MenuRowState tracks _highlighted '
            'from MouseRegion.onEnter/onExit alone — there is no keyboard '
            'equivalent, because nothing in a row can receive focus. See '
            'Keyboard below.',
        'The whole widget renders SizedBox.shrink() when onPickFiles is '
            'null and commands has no skill-group entries: nothing is '
            'mounted for assistive tech to find, matching there being '
            'nothing to offer.',
      ]);
}

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'The trigger is a real ElButton, so it takes the same keyboard as '
            'every other button on this system: Tab reaches it, Enter / '
            'NumpadEnter / Space activate it — see the Button page\'s own '
            'Keyboard disclosure.',
        'Nothing past the trigger is reachable by keyboard. Neither '
            '_AttachMenuState nor _MenuRow declares a Focus, a FocusNode, '
            'or an onKeyEvent: a row answers MouseRegion and a bare '
            'GestureDetector only.',
        'DRIFT, and worth stating plainly: this menu is not built on '
            '[ElMenuContent] (menu.dart\'s own ArrowDown/ArrowUp/Home/End/'
            'Enter handler) the way ElDropdownMenu is — the source\'s own '
            'library note explains why (the two-line row the stock '
            '[ElMenuItem] has no slot for) — so none of that navigation '
            'exists here.',
        'Escape is not wired either, in practice. ElPopover does supply '
            'an Escape handler, but its own class doc is explicit: "the '
            'Escape key when focus is already inside the popup" — and '
            'because no row and no trigger substitute ever moves focus '
            'into the popup content, that Focus node (canRequestFocus: '
            'false) never receives a key event to answer. The menu still '
            'closes on a tap anywhere outside it, through ElPopover\'s own '
            'modal barrier — that dismissal is a pointer path, not a '
            'keyboard one.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'No breakpoint branching anywhere in agent_attach_menu.dart: '
            'BuildContext width is never read for a layout decision.',
        'width (320) and maxHeight (384) are fixed el() values: the '
            "content's own box does not grow or shrink with the "
            'viewport, though ElPopover\'s own collision flip repositions '
            'it — never resizes it — to stay on screen.',
        'side: top, align: start is fixed at the call site: this menu '
            'always opens upward and left-aligned to its trigger, on '
            'every viewport, because the composer it sits above is '
            'assumed to be near the bottom of the screen.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      _bullets(ElTheme.of(context), <String>[
        'File: lib/src/components/agent_attach_menu.dart. No companion '
            'parts.',
        'Flutter imports: package:flutter/gestures.dart '
            '(PointerEnterEvent, PointerExitEvent), '
            'package:flutter/widgets.dart.',
        'Foundation imports: colors.dart, spacing.dart (el()), '
            'theme.dart, typography.dart, theme_scope.dart.',
        'Component imports: agent_slash_palette.dart (ElAgentCommand, '
            'ElAgentCommandGroup — the type this file consumes, never '
            'declares), button.dart (ElButton), dropdown_menu.dart '
            '(ElDropdownMenu.sideOffset only — not the widget itself), '
            'icon.dart, icon_paths.g.dart, menu.dart (ElMenuSurface, '
            'ElMenuPointerDown, ElMenuTriggerScope, ElMenuMotion, '
            'ElMenu.contentPadding — never ElMenuContent), popover.dart '
            '(ElPopover and friends).',
        'registryDependencies, resolved automatically by `elattar add '
            'agent-attach-menu`: agent-slash-palette, button, '
            'dropdown-menu, icon, menu, popover, source-foundation — '
            'copied verbatim from '
            'registry/components/agent-attach-menu.json.',
        'semanticDependencies (the manifest\'s own, narrower field): '
            'agent-slash-palette, button, dropdown-menu, icon, menu, '
            'popover.',
      ]),
      SizedBox(height: el(2)),
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: ElWidths.prose),
        child: DocsLinkRow(
          links: <DocsLink>[
            DocsLink(
              label: 'Agent Slash Palette',
              route: '/components/agent_slash_palette',
            ),
            DocsLink(label: 'Button', route: '/components/button'),
            DocsLink(
              label: 'Dropdown Menu',
              route: '/components/dropdown-menu',
            ),
            DocsLink(label: 'Icon', route: '/components/icon'),
            DocsLink(label: 'Popover', route: '/components/popover'),
          ],
        ),
      ),
    ],
  );
}

class _ThemingContent extends StatelessWidget {
  const _ThemingContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'Every colour is read live off ElTheme.of(context) at build time: '
            'theme.border (the separator rule), theme.accent (a '
            'highlighted row\'s fill), theme.foreground (a row\'s title), '
            'theme.mutedForeground (the "Skills" heading and a row\'s '
            'hint), theme.agent (every glyph). Flipping '
            'ElThemeController re-resolves every one on the next frame.',
        'The surface itself (ElMenuSurface, the popup\'s fill/border/'
            'shadow) and the popover\'s own animation are both borrowed '
            'wholesale from menu.dart / popover.dart — nothing here paints '
            'its own box.',
        'No override hatch: this widget takes no colour, shape, or '
            'surface parameter of its own. Restyling it means forking the '
            'file.',
      ]);
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

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Nothing to offer',
    treatment: 'onPickFiles == null && skills.isEmpty short-circuits to '
        'SizedBox.shrink() before ElPopover is even built.',
    userSignal: 'No plus renders at all — a caller closes off attachments '
        'entirely by handing this widget nothing to do.',
  ),
  DocsStateFact(
    state: 'Closed',
    treatment: '_open is false: only the trigger ElButton renders.',
    userSignal: 'The default resting state.',
  ),
  DocsStateFact(
    state: 'Open',
    treatment: '_open is true (and disabled is false): ElPopover mounts '
        'ElMenuSurface\'s content, animated in on ElPopover\'s own '
        'enter transition.',
    userSignal: 'The menu shown in Preview above.',
  ),
  DocsStateFact(
    state: 'Row highlighted',
    treatment: '_MenuRowState._highlighted, from MouseRegion.onEnter / '
        'onExit alone: theme.accent behind the row, no transition on it '
        'at all — measured, and reproduced as an instant fill rather than '
        'an animated one.',
    userSignal: 'Hovering a row.',
  ),
  DocsStateFact(
    state: 'Disabled',
    treatment: 'ElMenuPointerDown.enabled is !disabled (the menu cannot '
        'be toggled open) and the trigger ElButton itself gets onPressed: '
        'null, so it also paints 45% opacity and ignores pointer events.',
    userSignal: 'See Disabled above.',
  ),
];
