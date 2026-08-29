/// Public documentation metadata for the `select` component.
///
/// `select` has a real `registry/components/select.json` manifest:
/// [dependencies] below is that manifest's own `registryDependencies` list,
/// copied verbatim: `button`, `field`, `icon`, `surface`,
/// `popover`, `source-foundation`. `page.dart` renders the real
/// `elattar add select` command from it rather than a "not available yet"
/// disclosure.
///
/// **Re-housed, not re-invented.** This page used to be `SelectDocPage` in
/// `example/lib/components_docs/input_select_pages.dart`, hand-composed
/// with `Section` rather than declared as a `ComponentDocSpec`. It has
/// moved into its own directory, onto the kit `button` and `field` already
/// use; every specimen and every code string that page carried moved with
/// it unchanged. See `page.dart`'s own library doc for what the re-housing
/// added.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry selectDoc = ComponentDocEntry(
  name: 'select',
  title: 'Select',
  description:
      'Typed selection with sizes, groups, separators, disabled options, '
      'and keyboard navigation.',
  // registry/components/select.json's own registryDependencies, verbatim.
  dependencies: <String>[
    'button',
    'field',
    'icon',
    'surface',
    'popover',
    'source-foundation',
  ],
  exports: <String>[
    'Select',
    'SelectSize',
    'SelectOption',
    'SelectGroup',
    'SelectSeparator',
    'SelectMenu',
  ],
  sourcePath: 'lib/src/components/ui/select.dart',
);
