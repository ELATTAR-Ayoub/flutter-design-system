/// Public component documentation for three form components: native_select,
/// selection_control, and form.
///
/// **native_select** documents [DsNativeSelect] and [DsNativeSelectSize].
/// **selection_control** documents [DsSelectionControl], [DsHitArea], and
/// [DsJellyReplay]. **form** documents [DsForm], [DsFormField],
/// [DsTextFormField], [DsFormFieldBase], and [DsValidateMode].
///
/// The three are separate concepts but closely related: the form manages
/// validation and submission; selection_control is the invisible socket
/// DsCheckbox, DsRadioGroup, and DsSwitch wear; and native_select is the
/// OS picker with a port-built list.
///
/// Section shape mirrors `https://ui.shadcn.com/docs/components/base/native-select`
/// for native_select, section for section: a live demo ahead of any heading,
/// then Installation, Usage, Composition, Groups, Disabled, Invalid, Native
/// select vs select, RTL, and API Reference, in that order.
/// `https://ui.shadcn.com/docs/components/form` has no counterpart content of
/// its own to mirror: it is a "pick your framework" gateway page (React Hook
/// Form, TanStack Form, Formisch) with no props, no API, and no component
/// sections at all, so DsForm's content stays where it already grouped
/// naturally, inside Installation, Usage, API Reference, and the six
/// trailing sections. selection_control has no shadcn counterpart page of
/// any kind: it is an invented internal primitive, so its content is "ours
/// only" throughout, grouped under its own name the same way. States,
/// Accessibility, Responsive, Dependencies, Theming, and Source are this
/// package's own six sections, added after API Reference, named exactly
/// that with no extra words.
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
        description: nativeSelectExpandedDescription,
      ),
      breadcrumbs: const <DsBreadcrumbEntry>[
        DsBreadcrumbEntry.link('Components'),
        DsBreadcrumbEntry.page('Native Select / Selection Control / Form'),
      ],
      sidebar: const <DocsSidebarEntry>[
        DocsSidebarEntry(
          title: 'Button group',
          route: '/components/button_group',
        ),
        DocsSidebarEntry(title: 'Combobox', route: '/components/combobox'),
        DocsSidebarEntry(title: 'Field', route: '/components/field'),
        DocsSidebarEntry(title: 'Form', route: '/components/form'),
        DocsSidebarEntry(
          title: 'Input group',
          route: '/components/input_group',
        ),
        DocsSidebarEntry(title: 'Input OTP', route: '/components/input_otp'),
        DocsSidebarEntry(
          title: 'Native select',
          route: '/components/native_select',
          selected: true,
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
        DocsTocEntry(title: 'Groups', anchor: 'groups'),
        DocsTocEntry(title: 'Disabled', anchor: 'disabled'),
        DocsTocEntry(title: 'Invalid', anchor: 'invalid'),
        DocsTocEntry(
          title: 'Native select vs select',
          anchor: 'native-select-vs-select',
        ),
        DocsTocEntry(title: 'RTL', anchor: 'rtl'),
        DocsTocEntry(title: 'API Reference', anchor: 'api'),
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
    final DsThemeData theme = DsTheme.of(context);
    return Column(
      key: const ValueKey<String>('native-select-doc-article'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        // The live demo, ahead of any heading: the same shape the reference
        // page itself opens with. No DsSection wraps it, so it carries no
        // Overview/Status/Preview heading of its own before Installation.
        DocsCodeExample(
          title: 'Live specimens',
          description:
              'A live DsNativeSelect with options, and DsSelectionControl in '
              'rest and focused states (focus-visible is painted here, not '
              'simulated). DsForm has no paint of its own: see Usage below '
              'for how it is bound.',
          preview: const _NativeSelectPreview(),
          command: DocsCodeCommand(command: entry.command),
        ),
        SizedBox(height: ds(8)),
        DsSection(
          id: 'install',
          title: 'Installation',
          description: 'All three are exported but not yet in the registry.',
          child: DocsCodeExample(
            title: 'Import from the barrel',
            command: DocsCodeCommand(
              command: entry.command,
              description:
                  'Import DsNativeSelect, DsSelectionControl, and DsForm from '
                  'the public barrel: no CLI command yet.',
            ),
            manualFiles: const <DocsCodeFile>[
              DocsCodeFile(
                path: 'lib/form.dart',
                code:
                    "import 'package:elattar_design_system/"
                    "elattar_design_system.dart';\n\n"
                    '// Use directly: no elattar add command yet.',
              ),
            ],
          ),
        ),
        DsSection(
          id: 'usage',
          title: 'Usage',
          description:
              'DsNativeSelect with options, DsSelectionControl standalone, '
              'and DsForm with a field and validation.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              DsPanel(
                label: 'DART',
                note: 'DsNativeSelect WITH OPTIONS',
                child: DocsSelectableCodeBlock(code: _usageNativeSelectCode),
              ),
              SizedBox(height: ds(5)),
              DsPanel(
                label: 'DART',
                note: 'DsSelectionControl, THE SHARED SOCKET',
                child: DocsSelectableCodeBlock(
                  code: _usageSelectionControlCode,
                ),
              ),
              SizedBox(height: ds(5)),
              DsPanel(
                label: 'DART',
                note: 'DsForm, NON-VISUAL STATE CONTAINER',
                child: DocsSelectableCodeBlock(code: _usageFormCode),
              ),
            ],
          ),
        ),
        DsSection(
          id: 'composition',
          title: 'Composition',
          description:
              'DsNativeSelect flattens whatever list it is handed to find '
              'the selected value and to build the open list: a flat list '
              'of DsSelectOption, or DsSelectOption wrapped in DsSelectGroup '
              'under a label. DsSelectSeparator is legal in the same list '
              'but carries no specimen of its own. Selection control and '
              'form have no options tree to assemble: a selection control '
              'is one indicator widget in a socket, and a form is a flat '
              'list of fields.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              DsPanel(
                label: 'DART',
                note: 'SIMPLE: A FLAT LIST OF OPTIONS',
                child: DocsSelectableCodeBlock(code: _compositionSimpleCode),
              ),
              SizedBox(height: ds(5)),
              DsPanel(
                label: 'DART',
                note: 'WITH GROUPS: OPTIONS WRAPPED IN DsSelectGroup',
                child: DocsSelectableCodeBlock(code: _compositionGroupedCode),
              ),
            ],
          ),
        ),
        DsSection(
          id: 'groups',
          title: 'Groups',
          description:
              'DsSelectGroup organises related options under a label: the '
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
        DsSection(
          id: 'disabled',
          title: 'Disabled',
          description:
              'enabled: false dims the whole wrapper to opacity-50 and '
              'stops it taking pointers, exactly where the reference dims '
              'the wrapper rather than the control. A single '
              'DsSelectOption.enabled: false keeps the rest of the control '
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
        DsSection(
          id: 'invalid',
          title: 'Invalid',
          description:
              'invalid: true colours the border and ring destructive and '
              'paints the ring even at rest: the same aria-invalid '
              'treatment the reference\'s class list carries. The '
              'enclosing DsFieldScope\'s own invalid ORs in, so either side '
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
        DsSection(
          id: 'native-select-vs-select',
          title: 'Native select vs select',
          description: 'When to reach for which.',
          child: _bullets(theme, <String>[
            'DsNativeSelect is the platform picker, as far as Flutter can '
                'carry it: the closed control is measured 1:1 with the '
                'reference, arrows step the value while closed, and '
                'Alt+Down, Enter, Space, F4 open the list. The open list is '
                'a port-built DsSelectMenu, not the OS picker: Flutter has '
                'no OS <select> widget.',
            'DsSelect is DsSelectMenu wearing the Radix menu component\'s '
                'own closed control instead: fully custom, taller (40px '
                'against 32), and the arrows open it directly rather than '
                'stepping a value while it stays shut.',
            'Reach for DsNativeSelect when the closed-control fidelity and '
                'the value-stepping keyboard matter more than a fully '
                'custom look. Reach for DsSelect everywhere else.',
          ]),
        ),
        DsSection(
          id: 'rtl',
          title: 'RTL',
          description:
              'The closed control\'s text and chevron use '
              'AlignmentDirectional, not a fixed left or right: under a '
              'Directionality.rtl the label starts on the right and the '
              'chevron gutter moves to the left, the same flip the '
              'reference gets from its own logical CSS properties. Nothing '
              'in native_select.dart hardcodes a left-to-right assumption. '
              'DsSelectionControl is square with symmetric hit-area '
              'insets and carries no direction-specific geometry of its '
              'own; DsForm reads no direction at all.',
          child: const DocsCodeExample(
            title: 'Right-to-left select',
            preview: _NativeSelectRtlPreview(),
          ),
        ),
        DsSection(
          id: 'api',
          title: 'API Reference',
          description:
              'DsNativeSelect and its size enum, DsSelectionControl and its '
              'hit area, and DsForm with fields and validation.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const DocsApiTable(
                title: 'DsNativeSelect',
                facts: <DocsApiFact>[
                  DocsApiFact(
                    name: 'options',
                    type: 'List<DsSelectChild<T>>',
                    description:
                        'Required. Flattened to find the selected value; '
                        'includes DsSelectOption, DsSelectGroup, and '
                        'DsSelectSeparator.',
                  ),
                  DocsApiFact(
                    name: 'value',
                    type: 'T?',
                    description:
                        'The selected value. null renders the first option '
                        '— an unselected `<select>` does not exist.',
                  ),
                  DocsApiFact(
                    name: 'onChanged',
                    type: 'ValueChanged<T>?',
                    description: 'Fired on commit; null disables.',
                  ),
                  DocsApiFact(
                    name: 'size',
                    type: 'DsNativeSelectSize',
                    description:
                        'Defaults to md. sm is 28px; md is 32px. See '
                        'DsNativeSelectSize below.',
                  ),
                  DocsApiFact(
                    name: 'enabled',
                    type: 'bool',
                    description:
                        'Defaults to true. ANDed with the enclosing '
                        'DsFieldScope\'s.',
                  ),
                  DocsApiFact(
                    name: 'invalid',
                    type: 'bool',
                    description:
                        'Defaults to false. ORed with DsFieldScope\'s; '
                        'colours the border and ring red.',
                  ),
                  DocsApiFact(
                    name: 'expand',
                    type: 'bool',
                    description:
                        'Defaults to false. true makes the control '
                        'double.infinity wide; false is w-fit.',
                  ),
                  DocsApiFact(
                    name: 'width',
                    type: 'double?',
                    description: 'Explicit measure; beats both expand states.',
                  ),
                  DocsApiFact(
                    name: 'focusNode',
                    type: 'FocusNode?',
                    description:
                        'The node the label focuses or a failed submit lands '
                        'on.',
                  ),
                  DocsApiFact(
                    name: 'label',
                    type: 'String?',
                    description:
                        'Accessible name; routed through DsFieldScope.',
                  ),
                  DocsApiFact(
                    name: 'hint',
                    type: 'String?',
                    description:
                        'aria-describedby; routed through DsFieldScope.',
                  ),
                  DocsApiFact(
                    name: 'DsNativeSelect.menuOffset',
                    type: 'static double (get)',
                    description:
                        '4px: the sideOffset between the closed control and '
                        'the open list.',
                  ),
                ],
              ),
              SizedBox(height: ds(5)),
              const DocsApiTable(
                title: 'DsNativeSelectSize',
                facts: <DocsApiFact>[
                  DocsApiFact(
                    name: 'sm',
                    type: 'enum value',
                    description: 'h-7 (28px), radius-md, py-0.5.',
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
                        'Returns "default" for md, "sm" for sm: the attribute '
                        'the reference writes.',
                  ),
                  DocsApiFact(
                    name: 'height',
                    type: 'double (get)',
                    description: 'ds(8) for md, ds(7) for sm.',
                  ),
                  DocsApiFact(
                    name: 'radius',
                    type: 'double (get)',
                    description:
                        'radius-lg (12px) for md, radius-md (8px) for sm.',
                  ),
                  DocsApiFact(
                    name: 'insetY',
                    type: 'double (get)',
                    description: 'ds(1) for md, ds(0.5) for sm.',
                  ),
                ],
              ),
              SizedBox(height: ds(5)),
              const DocsApiTable(
                title: 'DsSelectionControl',
                facts: <DocsApiFact>[
                  DocsApiFact(
                    name: 'width',
                    type: 'double',
                    description:
                        'Required. Painted size; the hit area expands beyond '
                        'this.',
                  ),
                  DocsApiFact(
                    name: 'height',
                    type: 'double',
                    description: 'Required. Painted size.',
                  ),
                  DocsApiFact(
                    name: 'radius',
                    type: 'BorderRadius',
                    description: 'Required. Control shape.',
                  ),
                  DocsApiFact(
                    name: 'fill',
                    type: 'Color',
                    description:
                        'Required. Background at rest for the state the '
                        'caller is in.',
                  ),
                  DocsApiFact(
                    name: 'border',
                    type: 'Color',
                    description:
                        'Required. Border at rest; overridden while focused '
                        'or invalid.',
                  ),
                  DocsApiFact(
                    name: 'shadow',
                    type: 'DsShadowSpec',
                    description:
                        'Required. The token for the state: shadow-pressed at '
                        'rest, shadow-btn-primary when checked/on.',
                  ),
                  DocsApiFact(
                    name: 'duration',
                    type: 'Duration',
                    description:
                        'Required. The transition length: all three inherit '
                        'DsDurations.transitionDefault.',
                  ),
                  DocsApiFact(
                    name: 'jellyState',
                    type: 'Object?',
                    description:
                        'Handed to DsJellyReplay; a change replays the squash '
                        'animation.',
                  ),
                  DocsApiFact(
                    name: 'child',
                    type: 'Widget',
                    description:
                        'Required. The indicator (checkbox check, radio dot, '
                        'switch knob).',
                  ),
                  DocsApiFact(
                    name: 'onTap',
                    type: 'VoidCallback?',
                    description: 'null disables the control.',
                  ),
                  DocsApiFact(
                    name: 'enabled',
                    type: 'bool',
                    description:
                        'Defaults to true. Separate from inert: a control can '
                        'be enabled but inert.',
                  ),
                  DocsApiFact(
                    name: 'inert',
                    type: 'bool',
                    description:
                        'Defaults to false. Indeterminate checkbox: full '
                        'strength paint, deaf, in tab order.',
                  ),
                  DocsApiFact(
                    name: 'invalid',
                    type: 'bool',
                    description:
                        'Defaults to false. aria-invalid="true"; colours the '
                        'border and ring red.',
                  ),
                  DocsApiFact(
                    name: 'forceFocusRing',
                    type: 'bool?',
                    description:
                        'Defaults to null (follow real focus). true paints the '
                        'ring always; false withholds it.',
                  ),
                  DocsApiFact(
                    name: 'focusNode',
                    type: 'FocusNode?',
                    description: 'The node for focus and roving tabindex.',
                  ),
                  DocsApiFact(
                    name: 'skipTraversal',
                    type: 'bool',
                    description:
                        'Defaults to false. Roving tabindex: used by radio '
                        'groups.',
                  ),
                  DocsApiFact(
                    name: 'onKey',
                    type: 'KeyEventResult Function(KeyEvent)?',
                    description:
                        'For group-level keyboard (arrows in a radio group).',
                  ),
                  DocsApiFact(
                    name: 'semantics',
                    type: 'Widget Function(Widget)?',
                    description:
                        'Applied inside the hit-area expander so a tap in the '
                        'margin is not rejected before semantics.',
                  ),
                ],
              ),
              SizedBox(height: ds(5)),
              const DocsApiTable(
                title: 'DsForm',
                facts: <DocsApiFact>[
                  DocsApiFact(
                    name: 'fields',
                    type: 'List<DsFormFieldBase>',
                    description:
                        'Required. In registration order: the order '
                        'focusFirstError walks.',
                  ),
                  DocsApiFact(
                    name: 'mode',
                    type: 'DsValidateMode',
                    description:
                        'Defaults to onSubmit. When the first validation ask '
                        'happens.',
                  ),
                  DocsApiFact(
                    name: 'reValidateMode',
                    type: 'DsValidateMode',
                    description:
                        'Defaults to onChange. Asked after the first failed '
                        'submit.',
                  ),
                  DocsApiFact(
                    name: 'validate',
                    type: 'bool Function()',
                    description:
                        'Validates every field; returns true if all pass.',
                  ),
                  DocsApiFact(
                    name: 'focusFirstError',
                    type: 'void Function()',
                    description:
                        'Focuses the first invalid field in registration order '
                        '— works for any field type, unlike the reference.',
                  ),
                  DocsApiFact(
                    name: 'submit',
                    type: 'Future<bool> Function([FutureOr<void> Function()?])',
                    description:
                        'Validates, focuses first error, holds isSubmitting '
                        'true for the onValid call.',
                  ),
                  DocsApiFact(
                    name: 'setError',
                    type: 'void Function(String, String)',
                    description:
                        'Sets a message on a field by name: server error path; '
                        'does not focus.',
                  ),
                  DocsApiFact(
                    name: 'clearErrors',
                    type: 'void Function()',
                    description: 'Clears all messages without clearing values.',
                  ),
                  DocsApiFact(
                    name: 'reset',
                    type: 'void Function()',
                    description:
                        'Back to initialValue with no messages and no submit '
                        'history.',
                  ),
                  DocsApiFact(
                    name: 'isValid',
                    type: 'bool (get)',
                    description:
                        'true if every field.invalid is false: computed, not '
                        're-asked.',
                  ),
                  DocsApiFact(
                    name: 'isSubmitting',
                    type: 'bool (get)',
                    description: 'true while submit\'s onValid runs.',
                  ),
                  DocsApiFact(
                    name: 'submitCount',
                    type: 'int (get)',
                    description:
                        'How many times submit has run: mode before this is '
                        '0, reValidateMode after.',
                  ),
                  DocsApiFact(
                    name: 'DsFormField<T>',
                    type: 'class',
                    description:
                        'A typed field: value, rules, issueMode. Construct '
                        'directly or use DsTextFormField.',
                  ),
                  DocsApiFact(
                    name: 'DsTextFormField',
                    type: 'class',
                    description:
                        'A DsFormField<String> that owns the '
                        'TextEditingController.',
                  ),
                ],
              ),
              SizedBox(height: ds(5)),
              const DocsApiTable(
                title: 'DsValidateMode',
                facts: <DocsApiFact>[
                  DocsApiFact(
                    name: 'onSubmit',
                    type: 'enum value',
                    description:
                        'The question is asked when submit() is called.',
                  ),
                  DocsApiFact(
                    name: 'onChange',
                    type: 'enum value',
                    description: 'Asked on every field edit.',
                  ),
                ],
              ),
            ],
          ),
        ),
        DsSection(
          id: 'states',
          title: 'States',
          description:
              'DsNativeSelect owns rest, hover, focus, invalid, disabled, and '
              'open, across both size rungs (see DsNativeSelectSize in API '
              'Reference above). DsSelectionControl and DsForm own their own '
              'states, documented here as N/A with the reason.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const DocsStateMatrix(
                facts: <DocsStateFact>[
                  DocsStateFact(
                    state: 'Rest (DsNativeSelect)',
                    treatment:
                        'Transparent fill (light) or input at 30% (dark), 1px '
                        'input border, no ring, chevron visible.',
                    userSignal:
                        'Unlabelled but focusable select, bordered, with a '
                        'visible chevron.',
                  ),
                  DocsStateFact(
                    state: 'Focus-visible (DsNativeSelect)',
                    treatment:
                        'Border becomes ring, ring-3 ring-ring/50 animates in '
                        'over transitionDefault.',
                    userSignal:
                        'The control is focussed: animated focus ring '
                        'appears.',
                  ),
                  DocsStateFact(
                    state: 'Invalid (DsNativeSelect)',
                    treatment:
                        'Border and ring become destructive and destructive/20 '
                        '(destructive/50 in dark); ring paints even at rest.',
                    userSignal:
                        'Red border and error ring communicate validation '
                        'failure.',
                  ),
                  DocsStateFact(
                    state: 'Disabled (DsNativeSelect)',
                    treatment:
                        'opacity-50 on the wrapper; the control itself only '
                        'stops taking pointers.',
                    userSignal:
                        'The whole control is dimmed to 50% opacity and does '
                        'not respond to input.',
                  ),
                  DocsStateFact(
                    state: 'Hover (DsNativeSelect)',
                    treatment:
                        'Dark mode only: bg-input/50 replaces bg-input/30. '
                        'Light mode has no hover state.',
                    userSignal:
                        'Dark: the background brightens slightly. Light: no '
                        'visible change.',
                  ),
                  DocsStateFact(
                    state: 'Open (DsNativeSelect)',
                    treatment:
                        'Border becomes ring; list appears below the control '
                        'without animation.',
                    userSignal:
                        'The list is anchored below and becomes the focus '
                        'target.',
                  ),
                  DocsStateFact(
                    state:
                        'States (DsSelectionControl, DsForm): rest, checked, '
                        'disabled, etc.',
                    treatment:
                        'N/A: these components do not own their own painted '
                        'states. DsSelectionControl is configured by its '
                        'caller (fill, border, shadow per state); DsForm has '
                        'no paint at all.',
                    userSignal:
                        'DsCheckbox, DsRadioGroup, and DsSwitch each paint '
                        'their own states using DsSelectionControl\'s socket. '
                        'DsForm is invisible.',
                  ),
                  DocsStateFact(
                    state: 'Reduced motion',
                    treatment:
                        'DsNativeSelect and DsSelectionControl honour '
                        'prefers-reduced-motion. DsJellyReplay still plays '
                        'because the reference\'s own jelly plays in reduced '
                        'motion mode (measured).',
                    userSignal:
                        'Animations slow or become instantaneous per system '
                        'preference.',
                  ),
                ],
              ),
            ],
          ),
        ),
        DsSection(
          id: 'accessibility',
          title: 'Accessibility',
          description: 'Each component\'s keyboard and semantic contract.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              DsPanel(
                label: 'DsNativeSelect keyboard',
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
              SizedBox(height: ds(4)),
              DsPanel(
                label: 'DsSelectionControl keyboard',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const _A11yRow(
                      'Activation',
                      'Enter and Space activate the control: it is a button. '
                          'Custom onKey handler is consulted first (for radio group '
                          'arrows).',
                    ),
                    const _A11yRow(
                      'Hit area',
                      'The visible control is 20×20 (checkbox/radio) or 44×24 '
                          '(switch), but the hit area expands to 42×34, 66×38, and '
                          '34×34 respectively. Margin expansion, not padding: so '
                          'neighbours stay in place.',
                    ),
                    _A11yRow(
                      'Semantics',
                      'The semantics wrapper is optional and caller-supplied; '
                          'DsCheckbox, DsRadioGroup, and DsSwitch each supply their '
                          'own.',
                      last: true,
                    ),
                  ],
                ),
              ),
              SizedBox(height: ds(4)),
              DsPanel(
                label: 'DsForm contract',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const _A11yRow(
                      'Non-visual',
                      'DsForm paints nothing: bind it with ListenableBuilder '
                          'and read field.invalid and field.errors to drive your '
                          'own UI.',
                    ),
                    const _A11yRow(
                      'Field focus',
                      'focusFirstError() focuses the first invalid field in '
                          'registration order: any field type, not just text inputs.',
                    ),
                    _A11yRow(
                      'Announcements',
                      'Managed by DsField and DsFieldError around the controls; '
                          'DsForm itself neither reads nor announces.',
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
          title: 'Responsive',
          child: _bullets(theme, <String>[
            'DsNativeSelect at expand: true uses double.infinity width; at '
                'expand: false is w-fit. A DsField wrapper will stretch it to '
                'the field\'s own width regardless.',
            'DsSelectionControl is sized by its caller (width, height); no '
                'responsive breakpoints.',
            'DsForm reads no MediaQuery and responds identically at 390px and '
                '1440px: the form state machine is viewport-agnostic.',
            'Keyboard activation (arrows, Enter, Space, Tab) and pointer '
                'activation (tap) behave identically on every Flutter target.',
          ]),
        ),
        DsSection(
          id: 'dependencies',
          title: 'Dependencies',
          description: 'What these components need to install and run.',
          child: DocsInstallFacts(
            facts: <DocsInstallFact>[
              const DocsInstallFact(
                label: 'Registry items',
                value: 'None: all three are new',
                description:
                    'No registry manifests exist yet. `elattar add '
                    'native-select`, `elattar add selection-control`, and '
                    '`elattar add form` do not work.',
              ),
              const DocsInstallFact(
                label: 'Source files',
                value: 'native_select.dart, selection_control.dart, form.dart',
                description:
                    'Three separate files in lib/src/components/. All are '
                    'exported from the public barrel.',
              ),
              const DocsInstallFact(
                label: 'Dependencies',
                value: 'source-foundation, popover, select, field',
                description:
                    'native_select depends on DsSelectMenu (from select), '
                    'DsPopover, and DsField; selection_control depends on '
                    'DsButton and DsKeyframePlayer; form depends on ds-rule.',
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
                    'package/test/ covers the components; this page covers '
                    'all three together.',
              ),
            ],
          ),
        ),
        DsSection(
          id: 'theming',
          title: 'Theming',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              DsPanel(
                label: 'What varies with the theme',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    DsText(
                      '**DsNativeSelect** reads theme.input, theme.ring, and '
                      'theme.destructive. Dark mode has a 30%–50% overlay on '
                      'input; light mode is transparent. Invalid state uses '
                      'destructive with alpha variants.',
                      DsType.small,
                    ),
                    SizedBox(height: ds(3)),
                    DsText(
                      '**DsSelectionControl** reads colours from its caller '
                      '(fill, border, shadow, ring): it applies no theme '
                      'colours itself. DsCheckbox, DsRadioGroup, and DsSwitch '
                      'supply those per their own state.',
                      DsType.small,
                    ),
                    SizedBox(height: ds(3)),
                    DsText(
                      '**DsForm** paints nothing and reads no theme.',
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
          title: 'Source',
          child: DocsInstallFacts(
            title: 'Source and tests',
            facts: <DocsInstallFact>[
              const DocsInstallFact(
                label: 'Source',
                value:
                    'lib/src/components/native_select.dart, '
                    'selection_control.dart, form.dart',
                description: 'The three source files.',
              ),
              const DocsInstallFact(
                label: 'Package tests',
                value: 'test/selection_control_test.dart, form_test.dart',
                description:
                    'Tests for the shared primitive and form logic, exercised '
                    'against the real components.',
              ),
              const DocsInstallFact(
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

const String _usageNativeSelectCode =
    '''final List<DsSelectOption<String>> options = <DsSelectOption<String>>[
  const DsSelectOption(value: 'us', label: 'United States'),
  const DsSelectOption(value: 'ca', label: 'Canada'),
  const DsSelectOption(value: 'mx', label: 'Mexico'),
];

DsField(
  label: 'Country',
  child: DsNativeSelect<String>(
    options: options,
    value: country,
    onChanged: (String next) => setState(() => country = next),
  ),
)''';

const String _usageSelectionControlCode =
    '''// DsSelectionControl is the invisible socket: not used directly.
// DsCheckbox, DsRadioGroup, and DsSwitch build on it.
// See those components for examples.

DsField(
  label: 'Agree to terms',
  orientation: DsFieldOrientation.horizontal,
  child: DsCheckbox(
    state: agreed ? DsCheckboxState.checked : DsCheckboxState.unchecked,
    onChanged: (DsCheckboxState next) {
      setState(() => agreed = next == DsCheckboxState.checked);
    },
  ),
)''';

const String _usageFormCode = '''final DsForm form = DsForm(
  fields: <DsFormFieldBase>[
    DsTextFormField(
      name: 'email',
      initialValue: '',
      rules: <DsRule<String>>[
        // Add your validation rules here
      ],
    ),
  ],
  mode: DsValidateMode.onSubmit,
  reValidateMode: DsValidateMode.onChange,
);

ListenableBuilder(
  listenable: form,
  builder: (BuildContext context, Widget? _) => Column(
    children: <Widget>[
      DsField(
        label: 'Email',
        errors: form.field<String>('email').errors,
        focusNode: form['email'].focusNode,
        child: DsInput(
          controller: form.text('email').controller,
          placeholder: 'you@example.com',
        ),
      ),
      DsButton(
        onPressed: form.isSubmitting
            ? null
            : () => form.submit(() {
              // Handle successful submission
            }),
        label: form.isSubmitting ? 'Submitting...' : 'Submit',
        child: DsText(
          form.isSubmitting ? 'Submitting...' : 'Submit',
          DsComponentType.buttonLabel,
        ),
      ),
    ],
  ),
)''';

const String _compositionSimpleCode = '''DsNativeSelect<String>(
  options: const <DsSelectOption<String>>[
    DsSelectOption(value: 'apple', label: 'Apple'),
    DsSelectOption(value: 'banana', label: 'Banana'),
    DsSelectOption(value: 'blueberry', label: 'Blueberry'),
  ],
  value: fruit,
  onChanged: (String next) => setState(() => fruit = next),
)''';

const String _compositionGroupedCode = '''DsNativeSelect<String>(
  options: const <DsSelectChild<String>>[
    DsSelectGroup<String>(
      label: 'Engineering',
      children: <DsSelectOption<String>>[
        DsSelectOption(value: 'engineer', label: 'Engineer'),
        DsSelectOption(value: 'designer', label: 'Designer'),
      ],
    ),
    DsSelectGroup<String>(
      label: 'Operations',
      children: <DsSelectOption<String>>[
        DsSelectOption(value: 'support', label: 'Support'),
        DsSelectOption(value: 'sales', label: 'Sales'),
      ],
    ),
  ],
  value: role,
  onChanged: (String next) => setState(() => role = next),
)''';

const String _disabledCode = '''DsField(
  label: 'Fruit',
  child: DsNativeSelect<String>(
    options: options,
    value: fruit,
    onChanged: (String next) => setState(() => fruit = next),
    enabled: false, // whole control dimmed and inert
  ),
)

DsField(
  label: 'Fruit',
  child: DsNativeSelect<String>(
    options: const <DsSelectOption<String>>[
      DsSelectOption(value: 'apple', label: 'Apple'),
      DsSelectOption(value: 'banana', label: 'Banana', enabled: false),
      DsSelectOption(value: 'blueberry', label: 'Blueberry'),
    ],
    value: fruit,
    onChanged: (String next) => setState(() => fruit = next),
    // the control stays live; only Banana is skipped
  ),
)''';

const String _invalidCode = '''DsField(
  label: 'Country',
  errors: const <String>['Select a valid country.'],
  child: DsNativeSelect<String>(
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
  bool _forceFocusRing = false;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        DsText('DsNativeSelect with a small option list', DsType.label),
        SizedBox(height: ds(3)),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: DsContainers.sm),
          child: DsField(
            key: const ValueKey<String>('native-select-preview'),
            label: 'Country',
            child: DsNativeSelect<String>(
              options: const <DsSelectChild<String>>[
                DsSelectOption(value: 'us', label: 'United States'),
                DsSelectOption(value: 'ca', label: 'Canada'),
                DsSelectOption(value: 'mx', label: 'Mexico'),
              ],
              value: _country,
              onChanged: (String next) => setState(() => _country = next),
            ),
          ),
        ),
        SizedBox(height: ds(7)),
        DsText(
          'DsSelectionControl: the shared socket (static focus ring, not real focus)',
          DsType.label,
        ),
        SizedBox(height: ds(3)),
        DsButton(
          variant: DsButtonVariant.outline,
          size: DsButtonSize.sm,
          onPressed: () => setState(() => _forceFocusRing = !_forceFocusRing),
          child: DsText(
            _forceFocusRing ? 'Hide focus ring' : 'Show focus ring',
            DsComponentType.buttonLabel,
          ),
        ),
        SizedBox(height: ds(3)),
        Wrap(
          spacing: ds(5),
          runSpacing: ds(5),
          children: <Widget>[
            SizedBox(
              width: ds(32),
              height: ds(32),
              child: DsSelectionControl(
                width: ds(20),
                height: ds(20),
                radius: BorderRadius.circular(DsRadii.sm),
                fill: theme.background,
                border: theme.input,
                shadow: DsShadows.pressed,
                duration: DsDurations.transitionDefault,
                jellyState: false,
                forceFocusRing: _forceFocusRing,
                onTap: () {},
                child: const SizedBox(),
              ),
            ),
            SizedBox(
              width: ds(32),
              height: ds(32),
              child: DsSelectionControl(
                width: ds(20),
                height: ds(20),
                radius: BorderRadius.circular(DsRadii.sm),
                fill: theme.primary,
                border: theme.primary,
                shadow: DsShadows.btnPrimary,
                duration: DsDurations.transitionDefault,
                jellyState: true,
                forceFocusRing: _forceFocusRing,
                onTap: () {},
                child: const SizedBox(),
              ),
            ),
          ],
        ),
      ],
    );
  }
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
    constraints: const BoxConstraints(maxWidth: DsContainers.sm),
    child: DsField(
      key: const ValueKey<String>('native-select-groups-preview'),
      label: 'Role',
      child: DsNativeSelect<String>(
        options: const <DsSelectChild<String>>[
          DsSelectGroup<String>(
            label: 'Engineering',
            children: <DsSelectOption<String>>[
              DsSelectOption(value: 'engineer', label: 'Engineer'),
              DsSelectOption(value: 'designer', label: 'Designer'),
            ],
          ),
          DsSelectGroup<String>(
            label: 'Operations',
            children: <DsSelectOption<String>>[
              DsSelectOption(value: 'support', label: 'Support'),
              DsSelectOption(value: 'sales', label: 'Sales'),
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

  static const List<DsSelectOption<String>> _fruits = <DsSelectOption<String>>[
    DsSelectOption(value: 'apple', label: 'Apple'),
    DsSelectOption(value: 'banana', label: 'Banana'),
    DsSelectOption(value: 'blueberry', label: 'Blueberry'),
  ];

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: DsContainers.sm),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        DsText('Whole control disabled', DsType.label),
        SizedBox(height: ds(3)),
        DsField(
          key: const ValueKey<String>('native-select-disabled-preview'),
          label: 'Fruit',
          child: DsNativeSelect<String>(
            options: _fruits,
            value: _wholeControl,
            onChanged: (String next) => setState(() => _wholeControl = next),
            enabled: false,
          ),
        ),
        SizedBox(height: ds(7)),
        DsText('One option disabled', DsType.label),
        SizedBox(height: ds(3)),
        DsField(
          key: const ValueKey<String>('native-select-disabled-option-preview'),
          label: 'Fruit',
          child: DsNativeSelect<String>(
            options: const <DsSelectOption<String>>[
              DsSelectOption(value: 'apple', label: 'Apple'),
              DsSelectOption(value: 'banana', label: 'Banana', enabled: false),
              DsSelectOption(value: 'blueberry', label: 'Blueberry'),
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
    constraints: const BoxConstraints(maxWidth: DsContainers.sm),
    child: DsField(
      key: const ValueKey<String>('native-select-invalid-preview'),
      label: 'Country',
      errors: const <String>['Select a valid country.'],
      child: DsNativeSelect<String>(
        options: const <DsSelectChild<String>>[
          DsSelectOption(value: 'us', label: 'United States'),
          DsSelectOption(value: 'ca', label: 'Canada'),
          DsSelectOption(value: 'mx', label: 'Mexico'),
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
      constraints: const BoxConstraints(maxWidth: DsContainers.sm),
      child: DsField(
        key: const ValueKey<String>('native-select-rtl-preview'),
        label: 'الدولة',
        child: DsNativeSelect<String>(
          options: const <DsSelectChild<String>>[
            DsSelectOption(value: 'sa', label: 'السعودية'),
            DsSelectOption(value: 'eg', label: 'مصر'),
            DsSelectOption(value: 'ma', label: 'المغرب'),
          ],
          value: _country,
          onChanged: (String next) => setState(() => _country = next),
        ),
      ),
    ),
  );
}
