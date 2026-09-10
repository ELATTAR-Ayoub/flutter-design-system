/// `components/ui/dialog.tsx` — the modal overlay, and the machinery every
/// other modal on the dialogs page borrows.
///
/// ## What is measured here
///
/// Every number below was read off `http://localhost:3000/design-system/
/// components/base/dialogs` at 1440x900 on 2026-08-16 with the dialog **open**
/// (`bd-geom.js`), and every timing off a `requestAnimationFrame` trace of a
/// real `page.mouse` press (`bd-anim.js`). Nothing here is transcription.
///
/// | part | measured |
/// |---|---|
/// | content | 384 wide (`sm:max-w-sm`), `p-4`, `gap-4`, 16px radius, `--popover` fill, and a **1px `--foreground`/10 ring and nothing else** — no `shadow-md` under it |
/// | header | bleeds to 384 (`-mx-4 -mt-4`), `p-4` with `pr-12` when the close button is there, 1px bottom border, `--muted`/50, top corners rounded |
/// | footer | bleeds the same way, `p-4`, 1px top border, `--muted`/50, bottom corners rounded, `sm:flex-row sm:justify-end` |
/// | enter | `anim-jelly-in` — `--duration-jelly` 420ms on `--ease-spring` |
/// | exit | `anim-jelly-out` — `--duration-base` 250ms on `--ease-in-out` |
/// | overlay | `--background`/15 under a 4px backdrop blur, fading over `--duration-overlay` 320ms on `--ease-out` |
///
/// ## Two probe corrections
///
///  1. **The auto-focused button does not draw a focus ring.** A scripted
///     `space.click()` leaves the browser in keyboard modality, so the first probe
///     showed `Cancel` wearing a 3px `--ring` shadow. Re-driven with a real
///     `page.mouse.down/up`, `document.activeElement` is still the Cancel
///     button but `:focus-visible` does **not** match and its `box-shadow`
///     computes `none`. The port therefore moves focus without painting
///     anything, which is what the reference does.
///  2. **The jelly composes with the centring, and only because it has to.**
///     `DialogContent` centres itself with `-translate-x-1/2 -translate-y-1/2`,
///     which Tailwind v4 emits as the **standalone `translate` property** —
///     measured `translate: -50% -50%` with `transform: matrix(1,0,0,1,0,0)`.
///     `anim-jelly-in`'s keyframes drive `transform` only, exactly as
///     globals.css L2372–2374 warns they must. In Flutter the centring is
///     layout rather than paint, so the transform is the whole of the
///     animation — but the warning is why the keyframes are read as `transform`
///     and not as a translate that would have to be added to the centring.
///
/// ## The banding, and why it is the anatomy rather than decoration
///
/// `dialog.tsx`'s own comment:
///
/// > The header is a *band*, not just stacked text — it bleeds to the edges of
/// > the content's padding and closes with a rule, exactly like the footer.
/// > That gives the overlay three readable zones: what this is (title,
/// > description, close), what you are deciding on (the body), and what you can
/// > do (the CTAs). The two chrome bands are muted so the body is the only lit
/// > surface.
///
/// The negative margins are how CSS spells that. Flutter has no margins, so the
/// port spells it as layout: [DialogContent] pays its 16px padding on the
/// **body children only**, and the bands are laid out flush. Measured against
/// the reference, the two descriptions agree to the pixel — header top equals
/// content top, footer bottom equals content bottom, and both are 384 wide
/// inside a 384 box.
///
/// ## Not ported
///
/// `DialogFooter`'s own `showCloseButton` (nothing in the corpus passes it),
/// and the `*:[a]:underline` rules on the description — no dialog in the corpus
/// puts a link in one.
///
/// ## USER-ORDERED MOBILE ADAPTATIONS — two of them, and neither is measured
///
/// The reference is a desktop site and was probed at 1440x900. Nothing below
/// 640 was ever traced, and the reference has no back button at all. Both of
/// the following are **orders**, recorded as such so a later reader does not
/// mistake them for transcription and does not "correct" them back:
///
///  1. **The compact clamp** — [CompactDialogLayout]. At or below 600 logical
///     pixels of viewport width every centred modal takes `max-width: 90vw`
///     and `max-height: 75vh`, and its body scrolls inside the panel rather
///     than running off the screen. The trigger was a real overflow: the
///     dialogs page's shipment form, 384 wide plus two 16px gutters and a
///     three-band column, does not fit a 375x812 phone. Desktop geometry is
///     untouched — above the breakpoint [CompactDialogLayout.constraintsFor]
///     returns an unbounded box and every measured pin still holds.
///  2. **Back dismisses the topmost overlay** — [OverlayPortalState]. An
///     [OverlayPortal] is not a route, so Android's back button walks straight
///     past an open dialog and leaves the app. Every open portal registers
///     itself in one static stack and the host mounts a [PopScope] that
///     refuses the route pop while anything is open; the entry that is
///     **last** in the stack closes, so a dialog opened over a dialog unwinds
///     topmost-first. One mechanism, in one place — the sheet, the drawer and
///     the agent launcher's dialog all ride this host and inherit it.
///
/// **Back and Escape are deliberately not the same contract.** Escape is
/// transcribed: it closes whatever the reference was measured closing,
/// including the alert dialog that its own copy promises will not close (see
/// `alert_dialog.dart`'s drift 1), and a modal that the reference held open
/// under Escape would be held open here. Back is an order and admits no
/// exceptions — on a phone the alternative to dismissing is *leaving the app*,
/// which is never the intent behind a back press aimed at an overlay. So:
/// Escape follows the reference, back always dismisses.
library;

