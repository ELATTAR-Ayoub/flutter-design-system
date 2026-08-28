/// Public documentation page for `/docs/theming`.
///
/// Content contract: `docs/superpowers/plans/2026-08-21-public-website-ui-
/// information-architecture.md` section 7.7. Explains semantic roles rather
/// than a palette editor that does not exist, and reads its swatches from
/// `ThemeScope.of(context)` live so they cannot disagree with what the app
/// itself paints with — the same discipline `example/lib/token_swatch.dart`
/// documents for the legacy `/design-system/colors` gallery, applied here at
/// docs-page scale rather than reusing that page's own engine.
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

import '../docs/docs_facts.dart';
import '../docs/docs_layout.dart';
import '../docs/docs_section.dart';
import '../docs/docs_snippet.dart';
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
          'Semantic tokens, ThemeController, light and dark resolution, '
          'and how a consumer overrides them — read live from the theme '
          'this page itself renders with.',
    ),
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Docs'),
      BreadcrumbEntry.page('Theming'),
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
    final ThemeTokens theme = ThemeScope.of(context);
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

  Widget _prose(String text, ThemeTokens theme, {TextStyleToken? spec}) =>
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: LayoutWidths.prose),
        child: StyledText(text, spec ?? TextStyles.body),
      );

  Widget _overview(ThemeTokens theme) => DocsSection(
    id: 'overview',
    title: 'Overview',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _prose(
          'Every color a component paints with comes from '
          'ThemeScope.of(context), a ThemeTokens instance resolved from a live '
          'ThemeController, never a literal picked per widget. There is '
          'no palette editor: the two ThemeTokens instances (light, dark) '
          'are fixed in lib/src/foundation/theme.dart, and customization '
          'means either editing that file directly (source mode) or '
          'choosing which of the two paints (package mode). Both are '
          'covered below.',
          theme,
        ),
        SizedBox(height: space(4)),
        Alert(
          variant: AlertVariant.success,
          icon: const Icon(IconGlyph.circleCheck),
          title: 'Recommended: edit theme.dart directly',
          description:
              'Package mode fixes ThemeTokens.light/dark to the version '
              'you depend on, with no per-token override. A real token '
              'change means source mode: elattar init --foundation source, '
              'then edit lib/design_system/foundation/theme.dart. See '
              'Source-mode customization below.',
        ),
      ],
    ),
  );

  Widget _primitives(ThemeTokens theme) => DocsSection(
    id: 'primitives',
    title: 'Primitive versus semantic colors',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _prose(
          'Palette (lib/src/foundation/colors.dart) holds fixed, '
          'theme-independent brand hues — action, value, success, warning, '
          'info, plus bright/dark/deep variants of each. These do not '
          'change between light and dark.',
          theme,
        ),
        SizedBox(height: space(3)),
        _prose(
          'ThemeTokens is the semantic layer built from them: background, '
          'foreground, card, border, and the *Ink roles below all resolve '
          'differently per theme, even where they derive from the same '
          'Palette primitive.',
          theme,
        ),
        SizedBox(height: space(4)),
        _PrimitiveSwatchRow(theme: theme),
      ],
    ),
  );

  Widget _surfaces(ThemeTokens theme) => DocsSection(
    id: 'surfaces',
    title: 'Surface and foreground pairs',
    description:
        'Every surface in this system is declared with its matching '
        'foreground, read together so text is never guessed against a '
        'background it was not paired with.',
    child: _SemanticSwatchGrid(theme: theme),
  );

  Widget _actionValue(ThemeTokens theme) => DocsSection(
    id: 'action-value',
    title: 'Action versus value',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _prose(
          'Action (Palette.action, theme.actionText) marks links, active '
          'navigation, focus rings, and primary commands — the interactive '
          'thread that runs through the whole interface. Value '
          '(Palette.value, theme.premiumText) is reserved for outcomes worth '
          'calling out — a "Featured" or "Pro" badge, a highlighted metric '
          '— and stays out of ordinary navigation so it keeps its weight.',
          theme,
        ),
        SizedBox(height: space(4)),
        Wrap(
          spacing: space(3),
          runSpacing: space(3),
          children: <Widget>[
            _InkChip(
              label: 'Action',
              ink: theme.actionText,
              fill: Palette.action,
            ),
            _InkChip(
              label: 'Value',
              ink: theme.premiumText,
              fill: Palette.value,
            ),
          ],
        ),
      ],
    ),
  );

  Widget _status(ThemeTokens theme) => DocsSection(
    id: 'status',
    title: 'Status and -ink roles',
    description:
        'Success, warning, info, and destructive each carry a Palette '
        'fill and a matching *Ink foreground on ThemeTokens, used only for '
        'genuine status — never as a decorative accent.',
    child: Wrap(
      spacing: space(3),
      runSpacing: space(3),
      children: <Widget>[
        _InkChip(
          label: 'Success',
          ink: theme.successText,
          fill: Palette.success,
        ),
        _InkChip(
          label: 'Warning',
          ink: theme.warningText,
          fill: Palette.warning,
        ),
        _InkChip(label: 'Info', ink: theme.infoText, fill: Palette.info),
        _InkChip(
          label: 'Destructive',
          ink: theme.destructiveText,
          fill: theme.destructive,
        ),
      ],
    ),
  );

  Widget _resolution(ThemeTokens theme) => DocsSection(
    id: 'resolution',
    title: 'Light, dark, and system',
    description:
        'ThemeController holds a ColorMode (light, system, dark — dark '
        'is the default). ThemeScope.of(context) resolves it against the '
        'platform brightness in system mode and returns ThemeTokens.light '
        'or ThemeTokens.dark. Flip the control below — it holds its own '
        'controller, independent of the page around it.',
    child: const _ThemeModeDemo(),
  );

  Widget _typography(ThemeTokens theme) => DocsSection(
    id: 'typography',
    title: 'Typography selection',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _prose(
          'Type is a token axis of its own: every StyledText call takes a '
          'TextStyleToken from TextStyles (or a component-scoped ComponentTextStyles '
          'spec) rather than a raw TextStyle.',
          theme,
        ),
        SizedBox(height: space(3)),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            StyledText('See ', TextStyles.small, color: theme.mutedForeground),
            const DocsLink(
              label: 'Typeset',
              route: docsTypesetRoute,
              underline: true,
            ),
            StyledText(
              ' for the full scale, the fluid clamps, and the three font '
              'families.',
              TextStyles.small,
              color: theme.mutedForeground,
            ),
          ],
        ),
      ],
    ),
  );

  Widget _tokens(ThemeTokens theme) => DocsSection(
    id: 'tokens',
    title: 'Radius, shadow, and motion roles',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const DocsApiTable(
          title: 'Other foundation token families',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'Radii',
              type: 'lib/src/foundation/spacing.dart',
              description:
                  'xs 2, sm 6, md 10, lg 12, xl 16 — corner radii components '
                  'select by role, not by literal.',
            ),
            DocsApiFact(
              name: 'Shadows',
              type: 'lib/src/foundation/shadows.dart',
              description:
                  'Named elevation specs (e.g. chip, btnValue) consumed by '
                  'Surface, matched CSS-blur-exact to the '
                  'reference.',
            ),
            DocsApiFact(
              name: 'MotionDurations / MotionCurves',
              type: 'lib/src/foundation/motion.dart',
              description:
                  'tick 80ms, fast 150ms, base 250ms; curves spring/out/'
                  'curveIn. effectiveMotionDuration() collapses any of them to '
                  'zero under reduced motion.',
            ),
            DocsApiFact(
              name: 'LayoutWidths / Breakpoints',
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

  Widget _sourceMode(ThemeTokens theme) => DocsSection(
    id: 'source-mode',
    title: 'Source-mode customization',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _prose(
          'After `elattar init --foundation source`, '
          'lib/design_system/foundation/theme.dart is a full local copy of '
          'this file — edit ThemeTokens.light / .dark directly to change a '
          'token. The change applies everywhere a copied component reads '
          'that token, because every copied component imports the same '
          'local file. There is no build step or codegen between the edit '
          'and the next hot reload.',
          theme,
        ),
        SizedBox(height: space(4)),
        // The actual `light` instance this page's own swatches above are
        // reading from (lib/src/foundation/theme.dart) — capped, since the
        // full instance runs on for another two dozen fields past what a
        // reader needs to see the shape of the thing they would edit.
        DocsSnippet(
          code:
              'static final ThemeTokens light = _build(\n'
              '  kind: ResolvedColorMode.light,\n'
              '  background: hslColor(0, 0, 100),\n'
              '  foreground: hslColor(240, 10, 3.9),\n'
              '  card: hslColor(0, 0, 100),\n'
              '  cardForeground: hslColor(240, 10, 3.9),\n'
              '  popover: hslColor(0, 0, 100),\n'
              '  popoverForeground: hslColor(240, 10, 3.9),\n'
              '  secondary: hslColor(240, 4.8, 95.9),\n'
              '  secondaryForeground: hslColor(240, 5.9, 10),\n'
              '  muted: hslColor(240, 4.8, 95.9),\n'
              '  mutedForeground: hslColor(240, 4, 40),\n'
              '  accent: hslColor(240, 4.8, 95.9),\n'
              '  accentForeground: hslColor(240, 5.9, 10),\n'
              '  border: hslColor(240, 5.9, 90),\n'
              '  input: hslColor(240, 5.9, 90),\n'
              '  pageGlow: hslColor(240, 30, 98),\n'
              '  primary: Palette.action,\n'
              '  primaryForeground: hslColor(0, 0, 100),\n'
              '  ring: Palette.action,\n'
              '  actionText: Palette.actionDark,\n'
              '  premiumText: Palette.valueDark,\n'
              '  successText: Palette.successDeep,\n'
              '  warningText: Palette.warningDeep,\n'
              '  infoText: Palette.infoDeep,\n'
              '  destructiveText: Palette.destructiveDeep,\n'
              '  destructive: hslColor(0, 72.2, 50.6),\n'
              '  destructiveForeground: hslColor(0, 0, 98),\n'
              '  // ...bubble-glow fields, then:\n'
              '  radius: 10,\n'
              '  // ...ink/rim layers, chart colours, bloom and star fields\n'
              '  // follow — see lib/src/foundation/theme.dart for the rest.\n'
              ');',
          maxHeight: space(48),
        ),
      ],
    ),
  );

  Widget _packageMode(ThemeTokens theme) => DocsSection(
    id: 'package-mode',
    title: 'Package-mode theme configuration',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _prose(
          'ThemeScope takes exactly one configurable input — the controller\'s '
          'ColorMode — and no per-field override parameter. Depending on '
          'elattar_design_system as a package means the two ThemeTokens '
          'instances are fixed by the version you depend on; choosing '
          'light, dark, or system through the controller is the whole '
          'surface. Changing an individual token in package mode means '
          'forking the dependency, which is precisely the tradeoff source '
          'mode exists to avoid.',
          theme,
        ),
        SizedBox(height: space(3)),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            StyledText('See ', TextStyles.small, color: theme.mutedForeground),
            const DocsLink(
              label: 'Installation',
              route: docsInstallationRoute,
              underline: true,
            ),
            StyledText(
              ' for how a package dependency is added.',
              TextStyles.small,
              color: theme.mutedForeground,
            ),
          ],
        ),
      ],
    ),
  );

  Widget _verification(ThemeTokens theme) => DocsSection(
    id: 'verification',
    title: 'Contrast and reduced-motion verification',
    child: _prose(
      'Foreground/background contrast is not asserted by hand: the colors '
      'gallery inside this same documentation app (example/lib/'
      'token_swatch.dart) computes WCAG 2.x relative luminance and contrast '
      'ratio from the live resolved ThemeTokens for every paired token, in '
      'both themes. Reduced motion is verified the same way motion itself '
      'is produced: effectiveMotionDuration() reads '
      'MediaQuery.disableAnimations and collapses every duration it is '
      'asked for to zero, rather than a component checking the flag itself.',
      theme,
    ),
  );
}

