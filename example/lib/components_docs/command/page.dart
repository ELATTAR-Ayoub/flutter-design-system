/// Public documentation page for the `command` component.
///
/// **Re-housed onto the kit.** This page used to hand-compose `Section`
/// panels; it now declares a `ComponentDocSpec`
/// (`example/lib/docs/component_doc_page.dart`) and hands it to
/// `ComponentDocPage`, the same shape `button`, `field`, `dropdown_menu`,
/// `context_menu` and `menubar` established. Every specimen widget and
/// every code string below is the same one the hand-composed page carried,
/// with one required addition: the house shape's first section is always
/// titled Preview (`example/test/docs/docs_page_shape_test.dart` enforces it), so
/// the previously-unheaded live demo above Installation now owns a real
/// `ShowcaseSection` and a rail entry, where it used to be a bare
/// `DocsCodeExample` with neither. Four sections that were prose-only before
/// (Filtering, Groups, Scrollable, In a panel) each gain a genuine live
/// specimen here, since a `ShowcaseSection` is a specimen AND its source: a
/// Filtering specimen pre-filled with the query "t" so the reorder the
/// prose describes is visible without typing; a Scrollable specimen with
/// fifteen rows so `Command.listMaxHeight` genuinely caps and scrolls,
/// where the old page could only say "the palette above stays short enough
/// that the cap never triggers"; and an In a panel specimen that actually
/// opens and closes a container the way the prose describes. A new Keyboard
/// disclosure is split out of the "ArrowDown and ArrowUp...", "Ctrl+N and
/// Ctrl+J...", and "loop is false..." bullets the old Accessibility section
/// folded together.
///
/// **Split from a combined page.** This file used to document `Command`
/// and `Combobox<T>` together, on the argument that two "filter as you
/// type" surfaces read as one idea. They are two separately barrel-exported
/// public components with two source files, so each now owns a page:
/// everything about `Combobox` moved to `../combobox/page.dart` and is
/// gone from here, not duplicated.
///
/// Grounded against https://ui.shadcn.com/docs/components/base/command,
/// whose own `<h2>` list is About, Installation, Usage, Composition, Basic,
/// Shortcuts, Groups, Scrollable, RTL, API Reference. Composition,
/// Shortcuts, Groups and Scrollable land here under those names. Filtering
/// and In a panel are this port's own additions, and they earn their place:
/// the ported scorer re-ranks rows, which the reference documents nowhere,
/// and `Command` owns neither its opening nor its dismissal, so how a
/// container mounts it is the first thing a caller needs. Three of shadcn's
/// sections are skipped rather than faked, and named in the Scrollable
/// section's own SKIPPED panel: About (the port credits `cmdk` in
/// Installation instead of under a heading of its own), Basic (their
/// `CommandDialog` demo: [Command.inDialog] adjusts the palette's own
/// fill, border and row radius for that presentation, but the dialog
/// wrapper is recorded, not built) and RTL (no `Directionality` or
/// `TextDirection` branch anywhere in `command.dart`, and the docs shell
/// this page renders inside carries no direction toggle to demonstrate one
/// against).
///
/// **No overlay here.** `Command` mounts inline and anchors to nothing:
/// `command.dart`'s own "Why this file does not build on `Popover`". So
/// unlike the combobox page, this one's live specimens need no real
/// [Overlay] to work. `command_test.dart` still wraps it in a `MaterialApp`
/// for the ordinary reasons a docs page needs one.
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

