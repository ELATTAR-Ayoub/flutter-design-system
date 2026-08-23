/// Public documentation metadata for the `pagination` component.
///
/// [ComponentDocEntry] itself is defined in `catalog.dart`, which this file
/// only imports: the catalog's aggregate `componentDocs` list is
/// supervisor-owned and does not carry this entry yet, so `page.dart` reads
/// [paginationDoc] directly rather than looking it up through `componentDoc`.
///
/// `pagination` has no `registry/components/pagination.json` yet, [dependencies]
/// is left empty rather than naming items a manifest does not yet resolve.
/// `page.dart`'s installation section says so honestly instead of rendering
/// an `elattar add pagination` command that would fail.
library;

import '../catalog.dart';

/// IA §9.2's *expanded* description: not what pagination is, but when to
/// reach for it instead of its two closest neighbours for "more content
/// exists past what's on screen": a load-more button and infinite scroll.
/// Kept as a second top-level constant, beside [paginationDoc], because
/// [ComponentDocEntry] carries only one description field: the same shape
/// `switchExpandedDescription` and `popoverExpandedDescription` already use.
const String paginationExpandedDescription =
    'Reach for pagination when the list is bounded and addressable: a grid '
    'or table with a known total page count, where jumping straight to page '
    '12 is a real, useful action a user might actually want. The source '
    'file\'s own framing is exact: "the marketplace and the Stash both '
    'paginate." Reach for a load-more button instead when the list grows '
    'from the top and a fixed page number would not mean anything stable, '
    'this system\'s own live feed uses a plain DsButton labelled "Load 25 '
    'more…" next to a "48 of 12,480 shown" counter, not a bespoke '
    'component, because load-more is "repeat the same action," not a set of '
    'numbered destinations. There is no dedicated infinite-scroll primitive '
    'in this package at all: an auto-loading-on-scroll list is the '
    'load-more pattern with the button removed and a ScrollController '
    'listener added at the call site; nothing here or in the load-more '
    'convention builds that listener for you. Either way, pair pagination '
    'with a "Showing 25–48 of 184" range label at the call site: '
    'DsPagination renders the page links only and has no count or total of '
    'its own.';

const ComponentDocEntry paginationDoc = ComponentDocEntry(
  name: 'pagination',
  title: 'Pagination',
  description:
      'A centred row of page links, built entirely out of DsButton: no '
      'page-count model, no truncation logic of its own.',
  dependencies: <String>[],
  exports: <String>[
    'DsPagination',
    'DsPaginationLink',
    'DsPaginationStep',
    'DsPaginationEllipsis',
  ],
  sourcePath: 'lib/src/components/pagination.dart',
);
