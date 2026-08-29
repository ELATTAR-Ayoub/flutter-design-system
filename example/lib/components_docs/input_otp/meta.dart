/// Public documentation metadata for the `input_otp` component.
///
/// Split off Phase F/J's merged `input_group` page, which documented three
/// unrelated components (`InputGroup`, `ButtonGroup`, `InputOtp`) on
/// one route. This entry covers `InputOtp` and its slot/separator parts
/// only: see `../input_group/meta.dart` and `../button_group/meta.dart` for
/// the other two, each its own route and its own `<name>Doc` const.
///
/// **Corrected.** This note used to end "[dependencies] is left empty rather
/// than naming items a manifest does not yet resolve" — false twice over.
/// `registry/components/input-otp.json` is real and resolves seven items,
/// and the list below has always carried all seven, verbatim. `elattar add
/// input-otp` is a working command.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry inputOtpDoc = ComponentDocEntry(
  name: 'input_otp',
  title: 'Input OTP',
  description:
      'InputOtp is a six-digit verification field: six painted boxes '
      'over one hidden input, advancing focus and retreating on backspace. '
      'A native Flutter reimplementation of the input-otp JavaScript '
      'package\'s mechanism, not a port of the package itself.',
  dependencies: <String>[
    'button',
    'field',
    'icon',
    'input',
    'keyframes',
    'surface',
    'source-foundation',
  ],
  exports: <String>['InputOtp', 'InputOtpSlot', 'InputOtpSeparator'],
  sourcePath: 'lib/src/components/ui/input_otp.dart',
);
