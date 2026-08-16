/// `components/ui/bubble.tsx` — the surface a message sits on.
///
/// Seven variants, two alignments and a reactions rail, all of it driven off
/// `data-slot` so `BubbleContent` can be swapped for a button or a link without
/// restating a class. The port keeps that split literally: [DsBubble] paints
/// nothing and owns the *box* (`w-fit max-w-[80%]`, the 4px column gap, the
/// self-alignment); [DsBubbleContent] is the painted surface and the only thing
/// that knows a variant's fill.
///
/// ## Measured, not transcribed
///
/// Every number below is a computed style read off
/// `/design-system/components/base/chat` at 1440×900 on 2026-08-16
/// (`scratchpad/ba2-chat-inv.js`, `ba2-chat-hover.js`).
///
/// | property | measured |
/// |---|---|
/// | `BubbleContent` padding | `8px 12px` (`px-3 py-2`) |
/// | radius | **16px** — `rounded-xl` is [DsRadii.xl] here, not Tailwind's 12 |
/// | type | 13px / **21.125px** — `text-sm leading-relaxed` ([DsComponentType.bubbleContent]) |
/// | border | 1px, transparent on six of seven variants |
/// | one-line height | **39.13px** on every variant but `ghost`, which is 23.13 |
/// | `Bubble` gap | 4px (`gap-1`) |
/// | `Bubble` width cap | 80% of the column; `ghost` is exempt at 100% |
///
/// ## The `asChild` surface is the only animated one
///
/// A `div` bubble computes `transition-property: all` at `0s` — nothing moves.
/// `[button,a]:transition-colors` reaches only the `asChild` form, and there
/// the measured transition is **250ms on [DsCurves.out]** (the corpus default
/// pair), sweeping `--primary` → `primary/80` on hover. Text-align flips to
/// `left` there too, through `[button]:text-left`.
///
/// ## The count's `duration-fast` is a no-op — measured
///
/// `bubble.tsx` L203 asks for `transition-[width,opacity] duration-fast`.
/// Tailwind v4 has no `--duration-*` namespace, so `duration-fast` resolves to
/// nothing and the pair runs at the stylesheet default. The live trace
/// (`ba2-chat-inter.js`) reads **0.25s / cubic-bezier(0.22, 1, 0.36, 1)** and
/// settles 250ms after the pointer lands, so the port runs
/// [DsDurations.transitionDefault] on [DsCurves.out]. `showCount: always`
/// carries no transition class at all and measures `all 0s` — it cuts.
library;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../foundation/colors.dart';
import '../foundation/motion.dart';
import '../foundation/shadows.dart';
import '../foundation/spacing.dart';
import '../foundation/theme.dart';
import '../foundation/typography.dart';
import '../motion/press.dart';
import '../theme_scope.dart';

/// `start` (default) or `end` — the only alignment control in the family.
enum DsBubbleAlign {
  /// `data-align="start"`.
  start,

  /// `data-align="end"` — `self-end`, and `BubbleContent` follows through
  /// `group-data-[align=end]/bubble:self-end`.
  end,
}

/// The seven `cva` variants, in the reference's declaration order.
enum DsBubbleVariant {
  /// `bg-primary text-primary-foreground`, hover `primary/80`. The sender's
  /// own turn. Named [normal] because `default` is a Dart keyword.
  normal,

  /// `bg-secondary text-secondary-foreground`, hover
  /// `color-mix(in oklch, --secondary, --foreground 5%)`.
  secondary,

  /// `bg-muted`, hover `color-mix(in oklch, --muted, --foreground 5%)`.
  muted,

  /// `bg-bubble-tinted text-foreground`, hover `bg-bubble-tinted-hover`.
  ///
  /// The wash is a token per §1's rule that a colour needing a `dark:` twin is
  /// a token that has not been written yet — light lands at lightness 0.93,
  /// dark at 0.30, both derived from `--primary`.
  tinted,

  /// `border-border bg-background`, hover `bg-muted text-foreground`, and in
  /// dark `bg-input/30`. The one variant whose border is not transparent.
  outline,

  /// No fill, no padding, no radius — and the only variant allowed the full
  /// column width. Hover `bg-muted text-foreground`, dark `muted/50`.
  ghost,

