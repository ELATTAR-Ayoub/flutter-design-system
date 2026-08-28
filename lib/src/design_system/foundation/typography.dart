/// Typography tokens — a transcript of the reference's type layer.
///
/// Source of truth: `design-system/app/globals.css`
///   * font tokens        L169–172
///   * weights / tracking L177–188
///   * named sizes        L194–215
///   * `.type-*` classes  L1018–1292 (`@layer components`)
///
/// 1 CSS `rem` = 16px, so every `rem` below is written as its px value.
/// This file is inside `lib/src/foundation/`, the one place literals live.
library;

import 'package:flutter/painting.dart';

/// The three faces, named as they are registered in this package's pubspec.
///
/// Families follow the **tokens**, not the prose: the comment above
/// `--font-sans` (globals.css L167–168) says *"Space Grotesk owns words"*,
/// while the token it introduces is `"Inter Local"`. The token is what renders.
class Fonts {
  const Fonts._();

  /// `--font-sans: "Inter Local", …` (globals.css L169). `html` carries
  /// `font-sans`, so every class without its own `font-family` inherits this.
  static const String sans = 'InterLocal';

  /// `--font-mono: var(--font-geist-mono), …` (L170) — numerics, code, serials.
  static const String mono = 'GeistMono';

  /// `--font-heading: "Inter Local", …` (L171). A separate token that happens
  /// to resolve to the same face as [sans]; kept distinct so the port drifts
  /// with the reference rather than away from it.
  static const String heading = 'InterLocal';

  /// `--font-accent: "Redaction 35", …` (L172) — a genuine italic serif.
  static const String accent = 'Redaction35';

  /// The name of this package, threaded into every [TextStyle] this file
  /// builds.
  ///
  /// The three faces are declared in the PACKAGE pubspec, so `flutter_tools`
  /// bundles them for every dependent app under the prefixed family
  /// `packages/elattar_design_system/<Family>` (flutter_tools `asset.dart`).
  /// `TextStyle(package: …)` applies exactly that prefix, which is why
  /// [TextStyleToken.family] stays the bare family name and
  /// [TextStyleToken.resolve] passes this: call sites never think about prefixing.
  static const String package = 'elattar_design_system';
}

/// The colour a `.type-*` class sets **on itself** in globals.css.
///
/// Only five classes do (`.type-lead`, `.type-small`, `.type-label`,
/// `.type-micro`, `.type-section` — all `--muted-foreground`); every other
/// class inherits its colour from the surface it sits on, which is
/// [TextColorRole.none]. The theme resolves this to a real [Color]; this layer
/// only records which token the class named.
enum TextColorRole {
  /// No `color` declaration — inherits.
  none,

  /// `color: var(--foreground)`.
  foreground,

  /// `color: var(--muted-foreground)`.
  muted,
}

/// One `.type-*` class, recorded value for value.
///
/// Sizes are px, [height] is the CSS `line-height` **ratio** (which maps
/// straight onto [TextStyle.height]), and [tracking] is the CSS `letter-spacing`
/// in **em** — [resolve] multiplies it by the resolved font size to reach
/// Flutter's px `letterSpacing`.
class TextStyleToken {
  /// Records one class. Pass [wght] rather than [weight]: it drives both the
  /// variable-font axis and the static fallback, so the two cannot drift.
  TextStyleToken({
    required this.family,
    this.size,
    this.height,
    double? wght,
    this.tracking,
    this.uppercase = false,
    this.tabular = false,
    this.defaultColor = TextColorRole.none,
    this.fontStyle = FontStyle.normal,
  }) : weight = wght == null ? null : _staticFallback(wght),
       variations = wght == null
           ? const <FontVariation>[]
           : <FontVariation>[FontVariation(_wghtAxis, wght)];

  /// The variable-weight axis both foundation faces expose.
  static const String _wghtAxis = 'wght';

  /// The nearest static [FontWeight] at or below a `wght` axis value.
  ///
  /// `.type-h2` asks for **650** (globals.css L1081), which no [FontWeight]
  /// names; flooring to the 100-step below gives `w600`, the recorded fallback
  /// for the case where the variable axis is unavailable. Every other class
  /// lands on an exact step, so the floor is an identity there.
  static FontWeight _staticFallback(double wght) =>
      FontWeight.values[(wght ~/ 100) - 1];

  /// `font-family` — the bare family name; [resolve] adds the package prefix.
  final String family;

  /// `font-size` in px, or null when the class has no intrinsic px size:
  /// `.type-display` and `.type-h1` are `clamp()` (see [TextStyles.displaySize] /
  /// [TextStyles.h1Size]) and `.type-accent` is `em`-relative
  /// (see [TextStyles.accentSize]). The caller passes the resolved px to [resolve].
  final double? size;

  /// `line-height` as a unitless ratio, or null when the class declares none
  /// and inherits it (`.type-accent`).
  final double? height;

  /// The static weight step, derived from the declared `wght`; null when the
  /// class declares no `font-weight` and inherits it (`.type-code`,
  /// `.type-serial`).
  final FontWeight? weight;

  /// The variable-font axis settings — `wght` at the exact declared value.
  ///
  /// Carried for every class that declares a weight, not just `.type-h2`'s
  /// 650: [weight] alone is a static step, and only the axis reproduces the
  /// reference exactly on both variable faces.
  final List<FontVariation> variations;

  /// `letter-spacing` in **em**, or null when the class declares none.
  final double? tracking;

  /// `text-transform: uppercase`.
  ///
  /// A flag only — this layer performs no string transform. `StyledText` does.
  final bool uppercase;

  /// `font-variant-numeric: tabular-nums`.
  final bool tabular;

  /// The `color` the class sets on itself, if any.
  final TextColorRole defaultColor;

  /// `font-style` — italic only for `.type-accent`.
  final FontStyle fontStyle;

  /// `font-variant-numeric: tabular-nums` in Flutter's vocabulary.
  static const List<FontFeature> _tabularFigures = <FontFeature>[
    FontFeature.tabularFigures(),
  ];

  /// Builds the [TextStyle] for this class at [fontSize] px in [color].
  ///
  /// [fontSize] is always explicit — it is the resolved value for the fluid
  /// classes, and an override for the fixed ones. [tracking] is converted from
  /// em to px against it, which is what the browser does.
  TextStyle resolve(double fontSize, Color color) =>
      _style(fontSize, color, height);

  /// The same class as a CSS **inline** box.
  ///
  /// An inline non-replaced element's border box is the font's content area —
  /// its ascent plus its descent — and `line-height` governs only what the
  /// element contributes to the line box around it. A `<code>` chip in a
  /// sentence is therefore 17px of glyph plus its padding and border, not
  /// 17.5px of line box plus them. Dropping [height] is how Flutter spells
  /// "content area".
  TextStyle resolveInline(double fontSize, Color color) =>
      _style(fontSize, color, null, inherit: false);

