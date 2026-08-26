/// Public documentation page for the `agent-launcher` component.
///
/// Written from nothing: no page existed for this registry item before
/// this file. Read end to end from `lib/src/components/agent_launcher.dart`
/// (387 lines, `agent-launcher.tsx` ported) and from
/// `test/agent_launcher_test.dart`.
///
/// **The trigger is fixed to the whole page, not to this card.** The live
/// specimen below sits inside an `ElAgentLauncher`, genuinely positioned
/// by an `OverlayPortal` against the nearest `Overlay` — the app's own,
/// not the showcase stage — the same fact `pages/console.dart`'s own
/// launcher demo notes for its reader: *"it is sitting in the
/// bottom-right corner of the page you are reading."*
///
/// **One launcher, not two.** `avatar` is demonstrated by a toggle over a
/// single live `ElAgentLauncher` rather than by mounting a second one:
/// both pin to the exact same `right-6 bottom-6` corner, and the second
/// instance sits exactly on top of the first, absorbing every tap meant
/// for it — measured directly while writing this page's own test, not
/// guessed.
///
/// **`child` is a placeholder, honestly labelled.** The reference
/// composition is a whole `AgentConsole`; this port's console family is
/// out of scope for this page (a separate, not-yet-documented registry
/// item), so the live specimen passes a plain panel that says exactly what
/// it is rather than a console this page cannot yet claim to show.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/component_doc_page.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import 'meta.dart';

final ComponentDocSpec agentLauncherDocSpec = ComponentDocSpec(
  name: 'agent-launcher',
  title: agentLauncherDoc.title,
  description: agentLauncherDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'A live ElAgentLauncher, pinned to the bottom-right corner of '
          'the whole page (fixed right-6 bottom-6, z-40) rather than to '
          'this card. Hover it to see the label ride out; click it to '
          'open the dialog. The toggle swaps ElAgentLauncher.avatar '
          'between the default (ElCubeAvatar, through '
          'ElAgentAvatarRegistry.renderer) and a plain square, through '
          'the same ElAgentAvatarBuilder seam ElAgentFace.avatar takes — '
          'a second, independent launcher is not shown beside it, '
          'because two fixed-position launchers pin to the exact same '
          'corner and the second would sit on top of the first, '
          'intercepting every tap.',
      specimen: _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
      minHeight: el(48),
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'agent-launcher has a real registry manifest: `elattar add '
          'agent-launcher` installs lib/src/components/agent_launcher.dart '
          'and resolves agent-core, agent-face, button, dialog, and '
          'source-foundation automatically. The Manual tab is for a '
          'project not using the CLI.',
      command: agentLauncherDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/agent_launcher.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/agent_launcher.dart's generated "
              '@ui/agent_launcher.dart payload into components/ui.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated agent_launcher source here when using '
              'manual mode.',
        ),
        DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so ElAgentLauncher is reachable the '
              'same way the CLI path already makes it.',
          code: "export 'agent_launcher.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'The smallest correct import and construction. child is the '
          'one required slot with no default — "anything, really; the '
          'launcher only supplies the shell."',
      code: _usageCode,
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'The one public class the file declares, in full — every '
          'constructor parameter and every static measurement '
          'dialogSize\'s own clamp is built from.',
      child: DocsApiTable(title: 'ElAgentLauncher', facts: _launcherFacts),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          "The trigger is an ElButton(variant: outline) underneath: its "
          'own hover / press / focus states are inherited unchanged — see '
          "Button's own States. What agent_launcher.dart adds is below.",
      child: DocsStateMatrix(facts: _stateFacts),
    ),
    DisclosureSection(
      id: 'accessibility',
      title: 'Accessibility',
      child: _AccessibilityContent(),
    ),
    DisclosureSection(
      id: 'keyboard',
      title: 'Keyboard',
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
            value: agentLauncherDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'test/agent_launcher_test.dart',
            description: "The package's own coverage of ElAgentLauncher.",
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/agent_launcher_test.dart',
            description:
                'Covers this page: the article mounts, every '
                'ElAgentLauncher constructor parameter this page claims '
                'to document, opening the dialog on tap, and both themes '
                'at two viewport widths.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/agent_launcher/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class AgentLauncherDocPage extends StatelessWidget {
  const AgentLauncherDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: agentLauncherDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / AGENT',
      title: agentLauncherDoc.title,
      description: agentLauncherDoc.description,
    ),
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Components'),
      ElBreadcrumbEntry.page('Agent Launcher'),
    ],
    toc: agentLauncherDocSpec.toc,
    previous: null,
    next: null,
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('agent-launcher-doc-article'),
      child: ComponentDocPage(spec: agentLauncherDocSpec, header: false),
    ),
  );
}

