/// Public documentation page for the `surface` effect.
///
/// **Not a component.** [Surface] (`lib/src/components/ui/surface.dart`)
/// has no variant, no size, no enum of its own: one `StatelessWidget` that
/// paints one [ShadowStyle] — outer drop shadows AND inset highlight/shade
/// layers — around and inside a single child, in CSS's own paint order:
/// fill, inset shadows, border, content. Flutter's `BoxDecoration` can do the
/// first and the third; the inset layers are what this file exists for, and
/// they are the entire reason an outline button reads as something with a
/// socket to press into.
///
/// **House shape, effect edition.** Per
/// `new-page-brief.md`'s "Effects, motion primitives and the foundation
/// item": Preview, Installation, Usage, then one `EffectSection` per facet
/// the effect actually has, then the same eight disclosures every component
/// page carries. Every `EffectSection` here stages a real host — a pill
/// shaped and sized like `ButtonVariant.outline` — beside the same host
/// with the effect removed or a variable changed, so the difference is the
/// thing on screen rather than a claim in prose.
///
/// **Real use, not invented.** `grep -rln "Surface\b" lib/src/components/ui/`
/// returns 25 files at the time this page was written; `button.dart` is the
/// one this page's specimens are modelled on (`_surface`'s `secondary`,
/// `outline`, `ghost`, `destructive`, `link` arms all return
/// `Surface` directly). `effects/premium_surface.dart` and
/// `effects/action_feedback.dart` both compose it too, for the inset layers
/// under their own gradients — see the Glass and Premium Surface pages, which
/// depend on this one.
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

final ComponentDocSpec machineSurfaceDocSpec = ComponentDocSpec(
  name: 'surface',
  title: 'Surface',
  description: surfaceDoc.description,
  sections: <DocsPageSection>[
    EffectSection(
      id: 'preview',
      title: 'Preview',
      description:
          'A plain decorated box beside the same shape, fill and border '
          'wrapped in Surface with Shadows.control: the spec '
          'ButtonVariant.outline paints at rest. The inset top-rim of '
          'light and the outer drop shadow are what the plain box cannot '
          'show — Flutter\'s own BoxDecoration has no inset-shadow '
          'primitive.',
      host: const _PreviewHost(),
      code: _previewCode,
      label: 'Preview specimen view',
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'surface has a real registry manifest, '
          '`elattar add surface` installs '
          'lib/src/components/ui/surface.dart and resolves its one '
          'registryDependency, source-foundation, automatically. The '
          'Manual tab is for a project not using the CLI.',
      command: surfaceDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/effects/surface.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/ui/surface.dart's generated "
              '@ui/surface.dart payload into effects.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated surface source here when '
              'using manual mode.',
        ),
        DocsCodeFile(
          path: 'lib/effects/effects.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so Surface is reachable the '
              'same way the CLI path already makes it.',
          code: "export 'surface.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'The smallest correct import and construction: a rounded fill '
          'with an outer drop shadow, no inset layers and no border.',
      code: _usageCode,
    ),
    EffectSection(
      id: 'inset-shadow',
      title: 'Inset Shadow',
      description:
          'The one thing this file exists for. Shadows.md is an '
          'ambient-only spec — every layer is an outer BoxShadow, which a '
          'bare BoxDecoration could paint on its own. Shadows.control adds '
          'two inset layers on top of the same outer shadow: '
          '`inset 0 1px 0 var(--rim)` (the top highlight) and '
          '`inset 0 -2px 4px var(--ink-2)` (the bottom shade). Painting '
          'those is CustomPaint work — Canvas.drawDRRect under a clip — '
          'which is exactly what Surface adds over DecoratedBox.',
      host: const _InsetShadowHost(),
      code: _insetShadowCode,
      label: 'Inset shadow specimen view',
    ),
    EffectSection(
      id: 'pressed',
      title: 'Pressed',
      description:
          'The same outline pill, the same Surface, only the '
          'spec argument changes: Shadows.control at rest, Shadows.controlPressed '
          'once pressed. button.dart hard-cuts between the two on the '
          'exact frame the pointer goes down (mismatched layer counts '
          'block interpolation) — this effect has no transition logic of '
          'its own to do that with; it repaints whatever spec its caller '
          'hands it, every build.',
      host: const _PressedHost(),
      code: _pressedCode,
      label: 'Pressed specimen view',
    ),
    EffectSection(
      id: 'border',
      title: 'Border',
      description:
          'border is painted ABOVE the inset shadows and BELOW the '
          'content, and it is box-sizing: border-box — the child is '
          'padded by border!.dimensions so a 1px ring never eats into the '
          'label. fill with no border is what ButtonVariant.ghost and '
          '.link use; fill plus border is outline\'s own combination.',
      host: const _BorderHost(),
      code: _borderCode,
      label: 'Border specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every constructor parameter Surface declares, read '
          'off lib/src/components/ui/surface.dart.',
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
            value: surfaceDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'test/effects_test.dart, test/components_test.dart',
            description:
                'Surface has no dedicated machine_surface_test.dart: '
                'its inset-ring geometry is asserted in effects_test.dart, '
                'and every component that composes it is asserted where '
                'that component is.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/machine_surface_test.dart',
            description:
                'Covers this page: the article mounts, the full API table, '
                'and both themes at two viewport widths.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/surface/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class SurfaceDocPage extends StatelessWidget {
  const SurfaceDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: surfaceDoc.route,
    intro: DocsPageIntro(
      title: surfaceDoc.title,
      description: surfaceDoc.description,
    ),
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Components'),
      BreadcrumbEntry.page('Surface'),
    ],
    toc: machineSurfaceDocSpec.toc,
    previous: null,
    next: null,
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('surface-doc-article'),
      child: ComponentDocPage(spec: machineSurfaceDocSpec, header: false),
    ),
  );
}

