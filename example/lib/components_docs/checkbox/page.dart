/// Public documentation page for the `checkbox` component.
///
/// **Re-housed onto the kit.** This page used to hand-compose `ElSection`
/// panels; it now declares a `ComponentDocSpec`
/// (`example/lib/docs/component_doc_page.dart`) and hands it to
/// `ComponentDocPage`, the same shape `button` established. Every specimen
/// widget and every code string below is the same one the hand-composed page
/// carried; only where it lives changed.
///
/// **Section order**, matching `button`'s own house shape: Preview,
/// Installation, Usage, then one section per state the live grid already
/// showed (Checked state, Invalid state, Basic, Disabled, Group, Table),
/// then the eight disclosures. Three sections from the old page merged
/// rather than surviving as standalone headings, content preserved, not
/// dropped:
/// * Description folded into Basic's own description: both were about the
///   same wiring (`ElField.description` reaching `ElCheckbox.hint`), and
///   Basic already carries the live specimen that shows it.
/// * RTL folded into the Responsive disclosure as its own bullet: RTL and
///   viewport-independence are both "what does NOT change this control's
///   geometry" facts, and the trailing disclosures are exactly where that
///   kind of fact lives on every other page.
/// * The Installation section's own Status/Version/Platforms facts moved
///   into the Dependencies disclosure: `InstallSection` only carries a
///   command and manual files, the same shape `button` uses.
///
/// New: a Keyboard disclosure, between Accessibility and Responsive, read
/// directly off `lib/src/components/selection_control.dart`'s shared
/// `_onKey` (checkbox.dart composes `ElSelectionControl`, it does not wire
/// its own key handler).
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/component_doc_page.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../kit.dart' show ElStateCell;
import 'meta.dart';

