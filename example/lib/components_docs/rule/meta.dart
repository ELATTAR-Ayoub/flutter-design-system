/// Public documentation metadata for the rule component.
///
/// `rule` has a real `registry/components/rule.json` manifest —
/// [dependencies] is that manifest's own `registryDependencies` list,
/// verbatim: so `page.dart`'s installation section can render the real
/// `elattar add rule` command.
///
/// Despite the name this is the validation-rule primitive, not a horizontal
/// line. Its factories are static methods taking a message, so they can never
/// appear inside a `const` expression.
///
/// `rule` has no shadcn counterpart: it has its own page (`page.dart`),
/// with sections named for what it does rather than mirrored from a page
/// that does not exist.
library;

import '../catalog.dart';

const ComponentDocEntry elRuleDoc = ComponentDocEntry(
  name: 'rule',
  title: 'Rule',
  description:
      'Composable field validation rules with a Zod-derived email pattern.',
  // registry/components/rule.json's registryDependencies, verbatim.
  dependencies: <String>[],
  exports: <String>['ElRule', 'ElRules', 'ElIssueMode'],
  sourcePath: 'lib/src/components/rule.dart',
);
