/// `components/ui/button.tsx` — every variant the `cva` declares.
///
/// The component's own docstring names the three things that make it feel the
/// way it does: an **asymmetric spring** (the press registers in 80ms and
/// springs back over 250ms on `--ease-spring` — instant in, bouncy out), **real
/// depth** (an inner top highlight and inner bottom shade make the surface read
/// as a physical key, and `active:shadow-btn-down` sinks it into its socket
/// rather than merely dimming it), and the **pill shape** (controls are fully
/// rounded; only containers use the radius ladder).
///
/// The feel is `btn-spring` (globals.css L1886–1898): transform, background,
/// border, colour, box-shadow and opacity all transition at `--duration-base`
/// on `--ease-spring`, and `:active` shortens that to `--duration-tick`.
///
/// Two variants are not a flat fill. `default` wears `sheen-action` and
/// `premium` wears `foil-value` — a gradient ramp plus two blended
/// pseudo-layers each — so those two route their surface through
/// [DsSheenAction] / [DsFoilValue] instead of [DsMachineSurface]. The rest of
/// the state table is shared.
library;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../effects/foil_value.dart';
import '../effects/machine_surface.dart';
import '../effects/sheen_action.dart';
import '../foundation/colors.dart';
import '../foundation/motion.dart';
import '../foundation/shadows.dart';
import '../foundation/spacing.dart';
import '../foundation/theme.dart';
import '../foundation/typography.dart';
import '../motion/press.dart';
import '../theme_scope.dart';

/// The seven `cva` variants, in the reference's own declaration order.
enum DsButtonVariant {
  /// `variant="default"` — `sheen-action bg-primary text-primary-foreground
  /// shadow-btn-primary active:shadow-btn-down`. *"Primary action. Blue is
  /// interaction."*
  ///
  /// Named [primary] because `default` is a Dart keyword. It is the cva's
  /// `defaultVariants.variant` and it is this widget's default too.
  primary,

  /// `foil-value font-semibold text-value-foreground shadow-btn-value
  /// hover:shadow-glow-value active:shadow-btn-down` — *"Premium / money
  /// action. Lime is worth. The only glowing button."*
  premium,

  /// `bg-secondary text-secondary-foreground hover:bg-accent
  /// aria-expanded:bg-accent` — *"Neutral action beside a primary one."*
  ///
  /// Carries **no shadow class at all**, which the shadows page's own copy
  /// contradicts — see the drift note on [DsButton].
  secondary,

  /// `border-input bg-card text-foreground shadow-btn hover:bg-muted
  /// active:shadow-btn-down aria-expanded:bg-muted` — a machine surface you
  /// can press. *"Bordered. For actions that must not compete with the
  /// primary."*
  outline,

  /// `text-muted-foreground hover:bg-secondary hover:text-foreground
  /// active:bg-muted aria-expanded:bg-secondary aria-expanded:text-foreground`
  /// — no fill, no border, no elevation until touched.
  ghost,

  /// `border-destructive/25 bg-destructive/10 text-destructive-ink
  /// hover:border-destructive/40 hover:bg-destructive/20
  /// focus-visible:border-destructive/50 focus-visible:ring-destructive/25`.
  ///
  /// *"Deliberately a tint rather than a solid fill: white on #FF5B6E measures
  /// only 3:1, whereas error-on-tint clears AA and still reads unmistakably as
  /// danger."* Also carries no shadow class.
  destructive,

  /// `text-action-ink underline-offset-4 hover:underline` — *"Text button."*
  ///
  /// Keeps the base list's pill, height, padding, spring and focus ring; only
  /// the paint is stripped.
  link,
}

/// The sizes the docs chrome uses.
///
/// The reference declares nine (`xs`/`sm`/`default`/`lg`/`xl` and four square
/// `icon-*` steps); these four are the ones anything in this port asks for.
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

/// `focus-visible:ring-3` — a `0 0 0 3px` non-inset ring: zero offset, zero
/// blur, 3px spread.
const double _focusRingSpread = 3;

/// `focus-visible:ring-ring/50` on every variant but [DsButtonVariant.destructive].
const double _focusRingAlpha = 0.50;

/// `border-destructive/25` / `bg-destructive/10` at rest.
const double _destructiveBorderAlpha = 0.25;
const double _destructiveFillAlpha = 0.10;

/// `hover:border-destructive/40` / `hover:bg-destructive/20`.
const double _destructiveHoverBorderAlpha = 0.40;
const double _destructiveHoverFillAlpha = 0.20;

/// `focus-visible:border-destructive/50` / `focus-visible:ring-destructive/25`
/// — the destructive variant overrides both halves of the base focus ring.
const double _destructiveFocusBorderAlpha = 0.50;
const double _destructiveFocusRingAlpha = 0.25;

