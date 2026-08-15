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
import 'spinner.dart';

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

/// The nine `cva` size rungs, in the reference's own declaration order
/// (`button.tsx` L57–69).
///
/// Five text rungs and four squares. The text ladder is **32 / 40 / 48 / 56
/// plus a 24px step for dense internals**, and the component's own docstring
/// says why it is taller than stock shadcn: *"a premium product's primary
/// action cannot be 32px tall."*
///
/// Two things about it are worth knowing before reading [typeFor]:
///
/// * **Five rungs, three type sizes.** `sm` and `default` are both 13px, `lg`
///   and `xl` are both 15px; only `xs` is unique at the bottom. The ladder is a
///   *height* ladder that changes type twice (buttons-map drift 15).
/// * **The four `icon-*` rungs declare no `gap-*`, no `px-*` and no `text-*`
///   at all.** They are pure squares that inherit their type from the page.
///
/// `icon-xs` is declared here and rendered nowhere: the reference's cva
/// declares it and the API table prints it, and the page shows 8 of the 9
/// (drift 17). Supervisor ruling B3 — build nine of nine, so the printed API
/// row stays true.
enum DsButtonSize {
  /// `h-6 gap-1 px-2.5 text-xs` — 24px tall. *"Dense internal use only — chips
  /// inside combobox and attachment."*
  xs,

  /// `h-8 gap-1.5 px-3.5 text-small` — 32px tall.
  sm,

  /// `h-10 gap-2 px-4 text-sm` — 40px tall. The `default` size.
  ///
  /// Named [md] because `default` is a Dart keyword — the same rename
  /// [DsButtonVariant.primary] carries, and for the same reason.
  md,

  /// `h-12 gap-2.5 px-6 text-body` — 48px tall.
  lg,

  /// `h-14 gap-2.5 px-8 text-base` — 56px tall. *"Hero CTA only — landing page
  /// and pack opening."*
  xl,

  /// `size-6` — a 24px square.
  iconXs,

  /// `size-8` — a 32px square.
  iconSm,

  /// `size-10` — a 40px square.
  icon,

  /// `size-12` — a 48px square.
  iconLg,
}

/// The third cva axis (`button.tsx` L71–75) — *"uppercase label treatment for
/// pack and money CTAs."*
enum DsButtonEmphasis {
  /// `emphasis="none"` — the empty string. The cva's own default.
  none,

