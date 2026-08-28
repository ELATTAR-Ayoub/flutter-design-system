/// Public documentation metadata for the `agent-attach-menu` component.
///
/// `agent-attach-menu` has a real `registry/components/agent-attach-menu.json`
/// manifest: [dependencies] is that manifest's own `registryDependencies`,
/// copied verbatim (`['agent-slash-palette', 'button', 'dropdown-menu', 'icon',
/// 'menu', 'popover', 'source-foundation']`).
///
/// [ComponentDocEntry.description] is the page's only rendered description:
/// the one-sentence form for nav, search, and the page's own hero line.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry agentAttachMenuDoc = ComponentDocEntry(
  name: 'agent_attach_menu',
  title: 'Agent Attach Menu',
  description:
      'The plus beside the composer: one control for picking a file or '
      'running a skill, built on MenuSurface and MenuPointerDown over '
      'Popover rather than the arrow-key-navigable DropdownMenu.',
  // registry/components/agent-attach-menu.json's own registryDependencies,
  // verbatim.
  dependencies: <String>[
    'agent-slash-palette',
    'button',
    'dropdown-menu',
    'icon',
    'menu',
    'popover',
    'source-foundation',
  ],
  exports: <String>['AgentAttachMenu'],
  sourcePath: 'lib/src/components/agent_attach_menu.dart',
);
