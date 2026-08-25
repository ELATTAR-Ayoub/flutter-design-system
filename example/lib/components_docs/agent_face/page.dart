/// Public documentation page for the `agent-face` component.
///
/// Written from nothing: no page existed for this registry item before
/// this file. Read end to end from `lib/src/components/agent_face.dart`
/// (404 lines, `parts/agent-face.tsx` ported) and from
/// `test/agent_face_test.dart`.
///
/// **Two objects share one slot, and the choice is not a style one.** The
/// file's own docstring: the avatar draws the twenty states of an agent
/// *working*; the orb draws a conversation happening in the room. Voice
/// wins while it is active, because a live microphone is the more urgent
/// fact. "Voice" below is built around exactly that seam.
///
/// **The renderer indirection is documented, not demonstrated by mutating
/// global state.** [ElAgentAvatarRegistry]'s four static fields are the
/// real defaults every one of [ElAgentFace], [ElAgentStatusLine], and the
/// composer/console family resolves through when a caller passes nothing —
/// mutating them from a live docs specimen would leak into every other
/// specimen on the page after it runs, so the API table documents the
/// registry and [ElAgentFace.avatar] (a local, per-instance override) is
/// what the page's own specimen exercises instead.
///
/// **`ElAgentVoice`'s two audio fields, `samples` and `spectrum`, are left
/// null on every specimen here.** Null is not a missing case:
/// `ElLiveWaveform`'s own docstring calls it "a flat line, which is the
/// truth" — a closed microphone, drawn honestly rather than faked with a
/// synthetic waveform this page invented.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/component_doc_page.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../docs/docs_section.dart' show DocsAnchor;
import 'meta.dart';

final ComponentDocSpec agentFaceDocSpec = ComponentDocSpec(
  name: 'agent-face',
  title: agentFaceDoc.title,
  description: agentFaceDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'Four faces: idle at rest, thinking (busy, working), listening '
          '(the orb, driven by a microphone), speaking (the orb, driven by '
          'playback). Every one is a live ElAgentFace.',
      specimen: _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'agent-face has a real registry manifest: `elattar add '
          'agent-face` installs lib/src/components/agent_face.dart and '
          'resolves agent-avatar, agent-core, keyframes, source-foundation, '
          'voice, and voice-orb automatically. The Manual tab is for a '
          'project not using the CLI.',
      command: agentFaceDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/agent_face.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/agent_face.dart's generated "
              '@ui/agent_face.dart payload into components/ui.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated agent_face source here when using '
              'manual mode.',
        ),
        DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so ElAgentFace and its supporting '
              'classes are reachable the same way the CLI path already '
              'makes them.',
          code: "export 'agent_face.dart';",
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
      id: 'voice',
      title: 'Voice',
      description:
          'voice.isActive (listening || speaking) overrides state '
          'entirely: while it is true the face renders '
          'ElAgentAvatarRegistry.orb instead of the avatar, and the '
          'accessible label switches to "Listening" or "Speaking" rather '
          'than the state\'s own sentence.',
      specimen: _VoiceSpecimen(),
      code: _voiceCode,
      label: 'Voice specimen view',
    ),
    ShowcaseSection(
      id: 'status-line',
      title: 'Status Line',
      description:
          'The sentence beside the face. It shimmers (ElAgentShimmerText) '
          'exactly when voice.isActive || state.isBusy, and holds still '
          'otherwise; a listening line grows a waveform, a speaking line '
          'grows a bar visualiser, in the gap ElAgentStatusLine.gap opens '
          'for either.',
      specimen: _StatusLineSpecimen(),
      code: _statusLineCode,
      label: 'Status Line specimen view',
    ),
    ShowcaseSection(
      id: 'custom-renderer',
      title: 'Custom Renderer',
      description:
          'ElAgentFace.avatar takes an ElAgentAvatarBuilder and defaults '
          'to ElAgentAvatarRegistry.renderer (ElCubeAvatar). Passing one '
          'locally swaps the artwork for that instance alone — "swap the '
          'renderer, keep the machine" — without touching the registry '
          'every other face on the page still resolves through.',
      specimen: _CustomRendererSpecimen(),
      code: _customRendererCode,
      label: 'Custom Renderer specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'ElAgentFace, the value type that decides which object wins '
          '(ElAgentVoice), the sentence and its effect (ElAgentStatusLine, '
          'ElAgentShimmerText), the seam every one of them resolves a '
          'renderer through (ElAgentAvatarRegistry), and the three '
          'function signatures that seam is typed against.',
      children: const <DocsTocEntry>[
        DocsTocEntry(title: 'ElAgentFace', anchor: 'api-elagentface'),
        DocsTocEntry(title: 'ElAgentVoice', anchor: 'api-elagentvoice'),
        DocsTocEntry(
          title: 'ElAgentStatusLine',
          anchor: 'api-elagentstatusline',
        ),
        DocsTocEntry(
          title: 'ElAgentShimmerText',
          anchor: 'api-elagentshimmertext',
        ),
        DocsTocEntry(
          title: 'ElAgentAvatarRegistry',
          anchor: 'api-elagentavatarregistry',
        ),
        DocsTocEntry(title: 'Builder typedefs', anchor: 'api-builders'),
      ],
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'ElAgentFace itself has no hover, press, or focus state — it is '
          'a picture and a sentence, not a control. What varies is which '
          'of the two objects is drawn and whether the sentence shimmers.',
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
            value: agentFaceDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'test/agent_face_test.dart',
            description: "The package's own coverage of ElAgentFace and its family.",
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/agent_face_test.dart',
            description:
                'Covers this page: the article mounts, every ElAgentFace '
                'constructor parameter this page claims to document, and '
                'both themes at two viewport widths.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/agent_face/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class AgentFaceDocPage extends StatelessWidget {
  const AgentFaceDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: agentFaceDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / AGENT',
      title: agentFaceDoc.title,
      description: agentFaceDoc.description,
    ),
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Components'),
      ElBreadcrumbEntry.page('Agent Face'),
    ],
    toc: agentFaceDocSpec.toc,
    previous: null,
    next: null,
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('agent-face-doc-article'),
      child: ComponentDocPage(spec: agentFaceDocSpec, header: false),
    ),
  );
}

