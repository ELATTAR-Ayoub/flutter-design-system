/// Public documentation page for the `badge` component.
///
/// Mirrors `button_card_pages.dart`'s use of the Phase C docs primitives
/// (`DocsLayout`, `DocsCodeExample`, `DocsApiTable`, `DocsStateMatrix`,
/// `DocsInstallFacts`) and `dialog_page.dart`'s use of `kit.dart`'s
/// `ElSection` for titled, anchor-registered content blocks, `badge` needs
/// enough distinct sections (IA §9.1's eighteen) that `ElSection`'s built-in
/// heading and anchor registration earns its keep over hand-rolling a title
/// plus a `docsAnchorKey` wrap per block.
///
/// `badge` ships in the registry (`registry/components/badge.json`
/// does not exist): every install-facing panel below says so honestly
/// rather than presenting a CLI command that would fail.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/docs_code.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../kit.dart';
import 'meta.dart';

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
    sidebar: _sidebar,
    toc: const <DocsTocEntry>[
      DocsTocEntry(title: 'Installation', anchor: 'install'),
      DocsTocEntry(title: 'Usage', anchor: 'usage'),
      DocsTocEntry(title: 'Variants', anchor: 'variants'),
      DocsTocEntry(title: 'With icon', anchor: 'with-icon'),
      DocsTocEntry(title: 'With spinner', anchor: 'with-spinner'),
      DocsTocEntry(title: 'RTL', anchor: 'rtl'),
      DocsTocEntry(
        title: 'Composed with other primitives',
        anchor: 'composition',
      ),
      DocsTocEntry(title: 'API Reference', anchor: 'api'),
      DocsTocEntry(title: 'States', anchor: 'states'),
      DocsTocEntry(title: 'Accessibility', anchor: 'accessibility'),
      DocsTocEntry(title: 'Responsive', anchor: 'responsive'),
      DocsTocEntry(title: 'Dependencies', anchor: 'dependencies'),
      DocsTocEntry(title: 'Theming', anchor: 'theming'),
      DocsTocEntry(title: 'Source', anchor: 'source'),
    ],
    previous: const DocsPageLink(title: 'Avatar', route: '/components/avatar'),
    next: const DocsPageLink(
      title: 'Breadcrumb',
      route: '/components/breadcrumb',
    ),
    onNavigate: onNavigate,
    child: const _BadgeArticle(),
  );
}

/// The Wave 1 "base primitives" group this page belongs to (IA §7.3),
/// listed in the plan's own order. Routes other workers are producing this
/// same wave, not routes this page can verify are wired yet: the supervisor
/// aggregates the real sidebar in `catalog.dart` and `site_routes.dart`.
const List<DocsSidebarEntry> _sidebar = <DocsSidebarEntry>[
  DocsSidebarEntry(title: 'Accordion', route: '/components/accordion'),
  DocsSidebarEntry(title: 'Alert', route: '/components/alert'),
  DocsSidebarEntry(title: 'Avatar', route: '/components/avatar'),
  DocsSidebarEntry(title: 'Badge', route: '/components/badge', selected: true),
  DocsSidebarEntry(title: 'Breadcrumb', route: '/components/breadcrumb'),
  DocsSidebarEntry(title: 'Checkbox', route: '/components/checkbox'),
  DocsSidebarEntry(title: 'Collapsible', route: '/components/collapsible'),
  DocsSidebarEntry(title: 'Empty', route: '/components/empty'),
  DocsSidebarEntry(title: 'Kbd', route: '/components/kbd'),
  DocsSidebarEntry(title: 'Progress', route: '/components/progress'),
  DocsSidebarEntry(title: 'Separator', route: '/components/separator'),
  DocsSidebarEntry(title: 'Skeleton', route: '/components/skeleton'),
  DocsSidebarEntry(title: 'Switch', route: '/components/switch'),
  DocsSidebarEntry(title: 'Toggle', route: '/components/toggle'),
  DocsSidebarEntry(title: 'Tooltip', route: '/components/tooltip'),
];

