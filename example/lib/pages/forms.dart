/// `/design-system/components/base/forms`: four forms, all of them live.
///
/// The first ported page whose reference is `"use client"`, and the first with
/// **no static gallery at all**: nine specimens, six of them interactive, and
/// the fidelity bar is that a reader can type a weak password and watch four
/// bullets appear. Three cells in `#submit-states` are the page's only stills,
/// and one of those is still animating.
///
/// What this page owns and what it borrows: the *composition* is here: four
/// controllers, four rule lists, five hand-wired controls and the toast calls —
/// and every pixel is a package component. `ElForm` / `ElRule` are the
/// `useForm` + Zod pair, `ElField` is the `Field` family, and `ElToaster` is
/// mounted once by the shell (ruling F8) exactly as `<Toaster/>` is mounted once
/// by the root layout.
///
/// **The measure is `max-w-md`, 448px** ([_measureMd]), on all four forms. The
/// inputs page's is `max-w-lg`; these are different rungs of Tailwind's
/// container scale and neither is the spacing ladder.
///
/// ## Divergences: reproduced behaviour the reference does not have
///
/// * **Focus-on-error lands on every field (ruling F4).** `ElForm.submit`
///   focuses the first invalid field in registration order whatever its shape,
///   so submitting the composed form untouched puts focus on the Plan trigger.
///   The reference focuses nothing at all there: see drift 7: because RHF
///   needs a DOM ref and all three failing fields are hand-wired. An invisible
///   accessibility regression is the one drift class this port does not ship.
/// * **`form.reset(values)`** has no single call in the port: `ElForm.reset`
///   goes back to `defaultValues`. [_resetToSavedValues] does what RHF does —
///   reset, then write the saved strings back through the controllers, which at
///   a zeroed submit count re-validates nothing. The account form is therefore
///   back to *asking late* after a successful save, as the reference is.
///
/// ## Observed at the port, and not a drift the reference authored
///
/// **`FieldSet` does not carry the invalid colouring `Field` does.** The
/// composed form writes `data-invalid` on the payout `FieldSet`, but
/// `fieldVariants`' `data-[invalid=true]:text-destructive-ink` lives on `Field`
/// alone (`field.tsx` L10–21 against L53), so the legend and the two radio
/// labels stay muted while every other failing label on the page turns red.
/// Reproduced by leaving that group's ink alone.
///
/// **A `<legend>` is not a flex item.** The measured gap between "Payout
/// rhythm" and the radios is **6px**, not 6 + the fieldset's own `gap-3`: a
/// rendered legend is lifted out of the fieldset's anonymous content box, so
/// only its `mb-1.5` applies. [ElFieldSet] is therefore given the content box's
/// children: the group and its message: and the legend sits above it. That is
/// the CSS box tree, not a workaround.
///
/// ## Drift register: recorded, shipped as written (forms-map §15)
///
/// Where a drift belongs to a component rather than to this page it is recorded
/// at its own source and named here so the register stays complete.
///
/// 1. **The eyebrow says "Base" twice.** `` `${group.title} · Base` `` with
///    `group.title = "Base Components"` → **"Base Components · Base"**. All
///    fourteen base pages; the foundations pages print one clean word.
/// 2. **`Button`'s `loading` JSDoc contradicts every call site.** *"The label
///    stays in place so the button does not change width mid-action"*: yet
///    Save Account → Saving and Claim Handle → Claiming both swap. In the forms
///    the width happens to be pinned by flex `stretch`; in `#submit-states` the
///    buttons are intrinsically sized and Idle and Pending are visibly
///    different widths. Carried by `button.dart`.
/// 3. **The spinner's accessibility attributes are silently dropped.**
///    `spinner.tsx` passes `role="status"` and `aria-label="Loading"` into
///    `Icon`, which destructures five props and spreads nothing, so the glyph
///    renders `aria-hidden`. Carried by `spinner.dart` under ruling B9.
/// 4. **`#validation`'s Note argues against `mode: "onChange"`; `#field-errors`
///    uses it.** *"Validating on the first keystroke tells someone their email
///    is invalid while they are still typing the third character, which is true
///    and useless"*: and the password form two sections later asks on the
///    first keystroke. Defensible, unremarked, and both ship.
/// 5. **The `#validation` Panel label advertises a default as configuration.**
///    Both of the account form's modes are RHF defaults written out longhand,
///    and the Meta beneath calls `mode: "onSubmit"` *"the default, and the right
///    one"* while the label presents both as settings.
/// 6. **`aria-invalid` erases focus.** *(measured)* On an invalid field the
///    destructive border and ring already own both properties the focus ring
///    would set, and they are emitted later at equal specificity: so focusing
///    an errored control produces **no visible change**, against RULES §7's
///    opening line. Ruling F5, carried by `input.dart`, `textarea.dart`,
///    `select.dart` and `selection_control.dart`.
/// 7. **Focus-on-error is a no-op in the composed form.** All three fields that
///    fail at defaults are hand-wired, so RHF finds no ref with a `focus`
///    method. **Not reproduced**: ruling F4, see the divergence above.
/// 8. **The two server-error surfaces have different lifetimes and the copy
///    does not say so.** The Alert survives keystrokes until the next submit;
///    the field error is wiped by the first one, because re-validation runs and
///    `"taken"` passes `min(3)`. Both behaviours ship.
/// 9. **`<Textarea rows={3}/>` is inert.** `field-sizing: content` replaces
///    rows-based sizing and the visible floor is `min-h-20`, 80px, which is
///    roughly three lines by coincidence. Carried by `textarea.dart`.
/// 10. **`SelectContent` ships a dead animation set.** Six animation utilities
///    and four `translate-*` nudges, all cancelled because `position` defaults
///    to `"item-aligned"`. The rendered behaviour is a menu that simply
///    appears. Carried by `select.dart`.
/// 11. **`SelectTrigger`'s `w-fit` never applies.** *(measured)* The vertical
///    `Field`'s `*:w-full` is emitted later at equal specificity and wins, so
///    the trigger renders at the full 448px: which is why the Plan field here
///    passes `expand: true`.
/// 12. **Three line-heights on three consecutive lines.** Label 1.375,
///    description 1.5, error 1.428571: and none of them is `.type-small`'s
///    1.5-at-13px used everywhere else in the kit.
/// 13. **The textarea deviates from its siblings on three axes.**
///    `border-primary/50` not `border-ring`, `ring-ring/35` not `/50`,
///    `opacity-45` not `-50`: it follows `Input` where the other four follow
///    the shadcn default.
/// 14. **`Switch` disables on `data-disabled:`; `Checkbox`, `Radio` and
///    `Select` on `disabled:`.** Same intent, two selector families.
/// 15. **`Checkbox` carries `group-has-disabled/field:opacity-50` and
///    `RadioGroupItem` does not**: a disabled field dims the checkbox and not
///    the radio.
/// 16. **`SelectContent` uses Tailwind's stock `shadow-md`**: the only
///    elevation on the page outside the `--shadow-*` set, fixed black at 10%
///    under a popover whose fill flips with the theme.
/// 17. **`Select` is the only control with `dark:` variants.** Its dark resting
///    fill is `--input` at 30%, not `--card` like every sibling, and its
///    `dark:hover:bg-input/50` is the only hover state any control on this page
///    authors.
/// 18. **No hover state anywhere on a light theme.** The five form controls
///    author none at all; the Select's only one is dark-only.
/// 19. **`AccountForm` appears twice with identical Panel content.**
///    `#form` and `#validation` render the same component; the sections differ
///    only in prose and Panel label. Both are live and independent (ruling F9)
///   : the `#validation` Note's argument is only demonstrable if the second
///    one really asks nothing until you submit.
/// 20. **`alerts` is the one field with no `FormError`**, and `plan`, `payout`
///    and `alerts` are the three with no `FormDescription`: against
///    `#field-errors`' own do, *"Keep FormDescription present while the field is
///    valid; it is the only guidance there."*
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../kit.dart';
import '../nav.dart';
import '../shell.dart';

