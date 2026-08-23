/// `/design-system/components/base/buttons`: the first non-foundations page
/// in the port.
///
/// Nine sections, and almost nothing on it is a picture of a control: the
/// eight variant cells are live [DsButton]s, the ladder is five real rungs, the
/// six live buttons press and take focus, the three toggles toggle, the segment
/// group's pill travels, and all four IconSwap wheels roll. Two cells are
/// deliberately **stills**: see the drift register, entries 13 and 14.
///
/// Three shell facts differ from the six foundations pages, and only three
/// (buttons-map §0): the route nests two levels deeper; the eyebrow is
/// composed rather than literal, which is why it says "Base" twice; and `Row`,
/// `StateGrid` and `StateCell` render for the first time in the corpus. All
/// three of those are kit primitives in the reference, so they were promoted
/// into `kit.dart`: the lattice out of the icons page's own private fork
/// rather than copied a third time (supervisor ruling B10).
///
/// **What is not ported, and why.**
/// * **`asChild`** (ruling B4). Radix `Slot` renders the child in the button's
///   place, for links dressed as buttons. There is no Flutter analogue and no
///   anchor element to delegate to, so the `#api` row ships verbatim: a
///   printed API row is copy, and the fidelity bar is the reference's own copy
///  : and the divergence is recorded here instead of an invented API.
/// * **`aria-pressed` on the IconSwap demos.** Three of the four set it (the
///   fourth does not; drift 23). `DsButton` exposes `label` and `enabled` and
///   the pinned SDK's `SemanticsProperties` has no pressed-button flag that is
///   not also a checkbox or a switch, so a toggling *button* cannot announce
///   its state without announcing the wrong role. Recorded, not faked: the
///   same call `button.dart` makes for `aria-busy` (ruling B9).
/// * **`fill-value-ink`** on the favourited heart is page-local painting, not a
///   component API: see [_FilledGlyph], and ruling I3 for the precedent.
///
/// Reference drifts, all shipped as written (buttons-map §14). Where a drift
/// belongs to a component rather than to this page, it is recorded at its own
/// source and named here so the register stays complete.
/// 1. **The eyebrow says "Base" twice.** `eyebrow={`${group.title} · Base`}`
///    with `group.title = "Base Components"`: see [ButtonsPage.build].
/// 2. **"Press scales to 97% over 150ms"** in the `#states` caption, against
///    `scale-95` and `btn-spring`'s asymmetric in/out. Three numbers, none of
///    them the one that runs. The caption ships; the spring is what presses.
/// 3. **"the width stays stable"**, said four times: the `#states` cell note,
///    the `#api` `loading` row, Do #4, and the prop's own JSDoc: against a
///    **prepended** spinner that adds its own width plus the rung's gap. All
///    four ship. Stated once more in `DsButton.loading`.
/// 4. **The spinner is silent.** `Spinner` hands `role="status"` and
///    `aria-label="Loading"` to `Icon`, which destructures neither; only
///    `aria-busy` survives, and Flutter has no `aria-busy` (ruling B9).
/// 5. **"selection is always blue"** in the `#toggle` caption, against
///    `data-[state=on]:bg-muted`: the pressed Toggle is **grey**. Blue
///    selection is real one panel further down and only there.
/// 6. **`Icon size="sm"` renders 16px** inside a button: the base class list's
///    `size-4` beats the attribute, while `strokeWidth` keeps the 14px value.
///    Seven glyphs on this page. Carried by `DsButton.iconPxFor`.
/// 7. **ButtonGroup end radii are asymmetric**: the trailing member is forced
///    to the container radius while the leading one keeps its own pill.
/// 8. **`ButtonGroupText` sets no `data-slot`**, so the rule that rounds the
///    trailing member reaches straight past it.
/// 9. **The travelling pill is a stadium; the item under it is a rounded
///    rect.** Hover-on-unselected and selected are two shapes in one slot.
/// 10. **Three inert declarations on `Toggle variant="default"`**: a border
///    colour with no border, and a hover ink the element already inherits.
/// 11. **Two press feels on one page.** A Button springs and scales; a Toggle
///    and a ToggleGroupItem cross-fade every property and do not scale at all.
/// 12. **Disabled opacity differs by component**, 45% on a Button, 50% on a
///    Toggle. The `#states` cell note says "45% opacity", which is true of the
///    Button three sections above the disabled Toggle.
/// 13. **The "Hover" state cell does not show hover.** `className="bg-action"`
///    repaints the colour `--primary` already is, so the cell is
///    pixel-identical to "Default": see [_StatesSection].
/// 14. **The "Focus" state cell is a hand-drawn still**, not a focused
///    control: it reproduces the ring and the border, and not the transition a
///    real `:focus-visible` runs. See [_FocusStill].
/// 15. **Five size rungs, three type sizes, and only three of six type classes
///    carry a line-height at all.** Stated in full on `DsButtonSize`.
/// 16. **`ButtonGroupText className="type-num"` does not render as
///    `type-num`**: the utilities beat the component layer on size and
///    weight, and the mono family, the tabular figures and the tracking
///    survive. Pre-resolved as `DsComponentType.buttonGroupNum`.
/// 17. **`icon-xs` is documented and never rendered.** The cva declares it,
///    the `#api` table prints it, the page shows eight of the nine. Built
///    anyway (ruling B3), so the printed row stays true.
/// 18. **`Kbd` is flat**: no border, no shadow: while `--shadow-key`,
///    `--shadow-key-down` and `press-key` exist for exactly this object and
///    are documented one foundations page away.
/// 19. **`KbdGroup` renders a `<kbd>`** while typed as a `div`, so the first
///    row of `#kbd` is a `<kbd>` nesting two `<kbd>`s.
/// 20. **"No crossfades, no instant swaps"** in the IconSwap intro, against a
///    roll that transitions opacity on the same spring as the transform.
/// 21. **`swap-roll`'s comment is not a comment**: the rule opens with a
///    backslash, so the parser discards it. Nothing renders differently; it is
///    recorded because the utility below it is what this page's wheels use.
/// 22. **`emphasis="caps"` shrinks the type**, and cell 8 sits in the same
///    four-up grid as seven larger labels.
/// 23. **`PlayPauseDemo` omits `aria-pressed`** while the panel's own closing
///    copy says to add it "when it is a toggle": and its caption reads
///    "Playing"/"Paused", which is state. See [_PlayPauseDemo].
/// 24. **`--shadow-btn`'s use copy names three variants and one wears it.** In
///    the eight-cell variants grid, `outline` is a machine surface while
///    `secondary`, `destructive`, `ghost` and `link` are flat.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../kit.dart';
import '../nav.dart';

