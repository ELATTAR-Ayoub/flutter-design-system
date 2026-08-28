/// `components/ui/sonner.tsx` + the `.cn-toast` block (`app/globals.css`
/// L2584–2812) + **sonner's own stylesheet** (`node_modules/sonner/dist/
/// styles.css`) — the toast surface, its host, and the choreography between
/// them.
///
/// The split the reference makes is the split kept here: sonner's `<Toaster/>`
/// is mounted **once** in the root layout (`app/layout.tsx:39`,
/// `position="bottom-right"`) and every page just calls `toast.success(…)`.
/// The Flutter analogue is a widget in the package and its mounting in the
/// example's shell — supervisor ruling F8 — so this file ships [Toaster] and
/// [ToastController] and mounts neither.
///
/// **Every visual decision lives in `.cn-toast`,** and the comment in
/// `sonner.tsx` says why: *"so the live toast and the Elattar preview share one
/// definition."*
///
/// | property | declaration | value |
/// |---|---|---|
/// | layout | `display: flex; align-items: flex-start` | icon beside content, both top-aligned |
/// | gap | `calc(var(--spacing) * 3)` | **12px** |
/// | width | `var(--width, 22.25rem)` | **356px** |
/// | padding | `calc(var(--spacing) * 4)` | **16px** |
/// | border | `1px solid var(--border)` | — |
/// | radius | `var(--radius-lg)` | 12px |
/// | fill | `background-color: var(--popover)` | *not* the `background` shorthand — the comment explains that the shorthand would reset `background-image` too |
/// | elevation | `box-shadow: var(--shadow-e3)` | — |
/// | type | `var(--text-small)` / `1.5` | 13px |
/// | clip | `overflow: hidden` | *"the bloom needs something to clip against"* |
/// | icon | `margin-top: calc(var(--spacing) * 0.5)`, 16px glyph | *"optically centres the glyph on the first line of the title"* |
/// | content | `flex-direction: column; gap: calc(var(--spacing) * 1)` | 4px |
/// | title | 13px / **500** / `--foreground` | — |
/// | description | 13px / `--muted-foreground` | — |
///
/// **The glyph's colour is the only colour a toast carries**, and it is always
/// an `-ink` token — see [ToastType.inkOf]. The bloom's two hues are the
/// only other thing `data-type` changes.
///
/// ## The choreography — supervisor ruling F4
///
/// `.cn-toast` says what a toast *looks* like; sonner's package stylesheet says
/// what it *does*, and none of it is in `globals.css`. All of the following was
/// transcribed from `styles.css` and then rAF-sampled on the live reference
/// (1440 × 900, dark, 2026-08-16) before being built:
///
///  * **Enter.** There is no `@keyframes` entrance. A toast mounts at
///    `translateY(100%)` (of its own box) and `opacity: 0`, and one frame later
///    `data-mounted="true"` flips it to `translateY(0)` / `opacity: 1`. The
///    transition it rides is `transform, opacity, height` over the slow window
///    on [MotionCurves.cssEase]. Sonner's own comment: *"Trigger enter animation
///    without using CSS animation."*
///  * **The collapsed stack.** Only the front toast is legible. Every toast
///    behind it is translated by the gap times its index, scaled `1 − 0.05n`,
///    has **its children at `opacity: 0`**, and — the part that forces a
///    measure-then-lay-out pass — has its **height pinned to the front toast's
///    measured height**. Measured, three deep: `scale(0.95) translateY(-14px)`
///    and `scale(0.9) translateY(-28px)`, both at `height: 93.875px` when the
///    front toast measured 93.875.
///
///    *"Only the front toast is legible"* is a statement about **paint order**
///    as much as about opacity. A pinned back toast is a full-height opaque
///    `--popover` plate sitting 14px off the front one, so `--z-index:
///    toasts.length - index` is load-bearing: paint the stack the other way up
///    and the oldest blank plate covers the front toast's title outright.
///  * **Expand on hover.** Hovering the stack lifts every toast to its own
///    `--offset` (`n × gap + Σ heights before it`), returns it to `scale(1)`
///    and to its own natural height, and fades its children back in. Measured:
///    `translateY(-107.875px)` at `height: 75.6875px` for the second of three.
///  * **Three exits.** The front leaves the way it came in
///    (`translateY(100%)`, fade, slow window). A back toast leaves *upward
///    through its expanded slot* while the stack is expanded. A back toast in a
///    **collapsed** stack does something else entirely — `translateY(40%)`,
///    scale released back to 1, over a **longer transform window than the
///    opacity window**, so it fades out well before it has finished falling.
///  * **Unmount is not the exit.** `TIME_BEFORE_UNMOUNT` is 200ms and every
///    exit transition is longer than that, so the node is torn out mid-flight
///    and you only ever see the first stretch of any of them. Measured on the
///    front exit: the last frame before unmount read `opacity: 0.35`.
///  * **Swipe.** Threshold 45px or velocity above 0.11 px/ms. Travel in the
///    corner's own two directions is 1:1; against them it is dampened by
///    `1 / (1.5 + |delta| / 20)`. Released past the threshold the toast
///    animates out by a further 100% on the swiped axis over the short window
///    on [MotionCurves.cssEaseOut] — the one leg that names its easing. Released
///    short, it **snaps** back: `transition: none` is still in force.
///  * **Hover-pause is resume-from-remainder, not restart.** `pauseTimer`
///    subtracts the elapsed time and stores what is left. Measured: a toast
///    hovered from +1062ms to +3844ms unmounted at +6798ms — a restart would
///    have been +7700ms.
///
/// Reduced motion: sonner ships its **own** `prefers-reduced-motion` block that
/// kills `transition` and `animation` outright, where `globals.css` collapses
/// them to 0.01ms — two regimes that disagree (feedback-map drift 14). The port
/// has one switch, so it takes sonner's reading: under `effectiveMotionDuration`
/// zero every leg above lands on its **final frame immediately**, and the
/// clocks still run. Measured under `prefers-reduced-motion: reduce`: the toast
/// appears already at `matrix(1,0,0,1,0,0)` / `opacity: 1` and still expires on
/// its own 4000ms lifetime.
///
/// **Runtime contract**, from sonner's own constants rather than from its CSS:
/// [visibleLimit] 3, [lifetime] 4000ms, [gap] 14px, [viewportOffset] 24px,
/// [width] 356px, [swipeThreshold] 45px, and 200ms between a dismissal and the
/// unmount. Newest sits closest to the corner; anything past the third waits
/// its turn.
///
/// ## The compact anchor — the one ordered departure
///
/// At or below [Toaster.mobileBreakpoint] the stack anchors to the **top** of
/// the screen. That is a user order, and it is the only place this file
/// knowingly leaves the reference: sonner's mobile block reskins whichever
/// y-position is already set and never moves it, and the app mounts
/// `position="bottom-right"` as a literal, so **the reference's own phone
/// behaviour is a bottom stack**. Everything else in that block is adopted
/// verbatim — the 600px breakpoint, the 16px edge inset, the full-bleed width.
/// [Toaster]'s class doc carries the measurement and the reasoning.
///
/// The second ordered departure is the same order's consequence: 16px from the
/// top of a **phone** is 16px into the status bar, so the anchored edge pays
/// [MediaQueryData.padding] on top of sonner's inset — [Toaster.paddingFor],
/// and the corpus-wide ruling [SafeArea] states. sonner has no counterpart:
/// `styles.css` never spells `env(safe-area-inset-*)`, because a desktop
/// browser has no bar to clear.
///
/// Recorded rather than guessed, and still open:
///  * `[data-button]` — the action pill (`variant="secondary" size="sm"` by
///    hand, 32px on a pill). The live error toast on the `feedback` page has
///    one. It is not choreography and has no owner yet; feedback-map §15.2 #8.
///  * **The queue, not sonner's overflow.** Sonner mounts *every* toast and
///    hides the ones past the third with `data-visible="false"`, so their
///    4000ms clocks run while they are invisible. This port renders the newest
///    three and holds the rest back with their clocks **unstarted**, which is
///    the shipped, tested contract and the kinder of the two. Same three toasts
///    on screen either way.
///  * The loading glyph does **not** spin. `sonner.tsx` hands sonner
///    `<Loader2Icon className="size-4"/>` with no `anim-spin`, and no
///    `.cn-toast` rule adds one, so the live loading toast holds still.
///    feedback-map §6.2's glyph column reads `Loader2Icon + anim-spin`; the
///    stylesheet and the live page both disagree with it.
///  * `.starfield` blanks with the rest of a collapsed back toast's children —
///    it hangs off `[data-content]`, which is one of the two elements the
///    `opacity: 0` rule catches — while the **bloom stays lit**, because its
///    two pseudo-elements are on the toast itself. Measured on a three-deep
///    stack: `contentOpacity: 0` with both bloom layers still at `opacity:
///    0.75` and still drifting. [FeedbackSurface.starfield] is therefore switched
///    off for a blanked toast; CSS *fades* those sparkles over the slow window
///    and this cuts them at the state flip, which is the one seam in the
///    collapse. The fade boundary sits inside `FeedbackSurface`, above this
///    file's reach.
library;

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart'
    hide
        AspectRatio,
        Icon,
        OverlayPortal,
        RichText,
        SafeArea,
        ScrollPosition,
        Table,
        TableColumnWidth;

import './feedback_surface.dart';
import './surface.dart';
import '../../design_system/foundation/colors.dart';
import '../../design_system/foundation/motion.dart';
import '../../design_system/foundation/shadows.dart';
import '../../design_system/foundation/spacing.dart';
import '../../design_system/foundation/theme.dart';
import '../../design_system/foundation/typography.dart';
import '../../design_system/foundation/theme_scope.dart';
import './safe_area.dart';
import './icon.dart';
import './icon_paths.dart';

/// `width: var(--width, 22.25rem)`.
const double _width = 356;

/// sonner's `GAP` — the space between two stacked toasts.
const double _gap = 14;

