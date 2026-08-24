/// Public documentation metadata for the `form` component.
///
/// [ElForm] is not a layout wrapper and not a visual component at all: it is
/// the non-visual form state container — fields in registration order,
/// validation rules, submission policy, and focus-on-error logic. Bind it
/// with `ListenableBuilder` and read field state on every rebuild. This page
/// also documents its field types: [ElFormFieldBase], [ElFormField],
/// [ElTextFormField], and [ElValidateMode].
///
/// `https://ui.shadcn.com/docs/components/form` has no counterpart content
/// of its own to mirror: it is a "pick your framework" gateway page (React
/// Hook Form, TanStack Form, Formisch) with no props, no API, and no
/// component sections at all. So this page's own sections are named for the
/// reader problems `form.dart`'s own source actually solves: when
/// validation runs, where focus lands after a failed submit, how a server
/// error is surfaced, and how a form resets.
///
/// Install with `elattar add form`; the CLI resolves the declared dependency
/// closure.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry formDoc = ComponentDocEntry(
  name: 'form',
  title: 'Form',
  description:
      'The non-visual form state container: fields in registration order, '
      'validation rules, submission policy, and focus-on-error logic.',
  // Registry dependencies are resolved by `elattar add form`.
  dependencies: <String>['rule'],
  exports: <String>[
    'ElForm',
    'ElFormFieldBase',
    'ElFormField',
    'ElTextFormField',
    'ElValidateMode',
  ],
  sourcePath: 'lib/src/components/form.dart',
);
