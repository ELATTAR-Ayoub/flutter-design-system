/// `/design-system/components/base/selection`: four control families, and
/// seventeen of the twenty specimens answer a pointer.
///
/// The page the fourth family arrives on. `Checkbox`, `RadioGroup` and
/// `Switch` all shipped with `forms`; `Slider` is new here, and so are the
/// three matrix states none of the shipped controls could spell (ruling S4).
///
/// **The fidelity bar is that it moves.** A reader can tick a filter, flip a
/// preference, pick a withdrawal method by clicking anywhere on its card, and
/// drag two price handles while the readout follows. A port that renders these
/// as stills fails, however exact the pixels.
///
/// ## What is page-local and why (ruling S5)
///
/// The bulk header and the option card are compositions the reference builds
/// inline out of `div`s and a raw `Label`; neither is exported from
/// `components/ui/`. They stay here until a second page wants them: the B10
/// precedent. [_BulkList] in particular **cannot** reuse `DividedList`:
/// that fills with `theme.card` and draws each seam as a border on the row,
/// which is `divide-y`. This container declares no background at all, so its
/// `space-y-px` seams are the *parent* showing through, and every row supplies
/// its own fill.
///
/// ## Drift register: recorded, shipped as written (selection-map §14)
///
///  1. **Five chips, six sections, and they do not correspond.** `contents` is
///     `[Checkbox, Radio Group, Switch, Slider, Range Slider]`; the sections are
///     `checkbox, radio, switch, slider, api, rules`. **"Range Slider" names no
///     section**: the range is cell 2 of §4's matrix and the first slider
///     panel: and `API` and `Rules` get no chip. On `forms` the two lists were
///     identical. Both render as written.
///  2. **The page calls a 20px control "16px", twice**, §2's trailing
///     paragraph and §6's second do. Both `Checkbox` and `RadioGroupItem`
///     are `size-5` = 20px, and `checkbox.tsx`'s own docstring gives *"16px is
///     a fiddly target"* as the reason they are not. The copy quotes the number
///     the component was built to escape.
///  3. **The bulk header's tints are frozen and do not follow their
///     checkboxes** (ruling S6). Rows 2–4 carry `bg-action/12` as a literal
///     class and rows 5–6 `bg-background`, while every checkbox inside them is
///     uncontrolled. Uncheck a tinted row and it stays blue; check an untinted
///     one and it stays plain: which is exactly what §6's fourth don't
///     forbids. Reproduced exactly: [_BulkRow.tinted] is a constructor
///     argument, never a function of [_BulkRow.checked].
///  4. **Ids contain spaces**, `` id={`f-${label}`} `` gives `f-Available now`.
///     Valid HTML5 and `htmlFor` matches, so the labels work; no unescaped CSS
///     selector can reach them. Flutter has no id graph, so this one is
///     recorded and not reproducible.
///  5. **`duration-fast` / `duration-base` are inert system-wide**: closed by
///     the sweep; every transition here runs [MotionDurations.normal].
///  6. **The Focus cells are painted, not focused.** `cn()` is
///     `extendTailwindMerge` and `border-input` / `border-ring` are one
///     border-colour group, so tw-merge deletes `border-input` outright.
///     Nothing holds focus; the ring is a permanent box-shadow. Two such cells
///     exist and Flutter can only focus one thing, which is what
///     `forceFocusRing` is for. The note still says *"Tab to it"*.
///  7. **The Indeterminate cell is inert and undimmed**: controlled with no
///     handler, carrying no `disabled`. It looks operable, is not, and gives no
///     signal. `Checkbox.inert` is that state.
///  8. **The slider's range and thumb use different coordinate spaces**, and so
///     does its own drag mapping. Carried by `slider.dart`.
///  9. **The slider's hit expander disagrees with its three siblings** —
///     symmetric `after:-inset-2` against their `-inset-x-3 -inset-y-2`, so the
///     44px floor RULES §7 asks for is met by the other three and missed here.
/// 10. **The slider does not jelly and does not join the field layer.**
/// 11. **The slider thumb's `disabled:` classes never fire**, Radix renders a
///     `<span>`, which `:disabled` cannot match. One dimming, at the root.
///     Carried by `slider.dart` (ruling S7).
/// 12. **`DoDont` gets unequal columns for the first time**, 5 dos against 4
///     don'ts, so the two panels are different heights and the shorter one's
///     border stops early.
/// 13. **`Label` is used raw for the option cards**: the only page in the
///     corpus that imports `components/ui/label` directly instead of going
///     through `FieldLabel`, so the cards restate their layout from scratch.
///     [_OptionCard] does the same.
/// 14. **`Switch` disables on `data-disabled:`, the others on `disabled:`.**
/// 15. **The page has no invalid state anywhere.** Nothing validates, and the
///     `aria-invalid:` rules on all four components are unreachable from here.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart'
    hide
        AspectRatio,
        Form,
        FormField,
        Icon,
        OverlayPortal,
        RadioGroup,
        RichText,
        SafeArea,
        ScrollPosition,
        Table,
        TableColumnWidth;

