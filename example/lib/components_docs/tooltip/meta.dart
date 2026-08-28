/// Public documentation metadata for the tooltip component.
///
/// Unlike most of its Wave 1 siblings, `tooltip` already has a real
/// `registry/components/tooltip.json` manifest. [dependencies] is therefore
/// the manifest's own `registryDependencies` list, verbatim —
/// `['source-foundation']`: not a guess at the source's internal imports,
/// so `page.dart`'s installation section can render the real
/// `elattar add tooltip` command plus shipped registry dependencies.
/// disclosure most Wave 1 pages carry today.
///
/// [ComponentDocEntry.description] is the page's only rendered description:
/// the one-sentence form for nav, search, and the page's own hero line.
library;

import '../catalog.dart';

const ComponentDocEntry tooltipDoc = ComponentDocEntry(
  name: 'tooltip',
  title: 'Tooltip',
  description:
      'A short, non-interactive label that opens on pointer hover or a '
      'touch tap for a control whose purpose is not obvious on its own.',
  // registry/components/tooltip.json's own registryDependencies, verbatim —
  // a worker that invented a name here is exactly the failure mode the
  // Phase J supervisor notes warn about, and this one does not need to.
  dependencies: <String>['source-foundation'],
  exports: <String>['Tooltip', 'TooltipSide', 'TooltipContent'],
  sourcePath: 'lib/src/components/tooltip.dart',
);