  TextStyle _style(
    double fontSize,
    Color color,
    double? lineHeight, {
    bool inherit = true,
  }) {
    final double? em = tracking;
    return TextStyle(
      // A null `height` means "no line-height of my own", and `Text` merges an
      // ambient [DefaultTextStyle] into whatever it is given — so an inline
      // box would silently pick the surrounding paragraph's ratio back up.
      // Standing outside the cascade is the only way to say nothing at all.
      inherit: inherit,
      color: color,
      fontFamily: family,
      package: Fonts.package,
      fontSize: fontSize,
      height: lineHeight,
      // CSS splits a line's leading in half, above the glyphs and below them.
      // Flutter's default splits it in the ratio of the font's own ascent to
      // its descent instead, which drops every line about a pixel below where
      // the browser paints it. `even` **is** CSS half-leading.
      leadingDistribution: TextLeadingDistribution.even,
      fontWeight: weight,
      fontStyle: fontStyle,
      fontVariations: _variationsFor(fontSize),
      letterSpacing: em == null ? null : em * fontSize,
      fontFeatures: tabular ? _tabularFigures : null,
    );
  }

  /// Browsers apply `font-optical-sizing: auto` to any face with an `opsz`
  /// axis: the axis is set to the CSS font-size in px, clamped to the axis
  /// range. Inter Variable carries `opsz` 14–32 (assets-map §1); Geist Mono
  /// and Redaction carry none. Without this, every Inter glyph renders at the
  /// axis default (14) and text runs measure a few px off the reference —
  /// enough to move line-wrap points at 13–15px and to widen the 40px `h1`.
  List<FontVariation>? _variationsFor(double fontSize) {
    if (family != Fonts.sans) {
      return variations.isEmpty ? null : variations;
    }
    // allow-hardcoded: Inter Variable's own opsz axis range (14–32), a font
    // metric mirroring the browser's font-optical-sizing:auto, not a design
    // token.
    final double opsz = fontSize.clamp(14.0, 32.0);
    return <FontVariation>[...variations, FontVariation('opsz', opsz)];
  }
}

/// Type a component declares inline instead of reaching for a `.type-*` class.
///
/// Most of `components/ui/` does it: a control types itself out of the bare
/// Tailwind ladder — `text-sm`, `text-xs`, an optional `leading-*` and a weight
/// — and never names a `.type-*` class. Their values are still tokens
/// (`text-sm` resolves through `--text-sm`), so they are transcribed here
/// rather than typed into the components, which is also what keeps `fontSize:`
/// out of every file the token guard scans.
///
/// Three of these specs — [buttonGroupNum], [inputNum], [inputSerial] — are not
/// transcriptions of a class list but **resolutions of a cascade**: a `.type-*`
/// class in `@layer components` sitting under utilities that beat it on some
/// properties and not others. Each carries the table of who won what. A call
/// site that re-derived one would be re-deriving a bug.
///
/// ## The button ladder's type, and why it lives here
///
/// `Button`'s `cva` gives five of its nine sizes a `text-*` class
/// (`components/ui/button.tsx` L59–64) and its `emphasis="caps"` a sixth
/// (L73); the four `icon-*` rungs declare none and inherit. Five rungs, but
/// only **three distinct sizes** and **three distinct leadings**, on different
/// rungs — so a single [buttonLabel] cannot express the ladder and a component
/// cannot express it either without writing `fontSize:` outside this layer.
///
/// | rung | class | px | `line-height` |
/// |---|---|---|---|
/// | `xs` | `text-xs` → `--text-num-sm` | 12 | 16.0 |
/// | `sm` | `text-small` | 13 | *inherits* |
/// | `default` | `text-sm` → `--text-small` | 13 | 18.571 |
/// | `lg` | `text-body` | 15 | *inherits* |
/// | `xl` | `text-base` → `--text-body` | 15 | 22.5 |
/// | `caps` | `text-num-sm` | 12 | *inherits* |
///
/// The leading asymmetry is not a choice, it is a leftover. globals.css
/// L212–215 repoints Tailwind's own `--text-xs/sm/base/lg` at this scale but
/// leaves the companion `--text-*--line-height` keys at the framework's
/// **ratios**, which then apply to the new sizes: `calc(1 / 0.75) × 12`,
/// `calc(1.25 / 0.875) × 13`, `calc(1.5 / 1) × 15`. The four bespoke steps
/// (`--text-small`, `--text-body`, `--text-num-sm`) were declared here and have
/// no companion key at all, so their utilities emit `font-size` only and
/// `line-height` stays inherited. Buttons-map §3.1 verified all six against the
/// compiled stylesheet.
///
/// It is **practically inert inside a button**: the label is centred in a
/// fixed-height flex box with symmetric half-leading, so the glyphs land in the
/// same place either way. It is recorded because it is the reason `sm` and
/// `default` — both 13px — are not the same text style, and because a caller
/// that ever sizes a container to a button label's line box would see it.
class TextStyles {
  const TextStyles._();

  /// The ratios Tailwind's own `text-*` utilities carry, as globals.css leaves
  /// them.
  ///
  /// Written as the framework's own division rather than as the product,
  /// because that is what the stylesheet says: a `--text-*--line-height` key is
  /// `calc(<stock line-height> / <stock font-size>)` in rem, and the repointed
  /// size is what it multiplies. Spelling `1.4285714…` here would hide the
  /// derivation and drift the moment either half moves.
  static const double _leadingXs = 1 / 0.75;
  static const double _leadingSm = 1.25 / 0.875;
  static const double _leadingBase = 1.5 / 1;

  /// `Button` `size="default"`: `font-medium` at `text-sm`.
  ///
  /// `--text-sm: var(--text-small)` (globals.css L213), so a button label is
  /// **13px**, not Tailwind's stock 14 — the scale is redefined under the
  /// framework's own name. Its companion `--text-sm--line-height` is *not*
  /// redefined, so the utility still emits Tailwind's ratio and the label's
  /// line box is **18.5714px**.
  ///
  /// CORRECTED, and the correction is measured rather than reasoned. This spec
  /// and [sheetBody] both shipped with `height: null` under a doc comment
  /// asserting that `text-sm` leaves `line-height` at `normal`. The supervisor's
  /// probe on the live reference (`InputGroupText`) computes **13px at
  /// 18.5714px**, which is `calc(1.25 / 0.875) × 13` — the stock companion key
  /// survives the repoint, and it does so at every `text-sm` site that carries
  /// no `leading-*` override.
  ///
  /// Phases 1 and 2 never caught it because nothing they measured could: CSS
  /// centres glyphs in their line box by splitting the leading in half, and
  /// [TextStyleToken] sets [TextLeadingDistribution.even] to match, so a
  /// single-line centred label does not move when its line box grows. Only
  /// multi-line copy — [sheetBody]'s — changes spacing.
  ///
  /// Kept under the bare name [buttonLabel] rather than renamed to match its
  /// siblings: it is the cva's `defaultVariants.size`, and it is the style the
  /// rest of the port means when it says "a button label".
  static final TextStyleToken buttonLabel = TextStyleToken(
    family: Fonts.sans,
    size: 13,
    height: _leadingSm,
    wght: 500,
  );

