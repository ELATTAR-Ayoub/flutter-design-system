/// Public component documentation for the field component.
///
/// Reshaped to shadcn parity (worker brief, 2026-08-23) against
/// `https://ui.shadcn.com/docs/components/base/field`: the same section
/// order that page uses, ending in the six sections every page in this
/// docs site adds on top: States, Accessibility, Responsive, Dependencies,
/// Theming, Source. `overview` and the standalone `status` heading are
/// gone (shadcn's own page has neither; the status facts now live inside
/// Installation, and the "when to use this" guidance lives in
/// [fieldExpandedDescription] as the page lead, same as before). `variants`
/// is gone too: [DsFieldOrientation] is now the tenth table inside API
/// Reference, next to shadcn's own choice of folding every prop, including
/// enums, into one API section rather than a separate one.
///
/// `field` is Wave 2 of the component-documentation plan (form and input
/// family) and: like `tooltip` in Wave 1: already carries a real
/// `registry/components/field.json` manifest, so Installation below renders
/// the genuine `elattar add field` command rather than a "not available yet"
/// disclosure.
///
/// Unlike every sibling documented so far, `field` is not one widget but a
/// family of nine classes plus one enum: [DsField] itself, the threading
/// primitives [DsFieldScope] and [DsFieldActivator], the layout orientation
/// enum [DsFieldOrientation], the stacking helpers [DsFieldGroup] and
/// [DsFieldSet] with its [DsFieldLegend], and the three parts a hand-built
/// composition reaches for directly, [DsFieldLabel], [DsFieldDescription],
/// and [DsFieldError]. API Reference gives each of the nine classes plus
/// the one enum its own [DocsApiTable] rather than merging them into one,
/// because the classes are genuinely different shapes doing different
/// jobs, not overloads of one constructor.
///
/// shadcn's own per-control sections (Input, Textarea, Select, Slider,
/// Fieldset, Checkbox, Radio, Switch, Choice Card, Field Group) are mirrored
/// where [DsField] genuinely wraps that control: [DsInput], [DsTextarea],
/// [DsNativeSelect], [DsSlider], [DsFieldSet], [DsCheckbox], and [DsSwitch]
/// all read the ambient [DsFieldScope] the same way, so each gets its own
/// section. Radio has no section of its own: the only real
/// radio-inside-a-field composition this page has is the Fieldset demo
/// (a lone [DsField]-wrapped [DsRadioGroupItem] outside a [DsFieldSet]
/// is not how the source or forms.dart ever builds one), so a second,
/// near-identical heading would show nothing new. Choice Card and RTL are
/// skipped outright: this package has no card-styled selection component
/// to wrap, and no field.dart code path is direction-aware beyond the
/// [Directionality] every widget already inherits.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/docs_code.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../kit.dart';
import '../catalog.dart';
import 'meta.dart';

class FieldDocPage extends StatelessWidget {
  const FieldDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) {
    final ComponentDocEntry entry = fieldDoc;
    return DocsLayout(
      route: entry.route,
      intro: DocsPageIntro(
        eyebrow: 'COMPONENTS / BASE',
        title: entry.title,
        description: fieldExpandedDescription,
      ),
      breadcrumbs: const <DsBreadcrumbEntry>[
        DsBreadcrumbEntry.link('Components'),
        DsBreadcrumbEntry.page('Field'),
      ],
      // Wave 2's own inventory (Phase J plan), in the plan's own order.
      // Neither neighbouring route is registered yet either: the whole
      // wave's sidebar and previous/next chain is stitched together once
      // the supervisor aggregates every meta.dart.
      sidebar: const <DocsSidebarEntry>[
        DocsSidebarEntry(
          title: 'Button group',
          route: '/components/button_group',
        ),
        DocsSidebarEntry(title: 'Combobox', route: '/components/combobox'),
        DocsSidebarEntry(
          title: 'Field',
          route: '/components/field',
          selected: true,
        ),
        DocsSidebarEntry(title: 'Form', route: '/components/form'),
        DocsSidebarEntry(
          title: 'Input group',
          route: '/components/input_group',
        ),
        DocsSidebarEntry(title: 'Input OTP', route: '/components/input_otp'),
        DocsSidebarEntry(
          title: 'Native select',
          route: '/components/native_select',
        ),
        DocsSidebarEntry(title: 'Radio', route: '/components/radio'),
        DocsSidebarEntry(
          title: 'Selection control',
          route: '/components/selection_control',
        ),
        DocsSidebarEntry(title: 'Slider', route: '/components/slider'),
        DocsSidebarEntry(title: 'Textarea', route: '/components/textarea'),
      ],
      toc: const <DocsTocEntry>[
        DocsTocEntry(title: 'Installation', anchor: 'install'),
        DocsTocEntry(title: 'Usage', anchor: 'usage'),
        DocsTocEntry(title: 'Composition', anchor: 'composition'),
        DocsTocEntry(title: 'Anatomy', anchor: 'anatomy'),
        DocsTocEntry(title: 'Form', anchor: 'form'),
        DocsTocEntry(title: 'Input', anchor: 'input'),
        DocsTocEntry(title: 'Textarea', anchor: 'textarea'),
        DocsTocEntry(title: 'Select', anchor: 'select'),
        DocsTocEntry(title: 'Slider', anchor: 'slider'),
        DocsTocEntry(title: 'Fieldset', anchor: 'fieldset'),
        DocsTocEntry(title: 'Checkbox', anchor: 'checkbox'),
        DocsTocEntry(title: 'Switch', anchor: 'switch'),
        DocsTocEntry(title: 'Field group', anchor: 'field-group'),
        DocsTocEntry(
          title: 'Validation and errors',
          anchor: 'validation-errors',
        ),
        DocsTocEntry(title: 'API Reference', anchor: 'api'),
        DocsTocEntry(title: 'States', anchor: 'states'),
        DocsTocEntry(title: 'Accessibility', anchor: 'accessibility'),
        DocsTocEntry(title: 'Responsive', anchor: 'responsive'),
        DocsTocEntry(title: 'Dependencies', anchor: 'dependencies'),
        DocsTocEntry(title: 'Theming', anchor: 'theming'),
        DocsTocEntry(title: 'Source', anchor: 'source'),
      ],
      previous: const DocsPageLink(
        title: 'Combobox',
        route: '/components/combobox',
      ),
      next: const DocsPageLink(title: 'Form', route: '/components/form'),
      onNavigate: onNavigate,
      child: _FieldArticle(entry: entry),
    );
  }
}

