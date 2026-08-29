/// Documentation metadata for the `progress` component.
///
/// **Split.** This route used to carry both `Progress` and `Skeleton`
/// under one [ComponentDocEntry] (see the git history of this file for that
/// shape). `Skeleton` now has its own route and its own entry:
/// `example/lib/components_docs/skeleton/meta.dart`'s `skeletonDoc`. [name],
/// [route] (`/components/progress`), and the page class (`ProgressDocPage`)
/// are unchanged, so `catalog.dart`'s `progress.progressDoc` reference and
/// `main.dart`'s route table needed no edit for this half of the split.
///
/// Not wired into `catalog.dart`'s `componentDocs` list beyond the entry it
/// already carries: that file is supervisor-owned. `page.dart` reads
/// [progressDoc] directly rather than going through `componentDoc('progress')`.
///
/// `progress` has a real `registry/components/progress.json` manifest --
/// [dependencies] is that manifest's own `registryDependencies` list,
/// verbatim, so `page.dart`'s installation section can render the real
/// `elattar add progress` command.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry progressDoc = ComponentDocEntry(
  name: 'progress',
  title: 'Progress',
  description:
      'A determinate progress channel: a 10px sunken bar with five tones, '
      'for the moment you can compute a fraction done.',
  dependencies: <String>['surface', 'source-foundation'],
  exports: <String>['Progress', 'ProgressTone'],
  sourcePath: 'lib/src/components/ui/progress.dart',
);
