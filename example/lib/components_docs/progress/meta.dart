/// Documentation metadata for the `progress` component.
///
/// **Split.** This route used to carry both `ElProgress` and `ElSkeleton`
/// under one [ComponentDocEntry] (see the git history of this file for that
/// shape). `ElSkeleton` now has its own route and its own entry:
/// `example/lib/components_docs/skeleton/meta.dart`'s `skeletonDoc`. [name],
/// [route] (`/components/progress`), and the page class (`ProgressDocPage`)
/// are unchanged, so `catalog.dart`'s `progress.progressDoc` reference and
/// `main.dart`'s route table needed no edit for this half of the split.
///
/// Not wired into `catalog.dart`'s `componentDocs` list beyond the entry it
/// already carries: that file is supervisor-owned. `page.dart` reads
/// [progressDoc] directly rather than going through `componentDoc('progress')`.
///
/// `registry/components/progress.json` does not exist yet: see `page.dart`'s
/// installation section for the shipped command and registry dependencies. [dependencies] is left
/// empty rather than naming items a manifest does not yet resolve.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry progressDoc = ComponentDocEntry(
  name: 'progress',
  title: 'Progress',
  description:
      'A determinate progress channel: a 10px sunken bar with five tones, '
      'for the moment you can compute a fraction done.',
  dependencies: <String>['machine-surface', 'source-foundation'],
  exports: <String>['ElProgress', 'ElProgressTone'],
  sourcePath: 'lib/src/components/progress.dart',
);
