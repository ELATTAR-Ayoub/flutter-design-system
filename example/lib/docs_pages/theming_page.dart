/// Public documentation page for `/docs/theming`.
///
/// One job: a reader stops reaching for a colour and starts reaching for a
/// role. So the page opens with that rule, shows the roles as live specimens
/// read out of `ThemeScope.of(context)` rather than as a written-down
/// palette, and says plainly which of the two customization routes actually
/// changes a token.
///
/// **Nothing measurable is typed out here.** Every swatch is the colour this
/// page is itself painted with, and every radius, duration, measure and
/// breakpoint in the token table is interpolated from the foundation
/// constant. A value written into this file would be a second source of
/// truth, and this page's whole claim is to be the first one.
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
import '../docs/docs_showcase.dart';
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
          'Take colour from a semantic role, never from a value. Every '
          'swatch below is read live from the theme this page is painted '
          'with.',
    ),
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Docs'),
      BreadcrumbEntry.page('Theming'),
    ],
    toc: const <DocsTocEntry>[
      DocsTocEntry(title: 'The rule', anchor: 'overview'),
      DocsTocEntry(title: 'Primitive vs semantic', anchor: 'primitives'),
      DocsTocEntry(title: 'Roles by group', anchor: 'surfaces'),
      DocsTocEntry(title: 'Action vs value', anchor: 'action-value'),
      DocsTocEntry(title: 'Status roles', anchor: 'status'),
      DocsTocEntry(title: 'Light, dark, and system', anchor: 'resolution'),
      DocsTocEntry(title: 'Typography', anchor: 'typography'),
      DocsTocEntry(title: 'Radius, shadow, and motion', anchor: 'tokens'),
      DocsTocEntry(title: 'Changing a token', anchor: 'source-mode'),
      DocsTocEntry(title: 'Package mode', anchor: 'package-mode'),
      DocsTocEntry(title: 'Verification checklist', anchor: 'verification'),
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
        _roles(theme),
        _actionValue(theme),
        _status(theme),
        _resolution(),
        _typography(theme),
        _tokens(),
        _sourceMode(theme),
        _packageMode(theme),
        _verification(theme),
      ],
    );
  }

  Widget _prose(String text, {TextStyleToken? spec}) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: LayoutWidths.prose),
    child: StyledText(text, spec ?? TextStyles.body),
  );

  Widget _see(
    ThemeTokens theme,
    String lead,
    List<(String, String)> links,
    String tail,
  ) => Wrap(
    crossAxisAlignment: WrapCrossAlignment.center,
    children: <Widget>[
      StyledText(lead, TextStyles.small, color: theme.mutedForeground),
      for (int i = 0; i < links.length; i++) ...<Widget>[
        if (i > 0)
          StyledText(
            i == links.length - 1 ? ' and ' : ', ',
            TextStyles.small,
            color: theme.mutedForeground,
          ),
        DocsLink(label: links[i].$1, route: links[i].$2, underline: true),
      ],
      StyledText(tail, TextStyles.small, color: theme.mutedForeground),
    ],
  );

  Widget _overview(ThemeTokens theme) => DocsSection(
    id: 'overview',
    title: 'The rule',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _prose(
          'Read colour from ThemeScope.of(context) by role, and let the '
          'component paint itself. Do not style a widget with a colour of '
          // Prose teaching the rule, not code breaking it.
          'your own, and do not run Theme.of(context) beside this as a ' // ui-check: ignore
          'second visual system: two sources of truth is how a dark theme '
          'ends up correct on eighty percent of a screen.',
        ),
        SizedBox(height: space(4)),
        const DocsSnippet(
          language: 'dart',
          code:
              'final ThemeTokens theme = ThemeScope.of(context);\n\n'
              '// Yes: a role.\n'
              'ColoredBox(color: theme.card, child: child)\n\n'
              '// No: a value, and no dark counterpart.\n'
              '// ColoredBox(color: someGrey, child: child)',
        ),
        SizedBox(height: space(4)),
        _prose(
          'Wrap your app once in ThemeScope with a ThemeController, and every '
          'component below it resolves against the mode that controller '
          'holds.',
          spec: TextStyles.small,
        ),
      ],
    ),
  );

  Widget _primitives(ThemeTokens theme) => DocsSection(
    id: 'primitives',
    title: 'Primitive versus semantic',
    description:
        'Palette holds the fixed brand hues, identical in both themes. '
        'ThemeTokens is the semantic layer built from them, and resolves '
        'per theme. Compose against ThemeTokens; reach for Palette only '
        'where a hue must stay put.',
    child: _PrimitiveSwatchRow(theme: theme),
  );

  Widget _roles(ThemeTokens theme) => DocsSection(
    id: 'surfaces',
    title: 'Roles by group',
    description:
        'Every surface is declared with its matching foreground and read '
        'together, so text is never guessed against a background it was not '
        'paired with. Flip the theme control in your browser and these '
        'change with it.',
    child: DocsShowcaseFrame(
      alignment: Alignment.topLeft,
      minHeight: space(96),
      child: _RoleGroups(theme: theme),
    ),
  );

  Widget _actionValue(ThemeTokens theme) => DocsSection(
    id: 'action-value',
    title: 'Action versus value',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _prose(
          'Action marks links, active navigation, focus rings and primary '
          'commands: the interactive thread running through the interface. '
          'Value is reserved for outcomes worth calling out, such as a '
          'featured badge or a highlighted metric, and stays out of ordinary '
          'navigation so it keeps its weight.',
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
    title: 'Status roles',
    description:
        'Success, warning, info and destructive each pair a fill with a '
        'legible ink. Use them for genuine status only, never as a '
        'decorative accent, and never as the only signal, because colour '
        'alone is not one.',
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

  Widget _resolution() => DocsSection(
    id: 'resolution',
    title: 'Light, dark, and system',
    description:
        'ThemeController holds a ColorMode. In system mode ThemeScope '
        'resolves it against the platform brightness. The control below '
        'drives its own controller, independent of the page around it.',
    child: const _ThemeModeDemo(),
  );

  Widget _typography(ThemeTokens theme) => DocsSection(
    id: 'typography',
    title: 'Typography',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _prose(
          'Type is a token axis of its own: StyledText takes a role from '
          'TextStyles rather than a raw TextStyle, exactly as colour takes a '
          'role from ThemeTokens.',
        ),
        SizedBox(height: space(4)),
        _see(theme, 'See ', <(String, String)>[
          ('Typeset', docsTypesetRoute),
        ], ' for the whole scale rendered at real size.'),
      ],
    ),
  );

  /// The non-colour token families, with their values interpolated from the
  /// foundation rather than transcribed.
  Widget _tokens() => DocsSection(
    id: 'tokens',
    title: 'Radius, shadow, and motion',
    child: DocsApiTable(
      title: 'The other token families',
      facts: <DocsApiFact>[
        DocsApiFact(
          name: 'Radii',
          type: 'double',
          description:
              'Corner radii selected by role: xs ${_px(Radii.xs)}, '
              'sm ${_px(Radii.sm)}, md ${_px(Radii.md)}, lg ${_px(Radii.lg)}, '
              'xl ${_px(Radii.xl)}.',
        ),
        const DocsApiFact(
          name: 'Shadows',
          type: 'ShadowStyle',
          description:
              'Named elevation styles, each a stack of ShadowLayers, '
              'consumed by Surface. A component picks the style for what it '
              'is, never a blur radius.',
        ),
        DocsApiFact(
          name: 'MotionDurations, MotionCurves',
          type: 'Duration, Curve',
          description:
              'tick ${_ms(MotionDurations.tick)}, '
              'fast ${_ms(MotionDurations.fast)}, '
              'normal ${_ms(MotionDurations.normal)}, '
              'slow ${_ms(MotionDurations.slow)}. '
              'effectiveMotionDuration() collapses any of them to zero under '
              'reduced motion, so no component checks the flag itself.',
        ),
        DocsApiFact(
          name: 'LayoutWidths, Breakpoints',
          type: 'double',
          description:
              'Measures: prose ${_px(LayoutWidths.prose)}, '
              'content ${_px(LayoutWidths.content)}, '
              'page ${_px(LayoutWidths.page)}, '
              'shell ${_px(LayoutWidths.shell)}. And the four responsive '
              'steps: ${_px(Breakpoints.sm)}, ${_px(Breakpoints.md)}, '
              '${_px(Breakpoints.lg)}, ${_px(Breakpoints.xl)}.',
        ),
      ],
    ),
  );

  Widget _sourceMode(ThemeTokens theme) => DocsSection(
    id: 'source-mode',
    title: 'Changing a token',
    description:
        'There is no palette editor, and no per-token override parameter. '
        'Changing a role means owning the file that declares it, which is '
        'what the source foundation gives you.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const DocsSnippet(
          language: 'dart',
          code:
              '// lib/design_system/foundation/theme.dart, in your project,\n'
              '// after `elattar init --foundation source`.\n'
              'static final ThemeTokens light = _build(\n'
              '  kind: ResolvedColorMode.light,\n'
              '  // ...\n'
              '  primary: brandIndigo,   // was Palette.action\n'
              '  ring: brandIndigo,      // keep the focus ring on the hue\n'
              '  // ...\n'
              ');',
        ),
        SizedBox(height: space(4)),
        _prose(
          'Edit ThemeTokens.light and .dark in that file and every installed '
          'component follows, because they all import the same local copy. '
          'There is no build step between the edit and the next hot reload. '
          'Record what you changed: elattar add --overwrite replaces the '
          'files it installed, and this is one of them.',
        ),
      ],
    ),
  );

  Widget _packageMode(ThemeTokens theme) => DocsSection(
    id: 'package-mode',
    title: 'Package mode',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _prose(
          'Depending on the package instead fixes the two ThemeTokens '
          'instances to the version you depend on. Choosing light, dark or '
          'system through the controller is the whole configuration surface; '
          'changing an individual role means forking the dependency, which '
          'is the trade the source foundation exists to avoid.',
        ),
        SizedBox(height: space(4)),
        _see(theme, 'See ', <(String, String)>[
          ('Installation', docsInstallationRoute),
        ], ' for how a package dependency is added.'),
      ],
    ),
  );

  Widget _verification(ThemeTokens theme) => DocsSection(
    id: 'verification',
    title: 'Verification checklist',
    description: 'Four passes before a screen is done.',
    child: const DocsStateMatrix(
      title: 'Check before shipping a surface',
      facts: <DocsStateFact>[
        DocsStateFact(
          state: 'Both themes',
          treatment:
              'Render the screen in light and in dark, not just the one you '
              'develop in.',
          userSignal:
              'A surface painted from a role flips for free; one painted '
              'from a value does not.',
        ),
        DocsStateFact(
          state: 'Contrast',
          treatment:
              'Text takes the foreground declared with its surface, so the '
              'pair is checked rather than guessed.',
          userSignal:
              'The colours gallery in this app computes the WCAG ratio for '
              'every paired role, live, in both themes.',
        ),
        DocsStateFact(
          state: 'Not colour alone',
          treatment: 'Status carries an icon and a word as well as a hue.',
          userSignal:
              'The state stays legible to a reader who cannot separate the '
              'two hues.',
        ),
        DocsStateFact(
          state: 'Reduced motion',
          treatment:
              'Timing comes from effectiveMotionDuration(), which reads the '
              'platform flag and collapses to zero.',
          userSignal:
              'Nothing animates when the reader asked for nothing to '
              'animate.',
        ),
      ],
    ),
  );

  /// `10.0` is a value; `10px` is a number a person reads.
  static String _px(double value) =>
      '${value == value.roundToDouble() ? value.toStringAsFixed(0) : value}px';

  static String _ms(Duration value) => '${value.inMilliseconds}ms';
}

