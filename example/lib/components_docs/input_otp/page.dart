/// Public documentation page for the `input_otp` component.
///
/// **Re-housed onto the documentation kit** (matching
/// `components_docs/button/page.dart`'s own reference shape): the page is
/// now a `ComponentDocSpec` declaration plus a ten-line widget handing it to
/// `DocsLayout`, rather than a hand-composed `_Article`. Every specimen and
/// every code string below moved across unchanged from the previous
/// hand-composed page; nothing here was rewritten or reworded. Two changes
/// are new: the live preview is promoted to its own `Preview`
/// `ShowcaseSection` (it used to render ahead of any heading, with no rail
/// entry of its own), and a `Keyboard` disclosure is added between
/// Accessibility and Responsive — this page had none before, only a merged
/// "Accessibility and keyboard behavior" heading. The keyboard-specific
/// bullets (focus/tab behaviour, typing, and the paste gap) moved there
/// unchanged; nothing new was invented, only regrouped and, where the old
/// heading's own name promised a "keyboard behavior" that was never actually
/// isolated, now it is.
///
/// **Split from a merged page.** Phase F/J's original `input_group` route
/// documented three unrelated components on one page: `InputGroup`,
/// `ButtonGroup`, and `InputOtp`. This page covers `InputOtp` alone;
/// `InputGroup` lives at `../input_group/page.dart` and `ButtonGroup` at
/// `../button_group/page.dart`, each its own route.
///
/// **Against shadcn's own page**
/// (https://ui.shadcn.com/docs/components/base/input-otp, fetched fresh):
/// its own `<h2>`s are Input OTP, About, Installation, Usage, Composition,
/// Pattern, Separator, Disabled, Controlled, Invalid, Four Digits,
/// Alphanumeric, Form, RTL, API Reference. Composition, Disabled,
/// Controlled, Invalid, and RTL keep their own names. Four Digits becomes
/// Four digits (sentence case). Form becomes Verification form. Pattern and
/// Separator are merged into Groups and separators: `groups` is the one prop
/// that drives both where a slot boundary falls and where a
/// `InputOtpSeparator` is inserted.
///
/// **Skipped, honestly.** Two of shadcn's own sections describe a
/// capability this port does not have: Pattern's character-restriction half
/// (`InputOtp` hardcodes `TextInputType.number` and a
/// `LengthLimitingTextInputFormatter`, no pattern prop), and Alphanumeric
/// (nothing to swap with no pattern prop). **About**, shadcn's own lead-in
/// prose before Installation, is not a structural section on any page in
/// this corpus: [ComponentDocEntry.description] fills that role.
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

