/// The two theme blocks of `app/globals.css`, resolved.
///
/// * light — `:root, .light` (globals.css L546–735)
/// * dark  — `.dark` (globals.css L741–942)
///
/// Dark is the mode the system was designed in and is still its default
/// (L737–740). `.light` exists so a light island inside a dark page resolves
/// correctly, which is what a side-by-side specimen is; [DsThemeData.light] is
/// its equivalent here and can be handed to any subtree.
///
/// Every field of [DsThemeData] is one CSS custom property. Where the stylesheet
/// writes `var(--other)`, this file resolves it at construction — the resolved
/// value is what a component reads either way.
library;

import 'dart:ui' show Color;

import 'colors.dart';

/// Which theme block a [DsThemeData] transcribes.
enum DsThemeKind {
  /// `:root, .light` — globals.css L546.
  light,

  /// `.dark` — globals.css L741.
  dark,
}

/// One resolved theme block.
class DsThemeData {
  const DsThemeData._({
    required this.kind,
    required this.background,
    required this.foreground,
    required this.card,
    required this.cardForeground,
    required this.popover,
    required this.popoverForeground,
    required this.secondary,
    required this.secondaryForeground,
    required this.muted,
    required this.mutedForeground,
    required this.accent,
    required this.accentForeground,
    required this.border,
    required this.input,
    required this.pageGlow,
    required this.primary,
    required this.primaryForeground,
    required this.ring,
    required this.actionInk,
    required this.valueInk,
    required this.successInk,
    required this.warningInk,
    required this.infoInk,
    required this.destructiveInk,
    required this.destructive,
    required this.destructiveForeground,
    required this.bubbleTinted,
    required this.bubbleTintedHover,
    required this.radius,
    required this.ink1,
    required this.ink2,
    required this.ink3,
    required this.ink4,
    required this.rim,
    required this.rimStrong,
    required this.wall,
    required this.chart1,
    required this.chart2,
    required this.chart3,
    required this.chart4,
    required this.chart5,
    required this.sidebar,
    required this.sidebarForeground,
    required this.sidebarPrimary,
    required this.sidebarPrimaryForeground,
    required this.sidebarAccent,
    required this.sidebarAccentForeground,
    required this.sidebarBorder,
    required this.sidebarRing,
    required this.agent,
    required this.agentMuted,
    required this.scrim,
  });

  /// Which block this is.
  final DsThemeKind kind;

  // ── Monochrome: zinc ──────────────────────────────────────────────────────

  /// `--background` — light `hsl(0 0% 100%)` L549 / dark `hsl(240 10% 3.9%)`
  /// (zinc 950) L746.
  final Color background;

  /// `--foreground` — light `hsl(240 10% 3.9%)` L550 / dark `hsl(0 0% 98%)`
  /// (zinc 50) L747.
  final Color foreground;

  /// `--card` — light `hsl(0 0% 100%)` L552 / dark `hsl(240 5.9% 10%)`
  /// (zinc 900) L749.
  final Color card;

  /// `--card-foreground` — light `hsl(240 10% 3.9%)` L553 / dark `hsl(0 0% 98%)`
  /// L750.
  final Color cardForeground;

  /// `--popover` — light `hsl(0 0% 100%)` L554 / dark `hsl(240 5.9% 10%)` L751.
  final Color popover;

  /// `--popover-foreground` — light `hsl(240 10% 3.9%)` L555 /
  /// dark `hsl(0 0% 98%)` L752.
  final Color popoverForeground;

  /// `--secondary` — light `hsl(240 4.8% 95.9%)` (zinc 100) L557 /
  /// dark `hsl(240 3.7% 15.9%)` (zinc 800) L754.
  final Color secondary;

  /// `--secondary-foreground` — light `hsl(240 5.9% 10%)` L558 /
  /// dark `hsl(0 0% 98%)` L755.
  final Color secondaryForeground;

  /// `--muted` — light `hsl(240 4.8% 95.9%)` L559 / dark `hsl(240 3.7% 15.9%)`
  /// L756.
  final Color muted;

  /// `--muted-foreground` — light `hsl(240 4% 40%)` L569 /
  /// dark `hsl(240 4.9% 83.9%)` (zinc 300) L757.
  ///
  /// The one place light mode cannot mirror dark, and NOT zinc 500: zinc 500
  /// cleared AA on `--background` at 4.83:1 and missed it on `--muted` at
  /// 4.40:1, which is the most repeated foreground/surface pair in the file
  /// (L560–568).
  final Color mutedForeground;