/// A Palette primitive next to the semantic ink ThemeTokens resolves it into
/// for the current theme, so the difference is something a reader can see.
class _InkChip extends StatelessWidget {
  const _InkChip({required this.label, required this.ink, required this.fill});

  /// The wash behind an ink chip. Not a foundation token: no component paints
  /// a tinted status chip, so there is nothing to read this off, and it is
  /// declared once here rather than four times inline.
  static const double _tintAlpha = 0.12;

  final String label;
  final Color ink;
  final Color fill;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(horizontal: space(3), vertical: space(2)),
    decoration: BoxDecoration(
      color: fill.withValues(alpha: _tintAlpha),
      borderRadius: BorderRadius.circular(Radii.md),
    ),
    child: StyledText(label, TextStyles.small, color: ink),
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
        _Swatch(label: 'Palette.$name', color: color, theme: theme),
    ],
  );
}

/// One square of colour with its role name under it.
class _Swatch extends StatelessWidget {
  const _Swatch({
    required this.label,
    required this.color,
    required this.theme,
  });

  final String label;
  final Color color;
  final ThemeTokens theme;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Container(
        width: space(16),
        height: space(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(Radii.sm),
          border: Border.all(color: theme.border, width: BorderWidths.hairline),
        ),
      ),
      SizedBox(height: space(1)),
      StyledText(label, TextStyles.small, color: theme.mutedForeground),
    ],
  );
}