  /// `Button` `size="xs"`: `text-xs` → `--text-num-sm` **12px**, leading 16.0.
  /// The one rung whose size is unique in the ladder.
  static final TextStyleToken buttonLabelXs = TextStyleToken(
    family: Fonts.sans,
    size: 12,
    height: _leadingXs,
    wght: 500,
  );

  /// `Button` `size="sm"`: `text-small` **13px**, no line-height of its own.
  ///
  /// The same 13px as [buttonLabel] through a different class — which is
  /// exactly why both exist: `text-small` is bespoke and carries no companion
  /// leading key, `text-sm` is aliased and inherits Tailwind's.
  ///
  /// CORRECTED, and it is [buttonLabel]'s correction one rung down. "No
  /// companion leading key" does not mean *no leading*: it means the property
  /// is **inherited**, and what it inherits is Preflight's `html { line-height:
  /// 1.5 }`, which nothing between `html` and a button overrides. So the line
  /// box is `1.5 × 13` = **19.5px**, not the face's own natural leading.
  ///
  /// It shipped as `height: null` for the same reason [buttonLabel]'s error
  /// survived two phases: a label centred in a fixed-height flex box lands in
  /// the same place either way, so nothing that had been measured could see it.
  /// `SidebarMenuButton` is the first `h-auto` button in the corpus and it can:
  /// *(measured on the live reference)* a default sidebar row computes
  /// `font-size: 13px; line-height: 19.5px` and stands **37.5px** tall
  /// (19.5 + `py-2` + a 1px border); with the face's own leading it comes out
  /// 34, and the whole page runs short.
  static final TextStyleToken buttonLabelSm = TextStyleToken(
    family: Fonts.sans,
    size: 13,
    height: _leadingInherited,
    wght: 500,
  );

  /// `Button` `size="lg"`: `text-body` **15px**, inheriting 1.5 → **22.5px**.
  ///
  /// Same correction as [buttonLabelSm], and the same measurement: the `lg`
  /// sidebar row computes `15px / 22.5px` and is 50px tall around a 32px tile.
  static final TextStyleToken buttonLabelLg = TextStyleToken(
    family: Fonts.sans,
    size: 15,
    height: _leadingInherited,
    wght: 500,
  );

  /// Preflight's `html { line-height: 1.5 }` — what a `text-*` utility with no
  /// companion `--text-*--line-height` key leaves the element inheriting.
  ///
  /// Numerically [_leadingBase], and deliberately not spelled as it: that one
  /// is Tailwind's `--text-base--line-height` key, `calc(1.5rem / 1rem)`, and
  /// the two agreeing today is a coincidence of the stock scale rather than a
  /// relationship.
  static const double _leadingInherited = 1.5;

  /// `Button` `size="xl"`: `text-base` → `--text-body` **15px**, leading 22.5.
  /// Same size as [buttonLabelLg], different leading, same reason as `sm`.
  static final TextStyleToken buttonLabelXl = TextStyleToken(
    family: Fonts.sans,
    size: 15,
    height: _leadingBase,
    wght: 500,
  );

  /// `Button` `emphasis="caps"`: `text-num-sm font-semibold tracking-cta
  /// uppercase` (`button.tsx` L73) — **12px**, 600, `--tracking-cta` 0.09em
  /// (globals.css L184), uppercase.
  ///
  /// `cva` emits variant → size → emphasis, so tailwind-merge keeps the later
  /// class in each group and this beats the rung's own `text-*` and the base
  /// `font-medium` outright — including on `size="default"`, where it drops the
  /// label from 13px to 12 (buttons-map drift 22). It is an axis, not a rung:
  /// one style for all nine sizes.
  ///
  /// [TextStyleToken.uppercase] is a flag, not a transform — the widget that
  /// renders the label performs it, the way `StyledText` does.
  static final TextStyleToken buttonLabelCaps = TextStyleToken(
    family: Fonts.sans,
    size: 12,
    wght: 600,
    tracking: 0.09,
    uppercase: true,
  );

  /// `Toggle`'s base: `text-sm font-medium` (`components/ui/toggle.tsx` L10),
  /// and `ToggleGroupItem`'s too — the item's class list is
  /// `toggleVariants(...)` plus positioning (`toggle-group.tsx` L85–96).
  ///
  /// Value-identical to [buttonLabel] and named separately because the
  /// reference declares it separately: a `Toggle` is not a `Button` and its
  /// class list can move without the button's.
  static final TextStyleToken toggleLabel = TextStyleToken(
    family: Fonts.sans,
    size: 13,
    height: _leadingSm,
    wght: 500,
  );

  /// `ButtonGroupText`'s `text-sm font-medium` (`button-group.tsx` L44).
  static final TextStyleToken buttonGroupText = TextStyleToken(
    family: Fonts.sans,
    size: 13,
    height: _leadingSm,
    wght: 500,
  );

  /// What `<ButtonGroupText className="type-num">` actually renders —
  /// buttons-map drift 16, resolved.
  ///
  /// `.type-num` lives in `@layer components` (globals.css L1275) while
  /// `text-sm` and `font-medium` are utilities, and Tailwind v4 orders
  /// `theme → base → components → utilities`; tailwind-merge does not strip
  /// `type-num`, since it is not a class it recognises. So both apply and the
  /// utilities win the two properties they share:
  ///
  /// | property | `.type-num` | utility | renders |
  /// |---|---|---|---|
  /// | font-size | `--text-body` 15 | `text-sm` 13 | **13** |
  /// | font-weight | 600 | `font-medium` 500 | **500** |
  /// | font-family | `--font-mono` | — | **Geist Mono** |
  /// | `font-variant-numeric` | tabular-nums | — | **tabular** |
  /// | letter-spacing | `--tracking-num` −0.01em | — | **−0.01em** |
  ///
  /// Transcribed as its own spec rather than left to a `.copyWith` at the call
  /// site: the cascade is the fact, and a page that re-derived it would be
  /// re-deriving a bug.
  ///
  /// Leading: `.type-num` declares `line-height: 1.2`, which no utility
  /// overrides, so the component-layer value survives where the two the
  /// utilities beat do not.
  static final TextStyleToken buttonGroupNum = TextStyleToken(
    family: Fonts.mono,
    size: 13,
    height: 1.2,
    wght: 500,
    tracking: -0.01,
    tabular: true,
  );

