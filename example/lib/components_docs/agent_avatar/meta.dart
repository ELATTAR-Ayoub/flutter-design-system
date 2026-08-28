/// Public documentation metadata for the `agent-avatar` component.
///
/// `registry/components/agent-avatar.json` exists and is installable today:
/// [dependencies] below is that manifest's own `registryDependencies`,
/// copied verbatim — `agent-core`, `keyframes`, `source-foundation`.
///
/// `lib/src/components/agent_avatar.dart` is one file that folds four
/// reference files into one library: the isometric cube projection, the
/// nineteen scene recipes, the fourteen keyframe tables, and
/// [AgentAvatar] — the crossfade and the idle cube — itself. [exports]
/// lists every public class, enum and widget the file declares; the page
/// documents [AgentAvatar] and [AgentAvatarSize] in full (the surface a
/// caller actually constructs) and [CubeScene] as the one other
/// constructible widget, with the rest of the scene engine — the isometric
/// math, the keyframe tables, the per-scene recipes — named and described
/// rather than tabulated field by field: nothing in `agent_avatar.dart`
/// calls them a public API, they are the machine [AgentAvatar] runs on.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry agentAvatarDoc = ComponentDocEntry(
  name: 'agent_avatar',
  title: 'Agent Avatar',
  description:
      'The default face of a working agentAccent: twenty isometric cube scenes, '
      'one per state, cross-fading between them, recoloured by a single '
      'accent token.',
  dependencies: <String>['agent-core', 'keyframes', 'source-foundation'],
  exports: <String>[
    'AgentAvatar',
    'AgentAvatarSize',
    'CubeScene',
    'AgentCubeScene',
    'AgentCubeSpec',
    'AgentCubeMotion',
    'AgentCubeKeyframe',
    'AgentCubeKeyframes',
    'AgentCubeFaces',
    'AgentCube',
  ],
  sourcePath: 'lib/src/components/agent_avatar.dart',
);
