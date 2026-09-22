/// Public documentation metadata for the `hover-builder` component.
///
/// `hover-builder` is registry `type: "component"`, declared by
/// `registry/components/hover-builder.json` — and [dependencies] is that
/// manifest's own
/// `registryDependencies` list, copied verbatim: `source-foundation`. The
/// file exports one class, [HoverBuilder], the bare hover reporter a caller
/// composes with Press and its own AnimatedContainer for a card appearance.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry hoverBuilderDoc = ComponentDocEntry(
  name: 'hover_builder',
  title: 'Hover Builder',
  description:
      'A hover rise — translateY(-3px) onto a deeper shadow, with an '
      'optional border-colour swap — for a card or tile that answers the '
      'pointer the way the whole docs site\'s own cards do.',
  // registry/components/hover-builder.json's own registryDependencies, verbatim.
  dependencies: <String>['source-foundation'],
  exports: <String>['HoverBuilder'],
  sourcePath: 'lib/src/components/ui/hover_builder.dart',
);
