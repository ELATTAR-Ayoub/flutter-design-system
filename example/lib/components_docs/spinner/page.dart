/// Public documentation page for the `spinner` component, alone.
///
/// **Split from a three-component page.** `icon`, `spinner` and `rule`
/// used to share one route (`components_docs/icon/page.dart`). Spinner now
/// gets its own file, reshaped to mirror
/// https://ui.shadcn.com/docs/components/base/spinner's own literal section
/// list: Usage, Size, Button, Badge, Input Group, Empty, RTL, Customization,
/// API Reference. Installation is added ahead of Usage to match this
/// package's own shape (`../button/page.dart`); shadcn's spinner page has no
/// Installation heading of its own because that reference bundles spinner
/// into every registry install rather than shipping it standalone.
///
/// **Skipped, honestly: Customization only.** The reference's Customization
/// section edits `spinner.tsx` itself to swap its inline `<LoaderIcon>` for a
/// different lucide icon; [ElSpinner]'s constructor is `ElSpinner({size,
/// strokeOverride})`, no `icon` or `glyph` parameter at all, and `build()`
/// hardcodes `ElIcon(ElIconGlyph.loaderCircle, ...)`, so there is no
/// equivalent surface to demonstrate without forking `spinner.dart`. Button,
/// Badge, Input Group, Empty and RTL are all real compositions of components
/// this package has ([ElButton], [ElBadge], [ElInputGroup], [ElEmpty], and a
/// plain [Directionality] wrapper), and are kept, in the reference's own
/// order.
///
/// **Shape.** An unheaded live demo, then Installation, then Usage, then
/// the reference's own sections, then API Reference last (one prop table
/// per class), then exactly States, Accessibility, Responsive, Dependencies,
/// Theming, Source.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/docs_code.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../kit.dart';
import 'meta.dart';

class SpinnerDocPage extends StatelessWidget {
  const SpinnerDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: spinnerDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / PRIMITIVES',
      title: spinnerDoc.title,
      description: spinnerDoc.description,
    ),
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Components'),
      ElBreadcrumbEntry.page('Spinner'),
    ],
    toc: const <DocsTocEntry>[
      DocsTocEntry(title: 'Installation', anchor: 'install'),
      DocsTocEntry(title: 'Usage', anchor: 'usage'),
      DocsTocEntry(title: 'Size', anchor: 'size'),
      DocsTocEntry(title: 'Button', anchor: 'button'),
      DocsTocEntry(title: 'Badge', anchor: 'badge'),
      DocsTocEntry(title: 'Input Group', anchor: 'input-group'),
      DocsTocEntry(title: 'Empty', anchor: 'empty'),
      DocsTocEntry(title: 'RTL', anchor: 'rtl'),
      DocsTocEntry(
        title: 'API Reference',
        anchor: 'api',
        children: <DocsTocEntry>[
          DocsTocEntry(title: 'ElSpinner', anchor: 'api-elspinner'),
          DocsTocEntry(
            title: 'ElSpinner static constant',
            anchor: 'api-elspinner-static',
          ),
        ],
      ),
      DocsTocEntry(title: 'States', anchor: 'states'),
      DocsTocEntry(title: 'Accessibility', anchor: 'accessibility'),
      DocsTocEntry(title: 'Responsive', anchor: 'responsive'),
      DocsTocEntry(title: 'Dependencies', anchor: 'dependencies'),
      DocsTocEntry(title: 'Theming', anchor: 'theming'),
      DocsTocEntry(title: 'Source', anchor: 'source'),
    ],
    onNavigate: onNavigate,
    child: const _SpinnerArticle(),
  );
}

