/// Public documentation page for the `progress` component.
///
/// **Re-housed onto the kit.** This page used to hand-compose [Section]
/// panels shaped to mirror
/// https://ui.shadcn.com/docs/components/base/progress's own section list;
/// it now declares a [ComponentDocSpec] (`example/lib/docs/
/// component_doc_page.dart`) and hands it to [ComponentDocPage], the same
/// shape `button`, `field`, `popover`, `alert`, `toaster` and `spinner`
/// established. Every specimen widget and every code string below is the
/// same one the hand-composed page carried; new in this pass: the old
/// unheaded live demo is now a real Preview section with its own rail
/// entry, and the old combined "Accessibility and keyboard behavior"
/// section is split into its own Accessibility and Keyboard disclosures,
/// matching every other re-housed page's shape.
///
/// **Skipped, honestly.** `Composition` documents a `Progress.Root`/`Track`/
/// `Indicator`/`Label`/`Value` compound-widget tree; [Progress] is one
/// `StatelessWidget` with a `value`/`tone`/`label` surface and exposes no
/// such tree, so there is nothing to show. Its `With label and value`
/// subsection and the sibling `Label` section both answer the same reader
/// question, "how do I show text next to the bar", so this page answers it
/// once, under `Label and value`.
///
/// **Ours only.** `Download list` has no shadcn counterpart section: it was
/// already a built composition on the pre-split page, showing several tones
/// in one list rather than one bar in isolation, and stays for the same
/// reason.
///
/// **Corrected, not carried over.** The old page's Installation section
/// stated `registry/components/progress.json` does not exist and that
/// "none of this is resolved automatically today" -- false: the manifest
/// exists and `elattar add progress` resolves surface and
/// source-foundation automatically, exactly as `progress/meta.dart`'s own
/// [progressDoc.dependencies] already listed. The Installation section here
/// says so honestly instead.
///
/// **Motion.** `Progress`'s fill is a finite `ImplicitlyAnimatedWidget`
/// transition (it tweens once per value change, then stops), gated through
/// `effectiveMotionDuration` (`theme_scope.dart`) to `Duration.zero` under
/// `MediaQuery.disableAnimations`: confirmed by reading
/// `_AnimatedFractionalTranslation`'s duration parameter directly, and by
/// this page's own reduced-motion test case, which never calls
/// `tester.pumpAndSettle()`.
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

/// One static [Progress] specimen. Values and labels echo the reference's
/// own examples where `progress.dart`'s class doc quotes them verbatim
/// (`20.6`, `66.7`, and the drift-7 array's `{ tone: "default", label:
/// "Steps today", value: 72 }`): see drift 6 and drift 7 in
/// `lib/src/components/ui/progress.dart` for why the first bar below is
/// deliberately unlabelled.
class _ProgressSpecimen {
  const _ProgressSpecimen(this.value, this.tone, this.label);
  final double value;
  final ProgressTone tone;
  final String? label;
}

const List<_ProgressSpecimen> _progressSpecimens = <_ProgressSpecimen>[
  // No label: reproduces the reference's own drift 6 (page.tsx:339 is a
  // bare <Progress value={20.6} /> with no aria-label).
  _ProgressSpecimen(20.6, ProgressTone.normal, null),
  _ProgressSpecimen(66.7, ProgressTone.normal, 'Profile complete'),
  _ProgressSpecimen(72, ProgressTone.normal, 'Steps today'),
  _ProgressSpecimen(45, ProgressTone.value, 'Storage used'),
  _ProgressSpecimen(88, ProgressTone.success, 'Sync complete'),
  _ProgressSpecimen(34, ProgressTone.warning, 'Battery'),
  // destructive is for a reading OUTSIDE its safe band, per the enum's own
  // doc comment: not merely a low number.
  _ProgressSpecimen(92, ProgressTone.destructive, 'CPU temperature'),
];

