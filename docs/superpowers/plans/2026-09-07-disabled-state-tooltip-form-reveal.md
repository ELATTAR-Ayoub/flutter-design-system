# Disabled State, Reason Tooltip and Form Reveal Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking. Workers run on **Sonnet** only (never Opus or Fable).

**Goal:** Every disableable component dims through one shared `Disabled` wrapper at `SurfaceOpacity.disabled` (0.5), can explain why it is disabled through a `disabledReason` tooltip (hover on desktop, tap on touch), and a disabled submit button inside a `FormScope` scrolls the first invalid field to the centre of the screen and shows its error when clicked.

**Architecture:** A new `Disabled` widget in `lib/src/components/ui/disabled.dart` owns opacity, pointer blocking, cursor, the reason `Tooltip` and a disabled-tap hook. Sixteen hand-rolled `Opacity(SurfaceOpacity.disabled) + IgnorePointer` sites are replaced by it. `Form` gains `revealFirstError()` (validate, `Scrollable.ensureVisible` at `alignment: 0.5`, focus) and a `FormScope` inherited widget; `Button` reads the scope so a disabled CTA inside it auto-reveals.

**Tech Stack:** Flutter (pinned SDK per `pubspec.yaml`), `flutter_test`, existing foundation tokens (`SurfaceOpacity`, `MotionDurations`, `MotionCurves`, `effectiveMotionDuration`), the existing `Tooltip` component.

## Global Constraints

- No visual or motion literals in `lib/` or `example/lib/` outside `lib/src/design_system/foundation/`; `test/token_guard_test.dart` fails the build otherwise. Use `SurfaceOpacity.disabled`, `MotionDurations.*`, `MotionCurves.*`, `effectiveMotionDuration(context, …)`.
- No `El*` prefix on any public name.
- `SurfaceOpacity.disabled` stays `0.5`. `test/disabled_state_test.dart` already forbids any private `const double …[Dd]isabled…Opacity` copy that is not `= SurfaceOpacity.disabled`.
- Every new public parameter is `disabledReason` (type `String?`, default `null`). Null means no tooltip. Never rename an existing `enabled`/`disabled`/`onPressed` API.
- Bare `flutter test` runs natively on Windows. Run `flutter analyze` after every task; zero issues is the bar.
- Commit after every task with the trailer `Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>`.
- Public API changes are distributed by the registry: the final task rebuilds `registry/generated/latest` and validates it.
- Test harness: copy the `_host` helper from `test/disabled_state_test.dart` (MediaQuery 1440×900, Directionality ltr, `ThemeScope(controller: ThemeController(mode: ColorMode.dark))`). Tests import `package:elattar_design_system/elattar_design_system.dart` and `package:flutter/widgets.dart` with the same `hide` list that file uses.

---

## File map

| File | Responsibility |
|---|---|
| Create `lib/src/components/ui/disabled.dart` | The `Disabled` wrapper: opacity, IgnorePointer, cursor, reason tooltip, disabled-tap hook. |
| Modify `lib/elattar_design_system.dart` | Export `disabled.dart`. |
| Modify `lib/src/components/ui/form.dart` | `Form.revealFirstError()`, `submit()` uses it, new `FormScope`. |
| Modify `lib/src/components/ui/field.dart` | `Field.disabledReason`, `FieldScope.disabledReason`, `FieldLabel` uses `Disabled`. |
| Modify `lib/src/components/ui/button.dart` | `disabledReason`, `onDisabledPressed`, `FormScope` auto-wire, uses `Disabled`. |
| Modify text inputs: `input.dart`, `textarea.dart`, `input_otp.dart`, `input_group.dart` | `disabledReason`, uses `Disabled`. |
| Modify selection: `selection_control.dart`, `checkbox.dart`, `switch.dart`, `radio.dart`, `toggle.dart`, `toggle_group.dart`, `slider.dart`, `stat.dart` | `disabledReason`, uses `Disabled`. |
| Modify pickers/menus: `select.dart`, `native_select.dart`, `combobox.dart`, `command.dart`, `menu.dart`, `dropdown_menu.dart` | `disabledReason`, uses `Disabled`. |
| Modify agent: `agent_composer.dart`, `agent_attach_menu.dart`, `questionnaire.dart`, `voice.dart`, `agent_transcript.dart`, `blocks/agent_console/agent_console.dart` | `disabledReason`, uses `Disabled`. |
| Create `test/disabled_wrapper_test.dart` | Unit tests for `Disabled`. |
| Create `test/form_reveal_test.dart` | Tests for `revealFirstError`, `FormScope`, Button auto-wire. |
| Modify `test/disabled_state_test.dart` | New guard: no dim outside `disabled.dart`; every component carries `disabledReason`. |
| Modify `CHANGELOG.md`, `registry/generated/latest/*` | Release notes, regenerated registry. |

Out of scope, on purpose: `ContextMenu.enabled` gates whether a right-click area opens a menu over arbitrary content; dimming that content would be wrong, so it is left as is. `Breadcrumb`'s current-page item is semantics-only and not a control. Example docs pages get no new demos (1:1 fidelity bar); the CHANGELOG carries the API note.

## Shared conversion recipe (referenced by Tasks 3–7; each task still lists its exact sites)

Before (typical):

```dart
control = Opacity(
  opacity: enabled ? 1 : SurfaceOpacity.disabled,
  child: IgnorePointer(ignoring: !enabled, child: control),
);
```

After:

```dart
control = Disabled(
  disabled: !enabled,
  reason: widget.disabledReason ?? scope?.disabledReason, // scope only where a FieldScope is read
  child: control,
);
```

Rules:
1. Add `final String? disabledReason;` and `this.disabledReason,` to the constructor, with this doc comment: `/// Why the control is disabled. Shown as a tooltip on hover (pointer) or tap (touch) while disabled; null shows nothing.`
2. Where the component reads `FieldScope.maybeOf(context)`, fall back to `scope?.disabledReason`.
3. Menu-style rows (Select option, Combobox item, Command item, Menu item) keep their own keyboard/pointer gating; pass `blockPointer: false` so hover for the tooltip still reaches the row and the existing handlers keep deciding.
4. Never leave a second `Opacity` for the disabled state in the same file. Remove `IgnorePointer(ignoring: !enabled …)` only when `Disabled` replaces it (default `blockPointer: true`); keep any unrelated `IgnorePointer`.
5. Keep the existing `Semantics(enabled: …)` where it exists; `Disabled` adds none.

---

### Task 1: The `Disabled` wrapper

**Files:**
- Create: `lib/src/components/ui/disabled.dart`
- Modify: `lib/elattar_design_system.dart` (add `export './src/components/ui/disabled.dart';` in alphabetical position after `dialog.dart`)
- Test: `test/disabled_wrapper_test.dart`

**Interfaces:**
- Produces:
  ```dart
  class Disabled extends StatelessWidget {
    const Disabled({
      super.key,
      required this.disabled,
      required this.child,
      this.reason,
      this.onDisabledTap,
      this.blockPointer = true,
      this.duration,            // null → MotionDurations.fast
    });
  }
  ```

- [ ] **Step 1: Write the failing tests**

