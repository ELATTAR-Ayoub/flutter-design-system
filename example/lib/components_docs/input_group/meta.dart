/// Public documentation metadata for the `input_group` component.
///
/// Split off Phase F/J's merged `input_group` page, which documented three
/// unrelated components (`InputGroup`, `ButtonGroup`, `InputOtp`) on
/// one route. This entry now covers `InputGroup` and its addon/button/text
/// family only: see `../button_group/meta.dart` and `../input_otp/meta.dart`
/// for the other two, each its own route and its own `<name>Doc` const.
///
/// `input_group` installs through `elattar add input-group`: see `page.dart`'s
/// installation section for the shipped command and registry dependencies. [dependencies] is left
/// empty rather than naming items a manifest does not yet resolve.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry inputGroupDoc = ComponentDocEntry(
  name: 'input_group',
  title: 'Input group',
  description:
      'InputGroup wraps a form control in a 40px pill-shaped container '
      'with optional leading and trailing addons: text, icons, or buttons, '
      'used for search prefixes, password visibility toggles, or unit '
      'indicators.',
  dependencies: <String>[
    'button',
    'field',
    'input',
    'surface',
    'press',
    'source-foundation',
  ],
  exports: <String>[
    'InputGroup',
    'InputGroupInput',
    'InputGroupAddon',
    'InputGroupText',
    'InputGroupButton',
    'InputGroupAlign',
    'InputGroupButtonSize',
  ],
  sourcePath: 'lib/src/components/input_group.dart',
);
