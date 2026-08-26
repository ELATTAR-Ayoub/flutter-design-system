/// Public documentation page for the `form` component.
///
/// **Re-housed onto the kit.** This page used to hand-compose `ElSection`
/// panels; it now declares a `ComponentDocSpec`
/// (`example/lib/docs/component_doc_page.dart`) and hands it to
/// `ComponentDocPage`, the same shape `button` established. Every specimen
/// widget and every code string below is the same one the hand-composed page
/// carried; only where it lives changed.
///
/// **form** documents [ElForm], [ElFormFieldBase], [ElFormField],
/// [ElTextFormField], and [ElValidateMode].
/// `https://ui.shadcn.com/docs/components/form` is a "pick your framework"
/// gateway page with no props, no API, and no component sections at all, so
/// this page's own sections are named for the reader problems `form.dart`'s
/// own source actually solves, in the order that source raises them:
/// Validation timing, Focus on error, Server errors, Resetting.
///
/// **Section order**, matching `button`'s own house shape: Preview,
/// Installation, Usage, then the four reader-problem sections above (each
/// its own live `ShowcaseSection`, not a code-only panel — every one of
/// them already had a real, bound `ElForm` behind it), then the eight
/// disclosures. New: a Keyboard disclosure, between Accessibility and
/// Responsive — `ElForm` owns no widget tree and wires no key handler of
/// its own, so this section is mostly about what does NOT happen, same as
/// `field`'s.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/component_doc_page.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../docs/docs_section.dart' show DocsAnchor;
import 'meta.dart';

final ComponentDocSpec formDocSpec = ComponentDocSpec(
  name: 'form',
  title: formDoc.title,
  description: formDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'A ElForm with one field and a submit button, bound with '
          'ListenableBuilder. ElForm paints nothing itself: every pixel '
          'here comes from ElField and ElInput reading the form\'s state '
          'on each rebuild.',
      specimen: _PreviewSpecimen(),
      code: _usageCode,
      label: 'Preview specimen view',
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'Install with elattar add form, or import from the package '
          'barrel when you depend on the package directly.',
      command: formDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/form.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/form.dart's generated @ui/"
              'form.dart payload into components/ui.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated form source here when using manual '
              'mode.',
        ),
        const DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so ElForm and its field types are '
              'reachable the same way the CLI path already makes them.',
          code: "export 'form.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'ElForm is not a widget: it is a ChangeNotifier a page listens '
          'to with ListenableBuilder, passing each field\'s own state into '
          'a ElField.',
      code: _usageCode,
    ),
    ShowcaseSection(
      id: 'validation-timing',
      title: 'Validation timing',
      description:
          'mode decides when the FIRST validation ask happens (default '
          'onSubmit: a field stays silent until the form is submitted '
          'once). reValidateMode takes over after that first submit '
          '(default onChange: every keystroke re-validates once the form '
          'has failed once). Nothing here validates on blur — '
          'ElValidateMode has two members and not four.',
      specimen: _ValidationTimingSpecimen(),
      code: _validationTimingCode,
      label: 'Validation timing specimen view',
    ),
    ShowcaseSection(
      id: 'focus-on-error',
      title: 'Focus on error',
      description:
          'A failed submit calls focusFirstError(), which focuses the '
          'first invalid field in registration order — whatever type it '
          'is. This is a deliberate behavioural fix over the reference '
          '(ruling F4): react-hook-form\'s shouldFocusError only reaches a '
          'field whose ref exposes .focus(), which is a no-op for a '
          'hand-wired control; ElForm.focusFirstError has no such gap.',
      specimen: _FocusOnErrorSpecimen(),
      code: _focusOnErrorCode,
      label: 'Focus on error specimen view',
    ),
    ShowcaseSection(
      id: 'server-errors',
      title: 'Server errors',
      description:
          'setError(name, message) stores a message no rule produced — '
          'the round-trip-from-the-server path — and deliberately does '
          'NOT focus the field: a response arriving after the reader has '
          'moved on should not yank focus out from under them. The next '
          'edit clears it, because re-validation overwrites whatever is '
          'stored.',
      specimen: _ServerErrorSpecimen(),
      code: _serverErrorCode,
      label: 'Server errors specimen view',
    ),
    ShowcaseSection(
      id: 'resetting',
      title: 'Resetting',
      description:
          'reset() returns every field to its own initialValue, clears '
          'every message, and zeroes submitCount — so mode governs '
          'validation again from the start, exactly as if the form had '
          'never been touched.',
      specimen: _ResetSpecimen(),
      code: _resetCode,
      label: 'Resetting specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every constructor parameter and public member ElForm, '
          'ElFormFieldBase, ElFormField, ElTextFormField, and '
          'ElValidateMode each declare.',
      children: const <DocsTocEntry>[
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
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'ElForm has no paint of its own, so its "states" are the '
          'observable properties a bound page reads on each rebuild.',
      child: DocsStateMatrix(facts: _stateFacts),
    ),
    DisclosureSection(
      id: 'accessibility',
      title: 'Accessibility',
      description: 'The contract a bound page inherits.',
      child: _AccessibilityContent(),
    ),
    DisclosureSection(
      id: 'keyboard',
      title: 'Keyboard',
      description:
          'ElForm owns no widget tree and wires no Focus.onKeyEvent of '
          'its own: the one keyboard-relevant behaviour it owns is '
          'programmatic, not a key listener.',
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
      description: 'What this component needs to install and run.',
      child: _DependenciesContent(),
    ),
    DisclosureSection(
      id: 'theming',
      title: 'Theming',
      child: DocsInstallFacts(
        title: 'What varies with the theme',
        facts: const <DocsInstallFact>[
          DocsInstallFact(
            label: 'None',
            value: 'ElForm paints nothing',
            description:
                'It reads no theme. Every colour on this page comes from '
                'the ElField/ElInput/ElButton controls a bound page '
                'composes around it.',
          ),
        ],
      ),
    ),
    DisclosureSection(
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
                "This page's own live preview, API-completeness check, "
                'and theme coverage.',
          ),
        ],
      ),
    ),
  ],
);

