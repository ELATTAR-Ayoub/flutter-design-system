/// `components/ui/sidebar.tsx` — the app shell, taken apart.
///
/// Twenty-three exports and one idea: **the panel is a flex column of regions,
/// and every control inside it is a `Button` in sidebar geometry.** Nothing
/// here paints an active state, a hover fill or a focus ring of its own; the
/// row ladder, the paddings and the press feel all come from [DsButton], and
/// the selection comes from the menu's own travelling pill.
///
/// ## What was measured before it was built
///
/// Driven on `http://localhost:3000/design-system/components/base/sidebar` at
/// 1440 × 900 (2026-08-16, `sb-inv.js` / `sb-tree.js` / `sb-collapse.js` /
/// `sb-parts.js` / `sb-tip.js` / `sb-matrix.js` in the scratchpad):
///
/// | behaviour | measured |
/// |---|---|
/// | icon collapse | gap **and** container 256 → 48 in even ~13.85px steps per frame, reaching 48 exactly **250ms** after the state flip — `duration-base ease-linear`, and genuinely **linear**: no front-loading, no overshoot |
/// | offcanvas collapse | gap 256 → **0**, container keeps its 256 and slides its left edge 301 → 45, both linear over the same 250ms |
/// | the row, mid-collapse | **snaps**. `group-data-[collapsible=icon]:size-8!` lands whole on the transition's first frame (231 × 37.5 → 32 × 32 at Δ0), because width and height are not in `btn-spring`'s property list. The panel slides; its contents cut |
/// | keyboard | `⌘B` / `Ctrl-B` toggles, from anywhere — measured expanding 48 → 256 on the same linear 250ms |
/// | rail | 16px wide, straddling the panel's **inner** edge (centre = the panel edge less its border), `transition-all duration-base ease-out-flex`; it has no motion of its own — it tracks the edge the container's own transition is moving |
/// | collapsed tooltip | `side="right" align="center"`, content 10px clear of the row's right edge and centred on it, the diamond's centre 2px inside the content's left edge |
/// | disclosure line | `h-px` → `h-1`, 1 → 4px over 250ms `--ease-out` |
/// | group fold | `anim-fold` — 250ms `--ease-in-out` (162 → 148.61 at Δ53, which is that curve to within a frame) |
/// | menu row hover | `--secondary` reached over 250ms on `--ease-spring`, overshooting to rgb(43,43,46) past a rgb(39,39,42) target — [DsButton]'s own colour spring, untouched |
///
/// ## The five duration-word sites
///
/// `sidebar.tsx` carries five `duration-base` classes — on the gap, the
/// container, the rail, the group label and the disclosure line. The sweep's
/// standing finding is that a `duration-<word>` utility emits nothing; what
/// makes all five run at 250ms anyway is `--default-transition-duration: 250ms`
/// (globals.css L395), which is `--duration-base` pointed at the framework's
/// own default. Measured, all five are 250ms. The **easings** are real
/// utilities and do apply: `linear` on the gap and the container, `ease-out-flex`
/// on the rail, `linear` on the group label, `--ease-out` on the line.
///
/// ## Drift register — reproduced, not fixed
///
///  1. **`SidebarMenuBadge` is typed twice and loses.** `.type-num-xs`
///     (11/600) meets `Badge`'s own `text-xs font-medium` (12/500) and the
///     utility layer wins both properties; only the mono family, the tabular
///     figures and −0.01em survive. See [DsComponentType.sidebarMenuBadge].
///  2. **`NavUser`'s `<AvatarFallback className="type-num-sm">` loses the
///     other half** — `text-sm`'s 13px beats `.type-num-sm`'s 12, and 600
///     survives because `AvatarFallback` states no weight. Same collision,
///     opposite outcome. See [DsComponentType.avatarFallback].
///  3. **`SidebarGroupLabel`'s `px-3 pr-10` never renders on the page.** Every
///     label on it is inside a [DsSidebarCollapsibleGroup], which passes
///     `px-0`; tailwind-merge drops `pr-10` with it. The padding is built
///     because the export declares it, and no specimen shows it.
///  4. **`SidebarMenuSkeleton`'s width is a hash of `useId()`**, chosen so
///     server and client agree. Flutter has no hydration and no `useId`, so
///     the port takes a seed instead — the same variety, a different source.
///  5. **The rail is `tabIndex={-1}`** — a 382px-tall control that cannot be
///     reached from the keyboard, beside a `SidebarTrigger` that does the same
///     job and can. Reproduced: [DsSidebarRail] takes no focus.
///  6. **`sidebar_state` cookie.** The provider writes a seven-day cookie on
///     every toggle. There is no cookie here and no store to put one in;
///     recorded, and the readout copy that mentions it still ships.
///  7. **`SidebarGroupAction`'s `after:-inset-2 md:after:hidden`** is a
///     touch-target expander that is *disabled from `md` up* — so at every
///     width this port renders, the 24px square is the whole hit area.
///     Same on [DsSidebarMenuAction].
///  8. **The pill is measured off `[data-active="true"]`, first match wins.**
///     In the submenu specimen both the parent row and the "Open" sub-link
///     carry it; the pill lands on the parent's 37.5px button, not on the
///     149.5px list item that contains it (measured). [DsSidebarMenu] takes
///     the topmost registered row and sub-buttons never register.
///  9. **DIVERGENCE — the rail's outer half is not clickable.** The strip is
///     16px straddling the panel's inner edge and it *paints* whole, but
///     Flutter hit-tests nothing outside a box's own bounds: the half lying
///     over the inset is shadowed by the inset, which is a later sibling and
///     therefore hit-tested first. CSS has `z-20` for exactly this and Flutter
///     has no cross-sibling z-order. So the rail answers a click on its inner
///     ~9px only. Recorded rather than worked around — the alternatives are a
///     custom `Flex` that reorders hit tests or a layout change, and the
///     control has a keyboard-reachable twin ([DsSidebarTrigger]) doing the
///     same job.
/// 10. **`.sidebar-pill` has no pseudo-elements.** globals.css L2704–2716
///     pauses `::before`/`::after` animations on it and wakes them on hover of
///     the active row — but nothing gives the pill a `bloom-cosmic` or a
///     `starfield`, so `content` computes to `none` and the whole block is
///     inert (measured). The pill is `bg-secondary shadow-chip` and nothing
///     more.
///
/// ## Not ported
///
/// `asChild` (the standing B4 divergence), the `sidebar_state` cookie (drift 6)
/// and `AvatarBadge`-style extras the family does not use. `useIsMobile` is a
/// media query, and the port reads [MediaQuery] for the same 768px threshold.
library;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../effects/machine_surface.dart';
import '../foundation/colors.dart';
import '../foundation/motion.dart';
import '../foundation/shadows.dart';
import '../foundation/spacing.dart';
import '../foundation/theme.dart';
import '../foundation/typography.dart';
import '../motion/keyframes.dart';
import '../text_layout.dart';
import '../theme_scope.dart';
import 'badge.dart';
import 'button.dart';
import 'collapsible.dart';
import 'icon.dart';
import 'icon_paths.g.dart';
import 'icon_swap.dart';
import 'input.dart';
import 'sheet.dart';
import 'skeleton.dart';
import 'tooltip.dart';

/* ── Enums ───────────────────────────────────────────────────────────────── */

/// `Sidebar side` — which edge the panel is fixed to.
enum DsSidebarSide {
  left,
  right;

  bool get isLeft => this == DsSidebarSide.left;
}

/// `Sidebar variant`.
enum DsSidebarVariant {
  /// Flush against the viewport edge, with a border on the inset side.
  sidebar,

  /// Inset by `p-2`, the panel itself a rounded card with a ring.
  floating,

  /// Inset by `p-2` as well, but it is the **main column** that becomes the
  /// card — the wrapper paints `--sidebar` behind everything.
  inset,
}

/// `Sidebar collapsible` — what collapsing does.
enum DsSidebarCollapsible {
  /// The panel slides off the edge and the gap closes to nothing.
  offcanvas,

  /// The panel narrows to `--width-sidebar-icon` and keeps its glyphs.
  icon,

  /// It does not collapse; there is no gap, no container and no rail, and the
  /// panel is a plain flex column. Every part specimen on the page is one.
  none,
}

/// `SidebarMenuButton size` — the row ladder.
enum DsSidebarMenuButtonSize {
  /// `sm` → `Button` `xs`: `gap-1`, `text-xs`, a 12px glyph.
  sm,