  /// `--accent` — light `hsl(240 4.8% 95.9%)` L570 / dark `hsl(240 5.3% 26.1%)`
  /// (zinc 700) L758.
  final Color accent;

  /// `--accent-foreground` — light `hsl(240 5.9% 10%)` L571 /
  /// dark `hsl(0 0% 98%)` L759.
  final Color accentForeground;

  /// `--border` — light `hsl(240 5.9% 90%)` L573 / dark `hsl(240 3.7% 15.9%)`
  /// L761.
  final Color border;

  /// `--input` — light `hsl(240 5.9% 90%)` L574 / dark `hsl(240 5.3% 26.1%)`
  /// L762.
  final Color input;

  /// `--page-glow` — light `hsl(240 30% 98%)` L579 / dark `hsl(240 8% 10%)`
  /// L769.
  ///
  /// The page's light source, painted by the `body` rule as
  /// `radial-gradient(120% 90% at 62% 34%, var(--page-glow) 0%, transparent
  /// 64%)` (L984–994). On paper the lift is almost nothing, because a visible
  /// gradient on white reads as a stain rather than as light.
  final Color pageGlow;

  // ── Brand ─────────────────────────────────────────────────────────────────

  /// `--primary: var(--color-action)` — L582 light, L772 dark. Same in both.
  final Color primary;

  /// `--primary-foreground: hsl(0 0% 100%)` — L583 light, L779 dark.
  ///
  /// Pure white, not zinc 50: zinc 50 on the action fill rasterises at 4.39:1
  /// and misses AA by 0.11 on the most-used control in the system; pure white
  /// is 4.58:1 (L773–778).
  final Color primaryForeground;

  /// `--ring` — light `var(--color-action)` L584 /
  /// dark `var(--color-action-bright)` L780.
  final Color ring;

  // ── The text-safe end of each ramp, per theme ─────────────────────────────

  /// `--action-ink` — light `var(--color-action-dark)` L589 /
  /// dark `var(--color-action-bright)` L784.
  ///
  /// Nothing in the system writes `text-action-bright`; it writes
  /// `text-action-ink`, and this is where the answer differs between the modes.
  final Color actionInk;

  /// `--value-ink` — light `var(--color-value-dark)` L590 /
  /// dark `var(--color-value-bright)` L798.
  ///
  /// DOCUMENTED DRIFT: dark points at `-bright`, not the mid shade the system's
  /// own §1.3 table prescribes. The file keeps it deliberately so the next
  /// rebrand cannot reintroduce a contrast failure nothing catches (L785–797).
  final Color valueInk;

  /// `--success-ink` — light `var(--color-success-deep)` L591 /
  /// dark `var(--color-success)` L799.
  final Color successInk;

  /// `--warning-ink` — light `var(--color-warning-deep)` L592 /
  /// dark `var(--color-warning)` L800.
  final Color warningInk;

  /// `--info-ink` — light `var(--color-info-deep)` L593 /
  /// dark `var(--color-info)` L801.
  final Color infoInk;

  /// `--destructive-ink` — light `var(--color-destructive-deep)` L594 /
  /// dark `var(--color-destructive-lifted)` L802.
  final Color destructiveInk;

  /// `--destructive: hsl(0 72.2% 50.6%)` — L596 light, L805 dark. One red in
  /// both themes; shadcn's own error token.
  final Color destructive;

  /// `--destructive-foreground: hsl(0 0% 98%)` — L597 light, L806 dark.
  final Color destructiveForeground;

  // ── Derived tint ──────────────────────────────────────────────────────────

  /// `--bubble-tinted` — light `oklch(from var(--primary) 0.93 calc(c * 0.4) h)`
  /// L602 / dark `oklch(from var(--primary) 0.3 calc(c * 0.4) h)` L811.
  ///
  /// Computed by [DsOklab.fromOklchRelative], never hardcoded: it is derived
  /// from the action ramp so it follows a rebrand (L599–601).
  final Color bubbleTinted;

  /// `--bubble-tinted-hover` — light
  /// `oklch(from var(--primary) 0.88 calc(c * 0.5) h)` L603 /
  /// dark `oklch(from var(--primary) 0.35 calc(c * 0.5) h)` L812.
  final Color bubbleTintedHover;

  /// `--radius: 10px` — L605 light, L814 dark. The container ladder's default
  /// step; numerically `--radius-md`.
  final double radius;

  // ── Shadow ink ────────────────────────────────────────────────────────────
  // The geometry in `@theme static` never changes; only what colour fills it
  // (L607–609 / L816–819). Light is slate at roughly a fifth of dark's opacity;
  // dark is black and heavy, because on a zinc-950 page a shadow has to be
  // darker than the surface it falls on or it is invisible.

