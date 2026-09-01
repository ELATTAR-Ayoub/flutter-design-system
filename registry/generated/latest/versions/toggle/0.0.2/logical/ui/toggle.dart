/// `components/ui/toggle.tsx` — the whole `cva`, including the three
/// declarations on it that can never paint.
///
/// The section that renders it is captioned *"for state that persists rather
/// than actions that fire"*, and two things follow from that — both the
/// opposite of what [Button] does:
///
/// * **No press feedback at all.** The class list carries no `:active` rule and
///   no `btn-spring`. What it carries is a bare `transition-all`, which the
///   framework times at `--default-transition-duration` on
///   `--default-transition-timing-function` — and globals.css L395–396 points
///   those two at `--duration-base` and `--ease-out`. A Button squishes 5% and
///   registers in 80ms; a Toggle does nothing at all until the state actually
///   changes, then eases every changed property over 250ms (buttons-map
///   drift 11).
/// * **The on-state is grey, not blue.** `aria-pressed:bg-muted` and
///   `data-[state=on]:bg-muted` both fill with `--muted` — the very fill hover
///   paints. The page's own caption says *"the pressed state fills with the
///   blue tint — selection is always blue"*; the class says `--muted`
///   (buttons-map drift 5). Selection is blue exactly once on that page, and it
///   is the travelling pill in `ToggleGroup`, not this.
///
/// The base class list, resolved (`toggle.tsx` L10):
///
/// | class | value |
/// |---|---|
/// | `group/toggle inline-flex items-center justify-center gap-1` | hugs its content; 4px between an icon and a label ([Toggle.gap]) |
/// | `rounded-lg` | 12px — **not** a pill. Only the group's travelling pill is a stadium |
/// | `text-sm font-medium whitespace-nowrap` | 13px / 500, no wrapping |
/// | `transition-all` | every property, at the framework defaults above |
/// | `outline-none` | kills the global `:focus-visible` outline (globals.css L997–1000) |
/// | `hover:bg-muted hover:text-foreground` | fill `--muted`; **the ink half is inert** — see below |
/// | `focus-visible:border-ring` | **inert on `variant="default"`** — see below |
/// | `focus-visible:ring-3 focus-visible:ring-ring/50` | a `0 0 0 3px` ring at `--ring` @50%: the only focus affordance |
/// | `aria-pressed:bg-muted` + `data-[state=on]:bg-muted` | the on-fill, `--muted` |
/// | `disabled:pointer-events-none disabled:opacity-50` | **50%**, deliberately not the Button's 45% (drift 12) |
/// | `aria-invalid:*` | never set on this control anywhere in the reference |
/// | `[&_svg]:pointer-events-none [&_svg]:shrink-0` | — |
/// | `[&_svg:not([class*='size-'])]:size-4` | a lone icon child renders at 16px |
///
/// DOCUMENTED DRIFT (buttons-map drift 10) — **two of those declarations paint
/// nothing**, and the port reproduces the inertness rather than the intent:
///
/// * `hover:text-foreground` restates the colour the element already has. The
///   base sets no resting `color`, so Preflight's `button { color: inherit }`
///   has already given it `--foreground` from the page. Resting ink IS
///   `--foreground`, and hover changes nothing about it.
/// * `focus-visible:border-ring` has no border to colour on
///   [ToggleVariant.standard]: that variant is `bg-transparent` with no
///   border utility at all, so its box has zero border-width. It is live on
///   [ToggleVariant.outline], which brings `border border-input` with it.
library;

import 'dart:math' as math;

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

import './press.dart';
import './surface.dart';
import '../../design_system/foundation/colors.dart';
import '../../design_system/foundation/motion.dart';
import '../../design_system/foundation/shadows.dart';
import '../../design_system/foundation/spacing.dart';
import '../../design_system/foundation/surfaces.dart';
import '../../design_system/foundation/theme.dart';
import '../../design_system/foundation/typography.dart';
import '../../design_system/foundation/theme_scope.dart';
import './button.dart';
import './icon.dart';

/// The two `cva` variants (`toggle.tsx` L13–16).
///
/// Only [standard] is rendered anywhere in the reference; [outline] is declared
/// and never used. Both ship, because the page's `#api` table prints the row
/// `variant: default · outline` and a printed API row has to stay true.
enum ToggleVariant {
  /// `bg-transparent` — no fill, and **no border box at all**.
  ///
  /// Named [standard] because `default` is a Dart keyword, the same rename
  /// [ButtonVariant.primary] carries. It is the cva's `defaultVariants.
  /// variant` and it is this widget's default too.
  ///
  /// The missing border is load-bearing rather than cosmetic: with
  /// `box-sizing: border-box`, a 1px border would cost this control a pixel of
  /// inner width and height on each side. [Button]'s base list carries
  /// `border border-transparent` and pays that pixel; a Toggle's does not, so
  /// the port paints no border box here — not even a transparent one.
  standard,

