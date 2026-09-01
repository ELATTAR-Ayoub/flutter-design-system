/// Public documentation page for the `select` component.
///
/// **Re-housed onto the kit.** This page used to be `SelectDocPage`,
/// hand-composing `Section` panels inside
/// `example/lib/components_docs/input_select_pages.dart` and living outside
/// `componentDocs`. It now declares a `ComponentDocSpec`
/// (`example/lib/docs/component_doc_page.dart`) and hands it to
/// `ComponentDocPage`, the same shape `button`, `field` and `input` already
/// carry. Every specimen widget and every code string below is the same one
/// the hand-composed page carried (`_SelectPreview`, `_GroupedSelectPreview`,
/// `_SelectSizePreview`, `_TogglePill`, and the three option lists); only
/// where they live changed.
///
/// **Section order**, matching the house shape: Preview, Installation,
/// Usage (the smallest correct construction, code-only — the old page's
/// live "Grouped menu" and "Size and width control" examples move to their
/// own sections below it, since `SnippetSection` carries no live
/// specimen), Grouped menu, Size & width, then the eight disclosures. New:
/// a Keyboard disclosure, between Accessibility and Responsive, read
/// directly off `lib/src/components/ui/select.dart`'s `_SelectState`
/// keyboard handling.
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

final ComponentDocSpec selectDocSpec = ComponentDocSpec(
  name: 'select',
  title: selectDoc.title,
  description: selectDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'The menu walks selectable rows only. Group labels and '
          'separators document structure, while disabled rows are '
          'skipped by keyboard navigation. Toggle Size sm, Invalid, and '
          'Disabled to see the trigger respond.',
      specimen: _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
      minHeight: space(160),
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'select has a real registry manifest: elattar add select '
          'installs lib/src/components/ui/select.dart and resolves button, '
          'field, icon, surface, popover, and source-foundation '
          'automatically. The Manual tab is for a project not using the '
          'CLI.',
      command: selectDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/select.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/ui/select.dart's generated "
              '@ui/select.dart payload into components/ui.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated select source here when using manual '
              'mode.',
        ),
        const DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so Select and its five companion '
              'classes are reachable the same way the CLI path already '
              'makes them.',
          code: "export 'select.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'A typed select with grouped options. Every other example on '
          'this page only changes what options renders or a named '
          'argument on the trigger.',
      code: _usageCode,
    ),
    ShowcaseSection(
      id: 'grouped-menu',
      title: 'Grouped menu',
      description:
          'Group labels and separators are part of the public API, not '
          'an implementation detail: SelectGroup and SelectSeparator '
          'sit in the same options list as SelectOption.',
      specimen: _GroupedSelectPreview(),
      code: _groupedSelectCode,
      label: 'Grouped menu specimen view',
      minHeight: space(160),
    ),
    ShowcaseSection(
      id: 'size-width',
      title: 'Size & width',
      description:
          'size controls the trigger height (sm 32px, md 40px). expand '
          'fills the available form width; width, when given, wins over '
          'both.',
      specimen: _SelectSizeSpecimen(),
      code: _selectSizeCode,
      label: 'Size and width specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every constructor parameter Select declares, SelectSize\'s '
          'two rungs, and the four companion classes: one table per '
          'exported class or enum.',
      children: const <DocsTocEntry>[
        DocsTocEntry(title: 'Select', anchor: 'api-elselect'),
        DocsTocEntry(title: 'SelectSize', anchor: 'api-elselectsize'),
        DocsTocEntry(title: 'SelectOption', anchor: 'api-elselectoption'),
        DocsTocEntry(title: 'SelectGroup', anchor: 'api-elselectgroup'),
        DocsTocEntry(title: 'SelectSeparator', anchor: 'api-elselectseparator'),
        DocsTocEntry(title: 'SelectMenu', anchor: 'api-elselectmenu'),
      ],
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'Read off _SelectState.build and Select\'s own class doc, '
          'not inferred.',
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
          'select.dart\'s own menu wraps, unlike menu.dart\'s: the two '
          'families make opposite choices on purpose, and this section '
          'names select\'s.',
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
            value: selectDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'test/selects_test.dart',
            description:
                'Select is covered there (87 Select references at the '
                'time this page was written).',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/select_test.dart',
            description:
                'Covers this page: the article mounts, every Select '
                'constructor parameter this page claims to document, and '
                'both themes at two viewport widths.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/select/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class SelectDocPage extends StatelessWidget {
  const SelectDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: selectDoc.route,
    intro: DocsPageIntro(
      title: selectDoc.title,
      description: selectDoc.description,
    ),
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Components'),
      BreadcrumbEntry.page('Select'),
    ],
    toc: selectDocSpec.toc,
    previous: const DocsPageLink(
      title: 'Scroll area',
      route: '/components/scroll_area',
    ),
    next: const DocsPageLink(
      title: 'Separator',
      route: '/components/separator',
    ),
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('select-doc-article'),
      child: ComponentDocPage(spec: selectDocSpec, header: false),
    ),
  );
}