/// sonner's `VIEWPORT_OFFSET` — 24px from both edges of the corner it sits in.
const double _offset = 24;

/// sonner's `MOBILE_VIEWPORT_OFFSET` (`index.mjs` L415) — the inset every edge
/// of the viewport takes once the mobile block is in force. It replaces
/// [_offset] on all four sides at once, which is why one number covers both the
/// side insets and the distance from the anchored edge.
const double _mobileOffset = 16;

/// `@media (max-width: 600px)` (`styles.css` L425) — sonner's own and only
/// breakpoint, and the width at or below which [Toaster] goes compact.
///
/// A `max-width` media query is inclusive, so 600 itself is mobile.
const double _mobileBreakpoint = 600;

/// sonner's `VISIBLE_TOASTS_AMOUNT`.
const int _visible = 3;

/// sonner's `TOAST_LIFETIME`.
const Duration _lifetime = Duration(seconds: 4);

/// sonner's `SWIPE_THRESHOLD` — how far a drag must travel to dismiss.
const double _swipeThreshold = 45;

/// sonner's release velocity gate, in px **per millisecond**
/// (`index.mjs`: `velocity > 0.11`). Flutter reports drag velocity per second,
/// so the comparison is made against [_swipeVelocityPerSecond].
const double _swipeVelocity = 0.11;

/// [_swipeVelocity] in the units [DragEndDetails] speaks.
const double _swipeVelocityPerSecond = _swipeVelocity * 1000;

/// `--scale: var(--toasts-before) * 0.05 + 1`, substituted textually into
/// `scale(calc(-1 * var(--scale)))` and therefore resolving to `1 − 0.05n`
/// rather than to a negative scale. Verified on the live stack: the second
/// toast computes 0.95 and the third 0.90.
const double _stackScaleStep = 0.05;

/// `[data-removed][data-front=false][data-expanded=false] { --y:
/// translateY(40%) }` — how far a back toast in a collapsed stack falls. A
/// fraction of its own (pinned) box, not a length, and unsigned: it falls
/// downward from a bottom stack and from a top one alike.
const double _collapsedExitTravel = 0.40;

/// sonner's `TIME_BEFORE_UNMOUNT` — how long a dismissed toast stays in the
/// tree after it has been told to go.
///
/// It is numerically `--duration-dash-draw` and unrelated to it; putting it on
/// the duration scale would let a retimed checkbox retime the toast queue.
///
/// Shorter than every exit transition it fires alongside, which is not a
/// mistake: sonner's own comment calls it *"Equal to exit animation duration"*
/// and it is equal to only one of the four. The visible consequence is that
/// every exit is cut off partway.
const Duration _unmount = Duration(
  milliseconds: 200,
); // allow-hardcoded: sonner's TIME_BEFORE_UNMOUNT, a runtime constant, not a --duration-* token

/// `transition: transform 400ms, opacity 400ms, height 400ms` — the window
/// almost every leg of the choreography runs in.
///
/// Numerically `--duration-slow` and deliberately not spelled as it: this is a
/// third-party stylesheet's own literal, and retiming the design system's slow
/// window must not retime a foreign component. Same argument as [_unmount].
const Duration _transition = Duration(
  milliseconds: 400,
); // allow-hardcoded: sonner styles.css L89, a foreign runtime constant

/// `[data-removed][data-front=false][data-expanded=false] { transition:
/// transform 500ms, opacity 200ms }` — the transform half of the one exit that
/// does not use [_transition]. Its opacity half is [_unmount]'s number.
const Duration _collapsedExitTransform = Duration(
  milliseconds: 500,
); // allow-hardcoded: sonner styles.css L338, a foreign runtime constant

/// `animation-duration: 200ms; animation-timing-function: ease-out` on the four
/// `swipe-out-*` keyframes.
const Duration _swipeOutDuration = Duration(
  milliseconds: 200,
); // allow-hardcoded: sonner styles.css L356, a foreign runtime constant

/// `[data-promise=true] [data-icon] > svg { animation: sonner-fade-in 300ms
/// ease forwards }` — the settled glyph arriving over the loader it replaces.
const Duration _promiseSwapIn = Duration(
  milliseconds: 300,
); // allow-hardcoded: sonner styles.css L163, a foreign runtime constant

/// `.sonner-loader { transition: opacity 200ms, transform 200ms }` — the
/// loader leaving under it. Shorter than [_promiseSwapIn], so the two glyphs
/// cross rather than hand over.
const Duration _promiseSwapOut = _unmount;

/// `@keyframes sonner-fade-in { 0% { transform: scale(0.8) } }`, and the
/// mirrored rest state of `.sonner-loader[data-visible=false]`.
const double _promiseSwapScale = 0.8;

/// `[data-button]`'s box — `height: calc(var(--spacing) * 8)`.
const double _actionHeight = 32;

/// `padding-inline: calc(var(--spacing) * 3.5)`.
const double _actionPadding = 14;

/// The action a toast can carry — sonner's `toast(…, { action })`.
///
/// `[data-button]` is rendered by sonner itself, so it cannot be a real
/// [Button]; `.cn-toast`'s declarations mirror `variant="secondary"
/// size="sm"` by hand and the block's own comment says why it is **secondary
/// and not outline**: *"the bloom sits directly behind it, and a bordered
/// transparent control over moving light reads as a hole rather than a
/// button."*
///
/// Pressing it runs [onPressed] and then dismisses the toast, which is
/// sonner's own order (`index.mjs`: the handler first, `deleteToast()` after).
@immutable
class ToastAction {
  const ToastAction({required this.label, this.onPressed});

  final String label;
  final VoidCallback? onPressed;
}

/// `data-type` — the five sonner types, plus the untyped default.
enum ToastType {
  /// `data-type="success"` — `CircleCheck`, `--success-ink`, and a bloom of
  /// `--color-success` over `--color-value`.
  success,

  /// `data-type="info"` — `Info`, `--info-ink`.
  info,

  /// `data-type="warning"` — `TriangleAlert`, `--warning-ink`.
  warning,

  /// `data-type="error"` — `OctagonX`, `--destructive-ink`.
  error,

  /// `data-type="loading"` — `Loader2`, `--action-ink`.
  ///
  /// The one type with **no clock**: `index.mjs` returns before starting a
  /// timer whenever `toast.type === 'loading'`, so a loading toast sits there
  /// until something settles it. [ToastController.promise] is what settles
  /// it on this page.
  loading,

  /// No `data-type` at all: the glyph slot's own
  /// `color: var(--muted-foreground)` stands, and the bloom keeps the
  /// utility's default pair.
  normal;

  /// The key sonner spells this type with. [normal] has no attribute at all.
  String get label => this == ToastType.normal ? 'default' : name;

  /// The glyph slot's colour — *"always an `-ink` token"*.
  Color inkOf(ThemeTokens theme) => switch (this) {
    ToastType.success => theme.successText,
    ToastType.info => theme.infoText,
    ToastType.warning => theme.warningText,
    ToastType.error => theme.destructiveText,
    ToastType.loading => theme.actionText,
    ToastType.normal => theme.mutedForeground,
  };

  /// `TOAST_ICONS[type]` — `sonner.tsx` L18–24, complete.
  ///
  /// The `null` belongs to [normal] alone, and it is not a gap: `TOAST_ICONS`
  /// has no `default` key, `icons['default']` is `undefined`, and sonner's
  /// `getAsset('default')` answers nothing — so an untyped toast renders with
  /// no icon slot at all. [Toast.glyph] can still put one there, which is the
  /// call site's decision rather than the type's.
  IconGlyph? get glyph => switch (this) {
    ToastType.success => IconGlyph.circleCheck,
    ToastType.info => IconGlyph.info,
    ToastType.warning => IconGlyph.alertTriangle,
    ToastType.error => IconGlyph.octagonX,
    ToastType.loading => IconGlyph.loaderCircle,
    ToastType.normal => null,
  };
}

/// One queued toast.
@immutable
class ToastMessage {
  const ToastMessage({
    required this.title,
    this.description,
    this.type = ToastType.normal,
    this.glyph,
    this.duration = _lifetime,
    this.promise = false,
    this.action,
  });

  /// `[data-title]` — the only thing every toast on the forms page carries.
  final String title;

  /// `[data-description]`.
  final String? description;

  final ToastType type;

  /// Overrides [ToastType.glyph]. The types all carry their own geometry now,
  /// so this is for a call site that wants a different glyph on a typed toast —
  /// or any glyph at all on an untyped one.
  final IconGlyph? glyph;

  /// `TOAST_LIFETIME` unless the call site says otherwise. Ignored while
  /// [type] is [ToastType.loading], which has no clock.
  final Duration duration;

  /// `data-promise` — set for every state of a [ToastController.promise]
  /// toast, loading and settled alike. It is what turns the glyph swap into a
  /// cross-fade instead of a cut.
  final bool promise;

  /// `[data-button]` — the action pill, at the far right of the row. The
  /// `feedback` page's error toast carries a `Retry`.
  final ToastAction? action;

  /// The glyph this message actually paints.
  IconGlyph? get resolvedGlyph => glyph ?? type.glyph;
}

/// A live toast: an id, its message, and whether it is on its way out.
class _LiveToast {
  _LiveToast(this.id, this.message);

  final int id;

  /// Mutable: `toast.promise` swaps `loading → success | error` **in place**,
  /// on the same element, rather than dismissing one toast and firing another.
  ToastMessage message;

  bool leaving = false;

  /// `offsetBeforeRemove` — `deleteToast` freezes the toast's `--offset` at the
  /// instant it is removed, because it is dropped from `heights` in the same
  /// breath and would otherwise snap to whatever the survivors recompute.
  double? offsetBeforeRemove;

  /// The glyph the promise swap is crossing *from*, and a counter so a second
  /// swap on the same toast restarts the cross-fade.
  IconGlyph? swapFrom;
  int swapSeq = 0;