import '../kit.dart';
import '../nav.dart';

/* ── Page constants ──────────────────────────────────────────────────────── */

/// `max-w-sm`, `--container-sm`, 24rem. Tailwind's **container** scale, which
/// `globals.css` does not override, so it is not the spacing ladder even where
/// the two coincide.
// allow-hardcoded: framework container scale with no token to read it from.
const double _measureSm = 384;

/// `max-w-md`, `--container-md`, 28rem. Both slider panels.
// allow-hardcoded: framework container scale with no token to read it from.
const double _measureMd = 448;

/// `max-w-lg`, `--container-lg`, 32rem. The bulk header, the withdrawal cards
/// and the preferences list.
// allow-hardcoded: framework container scale with no token to read it from.
const double _measureLg = 512;

/// A block box wearing a `max-w-*`.
///
/// CSS caps a block box's width and leaves it at the start of its line. A bare
/// [ConstrainedBox] cannot say that: handed a **tight** width: which is what
/// every `CrossAxisAlignment.stretch` column and every `Padding` inside one
/// passes down: it *enforces* that width and the cap is silently lost, so
/// `max-w-sm` renders at the panel's full 1030. Measured: all six sites on this
/// page rendered 1030 against the reference's 384 / 512 / 512 / 512 / 448 /
/// 448. [Align] is what turns the incoming constraint loose again, and its own
/// start alignment is the rest of the declaration: the reference's boxes all
/// begin at the panel's content edge, 24px in.
///
/// The same shape `feedback.dart` names `_measured` and `selects.dart` wraps
/// its calendars in.
///
/// The reference's `max-w-*` is a rem value, so a doubled text-size setting
/// doubles the root font size and the same class measures twice as wide. A
/// literal px cap does not follow along, and a row that fit its measure at
/// 1x no longer fits at 2x. Scaling the cap by the active text scaler
/// reproduces the rem behaviour instead of inventing new headroom.
Widget _measured(double maxWidth, Widget child) => Builder(
  builder: (BuildContext context) {
    final double scale = MediaQuery.textScalerOf(context).scale(1.0);
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth * scale),
        child: child,
      ),
    );
  },
);

/// `w-40`: the three slider matrix cells.
final double _matrixSlider = space(40);

/// `bg-action/12`: the selected tint, on a bulk row and on a chosen card.
///
/// Read off [Palette.action] rather than `theme.primary` (ruling S3). The two
/// are numerically identical today, `--primary` is `var(--color-action)` in
/// **both** theme blocks: but they are different names for different jobs, and
/// `--ring` already proves the aliases can diverge per theme. The page says
/// `action`, so the port says `action`.
const double _actionTint = 0.12;

/// `border-action/50`: the chosen card's rim, from the same ramp.
const double _actionRim = 0.50;

/// `--strong`, as Preflight sets it: `b, strong { font-weight: bolder }`, which
/// against the body's 400 resolves to 700. The opening Note's four control
/// names step up to it.
// allow-hardcoded: Preflight's own `bolder`, resolved; there is no `--` token for it.
const double _bolder = 700;

/// [base] at [_bolder], keeping every other variable axis.
///
/// The `wght` entry is replaced in place rather than a bare `fontVariations`
/// override being handed to the span, because that would drop the `opsz` entry
/// `font-optical-sizing: auto` puts there.
TextStyle _strong(TextStyle base) => base.copyWith(
  fontWeight: FontWeight.bold,
  fontVariations: <FontVariation>[
    for (final FontVariation v
        in base.fontVariations ?? const <FontVariation>[])
      if (v.axis != 'wght') v,
    const FontVariation('wght', _bolder),
  ],
);

/* ── Page ────────────────────────────────────────────────────────────────── */

class SelectionPage extends StatelessWidget {
  const SelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CategoryHit here = findCategory('base', 'selection');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        PageHeader(
          // DRIFT 1 of the forms register, carried on all fourteen base pages:
          // the group is already called "Base Components" and the page
          // interpolates a second literal after a U+00B7 anyway.
          eyebrow: '${here.group.title} · Base',
          title: here.category.title,
          blurb: here.category.blurb,
          contents: here.category.contents,
        ),
        // `className="mb-12"`, 48px, and the only ported page that opens with
        // a Note above its first section.
        Padding(
          padding: EdgeInsets.only(bottom: space(12)),
          child: const Note(
            title: 'Which control for which job',
            child: _WhichControlBody(),
          ),
        ),
        const _CheckboxSection(),
        const _RadioSection(),
        const _SwitchSection(),
        const _SliderSection(),
        const _ApiSection(),
        const _RulesSection(),
        const PageFootNav(groupId: 'base', slug: 'selection'),
      ],
    );
  }
}