import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
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
import 'package:flutter/widgets.dart'
    as flutter
    show AspectRatio, OverlayPortal;

import './surface.dart';
import '../../design_system/foundation/motion.dart';
import '../../design_system/foundation/shadows.dart';
import '../../design_system/foundation/spacing.dart';
import '../../design_system/foundation/theme.dart';
import '../../design_system/foundation/typography.dart';
import '../../design_system/foundation/theme_scope.dart';
import './button.dart';
import './icon.dart';
import './icon_paths.dart';

/// `bg-background/15` — every overlay in the family, Radix and vaul alike.
const double _barrierAlpha = 0.15;

/// `bg-muted/50` — the two chrome bands.
const double _bandAlpha = 0.5;

/// `ring-1 ring-foreground/10`.
const double _ringAlpha = 0.10;

/// `bg-popover/80` — the media variant's close button, which sits on the
/// artwork rather than on a band.
const double _mediaCloseAlpha = 0.80;

/* ── The compact clamp ───────────────────────────────────────────────────── */

/// USER-ORDERED MOBILE ADAPTATION — the phone-sized box every centred modal is
/// held inside. See the library doc's adaptation 1.
///
/// Three numbers, and only the first of them has a precedent anywhere in the
/// system:
///
/// | number | where it comes from |
/// |---|---|
/// | [breakpoint] 600 | the one compact breakpoint the port already keeps — sonner's `@media (max-width: 600px)`, which `toaster.dart` anchors its stack off. Named again here rather than imported so this family does not depend on the toaster, and inclusive for the same reason a `max-width` query is |
/// | [maxWidthFraction] 0.90 | ordered — a 5% gutter each side, so the scrim reads as a scrim |
/// | [maxHeightFraction] 0.75 | ordered — the panel never fills the screen, because a modal that reaches both edges stops looking modal |
///
/// The clamp is a **maximum**, never a size: a small dialog on a small screen
/// is still exactly as big as its content. Above [breakpoint] every method
/// here is the identity, which is what keeps the measured desktop geometry
/// green.
class CompactDialogLayout {
  const CompactDialogLayout._();

  /// At or below this viewport width the clamp is in force.
  static const double breakpoint = 600;

  /// `max-width: 90vw`.
  static const double maxWidthFraction = 0.90;

  /// `max-height: 75vh`.
  static const double maxHeightFraction = 0.75;

  /// Whether a viewport of this width takes the compact treatment.
  ///
  /// Inclusive at the edge, as a `max-width` media query is.
  static bool isCompact(double viewportWidth) => viewportWidth <= breakpoint;

  /// The same question asked of a [BuildContext].
  static bool isCompactOf(BuildContext context) =>
      isCompact(MediaQuery.sizeOf(context).width);

  /// The box a centred modal may not exceed on [viewport] — and an unbounded
  /// one above the breakpoint, which is a no-op wherever it is applied.
  static BoxConstraints constraintsFor(Size viewport) =>
      isCompact(viewport.width)
      ? BoxConstraints(
          maxWidth: viewport.width * maxWidthFraction,
          maxHeight: viewport.height * maxHeightFraction,
        )
      : const BoxConstraints();

  /// [width] under the compact cap — for a panel that sizes itself rather than
  /// taking the constraint, which is the sheet's case.
  static double clampWidth(double width, Size viewport) =>
      isCompact(viewport.width)
      ? math.min(width, viewport.width * maxWidthFraction)
      : width;

  /// [box] under both caps — for a panel that sets an explicit width *and*
  /// height, which is the agent launcher's dialog.
  static Size clampSize(Size box, Size viewport) => isCompact(viewport.width)
      ? Size(
          math.min(box.width, viewport.width * maxWidthFraction),
          math.min(box.height, viewport.height * maxHeightFraction),
        )
      : box;
}

/* ── The portal ──────────────────────────────────────────────────────────── */

/// Builds the thing that opens the overlay. `DialogTrigger asChild`.
typedef ModalTriggerBuilder =
    Widget Function(BuildContext context, VoidCallback open);

/// Builds the overlay's content, given the callback that closes it —
/// `DialogClose asChild`, handed over rather than looked up.
typedef ModalContentBuilder =
    Widget Function(BuildContext context, VoidCallback close);

/// Wraps the content in its enter/exit animation. [animation] runs 0→1 on
/// open and 1→0 on close.
typedef ModalTransitionBuilder =
    Widget Function(
      BuildContext context,
      Animation<double> animation,
      Widget child,
    );

