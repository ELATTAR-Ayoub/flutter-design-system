/// Public documentation metadata for the `agent-launcher` component.
///
/// `registry/components/agent-launcher.json` exists and is installable
/// today: [dependencies] below is that manifest's own
/// `registryDependencies`, copied verbatim — `agent-core`, `agent-face`,
/// `button`, `dialog`, `source-foundation`.
///
/// `lib/src/components/ui/agent_launcher.dart` ports `agent-launcher.tsx`: a
/// fixed-position trigger — the same face the console header shows, at
/// rest — that opens whatever is passed as [AgentLauncher.child] in a
/// wide dialog. [exports] lists the one public class the file declares;
/// the page documents it in full, statics included.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry agentLauncherDoc = ComponentDocEntry(
  name: 'agent_launcher',
  title: 'Agent Launcher',
  description:
      'A fixed-position entrance to the agentAccent: the same face the console '
      'shows at rest, its label riding out on hover, opening whatever is '
      'passed to it in a wide dialog.',
  dependencies: <String>[
    'agent-core',
    'agent-face',
    'button',
    'dialog',
    'source-foundation',
  ],
  exports: <String>['AgentLauncher'],
  sourcePath: 'lib/src/components/ui/agent_launcher.dart',
);
