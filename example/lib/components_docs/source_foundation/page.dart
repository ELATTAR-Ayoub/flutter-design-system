/// Public documentation page for the `source-foundation` foundation.
///
/// **The only foundation-type registry item, and the root of the graph.**
/// Every other page in this rollout lists `source-foundation` in its
/// Dependencies disclosure; this page is the one place that relationship
/// runs backward. Its own `registryDependencies` is empty — nothing in the
/// package sits beneath it.
///
/// **Why `EffectSection`, not `ShowcaseSection`, and why there is no single
/// specimen.** `lib/src/design_system/foundation/` is eleven files of tokens and
/// utilities — colours, both themes, typography, spacing, motion, shadows,
/// surfaces, dates, text layout — not one widget with a shape to show. This
/// page cannot stage "the foundation" as one specimen, so it is built out
/// of small `EffectSection`s that each stage exactly one layer against a
/// host: a colour pair, a type ramp, a spacing rung, a motion pairing, a
/// shadow — the same four the brief for this page names, plus motion,
/// which the registry's own description lists alongside them.
///
/// **The Dependencies disclosure runs the other way.** Every other page's
/// Dependencies section lists what IT needs. This page's lists a
/// representative sample of the 93 registry items that need IT, with a
/// stated count rather than an attempted full list — see that section.
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

