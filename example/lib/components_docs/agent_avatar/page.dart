/// Public documentation page for the `agent-avatar` component.
///
/// Written from nothing: no page existed for this registry item before this
/// file. Read end to end from `lib/src/components/agent_avatar.dart`
/// (1760 lines, one file folding four reference files into one library) and
/// from `test/agent_avatar_test.dart`, the package's own coverage.
///
/// **What this page documents in full, and what it does not.** The file
/// exports ten public names. Two are what a caller actually constructs —
/// [ElCubeAvatar] (the widget) and [ElAgentAvatarSize] (the size it takes) —
/// and those get complete API tables. [ElCubeScene] is the one other
/// widget with a real public constructor, and gets one too: a caller who
/// wants a bare scene rather than the cross-fading, idle-aware
/// [ElCubeAvatar] can reach for it directly. The remaining six —
/// [ElAgentCube], [ElAgentCubeFaces], [ElAgentCubeKeyframe],
/// [ElAgentCubeKeyframes], [ElAgentCubeMotion], [ElAgentCubeScene], and the
/// top-level `elAgentCubeScene` — are the isometric projection, the
/// fourteen keyframe tables, and the nineteen scene recipes: the engine
/// [ElCubeAvatar] runs on, exported because the file draws no library-level
/// privacy boundary around them, but never called directly by any of the
/// three call sites this port has (`agent_face.dart`, this page, and the
/// package test). They are named and described once, in the API
/// Reference's "Scene engine" entry, rather than tabulated field by field —
/// tabulating fourteen keyframe tables would be several hundred rows no
/// reader of [ElCubeAvatar]'s own constructor ever reaches.
///
/// **State is not a per-value section.** [ElAgentState] (`agent_core.dart`)
/// has twenty values; a Button-style section per value would be twenty
/// headings for one enum this page does not own. "State Set" below shows
/// all twenty in one grid instead, the shape `components/el/agent-demo.tsx`'s
/// own `AvatarMatrix` uses. `ElAgentState` itself — its wire spelling, its
/// label text, which states are "busy" — is `agent-core`'s own claim to
/// make, not this page's: nothing here documents it, they are read from the
/// enum only to build a live specimen.
///
/// **Reduced motion has no section of its own**, for the same reason the
/// reference's own page notes: its whole subject is what happens when a
/// setting this page cannot toggle is on, which makes it the one facet with
/// no specimen to show. It is recorded as prose in Accessibility instead.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/component_doc_page.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../docs/docs_section.dart' show DocsAnchor;
import 'meta.dart';

/// Six states walked in state-machine order: start, working, a tool call,
/// waiting on a human, failure, success. Not the whole twenty — the "State
/// Set" section below is where every one of those lives — a representative
/// arc so the Preview specimen reads as a story rather than a wall of tiles.
const List<ElAgentState> _previewStates = <ElAgentState>[
  ElAgentState.idle,
  ElAgentState.thinking,
  ElAgentState.callingTools,
  ElAgentState.awaitingApproval,
  ElAgentState.error,
  ElAgentState.done,
];

