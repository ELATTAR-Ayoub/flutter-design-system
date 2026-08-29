/// Public documentation page for the `starfield` effect.
///
/// **Why `EffectSection`, not `ShowcaseSection`.** [AmbientPattern] renders
/// nothing on its own terms — it is `Positioned.fill` sparkle paint that
/// takes its host's own resolved colour and hover boolean. A
/// `ShowcaseSection` stages a specimen; `EffectSection` names the host the
/// starfield is hung over, which is the only way to show what thirteen
/// hand-placed sparkles actually look like.
///
/// **Section list.** Preview contrasts a themed panel with the starfield
/// mounted over it against the same panel without it, at
/// `EffectSection.minHeight: space(160)` — a starfield judged in the kit's
/// 384-tall default shows almost no field, per the brief for this page.
/// Host Height reproduces the source's own documented "measured catch": the
/// two clusters are anchored and clipped, never rescaled, so a short host
/// loses sparkles a tall one keeps — the exact fact `starfield.dart`'s
/// class doc records for a 69.125px Alert. Hover shows the per-cluster lean
/// `AmbientPattern.hovered` drives.
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

final ComponentDocSpec starfieldDocSpec = ComponentDocSpec(
  name: 'ambient_pattern',
  title: 'Starfield',
  description:
      'Thirteen hand-placed sparkles across two independently-swaying '
      'clusters, anchored to a corner and clipped to whatever box they '
      'hang off — the dust that rides along wherever feedback-surface hangs '
      'its corner light.',
  sections: <DocsPageSection>[
    EffectSection(
      id: 'preview',
      title: 'Preview',
      description:
          'The left panel mounts AmbientPattern(bloom2: Palette.action) as '
          'a Positioned.fill layer; the right panel is the identical '
          'DecoratedBox with no starfield at all. Both panels are tall '
          'enough (192px) that neither cluster is clipped, so all '
          'thirteen sparkles render on the left.',
      host: _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
      minHeight: space(160),
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'ambient-pattern has a real registry manifest: `elattar add ambient-pattern` '
          'installs lib/src/components/ui/starfield.dart and resolves its two '
          'registryDependencies automatically. The Manual tab is for a '
          'project not using the CLI.',
      command: ambientPatternDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/effects/starfield.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/ui/starfield.dart's generated "
              '@ui/starfield.dart payload into effects.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated starfield source here when using '
              'manual mode.',
        ),
        DocsCodeFile(
          path: 'lib/effects/effects.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so AmbientPattern, StarfieldCluster and '
              'Sparkle are reachable the same way the CLI path already '
              'makes them.',
          code: "export 'starfield.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'AmbientPattern paints over the whole of its box: give it tight '
          'constraints — Positioned.fill inside the host\'s own clip — '
          'and pass the host\'s resolved --bloom-2 colour and its live '
          'hover boolean.',
      code: _usageCode,
    ),
    EffectSection(
      id: 'host-height',
      title: 'Host Height',
      description:
          'Anchored, not tiled: both clusters render at their natural '
          'size and clip against whatever box they are given, rather '
          'than rescaling to fit it. At 72px tall — close to the Alert\'s '
          'own measured ~69px padding box — the dense cluster\'s topmost '
          'sparkles fall outside the box and are clipped away, exactly '
          'the catch starfield.dart\'s own class doc records. At 192px '
          'tall the same cluster clears the box entirely and nothing is '
          'lost.',
      host: _HostHeightSpecimen(),
      code: _hostHeightCode,
      label: 'Host Height specimen view',
      minHeight: space(160),
    ),
    EffectSection(
      id: 'hover',
      title: 'Hover',
      description:
          'Hover the panel. Each cluster leans toward the surface\'s '
          'middle and grows slightly — translate then scale, composed '
          'about the cluster\'s own anchored corner — on MotionDurations.bloom '
          '(1000ms), independently of the sway that keeps running '
          'underneath it.',
      host: _StarfieldHost(width: space(68), height: space(48)),
      code: _hoverCode,
      label: 'Hover specimen view',
      minHeight: space(160),
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every constructor parameter AmbientPattern declares, and every '
          'field of the two data records it is built from.',
      children: const <DocsTocEntry>[
        DocsTocEntry(title: 'AmbientPattern', anchor: 'api-elstarfield'),
        DocsTocEntry(
          title: 'StarfieldCluster',
          anchor: 'api-elstarfieldcluster',
        ),
        DocsTocEntry(title: 'Sparkle', anchor: 'api-elsparkle'),
      ],
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
            value: ambientPatternDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'test/feedback_effects_test.dart',
            description:
                'Groups "AmbientPattern — the two clusters" and "the '
                'starfield, rasterised" — the sway table, the hover '
                'nudge, the per-host clipping and the stilled-under-'
                'reduced-motion behaviour.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/starfield_test.dart',
            description:
                'Covers this page: the article mounts, the API table, a '
                'live hover on the host specimens, and both themes.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/starfield/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class AmbientPatternDocPage extends StatelessWidget {
  const AmbientPatternDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: ambientPatternDoc.route,
    intro: DocsPageIntro(
      title: ambientPatternDoc.title,
      description: ambientPatternDoc.description,
    ),
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Components'),
      BreadcrumbEntry.page('Starfield'),
    ],
    toc: starfieldDocSpec.toc,
    previous: null,
    next: null,
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('starfield-doc-article'),
      child: ComponentDocPage(spec: starfieldDocSpec, header: false),
    ),
  );
}

