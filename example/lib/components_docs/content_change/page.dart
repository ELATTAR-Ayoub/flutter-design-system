/// Public documentation page for the `content-change` motion primitive.
///
/// **Why `EffectSection`, not `ShowcaseSection`.** `ContentChange` has no variant
/// enum and paints nothing of its own — it is a `Transform.scale` +
/// `Opacity` wrapper around whatever `child` it is handed. A `ShowcaseSection`
/// stages a specimen on its own terms; `EffectSection` stages the host the
/// spring is applied to, which is the only way to show "content replacing
/// content in the same slot" — the exact case the source's own docstring
/// names — rather than a bare animated box with nothing to compare it to.
///
/// **Section list.** Preview contrasts the spring against a plain instant
/// replace. Stat Figure reproduces this port's one real corpus consumer
/// (`lib/src/components/stat.dart`) faithfully. Replay Key is the source's
/// own documented split, quoted directly from its class doc: a widget keyed
/// on [replayKey] restarts the spring every time that key changes (`Stat`'s
/// figure, keyed on state); a widget that keeps the same [replayKey] plays
/// once, at mount, and never again — even while its own content changes
/// underneath it (the data table's sortable rows, cited by the same
/// docstring, probed with `animation-name` staying put across a sort).
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

final ComponentDocSpec swapInDocSpec = ComponentDocSpec(
  name: 'content_change',
  title: 'Swap In',
  description:
      'A 250ms spring pop — opacity 0 to 1, scale 0.96 to 1 — for content '
      'replacing content in the same slot: a figure that just changed value, '
      'never a fresh mount that should read as an arrival from nowhere.',
  sections: <DocsPageSection>[
    EffectSection(
      id: 'preview',
      title: 'Preview',
      description:
          'The source names the reason this exists: a linear fade on '
          'content replacing content in the same slot reads as a re-render, '
          'not as a state change the reader just caused. The left figure '
          'springs on every change; the right one is replaced outright, no '
          'transition at all.',
      host: _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'content-change has a real registry manifest: `elattar add content-change` '
          'installs lib/src/components/ui/content_change.dart and resolves both '
          'registryDependencies automatically. The Manual tab is for a '
          'project not using the CLI.',
      command: contentChangeDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/motion/content_change.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/ui/content_change.dart's generated "
              '@ui/content_change.dart payload into your motion folder.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated content-change source here when using manual '
              'mode.',
        ),
        DocsCodeFile(
          path: 'lib/motion/motion.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so ContentChange is reachable the same way '
              'the CLI path already makes it.',
          code: "export 'content_change.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'Wrap the content that just changed. Pass replayKey to restart '
          'the spring on a genuine value change — omit it and the spring '
          'plays exactly once, at mount.',
      code: _usageCode,
    ),
    EffectSection(
      id: 'stat-figure',
      title: 'Stat Figure',
      description:
          "lib/src/components/stat.dart's own composition: the arriving "
          'figure is wrapped ContentChange(replayKey: state, …), so a loading '
          '→ ready transition — a changed React key in the reference, a '
          'changed replayKey here — remounts the figure and the spring '
          'replays.',
      host: _StatFigureSpecimen(),
      code: _statFigureCode,
      label: 'Stat Figure specimen view',
    ),
    EffectSection(
      id: 'replay-key',
      title: 'Replay Key',
      description:
          "The source's own documented split. Keyed (left): replayKey "
          'changes with the value, so every change remounts the node and '
          'replays the spring — Stat\'s own behaviour. Unkeyed (right): '
          'replayKey stays null, so the spring plays once at mount and '
          'never again, even while the visible text keeps changing — the '
          "data table's sortable rows, which keep the same DOM node across "
          'a sort and do not replay.',
      host: _ReplayKeySpecimen(),
      code: _replayKeyCode,
      label: 'Replay Key specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every constructor parameter ContentChange declares, plus its two '
          'public static values.',
      child: _ApiReferenceContent(),
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
            value: contentChangeDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'test/motion_test.dart',
            description:
                'ContentChange is covered inside the shared motion suite: there '
                'is no dedicated swap_in_test.dart in the package yet.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/swap_in_test.dart',
            description:
                'Covers this page: the article mounts, the full API table, '
                'the keyed/unkeyed distinction, and both themes.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/content_change/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class ContentChangeDocPage extends StatelessWidget {
  const ContentChangeDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: contentChangeDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / MOTION',
      title: contentChangeDoc.title,
      description: contentChangeDoc.description,
    ),
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Components'),
      BreadcrumbEntry.page('Swap In'),
    ],
    toc: swapInDocSpec.toc,
    previous: const DocsPageLink(
      title: 'Sliding Pill',
      route: '/components/active_indicator',
    ),
    next: null,
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('content-change-doc-article'),
      child: ComponentDocPage(spec: swapInDocSpec, header: false),
    ),
  );
}

/* ── Effect specimens ───────────────────────────────────────────────────── */

