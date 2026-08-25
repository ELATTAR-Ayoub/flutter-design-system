/// Public documentation page for the `field` component.
///
/// **Re-housed onto the kit.** This page used to hand-compose `ElSection`
/// panels; it now declares a `ComponentDocSpec`
/// (`example/lib/docs/component_doc_page.dart`) and hands it to
/// `ComponentDocPage`, the same shape `button` established. Every specimen
/// widget and every code string below is the same one the hand-composed page
/// carried; only where it lives changed, plus five sections (Input,
/// Textarea, Select, Slider, Switch) that were code-only panels before and
/// are genuinely live now, built from the exact same quoted source.
///
/// `field` is not one widget but a family of nine classes plus one enum:
/// [ElField] itself, the threading primitives [ElFieldScope] and
/// [ElFieldActivator], the layout orientation enum [ElFieldOrientation], the
/// stacking helpers [ElFieldGroup] and [ElFieldSet] with its
/// [ElFieldLegend], and the three parts a hand-built composition reaches for
/// directly, [ElFieldLabel], [ElFieldDescription], and [ElFieldError]. API
/// Reference gives each of the ten its own [DocsApiTable] rather than
/// merging them, with a rail sub-anchor per table — the same
/// `children:`-on-a-disclosure shape `form`'s own API Reference uses.
///
/// **Section order**, matching `button`'s own house shape: Preview,
/// Installation, Usage (the smallest correct example only), Composition,
/// Anatomy, then one section per control ElField wraps (Input, Textarea,
/// Select, Slider, Fieldset, Checkbox, Switch), Field group, Validation and
/// errors, then the eight disclosures. The old page's standalone "Form"
/// section — three sentences pointing at the Form page — is folded into the
/// Dependencies disclosure as a real [DocsLink] instead of a whole heading
/// for one cross-reference. New: a Keyboard disclosure, between
/// Accessibility and Responsive.
///
/// Radio has no section of its own here, unchanged from the original
/// ruling: the only real radio-inside-a-field composition this page has is
/// the Fieldset demo, and a second, near-identical heading would show
/// nothing new. Choice Card and RTL are still skipped: this package has no
/// card-styled selection component for `field` to wrap, and no field.dart
/// code path is direction-aware beyond the [Directionality] every widget
/// already inherits.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/component_doc_page.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../docs/docs_section.dart' show DocsAnchor;
import 'meta.dart';