final ComponentDocSpec checkboxDocSpec = ComponentDocSpec(
  name: 'checkbox',
  title: 'Checkbox',
  description: checkboxDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'Seven live specimens, all built from the same ElCheckbox '
          'constructor. Unchecked, Checked, Focus-visible and Error are '
          'operable: tap them. Indeterminate is deliberately held still and '
          'Disabled is deliberately inert; both are explained in States '
          'below.',
      specimen: _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'checkbox is a registry item: elattar add checkbox resolves it '
          'and its dependencies and copies the source into your project. '
          'The Manual tab is for a project not using the CLI.',
      command: checkboxDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/checkbox.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/checkbox.dart's generated "
              '@ui/checkbox.dart payload into components/ui.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated checkbox source here when using '
              'manual mode.',
        ),
        const DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so ElCheckbox and ElCheckboxState are '
              'reachable the same way the CLI path already makes them.',
          code: "export 'checkbox.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description: 'Import the package, then construct a ElCheckbox.',
      code: _basicUsageCode,
    ),
    ShowcaseSection(
      id: 'checked-state',
      title: 'Checked state',
      description:
          'ElCheckbox is always controlled: state carries the current '
          'ElCheckboxState and onChanged reports the next one on tap.',
      specimen: _CheckedStateSpecimen(),
      code: _smallestUsageCode,
      label: 'Checked state specimen view',
    ),
    ShowcaseSection(
      id: 'invalid-state',
      title: 'Invalid state',
      description:
          'invalid: true swaps the border and ring to the destructive '
          'colour; see States and Accessibility below for the full '
          'focus/error precedence.',
      specimen: _InvalidStateSpecimen(),
      code: _invalidUsageCode,
      label: 'Invalid state specimen view',
    ),
    ShowcaseSection(
      id: 'basic',
      title: 'Basic',
      description:
          'ElCheckbox renders no visible text of its own: label only '
          'supplies the accessible name. Pair it with ElField for a visible '
          'caption, and its ElFieldScope threads the label straight '
          'through. The same wiring carries description: '
          '"You can withdraw consent at any time in Settings." below feeds '
          'ElCheckbox.hint, read after the label through Semantics.hint — '
          'the aria-describedby analogue shadcn\'s FieldDescription '
          'authors by hand. No separate prop on ElCheckbox itself is '
          'needed once it is composed inside a ElField.',
      specimen: _BasicSpecimen(),
      code: _fieldUsageCode,
      label: 'Basic specimen view',
    ),
    ShowcaseSection(
      id: 'disabled',
      title: 'Disabled',
      description:
          'enabled: false dims the control to 50% opacity and removes it '
          'from the tab order.',
      specimen: _DisabledSpecimen(),
      code: _disabledUsageCode,
      label: 'Disabled specimen view',
    ),
    ShowcaseSection(
      id: 'group',
      title: 'Group',
      description:
          'A list of independent checkboxes sharing one row layout, each '
          'one still a plain, uncoordinated ElCheckbox.',
      specimen: _GroupSpecimen(),
      code: _filterRowCode,
      label: 'Group specimen view',
    ),
    ShowcaseSection(
      id: 'table',
      title: 'Table',
      description:
          'A header checkbox reflecting a partial selection across table '
          'rows: the case ElCheckboxState.indeterminate exists for.',
      specimen: _TableSpecimen(),
      code: _bulkSelectionCode,
      label: 'Table specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every constructor parameter ElCheckbox declares, plus '
          'ElCheckboxState and the static helpers callers reach for.',
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'Hover, Pressed, Loading, Empty and Success are omitted below: '
          'reasons follow the table.',
      child: _StatesContent(),
    ),
    DisclosureSection(
      id: 'accessibility',
      title: 'Accessibility',
      child: DocsInstallFacts(title: 'Accessibility', facts: _a11yFacts),
    ),
    DisclosureSection(
      id: 'keyboard',
      title: 'Keyboard',
      description:
          'Read off lib/src/components/selection_control.dart\'s shared '
          '_onKey: checkbox.dart composes ElSelectionControl rather than '
          'wiring its own key handler.',
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
      child: DocsInstallFacts(
        title: 'Tokens this component reads',
        facts: _themingFacts,
      ),
    ),
    DisclosureSection(
      id: 'source',
      title: 'Source',
      child: DocsInstallFacts(
        facts: <DocsInstallFact>[
          DocsInstallFact(
            label: 'Component source',
            value: checkboxDoc.sourcePath,
            description: 'Authoritative implementation.',
          ),
          const DocsInstallFact(
            label: 'Shared machinery',
            value: 'lib/src/components/selection_control.dart',
            description:
                'ElSelectionControl, ElHitArea and ElJellyReplay, shared '
                'with the switch and radio families and documented on '
                'their own component page.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'test/selection_feedback_test.dart',
            description:
                'State-matrix and geometry coverage for ElCheckbox in the '
                'package itself.',
          ),
          const DocsInstallFact(
            label: 'Docs page tests',
            value: 'example/test/components_docs/checkbox_test.dart',
            description:
                "Coverage for this page: API completeness, the live "
                'specimen toggle, and both themes.',
          ),
        ],
      ),
    ),
  ],
);

class CheckboxDocPage extends StatelessWidget {
  const CheckboxDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: checkboxDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / BASE',
      title: checkboxDoc.title,
      description: checkboxDoc.description,
    ),
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Components'),
      ElBreadcrumbEntry.page('Checkbox'),
    ],
    toc: checkboxDocSpec.toc,
    previous: const DocsPageLink(
      title: 'Breadcrumb',
      route: '/components/breadcrumb',
    ),
    next: const DocsPageLink(
      title: 'Collapsible',
      route: '/components/collapsible',
    ),
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('checkbox-doc-article'),
      child: ComponentDocPage(spec: checkboxDocSpec, header: false),
    ),
  );
}

/* ── Showcase specimens ─────────────────────────────────────────────────── */

class _PreviewSpecimen extends StatefulWidget {
  const _PreviewSpecimen();

  @override
  State<_PreviewSpecimen> createState() => _PreviewSpecimenState();
}

