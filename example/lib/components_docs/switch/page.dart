/// Documentation page for the switch component.
///
/// Mirrors `components_docs/button_card_pages.dart` — the same
/// [DocsLayout] shell, the same `docsAnchorKey`/`_Anchor` marking convention,
/// and the same reliance on the docs primitives for every card, table and
/// code panel. `meta.dart` is read directly ([switchDoc], never
/// `componentDoc('switch')`) because the supervisor-owned
/// `catalog.dart#componentDocs` list does not carry this entry yet.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/docs_code.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
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
      breadcrumbs: const <DsBreadcrumbEntry>[
        DsBreadcrumbEntry.link('Components'),
        DsBreadcrumbEntry.page('Switch'),
      ],
      sidebar: _sidebar(switchDoc.route),
      toc: const <DocsTocEntry>[
        DocsTocEntry(title: 'Overview', anchor: 'overview'),
        DocsTocEntry(title: 'Preview', anchor: 'preview'),
        DocsTocEntry(title: 'Sizes', anchor: 'sizes'),
        DocsTocEntry(title: 'States', anchor: 'states'),
        DocsTocEntry(title: 'Accessibility', anchor: 'accessibility'),
        DocsTocEntry(title: 'Usage', anchor: 'usage'),
        DocsTocEntry(title: 'Install', anchor: 'install'),
        DocsTocEntry(title: 'API', anchor: 'api'),
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
      _Anchor('overview', child: const _OverviewSection()),
      SizedBox(height: ds(6)),
      _Anchor('preview', child: const _PreviewSection()),
      SizedBox(height: ds(6)),
      _Anchor('sizes', child: const _SizesSection()),
      SizedBox(height: ds(6)),
      _Anchor('states', child: const _StatesSection()),
      SizedBox(height: ds(6)),
      _Anchor('accessibility', child: const _AccessibilitySection()),
      SizedBox(height: ds(6)),
      _Anchor('usage', child: const _UsageSection()),
      SizedBox(height: ds(6)),
      _Anchor('install', child: const _InstallSection()),
      SizedBox(height: ds(6)),
      _Anchor('api', child: const _ApiSection()),
    ],
  );
}

/// IA §9.1 items 4–5: the expanded, decision-guiding description (switch vs.
/// checkbox), plus a one-line status/motion teaser expanded on later.
class _OverviewSection extends StatelessWidget {
  const _OverviewSection();

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return _ProsePanel(
      title: 'When to use a switch',
      children: <Widget>[
        DsText(switchExpandedDescription, DsType.body, color: theme.foreground),
        SizedBox(height: ds(3)),
        DsText(
          'The thumb travels and the socket lights on every change — see '
          'Sizes for the exact geometry, States for the motion curves and '
          'reduced-motion behavior, and Install for why there is no CLI '
          'command yet.',
          DsType.small,
          color: theme.mutedForeground,
        ),
      ],
    );
  }
}

/// IA §9.1 item 6: the primary live specimen. Preview only, no tabs — the
/// Code/Manual view of the same source lives in Install, where it belongs
/// beside the honest "no CLI command yet" note.
class _PreviewSection extends StatelessWidget {
  const _PreviewSection();

  @override
  Widget build(BuildContext context) => const DocsCodeExample(
    title: 'Live preview',
    description:
        'A single interactive switch, wired to a real DsField label. Tap '
        'the pill or the words beside it — both flip the same value.',
    preview: _LiveSpecimen(),
  );
}

/// The one specimen the tests tap: a real, stateful [DsSwitch] behind a
/// [DsField] label, so both the control's own semantics and the label's
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
    final DsThemeData theme = DsTheme.of(context);
    return SizedBox(
      width: 320,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          DsField(
            label: 'Email notifications',
            description: 'Applies immediately — there is no Save button.',
            orientation: DsFieldOrientation.horizontal,
            child: DsSwitch(
              key: const ValueKey<String>('switch-doc-live-specimen'),
              value: _on,
              onChanged: (bool next) => setState(() => _on = next),
            ),
          ),
          SizedBox(height: ds(3)),
          DsText(
            _on ? 'Currently on.' : 'Currently off.',
            DsType.small,
            color: theme.mutedForeground,
          ),
        ],
      ),
    );
  }
}