final ComponentDocSpec agentAvatarDocSpec = ComponentDocSpec(
  name: 'agent-avatar',
  title: agentAvatarDoc.title,
  description: agentAvatarDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'Six of the twenty states, in the order an agent actually moves '
          'through one: idle, thinking, calling a tool, awaiting approval, '
          'error, done. Every one is a live ElCubeAvatar, cross-fading on '
          'the same 150ms clock the widget itself uses when state changes.',
      specimen: _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'agent-avatar has a real registry manifest: `elattar add '
          'agent-avatar` installs lib/src/components/agent_avatar.dart and '
          'resolves agent-core, keyframes, and source-foundation '
          'automatically. The Manual tab is for a project not using the '
          'CLI.',
      command: agentAvatarDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/agent_avatar.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/agent_avatar.dart's generated "
              '@ui/agent_avatar.dart payload into components/ui.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated agent_avatar source here when using '
              'manual mode.',
        ),
        DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so ElCubeAvatar and its supporting '
              'classes are reachable the same way the CLI path already '
              'makes them.',
          code: "export 'agent_avatar.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'The smallest correct import and construction. Every example '
          'below only changes named arguments on top of this.',
      code: _usageCode,
    ),
    ShowcaseSection(
      id: 'state-set',
      title: 'State Set',
      description:
          'All twenty ElAgentState values, each drawn at its default md '
          'size. Nineteen are isometric scenes resolved through '
          'elAgentCubeScene(state); idle is the one exception, a real '
          '3D-projected cube rather than a flat scene, because "it is the '
          'only state that is not an isometric projection."',
      specimen: _StateSetSpecimen(),
      code: _stateSetCode,
      label: 'State Set specimen view',
    ),
    ShowcaseSection(
      id: 'sizes',
      title: 'Sizes',
      description:
          'ElAgentAvatarSize has four rungs: sm (32px), md (48px, the '
          'default), lg (80px), xl (128px). Each scene renders wider than '
          'its own box and is deliberately allowed to overflow it — an '
          '80px lg box holds an 80.64px thinking scene.',
      specimen: _SizesSpecimen(),
      code: _sizesCode,
      label: 'Sizes specimen view',
    ),
    ShowcaseSection(
      id: 'accent',
      title: 'Accent',
      description:
          'accent is the one knob every accented face in a scene is mixed '
          'from. Left null it resolves to theme.agent, so an avatar '
          'follows a retheme automatically; a caller can override it '
          'per-instance for a different product surface.',
      specimen: _AccentSpecimen(),
      code: _accentCode,
      label: 'Accent specimen view',
    ),
    ShowcaseSection(
      id: 'speed',
      title: 'Speed',
      description:
          'speed is a global multiplier every duration in the scene '
          'divides by: 2 plays twice as fast, 0.5 half as fast. The '
          'reference rounds the divided duration to two decimals before '
          'handing it to the browser, and this port reproduces that '
          'rounding rather than dividing it away.',
      specimen: _SpeedSpecimen(),
      code: _speedCode,
      label: 'Speed specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'ElCubeAvatar and ElAgentAvatarSize in full — the surface a '
          'caller constructs — plus ElCubeScene, the one other widget with '
          'a public constructor, and the scene engine the three of them '
          'run on, named rather than tabulated.',
      children: const <DocsTocEntry>[
        DocsTocEntry(title: 'ElCubeAvatar', anchor: 'api-elcubeavatar'),
        DocsTocEntry(
          title: 'ElAgentAvatarSize',
          anchor: 'api-elagentavatarsize',
        ),
        DocsTocEntry(title: 'ElCubeScene', anchor: 'api-elcubescene'),
        DocsTocEntry(title: 'Scene engine', anchor: 'api-scene-engine'),
      ],
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'ElCubeAvatar is a display, not a control: it has no hover, '
          'press, focus, selected, loading, or disabled state of its own. '
          'What varies is which scene it draws and how it gets there.',
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
            value: agentAvatarDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'test/agent_avatar_test.dart',
            description:
                'The package\'s own coverage of ElCubeAvatar and the scene '
                'engine (1117 lines at the time this page was written).',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/agent_avatar_test.dart',
            description:
                'Covers this page: the article mounts, every '
                'ElCubeAvatar constructor parameter this page claims to '
                'document, and both themes at two viewport widths.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/agent_avatar/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class AgentAvatarDocPage extends StatelessWidget {
  const AgentAvatarDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: agentAvatarDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / AGENT',
      title: agentAvatarDoc.title,
      description: agentAvatarDoc.description,
    ),
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Components'),
      ElBreadcrumbEntry.page('Agent Avatar'),
    ],
    toc: agentAvatarDocSpec.toc,
    previous: null,
    next: null,
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('agent-avatar-doc-article'),
      child: ComponentDocPage(spec: agentAvatarDocSpec, header: false),
    ),
  );
}

