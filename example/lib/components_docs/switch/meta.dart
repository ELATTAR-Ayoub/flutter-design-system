/// Public documentation metadata for the switch component.
///
/// [ComponentDocEntry] itself is defined in `catalog.dart`, which this file
/// only imports — the catalog's aggregate `componentDocs` list is
/// supervisor-owned and does not carry this entry yet, so `page.dart` reads
/// [switchDoc] directly rather than looking it up through `componentDoc`.
library;

import '../catalog.dart';

/// IA §9.2's *expanded* description: not what a switch is, but when to reach
/// for one instead of a neighbour — specifically [DsCheckbox], the control it
/// is most often confused with. Kept as a second top-level constant, beside
/// [switchDoc], because [ComponentDocEntry] carries only one description
/// field and the two-description contract still has to be met from a file
/// this worker owns rather than by editing the supervisor-owned class.
const String switchExpandedDescription =
    'Reach for a switch when flipping it takes effect immediately — a '
    'setting that is already true the moment the thumb moves, with no Save '
    'button anywhere on the screen. Reach for a checkbox instead when the '
    'value is captured and submitted with the rest of a form, including '
    'inside a list where several boxes are gathered before one action '
    'commits them. The same boolean, two different promises to the user: a '
    'switch says "this is already on," a checkbox says "this is what I '
    'intend, once I submit."';

const ComponentDocEntry switchDoc = ComponentDocEntry(
  name: 'switch',
  title: 'Switch',
  description:
      'A boolean control that takes effect the instant it is flipped — no '
      'separate save step.',
  // What lib/src/components/switch.dart itself imports from
  // lib/src/components/ — real source-level dependencies, not a verified
  // registry dependency list. Switch has no registry manifest yet (see
  // DocsInstallFacts on the page), so these are documented as internal
  // dependencies rather than claimed as CLI-resolvable ones.
  dependencies: <String>['field', 'selection_control'],
  exports: <String>['DsSwitch', 'DsSwitchSize'],
  sourcePath: 'lib/src/components/switch.dart',
);
