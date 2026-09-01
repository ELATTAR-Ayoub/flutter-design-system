/// Public documentation page for the `keyframes` motion primitive.
///
/// **Why `EffectSection`, not `ShowcaseSection`, and why there is no single
/// widget.** `lib/src/components/ui/keyframes.dart` exports no component: it is
/// fourteen data tables (`EntranceMotion`, `StateChangeMotion`, … `DotSelectionMotion`) plus one player,
/// `KeyframePlayer`, and one transition table, `ContentSwapMotion`, that is
/// explicitly documented as not a keyframe at all. Every section below
/// stages one or several of the fourteen running on a representative host,
/// grouped the way the source file itself groups them (§D "the eleven",
/// §E the selection-control trio, §F the one transition).
///
/// **Fourteen, not fifteen.** The API Reference table below has exactly
/// fourteen rows. `ContentSwapMotion` gets its own short paragraph in the same
/// disclosure, named as what the source calls it: a transition, not a
/// keyframe.
///
/// **`pumpAndSettle` never appears in this page's own test.** `DiscreteProgressMotion`,
/// `LoadingShimmerMotion` and `LivePulseMotion` all run on a `repeat()`ing
/// `AnimationController` inside `KeyframePlayer` and never idle, so this
/// page's test uses `tester.pump()` and bounded `tester.pump(duration)`
/// calls throughout, exactly as `example/lib/pages/motion.dart` and
/// `test/motion_test.dart` already do for the same tables.
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

