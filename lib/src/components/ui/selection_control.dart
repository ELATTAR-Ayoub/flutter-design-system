/// What `Checkbox`, `RadioGroupItem` and `Switch` share.
///
/// The reference shares two things between the three and duplicates the rest:
///
///  * `use-replay-on-state-change.ts` — one hook, imported by all three, which
///    replays the squash on every real state change and never on mount. That
///    is [StateChangeFeedback].
///  * `checkboxControlClassName` / `radioControlClassName` — two exported
///    strings that are character-identical apart from the corner
///    (`rounded-sm` against `rounded-full aspect-square`). `Switch` restates
///    the same idea a third time with a longer transition list.
///
/// The socket, the focus ring, the invalid ring, the disabled dimming, the
/// keyboard path and the invisible hit-area expander are identical across all
/// three, so they are stated once here as [SelectionControl] and each
/// component supplies only its own skin — the same split `Button` makes
/// between `_ButtonSkin` and the widget that wears it.
///
/// **`aria-invalid` beats `focus-visible`** *(forms-map §3.3, measured)*. The
/// invalid rules are emitted later in the built stylesheet at equal
/// specificity, so a focused invalid control is pixel-identical to an
/// unfocused invalid one: focusing an errored checkbox produces **no visible
/// change**. RULES §7 opens with *"Focus always visible, never removed"*, and
/// this is the one place the system contradicts it. Reproduced exactly
/// (supervisor ruling F5) — it is visible, it is measured, and it is what the
/// page renders.
library;

import 'package:flutter/rendering.dart';
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

import './surface.dart';
import '../../design_system/foundation/motion.dart';
import '../../design_system/foundation/shadows.dart';
import '../../design_system/foundation/spacing.dart';
import '../../design_system/foundation/theme.dart';
import './keyframes.dart';
import '../../design_system/foundation/theme_scope.dart';
import './button.dart';

/// `focus-visible:ring-ring/50` — the ring alpha every selection control
/// carries, and the one a `Button` carries too.
const double _focusRingAlpha = 0.50;

/// `aria-invalid:ring-destructive/20`.
const double _invalidRingAlpha = 0.20;

/// `disabled:opacity-50` / `data-disabled:opacity-50`.
///
/// Deliberately not `Button`'s and `Input`'s 45%: the five form controls follow
/// the shadcn default here and the two text surfaces do not (forms-map drift
/// 13). Both numbers ship.
const double _disabledOpacity = 0.50;

/// `after:-inset-x-3` — 12px of invisible target on each side.
double get _hitInsetX => space(3);

/// `after:-inset-y-2` — 8px above and below.
double get _hitInsetY => space(2);

/// The `after:absolute after:-inset-x-3 after:-inset-y-2` pseudo-element, as a
/// hit test rather than as a box.
///
/// ## The insets grow from the PADDING box, not the border box
///
/// *(measured)* An absolutely positioned element resolves `inset` against its
/// containing block's **padding box** (CSS Position §3), and the containing
/// block here is the control itself — every one of them is `position:
/// relative`. So the expander starts one border-width inside the box the
/// widget occupies, and the whole family is 2px narrower and 2px shorter than
/// reading `-inset-*` off the border box suggests:
///
/// | control | border box | padding box | expander *(probed)* |
/// |---|---|---|---|
/// | checkbox / radio | 20 × 20 | 18 × 18 | **42 × 34** |
/// | switch | 44 × 24 | 42 × 22 | **66 × 38** |
/// | slider thumb | 20 × 20 | 18 × 18 | **34 × 34** |
///
/// Probed with `getComputedStyle(space, '::after')` on the live reference at
/// 1440 × 900, which reports the pseudo-element's own `width`/`height`
/// directly. This port shipped the border-box reading first — 44 × 36 and
/// 68 × 40 — and that 2px of extra generosity was a divergence, so it is
/// corrected here in the one place the whole family inherits it from.
///
/// One consequence worth stating plainly: RULES §7 asks for a 44px floor and
/// **the checkbox misses it by 2px**, at 42. That is what the reference
/// renders.
///
/// **Why a render object.** The pseudo-element is `position: absolute`, so it
/// takes no part in layout — the control still occupies 20 × 20 in flow and its
/// label still sits 8px away. Growing the widget instead (Flutter's own
/// `MaterialTapTargetSize.padded` trick) would move every neighbour by 12px, so
/// the box stays the size CSS gives it and only [hitTest] is widened. A point
/// in the margin is forwarded to the child at its centre, which is where the
/// browser sends a click on the pseudo-element too.
class HitArea extends SingleChildRenderObjectWidget {
  const HitArea({
    super.key,
    required this.insets,
    this.border,
    required Widget super.child,
  });