final ComponentDocSpec sourceFoundationDocSpec = ComponentDocSpec(
  name: 'source_foundation',
  title: 'Source Foundation',
  description: sourceFoundationDoc.description,
  sections: <DocsPageSection>[
    EffectSection(
      id: 'preview',
      title: 'Preview',
      description:
          'One small card, built from four of the foundation\'s own '
          'layers at once: theme.card and theme.foreground for colour, '
          'TextStyles.h4 and TextStyles.small for type, space(...) for every '
          'measure in it, and Shadows.md for its elevation. Nothing on '
          'it is a literal.',
      host: const _PreviewHost(),
      code: _previewCode,
      label: 'Preview specimen view',
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'source-foundation has a real registry manifest, `elattar add '
          'source-foundation` installs all eleven files plus its three '
          'bundled fonts (InterVariable, Geist Mono, Redaction35) and '
          'their OFL licenses. Its registryDependencies list is empty — '
          'this is the root of the graph. The Manual tab is for a '
          'project not using the CLI.',
      command: sourceFoundationDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/design_system/foundation.dart',
          title: '1. Copy the source',
          description:
              "Copy all eleven files under this package's "
              'lib/src/design_system/foundation/ into your own project at '
              'lib/design_system/foundation/ — the repository source path '
              'and the consumer destination are not the same path.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated foundation source here when using '
              'manual mode.',
        ),
        DocsCodeFile(
          path: 'pubspec.yaml',
          title: '2. Register the three bundled fonts',
          description:
              'InterVariable (InterLocal), Geist Mono and Redaction35 — '
              'the manifest\'s own fonts list — under flutter > fonts.',
          code:
              'flutter:\n'
              '  fonts:\n'
              '    - family: InterLocal\n'
              '      fonts:\n'
              '        - asset: fonts/InterVariable.ttf',
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'Wrap the app once in ThemeScope; every token below reads off '
          'ThemeScope.of(context) or a bare static from there on.',
      code: _usageCode,
    ),
    EffectSection(
      id: 'color',
      title: 'Semantic Color',
      description:
          'A representative seven of ThemeTokens\'s roughly thirty '
          'colour fields, each a background/foreground pair rather than '
          'a lone swatch — every semantic colour in this system is '
          'issued in pairs so a caller never has to guess which text '
          'reads on which fill. Toggle the theme switch in the app '
          'shell to see every pair repaint at once.',
      host: const _ColorHost(),
      code: _colorCode,
      label: 'Semantic color specimen view',
    ),
    EffectSection(
      id: 'type',
      title: 'Type Ramp',
      description:
          'Seven of TextStyles\'s roughly thirty specs, display down to '
          'code — each an TextStyleToken carrying its own family, size, '
          'weight and leading, applied through StyledText rather than a '
          'bare TextStyle.',
      host: const _TypeHost(),
      code: _typeCode,
      label: 'Type ramp specimen view',
    ),
    EffectSection(
      id: 'spacing',
      title: 'Spacing Rhythm',
      description:
          'space(n) = n × 4 logical pixels — Tailwind\'s own spacing unit, '
          'never redeclared in the reference stylesheet. Six rungs, 1 '
          'through 32, the same function that sizes every gap, padding '
          'and radius on every page in this kit.',
      host: const _SpacingHost(),
      code: _spacingCode,
      label: 'Spacing rhythm specimen view',
    ),
    EffectSection(
      id: 'motion',
      title: 'Motion',
      description:
          'Three MotionDurations/MotionCurves pairings a caller reaches for '
          'constantly: MotionDurations.tick with MotionCurves.enter for a hover, '
          'MotionDurations.normal with MotionCurves.emphasized for a press response, '
          'MotionDurations.slow with MotionCurves.settle for a panel opening. '
          'Tap any chip to replay it.',
      host: const _MotionHost(),
      code: _motionCode,
      label: 'Motion specimen view',
    ),
    EffectSection(
      id: 'shadow',
      title: 'Shadow Elevation',
      description:
          'Shadows.sm through e4 — the ambient depth ladder, the '
          'other shadow family being the MACHINE surfaces '
          '(Shadows.control and its kin) the Surface page '
          'documents on its own. Every layer stores a Color '
          'Function(ThemeTokens), never a literal Color, which is why '
          'this ladder repaints correctly in both themes without this '
          'page doing anything special.',
      host: const _ShadowHost(),
      code: _shadowCode,
      label: 'Shadow elevation specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'A representative inventory of what lib/src/design_system/foundation/ '
          'exports, by class, read off the source: not every static '
          'field of every class — there are hundreds — but every class '
          'this page\'s own specimens reach for, and what each one is '
          'for.',
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
            value: sourceFoundationDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from. Eleven files, not one.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value:
                'test/foundation_colors_test.dart, test/foundation_type_motion_test.dart, '
                'test/motion_test.dart, test/effects_test.dart, '
                'test/theme_scope_test.dart',
            description:
                'Every foundation file has its own dedicated suite; '
                'there is no single foundation_test.dart because there '
                'is no single foundation file.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/source_foundation_test.dart',
            description:
                'Covers this page: the article mounts, the API table, '
                'every specimen this page claims to show, and both '
                'themes — never with pumpAndSettle.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/source_foundation/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class SourceFoundationDocPage extends StatelessWidget {
  const SourceFoundationDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: sourceFoundationDoc.route,
    intro: DocsPageIntro(
      title: sourceFoundationDoc.title,
      description: sourceFoundationDoc.description,
    ),
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Components'),
      BreadcrumbEntry.page('Source Foundation'),
    ],
    toc: sourceFoundationDocSpec.toc,
    previous: null,
    next: null,
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('source-foundation-doc-article'),
      child: ComponentDocPage(spec: sourceFoundationDocSpec, header: false),
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
        TextStyles.section,
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

/* ── Preview ─────────────────────────────────────────────────────────────── */

class _PreviewHost extends StatelessWidget {
  const _PreviewHost();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Container(
      key: const ValueKey<String>('source-foundation-example:preview'),
      width: space(72),
      padding: EdgeInsets.all(space(5)),
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(Radii.xl),
        boxShadow: Shadows.md.outerShadows(theme),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          StyledText(
            'Every layer, at once',
            TextStyles.h4,
            color: theme.cardForeground,
          ),
          SizedBox(height: space(2)),
          StyledText(
            'theme.card, TextStyles.h4, space(5) padding, Shadows.md — four '
            'foundation layers, one card.',
            TextStyles.small,
            color: theme.mutedForeground,
          ),
        ],
      ),
    );
  }
}

const String _previewCode =
    "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
    'Container(\n'
    '  padding: EdgeInsets.all(space(5)),\n'
    '  decoration: BoxDecoration(\n'
    '    color: theme.card,\n'
    '    borderRadius: BorderRadius.circular(Radii.xl),\n'
    '    boxShadow: Shadows.md.outerShadows(theme),\n'
    '  ),\n'
    "  child: StyledText('Every layer, at once', TextStyles.h4, color: theme.cardForeground),\n"
    ')';

