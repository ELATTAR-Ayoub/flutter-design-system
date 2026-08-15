/// `components/ui/slider.tsx` — a knob sitting in a groove.
///
/// Its docstring is the specification: *"The track is a **sunken channel**
/// (`shadow-pressed`) and each thumb is a **raised knob** (`shadow-btn`), so the
/// handle reads as sitting in the groove rather than on top of a line. The
/// filled range carries the blue glow, which is what makes the selected span
/// read at a glance. 10px track and 20px thumbs rather than stock's 4 and 12 — a
/// price filter is a primary control on the marketplace, not a footnote."*
///
/// | class | value |
/// |---|---|
/// | root `relative flex w-full touch-none items-center` | the root's box IS the track's — **10px** — and the 20px thumbs overflow it by 5 top and bottom |
/// | root `data-disabled:opacity-50` | one dimming, at the root, and only here |
/// | track `grow rounded-pill border border-input bg-muted shadow-pressed data-horizontal:h-2.5` | 10px, 1px `--input`, `--muted`, sunken |
/// | track `overflow-hidden` | which is what gives the range its corners |
/// | range `absolute bg-action-ink shadow-btn-primary data-horizontal:h-full` | 8px — the track's content box — and lit |
/// | thumb `size-5 rounded-full border border-input bg-foreground shadow-btn` | 20px, raised |
/// | thumb `transition-[transform,box-shadow] duration-fast ease-spring` | the ring springs; see [DsTransforms.sliderThumbHoverScale] for what does not |
/// | thumb `after:absolute after:-inset-2` | the hit expander |
/// | thumb `hover:scale-110 hover:ring-3` · `focus-visible:ring-3` · `active:scale-125 active:ring-3` | — |
///
/// `bg-action-ink`, **not** `bg-primary`. The source comment gives the
/// measurement: *"`--primary` measures 1.63:1 there on this palette;
/// `--action-ink` measures 6.88:1."* A filled channel carries no foreground of
/// its own, so its contrast is against `--muted`, and `--action-ink` is the end
/// of the ramp that answers that. Unlike `--primary` it is theme-split, so the
/// fill is [DsThemeData.actionInk] and never [DsThemeData.primary].
///
/// ## The two coordinate spaces
///
/// The range and the thumb are positioned against **different boxes**, and they
/// agree only at 50%. Both formulas below were probed against the live
/// reference and hold exactly on all five sliders the page renders.
///
///  * **Range** — a percentage of the **track's content box**, which is the
///    root minus its 1px border on each side. On the price slider (448 wide,
///    `[10, 240]` of 0–500) that is `10/500 × 446 = 8.92` from the content
///    edge, probed at 8.90625, and `230/500 × 446 = 205.16` wide, probed at
///    205.19.
///  * **Thumb** — Radix writes `left: calc(P% + (50 − P) × thumbSize/100 px)`
///    against the **root's full width** and then pulls it back by
///    `translateX(-50%)`. That whole expression collapses to
///    `fraction × (rootWidth − thumbSize)`: the thumb's left edge travels the
///    root less its own width, so the knob never overhangs either end. Probed
///    exact on four independent cells — 0.25 × 428 = 107, 0.40 × 140 = 56,
///    0.20 × 140 = 28, 0.48 × 428 = 205.44.
///
/// A port that positions both the same way misaligns the fill against the knob
/// at every value but the midpoint. Reproduced as measured (selection-map drift
/// 8); the disagreement is Radix's and it is visible.
///
/// ## What this component deliberately does not do
///
///  * **No jelly.** Alone of the four families it does not import
///    `use-replay-on-state-change`, so there is no [DsJellyReplay] here.
///  * **No field participation.** No `aria-invalid`, no `data-invalid`, no
///    `FieldScope`. It shares the raised/recessed vocabulary with its three
///    siblings and nothing else (selection-map drift 10).
///  * **No vertical orientation.** The root carries `data-vertical:h-full
///    data-vertical:min-h-40 data-vertical:w-auto data-vertical:flex-col` and
///    the track and range each carry a `data-vertical:` size, but **no call
///    site in the corpus sets `orientation="vertical"`**. Recorded dormant
///    rather than built (supervisor ruling S2), on the same precedent as
///    `asChild`: a branch with no consumer is a branch with no oracle.
library;

import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../effects/machine_surface.dart';
import '../foundation/motion.dart';
import '../foundation/shadows.dart';
import '../foundation/spacing.dart';
import '../foundation/theme.dart';
import '../theme_scope.dart';
import 'button.dart';
import 'selection_control.dart';

