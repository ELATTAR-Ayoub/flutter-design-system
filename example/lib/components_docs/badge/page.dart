/// Public documentation page for the `badge` component.
///
/// **Re-housed onto the documentation kit.** This page used to be a
/// hand-composed `_BadgeArticle` built from `kit.dart`'s `ElSection` (see
/// `example/lib/components_docs/button/page.dart`'s own library doc for the
/// house shape every page is being moved onto). Every specimen and every
/// code string below is the same one the old page rendered; what moved is
/// only where the content lives: a `ComponentDocSpec` declaration plus a
/// ten-line widget, `DocsSection`/`DocsDisclosure` instead of `ElSection`,
/// and the eight fixed disclosures in the house order (API Reference,
/// States, Accessibility, Keyboard, Responsive, Dependencies, Theming,
/// Source) instead of the old page's own six-and-varying set.
///
/// **Renamed, not reworded.** The old disclosure titles carried their own
/// descriptive suffixes ("States and feedback", "Accessibility and keyboard
/// behavior", "Dependencies, files, and assets", "Theming notes", "Source,
/// tests, and docs"): `docs_page_shape_test.dart` requires the eight fixed
/// titles verbatim, so the suffixes are gone from the headings. Nothing the
/// suffix described is gone from the page — the prose underneath is
/// unchanged (Keyboard aside, see below).
///
/// **One real addition: Keyboard.** The old page had no dedicated Keyboard
/// section; its Accessibility bullet already stated `ElBadge` takes no
/// keyboard interactions at all. The new Keyboard disclosure below restates
/// that fact on its own, read directly off `lib/src/components/badge.dart`:
/// there is no `Focus`, no `FocusNode`, and no `Focus.onKeyEvent` anywhere in
/// the file, so there is nothing for a key to reach.
///
/// **The ElBadgeVariant table moved.** It used to sit inside the old page's
/// `Variants` section, beside the live grid. `DocsPageSection` is sealed into
/// four cases with no room for a table beside a showcase specimen, so it now
/// sits inside API Reference as a third table, alongside `ElBadge` and
/// `ElBadge static helpers` — the same place `ElButtonVariant`'s table lives
/// on the button page.
///
/// `badgeDoc` (from `meta.dart`) is the data source, not `componentDoc('badge')`.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/component_doc_page.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../docs/docs_section.dart' show DocsAnchor;
import 'meta.dart';

