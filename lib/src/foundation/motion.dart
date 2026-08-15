/// Motion tokens — a transcript of the reference's timing layer.
///
/// Source of truth: `design-system/app/globals.css` L395–432.
/// This file is inside `lib/src/foundation/`, the one place literals live.
library;

import 'package:flutter/animation.dart';

/// Every `--duration-*` token.
///
/// The scale's own thesis (globals.css L390–391): *"`tick` is the machine
/// beat: a press registers in 80ms, then springs back over `base`. That
/// asymmetry — instant in, springy out — is the whole feel."*
class DsDurations {
  const DsDurations._();

  /// `--duration-tick: 80ms` (L398) — the press-down beat.
  static const Duration tick = Duration(milliseconds: 80);

  /// `--duration-fast: 150ms` (L399).
  static const Duration fast = Duration(milliseconds: 150);

  /// `--duration-base: 250ms` (L400).
  ///
  /// Also `--default-transition-duration` (L395): the framework's own default
  /// is pointed at this token so nothing can beat it on the same element.
  static const Duration base = Duration(milliseconds: 250);

  /// `--duration-slow: 400ms` (L401).
  static const Duration slow = Duration(milliseconds: 400);

  /// `--duration-overlay: 320ms` (L402) — every overlay enter/exit.
  static const Duration overlay = Duration(milliseconds: 320);

  /// `--duration-jelly: 420ms` (L406). Longer than [overlay] because
  /// [DsCurves.spring] spends its last stretch settling an overshoot.
  static const Duration jelly = Duration(milliseconds: 420);

  /// `--duration-reward: 550ms` (L407).
  static const Duration reward = Duration(milliseconds: 550);

  /// `--duration-bloom: 1000ms` (L411) — ambient, not interactive.
  static const Duration bloom = Duration(milliseconds: 1000);

  /// `--duration-sway: 44s` (L417) — the starfield's slow sway.
  static const Duration sway = Duration(seconds: 44);

  /// `--duration-sway-alt: 33s` (L418). Deliberately not a multiple of
  /// [sway]: sways that share a period re-sync and the field reads as one
  /// rigid sheet.
  static const Duration swayAlt = Duration(seconds: 33);

  // ── Durations globals.css writes as literals ────────────────────────────
  // Three utilities set a duration inline rather than through a `--duration-*`
  // token. They are transcribed here anyway: the constraint is that literals
  // live in this layer, not that the reference happened to name them.

  /// `press`/`click-spring`/`press-spring` `:active { transition-duration:
  /// 40ms }` (globals.css L2283 / L2292 / L2302).
  ///
  /// The down-stroke of the whole click feel. Its comment (L2276): *"The
  /// asymmetry is the point: 40ms down, 250ms spring back."*
  static const Duration pressDown = Duration(milliseconds: 40);

  /// `anim-jelly { animation: yuki-jelly 0.6s var(--ease-out) both }`
  /// (globals.css L2366) — the arrival replay of a travelling pill.
  ///
  /// Deliberately NOT [jelly] (420ms): that token belongs to `anim-jelly-in`,
  /// the overlay entrance. The two are different animations that share a name
  /// stem, and collapsing them would slow every pill arrival by 43%.
  static const Duration animJelly = Duration(milliseconds: 600);

  // ── The named animations' own literals ──────────────────────────────────
  // Six of the nine `anim-*` utilities set their duration inline; only
  // `anim-jelly-in` (--duration-jelly) and `anim-reveal` (--duration-reward)
  // read a token (motion-map §6.2, drift D16). Same argument as [animJelly]:
  // the constraint is that literals live in this layer, not that the
  // reference happened to name them.

  /// `anim-pop-in { animation: yuki-pop-in 0.55s var(--ease-out) both }`
  /// (globals.css L2361–2363).
  ///
  /// Numerically equal to [reward] and deliberately not spelled as it: the
  /// reference writes `0.55s`, so a rebrand that retimes the reward moment
  /// must not silently retime the pop.
  static const Duration popIn = Duration(milliseconds: 550);

  /// `anim-spring-up { animation: yuki-spring-up 0.8s var(--ease-settle) both }`
  /// (globals.css L2369–2371).
  static const Duration springUp = Duration(milliseconds: 800);

  /// `anim-sign-on { animation: yuki-sign-on 0.9s steps(1, end) both }`
  /// (globals.css L2420–2422). The one duration on the page with no token
  /// anywhere near it.
  static const Duration signOn = Duration(milliseconds: 900);

  /// `anim-spin { animation: pulls-spin 0.9s linear infinite }`
  /// (globals.css L2407–2409) — the loading spinner, and the one animation in
  /// the system that is deliberately **not** eased. The utility's own comment
  /// (L2403–2406): *"`linear` on purpose: a spinner that eases is a spinner
  /// that looks like it is struggling."*
  ///
  /// Numerically equal to [signOn] and spelled separately for the same reason
  /// [popIn] is not [reward]: `yuki-sign-on` is a neon power-up on text and
  /// `pulls-spin` is a rotation on a glyph. Retiming one must not retime the
  /// other.
  static const Duration spin = Duration(milliseconds: 900);

