/// `/design-system/components/base/inputs` — text entry, in every shape.
///
/// Eight sections and thirty-one live fields. Almost nothing here is a picture
/// of a control: every specimen in the state grid takes text, all nine type
/// demos are real, the password toggle really toggles, both textareas grow, and
/// both OTP strips accept six digits through one hidden field. Two cells are
/// deliberately **stills** — the drifted Hover and Focus specimens, entries 4
/// and 5 below — and ruling I3 keeps them page-local paint rather than a fake
/// focus API nobody else would ever want.
///
/// Three shell facts differ from the foundations pages, the same three the
/// buttons page carries: the route nests two levels deeper, the eyebrow is
/// composed rather than literal (drift 1), and `StateGrid`/`StateCell` are kit
/// primitives promoted for this wave.
///
/// **The 13px collapse (ruling I7), because it is the one thing a reader will
/// try to "fix".** Every `className="type-num"` and `className="type-serial"`
/// on this page renders at **13px, not 15**, and `type-num-sm` at 13, not 12.
/// `.type-*` classes live in `@layer components`; Tailwind's `text-sm` is a
/// `@layer utilities` rule on the same element, and utilities win every property
/// they share. *(Measured on the running reference: an `InputGroupText` computes
/// 13px at an 18.5714px line box — the utility takes the size **and** the
/// leading.)* What survives is the family, the tabular figures, the 600 weight
/// and the −0.01em tracking, which is why "the shared mono foundation" is
/// two-thirds true and drift 8 records the third. [DsComponentType.inputNum] and
/// [DsComponentType.inputSerial] are that collapse already resolved in the
/// foundation layer — passing `DsType.numBase` to any field on this page renders
/// two pixels large.
///
/// **What is not ported, and why.**
/// * **`min`/`max` on the Quantity field** (`min={1} max={10}`). They are
///   validation and spinner-step attributes on `<input type="number">`; nothing
///   on this page shows a spinner, the value is seeded inside the range, and
///   neither attribute paints a pixel. Recorded rather than approximated with an
///   input formatter, which would change the value the reference never changes.
/// * **`aria-describedby` on the errored textarea.** The reference omits it
///   (drift 12) — an error that is visually paired and programmatically
///   unlinked. The port folds every description and message into the control's
///   `Semantics(hint:)` uniformly, so this one is *linked* here. An invisible
///   accessibility regression is the one drift class this port does not ship
///   (the principle ruling F4 states), so the omission is recorded and not
///   reproduced.
///
/// Reference drifts, all shipped as written (inputs-map §17). Where a drift
/// belongs to a component rather than to this page it is recorded at its own
/// source and named here so the register stays complete.
/// 1. **The eyebrow says "Base" twice.** `eyebrow={`${group.title} · Base`}`
///    with `group.title = "Base Components"` — see [InputsPage.build].
/// 2. **The opening Note's radius claim.** *"Both were changed: 40px and
///    10px"* — `input.tsx` is `rounded-pill`, **999px**, not 10. The 10 is
///    `--radius`, which only `input-group.tsx` reads and only through `calc()`.
/// 3. **The opening Note's fill claim.** *"Fields are also filled with
///    `bg-muted`"* — every field in the family is `bg-card`. Stated twice on
///    one page: the `#api` `Input` row repeats it.
/// 4. **The Hover specimen changes nothing.** `className="border-input"` is
///    already in the base class list and no member of this family declares a
///    `hover:` rule at all, so the cell is pixel-identical to Default. The note
///    "Border strengthens" describes an appearance the system does not have.
/// 5. **The Focus specimen shows the wrong focus.** It paints `border-ring
///    ring-3 ring-ring/50` — the *Button*'s recipe. The real one is
///    `border-primary/50` + `ring-ring/35`, which is what a focused field one
///    section down actually does. See [_FocusStill].
/// 6. **The invalid ring alpha differs by wrapper.** Bare `Input`/`Textarea`
///    ring at `--destructive`/20 in both themes; `InputGroup` and the OTP group
///    ring at 20 light and **40 dark**. Visible side by side in `#validation`,
///    fields 1 and 2. Carried by `input.dart` and `input_group.dart`.
/// 7. **Disabled opacity differs by wrapper** — 45% on `Input`/`Textarea`, 50%
///    on `InputGroup`/`InputOTP`.
/// 8. **"the numerical mono foundation" is 13px, not 15** — the collapse above.
///    Three places on this page assert the foundation is in use: the Quantity
///    field's description, the `#otp` section description, and Do #2.
/// 9. **Addon icons are requested at 14 and painted at 16.** `size="sm"` sets
///    presentational attributes; the addon's `[&>svg:not([class*='size-'])]
///    :size-4` overrides them with a class while `strokeWidth` stays computed
///    from 14. Seven icons here. In this port it collapses to an identity —
///    `DsIcon.strokeFor` snaps 48/16 and 48/14 to the same 2.4 rung — so the
///    cell is `DsIconSize.md` and nothing else.
/// 10. **The password field has a visible label bound to nothing.** Its
///    `FieldLabel` carries no `htmlFor`; the control is named by `aria-label`
///    instead, so clicking the label does nothing — while Do #1 on the same
///    page says *"Label every field visibly"*. Reproduced by withholding the
///    focus node every other field on the page is given.
/// 11. **`Field`'s invalid colouring never fires.** `fieldVariants` keys off
///    `data-[invalid=true]`, which this page never sets — it marks the control
///    with `aria-invalid` instead. No label on this page turns red, despite the
///    `#api` row claiming Field *"handles the invalid colouring for the whole
///    group"*. Every [DsField] here therefore passes `invalid: false`.
/// 12. **The textarea error is not linked.** `#textarea` field 2 has
///    `aria-invalid` and a `FieldError`, and neither an `id` on the error nor
///    an `aria-describedby` on the control — the three-signal contract the
///    `#validation` Note insists on, missing its third signal two sections
///    earlier. See the divergence note above.
/// 13. **The OTP digits are not mono.** `InputOTPSlot` is `text-sm` — Inter
///    13/400 — with no `type-num*` class, while the section description says
///    *"using the numerical mono foundation"*. The only mono in the component
///    is the invisible overlay's `font-family`, which paints nothing.
/// 14. **`.cn-input-otp` matches no rule** anywhere in the project or its
///    dependencies. Ported as the no-op it is.
/// 15. **`InputOTPGroup`'s `has-aria-invalid:border-destructive` is inert** —
///    the group declares no border-width, so only its ring could ever show.
/// 16. **Both OTP demos are static as rendered.** The active ring and the caret
///    are focus-only and nothing autofocuses; "Partially filled" describes the
///    value, not a caret position.
/// 17. **A `Note`'s tone ink is unreachable.** `tone="error"` tints the border
///    and the wash only: `.type-label` hard-declares `--muted-foreground` on
///    the title and the body states `text-muted-foreground` outright, so a
///    red-tinted box renders entirely grey text. This is the first page in the
///    corpus to use `tone="error"`, which is why it is recorded here.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../kit.dart';
import '../nav.dart';