/* ── Page data ───────────────────────────────────────────────────────────── */

/// `#sizes` block B: the inline array literal at `page:125–131`, the page's
/// only module-level data.
///
/// Rendered as `<span class="type-num-sm">{k}</span>, {v}`, where the
/// separator is a literal space, U+2014, and another space.
const List<(String, String)> _sizeUse = <(String, String)>[
  ('xs · 24px', 'Chips inside a combobox. Internal use only.'),
  ('sm · 32px', 'Table row actions, card footers, filter chips.'),
  ('default · 40px', 'The standard. Forms, dialogs, most actions.'),
  ('lg · 48px', 'Primary action on a card or detail page.'),
  ('xl · 56px', 'Landing hero and headline moments. Once per screen.'),
];

/// `#api`: five rows, every separator U+00B7.
///
/// The `size` row is the authority for the nine-rung ladder and it prints
/// `icon-xs`, which the page never renders (drift 17); the `loading` row
/// repeats the width claim `DsButton.loading` disproves (drift 3); and
/// `asChild` describes a prop this port does not have (ruling B4). All three
/// ship as written: a printed API row is copy.
const List<(String, String)> _apiRows = <(String, String)>[
  (
    'variant',
    'default · premium · secondary · outline · ghost · destructive · link. '
        'Default: default.',
  ),
  (
    'size',
    'xs · sm · default · lg · xl · icon-xs · icon-sm · icon · icon-lg. '
        'Default: default.',
  ),
  (
    'emphasis',
    'none · caps. Caps applies uppercase with 0.09em tracking, for headline '
        'and money CTAs.',
  ),
  (
    'loading',
    'Adds a spinner, sets aria-busy and disables the button. The label stays '
        'so width does not jump.',
  ),
  (
    'asChild',
    'Renders the child instead of a button — use for links that should look '
        'like buttons.',
  ),
];

/// `#rules`. `DoDont` takes `string[]`, so nothing inside is a code chip, and
/// every apostrophe in the donts is the straight ASCII one.
const List<String> _dos = <String>[
  'Keep one primary or premium button per decision area.',
  'Use premium lime only for money and reward actions — deposit, claim, buy, '
      'withdraw.',
  'Give every icon-only button an aria-label.',
  "Use loading rather than swapping the label to 'Please wait' — the width "
      'stays stable.',
  'Write labels as actions: Open Pack, Sell Selected, Request Withdrawal.',
];

const List<String> _donts = <String>[
  "Don't put two blue buttons side by side; make the lesser one secondary or "
      'outline.',
  "Don't use lime for Cancel, Back or Close.",
  "Don't use the destructive variant for anything reversible.",
  "Don't remove the focus ring, even when it looks heavy against lime.",
  "Don't write vague labels like Proceed, Continue Process or Submit Action.",
];

/* ── Page ────────────────────────────────────────────────────────────────── */

class ButtonsPage extends StatelessWidget {
  const ButtonsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final DsCategoryHit here = findCategory('base', 'buttons');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DsPageHeader(
          // DRIFT 1. The foundations pages pass `group.title` alone; this one
          // interpolates a second literal after it, and the group is already
          // called "Base Components": so the eyebrow reads "Base Components ·
          // Base". The separator is U+00B7.
          eyebrow: '${here.group.title} · Base',
          title: here.category.title,
          blurb: here.category.blurb,
          // Six chips against nine sections: `IconSwap` has no chip and is a
          // third of `#toggle`. The chips are a subset of the page in the
          // reference too (ruling B1).
          contents: here.category.contents,
        ),
        const _VariantsSection(),
        const _SizesSection(),
        const _StatesSection(),
        const _IconsSection(),
        const _GroupsSection(),
        const _ToggleSection(),
        const _KbdSection(),
        const _ApiSection(),
        const _RulesSection(),
        // `buttons` is index 0 of `base`, so `prev` is null and the kit renders
        // the bare spacer in its place: the first one-sided foot nav that is
        // missing its *left* half.
        const DsPageFootNav(groupId: 'base', slug: 'buttons'),
      ],
    );
  }
}

/* ── #variants ───────────────────────────────────────────────────────────── */

