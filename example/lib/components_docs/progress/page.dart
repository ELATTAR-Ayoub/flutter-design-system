/// Public documentation page for the paired `progress` / `skeleton`
/// components.
///
/// Mirrors `badge/page.dart`'s use of the Phase C docs primitives
/// (`DocsLayout`, `DocsCodeExample`, `DocsApiTable`, `DocsStateMatrix`,
/// `DocsInstallFacts`) and `kit.dart`'s `DsSection` for titled,
/// anchor-registered content blocks. The one structural difference from
/// `badge`: every `DsSection` below covers BOTH `DsProgress` and
/// `DsSkeleton` — see `meta.dart`'s library note for why one page, one
/// route, and one `ComponentDocEntry` carry two components.
///
/// Neither component has a registry manifest yet
/// (`registry/components/progress.json` and `.../skeleton.json` do not
/// exist) — every install-facing panel below says so honestly rather than
/// presenting a CLI command that would fail.
///
/// **Motion.** `DsProgress`'s fill is a finite `ImplicitlyAnimatedWidget`
/// transition (it tweens once per value change, then stops) and
/// `DsSkeleton`'s shimmer is a genuinely infinite `AnimationController.repeat()`
/// (`DsKeyframePlayer` with `repeat: true`). Both collapse to
/// `Duration.zero` under `MediaQuery.disableAnimations` via
/// `dsAnimationDuration` (`theme_scope.dart`) — confirmed for the skeleton by
/// the package's own `test/feedback_effects_test.dart` rasterised reduced
/// motion case, and for the progress fill by reading
/// `_AnimatedFractionalTranslation`'s duration parameter directly. See the
/// docs test's dedicated reduced-motion case for how this page verifies both
/// without ever calling `tester.pumpAndSettle()`.
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
    breadcrumbs: const <DsBreadcrumbEntry>[
      DsBreadcrumbEntry.link('Components'),
      DsBreadcrumbEntry.page('Progress & Skeleton'),
    ],
    sidebar: _sidebar,
    toc: const <DocsTocEntry>[
      DocsTocEntry(title: 'Overview', anchor: 'overview'),
      DocsTocEntry(title: 'Preview', anchor: 'preview'),
      DocsTocEntry(title: 'Install', anchor: 'install'),
      DocsTocEntry(title: 'Usage', anchor: 'usage'),
      DocsTocEntry(title: 'API', anchor: 'api'),
      DocsTocEntry(title: 'Variants', anchor: 'variants'),
      DocsTocEntry(title: 'States', anchor: 'states'),
      DocsTocEntry(title: 'Accessibility', anchor: 'accessibility'),
      DocsTocEntry(title: 'Responsive', anchor: 'responsive'),
      DocsTocEntry(title: 'Dependencies', anchor: 'dependencies'),
      DocsTocEntry(title: 'Composition', anchor: 'composition'),
      DocsTocEntry(title: 'Theming', anchor: 'theming'),
      DocsTocEntry(title: 'Source', anchor: 'source'),
    ],
    previous: const DocsPageLink(title: 'Kbd', route: '/components/kbd'),
    next: const DocsPageLink(
      title: 'Separator',
      route: '/components/separator',
    ),
    onNavigate: onNavigate,
    child: const _ProgressSkeletonArticle(),
  );
}

/// The Wave 1 "base primitives" group this page belongs to (IA §7.3), in the
/// plan's own order, with `Progress` and `Skeleton`'s two rows merged into
/// the one this page actually serves. Routes other workers are producing
/// this same wave, not routes this page can verify are wired yet — the
/// supervisor aggregates the real sidebar in `catalog.dart` and
/// `site_routes.dart`.
const List<DocsSidebarEntry> _sidebar = <DocsSidebarEntry>[
  DocsSidebarEntry(title: 'Accordion', route: '/components/accordion'),
  DocsSidebarEntry(title: 'Alert', route: '/components/alert'),
  DocsSidebarEntry(title: 'Avatar', route: '/components/avatar'),
  DocsSidebarEntry(title: 'Badge', route: '/components/badge'),
  DocsSidebarEntry(title: 'Breadcrumb', route: '/components/breadcrumb'),
  DocsSidebarEntry(title: 'Checkbox', route: '/components/checkbox'),
  DocsSidebarEntry(title: 'Collapsible', route: '/components/collapsible'),
  DocsSidebarEntry(title: 'Empty', route: '/components/empty'),
  DocsSidebarEntry(title: 'Kbd', route: '/components/kbd'),
  DocsSidebarEntry(
    title: 'Progress & Skeleton',
    route: '/components/progress',
    selected: true,
  ),
  DocsSidebarEntry(title: 'Separator', route: '/components/separator'),
  DocsSidebarEntry(title: 'Switch', route: '/components/switch'),
  DocsSidebarEntry(title: 'Toggle', route: '/components/toggle'),
  DocsSidebarEntry(title: 'Tooltip', route: '/components/tooltip'),
];