  /// `bg-destructive/10` (dark `/20`) under **`text-destructive-ink`**, not
  /// `text-destructive`: §1.3 says the fill end of a ramp does not carry text.
  /// Hover `destructive/20`, dark `/30`.
  destructive;

  /// The key the `cva` spells this variant with — what a state matrix prints.
  String get label => this == DsBubbleVariant.normal ? 'default' : name;
}

/// Which corner the reactions rail hangs off.
enum DsBubbleSide {
  /// `top-0 -translate-y-3/4`.
  top,

  /// `bottom-0 translate-y-3/4` — the default.
  bottom,
}

/// When a reaction's count is visible. The accessible name carries it either
/// way — §7 does not let information live in a hover state alone.
enum DsShowCount {
  /// `w-0 opacity-0` until hover or focus, then 16px over 250ms.
  hover,

  /// `w-4 opacity-100`, with no transition of its own.
  always,
}

/// `.mix(in oklch, a, b p%)` alphas and fill fractions the variants name.
class _BubbleAlpha {
  const _BubbleAlpha._();

  /// `bg-primary/80` on the `default` asChild hover.
  static const double primaryHover = 0.8;

  /// `--foreground 5%` in the `secondary` and `muted` hover mixes.
  static const double foregroundMix = 0.05;

  /// `dark:bg-input/30` on the `outline` asChild hover.
  static const double inputDarkHover = 0.30;

  /// `dark:bg-muted/50` on the `ghost` asChild hover.
  static const double mutedDarkHover = 0.50;

  /// `bg-destructive/10` light rest, `/20` dark rest.
  static const double destructiveFill = 0.10;
  static const double destructiveFillDark = 0.20;

  /// `hover:bg-destructive/20` light, `/30` dark.
  static const double destructiveHover = 0.20;
  static const double destructiveHoverDark = 0.30;

  /// `border-action/40 bg-action/10` — a reaction the reader already gave.
  static const double mineBorder = 0.40;
  static const double mineFill = 0.10;
}

/// A [Stack] that still answers a pointer over a child painted outside its own
/// box.
///
/// `BubbleReactions` is `absolute` and `translate-y-3/4`, so three quarters of
/// every rail hangs below the bubble it belongs to. In CSS that costs nothing:
/// nothing on the chain clips, and the rail is clickable wherever it lands.
/// Flutter bounds-checks **every** render object before it asks a child, so a
/// plain `Stack` — even at `Clip.none` — rejects the pointer before the rail is
/// ever consulted, and the pills would paint, hover-highlight in the browser
/// and do nothing here. Measured: the reveal never fired and the press never
/// landed until this existed.
class _ReactionStack extends MultiChildRenderObjectWidget {
  const _ReactionStack({required super.children});

  @override
  RenderStack createRenderObject(BuildContext context) => _RenderReactionStack(
        alignment: AlignmentDirectional.topStart,
        textDirection: Directionality.of(context),
        fit: StackFit.loose,
        clipBehavior: Clip.none,
      );

  @override
  void updateRenderObject(BuildContext context, RenderStack renderObject) {
    renderObject
      ..alignment = AlignmentDirectional.topStart
      ..textDirection = Directionality.of(context)
      ..fit = StackFit.loose
      ..clipBehavior = Clip.none;
  }
}

class _RenderReactionStack extends RenderStack {
  _RenderReactionStack({
    required super.alignment,
    super.textDirection,
    required super.fit,
    required super.clipBehavior,
  });

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    // No `size.contains` gate: the children answer for themselves, and one of
    // them is deliberately outside.
    if (hitTestChildren(result, position: position)) {
      result.add(BoxHitTestEntry(this, position));
      return true;
    }
    if (size.contains(position) && hitTestSelf(position)) {
      result.add(BoxHitTestEntry(this, position));
      return true;
    }
    return false;
  }
}

/// `focus-visible:ring-3 focus-visible:ring-ring/50` — the ring both the
/// `asChild` surface and a reaction pill paint, as a spec rather than a
/// written shadow.
List<BoxShadow> _focusRing(DsThemeData theme) =>
    DsShadowSpec(<DsShadowLayer>[
      DsShadowLayer(
        0,
        0,
        0,
        DsBubbleContent.focusRing,
        (DsThemeData t) =>
            t.ring.withValues(alpha: DsBubbleContent.focusRingAlpha),
      ),
    ]).outerShadows(theme);

