/// Documentation page for the switch component.
///
/// Reshaped to the shadcn parity frame (`components_docs/button/page.dart` is
/// the reference shape): a live demo before any heading, then Installation,
/// Usage, one top-level section per shadcn example (Description, Choice
/// card, Disabled, Invalid, Size: no `Examples` wrapper heading), API
/// Reference, and finally the six sections shadcn does not carry (States,
/// Accessibility, Responsive, Dependencies, Theming, Source). `RTL` is
/// skipped: `_Thumb` positions the thumb with `Positioned.left`, which is
/// not direction-aware, so the control does not actually mirror under RTL
/// (see the Responsive section's own note).
///
/// `meta.dart` is read directly ([switchDoc], never `componentDoc('switch')`)
/// because the supervisor-owned `catalog.dart#componentDocs` list does not
/// carry this entry yet.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/docs_code.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../kit.dart';
import 'meta.dart';

class SwitchDocPage extends StatelessWidget {
  const SwitchDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) {
    return DocsLayout(
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
      sidebar: _sidebar(switchDoc.route),
      // No entry for the hero demo: it renders before any heading, the same
      // as the shadcn page's own "Airplane Mode" example is not itself a
      // stop on the reference's on-this-page nav.
      toc: const <DocsTocEntry>[
        DocsTocEntry(title: 'Installation', anchor: 'install'),
        DocsTocEntry(title: 'Usage', anchor: 'usage'),
        DocsTocEntry(title: 'Description', anchor: 'description'),
        DocsTocEntry(title: 'Choice card', anchor: 'choice-card'),
        DocsTocEntry(title: 'Disabled', anchor: 'disabled'),
        DocsTocEntry(title: 'Invalid', anchor: 'invalid'),
        DocsTocEntry(title: 'Size', anchor: 'size'),
        DocsTocEntry(title: 'API Reference', anchor: 'api'),
        DocsTocEntry(title: 'States', anchor: 'states'),
        DocsTocEntry(title: 'Accessibility', anchor: 'accessibility'),
        DocsTocEntry(title: 'Responsive', anchor: 'responsive'),
        DocsTocEntry(title: 'Dependencies', anchor: 'dependencies'),
        DocsTocEntry(title: 'Theming', anchor: 'theming'),
        DocsTocEntry(title: 'Source', anchor: 'source'),
      ],
      previous: const DocsPageLink(
        title: 'Select',
        route: '/components/select',
      ),
      // No next page is wired: switch is a Wave 1 addition and the
      // components after it in reading order have not been routed by the
      // supervisor yet. A guessed route would risk pointing at a page that
      // does not exist.
      onNavigate: onNavigate,
      child: const _SwitchArticle(),
    );
  }
}

/// The five already-routed component pages, plus this one. Static rather
/// than derived from `catalog.dart#componentDocs`: that list does not carry
/// [switchDoc] yet, and this file must not edit the supervisor-owned catalog
/// to make it do so.
List<DocsSidebarEntry> _sidebar(String route) => <DocsSidebarEntry>[
  const DocsSidebarEntry(title: 'Button', route: '/components/button'),
  const DocsSidebarEntry(title: 'Card', route: '/components/card'),
  const DocsSidebarEntry(title: 'Input', route: '/components/input'),
  const DocsSidebarEntry(title: 'Dialog', route: '/components/dialog'),
  const DocsSidebarEntry(title: 'Select', route: '/components/select'),
  DocsSidebarEntry(
    title: 'Switch',
    route: switchDoc.route,
    selected: route == switchDoc.route,
  ),
];

class _SwitchArticle extends StatelessWidget {
  const _SwitchArticle();

  @override
  Widget build(BuildContext context) => Column(
    key: const ValueKey<String>('switch-doc-article'),
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      _Anchor('preview', child: const _PreviewSection()),
      SizedBox(height: el(8)),
      const _InstallSection(),
      SizedBox(height: el(2)),
      const _UsageSection(),
      SizedBox(height: el(2)),
      const _DescriptionSection(),
      SizedBox(height: el(2)),
      const _ChoiceCardSection(),
      SizedBox(height: el(2)),
      const _DisabledSection(),
      SizedBox(height: el(2)),
      const _InvalidSection(),
      SizedBox(height: el(2)),
      const _SizeSection(),
      SizedBox(height: el(2)),
      const _ApiSection(),
      SizedBox(height: el(2)),
      const _StatesSection(),
      SizedBox(height: el(2)),
      const _AccessibilitySection(),
      SizedBox(height: el(2)),
      const _ResponsiveSection(),
      SizedBox(height: el(2)),
      const _DependenciesSection(),
      SizedBox(height: el(2)),
      const _ThemingSection(),
      SizedBox(height: el(2)),
      const _SourceSection(),
    ],
  );
}

