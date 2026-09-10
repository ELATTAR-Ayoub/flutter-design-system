/// `components/ui/button-group.tsx` — the segmented control.
///
/// *"Joins related actions into one control. Used for view switching, quantity
/// steppers and split actions."* Three members: the row itself, a `--muted`
/// text cell, and a 1px rule.
///
/// **Root** (`:7–22, 24–38`) — `<div role="group" data-slot="button-group">`:
///
/// | class | line | effect |
/// |---|---|---|
/// | `flex w-fit items-stretch` | 8 | a shrink-to-fit row whose children stretch to the tallest — this is the whole reason a height-less [ButtonGroupText] comes out 40px |
/// | `*:focus-visible:relative *:focus-visible:z-10` | 8 | a focused member's ring paints over its neighbours |
/// | `has-[>[data-slot=button-group]]:gap-2` | 8 | 8px, but **only** when a group nests a group. Nothing on this page does, so the gap is 0 and the members are flush. Recorded, not built: nesting detection would buy a rule this port has never rendered. |
/// | `[&>*:not(:first-child)]:rounded-l-none` | 13 | interior left corners squared |
/// | `[&>*:not(:first-child)]:border-l-0` | 13 | **one** hairline between neighbours instead of two |
/// | `[&>*:not(:last-child)]:rounded-r-none` | 13 | interior right corners squared |
/// | `[&>[data-slot]:not(:has(~[data-slot]))]:rounded-r-lg!` | 13 | the last `data-slot` child is forced to `--radius-lg` **12px**, `!important` |
///
/// Line 8 carries three more selectors — `has-[select[aria-hidden=true]…]`,
/// `[&>[data-slot=select-trigger]:not([class*='w-'])]:w-fit` and
/// `[&>input]:flex-1` — which arm the group for a `Select` or an `Input`
/// member. Neither exists in a group in this port; recorded, not built. The
/// cva's `orientation="vertical"` (`:14–15`) is the same story: the page passes
/// the default, so only `horizontal` is ported.
///
/// Net shape, and it is **asymmetric by construction** (buttons-map drift 7):
/// the left end keeps the child's own radius — a `rounded-pill` [Button]
/// leaves a 20px stadium on a 40px control — while the right end is always
/// 12px.
///
/// ## Corners, and why a clip alone cannot make one
///
/// CSS restyles a child from its parent. Flutter cannot: [Button] paints
/// `BorderRadius.circular(Radii.full)` in its own build (`button.dart:471`)
/// and takes a radius from nobody.
///
/// A clip is not a substitute, because **a clip can only take paint away**.
/// Clipping a pill to a square-cornered rectangle changes nothing at all — the
/// cap is already inside that rectangle — and what is left in the corner is not
/// a square corner but bare page, a notch at every seam.
///
/// So the member is made to paint *past* its own box and the surplus is cut
/// off. `_BledSlot` lays the child out one full height wider than it measures —
/// half a height of **bleed** on each side — reports the natural width, and
/// shows the middle band. Half a height is at or past the deepest corner any
/// box can have, so both caps land outside the band and the visible left and
/// right edges are cuts through the member's straight run: full-height fill,
/// top and bottom borders running right up to the cut, and no vertical border
/// at the cut. That single move is `rounded-l-none`, `rounded-r-none` **and**
/// `border-l-0`.
///
/// The bleed is symmetric on purpose. A button centres its label in its box, so
/// an asymmetric stretch moves the label by half the difference — 10px on a
/// 40px control, and visibly lopsided across a three-segment group. Symmetric
/// stretch leaves the label exactly where it was and takes both caps.
///
/// Taking both caps is more than the rules ask at the two ends of the row, so
/// the slot puts back what it took: it clips to the shape the rules produce —
/// a rounded end wherever the member keeps a radius — and strokes the 1px frame
/// along the vertical ends itself. The child still paints its own top and
/// bottom borders, which survive the cut, so what is synthesised is exactly
/// what the bleed removed and nothing more.
///
/// Members this file declares are not bled at all. [ButtonGroupText] is told
/// its shape through `_Slot`, an [InheritedWidget] standing in for the
/// cascade, and paints it directly — corners, dropped left border and all;
/// [ButtonGroupSeparator] is a 1px rule with no corners and no border, so
/// there is nothing to tell it. That is the "expose a radius on the member"
/// route, taken wherever the member is ours to ask, which is why group B's left
/// end is exact rather than reconstructed.
///
/// ## The single-hairline join
///
/// `border-l-0` leaves exactly one border at each seam — the **left** member's
/// right border — and that falls out of the mechanism rather than needing a
/// nudge. No negative offset, no 1px overlap, no clip that eats a pixel: the
/// right-hand member has no left border to stack, because the bleed cut it off
/// (or, for a [ButtonGroupText], because it was told not to paint one). Two
/// hairlines can never meet at a seam here.
///
/// What has to be supplied instead is the one border that *should* be there.
/// CSS reads it off the member's own computed style; Flutter has no such
/// reading, so `_frameOf` re-derives the resting border of the member types a
/// group can hold — `--input` for an outline [Button], `--destructive/25` for
/// a destructive one, transparent for the other five variants and `--border`
/// for a [ButtonGroupText] (which paints its own). Group B's first seam
/// therefore comes out 2px wide, `--border` then `--input`, exactly as the
/// reference renders it: the text cell's right border followed by the
/// separator.
///
/// ## What the bleed costs
///
/// * **`*:focus-visible:z-10`.** A focused member's ring is drawn around the
///   stretched box, so its vertical runs sit half a height out and the seam
///   cuts them. What survives is the ring above and below the member — the clip
///   is deliberately generous vertically. In the reference the ring closes at
///   the seam and paints over the neighbour.
/// * **Sideways elevation.** A member's drop shadow is cut at every seam, which
///   is what the reference does too (the later member paints over it), and at
///   the two ends of the row, which it does not.
/// * **A synthesised edge does not follow state.** `focus-visible:border-ring`
///   recolours a member's own border; the strokes this file draws stay at the
///   resting colour.
/// * **Gradient surfaces are sampled from a wider box.** `action-feedback` and
///   `premium-surface` ramp across the member; the ramp is laid out across the
///   stretched box and the band shows its middle. Both are near-vertical
///   (`linear-gradient(176deg, …)`), so the difference is a fraction of a stop.
library;

