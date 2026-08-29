/// Public documentation page for the `agent-slash-palette` component.
///
/// `agent_slash_palette.dart` declares one widget, [AgentSlashPalette], one
/// data class, [AgentCommand], one enum, [AgentCommandGroup], and two
/// top-level functions, [slashQuery] and [filterCommands]. API Reference
/// gives each its own [DocsApiTable], plus a fifth table for the widget's own
/// public statics, with a rail sub-anchor per table.
///
/// **The widget is stateless on purpose.** Its own class doc says so
/// directly: "the open query, the matches and the highlight all belong to
/// the composer, which is the one place the keyboard is routed." Nothing in
/// `agent_slash_palette.dart` reads a [Focus] node or a [LogicalKeyboardKey]
/// — [activeIndex], [AgentSlashPalette.onSelect] and
/// [AgentSlashPalette.onHover] are the whole surface a caller drives. The
/// Keyboard disclosure below says exactly that, rather than assuming the
/// conventional "arrow keys move, Enter selects" shape a menu usually gets:
/// this file implements none of it, because the composer (out of scope for
/// this page) does.
///
/// The Filtering section below is the one live specimen built on
/// [slashQuery] and [filterCommands] rather than on the widget directly:
/// both are plain functions a composer calls to decide what list to hand the
/// palette, and a text field wired to them is the honest way to show what
/// they actually do.
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

final ComponentDocSpec agentSlashPaletteDocSpec = ComponentDocSpec(
  name: 'agent_slash_palette',
  title: 'Agent Slash Palette',
  description:
      'The `/` menu: a stateless list of skills and browser commands, '
      'grouped and highlighted by whatever index its caller — the '
      'composer — hands it.',
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'Skills first, then Commands, each group heading printed only '
          'when it has a row: the same `_groups` filter the source runs. '
          'Hover a row to move the highlight, tap one to select it — both '
          'callbacks a real composer would wire to its own keyboard '
          'handling instead.',
      specimen: _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'agent-slash-palette has a real registry manifest, `elattar add '
          'agent-slash-palette` installs lib/src/components/ui/'
          'agent_slash_palette.dart and resolves both registryDependencies '
          'automatically. The Manual tab is for a project not using the '
          'CLI.',
      command: agentSlashPaletteDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/agent_slash_palette.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/ui/agent_slash_palette.dart's "
              'generated @ui/agent_slash_palette.dart payload into '
              'components/ui.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated agent_slash_palette source here when '
              'using manual mode.',
        ),
        DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so AgentSlashPalette, AgentCommand '
              'and AgentCommandGroup are reachable the same way the CLI '
              'path already makes them.',
          code: "export 'agent_slash_palette.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'The smallest correct import and construction. commands is '
          'already filtered by the caller; the palette does not filter or '
          'sort what it is handed.',
      code: _usageCode,
    ),
    ShowcaseSection(
      id: 'groups',
      title: 'Groups',
      description:
          "`_groups` builds `[Skills, Commands].filter(g => g.items.length)` "
          '— a group with nothing in it prints no heading at all, not an '
          'empty one. Left: only skill-group commands, one heading. Right: '
          'only command-group commands, the other heading. Neither shows '
          'the group it has none of.',
      specimen: _GroupsSpecimen(),
      code: _groupsCode,
      label: 'Groups specimen view',
    ),
    ShowcaseSection(
      id: 'active-row',
      title: 'Active row',
      description:
          'activeIndex counts rows across both groups in display order, not '
          'per group: index 2 here is the third row down regardless of '
          'which group it falls in. A real caller moves this number on '
          'ArrowDown/ArrowUp; this specimen sets it once to show the paint.',
      specimen: _ActiveRowSpecimen(),
      code: _activeRowCode,
      label: 'Active row specimen view',
      minHeight: space(64),
    ),
    ShowcaseSection(
      id: 'filtering',
      title: 'Filtering',
      description:
          'slashQuery(value, caret) returns null the instant the field '
          'does not start with "/", so typing "and/or" never opens '
          'anything; filterCommands then keeps only the commands whose id '
          'or label contains the typed substring, case-insensitively. '
          'Clear the field down to just "/" to see the unfiltered list '
          'again.',
      specimen: _FilteringSpecimen(),
      code: _filteringCode,
      label: 'Filtering specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every constructor parameter AgentSlashPalette declares, its '
          'own public statics, every AgentCommand field, the '
          'AgentCommandGroup values, and the two top-level functions the '
          'file exports.',
      children: const <DocsTocEntry>[
        DocsTocEntry(
          title: 'AgentSlashPalette',
          anchor: 'api-elagentslashpalette',
        ),
        DocsTocEntry(
          title: 'AgentSlashPalette static values',
          anchor: 'api-elagentslashpalette-static',
        ),
        DocsTocEntry(title: 'AgentCommand', anchor: 'api-elagentcommand'),
        DocsTocEntry(
          title: 'AgentCommandGroup',
          anchor: 'api-elagentcommandgroup',
        ),
        DocsTocEntry(
          title: 'Top-level functions',
          anchor: 'api-top-level-functions',
        ),
      ],
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'Read off AgentSlashPalette.build and _PaletteBoxState, not '
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
            value: agentSlashPaletteDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/agent_slash_palette_test.dart',
            description:
                'Covers this page: the article mounts, the full API table, '
                'and every live specimen this page claims to show.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/agent_slash_palette/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class AgentSlashPaletteDocPage extends StatelessWidget {
  const AgentSlashPaletteDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: agentSlashPaletteDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / AGENT',
      title: agentSlashPaletteDoc.title,
      description: agentSlashPaletteDoc.description,
    ),
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Components'),
      BreadcrumbEntry.page('Agent Slash Palette'),
    ],
    toc: agentSlashPaletteDocSpec.toc,
    previous: null,
    next: null,
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('agent-slash-palette-doc-article'),
      child: ComponentDocPage(spec: agentSlashPaletteDocSpec, header: false),
    ),
  );
}