/// `DialogPortal` + `DialogOverlay` + the open state `Dialog.Root` owns.
///
/// **An [OverlayPortal], not a [Navigator] route**, and the reason is the one
/// thing a route cannot do here: `MediaQuery(disableAnimations: true)` — the
/// port's `prefers-reduced-motion` — sits *below* `MaterialApp` in both the
/// docs app and every page test, so a pushed route is built above it and never
/// sees it. [OverlayPortal] keeps the overlay a child of this widget in the
/// **element** tree while rendering it into the overlay theatre, so every
/// inherited lookup inside it — theme, media query, text style — resolves
/// through the page, exactly as a React portal's context does. The toaster in
/// `example/lib/shell.dart` reaches the same conclusion from the same
/// constraint.
///
/// Uncontrolled, like `Dialog.Root` with no `open` prop: the state lives here
/// and the trigger gets a callback. That is the opposite choice from
/// `Popover`, whose `open` is a prop — and deliberately so. A popover is
/// opened by a combobox that is already holding the boolean for its own
/// reasons; a dialog is opened by a button that has no other business.
class OverlayPortal extends StatefulWidget {
  const OverlayPortal({
    super.key,
    required this.trigger,
    required this.content,
    required this.transition,
    this.alignment = Alignment.center,
    this.enterDuration = MotionDurations.open,
    this.exitDuration = MotionDurations.close,
    this.overlayDuration = MotionDurations.overlayEnter,
    this.overlayCurve = MotionCurves.enter,
    this.dismissOnOverlayTap = true,
    this.clampToViewport = true,
    this.onOpenChange,
  });

  final ModalTriggerBuilder trigger;
  final ModalContentBuilder content;
  final ModalTransitionBuilder transition;

  /// Where the content sits in the theatre. Centre for a dialog, an edge for a
  /// sheet or a drawer.
  final Alignment alignment;

  /// `anim-jelly-in` is 420ms and `anim-jelly-out` 250 — *"leaving should never
  /// take as long as arriving"* (globals.css L2379–2381). The two are separate
  /// because a CSS exit animation is a different animation, not the entrance
  /// played backwards.
  final Duration enterDuration;
  final Duration exitDuration;

  /// The scrim's own clock, which is **not** the content's: the overlay runs
  /// `--duration-overlay` 320ms while the content runs 420 in and 250 out.
  final Duration overlayDuration;

  /// vaul's drawer fades its scrim on its own curve; everything else uses
  /// `--ease-out` via the `[class*="animate-in"]` bridge.
  final Curve overlayCurve;

  /// `onPointerDownOutside` — true everywhere but the alert dialog, which
  /// *"cannot be dismissed by clicking outside"* and was measured refusing to.
  final bool dismissOnOverlayTap;

  /// USER-ORDERED MOBILE ADAPTATION — whether the content is held inside
  /// [CompactDialogLayout]'s 90vw x 75vh box on a phone.
  ///
  /// On for the centred modals, which is what the order names: dialog, alert
  /// dialog, and the agent launcher's console dialog. **Off for the sheet and
  /// the drawer**, and the reason is that an edge-anchored panel's size is
  /// already viewport-relative and already an answer to the same question — a
  /// side sheet is deliberately full-height, so a 75vh cap would crop it, and
  /// the drawer is deliberately full-width under vaul's own `max-h-[80vh]`, so
  /// a 90vw cap would un-bleed it. Those two clamp themselves instead; see
  /// `sheet.dart` and `drawer.dart`.
  final bool clampToViewport;

  /// Fires with the new state whenever the overlay opens or closes.
  final ValueChanged<bool>? onOpenChange;

  @override
  State<OverlayPortal> createState() => OverlayPortalState();
}