/* ── Showcase specimens ─────────────────────────────────────────────────── */

/// One labelled avatar. Shared by every showcase below so the label
/// treatment (a caption under the box) is stated once.
class _AvatarTile extends StatelessWidget {
  const _AvatarTile({
    required this.keyValue,
    required this.label,
    required this.state,
    this.size = ElAgentAvatarSize.md,
    this.accent,
    this.speed = 1,
  });

  final String keyValue;
  final String label;
  final ElAgentState state;
  final ElAgentAvatarSize size;
  final Color? accent;
  final double speed;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      key: ValueKey<String>(keyValue),
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          width: el(32),
          height: el(32),
          child: Center(
            child: ElCubeAvatar(
              state: state,
              size: size,
              accent: accent,
              speed: speed,
            ),
          ),
        ),
        SizedBox(height: el(2)),
        ElText(label, ElType.caption, color: theme.mutedForeground),
      ],
    );
  }
}

class _PreviewSpecimen extends StatelessWidget {
  const _PreviewSpecimen();

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: el(2)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (final ElAgentState state in _previewStates) ...<Widget>[
            _AvatarTile(
              keyValue: 'agent-avatar-preview:${state.name}',
              label: state.label,
              state: state,
            ),
            SizedBox(width: el(6)),
          ],
        ],
      ),
    ),
  );
}

const String _previewCode =
    '''
import 'package:elattar_design_system/elattar_design_system.dart';

ElCubeAvatar(state: ElAgentState.idle),
ElCubeAvatar(state: ElAgentState.thinking),
ElCubeAvatar(state: ElAgentState.callingTools),
ElCubeAvatar(state: ElAgentState.awaitingApproval),
ElCubeAvatar(state: ElAgentState.error),
ElCubeAvatar(state: ElAgentState.done),''';

const String _usageCode =
    '''
import 'package:elattar_design_system/elattar_design_system.dart';

ElCubeAvatar(state: ElAgentState.idle)''';

class _StateSetSpecimen extends StatelessWidget {
  const _StateSetSpecimen();

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: el(4),
    runSpacing: el(4),
    children: <Widget>[
      for (final ElAgentState state in ElAgentState.values)
        _AvatarTile(
          keyValue: 'agent-avatar-example:state-${state.name}',
          label: state.label,
          state: state,
        ),
    ],
  );
}

const String _stateSetCode =
    '''
for (final ElAgentState state in ElAgentState.values)
  ElCubeAvatar(state: state)''';

class _SizesSpecimen extends StatelessWidget {
  const _SizesSpecimen();

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        for (final ElAgentAvatarSize size
            in ElAgentAvatarSize.values) ...<Widget>[
          _AvatarTile(
            keyValue: 'agent-avatar-example:size-${size.name}',
            label: size.name,
            state: ElAgentState.thinking,
            size: size,
          ),
          SizedBox(width: el(6)),
        ],
      ],
    ),
  );
}

const String _sizesCode =
    '''
ElCubeAvatar(state: ElAgentState.thinking, size: ElAgentAvatarSize.sm),
ElCubeAvatar(state: ElAgentState.thinking, size: ElAgentAvatarSize.md),
ElCubeAvatar(state: ElAgentState.thinking, size: ElAgentAvatarSize.lg),
ElCubeAvatar(state: ElAgentState.thinking, size: ElAgentAvatarSize.xl)''';

class _AccentSpecimen extends StatelessWidget {
  const _AccentSpecimen();

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      const _AvatarTile(
        keyValue: 'agent-avatar-example:accent-default',
        label: 'theme.agent',
        state: ElAgentState.running,
        size: ElAgentAvatarSize.lg,
      ),
      SizedBox(width: el(6)),
      _AvatarTile(
        keyValue: 'agent-avatar-example:accent-custom',
        label: 'custom',
        state: ElAgentState.running,
        size: ElAgentAvatarSize.lg,
        accent: ElPalette.action,
      ),
    ],
  );
}