class _PreviewSpecimenState extends State<_PreviewSpecimen> {
  ElCheckboxState _unchecked = ElCheckboxState.unchecked;
  ElCheckboxState _checked = ElCheckboxState.checked;
  ElCheckboxState _focus = ElCheckboxState.unchecked;
  ElCheckboxState _error = ElCheckboxState.unchecked;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: el(3),
    runSpacing: el(3),
    children: <Widget>[
      ElStateCell(
        label: 'Unchecked',
        note: 'Tap to toggle',
        child: ElCheckbox(
          key: const ValueKey<String>('checkbox-live-specimen'),
          state: _unchecked,
          label: 'Unchecked',
          onChanged: (ElCheckboxState next) =>
              setState(() => _unchecked = next),
        ),
      ),
      ElStateCell(
        label: 'Checked',
        note: 'Tap to toggle',
        child: ElCheckbox(
          state: _checked,
          label: 'Checked',
          onChanged: (ElCheckboxState next) => setState(() => _checked = next),
        ),
      ),
      const ElStateCell(
        label: 'Indeterminate',
        note: 'Held here on purpose: see States',
        child: ElCheckbox(
          state: ElCheckboxState.indeterminate,
          inert: true,
          label: 'Indeterminate',
        ),
      ),
      ElStateCell(
        label: 'Focus-visible',
        note: 'Ring painted, not focused',
        child: ElCheckbox(
          state: _focus,
          forceFocusRing: true,
          label: 'Focus-visible',
          onChanged: (ElCheckboxState next) => setState(() => _focus = next),
        ),
      ),
      ElStateCell(
        label: 'Error',
        note: 'invalid: true',
        child: ElCheckbox(
          state: _error,
          invalid: true,
          label: 'Error',
          onChanged: (ElCheckboxState next) => setState(() => _error = next),
        ),
      ),
      const ElStateCell(
        label: 'Disabled',
        child: ElCheckbox(enabled: false, label: 'Disabled'),
      ),
      const ElStateCell(
        label: 'Disabled checked',
        child: ElCheckbox(
          state: ElCheckboxState.checked,
          enabled: false,
          label: 'Disabled checked',
        ),
      ),
    ],
  );
}

const String _previewCode =
    '''Wrap(
  spacing: 12,
  runSpacing: 12,
  children: [
    ElCheckbox(
      state: unchecked ? ElCheckboxState.checked : ElCheckboxState.unchecked,
      label: 'Unchecked',
      onChanged: (next) => setState(() => unchecked = next),
    ),
    const ElCheckbox(
      state: ElCheckboxState.indeterminate,
      inert: true,
      label: 'Indeterminate',
    ),
    ElCheckbox(
      forceFocusRing: true,
      label: 'Focus-visible',
      onChanged: (next) {},
    ),
    ElCheckbox(invalid: true, label: 'Error', onChanged: (next) {}),
    const ElCheckbox(enabled: false, label: 'Disabled'),
    const ElCheckbox(
      state: ElCheckboxState.checked,
      enabled: false,
      label: 'Disabled checked',
    ),
  ],
)''';

class _CheckedStateSpecimen extends StatefulWidget {
  const _CheckedStateSpecimen();

  @override
  State<_CheckedStateSpecimen> createState() => _CheckedStateSpecimenState();
}

class _CheckedStateSpecimenState extends State<_CheckedStateSpecimen> {
  bool _accepted = false;

  @override
  Widget build(BuildContext context) => ElCheckbox(
    state: _accepted ? ElCheckboxState.checked : ElCheckboxState.unchecked,
    label: 'Accept the terms',
    onChanged: (ElCheckboxState next) =>
        setState(() => _accepted = next == ElCheckboxState.checked),
  );
}

const String _basicUsageCode =
    '''import 'package:elattar_design_system/elattar_design_system.dart';

ElCheckbox(label: 'Accept the terms')''';

const String _smallestUsageCode = '''bool accepted = false;

ElCheckbox(
  state: accepted ? ElCheckboxState.checked : ElCheckboxState.unchecked,
  label: 'Accept the terms',
  onChanged: (ElCheckboxState next) {
    setState(() => accepted = next == ElCheckboxState.checked);
  },
)''';

class _InvalidStateSpecimen extends StatelessWidget {
  const _InvalidStateSpecimen();

  @override
  Widget build(BuildContext context) =>
      const ElCheckbox(invalid: true, label: 'Accept the terms');
}

const String _invalidUsageCode = '''ElCheckbox(
  invalid: true,
  label: 'Accept the terms',
)''';

/// A live, functioning `ElField`-wrapped checkbox: proof the composition
/// Basic documents actually renders and toggles, not just a code excerpt.
class _BasicSpecimen extends StatefulWidget {
  const _BasicSpecimen();

  @override
  State<_BasicSpecimen> createState() => _BasicSpecimenState();
}

