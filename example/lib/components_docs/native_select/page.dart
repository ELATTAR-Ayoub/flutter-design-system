/// Public component documentation for the `native_select` component.
///
/// **native_select** documents [ElNativeSelect] and [ElNativeSelectSize]
/// only. `selection_control` and `form` — previously documented on this same
/// page — now have their own pages: `../selection_control/page.dart` and
/// `../form/page.dart`.
///
/// Section shape mirrors `https://ui.shadcn.com/docs/components/base/native-select`
/// section for section: a live demo ahead of any heading, then Installation,
/// Usage, Composition, Groups, Disabled, Invalid, Native select vs select,
/// RTL, and API Reference, in that order, followed by this package's own six
/// trailing sections (States, Accessibility, Responsive, Dependencies,
/// Theming, Source).
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/docs_code.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../kit.dart';
import '../catalog.dart';
import 'meta.dart';

class NativeSelectDocPage extends StatelessWidget {
  const NativeSelectDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) {
    final ComponentDocEntry entry = nativeSelectDoc;
    return DocsLayout(
      route: entry.route,
      intro: DocsPageIntro(
        eyebrow: 'COMPONENTS / BASE',
        title: entry.title,
        description: entry.description,
      ),
      breadcrumbs: const <ElBreadcrumbEntry>[
        ElBreadcrumbEntry.link('Components'),
        ElBreadcrumbEntry.page('Native Select'),
      ],
      toc: const <DocsTocEntry>[
        DocsTocEntry(title: 'Installation', anchor: 'install'),
        DocsTocEntry(title: 'Usage', anchor: 'usage'),
        DocsTocEntry(title: 'Composition', anchor: 'composition'),
        DocsTocEntry(title: 'Groups', anchor: 'groups'),
        DocsTocEntry(title: 'Disabled', anchor: 'disabled'),
        DocsTocEntry(title: 'Invalid', anchor: 'invalid'),
        DocsTocEntry(
          title: 'Native select vs select',
          anchor: 'native-select-vs-select',
        ),
        DocsTocEntry(title: 'RTL', anchor: 'rtl'),
        DocsTocEntry(
          title: 'API Reference',
          anchor: 'api',
          children: <DocsTocEntry>[
            DocsTocEntry(title: 'ElNativeSelect', anchor: 'api-elnativeselect'),
            DocsTocEntry(
              title: 'ElNativeSelectSize',
              anchor: 'api-elnativeselectsize',
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
        title: 'Input group',
        route: '/components/input_group',
      ),
      next: const DocsPageLink(title: 'Radio', route: '/components/radio'),
      onNavigate: onNavigate,
      child: _NativeSelectArticle(entry: entry),
    );
  }
}

class _NativeSelectArticle extends StatelessWidget {
  const _NativeSelectArticle({required this.entry});

  final ComponentDocEntry entry;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      key: const ValueKey<String>('native-select-doc-article'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        // The live demo, ahead of any heading: the same shape the reference
        // page itself opens with. No ElSection wraps it, so it carries no
        // Overview/Status/Preview heading of its own before Installation.
        DocsCodeExample(
          title: 'Live specimen',
          description: 'A live ElNativeSelect with a small option list.',
          preview: const _NativeSelectPreview(),
          command: DocsCodeCommand(command: entry.command),
        ),
        SizedBox(height: el(8)),
        ElSection(
          id: 'install',
          title: 'Installation',
          description:
              'Install with lattar add native-select, or import from the package barrel when you depend on the package directly.',
          child: DocsCodeExample(
            title: 'Package import',
            command: DocsCodeCommand(
              command: entry.command,
              description:
                  'Import ElNativeSelect from the public barrel: no CLI '
                  'command yet.',
            ),
            manualFiles: const <DocsCodeFile>[
              DocsCodeFile(
                path: 'lib/native_select.dart',
                code:
                    "import 'package:elattar_design_system/"
                    "elattar_design_system.dart';\n\n"
                    '// Install with `elattar add native-select`, or import from the package barrel when you depend on the package directly.',
              ),
            ],
          ),
        ),
        ElSection(
          id: 'usage',
          title: 'Usage',
          description: 'ElNativeSelect wrapped in a ElField, with options.',
          child: ElPanel(
            label: 'DART',
            note: 'MINIMAL',
            child: DocsSelectableCodeBlock(code: _usageCode),
          ),
        ),
        ElSection(
          id: 'composition',
          title: 'Composition',
          description:
              'ElNativeSelect flattens whatever list it is handed to find '
              'the selected value and to build the open list: a flat list '
              'of ElSelectOption, or ElSelectOption wrapped in ElSelectGroup '
              'under a label. ElSelectSeparator is legal in the same list '
              'but carries no specimen of its own.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ElPanel(
                label: 'DART',
                note: 'SIMPLE: A FLAT LIST OF OPTIONS',
                child: DocsSelectableCodeBlock(code: _compositionSimpleCode),
              ),
              SizedBox(height: el(5)),
              ElPanel(
                label: 'DART',
                note: 'WITH GROUPS: OPTIONS WRAPPED IN ElSelectGroup',
                child: DocsSelectableCodeBlock(code: _compositionGroupedCode),
              ),
            ],
          ),
        ),
        ElSection(
          id: 'groups',
          title: 'Groups',
          description:
              'ElSelectGroup organises related options under a label: the '
              'label paints inside the open list and is skipped by the '
              'keyboard, the same SelectGroup + SelectLabel pair the '
              'reference composes by hand.',
          child: DocsCodeExample(
            title: 'Grouped options',
            preview: const _NativeSelectGroupsPreview(),
            manualFiles: const <DocsCodeFile>[
              DocsCodeFile(
                path: 'grouped_native_select.dart',
                code: _compositionGroupedCode,
              ),
            ],
          ),
        ),
        ElSection(
          id: 'disabled',
          title: 'Disabled',
          description:
              'enabled: false dims the whole wrapper to opacity-50 and '
              'stops it taking pointers, exactly where the reference dims '
              'the wrapper rather than the control. A single '
              'ElSelectOption.enabled: false keeps the rest of the control '
              'live but skips that one row for both the keyboard and the '
              'click.',
          child: DocsCodeExample(
            title: 'Disabled control and disabled option',
            preview: const _NativeSelectDisabledPreview(),
            manualFiles: const <DocsCodeFile>[
              DocsCodeFile(
                path: 'disabled_native_select.dart',
                code: _disabledCode,
              ),
            ],
          ),
        ),
        ElSection(
          id: 'invalid',
          title: 'Invalid',
          description:
              'invalid: true colours the border and ring destructive and '
              'paints the ring even at rest: the same aria-invalid '
              'treatment the reference\'s class list carries. The '
              'enclosing ElFieldScope\'s own invalid ORs in, so either side '
              'can turn it on.',
          child: DocsCodeExample(
            title: 'Invalid select',
            preview: const _NativeSelectInvalidPreview(),
            manualFiles: const <DocsCodeFile>[
              DocsCodeFile(
                path: 'invalid_native_select.dart',
                code: _invalidCode,
              ),
            ],
          ),
        ),
        ElSection(
          id: 'native-select-vs-select',
          title: 'Native select vs select',
          description: 'When to reach for which.',
          child: _bullets(theme, <String>[
            'ElNativeSelect is the platform picker, as far as Flutter can '
                'carry it: the closed control is measured 1:1 with the '
                'reference, arrows step the value while closed, and '
                'Alt+Down, Enter, Space, F4 open the list. The open list is '
                'a port-built ElSelectMenu, not the OS picker: Flutter has '
                'no OS <select> widget.',
            'ElSelect is ElSelectMenu wearing the Radix menu component\'s '
                'own closed control instead: fully custom, taller (40px '
                'against 32), and the arrows open it directly rather than '
                'stepping a value while it stays shut.',
            'Reach for ElNativeSelect when the closed-control fidelity and '
                'the value-stepping keyboard matter more than a fully '
                'custom look. Reach for ElSelect everywhere else.',
          ]),
        ),
        ElSection(
          id: 'rtl',
          title: 'RTL',
          description:
              'The closed control\'s text and chevron use '
              'AlignmentDirectional, not a fixed left or right: under a '
              'Directionality.rtl the label starts on the right and the '
              'chevron gutter moves to the left, the same flip the '
              'reference gets from its own logical CSS properties. Nothing '
              'in native_select.dart hardcodes a left-to-right assumption.',
          child: const DocsCodeExample(
            title: 'Right-to-left select',
            preview: _NativeSelectRtlPreview(),
          ),
        ),
        ElSection(
          id: 'api',
          title: 'API Reference',
          description:
              'Every constructor parameter ElNativeSelect declares, its own '
              'static helper, and ElNativeSelectSize\'s two rungs.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              KeyedSubtree(
                key: docsAnchorKey('api-elnativeselect'),
                child: const DocsApiTable(
                  title: 'ElNativeSelect',
                  facts: <DocsApiFact>[
                    DocsApiFact(
                      name: 'options',
                      type: 'List<ElSelectChild<T>>',
                      description:
                          'Required. Flattened to find the selected value; '
                          'includes ElSelectOption, ElSelectGroup, and '
                          'ElSelectSeparator.',
                    ),
                    DocsApiFact(
                      name: 'value',
                      type: 'T?',
                      description:
                          'Required (nullable). The selected value. null '
                          'renders the first option — an unselected '
                          '`<select>` does not exist.',
                    ),
                    DocsApiFact(
                      name: 'onChanged',
                      type: 'ValueChanged<T>?',
                      description:
                          'Required (nullable). Fired on commit; null '
                          'disables.',
                    ),
                    DocsApiFact(
                      name: 'size',
                      type: 'ElNativeSelectSize',
                      description:
                          'Optional. Defaults to ElNativeSelectSize.md. See '
                          'the ElNativeSelectSize table below.',
                    ),
                    DocsApiFact(
                      name: 'enabled',
                      type: 'bool',
                      description:
                          'Optional. Defaults to true. ANDed with the '
                          'enclosing ElFieldScope\'s.',
                    ),
                    DocsApiFact(
                      name: 'invalid',
                      type: 'bool',
                      description:
                          'Optional. Defaults to false. ORed with '
                          'ElFieldScope\'s; colours the border and ring red.',
                    ),
                    DocsApiFact(
                      name: 'expand',
                      type: 'bool',
                      description:
                          'Optional. Defaults to false. true makes the '
                          'control double.infinity wide; false is w-fit.',
                    ),
                    DocsApiFact(
                      name: 'width',
                      type: 'double?',
                      description:
                          'Optional. Defaults to null. Explicit measure; '
                          'beats both expand states.',
                    ),
                    DocsApiFact(
                      name: 'focusNode',
                      type: 'FocusNode?',
                      description:
                          'Optional. Defaults to null. The node the label '
                          'focuses or a failed submit lands on.',
                    ),
                    DocsApiFact(
                      name: 'label',
                      type: 'String?',
                      description:
                          'Optional. Defaults to null. Accessible name; '
                          'routed through ElFieldScope.',
                    ),
                    DocsApiFact(
                      name: 'hint',
                      type: 'String?',
                      description:
                          'Optional. Defaults to null. '
                          'aria-describedby; routed through ElFieldScope.',
                    ),
                    DocsApiFact(
                      name: 'ElNativeSelect.menuOffset',
                      type: 'static double (get)',
                      description:
                          'el(1) = 4px: the sideOffset between the closed '
                          'control and the open list — PopoverContent\'s own '
                          'gap, since there is no reference for a list the '
                          'OS draws.',
                    ),
                  ],
                ),
              ),
              SizedBox(height: el(6)),
              KeyedSubtree(
                key: docsAnchorKey('api-elnativeselectsize'),
                child: const DocsApiTable(
                  title: 'ElNativeSelectSize',
                  facts: <DocsApiFact>[
                    DocsApiFact(
                      name: 'sm',
                      type: 'enum value',
                      description: 'h-7 (28px), radius-md (10px), py-0.5.',
                    ),
                    DocsApiFact(
                      name: 'md',
                      type: 'enum value',
                      description:
                          'h-8 (32px), radius-lg (12px), py-1. The default.',
                    ),
                    DocsApiFact(
                      name: 'label',
                      type: 'String (get)',
                      description:
                          'Returns "default" for md, "sm" for sm: the '
                          'attribute value the reference writes.',
                    ),
                    DocsApiFact(
                      name: 'height',
                      type: 'double (get)',
                      description: 'el(8) = 32 for md, el(7) = 28 for sm.',
                    ),
                    DocsApiFact(
                      name: 'radius',
                      type: 'double (get)',
                      description:
                          'ElRadii.lg = 12 for md, ElRadii.md = 10 for sm.',
                    ),
                    DocsApiFact(
                      name: 'insetY',
                      type: 'double (get)',
                      description: 'el(1) = 4 for md, el(0.5) = 2 for sm.',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        ElSection(
          id: 'states',
          title: 'States',
          description:
              'Rest, hover, focus, invalid, disabled, and open, across both '
              'size rungs (see ElNativeSelectSize in API Reference above).',
          child: const DocsStateMatrix(
            facts: <DocsStateFact>[
              DocsStateFact(
                state: 'Rest',
                treatment:
                    'Transparent fill (light) or input at 30% (dark), 1px '
                    'input border, no ring, chevron visible.',
                userSignal:
                    'Unlabelled but focusable select, bordered, with a '
                    'visible chevron.',
              ),
              DocsStateFact(
                state: 'Focus-visible',
                treatment:
                    'Border becomes ring, ring-3 ring-ring/50 animates in '
                    'over transitionDefault.',
                userSignal:
                    'The control is focussed: animated focus ring appears.',
              ),
              DocsStateFact(
                state: 'Invalid',
                treatment:
                    'Border and ring become destructive and destructive/20 '
                    '(destructive/50 in dark); ring paints even at rest.',
                userSignal:
                    'Red border and error ring communicate validation '
                    'failure.',
              ),
              DocsStateFact(
                state: 'Disabled',
                treatment:
                    'opacity-50 on the wrapper; the control itself only '
                    'stops taking pointers.',
                userSignal:
                    'The whole control is dimmed to 50% opacity and does '
                    'not respond to input.',
              ),
              DocsStateFact(
                state: 'Hover',
                treatment:
                    'Dark mode only: bg-input/50 replaces bg-input/30. '
                    'Light mode has no hover state.',
                userSignal:
                    'Dark: the background brightens slightly. Light: no '
                    'visible change.',
              ),
              DocsStateFact(
                state: 'Open',
                treatment:
                    'Border becomes ring; list appears below the control '
                    'without animation.',
                userSignal:
                    'The list is anchored below and becomes the focus '
                    'target.',
              ),
              DocsStateFact(
                state: 'Reduced motion',
                treatment: 'Honours prefers-reduced-motion.',
                userSignal:
                    'Animations slow or become instantaneous per system '
                    'preference.',
              ),
            ],
          ),
        ),
        ElSection(
          id: 'accessibility',
          title: 'Accessibility',
          description: 'The keyboard and semantic contract.',
          child: ElPanel(
            label: 'Keyboard',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const _A11yRow(
                  'Closed keyboard',
                  'Arrow up / Arrow down: step the value (not the '
                      'highlight) without opening. Home / End: jump to first / '
                      'last option. Alt+Down / Enter / Space / F4: open the list.',
                ),
                const _A11yRow(
                  'Open keyboard',
                  'Arrow up / Arrow down: move the highlight (wraps around). '
                      'Home / End: jump to first / last. Enter / Space: commit '
                      'the highlighted option. Escape / Tab: close without '
                      'committing.',
                ),
                _A11yRow(
                  'Semantics',
                  'Wraps the whole subtree in Semantics(button: true, '
                      'label:, hint:, value:, expanded:, enabled:). The closed '
                      'control shows the selected option as value.',
                  last: true,
                ),
              ],
            ),
          ),
        ),
        ElSection(
          id: 'responsive',
          title: 'Responsive',
          child: _bullets(theme, <String>[
            'expand: true uses double.infinity width; at expand: false is '
                'w-fit. A ElField wrapper will stretch it to the field\'s '
                'own width regardless.',
            'Keyboard activation (arrows, Enter, Space, Tab) and pointer '
                'activation (tap) behave identically on every Flutter '
                'target.',
            'No breakpoint branching anywhere in native_select.dart: the '
                'same widget tree renders at 390px and 1440px.',
          ]),
        ),
        ElSection(
          id: 'dependencies',
          title: 'Dependencies',
          description: 'What this component needs to install and run.',
          child: DocsInstallFacts(
            facts: <DocsInstallFact>[
              const DocsInstallFact(
                label: 'Registry item',
                value: 'registry/components/native-select.json',
                description:
                    'Shipped and resolved by `elattar add native-select`.',
              ),
              const DocsInstallFact(
                label: 'Source file',
                value: 'native_select.dart',
                description:
                    'lib/src/components/native_select.dart, exported from '
                    'the public barrel.',
              ),
              const DocsInstallFact(
                label: 'Dependencies',
                value: 'source-foundation, popover, select, field',
                description:
                    'Depends on ElSelectMenu (from select.dart), ElPopover, '
                    'and ElField (which supplies the focus/label/hint '
                    'plumbing).',
              ),
              const DocsInstallFact(
                label: 'Platforms',
                value: 'Android, iOS, Web, macOS, Windows, Linux',
                description: 'Pure widget composition; nothing platform-gated.',
              ),
              const DocsInstallFact(
                label: 'Verified',
                value: 'this docs specimen',
                description:
                    'example/test/components_docs/native_select_test.dart.',
              ),
            ],
          ),
        ),
        ElSection(
          id: 'theming',
          title: 'Theming',
          child: ElPanel(
            label: 'What varies with the theme',
            child: ElText(
              'ElNativeSelect reads theme.input, theme.ring, and '
              'theme.destructive. Dark mode has a 30%-50% overlay on input; '
              'light mode is transparent. Invalid state uses destructive '
              'with alpha variants.',
              ElType.small,
            ),
          ),
        ),
        ElSection(
          id: 'source',
          title: 'Source',
          child: DocsInstallFacts(
            title: 'Source and tests',
            facts: const <DocsInstallFact>[
              DocsInstallFact(
                label: 'Source',
                value: 'lib/src/components/native_select.dart',
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
  }
}

Widget _bullets(ElThemeData theme, List<String> lines) => ConstrainedBox(
  constraints: const BoxConstraints(maxWidth: ElWidths.prose),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      for (final String line in lines) ...<Widget>[
        ElText('•  $line', ElType.small, color: theme.mutedForeground),
        SizedBox(height: el(2)),
      ],
    ],
  ),
);

class _A11yRow extends StatelessWidget {
  const _A11yRow(this.label, this.body, {this.last = false});

  final String label;
  final String body;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : el(3)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ElText(label, ElType.label, color: theme.actionInk),
          SizedBox(height: el(1)),
          ElText(body, ElType.small),
        ],
      ),
    );
  }
}

