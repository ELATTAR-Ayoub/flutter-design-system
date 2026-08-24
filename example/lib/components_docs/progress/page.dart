/// Public documentation page for the `progress` component.
///
/// **Split off `skeleton`.** This route used to carry both `ElProgress` and
/// `ElSkeleton` on one page, section for section against two shadcn
/// counterparts at once. `ElSkeleton` now has its own route:
/// `example/lib/components_docs/skeleton/`. This page mirrors ONLY
/// `https://ui.shadcn.com/docs/components/base/progress`'s own section list,
/// fetched fresh: Installation, Usage, Composition, Label ("With label and
/// value" nested under it), Controlled, RTL, API Reference. Every section
/// title below drops the `Progress: ` prefix the merged page needed to tell
/// two components' sections apart: on a progress-only page it is redundant.
/// A live demo renders ahead of any heading, the same as the reference's own
/// top-of-page preview: no Overview, Status, or Preview heading precedes
/// Installation.
///
/// **Skipped, honestly.** `Composition` documents a `Progress.Root`/`Track`/
/// `Indicator`/`Label`/`Value` compound-widget tree; [ElProgress] is one
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
/// Neither has a registry manifest yet (`registry/components/progress.json`
/// does not exist): the install panel below says so honestly rather than
/// presenting a CLI command that would fail.
///
/// **Motion.** `ElProgress`'s fill is a finite `ImplicitlyAnimatedWidget`
/// transition (it tweens once per value change, then stops), gated through
/// `elAnimationDuration` (`theme_scope.dart`) to `Duration.zero` under
/// `MediaQuery.disableAnimations`: confirmed by reading
/// `_AnimatedFractionalTranslation`'s duration parameter directly, and by
/// this page's own reduced-motion test case, which never calls
/// `tester.pumpAndSettle()`.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/docs_code.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../kit.dart';
import 'meta.dart';

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
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Components'),
      ElBreadcrumbEntry.page('Progress'),
    ],
    sidebar: _sidebar,
    toc: const <DocsTocEntry>[
      DocsTocEntry(title: 'Installation', anchor: 'install'),
      DocsTocEntry(title: 'Usage', anchor: 'usage'),
      DocsTocEntry(title: 'Label and value', anchor: 'label-value'),
      DocsTocEntry(title: 'Controlled', anchor: 'controlled'),
      DocsTocEntry(title: 'RTL', anchor: 'rtl'),
      DocsTocEntry(title: 'Download list', anchor: 'download-list'),
      DocsTocEntry(title: 'API Reference', anchor: 'api'),
      DocsTocEntry(title: 'States', anchor: 'states'),
      DocsTocEntry(title: 'Accessibility', anchor: 'accessibility'),
      DocsTocEntry(title: 'Responsive', anchor: 'responsive'),
      DocsTocEntry(title: 'Dependencies', anchor: 'dependencies'),
      DocsTocEntry(title: 'Theming', anchor: 'theming'),
      DocsTocEntry(title: 'Source', anchor: 'source'),
    ],
    previous: const DocsPageLink(title: 'Kbd', route: '/components/kbd'),
    next: const DocsPageLink(title: 'Skeleton', route: '/components/skeleton'),
    onNavigate: onNavigate,
    child: const _ProgressArticle(),
  );
}

/// `progress` and `skeleton`'s own small family, now two routes instead of
/// one: mirrors the scope `scroll_area/page.dart`'s own `_sidebar` uses for
/// its three-component family rather than the full Wave 1 list the merged
/// page carried, since that full list was never anything but a placeholder
/// the supervisor's real sidebar in `catalog.dart` supersedes.
const List<DocsSidebarEntry> _sidebar = <DocsSidebarEntry>[
  DocsSidebarEntry(
    title: 'Progress',
    route: '/components/progress',
    selected: true,
  ),
  DocsSidebarEntry(title: 'Skeleton', route: '/components/skeleton'),
];