final ComponentDocSpec keyframesDocSpec = ComponentDocSpec(
  name: 'keyframes',
  title: 'Keyframes',
  description: keyframesDoc.description,
  sections: <DocsPageSection>[
    EffectSection(
      id: 'preview',
      title: 'Preview',
      description:
          'The same notification chip, twice. The left one is static: no '
          'KeyframePlayer wraps it. The right one is driven by EntranceMotion — '
          'opacity 0 → 1 by 55%, a scale table that overshoots twice '
          '(0.92×1.08 at 55%, 1.04×0.97 at 80%) before settling — over '
          'MotionDurations.popIn (550ms), MotionCurves.enter, fill: both. Replay '
          'remounts it, matching how the reference itself replays: a fresh '
          'key, not a restarted controller.',
      host: const _PreviewHost(),
      code: _previewCode,
      label: 'Preview specimen view',
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'keyframes has a real registry manifest, `elattar add keyframes` '
          'installs lib/src/components/ui/keyframes.dart and resolves its one '
          'registryDependency, source-foundation, automatically. The '
          'Manual tab is for a project not using the CLI.',
      command: keyframesDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/keyframes.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/ui/keyframes.dart's generated "
              '@ui/keyframes.dart payload into components/ui.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated keyframes source here when using '
              'manual mode.',
        ),
        DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so every table and KeyframePlayer '
              'are reachable the same way the CLI path already makes '
              'them.',
          code: "export 'keyframes.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'KeyframePlayer runs one table\'s clock and hands linear '
          'progress to builder; the easing lives in the table\'s own '
          'Animatable, never in the player.',
      code: _usageCode,
    ),
    EffectSection(
      id: 'entrance',
      title: 'Entrance & Exit',
      description:
          'Six of the nine anim-* tables the motion page demonstrates: '
          'each runs once and holds its final stop (fill: both). Replay '
          'remounts all six under a fresh key, the way the reference '
          'itself replays — a freshly keyed element restarting its CSS '
          'animation from t=0, never a rewound controller.',
      host: const _EntranceHost(),
      code: _entranceCode,
      label: 'Entrance and exit specimen view',
    ),
    EffectSection(
      id: 'looping',
      title: 'Looping',
      description:
          'The three tables that declare no fill mode at all: DiscreteProgressMotion '
          '(steps(8), never displays 360°), LoadingShimmerMotion (a sweeping gradient '
          'band) and LivePulseMotion (an expanding, fading ring around a live '
          'dot). All three repeat forever, and all three revert to their '
          'resting style — stop 0 — the instant reduced motion stills '
          'them, rather than holding a frozen frame the way the six above '
          'do.',
      host: const _LoopingHost(),
      code: _loopingCode,
      label: 'Looping specimen view',
      minHeight: space(56),
    ),
    EffectSection(
      id: 'progress',
      title: 'Progress',
      description:
          'The motion page\'s own two tables, declared for its duration '
          'and easing panels rather than for a named anim-* utility. The '
          'sweep bar genuinely fills, 0 → 1, over whichever MotionDurations '
          'rung its own row demonstrates. The travel chip is a verified '
          'no-op at its one real call site: a CSS percentage inside '
          'translateX resolves against the translated element\'s OWN '
          'border box, and that element is the 24px chip itself, so '
          '`calc(100% - 1.5rem)` evaluates to 0px and the chip never '
          'moves — only the easing panel around it communicates the '
          'curve.',
      host: const _ProgressHost(),
      code: _progressCode,
      label: 'Progress specimen view',
    ),
    EffectSection(
      id: 'selection-draw',
      title: 'Selection Draw',
      description:
          'Three tables that belong to the checkbox and the radio, and '
          'appear on no motion page at all: CheckmarkDrawMotion and DashDrawMotion '
          'both animate a CSS stroke-dashoffset, transcribed as a '
          '"drawn fraction" a caller reveals a path through; DotSelectionMotion is '
          'the radio dot arriving, the one table in the file that runs on '
          'MotionCurves.emphasized rather than MotionCurves.enter and overshoots twice '
          'over — once in the keyframe\'s own 1.35 stop, once again from '
          'the spring curve between stops.',
      host: const _SelectionDrawHost(),
      code: _selectionDrawCode,
      label: 'Selection draw specimen view',
    ),
    EffectSection(
      id: 'transition',
      title: 'Transition',
      description:
          'ContentSwapMotion is the one entry in this file that is not a '
          'keyframe: a transition, with no stops, only a from-state and a '
          'to-state. Tap to flip it. Both transform and opacity ride '
          'MotionCurves.emphasized over MotionDurations.slow (400ms), and because the '
          'curve exceeds 1 partway through, opacity clamps early — full '
          'opacity lands at roughly 147ms of the 400ms roll, a real '
          'crossfade the panel\'s own copy says does not happen.',
      host: const _TransitionHost(),
      code: _transitionCode,
      label: 'Transition specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'The fourteen keyframe tables this file exports, by name, read '
          'off lib/src/components/ui/keyframes.dart: what each animates, and the '
          'duration, curve and fill mode it runs under. ContentSwapMotion — a '
          'transition, not a keyframe — follows in its own paragraph.',
      child: const _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      child: const _StatesContent(),
    ),
    DisclosureSection(
      id: 'accessibility',
      title: 'Accessibility',
      child: const _AccessibilityContent(),
    ),
    DisclosureSection(
      id: 'keyboard',
      title: 'Keyboard',
      child: const _KeyboardContent(),
    ),
    DisclosureSection(
      id: 'responsive',
      title: 'Responsive',
      child: const _ResponsiveContent(),
    ),
    DisclosureSection(
      id: 'dependencies',
      title: 'Dependencies',
      child: const _DependenciesContent(),
    ),
    DisclosureSection(
      id: 'theming',
      title: 'Theming',
      child: const _ThemingContent(),
    ),
    DisclosureSection(
      id: 'source',
      title: 'Source',
      child: DocsInstallFacts(
        title: 'Reference',
        facts: <DocsInstallFact>[
          DocsInstallFact(
            label: 'Source',
            value: keyframesDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'test/motion_test.dart',
            description:
                'Every table in this file has its own group in the shared '
                'motion suite, sampled against the stopTolerance the file '
                'itself documents.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/keyframes_test.dart',
            description:
                'Covers this page: the article mounts, the full API '
                'table, a live replay and a live loop advance, and both '
                'themes — never with pumpAndSettle.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/keyframes/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class KeyframesDocPage extends StatelessWidget {
  const KeyframesDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: keyframesDoc.route,
    intro: DocsPageIntro(
      title: keyframesDoc.title,
      description: keyframesDoc.description,
    ),
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Components'),
      BreadcrumbEntry.page('Keyframes'),
    ],
    toc: keyframesDocSpec.toc,
    previous: null,
    next: null,
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('keyframes-doc-article'),
      child: ComponentDocPage(spec: keyframesDocSpec, header: false),
    ),
  );
}

/* ── Shared specimen shape ──────────────────────────────────────────────── */

class _Captioned extends StatelessWidget {
  const _Captioned({required this.caption, required this.child});

  final String caption;
  final Widget child;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      child,
      SizedBox(height: space(2)),
      StyledText(
        caption,
        TextStyles.small,
        color: ThemeScope.of(context).mutedForeground,
      ),
    ],
  );
}

class _Row extends StatelessWidget {
  const _Row({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: space(2)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          for (int i = 0; i < children.length; i++) ...<Widget>[
            if (i > 0) SizedBox(width: space(6)),
            children[i],
          ],
        ],
      ),
    ),
  );
}

class _Chip extends StatelessWidget {
  const _Chip({required this.child, this.keyValue});

  final Widget child;
  final String? keyValue;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Container(
      key: keyValue == null ? null : ValueKey<String>(keyValue!),
      width: space(28),
      height: space(28),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(Radii.lg),
        border: Border.all(color: theme.border, width: BorderWidths.hairline),
      ),
      child: child,
    );
  }
}

class _ReplayButton extends StatelessWidget {
  const _ReplayButton({required this.onTap, required this.keyValue});

  final VoidCallback onTap;
  final String keyValue;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return SizedBox(
      key: ValueKey<String>(keyValue),
      child: Press(
        onTap: onTap,
        child: Container(
          height: space(9),
          padding: EdgeInsets.symmetric(horizontal: space(4)),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: theme.secondary,
            borderRadius: BorderRadius.circular(Radii.full),
          ),
          child: StyledText(
            'Replay',
            TextStyles.small,
            color: theme.secondaryForeground,
          ),
        ),
      ),
    );
  }
}

