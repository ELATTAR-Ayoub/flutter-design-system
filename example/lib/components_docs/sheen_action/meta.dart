/// Public documentation metadata for the `sheen-action` effect.
///
/// `sheen-action` HAS a real `registry/effects/sheen-action.json` manifest:
/// [dependencies] below is that manifest's own `registryDependencies` list,
/// copied verbatim: `machine-surface`, `source-foundation` —
/// `machine-surface` because [ElSheenAction] splices its own ramp and its
/// two blended pseudo-layers around an inner [ElMachineSurface], which is
/// what actually paints the inset shadows, the border and the label.
/// `page.dart` renders the real `elattar add sheen-action` command from it.
///
/// Not a component: `lib/src/effects/sheen_action.dart` exports one
/// `StatefulWidget`, [ElSheenAction], with no variant and no size — it is
/// the surface this system's own primary Button paints itself with,
/// documented here as the effect it is: a static five-stop ramp, a static
/// blended texture, and a double-thump "beat" that plays on hover and
/// retimes — without restarting — on press.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry sheenActionDoc = ComponentDocEntry(
  name: 'sheen_action',
  title: 'Sheen Action',
  description:
      'The default Button\'s surface: a derived five-stop ramp, a static '
      'blended texture, and a double-thump light that beats on hover and '
      'retimes — without restarting — the instant the surface is pressed.',
  // registry/effects/sheen-action.json's own registryDependencies, verbatim.
  dependencies: <String>['machine-surface', 'source-foundation'],
  exports: <String>['ElSheenAction'],
  sourcePath: 'lib/src/effects/sheen_action.dart',
);
