/// Documentation metadata for the accordion component.
///
/// A worker-owned file: the supervisor folds [accordionDoc] into
/// `catalog.dart`'s `componentDocs` list in a later, serialized pass. This
/// file only ever imports `catalog.dart` for the [ComponentDocEntry] shape —
/// it never edits it.
///
/// [ComponentDocEntry.description] is the one-sentence form for nav and
/// search. [accordionExpandedDescription] is the longer "accordion versus
/// its two neighbours" guidance, rendered as its own unlabelled paragraph
/// directly under the hero in `page.dart`: deliberately not wrapped in its
/// own `DsSection`/anchor, so the shadcn-mirrored section order starts clean
/// at Preview, the same shape `button`'s `buttonExpandedDescription` uses.
library;

import '../catalog.dart';

/// What an accordion is *for*, argued against its two real neighbours
/// rather than restated as a definition.
const String accordionExpandedDescription =
    'A set of related disclosures where opening one panel closes whichever '
    'other panel was open: an FAQ list is the canonical case, where only one '
    'panel should stay open at a time. Reach for Collapsible instead for one '
    'independent disclosure with nothing else to coordinate with, like a '
    'lone advanced-filters panel: it is built on the same DsUnfold '
    'animation, so open/close pacing matches exactly. Reach for Tabs when '
    'the choices are peers behind persistent, always-visible triggers, '
    'replacing the visible content outright, rather than reading '
    'top-to-bottom with one section expanded at a time.';

/// `accordion` has no `registry/components/accordion.json` yet, so
/// [dependencies] names the real modules the source imports (for the
/// dependencies panel) rather than a validated `registryDependencies` list.
/// `page.dart`'s installation section says plainly that the component is
/// already usable through the published package: it is exported from the
/// barrel: but not yet through `elattar add accordion`.
const ComponentDocEntry accordionDoc = ComponentDocEntry(
  name: 'accordion',
  title: 'Accordion',
  description:
      'A vertical stack of disclosures where opening one panel closes '
      'whichever other panel was open.',
  dependencies: <String>[
    'source-foundation',
    'machine-surface',
    'button',
    'icon',
    'collapsible',
  ],
  exports: <String>['DsAccordion', 'DsAccordionItem'],
  sourcePath: 'lib/src/components/accordion.dart',
);
