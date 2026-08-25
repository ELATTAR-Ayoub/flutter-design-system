/// Public documentation metadata for the `agent-attachments` component.
///
/// `agent-attachments` has a real `registry/components/agent-attachments.json`
/// manifest: [dependencies] is that manifest's own `registryDependencies`,
/// copied verbatim (`['agent-core', 'attachment', 'button', 'dialog', 'icon',
/// 'source-foundation', 'tooltip']`).
///
/// [ComponentDocEntry.description] is the page's only rendered description:
/// the one-sentence form for nav, search, and the page's own hero line.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry agentAttachmentsDoc = ComponentDocEntry(
  name: 'agent_attachments',
  title: 'Agent Attachments',
  description:
      'A file the user picked and a file the agent produced draw through '
      'the same card — plus a delivery badge that says whether the '
      "model's bytes, or only its filename, actually reached it.",
  // registry/components/agent-attachments.json's own registryDependencies,
  // verbatim.
  dependencies: <String>[
    'agent-core',
    'attachment',
    'button',
    'dialog',
    'icon',
    'source-foundation',
    'tooltip',
  ],
  exports: <String>[
    'ElAgentAttachmentCard',
    'ElAgentAttachmentList',
    'ElAgentDeliveryBadge',
    'elAgentAttachmentGlyph',
    'elAgentAttachmentIsVideo',
  ],
  sourcePath: 'lib/src/components/agent_attachments.dart',
);
