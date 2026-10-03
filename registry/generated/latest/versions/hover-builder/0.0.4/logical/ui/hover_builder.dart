/// The hover lift — the `lift` utility, `app/globals.css` L2318–2330.
///
/// ```css
/// @utility lift {
///   transition:
///     transform var(--duration-base) var(--ease-out),
///     box-shadow var(--duration-base) var(--ease-out),
///     border-color var(--duration-base) var(--ease-standard);
///   &:hover { transform: translateY(-3px); box-shadow: var(--shadow-e3); }
/// }
/// ```
///
/// Note the two easings: the card rises and gains its shadow on `--ease-out`,
/// but its border changes colour on `--ease-standard`. One shared controller,
/// two curves.
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

/// Reports pointer hover to [builder]. The consumer decides what hovering
/// looks like.
///
/// Kept deliberately dumb: `lift` is only ever the *trigger*: on an index card
/// it also slides an arrow and recolours it, and baking one appearance in
/// would put those in the wrong place. A caller that wants the click feel too
/// composes this with [Press] rather than reaching for a bespoke card widget.
class HoverBuilder extends StatefulWidget {
  const HoverBuilder({
    super.key,
    required this.builder,
    this.cursor = MouseCursor.defer,
  });

  final Widget Function(BuildContext context, bool hovered) builder;

  final MouseCursor cursor;

  @override
  State<HoverBuilder> createState() => _LiftState();
}

class _LiftState extends State<HoverBuilder> {
  bool _hovered = false;

  void _set(bool value) {
    if (_hovered == value) return;
    setState(() => _hovered = value);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.cursor,
      onEnter: (_) => _set(true),
      onExit: (_) => _set(false),
      child: widget.builder(context, _hovered),
    );
  }
}