final ComponentDocSpec fieldDocSpec = ComponentDocSpec(
  name: 'field',
  title: fieldDoc.title,
  description: fieldDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'A vertical field with a live, toggleable error; a horizontal '
          'field wrapping a checkbox, activatable by tapping either the '
          'control or its visible label; a disabled field; and the '
          'separable invalid-versus-errors pairing the source itself '
          'documents as a drift between the reference\'s inputs and forms '
          'pages.',
      specimen: _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
      minHeight: el(160),
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'field already has a registry manifest: this installs '
          'lib/src/components/field.dart and resolves source-foundation '
          'and rule automatically. The Manual tab is for a project not '
          'using the CLI.',
      command: fieldDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/field.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/field.dart's generated @ui/"
              'field.dart payload into components/ui.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated field source here when using manual '
              'mode.',
        ),
        const DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so ElField and the rest of the field '
              'family are reachable the same way the CLI path already '
              'makes them.',
          code: "export 'field.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'The smallest correct composition. Every other example on this '
          'page only changes what control ElField wraps.',
      code: _usageBasicCode,
    ),
    SnippetSection(
      id: 'composition',
      title: 'Composition',
      description:
          'The two shapes a stack of fields takes: independent fields '
          'side by side (ElFieldGroup), or several fields grouped under '
          'one legend (ElFieldSet). Both are quoted from '
          'example/lib/pages/forms.dart below, in Fieldset and Field '
          'group.',
      code: '$_compositionGroupTree\n\n$_compositionSetTree',
    ),
    SnippetSection(
      id: 'anatomy',
      title: 'Anatomy',
      description:
          'The one fixed order every ElField renders, and never varies. '
          'ElFieldOrientation.horizontal reorders only the first two, '
          'control then label, for a checkbox, switch, or radio row: see '
          'API for both values.',
      code: _anatomyCode,
    ),
    ShowcaseSection(
      id: 'input',
      title: 'Input',
      description:
          'ElInput already carries its own optional label and hint for '
          'standalone use; leave both null so ElField supplies the '
          'visible label and description instead.',
      specimen: _InputSpecimen(),
      code: _inputCode,
      label: 'Input specimen view',
    ),
    ShowcaseSection(
      id: 'textarea',
      title: 'Textarea',
      description:
          'The same ElFieldScope wiring ElInput reads: ElTextarea ORs '
          'its own invalid with the field\'s and focuses the scope\'s '
          'focusNode when it registers none of its own.',
      specimen: _TextareaSpecimen(),
      code: _textareaCode,
      label: 'Textarea specimen view',
    ),
    ShowcaseSection(
      id: 'select',
      title: 'Select',
      description:
          'ElNativeSelect reads ElFieldScope the same way: the closed '
          'control is what the field labels, the reference\'s own '
          'operating-system picker is off-canvas either way.',
      specimen: _SelectSpecimen(),
      code: _selectCode,
      label: 'Select specimen view',
    ),
    ShowcaseSection(
      id: 'slider',
      title: 'Slider',
      description:
          'ElField still lays out the label, description and error '
          'around ElSlider, but ElSlider itself reads no ElFieldScope: it '
          'has no invalid ring and no scope-supplied focusNode, so its '
          'own label prop is the one accessible name a caller has to set '
          'directly.',
      specimen: _SliderSpecimen(),
      code: _sliderCode,
      label: 'Slider specimen view',
    ),
    SnippetSection(
      id: 'fieldset',
      title: 'Fieldset',
      description:
          'Quoted from example/lib/pages/forms.dart\'s _PayoutFieldSet: a '
          'ElFieldLegend outside the ElFieldSet (a rendered legend sits '
          'above the set rather than inside its flex flow), '
          'tightForGroup: true because a ElRadioGroup is the set\'s '
          'direct child, and one horizontal ElField per option so each '
          'radio keeps its own selectable label. See the Radio group page '
          'for the live version of this exact composition.',
      code: _compositionSetCode,
    ),
    ShowcaseSection(
      id: 'checkbox',
      title: 'Checkbox',
      description:
          'ElFieldOrientation.horizontal puts the checkbox before its '
          'label; the live version in Preview above is this exact '
          'composition, tap either the box or the words.',
      specimen: _CheckboxFieldSpecimen(),
      code: _usageHorizontalCode,
      label: 'Checkbox specimen view',
    ),
    ShowcaseSection(
      id: 'switch',
      title: 'Switch',
      description:
          'The same horizontal shape as Checkbox above, around ElSwitch '
          'instead.',
      specimen: _SwitchSpecimen(),
      code: _switchCode,
      label: 'Switch specimen view',
    ),
    SnippetSection(
      id: 'field-group',
      title: 'Field group',
      description:
          'Quoted from example/lib/pages/forms.dart\'s #profile-panel '
          'composition, the ElFieldGroup around the Handle and Email '
          'fields, trimmed to the two fields: the surrounding '
          'ListenableBuilder and submit button are that page\'s own '
          'form-state plumbing, not part of what ElField needs to be '
          'shown correctly here. See the Form page for the live, bound '
          'version.',
      code: _compositionGroupCode,
    ),
    ShowcaseSection(
      id: 'validation-errors',
      title: 'Validation and errors',
      description:
          'invalid defaults to errors.isNotEmpty but the two are '
          'separable switches. Both fields below colour their label and '
          'control red, because both set ElFieldScope.invalid; only the '
          'left one mounts a ElFieldError live region, because that is '
          'driven by errors alone, not by invalid.',
      specimen: _ValidationSpecimen(),
      code: _validationCode,
      label: 'Validation and errors specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every constructor parameter, every enum value, and every '
          'static member the source declares: one table per exported '
          'class or enum.',
      children: const <DocsTocEntry>[
        DocsTocEntry(title: 'ElField', anchor: 'api-elfield'),
        DocsTocEntry(title: 'ElFieldScope', anchor: 'api-elfieldscope'),
        DocsTocEntry(
          title: 'ElFieldActivator',
          anchor: 'api-elfieldactivator',
        ),
        DocsTocEntry(title: 'ElFieldGroup', anchor: 'api-elfieldgroup'),
        DocsTocEntry(title: 'ElFieldSet', anchor: 'api-elfieldset'),
        DocsTocEntry(title: 'ElFieldLegend', anchor: 'api-elfieldlegend'),
        DocsTocEntry(title: 'ElFieldLabel', anchor: 'api-elfieldlabel'),
        DocsTocEntry(
          title: 'ElFieldDescription',
          anchor: 'api-elfielddescription',
        ),
        DocsTocEntry(title: 'ElFieldError', anchor: 'api-elfielderror'),
        DocsTocEntry(
          title: 'ElFieldOrientation',
          anchor: 'api-elfieldorientation',
        ),
      ],
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'ElField itself owns rest, error, disabled, and the empty "no '
          'errors" case. Hover, pressed, focus-visible, selected, '
          'loading, and success belong to whatever control is wrapped — '
          'not to the field around it: so they are recorded here as N/A '
          'with that reason rather than invented.',
      child: DocsStateMatrix(facts: _stateFacts),
    ),
    DisclosureSection(
      id: 'accessibility',
      title: 'Accessibility',
      description:
          'The part this component exists for: turning a label, a '
          'control, a description, and an error into one thing a screen '
          'reader hears as one thing.',
      child: _AccessibilityContent(),
    ),
    DisclosureSection(
      id: 'keyboard',
      title: 'Keyboard',
      description:
          'field.dart wires no key handling of its own — every fact here '
          'is about what does NOT happen, read off ElFieldLabel.build '
          'directly.',
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
      description:
          "Elattar's own technical-transparency panel: what this "
          'component needs to install and run.',
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
            value: fieldDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: "test/inputs_test.dart ('ElField', 'ElFieldSet')",
            description:
                'Geometry, semantics, the label activation ladder, and '
                'the live-region contract, exercised against the real '
                'component.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/field_test.dart',
            description:
                "This page's own per-class API-completeness, live "
                'error-toggle, live checkbox-and-label-tap, and theme '
                'coverage.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/field/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class FieldDocPage extends StatelessWidget {
  const FieldDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: fieldDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / BASE',
      title: fieldDocSpec.title,
      description: fieldDocSpec.description,
    ),
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Components'),
      ElBreadcrumbEntry.page('Field'),
    ],
    toc: fieldDocSpec.toc,
    previous: const DocsPageLink(
      title: 'Combobox',
      route: '/components/combobox',
    ),
    next: const DocsPageLink(title: 'Form', route: '/components/form'),
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('field-doc-article'),
      child: ComponentDocPage(spec: fieldDocSpec, header: false),
    ),
  );
}

/* ── Showcase specimens ─────────────────────────────────────────────────── */

/// The live preview grid: a toggleable-error vertical field, an
/// activatable-by-label horizontal field, a disabled field, and the
/// separable invalid-vs-errors pairing the Accessibility disclosure
/// documents.
class _PreviewSpecimen extends StatefulWidget {
  const _PreviewSpecimen();

  @override
  State<_PreviewSpecimen> createState() => _PreviewSpecimenState();
}

