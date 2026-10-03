/// The press feel, and the control contract that has to come with it.
///
/// A squish under the finger is feedback, not a control. On its own it gives a
/// pointer user something to feel and gives a keyboard user, a screen-reader
/// user and a finger nothing at all — which is how a design system grows a row
/// of "buttons" nobody can Tab to.
///
/// So [Press] is two widgets in one, and which one you get depends on whether
/// you handed it something to do:
///
///   * **no `onTap`** — decorative. It squishes while a pointer is down and
///     adds nothing to the semantics tree. Wrap a real [Button] in it and the
///     Button stays the control.
///   * **`onTap`** — a complete control. Focusable and Tab-reachable, activated
///     by Enter and Space as well as by tap, announced as a button with the
///     name you give it, showing a focus ring, wearing a click cursor, and
///     answering a finger over at least [TouchTargets.minimum] square however
///     small it looks.
///
/// [TapTarget] is the last of those on its own, for controls that already have
/// the rest.
library;

import 'dart:math' as math;

import 'package:flutter/rendering.dart'
    show BoxHitTestEntry, BoxHitTestResult, RenderProxyBox;
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

import '../../design_system/foundation/motion.dart';
import '../../design_system/foundation/spacing.dart';
import '../../design_system/foundation/theme.dart';
import '../../design_system/foundation/theme_scope.dart';

/// Squishes [child] while it is being activated, and — when it owns an
/// [onTap] — is the control doing the activating.
///
/// Put this on anything clickable that is not a `Button`: the logo, a chip, a
/// nav row, a theme-toggle option. Give it a [semanticLabel] whenever the child
/// is not itself text, because that label is the whole name a screen reader has
/// for it.
class Press extends StatefulWidget {
  const Press({
    super.key,
    this.scale = MotionTransforms.press,
    required this.child,
    this.onTap,
    this.behavior = HitTestBehavior.opaque,
    this.downDuration = MotionDurations.pressIn,
    this.upDuration = MotionDurations.pressOut,
    this.semanticLabel,
    this.focusNode,
    this.autofocus = false,
    this.enabled = true,
    this.showFocusRing = true,
    this.focusRadius = Radii.md,
    this.minimumTarget = true,
    this.onFocusChange,
    this.onHoverChange,
    this.link = false,
    this.expanded,
  });

  /// The `:active` scale. Defaults to the `press` utility's 0.94; `Button`
  /// passes [MotionTransforms.buttonPress], `click-spring` surfaces 0.9.
  final double scale;

  /// How long the squish takes. `press` and its two siblings all use 40ms;
  /// `btn-spring` — what a `Button` wears — uses `--duration-tick`, 80ms.
  final Duration downDuration;

  /// How long the spring back takes. `--duration-base` for every utility in
  /// the family.
  final Duration upDuration;

  final Widget child;

  /// What activating this does.
  ///
  /// Null makes the widget decorative: no focus, no semantics, no keyboard, no
  /// cursor. That is the right shape when something inside already owns the
  /// action — a [Press] around a `Button` is a feel, not a second control.
  final VoidCallback? onTap;

  /// The accessible name, for a control whose child is not already text.
  ///
  /// A screen reader reads the child's own text when there is any; an icon-only
  /// control has none, and without this it is announced as an unnamed button.
  final String? semanticLabel;

  /// An externally owned focus node, when the caller needs to move focus here.
  ///
  /// One is created and disposed internally when this is null — the usual case.
  final FocusNode? focusNode;

  /// Whether this control takes focus when it is first mounted.
  final bool autofocus;

  /// Whether the control accepts input.
  ///
  /// A disabled control is still in the semantics tree, announced as disabled,
  /// and still readable — it just cannot be focused or activated. Silence would
  /// leave a screen-reader user wondering where the action went.
  final bool enabled;

  /// Whether a focus ring is painted when focus arrives from the keyboard.
  ///
  /// Pass `false` only when the child paints its own — `Button` and the
  /// selection controls do — never to make focus invisible.
  final bool showFocusRing;

  /// The ring's corner radius, which should match the child's own.
  final double focusRadius;

  /// Whether the hit area is grown to [TouchTargets.minimum] square.
  ///
  /// Layout is untouched either way; this only widens what answers a finger.
  /// Pass `false` where an ancestor already guarantees the floor and a second
  /// expansion would overlap a neighbouring control.
  final bool minimumTarget;

  /// Called when focus arrives or leaves, for a caller that paints its own
  /// focused state.
  final ValueChanged<bool>? onFocusChange;