/// The declaration: every section this page shows, in TOC order. `final`,
/// not `const`: `InstallSection.command` reads `badgeDoc.command`, a
/// computed getter, not a constant expression.
final ComponentDocSpec badgeDocSpec = ComponentDocSpec(
  name: 'badge',
  title: 'Badge',
  description:
      'A small pill-shaped label for status, counts, or metadata: not a '
      'control.',
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'ElBadge renders a small pill: a fixed 20px-tall, label-sized '
          'chip used to mark a status, a count, or a category: never an '
          'action. Eleven variants map to six semantic fills (success, '
          'warning, info, destructive, action, premium) plus primary and '
          'secondary, and three unfilled treatments (outline, ghost, link) '
          'for contexts that want restraint. Reach for it over ElKbd when '
          'the content is a status word or a count rather than a literal '
          'keystroke: kbd renders a monospace key cap, badge renders a '
          'semantic chip. Reach for it over a plain label when the value '
          'needs its own filled, bordered, or coloured surface to separate '
          'it from surrounding prose. And reach for ElButton instead the '
          'moment the chip needs to respond to a tap: ElBadge carries no '
          'GestureDetector, no FocusNode, and no pressed or hover state by '
          'design: its own source docstring puts it plainly, "a badge is a '
          'label, not a button, and it must not invite a click."',
      specimen: _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'badge ships in the registry, so `elattar add badge` is not '
          'available: install by copying the source file manually.',
      command: badgeDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/badge.dart',
          description:
              'No registry/components/badge.json exists yet: this is a '
              'source-only component today. Dependencies once registered '
              'would resolve to source-foundation and machine-surface.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Install with: elattar add badge',
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description: 'The smallest correct call, then the shapes seen above.',
      code: _usageCode,
    ),
    ShowcaseSection(
      id: 'variants',
      title: 'Variants',
      description:
          'All eleven ElBadgeVariant values. Badge has no size axis: every '
          'chip is the same hard 20px border box (ElBadge.height); content '
          'never grows it. Use paddingX or minWidth to adjust footprint '
          'instead of a size enum.',
      specimen: _VariantsSpecimen(),
      code: _variantsCode,
      label: 'Variants specimen view',
    ),
    ShowcaseSection(
      id: 'with-icon',
      title: 'With icon',
      description:
          'A leading glyph, forced to 12px square with a 4px gap before the '
          'label regardless of the icon\'s own size: the data page\'s '
          '"Featured" chips.',
      specimen: _WithIconSpecimen(),
      code: _withIconCode,
      label: 'With icon specimen view',
    ),
    ShowcaseSection(
      id: 'with-spinner',
      title: 'With spinner',
      description:
          'The glyph slot takes any widget, including ElSpinner: sized down '
          'to ElBadge.glyphSize (12px) so it fills the same square an icon '
          'would.',
      specimen: _WithSpinnerSpecimen(),
      code: _withSpinnerCode,
      label: 'With spinner specimen view',
    ),
    ShowcaseSection(
      id: 'rtl',
      title: 'RTL',
      description:
          'ElBadge paints no direction-specific layout of its own: it sizes '
          'to its label and centres its content either way, the same '
          'composition read right-to-left under a Directionality.',
      specimen: _RtlSpecimen(),
      code: _rtlCode,
      label: 'RTL specimen view',
    ),
    ShowcaseSection(
      id: 'composition',
      title: 'Composed with other primitives',
      description:
          'Not a shadcn section, badge is a leaf widget with no sub-parts of '
          'its own, but two real shapes badges are composed into elsewhere '
          'in this package are worth showing: a labelled metadata row, and a '
          'tag list. A third, ElSidebarMenuBadge\'s own precedent, shows how '
          'a real call site overrides spec/paddingX/minWidth together '
          'rather than adding a new widget.',
      specimen: _CompositionSpecimen(),
      code: _compositionCode,
      label: 'Composed with other primitives specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every ElBadge constructor parameter, its four static tokens, and '
          'all eleven ElBadgeVariant values: one table each.',
      child: _ApiReferenceContent(),
      children: <DocsTocEntry>[
        DocsTocEntry(title: 'ElBadge', anchor: 'api-elbadge'),
        DocsTocEntry(
          title: 'ElBadge static helpers',
          anchor: 'api-elbadge-static',
        ),
        DocsTocEntry(title: 'ElBadgeVariant', anchor: 'api-elbadge-variant'),
      ],
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'ElBadge is a static, presentational StatelessWidget: it has no '
          'onPressed/enabled parameter, no GestureDetector, no FocusNode, and '
          'no async flag anywhere in its build method. Most rows genuinely '
          'do not apply here, so they are grouped into one row below with '
          'the reason, rather than invented.',
      child: const DocsStateMatrix(facts: _stateFacts),
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
            value: badgeDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'none yet',
            description:
                'No dedicated unit test exists for badge.dart in the '
                'package test suite as of this page.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/badge_test.dart',
            description:
                'Covers this page: the API table, a live specimen of every '
                'variant, and ink distinguishability across both themes.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/badge/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class BadgeDocPage extends StatelessWidget {
  const BadgeDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: badgeDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / BASE',
      title: badgeDoc.title,
      description: badgeDoc.description,
    ),
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Components'),
      ElBreadcrumbEntry.page('Badge'),
    ],
    toc: badgeDocSpec.toc,
    previous: const DocsPageLink(title: 'Avatar', route: '/components/avatar'),
    next: const DocsPageLink(
      title: 'Breadcrumb',
      route: '/components/breadcrumb',
    ),
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('badge-doc-article'),
      child: ComponentDocPage(spec: badgeDocSpec, header: false),
    ),
  );
}

/* ── Showcase specimens ─────────────────────────────────────────────────── */

class _PreviewSpecimen extends StatelessWidget {
  const _PreviewSpecimen();

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: el(3),
    runSpacing: el(3),
    crossAxisAlignment: WrapCrossAlignment.center,
    children: const <Widget>[
      ElBadge(label: 'New'),
      ElBadge(label: 'Draft', variant: ElBadgeVariant.secondary),
      ElBadge(label: 'Failed', variant: ElBadgeVariant.destructive),
      ElBadge(label: 'Outline', variant: ElBadgeVariant.outline),
    ],
  );
}