  /// How far past its own **padding** box the control answers a pointer.
  final EdgeInsets insets;

  /// The border [insets] are measured inside, defaulting to the single
  /// hairline every control in this family draws.
  ///
  /// Pass `0` for a wrapper that paints no border of its own — a slider's root
  /// carries its border on the track inside it, and states insets already
  /// measured from its thumb's padding box.
  final double? border;

  /// The rect this expander answers, in the control's own coordinates.
  ///
  /// Exposed for tests because a tap cannot always reach it: **every render
  /// object above this one bounds-checks itself before it asks a child**, so an
  /// ancestor cut to the control's own box rejects a pointer in the margin
  /// before the expander is ever consulted. CSS has no such gate — nothing on
  /// the reference's chain clips — which is why the browser's 42 × 34 is
  /// reachable there and a Flutter tap through a snug parent is not.
  ///
  /// Pass `tester.renderObject(find.byType(HitArea))`.
  @visibleForTesting
  static Rect debugExpanded(RenderObject box) =>
      (box as _RenderHitArea).expanded;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderHitArea(insets, border ?? BorderWidths.hairline);

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderObject renderObject,
  ) {
    (renderObject as _RenderHitArea)
      ..insets = insets
      ..border = border ?? BorderWidths.hairline;
  }
}

class _RenderHitArea extends RenderProxyBox {
  _RenderHitArea(this._insets, this._border);

  EdgeInsets _insets;
  set insets(EdgeInsets value) {
    if (value == _insets) return;
    _insets = value;
  }

  double _border;
  set border(double value) {
    if (value == _border) return;
    _border = value;
  }

  /// The rect the pseudo-element covers, in this box's own coordinates.
  ///
  /// The border comes off first: `inset: -8px` on an absolutely positioned
  /// `::after` is measured from the padding box, so on a 20px control with a
  /// 1px border it reaches 8px out from an **18px** square and not from a 20px
  /// one.
  Rect get expanded => _insets.inflateRect(
    EdgeInsets.all(_border).deflateRect(Offset.zero & size),
  );

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    // Inside the paint, everything is ordinary.
    if (super.hitTest(result, position: position)) return true;
    if (!expanded.contains(position)) return false;

    // Outside it, the click still belongs to the control. Forward it at the
    // centre so the child accepts it in its own coordinates.
    final Offset centre = size.center(Offset.zero);
    return result.addWithRawTransform(
      transform: MatrixUtils.forceToPoint(centre),
      position: centre,
      hitTest: (BoxHitTestResult result, Offset transformed) {
        assert(transformed == centre);
        return child!.hitTest(result, position: centre);
      },
    );
  }
}

/// `use-replay-on-state-change.ts` — replays `anim-jelly` whenever [state]
/// actually changes, in both directions, and never on first paint.
///
/// The hook's own comment explains why it is JavaScript rather than CSS:
/// *"`data-[state=unchecked]:animate-jelly` would fire on mount for every
/// unchecked control on the page, and `:active` only holds while the pointer is
/// down, so a quick click cuts the animation off partway."* A `MutationObserver`
/// does not report initial state, which is the whole trick — so this widget
/// builds [child] bare until the first transition and only then mounts a player.
///
/// The replay itself is a re-key, which is the mechanism `KeyframePlayer`
/// documents: a freshly mounted player starts at t=0, mid-flight restarts
/// included, exactly as the hook's `remove / reflow / re-add` does.
class StateChangeFeedback extends StatefulWidget {
  const StateChangeFeedback({
    super.key,
    required this.state,
    required this.child,
  });

  /// The `data-state` analogue. Any value whose `==` changes on a real
  /// transition; the reference watches the attribute for the same reason and
  /// bails when Radix rewrites it unchanged.
  final Object? state;

