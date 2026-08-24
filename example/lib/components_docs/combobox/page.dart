/// Public documentation page for the `combobox` component.
///
/// **Split from a combined page.** `ElCombobox<T>` used to be documented on
/// `../command/page.dart`, sharing one entry with `ElCommand` on the
/// argument that two "filter as you type" surfaces read as one idea. They
/// are two separately barrel-exported public components with two source
/// files, so each now owns a page: everything about `ElCombobox` moved here
/// and is gone from the command page, not duplicated.
///
/// **Shape.** Copies `button/page.dart`'s frame, the Phase F/J reference
/// shape: an unheaded live demo above the first heading (a bare
/// [DocsCodeExample], no [ElSection], so it owns no TOC entry), then
/// Installation, Usage, then this component's own sections, then API
/// Reference last of the component-specific sections, then exactly States,
/// Accessibility, Responsive, Dependencies, Theming, Source. Section titles
/// carry no `Combobox` prefix: after the split the page is about one
/// component and the prefix would say nothing.
///
/// Grounded against https://ui.shadcn.com/docs/components/base/combobox,
/// whose own `<h2>` list is Installation, Usage, Composition, Custom Items,
/// Multiple Selection, Basic, Multiple, Clear Button, Groups, Custom Items,
/// Invalid, Disabled, Auto Highlight, Popup, Input Group, RTL, API
/// Reference. Composition, Invalid and Disabled land here under those
/// names. Filtering is this port's own addition and earns its place: the
/// matcher is a folded substring test rather than the fuzzy score its
/// sibling uses, and confusing the two is how a caller reaches for the
/// wrong component. Nine of the reference's sections describe a capability
/// `ElCombobox` genuinely does not have; rather than fake one, each is
/// named in the Composition section's own SKIPPED panel.
///
/// **This one is an overlay.** `ElCombobox` mounts its list through
/// [ElPopover], which is an [OverlayPortal], so every live specimen here
/// needs a real [Overlay] above it or the popup silently never opens: a
/// `MaterialApp` ancestor is enough, and `combobox_test.dart` supplies one.
/// A test that forgot it would pass while exercising nothing.
///
/// [ComponentDocEntry.description] is the page's only rendered description:
/// the short, one-sentence form. No second, longer paragraph renders
/// beneath it; Installation is the first section after the hero.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/docs_code.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../kit.dart';
import 'meta.dart';

class ComboboxDocPage extends StatelessWidget {
  const ComboboxDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: comboboxDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / BASE',
      title: comboboxDoc.title,
      description: comboboxDoc.description,
    ),
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Components'),
      ElBreadcrumbEntry.page('Combobox'),
    ],
    toc: const <DocsTocEntry>[
      DocsTocEntry(title: 'Installation', anchor: 'install'),
      DocsTocEntry(title: 'Usage', anchor: 'usage'),
      DocsTocEntry(title: 'Composition', anchor: 'composition'),
      DocsTocEntry(title: 'Filtering', anchor: 'filtering'),
      DocsTocEntry(title: 'Invalid', anchor: 'invalid'),
      DocsTocEntry(title: 'Disabled', anchor: 'disabled'),
      DocsTocEntry(
        title: 'API Reference',
        anchor: 'api',
        children: <DocsTocEntry>[
          DocsTocEntry(title: 'ElCombobox', anchor: 'api-elcombobox'),
          DocsTocEntry(
            title: 'ElCombobox static helpers',
            anchor: 'api-elcombobox-static',
          ),
          DocsTocEntry(title: 'ElComboboxItem', anchor: 'api-elcomboboxitem'),
          DocsTocEntry(
            title: 'elCollatorContains',
            anchor: 'api-elcollatorcontains',
          ),
        ],
      ),
      DocsTocEntry(title: 'States', anchor: 'states'),
      DocsTocEntry(title: 'Accessibility', anchor: 'accessibility'),
      DocsTocEntry(title: 'Responsive', anchor: 'responsive'),
      DocsTocEntry(title: 'Dependencies', anchor: 'dependencies'),
      DocsTocEntry(title: 'Theming', anchor: 'theming'),
      DocsTocEntry(title: 'Source', anchor: 'source'),
    ],
    previous: const DocsPageLink(
      title: 'Command',
      route: '/components/command',
    ),
    onNavigate: onNavigate,
    child: const _ComboboxArticle(),
  );
}

