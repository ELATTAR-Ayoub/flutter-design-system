/// Public documentation metadata for the breadcrumb component.
///
/// **Corrected.** This file used to claim `breadcrumb` had no
/// `registry/components/breadcrumb.json` manifest and that
/// [ComponentDocEntry.command] would fail against the real registry client.
/// That is stale: `registry/components/breadcrumb.json` is a real, shipped
/// manifest today, `registry/generated/latest/registry.json` carries
/// `breadcrumb`, and `elattar add breadcrumb` is a genuine, working
/// command. [dependencies] below already matches the manifest's own
/// `registryDependencies` list, verbatim: `icon` (for the chevron
/// separator) and `source-foundation`.
library;

import '../catalog.dart';

const ComponentDocEntry breadcrumbDoc = ComponentDocEntry(
  name: 'breadcrumb',
  title: 'Breadcrumb',
  description:
      "A wrapping trail of links back to a page's ancestors, ending in the "
      'current, non-clickable page.',
  // registry/components/breadcrumb.json's own registryDependencies,
  // verbatim: `icon` is a published registry item
  // (`registry/components/icon.json`) for the chevron separator, plus the
  // foundation every other entry names.
  dependencies: <String>['icon', 'source-foundation'],
  exports: <String>['ElBreadcrumb', 'ElBreadcrumbEntry'],
  sourcePath: 'lib/src/components/breadcrumb.dart',
);
