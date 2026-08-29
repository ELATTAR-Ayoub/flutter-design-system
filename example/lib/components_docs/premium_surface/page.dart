/// Public documentation page for the `premium-surface` effect.
///
/// **Not a component.** `lib/src/components/ui/premium_surface.dart` exports one
/// `StatefulWidget`, `PremiumSurface` — the premium Button's surface, and only
/// the premium Button's surface. No enum, no size rung: five constructor
/// parameters (`spec`, `radius`, `border`, `hovered`, `child`), the same
/// shape an `Surface` call takes plus one `hovered` flag, because
/// this is where the ramp, the foil and the glint splice in instead of a
/// flat fill.
///
/// **House shape, effect edition.** Preview, Installation, Usage, then one
/// `EffectSection` per facet the effect actually has (`hovered`, reduced
/// motion), then the same eight disclosures every component page carries.
/// Every `EffectSection` stages a host modelled on `ButtonVariant.premium`
/// beside the same shape and shadow spec painted flat, so the metal ramp is
/// the thing on screen rather than a claim in prose.
///
/// **`pumpAndSettle` never appears in this page's own test.** Both the foil
/// drift (11s) and the glint sweep (5.5s / 2.4s hovered) run on one shared
/// `Ticker` that starts in `initState` and never idles — `tester.pump()`
/// and `tester.pump(duration)` are the only advances used anywhere this
/// page's specimens mount, exactly as `button_test.dart` already does for
/// the Premium example.
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

final ComponentDocSpec foilValueDocSpec = ComponentDocSpec(
  name: 'premium_surface',
  title: 'Premium Surface',
  description: premiumSurfaceDoc.description,
  sections: <DocsPageSection>[
    EffectSection(
      id: 'preview',
      title: 'Preview',
      description:
          'The same Shadows.controlPremium spec painted two ways: flat, '
          'through Surface with fill: Palette.value, and '
          'through PremiumSurface, whose metal ramp, drifting foil and '
          'sweeping glint splice in where a flat fill would otherwise '
          'go. Both carry Palette.valueForeground text, the one '
          'foreground in the system that deliberately does not flip '
          'with the theme.',
      host: const _PreviewHost(),
      code: _previewCode,
      label: 'Preview specimen view',
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'premium-surface has a real registry manifest, `elattar add '
          'premium-surface` installs lib/src/components/ui/premium_surface.dart and '
          'resolves both registryDependencies — surface, '
          'source-foundation — automatically. The Manual tab is for a '
          'project not using the CLI.',
      command: premiumSurfaceDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/effects/premium_surface.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/ui/premium_surface.dart's generated "
              '@ui/premium_surface.dart payload into effects.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated premium-surface source here when using '
              'manual mode.',
        ),
        DocsCodeFile(
          path: 'lib/effects/effects.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so PremiumSurface is reachable the same '
              'way the CLI path already makes it.',
          code: "export 'premium_surface.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'The smallest correct import and construction: the shape and '
          'shadow spec an Surface call would take, wrapping the '
          'label the ramp shows through.',
      code: _usageCode,
    ),
    EffectSection(
      id: 'hovered',
      title: 'Hovered',
      description:
          'hovered pushes the metal: the foil\'s own opacity snaps from '
          '0.95 to 1 (no transition — the pseudo-element declares none, '
          'so a browser steps it, and so does this port), and the '
          'glint\'s period halves, MotionDurations.glint (5.5s) to '
          'MotionDurations.glintHover (2.4s). Both loops share ONE elapsed '
          'clock, so that halving does not resume smoothly — it '
          're-divides the same elapsed time by the new duration and can '
          'jump mid-sweep, measured and recorded as real reference '
          'behaviour (PremiumSurface.phaseAt\'s own doc, ruling B10b).',
      host: const _HoveredHost(),
      code: _hoveredCode,
      label: 'Hovered specimen view',
    ),
    EffectSection(
      id: 'reduced-motion',
      title: 'Reduced Motion',
      description:
          'Both loops re-read their period through effectiveMotionDuration '
          'on every build, so under MediaQuery.disableAnimations they '
          'get Duration.zero, stop, and paint frame 0: the glint '
          'invisible at opacity 0, the foil at the drift\'s opening '
          'offsets. Not a divergence from the reference — its own '
          'blanket prefers-reduced-motion rule collapses every '
          'animation on the page the same way.',
      host: const _ReducedMotionHost(),
      code: _reducedMotionCode,
      label: 'Reduced motion specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every constructor parameter PremiumSurface declares, read off '
          'lib/src/components/ui/premium_surface.dart.',
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
            value: premiumSurfaceDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'test/effects_test.dart',
            description:
                'The "PremiumSurface" group covers the seven derived ramp '
                'stops, the soft-light/screen blend modes, the drift and '
                'glint keyframe tracks, and phaseAt\'s re-division '
                'behaviour.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/foil_value_test.dart',
            description:
                'Covers this page: the article mounts, the full API '
                'table, and both themes at two viewport widths — never '
                'with pumpAndSettle.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/premium_surface/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class PremiumSurfaceDocPage extends StatelessWidget {
  const PremiumSurfaceDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: premiumSurfaceDoc.route,
    intro: DocsPageIntro(
      title: premiumSurfaceDoc.title,
      description: premiumSurfaceDoc.description,
    ),
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Components'),
      BreadcrumbEntry.page('Premium Surface'),
    ],
    toc: foilValueDocSpec.toc,
    previous: null,
    next: null,
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('premium-surface-doc-article'),
      child: ComponentDocPage(spec: foilValueDocSpec, header: false),
    ),
  );
}

