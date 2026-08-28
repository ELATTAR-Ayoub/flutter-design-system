/// Public documentation page for the `action-feedback` effect.
///
/// **Why `EffectSection`, not `ShowcaseSection`.** [ActionFeedback] takes no
/// variant — it is the one surface treatment this system's own primary
/// Button paints itself with, and it does nothing on its own terms: a
/// `ShowcaseSection` stages a specimen; `EffectSection` names the host
/// (here, a pill-shaped surface) the ramp, the texture and the beat are
/// painted onto.
///
/// **Section list.** Preview contrasts an ActionFeedback-wrapped pill
/// against the identical pill wrapped in a plain [Surface], so the
/// ramp and the static texture are visible against a flat fill. Hover and
/// Press are both live, pointer-driven specimens — hovered and pressed are
/// booleans this effect takes from its caller, so a docs specimen has to
/// wire them up itself, exactly as Button does.
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
import 'meta.dart';

final ComponentDocSpec sheenActionDocSpec = ComponentDocSpec(
  name: 'action_feedback',
  title: 'Sheen Action',
  description:
      'The default Button\'s surface: a derived five-stop ramp, a static '
      'blended texture, and a double-thump light that beats on hover and '
      'retimes — without restarting — the instant the surface is pressed.',
  sections: <DocsPageSection>[
    EffectSection(
      id: 'preview',
      title: 'Preview',
      description:
          'The left pill is ActionFeedback: the five-stop ramp plus the '
          'static striation/diagonal/corner texture, at rest. The right '
          'pill is the identical shape and shadow spec, wrapped in a '
          'plain Surface with a flat theme.secondary fill and no '
          'ramp, no texture, no beat.',
      host: const _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'action-feedback has a real registry manifest: `elattar add '
          'action-feedback` installs lib/src/components/ui/action_feedback.dart and '
          'resolves its two registryDependencies automatically. The '
          'Manual tab is for a project not using the CLI.',
      command: actionFeedbackDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/effects/action_feedback.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/ui/action_feedback.dart's generated "
              '@ui/action_feedback.dart payload into effects.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated action-feedback source here when using '
              'manual mode.',
        ),
        DocsCodeFile(
          path: 'lib/effects/effects.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so ActionFeedback is reachable the '
              'same way the CLI path already makes it.',
          code: "export 'action_feedback.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'ActionFeedback takes the same shadow spec, radius and border an '
          'Surface would, and splices its ramp in around them. '
          'hovered and pressed are the caller\'s own pointer state — '
          'nothing here reads a pointer itself.',
      code: _usageCode,
    ),
    EffectSection(
      id: 'hover',
      title: 'Hover',
      description:
          'Hover the pill. A fresh action-beat animation starts at frame '
          '0 (scale 0.55, opacity 0) and loops forever on MotionDurations.'
          'beatHover (2600ms) while the pointer stays inside — a strong '
          'thump, a weaker echo, then 1196ms of held rest each cycle.',
      host: const _SheenHost(label: 'Hover me'),
      code: _hoverCode,
      label: 'Hover specimen view',
    ),
    EffectSection(
      id: 'press',
      title: 'Press',
      description:
          'Press and hold. The same animation retimes to MotionDurations.'
          'beatPress (620ms), single iteration, WITHOUT restarting: its '
          'elapsed time so far is preserved and re-divided by the new, '
          'shorter duration. Press early in a hover and the beat jumps '
          'ahead; press late and the re-divided clock is already past '
          'the single iteration, so nothing visibly plays at all — the '
          'source\'s own measured, documented behaviour.',
      host: const _SheenHost(label: 'Press me', demonstratesPress: true),
      code: _pressCode,
      label: 'Press specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description: 'Every constructor parameter ActionFeedback declares.',
      child: DocsApiTable(title: 'ActionFeedback', facts: _sheenActionApiFacts),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      child: DocsStateMatrix(facts: _stateFacts),
    ),
    DisclosureSection(
      id: 'accessibility',
      title: 'Accessibility',
      child: _AccessibilityContent(),
    ),
    DisclosureSection(
      id: 'keyboard',
      title: 'Keyboard',
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
            value: actionFeedbackDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'test/effects_test.dart',
            description:
                'Group "ActionFeedback": the ramp\'s five derived stops, '
                'the theme-flipping beat blend, every action-beat '
                'keyframe sample, the dead final 46% of the cycle, and '
                'phaseAt\'s elapsed-time re-division under reduced '
                'motion.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/sheen_action_test.dart',
            description:
                'Covers this page: the article mounts, the API table, a '
                'live hover and a live press on the two interactive '
                'specimens, and both themes.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/action_feedback/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class ActionFeedbackDocPage extends StatelessWidget {
  const ActionFeedbackDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: actionFeedbackDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / EFFECTS',
      title: actionFeedbackDoc.title,
      description: actionFeedbackDoc.description,
    ),
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Components'),
      BreadcrumbEntry.page('Sheen Action'),
    ],
    toc: sheenActionDocSpec.toc,
    previous: null,
    next: null,
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('action-feedback-doc-article'),
      child: ComponentDocPage(spec: sheenActionDocSpec, header: false),
    ),
  );
}

