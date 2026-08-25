/// Public documentation page for the `rule` component, alone.
///
/// **Re-housed onto the kit.** This page used to hand-compose `ElSection`
/// panels; it now declares a `ComponentDocSpec`
/// (`example/lib/docs/component_doc_page.dart`) and hands it to
/// `ComponentDocPage`, the shape `button` established. Every specimen
/// widget and every code string the old page carried moves across
/// unchanged. Two things are new: the unheaded hero demo is now a real
/// `Preview` section with its own rail entry, and a Keyboard disclosure
/// sits between Accessibility and Responsive.
///
/// **The manifest is real, and empty on purpose.**
/// `registry/components/rule.json` ships today with an empty
/// `registryDependencies: []`: `rule.dart` imports nothing at all, not even
/// `package:flutter/widgets.dart`, so there is nothing for the manifest to
/// resolve. `elRuleDoc.command` (`elattar add rule`) still installs the
/// file itself.
///
/// `rule` has no shadcn counterpart at all: it corresponds to Zod schemas
/// plus `@hookform/resolvers`, not to any one shadcn component page. So its
/// sections are named for what [ElRule] does — composing a rule list,
/// collecting issues, deduplicating messages — in shadcn's own house style,
/// rather than mirrored from a page that does not exist.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/component_doc_page.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../docs/docs_section.dart' show DocsAnchor;
import 'meta.dart';

final ComponentDocSpec elRuleDocSpec = ComponentDocSpec(
  name: 'rule',
  title: elRuleDoc.title,
  description: elRuleDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description: "One rule's rendered message, for a value that fails it.",
      specimen: _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'rule has a real registry manifest with an empty '
          'registryDependencies: rule.dart imports nothing at all, not '
          'even package:flutter/widgets.dart, so `elattar add rule` has '
          'nothing else to resolve. The Manual tab is for a project not '
          'using the CLI.',
      command: elRuleDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/rule.dart',
          title: '1. Copy the source',
          description:
              "Copy rule.dart's generated payload into components/ui.",
          code:
              '// Copy the generated rule source here when using manual '
              'mode. No import of any kind, Flutter included.',
        ),
        const DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so ElRule, ElRules, and ElIssueMode '
              'are reachable.',
          code: "export 'rule.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'ElRule is the validation-rule primitive: a predicate and an '
          'error message, not a horizontal divider. A ElRule<T> holds a '
          'test function and the sentence it renders when a value fails. '
          'Every rule is a static factory method that takes a message, so '
          'it cannot appear inside a const expression: each rule is a new '
          'instance.',
      code: _usageCode,
    ),
    ShowcaseSection(
      id: 'composing',
      title: 'Composing a rule list',
      description:
          'A list of rules IS a schema: ordered checks against one field, '
          'each carrying the sentence it renders. ElRules.check walks the '
          'whole list and always collects every failure internally, in '
          'declaration order, never stopping early: that matches Zod 4\'s '
          'own behaviour, because the message a caller sees depends on it. '
          'ElIssueMode (see Collecting issues, below) then decides how '
          'many of those collected failures the caller actually gets '
          'back.',
      specimen: _ComposingSpecimen(),
      code: _composingCode,
      label: 'Composing a rule list specimen view',
    ),
    ShowcaseSection(
      id: 'collecting',
      title: 'Collecting issues',
      description:
          'ElIssueMode is RHF\'s criteriaMode, spelled as an enum: '
          'ElIssueMode.first (the default) truncates ElRules.check to the '
          'field\'s first failure, the account form\'s own behaviour. '
          'ElIssueMode.all keeps every failure, the password form\'s own '
          'behaviour, rendered as a bulleted list.',
      specimen: _CollectingSpecimen(),
      code: _collectingCode,
      label: 'Collecting issues specimen view',
    ),
    ShowcaseSection(
      id: 'deduping',
      title: 'Deduplicating messages',
      description:
          'ElRules.dedupe removes repeats, first occurrence winning: the '
          'same Map-keyed-by-message logic FieldError uses on the '
          'reference (field.tsx:196–198). Deliberately not run inside '
          'ElRules.check itself: the caller that renders the list is the '
          'caller that dedupes, matching where the reference does it.',
      specimen: _DedupingSpecimen(),
      code: _dedupingCode,
      label: 'Deduplicating messages specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      children: const <DocsTocEntry>[
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
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
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
    ),
    DisclosureSection(
      id: 'accessibility',
      title: 'Accessibility',
      child: _OneSentence(
        'ElRule contributes no accessibility surface of its own. issue() '
        "returns a plain string; FieldError is the component that renders "
        "it and wires it to the field's accessible description.",
      ),
    ),
    DisclosureSection(
      id: 'keyboard',
      title: 'Keyboard',
      child: _OneSentence(
        'ElRule has no interactive surface at all: it is pure Dart, no '
        'Flutter import anywhere in rule.dart, so there is no focus order '
        'and no key handling to describe.',
      ),
    ),
    DisclosureSection(
      id: 'responsive',
      title: 'Responsive',
      child: _OneSentence(
        'ElRule has no layout surface at all: it is pure Dart, no Flutter '
        'import anywhere in rule.dart, evaluated the same way regardless '
        'of platform or viewport.',
      ),
    ),
    DisclosureSection(
      id: 'dependencies',
      title: 'Dependencies',
      child: _DependenciesContent(),
    ),
    DisclosureSection(
      id: 'theming',
      title: 'Theming',
      child: _OneSentence(
        'No theming surface at all. ElRule renders nothing; the '
        'destructive/error tokens that colour a validation message are '
        'applied by FieldError, not by this file.',
      ),
    ),
    DisclosureSection(
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
            value: 'example/test/components_docs/rule_test.dart',
            description:
                'Covers this page: every static factory, ElRules.check '
                'under both ElIssueMode values, dedupe, and the API '
                'table.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/rule/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

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
    toc: elRuleDocSpec.toc,
    previous: null,
    next: null,
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('rule-doc-article'),
      child: ComponentDocPage(spec: elRuleDocSpec, header: false),
    ),
  );
}