/// `<div data-slot="bubble-group">` — `flex min-w-0 flex-col gap-2`.
class DsBubbleGroup extends StatelessWidget {
  const DsBubbleGroup({super.key, required this.children});

  final List<Widget> children;

  /// `gap-2`.
  static double get gap => ds(2);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (int i = 0; i < children.length; i++) ...<Widget>[
          if (i > 0) SizedBox(height: gap),
          children[i],
        ],
      ],
    );
  }
}

/// One speech bubble: the box, the variant, the alignment and the rail.
///
/// `w-fit max-w-[80%] min-w-0 flex-col gap-1` — so the port shrink-wraps its
/// content, caps itself at [maxWidthFraction] of the incoming width, and
/// aligns itself in the column. `ghost` is exempt from the cap
/// (`data-[variant=ghost]:max-w-full`).
class DsBubble extends StatelessWidget {
  const DsBubble({
    super.key,
    required this.child,
    this.variant = DsBubbleVariant.normal,
    this.align = DsBubbleAlign.start,
    this.reactions,
  });

  /// `max-w-[80%]`, and the reason a long answer wraps before it reaches the
  /// column edge. `ghost` overrides it to 1.
  static const double maxWidthFraction = 0.80;

  /// `gap-1` — the space between the content and anything stacked under it.
  static double get gap => ds(1);

  /// `BubbleContent`, or whatever the call site stacks in the column.
  final Widget child;

  final DsBubbleVariant variant;

  /// `data-align`. Inside a [DsMessage] the message's own align wins when this
  /// is left at its default — see [DsBubbleAlignScope].
  final DsBubbleAlign align;

  /// `BubbleReactions`, absolutely positioned against this bubble and pulled
  /// three quarters outside it, so it needs vertical room around it.
  final DsBubbleReactions? reactions;

  @override
  Widget build(BuildContext context) {
    final DsBubbleAlign resolved = DsBubbleAlignScope.resolve(context, align);
    final bool ghost = variant == DsBubbleVariant.ghost;

    Widget bubble = _BubbleScope(
      variant: variant,
      align: resolved,
      child: Align(
        alignment: resolved == DsBubbleAlign.end
            ? AlignmentDirectional.centerEnd
            : AlignmentDirectional.centerStart,
        // `w-fit max-w-[80%]`: shrink-wrap, capped at a fraction of whatever
        // column it is in. A [LayoutBuilder] would express that too and cannot
        // be used — it refuses to answer an intrinsic query, and the kit's own
        // `DsGrid` asks one of every cell through [IntrinsicHeight].
        child: _MaxWidthFraction(
          factor: ghost ? 1 : maxWidthFraction,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: resolved == DsBubbleAlign.end
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: <Widget>[child],
          ),
        ),
      ),
    );

    if (reactions != null) {
      // `position: absolute` against the bubble, which is `relative`. The rail
      // overflows the bubble's box by three quarters of its own height, so the
      // stack must neither clip nor bounds-check a pointer — see
      // [_ReactionStack].
      bubble = _ReactionStack(children: <Widget>[bubble, reactions!]);
    }

    return bubble;
  }
}

/// `max-w-[<f>%]` — caps the child at a fraction of the incoming width and
/// shrink-wraps it.
///
/// A [RenderProxyBox] rather than a [LayoutBuilder] so intrinsics still pass
/// through: `DsGrid` measures its cells with [IntrinsicHeight], and a
/// LayoutBuilder throws on that.
class _MaxWidthFraction extends SingleChildRenderObjectWidget {
  const _MaxWidthFraction({required this.factor, required super.child});

  final double factor;

  @override
  _RenderMaxWidthFraction createRenderObject(BuildContext context) =>
      _RenderMaxWidthFraction(factor);

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderMaxWidthFraction renderObject,
  ) =>
      renderObject.factor = factor;
}

class _RenderMaxWidthFraction extends RenderProxyBox {
  _RenderMaxWidthFraction(this._factor);

  double _factor;
  set factor(double value) {
    if (_factor == value) return;
    _factor = value;
    markNeedsLayout();
  }

  @override
  void performLayout() {
    final RenderBox? kid = child;
    if (kid == null) {
      size = constraints.smallest;
      return;
    }
    final double cap = constraints.maxWidth.isFinite
        ? constraints.maxWidth * _factor
        : double.infinity;
    kid.layout(
      constraints.copyWith(minWidth: 0, maxWidth: cap),
      parentUsesSize: true,
    );
    size = constraints.constrain(kid.size);
  }
}

