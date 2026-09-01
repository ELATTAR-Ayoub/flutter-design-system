/// Motion tokens — a transcript of the reference's timing layer.
///
/// Source of truth: `design-system/app/globals.css` L395–432.
/// This file is inside `lib/src/design_system/foundation/`, the one place literals live.
library;

import 'package:flutter/animation.dart';

/// Every `--duration-*` token.
///
/// The scale's own thesis (globals.css L390–391): *"`tick` is the machine
/// beat: a press registers in 80ms, then springs back over `base`. That
/// asymmetry — instant in, springy out — is the whole feel."*
class MotionDurations {
  const MotionDurations._();

  /// `--duration-tick: 80ms` (L398) — the press-down beat.
  static const Duration tick = Duration(milliseconds: 80);

  /// `--duration-fast: 150ms` (L399).
  static const Duration fast = Duration(milliseconds: 150);

  /// `--duration-base: 250ms` (L400).
  ///
  /// Spell this token only where the reference reads `var(--duration-base)`
  /// **directly** — the `btn-spring`, `lift`, `press`, `click-spring` and
  /// `slide-pill` `@utility` blocks, and the `anim-*` keyframes. Where the
  /// reference writes a `duration-base` **utility class** the value that
  /// actually applies is [transitionDefault], which is a different declaration
  /// that happens to carry the same number.
  static const Duration normal = Duration(milliseconds: 250);

  /// `--default-transition-duration: 250ms` (globals.css L395) — the duration
  /// every `transition-*` utility in the reference actually runs at.
  ///
  /// **Tailwind v4 has no `--duration-*` theme namespace.** The `--duration-*`
  /// customs above are declared and are read by hand-written `@utility` blocks,
  /// component classes and keyframes, but they generate no `duration-*`
  /// utility. The only `.duration-*` selectors in the built stylesheet are
  /// `.duration-200` and `.duration-400`, and nothing in the reference uses
  /// either. So `duration-fast` / `duration-base` / `duration-tick` in a
  /// `className` **emit no CSS at all**: `--tw-duration` is never set, and every
  /// `transition-*` utility falls through the second half of
  /// `var(--tw-duration, var(--default-transition-duration))` to land here.
  /// globals.css L392–394 points the framework default at `--duration-base` to
  /// stop a `duration-*` class beating it — a precaution against a class that
  /// cannot be generated.
  ///
  /// Probed on the live reference at `localhost:3000`, 1440 × 900, 2026-08-15.
  /// `getComputedStyle(space).transitionDuration` reads **0.25s** on every element
  /// whose class list names a duration token: checkbox, radio item, switch
  /// track, switch thumb, slider thumb, the withdrawal option card, `Input`,
  /// `Textarea`, `InputGroup`, `Item`, tabs trigger, the navigation-menu
  /// chevron, both `Nav` link levels, the theme-toggle option, and the
  /// index-card chevron. The control group confirms the mechanism rather than
  /// the number: `:where(.prose) a` and `slide-pill`'s opacity leg read
  /// `var(--duration-fast)` directly and report **0.15s** on the same pages.
  ///
  /// Numerically equal to [base] and spelled separately for the same reason
  /// [popIn] is not [reward]: two declarations that agree today. A retune of
  /// `--duration-base` moves the `@utility` blocks and leaves every
  /// `transition-*` utility exactly where it stands.
  /// `--duration-slow: 400ms` (L401).
  static const Duration slow = Duration(milliseconds: 400);

  /// `--duration-overlay: 320ms` (L402) — every overlay enter/exit.
  static const Duration overlayEnter = Duration(milliseconds: 320);

  static const Duration overlayExit = Duration(milliseconds: 320);

  /// `--duration-jelly: 420ms` (L406). Longer than [overlay] because
  /// [MotionCurves.emphasized] spends its last stretch settling an overshoot.
  static const Duration open = Duration(milliseconds: 420);

  static const Duration close = Duration(milliseconds: 250);

  static const Duration expand = Duration(milliseconds: 420);

  static const Duration collapse = Duration(milliseconds: 250);

  /// `--duration-reward: 550ms` (L407).
  static const Duration reward = Duration(milliseconds: 550);

  // ── third-party timings, measured rather than declared ───────────────────
  // Three overlays on the dialogs page take their clock from a library rather
  // than from globals.css. Their numbers live here for the same reason
  // sonner's do: a duration in a component file is a literal the guard scans,
  // and a duration nobody can point at a source for is a guess.