  final Widget child;

  @override
  State<StateChangeFeedback> createState() => _JellyReplayState();
}

class _JellyReplayState extends State<StateChangeFeedback> {
  /// The last state seen. Captured in [initState] and deliberately NOT with a
  /// `late` field initialiser: `late` evaluates on first read, the first read
  /// is inside [didUpdateWidget], and by then `widget` is already the new one —
  /// so every comparison would pass and the replay would never fire.
  Object? _last;

  /// Which run is playing. Zero means *"nothing has changed yet"* — the
  /// mount case the observer cannot see.
  int _run = 0;

  @override
  void initState() {
    super.initState();
    _last = widget.state;
  }

  @override
  void didUpdateWidget(StateChangeFeedback old) {
    super.didUpdateWidget(old);
    if (widget.state == _last) return;
    _last = widget.state;
    setState(() => _run++);
  }

  @override
  Widget build(BuildContext context) {
    if (_run == 0) return widget.child;
    return KeyedSubtree(
      key: ValueKey<int>(_run),
      child: KeyframePlayer(
        duration: StateChangeMotion.duration,
        fill: StateChangeMotion.fill,
        builder: (BuildContext context, double t, Widget? child) {
          final Offset scale = StateChangeMotion.scale.transform(t);
          return Transform(
            // `transform-origin` is untouched, so the squash pivots on the
            // control's own centre.
            alignment: Alignment.center,
            transform: Matrix4.diagonal3Values(scale.dx, scale.dy, 1),
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}

/// The socket every selection control sits in.
///
/// Paints [shadow] with [fill] and [border] inside [radius], transitions the
/// two colours over [duration] on `--ease-out`, composites the focus or invalid
/// ring in front of the socket, dims and deafens itself when disabled, answers
/// Enter and Space, and squashes on every change of [jellyState].
///
/// **Operable, [inert] and disabled are three states, not two.** `disabled`
/// dims a control and takes it out of the tab order; a controlled control with
/// no handler does neither and still cannot be operated. Both ship, because a
/// state matrix renders both.
class SelectionControl extends StatefulWidget {
  const SelectionControl({
    super.key,
    required this.width,
    required this.height,
    required this.radius,
    required this.fill,
    required this.border,
    required this.shadow,
    required this.duration,
    required this.jellyState,
    required this.child,
    this.onTap,
    this.enabled = true,
    this.inert = false,
    this.invalid = false,
    this.forceFocusRing,
    this.focusNode,
    this.skipTraversal = false,
    this.onKey,
    this.semantics,
  });

  /// The painted size.
  ///
  /// The hit target is the **padding** box — this less a border on each side —
  /// grown by 24 horizontally and 16 vertically, so a 20px control answers
  /// 42 × 34. See [HitArea] for the measurement.
  final double width;
  final double height;

  final BorderRadius radius;

  /// `background-color` at rest for the state the caller is in.
  final Color fill;

  /// `border-color` at rest. Overridden while focused or invalid.
  final Color border;

  /// The `--shadow-*` token for the state the caller is in — `shadow-pressed`
  /// at rest, `shadow-btn-primary` once checked or on.
  final ShadowStyle shadow;

  /// [MotionDurations.normal] for all three controls.
  ///
  /// The class lists disagree — `duration-fast` on checkbox and radio,
  /// `duration-base` on the switch — and neither utility exists in Tailwind v4,
  /// so all three sockets fall through to `--default-transition-duration` and
  /// run at the same speed. Probed, not read off the class list.
  final Duration duration;

  /// Handed to [StateChangeFeedback]; a change replays the squash.
  final Object? jellyState;

  /// The indicator, centred in the socket.
  final Widget child;

  /// `null` disables the control.
  final VoidCallback? onTap;

  /// Separate from [onTap] being null: a `Field` can disable a control that
  /// still has a handler, and `Switch` spells its own disabled state
  /// `data-disabled` rather than `:disabled` (forms-map drift 14).
  final bool enabled;

  /// `checked="indeterminate"` with **no** `onCheckedChange` — a control Radix
  /// holds at the value it was handed, forever.
  ///
  /// It carries no `disabled`, so what the browser renders is a live
  /// `<button>`: **fully opaque, still in the tab order, still ringing on
  /// `:focus-visible`**, and a click on it changes nothing only because there is
  /// no handler to call *(measured on the reference's Indeterminate cell:
  /// `disabled: false`, opacity 1)*. Three distinct states result, and all three
  /// ship:
  ///
  /// | | paints | pointer / keyboard | tab order |
  /// |---|---|---|---|
  /// | operable | full strength | operates | in |
  /// | [inert] | **full strength** | deaf | **in** |
  /// | `enabled: false` | dimmed by half | deaf | out |
  ///
  /// Only the last of those three columns is new. `enabled` already drove the
  /// dimming while `enabled && onTap != null` drove the deafness, so a control
  /// with no handler was *already* opaque and *already* deaf — and only its
  /// focusability was wrong (measured: `Opacity.opacity` 1.0,
  /// `IgnorePointer.ignoring` true, `Focus.canRequestFocus` **false**). This
  /// flag closes that one gap and nothing else.
  ///
  /// It beats [onTap]: *inert* is a statement about the control, not about
  /// whether a caller happened to pass a handler.
  ///
  /// DOCUMENTED DRIFT (selection-map drift 7): this is the one specimen on the
  /// reference page a reader can click with no result and no explanation.
  /// Reproduced, because it is what the page renders.
  final bool inert;

  /// `aria-invalid="true"`.
  final bool invalid;

  /// `className="border-ring ring-3 ring-ring/50"` — the focus ring worn by a
  /// control that does not have the focus.
  ///
  /// The reference's two "Focus" cells are **static fakes** *(selection-map
  /// §4.1 cell 4, drift 6)*: `cn()` is `extendTailwindMerge`, and `border-input`
  /// and `border-ring` are one `border-color` group, so the merge deletes
  /// `border-input` from the class string outright and what remains is a
  /// permanent box-shadow. Nothing on that page is focused — and two such cells
  /// sit on one page, which real focus cannot answer, there being exactly one of
  /// it.
  ///
  /// `true` paints the ring, `false` withholds it even while genuinely focused,
  /// and `null` — the default — follows the focus like any other control. One
  /// flag drives the border and the ring together because the two classes always
  /// travel together.
  ///
  /// [invalid] still beats it, unchanged: `aria-invalid` is tested first in both
  /// colour targets (ruling F5), so a forced ring on an errored control is as
  /// invisible as a real focus is.
  final bool? forceFocusRing;

  final FocusNode? focusNode;

  /// Roving tabindex — a `RadioGroup` is one tab stop, so every item but the
  /// active one leaves the Tab order while staying focusable.
  final bool skipTraversal;

  /// Consulted before Enter and Space, for the keys a group owns rather than
  /// an item: a `RadioGroup`'s arrows select as they move.
  final KeyEventResult Function(KeyEvent)? onKey;

  /// The control's own [Semantics], applied **inside** the hit-area expander.
  ///
  /// It has to go here rather than around the finished widget: every render
  /// object above [HitArea] tests its own bounds before it asks a child, so a
  /// `Semantics` wrapped outside would reject a pointer in the pseudo-element's
  /// margin before the expander ever saw it.
  final Widget Function(Widget)? semantics;

  @override
  State<SelectionControl> createState() => _SelectionControlState();
}

class _SelectionControlState extends State<SelectionControl> {
  bool _focused = false;

  /// Whether the control can be **operated** — the `:disabled` predicate, plus
  /// the two ways a control ends up with nothing to say.
  bool get _enabled => widget.enabled && !widget.inert && widget.onTap != null;

  /// Whether the control takes the focus, which is deliberately **not**
  /// [_enabled].
  ///
  /// `disabled` removes a `<button>` from the tab order; a missing handler does
  /// not. Reading the same flag for both is what made an inert control
  /// unfocusable, and separating them is the whole of what
  /// [SelectionControl.inert] fixes.
  bool get _focusable =>
      widget.enabled && (widget.inert || widget.onTap != null);

  /// Whether the ring paints: the real focus, or the class list's fake.
  bool get _focusRing => widget.forceFocusRing ?? _focused;

  void _setFocused(bool value) {
    if (_focused == value) return;
    setState(() => _focused = value);
  }

  /// A Radix control is a `<button>`, and a `<button>` activates on Enter and
  /// on Space. Wired by hand for the same reason `Button` wires it: a bare
  /// [Listener] gets neither, and a focus ring on something the keyboard cannot
  /// operate is worse than no ring at all.
  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (!_enabled) return KeyEventResult.ignored;
    final KeyEventResult? owned = widget.onKey?.call(event);
    if (owned != null && owned != KeyEventResult.ignored) return owned;
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final bool activates =
        event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.numpadEnter ||
        event.logicalKey == LogicalKeyboardKey.space;
    if (!activates) return KeyEventResult.ignored;
    widget.onTap!();
    return KeyEventResult.handled;
  }

  /// `focus-visible:border-ring`, beaten by `aria-invalid:border-destructive`.
  Color _borderTarget(ThemeTokens theme) {
    if (widget.invalid) return theme.destructive;
    if (_focusRing) return theme.ring;
    return widget.border;
  }

  /// `focus-visible:ring-3 ring-ring/50`, beaten by `aria-invalid:ring-3
  /// ring-destructive/20`.
  ///
  /// The resting value is the ring hue at **zero alpha** rather than
  /// `transparent`: a ring that fades out through its own colour is what the
  /// browser interpolates, and a 3px spread of nothing paints nothing.
  Color _ringTarget(ThemeTokens theme) {
    if (widget.invalid) {
      return theme.destructive.withValues(alpha: _invalidRingAlpha);
    }
    return theme.ring.withValues(alpha: _focusRing ? _focusRingAlpha : 0);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final Duration duration = effectiveMotionDuration(context, widget.duration);

    Widget control = TweenAnimationBuilder<Color?>(
      tween: ColorTween(end: widget.fill),
      duration: duration,
      curve: MotionCurves.enter,
      builder: (BuildContext context, Color? fill, Widget? child) =>
          TweenAnimationBuilder<Color?>(
            tween: ColorTween(end: _borderTarget(theme)),
            duration: duration,
            curve: MotionCurves.enter,
            builder: (BuildContext context, Color? border, Widget? child) =>
                TweenAnimationBuilder<Color?>(
                  tween: ColorTween(end: _ringTarget(theme)),
                  duration: duration,
                  curve: MotionCurves.enter,
                  builder: (BuildContext context, Color? ring, Widget? child) => Surface(
                    // The ring is ADDED to the socket, never replacing it — the same
                    // composition `Input` makes, for the same reason: the socket is
                    // what makes the control read as operable and it never rises.
                    spec: Button.withFocusRing(
                      widget.shadow,
                      ring ?? theme.ring,
                    ),
                    radius: widget.radius,
                    fill: fill ?? widget.fill,
                    border: Border.all(
                      color: border ?? widget.border,
                      width: BorderWidths.hairline,
                    ),
                    child: Center(child: child),
                  ),
                  child: child,
                ),
            child: child,
          ),
      child: widget.child,
    );

    control = SizedBox(
      width: widget.width,
      height: widget.height,
      child: control,
    );

    control = StateChangeFeedback(state: widget.jellyState, child: control);

    control = Focus(
      focusNode: widget.focusNode,
      canRequestFocus: _focusable,
      skipTraversal: widget.skipTraversal,
      onFocusChange: _setFocused,
      onKeyEvent: _onKey,
      child: control,
    );

    control = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _enabled ? widget.onTap : null,
      child: MouseRegion(
        // No control on this page authors a hover state (forms-map §8.2), so
        // the cursor is the only thing a pointer changes.
        cursor: _enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
        child: control,
      ),
    );

    control = Opacity(
      opacity: widget.enabled ? 1 : _disabledOpacity,
      child: IgnorePointer(ignoring: !_enabled, child: control),
    );

    if (widget.semantics != null) control = widget.semantics!(control);

    // Outermost, and it has to be: every render object above it checks its own
    // bounds before asking a child, so anything wrapped around this one would
    // reject a pointer in the margin before it ever arrived.
    return HitArea(
      insets: EdgeInsets.symmetric(
        horizontal: _hitInsetX,
        vertical: _hitInsetY,
      ),
      child: control,
    );
  }
}