/// The shadcn page's own un-headed hero demo ("Airplane Mode"): a single
/// interactive switch wired to a real [ElField] label. Tap the pill or the
/// words beside it: both flip the same value.
class _PreviewSection extends StatelessWidget {
  const _PreviewSection();

  @override
  Widget build(BuildContext context) => const DocsCodeExample(
    title: 'Live preview',
    description:
        'A single interactive switch, wired to a real ElField label. Tap '
        'the pill or the words beside it: both flip the same value.',
    preview: _LiveSpecimen(),
  );
}

/// The one specimen the tests tap: a real, stateful [ElSwitch] behind a
/// [ElField] label, so both the control's own semantics and the label's
/// activation wiring are exercised together.
class _LiveSpecimen extends StatefulWidget {
  const _LiveSpecimen();

  @override
  State<_LiveSpecimen> createState() => _LiveSpecimenState();
}

class _LiveSpecimenState extends State<_LiveSpecimen> {
  bool _on = false;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return SizedBox(
      width: 320,
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

/// shadcn's Installation section: CLI and Manual tabs. switch has not
/// ships a registry manifest and installs through `elattar add switch`.
class _InstallSection extends StatelessWidget {
  const _InstallSection();

  @override
  Widget build(BuildContext context) => ElSection(
    id: 'install',
    title: 'Installation',
    description:
        '`elattar add switch` installs the component and its declared '
        'dependency closure.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const DocsCodeExample(
          title: 'Manual install',
          manualFiles: <DocsCodeFile>[
            DocsCodeFile(
              path: 'lib/components/ui/switch.dart',
              title: 'switch.dart (public surface excerpt)',
              description:
                  'The real file is 233 lines and pairs with '
                  'selection_control.dart for the shared socket, focus '
                  'ring and hit area: this is the class signature, not '
                  'the full source.',
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
        SizedBox(height: el(4)),
        DocsInstallFacts(
          facts: <DocsInstallFact>[
            const DocsInstallFact(
              label: 'Registry item',
              value: 'Not yet published',
              description:
                  'switch ships in the registry in this wave: install '
                  'by copying source rather than running a CLI command.',
            ),
            const DocsInstallFact(
              label: 'Destination',
              value: 'lib/components/ui/switch.dart',
              description:
                  'Where a manual copy lands, and where a future CLI '
                  'install would place it too.',
            ),
            const DocsInstallFact(
              label: 'Foundation',
              value: 'source or package compatible',
              description:
                  'A plain StatelessWidget built from public foundation '
                  'tokens; nothing couples it to how the rest of the '
                  'project is installed.',
            ),
            const DocsInstallFact(
              label: 'Assets',
              value: 'none',
              description: 'No images, fonts, or other bundled files.',
            ),
            const DocsInstallFact(
              label: 'Shaders',
              value: 'none',
              description: 'No fragment shaders.',
            ),
            const DocsInstallFact(
              label: 'Platforms',
              value: 'Android, iOS, Web, macOS, Windows, Linux',
              description: 'One widget tree, no platform branching.',
            ),
            const DocsInstallFact(
              label: 'Verified',
              value: 'Package tests + this page\'s own specimen test',
              description:
                  'test/selection_feedback_test.dart covers geometry, '
                  'motion curves, colors, the hit area and ElField wiring; '
                  'example/test/components_docs/switch_test.dart covers '
                  'this page. No fixture/registry install check yet, '
                  'because the shipped manifest installs it.',
            ),
          ],
        ),
      ],
    ),
  );
}

/// shadcn's Usage section: the import plus the smallest correct
/// construction. Every other example on this page only changes named
/// arguments on top of this.
class _UsageSection extends StatelessWidget {
  const _UsageSection();

  @override
  Widget build(BuildContext context) => const ElSection(
    id: 'usage',
    title: 'Usage',
    description:
        'The smallest correct example: a controlled boolean with no label '
        'of its own.',
    child: ElPanel(
      label: 'DART',
      note: 'MINIMAL',
      child: DocsSelectableCodeBlock(code: _usageCode),
    ),
  );
}

const String _usageCode =
    "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
    'ElSwitch(\n'
    '  value: notificationsOn,\n'
    '  onChanged: (bool next) => setState(() => notificationsOn = next),\n'
    ')';

/// shadcn's Description example: a switch paired with a visible label AND
/// helper text, both wired through one [ElField]. New specimen code: the
/// page's existing labelled-row example (below, in Choice card) carries no
/// description text of its own, so it does not cover this case.
class _DescriptionSection extends StatelessWidget {
  const _DescriptionSection();

  @override
  Widget build(BuildContext context) => ElSection(
    id: 'description',
    title: 'Description',
    description:
        'A label and a line of helper text under it, both published '
        'through ElFieldScope so the switch adopts them as its accessible '
        'name and hint without repeating either string.',
    child: DocsCodeExample(
      title: 'Marketing emails',
      preview: const _DescriptionPreview(),
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(
          path: 'description_example.dart',
          code:
              'ElField(\n'
              "  label: 'Marketing emails',\n"
              "  description: 'Product announcements and offers, at most "
              "once a week.',\n"
              '  orientation: ElFieldOrientation.horizontal,\n'
              '  child: ElSwitch(\n'
              '    value: marketingOn,\n'
              '    onChanged: (bool next) => setState(() => marketingOn '
              '= next),\n'
              '  ),\n'
              ')',
        ),
      ],
    ),
  );
}

class _DescriptionPreview extends StatefulWidget {
  const _DescriptionPreview();