  /// Set by [Toaster] when a swipe carries this toast out, so the exit takes
  /// the `swipe-out-*` path instead of one of the three transitions.
  Offset? swipeOut;
}

/// `toast.success(…)` and friends — the queue behind a [Toaster].
///
/// Owned by whatever mounts the toaster, so a page can hold one and fire into
/// it, exactly as `toast` is a module-level singleton on the web.
class ToastController extends ChangeNotifier {
  final List<_LiveToast> _toasts = <_LiveToast>[];
  int _nextId = 0;

  /// Every toast currently in the tree, oldest first. At most [_visible] of
  /// them are on screen; the rest are queued.
  @visibleForTesting
  int get length => _toasts.length;

  /// How many are actually painted.
  @visibleForTesting
  int get visibleCount => _toasts.length < _visible ? _toasts.length : _visible;

  /// The message a live toast is currently showing — the only way to observe a
  /// [promise] swap from outside.
  @visibleForTesting
  ToastMessage? messageOf(int id) {
    for (final _LiveToast toast in _toasts) {
      if (toast.id == id) return toast.message;
    }
    return null;
  }

  /// `toast(…)` — returns the id, so a caller can dismiss it early.
  int show(ToastMessage message) {
    final int id = _nextId++;
    _toasts.add(_LiveToast(id, message));
    notifyListeners();
    return id;
  }

  int _typed(
    ToastType type,
    String title,
    String? description,
    IconGlyph? glyph,
    ToastAction? action,
  ) => show(
    ToastMessage(
      title: title,
      description: description,
      type: type,
      glyph: glyph,
      action: action,
    ),
  );

  /// `toast.success(title)`.
  int success(
    String title, {
    String? description,
    IconGlyph? glyph,
    ToastAction? action,
  }) => _typed(ToastType.success, title, description, glyph, action);

  /// `toast.error(title)` — the one the `feedback` page gives a `Retry`.
  int error(
    String title, {
    String? description,
    IconGlyph? glyph,
    ToastAction? action,
  }) => _typed(ToastType.error, title, description, glyph, action);

  /// `toast.info(title)`.
  int info(
    String title, {
    String? description,
    IconGlyph? glyph,
    ToastAction? action,
  }) => _typed(ToastType.info, title, description, glyph, action);

  /// `toast.warning(title)`.
  int warning(
    String title, {
    String? description,
    IconGlyph? glyph,
    ToastAction? action,
  }) => _typed(ToastType.warning, title, description, glyph, action);

  /// `toast.loading(title)` — the one call that leaves a toast on screen
  /// indefinitely. Dismiss it, or settle it with [settle].
  int loading(
    String title, {
    String? description,
    IconGlyph? glyph,
    ToastAction? action,
  }) => _typed(ToastType.loading, title, description, glyph, action);

  /// `toast.promise(promise, { loading, success, error })` — supervisor ruling
  /// F8.
  ///
  /// Shows the loading toast immediately and **swaps the settled one into the
  /// same toast** when [future] completes: same id, same box, same position in
  /// the stack, no exit and no second entrance. The glyph cross-fades (see
  /// [Toast.swapFrom]) and the 4000ms clock starts only once it has settled,
  /// because a loading toast has none.
  ///
  /// The `feedback` page's Promise button resolves after 1800ms.
  int promise<T>(
    Future<T> future, {
    required String loading,
    required String success,
    required String error,
    String? loadingDescription,
    String? successDescription,
    String? errorDescription,
  }) {
    final int id = show(
      ToastMessage(
        title: loading,
        description: loadingDescription,
        type: ToastType.loading,
        promise: true,
      ),
    );
    future.then<void>(
      (T _) => settle(
        id,
        ToastMessage(
          title: success,
          description: successDescription,
          type: ToastType.success,
          promise: true,
        ),
      ),
      onError: (Object failure, StackTrace trace) => settle(
        id,
        ToastMessage(
          title: error,
          description: errorDescription,
          type: ToastType.error,
          promise: true,
        ),
      ),
    );
    return id;
  }

  /// Replaces a live toast's message in place, the way `toast.promise` and
  /// `toast.success(id, …)` do. A no-op once the toast has gone.
  void settle(int id, ToastMessage next) {
    for (final _LiveToast toast in _toasts) {
      if (toast.id != id || toast.leaving) continue;
      final IconGlyph? was = toast.message.resolvedGlyph;
      final IconGlyph? now = next.resolvedGlyph;
      if (next.promise && was != null && was != now) {
        toast.swapFrom = was;
        toast.swapSeq++;
      }
      toast.message = next;
      notifyListeners();
      return;
    }
  }

  /// `toast.dismiss(id)` — starts the 200ms unmount window.
  void dismiss(int id) {
    for (final _LiveToast toast in _toasts) {
      if (toast.id != id || toast.leaving) continue;
      toast.leaving = true;
      notifyListeners();
      return;
    }
  }

  /// Called by the host once a leaving toast's window has closed.
  void _remove(int id) {
    final int before = _toasts.length;
    _toasts.removeWhere((_LiveToast t) => t.id == id);
    if (_toasts.length != before) notifyListeners();
  }

  /// `toast.dismiss()` with no argument — clears everything at once.
  void clear() {
    if (_toasts.isEmpty) return;
    _toasts.clear();
    notifyListeners();
  }
}

/// The corner sonner is anchored in. The root layout passes `bottom-right`.
enum ToastPosition {
  bottomRight,
  bottomLeft,
  topRight,
  topLeft;

  bool get isBottom =>
      this == ToastPosition.bottomRight || this == ToastPosition.bottomLeft;

  bool get isRight =>
      this == ToastPosition.bottomRight || this == ToastPosition.topRight;

  /// `--lift` — `-1` for a bottom stack, `+1` for a top one. Every offset in
  /// the choreography is multiplied by it, which is the whole reason one set of
  /// rules serves four corners.
  double get lift => isBottom ? -1 : 1;

  /// The same corner moved to the **top** edge, keeping the side it was on.
  ///
  /// This is the whole of the compact anchor swap: [lift] flips with it, and
  /// every rule in the choreography is already written as a multiple of [lift],
  /// so the stack grows downward, the entrance arrives from the top edge and
  /// the swipe's "with the corner" direction becomes up — all from this one
  /// substitution rather than from a second set of rules.
  ToastPosition get topAnchored =>
      isRight ? ToastPosition.topRight : ToastPosition.topLeft;
}

/// `<Toaster position="bottom-right" />` — the host.
///
/// Mount it **once**, above everything else, the way the root layout does. It
/// paints nothing until a toast is queued and never intercepts a pointer
/// outside the stack's own box.
///
/// ## The compact anchor — user-ordered, sonner's geometry
///
/// **[position] is the wide-viewport corner only.** At or below
/// [mobileBreakpoint] the stack re-anchors to the **top** of the screen.
///
/// What the reference actually does, measured rather than assumed:
///
///  * `styles.css` L425 opens `@media (max-width: 600px)` — sonner's one
///    breakpoint. Inside it the toaster goes `left/right: var(--mobile-offset)`
///    and `width: 100%`, each toast takes `width: calc(100% - offset * 2)`, and
///    the anchored edge moves to `--mobile-offset-*`. `MOBILE_VIEWPORT_OFFSET`
///    is `16px` against `VIEWPORT_OFFSET`'s `24px`.
///  * **The y-position does not move.** The block has a rule for each of
///    `[data-y-position=bottom]` and `[data-y-position=top]` and simply reskins
///    whichever one is already set. `app/layout.tsx:39` mounts
///    `<Toaster position="bottom-right" />` — a literal, with no `mobileOffset`
///    and no responsive override anywhere in the app — so **the reference's own
///    phone behaviour is a bottom stack**, full-bleed at a 16px inset.
///
/// The order was top-on-mobile, and the order wins over the reference here.
/// What sonner's block *does* own is the geometry, and all of it is adopted:
/// the 600px breakpoint, the 16px offset on every edge, and the toast widening
/// to fill the viewport between those insets. Only the anchored edge is the
/// port's own decision.
///
/// It is one substitution, not a fork: [ToastPosition.topAnchored] flips
/// `--lift`, and the collapse, the expand, all three exits, the entrance and
/// the swipe axis are each already written as a multiple of it.
///
/// ## The system bars
///
/// The anchored edge pays [MediaQueryData.padding] over sonner's inset —
/// [paddingFor]. A top-anchored compact stack sits `padding.top + 16` down, a
/// bottom-anchored one `padding.bottom + 24` up, and on any surface that
/// reports no bars at all — every desktop, every browser, every test that does
/// not set `view.padding` — the arithmetic is sonner's own number unchanged.
class Toaster extends StatefulWidget {
  const Toaster({
    super.key,
    required this.controller,
    this.position = ToastPosition.bottomRight,
  });

  final ToastController controller;

  /// The corner the stack sits in **on a wide viewport**. Below
  /// [mobileBreakpoint] the anchor is the top edge regardless — see the class
  /// doc — and only the side survives from this.
  final ToastPosition position;

  /// `width: 22.25rem` — the wide-viewport box.
  static double get width => _width;

  /// sonner's `GAP`.
  static double get gap => _gap;

  /// sonner's `VIEWPORT_OFFSET`.
  static double get viewportOffset => _offset;

  /// sonner's `MOBILE_VIEWPORT_OFFSET`.
  static double get mobileViewportOffset => _mobileOffset;

  /// `@media (max-width: 600px)` — inclusive, as a `max-width` query is.
  static double get mobileBreakpoint => _mobileBreakpoint;

  /// Whether a viewport of this width takes the compact treatment.
  static bool isCompact(double viewportWidth) =>
      viewportWidth <= _mobileBreakpoint;

  /// The anchored corner for a viewport of this width — [position] as given
  /// above the breakpoint, its [ToastPosition.topAnchored] twin below it.
  static ToastPosition positionFor(
    ToastPosition position,
    double viewportWidth,
  ) => isCompact(viewportWidth) ? position.topAnchored : position;