final ComponentDocSpec progressDocSpec = ComponentDocSpec(
  name: 'progress',
  title: progressDoc.title,
  description: progressDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description: 'A determinate Progress reading.',
      specimen: _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'progress has a real registry manifest, `elattar add progress` '
          'installs lib/src/components/ui/progress.dart and resolves '
          'surface and source-foundation automatically. The '
          'Manual tab is for a project not using the CLI.',
      command: progressDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/progress.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/ui/progress.dart's generated "
              '@ui/progress.dart payload into components/ui.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated progress.dart payload here when '
              'using manual mode.',
        ),
        const DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so Progress and ProgressTone are '
              'reachable the same way the CLI path already makes them.',
          code: "export 'progress.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'The smallest correct call, then a realistic, tone-selected '
          'one. Reach for Progress the moment you can compute a '
          'fraction: a file upload, a multi-step wizard, a sync job '
          'reporting bytes done over bytes total. Reach for Spinner '
          'instead when you cannot compute a fraction and the wait is '
          'short; reach for Skeleton when you already know the shape '
          'of what is arriving.',
      code: _usageCode,
    ),
    ShowcaseSection(
      id: 'label-value',
      title: 'Label and value',
      description:
          'Progress has no separate ProgressLabel or ProgressValue '
          'widget: label is a single Semantics accessible-name '
          'parameter, and a visible percentage readout, like the '
          'reference\'s own "412 / 2,000" span, is presentation the '
          'caller composes beside the bar. These seven specimens pair a '
          'caller-drawn label and percentage with each bar, the shape '
          'the reference\'s own PROGRESS_TONES panels use (three '
          'default, one value, one success, one warning, one '
          'destructive).',
      specimen: _LabelValueSpecimen(),
      code: _labelValueCode,
      label: 'Label and value specimen view',
      minHeight: space(110),
    ),
    ShowcaseSection(
      id: 'controlled',
      title: 'Controlled',
      description:
          'A real, stateful Progress. Press "Advance" to see the fill '
          'tween into its new position under Progress.transition '
          '(250ms, MotionCurves.enter): this is the specimen the reduced '
          'motion section below drives to a single-pump landing.',
      specimen: _ProgressLiveSpecimen(),
      code: _controlledCode,
      label: 'Controlled specimen view',
    ),
    ShowcaseSection(
      id: 'rtl',
      title: 'RTL',
      description:
          'Progress renders under an ambient RTL Directionality '
          'without error, and its Semantics label and value announce '
          'correctly in either direction. One real gap: the fill\'s '
          'FractionalTranslation offset carries a fixed sign rather '
          'than one derived from Directionality.of(context), so the bar '
          'keeps filling from the physical left even under RTL, unlike '
          'a reference built on logical CSS properties. A reader '
          'building a fully mirrored RTL layout should know the fill '
          'itself will not flip.',
      specimen: _ProgressRtlDemo(),
      code: _rtlCode,
      label: 'RTL specimen view',
    ),
    ShowcaseSection(
      id: 'download-list',
      title: 'Download list',
      description:
          'Three Progress rows sharing a list, echoing the '
          'reference\'s own second PROGRESS_TONES panel: the composed '
          'shape a download manager or a sync status panel actually '
          'uses. Not part of the shadcn counterpart\'s own section '
          'list; added because a single bar in isolation understates '
          'how the tones read together.',
      specimen: _DownloadListComposition(),
      code: _downloadListCode,
      label: 'Download list specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'A presentational StatelessWidget with no onPressed, no '
          'GestureDetector, and no FocusNode: most of the usual state '
          'rows do not apply, so the ones that are genuinely N/A are '
          'grouped below with the reason instead of invented.',
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
      description:
          'None: Progress is never in the tab order. It is a '
          'read-only status indicator, matching the native ARIA '
          'progressbar role\'s own behavior.',
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
            value: progressDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'test/feedback_effects_test.dart',
            description:
                'group(\'Progress\'): tones, the translation formula, '
                'rasterised fill placement, and the drift-6 unlabelled '
                'bar.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/progress_test.dart',
            description:
                'Covers this page: the API tables, live specimens at '
                'several values, the interactive fill, and a dedicated '
                'reduced-motion case.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/progress/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class ProgressDocPage extends StatelessWidget {
  const ProgressDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: progressDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / BASE',
      title: progressDoc.title,
      description: progressDoc.description,
    ),
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Components'),
      BreadcrumbEntry.page('Progress'),
    ],
    toc: progressDocSpec.toc,
    previous: const DocsPageLink(title: 'Kbd', route: '/components/kbd'),
    next: const DocsPageLink(title: 'Skeleton', route: '/components/skeleton'),
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('progress-doc-article'),
      child: ComponentDocPage(spec: progressDocSpec, header: false),
    ),
  );
}