class _BasicSpecimenState extends State<_BasicSpecimen> {
  bool _accepted = false;

  @override
  Widget build(BuildContext context) => ElField(
    label: 'Accept the terms and conditions',
    description: 'You can withdraw consent at any time in Settings.',
    orientation: ElFieldOrientation.horizontal,
    child: ElCheckbox(
      state: _accepted ? ElCheckboxState.checked : ElCheckboxState.unchecked,
      onChanged: (ElCheckboxState next) =>
          setState(() => _accepted = next == ElCheckboxState.checked),
    ),
  );
}

const String _fieldUsageCode = '''ElField(
  label: 'Accept the terms and conditions',
  description: 'You can withdraw consent at any time in Settings.',
  orientation: ElFieldOrientation.horizontal,
  child: ElCheckbox(
    state: accepted ? ElCheckboxState.checked : ElCheckboxState.unchecked,
    onChanged: (ElCheckboxState next) {
      setState(() => accepted = next == ElCheckboxState.checked);
    },
  ),
)''';

class _DisabledSpecimen extends StatelessWidget {
  const _DisabledSpecimen();

  @override
  Widget build(BuildContext context) =>
      const ElCheckbox(enabled: false, label: 'Disabled');
}

const String _disabledUsageCode = '''ElCheckbox(
  enabled: false,
  label: 'Disabled',
)''';

class _GroupSpecimen extends StatefulWidget {
  const _GroupSpecimen();

  @override
  State<_GroupSpecimen> createState() => _GroupSpecimenState();
}

class _GroupSpecimenState extends State<_GroupSpecimen> {
  final Map<String, bool> _checked = <String, bool>{
    'Electronics': false,
    'Clothing': true,
    'Home & Garden': false,
  };

  static const Map<String, String> _counts = <String, String>{
    'Electronics': '128',
    'Clothing': '76',
    'Home & Garden': '54',
  };

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      for (final String label in _checked.keys) ...<Widget>[
        _FilterRow(
          label: label,
          count: _counts[label]!,
          checked: _checked[label]!,
          onChanged: (bool next) => setState(() => _checked[label] = next),
        ),
        SizedBox(height: el(3)),
      ],
    ],
  );
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({
    required this.label,
    required this.count,
    required this.checked,
    required this.onChanged,
  });

  final String label;
  final String count;
  final bool checked;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      ElCheckbox(
        state: checked ? ElCheckboxState.checked : ElCheckboxState.unchecked,
        label: label,
        onChanged: (ElCheckboxState next) =>
            onChanged(next == ElCheckboxState.checked),
      ),
      SizedBox(width: ElField.gap),
      Expanded(
        child: ElFieldLabel(
          label,
          spec: ElFieldLabel.normal,
          onTap: () => onChanged(!checked),
        ),
      ),
      ElText(count, ElType.numSm),
    ],
  );
}

const String _filterRowCode = '''Row(
  crossAxisAlignment: CrossAxisAlignment.center,
  children: <Widget>[
    ElCheckbox(
      state: checked ? ElCheckboxState.checked : ElCheckboxState.unchecked,
      label: label,
      onChanged: (ElCheckboxState next) =>
          onChanged(next == ElCheckboxState.checked),
    ),
    SizedBox(width: ElField.gap),
    Expanded(
      child: ElFieldLabel(
        label,
        spec: ElFieldLabel.normal,
        onTap: () => onChanged(!checked),
      ),
    ),
    ElText(count, ElType.numSm),
  ],
)''';

class _TableSpecimen extends StatefulWidget {
  const _TableSpecimen();

  @override
  State<_TableSpecimen> createState() => _TableSpecimenState();
}

class _TableSpecimenState extends State<_TableSpecimen> {
  final List<bool> _rows = <bool>[true, false, false];