class _SpinnerArticle extends StatelessWidget {
  const _SpinnerArticle();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      key: const ValueKey<String>('spinner-doc-article'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _heroDemo(),
        SizedBox(height: el(6)),
        _install(),
        SizedBox(height: el(6)),
        _usage(),
        _size(),
        _button(),
        _badge(),
        _inputGroup(),
        _empty(),
        _rtl(),
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

  // ── LIVE DEMO (unheaded) ────────────────────────────────────────────────

  Widget _heroDemo() => DocsCodeExample(
    title: 'Spinner',
    description: 'The default 16px ElSpinner, rotating forever.',
    preview: const Center(child: ElSpinner()),
    manualFiles: const <DocsCodeFile>[
      DocsCodeFile(
        path: 'lib/components/ui/spinner.dart',
        code:
            "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
            'const ElSpinner loading = ElSpinner();',
      ),
    ],
  );

  // ── SHARED SECTIONS ────────────────────────────────────────────────────

  Widget _install() => ElSection(
    id: 'install',
    title: 'Installation',
    description:
        'spinner has a real registry manifest, `elattar add spinner` '
        'installs lib/src/components/spinner.dart and resolves icon and '
        'source-foundation automatically.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DocsCodeExample(
          title: 'Install spinner',
          command: DocsCodeCommand(
            command: spinnerDoc.command,
            description: 'Installs spinner.dart, requires icon.',
          ),
          manualFiles: const <DocsCodeFile>[
            DocsCodeFile(
              path: 'lib/components/ui/spinner.dart',
              title: '1. Copy the source',
              description:
                  "Copy spinner.dart's generated payload into components/ui.",
              code:
                  "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
                  '// Copy the generated spinner source here when using manual mode.',
            ),
            DocsCodeFile(
              path: 'lib/components/ui/ui.dart',
              title: '2. Export it from your barrel',
              description: 'Add the export line so ElSpinner is reachable.',
              code: "export 'spinner.dart';",
            ),
          ],
        ),
        SizedBox(height: el(5)),
        DocsInstallFacts(
          title: 'Manual install facts',
          facts: <DocsInstallFact>[
            DocsInstallFact(
              label: 'Registry dependencies',
              value: spinnerDoc.dependencies.join(', '),
              description:
                  "registry/components/spinner.json's own "
                  'registryDependencies, verbatim.',
            ),
            const DocsInstallFact(
              label: 'Manual copy target',
              value: 'lib/components/ui/spinner.dart',
              description: 'Where the CLI itself would place the file.',
            ),
            const DocsInstallFact(
              label: 'Semantic dependency',
              value: 'icon',
              description:
                  'spinner.dart imports icon.dart directly: ElSpinner is a '
                  'ElIcon(ElIconGlyph.loaderCircle, ...) wrapped in a '
                  'RotationTransition.',
            ),
          ],
        ),
      ],
    ),
  );

  Widget _usage() => ElSection(
    id: 'usage',
    title: 'Usage',
    description:
        'ElSpinner is a 16px rotating loader-circle icon that spins once '
        'every 900ms, forever, using a linear easing curve, no ease-in or '
        'ease-out. It is mute: no aria-label, no role="status", because the '
        'reference drops both in its own destructure. A loading button '
        'carries the busy state instead.',
    child: ElPanel(
      label: 'DART',
      note: 'MINIMAL',
      child: DocsSelectableCodeBlock(code: _usageCode),
    ),
  );

  Widget _size() => ElSection(
    id: 'size',
    title: 'Size',
    description:
        'A spinner at its default size (16px) and one at 24px, both '
        'rotating continuously. Tests use tester.pump(), never '
        'pumpAndSettle(), because the animation loops forever.',
    child: DocsCodeExample(
      title: 'Spinner specimen',
      preview: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ElText('Default (16px, 900ms cycle)', ElType.label),
            SizedBox(height: el(3)),
            const ElSpinner(),
            SizedBox(height: el(5)),
            ElText('Larger size (24px)', ElType.label),
            SizedBox(height: el(3)),
            const ElSpinner(size: 24),
          ],
        ),
      ),
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/spinner.dart',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Larger size, same stroke as the default.\n'
              'const ElSpinner large = ElSpinner(size: 24);',
        ),
      ],
    ),
  );

  Widget _button() => ElSection(
    id: 'button',
    title: 'Button',
    description:
        'The reference composes a Spinner child by hand and tags it '
        'data-icon="inline-start" or "inline-end" for spacing on either '
        'side of the label. ElButton\'s loading flag does the inline-start '
        'case natively: it prepends a ElSpinner and disables the button. '
        'The inline-end case has no dedicated flag, so it is a caller-built '
        'row instead.',
    child: DocsCodeExample(
      title: 'Spinner in a button',
      preview: Wrap(
        spacing: el(4),
        runSpacing: el(4),
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          ElButton(
            loading: true,
            onPressed: () {},
            child: const Text('Loading...'),
          ),
          ElButton(
            variant: ElButtonVariant.secondary,
            onPressed: () {},
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text('Processing'),
                SizedBox(width: ElButton.gapFor(ElButtonSize.md)),
                const ElSpinner(),
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
              'ElButton(\n'
              '  loading: true,\n'
              '  onPressed: () {},\n'
              "  child: const Text('Loading...'),\n"
              ')',
        ),
      ],
    ),
  );

  Widget _badge() => ElSection(
    id: 'badge',
    title: 'Badge',
    description:
        'ElBadge\'s glyph slot takes any widget, not only a ElIconGlyph: a '
        'ElSpinner passed there is squeezed into the same 12px square an '
        'icon fills, with the usual 4px gap before the label.',
    child: DocsCodeExample(
      title: 'Spinner in a badge',
      preview: Wrap(
        spacing: el(3),
        runSpacing: el(3),
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          ElBadge(
            label: 'Syncing',
            variant: ElBadgeVariant.secondary,
            glyph: ElSpinner(size: ElBadge.glyphSize),
          ),
          ElBadge(
            label: 'Updating',
            variant: ElBadgeVariant.action,
            glyph: ElSpinner(size: ElBadge.glyphSize),
          ),
        ],
      ),
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/badge.dart',
          code:
              "ElBadge(\n"
              "  label: 'Syncing',\n"
              '  variant: ElBadgeVariant.secondary,\n'
              '  glyph: ElSpinner(size: ElBadge.glyphSize),\n'
              ')',
        ),
      ],
    ),
  );

  Widget _inputGroup() => ElSection(
    id: 'input-group',
    title: 'Input Group',
    description:
        'An addon takes any widget too: a ElSpinner sized to the group\'s '
        'own 16px icon rung signals validation in progress without a '
        'status message of its own.',
    child: DocsCodeExample(
      title: 'Spinner in an input group',
      preview: ElInputGroup(
        endAddon: ElInputGroupAddon(
          align: ElInputGroupAlign.end,
          child: ElSpinner(size: ElIcon.pxFor(ElIconSize.sm)),
        ),
        enabled: false,
        child: ElInputGroupInput(placeholder: 'Validating...'),
      ),
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/input_group.dart',
          code:
              'ElInputGroup(\n'
              '  endAddon: ElInputGroupAddon(\n'
              '    align: ElInputGroupAlign.end,\n'
              '    child: ElSpinner(size: ElIcon.pxFor(ElIconSize.sm)),\n'
              '  ),\n'
              '  enabled: false,\n'
              "  child: ElInputGroupInput(placeholder: 'Validating...'),\n"
              ')',
        ),
      ],
    ),
  );

  Widget _empty() => ElSection(
    id: 'empty',
    title: 'Empty',
    description:
        'ElEmptyMedia only takes a ElIconGlyph, so a spinner cannot fill '
        'its tile. ElEmptyHeader\'s children list takes any widget, so the '
        'spinner sits there directly instead, ahead of the title and '
        'description, the way the reference\'s EmptyMedia would.',
    child: DocsCodeExample(
      title: 'Spinner in an empty state',
      preview: ElEmpty(
        children: <Widget>[
          ElEmptyHeader(
            children: <Widget>[
              const ElSpinner(size: 24),
              const ElEmptyTitle('Processing your request'),
              const ElEmptyDescription(
                'This can take a few moments. Please keep this window open.',
              ),
            ],
          ),
          ElEmptyContent(
            children: <Widget>[
              ElButton(
                variant: ElButtonVariant.outline,
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
              'ElEmpty(\n'
              '  children: <Widget>[\n'
              '    ElEmptyHeader(\n'
              '      children: <Widget>[\n'
              '        ElSpinner(size: 24),\n'
              "        ElEmptyTitle('Processing your request'),\n"
              '      ],\n'
              '    ),\n'
              '  ],\n'
              ')',
        ),
      ],
    ),
  );

  Widget _rtl() => ElSection(
    id: 'rtl',
    title: 'RTL',
    description:
        'ElSpinner paints identically under either text direction: a '
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
            const ElSpinner(),
            SizedBox(width: el(2)),
            ElText('جارٍ التحميل', ElType.body),
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
              '      const ElSpinner(),\n'
              "      ElText('جارٍ التحميل', ElType.body),\n"
              '    ],\n'
              '  ),\n'
              ')',
        ),
      ],
    ),
  );

  Widget _api() => ElSection(
    id: 'api',
    title: 'API Reference',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        KeyedSubtree(
          key: docsAnchorKey('api-elspinner'),
          child: const DocsApiTable(
            title: 'ElSpinner properties',
            facts: <DocsApiFact>[
              DocsApiFact(
                name: 'size',
                type: 'double',
                description:
                    'Defaults to ElSpinner.px (16.0). The rendered square '
                    'size. The stroke stays 2.4 regardless: see '
                    'strokeOverride.',
              ),
              DocsApiFact(
                name: 'strokeOverride',
                type: 'double?',
                description:
                    'The stroke width in lucide\'s 24-unit space. Null '
                    'means 2.4 always (ElIcon.strokeFor(16)\'s result), '
                    'matching the reference\'s off-ladder behaviour: the '
                    'reference computes strokeWidth from the size **prop** '
                    '(always "md"), never from the className that changes '
                    'the rendered box. Use this only if the reference needs '
                    'a different stroke.',
              ),
            ],
          ),
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-elspinner-static'),
          child: const DocsApiTable(
            title: 'ElSpinner static constant',
            facts: <DocsApiFact>[
              DocsApiFact(
                name: 'ElSpinner.px',
                type: 'static const double',
                description:
                    'The default size, 16.0, named because it matches the '
                    '`size-4` Tailwind class the reference uses, and because '
                    'ElButton reasons about it directly: a loading button '
                    'grows by ElSpinner.px + gapFor(size) the instant '
                    'loading starts.',
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _states() => ElSection(
    id: 'states',
    title: 'States',
    child: const DocsStateMatrix(
      facts: <DocsStateFact>[
        DocsStateFact(
          state: 'Animating',
          treatment:
              'RotationTransition repeats forever at '
              'elAnimationDuration(context, ElDurations.spin), 900ms by '
              'default, linear curve: the one animation in the system that '
              'takes no --ease-* curve.',
          userSignal:
              'Continuous rotation signals work in progress. Paired with a '
              'busy control such as a loading ElButton; never announced on '
              'its own.',
        ),
        DocsStateFact(
          state: 'Reduced motion',
          treatment:
              'MediaQueryData.disableAnimations true resolves the duration '
              'to Duration.zero; the controller stops at its lower bound '
              'and holds the 0-degree (upright) frame, the same frame the '
              'reference\'s own animation-iteration-count: 1 collapse '
              'leaves it on.',
          userSignal:
              'A still glyph, still on screen, just motionless: the '
              'loading affordance is present without the spin.',
        ),
      ],
    ),
  );

  Widget _accessibility(ElThemeData theme) => ElSection(
    id: 'accessibility',
    title: 'Accessibility',
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: ElWidths.prose),
      child: ElText(
        'A documented drift, not a decision. The reference hands its inner '
        'Icon a role="status" and an aria-label="Loading", but the '
        'reference\'s own Icon component destructures only {icon, size, '
        'tone, label, className} and spreads nothing, so both attributes '
        'are dropped on the floor there too. With no label reaching it, '
        'the glyph renders aria-hidden. ElSpinner reproduces that rendered '
        'behaviour: the glyph is wrapped in ExcludeSemantics, and ElButton '
        'carries the busy state alone, so a screen reader\'s only signal '
        'from a loading button is its aria-busy.',
        ElType.body,
      ),
    ),
  );

  Widget _responsive(ElThemeData theme) => ElSection(
    id: 'responsive',
    title: 'Responsive',
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: ElWidths.prose),
      child: ElText(
        'No platform-conditional code anywhere in spinner.dart: Android, '
        'iOS, Web, macOS, Windows, and Linux all render the same widget '
        'tree. ElSpinner does not read MediaQuery for layout, only for '
        'disableAnimations: it is a fixed-size widget that a responsive '
        'parent positions.',
        ElType.body,
      ),
    ),
  );

  Widget _dependencies(ElThemeData theme) => ElSection(
    id: 'dependencies',
    title: 'Dependencies',
    child: _bullets(theme, <String>[
      'File: lib/src/components/spinner.dart, one file, no companions.',
      'Imports icon.dart directly: ElSpinner wraps a '
          'ElIcon(ElIconGlyph.loaderCircle, ...) in a RotationTransition.',
      'registryDependencies, resolved automatically by `elattar add '
          'spinner`: source-foundation (motion tokens, theme_scope).',
      'Used by many other components as a loading affordance: button, '
          'badge, input group, empty.',
    ]),
  );

  Widget _theming(ElThemeData theme) => ElSection(
    id: 'theming',
    title: 'Theming',
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: ElWidths.prose),
      child: ElText(
        'Carries no tone parameter of its own; it always passes '
        'ElIconTone.inherit to the ElIcon it wraps, so it takes the '
        'surrounding text colour in both light and dark themes. Its '
        'motion, not its colour, is the themed surface: the spin duration '
        'is resolved through elAnimationDuration(context, ElDurations.spin) '
        'on every build, the same lookup ElPress and ElKeyframePlayer use.',
        ElType.body,
      ),
    ),
  );

  Widget _source() => ElSection(
    id: 'source',
    title: 'Source',
    child: DocsInstallFacts(
      title: 'Reference',
      facts: <DocsInstallFact>[
        DocsInstallFact(
          label: 'Source',
          value: spinnerDoc.sourcePath,
          description: 'The spinner component.',
        ),
        const DocsInstallFact(
          label: 'Package tests',
          value: 'test/components_test.dart',
          description:
              'ElSpinner is covered inside the shared base-components '
              'suite.',
        ),
        const DocsInstallFact(
          label: 'Docs test',
          value: 'example/test/components_docs/spinner_test.dart',
          description:
              'Covers this page: every composed example, the API table, '
              'and rotation under normal and reduced motion.',
        ),
        const DocsInstallFact(
          label: 'Edit these docs',
          value: 'example/lib/components_docs/spinner/page.dart',
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
import 'package:elattar_design_system/elattar_design_system.dart';

// Default: 16px, loops forever.
const ElSpinner loading = ElSpinner();''';
