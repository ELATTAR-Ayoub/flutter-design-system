/// Public documentation page for the `questionnaire` component.
///
/// Written from nothing: no page existed for this registry item before this
/// file. Read end to end from `lib/src/components/questionnaire.dart`
/// (1185 lines, `@shadcn/react/questionnaire` ported) and from
/// `test/agent_transcript_test.dart`, which exercises it live inside the
/// transcript page's own `_QuestionnaireDemo`. That specimen — a
/// three-item wizard with letter shortcuts, a required choice, an
/// optional text item, and a required text item — is reproduced below
/// rather than invented, adapted only to drop the fake network-latency
/// phase machinery a documentation preview does not need.
///
/// **It is a wizard, not a stack.** One [ElQuestionnaireItem] is on
/// screen at a time — every other one the caller passes is not laid out
/// at all, `SizedBox.shrink()` — which is what [ElQuestionnaireProgress],
/// [ElQuestionnairePrevious], [ElQuestionnaireSkip], [ElQuestionnaireNext]
/// and [ElQuestionnaireSubmit] all exist to move.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/component_doc_page.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../docs/docs_section.dart' show DocsAnchor;
import 'meta.dart';

final ComponentDocSpec questionnaireDocSpec = ComponentDocSpec(
  name: 'questionnaire',
  title: 'Questionnaire',
  description: questionnaireDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'Three items — a required choice, an optional text field, and '
          'a required text field — behind Progress and the four nav '
          'controls. Letters bind to the choices below (press A, B or '
          'C); Next and Submit both validate the active item first.',
      specimen: _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
      minHeight: el(120),
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'questionnaire has a real registry manifest, `elattar add '
          'questionnaire` installs lib/src/components/questionnaire.dart '
          'and resolves all five registryDependencies automatically. The '
          'Manual tab is for a project not using the CLI.',
      command: questionnaireDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/questionnaire.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/questionnaire.dart's generated "
              '@ui/questionnaire.dart payload into components/ui.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated questionnaire source here when '
              'using manual mode.',
        ),
        DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so ElQuestionnaire and every part it '
              'composes are reachable the same way the CLI path already '
              'makes them.',
          code: "export 'questionnaire.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'The smallest correct import and construction: one item, one '
          'choice, one Submit. Every example below only adds to this.',
      code: _usageCode,
    ),
    ShowcaseSection(
      id: 'choice-states',
      title: 'Choice states',
      description:
          'Four single-item forms, each frozen on one moment: '
          'unanswered, answered (defaultChecked), skipped (Skip '
          'pressed), and invalid (a required item validated with no '
          'answer). onSubmit is swallowed on every one — each cell '
          'exists to be looked at, not submitted.',
      specimen: _ChoiceStatesSpecimen(),
      code: _choiceStatesCode,
      label: 'Choice states specimen view',
    ),
    ShowcaseSection(
      id: 'text-item',
      title: 'Text item',
      description:
          'ElQuestionnaireInput is a control, so §3 puts it on the pill '
          'rather than the rounded-lg ladder ElQuestionnaireChoice uses. '
          'The right item is required and pre-invalidated to show the '
          'error line, which carries the source\'s own DRIFT: with no '
          'text child it renders exactly the primitive\'s default string.',
      specimen: _TextItemSpecimen(),
      code: _textItemCode,
      label: 'Text item specimen view',
    ),
    ShowcaseSection(
      id: 'shortcuts',
      title: 'Shortcuts',
      description:
          'shortcuts binds a key to every choice AND draws it, in a Kbd: '
          'letters (A, B, C…) on the left, numbers (1, 2, 3…) on the '
          'right, none by default. The root form\'s own onKeyDown reads '
          'the key, so the shortcut only fires while focus sits inside '
          'this questionnaire.',
      specimen: _ShortcutsSpecimen(),
      code: _shortcutsCode,
      label: 'Shortcuts specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every constructor parameter each exported class declares, '
          'every ElQuestionnaireShortcuts value, and '
          'ElQuestionnaireController\'s own public surface: one table '
          'per class or small family of classes.',
      children: const <DocsTocEntry>[
        DocsTocEntry(title: 'ElQuestionnaire', anchor: 'api-elquestionnaire'),
        DocsTocEntry(
          title: 'ElQuestionnaireShortcuts',
          anchor: 'api-elquestionnaireshortcuts',
        ),
        DocsTocEntry(
          title: 'ElQuestionnaireController',
          anchor: 'api-elquestionnairecontroller',
        ),
        DocsTocEntry(
          title: 'ElQuestionnaireItem',
          anchor: 'api-elquestionnaireitem',
        ),
        DocsTocEntry(
          title: 'Progress · Title · Description',
          anchor: 'api-elquestionnaire-structure',
        ),
        DocsTocEntry(
          title: 'Choices · Choice',
          anchor: 'api-elquestionnaire-choices',
        ),
        DocsTocEntry(
          title: 'Input · Error',
          anchor: 'api-elquestionnaire-input',
        ),
        DocsTocEntry(
          title: 'Actions',
          anchor: 'api-elquestionnaire-actions',
        ),
      ],
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'Read off _ElQuestionnaireState, ElQuestionnaireController and '
          '_ElQuestionnaireChoiceState directly, not inferred.',
      child: DocsStateMatrix(facts: _stateFacts),
    ),
    DisclosureSection(
      id: 'accessibility',
      title: 'Accessibility',
      child: _AccessibilityContent(),
    ),
    DisclosureSection(
      id: 'keyboard',
      title: 'Keyboard',
      description:
          'The one control family in this port with real keyboard '
          'navigation of its own: read off ElQuestionnaire\'s _onKey, '
          'not inferred.',
      child: _KeyboardContent(),
    ),
    DisclosureSection(
      id: 'responsive',
      title: 'Responsive',
      child: _ResponsiveContent(),
    ),
    DisclosureSection(
      id: 'dependencies',
      title: 'Dependencies',
      child: _DependenciesContent(),
    ),
    DisclosureSection(
      id: 'theming',
      title: 'Theming',
      child: _ThemingContent(),
    ),
    DisclosureSection(
      id: 'source',
      title: 'Source',
      child: DocsInstallFacts(
        title: 'Reference',
        facts: <DocsInstallFact>[
          DocsInstallFact(
            label: 'Source',
            value: questionnaireDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'test/agent_transcript_test.dart',
            description:
                'Covers ElQuestionnaire live, composed inside the '
                'transcript page\'s own demo — there is no dedicated '
                'questionnaire_test.dart in the package yet.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/questionnaire_test.dart',
            description:
                'Covers this page: the article mounts, the full API '
                'table, and every specimen this page claims to show.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/questionnaire/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class QuestionnaireDocPage extends StatelessWidget {
  const QuestionnaireDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: questionnaireDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / BASE',
      title: questionnaireDoc.title,
      description: questionnaireDoc.description,
    ),
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Components'),
      ElBreadcrumbEntry.page('Questionnaire'),
    ],
    toc: questionnaireDocSpec.toc,
    previous: null,
    next: null,
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('questionnaire-doc-article'),
      child: ComponentDocPage(spec: questionnaireDocSpec, header: false),
    ),
  );
}