const String _previewCode =
    "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
    'Wrap(\n'
    '  spacing: 12,\n'
    '  runSpacing: 12,\n'
    '  children: [\n'
    "    ElBadge(label: 'New'),\n"
    "    ElBadge(label: 'Draft', variant: ElBadgeVariant.secondary),\n"
    "    ElBadge(label: 'Failed', variant: ElBadgeVariant.destructive),\n"
    "    ElBadge(label: 'Outline', variant: ElBadgeVariant.outline),\n"
    '  ],\n'
    ')';

/// One specimen of every [ElBadgeVariant], each wrapped in a [KeyedSubtree]
/// the docs test locates directly: it reads the resolved ink straight off
/// the rendered [ElText] rather than re-deriving `ElBadge`'s private colour
/// mapping.
class _VariantLabel {
  const _VariantLabel(this.variant, this.label);
  final ElBadgeVariant variant;
  final String label;
}

/// Realistic copy per variant: the same words the variant's own docstring
/// in `badge.dart` uses as its example call site, where one exists (`action`
/// → "New release", `premium` → "Featured").
const List<_VariantLabel> _variantSpecimens = <_VariantLabel>[
  _VariantLabel(ElBadgeVariant.primary, 'New'),
  _VariantLabel(ElBadgeVariant.secondary, 'Draft'),
  _VariantLabel(ElBadgeVariant.destructive, 'Failed'),
  _VariantLabel(ElBadgeVariant.outline, 'Outline'),
  _VariantLabel(ElBadgeVariant.ghost, 'Ghost'),
  _VariantLabel(ElBadgeVariant.link, 'Docs'),
  _VariantLabel(ElBadgeVariant.action, 'New release'),
  _VariantLabel(ElBadgeVariant.premium, 'Featured'),
  _VariantLabel(ElBadgeVariant.success, 'Active'),
  _VariantLabel(ElBadgeVariant.warning, 'Pending'),
  _VariantLabel(ElBadgeVariant.info, 'Beta'),
];

class _VariantsSpecimen extends StatelessWidget {
  const _VariantsSpecimen();

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: el(3),
    runSpacing: el(3),
    crossAxisAlignment: WrapCrossAlignment.center,
    children: <Widget>[
      for (final _VariantLabel spec in _variantSpecimens)
        KeyedSubtree(
          key: ValueKey<String>('badge-preview:${spec.variant.name}'),
          child: ElBadge(label: spec.label, variant: spec.variant),
        ),
    ],
  );
}

const String _variantsCode =
    "ElBadge(label: 'New') // primary, the constructor default\n"
    "ElBadge(label: 'Draft', variant: ElBadgeVariant.secondary)\n"
    "ElBadge(label: 'Failed', variant: ElBadgeVariant.destructive)\n"
    "ElBadge(label: 'Outline', variant: ElBadgeVariant.outline)\n"
    "ElBadge(label: 'Ghost', variant: ElBadgeVariant.ghost)\n"
    "ElBadge(label: 'Docs', variant: ElBadgeVariant.link)\n"
    "ElBadge(label: 'New release', variant: ElBadgeVariant.action)\n"
    "ElBadge(label: 'Featured', variant: ElBadgeVariant.premium)\n"
    "ElBadge(label: 'Active', variant: ElBadgeVariant.success)\n"
    "ElBadge(label: 'Pending', variant: ElBadgeVariant.warning)\n"
    "ElBadge(label: 'Beta', variant: ElBadgeVariant.info)";

class _WithIconSpecimen extends StatelessWidget {
  const _WithIconSpecimen();

  @override
  Widget build(BuildContext context) => const ElBadge(
    label: 'Featured',
    variant: ElBadgeVariant.premium,
    glyph: ElIcon(
      ElIconGlyph.star,
      size: ElIconSize.xs,
      tone: ElIconTone.inherit,
    ),
  );
}

const String _withIconCode =
    'ElBadge(\n'
    "  label: 'Featured',\n"
    '  variant: ElBadgeVariant.premium,\n'
    '  glyph: const ElIcon(\n'
    '    ElIconGlyph.star,\n'
    '    size: ElIconSize.xs,\n'
    '    tone: ElIconTone.inherit,\n'
    '  ),\n'
    ')';

