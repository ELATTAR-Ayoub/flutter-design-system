/// Public documentation metadata for the checkbox component.
///
/// Not yet added to `catalog.dart`'s `componentDocs` list: that aggregation,
/// and the registry manifest checkbox does not have yet, are supervisor-owned
/// (Phase J plan, "Supervisor duties between waves"). This entry exists so
/// `CheckboxDocPage` has real install-target, export and source facts to
/// render without inventing them, exactly the same shape the five already
/// catalogued components use.
///
/// [ComponentDocEntry.description] is the one-sentence form for nav and
/// search. [checkboxExpandedDescription] is the longer "checkbox vs its two
/// neighbours" hero copy the page itself renders directly under the title,
/// unwrapped in any `DsSection`, the same shape `button`'s
/// `buttonExpandedDescription` establishes as the reference pattern.
library;

import '../catalog.dart';

/// The page's hero description: what a checkbox is *for*, argued against its
/// two real neighbours, DsSwitch and DsRadioGroup, rather than restated as a
/// definition.
const String checkboxExpandedDescription =
    'A checkbox holds one value a user sets independently of every other '
    'option on the screen, "notify me by email" is true or false on its '
    'own, with no relationship to any sibling setting, and nothing happens '
    'until whatever reads it does (a form submit, a filter recompute, a '
    'bulk action). Reach for DsSwitch instead when the toggle has an '
    'immediate, standalone effect the instant it flips, with no separate '
    'submit step (a settings page\'s "Dark mode" row). Reach for '
    'DsRadioGroup instead when the user is choosing exactly one option out '
    'of a mutually exclusive set (a shipping method): a checkbox says '
    '"these can all be true independently," a radio group says "only one '
    'of these can be true." Checkbox is also the only one of the three '
    'that can render a third value, DsCheckboxState.indeterminate, for a '
    'parent control reflecting a partial selection among its children: a '
    'state neither a switch nor a radio button has any way to represent.';

const ComponentDocEntry checkboxDoc = ComponentDocEntry(
  name: 'checkbox',
  title: 'Checkbox',
  description:
      'A tri-state control for one value a user can toggle independently of '
      'any other option.',
  // No registry manifest exists for checkbox yet (deliberately not added by
  // this worker: see the "Installation" section of the page itself), so
  // there are no registry dependencies to resolve automatically.
  dependencies: <String>[],
  exports: <String>['DsCheckbox', 'DsCheckboxState'],
  sourcePath: 'lib/src/components/checkbox.dart',
);
