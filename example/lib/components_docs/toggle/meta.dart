/// Public documentation metadata for the toggle and toggle-group components.
///
/// Not yet added to `catalog.dart`'s `componentDocs` list — that aggregation,
/// and the registry manifest neither component has yet, are supervisor-owned
/// (Phase J plan, "Supervisor duties between waves"). This entry exists so
/// `ToggleDocPage` has real install-target, export and source facts to render
/// without inventing them, exactly the same shape the five already-catalogued
/// components use.
///
/// One [ComponentDocEntry], not two: the brief documents `DsToggle` and
/// `DsToggleGroup` on a single page, because the group's semantics (a
/// `ToggleGroupItem` *is* a `DsToggle` underneath, per `toggle_group.dart`'s
/// own library doc) only make sense read alongside the item's. `sourcePath`
/// names `toggle.dart`, the item component both share; `toggle_group.dart` is
/// documented explicitly in the page's own Dependencies section rather than
/// claimed by a second entry `ComponentDocEntry` has no room for.
library;

import '../catalog.dart';

/// IA §9.2's *expanded* description: not what a toggle is, but when to reach
/// for one instead of a neighbour — [DsSwitch], [DsCheckbox], and, for the
/// group, [DsRadioGroup]/[DsTabs]/`IconSwap`. A second top-level constant,
/// beside [toggleDoc], for the same reason `switch/meta.dart` carries
/// `switchExpandedDescription`: [ComponentDocEntry] has only one description
/// field, and the two-description contract still has to be met from a file
/// this worker owns rather than by editing the supervisor-owned class.
const String toggleExpandedDescription =
    'A toggle is a small button that remembers whether it was pressed — '
    'bold in a text toolbar, mute on a call bar, a favourited card — and, '
    'like DsSwitch, it takes effect the instant it is pressed, with no '
    'separate submit step. Reach for DsSwitch instead when the control '
    'reads as a labelled boolean property in a settings list ("Dark mode") '
    'rather than a small, often unlabelled, icon-only action living beside '
    'others in a toolbar. Reach for DsCheckbox instead when the value is '
    'gathered and read later by something else — a form submit, a bulk '
    "action — rather than acted on the moment it changes. DsToggleGroup "
    'extends the same remembers-whether-it-was-pressed idea to three or '
    'more mutually exclusive options sharing one travelling selection '
    'pill: reach for DsRadioGroup instead when the options carry a value a '
    'form submits; reach for DsTabs instead when selecting an option also '
    'swaps the content beneath it — a toggle group only ever reports which '
    'option is selected, it renders no content pane of its own. With '
    'exactly two options, reach for IconSwap instead: DsToggleGroupItem '
    "documents the group itself as being for “three or more,” because a "
    'two-item segmented control wastes space and reads as weaker than it '
    'is.';

const ComponentDocEntry toggleDoc = ComponentDocEntry(
  name: 'toggle',
  title: 'Toggle',
  description:
      'A two-state pressed control, and the mutually exclusive segmented '
      'group built from it.',
  // No registry manifest exists for toggle or toggle-group yet (deliberately
  // not added by this worker — see the "Installation" section of the page
  // itself), so there are no registry dependencies to resolve automatically.
  dependencies: <String>[],
  exports: <String>[
    'DsToggle',
    'DsToggleVariant',
    'DsToggleSize',
    'DsToggleGroup',
    'DsToggleGroupItem',
  ],
  sourcePath: 'lib/src/components/toggle.dart',
);

/// The sibling source file [toggleDoc]'s single `sourcePath` field cannot
/// also name — read directly wherever the page cites the group's own file.
const String toggleGroupSourcePath = 'lib/src/components/toggle_group.dart';
