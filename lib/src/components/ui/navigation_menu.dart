/// `components/ui/navigation-menu.tsx` — a top bar whose items can open a
/// panel.
///
/// The page's own framing: *"Reach for it when a section needs more than a link
/// — a set of destinations with descriptions. The plain top-nav pattern above
/// is still right when every item is a single destination."*
///
/// The source lists the four things it changed off stock shadcn, and all four
/// are reproduced here: a **40px pill** trigger on 16px clearance rather than
/// stock's 36 / 10 / 6, `data-popup-open:` dropped (Base UI's attribute on a
/// Radix component, matching nothing), a **32px** content travel rather than
/// stock's 208, and the chevron routed through `Icon`.
///
/// ## Resolved, measured on the live reference at 1440 × 900 (2026-08-16)
///
/// | slot | measured |
/// |---|---|
/// | list | `gap-1`, 40 tall |
/// | trigger | 40 × content, `px-4`, `gap-1.5`, `rounded-pill`, a 1px transparent border, **13.5px / 20.25 / 500** |
/// | trigger, open | fill `--secondary`, ink `--foreground` — and **neither transitions** |
/// | chevron | 14px, `rotate: 180deg` open, on `transform, translate, scale, rotate` at 0.25s `--ease-spring` |
/// | viewport | `mt-2`, `rounded-lg`, `bg-popover`, `shadow-md` + `ring-1 ring-foreground/10`, `overflow-hidden`; 576 × 178 for Packs, 336 × 166 for Marketplace |
/// | content | `p-2` inside it |
/// | panel link | `px-3 py-2`, `gap-2`, `rounded-md`, 13px / 400 `--muted-foreground`; hover and active both `--accent` / `--accent-foreground`, **snapping** |
/// | indicator | 8 tall, width = the active trigger's `offsetWidth`, an 8px square rotated 45° and pushed half its height down, clipped |
///
/// ## The trigger's `text-nav` is not `.type-nav`
///
/// `navigationMenuTriggerStyle()` writes the **utility**, and `--text-nav`
/// declares a size with no paired line-height, so Tailwind supplies its own
/// 1.5 — 20.25px. `.type-nav`, the component class the top-nav buttons two
/// sections up wear, declares a `line-height` of 1.2 — 16.2px. Two spellings of one
/// token, four pixels of leading apart, on the same page. See
/// [TextStyles.navMenuTrigger].
///
/// ## Three drifts, all measured, all reproduced
///
///  1. **The indicator never travels.** Radix positions it from the active
///     trigger's `offsetLeft`, and `NavigationMenuItem` carries `relative` — so
///     every trigger's `offsetParent` is its own `li` and every `offsetLeft` is
///     **0**. Probed on §6's third panel: opening *Packs* (the first item)
///     writes `left: 0px; width: 93px; transform: translateX(0px)`, and opening
///     *Marketplace* (which starts 96.89px further along) writes
///     `left: 0px; width: 134px; transform: translateX(0px)`. Only the width
///     follows. The caret therefore sits centred over the **list's** left edge
///     and points at the wrong trigger for every item but the first — under a
///     panel label that reads *"the caret that names the open trigger"*. It is
///     the same `offsetLeft`-inside-a-positioned-ancestor trap
///     `sliding-indicator.tsx` documents having escaped, one component over.
///  2. **`origin-top-center` is not a Tailwind utility**, so the viewport's
///     `zoom-in-95` grows from its own **centre**. Measured: `transform-origin`
///     computes `288px 89px` on a 576 × 178 panel — see
///     [PopoverAnchorMode.selfCenter].
///  3. **Nothing about the trigger's paint is transitioned.** `press` declares
///     the whole `transition` shorthand as `transform`, and no colour utility
///     follows it, so `hover:bg-secondary`, `hover:text-foreground` and both
///     `data-[state=open]:` rules arrive in one frame. Probed:
///     `transition-property` reads exactly `transform`. (The *panel links* are
///     the same story — `press` and nothing else.) The one thing that does
///     interpolate is the chevron, because `transition-transform` compiles to
///     `transform, translate, scale, rotate` and `rotate` is the property
///     Tailwind's `rotate-180` writes.
///
/// ## Construction note: the panel is a portal
///
/// The reference hangs its panel off `absolute top-full` inside the
/// specimen's own `Panel`, which reserves `pb-40` / `pb-32` for it — so nothing
/// is ever clipped, and the rendered result is the same either way. This port
/// mounts it through [Popover] instead, which is the port's one mechanism for
/// an anchored panel and the only one whose hit testing survives leaving the
/// parent's box. Recorded rather than hidden: an over-long panel would be
/// clipped by the reference's `overflow-hidden` Panel and would not be clipped
/// here.
library;