/* ── Effect specimens ───────────────────────────────────────────────────── */

Widget _caption(BuildContext context, String label) => StyledText(
  label,
  TextStyles.caption,
  color: ThemeScope.of(context).mutedForeground,
);

/// A themed panel with [AmbientPattern] hung over it as a `Positioned.fill`
/// layer, and a [MouseRegion] driving the hover boolean the way a real host
/// (an Alert, a toast) drives it in the corpus.
class _StarfieldHost extends StatefulWidget {
  const _StarfieldHost({
    required this.width,
    required this.height,
    this.hoverable = true,
  });

  final double width;
  final double height;
  final bool hoverable;

  @override
  State<_StarfieldHost> createState() => _StarfieldHostState();
}

class _StarfieldHostState extends State<_StarfieldHost> {
  bool _hovered = false;

  void _setHovered(bool value) {
    if (_hovered == value) return;
    setState(() => _hovered = value);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return MouseRegion(
      onEnter: widget.hoverable ? (_) => _setHovered(true) : null,
      onExit: widget.hoverable ? (_) => _setHovered(false) : null,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          border: Border.all(color: theme.border, width: BorderWidths.hairline),
          borderRadius: BorderRadius.circular(Radii.lg),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Radii.lg),
          child: DecoratedBox(
            decoration: BoxDecoration(color: theme.card),
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Positioned.fill(
                  child: AmbientPattern(
                    bloom2: Palette.action,
                    hovered: _hovered,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PlainPanel extends StatelessWidget {
  const _PlainPanel({required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: theme.card,
        border: Border.all(color: theme.border, width: BorderWidths.hairline),
        borderRadius: BorderRadius.circular(Radii.lg),
      ),
    );
  }
}

class _PreviewSpecimen extends StatelessWidget {
  const _PreviewSpecimen();

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: space(6),
    runSpacing: space(4),
    crossAxisAlignment: WrapCrossAlignment.start,
    children: <Widget>[
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _caption(context, 'With AmbientPattern'),
          SizedBox(height: space(3)),
          KeyedSubtree(
            key: const ValueKey<String>('starfield-preview:with'),
            child: _StarfieldHost(
              width: space(68),
              height: space(48),
              hoverable: false,
            ),
          ),
        ],
      ),
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _caption(context, 'Without'),
          SizedBox(height: space(3)),
          KeyedSubtree(
            key: const ValueKey<String>('starfield-preview:without'),
            child: _PlainPanel(width: space(68), height: space(48)),
          ),
        ],
      ),
    ],
  );
}

const String _previewCode =
    '// With AmbientPattern — the effect this page documents\n'
    'Stack(\n'
    '  fit: StackFit.expand,\n'
    '  children: [\n'
    '    Positioned.fill(\n'
    '      child: AmbientPattern(bloom2: Palette.action),\n'
    '    ),\n'
    '  ],\n'
    ')\n\n'
    '// Without — the identical DecoratedBox, no AmbientPattern at all\n'
    'DecoratedBox(decoration: BoxDecoration(color: theme.card))';

class _HostHeightSpecimen extends StatelessWidget {
  const _HostHeightSpecimen();

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: space(6),
    runSpacing: space(4),
    crossAxisAlignment: WrapCrossAlignment.start,
    children: <Widget>[
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _caption(context, '72px — an Alert-sized host'),
          SizedBox(height: space(3)),
          KeyedSubtree(
            key: const ValueKey<String>('starfield-host-height:short'),
            child: _StarfieldHost(
              width: space(68),
              height: space(18),
              hoverable: false,
            ),
          ),
        ],
      ),
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _caption(context, '192px — nothing clipped'),
          SizedBox(height: space(3)),
          KeyedSubtree(
            key: const ValueKey<String>('starfield-host-height:tall'),
            child: _StarfieldHost(
              width: space(68),
              height: space(48),
              hoverable: false,
            ),
          ),
        ],
      ),
    ],
  );
}

