/// `components/ui/radio-group.tsx` — the same 20px socket, and the dot pops.
///
/// Its docstring: *"Radio — 20px to match Checkbox, squashes on selection, and
/// the dot pops in on the spring curve rather than appearing. Radix only mounts
/// the indicator when the item becomes checked, so the pop fires on every real
/// selection."*
///
/// `radioControlClassName` is `checkboxControlClassName` character for
/// character apart from the corner — `aspect-square … rounded-full` against
/// `rounded-sm` — so everything but the shape comes from [DsSelectionControl].
/// Two differences from the checkbox survive:
///
///  * the item carries **no** `group-has-disabled/field:opacity-50`, so a
///    disabled `Field` dims a checkbox and not a radio (forms-map drift 15);
///  * the indicator is a filled dot at `shadow-e1`, not a stroke, so it pops
///    rather than draws.
///
/// | class | value |
/// |---|---|
/// | `size-5 aspect-square rounded-full` | a 20px circle |
/// | `border border-input bg-card shadow-pressed` | the socket |
/// | `data-[state=checked]:border-primary bg-primary shadow-btn-primary` | lit |
/// | dot `size-2 rounded-full bg-primary-foreground shadow-e1` | 8px, raised |
/// | `anim-dot-pop` | 320ms on `--ease-spring`, `scale 0 → 1.35 @55% → 1` |
/// | `transition-[background-color,border-color,box-shadow] duration-fast ease-out` | 150ms |
///
/// `RadioGroup` itself is `grid w-full gap-2` — 8px — and the forms page passes
/// `className="gap-3"`, which tw-merges over it to **12px**. Both are reachable
/// through [DsRadioGroup.gap].
library;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../effects/machine_surface.dart';
import '../foundation/motion.dart';
import '../foundation/shadows.dart';
import '../foundation/spacing.dart';
import '../foundation/theme.dart';
import '../motion/keyframes.dart';
import '../theme_scope.dart';
import 'selection_control.dart';

/// `size-5`.
double get _boxSize => ds(5);

/// `size-2` — the dot.
double get _dotSize => ds(2);

/// The scope a `RadioGroupPrimitive.Root` provides: the selected value, the
/// setter, and the registry an item walks to answer an arrow key.
class _RadioScope<T> extends InheritedWidget {
  const _RadioScope({
    required this.value,
    required this.onChanged,
    required this.state,
    required super.child,
  });

  final T? value;
  final ValueChanged<T>? onChanged;
  final _DsRadioGroupState<T> state;

  static _RadioScope<T>? maybeOf<T>(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_RadioScope<T>>();

  @override
  bool updateShouldNotify(_RadioScope<T> old) =>
      old.value != value || old.onChanged != onChanged || old.state != state;
}

/// `RadioGroupPrimitive.Root` — `grid w-full gap-2`.
///
/// Owns the value, exactly as `onValueChange` / `value` on the Root do, and
/// owns the roving tab stop: the group is **one** stop, arrows move within it
/// and select as they move, and the movement wraps (Radix's `loop` defaults on).
class DsRadioGroup<T> extends StatefulWidget {
  const DsRadioGroup({
    super.key,
    required this.value,
    required this.onChanged,
    required this.children,
    this.gap,
  });

  /// `value` — `null` while nothing is chosen, which is also the state the
  /// composed form starts in.
  final T? value;

  /// `onValueChange`. `null` disables every item.
  final ValueChanged<T>? onChanged;

  /// The rows. Each holds a [DsRadioGroupItem] somewhere inside it — the
  /// reference wraps every item in a horizontal `Field` beside its label.
  final List<Widget> children;

  /// `gap-2` by default; the composed form passes `gap-3`.
  final double? gap;

  /// `gap-2` — the Root's own row gap.
  static double get defaultGap => ds(2);

  @override
  State<DsRadioGroup<T>> createState() => _DsRadioGroupState<T>();
}

class _DsRadioGroupState<T> extends State<DsRadioGroup<T>> {
  /// Every mounted item, in mount order — which for a list of rows is tree
  /// order, and therefore the order an arrow key walks.
  final List<_DsRadioGroupItemState<T>> _items = <_DsRadioGroupItemState<T>>[];

  void _register(_DsRadioGroupItemState<T> item) => _items.add(item);
  void _unregister(_DsRadioGroupItemState<T> item) => _items.remove(item);

  /// Whether [value] is the one item allowed into the Tab order.
  ///
  /// The checked item owns the stop; with nothing checked the first enabled
  /// item does, which is what a roving tabindex does on an empty group.
  bool isTabStop(T value) {
    if (widget.value != null) return widget.value == value;
    final int first = _items.indexWhere((_DsRadioGroupItemState<T> i) => i.enabled);
    return first >= 0 && _items[first].widget.value == value;
  }

