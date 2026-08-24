/// `components/ui/form.tsx` — the wiring, with no styling at all.
///
/// The web file is five exports and a hook, and it contributes **zero
/// classes**. What it contributes is an id graph: one `useId()` per `FormField`
/// *instance*, from which three ids are derived, and then the one contract that
/// matters (`form.tsx:130–132`):
///
/// | field state | `aria-describedby` | `aria-invalid` |
/// |---|---|---|
/// | valid | `"{id}-form-item-description"` | `"false"` |
/// | invalid | `"{id}-form-item-description {id}-form-item-message"` | `"true"` |
///
/// **None of that survives the port, and it does not need to.** Flutter has no
/// id graph; the reason `useId()` exists at all — two `AccountForm`s on one
/// page whose ids must not collide — is satisfied by two independent controller
/// objects. So the id half of this file lives in `ElFieldScope` (see
/// `field.dart`, which owns the semantics translation) and what is left here is
/// the state half: values, rules, when the question gets asked, and where focus
/// lands when the answer is no.
///
/// ## When the question gets asked (`forms-map.md` §5.2)
///
/// | form | first ask | thereafter |
/// |---|---|---|
/// | Account ×2 | **submit** | **every keystroke**, from the first failed submit onward |
/// | Password | **first keystroke** (`mode: "onChange"`) | every keystroke |
/// | Server | submit | every keystroke after the first failed submit |
/// | Composed | submit | every change after the first failed submit |
///
/// Nothing on the page validates on **blur** — there is no `mode: "onBlur"` or
/// `"onTouched"` anywhere — so [ElValidateMode] has two members and not four.
///
/// ## Focus-on-error — ruling F4
///
/// RHF runs `handleSubmit` with `shouldFocusError: true`: on a failed submit it
/// walks the registered fields **in registration order** and focuses the first
/// one whose stored ref exposes `.focus()`. A `Controller` only gets a real DOM
/// ref if the call site spreads `{...field}` onto a focusable element — so on
/// the reference it works in the three `Input`/`Textarea` forms and is a
/// **complete no-op in the composed form**, where `plan`, `payout` and `terms`
/// are all hand-wired and all three of them are what fail at defaults
/// (`forms-map.md` §3.4).
///
/// [ElForm.focusFirstError] focuses the first invalid field **whatever it is**.
/// That is a deliberate behavioural fix, flagged for sign-off: an invisible
/// accessibility regression is the one drift class this port does not ship, and
/// a keyboard user submitting the composed form on the reference is left with
/// focus on the button and three errors they were never sent to. The divergence
/// is recorded rather than reproduced.
///
/// `ServerErrorForm`'s manual `form.setError("handle", …)` does **not** focus —
/// `{ shouldFocus: true }` is not passed — and [ElForm.setError] matches that.
library;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'rule.dart';

/// RHF's `mode` / `reValidateMode`, as far as this page reaches them.
enum ElValidateMode {
  /// `"onSubmit"` — the question is asked when the form is submitted.
  onSubmit,

  /// `"onChange"` — asked on every edit.
  onChange,
}

/// One field's value, rules and current messages.
///
/// A [ChangeNotifier] so a control can rebuild on its own without the whole
/// form doing so, which is what `Controller` buys on the web.
abstract class ElFormFieldBase extends ChangeNotifier {
  ElFormFieldBase({required this.name});

  /// The schema key — `handle`, `email`, `password`, `plan`, `terms`.
  final String name;

  FocusNode? _focusNode;

  /// The node a failed submit lands on, and the one a `ElFieldLabel` focuses.
  ///
  /// Owned and disposed here, so a form's field list is the only thing a page
  /// has to keep alive.
  FocusNode get focusNode => _focusNode ??= FocusNode(debugLabel: name);

  List<String> _errors = const <String>[];

  /// What `FormError` renders. Empty means valid.
  List<String> get errors => _errors;

  /// `fieldState.invalid`.
  bool get invalid => _errors.isNotEmpty;