class FormDocPage extends StatelessWidget {
  const FormDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: formDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / BASE',
      title: formDocSpec.title,
      description: formDocSpec.description,
    ),
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Components'),
      ElBreadcrumbEntry.page('Form'),
    ],
    toc: formDocSpec.toc,
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('form-doc-article'),
      child: ComponentDocPage(spec: formDocSpec, header: false),
    ),
  );
}

/* ── Showcase specimens ─────────────────────────────────────────────────── */
// Every one of these five holds a real, bound `ElForm`, so each is a
// `StatefulWidget` that owns and disposes it — the same shape the original
// hand-composed page used, unchanged.

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

class _PreviewSpecimen extends StatefulWidget {
  const _PreviewSpecimen();

  @override
  State<_PreviewSpecimen> createState() => _PreviewSpecimenState();
}

class _PreviewSpecimenState extends State<_PreviewSpecimen> {
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

class _ValidationTimingSpecimen extends StatefulWidget {
  const _ValidationTimingSpecimen();

  @override
  State<_ValidationTimingSpecimen> createState() =>
      _ValidationTimingSpecimenState();
}

class _ValidationTimingSpecimenState
    extends State<_ValidationTimingSpecimen> {
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

class _FocusOnErrorSpecimen extends StatefulWidget {
  const _FocusOnErrorSpecimen();

  @override
  State<_FocusOnErrorSpecimen> createState() => _FocusOnErrorSpecimenState();
}

class _FocusOnErrorSpecimenState extends State<_FocusOnErrorSpecimen> {
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

const String _serverErrorCode =
    '''// A response comes back after the reader has moved on: setError does
// NOT pull focus back to the field.
form.setError('handle', 'This handle is already taken.');''';

class _ServerErrorSpecimen extends StatefulWidget {
  const _ServerErrorSpecimen();

  @override
  State<_ServerErrorSpecimen> createState() => _ServerErrorSpecimenState();
}

class _ServerErrorSpecimenState extends State<_ServerErrorSpecimen> {
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
            child: ElText(
              'Simulate server error',
              ElComponentType.buttonLabel,
            ),
          ),
        ],
      ),
    ),
  );
}