/* ── Shared specimen shape ──────────────────────────────────────────────── */
// Sized and shaped like ButtonVariant.premium's own pill (height 40,
// BorderRadius.circular(Radii.full), a transparent border costing a
// pixel of inner width) without importing Button itself: this page
// documents the raw effect, not the composed control.

double get _pillHeight => space(10);

BoxBorder get _transparentBorder =>
    Border.all(color: transparent, width: BorderWidths.hairline);

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

class _ValueLabel extends StatelessWidget {
  const _ValueLabel();

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(horizontal: space(4)),
    child: Center(
      widthFactor: 1,
      child: StyledText(
        'Upgrade to Pro',
        TextStyles.small,
        color: Palette.valueForeground,
      ),
    ),
  );
}

class _FlatValuePill extends StatelessWidget {
  const _FlatValuePill({this.keyValue});

  final String? keyValue;

  @override
  Widget build(BuildContext context) => SizedBox(
    key: keyValue == null ? null : ValueKey<String>(keyValue!),
    height: _pillHeight,
    child: Surface(
      spec: Shadows.controlPremium,
      radius: BorderRadius.circular(Radii.full),
      fill: Palette.value,
      border: _transparentBorder,
      child: const _ValueLabel(),
    ),
  );
}

class _FoilPill extends StatelessWidget {
  const _FoilPill({this.hovered = false, this.keyValue});

  final bool hovered;
  final String? keyValue;

  @override
  Widget build(BuildContext context) => SizedBox(
    key: keyValue == null ? null : ValueKey<String>(keyValue!),
    height: _pillHeight,
    child: PremiumSurface(
      spec: Shadows.controlPremium,
      radius: BorderRadius.circular(Radii.full),
      border: _transparentBorder,
      hovered: hovered,
      child: const _ValueLabel(),
    ),
  );
}

/* ── Specimens ───────────────────────────────────────────────────────────── */

class _PreviewHost extends StatelessWidget {
  const _PreviewHost();

  @override
  Widget build(BuildContext context) => const _CaptionedPair(
    leftCaption: 'Surface (flat fill)',
    left: _FlatValuePill(keyValue: 'premium-surface-example:flat'),
    rightCaption: 'PremiumSurface (ramp + foil + glint)',
    right: _FoilPill(keyValue: 'premium-surface-example:preview'),
  );
}

const String _previewCode =
    "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
    '// Without: the same spec, painted flat.\n'
    'Surface(\n'
    '  spec: Shadows.controlPremium,\n'
    '  radius: BorderRadius.circular(Radii.full),\n'
    '  fill: Palette.value,\n'
    "  child: const Text('Upgrade to Pro'),\n"
    ')\n\n'
    '// With: PremiumSurface splices in the ramp, the drifting foil and the\n'
    "// sweeping glint where the flat fill went.\n"
    'PremiumSurface(\n'
    '  spec: Shadows.controlPremium,\n'
    '  radius: BorderRadius.circular(Radii.full),\n'
    "  child: const Text('Upgrade to Pro'),\n"
    ')';

class _HoveredHost extends StatelessWidget {
  const _HoveredHost();

  @override
  Widget build(BuildContext context) => const _CaptionedPair(
    leftCaption: 'hovered: false (5.5s glint)',
    left: _FoilPill(keyValue: 'premium-surface-example:rest'),
    rightCaption: 'hovered: true (2.4s glint)',
    right: _FoilPill(
      hovered: true,
      keyValue: 'premium-surface-example:hovered',
    ),
  );
}

