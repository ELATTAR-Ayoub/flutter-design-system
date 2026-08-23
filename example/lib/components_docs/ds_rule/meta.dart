/// Public documentation metadata for the ds-rule component.
///
/// `ds-rule` has a real `registry/components/ds-rule.json` manifest —
/// [dependencies] is that manifest's own `registryDependencies` list,
/// verbatim: so the icon page's installation section can render the real
/// `elattar add ds-rule` command.
///
/// Despite the name this is the validation-rule primitive, not a horizontal
/// line. Its factories are static methods taking a message, so they can never
/// appear inside a `const` expression.
library;

import '../catalog.dart';

const ComponentDocEntry dsRuleDoc = ComponentDocEntry(
  name: 'ds-rule',
  title: 'Rule',
  description:
      'Composable field validation rules with a Zod-derived email pattern.',
  // registry/components/ds-rule.json's registryDependencies, verbatim.
  dependencies: <String>['source-foundation'],
  exports: <String>['DsRule', 'DsRules', 'DsIssueMode'],
  sourcePath: 'lib/src/components/ds_rule.dart',
);