/// `data-horizontal:h-2.5` — the track, and therefore the root.
double get _trackHeight => ds(2.5);

/// `size-5` — one thumb.
double get _thumbSize => ds(5);

/// `after:-inset-2` — 8px of invisible target around the knob.
///
/// **The expander measures 34 × 34.** An absolutely positioned pseudo-element
/// resolves its insets against the containing block's *padding* box, and the
/// thumb's 20px border box carries a 1px border, so it grows from an 18px
/// square: `18 + 8 + 8 = 34`. [DsHitArea] states that rule once for the whole
/// family and the three shipped controls now follow it too.
double get _hitInset => ds(2);

/// How far the thumb's expander reaches from the knob's own centre — 17px.
///
/// Half the **padding** box plus the inset, which is the same arithmetic
/// behind the 34 × 34 above. Both the pointer target and the hover region are
/// measured with it, because a pseudo-element belongs to its element: hovering
/// the expander hovers the thumb.
double get _thumbReach => _thumbSize / 2 - DsWidths.hairline + _hitInset;

/// `ring-ring/50` — the alpha every ring in the system carries.
const double _ringAlpha = 0.50;

/// `data-disabled:opacity-50`, on the root and nowhere else.
///
/// The thumb's own `disabled:opacity-50` and `disabled:pointer-events-none`
/// **never fire**: Radix renders the thumb as a `<span>` carrying
/// `data-disabled=""` and no `disabled` attribute, and `disabled:` compiles to
/// the `:disabled` pseudo-class, which no `<span>` can match. Probed on the
/// disabled matrix cell — root `opacity: 0.5`, thumb `opacity: 1`. So the knob
/// dims once, through the root, exactly as the track does (selection-map drift
/// 11, supervisor ruling S7: port the render, record the dead classes).
const double _disabledOpacity = 0.50;

/// `PageUp` / `PageDown` move ten steps at once.
///
/// Radix's keyboard contract, not a `--` token — it appears nowhere in
/// `globals.css`. Driven and measured on the live reference: on the price
/// slider (`step={5}`) `PageUp` moves 15 → 65, and on the odds slider
/// (`step={1}`) it moves 85 → 95.
///
// allow-hardcoded: Radix's page-key multiplier, measured on the live reference; it is keyboard behaviour, not a design token.
const int _pageStepMultiplier = 10;

/// A ranged control: a sunken channel, a lit fill, and one raised knob per
/// value.
///
/// Controlled, as every other selection control in this package is and as the
/// reference's own two panels are (`value` + `onValueChange`). The matrix cells
/// pass `defaultValue` and let Radix hold the state; a Flutter caller holds it
/// in a `State` and hands it back through [onChanged], which is the same
/// arrangement `DsCheckbox` and `DsRadioGroup` already ask for.
class DsSlider extends StatefulWidget {
  const DsSlider({
    super.key,
    required this.values,
    this.onChanged,
    this.min = 0,
    this.max = _defaultMax,
    this.step = _defaultStep,
    this.enabled = true,
    this.label,
  });

  /// `max = 100` — the component's own default (`slider.tsx` L23).
  static const double _defaultMax = 100;

  /// Radix's default `step`. The reference sets it explicitly on both panels
  /// (`step={5}` and `step={1}`) and lets the matrix cells inherit it.
  static const double _defaultStep = 1;

  /// `value` — one entry per thumb, ascending. Two entries makes it a range.
  final List<double> values;

  /// `onValueChange`. `null` makes the control inoperable, exactly as it does
  /// on the three shipped siblings.
  final ValueChanged<List<double>>? onChanged;

  /// `min = 0` (`slider.tsx` L22).
  final double min;

  /// `max`.
  final double max;

  /// `step`. Every value this control emits is a whole number of these above
  /// [min], clamped into range.
  final double step;

  /// `disabled` — separate from a null [onChanged] so a disabled surface can
  /// dim a slider that still carries its handler.
  final bool enabled;

  /// `aria-label`. Radix puts `role="slider"` on each **thumb**, so a
  /// single-value control announces this name and a range announces it on both
  /// handles, which is what the reference's `aria-label="Price range"` does.
  final String? label;

  /// `data-horizontal:h-2.5` — 10px, and the height of the whole control.
  static double get trackHeight => _trackHeight;

  /// `size-5` — 20px.
  static double get thumbSize => _thumbSize;