const String _hoveredCode =
    '// Rest.\n'
    'PremiumSurface(spec: Shadows.controlPremium, hovered: false, ...)\n\n'
    '// Hovered: the caller flips one flag, same widget.\n'
    'PremiumSurface(spec: Shadows.controlPremium, hovered: true, ...)';

class _ReducedMotionHost extends StatelessWidget {
  const _ReducedMotionHost();

  @override
  Widget build(BuildContext context) => _CaptionedPair(
    leftCaption: 'Motion enabled',
    left: const _FoilPill(keyValue: 'premium-surface-example:motion'),
    rightCaption: 'MediaQuery.disableAnimations',
    right: MediaQuery(
      data: MediaQuery.of(context).copyWith(disableAnimations: true),
      child: const _FoilPill(
        keyValue: 'premium-surface-example:reduced-motion',
      ),
    ),
  );
}

const String _reducedMotionCode =
    'MediaQuery(\n'
    '  data: MediaQuery.of(context).copyWith(disableAnimations: true),\n'
    '  child: PremiumSurface(spec: Shadows.controlPremium, ...),\n'
    ')';

/* ── Disclosure content ─────────────────────────────────────────────────── */

const String _usageCode = '''
import 'package:elattar_design_system/elattar_design_system.dart';

PremiumSurface(
  spec: Shadows.controlPremium,
  radius: BorderRadius.circular(Radii.full),
  child: const Text('Upgrade to Pro'),
)''';

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) =>
      const DocsApiTable(title: 'PremiumSurface', facts: _apiFacts);
}

const List<DocsApiFact> _apiFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'spec',
    type: 'ShadowStyle',
    description:
        'Required. The `--shadow-*` token to paint: outer layers under '
        'the ramp, inset layers over it. The caller stays in charge of '
        'which spec is live — btnValue at rest, glowValue on hover, '
        'btnDown while pressed — because that state table belongs to '
        'the Button, not to this surface.',
  ),
  DocsApiFact(
    name: 'radius',
    type: 'BorderRadius',
    description:
        'Required. The shape. The ramp, both pseudo-layers and the '
        'inset shadows are all clipped to it.',
  ),
  DocsApiFact(
    name: 'border',
    type: 'BoxBorder?',
    description:
        'Optional. Defaults to null. A real border painted over the '
        'inset shadows, costing a pixel of inner width — '
        '`border border-transparent` on the premium Button.',
  ),
  DocsApiFact(
    name: 'hovered',
    type: 'bool',
    description:
        'Optional. Defaults to false. Snaps the foil\'s opacity from '
        '0.95 to 1 and halves the glint\'s period (MotionDurations.glint, '
        '5.5s, to MotionDurations.glintHover, 2.4s) — see Hovered above.',
  ),
  DocsApiFact(
    name: 'child',
    type: 'Widget',
    description:
        'Required. The label, painted under the foil and the glint — '
        'both composite OVER inline content, which is why they read as '
        'light catching the surface rather than as a layer beneath it.',
  ),
];

