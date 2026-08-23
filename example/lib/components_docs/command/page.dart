/// Public documentation page for `DsCommand` and `DsCombobox`.
///
/// One page, two paired "filter as you type" components with opposite shapes.
/// Command is inline with nothing to anchor to; Combobox is a form control
/// anchored to a DsPopover. The distinction is the reason this page exists.
///
/// `DsCombobox` mounts its list through a `DsPopover` (an `OverlayPortal`), so
/// the live combobox specimen needs a real `Overlay` — the test harness wraps
/// the page in a `MaterialApp`. `DsCommand` has nothing to anchor to and mounts
/// inline, but the shared harness still supplies MaterialApp for the combobox.
///
/// Neither component has a registry manifest yet, and neither `elattar add`
/// command works — the Installation section says so without printing a command
/// line that would fail if a reader copied it.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/docs_code.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../kit.dart';
import 'meta.dart';

class CommandDocPage extends StatelessWidget {
  const CommandDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: commandDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / BASE',
      title: commandDoc.title,
      description: commandExpandedDescription,
    ),
    breadcrumbs: const <DsBreadcrumbEntry>[
      DsBreadcrumbEntry.link('Components'),
      DsBreadcrumbEntry.page('Command & Combobox'),
    ],
    sidebar: _sidebar,
    toc: const <DocsTocEntry>[
      DocsTocEntry(title: 'Overview', anchor: 'overview'),
      DocsTocEntry(title: 'Preview', anchor: 'preview'),
      DocsTocEntry(title: 'Install', anchor: 'install'),
      DocsTocEntry(title: 'Usage', anchor: 'usage'),
      DocsTocEntry(title: 'Filtering', anchor: 'filtering'),
      DocsTocEntry(title: 'API', anchor: 'api'),
      DocsTocEntry(title: 'Variants', anchor: 'variants'),
      DocsTocEntry(title: 'States', anchor: 'states'),
      DocsTocEntry(title: 'Accessibility', anchor: 'accessibility'),
      DocsTocEntry(title: 'Responsive', anchor: 'responsive'),
      DocsTocEntry(title: 'Dependencies', anchor: 'dependencies'),
      DocsTocEntry(title: 'Composition', anchor: 'composition'),
      DocsTocEntry(title: 'Theming', anchor: 'theming'),
      DocsTocEntry(title: 'Source', anchor: 'source'),
    ],
    previous: const DocsPageLink(
      title: 'Alert Dialog',
      route: '/components/alert-dialog',
    ),
    onNavigate: onNavigate,
    child: const _CommandArticle(),
  );
}

const List<DocsSidebarEntry> _sidebar = <DocsSidebarEntry>[
  DocsSidebarEntry(title: 'Button', route: '/components/button'),
  DocsSidebarEntry(title: 'Card', route: '/components/card'),
  DocsSidebarEntry(title: 'Input', route: '/components/input'),
  DocsSidebarEntry(title: 'Dialog', route: '/components/dialog'),
  DocsSidebarEntry(title: 'Alert Dialog', route: '/components/alert-dialog'),
  DocsSidebarEntry(title: 'Select', route: '/components/select'),
  DocsSidebarEntry(
    title: 'Command & Combobox',
    route: '/components/command',
    selected: true,
  ),
];

class _CommandArticle extends StatelessWidget {
  const _CommandArticle();

