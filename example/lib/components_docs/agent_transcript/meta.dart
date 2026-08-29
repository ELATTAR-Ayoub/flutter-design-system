/// Public documentation metadata for the `agent-transcript` component.
///
/// `agent-transcript` HAS a real `registry/components/agent-transcript.json`
/// manifest: [dependencies] below is that manifest's own
/// `registryDependencies` list, copied verbatim: `agent-attachments`,
/// `agent-core`, `agent-markdown`, `button`, `icon`, `keyframes`,
/// `source-foundation`.
///
/// `agent_transcript.dart` is a family of parts, not one widget — the same
/// shape `field` documents: every kind of row a transcript can draw
/// (`UserMessage`, `AgentMessage`, `ToolChip`, `ActionChip`,
/// `ApprovalCard`, `WelcomeCard`) plus the small entrance utilities
/// (`TypingCursor`, `FadeUp`, `RowIn`) and the plain data class
/// (`AgentCapability`) they all share.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry agentTranscriptDoc = ComponentDocEntry(
  name: 'agent-transcript',
  title: 'Agent Transcript',
  description:
      'Every kind of row an agent conversation can draw: a user bubble, '
      'flush agent prose with a typing cursor, a disclosure tool chip, an '
      'action chip, an approval card, and the empty-conversation welcome '
      'card.',
  // registry/components/agent-transcript.json's own registryDependencies,
  // verbatim.
  dependencies: <String>[
    'agent-attachments',
    'agent-core',
    'agent-markdown',
    'button',
    'icon',
    'keyframes',
    'source-foundation',
  ],
  exports: <String>[
    'UserMessage',
    'AgentMessage',
    'TypingCursor',
    'ToolChip',
    'ActionChip',
    'ApprovalCard',
    'FadeUp',
    'RowIn',
    'AgentCapability',
    'WelcomeCard',
  ],
  sourcePath: 'lib/src/components/ui/agent_transcript.dart',
);
