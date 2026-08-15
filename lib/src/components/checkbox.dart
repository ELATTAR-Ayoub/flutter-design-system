/// `components/ui/checkbox.tsx` — 20px, and the tick draws itself.
///
/// Its own docstring names the three things that put it beyond stock:
///
///  * **Bigger.** *"16px is a fiddly target and the tick inside it is
///    illegible."*
///  * **The tick is drawn, not faded.** *"A hand-authored path carries a dash
///    the length of itself; the offset animates to zero so the stroke writes
///    on. Lucide's icon cannot do this, so the path lives here."*
///  * **The box squashes on every toggle**, both directions, through
///    `useReplayOnStateChange` — [DsJellyReplay].
///
/// Every class, resolved (forms-map §8.1–8.3):
///
/// | class | value |
/// |---|---|
/// | `size-5` | 20 × 20 |
/// | `rounded-sm` | 6px |
/// | `border border-input` | 1px |
/// | `bg-card` → `data-[state=checked]:bg-primary` | — |
/// | `shadow-pressed` → `data-[state=checked]:shadow-btn-primary` | the socket lights and casts blue beneath |
/// | `transition-[background-color,border-color,box-shadow] duration-fast ease-out` | 250ms — `duration-fast` emits nothing, see [DsDurations.transitionDefault] |
/// | `after:absolute after:-inset-x-3 after:-inset-y-2` | a 44 × 36 target under a 20px box |
/// | `focus-visible:border-ring focus-visible:ring-3 focus-visible:ring-ring/50` | — |
/// | `aria-invalid:border-destructive aria-invalid:ring-3 aria-invalid:ring-destructive/20` | and it beats the focus ring |
/// | `disabled:opacity-50 group-has-disabled/field:opacity-50` | — |
///
/// The mark is a 14px box (`size-3.5`) holding one path on lucide's 24-unit
/// grid at `stroke-width: 3.2`, `round` caps and joins — heavier than any
/// lucide glyph, because at 14px a 2.4 stroke reads as a scratch.
library;

import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

import '../foundation/motion.dart';
import '../foundation/shadows.dart';
import '../foundation/spacing.dart';
import '../foundation/theme.dart';
import '../motion/keyframes.dart';
import '../theme_scope.dart';
import 'field.dart';
import 'icon_paths.dart';
import 'selection_control.dart';

/// Radix's `data-state` on a checkbox, which is tri-state because
/// `checked` is `boolean | "indeterminate"`.
enum DsCheckboxState {
  /// `data-state="unchecked"` — no indicator mounted at all.
  unchecked,

  /// `data-state="checked"`.
  checked,

  /// `data-state="indeterminate"` — the same lit box, carrying a bar instead
  /// of a tick.
  indeterminate;

  /// The attribute value the reference writes, and therefore the string a
  /// state-matrix caption prints.
  String get label => name;

  /// Whether the box is lit — `data-[state=checked]` and
  /// `data-[state=indeterminate]` declare an identical skin.
  bool get isOn => this != DsCheckboxState.unchecked;
}

/// `size-5`.
double get _boxSize => ds(5);

/// `size-3.5` — the mark's own box inside it.
double get _markSize => ds(3.5);

/// `stroke-width="3.2"`, in the 24-unit grid the two paths are drawn on.
///
/// allow-hardcoded: `checkbox.tsx` authors this stroke on its own `<svg>`; it
/// is the mark's geometry, not a token, and it is stated nowhere else.
const double _markStroke = 3.2;

/// `d="M5 12.5 10 17.5 19 7"` — the tick, hand-authored on lucide's grid
/// because lucide's own `Check` cannot carry a dash the length of itself.
///
/// allow-hardcoded: transcribed path data (`checkbox.tsx` L17).
Path _tickPath() => Path()
  ..moveTo(5, 12.5)
  ..lineTo(10, 17.5)
  ..lineTo(19, 7);

/// `d="M6 12h12"` — the indeterminate bar.
///
/// allow-hardcoded: transcribed path data (`checkbox.tsx` L17).
Path _dashPath() => Path()
  ..moveTo(6, 12)
  ..lineTo(18, 12);

/// A 20px checkbox whose tick writes itself on.
class DsCheckbox extends StatefulWidget {
  const DsCheckbox({
    super.key,
    this.state = DsCheckboxState.unchecked,
    this.onChanged,
    this.enabled = true,
    this.inert = false,
    this.invalid = false,
    this.forceFocusRing,
    this.focusNode,
    this.label,
    this.hint,
  });

  /// `checked` — the whole `data-state`, not a bool, because the reference's
  /// third state is a rendered state and not a null.
  final DsCheckboxState state;

  /// `onCheckedChange`, handed the state a click produces: an unchecked or
  /// indeterminate box becomes [DsCheckboxState.checked], a checked one
  /// becomes [DsCheckboxState.unchecked]. `null` disables the control.
  final ValueChanged<DsCheckboxState>? onChanged;