  /// The cva's default → `Button` `sm`: `gap-1.5`, `text-small`, a 14px glyph.
  /// **37.5px tall** at `h-auto px-2 py-2` (measured).
  md,

  /// `lg` → `Button` `lg`: `gap-2.5`, `text-body`, a 16px glyph. **50px** with
  /// a 32px tile in it (measured).
  lg;

  /// `MENU_BUTTON_SIZE` — *"the sidebar's three row heights, expressed in
  /// Button's own ladder."*
  DsButtonSize get button => switch (this) {
        DsSidebarMenuButtonSize.sm => DsButtonSize.xs,
        DsSidebarMenuButtonSize.md => DsButtonSize.sm,
        DsSidebarMenuButtonSize.lg => DsButtonSize.lg,
      };
}

/// `SidebarMenuSubButton size`.
enum DsSidebarMenuSubButtonSize {
  /// → `Button` `xs`.
  sm,

  /// The default → `Button` `sm`, a 32px link.
  md;

  DsButtonSize get button => switch (this) {
        DsSidebarMenuSubButtonSize.sm => DsButtonSize.xs,
        DsSidebarMenuSubButtonSize.md => DsButtonSize.sm,
      };
}

/* ── Scopes ──────────────────────────────────────────────────────────────── */

/// `useSidebar()` — the provider's whole contract.
///
/// The reference throws outside a provider (*"useSidebar must be used within a
/// SidebarProvider"*) and so does [of]; [maybeOf] is the non-throwing read the
/// port's own widgets use where the reference would have had no consumer.
class DsSidebarScope extends InheritedWidget {
  const DsSidebarScope({
    super.key,
    required this.open,
    required this.openMobile,
    required this.isMobile,
    required this.setOpen,
    required this.setOpenMobile,
    required this.toggleSidebar,
    required this.variant,
    required super.child,
  });

  /// The desktop panel's open flag.
  final bool open;

  /// The mobile sheet's own flag — a separate boolean, as it is upstream.
  final bool openMobile;

  /// `useIsMobile()` — the viewport is under 768px.
  final bool isMobile;

  final ValueChanged<bool> setOpen;
  final ValueChanged<bool> setOpenMobile;

  /// `isMobile ? setOpenMobile(!openMobile) : setOpen(!open)`.
  final VoidCallback toggleSidebar;

  /// The variant the provider was told about — see
  /// [DsSidebarProvider.variant] for why a *provider* knows this at all.
  final DsSidebarVariant variant;

  /// `data-state` — `"expanded"` or `"collapsed"`.
  bool get collapsed => !open;

  static DsSidebarScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<DsSidebarScope>();

  static DsSidebarScope of(BuildContext context) {
    final DsSidebarScope? scope = maybeOf(context);
    assert(scope != null, 'DsSidebarScope.of must be used within a '
        'DsSidebarProvider.');
    return scope!;
  }

  @override
  bool updateShouldNotify(DsSidebarScope old) =>
      old.open != open ||
      old.openMobile != openMobile ||
      old.isMobile != isMobile ||
      old.variant != variant;
}

/// The three `data-*` attributes [DsSidebar] writes on itself, published to the
/// regions inside it.
///
/// Every `group-data-[collapsible=icon]:` rule in the file reads exactly one of
/// these, which is why the port publishes them once here instead of threading a
/// flag through fifteen constructors.
class DsSidebarChrome extends InheritedWidget {
  const DsSidebarChrome({
    super.key,
    required this.side,
    required this.variant,
    required this.collapsible,
    required super.child,
  });

  final DsSidebarSide side;
  final DsSidebarVariant variant;

  /// `data-collapsible` — the panel's collapse mode **while it is collapsed**,
  /// and null (the empty string) while it is not. That conditional is the
  /// reference's own: `data-collapsible={state === "collapsed" ? collapsible : ""}`.
  final DsSidebarCollapsible? collapsible;

  /// `group-data-[collapsible=icon]` — the predicate fifteen rules turn on.
  bool get iconMode => collapsible == DsSidebarCollapsible.icon;

  static DsSidebarChrome? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<DsSidebarChrome>();

  /// False outside a [DsSidebar], which is what an element carrying no
  /// `data-collapsible` resolves to.
  static bool iconModeOf(BuildContext context) =>
      maybeOf(context)?.iconMode ?? false;

  @override
  bool updateShouldNotify(DsSidebarChrome old) =>
      old.side != side ||
      old.variant != variant ||
      old.collapsible != collapsible;
}

/* ── Provider ────────────────────────────────────────────────────────────── */

/// `SidebarProvider` — the state, the keyboard shortcut and the wrapper row.
///
/// `div.group/sidebar-wrapper.flex.min-h-svh.w-full.has-data-[variant=inset]:bg-sidebar`.
class DsSidebarProvider extends StatefulWidget {
  const DsSidebarProvider({
    super.key,
    required this.children,
    this.defaultOpen = true,
    this.open,
    this.onOpenChange,
    this.variant = DsSidebarVariant.sidebar,
    this.minHeight,
  });

  /// The wrapper's flex children — a [DsSidebar] and usually a
  /// [DsSidebarInset].
  final List<Widget> children;

  /// Uncontrolled initial state.
  final bool defaultOpen;

  /// `open` — pass it (with [onOpenChange]) to drive the panel from outside.
  final bool? open;

  final ValueChanged<bool>? onOpenChange;

  /// `has-data-[variant=inset]:bg-sidebar`, and the `peer-data-[variant=inset]`
  /// rules [DsSidebarInset] resolves.
  ///
  /// **Both are relational selectors the reference can write and Flutter
  /// cannot.** One asks a parent what its descendants are (`:has()`), the other
  /// asks a box what its *sibling* is (`peer-`). A Flutter widget can do
  /// neither, so — exactly as `DropdownMenuTrigger`'s `aria-expanded` does in
  /// `dropdown_menu.dart` — the fact travels **down** instead of up. The call
  /// site passes the same value here and to its [DsSidebar]; they must agree,
  /// and on the reference they agree by construction because one is computed
  /// from the other.
  final DsSidebarVariant variant;

  /// `min-h-svh`.
  ///
  /// Null by default, because **every specimen on the sidebar page cancels
  /// it**: the part stage passes `min-h-0 w-auto` and the shell stage
  /// `h-full min-h-0`. A real application shell passes the viewport height.
  final double? minHeight;

  /// `SIDEBAR_KEYBOARD_SHORTCUT` — `b`, with meta or control.
  static const LogicalKeyboardKey shortcut = LogicalKeyboardKey.keyB;

  /// `MOBILE_BREAKPOINT` — `(max-width: 767px)`.
  static bool isMobileWidth(double width) => width < DsBreakpoints.md;

  @override
  State<DsSidebarProvider> createState() => _DsSidebarProviderState();
}

class _DsSidebarProviderState extends State<DsSidebarProvider> {
  late bool _open = widget.defaultOpen;
  bool _openMobile = false;

  bool get _isOpen => widget.open ?? _open;

  void _setOpen(bool value) {
    // `document.cookie = sidebar_state=…` has no counterpart — drift 6.
    if (widget.onOpenChange != null) {
      widget.onOpenChange!(value);
      return;
    }
    setState(() => _open = value);
  }

  void _setOpenMobile(bool value) => setState(() => _openMobile = value);

  bool _isMobile(BuildContext context) =>
      DsSidebarProvider.isMobileWidth(MediaQuery.sizeOf(context).width);

