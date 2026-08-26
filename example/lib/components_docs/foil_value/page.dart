/// Public documentation page for the `foil-value` effect.
///
/// **Not a component.** `lib/src/effects/foil_value.dart` exports one
/// `StatefulWidget`, `ElFoilValue` — the premium Button's surface, and only
/// the premium Button's surface. No enum, no size rung: five constructor
/// parameters (`spec`, `radius`, `border`, `hovered`, `child`), the same
/// shape an `ElMachineSurface` call takes plus one `hovered` flag, because
/// this is where the ramp, the foil and the glint splice in instead of a
/// flat fill.
///
/// **House shape, effect edition.** Preview, Installation, Usage, then one
/// `EffectSection` per facet the effect actually has (`hovered`, reduced
/// motion), then the same eight disclosures every component page carries.
/// Every `EffectSection` stages a host modelled on `ElButtonVariant.premium`
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
import 'package:flutter/widgets.dart';

import '../../docs/component_doc_page.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import 'meta.dart';

final ComponentDocSpec foilValueDocSpec = ComponentDocSpec(
  name: 'foil_value',
  title: 'Foil Value',
  description: foilValueDoc.description,
  sections: <DocsPageSection>[
    EffectSection(
      id: 'preview',
      title: 'Preview',
      description:
          'The same ElShadows.btnValue spec painted two ways: flat, '
          'through ElMachineSurface with fill: ElPalette.value, and '
          'through ElFoilValue, whose metal ramp, drifting foil and '
          'sweeping glint splice in where a flat fill would otherwise '
          'go. Both carry ElPalette.valueForeground text, the one '
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
          'foil-value has a real registry manifest, `elattar add '
          'foil-value` installs lib/src/effects/foil_value.dart and '
          'resolves both registryDependencies — machine-surface, '
          'source-foundation — automatically. The Manual tab is for a '
          'project not using the CLI.',
      command: foilValueDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/effects/foil_value.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/effects/foil_value.dart's generated "
              '@effects/foil_value.dart payload into effects.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated foil-value source here when using '
              'manual mode.',
        ),
        DocsCodeFile(
          path: 'lib/effects/effects.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so ElFoilValue is reachable the same '
              'way the CLI path already makes it.',
          code: "export 'foil_value.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'The smallest correct import and construction: the shape and '
          'shadow spec an ElMachineSurface call would take, wrapping the '
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
          'glint\'s period halves, ElDurations.glint (5.5s) to '
          'ElDurations.glintHover (2.4s). Both loops share ONE elapsed '
          'clock, so that halving does not resume smoothly — it '
          're-divides the same elapsed time by the new duration and can '
          'jump mid-sweep, measured and recorded as real reference '
          'behaviour (ElFoilValue.phaseAt\'s own doc, ruling B10b).',
      host: const _HoveredHost(),
      code: _hoveredCode,
      label: 'Hovered specimen view',
    ),
    EffectSection(
      id: 'reduced-motion',
      title: 'Reduced Motion',
      description:
          'Both loops re-read their period through elAnimationDuration '
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
          'Every constructor parameter ElFoilValue declares, read off '
          'lib/src/effects/foil_value.dart.',
      child: const _ApiReferenceContent(),
    ),
    DisclosureSection(id: 'states', title: 'States', child: const _StatesContent()),
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
    DisclosureSection(id: 'theming', title: 'Theming', child: const _ThemingContent()),
    DisclosureSection(
      id: 'source',
      title: 'Source',
      child: DocsInstallFacts(
        title: 'Reference',
        facts: <DocsInstallFact>[
          DocsInstallFact(
            label: 'Source',
            value: foilValueDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'test/effects_test.dart',
            description:
                'The "ElFoilValue" group covers the seven derived ramp '
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
            value: 'example/lib/components_docs/foil_value/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class FoilValueDocPage extends StatelessWidget {
  const FoilValueDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: foilValueDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / EFFECTS',
      title: foilValueDoc.title,
      description: foilValueDoc.description,
    ),
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Components'),
      ElBreadcrumbEntry.page('Foil Value'),
    ],
    toc: foilValueDocSpec.toc,
    previous: null,
    next: null,
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('foil-value-doc-article'),
      child: ComponentDocPage(spec: foilValueDocSpec, header: false),
    ),
  );
}

/* ── Shared specimen shape ──────────────────────────────────────────────── */
// Sized and shaped like ElButtonVariant.premium's own pill (height 40,
// BorderRadius.circular(ElRadii.pill), a transparent border costing a
// pixel of inner width) without importing ElButton itself: this page
// documents the raw effect, not the composed control.

double get _pillHeight => el(10);

BoxBorder get _transparentBorder =>
    Border.all(color: elTransparent, width: ElWidths.hairline);

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
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      child,
      SizedBox(height: el(2)),
      ElText(
        caption,
        ElType.section,
        color: ElTheme.of(context).mutedForeground,
      ),
    ],
  );
}