  @override
  State<DsSlider> createState() => _DsSliderState();
}

class _DsSliderState extends State<DsSlider> {
  /// One per thumb — each is its own tab stop, as each `<span role="slider">`
  /// is.
  final List<FocusNode> _nodes = <FocusNode>[];

  /// Which thumb the pointer is inside the expander of, if any.
  int? _hovered;

  /// Which thumb the current drag is moving, if any.
  int? _active;

  /// Which thumb holds focus, if any.
  int? _focused;

  /// The root's own box, for turning a global pointer position into a local
  /// one.
  ///
  /// **Not `event.localPosition`.** [DsHitArea] forwards a hit in the margin to
  /// its child at the control's *centre* — right for a checkbox, where a click
  /// is a click, and wrong here, where `x` IS the value. Worse, the transform
  /// it records is reused for every later event in the same gesture, so a drag
  /// that began below the channel would report the centre forever. The browser
  /// hands Radix `event.clientX` no matter which descendant was hit; this is
  /// that.
  final GlobalKey _rootKey = GlobalKey();

  /// The width the last layout gave the root. Pointer maths needs it outside
  /// [build], where the [LayoutBuilder]'s constraints are no longer in scope.
  double _width = 0;

  bool get _operable => widget.enabled && widget.onChanged != null;

  @override
  void initState() {
    super.initState();
    _syncNodes();
  }

  @override
  void didUpdateWidget(DsSlider old) {
    super.didUpdateWidget(old);
    _syncNodes();
  }

  @override
  void dispose() {
    for (final FocusNode node in _nodes) {
      node.dispose();
    }
    super.dispose();
  }

  /// Keeps one node per value, so a range that gains or loses a thumb does not
  /// leave a node behind or reach past the end of the list.
  void _syncNodes() {
    while (_nodes.length < widget.values.length) {
      _nodes.add(FocusNode(debugLabel: 'DsSlider thumb ${_nodes.length}'));
    }
    while (_nodes.length > widget.values.length) {
      _nodes.removeLast().dispose();
    }
  }

  // ── Value maths ───────────────────────────────────────────────────────────

  double get _span => widget.max - widget.min;

  /// Where [value] sits between [DsSlider.min] and [DsSlider.max], 0 to 1.
  double _fraction(double value) =>
      _span <= 0 ? 0 : ((value - widget.min) / _span).clamp(0.0, 1.0);

  /// The nearest legal value to [raw] — a whole number of steps above the
  /// minimum, held inside the range.
  double _snap(double raw) {
    if (widget.step <= 0) return raw.clamp(widget.min, widget.max);
    final double steps = ((raw - widget.min) / widget.step).roundToDouble();
    return (widget.min + steps * widget.step).clamp(widget.min, widget.max);
  }

  /// What a pointer at [localX] means.
  ///
  /// **Measured against the ROOT's full width**, not against the thumb's
  /// travel. Driven on the live reference and rAF-sampled: on the 448-wide odds
  /// slider a pointer 131px in reported 29, and `131/448 × 100 = 29.24`. That
  /// is the same disagreement the two positioning spaces carry — the knob does
  /// not stay under the finger that is dragging it — and it is reproduced.
  double _valueAt(double localX) =>
      _snap(widget.min + (localX / _width) * _span);

  /// The thumb's left edge, in the root's coordinates.
  double _thumbLeft(double value) =>
      _fraction(value) * (_width - _thumbSize);

  /// The centre of the thumb's expanded target, in the root's coordinates.
  double _thumbCentre(double value) => _thumbLeft(value) + _thumbSize / 2;

  /// Which thumb a press at [localX] takes hold of.
  ///
  /// The nearest one, measured against the rendered knobs. Probed: with
  /// `[10, 240]` on a 0–500 range, a click 30% of the way from the low knob to
  /// the high one moved the **low** thumb to 85 and left the high one alone.
  int _nearestTo(double localX) {
    int best = 0;
    double bestGap = double.infinity;
    for (int i = 0; i < widget.values.length; i++) {
      final double gap = (localX - _thumbCentre(widget.values[i])).abs();
      if (gap < bestGap) {
        bestGap = gap;
        best = i;
      }
    }
    return best;
  }