  void _toggle() {
    if (_isMobile(context)) {
      _setOpenMobile(!_openMobile);
      return;
    }
    _setOpen(!_isOpen);
  }

  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_onKey);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_onKey);
    super.dispose();
  }

  /// `window.addEventListener("keydown", …)`.
  ///
  /// A **document**-level listener, not a subtree one, and the distinction is
  /// the whole point: the shortcut works with focus anywhere on the page —
  /// including nowhere, which is where focus sits until something is tapped.
  /// [HardwareKeyboard]'s handler list is Flutter's spelling of that; a
  /// `Focus` in the widget tree only ever sees what bubbles up from a focused
  /// descendant.
  ///
  /// One consequence is faithfully reproduced: a page carrying **several**
  /// providers installs several listeners, and `⌘B` toggles all of them. That
  /// is what the reference does too, and on the sidebar page it is invisible
  /// because every part stage is `collapsible="none"`.
  bool _onKey(KeyEvent event) {
    if (event is! KeyDownEvent) return false;
    if (event.logicalKey != DsSidebarProvider.shortcut) return false;
    final Set<LogicalKeyboardKey> pressed =
        HardwareKeyboard.instance.logicalKeysPressed;
    final bool modified = pressed.contains(LogicalKeyboardKey.metaLeft) ||
        pressed.contains(LogicalKeyboardKey.metaRight) ||
        pressed.contains(LogicalKeyboardKey.controlLeft) ||
        pressed.contains(LogicalKeyboardKey.controlRight);
    if (!modified) return false;
    _toggle();
    // `event.preventDefault()`.
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);

    Widget row = Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: widget.children,
    );

    if (widget.minHeight != null) {
      row = ConstrainedBox(
        constraints: BoxConstraints(minHeight: widget.minHeight!),
        child: row,
      );
    }

    if (widget.variant == DsSidebarVariant.inset) {
      row = ColoredBox(color: theme.sidebar, child: row);
    }

    return DsSidebarScope(
      open: _isOpen,
      openMobile: _openMobile,
      isMobile: _isMobile(context),
      setOpen: _setOpen,
      setOpenMobile: _setOpenMobile,
      toggleSidebar: _toggle,
      variant: widget.variant,
      child: row,
    );
  }
}

/* ── The panel ───────────────────────────────────────────────────────────── */

/// `Sidebar` — the gap, the container and the panel inside it.
///
/// Three renderings, as upstream has them: a plain flex column when
/// [collapsible] is [DsSidebarCollapsible.none], a `Sheet` on mobile, and the
/// gap-plus-fixed-container pair on desktop.
///
/// **`position: fixed` is a `Stack` here.** The reference's container is fixed
/// to the viewport and the page's own shell stage traps it with `transform-gpu`
/// — *"CSS doing its documented job rather than a hack, and it is the whole
/// reason `SidebarRail` and `SidebarInset` can be documented in a panel instead
/// of behind a link."* Flutter has no `fixed`, and does not need one: the
/// container is an overflowing child of the gap's own [Stack], which is
/// precisely what the trapped-fixed element renders as.
class DsSidebar extends StatelessWidget {
  const DsSidebar({
    super.key,
    required this.children,
    this.side = DsSidebarSide.left,
    this.variant = DsSidebarVariant.sidebar,
    this.collapsible = DsSidebarCollapsible.offcanvas,
    this.expand = false,
  });

  /// The panel's regions, top to bottom.
  final List<Widget> children;

  final DsSidebarSide side;

  /// Must match [DsSidebarProvider.variant] — see that field.
  final DsSidebarVariant variant;

  final DsSidebarCollapsible collapsible;

  /// `w-full` in place of `w-(--sidebar-width)`.
  ///
  /// [DsSidebarCollapsible.none] only, and it is a page override rather than a
  /// component prop upstream: `PartStage` writes `className="w-full"` onto the
  /// `Sidebar`, which is how one 256px component becomes the full-width stage
  /// every part specimen sits on.
  final bool expand;

  /// `w-[calc(var(--sidebar-width-icon)+(--spacing(4)))]` — the collapsed
  /// **gap** under `floating` / `inset`, which have to pay for their own `p-2`
  /// on both edges. 64px.
  static double get insetIconGap => DsWidths.sidebarIcon + ds(4);

  /// `w-[calc(var(--sidebar-width-icon)+(--spacing(4))+2px)]` — the same
  /// measure for the **container**, plus the two hairlines. 66px.
  static double get insetIconWidth => insetIconGap + DsWidths.hairline * 2;

  /// `p-2` on the container under `floating` / `inset`.
  static double get framePadding => ds(2);

  /// `w-4` — the rail's own width.
  static double get railWidth => ds(4);

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final DsSidebarScope scope = DsSidebarScope.of(context);

