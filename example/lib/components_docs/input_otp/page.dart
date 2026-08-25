/// Public documentation page for the `input_otp` component.
///
/// **Split from a merged page.** Phase F/J's original `input_group` route
/// documented three unrelated components on one page: `ElInputGroup`,
/// `ElButtonGroup`, and `ElInputOtp`. This page now covers `ElInputOtp`
/// alone; `ElInputGroup` lives at `../input_group/page.dart` and
/// `ElButtonGroup` at `../button_group/page.dart`, each its own route.
///
/// **Shape.** Matches `components_docs/button/page.dart`'s own reference
/// shape: an unheaded live specimen above the first heading, Installation,
/// Usage, then this component's own sections, API Reference last of the
/// shadcn-named sections (one prop table per exported class, nested under
/// it), then the fixed six: States, Accessibility, Responsive, Dependencies,
/// Theming, Source.
///
/// **Against shadcn's own page**
/// (https://ui.shadcn.com/docs/components/base/input-otp, fetched fresh):
/// its own `<h2>`s are Input OTP, About, Installation, Usage, Composition,
/// Pattern, Separator, Disabled, Controlled, Invalid, Four Digits,
/// Alphanumeric, Form, RTL, API Reference (flat, no nested `<h3>`s besides
/// API Reference's own table).
///
/// Composition, Disabled, Controlled, Invalid, and RTL keep their own
/// names. Four Digits becomes Four digits (sentence case, matching this
/// corpus's own heading style). Form becomes Verification form, the shape
/// every other page's problem-named section already uses. Pattern and
/// Separator are merged into one section, Groups and separators: `groups`
/// is the one prop that drives both where a slot boundary falls and where a
/// `ElInputOtpSeparator` is inserted, so the two shadcn sections describe
/// one mechanism here, not two.
///
/// **Skipped, honestly.** Two of shadcn's own sections describe a
/// capability this port does not have:
/// * Pattern (the *pattern-matching* half of it, not the *grouping* half
///   folded in above): shadcn's own section is about restricting which
///   characters are accepted via a regex (`REGEXP_ONLY_DIGITS`, etc.).
///   `ElInputOtp` hardcodes `TextInputType.number` and a
///   `LengthLimitingTextInputFormatter`: there is no pattern prop to
///   demonstrate.
/// * Alphanumeric: shadcn's demo swaps in a letters-and-digits pattern.
///   With no pattern prop at all (see above), there is nothing to swap.
///
/// **About**, shadcn's own lead-in prose before Installation, is not a
/// structural section on any page in this corpus: [ComponentDocEntry
/// .description] is the page's own hero paragraph and fills that role.
///
/// [ComponentDocEntry.description] is the page's only rendered description:
/// the short, one-sentence form (nav/search, and this page's own hero
/// paragraph). No second, longer paragraph renders beneath it.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/docs_code.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../kit.dart';
import 'meta.dart';

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
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Components'),
      ElBreadcrumbEntry.page('Input OTP'),
    ],
    toc: const <DocsTocEntry>[
      DocsTocEntry(title: 'Installation', anchor: 'install'),
      DocsTocEntry(title: 'Usage', anchor: 'usage'),
      DocsTocEntry(title: 'Composition', anchor: 'composition'),
      DocsTocEntry(title: 'Groups and separators', anchor: 'groups'),
      DocsTocEntry(title: 'Disabled', anchor: 'disabled'),
      DocsTocEntry(title: 'Controlled', anchor: 'controlled'),
      DocsTocEntry(title: 'Invalid', anchor: 'invalid'),
      DocsTocEntry(title: 'Four digits', anchor: 'four-digits'),
      DocsTocEntry(title: 'Verification form', anchor: 'form'),
      DocsTocEntry(title: 'RTL', anchor: 'rtl'),
      DocsTocEntry(
        title: 'API Reference',
        anchor: 'api',
        children: <DocsTocEntry>[
          DocsTocEntry(title: 'ElInputOtp', anchor: 'api-elinputotp'),
          DocsTocEntry(title: 'ElInputOtpSlot', anchor: 'api-elinputotpslot'),
          DocsTocEntry(
            title: 'ElInputOtpSeparator',
            anchor: 'api-elinputotpseparator',
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
      title: 'Button group',
      route: '/components/button_group',
    ),
    next: const DocsPageLink(
      title: 'Native select',
      route: '/components/native_select',
    ),
    onNavigate: onNavigate,
    child: const _Article(),
  );
}

class _Article extends StatefulWidget {
  const _Article();

  @override
  State<_Article> createState() => _ArticleState();
}

class _ArticleState extends State<_Article> {
  String _code = '';

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      key: const ValueKey<String>('input-otp-doc-article'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _preview(theme),
        SizedBox(height: el(6)),
        _install(),
        SizedBox(height: el(6)),
        _usage(),
        SizedBox(height: el(6)),
        _composition(),
        _groups(),
        _disabled(),
        _controlled(),
        _invalid(),
        _fourDigits(),
        _form(theme),
        _rtl(),
        _api(),
        _states(),
        _accessibility(theme),
        _responsive(theme),
        _dependencies(theme),
        _theming(theme),
        _source(),
      ],
    );
  }

  Widget _preview(ElThemeData theme) => DocsCodeExample(
    title: 'Input OTP',
    description:
        'Six slots grouped three and three, focus advancing on each '
        'digit typed.',
    preview: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        ElInputOtp(
          key: const ValueKey<String>('input-otp-doc-live'),
          onChanged: (String code) => setState(() => _code = code),
        ),
        SizedBox(height: el(3)),
        ElText(
          _code.length == 6 ? 'Complete: $_code' : 'Waiting for code...',
          key: const ValueKey<String>('input-otp-doc-status'),
          ElType.small,
          color: theme.mutedForeground,
        ),
      ],
    ),
    manualFiles: const <DocsCodeFile>[
      DocsCodeFile(
        path: 'input_otp_preview.dart',
        title: 'Live entry',
        code:
            "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
            'ElInputOtp(\n'
            '  onChanged: (String code) {\n'
            '    if (code.length == 6) {\n'
            '      // Code complete\n'
            '    }\n'
            '  },\n'
            ')',
      ),
    ],
  );

  Widget _install() => ElSection(
    id: 'install',
    title: 'Installation',
    description:
        '`elattar add input-otp` installs the component and its declared '
        'dependency closure.',
    child: DocsInstallFacts(
      title: 'Installation facts',
      facts: <DocsInstallFact>[
        const DocsInstallFact(
          label: 'Registry manifest',
          value: 'registry/components/input-otp.json',
          description:
              'No registry/components/input_otp.json exists. Copy '
              'lib/src/components/input_otp.dart manually.',
        ),
        const DocsInstallFact(
          label: 'Platforms',
          value: 'Android, iOS, Web, macOS, Windows, Linux',
          description: 'Pure widget composition: no platform-conditional code.',
        ),
        const DocsInstallFact(
          label: 'Verified',
          value: 'docs specimen only',
          description:
              'This page\'s live preview and example/test/components_docs/'
              'input_otp_test.dart.',
        ),
      ],
    ),
  );

  Widget _usage() => ElSection(
    id: 'usage',
    title: 'Usage',
    description:
        'The smallest correct import and construction. Every example '
        'below only changes named arguments on top of this.',
    child: ElPanel(
      label: 'DART',
      note: 'MINIMAL',
      child: DocsSelectableCodeBlock(code: _usageCode),
    ),
  );

  Widget _composition() => ElSection(
    id: 'composition',
    title: 'Composition',
    description: 'The widget hierarchy ElInputOtp builds on.',
    child: ElPanel(
      label: 'TREE',
      child: DocsSelectableCodeBlock(code: _compositionCode),
    ),
  );

  Widget _groups() => ElSection(
    id: 'groups',
    title: 'Groups and separators',
    description:
        'groups drives both the slot count per group and where a '
        'ElInputOtpSeparator is inserted, one between every pair. It must '
        'sum to maxLength.',
    child: DocsCodeExample(
      title: 'Three groups of two',
      preview: Center(child: ElInputOtp(groups: const <int>[2, 2, 2])),
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(
          path: 'input_otp_groups.dart',
          title: 'Three groups of two',
          code: 'ElInputOtp(groups: const <int>[2, 2, 2])',
        ),
      ],
    ),
  );

  Widget _disabled() => ElSection(
    id: 'disabled',
    title: 'Disabled',
    description: 'enabled: false fades the strip and stops accepting input.',
    child: DocsCodeExample(
      title: 'A disabled field with a seeded value',
      preview: Center(child: ElInputOtp(enabled: false, initialValue: '123')),
    ),
  );

  Widget _controlled() => ElSection(
    id: 'controlled',
    title: 'Controlled',
    description:
        'The live specimen above is already this shape, the parent owns '
        'the value through onChanged, not through a controller. Pass '
        'controller instead to drive the value imperatively.',
    child: ElPanel(
      label: 'DART',
      note: 'A TextEditingController-DRIVEN FIELD',
      child: DocsSelectableCodeBlock(code: _controlledCode),
    ),
  );

  Widget _invalid() => ElSection(
    id: 'invalid',
    title: 'Invalid',
    description:
        'invalid: true colors the slot borders and the group\'s ring '
        'destructive. See States below for the full color values.',
    child: DocsCodeExample(
      title: 'A rejected code',
      preview: Center(child: ElInputOtp(invalid: true, initialValue: '123')),
    ),
  );

  Widget _fourDigits() => ElSection(
    id: 'four-digits',
    title: 'Four digits',
    description: 'A PIN-length field: maxLength: 4, groups: [4], no split.',
    child: DocsCodeExample(
      title: 'A four-digit PIN',
      preview: Center(child: ElInputOtp(maxLength: 4, groups: const <int>[4])),
    ),
  );

  Widget _form(ElThemeData theme) => ElSection(
    id: 'form',
    title: 'Verification form',
    description:
        'ElInputOtp sitting in its usual home: a label, the field, and a '
        'submit action, rather than the isolated specimen above.',
    child: DocsCodeExample(
      title: 'Email verification',
      preview: _OtpFormComposition(theme: theme),
    ),
  );

  Widget _rtl() => ElSection(
    id: 'rtl',
    title: 'RTL',
    description:
        'The label reads right-to-left, the digit strip itself stays '
        'left-to-right, a verification code is read as a number, not as '
        'directional text.',
    child: DocsCodeExample(
      title: 'A right-to-left label above the strip',
      preview: const Directionality(
        textDirection: TextDirection.rtl,
        child: _RtlOtp(),
      ),
    ),
  );

  Widget _api() => ElSection(
    id: 'api',
    title: 'API Reference',
    description:
        'Every constructor parameter each exported class declares, read '
        'directly off lib/src/components/input_otp.dart: one table per '
        'class.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        KeyedSubtree(
          key: docsAnchorKey('api-elinputotp'),
          child: const DocsApiTable(title: 'ElInputOtp', facts: _inputOtpFacts),
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-elinputotpslot'),
          child: const DocsApiTable(title: 'ElInputOtpSlot', facts: _slotFacts),
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-elinputotpseparator'),
          child: const DocsApiTable(
            title: 'ElInputOtpSeparator',
            facts: <DocsApiFact>[],
          ),
        ),
      ],
    ),
  );

  Widget _states() => ElSection(
    id: 'states',
    title: 'States',
    description:
        'Read straight off _DsInputOtpState.build and '
        'ElInputOtpSlot.build, not inferred.',
    child: const DocsStateMatrix(facts: _stateFacts),
  );

  Widget _accessibility(ElThemeData theme) => ElSection(
    id: 'accessibility',
    title: 'Accessibility and keyboard behavior',
    child: _bullets(theme, <String>[
      'ElInputOtp publishes ONE Semantics(textField: true) node over the '
          'whole strip, matching the reference\'s single real <input>. '
          'Known screen-reader defect: the hidden EditableText inside '
          'does not exclude its own semantics, so the strip actually '
          'publishes TWO textField nodes and the field may be announced '
          'twice. Documented, not fixed, in the source.',
      'The six painted ElInputOtpSlot boxes contribute no semantics of '
          'their own: they sit under an IgnorePointer whose '
          'ignoringSemantics follows ignoring (true), so a screen reader '
          'never sees them as six separate fields.',
      'Focus behavior: the strip takes focus as one field '
          '(EditableText.requestKeyboard on tap anywhere in the strip). '
          'Typing and backspace work as expected; Tab moves to the next '
          'field on the page, not between slots (there are no separate '
          'focusable slots to move between).',
      'Paste is not supported: enableInteractiveSelection: false on the '
          'hidden EditableText disables paste. Users can type or autofill '
          'a code (AutofillHints.oneTimeCode is wired), but cannot paste '
          'it. A real accessibility gap, documented as the tradeoff for '
          'the simplified single-selection focus model.',
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
    ]),
  );

  Widget _responsive(ElThemeData theme) => ElSection(
    id: 'responsive',
    title: 'Responsive and platform behavior',
    child: _bullets(theme, <String>[
      'No breakpoint branching in input_otp.dart: BuildContext width is '
          'never read for a layout decision.',
      'The strip is always the sum of (slotSize × slot count) plus '
          '(separatorWidth × separator count): 208px at the default '
          'shape (6 slots, 1 separator). On narrow screens, constrain '
          'the surrounding layout if that is too wide.',
      'ElFieldVisibility wraps the field (USER-ORDERED MOBILE '
          'ADAPTATION): a one-time code arrives while the soft keyboard '
          'is already open, so this is the one family member that could '
          'least afford to skip the keyboard-avoidance hook.',
      'Platform parity: Android, iOS, Web, macOS, Windows, and Linux all '
          'render the same widget tree: no dart:io Platform branch '
          'anywhere in the file.',
    ]),
  );

  Widget _dependencies(ElThemeData theme) => ElSection(
    id: 'dependencies',
    title: 'Dependencies, files, and assets',
    child: _bullets(theme, <String>[
      'File: lib/src/components/input_otp.dart. No companion parts.',
      'Dart imports: dart:math (the selection-expansion arithmetic that '
          'decides which slot is active).',
      'Flutter imports: package:flutter/semantics.dart '
          '(SemanticsValidationResult), package:flutter/services.dart '
          '(AutofillHints, LengthLimitingTextInputFormatter), '
          'package:flutter/widgets.dart (EditableText).',
      'Foundation imports: colors.dart, motion.dart, shadows.dart, '
          'spacing.dart (el()), theme.dart, typography.dart.',
      'Effect imports: effects/machine_surface.dart (ElMachineSurface: '
          'slot borders, the active slot\'s ring, and the group\'s '
          'invalid ring).',
      'Motion imports: motion/keyframes.dart (ElKeyframePlayer: the '
          'fake caret\'s 1000ms blink).',
      'Component imports: button.dart (ElButton.withFocusRing), '
          'field.dart (ElFieldScope), icon.dart and icon_paths.dart '
          '(ElIcon: the separator glyph), input.dart '
          '(ElFieldVisibility, the mobile keyboard-avoidance hook).',
      'Registry dependencies are resolved automatically by `elattar add input-otp`.',
    ]),
  );

  Widget _theming(ElThemeData theme) => ElSection(
    id: 'theming',
    title: 'Theming notes',
    child: _bullets(theme, <String>[
      'Slot border: theme.input at rest, theme.ring while active. '
          'Invalid keeps the destructive border even while active; only '
          'the ring colour changes then.',
      'Slot fill: dark mode only, theme.input at 30% alpha '
          '(dark:bg-input/30). Light mode paints no fill at all, the '
          'boxes read only by their hairlines.',
      'Active ring: theme.ring at 50% alpha; invalid overrides to '
          'theme.destructive at 20% (light) or 40% (dark), matching '
          'ElInputGroup\'s own theme-split.',
      'Caret and digit text: theme.foreground for both. The digit is '
          'ElComponentType.textSm (Inter, not mono) — DOCUMENTED DRIFT: '
          'the reference\'s section description says "using the '
          'numerical mono foundation," but InputOTPSlot itself carries '
          'no mono class; only the invisible overlay is monospace, and '
          'it paints nothing.',
      'No colour overrides: every value comes from ElTheme.of(context).',
    ]),
  );

  Widget _source() => ElSection(
    id: 'source',
    title: 'Source and tests',
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
  );
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