/* ── Showcase specimens ─────────────────────────────────────────────────── */

class _PreviewSpecimen extends StatelessWidget {
  const _PreviewSpecimen();

  @override
  Widget build(BuildContext context) => const KeyedSubtree(
    key: ValueKey<String>('progress-example:preview'),
    child: Progress(value: 66.7, label: 'Profile complete'),
  );
}

const String _previewCode = '''Progress(
  value: 66.7,
  label: 'Profile complete',
)''';

const String _usageCode = '''
// The smallest correct call: tone defaults to normal, label is optional.
Progress(value: 62)

// A labelled, tone-selected bar for a real status.
Progress(
  value: syncedBytes / totalBytes * 100,
  tone: ProgressTone.value,
  label: 'Sync progress',
)''';

/// One [Progress] specimen with its value printed beside it: the docs
/// page's own presentation, not part of Progress's API.
class _LabelledProgress extends StatelessWidget {
  const _LabelledProgress({required this.spec});

  final _ProgressSpecimen spec;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: StyledText(
                spec.label ?? '(no label: reproduces reference drift 6)',
                TextStyles.small,
                color: spec.label == null
                    ? theme.mutedForeground
                    : theme.foreground,
              ),
            ),
            StyledText(
              '${spec.value.round()}%',
              TextStyles.small,
              color: theme.mutedForeground,
            ),
          ],
        ),
        SizedBox(height: space(2)),
        KeyedSubtree(
          key: ValueKey<String>(
            'progress-preview:${spec.tone.name}:${spec.value}',
          ),
          child: Progress(
            value: spec.value,
            tone: spec.tone,
            label: spec.label,
          ),
        ),
      ],
    );
  }
}

class _LabelValueSpecimen extends StatelessWidget {
  const _LabelValueSpecimen();

  @override
  Widget build(BuildContext context) => Column(
    key: const ValueKey<String>('progress-example:label-value'),
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      for (final _ProgressSpecimen spec in _progressSpecimens) ...<Widget>[
        _LabelledProgress(spec: spec),
        SizedBox(height: space(4)),
      ],
    ],
  );
}

const String _labelValueCode = '''
// Reproduces the reference's own drift 6: the first bar has no label.
Progress(value: 20.6)

Progress(value: 66.7, label: 'Profile complete')
Progress(value: 72, label: 'Steps today')
Progress(value: 45, tone: ProgressTone.value, label: 'Storage used')
Progress(value: 88, tone: ProgressTone.success, label: 'Sync complete')
Progress(value: 34, tone: ProgressTone.warning, label: 'Battery')
Progress(value: 92, tone: ProgressTone.destructive, label: 'CPU temperature')''';

/// The one specimen the docs test drives: a real, stateful [Progress] a
/// reader (and the reduced-motion test) can advance step by step.
class _ProgressLiveSpecimen extends StatefulWidget {
  const _ProgressLiveSpecimen();

  @override
  State<_ProgressLiveSpecimen> createState() => _ProgressLiveSpecimenState();
}

class _ProgressLiveSpecimenState extends State<_ProgressLiveSpecimen> {
  static const double _step = 20;

  double _value = 20;

