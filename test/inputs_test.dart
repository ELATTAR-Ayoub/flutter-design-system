import 'dart:async';
import 'dart:typed_data';
// `Tristate` is a `dart:ui` type that `package:flutter/semantics.dart` does not
// re-export; `SemanticsNode.flagsCollection` hands one back for every
// three-state flag.
import 'dart:ui' show Tristate;
import 'dart:ui' as ui show Image, ImageByteFormat;

import 'package:elattar_design_system/elattar_design_system.dart';
// `rendering.dart` re-exports `semantics.dart`, and brings `RenderRepaintBoundary`
// for the raster reads.
import 'package:flutter/rendering.dart';
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

/// `src-over`: [top] composited onto opaque [under].
Color _over(Color top, Color under) {
  final double a = top.a;
  return Color.from(
    alpha: 1,
    red: top.r * a + under.r * (1 - a),
    green: top.g * a + under.g * (1 - a),
    blue: top.b * a + under.b * (1 - a),
  );
}

double _luma(Color c) => c.r * 0.2126 + c.g * 0.7152 + c.b * 0.0722;

/// One rasterised pixel column straight down the middle of [child].
///
/// The socket is the one thing in this family that no widget-tree assertion can
/// reach: `DsMachineSurface` paints its inset layers with a [CustomPainter], so
/// what a `DsShadowSpec` *says* and what lands on the canvas are two different
/// claims. This reads the canvas.
Future<List<Color>> _column(
  WidgetTester t,
  Widget child, {
  required DsThemeMode mode,
}) async {
  await t.pumpWidget(host(
    RepaintBoundary(key: const Key('raster'), child: child),
    mode: mode,
  ));
  await t.pump(DsDurations.base);
  await t.pump(DsDurations.base);

  final RenderRepaintBoundary box =
      t.renderObject(find.byKey(const Key('raster')));
  final ui.Image image = (await t.runAsync(() => box.toImage(pixelRatio: 1)))!;
  final ByteData bytes = (await t.runAsync(() async =>
      (await image.toByteData(format: ui.ImageByteFormat.rawRgba))!))!;
  final int w = image.width;
  final int x = w ~/ 2;
  final List<Color> column = <Color>[
    for (int y = 0; y < image.height; y++)
      Color.from(
        alpha: bytes.getUint8((y * w + x) * 4 + 3) / 255,
        red: bytes.getUint8((y * w + x) * 4) / 255,
        green: bytes.getUint8((y * w + x) * 4 + 1) / 255,
        blue: bytes.getUint8((y * w + x) * 4 + 2) / 255,
      ),
  ];
  image.dispose();
  return column;
}