  /// Called when a pointer enters or leaves, for a caller that tints on hover.
  ///
  /// Reported here rather than left to a `MouseRegion` beside it, so a caller
  /// cannot end up with hover feedback on a surface that has no keyboard path —
  /// the shape this widget exists to prevent.
  final ValueChanged<bool>? onHoverChange;

  /// Whether this reads as a link rather than a button.
  ///
  /// A breadcrumb entry and a nav row go somewhere; a toggle and a dismiss do
  /// something. Screen-reader users navigate by that distinction, so it is a
  /// flag rather than an assumption.
  final bool link;

  /// Whether the control shows or hides something, and which way it is now.
  ///
  /// Null for a control that discloses nothing, which is most of them. A
  /// disclosure trigger that omits it announces as a plain button, and the
  /// reader has to press it to learn what it does.
  final bool? expanded;

  /// Whether this instance is a control rather than a decoration.
  bool get isInteractive => onTap != null;

  final HitTestBehavior behavior;

  @override
  State<Press> createState() => _PressState();
}

class _PressState extends State<Press> with SingleTickerProviderStateMixin {
  /// 0 at rest, 1 fully pressed. The asymmetry lives in the two durations.
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: MotionDurations.pressIn,
    reverseDuration: MotionDurations.pressOut,
  );

  /// `--ease-spring` in both directions.
  ///
  /// The reverse curve is *flipped*, not reused: CSS runs its timing function
  /// forward in real time whichever way a property is transitioning, while a
  /// reversing [AnimationController] would otherwise play the easing
  /// backwards and turn the spring's overshoot into a lag.
  late final Animation<double> _progress = CurvedAnimation(
    parent: _controller,
    curve: MotionCurves.emphasized,
    reverseCurve: MotionCurves.emphasized.flipped,
  );

  @override
  void dispose() {
    _controller.dispose();
    _ownedNode?.dispose();
    super.dispose();
  }

  /// Owned only when the caller did not supply one.
  FocusNode? _ownedNode;
  FocusNode get _node => widget.focusNode ?? (_ownedNode ??= FocusNode());

  /// Whether the focus ring should show — keyboard focus, not a pointer's.
  bool _focusVisible = false;

  void _down(PointerDownEvent _) => _controller.forward();
  void _release([PointerEvent? _]) => _controller.reverse();

  /// Activation from the keyboard, which has no pointer to squish with.
  ///
  /// The same feedback a tap gets, driven forward and back around the callback
  /// so Enter and Space look like what they are.
  void _activateFromKeyboard() {
    if (!widget.enabled) return;
    _controller.forward();
    widget.onTap?.call();
    _controller.reverse();
  }

  void _handleFocusHighlight(bool value) {
    if (_focusVisible == value) return;
    setState(() => _focusVisible = value);
  }

  void _handleHoverHighlight(bool value) => widget.onHoverChange?.call(value);

  @override
  Widget build(BuildContext context) {
    _controller.duration = effectiveMotionDuration(
      context,
      widget.downDuration,
    );
    _controller.reverseDuration = effectiveMotionDuration(
      context,
      widget.upDuration,
    );

    Widget result = Listener(
      onPointerDown: _down,
      onPointerUp: _release,
      onPointerCancel: _release,
      behavior: widget.behavior,
      child: AnimatedBuilder(
        animation: _progress,
        builder: (BuildContext context, Widget? child) => Transform.scale(
          // The spring overshoots past 1, which is what carries the scale a
          // hair beyond its target and back — do not clamp it.
          scale: 1 + (widget.scale - 1) * _progress.value,
          child: child,
        ),
        child: widget.child,
      ),
    );

    // Decorative: a squish and nothing else. Adding focus or semantics here
    // would put an unnamed, unactivatable node in the tree for a screen reader
    // to walk past.
    if (!widget.isInteractive) return result;

    final ThemeTokens theme = ThemeScope.of(context);
    final bool enabled = widget.enabled;

    if (widget.showFocusRing) {
      result = _FocusRing(
        visible: _focusVisible && enabled,
        radius: widget.focusRadius,
        color: theme.ring,
        child: result,
      );
    }

    result = GestureDetector(
      onTap: enabled ? widget.onTap : null,
      behavior: widget.behavior,
      child: result,
    );

    result = FocusableActionDetector(
      focusNode: _node,
      autofocus: widget.autofocus,
      enabled: enabled,
      mouseCursor: enabled
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onShowFocusHighlight: _handleFocusHighlight,
      onShowHoverHighlight: _handleHoverHighlight,
      onFocusChange: widget.onFocusChange,
      // Enter and Space, through the framework's own activation intents, so
      // this control answers the keys every other control answers rather than
      // a key map of its own.
      actions: <Type, Action<Intent>>{
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (ActivateIntent _) {
            _activateFromKeyboard();
            return null;
          },
        ),
        ButtonActivateIntent: CallbackAction<ButtonActivateIntent>(
          onInvoke: (ButtonActivateIntent _) {
            _activateFromKeyboard();
            return null;
          },
        ),
      },
      child: result,
    );

    result = Semantics(
      container: true,
      button: !widget.link,
      link: widget.link,
      enabled: enabled,
      expanded: widget.expanded,
      label: widget.semanticLabel,
      onTap: enabled ? widget.onTap : null,
      child: result,
    );

    if (widget.minimumTarget) result = TapTarget(child: result);
    return result;
  }
}

