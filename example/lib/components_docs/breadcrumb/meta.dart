/// Public documentation metadata for the breadcrumb component.
///
/// `breadcrumb` has **no** `registry/components/breadcrumb.json` manifest
/// yet, so [ComponentDocEntry.command] (`elattar add breadcrumb`, derived
/// from [ComponentDocEntry.name]) would fail against the real registry
/// client: there is nothing on the server for it to resolve. `page.dart`
/// never renders that formula as a working install path; see its
/// Installation section for the honest manual-only story.
library;

import '../catalog.dart';

const ComponentDocEntry breadcrumbDoc = ComponentDocEntry(
  name: 'breadcrumb',
  title: 'Breadcrumb',
  description:
      "A wrapping trail of links back to a page's ancestors, ending in the "
      'current, non-clickable page.',
  // The component's real transitive dependencies: the foundation modules
  // (motion, spacing, theme, typography) `source-foundation` already
  // stands for across every other entry, plus `icon` for the chevron
  // separator. Neither name is invented: `icon` is a published registry
  // item (`registry/components/icon.json`). What does not exist is a
  // `breadcrumb.json` wiring the two together: see the library doc above.
  dependencies: <String>['icon', 'source-foundation'],
  exports: <String>['ElBreadcrumb', 'ElBreadcrumbEntry'],
  sourcePath: 'lib/src/components/breadcrumb.dart',
);
