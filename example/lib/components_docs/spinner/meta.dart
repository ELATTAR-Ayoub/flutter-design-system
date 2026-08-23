/// Public documentation metadata for the spinner component.
///
/// `spinner` has a real `registry/components/spinner.json` manifest —
/// [dependencies] is that manifest's own `registryDependencies` list,
/// verbatim — so the icon page's installation section can render the real
/// `elattar add spinner` command.
///
/// Spinner is documented on the icon page rather than its own, because the
/// three smallest registry-backed primitives — icon, spinner and ds-rule —
/// read better together than as three near-empty pages.
library;

import '../catalog.dart';

const ComponentDocEntry spinnerDoc = ComponentDocEntry(
  name: 'spinner',
  title: 'Spinner',
  description:
      'A looping indeterminate activity indicator that settles under reduced motion.',
  // registry/components/spinner.json's registryDependencies, verbatim.
  dependencies: <String>['source-foundation'],
  exports: <String>['DsSpinner'],
  sourcePath: 'lib/src/components/spinner.dart',
);
