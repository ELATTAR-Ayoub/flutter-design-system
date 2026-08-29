/// Public documentation page for the `native_select` component.
///
/// **Re-housed onto the documentation kit** (matching
/// `components_docs/button/page.dart`'s own reference shape): the page is
/// now a `ComponentDocSpec` declaration plus a ten-line widget handing it to
/// `DocsLayout`, rather than a hand-composed `_NativeSelectArticle`. Every
/// specimen and every code string below moved across unchanged from the
/// previous hand-composed page; nothing here was rewritten or reworded. Two
/// changes are new: the live demo is promoted to its own `Preview`
/// `ShowcaseSection` (it used to render ahead of any heading, with no rail
/// entry of its own), and a `Keyboard` disclosure is added between
/// Accessibility and Responsive, carrying the "Closed keyboard" and "Open
/// keyboard" rows moved verbatim out of the old Accessibility panel — that
/// panel already named itself "Keyboard" internally, this just gives it the
/// house section it was missing. The Composition section's own "grouped"
/// code sample is not repeated a second time here: it now lives only on the
/// Groups section below, which already shows it beside a live specimen.
///
/// **native_select** documents [NativeSelect] and [NativeSelectSize]
/// only. `selection_control` and `form` — previously documented on this same
/// page — now have their own pages: `../selection_control/page.dart` and
/// `../form/page.dart`.
///
/// Section shape mirrors `https://ui.shadcn.com/docs/components/base/native-select`
/// section for section: a live demo ahead of any heading, then Installation,
/// Usage, Composition, Groups, Disabled, Invalid, Native select vs select,
/// RTL, and API Reference, in that order, followed by this package's own
/// eight trailing disclosures.
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
import '../../kit.dart' show Panel;
import '../catalog.dart';
import 'meta.dart';

