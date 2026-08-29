/// Public documentation page for the `combobox` component.
///
/// **Re-housed onto the kit.** This page used to hand-compose `Section`
/// panels; it now declares a `ComponentDocSpec`
/// (`example/lib/docs/component_doc_page.dart`) and hands it to
/// `ComponentDocPage`, the same shape `button` established. Every specimen
/// widget and every code string the old page carried moves across
/// unchanged; Filtering carried a bulleted explanation with no quoted
/// source before, and now shows `collatorContains`'s own body verbatim,
/// since a `ShowcaseSection`/`SnippetSection` is a specimen AND its source.
///
/// **Split from a combined page.** `Combobox<T>` used to be documented on
/// `../command/page.dart`, sharing one entry with `Command` on the
/// argument that two "filter as you type" surfaces read as one idea. They
/// are two separately barrel-exported public components with two source
/// files, so each now owns a page: everything about `Combobox` moved here
/// and is gone from the command page, not duplicated.
///
/// **Section order**, matching `button`'s own house shape: Preview (the old
/// un-headed live demo, promoted to a real section with a rail entry),
/// Installation, Usage, then this component's own sections (Composition,
/// Filtering, Invalid, Disabled), then the eight disclosures.
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
/// `Combobox` genuinely does not have; rather than fake one, each is
/// named in the Composition section's own quoted "skipped" notes.
///
/// **This one is an overlay.** `Combobox` mounts its list through
/// [Popover], which is an [OverlayPortal], so every live specimen here
/// needs a real [Overlay] above it or the popup silently never opens: a
/// `MaterialApp` ancestor is enough, and `combobox_test.dart` supplies one.
/// A test that forgot it would pass while exercising nothing.
///
/// New: a Keyboard disclosure, between Accessibility and Responsive, read
/// directly off `lib/src/components/ui/combobox.dart`'s own `_onKey`: the
/// caret-stays-in-the-field fact that used to live in Accessibility moved
/// there with it.
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