  /// **vaul**'s drawer, enter and exit — measured 500ms on the live reference
  /// (2026-08-16), on [MotionCurves.vaul].
  ///
  /// `--duration-overlay` does not reach it: vaul ships its own `fadeIn` /
  /// `slideFromBottom` keyframes and its own stylesheet, and the
  /// `[class*="animate-in"]` bridge that retimes every Radix overlay never
  /// matches them. So the drawer is the one overlay in the system that is
  /// visibly slower than its neighbours — recorded, reproduced.
  static const Duration drawerOpen = Duration(milliseconds: 500);

  static const Duration drawerClose = Duration(milliseconds: 500);

  /// `TooltipProvider delayDuration={200}` (`app/layout.tsx` L38) — the whole
  /// system's hover-open delay, *"set once on the provider in the root layout
  /// so timing cannot vary between screens"*.
  ///
  /// Measured: the tooltip's first frame lands 232.5ms after the pointer
  /// enters, which is 200 plus a rAF and a paint.
  static const Duration tooltipShowDelay = Duration(milliseconds: 200);

  /// Radix `HoverCard`'s `openDelay` default — measured 728.3ms from pointer
  /// entry to first frame. The reference passes no override.
  static const Duration hoverCardShowDelay = Duration(milliseconds: 700);

  /// Radix `HoverCard`'s `closeDelay` default — measured 329.3ms from the
  /// pointer leaving to `data-state="closed"`.
  static const Duration hoverCardHideDelay = Duration(milliseconds: 300);

  /// `window.setTimeout(() => setSaving(false), 1600)` — how long
  /// `AttachmentAction`'s glyph stays on the check after a save is started
  /// (`attachment.tsx` L328).
  ///
  /// A library-shaped literal rather than a token: it is written inline in
  /// the component, the way sonner's own numbers are, and it is here for the
  /// same reason — a duration in a component file is a literal the guard
  /// scans, and one nobody can point at a source for is a guess.
  static const Duration attachmentSaving = Duration(milliseconds: 1600);

  /// One 60 Hz frame — the unit **Chrome's programmatic smooth scroll**
  /// measures its own duration in.
  ///
  /// `MessageScrollerButton` calls `scrollTo({behavior: "smooth"})` and the
  /// browser, not the stylesheet, picks the timing. It is not a constant:
  /// sampled on the chat page's scroller (`ba2-chat-scroll.js`,
  /// `ba2-chat-inter.js`, 1440×900, 2026-08-16) a **100px** jump settled in
  /// ~168ms and the full **398px** jump in ~335ms — a ratio of 1.99 for four
  /// times the distance, which is `√d` to within a frame. Dividing out gives
  /// **16.8 ms per √px**, one frame, so the port computes
  /// `frame × sqrt(distancePx)` rather than pinning either measurement.
  ///
  /// The shape runs on [MotionCurves.cssEase]; see
  /// `MessageScrollerController.scrollToEnd` for the residual that fit
  /// leaves.
  static const Duration frame = Duration(microseconds: 16667);

  /// `--duration-bloom: 1000ms` (L411) — ambient, not interactive.
  static const Duration bloom = Duration(milliseconds: 1000);

  /// `--duration-sway: 44s` (L417) — the starfield's slow sway.
  static const Duration sway = Duration(seconds: 44);

  /// `--duration-sway-alt: 33s` (L418). Deliberately not a multiple of
  /// [sway]: sways that share a period re-sync and the field reads as one
  /// rigid sheet.
  static const Duration swayAlt = Duration(seconds: 33);

  // ── `feedback-surface`'s two drifts ─────────────────────────────────────────
  // Neither is tokenised: `@utility feedback-surface` writes both inline
  // (globals.css L1759 / L1817), which is the same situation the `anim-*`
  // literals below are in. They are transcribed here anyway — the constraint
  // is that literals live in this layer, not that the reference named them.
  //
  // The utility's own comment (L1859–1860) says why the pair is what it is:
  // 18 and 11 are **coprime-ish on purpose**, so the two layers take minutes
  // to return to the same arrangement and the surface never reads as one
  // rigid sheet. That is the same argument [swayAlt] carries, one layer down.

  /// `animation: cosmic-drift-deep 18s var(--ease-in-out) infinite alternate`
  /// (globals.css L1759) — the `::before` field, the one that reads as
  /// distance.
  static const Duration cosmicDriftDeep = Duration(seconds: 18);