/// `--font-weight-semibold: 600` (globals.css L179), which `font-semibold` on
/// the premium variant sets over the base list's `font-medium`.
const double _semiboldWght = 600;

/// What a variant paints in a given state. Pulled out so the state table
/// reads as a table.
class _ButtonSkin {
  const _ButtonSkin({
    required this.fill,
    required this.border,
    required this.content,
    required this.shadow,
    required this.ring,
    this.semibold = false,
    this.underline = false,
  });

  final Color fill;
  final Color border;
  final Color content;
  final DsShadowSpec shadow;

  /// The colour `focus-visible:ring-*` paints, already at its modifier alpha.
  final Color ring;

  /// `font-semibold` — premium only.
  final bool semibold;

  /// `hover:underline` — link only.
  final bool underline;
}

/// A pill button.
///
/// DOCUMENTED DRIFT (shadows-map §12.1–12.2), recorded here because this file
/// is where a reader will go looking for it: the shadows page's specimen copy
/// says `--shadow-btn` is for *"Secondary, outline and destructive buttons"*
/// and its `#in-use` caption says buttons *"carry `shadow-btn` or
/// `shadow-btn-primary`"*. In fact only [DsButtonVariant.outline] carries
/// `shadow-btn`; [DsButtonVariant.secondary] and [DsButtonVariant.destructive]
/// declare no shadow class at all, and [DsButtonVariant.premium] carries
/// `shadow-btn-value`. The copy ships as written; the buttons ship as coded.
class DsButton extends StatefulWidget {
  const DsButton({
    super.key,
    required this.child,
    this.variant = DsButtonVariant.primary,
    this.size = DsButtonSize.md,
    this.onPressed,
    this.label,
    this.focusNode,
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

  /// Supply one to drive `:focus-visible` from outside; otherwise the button
  /// owns its own node.
  final FocusNode? focusNode;

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

  /// [spec] with `focus-visible:ring-3 focus-visible:ring-<c>` composited in
  /// front of it — the shared focus-ring helper both this widget and `DsInput`
  /// reach for.
  ///
  /// Tailwind v4 composites its shadow slots in the order `inset-shadow,
  /// inset-ring, ring-offset, **ring**, shadow`, so the ring paints *in front
  /// of* the element's own `--tw-shadow` rather than behind it. CSS paints the
  /// first-listed `box-shadow` layer on top and [DsShadowSpec.outerShadows]
  /// reverses the list to reproduce that, so **prepending** the ring layer is
  /// exactly what "in front of" means here.
  ///
  /// [ring] arrives already at its modifier alpha — `--ring` @ 50% on a
  /// button, @ 35% on an input, `--destructive` @ 25% on a destructive button.
  static DsShadowSpec withFocusRing(DsShadowSpec spec, Color ring) =>
      DsShadowSpec(<DsShadowLayer>[
        DsShadowLayer(0, 0, 0, _focusRingSpread, (DsThemeData _) => ring),
        ...spec.layers,
      ]);

  @override
  State<DsButton> createState() => _DsButtonState();
}

class _DsButtonState extends State<DsButton> {
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;

  bool get _enabled => widget.onPressed != null;

  void _setHovered(bool value) {
    if (_hovered == value) return;
    setState(() => _hovered = value);
  }

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  void _setFocused(bool value) {
    if (_focused == value) return;
    setState(() => _focused = value);
  }

  /// `<button>` activates on Enter and on Space. Flutter gives a bare
  /// [Listener] neither, so the keyboard path is wired by hand — otherwise the
  /// focus ring would mark a control that cannot be operated from the keyboard.
  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (!_enabled || event is! KeyDownEvent) return KeyEventResult.ignored;
    final bool activates = event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.numpadEnter ||
        event.logicalKey == LogicalKeyboardKey.space;
    if (!activates) return KeyEventResult.ignored;
    widget.onPressed!();
    return KeyEventResult.handled;
  }

  /// The state table, variant by variant.
  ///
  /// `:active` is read as "pressed", and on a pointer device a press implies a
  /// hover — which is why ghost's `active:bg-muted` sits below its
  /// `hover:text-foreground` rather than beside it. Tailwind orders `active`
  /// after `hover`, so **active outranks hover** wherever both declare the
  /// same property: premium's `active:shadow-btn-down` beats its
  /// `hover:shadow-glow-value`, and outline's beats nothing but its own rest.
  _ButtonSkin _skin(DsThemeData theme) {
    switch (widget.variant) {
      case DsButtonVariant.primary:
        return _ButtonSkin(
          // `bg-primary` under the `sheen-action` ramp, which is opaque and
          // covers it — carried anyway because the class list carries it.
          fill: theme.primary,
          border: dsTransparent,
          content: theme.primaryForeground,
          shadow: _pressed ? DsShadows.btnDown : DsShadows.btnPrimary,
          ring: theme.ring.withValues(alpha: _focusRingAlpha),
        );

      case DsButtonVariant.premium:
        return _ButtonSkin(
          fill: DsPalette.value,
          border: dsTransparent,
          // `--color-value-foreground`: the one foreground in the system that
          // deliberately does NOT flip with the theme (globals.css L111–127) —
          // the foil is an opaque metal ramp, the same lime on a white page as
          // on a black one, so its label has to be dark in both.
          content: DsPalette.valueForeground,
          shadow: _pressed
              ? DsShadows.btnDown
              : _hovered
                  // `hover:shadow-glow-value` replaces the token WHOLESALE:
                  // the inset rim and the inner shade disappear, they are not
                  // added to.
                  ? DsShadows.glowValue
                  : DsShadows.btnValue,
          ring: theme.ring.withValues(alpha: _focusRingAlpha),
          semibold: true,
        );

      case DsButtonVariant.secondary:
        return _ButtonSkin(
          // No `active:` class of its own, so a press keeps the hover fill and
          // changes nothing but the scale.
          fill: _hovered ? theme.accent : theme.secondary,
          border: dsTransparent,
          content: theme.secondaryForeground,
          shadow: DsShadows.none,
          ring: theme.ring.withValues(alpha: _focusRingAlpha),
        );

      case DsButtonVariant.outline:
        return _ButtonSkin(
          // `active:` changes only the elevation here — the fill stays put.
          fill: _hovered ? theme.muted : theme.card,
          border: theme.input,
          content: theme.foreground,
          shadow: _pressed ? DsShadows.btnDown : DsShadows.btn,
          ring: theme.ring.withValues(alpha: _focusRingAlpha),
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
          ring: theme.ring.withValues(alpha: _focusRingAlpha),
        );

      case DsButtonVariant.destructive:
        return _ButtonSkin(
          fill: theme.destructive.withValues(
            alpha: _hovered ? _destructiveHoverFillAlpha : _destructiveFillAlpha,
          ),
          border: theme.destructive.withValues(
            alpha: _hovered
                ? _destructiveHoverBorderAlpha
                : _destructiveBorderAlpha,
          ),
          content: theme.destructiveInk,
          shadow: DsShadows.none,
          ring: theme.destructive.withValues(alpha: _destructiveFocusRingAlpha),
        );

      case DsButtonVariant.link:
        return _ButtonSkin(
          fill: dsTransparent,
          border: dsTransparent,
          content: theme.actionInk,
          shadow: DsShadows.none,
          ring: theme.ring.withValues(alpha: _focusRingAlpha),
          underline: _hovered,
        );
    }
  }

  /// `focus-visible:border-ring`, or `focus-visible:border-destructive/50`
  /// where the variant overrides it.
  Color _focusBorder(DsThemeData theme) =>
      widget.variant == DsButtonVariant.destructive
          ? theme.destructive.withValues(alpha: _destructiveFocusBorderAlpha)
          : theme.ring;

  /// `font-semibold` as an override on the resolved `text-sm` style.
  ///
  /// The reference does not declare a type class for it either — it stacks a
  /// weight utility on the button's own class list — so this is an override
  /// rather than a new `.type-*` spec. The `wght` axis entry is replaced in
  /// place so `font-optical-sizing`'s `opsz` entry survives.
  TextStyle _applySemibold(TextStyle base) {
    final List<FontVariation> axes = <FontVariation>[
      for (final FontVariation v
          in base.fontVariations ?? const <FontVariation>[])
        if (v.axis != 'wght') v,
      const FontVariation('wght', _semiboldWght),
    ];
    return base.copyWith(
      fontWeight: FontWeight.values[(_semiboldWght ~/ 100) - 1],
      fontVariations: axes,
    );
  }

  /// The variant's surface.
  ///
  /// Three of the seven paint a flat `background-color` and go through
  /// [DsMachineSurface] directly. `default` and `premium` paint a gradient
  /// `background-image` plus two blended pseudo-layers, which is what
  /// [DsSheenAction] and [DsFoilValue] are; they take the same shadow spec,
  /// radius and border and splice the ramp in where CSS puts it.
  Widget _surface({
    required DsShadowSpec spec,
    required BorderRadius radius,
    required Border border,
    required Color fill,
    required Widget child,
  }) {
    switch (widget.variant) {
      case DsButtonVariant.primary:
        return DsSheenAction(
          spec: spec,
          radius: radius,
          border: border,
          hovered: _hovered,
          pressed: _pressed,
          child: child,
        );
      case DsButtonVariant.premium:
        return DsFoilValue(
          spec: spec,
          radius: radius,
          border: border,
          hovered: _hovered,
          child: child,
        );
      case DsButtonVariant.secondary:
      case DsButtonVariant.outline:
      case DsButtonVariant.ghost:
      case DsButtonVariant.destructive:
      case DsButtonVariant.link:
        return DsMachineSurface(
          spec: spec,
          radius: radius,
          fill: fill,
          border: border,
          child: child,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final _ButtonSkin skin = _skin(theme);
    final double height = DsButton.heightFor(widget.size);
    final bool square = DsButton.isSquare(widget.size);
    final BorderRadius radius = BorderRadius.circular(DsRadii.pill);

    // `btn-spring`: 250ms, dropping to `--duration-tick` while active.
    final Duration transition = dsAnimationDuration(
      context,
      _pressed ? DsDurations.tick : DsDurations.base,
    );

    final Color borderColor = _focused ? _focusBorder(theme) : skin.border;
    final DsShadowSpec spec =
        _focused ? DsButton.withFocusRing(skin.shadow, skin.ring) : skin.shadow;

    Widget button = _SpringColors(
      fill: skin.fill,
      border: borderColor,
      content: skin.content,
      duration: transition,
      builder: (BuildContext context, Color fill, Color border, Color ink) {
        TextStyle style = DsText.styleOf(
          context,
          DsComponentType.buttonLabel,
          color: ink,
        );
        if (skin.semibold) style = _applySemibold(style);
        if (skin.underline) {
          // `underline-offset-4` has no Flutter equivalent — [TextStyle] can
          // say that a run is underlined but not how far below the baseline.
          // The rule renders at the font's own offset instead.
          style = style.copyWith(
            decoration: TextDecoration.underline,
            decorationColor: ink,
          );
        }
        return _surface(
          spec: spec,
          radius: radius,
          border: Border.all(color: border, width: DsWidths.hairline),
          fill: fill,
          child: Padding(
            // Just `px-*`: the border is inside the box and the surface
            // already insets this child by its width, the way `box-sizing:
            // border-box` does.
            padding: EdgeInsets.symmetric(
              horizontal: DsButton.paddingXFor(widget.size),
            ),
            child: Center(
              widthFactor: square ? null : 1,
              child: DefaultTextStyle(style: style, child: widget.child),
            ),
          ),
        );
      },
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

    // `:focus-visible`, not `:focus`. Flutter does not move focus on a bare
    // pointer tap — only keyboard traversal or an explicit request focuses
    // this node — so `hasFocus` here IS the keyboard-only predicate CSS means.
    button = Focus(
      focusNode: widget.focusNode,
      canRequestFocus: _enabled,
      onFocusChange: _setFocused,
      onKeyEvent: _onKey,
      child: button,
    );

    button = Opacity(
      opacity: _enabled ? 1 : _disabledOpacity,
      child: IgnorePointer(ignoring: !_enabled, child: button),
    );

    if (widget.label == null) return button;
    return Semantics(button: true, label: widget.label, child: button);
  }
}

/// `btn-spring` transitions `background-color`, `border-color` and `color`
/// together, on one duration and one curve.
///
/// [TweenAnimationBuilder] animates one value, so three are nested. The
/// alternative — one controller driving three [ColorTween]s — would have to
/// re-aim every tween by hand each time a target changes mid-flight, which is
/// the exact thing [TweenAnimationBuilder] already does for free.
class _SpringColors extends StatelessWidget {
  const _SpringColors({
    required this.fill,
    required this.border,
    required this.content,
    required this.duration,
    required this.builder,
  });

  final Color fill;
  final Color border;
  final Color content;
  final Duration duration;
  final Widget Function(BuildContext, Color fill, Color border, Color content)
      builder;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<Color?>(
      tween: ColorTween(end: fill),
      duration: duration,
      curve: DsCurves.spring,
      builder: (BuildContext context, Color? f, Widget? _) =>
          TweenAnimationBuilder<Color?>(
        tween: ColorTween(end: border),
        duration: duration,
        curve: DsCurves.spring,
        builder: (BuildContext context, Color? b, Widget? _) =>
            TweenAnimationBuilder<Color?>(
          tween: ColorTween(end: content),
          duration: duration,
          curve: DsCurves.spring,
          builder: (BuildContext context, Color? c, Widget? _) =>
              builder(context, f ?? fill, b ?? border, c ?? content),
        ),
      ),
    );
  }
}