import 'dart:math' as math;

import 'package:flutter/rendering.dart';
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

import '../../design_system/foundation/colors.dart';
import '../../design_system/foundation/spacing.dart';
import '../../design_system/foundation/theme.dart';
import '../../design_system/foundation/typography.dart';
import '../../design_system/foundation/theme_scope.dart';
import './button.dart';

/// `border-destructive/25` — the resting border alpha of
/// [ButtonVariant.destructive] (`button.tsx`, and `button.dart:115`).
///
/// Restated here rather than imported because `button.dart` keeps it private;
/// it is the one variant whose seam is neither a flat token nor transparent.
const double _destructiveBorderAlpha = 0.25;

/// How far past its own box a member's paint is let out, vertically.
///
/// The clip has to cut horizontally to the pixel — that is what squares a
/// corner — but there is no neighbour above or below a row, so nothing is
/// gained by cutting there and a member's elevation is lost if it does.
/// `--shadow-glow-value`, the deepest halo any member can wear, reaches about
/// 19px below its box (`0 10px 34px -8px`); eight spacing steps clears it and
/// the 3px focus ring together.
final double _spill = space(8);

/// The corner shape and border set the group's own rules give one member.
@immutable
class _SlotShape {
  const _SlotShape({
    required this.left,
    required this.right,
    required this.leftBorder,
  });

  /// The radius of **both** left corners — `rounded-l-none` makes it 0, and
  /// otherwise the member keeps its own.
  final double left;

  /// The radius of both right corners — 0 for `rounded-r-none`, `--radius-lg`
  /// where `rounded-r-lg!` lands, and otherwise the member's own.
  final double right;

  /// Whether the member still has a left border, i.e. whether it escaped
  /// `border-l-0`. True only for the first member.
  final bool leftBorder;

  BorderRadius get radii => BorderRadius.horizontal(
    left: Radius.circular(left),
    right: Radius.circular(right),
  );