/* ── Shared specimen shape ──────────────────────────────────────────────── */
// Sized and shaped like ButtonVariant.outline (button.dart's own indicator:
// height 40, BorderRadius.circular(Radii.full), theme.card fill,
// theme.input border, BorderWidths.hairline width) without importing Button
// itself: this page documents the raw effect, not the composed control.

double get _pillHeight => space(10);

class _CaptionedPair extends StatelessWidget {
  const _CaptionedPair({
    required this.leftCaption,
    required this.left,
    required this.rightCaption,
    required this.right,
  });

  final String leftCaption;
  final Widget left;
  final String rightCaption;
  final Widget right;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: space(2)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _Captioned(caption: leftCaption, child: left),
          SizedBox(width: space(8)),
          _Captioned(caption: rightCaption, child: right),
        ],
      ),
    ),
  );
}

class _Captioned extends StatelessWidget {
  const _Captioned({required this.caption, required this.child});

  final String caption;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        child,
        SizedBox(height: space(2)),
        StyledText(caption, TextStyles.section, color: theme.mutedForeground),
      ],
    );
  }
}

class _FlatPill extends StatelessWidget {
  const _FlatPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Container(
      key: const ValueKey<String>('surface-example:flat'),
      height: _pillHeight,
      padding: EdgeInsets.symmetric(horizontal: space(4)),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(Radii.full),
        border: Border.all(color: theme.input, width: BorderWidths.hairline),
      ),
      child: StyledText(label, TextStyles.small, color: theme.foreground),
    );
  }
}

class _SurfacePill extends StatelessWidget {
  const _SurfacePill({
    required this.label,
    required this.spec,
    this.bordered = true,
    this.keyValue,
  });

  final String label;
  final ShadowStyle spec;
  final bool bordered;
  final String? keyValue;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return SizedBox(
      key: keyValue == null ? null : ValueKey<String>(keyValue!),
      height: _pillHeight,
      child: Surface(
        spec: spec,
        radius: BorderRadius.circular(Radii.full),
        fill: theme.card,
        border: bordered
            ? Border.all(color: theme.input, width: BorderWidths.hairline)
            : null,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: space(4)),
          child: Center(
            widthFactor: 1,
            child: StyledText(label, TextStyles.small, color: theme.foreground),
          ),
        ),
      ),
    );
  }
}

/* ── Specimens ───────────────────────────────────────────────────────────── */

class _PreviewHost extends StatelessWidget {
  const _PreviewHost();

  @override
  Widget build(BuildContext context) => const _CaptionedPair(
    leftCaption: 'Plain BoxDecoration',
    left: _FlatPill(label: 'Outline'),
    rightCaption: 'Surface (Shadows.control)',
    right: _SurfacePill(
      label: 'Outline',
      spec: Shadows.control,
      keyValue: 'surface-example:preview',
    ),
  );
}

const String _previewCode =
    "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
    '// Without: a bare BoxDecoration.\n'
    'DecoratedBox(\n'
    '  decoration: BoxDecoration(\n'
    '    color: theme.card,\n'
    '    borderRadius: BorderRadius.circular(Radii.full),\n'
    '    border: Border.all(color: theme.input, width: BorderWidths.hairline),\n'
    '  ),\n'
    "  child: const Text('Outline'),\n"
    ')\n\n'
    '// With: Surface paints the same fill and border, plus the\n'
    "// inset layers Shadows.control declares — CSS's own paint order.\n"
    'Surface(\n'
    '  spec: Shadows.control,\n'
    '  radius: BorderRadius.circular(Radii.full),\n'
    '  fill: theme.card,\n'
    '  border: Border.all(color: theme.input, width: BorderWidths.hairline),\n'
    "  child: const Text('Outline'),\n"
    ')';