class _PreviewSpecimenState extends State<_PreviewSpecimen> {
  bool _emailInvalid = false;
  ElCheckboxState _subscribed = ElCheckboxState.unchecked;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ElText('Vertical, with a live error', ElType.section),
        SizedBox(height: el(3)),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: ElContainers.sm),
          child: ElField(
            // Scopes the docs test's "no ElFieldError at rest" assertion to
            // this one toggleable specimen: the static "Separable" pairing
            // further down deliberately keeps a ElFieldError mounted at all
            // times, so a page-wide byType(ElFieldError) search cannot tell
            // the two apart.
            key: const ValueKey<String>('field-doc-toggle-field'),
            label: 'Email',
            description: "We'll only use this for receipts.",
            errors: _emailInvalid
                ? const <String>['Enter a valid email address.']
                : const <String>[],
            child: const ElInput(
              key: ValueKey<String>('field-doc-specimen-email'),
              placeholder: 'you@example.com',
            ),
          ),
        ),
        SizedBox(height: el(3)),
        ElButton(
          key: const ValueKey<String>('field-doc-toggle-error'),
          variant: ElButtonVariant.outline,
          size: ElButtonSize.sm,
          label: _emailInvalid ? 'Clear the error' : 'Show an error',
          onPressed: () => setState(() => _emailInvalid = !_emailInvalid),
          child: ElText(
            _emailInvalid ? 'Clear the error' : 'Show an error',
            ElComponentType.buttonLabel,
          ),
        ),
        SizedBox(height: el(7)),
        ElText(
          'Horizontal, around a checkbox: tap the box or the words',
          ElType.section,
        ),
        SizedBox(height: el(3)),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: ElContainers.sm),
          child: ElField(
            label: 'Email me about product updates',
            orientation: ElFieldOrientation.horizontal,
            child: ElCheckbox(
              key: const ValueKey<String>('field-doc-specimen-checkbox'),
              state: _subscribed,
              onChanged: (ElCheckboxState next) =>
                  setState(() => _subscribed = next),
            ),
          ),
        ),
        SizedBox(height: el(7)),
        ElText('Disabled: the field wins over the control', ElType.section),
        SizedBox(height: el(3)),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: ElContainers.sm),
          // The control's own `enabled: true` is deliberately left in
          // place: ElField.enabled: false still wins, because a control
          // ANDs the two rather than reading only its own: see the API
          // and States sections.
          child: ElField(
            label: 'Handle',
            description: 'Set by your workspace admin.',
            enabled: false,
            child: ElInput(initialValue: 'ayoub', enabled: true),
          ),
        ),
        SizedBox(height: el(7)),
        ElText(
          'Separable: invalid and errors are two different switches',
          ElType.section,
        ),
        SizedBox(height: el(3)),
        const _ValidationSpecimen(),
        SizedBox(height: el(2)),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: ElWidths.prose),
          child: ElText(
            'Both colour the label and control red, because both set '
            'ElFieldScope.invalid. Only the left one mounts a ElFieldError '
            'live region, because that is driven by errors alone, not by '
            'invalid.',
            ElType.small,
            color: theme.mutedForeground,
          ),
        ),
      ],
    );
  }
}

const String _previewCode = '''ConstrainedBox(
  constraints: const BoxConstraints(maxWidth: ElContainers.sm),
  child: ElField(
    label: 'Email',
    description: "We'll only use this for receipts.",
    errors: emailInvalid ? const ['Enter a valid email address.'] : const [],
    child: const ElInput(placeholder: 'you@example.com'),
  ),
)

ElField(
  label: 'Email me about product updates',
  orientation: ElFieldOrientation.horizontal,
  child: ElCheckbox(
    state: subscribed,
    onChanged: (next) => setState(() => subscribed = next),
  ),
)

const ElField(
  label: 'Handle',
  description: 'Set by your workspace admin.',
  enabled: false,
  child: ElInput(initialValue: 'ayoub', enabled: true),
)''';

const String _usageBasicCode =
    '''import 'package:elattar_design_system/elattar_design_system.dart';

ElField(
  label: 'Display name',
  description: 'Shown publicly on your profile.',
  child: ElInput(placeholder: 'Astra Vale'),
)''';

/// The Composition section's own map of the shape below: not real code (no
/// return type, no semicolons), a tree of which part nests inside which.
const String _compositionGroupTree = '''FieldGroup
├─ Field
│  ├─ FieldLabel
│  ├─ the control
│  └─ FieldDescription
└─ Field
   ├─ FieldLabel
   ├─ the control
   └─ FieldDescription''';

/// The FieldSet half of the same map: the legend sits outside the set
/// itself, and each option keeps its own horizontal field.
const String _compositionSetTree = '''FieldLegend
FieldSet
└─ Field (horizontal, one per option)
   ├─ the control
   └─ FieldLabel''';

const String _anatomyCode =
    '''// Fixed render order inside every ElField, never varies:
// FieldLabel -> control -> FieldDescription -> FieldError
//
// ElField.gap           8px   between label, control, and what follows
// ElField.describedGap  4px   description's own gap once an error joins it
//
// ElFieldOrientation.horizontal reorders only the first two (control,
// then label) for a checkbox, switch, or radio row.''';

class _InputSpecimen extends StatelessWidget {
  const _InputSpecimen();

  @override
  Widget build(BuildContext context) => const ElFieldGroup(
    children: <Widget>[
      ElField(
        label: 'Username',
        description: 'This is your public display name.',
        child: ElInput(placeholder: 'ayoub'),
      ),
      ElField(
        label: 'Password',
        description: 'Must be at least 8 characters.',
        child: ElInput(obscureText: true),
      ),
    ],
  );
}

const String _inputCode = '''ElFieldGroup(
  children: <Widget>[
    ElField(
      label: 'Username',
      description: 'This is your public display name.',
      child: ElInput(placeholder: 'ayoub'),
    ),
    ElField(
      label: 'Password',
      description: 'Must be at least 8 characters.',
      child: ElInput(obscureText: true),
    ),
  ],
)''';