  /// `border border-input bg-transparent hover:bg-muted` — a 1px rule, still
  /// no fill. The `hover:bg-muted` it re-declares is already in the base list.
  outline,
}

/// The three `cva` sizes (`toggle.tsx` L17–22).
///
/// Only [md] is rendered. [sm] and [lg] ship for the same reason [outline]
/// does — the `#api` row prints `size: sm · default · lg`.
enum ToggleSize {
  /// `h-7 min-w-7 rounded-[min(var(--radius-md),12px)] px-2.5 text-sm` —
  /// 28px tall, 10px radius, and the one rung whose icon child renders at
  /// 14px rather than 16.
  sm,

  /// `h-8 min-w-8 px-2.5` — 32px tall, 32px minimum wide, 10px of horizontal
  /// padding. With a lone 16px icon that measures 36×32.
  ///
  /// Named [md] because it is the cva's `defaultVariants.size`, matching
  /// [ButtonSize.md].
  md,

  /// `h-9 min-w-9 px-2.5` — 36px tall.
  lg,
}

/// `focus-visible:ring-ring/50` — the same alpha a Button's ring carries.
const double _focusRingAlpha = 0.50;

/// What the control paints in a given state — the same shape as `Button`'s
/// `_ButtonSkin`, so the state table reads as a table.
class _ToggleSkin {
  const _ToggleSkin({
    required this.fill,
    required this.border,
    required this.ink,
    required this.ring,
  });

  /// `background-color`.
  final Color fill;

  /// `border-color`. Resolved for both variants but only painted by
  /// [ToggleVariant.outline] — [ToggleVariant.standard] has no border box
  /// to colour, which is drift 10's second half.
  final Color border;

  /// `color`, which the element inherits rather than declares.
  final Color ink;

  /// The colour `focus-visible:ring-3 focus-visible:ring-*` paints, already at
  /// its modifier alpha.
  final Color ring;
}

/// A two-state control: pressed or not, and it stays that way.
///
/// Genuinely interactive — clickable, hoverable, keyboard-operable — because
/// the page's toggles are, and *"everything is a live component"*.
///
/// Three of the parameters below ([pressedFill], [pressedInk] and
/// [inExclusiveGroup]) exist for `ToggleGroup` alone. That is not a
/// convenience: a `ToggleGroupItem` **is** a Toggle in the reference — its
/// class list is `toggleVariants(...)` plus exactly two trailing declarations
/// (`toggle-group.tsx` L94) — and Radix gives it radio-shaped semantics for
/// `type="single"`. Duplicating this widget's geometry and state table into a
/// second widget to avoid three optional parameters would put two copies of
/// one `cva` in the port, which is the thing the reference itself refuses to
/// do.
class Toggle extends StatefulWidget {
  const Toggle({
    super.key,
    required this.child,
    required this.pressed,
    this.onChanged,
    this.variant = ToggleVariant.standard,
    this.size = ToggleSize.md,
    this.label,
    this.focusNode,
    this.pressedFill,
    this.pressedInk,
    this.inExclusiveGroup = false,
  });

  /// The content — a label, an icon, or a row of both spaced by [gap].
  ///
  /// A bare [Text] is the right child for a labelled toggle: this widget
  /// installs the resolved `text-sm font-medium` as a [DefaultTextStyle],
  /// carrying `transition-all`'s animated ink and `whitespace-nowrap` with it,
  /// and re-resolving the class through [StyledText] here would drop both.
  final Widget child;

  /// `data-state="on"` / `aria-pressed="true"`.
  ///
  /// The control is fully governed: it never holds its own state, because the
  /// group above it may need to clear the selection entirely.
  final bool pressed;

  /// Called with the value the control is asking to move to — always
  /// `!pressed`, since a toggle has exactly one other state.
  ///
  /// `null` disables it: `disabled:pointer-events-none disabled:opacity-50`.
  final ValueChanged<bool>? onChanged;

  final ToggleVariant variant;

  final ToggleSize size;

  /// The accessible name — the reference's `aria-label`, which is set on all
  /// three toggles the page renders because all three are icon-only.
  ///
  /// Like `aria-label`, it **replaces** any name the child's own content would
  /// supply rather than adding to it, so a labelled toggle with a [Text] child
  /// is announced once.
  final String? label;