/// One static [DsProgress] specimen. Values and labels echo the reference's
/// own examples where `progress.dart`'s class doc quotes them verbatim
/// (`20.6`, `66.7`, and the drift-7 array's `{ tone: "default", label:
/// "Steps today", value: 72 }`) — see drift 6 and drift 7 in
/// `lib/src/components/progress.dart` for why the first bar below is
/// deliberately unlabelled.
class _ProgressSpecimen {
  const _ProgressSpecimen(this.value, this.tone, this.label);
  final double value;
  final DsProgressTone tone;
  final String? label;
}

const List<_ProgressSpecimen> _progressSpecimens = <_ProgressSpecimen>[
  // No label — reproduces the reference's own drift 6 (page.tsx:339 is a
  // bare <Progress value={20.6} /> with no aria-label).
  _ProgressSpecimen(20.6, DsProgressTone.normal, null),
  _ProgressSpecimen(66.7, DsProgressTone.normal, 'Profile complete'),
  _ProgressSpecimen(72, DsProgressTone.normal, 'Steps today'),
  _ProgressSpecimen(45, DsProgressTone.value, 'Storage used'),
  _ProgressSpecimen(88, DsProgressTone.success, 'Sync complete'),
  _ProgressSpecimen(34, DsProgressTone.warning, 'Battery'),
  // destructive is for a reading OUTSIDE its safe band, per the enum's own
  // doc comment — not merely a low number.
  _ProgressSpecimen(92, DsProgressTone.destructive, 'CPU temperature'),
];

