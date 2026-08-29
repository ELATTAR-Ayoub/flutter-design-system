/// Public documentation metadata for the slider component.
///
/// Not yet added to `catalog.dart`'s `componentDocs` list: that aggregation,
/// and the registry manifest slider does not have yet, are supervisor-owned
/// (Phase J plan, "Supervisor duties between waves"). This entry exists so
/// `SliderDocPage` has real install-target, export and source facts to
/// render without inventing them, exactly the same shape the already
/// catalogued components use.
library;

import '../catalog.dart';

const ComponentDocEntry sliderDoc = ComponentDocEntry(
  name: 'slider',
  title: 'Slider',
  description:
      'A ranged control for one or more thumbs sliding along a track '
      'between a minimum and a maximum.',
  // What lib/src/components/ui/slider.dart itself imports from
  // lib/src/components/ui/: real source-level dependencies, not a verified
  // registry dependency list. Slider installs through `elattar add slider` (see
  // DocsInstallFacts on the page), so these are documented as internal
  // dependencies rather than claimed as CLI-resolvable ones.
  dependencies: <String>[
    'button',
    'surface',
    'selection-control',
    'source-foundation',
  ],
  exports: <String>['Slider'],
  sourcePath: 'lib/src/components/ui/slider.dart',
);