class _WithSpinnerSpecimen extends StatelessWidget {
  const _WithSpinnerSpecimen();

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: el(3),
    runSpacing: el(3),
    crossAxisAlignment: WrapCrossAlignment.center,
    children: <Widget>[
      ElBadge(
        label: 'Deleting',
        variant: ElBadgeVariant.destructive,
        glyph: ElSpinner(size: ElBadge.glyphSize),
      ),
      ElBadge(
        label: 'Generating',
        variant: ElBadgeVariant.action,
        glyph: ElSpinner(size: ElBadge.glyphSize),
      ),
    ],
  );
}

const String _withSpinnerCode =
    'ElBadge(\n'
    "  label: 'Deleting',\n"
    '  variant: ElBadgeVariant.destructive,\n'
    '  glyph: ElSpinner(size: ElBadge.glyphSize),\n'
    ')\n'
    '\n'
    'ElBadge(\n'
    "  label: 'Generating',\n"
    '  variant: ElBadgeVariant.action,\n'
    '  glyph: ElSpinner(size: ElBadge.glyphSize),\n'
    ')';

class _RtlSpecimen extends StatelessWidget {
  const _RtlSpecimen();

  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: TextDirection.rtl,
    child: Wrap(
      spacing: el(3),
      runSpacing: el(3),
      crossAxisAlignment: WrapCrossAlignment.center,
      children: const <Widget>[
        ElBadge(label: 'جديد'),
        ElBadge(label: 'مسودة', variant: ElBadgeVariant.secondary),
        ElBadge(label: 'فشل', variant: ElBadgeVariant.destructive),
      ],
    ),
  );
}

const String _rtlCode =
    'Directionality(\n'
    '  textDirection: TextDirection.rtl,\n'
    '  child: Wrap(\n'
    '    spacing: 12,\n'
    '    runSpacing: 12,\n'
    '    children: [\n'
    "      ElBadge(label: 'جديد'),\n"
    "      ElBadge(label: 'مسودة', variant: ElBadgeVariant.secondary),\n"
    "      ElBadge(label: 'فشل', variant: ElBadgeVariant.destructive),\n"
    '    ],\n'
    '  ),\n'
    ')';

class _CompositionSpecimen extends StatelessWidget {
  const _CompositionSpecimen();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ElText('Workspace plan', ElType.section),
          SizedBox(width: el(2)),
          const ElBadge(label: 'Pro', variant: ElBadgeVariant.premium),
        ],
      ),
      SizedBox(height: el(4)),
      Wrap(
        spacing: el(2),
        runSpacing: el(2),
        children: const <Widget>[
          ElBadge(label: 'Design', variant: ElBadgeVariant.outline),
          ElBadge(label: 'Flutter', variant: ElBadgeVariant.outline),
          ElBadge(label: 'Tokens', variant: ElBadgeVariant.outline),
        ],
      ),
    ],
  );
}

const String _compositionCode =
    '// A labelled metadata row\n'
    'Row(\n'
    '  children: [\n'
    "    ElText('Workspace plan', ElType.section),\n"
    '    SizedBox(width: 8),\n'
    "    ElBadge(label: 'Pro', variant: ElBadgeVariant.premium),\n"
    '  ],\n'
    ')\n'
    '\n'
    '// A tag list\n'
    'Wrap(\n'
    '  spacing: 8,\n'
    '  runSpacing: 8,\n'
    '  children: [\n'
    "    ElBadge(label: 'Design', variant: ElBadgeVariant.outline),\n"
    "    ElBadge(label: 'Flutter', variant: ElBadgeVariant.outline),\n"
    "    ElBadge(label: 'Tokens', variant: ElBadgeVariant.outline),\n"
    '  ],\n'
    ')\n'
    '\n'
    '// The ElSidebarMenuBadge precedent: lib/src/components/sidebar.dart\n'
    '// composes ElBadge directly, overriding spec/paddingX/minWidth exactly\n'
    '// as documented above, rather than adding a new widget:\n'
    'ElBadge(\n'
    '  label: count,\n'
    '  variant: ElBadgeVariant.secondary,\n'
    '  spec: ElComponentType.sidebarMenuBadge,\n'
    '  paddingX: el(1.5),\n'
    '  minWidth: el(5),\n'
    ')';