    if (collapsible == DsSidebarCollapsible.none) {
      // `flex h-full w-(--sidebar-width) flex-col bg-sidebar
      //  text-sidebar-foreground`.
      return DsSidebarChrome(
        side: side,
        variant: variant,
        collapsible: null,
        child: _panelInk(
          theme,
          SizedBox(
            width: expand ? null : DsWidths.sidebar,
            child: ColoredBox(
              color: theme.sidebar,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: children,
              ),
            ),
          ),
        ),
      );
    }

    if (scope.isMobile) return _mobile(context, theme, scope);

    // `:has()` on the panel's own children — a [DsSidebarRail] among them is
    // what puts a rail on the edge, and the widget itself renders nothing in
    // the flow, exactly as an `absolute inset-y-0` element contributes nothing
    // to its column.
    final bool hasRail = children.any((Widget w) => w is DsSidebarRail);

    final bool collapsed = scope.collapsed;
    final DsSidebarCollapsible? mode = collapsed ? collapsible : null;
    final bool iconMode = mode == DsSidebarCollapsible.icon;
    final bool offcanvas = mode == DsSidebarCollapsible.offcanvas;
    final bool framed = variant != DsSidebarVariant.sidebar;

    final double gapWidth = offcanvas
        ? 0
        : iconMode
            ? (framed ? insetIconGap : DsWidths.sidebarIcon)
            : DsWidths.sidebar;
    final double containerWidth = iconMode
        ? (framed ? insetIconWidth : DsWidths.sidebarIcon)
        : DsWidths.sidebar;
    // `data-[side=left]:group-data-[collapsible=offcanvas]:left-[calc(var(--sidebar-width)*-1)]`
    // — the panel keeps its width and leaves.
    final double slide = offcanvas ? -DsWidths.sidebar : 0;
    // `group-data-[side=left]:border-r` / `border-l`, on the plain variant only.
    final double border = framed ? 0 : DsWidths.hairline;

    final Duration duration =
        dsAnimationDuration(context, DsDurations.transitionDefault);

    return DsSidebarChrome(
      side: side,
      variant: variant,
      collapsible: mode,
      child: _panelInk(
        theme,
        TweenAnimationBuilder<double>(
          tween: Tween<double>(end: gapWidth),
          duration: duration,
          curve: DsCurves.linear,
          builder: (BuildContext context, double gap, Widget? _) =>
              TweenAnimationBuilder<double>(
            tween: Tween<double>(end: containerWidth),
            duration: duration,
            curve: DsCurves.linear,
            builder: (BuildContext context, double width, Widget? _) =>
                TweenAnimationBuilder<double>(
              tween: Tween<double>(end: slide),
              duration: duration,
              curve: DsCurves.linear,
              builder: (BuildContext context, double dx, Widget? _) {
                // In the gap's own coordinates.
                final double left = side.isLeft ? dx : gap - width - dx;
                final double railCentre =
                    side.isLeft ? left + width - border : left + border;
                return SizedBox(
                  width: gap,
                  child: Stack(
                    // The container overflows the gap in every collapsed state
                    // and in `floating`; the stage above clips it, exactly as
                    // `overflow-hidden` does on the reference.
                    clipBehavior: Clip.none,
                    children: <Widget>[
                      Positioned(
                        left: left,
                        top: 0,
                        bottom: 0,
                        width: width,
                        child: _container(theme, framed: framed),
                      ),
                      // `z-20`, above the container's `z-10`.
                      if (hasRail)
                        Positioned(
                          left: railCentre - railWidth / 2,
                          top: 0,
                          bottom: 0,
                          width: railWidth,
                          child: _RailSlot(offcanvas: offcanvas),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  /// `text-sidebar-foreground` — the ambient ink every region inherits.
  Widget _panelInk(DsThemeData theme, Widget child) => DefaultTextStyle.merge(
        style: TextStyle(color: theme.sidebarForeground),
        child: child,
      );

  /// `sidebar-container` + `sidebar-inner`.
  Widget _container(DsThemeData theme, {required bool framed}) {
    final bool floating = variant == DsSidebarVariant.floating;

    Widget inner = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );

    if (floating) {
      // `rounded-lg shadow-sm ring-1 ring-sidebar-border`. A ring is drawn
      // outside the box in CSS; at this size the difference is the hairline
      // itself, and a border is what Flutter can paint on the same shape.
      inner = DecoratedBox(
        decoration: BoxDecoration(
          color: theme.sidebar,
          borderRadius: BorderRadius.circular(DsRadii.lg),
          border: Border.all(
            color: theme.sidebarBorder,
            width: DsWidths.hairline,
          ),
          boxShadow: DsShadows.tailwindSm.outerShadows(theme),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(DsRadii.lg - DsWidths.hairline),
          child: inner,
        ),
      );
    } else {
      inner = ColoredBox(color: theme.sidebar, child: inner);
    }

    if (framed) {
      return Padding(padding: EdgeInsets.all(framePadding), child: inner);
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          right: side.isLeft
              ? BorderSide(color: theme.border, width: DsWidths.hairline)
              : BorderSide.none,
          left: side.isLeft
              ? BorderSide.none
              : BorderSide(color: theme.border, width: DsWidths.hairline),
        ),
      ),
      // `box-sizing: border-box` — the hairline is paid out of the container's
      // own 256, which is why the reference's `sidebar-inner` measures **255**
      // beside a 256 container. A [DecoratedBox] paints its border over the
      // child rather than inside it, so the inset is stated here.
      child: Padding(
        padding: EdgeInsets.only(
          left: side.isLeft ? 0 : DsWidths.hairline,
          right: side.isLeft ? DsWidths.hairline : 0,
        ),
        child: inner,
      ),
    );
  }

  /// The mobile branch: `Sheet` on the same side, at
  /// `--width-sidebar-mobile`, with the close button hidden.
  ///
  /// Never rendered at any width this port's rig or page tests use — the page
  /// is measured at 1440 — and built because the component declares it.
  Widget _mobile(
    BuildContext context,
    DsThemeData theme,
    DsSidebarScope scope,
  ) {
    if (!scope.openMobile) return const SizedBox.shrink();
    return DsSidebarChrome(
      side: side,
      variant: variant,
      collapsible: null,
      child: Semantics(
        // `<SheetHeader className="sr-only"><SheetTitle>Sidebar</SheetTitle>`.
        label: 'Sidebar',
        hint: 'Displays the mobile sidebar.',
        container: true,
        child: DsSheetContent(
          side: side.isLeft ? DsSheetSide.left : DsSheetSide.right,
          // `[&>button]:hidden`.
          showCloseButton: false,
          width: DsWidths.sidebarMobile,
          fill: theme.sidebar,
          children: <Widget>[
            // `<div className="flex h-full w-full flex-col">`.
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: children,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ── Rail, trigger, inset ────────────────────────────────────────────────── */

/// `SidebarRail` — the 16px strip on the panel's edge that toggles it.
///
/// Placement is [DsSidebar]'s (the strip has to know where the container's
/// edge currently is); this is the control itself, and it is what a call site
/// composes into the panel. Rendering it outside a [DsSidebar] renders nothing,
/// which is what `sm:flex` plus a `hidden` base amounts to on a page that has
/// no panel.
class DsSidebarRail extends StatelessWidget {
  const DsSidebarRail({super.key});

  /// `after:w-0.5` — *"a 2px hover hairline is a rule, the same class of
  /// measure as a border."*
  static double get hairline => ds(0.5);

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

/// The rail as [DsSidebar] actually paints it, in the slot it computed.
class _RailSlot extends StatefulWidget {
  const _RailSlot({required this.offcanvas});

  /// `group-data-[collapsible=offcanvas]:` — the hover feedback changes from a
  /// hairline down the middle to a fill across the whole strip, and the
  /// hairline moves to `after:left-full`.
  final bool offcanvas;

  @override
  State<_RailSlot> createState() => _RailSlotState();
}

class _RailSlotState extends State<_RailSlot> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final DsSidebarScope scope = DsSidebarScope.of(context);
    final DsSidebarChrome? chrome = DsSidebarChrome.maybeOf(context);
    final bool left = chrome?.side.isLeft ?? true;

    // `in-data-[side=left]:cursor-w-resize`, flipping to `e-resize` once the
    // panel is collapsed — the cursor says which way the click will move it.
    final bool collapsed = scope.collapsed;
    final SystemMouseCursor cursor = (left != collapsed)
        ? SystemMouseCursors.resizeLeft
        : SystemMouseCursors.resizeRight;

    return MouseRegion(
      cursor: cursor,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: scope.toggleSidebar,
        child: Semantics(
          button: true,
          label: 'Toggle Sidebar',
          // `tabIndex={-1}` — drift 5.
          excludeSemantics: true,
          child: AnimatedContainer(
            duration:
                dsAnimationDuration(context, DsDurations.transitionDefault),
            curve: DsCurves.outFlex,
            color: _hovered && widget.offcanvas
                ? theme.sidebar
                : dsTransparent,
            child: Align(
              // `after:start-1/2`, and `after:left-full` once offcanvas.
              alignment: widget.offcanvas
                  ? Alignment.centerRight
                  : Alignment.center,
              child: SizedBox(
                width: DsSidebarRail.hairline,
                child: ColoredBox(
                  color: _hovered ? theme.sidebarBorder : dsTransparent,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// `SidebarTrigger` — a `ghost` `icon-sm` button whose glyph **rolls**.
///
/// *"The panel is a two-state control, so its glyph rolls rather than swapping
/// — §4. Collapsing rolls one way through the strip and expanding rolls back,
/// which is how you can tell which direction you just moved."*
class DsSidebarTrigger extends StatelessWidget {
  const DsSidebarTrigger({super.key, this.onPressed});

  /// `onClick` — called **before** the toggle, as the reference orders it.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final DsSidebarScope scope = DsSidebarScope.of(context);
    return DsButton(
      variant: DsButtonVariant.ghost,
      size: DsButtonSize.iconSm,
      label: 'Toggle Sidebar',
      onPressed: () {
        onPressed?.call();
        scope.toggleSidebar();
      },
      child: DsIconSwap(
        // `active={state}` — two states, so the strip rolls between them.
        activeIndex: scope.open ? 0 : 1,
        // `className="size-4"` on the swap, holding `Icon size="md"` glyphs.
        window: DsIcon.pxFor(DsIconSize.md),
        cell: DsIcon.pxFor(DsIconSize.md),
        icons: const <Widget>[
          DsIcon.lucide(DsLucide.panelLeftClose),
          DsIcon.lucide(DsLucide.panelLeft),
        ],
      ),
    );
  }
}

/// `SidebarInset` — the main column beside the panel.
///
/// `min-w-0` is load-bearing and stock does not ship it; the reference's own
/// note runs to thirty lines and ends *"no guard can see this."* In Flutter the
/// same statement is [Expanded] over a column that is free to be narrower than
/// its content, which is the default here rather than an opt-out.
class DsSidebarInset extends StatelessWidget {
  const DsSidebarInset({super.key, required this.child});

  final Widget child;

  /// `m-2` / `ml-2` on the inset variant.
  static double get margin => ds(2);

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final DsSidebarScope scope = DsSidebarScope.of(context);

    Widget main = ColoredBox(color: theme.background, child: child);

    if (scope.variant == DsSidebarVariant.inset) {
      // `md:peer-data-[variant=inset]:m-2 md:…:ml-0 md:…:rounded-xl
      //  md:…:shadow-sm md:…:peer-data-[state=collapsed]:ml-2` *(measured:
      // margin `8px 8px 8px 0px` expanded, `8px` all round collapsed)*.
      main = DecoratedBox(
        decoration: BoxDecoration(
          color: theme.background,
          borderRadius: BorderRadius.circular(DsRadii.xl),
          boxShadow: DsShadows.tailwindSm.outerShadows(theme),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(DsRadii.xl),
          child: child,
        ),
      );
      main = Padding(
        padding: EdgeInsets.fromLTRB(
          scope.collapsed ? margin : 0,
          margin,
          margin,
          margin,
        ),
        child: main,
      );
    }

    return Expanded(
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
        Expanded(child: main),
      ]),
    );
  }
}

/* ── Regions ─────────────────────────────────────────────────────────────── */

/// The `p-3` every region and group carries, dropping to `p-2` in icon mode.
EdgeInsets _regionPadding(BuildContext context) => EdgeInsets.all(
      DsSidebarChrome.iconModeOf(context) ? ds(2) : ds(3),
    );

/// `SidebarHeader` — `flex flex-col gap-2 p-3`.
class DsSidebarHeader extends StatelessWidget {
  const DsSidebarHeader({super.key, required this.children});

  final List<Widget> children;

  /// `gap-2`.
  static double get gap => ds(2);

  @override
  Widget build(BuildContext context) => Padding(
        padding: _regionPadding(context),
        child: _GappedColumn(gap: gap, children: children),
      );
}

/// `SidebarFooter` — the header's twin, plus `mt-auto`.
///
/// The automatic margin has no counterpart and needs none: the panel's own
/// column puts a [DsSidebarContent] between them, and that is what takes the
/// slack.
class DsSidebarFooter extends StatelessWidget {
  const DsSidebarFooter({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Padding(
        padding: _regionPadding(context),
        child: _GappedColumn(
          gap: DsSidebarHeader.gap,
          children: children,
        ),
      );
}

/// `SidebarContent` — `no-scrollbar flex min-h-0 flex-1 flex-col gap-0
/// overflow-auto`, and `overflow-hidden` in icon mode.
///
/// The only scrolling region in the panel, and the one that makes the footer
/// sit on the floor.
class DsSidebarContent extends StatelessWidget {
  const DsSidebarContent({super.key, this.children = const <Widget>[]});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final Widget column = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
    return Expanded(
      child: DsSidebarChrome.iconModeOf(context)
          ? ClipRect(child: column)
          // `no-scrollbar`: Flutter draws none by default, so the utility has
          // nothing to remove here.
          : SingleChildScrollView(child: column),
    );
  }
}

/// `SidebarSeparator` — `Separator` plus `mx-3 bg-sidebar-border`.
///
/// Painted here rather than composed, because what the reference reuses is a
/// one-declaration primitive (`shrink-0 bg-border data-horizontal:h-px
/// data-horizontal:w-full`) and the sidebar overrides both the colour and the
/// inset.
class DsSidebarSeparator extends StatelessWidget {
  const DsSidebarSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final bool icon = DsSidebarChrome.iconModeOf(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: icon ? ds(2) : ds(3)),
      child: SizedBox(
        height: DsWidths.hairline,
        child: ColoredBox(color: theme.sidebarBorder),
      ),
    );
  }
}

/// `SidebarGroup` — `relative flex w-full min-w-0 flex-col p-3`.
class DsSidebarGroup extends StatelessWidget {
  const DsSidebarGroup({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Padding(
        padding: _regionPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: children,
        ),
      );
}

/// `SidebarGroupContent` — *"no type of its own"*, just `w-full`.
class DsSidebarGroupContent extends StatelessWidget {
  const DsSidebarGroupContent({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}

/// `SidebarGroupLabel` — `.type-nav-sm` at **full strength**, 32px tall.
///
/// The reference's note on the colour is worth keeping whole: stock dims this
/// to `/70`, which it could afford because its token was zinc 700. Here the
/// token is `--muted-foreground`, *"which IS the lightest step that clears AA
/// on both `--background` and `--muted`"*, and 70% of it measures **2.76:1**
/// against the 4.5:1 it owes. At full strength it measures 4.83:1.
class DsSidebarGroupLabel extends StatelessWidget {
  const DsSidebarGroupLabel(this.label, {super.key, this.padding});

  final String label;

  /// Overrides `px-3 pr-10`.
  ///
  /// [DsSidebarCollapsibleGroup] passes [EdgeInsets.zero] — its `px-0`, which
  /// tailwind-merge resolves by dropping `pr-10` as well. Drift 3: that is
  /// every label on the page, so the declared padding never renders.
  final EdgeInsetsGeometry? padding;

  /// `h-8`.
  static double get height => ds(8);

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final bool icon = DsSidebarChrome.iconModeOf(context);

    final Widget row = SizedBox(
      height: height,
      child: Padding(
        padding: padding ?? EdgeInsets.only(left: ds(3), right: ds(10)),
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: DsText(label, DsType.navSm, color: theme.sidebarForeground),
        ),
      ),
    );

    // `transition-[margin,opacity] duration-base ease-linear` with
    // `group-data-[collapsible=icon]:-mt-8 group-data-[collapsible=icon]:opacity-0`.
    //
    // `-mt-8` cancels the label's own `h-8` exactly, so the collapsed group
    // loses the whole row. The port shrinks the box instead of giving it a
    // negative margin, which Flutter has no spelling for; the label is pinned
    // to the box's bottom so the reveal reads the same way round. Nothing on
    // the page renders it — every labelled group here is `collapsible="none"`.
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(end: icon ? 0 : 1),
      duration: dsAnimationDuration(context, DsDurations.transitionDefault),
      curve: DsCurves.linear,
      builder: (BuildContext context, double t, Widget? child) => ClipRect(
        child: Align(
          alignment: Alignment.bottomLeft,
          heightFactor: t,
          child: Opacity(opacity: t, child: child),
        ),
      ),
      child: row,
    );
  }
}

/// `SidebarGroupAction` — a 24px `ghost` square in the group's top-right
/// corner.
///
/// *"24px square at 12/8 from the corner, so it optically centres against the
/// 32px group label beside it: (32 − 24) / 2 = 4, plus the group's own 8px
/// padding."* Positioned by [DsSidebarCollapsibleGroup], which is the only
/// thing that holds one.
class DsSidebarGroupAction extends StatelessWidget {
  const DsSidebarGroupAction({
    super.key,
    required this.child,
    required this.label,
    this.onPressed,
  });

  final Widget child;

  /// `aria-label` — the square has no text.
  final String label;

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => DsButton(
        variant: DsButtonVariant.ghost,
        size: DsButtonSize.iconXs,
        label: label,
        onPressed: onPressed,
        child: child,
      );
}

/// `SidebarCollapsibleGroup` — title, disclosure line, action, folding content.
///
/// *"The line is the trigger rather than the title or action. That keeps the
/// two visible controls honest: clicking the action performs its verb, while
/// the divider only changes disclosure state."*
class DsSidebarCollapsibleGroup extends StatefulWidget {
  const DsSidebarCollapsibleGroup({
    super.key,
    required this.label,
    required this.toggleLabel,
    required this.child,
    this.action,
    this.defaultOpen = true,
  });

  final String label;

  /// The trigger's `aria-label` and its `sr-only` text — the same string twice,
  /// as the reference writes it.
  final String toggleLabel;

  final Widget child;

  /// A [DsSidebarGroupAction], anchored `top-4 right-3` in the group.
  final Widget? action;

  final bool defaultOpen;

  /// `h-6` on the trigger.
  static double get triggerHeight => ds(6);

  /// `h-px`, and `h-1` while closed.
  static double get lineOpen => DsWidths.hairline;
  static double get lineClosed => ds(1);

  @override
  State<DsSidebarCollapsibleGroup> createState() =>
      _DsSidebarCollapsibleGroupState();
}

class _DsSidebarCollapsibleGroupState extends State<DsSidebarCollapsibleGroup> {
  late bool _open = widget.defaultOpen;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final bool hasAction = widget.action != null;

    // `<span className="h-px w-full rounded-pill bg-sidebar-border
    //  transition-[height] duration-base ease-out
    //  group-data-[state=closed]/disclosure:h-1" />`
    final Widget line = TweenAnimationBuilder<double>(
      tween: Tween<double>(
        end: _open
            ? DsSidebarCollapsibleGroup.lineOpen
            : DsSidebarCollapsibleGroup.lineClosed,
      ),
      duration: dsAnimationDuration(context, DsDurations.transitionDefault),
      curve: DsCurves.out,
      builder: (BuildContext context, double h, Widget? _) => SizedBox(
        height: h,
        width: double.infinity,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: theme.sidebarBorder,
            borderRadius: BorderRadius.circular(DsRadii.pill),
          ),
        ),
      ),
    );

    final Widget trigger = DsButton(
      variant: DsButtonVariant.ghost,
      size: DsButtonSize.xs,
      label: widget.toggleLabel,
      expanded: _open,
      onPressed: () => setState(() => _open = !_open),
      // `hover:bg-transparent active:bg-transparent
      //  aria-expanded:bg-transparent` — the line is the affordance; the
      //  button behind it never paints.
      surface: const DsButtonSurface(
        fill: dsTransparent,
        hoverFill: dsTransparent,
      ),
      // `px-0`.
      padding: EdgeInsets.zero,
      contentAlignment: Alignment.center,
      child: line,
    );

    final Widget header = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Flexible(
          child: DsSidebarGroupLabel(widget.label, padding: EdgeInsets.zero),
        ),
        // `mx-2 h-6 min-w-8 flex-1`, and `mr-8` when an action sits beyond it.
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: ds(2),
              right: hasAction ? ds(8) : ds(2),
            ),
            child: SizedBox(
              height: DsSidebarCollapsibleGroup.triggerHeight,
              child: trigger,
            ),
          ),
        ),
      ],
    );

    return DsSidebarGroup(
      children: <Widget>[
        Stack(
          children: <Widget>[
            header,
            if (hasAction)
              // `absolute top-4 right-3`, measured from the GROUP's box — so
              // from the header row it is `top-1 right-0`, the group's own
              // `p-3` having already been paid.
              Positioned(
                top: ds(1),
                right: 0,
                child: widget.action!,
              ),
          ],
        ),
        DsUnfold(
          open: _open,
          child: DsSidebarGroupContent(child: widget.child),
        ),
      ],
    );
  }
}

/* ── Menu ────────────────────────────────────────────────────────────────── */

/// What a [DsSidebarMenuItem] tells the row inside it.
///
/// `group-has-data-[sidebar=menu-action]/menu-item:pr-10` and
/// `group-has-data-[sidebar=menu-badge]/menu-item:pr-16` are `:has()` on a
/// parent — the one relational selector Flutter *can* answer, because the item
/// is handed its own children as a list and can look at them.
class _SidebarMenuItemScope extends InheritedWidget {
  const _SidebarMenuItemScope({
    required this.hasAction,
    required this.hasBadge,
    required super.child,
  });

  final bool hasAction;
  final bool hasBadge;

  static _SidebarMenuItemScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_SidebarMenuItemScope>();

  @override
  bool updateShouldNotify(_SidebarMenuItemScope old) =>
      old.hasAction != hasAction || old.hasBadge != hasBadge;
}

/// Where a [DsSidebarMenuButton] registers itself when it is the active row.
class _SidebarMenuScope extends InheritedWidget {
  const _SidebarMenuScope({required this.state, required super.child});

  final _DsSidebarMenuState state;

  static _SidebarMenuScope? maybeOf(BuildContext context) =>
      context.getInheritedWidgetOfExactType<_SidebarMenuScope>();

  @override
  bool updateShouldNotify(_SidebarMenuScope old) => old.state != state;
}

/// `SidebarMenu` — *"the menu owns one pill; the rows never paint themselves."*
///
/// §4: a group with an active option makes the selection **travel**, landing
/// with a jelly squash. The pill is `bg-secondary shadow-chip rounded-lg`, it
/// is `pointer-events-none` so it can never eat a click meant for the row under
/// it, and it is keyed on `data-active` rather than `data-state` — *"a row
/// wrapped in a CollapsibleTrigger carries `data-state="open"`, and a pill
/// watching that would chase disclosure instead of selection."*
///
/// **Why this is not [DsSlidingPillGroup].** That widget lays its options out
/// in a row and finds the pill's target **by index**, which is right for a
/// toggle group. `useSlidingIndicator` here is given a *selector*, and what it
/// finds is not a child of the menu but a button nested inside one: in the
/// submenu specimen the active list item is 149.5px tall and the pill lands on
/// its 37.5px button (measured). So the target is registered from below rather
/// than indexed from above. Every number and curve is the same token —
/// `slide-pill`'s 250ms `--ease-spring` travel, its 150ms `--ease-out` fade,
/// and [DsJelly] for the 600ms squash — so there is still one transcription of
/// each.
class DsSidebarMenu extends StatefulWidget {
  const DsSidebarMenu({super.key, required this.children});

  /// [DsSidebarMenuItem]s, usually.
  final List<Widget> children;

  /// `gap-1`.
  static double get gap => ds(1);

  @override
  State<DsSidebarMenu> createState() => _DsSidebarMenuState();
}

class _DsSidebarMenuState extends State<DsSidebarMenu>
    with SingleTickerProviderStateMixin {
  final GlobalKey _frameKey = GlobalKey();

  /// Every currently-active row's anchor key. `querySelector` takes the first
  /// match in document order; [_measure] takes the topmost, which is the same
  /// thing in a column and does not depend on build order.
  final List<GlobalKey> _active = <GlobalKey>[];

  Rect? _rect;
  Rect? _held;
  bool _placed = false;

  late final AnimationController _jelly = AnimationController(
    vsync: this,
    duration: DsDurations.animJelly,
  );

  @override
  void dispose() {
    _jelly.dispose();
    super.dispose();
  }

  /// Called from [DsSidebarMenuButton]'s own lifecycle — a plain list append,
  /// never a `setState`, because [_measure] runs after every frame anyway.
  void register(GlobalKey key) {
    if (!_active.contains(key)) _active.add(key);
  }

  void unregister(GlobalKey key) => _active.remove(key);

  void _measure() {
    if (!mounted) return;
    final RenderObject? frame = _frameKey.currentContext?.findRenderObject();
    if (frame is! RenderBox || !frame.hasSize) return;

    Rect? best;
    for (final GlobalKey key in _active) {
      final RenderObject? box = key.currentContext?.findRenderObject();
      if (box is! RenderBox || !box.hasSize) continue;
      final Rect rect =
          box.localToGlobal(Offset.zero, ancestor: frame) & box.size;
      if (best == null ||
          rect.top < best.top ||
          (rect.top == best.top && rect.left < best.left)) {
        best = rect;
      }
    }

    if (best == _rect) {
      _placed = _placed || _rect != null;
      return;
    }
    setState(() => _rect = best);
    if (best != null) _jelly.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
    _jelly.duration = dsAnimationDuration(context, DsDurations.animJelly);

    final DsThemeData theme = DsTheme.of(context);
    final Rect? target = _rect;
    if (target != null) _held = target;
    final Rect? rect = target ?? _held;
    final bool travels = _placed;

    final List<Widget> rows = <Widget>[];
    for (int i = 0; i < widget.children.length; i++) {
      if (i > 0) rows.add(SizedBox(height: DsSidebarMenu.gap));
      rows.add(widget.children[i]);
    }

    return _SidebarMenuScope(
      state: this,
      child: Stack(
        key: _frameKey,
        children: <Widget>[
          if (rect != null)
            AnimatedPositioned(
              duration: travels
                  ? dsAnimationDuration(context, DsDurations.base)
                  : Duration.zero,
              curve: DsCurves.spring,
              left: rect.left,
              top: rect.top,
              width: rect.width,
              height: rect.height,
              child: IgnorePointer(
                child: AnimatedOpacity(
                  opacity: target == null ? 0 : 1,
                  duration: travels
                      ? dsAnimationDuration(context, DsDurations.fast)
                      : Duration.zero,
                  curve: DsCurves.out,
                  child: AnimatedBuilder(
                    animation: _jelly,
                    builder: (BuildContext context, Widget? child) {
                      final Offset scale = DsJelly.scale.evaluate(_jelly);
                      return Transform.scale(
                        scaleX: scale.dx,
                        scaleY: scale.dy,
                        child: child,
                      );
                    },
                    // `sidebar-pill block size-full rounded-lg bg-secondary
                    //  shadow-chip` — *"a fill alone looks like a smudge, a
                    //  fill with an edge looks like a surface."*
                    child: DsMachineSurface(
                      spec: DsShadows.chip,
                      radius: BorderRadius.circular(DsRadii.lg),
                      fill: theme.secondary,
                      child: const SizedBox.expand(),
                    ),
                  ),
                ),
              ),
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: rows,
          ),
        ],
      ),
    );
  }
}

/// `SidebarMenuItem` — `group/menu-item relative`.
///
/// The item is what the badge and the action are positioned against, and what
/// tells the row whether to reserve their lane.
class DsSidebarMenuItem extends StatelessWidget {
  const DsSidebarMenuItem({
    super.key,
    required this.button,
    this.action,
    this.badge,
    this.submenu,
  });

  /// The row — a [DsSidebarMenuButton], or a trigger wrapping one.
  final Widget button;

  /// A [DsSidebarMenuAction], `absolute top-1/2 right-1`.
  final Widget? action;

  /// A [DsSidebarMenuBadge], `absolute top-1/2 right-2`.
  final Widget? badge;

  /// A [DsSidebarMenuSub], which is in flow **under** the row and makes the
  /// item taller than its own button.
  final Widget? submenu;

  @override
  Widget build(BuildContext context) {
    final bool icon = DsSidebarChrome.iconModeOf(context);
    final Widget flow = submenu == null
        ? button
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[button, submenu!],
          );

    return _SidebarMenuItemScope(
      hasAction: action != null,
      hasBadge: badge != null,
      child: Stack(
        children: <Widget>[
          flow,
          // `group-data-[collapsible=icon]:hidden` on both.
          if (badge != null && !icon)
            Positioned(
              right: ds(2),
              top: 0,
              bottom: 0,
              child: Center(child: badge),
            ),
          if (action != null && !icon)
            Positioned(
              right: ds(1),
              top: 0,
              bottom: 0,
              child: Center(child: action),
            ),
        ],
      ),
    );
  }
}

/// `SidebarMenuButton` — a nav row, and *"a row IS a Button"*.
///
/// Every `Button` variant is available, because *"a row that deposits funds
/// should be able to be the lime one; a row that deletes should be able to be
/// the destructive one."* The **default** is `ghost` rather than Button's own
/// `default`: *"a column of rows that each painted themselves `bg-primary`
/// would be a wall of blue with no hierarchy left to spend."*
///
/// Three things are the sidebar's and not Button's, and each has a reason in
/// the source:
///
///  * **`rounded-lg`, not the pill.** *"A sidebar is a COLUMN of them at full
///    width, and a 240px pill is a lozenge: the radius stops describing the
///    object and starts fighting the stack."*
///  * **`h-auto px-2 py-2`.** Button's paddings exist to clear a pill's curve;
///    *"a 12px corner needs nothing like that, and the width is better spent on
///    the label."*
///  * **The active row does not paint itself.** The menu's pill does (§4), so
///    all the row changes is its own colour and nothing reflows. Stock adds
///    `data-active:font-medium` beside a `text-sm`, which *"was also a layout
///    bug: the row reflowed by a pixel every time an item activated, because a
///    heavier label is a wider label."*
class DsSidebarMenuButton extends StatefulWidget {
  const DsSidebarMenuButton({
    super.key,
    required this.child,
    this.isActive = false,
    this.variant = DsButtonVariant.ghost,
    this.size = DsSidebarMenuButtonSize.md,
    this.tooltip,
    this.label,
    this.onPressed,
    this.expanded = false,
    this.suppressPressScale = false,
  });

  /// The row's content — normally a [DsSidebarMenuRow].
  final Widget child;

  final bool isActive;

  final DsButtonVariant variant;

  final DsSidebarMenuButtonSize size;

  /// `tooltip` — shown only once the panel has collapsed to a rail.
  final String? tooltip;

  /// `aria-label`, defaulting to [tooltip] as the reference's own
  /// `props["aria-label"] ?? tooltip` does.
  final String? label;

  final VoidCallback? onPressed;

  /// `aria-expanded`, for a row that is also a dropdown trigger.
  final bool expanded;

  /// `aria-haspopup`, same.
  final bool suppressPressScale;

  /// `px-2 py-2` — the row's own padding, before the badge/action clearance.
  static double get padding => ds(2);

  /// `pr-10` — the lane an action reserves.
  static double get actionLane => ds(10);

  /// `pr-16` — the wider lane a badge reserves.
  static double get badgeLane => ds(16);

  /// `group-data-[collapsible=icon]:size-8!` — the collapsed row is a hard
  /// 32px square, and it gets there in one frame (measured).
  static double get iconSize => ds(8);

  @override
  State<DsSidebarMenuButton> createState() => _DsSidebarMenuButtonState();
}

class _DsSidebarMenuButtonState extends State<DsSidebarMenuButton> {
  final GlobalKey _anchor = GlobalKey();
  _DsSidebarMenuState? _menu;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync(_SidebarMenuScope.maybeOf(context)?.state);
  }

  @override
  void didUpdateWidget(DsSidebarMenuButton old) {
    super.didUpdateWidget(old);
    if (old.isActive != widget.isActive) {
      _sync(_SidebarMenuScope.maybeOf(context)?.state);
    }
  }

  void _sync(_DsSidebarMenuState? menu) {
    if (!identical(menu, _menu)) {
      _menu?.unregister(_anchor);
      _menu = menu;
    }
    if (widget.isActive) {
      _menu?.register(_anchor);
    } else {
      _menu?.unregister(_anchor);
    }
  }

  @override
  void dispose() {
    _menu?.unregister(_anchor);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final bool icon = DsSidebarChrome.iconModeOf(context);
    final _SidebarMenuItemScope? item = _SidebarMenuItemScope.maybeOf(context);

    final double right = icon
        ? DsSidebarMenuButton.padding
        : item?.hasBadge ?? false
            ? DsSidebarMenuButton.badgeLane
            : item?.hasAction ?? false
                ? DsSidebarMenuButton.actionLane
                : DsSidebarMenuButton.padding;

    // `variant === "ghost" && group-data-[collapsible=icon]:hover:bg-transparent
    //  …:active:bg-transparent` — *"in icon mode the tooltip carries the hover
    //  feedback; painting the ghost surface as well turns a quiet sidebar glyph
    //  into a detached 32px boxed control."*
    //
    // `isActive && variant === "ghost"` — the row keeps only its colour, and
    // the hover cancel's POSITION is load-bearing: it comes after the variant
    // or tailwind-merge drops it.
    final bool ghost = widget.variant == DsButtonVariant.ghost;
    final DsButtonSurface? surface = !ghost
        ? null
        : icon
            ? const DsButtonSurface(
                fill: dsTransparent,
                hoverFill: dsTransparent,
              )
            : widget.isActive
                ? DsButtonSurface(
                    fill: dsTransparent,
                    hoverFill: dsTransparent,
                    ink: theme.sidebarAccentForeground,
                    hoverInk: theme.sidebarAccentForeground,
                  )
                : null;

    Widget button = DsButton(
      variant: widget.variant,
      size: widget.size.button,
      radius: BorderRadius.circular(DsRadii.lg),
      autoHeight: true,
      contentAlignment: icon
          ? Alignment.center
          : AlignmentDirectional.centerStart,
      padding: EdgeInsets.fromLTRB(
        DsSidebarMenuButton.padding,
        DsSidebarMenuButton.padding,
        right,
        DsSidebarMenuButton.padding,
      ),
      surface: surface,
      expanded: widget.expanded,
      suppressPressScale: widget.suppressPressScale,
      label: widget.label ?? widget.tooltip,
      onPressed: widget.onPressed ?? () {},
      child: widget.child,
    );

    if (icon) {
      // `size-8!` beats `h-auto`, and the group's own padding is what makes the
      // rendered box 31 × 32 rather than 32 × 32 (measured).
      button = SizedBox(
        height: DsSidebarMenuButton.iconSize,
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: DsSidebarMenuButton.iconSize),
          child: button,
        ),
      );
    }

    button = KeyedSubtree(key: _anchor, child: button);

    if (widget.tooltip == null) return button;

    final DsSidebarScope? scope = DsSidebarScope.maybeOf(context);
    return DsTooltip(
      label: widget.tooltip!,
      side: DsTooltipSide.right,
      // `hidden={state !== "collapsed" || isMobile}`.
      hidden: !(scope?.collapsed ?? false) || (scope?.isMobile ?? false),
      child: button,
    );
  }
}

/// The row's own flex line: a glyph, the rung's `gap-*`, and a label that
/// truncates.
///
/// `[&>span:last-child]:truncate`, and `group-data-[collapsible=icon]:[&>svg~span]:hidden`
/// — the label is the thing that goes when the panel does.
class DsSidebarMenuRow extends StatelessWidget {
  const DsSidebarMenuRow({
    super.key,
    required this.label,
    this.leading,
    this.trailing,
    this.size = DsSidebarMenuButtonSize.md,
  });

  /// The glyph, already sized by the caller from [DsButton.iconPxFor].
  final Widget? leading;

  /// The label span.
  final Widget label;

  /// Anything after it — the header rows' `ml-auto` chevron.
  final Widget? trailing;

  final DsSidebarMenuButtonSize size;

  @override
  Widget build(BuildContext context) {
    final bool icon = DsSidebarChrome.iconModeOf(context);
    final double gap = DsButton.gapFor(size.button);

    if (icon && leading != null) return leading!;

    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        if (leading != null) ...<Widget>[leading!, SizedBox(width: gap)],
        Expanded(child: label),
        if (trailing != null) ...<Widget>[SizedBox(width: gap), trailing!],
      ],
    );
  }
}