  /// Supply one to drive `:focus-visible` from outside; otherwise the control
  /// owns its own node.
  final FocusNode? focusNode;

  /// The `data-[state=on]:bg-transparent` half of the override
  /// `ToggleGroupItem` appends **after** `toggleVariants(...)`
  /// (`toggle-group.tsx` L94, and its own comment at L91–93: *"the travelling
  /// pill is the background now, so the item gives up its own"*).
  ///
  /// Null — the default — keeps the cva's own on-fill, `--muted`.
  final Color? pressedFill;

  /// The `data-[state=on]:text-primary-foreground` half of the same override:
  /// white ink, because the pill underneath is `--primary`.
  ///
  /// Null keeps the inherited `--foreground`.
  final Color? pressedInk;

  /// Whether this control is one option of a mutually exclusive set —
  /// `ToggleGroup type="single"`.
  ///
  /// It changes only the semantics node. A standalone toggle is a button with
  /// an on/off state ([SemanticsProperties.toggled]); one option of a
  /// single-select group is not — it is a choice among others, which is
  /// [SemanticsProperties.inMutuallyExclusiveGroup] plus
  /// [SemanticsProperties.selected]. Radix draws the same distinction, and it
  /// is why a screen reader announces the group's three items as a set rather
  /// than as three independent switches.
  final bool inExclusiveGroup;

  /// `h-7` / `h-8` / `h-9`.
  static double heightFor(ToggleSize size) => switch (size) {
    ToggleSize.sm => space(7),
    ToggleSize.md => space(8),
    ToggleSize.lg => space(9),
  };

  /// `min-w-7` / `min-w-8` / `min-w-9` — the floor an icon-only toggle sits
  /// on, so a 16px glyph does not produce a 36px-wide box on a 32px-tall one.
  ///
  /// Every rung happens to declare `min-w-N` at its own `h-N`, which makes the
  /// control at least square. Kept as its own switch anyway: they are two
  /// separate declarations in the cva and either can move without the other.
  static double minWidthFor(ToggleSize size) => switch (size) {
    ToggleSize.sm => space(7),
    ToggleSize.md => space(8),
    ToggleSize.lg => space(9),
  };

  /// `px-2.5` — 10px, and all three rungs declare it, which is why this is a
  /// value rather than a switch.
  ///
  /// The `has-data-[icon=inline-*]` rules that would trim it to 8px (or 6px on
  /// [ToggleSize.sm]) need a child carrying `data-icon`, which nothing in
  /// the reference sets on a Toggle. They are inert everywhere they appear.
  static double get paddingX => space(2.5);

  /// `gap-1` — 4px between an icon and a label.
  ///
  /// Exposed rather than applied, exactly as [Button.gapFor] is: this
  /// component takes one [child], so a toggle that holds both an icon and a
  /// label composes its own row and asks here for the spacing.
  static double get gap => space(1);

  /// `rounded-lg`, or `rounded-[min(var(--radius-md),12px)]` on
  /// [ToggleSize.sm].
  ///
  /// The small rung's radius is an arbitrary-value clamp rather than a rung of
  /// the ladder, and both of its operands resolve from the ladder anyway:
  /// `--radius-md` is [Radii.md], and the ceiling the CSS writes as a raw
  /// length is numerically [Radii.lg] — the radius every other size carries.
  /// The `min` is kept live rather than folded to its current answer so that a
  /// rebrand raising `--radius-md` past the ceiling still clamps, which is the
  /// only reason the CSS wrote a `min()` in the first place.
  static double radiusFor(ToggleSize size) => switch (size) {
    ToggleSize.sm => math.min(Radii.md, Radii.lg),
    ToggleSize.md || ToggleSize.lg => Radii.lg,
  };

  /// What `[&_svg:not([class*='size-'])]:size-*` would force an icon child to.
  ///
  /// A CSS descendant selector restyles a glyph it did not create; [Icon]
  /// takes its px up front, so this component cannot reach into its own child
  /// to resize it. The rule is exposed instead: pass
  /// `Icon(..., size: Toggle.iconSizeFor(size))` and the child lands on
  /// the same 16px (14px on [ToggleSize.sm]) the selector would have forced.
  ///
  /// DOCUMENTED DRIFT (buttons-map drift 6): the page writes
  /// `<Icon icon={Heart} size="sm" />` on all three toggles — a **declared**
  /// 14px — and the selector overrides it to 16. The attribute is not what
  /// renders; the class is.
  static IconSize iconSizeFor(ToggleSize size) => switch (size) {
    ToggleSize.sm => IconSize.sm,
    ToggleSize.md || ToggleSize.lg => IconSize.md,
  };

