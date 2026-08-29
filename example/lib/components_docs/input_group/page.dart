/// Public documentation page for the `input_group` component.
///
/// **Re-housed onto the documentation kit** (matching
/// `components_docs/button/page.dart`'s own reference shape): the page is
/// now a `ComponentDocSpec` declaration plus a ten-line widget handing it to
/// `DocsLayout`, rather than a hand-composed `_Article`. Every specimen and
/// every code string below moved across unchanged from the previous
/// hand-composed page; nothing here was rewritten or reworded. Two changes
/// are new: the live preview is promoted to its own `Preview` `ShowcaseSection`
/// (it used to render ahead of any heading, with no rail entry of its own),
/// and a `Keyboard` disclosure is added between Accessibility and Responsive
/// — this page had none before, only a merged "Accessibility and keyboard
/// behavior" heading whose bullets, read closely, never actually named a key.
/// The keyboard facts below are new prose, read directly off
/// `lib/src/components/ui/input_group.dart`, not inferred: `InputGroupButton`
/// wires no `onKeyEvent` of its own (its `Press` wraps a bare
/// `GestureDetector.onTap`), so a focused addon button does not activate on
/// Enter or Space — a real, documented gap, not a claim this page invents.
///
/// **Split from a merged page.** Phase F/J's original `input_group` route
/// documented three unrelated components on one page: `InputGroup`,
/// `ButtonGroup`, and `InputOtp`. This page covers `InputGroup` alone;
/// `ButtonGroup` moved to `../button_group/page.dart` and `InputOtp` to
/// `../input_otp/page.dart`, each its own route.
///
/// **Against shadcn's own page**
/// (https://ui.shadcn.com/docs/components/base/input-group, fetched fresh):
/// its own `<h2>`s are Installation, Usage, Composition, Align (with four
/// `<h3>` children: inline-start, inline-end, block-start, block-end), Icon,
/// Text, Button, Kbd, Dropdown, Spinner, Textarea, Custom Input, RTL, API
/// Reference (five nested tables). This page keeps Composition, Custom
/// Input, and RTL under their own names. Align becomes Addon Position: only
/// the two inline values are built (`InputGroupAlign` has no
/// block-start/block-end; `InputGroupInput` is single-line, so a block
/// addon does not apply). Icon, Text, Button, Kbd, and Spinner are one
/// shadcn addon TYPE each, but this port has no separate widget per type:
/// they are all the same `InputGroupAddon.child` slot with different
/// content, so they stay merged under Addon Content rather than five
/// near-duplicate sections. Dropdown gets its own small section, Dropdown
/// Addon, as a manual code panel rather than a live specimen:
/// `DropdownMenu` needs a real overlay ancestor this page's plain preview
/// column does not provide (see the dropdown_menu docs for the interactive
/// version). Textarea is skipped honestly: there is no `InputGroupTextarea`
/// in this port — `Input` gained a `bare` mode instead of a second
/// addon-aware control being built.
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

