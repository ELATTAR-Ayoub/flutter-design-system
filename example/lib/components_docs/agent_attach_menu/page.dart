/// Public documentation page for the `agent-attach-menu` component.
///
/// `agent_attach_menu.dart` declares one widget, [AgentAttachMenu]. API
/// Reference gives it one table for its constructor parameters and a second
/// for its own public statics.
///
/// **Not built on the arrow-key-navigable menu.** The source's own library
/// doc says why: the reference overrides `DropdownMenuItem` with a two-line
/// child the stock [MenuItem] has no slot for, so this file composes
/// [MenuSurface] and [MenuPointerDown] over [Popover] directly rather
/// than [DropdownMenu]. That choice has a real consequence this page does
/// not skip: [MenuContent] — the class that actually implements
/// ArrowDown/ArrowUp/Home/End/Enter navigation in `menu.dart` — is never
/// used here, and neither `_AttachMenuState` nor `_MenuRow` binds a
/// [FocusNode] or a [Focus.onKeyEvent] of its own. [Popover] does supply
/// Escape, but only "when focus is already inside the popup" (its own class
/// doc) — and nothing in this menu ever puts focus there. The Keyboard
/// disclosure below documents exactly that reachable state, rather than the
/// conventional shape a menu is assumed to have.
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
      'running a skill, built on MenuSurface and MenuPointerDown over '
      'Popover rather than the arrow-key-navigable DropdownMenu.',
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'Both rows the composer can offer: a Photos & files row (when '
          'onPickFiles is given) and the skill-group commands from '
          'commands, separated by one hairline. Only AgentCommand values '
          'whose group is skill ever reach this menu — see Skills only '
          'below.',
      specimen: _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
      minHeight: space(64),
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'agent-attach-menu has a real registry manifest, `elattar add '
          'agent-attach-menu` installs lib/src/components/ui/'
          'agent_attach_menu.dart and resolves all seven '
          'registryDependencies automatically. The Manual tab is for a '
          'project not using the CLI.',
      command: agentAttachMenuDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/agent_attach_menu.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/ui/agent_attach_menu.dart's generated "
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
              'Add the export line so AgentAttachMenu is reachable the '
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
      minHeight: space(64),
    ),
    ShowcaseSection(
      id: 'disabled',
      title: 'Disabled',
      description:
          'disabled: true does two things at once: MenuPointerDown stops '
          'calling onPointerDown at all (enabled: !disabled), and the '
          'trigger Button itself receives onPressed: null, which is '
          "Button's own disabled switch — 45% opacity, no pointer "
          'events, on the same clock every disabled button uses.',
      specimen: _DisabledSpecimen(),
      code: _disabledCode,
      label: 'Disabled specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every constructor parameter AgentAttachMenu declares, plus its '
          'own public statics. AgentCommand and AgentCommandGroup — the '
          'type commands is built from — are documented on the Agent Slash '
          'Palette page instead, since this file imports them rather than '
          'declaring them.',
      children: const <DocsTocEntry>[
        DocsTocEntry(title: 'AgentAttachMenu', anchor: 'api-elagentattachmenu'),
        DocsTocEntry(
          title: 'AgentAttachMenu static values',
          anchor: 'api-elagentattachmenu-static',
        ),
      ],
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'Read off AgentAttachMenu.build and _AttachMenuState, not '
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
      title: agentAttachMenuDoc.title,
      description: agentAttachMenuDoc.description,
    ),
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Components'),
      BreadcrumbEntry.page('Agent Attach Menu'),
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

const List<AgentCommand> _menuCommands = <AgentCommand>[
  AgentCommand(
    id: 'find-comps',
    label: 'Find comps',
    hint: 'Find comparable sold listings for this card',
    group: AgentCommandGroup.skill,
    icon: Lucide.search,
  ),
  AgentCommand(
    id: 'summarize',
    label: 'Summarize',
    hint: 'Summarize this conversation',
    group: AgentCommandGroup.skill,
    icon: Lucide.sparkles,
  ),
  AgentCommand(
    id: 'clear',
    label: 'Clear',
    hint: 'Clear this conversation — never reaches this menu',
    group: AgentCommandGroup.command,
    icon: Lucide.trash2,
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
    final ThemeTokens theme = ThemeScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        AgentAttachMenu(
          key: const ValueKey<String>('agent-attach-menu-preview:trigger'),
          onPickFiles: () =>
              setState(() => _status = 'Opened the file picker.'),
          commands: _menuCommands,
          onRunCommand: (AgentCommand command) =>
              setState(() => _status = 'Ran: ${command.label}'),
        ),
        SizedBox(height: space(3)),
        StyledText(
          _status,
          TextStyles.small,
          key: const ValueKey<String>('agent-attach-menu-preview:status'),
          color: theme.mutedForeground,
        ),
      ],
    );
  }
}