/* ── Showcase specimens ─────────────────────────────────────────────────── */
// Carried unchanged from the old input_select_pages.dart: the same
// `_SelectPreview`, `_GroupedSelectPreview`, `_SelectSizePreview` and
// `_TogglePill` classes, renamed only to match this page's own specimen
// naming.

class _PreviewSpecimen extends StatefulWidget {
  const _PreviewSpecimen();

  @override
  State<_PreviewSpecimen> createState() => _PreviewSpecimenState();
}

class _PreviewSpecimenState extends State<_PreviewSpecimen> {
  String? _value;
  bool _invalid = false;
  bool _disabled = false;
  SelectSize _size = SelectSize.md;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Wrap(
          spacing: space(2),
          runSpacing: space(2),
          children: <Widget>[
            _TogglePill(
              selected: _size == SelectSize.md,
              label: 'Size md',
              onPressed: () => setState(() => _size = SelectSize.md),
            ),
            _TogglePill(
              selected: _size == SelectSize.sm,
              label: 'Size sm',
              onPressed: () => setState(() => _size = SelectSize.sm),
            ),
            _TogglePill(
              selected: _invalid,
              label: 'Invalid',
              onPressed: () => setState(() => _invalid = !_invalid),
            ),
            _TogglePill(
              selected: _disabled,
              label: 'Disabled',
              onPressed: () => setState(() => _disabled = !_disabled),
            ),
          ],
        ),
        SizedBox(height: space(5)),
        Field(
          label: 'Sort order',
          description:
              'Grouped options stay keyboard-friendly: the arrows skip '
              'labels, separators, and disabled rows.',
          errors: _invalid
              ? const <String>['Choose a sort order before continuing.']
              : const <String>[],
          child: Select<String>(
            options: _sortOptions,
            value: _value,
            onChanged: _disabled
                ? null
                : (String next) => setState(() => _value = next),
            placeholder: 'Choose a sort order',
            size: _size,
            invalid: _invalid,
            expand: true,
            label: 'Sort order',
            hint: _invalid
                ? 'Choose a sort order before continuing.'
                : 'Grouped menu with disabled rows.',
          ),
        ),
        SizedBox(height: space(4)),
        StyledText(
          _value == null ? 'No value selected yet.' : 'Selected: $_value',
          TextStyles.small,
          color: ThemeScope.of(context).mutedForeground,
        ),
      ],
    );
  }
}

const String _previewCode = '''Field(
  label: 'Sort order',
  description: 'Grouped options stay keyboard-friendly.',
  errors: invalid ? ['Choose a sort order before continuing.'] : [],
  child: Select<String>(
    options: sortOptions,
    value: value,
    onChanged: (next) => setState(() => value = next),
    placeholder: 'Choose a sort order',
    size: size,
    invalid: invalid,
    expand: true,
    label: 'Sort order',
  ),
)''';