  /// The inset from every viewport edge at this width.
  static double offsetFor(double viewportWidth) =>
      isCompact(viewportWidth) ? _mobileOffset : _offset;

  /// The host's own padding — [offsetFor] on all four sides, **plus whatever
  /// system chrome stands between the anchored edge and the screen**.
  ///
  /// User-ordered, and the same ruling [SafeArea] states for the rest of the
  /// corpus: nothing painted is letterboxed, but anything that has to be *read*
  /// clears the bars. It matters here because of the compact anchor above —
  /// 16px from `y = 0` on a phone is 16px **into** the status bar, and a
  /// top-anchored toast puts its title under the clock. A bottom stack has the
  /// same collision with the gesture bar on any device that has one.
  ///
  /// Only the **anchored** edge is paid, and the other three keep sonner's own
  /// number:
  ///
  ///  * the two sides, because [widthFor] is `100% − offset * 2` and the
  ///    toast's box is that arithmetic — widening the host's padding without
  ///    widening the toast would leave the stack adrift inside a box it no
  ///    longer fills;
  ///  * the far edge, because the stack does not reach it. A bottom-anchored
  ///    stack's top padding is inert under [Align], and spending an inset there
  ///    would only cap how far the stack could expand.
  ///
  /// [systemBars] is [MediaQueryData.padding] — the always-there obstructions —
  /// and never `viewInsets`: the keyboard belongs to whatever is focused, and a
  /// toast is not it. Clamped at zero for the same reason [widthFor] is: a
  /// negative [EdgeInsets] is an assertion in [Padding] rather than a squeeze.
  ///
  /// [position] is the **configured** corner, not the resolved one: which edge
  /// is anchored at this width is [positionFor]'s answer and not the caller's,
  /// so `bottomRight` on a phone pays the status bar it actually sits under.
  /// Passing an already-resolved corner is the same answer — [positionFor] is
  /// idempotent — which is what lets [build] hand it either one.
  static EdgeInsets paddingFor(
    double viewportWidth,
    EdgeInsets systemBars,
    ToastPosition position,
  ) {
    final ToastPosition anchored = positionFor(position, viewportWidth);
    final double inset = offsetFor(viewportWidth);
    return EdgeInsets.only(
      left: inset,
      right: inset,
      top: inset + (anchored.isBottom ? 0 : math.max(systemBars.top, 0)),
      bottom: inset + (anchored.isBottom ? math.max(systemBars.bottom, 0) : 0),
    );
  }

  /// The toast box at this width — `356px`, or
  /// `calc(100% - var(--mobile-offset) * 2)` once compact.
  ///
  /// Never negative: a viewport narrower than the two insets is not a layout
  /// anyone has, but a negative `width` is a crash rather than a squeeze.
  static double widthFor(double viewportWidth) => isCompact(viewportWidth)
      ? math.max(viewportWidth - _mobileOffset * 2, 0)
      : _width;

  /// sonner's `VISIBLE_TOASTS_AMOUNT`.
  static int get visibleLimit => _visible;

  /// sonner's `TOAST_LIFETIME`.
  static Duration get lifetime => _lifetime;

  /// sonner's `TIME_BEFORE_UNMOUNT`.
  static Duration get unmountDelay => _unmount;

  /// `transition: transform 400ms, opacity 400ms, height 400ms` — the window
  /// the enter, the collapse, the expand and two of the three exits share.
  static Duration get transition => _transition;

  /// The transform half of the collapsed back exit. Its opacity half is
  /// [unmountDelay]'s number.
  static Duration get collapsedExitTransform => _collapsedExitTransform;

  /// `animation-duration: 200ms` on the `swipe-out-*` keyframes.
  static Duration get swipeOutDuration => _swipeOutDuration;

  /// sonner's `SWIPE_THRESHOLD`.
  static double get swipeThreshold => _swipeThreshold;

  /// The release-velocity gate, in px per second.
  static double get swipeVelocity => _swipeVelocityPerSecond;

  /// `1 − 0.05n`'s step.
  static double get stackScaleStep => _stackScaleStep;

  /// `translateY(40%)`.
  static double get collapsedExitTravel => _collapsedExitTravel;

  /// The dampening sonner applies to a drag pulling *against* the corner —
  /// `1 / (1.5 + |delta| / 20)`, so a 20px pull lands 8px and a 100px pull
  /// lands 15px. Exposed because it is the only non-linear thing in the file.
  static double dampen(double delta) => delta / (1.5 + delta.abs() / 20);

  @override
  State<Toaster> createState() => _ToasterState();
}

/// One toast's fully-resolved target state for this frame — everything the CSS
/// cascade would have arrived at, computed once by the host and handed down.
@immutable
class _Choreo {
  const _Choreo({
    required this.translate,
    required this.translateFraction,
    required this.scale,
    required this.height,
    required this.contentOpacity,
    required this.opacity,
    required this.transformDuration,
    required this.transformCurve,
    required this.opacityDuration,
    required this.opacityCurve,
  });

  /// The pixel half of `--y`.
  final double translate;

  /// The percentage half of `--y`, as a fraction of the toast's **own** box —
  /// `translateY(100%)`, `translateY(-100%)` and `translateY(40%)` all resolve
  /// against the element, which is why they survive a height that is still
  /// animating.
  final double translateFraction;

  final double scale;

  /// The pinned box height. `height: var(--front-toast-height)` for a blanked
  /// back toast, `var(--initial-height)` for everything else.
  final double height;

  /// `[data-sonner-toast] > * { opacity }` — the icon slot and the content
  /// column together.
  final double contentOpacity;

  final double opacity;

  final Duration transformDuration;
  final Curve transformCurve;
  final Duration opacityDuration;
  final Curve opacityCurve;
}

