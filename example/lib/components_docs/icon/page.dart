/// Public documentation page for the icon, spinner, and ds_rule components.
///
/// Three small primitives documented together:
///
/// * **icon** — Lucide glyph renderer with size and tone ladders.
/// * **spinner** — Rotating loader-circle, 16px, loops forever.
/// * **ds-rule** — Validation rule predicate with static factory methods.
///
/// All three carry real registry manifests with identical dependencies
/// (`source-foundation`), so installation sections render the actual
/// `elattar add` commands.
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
      DocsTocEntry(title: 'Icon overview', anchor: 'icon-overview'),
      DocsTocEntry(title: 'Icon preview', anchor: 'icon-preview'),
      DocsTocEntry(title: 'Icon API', anchor: 'icon-api'),
      DocsTocEntry(title: 'Spinner overview', anchor: 'spinner-overview'),
      DocsTocEntry(title: 'Spinner preview', anchor: 'spinner-preview'),
      DocsTocEntry(title: 'Spinner API', anchor: 'spinner-api'),
      DocsTocEntry(title: 'DsRule overview', anchor: 'dsrule-overview'),
      DocsTocEntry(title: 'DsRule API', anchor: 'dsrule-api'),
      DocsTocEntry(title: 'Installation', anchor: 'install'),
      DocsTocEntry(title: 'Dependencies', anchor: 'dependencies'),
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
        _iconOverview(theme),
        _iconPreview(),
        _iconApi(),
        SizedBox(height: ds(8)),
        _spinnerOverview(theme),
        _spinnerPreview(),
        _spinnerApi(theme),
        SizedBox(height: ds(8)),
        _dsRuleOverview(theme),
        _dsRuleApi(theme),
        SizedBox(height: ds(8)),
        _install(),
        _dependencies(theme),
        _source(theme),
      ],
    );
  }

  // ── ICON SECTION ──────────────────────────────────────────────────────────

  Widget _iconOverview(DsThemeData theme) => DsSection(
    id: 'icon-overview',
    title: 'Icon',
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: DsWidths.prose),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DsText(
            'DsIcon renders one lucide glyph, 24×24 in lucide\'s 24-unit grid, '
            'at one of seven fixed sizes and one of ten tones. The 1,756-glyph '
            'lucide-react 1.28.0 set (ISC license) is embedded verbatim in '
            '`icon_paths.g.dart` — no icon font, no font hinting — and painted '
            'as stroked paths at the requested size and tone.',
            DsType.body,
          ),
          SizedBox(height: ds(4)),
          DsText(
            'Accessibility is mandatory: every icon either carries a label '
            '(rendered as an accessible name, announced by screen readers) or '
            'carries none and is hidden from assistive tech. There is no '
            'middle ground and no default — a caller must choose. A decorative '
            'icon beside explanatory text passes `label: null`, hiding it '
            'entirely; an icon-only button label passes the label string.',
            DsType.body,
          ),
          SizedBox(height: ds(4)),
          DsText(
            'Status: stable primitive, registered in the CLI. Platforms: '
            'Android, iOS, Web, macOS, Windows, Linux — no platform-conditional '
            'code in icon.dart.',
            DsType.small,
            color: theme.mutedForeground,
          ),
        ],
      ),
    ),
  );

  Widget _iconPreview() => DsSection(
    id: 'icon-preview',
    title: 'Preview',
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

  Widget _iconApi() => DsSection(
    id: 'icon-api',
    title: 'Icon API',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const DocsApiTable(
          title: 'DsIcon constructor',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'glyph',
              type: 'DsIconGlyph',
              description:
                  'Required (primary constructor). The curated glyph from '
                  'the whitelist — menu, search, star, check, x, and 59 others.',
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
          title: 'Static methods and constants',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'DsIcon.pxFor(DsIconSize)',
              type: 'static double',
              description:
                  'Returns the pixel size for a rung: xs→12, sm→14, md→16, '
                  'lg→20, xl→24, xl2→32, xl3→40.',
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
      ],
    ),
  );

  // ── SPINNER SECTION ────────────────────────────────────────────────────────

  Widget _spinnerOverview(DsThemeData theme) => DsSection(
    id: 'spinner-overview',
    title: 'Spinner',
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: DsWidths.prose),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DsText(
            'DsSpinner is a 16px rotating loader-circle icon that spins once '
            'every 900ms, forever, using a linear easing curve (no ease-in or '
            'ease-out). It is mute — no aria-label, no role="status" — because '
            'the reference drops both in its destructure. A loading button '
            'carries the busy state instead.',
            DsType.body,
          ),
          SizedBox(height: ds(4)),
          DsText(
            'When prefers-reduced-motion is active, the spinner does not stop '
            'existing — it completes one 0.01ms rotation and holds the upright '
            '(0°) frame, still, forever. This reproduces the reference\'s '
            'animation-iteration-count: 1 behaviour under reduced motion.',
            DsType.body,
          ),
          SizedBox(height: ds(4)),
          DsText(
            'Status: stable primitive, registered in the CLI. Platforms: '
            'Android, iOS, Web, macOS, Windows, Linux — animation-duration is '
            'resolved through dsAnimationDuration(context) for every frame.',
            DsType.small,
            color: theme.mutedForeground,
          ),
        ],
      ),
    ),
  );

  Widget _spinnerPreview() => DsSection(
    id: 'spinner-preview',
    title: 'Preview',
    description:
        'A spinner at its default size (16px), rotating continuously. Tests '
        'use tester.pump(), never pumpAndSettle(), because it loops forever.',
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
              '// Default: 16px, loops forever.\n'
              'const DsSpinner loading = DsSpinner();\n\n'
              '// Larger size, same stroke.\n'
              'const DsSpinner large = DsSpinner(size: 24);',
        ),
      ],
    ),
  );

  Widget _spinnerApi(DsThemeData theme) => DsSection(
    id: 'spinner-api',
    title: 'Spinner API',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const DocsApiTable(
          title: 'DsSpinner constructor',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'size',
              type: 'double',
              description:
                  'Defaults to DsSpinner.px (16.0). The rendered square size. '
                  'The stroke stays 2.4 regardless — see strokeOverride.',
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
          title: 'Static constant',
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
        SizedBox(height: ds(6)),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: DsWidths.prose),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DsText(
                'Reduced motion: When MediaQueryData.disableAnimations is true, '
                'the spinner completes one frame and stops. The animation '
                'duration becomes Duration.zero, the controller stops at its '
                'lower bound, and the loader-circle holds the 0° (upright) '
                'frame. It is still in the widget tree, still painted, still a '
                '16px square — it is just still.',
                DsType.small,
                color: theme.mutedForeground,
              ),
            ],
          ),
        ),
      ],
    ),
  );

  // ── DSRULE SECTION ─────────────────────────────────────────────────────────

  Widget _dsRuleOverview(DsThemeData theme) => DsSection(
    id: 'dsrule-overview',
    title: 'DsRule',
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: DsWidths.prose),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DsText(
            'DsRule is the validation-rule primitive — a predicate and an error '
            'message — not a horizontal divider. A `DsRule<T>` holds a test '
            'function and the sentence it renders when a value fails. A list of '
            'rules is what a schema is: ordered checks against one field, '
            'yielding all failures in declaration order or only the first, '
            'depending on DsIssueMode.',
            DsType.body,
          ),
          SizedBox(height: ds(4)),
          DsText(
            'Every rule is a static factory method that takes a message: '
            'DsRule.minLength(3, "At least 3 characters."), '
            'DsRule.email("That is not an email address."), '
            'DsRule.pattern(RegExp(...), "message"). These are static methods, '
            'not constructors, so they cannot appear inside a const expression — '
            'each rule is a new instance.',
            DsType.body,
          ),
          SizedBox(height: ds(4)),
          DsText(
            'The emailPattern is Zod 4\'s regex verbatim and enforces '
            'four constraints: no leading dot, no consecutive dots, at least '
            'one dotted domain label, and a two-or-more-letter TLD. So `a@b` '
            'fails where HTML5\'s type="email" accepts it — loosening the regex '
            'by one character changes which keystroke makes the error disappear.',
            DsType.body,
          ),
          SizedBox(height: ds(4)),
          DsText(
            'Status: stable primitive, registered in the CLI. Platforms: '
            'Android, iOS, Web, macOS, Windows, Linux — pure Dart, no platform '
            'gates.',
            DsType.small,
            color: theme.mutedForeground,
          ),
        ],
      ),
    ),
  );

  Widget _dsRuleApi(DsThemeData theme) => DsSection(
    id: 'dsrule-api',
    title: 'DsRule API',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const DocsApiTable(
          title: 'DsRule<T> constructor',
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
          title: 'Static factory methods',
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
                  'searches, not anchored matches — write anchors like ^value\$ '
                  'yourself if you mean the whole value.',
            ),
            DocsApiFact(
              name: 'DsRule.email(String)',
              type: 'static DsRule<String>',
              description:
                  'Passes when DsRule.emailPattern matches. One rule, '
                  'reading the Zod 4 email regex; strict.',
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
          title: 'Methods and constants',
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

  Widget _dependencies(DsThemeData theme) => DsSection(
    id: 'dependencies',
    title: 'Dependencies and files',
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

  Widget _source(DsThemeData theme) => DsSection(
    id: 'source',
    title: 'Source, tests, and docs',
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