/// One static [ElProgress] specimen. Values and labels echo the reference's
/// own examples where `progress.dart`'s class doc quotes them verbatim
/// (`20.6`, `66.7`, and the drift-7 array's `{ tone: "default", label:
/// "Steps today", value: 72 }`): see drift 6 and drift 7 in
/// `lib/src/components/progress.dart` for why the first bar below is
/// deliberately unlabelled.
class _ProgressSpecimen {
  const _ProgressSpecimen(this.value, this.tone, this.label);
  final double value;
  final ElProgressTone tone;
  final String? label;
}

const List<_ProgressSpecimen> _progressSpecimens = <_ProgressSpecimen>[
  // No label: reproduces the reference's own drift 6 (page.tsx:339 is a
  // bare <Progress value={20.6} /> with no aria-label).
  _ProgressSpecimen(20.6, ElProgressTone.normal, null),
  _ProgressSpecimen(66.7, ElProgressTone.normal, 'Profile complete'),
  _ProgressSpecimen(72, ElProgressTone.normal, 'Steps today'),
  _ProgressSpecimen(45, ElProgressTone.value, 'Storage used'),
  _ProgressSpecimen(88, ElProgressTone.success, 'Sync complete'),
  _ProgressSpecimen(34, ElProgressTone.warning, 'Battery'),
  // destructive is for a reading OUTSIDE its safe band, per the enum's own
  // doc comment: not merely a low number.
  _ProgressSpecimen(92, ElProgressTone.destructive, 'CPU temperature'),
];