  /// `Kbd`'s `font-sans text-xs font-medium` (`components/ui/kbd.tsx` L7) —
  /// 12px, 500, and `text-xs`'s inherited Tailwind leading of 16.0.
  ///
  /// `font-sans` is declared even though `html` already carries it: a `<kbd>`
  /// is one of the elements Preflight resets to the monospace stack, so the
  /// class is undoing a UA default rather than restating an inherited one.
  static final TextStyleToken kbdKey = TextStyleToken(
    family: Fonts.sans,
    size: 12,
    height: _leadingXs,
    wght: 500,
  );

  // ── the menu family ─────────────────────────────────────────────────────
  // `select.tsx`, `combobox.tsx` and `command.tsx` all type their group labels
  // and their metadata column out of `text-xs` — the 12px rung that
  // `--text-xs: var(--text-num-sm)` repoints, carrying Tailwind's own
  // `--text-xs--line-height: calc(1 / .75)` and therefore a 16px line box.
  //
  // Ruling L8: these are component roles, not a new `TextStyles` rung. The port has
  // no 12px sans class at all — `TextStyles.numberSm` is mono, and the three existing
  // 12px component roles ([buttonLabelXs], [buttonLabelCaps], [kbdKey]) all
  // declare a weight the menu family does not.
  //
  // selects-map drift 6 records that the same role is written three ways
  // across the three primitives — `SelectLabel` `px-3 py-2` at weight 400,
  // `ComboboxLabel` `px-2 py-1.5` at 400, `CommandGroup`'s heading `px-3 py-2`
  // at **500**. Only the padding differs between the first two, which is box
  // geometry and belongs to the components; the type is one spec. The
  // heading's weight-500 variant is the fourth spec, [menuHeading], and it
  // landed with its consumer — see its doc.

  /// `SelectLabel`'s `px-3 py-2 text-xs text-muted-foreground`
  /// (`components/ui/select.tsx:101`) — and `ComboboxLabel`'s `text-xs` with
  /// it.
  ///
  /// **12px, weight 400** — there is no `font-*` class in either list, so it
  /// inherits `html`'s 400, which is what separates this from [kbdKey] and
  /// [buttonLabelXs] at the same size. `text-xs`'s companion leading key
  /// survives the repoint exactly as `text-sm`'s does ([buttonLabel] carries
  /// that measurement), so the line box is `calc(1 / .75) × 12` = **16px** and
  /// a label row with `py-2` is **32px** tall — the step the item-aligned
  /// placement counts in beside a 34.571px item.
  ///
  /// The colour is not recorded here: `text-muted-foreground` is a utility on
  /// the element, not a declaration the class makes about itself, and the
  /// widget passes it — the same division [InputGroupText] follows.
  static final TextStyleToken menuLabel = TextStyleToken(
    family: Fonts.sans,
    size: 12,
    height: _leadingXs,
    wght: 400,
  );

  /// `CommandGroup`'s heading — [menuLabel] at **weight 500**.
  ///
  /// The class arrives through an arbitrary-variant on the group rather than on
  /// the heading itself: `**:[[cmdk-group-heading]]:text-xs
  /// **:[[cmdk-group-heading]]:font-medium` (`components/ui/command.tsx:129`),
  /// which is why nothing in the heading's own markup says 12px or 500.
  ///
  /// Ruling L8 made this spec conditional on a probe, because the class list
  /// alone cannot say whether `font-medium` survives the cascade. It does:
  /// *(measured)* the live palette's heading computes
  /// **`font-size: 12px`, `line-height: 16px`, `font-weight: 500`** at
  /// `font-variation-settings: normal` — a static face selection, not an axis
  /// tweak, which is why [TextStyleToken] carrying `wght: 500` reproduces it on
  /// both the variable and the fallback face.
  ///
  /// One weight step is the whole difference from [menuLabel], and that step is
  /// selects-map drift 6: three group labels, three sets of numbers, one role.
  static final TextStyleToken menuHeading = TextStyleToken(
    family: Fonts.sans,
    size: 12,
    height: _leadingXs,
    wght: 500,
  );

  /// `CommandShortcut`'s `ml-auto text-xs tracking-widest text-muted-foreground`
  /// (`components/ui/command.tsx:178`) — [menuLabel] plus `--tracking-widest`.
  ///
  /// **0.1em** *(measured, the production stylesheet at byte 3532:
  /// `--tracking-widest: .1em`)*, which is the widest tracking anywhere in the
  /// system and the only positive one outside `--tracking-cta`.
  ///
  /// It is **sans**, not mono, and that is selects-map drift 4: the palette
  /// renders `$48.00` and `$120.00` through this class while the same page's
  /// own Do 5 says *"render dates and prices with the named numerical
  /// typography foundation"*. Reproduce it as written.
  ///
  /// Declared this wave although its consumer arrives with `command.dart`:
  /// this file has one writer per wave, and a shortcut column typed by hand at
  /// the call site would put `fontSize:` in a component the guard scans.
  static final TextStyleToken menuShortcut = TextStyleToken(
    family: Fonts.sans,
    size: 12,
    height: _leadingXs,
    wght: 400,
    tracking: 0.1,
  );

  // ── the navigation family ───────────────────────────────────────────────

  /// `--leading-relaxed`'s sibling: the ratio Tailwind v4 pairs with a
  /// `--text-*` entry that declares **no** `--text-*--line-height` of its own.
  ///
  /// `--text-nav` is such an entry (globals.css L201 declares the size and
  /// nothing else), so `text-nav` emits `line-height: 1.5` from the framework
  /// rather than the 1.2 the `.type-nav` *component class* sets one layer down.
  static const double _leadingNavUtility = 1.5;

  /// `navigationMenuTriggerStyle()`'s `text-nav font-medium`
  /// (`components/ui/navigation-menu.tsx` L107) — 13.5px / 500 / **1.5**.
  ///
  /// **Not [TextStyles.nav], and the difference is measurable.** `.type-nav`
  /// (globals.css L1128) sets `--text-nav` *and* `line-height: 1.2`; the
  /// `text-nav` **utility** sets only the size, and Tailwind supplies its own
  /// 1.5 because globals.css declares no `--text-nav--line-height`. Probed on
  /// the live reference at 1440 × 900 (2026-08-16): the navigation-menu trigger
  /// and its `Leaderboard` link both report `13.5px/20.25px 500`, while the
  /// top-nav buttons two sections above them — which wear the `.type-nav`
  /// *class* — report `13.5px/16.2px 500`. Two spellings of one token, four
  /// pixels of leading apart, on the same page.
  ///
  /// It reaches the same three sites the utility does: the trigger, the plain
  /// link that borrows `navigationMenuTriggerStyle()`, and the `type-nav` title
  /// span inside a panel link — no: that last one is the *class* and stays on
  /// [TextStyles.nav]. Two sites.
  static final TextStyleToken navMenuTrigger = TextStyleToken(
    family: Fonts.sans,
    size: 13.5,
    height: _leadingNavUtility,
    wght: 500,
  );