final ComponentDocSpec inputOtpDocSpec = ComponentDocSpec(
  name: 'input-otp',
  title: inputOtpDoc.title,
  description: inputOtpDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'Six slots grouped three and three, focus advancing on each '
          'digit typed.',
      specimen: _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          '`elattar add input-otp` installs the component and its declared '
          'dependency closure. No registry/components/input_otp.json '
          'exists yet: copy lib/src/components/ui/input_otp.dart manually '
          'until it does.',
      command: inputOtpDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: inputOtpDoc.sourcePath,
          title: '1. Copy the source',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// No registry manifest yet: copy lib/src/components/ui/'
              'input_otp.dart into lib/components/ui/ in your project.',
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'The smallest correct import and construction. Every example '
          'below only changes named arguments on top of this.',
      code: _usageCode,
    ),
    SnippetSection(
      id: 'composition',
      title: 'Composition',
      description: 'The widget hierarchy InputOtp builds on.',
      code: _compositionCode,
    ),
    ShowcaseSection(
      id: 'groups',
      title: 'Groups and separators',
      description:
          'groups drives both the slot count per group and where a '
          'InputOtpSeparator is inserted, one between every pair. It '
          'must sum to maxLength.',
      specimen: const _GroupsSpecimen(),
      code: _groupsCode,
      label: 'Groups and separators specimen view',
    ),
    ShowcaseSection(
      id: 'disabled',
      title: 'Disabled',
      description: 'enabled: false fades the strip and stops accepting input.',
      specimen: const _DisabledSpecimen(),
      code: _disabledCode,
      label: 'Disabled specimen view',
    ),
    SnippetSection(
      id: 'controlled',
      title: 'Controlled',
      description:
          'The live specimen above is already this shape, the parent owns '
          'the value through onChanged, not through a controller. Pass '
          'controller instead to drive the value imperatively.',
      code: _controlledCode,
    ),
    ShowcaseSection(
      id: 'invalid',
      title: 'Invalid',
      description:
          'invalid: true colors the slot borders and the group\'s ring '
          'destructive. See States below for the full color values.',
      specimen: const _InvalidSpecimen(),
      code: _invalidCode,
      label: 'Invalid specimen view',
    ),
    ShowcaseSection(
      id: 'four-digits',
      title: 'Four digits',
      description: 'A PIN-length field: maxLength: 4, groups: [4], no split.',
      specimen: const _FourDigitsSpecimen(),
      code: _fourDigitsCode,
      label: 'Four digits specimen view',
    ),
    ShowcaseSection(
      id: 'form',
      title: 'Verification form',
      description:
          'InputOtp sitting in its usual home: a label, the field, and a '
          'submit action, rather than the isolated specimen above.',
      specimen: _OtpFormComposition(),
      code: _formCode,
      label: 'Verification form specimen view',
    ),
    ShowcaseSection(
      id: 'rtl',
      title: 'RTL',
      description:
          'The label reads right-to-left, the digit strip itself stays '
          'left-to-right, a verification code is read as a number, not as '
          'directional text.',
      specimen: const _RtlOtp(),
      code: _rtlCode,
      label: 'RTL specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every constructor parameter each exported class declares, read '
          'directly off lib/src/components/ui/input_otp.dart: one table per '
          'class.',
      children: const <DocsTocEntry>[
        DocsTocEntry(title: 'InputOtp', anchor: 'api-elinputotp'),
        DocsTocEntry(title: 'InputOtpSlot', anchor: 'api-elinputotpslot'),
        DocsTocEntry(
          title: 'InputOtpSeparator',
          anchor: 'api-elinputotpseparator',
        ),
      ],
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'Read straight off _DsInputOtpState.build and '
          'InputOtpSlot.build, not inferred.',
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
          'behavior" heading. Every claim here already lived in that '
          'heading\'s own bullets, just regrouped under its own name.',
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
            value: inputOtpDoc.sourcePath,
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
            value: 'example/test/components_docs/input_otp_test.dart',
            description:
                'Covers this page: API tables, live specimens, the bulk '
                'text-entry path, the double-semantics defect, and theme '
                'coverage.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/input_otp/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class InputOtpDocPage extends StatelessWidget {
  const InputOtpDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: inputOtpDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / BASE',
      title: inputOtpDoc.title,
      description: inputOtpDoc.description,
    ),
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Components'),
      BreadcrumbEntry.page('Input OTP'),
    ],
    toc: inputOtpDocSpec.toc,
    previous: const DocsPageLink(
      title: 'Button group',
      route: '/components/button_group',
    ),
    next: const DocsPageLink(
      title: 'Native select',
      route: '/components/native_select',
    ),
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('input-otp-doc-article'),
      child: ComponentDocPage(spec: inputOtpDocSpec, header: false),
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
  String _code = '';

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        InputOtp(
          key: const ValueKey<String>('input-otp-doc-live'),
          onChanged: (String code) => setState(() => _code = code),
        ),
        SizedBox(height: space(3)),
        StyledText(
          _code.length == 6 ? 'Complete: $_code' : 'Waiting for code...',
          key: const ValueKey<String>('input-otp-doc-status'),
          TextStyles.small,
          color: theme.mutedForeground,
        ),
      ],
    );
  }
}