import 'dart:math' as math;

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
import '../../design_system/foundation/motion.dart';
import '../../design_system/foundation/spacing.dart';
import '../../design_system/foundation/theme.dart';
import '../../design_system/foundation/typography.dart';
import './press.dart';
import '../../design_system/foundation/theme_scope.dart';
import './icon.dart';
import './icon_paths.dart';
import './popover.dart';

/// Radix's `delayDuration` — how long a pointer must rest on a trigger before
/// its panel opens.
///
/// The library's own default, not a `--duration-*` token, and on
/// [Toaster.unmountDelay]'s argument: putting a third-party runtime constant
/// on this system's motion scale would let a rebrand retime a foreign
/// component. Measured on the live reference: a first hover opened the panel
/// 281ms after the pointer landed, against a ~230–280ms expectation once
/// puppeteer's own move latency is allowed for.
const Duration _openDelay = Duration(
  milliseconds: 200,
); // allow-hardcoded: Radix's delayDuration, a library default, not a --duration-* token

/// Radix's own close timer — how long a panel stays open after the pointer
/// leaves the menu.
///
/// Measured at ~186ms from a real `pointerleave`, which is this plus the
/// sampler's slop.
const Duration _closeDelay = Duration(
  milliseconds: 150,
); // allow-hardcoded: Radix's close timer, a library default, not a --duration-* token

/// Radix's `skipDelayDuration` — the window after a panel closes during which
/// the **next** trigger opens with no delay at all.
///
/// Measured: travelling from *Packs* to *Marketplace* flipped `data-state` 78ms
/// after the pointer moved, i.e. on the next frame plus latency, while a
/// re-entry more than a second later took the full [_openDelay] again.
const Duration _skipDelay = Duration(
  milliseconds: 300,
); // allow-hardcoded: Radix's skipDelayDuration, a library default

/// One item in the bar: a trigger with a panel, or a plain link.
@immutable
class NavigationMenuItem {
  /// `NavigationMenuTrigger` + `NavigationMenuContent`.
  const NavigationMenuItem.trigger({required this.label, required this.content})
    : onTap = null,
      _isTrigger = true;

  /// `NavigationMenuLink asChild className={navigationMenuTriggerStyle()}` —
  /// an item that is a plain destination and still sits level with the pills
  /// beside it.
  const NavigationMenuItem.link({required this.label, this.onTap})
    : content = null,
      _isTrigger = false;

  final String label;

  /// The panel's body — the `ul` the page hands `NavigationMenuContent`. The
  /// `p-2` around it belongs to the component.
  final Widget? content;

  final VoidCallback? onTap;

  final bool _isTrigger;
}

/// The bar.
class NavigationMenu extends StatefulWidget {
  const NavigationMenu({
    super.key,
    required this.items,
    this.viewport = true,
    this.indicator = false,
  });

  final List<NavigationMenuItem> items;

  /// `viewport` — *"Default true: one shared panel that resizes between
  /// triggers. false gives each item its own panel, which is right when the
  /// panels are very different sizes."*
  ///
  /// The visible difference is where the panel is anchored: the shared viewport
  /// hangs off the **root's** left edge (`absolute top-full left-0` on the
  /// wrapper), while a per-item panel hangs off **its own item**, because
  /// `NavigationMenuItem` is the `relative` ancestor.
  final bool viewport;

  /// Whether a `NavigationMenuIndicator` is mounted.
  ///
  /// *"The caret pointing at the open trigger. Optional, and it is not an
  /// active-page marker — that is still `aria-current` plus a blue rule."*
  /// See drift 1 on the library: it does not point at the open trigger.
  final bool indicator;

