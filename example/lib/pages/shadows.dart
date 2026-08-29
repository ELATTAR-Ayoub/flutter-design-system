/// `/design-system/shadows`: the Shadows foundation page.
///
/// Two families, and the page exists to make the difference physical. Ambient
/// depth says how far a surface floats; machine depth says whether it can be
/// pressed. Nothing here is a drawing of a shadow: every specimen is the real
/// `--shadow-*` token painted by [Surface], and `#in-use` is five live
/// [Button]s and one genuinely editable [Input]: so "press the buttons and
/// focus the field" is a thing the reader can do rather than a thing the page
/// claims.
///
/// ## Drifts (shadows-map §12: recorded, shipped as written, never fixed)
///
/// 1. **`--shadow-btn`'s use copy against the buttons.** The specimen says
///    *"Secondary, outline and destructive buttons."* Only
///    [ButtonVariant.outline] carries `shadow-btn`; `secondary` and
///    `destructive` declare no shadow class at all. Visible in `#in-use` on
///    this very page: "View Hits" is flat, "Filters" is an inset surface.
/// 2. **The `#in-use` caption against its own specimens.** *"Buttons carry
///    `shadow-btn` or `shadow-btn-primary`…"*: the premium button carries
///    `shadow-btn-value` (swapping to `shadow-glow-value` on hover), and two of
///    the five carry nothing.
/// 3. **`glass-control` says 44px; the specimen is `h-12`.** The copy, the CSS
///    comment and the utility's own rationale all say 44; the render is 48.
///    Supervisor ruling S8: print 44, render 48, [_glassControlHeight].
/// 4. **"Two utilities, one material": there are three.** `glass-panel`,
///    `glass-panel-deep` and `glass-control` all exist ([GlassVariant.prominent] has
///    a home in the package). The Panel label narrows honestly to
///    "glass-panel and glass-control"; the section description does not.
/// 5. **The glow cells' rim classes differ from the spacing page's.** Here
///    `border-primary/40` and `border-value/40`; spacing uses
///    `border-action/40`. `--primary` *is* `var(--color-action)`, so the pixels
///    are identical and the source is not.
/// 6. **The glow captions differ across pages.** Shadows says "Says …" and
///    "Celebrated tiers, reward unlocks, premium actions"; spacing says
///    "Signals …" and "Legendary or mythic reveal, reward unlock, premium
///    action". Same two glows, two copies.
/// 7. **The Input's own JSDoc claims "a placeholder at 60% muted".** The class
///    is `placeholder:text-muted-foreground` at full opacity: prose describing
///    an intent the class never carried. [Input] renders the class.
/// 8. **`--shadow-key` / `--shadow-key-down` name the `press-key` utility**,
///    which exists in globals.css and is never demonstrated. The two tokens
///    render as unrelated stills side by side rather than as one key in two
///    positions, so this page ships them as stills too.
/// 9. **`--radius-4xl` renders here (32px) while the spacing page's ladder is
///    labelled "Seven steps" and stops at `3xl`.** This is the page where the
///    undocumented rung actually appears, [Radii.xl4], on both glass cells.
/// 10. **Fonts.** The globals prose and the nav blurbs say Space Grotesk;
///    `--font-sans` / `--font-heading` are "Inter Local". Per the project
///    decision, fonts follow tokens, not prose.
///
/// One correction to the map, made against the reference source: shadows-map
/// §5 counts *four* `Code` chips in the `#in-use` caption. `page.tsx` has
/// **five**, `shadow-btn`, `shadow-btn-primary`, `shadow-btn-down`, `:active`
/// and `shadow-pressed`. Five ship.
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

/// `border-primary/40`, `border-value/40`: the two glow boxes' rims. Drift 5
/// lives in the class name, not the number: the spacing page spells the first
/// one `border-action/40` and paints the identical colour.
const double _glowBorderAlpha = 0.40;