class _VariantsSection extends StatelessWidget {
  const _VariantsSection();

  @override
  Widget build(BuildContext context) {
    return DsSection(
      id: 'variants',
      title: 'Variants',
      description:
          'Seven variants, ordered by emphasis. Only one primary or '
          'premium button should be visible in any single decision area — if '
          'two compete, the user cannot tell what the screen wants.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // `cols={4}`, `grid-cols-2 sm:grid-cols-4`, so 4×2 at this frame.
          DsStateGrid(
            cols: 4,
            children: <Widget>[
              DsStateCell(
                label: 'default',
                note: 'Primary action. Blue.',
                child: DsButton(
                  onPressed: () {},
                  child: const Text('Open Pack'),
                ),
              ),
              DsStateCell(
                label: 'premium',
                note: 'Money & reward. Lime.',
                child: DsButton(
                  variant: DsButtonVariant.premium,
                  onPressed: () {},
                  child: const Text('Deposit Funds'),
                ),
              ),
              DsStateCell(
                label: 'secondary',
                note: 'Neutral, beside a primary.',
                child: DsButton(
                  variant: DsButtonVariant.secondary,
                  onPressed: () {},
                  child: const Text('View Hits'),
                ),
              ),
              DsStateCell(
                label: 'outline',
                note: 'Must not compete.',
                child: DsButton(
                  variant: DsButtonVariant.outline,
                  onPressed: () {},
                  child: const Text('Filters'),
                ),
              ),
              DsStateCell(
                label: 'ghost',
                note: 'Toolbars, dismissals.',
                child: DsButton(
                  variant: DsButtonVariant.ghost,
                  onPressed: () {},
                  child: const Text('Skip'),
                ),
              ),
              DsStateCell(
                label: 'destructive',
                note: 'Sell back, delete.',
                child: DsButton(
                  variant: DsButtonVariant.destructive,
                  onPressed: () {},
                  child: const Text('Sell All'),
                ),
              ),
              DsStateCell(
                label: 'link',
                note: 'Inline text action.',
                // Still a 40px pill with 16px of horizontal padding that
                // scales on press and takes the blue ring: a "text button"
                // only in what it paints.
                child: DsButton(
                  variant: DsButtonVariant.link,
                  onPressed: () {},
                  child: const Text('Forgot password?'),
                ),
              ),
              DsStateCell(
                label: 'premium + caps',
                note: 'Hero CTA treatment.',
                // DRIFT 22: `caps` is an axis, not a rung: it beats the
                // size's own class, so this label is *smaller* than the seven
                // beside it, and uppercased.
                child: DsButton(
                  variant: DsButtonVariant.premium,
                  emphasis: DsButtonEmphasis.caps,
                  onPressed: () {},
                  child: const Text('Claim Reward'),
                ),
              ),
            ],
          ),
          SizedBox(height: ds(4)),
          DsNote(
            tone: DsNoteTone.value,
            title: 'The lime button is rationed',
            child: DsRichText(
              TextSpan(
                children: <InlineSpan>[
                  DsCode.span('premium'),
                  const TextSpan(
                    text:
                        ' is the only variant permitted to glow, and only on '
                        'hover. Use it for depositing, claiming, purchasing '
                        'and confirming a withdrawal. A lime Cancel button '
                        'would be a bug.',
                  ),
                ],
              ),
              DsType.small,
            ),
          ),
        ],
      ),
    );
  }
}

/* ── #sizes ──────────────────────────────────────────────────────────────── */

class _SizesSection extends StatelessWidget {
  const _SizesSection();

  /// The five rungs the ladder shows, with the caption printed under each.
  static const List<(DsButtonSize, String, String)> _ladder =
      <(DsButtonSize, String, String)>[
        (DsButtonSize.xs, 'Extra small', 'xs · 24px'),
        (DsButtonSize.sm, 'Small', 'sm · 32px'),
        (DsButtonSize.md, 'Medium', 'default · 40px'),
        (DsButtonSize.lg, 'Large', 'lg · 48px'),
        (DsButtonSize.xl, 'Hero', 'xl · 56px'),
      ];

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);

    return DsSection(
      id: 'sizes',
      title: 'Sizes',
      // The straight apostrophe in "product's" is the reference's.
      description:
          '32 / 40 / 48 / 56, plus a 24px step for dense internals. '
          'This ladder is intentionally taller than stock shadcn — a premium '
          "product's primary action cannot be 32px.",
      child: DsPanel(
        label: 'The ladder',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // `align="end"`. The caption block is the same height under all
            // five columns, so aligning the columns' bottoms aligns the
            // buttons' bottoms too: the ladder gets a shared baseline free.
            DsRow(
              align: DsRowAlign.end,
              children: <Widget>[
                for (final (DsButtonSize, String, String) rung in _ladder)
                  _LadderColumn(
                    size: rung.$1,
                    label: rung.$2,
                    caption: rung.$3,
                  ),
              ],
            ),
            Container(
              // `mt-6 … border-t border-border pt-5`: margin outside the
              // rule, padding inside it, which is the order a border box
              // stacks them in.
              margin: EdgeInsets.only(top: ds(6)),
              padding: EdgeInsets.only(top: ds(5)),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: theme.border,
                    width: DsWidths.hairline,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // `space-y-2`.
                  for (int i = 0; i < _sizeUse.length; i++) ...<Widget>[
                    if (i > 0) SizedBox(height: ds(2)),
                    _SizeUseLine(entry: _sizeUse[i]),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// `<div className="text-center">`: one rung, over its caption.
class _LadderColumn extends StatelessWidget {
  const _LadderColumn({
    required this.size,
    required this.label,
    required this.caption,
  });

  final DsButtonSize size;
  final String label;

  /// `.type-micro`, so it is uppercased at paint time and the source stays
  /// greppable.
  final String caption;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        DsButton(size: size, onPressed: () {}, child: Text(label)),
        SizedBox(height: ds(3)),
        DsText(caption, DsType.micro, align: TextAlign.center),
      ],
    );
  }
}

/// `<p className="type-small"><span className="type-num-sm …">{k}</span>, {v}`.
///
/// Two families on one line, both landing on `--muted-foreground`: the mono
/// span states that colour itself and `.type-small` brings its own.
class _SizeUseLine extends StatelessWidget {
  const _SizeUseLine({required this.entry});

  final (String, String) entry;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);

    return DsRichText(
      TextSpan(
        children: <InlineSpan>[
          TextSpan(
            text: entry.$1,
            style: DsText.styleOf(
              context,
              DsType.numSm,
              color: theme.mutedForeground,
            ),
          ),
          TextSpan(text: ': ${entry.$2}'),
        ],
      ),
      DsType.small,
    );
  }
}