  /// Arrow keys: move to the next or previous enabled item, wrapping, and
  /// select it on arrival — the ARIA radio-group contract Radix implements.
  KeyEventResult moveFrom(T from, int step) {
    if (widget.onChanged == null) return KeyEventResult.ignored;
    final List<_DsRadioGroupItemState<T>> enabled = _items
        .where((_DsRadioGroupItemState<T> i) => i.enabled)
        .toList(growable: false);
    if (enabled.length < 2) return KeyEventResult.ignored;

    final int here =
        enabled.indexWhere((_DsRadioGroupItemState<T> i) => i.widget.value == from);
    if (here < 0) return KeyEventResult.ignored;

    final _DsRadioGroupItemState<T> next =
        enabled[(here + step + enabled.length) % enabled.length];
    widget.onChanged!(next.widget.value);
    next.focusNode.requestFocus();
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final double gap = widget.gap ?? DsRadioGroup.defaultGap;
    return _RadioScope<T>(
      value: widget.value,
      onChanged: widget.onChanged,
      state: this,
      // `w-full` — the group fills whatever measure it is given. Its rows are
      // NOT stretched to match: a grid stretches its items, but
      // `RadioGroupItem` declares `size-5 shrink-0` and an explicit width beats
      // `justify-items: stretch`, so a bare item stays 20px while a `Field` row
      // beside it still fills. Loose constraints are what expresses that.
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            for (int i = 0; i < widget.children.length; i++) ...<Widget>[
              if (i > 0) SizedBox(height: gap),
              widget.children[i],
            ],
          ],
        ),
      ),
    );
  }
}

/// `RadioGroupPrimitive.Item` — one 20px socket with a popping dot.
class DsRadioGroupItem<T> extends StatefulWidget {
  const DsRadioGroupItem({
    super.key,
    required this.value,
    this.enabled = true,
    this.invalid = false,
    this.label,
  });

  /// The value this item selects. Compared with the group's by `==`.
  final T value;

  /// `disabled` on the item itself; the group disables every item by passing a
  /// null `onChanged`.
  final bool enabled;

  /// `aria-invalid="true"`.
  final bool invalid;

  /// The accessible name, for a control whose visible label is a sibling.
  final String? label;

  /// `size-5` — 20px, level with a checkbox.
  static double get size => _boxSize;

  @override
  State<DsRadioGroupItem<T>> createState() => _DsRadioGroupItemState<T>();
}

class _DsRadioGroupItemState<T> extends State<DsRadioGroupItem<T>> {
  final FocusNode focusNode = FocusNode(debugLabel: 'DsRadioGroupItem');

  _DsRadioGroupState<T>? _group;

  /// Whether this item can be operated: its own `disabled`, and the group's.
  bool get enabled => widget.enabled && _group?.widget.onChanged != null;

  /// Which mounting of the indicator is on screen. Radix mounts it only when
  /// the item becomes checked, so the pop fires on every real selection and
  /// never on a rebuild.
  int _mount = 0;
  bool _wasChecked = false;

  @override
  void dispose() {
    _group?._unregister(this);
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final _RadioScope<T>? scope = _RadioScope.maybeOf<T>(context);
    assert(
      scope != null,
      'DsRadioGroupItem must be inside a DsRadioGroup of the same type — the '
      'value and the setter live on the Root, exactly as they do in Radix.',
    );

    if (!identical(_group, scope!.state)) {
      _group?._unregister(this);
      _group = scope.state;
      _group!._register(this);
    }

    final bool checked = scope.value == widget.value;
    if (checked != _wasChecked) {
      _wasChecked = checked;
      if (checked) _mount++;
    }

    final Widget indicator = checked
        ? KeyedSubtree(
            key: ValueKey<int>(_mount),
            child: _Dot(color: theme.primaryForeground),
          )
        : const SizedBox.shrink();

    return DsSelectionControl(
      width: _boxSize,
      height: _boxSize,
      // `rounded-full` on a square is a circle; half the box is the radius the
      // shape can never exceed.
      radius: BorderRadius.circular(_boxSize / 2),
      fill: checked ? theme.primary : theme.card,
      border: checked ? theme.primary : theme.input,
      shadow: checked ? DsShadows.btnPrimary : DsShadows.pressed,
      duration: DsDurations.fast,
      jellyState: checked,
      enabled: enabled,
      invalid: widget.invalid,
      focusNode: focusNode,
      skipTraversal: !_group!.isTabStop(widget.value),
      onKey: _onKey,
      onTap: scope.onChanged == null || !widget.enabled
          ? null
          : () => scope.onChanged!(widget.value),
      semantics: (Widget child) => Semantics(
        container: true,
        inMutuallyExclusiveGroup: true,
        checked: checked,
        enabled: enabled,
        label: widget.label,
        child: child,
      ),
      child: indicator,
    );
  }

  KeyEventResult _onKey(KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final int step = switch (event.logicalKey) {
      LogicalKeyboardKey.arrowDown || LogicalKeyboardKey.arrowRight => 1,
      LogicalKeyboardKey.arrowUp || LogicalKeyboardKey.arrowLeft => -1,
      _ => 0,
    };
    if (step == 0) return KeyEventResult.ignored;
    return _group?.moveFrom(widget.value, step) ?? KeyEventResult.ignored;
  }
}

/// `RadioIndicator` — `size-2 rounded-full bg-primary-foreground shadow-e1`
/// wearing `anim-dot-pop`.
class _Dot extends StatelessWidget {
  const _Dot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return DsKeyframePlayer(
      duration: DsDotPop.duration,
      // `both`, so a reduced-motion browser lands on the settled dot rather
      // than on `scale(0)`.
      fill: DsDotPop.fill,
      builder: (BuildContext context, double t, Widget? child) => Opacity(
        opacity: DsDotPop.opacity.transform(t).clamp(0.0, 1.0),
        child: Transform.scale(
          scale: DsDotPop.scale.transform(t),
          child: child,
        ),
      ),
      child: SizedBox(
        width: _dotSize,
        height: _dotSize,
        child: DsMachineSurface(
          spec: DsShadows.e1,
          radius: BorderRadius.circular(_dotSize / 2),
          fill: color,
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}