  /// `SheetContent`'s `text-sm`, with no `font-weight` of its own — so it
  /// inherits `html`'s 400.
  ///
  /// Its `line-height` is `text-sm`'s surviving Tailwind ratio, the same one
  /// [buttonLabel] carries and corrected on the same measurement — see that
  /// spec's doc. This is the one site where the correction is **visible**:
  /// `SheetContent` sets the mobile nav sheet's ambient text style, and a
  /// paragraph's line spacing does change when its line box goes from `normal`
  /// to 18.5714px. `Input`, the other consumer, does not move — a single line
  /// centred in a fixed 40px pill lands where it always did.
  static final TextStyleToken bodyCompact = TextStyleToken(
    family: Fonts.sans,
    size: 13,
    height: _leadingSm,
    wght: 400,
  );

  // ── the overlay family ──────────────────────────────────────────────────
  // `dialog.tsx`, `alert-dialog.tsx`, `sheet.tsx`, `drawer.tsx`, `popover.tsx`
  // and `tooltip.tsx` type their headings off the bare Tailwind ladder too —
  // `font-heading text-base font-medium`, with `leading-none` on exactly one
  // of them. Every number below is a computed style read off the live
  // reference at 1440x900 on 2026-08-16 with the overlay open.

  /// `--text-base: var(--text-body)` (globals.css L214), so an overlay heading
  /// is **15px**, not Tailwind's stock 16. Its companion `--text-base--line-
  /// height` is not redeclared, so the utility still emits the stock ratio.
  static const double _textBase = 15;

  /// `DialogTitle`'s `font-heading text-base leading-none font-medium`.
  ///
  /// The one overlay heading that overrides its leading, and the override is
  /// visible: `leading-none` collapses the line box onto the font size, so the
  /// measured title is **15px in a 15px box** where its four siblings sit in
  /// 22.5. That is what lets the dialog's header band close at 93px with an
  /// 8px gap under the title rather than a 15px optical one.
  static final TextStyleToken dialogTitle = TextStyleToken(
    family: Fonts.heading,
    size: _textBase,
    height: 1,
    wght: 500,
  );

  /// `font-heading text-base font-medium` with no leading override —
  /// `AlertDialogTitle`, `SheetTitle` and `DrawerTitle`, all three measured at
  /// 15px / 22.5px.
  ///
  /// The alert dialog is where the difference reads: its title is the
  /// question, it wraps to two lines on the narrow content, and `leading-none`
  /// would set those two lines solid.
  static final TextStyleToken overlayTitle = TextStyleToken(
    family: Fonts.heading,
    size: _textBase,
    height: _leadingBase,
    wght: 500,
  );

  /// `PopoverTitle`'s bare `font-medium` — no size and no family of its own,
  /// so it takes `PopoverContent`'s `text-sm`: 13px / 500 / 1.428571.
  ///
  /// Sans, not [Fonts.heading]: `popover.tsx` writes no `font-heading`, and
  /// a popover header is a label on a panel rather than a heading over a task.
  static final TextStyleToken popoverTitle = TextStyleToken(
    family: Fonts.sans,
    size: 13,
    height: _leadingSm,
    wght: 500,
  );

  /// `TooltipContent`'s `text-xs` — 12px / 400 / 1.333333, inheriting `html`'s
  /// weight. A tooltip is a label, and the class list gives it no weight of
  /// its own.
  static final TextStyleToken tooltipLabel = TextStyleToken(
    family: Fonts.sans,
    size: 12,
    height: _leadingXs,
    wght: 400,
  );

  /// `Badge`'s `text-xs font-medium` — 12px / 500 / 1.333333.
  ///
  /// **Not `.type-badge`.** That class (11px, 600, uppercase, 0.14em) is a
  /// different object with an unfortunately similar name; `badge.tsx` never
  /// reaches for it, and the measured chip on the media dialog is 12px at 500
  /// with no transform. [TextStyles.badge] stays where it is for the callers that
  /// do want the class.
  static final TextStyleToken badgeLabel = TextStyleToken(
    family: Fonts.sans,
    size: 12,
    height: _leadingXs,
    wght: 500,
  );

  // ── the sidebar family ──────────────────────────────────────────────────
  // Two roles, and both are the same collision: a `.type-num-*` **component**
  // class written onto an element whose own **utility** classes already state
  // a size and a weight. `cn()` keeps both — tailwind-merge has no group for a
  // `.type-*` class — and the utility layer is emitted after the component
  // layer, so the utility wins every property it names. What survives from the
  // `.type-num-*` side is only what the utilities are silent about: the mono
  // family, `tabular-nums`, and `--tracking-num` −0.01em.
  //
  // Neither is a new class in globals.css and neither is a design decision;
  // both are the *resolved* style, measured on the live page (1440 × 900,
  // 2026-08-16), and they are recorded here because a `.type-*` spec passed
  // straight through would render the wrong size on both.

  /// `SidebarMenuBadge`'s `.type-num-xs` over `Badge`'s own `text-xs
  /// font-medium` — **12px / 500 / 1.333333, mono, tabular, −0.01em**.
  ///
  /// [TextStyles.numberXs] is 11px at 600; `text-xs` (→ `--text-num-sm`, 12px) and
  /// `font-medium` both outrank it. *(Measured: `font-size: 12px`,
  /// `font-weight: 500`, `line-height: 16px`, `letter-spacing: -0.12px`,
  /// `font-variant-numeric: tabular-nums`, family `GeistMono`.)*
  static final TextStyleToken sidebarMenuBadge = TextStyleToken(
    family: Fonts.mono,
    size: 12,
    height: _leadingXs,
    wght: 500,
    tracking: -0.01,
    tabular: true,
  );

  /// `NavUser`'s `<AvatarFallback className="type-num-sm">` over
  /// `AvatarFallback`'s own `text-sm` — **13px / 600 / 1.428571, mono,
  /// tabular, −0.01em**.
  ///
  /// The mirror image of [sidebarMenuBadge]: here the class list carries a
  /// size but **no** weight, so `.type-num-sm`'s 600 survives and its 12px
  /// does not. *(Measured: 13px / 600 / 18.5714px / −0.13px / tabular /
  /// `GeistMono`.)*
  static final TextStyleToken avatarFallback = TextStyleToken(
    family: Fonts.mono,
    size: 13,
    height: _leadingSm,
    wght: 600,
    tracking: -0.01,
    tabular: true,
  );

  // ── the field family ────────────────────────────────────────────────────
  // `field.tsx`, `textarea.tsx` and `input-otp.tsx` type themselves out of the
  // bare Tailwind ladder — `text-sm` with an optional `leading-*` override —
  // and never reach for a `.type-*` class. Five resolved styles, all 13px.
  //
  // `--leading-*` is never redeclared in globals.css, so Tailwind's stock
  // ratios stand. They are unitless multipliers of the element's own font size,
  // which is what [TextStyleToken.height] is.