  /// The value, for the map a successful submit hands back.
  Object? get rawValue;

  /// The messages the rules raise against the current value, without storing
  /// them — `trigger` without the side effect.
  List<String> issues();

  /// Runs [issues] and stores the result. Returns whether the field passed.
  bool validate() {
    setErrors(issues());
    return !invalid;
  }

  /// Replaces the messages without consulting the rules.
  ///
  /// The server-error path: a message the schema could not have produced,
  /// which the next edit clears because re-validation overwrites it — exactly
  /// what `reValidateMode: "onChange"` does to a `setError` on the web.
  void setErrors(List<String> messages) {
    if (listEquals(_errors, messages)) return;
    _errors = List<String>.unmodifiable(messages);
    notifyListeners();
  }

  /// Back to the declared default, with no messages.
  void reset() {
    _errors = const <String>[];
    notifyListeners();
  }

  /// The form's re-validation hook. Set when the field joins a [ElForm].
  VoidCallback? _onEdit;

  /// Announces an edit — a value change, as opposed to a message change.
  ///
  /// The two are separate on purpose: storing messages must not re-trigger the
  /// validation that produced them.
  @protected
  void notifyEdited() {
    notifyListeners();
    _onEdit?.call();
  }

  @override
  void dispose() {
    _focusNode?.dispose();
    super.dispose();
  }
}

/// A typed field: a value, an ordered rule list, and a collection mode.
class ElFormField<T> extends ElFormFieldBase {
  ElFormField({
    required super.name,
    required T initialValue,
    List<ElRule<T>>? rules,
    this.issueMode = ElIssueMode.first,
  }) : _initialValue = initialValue,
       _value = initialValue,
       rules = rules ?? <ElRule<T>>[];

  /// The schema, in declaration order. Zod evaluates every check in that order
  /// without aborting, and so does [ElRules.check].
  final List<ElRule<T>> rules;

  /// `criteriaMode` — one message or all of them.
  final ElIssueMode issueMode;

  final T _initialValue;
  T _value;

  /// `defaultValues[name]`.
  T get initialValue => _initialValue;

  T get value => _value;

  set value(T next) {
    if (_value == next) return;
    _value = next;
    notifyEdited();
  }

  @override
  Object? get rawValue => _value;

  @override
  List<String> issues() => ElRules.check<T>(_value, rules, mode: issueMode);

  @override
  void reset() {
    _value = _initialValue;
    super.reset();
  }
}

/// A [ElFormField] that owns the [TextEditingController] its control edits.
///
/// The two have to be kept in step for every text field on the forms page, and
/// doing it once here is the difference between a page that declares four forms
/// and a page that hand-wires eight listeners.
class ElTextFormField extends ElFormField<String> {
  ElTextFormField({
    required super.name,
    String initialValue = '',
    super.rules,
    super.issueMode,
  }) : super(initialValue: initialValue) {
    controller = TextEditingController(text: initialValue);
    controller.addListener(_pull);
  }

  /// Hand this to `ElInput.controller` / `ElTextarea.controller`.
  late final TextEditingController controller;

  void _pull() => value = controller.text;

  @override
  void reset() {
    super.reset();
    controller.text = initialValue;
  }

  @override
  void dispose() {
    controller
      ..removeListener(_pull)
      ..dispose();
    super.dispose();
  }
}

/// A form: fields in declaration order, one validation policy, one submit.
///
/// Not a widget. `Form` on the web is `FormProvider` and contributes nothing to
/// the tree, so this contributes nothing either — a page listens to it with a
/// [ListenableBuilder] and passes each field's state into its own `ElField`.
class ElForm extends ChangeNotifier {
  ElForm({
    required this.fields,
    this.mode = ElValidateMode.onSubmit,
    this.reValidateMode = ElValidateMode.onChange,
  }) {
    for (final ElFormFieldBase field in fields) {
      field._onEdit = () => _onEdit(field);
    }
  }

