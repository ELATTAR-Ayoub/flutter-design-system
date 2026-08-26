/// Public documentation page for the `select` component.
///
/// **Re-housed onto the kit.** This page used to be `SelectDocPage`,
/// hand-composing `ElSection` panels inside
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
/// directly off `lib/src/components/select.dart`'s `_ElSelectState`
/// keyboard handling.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

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
      minHeight: el(160),
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'select has a real registry manifest: elattar add select '
          'installs lib/src/components/select.dart and resolves button, '
          'field, icon, machine-surface, popover, and source-foundation '
          'automatically. The Manual tab is for a project not using the '
          'CLI.',
      command: selectDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/select.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/select.dart's generated "
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
              'Add the export line so ElSelect and its five companion '
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
          'an implementation detail: ElSelectGroup and ElSelectSeparator '
          'sit in the same options list as ElSelectOption.',
      specimen: _GroupedSelectPreview(),
      code: _groupedSelectCode,
      label: 'Grouped menu specimen view',
      minHeight: el(160),
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
          'Every constructor parameter ElSelect declares, ElSelectSize\'s '
          'two rungs, and the four companion classes: one table per '
          'exported class or enum.',
      children: const <DocsTocEntry>[
        DocsTocEntry(title: 'ElSelect', anchor: 'api-elselect'),
        DocsTocEntry(title: 'ElSelectSize', anchor: 'api-elselectsize'),
        DocsTocEntry(title: 'ElSelectOption', anchor: 'api-elselectoption'),
        DocsTocEntry(title: 'ElSelectGroup', anchor: 'api-elselectgroup'),
        DocsTocEntry(
          title: 'ElSelectSeparator',
          anchor: 'api-elselectseparator',
        ),
        DocsTocEntry(title: 'ElSelectMenu', anchor: 'api-elselectmenu'),
      ],
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'Read off _ElSelectState.build and ElSelect\'s own class doc, '
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
                'ElSelect is covered there (87 ElSelect references at the '
                'time this page was written).',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/select_test.dart',
            description:
                'Covers this page: the article mounts, every ElSelect '
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
      eyebrow: 'COMPONENTS / BASE',
      title: selectDoc.title,
      description: selectDoc.description,
    ),
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Components'),
      ElBreadcrumbEntry.page('Select'),
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
  ElSelectSize _size = ElSelectSize.md;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Wrap(
          spacing: el(2),
          runSpacing: el(2),
          children: <Widget>[
            _TogglePill(
              selected: _size == ElSelectSize.md,
              label: 'Size md',
              onPressed: () => setState(() => _size = ElSelectSize.md),
            ),
            _TogglePill(
              selected: _size == ElSelectSize.sm,
              label: 'Size sm',
              onPressed: () => setState(() => _size = ElSelectSize.sm),
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
        SizedBox(height: el(5)),
        ElField(
          label: 'Sort order',
          description:
              'Grouped options stay keyboard-friendly: the arrows skip '
              'labels, separators, and disabled rows.',
          errors: _invalid
              ? const <String>['Choose a sort order before continuing.']
              : const <String>[],
          child: ElSelect<String>(
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
        SizedBox(height: el(4)),
        ElText(
          _value == null ? 'No value selected yet.' : 'Selected: $_value',
          ElType.small,
          color: ElTheme.of(context).mutedForeground,
        ),
      ],
    );
  }
}

const String _previewCode = '''ElField(
  label: 'Sort order',
  description: 'Grouped options stay keyboard-friendly.',
  errors: invalid ? ['Choose a sort order before continuing.'] : [],
  child: ElSelect<String>(
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

const String _usageCode = '''ElSelect<String>(
  options: const <ElSelectChild<String>>[
    ElSelectGroup(
      label: 'Activity',
      children: [
        ElSelectOption(value: 'popular', label: 'Most popular'),
        ElSelectOption(value: 'newest', label: 'Newest'),
      ],
    ),
    ElSelectSeparator(),
    ElSelectGroup(
      label: 'Price',
      children: [
        ElSelectOption(value: 'low', label: 'Price: low to high'),
        ElSelectOption(value: 'high', label: 'Price: high to low'),
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
    return ElField(
      label: 'Category',
      description: 'A grouped menu with semantic sections.',
      child: ElSelect<String>(
        options: _profileOptions,
        value: _category,
        onChanged: (String next) => setState(() => _category = next),
        expand: true,
        label: 'Category',
      ),
    );
  }
}

const String _groupedSelectCode = '''ElSelect<String>(
  options: const <ElSelectChild<String>>[
    ElSelectGroup(
      label: 'Category',
      children: [
        ElSelectOption(value: 'design', label: 'Design & culture'),
        ElSelectOption(value: 'photo', label: 'Photography'),
      ],
    ),
    ElSelectSeparator(),
    ElSelectGroup(
      label: 'Visibility',
      children: [
        ElSelectOption(value: 'public', label: 'Public'),
        ElSelectOption(value: 'private', label: 'Private'),
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
        SizedBox(height: el(5)),
        ElSelect<String>(
          options: _rarityOptions,
          value: _rarity,
          onChanged: (String next) => setState(() => _rarity = next),
          placeholder: 'Any rarity',
          size: ElSelectSize.sm,
          width: _expand ? null : el(40),
          expand: _expand,
          label: 'Rarity',
        ),
      ],
    );
  }
}

const String _selectSizeCode = '''ElSelect<String>(
  options: rarityOptions,
  value: rarity,
  onChanged: onChanged,
  placeholder: 'Any rarity',
  size: ElSelectSize.sm,
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
    return ElButton(
      variant: selected ? ElButtonVariant.primary : ElButtonVariant.secondary,
      size: ElButtonSize.sm,
      label: label,
      onPressed: onPressed,
      child: ElText(label, ElComponentType.buttonLabel),
    );
  }
}

const List<ElSelectChild<String>> _sortOptions = <ElSelectChild<String>>[
  ElSelectGroup<String>(
    label: 'Activity',
    children: <ElSelectOption<String>>[
      ElSelectOption<String>(value: 'popular', label: 'Most popular'),
      ElSelectOption<String>(value: 'newest', label: 'Newest'),
      ElSelectOption<String>(value: 'volatility', label: 'Volatility'),
    ],
  ),
  ElSelectSeparator(),
  ElSelectGroup<String>(
    label: 'Price',
    children: <ElSelectOption<String>>[
      ElSelectOption<String>(value: 'low', label: 'Price: low to high'),
      ElSelectOption<String>(
        value: 'high',
        label: 'Price: high to low',
        enabled: false,
      ),
    ],
  ),
];

const List<ElSelectChild<String>> _profileOptions = <ElSelectChild<String>>[
  ElSelectGroup<String>(
    label: 'Category',
    children: <ElSelectOption<String>>[
      ElSelectOption<String>(value: 'design', label: 'Design & culture'),
      ElSelectOption<String>(value: 'photo', label: 'Photography'),
    ],
  ),
  ElSelectSeparator(),
  ElSelectGroup<String>(
    label: 'Visibility',
    children: <ElSelectOption<String>>[
      ElSelectOption<String>(value: 'public', label: 'Public'),
      ElSelectOption<String>(value: 'private', label: 'Private'),
    ],
  ),
];

const List<ElSelectChild<String>> _rarityOptions = <ElSelectChild<String>>[
  ElSelectOption<String>(value: 'common', label: 'Common'),
  ElSelectOption<String>(value: 'rare', label: 'Rare'),
  ElSelectOption<String>(value: 'mythic', label: 'Mythic'),
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
        child: DocsApiTable(title: 'ElSelect', facts: _selectFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elselectsize',
        child: DocsApiTable(title: 'ElSelectSize', facts: _selectSizeFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elselectoption',
        child: DocsApiTable(
          title: 'ElSelectOption',
          facts: _selectOptionFacts,
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elselectgroup',
        child: DocsApiTable(title: 'ElSelectGroup', facts: _selectGroupFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elselectseparator',
        child: DocsApiTable(
          title: 'ElSelectSeparator',
          facts: _selectSeparatorFacts,
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elselectmenu',
        child: DocsApiTable(title: 'ElSelectMenu', facts: _selectMenuFacts),
      ),
    ],
  );
}

const List<DocsApiFact> _selectFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'options',
    type: 'List<ElSelectChild<T>>',
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
    type: 'ElSelectSize',
    description:
        'Optional. Defaults to ElSelectSize.md. See the ElSelectSize '
        'table below.',
  ),
  DocsApiFact(
    name: 'enabled',
    type: 'bool',
    description:
        'Optional. Defaults to true. ANDed with the enclosing '
        'ElFieldScope\'s.',
  ),
  DocsApiFact(
    name: 'invalid',
    type: 'bool',
    description:
        'Optional. Defaults to false. ORed with the enclosing '
        'ElFieldScope\'s. Destructive border and ring override the '
        'neutral trigger styling.',
  ),
  DocsApiFact(
    name: 'expand',
    type: 'bool',
    description:
        'Optional. Defaults to false. Fills the available form width '
        'when true, the cascade a vertical ElField applies.',
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
        'Optional. A ElFieldScope\'s node wins over the owned one and '
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
    name: 'ElSelect.itemHeight',
    type: 'static double',
    description:
        'One row\'s height — the step item-aligned placement counts in.',
  ),
  DocsApiFact(
    name: 'ElSelect.labelHeight',
    type: 'static double',
    description: 'A ElSelectGroup label row\'s height, 32.',
  ),
  DocsApiFact(
    name: 'ElSelect.separatorHeight',
    type: 'static double',
    description: 'A ElSelectSeparator row\'s height, 17.',
  ),
  DocsApiFact(
    name: 'ElSelect.scrollButtonHeight',
    type: 'static double',
    description: 'A scroll button\'s height, 32.',
  ),
];

const List<DocsApiFact> _selectSizeFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'sm',
    type: 'enum value',
    description: 'A 32px trigger.',
  ),
  DocsApiFact(
    name: 'md',
    type: 'enum value',
    description:
        'The constructor default — a 40px trigger, level with a '
        'default ElInput and ElButton.',
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
    type: 'List<ElSelectOption<T>>',
    description: 'Required. The rows this group holds.',
  ),
];