  /// The shape at [size], with over-large radii scaled down.
  ///
  /// [RRect.scaleRadii] is CSS's own overflow rule (CSS Backgrounds §5.5): take
  /// the smallest ratio of edge length to the sum of the radii on that edge and
  /// multiply **every** radius by it. So a `rounded-pill` member on a 40px
  /// control lands on a 20px stadium here for the same reason it does in the
  /// browser, and the port inherits the browser's oddities along with its
  /// results — including the fact that a lone member carrying both `999px` and
  /// `rounded-r-lg!` has its 12px end scaled away to nothing.
  RRect rrect(Size size) => radii.toRRect(Offset.zero & size).scaleRadii();

  @override
  bool operator ==(Object other) =>
      other is _SlotShape &&
      other.left == left &&
      other.right == right &&
      other.leftBorder == leftBorder;

  @override
  int get hashCode => Object.hash(left, right, leftBorder);
}

/// The cascade, as far as this component needs one.
///
/// The group's rules are descendant selectors: they are written on the parent
/// and read on the child. An [InheritedWidget] is the same arrangement — the
/// group publishes a shape, and a member that can paint its own corners reads
/// it. A member that cannot (any [Button]) is wrapped in a `_BledSlot`
/// instead, which does the reading on its behalf.
class _Slot extends InheritedWidget {
  const _Slot({required this.shape, required super.child});

  final _SlotShape shape;

  static _SlotShape? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_Slot>()?.shape;

  @override
  bool updateShouldNotify(_Slot oldWidget) => oldWidget.shape != shape;
}

/// A row of controls joined into one.
class ButtonGroup extends StatelessWidget {
  const ButtonGroup({super.key, required this.children});

  /// The members, in source order — buttons, [ButtonGroupText] cells and
  /// [ButtonGroupSeparator] rules.
  ///
  /// A member this file does not recognise is placed flush and left entirely
  /// alone: its corners are its own and no frame is synthesised for it. The
  /// group can only reshape what it can measure the shape of.
  final List<Widget> children;

  /// The corner radii the group's rules give the member at [index].
  ///
  /// Exposed for tests, because the radii *are* the component: the asymmetry
  /// (drift 7) and the reach past a `data-slot`-less member (drift 8) are both
  /// statements about this function and about nothing else. Values are as the
  /// rules declare them — `Radii.full` is 999 here, and clamps to half the
  /// height at paint the way CSS clamps it (see [_SlotShape.rrect]).
  @visibleForTesting
  static BorderRadius radiiOf(List<Widget> children, int index) =>
      _shapeOf(children, index).radii;

  /// Whether the member at [index] keeps its left border — false for every
  /// member but the first (`border-l-0`).
  @visibleForTesting
  static bool hasLeftBorder(List<Widget> children, int index) =>
      _shapeOf(children, index).leftBorder;

  /// `[&>[data-slot]…]` — every member in the reference carries a `data-slot`
  /// except `ButtonGroupText`, which is buttons-map **drift 8** and the reason
  /// the `rounded-r-lg!` rule can reach past it.
  static bool _hasDataSlot(Widget child) => child is! ButtonGroupText;

  /// The index `[&>[data-slot]:not(:has(~[data-slot]))]:rounded-r-lg!` lands
  /// on: the last member with a `data-slot`, which is not necessarily the last
  /// member. A trailing [ButtonGroupText] is invisible to the selector, so
  /// the rule skips over it and rounds the Button *behind* it — reproduced, not
  /// repaired.
  static int _lastSlotted(List<Widget> children) {
    for (int i = children.length - 1; i >= 0; i--) {
      if (_hasDataSlot(children[i])) return i;
    }
    return -1;
  }

  /// The radius a member paints when nothing overrides it.
  static double _ownRadius(Widget child) {
    if (child is Button) return Radii.full;
    if (child is ButtonGroupText) return Radii.lg;
    // A rule has no corners, and an unrecognised member is never reshaped.
    return 0;
  }

  static _SlotShape _shapeOf(List<Widget> children, int index) {
    final bool first = index == 0;
    final bool last = index == children.length - 1;
    final bool forced = index == _lastSlotted(children);
    final double own = _ownRadius(children[index]);
    return _SlotShape(
      left: first ? own : 0,
      // `rounded-r-lg!` is `!important`, so it beats `rounded-r-none` on an
      // interior member as readily as it beats the member's own radius on the
      // last one.
      right: forced ? Radii.lg : (last ? own : 0),
      leftBorder: first,
    );
  }