  /// `gap-1` on the list.
  static double get listGap => space(1);

  /// `h-10` on the trigger.
  static double get triggerHeight => space(10);

  /// `px-4` on the trigger.
  static double get triggerPaddingX => space(4);

  /// `gap-1.5` between a trigger's label and its chevron.
  static double get triggerGap => space(1.5);

  /// `size="sm"` on the chevron.
  static double get chevronPx => Icon.pxFor(IconSize.sm);

  /// `mt-2` — the gap between the bar and the panel.
  static double get panelOffset => space(2);

  /// `p-2` inside the panel.
  static double get panelPadding => space(2);

  /// `h-2` — the indicator's clipping band, and exactly [panelOffset], which is
  /// why an indicator and a panel never fight for the same eight pixels.
  static double get indicatorHeight => space(2);

  /// `size-2` — the square that becomes the caret once it is rotated.
  static double get caretSize => space(2);

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  /// Which item's panel is open, or null.
  int? _open;

  /// The trigger the pointer is resting on while [_openDelay] runs.
  int? _pending;

  /// Set for [_skipDelay] after a panel closes: the next trigger opens at once.
  bool _skipping = false;

  /// Every item's measured box, in the list's own coordinates — what the
  /// indicator reads its width from, and nothing else.
  final List<GlobalKey> _itemKeys = <GlobalKey>[];
  final GlobalKey _listKey = GlobalKey();
  List<double> _widths = const <double>[];

  @override
  void initState() {
    super.initState();
    _syncKeys();
  }

  @override
  void didUpdateWidget(NavigationMenu old) {
    super.didUpdateWidget(old);
    _syncKeys();
  }

  void _syncKeys() {
    if (_itemKeys.length == widget.items.length) return;
    _itemKeys
      ..clear()
      ..addAll(
        List<GlobalKey>.generate(widget.items.length, (int _) => GlobalKey()),
      );
    _widths = const <double>[];
  }

  void _measure() {
    if (!mounted) return;
    final List<double> measured = <double>[];
    for (final GlobalKey key in _itemKeys) {
      final RenderObject? box = key.currentContext?.findRenderObject();
      if (box is! RenderBox || !box.hasSize) return;
      // Radix reads `offsetWidth`, an **integer**: the probe reports 93 for a
      // 92.89px trigger and 134 for a 134.33px one.
      measured.add(box.size.width.roundToDouble());
    }
    if (measured.length == _widths.length) {
      bool same = true;
      for (int i = 0; i < measured.length; i++) {
        if (measured[i] != _widths[i]) same = false;
      }
      if (same) return;
    }
    setState(() => _widths = measured);
  }

  void _hoverTrigger(int index, bool entered) {
    if (!entered) {
      if (_pending == index) _pending = null;
      _scheduleClose();
      return;
    }
    _pending = index;
    if (_open != null || _skipping) {
      // Inside the skip window, or already open on a sibling: Radix swaps the
      // panel on the next frame rather than waiting again.
      _openNow(index);
      return;
    }
    Future<void>.delayed(_openDelay, () {
      if (!mounted || _pending != index) return;
      _openNow(index);
    });
  }

  void _openNow(int index) {
    if (!mounted || _open == index) return;
    setState(() {
      _open = index;
      _skipping = false;
    });
  }

  void _scheduleClose() {
    Future<void>.delayed(_closeDelay, () {
      if (!mounted || _pending != null) return;
      if (_open == null) return;
      setState(() {
        _open = null;
        _skipping = true;
      });
      Future<void>.delayed(_skipDelay, () {
        if (!mounted) return;
        setState(() => _skipping = false);
      });
    });
  }

  /// `onClick`: *"if open → `onItemDismiss`, else → `onItemSelect`"*.
  ///
  /// On a pointer device the close half is invisible, because the pointer is
  /// still over the trigger and re-opens it inside the skip window — probed,
  /// and the panel measured `open` after both a first and a second click. It is
  /// the path a touch or a test takes, so it is the handler that is ported.
  void _tapTrigger(int index) {
    if (_open == index) {
      setState(() {
        _open = null;
        _skipping = true;
      });
      return;
    }
    _openNow(index);
  }