  /// A `Field` may disable a control that still carries a handler —
  /// `group-has-disabled/field:opacity-50`. ANDed with the enclosing
  /// [DsFieldScope]'s: a disabled field disables its control and the control
  /// cannot opt back in.
  final bool enabled;

  /// `<Checkbox checked="indeterminate"/>` with no `onCheckedChange` — the
  /// state matrix's Indeterminate cell, and the bulk header's select-all box.
  ///
  /// Radix holds a controlled checkbox at its prop value, so the box never
  /// changes; but it carries no `disabled`, so it stays **opaque, focusable and
  /// announced as enabled** *(measured: `disabled: false`, opacity 1)*. See
  /// [DsSelectionControl.inert] for the full state table and for what the flag
  /// actually changes.
  ///
  /// Distinct from `enabled: false`, which dims by half and leaves the tab
  /// order, and from a bare `onChanged: null`, which is a control that merely
  /// has nothing to do rather than one held at a value.
  final bool inert;

  /// `aria-invalid="true"`. ORed with the enclosing [DsFieldScope]'s.
  final bool invalid;

  /// `className="border-ring ring-3 ring-ring/50"` — paints the focus ring
  /// without owning the focus, for the matrix's "Focus" cell.
  ///
  /// See [DsSelectionControl.forceFocusRing]: the cell is a static fake, two of
  /// them sit on one page, and `aria-invalid` still beats it.
  final bool? forceFocusRing;

  /// A [DsFieldScope]'s node wins over the one this widget would otherwise
  /// leave to `Focus`, and loses to this — so `DsForm.focusFirstError` lands on
  /// the checkbox itself (ruling F4).
  final FocusNode? focusNode;

  /// The accessible name. A visible `DsFieldLabel` feeds this through the
  /// scope rather than duplicating it — Flutter has no `htmlFor` graph.
  final String? label;

  /// `aria-describedby`, resolved: description, then error message, in DOM
  /// order. [Semantics.hint] is the only channel that reads after the label.
  final String? hint;

  /// `size-5` — 20px, *"because 16px is a fiddly target"*.
  static double get size => _boxSize;

  /// What a click produces, per Radix: anything not checked becomes checked.
  static DsCheckboxState nextAfter(DsCheckboxState state) =>
      state == DsCheckboxState.checked
          ? DsCheckboxState.unchecked
          : DsCheckboxState.checked;

  @override
  State<DsCheckbox> createState() => _DsCheckboxState();
}

class _DsCheckboxState extends State<DsCheckbox> {
  /// Which **reveal** is on screen.
  ///
  /// **Every reveal re-draws, from the full dash offset, every time**
  /// *(measured — behaviour audit, second pass)*. The hidden mark carries no
  /// animation at all while it is hidden (`getAnimations()` is empty on it),
  /// and restoring its `display` starts a brand-new CSS animation rather than
  /// resuming a finished one. So a checked → indeterminate swap re-runs
  /// `dash-draw` from zero over its own 200ms, and indeterminate → checked
  /// re-runs `check-draw` over 280ms.
  ///
  /// This corrects the model this file shipped with, which mounted both marks
  /// together behind an `IndexedStack` and therefore revealed a bar that had
  /// already finished drawing. That read `group-data-[state=indeterminate]:
  /// hidden` as a visibility toggle over two live animations; the browser
  /// treats it as a mount.
  ///
  /// **Going out is not a draw.** Returning to `unchecked` unmounts the
  /// indicator outright — no reverse stroke, no fade *(measured)* — which is
  /// the `SizedBox.shrink()` branch below.
  int _reveal = 0;

  @override
  void didUpdateWidget(DsCheckbox old) {
    super.didUpdateWidget(old);
    // Any change that lands on a lit state is a reveal, including a swap
    // between the two lit states.
    if (widget.state != old.state && widget.state.isOn) _reveal++;
  }

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final DsFieldScope? scope = DsFieldScope.maybeOf(context);

    // The slot merge (`FormControl`): the scope supplies what the id graph
    // would have wired, and the child's own props win where both speak. Same
    // four lines `DsInput` and `DsTextarea` carry.
    final bool invalid = widget.invalid || (scope?.invalid ?? false);
    final bool enabled = widget.enabled && (scope?.enabled ?? true);
    final String? label = widget.label ?? scope?.label;
    final String? hint = widget.hint ?? scope?.describedBy;
    final FocusNode? focusNode = widget.focusNode ?? scope?.focusNode;

    // `<label for>` **activates** its control; it does not merely focus it.
    // Registering the toggle is what makes a tap on the visible `DsFieldLabel`
    // tick the box, the way clicking "I accept the terms" does on the web.
    // Re-registered on every build because the closure reads [DsCheckbox.state],
    // and set back to null while disabled so a stale toggle from an earlier
    // build cannot outlive the state that made it legal.
    //
    // An inert box registers nothing either: a controlled checkbox with no
    // handler is not toggled by clicking its label on the web, and there is
    // nothing here that would make it so.
    final VoidCallback? toggle =
        enabled && !widget.inert && widget.onChanged != null
            ? () => widget.onChanged!(DsCheckbox.nextAfter(widget.state))
            : null;
    scope?.activator?.callback = toggle;