Widget _caption(BuildContext context, String label) => StyledText(
  label,
  TextStyles.caption,
  color: ThemeScope.of(context).mutedForeground,
);

class _PreviewSpecimen extends StatelessWidget {
  const _PreviewSpecimen();

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _caption(context, 'Springs in'),
          SizedBox(height: space(3)),
          const KeyedSubtree(
            key: ValueKey<String>('content-change-preview:springs'),
            child: _SpringPreview(),
          ),
        ],
      ),
      SizedBox(width: space(10)),
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _caption(context, 'Replaces instantly'),
          SizedBox(height: space(3)),
          const KeyedSubtree(
            key: ValueKey<String>('content-change-preview:instant'),
            child: _InstantPreview(),
          ),
        ],
      ),
    ],
  );
}

const String _previewCode =
    '// Springs in — the effect this page documents\n'
    'ContentChange(\n'
    '  replayKey: value,\n'
    '  child: StyledText(value.toString(), TextStyles.numberLg),\n'
    ')\n\n'
    '// Replaces instantly — no ContentChange, the plain comparison\n'
    'StyledText(value.toString(), TextStyles.numberLg)';

class _SpringPreview extends StatefulWidget {
  const _SpringPreview();

  @override
  State<_SpringPreview> createState() => _SpringPreviewState();
}

class _SpringPreviewState extends State<_SpringPreview> {
  int _value = 12;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return GestureDetector(
      onTap: () => setState(() => _value += 1),
      child: ContentChange(
        replayKey: _value,
        child: StyledText(
          '$_value',
          TextStyles.numberLg,
          color: theme.foreground,
        ),
      ),
    );
  }
}

class _InstantPreview extends StatefulWidget {
  const _InstantPreview();

  @override
  State<_InstantPreview> createState() => _InstantPreviewState();
}

class _InstantPreviewState extends State<_InstantPreview> {
  int _value = 12;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return GestureDetector(
      onTap: () => setState(() => _value += 1),
      child: StyledText(
        '$_value',
        TextStyles.numberLg,
        color: theme.foreground,
      ),
    );
  }
}

class _StatFigureSpecimen extends StatefulWidget {
  const _StatFigureSpecimen();

  @override
  State<_StatFigureSpecimen> createState() => _StatFigureSpecimenState();
}

class _StatFigureSpecimenState extends State<_StatFigureSpecimen> {
  int _value = 128;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return KeyedSubtree(
      key: const ValueKey<String>('content-change-example:stat-figure'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          StyledText(
            'Active users',
            TextStyles.small,
            color: theme.mutedForeground,
          ),
          SizedBox(height: space(2)),
          ContentChange(
            replayKey: _value,
            child: StyledText(
              '$_value',
              TextStyles.numberLg,
              color: theme.foreground,
            ),
          ),
          SizedBox(height: space(3)),
          Button(
            variant: ButtonVariant.outline,
            size: ButtonSize.sm,
            onPressed: () => setState(() => _value += 7),
            child: const Text('Refresh'),
          ),
        ],
      ),
    );
  }
}

const String _statFigureCode =
    'Widget figure;\n'
    'if (loading) {\n'
    '  figure = Skeleton(width: w, height: h);\n'
    '} else {\n'
    '  figure = ContentChange(\n'
    '    // <span key={state}> — a loading -> ready swap replays it.\n'
    '    replayKey: state,\n'
    '    child: StyledText(value, TextStyles.numberLg),\n'
    '  );\n'
    '}';

class _ReplayKeySpecimen extends StatefulWidget {
  const _ReplayKeySpecimen();

  @override
  State<_ReplayKeySpecimen> createState() => _ReplayKeySpecimenState();
}