  /// The panel body — `NavigationMenuContent`'s `p-2` around the caller's `ul`.
  Widget _panelBody(BuildContext context, Widget content) {
    final ThemeTokens theme = ThemeScope.of(context);
    return PopoverSurface(
      child: Padding(
        padding: EdgeInsets.all(NavigationMenu.panelPadding),
        child: DefaultTextStyle.merge(
          style: TextStyle(color: theme.popoverForeground),
          child: content,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _measure());

    final Widget list = Row(
      key: _listKey,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (int i = 0; i < widget.items.length; i++) ...<Widget>[
          if (i > 0) SizedBox(width: NavigationMenu.listGap),
          KeyedSubtree(key: _itemKeys[i], child: _item(context, i)),
        ],
      ],
    );

    if (!widget.viewport) {
      // Each item owns its panel and anchors it to itself; the row is the
      // whole widget.
      return list;
    }

    // One shared panel, anchored to the root's leading edge — `absolute
    // top-full left-0` on the viewport's wrapper.
    final int? open = _open;
    return Popover(
      open: open != null && widget.items[open].content != null,
      align: PopoverAlign.start,
      // The indicator lives in the 8px the panel would otherwise be offset by,
      // so the two never both spend it.
      sideOffset: widget.indicator ? 0 : NavigationMenu.panelOffset,
      // The viewport zooms from its own centre — drift 2 on the library.
      origin: PopoverAnchorMode.selfCenter,
      // `zoom-in-95 fade-in-0` and nothing else: no `slide-in-from-*` on this
      // overlay, unlike every menu in the corpus.
      slideSides: const <PopoverSide>{},
      // Hover closes this menu, and a modal layer would swallow the hover that
      // moves the pointer to a sibling trigger — the same argument
      // [PopoverBarrier.none] carries for a submenu, and this menu has no
      // outside-click path of its own at all.
      barrier: PopoverBarrier.none,
      anchor: list,
      content: (BuildContext context, PopoverAnchorMetrics metrics) {
        final Widget? content = open == null
            ? null
            : widget.items[open].content;
        if (content == null) return const SizedBox.shrink();
        return MouseRegion(
          // Radix keeps the panel open while the pointer is inside it.
          onEnter: (_) => _pending = -1,
          onExit: (_) {
            _pending = null;
            _scheduleClose();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (widget.indicator) _indicator(context),
              _panelBody(context, content),
            ],
          ),
        );
      },
    );
  }

  /// `NavigationMenuIndicator`, sized to the open trigger. Drift 1 applies to
  /// where it sits, not to how wide it is.
  Widget _indicator(BuildContext context) {
    final int? open = _open;
    return NavigationMenuIndicator(
      width: (open != null && open < _widths.length) ? _widths[open] : 0,
    );
  }

  Widget _item(BuildContext context, int index) {
    final NavigationMenuItem item = widget.items[index];
    if (!item._isTrigger) {
      return _NavigationMenuTrigger(
        label: item.label,
        open: false,
        chevron: false,
        onTap: item.onTap,
      );
    }

    final Widget trigger = _NavigationMenuTrigger(
      label: item.label,
      open: _open == index,
      chevron: true,
      onTap: () => _tapTrigger(index),
      onHover: (bool entered) => _hoverTrigger(index, entered),
    );

    if (widget.viewport) return trigger;

    // `viewport={false}`: the content is its own panel, anchored to this item.
    return Popover(
      open: _open == index,
      align: PopoverAlign.start,
      sideOffset: NavigationMenu.panelOffset,
      origin: PopoverAnchorMode.selfCenter,
      slideSides: const <PopoverSide>{},
      barrier: PopoverBarrier.none,
      anchor: trigger,
      content: (BuildContext context, PopoverAnchorMetrics metrics) =>
          MouseRegion(
            onEnter: (_) => _pending = -1,
            onExit: (_) {
              _pending = null;
              _scheduleClose();
            },
            child: _panelBody(context, item.content!),
          ),
    );
  }
}