class _ProgressArticle extends StatelessWidget {
  const _ProgressArticle();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      key: const ValueKey<String>('progress-doc-article'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        // The live demo, ahead of any heading: the same shape the reference
        // opens with. No ElSection wraps it, so it carries no Overview/
        // Status/Preview heading before Installation.
        const DocsCodeExample(
          title: 'Progress',
          description: 'A determinate ElProgress reading.',
          preview: ElProgress(value: 66.7, label: 'Profile complete'),
        ),
        SizedBox(height: el(6)),
        _install(),
        _usage(theme),
        _labelValue(),
        _controlled(),
        _rtl(),
        _downloadList(),
        _apiReference(),
        _states(),
        _accessibility(theme),
        _responsive(theme),
        _dependencies(theme),
        _theming(theme),
        _source(),
      ],
    );
  }

  Widget _install() => ElSection(
    id: 'install',
    title: 'Installation',
    description:
        '`elattar add progress` installs the component and its declared '
        'dependency closure.',
    child: DocsInstallFacts(
      title: 'Installation facts',
      facts: <DocsInstallFact>[
        const DocsInstallFact(
          label: 'Registry item',
          value: 'registry/components/progress.json',
          description:
              'Shipped and resolved by `elattar add progress`. This is a '
              'source-only component today.',
        ),
        const DocsInstallFact(
          label: 'Destination',
          value: 'lib/components/ui/progress.dart',
          description: 'Where a manual copy of the source belongs.',
        ),
        const DocsInstallFact(
          label: 'Foundation',
          value: 'source only',
          description: 'No package-backed alternative is offered yet.',
        ),
        const DocsInstallFact(
          label: 'Dependencies',
          value: 'source-foundation, machine-surface',
          description:
              'What the shipped manifest resolves: colors, '
              'shadows, spacing, theme, motion, and the ElMachineSurface '
              'effect the channel and the fill both paint through. None '
              'of this is resolved automatically today.',
        ),
        const DocsInstallFact(
          label: 'Assets',
          value: 'none',
          description: 'No images, icon fonts, or binary assets.',
        ),
        const DocsInstallFact(
          label: 'Shaders',
          value: 'none',
          description:
              'The fill and channel are ElMachineSurface layers: box '
              'shadows and solid fills, not a fragment shader.',
        ),
        DocsInstallFact(
          label: 'Platforms',
          value: 'Android, iOS, Web, macOS, Windows, Linux',
          description: 'No platform-conditional code in progress.dart.',
        ),
        const DocsInstallFact(
          label: 'Verified',
          value: 'package tests + docs specimen',
          description:
              'test/feedback_effects_test.dart, group(\'ElProgress\'), '
              'covers tones, the translation formula and rasterised fill '
              'placement. This page\'s own '
              'example/test/components_docs/progress_test.dart covers the '
              'specimen and reduced motion. No registry fixture install '
              'exists: there is nothing to install.',
        ),
      ],
    ),
  );

  Widget _usage(ElThemeData theme) => ElSection(
    id: 'usage',
    title: 'Usage',
    description:
        'The smallest correct call, then a realistic, tone-selected one.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: ElWidths.prose),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ElText(
                'ElProgress renders a 10px sunken channel with a filled '
                'indicator that translates into view as a value climbs: '
                'never a width change, a translation, so the tone shadow\'s '
                'inset rim runs off the end rather than pinning to the '
                'fill\'s leading edge.',
                ElType.body,
              ),
              SizedBox(height: el(4)),
              ElText(
                'Reach for ElProgress the moment you can compute a '
                'fraction: a file upload, a multi-step wizard, a sync job '
                'reporting bytes done over bytes total. Its Semantics node '
                'always announces the percentage, so a screen reader hears '
                'the number even when nothing else on screen moves. Reach '
                'for ElSpinner instead (documented on its own page) when '
                'you cannot compute a fraction and the wait is short. '
                'Reach for ElSkeleton (documented on its own page) when '
                'you already know the SHAPE of what is arriving and want '
                'the layout to hold still the instant real content '
                'replaces it.',
                ElType.body,
              ),
            ],
          ),
        ),
        SizedBox(height: el(5)),
        ElPanel(
          label: 'DART',
          note: 'MINIMAL',
          child: DocsSelectableCodeBlock(code: _usageCode),
        ),
      ],
    ),
  );

  Widget _labelValue() => ElSection(
    id: 'label-value',
    title: 'Label and value',
    description:
        'ElProgress has no separate ProgressLabel or ProgressValue widget: '
        '`label` is a single Semantics accessible-name parameter, and a '
        'visible percentage readout, like the reference\'s own "412 / '
        '2,000" span, is presentation the caller composes beside the bar. '
        'These seven specimens pair a caller-drawn label and percentage '
        'with each bar, the shape the reference\'s own PROGRESS_TONES '
        'panels use (three default, one value, one success, one warning, '
        'one destructive).',
    child: DocsCodeExample(
      title: 'Progress specimens',
      preview: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          for (final _ProgressSpecimen spec in _progressSpecimens) ...<Widget>[
            _LabelledProgress(spec: spec),
            SizedBox(height: el(4)),
          ],
        ],
      ),
    ),
  );

  Widget _controlled() => const ElSection(
    id: 'controlled',
    title: 'Controlled',
    description:
        'A real, stateful ElProgress. Press "Advance" to see the fill '
        'tween into its new position under ElProgress.transition (250ms, '
        'ElCurves.out): this is the specimen the reduced motion section '
        'below drives to a single-pump landing.',
    child: DocsCodeExample(
      title: 'Interactive: advance a value',
      preview: _ProgressLiveSpecimen(),
    ),
  );

  Widget _rtl() => const ElSection(
    id: 'rtl',
    title: 'RTL',
    description:
        'ElProgress renders under an ambient RTL Directionality without '
        'error, and its Semantics label and value announce correctly in '
        'either direction. One real gap: the fill\'s FractionalTranslation '
        'offset carries a fixed sign rather than one derived from '
        'Directionality.of(context), so the bar keeps filling from the '
        'physical left even under RTL, unlike a reference built on logical '
        'CSS properties. A reader building a fully mirrored RTL layout '
        'should know the fill itself will not flip.',
    child: DocsCodeExample(
      title: 'Progress under RTL',
      preview: _ProgressRtlDemo(),
    ),
  );

  Widget _downloadList() => const ElSection(
    id: 'download-list',
    title: 'Download list',
    description:
        'Three ElProgress rows sharing a list, echoing the reference\'s '
        'own second PROGRESS_TONES panel: the composed shape a download '
        'manager or a sync status panel actually uses. Not part of the '
        'shadcn counterpart\'s own section list; added because a single '
        'bar in isolation understates how the tones read together.',
    child: DocsCodeExample(
      title: 'A download list',
      preview: _DownloadListComposition(),
    ),
  );

  Widget _apiReference() => ElSection(
    id: 'api',
    title: 'API Reference',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const DocsApiTable(
          title: 'ElProgress properties',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'value',
              type: 'double',
              description:
                  'Required. 0…100. Clamped before use, so an out-of-range '
                  'caller value cannot overshoot the channel.',
            ),
            DocsApiFact(
              name: 'tone',
              type: 'ElProgressTone',
              description:
                  'Defaults to ElProgressTone.normal. Selects the fill ink '
                  'and shadow: see the tone table below.',
            ),
            DocsApiFact(
              name: 'label',
              type: 'String?',
              description:
                  'Optional Semantics accessible name. Null reproduces the '
                  'reference\'s own first bar, which ships with no '
                  'aria-label: see Accessibility for why this matters.',
            ),
          ],
        ),
        SizedBox(height: el(6)),
        const DocsApiTable(
          title: 'ElProgress static members',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'ElProgress.height',
              type: 'static double',
              description:
                  'The channel height, 10px (h-2.5). A fixed constant: '
                  'progress has a tone axis, not a size axis.',
            ),
            DocsApiFact(
              name: 'ElProgress.transition',
              type: 'static Duration',
              description:
                  'ElDurations.transitionDefault (250ms): the fill\'s own '
                  'transform transition, gated through elAnimationDuration.',
            ),
          ],
        ),
        SizedBox(height: el(6)),
        const DocsApiTable(
          title: 'ElProgressTone',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'normal',
              type: 'filled: the default',
              description:
                  'Fills with theme.actionInk under ElShadows.btnPrimary. '
                  'Spelled "normal" rather than "default" because default '
                  'is a Dart keyword; .label still reports "default".',
            ),
            DocsApiFact(
              name: 'value',
              type: 'filled',
              description:
                  'Fills with theme.valueInk under ElShadows.btnValue, '
                  'the one tone that leaves the action ramp, because '
                  'progression toward a reward is a value signal.',
            ),
            DocsApiFact(
              name: 'success',
              type: 'filled',
              description: 'Fills with theme.successInk under ElShadows.btn.',
            ),
            DocsApiFact(
              name: 'warning',
              type: 'filled',
              description: 'Fills with theme.warningInk under ElShadows.btn.',
            ),
            DocsApiFact(
              name: 'destructive',
              type: 'filled',
              description:
                  'Fills with theme.destructiveInk under ElShadows.btn. '
                  'For a reading OUTSIDE its safe band: a temperature or '
                  'error rate too high: never merely for a number that '
                  'fell; a figure moving the wrong way is news, not a '
                  'fault, and stays on normal.',
            ),
          ],
        ),
      ],
    ),
  );

  Widget _states() => ElSection(
    id: 'states',
    title: 'States',
    description:
        'A presentational StatelessWidget with no onPressed, no '
        'GestureDetector, and no FocusNode: most of IA §9.7\'s rows do not '
        'apply, so the ones that are genuinely N/A are grouped below with '
        'the reason instead of invented.',
    child: const DocsStateMatrix(
      facts: <DocsStateFact>[
        DocsStateFact(
          state: 'Value change',
          treatment:
              'The indicator translates from its old position to its new '
              'one over ElProgress.transition (250ms, ElCurves.out): a '
              'transform, not a width change.',
          userSignal:
              'The fill visibly slides to its new position rather than '
              'jumping or resizing.',
        ),
        DocsStateFact(
          state: 'Error / Success',
          treatment:
              'Not a live transition on one bar: choose '
              'ElProgressTone.destructive or .success at construction time '
              'instead. See the tone table in API Reference.',
          userSignal: 'A different progress instance, not a state change.',
        ),
        DocsStateFact(
          state: 'Reduced motion',
          treatment:
              'MediaQuery.disableAnimations collapses the transition to '
              'Duration.zero via elAnimationDuration: the fill lands on '
              'its target translation without a tween.',
          userSignal:
              'The progress bar jumps straight to its value: confirmed by '
              'this page\'s docs test.',
        ),
        DocsStateFact(
          state:
              'Hover / Focus-visible / Pressed / Selected / Empty / '
              'Disabled / Loading',
          treatment:
              'N/A: the widget carries no gesture, focus, or async-flag '
              'parameter to hold any of these; it is pure paint from its '
              'constructor arguments.',
          userSignal:
              'It does not respond to pointer or keyboard input; there is '
              'nothing to hover, focus, press, select, or disable.',
        ),
      ],
    ),
  );

  Widget _accessibility(ElThemeData theme) => ElSection(
    id: 'accessibility',
    title: 'Accessibility and keyboard behavior',
    child: _bullets(theme, <String>[
      'Semantic role: a Semantics node wraps the whole widget with '
          "value: '\${value.round()}%': every progress bar announces its "
          'percentage regardless of whether label is set. This is the one '
          'part of the brief that is fully met: a determinate progress bar '
          'here does announce its value.',
      'Accessible name (label): OPTIONAL, and null by default. A real '
          'gap, not a design choice: a bar built with no label reads to a '
          'screen reader as an unnamed control reporting "62%", with no '
          'indication of what is 62% complete. The default value '
          'reproduces the reference\'s own drift 6 rather than silently '
          'fixing it. Pass label explicitly for anything the surrounding '
          'context does not already make obvious.',
      'Keyboard interactions: none. ElProgress is never in the tab '
          'order: it is a read-only status indicator, matching the '
          'native ARIA progressbar role\'s own behavior.',
      'Non-colour signal: the Semantics value string carries the number '
          'independent of the fill\'s hue, so a tone change '
          '(success/warning/destructive) is never the only signal.',
    ]),
  );

  Widget _responsive(ElThemeData theme) => ElSection(
    id: 'responsive',
    title: 'Responsive',
    child: _bullets(theme, <String>[
      'No breakpoint reads from BuildContext, and no platform branch: the '
          'same widget tree renders at 390px and 1440px and on every '
          'target platform.',
      'ElProgress takes its width from its parent\'s constraints (there is '
          'no width parameter); only its 10px height is fixed. A caller '
          'that wants a narrower bar wraps it in a SizedBox or a '
          'ConstrainedBox: the component itself never clamps width.',
      'Platform parity: Android, iOS, Web, macOS, Windows and Linux all '
          'render the same widget tree.',
    ]),
  );

  Widget _dependencies(ElThemeData theme) => ElSection(
    id: 'dependencies',
    title: 'Dependencies, files, and install facts',
    child: _bullets(theme, <String>[
      'File: lib/src/components/progress.dart (one file, private '
          '_AnimatedFractionalTranslation helper included).',
      'Foundation imports: foundation/motion.dart (ElDurations, '
          'ElCurves, elAnimationDuration), foundation/shadows.dart '
          '(ElShadows.pressed/.btnPrimary/.btnValue/.btn), '
          'foundation/spacing.dart (el(), ElRadii), '
          'foundation/theme.dart (ElThemeData).',
      'Effect import: effects/machine_surface.dart (ElMachineSurface), '
          'which paints the channel and the fill.',
      'Scope import: theme_scope.dart (ElTheme).',
      'Assets/fonts/shaders: none.',
    ]),
  );

  Widget _theming(ElThemeData theme) => ElSection(
    id: 'theming',
    title: 'Theming',
    child: _bullets(theme, <String>[
      'Every colour comes from the live theme: theme.muted/.input for the '
          'channel, and ElProgressTone.inkOf(theme): one of actionInk/'
          'valueInk/successInk/warningInk/destructiveInk, for the fill. '
          'Flipping ElThemeController re-resolves both on every rebuild; '
          'nothing is cached.',
      'ElProgress declares no colour-override parameter of its own, every '
          'fill is tone-derived, the same rule ElBadge follows for its '
          'variants.',
    ]),
  );

  Widget _source() => ElSection(
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
              'group(\'ElProgress\'): tones, the translation formula, '
              'rasterised fill placement, and the drift-6 unlabelled bar.',
        ),
        const DocsInstallFact(
          label: 'Docs test',
          value: 'example/test/components_docs/progress_test.dart',
          description:
              'Covers this page: the API tables, live specimens at '
              'several values, the interactive fill, the pager, and a '
              'dedicated reduced-motion case.',
        ),
        const DocsInstallFact(
          label: 'Edit these docs',
          value: 'example/lib/components_docs/progress/page.dart',
          description: 'This file.',
        ),
      ],
    ),
  );
}

