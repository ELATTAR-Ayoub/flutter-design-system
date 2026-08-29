/// Public documentation page for the `glass` effect.
///
/// **Not a component.** `lib/src/components/ui/glass.dart` exports four
/// `StatelessWidget`s — `GlassVariant.panel`, `GlassVariant.navigation`,
/// `GlassVariant.prominent`, `GlassVariant.control` — none with a variant, a size, or an
/// enum of their own. One material (a translucent fill, a backdrop blur, a
/// hairline rim), split by scale: card-weight panels blur what is behind
/// them, the pill-scale control does not.
///
/// **House shape, effect edition.** Preview, Installation, Usage, then one
/// `EffectSection` per facet the effect actually has (control vs panel,
/// panel vs its deep ambient, panel vs its clearer fill), then the same
/// eight disclosures every component page carries. Every `EffectSection`
/// stages a real host beside the same host with the effect removed or one
/// variable changed.
///
/// **Honesty on real use.** `grep -rln "GlassVariant.panel\|GlassVariant.control\|
/// GlassVariant.prominent\|GlassVariant.navigation" lib/src/` at the time this page was
/// written returns only `glass.dart` itself: no component in the corpus
/// composes any of these four yet. `example/lib/pages/shadows.dart`'s own
/// `#glass` section is the one place in the app that mounts them, and it is
/// what the Deep/Clear/Control specimens below are modelled on. The
/// Dependencies disclosure says this plainly rather than inventing a caller.
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

final ComponentDocSpec glassDocSpec = ComponentDocSpec(
  name: 'glass',
  title: 'Glass',
  description: glassDoc.description,
  sections: <DocsPageSection>[
    EffectSection(
      id: 'preview',
      title: 'Preview',
      description:
          'An opaque theme.card rectangle beside an GlassVariant.panel over the '
          'same colourful backdrop. The panel\'s fill is theme.card at '
          '74% (color-mix toward transparent), so the gradient behind it '
          'stays visible through the blur — the whole reason to reach for '
          'this over a flat bg-card.',
      host: const _PreviewHost(),
      code: _previewCode,
      label: 'Preview specimen view',
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'glass has a real registry manifest, `elattar add glass` '
          'installs lib/src/components/ui/glass.dart and resolves both '
          'registryDependencies — surface, source-foundation — '
          'automatically. The Manual tab is for a project not using the '
          'CLI.',
      command: glassDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/glass.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/ui/glass.dart's generated "
              '@ui/glass.dart payload into components/ui.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated glass source here when using manual '
              'mode.',
        ),
        DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so all four glass widgets are '
              'reachable the same way the CLI path already makes them.',
          code: "export 'glass.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'The smallest correct import and construction: a card-scale '
          'panel over whatever sits behind it.',
      code: _usageCode,
    ),
    EffectSection(
      id: 'control',
      title: 'Control',
      description:
          'GlassVariant.control is the pill-scale utility: a theme.foreground '
          'wash at 7% and two inset layers only — no blur, no saturate, '
          'no ambient shadow. At 44px (rendered 48, a documented drift '
          'against the CSS comment and the section copy) there is '
          'nothing behind it worth blurring, and e2 under something that '
          'small reads as grime rather than depth.',
      host: const _ControlHost(),
      code: _controlCode,
      label: 'Control specimen view',
    ),
    EffectSection(
      id: 'deep',
      title: 'Deep',
      description:
          'GlassVariant.panel and GlassVariant.prominent are byte-identical but for '
          'their ambient layer: shadow-e2 against shadow-e4. e4 rather '
          'than a bespoke shadow, because elevation reads as a ratio of '
          'object to shadow — the depth that floats a 400px dialog leaves '
          'a full-width panel looking welded down.',
      host: const _DeepHost(),
      code: _deepCode,
      label: 'Deep specimen view',
    ),
    EffectSection(
      id: 'clear',
      title: 'Clear',
      description:
          'GlassVariant.navigation shares every mechanic with GlassVariant.panel — '
          'geometry, backdrop blur and saturation, rim, highlight, e2 '
          'ambient — and lowers only the fill opacity, for floating '
          'navigation chrome where content moving beneath should stay '
          'more visible through the blur.',
      host: const _ClearHost(),
      code: _clearCode,
      label: 'Clear specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every constructor parameter each of the four glass widgets '
          'declares, read off lib/src/components/ui/glass.dart: one table per '
          'class, since all four are exported from this one file.',
      child: const _ApiReferenceContent(),
      children: const <DocsTocEntry>[
        DocsTocEntry(title: 'GlassVariant.panel', anchor: 'api-elglasspanel'),
        DocsTocEntry(
          title: 'GlassVariant.navigation',
          anchor: 'api-elglasspanelclear',
        ),
        DocsTocEntry(
          title: 'GlassVariant.prominent',
          anchor: 'api-elglasspaneldeep',
        ),
        DocsTocEntry(
          title: 'GlassVariant.control',
          anchor: 'api-elglasscontrol',
        ),
      ],
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
            value: glassDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'test/effects_test.dart',
            description:
                'The "glass composites" and "glass utilities" groups cover '
                'the fill maths, the ambient clip, the inset ring, and '
                'the saturate colour filter.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/glass_test.dart',
            description:
                'Covers this page: the article mounts, the full API '
                'table, and both themes at two viewport widths.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/glass/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class GlassDocPage extends StatelessWidget {
  const GlassDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: glassDoc.route,
    intro: DocsPageIntro(
      title: glassDoc.title,
      description: glassDoc.description,
    ),
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Components'),
      BreadcrumbEntry.page('Glass'),
    ],
    toc: glassDocSpec.toc,
    previous: null,
    next: null,
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('glass-doc-article'),
      child: ComponentDocPage(spec: glassDocSpec, header: false),
    ),
  );
}

