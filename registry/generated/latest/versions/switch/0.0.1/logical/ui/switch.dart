/// `components/ui/switch.tsx` — a knob sitting in a socket.
///
/// Its docstring is the whole specification: *"The depth is the point, and it
/// comes from the two shadows disagreeing: the track is **recessed**
/// (`shadow-pressed` when off, `shadow-btn-primary` when on, which lights it
/// and casts blue beneath) while the thumb is **raised** (`shadow-btn`, with
/// its own inner highlight). That opposition is what separates the two surfaces
/// instead of leaving a flat pill with a flat dot."*
///
/// | class | value |
/// |---|---|
/// | `data-[size=default]:h-6 data-[size=default]:w-11` | **44 × 24** |
/// | `data-[size=sm]:h-5 data-[size=sm]:w-9` | 36 × 20 |
/// | thumb `size-5` / `size-4` | 20 / 16 |
/// | `rounded-pill` + thumb `rounded-full` | — |
/// | `border border-input p-0.5` | 1px, 2px |
/// | `data-[state=unchecked]:bg-muted data-[state=unchecked]:shadow-pressed` | the socket |
/// | `data-[state=checked]:border-primary bg-primary shadow-btn-primary` | *"lit and radiating when on"* |
/// | thumb `bg-foreground shadow-btn` | raised in both states |
/// | `translate-x-5` / `translate-x-4` | **20px** / 16px of travel |
/// | track `transition-[background-color,box-shadow,border-color] duration-base ease-out` | 250ms — but from `--default-transition-duration`, not `duration-base`, which emits nothing ([ElDurations.transitionDefault]) |
/// | thumb `transition-transform duration-base ease-spring` | the same 250ms, and it overshoots |
/// | `after:-inset-x-3 after:-inset-y-2` | a **66 × 38** target — measured from the 42 × 22 padding box, see [ElHitArea] |
///
/// **The travel is 20px on a track whose content box is 38 wide.** A 20px thumb
/// starting 2px in cannot move 20px and stay inside its own padding: it ends
/// flush against the inner edge of the border, with the 2px of air it had on
/// the left spent. That asymmetry is what the reference renders, and the
/// spring's overshoot briefly carries the thumb past the border entirely —
/// the track declares no `overflow`, so nothing clips it.
///
/// One more difference from its two siblings: the switch spells its disabled
/// state `data-disabled:` while `Checkbox`, `RadioGroupItem` and `Select` spell
/// it `disabled:` (forms-map drift 14). Same intent, two selector families,
/// one [ElSwitch.enabled].
library;

import 'package:flutter/widgets.dart';

import '../effects/machine_surface.dart';
import '../foundation/motion.dart';
import '../foundation/shadows.dart';
import '../foundation/spacing.dart';
import '../foundation/theme.dart';
import '../theme_scope.dart';
import 'field.dart';
import 'selection_control.dart';

/// `border` — 1px, paid for out of the track's own box.
double get _border => ElWidths.hairline;

/// `p-0.5`.
double get _padding => el(0.5);

/// The two rungs of `data-size`.
enum ElSwitchSize {
  /// `data-size="sm"` — `h-5 w-9`, a 16px thumb, 16px of travel.
  sm,

  /// `data-size="default"` — `h-6 w-11`, a 20px thumb, 20px of travel.
  ///
  /// Named [md] because `default` is a Dart keyword; [label] is what a state
  /// matrix prints.
  md;

  /// The attribute value the reference writes.
  String get label => this == ElSwitchSize.md ? 'default' : 'sm';

  /// `w-11` / `w-9`.
  double get trackWidth => this == ElSwitchSize.md ? el(11) : el(9);

  /// `h-6` / `h-5`.
  double get trackHeight => this == ElSwitchSize.md ? el(6) : el(5);

  /// `group-data-[size=default]/switch:size-5` / `:size-4`.
  double get thumbSize => this == ElSwitchSize.md ? el(5) : el(4);

  /// `translate-x-5` / `translate-x-4`.
  double get travel => this == ElSwitchSize.md ? el(5) : el(4);
}

/// A 44 × 24 switch: recessed track, raised knob.
class ElSwitch extends StatelessWidget {
  const ElSwitch({
    super.key,
    required this.value,
    this.onChanged,
    this.size = ElSwitchSize.md,
    this.enabled = true,
    this.invalid = false,
    this.focusNode,
    this.label,
    this.hint,
  });