class _ReplayKeySpecimenState extends State<_ReplayKeySpecimen> {
  int _revision = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Wrap(
          spacing: space(10),
          runSpacing: space(4),
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _caption(context, 'Keyed (replays)'),
                SizedBox(height: space(3)),
                KeyedSubtree(
                  key: const ValueKey<String>(
                    'content-change-example:replay-keyed',
                  ),
                  child: ContentChange(
                    replayKey: _revision,
                    child: StyledText(
                      'Row $_revision',
                      TextStyles.body,
                      color: theme.foreground,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _caption(context, 'Unkeyed (plays once)'),
                SizedBox(height: space(3)),
                KeyedSubtree(
                  key: const ValueKey<String>(
                    'content-change-example:replay-unkeyed',
                  ),
                  child: ContentChange(
                    child: StyledText(
                      'Row $_revision',
                      TextStyles.body,
                      color: theme.foreground,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: space(4)),
        Button(
          variant: ButtonVariant.ghost,
          size: ButtonSize.sm,
          onPressed: () => setState(() => _revision += 1),
          child: const Text('Change both'),
        ),
      ],
    );
  }
}

const String _replayKeyCode =
    '// Keyed: the spring restarts every time value changes\n'
    'ContentChange(replayKey: value, child: Text(\'Row \$value\'))\n\n'
    '// Unkeyed: same node, same widget — content changes, spring does not\n'
    'ContentChange(child: Text(\'Row \$value\'))';

const String _usageCode = '''
import 'package:elattar_design_system/elattar_design_system.dart';

ContentChange(
  replayKey: state,
  child: StyledText(value, TextStyles.numberLg),
)''';

/* ── Disclosure content ─────────────────────────────────────────────────── */

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsApiTable(title: 'ContentChange', facts: _swapInApiFacts),
      SizedBox(height: space(6)),
      const DocsApiTable(
        title: 'ContentChange static values',
        facts: _swapInStaticFacts,
      ),
    ],
  );
}

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Decorative by itself: ContentChange sets no Semantics node and '
            'contributes no accessible name. Whatever semantics child '
            'carries reach the tree unchanged, exactly as if child were '
            'rendered with no wrapper at all.',
        'Content, not container: this widget never hides or excludes '
            'anything from the semantics tree — unlike IconSwap, there is '
            'no "previous value" to exclude, since child is simply replaced.',
      ]);
}

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'ContentChange takes no focus and handles no key: it is an '
            'KeyframePlayer wrapping Opacity and Transform.scale, nothing '
            'that reads input.',
        'Whatever keyboard story child has (a focusable row, an '
            'interactive figure) is untouched — the spring plays over it, '
            'not instead of it.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'No breakpoint branching anywhere in content_change.dart: BuildContext '
            'width is never read.',
        'The scale target (0.96 to 1) is a fixed fraction, not a pixel '
            'value, so it scales with whatever size child already is at — '
            'the same spring reads correctly on a numLg stat figure or a '
            'single table cell.',
        'Platform parity: no dart:io Platform branch in the file.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      _bullets(ThemeScope.of(context), <String>[
        'File: lib/src/components/ui/content_change.dart: one file, no companions; the '
            'registry manifest lists exactly one entry under "files".',
        'Flutter imports: package:flutter/widgets.dart only.',
        'Foundation imports: foundation/motion.dart (MotionDurations.normal, '
            'MotionCurves.emphasized), motion/keyframes.dart (KeyframePlayer, the '
            'player this file is built on).',
        'registryDependencies, resolved automatically by `elattar add '
            'content-change`: keyframes, source-foundation — copied verbatim from '
            'registry/components/content-change.json.',
        'Not a dependency of content_change.dart itself, but its one live '
            'consumer in the corpus: Stat\'s arriving figure.',
      ]),
      SizedBox(height: space(4)),
      const DocsLinkRow(
        links: <DocsLink>[
          DocsLink(label: 'Stat', route: '/components/stat'),
          DocsLink(label: 'Keyframes', route: '/components/keyframes'),
          DocsLink(
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
        'No colour of its own: content_change.dart never reads ThemeScope.of'
            '(context) and paints nothing but child. Colour comes entirely '
            'from child\'s own styling.',
        'Flipping ThemeController changes nothing at this layer: the '
            'spring itself has no theme-aware state, only opacity and '
            'scale.',
        'The one thing this file reads through the theme scope is motion: '
            'KeyframePlayer routes duration through '
            'effectiveMotionDuration(context, …) internally, so '
            'MediaQuery.disableAnimations lands the spring on its end '
            'frame instantly.',
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

const List<DocsApiFact> _swapInApiFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'child',
    type: 'Widget',
    description: 'Required. The content the spring is applied to.',
  ),
  DocsApiFact(
    name: 'replayKey',
    type: 'Object?',
    description:
        'Optional. Defaults to null. Change it to re-run the spring, '
        'exactly as a changed React key remounts a node and restarts a CSS '
        'animation. Left null, the spring plays once, at mount, and never '
        'again — even while child keeps changing underneath it.',
  ),
];

const List<DocsApiFact> _swapInStaticFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'duration',
    type: 'static Duration',
    description: 'MotionDurations.normal — 250ms. var(--duration-base).',
  ),
  DocsApiFact(
    name: 'curve',
    type: 'static Curve',
    description: 'MotionCurves.emphasized. var(--ease-spring).',
  ),
];

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Mount (or replayKey changes)',
    treatment:
        'KeyframePlayer plays 0 to 1 over MotionDurations.normal (250ms) on '
        'MotionCurves.emphasized; opacity and scale both read the same eased t, '
        'opacity clamped 0..1, scale interpolated 0.96 to 1.',
    userSignal:
        'child fades and grows in together, with the spring\'s own '
        'overshoot on the scale leg before it settles at 1.',
  ),
  DocsStateFact(
    state: 'child changes, replayKey does not',
    treatment:
        'KeyframePlayer is not re-keyed, so the same State object keeps '
        'running: the spring does not restart, because nothing asked it '
        'to.',
    userSignal:
        'The new content appears with no animation at all — it was never '
        'playing again in the first place.',
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment:
        'KeyframePlayer routes its duration through effectiveMotionDuration '
        'internally, with KeyframeFill.both holding the end frame.',
    userSignal:
        'child lands at opacity 1, scale 1 immediately — no pop, no '
        'settle.',
  ),
];