  /// `--leading-snug: 1.375` — Tailwind stock, undeclared in globals.css.
  static const double _leadingSnug = 1.375;

  /// `--leading-relaxed: 1.625` — Tailwind stock, undeclared in globals.css.
  static const double _leadingRelaxed = 1.625;

  /// A bare `text-sm` with no weight and no leading override — 13px / 400 /
  /// 1.428571.
  ///
  /// The rung `FieldError` and the OTP slots sit on. Same size and leading as
  /// [buttonLabel] at `html`'s inherited 400 instead of `font-medium`'s 500,
  /// which is the only thing that separates the two.
  static final TextStyleToken bodySmall = TextStyleToken(
    family: Fonts.sans,
    size: 13,
    height: _leadingSm,
    wght: 400,
  );

  /// `FieldLabel`'s `text-sm leading-snug font-medium` — 13px / 500 / 1.375.
  ///
  /// The one place in the family that tightens the leading: a label is a short
  /// run above a control, and `text-sm`'s own 1.428571 would push it away from
  /// the field it names.
  static final TextStyleToken fieldLabel = TextStyleToken(
    family: Fonts.sans,
    size: 13,
    height: _leadingSnug,
    wght: 500,
  );

  /// `Textarea`'s `text-sm leading-relaxed` — 13px / 400 / 1.625, i.e. a
  /// 21.125px line box.
  ///
  /// The opposite override to [fieldLabel] and for the opposite reason: a
  /// textarea is the one control on the page that holds real paragraphs, and
  /// paragraphs need air between the lines.
  static final TextStyleToken textareaBody = TextStyleToken(
    family: Fonts.sans,
    size: 13,
    height: _leadingRelaxed,
    wght: 400,
  );

  /// `.type-num` under a `text-sm` utility — ruling I7's collapse, resolved.
  ///
  /// Same cascade as [buttonGroupNum]: `.type-num` is `@layer components` and
  /// `text-sm` is a utility, so the utility wins the one property they share
  /// and **the size drops from 15px to 13**. Everything the utility does not
  /// declare survives — Geist Mono, `font-variant-numeric: tabular-nums`,
  /// `--tracking-num` −0.01em and, unlike [buttonGroupNum], the **weight**:
  /// there is no `font-medium` in this class list to beat `.type-num`'s 600.
  ///
  /// The leading is `text-sm`'s 1.428571 rather than `.type-num`'s 1.2, because
  /// here the utility carries a companion `--text-sm--line-height` and a
  /// utility beats a component layer on every property it declares.
  static final TextStyleToken inputNumber = TextStyleToken(
    family: Fonts.mono,
    size: 13,
    height: _leadingSm,
    wght: 600,
    tracking: -0.01,
    tabular: true,
  );

  /// `.type-serial` under a `text-sm` utility — the same I7 collapse.
  ///
  /// `.type-serial` declares **no `font-weight` at all** (globals.css L1211),
  /// so the 400 recorded here is not the class's, it is `html`'s, inherited
  /// through it. Mono, uppercase and −0.01em survive; the size drops 15 → 13.
  static final TextStyleToken inputSerial = TextStyleToken(
    family: Fonts.mono,
    size: 13,
    height: _leadingSm,
    wght: 400,
    tracking: -0.01,
    uppercase: true,
  );

  // ── the chat family ─────────────────────────────────────────────────────
  // `message.tsx`, `bubble.tsx` and `attachment.tsx` type off the bare
  // Tailwind ladder. Every number below is a computed style read off
  // `/design-system/components/base/chat` at 1440×900 on 2026-08-16.

  /// `leading-tight` — 1.25, on `AttachmentContent`.
  static const double _leadingTight = 1.25;

  /// `BubbleContent`'s `text-sm leading-relaxed` — **13px / 21.125px / 400**.
  ///
  /// `--text-sm: var(--text-small)` puts it at 13, and `leading-relaxed`
  /// replaces `text-sm`'s own companion ratio outright, so this is the one
  /// 13px site in the port whose line box is 21.125 rather than 18.5714. It is
  /// what makes every single-line bubble on the page **39.13px** tall:
  /// 21.125 + `py-2` twice + the 1px transparent border twice.
  static final TextStyleToken bubbleContent = TextStyleToken(
    family: Fonts.sans,
    size: 13,
    height: _leadingRelaxed,
    wght: 400,
  );

  /// `MessageHeader` / `MessageFooter` — `text-xs font-medium`, **12px / 16px
  /// / 500**.
  ///
  /// Value-identical to [TextStyles.badge] and declared separately for the same
  /// reason [toggleLabel] is: the reference declares it separately, and a
  /// message's byline is free to move without a badge's.
  static final TextStyleToken messageMetadata = TextStyleToken(
    family: Fonts.sans,
    size: 12,
    height: _leadingXs,
    wght: 500,
  );

  /// `BubbleReactions`' own `text-sm` — 13px / 18.5714px / 400, inherited by
  /// the bare rail's emoji spans and by every reaction pill.
  static final TextStyleToken bubbleReactions = TextStyleToken(
    family: Fonts.sans,
    size: 13,
    height: _leadingSm,
    wght: 400,
  );

  /// `AttachmentTitle`'s `font-medium` under `Attachment size="default"`'s
  /// `text-sm` and `AttachmentContent`'s `leading-tight` — **13px / 16.25px /
  /// 500**.
  static final TextStyleToken attachmentTitle = TextStyleToken(
    family: Fonts.sans,
    size: 13,
    height: _leadingTight,
    wght: 500,
  );

  /// The same title under `size="sm"` / `size="xs"`, whose root is `text-xs` —
  /// **12px / 15px / 500**.
  static final TextStyleToken attachmentTitleSmall = TextStyleToken(
    family: Fonts.sans,
    size: 12,
    height: _leadingTight,
    wght: 500,
  );

  /// `AttachmentDescription`'s `text-xs` — 12px / 16px / 400, on every size,
  /// because the description states its own size and the root's does not reach
  /// it.
  static final TextStyleToken attachmentDescription = TextStyleToken(
    family: Fonts.sans,
    size: 12,
    height: _leadingXs,
    wght: 400,
  );

  // ── the data-display family ─────────────────────────────────────────────
  // `table.tsx`, `card.tsx`, `item.tsx` and `avatar.tsx` type off the bare
  // Tailwind ladder as well. Every number below is a computed style read off
  // `/design-system/components/base/data` at 1440×900 on 2026-08-16.

  /// `--leading-normal: 1.5` — Tailwind stock, undeclared in globals.css.
  ///
  /// Numerically [_leadingNavUtility] and a different fact: that one is the
  /// ratio the framework *supplies* when a `--text-*` entry declares no
  /// companion; this one is an author writing `leading-normal` by hand.
  static const double _leadingNormal = 1.5;