final ComponentDocSpec commandDocSpec = ComponentDocSpec(
  name: 'command',
  title: commandDoc.title,
  description: commandDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'Live. Type in the search field: rows drop out as the filter '
          'narrows, and the survivors re-rank inside their own group.',
      specimen: _CommandSpecimen(),
      code: _usageCommandCode,
      label: 'Preview specimen view',
      minHeight: space(120),
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'Already reachable today through both the published package and '
          'the registry: Command is barrel-exported, and the shipped '
          'registry/components/command.json manifest resolves through the '
          'elattar CLI. The Manual tab is for a project not using the CLI.',
      command: commandDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/command.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/ui/command.dart's generated @ui/"
              'command.dart payload into components/ui.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated command source here when using manual '
              'mode.',
        ),
        const DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so Command, CommandItem, '
              'CommandGroup and commandScore are reachable the same '
              'way the CLI path already makes them.',
          code: "export 'command.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'The smallest correct construction: a list of groups, each '
          'holding rows. Every example below only changes named arguments '
          'on top of this.',
      code: _usageCommandCode,
    ),
    SnippetSection(
      id: 'composition',
      title: 'Composition',
      description:
          'shadcn assembles Command from five caller-composed pieces '
          '(Command, CommandInput, CommandList, CommandGroup, '
          'CommandItem). This port is one widget configured through data '
          'instead, so the shape below is a data hierarchy rather than a '
          'widget tree: the search field, the empty row and the '
          'scrolling list are built for you and are not addressable from '
          'a call site.',
      code: _compositionTreeCommandCode,
    ),
    ShowcaseSection(
      id: 'filtering',
      title: 'Filtering',
      description:
          'Not in shadcn\'s own section list, and the single most '
          'surprising thing about this component: the rows do not just '
          'disappear, they move, ranked by commandScore, a ported '
          'fuzzy ranker. This specimen starts with the query "t" '
          'already typed: Go to Stash rises above Open Wallet, '
          'reversing the source order, because the "t" beginning the '
          'word "to" scores 0.891 while the "t" buried inside "Wallet" '
          'scores 0.17. An empty query short-circuits both passes, so '
          'source order stands: clear the field to see it. keywords are '
          "appended to the searchable string rather than scored "
          "separately: Open Wallet also carries keywords: ['money']. "
          'What gets scored is CommandItem.searchValue, not the label: '
          "left null, it derives from label, subtitle, meta and shortcut "
          "concatenated with nothing between them, which means a price "
          "or a key hint IS searchable — the Eclipse Vault row carries "
          '\$48.00 as its meta, and typing 48 finds it. Pass '
          'shouldFilter: false to hold the rows exactly as given and '
          'filter server-side instead, or filter to substitute a scorer '
          'of your own; both leave the highlight behaviour untouched.',
      specimen: _FilteringSpecimen(),
      code: _filteringCode,
      label: 'Filtering specimen view',
      minHeight: space(120),
    ),
    ShowcaseSection(
      id: 'shortcuts',
      title: 'Shortcuts',
      description:
          'shadcn renders a CommandShortcut, a right-aligned key hint, '
          'beside a row. CommandItem.shortcut is the same slot. meta '
          '(a price, a count, a timestamp) is a second, independent '
          'trailing slot, and a row can carry both at once: they differ '
          'in type spec, in whether the selected row brightens them, and '
          'in whether they displace the trailing check indicator.',
      specimen: _ShortcutsSpecimen(),
      code: _shortcutsCode,
      label: 'Shortcuts specimen view',
    ),
    ShowcaseSection(
      id: 'groups',
      title: 'Groups',
      description:
          'CommandGroup renders an optional heading above its rows, '
          'and separatorBefore draws a rule above the whole group: both '
          'visible below, where Actions carries a separator before it '
          'and Packs does not. A group whose rows are all filtered away '
          'hides its heading with them, and stops occupying space '
          'entirely. The separator is not painted while a query is '
          'running: it leaves the tree on the first keystroke and comes '
          'back when the field is cleared. Rows re-sort inside their own '
          'group on every keystroke, but the groups themselves never '
          'move: a faithfully reproduced upstream bug rather than a '
          'design choice — cmdk\'s second sort pass builds its selector '
          'from a React useId while the element carries its heading '
          'instead, so the selector matches nothing and the pass is a '
          'silent no-op. Command.sortsGroups is a static false that '
          'records it. Alt+ArrowDown and Alt+ArrowUp step to the next or '
          'previous group\'s first enabled row, falling back to a plain '
          'one-row step when there is no such group.',
      specimen: _GroupsSpecimen(),
      code: _usageCommandCode,
      label: 'Groups specimen view',
      minHeight: space(120),
    ),
    ShowcaseSection(
      id: 'scrollable',
      title: 'Scrollable',
      description:
          'Once the rows need more room than the palette allows, the '
          'list caps its height and scrolls internally rather than '
          'growing the page around it: Command.listMaxHeight (288px) '
          'is that cap, and nothing above it changes the palette\'s '
          'outer size. This specimen carries fifteen rows, enough to '
          'genuinely trigger the cap rather than describe it in the '
          'abstract. An arrow move scrolls the newly highlighted row '
          'into view; a hover deliberately does not, because a row you '
          'just pointed at is already on screen. Skipped, and named '
          'rather than silently dropped: About (this page credits cmdk '
          'in Installation instead of under a heading of its own, '
          'beside the version the scorer was ported from), Basic '
          '(shadcn\'s CommandDialog demo — Command.inDialog reproduces '
          'what that presentation does to the palette itself, but the '
          'dialog wrapper is recorded, not built, so there is no live '
          'specimen to show), and RTL (no Directionality or '
          'TextDirection branch anywhere in command.dart, and the docs '
          'shell this page renders inside carries no direction toggle '
          'to demonstrate one against).',
      specimen: _ScrollableSpecimen(),
      code: _scrollableCode,
      label: 'Scrollable specimen view',
      minHeight: space(120),
    ),
    ShowcaseSection(
      id: 'in-a-panel',
      title: 'In a panel',
      description:
          'Command owns neither its opening nor its dismissal, '
          'because it has no container of its own to dismiss. Whatever '
          'mounts it owns both: this specimen is a small stand-in for '
          "this site's own header search — a button opens a panel "
          'holding a live Command, and picking a row closes the panel '
          'itself, the container dismissing itself the way the prose '
          'describes.',
      specimen: _InAPanelSpecimen(),
      code: _inAPanelCode,
      label: 'In a panel specimen view',
      minHeight: space(120),
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every constructor parameter, static helper and top-level '
          'function lib/src/components/ui/command.dart declares: one table '
          'each, read off the real constructors.',
      children: const <DocsTocEntry>[
        DocsTocEntry(title: 'Command', anchor: 'api-elcommand'),
        DocsTocEntry(
          title: 'Command static helpers',
          anchor: 'api-elcommand-static',
        ),
        DocsTocEntry(title: 'CommandItem', anchor: 'api-elcommanditem'),
        DocsTocEntry(title: 'CommandGroup', anchor: 'api-elcommandgroup'),
        DocsTocEntry(title: 'commandScore', anchor: 'api-elcommandscore'),
      ],
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'Read off _DsCommandState, not inferred: the palette is '
          'always open, so every state below is a state of its list '
          'rather than of its visibility.',
      child: DocsStateMatrix(facts: _stateFacts),
    ),
    DisclosureSection(
      id: 'accessibility',
      title: 'Accessibility',
      description: 'Keyboard interactions have their own section below.',
      child: _AccessibilityContent(),
    ),
    DisclosureSection(
      id: 'keyboard',
      title: 'Keyboard',
      description:
          'Read straight off command.dart\'s own root Focus.onKeyEvent, '
          'not inferred.',
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
            value: commandDoc.sourcePath,
            description:
                'Authoritative implementation: Command, CommandItem, '
                'CommandGroup and commandScore. The truth this page '
                'was written from.',
          ),
          const DocsInstallFact(
            label: 'Sibling component',
            value: 'lib/src/components/ui/combobox.dart',
            description:
                'Combobox, the anchored form control that used to '
                'share this page. It has its own page now, at '
                '/components/combobox: reach for it when the reader '
                'knows roughly what the value is called, and for '
                'Command when they know what they want to do but not '
                'what it is named.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'test/components_test.dart',
            description:
                'Command and commandScore are covered inside the '
                'shared components suite, including the re-sort. There '
                'is no dedicated command_test.dart in the package.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/command_test.dart',
            description:
                'Covers this page: the section order, every API table, '
                'the live palette\'s filtering and re-sort, Enter '
                'committing a row, and both themes at two viewport '
                'widths.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/command/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class CommandDocPage extends StatelessWidget {
  const CommandDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: commandDoc.route,
    intro: DocsPageIntro(
      title: commandDocSpec.title,
      description: commandDocSpec.description,
    ),
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Components'),
      BreadcrumbEntry.page('Command'),
    ],
    toc: commandDocSpec.toc,
    previous: const DocsPageLink(
      title: 'Alert Dialog',
      route: '/components/alert-dialog',
    ),
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('command-doc-article'),
      child: ComponentDocPage(spec: commandDocSpec, header: false),
    ),
  );
}

