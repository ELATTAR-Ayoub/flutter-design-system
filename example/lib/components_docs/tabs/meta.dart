/// Public documentation metadata for the tabs component.
///
/// Not yet added to `catalog.dart`'s `componentDocs` list: that aggregation,
/// and the registry manifest tabs does not have yet, are supervisor-owned
/// (Phase J plan, "Supervisor duties between waves"). This entry exists so
/// `TabsDocPage` has real install-target, export and source facts to render
/// without inventing them, the same shape the five already catalogued
/// components use.
///
/// [ComponentDocEntry.description] is the one-sentence form for nav and
/// search. [tabsExpandedDescription] is the longer "when to reach for tabs
/// versus its two real neighbours" hero copy the page renders unlabelled,
/// directly under the title: the same split `button`'s
/// `buttonExpandedDescription` already uses.
library;

import '../catalog.dart';

/// The page's hero description: what tabs are for, argued against the two
/// controls a reader might reach for instead.
const String tabsExpandedDescription =
    'Tabs switch which panel of a single page is visible: every panel '
    'already belongs to the same screen, and picking a trigger swaps which '
    'one is shown while everything else (the route, the scaffold, the rest '
    'of the page) stays put. Reach for DsToggleGroup instead when there is '
    'no panel to reveal at all: a toggle group\'s selection is itself the '
    'payload the caller reads back (a sort order, a filter, a unit '
    'system), with nothing hidden underneath and shown on change. Reach '
    'for a navigation control (DsNavigationMenu, a sidebar entry, a route '
    'push) instead when picking an option should change the page itself: '
    'a new route, new browser history, a deep-linkable location: rather '
    'than swap a child within the one you are already on. Tabs and '
    'DsToggleGroup share their entire selection mechanism (the same '
    'DsSlidingPillGroup travelling mark this file\'s own docstring points '
    'at), so the two look and move identically; the only difference is '
    'what the selection means afterward. One more distinction worth '
    'knowing before reaching for either: DsToggleGroupItem carries its own '
    'enabled flag so a single option can be turned off, and DsTabItem has '
    'no equivalent: every tab this component renders is always operable.';

const ComponentDocEntry tabsDoc = ComponentDocEntry(
  name: 'tabs',
  title: 'Tabs',
  description:
      'A track of triggers with one travelling mark, switching between the '
      'panels of a single page.',
  // No registry manifest exists for tabs yet (deliberately not added by this
  // worker: see the "Installation" section of the page itself), so there
  // are no registry dependencies to resolve automatically.
  dependencies: <String>[],
  exports: <String>['DsTabs', 'DsTabItem', 'DsTabsVariant'],
  sourcePath: 'lib/src/components/tabs.dart',
);