/// Tailwind's `leading-snug` ratio, which the twelve specimen captions in
/// `#ambient` and `#machine` override `.type-small`'s own 1.5 with.
/// `globals.css` declares no `--leading-*` token for it, so it cannot come from
/// the foundation layer.
// allow-hardcoded: framework default with no token to read it from.
const double _leadingSnug = 1.375;

/// Preflight's `b, strong { font-weight: bolder }`. Outside `.prose`,
/// `globals.css` styles neither `<strong>` nor `<em>`, so the framework default
/// applies and `bolder` against the inherited 400 computes to exactly this.
// allow-hardcoded: framework default with no token to read it from.
const double _bolder = 700;

/// `max-w-sm`, 24rem. Tailwind's **container** scale, which `globals.css` does
/// not override (shadows-map §0); it is not the spacing scale, so it is not
/// `space(96)` even though the two coincide here.
// allow-hardcoded: framework default with no token to read it from.
const double _measureSm = 384;

/// `h-24`: the height every specimen box on this page shares.
final double _specimenHeight = space(24);

/// `h-12`: the `glass-control` specimen. **Drift 3:** the caption beside it
/// says 44px. Ruling S8 is to print the copy and render the class.
final double _glassControlHeight = space(12);

/* ── Page data (the reference's two module-level arrays) ─────────────────── */

/// One shadow specimen: the class the box wears, the token it prints, the spec
/// that paints it, and what it is for.
typedef _Specimen = ({String token, String cls, ShadowStyle spec, String use});

/// `const ambient`: four ambient steps. The four `use` strings are
/// **character-identical** to the spacing page's Elevation panel; only the
/// section description differs between the two pages, and both ship as written.
final List<_Specimen> _ambient = <_Specimen>[
  (
    token: '--shadow-e1',
    cls: 'shadow-e1',
    spec: Shadows.sm,
    use: 'Resting rows, chips, table headers. Barely there.',
  ),
  (
    token: '--shadow-e2',
    cls: 'shadow-e2',
    spec: Shadows.md,
    use: 'Cards and pack cards at rest.',
  ),
  (
    token: '--shadow-e3',
    cls: 'shadow-e3',
    spec: Shadows.lg,
    use: 'Hovered cards, popovers, dropdowns, sticky bars.',
  ),
  (
    token: '--shadow-e4',
    cls: 'shadow-e4',
    spec: Shadows.xl,
    use: 'Dialogs, drawers, the pack-opening stage.',
  ),
];

/// `const machine`: the eight inset surfaces. Every one of these carries at
/// least one `inset` layer, which is why the cells go through
/// [Surface] rather than a plain decoration.
final List<_Specimen> _machine = <_Specimen>[
  (
    token: '--shadow-btn',
    cls: 'shadow-btn',
    spec: Shadows.control,
    // DRIFT 1, kept: only `outline` carries this class.
    use:
        'Secondary, outline and destructive buttons. An inner top highlight '
        'and inner bottom shade make the surface read as a physical key.',
  ),
  (
    token: '--shadow-btn-primary',
    cls: 'shadow-btn-primary',
    spec: Shadows.controlPrimary,
    use: 'The primary button. Same depth plus a blue cast beneath it.',
  ),
  (
    token: '--shadow-btn-value',
    cls: 'shadow-btn-value',
    spec: Shadows.controlPremium,
    use: 'The premium button. Lime cast, for money and reward actions.',
  ),
  (
    token: '--shadow-btn-down',
    cls: 'shadow-btn-down',
    spec: Shadows.controlPressed,
    use:
        'Any button while pressed. The surface sinks into its socket instead '
        'of merely dimming.',
  ),
  (
    token: '--shadow-key',
    cls: 'shadow-key',
    spec: Shadows.keyRaised,
    // DRIFT 8, kept: `press-key` exists and is never demonstrated.
    use:
        'A raised key with a visible side wall. Used by the press-key '
        'utility.',
  ),
  (
    token: '--shadow-key-down',
    cls: 'shadow-key-down',
    spec: Shadows.keyPressed,
    use: 'The same key, travelled 3px down into its socket.',
  ),
  (
    token: '--shadow-pressed',
    cls: 'shadow-pressed',
    spec: Shadows.inset,
    use: 'A sunken socket. Every input, textarea and input group sits in one.',
  ),
  (
    token: '--shadow-chip',
    cls: 'shadow-chip',
    spec: Shadows.compactControl,
    use: 'Badge and chip depth. Lighter than a button, but not flat.',
  ),
];