/* ── Page constants ──────────────────────────────────────────────────────── */

/// `max-w-lg` — `--container-lg`, 32rem. Tailwind's **container** scale, which
/// `globals.css` does not override, so it is not the spacing ladder even where
/// the two coincide. The measure every `FieldGroup` and the composed `<form>`
/// are cut to.
// allow-hardcoded: framework container scale with no token to read it from.
const double _measureLg = 512;

/// `max-w-40` — the Quantity and Referral groups. This one *is* the spacing
/// scale, so it reads off it.
final double _measure40 = ds(40);

/// `#api` — six rows.
///
/// The `Input` row repeats both of the opening Note's false claims (drifts 2
/// and 3) and the `Field` row claims a colouring this page never triggers
/// (drift 11). Both ship: a printed API row is copy. The `InputGroup` value
/// carries **escaped straight double quotes** in the source and a literal `|`
/// with a space on each side.
const List<(String, String)> _apiRows = <(String, String)>[
  (
    'Input',
    'Native input props. 40px tall, 10px radius, bg-muted fill. Set type for '
        'the right keyboard and autofill.',
  ),
  ('Textarea', 'Auto-grows via field-sizing-content. Minimum 80px.'),
  (
    'InputGroup',
    'Wraps a control with addons. Use InputGroupAddon align="inline-start" | '
        '"inline-end".',
  ),
  (
    'Field',
    'Field + FieldLabel + FieldDescription + FieldError. Handles the invalid '
        'colouring for the whole group.',
  ),
  (
    'InputOTP',
    'maxLength sets the digit count. Group in threes with InputOTPSeparator '
        'between.',
  ),
  (
    'aria-invalid',
    'The single switch for the error appearance. Pair it with a FieldError and '
        'aria-describedby.',
  ),
];

/// `#rules` — the first page in the corpus with **five** of each rather than
/// four. Do #3's dashes are U+2014; every apostrophe in the donts is the
/// straight ASCII one, as the source array has them.
const List<String> _dos = <String>[
  'Label every field visibly; placeholders disappear the moment typing starts.',
  'Use the numerical mono foundation for money and quantities, and type-serial '
      'for serial codes.',
  'Set the right type — email, tel, number, search — so mobile keyboards and '
      'autofill work.',
  'Say what is wrong and how to fix it, and link the message with '
      'aria-describedby.',
  'Mark optional fields as optional rather than marking every required one.',
];

const List<String> _donts = <String>[
  "Don't use a placeholder as the label.",
  "Don't signal an error with a red border alone.",
  "Don't show validation errors while the user is still typing their first "
      'attempt.',
  "Don't put a currency symbol inside the value; it belongs in an addon.",
  "Don't disable a submit button without saying what is missing.",
];

/* ── Page ────────────────────────────────────────────────────────────────── */

