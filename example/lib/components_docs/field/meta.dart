/// Public documentation metadata for the `field` component.
///
/// `field` already has a real `registry/components/field.json` manifest —
/// [dependencies] is that manifest's own `registryDependencies`, copied
/// verbatim (`['source-foundation', 'ds-rule']`), not a guess at
/// `field.dart`'s internal imports. This is the same shape `tooltip`'s
/// `meta.dart` uses for the same reason: a worker that invented a dependency
/// name here would fail registry validation loudly, and this one does not
/// need to.
///
/// [ComponentDocEntry.description] is the one-sentence form for nav and
/// search. [fieldExpandedDescription] carries the IA §9.2 "when to use this
/// instead of a neighbour" guidance as a second top-level constant — the same
/// shape `tooltipExpandedDescription` and `switchExpandedDescription` use —
/// because [ComponentDocEntry] itself carries only one description field and
/// is supervisor-owned.
library;

import '../catalog.dart' show ComponentDocEntry;

/// IA §9.2's expanded description: field against the controls it wraps, not
/// a restatement of what a field is.
const String fieldExpandedDescription =
    'DsField is the labelling and validation wrapper every other input '
    'lives inside — not an input itself. It supplies the visible label, an '
    'optional description, and validation messages, and threads all three '
    'through DsFieldScope so the control folds them into one merged '
    'accessibility node instead of three separate announcements. Reach for '
    'it around DsInput, DsSelect, DsCheckbox, DsSwitch, or DsRadioGroup '
    'whenever that control needs a visible caption, helper copy, or an '
    'error message — none of those controls render their own visible label '
    'text. Reach for DsFieldGroup to stack several fields with the '
    'reference\'s own 20px rhythm, and DsFieldSet (with a leading '
    'DsFieldLegend) when several fields or a selection group belong under '
    'one heading, such as a radio group\'s "Payout rhythm". Reach for a '
    'bare DsFieldLabel, DsFieldDescription, or DsFieldError only when a '
    'call site is composing its own row by hand and DsField\'s fixed '
    'label-then-control-then-description-then-error order does not fit.';

const ComponentDocEntry fieldDoc = ComponentDocEntry(
  name: 'field',
  title: 'Field',
  description:
      'The label, description, and error wrapper every input, select, and '
      'selection control composes inside.',
  // registry/components/field.json's own registryDependencies, verbatim.
  dependencies: <String>['source-foundation', 'ds-rule'],
  exports: <String>[
    'DsField',
    'DsFieldScope',
    'DsFieldActivator',
    'DsFieldOrientation',
    'DsFieldGroup',
    'DsFieldSet',
    'DsFieldLegend',
    'DsFieldLabel',
    'DsFieldDescription',
    'DsFieldError',
  ],
  sourcePath: 'lib/src/components/field.dart',
);