class _ProgressSkeletonArticle extends StatelessWidget {
  const _ProgressSkeletonArticle();

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Column(
      key: const ValueKey<String>('progress-doc-article'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _overview(theme),
        _preview(),
        _install(),
        _usage(),
        _api(),
        _variants(theme),
        _states(),
        _accessibility(theme),
        _responsive(theme),
        _dependencies(theme),
        _composition(),
        _theming(theme),
        _source(),
      ],
    );
  }

  Widget _overview(DsThemeData theme) => DsSection(
    id: 'overview',
    title: 'Overview',
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: DsWidths.prose),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DsText(
            'DsProgress renders a 10px sunken channel with a filled '
            'indicator that translates into view as a value climbs — never '
            'a width change, a translation, so the tone shadow\'s inset '
            'rim runs off the end rather than pinning to the fill\'s '
            'leading edge. DsSkeleton renders a box the exact size of the '
            'thing that has not arrived yet, with a shimmering highlight '
            'sweeping across it forever, until the caller swaps it for '
            'real content.',
            DsType.body,
          ),
          SizedBox(height: ds(4)),
          DsText(progressSkeletonDecisionGuide, DsType.body),
          SizedBox(height: ds(4)),
          DsText(
            'Status: two stable primitives, neither registered in the CLI '
            'yet (see Install). Platforms: Android, iOS, Web, macOS, '
            'Windows, Linux — the same six every widget in this package '
            'targets.',
            DsType.small,
            color: theme.mutedForeground,
          ),
        ],
      ),
    ),
  );

  Widget _preview() => DsSection(
    id: 'preview',
    title: 'Preview',
    description:
        'Seven DsProgress readings across all five tones (three default, '
        'one value, one success, one warning, one destructive — the same '
        'split the reference\'s own PROGRESS_TONES array uses), an '
        'interactive one you can advance, and four DsSkeleton shapes.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DocsCodeExample(
          title: 'Progress specimens',
          manualFiles: const <DocsCodeFile>[
            DocsCodeFile(
              path: 'lib/components/ui/progress.dart',
              code:
                  "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
                  '// Progress has no registry manifest yet — copy\n'
                  '// lib/src/components/progress.dart from the package\n'
                  '// source directly. There is no generated CLI payload.',
            ),
          ],
          preview: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              for (final _ProgressSpecimen spec
                  in _progressSpecimens) ...<Widget>[
                _LabelledProgress(spec: spec),
                SizedBox(height: ds(4)),
              ],
            ],
          ),
        ),
        SizedBox(height: ds(6)),
        const DocsCodeExample(
          title: 'Interactive: advance a value',
          description:
              'A real, stateful DsProgress. Press "Advance" to see the '
              'fill tween into its new position under DsProgress.transition '
              '(250ms, DsCurves.out) — this is the specimen the reduced '
              'motion section below drives to a single-pump landing.',
          preview: _ProgressLiveSpecimen(),
        ),
        SizedBox(height: ds(6)),
        DocsCodeExample(
          title: 'Skeleton specimens',
          manualFiles: const <DocsCodeFile>[
            DocsCodeFile(
              path: 'lib/components/ui/skeleton.dart',
              code:
                  "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
                  '// Skeleton has no registry manifest yet — copy\n'
                  '// lib/src/components/skeleton.dart from the package\n'
                  '// source directly. There is no generated CLI payload.',
            ),
          ],
          preview: const _SkeletonShapes(),
        ),
      ],
    ),
  );

  Widget _install() => DsSection(
    id: 'install',
    title: 'Installation',
    description:
        'Neither component has a registry manifest yet, so `elattar add '
        'progress` and `elattar add skeleton` are not available — install '
        'by copying the source files manually.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DocsInstallFacts(
          title: 'Progress installation facts',
          facts: <DocsInstallFact>[
            const DocsInstallFact(
              label: 'Registry item',
              value: 'not yet registered',
              description:
                  'No registry/components/progress.json exists. This is a '
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
                  'What a future manifest would need to resolve — colors, '
                  'shadows, spacing, theme, motion, and the DsMachineSurface '
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
                  'The fill and channel are DsMachineSurface layers — box '
                  'shadows and solid fills — not a fragment shader.',
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
                  'test/feedback_effects_test.dart, group(\'DsProgress\'), '
                  'covers tones, the translation formula and rasterised '
                  'fill placement. This page\'s own '
                  'example/test/components_docs/progress_test.dart covers '
                  'the specimen and reduced motion. No registry fixture '
                  'install exists — there is nothing to install.',
            ),
          ],
        ),
        SizedBox(height: ds(5)),
        DocsInstallFacts(
          title: 'Skeleton installation facts',
          facts: <DocsInstallFact>[
            const DocsInstallFact(
              label: 'Registry item',
              value: 'not yet registered',
              description:
                  'No registry/components/skeleton.json exists. This is a '
                  'source-only component today.',
            ),
            const DocsInstallFact(
              label: 'Destination',
              value: 'lib/components/ui/skeleton.dart',
              description: 'Where a manual copy of the source belongs.',
            ),
            const DocsInstallFact(
              label: 'Foundation',
              value: 'source only',
              description: 'No package-backed alternative is offered yet.',
            ),
            const DocsInstallFact(
              label: 'Dependencies',
              value: 'source-foundation',
              description:
                  'foundation/theme.dart for the popover/accent gradient '
                  'stops and motion/keyframes.dart for DsShimmer and '
                  'DsKeyframePlayer, the shared looping-animation engine '
                  'every "pulls-*" motion in this system reuses.',
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
                  'The sweep is a Canvas.drawRect painted with a '
                  'LinearGradient shader object, not an asset-backed '
                  'fragment shader.',
            ),
            DocsInstallFact(
              label: 'Platforms',
              value: 'Android, iOS, Web, macOS, Windows, Linux',
              description: 'No platform-conditional code in skeleton.dart.',
            ),
            const DocsInstallFact(
              label: 'Verified',
              value: 'package tests + docs specimen',
              description:
                  'test/feedback_effects_test.dart, group(\'DsSkeleton\'), '
                  'rasterises the sweep and proves reduced motion holds a '
                  'fully static frame (zero changed pixels 470ms apart). '
                  'This page\'s own progress_test.dart re-proves the '
                  'settle without rasterising, by pumping bounded frames '
                  'and reading tester.binding.hasScheduledFrame. No '
                  'registry fixture install exists.',
            ),
          ],
        ),
      ],
    ),
  );

  Widget _usage() => DsSection(
    id: 'usage',
    title: 'Usage',
    description: 'The smallest correct call for each, then a realistic shape.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DsPanel(
          label: 'DART',
          note: 'PROGRESS',
          child: DocsSelectableCodeBlock(code: _progressUsageCode),
        ),
        SizedBox(height: ds(5)),
        DsPanel(
          label: 'DART',
          note: 'SKELETON',
          child: DocsSelectableCodeBlock(code: _skeletonUsageCode),
        ),
      ],
    ),
  );

  Widget _api() => DsSection(
    id: 'api',
    title: 'API',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const DocsApiTable(
          title: 'DsProgress properties',
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
              type: 'DsProgressTone',
              description:
                  'Defaults to DsProgressTone.normal. Selects the fill ink '
                  'and shadow — see Variants.',
            ),
            DocsApiFact(
              name: 'label',
              type: 'String?',
              description:
                  'Optional Semantics accessible name. Null reproduces the '
                  'reference\'s own first bar, which ships with no '
                  'aria-label — see Accessibility for why this matters.',
            ),
          ],
        ),
        SizedBox(height: ds(6)),
        const DocsApiTable(
          title: 'DsProgress static members',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'DsProgress.height',
              type: 'static double',
              description: 'The channel height — 10px (h-2.5).',
            ),
            DocsApiFact(
              name: 'DsProgress.transition',
              type: 'static Duration',
              description:
                  'DsDurations.transitionDefault (250ms) — the fill\'s own '
                  'transform transition, gated through dsAnimationDuration.',
            ),
          ],
        ),
        SizedBox(height: ds(6)),
        const DocsApiTable(
          title: 'DsSkeleton properties',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'width',
              type: 'double?',
              description:
                  'The box\'s width, or null to take the incoming '
                  'constraint (the caller\'s footprint, not a default '
                  'shape).',
            ),
            DocsApiFact(
              name: 'height',
              type: 'double?',
              description:
                  'The box\'s height, or null to take the incoming '
                  'constraint.',
            ),
            DocsApiFact(
              name: 'radius',
              type: 'double?',
              description:
                  'Overrides DsSkeleton.defaultRadius (10px). Set to '
                  'DsRadii.pill for an avatar circle or a pill-shaped '
                  'placeholder.',
            ),
          ],
        ),
        SizedBox(height: ds(6)),
        const DocsApiTable(
          title: 'DsSkeleton static members',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'DsSkeleton.defaultRadius',
              type: 'static double',
              description: 'DsRadii.md (10px) — the box\'s resting corner.',
            ),
            DocsApiFact(
              name: 'DsSkeleton.span',
              type:
                  'static InlineSpan Function({double? width, double? '
                  'height, double? radius})',
              description:
                  'Returns a WidgetSpan wrapping a DsSkeleton, aligned to '
                  'PlaceholderAlignment.middle, for a placeholder standing '
                  'in for a run of text inside a paragraph rather than a '
                  'block. See Preview\'s "inline" specimen.',
            ),
          ],
        ),
      ],
    ),
  );

  Widget _variants(DsThemeData theme) => DsSection(
    id: 'variants',
    title: 'Variants and sizes',
    description:
        'Progress has a tone axis, not a size axis — DsProgress.height is a '
        'fixed 10px everywhere. Skeleton has no variant enum at all: its '
        '"variant" is whatever width, height and radius the caller passes, '
        'because it must match the exact footprint of the content it '
        'stands in for.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const DocsApiTable(
          title: 'DsProgressTone',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'normal',
              type: 'filled — the default',
              description:
                  'Fills with theme.actionInk under DsShadows.btnPrimary. '
                  'Spelled "normal" rather than "default" because default '
                  'is a Dart keyword; .label still reports "default".',
            ),
            DocsApiFact(
              name: 'value',
              type: 'filled',
              description:
                  'Fills with theme.valueInk under DsShadows.btnValue — '
                  'the one tone that leaves the action ramp, because '
                  'progression toward a reward is a value signal.',
            ),
            DocsApiFact(
              name: 'success',
              type: 'filled',
              description: 'Fills with theme.successInk under DsShadows.btn.',
            ),
            DocsApiFact(
              name: 'warning',
              type: 'filled',
              description: 'Fills with theme.warningInk under DsShadows.btn.',
            ),
            DocsApiFact(
              name: 'destructive',
              type: 'filled',
              description:
                  'Fills with theme.destructiveInk under DsShadows.btn. '
                  'For a reading OUTSIDE its safe band — a temperature or '
                  'error rate too high — never merely for a number that '
                  'fell; a figure moving the wrong way is news, not a '
                  'fault, and stays on normal.',
            ),
          ],
        ),
        SizedBox(height: ds(4)),
        DsText(
          'Skeleton\'s only "variant" decision is the corner: '
          'DsSkeleton.defaultRadius (10px, rounded-md) fits a block or a '
          'text-line placeholder; passing radius: DsRadii.pill turns the '
          'same widget into a circle or a pill the moment width and '
          'height are equal or the box is short and wide. See the four '
          'shapes in Preview.',
          DsType.small,
          color: theme.mutedForeground,
        ),
      ],
    ),
  );

  Widget _states() => DsSection(
    id: 'states',
    title: 'States and feedback',
    description:
        'Both are presentational StatelessWidgets with no onPressed, no '
        'GestureDetector, and no FocusNode — most of IA §9.7\'s rows do not '
        'apply to either, so the ones that are genuinely N/A are grouped '
        'below with the reason instead of invented.',
    child: const DocsStateMatrix(
      facts: <DocsStateFact>[
        DocsStateFact(
          state: 'Progress — value change',
          treatment:
              'The indicator translates from its old position to its new '
              'one over DsProgress.transition (250ms, DsCurves.out) — a '
              'transform, not a width change.',
          userSignal:
              'The fill visibly slides to its new position rather than '
              'jumping or resizing.',
        ),
        DocsStateFact(
          state: 'Skeleton — loading (its only state)',
          treatment:
              'The shimmer runs forever via DsKeyframePlayer(repeat: true) '
              'until the caller stops rendering the skeleton and renders '
              'real content instead — DsSkeleton has no "done" flag of its '
              'own.',
          userSignal:
              'A continuously sweeping highlight signals "still working" '
              'for as long as the widget is on screen; the caller\'s own '
              'state (not a DsSkeleton parameter) decides when that ends.',
        ),
        DocsStateFact(
          state: 'Error / Success (progress)',
          treatment:
              'Not a live transition on one bar — choose '
              'DsProgressTone.destructive or .success at construction time '
              'instead. See Variants.',
          userSignal: 'A different progress instance, not a state change.',
        ),
        DocsStateFact(
          state: 'Reduced motion',
          treatment:
              'MediaQuery.disableAnimations collapses both animations to '
              'Duration.zero via dsAnimationDuration: the progress fill '
              'lands on its target translation without a tween, and '
              'DsKeyframePlayer stops its controller outright (fill: none '
              'reverts it to t=0, its resting frame) rather than merely '
              'animating fast.',
          userSignal:
              'The progress bar jumps straight to its value; the skeleton '
              'holds one still frame instead of sweeping — confirmed by '
              'this page\'s docs test and by '
              'test/feedback_effects_test.dart\'s rasterised case.',
        ),
        DocsStateFact(
          state:
              'Hover / Focus-visible / Pressed / Selected / Empty / '
              'Disabled',
          treatment:
              'N/A — neither widget carries a gesture, focus, or async-flag '
              'parameter to hold any of these; both are pure paint from '
              'their constructor arguments.',
          userSignal:
              'Neither responds to pointer or keyboard input; there is '
              'nothing to hover, focus, press, select, or disable.',
        ),
      ],
    ),
  );

  Widget _accessibility(DsThemeData theme) => DsSection(
    id: 'accessibility',
    title: 'Accessibility and keyboard behavior',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        DsText('DsProgress', DsType.label, color: theme.foreground),
        SizedBox(height: ds(2)),
        _bullets(theme, <String>[
          'Semantic role: a Semantics node wraps the whole widget with '
              "value: '\${value.round()}%' — every progress bar announces "
              'its percentage regardless of whether label is set. This is '
              'the one part of the brief that is fully met: a determinate '
              'progress bar here does announce its value.',
          'Accessible name (label): OPTIONAL, and null by default. A real '
              'gap, not a design choice — a bar built with no label reads '
              'to a screen reader as an unnamed control reporting "62%", '
              'with no indication of what is 62% complete. The default '
              'value reproduces the reference\'s own drift 6 rather than '
              'silently fixing it. Pass label explicitly for anything the '
              'surrounding context does not already make obvious.',
          'Keyboard interactions: none. DsProgress is never in the tab '
              'order — it is a read-only status indicator, matching the '
              'native ARIA progressbar role\'s own behavior.',
          'Non-colour signal: the Semantics value string carries the '
              'number independent of the fill\'s hue, so a tone change '
              '(success/warning/destructive) is never the only signal.',
        ]),
        SizedBox(height: ds(4)),
        DsText('DsSkeleton', DsType.label, color: theme.foreground),
        SizedBox(height: ds(2)),
        _bullets(theme, <String>[
          'Semantic role: NONE. DsSkeleton builds no Semantics node, no '
              'ExcludeSemantics, and no liveRegion announcement anywhere in '
              'its source. This is a real gap, not a documented design '
              'choice the way DsBadge\'s silence is: a placeholder standing '
              'in for content a user is waiting on gets no "loading" or '
              '"busy" announcement at all.',
          'What a screen reader actually gets: because the widget\'s leaf '
              'is a childless CustomPaint inside a SizedBox, Flutter '
              'contributes no semantic information for it by default — so '
              'in practice it is silently skipped, which is closer to '
              '"hidden" than "announced as busy", but that is an accident '
              'of how empty render objects are treated, not something '
              'DsSkeleton declares. A screen reader user gets neither a '
              '"content is loading" cue nor a guarantee the region is '
              'excluded on purpose.',
          'Recommended mitigation at the call site until this grows its '
              'own semantics: wrap a loading region in '
              'Semantics(label: \'Loading\', liveRegion: true) (or a '
              'DsEmpty/DsAlert busy announcement) around the whole '
              'skeleton group, the same way a caller already owns the '
              'swap between skeleton and real content.',
          'Keyboard interactions: none — DsSkeleton is never in the tab '
              'order, consistent with it not being interactive content.',
        ]),
      ],
    ),
  );

  Widget _responsive(DsThemeData theme) => DsSection(
    id: 'responsive',
    title: 'Responsive and platform behavior',
    child: _bullets(theme, <String>[
      'Neither widget reads a breakpoint from BuildContext or branches on '
          'platform — both render identically at 390px and 1440px and on '
          'every target platform.',
      'DsProgress takes its width from its parent\'s constraints (there is '
          'no width parameter); only its 10px height is fixed. A caller '
          'that wants a narrower bar wraps it in a SizedBox or a '
          'ConstrainedBox — the component itself never clamps width.',
      'DsSkeleton\'s geometry is entirely the caller\'s: width and height '
          'default to null, which takes the incoming constraint exactly '
          'the way an unconstrained Container would. Responsive behavior '
          'for a skeleton composition is a property of the layout around '
          'it, not of DsSkeleton itself.',
      'Platform parity: Android, iOS, Web, macOS, Windows and Linux all '
          'render the same widget tree for both components.',
    ]),
  );

  Widget _dependencies(DsThemeData theme) => DsSection(
    id: 'dependencies',
    title: 'Dependencies, files, and assets',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        DsText('DsProgress', DsType.label, color: theme.foreground),
        SizedBox(height: ds(2)),
        _bullets(theme, <String>[
          'File: lib/src/components/progress.dart (one file, private '
              '_AnimatedFractionalTranslation helper included).',
          'Foundation imports: foundation/motion.dart (DsDurations, '
              'DsCurves, dsAnimationDuration), foundation/shadows.dart '
              '(DsShadows.pressed/.btnPrimary/.btnValue/.btn), '
              'foundation/spacing.dart (ds(), DsRadii), '
              'foundation/theme.dart (DsThemeData).',
          'Effect import: effects/machine_surface.dart (DsMachineSurface) '
              '— paints the channel and the fill.',
          'Scope import: theme_scope.dart (DsTheme).',
          'Assets/fonts/shaders: none.',
        ]),
        SizedBox(height: ds(4)),
        DsText('DsSkeleton', DsType.label, color: theme.foreground),
        SizedBox(height: ds(2)),
        _bullets(theme, <String>[
          'File: lib/src/components/skeleton.dart (one file, private '
              '_ShimmerPainter included).',
          'Foundation imports: foundation/spacing.dart (ds(), DsRadii), '
              'foundation/theme.dart (DsThemeData).',
          'Motion import: motion/keyframes.dart (DsKeyframePlayer, '
              'DsShimmer) — the same looping-animation engine every '
              '"pulls-*" infinite motion in this system shares.',
          'Scope import: theme_scope.dart (DsTheme).',
          'Assets/fonts/shaders: none — the sweep is a LinearGradient '
              'shader object drawn by CustomPainter, not a bundled asset.',
        ]),
      ],
    ),
  );

  Widget _composition() => DsSection(
    id: 'composition',
    title: 'Composition examples',
    description:
        'A determinate download list (three tones at once, echoing the '
        'reference\'s own PROGRESS_TONES panel) and a card that swaps '
        'between a skeleton and its loaded content without moving.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const DocsCodeExample(
          title: 'A download list',
          preview: _DownloadListComposition(),
        ),
        SizedBox(height: ds(6)),
        const DocsCodeExample(
          title: 'A card that avoids layout shift',
          description:
              'Press the button to swap the placeholders for real content '
              'in place — the row never resizes, because the skeleton was '
              'already sized to match it.',
          preview: _LoadingCardComposition(),
        ),
      ],
    ),
  );

  Widget _theming(DsThemeData theme) => DsSection(
    id: 'theming',
    title: 'Theming notes',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        DsText('DsProgress', DsType.label, color: theme.foreground),
        SizedBox(height: ds(2)),
        _bullets(theme, <String>[
          'Every colour comes from the live theme: theme.muted/.input for '
              'the channel, and DsProgressTone.inkOf(theme) — one of '
              'actionInk/valueInk/successInk/warningInk/destructiveInk — '
              'for the fill. Flipping DsThemeController re-resolves both '
              'on every rebuild; nothing is cached.',
          'DsProgress declares no colour-override parameter of its own — '
              'every fill is tone-derived, the same rule DsBadge follows '
              'for its variants.',
        ]),
        SizedBox(height: ds(4)),
        DsText('DsSkeleton', DsType.label, color: theme.foreground),
        SizedBox(height: ds(2)),
        _bullets(theme, <String>[
          'The shimmer gradient is theme.popover → theme.accent → '
              'theme.popover (DsShimmer.gradient(theme)) — both stops '
              'resolve from the live theme, so light and dark each get '
              'their own correctly contrasted sweep with no override '
              'needed.',
          'DsSkeleton declares no colour parameter of its own either — the '
              'gradient is entirely theme-derived, consistent with every '
              'other primitive on this page.',
        ]),
      ],
    ),
  );

  Widget _source() => DsSection(
    id: 'source',
    title: 'Source, tests, and docs',
    child: DocsInstallFacts(
      title: 'Reference',
      facts: <DocsInstallFact>[
        DocsInstallFact(
          label: 'Progress source',
          value: progressDoc.sourcePath,
          description: 'Authoritative implementation for DsProgress.',
        ),
        const DocsInstallFact(
          label: 'Skeleton source',
          value: skeletonSourcePath,
          description: 'Authoritative implementation for DsSkeleton.',
        ),
        const DocsInstallFact(
          label: 'Package tests',
          value: 'test/feedback_effects_test.dart',
          description:
              'group(\'DsProgress\') and group(\'DsSkeleton\') — tones, '
              'the translation formula, rasterised fill placement, the '
              'drift-6 unlabelled bar, and the rasterised reduced-motion '
              'case for the shimmer.',
        ),
        const DocsInstallFact(
          label: 'Docs test',
          value: 'example/test/components_docs/progress_test.dart',
          description:
              'Covers this page: both API tables, live specimens at '
              'several values, the interactive fill, the pager, and a '
              'dedicated reduced-motion case for both animations.',
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

/// One [DsProgress] specimen with its value printed beside it — the docs
/// page's own presentation, not part of DsProgress's API.
class _LabelledProgress extends StatelessWidget {
  const _LabelledProgress({required this.spec});

  final _ProgressSpecimen spec;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: DsText(
                spec.label ?? '(no label — reproduces reference drift 6)',
                DsType.small,
                color: spec.label == null
                    ? theme.mutedForeground
                    : theme.foreground,
              ),
            ),
            DsText(
              '${spec.value.round()}%',
              DsType.small,
              color: theme.mutedForeground,
            ),
          ],
        ),
        SizedBox(height: ds(2)),
        KeyedSubtree(
          key: ValueKey<String>(
            'progress-preview:${spec.tone.name}:${spec.value}',
          ),
          child: DsProgress(
            value: spec.value,
            tone: spec.tone,
            label: spec.label,
          ),
        ),
      ],
    );
  }
}