const String _resetCode =
    '''// Back to initialValue on every field, no messages, submitCount zeroed.
form.reset();''';

class _ResetSpecimen extends StatefulWidget {
  const _ResetSpecimen();

  @override
  State<_ResetSpecimen> createState() => _ResetSpecimenState();
}

class _ResetSpecimenState extends State<_ResetSpecimen> {
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

/* ── Disclosure content ─────────────────────────────────────────────────── */

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsAnchor(
        id: 'api-elform',
        child: DocsApiTable(title: 'ElForm', facts: _elFormFacts),
      ),
      SizedBox(height: el(6)),
      const DocsAnchor(
        id: 'api-elformfieldbase',
        child: DocsApiTable(
          title: 'ElFormFieldBase',
          facts: _elFormFieldBaseFacts,
        ),
      ),
      SizedBox(height: el(6)),
      const DocsAnchor(
        id: 'api-elformfield',
        child: DocsApiTable(title: 'ElFormField<T>', facts: _elFormFieldFacts),
      ),
      SizedBox(height: el(6)),
      const DocsAnchor(
        id: 'api-eltextformfield',
        child: DocsApiTable(
          title: 'ElTextFormField',
          facts: _elTextFormFieldFacts,
        ),
      ),
      SizedBox(height: el(6)),
      const DocsAnchor(
        id: 'api-elvalidatemode',
        child: DocsApiTable(
          title: 'ElValidateMode',
          facts: _elValidateModeFacts,
        ),
      ),
    ],
  );
}

const List<DocsApiFact> _elFormFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'fields',
    type: 'List<ElFormFieldBase>',
    description:
        'Required. Registration order — the order focusFirstError walks.',
  ),
  DocsApiFact(
    name: 'mode',
    type: 'ElValidateMode',
    description:
        'Optional. Defaults to ElValidateMode.onSubmit. When the first '
        'validation ask happens.',
  ),
  DocsApiFact(
    name: 'reValidateMode',
    type: 'ElValidateMode',
    description:
        'Optional. Defaults to ElValidateMode.onChange. Asked again '
        'after the first failed submit.',
  ),
  DocsApiFact(
    name: 'operator [](name)',
    type: 'ElFormFieldBase',
    description:
        'The field named name, or a thrown StateError naming what is '
        'declared.',
  ),
  DocsApiFact(
    name: 'field<T>(name)',
    type: 'ElFormField<T>',
    description: 'name as its typed self.',
  ),
  DocsApiFact(
    name: 'text(name)',
    type: 'ElTextFormField',
    description: 'The text field named name, for its controller.',
  ),
  DocsApiFact(
    name: 'validate()',
    type: 'bool',
    description:
        'Runs every field\'s rules and stores the messages. Returns '
        'whether the whole form passed.',
  ),
  DocsApiFact(
    name: 'focusFirstError()',
    type: 'void',
    description:
        'Focuses the first invalid field in registration order. See '
        'Focus on error above.',
  ),
  DocsApiFact(
    name: 'submit([onValid])',
    type: 'Future<bool> Function([FutureOr<void> Function()?])',
    description:
        'Validates, focuses the first error, and stops on failure; '
        'otherwise runs onValid with isSubmitting held true for its '
        'duration.',
  ),
  DocsApiFact(
    name: 'setError(name, message)',
    type: 'void',
    description:
        'Stores a message no rule produced. Does not focus. See Server '
        'errors above.',
  ),
  DocsApiFact(
    name: 'clearErrors()',
    type: 'void',
    description: 'Clears every message without touching the values.',
  ),
  DocsApiFact(
    name: 'reset()',
    type: 'void',
    description:
        'Back to initialValue on every field, no messages, submitCount '
        'zeroed. See Resetting above.',
  ),
  DocsApiFact(
    name: 'isValid',
    type: 'bool (get)',
    description:
        'true if every field.invalid is false: computed from what is '
        'currently stored, not re-asked.',
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
        'How many times submit has run: mode governs edits before this '
        'is 0, reValidateMode governs them afterwards.',
  ),
];