  /// `anim-caret { animation: pulls-caret 1s steps(1, end) infinite }`
  /// (globals.css L2412–2414) — the OTP field's fake caret, a square wave:
  /// half the cycle lit, half dark, hard cut.
  ///
  /// Numerically equal to [bloom] (`--duration-bloom`) and spelled separately:
  /// the reference writes `1s` inline here, and the utility's comment records
  /// why it stopped borrowing a stock duration at all (L2410–2411) — *"Was
  /// tw-animate-css's `animate-caret-blink` paired with a stock
  /// `duration-1000`, so neither its rhythm nor its timing followed the
  /// system."*
  static const Duration caret = Duration(milliseconds: 1000);

  /// `anim-check-draw { stroke-dasharray: 22; animation: check-draw 280ms
  /// var(--ease-out) both }` (globals.css L2243–2246) — the checkbox tick
  /// drawing itself along its own 22-unit dash.
  static const Duration checkDraw = Duration(milliseconds: 280);

  /// `anim-dash-draw { stroke-dasharray: 12; animation: dash-draw 200ms
  /// var(--ease-out) both }` (globals.css L2247–2250) — the checkbox's
  /// indeterminate bar. Shorter than [checkDraw] because the stroke is shorter:
  /// 12 units against 22.
  static const Duration dashDraw = Duration(milliseconds: 200);

  /// `anim-dot-pop { animation: dot-pop 320ms var(--ease-spring) both }`
  /// (globals.css L2251–2253) — the radio dot arriving.
  ///
  /// Numerically equal to [overlay] (`--duration-overlay`) and spelled
  /// separately: the reference writes `320ms` inline on the utility rather than
  /// reading the token, so a retimed overlay must not move the dot.
  static const Duration dotPop = Duration(milliseconds: 320);

  /// `anim-ratchet { animation: yuki-ratchet 1.4s steps(8) infinite }`
  /// (globals.css L2416–2418).
  static const Duration ratchet = Duration(milliseconds: 1400);

  /// One of [ratchet]'s eight held positions — `steps(8)` divides the cycle
  /// into eight 175ms holds of 45° each (motion-map §6.3).
  ///
  /// Derived rather than typed: the reference never writes 175ms, it writes
  /// `1.4s` and `steps(8)`, and a change to either has to carry.
  static final Duration ratchetStep = Duration(
    microseconds: ratchet.inMicroseconds ~/ 8,
  );

  /// `anim-shimmer { … animation: pulls-shimmer 1.4s var(--ease-in-out)
  /// infinite }` (globals.css L2344–2353).
  ///
  /// Equal to [ratchet] by coincidence — a skeleton sweep and a mechanical
  /// spin are unrelated, and the reference states each separately.
  static const Duration shimmer = Duration(milliseconds: 1400);

  /// `anim-pulse-live { animation: pulls-pulse-live 2s var(--ease-in-out)
  /// infinite }` (globals.css L2354–2356) — *"the only animation allowed to
  /// run forever, and only on the live indicator"*.
  static const Duration pulseLive = Duration(seconds: 2);

  // ── The interaction utilities' own literals ────────────────────────────

  /// `press-spring { transition: transform 0.22s var(--ease-spring) }`
  /// (globals.css L2296–2303).
  ///
  /// DOCUMENTED DRIFT (motion-map D2): the motion page's own description
  /// promises *"40ms down, 250ms spring back"* for the whole family, and this
  /// utility releases in **220ms** — a raw `0.22s` that is not on the
  /// `--duration-*` scale at all. Both sides ship: the copy as written, the
  /// utility at its real number.
  static const Duration pressSpringUp = Duration(milliseconds: 220);

  // ── The effect layers' own literals ─────────────────────────────────────
  // `sheen-action` and `foil-value` time their pseudo-element animations
  // inline (shadows-map §5.3–5.4). Five values, none on the scale.

  /// `sheen-action:hover ::before { animation: action-beat 2.6s
  /// var(--ease-out) infinite }` — globals.css L2059–2160 (`@keyframes
  /// action-beat` at L2059–2088).
  ///
  /// 1196ms of the 2600ms cycle is dead rest: a double thump, then silence.
  static const Duration beatHover = Duration(milliseconds: 2600);

  /// `sheen-action:active ::before { animation: action-beat 620ms
  /// var(--ease-out) 1 }` — the same keyframes, once, at 23.8% of the hover
  /// cycle's length (globals.css L2059–2160).
  static const Duration beatPress = Duration(milliseconds: 620);

  /// `foil-value::after { animation: value-foil-drift 11s linear infinite }`
  /// — globals.css L1915–2040 (`@keyframes value-foil-drift` at L1915–1928).
  static const Duration foilDrift = Duration(seconds: 11);

  /// `foil-value::before { animation: value-glint 5.5s var(--ease-in-out)
  /// infinite }` — globals.css L1915–2040 (`@keyframes value-glint` at
  /// L1930–1946).
  ///
  /// It idles for the first 54% of the cycle, then one bright band crosses
  /// right to left.
  static const Duration glint = Duration(milliseconds: 5500);