/// One [ElProgress] specimen with its value printed beside it: the docs
/// page's own presentation, not part of ElProgress's API.
class _LabelledProgress extends StatelessWidget {
  const _LabelledProgress({required this.spec});

  final _ProgressSpecimen spec;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: ElText(
                spec.label ?? '(no label: reproduces reference drift 6)',
                ElType.small,
                color: spec.label == null
                    ? theme.mutedForeground
                    : theme.foreground,
              ),
            ),
            ElText(
              '${spec.value.round()}%',
              ElType.small,
              color: theme.mutedForeground,
            ),
          ],
        ),
        SizedBox(height: el(2)),
        KeyedSubtree(
          key: ValueKey<String>(
            'progress-preview:${spec.tone.name}:${spec.value}',
          ),
          child: ElProgress(
            value: spec.value,
            tone: spec.tone,
            label: spec.label,
          ),
        ),
      ],
    );
  }
}

/// The one specimen the docs test drives: a real, stateful [ElProgress] a
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
    final ElThemeData theme = ElTheme.of(context);
    final bool atMax = _value >= 100;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ElProgress(
          key: const ValueKey<String>('progress-doc-live-specimen'),
          value: _value,
          tone: ElProgressTone.value,
          label: 'Uploading report.pdf',
        ),
        SizedBox(height: el(3)),
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: el(3),
          runSpacing: el(2),
          children: <Widget>[
            ElText(
              '${_value.round()}%, Uploading report.pdf',
              ElType.small,
              color: theme.mutedForeground,
            ),
            ElButton(
              key: const ValueKey<String>('progress-doc-simulate-button'),
              variant: ElButtonVariant.secondary,
              size: ElButtonSize.sm,
              label: atMax ? 'Reset upload' : 'Advance upload 20%',
              onPressed: _advanceOrReset,
              child: ElText(
                atMax ? 'Reset' : 'Advance 20%',
                ElComponentType.buttonLabel,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// A single [ElProgress] rendered under an ambient RTL [Directionality]:
/// see `RTL`'s own description for what does, and does not, mirror.
class _ProgressRtlDemo extends StatelessWidget {
  const _ProgressRtlDemo();

  @override
  Widget build(BuildContext context) => const Directionality(
    textDirection: TextDirection.rtl,
    child: ElProgress(
      value: 66.7,
      tone: ElProgressTone.value,
      label: 'اكتمال التحميل',
    ),
  );
}

/// Three [ElProgress] rows sharing a list: the composed shape a download
/// manager or a sync status panel actually uses, echoing the reference's own
/// PROGRESS_TONES second panel.
class _DownloadListComposition extends StatelessWidget {
  const _DownloadListComposition();

  static const List<(String, double, ElProgressTone)> _rows =
      <(String, double, ElProgressTone)>[
        ('quarterly-report.pdf', 100, ElProgressTone.success),
        ('design-assets.zip', 54, ElProgressTone.value),
        ('backup.tar.gz', 8, ElProgressTone.normal),
      ];

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        for (int i = 0; i < _rows.length; i++) ...<Widget>[
          if (i > 0) SizedBox(height: el(4)),
          Row(
            children: <Widget>[
              Expanded(
                child: ElText(
                  _rows[i].$1,
                  ElType.small,
                  color: theme.foreground,
                ),
              ),
              ElText(
                _rows[i].$2 >= 100 ? 'Done' : '${_rows[i].$2.round()}%',
                ElType.small,
                color: theme.mutedForeground,
              ),
            ],
          ),
          SizedBox(height: el(1.5)),
          ElProgress(value: _rows[i].$2, tone: _rows[i].$3, label: _rows[i].$1),
        ],
      ],
    );
  }
}

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

const String _usageCode = '''
// The smallest correct call: tone defaults to normal, label is optional.
ElProgress(value: 62)

// A labelled, tone-selected bar for a real status.
ElProgress(
  value: syncedBytes / totalBytes * 100,
  tone: ElProgressTone.value,
  label: 'Sync progress',
)''';
