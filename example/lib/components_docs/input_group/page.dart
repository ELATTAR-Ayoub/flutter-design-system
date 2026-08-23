/// Public documentation page for the `input_group` component family.
///
/// Documents three closely-related components: `DsInputGroup` (the 40px pill
/// container for controls with optional leading/trailing addons),
/// `DsButtonGroup` (the segmented control for related actions), and
/// `DsInputOtp` (the six-digit verification field with painted boxes over one
/// hidden input).
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/docs_code.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../kit.dart';
import 'meta.dart';

class InputGroupDocPage extends StatelessWidget {
  const InputGroupDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: inputGroupDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / BASE',
      title: inputGroupDoc.title,
      description: inputGroupDoc.description,
    ),
    breadcrumbs: const <DsBreadcrumbEntry>[
      DsBreadcrumbEntry.link('Components'),
      DsBreadcrumbEntry.page('Input group'),
    ],
    sidebar: _sidebar,
    toc: const <DocsTocEntry>[
      DocsTocEntry(title: 'Overview', anchor: 'overview'),
      DocsTocEntry(title: 'Preview', anchor: 'preview'),
      DocsTocEntry(title: 'Install', anchor: 'install'),
      DocsTocEntry(title: 'Usage', anchor: 'usage'),
      DocsTocEntry(title: 'API', anchor: 'api'),
      DocsTocEntry(title: 'Variants', anchor: 'variants'),
      DocsTocEntry(title: 'States', anchor: 'states'),
      DocsTocEntry(title: 'Accessibility', anchor: 'accessibility'),
      DocsTocEntry(title: 'Responsive', anchor: 'responsive'),
      DocsTocEntry(title: 'Dependencies', anchor: 'dependencies'),
      DocsTocEntry(title: 'Composition', anchor: 'composition'),
      DocsTocEntry(title: 'Theming', anchor: 'theming'),
      DocsTocEntry(title: 'Source', anchor: 'source'),
    ],
    previous: const DocsPageLink(title: 'Field', route: '/components/field'),
    next: const DocsPageLink(
      title: 'Input OTP',
      route: '/components/input_otp',
    ),
    onNavigate: onNavigate,
    child: const _ArticleContent(),
  );
}

const List<DocsSidebarEntry> _sidebar = <DocsSidebarEntry>[
  DocsSidebarEntry(title: 'Button group', route: '/components/button_group'),
  DocsSidebarEntry(title: 'Combobox', route: '/components/combobox'),
  DocsSidebarEntry(title: 'Field', route: '/components/field'),
  DocsSidebarEntry(
    title: 'Input group',
    route: '/components/input_group',
    selected: true,
  ),
  DocsSidebarEntry(title: 'Input OTP', route: '/components/input_otp'),
  DocsSidebarEntry(title: 'Native select', route: '/components/native_select'),
  DocsSidebarEntry(title: 'Radio', route: '/components/radio'),
  DocsSidebarEntry(
    title: 'Selection control',
    route: '/components/selection_control',
  ),
  DocsSidebarEntry(title: 'Slider', route: '/components/slider'),
  DocsSidebarEntry(title: 'Textarea', route: '/components/textarea'),
];

class _ArticleContent extends StatefulWidget {
  const _ArticleContent();

  @override
  State<_ArticleContent> createState() => _ArticleContentState();
}

