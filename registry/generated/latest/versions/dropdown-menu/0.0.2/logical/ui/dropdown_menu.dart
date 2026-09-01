/// `components/ui/dropdown-menu.tsx` — a button that opens a menu under
/// itself.
///
/// The root is thin on purpose: everything a `DropdownMenu` renders below its
/// trigger is `menu.dart`, and everything about *where* it renders is
/// [Popover]. What is left here is the trigger contract and the four numbers
/// `DropdownMenuContent` writes on top of the shared class list.
///
/// | prop | class | value |
/// |---|---|---|
/// | `align` | `align="start"` — the file's own default | leading edges flush |
/// | `sideOffset` | `sideOffset={4}` | 4px under the trigger *(measured: the content lands 3.86 under a trigger whose bottom is at 579.14, Radix rounding the wrapper's translate to whole pixels)* |
/// | `min-w-40` | | 160 — the widest floor in the family |
/// | `max-h-(--radix-…-available-height)` | | capped at the room the chosen side leaves, which is what [Popover] already constrains its child to |
///
/// ## The trigger is `asChild`, and that used to cost two things
///
/// The page writes `<DropdownMenuTrigger asChild><Button variant="ghost">`, so
/// the trigger's props land on a real `Button` and **the button's own class
/// list resolves against them**. Two of those resolutions had no spelling on
/// this side, and both are named here because a reader will come looking:
///
/// GAP CLOSED 1 — **the press scale.** `DropdownMenuTrigger` stamps
/// `aria-haspopup="menu"` *(probed on all three triggers)*, which cancels
/// `active:not-aria-[haspopup]:scale-95`, so **no menu trigger on the
/// reference squishes**. It is exactly selects-map drift 20, one component
/// over. [Button] carried no flag for it while `button.dart` belonged to
/// another wave; it carries [Button.suppressPressScale] now, every trigger
/// passes it, and [DropdownMenu.pressScaleSuppressed] pins that it does.
///
/// GAP CLOSED 2 — **the open fill.** `ghost` resolves
/// `aria-expanded:bg-secondary aria-expanded:text-foreground` and `outline`
/// resolves `aria-expanded:bg-muted`, which are **the same colours those two
/// variants already paint on hover** *(measured in both themes: ghost open is
/// `--secondary` over `--foreground`, ghost hover is the same pair)*. The port
/// therefore rendered the open state correctly for as long as the pointer sat
/// on the trigger and dropped it in the one case the reference holds it —
/// pointer moved away while the menu stays open. [MenuTriggerScope] publishes
/// the open flag and [Button.expanded] resolves it, so the fill is now held
/// for exactly as long as the menu is.
///
/// Neither was worked around: a hand-rolled ghost button in this file would
/// have been a second button, which is the thing the port does not do.
library;

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

import '../../design_system/foundation/spacing.dart';
import './button.dart';
import './menu.dart';
import './popover.dart';

/// `asChild`, running in the one direction Flutter can run it.
///
/// `DropdownMenuTrigger` merges its own attributes — `aria-haspopup`,
/// `aria-expanded` — **into** the element the call site authored. A Flutter
/// parent cannot reach into a [Widget] it was handed and set a field on it, so
/// the state travels the other way: the trigger publishes what it knows and
/// the button reads it. That is what React context is for, and it is what
/// [InheritedWidget] is.
///
/// Only the *dynamic* half needs this. `aria-haspopup` never changes, so a
/// call site passes [Button.suppressPressScale] itself; `aria-expanded`
/// changes with a menu the call site does not own, so it comes from here.
class MenuTriggerScope extends InheritedWidget {
  const MenuTriggerScope({super.key, required this.open, required super.child});

  /// `aria-expanded` on the trigger — whether the menu under it is open.
  final bool open;

  /// The nearest enclosing trigger's open state.
  ///
  /// False outside one, which is what a `Button` carrying no `aria-expanded`
  /// at all resolves to — so a trigger widget can read this unconditionally
  /// and still render correctly when it is mounted on its own.
  static bool openOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<MenuTriggerScope>()?.open ??
      false;