  @override
  Widget build(BuildContext context) => Column(
    key: const ValueKey<String>('command-doc-article'),
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      _overview(),
      _preview(),
      _install(),
      _usage(),
      _filtering(),
      _api(),
      _variants(),
      _states(),
      _accessibility(),
      _responsive(),
      _dependencies(),
      _composition(),
      _theming(),
      _source(),
    ],
  );

  Widget _overview() => DsSection(
    id: 'overview',
    title: 'Overview',
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: DsWidths.prose),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DsText(
            'Two paired "filter as you type" surfaces. DsCommand is an '
            'inline, always-open action launcher with nothing to anchor to: '
            'no trigger, no popover, no positioner. DsCombobox is the '
            'opposite shape — a form control that anchors its popup to its '
            'own input through DsPopover, and holds a controlled value that '
            'survives the popup closing.',
            DsType.body,
          ),
          SizedBox(height: ds(4)),
          DsText(
            'Both narrow a list as you type, and that is the only thing they '
            'share. They do not even filter the same way: Command runs a '
            'ported fuzzy scorer that re-ranks rows on every keystroke, while '
            'Combobox runs a plain folded substring match that preserves the '
            'source order. Filtering, below, shows both on a worked example.',
            DsType.body,
          ),
          SizedBox(height: ds(4)),
          DsText(
            'Status: stable primitives, not yet registered in the CLI. '
            'Platforms: Android, iOS, Web, macOS, Windows, Linux.',
            DsType.small,
          ),
        ],
      ),
    ),
  );

  Widget _preview() => DsSection(
    id: 'preview',
    title: 'Preview',
    description:
        'Command inline with nothing around it, and Combobox anchored to its '
        'own input. Both are live: type in either one.',
    child: DocsCodeExample(
      title: 'Command and Combobox specimens',
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/command.dart',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy lib/src/components/command.dart and\n'
              '// lib/src/components/combobox.dart from the package source.\n'
              '// There is no generated CLI payload for either one yet.',
        ),
      ],
      preview: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DsText('Command — inline, always visible', DsType.label),
          SizedBox(height: ds(2)),
          const _CommandSpecimen(),
          SizedBox(height: ds(6)),
          DsText('Combobox — anchored to its own input', DsType.label),
          SizedBox(height: ds(2)),
          const _ComboboxSpecimen(),
        ],
      ),
    ),
  );

  Widget _install() => DsSection(
    id: 'install',
    title: 'Installation',
    description:
        'Neither component has a registry manifest, so the CLI cannot install '
        'either one today. Both are exported from the package barrel and '
        'usable through the published package right now.',
    child: DocsInstallFacts(
      title: 'Installation facts',
      facts: <DocsInstallFact>[
        const DocsInstallFact(
          label: 'CLI install',
          value: 'Not available yet',
          description:
              'There is no registry payload for command and none for '
              'combobox, so the registry client has nothing to resolve for '
              'either name.',
        ),
        const DocsInstallFact(
          label: 'Registry item',
          value: 'Not available yet',
          description:
              'Neither registry/components/command.json nor '
              'registry/components/combobox.json exists. Source-only '
              'components, both of them.',
        ),
        const DocsInstallFact(
          label: 'Destination',
          value: 'lib/components/ui/command.dart, .../combobox.dart',
          description: 'Two files; one source library each.',
        ),
        const DocsInstallFact(
          label: 'Dependencies',
          value:
              'source-foundation, icon, input, input_group, field, popover, '
              'select',
          description:
              'What the two sources really import from lib/src/components/. '
              'Not a validated registryDependencies list — there is no '
              'manifest for it to come from.',
        ),
        const DocsInstallFact(
          label: 'Assets',
          value: 'none',
          description: 'No images, icon fonts, or binary assets.',
        ),
        const DocsInstallFact(
          label: 'Shaders',
          value: 'none',
          description: 'Not applicable.',
        ),
        const DocsInstallFact(
          label: 'Platforms',
          value: 'Android, iOS, Web, macOS, Windows, Linux',
          description: 'Pure widget composition; nothing platform-gated.',
        ),
        const DocsInstallFact(
          label: 'Verified',
          value: 'package suite plus this page\'s specimens',
          description:
              'test/selects_test.dart covers DsCombobox and '
              'dsCollatorContains; the command suite covers dsCommandScore '
              'and the re-sort. This page adds two live specimens.',
        ),
      ],
    ),
  );

  Widget _usage() => DsSection(
    id: 'usage',
    title: 'Usage',
    description: 'Both shapes as they appear in the preview.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DsPanel(
          label: 'DART',
          note: 'COMMAND — inline, fires callbacks',
          child: DocsSelectableCodeBlock(code: _usageCommandCode),
        ),
        SizedBox(height: ds(5)),
        DsPanel(
          label: 'DART',
          note: 'COMBOBOX — anchored, holds a value',
          child: DocsSelectableCodeBlock(code: _usageComboboxCode),
        ),
      ],
    ),
  );

  Widget _filtering() => DsSection(
    id: 'filtering',
    title: 'Filtering — two different algorithms',
    description:
        'The single most common way to reach for the wrong one of these two '
        'is to assume they filter alike. They do not.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DsPanel(
          label: 'Command — dsCommandScore, a ported fuzzy ranker',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DsText(
                'dsCommandScore(string, abbreviation, [aliases]) is cmdk\'s '
                'own scorer, ported whole. It returns a double: 0 hides the '
                'row, and anything above it ranks the row. Letters need not '
                'be adjacent, so "gts" still finds "Go to Stash" — but where '
                'a letter lands matters enormously, because a match at the '
                'start of a word scores far higher than the same letter '
                'inside one.',
                DsType.small,
              ),
              SizedBox(height: ds(3)),
              DsText(
                'The measured worked example, taken from the source\'s own '
                'note and reproducible in the live specimen above: type a '
                'single "t". Go to Stash rises above Open Wallet, reversing '
                'the source order, because the "t" beginning the word "to" '
                'scores 0.891 while the "t" buried inside "Wallet" scores '
                '0.17. Rows re-sort inside their own group on every '
                'keystroke.',
                DsType.small,
              ),
              SizedBox(height: ds(3)),
              DsText(
                'Groups, however, do not re-sort — a faithfully reproduced '
                'upstream bug rather than a port decision. cmdk\'s second '
                'sort pass builds a selector from a React useId while the '
                'element carries its heading instead, so the selector matches '
                'nothing and the pass is a silent no-op. DsCommand.sortsGroups '
                'is a static false that records it.',
                DsType.small,
              ),
              SizedBox(height: ds(3)),
              DsText(
                'keywords are appended to the searchable string rather than '
                'scored separately, so keywords: [\'money\'] makes '
                '"Open Wallet money" the text being matched. Pass '
                'shouldFilter: false to hold the rows still and filter '
                'server-side instead, or filter to substitute a scorer of '
                'your own.',
                DsType.small,
              ),
            ],
          ),
        ),
        SizedBox(height: ds(5)),
        DsPanel(
          label: 'Combobox — dsCollatorContains, a plain substring match',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DsText(
                'dsCollatorContains(label, query) does exactly what its name '
                'says: it asks whether the label contains the query, with no '
                'ranking of any kind. Rows that match keep their source '
                'order; rows that do not are dropped. Nothing ever moves up '
                'the list.',
                DsType.small,
              ),
              SizedBox(height: ds(3)),
              DsText(
                'It is a substring test, not a prefix test — typing "rift" '
                'finds Golden Rift even though the query starts in the middle '
                'of the second word. Before comparing, both sides are folded '
                'the way a base-sensitivity collator folds them: case is '
                'ignored, accents are stripped, and whitespace and '
                'punctuation are skipped entirely. So "éclipse" matches '
                'Eclipse, and a stray hyphen or space in the query never '
                'costs a match.',
                DsType.small,
              ),
              SizedBox(height: ds(3)),
              DsText(
                'Because there is no scoring, a long list filtered to a '
                'single letter stays long. Combobox is the right shape when '
                'the reader knows roughly what the value is called; Command '
                'is the right shape when they know what they want to do but '
                'not what it is named.',
                DsType.small,
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _api() => DsSection(
    id: 'api',
    title: 'API',
    description:
        'Every constructor parameter and top-level function both source '
        'files declare.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const DocsApiTable(
          title: 'DsCommand',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'groups',
              type: 'List<DsCommandGroup>',
              description:
                  'Required. Every row on the palette, in source order, '
                  'grouped.',
            ),
            DocsApiFact(
              name: 'placeholder',
              type: 'String?',
              description: 'The search field\'s empty hint.',
            ),
            DocsApiFact(
              name: 'emptyLabel',
              type: 'String?',
              description:
                  'What renders when the filter leaves nothing. Null shows '
                  'an empty list rather than a message.',
            ),
            DocsApiFact(
              name: 'controller',
              type: 'TextEditingController?',
              description:
                  'An optional controller for the search field, for callers '
                  'that need to read or clear the query from outside.',
            ),
            DocsApiFact(
              name: 'focusNode',
              type: 'FocusNode?',
              description: 'An optional node for the search field.',
            ),
            DocsApiFact(
              name: 'shouldFilter',
              type: 'bool',
              description:
                  'Defaults to true. False leaves the rows exactly as passed '
                  '— the escape hatch for server-side or async filtering.',
            ),
            DocsApiFact(
              name: 'filter',
              type: 'double Function(String, String, List<String>)?',
              description:
                  'Replaces dsCommandScore. Return 0 to hide a row; larger '
                  'is better.',
            ),
            DocsApiFact(
              name: 'loop',
              type: 'bool',
              description:
                  'Defaults to false. Whether arrow-key navigation wraps '
                  'from the last row back to the first.',
            ),
            DocsApiFact(
              name: 'vimBindings',
              type: 'bool',
              description:
                  'Defaults to true. Ctrl+N/Ctrl+P and Ctrl+J/Ctrl+K move '
                  'the highlight alongside the arrow keys.',
            ),
            DocsApiFact(
              name: 'label',
              type: 'String?',
              description: 'The accessible name for the palette as a whole.',
            ),
            DocsApiFact(
              name: 'onValueChanged',
              type: 'ValueChanged<String>?',
              description:
                  'Called with the query on every keystroke — how a caller '
                  'drives its own async search.',
            ),
            DocsApiFact(
              name: 'inDialog',
              type: 'bool',
              description:
                  'Defaults to false. True adjusts the palette for the '
                  'centred-dialog presentation cmdk also ships.',
            ),
          ],
        ),
        SizedBox(height: ds(6)),
        const DocsApiTable(
          title: 'DsCommandItem',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'label',
              type: 'String',
              description:
                  'Required. The visible row text, and what is scored.',
            ),
            DocsApiFact(
              name: 'icon',
              type: 'DsIconGlyph?',
              description: 'A leading glyph from the system icon set.',
            ),
            DocsApiFact(
              name: 'lucideIcon',
              type: 'String?',
              description:
                  'A leading glyph named from the Lucide set instead, for '
                  'rows whose icon has no system equivalent.',
            ),
            DocsApiFact(
              name: 'iconTone',
              type: 'DsIconTone?',
              description: 'Overrides the leading glyph\'s tone.',
            ),
            DocsApiFact(
              name: 'subtitle',
              type: 'String?',
              description: 'A second line under the label.',
            ),
            DocsApiFact(
              name: 'meta',
              type: 'String?',
              description:
                  'Trailing metadata — a price, a count, a timestamp — set '
                  'apart from the shortcut.',
            ),
            DocsApiFact(
              name: 'shortcut',
              type: 'String?',
              description: 'A trailing key hint, rendered as a kbd cap.',
            ),
            DocsApiFact(
              name: 'value',
              type: 'String?',
              description:
                  'The identity used for selection and for the scored '
                  'string when it should differ from the label.',
            ),
            DocsApiFact(
              name: 'keywords',
              type: 'List<String>',
              description:
                  'Defaults to empty. Appended to the searchable text — see '
                  'Filtering.',
            ),
            DocsApiFact(
              name: 'enabled',
              type: 'bool',
              description:
                  'Defaults to true. A disabled row still renders and is '
                  'still filtered, but cannot be highlighted or picked.',
            ),
            DocsApiFact(
              name: 'onSelect',
              type: 'VoidCallback?',
              description:
                  'Fired when the row is committed by Enter or by a tap. '
                  'Command holds no value of its own — this callback is the '
                  'entire result.',
            ),
          ],
        ),
        SizedBox(height: ds(6)),
        const DocsApiTable(
          title: 'DsCommandGroup',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'items',
              type: 'List<DsCommandItem>',
              description: 'Required. The group\'s rows, in source order.',
            ),
            DocsApiFact(
              name: 'heading',
              type: 'String?',
              description:
                  'The group label. A group whose rows are all filtered away '
                  'hides its heading with them.',
            ),
            DocsApiFact(
              name: 'separatorBefore',
              type: 'bool',
              description: 'Defaults to false. Draws a rule above the group.',
            ),
          ],
        ),
        SizedBox(height: ds(6)),
        const DocsApiTable(
          title: 'dsCommandScore(string, abbreviation, [aliases])',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'string',
              type: 'String',
              description: 'The row text being scored.',
            ),
            DocsApiFact(
              name: 'abbreviation',
              type: 'String',
              description: 'The query typed so far.',
            ),
            DocsApiFact(
              name: 'aliases',
              type: 'List<String>',
              description:
                  'Defaults to empty. The item\'s keywords, appended to the '
                  'subject rather than scored on their own.',
            ),
          ],
        ),
        SizedBox(height: ds(6)),
        const DocsApiTable(
          title: 'DsCombobox<T>',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'items',
              type: 'List<DsComboboxItem<T>>',
              description:
                  'Required. DsComboboxItem is a typedef for DsSelectOption, '
                  'so a list written for DsSelect drops in unchanged.',
            ),
            DocsApiFact(
              name: 'value',
              type: 'T?',
              description:
                  'Required. The controlled selection, which persists after '
                  'the popup closes — the thing Command has no equivalent of.',
            ),
            DocsApiFact(
              name: 'onChanged',
              type: 'ValueChanged<T>?',
              description: 'Required. Null disables the control outright.',
            ),
            DocsApiFact(
              name: 'placeholder',
              type: 'String?',
              description: 'The input\'s empty hint.',
            ),
            DocsApiFact(
              name: 'emptyLabel',
              type: 'String?',
              description: 'What the popup shows when nothing matches.',
            ),
            DocsApiFact(
              name: 'enabled',
              type: 'bool',
              description:
                  'Defaults to true. Composes with DsFieldScope the way '
                  'DsInput and DsSelect do.',
            ),
            DocsApiFact(
              name: 'invalid',
              type: 'bool',
              description:
                  'Defaults to false. Paints the error ring; the message '
                  'itself belongs to the surrounding DsField.',
            ),
            DocsApiFact(
              name: 'focusNode',
              type: 'FocusNode?',
              description: 'An optional node for the text input.',
            ),
            DocsApiFact(
              name: 'label',
              type: 'String?',
              description:
                  'The field label, when not supplied by an enclosing '
                  'DsField.',
            ),
            DocsApiFact(
              name: 'hint',
              type: 'String?',
              description: 'Helper text under the field.',
            ),
            DocsApiFact(
              name: 'filter',
              type: 'bool Function(String label, String query)?',
              description:
                  'Replaces dsCollatorContains. Return true to keep the row.',
            ),
          ],
        ),
        SizedBox(height: ds(6)),
        const DocsApiTable(
          title: 'dsCollatorContains(label, query)',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'label',
              type: 'String',
              description: 'The row text being tested.',
            ),
            DocsApiFact(
              name: 'query',
              type: 'String',
              description:
                  'The query typed so far. Both sides are case-folded, '
                  'accent-stripped, and punctuation-skipped before the '
                  'substring test runs.',
            ),
          ],
        ),
      ],
    ),
  );

  Widget _variants() => DsSection(
    id: 'variants',
    title: 'Variants',
    description:
        'Neither component has a variant enum. What varies is structural, and '
        'these are the real forks.',
    child: const DocsApiTable(
      title: 'The behavioural forks',
      facts: <DocsApiFact>[
        DocsApiFact(
          name: 'Command, inline',
          type: 'default',
          description:
              'Mounted directly in a panel. Nothing anchors it and nothing '
              'dismisses it — the container owns both.',
        ),
        DocsApiFact(
          name: 'Command, inDialog',
          type: 'inDialog: true',
          description:
              'The centred-dialog presentation, for a palette summoned by a '
              'global shortcut rather than living on a page.',
        ),
        DocsApiFact(
          name: 'Command, unfiltered',
          type: 'shouldFilter: false',
          description:
              'Rows are rendered exactly as passed; the caller filters, '
              'usually against a server, and feeds new groups in.',
        ),
        DocsApiFact(
          name: 'Combobox, enabled',
          type: 'default',
          description:
              'A text input that opens its popup on focus and commits on '
              'pick.',
        ),
        DocsApiFact(
          name: 'Combobox, invalid',
          type: 'invalid: true',
          description:
              'The same control wearing the error ring, for a failed field '
              'validation.',
        ),
        DocsApiFact(
          name: 'Combobox, disabled',
          type: 'enabled: false or a null onChanged',
          description: 'Non-interactive; the popup never opens.',
        ),
      ],
    ),
  );

  Widget _states() => DsSection(
    id: 'states',
    title: 'States and feedback',
    child: const DocsStateMatrix(
      facts: <DocsStateFact>[
        DocsStateFact(
          state: 'Rest',
          treatment:
              'Command: the search field plus every row. Combobox: a closed '
              'input showing the selected label, or the placeholder.',
          userSignal: 'Command is already open; Combobox waits to be asked.',
        ),
        DocsStateFact(
          state: 'Filtered',
          treatment:
              'Command re-ranks and drops rows on every keystroke. Combobox '
              'drops non-matching rows and keeps the rest in source order.',
          userSignal: 'The list shortens; in Command it also reorders.',
        ),
        DocsStateFact(
          state: 'Highlighted',
          treatment:
              'Command highlights the best row automatically as soon as the '
              'rows register, before anything is touched, so Enter always '
              'has a target.',
          userSignal: 'One row is visibly armed.',
        ),
        DocsStateFact(
          state: 'Selected',
          treatment:
              'Command fires onSelect and keeps nothing. Combobox writes the '
              'value, closes the popup, and shows the chosen label.',
          userSignal: 'Command acts; Combobox remembers.',
        ),
        DocsStateFact(
          state: 'Empty',
          treatment:
              'Both render emptyLabel when the filter leaves nothing. Null '
              'leaves the region blank instead.',
          userSignal: 'A sentence where the rows were.',
        ),
        DocsStateFact(
          state: 'Disabled',
          treatment:
              'Combobox: enabled: false, or a null onChanged. Command has no '
              'disabled flag of its own — individual rows do (enabled), and '
              'the container disables the whole palette.',
          userSignal: 'No highlight, no commit.',
        ),
        DocsStateFact(
          state: 'Loading',
          treatment:
              'Neither has a loading state. A caller doing async work drives '
              'shouldFilter: false and swaps the rows itself.',
          userSignal: 'Whatever the caller renders in the rows.',
        ),
        DocsStateFact(
          state: 'Reduced motion',
          treatment:
              'Command does not animate at all. Combobox\'s popup runs the '
              'shared DsPopover transition, which collapses to zero through '
              'dsAnimationDuration.',
          userSignal: 'The popup appears without animated travel.',
        ),
      ],
    ),
  );

  Widget _accessibility() => DsSection(
    id: 'accessibility',
    title: 'Accessibility and keyboard behavior',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DsPanel(
          label: 'Keyboard',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DsText(
                'Both keep the caret in the text field at all times and move '
                'a highlight rather than focus, so typing never stops '
                'working. ArrowUp and ArrowDown move the highlight; Enter '
                'commits it. Command adds Ctrl+N/Ctrl+P and Ctrl+J/Ctrl+K '
                'while vimBindings is true, and wraps at the ends when loop '
                'is true. Combobox closes its popup on Escape and commits on '
                'Enter; Command has no dismissal of its own, because it has '
                'no container of its own to dismiss.',
                DsType.small,
              ),
            ],
          ),
        ),
        SizedBox(height: ds(5)),
        DsPanel(
          label: 'Known gaps',
          note: 'REPORTED, NOT IDEALISED',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DsText(
                'Known gap — no live region. Neither component announces how '
                'many rows survived the filter. A sighted reader sees the '
                'list collapse from twenty rows to two; a screen-reader user '
                'is told nothing at all, and finds out only by arrowing '
                'through what is left. The reference has the same hole, and '
                'closing it means adding a live region that speaks the '
                'result count on each keystroke — a real change to both '
                'components, not a prop.',
                DsType.small,
              ),
              SizedBox(height: ds(3)),
              DsText(
                'Known gap — the combobox highlight is not announced. The '
                'highlighted row is painted, but no relationship is wired '
                'from the input to the row that Enter would commit, so '
                'assistive tech does not read the active option as the '
                'highlight moves. Command has the same shape of gap on its '
                'own rows.',
                DsType.small,
              ),
              SizedBox(height: ds(3)),
              DsText(
                'Known gap — no role wiring between the field and the popup. '
                'Neither surface declares itself as a listbox with an owned '
                'set of options, so the popup reads as ordinary content that '
                'happens to have appeared.',
                DsType.small,
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _responsive() => DsSection(
    id: 'responsive',
    title: 'Responsive and platform behavior',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        DsText(
          'Command fills the width it is given and caps its list height, '
          'scrolling inside it — so a phone viewport shows the same palette '
          'as a desktop one, just shorter.',
          DsType.small,
        ),
        SizedBox(height: ds(3)),
        DsText(
          'Combobox sizes its popup from the measured anchor width and caps '
          'its height against the room the positioner reports, so a popup '
          'near the bottom of a short viewport shrinks rather than '
          'overflowing. Neither component branches on platform.',
          DsType.small,
        ),
      ],
    ),
  );

  Widget _dependencies() => DsSection(
    id: 'dependencies',
    title: 'Dependencies, files, and assets',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        DsText(
          'Files: lib/src/components/command.dart and '
          'lib/src/components/combobox.dart.',
          DsType.small,
        ),
        SizedBox(height: ds(3)),
        DsText(
          'Command imports icon and input from the component layer. Combobox '
          'imports input_group, field, popover, and select — the last of '
          'those because DsComboboxItem is a typedef for DsSelectOption and '
          'the two share their row paint.',
          DsType.small,
        ),
        SizedBox(height: ds(3)),
        DsText(
          'Foundation: colors, motion, spacing, theme, typography. Assets: '
          'none. Shaders: none.',
          DsType.small,
        ),
      ],
    ),
  );

  Widget _composition() => DsSection(
    id: 'composition',
    title: 'Composition examples',
    description:
        'Command inside a panel — the shape this site\'s own header search '
        'uses — and Combobox inside a field.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DsPanel(
          label: 'DART',
          note: 'COMMAND IN A SEARCH PANEL',
          child: DocsSelectableCodeBlock(code: _compositionCommandCode),
        ),
        SizedBox(height: ds(5)),
        DsPanel(
          label: 'DART',
          note: 'COMBOBOX IN A FORM FIELD',
          child: DocsSelectableCodeBlock(code: _compositionComboboxCode),
        ),
      ],
    ),
  );

  Widget _theming() => DsSection(
    id: 'theming',
    title: 'Theming notes',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        DsText(
          'Every colour in both components resolves from the live theme: the '
          'search field and rows from the input and popover families, the '
          'highlight from accent, headings and meta from mutedForeground. '
          'Flipping DsThemeController re-resolves all of them.',
          DsType.small,
        ),
        SizedBox(height: ds(3)),
        DsText(
          'Combobox\'s popup is a DsPopoverSurface, so its radius, shadow, '
          'and ring are the shared overlay recipe rather than anything this '
          'component owns — a change there moves every popup in the system '
          'together.',
          DsType.small,
        ),
      ],
    ),
  );

  Widget _source() => DsSection(
    id: 'source',
    title: 'Source, tests, and docs',
    child: DocsInstallFacts(
      title: 'Reference',
      facts: <DocsInstallFact>[
        DocsInstallFact(
          label: 'Source — Command',
          value: commandDoc.sourcePath,
          description: 'DsCommand, its item and group types, dsCommandScore.',
        ),
        const DocsInstallFact(
          label: 'Source — Combobox',
          value: comboboxSourcePath,
          description: 'DsCombobox and dsCollatorContains.',
        ),
        const DocsInstallFact(
          label: 'Package tests',
          value: 'test/selects_test.dart',
          description:
              'The DsCombobox group, including dsCollatorContains\' folding '
              'and substring behaviour.',
        ),
        const DocsInstallFact(
          label: 'Docs test',
          value: 'example/test/components_docs/command_test.dart',
          description:
              'Covers this page: both API tables, both live specimens, the '
              'filtering worked example, and both themes.',
        ),
        const DocsInstallFact(
          label: 'Edit these docs',
          value: 'example/lib/components_docs/command/page.dart',
          description: 'This file.',
        ),
      ],
    ),
  );
}