class InputsPage extends StatelessWidget {
  const InputsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final DsCategoryHit here = findCategory('base', 'inputs');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DsPageHeader(
          // DRIFT 1. The foundations pages pass `group.title` alone; this one
          // interpolates a second literal after a U+00B7, and the group is
          // already called "Base Components".
          eyebrow: '${here.group.title} · Base',
          title: here.category.title,
          blurb: here.category.blurb,
          contents: here.category.contents,
        ),
        // `<Note … className="mb-12">` — page level, between the header and the
        // first section, exactly where the shadows page puts its own.
        Padding(
          padding: EdgeInsets.only(bottom: ds(12)),
          child: const DsNote(
            title: 'Restyled from stock',
            child: _RestyledNoteBody(),
          ),
        ),
        const _StatesSection(),
        const _TypesSection(),
        const _TextareaSection(),
        const _OtpSection(),
        const _ValidationSection(),
        const _FormSection(),
        const _ApiSection(),
        const _RulesSection(),
        const DsPageFootNav(groupId: 'base', slug: 'inputs'),
      ],
    );
  }
}

/// The opening Note's body — two `Code` chips, and every specific claim in it
/// false against the component it describes (drifts 2 and 3).
class _RestyledNoteBody extends StatelessWidget {
  const _RestyledNoteBody();

  @override
  Widget build(BuildContext context) {
    return DsRichText(
      TextSpan(
        children: <InlineSpan>[
          const TextSpan(
            text: 'Inputs ship from shadcn at 32px tall with a 12px radius. '
                'Both were changed: 40px and 10px, so a field sits level with '
                'a default ',
          ),
          DsCode.span('Button'),
          const TextSpan(text: ' in the same row. Fields are also filled with '),
          DsCode.span('bg-muted'),
          const TextSpan(
            text: ' rather than transparent, so they read as editable against '
                'a card without a heavy border.',
          ),
        ],
      ),
      DsType.small,
    );
  }
}

/* ── #states ─────────────────────────────────────────────────────────────── */