/// `<span>` — a row's label: one line, truncating, in a CSS line box.
///
/// `[&>span:last-child]:truncate` is the row's own rule, and the line box is
/// the port's standing text correction: `text-small` is 13px inheriting
/// Preflight's 1.5, so the browser lays the line out at exactly **19.5px**
/// while the engine rounds ascent and descent to whole pixels and produces 20.
/// A fixed-height button hides that; an `h-auto` row does not, and half a pixel
/// per row is 7.5px down a page of them. [DsLineBox] gives the paragraph its
/// CSS height back.
///
/// The style is read from the ambient [DefaultTextStyle] rather than passed:
/// what a row's label is typed as is the *rung's* business, and [DsButton] has
/// already resolved it by the time this builds.
class DsSidebarMenuLabel extends StatelessWidget {
  const DsSidebarMenuLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final TextStyle style = DefaultTextStyle.of(context).style;
    return DsLineBox(
      style: style,
      child: Text(
        text,
        style: style,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
      ),
    );
  }
}

/// `SidebarMenuAction` — a 24px `ghost` square centred in whichever row it
/// sits in.
///
/// *"Every offset is (row − 24) / 2 against the 24 / 32 / 48 ladder — 0, 4, 12
/// — so all three land on the scale by arithmetic rather than by rounding."*
/// `rounded-md`, not the pill.
class DsSidebarMenuAction extends StatelessWidget {
  const DsSidebarMenuAction({
    super.key,
    required this.child,
    required this.label,
    this.onPressed,
  });