class _RtlOtp extends StatelessWidget {
  const _RtlOtp();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ElText('أدخل رمز التحقق', ElType.section, color: theme.foreground),
        SizedBox(height: el(3)),
        Center(child: ElInputOtp()),
      ],
    );
  }
}

class _OtpFormComposition extends StatelessWidget {
  const _OtpFormComposition({required this.theme});

  final ElThemeData theme;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 320),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ElText('Verify your email', ElType.h4, color: theme.foreground),
        SizedBox(height: el(2)),
        ElText(
          'Enter the 6-digit code sent to ayoub@example.com.',
          ElType.small,
          color: theme.mutedForeground,
        ),
        SizedBox(height: el(5)),
        Center(child: ElInputOtp()),
        SizedBox(height: el(5)),
        ElButton(
          expanded: true,
          onPressed: () {},
          child: ElText('Verify', ElComponentType.buttonLabel),
        ),
        SizedBox(height: el(3)),
        Center(
          child: ElButton(
            variant: ElButtonVariant.link,
            onPressed: () {},
            child: ElText('Resend code', ElComponentType.buttonLabel),
          ),
        ),
      ],
    ),
  );
}

const String _usageCode = '''ElInputOtp(
  maxLength: 6,
  groups: const <int>[3, 3],
  onChanged: (String code) {
    if (code.length == 6) {
      // Code complete
    }
  },
)''';