/* ── Preview ─────────────────────────────────────────────────────────────── */

class _NotificationCard extends StatelessWidget {
  const _NotificationCard();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Container(
      width: space(48),
      padding: EdgeInsets.all(space(4)),
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(Radii.xl),
        border: Border.all(color: theme.border, width: BorderWidths.hairline),
      ),
      child: Row(
        children: <Widget>[
          const Icon(IconGlyph.bell, size: IconSize.md, tone: IconTone.action),
          SizedBox(width: space(3)),
          Expanded(
            child: StyledText(
              'New message',
              TextStyles.small,
              color: theme.foreground,
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewHost extends StatefulWidget {
  const _PreviewHost();

  @override
  State<_PreviewHost> createState() => _PreviewHostState();
}

class _PreviewHostState extends State<_PreviewHost> {
  int _run = 0;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      _Row(
        children: <Widget>[
          const _Captioned(
            caption: 'static (no player)',
            child: SizedBox(
              key: ValueKey<String>('keyframes-example:static'),
              child: _NotificationCard(),
            ),
          ),
          _Captioned(
            caption: 'KeyframePlayer(duration: EntranceMotion.duration, …)',
            child: SizedBox(
              key: const ValueKey<String>('keyframes-example:pop-in'),
              child: KeyedSubtree(
                key: ValueKey<String>('pop-in-$_run'),
                child: KeyframePlayer(
                  duration: EntranceMotion.duration,
                  fill: EntranceMotion.fill,
                  builder: (BuildContext context, double t, Widget? child) {
                    final Offset scale = EntranceMotion.scale.transform(t);
                    return Opacity(
                      opacity: EntranceMotion.opacity
                          .transform(t)
                          .clamp(0.0, 1.0),
                      child: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.diagonal3Values(
                          scale.dx,
                          scale.dy,
                          1,
                        ),
                        child: child,
                      ),
                    );
                  },
                  child: const _NotificationCard(),
                ),
              ),
            ),
          ),
        ],
      ),
      SizedBox(height: space(4)),
      _ReplayButton(
        keyValue: 'keyframes-example:preview-replay',
        onTap: () => setState(() => _run++),
      ),
    ],
  );
}

const String _previewCode =
    "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
    '// Re-key to replay, the way the reference itself replays.\n'
    "KeyedSubtree(\n"
    "  key: ValueKey('pop-in-\$run'),\n"
    '  child: KeyframePlayer(\n'
    '    duration: EntranceMotion.duration,\n'
    '    fill: EntranceMotion.fill,\n'
    '    builder: (context, t, child) {\n'
    '      final scale = EntranceMotion.scale.transform(t);\n'
    '      return Opacity(\n'
    '        opacity: EntranceMotion.opacity.transform(t),\n'
    '        child: Transform(\n'
    '          alignment: Alignment.center,\n'
    '          transform: Matrix4.diagonal3Values(scale.dx, scale.dy, 1),\n'
    '          child: child,\n'
    '        ),\n'
    '      );\n'
    '    },\n'
    "    child: const NotificationCard(),\n"
    '  ),\n'
    ')';

/* ── Entrance & Exit ─────────────────────────────────────────────────────── */

class _EntranceHost extends StatefulWidget {
  const _EntranceHost();

  @override
  State<_EntranceHost> createState() => _EntranceHostState();
}

class _EntranceHostState extends State<_EntranceHost> {
  int _run = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        KeyedSubtree(
          key: ValueKey<String>('entrance-$_run'),
          child: _Row(
            children: <Widget>[
              _Captioned(
                caption: 'StateChangeMotion',
                child: _Chip(
                  keyValue: 'keyframes-example:jelly',
                  child: KeyframePlayer(
                    duration: StateChangeMotion.duration,
                    fill: StateChangeMotion.fill,
                    builder: (BuildContext context, double t, Widget? child) {
                      final Offset scale = StateChangeMotion.scale.transform(t);
                      return Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.diagonal3Values(
                          scale.dx,
                          scale.dy,
                          1,
                        ),
                        child: child,
                      );
                    },
                    child: const Icon(IconGlyph.check, tone: IconTone.success),
                  ),
                ),
              ),
              _Captioned(
                caption: 'SpringEntranceMotion',
                child: _Chip(
                  keyValue: 'keyframes-example:spring-up',
                  child: KeyframePlayer(
                    duration: SpringEntranceMotion.duration,
                    fill: SpringEntranceMotion.fill,
                    builder: (BuildContext context, double t, Widget? child) =>
                        Opacity(
                          opacity: SpringEntranceMotion.opacity
                              .transform(t)
                              .clamp(0.0, 1.0),
                          child: Transform.translate(
                            offset: Offset(
                              0,
                              SpringEntranceMotion.translateY.transform(t),
                            ),
                            child: child,
                          ),
                        ),
                    child: const Icon(
                      IconGlyph.arrowRight,
                      tone: IconTone.action,
                    ),
                  ),
                ),
              ),
              _Captioned(
                caption: 'OpenMotion',
                child: _Chip(
                  keyValue: 'keyframes-example:jelly-in',
                  child: KeyframePlayer(
                    duration: OpenMotion.duration,
                    fill: OpenMotion.fill,
                    builder: (BuildContext context, double t, Widget? child) =>
                        Opacity(
                          opacity: OpenMotion.opacity
                              .transform(t)
                              .clamp(0.0, 1.0),
                          child: Transform.translate(
                            offset: Offset(
                              0,
                              OpenMotion.translateY.transform(t),
                            ),
                            child: Transform.scale(
                              scale: OpenMotion.scale.transform(t),
                              child: child,
                            ),
                          ),
                        ),
                    child: const Icon(IconGlyph.sparkles, tone: IconTone.value),
                  ),
                ),
              ),
              _Captioned(
                caption: 'TextRevealMotion',
                child: _Chip(
                  keyValue: 'keyframes-example:sign-on',
                  child: KeyframePlayer(
                    duration: TextRevealMotion.duration,
                    fill: TextRevealMotion.fill,
                    builder: (BuildContext context, double t, Widget? child) {
                      final TextRevealFrame frame = TextRevealMotion.frameAt(t);
                      final TextStyle style = StyledText.styleOf(
                        context,
                        TextStyles.small,
                        color: theme.premiumText,
                      ).copyWith(shadows: frame.shadows(theme.premiumText));
                      return Opacity(
                        opacity: frame.opacity,
                        child: ColorFiltered(
                          colorFilter: frame.brightnessFilter,
                          child: Text('ON', style: style),
                        ),
                      );
                    },
                  ),
                ),
              ),
              _Captioned(
                caption: 'RevealMotion',
                child: _Chip(
                  keyValue: 'keyframes-example:reveal',
                  child: KeyframePlayer(
                    duration: RevealMotion.duration,
                    fill: RevealMotion.fill,
                    builder: (BuildContext context, double t, Widget? child) =>
                        Opacity(
                          opacity: RevealMotion.opacity
                              .transform(t)
                              .clamp(0.0, 1.0),
                          child: Transform(
                            transform: RevealMotion.transformAt(t),
                            alignment: Alignment.center,
                            child: child,
                          ),
                        ),
                    child: const Icon(
                      IconGlyph.sparkles,
                      tone: IconTone.action,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: space(4)),
        _ReplayButton(
          keyValue: 'keyframes-example:entrance-replay',
          onTap: () => setState(() => _run++),
        ),
      ],
    );
  }
}

const String _entranceCode =
    '// One table, three shapes: opacity alone (SpringEntranceMotion), scale alone\n'
    '// (StateChangeMotion), or opacity + scale + translateY together (OpenMotion).\n'
    'KeyframePlayer(\n'
    '  duration: OpenMotion.duration,\n'
    '  fill: OpenMotion.fill,\n'
    '  builder: (context, t, child) => Opacity(\n'
    '    opacity: OpenMotion.opacity.transform(t),\n'
    '    child: Transform.translate(\n'
    '      offset: Offset(0, OpenMotion.translateY.transform(t)),\n'
    '      child: Transform.scale(\n'
    '        scale: OpenMotion.scale.transform(t),\n'
    '        child: child,\n'
    '      ),\n'
    '    ),\n'
    '  ),\n'
    "  child: const Icon(...),\n"
    ')';

/* ── Looping ─────────────────────────────────────────────────────────────── */

class _LoopingHost extends StatelessWidget {
  const _LoopingHost();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return _Row(
      children: <Widget>[
        _Captioned(
          caption: 'DiscreteProgressMotion — steps(8), never shows 360°',
          child: _Chip(
            keyValue: 'keyframes-example:ratchet',
            child: KeyframePlayer(
              duration: DiscreteProgressMotion.duration,
              fill: DiscreteProgressMotion.fill,
              repeat: DiscreteProgressMotion.loops,
              builder: (BuildContext context, double t, Widget? child) =>
                  Transform.rotate(
                    angle: DiscreteProgressMotion.radiansAt(t),
                    child: child,
                  ),
              child: const Icon(IconGlyph.refreshCw, tone: IconTone.action),
            ),
          ),
        ),
        _Captioned(
          caption: 'LoadingShimmerMotion — a sweeping gradient band',
          child: SizedBox(
            key: const ValueKey<String>('keyframes-example:shimmer'),
            width: space(28),
            height: space(28),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Radii.lg),
              child: KeyframePlayer(
                duration: LoadingShimmerMotion.duration,
                fill: LoadingShimmerMotion.fill,
                repeat: LoadingShimmerMotion.loops,
                builder: (BuildContext context, double t, Widget? child) =>
                    CustomPaint(
                      painter: _ShimmerPainter(
                        t: t,
                        gradient: LoadingShimmerMotion.gradient(theme),
                      ),
                      size: Size(space(28), space(28)),
                    ),
              ),
            ),
          ),
        ),
        _Captioned(
          caption: 'LivePulseMotion — an expanding, fading ring',
          child: SizedBox(
            key: const ValueKey<String>('keyframes-example:pulse-live'),
            width: space(28),
            height: space(28),
            child: Center(
              child: KeyframePlayer(
                duration: LivePulseMotion.duration,
                fill: LivePulseMotion.fill,
                repeat: LivePulseMotion.loops,
                builder: (BuildContext context, double t, Widget? child) =>
                    CustomPaint(painter: _PulseLivePainter(t: t)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

const String _loopingCode =
    'KeyframePlayer(\n'
    '  duration: DiscreteProgressMotion.duration,\n'
    '  fill: DiscreteProgressMotion.fill,\n'
    '  repeat: DiscreteProgressMotion.loops,\n'
    '  builder: (context, t, child) =>\n'
    '      Transform.rotate(angle: DiscreteProgressMotion.radiansAt(t), child: child),\n'
    "  child: const Icon(...),\n"
    ')';

class _ShimmerPainter extends CustomPainter {
  const _ShimmerPainter({required this.t, required this.gradient});

  final double t;
  final LinearGradient gradient;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect tile = Rect.fromLTWH(
      LoadingShimmerMotion.offsetAt(t, size.width),
      0,
      LoadingShimmerMotion.tileWidth(size.width),
      size.height,
    );
    canvas.drawRect(
      Offset.zero & size,
      Paint()..shader = gradient.createShader(tile),
    );
  }

  @override
  bool shouldRepaint(covariant _ShimmerPainter oldDelegate) =>
      oldDelegate.t != t;
}

class _PulseLivePainter extends CustomPainter {
  const _PulseLivePainter({required this.t});

  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero);
    canvas.drawCircle(
      center,
      LivePulseMotion.ringRadiusAt(t),
      Paint()..color = LivePulseMotion.ringColorAt(t),
    );
    canvas.drawCircle(
      center,
      LivePulseMotion.dotRadius,
      Paint()
        ..color = LivePulseMotion.dotColor.withValues(
          alpha: LivePulseMotion.dotOpacityAt(t),
        ),
    );
  }

  @override
  bool shouldRepaint(covariant _PulseLivePainter oldDelegate) =>
      oldDelegate.t != t;
}

/* ── Progress ────────────────────────────────────────────────────────────── */

class _ProgressHost extends StatelessWidget {
  const _ProgressHost();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _Captioned(
          caption: 'SweepMotion — 0 → 1, over MotionDurations.slow here',
          child: SizedBox(
            key: const ValueKey<String>('keyframes-example:sweep'),
            width: space(56),
            height: space(3),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Radii.sm),
              child: DecoratedBox(
                decoration: BoxDecoration(color: theme.muted),
                child: KeyframePlayer(
                  duration: MotionDurations.slow,
                  fill: SweepMotion.fill,
                  builder: (BuildContext context, double t, Widget? child) =>
                      FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: SweepMotion.widthFactor.transform(t),
                        child: DecoratedBox(
                          decoration: BoxDecoration(color: theme.primary),
                        ),
                      ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: space(6)),
        _Captioned(
          caption: 'TravelMotion — a verified no-op at its real 24px call site',
          child: SizedBox(
            key: const ValueKey<String>('keyframes-example:travel'),
            width: space(56),
            height: space(6),
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: theme.muted,
                      borderRadius: BorderRadius.circular(Radii.sm),
                    ),
                  ),
                ),
                KeyframePlayer(
                  duration: TravelMotion.duration,
                  fill: TravelMotion.fill,
                  builder: (BuildContext context, double t, Widget? child) =>
                      Transform.translate(
                        offset: Offset(
                          TravelMotion.translationAt(
                            t,
                            TravelMotion.inset,
                            curve: MotionCurves.enter,
                          ),
                          0,
                        ),
                        child: child,
                      ),
                  child: Container(
                    width: TravelMotion.inset,
                    height: TravelMotion.inset,
                    decoration: BoxDecoration(
                      color: theme.accent,
                      borderRadius: BorderRadius.circular(Radii.sm),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

const String _progressCode =
    'KeyframePlayer(\n'
    '  duration: MotionDurations.slow, // whichever rung this row demonstrates\n'
    '  fill: SweepMotion.fill,\n'
    '  builder: (context, t, child) => FractionallySizedBox(\n'
    '    alignment: Alignment.centerLeft,\n'
    '    widthFactor: SweepMotion.widthFactor.transform(t),\n'
    '    child: child,\n'
    '  ),\n'
    ')';

/* ── Selection Draw ──────────────────────────────────────────────────────── */

class _SelectionDrawHost extends StatelessWidget {
  const _SelectionDrawHost();

  @override
  Widget build(BuildContext context) => _Row(
    children: <Widget>[
      _Captioned(
        caption:
            'CheckmarkDrawMotion — drawnFractionAt, revealed left to right',
        child: _Chip(
          keyValue: 'keyframes-example:check-draw',
          child: KeyframePlayer(
            duration: CheckmarkDrawMotion.duration,
            fill: CheckmarkDrawMotion.fill,
            builder: (BuildContext context, double t, Widget? child) =>
                ClipRect(
                  clipper: _FractionClipper(
                    CheckmarkDrawMotion.drawnFractionAt(t),
                  ),
                  child: child,
                ),
            child: const Icon(IconGlyph.check, tone: IconTone.success),
          ),
        ),
      ),
      _Captioned(
        caption: 'DashDrawMotion — the radio ring\'s own dash draw',
        child: _Chip(
          keyValue: 'keyframes-example:dash-draw',
          child: KeyframePlayer(
            duration: DashDrawMotion.duration,
            fill: DashDrawMotion.fill,
            builder: (BuildContext context, double t, Widget? child) =>
                ClipRect(
                  clipper: _FractionClipper(DashDrawMotion.drawnFractionAt(t)),
                  child: child,
                ),
            child: const Icon(IconGlyph.radio, tone: IconTone.action),
          ),
        ),
      ),
      _Captioned(
        caption: 'DotSelectionMotion — spring, overshoots twice',
        child: _Chip(
          keyValue: 'keyframes-example:dot-pop',
          child: KeyframePlayer(
            duration: DotSelectionMotion.duration,
            fill: DotSelectionMotion.fill,
            builder: (BuildContext context, double t, Widget? child) => Opacity(
              opacity: DotSelectionMotion.opacity.transform(t).clamp(0.0, 1.0),
              child: Transform.scale(
                scale: DotSelectionMotion.scale.transform(t),
                child: child,
              ),
            ),
            child: const Icon(IconGlyph.radio, tone: IconTone.value),
          ),
        ),
      ),
    ],
  );
}

class _FractionClipper extends CustomClipper<Rect> {
  const _FractionClipper(this.fraction);

  final double fraction;

  @override
  Rect getClip(Size size) =>
      Rect.fromLTWH(0, 0, size.width * fraction.clamp(0.0, 1.0), size.height);

  @override
  bool shouldReclip(covariant _FractionClipper oldClipper) =>
      oldClipper.fraction != fraction;
}

const String _selectionDrawCode =
    'KeyframePlayer(\n'
    '  duration: CheckmarkDrawMotion.duration,\n'
    '  fill: CheckmarkDrawMotion.fill,\n'
    '  builder: (context, t, child) => ClipRect(\n'
    '    clipper: FractionClipper(CheckmarkDrawMotion.drawnFractionAt(t)),\n'
    '    child: child,\n'
    '  ),\n'
    "  child: const Icon(...),\n"
    ')';

/* ── Transition ──────────────────────────────────────────────────────────── */

class _TransitionHost extends StatefulWidget {
  const _TransitionHost();

  @override
  State<_TransitionHost> createState() => _TransitionHostState();
}

class _TransitionHostState extends State<_TransitionHost> {
  bool _flipped = false;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final Duration duration = effectiveMotionDuration(
      context,
      ContentSwapMotion.duration,
    );
    final double cellHeight = space(10);
    final double travel = ContentSwapMotion.travelFor(cellHeight);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Press(
          onTap: () => setState(() => _flipped = !_flipped),
          child: SizedBox(
            key: const ValueKey<String>('keyframes-example:swap-roll'),
            width: cellHeight,
            height: cellHeight,
            child: ClipRect(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.card,
                  borderRadius: BorderRadius.circular(Radii.lg),
                  border: Border.all(
                    color: theme.border,
                    width: BorderWidths.hairline,
                  ),
                ),
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(end: _flipped ? 1 : 0),
                  duration: duration,
                  curve: ContentSwapMotion.curve,
                  builder: (BuildContext context, double v, Widget? _) => Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Transform.translate(
                        offset: Offset(0, -travel * v),
                        child: Opacity(
                          opacity: (1 - v).clamp(0.0, 1.0),
                          child: const Icon(
                            IconGlyph.check,
                            tone: IconTone.success,
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(0, travel * (1 - v)),
                        child: Opacity(
                          opacity: v.clamp(0.0, 1.0),
                          child: const Icon(IconGlyph.x, tone: IconTone.error),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: space(2)),
        StyledText(
          'Tap to roll',
          TextStyles.small,
          color: theme.mutedForeground,
        ),
      ],
    );
  }
}

const String _transitionCode =
    'TweenAnimationBuilder<double>(\n'
    '  tween: Tween(end: flipped ? 1 : 0),\n'
    '  duration: ContentSwapMotion.duration,\n'
    '  curve: ContentSwapMotion.curve,\n'
    '  builder: (context, v, _) => Transform.translate(\n'
    '    offset: Offset(0, ContentSwapMotion.travelFor(cellHeight) * v),\n'
    "    child: const Icon(...),\n"
    '  ),\n'
    ')';

/* ── Disclosure content ─────────────────────────────────────────────────── */

const String _usageCode = '''
import 'package:elattar_design_system/elattar_design_system.dart';

KeyframePlayer(
  duration: EntranceMotion.duration,
  fill: EntranceMotion.fill,
  builder: (context, t, child) {
    final scale = EntranceMotion.scale.transform(t);
    return Opacity(
      opacity: EntranceMotion.opacity.transform(t),
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.diagonal3Values(scale.dx, scale.dy, 1),
        child: child,
      ),
    );
  },
  child: const NotificationCard(),
)''';

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      const DocsApiTable(title: 'The fourteen keyframes', facts: _apiFacts),
      SizedBox(height: space(4)),
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: LayoutWidths.prose),
        child: StyledText(
          'A fifteenth entry, ContentSwapMotion, lives in the same file but is not '
          'one of the fourteen: it is a transition (a from-state and a '
          'to-state, no stops), running MotionDurations.slow (400ms) on '
          'MotionCurves.emphasized — see the Transition section above.',
          TextStyles.small,
          color: ThemeScope.of(context).mutedForeground,
        ),
      ),
    ],
  );
}

const List<DocsApiFact> _apiFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'EntranceMotion',
    type: 'both · 550ms · ease-out',
    description:
        'Opacity 0 → 1 by 55%, and a scale table that overshoots twice '
        '(0.92×1.08 at 55%, 1.04×0.97 at 80%) before settling at 100%. '
        'A generic entrance pop.',
  ),
  DocsApiFact(
    name: 'StateChangeMotion',
    type: 'both · 600ms · ease-out',
    description:
        'Scale only, oscillating wide-then-tall then back (1.18×0.82 at '
        '30%, 0.88×1.12 at 45%, …): a squash-and-stretch wobble with no '
        'opacity change, used for an arriving glyph.',
  ),
  DocsApiFact(
    name: 'SpringEntranceMotion',
    type: 'both · 800ms · ease-settle',
    description:
        'Opacity 0 → 1 by 55%, translateY 32px → -4px → 1.5px → -0.5px → '
        '0: rises past its resting position twice before settling.',
  ),
  DocsApiFact(
    name: 'OpenMotion',
    type: 'both · 420ms · ease-spring',
    description:
        'Opacity, scale and translateY together: the active indicator\'s own '
        'arrival — opacity 0 → 1 by 60%, scale 0.92 → 1.02 → 1, translateY '
        '24px → -4px → 0.',
  ),
  DocsApiFact(
    name: 'DiscreteProgressMotion',
    type: 'none · 1400ms · steps(8), loops',
    description:
        'Eight held 45° positions of 175ms each. 360° is never displayed: '
        'the wrap frame holds the last position and jumps straight to 0° '
        'on the next cycle.',
  ),
  DocsApiFact(
    name: 'TextRevealMotion',
    type: 'both · 900ms · steps(1, end)',
    description:
        'Opacity, a brightness filter and a text-shadow glow across six '
        'hard cuts (no interpolation between stops): a neon '
        'power-up-flicker-catch, holding its 70% frame forever once done.',
  ),
  DocsApiFact(
    name: 'RevealMotion',
    type: 'both · 550ms · ease-out',
    description:
        'Opacity 0 → 1 and an orthographic rotationY from -38° to 0° with '
        'a scale ease to 1: a card turning face-up.',
  ),
  DocsApiFact(
    name: 'LoadingShimmerMotion',
    type: 'none · 1400ms · ease-in-out, loops',
    description:
        'A 2×-wide gradient band sweeping left to right across a '
        'skeleton, repeating, tiled so the box is never empty at the '
        'extremes.',
  ),
  DocsApiFact(
    name: 'LivePulseMotion',
    type: 'none · 2000ms · ease-in-out, loops',
    description:
        'A ring expanding outward while it fades, around a dot whose own '
        'opacity breathes: the live-status indicator.',
  ),
  DocsApiFact(
    name: 'SweepMotion',
    type: 'both · caller-supplied · ease-out',
    description:
        'widthFactor 0 → 1: a progress bar filling. No duration constant '
        'of its own — the motion page\'s durations panel supplies one of '
        'the six MotionDurations rungs per row, because the panel IS the '
        'duration scale.',
  ),
  DocsApiFact(
    name: 'TravelMotion',
    type: 'both · 1000ms (MotionDurations.bloom) · caller-supplied curve',
    description:
        'translateX 0 → calc(100% - 1.5rem), where 100% resolves against '
        'the translated element\'s OWN width. At its one real call site '
        '(a 24px chip) that evaluates to 0px: a verified no-op.',
  ),
  DocsApiFact(
    name: 'CheckmarkDrawMotion',
    type: 'both · 280ms · ease-out',
    description:
        'stroke-dashoffset 22 → 0: the checkbox tick drawing itself on, '
        'transcribed as drawnFractionAt for a caller with no SVG '
        'stroke-dasharray to lean on.',
  ),
  DocsApiFact(
    name: 'DashDrawMotion',
    type: 'both · 200ms · ease-out',
    description:
        'stroke-dashoffset 12 → 0: the radio ring\'s own shorter dash '
        'draw, same shape as CheckmarkDrawMotion over a smaller dash array.',
  ),
  DocsApiFact(
    name: 'DotSelectionMotion',
    type: 'both · 320ms · ease-spring',
    description:
        'Scale 0 → 1.35 → 1 with opacity reaching 1 at the same 55% stop '
        'as the scale peak: the radio dot arriving, overshooting the '
        'keyframe\'s own 1.35 stop and then the spring curve\'s own '
        'overshoot on top of it.',
  ),
];

class _StatesContent extends StatelessWidget {
  const _StatesContent();

  @override
  Widget build(
    BuildContext context,
  ) => _bullets(ThemeScope.of(context), <String>[
    'This file has no "component state" of its own — each table is '
        'data, and KeyframePlayer is the one place a run state '
        'lives: forward-once (the eleven single-run tables, all fill: '
        'both) or repeat() forever (DiscreteProgressMotion, LoadingShimmerMotion, '
        'LivePulseMotion, all fill: none).',
    'Reduced motion is the one real state every table answers to. '
        'KeyframePlayer reads effectiveMotionDuration on every build: '
        'under MediaQuery.disableAnimations the controller stops and '
        'its value snaps outright — never a zero-length animation — '
        'to upperBound for a both-fill table (holding its final '
        'stop) or to lowerBound for a none-fill looper (reverting to '
        'the element\'s own resting style, stop 0).',
    'A both-fill table never restarts on its own: replay is remount, '
        'a fresh KeyedSubtree — see the Preview and Entrance & Exit '
        'sections above.',
  ]);
}

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'KeyframePlayer renders no Semantics node: build() returns an '
            'AnimatedBuilder, wrapped in a RepaintBoundary only when '
            'repeat is true. Whatever semantics the builder\'s own output '
            'carries pass through untouched.',
        'TextRevealMotion is the one table this file\'s own doc flags as a '
            'hazard: opacity and brightness alternate roughly 3.3 times '
            'per second across its six cuts, under the WCAG 3Hz flash '
            'threshold but the exact behaviour the reference\'s own '
            '"don\'t flash or strobe" rule warns against. Both ship, '
            'because the copy and the mechanism come from the same '
            'source and neither overrides the other.',
        'Nothing here announces that a surface is animating: reduced '
            'motion is the only accessibility lever this file exposes, '
            'and it is read automatically from the platform, never from '
            'a widget-level toggle.',
      ]);
}

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Takes no focus and handles no key: none of the fourteen tables '
            'or KeyframePlayer itself declare a Focus, a FocusNode or '
            'an onKeyEvent. Every specimen on this page that responds to '
            'a tap (the Preview and Entrance & Exit replay buttons, the '
            'Transition toggle) does so through the Press this page '
            'composes around it, not through anything keyframes.dart '
            'exposes.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(
    BuildContext context,
  ) => _bullets(ThemeScope.of(context), <String>[
    'No breakpoint branching anywhere in keyframes.dart: '
        'BuildContext width is never read for a layout decision.',
    'Every geometric table (LoadingShimmerMotion\'s tile, TravelMotion\'s distance) '
        'is expressed as a function of the host\'s own size — '
        'tileWidth(width), distanceFor(elementWidth) — so the motion '
        'scales with whatever box a caller gives it, exactly like a '
        'CSS background-size or a percentage transform would.',
  ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      _bullets(ThemeScope.of(context), <String>[
        'File: lib/src/components/ui/keyframes.dart: one file, no companions.',
        'Flutter imports: dart:math, package:flutter/widgets.dart.',
        'Foundation imports: foundation/colors.dart (OklabColor, Palette, '
            'for LivePulseMotion\'s ring), foundation/motion.dart '
            '(MotionDurations, MotionCurves, effectiveMotionDuration), '
            'foundation/shadows.dart (ShadowLayer, for TextRevealMotion\'s blur '
            'conversion), foundation/spacing.dart (space), '
            'foundation/theme.dart, theme_scope.dart.',
        'registryDependencies, resolved automatically by `elattar add '
            'keyframes`: source-foundation — copied verbatim from '
            'registry/components/keyframes.json.',
        'Real use in this corpus: active_indicator.dart\'s own private '
            '_jellyScale is the pattern Keyframes.track generalises; '
            'icon_swap.dart composes StateChangeMotion with ContentSwapMotion for its own '
            'arrival squash; the checkbox and the radio consume '
            'CheckmarkDrawMotion, DashDrawMotion and DotSelectionMotion directly.',
      ]),
      SizedBox(height: space(2)),
      DocsLinkRow(
        links: <DocsLink>[
          DocsLink(label: 'Icon Swap', route: '/components/icon_swap'),
          DocsLink(
            label: 'Active Indicator',
            route: '/components/active_indicator',
          ),
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
  Widget build(
    BuildContext context,
  ) => _bullets(ThemeScope.of(context), <String>[
    'Every table in this file is theme-blind: the geometry, the '
        'durations and the curves are all constants. The two that '
        'touch colour at all resolve it live rather than storing it: '
        'LivePulseMotion.ringColorAt mixes a fixed ink against '
        'OklabColor.mix, and TextRevealMotion\'s currentColor is whatever the '
        'caller\'s own TextStyle carries in — this page passes '
        'theme.premiumText, matching the reference\'s own '
        'text-value-ink.',
    'What actually flips with the theme on this page is the host '
        'around each table: the chip fill (theme.card), its border '
        '(theme.border) and the icon tones passed to Icon — the '
        'same as any other specimen on the kit.',
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
