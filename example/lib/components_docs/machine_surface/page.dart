/// Public documentation page for the `machine-surface` effect.
///
/// **Not a component.** [ElMachineSurface] (`lib/src/effects/machine_surface.dart`)
/// has no variant, no size, no enum of its own: one `StatelessWidget` that
/// paints one [ElShadowSpec] — outer drop shadows AND inset highlight/shade
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
/// shaped and sized like `ElButtonVariant.outline` — beside the same host
/// with the effect removed or a variable changed, so the difference is the
/// thing on screen rather than a claim in prose.
///
/// **Real use, not invented.** `grep -rln "ElMachineSurface\b" lib/src/components/`
/// returns 25 files at the time this page was written; `button.dart` is the
/// one this page's specimens are modelled on (`_surface`'s `secondary`,
/// `outline`, `ghost`, `destructive`, `link` arms all return
/// `ElMachineSurface` directly). `effects/foil_value.dart` and
/// `effects/sheen_action.dart` both compose it too, for the inset layers
/// under their own gradients — see the Glass and Foil Value pages, which
/// depend on this one.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/component_doc_page.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import 'meta.dart';

final ComponentDocSpec machineSurfaceDocSpec = ComponentDocSpec(
  name: 'machine_surface',
  title: 'Machine Surface',
  description: machineSurfaceDoc.description,
  sections: <DocsPageSection>[
    EffectSection(
      id: 'preview',
      title: 'Preview',
      description:
          'A plain decorated box beside the same shape, fill and border '
          'wrapped in ElMachineSurface with ElShadows.btn: the spec '
          'ElButtonVariant.outline paints at rest. The inset top-rim of '
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
          'machine-surface has a real registry manifest, '
          '`elattar add machine-surface` installs '
          'lib/src/effects/machine_surface.dart and resolves its one '
          'registryDependency, source-foundation, automatically. The '
          'Manual tab is for a project not using the CLI.',
      command: machineSurfaceDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/effects/machine_surface.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/effects/machine_surface.dart's generated "
              '@effects/machine_surface.dart payload into effects.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated machine-surface source here when '
              'using manual mode.',
        ),
        DocsCodeFile(
          path: 'lib/effects/effects.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so ElMachineSurface is reachable the '
              'same way the CLI path already makes it.',
          code: "export 'machine_surface.dart';",
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
          'The one thing this file exists for. ElShadows.e2 is an '
          'ambient-only spec — every layer is an outer BoxShadow, which a '
          'bare BoxDecoration could paint on its own. ElShadows.btn adds '
          'two inset layers on top of the same outer shadow: '
          '`inset 0 1px 0 var(--rim)` (the top highlight) and '
          '`inset 0 -2px 4px var(--ink-2)` (the bottom shade). Painting '
          'those is CustomPaint work — Canvas.drawDRRect under a clip — '
          'which is exactly what ElMachineSurface adds over DecoratedBox.',
      host: const _InsetShadowHost(),
      code: _insetShadowCode,
      label: 'Inset shadow specimen view',
    ),
    EffectSection(
      id: 'pressed',
      title: 'Pressed',
      description:
          'The same outline pill, the same ElMachineSurface, only the '
          'spec argument changes: ElShadows.btn at rest, ElShadows.btnDown '
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
          'label. fill with no border is what ElButtonVariant.ghost and '
          '.link use; fill plus border is outline\'s own combination.',
      host: const _BorderHost(),
      code: _borderCode,
      label: 'Border specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every constructor parameter ElMachineSurface declares, read '
          'off lib/src/effects/machine_surface.dart.',
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
    DisclosureSection(id: 'keyboard', title: 'Keyboard', child: const _KeyboardContent()),
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
            value: machineSurfaceDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'test/effects_test.dart, test/components_test.dart',
            description:
                'ElMachineSurface has no dedicated machine_surface_test.dart: '
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
            value: 'example/lib/components_docs/machine_surface/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class MachineSurfaceDocPage extends StatelessWidget {
  const MachineSurfaceDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: machineSurfaceDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / EFFECTS',
      title: machineSurfaceDoc.title,
      description: machineSurfaceDoc.description,
    ),
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Components'),
      ElBreadcrumbEntry.page('Machine Surface'),
    ],
    toc: machineSurfaceDocSpec.toc,
    previous: null,
    next: null,
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('machine-surface-doc-article'),
      child: ComponentDocPage(spec: machineSurfaceDocSpec, header: false),
    ),
  );
}

/* ── Shared specimen shape ──────────────────────────────────────────────── */
// Sized and shaped like ElButtonVariant.outline (button.dart's own pill:
// height 40, BorderRadius.circular(ElRadii.pill), theme.card fill,
// theme.input border, ElWidths.hairline width) without importing ElButton
// itself: this page documents the raw effect, not the composed control.

double get _pillHeight => el(10);

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
      padding: EdgeInsets.symmetric(horizontal: el(2)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _Captioned(caption: leftCaption, child: left),
          SizedBox(width: el(8)),
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
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        child,
        SizedBox(height: el(2)),
        ElText(caption, ElType.section, color: theme.mutedForeground),
      ],
    );
  }
}