/* ── Showcase specimens ─────────────────────────────────────────────────── */

/// The live command palette.
///
/// Row order is deliberate and is what the docs test measures: Open Wallet
/// sits above Go to Stash in source order, and typing `t` reverses them —
/// `t` opening the word "to" scores 0.891 where the `t` inside "Wallet"
/// scores 0.17. Eclipse Vault leads, so it is the row cmdk arms before
/// anything has been touched.
class _CommandSpecimen extends StatefulWidget {
  const _CommandSpecimen();

  @override
  State<_CommandSpecimen> createState() => _CommandSpecimenState();
}

class _CommandSpecimenState extends State<_CommandSpecimen> {
  String? _lastPicked;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final String? picked = _lastPicked;
    return KeyedSubtree(
      key: const ValueKey<String>('command-doc-command-specimen'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Command(
            placeholder: 'Type to filter...',
            emptyLabel: 'Nothing matches that.',
            label: 'Docs command palette',
            groups: <CommandGroup>[
              CommandGroup(
                heading: 'Packs',
                items: <CommandItem>[
                  CommandItem(
                    label: 'Eclipse Vault',
                    meta: '\$48.00',
                    onSelect: () =>
                        setState(() => _lastPicked = 'Eclipse Vault'),
                  ),
                ],
              ),
              CommandGroup(
                heading: 'Actions',
                separatorBefore: true,
                items: <CommandItem>[
                  CommandItem(
                    label: 'Open Wallet',
                    keywords: const <String>['money'],
                    onSelect: () => setState(() => _lastPicked = 'Open Wallet'),
                  ),
                  CommandItem(
                    label: 'Go to Stash',
                    onSelect: () => setState(() => _lastPicked = 'Go to Stash'),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: space(3)),
          StyledText(
            picked == null ? 'Nothing picked yet' : 'Last picked: $picked',
            TextStyles.small,
            color: theme.mutedForeground,
          ),
        ],
      ),
    );
  }
}

/// The same three rows as the Preview specimen, pre-filtered by a
/// `TextEditingController` seeded with `t`: `_search` reads
/// `_controller.text` directly (a getter, not state cached only on a
/// listener), so the reorder is visible on first frame with nothing typed.
class _FilteringSpecimen extends StatefulWidget {
  const _FilteringSpecimen();

  @override
  State<_FilteringSpecimen> createState() => _FilteringSpecimenState();
}

class _FilteringSpecimenState extends State<_FilteringSpecimen> {
  late final TextEditingController _controller = TextEditingController(
    text: 't',
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return KeyedSubtree(
      key: const ValueKey<String>('command-doc-filtering-specimen'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Command(
            controller: _controller,
            placeholder: 'Type to filter...',
            emptyLabel: 'Nothing matches that.',
            label: 'Filtering specimen',
            groups: <CommandGroup>[
              CommandGroup(
                heading: 'Packs',
                items: <CommandItem>[
                  CommandItem(label: 'Eclipse Vault', meta: '\$48.00'),
                ],
              ),
              CommandGroup(
                heading: 'Actions',
                separatorBefore: true,
                items: <CommandItem>[
                  CommandItem(
                    label: 'Open Wallet',
                    keywords: const <String>['money'],
                  ),
                  CommandItem(label: 'Go to Stash'),
                ],
              ),
            ],
          ),
          SizedBox(height: space(3)),
          StyledText(
            'Query: "t" — Go to Stash outranks Open Wallet',
            TextStyles.small,
            color: theme.mutedForeground,
          ),
        ],
      ),
    );
  }
}

class _ShortcutsSpecimen extends StatelessWidget {
  const _ShortcutsSpecimen();