final ComponentDocSpec comboboxDocSpec = ComponentDocSpec(
  name: 'combobox',
  title: comboboxDoc.title,
  description: comboboxDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'Live. Tap the field or its chevron to open the popup, type to '
          'narrow it, and pick a row: the value is kept and the label '
          'stays in the field.',
      specimen: _ComboboxSpecimen(),
      code: _usageComboboxCode,
      label: 'Preview specimen view',
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'combobox is a registry item: elattar add combobox resolves it '
          'and its dependencies and copies the source into your project. '
          'The Manual tab is for a project not using the CLI.',
      command: comboboxDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/combobox.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/ui/combobox.dart's generated "
              '@ui/combobox.dart payload into components/ui. The file '
              'needs its sibling dependencies too: see Dependencies below.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated combobox source here when using '
              'manual mode.',
        ),
        const DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so Combobox, ComboboxItem and '
              'collatorContains are reachable the same way the CLI path '
              'already makes them.',
          code: "export 'combobox.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'Controlled, like every other form control here: the value '
          'lives at the call site and comes back through onChanged. Every '
          'example below only changes named arguments on top of this.',
      code: _usageComboboxCode,
    ),
    SnippetSection(
      id: 'composition',
      title: 'Composition',
      description:
          'shadcn assembles Combobox from four caller-composed pieces '
          '(Combobox.Root, Combobox.Input, Combobox.List, Combobox.Item). '
          'This port is one widget configured through data instead, so '
          'the shape below is a data hierarchy rather than a widget tree: '
          'the input, its trigger button, the popover and the filtered '
          'list are built for you and are not addressable from a call '
          'site.',
      code: _compositionComboboxCode,
    ),
    SnippetSection(
      id: 'filtering',
      title: 'Filtering',
      description:
          "Not in shadcn's own section list, and the thing most worth "
          'knowing before choosing this component over its sibling: '
          'nothing is ranked, and nothing ever moves up the list. '
          'collatorContains(label, query) is a folded substring match: '
          'both sides are case-folded, Latin-diacritic-stripped and '
          'punctuation-skipped before the test runs, so typing "rift" '
          'finds Golden Rift even though the query starts mid-word, and '
          'an empty query matches everything, which is what makes an '
          'untouched popup show the whole list. Pass filter to substitute '
          'a predicate of your own; return true to keep the row. '
          'DIVERGENCE, recorded rather than hidden: the reference builds '
          'a real Intl.Collator, and ICU\'s collation table is not in '
          'this port — folding case and stripping Latin diacritics IS '
          'base sensitivity for the Latin script, but a script with its '
          'own collation rules (Turkish dotless i, German sharp s, '
          'Japanese kana equivalence) would diverge. One bypass is '
          'ported deliberately too: until the query has changed since '
          'the popup opened, the list is NOT narrowed to the '
          'already-selected label, so reopening after a pick shows every '
          'row again.',
      code: _filterCode,
    ),
    ShowcaseSection(
      id: 'invalid',
      title: 'Invalid',
      description:
          'The same control wearing the error ring, for a failed field '
          'validation. The message itself belongs to the surrounding '
          'Field, the way Input and Select already work: invalid on '
          'the control paints the ring and says nothing. An enclosing '
          "field's own invalid state reaches the control too, so either "
          'end can raise it.',
      specimen: _ComboboxInvalidSpecimen(),
      code: _invalidComboboxCode,
      label: 'Invalid specimen view',
    ),
    ShowcaseSection(
      id: 'disabled',
      title: 'Disabled',
      description:
          'Non-interactive: the popup never opens and the trigger button '
          'takes no press. Three separate things reach this state, and '
          'any one of them is enough: enabled: false, a null onChanged, '
          'or a disabled Field around it. A null onChanged is the most '
          'common real cause, because it usually falls out of a form '
          'with nothing to submit to yet.',
      specimen: _ComboboxDisabledSpecimen(),
      code: _disabledComboboxCode,
      label: 'Disabled specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every constructor parameter, static helper and top-level '
          'function lib/src/components/ui/combobox.dart declares: one table '
          'each, read off the real constructors.',
      children: const <DocsTocEntry>[
        DocsTocEntry(title: 'Combobox', anchor: 'api-elcombobox'),
        DocsTocEntry(
          title: 'Combobox static helpers',
          anchor: 'api-elcombobox-static',
        ),
        DocsTocEntry(title: 'ComboboxItem', anchor: 'api-elcomboboxitem'),
        DocsTocEntry(
          title: 'collatorContains',
          anchor: 'api-elcollatorcontains',
        ),
      ],
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'Read off _DsComboboxState, not inferred. The popup is an '
          'overlay, so open and closed are real states here in a way '
          'they are not for the inline palette next door.',
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
      description:
          "Read off lib/src/components/ui/combobox.dart's own _onKey "
          'directly: a Focus ancestor of the text field, so it sees the '
          "field's own key events before EditableText's shortcuts turn "
          'them into a caret move.',
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
            value: comboboxDoc.sourcePath,
            description:
                'Authoritative implementation: Combobox, ComboboxItem '
                'and collatorContains. The truth this page was written '
                'from.',
          ),
          const DocsInstallFact(
            label: 'Sibling component',
            value: 'lib/src/components/ui/command.dart',
            description:
                'Command, the inline action launcher that used to '
                'share this page. It has its own page now, at '
                '/components/command: reach for it when the reader '
                'knows what they want to do but not what it is named, '
                'and for Combobox when they know roughly what the value '
                'is called.',
          ),
          const DocsInstallFact(
            label: 'Row type',
            value: 'lib/src/components/ui/select.dart',
            description:
                'ComboboxItem is a typedef for SelectOption, so a '
                'list written for Select drops in unchanged and the '
                'two stay in step by construction.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'test/selects_test.dart',
            description:
                "The Combobox group, including collatorContains' "
                'folding and substring behaviour.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/combobox_test.dart',
            description:
                'Covers this page: the section order, every API table, '
                'the live field opening, filtering by substring and '
                'committing a value, the invalid and disabled specimens, '
                'and both themes at two viewport widths.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/combobox/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class ComboboxDocPage extends StatelessWidget {
  const ComboboxDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: comboboxDoc.route,
    intro: DocsPageIntro(
      title: comboboxDoc.title,
      description: comboboxDoc.description,
    ),
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Components'),
      BreadcrumbEntry.page('Combobox'),
    ],
    toc: comboboxDocSpec.toc,
    previous: const DocsPageLink(
      title: 'Command',
      route: '/components/command',
    ),
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('combobox-doc-article'),
      child: ComponentDocPage(spec: comboboxDocSpec, header: false),
    ),
  );
}