const String _previewCode = '''
AgentAttachMenu(
  onPickFiles: () => openFilePicker(),
  commands: commands, // only group == skill renders
  onRunCommand: (command) => runCommand(command),
)''';

class _SkillsOnlySpecimen extends StatelessWidget {
  const _SkillsOnlySpecimen();

  @override
  Widget build(BuildContext context) => AgentAttachMenu(
    key: const ValueKey<String>('agent-attach-menu-example:skills-only'),
    commands: _menuCommands,
    onRunCommand: (AgentCommand _) {},
  );
}

const String _skillsOnlyCode = '''
AgentAttachMenu(
  // onPickFiles omitted — no Photos & files row, no separator.
  commands: commands,
  onRunCommand: (command) => runCommand(command),
)''';

class _DisabledSpecimen extends StatelessWidget {
  const _DisabledSpecimen();

  @override
  Widget build(BuildContext context) => AgentAttachMenu(
    key: const ValueKey<String>('agent-attach-menu-example:disabled'),
    onPickFiles: () {},
    commands: _menuCommands,
    onRunCommand: (AgentCommand _) {},
    disabled: true,
  );
}

const String _disabledCode = '''
AgentAttachMenu(
  onPickFiles: () => openFilePicker(),
  commands: commands,
  onRunCommand: (command) => runCommand(command),
  disabled: true,
)''';

/* ── Disclosure content ─────────────────────────────────────────────────── */