/* ── Showcase specimens ─────────────────────────────────────────────────── */

class _FaceTile extends StatelessWidget {
  const _FaceTile({
    required this.keyValue,
    required this.label,
    required this.state,
    this.voice = ElAgentVoice.rest,
  });

  final String keyValue;
  final String label;
  final ElAgentState state;
  final ElAgentVoice voice;

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
            child: ElAgentFace(
              state: state,
              voice: voice,
              size: ElAgentAvatarSize.lg,
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
          _FaceTile(
            keyValue: 'agent-face-preview:idle',
            label: 'Ready',
            state: ElAgentState.idle,
          ),
          SizedBox(width: el(6)),
          _FaceTile(
            keyValue: 'agent-face-preview:thinking',
            label: 'Thinking',
            state: ElAgentState.thinking,
          ),
          SizedBox(width: el(6)),
          const _FaceTile(
            keyValue: 'agent-face-preview:listening',
            label: 'Listening',
            state: ElAgentState.idle,
            voice: ElAgentVoice(listening: true),
          ),
          SizedBox(width: el(6)),
          const _FaceTile(
            keyValue: 'agent-face-preview:speaking',
            label: 'Speaking',
            state: ElAgentState.idle,
            voice: ElAgentVoice(speaking: true),
          ),
        ],
      ),
    ),
  );
}

const String _previewCode =
    '''
import 'package:elattar_design_system/elattar_design_system.dart';

ElAgentFace(state: ElAgentState.idle),
ElAgentFace(state: ElAgentState.thinking),
ElAgentFace(
  state: ElAgentState.idle,
  voice: ElAgentVoice(listening: true),
),
ElAgentFace(
  state: ElAgentState.idle,
  voice: ElAgentVoice(speaking: true),
)''';