class _GroupsSpecimen extends StatelessWidget {
  const _GroupsSpecimen();

  @override
  Widget build(BuildContext context) =>
      Center(child: InputOtp(groups: const <int>[2, 2, 2]));
}

class _DisabledSpecimen extends StatelessWidget {
  const _DisabledSpecimen();

  @override
  Widget build(BuildContext context) =>
      Center(child: InputOtp(enabled: false, initialValue: '123'));
}

class _InvalidSpecimen extends StatelessWidget {
  const _InvalidSpecimen();

  @override
  Widget build(BuildContext context) =>
      Center(child: InputOtp(invalid: true, initialValue: '123'));
}

class _FourDigitsSpecimen extends StatelessWidget {
  const _FourDigitsSpecimen();

  @override
  Widget build(BuildContext context) =>
      Center(child: InputOtp(maxLength: 4, groups: const <int>[4]));
}

class _RtlOtp extends StatelessWidget {
  const _RtlOtp();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          StyledText(
            'أدخل رمز التحقق',
            TextStyles.section,
            color: theme.foreground,
          ),
          SizedBox(height: space(3)),
          Center(child: InputOtp()),
        ],
      ),
    );
  }
}

class _OtpFormComposition extends StatelessWidget {
  const _OtpFormComposition();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 320),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          StyledText(
            'Verify your email',
            TextStyles.h4,
            color: theme.foreground,
          ),
          SizedBox(height: space(2)),
          StyledText(
            'Enter the 6-digit code sent to ayoub@example.com.',
            TextStyles.small,
            color: theme.mutedForeground,
          ),
          SizedBox(height: space(5)),
          Center(child: InputOtp()),
          SizedBox(height: space(5)),
          Button(
            expanded: true,
            onPressed: () {},
            child: StyledText('Verify', TextStyles.buttonLabel),
          ),
          SizedBox(height: space(3)),
          Center(
            child: Button(
              variant: ButtonVariant.link,
              onPressed: () {},
              child: StyledText('Resend code', TextStyles.buttonLabel),
            ),
          ),
        ],
      ),
    );
  }
}

/* ── Disclosure content ─────────────────────────────────────────────────── */

const String _previewCode = '''InputOtp(
  onChanged: (String code) {
    if (code.length == 6) {
      // Code complete
    }
  },
)''';

const String _usageCode = '''InputOtp(
  maxLength: 6,
  groups: const <int>[3, 3],
  onChanged: (String code) {
    if (code.length == 6) {
      // Code complete
    }
  },
)''';

const String _compositionCode = '''InputOtp
├── InputOtpSlot (× groups[0])
├── InputOtpSeparator
├── InputOtpSlot (× groups[1])
└── ... one InputOtpSeparator between every pair of groups''';

const String _groupsCode = 'InputOtp(groups: const <int>[2, 2, 2])';

const String _disabledCode = "InputOtp(enabled: false, initialValue: '123')";

const String _controlledCode = '''final TextEditingController controller =
    TextEditingController(text: '123');

InputOtp(
  controller: controller,
  onChanged: (String code) {
    // read controller.text at any time
  },
)''';

const String _invalidCode = "InputOtp(invalid: true, initialValue: '123')";

const String _fourDigitsCode = 'InputOtp(maxLength: 4, groups: const <int>[4])';

const String _formCode = '''Column(
  children: [
    Text('Verify your email'),
    Text('Enter the 6-digit code sent to ayoub@example.com.'),
    InputOtp(),
    Button(
      expanded: true,
      onPressed: verify,
      child: const Text('Verify'),
    ),
    Button(
      variant: ButtonVariant.link,
      onPressed: resend,
      child: const Text('Resend code'),
    ),
  ],
)''';