/// IA §9.1 item 10: the two rungs of [DsSwitchSize], as a table and as a
/// live side-by-side.
class _SizesSection extends StatelessWidget {
  const _SizesSection();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsApiTable(
        title: 'Sizes',
        facts: <DocsApiFact>[
          DocsApiFact(
            name: 'DsSwitchSize.sm',
            type: '36 × 20 track, 16px thumb',
            description: '16px of travel. data-size="sm" on the reference.',
          ),
          DocsApiFact(
            name: 'DsSwitchSize.md',
            type: '44 × 24 track, 20px thumb',
            description:
                '20px of travel. The default value of DsSwitch.size — named '
                'md rather than default because default is a Dart keyword; '
                '.label still reports "default", the attribute value the '
                'reference writes.',
          ),
        ],
      ),
      SizedBox(height: ds(4)),
      const _SizesPreview(),
    ],
  );
}

class _SizesPreview extends StatefulWidget {
  const _SizesPreview();

  @override
  State<_SizesPreview> createState() => _SizesPreviewState();
}

class _SizesPreviewState extends State<_SizesPreview> {
  bool _sm = true;
  bool _md = true;

  @override
  Widget build(BuildContext context) => DocsCodeExample(
    title: 'Both sizes, side by side',
    preview: Wrap(
      spacing: ds(8),
      runSpacing: ds(4),
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        DsSwitch(
          size: DsSwitchSize.sm,
          value: _sm,
          label: 'Small',
          onChanged: (bool next) => setState(() => _sm = next),
        ),
        DsSwitch(
          value: _md,
          label: 'Default',
          onChanged: (bool next) => setState(() => _md = next),
        ),
      ],
    ),
  );
}

/// IA §9.1 item 11: rest/on, focus, disabled, invalid and reduced motion.
/// Hover, pressed, loading, empty and success are addressed in prose below
/// the table rather than invented as rows — see the reasons stated there.
class _StatesSection extends StatelessWidget {
  const _StatesSection();

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const DocsStateMatrix(
          facts: <DocsStateFact>[
            DocsStateFact(
              state: 'Off (rest)',
              treatment:
                  'value: false. Fill theme.muted, border theme.input, '
                  'DsShadows.pressed — a socket recessed below the '
                  'surrounding surface.',
              userSignal:
                  'The thumb rests at the track\'s left edge; the darker, '
                  'recessed socket reads as "unset" independent of hue.',
            ),
            DocsStateFact(
              state: 'On (selected)',
              treatment:
                  'value: true. Fill/border theme.primary, '
                  'DsShadows.btnPrimary — the socket lights and casts a '
                  'glow beneath the thumb.',
              userSignal:
                  'The thumb travels to the right edge AND the socket '
                  'brightens — position and light level both change, not '
                  'only color.',
            ),
            DocsStateFact(
              state: 'Hover',
              treatment:
                  'No dedicated hover treatment — this control family '
                  'authors none. MouseRegion only swaps the cursor.',
              userSignal:
                  'A click cursor over an enabled switch; nothing else '
                  'changes on screen.',
            ),
            DocsStateFact(
              state: 'Focus-visible',
              treatment:
                  'Keyboard focus paints theme.ring as the border and adds '
                  'a ring-alpha 0.50 glow around the socket, added in '
                  'front of it rather than replacing it.',
              userSignal:
                  'A visible ring in both themes — unless the control is '
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
                  'unfocused invalid one — reproduced exactly, matching '
                  'the reference (forms-map §3.3).',
            ),
            DocsStateFact(
              state: 'Disabled',
              treatment:
                  'enabled: false. Opacity drops to 50% (this five-control '
                  'family\'s own default — Button and Input use 45%) and '
                  'the control leaves the tab order.',
              userSignal:
                  'Dimmed and inert; pointer and keyboard are both '
                  'ignored, on or off.',
            ),
            DocsStateFact(
              state: 'Reduced motion',
              treatment:
                  'MediaQuery.disableAnimations true collapses every tween '
                  'to Duration.zero via dsAnimationDuration.',
              userSignal:
                  'The thumb still lands at the correct on/off position — '
                  'instantly, with no travel and no spring overshoot.',
            ),
          ],
        ),
        SizedBox(height: ds(3)),
        DsText(
          'Pressed is not a row: the reference\'s Switch class list carries '
          'no active-state transform of its own, so there is no distinct '
          'pressed visual beyond the value change itself. Loading, Empty '
          'and Success are not rows either — a boolean control has no '
          'asynchronous operation, so inventing them would describe '
          'behavior the source does not have.',
          DsType.small,
          color: theme.mutedForeground,
        ),
      ],
    );
  }
}