/// The semantic roles, grouped the way a developer looks for them.
///
/// Surface, action and status are read as pairs, a fill and the ink declared
/// with it, because that pairing is the contract. Navigation is the sidebar
/// family, and data is the chart ramp, which has no paired ink because a
/// series is a mark rather than a background for text.
class _RoleGroups extends StatelessWidget {
  const _RoleGroups({required this.theme});

  final ThemeTokens theme;

  List<(String, List<(String, Color, Color)>)>
  get _paired => <(String, List<(String, Color, Color)>)>[
    (
      'Surface',
      <(String, Color, Color)>[
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
      ],
    ),
    (
      'Action',
      <(String, Color, Color)>[
        ('primary / primaryForeground', theme.primary, theme.primaryForeground),
        ('ring, on background', theme.background, theme.ring),
        ('actionText, on background', theme.background, theme.actionText),
        ('premiumText, on background', theme.background, theme.premiumText),
      ],
    ),
    (
      'Status',
      <(String, Color, Color)>[
        (
          'destructive / destructiveForeground',
          theme.destructive,
          theme.destructiveForeground,
        ),
        ('successText, on background', theme.background, theme.successText),
        ('warningText, on background', theme.background, theme.warningText),
        ('infoText, on background', theme.background, theme.infoText),
      ],
    ),
    (
      'Navigation',
      <(String, Color, Color)>[
        ('sidebar / sidebarForeground', theme.sidebar, theme.sidebarForeground),
        (
          'sidebarPrimary / sidebarPrimaryForeground',
          theme.sidebarPrimary,
          theme.sidebarPrimaryForeground,
        ),
        (
          'sidebarAccent / sidebarAccentForeground',
          theme.sidebarAccent,
          theme.sidebarAccentForeground,
        ),
      ],
    ),
  ];

