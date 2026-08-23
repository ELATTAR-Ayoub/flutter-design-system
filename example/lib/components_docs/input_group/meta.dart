/// Documentation metadata for the `input_group` component family.
///
/// Not wired into `catalog.dart`'s `componentDocs` list — that file is
/// supervisor-owned. `page.dart` reads [inputGroupDoc] directly rather than
/// going through `componentDoc('input_group')`, so this entry stands on its
/// own until the supervisor aggregates it.
library;

import '../catalog.dart' show ComponentDocEntry;

/// `input_group` has no registry manifest yet — see `page.dart`'s
/// installation section for the honest disclosure. [dependencies] is left
/// empty rather than naming items a manifest does not yet resolve.
const ComponentDocEntry inputGroupDoc = ComponentDocEntry(
  name: 'input_group',
  title: 'Input group',
  description:
      'A pill-shaped container for input controls with optional leading and trailing addons — text, icons, or buttons.',
  dependencies: <String>[],
  exports: <String>[
    'DsInputGroup',
    'DsInputGroupInput',
    'DsInputGroupAddon',
    'DsInputGroupText',
    'DsInputGroupButton',
    'DsInputGroupAlign',
    'DsInputGroupButtonSize',
  ],
  sourcePath: 'lib/src/components/input_group.dart',
);