/// The state, public so a caller holding a [GlobalKey] can drive the overlay
/// from outside — which is what the drawer's drag-to-dismiss needs.
class OverlayPortalState extends State<OverlayPortal>
    with TickerProviderStateMixin {
  /// USER-ORDERED MOBILE ADAPTATION — every open portal in the app, oldest
  /// first. See the library doc's adaptation 2.
  ///
  /// Static because *"the topmost open overlay"* is a property of the app and
  /// not of any one portal. Two dialogs open at once are two unrelated
  /// [OverlayPortal]s — a confirmation raised from inside another dialog's
  /// content is a portal nested in the element tree but a **sibling** here —
  /// and back has to pick exactly one of them. A per-widget [PopScope] cannot:
  /// [ModalRoute] notifies *every* registered entry on a blocked pop, so
  /// without this list a single back press would close the whole stack at
  /// once. Each entry is notified, checks whether it is [_stack]'s last, and
  /// all but one return.
  static final List<OverlayPortalState> _stack = <OverlayPortalState>[];

  /// The open portals, oldest first. Read-only, and exposed for the tests that
  /// pin the unwind order.
  static List<OverlayPortalState> get openModals =>
      List<OverlayPortalState>.unmodifiable(_stack);

  final OverlayPortalController _portal = OverlayPortalController();

  /// Built in [initState] rather than lazily, on `Popover`'s hard-won
  /// precedent: a modal that never opened would otherwise construct its
  /// controller inside [dispose], where creating a ticker means an
  /// inherited-widget lookup on an element that is already deactivated.
  late final AnimationController _content;
  late final AnimationController _overlay;

  bool _open = false;

  /// Where the focus was standing when this modal opened.
  ///
  /// A modal takes the focus; something has to give it back. Nothing else
  /// will: the overlay child is torn out of the tree on close, and a focus
  /// node that leaves the tree leaves the focus nowhere — the next Tab starts
  /// again from the top of the page rather than from the control the reader
  /// opened the modal with.
  FocusNode? _restoreTo;

  /// The panel's scope: what traps Tab inside the modal and what Escape is
  /// heard on.
  late final FocusScopeNode _scope = FocusScopeNode(debugLabel: 'Modal');

  /// Whether the overlay is showing — the trigger's `data-state`.
  bool get isOpen => _open;

  @override
  void initState() {
    super.initState();
    _content = AnimationController(
      vsync: this,
      duration: widget.enterDuration,
      reverseDuration: widget.exitDuration,
    );
    _overlay = AnimationController(
      vsync: this,
      duration: widget.overlayDuration,
    );
  }

  @override
  void dispose() {
    // A portal torn down while open — a route pushed over it and disposed, a
    // hot reload — must not leave a dead entry for back to aim at.
    _stack.remove(this);
    _content.dispose();
    _overlay.dispose();
    _scope.dispose();
    super.dispose();
  }

  Duration _timed(Duration d) => effectiveMotionDuration(context, d);

  void open() {
    if (_open) return;
    _restoreTo = FocusManager.instance.primaryFocus;
    _stack.add(this);
    setState(() => _open = true);
    _portal.show();
    _content
      ..duration = _timed(widget.enterDuration)
      ..reverseDuration = _timed(widget.exitDuration)
      ..forward(from: 0);
    _overlay
      ..duration = _timed(widget.overlayDuration)
      ..forward(from: 0);
    _takeFocus();
    widget.onOpenChange?.call(true);
  }

  /// Moves the focus into the modal, on the frame after it exists.
  ///
  /// `FocusScope(autofocus: true)` is not enough on its own: the framework
  /// honours autofocus only while the enclosing scope has **no** focused child,
  /// and the trigger that just opened this modal is that child every time a
  /// keyboard opened it. The result was a dialog that trapped nothing, because
  /// the focus was still outside it — Tab went on walking the page behind.
  ///
  /// [FocusScopeNode.nextFocus] rather than a plain request: Radix moves to the
  /// **first tabbable child**, measured as the Cancel button, and a scope that
  /// merely focuses itself would leave the first Tab landing there instead.
  void _takeFocus() {
    WidgetsBinding.instance.addPostFrameCallback((Duration _) {
      if (!mounted || !_open) return;
      _scope.requestFocus();
      if (_scope.focusedChild == null) _scope.nextFocus();
    });
  }

  void close() {
    if (!_open) return;
    // Off the stack the moment the dismissal is decided, not when the exit
    // animation lands: a second back press 100ms later must reach whatever is
    // underneath rather than this one again.
    _stack.remove(this);
    setState(() => _open = false);
    _overlay.reverse();
    _content.reverse().whenComplete(() {
      // A reopen mid-exit takes the controller forward again; only the run
      // that actually reached zero may pull the overlay.
      if (_content.value != 0 || !mounted) return;
      _portal.hide();
    });
    _restoreFocus();
    widget.onOpenChange?.call(false);
  }

  /// Hands the focus back to whatever held it before the modal opened.
  ///
  /// Attempted only while that node is still attached: a trigger inside a list
  /// the modal itself removed is gone by now, and asking a detached node for
  /// the focus throws rather than failing quietly.
  void _restoreFocus() {
    final FocusNode? node = _restoreTo;
    _restoreTo = null;
    if (node == null || !node.canRequestFocus || node.context == null) return;
    node.requestFocus();
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    if (event.logicalKey != LogicalKeyboardKey.escape) {
      return KeyEventResult.ignored;
    }
    // Escape closes every modal on the page — the alert dialog included, which
    // was measured closing on Escape despite the section's own copy promising
    // *"no escape-to-cancel by accident"*. Drift, reproduced.
    close();
    return KeyEventResult.handled;
  }

  /// USER-ORDERED MOBILE ADAPTATION — the Android back button and the
  /// predictive-back gesture. See the library doc's adaptation 2.
  ///
  /// Reached through [PopScope] on the *page's* route, which is where this
  /// widget lives even when its content is painted into the overlay theatre.
  /// [didPop] is true only when the route actually popped, which [PopScope]'s
  /// `canPop: !isOpen` has already prevented; the interesting call is the
  /// cancelled one.
  ///
  /// **Unconditional**, unlike Escape: `dismissOnOverlayTap` and the
  /// reference's Escape drifts do not reach here. On a phone the only other
  /// outcome of a back press is leaving the app.
  void _onPop(bool didPop, Object? result) {
    if (didPop || !_open) return;
    // Every entry on the route is notified; only the topmost acts.
    if (_stack.isNotEmpty && !identical(_stack.last, this)) return;
    close();
  }

  Widget _buildOverlay(BuildContext context) {
    // USER-ORDERED MOBILE ADAPTATION 1 — the compact clamp, applied once, at
    // the host, so every modal that rides this portal inherits it and none of
    // them re-states it. Outside the transition rather than inside because
    // every transition in the family is paint-only: the constraint would land
    // in the same place either way, and this way the panel's own build sees
    // the clamped box directly.
    Widget panel = widget.transition(
      context,
      _content,
      Builder(builder: (BuildContext c) => widget.content(c, close)),
    );
    if (widget.clampToViewport) {
      panel = ConstrainedBox(
        constraints: CompactDialogLayout.constraintsFor(
          MediaQuery.sizeOf(context),
        ),
        child: panel,
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        // A modal is modal to assistive technology too. Without this the page
        // behind an open dialog is still there to be swiped through: the
        // scrim stops the pointer and stops nothing else, and a reader would
        // walk out of the modal without ever being told it had opened.
        const BlockSemantics(),
        FadeTransition(
          opacity: CurvedAnimation(
            parent: _overlay,
            curve: widget.overlayCurve,
            reverseCurve: widget.overlayCurve.flipped,
          ),
          child: Semantics(
            // Named the way the framework's own barrier is named, and offered
            // as a control only while tapping it actually dismisses.
            button: widget.dismissOnOverlayTap,
            label: widget.dismissOnOverlayTap ? _dismissLabel : null,
            onTap: widget.dismissOnOverlayTap ? close : null,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: widget.dismissOnOverlayTap ? close : null,
              child: const DialogOverlay(),
            ),
          ),
        ),
        Align(
          alignment: widget.alignment,
          child: FocusScope(
            node: _scope,
            // Radix moves focus to the first tabbable child on open — measured
            // as the Cancel button, with `:focus-visible` NOT matching, so
            // nothing is painted either way. The scope is what makes Escape
            // reachable and what keeps Tab inside the overlay.
            onKeyEvent: _onKey,
            child: Semantics(
              // The panel is the route as far as a reader is concerned: it is
              // announced on arrival, and its children are read one by one
              // rather than merged into a single unreadable string.
              scopesRoute: true,
              explicitChildNodes: true,
              child: panel,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) => PopScope<Object?>(
    // USER-ORDERED MOBILE ADAPTATION 2. [PopScope] paints nothing and
    // measures nothing — it builds its child verbatim — so the trigger's
    // box is untouched, which matters for the agent launcher whose trigger
    // is required to measure [Size.zero].
    canPop: !_open,
    onPopInvokedWithResult: _onPop,
    child: flutter.OverlayPortal(
      controller: _portal,
      overlayChildBuilder: _buildOverlay,
      child: widget.trigger(context, open),
    ),
  );
}

/// `DialogOverlay` — `fixed inset-0 bg-background/15
/// supports-backdrop-filter:backdrop-blur-xs`.
///
/// Shared by dialog, alert dialog, sheet and drawer: all four class lists are
/// byte-identical apart from the `isolate` the dialog's carries, which has no
/// paint of its own.
class DialogOverlay extends StatelessWidget {
  const DialogOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return BackdropFilter(
      filter: ui.ImageFilter.blur(sigmaX: Blurs.xs, sigmaY: Blurs.xs),
      child: ColoredBox(
        color: theme.background.withValues(alpha: _barrierAlpha),
      ),
    );
  }
}

/* ── The jelly ───────────────────────────────────────────────────────────── */

/// `anim-jelly-in` and `anim-jelly-out`, on one animation.
///
/// ```css
/// @keyframes yuki-jelly-in {
///   0%   { opacity: 0; transform: scale(0.92) translateY(24px); }
///   60%  { opacity: 1; transform: scale(1.02) translateY(-4px); }
///   100% { opacity: 1; transform: scale(1)    translateY(0);    }
/// }
/// @keyframes yuki-jelly-out {
///   0%   { opacity: 1; transform: scale(1)    translateY(0);    }
///   30%  { opacity: 1; transform: scale(1.01) translateY(-4px); }
///   100% { opacity: 0; transform: scale(0.94) translateY(16px); }
/// }
/// ```
///
/// Two things the CSS says that a naive lerp would get wrong, and both were
/// confirmed on the trace:
///
///  1. **The easing runs per *segment*, not across the whole animation.** CSS
///     applies `animation-timing-function` between each pair of keyframes, so
///     `--ease-spring` is spent twice on the way in: once over 0→60% and again
///     over 60→100%. Measured: the peak scale 1.02 lands at 252ms, which is
///     60% of 420 and not the 57% a single spring across the whole run would
///     put it at.
///  2. **`scale()` precedes `translateY()`, so the translate is scaled.** The
///     first frame measures `matrix(0.92, 0, 0, 0.92, 0, 22.08)` — 22.08 is
///     0.92 x 24, not 24. Wrapping the translate *inside* the scale is what
///     reproduces that.
class OpenTransition extends StatelessWidget {
  const OpenTransition({
    super.key,
    required this.animation,
    required this.child,
  });

  final Animation<double> animation;
  final Widget child;

  /// The one keyframe stop `yuki-jelly-in` declares between its ends.
  static const double _inBreak = 0.60;

  /// `yuki-jelly-out`'s.
  static const double _outBreak = 0.30;

  /// The in-keyframes, as (scale, translateY, opacity) at 0 / 60 / 100.
  static const List<double> _inScale = <double>[0.92, 1.02, 1];
  static const List<double> _inShift = <double>[24, -4, 0];

  /// The out-keyframes at 0 / 30 / 100.
  static const List<double> _outScale = <double>[1, 1.01, 0.94];
  static const List<double> _outShift = <double>[0, -4, 16];

  static double _lerp(double a, double b, double t) => a + (b - a) * t;

  /// The state at [progress] along whichever keyframe list is running.
  ///
  /// [progress] is the animation's own 0→1 for the entrance; for the exit it is
  /// `1 - value`, because `yuki-jelly-out` is a forward animation of its own
  /// and not the entrance reversed.
  static ({double scale, double shift, double opacity}) sample(
    double progress, {
    required bool entering,
  }) {
    final double t = progress.clamp(0.0, 1.0);
    if (entering) {
      if (t <= _inBreak) {
        final double local = MotionCurves.emphasized.transform(t / _inBreak);
        return (
          scale: _lerp(_inScale[0], _inScale[1], local),
          shift: _lerp(_inShift[0], _inShift[1], local),
          // `opacity: 0 → 1` over the same first segment.
          opacity: local.clamp(0.0, 1.0),
        );
      }
      final double local = MotionCurves.emphasized.transform(
        (t - _inBreak) / (1 - _inBreak),
      );
      return (
        scale: _lerp(_inScale[1], _inScale[2], local),
        shift: _lerp(_inShift[1], _inShift[2], local),
        opacity: 1,
      );
    }
    if (t <= _outBreak) {
      final double local = MotionCurves.move.transform(t / _outBreak);
      return (
        scale: _lerp(_outScale[0], _outScale[1], local),
        shift: _lerp(_outShift[0], _outShift[1], local),
        opacity: 1,
      );
    }
    final double local = MotionCurves.move.transform(
      (t - _outBreak) / (1 - _outBreak),
    );
    return (
      scale: _lerp(_outScale[1], _outScale[2], local),
      shift: _lerp(_outShift[1], _outShift[2], local),
      opacity: 1 - local.clamp(0.0, 1.0),
    );
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: animation,
    child: child,
    builder: (BuildContext context, Widget? child) {
      final bool entering = animation.status != AnimationStatus.reverse;
      final ({double scale, double shift, double opacity}) frame = sample(
        entering ? animation.value : 1 - animation.value,
        entering: entering,
      );
      return Opacity(
        opacity: frame.opacity.clamp(0.0, 1.0),
        child: Transform.scale(
          scale: frame.scale,
          // Inside the scale, because `scale() translateY()` scales the
          // translate — see the class doc.
          child: Transform.translate(
            offset: Offset(0, frame.shift),
            child: child,
          ),
        ),
      );
    },
  );
}

/* ── The dialog ──────────────────────────────────────────────────────────── */

/// `DialogContent variant` — *"not a separate modal"*, per the page's own copy:
/// *"It keeps the same focus trap, overlay, dismissal, motion,
/// title/description wiring and action components."*
enum DialogVariant {
  /// The three-zone default: banded header, lit body, banded footer.
  normal,

  /// `gap-0 overflow-hidden p-0 sm:max-w-md` — the full-bleed visual lead.
  /// Both bands lose their fill, their rule and their negative margins.
  media,
}

/// `Dialog` — trigger, portal, overlay, content.
class Dialog extends StatelessWidget {
  const Dialog({
    super.key,
    required this.trigger,
    required this.content,
    this.onOpenChange,
  });

  final ModalTriggerBuilder trigger;
  final ModalContentBuilder content;
  final ValueChanged<bool>? onOpenChange;

  @override
  Widget build(BuildContext context) => OverlayPortal(
    trigger: trigger,
    content: content,
    onOpenChange: onOpenChange,
    transition:
        (BuildContext context, Animation<double> animation, Widget child) =>
            OpenTransition(animation: animation, child: child),
  );
}

/// `DialogContent` — the panel itself.
class DialogContent extends StatelessWidget {
  const DialogContent({
    super.key,
    required this.children,
    this.variant = DialogVariant.normal,
    this.showCloseButton = true,
    this.onClose,
  });

  /// The grid's children, in order. A [DialogHeader] first and a
  /// [DialogFooter] last is the anatomy, but the class list enforces none of
  /// it and neither does this.
  final List<Widget> children;

  final DialogVariant variant;

  /// `showCloseButton`, defaulted on by the reference. Turning it off also
  /// drops the header's `pr-12`, because the reservation is
  /// `group-data-[close-button]/dialog-content:pr-12` — *"only when there is
  /// one to reserve for, hence the group-data hook rather than a blanket
  /// `pr-12`"*.
  final bool showCloseButton;

  /// Wired by [Dialog]; the X calls it.
  final VoidCallback? onClose;

  /// `sm:max-w-sm` — 384.
  static double get maxWidth => Containers.sm;

  /// `sm:max-w-md` — 448, the media variant.
  static double get mediaMaxWidth => Containers.md;

  /// `p-4` / `gap-4`, both zero on the media variant.
  static double get padding => space(4);

  /// `rounded-xl`.
  static double get radius => Radii.xl;

  /// `ring-1 ring-foreground/10`, and **nothing under it** — measured, the
  /// content's whole `box-shadow` is this one spread ring. A dialog needs no
  /// elevation because the scrim already separates it from the page.
  static ShadowStyle get ringSpec => ShadowStyle(<ShadowLayer>[
    ShadowLayer(
      0,
      0,
      0,
      BorderWidths.hairline,
      (ThemeTokens t) => t.foreground.withValues(alpha: _ringAlpha),
    ),
  ]);

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final bool media = variant == DialogVariant.media;
    final BorderRadius shape = BorderRadius.circular(radius);
    final double gap = media ? 0 : padding;

    // The grid, with `p-4` paid on the BODY children only: the header and the
    // footer cancel it with `-mx-4 -mt-4` / `-mx-4 -mb-4`, so in layout terms
    // they are simply flush. See the library doc.
    final List<Widget> rows = <Widget>[];
    for (int i = 0; i < children.length; i++) {
      if (i > 0 && gap > 0) rows.add(SizedBox(height: gap));
      final Widget child = children[i];
      final bool bleeds =
          child is DialogHeader ||
          child is DialogFooter ||
          child is DialogMedia;
      rows.add(
        bleeds
            ? child
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: padding),
                child: child,
              ),
      );
    }
    // `p-4`'s top and bottom, which only the body pays for: a leading header or
    // a trailing footer has already cancelled its side.
    final bool padTop =
        !media &&
        children.isNotEmpty &&
        children.first is! DialogHeader &&
        children.first is! DialogMedia;
    final bool padBottom =
        !media && children.isNotEmpty && children.last is! DialogFooter;

    final List<Widget> column = <Widget>[
      if (padTop) SizedBox(height: padding),
      ...rows,
      if (padBottom) SizedBox(height: padding),
    ];

    // USER-ORDERED MOBILE ADAPTATION — the body scrolls, the bands do not.
    //
    // A leading band and a trailing band are lifted out of the column and the
    // rest is put in a [SingleChildScrollView] under a **loose** [Flexible],
    // which is the whole of it: loose fit means the scroller is offered the
    // slack and takes only what its content needs, so with room to spare the
    // column is laid out exactly as it was before this existed and every
    // measured pin still reads the same number. The scroll only engages once
    // the incoming maximum actually binds — [CompactDialogLayout]'s 75vh on a
    // phone, or a viewport shorter than the panel anywhere else.
    //
    // Pinning the bands rather than scrolling the whole panel is the reference
    // author's own reasoning, applied one screen size down: the header names
    // the task and the footer *is* the decision, so they are the two things a
    // reader must not have to scroll to find. `dialog.tsx` puts it as *"three
    // readable zones"*, and on a phone only the middle one may move.
    final bool bandFirst =
        children.isNotEmpty &&
        (children.first is DialogHeader || children.first is DialogMedia);
    final bool bandLast = children.isNotEmpty && children.last is DialogFooter;
    final Widget? head = bandFirst ? column.removeAt(0) : null;
    final Widget? foot = bandLast ? column.removeLast() : null;

    Widget panel = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ?head,
        Flexible(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: column,
            ),
          ),
        ),
        ?foot,
      ],
    );

    if (showCloseButton) {
      panel = Stack(
        children: <Widget>[
          panel,
          Positioned(
            // `absolute top-2 right-2`.
            top: space(2),
            right: space(2),
            child: _CloseButton(onPressed: onClose, media: media),
          ),
        ],
      );
    }

    return DialogContentGroup(
      showCloseButton: showCloseButton,
      variant: variant,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: media ? mediaMaxWidth : maxWidth),
        child: DefaultTextStyle(
          // `text-sm text-popover-foreground`.
          style: StyledText.styleOf(
            context,
            TextStyles.body,
            color: theme.popoverForeground,
          ),
          child: Surface(
            spec: ringSpec,
            radius: shape,
            fill: theme.popover,
            // `overflow-hidden` on the media variant, so the artwork's square
            // corners are cut by the panel's.
            child: media ? ClipRRect(borderRadius: shape, child: panel) : panel,
          ),
        ),
      ),
    );
  }
}