const List<DocsApiFact> _selectSeparatorFacts = <DocsApiFact>[
  DocsApiFact(
    name: '(no parameters)',
    type: '—',
    description:
        'A const ElSelectSeparator() is the whole of it: a 1px rule '
        'that runs the full content width, contributing 17px to the '
        'item-aligned placement.',
  ),
];

const List<DocsApiFact> _selectMenuFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'children',
    type: 'List<ElSelectChild<T>>',
    description: "Required. The same options list ElSelect itself takes.",
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
    name: 'ElSelectMenu.heightOf(children)',
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
        'selection stops; ElSelectGroup contributes a scroll margin '
        'when the keyboard walks into it.',
    userSignal: 'The menu stays easy to scan and navigate.',
  ),
];

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'Provide a visible ElField label in forms, or pass label for '
            'accessible naming when the trigger stands alone.',
        'placeholder is for the empty-selection state only; it is not '
            'a substitute for labelling the control.',
        'invalid publishes the destructive treatment and semantic '
            'invalid state on the trigger, ORed with the enclosing '
            'ElFieldScope\'s.',
        'Keyboard navigation moves through selectable rows only and '
            'skips group labels, separators, and disabled options.',
      ]);
}

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
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
      _bullets(ElTheme.of(context), <String>[
        'No breakpoint branching anywhere in select.dart: expand and '
            'width are both explicit switches a caller passes, never a '
            'value this file reads off MediaQuery.',
        'Every row height (itemHeight, labelHeight, separatorHeight, '
            'scrollButtonHeight) is a fixed 4px-grid value, read off the '
            'type spec rather than the viewport.',
        'ElPopover\'s own collision handling keeps the popup on-screen '
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
      SizedBox(height: el(4)),
      const DocsLinkRow(
        links: <DocsLink>[
          DocsLink(label: 'Field', route: '/components/field'),
          DocsLink(label: 'Button', route: '/components/button'),
          DocsLink(label: 'Icon', route: '/components/icon'),
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
        description: 'Painted through ElPopoverSurface, shared with every '
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