/* ── Page constants ──────────────────────────────────────────────────────── */

/// `max-w-md`, `--container-md`, 28rem. Tailwind's **container** scale, which
/// `globals.css` does not override, so it is not the spacing ladder even where
/// the two coincide. The measure all four `<form>`s are cut to.
// allow-hardcoded: framework container scale with no token to read it from.
const double _measureMd = 448;

/// `await new Promise(r => setTimeout(r, 900))`: the account form's simulated
/// round trip, and the window its spinner is visible in.
///
/// A page constant, not a duration token: it is a fake network, and putting it
/// on the `--duration-*` scale would let a retimed animation retime a fake
/// network. Same reasoning `toaster.dart` gives for sonner's unmount window.
///
/// The guard scans per line, so the escape sits on the declaration itself.
const Duration _accountLatency = Duration(
  milliseconds: 900,
); // allow-hardcoded: the reference's simulated submit latency, not a --duration-* token

/// `await new Promise(r => setTimeout(r, 800))`: the server form's. See
/// [_accountLatency].
const Duration _serverLatency = Duration(
  milliseconds: 800,
); // allow-hardcoded: the reference's simulated server latency, not a --duration-* token

/* ── Schemas (`page.tsx` L58–93) ─────────────────────────────────────────── */

/// `accountSchema.handle`: three checks, in declaration order.
///
/// Zod 4 runs every string check without aborting and `criteriaMode` is left at
/// `firstError`, so `""` raises `too_small` **and** `invalid_format` and renders
/// only the first of them.
List<ElRule<String>> _handleRules() => <ElRule<String>>[
  ElRule.minLength(3, 'At least 3 characters.'),
  ElRule.maxLength(20, 'No more than 20 characters.'),
  ElRule.pattern(
    RegExp(r'^[a-z0-9_]+$'),
    'Lowercase letters, numbers and underscores only.',
  ),
];

/// `passwordSchema.password`: four checks and `criteriaMode: "all"`, which is
/// the only place in the corpus `FieldError`'s list branch fires.
List<ElRule<String>> _passwordRules() => <ElRule<String>>[
  ElRule.minLength(10, 'At least 10 characters.'),
  ElRule.pattern(RegExp('[A-Z]'), 'One capital letter.'),
  ElRule.pattern(RegExp('[0-9]'), 'One number.'),
  ElRule.pattern(RegExp('[^A-Za-z0-9]'), 'One symbol.'),
];

/* ── Page ────────────────────────────────────────────────────────────────── */

class FormsPage extends StatelessWidget {
  const FormsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ElCategoryHit here = findCategory('base', 'forms');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ElPageHeader(
          // DRIFT 1. The group is already called "Base Components"; the page
          // interpolates a second literal after a U+00B7 anyway.
          eyebrow: '${here.group.title} · Base',
          title: here.category.title,
          blurb: here.category.blurb,
          contents: here.category.contents,
        ),
        const _FormSection(),
        const _ValidationSection(),
        const _FieldErrorsSection(),
        const _SubmitStatesSection(),
        const _ServerErrorsSection(),
        const _ComposedFieldsSection(),
        const ElPageFootNav(groupId: 'base', slug: 'forms'),
      ],
    );
  }
}