/// IA §9.1 items 12–13: semantic role, labels, keyboard, focus, touch
/// target, the non-color on/off signal, error wiring, and responsive /
/// platform behavior.
class _AccessibilitySection extends StatelessWidget {
  const _AccessibilitySection();

  @override
  Widget build(BuildContext context) => const _ProsePanel(
    title: 'Accessibility',
    children: <Widget>[
      _Bullet(
        'Semantic role — a Semantics(toggled: value) node inside the hit '
        'area, so assistive technology announces it as a switch/toggle and '
        'reads its state as on or off, not merely checked.',
      ),
      _Bullet(
        'Accessible name — required. Pass DsSwitch.label directly, or wrap '
        'the control in a DsField(label: …); the field publishes the same '
        'string through DsFieldScope and the control adopts it '
        'automatically when its own label is left null.',
      ),
      _Bullet(
        'Label activation — inside a horizontal DsField, tapping the label '
        'text flips the switch too: DsField registers a DsFieldActivator '
        'and DsSwitch fills it with its own toggle callback.',
      ),
      _Bullet(
        'Keyboard — Tab moves focus onto an enabled switch; Enter or Space '
        'activates it, wired by hand onto a Focus widget the same way a '
        'native <button> would answer both keys.',
      ),
      _Bullet(
        'Focus routing — an explicit DsSwitch.focusNode wins over one '
        'supplied by an enclosing DsFieldScope, which in turn wins over '
        'none, so DsForm.focusFirstError can land on the switch itself.',
      ),
      _Bullet(
        'Touch target — the painted pill is 44 × 24 (or 36 × 20 at '
        'DsSwitchSize.sm), but DsHitArea invisibly grows the tappable '
        'region by 12px on each side and 8px above/below the padding box: '
        '66 × 38 at the default size, 58 × 34 at sm.',
      ),
      _Bullet(
        'Non-color signal — on and off are never distinguished by hue '
        'alone. The thumb\'s position (left vs. right) and the socket\'s '
        'depth (recessed vs. lit) both change with the value, so the '
        'state reads correctly even without color vision.',
      ),
      _Bullet(
        'Error wiring — DsSwitch(invalid: true) paints the destructive '
        'ring but sets no semantics validation result of its own; that '
        'announcement comes from the enclosing DsField/DsFieldScope, '
        'whose own Semantics node carries it for every control inside, '
        'whether or not that control reads the scope at all.',
      ),
      _Bullet(
        'Platform behavior — the geometry is fixed pixels rather than '
        'responsive; the same widget renders identically on Android, iOS, '
        'Web, macOS, Windows and Linux, with the hit-area expansion doing '
        'the work of staying comfortably tappable on touch platforms '
        'without growing the visual pill.',
      ),
    ],
  );
}

