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
class DsFonts {
  const DsFonts._();

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
  /// [DsTypeSpec.family] stays the bare family name and
  /// [DsTypeSpec.resolve] passes this: call sites never think about prefixing.
  static const String package = 'elattar_design_system';
}

/// The colour a `.type-*` class sets **on itself** in globals.css.
///
/// Only five classes do (`.type-lead`, `.type-small`, `.type-label`,
/// `.type-micro`, `.type-section` — all `--muted-foreground`); every other
/// class inherits its colour from the surface it sits on, which is
/// [DsTypeColor.none]. The theme resolves this to a real [Color]; this layer
/// only records which token the class named.
enum DsTypeColor {
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
class DsTypeSpec {
  /// Records one class. Pass [wght] rather than [weight]: it drives both the
  /// variable-font axis and the static fallback, so the two cannot drift.
  DsTypeSpec({
    required this.family,
    this.size,
    this.height,
    double? wght,
    this.tracking,
    this.uppercase = false,
    this.tabular = false,
    this.defaultColor = DsTypeColor.none,
    this.fontStyle = FontStyle.normal,
  })  : weight = wght == null ? null : _staticFallback(wght),
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
  /// `.type-display` and `.type-h1` are `clamp()` (see [DsType.displaySize] /
  /// [DsType.h1Size]) and `.type-accent` is `em`-relative
  /// (see [DsType.accentSize]). The caller passes the resolved px to [resolve].
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
  /// A flag only — this layer performs no string transform. `DsText` does.
  final bool uppercase;

  /// `font-variant-numeric: tabular-nums`.
  final bool tabular;

  /// The `color` the class sets on itself, if any.
  final DsTypeColor defaultColor;

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
      package: DsFonts.package,
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
    if (family != DsFonts.sans) {
      return variations.isEmpty ? null : variations;
    }
    // allow-hardcoded: Inter Variable's own opsz axis range (14–32), a font
    // metric mirroring the browser's font-optical-sizing:auto, not a design
    // token.
    final double opsz = fontSize.clamp(14.0, 32.0);
    return <FontVariation>[
      ...variations,
      FontVariation('opsz', opsz),
    ];
  }
}

/// Type a component declares inline instead of reaching for a `.type-*` class.
///
/// Two surfaces in this phase do it, both in `components/ui/`. Their values
/// are still tokens — `text-sm` resolves through `--text-sm` — so they are
/// transcribed here rather than typed into the components.
class DsComponentType {
  const DsComponentType._();

  /// `Button`'s base: `font-medium` at size `text-sm`.
  ///
  /// `--text-sm: var(--text-small)` (globals.css L213), so a button label is
  /// **13px**, not Tailwind's stock 14 — the scale is redefined under the
  /// framework's own name.
  ///
  /// No `--text-sm--line-height` companion token is declared, so Tailwind's
  /// `text-sm` utility leaves `line-height` at `normal`; [DsTypeSpec.height]
  /// is therefore null, which is Flutter's spelling of the same thing.
  static final DsTypeSpec buttonLabel = DsTypeSpec(
    family: DsFonts.sans,
    size: 13,
    wght: 500,
  );

  /// `SheetContent`'s `text-sm`, with no `font-weight` of its own — so it
  /// inherits `html`'s 400.
  static final DsTypeSpec sheetBody = DsTypeSpec(
    family: DsFonts.sans,
    size: 13,
    wght: 400,
  );
}

/// Every `.type-*` class in globals.css, one [DsTypeSpec] each.
class DsType {
  const DsType._();

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
  static final DsTypeSpec display = DsTypeSpec(
    family: DsFonts.heading,
    height: 1,
    wght: 500,
    tracking: -0.03,
  );

  /// `.type-h1` — clamp 32–40/1.1, 700, `--tracking-tight` −0.02em (L1070).
  static final DsTypeSpec h1 = DsTypeSpec(
    family: DsFonts.sans,
    height: 1.1,
    wght: 700,
    tracking: -0.02,
  );