const String _hostHeightCode =
    '// Same width, two heights — the tile is anchored and clipped,\n'
    '// never rescaled, so a short host shows fewer sparkles.\n'
    'SizedBox(\n'
    '  width: 272,\n'
    '  height: 72, // vs. 192\n'
    '  child: Stack(\n'
    '    fit: StackFit.expand,\n'
    '    children: [\n'
    '      Positioned.fill(child: AmbientPattern(bloom2: Palette.action)),\n'
    '    ],\n'
    '  ),\n'
    ')';

const String _hoverCode =
    'MouseRegion(\n'
    '  onEnter: (_) => setState(() => hovered = true),\n'
    '  onExit: (_) => setState(() => hovered = false),\n'
    '  child: Stack(\n'
    '    fit: StackFit.expand,\n'
    '    children: [\n'
    '      Positioned.fill(\n'
    '        child: AmbientPattern(bloom2: Palette.action, hovered: hovered),\n'
    '      ),\n'
    '    ],\n'
    '  ),\n'
    ')';

const String _usageCode = '''
import 'package:elattar_design_system/elattar_design_system.dart';

Stack(
  fit: StackFit.expand,
  children: [
    Positioned.fill(
      child: AmbientPattern(bloom2: theme.actionText, hovered: hovered),
    ),
    child,
  ],
)''';

/* ── Disclosure content ─────────────────────────────────────────────────── */

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsAnchor(
        id: 'api-elstarfield',
        child: DocsApiTable(title: 'AmbientPattern', facts: _starfieldApiFacts),
      ),
      SizedBox(height: space(6)),
      const DocsAnchor(
        id: 'api-elstarfieldcluster',
        child: DocsApiTable(title: 'StarfieldCluster', facts: _clusterApiFacts),
      ),
      SizedBox(height: space(6)),
      const DocsAnchor(
        id: 'api-elsparkle',
        child: DocsApiTable(title: 'Sparkle', facts: _sparkleApiFacts),
      ),
    ],
  );
}

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'AmbientPattern wraps its whole CustomPaint in IgnorePointer and adds '
            'no Semantics node of its own: a screen reader is told nothing '
            'about the sparkles, the same way aria-hidden marks the '
            'reference\'s own <span data-slot="alert-stars">.',
        'Purely decorative in both directions: it neither announces itself '
            'nor claims the pointer region its host already owns.',
      ]);
}

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'AmbientPattern takes no focus and handles no key: there is no Focus, '
            'no FocusNode and no onKeyEvent anywhere in starfield.dart.',
        'The hover it reacts to is not its own, either — hovered is a '
            'boolean the host hands in from its own MouseRegion; '
            'AmbientPattern\'s IgnorePointer keeps it from ever seeing a '
            'pointer event itself, keyboard or otherwise.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'No MediaQuery or breakpoint branching anywhere in starfield.dart.',
        'What does vary with size is the host\'s own geometry, not the '
            'viewport: both clusters are anchored and clipped rather than '
            'rescaled, so which of the thirteen sparkles actually render is '
            'a property of the box AmbientPattern is given — see Host Height '
            'above, not a responsive rule in this file.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      _bullets(ThemeScope.of(context), <String>[
        'File: lib/src/components/ui/starfield.dart — one file, three classes, '
            'no companions.',
        'Flutter imports: dart:math, dart:ui, foundation.dart (@immutable, '
            '@visibleForTesting, listEquals), widgets.dart.',
        'Foundation imports: ../components/icon_paths.dart (IconPaths, '
            'the sparkle path and its viewBox), foundation/colors.dart '
            '(hslColor, OklabColor), foundation/motion.dart (effectiveMotionDuration, '
            'MotionDurations, MotionCurves), foundation/theme.dart, theme_scope.dart.',
        'registryDependencies, resolved automatically by `elattar add '
            'starfield`: icon, source-foundation — copied verbatim from '
            'registry/components/starfield.json.',
        'Not a dependency of starfield.dart itself, but its one real '
            'consumer in the corpus: FeedbackSurface mounts AmbientPattern '
            'internally whenever its own starfield parameter is true (the '
            'default), which is how it reaches an Alert and every toast.',
      ]),
      SizedBox(height: space(3)),
      DocsLinkRow(
        links: <DocsLink>[
          const DocsLink(label: 'Icon', route: '/components/icon'),
          const DocsLink(
            label: 'Feedback Surface',
            route: '/components/feedback_surface',
          ),
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
        'The sparkle fill itself does not change with the theme: every '
            'instance is hslColor(0, 0, 100) — literal white — in both '
            'blocks, spelled as the top of the lightness axis rather than '
            'an ARGB literal.',
        'What the theme changes is the glow around it. On dark, '
            'AmbientPattern.glowFor returns starInk (white) at '
            'theme.starGlowMix alpha. On light it returns the host\'s own '
            'bloom2 mixed toward transparent at that same alpha in oklab — '
            'the one place a sparkle knows which variant it is sitting on.',
        'Both drop-shadow passes size themselves from theme.starGlowSize '
            '(a tight pass and a wide pass at 3x that radius), also '
            'theme-resolved.',
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

const List<DocsApiFact> _starfieldApiFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'bloom2',
    type: 'Color',
    description:
        'Required. The host\'s own resolved --bloom-2, which glowFor reads '
        'on light. Passed in rather than resolved here because only the '
        'host knows its own variant.',
  ),
  DocsApiFact(
    name: 'hovered',
    type: 'bool',
    description:
        'Optional, defaults to false. The host\'s own :hover — the '
        'starfield\'s IgnorePointer keeps it from detecting a pointer '
        'itself.',
  ),
];