/* ── Page ────────────────────────────────────────────────────────────────── */

class ShadowsPage extends StatelessWidget {
  const ShadowsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // The header reads its own copy out of the nav registry, exactly as
    // `findCategory("foundations", "shadows")` does in the reference.
    final CategoryHit here = findCategory('foundations', 'shadows');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        PageHeader(
          eyebrow: here.group.title,
          title: here.category.title,
          blurb: here.category.blurb,
          contents: here.category.contents,
        ),
        // `<Note … className="mb-12">`: the only page-level Note in the
        // foundations set that carries a margin of its own. It sits between the
        // header and the first section, at page level.
        Padding(
          padding: EdgeInsets.only(bottom: space(12)),
          child: const Note(
            title: 'Two families, one idea',
            child: _PageNoteBody(),
          ),
        ),
        const _AmbientSection(),
        const _MachineSection(),
        const _InUseSection(),
        const _GlowSection(),
        const _GlassSection(),
        const Section(
          id: 'rules',
          title: 'Rules',
          child: DoDont(
            dos: <String>[
              'Use the surface ladder plus a hairline for depth first; add a '
                  'shadow only to confirm it.',
              'Give anything pressable a machine shadow, and sink it to '
                  'shadow-btn-down on active.',
              'Keep every field in a sunken shadow-pressed socket.',
              'Reserve the two glows for selection and reward.',
            ],
            // Straight apostrophes, as the source array has them: only the
            // panel heading uses the curly `&rsquo;`, and [DoDont] owns that.
            donts: <String>[
              "Don't put an ambient shadow on a control — it will read as "
                  'floating rather than pressable.',
              "Don't raise an input; recessed is what makes it read as "
                  'editable.',
              "Don't glow a resting surface, and never glow navigation.",
              "Don't invent a shadow inline — every value is a token.",
            ],
          ),
        ),
        const PageFootNav(groupId: 'foundations', slug: 'shadows'),
      ],
    );
  }
}

/// The opening Note's body: the one `<strong>` and one of the three `<em>`s on
/// the page.
///
/// There is no italic face for Inter, so the emphasis renders as a synthesised
/// oblique rather than a designed italic; and `globals.css` styles neither
/// element outside `.prose`, so both fall through to Preflight: see [_bolder].
class _PageNoteBody extends StatelessWidget {
  const _PageNoteBody();