/// A focus ring drawn outside the child, so it cannot change what it rings.
///
/// Painted rather than added to the box: a ring that took part in layout would
/// move every neighbour by its own width the moment focus arrived.
class _FocusRing extends StatelessWidget {
  const _FocusRing({
    required this.visible,
    required this.radius,
    required this.color,
    required this.child,
  });

  final bool visible;
  final double radius;
  final Color color;
  final Widget child;

  /// The ring's width and how far it sits outside the child, both from the
  /// same scale every other focus treatment in the package uses.
  static double get _width => BorderWidths.focusRing;
  static double get _offset => BorderWidths.focusRingOffset;

  @override
  Widget build(BuildContext context) => CustomPaint(
    foregroundPainter: visible
        ? _FocusRingPainter(radius: radius, color: color)
        : null,
    child: child,
  );
}

class _FocusRingPainter extends CustomPainter {
  const _FocusRingPainter({required this.radius, required this.color});

  final double radius;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final double width = _FocusRing._width;
    final double offset = _FocusRing._offset;
    final Rect rect = Rect.fromLTWH(
      0,
      0,
      size.width,
      size.height,
    ).inflate(offset + width / 2);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(radius + offset)),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = width
        ..color = color,
    );
  }

  @override
  bool shouldRepaint(_FocusRingPainter old) =>
      old.radius != radius || old.color != color;
}

/// Guarantees a minimum effective touch target without moving anything.
///
/// A control may look smaller than a finger — a 20px checkbox, a dense menu
/// row — but the area that answers one may not. This widens [hitTest] alone:
/// layout, paint and every neighbour stay exactly where they were, and a point
/// in the grown margin is forwarded to the child at its centre.
///
/// It is the general form of the same idea `HitArea` applies to the selection
/// controls, and it takes its floor from [TouchTargets.minimum] rather than
/// from any one control's measurements.
class TapTarget extends SingleChildRenderObjectWidget {
  const TapTarget({super.key, this.minimum, required Widget super.child});

  /// The floor, defaulting to [TouchTargets.minimumSize].
  final Size? minimum;

  /// The rect this target answers, in its own coordinates. For tests.
  @visibleForTesting
  static Rect debugTarget(RenderObject box) => (box as _RenderTapTarget).target;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderTapTarget(minimum ?? TouchTargets.minimumSize);

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    (renderObject as _RenderTapTarget).minimum =
        minimum ?? TouchTargets.minimumSize;
  }
}

class _RenderTapTarget extends RenderProxyBox {
  _RenderTapTarget(this._minimum);

  Size _minimum;
  set minimum(Size value) {
    if (value == _minimum) return;
    _minimum = value;
    markNeedsLayout();
  }

  /// The box a pointer may land in: the child's own, grown about its centre to
  /// the minimum in each axis it falls short on.
  Rect get target {
    final double dx = math.max(0, (_minimum.width - size.width) / 2);
    final double dy = math.max(0, (_minimum.height - size.height) / 2);
    return Rect.fromLTRB(-dx, -dy, size.width + dx, size.height + dy);
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (!target.contains(position)) return false;
    // A point in the grown margin is answered by the child at its centre,
    // which is where a finger that missed by two pixels meant to land.
    final Offset inside = (Offset.zero & size).contains(position)
        ? position
        : size.center(Offset.zero);
    final bool hit = super.hitTest(result, position: inside);
    if (!hit) result.add(BoxHitTestEntry(this, position));
    return true;
  }
}