/* ── Showcase specimens ─────────────────────────────────────────────────── */

/// A stand-in for a console: honestly labelled, never claiming to be one.
class _PlaceholderChild extends StatelessWidget {
  const _PlaceholderChild({required this.keyValue});

  final String keyValue;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Container(
      key: ValueKey<String>(keyValue),
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center,
      color: theme.popover,
      child: ElText(
        'child slot — a console goes here',
        ElType.body,
        color: theme.mutedForeground,
      ),
    );
  }
}

/// `ElAgentAvatarBuilder`'s own shape: positional, so a call site can hand
/// over a closure without restating every label. Draws a plain square the
/// same size the real face would occupy.
Widget _squareRenderer(
  BuildContext context,
  ElAgentState state,
  ElAgentAvatarSize size,
  Color? accent,
  double? speed,
) {
  final ElThemeData theme = ElTheme.of(context);
  return Container(
    width: size.box,
    height: size.box,
    decoration: BoxDecoration(
      color: accent ?? theme.agent,
      borderRadius: BorderRadius.circular(ElRadii.sm),
    ),
  );
}

/// One live launcher, its `avatar` swapped by a toggle rather than by a
/// second launcher instance: two fixed-position launchers pin to the exact
/// same corner, and the second mounted would sit on top of the first,
/// intercepting every tap — measured, not guessed, while writing this page.
class _PreviewSpecimen extends StatefulWidget {
  const _PreviewSpecimen();

  @override
  State<_PreviewSpecimen> createState() => _PreviewSpecimenState();
}

class _PreviewSpecimenState extends State<_PreviewSpecimen> {
  bool _customRenderer = false;

  @override
  Widget build(BuildContext context) => Align(
    alignment: AlignmentDirectional.centerStart,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Wrap(
          spacing: el(2),
          runSpacing: el(2),
          children: <Widget>[
            ElButton(
              key: const ValueKey<String>(
                'agent-launcher-preview-toggle-default',
              ),
              size: ElButtonSize.sm,
              variant: _customRenderer
                  ? ElButtonVariant.outline
                  : ElButtonVariant.secondary,
              onPressed: () => setState(() => _customRenderer = false),
              child: const Text('Default'),
            ),
            ElButton(
              key: const ValueKey<String>(
                'agent-launcher-preview-toggle-custom',
              ),
              size: ElButtonSize.sm,
              variant: _customRenderer
                  ? ElButtonVariant.secondary
                  : ElButtonVariant.outline,
              onPressed: () => setState(() => _customRenderer = true),
              child: const Text('avatar: squareRenderer'),
            ),
          ],
        ),
        SizedBox(height: el(6)),
        ElAgentLauncher(
          key: const ValueKey<String>('agent-launcher-preview'),
          label: 'Ask the assistant',
          title: 'Vault',
          description: 'Ask about packs, pulls, prices and your wallet.',
          avatar: _customRenderer ? _squareRenderer : null,
          child: const _PlaceholderChild(
            keyValue: 'agent-launcher-preview-child',
          ),
        ),
      ],
    ),
  );
}

const String _previewCode =
    '''
import 'package:elattar_design_system/elattar_design_system.dart';

ElAgentLauncher(
  label: 'Ask the assistant',
  title: 'Vault',
  description: 'Ask about packs, pulls, prices and your wallet.',
  child: MyConsole(),
)

// avatar swaps the trigger's own face for any ElAgentAvatarBuilder:
ElAgentLauncher(
  label: 'Ask the assistant',
  title: 'Vault',
  description: 'Ask about packs, pulls, prices and your wallet.',
  avatar: (context, state, size, accent, speed) => Container(
    width: size.box,
    height: size.box,
    color: accent ?? ElTheme.of(context).agent,
  ),
  child: MyConsole(),
)''';