class _ToasterState extends State<Toaster>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  /// The lifetime clock of every toast that has been on screen, keyed by id so
  /// a rebuild cannot restart one.
  ///
  /// An [AnimationController] rather than a [Timer], and for one reason:
  /// sonner's `pauseTimer` *"subtracts the elapsed time and stores the
  /// remainder"*, and a controller stores exactly that in its own `value`. Stop
  /// it and it holds; start it again and it resumes where it stopped. A `Timer`
  /// would need a wall clock beside it, and a wall clock does not move under
  /// `pump(Duration)`.
  final Map<int, AnimationController> _clocks = <int, AnimationController>{};

  /// The unmount clock of every toast on its way out.
  final Map<int, Timer> _retiring = <int, Timer>{};

  /// `heights` — every mounted toast's own measured box height, the thing
  /// `--front-toast-height`, `--initial-height` and every `--offset` are built
  /// out of. Drift 17: this cannot be a constant, so it is a measure-then-lay-
  /// out pass, reported up out of layout exactly as sonner reports it up out of
  /// `getBoundingClientRect()`.
  final Map<int, double> _heights = <int, double>{};

  /// `expanded` — container-level state, set by hovering **anywhere** over the
  /// stack and cleared on leaving it, and held true for as long as a pointer is
  /// down (`interacting`).
  bool _expanded = false;
  bool _interacting = false;

  /// `isDocumentHidden` — the third thing that pauses every clock.
  bool _hidden = false;

  /// How far the stack currently reaches from its anchored corner. It is the
  /// host's own box, so it is also the hover region and the hit region, which
  /// is what sonner's `[data-expanded] ::after` bridge is for: without it,
  /// crossing the gap between two expanded toasts would collapse the stack.
  ///
  /// Built in [initState] rather than lazily: a toaster that never had a toast
  /// never reaches [build]'s use of it, and a `late final` would then be
  /// initialised for the first time by [dispose] — creating a ticker against an
  /// element that is already deactivated.
  late final _Track _extent;

  int _toastCount = 0;

  @override
  void initState() {
    super.initState();
    _extent = _Track(this, 1);
    widget.controller.addListener(_onChanged);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didUpdateWidget(Toaster old) {
    super.didUpdateWidget(old);
    if (old.controller == widget.controller) return;
    old.controller.removeListener(_onChanged);
    widget.controller.addListener(_onChanged);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.controller.removeListener(_onChanged);
    for (final AnimationController clock in _clocks.values) {
      clock.dispose();
    }
    for (final Timer timer in _retiring.values) {
      timer.cancel();
    }
    _extent.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final bool hidden = state != AppLifecycleState.resumed;
    if (_hidden == hidden) return;
    setState(() => _hidden = hidden);
  }

  void _onChanged() {
    if (!mounted) return;
    setState(() {
      // `useEffect(() => { if (toasts.length <= 1) setExpanded(false) },
      // [toasts])` — the reset is keyed on the toast list, not on the hover, so
      // hovering a lone toast still expands (and still pauses) it. That is why
      // a single hovered toast resumes from its remainder rather than never
      // pausing at all.
      final int count = widget.controller._toasts.length;
      if (count != _toastCount) {
        _toastCount = count;
        if (count <= 1) _expanded = false;
      }
    });
  }

  bool get _paused => _expanded || _interacting || _hidden;

  /// Starts a toast's lifetime the first time it becomes visible — a queued
  /// fourth toast does not start counting down behind the other three.
  void _tick(_LiveToast toast) {
    if (toast.message.type == ToastType.loading) {
      // `if (toast.promise && toastType === 'loading' || … || toast.type ===
      // 'loading') return` — a loading toast has no clock at all.
      _clocks.remove(toast.id)?.dispose();
      return;
    }
    // The lifetime is NOT gated on `effectiveMotionDuration`: sonner's reduced-
    // motion block removes transitions, not timers, and the live page confirms
    // a reduced-motion toast still expires on its own 4000ms.
    final AnimationController clock = _clocks.putIfAbsent(toast.id, () {
      final AnimationController c = AnimationController(
        vsync: this,
        duration: toast.message.duration,
      );
      // On `value`, not on `AnimationStatus.completed`. A controller reports
      // `completed` on the first tick **strictly past** its duration
      // (`InterpolationSimulation.isDone` is a `>`), which would fire a 4000ms
      // toast on the frame after 4000ms; `setTimeout(4000)` fires at 4000.
      // Value reaches exactly 1 on the tick that lands on the duration.
      // [ToastController.dismiss] is idempotent, so a later tick is a no-op.
      c.addListener(() {
        if (!mounted || c.value < 1) return;
        widget.controller.dismiss(toast.id);
      });
      return c;
    });
    clock.duration = toast.message.duration;
    if (_paused) {
      // `pauseTimer` — stop where it stands. The remainder is `1 - value`.
      if (clock.isAnimating) clock.stop(canceled: false);
    } else if (!clock.isAnimating && !clock.isCompleted) {
      // `startTimer(remainingTime)`.
      clock.forward();
    }
  }

  void _retire(_LiveToast toast) {
    _clocks.remove(toast.id)?.dispose();
    if (_retiring.containsKey(toast.id)) return;
    _retiring[toast.id] = Timer(_unmount, () {
      if (!mounted) return;
      _retiring.remove(toast.id);
      _heights.remove(toast.id);
      widget.controller._remove(toast.id);
    });
  }

  void _measured(int id, double height) {
    if (!mounted) return;
    if (_heights[id] == height) return;
    setState(() => _heights[id] = height);
  }

  void _setExpanded(bool expanded) {
    if (_expanded == expanded) return;
    setState(() => _expanded = expanded);
  }

  void _setInteracting(bool interacting) {
    if (_interacting == interacting) return;
    setState(() => _interacting = interacting);
  }

  /// A swipe carried a toast past the threshold: record the direction it left
  /// in, then dismiss it on the normal 200ms unmount clock.
  void _swipeAway(_LiveToast toast, Offset direction) {
    toast.swipeOut = direction;
    widget.controller.dismiss(toast.id);
  }

  @override
  Widget build(BuildContext context) {
    final List<_LiveToast> all = widget.controller._toasts;
    if (all.isEmpty) return const SizedBox.shrink();

    // The media query, not the incoming constraints: `@media (max-width:
    // 600px)` asks the viewport, and a `position: fixed` toaster is measured
    // against the viewport whatever box its slot happens to be. Absent a
    // MediaQuery there is no viewport to read, and infinity is the honest
    // answer — it resolves to the wide contract.
    final double viewportWidth =
        MediaQuery.maybeSizeOf(context)?.width ?? double.infinity;
    final ToastPosition position = Toaster.positionFor(
      widget.position,
      viewportWidth,
    );
    final EdgeInsets padding = Toaster.paddingFor(
      viewportWidth,
      SafeArea.insetsOf(context),
      position,
    );
    final double width = Toaster.widthFor(viewportWidth);

    // The three most recent are on screen; the rest wait.
    final List<_LiveToast> shown = all.length <= _visible
        ? all
        : all.sublist(all.length - _visible);

    // sonner's own order: `index` counts from the newest, which is the one
    // nearest the corner. This is the order every rule below is written in —
    // `isFront`, the `n` in `1 − 0.05n`, the gap multiple — and it is NOT the
    // paint order. `--z-index: toasts.length - index` puts the newest on top,
    // so the `Stack` at the end of this method takes the list reversed; the
    // note there is the whole of that argument.
    final List<_LiveToast> byIndex = shown.reversed.toList(growable: false);

    // `heights` — mounted, not removed, newest first. A toast is dropped from
    // it the instant it is dismissed, which is what lets the survivors close
    // the gap while the leaver is still on screen.
    final List<_LiveToast> rows = <_LiveToast>[
      for (final _LiveToast t in byIndex)
        if (!t.leaving && _heights.containsKey(t.id)) t,
    ];
    final double frontHeight = rows.isEmpty ? 0 : _heights[rows.first.id]!;

    for (final _LiveToast toast in shown) {
      if (toast.leaving) {
        _retire(toast);
      } else {
        _tick(toast);
      }
    }

    final double lift = position.lift;
    final List<Widget> slots = <Widget>[];
    double extent = 0;

    for (int index = 0; index < byIndex.length; index++) {
      final _LiveToast toast = byIndex[index];
      final bool isFront = index == 0;
      final double natural = _heights[toast.id] ?? 0;

      // `--offset: heightIndex * gap + Σ(heights before)`, frozen at
      // `offsetBeforeRemove` once the toast is on its way out.
      double offset;
      if (toast.leaving) {
        offset = toast.offsetBeforeRemove ?? 0;
      } else {
        final int heightIndex = rows.indexOf(toast);
        double before = 0;
        for (int i = 0; i < heightIndex; i++) {
          before += _heights[rows[i].id]!;
        }
        offset = heightIndex <= 0 ? 0 : heightIndex * _gap + before;
        toast.offsetBeforeRemove = offset;
      }

      // `[data-expanded=false][data-front=false]` — the blanked, pinned,
      // scaled state, and the only one that reads `--front-toast-height`.
      final bool blanked = !isFront && !_expanded;
      final double height = blanked && frontHeight > 0
          ? frontHeight
          : (natural > 0 ? natural : 0);

      double translate;
      double fraction;
      double scale;
      double opacity = 1;
      Duration transformDuration = _transition;
      Curve transformCurve = MotionCurves.cssEase;
      Duration opacityDuration = _transition;
      Curve opacityCurve = MotionCurves.cssEase;

      if (blanked) {
        // `--y: translateY(--lift-amount * --toasts-before) scale(1 - 0.05n)`.
        translate = lift * _gap * index;
        fraction = 0;
        scale = 1 - _stackScaleStep * index;
      } else {
        // `[data-mounted][data-expanded=true]`, and the front toast always:
        // `--y: translateY(--lift * --offset)`.
        translate = lift * offset;
        fraction = 0;
        scale = 1;
      }

      if (toast.leaving) {
        opacity = 0;
        if (toast.swipeOut != null) {
          // `[data-swipe-out=true]` beats all three removal rules — every one
          // of them carries `[data-swipe-out=false]`. `--y` reverts to the
          // resting value and the keyframes ride on top of it.
          transformDuration = _swipeOutDuration;
          transformCurve = MotionCurves.cssEaseOut;
          opacityDuration = _swipeOutDuration;
          opacityCurve = MotionCurves.cssEaseOut;
        } else if (isFront) {
          // `--y: translateY(--lift * -100%)` — out the way it came.
          fraction = -lift;
        } else if (_expanded) {
          // `--y: translateY(--lift * --offset + --lift * -100%)`.
          translate = lift * offset;
          fraction = -lift;
        } else {
          // `--y: translateY(40%)`, and the scale is released back to 1
          // because this rule's `--y` has no `scale()` in it at all.
          translate = 0;
          fraction = _collapsedExitTravel;
          scale = 1;
          transformDuration = _collapsedExitTransform;
          opacityDuration = _unmount;
        }
      }

      // How far this toast reaches past the anchored corner, for the host's
      // own box. `travel` is the pixel lift re-signed so that "away from the
      // corner" is positive in both a bottom stack and a top one.
      final double travel = translate * lift + fraction * lift * height;
      extent = math.max(extent, height * (1 + scale) / 2 + travel);

      slots.add(
        Positioned(
          // **On the `Positioned`, not on the `_ToastSlot` under it.** The
          // stack re-indexes on every arrival and on every front departure —
          // slot 0 stops being toast A and starts being toast B — and a
          // `Stack`'s children are matched by key. An unkeyed `Positioned`
          // matches its neighbour by *position*, and the keyed child inside it
          // is then rejected by `Widget.canUpdate`, so every surviving toast's
          // `State` is torn out and rebuilt: `_mounted` back to false,
          // `_opacity` back to 0, `_transform` back to the entrance base. The
          // promoted toast then blinks out and re-enters instead of animating
          // from the blanked state to the front one, and for the frames in
          // between the stack is a row of empty plates. Keying the `Positioned`
          // is what lets the element *move* between slots with its clocks
          // intact, which is what the whole choreography is written against.
          key: ValueKey<int>(toast.id),
          left: 0,
          width: width,
          top: position.isBottom ? null : 0,
          bottom: position.isBottom ? 0 : null,
          child: _ToastSlot(
            toast: toast,
            position: position,
            choreo: _Choreo(
              translate: translate,
              translateFraction: fraction,
              scale: scale,
              height: height,
              contentOpacity: blanked ? 0 : 1,
              opacity: opacity,
              transformDuration: effectiveMotionDuration(
                context,
                transformDuration,
              ),
              transformCurve: transformCurve,
              opacityDuration: effectiveMotionDuration(
                context,
                opacityDuration,
              ),
              opacityCurve: opacityCurve,
            ),
            swipeOut: toast.swipeOut,
            onMeasured: (double h) => _measured(toast.id, h),
            onDismiss: () => widget.controller.dismiss(toast.id),
            onSwipeAway: (Offset direction) => _swipeAway(toast, direction),
            onInteracting: _setInteracting,
          ),
        ),
      );
    }

    _extent.retarget(
      <double>[math.max(extent, 0)],
      effectiveMotionDuration(context, _transition),
      MotionCurves.cssEase,
    );

    // Give this widget a full-size slot — `Positioned.fill` inside the shell's
    // `Stack`, or an `Overlay` entry — and it anchors itself in the corner the
    // way sonner's fixed viewport does. Compact, that corner is a top one, and
    // the box spans the viewport between its two insets.
    return Align(
      alignment: switch (position) {
        ToastPosition.bottomRight => AlignmentDirectional.bottomEnd,
        ToastPosition.bottomLeft => AlignmentDirectional.bottomStart,
        ToastPosition.topRight => AlignmentDirectional.topEnd,
        ToastPosition.topLeft => AlignmentDirectional.topStart,
      },
      child: Padding(
        padding: padding,
        child: MouseRegion(
          // `onMouseEnter`/`onMouseMove` → expand, `onMouseLeave` → collapse,
          // both on the container. `opaque: false` because this only watches:
          // `FeedbackSurface` mounts its own `MouseRegion` on every toast for the
          // hover swell, and a region that claimed the pointer here would leave
          // the bloom's swell dead. Nested regions both receive the pointer;
          // an opaque one would not change that either, but stating the intent
          // costs nothing and the failure mode is silent.
          opaque: false,
          onEnter: (PointerEnterEvent _) => _setExpanded(true),
          onHover: (PointerHoverEvent _) => _setExpanded(true),
          onExit: (PointerExitEvent _) {
            // "Avoid setting expanded to false when interacting with a toast,
            // e.g. swiping."
            if (!_interacting) _setExpanded(false);
          },
          child: AnimatedBuilder(
            animation: _extent.c,
            builder: (BuildContext context, Widget? child) =>
                SizedBox(width: width, height: _extent.at(0), child: child),
            child: Stack(
              // Every toast is `position: absolute`, so nothing here sizes the
              // host; the host is sized to the stack's own reach above. A
              // toast mid-transition can briefly overshoot that, and clipping
              // it would be visible.
              clipBehavior: Clip.none,
              // **Reversed, and this is the z-index.** `--z-index:
              // toasts.length - index` gives the newest — `index` 0 — the
              // highest, so the front toast paints over the stack behind it. A
              // `Stack` paints in child order, and `slots` is built newest-
              // FIRST because that is the order `index` counts in, so handing
              // it over as-is paints the newest first and therefore *bottom*.
              //
              // The back toast is not a translucent hint: it is a whole opaque
              // `--popover` plate, pinned to the front toast's own height and
              // sitting only 14px off it, and its children are at `opacity: 0`.
              // Painted on top it covers the front toast's title and
              // description with blank fill — the empty plate — while every
              // widget-tree assertion still reads a legible front toast,
              // because nothing about the tree is wrong. Only the canvas is.
              // The rasterised pin in `feedback_effects_test.dart` is what
              // holds this, for exactly that reason.
              //
              // Hit-testing reverses again on its own, so the front toast is
              // also the one that now takes the tap and the swipe it was
              // already drawn to receive.
              children: slots.reversed.toList(growable: false),
            ),
          ),
        ),
      ),
    );
  }
}