/* ── Showcase specimens ─────────────────────────────────────────────────── */

const List<String> _packStyleValues = <String>['sealed', 'singles', 'slabs'];
const List<String> _packStyleChoices = <String>[
  'Sealed packs and boxes',
  'Singles off the wall',
  'Graded slabs',
];

class _PreviewSpecimen extends StatelessWidget {
  const _PreviewSpecimen();

  @override
  Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<String>('questionnaire-preview:root'),
    child: ElQuestionnaire(
      shortcuts: ElQuestionnaireShortcuts.letters,
      onSubmit: () {},
      children: <Widget>[
        const ElQuestionnaireProgress(),
        ElQuestionnaireItem(
          name: 'style',
          required: true,
          title: const ElQuestionnaireTitle('How do you usually pick a pack?'),
          children: <Widget>[
            ElQuestionnaireChoices(
              children: <ElQuestionnaireChoice>[
                for (int i = 0; i < _packStyleValues.length; i += 1)
                  ElQuestionnaireChoice(
                    value: _packStyleValues[i],
                    label: _packStyleChoices[i],
                  ),
              ],
            ),
            const ElQuestionnaireError(),
          ],
        ),
        const ElQuestionnaireItem(
          name: 'goal',
          title: ElQuestionnaireTitle('Chasing anything specific?'),
          description: ElQuestionnaireDescription(
            'Optional — Skip moves on without an answer.',
          ),
          children: <Widget>[
            ElQuestionnaireInput(placeholder: 'A card, a set, a rarity…'),
          ],
        ),
        const ElQuestionnaireItem(
          name: 'budget',
          required: true,
          title: ElQuestionnaireTitle("What's tonight's budget?"),
          children: <Widget>[
            ElQuestionnaireInput(
              placeholder: r'$',
              keyboardType: TextInputType.number,
            ),
            ElQuestionnaireError(text: 'Enter an amount before continuing.'),
          ],
        ),
        const ElQuestionnaireActions(
          children: <Widget>[
            ElQuestionnairePrevious(),
            ElQuestionnaireSkip(),
            ElQuestionnaireNext(),
            ElQuestionnaireSubmit(),
          ],
        ),
      ],
    ),
  );
}