class _ValueLabel extends StatelessWidget {
  const _ValueLabel();

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(horizontal: el(4)),
    child: Center(
      widthFactor: 1,
      child: ElText(
        'Upgrade to Pro',
        ElType.small,
        color: ElPalette.valueForeground,
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
    child: ElMachineSurface(
      spec: ElShadows.btnValue,
      radius: BorderRadius.circular(ElRadii.pill),
      fill: ElPalette.value,
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
    child: ElFoilValue(
      spec: ElShadows.btnValue,
      radius: BorderRadius.circular(ElRadii.pill),
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
    leftCaption: 'ElMachineSurface (flat fill)',
    left: _FlatValuePill(keyValue: 'foil-value-example:flat'),
    rightCaption: 'ElFoilValue (ramp + foil + glint)',
    right: _FoilPill(keyValue: 'foil-value-example:preview'),
  );
}

const String _previewCode =
    "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
    '// Without: the same spec, painted flat.\n'
    'ElMachineSurface(\n'
    '  spec: ElShadows.btnValue,\n'
    '  radius: BorderRadius.circular(ElRadii.pill),\n'
    '  fill: ElPalette.value,\n'
    "  child: const Text('Upgrade to Pro'),\n"
    ')\n\n'
    '// With: ElFoilValue splices in the ramp, the drifting foil and the\n'
    "// sweeping glint where the flat fill went.\n"
    'ElFoilValue(\n'
    '  spec: ElShadows.btnValue,\n'
    '  radius: BorderRadius.circular(ElRadii.pill),\n'
    "  child: const Text('Upgrade to Pro'),\n"
    ')';

class _HoveredHost extends StatelessWidget {
  const _HoveredHost();

  @override
  Widget build(BuildContext context) => const _CaptionedPair(
    leftCaption: 'hovered: false (5.5s glint)',
    left: _FoilPill(keyValue: 'foil-value-example:rest'),
    rightCaption: 'hovered: true (2.4s glint)',
    right: _FoilPill(hovered: true, keyValue: 'foil-value-example:hovered'),
  );
}

const String _hoveredCode =
    '// Rest.\n'
    'ElFoilValue(spec: ElShadows.btnValue, hovered: false, ...)\n\n'
    '// Hovered: the caller flips one flag, same widget.\n'
    'ElFoilValue(spec: ElShadows.btnValue, hovered: true, ...)';

class _ReducedMotionHost extends StatelessWidget {
  const _ReducedMotionHost();

  @override
  Widget build(BuildContext context) => _CaptionedPair(
    leftCaption: 'Motion enabled',
    left: const _FoilPill(keyValue: 'foil-value-example:motion'),
    rightCaption: 'MediaQuery.disableAnimations',
    right: MediaQuery(
      data: MediaQuery.of(context).copyWith(disableAnimations: true),
      child: const _FoilPill(keyValue: 'foil-value-example:reduced-motion'),
    ),
  );
}

const String _reducedMotionCode =
    'MediaQuery(\n'
    '  data: MediaQuery.of(context).copyWith(disableAnimations: true),\n'
    '  child: ElFoilValue(spec: ElShadows.btnValue, ...),\n'
    ')';

/* ── Disclosure content ─────────────────────────────────────────────────── */

const String _usageCode = '''
import 'package:elattar_design_system/elattar_design_system.dart';

ElFoilValue(
  spec: ElShadows.btnValue,
  radius: BorderRadius.circular(ElRadii.pill),
  child: const Text('Upgrade to Pro'),
)''';

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) =>
      const DocsApiTable(title: 'ElFoilValue', facts: _apiFacts);
}

const List<DocsApiFact> _apiFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'spec',
    type: 'ElShadowSpec',
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
        '0.95 to 1 and halves the glint\'s period (ElDurations.glint, '
        '5.5s, to ElDurations.glintHover, 2.4s) — see Hovered above.',
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
      _bullets(ElTheme.of(context), <String>[
        'One real state: hovered, a plain bool the caller passes — no '
            'internal hover detection of its own (the premium Button\'s '
            'own MouseRegion decides when to pass true). false to true '
            'snaps foilOpacity 0.95 to foilHoverOpacity 1 (no '
            'transition — the pseudo-element declares none) and halves '
            'the glint period; see Hovered above for what that does to '
            'an in-flight sweep.',
        'Two perpetual loops regardless of hovered: the foil drift '
            '(ElDurations.foilDrift, 11s, never changes with hover) and '
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
      _bullets(ElTheme.of(context), <String>[
        'ElFoilValue renders no Semantics node of its own: build() '
            'returns a RepaintBoundary wrapping a Stack of DecoratedBox, '
            'CustomPaint and ElMachineSurface layers, none of which '
            'declare accessibility metadata. Whatever semantics child '
            'carries pass through untouched.',
        'No accessible name, no role, no busy/animating flag: a caller '
            'composing an interactive premium action (ElButton\'s own '
            'Semantics(button: true)) owns accessibility entirely, '
            'exactly as it does over ElMachineSurface.',
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
      _bullets(ElTheme.of(context), <String>[
        'Takes no focus and handles no key: foil_value.dart declares no '
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
      _bullets(ElTheme.of(context), <String>[
        'No breakpoint branching anywhere in foil_value.dart: '
            'BuildContext width is never read for a layout decision.',
        'The Stack is StackFit.passthrough, alignment topLeft: the one '
            'non-positioned child (the ElMachineSurface carrying spec, '
            'radius, border and child) is what the Stack sizes itself '
            'against, so a caller\'s own SizedBox or Row constraints '
            'reach the label exactly as they would over a bare '
            'ElMachineSurface.',
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
      _bullets(ElTheme.of(context), <String>[
        'File: lib/src/effects/foil_value.dart: one file, no companions.',
        'Flutter imports: dart:math, dart:ui, package:flutter/'
            'foundation.dart, package:flutter/scheduler.dart (Ticker), '
            'package:flutter/widgets.dart.',
        'Foundation imports: foundation/colors.dart (ElOklab.mix, '
            'ElPalette), foundation/motion.dart (elAnimationDuration, '
            'ElDurations, ElCurves), foundation/shadows.dart, '
            'foundation/theme.dart, theme_scope.dart.',
        'Effect import: effects/machine_surface.dart (ElMachineSurface) '
            '— paints the inset shadows, border, and content over the '
            'ramp this file draws.',
        'registryDependencies, resolved automatically by `elattar add '
            'foil-value`: machine-surface, source-foundation — copied '
            'verbatim from registry/effects/foil-value.json. '
            'semanticDependencies (the manifest\'s narrower field): '
            'machine-surface.',
        'Real use in this corpus: lib/src/components/button.dart\'s '
            '_surface, the premium arm only — ElButtonVariant.premium is '
            'the sole caller in the package. sheen_action.dart carries a '
            'near-identical CSS-background-painting toolkit '
            '(_gradientLine, _imageRect, _groupPaint, _radialShader) for '
            'the primary variant\'s own effect, duplicated rather than '
            'shared, per this file\'s own comment.',
      ]),
      SizedBox(height: el(2)),
      DocsLinkRow(
        links: <DocsLink>[
          DocsLink(label: 'Button', route: '/components/button'),
          DocsLink(label: 'Machine Surface', route: '/components/machine_surface'),
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
        'The metal ramp itself does NOT flip with the theme: every one '
            'of its seven stops is derived from ElPalette (valueBright, '
            'value, valueDark), fixed colours rather than theme.* '
            'getters. rampColors is a static final list, computed once. '
            'foil_value.dart\'s own doc: "the one surface in the system '
            'that looks the same on a white page as on a black one."',
        'The label is the same deliberate non-flip: ElPalette.'
            'valueForeground stays dark in both themes (see the Preview '
            'specimen above) — that choice lives on the caller '
            '(ElButton\'s premium variant), not inside this file, but '
            'every specimen on this page carries it because the metal '
            'reads correctly only with it.',
        'What DOES read theme.* is the spec argument the caller passes: '
            'each ElShadowLayer inside ElShadows.btnValue / glowValue / '
            'btnDown is a Color Function(ElThemeData), resolved live via '
            'ElTheme.of(context) inside ElFoilValue.build — see the '
            'Machine Surface page\'s own Theming section for what that '
            'means.',
        'The one theme-dependent blend-mode split the reference makes '
            'elsewhere (multiply on light, screen on dark, for '
            'sheen-action) does NOT apply here: foilBlend (softLight) '
            'and glintBlend (screen) are both const, unconditional, in '
            'both themes — the ramp is opaque, so the foil composites '
            'against its own base rather than against the page, and '
            'never needs the split. foil_value.dart\'s own doc names '
            'this explicitly.',
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
