/// `components/ui/button.tsx` — the outline and ghost variants.
///
/// Phase 1 needs exactly two of the seven: the docs shell's mobile-nav trigger
/// (`variant="outline" size="icon"`) and the sheet's close button
/// (`variant="ghost" size="icon-sm"`). The enums are shaped so the other five
/// (default, premium, secondary, destructive, link) drop in later without a
/// rename — they need `sheen-action` and `foil-value`, which are out of scope
/// for these four pages.
///
/// The feel is `btn-spring` (globals.css L1886): transform, background,
/// border, colour, box-shadow and opacity all transition at `--duration-base`
/// on `--ease-spring`, and `:active` shortens that to `--duration-tick`.
library;

import 'package:flutter/widgets.dart';

import '../foundation/colors.dart';
import '../foundation/motion.dart';
import '../foundation/shadows.dart';
import '../foundation/spacing.dart';
import '../foundation/theme.dart';
import '../foundation/typography.dart';
import '../effects/machine_surface.dart';
import '../motion/press.dart';
import '../theme_scope.dart';

/// The phase-1 subset of the `cva` variants.
enum DsButtonVariant {
  /// `border-input bg-card text-foreground shadow-btn hover:bg-muted
  /// active:shadow-btn-down` — a machine surface you can press.
  outline,

  /// `text-muted-foreground hover:bg-secondary hover:text-foreground
  /// active:bg-muted` — no fill, no border, no elevation until touched.
  ghost,
}

/// The sizes the docs chrome uses.
enum DsButtonSize {
  /// `h-8 gap-1.5 px-3.5` — 32px tall.
  sm,

  /// `h-10 gap-2 px-4` — 40px tall. The `default` size.
  md,

  /// `size-10` — a 40px square.
  icon,

  /// `size-8` — a 32px square.
  iconSm,
}

/// `disabled:opacity-45` — the one opacity in the base class list.
const double _disabledOpacity = 0.45;

/// What a variant paints in a given state. Pulled out so the state table
/// reads as a table.
class _ButtonSkin {
  const _ButtonSkin({
    required this.fill,
    required this.border,
    required this.content,
    required this.shadow,
  });

  final Color fill;
  final Color border;
  final Color content;
  final DsShadowSpec shadow;
}

/// A pill button.
class DsButton extends StatefulWidget {
  const DsButton({
    super.key,
    required this.child,
    this.variant = DsButtonVariant.outline,
    this.size = DsButtonSize.md,
    this.onPressed,
    this.label,
  });

  /// The button's content — an icon, a label, or a row of both spaced by
  /// [gapFor].
  final Widget child;

  final DsButtonVariant variant;

  final DsButtonSize size;

  /// `null` disables the button: `disabled:pointer-events-none
  /// disabled:opacity-45`.
  final VoidCallback? onPressed;

  /// The accessible name, for the icon-only sizes that carry an `sr-only`
  /// span in the reference.
  final String? label;

  /// `h-*` / `size-*`.
  static double heightFor(DsButtonSize size) => switch (size) {
        DsButtonSize.sm || DsButtonSize.iconSm => ds(8),
        DsButtonSize.md || DsButtonSize.icon => ds(10),
      };

  /// `gap-*` — the space between an icon and its label.
  ///
  /// Exposed rather than applied, because this component takes one [child]:
  /// a button with both an icon and a label composes its own row and asks
  /// here for the spacing rather than inventing it.
  static double gapFor(DsButtonSize size) => switch (size) {
        DsButtonSize.sm => ds(1.5),
        DsButtonSize.md => ds(2),
        DsButtonSize.icon || DsButtonSize.iconSm => 0,
      };

  /// `px-*`. The square sizes have none — they centre their glyph.
  static double paddingXFor(DsButtonSize size) => switch (size) {
        DsButtonSize.sm => ds(3.5),
        DsButtonSize.md => ds(4),
        DsButtonSize.icon || DsButtonSize.iconSm => 0,
      };

  /// Whether the size is one of the two squares.
  static bool isSquare(DsButtonSize size) =>
      size == DsButtonSize.icon || size == DsButtonSize.iconSm;