const String _usageCode =
    '''
import 'package:elattar_design_system/elattar_design_system.dart';

ElAgentFace(state: ElAgentState.idle)''';

class _VoiceSpecimen extends StatelessWidget {
  const _VoiceSpecimen();

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      const _FaceTile(
        keyValue: 'agent-face-example:voice-rest',
        label: 'voice: rest',
        state: ElAgentState.callingTools,
      ),
      SizedBox(width: el(6)),
      const _FaceTile(
        keyValue: 'agent-face-example:voice-listening',
        label: 'listening: true',
        state: ElAgentState.callingTools,
        voice: ElAgentVoice(listening: true),
      ),
      SizedBox(width: el(6)),
      const _FaceTile(
        keyValue: 'agent-face-example:voice-speaking',
        label: 'speaking: true',
        state: ElAgentState.callingTools,
        voice: ElAgentVoice(speaking: true),
      ),
    ],
    ),
  );
}

const String _voiceCode =
    '''
// state never stops mattering underneath; voice.isActive just wins the
// paint while it is true.
ElAgentFace(state: ElAgentState.callingTools),
ElAgentFace(
  state: ElAgentState.callingTools,
  voice: ElAgentVoice(listening: true),
),
ElAgentFace(
  state: ElAgentState.callingTools,
  voice: ElAgentVoice(speaking: true),
)''';

class _StatusLineTile extends StatelessWidget {
  const _StatusLineTile({
    required this.keyValue,
    required this.state,
    this.voice = ElAgentVoice.rest,
  });

  final String keyValue;
  final ElAgentState state;
  final ElAgentVoice voice;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    key: ValueKey<String>(keyValue),
    constraints: BoxConstraints(maxWidth: el(56)),
    child: ElAgentStatusLine(state: state, voice: voice),
  );
}

class _StatusLineSpecimen extends StatelessWidget {
  const _StatusLineSpecimen();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      const _StatusLineTile(
        keyValue: 'agent-face-example:status-idle',
        state: ElAgentState.idle,
      ),
      SizedBox(height: el(4)),
      const _StatusLineTile(
        keyValue: 'agent-face-example:status-thinking',
        state: ElAgentState.thinking,
      ),
      SizedBox(height: el(4)),
      const _StatusLineTile(
        keyValue: 'agent-face-example:status-listening',
        state: ElAgentState.idle,
        voice: ElAgentVoice(listening: true),
      ),
      SizedBox(height: el(4)),
      const _StatusLineTile(
        keyValue: 'agent-face-example:status-speaking',
        state: ElAgentState.idle,
        voice: ElAgentVoice(speaking: true),
      ),
    ],
  );
}

const String _statusLineCode =
    '''
ElAgentStatusLine(state: ElAgentState.idle),
ElAgentStatusLine(state: ElAgentState.thinking),
ElAgentStatusLine(
  state: ElAgentState.idle,
  voice: ElAgentVoice(listening: true),
),
ElAgentStatusLine(
  state: ElAgentState.idle,
  voice: ElAgentVoice(speaking: true),
)''';

/// A renderer standing in for the artwork: `ElAgentAvatarBuilder`'s own
/// shape, positional, so a call site can hand over a closure without
/// restating every label. Draws a plain square the same size the real
/// avatar would occupy, to make the seam legible rather than pretty.
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
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: accent ?? theme.agent,
      borderRadius: BorderRadius.circular(ElRadii.md),
    ),
    child: ElText(
      state.name.substring(0, 1),
      ElType.chip,
      color: theme.background,
    ),
  );
}

