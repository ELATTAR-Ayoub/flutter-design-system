/// Public documentation metadata for the `message-scroller` component.
///
/// `message-scroller` HAS a real `registry/components/message-scroller.json`
/// manifest: [dependencies] below is that manifest's own
/// `registryDependencies` list, copied verbatim — `button` (the jump-to-edge
/// control), `icon` (its arrow glyph) and `source-foundation`. `page.dart`
/// renders the real `elattar add message-scroller` command from it rather
/// than a "not available yet" disclosure.
///
/// [ComponentDocEntry.name] is spelled with the hyphen, matching the
/// registry's own item name and `documentationRoute`
/// (`/components/message-scroller`) directly — the same convention
/// `alert-dialog` and `dropdown-menu` use, and unlike those two spelled with
/// an underscore, an underscore here would derive the wrong route.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry messageScrollerDoc = ComponentDocEntry(
  name: 'message-scroller',
  title: 'Message Scroller',
  description:
      'A transcript viewport that manages its own scroll: a provider, a '
      'scrolling viewport with a bottom fade, per-item message ids, a '
      'scroll anchor, and a jump-to-edge button that hides itself once '
      'that direction has nowhere left to go.',
  // registry/components/message-scroller.json's own registryDependencies,
  // verbatim.
  dependencies: <String>['button', 'icon', 'source-foundation'],
  exports: <String>[
    'ScrollPosition',
    'ScrollDirection',
    'MessageScrollerController',
    'MessageScrollerProvider',
    'MessageScroller',
    'MessageScrollerViewport',
    'ScrollFade',
    'MessageScrollerContent',
    'MessageScrollerItem',
    'MessageScrollerButton',
  ],
  sourcePath: 'lib/src/components/ui/message_scroller.dart',
);