  /// `emphasis="caps"` — `text-num-sm font-semibold tracking-cta uppercase`.
  ///
  /// An axis, not a rung: cva emits variant → size → emphasis and
  /// tailwind-merge keeps the later class in each group, so this beats whatever
  /// `text-*` the size declared **and** the base `font-medium`, on all nine
  /// sizes. On the `default` rung that means the label *shrinks*, 13px → 12
  /// (buttons-map drift 22).
  caps,
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
    this.emphasis = DsButtonEmphasis.none,
    this.loading = false,
    this.onPressed,
    this.label,
    this.focusNode,
  });

  /// The button's content — an icon, a label, or a row of both spaced by
  /// [gapFor].
  final Widget child;

  final DsButtonVariant variant;

  final DsButtonSize size;

  /// The uppercase treatment. See [DsButtonEmphasis.caps].
  final DsButtonEmphasis emphasis;

  /// `loading` (`button.tsx` L104, L120–127, L134–136) — four things at once:
  ///
  /// ```
  /// content  = <>{loading && <Spinner />}{children}</>
  /// data-loading = loading || undefined
  /// aria-busy    = loading || undefined
  /// disabled     = disabled || loading
  /// ```
  ///
  /// So it **prepends a spinner**, **disables the button** — which pulls in the
  /// base `disabled:pointer-events-none disabled:opacity-45` — and announces
  /// itself as busy. The port does the first two exactly; the third is where
  /// Flutter runs out of vocabulary, and [_DsButtonState.build] records why.
  ///
  /// DOCUMENTED DRIFT (buttons-map drift 3, forms-map drift 2). The prop's own
  /// JSDoc says *"The label stays in place so the button does not change width
  /// mid-action"*, the states cell is captioned *"Disabled, width held"*, and
  /// the rules list repeats it a fourth time. The spinner is **prepended**, so
  /// the button grows by [DsSpinner.px] + [gapFor] = **24px on the `default`
  /// rung**. It is accidentally true only where a parent stretches the button
  /// to a fixed width, which is what the forms page does and what the states
  /// grid does not. Four statements, false every time; all four ship.
  final bool loading;

  /// `null` disables the button: `disabled:pointer-events-none
  /// disabled:opacity-45`. [loading] disables it too.
  final VoidCallback? onPressed;

  /// The accessible name, for the icon-only sizes that carry an `sr-only`
  /// span in the reference.
  final String? label;

  /// Supply one to drive `:focus-visible` from outside; otherwise the button
  /// owns its own node.
  final FocusNode? focusNode;

  /// `h-*` / `size-*`.
  static double heightFor(DsButtonSize size) => switch (size) {
        DsButtonSize.xs || DsButtonSize.iconXs => ds(6),
        DsButtonSize.sm || DsButtonSize.iconSm => ds(8),
        DsButtonSize.md || DsButtonSize.icon => ds(10),
        DsButtonSize.lg || DsButtonSize.iconLg => ds(12),
        DsButtonSize.xl => ds(14),
      };

  /// `gap-*` — the space between an icon and its label.
  ///
  /// Exposed rather than applied, because this component takes one [child]:
  /// a button with both an icon and a label composes its own row and asks
  /// here for the spacing rather than inventing it. The one case where the
  /// button applies it itself is [loading], which prepends a child of its own
  /// and therefore owns the gap in front of it.
  ///
  /// `lg` and `xl` share `gap-2.5`; the four squares declare none.
  static double gapFor(DsButtonSize size) => switch (size) {
        DsButtonSize.xs => ds(1),
        DsButtonSize.sm => ds(1.5),
        DsButtonSize.md => ds(2),
        DsButtonSize.lg || DsButtonSize.xl => ds(2.5),
        DsButtonSize.iconXs ||
        DsButtonSize.iconSm ||
        DsButtonSize.icon ||
        DsButtonSize.iconLg =>
          0,
      };

  /// `px-*`. The square sizes have none — they centre their glyph.
  static double paddingXFor(DsButtonSize size) => switch (size) {
        DsButtonSize.xs => ds(2.5),
        DsButtonSize.sm => ds(3.5),
        DsButtonSize.md => ds(4),
        DsButtonSize.lg => ds(6),
        DsButtonSize.xl => ds(8),
        DsButtonSize.iconXs ||
        DsButtonSize.iconSm ||
        DsButtonSize.icon ||
        DsButtonSize.iconLg =>
          0,
      };

  /// `[&_svg:not([class*='size-'])]:size-*` — the px a rung forces on an icon
  /// child that does not state a size of its own.
  ///
  /// The base class list sets `size-4`; four rungs override it, and `md`/`lg`
  /// are the two text rungs that leave the base value alone.
  ///
  /// **This is the port's honest version of a CSS descendant selector.** The
  /// reference restyles the `<svg>` from the button; a Flutter parent cannot
  /// reach into [child] and resize a [DsIcon], so the rung publishes the number
  /// and the caller passes it. It is also why buttons-map drift 6 exists at
  /// all: `Icon size="sm"` writes 14 as an *attribute* and never emits a
  /// `size-*` class, so the CSS wins the box at 16 while `strokeWidth` keeps
  /// being computed from the declared 14. Invisible only because
  /// `strokeFor(14) == strokeFor(16) == 2.4`.
  static double iconPxFor(DsButtonSize size) => switch (size) {
        DsButtonSize.xs || DsButtonSize.iconXs => 12,
        DsButtonSize.sm || DsButtonSize.iconSm => 14,
        DsButtonSize.md || DsButtonSize.lg || DsButtonSize.icon => 16,
        DsButtonSize.xl || DsButtonSize.iconLg => 20,
      };

  /// The `text-*` class a rung declares, or **null** where it declares none.
  ///
  /// Null is not a missing case: the four `icon-*` rungs genuinely set no
  /// font-size, so their label inherits whatever the page is set in — which is
  /// what [_DsButtonState.build] reproduces by merging only the ink into the
  /// ambient [DefaultTextStyle] instead of replacing it.
  ///
  /// [emphasis] is checked first because cva emits it last: `caps` overrides
  /// every rung's own class, squares included.
  static DsTypeSpec? typeFor(DsButtonSize size, DsButtonEmphasis emphasis) {
    if (emphasis == DsButtonEmphasis.caps) {
      return DsComponentType.buttonLabelCaps;
    }
    return switch (size) {
      DsButtonSize.xs => DsComponentType.buttonLabelXs,
      DsButtonSize.sm => DsComponentType.buttonLabelSm,
      DsButtonSize.md => DsComponentType.buttonLabel,
      DsButtonSize.lg => DsComponentType.buttonLabelLg,
      DsButtonSize.xl => DsComponentType.buttonLabelXl,
      DsButtonSize.iconXs ||
      DsButtonSize.iconSm ||
      DsButtonSize.icon ||
      DsButtonSize.iconLg =>
        null,
    };
  }

  /// Whether the size is one of the four squares.
  static bool isSquare(DsButtonSize size) =>
      size == DsButtonSize.iconXs ||
      size == DsButtonSize.iconSm ||
      size == DsButtonSize.icon ||
      size == DsButtonSize.iconLg;

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

  /// `disabled = disabled || loading` — the reference ORs the two, so a
  /// loading button is a disabled button and takes the whole disabled branch:
  /// 45% opacity, no pointer events, no focus.
  bool get _enabled => widget.onPressed != null && !widget.loading;

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

  /// `text-transform: uppercase`, which Flutter has no [TextStyle] for.
  ///
  /// CSS transforms the *rendered* glyphs and leaves the DOM text alone, so the
  /// accessible name of a `caps` button is still "Claim Reward" — a screen
  /// reader never hears the shouting. That is reproduced here: the visible
  /// string is uppercased and [Text.semanticsLabel] is pinned to the original,
  /// which is Flutter's spelling of the same split.
  ///
  /// It reaches a [Text] child only. A CSS `text-transform` inherits through
  /// the whole subtree, and nothing here does — but the reference passes `caps`
  /// exactly one shape, a bare string, and a widget walker that rebuilt
  /// arbitrary descendants would be a much larger lie than this limit. Callers
  /// wrapping their label in anything else uppercase it themselves; the type
  /// spec still applies to the whole subtree, because that *is* inherited.
  Widget _caps(Widget child) {
    if (child is! Text) return child;
    final String? data = child.data;
    if (data == null) return child;
    return Text(
      data.toUpperCase(),
      key: child.key,
      style: child.style,
      strutStyle: child.strutStyle,
      textAlign: child.textAlign,
      textDirection: child.textDirection,
      softWrap: child.softWrap,
      overflow: child.overflow,
      textScaler: child.textScaler,
      maxLines: child.maxLines,
      semanticsLabel: child.semanticsLabel ?? data,
      textWidthBasis: child.textWidthBasis,
      textHeightBehavior: child.textHeightBehavior,
      selectionColor: child.selectionColor,
    );
  }

  /// `<>{loading && <Spinner />}{children}</>` — the button's own flex row.
  ///
  /// The spinner is **prepended**, and the gap between it and the label is the
  /// rung's own `gap-*`, because in CSS it is the button's flex `gap` doing the
  /// spacing rather than anything the spinner brings. That is where the missing
  /// 24px of [DsButton.loading]'s drift comes from: 16 for the glyph, 8 for
  /// `gap-2`.
  Widget _content() {
    final Widget label = widget.emphasis == DsButtonEmphasis.caps
        ? _caps(widget.child)
        : widget.child;
    if (!widget.loading) return label;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const DsSpinner(),
        SizedBox(width: DsButton.gapFor(widget.size)),
        label,
      ],
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
        final DsTypeSpec? typeSpec =
            DsButton.typeFor(widget.size, widget.emphasis);
        // Null means the rung declares no `text-*` class — the four squares.
        // CSS then leaves `font-size`, `line-height` and family inherited, and
        // the only thing the button contributes is its own `color`. Merging the
        // ink into the ambient style is exactly that; replacing the style would
        // be inventing a size the reference never sets.
        TextStyle style = typeSpec == null
            ? DefaultTextStyle.of(context).style.copyWith(color: ink)
            : DsText.styleOf(context, typeSpec, color: ink);
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
              child: DefaultTextStyle(style: style, child: _content()),
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

    // `<button>` — the element carries button semantics whether or not it also
    // carries an `sr-only` name, and `disabled` is part of what it exposes.
    //
    // `aria-busy` HAS NO FLUTTER ANALOGUE. Supervisor ruling B9 asks for the
    // web's split — the spinner silent, the button carrying the busy state —
    // and only half of it is expressible: `SemanticsProperties` in the pinned
    // SDK (3.44.8) declares `enabled`, `checked`, `expanded`, `toggled`,
    // `readOnly`, `liveRegion`, `isRequired` and the rest, and **no `busy`**.
    // There is no flag to set and no role to borrow that would not also
    // announce something the reference does not.
    //
    // So what ships is the half that is real: [loading] forces `enabled: false`
    // through [_enabled], which is exactly the state `aria-busy` accompanies on
    // the reference (`disabled = disabled || loading`), and assistive tech
    // learns the control is not actionable. What it does not learn is *why*.
    // Recorded rather than faked — inventing a hint string would put copy on
    // the page that the reference does not have, and the one drift class this
    // port does not ship is an invisible a11y difference in either direction.
    // `excludeSemantics` is what makes [label] behave like the `aria-label` it
    // ports. An accessible name given by `aria-label` **replaces** the
    // element's contents rather than joining them — an icon button labelled
    // "Search packs" is called exactly that, and a labelled button that also
    // holds text is called by its label alone. Without this, Flutter merges the
    // two and the name comes out "Search packs\n…". With `label == null` the
    // contents supply the name, which is the unlabelled `<button>`'s behaviour.
    return Semantics(
      button: true,
      enabled: _enabled,
      label: widget.label,
      excludeSemantics: widget.label != null,
      child: button,
    );
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