const List<DocsApiFact> _elFormFieldBaseFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'name',
    type: 'String',
    description: 'Required. The schema key.',
  ),
  DocsApiFact(
    name: 'focusNode',
    type: 'FocusNode (get)',
    description:
        'Owned and disposed by the field itself: the node a failed '
        'submit lands on, and the one a ElFieldLabel focuses.',
  ),
  DocsApiFact(
    name: 'errors',
    type: 'List<String> (get)',
    description: 'What FieldError renders. Empty means valid.',
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
        'The value, for the map a successful submit hands back.',
  ),
  DocsApiFact(
    name: 'issues()',
    type: 'List<String>',
    description:
        'The messages the rules raise against the current value, '
        'without storing them.',
  ),
  DocsApiFact(
    name: 'validate()',
    type: 'bool',
    description: 'Runs issues() and stores the result. Returns whether '
        'the field passed.',
  ),
  DocsApiFact(
    name: 'setErrors(messages)',
    type: 'void',
    description:
        'Replaces the messages without consulting the rules: the '
        'server-error path.',
  ),
  DocsApiFact(
    name: 'reset()',
    type: 'void',
    description: 'Back to the declared default, with no messages.',
  ),
];

const List<DocsApiFact> _elFormFieldFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'name',
    type: 'String',
    description: 'Required (inherited). The schema key.',
  ),
  DocsApiFact(
    name: 'initialValue',
    type: 'T',
    description: 'Required. The seed value and reset() target.',
  ),
  DocsApiFact(
    name: 'rules',
    type: 'List<ElRule<T>>?',
    description:
        'Optional. Defaults to an empty list. Evaluated in declaration '
        'order, every check run without aborting early.',
  ),
  DocsApiFact(
    name: 'issueMode',
    type: 'ElIssueMode',
    description:
        'Optional. Defaults to ElIssueMode.first. first truncates to '
        'one message; all keeps every one.',
  ),
  DocsApiFact(
    name: 'value',
    type: 'T (get/set)',
    description:
        "The current value. Setting it notifies listeners and the "
        "enclosing ElForm's re-validation hook.",
  ),
];

const List<DocsApiFact> _elTextFormFieldFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'name',
    type: 'String',
    description: 'Required (inherited). The schema key.',
  ),
  DocsApiFact(
    name: 'initialValue',
    type: 'String',
    description: "Optional. Defaults to ''.",
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
        'Owned by the field, kept in step with value: hand this to '
        'ElInput.controller / ElTextarea.controller.',
  ),
];