class _ComboboxArticle extends StatelessWidget {
  const _ComboboxArticle();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      key: const ValueKey<String>('combobox-doc-article'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _preview(),
        SizedBox(height: el(6)),
        _install(),
        SizedBox(height: el(6)),
        _usage(),
        SizedBox(height: el(6)),
        _composition(theme),
        _filtering(theme),
        _invalid(),
        _disabled(),
        _api(),
        _states(),
        _accessibility(theme),
        _responsive(theme),
        _dependencies(theme),
        _theming(theme),
        _source(),
      ],
    );
  }

  /// The live-demo slot shadcn renders before its first heading. [ElSection]
  /// always carries a heading, so this is a bare [DocsCodeExample] instead:
  /// no title text of its own in the article flow, and no TOC entry.
  Widget _preview() => DocsCodeExample(
    title: 'Combobox',
    description:
        'Live. Tap the field or its chevron to open the popup, type to '
        'narrow it, and pick a row: the value is kept and the label stays '
        'in the field.',
    preview: const _ComboboxSpecimen(),
    manualFiles: const <DocsCodeFile>[
      DocsCodeFile(
        path: 'combobox_preview.dart',
        title: 'The field above',
        code: _usageComboboxCode,
      ),
    ],
  );

  Widget _install() => ElSection(
    id: 'install',
    title: 'Installation',
    description:
        'Already reachable today through both the published package and the '
        'registry: ElCombobox is barrel-exported, and the shipped manifest '
        'resolves through the elattar CLI.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ElPanel(
          label: 'PACKAGE IMPORT',
          note: 'DART',
          child: const DocsSelectableCodeBlock(
            code:
                "import 'package:elattar_design_system/"
                "elattar_design_system.dart';\n",
          ),
        ),
        SizedBox(height: el(4)),
        DocsInstallFacts(
          title: 'Manual and CLI facts',
          facts: <DocsInstallFact>[
            const DocsInstallFact(
              label: 'CLI',
              value: 'elattar add combobox',
              description:
                  'Resolves the shipped registry/components/combobox.json '
                  'manifest. Use the package import above when you want the '
                  'published package, or use the CLI when you want the '
                  'generated local copy.',
            ),
            DocsInstallFact(
              label: 'Manual copy target',
              value: 'lib/components/ui/combobox.dart',
              description:
                  'Copy ${comboboxDoc.sourcePath} into components/ui and '
                  'keep its relative imports pointed at the same '
                  'foundation and sibling-component files: see '
                  'Dependencies below for the exact list.',
            ),
            DocsInstallFact(
              label: 'Registry dependencies',
              value: comboboxDoc.dependencies.join(', '),
              description:
                  'What registry/components/combobox.json lists as '
                  'registryDependencies, read directly from the shipped '
                  'manifest. select is load-bearing rather '
                  'than incidental: ElComboboxItem IS ElSelectOption.',
            ),
            const DocsInstallFact(
              label: 'Upstream',
              value: '@base-ui/react',
              description:
                  'The only component in this corpus ported from base-ui '
                  'rather than Radix or bespoke, which is why its state '
                  'vocabulary, its positioner variables and its filter '
                  'philosophy all differ from every neighbour.',
            ),
            const DocsInstallFact(
              label: 'Assets and shaders',
              value: 'none',
              description: 'Pure widget composition; nothing platform-gated.',
            ),
          ],
        ),
      ],
    ),
  );

  Widget _usage() => ElSection(
    id: 'usage',
    title: 'Usage',
    description:
        'Controlled, like every other form control here: the value lives '
        'at the call site and comes back through onChanged. Every example '
        'below only changes named arguments on top of this.',
    child: ElPanel(
      label: 'DART',
      note: 'MINIMAL',
      child: const DocsSelectableCodeBlock(code: _usageComboboxCode),
    ),
  );

  Widget _composition(ElThemeData theme) => ElSection(
    id: 'composition',
    title: 'Composition',
    description:
        'shadcn assembles Combobox from four caller-composed pieces '
        '(Combobox.Root, Combobox.Input, Combobox.List, Combobox.Item). '
        'This port is one widget configured through data instead, so the '
        'shape below is a data hierarchy rather than a widget tree: the '
        'input, its trigger button, the popover and the filtered list are '
        'built for you and are not addressable from a call site.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ElPanel(
          label: 'SHAPE',
          note: 'ANATOMY',
          child: const DocsSelectableCodeBlock(
            code: _compositionTreeComboboxCode,
          ),
        ),
        SizedBox(height: el(3)),
        ElPanel(
          label:
              'CUSTOM ITEMS, MULTIPLE SELECTION, MULTIPLE, CLEAR BUTTON, '
              'GROUPS, AUTO HIGHLIGHT, POPUP, INPUT GROUP, RTL',
          note: 'SKIPPED',
          child: _bullets(theme, <String>[
            'Custom Items: rows are data, not children. A row is a value, '
                'a label and an enabled flag, and the paint is the '
                'component\'s: there is no item builder to hand a widget '
                'to.',
            'Multiple Selection and Multiple: ElCombobox is single-select '
                'by construction. value is one T?, onChanged carries one '
                'T, and there is no chip rendering anywhere in the file.',
            'Clear Button: the reference ships one behind a showClear flag '
                'that defaults false, so it is not on the reference page '
                'either. This port has neither the flag nor the button, '
                'and a field whose only way back to empty is deleting the '
                'text is a real gap, recorded rather than glossed.',
            'Groups: the list is flat. ElComboboxItem is ElSelectOption, '
                'not the ElSelectGroup that sits beside it, so there is no '
                'heading or separator inside the popup.',
            'Auto Highlight: deliberately absent, matching base-ui\'s own '
                'autoHighlight: false. Nothing is highlighted until an '
                'arrow key moves, which is why Enter on a freshly opened '
                'popup does nothing at all.',
            'Popup: the reference\'s section shows a button-triggered '
                'variant with no text input. This port has one shape only: '
                'an input with a chevron addon.',
            'Input Group: the field IS an input group internally, but none '
                'of it is exposed. A caller cannot add a second addon, '
                'change the trigger glyph, or reach the group\'s own '
                'parameters.',
            'RTL: there is no Directionality or TextDirection branch in '
                'combobox.dart, and the docs shell this page renders '
                'inside carries no direction toggle to demonstrate one '
                'against.',
          ]),
        ),
      ],
    ),
  );

  Widget _filtering(ElThemeData theme) => ElSection(
    id: 'filtering',
    title: 'Filtering',
    description:
        'Not in shadcn\'s own section list, and the thing most worth '
        'knowing before choosing this component over its sibling: nothing '
        'is ranked, and nothing ever moves up the list.',
    child: ElPanel(
      label: 'elCollatorContains, a folded substring match',
      child: _bullets(theme, <String>[
        'elCollatorContains(label, query) returns a bool and does exactly '
            'what its name says: it asks whether the label contains the '
            'query. Rows that match keep their source order; rows that do '
            'not are dropped.',
        'It is a substring test, not a prefix test: typing "rift" finds '
            'Golden Rift in the field above even though the query starts '
            'in the middle of the second word.',
        'Both sides are folded first, the way a base-sensitivity collator '
            'folds them: case is ignored, Latin diacritics are stripped, '
            'and whitespace and punctuation are skipped entirely. So '
            '"eclipse" matches Eclipse, and a stray hyphen or space in the '
            'query never costs a match.',
        'An empty query matches everything rather than nothing, which is '
            'what makes an untouched popup show the whole list.',
        'The one bypass, ported deliberately: until the query has changed '
            'since the popup opened, the list is NOT narrowed to the '
            'already-selected label. Reopening after a pick shows every '
            'row again rather than the one whose name is sitting in the '
            'field.',
        'DIVERGENCE, recorded rather than hidden: the reference builds a '
            'real Intl.Collator, and ICU\'s collation table is not in this '
            'port. Folding case and stripping Latin diacritics IS base '
            'sensitivity for the Latin script, which is every string these '
            'pages produce; a script with its own collation rules '
            '(Turkish dotless i, German sharp s, Japanese kana '
            'equivalence) would diverge.',
        'Pass filter to substitute a predicate of your own. Return true to '
            'keep the row: there is no scoring axis to override, because '
            'there is no scoring.',
      ]),
    ),
  );

  Widget _invalid() => ElSection(
    id: 'invalid',
    title: 'Invalid',
    description:
        'The same control wearing the error ring, for a failed field '
        'validation. The message itself belongs to the surrounding '
        'ElField, the way ElInput and ElSelect already work: invalid on '
        'the control paints the ring and says nothing. An enclosing '
        'field\'s own invalid state reaches the control too, so either '
        'end can raise it.',
    child: DocsCodeExample(
      title: 'Invalid',
      preview: const _ComboboxInvalidSpecimen(),
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(
          path: 'combobox_invalid.dart',
          title: 'Invalid, inside a field',
          code: _invalidComboboxCode,
        ),
      ],
    ),
  );

  Widget _disabled() => ElSection(
    id: 'disabled',
    title: 'Disabled',
    description:
        'Non-interactive: the popup never opens and the trigger button '
        'takes no press. Three separate things reach this state, and any '
        'one of them is enough: enabled: false, a null onChanged, or a '
        'disabled ElField around it. A null onChanged is the most common '
        'real cause, because it usually falls out of a form with nothing '
        'to submit to yet.',
    child: DocsCodeExample(
      title: 'Disabled',
      preview: const _ComboboxDisabledSpecimen(),
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(
          path: 'combobox_disabled.dart',
          title: 'Disabled by a null onChanged',
          code: _disabledComboboxCode,
        ),
      ],
    ),
  );

  Widget _api() => ElSection(
    id: 'api',
    title: 'API Reference',
    description:
        'Every constructor parameter, static helper and top-level '
        'function lib/src/components/combobox.dart declares: one table '
        'each, read off the real constructors.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        KeyedSubtree(
          key: docsAnchorKey('api-elcombobox'),
          child: const DocsApiTable(
            title: 'ElCombobox<T>',
            facts: _comboboxFacts,
          ),
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-elcombobox-static'),
          child: const DocsApiTable(
            title: 'ElCombobox static helpers',
            facts: _comboboxStaticFacts,
          ),
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-elcomboboxitem'),
          child: const DocsApiTable(
            title: 'ElComboboxItem<T> (= ElSelectOption<T>)',
            facts: _comboboxItemFacts,
          ),
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-elcollatorcontains'),
          child: const DocsApiTable(
            title: 'elCollatorContains(label, query) → bool',
            facts: _collatorFacts,
          ),
        ),
      ],
    ),
  );

  Widget _states() => ElSection(
    id: 'states',
    title: 'States',
    description:
        'Read off _DsComboboxState, not inferred. The popup is an overlay, '
        'so open and closed are real states here in a way they are not for '
        'the inline palette next door.',
    child: const DocsStateMatrix(facts: _stateFacts),
  );

  Widget _accessibility(ElThemeData theme) => ElSection(
    id: 'accessibility',
    title: 'Accessibility',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ElPanel(
          label: 'Keyboard and semantics',
          child: _bullets(theme, <String>[
            'The caret never leaves the field. Arrow keys move a highlight '
                'rather than focus, so typing keeps working throughout: '
                'the key handler sits above the text field in the tree and '
                'sees ArrowDown before the field turns it into a caret '
                'move.',
            'ArrowDown or ArrowUp on a closed field opens the popup '
                'without moving anything; on an open one they move the '
                'highlight. The ring wraps THROUGH the field: past the '
                'last row the highlight comes off the list entirely before '
                'starting again, which is the listbox-with-an-input '
                'behaviour base-ui implements.',
            'Enter commits the highlighted row, and does nothing at all '
                'when nothing is highlighted: an unmoved popup has no '
                'armed row, by design. Escape closes the popup and puts '
                'the committed value\'s label back in the field.',
            'The control reports itself as a text field carrying its '
                'expanded state, named by label or by an enclosing '
                'ElField\'s label, and described by hint or that field\'s '
                'own description. Each row reports as a button carrying '
                'its selected and enabled state.',
            'The trigger button carries its own name, which flips between '
                'Open and Close with the popup, though on this page the '
                'field takes the focus and the arrows drive the popup '
                'instead.',
          ]),
        ),
        SizedBox(height: el(5)),
        ElPanel(
          label: 'Known gaps',
          note: 'REPORTED, NOT IDEALISED',
          child: _bullets(theme, <String>[
            'Known gap: no live region. Nothing announces how many rows '
                'survived the filter. A sighted reader sees the list '
                'collapse from six rows to one; a screen-reader user is '
                'told nothing, and finds out only by arrowing through what '
                'is left. The reference has the same hole, and closing it '
                'means adding a live region that speaks the result count '
                'on each keystroke: a real change to the component, not a '
                'parameter.',
            'Known gap: the highlight is painted but not announced. No '
                'relationship is wired from the field to the row Enter '
                'would commit, so assistive tech does not read the active '
                'option as the highlight moves.',
            'Known gap: no listbox role wiring. The popup does not declare '
                'itself a listbox owning a set of options, so it reads as '
                'ordinary content that happens to have appeared.',
            'Known gap: no way back to empty. With no clear affordance and '
                'no null in onChanged\'s type, a reader who has picked a '
                'value cannot un-pick one; the caller has to offer that '
                'some other way.',
          ]),
        ),
      ],
    ),
  );

  Widget _responsive(ElThemeData theme) => ElSection(
    id: 'responsive',
    title: 'Responsive',
    child: _bullets(theme, <String>[
      'No breakpoint branching anywhere in combobox.dart: BuildContext '
          'width is never read for a layout decision, and the same widget '
          'tree renders at 390px and 1440px.',
      'The popup sizes itself from the MEASURED anchor width plus a fixed '
          'overshoot, and the anchor is the inner input rather than the '
          'visible pill, so the popup ends up wider than the input and '
          'narrower than the field it hangs under. That is reproduced '
          'reference behaviour, not a layout accident.',
      'Its height is the smaller of the component\'s own cap and the room '
          'the positioner reports, so a popup near the bottom of a short '
          'viewport shrinks and scrolls rather than overflowing, and it '
          'flips above the field when there is more room up there.',
      'Row text is single-line and ellipsised rather than wrapped, so a '
          'long label shortens instead of growing the row.',
      'Platform parity: Android, iOS, Web, macOS, Windows and Linux all '
          'render the same tree. No dart:io Platform branch anywhere in '
          'the file.',
    ]),
  );

  Widget _dependencies(ElThemeData theme) => ElSection(
    id: 'dependencies',
    title: 'Dependencies',
    child: _bullets(theme, <String>[
      'File: lib/src/components/combobox.dart. One file, no companions, '
          'and a shipped registry manifest.',
      'Flutter imports: dart:math (clamping the popup height), '
          'package:flutter/services.dart (LogicalKeyboardKey, KeyEvent), '
          'package:flutter/widgets.dart.',
      'Foundation imports: foundation/motion.dart, '
          'foundation/spacing.dart (el()), foundation/theme.dart, '
          'foundation/typography.dart, theme_scope.dart (ElText, ElTheme).',
      'Component imports: field.dart (ElFieldScope, so an enclosing field '
          'can supply the label, the focus node, and the enabled and '
          'invalid states), icon.dart and icon_paths.dart (the chevron and '
          'the tick), input_group.dart (ElInputGroup, ElInputGroupInput, '
          'ElInputGroupAddon, ElInputGroupButton: the whole chassis), '
          'popover.dart (ElPopover and ElPopoverSurface: the overlay), '
          'select.dart (ElSelectOption, which ElComboboxItem is a typedef '
          'for).',
      'Notably NOT imported: input.dart. The text field here is '
          'ElInputGroupInput, not ElInput, which is the one dependency '
          'this component does not share with the command palette.',
      'Assets: none. Shaders: none.',
    ]),
  );

  Widget _theming(ElThemeData theme) => ElSection(
    id: 'theming',
    title: 'Theming',
    child: _bullets(theme, <String>[
      'Every colour resolves from ElTheme.of(context) at build time: the '
          'field from the input-group recipe, the popup surface from '
          'popover, a row\'s ink from popoverForeground, the highlighted '
          'row from accent with accentForeground ink, and the empty row '
          'from mutedForeground. Flipping ElThemeController re-resolves '
          'all of them on the next frame.',
      'The popup is a ElPopoverSurface, so its fill, radius, shadow and '
          'ring are the shared overlay recipe rather than anything this '
          'component owns: a change there moves every popup in the system '
          'together.',
      'Type is by role, never by size: rows and the empty row both read '
          'the sheet-body spec, and the empty row differs from a row only '
          'in its padding and its ink.',
      'Shape is fixed rather than parameterised: the popup clips at the '
          'large radius and a row corners at medium. No caller-facing '
          'radius parameter exists.',
      'The popup\'s entrance is the shared overlay duration on the shared '
          'out curve, which collapses to nothing under a reduced-motion '
          'setting. Worth naming as reproduced drift: this popup animates '
          'while the select popup, same design system and the same overlay '
          'job, does not.',
      'The trigger button is the one button in the system whose press '
          'cancels its own fill, which is a real reference behaviour '
          'reproduced through a dedicated parameter rather than a local '
          'restyle.',
    ]),
  );

  Widget _source() => ElSection(
    id: 'source',
    title: 'Source',
    child: DocsInstallFacts(
      title: 'Reference',
      facts: <DocsInstallFact>[
        DocsInstallFact(
          label: 'Source',
          value: comboboxDoc.sourcePath,
          description:
              'Authoritative implementation: ElCombobox, ElComboboxItem '
              'and elCollatorContains. The truth this page was written '
              'from.',
        ),
        const DocsInstallFact(
          label: 'Sibling component',
          value: 'lib/src/components/command.dart',
          description:
              'ElCommand, the inline action launcher that used to share '
              'this page. It has its own page now, at /components/command: '
              'reach for it when the reader knows what they want to do but '
              'not what it is named, and for Combobox when they know '
              'roughly what the value is called.',
        ),
        const DocsInstallFact(
          label: 'Row type',
          value: 'lib/src/components/select.dart',
          description:
              'ElComboboxItem is a typedef for ElSelectOption, so a list '
              'written for ElSelect drops in unchanged and the two stay in '
              'step by construction.',
        ),
        const DocsInstallFact(
          label: 'Package tests',
          value: 'test/selects_test.dart',
          description:
              'The ElCombobox group, including elCollatorContains\' '
              'folding and substring behaviour.',
        ),
        const DocsInstallFact(
          label: 'Docs test',
          value: 'example/test/components_docs/combobox_test.dart',
          description:
              'Covers this page: the section order, every API table, the '
              'live field opening, filtering by substring and committing a '
              'value, the invalid and disabled specimens, and both themes '
              'at two viewport widths.',
        ),
        const DocsInstallFact(
          label: 'Edit these docs',
          value: 'example/lib/components_docs/combobox/page.dart',
          description: 'This file.',
        ),
      ],
    ),
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

const String _usageComboboxCode = '''
import 'package:elattar_design_system/elattar_design_system.dart';

ElCombobox<String>(
  value: selectedSet,
  onChanged: (String next) => setState(() => selectedSet = next),
  placeholder: 'Search sets...',
  emptyLabel: 'No set by that name.',
  items: const <ElComboboxItem<String>>[
    ElComboboxItem<String>(value: 'golden', label: 'Golden Rift'),
    ElComboboxItem<String>(value: 'mystic', label: 'Mystic Surge'),
  ],
)''';

const String _compositionTreeComboboxCode =
    '''ElCombobox<T>                   // one widget, not four
├─ items: List<ElComboboxItem<T>>
│  └─ ElComboboxItem<T>             one option (a ElSelectOption<T>)
│     ├─ value: T                   what onChanged carries back
│     ├─ label: String              what is shown, and what is matched
│     └─ enabled: bool              a row that renders but cannot be picked
├─ value: T?                        the committed selection
└─ (built for you) the input, the chevron trigger, the ElPopover,
                   and the filtered list inside it''';

const String _invalidComboboxCode = '''
ElField(
  label: 'Card set',
  description: 'Start typing to narrow the list.',
  errors: const <String>['Pick a card set to continue.'],
  child: ElCombobox<String>(
    items: cardSets,
    value: selectedSet,
    invalid: submitted && selectedSet == null,
    onChanged: (String next) => setState(() => selectedSet = next),
  ),
)''';

const String _disabledComboboxCode = '''
ElCombobox<String>(
  items: cardSets,
  value: selectedSet,
  onChanged: null,          // enabled: false reaches the same state
  placeholder: 'Search sets...',
)''';

// ── API tables, read off lib/src/components/combobox.dart ───────────────────

const List<DocsApiFact> _comboboxFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'items',
    type: 'List<ElComboboxItem<T>>',
    description:
        'Required. The unfiltered list, in source order, which is also the '
        'order survivors keep. There is no cap: the reference\'s own limit '
        'prop defaults to no limit and is not ported.',
  ),
  DocsApiFact(
    name: 'value',
    type: 'T?',
    description:
        'Required (nullable). The controlled selection. Its label is what '
        'the field shows at rest, and null shows the placeholder instead.',
  ),
  DocsApiFact(
    name: 'onChanged',
    type: 'ValueChanged<T>?',
    description:
        'Required (nullable). Fires with the picked row\'s value. Null '
        'disables the control outright, exactly as enabled: false does.',
  ),
  DocsApiFact(
    name: 'placeholder',
    type: 'String?',
    description: 'Optional. Defaults to null. The field\'s empty hint.',
  ),
  DocsApiFact(
    name: 'emptyLabel',
    type: 'String?',
    description:
        'Optional. Defaults to null, which renders NO empty row at all. '
        'Non-null, it replaces the list whenever the filter leaves '
        'nothing, and the popup drops its own padding for it.',
  ),
  DocsApiFact(
    name: 'enabled',
    type: 'bool',
    description:
        'Optional. Defaults to true. Composes with an enclosing '
        'ElFieldScope the way ElInput and ElSelect do: either end can '
        'disable the control.',
  ),
  DocsApiFact(
    name: 'invalid',
    type: 'bool',
    description:
        'Optional. Defaults to false. Paints the error ring; the message '
        'itself belongs to the surrounding ElField. An enclosing field\'s '
        'own invalid state raises this too.',
  ),
  DocsApiFact(
    name: 'focusNode',
    type: 'FocusNode?',
    description:
        'Optional. Defaults to null, which takes an enclosing field\'s '
        'node if there is one and otherwise owns its own.',
  ),
  DocsApiFact(
    name: 'label',
    type: 'String?',
    description:
        'Optional. Defaults to null, falling back to an enclosing '
        'ElField\'s label. The accessible name: it names the control\'s '
        'semantics node and is passed to the inner input. It renders no '
        'visible label of its own.',
  ),
  DocsApiFact(
    name: 'hint',
    type: 'String?',
    description:
        'Optional. Defaults to null, falling back to an enclosing '
        'ElField\'s description. The accessible DESCRIPTION only: it is '
        'never painted. Visible helper text is the surrounding ElField\'s '
        'job.',
  ),
  DocsApiFact(
    name: 'filter',
    type: 'bool Function(String label, String query)?',
    description:
        'Optional. Defaults to null, which uses elCollatorContains. '
        'Return true to keep the row. It receives the row\'s label and the '
        'trimmed query.',
  ),
];