/* ── Semantic Color ──────────────────────────────────────────────────────── */

class _ColorPair extends StatelessWidget {
  const _ColorPair({
    required this.label,
    required this.background,
    required this.foreground,
    required this.keyValue,
  });

  final String label;
  final Color background;
  final Color foreground;
  final String keyValue;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Container(
      key: ValueKey<String>(keyValue),
      width: space(24),
      height: space(16),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(Radii.lg),
        border: Border.all(color: theme.border, width: BorderWidths.hairline),
      ),
      child: StyledText(label, TextStyles.small, color: foreground),
    );
  }
}

class _ColorHost extends StatelessWidget {
  const _ColorHost();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return _Row(
      children: <Widget>[
        _ColorPair(
          keyValue: 'source-foundation-example:color-background',
          label: 'background',
          background: theme.background,
          foreground: theme.foreground,
        ),
        _ColorPair(
          keyValue: 'source-foundation-example:color-card',
          label: 'card',
          background: theme.card,
          foreground: theme.cardForeground,
        ),
        _ColorPair(
          keyValue: 'source-foundation-example:color-primary',
          label: 'primary',
          background: theme.primary,
          foreground: theme.primaryForeground,
        ),
        _ColorPair(
          keyValue: 'source-foundation-example:color-secondary',
          label: 'secondary',
          background: theme.secondary,
          foreground: theme.secondaryForeground,
        ),
        _ColorPair(
          keyValue: 'source-foundation-example:color-muted',
          label: 'muted',
          background: theme.muted,
          foreground: theme.mutedForeground,
        ),
        _ColorPair(
          keyValue: 'source-foundation-example:color-accent',
          label: 'accent',
          background: theme.accent,
          foreground: theme.accentForeground,
        ),
        _ColorPair(
          keyValue: 'source-foundation-example:color-destructive',
          label: 'destructive',
          background: theme.destructive,
          foreground: theme.destructiveForeground,
        ),
      ],
    );
  }
}

const String _colorCode =
    '// Every semantic colour is issued in a background/foreground pair.\n'
    'Container(\n'
    '  color: theme.primary,\n'
    "  child: StyledText('primary', TextStyles.small, color: theme.primaryForeground),\n"
    ')';

/* ── Type Ramp ───────────────────────────────────────────────────────────── */

class _TypeHost extends StatelessWidget {
  const _TypeHost();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Column(
      key: const ValueKey<String>('source-foundation-example:type'),
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // .type-display and .type-h1 carry no intrinsic size of their own —
        // both are clamp()ed against the viewport, so Fluid supplies the
        // fontSize every other rung gets from its own TextStyleToken.
        StyledText(
          'TextStyles.display',
          TextStyles.display,
          color: theme.foreground,
          fontSize: Fluid.display(context),
        ),
        SizedBox(height: space(2)),
        StyledText(
          'TextStyles.h1',
          TextStyles.h1,
          color: theme.foreground,
          fontSize: Fluid.h1(context),
        ),
        SizedBox(height: space(2)),
        for (final (String, TextStyleToken) pair in <(String, TextStyleToken)>[
          ('h2', TextStyles.h2),
          ('lead', TextStyles.lead),
          ('body', TextStyles.body),
          ('small', TextStyles.small),
          ('code', TextStyles.code),
        ]) ...<Widget>[
          StyledText('TextStyles.${pair.$1}', pair.$2, color: theme.foreground),
          SizedBox(height: space(2)),
        ],
      ],
    );
  }
}

const String _typeCode =
    "StyledText('TextStyles.display', TextStyles.display, color: theme.foreground)\n"
    "StyledText('TextStyles.h1', TextStyles.h1, color: theme.foreground)\n"
    "StyledText('TextStyles.body', TextStyles.body, color: theme.foreground)";

/* ── Spacing Rhythm ──────────────────────────────────────────────────────── */

class _SpacingHost extends StatelessWidget {
  const _SpacingHost();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return SizedBox(
      key: const ValueKey<String>('source-foundation-example:spacing'),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            for (final int n in <int>[1, 2, 4, 8, 16, 32]) ...<Widget>[
              _Captioned(
                caption: 'space($n)',
                child: Container(
                  width: space(n),
                  height: space(n),
                  decoration: BoxDecoration(
                    color: theme.primary,
                    borderRadius: BorderRadius.circular(Radii.xs),
                  ),
                ),
              ),
              SizedBox(width: space(3)),
            ],
          ],
        ),
      ),
    );
  }
}