/// The `group/dialog-content` the bands read their two `group-data-*` hooks
/// off — `data-close-button` and `data-variant`.
class DialogContentGroup extends InheritedWidget {
  const DialogContentGroup({
    super.key,
    required this.showCloseButton,
    required this.variant,
    required super.child,
  });

  final bool showCloseButton;
  final DialogVariant variant;

  static DialogContentGroup? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<DialogContentGroup>();

  @override
  bool updateShouldNotify(DialogContentGroup old) =>
      old.showCloseButton != showCloseButton || old.variant != variant;
}

/// `absolute top-2 right-2`, `size="icon-sm"`, `variant="ghost"`.
class _CloseButton extends StatelessWidget {
  const _CloseButton({required this.onPressed, required this.media});

  final VoidCallback? onPressed;

  /// The media variant adds `bg-popover/80
  /// supports-backdrop-filter:backdrop-blur-xs`, because here the button lands
  /// on the artwork instead of on a muted band.
  final bool media;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final Widget button = Button(
      variant: ButtonVariant.ghost,
      size: ButtonSize.iconSm,
      label: 'Close',
      onPressed: onPressed,
      child: const Icon(IconGlyph.x),
    );
    if (!media) return button;
    return ClipRRect(
      borderRadius: BorderRadius.circular(Radii.full),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: Blurs.xs, sigmaY: Blurs.xs),
        child: ColoredBox(
          color: theme.popover.withValues(alpha: _mediaCloseAlpha),
          child: button,
        ),
      ),
    );
  }
}