const String _usageCommandCode = '''
DsCommand(
  placeholder: 'Type to filter...',
  emptyLabel: 'Nothing matches that.',
  groups: <DsCommandGroup>[
    DsCommandGroup(
      heading: 'Packs',
      items: <DsCommandItem>[
        DsCommandItem(
          label: 'Eclipse Vault',
          meta: '\\\$48.00',
          onSelect: () => open('eclipse'),
        ),
      ],
    ),
    DsCommandGroup(
      heading: 'Actions',
      separatorBefore: true,
      items: <DsCommandItem>[
        DsCommandItem(
          label: 'Open Wallet',
          keywords: <String>['money'],
          shortcut: 'Ctrl+W',
          onSelect: openWallet,
        ),
      ],
    ),
  ],
)
''';

const String _usageComboboxCode = '''
DsCombobox<String>(
  value: selectedSet,
  onChanged: (String next) => setState(() => selectedSet = next),
  placeholder: 'Search sets...',
  emptyLabel: 'No set by that name.',
  items: const <DsComboboxItem<String>>[
    DsComboboxItem<String>(value: 'golden', label: 'Golden Rift'),
    DsComboboxItem<String>(value: 'mystic', label: 'Mystic Surge'),
  ],
)
''';

const String _compositionCommandCode = '''
// This site's own header search: Command mounted in a panel that owns both
// opening and dismissal, because Command owns neither.
DsPanel(
  child: DsCommand(
    groups: searchGroups(
      onPick: (String route) {
        onNavigate(route);
        closeSearchPanel();   // the container dismisses itself
      },
    ),
    placeholder: 'Search the docs...',
    onValueChanged: (String query) => setState(() => _query = query),
  ),
)
''';