class _TextareaSpecimen extends StatelessWidget {
  const _TextareaSpecimen();

  @override
  Widget build(BuildContext context) => const ElField(
    label: 'Feedback',
    description: 'We read every word: keep it under 500 characters.',
    child: ElTextarea(
      placeholder: 'Tell us what is working and what is not.',
    ),
  );
}

const String _textareaCode = '''ElField(
  label: 'Feedback',
  description: 'We read every word: keep it under 500 characters.',
  child: ElTextarea(
    placeholder: 'Tell us what is working and what is not.',
  ),
)''';

class _SelectSpecimen extends StatefulWidget {
  const _SelectSpecimen();

  @override
  State<_SelectSpecimen> createState() => _SelectSpecimenState();
}

class _SelectSpecimenState extends State<_SelectSpecimen> {
  String _department = 'support';

  @override
  Widget build(BuildContext context) => ElField(
    label: 'Department',
    description: 'Routes your ticket to the right team.',
    child: ElNativeSelect<String>(
      value: _department,
      onChanged: (String next) => setState(() => _department = next),
      options: const <ElSelectChild<String>>[
        ElSelectOption(value: 'support', label: 'Support'),
        ElSelectOption(value: 'billing', label: 'Billing'),
        ElSelectOption(value: 'sales', label: 'Sales'),
      ],
    ),
  );
}

const String _selectCode = '''ElField(
  label: 'Department',
  description: 'Routes your ticket to the right team.',
  child: ElNativeSelect<String>(
    value: department,
    onChanged: (String next) => setState(() => department = next),
    options: const <ElSelectChild<String>>[
      ElSelectOption(value: 'support', label: 'Support'),
      ElSelectOption(value: 'billing', label: 'Billing'),
      ElSelectOption(value: 'sales', label: 'Sales'),
    ],
  ),
)''';

class _SliderSpecimen extends StatefulWidget {
  const _SliderSpecimen();

  @override
  State<_SliderSpecimen> createState() => _SliderSpecimenState();
}

class _SliderSpecimenState extends State<_SliderSpecimen> {
  List<double> _priceRange = <double>[50, 250];

  @override
  Widget build(BuildContext context) => ElField(
    label: 'Price range',
    description: 'Drag either handle to set your budget.',
    child: ElSlider(
      values: _priceRange,
      onChanged: (List<double> next) => setState(() => _priceRange = next),
      min: 0,
      max: 500,
    ),
  );
}

const String _sliderCode = '''ElField(
  label: 'Price range',
  description: 'Drag either handle to set your budget.',
  child: ElSlider(
    values: priceRange,
    onChanged: (List<double> next) => setState(() => priceRange = next),
    min: 0,
    max: 500,
  ),
)''';

/// Quoted from `example/lib/pages/forms.dart`'s `_PayoutFieldSet`: the shape
/// a group of radios actually needs. Illustrative — `field` (the object
/// wrapping value/invalid/errors) is that page's own form-state plumbing,
/// not defined here; see the Radio group page for the live version.
const String _compositionSetCode = '''Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  mainAxisSize: MainAxisSize.min,
  children: <Widget>[
    const ElFieldLegend('Payout rhythm'),
    SizedBox(height: ElFieldLegend.spaceBelow),
    ElFieldSet(
      tightForGroup: true,
      children: <Widget>[
        ElRadioGroup<String>(
          value: field.value,
          onChanged: (String next) => field.value = next,
          gap: ElFieldSet.groupGap,
          invalid: field.invalid,
          focusNode: field.focusNode,
          label: 'Payout rhythm',
          hint: field.errors.isEmpty ? null : field.errors.join(' '),
          children: const <Widget>[
            ElField(
              label: 'Daily',
              orientation: ElFieldOrientation.horizontal,
              child: ElRadioGroupItem<String>(value: 'daily'),
            ),
            ElField(
              label: 'Weekly',
              orientation: ElFieldOrientation.horizontal,
              child: ElRadioGroupItem<String>(value: 'weekly'),
            ),
          ],
        ),
        if (field.errors.isNotEmpty) ElFieldError(field.errors),
      ],
    ),
  ],
)''';

const String _usageHorizontalCode = '''ElField(
  label: 'Email me about product updates',
  orientation: ElFieldOrientation.horizontal,
  child: ElCheckbox(
    state: subscribed ? ElCheckboxState.checked : ElCheckboxState.unchecked,
    onChanged: (ElCheckboxState next) {
      setState(() => subscribed = next == ElCheckboxState.checked);
    },
  ),
)''';

/// A live, functioning `ElField`-wrapped checkbox: proof the composition
/// Checkbox documents actually renders and toggles, not just a code
/// excerpt.
class _CheckboxFieldSpecimen extends StatefulWidget {
  const _CheckboxFieldSpecimen();

  @override
  State<_CheckboxFieldSpecimen> createState() =>
      _CheckboxFieldSpecimenState();
}

class _CheckboxFieldSpecimenState extends State<_CheckboxFieldSpecimen> {
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

class _SwitchSpecimen extends StatefulWidget {
  const _SwitchSpecimen();

  @override
  State<_SwitchSpecimen> createState() => _SwitchSpecimenState();
}

class _SwitchSpecimenState extends State<_SwitchSpecimen> {
  bool _mfaEnabled = false;