/// The one specimen the docs test drives: a real, stateful [DsProgress] a
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
    final DsThemeData theme = DsTheme.of(context);
    final bool atMax = _value >= 100;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DsProgress(
          key: const ValueKey<String>('progress-doc-live-specimen'),
          value: _value,
          tone: DsProgressTone.value,
          label: 'Uploading report.pdf',
        ),
        SizedBox(height: ds(3)),
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: ds(3),
          runSpacing: ds(2),
          children: <Widget>[
            DsText(
              '${_value.round()}% — Uploading report.pdf',
              DsType.small,
              color: theme.mutedForeground,
            ),
            DsButton(
              key: const ValueKey<String>('progress-doc-simulate-button'),
              variant: DsButtonVariant.secondary,
              size: DsButtonSize.sm,
              label: atMax ? 'Reset upload' : 'Advance upload 20%',
              onPressed: _advanceOrReset,
              child: DsText(
                atMax ? 'Reset' : 'Advance 20%',
                DsComponentType.buttonLabel,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Four [DsSkeleton] shapes: a text line, a shorter second line, a circular
/// avatar placeholder, and a block card placeholder — plus one inline
/// [DsSkeleton.span] example, since that factory cannot be exercised any
/// other way.
class _SkeletonShapes extends StatelessWidget {
  const _SkeletonShapes();

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final TextStyle bodyStyle = DsText.styleOf(
      context,
      DsType.body,
      color: theme.foreground,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        DsText('Text lines (rounded-md, the default radius)', DsType.label),
        SizedBox(height: ds(2)),
        const KeyedSubtree(
          key: ValueKey<String>('skeleton-preview:line-1'),
          child: DsSkeleton(width: 220, height: 14),
        ),
        SizedBox(height: ds(2)),
        const KeyedSubtree(
          key: ValueKey<String>('skeleton-preview:line-2'),
          child: DsSkeleton(width: 160, height: 14),
        ),
        SizedBox(height: ds(5)),
        DsText('Avatar (radius: DsRadii.pill)', DsType.label),
        SizedBox(height: ds(2)),
        const KeyedSubtree(
          key: ValueKey<String>('skeleton-preview:avatar'),
          child: DsSkeleton(width: 40, height: 40, radius: DsRadii.pill),
        ),
        SizedBox(height: ds(5)),
        DsText(
          'A card placeholder, sized like the content it precedes',
          DsType.label,
        ),
        SizedBox(height: ds(2)),
        const KeyedSubtree(
          key: ValueKey<String>('skeleton-preview:card'),
          child: DsSkeleton(width: 320, height: 128),
        ),
        SizedBox(height: ds(5)),
        DsText('Inline, standing in for a run of text', DsType.label),
        SizedBox(height: ds(2)),
        Text.rich(
          TextSpan(
            style: bodyStyle,
            children: <InlineSpan>[
              const TextSpan(text: 'The next release ships in '),
              DsSkeleton.span(width: 64, height: 14),
              const TextSpan(text: ' weeks, after code freeze.'),
            ],
          ),
        ),
      ],
    );
  }
}

/// Three [DsProgress] rows sharing a list — the composed shape a download
/// manager or a sync status panel actually uses, echoing the reference's own
/// PROGRESS_TONES second panel.
class _DownloadListComposition extends StatelessWidget {
  const _DownloadListComposition();

  static const List<(String, double, DsProgressTone)> _rows =
      <(String, double, DsProgressTone)>[
        ('quarterly-report.pdf', 100, DsProgressTone.success),
        ('design-assets.zip', 54, DsProgressTone.value),
        ('backup.tar.gz', 8, DsProgressTone.normal),
      ];

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        for (int i = 0; i < _rows.length; i++) ...<Widget>[
          if (i > 0) SizedBox(height: ds(4)),
          Row(
            children: <Widget>[
              Expanded(
                child: DsText(
                  _rows[i].$1,
                  DsType.small,
                  color: theme.foreground,
                ),
              ),
              DsText(
                _rows[i].$2 >= 100 ? 'Done' : '${_rows[i].$2.round()}%',
                DsType.small,
                color: theme.mutedForeground,
              ),
            ],
          ),
          SizedBox(height: ds(1.5)),
          DsProgress(value: _rows[i].$2, tone: _rows[i].$3, label: _rows[i].$1),
        ],
      ],
    );
  }
}

