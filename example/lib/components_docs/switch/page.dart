/// Public documentation page for the `switch` component.
///
/// **Re-housed onto the kit.** This page used to hand-compose `ElSection`
/// panels, following the shadcn parity frame; it now declares a
/// `ComponentDocSpec` (`example/lib/docs/component_doc_page.dart`) and hands
/// it to `ComponentDocPage`, the same shape `button` established. Every
/// specimen widget and every code string that already existed moves across
/// unchanged; two sections (Choice card, Size) carried a live specimen with
/// no quoted source, and now carry both, since a `ShowcaseSection` is a
/// specimen AND its source.
///
/// **Section order**, matching `button`'s own house shape: Preview
/// (the page's own un-headed hero demo, promoted to a real section with a
/// rail entry), Installation, Usage, then one section per shadcn example
/// (Description, Choice card, Disabled, Invalid, Size: no `Examples` wrapper
/// heading), then the eight disclosures. The Size section's own geometry
/// table moved into API Reference as a second `ElSwitchSize` table,
/// alongside `ElSwitch` itself, matching how `button` documents
/// `ElButtonSize`. `RTL` is still skipped, unchanged from the original
/// ruling: `_Thumb` positions the thumb with `Positioned.left`, which is not
/// direction-aware, recorded as its own bullet in Responsive rather than a
/// whole section this control cannot back up.
///
/// switch now ships `registry/components/switch.json`; the old page's own
/// "not yet published" Installation facts were correct when written and are
/// gone now that `elattar add switch` actually resolves. New: a Keyboard
/// disclosure, between Accessibility and Responsive, read directly off
/// `lib/src/components/selection_control.dart`'s shared `_onKey`
/// (switch.dart composes `ElSelectionControl`, it does not wire its own key
/// handler).
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/component_doc_page.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import 'meta.dart';