  final Widget child;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => DsButton(
        variant: DsButtonVariant.ghost,
        size: DsButtonSize.iconXs,
        radius: BorderRadius.circular(DsRadii.md),
        label: label,
        onPressed: onPressed,
        child: child,
      );
}

/// `SidebarMenuBadge` — the count, in the row's right lane.
///
/// `h-5 min-w-5 px-1.5 select-none pointer-events-none`, typed
/// [DsComponentType.sidebarMenuBadge] (drift 1).
class DsSidebarMenuBadge extends StatelessWidget {
  const DsSidebarMenuBadge(
    this.count, {
    super.key,
    this.variant = DsBadgeVariant.secondary,
  });

  final String count;

  /// `variant = "secondary"` — the file's own default, not `Badge`'s.
  final DsBadgeVariant variant;

  /// `px-1.5`.
  static double get paddingX => ds(1.5);

  /// `min-w-5`.
  static double get minWidth => ds(5);

  @override
  Widget build(BuildContext context) => IgnorePointer(
        child: DsBadge(
          label: count,
          variant: variant,
          spec: DsComponentType.sidebarMenuBadge,
          paddingX: paddingX,
          minWidth: minWidth,
        ),
      );
}

/// `SidebarMenuSkeleton` — a 32px row of shimmer, at a varied width.
///
/// *"A varied width between 50% and 90%, so a column of skeleton rows reads as
/// text rather than as a stack of identical bars."* The reference hashes
/// `useId()` for it, so server and client agree; there is no hydration here, so
/// the port hashes a [seed] the call site supplies (drift 4).
class DsSidebarMenuSkeleton extends StatelessWidget {
  const DsSidebarMenuSkeleton({
    super.key,
    this.showIcon = false,
    this.seed = '',
  });

