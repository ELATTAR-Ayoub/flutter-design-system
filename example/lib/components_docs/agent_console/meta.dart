/// Public documentation metadata for the `agent-console` component.
///
/// `agent-console` HAS a real `registry/components/agent-console.json`
/// manifest: [dependencies] below is that manifest's own
/// `registryDependencies` list, copied verbatim: `agent-avatar`,
/// `agent-composer`, `agent-core`, `agent-face`, `agent-history`,
/// `agent-slash-palette`, `agent-transcript`, `button`, `dropdown-menu`,
/// `icon`, `marker`, `menu`, `popover`, `source-foundation`.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry agentConsoleDoc = ComponentDocEntry(
  name: 'agent-console',
  title: 'Agent Console',
  description:
      'The whole assistant, pointed at a transport: it owns the composer, '
      'the transcript, the face and the voice; it owns no protocol, no '
      'persona and no product knowledge.',
  // registry/components/agent-console.json's own registryDependencies,
  // verbatim.
  dependencies: <String>[
    'agent-avatar',
    'agent-composer',
    'agent-core',
    'agent-face',
    'agent-history',
    'agent-slash-palette',
    'agent-transcript',
    'button',
    'dropdown-menu',
    'icon',
    'marker',
    'menu',
    'popover',
    'source-foundation',
  ],
  exports: <String>[
    'AgentConsole',
    'AgentFeatures',
    'AgentPersona',
    'AgentModel',
  ],
  sourcePath: 'lib/src/blocks/agent_console/agent_console.dart',
);