final ComponentDocSpec switchDocSpec = ComponentDocSpec(
  name: 'switch',
  title: switchDoc.title,
  description: switchDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'A single interactive switch, wired to a real ElField label. Tap '
          'the pill or the words beside it: both flip the same value.',
      specimen: _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'switch is a registry item: elattar add switch resolves it and '
          'its dependencies and copies the source into your project. The '
          'Manual tab is for a project not using the CLI.',
      command: switchDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/switch.dart',
          title: 'switch.dart (public surface excerpt)',
          description:
              'The real file is 233 lines and pairs with '
              'selection_control.dart for the shared socket, focus ring and '
              'hit area: this is the class signature, not the full source.',
          code:
              "import 'package:flutter/widgets.dart';\n\n"
              'enum ElSwitchSize { sm, md }\n\n'
              'class ElSwitch extends StatelessWidget {\n'
              '  const ElSwitch({\n'
              '    super.key,\n'
              '    required this.value,\n'
              '    this.onChanged,\n'
              '    this.size = ElSwitchSize.md,\n'
              '    this.enabled = true,\n'
              '    this.invalid = false,\n'
              '    this.focusNode,\n'
              '    this.label,\n'
              '    this.hint,\n'
              '  });\n\n'
              '  final bool value;\n'
              '  final ValueChanged<bool>? onChanged;\n'
              '  final ElSwitchSize size;\n'
              '  final bool enabled;\n'
              '  final bool invalid;\n'
              '  final FocusNode? focusNode;\n'
              '  final String? label;\n'
              '  final String? hint;\n\n'
              '  // build(...) omitted: see the real source.\n'
              '}',
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'The smallest correct example: a controlled boolean with no label '
          'of its own.',
      code: _usageCode,
    ),
    ShowcaseSection(
      id: 'description',
      title: 'Description',
      description:
          'A label and a line of helper text under it, both published '
          'through ElFieldScope so the switch adopts them as its accessible '
          'name and hint without repeating either string.',
      specimen: _DescriptionSpecimen(),
      code: _descriptionCode,
      label: 'Description specimen view',
    ),
    ShowcaseSection(
      id: 'choice-card',
      title: 'Choice card',
      description:
          'A composed settings list: one ElFieldGroup, several horizontal '
          "ElField rows, one ElSwitch each: shadcn's own \"several toggles "
          'grouped in a card" pattern.',
      specimen: _ChoiceCardSpecimen(),
      code: _choiceCardCode,
      label: 'Choice card specimen view',
    ),
    ShowcaseSection(
      id: 'disabled',
      title: 'Disabled',
      description:
          'enabled: false dims the control to 50% opacity and removes it '
          'from the tab order, independent of value.',
      specimen: _DisabledSpecimen(),
      code: _disabledCode,
      label: 'Disabled specimen view',
    ),
    ShowcaseSection(
      id: 'invalid',
      title: 'Invalid',
      description:
          'invalid: true paints the destructive border and ring. Reproduced '
          'exactly, not merely announced: a focused invalid switch renders '
          'identically to an unfocused one (forms-map §3.3), see States '
          'below.',
      specimen: _InvalidSpecimen(),
      code: _invalidCode,
      label: 'Invalid specimen view',
    ),
    ShowcaseSection(
      id: 'size',
      title: 'Size',
      description:
          'The two rungs of ElSwitchSize, side by side. sm is a 36 × 20 '
          'track with 16px of thumb travel; md (the default: named md '
          'because default is a Dart keyword; .label still reports '
          '"default", the attribute value the reference writes) is a '
          '44 × 24 track with 20px of travel. See API Reference below for '
          'the full geometry table.',
      specimen: _SizeSpecimen(),
      code: _sizeCode,
      label: 'Size specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every constructor parameter ElSwitch declares, and both '
          'ElSwitchSize rungs.',
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'Rest/on, focus, disabled, invalid and reduced motion. Hover, '
          'pressed, loading, empty and success are addressed in prose below '
          'the table rather than invented as rows: see the reasons stated '
          'there.',
      child: _StatesContent(),
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
          "Read off lib/src/components/selection_control.dart's shared "
          '_onKey: switch.dart composes ElSelectionControl rather than '
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
            value: switchDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from. Paired with '
                'lib/src/components/selection_control.dart, documented '
                'separately.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'test/selection_feedback_test.dart',
            description:
                'Covers geometry, motion curves, colors, the hit area and '
                'ElField wiring for the whole selection-control family.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/switch_test.dart',
            description: 'Covers this page.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/switch/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class SwitchDocPage extends StatelessWidget {
  const SwitchDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: switchDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENT · SWITCH',
      title: switchDoc.title,
      description: switchDoc.description,
    ),
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Components'),
      ElBreadcrumbEntry.page('Switch'),
    ],
    toc: switchDocSpec.toc,
    previous: const DocsPageLink(title: 'Select', route: '/components/select'),
    // No next page is wired: the components after it in reading order have
    // not been routed by the supervisor yet. A guessed route would risk
    // pointing at a page that does not exist.
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('switch-doc-article'),
      child: ComponentDocPage(spec: switchDocSpec, header: false),
    ),
  );
}

/* ── Showcase specimens ─────────────────────────────────────────────────── */

/// The one specimen the tests tap: a real, stateful [ElSwitch] behind a
/// [ElField] label, so both the control's own semantics and the label's
/// activation wiring are exercised together.
class _PreviewSpecimen extends StatefulWidget {
  const _PreviewSpecimen();

  @override
  State<_PreviewSpecimen> createState() => _PreviewSpecimenState();
}

class _PreviewSpecimenState extends State<_PreviewSpecimen> {
  bool _on = false;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: ElContainers.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ElField(
            label: 'Email notifications',
            description: 'Applies immediately: there is no Save button.',
            orientation: ElFieldOrientation.horizontal,
            child: ElSwitch(
              key: const ValueKey<String>('switch-doc-live-specimen'),
              value: _on,
              onChanged: (bool next) => setState(() => _on = next),
            ),
          ),
          SizedBox(height: el(3)),
          ElText(
            _on ? 'Currently on.' : 'Currently off.',
            ElType.small,
            color: theme.mutedForeground,
          ),
        ],
      ),
    );
  }
}

const String _previewCode = '''ElField(
  label: 'Email notifications',
  description: 'Applies immediately: there is no Save button.',
  orientation: ElFieldOrientation.horizontal,
  child: ElSwitch(
    value: notificationsOn,
    onChanged: (bool next) => setState(() => notificationsOn = next),
  ),
)''';

const String _usageCode =
    "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
    'ElSwitch(\n'
    '  value: notificationsOn,\n'
    '  onChanged: (bool next) => setState(() => notificationsOn = next),\n'
    ')';