/// One CSS transition: a clock, an easing, and the from/to pair of every
/// component that rides the same declaration.
///
/// `transform` is **one** property, and its `translateY` and its `scale`
/// therefore share a single progress — measured on the live expand, where the
/// second toast's scale had covered 7.22% of its travel at the same frame its
/// translate had covered 7.22% of its own. Modelling them as two independent
/// tweens would drift apart the moment either one retargets mid-flight, which
/// is exactly what happens every time the stack re-indexes.
///
/// Retargeting is the other half of what CSS does for free: a transition whose
/// end value changes mid-flight restarts **from wherever it is now**, not from
/// where it began.
class _Track {
  _Track(TickerProvider vsync, int channels)
    : _from = List<double>.filled(channels, 0),
      _to = List<double>.filled(channels, 0),
      c = AnimationController(vsync: vsync, duration: Duration.zero, value: 1);

  final AnimationController c;
  final List<double> _from;
  final List<double> _to;
  Curve _curve = MotionCurves.cssEase;
  bool _seeded = false;

  double at(int i) {
    final double t = _curve.transform(c.value.clamp(0.0, 1.0));
    return _from[i] + (_to[i] - _from[i]) * t;
  }

  /// `transition: none` — land on the value with no travel. Also the first
  /// frame of a toast's life, which sonner spends at `translateY(100%)` before
  /// `data-mounted` flips.
  void set(List<double> next) {
    for (int i = 0; i < next.length; i++) {
      _from[i] = next[i];
      _to[i] = next[i];
    }
    c.duration = Duration.zero;
    c.value = 1;
    _seeded = true;
  }

  void retarget(List<double> next, Duration duration, Curve curve) {
    if (!_seeded) {
      set(next);
      return;
    }
    bool same = true;
    for (int i = 0; i < next.length; i++) {
      if (_to[i] != next[i]) {
        same = false;
        break;
      }
    }
    if (same && _curve == curve) return;
    for (int i = 0; i < next.length; i++) {
      _from[i] = at(i);
      _to[i] = next[i];
    }
    _curve = curve;
    if (duration <= Duration.zero) {
      c.duration = Duration.zero;
      c.value = 1;
      return;
    }
    c.duration = duration;
    c.forward(from: 0);
  }

  void dispose() => c.dispose();
}

/// The seven channels of the one `transform` declaration.
const int _kTranslate = 0;
const int _kFraction = 1;
const int _kScale = 2;
const int _kSwipeX = 3;
const int _kSwipeY = 4;
const int _kSwipeFracX = 5;
const int _kSwipeFracY = 6;

/// One `<li data-sonner-toast>` — its position in the stack, its own clocks,
/// and the gesture that can throw it out.
class _ToastSlot extends StatefulWidget {
  const _ToastSlot({
    required this.toast,
    required this.position,
    required this.choreo,
    required this.swipeOut,
    required this.onMeasured,
    required this.onDismiss,
    required this.onSwipeAway,
    required this.onInteracting,
  });

  final _LiveToast toast;
  final ToastPosition position;
  final _Choreo choreo;
  final Offset? swipeOut;
  final ValueChanged<double> onMeasured;
  final VoidCallback onDismiss;
  final ValueChanged<Offset> onSwipeAway;
  final ValueChanged<bool> onInteracting;

  @override
  State<_ToastSlot> createState() => _ToastSlotState();
}

class _ToastSlotState extends State<_ToastSlot> with TickerProviderStateMixin {
  late final _Track _transform = _Track(this, 7);
  late final _Track _height = _Track(this, 1);
  late final _Track _contentOpacity = _Track(this, 1);
  late final _Track _opacity = _Track(this, 1);

  /// `sonner-fade-in` on the settled glyph, and the loader's own 200ms fade
  /// under it. One clock: the loader's leg is the same elapsed time read
  /// against a shorter window.
  late final AnimationController _swap = AnimationController(
    vsync: this,
    duration: _promiseSwapIn,
    value: 1,
  );
  int _swapSeq = 0;
  IconGlyph? _swapFrom;

  /// `useEffect(() => setMounted(true), [])` — one frame after mount.
  bool _mounted = false;

  /// The live drag. `--swipe-amount-x` / `--swipe-amount-y`, and the axis lock
  /// sonner takes on the first pointer move past 1px.
  Offset _swipe = Offset.zero;
  Axis? _axis;
  bool _dragging = false;

  @override
  void initState() {
    super.initState();
    // The base rule, before `data-mounted` flips: `--y: translateY(100%)` at
    // the bottom, `translateY(-100%)` at the top, `opacity: 0`.
    _transform.set(
      _channels(translate: 0, fraction: -widget.position.lift, scale: 1),
    );
    _height.set(<double>[widget.choreo.height]);
    _contentOpacity.set(<double>[widget.choreo.contentOpacity]);
    _opacity.set(<double>[0]);
    _swapSeq = widget.toast.swapSeq;
    SchedulerBinding.instance.addPostFrameCallback((Duration _) {
      if (!mounted) return;
      setState(() => _mounted = true);
    });
  }

  @override
  void dispose() {
    _transform.dispose();
    _height.dispose();
    _contentOpacity.dispose();
    _opacity.dispose();
    _swap.dispose();
    super.dispose();
  }

  List<double> _channels({
    required double translate,
    required double fraction,
    required double scale,
    Offset swipe = Offset.zero,
    Offset swipeFraction = Offset.zero,
  }) => <double>[
    translate,
    fraction,
    scale,
    swipe.dx,
    swipe.dy,
    swipeFraction.dx,
    swipeFraction.dy,
  ];

  void _sync() {
    final _Choreo c = widget.choreo;

    if (widget.toast.swapSeq != _swapSeq) {
      _swapSeq = widget.toast.swapSeq;
      _swapFrom = widget.toast.swapFrom;
      final Duration d = effectiveMotionDuration(context, _promiseSwapIn);
      if (d <= Duration.zero) {
        _swap.value = 1;
      } else {
        _swap.duration = d;
        _swap.forward(from: 0);
      }
    }

    if (!_mounted) return;

    if (_dragging) {
      // `[data-swiping=true] { transition: none }` — the toast tracks the
      // pointer exactly, and lets go of it just as abruptly when the release
      // falls short of the threshold.
      _transform.set(
        _channels(
          translate: c.translate,
          fraction: c.translateFraction,
          scale: c.scale,
          swipe: _swipe,
        ),
      );
    } else {
      final Offset? out = widget.swipeOut;
      _transform.retarget(
        _channels(
          translate: c.translate,
          fraction: c.translateFraction,
          scale: c.scale,
          swipe: _swipe,
          // `translateX(calc(var(--swipe-amount-x) + 100%))` — a further whole
          // box on the swiped axis, in the direction it was thrown.
          swipeFraction: out ?? Offset.zero,
        ),
        c.transformDuration,
        c.transformCurve,
      );
    }
    // `height` is only ever *declared* by the two rules that pin it; the base
    // state has none at all, so a toast is at its measured height from its
    // first paint and has nothing to travel from. Until the measurement lands
    // there is no height to speak of either — so the first real number is a
    // jump, and every number after it is a transition.
    if (_height.at(0) <= 0 || c.height <= 0) {
      _height.set(<double>[c.height]);
    } else {
      _height.retarget(
        <double>[c.height],
        effectiveMotionDuration(context, _transition),
        MotionCurves.cssEase,
      );
    }
    _contentOpacity.retarget(
      <double>[c.contentOpacity],
      effectiveMotionDuration(context, _transition),
      MotionCurves.cssEase,
    );
    _opacity.retarget(<double>[c.opacity], c.opacityDuration, c.opacityCurve);
  }

