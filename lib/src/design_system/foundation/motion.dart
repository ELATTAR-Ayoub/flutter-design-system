/// The motion scale. Seven steps for everything that arrives, leaves, opens
/// or presses; one constant per looping animation and per surface; and the
/// behaviour timers (delays, lifetimes, tick intervals) that are not
/// animations at all. Mirrors `styles/motion.css` in the web design system —
/// same names, same numbers.
library;

import 'package:flutter/animation.dart';

/// Every duration on the scale, plus the behaviour timers that ride beside
/// it.
///
/// The scale's own thesis: `tick` is the machine beat — a press registers
/// instantly and springs back over `normal`. That asymmetry, instant in,
/// springy out, is the whole feel.
class MotionDurations {
  const MotionDurations._();

  /// The press-down beat — how quickly a press registers.
  static const Duration tick = Duration(milliseconds: 80);

  /// The quick step: small, low-stakes state changes.
  static const Duration fast = Duration(milliseconds: 150);

  /// The default transition duration — most things move at this speed.
  static const Duration normal = Duration(milliseconds: 250);

  /// The slow step — a larger or more deliberate change.
  static const Duration slow = Duration(milliseconds: 400);

  /// Every overlay's enter and exit.
  static const Duration overlayEnter = Duration(milliseconds: 320);

  /// How long an overlay takes to open. Longer than [overlayEnter] because
  /// [MotionCurves.emphasized] spends its last stretch settling an
  /// overshoot.
  static const Duration open = Duration(milliseconds: 420);

  // ── third-party timings, measured rather than declared ───────────────────
  // The drawer's overlay takes its clock from a library rather than from the
  // motion scale. Its number lives here for the same reason the other
  // third-party durations below do: a duration in a component file is a
  // literal the guard scans, and a duration nobody can point at a source for
  // is a guess.

  /// **vaul**'s drawer, enter and exit.
  ///
  /// `overlayEnter` does not reach it: vaul ships its own keyframes and its
  /// own stylesheet, so the drawer is the one overlay in the system that is
  /// visibly slower than its neighbours — deliberately.
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

  /// Radix `MenuSubTrigger`'s own submenu-open timer —
  /// `window.setTimeout(open, 100)` on `pointermove`, cleared on
  /// `pointerleave`. A dependency's own timer, not a `--duration-*` token —
  /// the same standing as [selectAutoScrollTick].
  static const Duration menuSubOpenDelay = Duration(milliseconds: 100);

  /// Radix `useTypeaheadSearch`'s idle-buffer reset — how long the menu's
  /// typeahead search debounces before it forgets what was typed.
  static const Duration menuTypeaheadReset = Duration(milliseconds: 1000);

  /// Radix `NavigationMenu`'s `delayDuration` — the hover-open delay before a
  /// panel opens. Measured on the live reference: a first hover opened the
  /// panel 281ms after the pointer landed, against a ~230–280ms expectation
  /// once measurement latency is allowed for.
  static const Duration navigationMenuOpenDelay = Duration(milliseconds: 200);

  /// Radix `NavigationMenu`'s own close timer — how long a panel stays open
  /// after the pointer leaves. Measured at ~186ms from a real `pointerleave`,
  /// which is this plus the sampler's slop.
  static const Duration navigationMenuCloseDelay = Duration(milliseconds: 150);

  /// Radix `NavigationMenu`'s `skipDelayDuration` — the window after a panel
  /// closes during which the **next** trigger opens with no delay at all.
  static const Duration navigationMenuSkipDelay = Duration(milliseconds: 300);

  /// Radix `ScrollArea`'s `scrollHideDelay` default. Measured between 542ms
  /// and 650ms. Not on the motion scale — nothing else in the system waits
  /// this long.
  static const Duration scrollAreaHideDelay = Duration(milliseconds: 600);

  /// Radix `Select`'s own auto-scroll interval —
  /// `window.setInterval(onAutoScroll, 50)` while a scroll button is
  /// hovered; each tick scrolls the viewport by one item's height.
  static const Duration selectAutoScrollTick = Duration(milliseconds: 50);