  /// `checked`.
  final bool value;

  /// `onCheckedChange`. `null` disables the control.
  final ValueChanged<bool>? onChanged;

  final ElSwitchSize size;

  /// `data-disabled` — separate from a null [onChanged] so a disabled `Field`
  /// can dim a switch that still carries its handler. ANDed with the enclosing
  /// [ElFieldScope]'s.
  final bool enabled;

  /// `aria-invalid="true"`. ORed with the enclosing [ElFieldScope]'s.
  final bool invalid;

  /// A [ElFieldScope]'s node wins over none and loses to this, so
  /// `ElForm.focusFirstError` lands on the switch itself (ruling F4).
  final FocusNode? focusNode;

  /// The accessible name, for a switch whose visible label is a sibling —
  /// supplied by a `ElField` through the scope when there is one.
  final String? label;

  /// `aria-describedby`, resolved: description, then error message.
  final String? hint;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    final ElFieldScope? scope = ElFieldScope.maybeOf(context);

    // The slot merge, as on every other control: the scope supplies what the id
    // graph would have wired and this widget's own props win.
    final bool isInvalid = invalid || (scope?.invalid ?? false);
    final bool isEnabled = enabled && (scope?.enabled ?? true);
    final String? name = label ?? scope?.label;
    final String? described = hint ?? scope?.describedBy;
    final FocusNode? node = focusNode ?? scope?.focusNode;

    // `<label for>` activates rather than focuses: a tap on "Price alerts"
    // flips the switch. Null while disabled, so a stale toggle cannot outlive
    // the state that made it legal.
    final VoidCallback? toggle = isEnabled && onChanged != null
        ? () => onChanged!(!value)
        : null;
    scope?.activator?.callback = toggle;

    return ElSelectionControl(
      width: size.trackWidth,
      height: size.trackHeight,
      radius: BorderRadius.circular(ElRadii.pill),
      // `bg-muted` when off — the one control here whose resting fill is not
      // `--card`, because a socket you can see into needs to be darker than the
      // surface it is cut out of.
      fill: value ? theme.primary : theme.muted,
      border: value ? theme.primary : theme.input,
      shadow: value ? ElShadows.btnPrimary : ElShadows.pressed,
      // `duration-base` is a Tailwind v4 no-op; the track runs at the
      // framework default. Same number, different declaration.
      duration: ElDurations.transitionDefault,
      jellyState: value,
      enabled: isEnabled,
      invalid: isInvalid,
      focusNode: node,
      onTap: toggle,
      // Inside the hit-area expander, never around it — see [ElHitArea].
      semantics: (Widget child) => Semantics(
        container: true,
        toggled: value,
        enabled: isEnabled && onChanged != null,
        label: name,
        hint: described,
        child: child,
      ),
      child: _Thumb(size: size, on: value, color: theme.foreground),
    );
  }
}

/// `SwitchPrimitive.Thumb` — raised in both states, and the only part that
/// runs on the spring.
class _Thumb extends StatelessWidget {
  const _Thumb({required this.size, required this.on, required this.color});

  final ElSwitchSize size;
  final bool on;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final double thumb = size.thumbSize;

    // The track's content box, so the knob's travel is measured against the
    // same rectangle CSS measures it against.
    return SizedBox.expand(
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(end: on ? 1 : 0),
        duration: elAnimationDuration(context, ElDurations.transitionDefault),
        // *"the thumb overshoots, the track does not"* — the one place in the
        // three controls where the two halves of a surface run different
        // curves.
        curve: ElCurves.spring,
        builder: (BuildContext context, double t, Widget? child) {
          return Stack(
            // The spring carries the thumb past the track's own edge on its
            // way to rest; the track declares no `overflow`, so neither does
            // this.
            clipBehavior: Clip.none,
            children: <Widget>[
              Positioned(
                // The surface has already inset this child by the border, so
                // only `p-0.5` is left to pay for here.
                left: _padding + size.travel * t,
                // `items-center` on a content box shorter than the thumb,
                // which is why the knob eats into the padding rather than
                // sitting inside it.
                top: (size.trackHeight - 2 * _border - thumb) / 2,
                width: thumb,
                height: thumb,
                child: child!,
              ),
            ],
          );
        },
        child: ElMachineSurface(
          spec: ElShadows.btn,
          radius: BorderRadius.circular(thumb / 2),
          fill: color,
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}