/* ── Shared specimen shape ──────────────────────────────────────────────── */

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

/// The gradient stage a card-scale panel is judged against: content moving
/// underneath is the whole reason `GlassVariant.panel`'s fill is translucent.
class _ColourfulStage extends StatelessWidget {
  const _ColourfulStage({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Container(
      width: space(56),
      height: space(32),
      padding: EdgeInsets.all(space(4)),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Radii.xl4),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[theme.primary, theme.accent, theme.secondary],
        ),
      ),
      child: child,
    );
  }
}

class _OpaqueCard extends StatelessWidget {
  const _OpaqueCard({required this.label, this.keyValue});

  final String label;
  final String? keyValue;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Container(
      key: keyValue == null ? null : ValueKey<String>(keyValue!),
      padding: EdgeInsets.all(space(4)),
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(Radii.lg),
        border: Border.all(color: theme.border, width: BorderWidths.hairline),
      ),
      child: StyledText(label, TextStyles.small, color: theme.foreground),
    );
  }
}

/* ── Specimens ───────────────────────────────────────────────────────────── */

class _PreviewHost extends StatelessWidget {
  const _PreviewHost();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return _CaptionedPair(
      leftCaption: 'Opaque theme.card',
      left: _ColourfulStage(
        child: const _OpaqueCard(
          label: 'card',
          keyValue: 'glass-example:opaque',
        ),
      ),
      rightCaption: 'GlassVariant.panel',
      right: _ColourfulStage(
        child: SizedBox(
          key: const ValueKey<String>('glass-example:preview'),
          width: space(28),
          height: space(16),
          child: Glass(
            variant: GlassVariant.panel,
            radius: BorderRadius.circular(Radii.xl4),
            child: Center(
              child: StyledText(
                'glass-panel',
                TextStyles.small,
                color: theme.foreground,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

const String _previewCode =
    "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
    '// Without: an opaque card, whatever sits behind it hidden entirely.\n'
    'DecoratedBox(\n'
    '  decoration: BoxDecoration(\n'
    '    color: theme.card,\n'
    '    borderRadius: BorderRadius.circular(Radii.lg),\n'
    '  ),\n'
    "  child: const Text('card'),\n"
    ')\n\n'
    '// With: GlassVariant.panel — translucent theme.card, a backdrop blur, a\n'
    '// hairline rim — over the same backdrop.\n'
    'Glass(variant: GlassVariant.panel, \n'
    '  radius: BorderRadius.circular(Radii.xl4),\n'
    "  child: const Text('glass-panel'),\n"
    ')';

class _ControlHost extends StatelessWidget {
  const _ControlHost();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    Widget backdrop(Widget child) => Container(
      width: space(40),
      height: space(24),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(Radii.xl4),
      ),
      child: child,
    );
    return _CaptionedPair(
      leftCaption: 'Plain pill',
      left: backdrop(
        Container(
          key: const ValueKey<String>('glass-example:control-flat'),
          height: space(12),
          padding: EdgeInsets.symmetric(horizontal: space(4)),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: OklabColor.mix(theme.foreground, transparent, 0.07),
            borderRadius: BorderRadius.circular(Radii.full),
          ),
          child: StyledText(
            'glass-control',
            TextStyles.small,
            color: theme.foreground,
          ),
        ),
      ),
      rightCaption: 'GlassVariant.control',
      right: backdrop(
        SizedBox(
          key: const ValueKey<String>('glass-example:control'),
          height: space(12),
          child: Glass(
            variant: GlassVariant.control,
            radius: BorderRadius.circular(Radii.full),
            padding: EdgeInsets.symmetric(horizontal: space(4)),
            child: Center(
              widthFactor: 1,
              child: StyledText(
                'glass-control',
                TextStyles.small,
                color: theme.foreground,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

const String _controlCode =
    'Glass(variant: GlassVariant.control, \n'
    '  radius: BorderRadius.circular(Radii.full),\n'
    '  padding: EdgeInsets.symmetric(horizontal: space(4)),\n'
    "  child: const Text('glass-control'),\n"
    ')';

class _DeepHost extends StatelessWidget {
  const _DeepHost();

  @override
  Widget build(BuildContext context) => _CaptionedPair(
    leftCaption: 'GlassVariant.panel (shadow-e2)',
    left: _ColourfulStage(
      child: SizedBox(
        key: const ValueKey<String>('glass-example:deep-e2'),
        width: space(24),
        height: space(14),
        child: Glass(
          variant: GlassVariant.panel,
          radius: BorderRadius.circular(Radii.xl4),
          child: const SizedBox.expand(),
        ),
      ),
    ),
    rightCaption: 'GlassVariant.prominent (shadow-e4)',
    right: _ColourfulStage(
      child: SizedBox(
        key: const ValueKey<String>('glass-example:deep-e4'),
        width: space(24),
        height: space(14),
        child: Glass(
          variant: GlassVariant.prominent,
          radius: BorderRadius.circular(Radii.xl4),
          child: const SizedBox.expand(),
        ),
      ),
    ),
  );
}

const String _deepCode =
    '// shadow-e2 ambient.\n'
    'Glass(variant: GlassVariant.panel, radius: BorderRadius.circular(Radii.xl4), child: ...)\n\n'
    '// shadow-e4 ambient — same fill, same rim, same highlight.\n'
    'Glass(variant: GlassVariant.prominent, radius: BorderRadius.circular(Radii.xl4), child: ...)';

class _ClearHost extends StatelessWidget {
  const _ClearHost();

  @override
  Widget build(BuildContext context) => _CaptionedPair(
    leftCaption: 'GlassVariant.panel',
    left: _ColourfulStage(
      child: SizedBox(
        key: const ValueKey<String>('glass-example:clear-panel'),
        width: space(24),
        height: space(14),
        child: Glass(
          variant: GlassVariant.panel,
          radius: BorderRadius.circular(Radii.xl4),
          child: const SizedBox.expand(),
        ),
      ),
    ),
    rightCaption: 'GlassVariant.navigation',
    right: _ColourfulStage(
      child: SizedBox(
        key: const ValueKey<String>('glass-example:clear'),
        width: space(24),
        height: space(14),
        child: Glass(
          variant: GlassVariant.navigation,
          radius: BorderRadius.circular(Radii.xl4),
          child: const SizedBox.expand(),
        ),
      ),
    ),
  );
}

const String _clearCode =
    '// Standard fill.\n'
    'Glass(variant: GlassVariant.panel, radius: BorderRadius.circular(Radii.xl4), child: ...)\n\n'
    "// A lower, foundation-owned fill opacity: floating navigation chrome.\n"
    'Glass(variant: GlassVariant.navigation, radius: BorderRadius.circular(Radii.xl4), child: ...)';

/* ── Disclosure content ─────────────────────────────────────────────────── */

const String _usageCode = '''
import 'package:elattar_design_system/elattar_design_system.dart';

Glass(variant: GlassVariant.panel,
  radius: BorderRadius.circular(Radii.xl4),
  padding: EdgeInsets.all(space(6)),
  child: const Text('Card'),
)''';

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsAnchor(
        id: 'api-elglasspanel',
        child: DocsApiTable(title: 'GlassVariant.panel', facts: _panelFacts),
      ),
      SizedBox(height: space(6)),
      DocsAnchor(
        id: 'api-elglasspanelclear',
        child: const DocsApiTable(
          title: 'GlassVariant.navigation',
          facts: _panelFacts,
        ),
      ),
      SizedBox(height: space(6)),
      DocsAnchor(
        id: 'api-elglasspaneldeep',
        child: const DocsApiTable(
          title: 'GlassVariant.prominent',
          facts: _panelFacts,
        ),
      ),
      SizedBox(height: space(6)),
      DocsAnchor(
        id: 'api-elglasscontrol',
        child: const DocsApiTable(
          title: 'GlassVariant.control',
          facts: _panelFacts,
        ),
      ),
    ],
  );
}

/// All four glass widgets declare the identical three-field constructor:
/// `radius`, an optional `padding`, and `child`.
const List<DocsApiFact> _panelFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'radius',
    type: 'BorderRadius',
    description:
        'Required. The shape. The fill, both inset layers, the ambient '
        'shadow (panels only) and the backdrop clip (panel/deep only) '
        'all follow it.',
  ),
  DocsApiFact(
    name: 'padding',
    type: 'EdgeInsetsGeometry?',
    description:
        'Optional. Defaults to null. The CSS utility declares none of '
        'its own; a caller that wants inner air passes it.',
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
        'All four are StatelessWidgets: no hover, press, focus, or '
            'internal state of their own — no States matrix in the sense '
            'a control has one.',
        'What varies is which of the four a caller picks: scale (panel '
            'vs control), elevation (e2 vs e4), and fill opacity '
            '(standard vs clear) — a build-time choice, not a runtime '
            'transition. See Control, Deep and Clear above for each.',
        'Reduced motion has nothing to answer here: none of the four '
            'mounts an AnimationController, a Ticker, or a '
            'TweenAnimationBuilder. The blur and the shadows are static '
            'paints, not animations.',
      ]);
}

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'None of the four glass widgets renders a Semantics node of its '
            'own: each build() returns a Stack or a single '
            'Surface, neither of which declares accessibility '
            'metadata. Whatever semantics child carries pass through '
            'untouched.',
        'No accessible name, no role: a caller composing interactive '
            'content inside one of these (a button, a link) owns its own '
            'Semantics exactly as it would without the glass wrapper.',
      ]);
}

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Takes no focus and handles no key: glass.dart declares no '
            'Focus, no FocusNode, no onKeyEvent on any of the four '
            'classes. Each is a paint-only surface; a caller that wants '
            'keyboard interaction wraps its own focusable content as '
            'child.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'No breakpoint branching anywhere in glass.dart: BuildContext '
            'width is never read for a layout decision.',
        'radius, padding and child are all the caller\'s own choices. '
            'The ambient-shadow clip (_outsideShape) and the inset ring '
            'both recompute from the RenderBox Size Flutter hands them '
            'at paint time, so the geometry scales with whatever box the '
            'caller gives it, at every viewport.',
        'The backdrop blur (ImageFilter.blur, sigma from Blurs.xl) is '
            'a fixed radius, not a fraction of the box: a wider panel '
            'blurs its backdrop by the same amount a narrow one does.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      _bullets(ThemeScope.of(context), <String>[
        'File: lib/src/components/ui/glass.dart: one file, four classes, no '
            'companions.',
        'Flutter imports: dart:math, dart:ui, package:flutter/'
            'foundation.dart (listEquals), package:flutter/widgets.dart.',
        'Foundation imports: foundation/colors.dart (OklabColor.mix), '
            'foundation/shadows.dart, foundation/spacing.dart (space()), '
            'foundation/surfaces.dart (SurfaceOpacity), foundation/'
            'theme.dart, theme_scope.dart.',
        'Effect import: effects/surface.dart (Surface) — '
            'every inset layer in every glass spec is painted through it.',
        'registryDependencies, resolved automatically by `elattar add '
            'glass`: surface, source-foundation — copied '
            'verbatim from registry/components/glass.json. '
            'semanticDependencies (the manifest\'s narrower field): '
            'surface.',
        'Real use in this corpus, honestly: none yet. grep -rln '
            '"GlassVariant.panel\\|GlassVariant.control\\|GlassVariant.prominent\\|'
            'GlassVariant.navigation" lib/src/ returns only glass.dart itself — '
            'no component composes any of the four. '
            'example/lib/pages/shadows.dart\'s own #glass section is the '
            'one place in the app that mounts them, and what the Control, '
            'Deep and Clear specimens above are modelled on.',
      ]),
      SizedBox(height: space(2)),
      DocsLinkRow(
        links: <DocsLink>[
          DocsLink(label: 'Surface', route: '/components/surface'),
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
    '"Neither needs a dark: variant" — glass.dart\'s own library '
        'doc. Every fill and rim is OklabColor.mix(X, transparent, N) '
        'over theme.card or theme.foreground, so a light edge on '
        'dark and a dark edge on light fall out of the same '
        'expression with no theme branch anywhere in the file.',
    'GlassVariant.panel / GlassVariant.prominent fill: '
        'OklabColor.mix(theme.card, transparent, SurfaceOpacity.'
        'glassPanel) — theme.card at 74%.',
    'GlassVariant.navigation fill: OklabColor.mix(theme.card, transparent, '
        'SurfaceOpacity.navigationGlass) — the same mix at the '
        'foundation-owned, lower navigation-glass opacity.',
    'GlassVariant.control fill: OklabColor.mix(theme.foreground, '
        'transparent, 0.07) — theme.foreground at 7%.',
    'Every rim: OklabColor.mix(theme.foreground, transparent, N) — '
        '12% on the two panels, 16% on the control (heavier, because '
        'a control has no ambient shadow to describe its edge; the '
        'ring is the whole silhouette).',
    'The top highlight on all four is theme.rimStrong — the same '
        'token every other raised surface carries, which is '
        'what keeps a glass panel in the same visual world as a '
        'button.',
    'The two panels\' ambient is Shadows.md (GlassVariant.panel, '
        'GlassVariant.navigation) or Shadows.xl (GlassVariant.prominent): each '
        'layer inside those specs is itself a Color Function'
        '(ThemeTokens), resolved live — see the Surface '
        'page\'s own Theming section for what that means.',
    'The backdrop blur and saturation (blur(24px) saturate(1.5) on '
        'the two panels; none on the control) are geometry, not '
        'colour: they do not change between themes.',
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