final ComponentDocSpec inputGroupDocSpec = ComponentDocSpec(
  name: 'input-group',
  title: inputGroupDoc.title,
  description: inputGroupDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description: 'A password field whose trailing addon toggles obscureText.',
      specimen: _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          '`elattar add input-group` installs the component and its '
          'declared dependency closure. No registry/components/'
          'input_group.json exists yet: copy '
          'lib/src/components/ui/input_group.dart manually until it does.',
      command: inputGroupDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: inputGroupDoc.sourcePath,
          title: '1. Copy the source',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// No registry manifest yet: copy lib/src/components/ui/'
              'input_group.dart into lib/components/ui/ in your project.',
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'The smallest correct import and construction. Every example '
          'below only changes named arguments or addon content on top of '
          'this.',
      code: _usageCode,
    ),
    SnippetSection(
      id: 'composition',
      title: 'Composition',
      description: 'The widget hierarchy InputGroup builds on.',
      code: _compositionCode,
    ),
    ShowcaseSection(
      id: 'position',
      title: 'Addon position',
      description:
          'align selects which side the addon sits on: start (their '
          'inline-start) or end (their inline-end). There is no '
          'block-start or block-end: InputGroupInput is single-line, so '
          'an addon above or below the control does not apply here.',
      specimen: _PositionSpecimen(),
      code: _positionCode,
      label: 'Addon position specimen view',
    ),
    ShowcaseSection(
      id: 'content',
      title: 'Addon content',
      description:
          'An addon holds one widget: icon, text, button, kbd, or spinner '
          'below are the same slot with different content, not different '
          'props.',
      specimen: _ContentSpecimen(),
      code: _contentCode,
      label: 'Addon content specimen view',
    ),
    SnippetSection(
      id: 'dropdown-addon',
      title: 'Dropdown addon',
      description:
          'A DropdownMenu trigger fits the same addon slot. It is not '
          'rendered live on this page because it needs a real Overlay '
          'ancestor (see the dropdown_menu docs for the interactive '
          'version).',
      code: _dropdownAddonCode,
    ),
    SnippetSection(
      id: 'custom-input',
      title: 'Custom input',
      description:
          'InputGroup.child accepts any widget, not only '
          'InputGroupInput. There is no data-slot equivalent, though: a '
          'custom control has to match the group\'s own 40px height and '
          'padding tokens itself, InputGroup does not measure or resize '
          'an unrecognised child for it.',
      code: _customInputCode,
    ),
    ShowcaseSection(
      id: 'rtl',
      title: 'RTL',
      specimen: _RtlSpecimen(),
      code: _rtlCode,
      label: 'RTL specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every constructor parameter each exported class declares, read '
          'directly off lib/src/components/ui/input_group.dart: one table per '
          'class or enum.',
      children: const <DocsTocEntry>[
        DocsTocEntry(title: 'InputGroup', anchor: 'api-elinputgroup'),
        DocsTocEntry(title: 'InputGroupInput', anchor: 'api-elinputgroupinput'),
        DocsTocEntry(title: 'InputGroupAddon', anchor: 'api-elinputgroupaddon'),
        DocsTocEntry(title: 'InputGroupText', anchor: 'api-elinputgrouptext'),
        DocsTocEntry(
          title: 'InputGroupButton',
          anchor: 'api-elinputgroupbutton',
        ),
        DocsTocEntry(title: 'InputGroupAlign', anchor: 'api-elinputgroupalign'),
        DocsTocEntry(
          title: 'InputGroupButtonSize',
          anchor: 'api-elinputgroupbuttonsize',
        ),
      ],
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'Read straight off _DsInputGroupState.build and '
          '_DsInputGroupButtonState.build, not inferred.',
      child: const DocsStateMatrix(facts: _stateFacts),
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
          'New: split out of the old merged "Accessibility and keyboard '
          'behavior" heading, whose own bullets never named a key. Every '
          'claim here is read directly off input_group.dart itself.',
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
            value: inputGroupDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
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
                'transitions, and theme coverage.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/input_group/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class InputGroupDocPage extends StatelessWidget {
  const InputGroupDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: inputGroupDoc.route,
    intro: DocsPageIntro(
      title: inputGroupDoc.title,
      description: inputGroupDoc.description,
    ),
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Components'),
      BreadcrumbEntry.page('Input group'),
    ],
    toc: inputGroupDocSpec.toc,
    previous: const DocsPageLink(title: 'Field', route: '/components/field'),
    next: const DocsPageLink(
      title: 'Button group',
      route: '/components/button_group',
    ),
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('input-group-doc-article'),
      child: ComponentDocPage(spec: inputGroupDocSpec, header: false),
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
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) => Center(
    child: SizedBox(
      width: space(72),
      key: const ValueKey<String>('input-group-doc-password-field'),
      child: InputGroup(
        endAddon: InputGroupAddon(
          align: InputGroupAlign.end,
          holdsButton: true,
          child: InputGroupButton(
            key: const ValueKey<String>('input-group-doc-password-toggle'),
            label: _passwordVisible ? 'Hide password' : 'Show password',
            toggled: _passwordVisible,
            onPressed: () =>
                setState(() => _passwordVisible = !_passwordVisible),
            child: Icon(
              _passwordVisible ? IconGlyph.eyeOff : IconGlyph.eye,
              size: IconSize.sm,
              tone: IconTone.inherit,
            ),
          ),
        ),
        child: InputGroupInput(
          placeholder: 'Enter password',
          obscureText: !_passwordVisible,
        ),
      ),
    ),
  );
}