const String _usageCode =
    '''final List<ElSelectOption<String>> options = <ElSelectOption<String>>[
  const ElSelectOption(value: 'us', label: 'United States'),
  const ElSelectOption(value: 'ca', label: 'Canada'),
  const ElSelectOption(value: 'mx', label: 'Mexico'),
];

ElField(
  label: 'Country',
  child: ElNativeSelect<String>(
    options: options,
    value: country,
    onChanged: (String next) => setState(() => country = next),
  ),
)''';

const String _compositionSimpleCode = '''ElNativeSelect<String>(
  options: const <ElSelectOption<String>>[
    ElSelectOption(value: 'apple', label: 'Apple'),
    ElSelectOption(value: 'banana', label: 'Banana'),
    ElSelectOption(value: 'blueberry', label: 'Blueberry'),
  ],
  value: fruit,
  onChanged: (String next) => setState(() => fruit = next),
)''';

const String _compositionGroupedCode = '''ElNativeSelect<String>(
  options: const <ElSelectChild<String>>[
    ElSelectGroup<String>(
      label: 'Engineering',
      children: <ElSelectOption<String>>[
        ElSelectOption(value: 'engineer', label: 'Engineer'),
        ElSelectOption(value: 'designer', label: 'Designer'),
      ],
    ),
    ElSelectGroup<String>(
      label: 'Operations',
      children: <ElSelectOption<String>>[
        ElSelectOption(value: 'support', label: 'Support'),
        ElSelectOption(value: 'sales', label: 'Sales'),
      ],
    ),
  ],
  value: role,
  onChanged: (String next) => setState(() => role = next),
)''';