void main() {
  // ───────────────────────────────────────────────────────────────────────────
  // The socket, read off the canvas
  // ───────────────────────────────────────────────────────────────────────────

  group('the socket, rasterised', () {
    /// The colour the interior would be if the inset ring ever collapsed to a
    /// full fill — both `--shadow-pressed` layers at unblurred full coverage.
    ///
    /// `#cacace` on light, and the reason this pin is written as an explicit
    /// anti-assertion rather than left implicit in "the interior is the card":
    /// it names the failure mode, so a future reader of a red test knows what
    /// broke and not merely that something did.
    Color collapsed(DsThemeData theme) =>
        _over(theme.ink3, _over(theme.ink4, theme.card));

    for (final DsThemeMode mode in <DsThemeMode>[
      DsThemeMode.light,
      DsThemeMode.dark,
    ]) {
      final DsThemeData theme = mode == DsThemeMode.light
          ? DsThemeData.light
          : DsThemeData.dark;

      testWidgets('$mode: the interior is the card token, the edges are inset',
          (WidgetTester t) async {
        final List<Color> column = await _column(
          t,
          const SizedBox(width: 120, child: DsInput()),
          mode: mode,
        );
        expect(column.length, DsInput.height.round());

        // The socket darkens the EDGES and leaves the fill alone. Anything
        // that inverts the ring paints the complement of this.
        for (int y = 10; y <= 30; y++) {
          expect(column[y], theme.card, reason: '$mode interior at y=$y');
        }

        // The band below the border is the inset, and it lightens monotonically
        // inward until it reaches the fill — a falloff, not a step.
        expect(_luma(column[1]), lessThan(_luma(theme.card)),
            reason: '$mode: the top band carries the inset');
        for (int y = 1; y < 7; y++) {
          expect(_luma(column[y]), lessThanOrEqualTo(_luma(column[y + 1])),
              reason: '$mode: the falloff is monotonic at y=$y');
        }
        expect(_luma(column[column.length - 2]),
            lessThan(_luma(theme.card)),
            reason: '$mode: and the bottom band carries it too');

        // The named failure mode, excluded by name.
        expect(collapsed(theme), isNot(theme.card),
            reason: 'the anti-assertion has to be able to fail');
        expect(column[20], isNot(collapsed(theme)),
            reason: '$mode: the inset ring collapsed to a full fill — the '
                'painter filled the clip instead of the band between the '
                'shape and its displaced hole');
      });

      testWidgets('$mode: the textarea wears the identical socket',
          (WidgetTester t) async {
        final List<Color> column = await _column(
          t,
          const SizedBox(width: 120, child: DsTextarea()),
          mode: mode,
        );
        expect(column.length, DsTextarea.minHeight.round());
        for (int y = 20; y <= 60; y++) {
          expect(column[y], theme.card, reason: '$mode interior at y=$y');
        }
        expect(_luma(column[1]), lessThan(_luma(theme.card)));
        expect(column[40], isNot(collapsed(theme)));
      });
    }
  });

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

    testWidgets('horizontal is CONTROL first, label on the slack',
        (WidgetTester t) async {
      // All three horizontal fields on the reference put the control in the DOM
      // before its label — a radio, a switch and a checkbox each sit at the
      // LEFT of their row — and `*:data-[slot=field-label]:flex-auto` grows the
      // label into what is left. This pin once said label-first, which is what
      // sent the forms page off to hand-compose its own row.
      await t.pumpWidget(host(SizedBox(
        width: 512,
        child: DsField(
          label: 'Price alerts',
          orientation: DsFieldOrientation.horizontal,
          child: const SizedBox(width: 44, height: 24, key: Key('switch')),
        ),
      )));

      final Rect field = t.getRect(find.byType(DsField));
      final Rect label = t.getRect(find.byType(DsFieldLabel));
      final Rect control = t.getRect(find.byKey(const Key('switch')));

      expect(control.left, lessThan(label.left),
          reason: 'the control comes first');
      expect(control.left, field.left, reason: 'and sits at the row\'s edge');
      expect(control.width, 44, reason: 'the control keeps its own size');
      expect(label.left - control.right, DsField.gap);
      // `flex-auto`: the label takes every remaining pixel, which is what makes
      // the rest of the row a target.
      expect(label.right, field.right);
    });

    testWidgets('a label tap ACTIVATES the control, it does not just focus it',
        (WidgetTester t) async {
      // `<label for=id>` forwards a click: tapping "I accept the terms" ticks
      // the checkbox. The control says what activation means by registering on
      // the scope's DsFieldActivator; the label calls it.
      //
      // The control here is a checkbox-shaped stub rather than `DsCheckbox`,
      // because registration lives in each control's own build and those files
      // belong to another owner — this pins THIS side of the contract, which is
      // the half that has to exist before the other half can be written.
      bool checked = false;
      int focused = 0;
      final FocusNode node = FocusNode();
      addTearDown(node.dispose);
      node.addListener(() {
        if (node.hasFocus) focused++;
      });

      await t.pumpWidget(host(StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) => SizedBox(
          width: 512,
          child: DsField(
            label: 'I accept the terms',
            focusNode: node,
            orientation: DsFieldOrientation.horizontal,
            child: Builder(builder: (BuildContext inner) {
              DsFieldScope.maybeOf(inner)?.activator?.callback =
                  () => setState(() => checked = !checked);
              return const SizedBox(width: 16, height: 16);
            }),
          ),
        ),
      )));

      await t.tap(find.text('I accept the terms'));
      await t.pump();
      expect(checked, isTrue, reason: 'the tap toggled, it did not focus');
      expect(focused, 0);

      await t.tap(find.text('I accept the terms'));
      await t.pump();
      expect(checked, isFalse, reason: 'and it toggles back');
    });

    testWidgets('a control that registers nothing still gets focused',
        (WidgetTester t) async {
      // A text control's activation IS focus, so it registers nothing and the
      // ladder falls through to the scope's node.
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

      await t.tap(find.text('Username'));
      await t.pump();
      expect(node.hasFocus, isTrue);
    });

    testWidgets('the label yields to a handler the caller supplies',
        (WidgetTester t) async {
      // A scope with neither activator nor node: the label attaches no
      // recogniser at all, so an ancestor's wins the arena instead of losing to
      // an inner one. This is what lets a call site compose its own row.
      int outer = 0;
      final FocusNode node = FocusNode();
      addTearDown(node.dispose);

      await t.pumpWidget(host(SizedBox(
        width: 512,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => outer++,
          child: DsFieldScope(
            label: 'Price alerts',
            child: DsFieldLabel('Price alerts', focusNode: null),
          ),
        ),
      )));

      await t.tap(find.text('Price alerts'));
      await t.pump();
      expect(outer, 1, reason: 'the ancestor took the tap');
      expect(node.hasFocus, isFalse);
    });

    testWidgets('an explicit onTap outranks both rungs below it',
        (WidgetTester t) async {
      int taps = 0;
      final FocusNode node = FocusNode();
      addTearDown(node.dispose);

      await t.pumpWidget(host(SizedBox(
        width: 512,
        child: DsField(
          label: 'Plan',
          focusNode: node,
          child: DsFieldLabel('Plan', onTap: () => taps++),
        ),
      )));

      await t.tap(find.text('Plan').last);
      await t.pump();
      expect(taps, 1);
      expect(node.hasFocus, isFalse, reason: 'onTap replaced the focus rung');
    });
  });

  group('DsFieldSet', () {
    testWidgets('a leading legend clears by 6, not by 6 plus the set\'s gap',
        (WidgetTester t) async {
      // *(Oracle-confirmed on the forms page.)* CSS lifts a rendered `<legend>`
      // out of the fieldset's anonymous flex content box, so the box's own
      // `gap` never applies to it and only its `mb-1.5` does. This pin once
      // asserted the set's gap here, which is the bug.
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
            SizedBox(height: 20, key: Key('message')),
          ],
        ),
      )));

      expect(
        t.getTopLeft(find.byKey(const Key('radios'))).dy -
            t.getBottomLeft(find.byType(DsFieldLegend)).dy,
        ds(1.5),
        reason: 'only the legend\'s own mb-1.5',
      );
      // …and every other gap in the set is the normal one.
      expect(
        t.getTopLeft(find.byKey(const Key('message'))).dy -
            t.getBottomLeft(find.byKey(const Key('radios'))).dy,
        ds(3),
        reason: 'the content box keeps its gap-3',
      );

      // The legend is the one spec composed at its call site rather than named
      // in the foundation, so it is the easiest of the four to leave un-boxed:
      // 13 × text-sm's 1.428571, rendered, not declared.
      expect(
        t.getSize(find.byType(DsFieldLegend)).height,
        closeTo(18.5714, 1e-3),
      );
    });

    testWidgets('without a legend every gap is the normal one',
        (WidgetTester t) async {
      await t.pumpWidget(host(SizedBox(
        width: 512,
        child: DsFieldSet(
          children: const <Widget>[
            SizedBox(height: 20, key: Key('a')),
            SizedBox(height: 20, key: Key('b')),
          ],
        ),
      )));
      expect(
        t.getTopLeft(find.byKey(const Key('b'))).dy -
            t.getBottomLeft(find.byKey(const Key('a'))).dy,
        ds(4),
      );
    });
  });

  /* ── USER-ORDERED MOBILE ADAPTATION ──────────────────────────────────────
     The field family keeps itself out from behind the software keyboard.
     Nothing here translates the reference: a browser scrolls a focused input
     back into its own shrunken visual viewport and this layer has to do it by
     hand. What is pinned is the rule and its price — the rule works on a phone,
     and it costs a desktop frame exactly nothing.                          */

  group('DsFieldVisibility — a focused field is never behind the keyboard', () {
    /// The phone the order names.
    const Size phone = Size(375, 812);

    /// A software keyboard of the height the order names.
    const double keyboard = 300;

    /// The spacer above and below the field. At rest the field's box is content
    /// y 700–740, which on an 812pt window is **on screen** and squarely behind
    /// a 300pt keyboard — the exact shape of the reported bug.
    const double lead = 700;

    /// Where the keyboard's top edge falls: 512.
    final double keyboardTop = phone.height - keyboard;

    Future<void> pumpPage(
      WidgetTester t, {
      required ScrollController controller,
      required double viewInsetsBottom,
      required Widget field,
    }) async {
      t.view.devicePixelRatio = 1;
      t.view.physicalSize = phone;
      addTearDown(t.view.reset);

      await t.pumpWidget(MediaQuery(
        data: MediaQueryData(
          size: phone,
          viewInsets: EdgeInsets.only(bottom: viewInsetsBottom),
        ),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: DsTheme(
            controller: DsThemeController(mode: DsThemeMode.dark),
            child: SingleChildScrollView(
              controller: controller,
              child: Column(
                children: <Widget>[
                  const SizedBox(height: lead),
                  SizedBox(width: 320, child: field),
                  const SizedBox(height: lead),
                ],
              ),
            ),
          ),
        ),
      ));
    }

    testWidgets('focusing one deep in a scroller lifts it clear of the keyboard',
        (WidgetTester t) async {
      final FocusNode node = FocusNode();
      final ScrollController controller = ScrollController();
      await pumpPage(
        t,
        controller: controller,
        viewInsetsBottom: keyboard,
        field: DsInput(focusNode: node),
      );

      // The bug, reproduced first: on screen by the viewport's reckoning, and
      // 228px of it behind the keyboard.
      expect(controller.offset, 0);
      expect(t.getRect(find.byType(DsInput)).bottom, lead + DsInput.height);
      expect(lead + DsInput.height, greaterThan(keyboardTop));

      node.requestFocus();
      await t.pump();
      await t.pumpAndSettle();

      // Lifted to sit exactly one margin above the keyboard's top edge, and no
      // further: the reveal is the minimum scroll that clears it.
      final Rect field = t.getRect(find.byType(DsInput));
      expect(field.bottom, closeTo(keyboardTop - DsFieldVisibility.margin, 0.01));
      expect(
        controller.offset,
        closeTo(lead + DsInput.height - keyboardTop + DsFieldVisibility.margin, 0.01),
      );
      // Still whole — a reveal that clipped the top of the field would be no
      // better than the keyboard covering the bottom of it.
      expect(field.top, greaterThanOrEqualTo(0));
    });

    testWidgets('with no keyboard on screen it does not move a pixel',
        (WidgetTester t) async {
      final FocusNode node = FocusNode();
      final ScrollController controller = ScrollController();
      await pumpPage(
        t,
        controller: controller,
        viewInsetsBottom: 0,
        field: DsInput(focusNode: node),
      );

      final Rect before = t.getRect(find.byType(DsInput));
      node.requestFocus();
      await t.pump();
      await t.pumpAndSettle();

      // The desktop guarantee, stated as an equality rather than a tolerance:
      // `viewInsets.bottom == 0` is the gate on every path in the mechanism.
      expect(controller.offset, 0);
      expect(t.getRect(find.byType(DsInput)), before);
    });

    testWidgets('a keyboard that opens AFTER the focus still lifts it',
        (WidgetTester t) async {
      // The real device order: the tap focuses the field, and the keyboard
      // animates in a moment later. Focus alone is not the trigger, so this is
      // the path that does the work on a phone.
      final FocusNode node = FocusNode();
      final ScrollController controller = ScrollController();
      await pumpPage(
        t,
        controller: controller,
        viewInsetsBottom: 0,
        field: DsInput(focusNode: node),
      );

      node.requestFocus();
      await t.pump();
      await t.pumpAndSettle();
      expect(controller.offset, 0, reason: 'no keyboard yet, nothing to avoid');

      // Same tree, same state, same focus — only the inset changed.
      await pumpPage(
        t,
        controller: controller,
        viewInsetsBottom: keyboard,
        field: DsInput(focusNode: node),
      );
      await t.pumpAndSettle();

      expect(node.hasFocus, isTrue);
      expect(
        t.getRect(find.byType(DsInput)).bottom,
        closeTo(keyboardTop - DsFieldVisibility.margin, 0.01),
      );
    });

    testWidgets('a field already in the clear is left alone',
        (WidgetTester t) async {
      final FocusNode node = FocusNode();
      final ScrollController controller = ScrollController();
      await pumpPage(
        t,
        controller: controller,
        viewInsetsBottom: keyboard,
        field: DsInput(focusNode: node),
      );
      // Parked where the field is already whole, already inside its margin and
      // already above the keyboard: the reveal's third branch runs and returns.
      controller.jumpTo(400);
      await t.pumpAndSettle();
      final double parked = controller.offset;
      final Rect resting = t.getRect(find.byType(DsInput));
      expect(resting.bottom, lessThan(keyboardTop));
      expect(resting.top, greaterThan(DsFieldVisibility.margin));

      node.requestFocus();
      await t.pump();
      await t.pumpAndSettle();

      expect(controller.offset, parked);
    });

    testWidgets('every field in the family wears the one hook',
        (WidgetTester t) async {
      // The point of the ruling: the mechanism lives in one place and each
      // control routes through it, so a control added later inherits the
      // behaviour instead of having to remember a rule. If one of these ever
      // stops being wrapped, this fails before a phone does.
      await t.pumpWidget(host(SizedBox(
        width: 320,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const DsInput(),
            const DsTextarea(),
            DsInputOtp(),
          ],
        ),
      )));

      for (final Type field in <Type>[DsInput, DsTextarea, DsInputOtp]) {
        expect(
          find.descendant(
            of: find.byType(field),
            matching: find.byType(DsFieldVisibility),
          ),
          findsOneWidget,
          reason: '$field must route through the shared focus-visibility hook',
        );
      }
    });
  });
}
