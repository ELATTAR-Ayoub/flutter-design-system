/// Public documentation page for the `badge` component.
///
/// Mirrors `button_card_pages.dart`'s use of the Phase C docs primitives
/// (`DocsLayout`, `DocsCodeExample`, `DocsApiTable`, `DocsStateMatrix`,
/// `DocsInstallFacts`) and `dialog_page.dart`'s use of `kit.dart`'s
/// `DsSection` for titled, anchor-registered content blocks — `badge` needs
/// enough distinct sections (IA §9.1's eighteen) that `DsSection`'s built-in
/// heading and anchor registration earns its keep over hand-rolling a title
/// plus a `docsAnchorKey` wrap per block.
///
/// `badge` has no registry manifest yet (`registry/components/badge.json`
/// does not exist) — every install-facing panel below says so honestly
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
    breadcrumbs: const <DsBreadcrumbEntry>[
      DsBreadcrumbEntry.link('Components'),
      DsBreadcrumbEntry.page('Badge'),
    ],
    sidebar: _sidebar,
    toc: const <DocsTocEntry>[
      DocsTocEntry(title: 'Overview', anchor: 'overview'),
      DocsTocEntry(title: 'Preview', anchor: 'preview'),
      DocsTocEntry(title: 'Install', anchor: 'install'),
      DocsTocEntry(title: 'Usage', anchor: 'usage'),
      DocsTocEntry(title: 'API', anchor: 'api'),
      DocsTocEntry(title: 'Variants', anchor: 'variants'),
      DocsTocEntry(title: 'States', anchor: 'states'),
      DocsTocEntry(title: 'Accessibility', anchor: 'accessibility'),
      DocsTocEntry(title: 'Responsive', anchor: 'responsive'),
      DocsTocEntry(title: 'Dependencies', anchor: 'dependencies'),
      DocsTocEntry(title: 'Composition', anchor: 'composition'),
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
/// same wave, not routes this page can verify are wired yet — the supervisor
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

/// One specimen of every [DsBadgeVariant], each wrapped in a
/// [KeyedSubtree] the docs test locates directly — see the test file's own
/// note on why: it reads the resolved ink straight off the rendered
/// [DsText] rather than re-deriving `DsBadge`'s private colour mapping.
class _VariantLabel {
  const _VariantLabel(this.variant, this.label);
  final DsBadgeVariant variant;
  final String label;
}

/// Realistic copy per variant — the same words the variant's own docstring
/// in `badge.dart` uses as its example call site, where one exists (`action`
/// → "New release", `premium` → "Featured").
const List<_VariantLabel> _variantSpecimens = <_VariantLabel>[
  _VariantLabel(DsBadgeVariant.primary, 'New'),
  _VariantLabel(DsBadgeVariant.secondary, 'Draft'),
  _VariantLabel(DsBadgeVariant.destructive, 'Failed'),
  _VariantLabel(DsBadgeVariant.outline, 'Outline'),
  _VariantLabel(DsBadgeVariant.ghost, 'Ghost'),
  _VariantLabel(DsBadgeVariant.link, 'Docs'),
  _VariantLabel(DsBadgeVariant.action, 'New release'),
  _VariantLabel(DsBadgeVariant.premium, 'Featured'),
  _VariantLabel(DsBadgeVariant.success, 'Active'),
  _VariantLabel(DsBadgeVariant.warning, 'Pending'),
  _VariantLabel(DsBadgeVariant.info, 'Beta'),
];

class _BadgeArticle extends StatelessWidget {
  const _BadgeArticle();

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Column(
      key: const ValueKey<String>('badge-doc-article'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _overview(theme),
        _preview(),
        _install(),
        _usage(),
        _api(),
        _variants(),
        _states(),
        _accessibility(theme),
        _responsive(theme),
        _dependencies(theme),
        _composition(),
        _theming(theme),
        _source(),
      ],
    );
  }

  Widget _overview(DsThemeData theme) => DsSection(
    id: 'overview',
    title: 'Overview',
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: DsWidths.prose),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DsText(
            'DsBadge renders a small pill: a fixed 20px-tall, label-sized '
            'chip used to mark a status, a count, or a category — never an '
            'action. Eleven variants map to six semantic fills (success, '
            'warning, info, destructive, action, premium) plus primary and '
            'secondary, and three unfilled treatments (outline, ghost, link) '
            'for contexts that want restraint.',
            DsType.body,
          ),
          SizedBox(height: ds(4)),
          DsText(
            'Reach for it over DsKbd when the content is a status word or a '
            'count rather than a literal keystroke — kbd renders a '
            'monospace key cap, badge renders a semantic chip. Reach for it '
            'over a plain label when the value needs its own filled, '
            'bordered, or coloured surface to separate it from surrounding '
            'prose — a badge always paints something (the ramp-chip '
            'highlight and shadow-chip on every filled variant), where bare '
            'text paints nothing. And reach for DsButton instead the moment '
            'the chip needs to respond to a tap: DsBadge carries no '
            'GestureDetector, no FocusNode, and no pressed or hover state by '
            'design — its own source docstring puts it plainly: "a badge is '
            'a label, not a button, and it must not invite a click."',
            DsType.body,
          ),
          SizedBox(height: ds(4)),
          DsText(
            'Status: stable primitive, not yet registered in the CLI (see '
            'Install). Platforms: Android, iOS, Web, macOS, Windows, Linux — '
            'the same six every widget in this package targets.',
            DsType.small,
            color: theme.mutedForeground,
          ),
        ],
      ),
    ),
  );

  Widget _preview() => DsSection(
    id: 'preview',
    title: 'Preview',
    description:
        'All eleven DsBadgeVariant values, plus the leading-glyph '
        'composition the data page uses for "Featured".',
    child: DocsCodeExample(
      title: 'Badge specimens',
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/badge.dart',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Badge has no registry manifest yet — copy\n'
              '// lib/src/components/badge.dart from the package source\n'
              '// directly. There is no generated CLI payload to fetch.',
        ),
      ],
      preview: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Wrap(
            spacing: ds(3),
            runSpacing: ds(3),
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              for (final _VariantLabel spec in _variantSpecimens)
                KeyedSubtree(
                  key: ValueKey<String>('badge-preview:${spec.variant.name}'),
                  child: DsBadge(label: spec.label, variant: spec.variant),
                ),
            ],
          ),
          SizedBox(height: ds(5)),
          DsText('With a leading glyph', DsType.label),
          SizedBox(height: ds(2)),
          const DsBadge(
            label: 'Featured',
            variant: DsBadgeVariant.premium,
            glyph: DsIcon(
              DsIconGlyph.star,
              size: DsIconSize.xs,
              tone: DsIconTone.inherit,
            ),
          ),
        ],
      ),
    ),
  );

  Widget _install() => DsSection(
    id: 'install',
    title: 'Installation',
    description:
        'badge has no registry manifest yet, so `elattar add badge` is not '
        'available — install by copying the source file manually.',
    child: DocsInstallFacts(
      title: 'Installation facts',
      facts: <DocsInstallFact>[
        const DocsInstallFact(
          label: 'Registry item',
          value: 'not yet registered',
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
              'What a future manifest would need to resolve — colors, '
              'shadows, spacing, theme, typography, and the '
              'DsMachineSurface effect. None of this is resolved '
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
              'registry fixture install exist yet — there is nothing to '
              'install.',
        ),
      ],
    ),
  );

  Widget _usage() => DsSection(
    id: 'usage',
    title: 'Usage',
    description: 'The smallest correct call, then the shapes seen above.',
    child: DsPanel(
      label: 'DART',
      note: 'COMPOSE',
      child: DocsSelectableCodeBlock(code: _usageCode),
    ),
  );

  Widget _api() => DsSection(
    id: 'api',
    title: 'API',
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
              type: 'DsBadgeVariant',
              description:
                  'Defaults to primary. Selects the fill, ink, and '
                  'shadow — see Variants.',
            ),
            DocsApiFact(
              name: 'spec',
              type: 'DsTypeSpec?',
              description:
                  'Overrides DsComponentType.badgeLabel, the resolved type '
                  'spec the label renders with. DsSidebarMenuBadge passes '
                  'DsComponentType.sidebarMenuBadge here.',
            ),
            DocsApiFact(
              name: 'paddingX',
              type: 'double?',
              description:
                  'Overrides the 8px horizontal padding on each side '
                  '(DsBadge.horizontalPadding).',
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
        SizedBox(height: ds(6)),
        const DocsApiTable(
          title: 'Static tokens',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'DsBadge.height',
              type: 'static double',
              description:
                  'The hard 20px border-box height every badge renders at.',
            ),
            DocsApiFact(
              name: 'DsBadge.horizontalPadding',
              type: 'static double',
              description: 'The default paddingX — 8px.',
            ),
            DocsApiFact(
              name: 'DsBadge.glyphSize',
              type: 'static double',
              description: 'The forced glyph square — 12px.',
            ),
            DocsApiFact(
              name: 'DsBadge.glyphGap',
              type: 'static double',
              description: 'The gap between glyph and label — 4px.',
            ),
          ],
        ),
      ],
    ),
  );

  Widget _variants() => DsSection(
    id: 'variants',
    title: 'Variants and sizes',
    description:
        'Badge has no size axis — every chip is the same hard 20px border '
        'box (DsBadge.height); content never grows it. Use paddingX or '
        'minWidth to adjust footprint instead of a size enum.',
    child: const DocsApiTable(
      title: 'DsBadgeVariant',
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
          description: 'Fills with theme.secondary. ramp-chip + shadow-chip.',
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
              'theme.mutedForeground — same ink as outline.',
        ),
        DocsApiFact(
          name: 'link',
          type: 'unfilled',
          description:
              'No fill, no ramp, no shadow. Ink is theme.actionInk — '
              'coloured text in a pill-shaped box.',
        ),
        DocsApiFact(
          name: 'action',
          type: 'filled',
          description:
              'Added for this system (not in the original shadcn set). A '
              '12%-alpha tint of DsPalette.action; ink is theme.actionInk — '
              'same ink as link. ramp-chip + shadow-chip. The media '
              'dialog\'s "New release".',
        ),
        DocsApiFact(
          name: 'premium',
          type: 'filled',
          description:
              'A 12%-alpha tint of DsPalette.value; ink is theme.valueInk. '
              'The one variant using shadow-btn-value instead of '
              'shadow-chip — used for Featured, Limited, and anything '
              'carrying value.',
        ),
        DocsApiFact(
          name: 'success',
          type: 'filled',
          description:
              'A 12%-alpha tint of DsPalette.success; ink is '
              'theme.successInk. ramp-chip + shadow-chip.',
        ),
        DocsApiFact(
          name: 'warning',
          type: 'filled',
          description:
              'A 12%-alpha tint of DsPalette.warning; ink is '
              'theme.warningInk. ramp-chip + shadow-chip.',
        ),
        DocsApiFact(
          name: 'info',
          type: 'filled',
          description:
              'A 12%-alpha tint of DsPalette.info; ink is theme.infoInk. '
              'ramp-chip + shadow-chip.',
        ),
      ],
    ),
  );

  Widget _states() => DsSection(
    id: 'states',
    title: 'States and feedback',
    description:
        'DsBadge is a static, presentational StatelessWidget: it has no '
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
          userSignal: 'The resting paint is the only paint — see below.',
        ),
        DocsStateFact(
          state: 'Error / Success',
          treatment:
              'Not a live transition on one badge — choose '
              'DsBadgeVariant.destructive or .success at construction time '
              'instead. See Variants.',
          userSignal: 'A different badge instance, not a state change.',
        ),
        DocsStateFact(
          state: 'Reduced motion',
          treatment:
              'N/A — no AnimationController and no motion token appears in '
              'DsBadge.build.',
          userSignal: 'Nothing animates, so nothing needs to still.',
        ),
        DocsStateFact(
          state:
              'Hover / Focus-visible / Pressed / Selected / Loading / '
              'Empty / Disabled',
          treatment:
              'N/A — DsBadge is a StatelessWidget with no gesture, focus, '
              'or async wiring; there is no onPressed/enabled parameter to '
              'hold any of these.',
          userSignal:
              'Wrap in DsButton (or your own GestureDetector) at the call '
              'site if the chip must respond to input — DsBadge '
              'intentionally does not.',
        ),
      ],
    ),
  );

  Widget _accessibility(DsThemeData theme) => DsSection(
    id: 'accessibility',
    title: 'Accessibility and keyboard behavior',
    child: _bullets(theme, <String>[
      'Semantic role: none of its own — DsBadge builds no Semantics node. '
          'The label reaches assistive tech as ordinary static text, not as '
          'a button, link, or image.',
      'Required labels: none beyond `label` itself — there is no separate '
          'semanticLabel or tooltip parameter.',
      'Keyboard interactions: none. DsBadge is never in the tab order.',
      'Focus behavior: never receives focus — no Focus widget or FocusNode '
          'exists in its build method.',
      'Touch target: not applicable — a badge is not tappable, so it makes '
          'no target-size guarantee. A caller that wraps one to be tappable '
          '(e.g. inside a GestureDetector) owns that guarantee, not '
          'DsBadge.',
      'Non-colour signals: the label word itself is the signal — every '
          'variant reads correctly from its text alone ("Failed", "Active", '
          '"Pending"), and outline/ghost/link additionally drop the fill '
          'entirely so colour is never the only cue.',
      'Error wiring: none — a badge is not a form control and cannot '
          'associate with a field\'s error text; use DsInput\'s own invalid '
          'state for that.',
      'Screen-reader announcements: none — there is no liveRegion. A badge '
          'whose label changes across a rebuild (e.g. "Pending" → "Active") '
          'is not announced as a change; wire that explicitly at the call '
          'site if it matters.',
      'Known platform differences: none observed — the same widget tree '
          'renders on every target platform; nothing in badge.dart branches '
          'on platform.',
    ]),
  );

  Widget _responsive(DsThemeData theme) => DsSection(
    id: 'responsive',
    title: 'Responsive and platform behavior',
    child: _bullets(theme, <String>[
      'No responsive branching — DsBadge reads no breakpoint from '
          'BuildContext and renders identically at 390px and 1440px; only '
          'the label string can change the width it occupies.',
      'Height is fixed at 20px (DsBadge.height) everywhere; width is '
          'intrinsic to the label plus 16px of horizontal padding unless '
          'paddingX/minWidth override it.',
      'Long labels are not truncated by DsBadge itself — overflow-hidden '
          'clips the 16px line box to the 14px content box vertically, but '
          'there is no horizontal ellipsis. A very long label simply widens '
          'the chip; constrain the surrounding layout if the label is '
          'untrusted length.',
      'Platform parity: Android, iOS, Web, macOS, Windows, and Linux all '
          'render the same widget tree.',
    ]),
  );

  Widget _dependencies(DsThemeData theme) => DsSection(
    id: 'dependencies',
    title: 'Dependencies, files, and assets',
    child: _bullets(theme, <String>[
      'File: lib/src/components/badge.dart (one file, no companion parts).',
      'Foundation imports: foundation/colors.dart (dsHsl, DsPalette), '
          'foundation/shadows.dart (DsShadows.chip, DsShadows.btnValue), '
          'foundation/spacing.dart (ds()), foundation/theme.dart '
          '(DsThemeData), foundation/typography.dart (DsComponentType).',
      'Effect import: effects/machine_surface.dart (DsMachineSurface) — '
          'paints the fill, border, and shadow together for every filled '
          'variant.',
      'Scope import: theme_scope.dart (DsText, DsTheme).',
      'Assets: none. Fonts: none beyond the system type scale every DsText '
          'call already depends on. Shaders: none — the ramp-chip highlight '
          'is a LinearGradient, not a fragment shader.',
    ]),
  );

  Widget _composition() => DsSection(
    id: 'composition',
    title: 'Composition examples',
    description:
        'Two real shapes badges are composed into elsewhere in this '
        'package: a labelled metadata row, and a tag list.',
    child: DocsCodeExample(
      title: 'Composed with other primitives',
      preview: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              DsText('Workspace plan', DsType.label),
              SizedBox(width: ds(2)),
              const DsBadge(label: 'Pro', variant: DsBadgeVariant.premium),
            ],
          ),
          SizedBox(height: ds(4)),
          Wrap(
            spacing: ds(2),
            runSpacing: ds(2),
            children: const <Widget>[
              DsBadge(label: 'Design', variant: DsBadgeVariant.outline),
              DsBadge(label: 'Flutter', variant: DsBadgeVariant.outline),
              DsBadge(label: 'Tokens', variant: DsBadgeVariant.outline),
            ],
          ),
        ],
      ),
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(
          path: 'sidebar_menu_badge_precedent.dart',
          title: 'The DsSidebarMenuBadge precedent',
          description:
              'lib/src/components/sidebar.dart composes DsBadge directly, '
              'overriding spec/paddingX/minWidth exactly as documented '
              'above, rather than adding a new widget:',
          code: '''DsBadge(
  label: count,
  variant: DsBadgeVariant.secondary,
  spec: DsComponentType.sidebarMenuBadge,
  paddingX: ds(1.5),
  minWidth: ds(5),
)''',
        ),
      ],
    ),
  );

  Widget _theming(DsThemeData theme) => DsSection(
    id: 'theming',
    title: 'Theming notes',
    child: _bullets(theme, <String>[
      'Every colour DsBadge paints comes from the live theme: '
          'DsTheme.of(context).primary/secondary/destructive for the base '
          'three fills, DsPalette.action/value/success/warning/info for the '
          'six semantic tints, and the matching *Ink getters for text. '
          'Flipping DsThemeController between light and dark re-resolves '
          'every one — nothing is cached.',
      'The ramp-chip highlight is NOT theme-aware: it is a fixed white-to-'
          'black alpha gradient (18% white top, 5% white mid, 14% black '
          'bottom) painted as its own layer over the fill in both themes — '
          'a deliberate port of the reference\'s own utility, not a token '
          'gap.',
      'The two shadow specs — DsShadows.chip and, for premium only, '
          'DsShadows.btnValue — are the badge entries in the machine-shadow '
          'family. Overriding them is not exposed as a DsBadge parameter.',
      'DsBadge declares no colour-override parameter of its own (no fill '
          'or color argument) — every fill is variant-derived. A call site '
          'that needs a colour outside the eleven variants is a signal to '
          'add a new DsBadgeVariant, not to bypass the token system.',
    ]),
  );

  Widget _source() => DsSection(
    id: 'source',
    title: 'Source, tests, and docs',
    child: DocsInstallFacts(
      title: 'Reference',
      facts: <DocsInstallFact>[
        DocsInstallFact(
          label: 'Source',
          value: badgeDoc.sourcePath,
          description:
              'Authoritative implementation — the truth this page '
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

Widget _bullets(DsThemeData theme, List<String> lines) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: <Widget>[
    for (final String line in lines) ...<Widget>[
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: DsWidths.prose),
        child: DsText('•  $line', DsType.small, color: theme.mutedForeground),
      ),
      SizedBox(height: ds(2)),
    ],
  ],
);

const String _usageCode = '''
// The smallest correct call — variant defaults to primary.
DsBadge(label: 'New')

// A semantic variant with a leading glyph, matching the data page's
// "Featured" chips (Icon size="xs" tone="inherit" in the reference).
DsBadge(
  label: 'Featured',
  variant: DsBadgeVariant.premium,
  glyph: const DsIcon(
    DsIconGlyph.star,
    size: DsIconSize.xs,
    tone: DsIconTone.inherit,
  ),
)

// An unfilled variant for a low-emphasis tag.
DsBadge(label: 'Draft', variant: DsBadgeVariant.outline)''';
