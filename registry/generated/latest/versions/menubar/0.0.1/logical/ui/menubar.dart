/// `components/ui/menubar.tsx` — a strip of triggers that pass one open menu
/// between them.
///
/// | part | class | value |
/// |---|---|---|
/// | root | `flex h-8 items-center gap-0.5 rounded-lg border p-1` | 32 tall, 2px between triggers, 12px radius, a 1px `--border`, 4px of inset |
/// | trigger | `flex items-center rounded-md h-8 px-3 text-sm font-medium` | **32 tall**, 12px each side, 13px/500, 10px radius |
/// | | `hover:bg-muted aria-expanded:bg-muted` | one fill for both states — *(measured: `--muted` in both themes, and `transition-duration: 0s`, so it **snaps**)* |
/// | content | `min-w-36 … data-open:animate-in` | 144, `align="start" alignOffset={-4} sideOffset={8}` |
///
/// DOCUMENTED DRIFT (menus drift 1): **the triggers overflow the bar they sit
/// in.** The root is `h-8` with `p-1`, which leaves a 24px content box, and
/// each trigger is `h-8` — 32. *(Measured: the root's box is
/// `y=1531.63 h=32` and the first trigger's is `y=1531.63 h=32` — identical,
/// so the padding is spent entirely on overflow and the triggers' fills run
/// edge to edge over the bar's own border inset.)* Reproduced exactly: the
/// port lets the row overflow rather than clipping it, because the reference
/// writes no `overflow-hidden`.
///
/// DOCUMENTED DRIFT (menus drift 2): **`MenubarContent` has no exit
/// animation.** Its class list ends at `data-open:zoom-in-95`; the
/// `data-closed:animate-out data-closed:fade-out-0 data-closed:zoom-out-95`
/// trio that `DropdownMenuContent`, `ContextMenuContent` and its own
/// `MenubarSubContent` all carry is simply absent. *(Measured while switching
/// menus by hover: the outgoing content is gone on the frame the state flips
/// and the incoming one animates in from `opacity 0` over 320ms.)*
/// [ElPopover.animateOut] false is that missing twin.
///
/// The page's own copy calls this *"Not used in the collector-facing product…
/// here because the admin surface will need it"*, which is why the whole
/// section is one specimen with no state matrix behind it.
library;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../foundation/spacing.dart';
import '../foundation/theme.dart';
import '../foundation/typography.dart';
import '../theme_scope.dart';
import 'menu.dart';
import 'popover.dart';

/// One `MenubarMenu` — a trigger's label and the rows it opens.
@immutable
class ElMenubarMenu {
  const ElMenubarMenu({required this.label, required this.children});

  /// `MenubarTrigger`'s text.
  final String label;

  /// `MenubarContent`'s children.
  final List<ElMenuChild> children;
}

/// A `Menubar`.
class ElMenubar extends StatefulWidget {
  const ElMenubar({super.key, required this.menus});

  final List<ElMenubarMenu> menus;

  /// `h-8` on the root — and on every trigger inside it. Drift 1.
  static double get height => el(8);

  /// `p-1`.
  static double get padding => el(1);

  /// `gap-0.5` — 2px.
  static double get gap => el(0.5);

  /// `px-3` on a trigger.
  static double get triggerPaddingX => el(3);

  /// `sideOffset={8}`.
  static double get sideOffset => el(2);

  /// `alignOffset={-4}` — the content starts 4px **left** of its trigger, so
  /// its inner padding lines up with the trigger's text rather than its box.
  static double get alignOffset => -el(1);

  @override
  State<ElMenubar> createState() => _ElMenubarState();
}

class _ElMenubarState extends State<ElMenubar> {
  /// Which menu is open, or null.
  int? _open;

  void _close() {
    if (_open == null) return;
    setState(() => _open = null);
  }

  void _toggle(int index) =>
      setState(() => _open = _open == index ? null : index);

  /// *(Measured: `pointerover` on a sibling trigger at t=167.3, both
  /// `data-state` attributes flipped by t=168.5.)* Hovering a sibling while a
  /// menu is open switches instantly — no intent delay, no close animation.
  void _hover(int index) {
    if (_open == null || _open == index) return;
    setState(() => _open = index);
  }

