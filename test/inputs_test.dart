import 'dart:async';
// `Tristate` is a `dart:ui` type that `package:flutter/semantics.dart` does not
// re-export; `SemanticsNode.flagsCollection` hands one back for every
// three-state flag.
import 'dart:ui' show Tristate;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// The text-entry and field layer: `DsInput`'s widening, `DsTextarea`,
/// `DsInputGroup`, `DsInputOtp`, the `DsField` family, and the validator.
///
/// State matrices are pinned against `inputs-map.md` §12 and `forms-map.md` §3
/// and §5 — the tables, not the specimens. Nothing here measures a glyph, so
/// none of it depends on the real font binaries being loaded.

Widget host(
  Widget child, {
  DsThemeMode mode = DsThemeMode.dark,
  bool reducedMotion = false,
}) {
  return MediaQuery(
    data: MediaQueryData(
      size: const Size(1440, 900),
      disableAnimations: reducedMotion,
    ),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: DsTheme(
        controller: DsThemeController(mode: mode),
        child: Center(child: child),
      ),
    ),
  );
}

/// The surface a component paints itself on, scoped so a group's own socket is
/// not mistaken for its control's.
DsMachineSurface surfaceIn(WidgetTester t, Finder of) => t.widget<DsMachineSurface>(
      find.descendant(of: of, matching: find.byType(DsMachineSurface)).first,
    );

Color borderOf(DsMachineSurface surface) => (surface.border! as Border).top.color;

/// The one focus/error ring a field ever paints, or null when it paints none.
DsShadowLayer? ringOf(DsMachineSurface surface) {
  final List<DsShadowLayer> outer = surface.spec.layers
      .where((DsShadowLayer l) => !l.inset)
      .toList(growable: false);
  if (outer.isEmpty) return null;
  final DsShadowLayer first = outer.first;
  return first.spread == 3 && first.blur == 0 ? first : null;
}