final ComponentDocSpec nativeSelectDocSpec = ComponentDocSpec(
  name: 'native-select',
  title: nativeSelectDoc.title,
  description: nativeSelectDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description: 'A live NativeSelect with a small option list.',
      specimen: const _NativeSelectPreview(),
      code: _previewCode,
      label: 'Preview specimen view',
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'Install with elattar add native-select, or import from the '
          'package barrel when you depend on the package directly.',
      command: nativeSelectDoc.command,
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/native_select.dart',
          code:
              "import 'package:elattar_design_system/"
              "elattar_design_system.dart';\n\n"
              '// Install with `elattar add native-select`, or import from '
              'the package barrel when you depend on the package directly.',
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description: 'NativeSelect wrapped in a Field, with options.',
      code: _usageCode,
    ),
    SnippetSection(
      id: 'composition',
      title: 'Composition',
      description:
          'NativeSelect flattens whatever list it is handed to find the '
          'selected value and to build the open list: a flat list of '
          'SelectOption, or SelectOption wrapped in SelectGroup '
          'under a label (see Groups below for the grouped shape, live). '
          'SelectSeparator is legal in the same list but carries no '
          'specimen of its own.',
      code: _compositionSimpleCode,
    ),
    ShowcaseSection(
      id: 'groups',
      title: 'Groups',
      description:
          'SelectGroup organises related options under a label: the '
          'label paints inside the open list and is skipped by the '
          'keyboard, the same SelectGroup + SelectLabel pair the '
          'reference composes by hand.',
      specimen: const _NativeSelectGroupsPreview(),
      code: _compositionGroupedCode,
      label: 'Groups specimen view',
    ),
    ShowcaseSection(
      id: 'disabled',
      title: 'Disabled',
      description:
          'enabled: false dims the whole wrapper to opacity-50 and stops '
          'it taking pointers, exactly where the reference dims the '
          'wrapper rather than the control. A single SelectOption.'
          'enabled: false keeps the rest of the control live but skips '
          'that one row for both the keyboard and the click.',
      specimen: const _NativeSelectDisabledPreview(),
      code: _disabledCode,
      label: 'Disabled specimen view',
      minHeight: space(96),
    ),
    ShowcaseSection(
      id: 'invalid',
      title: 'Invalid',
      description:
          'invalid: true colours the border and ring destructive and '
          'paints the ring even at rest: the same aria-invalid treatment '
          'the reference\'s class list carries. The enclosing '
          'FieldScope\'s own invalid ORs in, so either side can turn '
          'it on.',
      specimen: const _NativeSelectInvalidPreview(),
      code: _invalidCode,
      label: 'Invalid specimen view',
    ),
    SnippetSection(
      id: 'native-select-vs-select',
      title: 'Native select vs select',
      description:
          'NativeSelect is the platform picker, as far as Flutter can '
          'carry it: the closed control is measured 1:1 with the '
          'reference, arrows step the value while closed, and Alt+Down, '
          'Enter, Space, F4 open the list. The open list is a port-built '
          'SelectMenu, not the OS picker: Flutter has no OS <select> '
          'widget. Select is SelectMenu wearing the Radix menu '
          'component\'s own closed control instead: fully custom, taller '
          '(40px against 32), and the arrows open it directly rather than '
          'stepping a value while it stays shut. Reach for NativeSelect '
          'when the closed-control fidelity and the value-stepping '
          'keyboard matter more than a fully custom look. Reach for '
          'Select everywhere else.',
      code: _vsSelectCode,
    ),
    ShowcaseSection(
      id: 'rtl',
      title: 'RTL',
      description:
          'The closed control\'s text and chevron use '
          'AlignmentDirectional, not a fixed left or right: under a '
          'Directionality.rtl the label starts on the right and the '
          'chevron gutter moves to the left, the same flip the reference '
          'gets from its own logical CSS properties. Nothing in '
          'native_select.dart hardcodes a left-to-right assumption.',
      specimen: const _NativeSelectRtlPreview(),
      code: _rtlCode,
      label: 'RTL specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every constructor parameter NativeSelect declares, its own '
          'static helper, and NativeSelectSize\'s two rungs.',
      children: const <DocsTocEntry>[
        DocsTocEntry(title: 'NativeSelect', anchor: 'api-elnativeselect'),
        DocsTocEntry(
          title: 'NativeSelectSize',
          anchor: 'api-elnativeselectsize',
        ),
      ],
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'Rest, hover, focus, invalid, disabled, and open, across both '
          'size rungs (see NativeSelectSize in API Reference above).',
      child: const DocsStateMatrix(facts: _stateFacts),
    ),
    DisclosureSection(
      id: 'accessibility',
      title: 'Accessibility',
      description: 'The semantic contract; see Keyboard below for the keys.',
      child: const Panel(
        label: 'Semantics',
        child: _A11yRow(
          'Semantics',
          'Wraps the whole subtree in Semantics(button: true, label:, '
              'hint:, value:, expanded:, enabled:). The closed control '
              'shows the selected option as value.',
          last: true,
        ),
      ),
    ),
    DisclosureSection(
      id: 'keyboard',
      title: 'Keyboard',
      description:
          'New: split out of the old Accessibility panel\'s own '
          '"Keyboard" label, moved here verbatim rather than duplicated.',
      child: const Panel(
        label: 'Keyboard',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _A11yRow(
              'Closed keyboard',
              'Arrow up / Arrow down: step the value (not the highlight) '
                  'without opening. Home / End: jump to first / last '
                  'option. Alt+Down / Enter / Space / F4: open the list.',
            ),
            _A11yRow(
              'Open keyboard',
              'Arrow up / Arrow down: move the highlight (wraps around). '
                  'Home / End: jump to first / last. Enter / Space: commit '
                  'the highlighted option. Escape / Tab: close without '
                  'committing.',
              last: true,
            ),
          ],
        ),
      ),
    ),
    DisclosureSection(
      id: 'responsive',
      title: 'Responsive',
      child: _bullets(<String>[
        'expand: true uses double.infinity width; at expand: false is '
            'w-fit. A Field wrapper will stretch it to the field\'s own '
            'width regardless.',
        'Keyboard activation (arrows, Enter, Space, Tab) and pointer '
            'activation (tap) behave identically on every Flutter target.',
        'No breakpoint branching anywhere in native_select.dart: the same '
            'widget tree renders at 390px and 1440px.',
      ]),
    ),
    DisclosureSection(
      id: 'dependencies',
      title: 'Dependencies',
      description: 'What this component needs to install and run.',
      child: _DependenciesContent(),
    ),
    DisclosureSection(
      id: 'theming',
      title: 'Theming',
      child: Panel(
        label: 'What varies with the theme',
        child: StyledText(
          'NativeSelect reads theme.input, theme.ring, and '
          'theme.destructive. Dark mode has a 30%-50% overlay on input; '
          'light mode is transparent. Invalid state uses destructive with '
          'alpha variants.',
          TextStyles.small,
        ),
      ),
    ),
    DisclosureSection(
      id: 'source',
      title: 'Source',
      child: DocsInstallFacts(
        title: 'Source and tests',
        facts: const <DocsInstallFact>[
          DocsInstallFact(
            label: 'Source',
            value: 'lib/src/components/ui/native_select.dart',
            description: 'The one source file.',
          ),
          DocsInstallFact(
            label: 'Docs specimen',
            value: 'example/test/components_docs/native_select_test.dart',
            description:
                'This page\'s own live preview, API-completeness check, '
                'and theme coverage.',
          ),
        ],
      ),
    ),
  ],
);

