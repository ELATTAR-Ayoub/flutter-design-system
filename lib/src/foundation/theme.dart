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
    required this.cube,
    required this.scrim,
    required this.bloomVoid,
    required this.bloomL,
    required this.bloomC,
    required this.bloomLift,
    required this.bloomHotC,
    required this.starGlowSize,
    required this.starGlowMix,
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

  /// The twelve `--agent-cube-*` tokens — see [DsAgentCubeTokens].
  ///
  /// Grouped into an object rather than spread across twelve fields here
  /// because they are read as a **set**: every consumer is a cube face resolver
  /// that needs the whole palette at once, and `bloom`'s five knobs above are
  /// the opposite case — five unrelated scalars each read on its own.
  final DsAgentCubeTokens cube;

  /// `--scrim` — light `hsl(240 10% 3.9% / 0.28)` L663 /
  /// dark `hsl(240 10% 3.9% / 0.66)` L906.
  final Color scrim;

  // ── `bloom-cosmic`'s five theme knobs ──────────────────────────────────────
  // Declared in the two theme blocks beside every other token (globals.css
  // L699–715 light, L885–898 dark) and read by exactly one effect, which
  // computes `--bloom-core` / `--bloom-glow` / `--bloom-hot` from them with
  // relative-OKLCH syntax. They lived in `effects/bloom_cosmic.dart` under a
  // standing FOLLOW-UP until this file was next opened; supervisor ruling F9
  // is that opening.
  //
  // The line this draws, and the reason `--star-glow` is NOT here: a bloom
  // variable that resolves to a **flat** value per theme block is a theme
  // token and lives here. The ones that read `--bloom-1` / `--bloom-2` —
  // `--bloom-core`, `--bloom-glow`, `--bloom-hot`, and `--star-glow` on light
  // — cannot be flattened, because those two customs only exist on the host
  // element. Those stay derivations, next to the effect that performs them.

  /// `--bloom-void` — light `white` L700 / dark `black` L886.
  ///
  /// The identity operand of the theme's own blend mode: `multiply` by white
  /// and `screen` by black both leave the destination alone. Every gradient
  /// ramp in the effect ends here rather than on `transparent`, which is what
  /// makes the light fade out instead of leaving a rectangular edge.
  final Color bloomVoid;

  /// `--bloom-l` — light **0.6** L701 / dark **1** L887.
  ///
  /// The lightness multiplier every hue is put through before it is blurred.
  /// On paper a pale wash multiplied into white disappears, so light darkens
  /// first; dark is identity and the hues go in as they are.
  final double bloomL;

  /// `--bloom-c` — light **1.55** L702 / dark **1** L888. Chroma, same story:
  /// light pushes a hue well past its own saturation to survive the multiply.
  final double bloomC;

  /// `--bloom-lift` — light **0** L703 / dark **0.85** L889.
  ///
  /// How far `--bloom-hot` is lifted from `--bloom-core` toward white:
  /// `calc(l + (1 - l) * var(--bloom-lift))`. Zero on light, so the hot core
  /// is the core exactly — pure pigment.
  final double bloomLift;

  /// `--bloom-hot-c` — light **1** L704 / dark **0.5** L890. Half-desaturating
  /// the lifted core is what makes it read as light on glass rather than paint.
  final double bloomHotC;

  /// `--star-glow-size` — light **3px** L715 / dark **2px** L898.
  ///
  /// The `.starfield`'s tight `drop-shadow` radius; its wide companion is
  /// `calc(… * 3)`, which is the utility's own declaration and stays there.
  /// Light spends the larger radius because a coloured glow on paper has to
  /// travel further to register than white light on black does.
  final double starGlowSize;

  /// `--star-glow`'s strength — light **0.85** L714 / dark **0.5** L897.
  ///
  /// The one number the two blocks share a meaning for and not a form: dark
  /// declares `rgb(255 255 255 / 0.5)`, a flat white at half alpha, while light
  /// declares `color-mix(in oklab, var(--bloom-2) 85%, transparent)` — the
  /// host's own hue at 85%. Only the **strength** can be flattened into a theme
  /// block; which colour it is applied to depends on `--bloom-2`, which exists
  /// only on the host element. `DsStarfield.glowFor` is that second half.
  final double starGlowMix;

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
    // CSS `white` *is* `hsl(0 0% 100%)`; spelled as the top of the lightness
    // axis rather than as an ARGB literal, so this block states no colour the
    // rest of it would not.
    bloomVoid: dsHsl(0, 0, 100),
    bloomL: 0.6,
    bloomC: 1.55,
    bloomLift: 0,
    bloomHotC: 1,
    starGlowSize: 3,
    starGlowMix: 0.85,
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
    // `black` — the bottom of the same axis, for the same reason.
    bloomVoid: dsHsl(0, 0, 0),
    bloomL: 1,
    bloomC: 1,
    bloomLift: 0.85,
    bloomHotC: 0.5,
    starGlowSize: 2,
    starGlowMix: 0.5,
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
    required Color bloomVoid,
    required double bloomL,
    required double bloomC,
    required double bloomLift,
    required double bloomHotC,
    required double starGlowSize,
    required double starGlowMix,
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
      // Resolved off the block being built rather than passed in, exactly as
      // the eight sidebar tokens above are: the two sets are declared verbatim
      // per theme block, so which one this is *is* the whole of the lookup.
      cube: kind == DsThemeKind.dark
          ? DsAgentCubeTokens.dark
          : DsAgentCubeTokens.light,
      scrim: scrim,
      bloomVoid: bloomVoid,
      bloomL: bloomL,
      bloomC: bloomC,
      bloomLift: bloomLift,
      bloomHotC: bloomHotC,
      starGlowSize: starGlowSize,
      starGlowMix: starGlowMix,
    );
  }
}