/// The variant and alignment a [DsBubbleContent] reads off its bubble — the
/// port of `group/bubble` plus `data-variant`.
class _BubbleScope extends InheritedWidget {
  const _BubbleScope({
    required this.variant,
    required this.align,
    required super.child,
  });

  final DsBubbleVariant variant;
  final DsBubbleAlign align;

  static _BubbleScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_BubbleScope>();

  @override
  bool updateShouldNotify(_BubbleScope old) =>
      old.variant != variant || old.align != align;
}

/// `group-data-[align=end]/message:*` — a [DsMessage]'s align, published so a
/// [DsBubble] left at its default mirrors the row.
///
/// The reference does this with one `group-data` selector; the port needs a
/// scope because a Flutter parent cannot restyle a descendant. `message.dart`
/// mounts it, `bubble.dart` reads it, and the pair is the whole mechanism.
class DsBubbleAlignScope extends InheritedWidget {
  const DsBubbleAlignScope({
    super.key,
    required this.align,
    required super.child,
  });

  final DsBubbleAlign align;

  /// [own] unless it is the `start` default, in which case the enclosing
  /// message wins — which is what makes setting `align` on both *redundant
  /// rather than wrong*, exactly as the reference's Meta says.
  static DsBubbleAlign resolve(BuildContext context, DsBubbleAlign own) {
    if (own == DsBubbleAlign.end) return own;
    final DsBubbleAlignScope? scope =
        context.dependOnInheritedWidgetOfExactType<DsBubbleAlignScope>();
    return scope?.align ?? own;
  }

  @override
  bool updateShouldNotify(DsBubbleAlignScope old) => old.align != align;
}

/// The painted surface — `px-3 py-2 rounded-xl text-sm border border-transparent`.
///
/// [onPressed] is the port of `asChild`: pass one and the surface becomes the
/// control, with the hover fill and the focus ring the reference already writes
/// for `:is(button,a)`. Leave it null and the surface is inert, which is what a
/// `div` measures — `transition-property: all` at `0s`.
class DsBubbleContent extends StatefulWidget {
  const DsBubbleContent({
    super.key,
    required this.child,
    this.onPressed,
    this.semanticsLabel,
  });

  /// `px-3` — 12px.
  static double get paddingX => ds(3);

  /// `py-2` — 8px.
  static double get paddingY => ds(2);

  /// `ring-3` — the focus ring's spread, in px.
  static double get focusRing => 3;

  /// `focus-visible:ring-ring/50`.
  static const double focusRingAlpha = 0.50;

  final Widget child;

  /// `asChild` with a `<button>` inside: the whole bubble is the control.
  final VoidCallback? onPressed;

  /// The accessible name when the surface is a control and its child is not a
  /// plain string.
  final String? semanticsLabel;

  @override
  State<DsBubbleContent> createState() => _DsBubbleContentState();
}

class _DsBubbleContentState extends State<DsBubbleContent> {
  bool _hovered = false;
  bool _focused = false;

  /// The fill this variant paints, at rest or under a pointer.
  ///
  /// The hover column only ever applies to the `asChild` form: the reference
  /// scopes every one of them behind `:is(button,a):hover`.
  Color _fill(DsThemeData theme, DsBubbleVariant variant, bool hovered) {
    final bool dark = theme.kind == DsThemeKind.dark;
    return switch (variant) {
      DsBubbleVariant.normal => hovered
          ? theme.primary.withValues(alpha: _BubbleAlpha.primaryHover)
          : theme.primary,
      DsBubbleVariant.secondary => hovered
          ? DsOklab.mix(
              theme.secondary,
              theme.foreground,
              1 - _BubbleAlpha.foregroundMix,
            )
          : theme.secondary,
      DsBubbleVariant.muted => hovered
          ? DsOklab.mix(
              theme.muted,
              theme.foreground,
              1 - _BubbleAlpha.foregroundMix,
            )
          : theme.muted,
      DsBubbleVariant.tinted =>
        hovered ? theme.bubbleTintedHover : theme.bubbleTinted,
      DsBubbleVariant.outline => hovered
          ? (dark
              ? theme.input.withValues(alpha: _BubbleAlpha.inputDarkHover)
              : theme.muted)
          : theme.background,
      DsBubbleVariant.ghost => hovered
          ? (dark
              ? theme.muted.withValues(alpha: _BubbleAlpha.mutedDarkHover)
              : theme.muted)
          : dsTransparent,
      DsBubbleVariant.destructive => theme.destructive.withValues(
          alpha: hovered
              ? (dark
                  ? _BubbleAlpha.destructiveHoverDark
                  : _BubbleAlpha.destructiveHover)
              : (dark
                  ? _BubbleAlpha.destructiveFillDark
                  : _BubbleAlpha.destructiveFill),
        ),
    };
  }