const String _rtlCode = '''Directionality(
  textDirection: TextDirection.rtl,
  child: Column(
    children: [
      Text('أدخل رمز التحقق'),
      InputOtp(),
    ],
  ),
)''';

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      DocsAnchor(
        id: 'api-elinputotp',
        child: const DocsApiTable(title: 'InputOtp', facts: _inputOtpFacts),
      ),
      SizedBox(height: space(6)),
      DocsAnchor(
        id: 'api-elinputotpslot',
        child: const DocsApiTable(title: 'InputOtpSlot', facts: _slotFacts),
      ),
      SizedBox(height: space(6)),
      DocsAnchor(
        id: 'api-elinputotpseparator',
        child: const DocsApiTable(
          title: 'InputOtpSeparator',
          facts: <DocsApiFact>[],
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
        'InputOtp publishes ONE Semantics(textField: true) node over the '
            'whole strip, matching the reference\'s single real <input>. '
            'Known screen-reader defect: the hidden EditableText inside '
            'does not exclude its own semantics, so the strip actually '
            'publishes TWO textField nodes and the field may be announced '
            'twice. Documented, not fixed, in the source.',
        'The six painted InputOtpSlot boxes contribute no semantics of '
            'their own: they sit under an IgnorePointer whose '
            'ignoringSemantics follows ignoring (true), so a screen reader '
            'never sees them as six separate fields.',
        'Screen-reader announcements: no live region. Completion (all six '
            'digits entered) does not announce on its own; wire that at '
            'the call site if needed.',
        'Non-colour signals: invalid renders SemanticsValidationResult'
            '.invalid on the field node, alongside the destructive border '
            'and ring, not colour alone.',
        'Touch target: each of the six slots is 32px × 32px, the whole '
            'strip is one 32px-tall hit target (the hidden EditableText '
            'covers it edge to edge), below the platform\'s usual 44px '
            'recommendation, matching the reference\'s own dense affordance.',
      ]);
}

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Focus behavior: the strip takes focus as one field '
            '(EditableText.requestKeyboard on tap anywhere in the strip). '
            'Typing and backspace work as expected; Tab moves to the next '
            'field on the page, not between slots (there are no separate '
            'focusable slots to move between).',
        'Selection math, not a key handler: the active slot is derived '
            'from the hidden controller\'s selection (baseOffset clamped '
            'to min(length, maxLength - 1)), so typing, arrow-key caret '
            'movement, and backspace all just move that selection the way '
            'EditableText already does; input_otp.dart wires no '
            'onKeyEvent of its own.',
        'Paste is not supported: enableInteractiveSelection: false on the '
            'hidden EditableText disables paste (Ctrl+V / Cmd+V and '
            'long-press paste alike). Users can type or autofill a code '
            '(AutofillHints.oneTimeCode is wired, so an SMS-delivered code '
            'can fill the field without a keystroke), but cannot paste '
            'one. A real limitation, documented as the tradeoff for the '
            'simplified single-selection focus model.',
        'Numeric keyboard only: keyboardType: TextInputType.number and a '
            'LengthLimitingTextInputFormatter(maxLength) together mean the '
            'soft keyboard offers digits only and typing past maxLength '
            'is a no-op, not a truncation the caller has to guard against.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'No breakpoint branching in input_otp.dart: BuildContext width is '
            'never read for a layout decision.',
        'The strip is always the sum of (slotSize × slot count) plus '
            '(separatorWidth × separator count): 208px at the default '
            'shape (6 slots, 1 separator). On narrow screens, constrain '
            'the surrounding layout if that is too wide.',
        'FieldVisibility wraps the field (USER-ORDERED MOBILE '
            'ADAPTATION): a one-time code arrives while the soft keyboard '
            'is already open, so this is the one family member that could '
            'least afford to skip the keyboard-avoidance hook.',
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
        'File: lib/src/components/ui/input_otp.dart. No companion parts.',
        'Dart imports: dart:math (the selection-expansion arithmetic that '
            'decides which slot is active).',
        'Flutter imports: package:flutter/semantics.dart '
            '(SemanticsValidationResult), package:flutter/services.dart '
            '(AutofillHints, LengthLimitingTextInputFormatter), '
            'package:flutter/widgets.dart (EditableText).',
        'Foundation imports: colors.dart, motion.dart, shadows.dart, '
            'spacing.dart (space()), theme.dart, typography.dart.',
        'Effect imports: effects/surface.dart (Surface: '
            'slot borders, the active slot\'s ring, and the group\'s '
            'invalid ring).',
        'Motion imports: motion/keyframes.dart (KeyframePlayer: the '
            'fake caret\'s 1000ms blink).',
        'Component imports: button.dart (Button.withFocusRing), '
            'field.dart (FieldScope), icon.dart and icon_paths.dart '
            '(Icon: the separator glyph), input.dart '
            '(FieldVisibility, the mobile keyboard-avoidance hook).',
        'Registry dependencies are resolved automatically by `elattar add '
            'input-otp`.',
      ]),
      SizedBox(height: space(2)),
      DocsLinkRow(
        links: const <DocsLink>[
          DocsLink(label: 'Button', route: '/components/button'),
          DocsLink(label: 'Field', route: '/components/field'),
          DocsLink(label: 'Icon', route: '/components/icon'),
          DocsLink(label: 'Input', route: '/components/input'),
          DocsLink(label: 'Keyframes', route: '/components/keyframes'),
          DocsLink(label: 'Surface', route: '/components/surface'),
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
        'Slot border: theme.input at rest, theme.ring while active. '
            'Invalid keeps the destructive border even while active; only '
            'the ring colour changes then.',
        'Slot fill: dark mode only, theme.input at 30% alpha '
            '(dark:bg-input/30). Light mode paints no fill at all, the '
            'boxes read only by their hairlines.',
        'Active ring: theme.ring at 50% alpha; invalid overrides to '
            'theme.destructive at 20% (light) or 40% (dark), matching '
            'InputGroup\'s own theme-split.',
        'Caret and digit text: theme.foreground for both. The digit is '
            'TextStyles.bodySmall (Inter, not mono) — DOCUMENTED DRIFT: '
            'the reference\'s section description says "using the '
            'numerical mono foundation," but InputOTPSlot itself carries '
            'no mono class; only the invisible overlay is monospace, and '
            'it paints nothing.',
        'No colour overrides: every value comes from ThemeScope.of(context).',
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

const List<DocsApiFact> _inputOtpFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'maxLength',
    type: 'int',
    description: 'Optional. Defaults to 6. The digit count.',
  ),
  DocsApiFact(
    name: 'groups',
    type: 'List<int>',
    description:
        'Optional. Defaults to [3, 3]. How slots are grouped, with a '
        'InputOtpSeparator between each pair. Must sum to maxLength.',
  ),
  DocsApiFact(
    name: 'controller',
    type: 'TextEditingController?',
    description:
        'Optional. Drives the field\'s value from outside. Mutually '
        'exclusive with initialValue.',
  ),
  DocsApiFact(
    name: 'initialValue',
    type: 'String?',
    description:
        'Optional. Seeds the field on first build. Mutually exclusive '
        'with controller.',
  ),
  DocsApiFact(
    name: 'focusNode',
    type: 'FocusNode?',
    description:
        'Optional. Defaults to null, which falls back to the enclosing '
        'FieldScope\'s node, or an owned node if there is neither.',
  ),
  DocsApiFact(
    name: 'onChanged',
    type: 'ValueChanged<String>?',
    description:
        'Optional. Fires each time the value changes, including when '
        'reaching maxLength.',
  ),
  DocsApiFact(
    name: 'enabled',
    type: 'bool',
    description:
        'Optional. Defaults to true. ANDed with the enclosing '
        'FieldScope\'s own enabled flag. Fades to 50% opacity and '
        'stops accepting input when false.',
  ),
  DocsApiFact(
    name: 'invalid',
    type: 'bool',
    description:
        'Optional. Defaults to false. ORed with the enclosing '
        'FieldScope\'s own invalid flag. Colors the slot borders and '
        'ring destructive.',
  ),
  DocsApiFact(
    name: 'label',
    type: 'String?',
    description:
        'Optional. The field\'s accessible label, announced to screen '
        'readers. Falls back to the enclosing FieldScope\'s label.',
  ),
  DocsApiFact(
    name: 'InputOtp.slotSize',
    type: 'static double',
    description: '32px: the height and width of each slot.',
  ),
  DocsApiFact(
    name: 'InputOtp.separatorWidth',
    type: 'static double',
    description: '16px: the width of each separator (IconSize.md).',
  ),
  DocsApiFact(
    name: 'InputOtp.widthFor',
    type: 'static double Function(List<int>)',
    description:
        'The total strip width for a groups list: (slotSize × total '
        'slots) plus (separatorWidth × (groups.length − 1)).',
  ),
];