class _DescriptionSpecimen extends StatefulWidget {
  const _DescriptionSpecimen();

  @override
  State<_DescriptionSpecimen> createState() => _DescriptionSpecimenState();
}

class _DescriptionSpecimenState extends State<_DescriptionSpecimen> {
  bool _on = true;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: ElContainers.xs),
    child: ElField(
      label: 'Marketing emails',
      description: 'Product announcements and offers, at most once a week.',
      orientation: ElFieldOrientation.horizontal,
      child: ElSwitch(
        value: _on,
        onChanged: (bool next) => setState(() => _on = next),
      ),
    ),
  );
}

const String _descriptionCode = '''ElField(
  label: 'Marketing emails',
  description: 'Product announcements and offers, at most once a week.',
  orientation: ElFieldOrientation.horizontal,
  child: ElSwitch(
    value: marketingOn,
    onChanged: (bool next) => setState(() => marketingOn = next),
  ),
)''';

/// shadcn's Choice Card example: several toggle rows grouped in one card.
class _ChoiceCardSpecimen extends StatefulWidget {
  const _ChoiceCardSpecimen();

  @override
  State<_ChoiceCardSpecimen> createState() => _ChoiceCardSpecimenState();
}

class _ChoiceCardSpecimenState extends State<_ChoiceCardSpecimen> {
  final List<bool> _values = <bool>[true, false];

  static const List<(String, String)> _rows = <(String, String)>[
    ('Weekly digest', 'A summary of activity, sent every Monday.'),
    ('Marketing email', 'Product announcements and offers.'),
  ];

  @override
  Widget build(BuildContext context) => ElFieldGroup(
    children: <Widget>[
      for (int i = 0; i < _rows.length; i++)
        ElField(
          label: _rows[i].$1,
          description: _rows[i].$2,
          orientation: ElFieldOrientation.horizontal,
          child: ElSwitch(
            value: _values[i],
            label: _rows[i].$1,
            onChanged: (bool next) => setState(() => _values[i] = next),
          ),
        ),
    ],
  );
}

const String _choiceCardCode = '''ElFieldGroup(
  children: [
    for (final row in rows)
      ElField(
        label: row.label,
        description: row.description,
        orientation: ElFieldOrientation.horizontal,
        child: ElSwitch(
          value: values[row],
          label: row.label,
          onChanged: (bool next) => setState(() => values[row] = next),
        ),
      ),
  ],
)''';

class _DisabledSpecimen extends StatelessWidget {
  const _DisabledSpecimen();

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: el(6),
    crossAxisAlignment: WrapCrossAlignment.center,
    children: const <Widget>[
      ElSwitch(value: false, enabled: false),
      ElSwitch(value: true, enabled: false),
    ],
  );
}

const String _disabledCode =
    'ElSwitch(value: false, enabled: false)\n\n'
    'ElSwitch(value: true, enabled: false)';

void _noop(bool _) {}

class _InvalidSpecimen extends StatelessWidget {
  const _InvalidSpecimen();

  @override
  Widget build(BuildContext context) =>
      ElSwitch(value: false, invalid: true, onChanged: _noop);
}

const String _invalidCode =
    'ElSwitch(value: false, invalid: true, onChanged: (bool next) {})';

class _SizeSpecimen extends StatefulWidget {
  const _SizeSpecimen();

  @override
  State<_SizeSpecimen> createState() => _SizeSpecimenState();
}

class _SizeSpecimenState extends State<_SizeSpecimen> {
  bool _sm = true;
  bool _md = true;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: el(8),
    runSpacing: el(4),
    crossAxisAlignment: WrapCrossAlignment.center,
    children: <Widget>[
      ElSwitch(
        size: ElSwitchSize.sm,
        value: _sm,
        label: 'Small',
        onChanged: (bool next) => setState(() => _sm = next),
      ),
      ElSwitch(
        value: _md,
        label: 'Default',
        onChanged: (bool next) => setState(() => _md = next),
      ),
    ],
  );
}

const String _sizeCode = '''Wrap(
  spacing: 32,
  runSpacing: 16,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    ElSwitch(
      size: ElSwitchSize.sm,
      value: sm,
      label: 'Small',
      onChanged: (bool next) => setState(() => sm = next),
    ),
    ElSwitch(
      value: md,
      label: 'Default',
      onChanged: (bool next) => setState(() => md = next),
    ),
  ],
)''';