class _PositionSpecimen extends StatelessWidget {
  const _PositionSpecimen();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          StyledText('start', TextStyles.small),
          SizedBox(height: space(2)),
          InputGroup(
            startAddon: InputGroupAddon(
              align: InputGroupAlign.start,
              child: InputGroupText('https://'),
            ),
            child: InputGroupInput(placeholder: 'example.com'),
          ),
        ],
      ),
      SizedBox(height: space(5)),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          StyledText('end', TextStyles.small),
          SizedBox(height: space(2)),
          InputGroup(
            endAddon: InputGroupAddon(
              align: InputGroupAlign.end,
              child: InputGroupText('.com'),
            ),
            child: InputGroupInput(placeholder: 'example'),
          ),
        ],
      ),
    ],
  );
}

class _ContentSpecimen extends StatelessWidget {
  const _ContentSpecimen();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      StyledText('Search with leading icon and button', TextStyles.section),
      SizedBox(height: space(2)),
      InputGroup(
        startAddon: InputGroupAddon(
          align: InputGroupAlign.start,
          child: Icon(
            IconGlyph.search,
            size: IconSize.md,
            tone: IconTone.inherit,
          ),
        ),
        endAddon: InputGroupAddon(
          align: InputGroupAlign.end,
          holdsButton: true,
          child: InputGroupButton(
            label: 'Clear',
            onPressed: () {},
            child: const Icon(
              IconGlyph.x,
              size: IconSize.sm,
              tone: IconTone.inherit,
            ),
          ),
        ),
        child: InputGroupInput(placeholder: 'Search...'),
      ),
      SizedBox(height: space(4)),
      StyledText('Text addon: currency prefix', TextStyles.section),
      SizedBox(height: space(2)),
      InputGroup(
        startAddon: InputGroupAddon(
          align: InputGroupAlign.start,
          child: InputGroupText('USD'),
        ),
        child: InputGroupInput(placeholder: '0.00'),
      ),
      SizedBox(height: space(4)),
      StyledText('Kbd addon: keyboard shortcut', TextStyles.section),
      SizedBox(height: space(2)),
      InputGroup(
        endAddon: InputGroupAddon(
          align: InputGroupAlign.end,
          child: const Kbd('⌘K'),
        ),
        child: InputGroupInput(placeholder: 'Quick search'),
      ),
      SizedBox(height: space(4)),
      StyledText('Spinner addon: loading state', TextStyles.section),
      SizedBox(height: space(2)),
      InputGroup(
        endAddon: InputGroupAddon(
          align: InputGroupAlign.end,
          child: Spinner(size: Icon.pxFor(IconSize.sm)),
        ),
        enabled: false,
        child: InputGroupInput(placeholder: 'Checking availability...'),
      ),
    ],
  );
}

class _RtlSpecimen extends StatelessWidget {
  const _RtlSpecimen();

  @override
  Widget build(BuildContext context) => const Directionality(
    textDirection: TextDirection.rtl,
    child: SizedBox(
      width: 260,
      child: InputGroup(
        startAddon: InputGroupAddon(
          align: InputGroupAlign.start,
          child: InputGroupText('بحث'),
        ),
        child: InputGroupInput(placeholder: 'ابحث هنا'),
      ),
    ),
  );
}

/* ── Disclosure content ─────────────────────────────────────────────────── */

const String _previewCode = '''InputGroup(
  endAddon: InputGroupAddon(
    align: InputGroupAlign.end,
    holdsButton: true,
    child: InputGroupButton(
      label: 'Show password',
      onPressed: () {},
      child: const Icon(IconGlyph.eye, size: IconSize.sm),
    ),
  ),
  child: InputGroupInput(
    placeholder: 'Enter password',
    obscureText: true,
  ),
)''';

