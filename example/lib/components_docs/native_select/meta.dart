/// Public documentation metadata for the `native_select`, `selection_control`,
/// and `form` components.
///
/// This page documents three form components in one article:
/// - **native_select**: The operating system's own picker, as far as Flutter
///   can carry it. Closed control is 1:1 with the reference; the open list
///   diverges to a port-built DsSelectMenu.
/// - **selection_control**: The shared socket and hit-area primitive that
///   DsCheckbox, DsRadioGroup, and DsSwitch all build on.
/// - **form**: The non-visual form state container: fields, validation rules,
///   submission policy, and focus-on-error logic, but zero layout.
///
/// None of the three has a registry manifest yet, so installation is marked
/// N/A rather than showing an "elattar add" command.
library;

import '../catalog.dart' show ComponentDocEntry;

/// Expanded description for native_select, selection_control, and form —
/// the three form primitives documented on this page.
const String nativeSelectExpandedDescription =
    'DsNativeSelect is the select you reach for when you need the platform\'s '
    'own picker, as far as Flutter can carry it: the closed control is 1:1 '
    'with the reference, but the open list is a port-built DsSelectMenu '
    'instead of the OS picker, because Flutter has no OS `<select>` widget. '
    'Contrast it with DsSelect, which is a Radix menu component with full '
    'custom styling. DsSelectionControl is the invisible shared primitive, '
    'the socket, focus ring, hit area expander, and jelly squash: that '
    'DsCheckbox, DsRadioGroup, and DsSwitch all inherit; document it to '
    'explain what they have in common. DsForm is not a layout wrapper and not '
    'a visual component at all: it is the non-visual form state container: '
    'fields in registration order, validation rules, submission policy, and '
    'focus-on-error logic. Bind it with ListenableBuilder and read field '
    'state on every rebuild.';

const ComponentDocEntry nativeSelectDoc = ComponentDocEntry(
  name: 'native_select',
  title: 'Native Select, Selection Control, Form',
  description:
      'The OS select, the shared socket primitive, and the form '
      'state container: three form layers on one page.',
  // No registry manifest yet, N/A in Installation.
  dependencies: <String>[],
  exports: <String>[
    'DsNativeSelect',
    'DsNativeSelectSize',
    'DsSelectionControl',
    'DsHitArea',
    'DsJellyReplay',
    'DsValidateMode',
    'DsFormFieldBase',
    'DsFormField',
    'DsTextFormField',
    'DsForm',
  ],
  sourcePath:
      'lib/src/components/native_select.dart, '
      'lib/src/components/selection_control.dart, '
      'lib/src/components/form.dart',
);