/* ── Disclosure content ─────────────────────────────────────────────────── */

const String _usageCode = '''
// The smallest correct call: variant defaults to primary.
ElBadge(label: 'New')

// A semantic variant with a leading glyph, matching the data page's
// "Featured" chips (Icon size="xs" tone="inherit" in the reference).
ElBadge(
  label: 'Featured',
  variant: ElBadgeVariant.premium,
  glyph: const ElIcon(
    ElIconGlyph.star,
    size: ElIconSize.xs,
    tone: ElIconTone.inherit,
  ),
)

// An unfilled variant for a low-emphasis tag.
ElBadge(label: 'Draft', variant: ElBadgeVariant.outline)''';

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsAnchor(
        id: 'api-elbadge',
        child: DocsApiTable(title: 'ElBadge', facts: _badgeApiFacts),
      ),
      SizedBox(height: el(6)),
      const DocsAnchor(
        id: 'api-elbadge-static',
        child: DocsApiTable(
          title: 'ElBadge static helpers',
          facts: _badgeStaticFacts,
        ),
      ),
      SizedBox(height: el(6)),
      const DocsAnchor(
        id: 'api-elbadge-variant',
        child: DocsApiTable(title: 'ElBadgeVariant', facts: _variantFacts),
      ),
    ],
  );
}

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'Semantic role: none of its own, ElBadge builds no Semantics node. '
            'The label reaches assistive tech as ordinary static text, not as '
            'a button, link, or image.',
        'Required labels: none beyond `label` itself: there is no separate '
            'semanticLabel or tooltip parameter.',
        'Keyboard interactions: none. ElBadge is never in the tab order — '
            'see Keyboard below.',
        'Focus behavior: never receives focus: no Focus widget or FocusNode '
            'exists in its build method.',
        'Touch target: not applicable: a badge is not tappable, so it makes '
            'no target-size guarantee. A caller that wraps one to be tappable '
            '(e.g. inside a GestureDetector) owns that guarantee, not '
            'ElBadge.',
        'Non-colour signals: the label word itself is the signal: every '
            'variant reads correctly from its text alone ("Failed", "Active", '
            '"Pending"), and outline/ghost/link additionally drop the fill '
            'entirely so colour is never the only cue.',
        'Error wiring: none: a badge is not a form control and cannot '
            'associate with a field\'s error text; use ElInput\'s own invalid '
            'state for that.',
        'Screen-reader announcements: none: there is no liveRegion. A badge '
            'whose label changes across a rebuild (e.g. "Pending" → "Active") '
            'is not announced as a change; wire that explicitly at the call '
            'site if it matters.',
        'Known platform differences: none observed: the same widget tree '
            'renders on every target platform; nothing in badge.dart branches '
            'on platform.',
      ]);
}

/// New: the design calls for this page to carry its own Keyboard section.
/// Every claim here is read off `lib/src/components/badge.dart` directly,
/// not inferred: `ElBadge` is a `StatelessWidget` and its `build` method
/// contains no `Focus`, no `FocusNode`, and no `Focus.onKeyEvent`.
class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'No keyboard interactions: badge.dart wires no Focus, no FocusNode '
            'and no Focus.onKeyEvent anywhere in ElBadge.build. There is no '
            'key this control listens for.',
        'Tab order: never a stop. With no Focus widget in the tree, a badge '
            'is skipped entirely by Tab and Shift+Tab traversal.',
        'No custom ordering: nothing to order, for the same reason.',
        'A caller that needs a badge to respond to a key press wraps it in '
            'something that does — an ElButton, or a bespoke Focus/'
            'GestureDetector pairing of its own: ElBadge contributes no '
            'keyboard behaviour to build on.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'No responsive branching, ElBadge reads no breakpoint from '
            'BuildContext and renders identically at 390px and 1440px; only '
            'the label string can change the width it occupies.',
        'Height is fixed at 20px (ElBadge.height) everywhere; width is '
            'intrinsic to the label plus 16px of horizontal padding unless '
            'paddingX/minWidth override it.',
        'Long labels are not truncated by ElBadge itself: overflow-hidden '
            'clips the 16px line box to the 14px content box vertically, but '
            'there is no horizontal ellipsis. A very long label simply widens '
            'the chip; constrain the surrounding layout if the label is '
            'untrusted length.',
        'Platform parity: Android, iOS, Web, macOS, Windows, and Linux all '
            'render the same widget tree.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      _bullets(ElTheme.of(context), <String>[
        'File: lib/src/components/badge.dart (one file, no companion parts).',
        'Foundation imports: foundation/colors.dart (elHsl, ElPalette), '
            'foundation/shadows.dart (ElShadows.chip, ElShadows.btnValue), '
            'foundation/spacing.dart (el()), foundation/theme.dart '
            '(ElThemeData), foundation/typography.dart (ElComponentType).',
        'Effect import: effects/machine_surface.dart (ElMachineSurface), '
            'paints the fill, border, and shadow together for every filled '
            'variant.',
        'Scope import: theme_scope.dart (ElText, ElTheme).',
        'Assets: none. Fonts: none beyond the system type scale every ElText '
            'call already depends on. Shaders: none: the ramp-chip highlight '
            'is a LinearGradient, not a fragment shader.',
      ]),
      SizedBox(height: el(2)),
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: ElWidths.prose),
        child: DocsLinkRow(
          links: <DocsLink>[
            DocsLink(label: 'Button', route: '/components/button'),
            DocsLink(label: 'Icon', route: '/components/icon'),
            DocsLink(label: 'Kbd', route: '/components/kbd'),
            DocsLink(label: 'Sidebar', route: '/components/sidebar'),
          ],
        ),
      ),
    ],
  );
}