  @override
  bool updateShouldNotify(MenuTriggerScope oldWidget) => oldWidget.open != open;
}

/// A `DropdownMenu` — [trigger], and [children] under it.
///
/// Open state is a prop, the way [Popover]'s is and the way Radix's `open`
/// is: the caller owns the boolean. [DropdownMenu] is the *uncontrolled*
/// spelling — it owns the boolean itself, because every instance on the menus
/// page is uncontrolled and a caller that wants control can drive [Popover]
/// and [MenuContent] directly, which is what this widget is.
class DropdownMenu extends StatefulWidget {
  const DropdownMenu({
    super.key,
    required this.trigger,
    required this.children,
    this.width,
    this.align = PopoverAlign.start,
    this.side = PopoverSide.bottom,
    this.enabled = true,
  });

  /// `DropdownMenuTrigger asChild` — the caller's own control, rendered as
  /// authored. It is measured, and it is opened on **pointer-down**: see
  /// [MenuPointerDown].
  final Widget trigger;

  /// `DropdownMenuContent`'s children.
  final List<MenuChild> children;

  /// A `w-*` on the content — `w-60` and `w-52` on the page's two menus.
  /// Null falls back to `min-w-40`, and to the drift that comes with it
  /// ([MenuContent.minWidth]).
  final double? width;

  /// `align` — the file's default is `"start"`, not Radix's `"center"`.
  final PopoverAlign align;

  /// `side` — Radix's own default is `"bottom"` and the menus page never
  /// changes it, so that is this widget's default too.
  ///
  /// The sidebar is where it moves: a menu opened from a 256px panel has no
  /// room under it and every trigger in that family asks for `side="right"`
  /// (`NavUser` conditionally, `side={isMobile ? "bottom" : "right"}`). The
  /// placement itself is [Popover]'s, collision flip included; all this does
  /// is stop hard-coding one value of it.
  final PopoverSide side;

  final bool enabled;

  /// `sideOffset={4}` — one spacing unit.
  static double get sideOffset => space(1);

  /// GAP CLOSED 1, named so a reader can find it and a test can pin it: the
  /// reference's menu triggers do **not** take the press scale, and neither do
  /// the port's. True, as it is on [DatePicker] — the same attribute, one
  /// component over.
  static const bool _pressScaleSuppressed = true;

  /// Whether the port suppresses the trigger's press scale the way
  /// `aria-haspopup` does on the reference. Always true — see GAP CLOSED 1.
  ///
  /// It stays a property rather than becoming a comment because what it pins
  /// is a call-site fact: [DropdownMenu] cannot suppress anything itself, so
  /// this is only true for as long as every trigger keeps passing
  /// [Button.suppressPressScale].
  static bool get pressScaleSuppressed => _pressScaleSuppressed;

  @override
  State<DropdownMenu> createState() => _DropdownMenuState();
}

class _DropdownMenuState extends State<DropdownMenu> {
  bool _open = false;

  /// What both the popover and the trigger's `aria-expanded` read: a disabled
  /// menu is a closed one.
  bool get _isOpen => _open && widget.enabled;

  void _close() {
    if (!_open) return;
    setState(() => _open = false);
  }

  void _toggle() => setState(() => _open = !_open);

  @override
  Widget build(BuildContext context) {
    return Popover(
      open: _isOpen,
      side: widget.side,
      align: widget.align,
      sideOffset: DropdownMenu.sideOffset,
      origin: PopoverAnchorMode.corner,
      slideSides: MenuMotion.slideSides,
      onDismiss: _close,
      anchor: MenuPointerDown(
        enabled: widget.enabled,
        onPointerDown: _toggle,
        // GAP CLOSED 2 — `aria-expanded`, handed down to whatever the call
        // site authored.
        child: MenuTriggerScope(open: _isOpen, child: widget.trigger),
      ),
      content: (BuildContext context, PopoverAnchorMetrics metrics) =>
          MenuContent(
            children: widget.children,
            width: widget.width,
            minWidth: Menu.minWidthDropdown,
            onClose: _close,
          ),
    );
  }
}