const String _spacingCode =
    'SizedBox(width: space(8), height: space(8)) // 32px';

/* ── Motion ──────────────────────────────────────────────────────────────── */

class _MotionChip extends StatefulWidget {
  const _MotionChip({
    required this.keyValue,
    required this.caption,
    required this.duration,
    required this.curve,
  });

  final String keyValue;
  final String caption;
  final Duration duration;
  final Curve curve;

  @override
  State<_MotionChip> createState() => _MotionChipState();
}

class _MotionChipState extends State<_MotionChip> {
  bool _out = false;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final Duration duration = effectiveMotionDuration(context, widget.duration);
    return _Captioned(
      caption: widget.caption,
      child: Press(
        onTap: () => setState(() => _out = !_out),
        child: SizedBox(
          key: ValueKey<String>(widget.keyValue),
          width: space(20),
          height: space(9),
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(end: _out ? 1 : 0),
            duration: duration,
            curve: widget.curve,
            builder: (BuildContext context, double t, Widget? child) =>
                Container(
                  alignment: Alignment.centerLeft + Alignment(t * 2, 0),
                  decoration: BoxDecoration(
                    color: theme.secondary,
                    borderRadius: BorderRadius.circular(Radii.full),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(space(1)),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: theme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: SizedBox(width: space(6), height: space(6)),
                    ),
                  ),
                ),
          ),
        ),
      ),
    );
  }
}

class _MotionHost extends StatelessWidget {
  const _MotionHost();

  @override
  Widget build(BuildContext context) => _Row(
    children: <Widget>[
      _MotionChip(
        keyValue: 'source-foundation-example:motion-tick',
        caption: 'tick + out',
        duration: MotionDurations.tick,
        curve: MotionCurves.enter,
      ),
      _MotionChip(
        keyValue: 'source-foundation-example:motion-base',
        caption: 'base + spring',
        duration: MotionDurations.normal,
        curve: MotionCurves.emphasized,
      ),
      _MotionChip(
        keyValue: 'source-foundation-example:motion-slow',
        caption: 'slow + settle',
        duration: MotionDurations.slow,
        curve: MotionCurves.settle,
      ),
    ],
  );
}

const String _motionCode =
    'TweenAnimationBuilder<double>(\n'
    '  tween: Tween(end: pressed ? 1 : 0),\n'
    '  duration: MotionDurations.normal,\n'
    '  curve: MotionCurves.emphasized,\n'
    '  builder: (context, t, child) => Transform.translate(\n'
    '    offset: Offset(t * travel, 0),\n'
    '    child: child,\n'
    '  ),\n'
    ')';

/* ── Shadow Elevation ────────────────────────────────────────────────────── */

class _ShadowHost extends StatelessWidget {
  const _ShadowHost();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return _Row(
      children: <Widget>[
        for (final (String, ShadowStyle) pair in <(String, ShadowStyle)>[
          ('e1', Shadows.sm),
          ('e2', Shadows.md),
          ('e3', Shadows.lg),
          ('e4', Shadows.xl),
        ])
          _Captioned(
            caption: 'Shadows.${pair.$1}',
            child: Container(
              key: ValueKey<String>(
                'source-foundation-example:shadow-${pair.$1}',
              ),
              width: space(18),
              height: space(18),
              decoration: BoxDecoration(
                color: theme.card,
                borderRadius: BorderRadius.circular(Radii.lg),
                boxShadow: pair.$2.outerShadows(theme),
              ),
            ),
          ),
      ],
    );
  }
}

const String _shadowCode =
    'Container(\n'
    '  decoration: BoxDecoration(\n'
    '    color: theme.card,\n'
    '    boxShadow: Shadows.md.outerShadows(theme),\n'
    '  ),\n'
    ')';

/* ── Disclosure content ─────────────────────────────────────────────────── */