  @override
  Widget build(BuildContext context) => ElField(
    label: 'Two-factor authentication',
    description: 'Require a code from your authenticator app at sign-in.',
    orientation: ElFieldOrientation.horizontal,
    child: ElSwitch(
      value: _mfaEnabled,
      onChanged: (bool next) => setState(() => _mfaEnabled = next),
    ),
  );
}

const String _switchCode = '''ElField(
  label: 'Two-factor authentication',
  description: 'Require a code from your authenticator app at sign-in.',
  orientation: ElFieldOrientation.horizontal,
  child: ElSwitch(
    value: mfaEnabled,
    onChanged: (bool next) => setState(() => mfaEnabled = next),
  ),
)''';

/// Quoted from `example/lib/pages/forms.dart`'s `#profile-panel`
/// composition (the `ElFieldGroup` around the Handle and Email fields),
/// trimmed to the two fields. Illustrative — `handle`/`email` are that
/// page's own form-state plumbing, not defined here; see the Form page for
/// the live, bound version.
const String _compositionGroupCode = '''ElFieldGroup(
  children: <Widget>[
    ElField(
      label: 'Handle',
      description: 'This is how you appear on leaderboards.',
      errors: handle.errors,
      focusNode: handle.focusNode,
      child: ElInput(
        controller: handle.controller,
        placeholder: 'ayoub',
        autofillHints: const <String>[AutofillHints.username],
      ),
    ),
    ElField(
      label: 'Email',
      description: 'Receipts and nothing else.',
      errors: email.errors,
      focusNode: email.focusNode,
      child: ElInput(
        controller: email.controller,
        placeholder: 'you@example.com',
        keyboardType: TextInputType.emailAddress,
        autofillHints: const <String>[AutofillHints.email],
      ),
    ),
  ],
)''';

class _ValidationSpecimen extends StatelessWidget {
  const _ValidationSpecimen();

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: el(5),
    runSpacing: el(5),
    children: <Widget>[
      SizedBox(
        width: el(64),
        child: const ElField(
          label: 'errors: [...]',
          errors: <String>['This field is required.'],
          child: ElInput(),
        ),
      ),
      SizedBox(
        width: el(64),
        child: const ElField(
          label: 'invalid: true, no errors',
          invalid: true,
          child: ElInput(),
        ),
      ),
    ],
  );
}

const String _validationCode =
    '''// invalid defaults to errors.isNotEmpty, but the two are separable.
ElField(
  label: 'Email',
  errors: const <String>['Enter a valid email address.'],
  child: const ElInput(),
)

// invalid: true colours the label and control red with no message: the
// aria-invalid-only shape the reference's own inputs page uses.
ElField(
  label: 'Email',
  invalid: true,
  child: const ElInput(),
)''';

/* ── Disclosure content ─────────────────────────────────────────────────── */

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsAnchor(
        id: 'api-elfield',
        child: DocsApiTable(title: 'ElField', facts: _fieldFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elfieldscope',
        child: DocsApiTable(title: 'ElFieldScope', facts: _fieldScopeFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elfieldactivator',
        child: DocsApiTable(
          title: 'ElFieldActivator',
          facts: _fieldActivatorFacts,
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elfieldgroup',
        child: DocsApiTable(title: 'ElFieldGroup', facts: _fieldGroupFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elfieldset',
        child: DocsApiTable(title: 'ElFieldSet', facts: _fieldSetFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elfieldlegend',
        child: DocsApiTable(title: 'ElFieldLegend', facts: _fieldLegendFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elfieldlabel',
        child: DocsApiTable(title: 'ElFieldLabel', facts: _fieldLabelFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elfielddescription',
        child: DocsApiTable(
          title: 'ElFieldDescription',
          facts: _fieldDescriptionFacts,
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elfielderror',
        child: DocsApiTable(title: 'ElFieldError', facts: _fieldErrorFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elfieldorientation',
        child: DocsApiTable(
          title: 'ElFieldOrientation',
          facts: _fieldOrientationFacts,
        ),
      ),
    ],
  );
}

const List<DocsApiFact> _fieldFacts = <DocsApiFact>[
  DocsApiFact(name: 'child', type: 'Widget', description: 'Required. The control.'),
  DocsApiFact(
    name: 'label',
    type: 'String?',
    description:
        "FieldLabel's text: rendered visibly and announced as the "
        "control's accessible name through ElFieldScope, one string, one "
        'announcement.',
  ),
  DocsApiFact(
    name: 'description',
    type: 'String?',
    description:
        "FieldDescription's text, folded into the control's Semantics.hint.",
  ),
  DocsApiFact(
    name: 'errors',
    type: 'List<String>',
    description:
        'Defaults to []. FieldError\'s messages. Empty renders nothing at '
        'all: see States.',
  ),
  DocsApiFact(
    name: 'invalid',
    type: 'bool?',
    description:
        'Defaults to null, which means "there are messages" '
        '(errors.isNotEmpty). Settable separately from errors: see '
        'Accessibility.',
  ),
  DocsApiFact(
    name: 'enabled',
    type: 'bool',
    description:
        "Defaults to true. false disables the control through "
        "ElFieldScope, ANDed with the control's own enabled, so the "
        'control cannot opt back in.',
  ),
  DocsApiFact(
    name: 'focusNode',
    type: 'FocusNode?',
    description:
        'The node the label focuses (or a failed submit lands on) when '
        'the control registers no activator of its own.',
  ),
  DocsApiFact(
    name: 'orientation',
    type: 'ElFieldOrientation',
    description:
        'Defaults to vertical. See the ElFieldOrientation table below '
        'for both values.',
  ),
  DocsApiFact(
    name: 'ElField.gap',
    type: 'static double (get)',
    description: '8px: between label, control, and what follows.',
  ),
  DocsApiFact(
    name: 'ElField.describedGap',
    type: 'static double (get)',
    description:
        '4px: the gap the description tucks to the moment an error '
        'appears below it (gap − 4px).',
  ),
];

const List<DocsApiFact> _fieldScopeFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'label',
    type: 'String?',
    description: "The visible label's text, announced as the control's name.",
  ),
  DocsApiFact(
    name: 'describedBy',
    type: 'String?',
    description:
        'Description, then error messages, joined in DOM order: what a '
        'control reads as its Semantics.hint.',
  ),
  DocsApiFact(
    name: 'invalid',
    type: 'bool',
    description:
        'Defaults to false. A control ORs this with its own invalid flag.',
  ),
  DocsApiFact(
    name: 'enabled',
    type: 'bool',
    description:
        'Defaults to true. A control ANDs this with its own enabled flag.',
  ),
  DocsApiFact(
    name: 'focusNode',
    type: 'FocusNode?',
    description:
        'The node a tapped ElFieldLabel focuses when no activator is '
        'registered.',
  ),
  DocsApiFact(
    name: 'activator',
    type: 'ElFieldActivator?',
    description:
        'Where a control registers what activating this field does. A '
        'hand-built scope may leave this null.',
  ),
  DocsApiFact(
    name: 'child',
    type: 'Widget',
    description: 'Required. The control this scope wraps.',
  ),
  DocsApiFact(
    name: 'ElFieldScope.maybeOf',
    type: 'static ElFieldScope? Function(BuildContext)',
    description:
        'The InheritedWidget lookup a control reads to opt into '
        'everything above.',
  ),
];

const List<DocsApiFact> _fieldActivatorFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'callback',
    type: 'VoidCallback?',
    description:
        'Mutable, not constructor-injected: a one-slot holder. A control '
        'assigns what its own activation does during its own build; '
        'ElFieldLabel reads it at tap time. Every instance starts with '
        'callback: null.',
  ),
];

const List<DocsApiFact> _fieldGroupFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'children',
    type: 'List<Widget>',
    description: 'Required. The fields to stack.',
  ),
  DocsApiFact(
    name: 'nested',
    type: 'bool',
    description:
        'Defaults to false. true closes the gap from 20px to 16px, for '
        'a group inside a group.',
  ),
  DocsApiFact(
    name: 'ElFieldGroup.gap',
    type: 'static double (get)',
    description: '20px: the default gap between fields.',
  ),
  DocsApiFact(
    name: 'ElFieldGroup.nestedGap',
    type: 'static double (get)',
    description: '16px: the nested: true gap.',
  ),
];