  @override
  State<_DescriptionPreview> createState() => _DescriptionPreviewState();
}

class _DescriptionPreviewState extends State<_DescriptionPreview> {
  bool _on = true;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 320,
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

/// shadcn's Choice Card example: several toggle rows grouped in one card.
/// Carries the page's existing composition forward unchanged: one
/// ElFieldGroup, several horizontal ElField rows, one ElSwitch each.
class _ChoiceCardSection extends StatelessWidget {
  const _ChoiceCardSection();

  @override
  Widget build(BuildContext context) => const ElSection(
    id: 'choice-card',
    title: 'Choice card',
    description:
        'A composed settings list: one ElFieldGroup, several horizontal '
        'ElField rows, one ElSwitch each: shadcn\'s own "several toggles '
        'grouped in a card" pattern.',
    child: _PreferencesComposition(),
  );
}

class _PreferencesComposition extends StatefulWidget {
  const _PreferencesComposition();

  @override
  State<_PreferencesComposition> createState() =>
      _PreferencesCompositionState();
}

class _PreferencesCompositionState extends State<_PreferencesComposition> {
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

/// shadcn's Disabled example: `enabled: false`, on and off both shown so
/// the reader sees that the dimmed treatment applies to either value.
class _DisabledSection extends StatelessWidget {
  const _DisabledSection();

  @override
  Widget build(BuildContext context) => ElSection(
    id: 'disabled',
    title: 'Disabled',
    description:
        'enabled: false dims the control to 50% opacity and removes it '
        'from the tab order, independent of value.',
    child: DocsCodeExample(
      title: 'Disabled',
      preview: Wrap(
        spacing: el(6),
        crossAxisAlignment: WrapCrossAlignment.center,
        children: const <Widget>[
          ElSwitch(value: false, enabled: false),
          ElSwitch(value: true, enabled: false),
        ],
      ),
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(
          path: 'disabled_example.dart',
          code:
              'ElSwitch(value: false, enabled: false)\n\n'
              'ElSwitch(value: true, enabled: false)',
        ),
      ],
    ),
  );
}

/// shadcn's Invalid example: `invalid: true` paints the destructive
/// border/ring, ORed with an enclosing ElFieldScope's own invalid flag.
class _InvalidSection extends StatelessWidget {
  const _InvalidSection();

