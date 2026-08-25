/// Public documentation page for the `spinner` component, alone.
///
/// **Re-housed onto the kit.** This page used to hand-compose [ElSection]
/// panels shaped to mirror
/// https://ui.shadcn.com/docs/components/base/spinner's own section list; it
/// now declares a [ComponentDocSpec] (`example/lib/docs/
/// component_doc_page.dart`) and hands it to [ComponentDocPage], the same
/// shape `button`, `field`, `popover`, `alert` and `toaster` established.
/// Every specimen widget and every code string below is the same one the
/// hand-composed page carried; new in this pass: the old unheaded live demo
/// is now a real Preview section with its own rail entry, and a dedicated
/// Keyboard disclosure.
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
/// **Shape.** Preview, Installation, Usage, then the reference's own
/// sections, then API Reference (one prop table per class), then the eight
/// disclosures.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/component_doc_page.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import 'meta.dart';

final ComponentDocSpec spinnerDocSpec = ComponentDocSpec(
  name: 'spinner',
  title: spinnerDoc.title,
  description: spinnerDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description: 'The default 16px ElSpinner, rotating forever.',
      specimen: _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'spinner has a real registry manifest, `elattar add spinner` '
          'installs lib/src/components/spinner.dart and resolves icon and '
          'source-foundation automatically. The Manual tab is for a '
          'project not using the CLI.',
      command: spinnerDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/spinner.dart',
          title: '1. Copy the source',
          description:
              "Copy spinner.dart's generated payload into components/ui.",
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated spinner source here when using '
              'manual mode.',
        ),
        const DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description: 'Add the export line so ElSpinner is reachable.',
          code: "export 'spinner.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'ElSpinner is a 16px rotating loader-circle icon that spins '
          'once every 900ms, forever, using a linear easing curve, no '
          'ease-in or ease-out. It is mute: no aria-label, no '
          'role="status", because the reference drops both in its own '
          'destructure. A loading button carries the busy state instead.',
      code: _usageCode,
    ),
    ShowcaseSection(
      id: 'size',
      title: 'Size',
      description:
          'A spinner at its default size (16px) and one at 24px, both '
          'rotating continuously. Tests use tester.pump(), never '
          'pumpAndSettle(), because the animation loops forever.',
      specimen: _SizeSpecimen(),
      code: _sizeCode,
      label: 'Size specimen view',
    ),
    ShowcaseSection(
      id: 'button',
      title: 'Button',
      description:
          'The reference composes a Spinner child by hand and tags it '
          'data-icon="inline-start" or "inline-end" for spacing on '
          'either side of the label. ElButton\'s loading flag does the '
          'inline-start case natively: it prepends a ElSpinner and '
          'disables the button. The inline-end case has no dedicated '
          'flag, so it is a caller-built row instead.',
      specimen: _ButtonSpecimen(),
      code: _buttonCode,
      label: 'Button specimen view',
    ),
    ShowcaseSection(
      id: 'badge',
      title: 'Badge',
      description:
          'ElBadge\'s glyph slot takes any widget, not only a '
          'ElIconGlyph: a ElSpinner passed there is squeezed into the '
          'same 12px square an icon fills, with the usual 4px gap '
          'before the label.',
      specimen: _BadgeSpecimen(),
      code: _badgeCode,
      label: 'Badge specimen view',
    ),
    ShowcaseSection(
      id: 'input-group',
      title: 'Input Group',
      description:
          'An addon takes any widget too: a ElSpinner sized to the '
          'group\'s own 16px icon rung signals validation in progress '
          'without a status message of its own.',
      specimen: _InputGroupSpecimen(),
      code: _inputGroupCode,
      label: 'Input Group specimen view',
    ),
    ShowcaseSection(
      id: 'empty',
      title: 'Empty',
      description:
          'ElEmptyMedia only takes a ElIconGlyph, so a spinner cannot '
          'fill its tile. ElEmptyHeader\'s children list takes any '
          'widget, so the spinner sits there directly instead, ahead of '
          'the title and description, the way the reference\'s '
          'EmptyMedia would.',
      specimen: _EmptySpecimen(),
      code: _emptyCode,
      label: 'Empty specimen view',
      minHeight: el(120),
    ),
    ShowcaseSection(
      id: 'rtl',
      title: 'RTL',
      description:
          'ElSpinner paints identically under either text direction: a '
          'rotating circle has no logical edges to mirror. What does '
          'mirror is the composition around it, under the same '
          'Directionality.rtl that Toggle, Progress and Pagination each '
          'demonstrate on their own pages: a Row lays its children '
          'start-to-end along the ambient direction, so the spinner and '
          'its label swap physical sides without either widget reading '
          'direction itself.',
      specimen: _RtlSpecimen(),
      code: _rtlCode,
      label: 'RTL specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      child: DocsStateMatrix(facts: _stateFacts),
    ),
    DisclosureSection(
      id: 'accessibility',
      title: 'Accessibility',
      description:
          'A documented drift, not a decision -- read straight off '
          'spinner.dart\'s own docstring.',
      child: _AccessibilityContent(),
    ),
    DisclosureSection(
      id: 'keyboard',
      title: 'Keyboard',
      description:
          'ElSpinner is never in the tab order and answers no key '
          'press: it is a decorative glyph, not an interactive control.',
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
                'Covers this page: every composed example, the API '
                'table, and rotation under normal and reduced motion.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/spinner/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

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
    toc: spinnerDocSpec.toc,
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('spinner-doc-article'),
      child: ComponentDocPage(spec: spinnerDocSpec, header: false),
    ),
  );
}