  /// The ink. Only `outline` and `ghost` recolour on hover.
  Color _ink(DsThemeData theme, DsBubbleVariant variant, bool hovered) =>
      switch (variant) {
        DsBubbleVariant.normal => theme.primaryForeground,
        DsBubbleVariant.secondary => theme.secondaryForeground,
        DsBubbleVariant.muted || DsBubbleVariant.tinted => theme.foreground,
        DsBubbleVariant.outline || DsBubbleVariant.ghost => theme.foreground,
        DsBubbleVariant.destructive => theme.destructiveInk,
      };

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final _BubbleScope? scope = _BubbleScope.maybeOf(context);
    final DsBubbleVariant variant = scope?.variant ?? DsBubbleVariant.normal;
    final DsBubbleAlign align = scope?.align ?? DsBubbleAlign.start;
    final bool ghost = variant == DsBubbleVariant.ghost;
    final bool interactive = widget.onPressed != null;
    final bool hovered = interactive && _hovered;

    // A `div` bubble computes `transition-property: all` at **0s** — it cuts.
    // `[button,a]:transition-colors` reaches only the `asChild` form, measured
    // at 250ms on `--ease-out`.
    final Duration colours = interactive
        ? dsAnimationDuration(context, DsDurations.transitionDefault)
        : Duration.zero;

    Widget surface = Padding(
      // `p-0` on ghost, `px-3 py-2` everywhere else.
      padding: ghost
          ? EdgeInsets.zero
          : EdgeInsets.symmetric(
              horizontal: DsBubbleContent.paddingX,
              vertical: DsBubbleContent.paddingY,
            ),
      child: AnimatedDefaultTextStyle(
        duration: colours,
        curve: DsCurves.out,
        style: DsText.styleOf(
          context,
          DsComponentType.bubbleContent,
          color: _ink(theme, variant, hovered),
        ),
        // `[button]:text-left` — a control's copy is left-aligned even inside
        // an end-aligned row; a `div` bubble inherits `start`, which is the
        // same thing in LTR.
        textAlign: TextAlign.start,
        child: widget.child,
      ),
    );

    final BorderRadius radius = BorderRadius.circular(
      // `rounded-xl`, dropped to `rounded-none` on ghost.
      ghost ? 0 : DsRadii.xl,
    );

    // `border border-transparent` on every variant — a real 1px border that
    // costs a pixel of inner width, which is why a one-line bubble measures
    // 39.13 and not 37.13.
    surface = AnimatedContainer(
      duration: colours,
      curve: DsCurves.out,
      decoration: BoxDecoration(
        color: _fill(theme, variant, hovered),
        borderRadius: radius,
        border: Border.all(
          color: _focused
              ? theme.ring
              : variant == DsBubbleVariant.outline
                  ? theme.border
                  : dsTransparent,
          width: DsWidths.hairline,
        ),
        boxShadow: _focused ? _focusRing(theme) : null,
      ),
      // `overflow-hidden` — the surface clips its own content to the radius.
      clipBehavior: ghost ? Clip.none : Clip.antiAlias,
      child: surface,
    );

    // `w-fit max-w-full` inside the bubble's column, and
    // `group-data-[align=end]/bubble:self-end`.
    surface = Align(
      alignment: align == DsBubbleAlign.end
          ? AlignmentDirectional.centerEnd
          : AlignmentDirectional.centerStart,
      widthFactor: 1,
      heightFactor: 1,
      child: surface,
    );

    if (!interactive) return surface;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Focus(
        onFocusChange: (bool has) => setState(() => _focused = has),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onPressed,
          child: Semantics(
            button: true,
            label: widget.semanticsLabel,
            child: surface,
          ),
        ),
      ),
    );
  }
}