  @override
  Widget build(BuildContext context) {
    final TextStyle base = StyledText.styleOf(context, TextStyles.small);

    return RichText(
      TextSpan(
        children: <InlineSpan>[
          const TextSpan(
            text: 'Ambient shadows describe how far a surface floats. ',
          ),
          TextSpan(text: 'Machine', style: _strong(base)),
          const TextSpan(text: ' shadows describe whether it can be '),
          const TextSpan(
            text: 'pressed',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
          const TextSpan(
            text:
                '. That second family is what gives the interface its '
                'tactility: controls you operate stand proud with an inner '
                'highlight, and fields you type into are recessed. Get the two '
                'the wrong way round and everything feels like flat cardboard.',
          ),
        ],
      ),
      TextStyles.small,
    );
  }
}

/// [base] at [_bolder].
///
/// The `wght` axis entry is replaced in place rather than a bare
/// `fontVariations` override being handed to the span, because that would drop
/// the `opsz` entry `font-optical-sizing: auto` puts there: the same reason
/// `button.dart` writes its `font-semibold` override this way.
TextStyle _strong(TextStyle base) => base.copyWith(
  fontWeight: FontWeight.bold,
  fontVariations: <FontVariation>[
    for (final FontVariation v
        in base.fontVariations ?? const <FontVariation>[])
      if (v.axis != 'wght') v,
    const FontVariation('wght', _bolder),
  ],
);

/* ── #ambient ────────────────────────────────────────────────────────────── */

class _AmbientSection extends StatelessWidget {
  const _AmbientSection();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    return Section(
      id: 'ambient',
      title: 'Ambient depth',
      description:
          'Four steps. On a near-black page a shadow reads as a soft '
          'darkening, so depth mostly comes from the surface ladder — these '
          'only confirm it.',
      // An actual U+2192 arrow, not `->`.
      child: Panel(
        label: 'e1 → e4',
        child: Grid(
          sm: 2,
          lg: 4,
          gap: space(6),
          children: <Widget>[
            for (final _Specimen specimen in _ambient)
              _SpecimenCell(
                specimen: specimen,
                radius: Radii.lg,
                // `border border-border`: the ambient cells have one and the
                // machine cells do not.
                border: Border.all(
                  color: theme.border,
                  width: BorderWidths.hairline,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/* ── #machine ────────────────────────────────────────────────────────────── */

class _MachineSection extends StatelessWidget {
  const _MachineSection();

  @override
  Widget build(BuildContext context) {
    return Section(
      id: 'machine',
      title: 'Inset surfaces',
      description:
          'Depth that implies a mechanism. These carry inset '
          'highlights and shades, so a control looks like it has a top face '
          'and a side wall.',
      child: Panel(
        label: 'The machine set',
        // Three columns at `lg`, so the last row of eight holds two.
        child: Grid(
          sm: 2,
          lg: 3,
          gap: space(6),
          children: <Widget>[
            for (final _Specimen specimen in _machine)
              // `rounded-pill bg-card` and **no border**: the two ways a
              // machine cell differs from an ambient one.
              _SpecimenCell(specimen: specimen, radius: Radii.full),
          ],
        ),
      ),
    );
  }
}

/* ── #in-use ─────────────────────────────────────────────────────────────── */

class _InUseSection extends StatelessWidget {
  const _InUseSection();

  @override
  Widget build(BuildContext context) {
    return Section(
      id: 'in-use',
      title: 'Raised against recessed',
      description:
          'The rule in one panel. Press the buttons and focus the '
          'field — the button sinks, the field is already sunken and only its '
          'ring changes.',
      child: Panel(
        label: 'Press and focus these',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // `flex flex-wrap items-center gap-4`.
            Wrap(
              spacing: space(4),
              runSpacing: space(4),
              crossAxisAlignment: WrapCrossAlignment.center,
              children: const <Widget>[
                _LiveButton(ButtonVariant.primary, 'Open Pack'),
                _LiveButton(ButtonVariant.premium, 'Deposit Funds'),
                _LiveButton(ButtonVariant.secondary, 'View Hits'),
                _LiveButton(ButtonVariant.outline, 'Filters'),
                _LiveButton(ButtonVariant.ghost, 'Skip'),
              ],
            ),
            SizedBox(height: space(6)),
            // `<div class="mt-6 max-w-sm">` around a `w-full` Input: a block
            // box that fills the panel and stops at 384px. [Align] hands the
            // cap a loose constraint, which is what makes it a *max*.
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _measureSm),
                // `label` repeats the placeholder rather than inventing copy:
                // the reference's `<input>` carries no `aria-label` either, and
                // an unlabelled field's accessible name in HTML *is* its
                // placeholder. Same string announced, one less thing invented.
                child: const Input(
                  placeholder: 'Search packs, cards and sets',
                  label: 'Search packs, cards and sets',
                ),
              ),
            ),
            SizedBox(height: space(6)),
            const _InUseCaption(),
          ],
        ),
      ),
    );
  }
}

/// One of the five real Buttons.
///
/// `onPressed` is a no-op rather than `null`: the reference renders five
/// *enabled* `<button>`s with no `onClick`, and `null` here would mean
/// `disabled:pointer-events-none disabled:opacity-45`: which would take the
/// press states the section is written about off the page.
class _LiveButton extends StatelessWidget {
  const _LiveButton(this.variant, this.label);

  final ButtonVariant variant;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Button(
      variant: variant,
      onPressed: () {},
      // A bare [Text]: the button installs its own `DefaultTextStyle`, which
      // already carries the resolved class, `btn-spring`'s animated ink and —
      // on premium: the `font-semibold` override. Re-resolving the class
      // through [StyledText] here would silently drop both.
      child: Text(label),
    );
  }
}

/// `<p class="type-small mt-6">`: five `Code` chips (drift 2 lives in what it
/// claims about them).
class _InUseCaption extends StatelessWidget {
  const _InUseCaption();