const List<DocsApiFact> _fieldSetFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'children',
    type: 'List<Widget>',
    description:
        'Required. Everything inside the set: typically a selection '
        'group, then an optional ElFieldError.',
  ),
  DocsApiFact(
    name: 'tightForGroup',
    type: 'bool',
    description:
        'Defaults to false. true drops the 16px gap to 12px, for when '
        'a radio or checkbox group is a direct child.',
  ),
  DocsApiFact(
    name: 'ElFieldSet.gap',
    type: 'static double (get)',
    description: '16px: the default gap.',
  ),
  DocsApiFact(
    name: 'ElFieldSet.groupGap',
    type: 'static double (get)',
    description: '12px: the tightForGroup: true gap.',
  ),
];

const List<DocsApiFact> _fieldLegendFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'text',
    type: 'String',
    description: 'Required, positional. The heading over a ElFieldSet.',
  ),
  DocsApiFact(
    name: 'ElFieldLegend.spaceBelow',
    type: 'static double (get)',
    description:
        '6px, on top of: not instead of: the enclosing set\'s own gap, '
        "because a rendered legend sits above the set rather than inside "
        'its flex flow. See Fieldset above.',
  ),
];

const List<DocsApiFact> _fieldLabelFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'text',
    type: 'String',
    description: 'Required, positional.',
  ),
  DocsApiFact(
    name: 'spec',
    type: 'ElTypeSpec?',
    description:
        'Overrides ElComponentType.fieldLabel. ElFieldLabel.normal is '
        'the one built-in override — see statics.',
  ),
  DocsApiFact(
    name: 'focusNode',
    type: 'FocusNode?',
    description:
        'Focused on tap when no activator is registered. Falls back to '
        'the enclosing ElFieldScope.',
  ),
  DocsApiFact(
    name: 'activator',
    type: 'ElFieldActivator?',
    description:
        'Where the control registered what activating this field does. '
        'Falls back to the enclosing ElFieldScope.',
  ),
  DocsApiFact(
    name: 'enabled',
    type: 'bool',
    description:
        'Defaults to true. false dims the label to 50% opacity and '
        'drops its tap handler.',
  ),
  DocsApiFact(
    name: 'onTap',
    type: 'VoidCallback?',
    description:
        "The caller's own handler: outranks both the activator and the "
        'focus-node rungs. See Accessibility for the full ladder.',
  ),
  DocsApiFact(
    name: 'ElFieldLabel.normal',
    type: 'static ElTypeSpec (get)',
    description:
        'fieldLabel\'s size and leading with textSm\'s 400 weight '
        'substituted in: the filter-row "font-normal" override.',
  ),
  DocsApiFact(
    name: 'ElFieldLabel.disabledOpacity',
    type: 'static const double',
    description: '0.50.',
  ),
];

const List<DocsApiFact> _fieldDescriptionFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'text',
    type: 'String',
    description: 'Required, positional.',
  ),
];

const List<DocsApiFact> _fieldErrorFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'messages',
    type: 'List<String>',
    description:
        'Required, positional. Deduplicated before render. One message '
        'renders as a bare line; two or more render as a bulleted list.',
  ),
  DocsApiFact(
    name: 'ElFieldError.listIndent',
    type: 'static double (get)',
    description: '16px: where the bullet list starts.',
  ),
  DocsApiFact(
    name: 'ElFieldError.itemGap',
    type: 'static double (get)',
    description: '4px: between list items.',
  ),
];