/// A Palette primitive next to the semantic ink ThemeTokens resolves it
/// into for the current theme, so the difference in [_actionValue]/[_status]
/// is something the reader can see, not just be told.
class _InkChip extends StatelessWidget {
  const _InkChip({required this.label, required this.ink, required this.fill});

  final String label;
  final Color ink;
  final Color fill;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(horizontal: space(3), vertical: space(2)),
    decoration: BoxDecoration(
      color: fill.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(Radii.md),
    ),
    child: StyledText(label, TextStyles.eyebrow, color: ink),
  );
}

/// Live swatches of the Palette primitives — same values on both themes,
/// which is the point being demonstrated.
class _PrimitiveSwatchRow extends StatelessWidget {
  const _PrimitiveSwatchRow({required this.theme});

  final ThemeTokens theme;

  static final List<(String, Color)> _primitives = <(String, Color)>[
    ('action', Palette.action),
    ('value', Palette.value),
    ('success', Palette.success),
    ('warning', Palette.warning),
    ('info', Palette.info),
  ];

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: space(4),
    runSpacing: space(3),
    children: <Widget>[
      for (final (String name, Color color) in _primitives)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: space(16),
              height: space(16),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(Radii.sm),
                border: Border.all(
                  color: theme.border,
                  width: BorderWidths.hairline,
                ),
              ),
            ),
            SizedBox(height: space(1)),
            StyledText(
              'Palette.$name',
              TextStyles.caption,
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

  final ThemeTokens theme;

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
            padding: EdgeInsets.only(bottom: space(2)),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: space(4),
                vertical: space(3),
              ),
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(Radii.md),
                border: Border.all(
                  color: theme.border,
                  width: BorderWidths.hairline,
                ),
              ),
              child: StyledText(label, TextStyles.small, color: foreground),
            ),
          ),
      ],
    );
  }
}

