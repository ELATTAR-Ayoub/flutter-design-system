/// Public documentation metadata for the `collapsible` component.
///
/// `lib/src/components/collapsible.dart` exports two public classes:
/// [DsCollapsible] (the disclosure) and [DsUnfold] (the shared expand/collapse
/// animation `DsAccordion` also mounts per open item). Both are named in
/// [exports] because both are part of what a reader installs by copying this
/// one source file.
///
/// Collapsible has no `registry/components/collapsible.json` manifest yet —
/// see `page.dart`'s install section for the honest, un-invented statement of
/// that fact. [dependencies] still names the real transitive foundation the
/// widget imports today, so the fact is accurate the moment a manifest is
/// added.
///
/// [ComponentDocEntry.description] is the one-sentence form for nav and
/// search. [collapsibleExpandedDescription] is the longer hero copy the page
/// itself uses, argued against Collapsible's one real neighbour (Accordion)
/// rather than restated as a definition: the same shape `button`'s
/// `buttonExpandedDescription` and `popover`'s `popoverExpandedDescription`
/// already use.
library;

import '../catalog.dart';

/// The page's hero description: what tells two disclosures that share one
/// animation and one visual mechanic (DsUnfold) apart is coordination, not
/// looks. Also states, once, that DsCollapsible declares no variant or size
/// enum of its own, so a reader does not go looking for one later.
const String collapsibleExpandedDescription =
    'Both DsCollapsible and DsAccordion share one animation, DsUnfold, and '
    'one visual mechanic: a trigger that flips a boolean and a panel that '
    'unfolds under it. What differs is coordination. Accordion manages a '
    'set of items and decides which one is open, so opening a new item can '
    'close another. Collapsible manages exactly one open flag that only the '
    'caller changes, so two Collapsibles on the same page never know about '
    'each other: see Independent instances below for that proven live, not '
    'just claimed. DsCollapsible declares no variant or size enum of its '
    'own, either: the trigger and the content are entirely caller-supplied '
    'widgets (see API Reference), so visual variety belongs to composition, '
    'not to parameters on this component.';

const ComponentDocEntry collapsibleDoc = ComponentDocEntry(
  name: 'collapsible',
  title: 'Collapsible',
  description:
      'A single independent disclosure: one trigger, one panel: that '
      'expands and collapses on its own, without coordinating with anything '
      'else on the page.',
  dependencies: <String>['source-foundation'],
  exports: <String>['DsCollapsible', 'DsUnfold'],
  sourcePath: 'lib/src/components/collapsible.dart',
);