const List<DocsApiFact> _slotFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'char',
    type: 'String?',
    description: 'Optional. Defaults to null. The character in this slot.',
  ),
  DocsApiFact(
    name: 'active',
    type: 'bool',
    description:
        'Optional. Defaults to false. True when the caret is on this '
        'slot.',
  ),
  DocsApiFact(
    name: 'invalid',
    type: 'bool',
    description:
        'Optional. Defaults to false. Drawn with destructive border '
        'and ring.',
  ),
  DocsApiFact(
    name: 'first',
    type: 'bool',
    description:
        'Optional. Defaults to false. True for the first slot in the '
        'strip: takes the left border and left corners.',
  ),
  DocsApiFact(
    name: 'last',
    type: 'bool',
    description:
        'Optional. Defaults to false. True for the last slot in the '
        'strip: takes the right corners.',
  ),
];

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Rest',
    treatment:
        'Empty slot: theme.input border. Filled slot: same border, the '
        'character painted in theme.foreground.',
    userSignal: 'Six plain boxes, digits appearing as typed.',
  ),
  DocsStateFact(
    state: 'Active (focus)',
    treatment:
        'The slot the selection is on: border theme.ring, ring at 50% '
        'alpha. An empty active slot also shows the fake caret, a '
        '1000ms hard-cut blink (500ms on, 500ms off, no fade) — the '
        'real caret is caret-color: transparent on the hidden field.',
    userSignal: 'A ringed box with a blinking bar, on the next empty slot.',
  ),
  DocsStateFact(
    state: 'Invalid',
    treatment:
        'Every slot\'s border goes theme.destructive, active or not. '
        'The group also gets a destructive ring at 20% (light) or 40% '
        '(dark) alpha, painted around the group\'s own rounded rect.',
    userSignal: 'All six boxes outlined red, with a red halo.',
  ),
  DocsStateFact(
    state: 'Disabled',
    treatment: 'Opacity drops to 50%; IgnorePointer stops all input.',
    userSignal: 'A faded strip that ignores taps and typing.',
  ),
  DocsStateFact(
    state: 'Complete',
    treatment:
        'No distinct visual state: the strip looks like Rest with all '
        'six slots filled. onChanged fires with the full string; the '
        'call site decides what "complete" means.',
    userSignal:
        'All six boxes filled, caret gone (no active slot past '
        'the last character until the selection is moved back).',
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment:
        'The fake caret uses KeyframeFill.none, which freezes the '
        'player at its resting stop — opacity 1, steady — under '
        'MediaQuery.disableAnimations, since anim-caret declares no '
        'fill-mode of its own.',
    userSignal: 'A solid, unblinking caret instead of one that pulses.',
  ),
];