class NativeSelectDocPage extends StatelessWidget {
  const NativeSelectDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) {
    final ComponentDocEntry entry = nativeSelectDoc;
    return DocsLayout(
      route: entry.route,
      intro: DocsPageIntro(title: entry.title, description: entry.description),
      breadcrumbs: const <BreadcrumbEntry>[
        BreadcrumbEntry.link('Components'),
        BreadcrumbEntry.page('Native Select'),
      ],
      toc: nativeSelectDocSpec.toc,
      previous: const DocsPageLink(
        title: 'Input group',
        route: '/components/input_group',
      ),
      next: const DocsPageLink(title: 'Radio', route: '/components/radio'),
      onNavigate: onNavigate,
      child: KeyedSubtree(
        key: const ValueKey<String>('native-select-doc-article'),
        child: ComponentDocPage(spec: nativeSelectDocSpec, header: false),
      ),
    );
  }
}

/* ── Showcase specimens ─────────────────────────────────────────────────── */

class _A11yRow extends StatelessWidget {
  const _A11yRow(this.label, this.body, {this.last = false});

  final String label;
  final String body;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : space(3)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          StyledText(label, TextStyles.section, color: theme.actionText),
          SizedBox(height: space(1)),
          StyledText(body, TextStyles.small),
        ],
      ),
    );
  }
}

class _NativeSelectPreview extends StatefulWidget {
  const _NativeSelectPreview();

  @override
  State<_NativeSelectPreview> createState() => _NativeSelectPreviewState();
}

class _NativeSelectPreviewState extends State<_NativeSelectPreview> {
  String _country = 'us';

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: Containers.sm),
    child: Field(
      key: const ValueKey<String>('native-select-preview'),
      label: 'Country',
      child: NativeSelect<String>(
        options: const <SelectChild<String>>[
          SelectOption(value: 'us', label: 'United States'),
          SelectOption(value: 'ca', label: 'Canada'),
          SelectOption(value: 'mx', label: 'Mexico'),
        ],
        value: _country,
        onChanged: (String next) => setState(() => _country = next),
      ),
    ),
  );
}

class _NativeSelectGroupsPreview extends StatefulWidget {
  const _NativeSelectGroupsPreview();

  @override
  State<_NativeSelectGroupsPreview> createState() =>
      _NativeSelectGroupsPreviewState();
}