  final bool showIcon;

  /// Stands in for `useId()`. Same string, same width.
  final String seed;

  /// `h-8`.
  static double get height => ds(8);

  /// `(|hash| % 41) + 50`, as a fraction.
  static double widthFraction(String seed) {
    int hash = 0;
    for (int i = 0; i < seed.length; i++) {
      hash = (hash * _hashRadix + seed.codeUnitAt(i)).toSigned(32);
    }
    return ((hash.abs() % _hashSpread) + _hashFloor) / _percent;
  }

  static const int _hashRadix = 31;
  static const int _hashSpread = 41;
  static const int _hashFloor = 50;
  static const double _percent = 100;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: height,
        // `flex h-8 items-center gap-2 rounded-md px-2`.
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: ds(2)),
          child: Row(
            children: <Widget>[
              if (showIcon) ...<Widget>[
                DsSkeleton(
                  width: ds(4),
                  height: ds(4),
                  radius: DsRadii.md,
                ),
                SizedBox(width: ds(2)),
              ],
              // `h-4 max-w-(--skeleton-width) flex-1`.
              Expanded(
                child: FractionallySizedBox(
                  alignment: AlignmentDirectional.centerStart,
                  widthFactor: widthFraction(seed),
                  child: DsSkeleton(height: ds(4)),
                ),
              ),
            ],
          ),
        ),
      );
}