/// Four `<strong className="text-foreground">` runs stepping up out of the
/// Note's own `--muted-foreground`.
class _WhichControlBody extends StatelessWidget {
  const _WhichControlBody();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final TextStyle base = StyledText.styleOf(context, TextStyles.small);
    final TextStyle strong = _strong(base).copyWith(color: theme.foreground);

    return RichText(
      TextSpan(
        children: <InlineSpan>[
          TextSpan(text: 'Checkbox', style: strong),
          const TextSpan(text: ' for independent options and multi-select. '),
          TextSpan(text: 'Radio', style: strong),
          const TextSpan(text: ' for one choice from a visible set. '),
          TextSpan(text: 'Switch', style: strong),
          const TextSpan(
            text:
                ' only for settings that apply immediately with no Save '
                'button. ',
          ),
          TextSpan(text: 'Slider', style: strong),
          const TextSpan(
            text:
                ' for ranges where the exact number matters less than the '
                'feel: price filters, odds explainers.',
          ),
        ],
      ),
      TextStyles.small,
    );
  }
}

/* ── §1 · checkbox ───────────────────────────────────────────────────────── */

class _CheckboxSection extends StatefulWidget {
  const _CheckboxSection();

  @override
  State<_CheckboxSection> createState() => _CheckboxSectionState();
}

class _CheckboxSectionState extends State<_CheckboxSection> {
  /// Matrix cells 1, 2 and 4 are uncontrolled on the reference, so a click
  /// really does toggle them. Cell 4 additionally paints a permanent ring.
  CheckboxState _unchecked = CheckboxState.unchecked;
  CheckboxState _checked = CheckboxState.checked;
  CheckboxState _focus = CheckboxState.unchecked;

  /// `defaultChecked` on the first two rows of the filter list.
  final List<bool> _filters = <bool>[true, true, false, false];

  /// The bulk rows' own checkboxes. **Their tints do not follow these** —
  /// drift 3.
  final List<bool> _bulk = <bool>[true, true, true, false, false];

  static const List<(String, String)> _filterRows = <(String, String)>[
    ('Available now', '184 packs'),
    ('Limited edition', '12 packs'),
    ('Coming soon', '6 packs'),
    ('Sold out', '41 packs'),
  ];

  static const List<String> _selectedCards = <String>[
    'Voidwing Ascendant',
    'Emberlash Prime',
    'Tidecaller',
  ];