  @override
  Widget build(BuildContext context) => const ElSection(
    id: 'invalid',
    title: 'Invalid',
    description:
        'invalid: true paints the destructive border and ring. Reproduced '
        'exactly, not merely announced: a focused invalid switch renders '
        'identically to an unfocused one (forms-map §3.3), see States '
        'below.',
    child: DocsCodeExample(
      title: 'Invalid',
      preview: ElSwitch(value: false, invalid: true, onChanged: _noop),
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'invalid_example.dart',
          code:
              'ElSwitch(value: false, invalid: true, onChanged: (bool '
              'next) {})',
        ),
      ],
    ),
  );
}

void _noop(bool _) {}

/// The two rungs of [ElSwitchSize], as a table and as a live side-by-side:
/// shadcn's own "Size" example, singular.
class _SizeSection extends StatelessWidget {
  const _SizeSection();

  @override
  Widget build(BuildContext context) => ElSection(
    id: 'size',
    title: 'Size',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const DocsApiTable(
          title: 'Size',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'ElSwitchSize.sm',
              type: '36 × 20 track, 16px thumb',
              description: '16px of travel. data-size="sm" on the reference.',
            ),
            DocsApiFact(
              name: 'ElSwitchSize.md',
              type: '44 × 24 track, 20px thumb',
              description:
                  '20px of travel. The default value of ElSwitch.size: '
                  'named md rather than default because default is a Dart '
                  'keyword; .label still reports "default", the attribute '
                  'value the reference writes.',
            ),
          ],
        ),
        SizedBox(height: el(4)),
        const _SizePreview(),
      ],
    ),
  );
}

class _SizePreview extends StatefulWidget {
  const _SizePreview();

  @override
  State<_SizePreview> createState() => _SizePreviewState();
}

class _SizePreviewState extends State<_SizePreview> {
  bool _sm = true;
  bool _md = true;

  @override
  Widget build(BuildContext context) => DocsCodeExample(
    title: 'Both sizes, side by side',
    preview: Wrap(
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
    ),
  );
}

/// Every ElSwitch constructor parameter and both ElSwitchSize rungs. shadcn's
/// own API Reference just links out to Base UI's docs; ours renders a real
/// table, an addition their page does not have.
class _ApiSection extends StatelessWidget {
  const _ApiSection();

  @override
  Widget build(BuildContext context) => const ElSection(
    id: 'api',
    title: 'API Reference',
    child: DocsApiTable(
      facts: <DocsApiFact>[
        DocsApiFact(
          name: 'value',
          type: 'bool',
          description:
              'Required. The on/off state. Drives the socket\'s fill, '
              'border, shadow and the thumb\'s travel.',
        ),
        DocsApiFact(
          name: 'onChanged',
          type: 'ValueChanged<bool>?',
          description:
              'Called with the new value on tap or Enter/Space. Null makes '
              'the switch inert: visible and focusable, but nothing '
              'responds.',
        ),
        DocsApiFact(
          name: 'size',
          type: 'ElSwitchSize',
          description: 'Defaults to ElSwitchSize.md. See Size above.',
        ),
        DocsApiFact(
          name: 'enabled',
          type: 'bool',
          description:
              'Defaults to true. Dims to 50% opacity and leaves the tab '
              'order when false: separate from a null onChanged, so a '
              'disabled Field can dim a switch that still holds a handler.',
        ),
        DocsApiFact(
          name: 'invalid',
          type: 'bool',
          description:
              'Defaults to false. Paints the destructive border/ring. ORed '
              'with the enclosing ElFieldScope\'s own invalid flag.',
        ),
        DocsApiFact(
          name: 'focusNode',
          type: 'FocusNode?',
          description:
              'Optional. Falls back to a ElFieldScope\'s node when null, so '
              'ElForm.focusFirstError can land on the switch itself.',
        ),
        DocsApiFact(
          name: 'label',
          type: 'String?',
          description:
              'Optional accessible name for a switch whose visible label is '
              'a sibling. Falls back to the enclosing ElFieldScope\'s '
              'label: typically supplied by ElField.',
        ),
        DocsApiFact(
          name: 'hint',
          type: 'String?',
          description:
              'Optional description/error text, resolved into the '
              'control\'s semantics hint. Falls back to the enclosing '
              'ElFieldScope\'s describedBy.',
        ),
      ],
    ),
  );
}