/* ── Sample data ─────────────────────────────────────────────────────────── */
// One fixed list, reused across specimens so the same four commands appear
// consistently: two skills (the agent's own registered tools) and two
// browser commands (never sent to the agent).

const List<AgentCommand> _paletteCommands = <AgentCommand>[
  AgentCommand(
    id: 'find-comps',
    label: 'find-comps',
    hint: 'Find comparable sold listings for this card',
    group: AgentCommandGroup.skill,
    icon: Lucide.search,
  ),
  AgentCommand(
    id: 'summarize',
    label: 'summarize',
    hint: 'Summarize this conversation',
    group: AgentCommandGroup.skill,
    icon: Lucide.sparkles,
  ),
  AgentCommand(
    id: 'clear',
    label: 'clear',
    hint: 'Clear this conversation',
    group: AgentCommandGroup.command,
    icon: Lucide.trash2,
  ),
  AgentCommand(
    id: 'voice',
    label: 'voice',
    hint: 'Switch to voice mode',
    group: AgentCommandGroup.command,
    icon: Lucide.mic,
  ),
];

/* ── Showcase specimens ─────────────────────────────────────────────────── */

class _PreviewSpecimen extends StatefulWidget {
  const _PreviewSpecimen();

  @override
  State<_PreviewSpecimen> createState() => _PreviewSpecimenState();
}

class _PreviewSpecimenState extends State<_PreviewSpecimen> {
  int _activeIndex = 0;
  String _status = 'Hover or tap a row.';

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          width: space(90),
          child: AgentSlashPalette(
            key: const ValueKey<String>('agent-slash-palette-preview:palette'),
            commands: _paletteCommands,
            activeIndex: _activeIndex,
            onHover: (int index) => setState(() => _activeIndex = index),
            onSelect: (AgentCommand command) =>
                setState(() => _status = 'Selected: /${command.id}'),
          ),
        ),
        SizedBox(height: space(3)),
        StyledText(
          _status,
          TextStyles.small,
          key: const ValueKey<String>('agent-slash-palette-preview:status'),
          color: theme.mutedForeground,
        ),
      ],
    );
  }
}

const String _previewCode = '''
AgentSlashPalette(
  commands: commands, // 2 skills, 2 commands
  activeIndex: activeIndex,
  onHover: (index) => setState(() => activeIndex = index),
  onSelect: (command) => runCommand(command),
)''';