  @override
  State<Toggle> createState() => _ToggleState();
}

class _ToggleState extends State<Toggle> {
  bool _hovered = false;
  bool _focused = false;

  bool get _enabled => widget.onChanged != null;

  void _setHovered(bool value) {
    if (_hovered == value) return;
    setState(() => _hovered = value);
  }

  void _setFocused(bool value) {
    if (_focused == value) return;
    setState(() => _focused = value);
  }

  void _toggle() => widget.onChanged?.call(!widget.pressed);

  /// `<button>` activates on Enter and on Space, and Flutter gives a bare
  /// pointer surface neither — the identical hand-wiring `Button` carries,
  /// for the identical reason: a focus ring on a control that cannot be
  /// operated from the keyboard is a lie.
  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (!_enabled || event is! KeyDownEvent) return KeyEventResult.ignored;
    final bool activates =
        event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.numpadEnter ||
        event.logicalKey == LogicalKeyboardKey.space;
    if (!activates) return KeyEventResult.ignored;
    _toggle();
    return KeyEventResult.handled;
  }

  /// The state table.
  ///
  /// **On beats hover.** `hover:bg-muted` and `data-[state=on]:bg-*` are both
  /// single-class specificity, so source order decides, and Tailwind emits the
  /// attribute variants after the pseudo-class ones. On the standalone control
  /// the question is invisible — both fills are `--muted` — but it is the
  /// whole behaviour of a selected group item, whose on-fill is transparent so
  /// the pill can show through. A hover that outranked it would paint a grey
  /// rectangle over the travelling pill.
  _ToggleSkin _skin(ThemeTokens theme) {
    final bool bordered = widget.variant == ToggleVariant.outline;
    return _ToggleSkin(
      fill: widget.pressed
          ? (widget.pressedFill ?? theme.muted)
          : _hovered
          ? theme.muted
          : transparent,
      // `focus-visible:border-ring`, live only where there is a border to
      // colour. `border-input` at rest.
      border: bordered ? (_focused ? theme.ring : theme.input) : transparent,
      // The base declares no resting `color`, so the element inherits
      // `--foreground` and `hover:text-foreground` changes nothing (drift 10).
      // The only ink that ever moves is the group item's on-state override.
      ink: widget.pressed
          ? (widget.pressedInk ?? theme.foreground)
          : theme.foreground,
      ring: theme.ring.withValues(alpha: _focusRingAlpha),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final _ToggleSkin skin = _skin(theme);
    final bool bordered = widget.variant == ToggleVariant.outline;
    final BorderRadius radius = BorderRadius.circular(
      Toggle.radiusFor(widget.size),
    );

    // `transition-all` at `--default-transition-duration` /
    // `--default-transition-timing-function`. There is no `:active` override
    // to shorten it, the way `btn-spring` has.
    final Duration transition = effectiveMotionDuration(
      context,
      MotionDurations.normal,
    );

    Widget toggle = _TransitionAllColors(
      duration: transition,
      fill: skin.fill,
      ink: skin.ink,
      border: skin.border,
      // `box-shadow` is one of the properties `transition-all` names, and CSS
      // interpolates from `none` by holding the geometry and fading the
      // colour. A fully transparent ring IS that starting keyframe.
      ring: _focused ? skin.ring : skin.ring.withValues(alpha: 0),
      builder:
          (
            BuildContext context,
            Color fill,
            Color ink,
            Color border,
            Color ring,
          ) {
            return Surface(
              spec: Button.withFocusRing(Shadows.none, ring),
              radius: radius,
              fill: fill,
              // Only `outline` has a border box. Painting a transparent one on
              // `standard` would inset its content by a pixel that the reference
              // never spends.
              border: bordered
                  ? Border.all(color: border, width: BorderWidths.hairline)
                  : null,
              child: Padding(
                // Just `px-*`: `Surface` has already inset this child by
                // the border's width, the way `box-sizing: border-box` does.
                padding: EdgeInsets.symmetric(horizontal: Toggle.paddingX),
                child: Center(
                  // `inline-flex` + `w-fit`: the box hugs its content, and the
                  // minimum width below is what stops it collapsing onto a glyph.
                  widthFactor: 1,
                  child: DefaultTextStyle(
                    style: StyledText.styleOf(
                      context,
                      TextStyles.nav,
                      color: ink,
                    ),
                    // `whitespace-nowrap`, applied the way CSS applies it: as an
                    // inherited property every text descendant picks up, not as a
                    // parameter each one has to be passed.
                    softWrap: false,
                    child: widget.child,
                  ),
                ),
              ),
            );
          },
    );

    toggle = SizedBox(height: Toggle.heightFor(widget.size), child: toggle);
    // `min-w-*`. Outside the height so the floor reaches the content: the
    // padding subtracts from it on the way down, exactly as it does in a
    // border-box layout, leaving the label a 12px minimum measure on a 32px
    // control.
    toggle = ConstrainedBox(
      constraints: BoxConstraints(minWidth: Toggle.minWidthFor(widget.size)),
      child: toggle,
    );

    // No `Press`, and no pointer-down tracking either: the class list has no
    // `:active` rule and no `press` utility, so nothing about this control
    // changes between pointer-down and pointer-up.
    toggle = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _enabled ? _toggle : null,
      child: MouseRegion(
        cursor: _enabled ? SystemMouseCursors.click : MouseCursor.defer,
        onEnter: (_) => _setHovered(true),
        onExit: (_) => _setHovered(false),
        child: toggle,
      ),
    );

    // `:focus-visible`, not `:focus`. Flutter does not move focus on a bare
    // pointer tap — only keyboard traversal or an explicit request focuses
    // this node — so `hasFocus` here IS the keyboard-only predicate CSS means.
    toggle = Focus(
      focusNode: widget.focusNode,
      canRequestFocus: _enabled,
      onFocusChange: _setFocused,
      onKeyEvent: _onKey,
      child: toggle,
    );

    // `disabled:pointer-events-none disabled:opacity-50`. The [IgnorePointer]
    // is what makes the first half true, and it takes the hover with it: a
    // disabled control is never in the hit-test path, so `onEnter` cannot run.
    toggle = Opacity(
      opacity: _enabled ? 1 : SurfaceOpacity.disabled,
      child: IgnorePointer(ignoring: !_enabled, child: toggle),
    );

    // A 32px control against a 44px finger. Expanded only when the toggle
    // stands alone: inside a `ToggleGroup` the items are packed edge to edge,
    // and a symmetric expansion would make each one answer for its
    // neighbour's border rather than for itself.
    if (!widget.inExclusiveGroup) toggle = TapTarget(child: toggle);

    return Semantics(
      button: true,
      enabled: _enabled,
      label: widget.label,
      // `aria-label` overrides an element's content-derived name rather than
      // adding to it; this is that rule. With no label, the child's own text
      // names the control, exactly as `<button>Newest</button>` does.
      excludeSemantics: widget.label != null,
      toggled: widget.inExclusiveGroup ? null : widget.pressed,
      selected: widget.inExclusiveGroup ? widget.pressed : null,
      inMutuallyExclusiveGroup: widget.inExclusiveGroup ? true : null,
      child: toggle,
    );
  }
}