const List<DocsApiFact> _fieldOrientationFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'vertical',
    type: 'enum value',
    description:
        'The default. Column: label, gap, control, then description and '
        'error. Every field on the reference except its horizontal '
        'switch, checkbox, and radio rows.',
  ),
  DocsApiFact(
    name: 'horizontal',
    type: 'enum value',
    description:
        'Row: control first, then a gap, then the label, grown to fill '
        'the remaining width so the whole row is a click target, not '
        'just the words. Used for ElCheckbox, ElSwitch, and each '
        'ElRadioGroupItem.',
  ),
];

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Rest',
    treatment:
        'Label, control, and description render in order; no '
        'destructive tint; no ElFieldError widget exists in the tree at '
        'all.',
    userSignal:
        'Plain label and helper text at theme.foreground and '
        'theme.mutedForeground respectively.',
  ),
  DocsStateFact(
    state: 'Error',
    treatment:
        'errors non-empty (or invalid: true) merges theme.destructiveInk '
        'over the label and the control\'s own text via DefaultTextStyle, '
        'and mounts a ElFieldError node wrapped in '
        'Semantics(liveRegion: true).',
    userSignal:
        'Red label and message text, and the message is announced the '
        'instant it appears: see Accessibility for exactly what '
        '"announced" means here.',
  ),
  DocsStateFact(
    state: 'Empty (no errors)',
    treatment:
        'ElFieldError.build returns const SizedBox.shrink() when '
        'messages is empty: not a zero-height live region kept mounted '
        'for later.',
    userSignal:
        'Nothing extra in the tree to find or announce, the '
        'anti-pattern the component\'s own source comment calls out by '
        'name.',
  ),
  DocsStateFact(
    state: 'Disabled',
    treatment:
        "enabled: false publishes ElFieldScope.enabled: false; a "
        'wrapped control reads widget.enabled && (scope?.enabled ?? '
        "true), so the field's false always wins even if the control's "
        'own enabled is left true.',
    userSignal:
        "Whatever the control's own disabled look is (ElInput and "
        'ElCheckbox both dim). ElFieldLabel itself drops to 50% opacity '
        'and its tap handler is removed.',
  ),
  DocsStateFact(
    state: 'Hover / Pressed / Focus-visible / Selected / Loading / Success',
    treatment:
        'N/A, ElField paints none of these itself. A focus ring, a '
        'hover skin, a pressed squash, a selected fill, a spinner, and a '
        'success tint all belong to the wrapped control (ElInput, '
        'ElCheckbox, ElSwitch…), each documented on its own component '
        'page.',
    userSignal:
        'What the control renders is what shows, ElField contributes '
        'only the label, gap, and error wiring around it.',
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment:
        'N/A: field.dart imports no motion foundation and holds no '
        "AnimationController; the description's 4px tuck when an error "
        'appears is an immediate relayout, not a tween.',
    userSignal: 'Nothing to still: there was never anything animating.',
  ),
];

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: const <Widget>[
      _A11yRow(
        'Semantic role',
        'ElField wraps its whole subtree in Semantics(container: true, '
            'validationResult:), the nearest Flutter analogue to '
            'role="group" plus aria-invalid. This is set unconditionally '
            'on the field itself: it does not depend on the wrapped '
            'control opting in.',
      ),
      _A11yRow(
        'Label wiring',
        'label is threaded through ElFieldScope so the control reads it '
            'as its own accessible name (widget.label ?? scope?.label). '
            'The visible ElFieldLabel wraps its text in ExcludeSemantics '
            "so the same words are not announced twice, once as the "
            'label, once as the name.',
      ),
      _A11yRow(
        'Description wiring',
        "description feeds Semantics.hint on the control (the "
            'aria-describedby analogue) by joining with errors, '
            'description first, into one string. ElField renders the '
            'visible ElFieldDescription too, but wraps that copy in '
            "ExcludeSemantics, the string is already the control's hint, "
            'so this is the one avoided double-announcement, not a '
            'second one.',
      ),
      _A11yRow(
        'Error wiring and live region: is it announced?',
        'Yes. ElFieldError wraps its message(s) in Semantics(container: '
            'true, liveRegion: true), the role="alert" translation. '
            'Because ElFieldError.build returns null-equivalent '
            '(SizedBox.shrink()) when messages is empty, that live-region '
            'node does not exist in the tree at rest: going from zero to '
            'one-or-more errors mounts a brand-new live-region node, '
            'which is what triggers the announcement, rather than '
            'updating an existing region some screen readers coalesce or '
            'miss. Clearing the error unmounts the node silently: nothing '
            'is announced when a field becomes valid again.',
      ),
      _A11yRow(
        'Touch target',
        "ElFieldLabel's own tap target is intentionally narrowed to the "
            'words themselves (Align + heightFactor: 1, no forced width): '
            'tapping empty space to the right of a short label inside a '
            "wide field does not activate the control. This mirrors an "
            "HTML <label>'s own click behaviour; it is not a hit-area "
            'bug.',
      ),
      _A11yRow(
        'Non-colour signal',
        "The error message's own words are the primary signal; "
            'destructiveInk on top of that is reinforcement, not the '
            'only cue, ElField never ships a red-only, textless error '
            'state.',
      ),
      _A11yRow(
        'Known platform differences',
        'None observed: the same widget tree renders on every target '
            'platform this package supports.',
      ),
      _A11yRow(
        'Documented drift: invalid and errors are separable',
        "invalid defaults to errors.isNotEmpty but can be set "
            'independently. The reference itself does this two different '
            'ways on two different pages: its inputs page never sets a '
            "field's own invalid flag (only the control's aria-invalid), "
            'so no label there turns red despite an API table claiming '
            'the field "handles the invalid colouring for the whole '
            'group": while its forms page does set it, and there it '
            'fires. ElField.invalid reproduces that separable switch '
            'rather than papering over it; the "invalid: true, no '
            'message" specimen in Preview is that exact case.',
        last: true,
      ),
    ],
  );
}

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
          ElText(label, ElType.section, color: theme.actionInk),
          SizedBox(height: el(1)),
          ElText(body, ElType.small),
        ],
      ),
    );
  }
}