class _CustomRendererSpecimen extends StatelessWidget {
  const _CustomRendererSpecimen();

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Column(
        key: const ValueKey<String>('agent-face-example:renderer-default'),
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            width: el(32),
            height: el(32),
            child: const Center(
              child: ElAgentFace(
                state: ElAgentState.running,
                size: ElAgentAvatarSize.lg,
              ),
            ),
          ),
          SizedBox(height: el(2)),
          ElText(
            'default (ElCubeAvatar)',
            ElType.caption,
            color: ElTheme.of(context).mutedForeground,
          ),
        ],
      ),
      SizedBox(width: el(6)),
      Column(
        key: const ValueKey<String>('agent-face-example:renderer-custom'),
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            width: el(32),
            height: el(32),
            child: Center(
              child: ElAgentFace(
                state: ElAgentState.running,
                size: ElAgentAvatarSize.lg,
                avatar: _squareRenderer,
              ),
            ),
          ),
          SizedBox(height: el(2)),
          ElText(
            'avatar: _squareRenderer',
            ElType.caption,
            color: ElTheme.of(context).mutedForeground,
          ),
        ],
      ),
    ],
    ),
  );
}

const String _customRendererCode =
    '''
Widget squareRenderer(
  BuildContext context,
  ElAgentState state,
  ElAgentAvatarSize size,
  Color? accent,
  double? speed,
) {
  final theme = ElTheme.of(context);
  return Container(
    width: size.box,
    height: size.box,
    color: accent ?? theme.agent,
  );
}

ElAgentFace(state: ElAgentState.running),
ElAgentFace(state: ElAgentState.running, avatar: squareRenderer)''';

/* ── Disclosure content ─────────────────────────────────────────────────── */

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsAnchor(
        id: 'api-elagentface',
        child: DocsApiTable(title: 'ElAgentFace', facts: _agentFaceFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elagentvoice',
        child: DocsApiTable(title: 'ElAgentVoice', facts: _agentVoiceFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elagentstatusline',
        child: DocsApiTable(
          title: 'ElAgentStatusLine',
          facts: _statusLineApiFacts,
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elagentshimmertext',
        child: DocsApiTable(
          title: 'ElAgentShimmerText',
          facts: _shimmerTextFacts,
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elagentavatarregistry',
        child: DocsApiTable(
          title: 'ElAgentAvatarRegistry',
          facts: _registryFacts,
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-builders',
        child: DocsApiTable(title: 'Builder typedefs', facts: _builderFacts),
      ),
    ],
  );
}

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'ElAgentFace carries no Semantics node of its own: it delegates '
            'entirely to whichever object it draws. Under voice.isActive '
            'that is Semantics(image: true, label: "Listening" or '
            '"Speaking") from ElVoiceOrb\'s own tree; otherwise it is '
            'ElCubeAvatar\'s Semantics(image: true, label: state.label) — '
            'or the custom renderer\'s own, if one was passed, which owns '
            'its accessible name entirely.',
        'ElAgentStatusLine wraps its label text in Semantics(liveRegion: '
            'true): a screen reader is told the sentence changed rather '
            'than left to notice on its own. This is the one liveRegion '
            'in the family — ElAgentFace\'s own avatar/orb swap carries '
            'none.',
        'The shimmer (ElAgentShimmerText) is a ShaderMask over the same '
            'text node: it changes how the label paints, never what it '
            'says or whether it is announced.',
      ]);
}

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'ElAgentFace, ElAgentStatusLine, and ElAgentShimmerText all take '
            'no focus and handle no key event: none wraps a Focus node or '
            'a GestureDetector. All three are display, not controls.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'No breakpoint branching anywhere in agent_face.dart: '
            'BuildContext width is never read for a layout decision.',
        'elAgentFaceSize(size) is the one bridge between the avatar\'s '
            'rung and the orb\'s own numeric size argument — FACE_SIZE in '
            'the reference — and it is exactly size.box: the orb occupies '
            'the same box the avatar would have.',
        'ElAgentStatusLine\'s Row is mainAxisSize.min with a Flexible '
            'label (maxLines: 1, TextOverflow.ellipsis): the sentence '
            'truncates before the waveform or bar visualiser beside it is '
            'squeezed.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      _bullets(ElTheme.of(context), <String>[
        'File: lib/src/components/agent_face.dart — one file, no '
            'companions; the registry manifest lists exactly one entry '
            'under "files".',
        'registryDependencies, resolved automatically by `elattar add '
            'agent-face`: agent-avatar, agent-core, keyframes, '
            'source-foundation, voice, voice-orb — copied verbatim from '
            'registry/components/agent-face.json. agent-avatar supplies '
            'ElCubeAvatar, the registry\'s default renderer; agent-core '
            'supplies ElAgentState; voice supplies ElLiveWaveform and '
            'ElBarVisualizer; voice-orb supplies the shader-backed '
            'ElVoiceOrb, imported through the registry rather than '
            'directly so a test can substitute a cheap one in front of it.',
        'semanticDependencies (the manifest\'s own, narrower field): the '
            'same six.',
      ]),
      SizedBox(height: el(4)),
      const DocsLinkRow(
        links: <DocsLink>[
          DocsLink(label: 'Agent Avatar', route: '/components/agent_avatar'),
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
        'ElAgentFace reads no colour directly: every colour belongs to '
            'whichever object it draws — ElCubeAvatar\'s theme.agent / '
            'theme.cube tokens, or ElVoiceOrb\'s own shader uniforms.',
        'ElAgentStatusLine\'s label is theme.foreground while live '
            '(shimmering or not, the shimmer paints over it) and '
            'theme.mutedForeground at rest — "the shimmer paints color: '
            'transparent and lets the gradient through, so the ink under '
            'the mask only matters when it is still."',
        'ElAgentShimmerText\'s gradient is base (theme.mutedForeground) → '
            'band (theme.agent) → base, a different three-stop shape from '
            'both ElShimmer and ElShimmerText: spelled out in this file '
            'rather than reused, because the source utility it ports, '
            'anim-shimmer-text, is a different animation from both.',
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

const List<DocsApiFact> _agentFaceFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'state',
    type: 'ElAgentState',
    description:
        'Required. Which of the twenty states the avatar half draws '
        'when voice is not active.',
  ),
  DocsApiFact(
    name: 'voice',
    type: 'ElAgentVoice',
    description:
        'Defaults to ElAgentVoice.rest. isActive overrides state '
        'entirely and swaps the avatar for the orb.',
  ),
  DocsApiFact(
    name: 'avatar',
    type: 'ElAgentAvatarBuilder?',
    description:
        'Null takes ElAgentAvatarRegistry.renderer — "swap the '
        'renderer, keep the machine."',
  ),
  DocsApiFact(
    name: 'size',
    type: 'ElAgentAvatarSize',
    description: 'Defaults to md. Passed straight through to the renderer.',
  ),
  DocsApiFact(name: 'accent', type: 'Color?', description: 'Passed straight through to the renderer.'),
  DocsApiFact(
    name: 'speed',
    type: 'double?',
    description: 'Passed straight through to the renderer.',
  ),
];

