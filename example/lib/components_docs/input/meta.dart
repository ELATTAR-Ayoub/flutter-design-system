/// Public documentation metadata for the `input` component.
///
/// `input` has a real `registry/components/input.json` manifest:
/// [dependencies] below is that manifest's own `registryDependencies` list,
/// copied verbatim: `button`, `field`, `surface`, `source-foundation`.
/// `page.dart` renders the real `elattar add input` command from it rather
/// than a "not available yet" disclosure.
///
/// **Re-housed, not re-invented.** This page used to be `InputDocPage` in
/// `example/lib/components_docs/input_select_pages.dart`, hand-composed with
/// `Section` rather than declared as a `ComponentDocSpec`. It has moved
/// into its own directory, onto the kit `button` and `field` already use;
/// every specimen and every code string that page carried moved with it
/// unchanged. See `page.dart`'s own library doc for what the re-housing
/// added.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry inputDoc = ComponentDocEntry(
  name: 'input',
  title: 'Input',
  description:
      'Accessible text entry with focus, invalid, disabled, read-only, and '
      'grouped states.',
  // registry/components/input.json's own registryDependencies, verbatim.
  dependencies: <String>['button', 'field', 'surface', 'source-foundation'],
  exports: <String>['Input', 'FieldSurfaceRecipe', 'FieldVisibility'],
  sourcePath: 'lib/src/components/ui/input.dart',
);
