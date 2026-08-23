/// Public documentation page for `/docs/theming`.
///
/// Content contract: `docs/superpowers/plans/2026-08-21-public-website-ui-
/// information-architecture.md` section 7.7. Explains semantic roles rather
/// than a palette editor that does not exist, and reads its swatches from
/// `DsTheme.of(context)` live so they cannot disagree with what the app
/// itself paints with — the same discipline `example/lib/token_swatch.dart`
/// documents for the legacy `/design-system/colors` gallery, applied here at
/// docs-page scale rather than reusing that page's own engine.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../docs/docs_facts.dart';
import '../docs/docs_layout.dart';
import '../kit.dart';
import 'catalog.dart';

class ThemingDocsPage extends StatelessWidget {
  const ThemingDocsPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: docsThemingRoute,
    intro: const DocsPageIntro(
      eyebrow: 'DOCS',
      title: 'Theming',
      description:
          'Semantic tokens, DsThemeController, light and dark resolution, '
          'and how a consumer overrides them — read live from the theme '
          'this page itself renders with.',
    ),
    breadcrumbs: const <DsBreadcrumbEntry>[
      DsBreadcrumbEntry.link('Docs'),
      DsBreadcrumbEntry.page('Theming'),
    ],
    toc: const <DocsTocEntry>[
      DocsTocEntry(title: 'Overview', anchor: 'overview'),
      DocsTocEntry(title: 'Primitive vs semantic', anchor: 'primitives'),
      DocsTocEntry(title: 'Surface and foreground pairs', anchor: 'surfaces'),
      DocsTocEntry(title: 'Action vs value', anchor: 'action-value'),
      DocsTocEntry(title: 'Status and -ink roles', anchor: 'status'),
      DocsTocEntry(title: 'Light, dark, and system', anchor: 'resolution'),
      DocsTocEntry(title: 'Typography selection', anchor: 'typography'),
      DocsTocEntry(title: 'Radius, shadow, and motion roles', anchor: 'tokens'),
      DocsTocEntry(title: 'Source-mode customization', anchor: 'source-mode'),
      DocsTocEntry(title: 'Package-mode configuration', anchor: 'package-mode'),
      DocsTocEntry(
        title: 'Contrast and reduced motion',
        anchor: 'verification',
      ),
    ],
    previous: const DocsPageLink(
      title: 'Installation',
      route: docsInstallationRoute,
    ),
    next: const DocsPageLink(title: 'CLI', route: docsCliRoute),
    onNavigate: onNavigate,
    child: const _ThemingArticle(),
  );
}