const List<DocsApiFact> _comboboxStaticFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'ElCombobox.popupOffset',
    type: 'static double',
    description:
        'The gap between the field and its popup, passed straight to the '
        'popover as its side offset.',
  ),
  DocsApiFact(
    name: 'ElCombobox.popupOvershoot',
    type: 'static double',
    description:
        'How much wider than the measured anchor the popup renders. The '
        'anchor is the inner input, not the visible pill, which is why the '
        'popup is wider than one and narrower than the other.',
  ),
  DocsApiFact(
    name: 'ElCombobox.listMaxHeight',
    type: 'static double',
    description:
        'The list\'s own cap, 252px, before the room the positioner '
        'reports is consulted. The smaller of the two wins.',
  ),
  DocsApiFact(
    name: 'ElCombobox.itemHeight',
    type: 'static double',
    description:
        'One row, derived from the sheet-body type spec plus its vertical '
        'padding rather than hardcoded. The popup scrolls the highlight '
        'into view by this measure.',
  ),
  DocsApiFact(
    name: 'ElCombobox.emptyHeight',
    type: 'static double',
    description:
        'The empty row, which is a row in every dimension but its deeper '
        'padding.',
  ),
];

const List<DocsApiFact> _comboboxItemFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'value',
    type: 'T',
    description:
        'Required, and non-nullable here even though the combobox\'s own '
        'value is not. What onChanged carries back, and what the tick is '
        'matched against.',
  ),
  DocsApiFact(
    name: 'label',
    type: 'String',
    description:
        'Required. What the row shows, what the field shows once the row '
        'is committed, and the only text the filter ever sees.',
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
    name: 'ElComboboxItem<T>',
    type: 'typedef = ElSelectOption<T>',
    description:
        'Not a class of its own: the row DATA is the same record ElSelect '
        'carries, so it is the same type, and only the row PAINT lives in '
        'combobox.dart. A list written for ElSelect drops in unchanged.',
  ),
];