/// One specimen of every [ElBadgeVariant], each wrapped in a
/// [KeyedSubtree] the docs test locates directly: see the test file's own
/// note on why: it reads the resolved ink straight off the rendered
/// [ElText] rather than re-deriving `ElBadge`'s private colour mapping.
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

class _BadgeArticle extends StatelessWidget {
  const _BadgeArticle();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      key: const ValueKey<String>('badge-doc-article'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _preview(theme),
        _install(),
        _usage(),
        _variants(),
        _withIcon(),
        _withSpinner(),
        _rtl(),
        _composition(),
        _api(),
        _states(),
        _accessibility(theme),
        _responsive(theme),
        _dependencies(theme),
        _theming(theme),
        _source(),
      ],
    );
  }

  /// The live-demo slot shadcn's own badge page renders before its first
  /// heading: this port's `ElSection` always carries a heading, so `Preview`
  /// stands in for it, carrying the component's own framing prose (what it
  /// is, when to reach for it instead of `ElKbd` or `ElButton`) ahead of a
  /// small representative demo. The full eleven-variant grid lives under
  /// `Variants` below, mirroring shadcn's own split between its top demo
  /// (four badges) and its later `Variants` section (all five).
  Widget _preview(ElThemeData theme) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: ElWidths.prose),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ElText(
              'ElBadge renders a small pill: a fixed 20px-tall, '
              'label-sized chip used to mark a status, a count, or a '
              'category: never an action. Eleven variants map to six '
              'semantic fills (success, warning, info, destructive, '
              'action, premium) plus primary and secondary, and three '
              'unfilled treatments (outline, ghost, link) for contexts '
              'that want restraint.',
              ElType.body,
            ),
            SizedBox(height: el(4)),
            ElText(
              'Reach for it over ElKbd when the content is a status word '
              'or a count rather than a literal keystroke: kbd renders a '
              'monospace key cap, badge renders a semantic chip. Reach '
              'for it over a plain label when the value needs its own '
              'filled, bordered, or coloured surface to separate it from '
              'surrounding prose. And reach for ElButton instead the '
              'moment the chip needs to respond to a tap: ElBadge '
              'carries no GestureDetector, no FocusNode, and no pressed '
              'or hover state by design: its own source docstring puts '
              'it plainly: "a badge is a label, not a button, and it '
              'must not invite a click."',
              ElType.body,
            ),
            SizedBox(height: el(4)),
            ElText(
              'Status: stable primitive, installable through the CLI '
              '(see Installation). Platforms: Android, iOS, Web, macOS, '
              'Windows, Linux, the same six every widget in this package '
              'targets.',
              ElType.small,
              color: theme.mutedForeground,
            ),
          ],
        ),
      ),
      SizedBox(height: el(6)),
      DocsCodeExample(
        title: 'Badge specimens',
        manualFiles: const <DocsCodeFile>[
          DocsCodeFile(
            path: 'lib/components/ui/badge.dart',
            code:
                "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
                '// Install with: elattar add badge',
          ),
        ],
        preview: Wrap(
          spacing: el(3),
          runSpacing: el(3),
          crossAxisAlignment: WrapCrossAlignment.center,
          children: const <Widget>[
            ElBadge(label: 'New'),
            ElBadge(label: 'Draft', variant: ElBadgeVariant.secondary),
            ElBadge(label: 'Failed', variant: ElBadgeVariant.destructive),
            ElBadge(label: 'Outline', variant: ElBadgeVariant.outline),
          ],
        ),
      ),
    ],
  );

  Widget _install() => ElSection(
    id: 'install',
    title: 'Installation',
    description:
        'badge ships in the registry, so `elattar add badge` is not '
        'available: install by copying the source file manually.',
    child: DocsInstallFacts(
      title: 'Installation facts',
      facts: <DocsInstallFact>[
        const DocsInstallFact(
          label: 'Registry item',
          value: 'registry/components/badge.json',
          description:
              'No registry/components/badge.json exists. This is a '
              'source-only component today.',
        ),
        const DocsInstallFact(
          label: 'Destination',
          value: 'lib/components/ui/badge.dart',
          description: 'Where a manual copy of the source belongs.',
        ),
        const DocsInstallFact(
          label: 'Foundation',
          value: 'source only',
          description: 'No package-backed alternative is offered yet.',
        ),
        const DocsInstallFact(
          label: 'Dependencies',
          value: 'source-foundation, machine-surface',
          description:
              'What the shipped manifest resolves: colors, '
              'shadows, spacing, theme, typography, and the '
              'ElMachineSurface effect. None of this is resolved '
              'automatically today; copy the imports by hand.',
        ),
        const DocsInstallFact(
          label: 'Assets',
          value: 'none',
          description: 'No images, icon fonts, or binary assets.',
        ),
        const DocsInstallFact(
          label: 'Shaders',
          value: 'none',
          description:
              'The ramp-chip highlight is a LinearGradient, not a '
              'fragment shader.',
        ),
        DocsInstallFact(
          label: 'Platforms',
          value: 'Android, iOS, Web, macOS, Windows, Linux',
          description: 'No platform-conditional code in badge.dart.',
        ),
        const DocsInstallFact(
          label: 'Verified',
          value: 'docs specimen only',
          description:
              'This page\'s live preview and example/test/components_docs/'
              'badge_test.dart. No dedicated package-level unit test and no '
              'registry fixture install exist yet: there is nothing to '
              'install.',
        ),
      ],
    ),
  );

  Widget _usage() => ElSection(
    id: 'usage',
    title: 'Usage',
    description: 'The smallest correct call, then the shapes seen above.',
    child: ElPanel(
      label: 'DART',
      note: 'COMPOSE',
      child: DocsSelectableCodeBlock(code: _usageCode),
    ),
  );

  Widget _api() => ElSection(
    id: 'api',
    title: 'API Reference',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const DocsApiTable(
          title: 'Badge properties',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'label',
              type: 'String',
              description: 'Required. The chip\'s text content.',
            ),
            DocsApiFact(
              name: 'variant',
              type: 'ElBadgeVariant',
              description:
                  'Defaults to primary. Selects the fill, ink, and '
                  'shadow: see Variants.',
            ),
            DocsApiFact(
              name: 'spec',
              type: 'ElTypeSpec?',
              description:
                  'Overrides ElComponentType.badgeLabel, the resolved type '
                  'spec the label renders with. ElSidebarMenuBadge passes '
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
                  'A minimum-width floor, so e.g. a one-digit count reads '
                  'as a circle rather than a sliver. Null means no floor.',
            ),
            DocsApiFact(
              name: 'glyph',
              type: 'Widget?',
              description:
                  'A leading icon, forced to 12px square regardless of its '
                  'own size, with a 4px gap before the label.',
            ),
          ],
        ),
        SizedBox(height: el(6)),
        const DocsApiTable(
          title: 'Static tokens',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'ElBadge.height',
              type: 'static double',
              description:
                  'The hard 20px border-box height every badge renders at.',
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
          ],
        ),
      ],
    ),
  );

  Widget _variants() => ElSection(
    id: 'variants',
    title: 'Variants',
    description:
        'All eleven ElBadgeVariant values. Badge has no size axis: every '
        'chip is the same hard 20px border box (ElBadge.height); content '
        'never grows it. Use paddingX or minWidth to adjust footprint '
        'instead of a size enum.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ElPanel(
          label: 'PREVIEW',
          child: Wrap(
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
          ),
        ),
        SizedBox(height: el(6)),
        const DocsApiTable(
          title: 'ElBadgeVariant',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'primary',
              type: 'filled',
              description:
                  'Fills with theme.primary. ramp-chip highlight + shadow-chip. '
                  'The constructor default.',
            ),
            DocsApiFact(
              name: 'secondary',
              type: 'filled',
              description:
                  'Fills with theme.secondary. ramp-chip + shadow-chip.',
            ),
            DocsApiFact(
              name: 'destructive',
              type: 'filled',
              description:
                  'A 12%-alpha tint of theme.destructive. ramp-chip + '
                  'shadow-chip.',
            ),
            DocsApiFact(
              name: 'outline',
              type: 'unfilled',
              description:
                  'No fill, no ramp, no shadow. A 1px border in theme.input; '
                  'ink is theme.mutedForeground.',
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
                  'No fill, no ramp, no shadow. Ink is theme.actionInk, '
                  'coloured text in a pill-shaped box.',
            ),
            DocsApiFact(
              name: 'action',
              type: 'filled',
              description:
                  'Added for this system (not in the original shadcn set). A '
                  '12%-alpha tint of ElPalette.action; ink is theme.actionInk, '
                  'same ink as link. ramp-chip + shadow-chip. The media '
                  'dialog\'s "New release".',
            ),
            DocsApiFact(
              name: 'premium',
              type: 'filled',
              description:
                  'A 12%-alpha tint of ElPalette.value; ink is theme.valueInk. '
                  'The one variant using shadow-btn-value instead of '
                  'shadow-chip: used for Featured, Limited, and anything '
                  'carrying value.',
            ),
            DocsApiFact(
              name: 'success',
              type: 'filled',
              description:
                  'A 12%-alpha tint of ElPalette.success; ink is '
                  'theme.successInk. ramp-chip + shadow-chip.',
            ),
            DocsApiFact(
              name: 'warning',
              type: 'filled',
              description:
                  'A 12%-alpha tint of ElPalette.warning; ink is '
                  'theme.warningInk. ramp-chip + shadow-chip.',
            ),
            DocsApiFact(
              name: 'info',
              type: 'filled',
              description:
                  'A 12%-alpha tint of ElPalette.info; ink is theme.infoInk. '
                  'ramp-chip + shadow-chip.',
            ),
          ],
        ),
      ],
    ),
  );

  Widget _withIcon() => ElSection(
    id: 'with-icon',
    title: 'With icon',
    description:
        'A leading glyph, forced to 12px square with a 4px gap before the '
        'label regardless of the icon\'s own size: the data page\'s '
        '"Featured" chips.',
    child: ElPanel(
      label: 'PREVIEW',
      child: const ElBadge(
        label: 'Featured',
        variant: ElBadgeVariant.premium,
        glyph: ElIcon(
          ElIconGlyph.star,
          size: ElIconSize.xs,
          tone: ElIconTone.inherit,
        ),
      ),
    ),
  );

  Widget _withSpinner() => ElSection(
    id: 'with-spinner',
    title: 'With spinner',
    description:
        'The glyph slot takes any widget, including ElSpinner: sized down '
        'to ElBadge.glyphSize (12px) so it fills the same square an icon '
        'would.',
    child: ElPanel(
      label: 'PREVIEW',
      child: Wrap(
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
      ),
    ),
  );

  Widget _rtl() => ElSection(
    id: 'rtl',
    title: 'RTL',
    description:
        'ElBadge paints no direction-specific layout of its own: it sizes '
        'to its label and centres its content either way, the same '
        'composition read right-to-left under a Directionality.',
    child: ElPanel(
      label: 'PREVIEW',
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Wrap(
          spacing: el(3),
          runSpacing: el(3),
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            ElBadge(label: 'جديد'),
            ElBadge(label: 'مسودة', variant: ElBadgeVariant.secondary),
            ElBadge(label: 'فشل', variant: ElBadgeVariant.destructive),
          ],
        ),
      ),
    ),
  );

  Widget _states() => ElSection(
    id: 'states',
    title: 'States and feedback',
    description:
        'ElBadge is a static, presentational StatelessWidget: it has no '
        'onPressed/enabled parameter, no GestureDetector, no FocusNode, and '
        'no async flag anywhere in its build method. Most of IA §9.7\'s rows '
        'genuinely do not apply here, so they are grouped into one row below '
        'with the reason, rather than invented.',
    child: const DocsStateMatrix(
      facts: <DocsStateFact>[
        DocsStateFact(
          state: 'Rest',
          treatment:
              'Filled variants paint their fill under ramp-chip (a '
              'light-from-above gradient) and shadow-chip (shadow-btn-value '
              'for premium). Unfilled variants (outline, ghost, link) paint '
              'no ramp and no shadow.',
          userSignal: 'The resting paint is the only paint: see below.',
        ),
        DocsStateFact(
          state: 'Error / Success',
          treatment:
              'Not a live transition on one badge: choose '
              'ElBadgeVariant.destructive or .success at construction time '
              'instead. See Variants.',
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
              'Hover / Focus-visible / Pressed / Selected / Loading / '
              'Empty / Disabled',
          treatment:
              'N/A, ElBadge is a StatelessWidget with no gesture, focus, '
              'or async wiring; there is no onPressed/enabled parameter to '
              'hold any of these.',
          userSignal:
              'Wrap in ElButton (or your own GestureDetector) at the call '
              'site if the chip must respond to input, ElBadge '
              'intentionally does not.',
        ),
      ],
    ),
  );

  Widget _accessibility(ElThemeData theme) => ElSection(
    id: 'accessibility',
    title: 'Accessibility and keyboard behavior',
    child: _bullets(theme, <String>[
      'Semantic role: none of its own, ElBadge builds no Semantics node. '
          'The label reaches assistive tech as ordinary static text, not as '
          'a button, link, or image.',
      'Required labels: none beyond `label` itself: there is no separate '
          'semanticLabel or tooltip parameter.',
      'Keyboard interactions: none. ElBadge is never in the tab order.',
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
    ]),
  );

  Widget _responsive(ElThemeData theme) => ElSection(
    id: 'responsive',
    title: 'Responsive and platform behavior',
    child: _bullets(theme, <String>[
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
    ]),
  );

  Widget _dependencies(ElThemeData theme) => ElSection(
    id: 'dependencies',
    title: 'Dependencies, files, and assets',
    child: _bullets(theme, <String>[
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
  );

  Widget _composition() => ElSection(
    id: 'composition',
    title: 'Composed with other primitives',
    description:
        'Not a shadcn section, badge is a leaf widget with no sub-parts of '
        'its own, but two real shapes badges are composed into elsewhere '
        'in this package are worth showing: a labelled metadata row, and a '
        'tag list.',
    child: DocsCodeExample(
      title: 'Composed with other primitives',
      preview: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
      ),
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(
          path: 'sidebar_menu_badge_precedent.dart',
          title: 'The ElSidebarMenuBadge precedent',
          description:
              'lib/src/components/sidebar.dart composes ElBadge directly, '
              'overriding spec/paddingX/minWidth exactly as documented '
              'above, rather than adding a new widget:',
          code: '''ElBadge(
  label: count,
  variant: ElBadgeVariant.secondary,
  spec: ElComponentType.sidebarMenuBadge,
  paddingX: el(1.5),
  minWidth: el(5),
)''',
        ),
      ],
    ),
  );

  Widget _theming(ElThemeData theme) => ElSection(
    id: 'theming',
    title: 'Theming notes',
    child: _bullets(theme, <String>[
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
    ]),
  );

  Widget _source() => ElSection(
    id: 'source',
    title: 'Source, tests, and docs',
    child: DocsInstallFacts(
      title: 'Reference',
      facts: <DocsInstallFact>[
        DocsInstallFact(
          label: 'Source',
          value: badgeDoc.sourcePath,
          description:
              'Authoritative implementation: the truth this page '
              'was written from.',
        ),
        const DocsInstallFact(
          label: 'Package tests',
          value: 'none yet',
          description:
              'No dedicated unit test exists for badge.dart in the package '
              'test suite as of this page.',
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
  );
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