  /// `--ink-1` — light `hsl(240 20% 20% / 0.04)` L610 /
  /// dark `rgb(0 0 0 / 0.35)` L820.
  final Color ink1;

  /// `--ink-2` — light `hsl(240 20% 20% / 0.07)` L611 /
  /// dark `rgb(0 0 0 / 0.5)` L821.
  final Color ink2;

  /// `--ink-3` — light `hsl(240 20% 20% / 0.11)` L612 /
  /// dark `rgb(0 0 0 / 0.6)` L822.
  final Color ink3;

  /// `--ink-4` — light `hsl(240 20% 20% / 0.16)` L613 /
  /// dark `rgb(0 0 0 / 0.75)` L823.
  final Color ink4;

  /// `--rim` — light `hsl(0 0% 100% / 0.85)` L614 /
  /// dark `rgb(255 255 255 / 0.14)` L824. The inner top highlight of a machine
  /// surface.
  final Color rim;

  /// `--rim-strong` — light `hsl(0 0% 100% / 0.4)` L615 /
  /// dark `rgb(255 255 255 / 0.28)` L825.
  final Color rimStrong;

  /// `--wall` — light `hsl(240 6% 82%)` L616 / dark `hsl(240 6% 8%)` L826.
  /// The side wall a raised key travels down into.
  final Color wall;

  // ── Charts ────────────────────────────────────────────────────────────────
  // Each token names the end of its ramp that reads on THIS theme's surfaces —
  // deliberately not "run down each ramp" (L618–623 / L828–841).

  /// `--chart-1` — light `var(--color-action)` L624 /
  /// dark `var(--color-action-bright)` L842.
  final Color chart1;

  /// `--chart-2` — light `var(--color-value-dark)` L625 /
  /// dark `var(--color-value)` L843.
  final Color chart2;

  /// `--chart-3` — light `var(--color-info-deep)` L626 /
  /// dark `var(--color-info)` L844.
  final Color chart3;

  /// `--chart-4` — light `var(--color-action-dark)` L627 /
  /// dark `var(--color-value-bright)` L845.
  final Color chart4;

  /// `--chart-5` — light `var(--color-success-deep)` L628 /
  /// dark `var(--color-success)` L846.
  final Color chart5;

  // ── Sidebar ───────────────────────────────────────────────────────────────
  // Eight tokens that all resolve to something else, declared VERBATIM in both
  // theme blocks on purpose (L630–650 / L848–861): a `:root`-only declaration
  // would inherit the wrong theme's surface the moment a subtree is themed,
  // which is exactly what a side-by-side light/dark specimen does.

  /// `--sidebar: var(--card)` — L651 light, L862 dark.
  final Color sidebar;

  /// `--sidebar-foreground: var(--muted-foreground)` — L652 light, L863 dark.
  final Color sidebarForeground;

  /// `--sidebar-primary: var(--primary)` — L653 light, L864 dark.
  final Color sidebarPrimary;

  /// `--sidebar-primary-foreground: var(--primary-foreground)` — L654 / L865.
  final Color sidebarPrimaryForeground;

  /// `--sidebar-accent: var(--accent)` — L655 light, L866 dark.
  final Color sidebarAccent;

  /// `--sidebar-accent-foreground: var(--accent-foreground)` — L656 / L867.
  final Color sidebarAccentForeground;

  /// `--sidebar-border: var(--border)` — L657 light, L868 dark.
  final Color sidebarBorder;

  /// `--sidebar-ring: var(--ring)` — L658 light, L869 dark.
  final Color sidebarRing;

  // ── Agent ─────────────────────────────────────────────────────────────────

  /// `--agent` — light `var(--color-action)` L661 /
  /// dark `var(--color-action-bright)` L881.
  ///
  /// The agent acts, so the agent is the action colour; dark resolves to the
  /// ramp's lifted end because it is read as a foreground far more often than
  /// as a mark (L871–880).
  final Color agent;

  /// `--agent-muted` — light `hsl(213 100% 97%)` L662 / dark `hsl(217 40% 13%)`
  /// L903. The agent's own turn in the transcript, one step off `--card`.
  final Color agentMuted;

  /// `--scrim` — light `hsl(240 10% 3.9% / 0.28)` L663 /
  /// dark `hsl(240 10% 3.9% / 0.66)` L906.
  final Color scrim;

  // ───────────────────────────────────────────────────────────────────────────