/// `--agent-cube-*` — globals.css L720–731 (light) and L914–932 (dark).
///
/// The one block in the system that is not re-derivable from the semantic
/// tokens, and globals.css says why: *"the handoff draws these cubes for paper,
/// and the dark set is already an inversion of that original. This is the
/// original."*
///
/// FOLLOW-UP CLOSED. These lived in `components/agent_avatar.dart` under a
/// standing note — they are theme tokens, declared in the two theme blocks
/// beside every other one, and that file was not the avatar lane's to open.
/// This pass is the opening, and it is `bloom_cosmic.dart`'s move one family
/// over: the flat per-block values come here, the derivations stay with the
/// effect that performs them (`DsAgentCubeFaces` mixes the accent's own top and
/// right faces out of [accent] and [accentShade], so it cannot be flattened
/// into a block and does not move).
///
/// The note also asked that `DsAgentCubeTokens.of(BuildContext)` come with
/// them. It does not: it was a second resolver for what `DsTheme.of` already
/// does, and the tokens now ride [DsThemeData.cube] like every other one. That
/// is the whole of the API change — the two statics below are untouched, which
/// is what the avatar tests spend.
class DsAgentCubeTokens {
  const DsAgentCubeTokens({
    required this.top,
    required this.left,
    required this.right,
    required this.stroke,
    required this.accent,
    required this.accentShade,
    required this.back,
    required this.ghostInk,
    required this.errorTop,
    required this.errorLeft,
    required this.errorRight,
    required this.errorStroke,
  });

  /// `--agent-cube-top` — light `hsl(240 20% 99%)` / dark `hsl(240 5% 21%)`.
  final Color top;

  /// `--agent-cube-left` — light `hsl(240 15% 94%)` / dark `hsl(240 5% 17%)`.
  final Color left;

  /// `--agent-cube-right` — light `hsl(240 14% 90%)` / dark `hsl(240 5% 14%)`.
  final Color right;

  /// `--agent-cube-stroke` — light `hsl(240 10% 79%)` / dark `hsl(240 5% 31%)`.
  final Color stroke;

  /// `--agent-cube-accent` — light `var(--color-action)` / dark
  /// `var(--color-action-bright)`. The single knob; `DsCubeAvatar.accent`
  /// overrides it.
  final Color accent;

  /// `--agent-cube-accent-shade` — light `hsl(217 45% 72%)` / dark
  /// `hsl(217 40% 32%)`. *"Mixed into the accent's right face to shade it."*
  final Color accentShade;

  /// `--agent-cube-back` — light `hsl(240 14% 86%)` / dark `hsl(240 6% 10%)`.
  /// *"The sixth face of the idle cube — the one plane the isometric scenes
  /// never show, so it has no counterpart above."*
  final Color back;

  /// `--agent-cube-ghost-ink` — light `hsl(240 5% 54%)` / dark
  /// `hsl(240 5% 45%)`. *"Mixed into the dashed cube's stroke to grey it back
  /// from the accent."*
  final Color ghostInk;

  /// `--agent-cube-error-top` — light `hsl(0 70% 88%)` / dark `hsl(0 60% 46%)`.
  final Color errorTop;

  /// `--agent-cube-error-left` — light `hsl(0 65% 82%)` / dark `hsl(0 62% 39%)`.
  final Color errorLeft;

  /// `--agent-cube-error-right` — light `hsl(0 60% 75%)` / dark
  /// `hsl(0 63% 33%)`.
  final Color errorRight;

  /// `--agent-cube-error-stroke` — light `hsl(0 55% 69%)` / dark
  /// `hsl(0 68% 58%)`. *"Error is the one state that leaves the accent, because
  /// it has to: a blue failure looks like a blue success."*
  final Color errorStroke;

  /// globals.css L720–731.
  static final DsAgentCubeTokens light = DsAgentCubeTokens(
    top: dsHsl(240, 20, 99),
    left: dsHsl(240, 15, 94),
    right: dsHsl(240, 14, 90),
    stroke: dsHsl(240, 10, 79),
    accent: DsPalette.action,
    accentShade: dsHsl(217, 45, 72),
    back: dsHsl(240, 14, 86),
    ghostInk: dsHsl(240, 5, 54),
    errorTop: dsHsl(0, 70, 88),
    errorLeft: dsHsl(0, 65, 82),
    errorRight: dsHsl(0, 60, 75),
    errorStroke: dsHsl(0, 55, 69),
  );

  /// globals.css L914–932.
  static final DsAgentCubeTokens dark = DsAgentCubeTokens(
    top: dsHsl(240, 5, 21),
    left: dsHsl(240, 5, 17),
    right: dsHsl(240, 5, 14),
    stroke: dsHsl(240, 5, 31),
    accent: DsPalette.actionBright,
    accentShade: dsHsl(217, 40, 32),
    back: dsHsl(240, 6, 10),
    ghostInk: dsHsl(240, 5, 45),
    errorTop: dsHsl(0, 60, 46),
    errorLeft: dsHsl(0, 62, 39),
    errorRight: dsHsl(0, 63, 33),
    errorStroke: dsHsl(0, 68, 58),
  );
}