```dart
// test/disabled_wrapper_test.dart
import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart'
    hide AspectRatio, Form, FormField, Icon, OverlayPortal, RadioGroup, RichText, SafeArea, ScrollPosition, Table, TableColumnWidth, Tooltip;
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) => MediaQuery(
  data: const MediaQueryData(size: Size(1440, 900)),
  child: Directionality(
    textDirection: TextDirection.ltr,
    child: ThemeScope(
      controller: ThemeController(mode: ColorMode.dark),
      child: Center(child: child),
    ),
  ),
);

double _dim(WidgetTester t) => t
    .widgetList<Opacity>(find.descendant(of: find.byType(Disabled), matching: find.byType(Opacity)))
    .map((Opacity o) => o.opacity)
    .reduce((double a, double b) => a < b ? a : b);

void main() {
  testWidgets('enabled renders the child at full opacity and lets taps through', (WidgetTester t) async {
    int taps = 0;
    await t.pumpWidget(_host(Disabled(
      disabled: false,
      child: GestureDetector(onTap: () => taps++, child: const SizedBox(width: 80, height: 40)),
    )));
    await t.pumpAndSettle();
    expect(_dim(t), 1);
    await t.tap(find.byType(SizedBox));
    expect(taps, 1);
  });

  testWidgets('disabled fades to the token and blocks the child', (WidgetTester t) async {
    int taps = 0;
    await t.pumpWidget(_host(Disabled(
      disabled: true,
      child: GestureDetector(onTap: () => taps++, child: const SizedBox(width: 80, height: 40)),
    )));
    await t.pumpAndSettle();
    expect(_dim(t), SurfaceOpacity.disabled);
    await t.tap(find.byType(SizedBox), warnIfMissed: false);
    expect(taps, 0);
  });

  testWidgets('disabled with blockPointer false keeps the child hittable', (WidgetTester t) async {
    int taps = 0;
    await t.pumpWidget(_host(Disabled(
      disabled: true,
      blockPointer: false,
      child: GestureDetector(onTap: () => taps++, child: const SizedBox(width: 80, height: 40)),
    )));
    await t.pumpAndSettle();
    await t.tap(find.byType(SizedBox));
    expect(taps, 1);
  });

  testWidgets('onDisabledTap fires only while disabled', (WidgetTester t) async {
    int hits = 0;
    Widget build(bool disabled) => _host(Disabled(
      disabled: disabled,
      onDisabledTap: () => hits++,
      child: const SizedBox(width: 80, height: 40),
    ));
    await t.pumpWidget(build(false));
    await t.tap(find.byType(SizedBox));
    expect(hits, 0);
    await t.pumpWidget(build(true));
    await t.pumpAndSettle();
    await t.tap(find.byType(SizedBox), warnIfMissed: false);
    expect(hits, 1);
  });

  testWidgets('no reason means no Tooltip in the tree', (WidgetTester t) async {
    await t.pumpWidget(_host(const Disabled(disabled: true, child: SizedBox(width: 80, height: 40))));
    expect(find.byType(Tooltip), findsNothing);
  });

  testWidgets('a reason shows on hover while disabled', (WidgetTester t) async {
    await t.pumpWidget(_host(const Disabled(
      disabled: true,
      reason: 'Finish the form first',
      child: SizedBox(width: 80, height: 40),
    )));
    final TestGesture mouse = await t.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    addTearDown(mouse.removePointer);
    await mouse.moveTo(t.getCenter(find.byType(SizedBox)));
    await t.pump(MotionDurations.tooltipShowDelay + MotionDurations.overlayEnter);
    await t.pumpAndSettle();
    expect(find.text('Finish the form first'), findsOneWidget);
  });

  testWidgets('a reason shows on touch tap while disabled', (WidgetTester t) async {
    await t.pumpWidget(_host(const Disabled(
      disabled: true,
      reason: 'Finish the form first',
      child: SizedBox(width: 80, height: 40),
    )));
    final TestGesture finger = await t.createGesture(kind: PointerDeviceKind.touch);
    await finger.down(t.getCenter(find.byType(SizedBox)));
    await finger.up();
    await t.pump(MotionDurations.overlayEnter);
    expect(find.text('Finish the form first'), findsOneWidget);
    await t.pump(Tooltip.touchDwell + MotionDurations.overlayExit);
    await t.pumpAndSettle();
  });

  testWidgets('a reason on an enabled control shows nothing', (WidgetTester t) async {
    await t.pumpWidget(_host(const Disabled(
      disabled: false,
      reason: 'never',
      child: SizedBox(width: 80, height: 40),
    )));
    expect(find.byType(Tooltip), findsNothing);
  });
}
```

- [ ] **Step 2: Run to verify it fails**

Run: `flutter test test/disabled_wrapper_test.dart`
Expected: compile error, `Disabled` is not defined.

- [ ] **Step 3: Implement**

```dart
// lib/src/components/ui/disabled.dart
/// The one way a control in this system goes disabled.
///
/// Sixteen components used to hand-roll `Opacity(SurfaceOpacity.disabled)`
/// around an `IgnorePointer`, and four of them forgot one half. This widget is
/// the shared `.disabled` class: the fade, the pointer block, the cursor, the
/// reason tooltip and the tap hook live here and nowhere else.
library;

import 'package:flutter/widgets.dart';

import '../../design_system/foundation/motion.dart';
import '../../design_system/foundation/surfaces.dart';
import '../../design_system/foundation/theme_scope.dart';
import './tooltip.dart';

class Disabled extends StatelessWidget {
  const Disabled({
    super.key,
    required this.disabled,
    required this.child,
    this.reason,
    this.onDisabledTap,
    this.blockPointer = true,
    this.duration,
  });

  final bool disabled;
  final Widget child;

  /// Why the control is disabled. Shown as a tooltip on hover (pointer) or
  /// tap (touch) while [disabled]; null shows nothing.
  final String? reason;

  /// Called when a pointer taps the disabled control. Fires only while
  /// [disabled]; the child never sees the tap.
  final VoidCallback? onDisabledTap;

  /// Whether the child stops receiving pointer input while disabled.
  /// Menu rows that gate input themselves pass false.
  final bool blockPointer;

  /// How long the fade takes; null uses [MotionDurations.fast]. Button passes
  /// its own measured spring.
  final Duration? duration;

  @override
  Widget build(BuildContext context) {
    Widget result = TweenAnimationBuilder<double>(
      tween: Tween<double>(end: disabled ? SurfaceOpacity.disabled : 1),
      duration: effectiveMotionDuration(context, duration ?? MotionDurations.fast),
      curve: MotionCurves.emphasized,
      builder: (BuildContext context, double value, Widget? child) => Opacity(
        // The spring overshoots past 1 on the way back; CSS clamps opacity to
        // 0..1 for its used value and so do we.
        opacity: clampDouble(value, 0, 1),
        child: child,
      ),
      child: IgnorePointer(ignoring: disabled && blockPointer, child: child),
    );

    if (!disabled) return result;

    result = MouseRegion(
      cursor: SystemMouseCursors.basic,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onDisabledTap,
        child: result,
      ),
    );

    final String? label = reason;
    if (label == null || label.isEmpty) return result;
    return Tooltip(label: label, child: result);
  }
}
```

