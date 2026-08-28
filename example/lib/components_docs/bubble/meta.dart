/// Public documentation metadata for the `bubble` component.
///
/// `bubble` HAS a real `registry/components/bubble.json` manifest:
/// [dependencies] below is that manifest's own `registryDependencies` list,
/// copied verbatim — `press` (the reaction pill's own press feedback)
/// and `source-foundation`. `page.dart` renders the real `elattar add
/// bubble` command from it rather than a "not available yet" disclosure.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry bubbleDoc = ComponentDocEntry(
  name: 'bubble',
  title: 'Bubble',
  description:
      'The surface a message sits on: seven fill variants, two alignments, '
      'and a reactions rail that can hang off any corner, all driven off '
      'one variant flag so the painted surface can be swapped for a real '
      'button without restating a class.',
  // registry/components/bubble.json's own registryDependencies, verbatim.
  dependencies: <String>['press', 'source-foundation'],
  exports: <String>[
    'BubbleAlign',
    'BubbleVariant',
    'BubbleSide',
    'ShowCount',
    'BubbleGroup',
    'Bubble',
    'BubbleAlignScope',
    'BubbleContent',
    'BubbleReaction',
    'BubbleReactions',
  ],
  sourcePath: 'lib/src/components/bubble.dart',
);