  /// `animation: cosmic-drift-near 11s var(--ease-in-out) infinite alternate`
  /// (globals.css L1817) — the `::after` field, tighter and brighter.
  ///
  /// Numerically equal to [foilDrift] and spelled separately for the reason
  /// [popIn] is not [reward]: `value-foil-drift` is a metal sheen on a button
  /// and `cosmic-drift-near` is a corner light on a card. They agree today by
  /// accident, and retiming one must not retime the other.
  static const Duration cosmicDriftNear = Duration(seconds: 11);

  // ── Durations globals.css writes as literals ────────────────────────────
  // Three utilities set a duration inline rather than through a `--duration-*`
  // token. They are transcribed here anyway: the constraint is that literals
  // live in this layer, not that the reference happened to name them.

  /// `press`/`click-spring`/`press-spring` `:active { transition-duration:
  /// 40ms }` (globals.css L2283 / L2292 / L2302).
  ///
  /// The down-stroke of the whole click feel. Its comment (L2276): *"The
  /// asymmetry is the point: 40ms down, 250ms spring back."*
  static const Duration pressIn = Duration(milliseconds: 40);

  static const Duration pressOut = Duration(milliseconds: 250);

  /// `anim-jelly { animation: yuki-jelly 0.6s var(--ease-out) both }`
  /// (globals.css L2366) — the arrival replay of a travelling pill.
  ///
  /// Deliberately NOT [jelly] (420ms): that token belongs to `anim-jelly-in`,
  /// the overlay entrance. The two are different animations that share a name
  /// stem, and collapsing them would slow every pill arrival by 43%.
  static const Duration stateChange = Duration(milliseconds: 600);

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

  /// `anim-shimmer-text { … animation: pulls-shimmer 2.6s var(--ease-in-out)
  /// infinite }` (globals.css L3051–3070) — the agent's status line while it
  /// works.
  ///
  /// The **same keyframes** as [shimmer], at nearly twice the period, and the
  /// utility's own comment says why the pair is not one number: *"A highlight
  /// travelling through live text… Clipped to the glyphs rather than painted
  /// behind them, so it reads as the words themselves being lit rather than as
  /// a loading bar."* A skeleton is a placeholder and hurries; a status line
  /// is a sentence and does not.
  ///
  /// Numerically equal to [beatHover] and spelled separately on [popIn]'s
  /// precedent: `action-beat` is a pulse under a button and this is a sweep
  /// across text.
  static const Duration shimmerText = Duration(milliseconds: 2600);

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
  // `action-feedback` and `premium-surface` time their pseudo-element animations
  // inline (shadows-map §5.3–5.4). Five values, none on the scale.

  /// `action-feedback:hover ::before { animation: action-beat 2.6s
  /// var(--ease-out) infinite }` — globals.css L2059–2160 (`@keyframes
  /// action-beat` at L2059–2088).
  ///
  /// 1196ms of the 2600ms cycle is dead rest: a double thump, then silence.
  static const Duration beatHover = Duration(milliseconds: 2600);

  /// `action-feedback:active ::before { animation: action-beat 620ms
  /// var(--ease-out) 1 }` — the same keyframes, once, at 23.8% of the hover
  /// cycle's length (globals.css L2059–2160).
  static const Duration beatPress = Duration(milliseconds: 620);

  /// `premium-surface::after { animation: value-foil-drift 11s linear infinite }`
  /// — globals.css L1915–2040 (`@keyframes value-foil-drift` at L1915–1928).
  static const Duration foilDrift = Duration(seconds: 11);

  /// `premium-surface::before { animation: value-glint 5.5s var(--ease-in-out)
  /// infinite }` — globals.css L1915–2040 (`@keyframes value-glint` at
  /// L1930–1946).
  ///
  /// It idles for the first 54% of the cycle, then one bright band crosses
  /// right to left.
  static const Duration glint = Duration(milliseconds: 5500);

  /// `premium-surface:hover::before { animation-duration: 2.4s }` — the same
  /// glint, sped up on hover (globals.css L1915–2040).
  static const Duration glintHover = Duration(milliseconds: 2400);
}

/// The transform amounts the interaction utilities animate **to** —
/// globals.css L2277–2330.
///
/// Geometry rather than timing, but it belongs to the same utilities as
/// [MotionDurations.pressIn] and is a token by the same argument: a press that
/// is 0.94 on one surface and 0.95 on another is drift, not design.
class MotionTransforms {
  const MotionTransforms._();