class _GroupsSpecimen extends StatelessWidget {
  const _GroupsSpecimen();

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: space(4),
    runSpacing: space(4),
    children: <Widget>[
      SizedBox(
        width: space(76),
        child: AgentSlashPalette(
          key: const ValueKey<String>(
            'agent-slash-palette-example:skills-only',
          ),
          commands: _paletteCommands
              .where((AgentCommand c) => c.group == AgentCommandGroup.skill)
              .toList(),
          activeIndex: -1,
          onHover: (int _) {},
          onSelect: (AgentCommand _) {},
        ),
      ),
      SizedBox(
        width: space(76),
        child: AgentSlashPalette(
          key: const ValueKey<String>(
            'agent-slash-palette-example:commands-only',
          ),
          commands: _paletteCommands
              .where((AgentCommand c) => c.group == AgentCommandGroup.command)
              .toList(),
          activeIndex: -1,
          onHover: (int _) {},
          onSelect: (AgentCommand _) {},
        ),
      ),
    ],
  );
}

const String _groupsCode = '''
// Only the Skills group has rows: no "Commands" heading prints.
AgentSlashPalette(
  commands: commands.where((c) => c.group == AgentCommandGroup.skill).toList(),
  activeIndex: -1,
  onHover: (index) {},
  onSelect: (command) {},
)''';

class _ActiveRowSpecimen extends StatelessWidget {
  const _ActiveRowSpecimen();

  @override
  Widget build(BuildContext context) => SizedBox(
    width: space(90),
    child: AgentSlashPalette(
      key: const ValueKey<String>('agent-slash-palette-example:active-row'),
      commands: _paletteCommands,
      activeIndex: 2,
      onHover: (int _) {},
      onSelect: (AgentCommand _) {},
    ),
  );
}

const String _activeRowCode = '''
AgentSlashPalette(
  commands: commands,
  activeIndex: 2, // third row down, across both groups
  onHover: (index) {},
  onSelect: (command) {},
)''';

class _FilteringSpecimen extends StatefulWidget {
  const _FilteringSpecimen();

  @override
  State<_FilteringSpecimen> createState() => _FilteringSpecimenState();
}

class _FilteringSpecimenState extends State<_FilteringSpecimen> {
  final TextEditingController _controller = TextEditingController(text: '/');
  int _activeIndex = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String value = _controller.text;
    final String? query = slashQuery(value, value.length);
    final List<AgentCommand> matches = query == null
        ? const <AgentCommand>[]
        : filterCommands(_paletteCommands, query);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          width: space(90),
          child: Input(
            key: const ValueKey<String>(
              'agent-slash-palette-example:filter-input',
            ),
            controller: _controller,
            onChanged: (String _) => setState(() {}),
          ),
        ),
        SizedBox(height: space(3)),
        SizedBox(
          width: space(90),
          child: AgentSlashPalette(
            key: const ValueKey<String>('agent-slash-palette-example:filtered'),
            commands: matches,
            activeIndex: _activeIndex,
            onHover: (int index) => setState(() => _activeIndex = index),
            onSelect: (AgentCommand command) =>
                setState(() => _controller.text = '/${command.id} '),
          ),
        ),
      ],
    );
  }
}

const String _filteringCode = '''
final String? query = slashQuery(fieldValue, caretIndex);
final List<AgentCommand> matches = query == null
    ? const []
    : filterCommands(allCommands, query);

AgentSlashPalette(
  commands: matches,
  activeIndex: activeIndex,
  onHover: (index) => setState(() => activeIndex = index),
  onSelect: (command) => runCommand(command),
)''';

/* ── Disclosure content ─────────────────────────────────────────────────── */

