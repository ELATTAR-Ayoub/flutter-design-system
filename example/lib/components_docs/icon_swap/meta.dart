/// Public documentation metadata for the `icon-swap` effect.
///
/// `icon-swap` HAS a real `registry/components/icon-swap.json` manifest —
/// registry `type: "component"`, unlike its three siblings on this same
/// rollout (`sliding-pill`, `swap-in`, `lift`, all `type: "motion"`) — but it
/// carries no variant enum and is never placed on its own: every real call
/// site (`lib/src/components/attachment.dart`, `lib/src/components/
/// sidebar.dart`) puts it inside an `ElButton`'s `child:` slot. [dependencies]
/// is that manifest's own `registryDependencies` list, copied verbatim:
/// `keyframes`, `source-foundation`.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry iconSwapDoc = ComponentDocEntry(
  name: 'icon_swap',
  title: 'Icon Swap',
  description:
      'A fixed clip window that rolls one glyph out through the top and the '
      'next in from below, with a squash on arrival: the standard way a '
      'two-state icon control shows you it changed, never a crossfade or an '
      'instant swap.',
  // registry/components/icon-swap.json's own registryDependencies, verbatim.
  dependencies: <String>['keyframes', 'source-foundation'],
  exports: <String>['ElIconSwap'],
  sourcePath: 'lib/src/components/icon_swap.dart',
);