const List<DocsApiFact> _clusterApiFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'tile',
    type: 'Size',
    description:
        'background-size, which is also the SVG viewBox: 260x96 for the '
        'dense cluster, 200x64 for the thin one.',
  ),
  DocsApiFact(
    name: 'corner',
    type: 'Alignment',
    description:
        'Both background-position and transform-origin — the corner the '
        'cluster is anchored to and pivots about. bottomRight for the '
        'dense cluster, topRight for the thin one.',
  ),
  DocsApiFact(
    name: 'sway',
    type: 'Duration',
    description:
        'animation-duration for the rotation: MotionDurations.sway (44s) on '
        'the dense cluster, MotionDurations.swayAlt (33s) on the thin one — '
        'deliberately not multiples of each other.',
  ),
  DocsApiFact(
    name: 'fromDegrees',
    type: 'double',
    description: '@keyframes star-sway { from { rotate: <this>deg } }.',
  ),
  DocsApiFact(
    name: 'toDegrees',
    type: 'double',
    description: '…{ to { rotate: <this>deg } }.',
  ),
  DocsApiFact(
    name: 'hoverTranslate',
    type: 'Offset',
    description:
        ':hover translate — a nudge toward the surface\'s own middle, so '
        'the cluster leans in rather than drifting off its corner.',
  ),
  DocsApiFact(
    name: 'hoverScale',
    type: 'double',
    description: ':hover scale — 1.06 dense, 1.04 thin.',
  ),
  DocsApiFact(
    name: 'sparkles',
    type: 'List<Sparkle>',
    description:
        'The instances, in the SVG\'s own paint order: eight for the '
        'dense cluster, five for the thin one.',
  ),
];

const List<DocsApiFact> _sparkleApiFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'opacity',
    type: 'double',
    description: 'The path\'s own opacity attribute — 0.38 to 0.95.',
  ),
  DocsApiFact(
    name: 'x',
    type: 'double',
    description: 'translate(x, …) in the cluster\'s own tile coordinates.',
  ),
  DocsApiFact(name: 'y', type: 'double', description: 'translate(…, y).'),
  DocsApiFact(
    name: 'scale',
    type: 'double',
    description:
        'scale(s) — 0.12 to 0.46, so one sparkle spans 2.88px to 11.04px.',
  ),
];

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Swaying (default)',
    treatment:
        'Both AnimationControllers run controller.repeat(reverse: true) '
        'forever from didChangeDependencies — an infinite alternate, with '
        'no out-of-view pause.',
    userSignal:
        'Each cluster rocks a few degrees about its anchored corner, on '
        'periods long enough (44s / 33s) that the motion never repeats in '
        'a way a viewer can catch.',
  ),
  DocsStateFact(
    state: 'Hovered',
    treatment:
        'The host reports hovered: true; a shared AnimationController '
        'drives translate then scale, composed about the cluster\'s own '
        'origin, over MotionDurations.bloom (1000ms) on MotionCurves.enter.',
    userSignal:
        'Both clusters lean a few pixels toward the surface\'s middle and '
        'grow slightly, on top of whatever the sway is doing at that '
        'instant — the two are independent transform properties, not one '
        'that overwrites the other.',
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment:
        'effectiveMotionDuration(context, MotionDurations.sway) resolves to '
        'Duration.zero, the two sway controllers stop, and the painter '
        'switches to stilledMatrixFor — translate and scale from any held '
        'hover, but the rotation forced to the element\'s own resting '
        '0°, NOT frozen at wherever the sway last reached, and not the '
        "keyframe's -6°/6° extremes either.",
    userSignal:
        'Both clusters sit dead still at their un-rotated resting pose; a '
        'held hover still leans and grows them, just instantly rather '
        'than eased.',
  ),
];