class _ThemingArticle extends StatelessWidget {
  const _ThemingArticle();

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Column(
      key: const ValueKey<String>('theming-doc-article'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _overview(theme),
        _primitives(theme),
        _surfaces(theme),
        _actionValue(theme),
        _status(theme),
        _resolution(theme),
        _typography(theme),
        _tokens(theme),
        _sourceMode(theme),
        _packageMode(theme),
        _verification(theme),
      ],
    );
  }

  Widget _prose(String text, DsThemeData theme, {DsTypeSpec? spec}) =>
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: DsWidths.prose),
        child: DsText(text, spec ?? DsType.body),
      );

  Widget _overview(DsThemeData theme) => DsSection(
    id: 'overview',
    title: 'Overview',
    child: _prose(
      'Every color a component paints with comes from DsTheme.of(context), '
      'a DsThemeData instance resolved from a live DsThemeController — never '
      'a literal picked per widget. There is no palette editor: the two '
      'DsThemeData instances (light, dark) are fixed in '
      'lib/src/foundation/theme.dart, and customization means either editing '
      'that file directly (source mode) or choosing which of the two paints '
      '(package mode). Both are covered below.',
      theme,
    ),
  );

  Widget _primitives(DsThemeData theme) => DsSection(
    id: 'primitives',
    title: 'Primitive versus semantic colors',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _prose(
          'DsPalette (lib/src/foundation/colors.dart) holds fixed, '
          'theme-independent brand hues — action, value, success, warning, '
          'info, plus bright/dark/deep variants of each. These do not '
          'change between light and dark.',
          theme,
        ),
        SizedBox(height: ds(3)),
        _prose(
          'DsThemeData is the semantic layer built from them: background, '
          'foreground, card, border, and the *Ink roles below all resolve '
          'differently per theme, even where they derive from the same '
          'DsPalette primitive.',
          theme,
        ),
        SizedBox(height: ds(4)),
        _PrimitiveSwatchRow(theme: theme),
      ],
    ),
  );

  Widget _surfaces(DsThemeData theme) => DsSection(
    id: 'surfaces',
    title: 'Surface and foreground pairs',
    description:
        'Every surface in this system is declared with its matching '
        'foreground, read together so text is never guessed against a '
        'background it was not paired with.',
    child: _SemanticSwatchGrid(theme: theme),
  );

  Widget _actionValue(DsThemeData theme) => DsSection(
    id: 'action-value',
    title: 'Action versus value',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _prose(
          'Action (DsPalette.action, theme.actionInk) marks links, active '
          'navigation, focus rings, and primary commands — the interactive '
          'thread that runs through the whole interface. Value '
          '(DsPalette.value, theme.valueInk) is reserved for outcomes worth '
          'calling out — a "Featured" or "Pro" badge, a highlighted metric '
          '— and stays out of ordinary navigation so it keeps its weight.',
          theme,
        ),
        SizedBox(height: ds(4)),
        Wrap(
          spacing: ds(3),
          runSpacing: ds(3),
          children: <Widget>[
            _InkChip(
              label: 'Action',
              ink: theme.actionInk,
              fill: DsPalette.action,
            ),
            _InkChip(
              label: 'Value',
              ink: theme.valueInk,
              fill: DsPalette.value,
            ),
          ],
        ),
      ],
    ),
  );

  Widget _status(DsThemeData theme) => DsSection(
    id: 'status',
    title: 'Status and -ink roles',
    description:
        'Success, warning, info, and destructive each carry a DsPalette '
        'fill and a matching *Ink foreground on DsThemeData, used only for '
        'genuine status — never as a decorative accent.',
    child: Wrap(
      spacing: ds(3),
      runSpacing: ds(3),
      children: <Widget>[
        _InkChip(
          label: 'Success',
          ink: theme.successInk,
          fill: DsPalette.success,
        ),
        _InkChip(
          label: 'Warning',
          ink: theme.warningInk,
          fill: DsPalette.warning,
        ),
        _InkChip(label: 'Info', ink: theme.infoInk, fill: DsPalette.info),
        _InkChip(
          label: 'Destructive',
          ink: theme.destructiveInk,
          fill: theme.destructive,
        ),
      ],
    ),
  );

  Widget _resolution(DsThemeData theme) => DsSection(
    id: 'resolution',
    title: 'Light, dark, and system',
    description:
        'DsThemeController holds a DsThemeMode (light, system, dark — dark '
        'is the default). DsTheme.of(context) resolves it against the '
        'platform brightness in system mode and returns DsThemeData.light '
        'or DsThemeData.dark. Flip the control below — it holds its own '
        'controller, independent of the page around it.',
    child: const _ThemeModeDemo(),
  );

  Widget _typography(DsThemeData theme) => DsSection(
    id: 'typography',
    title: 'Typography selection',
    child: _prose(
      'Type is a token axis of its own: every DsText call takes a '
      'DsTypeSpec from DsType (or a component-scoped DsComponentType spec) '
      'rather than a raw TextStyle. See Typeset for the full scale, the '
      'fluid clamps, and the three font families.',
      theme,
    ),
  );

  Widget _tokens(DsThemeData theme) => DsSection(
    id: 'tokens',
    title: 'Radius, shadow, and motion roles',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const DocsApiTable(
          title: 'Other foundation token families',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'DsRadii',
              type: 'lib/src/foundation/spacing.dart',
              description:
                  'xs 2, sm 6, md 10, lg 12, xl 16 — corner radii components '
                  'select by role, not by literal.',
            ),
            DocsApiFact(
              name: 'DsShadows',
              type: 'lib/src/foundation/shadows.dart',
              description:
                  'Named elevation specs (e.g. chip, btnValue) consumed by '
                  'DsMachineSurface, matched CSS-blur-exact to the '
                  'reference.',
            ),
            DocsApiFact(
              name: 'DsDurations / DsCurves',
              type: 'lib/src/foundation/motion.dart',
              description:
                  'tick 80ms, fast 150ms, base 250ms; curves spring/out/'
                  'curveIn. dsAnimationDuration() collapses any of them to '
                  'zero under reduced motion.',
            ),
            DocsApiFact(
              name: 'DsWidths / DsBreakpoints',
              type: 'lib/src/foundation/spacing.dart',
              description:
                  'Layout measures (content 1080, page 1200, shell 1680) and '
                  'the four responsive steps (640 / 768 / 1024 / 1280) '
                  'components read instead of a hand-picked breakpoint.',
            ),
          ],
        ),
      ],
    ),
  );

  Widget _sourceMode(DsThemeData theme) => DsSection(
    id: 'source-mode',
    title: 'Source-mode customization',
    child: _prose(
      'After `elattar init --foundation source`, '
      'lib/design_system/foundation/theme.dart is a full local copy of this '
      'file — edit DsThemeData.light / .dark directly to change a token. '
      'The change applies everywhere a copied component reads that token, '
      'because every copied component imports the same local file. There is '
      'no build step or codegen between the edit and the next hot reload.',
      theme,
    ),
  );

  Widget _packageMode(DsThemeData theme) => DsSection(
    id: 'package-mode',
    title: 'Package-mode theme configuration',
    child: _prose(
      'DsTheme takes exactly one configurable input — the controller\'s '
      'DsThemeMode — and no per-field override parameter. Depending on '
      'elattar_design_system as a package (see Installation) means the two '
      'DsThemeData instances are fixed by the version you depend on; '
      'choosing light, dark, or system through the controller is the whole '
      'surface. Changing an individual token in package mode means forking '
      'the dependency, which is precisely the tradeoff source mode exists '
      'to avoid.',
      theme,
    ),
  );

  Widget _verification(DsThemeData theme) => DsSection(
    id: 'verification',
    title: 'Contrast and reduced-motion verification',
    child: _prose(
      'Foreground/background contrast is not asserted by hand: the colors '
      'gallery inside this same documentation app (example/lib/'
      'token_swatch.dart) computes WCAG 2.x relative luminance and contrast '
      'ratio from the live resolved DsThemeData for every paired token, in '
      'both themes. Reduced motion is verified the same way motion itself '
      'is produced: dsAnimationDuration() reads '
      'MediaQuery.disableAnimations and collapses every duration it is '
      'asked for to zero, rather than a component checking the flag itself.',
      theme,
    ),
  );
}