class _StatesContent extends StatelessWidget {
  const _StatesContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'One real state: hovered, a plain bool the caller passes — no '
            'internal hover detection of its own (the premium Button\'s '
            'own MouseRegion decides when to pass true). false to true '
            'snaps foilOpacity 0.95 to foilHoverOpacity 1 (no '
            'transition — the pseudo-element declares none) and halves '
            'the glint period; see Hovered above for what that does to '
            'an in-flight sweep.',
        'Two perpetual loops regardless of hovered: the foil drift '
            '(MotionDurations.foilDrift, 11s, never changes with hover) and '
            'the glint sweep, both driven by ONE shared elapsed clock '
            '(a bare Ticker, not two AnimationControllers) so the drift '
            'and the glint\'s idle phase never desynchronise from each '
            'other.',
        'Reduced motion is the other real variable — see Reduced '
            'Motion above and the Ticker\'s own _run: it stops entirely '
            'rather than freezing mid-frame, and resets elapsed to '
            'Duration.zero, so frame 0 is what paints.',
      ]);
}

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'PremiumSurface renders no Semantics node of its own: build() '
            'returns a RepaintBoundary wrapping a Stack of DecoratedBox, '
            'CustomPaint and Surface layers, none of which '
            'declare accessibility metadata. Whatever semantics child '
            'carries pass through untouched.',
        'No accessible name, no role, no busy/animating flag: a caller '
            'composing an interactive premium action (Button\'s own '
            'Semantics(button: true)) owns accessibility entirely, '
            'exactly as it does over Surface.',
        'The perpetual animation carries no ARIA-equivalent live-region '
            'or reduced-motion announcement of its own — MediaQuery.'
            'disableAnimations silences the motion (see Reduced Motion), '
            'but nothing here tells assistive tech the surface animates '
            'at all.',
      ]);
}

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Takes no focus and handles no key: premium_surface.dart declares no '
            'Focus, no FocusNode, no onKeyEvent, no GestureDetector or '
            'MouseRegion of its own. hovered arrives as a plain '
            'constructor argument; the premium Button\'s own Focus and '
            'MouseRegion decide when to flip it.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'No breakpoint branching anywhere in premium_surface.dart: '
            'BuildContext width is never read for a layout decision.',
        'The Stack is StackFit.passthrough, alignment topLeft: the one '
            'non-positioned child (the Surface carrying spec, '
            'radius, border and child) is what the Stack sizes itself '
            'against, so a caller\'s own SizedBox or Row constraints '
            'reach the label exactly as they would over a bare '
            'Surface.',
        'Every gradient layer (the ramp, the striations, the sheen, the '
            'corner light, the glint band) is sized and positioned as a '
            'fraction of the painted box (CSS background-size / '
            'background-position, reproduced by _imageRect), so the '
            'motion and the geometry both scale with whatever box the '
            'caller gives it, at every viewport.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      _bullets(ThemeScope.of(context), <String>[
        'File: lib/src/components/ui/premium_surface.dart: one file, no companions.',
        'Flutter imports: dart:math, dart:ui, package:flutter/'
            'foundation.dart, package:flutter/scheduler.dart (Ticker), '
            'package:flutter/widgets.dart.',
        'Foundation imports: foundation/colors.dart (OklabColor.mix, '
            'Palette), foundation/motion.dart (effectiveMotionDuration, '
            'MotionDurations, MotionCurves), foundation/shadows.dart, '
            'foundation/theme.dart, theme_scope.dart.',
        'Effect import: effects/surface.dart (Surface) '
            '— paints the inset shadows, border, and content over the '
            'ramp this file draws.',
        'registryDependencies, resolved automatically by `elattar add '
            'premium-surface`: surface, source-foundation — copied '
            'verbatim from registry/components/premium-surface.json. '
            'semanticDependencies (the manifest\'s narrower field): '
            'surface.',
        'Real use in this corpus: lib/src/components/ui/button.dart\'s '
            '_surface, the premium arm only — ButtonVariant.premium is '
            'the sole caller in the package. action_feedback.dart carries a '
            'near-identical CSS-background-painting toolkit '
            '(_gradientLine, _imageRect, _groupPaint, _radialShader) for '
            'the primary variant\'s own effect, duplicated rather than '
            'shared, per this file\'s own comment.',
      ]),
      SizedBox(height: space(2)),
      DocsLinkRow(
        links: <DocsLink>[
          DocsLink(label: 'Button', route: '/components/button'),
          DocsLink(label: 'Surface', route: '/components/surface'),
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
        'The metal ramp itself does NOT flip with the theme: every one '
            'of its seven stops is derived from Palette (valueBright, '
            'value, valueDark), fixed colours rather than theme.* '
            'getters. rampColors is a static final list, computed once. '
            'premium_surface.dart\'s own doc: "the one surface in the system '
            'that looks the same on a white page as on a black one."',
        'The label is the same deliberate non-flip: Palette.'
            'valueForeground stays dark in both themes (see the Preview '
            'specimen above) — that choice lives on the caller '
            '(Button\'s premium variant), not inside this file, but '
            'every specimen on this page carries it because the metal '
            'reads correctly only with it.',
        'What DOES read theme.* is the spec argument the caller passes: '
            'each ShadowLayer inside Shadows.controlPremium / glowValue / '
            'btnDown is a Color Function(ThemeTokens), resolved live via '
            'ThemeScope.of(context) inside PremiumSurface.build — see the '
            'Surface page\'s own Theming section for what that '
            'means.',
        'The one theme-dependent blend-mode split the reference makes '
            'elsewhere (multiply on light, screen on dark, for '
            'action-feedback) does NOT apply here: foilBlend (softLight) '
            'and glintBlend (screen) are both const, unconditional, in '
            'both themes — the ramp is opaque, so the foil composites '
            'against its own base rather than against the page, and '
            'never needs the split. premium_surface.dart\'s own doc names '
            'this explicitly.',
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
