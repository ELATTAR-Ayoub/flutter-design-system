/// Documentation metadata for the `skeleton` component.
///
/// **New route, split out of `progress`.** `Skeleton` used to share
/// `/components/progress` with `Progress` under one shared
/// `ComponentDocEntry` (see `progress/meta.dart`'s own note for the split).
/// It now has its own [name], its own route (`/components/skeleton`), and
/// its own page class (`SkeletonDocPage`).
///
/// Not wired into `catalog.dart`'s `componentDocs` list: that file is
/// supervisor-owned, and this entry is new. `page.dart` reads [skeletonDoc]
/// directly rather than going through `componentDoc('skeleton')`.
///
/// `registry/components/skeleton.json` ships today: [dependencies] is that
/// manifest's own `registryDependencies` list, verbatim, so `page.dart`'s
/// Installation section can render the real `elattar add skeleton` command.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry skeletonDoc = ComponentDocEntry(
  name: 'skeleton',
  title: 'Skeleton',
  description:
      'A shimmering placeholder box, sized like the content that has not '
      'arrived yet, so the layout never jumps when it does.',
  dependencies: <String>['keyframes', 'source-foundation'],
  exports: <String>['Skeleton'],
  sourcePath: 'lib/src/components/ui/skeleton.dart',
);
