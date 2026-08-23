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
library;

import '../catalog.dart';

const ComponentDocEntry collapsibleDoc = ComponentDocEntry(
  name: 'collapsible',
  title: 'Collapsible',
  description:
      'A single independent disclosure — one trigger, one panel — that '
      'expands and collapses on its own, without coordinating with anything '
      'else on the page.',
  dependencies: <String>['source-foundation'],
  exports: <String>['DsCollapsible', 'DsUnfold'],
  sourcePath: 'lib/src/components/collapsible.dart',
);