class _NativeSelectGroupsPreviewState
    extends State<_NativeSelectGroupsPreview> {
  String _role = 'engineer';

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: Containers.sm),
    child: Field(
      key: const ValueKey<String>('native-select-groups-preview'),
      label: 'Role',
      child: NativeSelect<String>(
        options: const <SelectChild<String>>[
          SelectGroup<String>(
            label: 'Engineering',
            children: <SelectOption<String>>[
              SelectOption(value: 'engineer', label: 'Engineer'),
              SelectOption(value: 'designer', label: 'Designer'),
            ],
          ),
          SelectGroup<String>(
            label: 'Operations',
            children: <SelectOption<String>>[
              SelectOption(value: 'support', label: 'Support'),
              SelectOption(value: 'sales', label: 'Sales'),
            ],
          ),
        ],
        value: _role,
        onChanged: (String next) => setState(() => _role = next),
      ),
    ),
  );
}

class _NativeSelectDisabledPreview extends StatefulWidget {
  const _NativeSelectDisabledPreview();

  @override
  State<_NativeSelectDisabledPreview> createState() =>
      _NativeSelectDisabledPreviewState();
}

class _NativeSelectDisabledPreviewState
    extends State<_NativeSelectDisabledPreview> {
  String _wholeControl = 'apple';
  String _oneOption = 'apple';

  static const List<SelectOption<String>> _fruits = <SelectOption<String>>[
    SelectOption(value: 'apple', label: 'Apple'),
    SelectOption(value: 'banana', label: 'Banana'),
    SelectOption(value: 'blueberry', label: 'Blueberry'),
  ];

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: Containers.sm),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        StyledText('Whole control disabled', TextStyles.section),
        SizedBox(height: space(3)),
        Field(
          key: const ValueKey<String>('native-select-disabled-preview'),
          label: 'Fruit',
          child: NativeSelect<String>(
            options: _fruits,
            value: _wholeControl,
            onChanged: (String next) => setState(() => _wholeControl = next),
            enabled: false,
          ),
        ),
        SizedBox(height: space(7)),
        StyledText('One option disabled', TextStyles.section),
        SizedBox(height: space(3)),
        Field(
          key: const ValueKey<String>('native-select-disabled-option-preview'),
          label: 'Fruit',
          child: NativeSelect<String>(
            options: const <SelectOption<String>>[
              SelectOption(value: 'apple', label: 'Apple'),
              SelectOption(value: 'banana', label: 'Banana', enabled: false),
              SelectOption(value: 'blueberry', label: 'Blueberry'),
            ],
            value: _oneOption,
            onChanged: (String next) => setState(() => _oneOption = next),
          ),
        ),
      ],
    ),
  );
}

class _NativeSelectInvalidPreview extends StatefulWidget {
  const _NativeSelectInvalidPreview();

  @override
  State<_NativeSelectInvalidPreview> createState() =>
      _NativeSelectInvalidPreviewState();
}

class _NativeSelectInvalidPreviewState
    extends State<_NativeSelectInvalidPreview> {
  String _country = 'us';

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: Containers.sm),
    child: Field(
      key: const ValueKey<String>('native-select-invalid-preview'),
      label: 'Country',
      errors: const <String>['Select a valid country.'],
      child: NativeSelect<String>(
        options: const <SelectChild<String>>[
          SelectOption(value: 'us', label: 'United States'),
          SelectOption(value: 'ca', label: 'Canada'),
          SelectOption(value: 'mx', label: 'Mexico'),
        ],
        value: _country,
        onChanged: (String next) => setState(() => _country = next),
        invalid: true,
      ),
    ),
  );
}

class _NativeSelectRtlPreview extends StatefulWidget {
  const _NativeSelectRtlPreview();

  @override
  State<_NativeSelectRtlPreview> createState() =>
      _NativeSelectRtlPreviewState();
}