const String _usageCode = '''InputGroup(
  child: InputGroupInput(
    placeholder: 'https://',
  ),
  startAddon: InputGroupAddon(
    align: InputGroupAlign.start,
    child: InputGroupText('https://'),
  ),
)''';

const String _compositionCode = '''InputGroup
├── startAddon: InputGroupAddon (align: start)
│   └── Icon / InputGroupText / InputGroupButton
├── child: InputGroupInput
└── endAddon: InputGroupAddon (align: end)
    └── Icon / InputGroupText / InputGroupButton''';

const String _positionCode = '''InputGroup(
  startAddon: InputGroupAddon(
    align: InputGroupAlign.start,
    child: InputGroupText('https://'),
  ),
  child: InputGroupInput(placeholder: 'example.com'),
)''';

const String _contentCode = '''InputGroup(
  startAddon: InputGroupAddon(
    align: InputGroupAlign.start,
    child: const Icon(IconGlyph.search, size: IconSize.md),
  ),
  endAddon: InputGroupAddon(
    align: InputGroupAlign.end,
    holdsButton: true,
    child: InputGroupButton(
      label: 'Clear',
      onPressed: () {},
      child: const Icon(IconGlyph.x, size: IconSize.sm),
    ),
  ),
  child: InputGroupInput(placeholder: 'Search...'),
)''';

const String _dropdownAddonCode = '''InputGroup(
  endAddon: InputGroupAddon(
    align: InputGroupAlign.end,
    holdsButton: true,
    child: DropdownMenu(
      // ...trigger and items
    ),
  ),
  child: InputGroupInput(placeholder: 'Filter...'),
)''';

const String _customInputCode = '''InputGroup(
  // Any widget is legal here, not only InputGroupInput. It must match
  // the group's own 40px height and padding tokens itself.
  child: MyCustomControl(),
)''';

