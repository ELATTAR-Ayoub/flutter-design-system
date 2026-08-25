/// Public component documentation for the field component.
///
/// Reshaped to shadcn parity (worker brief, 2026-08-23) against
/// `https://ui.shadcn.com/docs/components/base/field`: the same section
/// order that page uses, ending in the six sections every page in this
/// docs site adds on top: States, Accessibility, Responsive, Dependencies,
/// Theming, Source. `overview` and the standalone `status` heading are
/// gone (shadcn's own page has neither; the status facts now live inside
/// Installation, and the page lead is just the short, one-sentence
/// description). `variants` is gone too: [ElFieldOrientation] is now the
/// tenth table inside API Reference, next to shadcn's own choice of folding
/// every prop, including enums, into one API section rather than a separate
/// one.
///
/// `field` is Wave 2 of the component-documentation plan (form and input
/// family) and: like `tooltip` in Wave 1: already carries a real
/// `registry/components/field.json` manifest, so Installation below renders
/// the genuine `elattar add field` command and shipped registry dependencies.
/// disclosure.
///
/// Unlike every sibling documented so far, `field` is not one widget but a
/// family of nine classes plus one enum: [ElField] itself, the threading
/// primitives [ElFieldScope] and [ElFieldActivator], the layout orientation
/// enum [ElFieldOrientation], the stacking helpers [ElFieldGroup] and
/// [ElFieldSet] with its [ElFieldLegend], and the three parts a hand-built
/// composition reaches for directly, [ElFieldLabel], [ElFieldDescription],
/// and [ElFieldError]. API Reference gives each of the nine classes plus
/// the one enum its own [DocsApiTable] rather than merging them into one,
/// because the classes are genuinely different shapes doing different
/// jobs, not overloads of one constructor.
///
/// shadcn's own per-control sections (Input, Textarea, Select, Slider,
/// Fieldset, Checkbox, Radio, Switch, Choice Card, Field Group) are mirrored
/// where [ElField] genuinely wraps that control: [ElInput], [ElTextarea],
/// [ElNativeSelect], [ElSlider], [ElFieldSet], [ElCheckbox], and [ElSwitch]
/// all read the ambient [ElFieldScope] the same way, so each gets its own
/// section. Radio has no section of its own: the only real
/// radio-inside-a-field composition this page has is the Fieldset demo
/// (a lone [ElField]-wrapped [ElRadioGroupItem] outside a [ElFieldSet]
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
        description: entry.description,
      ),
      breadcrumbs: const <ElBreadcrumbEntry>[
        ElBreadcrumbEntry.link('Components'),
        ElBreadcrumbEntry.page('Field'),
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
    final ElThemeData theme = ElTheme.of(context);
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
        ElSection(
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
                      'and rule automatically.',
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
              SizedBox(height: el(5)),
              const DocsInstallFacts(
                title: 'Status',
                facts: <DocsInstallFact>[
                  DocsInstallFact(
                    label: 'Status',
                    value: 'Stable: registered in the registry',
                    description:
                        'ElField and the rest of the field family are '
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
        ElSection(
          id: 'usage',
          title: 'Usage',
          description:
              'The smallest correct composition, then a stacked group, '
              'then a horizontal field wrapping a checkbox: the three '
              'shapes ElFieldGroup and ElFieldOrientation exist for.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ElPanel(
                label: 'DART',
                note: 'SMALLEST CORRECT EXAMPLE',
                child: DocsSelectableCodeBlock(code: _usageBasicCode),
              ),
              SizedBox(height: el(5)),
              ElPanel(
                label: 'DART',
                note: 'STACKED WITH ElFieldGroup',
                child: DocsSelectableCodeBlock(code: _usageGroupCode),
              ),
              SizedBox(height: el(5)),
              ElPanel(
                label: 'DART',
                note: 'HORIZONTAL, AROUND A CHECKBOX',
                child: DocsSelectableCodeBlock(code: _usageHorizontalCode),
              ),
            ],
          ),
        ),
        ElSection(
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
              ElPanel(
                label: 'TREE',
                note: 'ElFieldGroup, INDEPENDENT FIELDS',
                child: DocsSelectableCodeBlock(code: _compositionGroupTree),
              ),
              SizedBox(height: el(5)),
              ElPanel(
                label: 'TREE',
                note: 'ElFieldSet, ONE LEGEND OVER SEVERAL FIELDS',
                child: DocsSelectableCodeBlock(code: _compositionSetTree),
              ),
            ],
          ),
        ),
        ElSection(
          id: 'anatomy',
          title: 'Anatomy',
          description:
              'The one fixed order every ElField renders, and never '
              'varies.',
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: ElWidths.prose),
            child: ElText(
              'FieldLabel, then the control, then FieldDescription, then '
              'FieldError: that order is fixed inside ElField itself, not '
              'a convention a call site has to follow. ElField.gap (8px) '
              'sits between each of those; ElField.describedGap (4px) is '
              'the tighter gap the description keeps once an error joins '
              'it below. ElFieldOrientation.horizontal reorders the first '
              'two, control then label, for a checkbox, switch, or radio '
              'row: see API for both values. A hand-built row that skips '
              'ElField itself, each ElRadioGroupItem\'s own horizontal '
              'ElField in Fieldset below, still carries the same four '
              'ideas through a bare ElFieldScope: label, describedBy, '
              'invalid, enabled.',
              ElType.body,
            ),
          ),
        ),
        ElSection(
          id: 'form',
          title: 'Form',
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: ElWidths.prose),
            child: ElText(
              'ElField wraps one control; Form covers wiring several of '
              'them into a submit flow. The Field group and Fieldset '
              'shapes below are quoted verbatim from '
              'example/lib/pages/forms.dart, the same file Form\'s own '
              'specimens build on: see Form for the validation timing and '
              'submit handling around them.',
              ElType.body,
            ),
          ),
        ),
        ElSection(
          id: 'input',
          title: 'Input',
          description:
              'ElInput already carries its own optional label and hint '
              'for standalone use; leave both null so ElField supplies the '
              'visible label and description instead.',
          child: ElPanel(
            label: 'DART',
            note: 'USERNAME AND PASSWORD',
            child: DocsSelectableCodeBlock(code: _inputCode),
          ),
        ),
        ElSection(
          id: 'textarea',
          title: 'Textarea',
          description:
              'The same ElFieldScope wiring ElInput reads: ElTextarea '
              'ORs its own invalid with the field\'s and focuses the '
              'scope\'s focusNode when it registers none of its own.',
          child: ElPanel(
            label: 'DART',
            note: 'FEEDBACK, WITH A CHARACTER-LIMIT HINT',
            child: DocsSelectableCodeBlock(code: _textareaCode),
          ),
        ),
        ElSection(
          id: 'select',
          title: 'Select',
          description:
              'ElNativeSelect reads ElFieldScope the same way: the closed '
              'control is what the field labels, the reference\'s own '
              'operating-system picker is off-canvas either way.',
          child: ElPanel(
            label: 'DART',
            note: 'DEPARTMENT',
            child: DocsSelectableCodeBlock(code: _selectCode),
          ),
        ),
        ElSection(
          id: 'slider',
          title: 'Slider',
          description:
              'ElField still lays out the label, description and error '
              'around ElSlider, but ElSlider itself reads no ElFieldScope: '
              'it has no invalid ring and no scope-supplied focusNode, so '
              'its own label prop is the one accessible name a caller has '
              'to set directly.',
          child: ElPanel(
            label: 'DART',
            note: 'PRICE RANGE',
            child: DocsSelectableCodeBlock(code: _sliderCode),
          ),
        ),
        ElSection(
          id: 'fieldset',
          title: 'Fieldset',
          description:
              'Quoted from example/lib/pages/forms.dart\'s '
              '_PayoutFieldSet: a ElFieldLegend outside the ElFieldSet '
              '(a rendered legend sits above the set rather than inside '
              'its flex flow), tightForGroup: true because a ElRadioGroup '
              'is the set\'s direct child, and one horizontal ElField per '
              'option so each radio keeps its own selectable label.',
          child: ElPanel(
            label: 'DART',
            note: 'FROM forms.dart, PAYOUT RHYTHM FIELDSET',
            child: DocsSelectableCodeBlock(code: _compositionSetCode),
          ),
        ),
        ElSection(
          id: 'checkbox',
          title: 'Checkbox',
          description:
              'ElFieldOrientation.horizontal puts the checkbox before its '
              'label; the live version above in Preview is this exact '
              'composition, tap either the box or the words.',
          child: ElPanel(
            label: 'DART',
            note: 'HORIZONTAL, AROUND A CHECKBOX',
            child: DocsSelectableCodeBlock(code: _usageHorizontalCode),
          ),
        ),
        ElSection(
          id: 'switch',
          title: 'Switch',
          description:
              'The same horizontal shape as Checkbox above, around '
              'ElSwitch instead.',
          child: ElPanel(
            label: 'DART',
            note: 'TWO-FACTOR AUTHENTICATION',
            child: DocsSelectableCodeBlock(code: _switchCode),
          ),
        ),
        ElSection(
          id: 'field-group',
          title: 'Field group',
          description:
              'Quoted from example/lib/pages/forms.dart\'s '
              '#profile-panel composition, the ElFieldGroup around the '
              'Handle and Email fields, trimmed to the two fields: the '
              'surrounding ListenableBuilder and submit button are that '
              'page\'s own form-state plumbing, not part of what ElField '
              'needs to be shown correctly here.',
          child: ElPanel(
            label: 'DART',
            note: 'FROM forms.dart, HANDLE + EMAIL',
            child: DocsSelectableCodeBlock(code: _compositionGroupCode),
          ),
        ),
        ElSection(
          id: 'validation-errors',
          title: 'Validation and errors',
          description:
              'invalid defaults to errors.isNotEmpty but the two are '
              'separable switches: the live "Separable" specimen in '
              'Preview above is exactly this pairing.',
          child: ElPanel(
            label: 'DART',
            note: 'INVALID AND ERRORS, SET APART',
            child: DocsSelectableCodeBlock(code: _validationCode),
          ),
        ),
        ElSection(
          id: 'api',
          title: 'API Reference',
          description:
              'Every public class, constructor parameter, and static '
              'member the source declares: ten tables, nine classes plus '
              'the one enum, ElFieldOrientation, folded in here rather '
              'than a separate Variants heading.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const DocsApiTable(
                title: 'ElField',
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
                        'through ElFieldScope, one string, one '
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
                        "through ElFieldScope, ANDed with the control's "
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
                    type: 'ElFieldOrientation',
                    description:
                        'Defaults to vertical. See the ElFieldOrientation '
                        'table below for both values.',
                  ),
                  DocsApiFact(
                    name: 'ElField.gap',
                    type: 'static double (get)',
                    description:
                        '8px: between label, control, and what follows.',
                  ),
                  DocsApiFact(
                    name: 'ElField.describedGap',
                    type: 'static double (get)',
                    description:
                        '4px: the gap the description tucks to the '
                        'moment an error appears below it (gap − 4px).',
                  ),
                ],
              ),
              SizedBox(height: el(5)),
              const DocsApiTable(
                title: 'ElFieldScope',
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
                        'The node a tapped ElFieldLabel focuses when no '
                        'activator is registered.',
                  ),
                  DocsApiFact(
                    name: 'activator',
                    type: 'ElFieldActivator?',
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
                    name: 'ElFieldScope.maybeOf',
                    type: 'static ElFieldScope? Function(BuildContext)',
                    description:
                        'The InheritedWidget lookup a control reads to opt '
                        'into everything above.',
                  ),
                ],
              ),
              SizedBox(height: el(5)),
              const DocsApiTable(
                title: 'ElFieldActivator',
                facts: <DocsApiFact>[
                  DocsApiFact(
                    name: 'callback',
                    type: 'VoidCallback?',
                    description:
                        'Mutable, not constructor-injected: a one-slot '
                        'holder. A control assigns what its own '
                        'activation does during its own build; '
                        'ElFieldLabel reads it at tap time. Every '
                        'instance starts with callback: null.',
                  ),
                ],
              ),
              SizedBox(height: el(5)),
              const DocsApiTable(
                title: 'ElFieldGroup',
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
                    name: 'ElFieldGroup.gap',
                    type: 'static double (get)',
                    description: '20px: the default gap between fields.',
                  ),
                  DocsApiFact(
                    name: 'ElFieldGroup.nestedGap',
                    type: 'static double (get)',
                    description: '16px: the nested: true gap.',
                  ),
                ],
              ),
              SizedBox(height: el(5)),
              const DocsApiTable(
                title: 'ElFieldSet',
                facts: <DocsApiFact>[
                  DocsApiFact(
                    name: 'children',
                    type: 'List<Widget>',
                    description:
                        'Required. Everything inside the set: typically '
                        'a selection group, then an optional ElFieldError.',
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
                    name: 'ElFieldSet.gap',
                    type: 'static double (get)',
                    description: '16px: the default gap.',
                  ),
                  DocsApiFact(
                    name: 'ElFieldSet.groupGap',
                    type: 'static double (get)',
                    description: '12px: the tightForGroup: true gap.',
                  ),
                ],
              ),
              SizedBox(height: el(5)),
              const DocsApiTable(
                title: 'ElFieldLegend',
                facts: <DocsApiFact>[
                  DocsApiFact(
                    name: 'text',
                    type: 'String',
                    description:
                        'Required, positional. The heading over a '
                        'ElFieldSet.',
                  ),
                  DocsApiFact(
                    name: 'ElFieldLegend.spaceBelow',
                    type: 'static double (get)',
                    description:
                        '6px, on top of: not instead of: the enclosing '
                        "set's own gap, because a rendered legend sits "
                        'above the set rather than inside its flex flow. '
                        'See Fieldset below.',
                  ),
                ],
              ),
              SizedBox(height: el(5)),
              const DocsApiTable(
                title: 'ElFieldLabel',
                facts: <DocsApiFact>[
                  DocsApiFact(
                    name: 'text',
                    type: 'String',
                    description: 'Required, positional.',
                  ),
                  DocsApiFact(
                    name: 'spec',
                    type: 'ElTypeSpec?',
                    description:
                        'Overrides ElComponentType.fieldLabel. '
                        'ElFieldLabel.normal is the one built-in override '
                        '— see statics.',
                  ),
                  DocsApiFact(
                    name: 'focusNode',
                    type: 'FocusNode?',
                    description:
                        'Focused on tap when no activator is registered. '
                        'Falls back to the enclosing ElFieldScope.',
                  ),
                  DocsApiFact(
                    name: 'activator',
                    type: 'ElFieldActivator?',
                    description:
                        'Where the control registered what activating '
                        'this field does. Falls back to the enclosing '
                        'ElFieldScope.',
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
                    name: 'ElFieldLabel.normal',
                    type: 'static ElTypeSpec (get)',
                    description:
                        'fieldLabel\'s size and leading with textSm\'s '
                        '400 weight substituted in: the filter-row '
                        '"font-normal" override.',
                  ),
                  DocsApiFact(
                    name: 'ElFieldLabel.disabledOpacity',
                    type: 'static const double',
                    description: '0.50.',
                  ),
                ],
              ),
              SizedBox(height: el(5)),
              const DocsApiTable(
                title: 'ElFieldDescription',
                facts: <DocsApiFact>[
                  DocsApiFact(
                    name: 'text',
                    type: 'String',
                    description: 'Required, positional.',
                  ),
                ],
              ),
              SizedBox(height: el(5)),
              const DocsApiTable(
                title: 'ElFieldError',
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
                    name: 'ElFieldError.listIndent',
                    type: 'static double (get)',
                    description: '16px: where the bullet list starts.',
                  ),
                  DocsApiFact(
                    name: 'ElFieldError.itemGap',
                    type: 'static double (get)',
                    description: '4px: between list items.',
                  ),
                ],
              ),
              SizedBox(height: el(5)),
              const DocsApiTable(
                title: 'ElFieldOrientation',
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
                        'for ElCheckbox, ElSwitch, and each '
                        'ElRadioGroupItem.',
                  ),
                ],
              ),
            ],
          ),
        ),
        ElSection(
          id: 'states',
          title: 'States and feedback',
          description:
              'ElField itself owns rest, error, disabled, and the empty '
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
                        'no destructive tint; no ElFieldError widget '
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
                        'mounts a ElFieldError node wrapped in '
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
                        'ElFieldError.build returns const SizedBox.shrink() '
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
                        'enabled: false publishes ElFieldScope.enabled: '
                        'false; a wrapped control reads '
                        'widget.enabled && (scope?.enabled ?? true), so '
                        'the field\'s false always wins even if the '
                        "control's own enabled is left true.",
                    userSignal:
                        "Whatever the control's own disabled look is "
                        '(ElInput and ElCheckbox both dim). ElFieldLabel '
                        'itself drops to 50% opacity and its tap handler '
                        'is removed.',
                  ),
                  DocsStateFact(
                    state:
                        'Hover / Pressed / Focus-visible / Selected / '
                        'Loading / Success',
                    treatment:
                        'N/A, ElField paints none of these itself. A '
                        'focus ring, a hover skin, a pressed squash, a '
                        'selected fill, a spinner, and a success tint all '
                        'belong to the wrapped control (ElInput, '
                        'ElCheckbox, ElSwitch…), each documented on its '
                        'own component page.',
                    userSignal:
                        'What the control renders is what shows, ElField '
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
        ElSection(
          id: 'accessibility',
          title: 'Accessibility and keyboard behavior',
          description:
              'The part this component exists for: turning a label, a '
              'control, a description, and an error into one thing a '
              'screen reader hears as one thing.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ElPanel(
                label: 'What the semantics tree actually carries',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const _A11yRow(
                      'Semantic role',
                      'ElField wraps its whole subtree in '
                          'Semantics(container: true, validationResult:), '
                          'the nearest Flutter analogue to role="group" '
                          'plus aria-invalid. This is set unconditionally '
                          'on the field itself: it does not depend on the '
                          'wrapped control opting in.',
                    ),
                    const _A11yRow(
                      'Label wiring',
                      'label is threaded through ElFieldScope so the '
                          "control reads it as its own accessible name "
                          '(widget.label ?? scope?.label). The visible '
                          'ElFieldLabel wraps its text in ExcludeSemantics '
                          "so the same words are not announced twice, "
                          'once as the label, once as the name.',
                    ),
                    const _A11yRow(
                      'Description wiring',
                      "description feeds Semantics.hint on the control "
                          '(the aria-describedby analogue) by joining with '
                          'errors, description first, into one string. '
                          'ElField renders the visible ElFieldDescription '
                          'too, but wraps that copy in ExcludeSemantics, '
                          "the string is already the control's hint, so "
                          'this is the one avoided double-announcement, '
                          'not a second one.',
                    ),
                    const _A11yRow(
                      'Error wiring and live region: is it announced?',
                      'Yes. ElFieldError wraps its message(s) in '
                          'Semantics(container: true, liveRegion: true), '
                          'the role="alert" translation. Because '
                          'ElFieldError.build returns null-equivalent '
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
                      'Tapping the visible ElFieldLabel resolves in order: '
                          "the caller's own onTap if supplied; otherwise "
                          "the registered ElFieldActivator's callback if a "
                          'control registered one (this activates the '
                          'control, ElCheckbox and ElSwitch both do); '
                          'otherwise the ElFieldScope.focusNode if one was '
                          'offered (this focuses the control: what a '
                          'text field\'s own activation is); otherwise no '
                          'gesture recogniser is attached at all, on '
                          'purpose, so an ancestor composing its own row '
                          'is never fought for the tap.',
                    ),
                    const _A11yRow(
                      'Focus behavior',
                      'ElField itself never takes focus. focusNode names '
                          'the node a tapped label focuses, or the node a '
                          'failed submit should land on: the actual ring '
                          'and outline are the wrapped control\'s own.',
                    ),
                    const _A11yRow(
                      'Touch target',
                      "ElFieldLabel's own tap target is intentionally "
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
                          'reinforcement, not the only cue, ElField never '
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
                          'ElField.invalid reproduces that separable '
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
        ElSection(
          id: 'responsive',
          title: 'Responsive and platform behavior',
          child: _bullets(theme, <String>[
            'No responsive breakpoints of its own, ElField reads no '
                'MediaQuery and renders the same Column or Row at 390px '
                'and 1440px. *:w-full is real here: CrossAxisAlignment.'
                'stretch forces every direct child (label, control, '
                'description, error) to the field\'s own width, so a '
                'ElInput inside a ElField always fills the field\'s '
                'measure rather than sizing to its content.',
            'ElFieldGroup and ElFieldSet are Columns with '
                'mainAxisSize: MainAxisSize.min: they take exactly the '
                'height their children need and never impose a width; '
                'the surrounding layout (a ElCard, a form panel measure) '
                'decides how wide a stack of fields gets.',
            'Keyboard activation (the label tap ladder above) and pointer '
                'activation behave identically on every Flutter target '
                'this package supports: there is no platform channel and '
                'nothing in field.dart branches on platform.',
          ]),
        ),
        ElSection(
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
                    'The manifest names source-foundation and rule, '
                    'nothing here is package-mode-only.',
              ),
              DocsInstallFact(
                label: 'Dependencies',
                value: entry.dependencies.join(', '),
                description:
                    "The manifest's registryDependencies, resolved "
                    'automatically by the registry client. rule '
                    'supplies ElRules.dedupe, used to deduplicate errors '
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
                    'The bullet marker in a multi-message ElFieldError is '
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
                    "test/inputs_test.dart's 'ElField' and 'ElFieldSet' "
                    "groups, plus this page's own live specimens. No "
                    'fixture install was run as part of writing this '
                    'page.',
              ),
            ],
          ),
        ),
        ElSection(
          id: 'theming',
          title: 'Theming notes',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ElPanel(
                label: 'What actually varies with the theme',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ElText(
                      'ElField reads exactly one theme colour directly: '
                      'theme.destructiveInk, merged over the subtree via '
                      'DefaultTextStyle when invalid. Everything else, '
                      'the label\'s own ink, the description\'s '
                      'theme.mutedForeground, the control\'s own fill and '
                      'border: belongs to ElText\'s type specs or to the '
                      'wrapped control, not to field.dart itself.',
                      ElType.small,
                    ),
                    SizedBox(height: el(3)),
                    ElText(
                      'The label, description, and error each carry their '
                      'own fixed type spec, ElComponentType.fieldLabel, '
                      'ElType.small, and ElComponentType.textSm '
                      'respectively: none configurable per instance '
                      'except ElFieldLabel.spec, which ElField itself '
                      'never overrides (it always renders the plain '
                      'fieldLabel spec).',
                      ElType.small,
                    ),
                    SizedBox(height: el(3)),
                    ElText(
                      'No radius, shadow, or surface token appears in '
                      'field.dart: it lays text and gaps out and lets '
                      'the wrapped control paint every surface.',
                      ElType.small,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        ElSection(
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
                value: "test/inputs_test.dart ('ElField', 'ElFieldSet')",
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
          ElText(label, ElType.section, color: theme.actionInk),
          SizedBox(height: el(1)),
          ElText(body, ElType.small),
        ],
      ),
    );
  }
}

