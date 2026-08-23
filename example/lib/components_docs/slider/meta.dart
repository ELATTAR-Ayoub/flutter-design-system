/// Public documentation metadata for the slider component.
///
/// Not yet added to `catalog.dart`'s `componentDocs` list — that aggregation,
/// and the registry manifest slider does not have yet, are supervisor-owned
/// (Phase J plan, "Supervisor duties between waves"). This entry exists so
/// `SliderDocPage` has real install-target, export and source facts to
/// render without inventing them, exactly the same shape the already
/// catalogued components use.
library;

import '../catalog.dart';

/// IA §9.2's *expanded* description: not what a slider is, but when to reach
/// for one instead of a neighbour — specifically a numeric [DsInput], the
/// control it is most often confused with. Kept as a second top-level
/// constant, beside [sliderDoc], because [ComponentDocEntry] carries only one
/// description field and the two-description contract still has to be met
/// from a file this worker owns rather than by editing the supervisor-owned
/// class.
const String sliderExpandedDescription =
    'Reach for a slider when the user is making an imprecise, relative '
    'adjustment — dragging toward "about here," "roughly this loud," or '
    '"somewhere in this price band" — and the track itself states the whole '
    'legal range visually, so no separate min/max copy has to be written for '
    'it. Reach for a numeric DsInput instead when the user already knows the '
    'exact value they mean to enter — a birth year, a quantity, a price '
    'copied from a receipt — because a slider forces them to eyeball a '
    'position on a track rather than type the number they have in mind, and '
    'it has no way to enter a value outside the track it draws. Passing one '
    'entry in DsSlider.values renders a single-value slider; passing two (or '
    'more) renders a range slider with one thumb per entry — the same '
    'widget and the same constructor, not a separate class the way '
    'DsCheckboxState is a separate enum for a third checkbox state.';

const ComponentDocEntry sliderDoc = ComponentDocEntry(
  name: 'slider',
  title: 'Slider',
  description:
      'A ranged control for one or more thumbs sliding along a track '
      'between a minimum and a maximum.',
  // What lib/src/components/slider.dart itself imports from
  // lib/src/components/ — real source-level dependencies, not a verified
  // registry dependency list. Slider has no registry manifest yet (see
  // DocsInstallFacts on the page), so these are documented as internal
  // dependencies rather than claimed as CLI-resolvable ones.
  dependencies: <String>['button', 'selection_control'],
  exports: <String>['DsSlider'],
  sourcePath: 'lib/src/components/slider.dart',
);