/// IA §9.1 items 8 and 15: the smallest correct example, a labelled form
/// row, a compact/disabled/invalid variant, and a small composed settings
/// list.
class _UsageSection extends StatelessWidget {
  const _UsageSection();

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return _ProsePanel(
      title: 'Usage',
      children: <Widget>[
        DsText(
          'The smallest correct example — a controlled boolean with no '
          'label of its own.',
          DsType.small,
          color: theme.mutedForeground,
        ),
        SizedBox(height: ds(2)),
        const DocsSelectableCodeBlock(
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              'DsSwitch(\n'
              '  value: notificationsOn,\n'
              '  onChanged: (bool next) => setState(() => notificationsOn = next),\n'
              ')',
        ),
        SizedBox(height: ds(4)),
        DsText(
          'Labelled inside a form row — the control comes first in the '
          'row, matching every horizontal field on the reference.',
          DsType.small,
          color: theme.mutedForeground,
        ),
        SizedBox(height: ds(2)),
        const DocsSelectableCodeBlock(
          code:
              'DsField(\n'
              "  label: 'Price alerts',\n"
              '  orientation: DsFieldOrientation.horizontal,\n'
              '  child: DsSwitch(\n'
              '    value: alertsOn,\n'
              '    onChanged: (bool next) => setState(() => alertsOn = next),\n'
              '  ),\n'
              ')',
        ),
        SizedBox(height: ds(4)),
        DsText(
          'Small size, disabled, and marked invalid — three independent '
          'flags.',
          DsType.small,
          color: theme.mutedForeground,
        ),
        SizedBox(height: ds(2)),
        const DocsSelectableCodeBlock(
          code:
              'DsSwitch(value: true, size: DsSwitchSize.sm, enabled: false)\n\n'
              'DsSwitch(value: false, invalid: true, onChanged: (bool next) {})',
        ),
        SizedBox(height: ds(4)),
        DsText(
          'A composed settings list — one DsFieldGroup, several horizontal '
          'DsField rows, one DsSwitch each.',
          DsType.small,
          color: theme.mutedForeground,
        ),
        SizedBox(height: ds(3)),
        const _PreferencesComposition(),
      ],
    );
  }
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
  Widget build(BuildContext context) => DsFieldGroup(
    children: <Widget>[
      for (int i = 0; i < _rows.length; i++)
        DsField(
          label: _rows[i].$1,
          description: _rows[i].$2,
          orientation: DsFieldOrientation.horizontal,
          child: DsSwitch(
            value: _values[i],
            label: _rows[i].$1,
            onChanged: (bool next) => setState(() => _values[i] = next),
          ),
        ),
    ],
  );
}

/// IA §9.1 items 7, 9.9, 14, 16 and (partially) 17: manual installation,
/// the mandatory install-facts disclosure, source dependencies, theming, and
/// where the source and tests live.
class _InstallSection extends StatelessWidget {
  const _InstallSection();

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DsText(
          'Switch has not shipped a registry manifest yet — there is no '
          '"elattar add switch" to run, and this page will not print one '
          'that does not work. Copy the source below (and its '
          'selection_control.dart dependency) into lib/components/ui/ '
          'until a manifest ships.',
          DsType.small,
          color: theme.mutedForeground,
        ),
        SizedBox(height: ds(4)),
        const DocsCodeExample(
          title: 'Manual install',
          manualFiles: <DocsCodeFile>[
            DocsCodeFile(
              path: 'lib/components/ui/switch.dart',
              title: 'switch.dart (public surface excerpt)',
              description:
                  'The real file is 233 lines and pairs with '
                  'selection_control.dart for the shared socket, focus '
                  'ring and hit area — this is the class signature, not '
                  'the full source.',
              code:
                  "import 'package:flutter/widgets.dart';\n\n"
                  'enum DsSwitchSize { sm, md }\n\n'
                  'class DsSwitch extends StatelessWidget {\n'
                  '  const DsSwitch({\n'
                  '    super.key,\n'
                  '    required this.value,\n'
                  '    this.onChanged,\n'
                  '    this.size = DsSwitchSize.md,\n'
                  '    this.enabled = true,\n'
                  '    this.invalid = false,\n'
                  '    this.focusNode,\n'
                  '    this.label,\n'
                  '    this.hint,\n'
                  '  });\n\n'
                  '  final bool value;\n'
                  '  final ValueChanged<bool>? onChanged;\n'
                  '  final DsSwitchSize size;\n'
                  '  final bool enabled;\n'
                  '  final bool invalid;\n'
                  '  final FocusNode? focusNode;\n'
                  '  final String? label;\n'
                  '  final String? hint;\n\n'
                  '  // build(...) omitted — see the real source.\n'
                  '}',
            ),
          ],
        ),
        SizedBox(height: ds(4)),
        DsText(
          'Theming — every color routes through DsTheme.of(context) '
          '(primary, muted, input, border, foreground), so light and dark '
          'resolve automatically; nothing on this page is a literal '
          'Color. Motion runs on DsDurations.transitionDefault (250ms): '
          'the track\'s fill, border and ring tween on DsCurves.out, while '
          'the thumb\'s own transform tweens on DsCurves.spring and '
          'briefly overshoots the track\'s edge before settling — the one '
          'place in the control where the two halves of the same surface '
          'run different curves.',
          DsType.small,
          color: theme.mutedForeground,
        ),
        SizedBox(height: ds(4)),
        DocsInstallFacts(
          facts: <DocsInstallFact>[
            const DocsInstallFact(
              label: 'Registry item',
              value: 'Not yet published',
              description:
                  'switch has no registry manifest in this wave — install '
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
            DocsInstallFact(
              label: 'Internal dependencies',
              value: switchDoc.dependencies.join(', '),
              description:
                  'What switch.dart itself imports from '
                  'lib/src/components — not a verified registry '
                  'dependency list, since none exists yet.',
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
                  'motion curves, colors, the hit area and DsField wiring; '
                  'example/test/components_docs/switch_test.dart covers '
                  'this page. No fixture/registry install check yet, '
                  'because there is no manifest to install.',
            ),
          ],
        ),
      ],
    );
  }
}