/* ── Disclosure content ─────────────────────────────────────────────────── */

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsApiTable(title: 'ElSwitch', facts: _switchApiFacts),
      SizedBox(height: el(6)),
      const DocsApiTable(title: 'ElSwitchSize', facts: _sizeFacts),
    ],
  );
}

const List<DocsApiFact> _switchApiFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'value',
    type: 'bool',
    description:
        "Required. The on/off state. Drives the socket's fill, border, "
        "shadow and the thumb's travel.",
  ),
  DocsApiFact(
    name: 'onChanged',
    type: 'ValueChanged<bool>?',
    description:
        'Called with the new value on tap or Enter/Space. Null makes the '
        'switch inert: visible and focusable, but nothing responds.',
  ),
  DocsApiFact(
    name: 'size',
    type: 'ElSwitchSize',
    description: 'Defaults to ElSwitchSize.md. See the table below.',
  ),
  DocsApiFact(
    name: 'enabled',
    type: 'bool',
    description:
        'Defaults to true. Dims to 50% opacity and leaves the tab order '
        'when false: separate from a null onChanged, so a disabled Field '
        'can dim a switch that still holds a handler.',
  ),
  DocsApiFact(
    name: 'invalid',
    type: 'bool',
    description:
        "Defaults to false. Paints the destructive border/ring. ORed with "
        "the enclosing ElFieldScope's own invalid flag.",
  ),
  DocsApiFact(
    name: 'focusNode',
    type: 'FocusNode?',
    description:
        "Optional. Falls back to a ElFieldScope's node when null, so "
        'ElForm.focusFirstError can land on the switch itself.',
  ),
  DocsApiFact(
    name: 'label',
    type: 'String?',
    description:
        'Optional accessible name for a switch whose visible label is a '
        "sibling. Falls back to the enclosing ElFieldScope's label: "
        'typically supplied by ElField.',
  ),
  DocsApiFact(
    name: 'hint',
    type: 'String?',
    description:
        "Optional description/error text, resolved into the control's "
        "semantics hint. Falls back to the enclosing ElFieldScope's "
        'describedBy.',
  ),
];

const List<DocsApiFact> _sizeFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'ElSwitchSize.sm',
    type: '36 × 20 track, 16px thumb',
    description: '16px of travel. data-size="sm" on the reference.',
  ),
  DocsApiFact(
    name: 'ElSwitchSize.md',
    type: '44 × 24 track, 20px thumb',
    description:
        '20px of travel. The default value of ElSwitch.size: named md '
        'rather than default because default is a Dart keyword; .label '
        'still reports "default", the attribute value the reference '
        'writes.',
  ),
];