  @override
  Widget build(BuildContext context) {
    final int selected = _rows.where((bool v) => v).length;
    final ElCheckboxState headerState = selected == 0
        ? ElCheckboxState.unchecked
        : selected == _rows.length
        ? ElCheckboxState.checked
        : ElCheckboxState.indeterminate;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ElCheckbox(
          state: headerState,
          label: 'Select all ${_rows.length} rows',
          onChanged: (ElCheckboxState next) {
            final bool selectAll = next == ElCheckboxState.checked;
            setState(() {
              for (int i = 0; i < _rows.length; i++) {
                _rows[i] = selectAll;
              }
            });
          },
        ),
        SizedBox(height: el(3)),
        for (int i = 0; i < _rows.length; i++) ...<Widget>[
          ElCheckbox(
            state: _rows[i]
                ? ElCheckboxState.checked
                : ElCheckboxState.unchecked,
            label: 'Row ${i + 1}',
            onChanged: (ElCheckboxState next) =>
                setState(() => _rows[i] = next == ElCheckboxState.checked),
          ),
          SizedBox(height: el(2)),
        ],
      ],
    );
  }
}

const String _bulkSelectionCode =
    '''// selectedCount tracks how many of `total` rows are checked.
ElCheckbox(
  state: selectedCount == 0
      ? ElCheckboxState.unchecked
      : selectedCount == total
          ? ElCheckboxState.checked
          : ElCheckboxState.indeterminate,
  label: 'Select all \$total rows',
  onChanged: (ElCheckboxState next) {
    final bool selectAll = next == ElCheckboxState.checked;
    setState(() {
      for (int i = 0; i < total; i++) {
        rowSelected[i] = selectAll;
      }
    });
  },
)''';

/* ── Disclosure content ─────────────────────────────────────────────────── */

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsApiTable(title: 'ElCheckbox', facts: _checkboxApiFacts),
      SizedBox(height: el(5)),
      const DocsApiTable(
        title: 'ElCheckboxState and statics',
        facts: _checkboxStateFacts,
      ),
    ],
  );
}

const List<DocsApiFact> _checkboxApiFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'state',
    type: 'ElCheckboxState',
    description:
        'Which of the three data-state values is rendered. Defaults to '
        'ElCheckboxState.unchecked.',
  ),
  DocsApiFact(
    name: 'onChanged',
    type: 'ValueChanged<ElCheckboxState>?',
    description:
        'Called with the next state on tap or Enter/Space. Null disables '
        'the control: the same "no handler, no operation" rule ElButton '
        'follows.',
  ),
  DocsApiFact(
    name: 'enabled',
    type: 'bool',
    description:
        'Defaults to true. false dims the control to 50% opacity and '
        'removes it from the tab order.',
  ),
  DocsApiFact(
    name: 'inert',
    type: 'bool',
    description:
        'Defaults to false. true holds the control at its current state '
        'forever: full opacity, still focusable, but a tap or Enter/Space '
        'does nothing. Distinct from enabled: false: see States.',
  ),
  DocsApiFact(
    name: 'invalid',
    type: 'bool',
    description:
        'Defaults to false. true paints the destructive border and ring. '
        'ORed with the enclosing ElFieldScope\'s own invalid flag.',
  ),
  DocsApiFact(
    name: 'forceFocusRing',
    type: 'bool?',
    description:
        'true paints the focus ring without owning focus, false withholds '
        'it even while genuinely focused, and null (the default) follows '
        'real focus.',
  ),
  DocsApiFact(
    name: 'focusNode',
    type: 'FocusNode?',
    description: 'Overrides the node a ElFieldScope would otherwise supply.',
  ),
  DocsApiFact(
    name: 'label',
    type: 'String?',
    description:
        'The accessible name. Not rendered as visible text, pair with '
        'ElField (or ElFieldLabel) for a visible caption.',
  ),
  DocsApiFact(
    name: 'hint',
    type: 'String?',
    description:
        'Read after the label: the aria-describedby analogue, resolved '
        'through Semantics.hint.',
  ),
];

const List<DocsApiFact> _checkboxStateFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'ElCheckboxState.unchecked',
    type: 'enum value',
    description: 'No indicator mounted. isOn is false.',
  ),
  DocsApiFact(
    name: 'ElCheckboxState.checked',
    type: 'enum value',
    description: 'The self-drawing tick mark. isOn is true.',
  ),
  DocsApiFact(
    name: 'ElCheckboxState.indeterminate',
    type: 'enum value',
    description: 'The same lit box, carrying a bar instead of a tick. isOn '
        'is true.',
  ),
  DocsApiFact(
    name: 'ElCheckbox.size',
    type: 'static double',
    description:
        'The 20px box size: bigger than the reference\'s own default '
        'because a 16px target and tick were judged illegible.',
  ),
  DocsApiFact(
    name: 'ElCheckbox.nextAfter',
    type: 'static ElCheckboxState Function(ElCheckboxState)',
    description:
        'What a click produces: anything not already checked becomes '
        'checked, and checked becomes unchecked.',
  ),
];