const String _accentCode =
    '''
ElCubeAvatar(state: ElAgentState.running, size: ElAgentAvatarSize.lg),
ElCubeAvatar(
  state: ElAgentState.running,
  size: ElAgentAvatarSize.lg,
  accent: ElPalette.action,
)''';

class _SpeedSpecimen extends StatelessWidget {
  const _SpeedSpecimen();

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      const _AvatarTile(
        keyValue: 'agent-avatar-example:speed-default',
        label: 'speed: 1',
        state: ElAgentState.searching,
        size: ElAgentAvatarSize.lg,
      ),
      SizedBox(width: el(6)),
      const _AvatarTile(
        keyValue: 'agent-avatar-example:speed-fast',
        label: 'speed: 2.5',
        state: ElAgentState.searching,
        size: ElAgentAvatarSize.lg,
        speed: 2.5,
      ),
    ],
  );
}

const String _speedCode =
    '''
ElCubeAvatar(state: ElAgentState.searching, size: ElAgentAvatarSize.lg),
ElCubeAvatar(
  state: ElAgentState.searching,
  size: ElAgentAvatarSize.lg,
  speed: 2.5,
)''';

/* ── Disclosure content ─────────────────────────────────────────────────── */

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsAnchor(
        id: 'api-elcubeavatar',
        child: DocsApiTable(title: 'ElCubeAvatar', facts: _cubeAvatarFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elagentavatarsize',
        child: DocsApiTable(
          title: 'ElAgentAvatarSize',
          facts: _avatarSizeFacts,
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elcubescene',
        child: DocsApiTable(title: 'ElCubeScene', facts: _cubeSceneFacts),
      ),
      SizedBox(height: el(5)),
      DocsAnchor(
        id: 'api-scene-engine',
        child: _SceneEngineContent(),
      ),
    ],
  );
}