  /// The resting `border-color` of a [Button] variant — the colour of the
  /// hairline it contributes to a seam.
  ///
  /// The five variants that declare `border-transparent` contribute nothing,
  /// which is why group C reads as one solid control with a single `--input`
  /// rule down the middle: the separator is the only visible line in it.
  static Color _frameOf(ThemeTokens theme, ButtonVariant variant) {
    switch (variant) {
      case ButtonVariant.outline:
        return theme.input;
      case ButtonVariant.destructive:
        return theme.destructive.withValues(alpha: _destructiveBorderAlpha);
      case ButtonVariant.primary:
      case ButtonVariant.premium:
      case ButtonVariant.secondary:
      case ButtonVariant.ghost:
      case ButtonVariant.link:
        return transparent;
    }
  }

  Widget _member(ThemeTokens theme, int index) {
    final Widget child = children[index];
    final _SlotShape shape = _shapeOf(children, index);
    if (child is ButtonGroupText) {
      return _Slot(shape: shape, child: child);
    }
    if (child is Button) {
      return _BledSlot(
        shape: shape,
        frame: _frameOf(theme, child.variant),
        child: child,
      );
    }
    // A separator has no corners to square and no border to drop; anything
    // else is not ours to reshape.
    return child;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Semantics(
      // `role="group"` — a container the members stay individually reachable
      // inside of.
      container: true,
      explicitChildNodes: true,
      // `items-stretch` sizes every member to the tallest, and CSS gets that
      // measurement for free. [IntrinsicHeight] is what buys it here: it takes
      // the row's tallest intrinsic height and hands it back down as a tight
      // constraint, which is exactly what gives the height-less text cell its
      // 40px.
      // `items-stretch` sizes every member to the tallest, and CSS gets that
      // measurement for free. [IntrinsicHeight] is what buys it here: it takes
      // the row's tallest intrinsic height and hands it back down as a tight
      // constraint, which is exactly what gives the height-less text cell its
      // 40px.
      //
      // **Not scrolled, deliberately.** A `w-fit` row that outgrows its column
      // is the page's problem, exactly as it is in the reference: wrapping the
      // group in its own scroll view unbounds the width its members measure
      // against, and `IntrinsicHeight` over the slot render objects then flushes
      // semantics against boxes that were never laid out. The consumer decides
      // whether this group scrolls, the same way it decides for a wide table.
      child: IntrinsicHeight(
        child: Row(
          // `w-fit`.
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            for (int i = 0; i < children.length; i++) _member(theme, i),
          ],
        ),
      ),
    );
  }
}

/// `ButtonGroupText` (`button-group.tsx:40–58`) — `flex items-center gap-2
/// rounded-lg border bg-muted px-2.5 text-sm font-medium`.
///
/// A label cell in the row: 12px corners, **10px** of horizontal padding, a
/// `--muted` fill, 13px/500, and no height of its own — it stretches to the
/// tallest member, which is where its 40px comes from.
///
/// `border` carries no colour class, so `@layer base`'s
/// `* { @apply border-border }` (globals.css:945–947) supplies `--border`. It
/// is the one member that paints its own frame here: it is ours, so it can be
/// handed the shape directly instead of being bled and clipped like a
/// [Button]. That frame is a stroke rather than a [BoxDecoration] border for
/// a blunt reason — `BoxDecoration` refuses a non-uniform border together with
/// a border radius, and an interior cell needs exactly that pairing
/// (`border-l-0` on a box whose right corners may still be rounded).
///
/// DOCUMENTED DRIFT (buttons-map drift 8): it sets **no `data-slot`**, while
/// `Button` and `ButtonGroupSeparator` both do, so it can never satisfy
/// `[&>[data-slot]:not(:has(~[data-slot]))]` and the `rounded-r-lg!` rule
/// reaches straight past it to the last Button. [ButtonGroup] reproduces
/// that, including the case where the reach is visibly wrong.
class ButtonGroupText extends StatelessWidget {
  const ButtonGroupText(this.text, {super.key, this.numeric = false});

  /// The label, as authored — `Quantity`, `3`.
  final String text;