  void _onPanStart(DragStartDetails _) {
    _axis = null;
    _dragging = true;
    widget.onInteracting(true);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final Offset next = _swipe + details.delta;
    if (_axis == null && (next.dx.abs() > 1 || next.dy.abs() > 1)) {
      _axis = next.dx.abs() > next.dy.abs() ? Axis.horizontal : Axis.vertical;
    }
    // "Only apply swipe in the locked direction", and only the corner's own
    // two directions travel 1:1 — the other two are dampened.
    Offset swipe = Offset.zero;
    if (_axis == Axis.horizontal) {
      final bool with_ = widget.position.isRight ? next.dx > 0 : next.dx < 0;
      swipe = Offset(with_ ? next.dx : Toaster.dampen(next.dx), 0);
    } else if (_axis == Axis.vertical) {
      final bool with_ = widget.position.isBottom ? next.dy > 0 : next.dy < 0;
      swipe = Offset(0, with_ ? next.dy : Toaster.dampen(next.dy));
    }
    setState(() => _swipe = swipe);
  }

  void _onPanEnd(DragEndDetails details) {
    _dragging = false;
    widget.onInteracting(false);
    final double amount = _axis == Axis.horizontal ? _swipe.dx : _swipe.dy;
    final Offset v = details.velocity.pixelsPerSecond;
    final double speed = (_axis == Axis.horizontal ? v.dx : v.dy).abs();
    if (amount.abs() >= _swipeThreshold || speed > _swipeVelocityPerSecond) {
      widget.onSwipeAway(
        _axis == Axis.horizontal
            ? Offset(amount.sign, 0)
            : Offset(0, amount.sign),
      );
      return;
    }
    // Short of the threshold sonner writes `--swipe-amount-*: 0px` while
    // `data-swiping` is still true, so the toast snaps home with no transition
    // at all. Measured: the toast survives and does not travel.
    setState(() {
      _swipe = Offset.zero;
      _axis = null;
    });
  }