  @override
  Widget build(BuildContext context) {
    return RichText(
      TextSpan(
        children: <InlineSpan>[
          const TextSpan(text: 'Buttons carry '),
          Code.span('shadow-btn'),
          const TextSpan(text: ' or '),
          Code.span('shadow-btn-primary'),
          const TextSpan(text: ' and drop to '),
          Code.span('shadow-btn-down'),
          const TextSpan(text: ' on '),
          Code.span(':active'),
          const TextSpan(text: '. The input carries '),
          Code.span('shadow-pressed'),
          const TextSpan(
            text: ' permanently — it is a socket, and it never rises.',
          ),
        ],
      ),
      TextStyles.small,
    );
  }
}

/* ── #glow ───────────────────────────────────────────────────────────────── */

class _GlowSection extends StatelessWidget {
  const _GlowSection();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    return Section(
      id: 'glow',
      title: 'Rationed glow',
      description:
          'Two glows, and they are the scarcest thing in the system. '
          'Both derive from the accent tokens, so they follow the palette '
          'automatically.',
      child: Panel(
        label: 'Selected and celebrated',
        child: Grid(
          sm: 2,
          gap: space(6),
          children: <Widget>[
            // DRIFT 5: `border-primary/40` here, `border-action/40` on the
            // spacing page. `--primary` *is* `var(--color-action)`, so the two
            // rims are the same pixels cut from two different class names.
            _GlowCell(
              spec: Shadows.glowAction,
              rim: theme.primary,
              label: 'glow-action',
              ink: theme.actionText,
              // DRIFT 6: the spacing page says "Signals" and names different
              // occasions for the same two glows.
              lead:
                  'Selected pack, focused primary CTA, active opening stage. '
                  'Says ',
              emphasis: 'this is the thing you chose',
            ),
            _GlowCell(
              spec: Shadows.glowValue,
              rim: Palette.value,
              label: 'glow-value',
              ink: theme.premiumText,
              lead: 'Celebrated tiers, reward unlocks, premium actions. Says ',
              emphasis: 'this is worth something',
            ),
          ],
        ),
      ),
    );
  }
}

class _GlowCell extends StatelessWidget {
  const _GlowCell({
    required this.spec,
    required this.rim,
    required this.label,
    required this.ink,
    required this.lead,
    required this.emphasis,
  });

  final ShadowStyle spec;

  /// The ramp the `border-<ramp>/40` rim is cut from.
  final Color rim;

  final String label;
  final Color ink;

  /// The caption up to its `<em>`…
  final String lead;

  /// …and the clause inside it. The full stop after it is outside the emphasis.
  final String emphasis;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _SpecimenBox(
          spec: spec,
          radius: Radii.lg,
          border: Border.all(
            color: rim.withValues(alpha: _glowBorderAlpha),
            width: BorderWidths.hairline,
          ),
          child: StyledText(label, TextStyles.numberSm, color: ink),
        ),
        SizedBox(height: space(3)),
        // `.type-small` at its own 1.5 leading: the glow captions carry no
        // `leading-snug`, unlike the twelve specimen captions above.
        RichText(
          TextSpan(
            children: <InlineSpan>[
              TextSpan(text: lead),
              TextSpan(
                text: emphasis,
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
              const TextSpan(text: '.'),
            ],
          ),
          TextStyles.small,
        ),
      ],
    );
  }
}