  @override
  Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<String>('command-doc-shortcuts-specimen'),
    child: Command(
      placeholder: 'Type to filter...',
      label: 'Shortcuts specimen',
      groups: <CommandGroup>[
        CommandGroup(
          items: <CommandItem>[
            CommandItem(
              label: 'Open Wallet',
              keywords: const <String>['money'],
              shortcut: 'Ctrl+W',
              meta: '2 accounts',
            ),
          ],
        ),
      ],
    ),
  );
}

/// The same two-group composition Preview mounts, under its own key: the
/// group heading and `separatorBefore` are what this section is about.
class _GroupsSpecimen extends StatelessWidget {
  const _GroupsSpecimen();

  @override
  Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<String>('command-doc-groups-specimen'),
    child: Command(
      placeholder: 'Type to filter...',
      label: 'Groups specimen',
      groups: <CommandGroup>[
        CommandGroup(
          heading: 'Packs',
          items: <CommandItem>[
            CommandItem(label: 'Eclipse Vault', meta: '\$48.00'),
          ],
        ),
        CommandGroup(
          heading: 'Actions',
          separatorBefore: true,
          items: <CommandItem>[
            CommandItem(label: 'Open Wallet'),
            CommandItem(label: 'Go to Stash'),
          ],
        ),
      ],
    ),
  );
}

/// Fifteen rows in one group: enough to exceed `Command.listMaxHeight`
/// (288px) and genuinely scroll, rather than describe scrolling in the
/// abstract the way the old page's static demo did.
class _ScrollableSpecimen extends StatelessWidget {
  const _ScrollableSpecimen();

  @override
  Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<String>('command-doc-scrollable-specimen'),
    child: Command(
      placeholder: 'Type to filter...',
      label: 'Scrollable specimen',
      groups: <CommandGroup>[
        CommandGroup(
          heading: 'Every command',
          items: <CommandItem>[
            for (int i = 1; i <= 15; i++) CommandItem(label: 'Command $i'),
          ],
        ),
      ],
    ),
  );
}

/// A small stand-in for this site's own header search: a button opens a
/// bordered panel holding a live [Command]; picking a row closes the
/// panel itself, the container dismissing itself the way [Command] never
/// does on its own.
class _InAPanelSpecimen extends StatefulWidget {
  const _InAPanelSpecimen();

  @override
  State<_InAPanelSpecimen> createState() => _InAPanelSpecimenState();
}