  void _advanceOrReset() => setState(() {
    _value = _value >= 100 ? 0 : (_value + _step).clamp(0, 100);
  });

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final bool atMax = _value >= 100;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Progress(
          key: const ValueKey<String>('progress-doc-live-specimen'),
          value: _value,
          tone: ProgressTone.value,
          label: 'Uploading report.pdf',
        ),
        SizedBox(height: space(3)),
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: space(3),
          runSpacing: space(2),
          children: <Widget>[
            StyledText(
              '${_value.round()}%, Uploading report.pdf',
              TextStyles.small,
              color: theme.mutedForeground,
            ),
            Button(
              key: const ValueKey<String>('progress-doc-simulate-button'),
              variant: ButtonVariant.secondary,
              size: ButtonSize.sm,
              label: atMax ? 'Reset upload' : 'Advance upload 20%',
              onPressed: _advanceOrReset,
              child: StyledText(
                atMax ? 'Reset' : 'Advance 20%',
                TextStyles.buttonLabel,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

const String _controlledCode = '''
double value = 20;

Progress(
  value: value,
  tone: ProgressTone.value,
  label: 'Uploading report.pdf',
)

// Press to advance: setState(() => value = (value + 20).clamp(0, 100));''';

/// A single [Progress] rendered under an ambient RTL [Directionality]:
/// see `RTL`'s own description for what does, and does not, mirror.
class _ProgressRtlDemo extends StatelessWidget {
  const _ProgressRtlDemo();

  @override
  Widget build(BuildContext context) => const Directionality(
    key: ValueKey<String>('progress-example:rtl'),
    textDirection: TextDirection.rtl,
    child: Progress(
      value: 66.7,
      tone: ProgressTone.value,
      label: 'اكتمال التحميل',
    ),
  );
}

const String _rtlCode = '''Directionality(
  textDirection: TextDirection.rtl,
  child: Progress(
    value: 66.7,
    tone: ProgressTone.value,
    label: 'اكتمال التحميل',
  ),
)''';

/// Three [Progress] rows sharing a list: the composed shape a download
/// manager or a sync status panel actually uses, echoing the reference's own
/// PROGRESS_TONES second panel.
class _DownloadListComposition extends StatelessWidget {
  const _DownloadListComposition();

  static const List<(String, double, ProgressTone)> _rows =
      <(String, double, ProgressTone)>[
        ('quarterly-report.pdf', 100, ProgressTone.success),
        ('design-assets.zip', 54, ProgressTone.value),
        ('backup.tar.gz', 8, ProgressTone.normal),
      ];

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Column(
      key: const ValueKey<String>('progress-example:download-list'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        for (int i = 0; i < _rows.length; i++) ...<Widget>[
          if (i > 0) SizedBox(height: space(4)),
          Row(
            children: <Widget>[
              Expanded(
                child: StyledText(
                  _rows[i].$1,
                  TextStyles.small,
                  color: theme.foreground,
                ),
              ),
              StyledText(
                _rows[i].$2 >= 100 ? 'Done' : '${_rows[i].$2.round()}%',
                TextStyles.small,
                color: theme.mutedForeground,
              ),
            ],
          ),
          SizedBox(height: space(1.5)),
          Progress(value: _rows[i].$2, tone: _rows[i].$3, label: _rows[i].$1),
        ],
      ],
    );
  }
}

const String _downloadListCode = '''Column(
  children: [
    Progress(value: 100, tone: ProgressTone.success, label: 'quarterly-report.pdf'),
    Progress(value: 54, tone: ProgressTone.value, label: 'design-assets.zip'),
    Progress(value: 8, tone: ProgressTone.normal, label: 'backup.tar.gz'),
  ],
)''';

/* ── Disclosure content ─────────────────────────────────────────────────── */

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsApiTable(
        title: 'Progress properties',
        facts: <DocsApiFact>[
          DocsApiFact(
            name: 'value',
            type: 'double',
            description:
                'Required. 0…100. Clamped before use, so an '
                'out-of-range caller value cannot overshoot the '
                'channel.',
          ),
          DocsApiFact(
            name: 'tone',
            type: 'ProgressTone',
            description:
                'Defaults to ProgressTone.normal. Selects the fill '
                'ink and shadow: see the tone table below.',
          ),
          DocsApiFact(
            name: 'label',
            type: 'String?',
            description:
                'Optional Semantics accessible name. Null reproduces '
                'the reference\'s own first bar, which ships with no '
                'aria-label: see Accessibility for why this matters.',
          ),
        ],
      ),
      SizedBox(height: space(6)),
      const DocsApiTable(
        title: 'Progress static members',
        facts: <DocsApiFact>[
          DocsApiFact(
            name: 'Progress.height',
            type: 'static double',
            description:
                'The channel height, 10px (h-2.5). A fixed constant: '
                'progress has a tone axis, not a size axis.',
          ),
          DocsApiFact(
            name: 'Progress.transition',
            type: 'static Duration',
            description:
                'MotionDurations.normal (250ms): the fill\'s '
                'own transform transition, gated through '
                'effectiveMotionDuration.',
          ),
        ],
      ),
      SizedBox(height: space(6)),
      const DocsApiTable(
        title: 'ProgressTone',
        facts: <DocsApiFact>[
          DocsApiFact(
            name: 'normal',
            type: 'filled: the default',
            description:
                'Fills with theme.actionText under Shadows.controlPrimary. '
                'Spelled "normal" rather than "default" because '
                'default is a Dart keyword; .label still reports '
                '"default".',
          ),
          DocsApiFact(
            name: 'value',
            type: 'filled',
            description:
                'Fills with theme.premiumText under Shadows.controlPremium, '
                'the one tone that leaves the action ramp, because '
                'progression toward a reward is a value signal.',
          ),
          DocsApiFact(
            name: 'success',
            type: 'filled',
            description: 'Fills with theme.successText under Shadows.control.',
          ),
          DocsApiFact(
            name: 'warning',
            type: 'filled',
            description: 'Fills with theme.warningText under Shadows.control.',
          ),
          DocsApiFact(
            name: 'destructive',
            type: 'filled',
            description:
                'Fills with theme.destructiveText under Shadows.control. '
                'For a reading OUTSIDE its safe band: a temperature or '
                'error rate too high: never merely for a number that '
                'fell; a figure moving the wrong way is news, not a '
                'fault, and stays on normal.',
          ),
        ],
      ),
    ],
  );
}

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Value change',
    treatment:
        'The indicator translates from its old position to its new '
        'one over Progress.transition (250ms, MotionCurves.enter): a '
        'transform, not a width change.',
    userSignal:
        'The fill visibly slides to its new position rather than '
        'jumping or resizing.',
  ),
  DocsStateFact(
    state: 'Error / Success',
    treatment:
        'Not a live transition on one bar: choose '
        'ProgressTone.destructive or .success at construction time '
        'instead. See the tone table in API Reference.',
    userSignal: 'A different progress instance, not a state change.',
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment:
        'MediaQuery.disableAnimations collapses the transition to '
        'Duration.zero via effectiveMotionDuration: the fill lands on its '
        'target translation without a tween.',
    userSignal:
        'The progress bar jumps straight to its value: confirmed by '
        'this page\'s docs test.',
  ),
  DocsStateFact(
    state:
        'Hover / Focus-visible / Pressed / Selected / Empty / Disabled '
        '/ Loading',
    treatment:
        'N/A: the widget carries no gesture, focus, or async-flag '
        'parameter to hold any of these; it is pure paint from its '
        'constructor arguments.',
    userSignal:
        'It does not respond to pointer or keyboard input; there is '
        'nothing to hover, focus, press, select, or disable.',
  ),
];

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Semantic role: a Semantics node wraps the whole widget with '
            "value: '\${value.round()}%': every progress bar announces "
            'its percentage regardless of whether label is set. This '
            'is the one part of the brief that is fully met: a '
            'determinate progress bar here does announce its value.',
        'Accessible name (label): OPTIONAL, and null by default. A '
            'real gap, not a design choice: a bar built with no label '
            'reads to a screen reader as an unnamed control reporting '
            '"62%", with no indication of what is 62% complete. The '
            'default value reproduces the reference\'s own drift 6 '
            'rather than silently fixing it. Pass label explicitly for '
            'anything the surrounding context does not already make '
            'obvious.',
        'Non-colour signal: the Semantics value string carries the '
            'number independent of the fill\'s hue, so a tone change '
            '(success/warning/destructive) is never the only signal.',
      ]);
}