class _StatesContent extends StatelessWidget {
  const _StatesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsStateMatrix(facts: _stateFacts),
      SizedBox(height: el(4)),
      ElText(
        'Omitted: Hover: no control in this family authors a hover skin; '
        'only the pointer cursor changes. Pressed, there is no separate '
        'pointer-down look; the box squashes once, after the state '
        'actually changes, via ElJellyReplay, which is a post-toggle '
        'reveal rather than a held-down state. Loading and Empty, '
        'ElCheckbox is a synchronous primitive with no async operation and '
        'nothing to list, so neither applies. Success: the component '
        'defines no success semantics of its own.',
        ElType.small,
        color: ElTheme.of(context).mutedForeground,
      ),
    ],
  );
}

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Rest (unchecked)',
    treatment:
        'theme.card fill, theme.input border, pressed-style shadow.',
    userSignal: 'An empty 20px box; no indicator is mounted.',
  ),
  DocsStateFact(
    state: 'Selected (checked)',
    treatment:
        'theme.primary fill and border; the tick draws itself, stroke '
        'first, over its own reveal.',
    userSignal:
        'A drawn checkmark rather than a faded-in one, visible even to a '
        'reader who cannot rely on the fill colour changing.',
  ),
  DocsStateFact(
    state: 'Indeterminate',
    treatment:
        'The same lit socket as Checked, carrying a horizontal bar '
        'instead of a tick; re-draws from zero on every reveal.',
    userSignal:
        'A bar, not a tick: the shape itself signals "partially '
        'selected," not just a third colour.',
  ),
  DocsStateFact(
    state: 'Inert',
    treatment:
        'inert: true holds the control at its current state forever, '
        'regardless of onChanged.',
    userSignal:
        'Full opacity, still in the tab order, looks exactly like an '
        'operable checkbox: a tap or Enter/Space does nothing. Reproduced '
        'from the reference on purpose, not a bug.',
  ),
  DocsStateFact(
    state: 'Focus-visible',
    treatment: 'border-ring plus a 3px ring at 50% alpha.',
    userSignal:
        'A visible ring around the box: beaten by Error below when both '
        'apply.',
  ),
  DocsStateFact(
    state: 'Error',
    treatment:
        'invalid: true swaps the border and ring to the destructive '
        'colour at 20% ring alpha.',
    userSignal:
        'aria-invalid beats focus-visible: a focused, invalid checkbox '
        'looks pixel-identical to an unfocused invalid one: reproduced '
        'faithfully rather than "fixed".',
  ),
  DocsStateFact(
    state: 'Disabled',
    treatment:
        'enabled: false drops opacity to 50% and removes the control from '
        'the tab order and from pointer and keyboard handling.',
    userSignal: 'Visibly and operably inert: the one state that dims.',
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment:
        'The tick/bar keyframe player fills both ends, so a '
        'reduced-motion context lands directly on the finished stroke '
        'instead of drawing to it; the socket colour and shadow tween '
        'collapses to its resolved (near-zero) duration.',
    userSignal: 'The same end state, with no draw-on animation to sit '
        'through.',
  ),
];