class _InAPanelSpecimenState extends State<_InAPanelSpecimen> {
  bool _open = false;
  String? _lastPicked;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return KeyedSubtree(
      key: const ValueKey<String>('command-doc-in-a-panel-specimen'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Button(
            key: const ValueKey<String>('command-doc-panel-trigger'),
            variant: ButtonVariant.outline,
            label: _open ? 'Close search panel' : 'Open search panel',
            onPressed: () => setState(() => _open = !_open),
            child: StyledText(
              _open ? 'Close search panel' : 'Open search panel',
              TextStyles.nav,
            ),
          ),
          if (_open) ...<Widget>[
            SizedBox(height: space(3)),
            Container(
              padding: EdgeInsets.all(space(2)),
              decoration: BoxDecoration(
                color: theme.popover,
                border: Border.all(color: theme.border),
                borderRadius: BorderRadius.circular(Radii.lg),
              ),
              child: Command(
                placeholder: 'Search the docs...',
                label: 'Docs search panel',
                groups: <CommandGroup>[
                  CommandGroup(
                    items: <CommandItem>[
                      CommandItem(
                        label: 'Installation',
                        onSelect: () => setState(() {
                          _lastPicked = 'Installation';
                          _open = false;
                        }),
                      ),
                      CommandItem(
                        label: 'Theming',
                        onSelect: () => setState(() {
                          _lastPicked = 'Theming';
                          _open = false;
                        }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
          SizedBox(height: space(3)),
          StyledText(
            _lastPicked == null
                ? 'Nothing picked yet'
                : 'Last picked: $_lastPicked (panel closed itself)',
            TextStyles.small,
            color: theme.mutedForeground,
          ),
        ],
      ),
    );
  }
}

const String _usageCommandCode = '''
import 'package:elattar_design_system/elattar_design_system.dart';

Command(
  placeholder: 'Type to filter...',
  emptyLabel: 'Nothing matches that.',
  label: 'Docs command palette',
  groups: <CommandGroup>[
    CommandGroup(
      heading: 'Packs',
      items: <CommandItem>[
        CommandItem(
          label: 'Eclipse Vault',
          meta: '\\\$48.00',
          onSelect: () => open('eclipse'),
        ),
      ],
    ),
    CommandGroup(
      heading: 'Actions',
      separatorBefore: true,
      items: <CommandItem>[
        CommandItem(
          label: 'Open Wallet',
          keywords: <String>['money'],
          onSelect: openWallet,
        ),
        CommandItem(
          label: 'Go to Stash',
          onSelect: openStash,
        ),
      ],
    ),
  ],
)''';

const String _compositionTreeCommandCode =
    '''Command                       // one widget, not five
├─ groups: List<CommandGroup>
│  └─ CommandGroup
│     ├─ heading                    the group label, optional
│     ├─ separatorBefore            a rule above the whole group
│     └─ items: List<CommandItem>
│        └─ CommandItem           one filterable, selectable row
└─ (built for you) the search field, the empty row, the scrolling list''';

const String _filteringCode = '''Command(
  controller: TextEditingController(text: 't'), // pre-fills the query
  groups: <CommandGroup>[
    CommandGroup(
      heading: 'Packs',
      items: <CommandItem>[
        CommandItem(label: 'Eclipse Vault', meta: '\\\$48.00'),
      ],
    ),
    CommandGroup(
      heading: 'Actions',
      separatorBefore: true,
      items: <CommandItem>[
        CommandItem(label: 'Open Wallet', keywords: <String>['money']),
        CommandItem(label: 'Go to Stash'), // 't' scores this row higher
      ],
    ),
  ],
)''';

const String _shortcutsCode = '''
CommandItem(
  label: 'Open Wallet',
  keywords: <String>['money'],
  shortcut: 'Ctrl+W',     // a trailing key hint, right-aligned
  meta: '2 accounts',     // and a second, independent trailing slot
  onSelect: openWallet,
)''';

const String _scrollableCode = '''Command(
  groups: <CommandGroup>[
    CommandGroup(
      heading: 'Every command',
      items: <CommandItem>[
        for (int i = 1; i <= 15; i++) CommandItem(label: 'Command \$i'),
      ],
    ),
  ],
)
// Command.listMaxHeight (288px) caps the row list; fifteen rows exceed it
// and the list scrolls internally instead of growing the palette.''';

const String _inAPanelCode = '''
// This site's own header search: Command mounted in a panel that owns both
// opening and dismissal, because Command owns neither.
Panel(
  child: Command(
    groups: searchGroups(
      onPick: (String route) {
        onNavigate(route);
        closeSearchPanel();   // the container dismisses itself
      },
    ),
    placeholder: 'Search the docs...',
    onValueChanged: (String value) => setState(() => _highlighted = value),
  ),
)''';

/* ── Disclosure content ─────────────────────────────────────────────────── */

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsAnchor(
        id: 'api-elcommand',
        child: DocsApiTable(title: 'Command', facts: _commandFacts),
      ),
      SizedBox(height: space(6)),
      const DocsAnchor(
        id: 'api-elcommand-static',
        child: DocsApiTable(
          title: 'Command static helpers',
          facts: _commandStaticFacts,
        ),
      ),
      SizedBox(height: space(6)),
      const DocsAnchor(
        id: 'api-elcommanditem',
        child: DocsApiTable(title: 'CommandItem', facts: _commandItemFacts),
      ),
      SizedBox(height: space(6)),
      const DocsAnchor(
        id: 'api-elcommandgroup',
        child: DocsApiTable(title: 'CommandGroup', facts: _commandGroupFacts),
      ),
      SizedBox(height: space(6)),
      const DocsAnchor(
        id: 'api-elcommandscore',
        child: DocsApiTable(
          title: 'commandScore(string, abbreviation, [aliases]) → double',
          facts: _commandScoreFacts,
        ),
      ),
    ],
  );
}

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      _bullets(ThemeScope.of(context), <String>[
        'Each row reports itself as a button carrying its selected and '
            'enabled state, and its accessible name joins the label to '
            'the shortcut when a row has one. The palette as a whole is '
            'a semantics container named by label.',
      ]),
      SizedBox(height: space(3)),
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: LayoutWidths.prose),
        child: StyledText(
          'Known gaps, reported rather than idealised.',
          TextStyles.small,
          color: ThemeScope.of(context).destructiveText,
        ),
      ),
      SizedBox(height: space(2)),
      _bullets(ThemeScope.of(context), <String>[
        'Known gap: no live region. Nothing announces how many rows '
            'survived the filter. A sighted reader sees the list '
            'collapse from twenty rows to two; a screen-reader user is '
            'told nothing, and finds out only by arrowing through what '
            'is left. The reference has the same hole, and closing it '
            'means adding a live region that speaks the result count on '
            'each keystroke: a real change to the component, not a '
            'parameter.',
        'Known gap: the highlight is painted but not announced. No '
            'relationship is wired from the search field to the row '
            'Enter would commit, so assistive tech does not read the '
            'active option as the highlight moves.',
        'Known gap: no listbox role wiring. The palette does not '
            'declare itself as a listbox owning a set of options, so '
            'the rows read as ordinary buttons that happen to sit under '
            'a text field.',
        'Known gap: the search field has no focus affordance at all, '
            'and this one is reproduced deliberately. The reference '
            'kills the socket shadow outright and its focus predicate '
            'looks for a data-slot the command input never carries, so '
            'neither the ring nor a border change can ever fire. It is '
            'the one text field in the system that shows nothing when '
            'focused.',
      ]),
    ],
  );
}

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'The caret never leaves the search field. Arrow keys move a '
            'highlight rather than focus, so typing keeps working '
            'throughout: the root key handler sits above the text field '
            'in the tree and sees Home, End and the arrows before the '
            'field turns them into caret moves.',
        'ArrowDown and ArrowUp step one row; Home and End jump to the '
            'first and last; Alt+Arrow steps by group; Meta+Arrow jumps '
            'to the far end. Enter and NumpadEnter commit the '
            'highlighted row and fire its onSelect.',
        'Ctrl+N and Ctrl+J step down, Ctrl+P and Ctrl+K step up, while '
            'vimBindings is true (the default). Worth naming: the '
            'reference advertises Ctrl+K as the shortcut that OPENS a '
            'palette, while inside one Ctrl+K already means move up.',
        'loop is false by default, so the arrows stop dead at both ends '
            'rather than wrapping.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'No breakpoint branching anywhere in command.dart: BuildContext '
            'width is never read for a layout decision, and the same '
            'widget tree renders at 390px and 1440px.',
        'The palette fills the width it is given and caps its list '
            'height, scrolling inside it, so a phone viewport shows the '
            'same palette as a desktop one: just shorter, with more '
            'scrolling.',
        'Every measurement is a fixed 4px-grid value through space() or a '
            'component type spec, never a viewport fraction: see the '
            'static helpers table in API Reference for the whole set.',
        'Row text is single-line and ellipsised rather than wrapped, so '
            'a long label shortens instead of growing the row. The one '
            'row that is taller is a row carrying a subtitle, which is '
            'a second line by construction.',
        'Platform parity: Android, iOS, Web, macOS, Windows and Linux '
            'all render the same tree. No dart:io Platform branch '
            'anywhere in the file, and the vim bindings are Ctrl-based '
            'on every one of them.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      _bullets(ThemeScope.of(context), <String>[
        'File: lib/src/components/ui/command.dart. One file, no '
            'companions, and shipped registry manifest.',
        'Flutter imports: dart:math (the score decay), '
            'package:flutter/services.dart (LogicalKeyboardKey, '
            'HardwareKeyboard, KeyEvent), package:flutter/widgets.dart.',
        'Foundation imports: foundation/colors.dart, '
            'foundation/spacing.dart (space()), foundation/theme.dart, '
            'foundation/typography.dart, theme_scope.dart (StyledText, '
            'ThemeScope).',
        'Component imports: icon.dart (Icon, IconGlyph, '
            'IconTone), icon_paths.dart and icon_paths.g.dart '
            '(LucideGlyph, for CommandItem.lucideIcon), input.dart '
            '(Input, the search field), input_group.dart '
            '(InputGroupAddon, for the addon inset only).',
        'Notably NOT imported: popover.dart. The palette is inline and '
            'anchors to nothing, which is why nothing on this page '
            'needs an Overlay to work: see Composition.',
        'It also does not import input_group.dart\'s own InputGroup '
            'widget, only its addon inset. That widget fixes a 40px '
            'pill, a card fill and a pressed shadow, all three of which '
            'this control overrides, so the recipe is reused where the '
            'widget cannot be.',
        'Assets: none. Shaders: none.',
      ]),
      SizedBox(height: space(4)),
      const DocsLinkRow(
        links: <DocsLink>[
          DocsLink(label: 'Icon', route: '/components/icon'),
          DocsLink(label: 'Input', route: '/components/input'),
          DocsLink(label: 'Input group', route: '/components/input_group'),
        ],
      ),
    ],
  );
}