  /// `:root, .light` — globals.css L546–735.
  static final DsThemeData light = _build(
    kind: DsThemeKind.light,
    background: dsHsl(0, 0, 100),
    foreground: dsHsl(240, 10, 3.9),
    card: dsHsl(0, 0, 100),
    cardForeground: dsHsl(240, 10, 3.9),
    popover: dsHsl(0, 0, 100),
    popoverForeground: dsHsl(240, 10, 3.9),
    secondary: dsHsl(240, 4.8, 95.9),
    secondaryForeground: dsHsl(240, 5.9, 10),
    muted: dsHsl(240, 4.8, 95.9),
    mutedForeground: dsHsl(240, 4, 40),
    accent: dsHsl(240, 4.8, 95.9),
    accentForeground: dsHsl(240, 5.9, 10),
    border: dsHsl(240, 5.9, 90),
    input: dsHsl(240, 5.9, 90),
    pageGlow: dsHsl(240, 30, 98),
    primary: DsPalette.action,
    primaryForeground: dsHsl(0, 0, 100),
    ring: DsPalette.action,
    actionInk: DsPalette.actionDark,
    valueInk: DsPalette.valueDark,
    successInk: DsPalette.successDeep,
    warningInk: DsPalette.warningDeep,
    infoInk: DsPalette.infoDeep,
    destructiveInk: DsPalette.destructiveDeep,
    destructive: dsHsl(0, 72.2, 50.6),
    destructiveForeground: dsHsl(0, 0, 98),
    // oklch(from var(--primary) 0.93 calc(c * 0.4) h) — L602.
    bubbleLightness: 0.93,
    bubbleChromaScale: 0.4,
    // oklch(from var(--primary) 0.88 calc(c * 0.5) h) — L603.
    bubbleHoverLightness: 0.88,
    bubbleHoverChromaScale: 0.5,
    radius: 10,
    ink1: dsHsl(240, 20, 20, 0.04),
    ink2: dsHsl(240, 20, 20, 0.07),
    ink3: dsHsl(240, 20, 20, 0.11),
    ink4: dsHsl(240, 20, 20, 0.16),
    rim: dsHsl(0, 0, 100, 0.85),
    rimStrong: dsHsl(0, 0, 100, 0.4),
    wall: dsHsl(240, 6, 82),
    chart1: DsPalette.action,
    chart2: DsPalette.valueDark,
    chart3: DsPalette.infoDeep,
    chart4: DsPalette.actionDark,
    chart5: DsPalette.successDeep,
    agent: DsPalette.action,
    agentMuted: dsHsl(213, 100, 97),
    scrim: dsHsl(240, 10, 3.9, 0.28),
  );

  /// `.dark` — globals.css L741–942.
  static final DsThemeData dark = _build(
    kind: DsThemeKind.dark,
    background: dsHsl(240, 10, 3.9),
    foreground: dsHsl(0, 0, 98),
    card: dsHsl(240, 5.9, 10),
    cardForeground: dsHsl(0, 0, 98),
    popover: dsHsl(240, 5.9, 10),
    popoverForeground: dsHsl(0, 0, 98),
    secondary: dsHsl(240, 3.7, 15.9),
    secondaryForeground: dsHsl(0, 0, 98),
    muted: dsHsl(240, 3.7, 15.9),
    mutedForeground: dsHsl(240, 4.9, 83.9),
    accent: dsHsl(240, 5.3, 26.1),
    accentForeground: dsHsl(0, 0, 98),
    border: dsHsl(240, 3.7, 15.9),
    input: dsHsl(240, 5.3, 26.1),
    pageGlow: dsHsl(240, 8, 10),
    primary: DsPalette.action,
    primaryForeground: dsHsl(0, 0, 100),
    ring: DsPalette.actionBright,
    actionInk: DsPalette.actionBright,
    valueInk: DsPalette.valueBright,
    successInk: DsPalette.success,
    warningInk: DsPalette.warning,
    infoInk: DsPalette.info,
    destructiveInk: DsPalette.destructiveLifted,
    destructive: dsHsl(0, 72.2, 50.6),
    destructiveForeground: dsHsl(0, 0, 98),
    // oklch(from var(--primary) 0.3 calc(c * 0.4) h) — L811.
    bubbleLightness: 0.3,
    bubbleChromaScale: 0.4,
    // oklch(from var(--primary) 0.35 calc(c * 0.5) h) — L812.
    bubbleHoverLightness: 0.35,
    bubbleHoverChromaScale: 0.5,
    radius: 10,
    // rgb(0 0 0 / a) and rgb(255 255 255 / a) — the same colours hsl() spells
    // as `hsl(0 0% 0%)` and `hsl(0 0% 100%)`.
    ink1: dsHsl(0, 0, 0, 0.35),
    ink2: dsHsl(0, 0, 0, 0.5),
    ink3: dsHsl(0, 0, 0, 0.6),
    ink4: dsHsl(0, 0, 0, 0.75),
    rim: dsHsl(0, 0, 100, 0.14),
    rimStrong: dsHsl(0, 0, 100, 0.28),
    wall: dsHsl(240, 6, 8),
    chart1: DsPalette.actionBright,
    chart2: DsPalette.value,
    chart3: DsPalette.info,
    chart4: DsPalette.valueBright,
    chart5: DsPalette.success,
    agent: DsPalette.actionBright,
    agentMuted: dsHsl(217, 40, 13),
    scrim: dsHsl(240, 10, 3.9, 0.66),
  );