/// `SidebarMenuSub` — the nested list, hung off a spine.
///
/// `mx-4 translate-x-px border-l border-sidebar-border px-3 py-1 gap-1`, and
/// *"16 / 12 / 4 rather than stock's 14 / 10 / 2. `translate-x-px` stays: a 1px
/// nudge onto the border spine is a hairline, not spacing."*
class DsSidebarMenuSub extends StatelessWidget {
  const DsSidebarMenuSub({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    if (DsSidebarChrome.iconModeOf(context)) return const SizedBox.shrink();

    return Padding(
      // `mx-4` plus the `translate-x-px` nudge, which lands as one number here
      // because the two are the same axis and a transform that only ever moves
      // a border onto its own hairline has no other observable effect.
      padding: EdgeInsets.only(left: ds(4) + DsWidths.hairline, right: ds(4)),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: theme.sidebarBorder,
              width: DsWidths.hairline,
            ),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: ds(3) - DsWidths.hairline,
            right: ds(3),
            top: ds(1),
            bottom: ds(1),
          ),
          child: _GappedColumn(gap: ds(1), children: children),
        ),
      ),
    );
  }
}

/// `SidebarMenuSubItem` — `group/menu-sub-item relative`.
class DsSidebarMenuSubItem extends StatelessWidget {
  const DsSidebarMenuSubItem({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}

/// `SidebarMenuSubButton` — a nested link.
///
/// *"Always `asChild`, because this part must stay an `<a>`"* — it takes an
/// href and is keyboard-reachable as a link. The port has no `asChild` (B4)
/// and no anchors, so what survives is the shape: a `ghost` button at
/// `rounded-lg px-3`, whose active state is a colour and nothing else.
class DsSidebarMenuSubButton extends StatelessWidget {
  const DsSidebarMenuSubButton({
    super.key,
    required this.label,
    this.isActive = false,
    this.variant = DsButtonVariant.ghost,
    this.size = DsSidebarMenuSubButtonSize.md,
    this.onPressed,
  });

  final String label;
  final bool isActive;
  final DsButtonVariant variant;
  final DsSidebarMenuSubButtonSize size;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    if (DsSidebarChrome.iconModeOf(context)) return const SizedBox.shrink();

    final bool ghost = variant == DsButtonVariant.ghost;
    return DsButton(
      variant: variant,
      size: size.button,
      radius: BorderRadius.circular(DsRadii.lg),
      contentAlignment: AlignmentDirectional.centerStart,
      // `px-3`.
      padding: EdgeInsets.symmetric(horizontal: ds(3)),
      surface: isActive && ghost
          ? DsButtonSurface(
              fill: dsTransparent,
              hoverFill: dsTransparent,
              ink: theme.sidebarAccentForeground,
              hoverInk: theme.sidebarAccentForeground,
            )
          : null,
      onPressed: onPressed ?? () {},
      child: DsSidebarMenuLabel(label),
    );
  }
}

/// `SidebarInput` — `Input` at `h-8 w-full bg-background shadow-none`.
class DsSidebarInput extends StatelessWidget {
  const DsSidebarInput({
    super.key,
    this.placeholder,
    this.label,
    this.controller,
    this.padding,
  });

  final String? placeholder;

  /// The field's accessible name — `aria-label`, or the `sr-only` `Label` the
  /// search-form pattern puts in front of it.
  final String? label;

  final TextEditingController? controller;

  /// Overrides `px-4 py-1` — the search form's `pl-8`, which clears its glyph.
  final EdgeInsetsGeometry? padding;

  /// `h-8`.
  static double get height => ds(8);

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return DsInput(
      controller: controller,
      placeholder: placeholder,
      label: label,
      padding: padding,
      boxHeight: height,
      fill: theme.background,
      flat: true,
    );
  }
}

/* ── Shared bits ─────────────────────────────────────────────────────────── */

/// A `flex-col` with a `gap-*` between its children.
class _GappedColumn extends StatelessWidget {
  const _GappedColumn({required this.gap, required this.children});

  final double gap;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final List<Widget> rows = <Widget>[];
    for (int i = 0; i < children.length; i++) {
      if (i > 0) rows.add(SizedBox(height: gap));
      rows.add(children[i]);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: rows,
    );
  }
}
