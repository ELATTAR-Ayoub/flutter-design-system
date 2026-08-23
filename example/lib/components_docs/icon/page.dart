/// Public documentation page for the icon, spinner, and ds_rule components.
///
/// Reshaped to the shadcn parity frame (shadcn-parity component docs pass):
/// `spinner` has a real counterpart at
/// `https://ui.shadcn.com/docs/components/base/spinner`, and its sections
/// (Usage, Size) are mirrored under the Spinner group below. `icon` and
/// `ds-rule` have no shadcn counterpart at all, so their sections are named
/// in shadcn's own style rather than copied from a page that does not exist.
///
/// Three small primitives documented together, each grouped under its own
/// name so a reader who wants only one of them can jump straight to it:
///
/// * **icon**, Lucide glyph renderer with size and tone ladders.
/// * **spinner**, Rotating loader-circle, 16px, loops forever.
/// * **ds-rule**, Validation rule predicate with static factory methods.
///
/// All three carry real registry manifests with identical dependencies
/// (`source-foundation`), so the Installation section renders three real
/// `elattar add` commands.
///
/// **Skipped from spinner's own reference sections:** Customization only.
/// The reference's Customization section edits `spinner.tsx` itself to swap
/// its inline `<LoaderIcon>` for a different lucide icon; [DsSpinner]'s
/// constructor is `DsSpinner({size, strokeOverride})`, no `icon` or `glyph`
/// parameter at all, and `build()` hardcodes `DsIcon(DsIconGlyph.loaderCircle,
/// ...)`, so there is no equivalent surface to demonstrate without forking
/// `spinner.dart`. Button, Badge, Input Group, Empty and RTL are all real
/// compositions of components this package has ([DsButton], [DsBadge],
/// [DsInputGroup], [DsEmpty], and a plain [Directionality] wrapper), and are
/// mirrored below under the Spinner group, in the reference's own order.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/docs_code.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../kit.dart';
import 'meta.dart';
import '../spinner/meta.dart' as spinner_meta;
import '../ds_rule/meta.dart' as dsrule_meta;

class IconDocPage extends StatelessWidget {
  const IconDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: iconDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / PRIMITIVES',
      title: 'Icon, Spinner, DsRule',
      description:
          'Three small, token-backed primitives: glyph rendering, loading '
          'feedback, and field validation.',
    ),
    breadcrumbs: const <DsBreadcrumbEntry>[
      DsBreadcrumbEntry.link('Components'),
      DsBreadcrumbEntry.page('Icon, Spinner, DsRule'),
    ],
    sidebar: const <DocsSidebarEntry>[],
    toc: const <DocsTocEntry>[
      DocsTocEntry(title: 'Installation', anchor: 'install'),
      DocsTocEntry(title: 'Icon Usage', anchor: 'icon-usage'),
      DocsTocEntry(title: 'Icon glyphs', anchor: 'icon-glyphs'),
      DocsTocEntry(title: 'Spinner Usage', anchor: 'spinner-usage'),
      DocsTocEntry(title: 'Spinner size', anchor: 'spinner-size'),
      DocsTocEntry(title: 'Spinner: Button', anchor: 'spinner-button'),
      DocsTocEntry(title: 'Spinner: Badge', anchor: 'spinner-badge'),
      DocsTocEntry(
        title: 'Spinner: Input Group',
        anchor: 'spinner-input-group',
      ),
      DocsTocEntry(title: 'Spinner: Empty', anchor: 'spinner-empty'),
      DocsTocEntry(title: 'Spinner: RTL', anchor: 'spinner-rtl'),
      DocsTocEntry(title: 'DsRule Usage', anchor: 'dsrule-usage'),
      DocsTocEntry(title: 'API Reference', anchor: 'api'),
      DocsTocEntry(title: 'States', anchor: 'states'),
      DocsTocEntry(title: 'Accessibility', anchor: 'accessibility'),
      DocsTocEntry(title: 'Responsive', anchor: 'responsive'),
      DocsTocEntry(title: 'Dependencies', anchor: 'dependencies'),
      DocsTocEntry(title: 'Theming', anchor: 'theming'),
      DocsTocEntry(title: 'Source', anchor: 'source'),
    ],
    onNavigate: onNavigate,
    child: const _ComponentsArticle(),
  );
}