/// Rest/on, focus, disabled, invalid and reduced motion. Hover, pressed,
/// loading, empty and success are addressed in prose below the table rather
/// than invented as rows: see the reasons stated there.
class _StatesSection extends StatelessWidget {
  const _StatesSection();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return ElSection(
      id: 'states',
      title: 'States',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const DocsStateMatrix(
            facts: <DocsStateFact>[
              DocsStateFact(
                state: 'Off (rest)',
                treatment:
                    'value: false. Fill theme.muted, border theme.input, '
                    'ElShadows.pressed: a socket recessed below the '
                    'surrounding surface.',
                userSignal:
                    'The thumb rests at the track\'s left edge; the darker, '
                    'recessed socket reads as "unset" independent of hue.',
              ),
              DocsStateFact(
                state: 'On (selected)',
                treatment:
                    'value: true. Fill/border theme.primary, '
                    'ElShadows.btnPrimary: the socket lights and casts a '
                    'glow beneath the thumb.',
                userSignal:
                    'The thumb travels to the right edge AND the socket '
                    'brightens: position and light level both change, not '
                    'only color.',
              ),
              DocsStateFact(
                state: 'Hover',
                treatment:
                    'No dedicated hover treatment: this control family '
                    'authors none. MouseRegion only swaps the cursor.',
                userSignal:
                    'A click cursor over an enabled switch; nothing else '
                    'changes on screen.',
              ),
              DocsStateFact(
                state: 'Focus-visible',
                treatment:
                    'Keyboard focus paints theme.ring as the border and '
                    'adds a ring-alpha 0.50 glow around the socket, added '
                    'in front of it rather than replacing it.',
                userSignal:
                    'A visible ring in both themes: unless the control is '
                    'also invalid, see below.',
              ),
              DocsStateFact(
                state: 'Invalid',
                treatment:
                    'invalid: true. Border/ring turn theme.destructive at '
                    'ring-alpha 0.20, tested ahead of focus at equal '
                    'specificity.',
                userSignal:
                    'A focused, invalid switch renders identically to an '
                    'unfocused invalid one: reproduced exactly, matching '
                    'the reference (forms-map §3.3).',
              ),
              DocsStateFact(
                state: 'Disabled',
                treatment:
                    'enabled: false. Opacity drops to 50% (this '
                    'five-control family\'s own default, Button and Input '
                    'use 45%) and the control leaves the tab order.',
                userSignal:
                    'Dimmed and inert; pointer and keyboard are both '
                    'ignored, on or off.',
              ),
              DocsStateFact(
                state: 'Reduced motion',
                treatment:
                    'MediaQuery.disableAnimations true collapses every '
                    'tween to Duration.zero via elAnimationDuration.',
                userSignal:
                    'The thumb still lands at the correct on/off position, '
                    'instantly, with no travel and no spring overshoot.',
              ),
            ],
          ),
          SizedBox(height: el(3)),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: ElWidths.prose),
            child: ElText(
              'Pressed is not a row: the reference\'s Switch class list '
              'carries no active-state transform of its own, so there is '
              'no distinct pressed visual beyond the value change itself. '
              'Loading, Empty and Success are not rows either: a boolean '
              'control has no asynchronous operation, so inventing them '
              'would describe behavior the source does not have.',
              ElType.small,
              color: theme.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}

/// Semantic role, labels, keyboard, focus, touch target, the non-color
/// on/off signal, and error wiring.
class _AccessibilitySection extends StatelessWidget {
  const _AccessibilitySection();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return ElSection(
      id: 'accessibility',
      title: 'Accessibility',
      child: _bullets(theme, <String>[
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
            'a native <button> would answer both keys.',
        'Focus routing: an explicit ElSwitch.focusNode wins over one '
            'supplied by an enclosing ElFieldScope, which in turn wins '
            'over none, so ElForm.focusFirstError can land on the switch '
            'itself.',
        'Touch target: the painted pill is 44 × 24 (or 36 × 20 at '
            'ElSwitchSize.sm), but ElHitArea invisibly grows the tappable '
            'region by 12px on each side and 8px above/below the padding '
            'box: 66 × 38 at the default size, 58 × 34 at sm.',
        'Non-color signal: on and off are never distinguished by hue '
            'alone. The thumb\'s position (left vs. right) and the '
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
      ]),
    );
  }
}