  /// `TableHead`'s `font-medium` under the table's own `text-sm` —
  /// **13px / 18.5714px / 500**.
  ///
  /// The size is inherited: `<table className="… text-sm">` sets it once and
  /// every `th` and `td` under it takes the resolved 13px *and* the resolved
  /// 18.5714px line box, because an inherited `line-height` inherits as the
  /// computed pixel value rather than as the ratio.
  static final TextStyleToken tableHead = TextStyleToken(
    family: Fonts.sans,
    size: 13,
    height: _leadingSm,
    wght: 500,
  );

  /// `CardTitle`'s `font-heading text-base leading-snug font-medium` —
  /// **15px / 20.625px / 500**.
  ///
  /// The overlay family's [overlayTitle] is the same size and weight in the
  /// same face at `text-base`'s own 1.5; a card title tightens to
  /// `leading-snug`, so it sits 1.875px shorter and closer to the description
  /// under it.
  static final TextStyleToken cardTitle = TextStyleToken(
    family: Fonts.heading,
    size: _textBase,
    height: _leadingSnug,
    wght: 500,
  );

  /// `ItemTitle`'s `text-sm leading-snug font-medium` — 13px / 17.875px / 500.
  ///
  /// Numerically [fieldLabel], and named separately because it is a different
  /// component's declaration: `item.tsx` writes the three utilities itself and
  /// has no `field.tsx` in its cascade.
  static final TextStyleToken itemTitle = TextStyleToken(
    family: Fonts.sans,
    size: 13,
    height: _leadingSnug,
    wght: 500,
  );

  /// `ItemDescription`'s `text-sm leading-normal font-normal` —
  /// **13px / 19.5px / 400**.
  ///
  /// `--leading-normal: 1.5` — Tailwind stock, undeclared in globals.css, and
  /// the same ratio [navMenuTrigger] takes from the framework for the opposite
  /// reason (there it is a *missing* companion key; here it is an explicit
  /// utility). A row's description is the one string in an `Item` that is
  /// allowed to wrap, and 1.5 is what separates the two lines.
  static final TextStyleToken itemDescription = TextStyleToken(
    family: Fonts.sans,
    size: 13,
    height: _leadingNormal,
    wght: 400,
  );

  /// `AvatarFallback` under the page's `.type-caption` — **13px / 18.5714px /
  /// 500**.
  ///
  /// Ruling I7's collapse again, on a class the fallback's own list beats:
  /// `AvatarFallback` carries `text-sm`, a *utility*, and `.type-caption` is
  /// `@layer components`, so the utility wins both properties they share —
  /// the class's 10.5px size and its 1.35 leading are both discarded. What
  /// survives is the one thing `text-sm` does not declare: **the 500 weight**.
  /// *(Measured on the 24px avatar: 13px/18.5714px/500, where the class alone
  /// would render 10.5/14.175.)*
  static final TextStyleToken avatarInitials = TextStyleToken(
    family: Fonts.sans,
    size: 13,
    height: _leadingSm,
    wght: 500,
  );

  // The data page's other five fallbacks wear `.type-num-sm` over the same
  // `text-sm`, which is [avatarFallback] — already recorded above for
  // `NavUser`, measured on a different page, and byte-identical. One spelling.
  // Every `.type-*` class in globals.css follows in the same namespace.

  // ── Fluid sizes ──────────────────────────────────────────────────────────

  /// `.type-display` — `font-size: clamp(2.75rem, 4.4vw, 4rem)` (L1021),
  /// i.e. clamp(44px, 4.4% of the viewport width, 64px).
  static double displaySize(double vw) => (vw * 4.4 / 100).clamp(44, 64);

  /// `.type-h1` — `font-size: clamp(2rem, 2.8vw, 2.5rem)` (L1072),
  /// i.e. clamp(32px, 2.8% of the viewport width, 40px).
  static double h1Size(double vw) => (vw * 2.8 / 100).clamp(32, 40);

  /// `.type-accent` — `font-size: 1.055em` (L1048): 1.055× the size it is set
  /// inside, so one display word in the accent face rides `.type-display`'s
  /// clamp for free.
  static double accentSize(double inheritedSize) => inheritedSize * 1.055;

  // ── Words ────────────────────────────────────────────────────────────────

  /// `.type-display` — heading face, clamp 44–64/1, 500,
  /// `--tracking-display` −0.03em (globals.css L1019).
  static final TextStyleToken display = TextStyleToken(
    family: Fonts.heading,
    height: 1,
    wght: 500,
    tracking: -0.03,
  );

  /// `.type-h1` — clamp 32–40/1.1, 700, `--tracking-tight` −0.02em (L1070).
  static final TextStyleToken h1 = TextStyleToken(
    family: Fonts.sans,
    height: 1.1,
    wght: 700,
    tracking: -0.02,
  );

  /// `.type-h2` — 28px (1.75rem)/1.2, **650**, −0.015em (L1077).
  static final TextStyleToken h2 = TextStyleToken(
    family: Fonts.sans,
    size: 28,
    height: 1.2,
    wght: 650,
    tracking: -0.015,
  );

  /// `.type-h3` — 21px (1.3125rem)/1.3, 600, −0.01em (L1084).
  static final TextStyleToken h3 = TextStyleToken(
    family: Fonts.sans,
    size: 21,
    height: 1.3,
    wght: 600,
    tracking: -0.01,
  );

  /// `.type-h4` — 17px (1.0625rem)/1.4, 600, no tracking (L1091).
  static final TextStyleToken h4 = TextStyleToken(
    family: Fonts.sans,
    size: 17,
    height: 1.4,
    wght: 600,
  );

  /// `.type-lead` — 17px (1.0625rem)/1.65, 400, muted-foreground (L1099).
  static final TextStyleToken lead = TextStyleToken(
    family: Fonts.sans,
    size: 17,
    height: 1.65,
    wght: 400,
    defaultColor: TextColorRole.muted,
  );

  /// `.type-body` — `--text-body` 15px/1.6, 400 (L1105).
  static final TextStyleToken body = TextStyleToken(
    family: Fonts.sans,
    size: 15,
    height: 1.6,
    wght: 400,
  );

  /// `.type-small` — `--text-small` 13px/1.5, 400, muted-foreground (L1120).
  static final TextStyleToken small = TextStyleToken(
    family: Fonts.sans,
    size: 13,
    height: 1.5,
    wght: 400,
    defaultColor: TextColorRole.muted,
  );

  /// `.type-nav` — `--text-nav` 13.5px/1.2, 500 (L1128).
  static final TextStyleToken nav = TextStyleToken(
    family: Fonts.sans,
    size: 13.5,
    height: 1.2,
    wght: 500,
  );