/* ── #glass ──────────────────────────────────────────────────────────────── */

class _GlassSection extends StatelessWidget {
  const _GlassSection();

  @override
  Widget build(BuildContext context) {
    return Section(
      id: 'glass',
      title: 'Glass',
      // DRIFT 4: "Two utilities": there are three.
      description:
          'A surface in front of the page rather than cut out of it. '
          'Two utilities, one material — the split is scale, not taste.',
      child: Panel(
        // …which the label, unlike the description, narrows honestly.
        label: 'glass-panel and glass-control',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Grid(
              sm: 2,
              gap: space(6),
              children: const <Widget>[_GlassPanelCell(), _GlassControlCell()],
            ),
            SizedBox(height: space(6)),
            const Note(
              title: 'Neither needs a dark: variant',
              child: _GlassNoteBody(),
            ),
          ],
        ),
      ),
    );
  }
}

/// `glass-panel grid h-24 place-items-center rounded-4xl`: no `bg-*` and no
/// border class of its own, because the utility supplies both.
class _GlassPanelCell extends StatelessWidget {
  const _GlassPanelCell();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: _specimenHeight,
          child: Glass(
            variant: GlassVariant.panel,
            // DRIFT 9: `--radius-4xl`, the rung the spacing page's ladder does
            // not document, renders here.
            radius: BorderRadius.circular(Radii.xl4),
            // `text-foreground`, not `text-muted-foreground`: the one
            // specimen label on the page that is not muted.
            child: Center(
              child: StyledText(
                'glass-panel',
                TextStyles.numberSm,
                color: theme.foreground,
              ),
            ),
          ),
        ),
        SizedBox(height: space(3)),
        RichText(
          TextSpan(
            children: <InlineSpan>[
              const TextSpan(text: 'Card scale. Translucent '),
              Code.span('--card'),
              const TextSpan(
                text:
                    ', a backdrop blur, a hairline rim of the ink colour '
                    'and ',
              ),
              Code.span('--shadow-e2'),
              const TextSpan(
                text:
                    ' beneath. The page’s own light shows through it, which '
                    'is the whole reason to reach for this over ',
              ),
              Code.span('bg-card'),
              const TextSpan(text: '.'),
            ],
          ),
          TextStyles.small,
        ),
      ],
    );
  }
}

/// `grid h-24 place-items-center rounded-4xl bg-card` holding a
/// `glass-control inline-flex h-12 items-center rounded-pill px-4`.
///
/// The outer box is opaque `--card` and carries no shadow at all: it is a
/// backdrop for the control, not a specimen. **Drift 3** is the inner one: the
/// caption says 44px and [_glassControlHeight] is 48.
class _GlassControlCell extends StatelessWidget {
  const _GlassControlCell();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: _specimenHeight,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: theme.card,
              borderRadius: BorderRadius.circular(Radii.xl4),
            ),
            child: Center(
              child: SizedBox(
                height: _glassControlHeight,
                child: Glass(
                  variant: GlassVariant.control,
                  radius: BorderRadius.circular(Radii.full),
                  padding: EdgeInsets.symmetric(horizontal: space(4)),
                  // `inline-flex`: the box is as wide as its content plus its
                  // padding, so the width factor shrink-wraps while the
                  // 48px height stays tight.
                  child: Center(
                    widthFactor: 1,
                    child: StyledText(
                      'glass-control',
                      TextStyles.numberSm,
                      color: theme.foreground,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: space(3)),
        RichText(
          TextSpan(
            children: <InlineSpan>[
              // DRIFT 3, printed as written against a 48px render.
              const TextSpan(
                text:
                    'Control scale. No blur and no ambient shadow: at 44px '
                    'there is nothing behind it worth blurring, and ',
              ),
              Code.span('e2'),
              const TextSpan(
                text:
                    ' under something that small reads as grime rather than '
                    'as depth.',
              ),
            ],
          ),
          TextStyles.small,
        ),
      ],
    );
  }
}