const List<DocsApiFact> _collatorFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'label',
    type: 'String',
    description: 'Positional, required. The row text being tested.',
  ),
  DocsApiFact(
    name: 'query',
    type: 'String',
    description:
        'Positional, required. The query typed so far. It is trimmed, then '
        'both sides are case-folded, Latin-diacritic-stripped and '
        'punctuation-skipped before the substring test runs.',
  ),
  DocsApiFact(
    name: 'returns',
    type: 'bool',
    description:
        'True keeps the row. An empty query returns true for every row, '
        'which is what makes an untouched popup show the whole list.',
  ),
];

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Rest, closed',
    treatment:
        'The field shows the selected row\'s label, or the placeholder '
        'when nothing is selected. The popup is not in the tree at all.',
    userSignal: 'An ordinary text field with a chevron.',
  ),
  DocsStateFact(
    state: 'Open',
    treatment:
        'A pointer down on the field, a press on the chevron, or an arrow '
        'key opens the popup, which enters on the shared overlay duration '
        'and out curve. Nothing is highlighted yet.',
    userSignal: 'A list appears under the field, with no row armed.',
  ),
  DocsStateFact(
    state: 'Filtered',
    treatment:
        'Each keystroke re-tests every row and drops the non-matches, '
        'keeping the survivors in source order. Any highlight is cleared, '
        'because the list has moved underneath it.',
    userSignal: 'The list shortens. It never reorders.',
  ),
  DocsStateFact(
    state: 'Highlighted',
    treatment:
        'An arrow key or a hover arms a row. The arrow ring includes the '
        'field itself, so walking past the last row lands nowhere before '
        'wrapping to the first.',
    userSignal: 'One row is filled with the accent colour.',
  ),
  DocsStateFact(
    state: 'Committed',
    treatment:
        'Enter on an armed row, or a tap on any enabled row, writes the '
        'value, closes the popup, and puts the row\'s label in the field. '
        'A disabled row commits nothing.',
    userSignal: 'The popup closes and the field reads the chosen label.',
  ),
  DocsStateFact(
    state: 'Dismissed',
    treatment:
        'Escape or a dismissal from the popover restores whatever the '
        'committed value says the field should read, discarding a '
        'half-typed query.',
    userSignal: 'The field snaps back to the value it already had.',
  ),
  DocsStateFact(
    state: 'Empty',
    treatment:
        'emptyLabel replaces the list when the filter leaves nothing, and '
        'the popup drops its padding so the row is full-bleed. Null '
        'renders no empty row at all.',
    userSignal: 'A centred, muted sentence where the rows were.',
  ),
  DocsStateFact(
    state: 'Invalid',
    treatment:
        'invalid on the control, or an invalid ElField around it, paints '
        'the error ring on the field. Nothing about the popup or the '
        'filter changes.',
    userSignal: 'A red ring; the message comes from the field.',
  ),
  DocsStateFact(
    state: 'Disabled',
    treatment:
        'enabled: false, a null onChanged, or a disabled ElField. The '
        'popup cannot open, the trigger takes no press, and the pointer '
        'listener is not installed.',
    userSignal: 'A faded, inert field.',
  ),
  DocsStateFact(
    state: 'Loading',
    treatment:
        'There is none. A caller doing async work swaps the items list '
        'itself and renders its own progress affordance outside the '
        'field.',
    userSignal: 'Whatever the caller puts in the rows.',
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment:
        'The popup\'s entrance routes through the shared animation '
        'duration, which collapses to zero under '
        'MediaQuery.disableAnimations. Nothing else here animates.',
    userSignal: 'The popup appears without animated travel.',
  ),
];