    final bool on = widget.state.isOn;

    final bool bar = widget.state == DsCheckboxState.indeterminate;

    // Only the visible mark is mounted, and it is re-keyed on every reveal, so
    // each one starts a fresh player at dash offset zero. A hidden mark holds
    // no animation in the browser either — see [_reveal].
    final Widget indicator = on
        ? KeyedSubtree(
            key: ValueKey<int>(_reveal),
            child: SizedBox(
              width: _markSize,
              height: _markSize,
              child: _Mark(
                path: bar ? _dashPath() : _tickPath(),
                dashArray:
                    bar ? DsDashDraw.dashArray : DsCheckDraw.dashArray,
                duration: bar ? DsDashDraw.duration : DsCheckDraw.duration,
                drawnAt:
                    bar ? DsDashDraw.drawnFractionAt : DsCheckDraw.drawnFractionAt,
                color: theme.primaryForeground,
              ),
            ),
          )
        // Instant unmount, both marks gone at once. No reverse draw and no
        // fade — measured.
        : const SizedBox.shrink();

    return DsSelectionControl(
      width: _boxSize,
      height: _boxSize,
      radius: BorderRadius.circular(DsRadii.sm),
      fill: on ? theme.primary : theme.card,
      border: on ? theme.primary : theme.input,
      shadow: on ? DsShadows.btnPrimary : DsShadows.pressed,
      // NOT `--duration-fast`. The class list says `duration-fast`, and that
      // utility does not exist in Tailwind v4 — the socket runs at the
      // framework default, probed at 0.25s on the live reference.
      duration: DsDurations.transitionDefault,
      jellyState: widget.state,
      enabled: enabled,
      inert: widget.inert,
      invalid: invalid,
      forceFocusRing: widget.forceFocusRing,
      focusNode: focusNode,
      onTap: toggle,
      // Inside the hit-area expander, never around it — see [DsHitArea].
      semantics: (Widget child) => Semantics(
        container: true,
        checked: widget.state == DsCheckboxState.checked,
        mixed: widget.state == DsCheckboxState.indeterminate,
        // An inert box is announced as an ENABLED checkbox, because that is
        // what the reference's `disabled: false` says. Faithful, and the
        // second half of drift 7: it gives assistive technology no more signal
        // than it gives a reader.
        enabled: enabled && (widget.inert || widget.onChanged != null),
        label: label,
        hint: hint,
        child: child,
      ),
      child: indicator,
    );
  }
}

/// One drawn mark: a path on the 24-unit grid, revealed from its start.
///
/// `stroke-dashoffset` has no Flutter spelling, so the dash is a
/// [PathMetric.extractPath] window instead — the consumer half of the note in
/// `keyframes.dart`. The window is measured in the CSS's own dash units so the
/// two agree exactly: a path shorter than its `stroke-dasharray` (the tick
/// measures about 20.9 against a 22-unit dash) finishes early and holds, which
/// is what the browser draws too.
class _Mark extends StatelessWidget {
  const _Mark({
    required this.path,
    required this.dashArray,
    required this.duration,
    required this.drawnAt,
    required this.color,
  });

  final Path path;
  final double dashArray;
  final Duration duration;
  final double Function(double) drawnAt;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DsKeyframePlayer(
      duration: duration,
      // `both`, so a reduced-motion browser lands on the finished stroke.
      fill: DsKeyframeFill.both,
      builder: (BuildContext context, double t, Widget? child) => CustomPaint(
        painter: _MarkPainter(
          path: path,
          drawn: dashArray * drawnAt(t),
          color: color,
        ),
      ),
    );
  }
}

class _MarkPainter extends CustomPainter {
  const _MarkPainter({
    required this.path,
    required this.drawn,
    required this.color,
  });

  final Path path;

  /// How much of the stroke is painted, in the 24-unit grid's own units.
  final double drawn;

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || drawn <= 0) return;
    canvas.save();
    // The same `viewBox` fit `DsIcon` performs: 24 units into the rendered box,
    // with the stroke width scaled by the canvas rather than by hand.
    canvas.scale(size.width / _viewBox, size.height / _viewBox);

    final Path stroke = Path();
    for (final ui.PathMetric metric in path.computeMetrics()) {
      stroke.addPath(
        metric.extractPath(0, drawn.clamp(0, metric.length)),
        Offset.zero,
      );
    }

    canvas.drawPath(
      stroke,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = _markStroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
    canvas.restore();
  }

  /// `viewBox="0 0 24 24"` — the same grid lucide authors on, already stated
  /// once in `icon_paths.dart` and read from there rather than restated.
  static double get _viewBox => DsIconPaths.viewBox;

  @override
  bool shouldRepaint(_MarkPainter old) =>
      old.drawn != drawn || old.color != color || old.path != path;
}
