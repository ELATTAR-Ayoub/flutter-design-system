/// Public documentation metadata for the `button` component.
///
/// `button` HAS a real `registry/components/button.json` manifest:
/// [dependencies] below is that manifest's own `registryDependencies` list,
/// copied verbatim: `premium-surface`, `surface`, `action-feedback`,
/// `source-foundation`, `spinner`. `page.dart` renders the
/// real `elattar add button` command from it rather than a "not available
/// yet" disclosure.
///
/// [ComponentDocEntry.description] is the one-sentence form for nav, search,
/// and the page's own hero line. The page no longer renders a second,
/// longer "button vs link" paragraph beneath it.
///
/// This page is the Phase F/J **reference shape** other component pages will
/// be reshaped to match: see `page.dart`'s own library doc for the section
/// order this establishes.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry buttonDoc = ComponentDocEntry(
  name: 'button',
  title: 'Button',
  description:
      'A pill-shaped control with seven variants, nine sizes, loading and '
      'disabled states, and a springing focus ring: for triggering an '
      'action, never for navigating to one.',
  // registry/components/button.json's own registryDependencies, verbatim.
  dependencies: <String>[
    'premium-surface',
    'surface',
    'action-feedback',
    'source-foundation',
    'spinner',
  ],
  exports: <String>[
    'Button',
    'ButtonVariant',
    'ButtonSize',
    'ButtonEmphasis',
    'ButtonStyleRecipe',
  ],
  sourcePath: 'lib/src/components/ui/button.dart',
);