/// IA §9.1 item 9: every DsSwitch constructor parameter and both
/// DsSwitchSize rungs.
class _ApiSection extends StatelessWidget {
  const _ApiSection();

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const DocsApiTable(
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
                  'Called with the new value on tap or Enter/Space. Null '
                  'makes the switch inert: visible and focusable, but '
                  'nothing responds.',
            ),
            DocsApiFact(
              name: 'size',
              type: 'DsSwitchSize',
              description: 'Defaults to DsSwitchSize.md. See Sizes above.',
            ),
            DocsApiFact(
              name: 'enabled',
              type: 'bool',
              description:
                  'Defaults to true. Dims to 50% opacity and leaves the '
                  'tab order when false — separate from a null onChanged, '
                  'so a disabled Field can dim a switch that still holds '
                  'a handler.',
            ),
            DocsApiFact(
              name: 'invalid',
              type: 'bool',
              description:
                  'Defaults to false. Paints the destructive border/ring. '
                  'ORed with the enclosing DsFieldScope\'s own invalid '
                  'flag.',
            ),
            DocsApiFact(
              name: 'focusNode',
              type: 'FocusNode?',
              description:
                  'Optional. Falls back to a DsFieldScope\'s node when '
                  'null, so DsForm.focusFirstError can land on the switch '
                  'itself.',
            ),
            DocsApiFact(
              name: 'label',
              type: 'String?',
              description:
                  'Optional accessible name for a switch whose visible '
                  'label is a sibling. Falls back to the enclosing '
                  'DsFieldScope\'s label — typically supplied by DsField.',
            ),
            DocsApiFact(
              name: 'hint',
              type: 'String?',
              description:
                  'Optional description/error text, resolved into the '
                  'control\'s semantics hint. Falls back to the enclosing '
                  'DsFieldScope\'s describedBy.',
            ),
          ],
        ),
        SizedBox(height: ds(3)),
        DsText(
          'Source: lib/src/components/switch.dart (paired with '
          'lib/src/components/selection_control.dart, documented '
          'separately). Tests: test/selection_feedback_test.dart and '
          'example/test/components_docs/switch_test.dart.',
          DsType.small,
          color: theme.mutedForeground,
        ),
      ],
    );
  }
}

/// A titled card for prose, matching the visual weight of
/// `docs_facts.dart`'s `_DocsFactPanel` without depending on it — that class
/// is private to a file this page only reads.
class _ProsePanel extends StatelessWidget {
  const _ProsePanel({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(DsRadii.xl),
        border: Border.all(color: theme.border, width: DsWidths.hairline),
      ),
      child: Padding(
        padding: EdgeInsets.all(ds(5)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            DsText(title, DsType.h4, color: theme.foreground),
            SizedBox(height: ds(4)),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: ds(3)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: ds(1.5), right: ds(2)),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: theme.mutedForeground,
                shape: BoxShape.circle,
              ),
              child: SizedBox(width: ds(1), height: ds(1)),
            ),
          ),
          Expanded(
            child: DsText(text, DsType.small, color: theme.mutedForeground),
          ),
        ],
      ),
    );
  }
}

class _Anchor extends StatelessWidget {
  const _Anchor(this.name, {required this.child});

  final String name;
  final Widget child;

  @override
  // Same convention `button_card_pages.dart` uses: this key is the one the
  // table of contents and the mobile anchor strip look the section up by.
  Widget build(BuildContext context) =>
      KeyedSubtree(key: docsAnchorKey(name), child: child);
}