const String _rtlCode = '''Directionality(
  textDirection: TextDirection.rtl,
  child: InputGroup(
    startAddon: InputGroupAddon(
      align: InputGroupAlign.start,
      child: InputGroupText('بحث'),
    ),
    child: InputGroupInput(placeholder: 'ابحث هنا'),
  ),
)''';

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      DocsAnchor(
        id: 'api-elinputgroup',
        child: const DocsApiTable(title: 'InputGroup', facts: _inputGroupFacts),
      ),
      SizedBox(height: space(6)),
      DocsAnchor(
        id: 'api-elinputgroupinput',
        child: const DocsApiTable(
          title: 'InputGroupInput',
          facts: _inputGroupInputFacts,
        ),
      ),
      SizedBox(height: space(6)),
      DocsAnchor(
        id: 'api-elinputgroupaddon',
        child: const DocsApiTable(title: 'InputGroupAddon', facts: _addonFacts),
      ),
      SizedBox(height: space(6)),
      DocsAnchor(
        id: 'api-elinputgrouptext',
        child: const DocsApiTable(title: 'InputGroupText', facts: _textFacts),
      ),
      SizedBox(height: space(6)),
      DocsAnchor(
        id: 'api-elinputgroupbutton',
        child: const DocsApiTable(
          title: 'InputGroupButton',
          facts: _buttonFacts,
        ),
      ),
      SizedBox(height: space(6)),
      DocsAnchor(
        id: 'api-elinputgroupalign',
        child: const DocsApiTable(title: 'InputGroupAlign', facts: _alignFacts),
      ),
      SizedBox(height: space(6)),
      DocsAnchor(
        id: 'api-elinputgroupbuttonsize',
        child: const DocsApiTable(
          title: 'InputGroupButtonSize',
          facts: _buttonSizeFacts,
        ),
      ),
    ],
  );
}

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Semantic role: Semantics(container: true) wraps the whole pill '
            '(role="group"). The control inside reads its own label through '
            'FieldScope, or its own label/placeholder when standalone.',
        'InputGroupAddon is itself Semantics(container: true) '
            '(role="group"). Tapping anywhere in an addon that is not a '
            'button focuses the control: a click handler on the addon\'s own '
            'padding, not just its glyph.',
        'InputGroupButton: with label given, it REPLACES the child\'s '
            'name (button: true, label:); toggled maps to Semantics.toggled '
            '(aria-pressed) for a real stateful control like the password '
            'toggle above, not a decorative icon.',
        'Focus behavior: focusNode defaults to the enclosing FieldScope\'s '
            'node, so a form\'s focus-on-error lands inside the group; only '
            'owns a node of its own when there is no field above it. '
            '_focusWithin tracks descendant focus (a non-focusable Focus '
            'node with canRequestFocus: false) to drive the border/ring the '
            'same way :focus-within does in CSS. See Keyboard below for how '
            'a caller actually moves focus into and out of the pill.',
        'Touch target: the group is 40px tall, 16px horizontally padded on '
            'a side with no addon. InputGroupButton is 24px tall: below '
            'the platform\'s usual 44px recommendation, matching the '
            'reference\'s own dense affordance.',
        'Non-colour signals: invalid is shown as a destructive border AND '
            'ring, never the ring alone.',
      ]);
}

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'InputGroupInput is a Input(bare: true) underneath: it accepts '
            'the same native EditableText keyboard behaviour as a bare '
            'Input does, typing, arrow-key caret movement, Home/End, '
            'Backspace/Delete, and Enter fires onSubmitted.',
        'Tab order: input_group.dart wires no FocusTraversalPolicy of its '
            'own. Tab and Shift+Tab walk whatever order the enclosing page '
            'already declares; the group\'s control participates through '
            'its own (or the enclosing FieldScope\'s) focus node.',
        'DOCUMENTED GAP: InputGroupButton wires no onKeyEvent handler. '
            'Its press feedback comes from Press, which wraps a bare '
            'GestureDetector.onTap and reacts to no key at all — unlike '
            'Button, whose own _onKey answers Enter, NumpadEnter, and '
            'Space. A focused addon button (the password-visibility toggle '
            'above, for instance) is reachable by Tab, because '
            'canRequestFocus tracks _enabled, but pressing Enter or Space '
            'on it does nothing: only a pointer tap activates onPressed.',
        'Focus-within tracking (the border/ring the whole pill shows while '
            'any descendant is focused) is driven by a non-focusable '
            'Focus(canRequestFocus: false) node watching its descendants, '
            'not by a key handler: it reacts to focus, not to a keypress.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'No breakpoint branching in input_group.dart: BuildContext width is '
            'never read for a layout decision. The pill renders the same at '
            '390px and 1440px.',
        'Width is intrinsic to the content and the frame around it: the '
            'control is Expanded inside the group\'s Row, so it grows to '
            'fill whatever width the caller gives the group.',
        'Overflow: the group clips addons to its own height. A long addon '
            'label is not truncated by the group itself; the caller must '
            'constrain width.',
        'Platform parity: Android, iOS, Web, macOS, Windows, and Linux all '
            'render the same widget tree: no dart:io Platform branch '
            'anywhere in the file.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      _bullets(ThemeScope.of(context), <String>[
        'File: lib/src/components/ui/input_group.dart. No companion parts.',
        'Foundation imports: colors.dart, motion.dart, shadows.dart, '
            'spacing.dart (space()), theme.dart, typography.dart.',
        'Effect imports: effects/surface.dart (Surface: '
            'the pill\'s fill, border, and focus/invalid ring on both '
            'InputGroup and InputGroupButton).',
        'Component imports: button.dart (Button.withFocusRing, the '
            'shared ring-compositing helper), field.dart (FieldScope, for '
            'the enclosing-field fallback), input.dart (Input: '
            'InputGroupInput is a Input with bare: true and its own '
            'padding).',
        'Registry dependencies are resolved automatically by `elattar add '
            'input-group`: button, field, input, surface, '
            'press, source-foundation.',
      ]),
      SizedBox(height: space(2)),
      DocsLinkRow(
        links: const <DocsLink>[
          DocsLink(label: 'Button', route: '/components/button'),
          DocsLink(label: 'Field', route: '/components/field'),
          DocsLink(label: 'Input', route: '/components/input'),
          DocsLink(label: 'Surface', route: '/components/surface'),
          DocsLink(label: 'Press Motion', route: '/components/press'),
        ],
      ),
    ],
  );
}

