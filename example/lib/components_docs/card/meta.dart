/// Public documentation metadata for the `card` component.
///
/// `card` HAS a real `registry/components/card.json` manifest:
/// [dependencies] below is that manifest's own `registryDependencies` list,
/// copied verbatim — one entry, `source-foundation`. `page.dart` renders the
/// real `elattar add card` command from it rather than a "not available yet"
/// disclosure.
///
/// This page used to be hand-composed, as `CardDocPage` inside the retired
/// `components_docs/button_card_pages.dart`. It is re-housed here onto the
/// `button`/`field` reference shape: see `page.dart`'s own library doc.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry cardDoc = ComponentDocEntry(
  name: 'card',
  title: 'Card',
  description:
      'A structured content surface: header, title, description, action, '
      'content, and footer regions, composed by hand from six small '
      'widgets rather than toggled by flags on one big one.',
  // registry/components/card.json's own registryDependencies, verbatim.
  dependencies: <String>['source-foundation'],
  exports: <String>[
    'ElCard',
    'ElCardHeader',
    'ElCardTitle',
    'ElCardDescription',
    'ElCardContent',
    'ElCardFooter',
  ],
  sourcePath: 'lib/src/components/card.dart',
);