class _SceneEngineContent extends StatelessWidget {
  const _SceneEngineContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      ElText(
        'Scene engine',
        ElType.h4,
        color: ElTheme.of(context).foreground,
      ),
      SizedBox(height: el(3)),
      _bullets(ElTheme.of(context), <String>[
        'ElAgentCube — a private-constructor namespace (no public '
            'constructor of its own) holding the isometric math: iso() '
            'projects (x, y, z) to a screen offset, viewBoxOf() measures a '
            "scene's bounding box from its cubes, sorted() draws "
            'back-to-front. Called by ElCubeScene, never by a caller.',
        'ElAgentCubeFaces — the four colours one cube is drawn in '
            '(neutral, accent, error, ghost) plus its dash, with the '
            "accent face's top and right mixed from accent and "
            'accentShade in oklab so any hue lights correctly.',
        'ElAgentCubeKeyframe — the fourteen @keyframes agent-cube-* names '
            'this file ports: bob, rise, appear, drop, glide, blinkfade, '
            'blinkslow, lift, lift2, settle, pull, shake, bounce, and '
            'spin3d — the one keyframe no isometric scene names, the idle '
            "cube's own rotation.",
        'ElAgentCubeKeyframes — those fourteen tables, each as an '
            'Animatable over 0..1.',
        'ElAgentCubeMotion — one animation shorthand: which keyframe '
            'plays, its duration and delay (already divided by speed), '
            'whether it alternates, and whether the element starts hidden '
            'during the delay.',
        'ElAgentCubeSpec — one cube\'s entry in a scene recipe: its grid '
            'position and which motions it plays.',
        'ElAgentCubeScene / elAgentCubeScene(state, speed:) — a scene\'s '
            "own cube list and measured width; the function resolves an "
            'ElAgentState to one of the nineteen recipes.',
      ]),
    ],
  );
}

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'Semantic role: Semantics(image: true) on the rendered node, on '
            'every state — this is a picture of what the agent is doing, '
            'never a control.',
        'Accessible name: label: state.label — "role=\\"img\\" '
            'aria-label={AGENT_STATE_LABEL[state]}" in the reference. A '
            'screen reader hears the sentence ("Planning", "Retrieving '
            'knowledge"), not the enum name.',
        'Known gap: the Semantics node carries no liveRegion. A screen '
            'reader that has already focused the avatar is not told when '
            'the label changes underneath it; ElAgentStatusLine '
            '(agent_face.dart), which sits beside the avatar in a real '
            'console, is the one that marks liveRegion: true.',
        'Reduced motion: elAnimationDuration(context, ElCubeAvatar.'
            'crossfade) collapsing to Duration.zero freezes the clock '
            '(_frozen = true), which the scene renders as globals.css '
            'L3195-3215 states it: every cube fully opaque at its grid '
            'position, no transform — not "the clock stopped at zero", '
            'which for appear and drop would render nothing at all.',
        'The crossfade itself carries no semantic signal of its own: it '
            'is two SVG-shaped paints layered in a Stack while it runs, '
            'and only the incoming scene\'s label is ever announced.',
      ]);
}

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'ElCubeAvatar takes no focus and handles no key event: it wraps '
            'no Focus node and no GestureDetector. It is a Semantics('
            'image: true) node, not a control.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'No breakpoint branching anywhere in agent_avatar.dart: '
            'BuildContext width is never read for a layout decision.',
        'The rendered box is entirely a function of size '
            '(ElAgentAvatarSize.box, one of 32/48/80/128px) and the '
            'caller decides which rung to pass; nothing here reads a '
            'viewport to choose one automatically.',
        'A scene is deliberately allowed to overflow its own box '
            '(OverflowBox, clipBehavior: Clip.none): an 80px lg box holds '
            'an 80.64px thinking scene. A caller that clips the avatar\'s '
            'own SizedBox will clip real content.',
        'Platform parity: Android, iOS, Web, macOS, Windows, and Linux '
            'all render the same CustomPaint tree; no dart:io Platform '
            'branch anywhere in the file.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      _bullets(ElTheme.of(context), <String>[
        'File: lib/src/components/agent_avatar.dart — one file, no '
            'companions; the registry manifest lists exactly one entry '
            'under "files".',
        'Flutter imports: package:flutter/widgets.dart only (plus '
            'dart:math and dart:ui from the standard library, for the '
            'projection and the painter).',
        'registryDependencies, resolved automatically by `elattar add '
            'agent-avatar`: agent-core, keyframes, source-foundation — '
            'copied verbatim from registry/components/agent-avatar.json. '
            'agent-core supplies ElAgentState and its .label; keyframes '
            'supplies the motion-map machinery ElAgentCubeKeyframes '
            'follows the precedent of; source-foundation supplies el(), '
            'ElTheme, and the durations and curves every clock reads.',
        'semanticDependencies (the manifest\'s own, narrower field): the '
            'same two, agent-core and keyframes — this component has no '
            'dependency it pulls in only for internal use and hides from '
            'a reader deciding whether to install it.',
      ]),
      SizedBox(height: el(2)),
      const DocsLinkRow(
        links: <DocsLink>[
          DocsLink(label: 'Agent Core', route: '/components/agent-core'),
          DocsLink(label: 'Keyframes', route: '/components/keyframes'),
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
        'accent resolves to ElTheme.of(context).agent when left null — '
            '"the single knob every accent face in the set is mixed '
            'from" — and can be overridden per instance.',
        'The twelve --agent-cube-* tokens (neutral/accent/error/ghost, '
            'each with a fill and a dash) live on theme.cube '
            '(ElAgentCubeTokens.light / .dark), resolved from '
            'ElThemeData the same way every other token is: flipping '
            'ElThemeController re-resolves them on the next frame.',
        'ElAgentCubeFaces derives the accent cube\'s top and right faces '
            'from accent and accentShade in oklab (perceptually linear '
            'lighting) and mixes their transparency in srgb (a '
            'compositing operation, not a shading one) — the two colour '
            'spaces are deliberately different for what each mix is '
            'doing.',
        'The idle cube reads the same theme.cube tokens as every '
            'isometric scene: there is no separate palette for the one '
            'state that is not a scene.',
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

const List<DocsApiFact> _cubeAvatarFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'state',
    type: 'ElAgentState',
    description:
        'Which of the twenty states to draw. Defaults to '
        'ElAgentState.idle, the reference\'s own default.',
  ),
  DocsApiFact(
    name: 'size',
    type: 'ElAgentAvatarSize',
    description: 'The rung the avatar renders at. Defaults to md.',
  ),
  DocsApiFact(
    name: 'accent',
    type: 'Color?',
    description:
        'The brand hook every accented face is mixed from. Null '
        'resolves to theme.agent, so the avatar follows a retheme '
        'automatically.',
  ),
  DocsApiFact(
    name: 'speed',
    type: 'double',
    description:
        'A global multiplier every duration in the scene divides by. '
        'Defaults to 1.',
  ),
  DocsApiFact(
    name: 'crossfade',
    type: 'static Duration get',
    description:
        'ElDurations.fast (150ms) — how long the outgoing scene fades '
        'under the incoming one when state changes.',
  ),
  DocsApiFact(
    name: 'spin',
    type: 'static const ElAgentCubeMotion',
    description:
        "The idle cube's own clock: ElAgentCubeKeyframe.spin3d over 9s, "
        'linear — the one duration in the family that is not a scene '
        'recipe.',
  ),
];