Note: `clampDouble` comes from `package:flutter/foundation.dart` and is re-exported by `widgets.dart`. If `effectiveMotionDuration` lives in `theme_scope.dart` (it does: `lib/src/design_system/foundation/theme_scope.dart:370`), the import above is right; otherwise import from `motion.dart`.

- [ ] **Step 4: Export from the barrel**

In `lib/elattar_design_system.dart` add `export './src/components/ui/disabled.dart';` directly after the `dialog.dart` export.

- [ ] **Step 5: Run tests**

Run: `flutter test test/disabled_wrapper_test.dart && flutter analyze`
Expected: all 8 pass, analyzer clean. If the hover test fails because the tooltip's `MouseRegion` never receives the enter, confirm the `MouseRegion` in `Disabled` sits *inside* the `Tooltip` (it does in the code above) and that `Tooltip`'s own `MouseRegion` is opaque by default.

- [ ] **Step 6: Commit**

```bash
git add lib/src/components/ui/disabled.dart lib/elattar_design_system.dart test/disabled_wrapper_test.dart
git commit -m "feat: add Disabled wrapper with reason tooltip and disabled-tap hook"
```

---

### Task 2: `Form.revealFirstError()` and `FormScope`

**Files:**
- Modify: `lib/src/components/ui/form.dart` (`Form` class, around lines 290–340: `focusFirstError`, `submit`)
- Test: `test/form_reveal_test.dart`

**Interfaces:**
- Consumes: `FormFieldBase.focusNode` (`form.dart:96`), `FormFieldBase.invalid`, `Form.validate()`.
- Produces:
  ```dart
  Future<void> Form.revealFirstError({bool validateFirst = true});
  class FormScope extends InheritedNotifier<Form> {
    const FormScope({super.key, required Form form, required super.child});
    static Form? maybeOf(BuildContext context);
    Form get form;
  }
  ```

- [ ] **Step 1: Write the failing tests**

```dart
// test/form_reveal_test.dart
import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart'
    hide AspectRatio, Form, FormField, Icon, OverlayPortal, RadioGroup, RichText, SafeArea, ScrollPosition, Table, TableColumnWidth, Tooltip;
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) => MediaQuery(
  data: const MediaQueryData(size: Size(1440, 900)),
  child: Directionality(
    textDirection: TextDirection.ltr,
    child: ThemeScope(
      controller: ThemeController(mode: ColorMode.dark),
      child: child,
    ),
  ),
);

/// A tall page: 20 filler blocks, then the form's two fields, then a CTA.
Widget _page(Form form, {Widget? cta}) => _host(
  FormScope(
    form: form,
    child: ListenableBuilder(
      listenable: form,
      builder: (BuildContext context, Widget? _) => SingleChildScrollView(
        child: Column(
          children: <Widget>[
            for (int i = 0; i < 20; i++) const SizedBox(height: 200),
            Field(
              key: const ValueKey<String>('email-field'),
              label: 'Email',
              errors: form.field<String>('email').errors,
              focusNode: form['email'].focusNode,
              child: Input(controller: form.text('email').controller),
            ),
            const SizedBox(height: 1200),
            Field(
              label: 'Handle',
              errors: form.field<String>('handle').errors,
              focusNode: form['handle'].focusNode,
              child: Input(controller: form.text('handle').controller),
            ),
            const SizedBox(height: 600),
            cta ?? const SizedBox.shrink(),
          ],
        ),
      ),
    ),
  ),
);

Form _form() => Form(
  fields: <FormFieldBase>[
    TextFormField(name: 'email', initialValue: '', rules: <ValidationRule<String>>[required('Enter your email')]),
    TextFormField(name: 'handle', initialValue: '', rules: <ValidationRule<String>>[required('Pick a handle')]),
  ],
);

void main() {
  testWidgets('revealFirstError validates, centres the first invalid field and focuses it', (WidgetTester t) async {
    final Form form = _form();
    addTearDown(form.dispose);
    await t.pumpWidget(_page(form));
    expect(find.text('Enter your email'), findsNothing);

    await form.revealFirstError();
    await t.pumpAndSettle();

    expect(find.text('Enter your email'), findsOneWidget);
    expect(form['email'].focusNode.hasFocus, isTrue);
    final Rect field = t.getRect(find.byKey(const ValueKey<String>('email-field')));
    expect((field.center.dy - 450).abs(), lessThan(field.height));
  });

  testWidgets('revealFirstError with nothing invalid does nothing', (WidgetTester t) async {
    final Form form = _form();
    addTearDown(form.dispose);
    form.text('email').controller.text = 'a@b.c';
    form.text('handle').controller.text = 'ab';
    await t.pumpWidget(_page(form));
    final double before = t.state<ScrollableState>(find.byType(Scrollable)).position.pixels;
    await form.revealFirstError();
    await t.pumpAndSettle();
    expect(t.state<ScrollableState>(find.byType(Scrollable)).position.pixels, before);
  });

  testWidgets('a failed submit also scrolls', (WidgetTester t) async {
    final Form form = _form();
    addTearDown(form.dispose);
    await t.pumpWidget(_page(form));
    expect(await form.submit(), isFalse);
    await t.pumpAndSettle();
    expect(t.state<ScrollableState>(find.byType(Scrollable)).position.pixels, greaterThan(0));
  });

  testWidgets('FormScope.maybeOf finds the form', (WidgetTester t) async {
    final Form form = _form();
    addTearDown(form.dispose);
    Form? seen;
    await t.pumpWidget(_host(FormScope(
      form: form,
      child: Builder(builder: (BuildContext c) { seen = FormScope.maybeOf(c); return const SizedBox(); }),
    )));
    expect(identical(seen, form), isTrue);
  });
}
```

Check the rule helper name: grep `lib/src/components/ui/validation_rule.dart` for the required-rule factory (`required(`, `ValidationRule.required`, or similar) and use that exact name. If `TextFormField`'s constructor differs from `(name, initialValue, rules)`, read `form.dart:206-235` and match it.

- [ ] **Step 2: Run to verify it fails**

Run: `flutter test test/form_reveal_test.dart`
Expected: compile errors for `revealFirstError` and `FormScope`.

- [ ] **Step 3: Implement in `form.dart`**

Add the imports if missing: `motion.dart` and `theme_scope.dart` from `../../design_system/foundation/`. Then, in `class Form`, replace the `focusFirstError` / `submit` pair with:

```dart
  /// The first invalid field in registration order, or null.
  FormFieldBase? get firstInvalid {
    for (final FormFieldBase field in fields) {
      if (field.invalid) return field;
    }
    return null;
  }

  /// `shouldFocusError: true` — focuses the first invalid field. Kept for
  /// callers that only want focus; [revealFirstError] is what a submit does.
  void focusFirstError() => firstInvalid?.focusNode.requestFocus();

  /// Shows the reader exactly what is missing.
  ///
  /// Runs the rules (so the field's error text appears), scrolls the first
  /// invalid field to the centre of every scroll view between it and the
  /// root, then focuses it. A disabled submit button inside a [FormScope]
  /// calls this when tapped, and so does a failed [submit].
  Future<void> revealFirstError({bool validateFirst = true}) async {
    if (validateFirst) validate();
    final FormFieldBase? field = firstInvalid;
    if (field == null) return;
    final BuildContext? context = field.focusNode.context;
    if (context != null && context.mounted) {
      await Scrollable.ensureVisible(
        context,
        alignment: 0.5,
        duration: effectiveMotionDuration(context, MotionDurations.normal),
        curve: MotionCurves.emphasized,
      );
    }
    field.focusNode.requestFocus();
  }

  /// `handleSubmit(onValid)`.
  ///
  /// Validates, reveals the first error and stops on failure; otherwise runs
  /// [onValid] with [isSubmitting] held true for its duration — which is what
  /// puts the spinner in the submit button.
  Future<bool> submit([FutureOr<void> Function()? onValid]) async {
    _submitCount++;
    if (!validate()) {
      await revealFirstError(validateFirst: false);
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
```

`Scrollable.ensureVisible` walks every ancestor scrollable itself, so nested scroll views need no extra code. If `focusNode.context` is null (the control attached a different node), nothing scrolls and focus still moves; that is the documented fallback.

Append at the end of `form.dart`:

```dart
/// Puts a [Form] in the tree so a disabled submit [Button] below it can call
/// [Form.revealFirstError] without being handed the form by hand.
///
/// An [InheritedNotifier], so dependents rebuild when the form notifies.
class FormScope extends InheritedNotifier<Form> {
  const FormScope({super.key, required Form form, required super.child})
      : super(notifier: form);

  Form get form => notifier!;

  static Form? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<FormScope>()?.notifier;
}
```

- [ ] **Step 4: Run tests**

Run: `flutter test test/form_reveal_test.dart test/inputs_test.dart && flutter analyze`
Expected: pass. The centring assertion allows one field-height of slack because `ensureVisible` clamps at scroll extents; the filler blocks in `_page` make sure the field is not at an extent.

- [ ] **Step 5: Commit**

```bash
git add lib/src/components/ui/form.dart test/form_reveal_test.dart
git commit -m "feat: Form.revealFirstError scrolls the first invalid field to centre; add FormScope"
```

---

### Task 3: Button, Field and FieldLabel

**Files:**
- Modify: `lib/src/components/ui/button.dart` (constructor `:341-358`, `_enabled` `:663`, dim block `:1143-1158`)
- Modify: `lib/src/components/ui/field.dart` (`FieldScope` `:105-152`, `Field` ctor `:302-312`, `FieldScope` construction near `:382-397`, `FieldLabel` dim `:616`)
- Test: `test/form_reveal_test.dart` (add), `test/disabled_state_test.dart` (existing Button dim test must still pass)

**Interfaces:**
- Consumes: `Disabled` (Task 1), `FormScope.maybeOf`, `Form.revealFirstError` (Task 2).
- Produces: `Button.disabledReason: String?`, `Button.onDisabledPressed: VoidCallback?`, `Field.disabledReason: String?`, `FieldScope.disabledReason: String?`.

- [ ] **Step 1: Write the failing tests** (append to `test/form_reveal_test.dart`)

```dart
  testWidgets('a disabled Button inside FormScope reveals the first error on tap', (WidgetTester t) async {
    final Form form = _form();
    addTearDown(form.dispose);
    await t.pumpWidget(_page(form, cta: const Button(onPressed: null, child: Text('Submit'))));
    await t.ensureVisible(find.text('Submit'));
    await t.pumpAndSettle();
    await t.tap(find.text('Submit'), warnIfMissed: false);
    await t.pumpAndSettle();
    expect(find.text('Enter your email'), findsOneWidget);
    expect(form['email'].focusNode.hasFocus, isTrue);
  });

  testWidgets('onDisabledPressed wins over the FormScope default', (WidgetTester t) async {
    final Form form = _form();
    addTearDown(form.dispose);
    int hits = 0;
    await t.pumpWidget(_page(form, cta: Button(onPressed: null, onDisabledPressed: () => hits++, child: const Text('Submit'))));
    await t.ensureVisible(find.text('Submit'));
    await t.pumpAndSettle();
    await t.tap(find.text('Submit'), warnIfMissed: false);
    await t.pumpAndSettle();
    expect(hits, 1);
    expect(find.text('Enter your email'), findsNothing);
  });

  testWidgets('a loading Button does not reveal errors', (WidgetTester t) async {
    final Form form = _form();
    addTearDown(form.dispose);
    await t.pumpWidget(_page(form, cta: Button(onPressed: () {}, loading: true, child: const Text('Submit'))));
    await t.ensureVisible(find.text('Submit'));
    await t.pumpAndSettle();
    await t.tap(find.text('Submit'), warnIfMissed: false);
    await t.pump();
    expect(find.text('Enter your email'), findsNothing);
  });

  testWidgets('Field.disabledReason reaches the control tooltip', (WidgetTester t) async {
    await t.pumpWidget(_host(Center(child: Field(
      label: 'Email',
      enabled: false,
      disabledReason: 'Locked after verification',
      child: Input(controller: TextEditingController()),
    ))));
    expect(find.byWidgetPredicate((Widget w) => w is Tooltip && w.label == 'Locked after verification'), findsOneWidget);
  });
```

The last test needs Task 4's `Input` change to pass; it is written here so Task 4 has a red test waiting. Mark it `skip: 'Task 4'` until then, and remove the skip in Task 4.

- [ ] **Step 2: Run to verify it fails**

Run: `flutter test test/form_reveal_test.dart`
Expected: compile errors on `onDisabledPressed`, `disabledReason`.

- [ ] **Step 3: Button**

Add to the constructor and fields:

```dart
    this.disabledReason,
    this.onDisabledPressed,
  ...
  /// Why the button is disabled. Shown as a tooltip on hover (pointer) or
  /// tap (touch) while disabled; null shows nothing.
  final String? disabledReason;

  /// Called when a pointer taps the button while `onPressed` is null and it is
  /// not loading. Null inside a [FormScope] means [Form.revealFirstError].
  final VoidCallback? onDisabledPressed;
```

Replace the `TweenAnimationBuilder … IgnorePointer` block (`button.dart:1143-1158`) with:

```dart
    // B11 — `disabled:opacity-45` on `btn-spring`'s clock (see [Disabled]).
    // `pointer-events: none` is not on that clock: [Disabled] keeps the
    // IgnorePointer instant.
    final Form? form = FormScope.maybeOf(context);
    final bool idleDisabled = widget.onPressed == null && !widget.loading;
    button = Disabled(
      disabled: !_enabled,
      duration: transition,
      reason: widget.disabledReason,
      onDisabledTap: !idleDisabled
          ? null
          : widget.onDisabledPressed ??
              (form == null ? null : () => form.revealFirstError()),
      child: button,
    );
```

Add `import './disabled.dart';` and `import './form.dart';` (form.dart exports `Form`; if `button.dart` imports `flutter/widgets.dart` without hiding `Form`, add `hide Form` to that import).