  /// `press` `:active { transform: scale(0.94) }` (L2281). The default squish
  /// for anything clickable that is not a `Button`.
  static const double press = 0.94;

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
  static const double buttonPress = 0.95;

  /// `Slider`'s thumb `hover:scale-110` (`components/ui/slider.tsx`) —
  /// Tailwind `scale-110` = 1.10.
  ///
  /// Recorded here for the same reason as [buttonScale]: a component's own
  /// stock-Tailwind scale utility is still a transform amount, and the one
  /// place transform amounts live is this class.
  ///
  /// **It arrives instantly.** The built stylesheet emits
  /// `.hover\:scale-110:hover { scale: var(--tw-scale-x) var(--tw-scale-y) }`
  /// — the CSS **`scale`** property, not `transform` — while the thumb's
  /// transition list is `transition-[transform,box-shadow]`. `scale` is not in
  /// that list, so nothing interpolates it. Driven on the live reference and
  /// rAF-sampled through a real pointer gesture (1440 × 900, 2026-08-15): the
  /// sampler saw `none → 1.1 → 1.25 → 1.1` with **zero** intermediate frames
  /// across ~100 samples. The ring beside it does tween, on
  /// [MotionCurves.emphasized] over [MotionDurations.normal].
  static const double sliderThumbHoverScale = 1.10;

  /// `Slider`'s thumb `active:scale-125` — Tailwind `scale-125` = 1.25.
  ///
  /// Its source comment: *"Grabbing it springs the knob up, like picking it
  /// out of the groove."* The spring named there reaches the ring only — see
  /// [sliderThumbHoverScale] for the measurement.
  static const double sliderThumbActiveScale = 1.25;

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
class MotionCurves {
  const MotionCurves._();

  /// `--ease-spring: cubic-bezier(0.34, 1.56, 0.64, 1)` (L420) —
  /// overshoot + settle.
  static const Cubic emphasized = Cubic(0.34, 1.56, 0.64, 1);

  /// `--ease-out: cubic-bezier(0.22, 1, 0.36, 1)` (L421).
  ///
  /// Also `--default-transition-timing-function` (L396): the system default.
  static const Cubic enter = Cubic(0.22, 1, 0.36, 1);

  /// `--ease-in: cubic-bezier(0.7, 0, 0.84, 0)` (L428) — the accelerating
  /// exit. Deliberately NOT Tailwind's gentler `cubic-bezier(0.4, 0, 1, 1)`.
  static const Cubic exit = Cubic(0.7, 0, 0.84, 0);

  /// `--ease-in-out: cubic-bezier(0.65, 0, 0.35, 1)` (L429).
  static const Cubic move = Cubic(0.65, 0, 0.35, 1);

  /// `--ease-settle: cubic-bezier(0.16, 1, 0.3, 1)` (L431) — long travel,
  /// lands soft.
  static const Cubic settle = Cubic(0.16, 1, 0.3, 1);

  /// `--ease-standard: cubic-bezier(0.4, 0, 0.2, 1)` (L432).
  static const Cubic standard = Cubic(0.4, 0, 0.2, 1);

  /// `--ease-out-flex: cubic-bezier(0.05, 0.6, 0.4, 0.9)` (L430).
  static const Cubic outFlex = Cubic(0.05, 0.6, 0.4, 0.9);

  /// CSS's own `linear` — `cubic-bezier(0, 0, 1, 1)`, i.e. no easing at all.
  ///
  /// **Not one of the system's easings and not on [all]**, on [cssEase]'s
  /// precedent: `globals.css` declares no `--ease-linear`, so `ease-linear` is
  /// Tailwind's own utility emitting the CSS keyword.
  ///
  /// It has exactly one consumer, and it is the app shell's most visible
  /// motion: `Sidebar`'s gap and container both carry
  /// `transition-[…] duration-base ease-linear`, so the panel's collapse is a
  /// **constant-rate** width change rather than an eased one. Measured on the
  /// live reference (1440 × 900, 2026-08-16, `sb-collapse.js`): 256 → 48 in
  /// even ~13.85px steps per 16.6ms frame, reaching 48 exactly 250ms after the
  /// state flip, with no front-loading and no overshoot at either end.
  ///
  /// Spelled as the identity [Cubic] rather than as the framework's own linear
  /// curve so that every easing in the port is one object type and one
  /// transcription of a CSS value.
  static const Cubic linear = Cubic(0, 0, 1, 1);