  /// `className="type-num"`, resolved.
  ///
  /// DOCUMENTED DRIFT (buttons-map drift 16): `.type-num` is `@layer
  /// components` while `text-sm` and `font-medium` are utilities, and Tailwind
  /// v4 orders `theme → base → components → utilities`. tailwind-merge does not
  /// strip `type-num` — it is not a class it recognises — so both apply and the
  /// utilities win the two properties they share. The "3" is Geist Mono at
  /// **13px/500**, not `.type-num`'s 15px/600; the mono family, the tabular
  /// figures and the −0.01em tracking do survive. That resolved cascade is
  /// [TextStyles.numberBase], transcribed once in the foundation layer
  /// rather than re-derived here.
  final bool numeric;

  /// `px-2.5` — 10px.
  static double get paddingX => space(2.5);

  /// `gap-2` — 8px, for a caller composing a glyph beside the label. The page
  /// passes bare text, so nothing exercises it.
  static double get gap => space(2);

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    // Standing alone, the cell is what its own class list says: 12px all round
    // with a full border.
    final _SlotShape shape =
        _Slot.maybeOf(context) ??
        const _SlotShape(left: Radii.lg, right: Radii.lg, leftBorder: true);

    return DecoratedBox(
      decoration: BoxDecoration(color: theme.muted, borderRadius: shape.radii),
      child: CustomPaint(
        // `painter`, not `foregroundPainter`: CSS paints background, then
        // border, then content, and a background painter runs before the child.
        painter: _Frame(
          radii: shape.radii,
          color: theme.border,
          leftBorder: shape.leftBorder,
        ),
        child: Padding(
          // `px-2.5`, plus the border, which `box-sizing: border-box` pays for
          // out of the cell's own box. `border-l-0` gives that pixel back.
          padding: EdgeInsets.fromLTRB(
            ButtonGroupText.paddingX +
                (shape.leftBorder ? BorderWidths.hairline : 0),
            BorderWidths.hairline,
            ButtonGroupText.paddingX + BorderWidths.hairline,
            BorderWidths.hairline,
          ),
          // `items-center` with no width of its own — the cell is as wide as
          // its label and as tall as the row.
          child: Center(
            widthFactor: 1,
            child: StyledText(
              text,
              numeric ? TextStyles.numberBase : TextStyles.nav,
              maxLines: 1,
              softWrap: false,
            ),
          ),
        ),
      ),
    );
  }
}

/// `ButtonGroupSeparator` (`button-group.tsx:60–76`) — a `Separator` with
/// `orientation="vertical"`, resolved.
///
/// `w-px` (**1px**, [BorderWidths.hairline]) + `self-stretch` + `my-px` (**1px of
/// margin at top and bottom**, so the rule stops one pixel short of the row's
/// edges) + `bg-input`, which beats `Separator`'s own `bg-border`
/// (`separator.tsx:20`) because it is written later in the merged class list.
///
/// `decorative` defaults true on `Separator`, i.e. `aria-hidden` — a plain box
/// with no semantics of its own is the same statement here.
class ButtonGroupSeparator extends StatelessWidget {
  const ButtonGroupSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      // `my-px` is a margin, so it is outside the rule's own box: the line is
      // (row height − 2) tall.
      padding: EdgeInsets.symmetric(vertical: BorderWidths.hairline),
      child: SizedBox(
        width: BorderWidths.hairline,
        child: ColoredBox(color: ThemeScope.of(context).input),
      ),
    );
  }
}

// ── The frame ───────────────────────────────────────────────────────────────

/// Strokes a 1px CSS border along [shape], run by run.
///
/// Written as separate runs because a member's borders are not all present: an
/// interior member has no left border at all, and a bled member's child has
/// already painted its own top and bottom. The stroke is centred on the shape
/// deflated by half a hairline, which puts it inside the box exactly where
/// `box-sizing: border-box` puts a CSS border.
void _elStrokeFrame(
  Canvas canvas,
  RRect shape,
  Color color, {
  required bool leftEnd,
  required bool rightEnd,
  required bool sides,
}) {
  if (color.a == 0) return;
  final RRect r = shape.deflate(BorderWidths.hairline / 2);
  if (r.width <= 0 || r.height <= 0) return;

  final Path path = Path();
  if (leftEnd) _elAddEnd(path, r, left: true);
  if (rightEnd) _elAddEnd(path, r, left: false);
  if (sides) {
    path
      ..moveTo(r.left + r.tlRadiusX, r.top)
      ..lineTo(r.right - r.trRadiusX, r.top)
      ..moveTo(r.left + r.blRadiusX, r.bottom)
      ..lineTo(r.right - r.brRadiusX, r.bottom);
  }

  canvas.drawPath(
    path,
    Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = BorderWidths.hairline
      ..color = color,
  );
}