class _ThemingContent extends StatelessWidget {
  const _ThemingContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Border: theme.input at rest, theme.ring while any descendant has '
            'focus. Invalid overrides both to theme.destructive, ORed with '
            'the enclosing FieldScope\'s own invalid flag.',
        'Ring: transparent at rest; theme.ring at 50% alpha on '
            'focus-within; theme.destructive at 20% (light) or 40% (dark) '
            'when invalid, matching InputOtp\'s own theme-split.',
        'Fill: always theme.card, never theme.background.',
        'Addons inherit text colour from theme.mutedForeground '
            '(DefaultTextStyle.merge), which a Icon at IconTone.inherit '
            'reads too.',
        'Disabled: opacity to 50% (has-disabled:opacity-50), five points '
            'weaker than a bare Input\'s own 45%: an addon button inside a '
            'disabled group still fades at the button\'s own 45%, so the two '
            'opacities multiply.',
        'No colour overrides on InputGroup itself: every value comes from '
            'ThemeScope.of(context). InputGroupButton.cancelPressFill is a '
            'behaviour flag, not a colour override.',
      ]);
}

Widget _bullets(ThemeTokens theme, List<String> lines) => ConstrainedBox(
  constraints: const BoxConstraints(maxWidth: LayoutWidths.prose),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      for (final String line in lines) ...<Widget>[
        StyledText('•  $line', TextStyles.small, color: theme.mutedForeground),
        SizedBox(height: space(2)),
      ],
    ],
  ),
);

const List<DocsApiFact> _inputGroupFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'child',
    type: 'Widget',
    description:
        'Required. The control, typically InputGroupInput. Takes '
        'whatever width the addons leave (Expanded).',
  ),
  DocsApiFact(
    name: 'startAddon',
    type: 'Widget?',
    description:
        'Optional. Defaults to null. The leading addon: text, icon, or '
        'button.',
  ),
  DocsApiFact(
    name: 'endAddon',
    type: 'Widget?',
    description:
        'Optional. Defaults to null. The trailing addon: text, icon, or '
        'button.',
  ),
  DocsApiFact(
    name: 'invalid',
    type: 'bool',
    description:
        'Optional. Defaults to false. ORed with the enclosing '
        'FieldScope\'s own invalid flag. Colors the border and ring '
        'theme.destructive.',
  ),
  DocsApiFact(
    name: 'enabled',
    type: 'bool',
    description:
        'Optional. Defaults to true. ANDed with the enclosing '
        'FieldScope\'s own enabled flag. Drops opacity to 50% and '
        'ignores pointer input when false.',
  ),
  DocsApiFact(
    name: 'focusNode',
    type: 'FocusNode?',
    description:
        'Optional. Defaults to null, which falls back to the enclosing '
        'FieldScope\'s node, or an owned node if there is neither.',
  ),
  DocsApiFact(
    name: 'InputGroup.height',
    type: 'static double',
    description: '40px (Input.height): the hard border-box height.',
  ),
  DocsApiFact(
    name: 'InputGroup.addonInset',
    type: 'static double',
    description: '16px: the addon\'s own horizontal padding on its side.',
  ),
  DocsApiFact(
    name: 'InputGroup.addonButtonPull',
    type: 'static double',
    description:
        '2px: negative margin subtracted from addonInset when the addon '
        'holds a button, clearing at 14px instead of 16.',
  ),
  DocsApiFact(
    name: 'InputGroup.clearance',
    type: 'static double',
    description:
        '8px: the control\'s own padding on a side an addon occupies, '
        'replacing the 16px pill clearance an addon already supplies.',
  ),
];

