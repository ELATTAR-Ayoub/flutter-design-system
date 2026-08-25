/// Public documentation metadata for the `agent-face` component.
///
/// `registry/components/agent-face.json` exists and is installable today:
/// [dependencies] below is that manifest's own `registryDependencies`,
/// copied verbatim — `agent-avatar`, `agent-core`, `keyframes`,
/// `source-foundation`, `voice`, `voice-orb`.
///
/// `lib/src/components/agent_face.dart` is `parts/agent-face.tsx` ported:
/// which of two objects sits in the face's slot — the working avatar or the
/// listening/speaking voice orb — plus the sentence beside it. [exports]
/// lists every public name the file declares; the page documents
/// [ElAgentFace] (the widget a caller constructs), [ElAgentVoice] (the
/// value that decides which object wins), [ElAgentStatusLine] and
/// [ElAgentShimmerText] (the sentence, and the effect it wears while
/// busy), and [ElAgentAvatarRegistry] (the seam every one of those four
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
    'voice-orb',
  ],
  exports: <String>[
    'ElAgentFace',
    'ElAgentVoice',
    'ElAgentStatusLine',
    'ElAgentShimmerText',
    'ElAgentAvatarRegistry',
    'ElAgentAvatarBuilder',
    'ElAgentOrbBuilder',
    'ElAgentVisualiserBuilder',
  ],
  sourcePath: 'lib/src/components/agent_face.dart',
);