/// One vertical end of [r]: its straight run plus the two corner arcs that meet
/// it.
///
/// Angles are screen angles — y grows downward, so a positive sweep runs
/// clockwise on the page and each corner is a quarter turn from one axis to the
/// next. Every piece opens its own subpath (`forceMoveTo: true`), so the three
/// meet at their shared tangent points without a chord drawn between them.
void _elAddEnd(Path path, RRect r, {required bool left}) {
  final double x = left ? r.left : r.right;
  final double topRx = left ? r.tlRadiusX : r.trRadiusX;
  final double topRy = left ? r.tlRadiusY : r.trRadiusY;
  final double botRx = left ? r.blRadiusX : r.brRadiusX;
  final double botRy = left ? r.blRadiusY : r.brRadiusY;

  path
    ..moveTo(x, r.top + topRy)
    ..lineTo(x, r.bottom - botRy);

  if (topRx > 0 && topRy > 0) {
    path.arcTo(
      Rect.fromLTWH(
        left ? r.left : r.right - 2 * topRx,
        r.top,
        2 * topRx,
        2 * topRy,
      ),
      left ? math.pi : math.pi * 3 / 2,
      math.pi / 2,
      true,
    );
  }
  if (botRx > 0 && botRy > 0) {
    path.arcTo(
      Rect.fromLTWH(
        left ? r.left : r.right - 2 * botRx,
        r.bottom - 2 * botRy,
        2 * botRx,
        2 * botRy,
      ),
      left ? math.pi / 2 : 0,
      math.pi / 2,
      true,
    );
  }
}

/// [ButtonGroupText]'s border — every run of it, minus the left one when
/// `border-l-0` has taken it.
class _Frame extends CustomPainter {
  const _Frame({
    required this.radii,
    required this.color,
    required this.leftBorder,
  });

  final BorderRadius radii;
  final Color color;
  final bool leftBorder;

  @override
  void paint(Canvas canvas, Size size) => _elStrokeFrame(
    canvas,
    radii.toRRect(Offset.zero & size).scaleRadii(),
    color,
    leftEnd: leftBorder,
    rightEnd: true,
    sides: true,
  );

  @override
  bool shouldRepaint(_Frame oldDelegate) =>
      oldDelegate.radii != radii ||
      oldDelegate.color != color ||
      oldDelegate.leftBorder != leftBorder;
}

// ── The bled slot ───────────────────────────────────────────────────────────

/// A member that paints its own corners and cannot be told otherwise.
///
/// See the library doc: the child is laid out one height wider than it
/// measures, painted centred, and cut back to the band — which squares whatever
/// corners the group's rules square, drops the left border where `border-l-0`
/// does, and costs the frame runs the cut removed. Those are stroked back on.
class _BledSlot extends SingleChildRenderObjectWidget {
  const _BledSlot({
    required this.shape,
    required this.frame,
    required Widget super.child,
  });

  final _SlotShape shape;

  /// The member's own resting `border-color` — see `ButtonGroup._frameOf`.
  final Color frame;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderBledSlot(shape, frame);

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderBledSlot renderObject,
  ) {
    renderObject
      ..shape = shape
      ..frame = frame;
  }
}