/// A DsPalette primitive next to the semantic ink DsThemeData resolves it
/// into for the current theme, so the difference in [_actionValue]/[_status]
/// is something the reader can see, not just be told.
class _InkChip extends StatelessWidget {
  const _InkChip({required this.label, required this.ink, required this.fill});

  final String label;
  final Color ink;
  final Color fill;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(horizontal: ds(3), vertical: ds(2)),
    decoration: BoxDecoration(
      color: fill.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(DsRadii.md),
    ),
    child: DsText(label, DsType.label, color: ink),
  );
}

/// Live swatches of the DsPalette primitives — same values on both themes,
/// which is the point being demonstrated.
class _PrimitiveSwatchRow extends StatelessWidget {
  const _PrimitiveSwatchRow({required this.theme});

  final DsThemeData theme;

  static final List<(String, Color)> _primitives = <(String, Color)>[
    ('action', DsPalette.action),
    ('value', DsPalette.value),
    ('success', DsPalette.success),
    ('warning', DsPalette.warning),
    ('info', DsPalette.info),
  ];

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: ds(4),
    runSpacing: ds(3),
    children: <Widget>[
      for (final (String name, Color color) in _primitives)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: ds(16),
              height: ds(16),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(DsRadii.sm),
                border: Border.all(
                  color: theme.border,
                  width: DsWidths.hairline,
                ),
              ),
            ),
            SizedBox(height: ds(1)),
            DsText(
              'DsPalette.$name',
              DsType.caption,
              color: theme.mutedForeground,
            ),
          ],
        ),
    ],
  );
}