const String _usageCode = '''
import 'package:elattar_design_system/elattar_design_system.dart';

void main() => runApp(
  ThemeScope(
    controller: ThemeController(mode: ColorMode.dark),
    child: Builder(
      builder: (context) {
        final theme = ThemeScope.of(context);
        return StyledText('Hello', TextStyles.h1, color: theme.foreground);
      },
    ),
  ),
);''';

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) =>
      const DocsApiTable(title: 'Foundation classes', facts: _apiFacts);
}

const List<DocsApiFact> _apiFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'space',
    type: 'double Function(num n)',
    description:
        'Tailwind\'s spacing unit: space(n) = n × 4 logical pixels. The one '
        'function almost every geometry value under lib/ and example/lib/ '
        'is expressed through.',
  ),
  DocsApiFact(
    name: 'LayoutWidths / Radii / Containers / Breakpoints / Blurs',
    type: 'static double constants',
    description:
        'The rest of the geometry ladders: measures the shell is built '
        'on, corner radii, Tailwind\'s stock container and breakpoint '
        'scales, and the two blur radii the reference actually reaches '
        'for.',
  ),
  DocsApiFact(
    name: 'ThemeScope / ThemeTokens / ThemeController / ColorMode',
    type: 'InheritedNotifier, data class, ChangeNotifier, enum',
    description:
        'The theme system: ThemeScope.of(context) reads the live '
        'ThemeTokens; ThemeController holds the mode (dark/light) and '
        'notifies on change. ThemeTokens carries roughly thirty semantic '
        'colour fields, always in background/foreground pairs.',
  ),
  DocsApiFact(
    name: 'Palette / OklabColor',
    type: 'static Color constants, and a mixing/conversion toolkit',
    description:
        'The handful of colours that do NOT flip with the theme '
        '(action, value, success/warning/info/destructive inks), plus '
        'OklabColor.mix and the OKLab/OKLCH conversion the theme layer '
        'mixes through for perceptually-even colour math.',
  ),
  DocsApiFact(
    name: 'TextStyles / ComponentTextStyles / TextStyleToken / StyledText',
    type: 'static TextStyleToken constants, and the widget that paints them',
    description:
        'The full type scale (display through the numeric rungs) plus '
        'every component\'s own bespoke spec (buttonLabel, cardTitle, '
        'and dozens more). StyledText(text, spec, {color}) is how every one '
        'of them is actually painted — never a bare Text with a manual '
        'TextStyle.',
  ),
  DocsApiFact(
    name:
        'MotionDurations / MotionCurves / MotionTransforms / effectiveMotionDuration',
    type: 'static Duration/Curve/double constants, and a helper function',
    description:
        'Every named duration and cubic-bezier easing in the system, '
        'plus the `:active` scale amounts (MotionTransforms). '
        'effectiveMotionDuration(context, duration) is the one call every '
        'animated widget in the package routes its durations through, '
        'so MediaQuery.disableAnimations stills the whole system at '
        'once.',
  ),
  DocsApiFact(
    name: 'Shadows / ShadowStyle / ShadowLayer',
    type: 'static ShadowStyle constants, and their layer model',
    description:
        'The elevation ladder (e1-e4) and the MACHINE-surface family '
        '(btn and its kin). Every layer stores a Color Function'
        '(ThemeTokens) rather than a literal, so the whole ladder '
        'repaints correctly under a theme flip with no caller-side '
        'branching.',
  ),
  DocsApiFact(
    name: 'SurfaceOpacity',
    type: 'static double constants',
    description:
        'The two glass-panel opacities (glassPanel, navigationGlass) '
        'the Glass effect and the sticky docs header both read.',
  ),
  DocsApiFact(
    name: 'DateFormat',
    type: 'static formatting helpers',
    description:
        'Locale-aware date and time formatting, used by the Calendar '
        'and any surface that renders a timestamp.',
  ),
];