/// The live combobox.
///
/// The card sets are the package suite's own list. `ElCombobox` mounts its
/// popup through a [ElPopover], so this specimen needs a real [Overlay]
/// above it: the docs shell has one in the app, and `combobox_test.dart`
/// supplies a `MaterialApp`. Without one the popup silently never opens.
class _ComboboxSpecimen extends StatefulWidget {
  const _ComboboxSpecimen();

  @override
  State<_ComboboxSpecimen> createState() => _ComboboxSpecimenState();
}

/// The six sets every specimen on this page draws from.
const List<ElComboboxItem<String>> _cardSets = <ElComboboxItem<String>>[
  ElComboboxItem<String>(value: 'golden', label: 'Golden Rift'),
  ElComboboxItem<String>(value: 'mystic', label: 'Mystic Surge'),
  ElComboboxItem<String>(value: 'shadow', label: 'Shadow Core'),
  ElComboboxItem<String>(value: 'celestial', label: 'Celestial Strike'),
  ElComboboxItem<String>(value: 'origin', label: 'Origin Pulse'),
  ElComboboxItem<String>(value: 'eclipse', label: 'Eclipse Vault'),
];

String? _labelFor(String? value) {
  if (value == null) return null;
  for (final ElComboboxItem<String> item in _cardSets) {
    if (item.value == value) return item.label;
  }
  return null;
}

