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
/// | `transition-[background-color,border-color,box-shadow] duration-fast ease-out` | 150ms |
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
    this.invalid = false,
    this.focusNode,
    this.label,
  });

  /// `checked` — the whole `data-state`, not a bool, because the reference's
  /// third state is a rendered state and not a null.
  final DsCheckboxState state;

  /// `onCheckedChange`, handed the state a click produces: an unchecked or
  /// indeterminate box becomes [DsCheckboxState.checked], a checked one
  /// becomes [DsCheckboxState.unchecked]. `null` disables the control.
  final ValueChanged<DsCheckboxState>? onChanged;

  /// A `Field` may disable a control that still carries a handler —
  /// `group-has-disabled/field:opacity-50`.
  final bool enabled;

  /// `aria-invalid="true"`.
  final bool invalid;

  final FocusNode? focusNode;

  /// The accessible name. A visible `DsFieldLabel` feeds this rather than
  /// duplicating it — Flutter has no `htmlFor` graph.
  final String? label;

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
  /// Which mounting of the Indicator is on screen.
  ///
  /// Radix mounts `CheckboxPrimitive.Indicator` when the box leaves
  /// `unchecked` and unmounts it when it returns, so both draw animations fire
  /// on that mount and **not** on a checked → indeterminate swap: the marks are
  /// already mounted there and only their visibility changes. Bumping this on
  /// the mount transition alone is that behaviour.
  int _mount = 0;

  @override
  void didUpdateWidget(DsCheckbox old) {
    super.didUpdateWidget(old);
    if (!old.state.isOn && widget.state.isOn) _mount++;
  }

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final bool on = widget.state.isOn;

    final Widget indicator = on
        ? KeyedSubtree(
            key: ValueKey<int>(_mount),
            child: SizedBox(
              width: _markSize,
              height: _markSize,
              // Both marks are mounted together and one is hidden, exactly as
              // `group-data-[state=indeterminate]/checkbox:hidden` does — which
              // is why a checked → indeterminate swap reveals a bar that has
              // already finished drawing.
              child: IndexedStack(
                index: widget.state == DsCheckboxState.indeterminate ? 1 : 0,
                alignment: Alignment.center,
                children: <Widget>[
                  _Mark(
                    path: _tickPath(),
                    dashArray: DsCheckDraw.dashArray,
                    duration: DsCheckDraw.duration,
                    drawnAt: DsCheckDraw.drawnFractionAt,
                    color: theme.primaryForeground,
                  ),
                  _Mark(
                    path: _dashPath(),
                    dashArray: DsDashDraw.dashArray,
                    duration: DsDashDraw.duration,
                    drawnAt: DsDashDraw.drawnFractionAt,
                    color: theme.primaryForeground,
                  ),
                ],
              ),
            ),
          )
        : const SizedBox.shrink();

    return DsSelectionControl(
      width: _boxSize,
      height: _boxSize,
      radius: BorderRadius.circular(DsRadii.sm),
      fill: on ? theme.primary : theme.card,
      border: on ? theme.primary : theme.input,
      shadow: on ? DsShadows.btnPrimary : DsShadows.pressed,
      duration: DsDurations.fast,
      jellyState: widget.state,
      enabled: widget.enabled,
      invalid: widget.invalid,
      focusNode: widget.focusNode,
      onTap: widget.onChanged == null
          ? null
          : () => widget.onChanged!(DsCheckbox.nextAfter(widget.state)),
      semantics: (Widget child) => Semantics(
        container: true,
        checked: widget.state == DsCheckboxState.checked,
        mixed: widget.state == DsCheckboxState.indeterminate,
        enabled: widget.enabled && widget.onChanged != null,
        label: widget.label,
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