/* ── Showcase specimens ─────────────────────────────────────────────────── */

class _PreviewSpecimen extends StatelessWidget {
  const _PreviewSpecimen();

  @override
  Widget build(BuildContext context) => const KeyedSubtree(
    key: ValueKey<String>('spinner-example:preview'),
    child: ElSpinner(),
  );
}

const String _previewCode =
    "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
    'const ElSpinner loading = ElSpinner();';

const String _usageCode = '''
import 'package:elattar_design_system/elattar_design_system.dart';

// Default: 16px, loops forever.
const ElSpinner loading = ElSpinner();''';

class _SizeSpecimen extends StatelessWidget {
  const _SizeSpecimen();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      ElText('Default (16px, 900ms cycle)', ElType.section),
      SizedBox(height: el(3)),
      const KeyedSubtree(
        key: ValueKey<String>('spinner-example:size-default'),
        child: ElSpinner(),
      ),
      SizedBox(height: el(5)),
      ElText('Larger size (24px)', ElType.section),
      SizedBox(height: el(3)),
      const KeyedSubtree(
        key: ValueKey<String>('spinner-example:size-large'),
        child: ElSpinner(size: 24),
      ),
    ],
  );
}

const String _sizeCode =
    "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
    '// Larger size, same stroke as the default.\n'
    'const ElSpinner large = ElSpinner(size: 24);';

class _ButtonSpecimen extends StatelessWidget {
  const _ButtonSpecimen();

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: el(4),
    runSpacing: el(4),
    crossAxisAlignment: WrapCrossAlignment.center,
    children: <Widget>[
      KeyedSubtree(
        key: const ValueKey<String>('spinner-example:button-loading'),
        child: ElButton(
          loading: true,
          onPressed: () {},
          child: const Text('Loading...'),
        ),
      ),
      KeyedSubtree(
        key: const ValueKey<String>('spinner-example:button-inline-end'),
        child: ElButton(
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
      ),
    ],
  );
}

const String _buttonCode =
    "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
    'ElButton(\n'
    '  loading: true,\n'
    '  onPressed: () {},\n'
    "  child: const Text('Loading...'),\n"
    ')';