/// The eight appearances, in a `cols={4}` lattice — two full rows at this
/// frame, no orphan cell.
///
/// Six of the eight are a bare [DsInput] and nothing else. The two that are not
/// carry `className` overrides the component has no property for, which is what
/// ruling I3 means by page-local paint: [_FocusStill] and [_SuccessStill]
/// rebuild the pill around a stripped field rather than adding a "pretend to be
/// focused" flag to a component nobody else would ever pass it to.
class _StatesSection extends StatelessWidget {
  const _StatesSection();

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);

    return DsSection(
      id: 'states',
      title: 'States',
      description: 'The full matrix. Every input in the product must be able '
          'to show all eight — a form that cannot express an error is not '
          'finished.',
      child: DsStateGrid(
        children: <Widget>[
          const DsStateCell(
            label: 'Default',
            child: DsInput(placeholder: 'Search packs', label: 'Default'),
          ),
          // DRIFT 4. `className="border-input"` repeats a class the base list
          // already carries, and no input primitive declares a `hover:` rule —
          // so this cell is literally the cell above it, and its note describes
          // nothing.
          const DsStateCell(
            label: 'Hover',
            note: 'Border strengthens',
            child: DsInput(placeholder: 'Search packs', label: 'Hover'),
          ),
          const DsStateCell(
            label: 'Focus',
            note: 'Blue ring',
            child: _FocusStill(),
          ),
          const DsStateCell(
            label: 'Filled',
            child: DsInput(initialValue: 'Eclipse Vault', label: 'Filled'),
          ),
          const DsStateCell(
            label: 'Error',
            note: 'aria-invalid',
            child: DsInput(
              initialValue: 'not-an-email',
              invalid: true,
              label: 'Error',
            ),
          ),
          const DsStateCell(
            label: 'Success',
            child: _SuccessStill(label: 'Success'),
          ),
          const DsStateCell(
            label: 'Disabled',
            note: '45% opacity',
            child: DsInput(
              placeholder: 'Unavailable',
              enabled: false,
              label: 'Disabled',
            ),
          ),
          DsStateCell(
            label: 'Read only',
            note: 'Value, not editable',
            // `readOnly` alone changes nothing visually — `input.tsx` has no
            // `read-only:` variant. The whole of this cell's difference is
            // `className="text-muted-foreground"`, and an input's colour is
            // `inherit` (Preflight), so the class arrives the way inheritance
            // arrives in Flutter: an ambient style over the subtree.
            child: DefaultTextStyle.merge(
              style: TextStyle(color: theme.mutedForeground),
              // A U+2026 horizontal ellipsis, not three full stops.
              child: const DsInput(
                initialValue: '0xA71c…4F2b',
                readOnly: true,
                label: 'Read only',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A live field wearing a pill this page painted itself.
///
/// [DsInput.bare] is `InputGroupInput`'s strip list — no surface at all — so
/// what is left is a padded editable line, and the caller supplies the border,
/// the fill and the socket. That is the same split `DsInputGroup` uses, reached
/// for here because two state cells override the border through `className` and
/// a component property for "look focused without being focused" would exist
/// only to reproduce a mistake (ruling I3).
class _PaintedField extends StatelessWidget {
  const _PaintedField({
    required this.border,
    required this.ring,
    required this.child,
  });

  /// What replaces `border-input`.
  final Color border;

  /// The 3px `ring-*` layer, or null for the cells that declare none.
  final Color? ring;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return SizedBox(
      height: DsInput.height,
      child: DsMachineSurface(
        // Every specimen in this grid carries `shadow-pressed` permanently; a
        // ring is *added* to it and never replaces it.
        spec: ring == null
            ? DsShadows.pressed
            : DsButton.withFocusRing(DsShadows.pressed, ring!),
        radius: BorderRadius.circular(DsRadii.pill),
        fill: theme.card,
        border: Border.all(color: border, width: DsWidths.hairline),
        child: child,
      ),
    );
  }
}

/// DRIFT 5 — `className="border-ring ring-3 ring-ring/50"`.
///
/// A real `:focus-visible` on this component is `border-primary/50` +
/// `ring-ring/35`; this cell paints the *Button*'s recipe instead, so a reader
/// copying the specimen gets the wrong border token and a ring fifteen
/// percentage points too strong. The field underneath is genuinely editable —
/// only its surface is hand-drawn.
class _FocusStill extends StatelessWidget {
  const _FocusStill();

  /// `ring-ring/50`.
  static const double _ringAlpha = 0.50;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return _PaintedField(
      border: theme.ring,
      ring: theme.ring.withValues(alpha: _ringAlpha),
      child: const DsInput(
        placeholder: 'Search packs',
        label: 'Focus',
        bare: true,
      ),
    );
  }
}

/// `className="border-value/50"` — the one green border in the family.
///
/// Not a drift, and it is still page-local: `Input` has no success state, and
/// the same override reappears on `#validation` field 3, which is the only
/// other place in the corpus a field is coloured for being right rather than
/// for being wrong.
class _SuccessStill extends StatelessWidget {
  const _SuccessStill({this.value = 'collector@pulls.xyz', this.label});

  final String value;
  final String? label;

  /// `border-value/50` — `rgba(163, 230, 53, 0.50)`.
  static const double _borderAlpha = 0.50;

  @override
  Widget build(BuildContext context) {
    return _PaintedField(
      border: DsPalette.value.withValues(alpha: _borderAlpha),
      ring: null,
      child: DsInput(initialValue: value, label: label, bare: true),
    );
  }
}

/* ── The `<label for=…>` half Flutter can reproduce ──────────────────────── */

/// One [FocusNode] per `htmlFor`, keyed by the id the reference wrote.
///
/// `<label for=id>` has no Flutter counterpart; what it *buys* is a click on
/// the words focusing the control, and that needs one node both the label and
/// the field can name. [DsField] threads it down through [DsFieldScope], so the
/// page's only job is to own the nodes and outlive the build.
///
/// Withholding a node is therefore how drift 10 ships: the password field is
/// the one field on this page whose `FieldLabel` carries no `htmlFor`, so it is
/// the one field built without one, and its label is inert exactly as the
/// reference's is.
class _FieldNodes {
  final Map<String, FocusNode> _nodes = <String, FocusNode>{};

  FocusNode operator [](String id) =>
      _nodes.putIfAbsent(id, () => FocusNode(debugLabel: id));

  void dispose() {
    for (final FocusNode node in _nodes.values) {
      node.dispose();
    }
    _nodes.clear();
  }
}

/// `<FieldGroup className="max-w-lg">` and the two `max-w-40` groups — a cap on
/// the measure, hard against the leading edge.
///
/// A `max-w-*` is a *maximum* on a block that is otherwise `w-full`, so it
/// cannot be a `SizedBox`: the [Align] is what loosens the field's own stretch
/// so the cap can bite.
class _Measure extends StatelessWidget {
  const _Measure({required this.child, this.width});

  final Widget child;

  /// Defaults to `max-w-lg`.
  final double? width;

  @override
  Widget build(BuildContext context) => Align(
        alignment: AlignmentDirectional.centerStart,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: width ?? _measureLg),
          child: child,
        ),
      );
}

/// `aria-invalid` on the control, with the `Field` left valid.
///
/// The reference marks the control and never the field (drift 11), and the two
/// are separate attributes on the web: `aria-invalid` paints and announces,
/// `data-invalid` only colours the group. [DsField] spends one switch on both,
/// so a page that wants the first without the second restates the field's own
/// scope with that one flag flipped. Every string in it comes back out of the
/// scope, so nothing is duplicated.
///
/// It is also the only way to reach `DsInputGroupInput`, which takes no
/// `invalid` of its own — the wrapper paints every pixel of the error state, so
/// the prop would have had nothing left to do but announce.
class _InvalidControl extends StatelessWidget {
  const _InvalidControl({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final DsFieldScope? scope = DsFieldScope.maybeOf(context);
    return DsFieldScope(
      label: scope?.label,
      describedBy: scope?.describedBy,
      invalid: true,
      enabled: scope?.enabled ?? true,
      focusNode: scope?.focusNode,
      child: child,
    );
  }
}

/* ── #types ──────────────────────────────────────────────────────────────── */

/// Nine fields, seven of them labelled by `htmlFor`.
///
/// Stateful only to own the focus nodes those seven need; nothing on this
/// section has state of its own except the password toggle, which owns its own.
class _TypesSection extends StatefulWidget {
  const _TypesSection();

  @override
  State<_TypesSection> createState() => _TypesSectionState();
}

class _TypesSectionState extends State<_TypesSection> {
  final _FieldNodes _nodes = _FieldNodes();

  @override
  void dispose() {
    _nodes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DsSection(
      id: 'types',
      title: 'Input types',
      description: 'Every text-entry shape the product needs. The type '
          'attribute is not cosmetic — it drives the mobile keyboard, autofill '
          'and validation.',
      child: DsPanel(
        label: 'Types',
        child: _Measure(
          child: DsFieldGroup(
            children: <Widget>[
              // 1 · Username. A bare `Input`: 16px of padding on both sides,
              // because a pill's corner eats about 20 of a 40px control.
              DsField(
                label: 'Username',
                description: 'Shown on live pulls and the leaderboard.',
                invalid: false,
                focusNode: _nodes['i-text'],
                child: const DsInput(placeholder: 'voidwing'),
              ),

              // 2 · Email. One leading addon, so the value's left padding drops
              // from 16 to 8 — the gap to the glyph, not to the curve.
              DsField(
                label: 'Email',
                invalid: false,
                focusNode: _nodes['i-email'],
                child: DsInputGroup(
                  startAddon: const DsInputGroupAddon(
                    child: DsIcon(
                      DsIconGlyph.atSign,
                      size: DsIconSize.md,
                      tone: DsIconTone.subtle,
                    ),
                  ),
                  child: const DsInputGroupInput(
                    placeholder: 'collector@pulls.xyz',
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: <String>[AutofillHints.email],
                  ),
                ),
              ),

              // 3 · Password. DRIFT 10 — no `htmlFor`, so no focus node, so the
              // visible label is bound to nothing and clicking it does nothing.
              const DsField(
                label: 'Password',
                description: 'Visibility toggle is a real control with an '
                    'aria-pressed state, not a decorative icon.',
                invalid: false,
                child: _PasswordField(),
              ),

              // 4 · Search.
              DsField(
                label: 'Search',
                invalid: false,
                focusNode: _nodes['i-search'],
                child: DsInputGroup(
                  startAddon: const DsInputGroupAddon(
                    child: DsIcon(
                      DsIconGlyph.search,
                      size: DsIconSize.md,
                      tone: DsIconTone.subtle,
                    ),
                  ),
                  child: const DsInputGroupInput(
                    placeholder: 'Search packs, cards and sets',
                  ),
                ),
              ),

              // 5 · Quantity. `max-w-40`, a trailing text addon, and the first
              // of six `type-num` values on the page — 13px, not 15.
              DsField(
                label: 'Quantity',
                description: 'Numerical values use the shared mono foundation, '
                    'even inside inputs.',
                invalid: false,
                focusNode: _nodes['i-num'],
                child: _Measure(
                  width: _measure40,
                  child: DsInputGroup(
                    endAddon: const DsInputGroupAddon(
                      align: DsInputGroupAlign.end,
                      child: DsInputGroupText('packs'),
                    ),
                    child: DsInputGroupInput(
                      initialValue: '3',
                      keyboardType: TextInputType.number,
                      textSpec: DsComponentType.inputNum,
                    ),
                  ),
                ),
              ),

              // 6 · Phone number. The `+1` addon is `type-num-sm`, which under
              // `text-sm` collapses to the same 13px the value uses — the class
              // loses its size *and* its leading, and keeps everything else.
              DsField(
                label: 'Phone number',
                description: 'Country code is a separate addon so it never '
                    'gets validated as part of the number.',
                invalid: false,
                focusNode: _nodes['i-phone'],
                child: DsInputGroup(
                  startAddon: DsInputGroupAddon(
                    child: DsInputGroupText(
                      '+1',
                      spec: DsComponentType.inputNum,
                    ),
                  ),
                  child: DsInputGroupInput(
                    placeholder: '555 0134 908',
                    keyboardType: TextInputType.phone,
                    autofillHints: const <String>[
                      AutofillHints.telephoneNumber,
                    ],
                    textSpec: DsComponentType.inputNum,
                  ),
                ),
              ),

              // 7 · Deposit amount. Addons on both sides, so both paddings
              // drop to 8. Of the two addons only `$` carries a `.type-*`
              // class; `USD` sits on the bare `text-sm` rung, at the same 13px
              // by a different route.
              DsField(
                label: 'Deposit amount',
                invalid: false,
                focusNode: _nodes['i-amount'],
                child: DsInputGroup(
                  startAddon: DsInputGroupAddon(
                    child: DsInputGroupText(
                      r'$',
                      spec: DsComponentType.inputNum,
                    ),
                  ),
                  endAddon: const DsInputGroupAddon(
                    align: DsInputGroupAlign.end,
                    child: DsInputGroupText('USD'),
                  ),
                  child: DsInputGroupInput(
                    placeholder: '0.00',
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    textSpec: DsComponentType.inputNum,
                  ),
                ),
              ),

              // 8 · Invite code. A trailing addon holding a button, which pulls
              // its own clearance back 2px — 14, not 16.
              DsField(
                label: 'Invite code',
                invalid: false,
                focusNode: _nodes['i-invite'],
                child: DsInputGroup(
                  startAddon: const DsInputGroupAddon(
                    child: DsIcon(
                      DsIconGlyph.ticket,
                      size: DsIconSize.md,
                      tone: DsIconTone.subtle,
                    ),
                  ),
                  endAddon: DsInputGroupAddon(
                    align: DsInputGroupAlign.end,
                    child: DsInputGroupButton(
                      // No `onClick` in the reference either — it is an enabled
                      // `type="button"` that does nothing. `null` would disable
                      // it and fade it to 45%.
                      onPressed: () {},
                      child: const Text('Apply'),
                    ),
                  ),
                  child: DsInputGroupInput(
                    placeholder: 'ECLIPSE-2K4A',
                    textSpec: DsComponentType.inputSerial,
                  ),
                ),
              ),

              // 9 · Referral percentage. `max-w-40`, and the only addon on the
              // page that is a glyph on the trailing side.
              DsField(
                label: 'Referral percentage',
                invalid: false,
                focusNode: _nodes['i-referral'],
                child: _Measure(
                  width: _measure40,
                  child: DsInputGroup(
                    endAddon: const DsInputGroupAddon(
                      align: DsInputGroupAlign.end,
                      child: DsIcon(
                        DsIconGlyph.percent,
                        size: DsIconSize.md,
                        tone: DsIconTone.subtle,
                      ),
                    ),
                    child: DsInputGroupInput(
                      initialValue: '5',
                      keyboardType: TextInputType.number,
                      textSpec: DsComponentType.inputNum,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// `PasswordField` (`page.tsx:54–77`) — the page's only stateful child.
///
/// One boolean drives four things at once: the input's `type`, the glyph, the
/// button's `aria-label` and its `aria-pressed`. The field's own description
/// says the toggle is a real control with a pressed state and not a decorative
/// icon, and it is.
class _PasswordField extends StatefulWidget {
  const _PasswordField();

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    return DsInputGroup(
      startAddon: const DsInputGroupAddon(
        child: DsIcon(
          DsIconGlyph.lock,
          size: DsIconSize.md,
          tone: DsIconTone.subtle,
        ),
      ),
      endAddon: DsInputGroupAddon(
        align: DsInputGroupAlign.end,
        child: DsInputGroupButton(
          onPressed: () => setState(() => _visible = !_visible),
          label: _visible ? 'Hide password' : 'Show password',
          toggled: _visible,
          // `size="xs"`'s own `size-3.5` beats the Button base's `size-4`
          // *(measured)*, so a button icon is 14px where an addon icon is 16.
          child: DsIcon(
            _visible ? DsIconGlyph.eyeOff : DsIconGlyph.eye,
            size: DsIconSize.sm,
            tone: DsIconTone.subtle,
          ),
        ),
      ),
      child: DsInputGroupInput(
        initialValue: 'correct-horse-battery',
        obscureText: !_visible,
        keyboardType: TextInputType.visiblePassword,
        // The `aria-label` that stands in for the label bound to nothing.
        label: 'Password',
      ),
    );
  }
}

/* ── #textarea ───────────────────────────────────────────────────────────── */

class _TextareaSection extends StatefulWidget {
  const _TextareaSection();

  @override
  State<_TextareaSection> createState() => _TextareaSectionState();
}

class _TextareaSectionState extends State<_TextareaSection> {
  final _FieldNodes _nodes = _FieldNodes();

  @override
  void dispose() {
    _nodes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DsSection(
      id: 'textarea',
      title: 'Textarea',
      description: 'Auto-grows with content via field-sizing. Used for '
          'shipping notes and support messages.',
      child: DsPanel(
        label: 'Textarea',
        child: _Measure(
          child: DsFieldGroup(
            children: <Widget>[
              DsField(
                label: 'Shipping note',
                description: 'Grows as you type. Minimum height is 80px.',
                invalid: false,
                focusNode: _nodes['ta'],
                child: const DsTextarea(
                  placeholder: 'Anything the packing team should know',
                ),
              ),
              // DRIFT 12. `aria-invalid` and a `FieldError`, with no `id` on
              // the error and no `aria-describedby` on the control — the
              // three-signal contract the `#validation` Note insists on, two
              // sections before it is stated, missing its third signal. The
              // port links it; see the library note.
              DsField(
                label: 'With an error',
                errors: const <String>[
                  'Please provide at least 20 characters.',
                ],
                // DRIFT 11 — `data-invalid` is never set on this page, so the
                // label above stays `--foreground` and only the control reddens.
                invalid: false,
                focusNode: _nodes['ta-err'],
                child: const _InvalidControl(
                  child: DsTextarea(initialValue: 'Too short'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ── #otp ────────────────────────────────────────────────────────────────── */

/// Two six-digit strips, `[3, 3]`, 208px each.
///
/// DRIFT 16 — both are **static as rendered**. The active ring and the fake
/// caret are focus-only and nothing on the page autofocuses, so "Partially
/// filled" describes the value and not a caret position. Focus either one and
/// the ring and the 1s square-wave caret arrive exactly where the package's own
/// selection reducer puts them.
class _OtpSection extends StatelessWidget {
  const _OtpSection();

  /// `space-y-8` — 32px between the two demos.
  static double get _demoGap => ds(8);

  /// `<p className="type-label mb-4">` — 16px under each demo's own label.
  static double get _labelGap => ds(4);

  @override
  Widget build(BuildContext context) {
    return DsSection(
      id: 'otp',
      title: 'Verification code',
      // DRIFT 13 lives in this sentence: the slots are `text-sm` Inter, and the
      // only mono in the component paints nothing.
      description: 'Email verification and two-factor authentication. Six '
          'digits, grouped three and three, using the numerical mono '
          'foundation.',
      child: DsPanel(
        label: 'Verification code',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _OtpDemo(label: 'Empty', child: DsInputOtp()),
            SizedBox(height: _demoGap),
            // Controlled on the reference only because `InputOTP` manages
            // `value` itself and a `defaultValue` beside it makes React warn
            // about switching between controlled and uncontrolled
            // (`page.tsx:80–81`). Flutter has no such hazard: a seed is a seed.
            _OtpDemo(
              label: 'Partially filled',
              child: DsInputOtp(initialValue: '4082'),
            ),
          ],
        ),
      ),
    );
  }
}

class _OtpDemo extends StatelessWidget {
  const _OtpDemo({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // `.type-label` uppercases at paint and brings its own
        // `--muted-foreground`; the element states no colour of its own.
        DsText(label, DsType.label),
        SizedBox(height: _OtpSection._labelGap),
        child,
      ],
    );
  }
}

/* ── #validation ─────────────────────────────────────────────────────────── */

class _ValidationSection extends StatefulWidget {
  const _ValidationSection();

  @override
  State<_ValidationSection> createState() => _ValidationSectionState();
}

class _ValidationSectionState extends State<_ValidationSection> {
  final _FieldNodes _nodes = _FieldNodes();

  @override
  void dispose() {
    _nodes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DsSection(
      id: 'validation',
      title: 'Validation messages',
      description: 'An error must say what is wrong and what to do about it. '
          'Errors appear below the field, never as a tooltip, and never only '
          'as a red border.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // The page's Field & Label chapter. There is no section by that name;
          // the header chip that promises one lands here.
          DsPanel(
            label: 'Field anatomy',
            child: _Measure(
              child: DsFieldGroup(
                children: <Widget>[
                  // 1 · A bare invalid field: destructive border, ring at 20%
                  // in **both** themes.
                  DsField(
                    label: 'Email',
                    errors: const <String>[
                      'That address is missing a domain. Try '
                          'collector@pulls.xyz.',
                    ],
                    invalid: false,
                    focusNode: _nodes['v1'],
                    child: const _InvalidControl(
                      child: DsInput(initialValue: 'collector@pulls'),
                    ),
                  ),
                  // 2 · The same error state inside a group — DRIFT 6, visible
                  // one field below drift 6's other half: this one rings at 40%
                  // on dark, the field above it at 20%, and the only difference
                  // between them is that an addon happens to be present.
                  DsField(
                    label: 'Withdrawal amount',
                    errors: const <String>[
                      'Exceeds your available balance of \$1,204.80. Bonus '
                          'balance cannot be withdrawn.',
                    ],
                    invalid: false,
                    focusNode: _nodes['v2'],
                    child: _InvalidControl(
                      child: DsInputGroup(
                        startAddon: DsInputGroupAddon(
                          child: DsInputGroupText(
                            r'$',
                            spec: DsComponentType.inputNum,
                          ),
                        ),
                        child: DsInputGroupInput(
                          initialValue: '2,400.00',
                          textSpec: DsComponentType.inputNum,
                        ),
                      ),
                    ),
                  ),
                  // 3 · The one field on the page coloured for being right.
                  _AvailableField(node: _nodes['v3']),
                ],
              ),
            ),
          ),
          // `className="mt-4"`.
          SizedBox(height: ds(4)),
          const DsNote(
            tone: DsNoteTone.error,
            title: 'Never colour alone',
            child: _NeverColourAloneBody(),
          ),
        ],
      ),
    );
  }
}

/// `#validation` field 3 — a green border and a `text-value-ink` description.
///
/// Hand-composed rather than a [DsField], because `FieldDescription` states its
/// own `--muted-foreground` and this is the corpus's only instance that
/// overrides it with a `text-*` class. Everything else about the stack is
/// [DsField]'s: an 8px gap above and below the control, `w-fit` on the label,
/// and one merged semantics node for the three parts.
class _AvailableField extends StatelessWidget {
  const _AvailableField({required this.node});

  final FocusNode node;

  static const String _label = 'Username';
  static const String _description = 'Available.';

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);

    return Semantics(
      container: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          DsFieldLabel(_label, focusNode: node),
          SizedBox(height: DsField.gap),
          DsFieldScope(
            label: _label,
            // `aria-describedby="v3-ok"`, folded into the control's hint the
            // way every other description on this page is.
            describedBy: _description,
            focusNode: node,
            child: const _SuccessStill(value: 'voidwing'),
          ),
          SizedBox(height: DsField.gap),
          // Already the control's hint; announcing it here would read it twice.
          ExcludeSemantics(
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: DsText(
                _description,
                DsType.small,
                color: theme.valueInk,
                align: TextAlign.start,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The `tone="error"` Note's body — two `Code` chips, and DRIFT 17: nothing
/// inside a Note ever renders in the tone's ink, so this is a red-tinted box
/// with entirely grey text.
class _NeverColourAloneBody extends StatelessWidget {
  const _NeverColourAloneBody();

  @override
  Widget build(BuildContext context) {
    return DsRichText(
      TextSpan(
        children: <InlineSpan>[
          const TextSpan(
            text: 'A red border on its own is invisible to a colour-blind '
                'user. Errors always ship three signals: ',
          ),
          DsCode.span('aria-invalid'),
          const TextSpan(
            text: ', the destructive border, and a written message linked by ',
          ),
          DsCode.span('aria-describedby'),
          const TextSpan(text: '.'),
        ],
      ),
      DsType.small,
    );
  }
}

/* ── #form ───────────────────────────────────────────────────────────────── */

/// `<form onSubmit={e => e.preventDefault()}>` — two fields, a rule, two
/// buttons, and no validation at all.
///
/// The `<form>` element contributes nothing here: no schema, no resolver, no
/// submit handler beyond swallowing the event. Ported as what it is, which is a
/// layout — the form/validator layer belongs to the forms page.
class _FormSection extends StatefulWidget {
  const _FormSection();

  @override
  State<_FormSection> createState() => _FormSectionState();
}

class _FormSectionState extends State<_FormSection> {
  final _FieldNodes _nodes = _FieldNodes();

  @override
  void dispose() {
    _nodes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);

    return DsSection(
      id: 'form',
      title: 'A complete form',
      description: 'Everything assembled: labels above fields, 20px between '
          'fields, description under the field it describes, and the primary '
          'action separated by a rule.',
      child: DsPanel(
        label: 'Deposit funds',
        // `max-w-lg` sits on the `<form>`; the `FieldGroup` inside carries none.
        child: _Measure(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              DsFieldGroup(
                children: <Widget>[
                  DsField(
                    label: 'Amount',
                    description: 'Minimum \$10.00. Deposits clear instantly.',
                    invalid: false,
                    focusNode: _nodes['f-amount'],
                    child: DsInputGroup(
                      startAddon: DsInputGroupAddon(
                        child: DsInputGroupText(
                          r'$',
                          spec: DsComponentType.inputNum,
                        ),
                      ),
                      endAddon: const DsInputGroupAddon(
                        align: DsInputGroupAlign.end,
                        child: DsInputGroupText('USD'),
                      ),
                      child: DsInputGroupInput(
                        placeholder: '0.00',
                        keyboardType:
                            const TextInputType.numberWithOptions(decimal: true),
                        textSpec: DsComponentType.inputNum,
                      ),
                    ),
                  ),
                  DsField(
                    label: 'Promo code',
                    invalid: false,
                    focusNode: _nodes['f-promo'],
                    child: const DsInput(placeholder: 'Optional'),
                  ),
                ],
              ),
              // `<div className="mt-8 flex gap-3 border-t border-border pt-6">`
              // — 32px above the rule, 24 below it, 12 between the buttons.
              SizedBox(height: ds(8)),
              Container(
                padding: EdgeInsets.only(top: ds(6)),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: theme.border,
                      width: DsWidths.hairline,
                    ),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    DsButton(
                      variant: DsButtonVariant.premium,
                      onPressed: () {},
                      child: const Text('Deposit Funds'),
                    ),
                    SizedBox(width: ds(3)),
                    DsButton(
                      variant: DsButtonVariant.ghost,
                      onPressed: () {},
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ── #api ────────────────────────────────────────────────────────────────── */

class _ApiSection extends StatelessWidget {
  const _ApiSection();

  @override
  Widget build(BuildContext context) {
    return DsSection(
      id: 'api',
      title: 'API',
      child: DsMeta(
        items: <DsMetaItem>[
          for (final (String, String) row in _apiRows)
            (k: row.$1, v: TextSpan(text: row.$2)),
        ],
      ),
    );
  }
}

/* ── #rules ──────────────────────────────────────────────────────────────── */

class _RulesSection extends StatelessWidget {
  const _RulesSection();

  @override
  Widget build(BuildContext context) {
    // Do #1 is contradicted by the password field two sections up (drift 10);
    // Do #2 is contradicted by the 13px every `type-num` on the page renders at
    // (drift 8). Both ship.
    return const DsSection(
      id: 'rules',
      title: 'Rules',
      child: DsDoDont(dos: _dos, donts: _donts),
    );
  }
}