const List<DocsApiFact> _avatarSizeFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'sm',
    type: 'box 32px · scale 0.19',
    description: 'size-8 in the reference.',
  ),
  DocsApiFact(
    name: 'md',
    type: 'box 48px · scale 0.29',
    description: 'size-12 in the reference. The constructor default.',
  ),
  DocsApiFact(
    name: 'lg',
    type: 'box 80px · scale 0.48',
    description: 'size-20 in the reference.',
  ),
  DocsApiFact(
    name: 'xl',
    type: 'box 128px · scale 0.78',
    description: 'size-32 in the reference.',
  ),
];

const List<DocsApiFact> _cubeSceneFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'scene',
    type: 'ElAgentCubeScene',
    description:
        'Required. The recipe to draw, from elAgentCubeScene(state, '
        'speed: …).',
  ),
  DocsApiFact(
    name: 'width',
    type: 'double',
    description: 'Required. The rendered width: scene.width × scale.',
  ),
  DocsApiFact(
    name: 'accent',
    type: 'Color',
    description: "Required. The resolved --agent-cube-accent this scene paints with.",
  ),
  DocsApiFact(
    name: 'elapsed',
    type: 'double',
    description:
        'Seconds of wall clock since the scene mounted. Defaults to 0.',
  ),
  DocsApiFact(
    name: 'frozen',
    type: 'bool',
    description:
        "globals.css's explicit reduced-motion rule: every cube static, "
        'fully opaque, no transform. Defaults to false.',
  ),
];

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'idle',
    treatment: '_IdleCube — a real 3D-projected cube, agent-cube-spin3d '
        '9s linear infinite',
    userSignal: 'The one state that is not an isometric scene.',
  ),
  DocsStateFact(
    state: 'any of the other 19',
    treatment: 'ElCubeScene, resolved through elAgentCubeScene(state)',
    userSignal: 'An isometric scene of up to twenty animated cubes.',
  ),
  DocsStateFact(
    state: 'state change',
    treatment: 'ElCubeAvatar.crossfade — 150ms on ElCurves.out',
    userSignal:
        'The outgoing scene holds at full opacity underneath while the '
        'incoming one fades over it.',
  ),
  DocsStateFact(
    state: 'reduced motion',
    treatment: 'frozen: true on every cube in the current scene',
    userSignal: 'Static, fully opaque, no transform — not paused at t=0.',
  ),
  DocsStateFact(
    state: 'hover / press / focus / selected / loading / disabled',
    treatment: 'N/A',
    userSignal:
        'ElCubeAvatar takes no pointer input and is not focusable: it '
        'is Semantics(image: true), not a control.',
  ),
];