/// Layout, breakpoints, and platform behavior: split out from
/// Accessibility, matching `button/page.dart`'s own separation of the two
/// concerns. shadcn covers this ground with its RTL example; ElSwitch does
/// not mirror under RTL (see the note below), so RTL is skipped rather than
/// faked, per the worker brief.
class _ResponsiveSection extends StatelessWidget {
  const _ResponsiveSection();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return ElSection(
      id: 'responsive',
      title: 'Responsive',
      child: _bullets(theme, <String>[
        'No breakpoint branching anywhere in switch.dart: BuildContext '
            'width is never read for a layout decision; the same widget '
            'renders identically at 390px and 1440px.',
        'Every measurement (trackWidth, trackHeight, thumbSize, travel) '
            'is a fixed value keyed only to ElSwitchSize, never to '
            'viewport.',
        'Platform parity: Android, iOS, Web, macOS, Windows and Linux all '
            'render the same widget tree: switch.dart imports no dart:io '
            'Platform and branches on nothing.',
        'RTL is skipped on this page rather than documented as supported: '
            '_Thumb positions the knob with Positioned.left, which is not '
            'direction-aware, so the control does not actually mirror '
            'under Directionality.rtl. A genuine gap, not a section this '
            'page fakes.',
      ]),
    );
  }
}

/// The real source-level imports switch.dart pulls in: not a verified
/// registry dependency list (switch has no manifest yet), so this is
/// documented as internal dependencies rather than claimed as
/// CLI-resolvable ones.
class _DependenciesSection extends StatelessWidget {
  const _DependenciesSection();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return ElSection(
      id: 'dependencies',
      title: 'Dependencies',
      child: _bullets(theme, <String>[
        'File: lib/src/components/switch.dart, paired with '
            'lib/src/components/selection_control.dart for the shared '
            'socket, focus ring and hit area (documented separately).',
        'Flutter imports: package:flutter/widgets.dart only, no material '
            'and no services.',
        'Foundation imports: effects/machine_surface.dart (ElMachineSurface, '
            'the raised thumb), foundation/motion.dart (ElDurations, '
            'ElCurves, elAnimationDuration), foundation/shadows.dart '
            '(ElShadows), foundation/spacing.dart (el()), and '
            'foundation/theme.dart plus theme_scope.dart (ElTheme, ElText).',
        'Component imports: field.dart (ElFieldScope, for label/hint/'
            'enabled/invalid inheritance and label-tap activation) and '
            'selection_control.dart (ElSelectionControl, the shared '
            'track/focus-ring/hit-area primitive Checkbox and '
            'RadioGroupItem also build on).',
        'Internal dependencies (this page\'s own honest list, since no '
            'registry dependencies resolved by lattar add switch: ${switchDoc.dependencies.join(', ')}.',
      ]),
    );
  }
}

/// How color and motion resolve: nothing on this page is a literal Color
/// or a bare Duration.
class _ThemingSection extends StatelessWidget {
  const _ThemingSection();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return ElSection(
      id: 'theming',
      title: 'Theming',
      child: _bullets(theme, <String>[
        'Every color routes through ElTheme.of(context) (primary, muted, '
            'input, border, foreground), so light and dark resolve '
            'automatically; nothing on this page is a literal Color.',
        'bg-muted is the one resting fill in this control family that is '
            'not --card: a socket you can see into needs to be darker '
            'than the surface it is cut out of.',
        'Motion runs on ElDurations.transitionDefault (250ms): the '
            'track\'s fill, border and ring tween on ElCurves.out, while '
            'the thumb\'s own transform tweens on ElCurves.spring and '
            'briefly overshoots the track\'s edge before settling: the '
            'one place in the control where the two halves of the same '
            'surface run different curves.',
      ]),
    );
  }
}

/// Source, tests, and where to edit this page: matching
/// `button/page.dart`'s own `_source()` shape.
class _SourceSection extends StatelessWidget {
  const _SourceSection();

  @override
  Widget build(BuildContext context) => ElSection(
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
  );
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

class _Anchor extends StatelessWidget {
  const _Anchor(this.name, {required this.child});

  final String name;
  final Widget child;

  @override
  // Same convention `button_card_pages.dart` uses: this key is the one the
  // table of contents and the mobile anchor strip look the section up by.
  // Used only for the un-headed hero demo above: every other section below
  // gets its anchor from [ElSection] itself.
  Widget build(BuildContext context) =>
      KeyedSubtree(key: docsAnchorKey(name), child: child);
}