  /// `ArrowLeft` / `ArrowRight` on the strip — measured moving from "Users" to
  /// "Wallet" with the content following.
  void _step(int delta) {
    final int? open = _open;
    if (open == null) return;
    final int count = widget.menus.length;
    setState(() => _open = (open + delta + count) % count);
  }

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);

    return Focus(
      canRequestFocus: false,
      skipTraversal: true,
      // The open content is a descendant in the element tree (its portal keeps
      // it there), so the keys it does not handle arrive here.
      onKeyEvent: (FocusNode node, KeyEvent event) {
        if (event is! KeyDownEvent || _open == null) {
          return KeyEventResult.ignored;
        }
        if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
          _step(1);
        } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
          _step(-1);
        } else {
          return KeyEventResult.ignored;
        }
        return KeyEventResult.handled;
      },
      child: Container(
        height: ElMenubar.height,
        padding: EdgeInsets.all(ElMenubar.padding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ElRadii.lg),
          border: Border.all(color: theme.border, width: ElWidths.hairline),
        ),
        // `items-center` on a row whose children are taller than it is: the
        // 32px triggers stay 32px and hang 4px out of the 24px content box at
        // each end. Drift 1, reproduced rather than clipped.
        child: OverflowBox(
          alignment: AlignmentDirectional.centerStart,
          maxHeight: ElMenubar.height,
          minHeight: ElMenubar.height,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              for (int i = 0; i < widget.menus.length; i++) ...<Widget>[
                if (i > 0) SizedBox(width: ElMenubar.gap),
                _MenubarTrigger(
                  menu: widget.menus[i],
                  open: _open == i,
                  onPointerDown: () => _toggle(i),
                  onHover: () => _hover(i),
                  onClose: _close,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// `MenubarTrigger` + the `MenubarContent` it opens.
class _MenubarTrigger extends StatefulWidget {
  const _MenubarTrigger({
    required this.menu,
    required this.open,
    required this.onPointerDown,
    required this.onHover,
    required this.onClose,
  });

  final ElMenubarMenu menu;
  final bool open;
  final VoidCallback onPointerDown;
  final VoidCallback onHover;
  final VoidCallback onClose;

  @override
  State<_MenubarTrigger> createState() => _MenubarTriggerState();
}

class _MenubarTriggerState extends State<_MenubarTrigger> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    // `hover:bg-muted aria-expanded:bg-muted` — one fill, two states, and it
    // does not transition.
    final bool lit = _hovered || widget.open;

    final Widget trigger = DecoratedBox(
      decoration: BoxDecoration(
        color: lit ? theme.muted : null,
        borderRadius: BorderRadius.circular(ElRadii.md),
      ),
      child: SizedBox(
        height: ElMenubar.height,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: ElMenubar.triggerPaddingX),
          child: Center(
            widthFactor: 1,
            child: ElText(
              widget.menu.label,
              // `text-sm font-medium` — 13px / 500, which is the button label
              // rung and not a spec of its own.
              ElComponentType.buttonLabel,
              color: theme.foreground,
              maxLines: 1,
              softWrap: false,
            ),
          ),
        ),
      ),
    );

    return ElPopover(
      open: widget.open,
      side: ElPopoverSide.bottom,
      align: ElPopoverAlign.start,
      sideOffset: ElMenubar.sideOffset,
      origin: ElPopoverOriginModel.corner,
      slideSides: ElMenuMotion.slideSides,
      // Drift 2 — the one content in the family with no `animate-out`.
      animateOut: false,
      // `modal={false}` — Radix's menubar is non-modal, which is the whole
      // reason a sibling trigger can be hovered while a menu is open.
      barrier: ElPopoverBarrier.nonModal,
      onDismiss: widget.onClose,
      anchor: ElMenuPointerDown(
        onPointerDown: widget.onPointerDown,
        child: MouseRegion(
          // `select-none` and `cursor-default`: this is not a link.
          cursor: SystemMouseCursors.basic,
          onEnter: (_) {
            setState(() => _hovered = true);
            widget.onHover();
          },
          onExit: (_) => setState(() => _hovered = false),
          child: SelectionContainer.disabled(child: trigger),
        ),
      ),
      content: (BuildContext context, ElPopoverAnchorMetrics metrics) =>
          // `alignOffset={-4}` — expressed as a translate on the content
          // because it is a nudge along the align axis, which is what the prop
          // is: [ElPopover] places the leading edges flush and this moves them.
          Transform.translate(
            offset: Offset(ElMenubar.alignOffset, 0),
            child: ElMenuContent(
              children: widget.menu.children,
              minWidth: ElMenu.minWidthMenu,
              // Drift 5 — the menubar is the one file that puts a check row's
              // indicator on the leading edge.
              indicatorSide: ElMenuIndicatorSide.start,
              onClose: widget.onClose,
            ),
          ),
    );
  }
}