const String _previewCode =
    "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
    'ElQuestionnaire(\n'
    '  shortcuts: ElQuestionnaireShortcuts.letters,\n'
    '  onSubmit: submit,\n'
    '  children: [\n'
    '    const ElQuestionnaireProgress(),\n'
    '    ElQuestionnaireItem(\n'
    "      name: 'style',\n"
    '      required: true,\n'
    "      title: const ElQuestionnaireTitle('How do you usually pick a pack?'),\n"
    '      children: [\n'
    '        ElQuestionnaireChoices(\n'
    '          children: [\n'
    "            ElQuestionnaireChoice(value: 'sealed', label: 'Sealed packs and boxes'),\n"
    "            ElQuestionnaireChoice(value: 'singles', label: 'Singles off the wall'),\n"
    "            ElQuestionnaireChoice(value: 'slabs', label: 'Graded slabs'),\n"
    '          ],\n'
    '        ),\n'
    '        const ElQuestionnaireError(),\n'
    '      ],\n'
    '    ),\n'
    '    // …more items…\n'
    '    const ElQuestionnaireActions(\n'
    '      children: [\n'
    '        ElQuestionnairePrevious(),\n'
    '        ElQuestionnaireSkip(),\n'
    '        ElQuestionnaireNext(),\n'
    '        ElQuestionnaireSubmit(),\n'
    '      ],\n'
    '    ),\n'
    '  ],\n'
    ')';

const String _usageCode = '''
import 'package:elattar_design_system/elattar_design_system.dart';

ElQuestionnaire(
  onSubmit: submit,
  children: const [
    ElQuestionnaireItem(
      name: 'answer',
      children: [
        ElQuestionnaireChoices(
          children: [ElQuestionnaireChoice(value: 'yes', label: 'Yes')],
        ),
      ],
    ),
    ElQuestionnaireActions(children: [ElQuestionnaireSubmit()]),
  ],
)''';

/// `_QuestionnaireCell` / `_QuestionnaireInvalidCell`, `transcript.dart`'s
/// own state-matrix cells, reproduced: each root is isolated (its own
/// `ElQuestionnaire`) and swallows `onSubmit`, since a single-item root
/// with a visible Submit or Skip would submit the instant it is pressed —
/// these cells exist to be looked at.
class _ChoiceStatesSpecimen extends StatelessWidget {
  const _ChoiceStatesSpecimen();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Wrap(
      spacing: el(6),
      runSpacing: el(4),
      children: <Widget>[
        _cell(theme, 'Unanswered', const _ChoiceCell(
          key: ValueKey<String>('questionnaire-example:choice-unanswered'),
        )),
        _cell(
          theme,
          'Answered',
          const _ChoiceCell(
            key: ValueKey<String>('questionnaire-example:choice-answered'),
            checked: true,
          ),
        ),
        _cell(
          theme,
          'Skipped',
          const _ChoiceCell(
            key: ValueKey<String>('questionnaire-example:choice-skipped'),
            withSkip: true,
          ),
        ),
        _cell(
          theme,
          'Invalid',
          const _InvalidChoiceCell(
            key: ValueKey<String>('questionnaire-example:choice-invalid'),
          ),
        ),
      ],
    );
  }

  Widget _cell(ElThemeData theme, String label, Widget child) => SizedBox(
    width: el(56),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        child,
        SizedBox(height: el(2)),
        ElText(label, ElType.small, color: theme.mutedForeground),
      ],
    ),
  );
}

class _ChoiceCell extends StatelessWidget {
  const _ChoiceCell({
    super.key,
    this.checked = false,
    this.withSkip = false,
  });

  final bool checked;
  final bool withSkip;

  @override
  Widget build(BuildContext context) => ElQuestionnaire(
    gap: el(3),
    children: <Widget>[
      ElQuestionnaireItem(
        name: 'demo',
        children: <Widget>[
          ElQuestionnaireChoices(
            children: <ElQuestionnaireChoice>[
              ElQuestionnaireChoice(
                value: 'a',
                label: 'Option A',
                defaultChecked: checked,
              ),
            ],
          ),
          if (withSkip)
            const ElQuestionnaireActions(
              children: <Widget>[ElQuestionnaireSkip()],
            ),
        ],
      ),
    ],
  );
}

