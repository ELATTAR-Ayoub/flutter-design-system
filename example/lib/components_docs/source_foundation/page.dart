/// Public documentation page for the `source-foundation` foundation.
///
/// **The only foundation-type registry item, and the root of the graph.**
/// Every other page in this rollout lists `source-foundation` in its
/// Dependencies disclosure; this page is the one place that relationship
/// runs backward. Its own `registryDependencies` is empty — nothing in the
/// package sits beneath it.
///
/// **Why `EffectSection`, not `ShowcaseSection`, and why there is no single
/// specimen.** `lib/src/foundation/` is eleven files of tokens and
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
import 'package:flutter/widgets.dart';

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
          'ElType.h4 and ElType.small for type, el(...) for every '
          'measure in it, and ElShadows.e2 for its elevation. Nothing on '
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
          path: 'lib/foundation/foundation.dart',
          title: '1. Copy the source',
          description:
              'Copy every file under lib/src/foundation/, plus '
              'lib/src/text_layout.dart and lib/src/theme_scope.dart, '
              "into your project's own foundation folder.",
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
          'Wrap the app once in ElTheme; every token below reads off '
          'ElTheme.of(context) or a bare static from there on.',
      code: _usageCode,
    ),
    EffectSection(
      id: 'color',
      title: 'Semantic Color',
      description:
          'A representative seven of ElThemeData\'s roughly thirty '
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
          'Seven of ElType\'s roughly thirty specs, display down to '
          'code — each an ElTypeSpec carrying its own family, size, '
          'weight and leading, applied through ElText rather than a '
          'bare TextStyle.',
      host: const _TypeHost(),
      code: _typeCode,
      label: 'Type ramp specimen view',
    ),
    EffectSection(
      id: 'spacing',
      title: 'Spacing Rhythm',
      description:
          'el(n) = n × 4 logical pixels — Tailwind\'s own spacing unit, '
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
          'Three ElDurations/ElCurves pairings a caller reaches for '
          'constantly: ElDurations.tick with ElCurves.out for a hover, '
          'ElDurations.base with ElCurves.spring for a press response, '
          'ElDurations.slow with ElCurves.settle for a panel opening. '
          'Tap any chip to replay it.',
      host: const _MotionHost(),
      code: _motionCode,
      label: 'Motion specimen view',
    ),
    EffectSection(
      id: 'shadow',
      title: 'Shadow Elevation',
      description:
          'ElShadows.e1 through e4 — the ambient depth ladder, the '
          'other shadow family being the MACHINE surfaces '
          '(ElShadows.btn and its kin) the Machine Surface page '
          'documents on its own. Every layer stores a Color '
          'Function(ElThemeData), never a literal Color, which is why '
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
          'A representative inventory of what lib/src/foundation/ '
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
                'test/colors_test.dart, test/typography_test.dart, '
                'test/motion_test.dart, test/shadows_test.dart, '
                'test/theme_scope_test.dart',
            description:
                'Every foundation file has its own dedicated suite; '
                'there is no single foundation_test.dart because there '
                'is no single foundation file.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value:
                'example/test/components_docs/source_foundation_test.dart',
            description:
                'Covers this page: the article mounts, the API table, '
                'every specimen this page claims to show, and both '
                'themes — never with pumpAndSettle.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value:
                'example/lib/components_docs/source_foundation/page.dart',
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
      eyebrow: 'COMPONENTS / FOUNDATIONS',
      title: sourceFoundationDoc.title,
      description: sourceFoundationDoc.description,
    ),
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Components'),
      ElBreadcrumbEntry.page('Source Foundation'),
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
      SizedBox(height: el(2)),
      ElText(caption, ElType.section, color: ElTheme.of(context).mutedForeground),
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
      padding: EdgeInsets.symmetric(horizontal: el(2)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          for (int i = 0; i < children.length; i++) ...<Widget>[
            if (i > 0) SizedBox(width: el(6)),
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
    final ElThemeData theme = ElTheme.of(context);
    return Container(
      key: const ValueKey<String>('source-foundation-example:preview'),
      width: el(72),
      padding: EdgeInsets.all(el(5)),
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(ElRadii.xl),
        boxShadow: ElShadows.e2.outerShadows(theme),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ElText('Every layer, at once', ElType.h4, color: theme.cardForeground),
          SizedBox(height: el(2)),
          ElText(
            'theme.card, ElType.h4, el(5) padding, ElShadows.e2 — four '
            'foundation layers, one card.',
            ElType.small,
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
    '  padding: EdgeInsets.all(el(5)),\n'
    '  decoration: BoxDecoration(\n'
    '    color: theme.card,\n'
    '    borderRadius: BorderRadius.circular(ElRadii.xl),\n'
    '    boxShadow: ElShadows.e2.outerShadows(theme),\n'
    '  ),\n'
    "  child: ElText('Every layer, at once', ElType.h4, color: theme.cardForeground),\n"
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
    final ElThemeData theme = ElTheme.of(context);
    return Container(
      key: ValueKey<String>(keyValue),
      width: el(24),
      height: el(16),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(ElRadii.lg),
        border: Border.all(color: theme.border, width: ElWidths.hairline),
      ),
      child: ElText(label, ElType.small, color: foreground),
    );
  }
}

class _ColorHost extends StatelessWidget {
  const _ColorHost();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
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
    "  child: ElText('primary', ElType.small, color: theme.primaryForeground),\n"
    ')';

/* ── Type Ramp ───────────────────────────────────────────────────────────── */

class _TypeHost extends StatelessWidget {
  const _TypeHost();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      key: const ValueKey<String>('source-foundation-example:type'),
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // .type-display and .type-h1 carry no intrinsic size of their own —
        // both are clamp()ed against the viewport, so ElFluid supplies the
        // fontSize every other rung gets from its own ElTypeSpec.
        ElText(
          'ElType.display',
          ElType.display,
          color: theme.foreground,
          fontSize: ElFluid.display(context),
        ),
        SizedBox(height: el(2)),
        ElText(
          'ElType.h1',
          ElType.h1,
          color: theme.foreground,
          fontSize: ElFluid.h1(context),
        ),
        SizedBox(height: el(2)),
        for (final (String, ElTypeSpec) pair in <(String, ElTypeSpec)>[
          ('h2', ElType.h2),
          ('lead', ElType.lead),
          ('body', ElType.body),
          ('small', ElType.small),
          ('code', ElType.code),
        ]) ...<Widget>[
          ElText('ElType.${pair.$1}', pair.$2, color: theme.foreground),
          SizedBox(height: el(2)),
        ],
      ],
    );
  }
}