  List<(String, Color)> get _charts => <(String, Color)>[
    ('chart1', theme.chart1),
    ('chart2', theme.chart2),
    ('chart3', theme.chart3),
    ('chart4', theme.chart4),
    ('chart5', theme.chart5),
  ];

  @override
  Widget build(BuildContext context) => Column(
    key: const ValueKey<String>('theming-role-groups'),
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      for (final (String title, List<(String, Color, Color)> rows) in _paired)
        Padding(
          key: ValueKey<String>('theming-role-group:$title'),
          padding: EdgeInsets.only(bottom: space(6)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              StyledText(title, TextStyles.small),
              SizedBox(height: space(3)),
              for (final (String label, Color fill, Color ink) in rows)
                Padding(
                  padding: EdgeInsets.only(bottom: space(2)),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: space(4),
                      vertical: space(3),
                    ),
                    decoration: BoxDecoration(
                      color: fill,
                      borderRadius: BorderRadius.circular(Radii.md),
                      border: Border.all(
                        color: theme.border,
                        width: BorderWidths.hairline,
                      ),
                    ),
                    child: StyledText(label, TextStyles.small, color: ink),
                  ),
                ),
            ],
          ),
        ),
      Column(
        key: const ValueKey<String>('theming-role-group:Data'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          StyledText('Data', TextStyles.small),
          SizedBox(height: space(3)),
          Wrap(
            spacing: space(4),
            runSpacing: space(3),
            children: <Widget>[
              for (final (String name, Color color) in _charts)
                _Swatch(label: name, color: color, theme: theme),
            ],
          ),
        ],
      ),
    ],
  );
}

/// A Light/System/Dark control over its own [ThemeController], independent of
/// the app theme this page renders inside. Flipping it re-resolves the
/// swatches beneath it live, the way a consuming app's own toggle would.
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
                runSpacing: space(2),
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
                        child: StyledText(mode.name, TextStyles.small),
                      ),
                    ),
                ],
              ),
              SizedBox(height: space(4)),
              for (final (String label, Color fill, Color ink)
                  in <(String, Color, Color)>[
                    (
                      'background / foreground',
                      demoTheme.background,
                      demoTheme.foreground,
                    ),
                    (
                      'card / cardForeground',
                      demoTheme.card,
                      demoTheme.cardForeground,
                    ),
                    (
                      'muted / mutedForeground',
                      demoTheme.muted,
                      demoTheme.mutedForeground,
                    ),
                    (
                      'primary / primaryForeground',
                      demoTheme.primary,
                      demoTheme.primaryForeground,
                    ),
                  ])
                Padding(
                  padding: EdgeInsets.only(bottom: space(2)),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: space(4),
                      vertical: space(3),
                    ),
                    decoration: BoxDecoration(
                      color: fill,
                      borderRadius: BorderRadius.circular(Radii.md),
                      border: Border.all(
                        color: demoTheme.border,
                        width: BorderWidths.hairline,
                      ),
                    ),
                    child: StyledText(label, TextStyles.small, color: ink),
                  ),
                ),
            ],
          ),
        );
      },
    ),
  );
}