/// One row of the `reactions` data form.
class DsBubbleReaction {
  const DsBubbleReaction({
    required this.emoji,
    required this.count,
    required this.label,
    this.mine = false,
  });

  /// The emoji. A reaction is the one place §5 rule 4's *"no emoji as UI"* does
  /// not apply — see the carve-out there.
  final String emoji;

  final int count;

  /// What the emoji means, for the accessible name — *"a heart"*.
  final String label;

  /// Has the reader already reacted this way? Carries a border **and** a fill
  /// **and** `aria-pressed`, because trap 11 and §7 both rule out a hue as the
  /// only carrier of a state.
  final bool mine;
}

/// The reactions rail — `absolute z-10 rounded-full bg-muted ring-3 ring-card`.
///
/// Two forms, exclusive: pass [reactions] and it draws pills with counts, pass
/// [children] and it stays the bare rail. Measured geometry:
///
/// | form | padding | height |
/// |---|---|---|
/// | bare (`children`) | `2px 6px` (`px-1.5 py-0.5`) | 22.5625 |
/// | data (`has-[button]:p-0`) | 0 | 28 (`h-7` pills) |
///
/// The ring is `--card` at 3px spread: put the rail on a card surface, or it
/// reads as a halo — which is why the reference's two specimen panels carry
/// `bodyClassName="bg-card"`.
class DsBubbleReactions extends StatelessWidget {
  const DsBubbleReactions({
    super.key,
    this.side = DsBubbleSide.bottom,
    this.align = DsBubbleAlign.end,
    this.reactions,
    this.showCount = DsShowCount.hover,
    this.onReact,
    this.children,
  });

  /// `translate-y-3/4` — the fraction of its own height the rail hangs outside
  /// the bubble.
  static const double overhang = 0.75;

  /// `left-3` / `right-3`.
  static double get inset => ds(3);

  /// `px-1.5 py-0.5` — the bare rail's padding.
  static double get barePaddingX => ds(1.5);
  static double get barePaddingY => ds(0.5);

  /// `gap-1`.
  static double get gap => ds(1);

  /// `ring-3` — the punch-out that hides the bubble edge behind the rail.
  static double get ring => 3;

  final DsBubbleSide side;
  final DsBubbleAlign align;

  /// Draw these rather than [children].
  final List<DsBubbleReaction>? reactions;

  final DsShowCount showCount;

  /// Fired with the reaction's [DsBubbleReaction.label] when one is pressed.
  final void Function(String label)? onReact;

  /// The bare rail's contents.
  final List<Widget>? children;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final bool data = reactions != null;

    final List<Widget> items = data
        ? <Widget>[
            for (final DsBubbleReaction r in reactions!)
              _ReactionPill(
                reaction: r,
                showCount: showCount,
                onReact: onReact,
              ),
          ]
        : (children ?? const <Widget>[]);

    Widget rail = Container(
      padding: data
          ? EdgeInsets.zero
          : EdgeInsets.symmetric(
              horizontal: barePaddingX,
              vertical: barePaddingY,
            ),
      decoration: BoxDecoration(
        color: theme.muted,
        borderRadius: BorderRadius.circular(DsRadii.pill),
        // `ring-3 ring-card` — a spread-only layer, the same shape
        // `box-shadow: 0 0 0 3px var(--card)` computes to.
        boxShadow: DsShadowSpec(<DsShadowLayer>[
          DsShadowLayer(0, 0, 0, ring, (DsThemeData t) => t.card),
        ]).outerShadows(theme),
      ),
      child: DefaultTextStyle.merge(
        style: DsText.styleOf(
          context,
          DsComponentType.bubbleReactions,
          color: theme.foreground,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            for (int i = 0; i < items.length; i++) ...<Widget>[
              if (i > 0) SizedBox(width: gap),
              items[i],
            ],
          ],
        ),
      ),
    );

    // `translate-y-±3/4` on a box whose height is not known until it is laid
    // out — a FractionalTranslation is exactly that percentage of the child.
    rail = FractionalTranslation(
      translation: Offset(0, side == DsBubbleSide.top ? -overhang : overhang),
      child: rail,
    );

    // `top-0` / `bottom-0` × `left-3` / `right-3`, against the bubble.
    //
    // Returned as a bare [PositionedDirectional] rather than wrapped in a
    // `Stack` of its own: the parent data resolves against [DsBubble]'s own
    // stack, which is the one element that does not bounds-check a pointer.
    return PositionedDirectional(
      top: side == DsBubbleSide.top ? 0 : null,
      bottom: side == DsBubbleSide.bottom ? 0 : null,
      start: align == DsBubbleAlign.start ? inset : null,
      end: align == DsBubbleAlign.end ? inset : null,
      child: rail,
    );
  }
}