const String _usageCode = '''Select<String>(
  options: const <SelectChild<String>>[
    SelectGroup(
      label: 'Activity',
      children: [
        SelectOption(value: 'popular', label: 'Most popular'),
        SelectOption(value: 'newest', label: 'Newest'),
      ],
    ),
    SelectSeparator(),
    SelectGroup(
      label: 'Price',
      children: [
        SelectOption(value: 'low', label: 'Price: low to high'),
        SelectOption(value: 'high', label: 'Price: high to low'),
      ],
    ),
  ],
  value: sort,
  onChanged: onSortChanged,
  placeholder: 'Choose a sort order',
  expand: true,
)''';

class _GroupedSelectPreview extends StatefulWidget {
  const _GroupedSelectPreview();

  @override
  State<_GroupedSelectPreview> createState() => _GroupedSelectPreviewState();
}

class _GroupedSelectPreviewState extends State<_GroupedSelectPreview> {
  String? _category = 'design';

  @override
  Widget build(BuildContext context) {
    return Field(
      label: 'Category',
      description: 'A grouped menu with semantic sections.',
      child: Select<String>(
        options: _profileOptions,
        value: _category,
        onChanged: (String next) => setState(() => _category = next),
        expand: true,
        label: 'Category',
      ),
    );
  }
}

const String _groupedSelectCode = '''Select<String>(
  options: const <SelectChild<String>>[
    SelectGroup(
      label: 'Category',
      children: [
        SelectOption(value: 'design', label: 'Design & culture'),
        SelectOption(value: 'photo', label: 'Photography'),
      ],
    ),
    SelectSeparator(),
    SelectGroup(
      label: 'Visibility',
      children: [
        SelectOption(value: 'public', label: 'Public'),
        SelectOption(value: 'private', label: 'Private'),
      ],
    ),
  ],
  value: value,
  onChanged: onChanged,
  expand: true,
)''';

class _SelectSizeSpecimen extends StatefulWidget {
  const _SelectSizeSpecimen();

  @override
  State<_SelectSizeSpecimen> createState() => _SelectSizeSpecimenState();
}

class _SelectSizeSpecimenState extends State<_SelectSizeSpecimen> {
  String? _rarity;
  bool _expand = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _TogglePill(
          selected: _expand,
          label: _expand ? 'Expand on' : 'Expand off',
          onPressed: () => setState(() => _expand = !_expand),
        ),
        SizedBox(height: space(5)),
        Select<String>(
          options: _rarityOptions,
          value: _rarity,
          onChanged: (String next) => setState(() => _rarity = next),
          placeholder: 'Any rarity',
          size: SelectSize.sm,
          width: _expand ? null : space(40),
          expand: _expand,
          label: 'Rarity',
        ),
      ],
    );
  }
}

const String _selectSizeCode = '''Select<String>(
  options: rarityOptions,
  value: rarity,
  onChanged: onChanged,
  placeholder: 'Any rarity',
  size: SelectSize.sm,
  width: 160,
)''';

class _TogglePill extends StatelessWidget {
  const _TogglePill({
    required this.selected,
    required this.label,
    required this.onPressed,
  });

  final bool selected;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Button(
      variant: selected ? ButtonVariant.primary : ButtonVariant.secondary,
      size: ButtonSize.sm,
      label: label,
      onPressed: onPressed,
      child: StyledText(label, TextStyles.nav),
    );
  }
}

const List<SelectChild<String>> _sortOptions = <SelectChild<String>>[
  SelectGroup<String>(
    label: 'Activity',
    children: <SelectOption<String>>[
      SelectOption<String>(value: 'popular', label: 'Most popular'),
      SelectOption<String>(value: 'newest', label: 'Newest'),
      SelectOption<String>(value: 'volatility', label: 'Volatility'),
    ],
  ),
  SelectSeparator(),
  SelectGroup<String>(
    label: 'Price',
    children: <SelectOption<String>>[
      SelectOption<String>(value: 'low', label: 'Price: low to high'),
      SelectOption<String>(
        value: 'high',
        label: 'Price: high to low',
        enabled: false,
      ),
    ],
  ),
];