class _InvalidChoiceCell extends StatelessWidget {
  const _InvalidChoiceCell({super.key});

  @override
  Widget build(BuildContext context) => const ElQuestionnaire(
    gap: 12, // el(3) inline, kept a literal-free double via the call site.
    children: <Widget>[
      ElQuestionnaireItem(
        name: 'demo',
        required: true,
        invalid: true,
        title: ElQuestionnaireTitle('Pick one'),
        children: <Widget>[
          ElQuestionnaireChoices(
            children: <ElQuestionnaireChoice>[
              ElQuestionnaireChoice(value: 'a', label: 'Option A'),
            ],
          ),
          ElQuestionnaireError(),
        ],
      ),
    ],
  );
}

const String _choiceStatesCode =
    "ElQuestionnaireChoice(value: 'a', label: 'Option A') // unanswered\n"
    "ElQuestionnaireChoice(value: 'a', label: 'Option A', defaultChecked: true) // answered\n"
    '// Skip pressed: ElQuestionnaireController.skip(name) — see Skipped above\n\n'
    '// invalid: true forces the state without validating.\n'
    'const ElQuestionnaireItem(\n'
    "  name: 'demo',\n"
    '  required: true,\n'
    '  invalid: true,\n'
    "  title: ElQuestionnaireTitle('Pick one'),\n"
    '  children: [\n'
    '    ElQuestionnaireChoices(\n'
    "      children: [ElQuestionnaireChoice(value: 'a', label: 'Option A')],\n"
    '    ),\n'
    '    ElQuestionnaireError(), // no text: the primitive\'s own default string\n'
    '  ],\n'
    ')';