const String _typeCode =
    "ElText('ElType.display', ElType.display, color: theme.foreground)\n"
    "ElText('ElType.h1', ElType.h1, color: theme.foreground)\n"
    "ElText('ElType.body', ElType.body, color: theme.foreground)";

/* ── Spacing Rhythm ──────────────────────────────────────────────────────── */

class _SpacingHost extends StatelessWidget {
  const _SpacingHost();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
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
                caption: 'el($n)',
                child: Container(
                  width: el(n),
                  height: el(n),
                  decoration: BoxDecoration(
                    color: theme.primary,
                    borderRadius: BorderRadius.circular(ElRadii.xs),
                  ),
                ),
              ),
              SizedBox(width: el(3)),
            ],
          ],
        ),
      ),
    );
  }
}

const String _spacingCode = 'SizedBox(width: el(8), height: el(8)) // 32px';

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
    final ElThemeData theme = ElTheme.of(context);
    final Duration duration = elAnimationDuration(context, widget.duration);
    return _Captioned(
      caption: widget.caption,
      child: ElPress(
        onTap: () => setState(() => _out = !_out),
        child: SizedBox(
          key: ValueKey<String>(widget.keyValue),
          width: el(20),
          height: el(9),
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(end: _out ? 1 : 0),
            duration: duration,
            curve: widget.curve,
            builder: (BuildContext context, double t, Widget? child) =>
                Container(
                  alignment: Alignment.centerLeft + Alignment(t * 2, 0),
                  decoration: BoxDecoration(
                    color: theme.secondary,
                    borderRadius: BorderRadius.circular(ElRadii.pill),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(el(1)),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: theme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: SizedBox(width: el(6), height: el(6)),
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
        duration: ElDurations.tick,
        curve: ElCurves.out,
      ),
      _MotionChip(
        keyValue: 'source-foundation-example:motion-base',
        caption: 'base + spring',
        duration: ElDurations.base,
        curve: ElCurves.spring,
      ),
      _MotionChip(
        keyValue: 'source-foundation-example:motion-slow',
        caption: 'slow + settle',
        duration: ElDurations.slow,
        curve: ElCurves.settle,
      ),
    ],
  );
}

const String _motionCode =
    'TweenAnimationBuilder<double>(\n'
    '  tween: Tween(end: pressed ? 1 : 0),\n'
    '  duration: ElDurations.base,\n'
    '  curve: ElCurves.spring,\n'
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
    final ElThemeData theme = ElTheme.of(context);
    return _Row(
      children: <Widget>[
        for (final (String, ElShadowSpec) pair in <(String, ElShadowSpec)>[
          ('e1', ElShadows.e1),
          ('e2', ElShadows.e2),
          ('e3', ElShadows.e3),
          ('e4', ElShadows.e4),
        ])
          _Captioned(
            caption: 'ElShadows.${pair.$1}',
            child: Container(
              key: ValueKey<String>('source-foundation-example:shadow-${pair.$1}'),
              width: el(18),
              height: el(18),
              decoration: BoxDecoration(
                color: theme.card,
                borderRadius: BorderRadius.circular(ElRadii.lg),
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
    '    boxShadow: ElShadows.e2.outerShadows(theme),\n'
    '  ),\n'
    ')';

/* ── Disclosure content ─────────────────────────────────────────────────── */

const String _usageCode = '''
import 'package:elattar_design_system/elattar_design_system.dart';

void main() => runApp(
  ElTheme(
    controller: ElThemeController(mode: ElThemeMode.dark),
    child: Builder(
      builder: (context) {
        final theme = ElTheme.of(context);
        return ElText('Hello', ElType.h1, color: theme.foreground);
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
    name: 'el',
    type: 'double Function(num n)',
    description:
        'Tailwind\'s spacing unit: el(n) = n × 4 logical pixels. The one '
        'function almost every geometry value under lib/ and example/lib/ '
        'is expressed through.',
  ),
  DocsApiFact(
    name: 'ElWidths / ElRadii / ElContainers / ElBreakpoints / ElBlurs',
    type: 'static double constants',
    description:
        'The rest of the geometry ladders: measures the shell is built '
        'on, corner radii, Tailwind\'s stock container and breakpoint '
        'scales, and the two blur radii the reference actually reaches '
        'for.',
  ),
  DocsApiFact(
    name: 'ElTheme / ElThemeData / ElThemeController / ElThemeMode',
    type: 'InheritedNotifier, data class, ChangeNotifier, enum',
    description:
        'The theme system: ElTheme.of(context) reads the live '
        'ElThemeData; ElThemeController holds the mode (dark/light) and '
        'notifies on change. ElThemeData carries roughly thirty semantic '
        'colour fields, always in background/foreground pairs.',
  ),
  DocsApiFact(
    name: 'ElPalette / ElOklab',
    type: 'static Color constants, and a mixing/conversion toolkit',
    description:
        'The handful of colours that do NOT flip with the theme '
        '(action, value, success/warning/info/destructive inks), plus '
        'ElOklab.mix and the OKLab/OKLCH conversion the theme layer '
        'mixes through for perceptually-even colour math.',
  ),
  DocsApiFact(
    name: 'ElType / ElComponentType / ElTypeSpec / ElText',
    type: 'static ElTypeSpec constants, and the widget that paints them',
    description:
        'The full type scale (display through the numeric rungs) plus '
        'every component\'s own bespoke spec (buttonLabel, cardTitle, '
        'and dozens more). ElText(text, spec, {color}) is how every one '
        'of them is actually painted — never a bare Text with a manual '
        'TextStyle.',
  ),
  DocsApiFact(
    name: 'ElDurations / ElCurves / ElTransforms / elAnimationDuration',
    type: 'static Duration/Curve/double constants, and a helper function',
    description:
        'Every named duration and cubic-bezier easing in the system, '
        'plus the `:active` scale amounts (ElTransforms). '
        'elAnimationDuration(context, duration) is the one call every '
        'animated widget in the package routes its durations through, '
        'so MediaQuery.disableAnimations stills the whole system at '
        'once.',
  ),
  DocsApiFact(
    name: 'ElShadows / ElShadowSpec / ElShadowLayer',
    type: 'static ElShadowSpec constants, and their layer model',
    description:
        'The elevation ladder (e1-e4) and the MACHINE-surface family '
        '(btn and its kin). Every layer stores a Color Function'
        '(ElThemeData) rather than a literal, so the whole ladder '
        'repaints correctly under a theme flip with no caller-side '
        'branching.',
  ),
  DocsApiFact(
    name: 'ElSurfaceOpacity',
    type: 'static double constants',
    description:
        'The two glass-panel opacities (glassPanel, navigationGlass) '
        'the Glass effect and the sticky docs header both read.',
  ),
  DocsApiFact(
    name: 'ElDateFormat',
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
      _bullets(ElTheme.of(context), <String>[
        'The foundation itself has exactly one piece of runtime state: '
            'ElThemeController.mode (dark or light), a ChangeNotifier '
            'every ElTheme.of(context) call subscribes to. Everything '
            'else on this page — every colour, every type spec, every '
            'duration — is a compile-time constant or a pure function of '
            'that one mode.',
        'MediaQuery.disableAnimations is the second real variable, read '
            'through elAnimationDuration by every animated consumer of '
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
      _bullets(ElTheme.of(context), <String>[
        'Every ElThemeData colour pair is issued together specifically '
            'so a caller cannot accidentally pick a foreground that '
            'fails contrast against its own background — ElButton\'s '
            'destructive variant (a 10% tint rather than a solid fill) '
            'is the system\'s own worked example of choosing the pairing '
            'that clears AA over one that does not.',
        'ElText routes every string through the same text-layout '
            'machinery (ElLineBox, text_layout.dart), so font scaling, '
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
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'The foundation itself takes no focus and handles no key: it is '
            'tokens and pure functions, not an interactive widget. '
            'ElTheme is an InheritedNotifier with no Focus of its own; '
            'every keyboard story on this kit belongs to a component '
            'built on top of it, never to lib/src/foundation/ directly.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'ElBreakpoints (sm/md/lg/xl) and ElContainers are exactly the '
            'foundation\'s own responsive vocabulary: every breakpoint '
            'check anywhere else in this package (the docs shell\'s own '
            'rail-vs-sheet switch, a dialog\'s width cap) reads one of '
            'these two ladders rather than a literal pixel comparison.',
        'ElFluid (theme_scope.dart) is the type scale\'s own responsive '
            'half: ElType.displaySize(vw) and h1Size(vw) clamp a '
            'viewport-relative size between a floor and a ceiling, the '
            'one place in the foundation where a token is a function of '
            'width rather than a constant.',
        'None of this page\'s own six specimen sections branch on '
            'width themselves — every one is sized off el(...) so it '
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
      _bullets(ElTheme.of(context), <String>[
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
      SizedBox(height: el(2)),
      DocsLinkRow(
        links: <DocsLink>[
          DocsLink(label: 'Button', route: '/components/button'),
          DocsLink(label: 'Badge', route: '/components/badge'),
          DocsLink(label: 'Card', route: '/components/card'),
          DocsLink(label: 'Avatar', route: '/components/avatar'),
          DocsLink(label: 'Dialog', route: '/components/dialog'),
          DocsLink(label: 'Chart', route: '/components/chart'),
          DocsLink(label: 'Press Motion', route: '/components/press_motion'),
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
      _bullets(ElTheme.of(context), <String>[
        'This IS the theming system, so this disclosure states the '
            'mechanism rather than describing how something else reads '
            'it. ElThemeData is one immutable value per mode; '
            'ElThemeController swaps the whole value on '
            'setMode(ElThemeMode.light/dark) and notifies every '
            'listening ElTheme.of(context) in one frame.',
        'The two theme blocks are hand-authored siblings, not one '
            'block with computed overrides: every field on this page\'s '
            'Semantic Color specimen is a real, separately-chosen colour '
            'in each mode, not a formula applied to a single source '
            'colour.',
        'ElPalette is the deliberate exception: action, value and the '
            'four status inks (success/warning/info/destructive-adjacent) '
            'stay fixed across both themes on purpose — see the Foil '
            'Value page\'s own Theming section for the clearest worked '
            'example of why.',
      ]);
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
