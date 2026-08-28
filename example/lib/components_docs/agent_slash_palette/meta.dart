/// Public documentation metadata for the `agent-slash-palette` component.
///
/// `agent-slash-palette` has a real `registry/components/agent-slash-palette.json`
/// manifest: [dependencies] is that manifest's own `registryDependencies`,
/// copied verbatim (`['icon', 'source-foundation']`).
///
/// [ComponentDocEntry.description] is the page's only rendered description:
/// the one-sentence form for nav, search, and the page's own hero line.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry agentSlashPaletteDoc = ComponentDocEntry(
  name: 'agent_slash_palette',
  title: 'Agent Slash Palette',
  description:
      'The `/` menu: a stateless list of skills and browser commands, '
      'grouped and highlighted by whatever index its caller — the '
      'composer — hands it.',
  // registry/components/agent-slash-palette.json's own registryDependencies,
  // verbatim.
  dependencies: <String>['icon', 'source-foundation'],
  exports: <String>[
    'AgentSlashPalette',
    'AgentCommand',
    'AgentCommandGroup',
    'slashQuery',
    'filterCommands',
  ],
  sourcePath: 'lib/src/components/agent_slash_palette.dart',
);
