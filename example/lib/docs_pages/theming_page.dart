/// Public documentation page for `/docs/theming`.
///
/// Content contract: `docs/superpowers/plans/2026-08-21-public-website-ui-
/// information-architecture.md` section 7.7. Explains semantic roles rather
/// than a palette editor that does not exist, and reads its swatches from
/// `ElTheme.of(context)` live so they cannot disagree with what the app
/// itself paints with — the same discipline `example/lib/token_swatch.dart`
/// documents for the legacy `/design-system/colors` gallery, applied here at
/// docs-page scale rather than reusing that page's own engine.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

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
          'Semantic tokens, ElThemeController, light and dark resolution, '
          'and how a consumer overrides them — read live from the theme '
          'this page itself renders with.',
    ),
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Docs'),
      ElBreadcrumbEntry.page('Theming'),
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
    final ElThemeData theme = ElTheme.of(context);
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

  Widget _prose(String text, ElThemeData theme, {ElTypeSpec? spec}) =>
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: ElWidths.prose),
        child: ElText(text, spec ?? ElType.body),
      );

  Widget _overview(ElThemeData theme) => DocsSection(
    id: 'overview',
    title: 'Overview',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _prose(
          'Every color a component paints with comes from '
          'ElTheme.of(context), a ElThemeData instance resolved from a live '
          'ElThemeController, never a literal picked per widget. There is '
          'no palette editor: the two ElThemeData instances (light, dark) '
          'are fixed in lib/src/foundation/theme.dart, and customization '
          'means either editing that file directly (source mode) or '
          'choosing which of the two paints (package mode). Both are '
          'covered below.',
          theme,
        ),
        SizedBox(height: el(4)),
        ElAlert(
          variant: ElAlertVariant.success,
          icon: const ElIcon(ElIconGlyph.circleCheck),
          title: 'Recommended: edit theme.dart directly',
          description:
              'Package mode fixes ElThemeData.light/dark to the version '
              'you depend on, with no per-token override. A real token '
              'change means source mode: elattar init --foundation source, '
              'then edit lib/design_system/foundation/theme.dart. See '
              'Source-mode customization below.',
        ),
      ],
    ),
  );

  Widget _primitives(ElThemeData theme) => DocsSection(
    id: 'primitives',
    title: 'Primitive versus semantic colors',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _prose(
          'ElPalette (lib/src/foundation/colors.dart) holds fixed, '
          'theme-independent brand hues — action, value, success, warning, '
          'info, plus bright/dark/deep variants of each. These do not '
          'change between light and dark.',
          theme,
        ),
        SizedBox(height: el(3)),
        _prose(
          'ElThemeData is the semantic layer built from them: background, '
          'foreground, card, border, and the *Ink roles below all resolve '
          'differently per theme, even where they derive from the same '
          'ElPalette primitive.',
          theme,
        ),
        SizedBox(height: el(4)),
        _PrimitiveSwatchRow(theme: theme),
      ],
    ),
  );

  Widget _surfaces(ElThemeData theme) => DocsSection(
    id: 'surfaces',
    title: 'Surface and foreground pairs',
    description:
        'Every surface in this system is declared with its matching '
        'foreground, read together so text is never guessed against a '
        'background it was not paired with.',
    child: _SemanticSwatchGrid(theme: theme),
  );

  Widget _actionValue(ElThemeData theme) => DocsSection(
    id: 'action-value',
    title: 'Action versus value',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _prose(
          'Action (ElPalette.action, theme.actionInk) marks links, active '
          'navigation, focus rings, and primary commands — the interactive '
          'thread that runs through the whole interface. Value '
          '(ElPalette.value, theme.valueInk) is reserved for outcomes worth '
          'calling out — a "Featured" or "Pro" badge, a highlighted metric '
          '— and stays out of ordinary navigation so it keeps its weight.',
          theme,
        ),
        SizedBox(height: el(4)),
        Wrap(
          spacing: el(3),
          runSpacing: el(3),
          children: <Widget>[
            _InkChip(
              label: 'Action',
              ink: theme.actionInk,
              fill: ElPalette.action,
            ),
            _InkChip(
              label: 'Value',
              ink: theme.valueInk,
              fill: ElPalette.value,
            ),
          ],
        ),
      ],
    ),
  );

  Widget _status(ElThemeData theme) => DocsSection(
    id: 'status',
    title: 'Status and -ink roles',
    description:
        'Success, warning, info, and destructive each carry a ElPalette '
        'fill and a matching *Ink foreground on ElThemeData, used only for '
        'genuine status — never as a decorative accent.',
    child: Wrap(
      spacing: el(3),
      runSpacing: el(3),
      children: <Widget>[
        _InkChip(
          label: 'Success',
          ink: theme.successInk,
          fill: ElPalette.success,
        ),
        _InkChip(
          label: 'Warning',
          ink: theme.warningInk,
          fill: ElPalette.warning,
        ),
        _InkChip(label: 'Info', ink: theme.infoInk, fill: ElPalette.info),
        _InkChip(
          label: 'Destructive',
          ink: theme.destructiveInk,
          fill: theme.destructive,
        ),
      ],
    ),
  );

  Widget _resolution(ElThemeData theme) => DocsSection(
    id: 'resolution',
    title: 'Light, dark, and system',
    description:
        'ElThemeController holds a ElThemeMode (light, system, dark — dark '
        'is the default). ElTheme.of(context) resolves it against the '
        'platform brightness in system mode and returns ElThemeData.light '
        'or ElThemeData.dark. Flip the control below — it holds its own '
        'controller, independent of the page around it.',
    child: const _ThemeModeDemo(),
  );

  Widget _typography(ElThemeData theme) => DocsSection(
    id: 'typography',
    title: 'Typography selection',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _prose(
          'Type is a token axis of its own: every ElText call takes a '
          'ElTypeSpec from ElType (or a component-scoped ElComponentType '
          'spec) rather than a raw TextStyle.',
          theme,
        ),
        SizedBox(height: el(3)),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            ElText('See ', ElType.small, color: theme.mutedForeground),
            const DocsLink(
              label: 'Typeset',
              route: docsTypesetRoute,
              underline: true,
            ),
            ElText(
              ' for the full scale, the fluid clamps, and the three font '
              'families.',
              ElType.small,
              color: theme.mutedForeground,
            ),
          ],
        ),
      ],
    ),
  );

  Widget _tokens(ElThemeData theme) => DocsSection(
    id: 'tokens',
    title: 'Radius, shadow, and motion roles',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const DocsApiTable(
          title: 'Other foundation token families',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'ElRadii',
              type: 'lib/src/foundation/spacing.dart',
              description:
                  'xs 2, sm 6, md 10, lg 12, xl 16 — corner radii components '
                  'select by role, not by literal.',
            ),
            DocsApiFact(
              name: 'ElShadows',
              type: 'lib/src/foundation/shadows.dart',
              description:
                  'Named elevation specs (e.g. chip, btnValue) consumed by '
                  'ElMachineSurface, matched CSS-blur-exact to the '
                  'reference.',
            ),
            DocsApiFact(
              name: 'ElDurations / ElCurves',
              type: 'lib/src/foundation/motion.dart',
              description:
                  'tick 80ms, fast 150ms, base 250ms; curves spring/out/'
                  'curveIn. elAnimationDuration() collapses any of them to '
                  'zero under reduced motion.',
            ),
            DocsApiFact(
              name: 'ElWidths / ElBreakpoints',
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

  Widget _sourceMode(ElThemeData theme) => DocsSection(
    id: 'source-mode',
    title: 'Source-mode customization',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _prose(
          'After `elattar init --foundation source`, '
          'lib/design_system/foundation/theme.dart is a full local copy of '
          'this file — edit ElThemeData.light / .dark directly to change a '
          'token. The change applies everywhere a copied component reads '
          'that token, because every copied component imports the same '
          'local file. There is no build step or codegen between the edit '
          'and the next hot reload.',
          theme,
        ),
        SizedBox(height: el(4)),
        // The actual `light` instance this page's own swatches above are
        // reading from (lib/src/foundation/theme.dart) — capped, since the
        // full instance runs on for another two dozen fields past what a
        // reader needs to see the shape of the thing they would edit.
        DocsSnippet(
          code:
              'static final ElThemeData light = _build(\n'
              '  kind: ElThemeKind.light,\n'
              '  background: elHsl(0, 0, 100),\n'
              '  foreground: elHsl(240, 10, 3.9),\n'
              '  card: elHsl(0, 0, 100),\n'
              '  cardForeground: elHsl(240, 10, 3.9),\n'
              '  popover: elHsl(0, 0, 100),\n'
              '  popoverForeground: elHsl(240, 10, 3.9),\n'
              '  secondary: elHsl(240, 4.8, 95.9),\n'
              '  secondaryForeground: elHsl(240, 5.9, 10),\n'
              '  muted: elHsl(240, 4.8, 95.9),\n'
              '  mutedForeground: elHsl(240, 4, 40),\n'
              '  accent: elHsl(240, 4.8, 95.9),\n'
              '  accentForeground: elHsl(240, 5.9, 10),\n'
              '  border: elHsl(240, 5.9, 90),\n'
              '  input: elHsl(240, 5.9, 90),\n'
              '  pageGlow: elHsl(240, 30, 98),\n'
              '  primary: ElPalette.action,\n'
              '  primaryForeground: elHsl(0, 0, 100),\n'
              '  ring: ElPalette.action,\n'
              '  actionInk: ElPalette.actionDark,\n'
              '  valueInk: ElPalette.valueDark,\n'
              '  successInk: ElPalette.successDeep,\n'
              '  warningInk: ElPalette.warningDeep,\n'
              '  infoInk: ElPalette.infoDeep,\n'
              '  destructiveInk: ElPalette.destructiveDeep,\n'
              '  destructive: elHsl(0, 72.2, 50.6),\n'
              '  destructiveForeground: elHsl(0, 0, 98),\n'
              '  // ...bubble-glow fields, then:\n'
              '  radius: 10,\n'
              '  // ...ink/rim layers, chart colours, bloom and star fields\n'
              '  // follow — see lib/src/foundation/theme.dart for the rest.\n'
              ');',
          maxHeight: el(48),
        ),
      ],
    ),
  );

  Widget _packageMode(ElThemeData theme) => DocsSection(
    id: 'package-mode',
    title: 'Package-mode theme configuration',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _prose(
          'ElTheme takes exactly one configurable input — the controller\'s '
          'ElThemeMode — and no per-field override parameter. Depending on '
          'elattar_design_system as a package means the two ElThemeData '
          'instances are fixed by the version you depend on; choosing '
          'light, dark, or system through the controller is the whole '
          'surface. Changing an individual token in package mode means '
          'forking the dependency, which is precisely the tradeoff source '
          'mode exists to avoid.',
          theme,
        ),
        SizedBox(height: el(3)),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            ElText('See ', ElType.small, color: theme.mutedForeground),
            const DocsLink(
              label: 'Installation',
              route: docsInstallationRoute,
              underline: true,
            ),
            ElText(
              ' for how a package dependency is added.',
              ElType.small,
              color: theme.mutedForeground,
            ),
          ],
        ),
      ],
    ),
  );

  Widget _verification(ElThemeData theme) => DocsSection(
    id: 'verification',
    title: 'Contrast and reduced-motion verification',
    child: _prose(
      'Foreground/background contrast is not asserted by hand: the colors '
      'gallery inside this same documentation app (example/lib/'
      'token_swatch.dart) computes WCAG 2.x relative luminance and contrast '
      'ratio from the live resolved ElThemeData for every paired token, in '
      'both themes. Reduced motion is verified the same way motion itself '
      'is produced: elAnimationDuration() reads '
      'MediaQuery.disableAnimations and collapses every duration it is '
      'asked for to zero, rather than a component checking the flag itself.',
      theme,
    ),
  );
}