  void _onPanCancel() {
    _dragging = false;
    widget.onInteracting(false);
    setState(() {
      _swipe = Offset.zero;
      _axis = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    _sync();

    final ToastMessage message = widget.toast.message;

    return AnimatedBuilder(
      animation: Listenable.merge(<Listenable>[
        _transform.c,
        _height.c,
        _contentOpacity.c,
        _opacity.c,
        _swap,
      ]),
      builder: (BuildContext context, Widget? _) {
        // Read inside the builder, never above it: this closure is what the
        // clocks rebuild, and a value captured in the enclosing `build` would
        // only ever be as fresh as the last time the whole host rebuilt — which
        // is when a toast is queued, not once a frame.
        final double swapIn = MotionCurves.cssEase.transform(
          _swap.value.clamp(0.0, 1.0),
        );
        // The loader's shorter window, read off the same elapsed time.
        final double swapOut = MotionCurves.cssEase.transform(
          (_swap.value *
                  _promiseSwapIn.inMicroseconds /
                  _promiseSwapOut.inMicroseconds)
              .clamp(0.0, 1.0),
        );
        return Transform.translate(
          offset: Offset(0, _transform.at(_kTranslate)),
          child: FractionalTranslation(
            translation: Offset(0, _transform.at(_kFraction)),
            child: Transform.scale(
              scale: _transform.at(_kScale),
              child: Transform.translate(
                offset: Offset(
                  _transform.at(_kSwipeX),
                  _transform.at(_kSwipeY),
                ),
                child: FractionalTranslation(
                  translation: Offset(
                    _transform.at(_kSwipeFracX),
                    _transform.at(_kSwipeFracY),
                  ),
                  child: Opacity(
                    opacity: _opacity.at(0).clamp(0.0, 1.0),
                    child: GestureDetector(
                      // A pan, not a drag: the axis lock is sonner's own and it
                      // wants both. Children are hit-tested first, so the bloom's
                      // `MouseRegion` underneath still sees every pointer.
                      behavior: HitTestBehavior.opaque,
                      // `pointerStartRef` is the **pointerdown** position, and
                      // every swipe amount sonner computes is a delta from it —
                      // so the recogniser's slop must be delivered, not
                      // swallowed. With the default `start` behaviour a 60px
                      // flick arrives as a drag that has already travelled 60px
                      // and reports nothing at all.
                      dragStartBehavior: DragStartBehavior.down,
                      onPanStart: _onPanStart,
                      onPanUpdate: _onPanUpdate,
                      onPanEnd: _onPanEnd,
                      onPanCancel: _onPanCancel,
                      child: Toast(
                        message: message,
                        onDismiss: widget.onDismiss,
                        pinnedHeight: _height.at(0) > 0 ? _height.at(0) : null,
                        contentOpacity: _contentOpacity.at(0).clamp(0.0, 1.0),
                        starfield: _contentOpacity.at(0) > 0,
                        onMeasured: widget.onMeasured,
                        swapFrom: _swap.isCompleted ? null : _swapFrom,
                        swapIn: swapIn,
                        swapOut: swapOut,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// `.cn-toast` — the surface, on its own, for a host or a static preview.
class Toast extends StatelessWidget {
  const Toast({
    super.key,
    required this.message,
    this.onDismiss,
    this.pinnedHeight,
    this.contentOpacity = 1,
    this.starfield = true,
    this.onMeasured,
    this.swapFrom,
    this.swapIn = 1,
    this.swapOut = 1,
  });

  final ToastMessage message;

  /// A tap dismisses.
  ///
  /// sonner itself has no tap-to-dismiss — it has the swipe [Toaster] now
  /// implements, and a close button this page does not enable. The tap is the
  /// port's own, shipped and pinned before the choreography landed, and kept:
  /// a pointer-only affordance on a surface that lives for four seconds is not
  /// something to take away for symmetry.
  ///
  /// Null in a static preview: the card renders with no dismiss handler at
  /// all, and the pointer cursor is withheld to match.
  final VoidCallback? onDismiss;

  /// `height: var(--front-toast-height)` — the outer box height to pin to, or
  /// null for `var(--initial-height)`, which is simply what the content
  /// measures.
  ///
  /// The content is laid out at its natural height regardless and clipped, the
  /// way a flex container with `align-items: flex-start`, an explicit `height`
  /// and `overflow: hidden` does.
  final double? pinnedHeight;

  /// `[data-sonner-toast] > * { opacity }`. Zero on a blanked back toast, and
  /// the reason toasts 2 and 3 of a collapsed stack are silhouettes.
  final double contentOpacity;

  /// Whether `.starfield` hangs over the bloom. False for a blanked back toast
  /// — see the library note.
  final bool starfield;

  /// Reports the height the content actually measures, so a host can pin its
  /// back toasts to it. This is drift 17's measure-then-lay-out pass.
  final ValueChanged<double>? onMeasured;

  /// The glyph a `toast.promise` swap is crossing *from*, painted under the
  /// settled one while both fades run.
  final IconGlyph? swapFrom;

  /// `sonner-fade-in`'s progress on the settled glyph — opacity, and a scale
  /// from 0.8.
  final double swapIn;

  /// The loader's own shorter fade under it.
  final double swapOut;

  /// `box-sizing: border-box` — the hairline on each side is paid for out of
  /// the box, so a pinned outer height reaches the content two pixels short.
  static double get borderInset => BorderWidths.hairline * 2;

  /// `[data-title]` — `font-size: var(--text-small); font-weight: 500`, and
  /// **no leading of its own**, so it inherits the one `.cn-toast` sets on the
  /// whole toast — one and a half — and renders at 19.5px.
  ///
  /// Assembled out of two foundation specs rather than reaching for
  /// [TextStyles.buttonLabel], which is the same 13/500 on `text-sm`'s
  /// surviving Tailwind ratio (1.4286 → 18.57px). That is the right leading for
  /// a button label and the wrong one here by 0.93px a line — a whole pixel per
  /// line of every toast, and the difference between reproducing sonner's
  /// measured 53.5 / 75.6875 / 93.875px boxes and missing all three.
  static final TextStyleToken titleSpec = TextStyleToken(
    family: Fonts.sans,
    size: TextStyles.small.size,
    height: TextStyles.small.height,
    wght: TextStyles.buttonLabel.weight!.value.toDouble(),
  );

  /// `[data-description]` — `.cn-toast` sets its size and its colour and
  /// **never its leading**, so the one sonner's own stylesheet declares on
  /// `[data-description]` is what survives: one-point-four, 18.2px, not the
  /// 19.5 the preview gets. feedback-map drift 4, and the map's own ruling on
  /// it — *"the port should pin the LIVE numbers"*.
  ///
  /// Confirmed by arithmetic on the measured boxes rather than by reading the
  /// declaration: a title with a one-line description measured 75.6875px, and
  /// 75.6875 − 2 − 32 − 19.5 − 4 leaves 18.1875 for the description line.
  static final TextStyleToken descriptionSpec = TextStyleToken(
    family: Fonts.sans,
    size: TextStyles.small.size,
    height:
        1.4, // allow-hardcoded: sonner styles.css L129, a foreign stylesheet's own line-height
    wght: TextStyles.small.weight!.value.toDouble(),
    defaultColor: TextColorRole.muted,
  );

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final BorderRadius radius = BorderRadius.circular(Radii.lg);
    final IconGlyph? glyph = message.resolvedGlyph;

    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        StyledText(message.title, titleSpec, color: theme.foreground),
        if (message.description != null) ...<Widget>[
          // `[data-content] { gap: calc(var(--spacing) * 1) }`.
          SizedBox(height: space(1)),
          StyledText(
            message.description!,
            descriptionSpec,
            color: theme.mutedForeground,
          ),
        ],
      ],
    );

    final ToastAction? action = message.action;
    if (glyph != null || action != null) {
      content = Row(
        // `align-items: flex-start` — a 32px pill beside a one-line title sits
        // at the top of the row, not centred against it.
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (glyph != null) ...<Widget>[
            Padding(
              // `[data-icon] { margin-top: calc(var(--spacing) * 0.5) }`.
              padding: EdgeInsets.only(top: space(0.5)),
              child: _Glyph(
                glyph: glyph,
                from: swapFrom,
                swapIn: swapIn,
                swapOut: swapOut,
              ),
            ),
            // `gap: calc(var(--spacing) * 3)`.
            SizedBox(width: space(3)),
          ],
          // `[data-content] { min-width: 0 }` under `margin-left: auto` on the
          // button: the column keeps the row's whole remaining width and its
          // text is left-aligned inside it, which puts the pill hard against
          // the right edge.
          Expanded(child: content),
          if (action != null) ...<Widget>[
            SizedBox(width: space(3)),
            _ActionPill(action: action, onDismiss: onDismiss),
          ],
        ],
      );
    }

    // The glyph is `color: var(--<type>-ink)` and nothing else in the toast is
    // coloured by its type at all.
    content = DefaultTextStyle.merge(
      style: TextStyle(color: message.type.inkOf(theme)),
      child: content,
    );

    Widget toast = Padding(
      // `padding: calc(var(--spacing) * 4)`.
      padding: EdgeInsets.all(space(4)),
      child: contentOpacity >= 1
          ? content
          : Opacity(opacity: contentOpacity.clamp(0.0, 1.0), child: content),
    );

    // `height: …` + `overflow: hidden`, and the measurement the host pins its
    // back toasts to. Inside the border, so both are stated in the content box
    // and converted at this one seam.
    toast = _PinnedBox(
      height: pinnedHeight == null ? null : pinnedHeight! - borderInset,
      onMeasured: onMeasured == null
          ? null
          : (double h) => onMeasured!(h + borderInset),
      child: toast,
    );

    toast = _bloomFor(
      message.type,
      radius: radius,
      fill: theme.popover,
      starfield: starfield,
      child: toast,
    );

    // `box-shadow: var(--shadow-e3)` and `border: 1px solid var(--border)`,
    // outside the bloom's clip because `overflow: hidden` clips to the padding
    // box.
    toast = Surface(
      spec: Shadows.lg,
      radius: radius,
      border: Border.all(color: theme.border, width: BorderWidths.hairline),
      child: toast,
    );

    return Semantics(
      container: true,
      liveRegion: true,
      label: message.title,
      // The tap is the port's own affordance (see [onDismiss]), so the cursor
      // that marks it is too: a pointer on the whole card only while a tap
      // would actually do something.
      child: MouseRegion(
        cursor: onDismiss != null
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onDismiss,
          child: toast,
        ),
      ),
    );
  }

  /// `.cn-toast[data-type="…"]`'s `--bloom-1` / `--bloom-2` pair.
  ///
  /// Four of the five agree with the Alert variant of the same name. `warning`
  /// does not — see `FeedbackSurface.toastWarning`.
  static Widget _bloomFor(
    ToastType type, {
    required BorderRadius radius,
    required Color fill,
    required bool starfield,
    required Widget child,
  }) => switch (type) {
    ToastType.success => FeedbackSurface(
      variant: FeedbackVariant.success,
      radius: radius,
      fill: fill,
      starfield: starfield,
      child: child,
    ),
    ToastType.info => FeedbackSurface(
      variant: FeedbackVariant.info,
      radius: radius,
      fill: fill,
      starfield: starfield,
      child: child,
    ),
    ToastType.warning => FeedbackSurface(
      variant: FeedbackVariant.warning,
      radius: radius,
      fill: fill,
      starfield: starfield,
      child: child,
    ),
    ToastType.error => FeedbackSurface(
      variant: FeedbackVariant.error,
      radius: radius,
      fill: fill,
      starfield: starfield,
      child: child,
    ),
    ToastType.loading => FeedbackSurface(
      variant: FeedbackVariant.loading,
      radius: radius,
      fill: fill,
      starfield: starfield,
      child: child,
    ),
    ToastType.normal => FeedbackSurface(
      variant: FeedbackVariant.neutral,
      radius: radius,
      fill: fill,
      starfield: starfield,
      child: child,
    ),
  };
}

/// `[data-button]` — the action pill.
///
/// `.cn-toast [data-button]` mirrors `variant="secondary" size="sm"` by hand,
/// because sonner renders the button itself and it can therefore never be a
/// real [Button]: 32px tall, 14px of inline padding, a 999px pill, `--secondary`
/// over the bloom, `--secondary-foreground`, 13/500, and a background that
/// crosses to `--accent` on hover over the transition default on
/// [MotionCurves.enter]. The 1px transparent border is declared and is paid for out
/// of the 32px, exactly as the fill's would be.
///
/// Pressing it runs the handler and then dismisses the toast, which is the
/// order `index.mjs` uses.
class _ActionPill extends StatefulWidget {
  const _ActionPill({required this.action, required this.onDismiss});

  final ToastAction action;
  final VoidCallback? onDismiss;

  @override
  State<_ActionPill> createState() => _ActionPillState();
}

class _ActionPillState extends State<_ActionPill> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (PointerEnterEvent _) => setState(() => _hovered = true),
      onExit: (PointerExitEvent _) => setState(() => _hovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          widget.action.onPressed?.call();
          widget.onDismiss?.call();
        },
        child: Semantics(
          button: true,
          label: widget.action.label,
          child: AnimatedContainer(
            duration: effectiveMotionDuration(context, MotionDurations.normal),
            curve: MotionCurves.enter,
            height: _actionHeight,
            padding: EdgeInsets.symmetric(horizontal: _actionPadding),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _hovered ? theme.accent : theme.secondary,
              borderRadius: BorderRadius.circular(Radii.full),
              border: Border.all(
                color: transparent,
                width: BorderWidths.hairline,
              ),
            ),
            child: ExcludeSemantics(
              child: StyledText(
                widget.action.label,
                Toast.titleSpec,
                color: theme.secondaryForeground,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// `[data-icon]` — 16px, and the two-glyph cross-fade a promise swap runs
/// through it.
class _Glyph extends StatelessWidget {
  const _Glyph({
    required this.glyph,
    required this.from,
    required this.swapIn,
    required this.swapOut,
  });

  final IconGlyph glyph;
  final IconGlyph? from;
  final double swapIn;
  final double swapOut;

  @override
  Widget build(BuildContext context) {
    final Widget settled = Icon(glyph, sizePx: space(4));
    if (from == null || swapIn >= 1) return settled;

    // `[data-promise=true] [data-icon] > svg { opacity: 0; transform:
    // scale(0.8); animation: sonner-fade-in }` over `.sonner-loader[data-
    // visible=false] { opacity: 0; transform: scale(0.8) }`. Both glyphs wear
    // the settled type's ink: `[data-icon]`'s colour is a `data-type` rule and
    // it flips at once, under a loader that is still on its way out.
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Opacity(
          opacity: (1 - swapOut).clamp(0.0, 1.0),
          child: Transform.scale(
            scale: 1 - (1 - _promiseSwapScale) * swapOut,
            child: Icon(from!, sizePx: space(4)),
          ),
        ),
        Opacity(
          opacity: swapIn.clamp(0.0, 1.0),
          child: Transform.scale(
            scale: _promiseSwapScale + (1 - _promiseSwapScale) * swapIn,
            child: settled,
          ),
        ),
      ],
    );
  }
}

/// `height: <length>` + `overflow: hidden` on a box whose content is laid out
/// at its own height regardless.
///
/// Drift 17, in one render object. Sonner reads `heights[0].height` off the DOM
/// and pins every collapsed back toast to it, which means the stack cannot be
/// laid out until the front toast has been measured — a round trip a constant
/// cannot stand in for. This lays the child out unbounded, reports what it
/// measured, then takes whatever height it was told to.
class _PinnedBox extends SingleChildRenderObjectWidget {
  const _PinnedBox({
    required this.height,
    required this.onMeasured,
    required Widget super.child,
  });

  final double? height;
  final ValueChanged<double>? onMeasured;

  @override
  _RenderPinnedBox createRenderObject(BuildContext context) =>
      _RenderPinnedBox(height: height, onMeasured: onMeasured);

  @override
  void updateRenderObject(BuildContext context, _RenderPinnedBox box) {
    box
      ..pinned = height
      ..onMeasured = onMeasured;
  }
}

class _RenderPinnedBox extends RenderProxyBox {
  _RenderPinnedBox({double? height, this.onMeasured}) : _pinned = height;

  double? _pinned;
  double? get pinned => _pinned;
  set pinned(double? value) {
    if (_pinned == value) return;
    _pinned = value;
    markNeedsLayout();
  }

  ValueChanged<double>? onMeasured;

  double? _reported;

  @override
  void performLayout() {
    final RenderBox? child = this.child;
    if (child == null) {
      size = constraints.smallest;
      return;
    }
    // The flow height, before `height:` overrides it: the incoming width,
    // nothing at all in the other axis.
    child.layout(
      BoxConstraints(
        minWidth: constraints.minWidth,
        maxWidth: constraints.maxWidth,
      ),
      parentUsesSize: true,
    );
    final double natural = child.size.height;
    if (_reported != natural) {
      _reported = natural;
      final ValueChanged<double>? report = onMeasured;
      if (report != null) {
        // Out of layout, the way sonner reports out of an effect.
        SchedulerBinding.instance.addPostFrameCallback((Duration _) {
          if (attached) report(natural);
        });
      }
    }
    size = Size(child.size.width, _pinned ?? natural);
  }

  bool get _clips => child != null && size.height < child!.size.height;

  @override
  void paint(PaintingContext context, Offset offset) {
    final RenderBox? child = this.child;
    if (child == null) return;
    if (!_clips) {
      context.paintChild(child, offset);
      return;
    }
    // `overflow: hidden`, and `align-items: flex-start` puts the overflow at
    // the bottom.
    layer = context.pushClipRect(
      needsCompositing,
      offset,
      Offset.zero & size,
      (PaintingContext inner, Offset shifted) =>
          inner.paintChild(child, shifted),
      oldLayer: layer as ClipRectLayer?,
    );
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (!size.contains(position)) return false;
    return super.hitTest(result, position: position);
  }

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);
    // A clipped toast is still announced in full; sonner announces through a
    // separate region and clips only the paint.
  }
}