  /// `.type-h2` — 28px (1.75rem)/1.2, **650**, −0.015em (L1077).
  static final DsTypeSpec h2 = DsTypeSpec(
    family: DsFonts.sans,
    size: 28,
    height: 1.2,
    wght: 650,
    tracking: -0.015,
  );

  /// `.type-h3` — 21px (1.3125rem)/1.3, 600, −0.01em (L1084).
  static final DsTypeSpec h3 = DsTypeSpec(
    family: DsFonts.sans,
    size: 21,
    height: 1.3,
    wght: 600,
    tracking: -0.01,
  );

  /// `.type-h4` — 17px (1.0625rem)/1.4, 600, no tracking (L1091).
  static final DsTypeSpec h4 = DsTypeSpec(
    family: DsFonts.sans,
    size: 17,
    height: 1.4,
    wght: 600,
  );

  /// `.type-lead` — 17px (1.0625rem)/1.65, 400, muted-foreground (L1099).
  static final DsTypeSpec lead = DsTypeSpec(
    family: DsFonts.sans,
    size: 17,
    height: 1.65,
    wght: 400,
    defaultColor: DsTypeColor.muted,
  );

  /// `.type-body` — `--text-body` 15px/1.6, 400 (L1105).
  static final DsTypeSpec body = DsTypeSpec(
    family: DsFonts.sans,
    size: 15,
    height: 1.6,
    wght: 400,
  );

  /// `.type-small` — `--text-small` 13px/1.5, 400, muted-foreground (L1120).
  static final DsTypeSpec small = DsTypeSpec(
    family: DsFonts.sans,
    size: 13,
    height: 1.5,
    wght: 400,
    defaultColor: DsTypeColor.muted,
  );

  /// `.type-nav` — `--text-nav` 13.5px/1.2, 500 (L1128).
  static final DsTypeSpec nav = DsTypeSpec(
    family: DsFonts.sans,
    size: 13.5,
    height: 1.2,
    wght: 500,
  );

  /// `.type-nav-sm` — `--text-chip` 11.5px/1.2, 500 (L1139).
  /// The dense step of [nav]; sentence case is the whole point of the class.
  static final DsTypeSpec navSm = DsTypeSpec(
    family: DsFonts.sans,
    size: 11.5,
    height: 1.2,
    wght: 500,
  );

  /// `.type-chip` — `--text-chip` 11.5px/1.2, 500 (L1145).
  static final DsTypeSpec chip = DsTypeSpec(
    family: DsFonts.sans,
    size: 11.5,
    height: 1.2,
    wght: 500,
  );

  /// `.type-caption` — `--text-micro` 10.5px/1.35, 500 (L1151).
  static final DsTypeSpec caption = DsTypeSpec(
    family: DsFonts.sans,
    size: 10.5,
    height: 1.35,
    wght: 500,
  );

  /// `.type-code` — mono, `--text-code` 12.5px/1.4, **no font-weight
  /// declaration** — it inherits (L1157).
  static final DsTypeSpec code = DsTypeSpec(
    family: DsFonts.mono,
    size: 12.5,
    height: 1.4,
  );

  /// `.type-label` — `--text-label` 11px/1, 600, uppercase,
  /// `--tracking-label` 0.16em, muted-foreground (L1164).
  static final DsTypeSpec label = DsTypeSpec(
    family: DsFonts.sans,
    size: 11,
    height: 1,
    wght: 600,
    tracking: 0.16,
    uppercase: true,
    defaultColor: DsTypeColor.muted,
  );

  /// `.type-section` — `--text-small` 13px/1.4, 600, muted-foreground (L1192).
  /// The label's quiet twin: a group heading in sentence case.
  static final DsTypeSpec section = DsTypeSpec(
    family: DsFonts.sans,
    size: 13,
    height: 1.4,
    wght: 600,
    defaultColor: DsTypeColor.muted,
  );

  /// `.type-wordmark` — `--text-body` 15px/1, 700,
  /// `--tracking-num` −0.01em (L1201).
  static final DsTypeSpec wordmark = DsTypeSpec(
    family: DsFonts.sans,
    size: 15,
    height: 1,
    wght: 700,
    tracking: -0.01,
  );