  /// Builds one theme block from its DECLARED tokens, resolving the two groups
  /// the stylesheet writes as references rather than values:
  ///
  /// * the eight `--sidebar-*` aliases, which point at `--card`,
  ///   `--muted-foreground`, `--primary`, `--primary-foreground`, `--accent`,
  ///   `--accent-foreground`, `--border` and `--ring` in both blocks;
  /// * `--bubble-tinted` / `--bubble-tinted-hover`, which are relative OKLCH
  ///   colours derived from `--primary`.
  static DsThemeData _build({
    required DsThemeKind kind,
    required Color background,
    required Color foreground,
    required Color card,
    required Color cardForeground,
    required Color popover,
    required Color popoverForeground,
    required Color secondary,
    required Color secondaryForeground,
    required Color muted,
    required Color mutedForeground,
    required Color accent,
    required Color accentForeground,
    required Color border,
    required Color input,
    required Color pageGlow,
    required Color primary,
    required Color primaryForeground,
    required Color ring,
    required Color actionInk,
    required Color valueInk,
    required Color successInk,
    required Color warningInk,
    required Color infoInk,
    required Color destructiveInk,
    required Color destructive,
    required Color destructiveForeground,
    required double bubbleLightness,
    required double bubbleChromaScale,
    required double bubbleHoverLightness,
    required double bubbleHoverChromaScale,
    required double radius,
    required Color ink1,
    required Color ink2,
    required Color ink3,
    required Color ink4,
    required Color rim,
    required Color rimStrong,
    required Color wall,
    required Color chart1,
    required Color chart2,
    required Color chart3,
    required Color chart4,
    required Color chart5,
    required Color agent,
    required Color agentMuted,
    required Color scrim,
  }) {
    return DsThemeData._(
      kind: kind,
      background: background,
      foreground: foreground,
      card: card,
      cardForeground: cardForeground,
      popover: popover,
      popoverForeground: popoverForeground,
      secondary: secondary,
      secondaryForeground: secondaryForeground,
      muted: muted,
      mutedForeground: mutedForeground,
      accent: accent,
      accentForeground: accentForeground,
      border: border,
      input: input,
      pageGlow: pageGlow,
      primary: primary,
      primaryForeground: primaryForeground,
      ring: ring,
      actionInk: actionInk,
      valueInk: valueInk,
      successInk: successInk,
      warningInk: warningInk,
      infoInk: infoInk,
      destructiveInk: destructiveInk,
      destructive: destructive,
      destructiveForeground: destructiveForeground,
      bubbleTinted: DsOklab.fromOklchRelative(
        primary,
        lightness: bubbleLightness,
        chromaScale: bubbleChromaScale,
      ),
      bubbleTintedHover: DsOklab.fromOklchRelative(
        primary,
        lightness: bubbleHoverLightness,
        chromaScale: bubbleHoverChromaScale,
      ),
      radius: radius,
      ink1: ink1,
      ink2: ink2,
      ink3: ink3,
      ink4: ink4,
      rim: rim,
      rimStrong: rimStrong,
      wall: wall,
      chart1: chart1,
      chart2: chart2,
      chart3: chart3,
      chart4: chart4,
      chart5: chart5,
      sidebar: card,
      sidebarForeground: mutedForeground,
      sidebarPrimary: primary,
      sidebarPrimaryForeground: primaryForeground,
      sidebarAccent: accent,
      sidebarAccentForeground: accentForeground,
      sidebarBorder: border,
      sidebarRing: ring,
      agent: agent,
      agentMuted: agentMuted,
      scrim: scrim,
    );
  }
}