  /// sonner's `TOAST_LIFETIME` — how long a toast stays on screen before it
  /// auto-dismisses.
  static const Duration toastLifetime = Duration(seconds: 4);

  /// sonner's `TIME_BEFORE_UNMOUNT` — how long a dismissed toast stays in the
  /// tree after it has been told to go.
  ///
  /// Shorter than every exit transition it fires alongside, which is not a
  /// mistake: sonner's own comment calls it *"Equal to exit animation
  /// duration"* and it is equal to only one of the four. The visible
  /// consequence is that every exit is cut off partway.
  static const Duration toastUnmountDelay = Duration(milliseconds: 200);

  /// `transition: transform 400ms, opacity 400ms, height 400ms` — the window
  /// almost every leg of sonner's toast choreography runs in.
  ///
  /// Numerically equal to [slow] and deliberately not spelled as it: this is
  /// a third-party stylesheet's own literal, and retiming the design
  /// system's slow window must not retime a foreign component.
  static const Duration toastTransition = Duration(milliseconds: 400);

  /// sonner: `[data-removed][data-front=false][data-expanded=false] {
  /// transition: transform 500ms, opacity 200ms }` — the transform half of
  /// the one exit that does not use [toastTransition]. Its opacity half is
  /// [toastUnmountDelay]'s number.
  static const Duration toastCollapsedExitTransform = Duration(
    milliseconds: 500,
  );

  /// sonner: `animation-duration: 200ms` on the four `swipe-out-*`
  /// keyframes.
  static const Duration toastSwipeOutDuration = Duration(milliseconds: 200);

  /// sonner: `[data-promise=true] [data-icon] > svg { animation:
  /// sonner-fade-in 300ms ease forwards }` — the settled glyph arriving over
  /// the loader it replaces.
  static const Duration toastPromiseSwapIn = Duration(milliseconds: 300);

  /// `AttachmentStatusText`'s `--shimmer-duration: 2s` — the shimmer sweep
  /// period on the attachment's status line.
  ///
  /// Numerically close to but distinct from [shimmer] (1400ms) and
  /// [shimmerText] (2600ms): a third component's own measured period, not
  /// either of those two.
  static const Duration attachmentStatusShimmer = Duration(seconds: 2);

  /// `window.setTimeout(() => setSaving(false), 1600)` — how long
  /// `AttachmentAction`'s glyph stays on the check after a save is started
  /// (`attachment.tsx` L328).
  ///
  /// A library-shaped literal rather than a token: it is written inline in
  /// the component, the way sonner's own numbers are, and it is here for the
  /// same reason — a duration in a component file is a literal the guard
  /// scans, and one nobody can point at a source for is a guess.
  static const Duration attachmentSaving = Duration(milliseconds: 1600);

  /// Ambient, not interactive — a slow bloom on something that is not being
  /// acted on.
  static const Duration bloom = Duration(milliseconds: 1000);

  /// The starfield's slow sway.
  static const Duration sway = Duration(seconds: 44);

  /// The starfield's other layer. Deliberately not a multiple of [sway]:
  /// sways that share a period re-sync and the field reads as one rigid
  /// sheet.
  static const Duration swayAlt = Duration(seconds: 33);

  // ── the feedback surface's two drifts ───────────────────────────────────
  // 18 and 11 are coprime-ish on purpose, so the two layers take minutes to
  // return to the same arrangement and the surface never reads as one rigid
  // sheet — the same argument [swayAlt] carries, one layer down.

  /// The feedback surface's deeper field, the one that reads as distance.
  static const Duration cosmicDriftDeep = Duration(seconds: 18);

  /// The feedback surface's nearer field, tighter and brighter.
  ///
  /// Numerically equal to [foilDrift] and spelled separately: one is a metal
  /// sheen on a button, the other a corner light on a card. They agree today
  /// by accident, and retiming one must not retime the other.
  static const Duration cosmicDriftNear = Duration(seconds: 11);

  /// The down-stroke of the click feel — how quickly a press registers.
  ///
  /// The asymmetry is the point: fast down, slower spring back on
  /// [pressOut].
  static const Duration pressIn = Duration(milliseconds: 40);

