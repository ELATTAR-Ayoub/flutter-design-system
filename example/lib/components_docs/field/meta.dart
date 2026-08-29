/// Public documentation metadata for the `field` component.
///
/// `field` already has a real `registry/components/field.json` manifest —
/// [dependencies] is that manifest's own `registryDependencies`, copied
/// verbatim (`['source-foundation', 'rule']`), not a guess at
/// `field.dart`'s internal imports. This is the same shape `tooltip`'s
/// `meta.dart` uses for the same reason: a worker that invented a dependency
/// name here would fail registry validation loudly, and this one does not
/// need to.
///
/// [ComponentDocEntry.description] is the page's only rendered description:
/// the one-sentence form for nav, search, and the page's own hero line.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry fieldDoc = ComponentDocEntry(
  name: 'field',
  title: 'Field',
  description:
      'The label, description, and error wrapper every input, select, and '
      'selection control composes inside.',
  // registry/components/field.json's own registryDependencies, verbatim.
  dependencies: <String>['validation-rule', 'source-foundation'],
  exports: <String>[
    'Field',
    'FieldScope',
    'FieldActivator',
    'FieldOrientation',
    'FieldGroup',
    'FieldSet',
    'FieldLegend',
    'FieldLabel',
    'FieldDescription',
    'FieldError',
  ],
  sourcePath: 'lib/src/components/ui/field.dart',
);