class _BadgeSpecimen extends StatelessWidget {
  const _BadgeSpecimen();

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: el(3),
    runSpacing: el(3),
    crossAxisAlignment: WrapCrossAlignment.center,
    children: <Widget>[
      KeyedSubtree(
        key: const ValueKey<String>('spinner-example:badge-secondary'),
        child: ElBadge(
          label: 'Syncing',
          variant: ElBadgeVariant.secondary,
          glyph: ElSpinner(size: ElBadge.glyphSize),
        ),
      ),
      KeyedSubtree(
        key: const ValueKey<String>('spinner-example:badge-action'),
        child: ElBadge(
          label: 'Updating',
          variant: ElBadgeVariant.action,
          glyph: ElSpinner(size: ElBadge.glyphSize),
        ),
      ),
    ],
  );
}

const String _badgeCode =
    "ElBadge(\n"
    "  label: 'Syncing',\n"
    '  variant: ElBadgeVariant.secondary,\n'
    '  glyph: ElSpinner(size: ElBadge.glyphSize),\n'
    ')';

class _InputGroupSpecimen extends StatelessWidget {
  const _InputGroupSpecimen();

  @override
  Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<String>('spinner-example:input-group'),
    child: ElInputGroup(
      endAddon: ElInputGroupAddon(
        align: ElInputGroupAlign.end,
        child: ElSpinner(size: ElIcon.pxFor(ElIconSize.sm)),
      ),
      enabled: false,
      child: const ElInputGroupInput(placeholder: 'Validating...'),
    ),
  );
}

const String _inputGroupCode =
    'ElInputGroup(\n'
    '  endAddon: ElInputGroupAddon(\n'
    '    align: ElInputGroupAlign.end,\n'
    '    child: ElSpinner(size: ElIcon.pxFor(ElIconSize.sm)),\n'
    '  ),\n'
    '  enabled: false,\n'
    "  child: ElInputGroupInput(placeholder: 'Validating...'),\n"
    ')';

class _EmptySpecimen extends StatelessWidget {
  const _EmptySpecimen();

  @override
  Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<String>('spinner-example:empty'),
    child: ElEmpty(
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
  );
}

const String _emptyCode =
    'ElEmpty(\n'
    '  children: <Widget>[\n'
    '    ElEmptyHeader(\n'
    '      children: <Widget>[\n'
    '        ElSpinner(size: 24),\n'
    "        ElEmptyTitle('Processing your request'),\n"
    '      ],\n'
    '    ),\n'
    '  ],\n'
    ')';

class _RtlSpecimen extends StatelessWidget {
  const _RtlSpecimen();

  @override
  Widget build(BuildContext context) => Directionality(
    key: const ValueKey<String>('spinner-example:rtl'),
    textDirection: TextDirection.rtl,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const ElSpinner(),
        SizedBox(width: el(2)),
        ElText('جارٍ التحميل', ElType.body),
      ],
    ),
  );
}

const String _rtlCode =
    'Directionality(\n'
    '  textDirection: TextDirection.rtl,\n'
    '  child: Row(\n'
    '    mainAxisSize: MainAxisSize.min,\n'
    '    children: <Widget>[\n'
    '      const ElSpinner(),\n'
    "      ElText('جارٍ التحميل', ElType.body),\n"
    '    ],\n'
    '  ),\n'
    ')';

/* ── Disclosure content ─────────────────────────────────────────────────── */

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsApiTable(
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
      SizedBox(height: el(6)),
      const DocsApiTable(
        title: 'ElSpinner static constant',
        facts: <DocsApiFact>[
          DocsApiFact(
            name: 'ElSpinner.px',
            type: 'static const double',
            description:
                'The default size, 16.0, named because it matches the '
                '`size-4` Tailwind class the reference uses, and '
                'because ElButton reasons about it directly: a loading '
                'button grows by ElSpinner.px + gapFor(size) the '
                'instant loading starts.',
          ),
        ],
      ),
    ],
  );
}

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
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
        'to Duration.zero; the controller stops at its lower bound and '
        'holds the 0-degree (upright) frame, the same frame the '
        'reference\'s own animation-iteration-count: 1 collapse leaves '
        'it on.',
    userSignal:
        'A still glyph, still on screen, just motionless: the loading '
        'affordance is present without the spin.',
  ),
];

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: ElWidths.prose),
    child: Builder(
      builder: (BuildContext context) {
        final ElThemeData theme = ElTheme.of(context);
        return ElText(
          'The reference hands its inner Icon a role="status" and an '
          'aria-label="Loading", but the reference\'s own Icon '
          'component destructures only {icon, size, tone, label, '
          'className} and spreads nothing, so both attributes are '
          'dropped on the floor there too. With no label reaching it, '
          'the glyph renders aria-hidden. ElSpinner reproduces that '
          'rendered behaviour: the glyph is wrapped in ExcludeSemantics, '
          'and ElButton carries the busy state alone, so a screen '
          'reader\'s only signal from a loading button is its '
          'aria-busy.',
          ElType.small,
          color: theme.mutedForeground,
        );
      },
    ),
  );
}

