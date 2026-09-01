/// Public documentation metadata for the `press` motion primitive.
///
/// `press` is registry `type: "motion"` — `registry/components/press.json`,
/// not `registry/components/` — and [dependencies] is that manifest's own
/// `registryDependencies` list, copied verbatim: `source-foundation`. The
/// The file `lib/src/components/ui/press.dart` exports [Press] — the seam every
/// clickable surface that is not a `Button` goes through — and [TapTarget],
/// which expands a control's hit box to a fingertip without touching layout.
/// With `onTap`, `Press` is a complete control: Tab-reachable, activated by
/// Enter and Space, ringed on keyboard focus, named to a screen reader, and at
/// least 44 x 44 to a pointer. Without one it is what it always was, a
/// decoration carrying the CSS `press` utility's click feel.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry pressDoc = ComponentDocEntry(
  name: 'press',
  title: 'Press Motion',
  description:
      'The shared activation contract for anything clickable that is not a '
      'Button: Tab and Enter and Space, a focus ring on keyboard focus only, '
      'button or link semantics, a 44px minimum target, and the press squish. '
      'Inert without onTap.',
  // registry/components/press.json's own registryDependencies, verbatim.
  dependencies: <String>['source-foundation'],
  exports: <String>['Press', 'TapTarget'],
  sourcePath: 'lib/src/components/ui/press.dart',
);