/// `NavigationMenuIndicator` — the caret that ties an open panel back to the
/// trigger that opened it.
///
/// The source's own note: *"Not an active indicator — navigation's active mark
/// is a blue rule, and §3 forbids navigation glowing at all. This one only says
/// which trigger the panel belongs to, so it wears the panel's own surface and
/// rides up out of a clipping box: half a rotated square is a triangle, and
/// `translate-y-1/2` is a fraction rather than the arbitrary `top-[60%]` stock
/// shipped."*
///
/// **Where it sits is drift 1 on [NavigationMenu]**: Radix pins it to the
/// list's leading edge for every trigger, because every trigger's `offsetLeft`
/// is measured inside its own `relative` `li` and is therefore 0. Only [width]
/// follows the open trigger. Mounted by [NavigationMenu] when its
/// `indicator` is set; public because the reference exports it, and because a
/// caret that points at the wrong thing should be assertable by name.
class NavigationMenuIndicator extends StatelessWidget {
  const NavigationMenuIndicator({super.key, required this.width});

  /// The open trigger's `offsetWidth` — an integer, as Radix reads it.
  final double width;

  @override
  Widget build(BuildContext context) {
    final double caret = NavigationMenu.caretSize;
    return SizedBox(
      width: width,
      height: NavigationMenu.indicatorHeight,
      // `overflow-hidden`: half a rotated square is a triangle.
      child: ClipRect(
        child: OverflowBox(
          alignment: Alignment.bottomCenter,
          maxHeight: caret * 2,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Transform.translate(
              // `translate-y-1/2` — a fraction of the square's own box.
              offset: Offset(0, caret / 2),
              child: Transform.rotate(
                // `rotate-45` — an eighth of a turn.
                angle: math.pi / 4,
                child: _CaretSquare(size: caret),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The rotated square itself: `size-2 rounded-tl-sm bg-popover ring-1
/// ring-foreground/10`.
class _CaretSquare extends StatelessWidget {
  const _CaretSquare({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: theme.popover,
        // `rounded-tl-sm` — the corner that becomes the caret's point once the
        // square is turned.
        borderRadius: BorderRadius.only(topLeft: Radius.circular(Radii.sm)),
        border: Border.all(
          color: theme.foreground.withValues(alpha: _caretRingAlpha),
          width: BorderWidths.hairline,
        ),
      ),
    );
  }
}

/// `ring-1 ring-foreground/10` — the same rim [PopoverSurface] wears.
const double _caretRingAlpha = 0.10;

/// The 40px indicator: `navigationMenuTriggerStyle()`, with or without a chevron.
class _NavigationMenuTrigger extends StatefulWidget {
  const _NavigationMenuTrigger({
    required this.label,
    required this.open,
    required this.chevron,
    this.onTap,
    this.onHover,
  });

  final String label;
  final bool open;

  /// `NavigationMenuTrigger` appends one; `NavigationMenuLink` does not.
  final bool chevron;

  final VoidCallback? onTap;
  final ValueChanged<bool>? onHover;

  @override
  State<_NavigationMenuTrigger> createState() =>
      _NavigationMenuTriggerState();
}

class _NavigationMenuTriggerState extends State<_NavigationMenuTrigger> {
  bool _hovered = false;

  void _hover(bool value) {
    if (_hovered != value) setState(() => _hovered = value);
    widget.onHover?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final bool lit = widget.open || _hovered;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _hover(true),
      onExit: (_) => _hover(false),
      child: Semantics(
        button: true,
        expanded: widget.chevron ? widget.open : null,
        label: widget.label,
        child: Press(
          onTap: widget.onTap,
          child: SizedBox(
            height: NavigationMenu.triggerHeight,
            // A [Container], not a bare [DecoratedBox]: `border
            // border-transparent` is invisible and still occupies a pixel on
            // each edge, and only [Container] passes a decoration's own
            // `dimensions` down as padding. Measured: a "Packs" trigger is
            // 92.89 wide, of which two pixels are that border.
            child: Container(
              decoration: BoxDecoration(
                // Both `hover:` and `data-[state=open]:` fills, and they snap —
                // `transition-property` is `transform` alone (drift 3).
                color: lit ? theme.secondary : transparent,
                borderRadius: BorderRadius.circular(Radii.full),
                border: Border.all(
                  color: transparent,
                  width: BorderWidths.hairline,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: NavigationMenu.triggerPaddingX,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    StyledText(
                      widget.label,
                      TextStyles.navMenuTrigger,
                      color: lit ? theme.foreground : theme.mutedForeground,
                      softWrap: false,
                    ),
                    if (widget.chevron) ...<Widget>[
                      SizedBox(width: NavigationMenu.triggerGap),
                      _Chevron(open: widget.open, lit: lit),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The trigger's chevron — the one thing on this control that interpolates.
///
/// `transition-transform duration-base ease-spring` compiles to
/// `transition-property: transform, translate, scale, rotate`, and `rotate-180`
/// writes the standalone `rotate` property — which **is** in that list. Probed:
/// `rotate: 180deg` when open, on `0.25s cubic-bezier(0.34, 1.56, 0.64, 1)`.
class _Chevron extends StatelessWidget {
  const _Chevron({required this.open, required this.lit});

  final bool open;
  final bool lit;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return DefaultTextStyle.merge(
      // `Icon` strokes `currentColor`, which on this trigger is whatever the
      // label resolved to — so the glyph's `tone: inherit` reads this.
      style: TextStyle(color: lit ? theme.foreground : theme.mutedForeground),
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(end: open ? 1 : 0),
        duration: effectiveMotionDuration(context, MotionDurations.normal),
        curve: MotionCurves.emphasized,
        builder: (BuildContext context, double t, Widget? child) =>
            Transform.rotate(angle: math.pi * t, child: child),
        child: Icon(
          IconGlyph.chevronDown,
          sizePx: NavigationMenu.chevronPx,
          tone: IconTone.inherit,
        ),
      ),
    );
  }
}

/// One row inside a panel — `NavigationMenuLink`.
///
/// `press flex items-center gap-2 rounded-md px-3 py-2 text-sm
/// text-muted-foreground hover:bg-accent hover:text-accent-foreground
/// data-active:bg-accent data-active:text-accent-foreground`.
///
/// **Nothing here transitions either**: `press` supplies the whole shorthand
/// and no colour utility follows it, so the fill and the ink land in one frame.
/// Probed on a hovered Packs row: `background-color rgb(63, 63, 70)`,
/// `color rgb(250, 250, 250)`, `transition-property: transform`.
///
/// `active` is Radix's `data-active=""`, and the source's own note explains why
/// it is spelled `data-active:` and never `data-[active=true]`: *"an empty
/// string is not `true`"*.
class NavigationMenuLink extends StatefulWidget {
  const NavigationMenuLink({
    super.key,
    required this.child,
    this.active = false,
    this.onTap,
  });

  /// The row's content — the page passes either an icon-and-label row or a
  /// two-line title/blurb column.
  final Widget child;

  /// `active` — *"Marks the current destination."*
  final bool active;

  final VoidCallback? onTap;

  /// `px-3`.
  static double get paddingX => space(3);

  /// `py-2`.
  static double get paddingY => space(2);

  /// `gap-2`.
  static double get gap => space(2);

  /// `[&_svg:not([class*='size-'])]:size-4`.
  static double get iconPx => space(4);

  @override
  State<NavigationMenuLink> createState() => _NavigationMenuLinkState();
}

class _NavigationMenuLinkState extends State<NavigationMenuLink> {
  bool _hovered = false;

  void _hover(bool value) {
    if (_hovered == value) return;
    setState(() => _hovered = value);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final bool lit = widget.active || _hovered;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _hover(true),
      onExit: (_) => _hover(false),
      child: Semantics(
        link: true,
        selected: widget.active,
        child: Press(
          onTap: widget.onTap,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: lit ? theme.accent : transparent,
              borderRadius: BorderRadius.circular(Radii.md),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: NavigationMenuLink.paddingX,
                vertical: NavigationMenuLink.paddingY,
              ),
              child: DefaultTextStyle(
                // `text-sm text-muted-foreground` — ambient, so the row's own
                // children (and any `tone: inherit` glyph in them) read it.
                style: StyledText.styleOf(
                  context,
                  TextStyles.bodySmall,
                  color: lit ? theme.accentForeground : theme.mutedForeground,
                ),
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