class _FlatPill extends StatelessWidget {
  const _FlatPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Container(
      key: const ValueKey<String>('machine-surface-example:flat'),
      height: _pillHeight,
      padding: EdgeInsets.symmetric(horizontal: el(4)),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(ElRadii.pill),
        border: Border.all(color: theme.input, width: ElWidths.hairline),
      ),
      child: ElText(label, ElType.small, color: theme.foreground),
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
  final ElShadowSpec spec;
  final bool bordered;
  final String? keyValue;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return SizedBox(
      key: keyValue == null ? null : ValueKey<String>(keyValue!),
      height: _pillHeight,
      child: ElMachineSurface(
        spec: spec,
        radius: BorderRadius.circular(ElRadii.pill),
        fill: theme.card,
        border: bordered
            ? Border.all(color: theme.input, width: ElWidths.hairline)
            : null,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: el(4)),
          child: Center(
            widthFactor: 1,
            child: ElText(label, ElType.small, color: theme.foreground),
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
    rightCaption: 'ElMachineSurface (ElShadows.btn)',
    right: _SurfacePill(
      label: 'Outline',
      spec: ElShadows.btn,
      keyValue: 'machine-surface-example:preview',
    ),
  );
}

const String _previewCode =
    "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
    '// Without: a bare BoxDecoration.\n'
    'DecoratedBox(\n'
    '  decoration: BoxDecoration(\n'
    '    color: theme.card,\n'
    '    borderRadius: BorderRadius.circular(ElRadii.pill),\n'
    '    border: Border.all(color: theme.input, width: ElWidths.hairline),\n'
    '  ),\n'
    "  child: const Text('Outline'),\n"
    ')\n\n'
    '// With: ElMachineSurface paints the same fill and border, plus the\n'
    "// inset layers ElShadows.btn declares — CSS's own paint order.\n"
    'ElMachineSurface(\n'
    '  spec: ElShadows.btn,\n'
    '  radius: BorderRadius.circular(ElRadii.pill),\n'
    '  fill: theme.card,\n'
    '  border: Border.all(color: theme.input, width: ElWidths.hairline),\n'
    "  child: const Text('Outline'),\n"
    ')';

class _InsetShadowHost extends StatelessWidget {
  const _InsetShadowHost();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    Widget card(ElShadowSpec spec, String key) => SizedBox(
      key: ValueKey<String>(key),
      width: el(24),
      height: el(24),
      child: ElMachineSurface(
        spec: spec,
        radius: BorderRadius.circular(ElRadii.lg),
        fill: theme.card,
        child: const SizedBox.expand(),
      ),
    );
    return _CaptionedPair(
      leftCaption: 'ElShadows.e2 (outer only)',
      left: card(ElShadows.e2, 'machine-surface-example:outer-only'),
      rightCaption: 'ElShadows.btn (outer + inset)',
      right: card(ElShadows.btn, 'machine-surface-example:inset'),
    );
  }
}

const String _insetShadowCode =
    '// Outer-only: a BoxDecoration could paint this alone.\n'
    'ElMachineSurface(spec: ElShadows.e2, radius: ..., fill: theme.card, child: ...)\n\n'
    '// Outer + inset: the top-rim highlight and bottom-shade only\n'
    "// ElMachineSurface's CustomPaint layer can add.\n"
    'ElMachineSurface(spec: ElShadows.btn, radius: ..., fill: theme.card, child: ...)';

class _PressedHost extends StatelessWidget {
  const _PressedHost();

  @override
  Widget build(BuildContext context) => const _CaptionedPair(
    leftCaption: 'Rest — ElShadows.btn',
    left: _SurfacePill(
      label: 'Outline',
      spec: ElShadows.btn,
      keyValue: 'machine-surface-example:rest',
    ),
    rightCaption: 'Pressed — ElShadows.btnDown',
    right: _SurfacePill(
      label: 'Outline',
      spec: ElShadows.btnDown,
      keyValue: 'machine-surface-example:pressed',
    ),
  );
}

const String _pressedCode =
    '// Rest.\n'
    'ElMachineSurface(spec: ElShadows.btn, ...)\n\n'
    '// Pressed: the caller swaps the spec argument, same widget.\n'
    'ElMachineSurface(spec: ElShadows.btnDown, ...)';

class _BorderHost extends StatelessWidget {
  const _BorderHost();

  @override
  Widget build(BuildContext context) => const _CaptionedPair(
    leftCaption: 'fill, no border',
    left: _SurfacePill(
      label: 'Ghost',
      spec: ElShadows.none,
      bordered: false,
      keyValue: 'machine-surface-example:no-border',
    ),
    rightCaption: 'fill + border',
    right: _SurfacePill(
      label: 'Outline',
      spec: ElShadows.btn,
      keyValue: 'machine-surface-example:with-border',
    ),
  );
}

