/// Public documentation metadata for the switch component.
///
/// [ComponentDocEntry] itself is defined in `catalog.dart`, which this file
/// only imports: the catalog's aggregate `componentDocs` list is
/// supervisor-owned and does not carry this entry yet, so `page.dart` reads
/// [switchDoc] directly rather than looking it up through `componentDoc`.
library;

import '../catalog.dart';

const ComponentDocEntry switchDoc = ComponentDocEntry(
  name: 'switch',
  title: 'Switch',
  description:
      'A boolean control that takes effect the instant it is flipped: no '
      'separate save step.',
  // What lib/src/components/ui/switch.dart itself imports from
  // lib/src/components/ui/: real source-level dependencies, not a verified
  // registry dependency list. Switch installs through `elattar add switch` (see
  // DocsInstallFacts on the page), so these are documented as internal
  // dependencies rather than claimed as CLI-resolvable ones.
  dependencies: <String>[
    'field',
    'surface',
    'selection-control',
    'source-foundation',
  ],
  exports: <String>['Switch', 'SwitchSize'],
  sourcePath: 'lib/src/components/ui/switch.dart',
);
