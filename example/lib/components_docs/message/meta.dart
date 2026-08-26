/// Public documentation metadata for the `message` component.
///
/// `message` HAS a real `registry/components/message.json` manifest:
/// [dependencies] below is that manifest's own `registryDependencies` list,
/// copied verbatim — `bubble` (a message's own content column is built from
/// bubbles) and `source-foundation`. `page.dart` renders the real `elattar
/// add message` command from it rather than a "not available yet"
/// disclosure.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry messageDoc = ComponentDocEntry(
  name: 'message',
  title: 'Message',
  description:
      'The layout of one turn: an optional avatar beside a header, a run '
      'of bubbles and a footer, with a single align that flips the whole '
      'row — six flex containers sharing one group, holding no state and '
      'knowing nothing about what is inside them.',
  // registry/components/message.json's own registryDependencies, verbatim.
  dependencies: <String>['bubble', 'source-foundation'],
  exports: <String>[
    'ElMessageGroup',
    'ElMessage',
    'ElMessageScope',
    'ElMessageAvatar',
    'ElMessageContent',
    'ElMessageHeader',
    'ElMessageFooter',
  ],
  sourcePath: 'lib/src/components/message.dart',
);