class _StatesContent extends StatelessWidget {
  const _StatesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsStateMatrix(facts: _stateFacts),
      SizedBox(height: el(3)),
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: ElWidths.prose),
        child: ElText(
          'Pressed is not a row: the reference\'s Switch class list carries '
          'no active-state transform of its own, so there is no distinct '
          'pressed visual beyond the value change itself. Loading, Empty '
          'and Success are not rows either: a boolean control has no '
          'asynchronous operation, so inventing them would describe '
          'behavior the source does not have.',
          ElType.small,
          color: ElTheme.of(context).mutedForeground,
        ),
      ),
    ],
  );
}

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Off (rest)',
    treatment:
        'value: false. Fill theme.muted, border theme.input, '
        'ElShadows.pressed: a socket recessed below the surrounding '
        'surface.',
    userSignal:
        "The thumb rests at the track's left edge; the darker, recessed "
        'socket reads as "unset" independent of hue.',
  ),
  DocsStateFact(
    state: 'On (selected)',
    treatment:
        'value: true. Fill/border theme.primary, ElShadows.btnPrimary: the '
        'socket lights and casts a glow beneath the thumb.',
    userSignal:
        'The thumb travels to the right edge AND the socket brightens: '
        'position and light level both change, not only color.',
  ),
  DocsStateFact(
    state: 'Hover',
    treatment:
        'No dedicated hover treatment: this control family authors none. '
        'MouseRegion only swaps the cursor.',
    userSignal:
        'A click cursor over an enabled switch; nothing else changes on '
        'screen.',
  ),
  DocsStateFact(
    state: 'Focus-visible',
    treatment:
        'Keyboard focus paints theme.ring as the border and adds a '
        'ring-alpha 0.50 glow around the socket, added in front of it '
        'rather than replacing it.',
    userSignal:
        'A visible ring in both themes: unless the control is also '
        'invalid, see below.',
  ),
  DocsStateFact(
    state: 'Invalid',
    treatment:
        'invalid: true. Border/ring turn theme.destructive at ring-alpha '
        '0.20, tested ahead of focus at equal specificity.',
    userSignal:
        'A focused, invalid switch renders identically to an unfocused '
        'invalid one: reproduced exactly, matching the reference '
        '(forms-map §3.3).',
  ),
  DocsStateFact(
    state: 'Disabled',
    treatment:
        "enabled: false. Opacity drops to 50% (this five-control family's "
        'own default, Button and Input use 45%) and the control leaves '
        'the tab order.',
    userSignal:
        'Dimmed and inert; pointer and keyboard are both ignored, on or '
        'off.',
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment:
        'MediaQuery.disableAnimations true collapses every tween to '
        'Duration.zero via elAnimationDuration.',
    userSignal:
        'The thumb still lands at the correct on/off position, instantly, '
        'with no travel and no spring overshoot.',
  ),
];

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'Semantic role: a Semantics(toggled: value) node inside the hit '
            'area, so assistive technology announces it as a switch/toggle '
            'and reads its state as on or off, not merely checked.',
        'Accessible name: required. Pass ElSwitch.label directly, or wrap '
            'the control in a ElField(label: …); the field publishes the '
            'same string through ElFieldScope and the control adopts it '
            'automatically when its own label is left null.',
        'Label activation: inside a horizontal ElField, tapping the label '
            'text flips the switch too: ElField registers a '
            'ElFieldActivator and ElSwitch fills it with its own toggle '
            'callback.',
        'Keyboard: Tab moves focus onto an enabled switch; Enter or Space '
            'activates it, wired by hand onto a Focus widget the same way '
            'a native <button> would answer both keys: see Keyboard below '
            'for the exact contract.',
        'Focus routing: an explicit ElSwitch.focusNode wins over one '
            'supplied by an enclosing ElFieldScope, which in turn wins '
            'over none, so ElForm.focusFirstError can land on the switch '
            'itself.',
        'Touch target: the painted pill is 44 × 24 (or 36 × 20 at '
            'ElSwitchSize.sm), but ElHitArea invisibly grows the tappable '
            'region by 12px on each side and 8px above/below the padding '
            'box: 66 × 38 at the default size, 58 × 34 at sm.',
        'Non-color signal: on and off are never distinguished by hue '
            "alone. The thumb's position (left vs. right) and the "
            'socket\'s depth (recessed vs. lit) both change with the '
            'value, so the state reads correctly even without color '
            'vision.',
        'Error wiring: ElSwitch(invalid: true) paints the destructive '
            'ring but sets no semantics validation result of its own; '
            'that announcement comes from the enclosing '
            'ElField/ElFieldScope, whose own Semantics node carries it '
            'for every control inside, whether or not that control reads '
            'the scope at all.',
        'Known gap, spelling: the switch spells its disabled state '
            '`data-disabled:` while Checkbox, RadioGroupItem and Select '
            'spell it `disabled:` on the reference (forms-map drift 14). '
            'Same intent, two selector families, one ElSwitch.enabled.',
      ]);
}