/// A ElPalette primitive next to the semantic ink ElThemeData resolves it
/// into for the current theme, so the difference in [_actionValue]/[_status]
/// is something the reader can see, not just be told.
class _InkChip extends StatelessWidget {
  const _InkChip({required this.label, required this.ink, required this.fill});

  final String label;
  final Color ink;
  final Color fill;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(horizontal: el(3), vertical: el(2)),
    decoration: BoxDecoration(
      color: fill.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(ElRadii.md),
    ),
    child: ElText(label, ElType.label, color: ink),
  );
}

/// Live swatches of the ElPalette primitives — same values on both themes,
/// which is the point being demonstrated.
class _PrimitiveSwatchRow extends StatelessWidget {
  const _PrimitiveSwatchRow({required this.theme});

  final ElThemeData theme;

  static final List<(String, Color)> _primitives = <(String, Color)>[
    ('action', ElPalette.action),
    ('value', ElPalette.value),
    ('success', ElPalette.success),
    ('warning', ElPalette.warning),
    ('info', ElPalette.info),
  ];

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: el(4),
    runSpacing: el(3),
    children: <Widget>[
      for (final (String name, Color color) in _primitives)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: el(16),
              height: el(16),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(ElRadii.sm),
                border: Border.all(
                  color: theme.border,
                  width: ElWidths.hairline,
                ),
              ),
            ),
            SizedBox(height: el(1)),
            ElText(
              'ElPalette.$name',
              ElType.caption,
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

  final ElThemeData theme;

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
            padding: EdgeInsets.only(bottom: el(2)),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: el(4), vertical: el(3)),
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(ElRadii.md),
                border: Border.all(
                  color: theme.border,
                  width: ElWidths.hairline,
                ),
              ),
              child: ElText(label, ElType.small, color: foreground),
            ),
          ),
      ],
    );
  }
}

