/// Public documentation metadata for the `native_select` component.
///
/// This page documents exactly one component: [NativeSelect] and its
/// [NativeSelectSize] rungs — the operating system's own picker, as far as
/// Flutter can carry it. `selection_control` (the shared socket primitive
/// Checkbox/RadioGroup/Switch build on) and `form` (the non-visual
/// form state container) used to be documented on this same page; they now
/// have their own pages at `../selection_control/` and `../form/`, one
/// component per page.
///
/// Install with `elattar add native-select`; the CLI resolves the declared
/// dependency closure.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry nativeSelectDoc = ComponentDocEntry(
  name: 'native_select',
  title: 'Native Select',
  description:
      'The operating system\'s own picker, as far as Flutter can carry it: '
      'a 1:1 closed control over a port-built open list.',
  // Registry dependencies are resolved by `elattar add native-select`.
  dependencies: <String>[
    'button',
    'field',
    'icon',
    'surface',
    'popover',
    'select',
    'source-foundation',
  ],
  exports: <String>['NativeSelect', 'NativeSelectSize'],
  sourcePath: 'lib/src/components/ui/native_select.dart',
);