/* ── Effect specimens ───────────────────────────────────────────────────── */

BorderRadius get _pillRadius => BorderRadius.circular(Radii.full);

Widget _pillLabel(ThemeTokens theme, String text) => Padding(
  padding: EdgeInsets.symmetric(horizontal: space(6), vertical: space(3)),
  child: StyledText(text, TextStyles.body, color: theme.primaryForeground),
);

class _PreviewSpecimen extends StatelessWidget {
  const _PreviewSpecimen();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Wrap(
      spacing: space(6),
      runSpacing: space(4),
      crossAxisAlignment: WrapCrossAlignment.start,
      children: <Widget>[
        KeyedSubtree(
          key: const ValueKey<String>('action-feedback-preview:sheen'),
          child: ActionFeedback(
            spec: Shadows.controlPrimary,
            radius: _pillRadius,
            border: Border.all(
              color: theme.border,
              width: BorderWidths.hairline,
            ),
            child: _pillLabel(theme, 'ActionFeedback'),
          ),
        ),
        KeyedSubtree(
          key: const ValueKey<String>('action-feedback-preview:plain'),
          child: Surface(
            spec: Shadows.controlPrimary,
            radius: _pillRadius,
            fill: theme.secondary,
            border: Border.all(
              color: theme.border,
              width: BorderWidths.hairline,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: space(6),
                vertical: space(3),
              ),
              child: StyledText(
                'Plain surface',
                TextStyles.body,
                color: theme.foreground,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

const String _previewCode =
    '// ActionFeedback — the ramp and the static texture\n'
    'ActionFeedback(\n'
    '  spec: Shadows.controlPrimary,\n'
    '  radius: BorderRadius.circular(Radii.full),\n'
    "  child: const Text('ActionFeedback'),\n"
    ')\n\n'
    '// A plain Surface — flat fill, no ramp, no texture, no beat\n'
    'Surface(\n'
    '  spec: Shadows.controlPrimary,\n'
    '  radius: BorderRadius.circular(Radii.full),\n'
    '  fill: theme.secondary,\n'
    "  child: const Text('Plain surface'),\n"
    ')';

/// A pointer-driven [ActionFeedback], wiring `hovered` and `pressed` from a
/// real [MouseRegion] / [Listener] the way [Button] does — neither
/// boolean is something ActionFeedback reads for itself. A raw [Listener]
/// rather than a [GestureDetector]'s tap recognizer: it fires on every
/// pointer event unconditionally, with no gesture-arena resolution to lose,
/// the same mechanism this batch's own Press uses.
class _SheenHost extends StatefulWidget {
  const _SheenHost({required this.label, this.demonstratesPress = false});

  final String label;
  final bool demonstratesPress;

  @override
  State<_SheenHost> createState() => _SheenHostState();
}

class _SheenHostState extends State<_SheenHost> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() {
        _hovered = false;
        _pressed = false;
      }),
      child: Listener(
        behavior: HitTestBehavior.opaque,
        onPointerDown: (_) => setState(() => _pressed = true),
        onPointerUp: (_) => setState(() => _pressed = false),
        onPointerCancel: (_) => setState(() => _pressed = false),
        child: ActionFeedback(
          key: ValueKey<String>(
            widget.demonstratesPress
                ? 'action-feedback-press:host'
                : 'action-feedback-hover:host',
          ),
          spec: _pressed ? Shadows.controlPressed : Shadows.controlPrimary,
          radius: _pillRadius,
          border: Border.all(color: theme.border, width: BorderWidths.hairline),
          hovered: _hovered,
          pressed: _pressed,
          child: _pillLabel(theme, widget.label),
        ),
      ),
    );
  }
}

const String _hoverCode =
    'MouseRegion(\n'
    '  onEnter: (_) => setState(() => hovered = true),\n'
    '  onExit: (_) => setState(() => hovered = false),\n'
    '  child: ActionFeedback(\n'
    '    spec: Shadows.controlPrimary,\n'
    '    radius: BorderRadius.circular(Radii.full),\n'
    '    hovered: hovered,\n'
    "    child: const Text('Hover me'),\n"
    '  ),\n'
    ')';

const String _pressCode =
    'Listener(\n'
    '  behavior: HitTestBehavior.opaque,\n'
    '  onPointerDown: (_) => setState(() => pressed = true),\n'
    '  onPointerUp: (_) => setState(() => pressed = false),\n'
    '  onPointerCancel: (_) => setState(() => pressed = false),\n'
    '  child: ActionFeedback(\n'
    '    spec: pressed ? Shadows.controlPressed : Shadows.controlPrimary,\n'
    '    radius: BorderRadius.circular(Radii.full),\n'
    '    pressed: pressed,\n'
    "    child: const Text('Press me'),\n"
    '  ),\n'
    ')';

const String _usageCode = '''
import 'package:elattar_design_system/elattar_design_system.dart';

ActionFeedback(
  spec: pressed ? Shadows.controlPressed : Shadows.controlPrimary,
  radius: BorderRadius.circular(Radii.full),
  border: Border.all(color: border, width: BorderWidths.hairline),
  hovered: hovered,
  pressed: pressed,
  child: const Text('Continue'),
)''';

/* ── Disclosure content ─────────────────────────────────────────────────── */

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'ActionFeedback adds no Semantics node of its own: it is a Stack '
            'of paint layers around whatever child it is given, and the '
            'child\'s own semantics (a Button\'s label and role, say) '
            'pass through unmodified.',
        'The ramp, the texture and the beat are all purely visual — none '
            'of it is announced to a screen reader.',
      ]);
}

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'ActionFeedback takes no focus and handles no key: there is no '
            'Focus, no FocusNode and no onKeyEvent anywhere in '
            'action_feedback.dart.',
        'hovered and pressed are booleans the caller hands in — in this '
            'system\'s real use, Button\'s own _hovered/_pressed state, '
            'which IS reachable by keyboard (Space/Enter sets _pressed). '
            'ActionFeedback itself never detects a pointer or a key.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'No MediaQuery or breakpoint branching anywhere in '
            'action_feedback.dart — radius, spec and border all arrive from '
            'the caller.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      _bullets(ThemeScope.of(context), <String>[
        'File: lib/src/components/ui/action_feedback.dart — one file, one public '
            'class, plus the two private painters that do the actual '
            'drawing.',
        'Flutter imports: dart:math, dart:ui, foundation.dart '
            '(@visibleForTesting), scheduler.dart (Ticker), widgets.dart.',
        'Foundation imports: foundation/colors.dart (OklabColor, Palette, '
            'transparent), foundation/motion.dart (effectiveMotionDuration, '
            'MotionDurations, MotionCurves), foundation/shadows.dart '
            '(ShadowStyle), foundation/theme.dart, theme_scope.dart, '
            'and surface.dart for the inner Surface it '
            'splices its ramp around.',
        'registryDependencies, resolved automatically by `elattar add '
            'action-feedback`: surface, source-foundation — copied '
            'verbatim from registry/components/action-feedback.json.',
        'Not a dependency of action_feedback.dart itself, but its one real '
            'consumer in the corpus: Button\'s primary variant paints '
            'itself with ActionFeedback rather than a plain '
            'Surface.',
      ]),
      SizedBox(height: space(3)),
      DocsLinkRow(
        links: <DocsLink>[
          const DocsLink(
            label: 'Machine Surface',
            route: '/components/surface',
          ),
          const DocsLink(label: 'Button', route: '/components/button'),
          const DocsLink(
            label: 'Source Foundation',
            route: '/components/source_foundation',
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
      _bullets(ThemeScope.of(context), <String>[
        'Every ramp stop is derived, never frozen: the five colours are '
            'OklabColor.mix blends of Palette.actionBright / .action / '
            '.actionDark, computed live rather than pasted in as hex — a '
            'rebrand of the action ramp carries through untouched.',
        'The texture\'s three layers (striations, diagonal sheen, corner '
            'light) and the beat\'s core colour are all alphas of the '
            'same Palette.actionBright, independent of light/dark.',
        'What DOES flip with the theme is the beat\'s own blend mode: '
            'screen on dark, multiply on light — the one mix-blend-mode '
            'in this system that depends on the theme, the same split '
            'feedback-surface carries for its own reason.',
        'The texture\'s blend (soft-light) does not flip: it is constant '
            'in both themes.',
      ]);
}

Widget _bullets(ThemeTokens theme, List<String> lines) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: <Widget>[
    for (final String line in lines) ...<Widget>[
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: LayoutWidths.prose),
        child: StyledText(
          '•  $line',
          TextStyles.small,
          color: theme.mutedForeground,
        ),
      ),
      SizedBox(height: space(2)),
    ],
  ],
);