/// `transition-all` — every property that changes, on one duration and one
/// curve.
///
/// Four colours move on this control: the fill, the ink, the border and the
/// ring. [TweenAnimationBuilder] animates one value, so four are nested — the
/// same trade `Button`'s `_SpringColors` makes, and for the same reason: one
/// controller driving four [ColorTween]s would have to re-aim every tween by
/// hand each time a target changed mid-flight, which is precisely what
/// [TweenAnimationBuilder] already does for free.
class _TransitionAllColors extends StatelessWidget {
  const _TransitionAllColors({
    required this.fill,
    required this.ink,
    required this.border,
    required this.ring,
    required this.duration,
    required this.builder,
  });

  final Color fill;
  final Color ink;
  final Color border;
  final Color ring;
  final Duration duration;
  final Widget Function(
    BuildContext context,
    Color fill,
    Color ink,
    Color border,
    Color ring,
  )
  builder;

  Widget _tween(Color end, Widget Function(BuildContext, Color) child) =>
      TweenAnimationBuilder<Color?>(
        tween: ColorTween(end: end),
        duration: duration,
        curve: MotionCurves.enter,
        builder: (BuildContext context, Color? value, Widget? _) =>
            child(context, value ?? end),
      );

  @override
  Widget build(BuildContext context) {
    return _tween(
      fill,
      (BuildContext context, Color f) => _tween(
        ink,
        (BuildContext context, Color i) => _tween(
          border,
          (BuildContext context, Color b) => _tween(
            ring,
            (BuildContext context, Color r) => builder(context, f, i, b, r),
          ),
        ),
      ),
    );
  }
}