const List<DocsInstallFact> _a11yFacts = <DocsInstallFact>[
  DocsInstallFact(
    label: 'Semantic role',
    value: 'Semantics(checked:, mixed:)',
    description:
        'unchecked -> checked: false, mixed: false. checked -> checked: '
        'true. indeterminate -> checked: false, mixed: true: read by '
        'assistive technology as a tri-state checkbox.',
  ),
  DocsInstallFact(
    label: 'Label association',
    value: 'label',
    description:
        'Feeds the control\'s accessible name directly. It is never '
        'rendered as visible text: compose with ElField (or a '
        'ElFieldLabel) for a caption a sighted user can read; tapping '
        'that visible label activates the control through the same '
        'activator wiring an HTML <label for> click would use.',
  ),
  DocsInstallFact(
    label: 'Focus behavior',
    value: 'border-ring plus a 3px ring at 50% alpha',
    description:
        'aria-invalid beats focus-visible at equal specificity, '
        'reproduced from the reference: a focused, invalid checkbox shows '
        'no visible change from an unfocused invalid one.',
  ),
  DocsInstallFact(
    label: 'Touch target',
    value: '42 x 34, centred on a 20 x 20 box',
    description:
        'ElHitArea grows the hit test past the painted box. Measured from '
        'the reference at 2px short of the system\'s own 44px floor on '
        'both axes: recorded, not corrected, because it is what the '
        'reference renders.',
  ),
  DocsInstallFact(
    label: 'Non-colour signal',
    value: 'A drawn glyph, not just a fill change',
    description:
        'Checked draws a tick and indeterminate draws a bar, two '
        'different shapes, so the state does not depend on a reader '
        'distinguishing fill colours.',
  ),
  DocsInstallFact(
    label: 'Error wiring',
    value: 'invalid, ORed with the enclosing ElFieldScope',
    description:
        'A ElField around the control folds its own invalid flag in, and '
        'colours the field\'s text with theme.destructiveInk when either '
        'is true.',
  ),
  DocsInstallFact(
    label: 'Screen-reader announcements',
    value: 'No live region',
    description:
        'State changes are exposed purely through the checked/mixed '
        'flags on the merged semantics node; no extra announcement is '
        'authored.',
  ),
  DocsInstallFact(
    label: 'Known drift',
    value: 'inert renders as fully operable',
    description:
        'inert: true carries no disabled semantics at all, the control '
        'announces enabled: true: so a screen reader gets no more signal '
        'than a sighted reader that the control cannot be operated. '
        'Reproduced from the reference on purpose.',
  ),
];

