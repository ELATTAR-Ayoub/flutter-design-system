/// Public documentation metadata for the `agent-markdown` component.
///
/// `agent-markdown` has a real `registry/components/agent-markdown.json`
/// manifest: [dependencies] is that manifest's own `registryDependencies`,
/// copied verbatim (`['source-foundation']`).
///
/// [ComponentDocEntry.description] is the page's only rendered description:
/// the one-sentence form for nav, search, and the page's own hero line.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry agentMarkdownDoc = ComponentDocEntry(
  name: 'agent_markdown',
  title: 'Agent Markdown',
  description:
      'Renders formatted text — headings, bold and italic, lists, a '
      'blockquote, tables, fenced code — to a Flutter widget tree with no '
      'HTML parser and no dangerouslySetInnerHTML in the path.',
  // registry/components/agent-markdown.json's own registryDependencies,
  // verbatim.
  dependencies: <String>['source-foundation'],
  exports: <String>[
    'AgentMarkdown',
    'AgentCodeBlock',
    'PreformattedCode',
    'PrismPalette',
    'CodeToken',
    'safeHref',
    'languageAliases',
  ],
  sourcePath: 'lib/src/components/agent_markdown.dart',
);