/// Read directly off `ElFieldLabel.build` (`lib/src/components/field.dart`):
/// field.dart wires no `Focus.onKeyEvent` of its own anywhere, so every fact
/// here is about what does NOT happen.
class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'No key handling of its own: field.dart wires no '
            'Focus.onKeyEvent anywhere. Every key a keyboard user presses '
            'while a field is focused reaches whatever control ElField '
            'wraps, unfiltered.',
        'ElFieldLabel is tap-only: it is built from a bare GestureDetector, '
            'never a Focus node of its own. It cannot receive keyboard '
            'focus and has no key binding — a keyboard user tabs straight '
            'past the visible label to the control it names.',
        'Tab order: field.dart declares no FocusTraversalPolicy. Tab and '
            'Shift+Tab walk whatever order the surrounding page — or '
            'ElFieldGroup\'s own child order — already declares.',
        'focusNode only moves focus programmatically, never in response '
            'to a key event: it is the node a tapped ElFieldLabel calls '
            '.requestFocus() on (the last rung of the tap-activation '
            'ladder, see Accessibility), and the node a failed ElForm '
            'submit lands on via focusFirstError().',
        'The wrapped control\'s own keyboard behaviour (Enter/Space on '
            'ElCheckbox and ElSwitch, arrow keys on a ElRadioGroup, typed '
            'characters on ElInput and ElTextarea) is entirely that '
            "control's own: field.dart neither adds nor removes a "
            'binding.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'No responsive breakpoints of its own, ElField reads no '
            'MediaQuery and renders the same Column or Row at 390px and '
            '1440px. *:w-full is real here: CrossAxisAlignment.stretch '
            'forces every direct child (label, control, description, '
            'error) to the field\'s own width, so a ElInput inside a '
            "ElField always fills the field's measure rather than sizing "
            'to its content.',
        'ElFieldGroup and ElFieldSet are Columns with mainAxisSize: '
            'MainAxisSize.min: they take exactly the height their '
            'children need and never impose a width; the surrounding '
            'layout (a ElCard, a form panel measure) decides how wide a '
            'stack of fields gets.',
        'Keyboard activation (the label tap ladder above) and pointer '
            'activation behave identically on every Flutter target this '
            'package supports: there is no platform channel and nothing '
            'in field.dart branches on platform.',
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
            value: 'field',
            description:
                'registry/components/field.json exists and is '
                'installable through the CLI today.',
          ),
          const DocsInstallFact(
            label: 'Destination',
            value: 'lib/components/ui/field.dart',
            description:
                'The same lib/components/ui/ target every component '
                'installs to, in both foundation modes.',
          ),
          const DocsInstallFact(
            label: 'Foundation',
            value: 'source or package compatible',
            description:
                'The manifest names source-foundation and rule, nothing '
                'here is package-mode-only.',
          ),
          DocsInstallFact(
            label: 'Dependencies',
            value: fieldDoc.dependencies.join(', '),
            description:
                "The manifest's registryDependencies, resolved "
                'automatically by the registry client. rule supplies '
                'ElRules.dedupe, used to deduplicate errors before '
                'render.',
          ),
          const DocsInstallFact(
            label: 'Assets',
            value: 'none',
            description: 'No image, font, or shader asset is referenced.',
          ),
          const DocsInstallFact(
            label: 'Shaders',
            value: 'none',
            description:
                'The bullet marker in a multi-message ElFieldError is a '
                'text glyph, not a painted shape.',
          ),
          const DocsInstallFact(
            label: 'Platforms',
            value: 'Android, iOS, Web, macOS, Windows, Linux',
            description:
                'Pure widget composition; nothing platform-gated.',
          ),
          const DocsInstallFact(
            label: 'Verified',
            value: 'package tests + this docs specimen',
            description:
                "test/inputs_test.dart's 'ElField' and 'ElFieldSet' "
                "groups, plus this page's own live specimens. No fixture "
                'install was run as part of writing this page.',
          ),
        ],
      ),
      SizedBox(height: el(4)),
      const DocsLinkRow(
        links: <DocsLink>[
          DocsLink(label: 'Form', route: '/components/form'),
          DocsLink(label: 'Checkbox', route: '/components/checkbox'),
          DocsLink(label: 'Radio group', route: '/components/radio'),
          DocsLink(label: 'Switch', route: '/components/switch'),
          DocsLink(label: 'Textarea', route: '/components/textarea'),
          DocsLink(label: 'Slider', route: '/components/slider'),
          DocsLink(
            label: 'Native select',
            route: '/components/native_select',
          ),
          DocsLink(
            label: 'Selection control',
            route: '/components/selection_control',
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
        label: 'destructiveInk',
        value: 'theme.destructiveInk',
        description:
            'The one theme colour ElField reads directly, merged over '
            'the subtree via DefaultTextStyle when invalid. Everything '
            'else — the label\'s own ink, the description\'s '
            'theme.mutedForeground, the control\'s own fill and border — '
            "belongs to ElText's type specs or to the wrapped control, "
            'not to field.dart itself.',
      ),
      DocsInstallFact(
        label: 'Type specs',
        value:
            'ElComponentType.fieldLabel, ElType.small, '
            'ElComponentType.textSm',
        description:
            'The label, description, and error each carry their own '
            'fixed type spec: none configurable per instance except '
            'ElFieldLabel.spec, which ElField itself never overrides '
            '(it always renders the plain fieldLabel spec).',
      ),
      DocsInstallFact(
        label: 'Shape and elevation',
        value: 'none',
        description:
            'No radius, shadow, or surface token appears in field.dart: '
            'it lays text and gaps out and lets the wrapped control '
            'paint every surface.',
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