const List<SelectChild<String>> _profileOptions = <SelectChild<String>>[
  SelectGroup<String>(
    label: 'Category',
    children: <SelectOption<String>>[
      SelectOption<String>(value: 'design', label: 'Design & culture'),
      SelectOption<String>(value: 'photo', label: 'Photography'),
    ],
  ),
  SelectSeparator(),
  SelectGroup<String>(
    label: 'Visibility',
    children: <SelectOption<String>>[
      SelectOption<String>(value: 'public', label: 'Public'),
      SelectOption<String>(value: 'private', label: 'Private'),
    ],
  ),
];

const List<SelectChild<String>> _rarityOptions = <SelectChild<String>>[
  SelectOption<String>(value: 'common', label: 'Common'),
  SelectOption<String>(value: 'rare', label: 'Rare'),
  SelectOption<String>(value: 'mythic', label: 'Mythic'),
];

/* ── Disclosure content ─────────────────────────────────────────────────── */

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsAnchor(
        id: 'api-elselect',
        child: DocsApiTable(title: 'Select', facts: _selectFacts),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elselectsize',
        child: DocsApiTable(title: 'SelectSize', facts: _selectSizeFacts),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elselectoption',
        child: DocsApiTable(title: 'SelectOption', facts: _selectOptionFacts),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elselectgroup',
        child: DocsApiTable(title: 'SelectGroup', facts: _selectGroupFacts),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elselectseparator',
        child: DocsApiTable(
          title: 'SelectSeparator',
          facts: _selectSeparatorFacts,
        ),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elselectmenu',
        child: DocsApiTable(title: 'SelectMenu', facts: _selectMenuFacts),
      ),
    ],
  );
}

const List<DocsApiFact> _selectFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'options',
    type: 'List<SelectChild<T>>',
    description:
        "Required. SelectContent's children — items, groups, and "
        'separators, in menu order.',
  ),
  DocsApiFact(
    name: 'value',
    type: 'T?',
    description:
        'Required. null renders the placeholder state under a muted '
        'ink.',
  ),
  DocsApiFact(
    name: 'onChanged',
    type: 'ValueChanged<T>?',
    description: 'Required. null disables the trigger outright.',
  ),
  DocsApiFact(
    name: 'placeholder',
    type: 'String?',
    description: 'Optional. Shown when value is null.',
  ),
  DocsApiFact(
    name: 'size',
    type: 'SelectSize',
    description:
        'Optional. Defaults to SelectSize.md. See the SelectSize '
        'table below.',
  ),
  DocsApiFact(
    name: 'enabled',
    type: 'bool',
    description:
        'Optional. Defaults to true. ANDed with the enclosing '
        'FieldScope\'s.',
  ),
  DocsApiFact(
    name: 'invalid',
    type: 'bool',
    description:
        'Optional. Defaults to false. ORed with the enclosing '
        'FieldScope\'s. Destructive border and ring override the '
        'neutral trigger styling.',
  ),
  DocsApiFact(
    name: 'expand',
    type: 'bool',
    description:
        'Optional. Defaults to false. Fills the available form width '
        'when true, the cascade a vertical Field applies.',
  ),
  DocsApiFact(
    name: 'width',
    type: 'double?',
    description:
        'Optional. An explicit trigger width. Wins over both expand '
        'and the default hug-content sizing when given.',
  ),
  DocsApiFact(
    name: 'focusNode',
    type: 'FocusNode?',
    description:
        'Optional. A FieldScope\'s node wins over the owned one and '
        'loses to this.',
  ),
  DocsApiFact(
    name: 'label',
    type: 'String?',
    description:
        'Optional. The accessible trigger name when the select has no '
        'visible outer label.',
  ),
  DocsApiFact(
    name: 'hint',
    type: 'String?',
    description:
        'Optional. aria-describedby resolved: description, then error '
        'message.',
  ),
  DocsApiFact(
    name: 'Select.itemHeight',
    type: 'static double',
    description:
        'One row\'s height — the step item-aligned placement counts in.',
  ),
  DocsApiFact(
    name: 'Select.labelHeight',
    type: 'static double',
    description: 'A SelectGroup label row\'s height, 32.',
  ),
  DocsApiFact(
    name: 'Select.separatorHeight',
    type: 'static double',
    description: 'A SelectSeparator row\'s height, 17.',
  ),
  DocsApiFact(
    name: 'Select.scrollButtonHeight',
    type: 'static double',
    description: 'A scroll button\'s height, 32.',
  ),
];