const List<DocsApiFact> _elValidateModeFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'onSubmit',
    type: 'enum value',
    description: 'The question is asked when submit() is called.',
  ),
  DocsApiFact(
    name: 'onChange',
    type: 'enum value',
    description: 'Asked on every field edit.',
  ),
];

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Pristine',
    treatment:
        'submitCount is 0; every field\'s errors is empty; mode has not '
        'yet been consulted (edits validate only if mode is onChange).',
    userSignal: 'No error text anywhere; a blank or seeded form.',
  ),
  DocsStateFact(
    state: 'Submitting',
    treatment:
        'isSubmitting is true for the duration of submit\'s onValid '
        'callback; what ElButton.loading reads.',
    userSignal: 'A submit button shows its spinner and disables.',
  ),
  DocsStateFact(
    state: 'Invalid after submit',
    treatment:
        'submitCount > 0 and at least one field.invalid is true; '
        'reValidateMode now governs further edits.',
    userSignal:
        'Errors render under the failing fields; focus has moved to '
        'the first of them.',
  ),
  DocsStateFact(
    state: 'Server error',
    treatment:
        'setError stored a message no rule produced; the next edit to '
        'that field clears it via re-validation.',
    userSignal: 'An error appears with no focus change.',
  ),
  DocsStateFact(
    state: 'Reset',
    treatment:
        'Every field back to initialValue, no messages, submitCount '
        'zeroed.',
    userSignal: 'The form reads exactly as it did on first mount.',
  ),
];

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) => DocsInstallFacts(
    title: 'ElForm contract',
    facts: const <DocsInstallFact>[
      DocsInstallFact(
        label: 'Non-visual',
        value: 'ElForm paints nothing',
        description:
            'Bind it with ListenableBuilder and read field.invalid and '
            'field.errors to drive your own UI.',
      ),
      DocsInstallFact(
        label: 'Field focus',
        value: 'focusFirstError()',
        description:
            'Focuses the first invalid field in registration order: '
            'any field type, not just text inputs — see Focus on error '
            'above.',
      ),
      DocsInstallFact(
        label: 'Announcements',
        value: 'Delegated to ElField and ElFieldError',
        description:
            'Managed by the controls around it; ElForm itself neither '
            'reads nor announces.',
      ),
    ],
  );
}

/// `ElForm` owns no widget tree, so this section is entirely about the one
/// keyboard-relevant behaviour it does own — `focusFirstError()`, called
/// from `submit()` — read off `lib/src/components/form.dart` directly.
class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'No key handling of its own: form.dart wires no '
            'Focus.onKeyEvent and owns no FocusNode of its own — every '
            'FocusNode belongs to a field (ElFormFieldBase.focusNode), '
            'not to the form.',
        'focusFirstError() is programmatic, not a key listener: submit() '
            'calls it on a failed validate(), and it walks fields in '
            'registration order calling field.focusNode.requestFocus() on '
            'the first invalid one. Nothing here responds to a key press '
            'directly; it responds to the RESULT of one (activating a '
            'Submit button).',
        'Tab order across fields is whatever the bound page\'s own widget '
            'tree declares — usually the same order fields is written in, '
            'since that is also each field\'s registration order, but '
            'form.dart itself reads no FocusTraversalPolicy and enforces '
            'no ordering.',
        'Submit and Reset are ordinary ElButtons in every specimen on '
            'this page: their own Enter/Space activation (see the Button '
            'page\'s Keyboard section) is what triggers submit() or '
            'reset(), not something form.dart adds.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'ElForm reads no MediaQuery and responds identically at 390px '
            'and 1440px: the form state machine is viewport-agnostic.',
        'Keyboard activation (Tab, Enter) and pointer activation (tap) '
            'reach the same submit() call on every Flutter target.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      DocsInstallFacts(
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
                'lib/src/components/form.dart, exported from the public '
                'barrel.',
          ),
          DocsInstallFact(
            label: 'Dependencies',
            value: formDoc.dependencies.join(', '),
            description:
                'ElFormField.rules is a List<ElRule<T>>, checked by '
                'ElRules.check (rule.dart) — dependency-free, no schema '
                'library.',
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
                'test/form_test.dart and example/test/components_docs/'
                'form_test.dart.',
          ),
        ],
      ),
      SizedBox(height: el(4)),
      const DocsLinkRow(
        links: <DocsLink>[
          DocsLink(label: 'Field', route: '/components/field'),
          DocsLink(label: 'Button', route: '/components/button'),
          DocsLink(label: 'Rule', route: '/components/rule'),
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
