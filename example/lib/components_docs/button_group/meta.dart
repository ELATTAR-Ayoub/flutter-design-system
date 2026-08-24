/// Public documentation metadata for the `button_group` component.
///
/// Split off Phase F/J's merged `input_group` page, which documented three
/// unrelated components (`ElInputGroup`, `ElButtonGroup`, `ElInputOtp`) on
/// one route. This entry covers `ElButtonGroup` and its text/separator
/// members only: see `../input_group/meta.dart` and `../input_otp/meta.dart`
/// for the other two, each its own route and its own `<name>Doc` const.
///
/// `button_group` installs through `elattar add button-group`: see `page.dart`'s
/// installation section for the shipped command and registry dependencies. [dependencies] is left
/// empty rather than naming items a manifest does not yet resolve.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry buttonGroupDoc = ComponentDocEntry(
  name: 'button_group',
  title: 'Button group',
  description:
      'ElButtonGroup renders a segmented control: buttons joined at their '
      'edges with one hairline between each pair and squared interior '
      'corners, used for view switching, quantity steppers, and split '
      'actions.',
  dependencies: <String>['button', 'source-foundation'],
  exports: <String>[
    'ElButtonGroup',
    'ElButtonGroupText',
    'ElButtonGroupSeparator',
  ],
  sourcePath: 'lib/src/components/button_group.dart',
);