const String _usageBasicCode =
    '''import 'package:elattar_design_system/elattar_design_system.dart';

ElField(
  label: 'Display name',
  description: 'Shown publicly on your profile.',
  child: ElInput(placeholder: 'Astra Vale'),
)''';

const String _usageGroupCode = '''ElFieldGroup(
  children: <Widget>[
    ElField(
      label: 'Handle',
      description: 'This is how you appear on leaderboards.',
      errors: handle.errors,
      focusNode: handle.focusNode,
      child: ElInput(controller: handle.controller, placeholder: 'ayoub'),
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
      ),
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

const String _textareaCode = '''ElField(
  label: 'Feedback',
  description: 'We read every word: keep it under 500 characters.',
  child: ElTextarea(
    placeholder: 'Tell us what is working and what is not.',
  ),
)''';

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

const String _switchCode = '''ElField(
  label: 'Two-factor authentication',
  description: 'Require a code from your authenticator app at sign-in.',
  orientation: ElFieldOrientation.horizontal,
  child: ElSwitch(
    value: mfaEnabled,
    onChanged: (bool next) => setState(() => mfaEnabled = next),
  ),
)''';

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

/// Quoted from `example/lib/pages/forms.dart`'s `#profile-panel` composition
/// (the `ElFieldGroup` around the Handle and Email fields), trimmed to the
/// two fields: the surrounding `ListenableBuilder` and submit button are
/// that page's own form-state plumbing, not part of what `ElField` needs to
/// be shown correctly here.
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

/// Quoted from `example/lib/pages/forms.dart`'s `_PayoutFieldSet`: the
/// shape a group of radios actually needs: a `ElFieldLegend` outside the
/// `ElFieldSet` (a rendered `<legend>` is lifted out of a fieldset's flex
/// content box on the reference, so the set's own gap never reaches it),
/// `tightForGroup: true` because a `ElRadioGroup` is the set's direct child,
/// and one horizontal `ElField` per option so each radio keeps its own
/// selectable label.
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
  ElCheckboxState _subscribed = ElCheckboxState.unchecked;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        Wrap(
          spacing: el(5),
          runSpacing: el(5),
          children: <Widget>[
            SizedBox(
              width: el(64),
              child: ElField(
                label: 'errors: [...]',
                errors: const <String>['This field is required.'],
                child: const ElInput(),
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
        ),
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