/// A settings-row shape that swaps a [DsSkeleton] avatar and two text-line
/// skeletons for real content, without the row changing size — the reason
/// `skeleton.dart`'s own class doc gives for why the geometry is always the
/// caller's.
class _LoadingCardComposition extends StatefulWidget {
  const _LoadingCardComposition();

  @override
  State<_LoadingCardComposition> createState() =>
      _LoadingCardCompositionState();
}

class _LoadingCardCompositionState extends State<_LoadingCardComposition> {
  bool _loaded = false;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 40,
              height: 40,
              child: _loaded
                  ? DecoratedBox(
                      decoration: BoxDecoration(
                        color: theme.muted,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: DsIcon(
                          DsIconGlyph.user,
                          size: DsIconSize.sm,
                          tone: DsIconTone.muted,
                        ),
                      ),
                    )
                  : const DsSkeleton(
                      width: 40,
                      height: 40,
                      radius: DsRadii.pill,
                    ),
            ),
            SizedBox(width: ds(3)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _loaded
                    ? <Widget>[
                        DsText(
                          'Amara Chen',
                          DsType.label,
                          color: theme.foreground,
                        ),
                        SizedBox(height: ds(1)),
                        DsText(
                          'Design lead — active 2 minutes ago',
                          DsType.small,
                          color: theme.mutedForeground,
                        ),
                      ]
                    : const <Widget>[
                        DsSkeleton(width: 140, height: 14),
                        SizedBox(height: 8),
                        DsSkeleton(width: 200, height: 12),
                      ],
              ),
            ),
          ],
        ),
        SizedBox(height: ds(4)),
        DsButton(
          key: const ValueKey<String>('progress-doc-toggle-loaded'),
          variant: DsButtonVariant.outline,
          size: DsButtonSize.sm,
          label: _loaded ? 'Show skeleton again' : 'Show loaded content',
          onPressed: () => setState(() => _loaded = !_loaded),
          child: DsText(
            _loaded ? 'Show skeleton again' : 'Show loaded content',
            DsComponentType.buttonLabel,
          ),
        ),
      ],
    );
  }
}

Widget _bullets(DsThemeData theme, List<String> lines) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: <Widget>[
    for (final String line in lines) ...<Widget>[
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: DsWidths.prose),
        child: DsText('•  $line', DsType.small, color: theme.mutedForeground),
      ),
      SizedBox(height: ds(2)),
    ],
  ],
);

const String _progressUsageCode = '''
// The smallest correct call — tone defaults to normal, label is optional.
DsProgress(value: 62)

// A labelled, tone-selected bar for a real status.
DsProgress(
  value: syncedBytes / totalBytes * 100,
  tone: DsProgressTone.value,
  label: 'Sync progress',
)''';

const String _skeletonUsageCode = '''
// A block the exact size of the card that will replace it.
DsSkeleton(width: 320, height: 128)

// A circular avatar placeholder.
DsSkeleton(width: 40, height: 40, radius: DsRadii.pill)

// Inline, standing in for a run of text.
Text.rich(
  TextSpan(
    style: DsText.styleOf(context, DsType.body),
    children: <InlineSpan>[
      const TextSpan(text: 'Ready in '),
      DsSkeleton.span(width: 64, height: 14),
    ],
  ),
)''';