class _NativeSelectRtlPreviewState extends State<_NativeSelectRtlPreview> {
  String _country = 'sa';

  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: TextDirection.rtl,
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: Containers.sm),
      child: Field(
        key: const ValueKey<String>('native-select-rtl-preview'),
        label: 'الدولة',
        child: NativeSelect<String>(
          options: const <SelectChild<String>>[
            SelectOption(value: 'sa', label: 'السعودية'),
            SelectOption(value: 'eg', label: 'مصر'),
            SelectOption(value: 'ma', label: 'المغرب'),
          ],
          value: _country,
          onChanged: (String next) => setState(() => _country = next),
        ),
      ),
    ),
  );
}

/* ── Disclosure content ─────────────────────────────────────────────────── */

const String _previewCode =
    '''final List<SelectOption<String>> options = <SelectOption<String>>[
  const SelectOption(value: 'us', label: 'United States'),
  const SelectOption(value: 'ca', label: 'Canada'),
  const SelectOption(value: 'mx', label: 'Mexico'),
];

Field(
  label: 'Country',
  child: NativeSelect<String>(
    options: options,
    value: country,
    onChanged: (String next) => setState(() => country = next),
  ),
)''';

const String _usageCode =
    '''final List<SelectOption<String>> options = <SelectOption<String>>[
  const SelectOption(value: 'us', label: 'United States'),
  const SelectOption(value: 'ca', label: 'Canada'),
  const SelectOption(value: 'mx', label: 'Mexico'),
];

Field(
  label: 'Country',
  child: NativeSelect<String>(
    options: options,
    value: country,
    onChanged: (String next) => setState(() => country = next),
  ),
)''';

const String _compositionSimpleCode = '''NativeSelect<String>(
  options: const <SelectOption<String>>[
    SelectOption(value: 'apple', label: 'Apple'),
    SelectOption(value: 'banana', label: 'Banana'),
    SelectOption(value: 'blueberry', label: 'Blueberry'),
  ],
  value: fruit,
  onChanged: (String next) => setState(() => fruit = next),
)''';

const String _compositionGroupedCode = '''NativeSelect<String>(
  options: const <SelectChild<String>>[
    SelectGroup<String>(
      label: 'Engineering',
      children: <SelectOption<String>>[
        SelectOption(value: 'engineer', label: 'Engineer'),
        SelectOption(value: 'designer', label: 'Designer'),
      ],
    ),
    SelectGroup<String>(
      label: 'Operations',
      children: <SelectOption<String>>[
        SelectOption(value: 'support', label: 'Support'),
        SelectOption(value: 'sales', label: 'Sales'),
      ],
    ),
  ],
  value: role,
  onChanged: (String next) => setState(() => role = next),
)''';

const String _disabledCode = '''Field(
  label: 'Fruit',
  child: NativeSelect<String>(
    options: options,
    value: fruit,
    onChanged: (String next) => setState(() => fruit = next),
    enabled: false, // whole control dimmed and inert
  ),
)

Field(
  label: 'Fruit',
  child: NativeSelect<String>(
    options: const <SelectOption<String>>[
      SelectOption(value: 'apple', label: 'Apple'),
      SelectOption(value: 'banana', label: 'Banana', enabled: false),
      SelectOption(value: 'blueberry', label: 'Blueberry'),
    ],
    value: fruit,
    onChanged: (String next) => setState(() => fruit = next),
    // the control stays live; only Banana is skipped
  ),
)''';

const String _invalidCode = '''Field(
  label: 'Country',
  errors: const <String>['Select a valid country.'],
  child: NativeSelect<String>(
    options: options,
    value: country,
    onChanged: (String next) => setState(() => country = next),
    invalid: true,
  ),
)''';

const String _vsSelectCode = '''NativeSelect<String>(
  options: options,
  value: country,
  onChanged: (String next) => setState(() => country = next),
) // 1:1 closed control, value-stepping keyboard

Select<String>(
  options: options,
  value: country,
  onChanged: (String next) => setState(() => country = next),
) // fully custom, 40px, arrows open the list directly''';