/* ── The bands ───────────────────────────────────────────────────────────── */

/// `DialogHeader` — the muted band that names the task.
class DialogHeader extends StatelessWidget {
  const DialogHeader({super.key, required this.children});

  /// `flex flex-col gap-2`.
  final List<Widget> children;

  /// `pr-12` — the lane the absolutely-positioned close button lands in.
  static double get closeButtonLane => space(12);

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final DialogContentGroup? group = DialogContentGroup.maybeOf(context);
    final bool media = group?.variant == DialogVariant.media;
    final double pad = DialogContent.padding;
    final double right = (group?.showCloseButton ?? true) && !media
        ? closeButtonLane
        : pad;

    final Widget stack = Padding(
      padding: media
          // `p-4 pb-2`.
          ? EdgeInsets.fromLTRB(pad, pad, pad, space(2))
          : EdgeInsets.fromLTRB(pad, pad, right, pad),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (int i = 0; i < children.length; i++) ...<Widget>[
            if (i > 0) SizedBox(height: space(2)),
            children[i],
          ],
        ],
      ),
    );

    if (media) return stack;
    // [Container], not [DecoratedBox]: `box-sizing: border-box` pays for the
    // rule out of the band's own 93.13px, and only Container adds
    // `decoration.padding` for a border. Measured — the header's bottom edge is
    // its rule.
    return Container(
      decoration: BoxDecoration(
        color: theme.muted.withValues(alpha: _bandAlpha),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(DialogContent.radius),
        ),
        border: Border(
          bottom: BorderSide(color: theme.border, width: BorderWidths.hairline),
        ),
      ),
      child: stack,
    );
  }
}