void main() {
  // ───────────────────────────────────────────────────────────────────────────
  // The validator — forms-map §5
  // ───────────────────────────────────────────────────────────────────────────

  group('DsRule — the Zod-4 email predicate, verbatim', () {
    test('accepts what the reference accepts', () {
      for (final String address in <String>[
        'collector@pulls.xyz',
        'you@example.com',
        "o'brien+tag@sub.domain.co.uk",
        'a.b@c.dd',
      ]) {
        expect(DsRule.emailPattern.hasMatch(address), isTrue, reason: address);
      }
    });

    test('is stricter than HTML5 in exactly the four documented ways', () {
      // No bare TLD — `a@b` is accepted by a browser's own type="email".
      expect(DsRule.emailPattern.hasMatch('a@b'), isFalse);
      // No leading dot.
      expect(DsRule.emailPattern.hasMatch('.a@b.cc'), isFalse);
      // No consecutive dots, anywhere.
      expect(DsRule.emailPattern.hasMatch('a..b@c.dd'), isFalse);
      // A TLD is two letters or more.
      expect(DsRule.emailPattern.hasMatch('a@b.c'), isFalse);
    });

    test('rejects the page\'s own failing specimens', () {
      // The state grid's Error cell, and the validation section's field 1.
      expect(DsRule.emailPattern.hasMatch('not-an-email'), isFalse);
      expect(DsRule.emailPattern.hasMatch('collector@pulls'), isFalse);
      expect(DsRule.emailPattern.hasMatch('a b@c.dd'), isFalse);
      expect(DsRule.emailPattern.hasMatch(''), isFalse);
    });
  });

  group('DsRules — collection', () {
    // accountSchema.handle, verbatim (forms-map §5.1).
    final List<DsRule<String>> handle = <DsRule<String>>[
      DsRule.minLength(3, 'At least 3 characters.'),
      DsRule.maxLength(20, 'No more than 20 characters.'),
      DsRule.pattern(
        RegExp(r'^[a-z0-9_]+$'),
        'Lowercase letters, numbers and underscores only.',
      ),
    ];

    test('firstError renders every row of the account table', () {
      // forms-map §5.3 — Zod runs all string checks in declaration order
      // without aborting, so `min` precedes `max` precedes `regex`.
      const Map<String, String?> table = <String, String?>{
        '': 'At least 3 characters.',
        'ab': 'At least 3 characters.',
        'AB': 'At least 3 characters.',
        'Ayoub': 'Lowercase letters, numbers and underscores only.',
        'ayoub!': 'Lowercase letters, numbers and underscores only.',
        'ayoub_9': null,
      };
      for (final MapEntry<String, String?> row in table.entries) {
        final List<String> issues = DsRules.check<String>(row.key, handle);
        expect(issues, row.value == null ? isEmpty : <String>[row.value!],
            reason: '"${row.key}"');
      }
      expect(
        DsRules.check<String>('a' * 21, handle),
        <String>['No more than 20 characters.'],
      );
    });

    test('firstError truncates a value that fails two checks at once', () {
      // `""` raises too_small AND invalid_format; only the first renders.
      expect(DsRules.check<String>('', handle).length, 1);
      expect(
        DsRules.check<String>('', handle, mode: DsIssueMode.all).length,
        2,
        reason: 'criteriaMode "all" keeps both',
      );
    });

    test('all renders the password form\'s four-message list', () {
      // passwordSchema, verbatim (forms-map §5.1 / §5.4).
      final List<DsRule<String>> password = <DsRule<String>>[
        DsRule.minLength(10, 'At least 10 characters.'),
        DsRule.pattern(RegExp(r'[A-Z]'), 'One capital letter.'),
        DsRule.pattern(RegExp(r'[0-9]'), 'One number.'),
        DsRule.pattern(RegExp(r'[^A-Za-z0-9]'), 'One symbol.'),
      ];
      List<String> check(String v) =>
          DsRules.check<String>(v, password, mode: DsIssueMode.all);

      expect(check('a'), <String>[
        'At least 10 characters.',
        'One capital letter.',
        'One number.',
        'One symbol.',
      ]);
      expect(check('abcdefghij'), <String>[
        'One capital letter.',
        'One number.',
        'One symbol.',
      ]);
      expect(check('Abcdefghij'), <String>['One number.', 'One symbol.']);
      expect(check('Abcdefghi1'), <String>['One symbol.']);
      expect(check('Abcdefghi1!'), isEmpty);
    });

    test('dedupe keeps the first occurrence, in order', () {
      expect(
        DsRules.dedupe(<String>['b', 'a', 'b', 'c', 'a']),
        <String>['b', 'a', 'c'],
      );
    });

    test('accepted and oneOf carry the composed schema', () {
      // `terms` is `.refine(v => v)`, not `z.literal(true)`.
      final DsRule<bool> terms = DsRule.accepted('You have to accept the terms.');
      expect(terms.issue(false), 'You have to accept the terms.');
      expect(terms.issue(true), isNull);

      // `z.enum(["daily","weekly"])` — Zod 4 applies the message to the
      // invalid-TYPE case too, which is how `undefined` renders it.
      final DsRule<String?> payout = DsRule.oneOf<String>(
        <String>['daily', 'weekly'],
        'Pick a payout rhythm.',
      );
      expect(payout.issue(null), 'Pick a payout rhythm.');
      expect(payout.issue('monthly'), 'Pick a payout rhythm.');
      expect(payout.issue('weekly'), isNull);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // The form controller — forms-map §3.4, §5.2, §5.5
  // ───────────────────────────────────────────────────────────────────────────

  group('DsForm', () {
    DsForm accountForm() => DsForm(
          fields: <DsFormFieldBase>[
            DsTextFormField(
              name: 'handle',
              rules: <DsRule<String>>[
                DsRule.minLength(3, 'At least 3 characters.'),
              ],
            ),
            DsTextFormField(
              name: 'email',
              rules: <DsRule<String>>[
                DsRule.email('That is not an email address.'),
              ],
            ),
          ],
        );

    test('onSubmit asks nothing until submit, then asks on every edit', () {
      final DsForm form = accountForm();
      addTearDown(form.dispose);

      form.text('handle').controller.text = 'a';
      expect(form['handle'].errors, isEmpty,
          reason: 'mode onSubmit — the first ask is the submit');

      expect(form.validate(), isFalse);
      expect(form['handle'].errors, <String>['At least 3 characters.']);

      form.submit();
      form.text('handle').controller.text = 'ayo';
      expect(form['handle'].errors, isEmpty,
          reason: 'reValidateMode onChange — every keystroke from here on');
    });

    test('onChange asks from the first keystroke', () {
      final DsForm form = DsForm(
        mode: DsValidateMode.onChange,
        fields: <DsFormFieldBase>[
          DsTextFormField(
            name: 'password',
            issueMode: DsIssueMode.all,
            rules: <DsRule<String>>[
              DsRule.minLength(10, 'At least 10 characters.'),
              DsRule.pattern(RegExp(r'[A-Z]'), 'One capital letter.'),
            ],
          ),
        ],
      );
      addTearDown(form.dispose);

      form.text('password').controller.text = 'a';
      expect(form['password'].errors, <String>[
        'At least 10 characters.',
        'One capital letter.',
      ]);
    });

    test('the composed form fails exactly three fields at its defaults', () {
      // forms-map §5.5, pressing Save Preferences untouched.
      final DsForm form = DsForm(
        fields: <DsFormFieldBase>[
          DsFormField<String>(
            name: 'plan',
            initialValue: '',
            rules: <DsRule<String>>[DsRule.minLength(1, 'Pick a plan.')],
          ),
          DsFormField<String?>(
            name: 'payout',
            initialValue: null,
            rules: <DsRule<String?>>[
              DsRule.oneOf<String>(
                <String>['daily', 'weekly'],
                'Pick a payout rhythm.',
              ),
            ],
          ),
          DsTextFormField(
            name: 'bio',
            rules: <DsRule<String>>[
              DsRule.maxLength(160, '160 characters is the ceiling.'),
            ],
          ),
          DsFormField<bool>(name: 'alerts', initialValue: true),
          DsFormField<bool>(
            name: 'terms',
            initialValue: false,
            rules: <DsRule<bool>>[
              DsRule.accepted('You have to accept the terms.'),
            ],
          ),
        ],
      );
      addTearDown(form.dispose);

      expect(form.validate(), isFalse);
      expect(form['plan'].errors, <String>['Pick a plan.']);
      expect(form['payout'].errors, <String>['Pick a payout rhythm.']);
      expect(form['bio'].errors, isEmpty);
      expect(form['alerts'].errors, isEmpty);
      expect(form['terms'].errors, <String>['You have to accept the terms.']);
    });

    testWidgets('focus-on-error lands on the first invalid field — every type',
        (WidgetTester t) async {
      // Ruling F4. On the reference this is a complete no-op in the composed
      // form, because `plan` is a hand-wired Select with no DOM ref. Here the
      // first invalid field in registration order is focused whatever it is.
      final DsForm form = DsForm(
        fields: <DsFormFieldBase>[
          DsFormField<bool>(name: 'alerts', initialValue: true),
          DsFormField<String>(
            name: 'plan',
            initialValue: '',
            rules: <DsRule<String>>[DsRule.minLength(1, 'Pick a plan.')],
          ),
          DsTextFormField(
            name: 'bio',
            rules: <DsRule<String>>[DsRule.minLength(1, 'Say something.')],
          ),
        ],
      );
      addTearDown(form.dispose);

      // The nodes have to be in a tree to take focus.
      await t.pumpWidget(host(Column(
        children: <Widget>[
          for (final DsFormFieldBase field in form.fields)
            Focus(focusNode: field.focusNode, child: const SizedBox(height: 8)),
        ],
      )));

      await form.submit();
      await t.pump();

      expect(form['plan'].focusNode.hasFocus, isTrue,
          reason: 'the first INVALID field, not the first field');
      expect(form['alerts'].focusNode.hasFocus, isFalse);
      expect(form['bio'].focusNode.hasFocus, isFalse);
    });

    testWidgets('setError does not focus — shouldFocus is not passed',
        (WidgetTester t) async {
      final DsForm form = accountForm();
      addTearDown(form.dispose);

      await t.pumpWidget(host(Column(
        children: <Widget>[
          for (final DsFormFieldBase field in form.fields)
            Focus(focusNode: field.focusNode, child: const SizedBox(height: 8)),
        ],
      )));

      form.setError('handle', 'That handle is taken.');
      await t.pump();

      expect(form['handle'].errors, <String>['That handle is taken.']);
      expect(form['handle'].focusNode.hasFocus, isFalse);
    });

    test('a server error is cleared by the next edit', () {
      final DsForm form = accountForm();
      addTearDown(form.dispose);

      form.submit();
      form.setError('handle', 'That handle is taken.');
      form.text('handle').controller.text = 'voidwing';
      expect(form['handle'].errors, isEmpty,
          reason: 'reValidateMode onChange overwrites what setError stored');
    });

    test('isSubmitting is held for the duration of onValid', () async {
      final DsForm form = accountForm();
      addTearDown(form.dispose);
      form.text('handle').controller.text = 'voidwing';
      form.text('email').controller.text = 'you@example.com';

      final Completer<void> gate = Completer<void>();
      final Future<bool> pending = form.submit(() => gate.future);
      expect(form.isSubmitting, isTrue);
      gate.complete();
      expect(await pending, isTrue);
      expect(form.isSubmitting, isFalse);
    });

    test('a failed submit never runs onValid', () async {
      final DsForm form = accountForm();
      addTearDown(form.dispose);
      bool ran = false;
      expect(await form.submit(() => ran = true), isFalse);
      expect(ran, isFalse);
      expect(form.isSubmitting, isFalse);
    });

    test('a text field keeps its controller and its value in step', () {
      final DsTextFormField field = DsTextFormField(
        name: 'handle',
        initialValue: 'voidwing',
      );
      addTearDown(field.dispose);

      expect(field.controller.text, 'voidwing');
      field.controller.text = 'ayoub';
      expect(field.value, 'ayoub');
      field.reset();
      expect(field.value, 'voidwing');
      expect(field.controller.text, 'voidwing');
    });

    test('an unknown field name names what is declared', () {
      final DsForm form = accountForm();
      addTearDown(form.dispose);
      expect(
        () => form['nope'],
        throwsA(isA<StateError>().having(
          (StateError e) => e.message,
          'message',
          allOf(contains('handle'), contains('email')),
        )),
      );
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // DsInput — the widening, and the alpha fix
  // ───────────────────────────────────────────────────────────────────────────

  group('DsInput', () {
    Widget field({
      String? initialValue,
      bool invalid = false,
      bool readOnly = false,
      FocusNode? focusNode,
      DsTypeSpec? textSpec,
      DsThemeMode mode = DsThemeMode.dark,
    }) =>
        host(
          SizedBox(
            width: 384,
            child: DsInput(
              initialValue: initialValue,
              invalid: invalid,
              readOnly: readOnly,
              focusNode: focusNode,
              textSpec: textSpec,
              placeholder: 'Search packs',
            ),
          ),
          mode: mode,
        );

    testWidgets('selects at 35%, the same alpha as every other surface',
        (WidgetTester t) async {
      // Ruling I10. `globals.css:1007` and the example app's own
      // DefaultSelectionStyle both say 0.35; this field said 0.30.
      await t.pumpWidget(field());
      final EditableText editable =
          t.widget<EditableText>(find.byType(EditableText));
      expect(
        editable.selectionColor,
        DsThemeData.dark.primary.withValues(alpha: 0.35),
      );
    });

    testWidgets('initialValue seeds the field it owns', (WidgetTester t) async {
      await t.pumpWidget(field(initialValue: 'Eclipse Vault'));
      expect(find.text('Eclipse Vault'), findsOneWidget);
      expect(find.text('Search packs'), findsNothing);
    });

    testWidgets('aria-invalid paints destructive and ERASES the focus ring',
        (WidgetTester t) async {
      // Ruling F5 / forms-map §3.3, measured: the `aria-invalid:` rules are
      // emitted after the `focus-visible:` ones at equal specificity, so a
      // focused invalid field is pixel-identical to an unfocused one.
      final FocusNode node = FocusNode();
      addTearDown(node.dispose);
      await t.pumpWidget(field(invalid: true, focusNode: node));
      await t.pump(DsDurations.base);
      await t.pump(DsDurations.base);

      final DsThemeData dark = DsThemeData.dark;
      final DsMachineSurface rest = surfaceIn(t, find.byType(DsInput));
      expect(borderOf(rest), dark.destructive);
      expect(ringOf(rest)!.color(dark).a, closeTo(0.20, 1e-6));

      node.requestFocus();
      await t.pump();
      await t.pump(DsDurations.base);
      await t.pump(DsDurations.base);

      final DsMachineSurface focused = surfaceIn(t, find.byType(DsInput));
      expect(borderOf(focused), dark.destructive,
          reason: 'no --primary/50 border — invalid wins');
      expect(ringOf(focused)!.color(dark).a, closeTo(0.20, 1e-6),
          reason: 'no ring-ring/35 — invalid wins');
      // The socket is untouched either way.
      expect(focused.spec.insetLayers, DsShadows.pressed.insetLayers);
    });

    testWidgets('the invalid ring has no dark variant on the bare field',
        (WidgetTester t) async {
      // inputs-map drift 6: 20% in BOTH themes here, where a group rings at 40
      // on dark.
      for (final DsThemeMode mode in <DsThemeMode>[
        DsThemeMode.dark,
        DsThemeMode.light,
      ]) {
        await t.pumpWidget(field(invalid: true, mode: mode));
        await t.pump(DsDurations.base);
        await t.pump(DsDurations.base);
        final DsThemeData theme = mode == DsThemeMode.dark
            ? DsThemeData.dark
            : DsThemeData.light;
        expect(
          ringOf(surfaceIn(t, find.byType(DsInput)))!.color(theme).a,
          closeTo(0.20, 1e-6),
          reason: '$mode',
        );
      }
    });

    testWidgets('the value inherits its colour, the way `color: inherit` does',
        (WidgetTester t) async {
      // Preflight gives inputs `color: inherit` and the component never
      // overrides it. That is what carries `Field`'s invalid colouring into the
      // typed text, and what the Read-only state cell's `text-muted-foreground`
      // rides.
      await t.pumpWidget(host(DefaultTextStyle(
        style: TextStyle(color: DsThemeData.dark.mutedForeground),
        child: const SizedBox(
          width: 384,
          child: DsInput(initialValue: '0xA71c…4F2b', readOnly: true),
        ),
      )));
      expect(
        t.widget<EditableText>(find.byType(EditableText)).style.color,
        DsThemeData.dark.mutedForeground,
      );
    });

    testWidgets('a type class collapses to 13px, keeping everything else',
        (WidgetTester t) async {
      // Ruling I7 / inputs-map §4.3 and drift 8.
      await t.pumpWidget(field(textSpec: DsComponentType.inputNum));
      final TextStyle style =
          t.widget<EditableText>(find.byType(EditableText)).style;
      expect(style.fontSize, 13, reason: 'text-sm beats .type-num, 15 → 13');
      expect(style.fontFamily, contains('GeistMono'));
      expect(style.fontFeatures, contains(const FontFeature.tabularFigures()));
      expect(style.letterSpacing, closeTo(-0.01 * 13, 1e-9));
    });

    testWidgets('bare paints no surface at all', (WidgetTester t) async {
      await t.pumpWidget(host(const SizedBox(
        width: 384,
        child: DsInput(placeholder: 'x', bare: true),
      )));
      expect(
        find.descendant(
          of: find.byType(DsInput),
          matching: find.byType(DsMachineSurface),
        ),
        findsNothing,
        reason: 'border-0 shadow-none ring-0 bg-transparent leaves nothing',
      );
    });

    testWidgets('publishes aria-invalid as a validation result',
        (WidgetTester t) async {
      final SemanticsHandle handle = t.ensureSemantics();

      await t.pumpWidget(host(const SizedBox(
        width: 384,
        child: DsInput(label: 'Email', hint: 'That is not an email address.',
            invalid: true),
      )));

      final SemanticsNode node = t.getSemantics(find.byType(DsInput));
      expect(node.validationResult, SemanticsValidationResult.invalid);
      // Trailing newline: the node merges [EditableText]'s own empty label in,
      // and `SemanticsConfiguration` joins labels with one. It is one node,
      // which is the contract.
      expect(node.label.trim(), 'Email');
      expect(node.hint, 'That is not an email address.');
      handle.dispose();
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // DsTextarea — inputs-map §5.1, §12.3
  // ───────────────────────────────────────────────────────────────────────────

  group('DsTextarea', () {
    testWidgets('is an 80px minimum on the radius ladder, not a pill',
        (WidgetTester t) async {
      await t.pumpWidget(host(const SizedBox(
        width: 512,
        child: DsTextarea(placeholder: 'Anything the packing team should know'),
      )));

      final DsMachineSurface surface = surfaceIn(t, find.byType(DsTextarea));
      expect(surface.radius, BorderRadius.circular(DsRadii.lg),
          reason: 'rounded-lg 12 — the family\'s one non-pill member');
      expect(surface.fill, DsThemeData.dark.card);
      expect(surface.spec, same(DsShadows.pressed));
      expect(t.getSize(find.byType(DsTextarea)).height, DsTextarea.minHeight);
      expect(DsTextarea.minHeight, ds(20));
      expect(DsTextarea.insets, EdgeInsets.symmetric(horizontal: ds(3.5), vertical: ds(2.5)));
    });

    testWidgets('grows with its content and has no ceiling',
        (WidgetTester t) async {
      await t.pumpWidget(host(const SizedBox(width: 512, child: DsTextarea())));
      final double floor = t.getSize(find.byType(DsTextarea)).height;
      expect(floor, DsTextarea.minHeight);

      await t.enterText(find.byType(EditableText), 'a\nb\nc\nd\ne\nf\ng\nh');
      await t.pump();
      expect(t.getSize(find.byType(DsTextarea)).height, greaterThan(floor),
          reason: 'field-sizing: content, with min-h-20 as the floor only');
    });

    testWidgets('types at leading-relaxed, which the input does not',
        (WidgetTester t) async {
      await t.pumpWidget(host(const SizedBox(width: 512, child: DsTextarea())));
      final TextStyle style =
          t.widget<EditableText>(find.byType(EditableText)).style;
      expect(style.fontSize, 13);
      expect(style.height, DsComponentType.textareaBody.height);
      expect(style.fontSize! * style.height!, closeTo(21.125, 1e-6),
          reason: 'leading-relaxed 1.625 on 13px');
    });

    testWidgets('disabled keeps the pointer — no pointer-events-none',
        (WidgetTester t) async {
      // inputs-map §5.1: the textarea's disabled list omits what the input's
      // carries, so it still shows `cursor-not-allowed` for a pointer the
      // input would have refused.
      await t.pumpWidget(host(const SizedBox(
        width: 512,
        child: DsTextarea(enabled: false),
      )));
      final MouseRegion region = t.widget<MouseRegion>(
        find.descendant(
          of: find.byType(DsTextarea),
          matching: find.byType(MouseRegion),
        ).first,
      );
      expect(region.cursor, SystemMouseCursors.forbidden);
      expect(
        t.widget<Opacity>(find.descendant(
          of: find.byType(DsTextarea),
          matching: find.byType(Opacity),
        ).first).opacity,
        0.45,
        reason: 'the field\'s own 45, not a group\'s 50',
      );
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // DsInputGroup — inputs-map §4.2, §12.2
  // ───────────────────────────────────────────────────────────────────────────

  group('DsInputGroup', () {
    Widget group({
      Widget? start,
      Widget? end,
      bool invalid = false,
      bool enabled = true,
      FocusNode? focusNode,
      DsThemeMode mode = DsThemeMode.dark,
    }) =>
        host(
          SizedBox(
            width: 512,
            child: DsInputGroup(
              startAddon: start,
              endAddon: end,
              invalid: invalid,
              enabled: enabled,
              focusNode: focusNode,
              child: const DsInputGroupInput(placeholder: 'x'),
            ),
          ),
          mode: mode,
        );

    EdgeInsetsDirectional controlInsets(WidgetTester t) => t
        .widget<Padding>(find.descendant(
          of: find.byType(DsInputGroupInput),
          matching: find.byWidgetPredicate(
            (Widget w) => w is Padding && w.padding is EdgeInsetsDirectional,
          ),
        ).first)
        .padding as EdgeInsetsDirectional;

    testWidgets('is a 40px pill in a permanent socket', (WidgetTester t) async {
      await t.pumpWidget(group());
      expect(t.getSize(find.byType(DsInputGroup)).height, ds(10));
      final DsMachineSurface surface = surfaceIn(t, find.byType(DsInputGroup));
      expect(surface.radius, BorderRadius.circular(DsRadii.pill));
      expect(surface.fill, DsThemeData.dark.card);
      expect(borderOf(surface), DsThemeData.dark.input);
      expect(surface.spec, same(DsShadows.pressed));
    });

    testWidgets('focus is the BUTTON\'s recipe, not the bare field\'s',
        (WidgetTester t) async {
      // inputs-map §12.2: border `--ring` and ring at 50%, where a bare Input
      // uses `--primary`@50% and 35%.
      final FocusNode node = FocusNode();
      addTearDown(node.dispose);
      await t.pumpWidget(group(focusNode: node));

      node.requestFocus();
      await t.pump();
      await t.pump(DsDurations.base);
      await t.pump(DsDurations.base);

      final DsThemeData dark = DsThemeData.dark;
      final DsMachineSurface surface = surfaceIn(t, find.byType(DsInputGroup));
      expect(borderOf(surface), dark.ring);
      expect(ringOf(surface)!.color(dark).a, closeTo(0.50, 1e-6));
    });

    testWidgets('the invalid ring DOES split by theme — 20 light, 40 dark',
        (WidgetTester t) async {
      // inputs-map drift 6, the other half: the same error state is two
      // different reds depending on whether an addon happens to be present.
      const Map<DsThemeMode, double> expected = <DsThemeMode, double>{
        DsThemeMode.light: 0.20,
        DsThemeMode.dark: 0.40,
      };
      for (final MapEntry<DsThemeMode, double> row in expected.entries) {
        await t.pumpWidget(group(invalid: true, mode: row.key));
        await t.pump(DsDurations.base);
        await t.pump(DsDurations.base);
        final DsThemeData theme = row.key == DsThemeMode.dark
            ? DsThemeData.dark
            : DsThemeData.light;
        final DsMachineSurface surface = surfaceIn(t, find.byType(DsInputGroup));
        expect(borderOf(surface), theme.destructive);
        expect(ringOf(surface)!.color(theme).a, closeTo(row.value, 1e-6),
            reason: '${row.key}');
      }
    });

    testWidgets('disabled fades to 50, not the field\'s 45',
        (WidgetTester t) async {
      await t.pumpWidget(group(enabled: false));
      expect(
        t.widget<Opacity>(find.descendant(
          of: find.byType(DsInputGroup),
          matching: find.byType(Opacity),
        ).first).opacity,
        0.50,
      );
    });

    testWidgets('the clearance rule drops 16 to 8, on that side only',
        (WidgetTester t) async {
      // inputs-map §4.2 — the table of nine fields, reduced to its four shapes.
      await t.pumpWidget(group());
      expect(controlInsets(t).start, ds(4));
      expect(controlInsets(t).end, ds(4));

      await t.pumpWidget(group(
        start: const DsInputGroupAddon(child: DsInputGroupText(r'$')),
      ));
      expect(controlInsets(t).start, ds(2), reason: 'has-[inline-start]');
      expect(controlInsets(t).end, ds(4), reason: 'only that side changes');

      await t.pumpWidget(group(
        end: const DsInputGroupAddon(
          align: DsInputGroupAlign.end,
          child: DsInputGroupText('packs'),
        ),
      ));
      expect(controlInsets(t).start, ds(4));
      expect(controlInsets(t).end, ds(2));

      await t.pumpWidget(group(
        start: const DsInputGroupAddon(child: DsInputGroupText(r'$')),
        end: const DsInputGroupAddon(
          align: DsInputGroupAlign.end,
          child: DsInputGroupText('USD'),
        ),
      ));
      expect(controlInsets(t).start, ds(2));
      expect(controlInsets(t).end, ds(2));

      // `py-1` survives the strip — only the horizontal padding is contested.
      expect(controlInsets(t).top, ds(1));
      expect(controlInsets(t).bottom, ds(1));
    });

    testWidgets('an addon holding a button pulls back 2px', (WidgetTester t) async {
      // `has-[>button]:-ml-0.5` — 16 becomes 14.
      await t.pumpWidget(group(
        start: const DsInputGroupAddon(child: DsInputGroupText('@')),
      ));
      EdgeInsetsDirectional addonInsets() => t
          .widget<Padding>(find.descendant(
            of: find.byType(DsInputGroupAddon),
            matching: find.byWidgetPredicate(
              (Widget w) => w is Padding && w.padding is EdgeInsetsDirectional,
            ),
          ).first)
          .padding as EdgeInsetsDirectional;
      expect(addonInsets().start, ds(4));

      await t.pumpWidget(group(
        start: DsInputGroupAddon(
          child: DsInputGroupButton(child: const Text('Apply'), onPressed: () {}),
        ),
      ));
      expect(addonInsets().start, ds(4) - ds(0.5));
    });

    testWidgets('addon text computes 13px at an 18.5714px line box',
        (WidgetTester t) async {
      // *(Measured on the live reference.)* Ruling I7's collapse, seen
      // directly: `text-sm` is a utility carrying the surviving stock
      // `--text-sm--line-height`, so it beats `.type-num`'s 15px AND its 1.2.
      await t.pumpWidget(group(
        end: const DsInputGroupAddon(
          align: DsInputGroupAlign.end,
          child: DsInputGroupText('packs'),
        ),
      ));
      final TextStyle style = t
          .widget<Text>(find.descendant(
            of: find.byType(DsInputGroupText),
            matching: find.byType(Text),
          ).first)
          .style!;
      expect(style.fontSize, 13);
      expect(style.fontSize! * style.height!, closeTo(18.5714, 1e-3));
      expect(style.color, DsThemeData.dark.mutedForeground);
    });

    testWidgets('a numeric addon keeps the mono treatment and loses the size',
        (WidgetTester t) async {
      await t.pumpWidget(group(
        start: DsInputGroupAddon(
          child: DsInputGroupText('+1', spec: DsComponentType.inputNum),
        ),
      ));
      final TextStyle style = t
          .widget<Text>(find.descendant(
            of: find.byType(DsInputGroupText),
            matching: find.byType(Text),
          ).first)
          .style!;
      expect(style.fontSize, 13, reason: 'type-num-sm\'s 12 does not survive');
      expect(style.fontFamily, contains('GeistMono'));
      expect(style.fontSize! * style.height!, closeTo(18.5714, 1e-3));
    });

    testWidgets('an addon click focuses the control', (WidgetTester t) async {
      await t.pumpWidget(group(
        start: const DsInputGroupAddon(child: DsInputGroupText('@')),
      ));
      expect(t.widget<EditableText>(find.byType(EditableText)).focusNode.hasFocus,
          isFalse);

      await t.tap(find.byType(DsInputGroupAddon));
      await t.pump();
      expect(t.widget<EditableText>(find.byType(EditableText)).focusNode.hasFocus,
          isTrue);
    });
  });

  group('DsInputGroupButton', () {
    testWidgets('is 24px tall on the only derived corner in the system',
        (WidgetTester t) async {
      await t.pumpWidget(host(DsInputGroupButton(
        onPressed: () {},
        child: const Text('Apply'),
      )));

      expect(t.getSize(find.byType(DsInputGroupButton)).height, ds(6));
      expect(DsInputGroupButton.paddingX, ds(1.5));
      expect(DsInputGroupButton.gap, ds(1));

      final DsMachineSurface surface =
          surfaceIn(t, find.byType(DsInputGroupButton));
      expect(surface.radius, BorderRadius.circular(DsRadii.addonButton));
      // `calc(var(--radius) - 3px)` with `--radius` at 10 in both themes.
      expect(DsRadii.addonButton, 7);
      expect(DsRadii.addonButton, DsRadii.md - 3);
      // `shadow-none` at rest.
      expect(surface.spec, same(DsShadows.none));
    });

    testWidgets('publishes aria-pressed as a toggled state',
        (WidgetTester t) async {
      final SemanticsHandle handle = t.ensureSemantics();

      await t.pumpWidget(host(DsInputGroupButton(
        onPressed: () {},
        label: 'Hide password',
        toggled: true,
        child: const SizedBox.square(dimension: 14),
      )));

      final SemanticsNode node = t.getSemantics(find.byType(DsInputGroupButton));
      expect(node.label, 'Hide password');
      expect(node.flagsCollection.isToggled, Tristate.isTrue);
      handle.dispose();
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // DsInputOtp — inputs-map §6
  // ───────────────────────────────────────────────────────────────────────────

  group('DsInputOtp', () {
    Widget otp({
      String? initialValue,
      FocusNode? focusNode,
      bool reducedMotion = false,
      DsThemeMode mode = DsThemeMode.dark,
      Key? key,
    }) =>
        host(
          DsInputOtp(
            // `initialValue` is `defaultValue`: read once, when the field
            // builds its own controller. A test that re-pumps with a different
            // seed has to re-key, or it keeps the first one — which is the
            // attribute behaving correctly, not a bug to work around.
            key: key,
            initialValue: initialValue,
            focusNode: focusNode,
          ),
          mode: mode,
          reducedMotion: reducedMotion,
        );

    testWidgets('the strip is 96 + 16 + 96 = 208', (WidgetTester t) async {
      await t.pumpWidget(otp());
      expect(t.getSize(find.byType(DsInputOtp)), Size(208, ds(8)));
      expect(DsInputOtp.slotSize, ds(8));
      expect(DsInputOtp.separatorWidth, 16);
      expect(find.byType(DsInputOtpSlot), findsNWidgets(6));
      expect(find.byType(DsInputOtpSeparator), findsOneWidget);
      for (int i = 0; i < 6; i++) {
        expect(t.getSize(find.byType(DsInputOtpSlot).at(i)), const Size(32, 32));
      }
    });

    testWidgets('adjacent slots share one hairline', (WidgetTester t) async {
      await t.pumpWidget(otp());
      // Slots are painted in group order with the active one last; at rest that
      // is left to right, so `.at(0)` is the group's first.
      final Finder opener = find.byWidgetPredicate(
        (Widget w) => w is DsInputOtpSlot && w.first,
      );
      expect(opener, findsNWidgets(2), reason: 'one per group');
      final DsMachineSurface surface = t.widget<DsMachineSurface>(
        find.descendant(
          of: opener.first,
          matching: find.byType(DsMachineSurface),
        ).first,
      );
      final Border border = surface.border! as Border;
      expect(border.left, isNot(BorderSide.none),
          reason: 'first:border-l');
      expect(surface.radius.topLeft, Radius.circular(DsRadii.lg),
          reason: 'first:rounded-l-lg');
      expect(surface.radius.topRight, Radius.zero,
          reason: 'every inner corner is square');
    });

    testWidgets('both demos are static at rest — no ring, no caret',
        (WidgetTester t) async {
      // inputs-map drift 16: the active ring and the caret are focus-only, and
      // nothing on the page autofocuses.
      await t.pumpWidget(otp(initialValue: '4082'));
      for (int i = 0; i < 6; i++) {
        expect(t.widget<DsInputOtpSlot>(find.byType(DsInputOtpSlot).at(i)).active,
            isFalse);
      }
      expect(find.byType(DsKeyframePlayer), findsNothing);
    });

    testWidgets('focus lands the ring where the package puts the selection',
        (WidgetTester t) async {
      // onFocus: setSelectionRange(min(value.length, maxLength - 1), length).
      const Map<String, int> table = <String, int>{
        '': 0, // empty → [0,0] → slot 0
        '4082': 4, // partially filled → [4,4] → slot 4
        '408215': 5, // full → [5,6] → slot 5, NOT past the end
      };
      for (final MapEntry<String, int> row in table.entries) {
        final FocusNode node = FocusNode();
        await t.pumpWidget(otp(
          key: ValueKey<String>(row.key),
          initialValue: row.key,
          focusNode: node,
        ));
        node.requestFocus();
        // Two frames: the first applies the focus change and marks the strip
        // dirty from the focus listener, the second rebuilds it.
        await t.pump();
        await t.pump();

        final Iterable<DsInputOtpSlot> slots = t
            .widgetList<DsInputOtpSlot>(find.byType(DsInputOtpSlot))
            .where((DsInputOtpSlot s) => s.active);
        expect(slots.length, 1, reason: '"${row.key}"');
        // The caret is drawn only where the active slot is empty.
        expect(slots.single.showsCaret, row.key.length < 6, reason: row.key);
        node.dispose();
      }
    });

    testWidgets('the caret is a 16×1 square wave — 500 on, 500 off',
        (WidgetTester t) async {
      final FocusNode node = FocusNode();
      addTearDown(node.dispose);
      await t.pumpWidget(otp(focusNode: node));
      node.requestFocus();
      await t.pump();
      await t.pump();

      expect(find.byType(DsKeyframePlayer), findsOneWidget);
      final Finder rule = find.descendant(
        of: find.byType(DsKeyframePlayer),
        matching: find.byType(ColoredBox),
      );
      expect(t.getSize(rule), Size(DsWidths.hairline, ds(4)));
      expect(t.widget<ColoredBox>(rule).color, DsThemeData.dark.foreground);

      double opacity() => t
          .widget<Opacity>(find
              .descendant(
                of: find.byType(DsKeyframePlayer),
                matching: find.byType(Opacity),
              )
              .first)
          .opacity;

      // Lit for the first half of the 1000ms cycle, dark for the second, with
      // a hard cut and no fade at either end.
      expect(opacity(), 1);
      await t.pump(const Duration(milliseconds: 400));
      expect(opacity(), 1);
      await t.pump(const Duration(milliseconds: 200));
      expect(opacity(), 0);
      await t.pump(const Duration(milliseconds: 300));
      expect(opacity(), 0);
    });

    testWidgets('reduced motion leaves the caret steady and visible',
        (WidgetTester t) async {
      // `anim-caret` declares no fill mode, so the blanket reduced-motion rule
      // reverts it to the element's own resting style: opacity 1 (§6.3).
      final FocusNode node = FocusNode();
      addTearDown(node.dispose);
      await t.pumpWidget(otp(focusNode: node, reducedMotion: true));
      node.requestFocus();
      await t.pump();
      await t.pump();

      double opacity() => t
          .widget<Opacity>(find
              .descendant(
                of: find.byType(DsKeyframePlayer),
                matching: find.byType(Opacity),
              )
              .first)
          .opacity;

      expect(opacity(), 1);
      await t.pump(const Duration(milliseconds: 900));
      expect(opacity(), 1);
    });

    testWidgets('typing fills the slots left to right', (WidgetTester t) async {
      await t.pumpWidget(otp());
      await t.enterText(find.byType(EditableText), '408');
      await t.pump();
      expect(find.text('4'), findsOneWidget);
      expect(find.text('0'), findsOneWidget);
      expect(find.text('8'), findsOneWidget);
    });

    testWidgets('the value cannot exceed maxLength', (WidgetTester t) async {
      await t.pumpWidget(otp());
      await t.enterText(find.byType(EditableText), '40821599');
      await t.pump();
      expect(
        t.widget<EditableText>(find.byType(EditableText)).controller.text,
        '408215',
      );
    });

    testWidgets('the digits are not mono', (WidgetTester t) async {
      // inputs-map drift 13: the section description says "using the numerical
      // mono foundation" and the slot is `text-sm` — Inter 13/400.
      await t.pumpWidget(otp(initialValue: '4'));
      // Scoped to the painted box: the hidden overlay carries the same string.
      final TextStyle style = t
          .widget<Text>(find.descendant(
            of: find.byType(DsInputOtpSlot),
            matching: find.text('4'),
          ))
          .style!;
      expect(style.fontFamily, contains('InterLocal'));
      expect(style.fontSize, 13);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // The field layer — forms-map §3.2, inputs-map §7.1
  // ───────────────────────────────────────────────────────────────────────────

  group('DsField', () {
    testWidgets('the stack is 20 between fields and 8 inside one',
        (WidgetTester t) async {
      await t.pumpWidget(host(SizedBox(
        width: 512,
        child: DsFieldGroup(children: <Widget>[
          const DsField(label: 'Username', child: DsInput()),
          const DsField(label: 'Email', child: DsInput()),
        ]),
      )));

      expect(DsFieldGroup.gap, ds(5));
      expect(DsFieldGroup.nestedGap, ds(4));
      expect(DsField.gap, ds(2));

      final double first = t.getBottomLeft(find.byType(DsField).at(0)).dy;
      final double second = t.getTopLeft(find.byType(DsField).at(1)).dy;
      expect(second - first, ds(5));

      final double labelBottom =
          t.getBottomLeft(find.byType(DsFieldLabel).first).dy;
      final double controlTop = t.getTopLeft(find.byType(DsInput).first).dy;
      expect(controlTop - labelBottom, ds(2));
    });

    testWidgets('the description tucks 4px closer once an error appears',
        (WidgetTester t) async {
      // forms-map §3.2, measured: `last:mt-0` becomes `nth-last-2:-mt-1` the
      // moment FieldError stops returning null.
      Future<double> gapWith(List<String> errors) async {
        await t.pumpWidget(host(SizedBox(
          width: 512,
          child: DsField(
            label: 'Shipping note',
            description: 'Grows as you type.',
            errors: errors,
            child: const DsInput(),
          ),
        )));
        return t.getTopLeft(find.byType(DsFieldDescription)).dy -
            t.getBottomLeft(find.byType(DsInput)).dy;
      }

      expect(await gapWith(const <String>[]), ds(2));
      expect(await gapWith(const <String>['Please provide 20 characters.']),
          ds(1));
      expect(DsField.describedGap, ds(1));
    });

    testWidgets('an error is a live region; a valid field builds none',
        (WidgetTester t) async {
      final SemanticsHandle handle = t.ensureSemantics();

      await t.pumpWidget(host(const SizedBox(
        width: 512,
        child: DsField(label: 'Email', child: DsInput()),
      )));
      expect(find.byType(DsFieldError), findsNothing,
          reason: 'FieldError returns null when valid — not an empty region');

      await t.pumpWidget(host(const SizedBox(
        width: 512,
        child: DsField(
          label: 'Email',
          errors: <String>['That address is missing a domain.'],
          child: DsInput(),
        ),
      )));
      final SemanticsNode node = t.getSemantics(find.byType(DsFieldError));
      expect(node.flagsCollection.isLiveRegion, isTrue);
      handle.dispose();
    });

    testWidgets('two messages render as a list, deduped, indented 16',
        (WidgetTester t) async {
      await t.pumpWidget(host(const SizedBox(
        width: 512,
        child: DsFieldError(<String>[
          'One capital letter.',
          'One number.',
          'One capital letter.',
        ]),
      )));

      expect(find.text('•'), findsNWidgets(2), reason: 'deduped to two');
      expect(DsFieldError.listIndent, ds(4));
      expect(DsFieldError.itemGap, ds(1));

      final double textLeft = t.getTopLeft(find.text('One capital letter.')).dx;
      final double errorLeft = t.getTopLeft(find.byType(DsFieldError)).dx;
      expect(textLeft - errorLeft, ds(4), reason: 'ml-4 on the list');

      // EVERY item lands on the declared box, marker included — bare, each one
      // quantized on its own and a four-message password error drifted by
      // nearly two pixels. Two items at 18.5714 with one 4px gap between them.
      expect(
        t.getSize(find.byType(DsFieldError)).height,
        closeTo(18.5714 * 2 + ds(1), 1e-3),
        reason: 'the list is exactly its items plus its gaps',
      );
    });

    testWidgets('one message renders as a bare string', (WidgetTester t) async {
      await t.pumpWidget(host(const SizedBox(
        width: 512,
        child: DsFieldError(<String>['That address is missing a domain.']),
      )));
      expect(find.text('•'), findsNothing);
      expect(find.text('That address is missing a domain.'), findsOneWidget);
    });

    testWidgets('the field publishes ONE node: name, hint, validation result',
        (WidgetTester t) async {
      // inputs-map §7.2 — `<label for>`, `aria-describedby` and `aria-invalid`
      // collapsed into what a screen reader actually announces.
      final SemanticsHandle handle = t.ensureSemantics();

      await t.pumpWidget(host(const SizedBox(
        width: 512,
        child: DsField(
          label: 'Email',
          description: 'Receipts and nothing else.',
          errors: <String>['That is not an email address.'],
          child: DsInput(),
        ),
      )));

      final SemanticsNode node = t.getSemantics(find.byType(DsInput));
      expect(node.label.trim(), 'Email',
          reason: 'the visible label names the control');
      expect(node.hint,
          'Receipts and nothing else. That is not an email address.',
          reason: 'describedby order: description first, then the message');
      expect(node.validationResult, SemanticsValidationResult.invalid);
      handle.dispose();
    });

    testWidgets('the field marks itself invalid, not only its control',
        (WidgetTester t) async {
      // A control that does not read DsFieldScope — everything another owner
      // builds, until it does — still lands inside a node announced as
      // invalid, because the field states it too.
      final SemanticsHandle handle = t.ensureSemantics();

      await t.pumpWidget(host(const SizedBox(
        width: 512,
        child: DsField(
          label: 'Plan',
          errors: <String>['Pick a plan.'],
          child: SizedBox(width: 44, height: 24, key: Key('opaque')),
        ),
      )));

      expect(
        t.getSemantics(find.byKey(const Key('opaque'))).validationResult,
        SemanticsValidationResult.invalid,
      );
      handle.dispose();
    });

    testWidgets('the scope reaches the control on BOTH orientations',
        (WidgetTester t) async {
      // REGRESSION: the horizontal branch once put the bare `child` in its Row
      // where the vertical branch put the scope-wrapped control, so a
      // horizontal field published no DsFieldScope at all. That is the branch
      // the switch and the checkbox live on — the two composed-form controls
      // focus-on-error has to reach — so the failure was invisible and landed
      // exactly where it hurt. Both orientations are asserted together so
      // neither can drift from the other again.
      for (final DsFieldOrientation orientation in DsFieldOrientation.values) {
        final FocusNode node = FocusNode(debugLabel: orientation.name);
        addTearDown(node.dispose);
        DsFieldScope? seen;

        await t.pumpWidget(host(SizedBox(
          width: 512,
          child: DsField(
            key: ValueKey<DsFieldOrientation>(orientation),
            label: 'Price alerts',
            description: 'Only for the packs you follow.',
            errors: const <String>['You have to accept the terms.'],
            enabled: false,
            focusNode: node,
            orientation: orientation,
            child: Builder(builder: (BuildContext c) {
              seen = DsFieldScope.maybeOf(c);
              return const SizedBox(width: 44, height: 24);
            }),
          ),
        )));

        final String why = orientation.name;
        expect(seen, isNotNull,
            reason: '$why publishes no DsFieldScope — nothing under it can '
                'adopt a label, a describedby, a disabled state or a node');
        expect(seen!.label, 'Price alerts', reason: why);
        expect(
          seen!.describedBy,
          'Only for the packs you follow. You have to accept the terms.',
          reason: why,
        );
        expect(seen!.invalid, isTrue, reason: why);
        expect(seen!.enabled, isFalse, reason: why);
        expect(seen!.focusNode, same(node), reason: why);
      }
    });

    testWidgets('a horizontal field\'s control adopts it observably',
        (WidgetTester t) async {
      // The scope being present is one thing; a control actually wearing it is
      // the thing F4 depends on. Focus-on-error requires the control to be on
      // the field's node, and a disabled field has to reach the control.
      final FocusNode node = FocusNode();
      addTearDown(node.dispose);

      await t.pumpWidget(host(SizedBox(
        width: 512,
        child: DsField(
          label: 'Price alerts',
          enabled: false,
          focusNode: node,
          orientation: DsFieldOrientation.horizontal,
          child: const SizedBox(width: 200, child: DsInput()),
        ),
      )));

      final EditableText editable =
          t.widget<EditableText>(find.byType(EditableText));
      expect(editable.focusNode, same(node),
          reason: 'the form\'s node has to land ON the control, or a failed '
              'submit focuses nothing');
      expect(editable.readOnly, isTrue,
          reason: 'a disabled field disables what is inside it');
    });

    testWidgets('the visible label is not announced twice',
        (WidgetTester t) async {
      final SemanticsHandle handle = t.ensureSemantics();

      await t.pumpWidget(host(const SizedBox(
        width: 512,
        child: DsField(label: 'Email', child: DsInput()),
      )));

      final SemanticsNode field = t.getSemantics(find.byType(DsInput));
      // The label widget publishes nothing of its own, so asking for its
      // semantics walks up to the very node the control is on — one node for
      // the whole field, which is the contract.
      expect(t.getSemantics(find.byType(DsFieldLabel)), same(field));
      expect(
        field.label.trim(),
        'Email',
        reason: 'once — a correct <label for> names the input, it is not '
            'read as a separate string beside it',
      );
      handle.dispose();
    });

    testWidgets('tapping the label focuses the control', (WidgetTester t) async {
      final FocusNode node = FocusNode();
      addTearDown(node.dispose);
      await t.pumpWidget(host(SizedBox(
        width: 512,
        child: DsField(
          label: 'Username',
          focusNode: node,
          child: const DsInput(),
        ),
      )));

      expect(node.hasFocus, isFalse);
      // The text, not the label box: `w-fit` is the point, and the box a
      // stretched Column hands the label is 512px of which only the words are
      // a target.
      await t.tap(find.text('Username'));
      await t.pump();
      expect(node.hasFocus, isTrue);
    });

    testWidgets('the label narrows to its text, not to the field\'s measure',
        (WidgetTester t) async {
      // `w-fit` — a click 400px right of "Email" must not focus the input.
      await t.pumpWidget(host(const SizedBox(
        width: 512,
        child: DsField(label: 'Email', child: DsInput()),
      )));
      expect(t.getSize(find.byType(DsField)).width, 512);
      expect(t.getSize(find.text('Email')).width, lessThan(512));
    });

    testWidgets('invalid colours the label and the value, and nothing else',
        (WidgetTester t) async {
      // forms-map §3.2: the label and the typed text inherit and turn; the
      // description and the error declare their own colours and do not.
      await t.pumpWidget(host(const SizedBox(
        width: 512,
        child: DsField(
          label: 'Handle',
          description: 'Shown on live pulls.',
          errors: <String>['At least 3 characters.'],
          child: DsInput(),
        ),
      )));

      final DsThemeData dark = DsThemeData.dark;
      expect(
        t.widget<Text>(find.descendant(
          of: find.byType(DsFieldLabel),
          matching: find.byType(Text),
        ).first).style!.color,
        dark.destructiveInk,
      );
      expect(
        t.widget<EditableText>(find.byType(EditableText)).style.color,
        dark.destructiveInk,
        reason: 'input { color: inherit }',
      );
      expect(
        t.widget<Text>(find.descendant(
          of: find.byType(DsFieldDescription),
          matching: find.byType(Text),
        ).first).style!.color,
        dark.mutedForeground,
        reason: 'explicit text-muted-foreground wins',
      );
    });

    testWidgets('the three line-heights RENDER at three different boxes',
        (WidgetTester t) async {
      // forms-map §3.2 — 17.875 / 19.5 / 18.571 on three consecutive lines.
      //
      // REGRESSION: this once asserted `fontSize × height` off the resolved
      // style — the box the spec DECLARES, which is a restatement of the spec
      // and cannot fail. The label and the error were meanwhile rendering 18.0
      // and 19.0, because a bare `Text` takes the engine's rounded ascent plus
      // descent and quantizes up to the next half pixel. Measuring the
      // RenderBox is the only form of this assertion with teeth.
      await t.pumpWidget(host(const SizedBox(
        width: 512,
        child: DsField(
          label: 'Handle',
          description: 'Shown on live pulls.',
          errors: <String>['At least 3 characters.'],
          child: DsInput(),
        ),
      )));

      /// The box the spec asks for.
      double declared(Finder of) {
        final TextStyle style = t
            .widget<Text>(
                find.descendant(of: of, matching: find.byType(Text)).first)
            .style!;
        return style.fontSize! * style.height!;
      }

      /// The box that actually lays out.
      double rendered(Finder of) => t.getSize(of).height;

      const Map<String, double> boxes = <String, double>{
        'label': 17.875, // 13 × leading-snug 1.375
        'description': 19.5, // 13 × leading-normal 1.5
        'error': 18.5714, // 13 × text-sm's 1.428571
      };
      final Map<String, Finder> parts = <String, Finder>{
        'label': find.byType(DsFieldLabel),
        'description': find.byType(DsFieldDescription),
        'error': find.byType(DsFieldError),
      };

      for (final MapEntry<String, Finder> part in parts.entries) {
        expect(rendered(part.value), closeTo(boxes[part.key]!, 1e-3),
            reason: part.key);
        // …and it is the box its own spec declares, not a rounding that lands
        // near it.
        expect(rendered(part.value), closeTo(declared(part.value), 1e-3),
            reason: '${part.key} renders its declared box');
      }
    });

    testWidgets('a disabled field disables the control it holds',
        (WidgetTester t) async {
      await t.pumpWidget(host(const SizedBox(
        width: 512,
        child: DsField(label: 'Email', enabled: false, child: DsInput()),
      )));
      expect(
        t.widget<EditableText>(find.byType(EditableText)).readOnly,
        isTrue,
      );
    });

    testWidgets('horizontal puts the label on the slack', (WidgetTester t) async {
      await t.pumpWidget(host(SizedBox(
        width: 512,
        child: DsField(
          label: 'Price alerts',
          orientation: DsFieldOrientation.horizontal,
          child: const SizedBox(width: 44, height: 24, key: Key('switch')),
        ),
      )));
      final Rect label = t.getRect(find.byType(DsFieldLabel));
      final Rect control = t.getRect(find.byKey(const Key('switch')));
      expect(label.left, lessThan(control.left));
      expect(control.width, 44, reason: 'the control keeps its own size');
    });
  });

  group('DsFieldSet', () {
    testWidgets('closes from 16 to 12 around a selection group',
        (WidgetTester t) async {
      expect(DsFieldSet.gap, ds(4));
      expect(DsFieldSet.groupGap, ds(3));
      expect(DsFieldLegend.spaceBelow, ds(1.5));

      await t.pumpWidget(host(SizedBox(
        width: 512,
        child: DsFieldSet(
          tightForGroup: true,
          children: const <Widget>[
            DsFieldLegend('Payout rhythm'),
            SizedBox(height: 20, key: Key('radios')),
          ],
        ),
      )));
      final double legendBottom =
          t.getBottomLeft(find.byType(DsFieldLegend)).dy;
      final double nextTop = t.getTopLeft(find.byKey(const Key('radios'))).dy;
      expect(nextTop - legendBottom, ds(3));

      // The legend is the one spec composed at its call site rather than named
      // in the foundation, so it is the easiest of the four to leave un-boxed:
      // 13 × text-sm's 1.428571, rendered, not declared.
      expect(
        t.getSize(find.byType(DsFieldLegend)).height,
        closeTo(18.5714, 1e-3),
      );
    });
  });
}