const String _disabledCode = '''ElField(
  label: 'Fruit',
  child: ElNativeSelect<String>(
    options: options,
    value: fruit,
    onChanged: (String next) => setState(() => fruit = next),
    enabled: false, // whole control dimmed and inert
  ),
)

ElField(
  label: 'Fruit',
  child: ElNativeSelect<String>(
    options: const <ElSelectOption<String>>[
      ElSelectOption(value: 'apple', label: 'Apple'),
      ElSelectOption(value: 'banana', label: 'Banana', enabled: false),
      ElSelectOption(value: 'blueberry', label: 'Blueberry'),
    ],
    value: fruit,
    onChanged: (String next) => setState(() => fruit = next),
    // the control stays live; only Banana is skipped
  ),
)''';

const String _invalidCode = '''ElField(
  label: 'Country',
  errors: const <String>['Select a valid country.'],
  child: ElNativeSelect<String>(
    options: options,
    value: country,
    onChanged: (String next) => setState(() => country = next),
    invalid: true,
  ),
)''';

class _NativeSelectPreview extends StatefulWidget {
  const _NativeSelectPreview();

  @override
  State<_NativeSelectPreview> createState() => _NativeSelectPreviewState();
}

class _NativeSelectPreviewState extends State<_NativeSelectPreview> {
  String _country = 'us';

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: ElContainers.sm),
    child: ElField(
      key: const ValueKey<String>('native-select-preview'),
      label: 'Country',
      child: ElNativeSelect<String>(
        options: const <ElSelectChild<String>>[
          ElSelectOption(value: 'us', label: 'United States'),
          ElSelectOption(value: 'ca', label: 'Canada'),
          ElSelectOption(value: 'mx', label: 'Mexico'),
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
    constraints: const BoxConstraints(maxWidth: ElContainers.sm),
    child: ElField(
      key: const ValueKey<String>('native-select-groups-preview'),
      label: 'Role',
      child: ElNativeSelect<String>(
        options: const <ElSelectChild<String>>[
          ElSelectGroup<String>(
            label: 'Engineering',
            children: <ElSelectOption<String>>[
              ElSelectOption(value: 'engineer', label: 'Engineer'),
              ElSelectOption(value: 'designer', label: 'Designer'),
            ],
          ),
          ElSelectGroup<String>(
            label: 'Operations',
            children: <ElSelectOption<String>>[
              ElSelectOption(value: 'support', label: 'Support'),
              ElSelectOption(value: 'sales', label: 'Sales'),
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

  static const List<ElSelectOption<String>> _fruits = <ElSelectOption<String>>[
    ElSelectOption(value: 'apple', label: 'Apple'),
    ElSelectOption(value: 'banana', label: 'Banana'),
    ElSelectOption(value: 'blueberry', label: 'Blueberry'),
  ];

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: ElContainers.sm),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ElText('Whole control disabled', ElType.label),
        SizedBox(height: el(3)),
        ElField(
          key: const ValueKey<String>('native-select-disabled-preview'),
          label: 'Fruit',
          child: ElNativeSelect<String>(
            options: _fruits,
            value: _wholeControl,
            onChanged: (String next) => setState(() => _wholeControl = next),
            enabled: false,
          ),
        ),
        SizedBox(height: el(7)),
        ElText('One option disabled', ElType.label),
        SizedBox(height: el(3)),
        ElField(
          key: const ValueKey<String>('native-select-disabled-option-preview'),
          label: 'Fruit',
          child: ElNativeSelect<String>(
            options: const <ElSelectOption<String>>[
              ElSelectOption(value: 'apple', label: 'Apple'),
              ElSelectOption(value: 'banana', label: 'Banana', enabled: false),
              ElSelectOption(value: 'blueberry', label: 'Blueberry'),
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
    constraints: const BoxConstraints(maxWidth: ElContainers.sm),
    child: ElField(
      key: const ValueKey<String>('native-select-invalid-preview'),
      label: 'Country',
      errors: const <String>['Select a valid country.'],
      child: ElNativeSelect<String>(
        options: const <ElSelectChild<String>>[
          ElSelectOption(value: 'us', label: 'United States'),
          ElSelectOption(value: 'ca', label: 'Canada'),
          ElSelectOption(value: 'mx', label: 'Mexico'),
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
      constraints: const BoxConstraints(maxWidth: ElContainers.sm),
      child: ElField(
        key: const ValueKey<String>('native-select-rtl-preview'),
        label: 'الدولة',
        child: ElNativeSelect<String>(
          options: const <ElSelectChild<String>>[
            ElSelectOption(value: 'sa', label: 'السعودية'),
            ElSelectOption(value: 'eg', label: 'مصر'),
            ElSelectOption(value: 'ma', label: 'المغرب'),
          ],
          value: _country,
          onChanged: (String next) => setState(() => _country = next),
        ),
      ),
    ),
  );
}