/// `DialogFooter` — *"the CTAs"*, banded to match.
class DialogFooter extends StatelessWidget {
  const DialogFooter({super.key, required this.children});

  /// `flex flex-col-reverse gap-2 sm:flex-row sm:justify-end`. The port renders
  /// the `sm:` branch, which is the one every measured frame is in.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final bool media =
        DialogContentGroup.maybeOf(context)?.variant == DialogVariant.media;
    final double pad = DialogContent.padding;

    final Widget row = Padding(
      padding: media
          // `p-4 pt-2`.
          ? EdgeInsets.fromLTRB(pad, space(2), pad, pad)
          : EdgeInsets.all(pad),
      // Actions wrap rather than clip: two or three labels at a large text
      // scale, or in a language that spells them longer, do not share one
      // line on a phone.
      child: Wrap(
        alignment: WrapAlignment.end,
        spacing: space(2),
        runSpacing: space(2),
        children: children,
      ),
    );

    if (media) return row;
    return Container(
      decoration: BoxDecoration(
        color: theme.muted.withValues(alpha: _bandAlpha),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(DialogContent.radius),
        ),
        border: Border(
          top: BorderSide(color: theme.border, width: BorderWidths.hairline),
        ),
      ),
      child: row,
    );
  }
}

/// `DialogTitle` — `font-heading text-base leading-none font-medium`.
class DialogTitle extends StatelessWidget {
  const DialogTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) =>
      StyledText(text, TextStyles.h4, color: ThemeScope.of(context).foreground);
}

/// `DialogDescription` — `text-sm text-muted-foreground`.
class DialogDescription extends StatelessWidget {
  const DialogDescription(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => StyledText(
    text,
    TextStyles.body,
    color: ThemeScope.of(context).mutedForeground,
  );
}

/// `DialogMedia` — *"Full-bleed visual lead for announcement, editorial and
/// promotional dialogs. It is an anatomy slot of `DialogContent
/// variant="media"`, not another modal."*
///
/// `relative aspect-video overflow-hidden bg-muted` — measured 448 x 252, which
/// is 16:9 to the pixel.
class DialogMedia extends StatelessWidget {
  const DialogMedia({super.key, required this.child});

  final Widget child;

  /// `aspect-video`.
  static const double aspect = 16 / 9;

  @override
  Widget build(BuildContext context) => flutter.AspectRatio(
    aspectRatio: aspect,
    child: ClipRect(
      child: ColoredBox(color: ThemeScope.of(context).muted, child: child),
    ),
  );
}

/// What a screen reader calls the scrim behind a dismissible modal.
///
/// English only, like every other string in this package: the port carries no
/// localisation layer, and inventing one for a single word would be a bigger
/// claim than the package can keep.
const String _dismissLabel = 'Dismiss';