  static const List<String> _plainCards = <String>[
    'Stonewarden',
    'Glasswing Drift',
  ];

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    return Section(
      id: 'checkbox',
      title: 'Checkbox',
      description:
          'Used for filters, bulk card selection and terms '
          'acceptance. Selection is blue, always.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          StateGrid(
            cols: 6,
            children: <Widget>[
              StateCell(
                label: 'Unchecked',
                child: Checkbox(
                  state: _unchecked,
                  label: 'Unchecked',
                  onChanged: (CheckboxState next) =>
                      setState(() => _unchecked = next),
                ),
              ),
              StateCell(
                label: 'Checked',
                child: Checkbox(
                  state: _checked,
                  label: 'Checked',
                  onChanged: (CheckboxState next) =>
                      setState(() => _checked = next),
                ),
              ),
              const StateCell(
                label: 'Indeterminate',
                note: 'Partial bulk selection',
                // DRIFT 7. `checked="indeterminate"` with no
                // `onCheckedChange` and no `disabled`: Radix holds it here
                // forever, at full opacity, still focusable, and a click does
                // nothing at all.
                child: Checkbox(
                  state: CheckboxState.indeterminate,
                  inert: true,
                  label: 'Indeterminate',
                ),
              ),
              StateCell(
                label: 'Focus',
                note: 'Tab to it',
                // DRIFT 6. The ring is painted, not focused: and the box is
                // still a live, uncontrolled checkbox underneath it.
                child: Checkbox(
                  state: _focus,
                  forceFocusRing: true,
                  label: 'Focus',
                  onChanged: (CheckboxState next) =>
                      setState(() => _focus = next),
                ),
              ),
              const StateCell(
                label: 'Disabled',
                child: Checkbox(enabled: false, label: 'Disabled'),
              ),
              const StateCell(
                label: 'Disabled checked',
                child: Checkbox(
                  state: CheckboxState.checked,
                  enabled: false,
                  label: 'Disabled checked',
                ),
              ),
            ],
          ),
          SizedBox(height: space(4)),
          Panel(
            label: 'In a filter list',
            child: _measured(
              _measureSm,
              FieldSet(
                children: <Widget>[
                  const FieldLegend('Availability'),
                  FieldGroup(
                    children: <Widget>[
                      for (int i = 0; i < _filterRows.length; i++)
                        _FilterRow(
                          label: _filterRows[i].$1,
                          count: _filterRows[i].$2,
                          checked: _filters[i],
                          onChanged: (bool next) =>
                              setState(() => _filters[i] = next),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: space(4)),
          Panel(
            label: 'Bulk selection header',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _measured(
                  _measureLg,
                  _BulkList(
                    children: <Widget>[
                      _BulkRow(
                        fill: theme.muted,
                        checkbox: const Checkbox(
                          state: CheckboxState.indeterminate,
                          inert: true,
                          label: 'Select all cards',
                        ),
                        title: '3 of 12 cards selected',
                        titleColor: theme.foreground,
                        trailing: StyledText(
                          r'$2,481.00',
                          TextStyles.numberSm,
                          color: theme.premiumText,
                        ),
                      ),
                      for (int i = 0; i < _selectedCards.length; i++)
                        _BulkRow(
                          // DRIFT 3. A frozen literal, never a function of
                          // the checkbox beside it.
                          fill: Palette.action.withValues(alpha: _actionTint),
                          checkbox: Checkbox(
                            state: _bulk[i]
                                ? CheckboxState.checked
                                : CheckboxState.unchecked,
                            label: _selectedCards[i],
                            onChanged: (CheckboxState next) => setState(
                              () => _bulk[i] = next == CheckboxState.checked,
                            ),
                          ),
                          title: _selectedCards[i],
                          titleColor: theme.foreground,
                        ),
                      for (int i = 0; i < _plainCards.length; i++)
                        _BulkRow(
                          fill: theme.background,
                          checkbox: Checkbox(
                            state: _bulk[_selectedCards.length + i]
                                ? CheckboxState.checked
                                : CheckboxState.unchecked,
                            label: _plainCards[i],
                            onChanged: (CheckboxState next) => setState(
                              () => _bulk[_selectedCards.length + i] =
                                  next == CheckboxState.checked,
                            ),
                          ),
                          title: _plainCards[i],
                          titleColor: theme.mutedForeground,
                        ),
                    ],
                  ),
                ),
                // `className="mt-5"`, 20px.
                SizedBox(height: space(5)),
                StyledText(
                  'The indeterminate state is what makes a bulk header honest '
                  '— it says “some” rather than lying with checked '
                  'or unchecked. Selected rows also take the blue tint, so '
                  'selection reads without inspecting the box.',
                  TextStyles.small,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// One row of "In a filter list": a checkbox, a 400-weight label that grows
/// into the slack, and a right-aligned count.
///
/// Composed here rather than through `Field(orientation: horizontal)`
/// because the reference's `Field` holds **three** children and `Field`
/// holds a control and a label. The label takes the top rung of
/// [FieldLabel]'s activation ladder: an explicit `onTap`: which is what
/// `<label for>` buys: clicking the words ticks the box.
class _FilterRow extends StatelessWidget {
  const _FilterRow({
    required this.label,
    required this.count,
    required this.checked,
    required this.onChanged,
  });

  final String label;
  final String count;
  final bool checked;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    void toggle() => onChanged(!checked);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Checkbox(
          state: checked ? CheckboxState.checked : CheckboxState.unchecked,
          label: label,
          onChanged: (CheckboxState next) =>
              onChanged(next == CheckboxState.checked),
        ),
        SizedBox(width: Field.gap),
        // `*:data-[slot=field-label]:flex-auto`: the label grows, which is
        // what makes the rest of the row a target. The count used to sit
        // outside this Expanded as a rigid trailing sibling, which is
        // exactly what overflows once the label and the count both grow at
        // 2x text: a `spaceBetween` Wrap keeps the count flush to the
        // trailing edge (the `ml-auto` reading) at desktop width, same as
        // the Row did, and only drops it under the label on its own line
        // once the pair genuinely does not fit.
        Expanded(
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              FieldLabel(
                label,
                // `className="font-normal"`, probed at weight 400 with the
                // label's own 1.375 leading intact.
                spec: FieldLabel.normal,
                onTap: toggle,
              ),
              // `type-num-sm ml-auto text-muted-foreground`.
              StyledText(count, TextStyles.numberSm),
            ],
          ),
        ),
      ],
    );
  }
}

/// `div.max-w-lg.space-y-px.overflow-hidden.rounded-lg.border.border-border`.
///
/// **The seams are not a fill.** The container declares no background, so what
/// shows in each `space-y-px` gap is whatever is behind it: the `Panel`'s
/// own `--background`. `space-y-px` is a bottom **margin** on every child but
/// the last, not a gap, and the measured height confirms it:
/// 6 × 44 + 5 × 1 + 2 × 1 border = 271.
class _BulkList extends StatelessWidget {
  const _BulkList({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Radii.lg),
        border: Border.all(color: theme.border, width: BorderWidths.hairline),
      ),
      // The border's own pixel, top and bottom. [DecoratedBox] paints a border
      // without reserving space for it, and the reference's height only works
      // out with it: 6 × 44 + 5 × 1 + **2 × 1** = 271. Two pixels here move
      // every section below this one.
      child: Padding(
        padding: EdgeInsets.all(BorderWidths.hairline),
        child: ClipRRect(
          // `overflow-hidden` against the border's inner edge, so the first and
          // last rows take the container's corners.
          borderRadius: BorderRadius.circular(Radii.lg - BorderWidths.hairline),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for (int i = 0; i < children.length; i++) ...<Widget>[
                if (i > 0) SizedBox(height: BorderWidths.hairline),
                children[i],
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// One 44px bulk row, `flex items-center gap-3 px-4 py-3`.
class _BulkRow extends StatelessWidget {
  const _BulkRow({
    required this.fill,
    required this.checkbox,
    required this.title,
    required this.titleColor,
    this.trailing,
  });

  /// The row's own background. **Stated by the caller, never derived from the
  /// checkbox**: drift 3.
  final Color fill;

  final Widget checkbox;
  final String title;
  final Color titleColor;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: fill,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: space(4), vertical: space(3)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            checkbox,
            SizedBox(width: space(3)),
            // `trailing` used to sit outside this Expanded as a rigid
            // sibling, which is what overflows once the title and a
            // trailing value (a price, on the header row) both grow at 2x
            // text. A `spaceBetween` Wrap keeps trailing flush to the edge
            // at desktop width, same as the Row did, and only drops it
            // under the title once the pair genuinely does not fit.
            Expanded(
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  StyledText(title, TextStyles.small, color: titleColor),
                  ?trailing,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ── §2 · radio ──────────────────────────────────────────────────────────── */

class _RadioSection extends StatefulWidget {
  const _RadioSection();

  @override
  State<_RadioSection> createState() => _RadioSectionState();
}

class _RadioSectionState extends State<_RadioSection> {
  /// Each matrix cell wraps its item in **its own** `RadioGroup`: four
  /// independent groups of one.
  String? _unselected;
  String? _selected = 'a';
  String? _focus;

  String _method = 'usdc';

  static const List<(String, String, String, String)> _methods =
      <(String, String, String, String)>[
        ('usdc', 'USDC', 'Arrives in minutes. Network fee applies.', 'No fee'),
        ('bank', 'Bank transfer', '1–3 business days.', r'$0.00'),
        (
          'card',
          'Card refund',
          'Back to the original card. 5–10 days.',
          r'$0.00',
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Section(
      id: 'radio',
      title: 'Radio Group',
      description:
          'One choice from a set the user can see at once. If the '
          'options need explaining, the description belongs inside the '
          'option, not beneath the group.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          StateGrid(
            children: <Widget>[
              StateCell(
                label: 'Unselected',
                child: RadioGroup<String>(
                  value: _unselected,
                  onChanged: (String next) =>
                      setState(() => _unselected = next),
                  children: const <Widget>[
                    RadioGroupItem<String>(value: 'a', label: 'Unselected'),
                  ],
                ),
              ),
              StateCell(
                label: 'Selected',
                child: RadioGroup<String>(
                  value: _selected,
                  onChanged: (String next) => setState(() => _selected = next),
                  children: const <Widget>[
                    RadioGroupItem<String>(value: 'a', label: 'Selected'),
                  ],
                ),
              ),
              StateCell(
                label: 'Focus',
                // DRIFT 6 again: the second painted ring on the page.
                child: RadioGroup<String>(
                  value: _focus,
                  onChanged: (String next) => setState(() => _focus = next),
                  children: const <Widget>[
                    RadioGroupItem<String>(
                      value: 'a',
                      forceFocusRing: true,
                      label: 'Focus',
                    ),
                  ],
                ),
              ),
              const StateCell(
                label: 'Disabled',
                child: RadioGroup<String>(
                  value: null,
                  onChanged: null,
                  children: <Widget>[
                    RadioGroupItem<String>(
                      value: 'a',
                      enabled: false,
                      label: 'Disabled',
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: space(4)),
          Panel(
            label: 'Withdrawal method',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _measured(
                  _measureLg,
                  RadioGroup<String>(
                    value: _method,
                    // `className="max-w-lg gap-3"`: tw-merges over the Root's
                    // own `gap-2`.
                    gap: space(3),
                    onChanged: (String next) => setState(() => _method = next),
                    children: <Widget>[
                      for (final (
                            String value,
                            String title,
                            String desc,
                            String fee,
                          )
                          in _methods)
                        _OptionCard(
                          value: value,
                          title: title,
                          description: desc,
                          fee: fee,
                          selected: _method == value,
                          onTap: () => setState(() => _method = value),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: space(5)),
                // DRIFT 2. The circle is 20px.
                StyledText(
                  'The whole card is the target, not just the 16px circle. '
                  'Selected takes a blue border plus the blue tint.',
                  TextStyles.small,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A withdrawal option: a raw `<Label>` wrapping a radio, and **the first
/// hover state in this family**.
///
/// `SelectionControl`'s own doc records that no control on the forms page
/// authors a hover. That is still true of the *controls*; the card around one
/// does. `hover:border-input` runs `transition-colors`: probed at
/// [MotionDurations.normal] on `--ease-out`, and confirmed by driving a
/// real pointer onto the card and sampling every frame: the border walks
/// `--border` → `--input` across roughly fifteen frames rather than cutting.
///
/// DRIFT 13: the reference reaches for `components/ui/label` directly here
/// instead of `FieldLabel`, so the card gets none of `FieldLabel`'s
/// `leading-snug`, `w-fit` or gap and restates its layout from scratch. So does
/// this.
class _OptionCard extends StatefulWidget {
  const _OptionCard({
    required this.value,
    required this.title,
    required this.description,
    required this.fee,
    required this.selected,
    required this.onTap,
  });

  final String value;
  final String title;
  final String description;
  final String fee;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_OptionCard> createState() => _OptionCardState();
}

class _OptionCardState extends State<_OptionCard> {
  bool _hovered = false;

  void _hover(bool value) {
    if (_hovered == value) return;
    setState(() => _hovered = value);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    // `has-[[data-state=checked]]:border-action/50` beats `hover:border-input`
    //: it is emitted later at equal specificity, so a selected card does not
    // lose its rim to a pointer.
    final Color border = widget.selected
        ? Palette.action.withValues(alpha: _actionRim)
        : _hovered
        ? theme.input
        : theme.border;
    final Color fill = widget.selected
        ? Palette.action.withValues(alpha: _actionTint)
        : theme.card;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _hover(true),
      onExit: (_) => _hover(false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: TweenAnimationBuilder<Color?>(
          tween: ColorTween(end: border),
          duration: effectiveMotionDuration(context, MotionDurations.normal),
          curve: MotionCurves.enter,
          builder: (BuildContext context, Color? rim, Widget? child) =>
              TweenAnimationBuilder<Color?>(
                tween: ColorTween(end: fill),
                duration: effectiveMotionDuration(
                  context,
                  MotionDurations.normal,
                ),
                curve: MotionCurves.enter,
                builder: (BuildContext context, Color? wash, Widget? child) =>
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: wash ?? fill,
                        borderRadius: BorderRadius.circular(Radii.lg),
                        border: Border.all(
                          color: rim ?? border,
                          width: BorderWidths.hairline,
                        ),
                      ),
                      child: child,
                    ),
                child: child,
              ),
          child: Padding(
            // `p-4` **plus the border**. `box-sizing: border-box` puts the
            // padding inside a border that still occupies the box, so a card
            // measures content + 2 x 16 + 2 x 1 = 81.3 and not 79.3.
            // [DecoratedBox] paints its border over the child without
            // reserving space for it, [Container] adds `decoration.padding`
            // for its callers and this does not: so the hairline is added
            // here. Three cards deep, forgetting it costs the section 6px.
            padding: EdgeInsets.all(space(4) + BorderWidths.hairline),
            child: Row(
              // `items-start`: the card is the one row on the page that does
              // not centre.
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  // `className="mt-0.5"` on the item, 2px.
                  padding: EdgeInsets.only(top: space(0.5)),
                  child: RadioGroupItem<String>(
                    value: widget.value,
                    label: widget.title,
                  ),
                ),
                SizedBox(width: space(3)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      StyledText(
                        widget.title,
                        TextStyles.h4,
                        color: theme.foreground,
                      ),
                      SizedBox(height: space(1)),
                      StyledText(widget.description, TextStyles.small),
                    ],
                  ),
                ),
                SizedBox(width: space(3)),
                StyledText(widget.fee, TextStyles.numberSm),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/* ── §3 · switch ─────────────────────────────────────────────────────────── */

class _SwitchSection extends StatefulWidget {
  const _SwitchSection();

  @override
  State<_SwitchSection> createState() => _SwitchSectionState();
}

class _SwitchSectionState extends State<_SwitchSection> {
  bool _off = false;
  bool _on = true;

  final List<bool> _prefs = <bool>[true, true, false, false];

  static const List<(String, String)> _preferences = <(String, String)>[
    (
      'Rare pull alerts',
      'Notify me when a legendary or better is pulled from a pack I follow.',
    ),
    ('Weekly leaderboard', 'A summary of where I placed and what I earned.'),
    ('Marketing email', 'New pack drops and promotions.'),
    ('Reduced motion', 'Skip the pack-opening animation entirely.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Section(
      id: 'switch',
      title: 'Switch',
      description:
          'Only for settings that take effect the moment they are '
          'flipped. If there is a Save button on the screen, use a checkbox '
          'instead.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          StateGrid(
            children: <Widget>[
              StateCell(
                label: 'Off',
                child: Switch(
                  value: _off,
                  label: 'Off',
                  onChanged: (bool next) => setState(() => _off = next),
                ),
              ),
              StateCell(
                label: 'On',
                child: Switch(
                  value: _on,
                  label: 'On',
                  onChanged: (bool next) => setState(() => _on = next),
                ),
              ),
              const StateCell(
                label: 'Disabled off',
                child: Switch(
                  value: false,
                  enabled: false,
                  label: 'Disabled off',
                ),
              ),
              const StateCell(
                label: 'Disabled on',
                child: Switch(
                  value: true,
                  enabled: false,
                  label: 'Disabled on',
                ),
              ),
            ],
          ),
          SizedBox(height: space(4)),
          Panel(
            label: 'Notification preferences',
            child: _measured(
              _measureLg,
              FieldGroup(
                children: <Widget>[
                  for (int i = 0; i < _preferences.length; i++)
                    _PreferenceRow(
                      title: _preferences[i].$1,
                      description: _preferences[i].$2,
                      value: _prefs[i],
                      onChanged: (bool next) =>
                          setState(() => _prefs[i] = next),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// One preferences row: label and description on the left, switch on the
/// right.
///
/// The **opposite** order to `Field`'s horizontal branch, which puts the
/// control first because all three horizontal fields on the `forms` page do.
/// Here the reference writes `<span class="min-w-0 flex-1">` before the
/// `<Switch/>`, so the control is last. Composed by hand for that reason.
///
/// `items-center` applies rather than `items-start`: `Field`'s
/// `has-[>[data-slot=field-content]]:items-start` misses, because the child is
/// a bare `<span>` and not a field-content slot.
class _PreferenceRow extends StatelessWidget {
  const _PreferenceRow({
    required this.title,
    required this.description,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String description;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              FieldLabel(title, onTap: () => onChanged(!value)),
              FieldDescription(description),
            ],
          ),
        ),
        SizedBox(width: Field.gap),
        Switch(value: value, label: title, onChanged: onChanged),
      ],
    );
  }
}

/* ── §4 · slider ─────────────────────────────────────────────────────────── */

class _SliderSection extends StatefulWidget {
  const _SliderSection();

  @override
  State<_SliderSection> createState() => _SliderSectionState();
}

class _SliderSectionState extends State<_SliderSection> {
  /// `useState([10, 240])` and `useState([25])`.
  List<double> _price = <double>[10, 240];
  List<double> _odds = <double>[25];

  /// The matrix cells are uncontrolled on the reference and draggable, so they
  /// hold state here too.
  List<double> _default = <double>[40];
  List<double> _range = <double>[20, 70];

  /// `$10 – $240`, U+2013, **spaced**, unlike the two en dashes in §2's
  /// descriptions.
  String get _priceReadout => '\$${_price[0].toInt()} – \$${_price[1].toInt()}';

  @override
  Widget build(BuildContext context) {
    return Section(
      id: 'slider',
      title: 'Slider',
      description:
          'Ranges. The current value is always shown as a number '
          'beside the track: a slider without a readout is guesswork.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // The one Panel on the page with no `mt`.
          Panel(
            label: 'Price range filter',
            child: _measured(
              _measureMd,
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _Readout(label: 'Price range', value: _priceReadout),
                  Slider(
                    values: _price,
                    min: 0,
                    max: 500,
                    step: 5,
                    label: 'Price range',
                    onChanged: (List<double> next) =>
                        setState(() => _price = next),
                  ),
                  // `className="mt-3"`, 12px.
                  SizedBox(height: space(3)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      StyledText(r'$0', TextStyles.numberSm),
                      StyledText(r'$500', TextStyles.numberSm),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: space(4)),
          Panel(
            label: 'Single value',
            child: _measured(
              _measureMd,
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _Readout(
                    label: 'Auto-sell below rarity',
                    value: '${_odds.single.toInt()}%',
                  ),
                  // No `min`: the component defaults it to 0: and no footer.
                  Slider(
                    values: _odds,
                    label: 'Auto-sell threshold',
                    onChanged: (List<double> next) =>
                        setState(() => _odds = next),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: space(4)),
          StateGrid(
            cols: 3,
            children: <Widget>[
              StateCell(
                label: 'Default',
                child: SizedBox(
                  width: _matrixSlider,
                  child: Slider(
                    values: _default,
                    label: 'Default',
                    onChanged: (List<double> next) =>
                        setState(() => _default = next),
                  ),
                ),
              ),
              StateCell(
                label: 'Range',
                child: SizedBox(
                  width: _matrixSlider,
                  child: Slider(
                    values: _range,
                    label: 'Range',
                    onChanged: (List<double> next) =>
                        setState(() => _range = next),
                  ),
                ),
              ),
              StateCell(
                label: 'Disabled',
                child: SizedBox(
                  width: _matrixSlider,
                  child: Slider(
                    values: const <double>[40],
                    enabled: false,
                    label: 'Disabled',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// `div.mb-4.flex.items-baseline.justify-between`: the label and its number.
class _Readout extends StatelessWidget {
  const _Readout({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    return Padding(
      // `mb-4`, 16px.
      padding: EdgeInsets.only(bottom: space(4)),
      // A Row with spaceBetween cannot give way: at 2x text scale the label
      // and the value can outgrow a narrow matrix cell together. Wrap keeps
      // the same spaceBetween reading at desktop width and drops the value
      // to its own line only once the row genuinely runs out of room.
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        runSpacing: space(1),
        children: <Widget>[
          StyledText(label, TextStyles.small),
          StyledText(value, TextStyles.numberBase, color: theme.foreground),
        ],
      ),
    );
  }
}

/* ── §5 · api ────────────────────────────────────────────────────────────── */

class _ApiSection extends StatelessWidget {
  const _ApiSection();

  @override
  Widget build(BuildContext context) {
    return const Section(
      id: 'api',
      title: 'API',
      child: Meta(
        items: <MetaItem>[
          (
            k: 'Checkbox',
            v: TextSpan(
              text:
                  'checked accepts true, false or "indeterminate". Use '
                  'indeterminate for partial bulk selection.',
            ),
          ),
          (
            k: 'RadioGroup',
            v: TextSpan(
              text:
                  'RadioGroup + RadioGroupItem. Wrap each item in a Label '
                  'so the whole card is clickable.',
            ),
          ),
          (
            k: 'Switch',
            v: TextSpan(
              text:
                  'Immediate-effect settings only. Always paired with a '
                  'FieldLabel and FieldDescription.',
            ),
          ),
          (
            k: 'Slider',
            v: TextSpan(
              text:
                  'value as an array. Two entries makes it a range. Always '
                  'render the value as text too.',
            ),
          ),
          (
            k: 'has-[[data-state=checked]]:',
            v: TextSpan(
              text:
                  'The Tailwind pattern for styling a wrapper based on the '
                  'control inside it: used for selected option cards.',
            ),
          ),
        ],
      ),
    );
  }
}

/* ── §6 · rules ──────────────────────────────────────────────────────────── */

class _RulesSection extends StatelessWidget {
  const _RulesSection();

  @override
  Widget build(BuildContext context) {
    return Section(
      id: 'rules',
      title: 'Rules',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // DRIFT 12. Five against four: the first `DoDont` in the corpus
          // whose columns are different lengths.
          const DoDont(
            dos: <String>[
              'Use indeterminate on a bulk-select header whenever some but '
                  'not all rows are selected.',
              'Make the whole option card clickable, not just the 16px '
                  'control.',
              "Show a slider's current value with the shared type-num "
                  'foundation.',
              'Reserve Switch for settings that apply instantly.',
              'Tint selected rows blue so selection reads at a glance.',
            ],
            donts: <String>[
              "Don't use a Switch next to a Save button: that is a "
                  'checkbox.',
              "Don't use a radio group for two options that are really on "
                  'and off.',
              "Don't ship a slider without a numeric readout.",
              "Don't rely on the tick or dot alone; selected rows should "
                  'change background too.',
            ],
          ),
          SizedBox(height: space(4)),
          const Note(child: _RulesNoteBody()),
        ],
      ),
    );
  }
}

class _RulesNoteBody extends StatelessWidget {
  const _RulesNoteBody();

  @override
  Widget build(BuildContext context) {
    return RichText(
      TextSpan(
        children: <InlineSpan>[
          const TextSpan(text: 'Indeterminate is set with '),
          Code.span('checked="indeterminate"'),
          const TextSpan(
            text:
                ', not a separate prop. Getting this wrong is the most '
                'common bug in bulk selection headers.',
          ),
        ],
      ),
      TextStyles.small,
    );
  }
}
