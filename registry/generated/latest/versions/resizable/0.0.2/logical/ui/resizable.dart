/// `components/ui/resizable.tsx` — three wrappers over
/// `react-resizable-panels@4.12.2`.
///
/// ```tsx
/// <ResizablePrimitive.Group  className="flex h-full w-full aria-[orientation=vertical]:flex-col" />
/// <ResizablePrimitive.Panel />
/// <ResizablePrimitive.Separator className="relative flex w-px items-center justify-center bg-border … after:absolute after:inset-y-0 after:left-1/2 after:w-1 after:-translate-x-1/2 …">
///   {withHandle && <div className="z-10 flex h-6 w-1 shrink-0 rounded-lg bg-border" />}
/// </ResizablePrimitive.Separator>
/// ```
///
/// ## What the probe found (`scratchpad/bl-resize.js`)
///
///  1. **The 1px line has a 4px grab zone, and the grip is exactly that wide.**
///     `after:w-1 after:left-1/2 after:-translate-x-1/2` puts a 4px
///     pseudo-element 1.5px each side of the hairline; `elementFromPoint`
///     across the seam answers the handle from x = 735 to x = 739 for a handle
///     whose own box is [736.8, 737.8]. The `withHandle` grip is `h-6 w-1` —
///     4 × 24, `rounded-lg`, `bg-border`, `z-10` — i.e. the same 4px, made
///     visible for 24px of the seam's height. [handleHit], [gripSize].
///     **The port no longer drags off that 4px** — see [handleGrab] and the
///     divergence note below.
///  2. **`minSize={25}` is 25 *pixels*.** Dragged hard left, the first panel
///     stops at 25.0px and the separator reports `aria-valuemin="2.434"`,
///     which is 25 ÷ 1027. `defaultSize={40}` and `{60}` meanwhile land on
///     40% / 60% — because v4 writes them straight into `flex-grow`
///     (`flex: 40 1 0px`), where only their ratio survives. So the two props
///     on the same component are read in two different units, and the one
///     that looks like a percentage is the one that is not. Reproduced:
///     [ResizablePanel.defaultSize] is a weight, [ResizablePanel.minSize]
///     is pixels.
///  3. **The second panel has no floor.** It carries no `minSize`, so `End` on
///     the separator takes it to 0 and the first panel to the full 1027.
///  4. **The drag is live and 1:1** — sampled every frame at exactly the
///     pointer's delta, no easing, no commit-on-release.
///  5. **The keyboard step is 5 percentage points**, `Home` goes to the
///     minimum and `End` to the maximum: measured 90.068 → 85.068 → 80.068 →
///     85.068 → 2.434 → 100. [keyboardStep].
///  6. **There is no resize cursor at rest.** `getComputedStyle(handle).cursor`
///     is `auto`; the library only swaps the cursor globally while a drag is in
///     flight. The port matches at rest and sets [SystemMouseCursors.resizeLeftRight]
///     over the grab zone, which is the drag affordance the reference gets from
///     its own global stylesheet.
///
/// ## USER-ORDERED DIVERGENCE — the grab strip is 24px, not the measured 4
///
/// The reference is a mouse-only document: `after:w-1` is a 4px target, which a
/// cursor hits and a fingertip does not (the platform guidance both stores
/// publish is 44/48px, and 4px is under a tenth of it). **On the user's order**
/// the drag strip widens to [handleGrab] — 24px, centred on the same hairline,
/// so it reaches 11.5px into each neighbouring panel instead of 1.5px.
///
/// What does **not** move, and the reason this is a hit-area change and not a
/// visual one:
///
///  * the seam is still `_handleWidth` — one hairline of `--border`;
///  * the grip is still [gripSize] — 4 × 24, exactly the reference's box;
///  * [handleHit] still states the measured 4px, so the number the probe found
///    stays in the file rather than being overwritten by the one that ships.
///
/// The strip is invisible either way — it paints nothing, it only answers — so
/// the rendered pixels are unchanged and only `elementFromPoint` would tell the
/// two apart. Pinned by the two hit tests in `test/layout_test.dart` and
/// `example/test/layout_page_test.dart`, which now walk out to the new edge and
/// past it.
library;

import 'package:flutter/gestures.dart' show DragStartBehavior;
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

import '../../design_system/foundation/spacing.dart';
import '../../design_system/foundation/theme.dart';
import '../../design_system/foundation/theme_scope.dart';