const String _compositionComboboxCode = '''
DsField(
  label: 'Card set',
  hint: 'Start typing to narrow the list.',
  child: DsCombobox<String>(
    items: cardSets,
    value: selectedSet,
    invalid: submitted && selectedSet == null,
    onChanged: (String next) => setState(() => selectedSet = next),
  ),
)
''';

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
    final DsThemeData theme = DsTheme.of(context);
    final String? picked = _lastPicked;
    return KeyedSubtree(
      key: const ValueKey<String>('command-doc-command-specimen'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DsCommand(
            placeholder: 'Type to filter...',
            emptyLabel: 'Nothing matches that.',
            label: 'Docs command palette',
            groups: <DsCommandGroup>[
              DsCommandGroup(
                heading: 'Packs',
                items: <DsCommandItem>[
                  DsCommandItem(
                    label: 'Eclipse Vault',
                    meta: '\$48.00',
                    onSelect: () =>
                        setState(() => _lastPicked = 'Eclipse Vault'),
                  ),
                ],
              ),
              DsCommandGroup(
                heading: 'Actions',
                separatorBefore: true,
                items: <DsCommandItem>[
                  DsCommandItem(
                    label: 'Open Wallet',
                    keywords: const <String>['money'],
                    onSelect: () => setState(() => _lastPicked = 'Open Wallet'),
                  ),
                  DsCommandItem(
                    label: 'Go to Stash',
                    onSelect: () => setState(() => _lastPicked = 'Go to Stash'),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: ds(3)),
          DsText(
            picked == null ? 'Nothing picked yet' : 'Last picked: $picked',
            DsType.small,
            color: theme.mutedForeground,
          ),
        ],
      ),
    );
  }
}

/// The live combobox.
///
/// The card sets are the package suite's own list, minus Eclipse Vault: that
/// label already appears on the command palette above, and a docs page that
/// printed the same string in two live specimens would make every assertion
/// about it ambiguous.
class _ComboboxSpecimen extends StatefulWidget {
  const _ComboboxSpecimen();

  @override
  State<_ComboboxSpecimen> createState() => _ComboboxSpecimenState();
}

class _ComboboxSpecimenState extends State<_ComboboxSpecimen> {
  static const List<DsComboboxItem<String>> _sets = <DsComboboxItem<String>>[
    DsComboboxItem<String>(value: 'golden', label: 'Golden Rift'),
    DsComboboxItem<String>(value: 'mystic', label: 'Mystic Surge'),
    DsComboboxItem<String>(value: 'shadow', label: 'Shadow Core'),
    DsComboboxItem<String>(value: 'celestial', label: 'Celestial Strike'),
    DsComboboxItem<String>(value: 'origin', label: 'Origin Pulse'),
  ];

  String? _selected;

  String? get _selectedLabel {
    final String? value = _selected;
    if (value == null) return null;
    for (final DsComboboxItem<String> item in _sets) {
      if (item.value == value) return item.label;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final String? label = _selectedLabel;
    return KeyedSubtree(
      key: const ValueKey<String>('command-doc-combobox-specimen'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DsCombobox<String>(
            items: _sets,
            value: _selected,
            onChanged: (String next) => setState(() => _selected = next),
            placeholder: 'Search sets...',
            emptyLabel: 'No set by that name.',
          ),
          SizedBox(height: ds(3)),
          DsText(
            label == null ? 'Nothing selected yet' : 'Selected: $label',
            DsType.small,
            color: theme.mutedForeground,
          ),
        ],
      ),
    );
  }
}