const String _usageCode =
    '''
import 'package:elattar_design_system/elattar_design_system.dart';

ElAgentLauncher(
  label: 'Ask the assistant',
  title: 'Assistant',
  description: 'Opens the console.',
  child: MyConsole(),
)''';

/* ── Disclosure content ─────────────────────────────────────────────────── */

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'The trigger is ElButton(label: widget.label, child: ElAgentFace('
            '…)): passing label forces excludeSemantics: true on the '
            'button, so the accessible name is the launcher\'s own '
            'label ("Ask the assistant"), not the face\'s state sentence.',
        'The label chip that rides out on hover (_Label) is wrapped in '
            'IgnorePointer and carries no Semantics of its own: it is '
            'decoration for a sighted pointer user, not a second '
            'accessible name — "pointer-events-none keeps it from eating '
            'the hover it was summoned by."',
        'The dialog\'s title and description are announced, never '
            'painted: Semantics(label: \'\$title. \$description\', '
            'container: true) on the content box — dialog.dart\'s own '
            '<DialogTitle className="sr-only"> pattern, ported.',
      ]);
}

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'The trigger inherits ElButton\'s own keyboard handling '
            'unchanged: Enter, NumpadEnter, and Space activate it when '
            'focused. agent_launcher.dart wires no Focus node or key '
            'handler of its own.',
        'Escape closes the open dialog — inherited from ElModalPortal '
            '(dialog.dart), unconditional there, not something '
            'agent_launcher.dart adds.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'dialogSize(viewport) is the one real breakpoint-shaped '
            'computation in the file: width is '
            'max(minFraction · vw, min(maxWidth, viewportFraction · vw)) '
            '— CSS\'s own order, min-width applied AFTER max-width, so '
            'past roughly 2133px of viewport the 80rem cap stops binding '
            'and a 2400px window gets a 1440px dialog rather than a '
            '1280px one.',
        'height is min(heightFraction · vh, maxHeight) — a plain min, no '
            'floor.',
        'ElModalCompact.clampSize takes the last word on a phone: at '
            '375x812 the formula above resolves to 292.5 x 714.6 (714.6 '
            'is 88% of the viewport, leaving nothing for the scrim), and '
            'the clamp brings it to 292.5 x 609. Above the breakpoint the '
            'clamp is the identity.',
        'The trigger itself (size-16, right-6 bottom-6) does not move '
            'with the viewport: it is a fixed square at a fixed inset on '
            'every width.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      _bullets(ElTheme.of(context), <String>[
        'File: lib/src/components/agent_launcher.dart — one file, no '
            'companions; the registry manifest lists exactly one entry '
            'under "files".',
        'registryDependencies, resolved automatically by `elattar add '
            'agent-launcher`: agent-core, agent-face, button, dialog, '
            'source-foundation — copied verbatim from '
            'registry/components/agent-launcher.json. button supplies '
            'ElButton and ElButtonSurface\'s hoverBorder field (added for '
            'this call site); dialog supplies ElModalPortal, '
            'ElJellyTransition, and ElModalCompact.clampSize; agent-face '
            'supplies the trigger\'s own ElAgentFace and '
            'ElAgentAvatarBuilder.',
        'semanticDependencies (the manifest\'s own, narrower field): the '
            'same five.',
      ]),
      SizedBox(height: el(4)),
      const DocsLinkRow(
        links: <DocsLink>[
          DocsLink(label: 'Agent Core', route: '/components/agent-core'),
          DocsLink(label: 'Agent Face', route: '/components/agent_face'),
          DocsLink(label: 'Button', route: '/components/button'),
          DocsLink(label: 'Dialog', route: '/components/dialog'),
        ],
      ),
    ],
  );
}

class _ThemingContent extends StatelessWidget {
  const _ThemingContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'The trigger\'s fill, border, and press feel are outline\'s own '
            '(theme.card, theme.input, shadow-btn/shadow-btn-down) — see '
            "Button's own Theming. The one override this file adds is "
            'hover:border-agent/50: ElButtonSurface(hoverBorder: '
            'theme.agent.withValues(alpha: 0.50)), painted on the same '
            'spring clock the border already rides.',
        'The label chip is theme.card with a theme.border hairline and '
            'ElShadows.e2 — the same panel chrome a tooltip or a popover '
            'uses.',
        'The dialog surface is theme.popover, ringed and shadowed by '
            'ElDialogContent.ringSpec plus ElShadows.e4, both from '
            'dialog.dart: nothing here paints a bespoke shadow.',
      ]);
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