  /// `foil-value:hover::before { animation-duration: 2.4s }` — the same
  /// glint, sped up on hover (globals.css L1915–2040).
  static const Duration glintHover = Duration(milliseconds: 2400);
}

/// The transform amounts the interaction utilities animate **to** —
/// globals.css L2277–2330.
///
/// Geometry rather than timing, but it belongs to the same utilities as
/// [DsDurations.pressDown] and is a token by the same argument: a press that
/// is 0.94 on one surface and 0.95 on another is drift, not design.
class DsTransforms {
  const DsTransforms._();

  /// `press` `:active { transform: scale(0.94) }` (L2281). The default squish
  /// for anything clickable that is not a `Button`.
  static const double pressScale = 0.94;

  /// `click-spring` `:active { transform: scale(0.9) }` (L2291).
  static const double clickSpringScale = 0.9;

  /// `press-spring` `:active { transform: scale(0.92) }` (L2300) — same feel,
  /// less travel, *"for larger surfaces where 0.9 would look comical"*.
  static const double pressSpringScale = 0.92;

  /// `Button`'s own `active:not-aria-[haspopup]:scale-95`
  /// (`components/ui/button.tsx`) — Tailwind `scale-95` = 0.95.
  ///
  /// A button squishes less than a bare `press` surface because it already
  /// travels: `--shadow-btn` swaps to `--shadow-btn-down` in the same beat.
  static const double buttonScale = 0.95;

  /// `lift` `:hover { transform: translateY(-3px) }` (L2327).
  static const double liftY = -3;

  /// `press-key` `:active { transform: translateY(3px) }` (L2315) — the key
  /// travelling into its socket.
  static const double keyDownY = 3;

  /// `swap-roll` `transform: translateY(calc(var(--swap-offset) * 160%))`
  /// (globals.css L2265–2271) — one step of the IconSwap wheel, as a fraction
  /// of the strip cell's **own** height.
  ///
  /// A percentage translate resolves against the translated box, and every
  /// strip cell is `place-items-center` around a single glyph, so the step is
  /// 1.6 × the glyph — 25.6px at 16px, 32px at 20px — not 1.6 × the clip
  /// window. Overshooting the cell by 60% is what makes the strip read as a
  /// wheel rather than a list: the leaver is fully clear before the arriver
  /// reaches centre.
  static const double swapRollTravel = 1.6;
}

/// Every `--ease-*` token, as Flutter [Cubic] curves.
///
/// The CSS names map one-to-one; only `--ease-in` is renamed ([curveIn]),
/// because `in` is a reserved-ish identifier in Dart call sites.
class DsCurves {
  const DsCurves._();

  /// `--ease-spring: cubic-bezier(0.34, 1.56, 0.64, 1)` (L420) —
  /// overshoot + settle.
  static const Cubic spring = Cubic(0.34, 1.56, 0.64, 1);

  /// `--ease-out: cubic-bezier(0.22, 1, 0.36, 1)` (L421).
  ///
  /// Also `--default-transition-timing-function` (L396): the system default.
  static const Cubic out = Cubic(0.22, 1, 0.36, 1);

  /// `--ease-in: cubic-bezier(0.7, 0, 0.84, 0)` (L428) — the accelerating
  /// exit. Deliberately NOT Tailwind's gentler `cubic-bezier(0.4, 0, 1, 1)`.
  static const Cubic curveIn = Cubic(0.7, 0, 0.84, 0);

  /// `--ease-in-out: cubic-bezier(0.65, 0, 0.35, 1)` (L429).
  static const Cubic inOut = Cubic(0.65, 0, 0.35, 1);

  /// `--ease-settle: cubic-bezier(0.16, 1, 0.3, 1)` (L431) — long travel,
  /// lands soft.
  static const Cubic settle = Cubic(0.16, 1, 0.3, 1);

  /// `--ease-standard: cubic-bezier(0.4, 0, 0.2, 1)` (L432).
  static const Cubic standard = Cubic(0.4, 0, 0.2, 1);

  /// `--ease-out-flex: cubic-bezier(0.05, 0.6, 0.4, 0.9)` (L430).
  static const Cubic outFlex = Cubic(0.05, 0.6, 0.4, 0.9);

  /// All seven easings, in the order globals.css **declares** them:
  /// `spring` L420, `out` L421, `curveIn` L428, `inOut` L429, `outFlex` L430,
  /// `settle` L431, `standard` L432.
  ///
  /// That is deliberately **not this class's own field order**, which puts
  /// [outFlex] last rather than fifth. The two orders disagreeing is the
  /// whole reason this list is stated explicitly instead of being derived:
  /// the fields are grouped by how often they are reached for, the list is a
  /// transcript. Indexes into [all] are therefore stable against a field
  /// being moved — do not reorder it to match the fields.
  static const List<Cubic> all = <Cubic>[
    spring,
    out,
    curveIn,
    inOut,
    outFlex,
    settle,
    standard,
  ];
}