const String _rtlCode = '''Directionality(
  textDirection: TextDirection.rtl,
  child: Field(
    label: 'الدولة',
    child: NativeSelect<String>(
      options: const <SelectChild<String>>[
        SelectOption(value: 'sa', label: 'السعودية'),
        SelectOption(value: 'eg', label: 'مصر'),
        SelectOption(value: 'ma', label: 'المغرب'),
      ],
      value: country,
      onChanged: (String next) => setState(() => country = next),
    ),
  ),
)''';

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      DocsAnchor(
        id: 'api-elnativeselect',
        child: const DocsApiTable(
          title: 'NativeSelect',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'options',
              type: 'List<SelectChild<T>>',
              description:
                  'Required. Flattened to find the selected value; '
                  'includes SelectOption, SelectGroup, and '
                  'SelectSeparator.',
            ),
            DocsApiFact(
              name: 'value',
              type: 'T?',
              description:
                  'Required (nullable). The selected value. null renders '
                  'the first option — an unselected `<select>` does not '
                  'exist.',
            ),
            DocsApiFact(
              name: 'onChanged',
              type: 'ValueChanged<T>?',
              description:
                  'Required (nullable). Fired on commit; null disables.',
            ),
            DocsApiFact(
              name: 'size',
              type: 'NativeSelectSize',
              description:
                  'Optional. Defaults to NativeSelectSize.md. See the '
                  'NativeSelectSize table below.',
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
                  'Optional. Defaults to false. ORed with FieldScope\'s; '
                  'colours the border and ring red.',
            ),
            DocsApiFact(
              name: 'expand',
              type: 'bool',
              description:
                  'Optional. Defaults to false. true makes the control '
                  'double.infinity wide; false is w-fit.',
            ),
            DocsApiFact(
              name: 'width',
              type: 'double?',
              description:
                  'Optional. Defaults to null. Explicit measure; beats '
                  'both expand states.',
            ),
            DocsApiFact(
              name: 'focusNode',
              type: 'FocusNode?',
              description:
                  'Optional. Defaults to null. The node the label focuses '
                  'or a failed submit lands on.',
            ),
            DocsApiFact(
              name: 'label',
              type: 'String?',
              description:
                  'Optional. Defaults to null. Accessible name; routed '
                  'through FieldScope.',
            ),
            DocsApiFact(
              name: 'hint',
              type: 'String?',
              description:
                  'Optional. Defaults to null. aria-describedby; routed '
                  'through FieldScope.',
            ),
            DocsApiFact(
              name: 'NativeSelect.menuOffset',
              type: 'static double (get)',
              description:
                  'space(1) = 4px: the sideOffset between the closed control '
                  'and the open list — PopoverContent\'s own gap, since '
                  'there is no reference for a list the OS draws.',
            ),
          ],
        ),
      ),
      SizedBox(height: space(6)),
      DocsAnchor(
        id: 'api-elnativeselectsize',
        child: const DocsApiTable(
          title: 'NativeSelectSize',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'sm',
              type: 'enum value',
              description: 'h-7 (28px), radius-md (10px), py-0.5.',
            ),
            DocsApiFact(
              name: 'md',
              type: 'enum value',
              description: 'h-8 (32px), radius-lg (12px), py-1. The default.',
            ),
            DocsApiFact(
              name: 'label',
              type: 'String (get)',
              description:
                  'Returns "default" for md, "sm" for sm: the attribute '
                  'value the reference writes.',
            ),
            DocsApiFact(
              name: 'height',
              type: 'double (get)',
              description: 'space(8) = 32 for md, space(7) = 28 for sm.',
            ),
            DocsApiFact(
              name: 'radius',
              type: 'double (get)',
              description: 'Radii.lg = 12 for md, Radii.md = 10 for sm.',
            ),
            DocsApiFact(
              name: 'insetY',
              type: 'double (get)',
              description: 'space(1) = 4 for md, space(0.5) = 2 for sm.',
            ),
          ],
        ),
      ),
    ],
  );
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      DocsInstallFacts(
        facts: const <DocsInstallFact>[
          DocsInstallFact(
            label: 'Registry item',
            value: 'registry/components/native-select.json',
            description: 'Shipped and resolved by `elattar add native-select`.',
          ),
          DocsInstallFact(
            label: 'Source file',
            value: 'native_select.dart',
            description:
                'lib/src/components/ui/native_select.dart, exported from the '
                'public barrel.',
          ),
          DocsInstallFact(
            label: 'Dependencies',
            value: 'source-foundation, popover, select, field',
            description:
                'Depends on SelectMenu (from select.dart), Popover, '
                'and Field (which supplies the focus/label/hint '
                'plumbing).',
          ),
          DocsInstallFact(
            label: 'Platforms',
            value: 'Android, iOS, Web, macOS, Windows, Linux',
            description: 'Pure widget composition; nothing platform-gated.',
          ),
          DocsInstallFact(
            label: 'Verified',
            value: 'this docs specimen',
            description:
                'example/test/components_docs/native_select_test.dart.',
          ),
        ],
      ),
      SizedBox(height: space(2)),
      DocsLinkRow(
        links: const <DocsLink>[
          DocsLink(label: 'Button', route: '/components/button'),
          DocsLink(label: 'Field', route: '/components/field'),
          DocsLink(label: 'Icon', route: '/components/icon'),
          DocsLink(label: 'Surface', route: '/components/surface'),
          DocsLink(label: 'Popover', route: '/components/popover'),
          DocsLink(label: 'Select', route: '/components/select'),
          DocsLink(
            label: 'Source Foundation',
            route: '/components/source_foundation',
          ),
        ],
      ),
    ],
  );
}