const List<DocsApiFact> _selectSizeFacts = <DocsApiFact>[
  DocsApiFact(name: 'sm', type: 'enum value', description: 'A 32px trigger.'),
  DocsApiFact(
    name: 'md',
    type: 'enum value',
    description:
        'The constructor default — a 40px trigger, level with a '
        'default Input and Button.',
  ),
];

const List<DocsApiFact> _selectOptionFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'value',
    type: 'T',
    description: 'Required. The typed value this row commits.',
  ),
  DocsApiFact(
    name: 'label',
    type: 'String',
    description: "Required. The row's visible text.",
  ),
  DocsApiFact(
    name: 'enabled',
    type: 'bool',
    description:
        'Optional. Defaults to true. A disabled option stays visible '
        'but is skipped by keyboard and pointer selection.',
  ),
];

const List<DocsApiFact> _selectGroupFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'label',
    type: 'String?',
    description:
        "Optional. The group's own SelectLabel text. null is legal — a "
        'group with no visible label.',
  ),
  DocsApiFact(
    name: 'children',
    type: 'List<SelectOption<T>>',
    description: 'Required. The rows this group holds.',
  ),
];

const List<DocsApiFact> _selectSeparatorFacts = <DocsApiFact>[
  DocsApiFact(
    name: '(no parameters)',
    type: '—',
    description:
        'A const SelectSeparator() is the whole of it: a 1px rule '
        'that runs the full content width, contributing 17px to the '
        'item-aligned placement.',
  ),
];