/// A minimal Light/System/Dark control over its own [ElThemeController],
/// independent of the app theme this page renders inside — flipping it
/// re-resolves [_SemanticSwatchGrid] live underneath, the same way a
/// consuming application's own toggle would.
class _ThemeModeDemo extends StatefulWidget {
  const _ThemeModeDemo();

  @override
  State<_ThemeModeDemo> createState() => _ThemeModeDemoState();
}

class _ThemeModeDemoState extends State<_ThemeModeDemo> {
  final ElThemeController _controller = ElThemeController(
    mode: ElThemeMode.dark,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ElTheme(
    controller: _controller,
    child: Builder(
      builder: (BuildContext context) {
        final ElThemeData demoTheme = ElTheme.of(context);
        return Container(
          padding: EdgeInsets.all(el(5)),
          decoration: BoxDecoration(
            color: demoTheme.background,
            borderRadius: BorderRadius.circular(ElRadii.lg),
            border: Border.all(
              color: demoTheme.border,
              width: ElWidths.hairline,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Wrap(
                spacing: el(2),
                children: <Widget>[
                  for (final ElThemeMode mode in ElThemeMode.values)
                    KeyedSubtree(
                      key: ValueKey<String>('theming-doc-mode:${mode.name}'),
                      child: ElButton(
                        onPressed: () =>
                            setState(() => _controller.setMode(mode)),
                        variant: _controller.mode == mode
                            ? ElButtonVariant.primary
                            : ElButtonVariant.outline,
                        size: ElButtonSize.sm,
                        child: ElText(mode.name, ElComponentType.buttonLabelSm),
                      ),
                    ),
                ],
              ),
              SizedBox(height: el(4)),
              _SemanticSwatchGrid(theme: demoTheme),
            ],
          ),
        );
      },
    ),
  );
}