const String _borderCode =
    '// No border: ElButtonVariant.ghost and .link\'s own shape.\n'
    'ElMachineSurface(spec: ElShadows.none, fill: theme.card, border: null, ...)\n\n'
    "// With a border: box-sizing border-box, painted over the inset layers.\n"
    'ElMachineSurface(\n'
    '  spec: ElShadows.btn,\n'
    '  fill: theme.card,\n'
    '  border: Border.all(color: theme.input, width: ElWidths.hairline),\n'
    '  ...\n'
    ')';

/* ── Disclosure content ─────────────────────────────────────────────────── */

const String _usageCode = '''
import 'package:elattar_design_system/elattar_design_system.dart';

ElMachineSurface(
  spec: ElShadows.e2,
  radius: BorderRadius.circular(ElRadii.lg),
  fill: theme.card,
  child: const Text('Card'),
)''';

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) =>
      const DocsApiTable(title: 'ElMachineSurface', facts: _apiFacts);
}

const List<DocsApiFact> _apiFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'spec',
    type: 'ElShadowSpec',
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
      _bullets(ElTheme.of(context), <String>[
        'ElMachineSurface is a StatelessWidget: it carries no hover, '
            'press, focus, or theme state of its own — no States matrix in '
            'the sense a control has one.',
        'It is a pure paint function of the five constructor parameters '
            'above, re-evaluated on every build. Whatever "state" a '
            'reader sees — rest vs pressed, bordered vs not — is the '
            'caller passing a different spec, fill, or border each time, '
            'exactly as the Pressed and Border sections above do.',
        'The one thing that changes without a new build: theme. Each '
            'ElShadowLayer.color is a Color Function(ElThemeData), read '
            'live off ElTheme.of(context) inside build() — see Theming '
            'below.',
      ]);
}

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'ElMachineSurface renders no Semantics node of its own: build() '
            'returns a DecoratedBox wrapping, at most, a Padding and a '
            'CustomPaint — none of which carry accessibility metadata. '
            'Whatever semantics child declares pass through untouched.',
        'No accessible name, no role, no state: those are the caller\'s '
            'job. ElButton wraps its own Semantics(button: true) around '
            'the ElMachineSurface it paints, not the other way round.',
      ]);
}

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'Takes no focus and handles no key: machine_surface.dart declares '
            'no Focus, no FocusNode, no onKeyEvent, and no GestureDetector '
            'or MouseRegion. It is a paint-only widget; a caller that '
            'wants keyboard interaction wraps it in something that has one, '
            'the way ElButton\'s own Focus does.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'No breakpoint branching anywhere in machine_surface.dart: '
            'BuildContext width is never read for a layout decision.',
        'spec, radius, fill, border and child are all the caller\'s own '
            'choices; ElMachineSurface never resizes or repositions '
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
      _bullets(ElTheme.of(context), <String>[
        'File: lib/src/effects/machine_surface.dart: one file, no '
            'companions.',
        'Flutter imports: package:flutter/foundation.dart '
            '(@visibleForTesting, listEquals), package:flutter/widgets.dart.',
        'Foundation imports: foundation/shadows.dart (ElShadowSpec, '
            'ElShadowLayer), foundation/theme.dart, theme_scope.dart '
            '(ElTheme).',
        'registryDependencies, resolved automatically by `elattar add '
            'machine-surface`: source-foundation — copied verbatim from '
            'registry/effects/machine-surface.json. No semanticDependencies.',
        '25 files under lib/src/components import ElMachineSurface '
            'directly (measured by grep at the time this page was '
            'written), including button.dart\'s secondary, outline, '
            'ghost, destructive, and link variants.',
        'Two other effects compose it rather than paint their own inset '
            'layers: effects/foil_value.dart (the premium button\'s '
            'surface) and effects/glass.dart (all three glass utilities).',
      ]),
      SizedBox(height: el(2)),
      DocsLinkRow(
        links: <DocsLink>[
          DocsLink(label: 'Button', route: '/components/button'),
          DocsLink(label: 'Glass', route: '/components/glass'),
          DocsLink(label: 'Foil Value', route: '/components/foil_value'),
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
        'ElMachineSurface itself reads exactly one theme value: '
            'ElTheme.of(context), fetched once per build() and handed to '
            'spec.outerShadows(theme) and the inset painter\'s layers. It '
            'resolves no colour on its own — fill and border are supplied '
            'entirely by the caller.',
        'What IS theme-sensitive is every layer inside spec: '
            'ElShadowLayer.color is typed Color Function(ElThemeData), not '
            'Color — shadows.dart\'s own library doc: "Light mode gets '
            'weaker, cooler, tighter ink and an inverted rim — same '
            'shapes, same names, same components." A spec built once '
            '(ElShadows.btn is a static const) repaints correctly in both '
            'themes because every colour inside it is still a function, '
            'resolved fresh on the next build after a theme flip.',
        'No caching: nothing here memoises a resolved Color across '
            'builds, so a live ElThemeController flip repaints every '
            'ElMachineSurface on the next frame with no special handling.',
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