/// `w-px` — the seam itself.
const double _handleWidth = BorderWidths.hairline;

/// `after:w-1` — the 4px pseudo-element that answers the pointer **on the
/// reference**.
///
/// Kept as the measurement it is. What the port actually hit-tests is
/// [handleGrab]; see the library note's divergence section.
double get handleHit => space(1);

/// The width the port's drag strip really is: **24px**, centred on the same
/// hairline the reference centres its 4px on.
///
/// A user-ordered divergence for touch — the library note carries the whole
/// reasoning. 24 is `space(6)`, the same rung the grip is 24 *tall* at, so the
/// strip is a square around the visible grip rather than a number of its own.
double get handleGrab => space(6);

/// `h-6 w-1` — the visible grip, when `withHandle` is set. Unchanged by the
/// [handleGrab] divergence: the hit area widened, the paint did not.
Size get gripSize => Size(space(1), space(6));

/// Arrow keys move the separator by five percentage points.
const double keyboardStep = 5;

/// The [FocusNode.debugLabel] the separator carries, so `tabIndex={0}` can be
/// exercised without a tab order to walk to it through.
const String resizableHandleFocusLabel = 'ResizableHandle';

/// One panel's declaration.
class ResizablePanel {
  const ResizablePanel({
    required this.defaultSize,
    this.minSize = 0,
    required this.child,
  });

  /// `defaultSize` — a **flex-grow weight**, not a percentage. Only the ratio
  /// between the panels in a group survives; see the library note.
  final double defaultSize;

  /// `minSize` — in **pixels**, which is what the library measured out at.
  final double minSize;

  final Widget child;
}

/// `<ResizablePanelGroup>` with `<ResizableHandle withHandle />` between every
/// pair.
class ResizablePanelGroup extends StatefulWidget {
  const ResizablePanelGroup({
    super.key,
    required this.panels,
    this.withHandle = true,
    this.minHeight,
  });

  final List<ResizablePanel> panels;

  /// `withHandle` — draws the 4 × 24 grip on the seam.
  final bool withHandle;

  /// `min-h-56` on the page's group.
  final double? minHeight;

  @override
  State<ResizablePanelGroup> createState() => _ResizablePanelGroupState();
}

class _ResizablePanelGroupState extends State<ResizablePanelGroup> {
  /// Percentages, summing to 100 — the shape `flex-grow` collapses the
  /// declared weights into on the first layout, and the shape the library
  /// itself switches to after the first drag (`flex: 54.606 1 0px`).
  late final List<double> _weights = _normalised();

  List<double> _normalised() {
    final double total = widget.panels.fold(
      0,
      (double a, ResizablePanel p) => a + p.defaultSize,
    );
    if (total <= 0) {
      return List<double>.filled(
        widget.panels.length,
        100 / widget.panels.length,
      );
    }
    return <double>[
      for (final ResizablePanel p in widget.panels) p.defaultSize / total * 100,
    ];
  }

  /// The width the panels share: the group's inner width less every seam.
  double _panelSpace(double inner) =>
      inner - _handleWidth * (widget.panels.length - 1);

  /// Moves [deltaPx] from the panel after seam [seam] to the one before it.
  void _resize(int seam, double deltaPx, double space) {
    if (space <= 0) return;
    setState(() {
      final double before = _weights[seam] / 100 * space;
      final double after = _weights[seam + 1] / 100 * space;
      final double minBefore = widget.panels[seam].minSize;
      final double minAfter = widget.panels[seam + 1].minSize;
      final double moved = deltaPx.clamp(
        -(before - minBefore),
        after - minAfter,
      );
      _weights[seam] = (before + moved) / space * 100;
      _weights[seam + 1] = (after - moved) / space * 100;
    });
  }