const List<DocsApiFact> _inputGroupInputFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'controller',
    type: 'TextEditingController?',
    description: 'Optional. Drives the field\'s value from outside.',
  ),
  DocsApiFact(
    name: 'initialValue',
    type: 'String?',
    description: 'Optional. Seeds the field on first build.',
  ),
  DocsApiFact(
    name: 'placeholder',
    type: 'String?',
    description: 'Optional. Hint text shown when the field is empty.',
  ),
  DocsApiFact(
    name: 'onChanged',
    type: 'ValueChanged<String>?',
    description: 'Optional. Fires as the user types.',
  ),
  DocsApiFact(
    name: 'onSubmitted',
    type: 'ValueChanged<String>?',
    description: 'Optional. Fires when the user submits (Return key).',
  ),
  DocsApiFact(
    name: 'readOnly',
    type: 'bool',
    description:
        'Optional. Defaults to false. Disables editing but allows '
        'selection.',
  ),
  DocsApiFact(
    name: 'obscureText',
    type: 'bool',
    description: 'Optional. Defaults to false. Password-field dots.',
  ),
  DocsApiFact(
    name: 'keyboardType',
    type: 'TextInputType?',
    description: 'Optional. The soft keyboard layout: number, email, etc.',
  ),
  DocsApiFact(
    name: 'autofillHints',
    type: 'List<String>?',
    description:
        'Optional. iOS/Android autofill hints: pass username, password, '
        'etc.',
  ),
  DocsApiFact(
    name: 'textSpec',
    type: 'TextStyleToken?',
    description: 'Optional. Overrides the type spec: defaults to body.',
  ),
  DocsApiFact(
    name: 'label',
    type: 'String?',
    description:
        'Optional. The field\'s accessible label, announced to screen '
        'readers.',
  ),
];

const List<DocsApiFact> _addonFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'child',
    type: 'Widget',
    description:
        'Required. The content: StyledText, Icon, or InputGroupButton.',
  ),
  DocsApiFact(
    name: 'align',
    type: 'InputGroupAlign',
    description:
        'Optional. Defaults to InputGroupAlign.start. Which side the '
        'addon occupies.',
  ),
  DocsApiFact(
    name: 'holdsButton',
    type: 'bool?',
    description:
        'Optional. Defaults to null, which infers true only when child '
        'is a InputGroupButton. State it explicitly to override the '
        'inference.',
  ),
  DocsApiFact(
    name: 'InputGroupAddon.insetY',
    type: 'static double',
    description:
        '6px: vertical padding inside the addon (h-auto inside a '
        'centred 40px row, so this only bites when content is taller '
        'than the pill\'s inner height).',
  ),
  DocsApiFact(
    name: 'InputGroupAddon.gap',
    type: 'static double',
    description:
        '8px: gap between an addon\'s own children, when it has more '
        'than one.',
  ),
];

const List<DocsApiFact> _textFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'text',
    type: 'String',
    description: 'Required. The label text.',
  ),
  DocsApiFact(
    name: 'spec',
    type: 'TextStyleToken?',
    description: 'Optional. Overrides the type spec: defaults to body.',
  ),
];