const String _usageCode = '''
import 'package:elattar_design_system/elattar_design_system.dart';

AgentSlashPalette(
  commands: commands,
  activeIndex: activeIndex,
  onSelect: (command) => runCommand(command),
  onHover: (index) => setState(() => activeIndex = index),
)''';

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsAnchor(
        id: 'api-elagentslashpalette',
        child: DocsApiTable(title: 'AgentSlashPalette', facts: _paletteFacts),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elagentslashpalette-static',
        child: DocsApiTable(
          title: 'AgentSlashPalette static values',
          facts: _paletteStaticFacts,
        ),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elagentcommand',
        child: DocsApiTable(title: 'AgentCommand', facts: _commandFacts),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elagentcommandgroup',
        child: DocsApiTable(
          title: 'AgentCommandGroup',
          facts: _commandGroupFacts,
        ),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-top-level-functions',
        child: DocsApiTable(
          title: 'Top-level functions',
          facts: _functionFacts,
        ),
      ),
    ],
  );
}

const List<DocsApiFact> _paletteFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'commands',
    type: 'List<AgentCommand>',
    description:
        'Required. Already filtered by the caller — the palette does not '
        'filter, sort, or paginate what it is handed.',
  ),
  DocsApiFact(
    name: 'activeIndex',
    type: 'int',
    description:
        'Required. Counts rows across both groups in display order. The '
        'row at this index paints highlighted; every other value renders '
        'no highlight at all.',
  ),
  DocsApiFact(
    name: 'onSelect',
    type: 'ValueChanged<AgentCommand>',
    description:
        'Required. Fires from a row\'s PointerDownEvent (onMouseDown, not '
        'onClick — see Keyboard) or a tap.',
  ),
  DocsApiFact(
    name: 'onHover',
    type: 'ValueChanged<int>',
    description:
        "Required. Fires with a row's own position the instant the "
        "pointer enters it (MouseRegion.onEnter).",
  ),
];

const List<DocsApiFact> _paletteStaticFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'maxHeight',
    type: 'double',
    description: 'space(64) — 256. The scrolling box never grows past this.',
  ),
  DocsApiFact(
    name: 'bottomGap',
    type: 'double',
    description:
        "space(2) — 8. The gap this widget's own layout reserves below "
        'itself, for a caller stacking it over a composer.',
  ),
  DocsApiFact(
    name: 'entrance',
    type: 'Duration',
    description:
        'MotionDurations.slow — 400ms. The fade/rise-in tween duration, run '
        'once on mount and never again while the same element stays '
        'mounted.',
  ),
  DocsApiFact(
    name: 'rise',
    type: 'double',
    description: "space(2.5) — 10. The entrance tween's own translateY start.",
  ),
  DocsApiFact(
    name: 'headingInsets',
    type: 'EdgeInsets',
    description:
        'fromLTRB(space(3), space(3), space(3), space(1)) on a group heading.',
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
    description: "space(3) — 12. Between a row's glyph and its text column.",
  ),
  DocsApiFact(
    name: 'lineGap',
    type: 'double',
    description: 'space(1) — 4. Between the id line and the hint line.',
  ),
  DocsApiFact(
    name: 'glyphTopInset',
    type: 'double',
    description:
        "space(1) — 4. The glyph's own top offset against the first "
        'line.',
  ),
  DocsApiFact(name: 'glyphSize', type: 'double', description: 'space(4) — 16.'),
  DocsApiFact(
    name: 'lucideStroke',
    type: 'double',
    description:
        "Icon.strokeFor(IconPaths.viewBox) — lucide's own authored "
        'stroke width, not the Icon wrapper\'s derived one. A row '
        'renders command.icon raw, which is why this glyph reads thinner '
        'than the plus menu\'s.',
  ),
  DocsApiFact(
    name: 'scrollsGroupsNotRows',
    type: 'bool',
    description:
        'true, always. DRIFT, reproduced on purpose: the reference '
        'scrolls the active GROUP into view, not the active row, so '
        'keyboard-walking past the second row never brings the highlight '
        'back into view. See Keyboard below.',
  ),
];

