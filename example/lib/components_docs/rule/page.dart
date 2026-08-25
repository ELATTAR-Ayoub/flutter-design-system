/// Public documentation page for the `rule` component, alone.
///
/// **Split from a three-component page.** `icon`, `spinner` and `rule`
/// used to share one route (`components_docs/icon/page.dart`). `rule`
/// now gets its own file, reshaped to the same frame `../button/page.dart`
/// establishes.
///
/// `rule` has no shadcn counterpart at all: it corresponds to Zod schemas
/// plus `@hookform/resolvers`, not to any one shadcn component page. So its
/// sections are named for what [ElRule] does — composing a rule list,
/// collecting issues, deduplicating messages — in shadcn's own house style,
/// rather than mirrored from a page that does not exist.
///
/// **Shape.** An unheaded live demo, then Installation, then Usage, then
/// this component's own sections, then API Reference last (one prop table
/// per class), then exactly States, Accessibility, Responsive, Dependencies,
/// Theming, Source.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/docs_code.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../kit.dart';
import 'meta.dart';

class ElRuleDocPage extends StatelessWidget {
  const ElRuleDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: elRuleDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / PRIMITIVES',
      title: elRuleDoc.title,
      description: elRuleDoc.description,
    ),
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Components'),
      ElBreadcrumbEntry.page('Rule'),
    ],
    toc: const <DocsTocEntry>[
      DocsTocEntry(title: 'Installation', anchor: 'install'),
      DocsTocEntry(title: 'Usage', anchor: 'usage'),
      DocsTocEntry(title: 'Composing a rule list', anchor: 'composing'),
      DocsTocEntry(title: 'Collecting issues', anchor: 'collecting'),
      DocsTocEntry(title: 'Deduplicating messages', anchor: 'deduping'),
      DocsTocEntry(
        title: 'API Reference',
        anchor: 'api',
        children: <DocsTocEntry>[
          DocsTocEntry(title: 'ElRule', anchor: 'api-elrule'),
          DocsTocEntry(
            title: 'ElRule static factory methods',
            anchor: 'api-elrule-factories',
          ),
          DocsTocEntry(
            title: 'ElRule methods and constants',
            anchor: 'api-elrule-methods',
          ),
          DocsTocEntry(title: 'ElRules', anchor: 'api-elrules'),
          DocsTocEntry(title: 'ElIssueMode', anchor: 'api-elissuemode'),
        ],
      ),
      DocsTocEntry(title: 'States', anchor: 'states'),
      DocsTocEntry(title: 'Accessibility', anchor: 'accessibility'),
      DocsTocEntry(title: 'Responsive', anchor: 'responsive'),
      DocsTocEntry(title: 'Dependencies', anchor: 'dependencies'),
      DocsTocEntry(title: 'Theming', anchor: 'theming'),
      DocsTocEntry(title: 'Source', anchor: 'source'),
    ],
    onNavigate: onNavigate,
    child: const _DsRuleArticle(),
  );
}