/* ── #states ─────────────────────────────────────────────────────────────── */

class _StatesSection extends StatelessWidget {
  const _StatesSection();

  /// The six live variants, in the order the panel renders them. `link` is
  /// absent: the one variant of the seven this row leaves out.
  static const List<(DsButtonVariant, String)> _live =
      <(DsButtonVariant, String)>[
        (DsButtonVariant.primary, 'Primary'),
        (DsButtonVariant.premium, 'Premium'),
        (DsButtonVariant.secondary, 'Secondary'),
        (DsButtonVariant.outline, 'Outline'),
        (DsButtonVariant.ghost, 'Ghost'),
        (DsButtonVariant.destructive, 'Destructive'),
      ];

  @override
  Widget build(BuildContext context) {
    return DsSection(
      id: 'states',
      title: 'States',
      description:
          'Hover, focus and active are live below: interact with '
          'them directly. Disabled and loading are shown as rendered.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // `cols={5}`, `grid-cols-2 sm:grid-cols-3 lg:grid-cols-5`, so one
          // clean row at this frame and only at this frame.
          DsStateGrid(
            cols: 5,
            children: <Widget>[
              DsStateCell(
                label: 'Default',
                child: DsButton(
                  onPressed: () {},
                  child: const Text('Open Pack'),
                ),
              ),
              DsStateCell(
                label: 'Hover',
                note: 'Hover it',
                // DRIFT 13. The reference adds `className="bg-action"` here,
                // and `--primary` **is** `var(--color-action)`: so the class
                // repaints the colour the button already paints and this cell
                // is pixel-identical to the one before it. Reproduced as the
                // no-op it is (ruling B8); the note admits it is live rather
                // than a still, and the real hover difference is the sheen
                // beating, which only a true hover starts.
                child: DsButton(
                  onPressed: () {},
                  child: const Text('Open Pack'),
                ),
              ),
              const DsStateCell(
                label: 'Focus',
                note: 'Tab to it',
                child: _FocusStill(),
              ),
              // No handler and `loading`: the reference passes neither an
              // `onClick` nor `disabled`, and `disabled = disabled || loading`
              // does the rest.
              const DsStateCell(
                label: 'Loading',
                note: 'Disabled, width held',
                child: DsButton(loading: true, child: Text('Open Pack')),
              ),
              const DsStateCell(
                label: 'Disabled',
                note: '45% opacity',
                child: DsButton(child: Text('Open Pack')),
              ),
            ],
          ),
          SizedBox(height: ds(4)),
          DsPanel(
            label: 'Live — press and hold, or tab through',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                DsRow(
                  children: <Widget>[
                    for (final (DsButtonVariant, String) v in _live)
                      DsButton(
                        variant: v.$1,
                        onPressed: () {},
                        child: Text(v.$2),
                      ),
                  ],
                ),
                SizedBox(height: ds(5)),
                // DRIFT 2: three numbers, none of which is the one that runs.
                DsText(
                  'Press scales to 97% over 150ms. Focus draws a blue ring '
                  'that is never removed. Both behaviours are built into the '
                  'variant base class, so no component has to remember them.',
                  DsType.small,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// `className="border-ring ring-3 ring-ring/50"` on a resting Button.
///
/// DRIFT 14, reproduced exactly (ruling B8). The reference hands the button
/// three utility classes and no focus: the border is recoloured, a `0 0 0 3px`
/// ring is composited in front of the variant's own shadow, and nothing else
/// about the control changes: it is a **still** of `:focus-visible`, not a
/// focused control, and it does not run the border transition a real focus
/// would.
///
/// So this draws the still rather than requesting focus. Focus is exclusive
/// and traversable: a genuinely focused specimen would steal the page's focus
/// on load and lose the state on the first Tab, which is not what the
/// reference renders. The overlay is a [DsMachineSurface] filling the button's
/// own box: same box, same pill, so the ring lands where the class puts it and
/// the 1px border paints over the transparent one the base class list carries,
/// with no effect on layout. Painting after the button is what "composited in
/// front of the shadow" means.
class _FocusStill extends StatelessWidget {
  const _FocusStill();

  /// `ring-ring/50`.
  static const double _ringAlpha = 0.50;

  /// The base the ring composites onto: the button paints its own
  /// `shadow-btn-primary` underneath, so this layer carries the ring alone.
  static const DsShadowSpec _bare = DsShadowSpec(<DsShadowLayer>[]);

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);

    return Stack(
      children: <Widget>[
        DsButton(onPressed: () {}, child: const Text('Open Pack')),
        Positioned.fill(
          child: IgnorePointer(
            child: DsMachineSurface(
              spec: DsButton.withFocusRing(
                _bare,
                theme.ring.withValues(alpha: _ringAlpha),
              ),
              radius: BorderRadius.circular(DsRadii.pill),
              border: Border.all(color: theme.ring, width: DsWidths.hairline),
              child: const SizedBox.expand(),
            ),
          ),
        ),
      ],
    );
  }
}

/* ── #icons ──────────────────────────────────────────────────────────────── */

class _IconsSection extends StatelessWidget {
  const _IconsSection();

  /// The four labelled buttons. Icon leads, label follows.
  static const List<(DsButtonVariant, DsIconGlyph, String)> _labelled =
      <(DsButtonVariant, DsIconGlyph, String)>[
        (DsButtonVariant.primary, DsIconGlyph.packageOpen, 'Open Pack'),
        (DsButtonVariant.premium, DsIconGlyph.wallet, 'Deposit Funds'),
        (DsButtonVariant.secondary, DsIconGlyph.share2, 'Share Pull'),
        (DsButtonVariant.destructive, DsIconGlyph.trash2, 'Sell Selected'),
      ];

  @override
  Widget build(BuildContext context) {
    return DsSection(
      id: 'icons',
      title: 'Icons and icon-only buttons',
      // Straight apostrophe in "button's", as the reference has it.
      description:
          "An icon inside a button inherits the button's colour. An "
          'icon-only button must carry an accessible name, or it is unusable '
          'with a screen reader.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          DsPanel(
            label: 'With a label',
            child: DsRow(
              children: <Widget>[
                for (final (DsButtonVariant, DsIconGlyph, String) b
                    in _labelled)
                  _LabelledIconButton(variant: b.$1, glyph: b.$2, label: b.$3),
              ],
            ),
          ),
          SizedBox(height: ds(4)),
          DsPanel(
            label: 'Icon only',
            // The page's only use of the panel's `note` slot.
            note: 'aria-label required',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                DsRow(
                  children: <Widget>[
                    DsButton(
                      size: DsButtonSize.iconSm,
                      variant: DsButtonVariant.ghost,
                      label: 'Search packs',
                      onPressed: () {},
                      child: DsIcon(
                        DsIconGlyph.search,
                        sizePx: DsButton.iconPxFor(DsButtonSize.iconSm),
                      ),
                    ),
                    DsButton(
                      size: DsButtonSize.icon,
                      variant: DsButtonVariant.outline,
                      label: 'Add to favourites',
                      onPressed: () {},
                      child: DsIcon(
                        DsIconGlyph.heart,
                        sizePx: DsButton.iconPxFor(DsButtonSize.icon),
                      ),
                    ),
                    DsButton(
                      size: DsButtonSize.iconLg,
                      label: 'Open pack',
                      onPressed: () {},
                      child: DsIcon(
                        DsIconGlyph.packageOpen,
                        sizePx: DsButton.iconPxFor(DsButtonSize.iconLg),
                      ),
                    ),
                    // The one glyph on the page that does not inherit its
                    // button's ink.
                    DsButton(
                      size: DsButtonSize.icon,
                      variant: DsButtonVariant.ghost,
                      label: 'Favourite this card',
                      onPressed: () {},
                      child: DsIcon(
                        DsIconGlyph.heart,
                        sizePx: DsButton.iconPxFor(DsButtonSize.icon),
                        tone: DsIconTone.value,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ds(5)),
                // `lime&rsquo;s`: a right single quotation mark.
                DsText(
                  'The last button uses the lime tone deliberately — a '
                  'favourited card is a value signal, and that is one of '
                  'lime’s permitted jobs.',
                  DsType.small,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A button holding an icon and a label, spaced by the rung's own `gap-*`.
///
/// DRIFT 6: the reference asks for `size="sm"`: a declared 14px: and the
/// base class list's `size-4` overrides the box to 16 while `strokeWidth`
/// keeps being computed from 14. The two coincide, so the rung's own
/// `iconPxFor` is what is written.
class _LabelledIconButton extends StatelessWidget {
  const _LabelledIconButton({
    required this.variant,
    required this.glyph,
    required this.label,
  });

  final DsButtonVariant variant;
  final DsIconGlyph glyph;
  final String label;

  @override
  Widget build(BuildContext context) {
    const DsButtonSize size = DsButtonSize.md;

    return DsButton(
      variant: variant,
      onPressed: () {},
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          DsIcon(glyph, sizePx: DsButton.iconPxFor(size)),
          SizedBox(width: DsButton.gapFor(size)),
          Text(label),
        ],
      ),
    );
  }
}

/* ── #groups ─────────────────────────────────────────────────────────────── */

class _GroupsSection extends StatelessWidget {
  const _GroupsSection();

  @override
  Widget build(BuildContext context) {
    return DsSection(
      id: 'groups',
      title: 'Button Group',
      description:
          'Joins related actions into one control. Used for view '
          'switching, quantity steppers and split actions.',
      child: DsPanel(
        label: 'Segmented actions',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // `w-fit`: a group shrinks to its members rather than filling the
            // panel, so the column starts them rather than stretching them.
            DsButtonGroup(
              children: <Widget>[
                for (final String label in const <String>[
                  'Newest',
                  'Price',
                  'Popularity',
                ])
                  DsButton(
                    variant: DsButtonVariant.outline,
                    onPressed: () {},
                    child: Text(label),
                  ),
              ],
            ),
            // `space-y-6`.
            SizedBox(height: ds(6)),
            DsButtonGroup(
              children: <Widget>[
                const DsButtonGroupText('Quantity'),
                const DsButtonGroupSeparator(),
                DsButton(
                  variant: DsButtonVariant.outline,
                  size: DsButtonSize.icon,
                  label: 'Decrease quantity',
                  onPressed: () {},
                  child: DsIcon(
                    DsIconGlyph.minus,
                    sizePx: DsButton.iconPxFor(DsButtonSize.icon),
                  ),
                ),
                // DRIFT 16: `className="type-num"` loses its size and its
                // weight to the utilities already on the element, and keeps
                // the mono family, the tabular figures and the tracking.
                const DsButtonGroupText('3', numeric: true),
                DsButton(
                  variant: DsButtonVariant.outline,
                  size: DsButtonSize.icon,
                  label: 'Increase quantity',
                  onPressed: () {},
                  child: DsIcon(
                    DsIconGlyph.plus,
                    sizePx: DsButton.iconPxFor(DsButtonSize.icon),
                  ),
                ),
              ],
            ),
            SizedBox(height: ds(6)),
            DsButtonGroup(
              children: <Widget>[
                DsButton(onPressed: () {}, child: const Text('Open Pack')),
                const DsButtonGroupSeparator(),
                DsButton(
                  size: DsButtonSize.icon,
                  label: 'More open options',
                  onPressed: () {},
                  child: DsIcon(
                    DsIconGlyph.chevronDown,
                    sizePx: DsButton.iconPxFor(DsButtonSize.icon),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/* ── #toggle ─────────────────────────────────────────────────────────────── */

class _ToggleSection extends StatelessWidget {
  const _ToggleSection();

  @override
  Widget build(BuildContext context) {
    return DsSection(
      id: 'toggle',
      // A literal ampersand in the heading.
      title: 'Toggle & Toggle Group',
      description:
          'For state that persists rather than actions that fire. '
          'View mode, favourite, and filter chips that stay on.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const DsPanel(label: 'Toggle', child: _TogglePanel()),
          SizedBox(height: ds(4)),
          const DsPanel(
            label: 'Toggle Group — three or more options',
            child: _ToggleGroupPanel(),
          ),
          SizedBox(height: ds(4)),
          const DsPanel(
            label: 'IconSwap — the two-state control',
            child: _IconSwapPanel(),
          ),
        ],
      ),
    );
  }
}

/// Three toggles: off, on, disabled: and the first two are live.
class _TogglePanel extends StatefulWidget {
  const _TogglePanel();

  @override
  State<_TogglePanel> createState() => _TogglePanelState();
}

class _TogglePanelState extends State<_TogglePanel> {
  /// `<Toggle>` and `<Toggle defaultPressed>`; the third is `disabled` and
  /// never moves, so it needs no slot.
  final List<bool> _pressed = <bool>[false, true];

  Widget _heart() => const DsIcon(DsIconGlyph.heart, size: DsIconSize.md);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DsRow(
          children: <Widget>[
            DsToggle(
              pressed: _pressed[0],
              onChanged: (bool v) => setState(() => _pressed[0] = v),
              label: 'Favourite',
              child: _heart(),
            ),
            DsToggle(
              pressed: _pressed[1],
              onChanged: (bool v) => setState(() => _pressed[1] = v),
              label: 'Favourite, on',
              child: _heart(),
            ),
            // A null handler is `disabled`: no pointer events, 50% opacity.
            DsToggle(
              pressed: false,
              label: 'Favourite, unavailable',
              child: _heart(),
            ),
          ],
        ),
        SizedBox(height: ds(5)),
        // DRIFT 5: the pressed fill is `--muted`, which is grey. The blue
        // selection this promises is real one panel down, and only there.
        DsText(
          'Off · On · Disabled. The pressed state fills with the blue tint — '
          'selection is always blue.',
          DsType.small,
        ),
      ],
    );
  }
}

/// `<ToggleGroup type="single" defaultValue="newest">`.
class _ToggleGroupPanel extends StatefulWidget {
  const _ToggleGroupPanel();

  @override
  State<_ToggleGroupPanel> createState() => _ToggleGroupPanelState();
}

class _ToggleGroupPanelState extends State<_ToggleGroupPanel> {
  /// `defaultValue="newest"`: index 0.
  int? _selected = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // `w-fit`, so the group is started rather than stretched.
        DsToggleGroup(
          items: const <DsToggleGroupItem>[
            DsToggleGroupItem(label: 'Newest'),
            DsToggleGroupItem(label: 'Price'),
            DsToggleGroupItem(label: 'Popular'),
          ],
          selectedIndex: _selected,
          // Radix `type="single"` clears the selection when the active option
          // is clicked again, and the pill fades out where it stands (ruling
          // B7). Mirrored rather than locked to one-always-selected.
          onChanged: (int? i) => setState(() => _selected = i),
        ),
        SizedBox(height: ds(5)),
        DsText(
          'A toggle group is for three or more mutually exclusive options. '
          'With exactly two, use IconSwap below — a segmented control for a '
          'binary choice wastes space and reads as weaker than it is.',
          DsType.small,
        ),
      ],
    );
  }
}

/// The four wheels, with the copy that frames them.
class _IconSwapPanel extends StatelessWidget {
  const _IconSwapPanel();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        // DRIFT 20: "No crossfades": and the roll transitions opacity on the
        // same spring as the transform, which clamps to full about a third of
        // the way through.
        DsText(
          'Every control that alternates between two icons swaps them through '
          'a vertical strip. Click each one: the icons are a physical wheel, '
          'so the old icon exits through the top and the next rises from '
          'below, landing with a jelly squash. No crossfades, no instant '
          'swaps — a control that changed meaning should show you that it '
          'changed.',
          DsType.small,
        ),
        SizedBox(height: ds(6)),
        // `flex flex-wrap items-start gap-10`.
        Wrap(
          spacing: ds(10),
          runSpacing: ds(10),
          crossAxisAlignment: WrapCrossAlignment.start,
          children: <Widget>[
            _ViewSwitchDemo(),
            _PlayPauseDemo(),
            _FavouriteDemo(),
            _MuteDemo(),
          ],
        ),
        SizedBox(height: ds(6)),
        DsRichText(
          TextSpan(
            children: <InlineSpan>[
              const TextSpan(text: 'Put '),
              DsCode.span('IconSwap'),
              const TextSpan(
                text: ' inside a Button as its child, and give the button an ',
              ),
              DsCode.span('aria-label'),
              const TextSpan(
                text: ' that describes what pressing it will do — plus ',
              ),
              DsCode.span('aria-pressed'),
              const TextSpan(text: ' when it is a toggle.'),
            ],
          ),
          DsType.small,
        ),
      ],
    );
  }
}

/// `<div className="flex flex-col items-center gap-3">`: a wheel over its
/// caption.
class _SwapDemo extends StatelessWidget {
  const _SwapDemo({required this.control, required this.caption});

  final Widget control;

  /// `.type-micro`, uppercased at paint time.
  final String caption;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      control,
      SizedBox(height: ds(3)),
      DsText(caption, DsType.micro, align: TextAlign.center),
    ],
  );
}

/// `ViewSwitchDemo`: an outline icon button, grid ⇄ list.
class _ViewSwitchDemo extends StatefulWidget {
  const _ViewSwitchDemo();

  @override
  State<_ViewSwitchDemo> createState() => _ViewSwitchDemoState();
}

class _ViewSwitchDemoState extends State<_ViewSwitchDemo> {
  bool _list = false;

  @override
  Widget build(BuildContext context) {
    const DsButtonSize size = DsButtonSize.icon;
    final double glyph = DsButton.iconPxFor(size);

    return _SwapDemo(
      caption: 'View · ${_list ? 'list' : 'grid'}',
      control: DsButton(
        variant: DsButtonVariant.outline,
        size: size,
        // `aria-pressed={view === "list"}` has no port: see the library note.
        label: _list ? 'Switch to grid view' : 'Switch to list view',
        onPressed: () => setState(() => _list = !_list),
        child: DsIconSwap(
          activeIndex: _list ? 1 : 0,
          // `className="size-5"`: the clip window, 4px wider than the glyph.
          window: ds(5),
          cell: glyph,
          icons: <Widget>[
            DsIcon(DsIconGlyph.layoutGrid, sizePx: glyph),
            DsIcon(DsIconGlyph.rows3, sizePx: glyph),
          ],
        ),
      ),
    );
  }
}

/// `PlayPauseDemo`: the one demo on a 48px button, and the one that omits
/// `aria-pressed` (drift 23) while captioning itself with state.
class _PlayPauseDemo extends StatefulWidget {
  const _PlayPauseDemo();

  @override
  State<_PlayPauseDemo> createState() => _PlayPauseDemoState();
}

class _PlayPauseDemoState extends State<_PlayPauseDemo> {
  bool _playing = false;

  @override
  Widget build(BuildContext context) {
    const DsButtonSize size = DsButtonSize.iconLg;
    final double glyph = DsButton.iconPxFor(size);

    return _SwapDemo(
      caption: _playing ? 'Playing' : 'Paused',
      control: DsButton(
        size: size,
        label: _playing ? 'Pause' : 'Play',
        onPressed: () => setState(() => _playing = !_playing),
        child: DsIconSwap(
          activeIndex: _playing ? 1 : 0,
          // `className="size-6"`.
          window: ds(6),
          cell: glyph,
          icons: <Widget>[
            DsIcon(DsIconGlyph.play, sizePx: glyph),
            DsIcon(DsIconGlyph.pause, sizePx: glyph),
          ],
        ),
      ),
    );
  }
}

/// `FavouriteDemo`: the only wheel whose two cells differ in colour as well
/// as in shape, and the only filled glyph on the page.
class _FavouriteDemo extends StatefulWidget {
  const _FavouriteDemo();

  @override
  State<_FavouriteDemo> createState() => _FavouriteDemoState();
}

class _FavouriteDemoState extends State<_FavouriteDemo> {
  bool _on = false;

  @override
  Widget build(BuildContext context) {
    const DsButtonSize size = DsButtonSize.icon;
    final double glyph = DsButton.iconPxFor(size);

    return _SwapDemo(
      caption: _on ? 'Favourited' : 'Not favourited',
      control: DsButton(
        variant: DsButtonVariant.secondary,
        size: size,
        label: _on ? 'Remove from favourites' : 'Add to favourites',
        onPressed: () => setState(() => _on = !_on),
        child: DsIconSwap(
          activeIndex: _on ? 1 : 0,
          window: ds(5),
          cell: glyph,
          icons: <Widget>[
            DsIcon(DsIconGlyph.heart, sizePx: glyph, tone: DsIconTone.subtle),
            _FilledGlyph(
              glyph: DsIconGlyph.heart,
              px: glyph,
              tone: DsIconTone.value,
            ),
          ],
        ),
      ),
    );
  }
}

/// `MuteDemo`: a ghost icon button, sound ⇄ muted.
class _MuteDemo extends StatefulWidget {
  const _MuteDemo();

  @override
  State<_MuteDemo> createState() => _MuteDemoState();
}

class _MuteDemoState extends State<_MuteDemo> {
  bool _muted = false;

  @override
  Widget build(BuildContext context) {
    const DsButtonSize size = DsButtonSize.icon;
    final double glyph = DsButton.iconPxFor(size);

    return _SwapDemo(
      caption: _muted ? 'Muted' : 'Sound on',
      control: DsButton(
        variant: DsButtonVariant.ghost,
        size: size,
        label: _muted ? 'Unmute' : 'Mute',
        onPressed: () => setState(() => _muted = !_muted),
        child: DsIconSwap(
          activeIndex: _muted ? 1 : 0,
          window: ds(5),
          cell: glyph,
          icons: <Widget>[
            DsIcon(DsIconGlyph.volume2, sizePx: glyph),
            DsIcon(DsIconGlyph.volumeX, sizePx: glyph),
          ],
        ),
      ),
    );
  }
}

/// `<Icon … className="fill-value-ink" />`: a glyph whose interior is
/// painted as well as stroked.
///
/// `fill` is an SVG paint property, not a size or a tone: lucide's paths ship
/// `fill="none"` and [DsIcon] has no parameter that would override it, because
/// exactly one glyph in the curated set fills anything and it fills a dot.
/// So the interior is painted here, under the real glyph, out of the **same**
/// transcribed path: page-local painting rather than a component API, which
/// is the call ruling I3 makes for the inputs page's drawn focus ring.
///
/// Order matters and matches the browser's: fill first, stroke over it.
class _FilledGlyph extends StatelessWidget {
  const _FilledGlyph({
    required this.glyph,
    required this.px,
    required this.tone,
  });

  final DsIconGlyph glyph;
  final double px;

  /// Resolved once and used for both passes, the way `currentColor` and
  /// `fill-value-ink` land on the same token here.
  final DsIconTone tone;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: px,
      height: px,
      child: CustomPaint(
        painter: _GlyphFill(
          glyph: glyph,
          color: DsIcon.colorFor(context, tone),
        ),
        // A [CustomPaint] painter draws behind its child, which is the
        // stacking order `fill` and `stroke` have inside one `<path>`.
        child: DsIcon(glyph, sizePx: px, tone: tone),
      ),
    );
  }
}

class _GlyphFill extends CustomPainter {
  const _GlyphFill({required this.glyph, required this.color});