class _ComponentsArticle extends StatelessWidget {
  const _ComponentsArticle();

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Column(
      key: const ValueKey<String>('icon-doc-article'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        // shadcn: the live demo that opens the page, before any heading. A
        // small composite of all three primitives, reusing the same glyphs
        // and the same DsSpinner construction the sections below use.
        _heroDemo(),
        SizedBox(height: ds(8)),
        _install(),
        SizedBox(height: ds(8)),
        _iconUsage(),
        _iconGlyphs(),
        SizedBox(height: ds(8)),
        _spinnerUsage(),
        _spinnerSize(),
        _spinnerButton(),
        _spinnerBadge(),
        _spinnerInputGroup(),
        _spinnerEmpty(),
        _spinnerRtl(),
        SizedBox(height: ds(8)),
        _dsRuleUsage(theme),
        SizedBox(height: ds(8)),
        _api(theme),
        _states(theme),
        _accessibility(theme),
        _responsive(theme),
        _dependencies(theme),
        _theming(theme),
        _source(theme),
      ],
    );
  }

  // ── LIVE DEMO (unheaded) ────────────────────────────────────────────────

  Widget _heroDemo() => DocsCodeExample(
    title: 'Icon, Spinner, DsRule',
    description:
        'A curated glyph, a looping spinner, and a validation rule\'s '
        'rendered message, side by side.',
    preview: Wrap(
      spacing: ds(6),
      runSpacing: ds(4),
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        for (final (DsIconGlyph glyph, String name)
            in const <(DsIconGlyph, String)>[
              (DsIconGlyph.check, 'check'),
              (DsIconGlyph.star, 'star'),
              (DsIconGlyph.alertTriangle, 'alertTriangle'),
            ])
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              DsIcon(glyph, size: DsIconSize.lg),
              SizedBox(height: ds(2)),
              DsText(name, DsType.small),
            ],
          ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const DsSpinner(),
            SizedBox(height: ds(2)),
            DsText('DsSpinner', DsType.small),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            DsText(
              DsRule.email('That is not an email address.').issue('a@b') ?? '',
              DsType.small,
            ),
            SizedBox(height: ds(2)),
            DsText('DsRule.email(...).issue(\'a@b\')', DsType.code),
          ],
        ),
      ],
    ),
  );

  // ── ICON SECTION ──────────────────────────────────────────────────────────

  Widget _iconUsage() => DsSection(
    id: 'icon-usage',
    title: 'Icon Usage',
    description:
        'DsIcon renders one lucide glyph, 24x24 in lucide\'s 24-unit grid, at '
        'one of seven fixed sizes and one of ten tones. The 1,756-glyph '
        'lucide-react 1.28.0 set (ISC license) is embedded verbatim in '
        '`icon_paths.g.dart`: no icon font, no font hinting, painted as '
        'stroked paths at the requested size and tone.',
    child: DocsCodeExample(
      title: 'Basic construction',
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/icon.dart',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Install with elattar add icon\n'
              'const DsIcon checkmark = DsIcon(DsIconGlyph.check);',
        ),
      ],
    ),
  );

  Widget _iconGlyphs() => DsSection(
    id: 'icon-glyphs',
    title: 'Icon glyphs',
    description:
        'A curated selection of seven glyphs across three sizes: md (16px, '
        'default), lg (20px), and xl (24px). Each is labeled with its '
        'DsIconGlyph name.',
    child: DocsCodeExample(
      title: 'Icon specimens',
      preview: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          for (final String section in <String>[
            'Navigation',
            'Actions',
            'Status',
          ]) ...<Widget>[
            DsText(section, DsType.label),
            SizedBox(height: ds(2)),
            Wrap(
              spacing: ds(4),
              runSpacing: ds(4),
              children: _iconSpecimens(section),
            ),
            SizedBox(height: ds(5)),
          ],
        ],
      ),
    ),
  );

  List<Widget> _iconSpecimens(String section) {
    const List<(DsIconGlyph, String)> specs = <(DsIconGlyph, String)>[
      (DsIconGlyph.menu, 'menu'),
      (DsIconGlyph.search, 'search'),
      (DsIconGlyph.settings, 'settings'),
      (DsIconGlyph.star, 'star'),
      (DsIconGlyph.check, 'check'),
      (DsIconGlyph.x, 'x'),
      (DsIconGlyph.alertTriangle, 'alertTriangle'),
    ];

    final List<(DsIconGlyph, String)> filtered = section == 'Navigation'
        ? specs.sublist(0, 3)
        : section == 'Actions'
        ? specs.sublist(3, 6)
        : specs.sublist(6);

    return <Widget>[
      for (final (DsIconGlyph glyph, String name) in filtered)
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            DsIcon(glyph, size: DsIconSize.lg),
            SizedBox(height: ds(2)),
            DsText(name, DsType.small),
          ],
        ),
    ];
  }

  // ── SPINNER SECTION ────────────────────────────────────────────────────────

  Widget _spinnerUsage() => DsSection(
    id: 'spinner-usage',
    title: 'Spinner Usage',
    description:
        'DsSpinner is a 16px rotating loader-circle icon that spins once '
        'every 900ms, forever, using a linear easing curve, no ease-in or '
        'ease-out. It is mute: no aria-label, no role="status", because the '
        'reference drops both in its own destructure. A loading button '
        'carries the busy state instead.',
    child: DocsCodeExample(
      title: 'Basic construction',
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/spinner.dart',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Default: 16px, loops forever.\n'
              'const DsSpinner loading = DsSpinner();',
        ),
      ],
    ),
  );

  Widget _spinnerSize() => DsSection(
    id: 'spinner-size',
    title: 'Spinner size',
    description:
        'A spinner at its default size (16px) and one at 24px, both rotating '
        'continuously. Tests use tester.pump(), never pumpAndSettle(), '
        'because the animation loops forever.',
    child: DocsCodeExample(
      title: 'Spinner specimen',
      preview: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            DsText('Default (16px, 900ms cycle)', DsType.label),
            SizedBox(height: ds(3)),
            const DsSpinner(),
            SizedBox(height: ds(5)),
            DsText('Larger size (24px)', DsType.label),
            SizedBox(height: ds(3)),
            const DsSpinner(size: 24),
          ],
        ),
      ),
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/spinner.dart',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Larger size, same stroke as the default.\n'
              'const DsSpinner large = DsSpinner(size: 24);',
        ),
      ],
    ),
  );

  Widget _spinnerButton() => DsSection(
    id: 'spinner-button',
    title: 'Spinner: Button',
    description:
        'The reference composes a Spinner child by hand and tags it '
        'data-icon="inline-start" or "inline-end" for spacing on either '
        'side of the label. DsButton\'s loading flag does the inline-start '
        'case natively: it prepends a DsSpinner and disables the button. '
        'The inline-end case has no dedicated flag, so it is a caller-built '
        'row instead.',
    child: DocsCodeExample(
      title: 'Spinner in a button',
      preview: Wrap(
        spacing: ds(4),
        runSpacing: ds(4),
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          DsButton(
            loading: true,
            onPressed: () {},
            child: const Text('Loading...'),
          ),
          DsButton(
            variant: DsButtonVariant.secondary,
            onPressed: () {},
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text('Processing'),
                SizedBox(width: DsButton.gapFor(DsButtonSize.md)),
                const DsSpinner(),
              ],
            ),
          ),
        ],
      ),
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/button.dart',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              'DsButton(\n'
              '  loading: true,\n'
              '  onPressed: () {},\n'
              "  child: const Text('Loading...'),\n"
              ')',
        ),
      ],
    ),
  );

  Widget _spinnerBadge() => DsSection(
    id: 'spinner-badge',
    title: 'Spinner: Badge',
    description:
        'DsBadge\'s glyph slot takes any widget, not only a DsIconGlyph: a '
        'DsSpinner passed there is squeezed into the same 12px square an '
        'icon fills, with the usual 4px gap before the label.',
    child: DocsCodeExample(
      title: 'Spinner in a badge',
      preview: Wrap(
        spacing: ds(3),
        runSpacing: ds(3),
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          DsBadge(
            label: 'Syncing',
            variant: DsBadgeVariant.secondary,
            glyph: DsSpinner(size: DsBadge.glyphSize),
          ),
          DsBadge(
            label: 'Updating',
            variant: DsBadgeVariant.action,
            glyph: DsSpinner(size: DsBadge.glyphSize),
          ),
        ],
      ),
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/badge.dart',
          code:
              "DsBadge(\n"
              "  label: 'Syncing',\n"
              '  variant: DsBadgeVariant.secondary,\n'
              '  glyph: DsSpinner(size: DsBadge.glyphSize),\n'
              ')',
        ),
      ],
    ),
  );

  Widget _spinnerInputGroup() => DsSection(
    id: 'spinner-input-group',
    title: 'Spinner: Input Group',
    description:
        'An addon takes any widget too: a DsSpinner sized to the group\'s '
        'own 16px icon rung signals validation in progress without a '
        'status message of its own.',
    child: DocsCodeExample(
      title: 'Spinner in an input group',
      preview: DsInputGroup(
        endAddon: DsInputGroupAddon(
          align: DsInputGroupAlign.end,
          child: DsSpinner(size: DsIcon.pxFor(DsIconSize.sm)),
        ),
        enabled: false,
        child: DsInputGroupInput(placeholder: 'Validating...'),
      ),
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/input_group.dart',
          code:
              'DsInputGroup(\n'
              '  endAddon: DsInputGroupAddon(\n'
              '    align: DsInputGroupAlign.end,\n'
              '    child: DsSpinner(size: DsIcon.pxFor(DsIconSize.sm)),\n'
              '  ),\n'
              '  enabled: false,\n'
              "  child: DsInputGroupInput(placeholder: 'Validating...'),\n"
              ')',
        ),
      ],
    ),
  );

  Widget _spinnerEmpty() => DsSection(
    id: 'spinner-empty',
    title: 'Spinner: Empty',
    description:
        'DsEmptyMedia only takes a DsIconGlyph, so a spinner cannot fill '
        'its tile. DsEmptyHeader\'s children list takes any widget, so the '
        'spinner sits there directly instead, ahead of the title and '
        'description, the way the reference\'s EmptyMedia would.',
    child: DocsCodeExample(
      title: 'Spinner in an empty state',
      preview: DsEmpty(
        children: <Widget>[
          DsEmptyHeader(
            children: <Widget>[
              const DsSpinner(size: 24),
              const DsEmptyTitle('Processing your request'),
              const DsEmptyDescription(
                'This can take a few moments. Please keep this window open.',
              ),
            ],
          ),
          DsEmptyContent(
            children: <Widget>[
              DsButton(
                variant: DsButtonVariant.outline,
                onPressed: () {},
                child: const Text('Cancel'),
              ),
            ],
          ),
        ],
      ),
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/empty.dart',
          code:
              'DsEmpty(\n'
              '  children: <Widget>[\n'
              '    DsEmptyHeader(\n'
              '      children: <Widget>[\n'
              '        DsSpinner(size: 24),\n'
              "        DsEmptyTitle('Processing your request'),\n"
              '      ],\n'
              '    ),\n'
              '  ],\n'
              ')',
        ),
      ],
    ),
  );

  Widget _spinnerRtl() => DsSection(
    id: 'spinner-rtl',
    title: 'Spinner: RTL',
    description:
        'DsSpinner paints identically under either text direction: a '
        'rotating circle has no logical edges to mirror. What does mirror '
        'is the composition around it, under the same Directionality.rtl '
        'that Toggle, Progress and Pagination each demonstrate on their own '
        'pages: a Row lays its children start-to-end along the ambient '
        'direction, so the spinner and its label swap physical sides '
        'without either widget reading direction itself.',
    child: DocsCodeExample(
      title: 'Spinner under RTL',
      preview: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const DsSpinner(),
            SizedBox(width: ds(2)),
            DsText('جارٍ التحميل', DsType.body),
          ],
        ),
      ),
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/spinner.dart',
          code:
              'Directionality(\n'
              '  textDirection: TextDirection.rtl,\n'
              '  child: Row(\n'
              '    mainAxisSize: MainAxisSize.min,\n'
              '    children: <Widget>[\n'
              '      const DsSpinner(),\n'
              "      DsText('جارٍ التحميل', DsType.body),\n"
              '    ],\n'
              '  ),\n'
              ')',
        ),
      ],
    ),
  );

  // ── DSRULE SECTION ─────────────────────────────────────────────────────────

  Widget _dsRuleUsage(DsThemeData theme) => DsSection(
    id: 'dsrule-usage',
    title: 'DsRule Usage',
    description:
        'DsRule is the validation-rule primitive: a predicate and an error '
        'message, not a horizontal divider. A DsRule<T> holds a test '
        'function and the sentence it renders when a value fails. A list of '
        'rules is what a schema is: ordered checks against one field, '
        'yielding all failures in declaration order or only the first, '
        'depending on DsIssueMode. Every rule is a static factory method '
        'that takes a message, so it cannot appear inside a const '
        'expression: each rule is a new instance.',
    child: DocsCodeExample(
      title: 'Basic construction',
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/ds_rule.dart',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Install with elattar add ds-rule\n'
              'final DsRule<String> minLen = DsRule.minLength(\n'
              "  3,\n  'At least 3 characters.',\n);\n\n"
              'final DsRule<String> email = DsRule.email(\n'
              "  'That is not an email address.',\n);",
        ),
      ],
    ),
  );

  // ── SHARED SECTIONS ────────────────────────────────────────────────────────

  Widget _install() => DsSection(
    id: 'install',
    title: 'Installation',
    description:
        'All three components carry registry manifests and install through '
        'the CLI, resolving source-foundation automatically.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DocsCodeExample(
          title: 'Install icon',
          command: DocsCodeCommand(
            command: iconDoc.command,
            description: 'Installs icon.dart and three companion files.',
          ),
        ),
        SizedBox(height: ds(5)),
        DocsCodeExample(
          title: 'Install spinner',
          command: DocsCodeCommand(
            command: spinner_meta.spinnerDoc.command,
            description: 'Installs spinner.dart, requires icon.',
          ),
        ),
        SizedBox(height: ds(5)),
        DocsCodeExample(
          title: 'Install ds-rule',
          command: DocsCodeCommand(
            command: dsrule_meta.dsRuleDoc.command,
            description: 'Installs ds_rule.dart.',
          ),
        ),
      ],
    ),
  );

  Widget _api(DsThemeData theme) => DsSection(
    id: 'api',
    title: 'API Reference',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const DocsApiTable(
          title: 'DsIcon properties',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'glyph',
              type: 'DsIconGlyph',
              description:
                  'Required (primary constructor). The curated glyph from '
                  'the whitelist: menu, search, star, check, x, and 59 others.',
            ),
            DocsApiFact(
              name: 'size',
              type: 'DsIconSize',
              description:
                  'Defaults to md (16px). One of: xs (12px), sm (14px), md '
                  '(16px), lg (20px), xl (24px), xl2 (32px), xl3 (40px).',
            ),
            DocsApiFact(
              name: 'tone',
              type: 'DsIconTone',
              description:
                  'Defaults to inherit (the text colour). One of: normal '
                  '(foreground), muted, subtle, action, value, success, '
                  'warning, info, error, inherit.',
            ),
            DocsApiFact(
              name: 'label',
              type: 'String?',
              description:
                  'The accessible name, required for icon-only controls, '
                  'omitted for decorative icons beside explanatory text. '
                  'Passed to Semantics(label:) or ExcludeSemantics.',
            ),
            DocsApiFact(
              name: 'sizePx',
              type: 'double?',
              description:
                  'An off-ladder px size, overriding the size parameter. '
                  'Use sparingly; the ladder exists for a reason.',
            ),
            DocsApiFact(
              name: 'strokeOverride',
              type: 'double?',
              description:
                  'The stroke width in lucide\'s 24-unit space. Null means '
                  'the formula computes it from the px size; 2 is lucide\'s '
                  'authored value; 2.4 and 1.6 are the snap bounds.',
            ),
          ],
        ),
        SizedBox(height: ds(6)),
        const DocsApiTable(
          title: 'DsIcon.lucide constructor',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'lucide',
              type: 'DsLucideGlyph',
              description:
                  'Required. A glyph from the generated registry, for when '
                  'the curated whitelist doesn\'t carry the shape you need. '
                  'Takes the same size, tone, label, and stroke parameters.',
            ),
          ],
        ),
        SizedBox(height: ds(6)),
        const DocsApiTable(
          title: 'Icon static methods and constants',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'DsIcon.pxFor(DsIconSize)',
              type: 'static double',
              description:
                  'Returns the pixel size for a rung: xs to 12, sm to 14, md '
                  'to 16, lg to 20, xl to 24, xl2 to 32, xl3 to 40.',
            ),
            DocsApiFact(
              name: 'DsIcon.strokeFor(double)',
              type: 'static double',
              description:
                  'Computes the stroke width for a px size. At md (16px) it '
                  'returns 2.4; above 2.6x the authored ratio it snaps to 2; '
                  'below 1.5x it snaps to 1.6.',
            ),
            DocsApiFact(
              name: 'DsIcon.colorFor(context, tone)',
              type: 'static Color',
              description:
                  'Resolves the tone to the theme colour. DsIconTone.inherit '
                  'reads DefaultTextStyle, falling back to theme.foreground.',
            ),
          ],
        ),
        SizedBox(height: ds(8)),
        const DocsApiTable(
          title: 'DsSpinner properties',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'size',
              type: 'double',
              description:
                  'Defaults to DsSpinner.px (16.0). The rendered square size. '
                  'The stroke stays 2.4 regardless: see strokeOverride.',
            ),
            DocsApiFact(
              name: 'strokeOverride',
              type: 'double?',
              description:
                  'The stroke width in lucide\'s 24-unit space. Null means '
                  '2.4 always (icon.dart\'s strokeFor(16) result), matching '
                  'the reference\'s off-ladder behaviour. Use this only if '
                  'the reference needs a different stroke.',
            ),
          ],
        ),
        SizedBox(height: ds(6)),
        const DocsApiTable(
          title: 'Spinner static constant',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'DsSpinner.px',
              type: 'static const double',
              description:
                  'The default size, 16.0, named because it matches the `size-4` '
                  'Tailwind class the reference uses.',
            ),
          ],
        ),
        SizedBox(height: ds(8)),
        const DocsApiTable(
          title: 'DsRule properties',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'test',
              type: 'DsRuleTest<T> (bool Function(T))',
              description:
                  'Required. Returns true when the value passes. Public for '
                  'custom rules; use the static factories below for the shipped '
                  'checks.',
            ),
            DocsApiFact(
              name: 'message',
              type: 'String',
              description:
                  'Required. Rendered verbatim by FieldError when test fails. '
                  'Every message in this package\'s own schemas includes the '
                  'trailing period.',
            ),
          ],
        ),
        SizedBox(height: ds(6)),
        const DocsApiTable(
          title: 'DsRule static factory methods',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'DsRule.minLength(int, String)',
              type: 'static DsRule<String>',
              description:
                  'Passes when String.length >= min. Counts UTF-16 code units, '
                  'matching JavaScript and Zod.',
            ),
            DocsApiFact(
              name: 'DsRule.maxLength(int, String)',
              type: 'static DsRule<String>',
              description: 'Passes when String.length <= max.',
            ),
            DocsApiFact(
              name: 'DsRule.pattern(RegExp, String)',
              type: 'static DsRule<String>',
              description:
                  'Passes when RegExp.hasMatch(value) is true. Tests are '
                  'searches, not anchored matches: write anchors like ^value\$ '
                  'yourself if you mean the whole value.',
            ),
            DocsApiFact(
              name: 'DsRule.email(String)',
              type: 'static DsRule<String>',
              description:
                  'Passes when DsRule.emailPattern matches. One rule, '
                  'reading the Zod 4 email regex; strict. `a@b` fails where '
                  'HTML5\'s type="email" accepts it: the emailPattern is the '
                  'Zod 4 regex verbatim, enforcing no leading dot, no '
                  'consecutive dots, at least one dotted domain label, and a '
                  'two-or-more-letter TLD.',
            ),
            DocsApiFact(
              name: 'DsRule.accepted(String)',
              type: 'static DsRule<bool>',
              description:
                  'Passes when value == true. For checkbox terms and conditions.',
            ),
            DocsApiFact(
              name: 'DsRule.oneOf<T>(List<T>, String)',
              type: 'static DsRule<T?>',
              description:
                  'Passes when value != null and allowed.contains(value). '
                  'Use for radio groups and select dropdowns; null (untouched) '
                  'fails.',
            ),
          ],
        ),
        SizedBox(height: ds(6)),
        const DocsApiTable(
          title: 'DsRule methods and constants',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'issue(T)',
              type: 'String?',
              description:
                  'Returns message when test(value) is false, null when it '
                  'passes. Used by DsRules.check.',
            ),
            DocsApiFact(
              name: 'DsRule.emailPattern',
              type: 'static const RegExp',
              description:
                  'The Zod 4 email regex, verbatim: requires ^, no leading dot, '
                  'no .., at least one dotted domain label, and 2+ letter TLD.',
            ),
          ],
        ),
        SizedBox(height: ds(6)),
        const DocsApiTable(
          title: 'DsRules (runner)',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'DsRules.check<T>(T, List<DsRule<T>>, DsIssueMode)',
              type: 'static List<String>',
              description:
                  'Walks every rule in order, collects all failures, and '
                  'truncates to the first under DsIssueMode.first, or keeps '
                  'all under .all. Like Zod with RHF\'s criteriaMode.',
            ),
            DocsApiFact(
              name: 'DsRules.dedupe(List<String>)',
              type: 'static List<String>',
              description:
                  'Removes duplicate messages, first occurrence winning. '
                  'Matches FieldError\'s own dedupe logic.',
            ),
          ],
        ),
        SizedBox(height: ds(6)),
        const DocsApiTable(
          title: 'DsIssueMode',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'first',
              type: 'DsIssueMode',
              description:
                  'Default. DsRules.check truncates to the first failure. The '
                  'account form only renders one message, even if three checks '
                  'fail.',
            ),
            DocsApiFact(
              name: 'all',
              type: 'DsIssueMode',
              description:
                  'DsRules.check returns every failure. The password form '
                  'renders a bulleted list when multiple rules fail.',
            ),
          ],
        ),
      ],
    ),
  );

  Widget _states(DsThemeData theme) => DsSection(
    id: 'states',
    title: 'States',
    child: const DocsStateMatrix(
      facts: <DocsStateFact>[
        DocsStateFact(
          state: 'Icon: static',
          treatment:
              'Painted once at the requested size and tone token. DsIcon '
              'carries no hover, press, or focus state of its own.',
          userSignal:
              'A fixed glyph. Interaction states belong to whatever control '
              'contains it (DsButton, DsMenuItem), not to DsIcon itself.',
        ),
        DocsStateFact(
          state: 'Spinner: animating',
          treatment:
              'RotationTransition repeats forever at '
              'dsAnimationDuration(spin), 900ms by default, linear curve.',
          userSignal:
              'Continuous rotation signals work in progress. Paired with a '
              'busy control such as a loading DsButton; never announced on '
              'its own.',
        ),
        DocsStateFact(
          state: 'Spinner: reduced motion',
          treatment:
              'MediaQueryData.disableAnimations true resolves the duration '
              'to Duration.zero; the controller stops at its lower bound and '
              'holds the 0-degree (upright) frame.',
          userSignal:
              'A still glyph, still on screen, just motionless: the loading '
              'affordance is present without the spin.',
        ),
        DocsStateFact(
          state: 'DsRule: passing',
          treatment: 'issue(value) returns null.',
          userSignal:
              'No error renders. DsRules.check omits this rule from its '
              'result list.',
        ),
        DocsStateFact(
          state: 'DsRule: failing',
          treatment: 'issue(value) returns message.',
          userSignal:
              'FieldError renders the message. DsIssueMode decides whether '
              'sibling failures also render.',
        ),
      ],
    ),
  );

  Widget _accessibility(DsThemeData theme) => DsSection(
    id: 'accessibility',
    title: 'Accessibility',
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: DsWidths.prose),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DsText(
            'Icon: accessibility is mandatory, not a default. Every DsIcon '
            'either carries a label (rendered as an accessible name, '
            'announced by screen readers) or carries none and is hidden '
            'from assistive tech via ExcludeSemantics. There is no middle '
            'ground: a caller must choose. A decorative icon beside '
            'explanatory text passes label: null, hiding it entirely; an '
            'icon-only button label passes the label string.',
            DsType.body,
          ),
          SizedBox(height: ds(4)),
          DsText(
            'Spinner: a documented drift, not a decision. The reference '
            'hands its inner Icon a role="status" and an aria-label='
            '"Loading", but the reference\'s own Icon component destructures '
            'only {icon, size, tone, label, className} and spreads nothing, '
            'so both attributes are dropped on the floor there too. With no '
            'label reaching it, the glyph renders aria-hidden. DsSpinner '
            'reproduces that rendered behaviour: the glyph is wrapped in '
            'ExcludeSemantics, and DsButton carries the busy state alone, '
            'so a screen reader\'s only signal from a loading button is its '
            'aria-busy.',
            DsType.body,
          ),
          SizedBox(height: ds(4)),
          DsText(
            'DsRule: contributes no accessibility surface of its own. '
            'issue() returns a plain string; FieldError is the component '
            'that renders it and wires it to the field\'s accessible '
            'description.',
            DsType.body,
          ),
        ],
      ),
    ),
  );

  Widget _responsive(DsThemeData theme) => DsSection(
    id: 'responsive',
    title: 'Responsive',
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: DsWidths.prose),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DsText(
            'All three are stable primitives, registered in the CLI, with '
            'no platform-conditional code anywhere in icon.dart, '
            'spinner.dart or ds_rule.dart. Platforms: Android, iOS, Web, '
            'macOS, Windows, Linux, identically.',
            DsType.body,
          ),
          SizedBox(height: ds(4)),
          DsText(
            'Neither DsIcon nor DsSpinner reads MediaQuery for layout: both '
            'are fixed-size widgets that a responsive parent (a Wrap, a '
            'breakpoint-driven Row) positions. DsRule has no layout surface '
            'at all: it is pure Dart, evaluated the same way regardless of '
            'viewport.',
            DsType.body,
          ),
        ],
      ),
    ),
  );

  Widget _dependencies(DsThemeData theme) => DsSection(
    id: 'dependencies',
    title: 'Dependencies',
    child: _bullets(theme, <String>[
      'icon: lib/src/components/icon.dart (glyph painter, size/tone enums) '
          '+ icon_paths.dart (element model) + icon_paths.g.dart (1,756 '
          'glyphs, 15.9 KB, generated from lucide-react 1.28.0 ISC).',
      'spinner: lib/src/components/spinner.dart (rotating loader-circle, uses '
          'DsIcon internally).',
      'ds-rule: lib/src/components/ds_rule.dart (validation predicates, '
          'Zod-4 email regex, pure Dart).',
      'All three depend on source-foundation (theme, motion, spacing tokens).',
      'icon and spinner are used by many other components (button, input, '
          'feedback). ds-rule is used by field and form contexts.',
    ]),
  );

  Widget _theming(DsThemeData theme) => DsSection(
    id: 'theming',
    title: 'Theming',
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: DsWidths.prose),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DsText(
            'Icon: DsIconTone resolves to one of ten theme tokens through '
            'DsIcon.colorFor, never a raw colour. inherit, the default, '
            'reads DefaultTextStyle and falls back to theme.foreground, so '
            'an icon inside a coloured button or link picks up that colour '
            'without a tone override.',
            DsType.body,
          ),
          SizedBox(height: ds(4)),
          DsText(
            'Spinner: carries no tone parameter of its own; it always '
            'passes DsIconTone.inherit to the DsIcon it wraps, so it takes '
            'the surrounding text colour in both light and dark themes. Its '
            'motion, not its colour, is the themed surface: the spin '
            'duration is resolved through dsAnimationDuration(context, '
            'DsDurations.spin) on every build, the same lookup DsPress and '
            'DsKeyframePlayer use.',
            DsType.body,
          ),
          SizedBox(height: ds(4)),
          DsText(
            'DsRule: no theming surface at all. It renders nothing; the '
            'destructive/error tokens that colour a validation message are '
            'applied by FieldError, not by this file.',
            DsType.body,
          ),
        ],
      ),
    ),
  );

  Widget _source(DsThemeData theme) => DsSection(
    id: 'source',
    title: 'Source',
    child: DocsInstallFacts(
      title: 'Reference',
      facts: <DocsInstallFact>[
        DocsInstallFact(
          label: 'icon source',
          value: iconDoc.sourcePath,
          description: 'The icon component.',
        ),
        DocsInstallFact(
          label: 'spinner source',
          value: spinner_meta.spinnerDoc.sourcePath,
          description: 'The spinner component.',
        ),
        DocsInstallFact(
          label: 'ds-rule source',
          value: dsrule_meta.dsRuleDoc.sourcePath,
          description: 'The validation rule component.',
        ),
        const DocsInstallFact(
          label: 'Docs test',
          value: 'example/test/components_docs/icon_test.dart',
          description:
              'Covers this page: icon specimens at multiple sizes, '
              'spinner animation under normal and reduced motion, and '
              'ds-rule matching.',
        ),
        const DocsInstallFact(
          label: 'Edit these docs',
          value: 'example/lib/components_docs/icon/page.dart',
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