/// A minimal Light/System/Dark control over its own [ThemeController],
/// independent of the app theme this page renders inside — flipping it
/// re-resolves [_SemanticSwatchGrid] live underneath, the same way a
/// consuming application's own toggle would.
class _ThemeModeDemo extends StatefulWidget {
  const _ThemeModeDemo();

  @override
  State<_ThemeModeDemo> createState() => _ThemeModeDemoState();
}

class _ThemeModeDemoState extends State<_ThemeModeDemo> {
  final ThemeController _controller = ThemeController(mode: ColorMode.dark);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ThemeScope(
    controller: _controller,
    child: Builder(
      builder: (BuildContext context) {
        final ThemeTokens demoTheme = ThemeScope.of(context);
        return Container(
          padding: EdgeInsets.all(space(5)),
          decoration: BoxDecoration(
            color: demoTheme.background,
            borderRadius: BorderRadius.circular(Radii.lg),
            border: Border.all(
              color: demoTheme.border,
              width: BorderWidths.hairline,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Wrap(
                spacing: space(2),
                children: <Widget>[
                  for (final ColorMode mode in ColorMode.values)
                    KeyedSubtree(
                      key: ValueKey<String>('theming-doc-mode:${mode.name}'),
                      child: Button(
                        onPressed: () =>
                            setState(() => _controller.setMode(mode)),
                        variant: _controller.mode == mode
                            ? ButtonVariant.primary
                            : ButtonVariant.outline,
                        size: ButtonSize.sm,
                        child: StyledText(mode.name, TextStyles.buttonLabelSm),
                      ),
                    ),
                ],
              ),
              SizedBox(height: space(4)),
              _SemanticSwatchGrid(theme: demoTheme),
            ],
          ),
        );
      },
    ),
  );
}