- [ ] **Step 4: Field and FieldScope**

`FieldScope`: add `this.disabledReason,` to the constructor, `final String? disabledReason;` with the standard doc comment, and `old.disabledReason != disabledReason ||` to `updateShouldNotify`.

`Field`: add `this.disabledReason,` and `final String? disabledReason;`; where `Field` builds its `FieldScope` (near `field.dart:382-397`), pass `disabledReason: widget.disabledReason`.

`FieldLabel` (`field.dart:616`): replace `label = Opacity(opacity: disabledOpacity, child: label);` with `label = Disabled(disabled: true, blockPointer: false, child: label);` inside the same `if (!enabled)` branch (keep `FieldLabel.disabledOpacity` as the public alias; the guard test still asserts it forwards to the token). Add `import './disabled.dart';`.

- [ ] **Step 5: Run tests**

Run: `flutter test test/form_reveal_test.dart test/disabled_state_test.dart test/components_test.dart && flutter analyze`
Expected: pass (except the one skipped test).

- [ ] **Step 6: Commit**

```bash
git add lib/src/components/ui/button.dart lib/src/components/ui/field.dart test/form_reveal_test.dart
git commit -m "feat: Button disabledReason/onDisabledPressed with FormScope auto-reveal; Field.disabledReason"
```

---

### Task 4: Text inputs

**Files:**
- Modify: `lib/src/components/ui/input.dart` (ctor; scope read `:362-367`; dim `:458-459`)
- Modify: `lib/src/components/ui/textarea.dart` (ctor; scope `:181-184`; dim `:256-259`, currently no IgnorePointer)
- Modify: `lib/src/components/ui/input_otp.dart` (ctor; scope `:305`; dim `:372-373`)
- Modify: `lib/src/components/ui/input_group.dart` (group ctor; `:216`; dim `:301-302`; `InputGroupButton` ctor, `_enabled` `:635`, dim `:752-753`)
- Test: `test/disabled_state_test.dart` (add cases), un-skip the Field test in `test/form_reveal_test.dart`

**Interfaces:**
- Consumes: `Disabled`, `FieldScope.disabledReason`.
- Produces: `disabledReason: String?` on `Input`, `Textarea`, `InputOtp`, `InputGroup`, `InputGroupButton`.

- [ ] **Step 1: Write the failing tests** (append inside the `'the controls a reader meets'` group of `test/disabled_state_test.dart`)

```dart
    Finder tip(String s) => find.byWidgetPredicate((Widget w) => w is Tooltip && w.label == s);

    testWidgets('Input, Textarea, InputOtp and InputGroup carry a reason', (WidgetTester tester) async {
      await tester.pumpWidget(_host(Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Input(controller: TextEditingController(), enabled: false, disabledReason: 'r-input'),
        Textarea(controller: TextEditingController(), enabled: false, disabledReason: 'r-textarea'),
        InputOtp(length: 4, enabled: false, disabledReason: 'r-otp'),
        InputGroup(enabled: false, disabledReason: 'r-group', child: Input(controller: TextEditingController())),
      ])));
      await tester.pumpAndSettle();
      for (final String s in <String>['r-input', 'r-textarea', 'r-otp', 'r-group']) {
        expect(tip(s), findsOneWidget, reason: s);
      }
      expect(_dim(tester, Textarea), SurfaceOpacity.disabled);
    });

    testWidgets('a disabled Textarea no longer takes the tap', (WidgetTester tester) async {
      await tester.pumpWidget(_host(Textarea(controller: TextEditingController(), enabled: false)));
      await tester.pumpAndSettle();
      expect(find.descendant(of: find.byType(Textarea), matching: find.byWidgetPredicate((Widget w) => w is IgnorePointer && w.ignoring)), findsOneWidget);
    });
```

Adjust constructor arguments to each component's real required parameters (read the ctor first: `InputOtp` may take `length`, `slots` or a controller; `InputGroup` may take `children`). Do not invent parameters; use what the ctor declares.

- [ ] **Step 2: Run to verify it fails**

Run: `flutter test test/disabled_state_test.dart`
Expected: compile errors on `disabledReason`.

- [ ] **Step 3: Implement each site with the shared recipe**

`input.dart` (`:458-459`):
```dart
    control = Disabled(
      disabled: !enabled,
      reason: widget.disabledReason ?? scope?.disabledReason,
      child: control,
    );
```
`scope` is the `FieldScope?` already read at `:362`; keep `readOnly: !enabled` at `:384`.

`textarea.dart` (`:256-259`): same shape. This *adds* pointer blocking that was deliberately absent (comment at `:256-257`). Read that comment; if it exists to keep the scroll of a read-only textarea working, pass `blockPointer: false` and say so in a one-line comment; otherwise use the default. The test above expects the default (blocked); if you go with `blockPointer: false`, change the test to assert `ignoring: false` and explain in the commit message.

`input_otp.dart` (`:372-373`): same shape, `scope` is the field read at `:305`.

`input_group.dart` group root (`:301-302`): `reason: widget.disabledReason ?? field?.disabledReason` where `field` is the scope read at `:216`. `InputGroupButton` (`:752-753`): `Disabled(disabled: !_enabled, reason: widget.disabledReason, child: …)`.

Each of the five classes gets `this.disabledReason,` + `final String? disabledReason;` with the standard doc comment. Add `import './disabled.dart';` to each file.

- [ ] **Step 4: Un-skip** the `Field.disabledReason reaches the control tooltip` test in `test/form_reveal_test.dart`.

- [ ] **Step 5: Run tests**

Run: `flutter test test/disabled_state_test.dart test/form_reveal_test.dart test/inputs_test.dart && flutter analyze`
Expected: pass.

- [ ] **Step 6: Commit**

```bash
git add lib/src/components/ui/input.dart lib/src/components/ui/textarea.dart lib/src/components/ui/input_otp.dart lib/src/components/ui/input_group.dart test/disabled_state_test.dart test/form_reveal_test.dart
git commit -m "feat: text inputs dim through Disabled and carry disabledReason"
```

---

### Task 5: Selection controls, Toggle, Slider, Stat

**Files:**
- Modify: `lib/src/components/ui/selection_control.dart` (ctor; `_enabled` `:431`; dim `:559-560`)
- Modify: `lib/src/components/ui/checkbox.dart` (ctor; scope `:219`; delegate `:290`)
- Modify: `lib/src/components/ui/switch.dart` (ctor; `:140`; delegate `:167`)
- Modify: `lib/src/components/ui/radio.dart` (`RadioGroupItem` ctor; delegates `:446,458`; scope read near `:233`)
- Modify: `lib/src/components/ui/toggle.dart` (ctor; dim `:503-504`)
- Modify: `lib/src/components/ui/toggle_group.dart` (`ToggleGroupItem` `:90-106`; forward `:207`)
- Modify: `lib/src/components/ui/slider.dart` (ctor; dim `:541-543`)
- Modify: `lib/src/components/ui/stat.dart` (ctor `:202`; dim `:358`, no IgnorePointer)
- Test: `test/disabled_state_test.dart`