const List<DocsApiFact> _selectMenuFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'children',
    type: 'List<SelectChild<T>>',
    description: "Required. The same options list Select itself takes.",
  ),
  DocsApiFact(
    name: 'selected',
    type: 'T?',
    description: 'Required. The row that wears the tick.',
  ),
  DocsApiFact(
    name: 'highlighted',
    type: 'int',
    description: 'Required. The row the keyboard is on.',
  ),
  DocsApiFact(
    name: 'onPick',
    type: 'ValueChanged<int>',
    description: 'Required. Called with an index into the selectable rows.',
  ),
  DocsApiFact(
    name: 'onHover',
    type: 'ValueChanged<int>',
    description: 'Required. Called as the pointer moves over a row.',
  ),
  DocsApiFact(
    name: 'initialScrollOffset',
    type: 'double',
    description:
        'Optional. Defaults to 0. Where item-aligned placement starts '
        'the viewport when the content is too tall to be placed by '
        'moving the box.',
  ),
  DocsApiFact(
    name: 'SelectMenu.heightOf(children)',
    type: 'static double',
    description:
        'The height children renders at, p-2 included — what a caller '
        'needs before the menu exists in order to place it.',
  ),
];

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Placeholder',
    treatment: 'null value shows muted placeholder text in the trigger.',
    userSignal: 'The user still has to make a selection.',
  ),
  DocsStateFact(
    state: 'Selected',
    treatment:
        'Trigger shows the current label; item-aligned placement opens '
        'the menu with the chosen row over the trigger.',
    userSignal: 'The current value is visible before opening the menu.',
  ),
  DocsStateFact(
    state: 'Invalid',
    treatment:
        'Destructive border and ring override the neutral trigger '
        'styling, and beat focus.',
    userSignal: 'The selection needs correction, announced semantically.',
  ),
  DocsStateFact(
    state: 'Disabled',
    treatment:
        'Trigger dims to 50% opacity and can no longer open the menu. '
        '_openMenu early-returns on a menu with no selectable row, so '
        'a select whose every option is disabled cannot open either.',
    userSignal: 'The field is unavailable in the current workflow.',
  ),
  DocsStateFact(
    state: 'Disabled option',
    treatment:
        'The row stays visible but is skipped by keyboard and pointer '
        'selection.',
    userSignal:
        'Users can see the unavailable choice without accidentally '
        'selecting it.',
  ),
  DocsStateFact(
    state: 'Grouped menu',
    treatment:
        'Labels and separators structure the menu but are not '
        'selection stops; SelectGroup contributes a scroll margin '
        'when the keyboard walks into it.',
    userSignal: 'The menu stays easy to scan and navigate.',
  ),
];

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Provide a visible Field label in forms, or pass label for '
            'accessible naming when the trigger stands alone.',
        'placeholder is for the empty-selection state only; it is not '
            'a substitute for labelling the control.',
        'invalid publishes the destructive treatment and semantic '
            'invalid state on the trigger, ORed with the enclosing '
            'FieldScope\'s.',
        'Keyboard navigation moves through selectable rows only and '
            'skips group labels, separators, and disabled options.',
      ]);
}

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'ArrowDown / ArrowUp move the highlight one row; unlike '
            'menu.dart\'s own menu, this one wraps: past the last row '
            'the highlight returns to the first, and past the first it '
            'returns to the last.',
        'Enter and Space commit the highlighted row and close the '
            'menu.',
        'Escape closes the menu without committing a selection.',
        'Typing a printable character jumps to the next row whose '
            'text starts with it, the same typeahead the menu family '
            'shares.',
        'A disabled trigger (enabled: false, or every option disabled) '
            'is removed from keyboard traversal entirely.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'No breakpoint branching anywhere in select.dart: expand and '
            'width are both explicit switches a caller passes, never a '
            'value this file reads off MediaQuery.',
        'Every row height (itemHeight, labelHeight, separatorHeight, '
            'scrollButtonHeight) is a fixed 4px-grid value, read off the '
            'type spec rather than the viewport.',
        'Popover\'s own collision handling keeps the popup on-screen '
            'near a viewport edge; select.dart repeats none of that '
            'logic itself.',
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
            label: 'Registry item',
            value: 'registry/components/select.json',
            description: 'Installable through the CLI today.',
          ),
          const DocsInstallFact(
            label: 'Destination',
            value: 'lib/components/ui/select.dart',
            description:
                'The same lib/components/ui/ target every component '
                'installs to.',
          ),
          DocsInstallFact(
            label: 'Dependencies',
            value: selectDoc.dependencies.join(', '),
            description:
                "The manifest's registryDependencies, resolved "
                'automatically. popover supplies the menu\'s placement '
                'and elevation surface; icon supplies the chevron.',
          ),
        ],
      ),
      SizedBox(height: space(4)),
      const DocsLinkRow(
        links: <DocsLink>[
          DocsLink(label: 'Field', route: '/components/field'),
          DocsLink(label: 'Button', route: '/components/button'),
          DocsLink(label: 'Icon', route: '/components/icon'),
          DocsLink(label: 'Popover', route: '/components/popover'),
          DocsLink(label: 'Surface', route: '/components/surface'),
          DocsLink(
            label: 'Source Foundation',
            route: '/components/source_foundation',
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
        label: 'theme.card / theme.input',
        value: 'Trigger fill and border',
        description:
            'Dark mode alone sinks the fill to theme.input at 30% '
            '(50% on hover) — the only control in the family with a '
            'light-mode-absent hover treatment.',
      ),
      DocsInstallFact(
        label: 'theme.ring',
        value: 'Focus ring',
        description: '50% alpha, beaten outright by invalid.',
      ),
      DocsInstallFact(
        label: 'theme.destructive',
        value: 'Invalid border and ring',
        description: '20% alpha light, 40% dark.',
      ),
      DocsInstallFact(
        label: 'theme.popover',
        value: 'Menu content fill',
        description:
            'Painted through PopoverSurface, shared with every '
            'other popover-backed control.',
      ),
      DocsInstallFact(
        label: 'theme.mutedForeground',
        value: 'Placeholder and chevron ink',
        description: 'Full opacity in both themes.',
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