/// Read directly off `lib/src/components/selection_control.dart`'s shared
/// `_onKey`: `checkbox.dart` composes `ElSelectionControl` rather than
/// wiring its own key handler, so every fact here is that file's, not
/// invented for this page.
class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'Activation: Enter, NumpadEnter, and Space toggle a focused, '
            'enabled, non-inert checkbox. The shared _onKey only inspects '
            'KeyDownEvent, a matching KeyUpEvent is ignored, and any other '
            'key returns KeyEventResult.ignored so it keeps propagating.',
        'Tab order: Focus.canRequestFocus is wired to enabled && (inert || '
            'onChanged != null), so a disabled checkbox is removed from '
            'keyboard traversal entirely, while an inert one (full '
            'opacity, deaf to activation) still receives Tab focus: the '
            'one place inert and disabled diverge for a keyboard user, '
            'not just a pointer one.',
        'No custom ordering: neither checkbox.dart nor '
            'selection_control.dart wires a FocusTraversalPolicy of its '
            'own. Tab and Shift+Tab walk whatever order the surrounding '
            'page (or ElFieldGroup) already declares.',
        'Pointer vs keyboard: a bare pointer tap never requests focus on '
            'the node in this family; only keyboard traversal, or an '
            'explicit focusNode.requestFocus() from outside, does — the '
            'same asymmetry ElButton\'s own Keyboard section documents, '
            'shared machinery.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'ElCheckbox has no responsive breakpoints of its own: it is a '
            'fixed 20 x 20 atomic control with a fixed 42 x 34 hit area, '
            'identical across mobile, tablet, desktop and web. What '
            'changes with layout belongs to whatever composes it: ElField '
            'reflows its label and description, and a filter list or '
            'bulk-selection row decides its own wrap behaviour.',
        'Keyboard activation (Enter/Space) and pointer activation behave '
            'identically on every Flutter target this package supports; '
            'there is no platform channel and nothing here is web-only or '
            'desktop-only.',
        'RTL: checkbox.dart carries no left/right-specific geometry of '
            'its own: the socket is square, ElHitArea\'s insets grow '
            'symmetrically on every side, and the tick/bar paths are '
            'drawn in a fixed local coordinate space rather than '
            'mirrored. What flips under Directionality.rtl belongs '
            'entirely to whatever composes it: ElField and ElFieldLabel '
            'reorder label, control and description the same way any '
            'other Flutter row does under RTL, because nothing in '
            'checkbox.dart hardcodes a left-to-right assumption.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      DocsInstallFacts(
        title: 'Dependencies and files',
        facts: <DocsInstallFact>[
          DocsInstallFact(
            label: 'Status',
            value: 'Stable, installable through elattar add checkbox',
            description:
                'Ported and tested against lib/src/components/'
                'checkbox.dart, and shipped as a registry item.',
          ),
          const DocsInstallFact(
            label: 'Version',
            value: '0.0.1',
            description:
                'Tracks the package version; there is no separate '
                'registry schema version.',
          ),
          const DocsInstallFact(
            label: 'Platforms',
            value: 'Android, iOS, Web, macOS, Windows, Linux',
            description:
                'A pure Flutter widget tree and CustomPainter geometry, '
                'no platform channel and no platform-specific branch.',
          ),
          DocsInstallFact(
            label: 'Source file',
            value: checkboxDoc.sourcePath,
            description: 'The authoritative implementation.',
          ),
          const DocsInstallFact(
            label: 'Local file dependencies',
            value:
                'selection_control.dart, field.dart, icon_paths.dart, '
                'motion/keyframes.dart',
            description:
                'checkbox.dart imports these directly: '
                'selection_control.dart for the shared socket / hit-area '
                '/ focus-ring machinery (ElSelectionControl), field.dart '
                'for ElFieldScope wiring, icon_paths.dart for the 24-unit '
                'icon grid, and motion/keyframes.dart for the '
                'self-drawing stroke player. None are copyable in '
                'isolation.',
          ),
          const DocsInstallFact(
            label: 'Foundation dependencies',
            value:
                'foundation/motion.dart, foundation/shadows.dart, '
                'foundation/spacing.dart, foundation/theme.dart, '
                'theme_scope.dart',
            description:
                'Token sources: durations and curves, shadow specs, the '
                'el() spacing scale, and the live theme.',
          ),
          DocsInstallFact(
            label: 'Exports',
            value: checkboxDoc.exports.join(', '),
            description: 'The public symbols this component makes '
                'available.',
          ),
          const DocsInstallFact(
            label: 'Assets',
            value: 'none',
            description:
                'The tick and bar are drawn with CustomPainter path '
                'geometry, not an image or an icon-font glyph.',
          ),
          const DocsInstallFact(
            label: 'Fonts',
            value: 'none',
            description: 'No text is rendered by ElCheckbox itself.',
          ),
          const DocsInstallFact(
            label: 'Shaders',
            value: 'none',
            description: 'No fragment shader is used.',
          ),
        ],
      ),
      SizedBox(height: el(4)),
      const DocsLinkRow(
        links: <DocsLink>[
          DocsLink(label: 'Field', route: '/components/field'),
          DocsLink(label: 'Icon', route: '/components/icon'),
          DocsLink(label: 'Keyframes', route: '/components/keyframes'),
          DocsLink(
            label: 'Selection control',
            route: '/components/selection_control',
          ),
        ],
      ),
    ],
  );
}

const List<DocsInstallFact> _themingFacts = <DocsInstallFact>[
  DocsInstallFact(
    label: 'Fill',
    value:
        'theme.card (rest) / theme.primary (checked or indeterminate)',
    description: 'Socket background.',
  ),
  DocsInstallFact(
    label: 'Border',
    value:
        'theme.input (rest) / theme.primary (lit) / theme.ring '
        '(focus-visible) / theme.destructive (invalid)',
    description: 'Resolved in that precedence order: invalid always wins.',
  ),
  DocsInstallFact(
    label: 'Mark colour',
    value: 'theme.primaryForeground',
    description: 'The drawn tick/bar stroke.',
  ),
  DocsInstallFact(
    label: 'Shadow',
    value: 'ElShadows.pressed (rest) / ElShadows.btnPrimary (lit)',
    description:
        'The socket shadow spec, composed with the focus or invalid ring.',
  ),
  DocsInstallFact(
    label: 'Radius',
    value: 'ElRadii.sm (6px)',
    description: 'The socket corner.',
  ),
  DocsInstallFact(
    label: 'Motion',
    value:
        'ElDurations.transitionDefault, ElKeyframePlayer, ElJellyReplay',
    description:
        'Socket colour/border/ring tween duration, the self-drawing '
        'stroke, and the post-toggle squash: all resolved through '
        'elAnimationDuration, so reduced motion shortens or removes them '
        'automatically.',
  ),
];

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
