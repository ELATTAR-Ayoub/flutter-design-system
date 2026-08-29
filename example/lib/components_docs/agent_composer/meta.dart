/// Public documentation metadata for the `agent-composer` component.
///
/// `agent-composer` HAS a real `registry/components/agent-composer.json`
/// manifest: [dependencies] below is that manifest's own
/// `registryDependencies` list, copied verbatim: `agent-attach-menu`,
/// `agent-attachments`, `agent-core`, `agent-slash-palette`, `button`,
/// `icon`, `input`, `surface`, `source-foundation`.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry agentComposerDoc = ComponentDocEntry(
  name: 'agent-composer',
  title: 'Agent Composer',
  description:
      'The growing textarea an agent console sends from: attachments, a '
      'plus menu, a slash-command palette, and a send button that becomes '
      'a stop button while the agent is answering.',
  // registry/components/agent-composer.json's own registryDependencies,
  // verbatim.
  dependencies: <String>[
    'agent-attach-menu',
    'agent-attachments',
    'agent-core',
    'agent-slash-palette',
    'button',
    'icon',
    'input',
    'surface',
    'source-foundation',
  ],
  exports: <String>['AgentComposer'],
  sourcePath: 'lib/src/components/ui/agent_composer.dart',
);