class _ArticleContentState extends State<_ArticleContent> {
  bool _passwordVisible = false;
  int _count = 3;
  String _otpCode = '';

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Column(
      key: const ValueKey<String>('input-group-doc-article'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _overview(theme),
        _preview(theme),
        _install(),
        _usage(),
        _api(),
        _variants(),
        _states(),
        _accessibility(theme),
        _responsive(theme),
        _dependencies(theme),
        _composition(),
        _theming(theme),
        _source(),
      ],
    );
  }

  Widget _overview(DsThemeData theme) => DsSection(
    id: 'overview',
    title: 'Overview',
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: DsWidths.prose),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DsText(
            'DsInputGroup wraps form controls in a 40px pill-shaped container '
            'with optional leading and trailing addons. The addons can display '
            'text, icons, or buttons — used for search prefixes, password '
            'visibility toggles, or unit indicators. DsButtonGroup renders a '
            'segmented control: buttons joined at their edges with one hairline '
            'between each pair and squared interior corners. DsInputOtp is a '
            'six-digit verification field: six painted boxes over one hidden '
            'input, advancing focus and retreating on backspace.',
            DsType.body,
          ),
          SizedBox(height: ds(4)),
          DsText(
            'Status: stable primitives, not yet registered in the CLI (see '
            'Install). Platforms: Android, iOS, Web, macOS, Windows, Linux.',
            DsType.small,
            color: theme.mutedForeground,
          ),
        ],
      ),
    ),
  );

  Widget _preview(DsThemeData theme) => DsSection(
    id: 'preview',
    title: 'Preview',
    description:
        'A password field with toggle, a quantity stepper, and a '
        'complete OTP entry.',
    child: DocsCodeExample(
      title: 'Input group family specimens',
      preview: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: ds(6),
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DsText(
                'Input group with password visibility toggle',
                DsType.label,
              ),
              SizedBox(height: ds(3)),
              SizedBox(
                width: ds(64),
                key: const ValueKey<String>('input-group-doc-password-field'),
                child: DsInputGroup(
                  child: DsInputGroupInput(
                    placeholder: 'Enter password',
                    obscureText: !_passwordVisible,
                  ),
                  endAddon: DsInputGroupAddon(
                    align: DsInputGroupAlign.end,
                    holdsButton: true,
                    child: DsInputGroupButton(
                      key: const ValueKey<String>(
                        'input-group-doc-password-toggle',
                      ),
                      label: _passwordVisible ? 'Hide' : 'Show',
                      onPressed: () =>
                          setState(() => _passwordVisible = !_passwordVisible),
                      child: DsIcon(
                        _passwordVisible ? DsIconGlyph.eyeOff : DsIconGlyph.eye,
                        size: DsIconSize.sm,
                        tone: DsIconTone.inherit,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DsText('Button group quantity stepper', DsType.label),
              SizedBox(height: ds(3)),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DsButtonGroup(
                  children: <Widget>[
                    DsButton(
                      key: const ValueKey<String>('button-group-doc-decrease'),
                      variant: DsButtonVariant.outline,
                      size: DsButtonSize.sm,
                      onPressed: () =>
                          setState(() => _count = (_count - 1).clamp(0, 99)),
                      child: DsText('−', DsComponentType.buttonLabel),
                    ),
                    DsButtonGroupText(
                      _count.toString(),
                      key: const ValueKey<String>('button-group-doc-count'),
                      numeric: true,
                    ),
                    DsButton(
                      key: const ValueKey<String>('button-group-doc-increase'),
                      variant: DsButtonVariant.outline,
                      size: DsButtonSize.sm,
                      onPressed: () =>
                          setState(() => _count = (_count + 1).clamp(0, 99)),
                      child: DsText('+', DsComponentType.buttonLabel),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DsText('Input OTP live entry', DsType.label),
              SizedBox(height: ds(3)),
              Center(
                child: DsInputOtp(
                  key: const ValueKey<String>('input-otp-doc-live'),
                  onChanged: (String code) {
                    setState(() => _otpCode = code);
                  },
                ),
              ),
              SizedBox(height: ds(3)),
              DsText(
                _otpCode.length == 6
                    ? 'Complete: $_otpCode'
                    : 'Waiting for code...',
                key: const ValueKey<String>('input-otp-doc-status'),
                DsType.small,
                color: theme.mutedForeground,
              ),
            ],
          ),
        ],
      ),
    ),
  );

  Widget _install() => DsSection(
    id: 'install',
    title: 'Installation',
    description:
        'None of the three components have registry manifests yet — '
        'install by copying the source files manually.',
    child: DocsInstallFacts(
      title: 'Installation facts',
      facts: <DocsInstallFact>[
        const DocsInstallFact(
          label: 'Input group',
          value: 'Not available',
          description: 'No registry manifest exists. Copy the source manually.',
        ),
        const DocsInstallFact(
          label: 'Button group',
          value: 'Not available',
          description: 'No registry manifest exists. Copy the source manually.',
        ),
        const DocsInstallFact(
          label: 'Input OTP',
          value: 'Not available',
          description: 'No registry manifest exists. Copy the source manually.',
        ),
        const DocsInstallFact(
          label: 'Platforms',
          value: 'Android, iOS, Web, macOS, Windows, Linux',
          description:
              'Pure widget composition — no platform-conditional code.',
        ),
        const DocsInstallFact(
          label: 'Verified',
          value: 'docs specimen only',
          description:
              'This page\'s live preview and example/test/components_docs/'
              'input_group_test.dart.',
        ),
      ],
    ),
  );

  Widget _usage() => DsSection(
    id: 'usage',
    title: 'Usage',
    description:
        'DsInputGroup with a text input, DsButtonGroup with '
        'buttons, and DsInputOtp for verification codes.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DsPanel(
          label: 'DART',
          note: 'DsInputGroup WITH ADDON',
          child: DocsSelectableCodeBlock(code: _usageGroupCode),
        ),
        SizedBox(height: ds(5)),
        DsPanel(
          label: 'DART',
          note: 'DsButtonGroup SEGMENTED CONTROL',
          child: DocsSelectableCodeBlock(code: _usageButtonGroupCode),
        ),
        SizedBox(height: ds(5)),
        DsPanel(
          label: 'DART',
          note: 'DsInputOtp VERIFICATION FIELD',
          child: DocsSelectableCodeBlock(code: _usageOtpCode),
        ),
      ],
    ),
  );

  Widget _api() => DsSection(
    id: 'api',
    title: 'API',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const DocsApiTable(
          title: 'DsInputGroup',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'child',
              type: 'Widget',
              description:
                  'Required. The control, typically '
                  'DsInputGroupInput.',
            ),
            DocsApiFact(
              name: 'startAddon',
              type: 'Widget?',
              description: 'Optional leading addon — text, icon, or button.',
            ),
            DocsApiFact(
              name: 'endAddon',
              type: 'Widget?',
              description: 'Optional trailing addon — text, icon, or button.',
            ),
            DocsApiFact(
              name: 'invalid',
              type: 'bool',
              description: 'Defaults to false. Colors the ring destructive.',
            ),
            DocsApiFact(
              name: 'enabled',
              type: 'bool',
              description:
                  'Defaults to true. Reduces opacity and disables focus.',
            ),
            DocsApiFact(
              name: 'focusNode',
              type: 'FocusNode?',
              description:
                  'The control\'s focus node. Falls back to '
                  'DsFieldScope if not provided.',
            ),
            DocsApiFact(
              name: 'DsInputGroup.height',
              type: 'static double',
              description: '40px — the hard border-box height.',
            ),
            DocsApiFact(
              name: 'DsInputGroup.addonInset',
              type: 'static double',
              description: '16px — the addon\'s horizontal padding.',
            ),
            DocsApiFact(
              name: 'DsInputGroup.addonButtonPull',
              type: 'static double',
              description: '4px — negative margin when addon holds a button.',
            ),
            DocsApiFact(
              name: 'DsInputGroup.clearance',
              type: 'static double',
              description: '8px — the control\'s padding on an addon side.',
            ),
          ],
        ),
        SizedBox(height: ds(6)),
        const DocsApiTable(
          title: 'DsInputGroupInput',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'controller',
              type: 'TextEditingController?',
              description: 'Drives the field\'s value from outside.',
            ),
            DocsApiFact(
              name: 'initialValue',
              type: 'String?',
              description: 'Seeds the field on first build.',
            ),
            DocsApiFact(
              name: 'placeholder',
              type: 'String?',
              description: 'Hint text shown when the field is empty.',
            ),
            DocsApiFact(
              name: 'obscureText',
              type: 'bool',
              description: 'Defaults to false. Password-field dots.',
            ),
            DocsApiFact(
              name: 'keyboardType',
              type: 'TextInputType',
              description: 'The soft keyboard layout — number, email, etc.',
            ),
            DocsApiFact(
              name: 'onChanged',
              type: 'ValueChanged<String>?',
              description: 'Fires as the user types.',
            ),
            DocsApiFact(
              name: 'onSubmitted',
              type: 'ValueChanged<String>?',
              description: 'Fires when the user submits (Return key).',
            ),
            DocsApiFact(
              name: 'readOnly',
              type: 'bool',
              description:
                  'Defaults to false. Disables editing but allows selection.',
            ),
            DocsApiFact(
              name: 'autofillHints',
              type: 'Iterable<String>?',
              description:
                  'iOS/Android autofill hints — pass username, password, etc.',
            ),
            DocsApiFact(
              name: 'textSpec',
              type: 'DsTypeSpec?',
              description: 'Overrides the type spec — defaults to body.',
            ),
            DocsApiFact(
              name: 'label',
              type: 'String?',
              description:
                  'The field\'s accessible label, announced to screen readers.',
            ),
          ],
        ),
        SizedBox(height: ds(6)),
        const DocsApiTable(
          title: 'DsInputGroupAddon',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'child',
              type: 'Widget',
              description:
                  'Required. The content — DsText, DsIcon, or '
                  'DsInputGroupButton.',
            ),
            DocsApiFact(
              name: 'align',
              type: 'DsInputGroupAlign',
              description: 'start or end — the addon\'s position.',
            ),
            DocsApiFact(
              name: 'holdsButton',
              type: 'bool',
              description:
                  'Defaults to false. Applies negative margin '
                  'when the child is DsInputGroupButton.',
            ),
            DocsApiFact(
              name: 'DsInputGroupAddon.insetY',
              type: 'static double',
              description: '8px — vertical inset from the group edge.',
            ),
            DocsApiFact(
              name: 'DsInputGroupAddon.gap',
              type: 'static double',
              description: '8px — gap between addon and control.',
            ),
          ],
        ),
        SizedBox(height: ds(6)),
        const DocsApiTable(
          title: 'DsInputGroupText',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'text',
              type: 'String',
              description: 'Required. The label text.',
            ),
            DocsApiFact(
              name: 'spec',
              type: 'DsTypeSpec?',
              description: 'Overrides the type spec — defaults to body.',
            ),
          ],
        ),
        SizedBox(height: ds(6)),
        const DocsApiTable(
          title: 'DsInputGroupButton',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'child',
              type: 'Widget?',
              description: 'Optional. An icon or text — size xs.',
            ),
            DocsApiFact(
              name: 'onPressed',
              type: 'VoidCallback',
              description: 'Required. Fires when the button is tapped.',
            ),
            DocsApiFact(
              name: 'label',
              type: 'String',
              description: 'Required. The button\'s semantic label.',
            ),
            DocsApiFact(
              name: 'toggled',
              type: 'bool',
              description: 'Defaults to false. A toggled-button fill.',
            ),
            DocsApiFact(
              name: 'focusNode',
              type: 'FocusNode?',
              description: 'The button\'s focus node.',
            ),
            DocsApiFact(
              name: 'size',
              type: 'DsInputGroupButtonSize',
              description: 'xs (default) or iconXs.',
            ),
            DocsApiFact(
              name: 'cancelPressFill',
              type: 'bool',
              description:
                  'Defaults to true. Controls whether the button shows fill on '
                  'press.',
            ),
            DocsApiFact(
              name: 'DsInputGroupButton.height',
              type: 'static double',
              description: '40px — the hard border-box height.',
            ),
            DocsApiFact(
              name: 'DsInputGroupButton.paddingX',
              type: 'static double',
              description: '8px — horizontal padding.',
            ),
            DocsApiFact(
              name: 'DsInputGroupButton.paddingXFor',
              type: 'static double Function',
              description: 'Calculates paddingX from a given child width.',
            ),
            DocsApiFact(
              name: 'DsInputGroupButton.gap',
              type: 'static double',
              description: '6px — gap between icon and label.',
            ),
          ],
        ),
        SizedBox(height: ds(6)),
        const DocsApiTable(
          title: 'DsButtonGroup',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'children',
              type: 'List<Widget>',
              description:
                  'Required. DsButton, DsButtonGroupText, or '
                  'DsButtonGroupSeparator instances.',
            ),
            DocsApiFact(
              name: 'DsButtonGroup.radiiOf',
              type: 'static BorderRadius Function',
              description: 'Reads the corner radii for a member at an index.',
            ),
            DocsApiFact(
              name: 'DsButtonGroup.hasLeftBorder',
              type: 'static bool Function',
              description: 'True only for the first member.',
            ),
          ],
        ),
        SizedBox(height: ds(6)),
        const DocsApiTable(
          title: 'DsButtonGroupText',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'text',
              type: 'String',
              description: 'Required. The cell\'s text.',
            ),
            DocsApiFact(
              name: 'numeric',
              type: 'bool',
              description: 'Defaults to false. Centers numeric text.',
            ),
            DocsApiFact(
              name: 'DsButtonGroupText.paddingX',
              type: 'static double',
              description: '8px — horizontal padding.',
            ),
            DocsApiFact(
              name: 'DsButtonGroupText.gap',
              type: 'static double',
              description: '6px — gap between elements.',
            ),
          ],
        ),
        SizedBox(height: ds(6)),
        const DocsApiTable(
          title: 'DsButtonGroupSeparator',
          facts: <DocsApiFact>[],
        ),
        SizedBox(height: ds(6)),
        const DocsApiTable(
          title: 'DsInputOtp',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'maxLength',
              type: 'int',
              description: 'Defaults to 6. The digit count.',
            ),
            DocsApiFact(
              name: 'groups',
              type: 'List<int>',
              description:
                  'Defaults to [3, 3]. How slots are grouped with '
                  'separators between them. MUST sum to maxLength.',
            ),
            DocsApiFact(
              name: 'controller',
              type: 'TextEditingController?',
              description: 'Drives the field\'s value from outside.',
            ),
            DocsApiFact(
              name: 'initialValue',
              type: 'String?',
              description: 'Seeds the field on first build.',
            ),
            DocsApiFact(
              name: 'focusNode',
              type: 'FocusNode?',
              description: 'The field\'s focus node.',
            ),
            DocsApiFact(
              name: 'onChanged',
              type: 'ValueChanged<String>?',
              description:
                  'Fires each time the value changes, including when '
                  'reaching maxLength.',
            ),
            DocsApiFact(
              name: 'enabled',
              type: 'bool',
              description: 'Defaults to true. Disables input and fades.',
            ),
            DocsApiFact(
              name: 'invalid',
              type: 'bool',
              description:
                  'Defaults to false. Colors the slot borders and ring '
                  'destructive.',
            ),
            DocsApiFact(
              name: 'label',
              type: 'String?',
              description:
                  'The field\'s accessible label, announced to screen '
                  'readers.',
            ),
            DocsApiFact(
              name: 'DsInputOtp.slotSize',
              type: 'static double',
              description: '32px — the height and width of each slot.',
            ),
            DocsApiFact(
              name: 'DsInputOtp.separatorWidth',
              type: 'static double',
              description: '16px — the width of each separator.',
            ),
            DocsApiFact(
              name: 'DsInputOtp.widthFor',
              type: 'static double Function',
              description: 'Calculates the total width for a groups list.',
            ),
          ],
        ),
        SizedBox(height: ds(6)),
        const DocsApiTable(
          title: 'DsInputOtpSlot',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'char',
              type: 'String?',
              description: 'The character in this slot, or null if empty.',
            ),
            DocsApiFact(
              name: 'active',
              type: 'bool',
              description: 'True when the caret is on this slot.',
            ),
            DocsApiFact(
              name: 'invalid',
              type: 'bool',
              description: 'Drawn with destructive border and ring.',
            ),
            DocsApiFact(
              name: 'first',
              type: 'bool',
              description: 'True for the first slot in the strip.',
            ),
            DocsApiFact(
              name: 'last',
              type: 'bool',
              description: 'True for the last slot in the strip.',
            ),
          ],
        ),
        SizedBox(height: ds(6)),
        const DocsApiTable(
          title: 'DsInputOtpSeparator',
          facts: <DocsApiFact>[],
        ),
      ],
    ),
  );

  Widget _variants() => DsSection(
    id: 'variants',
    title: 'Variants and sizes',
    description:
        'No size axis on any component — all use fixed token '
        'heights. DsInputGroupAlign selects addon position.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const DocsApiTable(
          title: 'DsInputGroupAlign',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'start',
              type: 'enum value',
              description: 'The addon leads the control.',
            ),
            DocsApiFact(
              name: 'end',
              type: 'enum value',
              description: 'The addon trails the control.',
            ),
          ],
        ),
        SizedBox(height: ds(6)),
        const DocsApiTable(
          title: 'DsInputGroupButtonSize',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'xs',
              type: 'enum value',
              description: 'Extra small — 32px × 32px.',
            ),
            DocsApiFact(
              name: 'iconXs',
              type: 'enum value',
              description: 'Icon-only extra small — 32px × 32px.',
            ),
          ],
        ),
      ],
    ),
  );

  Widget _states() => DsSection(
    id: 'states',
    title: 'States and feedback',
    description:
        'Rest, invalid, disabled, and focus behaviors documented '
        'per family, with N/A for inapplicable states.',
    child: const DocsStateMatrix(
      facts: <DocsStateFact>[
        DocsStateFact(
          state: 'Rest',
          treatment: 'Border paints theme.input, ring transparent. No shadow.',
          userSignal: 'Plain gray pill.',
        ),
        DocsStateFact(
          state: 'Focus-visible',
          treatment:
              'Border becomes theme.ring, ring at 50% alpha. For '
              'DsInputGroup only.',
          userSignal: 'Blue outline.',
        ),
        DocsStateFact(
          state: 'Invalid',
          treatment:
              'Ring becomes theme.destructive at 20% (light) or 40% '
              '(dark). Border and ring stay — never just the ring.',
          userSignal: 'Red ring.',
        ),
        DocsStateFact(
          state: 'Disabled',
          treatment: 'Opacity drops to 50%. Control does not accept focus.',
          userSignal: 'Faded appearance.',
        ),
        DocsStateFact(
          state: 'Hover / Pressed / Selected / Loading / Success',
          treatment:
              'N/A for DsInputGroup and DsButtonGroup — those states '
              'belong to the wrapped control. For DsInputOtp: painted '
              'boxes have no state of their own beyond active and '
              'invalid.',
          userSignal:
              'Refer to DsInput, DsButton, and DsInputOtp.active '
              'respectively.',
        ),
        DocsStateFact(
          state: 'Reduced motion',
          treatment:
              'N/A — no AnimationController in any of the three. The '
              'OTP caret animation is a discrete lookup, not a tween.',
          userSignal: 'Nothing to still.',
        ),
      ],
    ),
  );

  Widget _accessibility(DsThemeData theme) => DsSection(
    id: 'accessibility',
    title: 'Accessibility and keyboard behavior',
    child: _bullets(theme, <String>[
      'DsInputGroup wraps the whole subtree in Semantics(container: true). '
          'The control inside reads its own label through DsFieldScope.',
      'DsButtonGroup carries Semantics(container: true) with no role — '
          'it is a container, not a group with a semantic role. The buttons '
          'inside keep their own semantics.',
      'DsInputOtp publishes one textField semantics node over the whole '
          'strip — not six unlabelled boxes. All input goes to one hidden '
          'EditableText; the painted boxes contribute no semantics of their '
          'own.',
      'Focus behavior: DsInputGroup.focusNode focuses the control on '
          'label tap. The OTP strip takes focus as one field. Keyboard: '
          'DsButtonGroup is not in the tab order — it is a control family, '
          'not a container. DsInputOtp: typing and backspace work as '
          'expected; Tab advances to the next field.',
      'Touch target: DsInputGroup is 40px tall and 16px horizontally '
          'padded — the same as DsInput on the group wrapper. Buttons are '
          '40px tall and 16px wide (sm size) or 32px × 32px (xs). '
          'DsInputOtp slots are 32px × 32px.',
      'Non-colour signals: error is shown as destructive text, not just '
          'colour. The active OTP slot shows a focus ring, not just a visual '
          'highlight.',
      'Screen-reader announcements: DsInputOtp has no live region — '
          'completion does not announce; wire that at the call site if '
          'needed.',
      'Known platform differences: DsButtonGroup.radiiOf uses symmetric '
          'bleed to reshape children — the visual result is identical on all '
          'platforms, but the mechanism is Flutter-specific.',
    ]),
  );

  Widget _responsive(DsThemeData theme) => DsSection(
    id: 'responsive',
    title: 'Responsive and platform behavior',
    child: _bullets(theme, <String>[
      'No responsive breakpoints — DsInputGroup renders the same pill at '
          '390px and 1440px. Width is intrinsic to the content and the '
          'frame around it.',
      'DsButtonGroup: interior members are squared; left end keeps its '
          'radius; right end is forced to 12px. The same on all viewports.',
      'DsInputOtp: the strip is always the sum of (slotSize × slot count) '
          'plus (separatorWidth × separator count). On narrow screens, '
          'constrain the surrounding layout if the 208px default is too wide.',
      'Overflow: DsInputGroup clips addons to its own height. Long button '
          'labels are not truncated — they may overflow. The container must '
          'constrain width.',
      'All three render the same widget tree on Android, iOS, Web, macOS, '
          'Windows, and Linux.',
    ]),
  );

  Widget _dependencies(DsThemeData theme) => DsSection(
    id: 'dependencies',
    title: 'Dependencies, files, and assets',
    child: _bullets(theme, <String>[
      'Files: lib/src/components/input_group.dart (764 lines), '
          'button_group.dart (774 lines), input_otp.dart (625 lines). No '
          'companion parts.',
      'Foundation imports: colors.dart, spacing.dart, theme.dart, '
          'typography.dart, motion.dart, shadows.dart.',
      'Effects: machine_surface.dart (DsInputOtp uses it for slot borders '
          'and ring).',
      'Assets: none. Fonts: none beyond the system type scale. Shaders: '
          'none.',
      'DsInputOtp: EditableText over IgnorePointer, not six separate '
          'TextFields — the semantic and event model is built on that '
          'architecture.',
    ]),
  );

  Widget _composition() => DsSection(
    id: 'composition',
    title: 'Composition examples',
    description:
        'A search input, a segment control, and the three family '
        'members as they live in the system.',
    child: DocsCodeExample(
      title: 'Real compositions from this design system',
      preview: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: ds(4),
        children: <Widget>[
          DsText('Search with leading icon and button', DsType.label),
          DsInputGroup(
            startAddon: DsInputGroupAddon(
              align: DsInputGroupAlign.start,
              child: DsIcon(
                DsIconGlyph.search,
                size: DsIconSize.md,
                tone: DsIconTone.inherit,
              ),
            ),
            endAddon: DsInputGroupAddon(
              align: DsInputGroupAlign.end,
              holdsButton: true,
              child: DsInputGroupButton(
                label: 'Clear',
                onPressed: () {},
                child: const DsIcon(
                  DsIconGlyph.x,
                  size: DsIconSize.sm,
                  tone: DsIconTone.inherit,
                ),
              ),
            ),
            child: DsInputGroupInput(placeholder: 'Search...'),
          ),
          SizedBox(height: ds(2)),
          DsText('Filter toggle buttons', DsType.label),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DsButtonGroup(
              children: <Widget>[
                DsButton(
                  variant: DsButtonVariant.outline,
                  size: DsButtonSize.sm,
                  onPressed: () {},
                  child: DsText('All', DsComponentType.buttonLabel),
                ),
                DsButton(
                  variant: DsButtonVariant.outline,
                  size: DsButtonSize.sm,
                  onPressed: () {},
                  child: DsText('Active', DsComponentType.buttonLabel),
                ),
                DsButton(
                  variant: DsButtonVariant.outline,
                  size: DsButtonSize.sm,
                  onPressed: () {},
                  child: DsText('Archived', DsComponentType.buttonLabel),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  Widget _theming(DsThemeData theme) => DsSection(
    id: 'theming',
    title: 'Theming notes',
    child: _bullets(theme, <String>[
      'DsInputGroup: border is theme.input (resting), theme.ring (focused). '
          'Invalid ring is theme.destructive at 20% (light) or 40% (dark). '
          'Addons inherit text colour from their content (DsText, DsIcon).',
      'DsButtonGroup: uses the resting border of the button variant inside '
          'it (e.g., theme.input for outline). Separators and hairlines are '
          'theme.border. The seam between two members is one hairline, not '
          'two.',
      'DsInputOtp: slot borders are theme.input at rest. On focus, the '
          'active slot gets a ring at theme.ring / 50%. Invalid state uses '
          'theme.destructive borders. In dark mode, empty slots have a 30% '
          'alpha fill; light mode is transparent.',
      'No colour overrides — all values come from the theme. A call site '
          'that needs a non-standard colour should use DsTheme.of(context) '
          'to derive its own.',
    ]),
  );

  Widget _source() => DsSection(
    id: 'source',
    title: 'Source and tests',
    child: DocsInstallFacts(
      title: 'Reference',
      facts: <DocsInstallFact>[
        DocsInstallFact(
          label: 'Source',
          value: inputGroupDoc.sourcePath,
          description:
              'Authoritative implementation — the truth this page was '
              'written from.',
        ),
        const DocsInstallFact(
          label: 'Package tests',
          value: 'none yet',
          description: 'No dedicated unit tests in the package test suite.',
        ),
        const DocsInstallFact(
          label: 'Docs test',
          value: 'example/test/components_docs/input_group_test.dart',
          description:
              'Covers this page: API tables, live specimens, state '
              'transitions, and theme coverage for all three components.',
        ),
        const DocsInstallFact(
          label: 'Edit these docs',
          value: 'example/lib/components_docs/input_group/page.dart',
          description: 'This file.',
        ),
      ],
    ),
  );
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

const String _usageGroupCode = '''DsInputGroup(
  child: DsInputGroupInput(
    placeholder: 'https://',
  ),
  startAddon: DsInputGroupAddon(
    align: DsInputGroupAlign.start,
    child: DsInputGroupText(text: 'https://'),
  ),
)''';

const String _usageButtonGroupCode = '''DsButtonGroup(
  children: <Widget>[
    DsButton(
      variant: DsButtonVariant.outline,
      onPressed: () {},
      child: const Text('Day'),
    ),
    DsButton(
      variant: DsButtonVariant.outline,
      onPressed: () {},
      child: const Text('Week'),
    ),
    DsButton(
      variant: DsButtonVariant.outline,
      onPressed: () {},
      child: const Text('Month'),
    ),
  ],
)''';

const String _usageOtpCode = '''DsInputOtp(
  maxLength: 6,
  groups: const <int>[3, 3],
  onChanged: (String code) {
    if (code.length == 6) {
      // Code complete
    }
  },
)''';