/* ── Showcase specimens ─────────────────────────────────────────────────── */

const String _usageComboboxCode = '''
import 'package:elattar_design_system/elattar_design_system.dart';

Combobox<String>(
  value: selectedSet,
  onChanged: (String next) => setState(() => selectedSet = next),
  placeholder: 'Search sets...',
  emptyLabel: 'No set by that name.',
  items: const <ComboboxItem<String>>[
    ComboboxItem<String>(value: 'golden', label: 'Golden Rift'),
    ComboboxItem<String>(value: 'mystic', label: 'Mystic Surge'),
  ],
)''';

const String _compositionComboboxCode =
    '''Combobox<T>                   // one widget, not four
├─ items: List<ComboboxItem<T>>
│  └─ ComboboxItem<T>             one option (a SelectOption<T>)
│     ├─ value: T                   what onChanged carries back
│     ├─ label: String              what is shown, and what is matched
│     └─ enabled: bool              a row that renders but cannot be picked
├─ value: T?                        the committed selection
└─ (built for you) the input, the chevron trigger, the Popover,
                   and the filtered list inside it

// Skipped, honestly — capabilities this port genuinely does not have:
// Custom Items: rows are data, not children. There is no item builder.
// Multiple Selection / Multiple: single-select by construction, one T?.
// Clear Button: no showClear flag and no clear affordance at all.
// Groups: the list is flat; ComboboxItem carries no group heading.
// Auto Highlight: nothing is highlighted until an arrow key moves.
// Popup: one shape only, an input with a chevron addon.
// Input Group: the field IS an input group internally, but not exposed.
// RTL: no Directionality/TextDirection branch in combobox.dart.''';

const String _filterCode =
    '''bool collatorContains(String label, String query) {
  final String needle = _fold(query.trim());
  return needle.isEmpty || _fold(label).contains(needle);
}''';

const String _invalidComboboxCode = '''
Field(
  label: 'Card set',
  description: 'Start typing to narrow the list.',
  errors: const <String>['Pick a card set to continue.'],
  child: Combobox<String>(
    items: cardSets,
    value: selectedSet,
    invalid: submitted && selectedSet == null,
    onChanged: (String next) => setState(() => selectedSet = next),
  ),
)''';

const String _disabledComboboxCode = '''
Combobox<String>(
  items: cardSets,
  value: selectedSet,
  onChanged: null,          // enabled: false reaches the same state
  placeholder: 'Search sets...',
)''';

/// The live combobox.
///
/// The card sets are the package suite's own list. `Combobox` mounts its
/// popup through a [Popover], so this specimen needs a real [Overlay]
/// above it: the docs shell has one in the app, and `combobox_test.dart`
/// supplies a `MaterialApp`. Without one the popup silently never opens.
class _ComboboxSpecimen extends StatefulWidget {
  const _ComboboxSpecimen();

  @override
  State<_ComboboxSpecimen> createState() => _ComboboxSpecimenState();
}

/// The six sets every specimen on this page draws from.
const List<ComboboxItem<String>> _cardSets = <ComboboxItem<String>>[
  ComboboxItem<String>(value: 'golden', label: 'Golden Rift'),
  ComboboxItem<String>(value: 'mystic', label: 'Mystic Surge'),
  ComboboxItem<String>(value: 'shadow', label: 'Shadow Core'),
  ComboboxItem<String>(value: 'celestial', label: 'Celestial Strike'),
  ComboboxItem<String>(value: 'origin', label: 'Origin Pulse'),
  ComboboxItem<String>(value: 'eclipse', label: 'Eclipse Vault'),
];

String? _labelFor(String? value) {
  if (value == null) return null;
  for (final ComboboxItem<String> item in _cardSets) {
    if (item.value == value) return item.label;
  }
  return null;
}