/* ── Disclosure content ─────────────────────────────────────────────────── */

/// One honest sentence, for a disclosure this component has nothing more to
/// say under.
class _OneSentence extends StatelessWidget {
  const _OneSentence(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: ElWidths.prose),
    child: ElText(
      text,
      ElType.small,
      color: ElTheme.of(context).mutedForeground,
    ),
  );
}

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsAnchor(
        id: 'api-elrule',
        child: DocsApiTable(
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
      const DocsAnchor(
        id: 'api-elrule-factories',
        child: DocsApiTable(
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
      const DocsAnchor(
        id: 'api-elrule-methods',
        child: DocsApiTable(
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
                  'is constructed from a raw-string RegExp literal, '
                  'which is not a compile-time constant in Dart.',
            ),
          ],
        ),
      ),
      SizedBox(height: el(6)),
      const DocsAnchor(
        id: 'api-elrules',
        child: DocsApiTable(
          title: 'ElRules (runner)',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'ElRules.check<T>(T, List<ElRule<T>>, {ElIssueMode '
                  'mode})',
              type: 'static List<String>',
              description:
                  'Walks every rule in order, collects all failures, and '
                  'truncates to the first under ElIssueMode.first (the '
                  'default), or keeps all under .all. Like Zod with '
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
      const DocsAnchor(
        id: 'api-elissuemode',
        child: DocsApiTable(
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
  );
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      _bullets(ElTheme.of(context), <String>[
        'File: lib/src/components/rule.dart, one file, no companions, no '
            'Flutter import.',
        'registryDependencies: empty. Nothing to resolve: rule.dart has '
            'no import of its own to chase.',
        'Used by field and form contexts: any ElRule<T> list is a schema '
            'a form field validates against.',
      ]),
      SizedBox(height: el(2)),
      DocsLinkRow(
        links: <DocsLink>[
          const DocsLink(label: 'Field', route: '/components/field'),
          const DocsLink(label: 'Form', route: '/components/form'),
        ],
      ),
    ],
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

/* ── Showcase specimens ─────────────────────────────────────────────────── */

class _PreviewSpecimen extends StatelessWidget {
  const _PreviewSpecimen();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      ElText(
        ElRule.email('That is not an email address.').issue('a@b') ?? '',
        ElType.small,
      ),
      SizedBox(height: el(2)),
      ElText("ElRule.email('...').issue('a@b')", ElType.code),
    ],
  );
}

class _ComposingSpecimen extends StatelessWidget {
  const _ComposingSpecimen();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
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
          "ElRules.check('AB', handleRules, mode: ElIssueMode.all)",
          ElType.code,
        ),
        SizedBox(height: el(2)),
        for (final String issue in issues)
          ElText('• $issue', ElType.small, color: theme.destructiveInk),
      ],
    );
  }
}

class _CollectingSpecimen extends StatelessWidget {
  const _CollectingSpecimen();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
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
        ElText('ElIssueMode.first (${firstOnly.length} shown)', ElType.section),
        for (final String issue in firstOnly)
          ElText('• $issue', ElType.small, color: theme.destructiveInk),
        SizedBox(height: el(4)),
        ElText('ElIssueMode.all (${all.length} shown)', ElType.section),
        for (final String issue in all)
          ElText('• $issue', ElType.small, color: theme.destructiveInk),
      ],
    );
  }
}

class _DedupingSpecimen extends StatelessWidget {
  const _DedupingSpecimen();

  @override
  Widget build(BuildContext context) {
    final List<String> deduped = ElRules.dedupe(<String>[
      'Required.',
      'Required.',
      'Too short.',
    ]);
    return ElText(deduped.join(', '), ElType.small);
  }
}

/* ── Code strings ───────────────────────────────────────────────────────── */

const String _previewCode =
    "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
    "ElRule.email('That is not an email address.').issue('a@b')";

const String _usageCode = '''
import 'package:elattar_design_system/elattar_design_system.dart';

final ElRule<String> minLen = ElRule.minLength(
  3,
  'At least 3 characters.',
);

final ElRule<String> email = ElRule.email(
  'That is not an email address.',
);''';

const String _composingCode =
    'final List<ElRule<String>> handleRules = <ElRule<String>>[\n'
    "  ElRule.minLength(3, 'At least 3 characters.'),\n"
    '  ElRule.pattern(\n'
    "    RegExp(r'^[a-z0-9_]+\$'),\n"
    "    'Lowercase letters, digits, or underscore only.',\n"
    '  ),\n'
    '];\n\n'
    "ElRules.check('AB', handleRules, mode: ElIssueMode.all)\n"
    '// both fail: too short AND uppercase';

const String _collectingCode =
    "ElRules.check('ab', passwordRules, mode: ElIssueMode.first) // 1 issue\n"
    "ElRules.check('ab', passwordRules, mode: ElIssueMode.all)   // 3 issues";

const String _dedupingCode =
    "ElRules.dedupe(['Required.', 'Required.', 'Too short.'])\n"
    "// ['Required.', 'Too short.']";