const String _compositionCode = '''ElInputOtp
├── ElInputOtpSlot (× groups[0])
├── ElInputOtpSeparator
├── ElInputOtpSlot (× groups[1])
└── ... one ElInputOtpSeparator between every pair of groups''';

const String _controlledCode = '''final TextEditingController controller =
    TextEditingController(text: '123');

ElInputOtp(
  controller: controller,
  onChanged: (String code) {
    // read controller.text at any time
  },
)''';

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
        'ElInputOtpSeparator between each pair. Must sum to maxLength.',
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
        'ElFieldScope\'s node, or an owned node if there is neither.',
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
        'ElFieldScope\'s own enabled flag. Fades to 50% opacity and '
        'stops accepting input when false.',
  ),
  DocsApiFact(
    name: 'invalid',
    type: 'bool',
    description:
        'Optional. Defaults to false. ORed with the enclosing '
        'ElFieldScope\'s own invalid flag. Colors the slot borders and '
        'ring destructive.',
  ),
  DocsApiFact(
    name: 'label',
    type: 'String?',
    description:
        'Optional. The field\'s accessible label, announced to screen '
        'readers. Falls back to the enclosing ElFieldScope\'s label.',
  ),
  DocsApiFact(
    name: 'ElInputOtp.slotSize',
    type: 'static double',
    description: '32px: the height and width of each slot.',
  ),
  DocsApiFact(
    name: 'ElInputOtp.separatorWidth',
    type: 'static double',
    description: '16px: the width of each separator (ElIconSize.md).',
  ),
  DocsApiFact(
    name: 'ElInputOtp.widthFor',
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
        'The fake caret uses ElKeyframeFill.none, which freezes the '
        'player at its resting stop — opacity 1, steady — under '
        'MediaQuery.disableAnimations, since anim-caret declares no '
        'fill-mode of its own.',
    userSignal: 'A solid, unblinking caret instead of one that pulses.',
  ),
];