  void _setBefore(int seam, double px, double space) {
    final double current = _weights[seam] / 100 * space;
    _resize(seam, px - current, space);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double inner = constraints.maxWidth;
        final double space = _panelSpace(inner);

        final List<Widget> row = <Widget>[];
        final List<double> seams = <double>[];
        double x = 0;
        for (int i = 0; i < widget.panels.length; i++) {
          final double width = _weights[i] / 100 * space;
          row.add(SizedBox(width: width, child: widget.panels[i].child));
          x += width;
          if (i < widget.panels.length - 1) {
            row.add(_Seam(colour: theme.border, withHandle: widget.withHandle));
            seams.add(x);
            x += _handleWidth;
          }
        }

        return ConstrainedBox(
          constraints: BoxConstraints(minHeight: widget.minHeight ?? 0),
          child: IntrinsicHeight(
            child: Stack(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: row,
                ),
                // `after:absolute after:inset-y-0 after:left-1/2 after:w-1
                // after:-translate-x-1/2` — the grab zone, laid out here
                // rather than inside the 1px seam. Widened from the measured
                // 4px to [handleGrab]'s 24 on the user's order; see the
                // library note.
                //
                // **This is the hit-area precedent, avoided rather than
                // paid.** A `Positioned` child that hangs 1.5px out of a 1px
                // `Stack` is painted but never hit: Flutter bounds-checks
                // every ancestor before it asks a child, so the strip would
                // answer only across the hairline it straddles. Hoisting it
                // to the group's own stack puts it inside a box that contains
                // it, and — because a `Stack` hit-tests in reverse paint
                // order — ahead of both neighbouring panels.
                for (int i = 0; i < seams.length; i++)
                  Positioned(
                    left: seams[i] - (handleGrab - _handleWidth) / 2,
                    top: 0,
                    bottom: 0,
                    width: handleGrab,
                    child: _GrabStrip(
                      onDrag: (double dx) => _resize(i, dx, space),
                      onKey: (double sign) {
                        if (sign == 0) {
                          _setBefore(i, widget.panels[i].minSize, space);
                        } else if (sign.isInfinite) {
                          _setBefore(
                            i,
                            space - widget.panels[i + 1].minSize,
                            space,
                          );
                        } else {
                          _resize(i, sign * keyboardStep / 100 * space, space);
                        }
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// `<ResizableHandle>`'s visible half: the `w-px bg-border` seam and the
/// optional `h-6 w-1` grip.
///
/// The grip is 4px wide against a 1px seam, so it overhangs by 1.5px on each
/// side exactly as the `after:` pseudo-element does — [Clip.none] keeps that
/// overhang painted.
class _Seam extends StatelessWidget {
  const _Seam({required this.colour, required this.withHandle});

  final Color colour;
  final bool withHandle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _handleWidth,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: <Widget>[
          Positioned.fill(child: ColoredBox(color: colour)),
          if (withHandle)
            // `z-10 flex h-6 w-1 shrink-0 rounded-lg bg-border`.
            SizedBox(
              width: gripSize.width,
              height: gripSize.height,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: colour,
                  borderRadius: BorderRadius.circular(Radii.lg),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// `<ResizableHandle>`'s interactive half: `role="separator" tabIndex={0}`,
/// the pointer target ([handleGrab] wide, not the reference's 4), and the
/// arrow/Home/End keys.
class _GrabStrip extends StatefulWidget {
  const _GrabStrip({required this.onDrag, required this.onKey});

  final void Function(double dx) onDrag;

  /// `-1` / `+1` for the arrows, `0` for Home, [double.infinity] for End.
  final void Function(double sign) onKey;

  @override
  State<_GrabStrip> createState() => _GrabStripState();
}

class _GrabStripState extends State<_GrabStrip> {
  /// Labelled so a test can reach `tabIndex={0}` without a tab order to walk:
  /// the strip paints nothing and nothing else on the page points at it.
  final FocusNode _focus = FocusNode(debugLabel: resizableHandleFocusLabel);

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowLeft:
        widget.onKey(-1);
      case LogicalKeyboardKey.arrowRight:
        widget.onKey(1);
      case LogicalKeyboardKey.home:
        widget.onKey(0);
      case LogicalKeyboardKey.end:
        widget.onKey(double.infinity);
      default:
        return KeyEventResult.ignored;
    }
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: 'Resize',
      child: Focus(
        focusNode: _focus,
        onKeyEvent: _onKey,
        child: MouseRegion(
          cursor: SystemMouseCursors.resizeLeftRight,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            // The library moves the panels off raw pointer deltas with no
            // slop of any kind, so the first pixel of travel has to count.
            dragStartBehavior: DragStartBehavior.down,
            onHorizontalDragUpdate: (DragUpdateDetails d) =>
                widget.onDrag(d.delta.dx),
            child: const SizedBox.expand(),
          ),
        ),
      ),
    );
  }
}