class _FieldArticle extends StatelessWidget {
  const _FieldArticle({required this.entry});

  final ComponentDocEntry entry;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Column(
      key: const ValueKey<String>('field-doc-article'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DocsCodeExample(
          title: 'Field specimens',
          description:
              'A vertical field with a live, toggleable error; a '
              'horizontal field wrapping a checkbox, activatable by tapping '
              'either the control or its visible label; a disabled field; '
              'and the separable invalid-versus-errors pairing the source '
              'itself documents as a drift between the reference\'s inputs '
              'and forms pages.',
          preview: const _FieldPreview(),
          command: DocsCodeCommand(command: entry.command),
        ),
        DsSection(
          id: 'install',
          title: 'Installation',
          description:
              'field already has a registry manifest: this installs '
              'lib/src/components/field.dart and its dependencies, '
              'resolved automatically.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              DocsCodeExample(
                title: 'Installation',
                command: DocsCodeCommand(
                  command: entry.command,
                  description:
                      'Installs field.dart and resolves source-foundation '
                      'and ds-rule automatically.',
                ),
                manualFiles: const <DocsCodeFile>[
                  DocsCodeFile(
                    path: 'lib/components/ui/field.dart',
                    code:
                        "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
                        '// Copy the generated field source here when using '
                        'manual mode.',
                  ),
                ],
              ),
              SizedBox(height: ds(5)),
              const DocsInstallFacts(
                title: 'Status',
                facts: <DocsInstallFact>[
                  DocsInstallFact(
                    label: 'Status',
                    value: 'Stable: registered in the registry',
                    description:
                        'DsField and the rest of the field family are '
                        'exported from the public barrel and installable '
                        'through the CLI today.',
                  ),
                  DocsInstallFact(
                    label: 'Version',
                    value: '0.0.1',
                    description: "The registry manifest's own version field.",
                  ),
                  DocsInstallFact(
                    label: 'Dart / Flutter',
                    value: '>=3.12.2 <4.0.0 / >=3.44.8',
                    description:
                        "The manifest's minDart and minFlutter constraints.",
                  ),
                  DocsInstallFact(
                    label: 'Platforms',
                    value: 'Android, iOS, Web, macOS, Windows, Linux',
                    description:
                        'Pure widget composition: nothing here is '
                        'platform-gated.',
                  ),
                ],
              ),
            ],
          ),
        ),
        DsSection(
          id: 'usage',
          title: 'Usage',
          description:
              'The smallest correct composition, then a stacked group, '
              'then a horizontal field wrapping a checkbox: the three '
              'shapes DsFieldGroup and DsFieldOrientation exist for.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              DsPanel(
                label: 'DART',
                note: 'SMALLEST CORRECT EXAMPLE',
                child: DocsSelectableCodeBlock(code: _usageBasicCode),
              ),
              SizedBox(height: ds(5)),
              DsPanel(
                label: 'DART',
                note: 'STACKED WITH DsFieldGroup',
                child: DocsSelectableCodeBlock(code: _usageGroupCode),
              ),
              SizedBox(height: ds(5)),
              DsPanel(
                label: 'DART',
                note: 'HORIZONTAL, AROUND A CHECKBOX',
                child: DocsSelectableCodeBlock(code: _usageHorizontalCode),
              ),
            ],
          ),
        ),
        DsSection(
          id: 'composition',
          title: 'Composition',
          description:
              'The two shapes a stack of fields takes: independent fields '
              'side by side, or several fields grouped under one legend. '
              'Both are quoted from example/lib/pages/forms.dart below, in '
              'Fieldset and Field group.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              DsPanel(
                label: 'TREE',
                note: 'DsFieldGroup, INDEPENDENT FIELDS',
                child: DocsSelectableCodeBlock(code: _compositionGroupTree),
              ),
              SizedBox(height: ds(5)),
              DsPanel(
                label: 'TREE',
                note: 'DsFieldSet, ONE LEGEND OVER SEVERAL FIELDS',
                child: DocsSelectableCodeBlock(code: _compositionSetTree),
              ),
            ],
          ),
        ),
        DsSection(
          id: 'anatomy',
          title: 'Anatomy',
          description:
              'The one fixed order every DsField renders, and never '
              'varies.',
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: DsWidths.prose),
            child: DsText(
              'FieldLabel, then the control, then FieldDescription, then '
              'FieldError: that order is fixed inside DsField itself, not '
              'a convention a call site has to follow. DsField.gap (8px) '
              'sits between each of those; DsField.describedGap (4px) is '
              'the tighter gap the description keeps once an error joins '
              'it below. DsFieldOrientation.horizontal reorders the first '
              'two, control then label, for a checkbox, switch, or radio '
              'row: see API for both values. A hand-built row that skips '
              'DsField itself, each DsRadioGroupItem\'s own horizontal '
              'DsField in Fieldset below, still carries the same four '
              'ideas through a bare DsFieldScope: label, describedBy, '
              'invalid, enabled.',
              DsType.body,
            ),
          ),
        ),
        DsSection(
          id: 'form',
          title: 'Form',
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: DsWidths.prose),
            child: DsText(
              'DsField wraps one control; Form covers wiring several of '
              'them into a submit flow. The Field group and Fieldset '
              'shapes below are quoted verbatim from '
              'example/lib/pages/forms.dart, the same file Form\'s own '
              'specimens build on: see Form for the validation timing and '
              'submit handling around them.',
              DsType.body,
            ),
          ),
        ),
        DsSection(
          id: 'input',
          title: 'Input',
          description:
              'DsInput already carries its own optional label and hint '
              'for standalone use; leave both null so DsField supplies the '
              'visible label and description instead.',
          child: DsPanel(
            label: 'DART',
            note: 'USERNAME AND PASSWORD',
            child: DocsSelectableCodeBlock(code: _inputCode),
          ),
        ),
        DsSection(
          id: 'textarea',
          title: 'Textarea',
          description:
              'The same DsFieldScope wiring DsInput reads: DsTextarea '
              'ORs its own invalid with the field\'s and focuses the '
              'scope\'s focusNode when it registers none of its own.',
          child: DsPanel(
            label: 'DART',
            note: 'FEEDBACK, WITH A CHARACTER-LIMIT HINT',
            child: DocsSelectableCodeBlock(code: _textareaCode),
          ),
        ),
        DsSection(
          id: 'select',
          title: 'Select',
          description:
              'DsNativeSelect reads DsFieldScope the same way: the closed '
              'control is what the field labels, the reference\'s own '
              'operating-system picker is off-canvas either way.',
          child: DsPanel(
            label: 'DART',
            note: 'DEPARTMENT',
            child: DocsSelectableCodeBlock(code: _selectCode),
          ),
        ),
        DsSection(
          id: 'slider',
          title: 'Slider',
          description:
              'DsField still lays out the label, description and error '
              'around DsSlider, but DsSlider itself reads no DsFieldScope: '
              'it has no invalid ring and no scope-supplied focusNode, so '
              'its own label prop is the one accessible name a caller has '
              'to set directly.',
          child: DsPanel(
            label: 'DART',
            note: 'PRICE RANGE',
            child: DocsSelectableCodeBlock(code: _sliderCode),
          ),
        ),
        DsSection(
          id: 'fieldset',
          title: 'Fieldset',
          description:
              'Quoted from example/lib/pages/forms.dart\'s '
              '_PayoutFieldSet: a DsFieldLegend outside the DsFieldSet '
              '(a rendered legend sits above the set rather than inside '
              'its flex flow), tightForGroup: true because a DsRadioGroup '
              'is the set\'s direct child, and one horizontal DsField per '
              'option so each radio keeps its own selectable label.',
          child: DsPanel(
            label: 'DART',
            note: 'FROM forms.dart, PAYOUT RHYTHM FIELDSET',
            child: DocsSelectableCodeBlock(code: _compositionSetCode),
          ),
        ),
        DsSection(
          id: 'checkbox',
          title: 'Checkbox',
          description:
              'DsFieldOrientation.horizontal puts the checkbox before its '
              'label; the live version above in Preview is this exact '
              'composition, tap either the box or the words.',
          child: DsPanel(
            label: 'DART',
            note: 'HORIZONTAL, AROUND A CHECKBOX',
            child: DocsSelectableCodeBlock(code: _usageHorizontalCode),
          ),
        ),
        DsSection(
          id: 'switch',
          title: 'Switch',
          description:
              'The same horizontal shape as Checkbox above, around '
              'DsSwitch instead.',
          child: DsPanel(
            label: 'DART',
            note: 'TWO-FACTOR AUTHENTICATION',
            child: DocsSelectableCodeBlock(code: _switchCode),
          ),
        ),
        DsSection(
          id: 'field-group',
          title: 'Field group',
          description:
              'Quoted from example/lib/pages/forms.dart\'s '
              '#profile-panel composition, the DsFieldGroup around the '
              'Handle and Email fields, trimmed to the two fields: the '
              'surrounding ListenableBuilder and submit button are that '
              'page\'s own form-state plumbing, not part of what DsField '
              'needs to be shown correctly here.',
          child: DsPanel(
            label: 'DART',
            note: 'FROM forms.dart, HANDLE + EMAIL',
            child: DocsSelectableCodeBlock(code: _compositionGroupCode),
          ),
        ),
        DsSection(
          id: 'validation-errors',
          title: 'Validation and errors',
          description:
              'invalid defaults to errors.isNotEmpty but the two are '
              'separable switches: the live "Separable" specimen in '
              'Preview above is exactly this pairing.',
          child: DsPanel(
            label: 'DART',
            note: 'INVALID AND ERRORS, SET APART',
            child: DocsSelectableCodeBlock(code: _validationCode),
          ),
        ),
        DsSection(
          id: 'api',
          title: 'API Reference',
          description:
              'Every public class, constructor parameter, and static '
              'member the source declares: ten tables, nine classes plus '
              'the one enum, DsFieldOrientation, folded in here rather '
              'than a separate Variants heading.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const DocsApiTable(
                title: 'DsField',
                facts: <DocsApiFact>[
                  DocsApiFact(
                    name: 'child',
                    type: 'Widget',
                    description: 'Required. The control.',
                  ),
                  DocsApiFact(
                    name: 'label',
                    type: 'String?',
                    description:
                        "FieldLabel's text: rendered visibly and "
                        "announced as the control's accessible name "
                        'through DsFieldScope, one string, one '
                        'announcement.',
                  ),
                  DocsApiFact(
                    name: 'description',
                    type: 'String?',
                    description:
                        "FieldDescription's text, folded into the "
                        "control's Semantics.hint.",
                  ),
                  DocsApiFact(
                    name: 'errors',
                    type: 'List<String>',
                    description:
                        'Defaults to []. FieldError\'s messages. Empty '
                        'renders nothing at all: see States.',
                  ),
                  DocsApiFact(
                    name: 'invalid',
                    type: 'bool?',
                    description:
                        'Defaults to null, which means "there are '
                        'messages" (errors.isNotEmpty). Settable '
                        'separately from errors: see Accessibility.',
                  ),
                  DocsApiFact(
                    name: 'enabled',
                    type: 'bool',
                    description:
                        "Defaults to true. false disables the control "
                        "through DsFieldScope, ANDed with the control's "
                        'own enabled, so the control cannot opt back in.',
                  ),
                  DocsApiFact(
                    name: 'focusNode',
                    type: 'FocusNode?',
                    description:
                        'The node the label focuses (or a failed submit '
                        'lands on) when the control registers no '
                        'activator of its own.',
                  ),
                  DocsApiFact(
                    name: 'orientation',
                    type: 'DsFieldOrientation',
                    description:
                        'Defaults to vertical. See the DsFieldOrientation '
                        'table below for both values.',
                  ),
                  DocsApiFact(
                    name: 'DsField.gap',
                    type: 'static double (get)',
                    description:
                        '8px: between label, control, and what follows.',
                  ),
                  DocsApiFact(
                    name: 'DsField.describedGap',
                    type: 'static double (get)',
                    description:
                        '4px: the gap the description tucks to the '
                        'moment an error appears below it (gap − 4px).',
                  ),
                ],
              ),
              SizedBox(height: ds(5)),
              const DocsApiTable(
                title: 'DsFieldScope',
                facts: <DocsApiFact>[
                  DocsApiFact(
                    name: 'label',
                    type: 'String?',
                    description:
                        "The visible label's text, announced as the "
                        "control's name.",
                  ),
                  DocsApiFact(
                    name: 'describedBy',
                    type: 'String?',
                    description:
                        'Description, then error messages, joined in DOM '
                        'order: what a control reads as its Semantics.hint.',
                  ),
                  DocsApiFact(
                    name: 'invalid',
                    type: 'bool',
                    description:
                        'Defaults to false. A control ORs this with its '
                        'own invalid flag.',
                  ),
                  DocsApiFact(
                    name: 'enabled',
                    type: 'bool',
                    description:
                        'Defaults to true. A control ANDs this with its '
                        'own enabled flag.',
                  ),
                  DocsApiFact(
                    name: 'focusNode',
                    type: 'FocusNode?',
                    description:
                        'The node a tapped DsFieldLabel focuses when no '
                        'activator is registered.',
                  ),
                  DocsApiFact(
                    name: 'activator',
                    type: 'DsFieldActivator?',
                    description:
                        'Where a control registers what activating this '
                        'field does. A hand-built scope may leave this '
                        'null.',
                  ),
                  DocsApiFact(
                    name: 'child',
                    type: 'Widget',
                    description: 'Required. The control this scope wraps.',
                  ),
                  DocsApiFact(
                    name: 'DsFieldScope.maybeOf',
                    type: 'static DsFieldScope? Function(BuildContext)',
                    description:
                        'The InheritedWidget lookup a control reads to opt '
                        'into everything above.',
                  ),
                ],
              ),
              SizedBox(height: ds(5)),
              const DocsApiTable(
                title: 'DsFieldActivator',
                facts: <DocsApiFact>[
                  DocsApiFact(
                    name: 'callback',
                    type: 'VoidCallback?',
                    description:
                        'Mutable, not constructor-injected: a one-slot '
                        'holder. A control assigns what its own '
                        'activation does during its own build; '
                        'DsFieldLabel reads it at tap time. Every '
                        'instance starts with callback: null.',
                  ),
                ],
              ),
              SizedBox(height: ds(5)),
              const DocsApiTable(
                title: 'DsFieldGroup',
                facts: <DocsApiFact>[
                  DocsApiFact(
                    name: 'children',
                    type: 'List<Widget>',
                    description: 'Required. The fields to stack.',
                  ),
                  DocsApiFact(
                    name: 'nested',
                    type: 'bool',
                    description:
                        'Defaults to false. true closes the gap from 20px '
                        'to 16px, for a group inside a group.',
                  ),
                  DocsApiFact(
                    name: 'DsFieldGroup.gap',
                    type: 'static double (get)',
                    description: '20px: the default gap between fields.',
                  ),
                  DocsApiFact(
                    name: 'DsFieldGroup.nestedGap',
                    type: 'static double (get)',
                    description: '16px: the nested: true gap.',
                  ),
                ],
              ),
              SizedBox(height: ds(5)),
              const DocsApiTable(
                title: 'DsFieldSet',
                facts: <DocsApiFact>[
                  DocsApiFact(
                    name: 'children',
                    type: 'List<Widget>',
                    description:
                        'Required. Everything inside the set: typically '
                        'a selection group, then an optional DsFieldError.',
                  ),
                  DocsApiFact(
                    name: 'tightForGroup',
                    type: 'bool',
                    description:
                        'Defaults to false. true drops the 16px gap to '
                        '12px, for when a radio or checkbox group is a '
                        'direct child.',
                  ),
                  DocsApiFact(
                    name: 'DsFieldSet.gap',
                    type: 'static double (get)',
                    description: '16px: the default gap.',
                  ),
                  DocsApiFact(
                    name: 'DsFieldSet.groupGap',
                    type: 'static double (get)',
                    description: '12px: the tightForGroup: true gap.',
                  ),
                ],
              ),
              SizedBox(height: ds(5)),
              const DocsApiTable(
                title: 'DsFieldLegend',
                facts: <DocsApiFact>[
                  DocsApiFact(
                    name: 'text',
                    type: 'String',
                    description:
                        'Required, positional. The heading over a '
                        'DsFieldSet.',
                  ),
                  DocsApiFact(
                    name: 'DsFieldLegend.spaceBelow',
                    type: 'static double (get)',
                    description:
                        '6px, on top of: not instead of: the enclosing '
                        "set's own gap, because a rendered legend sits "
                        'above the set rather than inside its flex flow. '
                        'See Fieldset below.',
                  ),
                ],
              ),
              SizedBox(height: ds(5)),
              const DocsApiTable(
                title: 'DsFieldLabel',
                facts: <DocsApiFact>[
                  DocsApiFact(
                    name: 'text',
                    type: 'String',
                    description: 'Required, positional.',
                  ),
                  DocsApiFact(
                    name: 'spec',
                    type: 'DsTypeSpec?',
                    description:
                        'Overrides DsComponentType.fieldLabel. '
                        'DsFieldLabel.normal is the one built-in override '
                        '— see statics.',
                  ),
                  DocsApiFact(
                    name: 'focusNode',
                    type: 'FocusNode?',
                    description:
                        'Focused on tap when no activator is registered. '
                        'Falls back to the enclosing DsFieldScope.',
                  ),
                  DocsApiFact(
                    name: 'activator',
                    type: 'DsFieldActivator?',
                    description:
                        'Where the control registered what activating '
                        'this field does. Falls back to the enclosing '
                        'DsFieldScope.',
                  ),
                  DocsApiFact(
                    name: 'enabled',
                    type: 'bool',
                    description:
                        'Defaults to true. false dims the label to 50% '
                        'opacity and drops its tap handler.',
                  ),
                  DocsApiFact(
                    name: 'onTap',
                    type: 'VoidCallback?',
                    description:
                        "The caller's own handler: outranks both the "
                        'activator and the focus-node rungs. See '
                        'Accessibility for the full ladder.',
                  ),
                  DocsApiFact(
                    name: 'DsFieldLabel.normal',
                    type: 'static DsTypeSpec (get)',
                    description:
                        'fieldLabel\'s size and leading with textSm\'s '
                        '400 weight substituted in: the filter-row '
                        '"font-normal" override.',
                  ),
                  DocsApiFact(
                    name: 'DsFieldLabel.disabledOpacity',
                    type: 'static const double',
                    description: '0.50.',
                  ),
                ],
              ),
              SizedBox(height: ds(5)),
              const DocsApiTable(
                title: 'DsFieldDescription',
                facts: <DocsApiFact>[
                  DocsApiFact(
                    name: 'text',
                    type: 'String',
                    description: 'Required, positional.',
                  ),
                ],
              ),
              SizedBox(height: ds(5)),
              const DocsApiTable(
                title: 'DsFieldError',
                facts: <DocsApiFact>[
                  DocsApiFact(
                    name: 'messages',
                    type: 'List<String>',
                    description:
                        'Required, positional. Deduplicated before '
                        'render. One message renders as a bare line; two '
                        'or more render as a bulleted list.',
                  ),
                  DocsApiFact(
                    name: 'DsFieldError.listIndent',
                    type: 'static double (get)',
                    description: '16px: where the bullet list starts.',
                  ),
                  DocsApiFact(
                    name: 'DsFieldError.itemGap',
                    type: 'static double (get)',
                    description: '4px: between list items.',
                  ),
                ],
              ),
              SizedBox(height: ds(5)),
              const DocsApiTable(
                title: 'DsFieldOrientation',
                facts: <DocsApiFact>[
                  DocsApiFact(
                    name: 'vertical',
                    type: 'enum value',
                    description:
                        'The default. Column: label, gap, control, then '
                        'description and error. Every field on the '
                        'reference except its horizontal switch, checkbox, '
                        'and radio rows.',
                  ),
                  DocsApiFact(
                    name: 'horizontal',
                    type: 'enum value',
                    description:
                        'Row: control first, then a gap, then the label, '
                        'grown to fill the remaining width so the whole '
                        'row is a click target, not just the words. Used '
                        'for DsCheckbox, DsSwitch, and each '
                        'DsRadioGroupItem.',
                  ),
                ],
              ),
            ],
          ),
        ),
        DsSection(
          id: 'states',
          title: 'States and feedback',
          description:
              'DsField itself owns rest, error, disabled, and the empty '
              '"no errors" case. Hover, pressed, focus-visible, selected, '
              'loading, and success belong to whatever control is wrapped '
              '— not to the field around it: so they are recorded here '
              'as N/A with that reason rather than invented.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const DocsStateMatrix(
                facts: <DocsStateFact>[
                  DocsStateFact(
                    state: 'Rest',
                    treatment:
                        'Label, control, and description render in order; '
                        'no destructive tint; no DsFieldError widget '
                        'exists in the tree at all.',
                    userSignal:
                        'Plain label and helper text at theme.foreground '
                        'and theme.mutedForeground respectively.',
                  ),
                  DocsStateFact(
                    state: 'Error',
                    treatment:
                        'errors non-empty (or invalid: true) merges '
                        'theme.destructiveInk over the label and the '
                        "control's own text via DefaultTextStyle, and "
                        'mounts a DsFieldError node wrapped in '
                        'Semantics(liveRegion: true).',
                    userSignal:
                        'Red label and message text, and the message is '
                        'announced the instant it appears: see '
                        'Accessibility for exactly what "announced" means '
                        'here.',
                  ),
                  DocsStateFact(
                    state: 'Empty (no errors)',
                    treatment:
                        'DsFieldError.build returns const SizedBox.shrink() '
                        'when messages is empty: not a zero-height live '
                        'region kept mounted for later.',
                    userSignal:
                        'Nothing extra in the tree to find or announce, '
                        'the anti-pattern the component\'s own source '
                        'comment calls out by name.',
                  ),
                  DocsStateFact(
                    state: 'Disabled',
                    treatment:
                        'enabled: false publishes DsFieldScope.enabled: '
                        'false; a wrapped control reads '
                        'widget.enabled && (scope?.enabled ?? true), so '
                        'the field\'s false always wins even if the '
                        "control's own enabled is left true.",
                    userSignal:
                        "Whatever the control's own disabled look is "
                        '(DsInput and DsCheckbox both dim). DsFieldLabel '
                        'itself drops to 50% opacity and its tap handler '
                        'is removed.',
                  ),
                  DocsStateFact(
                    state:
                        'Hover / Pressed / Focus-visible / Selected / '
                        'Loading / Success',
                    treatment:
                        'N/A, DsField paints none of these itself. A '
                        'focus ring, a hover skin, a pressed squash, a '
                        'selected fill, a spinner, and a success tint all '
                        'belong to the wrapped control (DsInput, '
                        'DsCheckbox, DsSwitch…), each documented on its '
                        'own component page.',
                    userSignal:
                        'What the control renders is what shows, DsField '
                        'contributes only the label, gap, and error '
                        'wiring around it.',
                  ),
                  DocsStateFact(
                    state: 'Reduced motion',
                    treatment:
                        'N/A: field.dart imports no motion foundation '
                        'and holds no AnimationController; the '
                        "description's 4px tuck when an error appears is "
                        'an immediate relayout, not a tween.',
                    userSignal:
                        'Nothing to still: there was never anything '
                        'animating.',
                  ),
                ],
              ),
            ],
          ),
        ),
        DsSection(
          id: 'accessibility',
          title: 'Accessibility and keyboard behavior',
          description:
              'The part this component exists for: turning a label, a '
              'control, a description, and an error into one thing a '
              'screen reader hears as one thing.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              DsPanel(
                label: 'What the semantics tree actually carries',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const _A11yRow(
                      'Semantic role',
                      'DsField wraps its whole subtree in '
                          'Semantics(container: true, validationResult:), '
                          'the nearest Flutter analogue to role="group" '
                          'plus aria-invalid. This is set unconditionally '
                          'on the field itself: it does not depend on the '
                          'wrapped control opting in.',
                    ),
                    const _A11yRow(
                      'Label wiring',
                      'label is threaded through DsFieldScope so the '
                          "control reads it as its own accessible name "
                          '(widget.label ?? scope?.label). The visible '
                          'DsFieldLabel wraps its text in ExcludeSemantics '
                          "so the same words are not announced twice, "
                          'once as the label, once as the name.',
                    ),
                    const _A11yRow(
                      'Description wiring',
                      "description feeds Semantics.hint on the control "
                          '(the aria-describedby analogue) by joining with '
                          'errors, description first, into one string. '
                          'DsField renders the visible DsFieldDescription '
                          'too, but wraps that copy in ExcludeSemantics, '
                          "the string is already the control's hint, so "
                          'this is the one avoided double-announcement, '
                          'not a second one.',
                    ),
                    const _A11yRow(
                      'Error wiring and live region: is it announced?',
                      'Yes. DsFieldError wraps its message(s) in '
                          'Semantics(container: true, liveRegion: true), '
                          'the role="alert" translation. Because '
                          'DsFieldError.build returns null-equivalent '
                          '(SizedBox.shrink()) when messages is empty, '
                          'that live-region node does not exist in the '
                          'tree at rest: going from zero to one-or-more '
                          'errors mounts a brand-new live-region node, '
                          'which is what triggers the announcement, rather '
                          'than updating an existing region some screen '
                          'readers coalesce or miss. Clearing the error '
                          'unmounts the node silently: nothing is '
                          'announced when a field becomes valid again.',
                    ),
                    const _A11yRow(
                      'Keyboard activation: the label tap ladder',
                      'Tapping the visible DsFieldLabel resolves in order: '
                          "the caller's own onTap if supplied; otherwise "
                          "the registered DsFieldActivator's callback if a "
                          'control registered one (this activates the '
                          'control, DsCheckbox and DsSwitch both do); '
                          'otherwise the DsFieldScope.focusNode if one was '
                          'offered (this focuses the control: what a '
                          'text field\'s own activation is); otherwise no '
                          'gesture recogniser is attached at all, on '
                          'purpose, so an ancestor composing its own row '
                          'is never fought for the tap.',
                    ),
                    const _A11yRow(
                      'Focus behavior',
                      'DsField itself never takes focus. focusNode names '
                          'the node a tapped label focuses, or the node a '
                          'failed submit should land on: the actual ring '
                          'and outline are the wrapped control\'s own.',
                    ),
                    const _A11yRow(
                      'Touch target',
                      "DsFieldLabel's own tap target is intentionally "
                          "narrowed to the words themselves (Align + "
                          'heightFactor: 1, no forced width): tapping '
                          'empty space to the right of a short label '
                          'inside a wide field does not activate the '
                          "control. This mirrors an HTML <label>'s own "
                          'click behaviour; it is not a hit-area bug.',
                    ),
                    const _A11yRow(
                      'Non-colour signal',
                      'The error message\'s own words are the primary '
                          "signal; destructiveInk on top of that is "
                          'reinforcement, not the only cue, DsField never '
                          'ships a red-only, textless error state.',
                    ),
                    const _A11yRow(
                      'Known platform differences',
                      'None observed: the same widget tree renders on '
                          'every target platform this package supports.',
                    ),
                    _A11yRow(
                      'Documented drift: invalid and errors are separable',
                      "invalid defaults to errors.isNotEmpty but can be "
                          'set independently. The reference itself does '
                          'this two different ways on two different pages: '
                          "its inputs page never sets a field's own "
                          'invalid flag (only the control\'s aria-invalid), '
                          'so no label there turns red despite an API '
                          'table claiming the field "handles the invalid '
                          'colouring for the whole group": while its '
                          "forms page does set it, and there it fires. "
                          'DsField.invalid reproduces that separable '
                          'switch rather than papering over it; the '
                          '"invalid: true, no message" specimen in Preview '
                          'is that exact case.',
                      last: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        DsSection(
          id: 'responsive',
          title: 'Responsive and platform behavior',
          child: _bullets(theme, <String>[
            'No responsive breakpoints of its own, DsField reads no '
                'MediaQuery and renders the same Column or Row at 390px '
                'and 1440px. *:w-full is real here: CrossAxisAlignment.'
                'stretch forces every direct child (label, control, '
                'description, error) to the field\'s own width, so a '
                'DsInput inside a DsField always fills the field\'s '
                'measure rather than sizing to its content.',
            'DsFieldGroup and DsFieldSet are Columns with '
                'mainAxisSize: MainAxisSize.min: they take exactly the '
                'height their children need and never impose a width; '
                'the surrounding layout (a DsCard, a form panel measure) '
                'decides how wide a stack of fields gets.',
            'Keyboard activation (the label tap ladder above) and pointer '
                'activation behave identically on every Flutter target '
                'this package supports: there is no platform channel and '
                'nothing in field.dart branches on platform.',
          ]),
        ),
        DsSection(
          id: 'dependencies',
          title: 'Dependencies, files, and disclosure',
          description:
              "Elattar's own technical-transparency panel: what this "
              'component needs to install and run.',
          child: DocsInstallFacts(
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
                    'The manifest names source-foundation and ds-rule, '
                    'nothing here is package-mode-only.',
              ),
              DocsInstallFact(
                label: 'Dependencies',
                value: entry.dependencies.join(', '),
                description:
                    "The manifest's registryDependencies, resolved "
                    'automatically by the registry client. ds-rule '
                    'supplies DsRules.dedupe, used to deduplicate errors '
                    'before render.',
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
                    'The bullet marker in a multi-message DsFieldError is '
                    'a text glyph, not a painted shape.',
              ),
              const DocsInstallFact(
                label: 'Platforms',
                value: 'Android, iOS, Web, macOS, Windows, Linux',
                description: 'Pure widget composition; nothing platform-gated.',
              ),
              const DocsInstallFact(
                label: 'Verified',
                value: 'package tests + this docs specimen',
                description:
                    "test/inputs_test.dart's 'DsField' and 'DsFieldSet' "
                    "groups, plus this page's own live specimens. No "
                    'fixture install was run as part of writing this '
                    'page.',
              ),
            ],
          ),
        ),
        DsSection(
          id: 'theming',
          title: 'Theming notes',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              DsPanel(
                label: 'What actually varies with the theme',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    DsText(
                      'DsField reads exactly one theme colour directly: '
                      'theme.destructiveInk, merged over the subtree via '
                      'DefaultTextStyle when invalid. Everything else, '
                      'the label\'s own ink, the description\'s '
                      'theme.mutedForeground, the control\'s own fill and '
                      'border: belongs to DsText\'s type specs or to the '
                      'wrapped control, not to field.dart itself.',
                      DsType.small,
                    ),
                    SizedBox(height: ds(3)),
                    DsText(
                      'The label, description, and error each carry their '
                      'own fixed type spec, DsComponentType.fieldLabel, '
                      'DsType.small, and DsComponentType.textSm '
                      'respectively: none configurable per instance '
                      'except DsFieldLabel.spec, which DsField itself '
                      'never overrides (it always renders the plain '
                      'fieldLabel spec).',
                      DsType.small,
                    ),
                    SizedBox(height: ds(3)),
                    DsText(
                      'No radius, shadow, or surface token appears in '
                      'field.dart: it lays text and gaps out and lets '
                      'the wrapped control paint every surface.',
                      DsType.small,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        DsSection(
          id: 'source',
          title: 'Source and tests',
          child: DocsInstallFacts(
            title: 'Source and tests',
            facts: <DocsInstallFact>[
              DocsInstallFact(
                label: 'Source',
                value: entry.sourcePath,
                description: 'The authoritative package source.',
              ),
              const DocsInstallFact(
                label: 'GitHub',
                value:
                    'github.com/ELATTAR-Ayoub/flutter-design-system/blob/'
                    'main/lib/src/components/field.dart',
                description:
                    "The registry manifest's own sourceLink, verbatim.",
              ),
              const DocsInstallFact(
                label: 'Package tests',
                value: "test/inputs_test.dart ('DsField', 'DsFieldSet')",
                description:
                    'Geometry, semantics, the label activation ladder, '
                    'and the live-region contract, exercised against the '
                    'real component.',
              ),
              const DocsInstallFact(
                label: 'Docs specimen',
                value: 'example/test/components_docs/field_test.dart',
                description:
                    "This page's own per-class API-completeness, live "
                    'error-toggle, live checkbox-and-label-tap, and '
                    'theme coverage.',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Widget _bullets(DsThemeData theme, List<String> lines) => ConstrainedBox(
  constraints: const BoxConstraints(maxWidth: DsWidths.prose),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      for (final String line in lines) ...<Widget>[
        DsText('•  $line', DsType.small, color: theme.mutedForeground),
        SizedBox(height: ds(2)),
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
    final DsThemeData theme = DsTheme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : ds(3)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DsText(label, DsType.label, color: theme.actionInk),
          SizedBox(height: ds(1)),
          DsText(body, DsType.small),
        ],
      ),
    );
  }
}

const String _usageBasicCode =
    '''import 'package:elattar_design_system/elattar_design_system.dart';

DsField(
  label: 'Display name',
  description: 'Shown publicly on your profile.',
  child: DsInput(placeholder: 'Astra Vale'),
)''';

const String _usageGroupCode = '''DsFieldGroup(
  children: <Widget>[
    DsField(
      label: 'Handle',
      description: 'This is how you appear on leaderboards.',
      errors: handle.errors,
      focusNode: handle.focusNode,
      child: DsInput(controller: handle.controller, placeholder: 'ayoub'),
    ),
    DsField(
      label: 'Email',
      description: 'Receipts and nothing else.',
      errors: email.errors,
      focusNode: email.focusNode,
      child: DsInput(
        controller: email.controller,
        placeholder: 'you@example.com',
        keyboardType: TextInputType.emailAddress,
      ),
    ),
  ],
)''';

const String _usageHorizontalCode = '''DsField(
  label: 'Email me about product updates',
  orientation: DsFieldOrientation.horizontal,
  child: DsCheckbox(
    state: subscribed ? DsCheckboxState.checked : DsCheckboxState.unchecked,
    onChanged: (DsCheckboxState next) {
      setState(() => subscribed = next == DsCheckboxState.checked);
    },
  ),
)''';

/// The Composition section's own map of the shape below: not real code
/// (no return type, no semicolons), a tree of which part nests inside which.
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

const String _inputCode = '''DsFieldGroup(
  children: <Widget>[
    DsField(
      label: 'Username',
      description: 'This is your public display name.',
      child: DsInput(placeholder: 'ayoub'),
    ),
    DsField(
      label: 'Password',
      description: 'Must be at least 8 characters.',
      child: DsInput(obscureText: true),
    ),
  ],
)''';

const String _textareaCode = '''DsField(
  label: 'Feedback',
  description: 'We read every word: keep it under 500 characters.',
  child: DsTextarea(
    placeholder: 'Tell us what is working and what is not.',
  ),
)''';

const String _selectCode = '''DsField(
  label: 'Department',
  description: 'Routes your ticket to the right team.',
  child: DsNativeSelect<String>(
    value: department,
    onChanged: (String next) => setState(() => department = next),
    options: const <DsSelectChild<String>>[
      DsSelectOption(value: 'support', label: 'Support'),
      DsSelectOption(value: 'billing', label: 'Billing'),
      DsSelectOption(value: 'sales', label: 'Sales'),
    ],
  ),
)''';

const String _sliderCode = '''DsField(
  label: 'Price range',
  description: 'Drag either handle to set your budget.',
  child: DsSlider(
    values: priceRange,
    onChanged: (List<double> next) => setState(() => priceRange = next),
    min: 0,
    max: 500,
  ),
)''';

const String _switchCode = '''DsField(
  label: 'Two-factor authentication',
  description: 'Require a code from your authenticator app at sign-in.',
  orientation: DsFieldOrientation.horizontal,
  child: DsSwitch(
    value: mfaEnabled,
    onChanged: (bool next) => setState(() => mfaEnabled = next),
  ),
)''';

const String _validationCode =
    '''// invalid defaults to errors.isNotEmpty, but the two are separable.
DsField(
  label: 'Email',
  errors: const <String>['Enter a valid email address.'],
  child: const DsInput(),
)

// invalid: true colours the label and control red with no message: the
// aria-invalid-only shape the reference's own inputs page uses.
DsField(
  label: 'Email',
  invalid: true,
  child: const DsInput(),
)''';

/// Quoted from `example/lib/pages/forms.dart`'s `#profile-panel` composition
/// (the `DsFieldGroup` around the Handle and Email fields), trimmed to the
/// two fields: the surrounding `ListenableBuilder` and submit button are
/// that page's own form-state plumbing, not part of what `DsField` needs to
/// be shown correctly here.
const String _compositionGroupCode = '''DsFieldGroup(
  children: <Widget>[
    DsField(
      label: 'Handle',
      description: 'This is how you appear on leaderboards.',
      errors: handle.errors,
      focusNode: handle.focusNode,
      child: DsInput(
        controller: handle.controller,
        placeholder: 'ayoub',
        autofillHints: const <String>[AutofillHints.username],
      ),
    ),
    DsField(
      label: 'Email',
      description: 'Receipts and nothing else.',
      errors: email.errors,
      focusNode: email.focusNode,
      child: DsInput(
        controller: email.controller,
        placeholder: 'you@example.com',
        keyboardType: TextInputType.emailAddress,
        autofillHints: const <String>[AutofillHints.email],
      ),
    ),
  ],
)''';

/// Quoted from `example/lib/pages/forms.dart`'s `_PayoutFieldSet`: the
/// shape a group of radios actually needs: a `DsFieldLegend` outside the
/// `DsFieldSet` (a rendered `<legend>` is lifted out of a fieldset's flex
/// content box on the reference, so the set's own gap never reaches it),
/// `tightForGroup: true` because a `DsRadioGroup` is the set's direct child,
/// and one horizontal `DsField` per option so each radio keeps its own
/// selectable label.
const String _compositionSetCode = '''Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  mainAxisSize: MainAxisSize.min,
  children: <Widget>[
    const DsFieldLegend('Payout rhythm'),
    SizedBox(height: DsFieldLegend.spaceBelow),
    DsFieldSet(
      tightForGroup: true,
      children: <Widget>[
        DsRadioGroup<String>(
          value: field.value,
          onChanged: (String next) => field.value = next,
          gap: DsFieldSet.groupGap,
          invalid: field.invalid,
          focusNode: field.focusNode,
          label: 'Payout rhythm',
          hint: field.errors.isEmpty ? null : field.errors.join(' '),
          children: const <Widget>[
            DsField(
              label: 'Daily',
              orientation: DsFieldOrientation.horizontal,
              child: DsRadioGroupItem<String>(value: 'daily'),
            ),
            DsField(
              label: 'Weekly',
              orientation: DsFieldOrientation.horizontal,
              child: DsRadioGroupItem<String>(value: 'weekly'),
            ),
          ],
        ),
        if (field.errors.isNotEmpty) DsFieldError(field.errors),
      ],
    ),
  ],
)''';

/// The live preview grid: a toggleable-error vertical field, an
/// activatable-by-label horizontal field, a disabled field, and the
/// separable invalid-vs-errors pairing the Accessibility section documents.
class _FieldPreview extends StatefulWidget {
  const _FieldPreview();

  @override
  State<_FieldPreview> createState() => _FieldPreviewState();
}

class _FieldPreviewState extends State<_FieldPreview> {
  bool _emailInvalid = false;
  DsCheckboxState _subscribed = DsCheckboxState.unchecked;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        DsText('Vertical, with a live error', DsType.label),
        SizedBox(height: ds(3)),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: DsContainers.sm),
          child: DsField(
            // Scopes the docs test's "no DsFieldError at rest" assertion to
            // this one toggleable specimen: the static "Separable" pairing
            // further down deliberately keeps a DsFieldError mounted at all
            // times, so a page-wide byType(DsFieldError) search cannot tell
            // the two apart.
            key: const ValueKey<String>('field-doc-toggle-field'),
            label: 'Email',
            description: "We'll only use this for receipts.",
            errors: _emailInvalid
                ? const <String>['Enter a valid email address.']
                : const <String>[],
            child: const DsInput(
              key: ValueKey<String>('field-doc-specimen-email'),
              placeholder: 'you@example.com',
            ),
          ),
        ),
        SizedBox(height: ds(3)),
        DsButton(
          key: const ValueKey<String>('field-doc-toggle-error'),
          variant: DsButtonVariant.outline,
          size: DsButtonSize.sm,
          label: _emailInvalid ? 'Clear the error' : 'Show an error',
          onPressed: () => setState(() => _emailInvalid = !_emailInvalid),
          child: DsText(
            _emailInvalid ? 'Clear the error' : 'Show an error',
            DsComponentType.buttonLabel,
          ),
        ),
        SizedBox(height: ds(7)),
        DsText(
          'Horizontal, around a checkbox: tap the box or the words',
          DsType.label,
        ),
        SizedBox(height: ds(3)),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: DsContainers.sm),
          child: DsField(
            label: 'Email me about product updates',
            orientation: DsFieldOrientation.horizontal,
            child: DsCheckbox(
              key: const ValueKey<String>('field-doc-specimen-checkbox'),
              state: _subscribed,
              onChanged: (DsCheckboxState next) =>
                  setState(() => _subscribed = next),
            ),
          ),
        ),
        SizedBox(height: ds(7)),
        DsText('Disabled: the field wins over the control', DsType.label),
        SizedBox(height: ds(3)),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: DsContainers.sm),
          // The control's own `enabled: true` is deliberately left in
          // place: DsField.enabled: false still wins, because a control
          // ANDs the two rather than reading only its own: see the API
          // and States sections.
          child: DsField(
            label: 'Handle',
            description: 'Set by your workspace admin.',
            enabled: false,
            child: DsInput(initialValue: 'ayoub', enabled: true),
          ),
        ),
        SizedBox(height: ds(7)),
        DsText(
          'Separable: invalid and errors are two different switches',
          DsType.label,
        ),
        SizedBox(height: ds(3)),
        Wrap(
          spacing: ds(5),
          runSpacing: ds(5),
          children: <Widget>[
            SizedBox(
              width: ds(64),
              child: DsField(
                label: 'errors: [...]',
                errors: const <String>['This field is required.'],
                child: const DsInput(),
              ),
            ),
            SizedBox(
              width: ds(64),
              child: const DsField(
                label: 'invalid: true, no errors',
                invalid: true,
                child: DsInput(),
              ),
            ),
          ],
        ),
        SizedBox(height: ds(2)),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: DsWidths.prose),
          child: DsText(
            'Both colour the label and control red, because both set '
            'DsFieldScope.invalid. Only the left one mounts a DsFieldError '
            'live region, because that is driven by errors alone, not by '
            'invalid.',
            DsType.small,
            color: theme.mutedForeground,
          ),
        ),
      ],
    );
  }
}