class _StatesContent extends StatelessWidget {
  const _StatesContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'The foundation itself has exactly one piece of runtime state: '
            'ThemeController.mode (dark or light), a ChangeNotifier '
            'every ThemeScope.of(context) call subscribes to. Everything '
            'else on this page — every colour, every type spec, every '
            'duration — is a compile-time constant or a pure function of '
            'that one mode.',
        'MediaQuery.disableAnimations is the second real variable, read '
            'through effectiveMotionDuration by every animated consumer of '
            'this foundation (not by the foundation\'s own files, which '
            'declare no animation of their own) — see the Motion section '
            'above and this system\'s dedicated motion primitives, Press '
            'Motion and Keyframes.',
      ]);
}

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Every ThemeTokens colour pair is issued together specifically '
            'so a caller cannot accidentally pick a foreground that '
            'fails contrast against its own background — Button\'s '
            'destructive variant (a 10% tint rather than a solid fill) '
            'is the system\'s own worked example of choosing the pairing '
            'that clears AA over one that does not.',
        'StyledText routes every string through the same text-layout '
            'machinery (LineBox, text_layout.dart), so font scaling, '
            'selection and semantics behave identically everywhere a '
            'caller reaches for a token instead of a bare Text.',
        'The foundation carries no ARIA-equivalent contrast checker or '
            'runtime assertion of its own: the pairing discipline is a '
            'convention this page and the source\'s own comments state, '
            'not a guard the type system enforces.',
      ]);
}

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(
    BuildContext context,
  ) => _bullets(ThemeScope.of(context), <String>[
    'The foundation itself takes no focus and handles no key: it is '
        'tokens and pure functions, not an interactive widget. '
        'ThemeScope is an InheritedNotifier with no Focus of its own; '
        'every keyboard story on this kit belongs to a component '
        'built on top of it, never to lib/src/design_system/foundation/ directly.',
  ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Breakpoints (sm/md/lg/xl) and Containers are exactly the '
            'foundation\'s own responsive vocabulary: every breakpoint '
            'check anywhere else in this package (the docs shell\'s own '
            'rail-vs-sheet switch, a dialog\'s width cap) reads one of '
            'these two ladders rather than a literal pixel comparison.',
        'Fluid (theme_scope.dart) is the type scale\'s own responsive '
            'half: TextStyles.displaySize(vw) and h1Size(vw) clamp a '
            'viewport-relative size between a floor and a ceiling, the '
            'one place in the foundation where a token is a function of '
            'width rather than a constant.',
        'None of this page\'s own six specimen sections branch on '
            'width themselves — every one is sized off space(...) so it '
            'reflows with whatever column the docs shell gives it, the '
            'same as every other kit page.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      _bullets(ThemeScope.of(context), <String>[
        'This page\'s Dependencies disclosure runs the other way from '
            'every other page\'s: source-foundation depends on nothing '
            '— registryDependencies is empty — so what belongs here is '
            'who depends on IT.',
        'registry/generated/latest/registry.json lists 93 registry '
            'items whose own registryDependencies names '
            '"source-foundation" — components, effects, and every other '
            'motion primitive in this rollout among them. A full list '
            'would be most of the catalog; a representative sample '
            'follows instead.',
      ]),
      SizedBox(height: space(2)),
      DocsLinkRow(
        links: <DocsLink>[
          DocsLink(label: 'Button', route: '/components/button'),
          DocsLink(label: 'Badge', route: '/components/badge'),
          DocsLink(label: 'Card', route: '/components/card'),
          DocsLink(label: 'Avatar', route: '/components/avatar'),
          DocsLink(label: 'Dialog', route: '/components/dialog'),
          DocsLink(label: 'Chart', route: '/components/chart'),
          DocsLink(label: 'Press Motion', route: '/components/press'),
          DocsLink(label: 'Keyframes', route: '/components/keyframes'),
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
        'This IS the theming system, so this disclosure states the '
            'mechanism rather than describing how something else reads '
            'it. ThemeTokens is one immutable value per mode; '
            'ThemeController swaps the whole value on '
            'setMode(ColorMode.light/dark) and notifies every '
            'listening ThemeScope.of(context) in one frame.',
        'The two theme blocks are hand-authored siblings, not one '
            'block with computed overrides: every field on this page\'s '
            'Semantic Color specimen is a real, separately-chosen colour '
            'in each mode, not a formula applied to a single source '
            'colour.',
        'Palette is the deliberate exception: action, value and the '
            'four status inks (success/warning/info/destructive-adjacent) '
            'stay fixed across both themes on purpose — see the Foil '
            'Value page\'s own Theming section for the clearest worked '
            'example of why.',
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