Widget _bullets(List<String> lines) => Builder(
  builder: (BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: LayoutWidths.prose),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          for (final String line in lines) ...<Widget>[
            StyledText(
              '•  $line',
              TextStyles.small,
              color: theme.mutedForeground,
            ),
            SizedBox(height: space(2)),
          ],
        ],
      ),
    );
  },
);

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Rest',
    treatment:
        'Transparent fill (light) or input at 30% (dark), 1px input '
        'border, no ring, chevron visible.',
    userSignal:
        'Unlabelled but focusable select, bordered, with a visible '
        'chevron.',
  ),
  DocsStateFact(
    state: 'Focus-visible',
    treatment:
        'Border becomes ring, ring-3 ring-ring/50 animates in over '
        'transitionDefault.',
    userSignal: 'The control is focussed: animated focus ring appears.',
  ),
  DocsStateFact(
    state: 'Invalid',
    treatment:
        'Border and ring become destructive and destructive/20 '
        '(destructive/50 in dark); ring paints even at rest.',
    userSignal: 'Red border and error ring communicate validation failure.',
  ),
  DocsStateFact(
    state: 'Disabled',
    treatment:
        'opacity-50 on the wrapper; the control itself only stops taking '
        'pointers.',
    userSignal:
        'The whole control is dimmed to 50% opacity and does not respond '
        'to input.',
  ),
  DocsStateFact(
    state: 'Hover',
    treatment:
        'Dark mode only: bg-input/50 replaces bg-input/30. Light mode '
        'has no hover state.',
    userSignal:
        'Dark: the background brightens slightly. Light: no visible '
        'change.',
  ),
  DocsStateFact(
    state: 'Open',
    treatment:
        'Border becomes ring; list appears below the control without '
        'animation.',
    userSignal: 'The list is anchored below and becomes the focus target.',
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment: 'Honours prefers-reduced-motion.',
    userSignal:
        'Animations slow or become instantaneous per system preference.',
  ),
];