/// `<Note className="mt-6" title="Neither needs a dark: variant">`: a bare
/// `dark:` with its colon, which is the class-variant prefix, not a typo.
class _GlassNoteBody extends StatelessWidget {
  const _GlassNoteBody();

  @override
  Widget build(BuildContext context) {
    return RichText(
      TextSpan(
        children: <InlineSpan>[
          const TextSpan(text: 'Both mix from '),
          Code.span('--card'),
          const TextSpan(text: ' and '),
          Code.span('--foreground'),
          const TextSpan(
            text:
                ', so a light edge on dark and a dark edge on light fall out '
                'of the same expression. The top highlight is ',
          ),
          Code.span('--rim-strong'),
          const TextSpan(
            text:
                ' — the same token every raised control carries, which is '
                'what keeps a glass card in the same world as a button.',
          ),
        ],
      ),
      TextStyles.small,
    );
  }
}

/* ── Shared ──────────────────────────────────────────────────────────────── */

/// One cell of `#ambient` or `#machine`: the specimen, the token it prints, and
/// the one-line note about what it is for.
class _SpecimenCell extends StatelessWidget {
  const _SpecimenCell({
    required this.specimen,
    required this.radius,
    this.border,
  });

  final _Specimen specimen;

  /// `rounded-lg` in `#ambient`, `rounded-pill` in `#machine`: where the pill
  /// is clamped by the shape to a 48px stadium end on a 96px-tall box.
  final double radius;

  /// `border border-border` in `#ambient`; the machine cells declare none.
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _SpecimenBox(
          spec: specimen.spec,
          radius: radius,
          border: border,
          child: StyledText(
            specimen.cls,
            TextStyles.numberSm,
            color: theme.mutedForeground,
          ),
        ),
        SizedBox(height: space(3)),
        StyledText(
          specimen.token,
          TextStyles.numberSm,
          color: theme.actionText,
        ),
        SizedBox(height: space(1)),
        _UseCopy(specimen.use),
      ],
    );
  }
}

/// `grid h-24 place-items-center … bg-card ${cls}`: the specimen itself.
///
/// Every box on this page goes through [Surface], the ambient four
/// included. Half of these tokens carry `inset` layers that a [BoxDecoration]
/// cannot paint at all, and the other half would need a second code path to say
/// the same thing: so there is one path, and the difference between the two
/// families stays what the reference says it is: the shape and the border.
class _SpecimenBox extends StatelessWidget {
  const _SpecimenBox({
    required this.spec,
    required this.radius,
    this.border,
    required this.child,
  });

  final ShadowStyle spec;
  final double radius;
  final BoxBorder? border;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _specimenHeight,
      child: Surface(
        spec: spec,
        radius: BorderRadius.circular(radius),
        fill: ThemeScope.of(context).card,
        border: border,
        // `place-items-center`.
        child: Center(child: child),
      ),
    );
  }
}

/// `type-small mt-1 leading-snug`: the one-line note under a specimen.
///
/// The only place on this page a `.type-*` class is overridden, and it is
/// overridden in exactly one property: the leading tightens so a two-line
/// caption stays a caption. The glow and glass captions below do **not** carry
/// it, and stay at `.type-small`'s own 1.5.
class _UseCopy extends StatelessWidget {
  const _UseCopy(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final TextStyle style = StyledText.styleOf(
      context,
      TextStyles.small,
    ).copyWith(height: _leadingSnug);
    // Not a `.type-*` class, so it cannot go through [StyledText]: but the line
    // box still has to be the one CSS lays out.
    return LineBox(
      style: style,
      child: Text(text, style: style),
    );
  }
}