  /// CSS's own unnamed `ease` — `cubic-bezier(0.25, 0.1, 0.25, 1)`.
  ///
  /// **Not one of the system's easings, and deliberately not on [all].**
  /// It is here for exactly one reason: sonner's stylesheet
  /// (`node_modules/sonner/dist/styles.css` L89) writes
  /// `transition: transform 400ms, opacity 400ms, height 400ms, box-shadow
  /// 200ms` and names no timing function, so every leg of the toast
  /// choreography — enter, stack collapse, expand-on-hover, two of the three
  /// exits, the child fade, the container's own travel and the promise icon's
  /// swap — runs on the CSS initial value. A foreign library's default, on the
  /// same argument [Toaster.unmountDelay] carries: putting it on the system's
  /// motion scale would let a rebrand silently retime a third-party component,
  /// and snapping it to [standard] `(0.4, 0, 0.2, 1)` would retime every toast
  /// today.
  ///
  /// Verified against the live reference rather than assumed. rAF-sampled
  /// through a real toast entrance (1440 × 900, dark, 2026-08-16): opacity read
  /// 0.314 at 20.3% of the 400ms window, 0.645 at 38.3% and 0.9445 at 69.6% —
  /// which is this curve to within the sampler's own frame slop, and is not
  /// [standard], [out] or [inOut] at any of the three.
  ///
  /// Sonner's swipe-out is the one leg that names an easing, and it names
  /// `ease-out` — CSS's `cubic-bezier(0, 0, 0.58, 1)`, which is a *fourth*
  /// stock curve and not this system's [out]. See [cssEaseOut].
  static const Cubic cssEase = Cubic(0.25, 0.1, 0.25, 1);

  /// CSS's own `ease-out` — `cubic-bezier(0, 0, 0.58, 1)`.
  ///
  /// The companion to [cssEase], and here for the same one reason: sonner's
  /// `swipe-out-*` keyframes run `200ms ease-out forwards` (`styles.css`
  /// L356–358), and that `ease-out` is the CSS keyword, not `--ease-out`.
  /// Measured on a live downward swipe: transform and opacity both read 95.5%
  /// of their travel at 77.5% of the 200ms window, which is this curve and is
  /// visibly not [out] `(0.22, 1, 0.36, 1)` — that one is 99.7% done by the
  /// same instant.
  static const Cubic cssEaseOut = Cubic(0, 0, 0.58, 1);

  /// CSS's own `ease-in-out` — `cubic-bezier(0.42, 0, 0.58, 1)`.
  ///
  /// The third stock keyword, and here for the same reason as [cssEase] and
  /// [cssEaseOut]: `shadcn/tailwind.css`'s `scroll-fade-*` utilities write
  /// `animation: 1ms ease-in-out scroll-fade-reveal-b` and name the keyword,
  /// not `--ease-in-out`. The two are far apart — this one is much lazier in
  /// the middle — and the mask geometry is where it shows.
  ///
  /// Measured on the chat page's message scroller (`ba2-chat-scroll.js`,
  /// 1440×900, 2026-08-16): with the reveal 58.33% through its 96px range the
  /// mask's remaining fade read **0.3588** of full, and `1 - Y(0.5833)` on
  /// this curve is 0.3563; the system's own [inOut] `(0.65, 0, 0.35, 1)` would
  /// give 0.284 at the same point. Two more samples (75% → 0.1292, 87.5% →
  /// 0.0561) agree to within the sampler's slop.
  static const Cubic cssEaseInOut = Cubic(0.42, 0, 0.58, 1);

  /// **vaul**'s own easing — `cubic-bezier(0.32, 0.72, 0, 1)`.
  ///
  /// Read off the live drawer's computed `animation-timing-function`
  /// (2026-08-16). A fifth curve in the system and, like [cssEase] and
  /// [cssEaseOut], one this design system did not choose: it arrives with the
  /// library, applies to `fadeIn` and `slideFromBottom` alike, and is much
  /// flatter at the start than [out] — 50% of the travel is still 130ms away
  /// at 500ms total, where [out] would be past 90%.
  static const Cubic vaul = Cubic(0.32, 0.72, 0, 1);

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
    emphasized,
    enter,
    exit,
    move,
    outFlex,
    settle,
    standard,
  ];
}
