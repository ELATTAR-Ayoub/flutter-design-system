/// The hover lift — the `lift` utility, `app/globals.css` L2318–2330.
///
/// ```css
/// @utility lift {
///   transition:
///     transform var(--duration-base) var(--ease-out),
///     box-shadow var(--duration-base) var(--ease-out),
///     border-color var(--duration-base) var(--ease-standard);
///   &:hover { transform: translateY(-3px); box-shadow: var(--shadow-e3); }
/// }
/// ```
///
/// Note the two easings: the card rises and gains its shadow on `--ease-out`,
/// but its border changes colour on `--ease-standard`. One shared controller,
/// two curves.
library;

import 'package:flutter/widgets.dart';

import '../foundation/colors.dart';
import '../foundation/motion.dart';
import '../foundation/shadows.dart';
import '../foundation/spacing.dart';
import '../foundation/theme.dart';
import '../theme_scope.dart';

/// Reports pointer hover to [builder]. The consumer decides what hovering
/// looks like.
///
/// Kept deliberately dumb: `lift` is only ever the *trigger*: on an index card
/// it also slides an arrow and recolours it, and baking one appearance in
/// would put those in the wrong place. [DsLiftCard] is the standard
/// appearance, built on this.
class DsLift extends StatefulWidget {
  const DsLift({
    super.key,
    required this.builder,
    this.cursor = MouseCursor.defer,
  });

  final Widget Function(BuildContext context, bool hovered) builder;

  final MouseCursor cursor;

  @override
  State<DsLift> createState() => _DsLiftState();
}

class _DsLiftState extends State<DsLift> {
  bool _hovered = false;

  void _set(bool value) {
    if (_hovered == value) return;
    setState(() => _hovered = value);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.cursor,
      onEnter: (_) => _set(true),
      onExit: (_) => _set(false),
      child: widget.builder(context, _hovered),
    );
  }
}

/// A card that lifts: `translateY(-3px)` onto `--shadow-e3`, with an optional
/// border-colour swap.
///
/// This is the shape every docs card takes — the overview's index cards, the
/// foot-nav's prev/next cards — so it ships rather than being re-typed per
/// page. Everything it does not decide (padding, contents, the arrow that
/// slides on hover) comes through [builder], which is handed the same hover
/// flag driving the lift.
class DsLiftCard extends StatefulWidget {
  const DsLiftCard({
    super.key,
    required this.builder,
    this.radius,
    this.fill,
    this.borderColor,
    this.hoverBorderColor,
    this.shadow,
    this.padding = EdgeInsets.zero,
    this.onTap,
    this.cursor = SystemMouseCursors.click,
  });

  /// Built with the live hover state.
  final Widget Function(BuildContext context, bool hovered) builder;

  /// Defaults to `--radius-xl` (16px), the card corner.
  final BorderRadius? radius;

  /// Defaults to `--card`.
  final Color? fill;

  /// Defaults to `--border`.
  final Color? borderColor;

  /// Defaults to [borderColor] — i.e. no swap. The index cards pass
  /// `--color-action` at 45%.
  final Color? hoverBorderColor;

  /// Defaults to `--shadow-e3`, which is what the `lift` utility names.
  final DsShadowSpec? shadow;

  final EdgeInsetsGeometry padding;

  final VoidCallback? onTap;

  final MouseCursor cursor;

  @override
  State<DsLiftCard> createState() => _DsLiftCardState();
}

class _DsLiftCardState extends State<DsLiftCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: DsDurations.base,
  );

  /// Transform and shadow ride `--ease-out`…
  late final Animation<double> _rise = CurvedAnimation(
    parent: _controller,
    curve: DsCurves.out,
    reverseCurve: DsCurves.out.flipped,
  );

  /// …and border-colour rides `--ease-standard`.
  late final Animation<double> _tint = CurvedAnimation(
    parent: _controller,
    curve: DsCurves.standard,
    reverseCurve: DsCurves.standard.flipped,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _hover(bool hovered) {
    _controller.duration = dsAnimationDuration(context, DsDurations.base);
    if (hovered) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  /// `box-shadow: none` in CSS interpolates as a fully transparent shadow of
  /// zero size, so the shadow fades *in* rather than snapping to full ink at
  /// zero blur — which is what lerping from an empty list would do.
  List<BoxShadow> _shadowAt(List<BoxShadow> lifted, double t) {
    if (t <= 0) return const <BoxShadow>[];
    if (t >= 1) return lifted;
    final List<BoxShadow> none = <BoxShadow>[
      for (int i = 0; i < lifted.length; i++)
        const BoxShadow(color: dsTransparent), // allow-hardcoded: CSS `none`
    ];
    return BoxShadow.lerpList(none, lifted, t)!;
  }

  Color _colorAt(Color from, Color to, double t) {
    if (t <= 0 || from == to) return from;
    if (t >= 1) return to;
    return Color.lerp(from, to, t)!;
  }

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final BorderRadius radius =
        widget.radius ?? BorderRadius.circular(DsRadii.xl);
    final Color resting = widget.borderColor ?? theme.border;
    final Color hovering = widget.hoverBorderColor ?? resting;
    final List<BoxShadow> lifted =
        (widget.shadow ?? DsShadows.e3).outerShadows(theme);

    return DsLift(
      cursor: widget.onTap == null ? MouseCursor.defer : widget.cursor,
      builder: (BuildContext context, bool hovered) {
        _hover(hovered);
        return GestureDetector(
          onTap: widget.onTap,
          behavior: HitTestBehavior.opaque,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, Widget? child) => Transform.translate(
              offset: Offset(0, DsTransforms.liftY * _rise.value),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: widget.fill ?? theme.card,
                  borderRadius: radius,
                  border: Border.all(
                    color: _colorAt(resting, hovering, _tint.value),
                    width: DsWidths.hairline,
                  ),
                  boxShadow: _shadowAt(lifted, _rise.value),
                ),
                child: child,
              ),
            ),
            child: Padding(
              // `box-sizing: border-box`: the hairline is paid for out of the
              // card's own box, so the content box is the card minus its
              // padding *and* minus the border on each side. [Container] adds
              // `decoration.padding` for exactly this reason; [DecoratedBox]
              // paints the border without reserving room for it, and the two
              // pixels it hands back are enough to move a line-wrap point.
              padding: widget.padding.add(
                const EdgeInsets.all(DsWidths.hairline),
              ),
              child: widget.builder(context, hovered),
            ),
          ),
        );
      },
    );
  }
}