/// New: split out of Accessibility, matching `button`, `field`, `popover`,
/// `alert` and `toaster`'s own dedicated Keyboard disclosure. ElSpinner is
/// wrapped in [ExcludeSemantics] and has no [Focus] or `onKeyEvent` of its
/// own anywhere in `spinner.dart` -- read directly off the source, not
/// inferred.
class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: ElWidths.prose),
    child: Builder(
      builder: (BuildContext context) {
        final ElThemeData theme = ElTheme.of(context);
        return ElText(
          'No key handling of any kind: spinner.dart declares no Focus, '
          'FocusNode, or onKeyEvent anywhere, and the glyph itself is '
          'wrapped in ExcludeSemantics. ElSpinner is never in the tab '
          'order and answers no key press -- it is a decorative glyph, '
          'always mounted inside whatever interactive control uses it '
          '(a loading ElButton, an in-progress ElBadge, a validating '
          'ElInputGroup addon), and that control\'s own tab stop and '
          'key bindings are entirely unaffected by the spinner riding '
          'inside it.',
          ElType.small,
          color: theme.mutedForeground,
        );
      },
    ),
  );
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: ElWidths.prose),
    child: Builder(
      builder: (BuildContext context) {
        final ElThemeData theme = ElTheme.of(context);
        return ElText(
          'No platform-conditional code anywhere in spinner.dart: '
          'Android, iOS, Web, macOS, Windows, and Linux all render the '
          'same widget tree. ElSpinner does not read MediaQuery for '
          'layout, only for disableAnimations: it is a fixed-size '
          'widget that a responsive parent positions.',
          ElType.small,
          color: theme.mutedForeground,
        );
      },
    ),
  );
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      _bullets(ElTheme.of(context), <String>[
        'File: lib/src/components/spinner.dart, one file, no '
            'companions.',
        'Imports icon.dart directly: ElSpinner wraps a '
            'ElIcon(ElIconGlyph.loaderCircle, ...) in a '
            'RotationTransition.',
        'registryDependencies, resolved automatically by `elattar add '
            'spinner`: icon, source-foundation.',
        'Used by many other components as a loading affordance: '
            'button, badge, input group, empty.',
      ]),
      SizedBox(height: el(2)),
      const DocsLinkRow(
        links: <DocsLink>[
          DocsLink(label: 'Button', route: '/components/button'),
          DocsLink(label: 'Badge', route: '/components/badge'),
        ],
      ),
    ],
  );
}

class _ThemingContent extends StatelessWidget {
  const _ThemingContent();

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: ElWidths.prose),
    child: Builder(
      builder: (BuildContext context) {
        final ElThemeData theme = ElTheme.of(context);
        return ElText(
          'Carries no tone parameter of its own; it always passes '
          'ElIconTone.inherit to the ElIcon it wraps, so it takes the '
          'surrounding text colour in both light and dark themes. Its '
          'motion, not its colour, is the themed surface: the spin '
          'duration is resolved through elAnimationDuration(context, '
          'ElDurations.spin) on every build, the same lookup ElPress '
          'and ElKeyframePlayer use.',
          ElType.small,
          color: theme.mutedForeground,
        );
      },
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