  /// Moves thumb [index] to [value] and reports the new list.
  ///
  /// A thumb stops at its neighbour rather than passing it, and the two may
  /// come to rest on the same value — probed by dragging the low knob of
  /// `[0, 500]` past the end, which produced `[500, 500]` both during the drag
  /// and after release.
  void _move(int index, double value) {
    if (!_operable) return;
    final double lower =
        index == 0 ? widget.min : widget.values[index - 1];
    final double upper = index == widget.values.length - 1
        ? widget.max
        : widget.values[index + 1];
    final double held = value.clamp(lower, upper);
    if (held == widget.values[index]) return;
    final List<double> next = List<double>.of(widget.values);
    next[index] = held;
    widget.onChanged!(next);
  }

  void _nudge(int index, double delta) =>
      _move(index, _snap(widget.values[index] + delta));

  /// Where thumb [index] would actually come to rest if asked for [value] —
  /// snapped to the step and stopped at its neighbour.
  double _reachable(int index, double value) {
    final double lower = index == 0 ? widget.min : widget.values[index - 1];
    final double upper = index == widget.values.length - 1
        ? widget.max
        : widget.values[index + 1];
    return _snap(value).clamp(lower, upper);
  }

  /// `aria-valuenow`, as a screen reader would say it.
  ///
  /// Whole steps print without a decimal tail — the reference's every slider
  /// is integral (`step` 1 and 5 over integer ranges), so "40" is what the
  /// browser announces and "40.0" would be this port inventing a precision.
  String _announce(double value) => value == value.roundToDouble()
      ? value.toInt().toString()
      : value.toString();

  // ── Pointer ───────────────────────────────────────────────────────────────

  /// [global] in the root's own coordinates, or null before it has laid out.
  Offset? _localOf(Offset global) {
    final RenderObject? box = _rootKey.currentContext?.findRenderObject();
    if (box is! RenderBox || !box.hasSize) return null;
    return box.globalToLocal(global);
  }

  void _grab(Offset local) {
    if (!_operable) return;
    final int index = _nearestTo(local.dx);
    setState(() => _active = index);
    _nodes[index].requestFocus();
    _move(index, _valueAt(local.dx));
  }

  void _drag(Offset local) {
    final int? index = _active;
    if (index == null || !_operable) return;
    _move(index, _valueAt(local.dx));
  }

  void _release() {
    if (_active == null) return;
    setState(() => _active = null);
  }

  /// Which thumb's expander the pointer is inside, or null.
  ///
  /// The expander is a pseudo-element, so hovering it hovers the thumb — which
  /// is why the hover region is the 34 × 34 target and not the 20px knob.
  /// Computed here rather than with a [MouseRegion] per thumb because the
  /// knobs overflow the root's own box, and a render object outside its
  /// parent's bounds never receives a pointer.
  int? _hoveredAt(Offset local) {
    for (int i = 0; i < widget.values.length; i++) {
      if ((local.dx - _thumbCentre(widget.values[i])).abs() <= _thumbReach) {
        return i;
      }
    }
    return null;
  }

  void _hover(Offset local) {
    final int? next = _operable ? _hoveredAt(local) : null;
    if (next == _hovered) return;
    setState(() => _hovered = next);
  }

  // ── Keyboard ──────────────────────────────────────────────────────────────