  /// `.type-nav-sm` — `--text-chip` 11.5px/1.2, 500 (L1139).
  /// The dense step of [nav]; sentence case is the whole point of the class.
  static final TextStyleToken navSm = TextStyleToken(
    family: Fonts.sans,
    size: 11.5,
    height: 1.2,
    wght: 500,
  );

  /// `.type-chip` — `--text-chip` 11.5px/1.2, 500 (L1145).
  static final TextStyleToken chip = TextStyleToken(
    family: Fonts.sans,
    size: 11.5,
    height: 1.2,
    wght: 500,
  );

  /// `.type-caption` — `--text-micro` 10.5px/1.35, 500 (L1151).
  static final TextStyleToken caption = TextStyleToken(
    family: Fonts.sans,
    size: 10.5,
    height: 1.35,
    wght: 500,
  );

  /// `.type-code` — mono, `--text-code` 12.5px/1.4, **no font-weight
  /// declaration** — it inherits (L1157).
  static final TextStyleToken code = TextStyleToken(
    family: Fonts.mono,
    size: 12.5,
    height: 1.4,
  );

  /// `.type-label` — `--text-label` 11px/1, 600, uppercase,
  /// `--tracking-label` 0.16em, muted-foreground (L1164).
  static final TextStyleToken eyebrow = TextStyleToken(
    family: Fonts.sans,
    size: 11,
    height: 1,
    wght: 600,
    tracking: 0.16,
    uppercase: true,
    defaultColor: TextColorRole.muted,
  );

  /// `.type-section` — `--text-small` 13px/1.4, 600, muted-foreground (L1192).
  /// The label's quiet twin: a group heading in sentence case.
  static final TextStyleToken section = TextStyleToken(
    family: Fonts.sans,
    size: 13,
    height: 1.4,
    wght: 600,
    defaultColor: TextColorRole.muted,
  );

  /// `.type-wordmark` — `--text-body` 15px/1, 700,
  /// `--tracking-num` −0.01em (L1201).
  static final TextStyleToken wordmark = TextStyleToken(
    family: Fonts.sans,
    size: 15,
    height: 1,
    wght: 700,
    tracking: -0.01,
  );

  /// `.type-serial` — mono, `--text-body` 15px/1.4, uppercase,
  /// `--tracking-num` −0.01em, **no font-weight declaration** — it inherits
  /// (L1211).
  static final TextStyleToken identifier = TextStyleToken(
    family: Fonts.mono,
    size: 15,
    height: 1.4,
    tracking: -0.01,
    uppercase: true,
  );

  /// `.type-micro` — `--text-micro` 10.5px/1, 600, uppercase,
  /// `--tracking-micro` 0.18em, muted-foreground (L1218).
  static final TextStyleToken eyebrowSmall = TextStyleToken(
    family: Fonts.sans,
    size: 10.5,
    height: 1,
    wght: 600,
    tracking: 0.18,
    uppercase: true,
    defaultColor: TextColorRole.muted,
  );

  /// `.type-tag` — `--text-tag` 10px/1, 600, uppercase,
  /// `--tracking-tag` 0.12em (L1238). The smallest step.
  static final TextStyleToken tag = TextStyleToken(
    family: Fonts.sans,
    size: 10,
    height: 1,
    wght: 600,
    tracking: 0.12,
    uppercase: true,
  );

  /// `.type-badge` — `--text-label` 11px/1, 600, uppercase,
  /// `--tracking-badge` 0.14em (L1246).
  static final TextStyleToken badge = TextStyleToken(
    family: Fonts.sans,
    size: 11,
    height: 1,
    wght: 600,
    tracking: 0.14,
    uppercase: true,
  );

  /// `.type-accent` — Redaction 35, 1.055em, italic, 400,
  /// `--tracking-display` −0.03em, **no line-height declaration** — it
  /// inherits (L1046).
  static final TextStyleToken accent = TextStyleToken(
    family: Fonts.accent,
    wght: 400,
    tracking: -0.03,
    fontStyle: FontStyle.italic,
  );

  // ── Numerics ─────────────────────────────────────────────────────────────
  // The shared rule (L1256–1266) gives all six: mono, tabular-nums, 600,
  // `--tracking-num` −0.01em. Each step then sets only size and line-height —
  // except `.type-num-xl`, which overrides the tracking.

  /// `.type-num-xs` — mono, `--text-label` 11px/1.2, 600, tabular,
  /// −0.01em (L1267).
  static final TextStyleToken numberXs = TextStyleToken(
    family: Fonts.mono,
    size: 11,
    height: 1.2,
    wght: 600,
    tracking: -0.01,
    tabular: true,
  );

  /// `.type-num-sm` — mono, `--text-num-sm` 12px/1.2, 600, tabular,
  /// −0.01em (L1271).
  static final TextStyleToken numberSm = TextStyleToken(
    family: Fonts.mono,
    size: 12,
    height: 1.2,
    wght: 600,
    tracking: -0.01,
    tabular: true,
  );

  /// `.type-num` — mono, `--text-body` 15px/1.2, 600, tabular, −0.01em
  /// (L1275). Named `numBase` because Dart reserves `num`.
  static final TextStyleToken numberBase = TextStyleToken(
    family: Fonts.mono,
    size: 15,
    height: 1.2,
    wght: 600,
    tracking: -0.01,
    tabular: true,
  );

  /// `.type-num-md` — mono, 20px (1.25rem)/1.15, 600, tabular,
  /// −0.01em (L1279).
  static final TextStyleToken numberMd = TextStyleToken(
    family: Fonts.mono,
    size: 20,
    height: 1.15,
    wght: 600,
    tracking: -0.01,
    tabular: true,
  );

  /// `.type-num-lg` — mono, 28px (1.75rem)/1.05, 600, tabular,
  /// −0.01em (L1283).
  static final TextStyleToken numberLg = TextStyleToken(
    family: Fonts.mono,
    size: 28,
    height: 1.05,
    wght: 600,
    tracking: -0.01,
    tabular: true,
  );

  /// `.type-num-xl` — mono, 40px (2.5rem)/1, 600, tabular, and the one
  /// numeric that leaves `--tracking-num`: −0.025em (L1287).
  static final TextStyleToken numberXl = TextStyleToken(
    family: Fonts.mono,
    size: 40,
    height: 1,
    wght: 600,
    tracking: -0.025,
    tabular: true,
  );

  /// All 27 classes, in the order globals.css declares them (L1019–1292).
  static final List<TextStyleToken> all = <TextStyleToken>[
    display,
    accent,
    h1,
    h2,
    h3,
    h4,
    lead,
    body,
    small,
    nav,
    navSm,
    chip,
    caption,
    code,
    eyebrow,
    section,
    wordmark,
    identifier,
    eyebrowSmall,
    tag,
    badge,
    numberXs,
    numberSm,
    numberBase,
    numberMd,
    numberLg,
    numberXl,
  ];
}