class _ComboboxSpecimenState extends State<_ComboboxSpecimen> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final String? label = _labelFor(_selected);
    return KeyedSubtree(
      key: const ValueKey<String>('combobox-doc-combobox-specimen'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Combobox<String>(
            items: _cardSets,
            value: _selected,
            onChanged: (String next) => setState(() => _selected = next),
            placeholder: 'Search sets...',
            emptyLabel: 'No set by that name.',
            label: 'Card set',
          ),
          SizedBox(height: space(3)),
          StyledText(
            label == null ? 'Nothing selected yet' : 'Selected: $label',
            TextStyles.small,
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
    child: Field(
      label: 'Card set',
      description: 'Start typing to narrow the list.',
      errors: const <String>['Pick a card set to continue.'],
      child: Combobox<String>(
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
    child: Combobox<String>(
      items: _cardSets,
      value: null,
      onChanged: null,
      placeholder: 'Search sets...',
      label: 'Card set',
    ),
  );
}

/* ── Disclosure content ─────────────────────────────────────────────────── */

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsAnchor(
        id: 'api-elcombobox',
        child: DocsApiTable(title: 'Combobox<T>', facts: _comboboxFacts),
      ),
      SizedBox(height: space(6)),
      const DocsAnchor(
        id: 'api-elcombobox-static',
        child: DocsApiTable(
          title: 'Combobox static helpers',
          facts: _comboboxStaticFacts,
        ),
      ),
      SizedBox(height: space(6)),
      const DocsAnchor(
        id: 'api-elcomboboxitem',
        child: DocsApiTable(
          title: 'ComboboxItem<T> (= SelectOption<T>)',
          facts: _comboboxItemFacts,
        ),
      ),
      SizedBox(height: space(6)),
      const DocsAnchor(
        id: 'api-elcollatorcontains',
        child: DocsApiTable(
          title: 'collatorContains(label, query) → bool',
          facts: _collatorFacts,
        ),
      ),
    ],
  );
}

const List<DocsApiFact> _comboboxFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'items',
    type: 'List<ComboboxItem<T>>',
    description:
        'Required. The unfiltered list, in source order, which is also '
        "the order survivors keep. There is no cap: the reference's own "
        'limit prop defaults to no limit and is not ported.',
  ),
  DocsApiFact(
    name: 'value',
    type: 'T?',
    description:
        'Required (nullable). The controlled selection. Its label is '
        'what the field shows at rest, and null shows the placeholder '
        'instead.',
  ),
  DocsApiFact(
    name: 'onChanged',
    type: 'ValueChanged<T>?',
    description:
        "Required (nullable). Fires with the picked row's value. Null "
        'disables the control outright, exactly as enabled: false does.',
  ),
  DocsApiFact(
    name: 'placeholder',
    type: 'String?',
    description: "Optional. Defaults to null. The field's empty hint.",
  ),
  DocsApiFact(
    name: 'emptyLabel',
    type: 'String?',
    description:
        'Optional. Defaults to null, which renders NO empty row at all. '
        'Non-null, it replaces the list whenever the filter leaves '
        "nothing, and the popup drops its own padding for it.",
  ),
  DocsApiFact(
    name: 'enabled',
    type: 'bool',
    description:
        'Optional. Defaults to true. Composes with an enclosing '
        'FieldScope the way Input and Select do: either end can '
        'disable the control.',
  ),
  DocsApiFact(
    name: 'invalid',
    type: 'bool',
    description:
        'Optional. Defaults to false. Paints the error ring; the '
        'message itself belongs to the surrounding Field. An '
        "enclosing field's own invalid state raises this too.",
  ),
  DocsApiFact(
    name: 'focusNode',
    type: 'FocusNode?',
    description:
        "Optional. Defaults to null, which takes an enclosing field's "
        'node if there is one and otherwise owns its own.',
  ),
  DocsApiFact(
    name: 'label',
    type: 'String?',
    description:
        "Optional. Defaults to null, falling back to an enclosing "
        "Field's label. The accessible name: it names the control's "
        'semantics node and is passed to the inner input. It renders no '
        'visible label of its own.',
  ),
  DocsApiFact(
    name: 'hint',
    type: 'String?',
    description:
        "Optional. Defaults to null, falling back to an enclosing "
        "Field's description. The accessible DESCRIPTION only: it is "
        "never painted. Visible helper text is the surrounding Field's "
        'job.',
  ),
  DocsApiFact(
    name: 'filter',
    type: 'bool Function(String label, String query)?',
    description:
        'Optional. Defaults to null, which uses collatorContains. '
        "Return true to keep the row. It receives the row's label and "
        'the trimmed query.',
  ),
];