  /// The arrow, page and home/end contract, driven and measured.
  ///
  /// Right and Up add a step, Left and Down take one away, the page keys move
  /// ten, and Home and End go to the ends. Every one of them lands in a single
  /// frame: the thumb's transition list covers `transform` and `box-shadow`,
  /// and its position is `left`, so nothing interpolates it.
  KeyEventResult _onKey(int index, KeyEvent event) {
    if (event is! KeyDownEvent || !_operable) return KeyEventResult.ignored;
    final double page = widget.step * _pageStepMultiplier;
    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowRight:
      case LogicalKeyboardKey.arrowUp:
        _nudge(index, widget.step);
      case LogicalKeyboardKey.arrowLeft:
      case LogicalKeyboardKey.arrowDown:
        _nudge(index, -widget.step);
      case LogicalKeyboardKey.pageUp:
        _nudge(index, page);
      case LogicalKeyboardKey.pageDown:
        _nudge(index, -page);
      case LogicalKeyboardKey.home:
        _move(index, widget.min);
      case LogicalKeyboardKey.end:
        _move(index, widget.max);
      default:
        return KeyEventResult.ignored;
    }
    return KeyEventResult.handled;
  }

  void _setFocused(int index, bool has) {
    final int? next = has ? index : (_focused == index ? null : _focused);
    if (next == _focused) return;
    setState(() => _focused = next);
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);

    // The tight height sits ABOVE the [LayoutBuilder], and it has to.
    // `LayoutBuilder` refuses to answer an intrinsic dimension — computing one
    // would mean running the callback speculatively against a live tree — and
    // `DsStateGrid` wraps every cell in an `IntrinsicHeight`. A
    // `RenderConstrainedBox` short-circuits both height intrinsics when its
    // height is tight, so this box answers 10 without the builder below ever
    // being asked. Nesting them the other way round makes the whole control
    // unusable inside any parent that measures.
    Widget slider = SizedBox(
      key: _rootKey,
      height: _trackHeight,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          _width = constraints.maxWidth;

          return Stack(
            // The knobs stand 5px proud of the channel at rest and 7.5 at the
            // active scale; the reference's root declares no `overflow`, so
            // neither does this.
            clipBehavior: Clip.none,
            children: <Widget>[
              Positioned.fill(child: _Track(theme: theme, range: _rangeRect())),
              for (int i = 0; i < widget.values.length; i++)
                Positioned(
                  left: _thumbLeft(widget.values[i]),
                  // `items-center` against a 10px line: half the knob sits
                  // above the channel and half below.
                  top: (_trackHeight - _thumbSize) / 2,
                  width: _thumbSize,
                  height: _thumbSize,
                  child: _Thumb(
                    node: _nodes[i],
                    canFocus: _operable,
                    lit: _hovered == i || _active == i || _focused == i,
                    scale: _active == i
                        ? DsTransforms.sliderThumbActiveScale
                        : _hovered == i
                            ? DsTransforms.sliderThumbHoverScale
                            : 1,
                    onFocusChange: (bool has) => _setFocused(i, has),
                    onKey: (KeyEvent event) => _onKey(i, event),
                    semantics: (Widget child) => Semantics(
                      container: true,
                      slider: true,
                      enabled: _operable,
                      label: widget.label,
                      // `aria-valuenow`, and the two values the step keys
                      // would land on. Flutter asserts that an `increase`
                      // action is annotated with both `value` and
                      // `increasedValue` or with neither, so the three are
                      // stated together.
                      value: _announce(widget.values[i]),
                      increasedValue: _announce(
                        _reachable(i, widget.values[i] + widget.step),
                      ),
                      decreasedValue: _announce(
                        _reachable(i, widget.values[i] - widget.step),
                      ),
                      onIncrease:
                          _operable ? () => _nudge(i, widget.step) : null,
                      onDecrease:
                          _operable ? () => _nudge(i, -widget.step) : null,
                      child: child,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );

    slider = Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: (PointerDownEvent event) {
        final Offset? local = _localOf(event.position);
        if (local != null) _grab(local);
      },
      onPointerMove: (PointerMoveEvent event) {
        final Offset? local = _localOf(event.position);
        if (local != null) _drag(local);
      },
      onPointerUp: (PointerUpEvent _) => _release(),
      onPointerCancel: (PointerCancelEvent _) => _release(),
      child: MouseRegion(
        cursor: _operable ? SystemMouseCursors.click : SystemMouseCursors.basic,
        onHover: (PointerHoverEvent event) {
          final Offset? local = _localOf(event.position);
          if (local != null) _hover(local);
        },
        onExit: (PointerExitEvent _) => _hover(const Offset(-1, -1)),
        child: slider,
      ),
    );

    // `touch-none` plus `data-disabled` — Radix refuses the gesture in
    // JavaScript rather than through `pointer-events`, which is why the probe
    // reads `pointer-events: auto` on a disabled root and the value still does
    // not move.
    slider = Opacity(
      opacity: widget.enabled ? 1 : _disabledOpacity,
      child: IgnorePointer(ignoring: !_operable, child: slider),
    );

    // Outermost, so nothing above it rejects a pointer aimed at a knob that
    // stands outside the channel — the same ordering [DsHitArea] documents.
    return DsHitArea(
      // The root paints no border of its own — the track inside it does — so
      // there is none to discount, and these insets are already measured from
      // the thumb's padding box through [_thumbReach].
      border: 0,
      insets: EdgeInsets.symmetric(
        // A knob at either extreme sits half its width in from the root's
        // edge, and its expander reaches [_thumbReach] from that centre.
        horizontal: _thumbReach - _thumbSize / 2,
        // Vertically the knob is centred on a 10px channel, so the expander
        // stands 12px proud of it on both sides.
        vertical: _thumbReach - _trackHeight / 2,
      ),
      child: slider,
    );
  }

  /// The filled span, as a fraction of the **track's content box**.
  ///
  /// Returned as `(left, width)` fractions so [_Track] can resolve them against
  /// the box it actually lays out in, which is the root minus its border.
  (double, double) _rangeRect() {
    final double low =
        widget.values.length > 1 ? _fraction(widget.values.first) : 0;
    final double high = _fraction(widget.values.last);
    return (low, math.max(0, high - low));
  }
}

/// `SliderPrimitive.Track` with its `Range` inside it.
///
/// `overflow-hidden` is load-bearing: the range declares no radius of its own
/// (probed `border-radius: 0px`) and gets its ends from the channel clipping
/// it. That clip is also what crops `--shadow-btn-primary`'s outer glow to the
/// channel, so the blue spills along the groove and never around it.
class _Track extends StatelessWidget {
  const _Track({required this.theme, required this.range});

  final DsThemeData theme;

  /// `(left, width)` as fractions of this track's content box.
  final (double, double) range;

  @override
  Widget build(BuildContext context) {
    return DsMachineSurface(
      spec: DsShadows.pressed,
      radius: BorderRadius.circular(DsRadii.pill),
      fill: theme.muted,
      border: Border.all(color: theme.input, width: DsWidths.hairline),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(DsRadii.pill),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double content = constraints.maxWidth;
            return Stack(
              children: <Widget>[
                Positioned(
                  left: range.$1 * content,
                  width: range.$2 * content,
                  top: 0,
                  bottom: 0,
                  child: DsMachineSurface(
                    spec: DsShadows.btnPrimary,
                    // The channel supplies the corners; the fill has none.
                    radius: BorderRadius.zero,
                    fill: theme.actionInk,
                    child: const SizedBox.expand(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// `SliderPrimitive.Thumb` — the raised knob.
///
/// Two things move on it and they move differently, which is the whole of what
/// the rAF probe was for:
///
///  * the **ring** is a `box-shadow`, it is in `transition-[transform,
///    box-shadow]`, and it tweens on [DsCurves.spring] over
///    [DsDurations.transitionDefault];
///  * the **scale** is Tailwind v4's `scale` property, which that list does not
///    name, so it snaps. See [DsTransforms.sliderThumbHoverScale].
class _Thumb extends StatelessWidget {
  const _Thumb({
    required this.node,
    required this.canFocus,
    required this.lit,
    required this.scale,
    required this.onFocusChange,
    required this.onKey,
    required this.semantics,
  });

  final FocusNode node;
  final bool canFocus;

  /// Whether any of `hover:`, `focus-visible:` or `active:` is asking for
  /// `ring-3` — all three declare the identical ring.
  final bool lit;

  final double scale;
  final ValueChanged<bool> onFocusChange;
  final KeyEventResult Function(KeyEvent) onKey;
  final Widget Function(Widget) semantics;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);

    Widget knob = TweenAnimationBuilder<Color?>(
      // At rest the ring is its own hue at zero alpha rather than
      // `transparent`, so it fades out through its own colour the way the
      // browser interpolates it — the same reasoning [DsSelectionControl]
      // records.
      tween: ColorTween(
        end: theme.ring.withValues(alpha: lit ? _ringAlpha : 0),
      ),
      duration: dsAnimationDuration(context, DsDurations.transitionDefault),
      curve: DsCurves.spring,
      builder: (BuildContext context, Color? ring, Widget? child) =>
          DsMachineSurface(
        // The ring is prepended to `--shadow-btn`, never replacing it —
        // measured on the keyboard-focused thumb, whose box-shadow reads the
        // 3px ring at half alpha followed by all four of the button's own
        // layers.
        spec: DsButton.withFocusRing(DsShadows.btn, ring ?? theme.ring),
        radius: BorderRadius.circular(_thumbSize / 2),
        fill: theme.foreground,
        border: Border.all(color: theme.input, width: DsWidths.hairline),
        child: child!,
      ),
      child: const SizedBox.expand(),
    );

    // No tween: measured to arrive in one frame. `alignment: center` because
    // the active scale shifts the knob's left edge by 2.5px on a 20px box,
    // which is exactly half of the 5px it grows.
    knob = Transform.scale(alignment: Alignment.center, scale: scale, child: knob);

    return semantics(
      Focus(
        focusNode: node,
        canRequestFocus: canFocus,
        onFocusChange: onFocusChange,
        onKeyEvent: (FocusNode _, KeyEvent event) => onKey(event),
        child: knob,
      ),
    );
  }
}