/* ── #form ───────────────────────────────────────────────────────────────── */

class _FormSection extends StatelessWidget {
  const _FormSection();

  @override
  Widget build(BuildContext context) {
    return ElSection(
      id: 'form',
      title: 'Form',
      description:
          'React Hook Form for state, Zod for the schema, and the '
          'Field family for everything you can see. form.tsx contributes no '
          'presentation at all — only ids and aria attributes.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const ElPanel(label: 'A whole form, live', child: _AccountForm()),
          // `className="mt-6"` on the Note, the Meta and every DoDont on the
          // page.
          SizedBox(height: el(6)),
          const ElNote(
            title: 'Why there is no FormItem',
            child: _WhyNoFormItemBody(),
          ),
          SizedBox(height: el(6)),
          const ElMeta(
            items: <ElMetaItem>[
              (
                k: 'Form',
                v: TextSpan(
                  text: 'FormProvider. Spread the useForm return into it.',
                ),
              ),
              (
                k: 'FormField',
                v: TextSpan(
                  text:
                      'Controller, plus a useId() so two forms on one page '
                      'cannot collide on ids.',
                ),
              ),
              (
                k: 'FormControl',
                v: TextSpan(
                  text:
                      'A Slot. Stamps id, aria-invalid and aria-describedby '
                      'onto whatever control it wraps — input, trigger, switch '
                      'or checkbox alike.',
                ),
              ),
              (
                k: 'FormLabel / FormDescription / FormError',
                v: TextSpan(
                  text:
                      'FieldLabel / FieldDescription / FieldError, bound to '
                      'this field. Zero added styling.',
                ),
              ),
              (
                k: 'useFormField()',
                v: TextSpan(
                  text:
                      'The ids and fieldState, for anything the three above '
                      'do not cover. Throws outside a FormField.',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Four `Code` chips, one `<em>`, and a U+2019 in "React Hook Form's".
class _WhyNoFormItemBody extends StatelessWidget {
  const _WhyNoFormItemBody();

  @override
  Widget build(BuildContext context) {
    return ElRichText(
      TextSpan(
        children: <InlineSpan>[
          const TextSpan(
            text:
                'Stock shadcn ships a second generation of these primitives '
                '— ',
          ),
          ElCode.span('FormItem'),
          const TextSpan(text: ', '),
          ElCode.span('FormLabel'),
          const TextSpan(text: ', '),
          ElCode.span('FormDescription'),
          const TextSpan(text: ', '),
          ElCode.span('FormMessage'),
          const TextSpan(
            text:
                ' — each carrying its own presentation. This system already '
                'has that presentation in ',
          ),
          ElCode.span('field.tsx'),
          const TextSpan(text: ', whose '),
          ElCode.span('FieldError'),
          const TextSpan(
            text: ' takes React Hook Form’s error shape verbatim. So ',
          ),
          ElCode.span('FormLabel'),
          const TextSpan(text: ' here '),
          const TextSpan(
            text: 'renders',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
          const TextSpan(text: ' '),
          ElCode.span('FieldLabel'),
          const TextSpan(text: ' and adds one attribute: '),
          ElCode.span('htmlFor'),
          const TextSpan(
            text:
                '. Two vocabularies for one idea is what RULES §1.1 forbids; '
                'a binding layer over one vocabulary is not that.',
          ),
        ],
      ),
      ElType.small,
    );
  }
}

/* ── #validation ─────────────────────────────────────────────────────────── */

class _ValidationSection extends StatelessWidget {
  const _ValidationSection();

  @override
  Widget build(BuildContext context) {
    return ElSection(
      id: 'validation',
      title: 'Validation',
      description:
          'The schema is the source of truth. Zod owns what valid '
          'means; React Hook Form owns when the question gets asked.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // DRIFT 19 / ruling F9. The same component as `#form`, live and
          // independent: two controllers, so nothing they hold is shared.
          // DRIFT 5. The label advertises two RHF defaults as configuration;
          // the separator is U+00B7.
          const ElPanel(
            label: 'mode: onSubmit · reValidateMode: onChange',
            child: _AccountForm(),
          ),
          SizedBox(height: el(6)),
          // Not `const`: `.type-small` is resolved at runtime, so the one Note
          // on the page with no chips in it is still a runtime widget.
          ElNote(
            title: 'Validate late, re-validate early',
            // DRIFT 4. This paragraph argues against the mode the next section
            // ships.
            child: ElText(
              'The account form above asks nothing until you submit, then '
              're-checks on every keystroke. Validating on the first keystroke '
              'tells someone their email is invalid while they are still '
              'typing the third character, which is true and useless. Once '
              'they have submitted, they have asked to be told — so from that '
              'point the feedback is immediate.',
              ElType.small,
            ),
          ),
          SizedBox(height: el(6)),
          // The double quotes inside rows 1, 2 and 4 are straight `"` in the
          // source, not the curly pair the Panel labels use.
          const ElMeta(
            items: <ElMetaItem>[
              (
                k: 'mode',
                v: TextSpan(
                  text:
                      '"onSubmit" — the default, and the right '
                      'one.',
                ),
              ),
              (
                k: 'reValidateMode',
                v: TextSpan(
                  text: '"onChange" — after the first failed submit only.',
                ),
              ),
              (
                k: 'resolver',
                v: TextSpan(
                  text:
                      'zodResolver(schema). The schema also types the form: '
                      'z.infer<typeof schema>.',
                ),
              ),
              (
                k: 'criteriaMode',
                v: TextSpan(
                  text:
                      '"all" collects every failing rule into error.types '
                      'instead of only the first.',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/* ── #field-errors ───────────────────────────────────────────────────────── */

class _FieldErrorsSection extends StatelessWidget {
  const _FieldErrorsSection();

  /// The one `DoDont` on the page. Curly quotes in do 2 only; every apostrophe
  /// elsewhere is the straight ASCII one, as the source arrays have them.
  static const List<String> _dos = <String>[
    'Let FormControl stamp the aria wiring — it works on a Select trigger and '
        'a Switch, not only an input.',
    'Write what to do next: “At least 10 characters.” not “Invalid.”',
    'Keep FormDescription present while the field is valid; it is the only '
        'guidance there.',
  ];

  /// Don't 3 carries a five-line `// allow-hardcoded:` block above it in the
  /// source, explaining that the line *names* the anti-pattern in order to
  /// forbid it and that `state-colour-as-text` cannot tell a page teaching a
  /// rule from a page breaking it.
  static const List<String> _donts = <String>[
    'Hand-type id / htmlFor / aria-describedby. It satisfies the rule exactly '
        'as often as someone remembers.',
    'Render an error container that is always mounted and merely empty — a '
        'screen reader announces the region.',
    // allow-hardcoded: this line NAMES the anti-pattern in order to forbid it,
    // exactly as the reference's own escape hatch says.
    'Paint error text with text-destructive. Only -ink carries text, and it is '
        'a different red per theme.',
  ];

  @override
  Widget build(BuildContext context) {
    return ElSection(
      id: 'field-errors',
      title: 'Field errors',
      description:
          'One rule fails, you get a sentence. Several fail, you get '
          'a list — the same component, deciding on its own.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // The em dash is U+2014.
          const ElPanel(
            label: 'criteriaMode: all — type a weak password',
            child: _PasswordForm(),
          ),
          SizedBox(height: el(6)),
          const ElNote(
            title: 'What the wiring actually guarantees',
            child: _WiringGuaranteesBody(),
          ),
          // `<div className="mt-6">` around the DoDont rather than on it.
          SizedBox(height: el(6)),
          const ElDoDont(dos: _dos, donts: _donts),
        ],
      ),
    );
  }
}

class _WiringGuaranteesBody extends StatelessWidget {
  const _WiringGuaranteesBody();

  @override
  Widget build(BuildContext context) {
    return ElRichText(
      TextSpan(
        children: <InlineSpan>[
          const TextSpan(
            text:
                'Every field above ships the three things RULES §7 demands, '
                'and none of them were typed at the call site. The control '
                'carries ',
          ),
          ElCode.span('aria-invalid'),
          const TextSpan(text: ' and an '),
          ElCode.span('aria-describedby'),
          const TextSpan(
            text:
                ' that points at the description while valid and at '
                'description + error once it is not. The error itself is a ',
          ),
          ElCode.span('FieldError'),
          const TextSpan(text: ' with '),
          ElCode.span('role="alert"'),
          const TextSpan(
            text:
                ', and it renders nothing at all when the field is valid '
                'rather than leaving an empty live region behind.',
          ),
        ],
      ),
      ElType.small,
    );
  }
}

/* ── #submit-states ──────────────────────────────────────────────────────── */

/// The only section with no `Panel`: the lattice is the section's direct
/// child.
class _SubmitStatesSection extends StatelessWidget {
  const _SubmitStatesSection();

  @override
  Widget build(BuildContext context) {
    return ElSection(
      id: 'submit-states',
      title: 'Submit states',
      description:
          'Every action needs two signals: the control confirms it '
          'heard you, the outcome confirms it worked.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const _SubmitStates(),
          SizedBox(height: el(6)),
          const ElNote(
            title: 'Both signals, or neither counts',
            child: _BothSignalsBody(),
          ),
        ],
      ),
    );
  }
}

class _BothSignalsBody extends StatelessWidget {
  const _BothSignalsBody();

  @override
  Widget build(BuildContext context) {
    return ElRichText(
      TextSpan(
        children: <InlineSpan>[
          ElCode.span('loading'),
          const TextSpan(
            text:
                ' on the Button is the first signal — it swaps in a spinner, '
                'sets ',
          ),
          ElCode.span('aria-busy'),
          const TextSpan(
            text:
                ' and disables the control, so a slow save cannot be '
                'double-submitted. The toast is the second. A form with only '
                'the spinner leaves you wondering whether it worked; one with '
                'only the toast leaves the click feeling dead for as long as '
                'the request took.',
          ),
        ],
      ),
      ElType.small,
    );
  }
}

/* ── #server-errors ──────────────────────────────────────────────────────── */

class _ServerErrorsSection extends StatelessWidget {
  const _ServerErrorsSection();

  @override
  Widget build(BuildContext context) {
    return ElSection(
      id: 'server-errors',
      title: 'Server errors',
      description:
          'The field is valid and the submit still failed. This is '
          'the state most forms never draw, and the only one your users will '
          'actually hit.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // The quotes around `taken` are U+201C / U+201D.
          const ElPanel(
            label: 'Submit “taken” to fail, anything else to succeed',
            child: _ServerErrorForm(),
          ),
          SizedBox(height: el(6)),
          const ElNote(
            title: 'Two places, because they answer two questions',
            child: _TwoPlacesBody(),
          ),
          SizedBox(height: el(6)),
          const ElMeta(
            items: <ElMetaItem>[
              (
                k: 'setError("root.serverError")',
                v: TextSpan(
                  text:
                      'Form-level. Never sent to the server, cleared on the '
                      'next submit.',
                ),
              ),
              (
                k: 'clearErrors',
                v: TextSpan(
                  text:
                      'Called first on every submit, or the last failure '
                      'outlives the attempt that caused it.',
                ),
              ),
              (
                k: 'formState.errors.root',
                v: TextSpan(
                  text: 'Where root errors land. Not part of your schema type.',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TwoPlacesBody extends StatelessWidget {
  const _TwoPlacesBody();

  @override
  Widget build(BuildContext context) {
    const TextStyle italic = TextStyle(fontStyle: FontStyle.italic);
    return ElRichText(
      TextSpan(
        children: <InlineSpan>[
          ElCode.span('setError("root.serverError")'),
          const TextSpan(text: ' holds what went wrong with the '),
          const TextSpan(text: 'submission', style: italic),
          const TextSpan(
            text:
                ' and renders as an Alert — a persistent condition worth '
                'explaining, which is exactly what RULES §5 reserves Alert '
                'for. ',
          ),
          ElCode.span('setError("handle")'),
          const TextSpan(text: ' holds what is wrong with the '),
          const TextSpan(text: 'field', style: italic),
          const TextSpan(
            text:
                ', so the error sits next to the thing you have to change. A '
                'form that only does the first makes you hunt; one that only '
                'does the second cannot explain a failure that belongs to no '
                'field.',
          ),
        ],
      ),
      ElType.small,
    );
  }
}

/* ── #composed-fields ────────────────────────────────────────────────────── */

class _ComposedFieldsSection extends StatelessWidget {
  const _ComposedFieldsSection();

  @override
  Widget build(BuildContext context) {
    return ElSection(
      id: 'composed-fields',
      title: 'Composed fields',
      // The angle brackets are a JSX string attribute, so they are text.
      description:
          'Select, RadioGroup, Textarea, Switch and Checkbox — none '
          'of them an <input>, all of them wired the same way.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const ElPanel(
            label: 'Five control shapes, one binding',
            child: _ComposedForm(),
          ),
          SizedBox(height: el(6)),
          const ElNote(
            title: 'Why FormControl is a Slot',
            child: _WhyFormControlIsSlotBody(),
          ),
        ],
      ),
    );
  }
}

class _WhyFormControlIsSlotBody extends StatelessWidget {
  const _WhyFormControlIsSlotBody();

  @override
  Widget build(BuildContext context) {
    return ElRichText(
      TextSpan(
        children: <InlineSpan>[
          const TextSpan(
            text:
                'A Slot merges its props onto its child rather than '
                'rendering a wrapper, which is what lets one component carry '
                'the wiring for five controls that share no DOM shape. Note '
                'where it sits on the Select: around the ',
          ),
          ElCode.span('SelectTrigger'),
          const TextSpan(text: ', not the '),
          ElCode.span('Select'),
          const TextSpan(
            text:
                ' — the trigger is the focusable thing, so it is the thing '
                'that needs the id. Controls that are not ',
          ),
          ElCode.span('<input>'),
          const TextSpan(text: ' take '),
          ElCode.span('onValueChange'),
          const TextSpan(text: ' or '),
          ElCode.span('onCheckedChange'),
          const TextSpan(text: ', so they are wired by hand from '),
          ElCode.span('field'),
          const TextSpan(text: ' rather than spread.'),
        ],
      ),
      ElType.small,
    );
  }
}

/* ── 1 · AccountForm: instantiated twice ────────────────────────────────── */

/// `mode: "onSubmit"`, `reValidateMode: "onChange"`, both written out longhand
/// because the `#validation` Panel label prints them (drift 5).
///
/// Two instances, two controllers. The web needs a `useId()` per `FormField`
/// so the two cannot collide on ids; Flutter has no id graph, so two objects
/// are the whole of it.
class _AccountForm extends StatefulWidget {
  const _AccountForm();

  @override
  State<_AccountForm> createState() => _AccountFormState();
}

class _AccountFormState extends State<_AccountForm> {
  late final ElForm _form = ElForm(
    mode: ElValidateMode.onSubmit,
    reValidateMode: ElValidateMode.onChange,
    fields: <ElFormFieldBase>[
      ElTextFormField(name: 'handle', rules: _handleRules()),
      ElTextFormField(
        name: 'email',
        rules: <ElRule<String>>[ElRule.email('That is not an email address.')],
      ),
    ],
  );

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    await _form.submit(() async {
      await Future<void>.delayed(_accountLatency);
      if (!mounted) return;
      docsToasts.success(
        'Saved as @${_form.text('handle').value}',
        glyph: ElIconGlyph.circleCheck,
      );
      _resetToSavedValues(_form);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _form,
      builder: (BuildContext context, Widget? child) {
        final ElTextFormField handle = _form.text('handle');
        final ElTextFormField email = _form.text('email');
        final bool busy = _form.isSubmitting;

        return _Measure(
          child: ElFieldGroup(
            children: <Widget>[
              ElField(
                label: 'Handle',
                description: 'This is how you appear on leaderboards.',
                errors: handle.errors,
                focusNode: handle.focusNode,
                child: ElInput(
                  controller: handle.controller,
                  placeholder: 'ayoub',
                  autofillHints: const <String>[AutofillHints.username],
                ),
              ),
              ElField(
                label: 'Email',
                description: 'Receipts and nothing else.',
                errors: email.errors,
                focusNode: email.focusNode,
                child: ElInput(
                  controller: email.controller,
                  placeholder: 'you@example.com',
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const <String>[AutofillHints.email],
                ),
              ),
              // DRIFT 2. The label swaps and the button would grow by the
              // spinner's 24px: except that `FieldGroup` stretches it to the
              // form's 448px, which pins the width by accident.
              ElButton(
                loading: busy,
                onPressed: _submit,
                child: Text(busy ? 'Saving' : 'Save Account'),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// `form.reset(values)`: the just-saved values become the new baseline.
///
/// `ElForm.reset` goes back to `defaultValues`, which is the one thing RHF's
/// `reset(values)` does *not* do, so the strings are read first and written
/// back through the controllers afterwards. Writing them back at a zeroed
/// submit count re-validates nothing, `mode` governs again: which is exactly
/// the state a reset form is in: values kept, messages gone, asking late.
void _resetToSavedValues(ElForm form) {
  final Map<String, String> saved = <String, String>{
    for (final ElFormFieldBase field in form.fields)
      if (field is ElTextFormField) field.name: field.value,
  };
  form.reset();
  for (final MapEntry<String, String> entry in saved.entries) {
    form.text(entry.key).controller.text = entry.value;
  }
}

/* ── 2 · PasswordForm: the multi-error list ─────────────────────────────── */

/// `criteriaMode: "all"` + `mode: "onChange"`: the only place in the corpus
/// where `FieldError` renders a list rather than a sentence (drift 4).
class _PasswordForm extends StatefulWidget {
  const _PasswordForm();

  @override
  State<_PasswordForm> createState() => _PasswordFormState();
}

class _PasswordFormState extends State<_PasswordForm> {
  late final ElForm _form = ElForm(
    // `mode: "onChange"`: asked on the first keystroke.
    mode: ElValidateMode.onChange,
    fields: <ElFormFieldBase>[
      ElTextFormField(
        name: 'password',
        issueMode: ElIssueMode.all,
        rules: _passwordRules(),
      ),
    ],
  );

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    await _form.submit(
      () => docsToasts.success(
        'Password accepted',
        glyph: ElIconGlyph.circleCheck,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _form,
      builder: (BuildContext context, Widget? child) {
        final ElTextFormField password = _form.text('password');

        return _Measure(
          child: ElFieldGroup(
            children: <Widget>[
              ElField(
                label: 'New password',
                description:
                    'Type a weak one — every unmet rule is listed at once.',
                errors: password.errors,
                focusNode: password.focusNode,
                child: ElInput(
                  controller: password.controller,
                  obscureText: true,
                  autofillHints: const <String>[AutofillHints.newPassword],
                ),
              ),
              // No `loading` here: the submit body is synchronous.
              ElButton(
                variant: ElButtonVariant.outline,
                onPressed: _submit,
                child: const Text('Set Password'),
              ),
            ],
          ),
        );
      },
    );
  }
}

/* ── 3 · ServerErrorForm: two surfaces, two lifetimes ───────────────────── */

/// The field is **valid** and the submit still fails. `"taken"` is the default
/// value, so the demo fails on the very first press with no typing.
class _ServerErrorForm extends StatefulWidget {
  const _ServerErrorForm();

  @override
  State<_ServerErrorForm> createState() => _ServerErrorFormState();
}

class _ServerErrorFormState extends State<_ServerErrorForm> {
  late final ElForm _form = ElForm(
    fields: <ElFormFieldBase>[
      ElTextFormField(
        name: 'handle',
        initialValue: 'taken',
        rules: <ElRule<String>>[ElRule.minLength(3, 'At least 3 characters.')],
      ),
    ],
  );

  /// `formState.errors.root?.serverError`: a slot outside the schema, so it
  /// lives outside the controller too. No resolver run can touch it; only the
  /// next submit clears it.
  String? _rootError;

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    await _form.submit(() async {
      // `form.clearErrors("root.serverError")`: first, unconditionally, *"or
      // the last failure outlives the attempt that caused it"*.
      setState(() => _rootError = null);
      await Future<void>.delayed(_serverLatency);
      if (!mounted) return;

      final String handle = _form.text('handle').value;
      if (handle == 'taken') {
        setState(() => _rootError = 'That handle belongs to someone else.');
        // DRIFT 8. This one evaporates on the next keystroke: re-validation
        // runs, `"taken"` passes `min(3)`, and the clean result replaces it —
        // while the Alert above survives until the next submit.
        _form.setError('handle', 'Already registered.');
        docsToasts.error(
          'Could not claim that handle',
          glyph: ElIconGlyph.octagonX,
        );
        return;
      }
      docsToasts.success('Claimed @$handle', glyph: ElIconGlyph.circleCheck);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _form,
      builder: (BuildContext context, Widget? child) {
        final ElTextFormField handle = _form.text('handle');
        final bool busy = _form.isSubmitting;

        return _Measure(
          child: ElFieldGroup(
            children: <Widget>[
              // The Alert is the first child of the group, so it is followed by
              // the group's own 20px.
              if (_rootError != null)
                ElAlert(
                  variant: ElAlertVariant.destructive,
                  // The page supplies the glyph and the variant only says what
                  // colour it comes out, `tone="inherit"` is `text-current`.
                  icon: const ElIcon(
                    ElIconGlyph.circleX,
                    tone: ElIconTone.inherit,
                  ),
                  title: 'Could not save',
                  description: _rootError,
                ),
              ElField(
                label: 'Claim a handle',
                description:
                    '“taken” fails on the server. Anything else succeeds.',
                errors: handle.errors,
                focusNode: handle.focusNode,
                child: ElInput(controller: handle.controller),
              ),
              ElButton(
                loading: busy,
                onPressed: _submit,
                child: Text(busy ? 'Claiming' : 'Claim Handle'),
              ),
            ],
          ),
        );
      },
    );
  }
}

/* ── 4 · ComposedForm: five control shapes ──────────────────────────────── */

/// Five controls, none of them an `<input>`, all of them wired the same way.
///
/// Submitting untouched fails three fields at once, `plan`, `payout` and
/// `terms`: and focus lands on the first of them (ruling F4). On the reference
/// it lands nowhere.
class _ComposedForm extends StatefulWidget {
  const _ComposedForm();

  @override
  State<_ComposedForm> createState() => _ComposedFormState();
}

class _ComposedFormState extends State<_ComposedForm> {
  late final ElForm _form = ElForm(
    fields: <ElFormFieldBase>[
      ElFormField<String>(
        name: 'plan',
        initialValue: '',
        rules: <ElRule<String>>[ElRule.minLength(1, 'Pick a plan.')],
      ),
      // `z.enum([...], { message })`. Zod 4 applies the same message to the
      // invalid-**type** case, which is how an untouched group renders a
      // sentence rather than a type error.
      ElFormField<String?>(
        name: 'payout',
        initialValue: null,
        rules: <ElRule<String?>>[
          ElRule.oneOf<String>(<String>[
            'daily',
            'weekly',
          ], 'Pick a payout rhythm.'),
        ],
      ),
      ElTextFormField(
        name: 'bio',
        rules: <ElRule<String>>[
          ElRule.maxLength(160, '160 characters is the ceiling.'),
        ],
      ),
      // DRIFT 20. `z.boolean()`: no message, and the only field on the page
      // with no `FormError` beneath it.
      ElFormField<bool>(name: 'alerts', initialValue: true),
      // `.refine`, not `z.literal(true)`: a literal types the field as `true`,
      // so the `false` default cannot assign and the schema ends up unable to
      // describe the only state the checkbox starts in.
      ElFormField<bool>(
        name: 'terms',
        initialValue: false,
        rules: <ElRule<bool>>[ElRule.accepted('You have to accept the terms.')],
      ),
    ],
  );

  static const List<ElSelectOption<String>> _plans = <ElSelectOption<String>>[
    ElSelectOption<String>(value: 'free', label: 'Free'),
    ElSelectOption<String>(value: 'pro', label: 'Pro'),
    ElSelectOption<String>(value: 'vault', label: 'Vault'),
  ];

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    await _form.submit(
      () => docsToasts.success(
        'Preferences saved',
        glyph: ElIconGlyph.circleCheck,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _form,
      builder: (BuildContext context, Widget? child) {
        final ElFormField<String> plan = _form.field<String>('plan');
        final ElFormField<String?> payout = _form.field<String?>('payout');
        final ElTextFormField bio = _form.text('bio');
        final ElFormField<bool> alerts = _form.field<bool>('alerts');
        final ElFormField<bool> terms = _form.field<bool>('terms');

        return _Measure(
          child: ElFieldGroup(
            children: <Widget>[
              // `plan`: no description (drift 20). `FormControl` wraps the
              // trigger, not the Select, so the trigger is what takes the focus
              // node and the wiring.
              ElField(
                label: 'Plan',
                errors: plan.errors,
                focusNode: plan.focusNode,
                child: ElSelect<String>(
                  options: _plans,
                  value: plan.value.isEmpty ? null : plan.value,
                  onChanged: (String value) => plan.value = value,
                  placeholder: 'Choose a plan',
                  // DRIFT 11. `w-fit` on the trigger loses to the vertical
                  // field's `*:w-full`, so it renders at the full 448.
                  expand: true,
                ),
              ),
              _PayoutFieldSet(field: payout),
              ElField(
                label: 'Bio',
                description: '160 characters at most.',
                errors: bio.errors,
                focusNode: bio.focusNode,
                // DRIFT 9. `rows={3}` is inert; `min-h-20` is the floor.
                child: ElTextarea(controller: bio.controller),
              ),
              // `alerts`: a horizontal field, no description, no error, and
              // nothing that can fail. The label is the field's, so the switch
              // states no name of its own: the reference's `<Switch/>` carries
              // no `aria-label` either and is named by the `FormLabel` beside
              // it.
              ElField(
                label: 'Price alerts',
                orientation: ElFieldOrientation.horizontal,
                focusNode: alerts.focusNode,
                child: ElSwitch(
                  value: alerts.value,
                  onChanged: (bool next) => alerts.value = next,
                ),
              ),
              // `terms`, **one** horizontal field where the reference nests
              // two.
              //
              // It nests because its horizontal `Field` is `flex-row`: a
              // `<FormError/>` inside it would sit *beside* the label rather
              // than under the row, so the message needs an outer vertical
              // `Field` to fall into. [ElField]'s horizontal branch is already
              // a column holding the row, and the description/message slots
              // append to that column: so the wrapper collapses into it and
              // the rendered box tree is the same one: row, `gap-2`, message.
              //
              // Collapsing it is also what keeps the wiring intact. A nested
              // [ElField] publishes a *new* [ElFieldScope] that shadows the
              // outer one, so the checkbox would adopt a null focus node and a
              // valid state: focus-on-error (ruling F4) would stop landing on
              // it and the message would stop being announced with it.
              ElField(
                label: 'I accept the terms',
                orientation: ElFieldOrientation.horizontal,
                errors: terms.errors,
                focusNode: terms.focusNode,
                child: ElCheckbox(
                  state: terms.value
                      ? ElCheckboxState.checked
                      : ElCheckboxState.unchecked,
                  onChanged: (ElCheckboxState next) =>
                      terms.value = next == ElCheckboxState.checked,
                ),
              ),
              ElButton(
                onPressed: _submit,
                child: const Text('Save Preferences'),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// The page's one `FieldSet` + `FieldLegend variant="label"`.
///
/// A group of radios is a fieldset with a legend, **not** a label with an
/// `htmlFor`: `<label for>` may only point at a labelable element and a
/// RadioGroup container is a `div`, so the usual `FormLabel` pattern would emit
/// markup that validates nowhere and announces nothing (`page.tsx` L322–325).
///
/// The legend sits **outside** [ElFieldSet] on purpose: see the library note:
/// a rendered `<legend>` is lifted out of the fieldset's anonymous content box,
/// so the fieldset's `gap-3` never applies to it and only its `mb-1.5` does.
/// [ElFieldSet] is that content box, holding the group and its message.
class _PayoutFieldSet extends StatelessWidget {
  const _PayoutFieldSet({required this.field});

  final ElFormField<String?> field;

  @override
  Widget build(BuildContext context) {
    // The FieldSet carries `data-invalid`, and NOTHING is keyed to it: the
    // colouring lives on `Field`'s own class list, so the legend and both radio
    // labels stay muted while every other failing label on the page turns red.
    // See the library note.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const ElFieldLegend('Payout rhythm'),
        SizedBox(height: ElFieldLegend.spaceBelow),
        ElFieldSet(
          tightForGroup: true,
          children: <Widget>[
            ElRadioGroup<String>(
              value: field.value,
              onChanged: (String next) => field.value = next,
              // `className="gap-3"` tw-merges over the Root's own `gap-2`.
              gap: ElFieldSet.groupGap,
              invalid: field.invalid,
              focusNode: field.focusNode,
              label: 'Payout rhythm',
              hint: field.errors.isEmpty ? null : field.errors.join(' '),
              // One labelled horizontal field per option, which is the shape
              // the reference uses: `<label for="payout-daily">` selects that
              // radio outright, so each item registers its own selection on
              // its own field rather than on the group's: the group's field
              // belongs to the legend.
              children: const <Widget>[
                ElField(
                  label: 'Daily',
                  orientation: ElFieldOrientation.horizontal,
                  child: ElRadioGroupItem<String>(value: 'daily'),
                ),
                ElField(
                  label: 'Weekly',
                  orientation: ElFieldOrientation.horizontal,
                  child: ElRadioGroupItem<String>(value: 'weekly'),
                ),
              ],
            ),
            if (field.errors.isNotEmpty) ElFieldError(field.errors),
          ],
        ),
      ],
    );
  }
}

/* ── 5 · SubmitStates ────────────────────────────────────────────────────── */

/// `StateGrid cols={4}`: four cells, one of them live.
///
/// The one `useState` on the page outside the four forms, and it is one-way:
/// once clicked, cell 3 reads **Saved** in `secondary` for the rest of the
/// session.
class _SubmitStates extends StatefulWidget {
  const _SubmitStates();

  @override
  State<_SubmitStates> createState() => _SubmitStatesState();
}

class _SubmitStatesState extends State<_SubmitStates> {
  bool _saved = false;

  @override
  Widget build(BuildContext context) {
    return ElStateGrid(
      children: <Widget>[
        ElStateCell(
          label: 'Idle',
          note: 'Nothing pending',
          // Clickable with no handler: a bare `<button>` is not a disabled
          // one, so it keeps full opacity and the pointer.
          child: ElButton(onPressed: () {}, child: const Text('Save Account')),
        ),
        // Static, but animating: the spinner never stops and `loading` implies
        // `disabled`, so the cell also shows the 45% dim.
        ElStateCell(
          label: 'Pending',
          note: 'isSubmitting',
          child: ElButton(
            loading: true,
            onPressed: () {},
            child: const Text('Saving'),
          ),
        ),
        ElStateCell(
          label: 'Success',
          note: 'Outcome confirmed',
          child: ElButton(
            variant: _saved
                ? ElButtonVariant.secondary
                : ElButtonVariant.primary,
            onPressed: () {
              setState(() => _saved = true);
              docsToasts.success(
                'Account saved',
                glyph: ElIconGlyph.circleCheck,
              );
            },
            child: Text(_saved ? 'Saved' : 'Click to save'),
          ),
        ),
        const ElStateCell(
          label: 'Disabled',
          note: 'Nothing has changed',
          child: ElButton(child: Text('Save Account')),
        ),
      ],
    );
  }
}

/* ── Page-local composition ──────────────────────────────────────────────── */

/// `<form className="max-w-md">`, 448px, left-aligned in a 1030px panel body.
class _Measure extends StatelessWidget {
  const _Measure({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Align(
    alignment: AlignmentDirectional.centerStart,
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: _measureMd),
      child: child,
    ),
  );
}