const List<DocsApiFact> _sheenActionApiFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'spec',
    type: 'ShadowStyle',
    description:
        'Required. The --shadow-* token to paint: outer layers under the '
        'ramp, inset layers over it. The caller stays in charge of which '
        'spec is live (rest vs. pressed) — that state table belongs to '
        'the button, not to this surface.',
  ),
  DocsApiFact(
    name: 'radius',
    type: 'BorderRadius',
    description:
        'Required. The shape — the ramp, both pseudo-layers and the '
        'inset shadows are all clipped to it.',
  ),
  DocsApiFact(
    name: 'border',
    type: 'BoxBorder?',
    description: 'Optional. Painted over the inset shadows.',
  ),
  DocsApiFact(
    name: 'hovered',
    type: 'bool',
    description: 'Optional, defaults to false. Runs the beat on a 2600ms loop.',
  ),
  DocsApiFact(
    name: 'pressed',
    type: 'bool',
    description:
        'Optional, defaults to false. Retimes the beat to a single '
        '620ms pass and outranks hovered.',
  ),
  DocsApiFact(
    name: 'child',
    type: 'Widget',
    description: 'Required. Painted over the inset shadows and the ramp.',
  ),
];

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Rest',
    treatment:
        'hovered and pressed both false: _drive(null, Duration.zero) '
        'stops the clock and holds _beat at 0.',
    userSignal:
        'The ramp and the static texture render; the beat ::before layer '
        'sits at its base style — scale(0.55), opacity 0 — invisible.',
  ),
  DocsStateFact(
    state: 'Hovered',
    treatment:
        'A bare Ticker starts fresh at elapsed zero and phaseAt wraps it '
        'modulo MotionDurations.beatHover (2600ms) forever — a NEW animation '
        'every hover-in, never a resumed one.',
    userSignal:
        'A strong thump, a weaker echo, then 1196ms of held rest, on '
        'repeat for as long as the pointer stays inside.',
  ),
  DocsStateFact(
    state: 'Pressed',
    treatment:
        'The SAME animation retimes to MotionDurations.beatPress (620ms), '
        'iterating once: its elapsed time is preserved and re-divided by '
        'the shorter duration rather than restarting at frame 0 — '
        'verified on the reference to four significant figures.',
    userSignal:
        'Press early in a hover and the beat visibly jumps ahead; press '
        'the more usual couple of seconds in and the re-divided clock is '
        'already past its one iteration, so nothing plays at all for the '
        'whole hold — a real, documented, non-obvious case.',
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment:
        'effectiveMotionDuration resolves both beatHover and beatPress to '
        'Duration.zero regardless of hovered/pressed, so _drive never '
        'starts the Ticker and _beat stays at 0.',
    userSignal:
        'The beat never appears, in any state — only the static ramp '
        'and texture render, hover and press included.',
  ),
];