const List<DocsApiFact> _comboboxStaticFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'Combobox.popupOffset',
    type: 'static double',
    description:
        'The gap between the field and its popup, passed straight to '
        'the popover as its side offset.',
  ),
  DocsApiFact(
    name: 'Combobox.popupOvershoot',
    type: 'static double',
    description:
        'How much wider than the measured anchor the popup renders. '
        'The anchor is the inner input, not the visible pill, which is '
        'why the popup is wider than one and narrower than the other.',
  ),
  DocsApiFact(
    name: 'Combobox.listMaxHeight',
    type: 'static double',
    description:
        "The list's own cap, 252px, before the room the positioner "
        'reports is consulted. The smaller of the two wins.',
  ),
  DocsApiFact(
    name: 'Combobox.itemHeight',
    type: 'static double',
    description:
        'One row, derived from the sheet-body type spec plus its '
        'vertical padding rather than hardcoded. The popup scrolls the '
        'highlight into view by this measure.',
  ),
  DocsApiFact(
    name: 'Combobox.emptyHeight',
    type: 'static double',
    description:
        'The empty row, which is a row in every dimension but its '
        'deeper padding.',
  ),
];

const List<DocsApiFact> _comboboxItemFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'value',
    type: 'T',
    description:
        "Required, and non-nullable here even though the combobox's own "
        'value is not. What onChanged carries back, and what the tick '
        'is matched against.',
  ),
  DocsApiFact(
    name: 'label',
    type: 'String',
    description:
        'Required. What the row shows, what the field shows once the '
        'row is committed, and the only text the filter ever sees.',
  ),
  DocsApiFact(
    name: 'enabled',
    type: 'bool',
    description:
        'Optional. Defaults to true. A disabled row still renders and '
        'is still filtered, but fades and can be neither highlighted '
        'nor committed: the arrows step over it.',
  ),
  DocsApiFact(
    name: 'ComboboxItem<T>',
    type: 'typedef = SelectOption<T>',
    description:
        'Not a class of its own: the row DATA is the same record '
        'Select carries, so it is the same type, and only the row '
        'PAINT lives in combobox.dart. A list written for Select '
        'drops in unchanged.',
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
        'Positional, required. The query typed so far. It is trimmed, '
        'then both sides are case-folded, Latin-diacritic-stripped and '
        'punctuation-skipped before the substring test runs.',
  ),
  DocsApiFact(
    name: 'returns',
    type: 'bool',
    description:
        'True keeps the row. An empty query returns true for every '
        'row, which is what makes an untouched popup show the whole '
        'list.',
  ),
];

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Rest, closed',
    treatment:
        "The field shows the selected row's label, or the placeholder "
        'when nothing is selected. The popup is not in the tree at all.',
    userSignal: 'An ordinary text field with a chevron.',
  ),
  DocsStateFact(
    state: 'Open',
    treatment:
        'A pointer down on the field, a press on the chevron, or an '
        'arrow key opens the popup, which enters on the shared overlay '
        'duration and out curve. Nothing is highlighted yet.',
    userSignal: 'A list appears under the field, with no row armed.',
  ),
  DocsStateFact(
    state: 'Filtered',
    treatment:
        'Each keystroke re-tests every row and drops the non-matches, '
        'keeping the survivors in source order. Any highlight is '
        'cleared, because the list has moved underneath it.',
    userSignal: 'The list shortens. It never reorders.',
  ),
  DocsStateFact(
    state: 'Highlighted',
    treatment:
        'An arrow key or a hover arms a row. The arrow ring includes '
        'the field itself, so walking past the last row lands nowhere '
        'before wrapping to the first.',
    userSignal: 'One row is filled with the accent colour.',
  ),
  DocsStateFact(
    state: 'Committed',
    treatment:
        'Enter on an armed row, or a tap on any enabled row, writes '
        "the value, closes the popup, and puts the row's label in the "
        'field. A disabled row commits nothing.',
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
        'emptyLabel replaces the list when the filter leaves nothing, '
        'and the popup drops its padding so the row is full-bleed. Null '
        'renders no empty row at all.',
    userSignal: 'A centred, muted sentence where the rows were.',
  ),
  DocsStateFact(
    state: 'Invalid',
    treatment:
        'invalid on the control, or an invalid Field around it, '
        'paints the error ring on the field. Nothing about the popup '
        'or the filter changes.',
    userSignal: 'A red ring; the message comes from the field.',
  ),
  DocsStateFact(
    state: 'Disabled',
    treatment:
        'enabled: false, a null onChanged, or a disabled Field. The '
        'popup cannot open, the trigger takes no press, and the '
        'pointer listener is not installed.',
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
        "The popup's entrance routes through the shared animation "
        'duration, which collapses to zero under '
        'MediaQuery.disableAnimations. Nothing else here animates.',
    userSignal: 'The popup appears without animated travel.',
  ),
];

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      _bullets(ThemeScope.of(context), <String>[
        'The control reports itself as a text field carrying its '
            'expanded state, named by label or by an enclosing '
            "Field's label, and described by hint or that field's own "
            'description. Each row reports as a button carrying its '
            'selected and enabled state.',
        'The trigger button carries its own name, which flips between '
            'Open and Close with the popup, though on this page the '
            'field takes the focus and the arrows drive the popup '
            'instead.',
      ]),
      SizedBox(height: space(3)),
      StyledText(
        'Known gaps, reported not idealised',
        TextStyles.section,
        color: ThemeScope.of(context).actionText,
      ),
      SizedBox(height: space(2)),
      _bullets(ThemeScope.of(context), <String>[
        'Known gap: no live region. Nothing announces how many rows '
            'survived the filter. A sighted reader sees the list '
            'collapse from six rows to one; a screen-reader user is '
            'told nothing, and finds out only by arrowing through what '
            'is left. The reference has the same hole, and closing it '
            'means adding a live region that speaks the result count on '
            'each keystroke: a real change to the component, not a '
            'parameter.',
        'Known gap: the highlight is painted but not announced. No '
            'relationship is wired from the field to the row Enter '
            'would commit, so assistive tech does not read the active '
            'option as the highlight moves.',
        'Known gap: no listbox role wiring. The popup does not declare '
            'itself a listbox owning a set of options, so it reads as '
            'ordinary content that happens to have appeared.',
        'Known gap: no way back to empty. With no clear affordance and '
            "no null in onChanged's type, a reader who has picked a "
            'value cannot un-pick one; the caller has to offer that '
            'some other way.',
      ]),
    ],
  );
}