class _RenderBledSlot extends RenderBox
    with RenderObjectWithChildMixin<RenderBox> {
  /// Positional because both fields are private: the shape first, then the ink
  /// its synthesised runs are drawn in.
  _RenderBledSlot(this._shape, this._frame);

  _SlotShape _shape;
  set shape(_SlotShape value) {
    if (value == _shape) return;
    _shape = value;
    // The bleed is a function of the height alone, so a new shape repaints and
    // never relayouts.
    markNeedsPaint();
  }

  Color _frame;
  set frame(Color value) {
    if (value == _frame) return;
    _frame = value;
    markNeedsPaint();
  }

  /// Half the surplus width, i.e. how far the child hangs past each side.
  double _bleed = 0;

  /// A handle rather than a bare field: the layer belongs to the layer tree,
  /// which disposes it on its own schedule, and only [LayerHandle] keeps the
  /// two owners from disposing it twice.
  final LayerHandle<ClipPathLayer> _clipLayer = LayerHandle<ClipPathLayer>();

  @override
  void dispose() {
    _clipLayer.layer = null;
    super.dispose();
  }

  // The slot measures exactly what the member measures — the bleed is paint,
  // not layout, and the group's width has to stay the sum of its members'.
  @override
  double computeMinIntrinsicWidth(double height) =>
      child?.getMinIntrinsicWidth(height) ?? 0;

  @override
  double computeMaxIntrinsicWidth(double height) =>
      child?.getMaxIntrinsicWidth(height) ?? 0;

  @override
  double computeMinIntrinsicHeight(double width) =>
      child?.getMinIntrinsicHeight(width) ?? 0;

  @override
  double computeMaxIntrinsicHeight(double width) =>
      child?.getMaxIntrinsicHeight(width) ?? 0;

  @override
  Size computeDryLayout(BoxConstraints constraints) =>
      child?.getDryLayout(constraints) ?? constraints.smallest;

  @override
  void performLayout() {
    final RenderBox? child = this.child;
    if (child == null) {
      _bleed = 0;
      size = constraints.smallest;
      return;
    }

    // What the member would measure on its own — the width the group owes it,
    // and the height the bleed is derived from.
    final Size natural = child.getDryLayout(constraints);
    _bleed = natural.height / 2;
    final double stretched = natural.width + _bleed * 2;

    child.layout(
      BoxConstraints(
        minWidth: stretched,
        maxWidth: stretched,
        minHeight: constraints.minHeight,
        maxHeight: constraints.maxHeight,
      ),
      parentUsesSize: true,
    );
    size = constraints.constrain(
      Size(math.max(child.size.width - _bleed * 2, 0), child.size.height),
    );
  }

  /// The band, plus the vertical spill.
  Rect get _bounds =>
      Rect.fromLTRB(0, -_spill, size.width, size.height + _spill);

  /// Everything the member is allowed to put on the page.
  ///
  /// The union of two subpaths: its own shape, which is what confines the fill
  /// and rounds an end the rules leave rounded, and a rectangle over the shape's
  /// straight span, inflated vertically so elevation still reaches the page.
  /// The bleed's surplus fill lies outside the band horizontally and so outside
  /// both.
  Path _clipPath(RRect shape) {
    final Path path = Path()..addRRect(shape);
    final double from = shape.tlRadiusX;
    final double to = size.width - shape.trRadiusX;
    if (to > from) {
      path.addRect(Rect.fromLTRB(from, -_spill, to, size.height + _spill));
    }
    return path;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final RenderBox? child = this.child;
    if (child == null || size.isEmpty) return;
    final RRect shape = _shape.rrect(size);

    _clipLayer.layer = context.pushClipPath(
      needsCompositing,
      offset,
      _bounds,
      _clipPath(shape),
      (PaintingContext inner, Offset origin) =>
          inner.paintChild(child, origin + Offset(-_bleed, 0)),
      oldLayer: _clipLayer.layer,
    );

    // Outside the clip, and after the child: the runs the cut removed, in the
    // member's own border colour. The right end is always drawn — CSS never
    // takes a right border away, and at a squared end this stroke IS the seam.
    _elStrokeFrame(
      context.canvas,
      shape.shift(offset),
      _frame,
      leftEnd: _shape.leftBorder,
      rightEnd: true,
      sides: false,
    );
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    final RenderBox? child = this.child;
    if (child == null) return false;
    // [RenderBox.hitTest] has already rejected anything outside the band, so
    // the member's hit area is its own box exactly as CSS leaves it — the bleed
    // is unreachable.
    return result.addWithPaintOffset(
      offset: Offset(-_bleed, 0),
      position: position,
      hitTest: (BoxHitTestResult result, Offset transformed) =>
          child.hitTest(result, position: transformed),
    );
  }

  @override
  void applyPaintTransform(RenderBox child, Matrix4 transform) {
    transform.translateByDouble(-_bleed, 0, 0, 1);
  }
}
