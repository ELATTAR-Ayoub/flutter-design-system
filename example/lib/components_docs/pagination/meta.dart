/// Public documentation metadata for the `pagination` component.
///
/// [ComponentDocEntry] itself is defined in `catalog.dart`, which this file
/// only imports: the catalog's aggregate `componentDocs` list is
/// supervisor-owned and does not carry this entry yet, so `page.dart` reads
/// [paginationDoc] directly rather than looking it up through `componentDoc`.
///
/// **Corrected.** This note used to say `registry/components/pagination.json`
/// did not exist and that [dependencies] was therefore left empty. Both were
/// stale, and both were false in the same breath — the list below has never
/// been empty. The manifest is real, `elattar add pagination` is a working
/// command, and [dependencies] matches its `registryDependencies` verbatim.
/// `page.dart`'s installation section says so honestly instead of rendering
/// an `elattar add pagination` command that would fail.
library;

import '../catalog.dart';

const ComponentDocEntry paginationDoc = ComponentDocEntry(
  name: 'pagination',
  title: 'Pagination',
  description:
      'A centred row of page links, built entirely out of ElButton: no '
      'page-count model, no truncation logic of its own.',
  dependencies: <String>['button', 'icon', 'source-foundation'],
  exports: <String>[
    'ElPagination',
    'ElPaginationLink',
    'ElPaginationStep',
    'ElPaginationEllipsis',
  ],
  sourcePath: 'lib/src/components/pagination.dart',
);