  /// `.type-serial` — mono, `--text-body` 15px/1.4, uppercase,
  /// `--tracking-num` −0.01em, **no font-weight declaration** — it inherits
  /// (L1211).
  static final DsTypeSpec serial = DsTypeSpec(
    family: DsFonts.mono,
    size: 15,
    height: 1.4,
    tracking: -0.01,
    uppercase: true,
  );

  /// `.type-micro` — `--text-micro` 10.5px/1, 600, uppercase,
  /// `--tracking-micro` 0.18em, muted-foreground (L1218).
  static final DsTypeSpec micro = DsTypeSpec(
    family: DsFonts.sans,
    size: 10.5,
    height: 1,
    wght: 600,
    tracking: 0.18,
    uppercase: true,
    defaultColor: DsTypeColor.muted,
  );

  /// `.type-tag` — `--text-tag` 10px/1, 600, uppercase,
  /// `--tracking-tag` 0.12em (L1238). The smallest step.
  static final DsTypeSpec tag = DsTypeSpec(
    family: DsFonts.sans,
    size: 10,
    height: 1,
    wght: 600,
    tracking: 0.12,
    uppercase: true,
  );

  /// `.type-badge` — `--text-label` 11px/1, 600, uppercase,
  /// `--tracking-badge` 0.14em (L1246).
  static final DsTypeSpec badge = DsTypeSpec(
    family: DsFonts.sans,
    size: 11,
    height: 1,
    wght: 600,
    tracking: 0.14,
    uppercase: true,
  );

  /// `.type-accent` — Redaction 35, 1.055em, italic, 400,
  /// `--tracking-display` −0.03em, **no line-height declaration** — it
  /// inherits (L1046).
  static final DsTypeSpec accent = DsTypeSpec(
    family: DsFonts.accent,
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
  static final DsTypeSpec numXs = DsTypeSpec(
    family: DsFonts.mono,
    size: 11,
    height: 1.2,
    wght: 600,
    tracking: -0.01,
    tabular: true,
  );

  /// `.type-num-sm` — mono, `--text-num-sm` 12px/1.2, 600, tabular,
  /// −0.01em (L1271).
  static final DsTypeSpec numSm = DsTypeSpec(
    family: DsFonts.mono,
    size: 12,
    height: 1.2,
    wght: 600,
    tracking: -0.01,
    tabular: true,
  );

  /// `.type-num` — mono, `--text-body` 15px/1.2, 600, tabular, −0.01em
  /// (L1275). Named `numBase` because Dart reserves `num`.
  static final DsTypeSpec numBase = DsTypeSpec(
    family: DsFonts.mono,
    size: 15,
    height: 1.2,
    wght: 600,
    tracking: -0.01,
    tabular: true,
  );

  /// `.type-num-md` — mono, 20px (1.25rem)/1.15, 600, tabular,
  /// −0.01em (L1279).
  static final DsTypeSpec numMd = DsTypeSpec(
    family: DsFonts.mono,
    size: 20,
    height: 1.15,
    wght: 600,
    tracking: -0.01,
    tabular: true,
  );

  /// `.type-num-lg` — mono, 28px (1.75rem)/1.05, 600, tabular,
  /// −0.01em (L1283).
  static final DsTypeSpec numLg = DsTypeSpec(
    family: DsFonts.mono,
    size: 28,
    height: 1.05,
    wght: 600,
    tracking: -0.01,
    tabular: true,
  );

  /// `.type-num-xl` — mono, 40px (2.5rem)/1, 600, tabular, and the one
  /// numeric that leaves `--tracking-num`: −0.025em (L1287).
  static final DsTypeSpec numXl = DsTypeSpec(
    family: DsFonts.mono,
    size: 40,
    height: 1,
    wght: 600,
    tracking: -0.025,
    tabular: true,
  );

  /// All 27 classes, in the order globals.css declares them (L1019–1292).
  static final List<DsTypeSpec> all = <DsTypeSpec>[
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
    label,
    section,
    wordmark,
    serial,
    micro,
    tag,
    badge,
    numXs,
    numSm,
    numBase,
    numMd,
    numLg,
    numXl,
  ];
}