const List<DocsApiFact> _agentVoiceFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'listening',
    type: 'bool',
    description: 'Defaults to false. The user is speaking.',
  ),
  DocsApiFact(
    name: 'speaking',
    type: 'bool',
    description: 'Defaults to false. The assistant is speaking.',
  ),
  DocsApiFact(
    name: 'samples',
    type: 'ValueListenable<Float32List>?',
    description:
        'Time-domain samples for the waveform. Null draws a flat line.',
  ),
  DocsApiFact(
    name: 'spectrum',
    type: 'ValueListenable<Float32List>?',
    description: 'Frequency bins for the bar visualiser. Null draws silence.',
  ),
  DocsApiFact(
    name: 'level',
    type: 'ValueListenable<double>?',
    description: "0-1, for the orb's own shader.",
  ),
  DocsApiFact(
    name: 'isActive',
    type: 'bool get',
    description: 'listening || speaking.',
  ),
  DocsApiFact(
    name: 'rest',
    type: 'static const ElAgentVoice',
    description: 'const ElAgentVoice() — nothing happening in the room.',
  ),
];

const List<DocsApiFact> _statusLineApiFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'state',
    type: 'ElAgentState',
    description: 'Required. Supplies the label when voice is not active.',
  ),
  DocsApiFact(
    name: 'voice',
    type: 'ElAgentVoice',
    description: 'Defaults to ElAgentVoice.rest.',
  ),
  DocsApiFact(
    name: 'gap',
    type: 'static double get',
    description: 'el(2) — between the label and whichever visualiser shows.',
  ),
  DocsApiFact(
    name: 'waveformBox',
    type: 'static Size get',
    description: 'el(16) x el(4) — the listening waveform\'s own box.',
  ),
  DocsApiFact(
    name: 'barsBox',
    type: 'static Size get',
    description: 'el(12) x el(4) — the speaking bar visualiser\'s own box.',
  ),
  DocsApiFact(
    name: 'bars',
    type: 'static const int',
    description: '8 — how many bars the speaking visualiser draws.',
  ),
];

