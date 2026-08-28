/// Public documentation metadata for the spinner component.
///
/// `spinner` has a real `registry/components/spinner.json` manifest —
/// [dependencies] is that manifest's own `registryDependencies` list,
/// verbatim: so `page.dart`'s installation section can render the real
/// `elattar add spinner` command.
///
/// `spinner` has its own page (`page.dart`), shaped to mirror
/// https://ui.shadcn.com/docs/components/base/spinner's own section list —
/// see that file's library doc for the shadcn-parity notes and the one
/// section it honestly skips.
library;

import '../catalog.dart';

const ComponentDocEntry spinnerDoc = ComponentDocEntry(
  name: 'spinner',
  title: 'Spinner',
  description:
      'A looping indeterminate activity indicator that settles under reduced motion.',
  // registry/components/spinner.json's registryDependencies, verbatim.
  dependencies: <String>['icon', 'source-foundation'],
  exports: <String>['Spinner'],
  sourcePath: 'lib/src/components/spinner.dart',
);