/// Live surface/foreground pairs, read straight off [theme] — this is the
/// "live token specimens" the content contract asks for, not a screenshot.
class _SemanticSwatchGrid extends StatelessWidget {
  const _SemanticSwatchGrid({required this.theme});

  final DsThemeData theme;

  @override
  Widget build(BuildContext context) {
    final List<(String, Color, Color)> pairs = <(String, Color, Color)>[
      ('background / foreground', theme.background, theme.foreground),
      ('card / cardForeground', theme.card, theme.cardForeground),
      ('popover / popoverForeground', theme.popover, theme.popoverForeground),
      (
        'secondary / secondaryForeground',
        theme.secondary,
        theme.secondaryForeground,
      ),
      ('muted / mutedForeground', theme.muted, theme.mutedForeground),
      ('accent / accentForeground', theme.accent, theme.accentForeground),
      ('primary / primaryForeground', theme.primary, theme.primaryForeground),
      (
        'destructive / destructiveForeground',
        theme.destructive,
        theme.destructiveForeground,
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        for (final (String label, Color surface, Color foreground) in pairs)
          Padding(
            padding: EdgeInsets.only(bottom: ds(2)),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: ds(4), vertical: ds(3)),
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(DsRadii.md),
                border: Border.all(
                  color: theme.border,
                  width: DsWidths.hairline,
                ),
              ),
              child: DsText(label, DsType.small, color: foreground),
            ),
          ),
      ],
    );
  }
}

/// A minimal Light/System/Dark control over its own [DsThemeController],
/// independent of the app theme this page renders inside — flipping it
/// re-resolves [_SemanticSwatchGrid] live underneath, the same way a
/// consuming application's own toggle would.
class _ThemeModeDemo extends StatefulWidget {
  const _ThemeModeDemo();

  @override
  State<_ThemeModeDemo> createState() => _ThemeModeDemoState();
}

class _ThemeModeDemoState extends State<_ThemeModeDemo> {
  final DsThemeController _controller = DsThemeController(
    mode: DsThemeMode.dark,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => DsTheme(
    controller: _controller,
    child: Builder(
      builder: (BuildContext context) {
        final DsThemeData demoTheme = DsTheme.of(context);
        return Container(
          padding: EdgeInsets.all(ds(5)),
          decoration: BoxDecoration(
            color: demoTheme.background,
            borderRadius: BorderRadius.circular(DsRadii.lg),
            border: Border.all(
              color: demoTheme.border,
              width: DsWidths.hairline,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Wrap(
                spacing: ds(2),
                children: <Widget>[
                  for (final DsThemeMode mode in DsThemeMode.values)
                    KeyedSubtree(
                      key: ValueKey<String>('theming-doc-mode:${mode.name}'),
                      child: DsButton(
                        onPressed: () =>
                            setState(() => _controller.setMode(mode)),
                        variant: _controller.mode == mode
                            ? DsButtonVariant.primary
                            : DsButtonVariant.outline,
                        size: DsButtonSize.sm,
                        child: DsText(mode.name, DsComponentType.buttonLabelSm),
                      ),
                    ),
                ],
              ),
              SizedBox(height: ds(4)),
              _SemanticSwatchGrid(theme: demoTheme),
            ],
          ),
        );
      },
    ),
  );
}
