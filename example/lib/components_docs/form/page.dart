/// Public component documentation for the `form` component.
///
/// **form** documents [ElForm], [ElFormFieldBase], [ElFormField],
/// [ElTextFormField], and [ElValidateMode].
///
/// `https://ui.shadcn.com/docs/components/form` is a "pick your framework"
/// gateway page with no props, no API, and no component sections at all, so
/// this page's own sections are named for the reader problems `form.dart`'s
/// own source actually solves, in the order that source raises them:
/// Validation timing, Focus on error, Server errors, Resetting. Section
/// shape: a live demo ahead of any heading, then Installation, Usage, the
/// four sections above, then API Reference, then this package's own six
/// trailing sections (States, Accessibility, Responsive, Dependencies,
/// Theming, Source).
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/docs_code.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../kit.dart';
import '../catalog.dart';
import 'meta.dart';

class FormDocPage extends StatelessWidget {
  const FormDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) {
    final ComponentDocEntry entry = formDoc;
    return DocsLayout(
      route: entry.route,
      intro: DocsPageIntro(
        eyebrow: 'COMPONENTS / BASE',
        title: entry.title,
        description: entry.description,
      ),
      breadcrumbs: const <ElBreadcrumbEntry>[
        ElBreadcrumbEntry.link('Components'),
        ElBreadcrumbEntry.page('Form'),
      ],
      toc: const <DocsTocEntry>[
        DocsTocEntry(title: 'Installation', anchor: 'install'),
        DocsTocEntry(title: 'Usage', anchor: 'usage'),
        DocsTocEntry(title: 'Validation timing', anchor: 'validation-timing'),
        DocsTocEntry(title: 'Focus on error', anchor: 'focus-on-error'),
        DocsTocEntry(title: 'Server errors', anchor: 'server-errors'),
        DocsTocEntry(title: 'Resetting', anchor: 'resetting'),
        DocsTocEntry(
          title: 'API Reference',
          anchor: 'api',
          children: <DocsTocEntry>[
            DocsTocEntry(title: 'ElForm', anchor: 'api-elform'),
            DocsTocEntry(
              title: 'ElFormFieldBase',
              anchor: 'api-elformfieldbase',
            ),
            DocsTocEntry(title: 'ElFormField', anchor: 'api-elformfield'),
            DocsTocEntry(
              title: 'ElTextFormField',
              anchor: 'api-eltextformfield',
            ),
            DocsTocEntry(title: 'ElValidateMode', anchor: 'api-elvalidatemode'),
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
      child: _FormArticle(entry: entry),
    );
  }
}

class _FormArticle extends StatelessWidget {
  const _FormArticle({required this.entry});

  final ComponentDocEntry entry;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      key: const ValueKey<String>('form-doc-article'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DocsCodeExample(
          title: 'Live specimen',
          description:
              'A ElForm with one field and a submit button, bound with '
              'ListenableBuilder. ElForm paints nothing itself: every pixel '
              'here comes from ElField and ElInput reading the form\'s '
              'state on each rebuild.',
          preview: const _FormPreview(),
          command: DocsCodeCommand(command: entry.command),
        ),
        SizedBox(height: el(8)),
        ElSection(
          id: 'install',
          title: 'Installation',
          description:
              'Install with elattar add form, or import from the package barrel when you depend on the package directly.',
          child: DocsCodeExample(
            title: 'Package import',
            command: DocsCodeCommand(
              command: entry.command,
              description:
                  'Import ElForm from the public barrel: no CLI command '
                  'yet.',
            ),
            manualFiles: const <DocsCodeFile>[
              DocsCodeFile(
                path: 'lib/form.dart',
                code:
                    "import 'package:elattar_design_system/"
                    "elattar_design_system.dart';\n\n"
                    '// Install with `elattar add form`, or import from the package barrel when you depend on the package directly.',
              ),
            ],
          ),
        ),
        ElSection(
          id: 'usage',
          title: 'Usage',
          description:
              'ElForm is not a widget: it is a ChangeNotifier a page '
              'listens to with ListenableBuilder, passing each field\'s own '
              'state into a ElField.',
          child: ElPanel(
            label: 'DART',
            note: 'MINIMAL',
            child: DocsSelectableCodeBlock(code: _usageCode),
          ),
        ),
        ElSection(
          id: 'validation-timing',
          title: 'Validation timing',
          description:
              'mode decides when the FIRST validation ask happens (default '
              'onSubmit: a field stays silent until the form is submitted '
              'once). reValidateMode takes over after that first submit '
              '(default onChange: every keystroke re-validates once the '
              'form has failed once). Nothing here validates on blur — '
              'ElValidateMode has two members and not four.',
          child: DocsCodeExample(
            title: 'onSubmit, then onChange',
            preview: const _ValidationTimingPreview(),
            manualFiles: const <DocsCodeFile>[
              DocsCodeFile(
                path: 'validation_timing.dart',
                code: _validationTimingCode,
              ),
            ],
          ),
        ),
        ElSection(
          id: 'focus-on-error',
          title: 'Focus on error',
          description:
              'A failed submit calls focusFirstError(), which focuses the '
              'first invalid field in registration order — whatever type '
              'it is. This is a deliberate behavioural fix over the '
              'reference (ruling F4): react-hook-form\'s shouldFocusError '
              'only reaches a field whose ref exposes .focus(), which is a '
              'no-op for a hand-wired control; ElForm.focusFirstError has '
              'no such gap.',
          child: DocsCodeExample(
            title: 'Submit empty and watch focus move',
            preview: const _FocusOnErrorPreview(),
            manualFiles: const <DocsCodeFile>[
              DocsCodeFile(
                path: 'focus_on_error.dart',
                code: _focusOnErrorCode,
              ),
            ],
          ),
        ),
        ElSection(
          id: 'server-errors',
          title: 'Server errors',
          description:
              'setError(name, message) stores a message no rule produced — '
              'the round-trip-from-the-server path — and deliberately does '
              'NOT focus the field: a response arriving after the reader '
              'has moved on should not yank focus out from under them. The '
              'next edit clears it, because re-validation overwrites '
              'whatever is stored.',
          child: DocsCodeExample(
            title: 'Simulate a server rejection',
            preview: const _ServerErrorPreview(),
            manualFiles: const <DocsCodeFile>[
              DocsCodeFile(path: 'server_error.dart', code: _serverErrorCode),
            ],
          ),
        ),
        ElSection(
          id: 'resetting',
          title: 'Resetting',
          description:
              'reset() returns every field to its own initialValue, clears '
              'every message, and zeroes submitCount — so mode governs '
              'validation again from the start, exactly as if the form had '
              'never been touched.',
          child: DocsCodeExample(
            title: 'Edit, submit, then reset',
            preview: const _ResetPreview(),
            manualFiles: const <DocsCodeFile>[
              DocsCodeFile(path: 'reset.dart', code: _resetCode),
            ],
          ),
        ),
        ElSection(
          id: 'api',
          title: 'API Reference',
          description:
              'Every constructor parameter and public member ElForm, '
              'ElFormFieldBase, ElFormField, ElTextFormField, and '
              'ElValidateMode each declare.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              KeyedSubtree(
                key: docsAnchorKey('api-elform'),
                child: const DocsApiTable(
                  title: 'ElForm',
                  facts: <DocsApiFact>[
                    DocsApiFact(
                      name: 'fields',
                      type: 'List<ElFormFieldBase>',
                      description:
                          'Required. Registration order — the order '
                          'focusFirstError walks.',
                    ),
                    DocsApiFact(
                      name: 'mode',
                      type: 'ElValidateMode',
                      description:
                          'Optional. Defaults to ElValidateMode.onSubmit. '
                          'When the first validation ask happens.',
                    ),
                    DocsApiFact(
                      name: 'reValidateMode',
                      type: 'ElValidateMode',
                      description:
                          'Optional. Defaults to ElValidateMode.onChange. '
                          'Asked again after the first failed submit.',
                    ),
                    DocsApiFact(
                      name: 'operator [](name)',
                      type: 'ElFormFieldBase',
                      description:
                          'The field named name, or a thrown StateError '
                          'naming what is declared.',
                    ),
                    DocsApiFact(
                      name: 'field<T>(name)',
                      type: 'ElFormField<T>',
                      description: 'name as its typed self.',
                    ),
                    DocsApiFact(
                      name: 'text(name)',
                      type: 'ElTextFormField',
                      description:
                          'The text field named name, for its controller.',
                    ),
                    DocsApiFact(
                      name: 'validate()',
                      type: 'bool',
                      description:
                          'Runs every field\'s rules and stores the '
                          'messages. Returns whether the whole form passed.',
                    ),
                    DocsApiFact(
                      name: 'focusFirstError()',
                      type: 'void',
                      description:
                          'Focuses the first invalid field in registration '
                          'order. See Focus on error above.',
                    ),
                    DocsApiFact(
                      name: 'submit([onValid])',
                      type:
                          'Future<bool> Function([FutureOr<void> '
                          'Function()?])',
                      description:
                          'Validates, focuses the first error, and stops on '
                          'failure; otherwise runs onValid with '
                          'isSubmitting held true for its duration.',
                    ),
                    DocsApiFact(
                      name: 'setError(name, message)',
                      type: 'void',
                      description:
                          'Stores a message no rule produced. Does not '
                          'focus. See Server errors above.',
                    ),
                    DocsApiFact(
                      name: 'clearErrors()',
                      type: 'void',
                      description:
                          'Clears every message without touching '
                          'the values.',
                    ),
                    DocsApiFact(
                      name: 'reset()',
                      type: 'void',
                      description:
                          'Back to initialValue on every field, no '
                          'messages, submitCount zeroed. See Resetting '
                          'above.',
                    ),
                    DocsApiFact(
                      name: 'isValid',
                      type: 'bool (get)',
                      description:
                          'true if every field.invalid is false: computed '
                          'from what is currently stored, not re-asked.',
                    ),
                    DocsApiFact(
                      name: 'isSubmitting',
                      type: 'bool (get)',
                      description: 'true while submit\'s onValid runs.',
                    ),
                    DocsApiFact(
                      name: 'submitCount',
                      type: 'int (get)',
                      description:
                          'How many times submit has run: mode governs '
                          'edits before this is 0, reValidateMode governs '
                          'them afterwards.',
                    ),
                  ],
                ),
              ),
              SizedBox(height: el(6)),
              KeyedSubtree(
                key: docsAnchorKey('api-elformfieldbase'),
                child: const DocsApiTable(
                  title: 'ElFormFieldBase',
                  facts: <DocsApiFact>[
                    DocsApiFact(
                      name: 'name',
                      type: 'String',
                      description: 'Required. The schema key.',
                    ),
                    DocsApiFact(
                      name: 'focusNode',
                      type: 'FocusNode (get)',
                      description:
                          'Owned and disposed by the field itself: the node '
                          'a failed submit lands on, and the one a '
                          'ElFieldLabel focuses.',
                    ),
                    DocsApiFact(
                      name: 'errors',
                      type: 'List<String> (get)',
                      description:
                          'What FieldError renders. Empty means valid.',
                    ),
                    DocsApiFact(
                      name: 'invalid',
                      type: 'bool (get)',
                      description: 'True when errors is not empty.',
                    ),
                    DocsApiFact(
                      name: 'rawValue',
                      type: 'Object? (get)',
                      description:
                          'The value, for the map a successful '
                          'submit hands back.',
                    ),
                    DocsApiFact(
                      name: 'issues()',
                      type: 'List<String>',
                      description:
                          'The messages the rules raise against the '
                          'current value, without storing them.',
                    ),
                    DocsApiFact(
                      name: 'validate()',
                      type: 'bool',
                      description:
                          'Runs issues() and stores the result. Returns '
                          'whether the field passed.',
                    ),
                    DocsApiFact(
                      name: 'setErrors(messages)',
                      type: 'void',
                      description:
                          'Replaces the messages without consulting the '
                          'rules: the server-error path.',
                    ),
                    DocsApiFact(
                      name: 'reset()',
                      type: 'void',
                      description:
                          'Back to the declared default, with no '
                          'messages.',
                    ),
                  ],
                ),
              ),
              SizedBox(height: el(6)),
              KeyedSubtree(
                key: docsAnchorKey('api-elformfield'),
                child: const DocsApiTable(
                  title: 'ElFormField<T>',
                  facts: <DocsApiFact>[
                    DocsApiFact(
                      name: 'name',
                      type: 'String',
                      description: 'Required (inherited). The schema key.',
                    ),
                    DocsApiFact(
                      name: 'initialValue',
                      type: 'T',
                      description:
                          'Required. The seed value and reset() target.',
                    ),
                    DocsApiFact(
                      name: 'rules',
                      type: 'List<ElRule<T>>?',
                      description:
                          'Optional. Defaults to an empty list. Evaluated '
                          'in declaration order, every check run without '
                          'aborting early.',
                    ),
                    DocsApiFact(
                      name: 'issueMode',
                      type: 'ElIssueMode',
                      description:
                          'Optional. Defaults to ElIssueMode.first. first '
                          'truncates to one message; all keeps every one.',
                    ),
                    DocsApiFact(
                      name: 'value',
                      type: 'T (get/set)',
                      description:
                          'The current value. Setting it notifies '
                          'listeners and the enclosing ElForm\'s re-'
                          'validation hook.',
                    ),
                  ],
                ),
              ),
              SizedBox(height: el(6)),
              KeyedSubtree(
                key: docsAnchorKey('api-eltextformfield'),
                child: const DocsApiTable(
                  title: 'ElTextFormField',
                  facts: <DocsApiFact>[
                    DocsApiFact(
                      name: 'name',
                      type: 'String',
                      description: 'Required (inherited). The schema key.',
                    ),
                    DocsApiFact(
                      name: 'initialValue',
                      type: 'String',
                      description: 'Optional. Defaults to \'\'.',
                    ),
                    DocsApiFact(
                      name: 'rules',
                      type: 'List<ElRule<String>>?',
                      description: 'Optional (inherited).',
                    ),
                    DocsApiFact(
                      name: 'issueMode',
                      type: 'ElIssueMode',
                      description: 'Optional (inherited).',
                    ),
                    DocsApiFact(
                      name: 'controller',
                      type: 'TextEditingController (get)',
                      description:
                          'Owned by the field, kept in step with value: '
                          'hand this to ElInput.controller / '
                          'ElTextarea.controller.',
                    ),
                  ],
                ),
              ),
              SizedBox(height: el(6)),
              KeyedSubtree(
                key: docsAnchorKey('api-elvalidatemode'),
                child: const DocsApiTable(
                  title: 'ElValidateMode',
                  facts: <DocsApiFact>[
                    DocsApiFact(
                      name: 'onSubmit',
                      type: 'enum value',
                      description:
                          'The question is asked when submit() is called.',
                    ),
                    DocsApiFact(
                      name: 'onChange',
                      type: 'enum value',
                      description: 'Asked on every field edit.',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        ElSection(
          id: 'states',
          title: 'States',
          description:
              'ElForm has no paint of its own, so its "states" are the '
              'observable properties a bound page reads on each rebuild.',
          child: const DocsStateMatrix(
            facts: <DocsStateFact>[
              DocsStateFact(
                state: 'Pristine',
                treatment:
                    'submitCount is 0; every field\'s errors is empty; '
                    'mode has not yet been consulted (edits validate only '
                    'if mode is onChange).',
                userSignal: 'No error text anywhere; a blank or seeded form.',
              ),
              DocsStateFact(
                state: 'Submitting',
                treatment:
                    'isSubmitting is true for the duration of submit\'s '
                    'onValid callback; what ElButton.loading reads.',
                userSignal: 'A submit button shows its spinner and disables.',
              ),
              DocsStateFact(
                state: 'Invalid after submit',
                treatment:
                    'submitCount > 0 and at least one field.invalid is '
                    'true; reValidateMode now governs further edits.',
                userSignal:
                    'Errors render under the failing fields; focus has '
                    'moved to the first of them.',
              ),
              DocsStateFact(
                state: 'Server error',
                treatment:
                    'setError stored a message no rule produced; the next '
                    'edit to that field clears it via re-validation.',
                userSignal: 'An error appears with no focus change.',
              ),
              DocsStateFact(
                state: 'Reset',
                treatment:
                    'Every field back to initialValue, no messages, '
                    'submitCount zeroed.',
                userSignal: 'The form reads exactly as it did on first mount.',
              ),
            ],
          ),
        ),
        ElSection(
          id: 'accessibility',
          title: 'Accessibility',
          description: 'The contract a bound page inherits.',
          child: ElPanel(
            label: 'ElForm contract',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const _A11yRow(
                  'Non-visual',
                  'ElForm paints nothing: bind it with ListenableBuilder '
                      'and read field.invalid and field.errors to drive '
                      'your own UI.',
                ),
                const _A11yRow(
                  'Field focus',
                  'focusFirstError() focuses the first invalid field in '
                      'registration order: any field type, not just text '
                      'inputs — see Focus on error above.',
                ),
                _A11yRow(
                  'Announcements',
                  'Managed by ElField and ElFieldError around the '
                      'controls; ElForm itself neither reads nor announces.',
                  last: true,
                ),
              ],
            ),
          ),
        ),
        ElSection(
          id: 'responsive',
          title: 'Responsive',
          child: _bullets(theme, <String>[
            'ElForm reads no MediaQuery and responds identically at 390px '
                'and 1440px: the form state machine is viewport-agnostic.',
            'Keyboard activation (Tab, Enter) and pointer activation '
                '(tap) reach the same submit() call on every Flutter '
                'target.',
          ]),
        ),
        ElSection(
          id: 'dependencies',
          title: 'Dependencies',
          description: 'What this component needs to install and run.',
          child: DocsInstallFacts(
            facts: <DocsInstallFact>[
              const DocsInstallFact(
                label: 'Registry item',
                value: 'registry/components/form.json',
                description: 'Shipped and resolved by `elattar add form`.',
              ),
              const DocsInstallFact(
                label: 'Source file',
                value: 'form.dart',
                description:
                    'lib/src/components/form.dart, exported from the '
                    'public barrel.',
              ),
              const DocsInstallFact(
                label: 'Dependencies',
                value: 'rule',
                description:
                    'ElFormField.rules is a List<ElRule<T>>, checked by '
                    'ElRules.check (rule.dart) — dependency-free, no '
                    'schema library.',
              ),
              const DocsInstallFact(
                label: 'Platforms',
                value: 'Android, iOS, Web, macOS, Windows, Linux',
                description: 'Pure Dart state; nothing platform-gated.',
              ),
              const DocsInstallFact(
                label: 'Verified',
                value: 'package tests + this docs specimen',
                description:
                    'test/form_test.dart and '
                    'example/test/components_docs/form_test.dart.',
              ),
            ],
          ),
        ),
        ElSection(
          id: 'theming',
          title: 'Theming',
          child: ElPanel(
            label: 'What varies with the theme',
            child: ElText(
              'ElForm paints nothing and reads no theme. Every colour on '
              'this page comes from the ElField/ElInput/ElButton controls '
              'a bound page composes around it.',
              ElType.small,
            ),
          ),
        ),
        ElSection(
          id: 'source',
          title: 'Source',
          child: DocsInstallFacts(
            title: 'Source and tests',
            facts: const <DocsInstallFact>[
              DocsInstallFact(
                label: 'Source',
                value: 'lib/src/components/form.dart',
                description: 'The one source file.',
              ),
              DocsInstallFact(
                label: 'Package tests',
                value: 'test/form_test.dart',
                description: 'Tests for the form state machine.',
              ),
              DocsInstallFact(
                label: 'Docs specimen',
                value: 'example/test/components_docs/form_test.dart',
                description:
                    'This page\'s own live preview, API-completeness '
                    'check, and theme coverage.',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Widget _bullets(ElThemeData theme, List<String> lines) => ConstrainedBox(
  constraints: const BoxConstraints(maxWidth: ElWidths.prose),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      for (final String line in lines) ...<Widget>[
        ElText('•  $line', ElType.small, color: theme.mutedForeground),
        SizedBox(height: el(2)),
      ],
    ],
  ),
);

class _A11yRow extends StatelessWidget {
  const _A11yRow(this.label, this.body, {this.last = false});

  final String label;
  final String body;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : el(3)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ElText(label, ElType.section, color: theme.actionInk),
          SizedBox(height: el(1)),
          ElText(body, ElType.small),
        ],
      ),
    );
  }
}

const String _usageCode = '''final ElForm form = ElForm(
  fields: <ElFormFieldBase>[
    ElTextFormField(
      name: 'email',
      rules: <ElRule<String>>[
        ElRule.email('That is not a valid email address.'),
      ],
    ),
  ],
);

ListenableBuilder(
  listenable: form,
  builder: (BuildContext context, Widget? _) => Column(
    children: <Widget>[
      ElField(
        label: 'Email',
        errors: form.field<String>('email').errors,
        focusNode: form['email'].focusNode,
        child: ElInput(controller: form.text('email').controller),
      ),
      ElButton(
        onPressed: form.isSubmitting ? null : () => form.submit(),
        child: const Text('Submit'),
      ),
    ],
  ),
)''';

const String _validationTimingCode = '''ElForm(
  fields: <ElFormFieldBase>[
    ElTextFormField(
      name: 'handle',
      rules: <ElRule<String>>[ElRule.minLength(3, 'At least 3 characters.')],
    ),
  ],
  // The defaults, spelled out:
  mode: ElValidateMode.onSubmit,
  reValidateMode: ElValidateMode.onChange,
)''';

const String _focusOnErrorCode = '''final ElForm form = ElForm(
  fields: <ElFormFieldBase>[
    ElTextFormField(name: 'name', rules: <ElRule<String>>[
      ElRule.minLength(1, 'Required.'),
    ]),
    ElTextFormField(name: 'email', rules: <ElRule<String>>[
      ElRule.email('That is not a valid email address.'),
    ]),
  ],
);

// A failed submit focuses 'name' first: it is registered before 'email'.
await form.submit();''';

const String _serverErrorCode =
    '''// A response comes back after the reader has moved on: setError does
// NOT pull focus back to the field.
form.setError('handle', 'This handle is already taken.');''';

const String _resetCode =
    '''// Back to initialValue on every field, no messages, submitCount zeroed.
form.reset();''';

class _FormPreview extends StatefulWidget {
  const _FormPreview();

  @override
  State<_FormPreview> createState() => _FormPreviewState();
}

class _FormPreviewState extends State<_FormPreview> {
  late final ElForm _form;

  @override
  void initState() {
    super.initState();
    _form = ElForm(
      fields: <ElFormFieldBase>[
        ElTextFormField(
          name: 'handle',
          rules: <ElRule<String>>[
            ElRule.minLength(3, 'At least 3 characters.'),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return ListenableBuilder(
      listenable: _form,
      builder: (BuildContext context, Widget? _) => ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: ElContainers.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ElField(
              key: const ValueKey<String>('form-preview-field'),
              label: 'Handle',
              errors: _form.field<String>('handle').errors,
              focusNode: _form['handle'].focusNode,
              child: ElInput(
                controller: _form.text('handle').controller,
                placeholder: 'yourname',
              ),
            ),
            SizedBox(height: el(3)),
            ElText(
              'isValid: ${_form.isValid}, isSubmitting: '
              '${_form.isSubmitting}, submitCount: ${_form.submitCount}',
              ElType.small,
              color: theme.mutedForeground,
            ),
            SizedBox(height: el(3)),
            ElButton(
              key: const ValueKey<String>('form-preview-submit'),
              onPressed: _form.isSubmitting ? null : () => _form.submit(),
              loading: _form.isSubmitting,
              child: ElText('Submit', ElComponentType.buttonLabel),
            ),
          ],
        ),
      ),
    );
  }
}

class _ValidationTimingPreview extends StatefulWidget {
  const _ValidationTimingPreview();

  @override
  State<_ValidationTimingPreview> createState() =>
      _ValidationTimingPreviewState();
}

class _ValidationTimingPreviewState extends State<_ValidationTimingPreview> {
  late final ElForm _form;

  @override
  void initState() {
    super.initState();
    _form = ElForm(
      fields: <ElFormFieldBase>[
        ElTextFormField(
          name: 'handle',
          rules: <ElRule<String>>[
            ElRule.minLength(3, 'At least 3 characters.'),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return ListenableBuilder(
      listenable: _form,
      builder: (BuildContext context, Widget? _) => ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: ElContainers.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ElField(
              key: const ValueKey<String>('form-validation-timing-field'),
              label: 'Handle',
              errors: _form.field<String>('handle').errors,
              focusNode: _form['handle'].focusNode,
              child: ElInput(controller: _form.text('handle').controller),
            ),
            SizedBox(height: el(3)),
            ElText(
              _form.submitCount == 0
                  ? 'submitCount: 0 — edits are not validated yet.'
                  : 'submitCount: ${_form.submitCount} — every edit now '
                        're-validates.',
              ElType.small,
              color: theme.mutedForeground,
            ),
            SizedBox(height: el(3)),
            ElButton(
              key: const ValueKey<String>('form-validation-timing-submit'),
              onPressed: () => _form.submit(),
              child: ElText('Submit', ElComponentType.buttonLabel),
            ),
          ],
        ),
      ),
    );
  }
}

class _FocusOnErrorPreview extends StatefulWidget {
  const _FocusOnErrorPreview();

  @override
  State<_FocusOnErrorPreview> createState() => _FocusOnErrorPreviewState();
}

class _FocusOnErrorPreviewState extends State<_FocusOnErrorPreview> {
  late final ElForm _form;
  String _focused = 'none';

  @override
  void initState() {
    super.initState();
    _form = ElForm(
      fields: <ElFormFieldBase>[
        ElTextFormField(
          name: 'name',
          rules: <ElRule<String>>[ElRule.minLength(1, 'Required.')],
        ),
        ElTextFormField(
          name: 'email',
          rules: <ElRule<String>>[
            ElRule.email('That is not a valid email address.'),
          ],
        ),
      ],
    );
    _form['name'].focusNode.addListener(() => _onFocusChange('name'));
    _form['email'].focusNode.addListener(() => _onFocusChange('email'));
  }

  void _onFocusChange(String name) {
    if (!_form[name].focusNode.hasFocus) return;
    setState(() => _focused = name);
  }

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return ListenableBuilder(
      listenable: _form,
      builder: (BuildContext context, Widget? _) => ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: ElContainers.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ElField(
              key: const ValueKey<String>('form-focus-name-field'),
              label: 'Name',
              errors: _form.field<String>('name').errors,
              focusNode: _form['name'].focusNode,
              child: ElInput(controller: _form.text('name').controller),
            ),
            SizedBox(height: el(3)),
            ElField(
              key: const ValueKey<String>('form-focus-email-field'),
              label: 'Email',
              errors: _form.field<String>('email').errors,
              focusNode: _form['email'].focusNode,
              child: ElInput(controller: _form.text('email').controller),
            ),
            SizedBox(height: el(3)),
            ElText(
              'Focused field: $_focused',
              ElType.small,
              color: theme.mutedForeground,
            ),
            SizedBox(height: el(3)),
            ElButton(
              key: const ValueKey<String>('form-focus-submit'),
              onPressed: () => _form.submit(),
              child: ElText('Submit empty', ElComponentType.buttonLabel),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServerErrorPreview extends StatefulWidget {
  const _ServerErrorPreview();

  @override
  State<_ServerErrorPreview> createState() => _ServerErrorPreviewState();
}

class _ServerErrorPreviewState extends State<_ServerErrorPreview> {
  late final ElForm _form;

  @override
  void initState() {
    super.initState();
    _form = ElForm(
      fields: <ElFormFieldBase>[
        ElTextFormField(name: 'handle', initialValue: 'shadcn'),
      ],
    );
  }

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _form,
    builder: (BuildContext context, Widget? _) => ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: ElContainers.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ElField(
            key: const ValueKey<String>('form-server-error-field'),
            label: 'Handle',
            errors: _form.field<String>('handle').errors,
            focusNode: _form['handle'].focusNode,
            child: ElInput(controller: _form.text('handle').controller),
          ),
          SizedBox(height: el(3)),
          ElButton(
            key: const ValueKey<String>('form-server-error-trigger'),
            variant: ElButtonVariant.destructive,
            onPressed: () =>
                _form.setError('handle', 'This handle is already taken.'),
            child: ElText('Simulate server error', ElComponentType.buttonLabel),
          ),
        ],
      ),
    ),
  );
}

class _ResetPreview extends StatefulWidget {
  const _ResetPreview();

  @override
  State<_ResetPreview> createState() => _ResetPreviewState();
}

class _ResetPreviewState extends State<_ResetPreview> {
  late final ElForm _form;

  @override
  void initState() {
    super.initState();
    _form = ElForm(
      fields: <ElFormFieldBase>[
        ElTextFormField(
          name: 'handle',
          initialValue: 'shadcn',
          rules: <ElRule<String>>[
            ElRule.minLength(3, 'At least 3 characters.'),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _form,
    builder: (BuildContext context, Widget? _) => ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: ElContainers.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ElField(
            key: const ValueKey<String>('form-reset-field'),
            label: 'Handle',
            errors: _form.field<String>('handle').errors,
            focusNode: _form['handle'].focusNode,
            child: ElInput(controller: _form.text('handle').controller),
          ),
          SizedBox(height: el(3)),
          Wrap(
            spacing: el(2),
            children: <Widget>[
              ElButton(
                key: const ValueKey<String>('form-reset-submit'),
                onPressed: () => _form.submit(),
                child: ElText('Submit', ElComponentType.buttonLabel),
              ),
              ElButton(
                key: const ValueKey<String>('form-reset-trigger'),
                variant: ElButtonVariant.outline,
                onPressed: _form.reset,
                child: ElText('Reset', ElComponentType.buttonLabel),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