/// Read directly off `lib/src/components/selection_control.dart`'s shared
/// `_onKey`: `switch.dart` composes `ElSelectionControl` rather than wiring
/// its own key handler, so every fact here is that file's, not invented for
/// this page.
class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'Activation: Enter, NumpadEnter, and Space toggle a focused, '
            'enabled switch. The shared _onKey only inspects KeyDownEvent, '
            'a matching KeyUpEvent is ignored, and any other key returns '
            'KeyEventResult.ignored so it keeps propagating.',
        'Tab order: canRequestFocus is wired to enabled && onTap != null '
            '(switch.dart never sets ElSelectionControl.inert, so that '
            'half of the shared predicate is always false here): a '
            'disabled switch, or one with a null onChanged, is removed '
            'from keyboard traversal entirely, not just dimmed in place.',
        'No custom ordering: neither switch.dart nor '
            'selection_control.dart wires a FocusTraversalPolicy of its '
            'own. Tab and Shift+Tab walk whatever order the surrounding '
            'page (or ElFieldGroup) already declares.',
        'Pointer vs keyboard: a bare pointer tap never requests focus on '
            'the node in this family; only keyboard traversal, or an '
            'explicit focusNode.requestFocus() from outside, does — the '
            "same asymmetry ElButton's own Keyboard section documents, "
            'shared machinery.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'No breakpoint branching anywhere in switch.dart: BuildContext '
            'width is never read for a layout decision; the same widget '
            'renders identically at 390px and 1440px.',
        'Every measurement (trackWidth, trackHeight, thumbSize, travel) '
            'is a fixed value keyed only to ElSwitchSize, never to '
            'viewport.',
        'Platform parity: Android, iOS, Web, macOS, Windows and Linux all '
            'render the same widget tree: switch.dart imports no dart:io '
            'Platform and branches on nothing.',
        'RTL is not supported by this control, recorded rather than '
            'documented as working: _Thumb positions the knob with '
            'Positioned.left, which is not direction-aware, so the '
            'control does not actually mirror under Directionality.rtl. '
            'A genuine gap, not a section this page fakes.',
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
            value: 'Stable, installable through elattar add switch',
            description:
                'Ported and tested against lib/src/components/switch.dart, '
                'and shipped as a registry item.',
          ),
          const DocsInstallFact(
            label: 'Version',
            value: '0.0.1',
            description:
                'Tracks the package version; there is no separate registry '
                'schema version.',
          ),
          const DocsInstallFact(
            label: 'Platforms',
            value: 'Android, iOS, Web, macOS, Windows, Linux',
            description: 'One widget tree, no platform branching.',
          ),
          DocsInstallFact(
            label: 'Source file',
            value: switchDoc.sourcePath,
            description: 'The authoritative implementation.',
          ),
          const DocsInstallFact(
            label: 'Local file dependencies',
            value: 'field.dart, selection_control.dart',
            description:
                'switch.dart imports these directly: field.dart for '
                'ElFieldScope wiring, and selection_control.dart for '
                'ElSelectionControl, the shared track/focus-ring/hit-area '
                'primitive Checkbox and RadioGroupItem also build on. '
                'Neither is copyable in isolation.',
          ),
          const DocsInstallFact(
            label: 'Foundation dependencies',
            value:
                'effects/machine_surface.dart, foundation/motion.dart, '
                'foundation/shadows.dart, foundation/spacing.dart, '
                'foundation/theme.dart, theme_scope.dart',
            description:
                'ElMachineSurface for the raised thumb, and the usual '
                'duration/curve, shadow, spacing and theme tokens.',
          ),
          DocsInstallFact(
            label: 'Exports',
            value: switchDoc.exports.join(', '),
            description:
                'The public symbols this component makes available.',
          ),
          const DocsInstallFact(
            label: 'Assets',
            value: 'none',
            description: 'No images, fonts, or other bundled files.',
          ),
          const DocsInstallFact(
            label: 'Fonts',
            value: 'none',
            description: 'No text is rendered by ElSwitch itself.',
          ),
          const DocsInstallFact(
            label: 'Shaders',
            value: 'none',
            description: 'No fragment shaders.',
          ),
        ],
      ),
      SizedBox(height: el(4)),
      const DocsLinkRow(
        links: <DocsLink>[
          DocsLink(label: 'Field', route: '/components/field'),
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
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'Every color routes through ElTheme.of(context) (primary, muted, '
            'input, border, foreground), so light and dark resolve '
            'automatically; nothing on this page is a literal Color.',
        'bg-muted is the one resting fill in this control family that is '
            'not --card: a socket you can see into needs to be darker '
            'than the surface it is cut out of.',
        'Motion runs on ElDurations.transitionDefault (250ms): the '
            "track's fill, border and ring tween on ElCurves.out, while "
            "the thumb's own transform tweens on ElCurves.spring and "
            "briefly overshoots the track's edge before settling: the "
            'one place in the control where the two halves of the same '
            'surface run different curves.',
      ]);
}

/// Bulleted prose at reading width, matching `button/page.dart`'s own
/// private `_bullets` helper: one bullet per bound fact, not a table.
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