const List<DocsApiFact> _buttonFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'child',
    type: 'Widget',
    description: 'Required. An icon or text, rendered at 13px.',
  ),
  DocsApiFact(
    name: 'onPressed',
    type: 'VoidCallback?',
    description:
        'Optional. Defaults to null, which disables the button: 45% '
        'opacity, no pointer events, no focus.',
  ),
  DocsApiFact(
    name: 'label',
    type: 'String?',
    description:
        'Optional. Defaults to null. The accessible name; required in '
        'practice for an icon-only button, but not enforced by the '
        'constructor.',
  ),
  DocsApiFact(
    name: 'toggled',
    type: 'bool?',
    description:
        'Optional. Defaults to null. Maps to Semantics.toggled '
        '(aria-pressed) for a real stateful control like a visibility '
        'toggle.',
  ),
  DocsApiFact(
    name: 'focusNode',
    type: 'FocusNode?',
    description: 'Optional. The button\'s own focus node.',
  ),
  DocsApiFact(
    name: 'size',
    type: 'InputGroupButtonSize',
    description:
        'Optional. Defaults to InputGroupButtonSize.xs. See the '
        'InputGroupButtonSize table below.',
  ),
  DocsApiFact(
    name: 'cancelPressFill',
    type: 'bool',
    description:
        'Optional. Defaults to false. When true, a press cancels the '
        'ghost hover fill instead of deepening it (data-pressed:'
        'bg-transparent in the reference, the combobox trigger\'s own '
        'behaviour), and only the press-scale still moves.',
  ),
  DocsApiFact(
    name: 'InputGroupButton.height',
    type: 'static double',
    description: '24px: the hard border-box height, both size rungs.',
  ),
  DocsApiFact(
    name: 'InputGroupButton.paddingX',
    type: 'static double',
    description: '6px: horizontal padding on the xs rung.',
  ),
  DocsApiFact(
    name: 'InputGroupButton.paddingXFor',
    type: 'static double Function(InputGroupButtonSize)',
    description:
        'The rung\'s horizontal padding: 6px for xs, 0 for iconXs '
        '(which centres the glyph in a square instead).',
  ),
  DocsApiFact(
    name: 'InputGroupButton.gap',
    type: 'static double',
    description:
        '4px. Exposed rather than applied: this widget takes one child, '
        'so a button with both an icon and a label composes its own row.',
  ),
];

const List<DocsApiFact> _alignFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'start',
    type: 'enum value',
    description: 'inline-start. The addon leads the control.',
  ),
  DocsApiFact(
    name: 'end',
    type: 'enum value',
    description: 'inline-end. The addon trails the control.',
  ),
];

const List<DocsApiFact> _buttonSizeFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'xs',
    type: 'enum value',
    description:
        'The default rung: 24px tall, as wide as its content plus 6px '
        'padding. Forces a 14px icon child. The inputs page\'s own '
        'password toggle wears this rung.',
  ),
  DocsApiFact(
    name: 'iconXs',
    type: 'enum value',
    description:
        'A 24×24 square with no padding at all. Forces a 16px icon '
        'child: one rung larger than xs, on a button that is narrower.',
  ),
];

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Rest',
    treatment: 'Border theme.input, ring transparent. Fill theme.card.',
    userSignal: 'Plain gray pill.',
  ),
  DocsStateFact(
    state: 'Focus-within',
    treatment:
        'Border springs to theme.ring, ring to 50% alpha, over the '
        'framework\'s transition-default duration. Tracked by a '
        'non-focusable Focus(canRequestFocus: false) node watching its '
        'descendants, the :focus-within equivalent.',
    userSignal: 'A blue outline around the whole pill, not just the field.',
  ),
  DocsStateFact(
    state: 'Invalid',
    treatment:
        'Border and ring both go destructive: full theme.destructive '
        'border, ring at 20% (light) or 40% (dark) alpha. Border and '
        'ring change together: never just the ring.',
    userSignal: 'A red-bordered pill with a red ring.',
  ),
  DocsStateFact(
    state: 'Disabled',
    treatment:
        'Opacity drops to 50% (has-disabled:opacity-50); IgnorePointer '
        'kills input. An addon button inside keeps its own 45% opacity, '
        'so the two multiply.',
    userSignal: 'Faded pill, no response to taps.',
  ),
  DocsStateFact(
    state: 'Addon button: hover / pressed / focus',
    treatment:
        'InputGroupButton is its own ghost surface: transparent at '
        'rest, theme.secondary on hover, theme.muted while pressed '
        '(pressed outranks hover), theme.ring border on focus. Colours '
        'spring over the framework\'s spring curve; press/focus timing '
        'uses MotionDurations.tick.',
    userSignal: 'A lit 24px chip under the pointer or keyboard focus.',
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment:
        'Every TweenAnimationBuilder duration routes through '
        'effectiveMotionDuration, which is Duration.zero under '
        'MediaQuery.disableAnimations.',
    userSignal: 'Border and ring hard-cut instead of springing.',
  ),
];