**Interfaces:**
- Consumes: `Disabled`, `FieldScope.disabledReason`.
- Produces: `disabledReason: String?` on `SelectionControl`, `Checkbox`, `Switch`, `RadioGroupItem`, `Toggle`, `ToggleGroupItem`, `Slider`, `Stat`.

- [ ] **Step 1: Write the failing test** (append to the same group)

```dart
    testWidgets('selection controls, Toggle, Slider and Stat carry a reason', (WidgetTester tester) async {
      await tester.pumpWidget(_host(Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Checkbox(value: false, onChanged: (_) {}, enabled: false, disabledReason: 'r-checkbox'),
        Switch(value: false, onChanged: (_) {}, enabled: false, disabledReason: 'r-switch'),
        RadioGroup<int>(value: 1, onChanged: (_) {}, children: <Widget>[RadioGroupItem<int>(value: 1, enabled: false, disabledReason: 'r-radio', label: const Text('one'))]),
        Toggle(pressed: false, onChanged: null, disabledReason: 'r-toggle', child: const Text('t')),
        ToggleGroup<int>(value: <int>{}, onChanged: (_) {}, items: <ToggleGroupItem<int>>[ToggleGroupItem<int>(value: 1, enabled: false, disabledReason: 'r-tgi', child: const Text('a'))]),
        Slider(value: 0.5, onChanged: (_) {}, enabled: false, disabledReason: 'r-slider'),
        Stat(label: 'x', value: '1', disabled: true, disabledReason: 'r-stat'),
      ])));
      await tester.pumpAndSettle();
      for (final String s in <String>['r-checkbox', 'r-switch', 'r-radio', 'r-toggle', 'r-tgi', 'r-slider', 'r-stat']) {
        expect(find.byWidgetPredicate((Widget w) => w is Tooltip && w.label == s), findsOneWidget, reason: s);
      }
    });
```

Match each constructor's real required parameters before running (read each ctor; `RadioGroup`, `ToggleGroup` and `Stat` signatures vary). Do not invent parameters.

- [ ] **Step 2: Run to verify it fails**

Run: `flutter test test/disabled_state_test.dart`
Expected: compile errors on `disabledReason`.

- [ ] **Step 3: Implement**

`selection_control.dart` (`:559-560`):
```dart
    control = Disabled(
      disabled: !widget.enabled,
      reason: widget.disabledReason,
      child: control,
    );
```
Note the existing code dims on `widget.enabled` but blocks on `_enabled` (`enabled && !inert && onTap != null`). Preserve that split: keep `IgnorePointer(ignoring: !_enabled && widget.enabled, child: control)` *inside* the `Disabled` when they differ, i.e.:
```dart
    control = IgnorePointer(ignoring: widget.enabled && !_enabled, child: control);
    control = Disabled(disabled: !widget.enabled, reason: widget.disabledReason, child: control);
```

`checkbox.dart`, `switch.dart`, `radio.dart`: add the param, pass `disabledReason: widget.disabledReason ?? scope?.disabledReason` into `SelectionControl` (the scope variable each file already reads).

`toggle.dart` (`:503-504`): `Disabled(disabled: !_enabled, reason: widget.disabledReason, child: …)`.

`toggle_group.dart`: `ToggleGroupItem` gets `disabledReason`; at `:207` forward `disabledReason: items[i].disabledReason` to the `Toggle`.

`slider.dart` (`:541-543`): existing dims on `widget.enabled`, blocks on `_operable`. Same pattern as SelectionControl: inner `IgnorePointer(ignoring: widget.enabled && !_operable)`, outer `Disabled(disabled: !widget.enabled, reason: widget.disabledReason)`.

`stat.dart` (`:358`): `Disabled(disabled: widget.disabled, reason: widget.disabledReason, child: …)`. Stat has no tap; the default pointer block is harmless and makes it consistent.

Add `import './disabled.dart';` to each file that now builds a `Disabled`.

- [ ] **Step 4: Run tests**

Run: `flutter test test/disabled_state_test.dart test/selection_feedback_test.dart test/slider_test.dart test/components_test.dart && flutter analyze`
Expected: pass.

- [ ] **Step 5: Commit**

```bash
git add lib/src/components/ui/selection_control.dart lib/src/components/ui/checkbox.dart lib/src/components/ui/switch.dart lib/src/components/ui/radio.dart lib/src/components/ui/toggle.dart lib/src/components/ui/toggle_group.dart lib/src/components/ui/slider.dart lib/src/components/ui/stat.dart test/disabled_state_test.dart
git commit -m "feat: selection controls, Toggle, Slider and Stat dim through Disabled with disabledReason"
```

---

### Task 6: Select, NativeSelect, Combobox, Command, Menu, DropdownMenu

**Files:**
- Modify: `lib/src/components/ui/select.dart` (ctor; `_fieldEnabled` `:357,398`; trigger dim `:665-666`; `SelectOption` ctor; option dim `:1300-1303`)
- Modify: `lib/src/components/ui/native_select.dart` (ctor; `:241-242`; dim `:579-580`)
- Modify: `lib/src/components/ui/combobox.dart` (item class near `:165`; dim `:734-737`)
- Modify: `lib/src/components/ui/command.dart` (`CommandItem` `:344`; dim `:1455-1458`)
- Modify: `lib/src/components/ui/menu.dart` (`MenuItem`, `MenuCheckboxItem`, `MenuRadioItem`, `MenuSubTrigger` ctors near `:155,224,249,332`; row dim `:1471`)
- Modify: `lib/src/components/ui/dropdown_menu.dart` (ctor `:108`; forward `:186`)
- Test: `test/disabled_state_test.dart`, `test/menus_test.dart` (must still pass)

**Interfaces:**
- Consumes: `Disabled` with `blockPointer: false` for rows.
- Produces: `disabledReason: String?` on `Select`, `SelectOption`, `NativeSelect`, `ComboboxItem` (whatever the item class is named), `CommandItem`, `MenuItem` family, `DropdownMenu`.

- [ ] **Step 1: Write the failing test** (append to the same group)

```dart
    testWidgets('Select and NativeSelect triggers carry a reason', (WidgetTester tester) async {
      await tester.pumpWidget(_host(Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Select<int>(value: null, onChanged: (_) {}, enabled: false, disabledReason: 'r-select', options: <SelectOption<int>>[SelectOption<int>(value: 1, label: 'one')]),
        NativeSelect<int>(value: null, onChanged: (_) {}, enabled: false, disabledReason: 'r-native', options: <NativeSelectOption<int>>[NativeSelectOption<int>(value: 1, label: 'one')]),
      ])));
      await tester.pumpAndSettle();
      expect(find.byWidgetPredicate((Widget w) => w is Tooltip && w.label == 'r-select'), findsOneWidget);
      expect(find.byWidgetPredicate((Widget w) => w is Tooltip && w.label == 'r-native'), findsOneWidget);
    });

    testWidgets('a disabled Select option keeps its row hittable for hover and carries a reason', (WidgetTester tester) async {
      await tester.pumpWidget(_host(Select<int>(value: null, onChanged: (_) {}, options: <SelectOption<int>>[
        SelectOption<int>(value: 1, label: 'one'),
        SelectOption<int>(value: 2, label: 'two', enabled: false, disabledReason: 'r-opt'),
      ])));
      await tester.tap(find.byType(Select<int>));
      await tester.pumpAndSettle();
      final Finder wrapper = find.ancestor(of: find.text('two'), matching: find.byType(Disabled));
      expect(wrapper, findsOneWidget);
      expect(tester.widget<Disabled>(wrapper).blockPointer, isFalse);
      expect(find.byWidgetPredicate((Widget w) => w is Tooltip && w.label == 'r-opt'), findsOneWidget);
    });
```