const List<DocsApiFact> _commandFacts = <DocsApiFact>[
  DocsApiFact(name: 'id', type: 'String', description: 'Required.'),
  DocsApiFact(name: 'label', type: 'String', description: 'Required.'),
  DocsApiFact(
    name: 'hint',
    type: 'String?',
    description: 'Optional. The second line under the id, clamped to 2 lines.',
  ),
  DocsApiFact(
    name: 'group',
    type: 'AgentCommandGroup',
    description: 'Required. Which section this command renders under.',
  ),
  DocsApiFact(
    name: 'icon',
    type: 'LucideGlyph?',
    description:
        'Optional. Usually derived from the state the command\'s tool '
        'maps to, so one capability carries one mark everywhere it '
        'appears. A row with no icon still reserves the glyph column\'s '
        'own layout.',
  ),
  DocsApiFact(
    name: 'run',
    type: 'VoidCallback?',
    description:
        'Optional. Runs in the browser. Mutually exclusive with '
        'directive — this file does not enforce that, the caller does.',
  ),
  DocsApiFact(
    name: 'directive',
    type: 'String?',
    description:
        'Optional. Text written into the composer for the user '
        'to send.',
  ),
];

const List<DocsApiFact> _commandGroupFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'skill',
    type: '—',
    description:
        "Something the agent can actually do: the scope's own registered "
        'tools, never invented by the palette.',
  ),
  DocsApiFact(
    name: 'command',
    type: '—',
    description: 'Runs in the browser. Never reaches the agent.',
  ),
];

const List<DocsApiFact> _functionFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'slashQuery(value, caret)',
    type: 'String? Function(String, int)',
    description:
        'Null unless value starts with "/" AND the text up to caret '
        'contains no space or newline — so "and/or" mid-sentence never '
        'opens anything. Returns the text after the slash, up to the '
        'caret, empty string included.',
  ),
  DocsApiFact(
    name: 'filterCommands(commands, query)',
    type: 'List<AgentCommand> Function(List<AgentCommand>, String)',
    description:
        'A plain, case-insensitive substring match over id and label. An '
        'empty query returns the input list unchanged. No fuzzy matching: '
        'the source\'s own doc comment says a fuzzy match would rank '
        '"/clear" below "/recalculate" because both contain c-l-e-a-r.',
  ),
];

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Semantic role: every row wraps Semantics(button: true, selected: '
            'active) — active is activeIndex == this row\'s own position, '
            'nothing else.',
        'No accessible name beyond the row\'s own text content ("/" + '
            'command.id, then the hint on its own line): there is no '
            'label or semanticsLabel override anywhere in this file.',
        'The palette itself renders no Semantics.container and no live '
            'region: a screen reader is told about each row as an '
            'individual button, never that a menu opened or how many rows '
            'it holds.',
        'The whole widget renders SizedBox.shrink() when commands is '
            'empty — nothing is mounted for assistive tech to find, which '
            'is the correct behaviour for "there is nothing to show" but '
            'also means there is no announcement that a search produced '
            'zero results.',
      ]);
}

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'This file binds no key at all. There is no Focus, no FocusNode, '
            'no onKeyEvent anywhere in agent_slash_palette.dart: '
            'AgentSlashPalette cannot intercept a keystroke on its own.',
        'ArrowDown/ArrowUp, Enter and Escape are entirely the composer\'s '
            'own job, out of scope for this page — the class doc says so '
            'directly: "the open query, the matches and the highlight all '
            'belong to the composer, which is the one place the keyboard '
            'is routed."',
        'A row does answer the pointer, but only onMouseDown '
            '(Listener.onPointerDown), not onClick: the composer keeps '
            'focus in its own text field while the palette is open, and a '
            'tap would blur it first if the row waited for onClick.',
        'DRIFT, reproduced. _PaletteBoxState scrolls the active GROUP '
            'into view on activeIndex change (scrollIntoView on the '
            'outer list, whose children are the two <li> groups), not the '
            'active ROW: keyboard-walking past the second row never '
            'brings the highlight back into view, because every index '
            'from 2 up resolves to nothing and scrolls nothing. See '
            'AgentSlashPalette.scrollsGroupsNotRows above.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'No breakpoint branching anywhere in agent_slash_palette.dart: '
            'BuildContext width is never read.',
        'The widget claims no width of its own — every measurement here '
            'is space() height and inset, none of them horizontal sizing — so '
            'the caller\'s own SizedBox or the composer\'s w-full decides '
            'how wide it renders. This page wraps every specimen in a '
            'fixed-width SizedBox to give it something to measure against.',
        'maxHeight (256) is fixed regardless of viewport: a palette with '
            'enough rows to exceed it scrolls internally rather than '
            'growing or shrinking with the screen.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      _bullets(ThemeScope.of(context), <String>[
        'File: lib/src/components/ui/agent_slash_palette.dart. No companion '
            'parts.',
        'Flutter imports: package:flutter/gestures.dart (PointerEnterEvent, '
            'PointerDownEvent), package:flutter/rendering.dart '
            '(RenderAbstractViewport, for the group-scroll-into-view), '
            'package:flutter/widgets.dart.',
        'Foundation imports: colors.dart, motion.dart (MotionDurations, '
            'MotionCurves), shadows.dart (Shadows.lg), spacing.dart (space()), '
            'theme.dart, typography.dart, theme_scope.dart.',
        'Component imports: icon.dart (Icon.lucide, IconTone), '
            'icon_paths.dart and icon_paths.g.dart (LucideGlyph, '
            'Lucide, IconPaths.viewBox for lucideStroke).',
        'registryDependencies, resolved automatically by `elattar add '
            'agent-slash-palette`: icon, source-foundation — copied '
            'verbatim from registry/components/agent-slash-palette.json.',
        'semanticDependencies (the manifest\'s own, narrower field): '
            'icon.',
      ]),
      SizedBox(height: space(2)),
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: LayoutWidths.prose),
        child: DocsLinkRow(
          links: <DocsLink>[DocsLink(label: 'Icon', route: '/components/icon')],
        ),
      ),
    ],
  );
}