  final DsIconGlyph glyph;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    canvas.save();
    // The same fit [DsIcon] uses: lucide's 24-unit space into the rendered box.
    canvas.scale(
      size.width / DsIconPaths.viewBox,
      size.height / DsIconPaths.viewBox,
    );
    canvas.drawPath(DsIconPaths.pathFor(glyph), Paint()..color = color);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_GlyphFill old) =>
      old.glyph != glyph || old.color != color;
}

/* ── #kbd ────────────────────────────────────────────────────────────────── */

class _KbdSection extends StatelessWidget {
  const _KbdSection();

  @override
  Widget build(BuildContext context) {
    return DsSection(
      id: 'kbd',
      title: 'Kbd',
      description:
          'Keyboard hints. The product is fully keyboard navigable, '
          'so shortcuts are surfaced rather than hidden.',
      child: DsPanel(
        label: 'Shortcut hints',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DsRow(
              children: <Widget>[
                // DRIFT 19: a `<kbd>` nesting two `<kbd>`s: the group renders
                // the same element its members do while typed as a `div`.
                DsKbdGroup(children: <Widget>[DsKbd('Ctrl'), DsKbd('K')]),
                DsText('Open search', DsType.small),
              ],
            ),
            // `space-y-4`.
            SizedBox(height: ds(4)),
            DsRow(
              children: <Widget>[
                DsKbd('Space'),
                DsText('Reveal next card', DsType.small),
              ],
            ),
            SizedBox(height: ds(4)),
            DsRow(
              children: <Widget>[
                DsKbd('Esc'),
                DsText('Skip the opening sequence', DsType.small),
              ],
            ),
          ],
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
      // One of the two sections that pass no description.
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
    return const DsSection(
      id: 'rules',
      title: 'Rules',
      // DRIFT 3, a fourth time: Do #4 restates the width claim the prepended
      // spinner disproves.
      child: DsDoDont(dos: _dos, donts: _donts),
    );
  }
}