class _ThemingContent extends StatelessWidget {
  const _ThemingContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'Every colour ElBadge paints comes from the live theme: '
            'ElTheme.of(context).primary/secondary/destructive for the base '
            'three fills, ElPalette.action/value/success/warning/info for the '
            'six semantic tints, and the matching *Ink getters for text. '
            'Flipping ElThemeController between light and dark re-resolves '
            'every one: nothing is cached.',
        'The ramp-chip highlight is NOT theme-aware: it is a fixed white-to-'
            'black alpha gradient (18% white top, 5% white mid, 14% black '
            'bottom) painted as its own layer over the fill in both themes, '
            'a deliberate port of the reference\'s own utility, not a token '
            'gap.',
        'The two shadow specs, ElShadows.chip and, for premium only, '
            'ElShadows.btnValue: are the badge entries in the machine-shadow '
            'family. Overriding them is not exposed as a ElBadge parameter.',
        'ElBadge declares no colour-override parameter of its own (no fill '
            'or color argument): every fill is variant-derived. A call site '
            'that needs a colour outside the eleven variants is a signal to '
            'add a new ElBadgeVariant, not to bypass the token system.',
      ]);
}

Widget _bullets(ElThemeData theme, List<String> lines) => ConstrainedBox(
  constraints: const BoxConstraints(maxWidth: ElWidths.prose),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      for (final String line in lines) ...<Widget>[
        ElText('•  $line', ElType.small, color: theme.mutedForeground),
        SizedBox(height: el(2)),
      ],
    ],
  ),
);

const List<DocsApiFact> _badgeApiFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'label',
    type: 'String',
    description: 'Required. The chip\'s text content.',
  ),
  DocsApiFact(
    name: 'variant',
    type: 'ElBadgeVariant',
    description:
        'Defaults to primary. Selects the fill, ink, and shadow: see '
        'ElBadgeVariant below.',
  ),
  DocsApiFact(
    name: 'spec',
    type: 'ElTypeSpec?',
    description:
        'Overrides ElComponentType.badgeLabel, the resolved type spec the '
        'label renders with. ElSidebarMenuBadge passes '
        'ElComponentType.sidebarMenuBadge here.',
  ),
  DocsApiFact(
    name: 'paddingX',
    type: 'double?',
    description:
        'Overrides the 8px horizontal padding on each side '
        '(ElBadge.horizontalPadding).',
  ),
  DocsApiFact(
    name: 'minWidth',
    type: 'double?',
    description:
        'A minimum-width floor, so e.g. a one-digit count reads as a '
        'circle rather than a sliver. Null means no floor.',
  ),
  DocsApiFact(
    name: 'glyph',
    type: 'Widget?',
    description:
        'A leading icon, forced to 12px square regardless of its own '
        'size, with a 4px gap before the label.',
  ),
];