class _InsetShadowHost extends StatelessWidget {
  const _InsetShadowHost();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    Widget card(ShadowStyle spec, String key) => SizedBox(
      key: ValueKey<String>(key),
      width: space(24),
      height: space(24),
      child: Surface(
        spec: spec,
        radius: BorderRadius.circular(Radii.lg),
        fill: theme.card,
        child: const SizedBox.expand(),
      ),
    );
    return _CaptionedPair(
      leftCaption: 'Shadows.md (outer only)',
      left: card(Shadows.md, 'surface-example:outer-only'),
      rightCaption: 'Shadows.control (outer + inset)',
      right: card(Shadows.control, 'surface-example:inset'),
    );
  }
}

const String _insetShadowCode =
    '// Outer-only: a BoxDecoration could paint this alone.\n'
    'Surface(spec: Shadows.md, radius: ..., fill: theme.card, child: ...)\n\n'
    '// Outer + inset: the top-rim highlight and bottom-shade only\n'
    "// Surface's CustomPaint layer can add.\n"
    'Surface(spec: Shadows.control, radius: ..., fill: theme.card, child: ...)';

class _PressedHost extends StatelessWidget {
  const _PressedHost();

  @override
  Widget build(BuildContext context) => const _CaptionedPair(
    leftCaption: 'Rest — Shadows.control',
    left: _SurfacePill(
      label: 'Outline',
      spec: Shadows.control,
      keyValue: 'surface-example:rest',
    ),
    rightCaption: 'Pressed — Shadows.controlPressed',
    right: _SurfacePill(
      label: 'Outline',
      spec: Shadows.controlPressed,
      keyValue: 'surface-example:pressed',
    ),
  );
}

const String _pressedCode =
    '// Rest.\n'
    'Surface(spec: Shadows.control, ...)\n\n'
    '// Pressed: the caller swaps the spec argument, same widget.\n'
    'Surface(spec: Shadows.controlPressed, ...)';

class _BorderHost extends StatelessWidget {
  const _BorderHost();

  @override
  Widget build(BuildContext context) => const _CaptionedPair(
    leftCaption: 'fill, no border',
    left: _SurfacePill(
      label: 'Ghost',
      spec: Shadows.none,
      bordered: false,
      keyValue: 'surface-example:no-border',
    ),
    rightCaption: 'fill + border',
    right: _SurfacePill(
      label: 'Outline',
      spec: Shadows.control,
      keyValue: 'surface-example:with-border',
    ),
  );
}

const String _borderCode =
    '// No border: ButtonVariant.ghost and .link\'s own shape.\n'
    'Surface(spec: Shadows.none, fill: theme.card, border: null, ...)\n\n'
    "// With a border: box-sizing border-box, painted over the inset layers.\n"
    'Surface(\n'
    '  spec: Shadows.control,\n'
    '  fill: theme.card,\n'
    '  border: Border.all(color: theme.input, width: BorderWidths.hairline),\n'
    '  ...\n'
    ')';

/* ── Disclosure content ─────────────────────────────────────────────────── */

const String _usageCode = '''
import 'package:elattar_design_system/elattar_design_system.dart';

Surface(
  spec: Shadows.md,
  radius: BorderRadius.circular(Radii.lg),
  fill: theme.card,
  child: const Text('Card'),
)''';

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) =>
      const DocsApiTable(title: 'Surface', facts: _apiFacts);
}

const List<DocsApiFact> _apiFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'spec',
    type: 'ShadowStyle',
    description:
        'Required. The `--shadow-*` token to paint: its outer layers go '
        'into a BoxDecoration.boxShadow, its inset layers (spec.hasInset) '
        'go through a CustomPaint layer this widget mounts only when at '
        'least one is present.',
  ),
  DocsApiFact(
    name: 'radius',
    type: 'BorderRadius',
    description:
        'Required. The shape. Both the outer shadows, the inset clip, and '
        'the DecoratedBox fill follow it.',
  ),
  DocsApiFact(
    name: 'fill',
    type: 'Color?',
    description:
        "Optional. Defaults to null. The surface's own background-color, "
        'painted by the outer DecoratedBox, under everything else.',
  ),
  DocsApiFact(
    name: 'border',
    type: 'BoxBorder?',
    description:
        "Optional. Defaults to null. Painted above the inset shadows, "
        "below the content: box-sizing: border-box, so the child is "
        "padded by border!.dimensions to keep the border's own width out "
        'of its box.',
  ),
  DocsApiFact(
    name: 'child',
    type: 'Widget',
    description: 'Required. The content painted over every layer above it.',
  ),
];

