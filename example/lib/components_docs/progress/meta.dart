/// Documentation metadata for the paired `progress` / `skeleton` components.
///
/// Not wired into `catalog.dart`'s `componentDocs` list — that file is
/// supervisor-owned. `page.dart` reads [progressDoc] directly rather than
/// going through `componentDoc('progress')`, so this entry stands on its own
/// until the supervisor aggregates it.
///
/// **Why one entry covers two components.** `DsProgress` and `DsSkeleton`
/// both answer "something is happening" — the one interesting fact about
/// them is which one to reach for, not two isolated API surfaces — so this
/// wave assigns them a single documentation slot rather than two. [route]
/// resolves to `/components/progress`; there is no separate
/// `/components/skeleton` route from this page. [exports] therefore lists
/// symbols from *both* source files, and [sourcePath] — a single-string
/// field on [ComponentDocEntry] — names the first of the two;
/// [skeletonSourcePath] below names the second so the page (and a reader of
/// this file) has both without inventing a second entry type.
library;

import '../catalog.dart' show ComponentDocEntry;

/// Neither `registry/components/progress.json` nor
/// `registry/components/skeleton.json` exists yet — see `page.dart`'s
/// installation section for the honest disclosure. [dependencies] is left
/// empty rather than naming items a manifest does not yet resolve.
const ComponentDocEntry progressDoc = ComponentDocEntry(
  name: 'progress',
  title: 'Progress & Skeleton',
  description:
      'Two ways to show something is happening: a determinate progress '
      'channel when you know the fraction done, a shimmering skeleton when '
      'you know the shape of what is coming.',
  dependencies: <String>[],
  exports: <String>['DsProgress', 'DsProgressTone', 'DsSkeleton'],
  sourcePath: 'lib/src/components/progress.dart',
);

/// [DsSkeleton]'s own file — see the library note on why this is not a
/// second [ComponentDocEntry].
const String skeletonSourcePath = 'lib/src/components/skeleton.dart';

/// The expanded, decision-guiding description IA §9.2 requires: not what
/// each widget is, but which one a caller should reach for and why. Named
/// rather than inlined so `page.dart`'s Overview section and any future
/// search/summary surface read the same sentence.
const String progressSkeletonDecisionGuide =
    'Reach for DsProgress the moment you can compute a fraction — a file '
    'upload, a multi-step wizard, a sync job reporting bytes done over '
    'bytes total. Its Semantics node always announces the percentage, so a '
    'screen reader hears the number even when nothing else on screen '
    'moves. Reach for DsSpinner instead (documented on its own page) when '
    'you cannot compute a fraction and the wait is short — a submit '
    'button, a small inline fetch — where a moving indicator is enough and '
    'a channel with no real value to show would be misleading. Reach for '
    'DsSkeleton when you already know the SHAPE of what is arriving — a '
    'card, an avatar plus two lines, a table row — and want the layout to '
    'hold still the instant real content replaces it. A generic grey '
    'rectangle where a specific shape belongs causes a layout jump, which '
    'reads as more broken than either a progress bar or a spinner would.';