class _DsRuleArticle extends StatelessWidget {
  const _DsRuleArticle();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      key: const ValueKey<String>('rule-doc-article'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _heroDemo(),
        SizedBox(height: el(6)),
        _install(),
        SizedBox(height: el(6)),
        _usage(),
        _composing(theme),
        _collecting(theme),
        _deduping(theme),
        _api(),
        _states(),
        _accessibility(theme),
        _responsive(theme),
        _dependencies(theme),
        _theming(theme),
        _source(),
      ],
    );
  }

  // ── LIVE DEMO (unheaded) ────────────────────────────────────────────────

  Widget _heroDemo() => DocsCodeExample(
    title: 'Rule',
    description: "One rule's rendered message, for a value that fails it.",
    preview: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ElText(
          ElRule.email('That is not an email address.').issue('a@b') ?? '',
          ElType.small,
        ),
        SizedBox(height: el(2)),
        ElText('ElRule.email(\'...\').issue(\'a@b\')', ElType.code),
      ],
    ),
    manualFiles: const <DocsCodeFile>[
      DocsCodeFile(
        path: 'lib/components/ui/rule.dart',
        code:
            "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
            "ElRule.email('That is not an email address.').issue('a@b')",
      ),
    ],
  );

  // ── SHARED SECTIONS ────────────────────────────────────────────────────

  Widget _install() => ElSection(
    id: 'install',
    title: 'Installation',
    description:
        'rule has a real registry manifest, `elattar add rule` '
        'installs lib/src/components/rule.dart and resolves '
        'source-foundation automatically.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DocsCodeExample(
          title: 'Install rule',
          command: DocsCodeCommand(
            command: elRuleDoc.command,
            description: 'Installs rule.dart.',
          ),
          manualFiles: const <DocsCodeFile>[
            DocsCodeFile(
              path: 'lib/components/ui/rule.dart',
              title: '1. Copy the source',
              description:
                  "Copy rule.dart's generated payload into components/ui.",
              code:
                  '// Copy the generated rule source here when using manual mode.',
            ),
            DocsCodeFile(
              path: 'lib/components/ui/ui.dart',
              title: '2. Export it from your barrel',
              description:
                  'Add the export line so ElRule, ElRules, and ElIssueMode '
                  'are reachable.',
              code: "export 'rule.dart';",
            ),
          ],
        ),
        SizedBox(height: el(5)),
        DocsInstallFacts(
          title: 'Manual install facts',
          facts: <DocsInstallFact>[
            DocsInstallFact(
              label: 'Registry dependencies',
              value: elRuleDoc.dependencies.join(', '),
              description:
                  "registry/components/rule.json's own "
                  'registryDependencies, verbatim.',
            ),
            const DocsInstallFact(
              label: 'Manual copy target',
              value: 'lib/components/ui/rule.dart',
              description: 'Where the CLI itself would place the file.',
            ),
            const DocsInstallFact(
              label: 'No Flutter import at all',
              value: 'pure Dart',
              description:
                  'rule.dart imports nothing, not even '
                  "package:flutter/widgets.dart: it is a validation "
                  'predicate library, not a widget.',
            ),
          ],
        ),
      ],
    ),
  );

  Widget _usage() => ElSection(
    id: 'usage',
    title: 'Usage',
    description:
        'ElRule is the validation-rule primitive: a predicate and an error '
        'message, not a horizontal divider. A ElRule<T> holds a test '
        'function and the sentence it renders when a value fails. Every '
        'rule is a static factory method that takes a message, so it '
        'cannot appear inside a const expression: each rule is a new '
        'instance.',
    child: ElPanel(
      label: 'DART',
      note: 'MINIMAL',
      child: DocsSelectableCodeBlock(code: _usageCode),
    ),
  );

  Widget _composing(ElThemeData theme) => ElSection(
    id: 'composing',
    title: 'Composing a rule list',
    description:
        'A list of rules IS a schema: ordered checks against one field, '
        'each carrying the sentence it renders. ElRules.check walks the '
        'whole list and always collects every failure internally, in '
        'declaration order, never stopping early: that matches Zod 4\'s own '
        'behaviour, because the message a caller sees depends on it. '
        'ElIssueMode (see Collecting issues, below) then decides how many '
        'of those collected failures the caller actually gets back.',
    child: DocsCodeExample(
      title: 'A two-check handle schema, every failure',
      preview: Builder(
        builder: (BuildContext context) {
          final List<ElRule<String>> handleRules = <ElRule<String>>[
            ElRule.minLength(3, 'At least 3 characters.'),
            ElRule.pattern(
              RegExp(r'^[a-z0-9_]+$'),
              'Lowercase letters, digits, or underscore only.',
            ),
          ];
          final List<String> issues = ElRules.check(
            'AB',
            handleRules,
            mode: ElIssueMode.all,
          );
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ElText(
                'ElRules.check(\'AB\', handleRules, mode: ElIssueMode.all)',
                ElType.code,
              ),
              SizedBox(height: el(2)),
              for (final String issue in issues)
                ElText('• $issue', ElType.small, color: theme.destructiveInk),
            ],
          );
        },
      ),
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(
          path: 'el_rule_compose.dart',
          code:
              'final List<ElRule<String>> handleRules = <ElRule<String>>[\n'
              "  ElRule.minLength(3, 'At least 3 characters.'),\n"
              '  ElRule.pattern(\n'
              "    RegExp(r'^[a-z0-9_]+\$'),\n"
              "    'Lowercase letters, digits, or underscore only.',\n"
              '  ),\n'
              '];\n\n'
              "ElRules.check('AB', handleRules, mode: ElIssueMode.all)\n"
              '// both fail: too short AND uppercase',
        ),
      ],
    ),
  );

  Widget _collecting(ElThemeData theme) => ElSection(
    id: 'collecting',
    title: 'Collecting issues',
    description:
        'ElIssueMode is RHF\'s criteriaMode, spelled as an enum: '
        'ElIssueMode.first (the default) truncates ElRules.check to the '
        'field\'s first failure, the account form\'s own behaviour. '
        'ElIssueMode.all keeps every failure, the password form\'s own '
        'behaviour, rendered as a bulleted list.',
    child: DocsCodeExample(
      title: 'The same failing value, both modes',
      preview: Builder(
        builder: (BuildContext context) {
          final List<ElRule<String>> passwordRules = <ElRule<String>>[
            ElRule.minLength(8, 'At least 8 characters.'),
            ElRule.pattern(RegExp('[A-Z]'), 'At least one capital letter.'),
            ElRule.pattern(RegExp('[0-9]'), 'At least one digit.'),
          ];
          final List<String> firstOnly = ElRules.check(
            'ab',
            passwordRules,
            mode: ElIssueMode.first,
          );
          final List<String> all = ElRules.check(
            'ab',
            passwordRules,
            mode: ElIssueMode.all,
          );
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ElText(
                'ElIssueMode.first (${firstOnly.length} shown)',
                ElType.section,
              ),
              for (final String issue in firstOnly)
                ElText('• $issue', ElType.small, color: theme.destructiveInk),
              SizedBox(height: el(4)),
              ElText('ElIssueMode.all (${all.length} shown)', ElType.section),
              for (final String issue in all)
                ElText('• $issue', ElType.small, color: theme.destructiveInk),
            ],
          );
        },
      ),
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(
          path: 'el_rule_collect.dart',
          code:
              "ElRules.check('ab', passwordRules, mode: ElIssueMode.first) // 1 issue\n"
              "ElRules.check('ab', passwordRules, mode: ElIssueMode.all)   // 3 issues",
        ),
      ],
    ),
  );

  Widget _deduping(ElThemeData theme) => ElSection(
    id: 'deduping',
    title: 'Deduplicating messages',
    description:
        'ElRules.dedupe removes repeats, first occurrence winning: the '
        'same Map-keyed-by-message logic FieldError uses on the reference '
        '(field.tsx:196–198). Deliberately not run inside ElRules.check '
        'itself: the caller that renders the list is the caller that '
        'dedupes, matching where the reference does it.',
    child: DocsCodeExample(
      title: 'Two rules, one shared message',
      preview: Builder(
        builder: (BuildContext context) {
          final List<String> deduped = ElRules.dedupe(<String>[
            'Required.',
            'Required.',
            'Too short.',
          ]);
          return ElText(deduped.join(', '), ElType.small);
        },
      ),
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(
          path: 'el_rule_dedupe.dart',
          code:
              "ElRules.dedupe(['Required.', 'Required.', 'Too short.'])\n"
              "// ['Required.', 'Too short.']",
        ),
      ],
    ),
  );

  Widget _api() => ElSection(
    id: 'api',
    title: 'API Reference',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        KeyedSubtree(
          key: docsAnchorKey('api-elrule'),
          child: const DocsApiTable(
            title: 'ElRule properties',
            facts: <DocsApiFact>[
              DocsApiFact(
                name: 'test',
                type: 'ElRuleTest<T> (bool Function(T))',
                description:
                    'Required. Returns true when the value passes. Public '
                    'for custom rules; use the static factories below for '
                    'the shipped checks.',
              ),
              DocsApiFact(
                name: 'message',
                type: 'String',
                description:
                    'Required. Rendered verbatim by FieldError when test '
                    'fails.',
              ),
            ],
          ),
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-elrule-factories'),
          child: const DocsApiTable(
            title: 'ElRule static factory methods',
            facts: <DocsApiFact>[
              DocsApiFact(
                name: 'ElRule.minLength(int, String)',
                type: 'static ElRule<String>',
                description:
                    'Passes when String.length >= min. Counts UTF-16 code '
                    'units, matching JavaScript and Zod.',
              ),
              DocsApiFact(
                name: 'ElRule.maxLength(int, String)',
                type: 'static ElRule<String>',
                description: 'Passes when String.length <= max.',
              ),
              DocsApiFact(
                name: 'ElRule.pattern(RegExp, String)',
                type: 'static ElRule<String>',
                description:
                    'Passes when RegExp.hasMatch(value) is true. Tests are '
                    'searches, not anchored matches: write anchors like '
                    '^value\$ yourself if you mean the whole value.',
              ),
              DocsApiFact(
                name: 'ElRule.email(String)',
                type: 'static ElRule<String>',
                description:
                    'Passes when ElRule.emailPattern matches: the Zod 4 '
                    'email regex, verbatim, strict. `a@b` fails where '
                    'HTML5\'s type="email" accepts it: no leading dot, no '
                    'consecutive dots, at least one dotted domain label, '
                    'and a two-or-more-letter TLD.',
              ),
              DocsApiFact(
                name: 'ElRule.accepted(String)',
                type: 'static ElRule<bool>',
                description:
                    'Passes when value == true. For checkbox terms and '
                    'conditions.',
              ),
              DocsApiFact(
                name: 'ElRule.oneOf<T>(List<T>, String)',
                type: 'static ElRule<T?>',
                description:
                    'Passes when value != null and allowed.contains(value). '
                    'Use for radio groups and select dropdowns; null '
                    '(untouched) fails.',
              ),
            ],
          ),
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-elrule-methods'),
          child: const DocsApiTable(
            title: 'ElRule methods and constants',
            facts: <DocsApiFact>[
              DocsApiFact(
                name: 'issue(T)',
                type: 'String?',
                description:
                    'Returns message when test(value) is false, null when '
                    'it passes. Used by ElRules.check.',
              ),
              DocsApiFact(
                name: 'ElRule.emailPattern',
                type: 'static final RegExp',
                description:
                    "The Zod 4 email regex, verbatim: requires ^, no "
                    'leading dot, no .., at least one dotted domain label, '
                    'and 2+ letter TLD. static final, not static const: it '
                    'is constructed from a raw-string RegExp literal, which '
                    'is not a compile-time constant in Dart.',
              ),
            ],
          ),
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-elrules'),
          child: const DocsApiTable(
            title: 'ElRules (runner)',
            facts: <DocsApiFact>[
              DocsApiFact(
                name:
                    'ElRules.check<T>(T, List<ElRule<T>>, {ElIssueMode '
                    'mode})',
                type: 'static List<String>',
                description:
                    'Walks every rule in order, collects all failures, and '
                    'truncates to the first under ElIssueMode.first '
                    '(the default), or keeps all under .all. Like Zod with '
                    "RHF's criteriaMode.",
              ),
              DocsApiFact(
                name: 'ElRules.dedupe(List<String>)',
                type: 'static List<String>',
                description:
                    'Removes duplicate messages, first occurrence winning. '
                    "Matches FieldError's own dedupe logic.",
              ),
            ],
          ),
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-elissuemode'),
          child: const DocsApiTable(
            title: 'ElIssueMode',
            facts: <DocsApiFact>[
              DocsApiFact(
                name: 'first',
                type: 'enum value',
                description:
                    "Default. ElRules.check truncates to the first "
                    'failure. The account form only renders one message, '
                    'even if three checks fail.',
              ),
              DocsApiFact(
                name: 'all',
                type: 'enum value',
                description:
                    'ElRules.check returns every failure. The password '
                    'form renders a bulleted list when multiple rules '
                    'fail.',
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _states() => ElSection(
    id: 'states',
    title: 'States',
    child: const DocsStateMatrix(
      facts: <DocsStateFact>[
        DocsStateFact(
          state: 'Passing',
          treatment: 'issue(value) returns null.',
          userSignal:
              'No error renders. ElRules.check omits this rule from its '
              'result list.',
        ),
        DocsStateFact(
          state: 'Failing',
          treatment: 'issue(value) returns message.',
          userSignal:
              'FieldError renders the message. ElIssueMode decides '
              'whether sibling failures also render.',
        ),
      ],
    ),
  );

  Widget _accessibility(ElThemeData theme) => ElSection(
    id: 'accessibility',
    title: 'Accessibility',
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: ElWidths.prose),
      child: ElText(
        'ElRule contributes no accessibility surface of its own. issue() '
        'returns a plain string; FieldError is the component that renders '
        "it and wires it to the field's accessible description.",
        ElType.body,
      ),
    ),
  );

  Widget _responsive(ElThemeData theme) => ElSection(
    id: 'responsive',
    title: 'Responsive',
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: ElWidths.prose),
      child: ElText(
        'ElRule has no layout surface at all: it is pure Dart, no Flutter '
        'import anywhere in rule.dart, evaluated the same way '
        'regardless of platform or viewport.',
        ElType.body,
      ),
    ),
  );

  Widget _dependencies(ElThemeData theme) => ElSection(
    id: 'dependencies',
    title: 'Dependencies',
    child: _bullets(theme, <String>[
      'File: lib/src/components/rule.dart, one file, no companions, no '
          'Flutter import.',
      'registryDependencies, resolved automatically by `elattar add '
          'rule`: source-foundation.',
      'Used by field and form contexts: any ElRule<T> list is a schema a '
          'form field validates against.',
    ]),
  );

  Widget _theming(ElThemeData theme) => ElSection(
    id: 'theming',
    title: 'Theming',
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: ElWidths.prose),
      child: ElText(
        'No theming surface at all. ElRule renders nothing; the '
        'destructive/error tokens that colour a validation message are '
        'applied by FieldError, not by this file.',
        ElType.body,
      ),
    ),
  );

  Widget _source() => ElSection(
    id: 'source',
    title: 'Source',
    child: DocsInstallFacts(
      title: 'Reference',
      facts: <DocsInstallFact>[
        DocsInstallFact(
          label: 'Source',
          value: elRuleDoc.sourcePath,
          description: 'The validation rule component.',
        ),
        const DocsInstallFact(
          label: 'Package tests',
          value: 'test/components_test.dart',
          description:
              'ElRule and ElRules are covered inside the shared '
              'base-components suite.',
        ),
        const DocsInstallFact(
          label: 'Docs test',
          value: 'example/test/components_docs/el_rule_test.dart',
          description:
              'Covers this page: every static factory, ElRules.check '
              'under both ElIssueMode values, dedupe, and the API table.',
        ),
        const DocsInstallFact(
          label: 'Edit these docs',
          value: 'example/lib/components_docs/rule/page.dart',
          description: 'This file.',
        ),
      ],
    ),
  );
}

Widget _bullets(ElThemeData theme, List<String> lines) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: <Widget>[
    for (final String line in lines) ...<Widget>[
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: ElWidths.prose),
        child: ElText('•  $line', ElType.small, color: theme.mutedForeground),
      ),
      SizedBox(height: el(2)),
    ],
  ],
);

const String _usageCode = '''
import 'package:elattar_design_system/elattar_design_system.dart';

final ElRule<String> minLen = ElRule.minLength(
  3,
  'At least 3 characters.',
);

final ElRule<String> email = ElRule.email(
  'That is not an email address.',
);''';