  /// The spring back after a press releases.
  static const Duration pressOut = Duration(milliseconds: 250);

  /// The arrival replay of a travelling pill — a value settling into its new
  /// state.
  static const Duration stateChange = Duration(milliseconds: 600);

  /// The loading spinner's rotation — the one animation in the system that
  /// is deliberately **not** eased: a spinner that eases is a spinner that
  /// looks like it is struggling. Runs on `Curves.linear`, not a
  /// [MotionCurves] member.
  static const Duration spin = Duration(milliseconds: 900);

  /// The OTP field's fake caret, a square wave: half the cycle lit, half
  /// dark, hard cut.
  static const Duration caret = Duration(milliseconds: 1000);

  /// The skeleton sweep across a loading surface.
  static const Duration shimmer = Duration(milliseconds: 1400);

  /// The agent's status line while it works — the same sweep as [shimmer],
  /// at nearly twice the period, because a status line is a sentence and
  /// does not hurry the way a placeholder skeleton does.
  static const Duration shimmerText = Duration(milliseconds: 2600);

  /// The only animation allowed to run forever, and only on the live
  /// indicator.
  static const Duration pulseLive = Duration(seconds: 2);

  /// The hover pulse under a premium button surface.
  ///
  /// 1196ms of the 2600ms cycle is dead rest: a double thump, then silence.
  static const Duration beatHover = Duration(milliseconds: 2600);

  /// The same pulse, once, on press — shorter than [beatHover] because it
  /// plays through a single beat rather than looping.
  static const Duration beatPress = Duration(milliseconds: 620);

  /// The premium surface's metal-sheen sweep.
  static const Duration foilDrift = Duration(seconds: 11);

  /// The premium surface's glint — it idles for the first 54% of the cycle,
  /// then one bright band crosses right to left.
  static const Duration glint = Duration(milliseconds: 5500);

  /// The same glint, sped up on hover.
  static const Duration glintHover = Duration(milliseconds: 2400);
}

/// The transform amounts the interaction utilities animate **to**.
///
/// Geometry rather than timing, but it belongs to the same utilities as
/// [MotionDurations.pressIn] and is a token by the same argument: a press
/// that is one scale on one surface and another elsewhere is drift, not
/// design.
class MotionTransforms {
  const MotionTransforms._();

  /// The one click feel: anything pressed shrinks to this and springs back.
  static const double press = 0.9;

  /// `swap-roll` — the IconSwap wheel moves each icon this fraction of its
  /// own height per step.
  static const double swapRollTravel = 1.6;
}

/// Every easing on the scale, as Flutter [Cubic] curves.
class MotionCurves {
  const MotionCurves._();

  /// Overshoot + settle — the spring feel.
  static const Cubic emphasized = Cubic(0.34, 1.56, 0.64, 1);

  /// The system default: something arriving decelerates into place.
  static const Cubic enter = Cubic(0.22, 1, 0.36, 1);

  /// The accelerating exit — something leaving speeds up as it goes.
  static const Cubic exit = Cubic(0.7, 0, 0.84, 0);

  /// The symmetric ease for things that move without arriving or leaving.
  static const Cubic move = Cubic(0.65, 0, 0.35, 1);

  /// Long travel, lands soft.
  static const Cubic settle = Cubic(0.16, 1, 0.3, 1);

  /// The standard Material-shaped ease.
  static const Cubic standard = Cubic(0.4, 0, 0.2, 1);

  /// A flexible, slightly floaty out-ease.
  static const Cubic outFlex = Cubic(0.05, 0.6, 0.4, 0.9);

  /// All seven easings.
  ///
  /// Deliberately **not this class's own field order**, which puts [outFlex]
  /// last rather than fifth. The two orders disagreeing is the whole reason
  /// this list is stated explicitly instead of being derived: the fields are
  /// grouped by how often they are reached for, the list is a transcript.
  /// Indexes into [all] are therefore stable against a field being moved — do
  /// not reorder it to match the fields.
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