const List<DocsApiFact> _shimmerTextFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'child',
    type: 'Widget',
    description: 'Required. The text the shimmer band travels across.',
  ),
  DocsApiFact(
    name: 'period',
    type: 'static const Duration',
    description: 'ElDurations.shimmerText — 2.6s, infinite, no fill.',
  ),
  DocsApiFact(
    name: 'tileFactor',
    type: 'static const double',
    description: '2.2 — background-size: 220% 100% in the reference.',
  ),
  DocsApiFact(
    name: 'stops',
    type: 'static const List<double>',
    description: "[0.30, 0.50, 0.70] — the gradient's three stops.",
  ),
];

const List<DocsApiFact> _registryFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'renderer',
    type: 'static ElAgentAvatarBuilder',
    description:
        'Seeded to ElCubeAvatar. What ElAgentFace.avatar falls back to '
        'when left null.',
  ),
  DocsApiFact(
    name: 'orb',
    type: 'static ElAgentOrbBuilder',
    description: 'Seeded to ElVoiceOrb.',
  ),
  DocsApiFact(
    name: 'waveform',
    type: 'static ElAgentVisualiserBuilder',
    description: 'Seeded to ElLiveWaveform.',
  ),
  DocsApiFact(
    name: 'bars',
    type: 'static ElAgentVisualiserBuilder',
    description: 'Seeded to ElBarVisualizer.',
  ),
];

const List<DocsApiFact> _builderFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'ElAgentAvatarBuilder',
    type:
        'Widget Function(BuildContext, ElAgentState, ElAgentAvatarSize, '
        'Color?, double?)',
    description: 'What ElAgentFace.avatar and ElAgentAvatarRegistry.renderer take.',
  ),
  DocsApiFact(
    name: 'ElAgentOrbBuilder',
    type:
        'Widget Function(BuildContext, ElOrbState, '
        'ValueListenable<double>?, double)',
    description: 'What ElAgentAvatarRegistry.orb takes.',
  ),
  DocsApiFact(
    name: 'ElAgentVisualiserBuilder',
    type: 'Widget Function(BuildContext, ElAgentVoice, Size)',
    description:
        'What ElAgentAvatarRegistry.waveform and .bars take — the two '
        'visualisers ElAgentStatusLine puts beside the label.',
  ),
];

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'voice.isActive (listening or speaking)',
    treatment: 'ElAgentAvatarRegistry.orb, label "Listening"/"Speaking"',
    userSignal: 'Wins over state entirely, however busy the agent is.',
  ),
  DocsStateFact(
    state: 'state.isBusy, voice at rest',
    treatment: 'the renderer (default ElCubeAvatar), label state.label',
    userSignal: 'The working avatar.',
  ),
  DocsStateFact(
    state: 'idle / done / error, voice at rest',
    treatment: 'the renderer, label state.label',
    userSignal: 'The resting avatar (idle) or a terminal one.',
  ),
  DocsStateFact(
    state: 'status line: live (voice.isActive || state.isBusy)',
    treatment: 'ElAgentShimmerText over the label',
    userSignal: 'The sentence shimmers; it stands still otherwise.',
  ),
  DocsStateFact(
    state: 'hover / press / focus / selected / disabled / loading',
    treatment: 'N/A',
    userSignal:
        'ElAgentFace and ElAgentStatusLine take no pointer input and are '
        'not focusable: neither is a control.',
  ),
];