class _ThemingContent extends StatelessWidget {
  const _ThemingContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Every colour resolves from ThemeScope.of(context) at build time: '
            'the palette fill from card (or popover under inDialog), '
            'its stroke from border, the search field from input at a '
            'fixed alpha for both fill and border, the highlighted row '
            'from muted, headings and trailing meta from '
            'mutedForeground. Flipping ThemeController re-resolves '
            'all of them on the next frame.',
        'The highlighted row uses muted, which is a third highlight '
            'token in this corpus after the select row\'s accent and '
            'the combobox row\'s accent. Reproduced drift, not a choice '
            'this port made.',
        'Type is by role, never by size: rows and the empty row read '
            'the sheet-body spec, headings the menu-heading spec (the '
            'weight-500 member of a three-way group-label split), '
            'shortcuts the menu-shortcut spec, and subtitles and meta '
            'the caption spec. The prices riding the shortcut spec are '
            'sans rather than the numeric foundation, which is '
            'reproduced upstream drift.',
        'Shape is fixed rather than parameterised: the palette corners '
            'at the extra-large radius, its search field at large, and '
            'a row at medium (large under inDialog). No caller-facing '
            'radius parameter exists.',
        'Nothing here animates. There is no transition on the row '
            'highlight, so it snaps: which also means this component '
            'has nothing to reduce under a reduced-motion setting.',
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

// ── API tables, read off lib/src/components/ui/command.dart ────────────────────

const List<DocsApiFact> _commandFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'groups',
    type: 'List<CommandGroup>',
    description:
        'Required. Every row on the palette, in source order, grouped. The '
        'groups are never reordered: see Command.sortsGroups below.',
  ),
  DocsApiFact(
    name: 'placeholder',
    type: 'String?',
    description: 'Optional. Defaults to null. The search field\'s empty hint.',
  ),
  DocsApiFact(
    name: 'emptyLabel',
    type: 'String?',
    description:
        'Optional. Defaults to null, which renders NO empty row at all: an '
        'empty list rather than a message. Non-null, it mounts exactly '
        'when the filtered count reaches zero.',
  ),
  DocsApiFact(
    name: 'controller',
    type: 'TextEditingController?',
    description:
        'Optional. Defaults to null, which lets the palette own its own. '
        'Supply one to read or clear the query from outside — the '
        'Filtering specimen above pre-seeds one with "t".',
  ),
  DocsApiFact(
    name: 'focusNode',
    type: 'FocusNode?',
    description:
        'Optional. Defaults to null, which lets the search field own its '
        'own node.',
  ),
  DocsApiFact(
    name: 'shouldFilter',
    type: 'bool',
    description:
        'Optional. Defaults to true, which is cmdk\'s own default and '
        'means automatic filtering AND sorting. False shows every row in '
        'source order and leaves the narrowing to the caller: the escape '
        'hatch for a server-side or async search.',
  ),
  DocsApiFact(
    name: 'filter',
    type:
        'double Function(String value, String search, List<String> keywords)?',
    description:
        'Optional. Defaults to null, which uses commandScore. Return 0 '
        'to hide a row; larger is better. The first argument is the row\'s '
        'searchValue, not its label.',
  ),
  DocsApiFact(
    name: 'loop',
    type: 'bool',
    description:
        'Optional. Defaults to false, matching the reference, which leaves '
        'the prop unset. True wraps arrow navigation from the last row '
        'back to the first.',
  ),
  DocsApiFact(
    name: 'vimBindings',
    type: 'bool',
    description:
        'Optional. Defaults to true. Ctrl+N and Ctrl+J step down, Ctrl+P '
        'and Ctrl+K step up, alongside the arrow keys.',
  ),
  DocsApiFact(
    name: 'label',
    type: 'String?',
    description:
        'Optional. Defaults to null. The accessible name: it names the '
        'palette\'s semantics container and is passed to the search field '
        'as its own label, which the reference renders into a visually '
        'hidden element.',
  ),
  DocsApiFact(
    name: 'onValueChanged',
    type: 'ValueChanged<String>?',
    description:
        'Optional. Defaults to null. Fires with the HIGHLIGHTED row\'s '
        'searchValue whenever the highlight moves, which includes the '
        'automatic move back to the top on every keystroke. It is not the '
        'query: read the query from a controller instead.',
  ),
  DocsApiFact(
    name: 'inDialog',
    type: 'bool',
    description:
        'Optional. Defaults to false. True adjusts the palette for the '
        'centred-dialog presentation cmdk also ships: the popover fill '
        'instead of the card fill, no stroke of its own, and a wider row '
        'radius. The dialog wrapper itself is recorded, not built.',
  ),
];