Match real constructor signatures (`Select`, `SelectOption`, `NativeSelect`, `NativeSelectOption`) by reading them first; the option class names may differ.

- [ ] **Step 2: Run to verify it fails**

Run: `flutter test test/disabled_state_test.dart`
Expected: compile errors on `disabledReason`.

- [ ] **Step 3: Implement**

Triggers (`select.dart:665-666`, `native_select.dart:579-580`): the existing code dims on `_fieldEnabled` and blocks on `_enabled` (`_fieldEnabled && onChanged != null`). Preserve: inner `IgnorePointer(ignoring: _fieldEnabled && !_enabled)`, outer `Disabled(disabled: !_fieldEnabled, reason: widget.disabledReason ?? _scope?.disabledReason)` (`_scope` in select.dart `:351`; native_select reads its scope similarly, use that variable).

Rows, all four with the same shape:
```dart
    row = Disabled(
      disabled: !item.enabled,        // option.enabled / enabled per file
      blockPointer: false,
      reason: item.disabledReason,
      child: row,
    );
```
- `select.dart:1300-1303` (`option`), `combobox.dart:734-737` (`item`), `command.dart:1455-1458` (`item`, keep `Command.disabledOpacity` as the public alias), `menu.dart:1471` (`enabled`, the row builder gets a new `String? disabledReason` argument threaded from each item class).

`dropdown_menu.dart`: add `disabledReason`; the trigger already forwards `enabled: widget.enabled` at `:186`. Wrap the trigger child in `Disabled(disabled: !widget.enabled, reason: widget.disabledReason, child: trigger)` only if the trigger does not already render through a `Button` that receives `onPressed: null`; if it does, pass `disabledReason: widget.disabledReason` to that `Button` instead. Read `:170-200` and pick the one that does not double-dim (the guard in Task 8 catches a double `Disabled` under one `DropdownMenu`).

Add `import './disabled.dart';` to each file.

- [ ] **Step 4: Run tests**

Run: `flutter test test/disabled_state_test.dart test/menus_test.dart test/selects_test.dart test/select_combobox_keyboard_test.dart test/overlay_menu_family_test.dart && flutter analyze`
Expected: pass.

- [ ] **Step 5: Commit**

```bash
git add lib/src/components/ui/select.dart lib/src/components/ui/native_select.dart lib/src/components/ui/combobox.dart lib/src/components/ui/command.dart lib/src/components/ui/menu.dart lib/src/components/ui/dropdown_menu.dart test/disabled_state_test.dart
git commit -m "feat: pickers and menu rows dim through Disabled with disabledReason"
```

---

### Task 7: Agent surfaces

**Files:**
- Modify: `lib/src/components/ui/agent_composer.dart` (ctor `:159-181`; `_ComposerInput` `:664`, dim `:769-770`; attach menu pass-through `:521`; send button `:553`)
- Modify: `lib/src/components/ui/agent_attach_menu.dart` (ctor `:71-83`; trigger `:188-192`)
- Modify: `lib/src/components/ui/questionnaire.dart` (`QuestionnaireChoice` ctor `:673-708`; dim `:764-765`; cursor `:39-45`)
- Modify: `lib/src/components/ui/voice.dart` (`MicControl` ctor `:454`; Button delegate near `:549`)
- Modify: `lib/src/components/ui/agent_transcript.dart` (`WelcomeCard` `:1155`; `_CapabilityGrid` `:1207,1329`)
- Modify: `lib/src/blocks/agent_console/agent_console.dart` (`:552,575,684,861`: pass a reason)
- Test: `test/agent_composer_test.dart`, `test/agent_transcript_test.dart`, `test/agent_console_test.dart` (existing), `test/disabled_state_test.dart` (add)

**Interfaces:**
- Consumes: `Disabled`, `Button.disabledReason`, `DropdownMenu.disabledReason`.
- Produces: `disabledReason: String?` on `AgentComposer`, `AgentAttachMenu`, `QuestionnaireChoice`, `MicControl`, `WelcomeCard`; `AgentConsole` passes `'Connecting…'` (or the existing transport-not-ready copy if one exists in that file; grep `isReady` first) as the reason while `!transport.isReady`.

- [ ] **Step 1: Write the failing test** (append to the same group)

```dart
    testWidgets('agent surfaces carry a reason', (WidgetTester tester) async {
      await tester.pumpWidget(_host(Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        AgentComposer(onSubmit: () {}, disabled: true, disabledReason: 'r-composer'),
        AgentAttachMenu(disabled: true, disabledReason: 'r-attach'),
        MicControl(disabled: true, disabledReason: 'r-mic'),
      ])));
      await tester.pumpAndSettle();
      for (final String s in <String>['r-composer', 'r-attach', 'r-mic']) {
        expect(find.byWidgetPredicate((Widget w) => w is Tooltip && w.label == s), findsOneWidget, reason: s);
      }
    });
```

Match real required parameters (`AgentAttachMenu` and `MicControl` likely need callbacks; read the ctors). `QuestionnaireChoice` needs a `Questionnaire` scope; test it through the existing questionnaire test file pattern instead if a bare pump throws.

- [ ] **Step 2: Run to verify it fails**

Run: `flutter test test/disabled_state_test.dart`
Expected: compile errors on `disabledReason`.

- [ ] **Step 3: Implement**

`agent_composer.dart`: add `disabledReason` to `AgentComposer` and `_ComposerInput`. `_ComposerInput` (`:769-770`): `Disabled(disabled: !widget.enabled, blockPointer: false, reason: widget.disabledReason, child: …)` (`blockPointer: false` keeps the existing read-only tap-to-focus behaviour; keep `AgentComposer.disabledInputOpacity` as the public alias). Pass `disabledReason: widget.disabledReason` to `_ComposerInput` (`:502`) and to `AgentAttachMenu` (`:521`). The send `Button` (`:553`): pass `disabledReason: widget.disabled ? widget.disabledReason : null` so an empty composer does not explain itself, only a disabled one.

`agent_attach_menu.dart` (`:188-192`): wrap the trigger `Button` in `Disabled(disabled: widget.disabled, reason: widget.disabledReason, child: button)`; keep `MenuPointerDown(enabled: !widget.disabled …)`. Add `disabledReason` to the ctor.

`questionnaire.dart` (`:764-765`): replace the `Opacity` with `Disabled(disabled: widget.disabled, blockPointer: false, reason: widget.disabledReason, child: …)`. The choice already nulls `onTap` when disabled; `blockPointer: false` keeps its hover state machine. Keep `QuestionnaireChoice.disabledOpacity` as the alias. Add `disabledReason` to the ctor.