  @override
  State<DsButton> createState() => _DsButtonState();
}

class _DsButtonState extends State<DsButton> {
  bool _hovered = false;
  bool _pressed = false;

  bool get _enabled => widget.onPressed != null;

  void _setHovered(bool value) {
    if (_hovered == value) return;
    setState(() => _hovered = value);
  }

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  /// The state table, variant by variant.
  ///
  /// `:active` is read as "pressed", and on a pointer device a press implies a
  /// hover — which is why ghost's `active:bg-muted` sits below its
  /// `hover:text-foreground` rather than beside it.
  _ButtonSkin _skin(DsThemeData theme) {
    switch (widget.variant) {
      case DsButtonVariant.outline:
        return _ButtonSkin(
          // `active:` changes only the elevation here — the fill stays put.
          fill: _hovered ? theme.muted : theme.card,
          border: theme.input,
          content: theme.foreground,
          shadow: _pressed ? DsShadows.btnDown : DsShadows.btn,
        );
      case DsButtonVariant.ghost:
        return _ButtonSkin(
          fill: _pressed
              ? theme.muted
              : _hovered
                  ? theme.secondary
                  : dsTransparent,
          // The base class list is `border border-transparent` for every
          // variant: a real 1px border that costs a pixel of inner width.
          border: dsTransparent,
          content:
              _hovered || _pressed ? theme.foreground : theme.mutedForeground,
          shadow: DsShadows.none,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final _ButtonSkin skin = _skin(theme);
    final double height = DsButton.heightFor(widget.size);
    final bool square = DsButton.isSquare(widget.size);

    // `btn-spring`: 250ms, dropping to `--duration-tick` while active.
    final Duration transition = dsAnimationDuration(
      context,
      _pressed ? DsDurations.tick : DsDurations.base,
    );

    Widget button = TweenAnimationBuilder<Color?>(
      tween: ColorTween(end: skin.fill),
      duration: transition,
      curve: DsCurves.spring,
      builder: (BuildContext context, Color? fill, Widget? child) =>
          TweenAnimationBuilder<Color?>(
        tween: ColorTween(end: skin.content),
        duration: transition,
        curve: DsCurves.spring,
        builder: (BuildContext context, Color? ink, Widget? content) =>
            DsMachineSurface(
          spec: skin.shadow,
          radius: BorderRadius.circular(DsRadii.pill),
          fill: fill,
          border: Border.all(color: skin.border, width: DsWidths.hairline),
          child: Padding(
            // The border is inside the box, so its width comes off the
            // padding — `box-sizing: border-box`.
            padding: EdgeInsets.symmetric(
              horizontal:
                  DsButton.paddingXFor(widget.size) + DsWidths.hairline,
            ),
            child: Center(
              widthFactor: square ? null : 1,
              child: DefaultTextStyle(
                style: DsText.styleOf(
                  context,
                  DsComponentType.buttonLabel,
                  color: ink!,
                ),
                child: content!,
              ),
            ),
          ),
        ),
        child: child,
      ),
      child: widget.child,
    );

    button = SizedBox(
      width: square ? height : null,
      height: height,
      child: button,
    );

    button = DsPress(
      scale: DsTransforms.buttonScale,
      // `btn-spring`'s `:active { transition-duration: --duration-tick }`,
      // where a bare `press` surface would use 40ms.
      downDuration: DsDurations.tick,
      upDuration: DsDurations.base,
      onTap: widget.onPressed,
      child: Listener(
        onPointerDown: (_) => _setPressed(true),
        onPointerUp: (_) => _setPressed(false),
        onPointerCancel: (_) => _setPressed(false),
        child: MouseRegion(
          cursor: _enabled ? SystemMouseCursors.click : MouseCursor.defer,
          onEnter: (_) => _setHovered(true),
          onExit: (_) => _setHovered(false),
          child: button,
        ),
      ),
    );

    button = Opacity(
      opacity: _enabled ? 1 : _disabledOpacity,
      child: IgnorePointer(ignoring: !_enabled, child: button),
    );

    if (widget.label == null) return button;
    return Semantics(button: true, label: widget.label, child: button);
  }
}