const String _usageCode = '''
import 'package:elattar_design_system/elattar_design_system.dart';

AgentAttachMenu(
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
        child: DocsApiTable(title: 'AgentAttachMenu', facts: _attachMenuFacts),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elagentattachmenu-static',
        child: DocsApiTable(
          title: 'AgentAttachMenu static values',
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
    type: 'List<AgentCommand>?',
    description:
        "Optional. The full list the composer holds — this widget's own "
        '_skills getter filters it down to group == skill and ignores '
        'everything else: browser commands never reach this menu.',
  ),
  DocsApiFact(
    name: 'onRunCommand',
    type: 'ValueChanged<AgentCommand>',
    description:
        'Required. Fires with the selected skill after the menu '
        'closes.',
  ),
  DocsApiFact(
    name: 'disabled',
    type: 'bool',
    description:
        'Optional. Defaults to false. Stops the trigger from opening and '
        'renders the underlying Button in its own disabled paint.',
  ),
];

const List<DocsApiFact> _attachMenuStaticFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'triggerSize',
    type: 'ButtonSize',
    description: 'ButtonSize.iconSm — the trigger is a plain icon-only Button.',
  ),
  DocsApiFact(
    name: 'width',
    type: 'double',
    description:
        'space(80) — 320. Fixed content width, unrelated to the '
        'viewport.',
  ),
  DocsApiFact(
    name: 'maxHeight',
    type: 'double',
    description:
        'space(96) — 384. The scrolling content never grows past '
        'this.',
  ),
  DocsApiFact(
    name: 'rowInsets',
    type: 'EdgeInsets',
    description:
        'symmetric(horizontal: space(3), vertical: space(2)) on a row.',
  ),
  DocsApiFact(
    name: 'rowGap',
    type: 'double',
    description: "space(3) — 12. Between a row's glyph and its text.",
  ),
  DocsApiFact(
    name: 'rowRadius',
    type: 'double',
    description:
        'Radii.md — 10. The highlighted-row fill\'s corner '
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
  DocsApiFact(name: 'glyphSize', type: 'double', description: 'space(4) — 16.'),
];

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Trigger: a plain Button with label: "Add files or use a '
            'skill", which is its accessible name (the plus icon carries '
            'no name of its own).',
        'Trigger also wraps MenuTriggerScope(open: _isOpen), the same '
            "scope DropdownMenu's own trigger reads — a caller building "
            'a custom trigger can read MenuTriggerScope.openOf to '
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
      _bullets(ThemeScope.of(context), <String>[
        'The trigger is a real Button, so it takes the same keyboard as '
            'every other button on this system: Tab reaches it, Enter / '
            'NumpadEnter / Space activate it — see the Button page\'s own '
            'Keyboard disclosure.',
        'Nothing past the trigger is reachable by keyboard. Neither '
            '_AttachMenuState nor _MenuRow declares a Focus, a FocusNode, '
            'or an onKeyEvent: a row answers MouseRegion and a bare '
            'GestureDetector only.',
        'DRIFT, and worth stating plainly: this menu is not built on '
            '[MenuContent] (menu.dart\'s own ArrowDown/ArrowUp/Home/End/'
            'Enter handler) the way DropdownMenu is — the source\'s own '
            'library note explains why (the two-line row the stock '
            '[MenuItem] has no slot for) — so none of that navigation '
            'exists here.',
        'Escape is not wired either, in practice. Popover does supply '
            'an Escape handler, but its own class doc is explicit: "the '
            'Escape key when focus is already inside the popup" — and '
            'because no row and no trigger substitute ever moves focus '
            'into the popup content, that Focus node (canRequestFocus: '
            'false) never receives a key event to answer. The menu still '
            'closes on a tap anywhere outside it, through Popover\'s own '
            'modal barrier — that dismissal is a pointer path, not a '
            'keyboard one.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'No breakpoint branching anywhere in agent_attach_menu.dart: '
            'BuildContext width is never read for a layout decision.',
        'width (320) and maxHeight (384) are fixed space() values: the '
            "content's own box does not grow or shrink with the "
            'viewport, though Popover\'s own collision flip repositions '
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
      _bullets(ThemeScope.of(context), <String>[
        'File: lib/src/components/ui/agent_attach_menu.dart. No companion '
            'parts.',
        'Flutter imports: package:flutter/gestures.dart '
            '(PointerEnterEvent, PointerExitEvent), '
            'package:flutter/widgets.dart.',
        'Foundation imports: colors.dart, spacing.dart (space()), '
            'theme.dart, typography.dart, theme_scope.dart.',
        'Component imports: agent_slash_palette.dart (AgentCommand, '
            'AgentCommandGroup — the type this file consumes, never '
            'declares), button.dart (Button), dropdown_menu.dart '
            '(DropdownMenu.sideOffset only — not the widget itself), '
            'icon.dart, icon_paths.g.dart, menu.dart (MenuSurface, '
            'MenuPointerDown, MenuTriggerScope, MenuMotion, '
            'Menu.contentPadding — never MenuContent), popover.dart '
            '(Popover and friends).',
        'registryDependencies, resolved automatically by `elattar add '
            'agent-attach-menu`: agent-slash-palette, button, '
            'dropdown-menu, icon, menu, popover, source-foundation — '
            'copied verbatim from '
            'registry/components/agent-attach-menu.json.',
        'semanticDependencies (the manifest\'s own, narrower field): '
            'agent-slash-palette, button, dropdown-menu, icon, menu, '
            'popover.',
      ]),
      SizedBox(height: space(2)),
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: LayoutWidths.prose),
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
            DocsLink(label: 'Menu', route: '/components/menu'),
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
      _bullets(ThemeScope.of(context), <String>[
        'Every colour is read live off ThemeScope.of(context) at build time: '
            'theme.border (the separator rule), theme.accent (a '
            'highlighted row\'s fill), theme.foreground (a row\'s title), '
            'theme.mutedForeground (the "Skills" heading and a row\'s '
            'hint), theme.agentAccent (every glyph). Flipping '
            'ThemeController re-resolves every one on the next frame.',
        'The surface itself (MenuSurface, the popup\'s fill/border/'
            'shadow) and the popover\'s own animation are both borrowed '
            'wholesale from menu.dart / popover.dart — nothing here paints '
            'its own box.',
        'No override hatch: this widget takes no colour, shape, or '
            'surface parameter of its own. Restyling it means forking the '
            'file.',
      ]);
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

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Nothing to offer',
    treatment:
        'onPickFiles == null && skills.isEmpty short-circuits to '
        'SizedBox.shrink() before Popover is even built.',
    userSignal:
        'No plus renders at all — a caller closes off attachments '
        'entirely by handing this widget nothing to do.',
  ),
  DocsStateFact(
    state: 'Closed',
    treatment: '_open is false: only the trigger Button renders.',
    userSignal: 'The default resting state.',
  ),
  DocsStateFact(
    state: 'Open',
    treatment:
        '_open is true (and disabled is false): Popover mounts '
        'MenuSurface\'s content, animated in on Popover\'s own '
        'enter transition.',
    userSignal: 'The menu shown in Preview above.',
  ),
  DocsStateFact(
    state: 'Row highlighted',
    treatment:
        '_MenuRowState._highlighted, from MouseRegion.onEnter / '
        'onExit alone: theme.accent behind the row, no transition on it '
        'at all — measured, and reproduced as an instant fill rather than '
        'an animated one.',
    userSignal: 'Hovering a row.',
  ),
  DocsStateFact(
    state: 'Disabled',
    treatment:
        'MenuPointerDown.enabled is !disabled (the menu cannot '
        'be toggled open) and the trigger Button itself gets onPressed: '
        'null, so it also paints 45% opacity and ignores pointer events.',
    userSignal: 'See Disabled above.',
  ),
];