const List<DocsApiFact> _commandStaticFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'Command.padding',
    type: 'static double',
    description:
        'The palette\'s own inset, and the distance the separator bleeds '
        'back out through it.',
  ),
  DocsApiFact(
    name: 'Command.listMaxHeight',
    type: 'static double',
    description:
        'The cap the row list scrolls inside: 288px. Nothing above it '
        'changes the palette\'s outer size.',
  ),
  DocsApiFact(
    name: 'Command.inputHeight',
    type: 'static double',
    description:
        'The search field\'s height: 32px, where the rest of the input '
        'family sits at 40.',
  ),
  DocsApiFact(
    name: 'Command.inputFillAlpha',
    type: 'static const double',
    description:
        'One alpha, applied to both the search field\'s fill and its '
        'border, over the theme\'s input colour.',
  ),
  DocsApiFact(
    name: 'Command.searchGlyphOpacity',
    type: 'static const double',
    description:
        'The leading search glyph\'s opacity. An opacity, not a colour: '
        'the glyph reads mutedForeground and then fades, which measures '
        'differently from foreground at the same alpha.',
  ),
  DocsApiFact(
    name: 'Command.disabledOpacity',
    type: 'static const double',
    description: 'What a row with enabled: false fades to.',
  ),
  DocsApiFact(
    name: 'Command.itemHeight',
    type: 'static double',
    description:
        'One single-line row, derived from the sheet-body type spec plus '
        'its vertical padding rather than hardcoded.',
  ),
  DocsApiFact(
    name: 'Command.headingHeight',
    type: 'static double',
    description: 'One group heading, derived from the menu-heading type spec.',
  ),
  DocsApiFact(
    name: 'Command.emptyHeight',
    type: 'static double',
    description:
        'The empty row, which is a body line box inside a much deeper '
        'padding than a row takes.',
  ),
  DocsApiFact(
    name: 'Command.sortsGroups',
    type: 'static bool',
    description:
        'False, and it is a record rather than a switch: rows re-sort '
        'inside their group, groups never move. Reproduced upstream bug, '
        'documented in Groups above.',
  ),
];

