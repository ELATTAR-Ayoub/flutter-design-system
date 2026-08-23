/// Public documentation metadata for the tooltip component.
///
/// Unlike most of its Wave 1 siblings, `tooltip` already has a real
/// `registry/components/tooltip.json` manifest. [dependencies] is therefore
/// the manifest's own `registryDependencies` list, verbatim —
/// `['source-foundation']`: not a guess at the source's internal imports,
/// so `page.dart`'s installation section can render the real
/// `elattar add tooltip` command instead of the "not available yet"
/// disclosure most Wave 1 pages carry today.
///
/// [ComponentDocEntry.description] is the one-sentence form for nav and
/// search. [tooltipExpandedDescription] carries the IA §9.2 "when to use
/// this instead of a neighbour" guidance, kept as a second top-level
/// constant: the same shape `switch`'s `switchExpandedDescription` uses —
/// because [ComponentDocEntry] itself carries only one description field and
/// is supervisor-owned.
library;

import '../catalog.dart';

/// IA §9.2's expanded description: tooltip against its two overlay
/// neighbours, not a restatement of what a tooltip is.
const String tooltipExpandedDescription =
    'Reach for a tooltip when the content is a single short line of text '
    'and nothing else: a name for an icon-only control, a brief clarifying '
    'aside. It is not a place for interactive content: reach for Popover '
    'instead when the content has its own buttons, links, or form fields, '
    'and reach for Hover Card when the content is a richer, still '
    'non-interactive preview that needs more room than one line (a user '
    'card, a link preview). A tooltip opens on a 200ms pointer hover or an '
    'immediate touch tap, and closes when the pointer leaves, a second tap '
    'lands, or a tap elsewhere is registered: never on a click, and never '
    'by staying open indefinitely.';

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
  exports: <String>['DsTooltip', 'DsTooltipSide', 'DsTooltipContent'],
  sourcePath: 'lib/src/components/tooltip.dart',
);