/// Read directly off `lib/src/components/ui/combobox.dart`'s own `_onKey`: a
/// `Focus` ancestor of the text field, so it sees the field's own key
/// events before `EditableText`'s shortcuts turn them into a caret move.
class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'The caret never leaves the field. Arrow keys move a highlight '
            'rather than focus, so typing keeps working throughout: the '
            'key handler is a Focus(canRequestFocus: false, '
            'skipTraversal: true) wrapped ABOVE the text field, so it '
            "sees ArrowDown before the field's own EditableText "
            'shortcuts turn it into a caret move.',
        'ArrowDown or ArrowUp on a closed field opens the popup without '
            'moving anything; on an open one they move the highlight. '
            'The ring wraps THROUGH the field: past the last row the '
            'highlight comes off the list entirely (index −1) before '
            'starting again, the listbox-with-an-input behaviour '
            'base-ui implements.',
        'Enter commits the highlighted row, and does nothing at all '
            'when the popup is closed or nothing is highlighted: an '
            'unmoved popup has no armed row, by design.',
        'Escape closes the popup and puts the committed value\'s label '
            'back in the field; it does nothing at all on an already '
            'closed popup.',
        'Any other key falls through: KeyEventResult.ignored lets it '
            'keep propagating to the field underneath, which is what '
            'lets ordinary typing narrow the list on every keystroke '
            'that is not one of the four above.',
        'Tab order: canRequestFocus: false on the key-capturing Focus '
            'means it is never itself a tab stop; the real tab stop is '
            'the underlying InputGroupInput, one focus node for the '
            'whole control, not one per row.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'No breakpoint branching anywhere in combobox.dart: '
            'BuildContext width is never read for a layout decision, '
            'and the same widget tree renders at 390px and 1440px.',
        'The popup sizes itself from the MEASURED anchor width plus a '
            'fixed overshoot, and the anchor is the inner input rather '
            'than the visible pill, so the popup ends up wider than the '
            'input and narrower than the field it hangs under. That is '
            'reproduced reference behaviour, not a layout accident.',
        'Its height is the smaller of the component\'s own cap and the '
            'room the positioner reports, so a popup near the bottom of '
            'a short viewport shrinks and scrolls rather than '
            'overflowing, and it flips above the field when there is '
            'more room up there.',
        'Row text is single-line and ellipsised rather than wrapped, '
            'so a long label shortens instead of growing the row.',
        'Platform parity: Android, iOS, Web, macOS, Windows and Linux '
            'all render the same tree. No dart:io Platform branch '
            'anywhere in the file.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      _bullets(ThemeScope.of(context), <String>[
        'File: lib/src/components/ui/combobox.dart. One file, no '
            'companions, and a shipped registry manifest.',
        'Flutter imports: dart:math (clamping the popup height), '
            'package:flutter/services.dart (LogicalKeyboardKey, '
            'KeyEvent), package:flutter/widgets.dart.',
        'Foundation imports: foundation/motion.dart, '
            'foundation/spacing.dart (space()), foundation/theme.dart, '
            'foundation/typography.dart, theme_scope.dart (StyledText, '
            'ThemeScope).',
        'Component imports: field.dart (FieldScope, so an enclosing '
            'field can supply the label, the focus node, and the '
            'enabled and invalid states), icon.dart and icon_paths.dart '
            '(the chevron and the tick), input_group.dart (InputGroup, '
            'InputGroupInput, InputGroupAddon, InputGroupButton: '
            'the whole chassis), popover.dart (Popover and '
            'PopoverSurface: the overlay), select.dart '
            '(SelectOption, which ComboboxItem is a typedef for).',
        'Notably NOT imported: input.dart. The text field here is '
            'InputGroupInput, not Input, which is the one '
            'dependency this component does not share with the command '
            'palette.',
        'Assets: none. Shaders: none.',
      ]),
      SizedBox(height: space(4)),
      const DocsLinkRow(
        links: <DocsLink>[
          DocsLink(label: 'Field', route: '/components/field'),
          DocsLink(label: 'Icon', route: '/components/icon'),
          DocsLink(label: 'Input group', route: '/components/input_group'),
          DocsLink(label: 'Popover', route: '/components/popover'),
          DocsLink(label: 'Select', route: '/components/select'),
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
            'the field from the input-group recipe, the popup surface '
            'from popover, a row\'s ink from popoverForeground, the '
            'highlighted row from accent with accentForeground ink, and '
            'the empty row from mutedForeground. Flipping '
            'ThemeController re-resolves all of them on the next '
            'frame.',
        'The popup is a PopoverSurface, so its fill, radius, shadow '
            'and ring are the shared overlay recipe rather than '
            'anything this component owns: a change there moves every '
            'popup in the system together.',
        'Type is by role, never by size: rows and the empty row both '
            'read the sheet-body spec, and the empty row differs from a '
            'row only in its padding and its ink.',
        'Shape is fixed rather than parameterised: the popup clips at '
            'the large radius and a row corners at medium. No '
            'caller-facing radius parameter exists.',
        "The popup's entrance is the shared overlay duration on the "
            'shared out curve, which collapses to nothing under a '
            'reduced-motion setting. Worth naming as reproduced drift: '
            'this popup animates while the select popup, same design '
            'system and the same overlay job, does not.',
        'The trigger button is the one button in the system whose '
            'press cancels its own fill, which is a real reference '
            'behaviour reproduced through a dedicated parameter rather '
            'than a local restyle.',
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