class _TextItemSpecimen extends StatelessWidget {
  const _TextItemSpecimen();

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: el(6),
    runSpacing: el(4),
    children: <Widget>[
      SizedBox(
        width: el(72),
        child: const ElQuestionnaire(
          key: ValueKey<String>('questionnaire-example:text-optional'),
          children: <Widget>[
            ElQuestionnaireItem(
              name: 'goal',
              title: ElQuestionnaireTitle('Chasing anything specific?'),
              description: ElQuestionnaireDescription(
                'Optional — Skip moves on without an answer.',
              ),
              children: <Widget>[
                ElQuestionnaireInput(placeholder: 'A card, a set, a rarity…'),
              ],
            ),
          ],
        ),
      ),
      SizedBox(
        width: el(72),
        child: const ElQuestionnaire(
          key: ValueKey<String>('questionnaire-example:text-invalid'),
          children: <Widget>[
            ElQuestionnaireItem(
              name: 'budget',
              required: true,
              invalid: true,
              title: ElQuestionnaireTitle("What's tonight's budget?"),
              children: <Widget>[
                ElQuestionnaireInput(
                  placeholder: r'$',
                  keyboardType: TextInputType.number,
                ),
                ElQuestionnaireError(
                  text: 'Enter an amount before continuing.',
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}

const String _textItemCode =
    'ElQuestionnaireInput(placeholder: \'A card, a set, a rarity…\')\n\n'
    '// keyboardType routes the on-screen keyboard; ElQuestionnaireError\n'
    '// only mounts while its item is invalid.\n'
    'ElQuestionnaireInput(\n'
    '  placeholder: r\'\$\',\n'
    '  keyboardType: TextInputType.number,\n'
    ')\n'
    'ElQuestionnaireError(text: \'Enter an amount before continuing.\')';

class _ShortcutsSpecimen extends StatelessWidget {
  const _ShortcutsSpecimen();

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: el(6),
    runSpacing: el(4),
    children: <Widget>[
      SizedBox(
        width: el(72),
        child: KeyedSubtree(
          key: const ValueKey<String>('questionnaire-example:shortcuts-letters'),
          child: ElQuestionnaire(
            shortcuts: ElQuestionnaireShortcuts.letters,
            children: <Widget>[
              ElQuestionnaireItem(
                name: 'demo-letters',
                children: <Widget>[
                  ElQuestionnaireChoices(
                    children: <ElQuestionnaireChoice>[
                      for (int i = 0; i < _packStyleValues.length; i += 1)
                        ElQuestionnaireChoice(
                          value: _packStyleValues[i],
                          label: _packStyleChoices[i],
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      SizedBox(
        width: el(72),
        child: KeyedSubtree(
          key: const ValueKey<String>('questionnaire-example:shortcuts-numbers'),
          child: ElQuestionnaire(
            shortcuts: ElQuestionnaireShortcuts.numbers,
            children: <Widget>[
              ElQuestionnaireItem(
                name: 'demo-numbers',
                children: <Widget>[
                  ElQuestionnaireChoices(
                    children: <ElQuestionnaireChoice>[
                      for (int i = 0; i < _packStyleValues.length; i += 1)
                        ElQuestionnaireChoice(
                          value: _packStyleValues[i],
                          label: _packStyleChoices[i],
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

const String _shortcutsCode =
    '// ElQuestionnaireShortcuts.letters — A, B, C…\n'
    'ElQuestionnaire(shortcuts: ElQuestionnaireShortcuts.letters, children: [...])\n\n'
    '// ElQuestionnaireShortcuts.numbers — 1, 2, 3…\n'
    'ElQuestionnaire(shortcuts: ElQuestionnaireShortcuts.numbers, children: [...])\n\n'
    '// ElQuestionnaireShortcuts.none is the default: no binding, no badge.';

/* ── Disclosure content ─────────────────────────────────────────────────── */

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsAnchor(
        id: 'api-elquestionnaire',
        child: DocsApiTable(
          title: 'ElQuestionnaire',
          facts: _questionnaireFacts,
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elquestionnaireshortcuts',
        child: DocsApiTable(
          title: 'ElQuestionnaireShortcuts',
          facts: _shortcutsFacts,
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elquestionnairecontroller',
        child: DocsApiTable(
          title: 'ElQuestionnaireController',
          facts: _controllerFacts,
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elquestionnaireitem',
        child: DocsApiTable(
          title: 'ElQuestionnaireItem',
          facts: _itemFacts,
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elquestionnaire-structure',
        child: DocsApiTable(
          title: 'Progress · Title · Description',
          facts: _structureFacts,
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elquestionnaire-choices',
        child: DocsApiTable(title: 'Choices · Choice', facts: _choicesFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elquestionnaire-input',
        child: DocsApiTable(title: 'Input · Error', facts: _inputFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elquestionnaire-actions',
        child: DocsApiTable(title: 'Actions', facts: _actionsFacts),
      ),
    ],
  );
}

const List<DocsApiFact> _questionnaireFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'children',
    type: 'List<Widget>',
    description:
        'Required. The item list plus Progress/Actions siblings, in '
        'flow order. Every ElQuestionnaireItem but the active one lays '
        'out as SizedBox.shrink().',
  ),
  DocsApiFact(
    name: 'shortcuts',
    type: 'ElQuestionnaireShortcuts',
    description:
        'Optional. Defaults to ElQuestionnaireShortcuts.none. Which key '
        'set the active item\'s choices bind AND draw — see the table '
        'below.',
  ),
  DocsApiFact(
    name: 'onSubmit',
    type: 'VoidCallback?',
    description:
        'Optional. Defaults to null. Fires once every item validates '
        'and Submit is pressed (or the last item is Skipped).',
  ),
  DocsApiFact(
    name: 'gap',
    type: 'double?',
    description:
        'Optional. Defaults to null, which keeps gap-4 (16px). '
        'Overrides the column gap between visible children.',
  ),
  DocsApiFact(
    name: 'controller',
    type: 'ElQuestionnaireController?',
    description:
        'Optional. Defaults to null, which lets the widget own (and '
        'dispose) its own controller. Supply one to read or drive the '
        'wizard from outside — see the table below.',
  ),
  DocsApiFact(
    name: 'focusNode',
    type: 'FocusNode?',
    description:
        'Optional. Defaults to null, which lets the widget own its own '
        'node. The keyboard handler lives on this node, scoped to the '
        'form.',
  ),
];

const List<DocsApiFact> _shortcutsFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'none',
    type: 'enum value',
    description: 'The default. No binding, and no Kbd badge drawn.',
  ),
  DocsApiFact(
    name: 'letters',
    type: 'enum value',
    description: 'A, B, C… up to the 26th choice.',
  ),
  DocsApiFact(
    name: 'numbers',
    type: 'enum value',
    description: '1, 2, 3… up to the 9th choice.',
  ),
];

const List<DocsApiFact> _controllerFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'index',
    type: 'int (getter)',
    description: 'Which item is on screen, 0-based.',
  ),
  DocsApiFact(
    name: 'valueOf(name)',
    type: 'String?',
    description: 'The value currently held for the named item.',
  ),
  DocsApiFact(
    name: 'isSkipped(name)',
    type: 'bool',
    description: 'Whether the named item was moved past via Skip.',
  ),
  DocsApiFact(
    name: 'isInvalid(name)',
    type: 'bool',
    description: 'Whether the named item failed its last validate().',
  ),
  DocsApiFact(
    name: 'textFor(name)',
    type: 'TextEditingController',
    description:
        'The field controller for a text item, created on first ask '
        'and reused after — what ElQuestionnaireInput binds to.',
  ),
  DocsApiFact(
    name: 'setValue(name, value)',
    type: 'void',
    description:
        'Records an answer, clears skipped and invalid for that item, '
        'and notifies listeners.',
  ),
  DocsApiFact(
    name: 'skip(name)',
    type: 'void',
    description: 'Marks the item skipped without recording a value.',
  ),
  DocsApiFact(
    name: 'goTo(index)',
    type: 'void',
    description: 'Jumps the wizard straight to an item, unvalidated.',
  ),
  DocsApiFact(
    name: 'validate(name, {required required})',
    type: 'bool',
    description:
        'The primitive\'s own validate(): passes (and clears invalid) '
        'when the item is not required, has an answer, or was skipped; '
        'otherwise marks it invalid and returns false. Next and Submit '
        'both call this before advancing.',
  ),
];

const List<DocsApiFact> _itemFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'name',
    type: 'String',
    description:
        'Required. The key every controller method and shortcut lookup '
        'reads and writes by.',
  ),
  DocsApiFact(
    name: 'title',
    type: 'Widget?',
    description:
        'Optional. Defaults to null. Deliberately not one of children: '
        'it carries its own mb-4, paid only when no description '
        'follows.',
  ),
  DocsApiFact(
    name: 'description',
    type: 'Widget?',
    description: 'Optional. Defaults to null.',
  ),
  DocsApiFact(
    name: 'required',
    type: 'bool',
    description:
        'Optional. Defaults to false. Gates whether Skip renders and '
        'what validate() demands.',
  ),
  DocsApiFact(
    name: 'invalid',
    type: 'bool',
    description:
        'Optional. Defaults to false. Forces the invalid state without '
        'validating — what a frozen documentation or state-grid cell '
        'uses.',
  ),
  DocsApiFact(
    name: 'children',
    type: 'List<Widget>',
    description:
        'Optional. Defaults to an empty list. The item\'s own body — '
        'Choices or Input, plus an optional Error, laid out in a '
        '16px-gapped column.',
  ),
];

const List<DocsApiFact> _structureFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'ElQuestionnaireProgress()',
    type: 'no constructor params',
    description:
        "Renders \"Question X of Y\" off the controller's own index and "
        'the registered item count; reserves its row (min-h-4) before '
        'the text streams in.',
  ),
  DocsApiFact(
    name: 'ElQuestionnaireTitle(text)',
    type: 'String (positional, required)',
    description: 'The item\'s legend, font-heading text-base font-medium.',
  ),
  DocsApiFact(
    name: 'ElQuestionnaireDescription(text)',
    type: 'String (positional, required)',
    description: 'A second line under the title, muted foreground.',
  ),
];

const List<DocsApiFact> _choicesFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'ElQuestionnaireChoices.children',
    type: 'List<ElQuestionnaireChoice> (required)',
    description:
        'Registers its values with the enclosing item, which is what '
        'lets a typed key answer to the right choice.',
  ),
  DocsApiFact(
    name: 'ElQuestionnaireChoice.value',
    type: 'String (required)',
    description: 'The recorded answer when this choice is picked.',
  ),
  DocsApiFact(
    name: 'ElQuestionnaireChoice.label',
    type: 'String (required)',
    description: 'The visible row text.',
  ),
  DocsApiFact(
    name: 'ElQuestionnaireChoice.description',
    type: 'String?',
    description: 'Optional. Defaults to null. A second, muted line.',
  ),
  DocsApiFact(
    name: 'ElQuestionnaireChoice.defaultChecked',
    type: 'bool',
    description:
        'Optional. Defaults to false. Seeds the controller once on '
        'mount, the way an uncontrolled input\'s default value reaches '
        'state.',
  ),
  DocsApiFact(
    name: 'ElQuestionnaireChoice.disabled',
    type: 'bool',
    description:
        'Optional. Defaults to false. Mutes the tap at 50% opacity '
        'without changing the checked state.',
  ),
];

const List<DocsApiFact> _inputFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'ElQuestionnaireInput.placeholder',
    type: 'String?',
    description: 'Optional. Defaults to null.',
  ),
  DocsApiFact(
    name: 'ElQuestionnaireInput.keyboardType',
    type: 'TextInputType?',
    description:
        'Optional. Defaults to null. Passed straight through to the '
        'ElInput underneath.',
  ),
  DocsApiFact(
    name: 'ElQuestionnaireError.text',
    type: 'String?',
    description:
        'Optional. Defaults to null, which renders the primitive\'s '
        'own default: "Choose an answer to continue." when the item is '
        'required, "Choose an answer or skip this question." when it '
        'is not. DOCUMENTED DRIFT, reproduced: with no text supplied '
        'this is the exact string a real integration ships.',
  ),
];

const List<DocsApiFact> _actionsFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'ElQuestionnaireActions.children',
    type: 'List<Widget> (required)',
    description:
        'Lays the four controls out on a grid: leading content, Skip '
        'centred, Next/Submit trailing — the grid\'s gaps are paid even '
        'when a track has nothing in it.',
  ),
  DocsApiFact(
    name: 'ElQuestionnairePrevious.label',
    type: 'String, defaults to "Previous"',
    description: 'Visible when total > 1 && !first.',
  ),
  DocsApiFact(
    name: 'ElQuestionnaireSkip.label',
    type: 'String, defaults to "Skip"',
    description: 'Visible when the active item is NOT required.',
  ),
  DocsApiFact(
    name: 'ElQuestionnaireNext.label',
    type: 'String, defaults to "Next"',
    description:
        'Visible when total > 1 && !last. Validates the active item '
        'before advancing.',
  ),
  DocsApiFact(
    name: 'ElQuestionnaireSubmit.label',
    type: 'String, defaults to "Submit"',
    description:
        'Visible when total > 0 && last. Validates the active item, '
        'then calls onSubmit.',
  ),
];

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Unanswered',
    treatment:
        'No value, no skip flag. theme.input rim (dark: 20%-alpha theme'
        '.input fill; light: transparent).',
    userSignal: 'A plain outlined row, nothing chosen.',
  ),
  DocsStateFact(
    state: 'Answered',
    treatment:
        'controller.valueOf(name) == choice.value. theme.muted fill, '
        'theme.primary 40%-alpha rim, a primary-filled dot that pops in '
        'over ElDotPop\'s own curve.',
    userSignal: 'A filled indicator with a springing dot inside it.',
  ),
  DocsStateFact(
    state: 'Hover',
    treatment:
        'Pointer-only, unanswered choices only: theme.muted 50%-alpha '
        'fill.',
    userSignal: 'A faint highlight under the pointer.',
  ),
  DocsStateFact(
    state: 'Skipped',
    treatment:
        'controller.isSkipped(name). No value is recorded; the item is '
        'simply advanced past. Nothing on the choice row itself changes '
        '— skipped is a controller fact, not a choice paint.',
    userSignal: 'The wizard moves on with no answer recorded.',
  ),
  DocsStateFact(
    state: 'Invalid',
    treatment:
        'validate() failed, or invalid: true forced it. The choice '
        'rim and the radio control both switch to theme.destructive; '
        'ElQuestionnaireError mounts as a Semantics live region.',
    userSignal: 'A red-rimmed row and an error line announced live.',
  ),
  DocsStateFact(
    state: 'Disabled (a choice)',
    treatment:
        'ElQuestionnaireChoice.disabled: true. 50% opacity, cursor: '
        'forbidden, the tap handler is null.',
    userSignal: 'Faded and inert, independent of checked.',
  ),
  DocsStateFact(
    state: 'Submitting / Complete',
    treatment:
        'Not primitive states: ElQuestionnaireController tracks no '
        '"submitting" or "complete" flag at all. onSubmit fires once '
        'validation passes on the last item; whatever happens after — a '
        'spinner, a confirmation screen — is the call site\'s own state, '
        'as transcript.dart\'s ElQuestionnaireSubmittingView / '
        'ElQuestionnaireCompleteView demonstrate outside this file.',
    userSignal: 'Whatever the integration decides to show next.',
  ),
];

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'ElQuestionnaireProgress carries Semantics(label: '
            '"Questionnaire progress", value: "Question X of Y"), so an '
            'assistive technology hears the count even though the text '
            'itself is a plain paragraph.',
        'ElQuestionnaireError is a Semantics(liveRegion: true) — a new '
            'error is announced the moment it mounts, no focus move '
            'required.',
        'A choice row is not a native radio button: it is a plain '
            'GestureDetector with no Semantics node of its own layered '
            'on top of its visible content, so a screen reader reads '
            'whatever ElText children expose and nothing that names it '
            'as "selected" or "radio button."',
        'Known gap: the shortcut key bound to a choice (A/B/C or 1/2/3) '
            'is drawn in an ElKbd badge but carries no Semantics hint — '
            'a sighted keyboard user discovers it visually, a screen '
            'reader user is not told it exists.',
      ]);
}

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'Enter submits: calls the same validate-then-advance-or-submit '
            'path as pressing Submit, on the root form\'s Focus.onKeyEvent '
            '— scoped to this questionnaire, not the whole document.',
        'ArrowLeft goes to the previous item; ArrowRight validates the '
            'active item and goes to the next — the same two paths '
            'Previous and Next expose as buttons.',
        'A typed letter or digit, uppercased, is matched against '
            'shortcuts.keyFor(index) for every registered choice value '
            'on the active item; a match calls setValue immediately, no '
            'Enter needed.',
        'Every other key returns KeyEventResult.ignored and keeps '
            'propagating: this handler never swallows a key it does not '
            'recognise.',
        'Tab order is not managed by this file: no '
            'FocusTraversalPolicy is set here, so Tab and Shift+Tab walk '
            'whatever order the surrounding page declares — the same '
            'rule button.dart documents for itself.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'No MediaQuery.sizeOf breakpoint branch inside questionnaire.dart '
            'itself: every layout decision in this file is fixed.',
        'ElQuestionnaireInput does read the viewport once, through the '
            'field it composes: sm and above drop the 44px touch floor '
            'to a plain 32px height, the same rule ElField\'s own inputs '
            'use elsewhere in this system.',
        'Actions\' own grid keeps min-h-11 below sm and min-h-8 at sm '
            'and above — a breakpoint change in row height, not in what '
            'the row contains.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      _bullets(ElTheme.of(context), <String>[
        'File: lib/src/components/questionnaire.dart — one file, no '
            'companions; the registry manifest lists exactly one entry '
            'under "files".',
        'Flutter imports: package:flutter/services.dart '
            '(LogicalKeyboardKey, KeyEvent), package:flutter/widgets.dart.',
        'Foundation imports: foundation/colors.dart, foundation/motion.dart '
            '(elAnimationDuration), foundation/shadows.dart, '
            'foundation/spacing.dart (el()), foundation/theme.dart, '
            'foundation/typography.dart, motion/keyframes.dart '
            '(ElDotPop), theme_scope.dart.',
        'Component imports: button.dart (ElButton, the four action '
            'controls), input.dart (ElInput, what ElQuestionnaireInput '
            'wraps), kbd.dart (ElKbd, the shortcut badge).',
        'registryDependencies, resolved automatically by `elattar add '
            'questionnaire`: button, input, kbd, keyframes, '
            'source-foundation — copied verbatim from '
            'registry/components/questionnaire.json.',
      ]),
      SizedBox(height: el(3)),
      const DocsLinkRow(
        links: <DocsLink>[
          DocsLink(label: 'Button', route: '/components/button'),
          DocsLink(label: 'Input', route: '/components/input'),
          DocsLink(label: 'Kbd', route: '/components/kbd'),
          DocsLink(label: 'Keyframes', route: '/components/keyframes'),
          DocsLink(
            label: 'Source Foundation',
            route: '/components/source_foundation',
          ),
        ],
      ),
    ],
  );
}

class _ThemingContent extends StatelessWidget {
  const _ThemingContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'A choice reads theme.muted, theme.input, theme.primary and '
            'theme.destructive live off ElTheme.of(context) at every '
            'build: unanswered, answered, hovered and invalid each pick '
            'a different combination of the same four tokens.',
        'ElQuestionnaireInput and ElQuestionnaireError both route their '
            'colour through the same tokens ElField uses elsewhere: '
            'theme.input for the pill border, theme.destructiveInk for '
            'the error text.',
        'The answered dot\'s pop-in (ElDotPop) and the row\'s own hover/'
            'checked transitions both run on ElCurves and '
            'elAnimationDuration, the same clock every other control in '
            'this system shares — nothing here is a bespoke duration.',
        'Flipping ElThemeController re-resolves every one of these on '
            'the next frame: nothing is cached.',
      ]);
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