class _ComboboxSpecimenState extends State<_ComboboxSpecimen> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    final String? label = _labelFor(_selected);
    return KeyedSubtree(
      key: const ValueKey<String>('combobox-doc-combobox-specimen'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ElCombobox<String>(
            items: _cardSets,
            value: _selected,
            onChanged: (String next) => setState(() => _selected = next),
            placeholder: 'Search sets...',
            emptyLabel: 'No set by that name.',
            label: 'Card set',
          ),
          SizedBox(height: el(3)),
          ElText(
            label == null ? 'Nothing selected yet' : 'Selected: $label',
            ElType.small,
            color: theme.mutedForeground,
          ),
        ],
      ),
    );
  }
}

/// The same control wearing the error ring, inside the field that owns the
/// message. `invalid` on the control paints the ring and says nothing.
class _ComboboxInvalidSpecimen extends StatefulWidget {
  const _ComboboxInvalidSpecimen();

  @override
  State<_ComboboxInvalidSpecimen> createState() =>
      _ComboboxInvalidSpecimenState();
}

class _ComboboxInvalidSpecimenState extends State<_ComboboxInvalidSpecimen> {
  String? _selected;

  @override
  Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<String>('combobox-example:invalid'),
    child: ElField(
      label: 'Card set',
      description: 'Start typing to narrow the list.',
      errors: const <String>['Pick a card set to continue.'],
      child: ElCombobox<String>(
        items: _cardSets,
        value: _selected,
        invalid: true,
        onChanged: (String next) => setState(() => _selected = next),
        placeholder: 'Search sets...',
        emptyLabel: 'No set by that name.',
      ),
    ),
  );
}

/// Disabled by a null `onChanged`, which is the most common real cause.
class _ComboboxDisabledSpecimen extends StatelessWidget {
  const _ComboboxDisabledSpecimen();

  @override
  Widget build(BuildContext context) => const KeyedSubtree(
    key: ValueKey<String>('combobox-example:disabled'),
    child: ElCombobox<String>(
      items: _cardSets,
      value: null,
      onChanged: null,
      placeholder: 'Search sets...',
      label: 'Card set',
    ),
  );
}