class _ThemingContent extends StatelessWidget {
  const _ThemingContent();

  @override
  Widget build(
    BuildContext context,
  ) => _bullets(ThemeScope.of(context), <String>[
    'Every colour is read live off ThemeScope.of(context) at build time: '
        'theme.popover (the box fill), theme.border (the box border '
        'and the 1px header-strip-equivalent rule this widget does '
        'not have), theme.mutedForeground (group headings and hints), '
        'theme.foreground (the id line), theme.accent (an active '
        'row\'s fill), theme.agentAccent (every glyph, via a DefaultTextStyle '
        'merge). Flipping ThemeController re-resolves every one on '
        'the next frame.',
    'Elevation: Shadows.lg, the same token on every render — there '
        'is no rest/hover/pressed shadow variation, because the box '
        'itself never receives a pointer, only its rows do.',
    'No override hatch: unlike ButtonStyleRecipe on Button, this widget '
        'takes no colour or shape parameters at all. Restyling it '
        'means forking the file.',
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
    state: 'Empty',
    treatment:
        'commands.isEmpty short-circuits to SizedBox.shrink(): '
        'nothing mounts at all, not an empty box.',
    userSignal:
        'The palette disappears entirely — a caller closes its own '
        'overlay, if any, on the same condition.',
  ),
  DocsStateFact(
    state: 'Populated',
    treatment:
        'One group heading per non-empty group, Skills before '
        'Commands, in that fixed order regardless of how the caller\'s '
        'own list is ordered.',
    userSignal: 'The rows this specimen shows above.',
  ),
  DocsStateFact(
    state: 'Row highlighted',
    treatment:
        "i == activeIndex paints theme.accent behind that row's "
        'own Padding; every other row paints transparent.',
    userSignal: 'One row reads visually "current" — see Active row above.',
  ),
  DocsStateFact(
    state: 'Row hovered',
    treatment:
        'MouseRegion.onEnter calls onHover(i); the widget applies '
        'no fill of its own from hover — the caller decides whether '
        'hovering moves activeIndex.',
    userSignal:
        "Whatever the caller's own onHover implementation does; "
        'in every specimen on this page, the same accent fill as an '
        'active row.',
  ),
  DocsStateFact(
    state: 'Mount / entrance',
    treatment:
        'A TweenAnimationBuilder runs once, opacity 0→1 and a '
        '10px→0 translateY, over MotionDurations.slow (400ms) on MotionCurves.enter.',
    userSignal:
        'A fade-and-rise on first paint; filtering the same '
        'mounted instance does not replay it.',
  ),
];