const List<DocsApiFact> _badgeStaticFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'ElBadge.height',
    type: 'static double',
    description: 'The hard 20px border-box height every badge renders at.',
  ),
  DocsApiFact(
    name: 'ElBadge.horizontalPadding',
    type: 'static double',
    description: 'The default paddingX, 8px.',
  ),
  DocsApiFact(
    name: 'ElBadge.glyphSize',
    type: 'static double',
    description: 'The forced glyph square, 12px.',
  ),
  DocsApiFact(
    name: 'ElBadge.glyphGap',
    type: 'static double',
    description: 'The gap between glyph and label, 4px.',
  ),
];

const List<DocsApiFact> _variantFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'primary',
    type: 'filled',
    description:
        'Fills with theme.primary. ramp-chip highlight + shadow-chip. The '
        'constructor default.',
  ),
  DocsApiFact(
    name: 'secondary',
    type: 'filled',
    description: 'Fills with theme.secondary. ramp-chip + shadow-chip.',
  ),
  DocsApiFact(
    name: 'destructive',
    type: 'filled',
    description:
        'A 12%-alpha tint of theme.destructive. ramp-chip + shadow-chip.',
  ),
  DocsApiFact(
    name: 'outline',
    type: 'unfilled',
    description:
        'No fill, no ramp, no shadow. A 1px border in theme.input; ink is '
        'theme.mutedForeground.',
  ),
  DocsApiFact(
    name: 'ghost',
    type: 'unfilled',
    description:
        'No fill, no border, no ramp, no shadow. Ink is '
        'theme.mutedForeground: same ink as outline.',
  ),
  DocsApiFact(
    name: 'link',
    type: 'unfilled',
    description:
        'No fill, no ramp, no shadow. Ink is theme.actionInk, coloured '
        'text in a pill-shaped box.',
  ),
  DocsApiFact(
    name: 'action',
    type: 'filled',
    description:
        'Added for this system (not in the original shadcn set). A '
        '12%-alpha tint of ElPalette.action; ink is theme.actionInk, same '
        'ink as link. ramp-chip + shadow-chip. The media dialog\'s "New '
        'release".',
  ),
  DocsApiFact(
    name: 'premium',
    type: 'filled',
    description:
        'A 12%-alpha tint of ElPalette.value; ink is theme.valueInk. The '
        'one variant using shadow-btn-value instead of shadow-chip: used '
        'for Featured, Limited, and anything carrying value.',
  ),
  DocsApiFact(
    name: 'success',
    type: 'filled',
    description:
        'A 12%-alpha tint of ElPalette.success; ink is theme.successInk. '
        'ramp-chip + shadow-chip.',
  ),
  DocsApiFact(
    name: 'warning',
    type: 'filled',
    description:
        'A 12%-alpha tint of ElPalette.warning; ink is theme.warningInk. '
        'ramp-chip + shadow-chip.',
  ),
  DocsApiFact(
    name: 'info',
    type: 'filled',
    description:
        'A 12%-alpha tint of ElPalette.info; ink is theme.infoInk. '
        'ramp-chip + shadow-chip.',
  ),
];

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Rest',
    treatment:
        'Filled variants paint their fill under ramp-chip (a '
        'light-from-above gradient) and shadow-chip (shadow-btn-value for '
        'premium). Unfilled variants (outline, ghost, link) paint no ramp '
        'and no shadow.',
    userSignal: 'The resting paint is the only paint: see below.',
  ),
  DocsStateFact(
    state: 'Error / Success',
    treatment:
        'Not a live transition on one badge: choose ElBadgeVariant.'
        'destructive or .success at construction time instead. See '
        'Variants.',
    userSignal: 'A different badge instance, not a state change.',
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment:
        'N/A: no AnimationController and no motion token appears in '
        'ElBadge.build.',
    userSignal: 'Nothing animates, so nothing needs to still.',
  ),
  DocsStateFact(
    state:
        'Hover / Focus-visible / Pressed / Selected / Loading / Empty / '
        'Disabled',
    treatment:
        'N/A, ElBadge is a StatelessWidget with no gesture, focus, or '
        'async wiring; there is no onPressed/enabled parameter to hold any '
        'of these.',
    userSignal:
        'Wrap in ElButton (or your own GestureDetector) at the call site '
        'if the chip must respond to input, ElBadge intentionally does '
        'not.',
  ),
];
