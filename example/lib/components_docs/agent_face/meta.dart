/// Public documentation metadata for the `agent-face` component.
///
/// `registry/components/agent-face.json` exists and is installable today:
/// [dependencies] below is that manifest's own `registryDependencies`,
/// copied verbatim — `agent-avatar`, `agent-core`, `keyframes`,
/// `source-foundation`, `voice`, `voice-indicator`.
///
/// `lib/src/components/agent_face.dart` is `parts/agent-face.tsx` ported:
/// which of two objects sits in the face's slot — the working avatar or the
/// listening/speaking voice orb — plus the sentence beside it. [exports]
/// lists every public name the file declares; the page documents
/// [AgentFace] (the widget a caller constructs), [AgentVoice] (the
/// value that decides which object wins), [AgentStatusLine] and
/// [AgentStatusText] (the sentence, and the effect it wears while
/// busy), and [AgentAvatarRegistry] (the seam every one of those four
/// resolves its renderer through) in full.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry agentFaceDoc = ComponentDocEntry(
  name: 'agent_face',
  title: 'Agent Face',
  description:
      'What the assistant looks like right now: the working avatar or the '
      'listening/speaking voice orb, whichever is the more urgent fact, '
      'plus the status sentence beside it.',
  dependencies: <String>[
    'agent-avatar',
    'agent-core',
    'keyframes',
    'source-foundation',
    'voice',
    'voice-indicator',
  ],
  exports: <String>[
    'AgentFace',
    'AgentVoice',
    'AgentStatusLine',
    'AgentStatusText',
    'AgentAvatarRegistry',
    'AgentAvatarBuilder',
    'AgentOrbBuilder',
    'AgentVisualiserBuilder',
  ],
  sourcePath: 'lib/src/components/agent_face.dart',
);