/// New: split out of the old combined "Accessibility and keyboard
/// behavior" section, matching `button`, `field`, `popover`, `alert`,
/// `toaster` and `spinner`'s own dedicated Keyboard disclosure.
class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'No key handling of its own: progress.dart wires no Focus, '
            'FocusNode, or onKeyEvent anywhere. Progress is never in '
            'the tab order: it is a read-only status indicator, '
            'matching the native ARIA progressbar role\'s own '
            'behavior.',
        'No FocusTraversalPolicy either, since there is nothing here '
            'to traverse to. Tab and Shift+Tab walk straight past a '
            'progress bar to whatever the surrounding page declares '
            'next.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'No breakpoint reads from BuildContext, and no platform '
            'branch: the same widget tree renders at 390px and 1440px '
            'and on every target platform.',
        'Progress takes its width from its parent\'s constraints '
            '(there is no width parameter); only its 10px height is '
            'fixed. A caller that wants a narrower bar wraps it in a '
            'SizedBox or a ConstrainedBox: the component itself never '
            'clamps width.',
        'Platform parity: Android, iOS, Web, macOS, Windows and Linux '
            'all render the same widget tree.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      DocsInstallFacts(
        facts: <DocsInstallFact>[
          const DocsInstallFact(
            label: 'Registry item',
            value: 'progress',
            description:
                'registry/components/progress.json exists and is '
                'installable through the CLI today.',
          ),
          const DocsInstallFact(
            label: 'Destination',
            value: 'lib/components/ui/progress.dart',
            description:
                'The same lib/components/ui/ target every component '
                'installs to.',
          ),
          const DocsInstallFact(
            label: 'Files',
            value: 'lib/src/components/ui/progress.dart',
            description:
                'One file (a private _AnimatedFractionalTranslation '
                'helper included).',
          ),
          const DocsInstallFact(
            label: 'Package imports',
            value:
                'foundation/motion.dart, foundation/shadows.dart, '
                'foundation/spacing.dart, foundation/theme.dart, '
                'effects/surface.dart, theme_scope.dart',
            description:
                'Surface paints the channel and the fill; the '
                'rest are the shared motion, shadow, spacing, theme '
                'and theme-mode primitives every component reads.',
          ),
          DocsInstallFact(
            label: 'Dependencies',
            value: progressDoc.dependencies.join(', '),
            description:
                "registry/components/progress.json's own "
                'registryDependencies, resolved automatically by '
                '`elattar add progress`.',
          ),
          const DocsInstallFact(
            label: 'Assets, fonts, shaders',
            value: 'none',
            description:
                'The fill and channel are Surface layers: box '
                'shadows and solid fills, not a fragment shader.',
          ),
          const DocsInstallFact(
            label: 'Platforms',
            value: 'Android, iOS, Web, macOS, Windows, Linux',
            description: 'No platform-conditional code in progress.dart.',
          ),
        ],
      ),
      SizedBox(height: space(4)),
      const DocsLinkRow(
        links: <DocsLink>[
          DocsLink(label: 'Spinner', route: '/components/spinner'),
          DocsLink(label: 'Skeleton', route: '/components/skeleton'),
          DocsLink(label: 'Surface', route: '/components/surface'),
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
        'Every colour comes from the live theme: theme.muted/.input '
            'for the channel, and ProgressTone.inkOf(theme): one of '
            'actionText/premiumText/successText/warningText/destructiveText, '
            'for the fill. Flipping ThemeController re-resolves both '
            'on every rebuild; nothing is cached.',
        'Progress declares no colour-override parameter of its own, '
            'every fill is tone-derived, the same rule Badge follows '
            'for its variants.',
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