  /// **Registration order**, which is the order [focusFirstError] walks.
  final List<ElFormFieldBase> fields;

  /// When the question is first asked.
  final ElValidateMode mode;

  /// When it is asked again, once the form has been submitted.
  final ElValidateMode reValidateMode;

  int _submitCount = 0;
  bool _submitting = false;

  /// How many times submit has run. `mode` governs edits while this is 0 and
  /// `reValidateMode` governs them afterwards.
  int get submitCount => _submitCount;

  /// `formState.isSubmitting` — what `ElButton.loading` reads.
  bool get isSubmitting => _submitting;

  /// `formState.isValid`, computed from what is currently stored rather than
  /// re-asked.
  bool get isValid => fields.every((ElFormFieldBase f) => !f.invalid);

  /// The field named [name], or a thrown [StateError] naming what is declared.
  ElFormFieldBase operator [](String name) => fields.firstWhere(
    (ElFormFieldBase f) => f.name == name,
    orElse: () => throw StateError(
      'No field named "$name". This form declares: '
      '${fields.map((ElFormFieldBase f) => f.name).join(', ')}.',
    ),
  );

  /// [name] as its typed self — `form.field<String>('handle').value`.
  ElFormField<T> field<T>(String name) => this[name] as ElFormField<T>;

  /// The text field named [name], for its controller.
  ElTextFormField text(String name) => this[name] as ElTextFormField;

  /// Runs every field's rules and stores the messages. Returns whether the
  /// whole form passed.
  bool validate() {
    bool valid = true;
    for (final ElFormFieldBase field in fields) {
      if (!field.validate()) valid = false;
    }
    notifyListeners();
    return valid;
  }

  /// `shouldFocusError: true` — the first invalid field in registration order.
  ///
  /// See this library's doc: correct for **every** field type, which is where
  /// it diverges from the reference. Ruling F4.
  void focusFirstError() {
    for (final ElFormFieldBase field in fields) {
      if (!field.invalid) continue;
      field.focusNode.requestFocus();
      return;
    }
  }

  /// `handleSubmit(onValid)`.
  ///
  /// Validates, focuses the first error and stops on failure; otherwise runs
  /// [onValid] with [isSubmitting] held true for its duration — which is what
  /// puts the spinner in the submit button.
  Future<bool> submit([FutureOr<void> Function()? onValid]) async {
    _submitCount++;
    if (!validate()) {
      focusFirstError();
      return false;
    }
    _submitting = true;
    notifyListeners();
    try {
      await onValid?.call();
    } finally {
      _submitting = false;
      notifyListeners();
    }
    return true;
  }

  /// `form.setError(name, { message })` — a message no rule produced.
  ///
  /// Deliberately does **not** focus: the reference's `ServerErrorForm` omits
  /// `{ shouldFocus: true }`, and a server round-trip that yanks focus out from
  /// under someone who has moved on is the reason it does.
  void setError(String name, String message) {
    this[name].setErrors(<String>[message]);
    notifyListeners();
  }

  /// Clears every message without touching the values.
  void clearErrors() {
    for (final ElFormFieldBase field in fields) {
      field.setErrors(const <String>[]);
    }
    notifyListeners();
  }

  /// Back to `defaultValues`, with no messages and no submit history.
  void reset() {
    for (final ElFormFieldBase field in fields) {
      field.reset();
    }
    _submitCount = 0;
    notifyListeners();
  }

  void _onEdit(ElFormFieldBase field) {
    // `mode` decides the first ask; once the form has been submitted,
    // `reValidateMode` decides every one after it.
    final ElValidateMode active = _submitCount == 0 ? mode : reValidateMode;
    if (active == ElValidateMode.onChange) field.validate();
    notifyListeners();
  }

  @override
  void dispose() {
    for (final ElFormFieldBase field in fields) {
      field._onEdit = null;
      field.dispose();
    }
    super.dispose();
  }
}
