/// Documentation metadata for the alert component.
///
/// `alert` has no `registry/components/*.json` manifest yet (unlike its
/// sibling `alert-dialog`, which does) — see
/// `docs/superpowers/plans/2026-08-23-phase-j-full-component-documentation.md`.
/// [alertDoc.dependencies] is therefore left empty rather than naming
/// registry items that do not exist; the page's own install section states
/// the CLI gap in prose instead.
library;

import '../catalog.dart';

/// [ComponentDocEntry.description] is the one-sentence form for nav and
/// search. The page's own "Purpose" section carries the expanded,
/// decision-guidance description IA §9.2 also asks for.
const ComponentDocEntry alertDoc = ComponentDocEntry(
  name: 'alert',
  title: 'Alert',
  description:
      'A persistent inline message that shares one bordered card surface '
      'across five variants, told apart only by icon color and bloom.',
  dependencies: <String>[],
  exports: <String>['DsAlert', 'DsAlertVariant'],
  sourcePath: 'lib/src/components/alert.dart',
);