const List<DocsApiFact> _commandItemFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'label',
    type: 'String',
    description:
        'Required. The row\'s visible copy, and the first thing folded '
        'into what gets scored.',
  ),
  DocsApiFact(
    name: 'icon',
    type: 'IconGlyph?',
    description:
        'Optional. Defaults to null. A leading glyph from the curated '
        'system set. The row, not the call site, decides its size.',
  ),
  DocsApiFact(
    name: 'lucideIcon',
    type: 'LucideGlyph?',
    description:
        'Optional. Defaults to null. The same slot over the generated '
        'Lucide registry, for a row whose glyph has no curated '
        'equivalent. Ignored when icon is given.',
  ),
  DocsApiFact(
    name: 'iconTone',
    type: 'IconTone?',
    description:
        'Optional. Defaults to null, which leaves the row\'s own subtle '
        'tone in charge. A selected row overrules whatever this says, the '
        'same way it overrules the default.',
  ),
  DocsApiFact(
    name: 'subtitle',
    type: 'String?',
    description:
        'Optional. Defaults to null. A second, caption-sized line under '
        'the label, which grows the row by one line box. It is part of '
        'the searched text.',
  ),
  DocsApiFact(
    name: 'meta',
    type: 'String?',
    description:
        'Optional. Defaults to null. Trailing metadata that is NOT a '
        'shortcut: a price, a count, a timestamp. It stays muted on the '
        'selected row, and unlike a shortcut it does not displace the '
        'trailing check indicator.',
  ),
  DocsApiFact(
    name: 'shortcut',
    type: 'String?',
    description:
        'Optional. Defaults to null. A trailing key hint on the '
        'menu-shortcut spec, which brightens with the selected row and '
        'takes the place of the trailing check indicator entirely.',
  ),
  DocsApiFact(
    name: 'value',
    type: 'String?',
    description:
        'Optional. Defaults to null, which derives the identity from the '
        'rendered text: see searchValue below. Set it when selection '
        'identity or the scored string should differ from what the row '
        'shows.',
  ),
  DocsApiFact(
    name: 'keywords',
    type: 'List<String>',
    description:
        'Optional. Defaults to an empty list. Appended to the searchable '
        'string rather than scored separately: see Filtering.',
  ),
  DocsApiFact(
    name: 'enabled',
    type: 'bool',
    description:
        'Optional. Defaults to true. A disabled row still renders and is '
        'still filtered, but fades and can be neither highlighted nor '
        'committed: the arrows step over it.',
  ),
  DocsApiFact(
    name: 'onSelect',
    type: 'VoidCallback?',
    description:
        'Optional. Defaults to null. Fired when the row is committed by '
        'Enter or by a tap, and by nothing else. Command holds no value '
        'of its own, so this callback is the entire result.',
  ),
  DocsApiFact(
    name: 'searchValue',
    type: 'String (getter)',
    description:
        'Not a constructor parameter: the derived string the matcher '
        'actually sees, and the identity the highlight is stored under. '
        'It is value when given, otherwise label, subtitle, meta and '
        'shortcut concatenated with nothing between them, trimmed.',
  ),
];

const List<DocsApiFact> _commandGroupFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'items',
    type: 'List<CommandItem>',
    description:
        'Required. The group\'s rows, in source order. They re-sort '
        'inside this group when a query is running, and never leave it.',
  ),
  DocsApiFact(
    name: 'heading',
    type: 'String?',
    description:
        'Optional. Defaults to null, which renders a group with no '
        'heading element at all while keeping its padding. A group whose '
        'rows are all filtered away hides its heading with them.',
  ),
  DocsApiFact(
    name: 'separatorBefore',
    type: 'bool',
    description:
        'Optional. Defaults to false. Draws a full-bleed hairline above '
        'this group, modelled as the group\'s own property rather than a '
        'sibling list entry so the arrangement cannot drift. It is not '
        'painted at all while a query is running.',
  ),
];

const List<DocsApiFact> _commandScoreFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'string',
    type: 'String',
    description:
        'Positional, required. The row text being scored: in practice a '
        'CommandItem.searchValue.',
  ),
  DocsApiFact(
    name: 'abbreviation',
    type: 'String',
    description: 'Positional, required. The query typed so far.',
  ),
  DocsApiFact(
    name: 'aliases',
    type: 'List<String>',
    description:
        'Positional, optional. Defaults to an empty list. The row\'s '
        'keywords, appended to the subject rather than scored on their '
        'own.',
  ),
  DocsApiFact(
    name: 'returns',
    type: 'double',
    description:
        '0 hides the row entirely; 1 is a perfect match. cmdk\'s own '
        'scorer, ported whole rather than approximated.',
  ),
];

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Rest',
    treatment:
        'The search field plus every row, in source order. The palette is '
        'inline and always open: there is no closed state to document.',
    userSignal: 'Everything is already visible.',
  ),
  DocsStateFact(
    state: 'Filtered',
    treatment:
        'Every keystroke re-scores each row, drops the zeroes, and '
        're-sorts the survivors inside their own group, source index '
        'breaking a tie. The separator leaves the tree while a query '
        'runs.',
    userSignal: 'The list shortens AND reorders, not just shortens.',
  ),
  DocsStateFact(
    state: 'Highlighted',
    treatment:
        'The first valid row is armed one frame after mount, before '
        'anything is touched, and the highlight returns to the top on '
        'every keystroke. A hover takes it too, and keeps it: moving off '
        'the palette leaves the last-hovered row armed.',
    userSignal: 'One row is visibly armed, so Enter always has a target.',
  ),
  DocsStateFact(
    state: 'Committed',
    treatment:
        'Enter or a tap fires the row\'s onSelect and keeps nothing: no '
        'value is stored, no field is written, the palette does not '
        'close, because it owns no container to close.',
    userSignal: 'Something happens elsewhere; the palette stays as it was.',
  ),
  DocsStateFact(
    state: 'Empty',
    treatment:
        'emptyLabel mounts exactly when the filtered count reaches zero, '
        'including a palette with no rows and no query. Null renders no '
        'empty row at all.',
    userSignal: 'A sentence where the rows were, or nothing.',
  ),
  DocsStateFact(
    state: 'Disabled row',
    treatment:
        'enabled: false fades the row and takes it out of the ring the '
        'arrows walk, while leaving it rendered and still filtered. There '
        'is no disabled flag for the palette as a whole: a container that '
        'needs one disables itself.',
    userSignal: 'A faded row nothing can arm or commit.',
  ),
  DocsStateFact(
    state: 'Loading',
    treatment:
        'There is none. A caller doing async work passes shouldFilter: '
        'false and swaps the rows itself, rendering its own progress '
        'affordance outside the palette.',
    userSignal: 'Whatever the caller puts in the rows.',
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment:
        'Nothing to reduce: this component runs no animation at all. The '
        'row highlight has no transition and snaps, which is the '
        'reference\'s behaviour too.',
    userSignal: 'Identical either way.',
  ),
];