/// One reaction pill — `press h-7 rounded-pill border px-2 text-sm`.
class _ReactionPill extends StatefulWidget {
  const _ReactionPill({
    required this.reaction,
    required this.showCount,
    required this.onReact,
  });

  final DsBubbleReaction reaction;
  final DsShowCount showCount;
  final void Function(String label)? onReact;

  @override
  State<_ReactionPill> createState() => _ReactionPillState();
}

class _ReactionPillState extends State<_ReactionPill> {
  bool _hovered = false;
  bool _focused = false;

  /// `h-7` — 28px.
  static double get height => ds(7);

  /// `px-2` — 8px.
  static double get paddingX => ds(2);

  /// `gap-1` — 4px between the emoji and the count.
  static double get gap => ds(1);

  /// `w-4` — the count's revealed width, measured at exactly 16px.
  static double get countWidth => ds(4);

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final DsBubbleReaction r = widget.reaction;
    final bool open = widget.showCount == DsShowCount.always ||
        _hovered ||
        _focused;

    final Widget count = ClipRect(
      child: SizedBox(
        width: countWidth,
        child: DsText(
          '${r.count}',
          DsType.numSm,
          color: r.mine ? theme.actionInk : theme.foreground,
          align: TextAlign.right,
          maxLines: 1,
          softWrap: false,
        ),
      ),
    );

    Widget revealed;
    if (widget.showCount == DsShowCount.always) {
      // Measured `transition-property: all` at `0s` — the always branch names
      // no transition class, so it cuts.
      revealed = count;
    } else {
      final Duration d = dsAnimationDuration(
        context,
        DsDurations.transitionDefault,
      );
      revealed = TweenAnimationBuilder<double>(
        // No `begin`: the builder keeps the value it last painted, which is
        // what an interrupted CSS transition does.
        tween: Tween<double>(end: open ? 1 : 0),
        duration: d,
        curve: DsCurves.out,
        builder: (BuildContext context, double t, Widget? child) => ClipRect(
          child: Align(
            alignment: AlignmentDirectional.centerEnd,
            widthFactor: t,
            child: Opacity(opacity: t, child: child),
          ),
        ),
        child: count,
      );
    }

    Widget pill = Container(
      height: height,
      padding: EdgeInsets.symmetric(horizontal: paddingX),
      decoration: BoxDecoration(
        color: r.mine
            ? DsPalette.action.withValues(alpha: _BubbleAlpha.mineFill)
            : (_hovered ? theme.accent : theme.muted),
        borderRadius: BorderRadius.circular(DsRadii.pill),
        border: Border.all(
          color: _focused
              ? theme.ring
              : r.mine
                  ? DsPalette.action
                      .withValues(alpha: _BubbleAlpha.mineBorder)
                  : theme.border,
          width: DsWidths.hairline,
        ),
        boxShadow: _focused ? _focusRing(theme) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // `<span aria-hidden>{emoji}</span>`.
          ExcludeSemantics(
            child: DsText(
              r.emoji,
              DsComponentType.bubbleReactions,
              color: r.mine ? theme.actionInk : theme.foreground,
            ),
          ),
          SizedBox(width: gap),
          ExcludeSemantics(child: revealed),
        ],
      ),
    );

    // `press` — 40ms down to 0.94, 250ms spring back, measured on this exact
    // pill (`ba2-chat-inter.js`: min 0.9374, peak 1.0058, settled at 494ms).
    pill = DsPress(
      onTap: () => widget.onReact?.call(r.label),
      behavior: HitTestBehavior.opaque,
      child: pill,
    );

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Focus(
        onFocusChange: (bool has) => setState(() => _focused = has),
        child: Semantics(
          button: true,
          toggled: r.mine,
          // The `sr-only` span: "8 reacted with a heart", present at rest in
          // both `showCount` modes.
          label: '${r.count} reacted with ${r.label}',
          child: pill,
        ),
      ),
    );
  }
}