`voice.dart`: `MicControl` gets `disabledReason`; forward `disabledReason: widget.disabledReason` to the delegate `Button` near `:549`.

`agent_transcript.dart`: `WelcomeCard` and `_CapabilityGrid` get `disabledReason`; forward it to each capability `Button`.

`agent_console.dart`: grep the file for the copy used when the transport is not ready; if none, add `static const String notReadyReason = 'Connecting to the agent…';` on `AgentConsole` and pass `disabledReason: disabled ? AgentConsole.notReadyReason : null` at `:552` (composer), `:575` (`_ModelPicker` → its `DropdownMenu` at `:861`) and `:684` (`WelcomeCard`).

Add `import './disabled.dart';` where a `Disabled` is built.

- [ ] **Step 4: Run tests**

Run: `flutter test test/disabled_state_test.dart test/agent_composer_test.dart test/agent_transcript_test.dart test/agent_console_test.dart test/agent_voice_test.dart && flutter analyze`
Expected: pass.

- [ ] **Step 5: Commit**

```bash
git add lib/src/components/ui/agent_composer.dart lib/src/components/ui/agent_attach_menu.dart lib/src/components/ui/questionnaire.dart lib/src/components/ui/voice.dart lib/src/components/ui/agent_transcript.dart lib/src/blocks/agent_console/agent_console.dart test/disabled_state_test.dart
git commit -m "feat: agent surfaces dim through Disabled with disabledReason"
```

---

### Task 8: Guard, registry, changelog, full verification

**Files:**
- Modify: `test/disabled_state_test.dart` (`'the token'` group)
- Modify: `CHANGELOG.md` (Unreleased section)
- Regenerate: `registry/generated/latest/registry.json` (and anything else the builder writes)

**Interfaces:** none new.

- [ ] **Step 1: Write the guard test** (append to the `'the token'` group)

```dart
    test('no component dims itself outside Disabled', () {
      // `Opacity(opacity: enabled ? 1 : SurfaceOpacity.disabled)` was the
      // pattern that drifted; now it is a build failure.
      final RegExp dim = RegExp(r'opacity:\s*[^,;)]*(SurfaceOpacity\.disabled|[Dd]isabledOpacity|disabledInputOpacity)');
      final List<String> offenders = <String>[];
      for (final File file in Directory('lib/src').listSync(recursive: true).whereType<File>()) {
        if (!file.path.endsWith('.dart') || file.path.endsWith('disabled.dart')) continue;
        final List<String> lines = file.readAsLinesSync();
        for (int i = 0; i < lines.length; i++) {
          if (dim.hasMatch(lines[i])) offenders.add('${file.path}:${i + 1}');
        }
      }
      expect(offenders, isEmpty, reason: 'dim through Disabled, not a private Opacity');
    });

    test('every disableable component takes disabledReason', () {
      const Map<String, String> classes = <String, String>{
        'button.dart': 'class Button ', 'input.dart': 'class Input ', 'textarea.dart': 'class Textarea ',
        'input_otp.dart': 'class InputOtp ', 'input_group.dart': 'class InputGroup ',
        'checkbox.dart': 'class Checkbox ', 'switch.dart': 'class Switch ', 'radio.dart': 'class RadioGroupItem',
        'toggle.dart': 'class Toggle ', 'toggle_group.dart': 'class ToggleGroupItem', 'slider.dart': 'class Slider ',
        'stat.dart': 'class Stat ', 'select.dart': 'class Select<', 'native_select.dart': 'class NativeSelect<',
        'combobox.dart': 'class Combobox', 'command.dart': 'class CommandItem', 'menu.dart': 'class MenuItem ',
        'dropdown_menu.dart': 'class DropdownMenu ', 'agent_composer.dart': 'class AgentComposer ',
        'agent_attach_menu.dart': 'class AgentAttachMenu ', 'questionnaire.dart': 'class QuestionnaireChoice',
        'voice.dart': 'class MicControl', 'agent_transcript.dart': 'class WelcomeCard', 'field.dart': 'class Field ',
      };
      final List<String> missing = <String>[];
      classes.forEach((String file, String marker) {
        final String src = File('lib/src/components/ui/$file').readAsStringSync();
        final int at = src.indexOf(marker);
        final int end = src.indexOf('\nclass ', at + 1);
        final String body = src.substring(at, end < 0 ? src.length : end);
        if (!body.contains('final String? disabledReason;')) missing.add('$file:$marker');
      });
      expect(missing, isEmpty);
    });
```

If a marker string does not match the real class declaration (generics, `abstract`), fix the marker, not the class.

- [ ] **Step 2: Run the guard**

Run: `flutter test test/disabled_state_test.dart`
Expected: pass. Any offender listed is a site a previous task missed; convert it with the recipe and rerun.

- [ ] **Step 3: Rebuild and validate the registry**

```powershell
dart run tool/registry_builder/bin/build.dart .
dart run tool/registry_builder/bin/validate.dart registry/generated/latest/registry.json
```
Expected: validate prints success; `git status` shows changes only under `registry/generated/latest`.

- [ ] **Step 4: CHANGELOG**

Under the Unreleased heading in `CHANGELOG.md` add:

```markdown
### Added
- `Disabled` — the one wrapper every control dims through (`SurfaceOpacity.disabled`, pointer block, cursor, reason tooltip, disabled-tap hook).
- `disabledReason` on every disableable component and on `Field`; shows as a tooltip on hover or touch tap while disabled.
- `Form.revealFirstError()` validates, scrolls the first invalid field to the centre of the screen and focuses it. `Form.submit()` now uses it.
- `FormScope`; a disabled `Button` below it reveals the first error when tapped. `Button.onDisabledPressed` overrides that.

### Changed
- Textarea, Stat and AgentAttachMenu now dim and block input like every other disabled control.
```

- [ ] **Step 5: Full verification**

Run: `flutter analyze && flutter test`
Expected: analyzer clean, every test passes. Paste the final summary line of `flutter test` into the commit body.

- [ ] **Step 6: Commit**

```bash
git add test/disabled_state_test.dart CHANGELOG.md registry/generated/latest
git commit -m "test: guard every dim through Disabled; regenerate registry; changelog"
```

---

## Self-review

- Spec coverage: shared 50% class → Task 1 + guard in Task 8; applied to all disabled variants → Tasks 3–7 (sites from the survey table); tooltip on hover and mobile tap, hidden when unset → Task 1 (`Disabled.reason`, `Tooltip` touch path) and every `disabledReason` param; form CTA scroll-to-centre with error shown → Task 2 (`revealFirstError`, `alignment: 0.5`, `validate()` first) + Task 3 (`FormScope` auto-wire on `Button`).
- Placeholder scan: constructor argument lists in tests are marked "match the real ctor" because signatures were not all read; that is an instruction to read the file, not a TBD.
- Type consistency: `Disabled(disabled, child, reason, onDisabledTap, blockPointer, duration)`; `Form.revealFirstError({validateFirst})`; `FormScope(form, child)`, `FormScope.maybeOf`; `Button.onDisabledPressed`; `disabledReason` everywhere. Consistent across tasks.