class _StatesContent extends StatelessWidget {
  const _StatesContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Surface is a StatelessWidget: it carries no hover, '
            'press, focus, or theme state of its own — no States matrix in '
            'the sense a control has one.',
        'It is a pure paint function of the five constructor parameters '
            'above, re-evaluated on every build. Whatever "state" a '
            'reader sees — rest vs pressed, bordered vs not — is the '
            'caller passing a different spec, fill, or border each time, '
            'exactly as the Pressed and Border sections above do.',
        'The one thing that changes without a new build: theme. Each '
            'ShadowLayer.color is a Color Function(ThemeTokens), read '
            'live off ThemeScope.of(context) inside build() — see Theming '
            'below.',
      ]);
}

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Surface renders no Semantics node of its own: build() '
            'returns a DecoratedBox wrapping, at most, a Padding and a '
            'CustomPaint — none of which carry accessibility metadata. '
            'Whatever semantics child declares pass through untouched.',
        'No accessible name, no role, no state: those are the caller\'s '
            'job. Button wraps its own Semantics(button: true) around '
            'the Surface it paints, not the other way round.',
      ]);
}

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Takes no focus and handles no key: surface.dart declares '
            'no Focus, no FocusNode, no onKeyEvent, and no GestureDetector '
            'or MouseRegion. It is a paint-only widget; a caller that '
            'wants keyboard interaction wraps it in something that has one, '
            'the way Button\'s own Focus does.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'No breakpoint branching anywhere in surface.dart: '
            'BuildContext width is never read for a layout decision.',
        'spec, radius, fill, border and child are all the caller\'s own '
            'choices; Surface never resizes or repositions '
            'anything on its own. The CustomPaint layer that draws the '
            'inset rings reads only the RenderBox Size Flutter hands it at '
            'paint time, so the ring geometry scales with whatever box the '
            'caller gives it, at every viewport, with no special-casing.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      _bullets(ThemeScope.of(context), <String>[
        'File: lib/src/components/ui/surface.dart: one file, no '
            'companions.',
        'Flutter imports: package:flutter/foundation.dart '
            '(@visibleForTesting, listEquals), package:flutter/widgets.dart.',
        'Foundation imports: foundation/shadows.dart (ShadowStyle, '
            'ShadowLayer), foundation/theme.dart, theme_scope.dart '
            '(ThemeScope).',
        'registryDependencies, resolved automatically by `elattar add '
            'surface`: source-foundation — copied verbatim from '
            'registry/components/surface.json. No semanticDependencies.',
        '25 files under lib/src/components import Surface '
            'directly (measured by grep at the time this page was '
            'written), including button.dart\'s secondary, outline, '
            'ghost, destructive, and link variants.',
        'Two other effects compose it rather than paint their own inset '
            'layers: effects/premium_surface.dart (the premium button\'s '
            'surface) and effects/glass.dart (all three glass utilities).',
      ]),
      SizedBox(height: space(2)),
      DocsLinkRow(
        links: <DocsLink>[
          DocsLink(label: 'Button', route: '/components/button'),
          DocsLink(label: 'Glass', route: '/components/glass'),
          DocsLink(
            label: 'Premium Surface',
            route: '/components/premium_surface',
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
        'Surface itself reads exactly one theme value: '
            'ThemeScope.of(context), fetched once per build() and handed to '
            'spec.outerShadows(theme) and the inset painter\'s layers. It '
            'resolves no colour on its own — fill and border are supplied '
            'entirely by the caller.',
        'What IS theme-sensitive is every layer inside spec: '
            'ShadowLayer.color is typed Color Function(ThemeTokens), not '
            'Color — shadows.dart\'s own library doc: "Light mode gets '
            'weaker, cooler, tighter ink and an inverted rim — same '
            'shapes, same names, same components." A spec built once '
            '(Shadows.control is a static const) repaints correctly in both '
            'themes because every colour inside it is still a function, '
            'resolved fresh on the next build after a theme flip.',
        'No caching: nothing here memoises a resolved Color across '
            'builds, so a live ThemeController flip repaints every '
            'Surface on the next frame with no special handling.',
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