const List<DocsApiFact> _launcherFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'label',
    type: 'String',
    description:
        'Required. Rides out of the button on hover; the button\'s own '
        'accessible name.',
  ),
  DocsApiFact(
    name: 'title',
    type: 'String',
    description:
        "Required. Announced when the dialog opens. Not painted — the "
        "child owns its own header.",
  ),
  DocsApiFact(
    name: 'description',
    type: 'String',
    description: 'Required. Announced alongside title.',
  ),
  DocsApiFact(
    name: 'child',
    type: 'Widget',
    description:
        'Required, no default. The dialog\'s content — "anything, '
        'really; the launcher only supplies the shell."',
  ),
  DocsApiFact(
    name: 'avatar',
    type: 'ElAgentAvatarBuilder?',
    description:
        'Null takes ElAgentAvatarRegistry.renderer, the same default '
        "the console header uses.",
  ),
  DocsApiFact(
    name: 'size',
    type: 'static double get',
    description: 'el(16) = 64px — the trigger\'s own square.',
  ),
  DocsApiFact(
    name: 'inset',
    type: 'static double get',
    description: 'el(6) = 24px — right and bottom, from the viewport edge.',
  ),
  DocsApiFact(
    name: 'labelGap',
    type: 'static double get',
    description: 'el(3) = 12px — between the label and the button.',
  ),
  DocsApiFact(
    name: 'labelRest',
    type: 'static double get',
    description:
        'el(2) = 8px — the label\'s resting translateX; it SNAPS to 0 on '
        'the first hover frame rather than riding the opacity fade, per '
        "the file's own PROBE CORRECTION.",
  ),
  DocsApiFact(
    name: 'labelPadding',
    type: 'static EdgeInsets get',
    description: 'Symmetric, el(3) horizontal, el(2) vertical.',
  ),
  DocsApiFact(
    name: 'hoverRimAlpha',
    type: 'static const double',
    description: '0.50 — the alpha hover:border-agent/50 paints at.',
  ),
  DocsApiFact(
    name: 'dialogViewportFraction',
    type: 'static const double',
    description: '0.78 — width: 78vw.',
  ),
  DocsApiFact(
    name: 'dialogMinFraction',
    type: 'static const double',
    description: '0.60 — the CSS min-width floor, 60vw.',
  ),
  DocsApiFact(
    name: 'dialogMaxWidth',
    type: 'static double get',
    description: 'el(320) = 1280px — the CSS max-width cap, 80rem.',
  ),
  DocsApiFact(
    name: 'dialogHeightFraction',
    type: 'static const double',
    description: '0.88 — the height formula\'s own 88vh.',
  ),
  DocsApiFact(
    name: 'dialogMaxHeight',
    type: 'static double get',
    description: 'el(208) = 832px — the height formula\'s 52rem cap.',
  ),
  DocsApiFact(
    name: 'dialogSize',
    type: 'static Size Function(Size viewport)',
    description:
        'The resolved dialog box for a given viewport, CSS\'s own '
        "max(min-width, min(max-width, width)) order, then "
        'ElModalCompact.clampSize\'s mobile floor. See Responsive.',
  ),
];

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'label, rest',
    treatment: 'opacity 0, translateX(labelRest)',
    userSignal: 'Hidden, offset 8px right of its resting seat.',
  ),
  DocsStateFact(
    state: 'label, hover',
    treatment:
        'opacity 1 over ElDurations.base on ElCurves.outFlex; translateX '
        'SNAPS to 0 on the first hover frame, not animated',
    userSignal:
        'Fades in while already in position — the measured PROBE '
        'CORRECTION, not the naive "both ride out together."',
  ),
  DocsStateFact(
    state: 'dialog, open',
    treatment: 'ElJellyTransition over the dialog content',
    userSignal: 'The console (or whatever child is) appears, jellied in.',
  ),
  DocsStateFact(
    state: 'trigger, hover',
    treatment:
        "outline's own hover plus this file's own addition, "
        'hover:border-agent/50',
    userSignal: 'The rim tints toward the agent accent on top of outline\'s own hover.',
  ),
];
