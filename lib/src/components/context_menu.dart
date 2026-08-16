/// `components/ui/context-menu.tsx` — the same menu, opened by a right-click,
/// anchored to the pointer.
///
/// `ContextMenuTrigger` is `select-none` and nothing else; the whole component
/// is *where* the menu goes. Radix builds a **virtual element** from the
/// `contextmenu` event's client coordinates and positions the content against
/// it at `side="right" sideOffset={2} align="start"` — which is why a
/// right-click menu opens at the cursor with its top-left corner 2px to the
/// right of it, whatever was right-clicked.
///
/// *(Measured 2026-08-16: the card was right-clicked at (485, 498.44) and the
/// content landed at (487, 498) — `dx = 2`, `dy = −0.44`, `data-side="right"`,
/// `data-align="start"`, `--radix-context-menu-content-transform-origin:
/// 0px 0%`.)* [DsPopover.anchorPoint] is that virtual element.
///
/// *(Also probed: a **left**-click on the trigger opens nothing.)* The
/// reference has no long-press or keyboard route either — `ContextMenuTrigger`
/// listens for `contextmenu` and for a long-press on touch, and the page's own
/// Don't 1 is about exactly that hole: *"Don't make a right-click menu the only
/// path to an action — touch users cannot reach it."*
///
/// DOCUMENTED DRIFT (menus drift 4): `ContextMenuSubContent` is the **one**
/// overlay in the corpus that writes `border` instead of `ring-1
/// ring-foreground/10` — a real 1px line that costs its box 2px. *(Measured: a
/// submenu holding two 34.5625 rows is 87.125 tall.)* Its two siblings in the
/// other files write the ring, at the same `shadow-lg`.
library;

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import '../foundation/spacing.dart';
import 'menu.dart';
import 'popover.dart';

/// A `ContextMenu` — right-click [child] and [children] opens at the pointer.
class DsContextMenu extends StatefulWidget {
  const DsContextMenu({
    super.key,
    required this.child,
    required this.children,
    this.width,
    this.enabled = true,
  });

  /// `ContextMenuTrigger`'s content — `select-none`, and otherwise exactly as
  /// authored.
  final Widget child;

  /// `ContextMenuContent`'s children.
  final List<DsMenuChild> children;

  /// A `w-*` on the content — `w-56` on the page's only instance.
  final double? width;

  final bool enabled;

  /// `sideOffset={2}` — Radix's own default for a context menu, and **not** a
  /// spacing-ladder value. Two pixels: half a unit.
  static double get sideOffset => ds(0.5);

  @override
  State<DsContextMenu> createState() => _DsContextMenuState();
}

class _DsContextMenuState extends State<DsContextMenu> {
  /// Where the right-click landed, in global coordinates. Null while closed.
  Offset? _at;

  void _close() {
    if (_at == null) return;
    setState(() => _at = null);
  }

  void _openAt(Offset global) {
    if (!widget.enabled) return;
    setState(() => _at = global);
  }

  @override
  Widget build(BuildContext context) {
    return DsPopover(
      open: _at != null,
      anchorPoint: _at,
      // Radix's `ContextMenuContent` fixes all three; the file passes none of
      // them through, so they are constants here too.
      side: DsPopoverSide.right,
      align: DsPopoverAlign.start,
      sideOffset: DsContextMenu.sideOffset,
      origin: DsPopoverOriginModel.corner,
      slideSides: DsMenuMotion.slideSides,
      onDismiss: _close,
      anchor: Listener(
        // A secondary-button press. `onSecondaryTapDown` would work for a
        // mouse and miss the trackpad's two-finger press, which arrives as a
        // pointer with `kSecondaryButton` set and no separate tap gesture.
        onPointerDown: (PointerDownEvent event) {
          if (event.buttons & kSecondaryButton == 0) return;
          _openAt(event.position);
        },
        // `select-none` — a right-click drag over the card must not start a
        // selection. Inert until a [SelectionArea] is above it, which is
        // exactly when the CSS rule starts mattering too.
        child: SelectionContainer.disabled(child: widget.child),
      ),
      content: (BuildContext context, DsPopoverAnchorMetrics metrics) =>
          DsMenuContent(
        children: widget.children,
        width: widget.width,
        minWidth: DsMenu.minWidthMenu,
        onClose: _close,
      ),
    );
  }
}
