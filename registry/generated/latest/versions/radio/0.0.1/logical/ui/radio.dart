/// `components/ui/radio-group.tsx` — the same 20px socket, and the dot pops.
///
/// Its docstring: *"Radio — 20px to match Checkbox, squashes on selection, and
/// the dot pops in on the spring curve rather than appearing. Radix only mounts
/// the indicator when the item becomes checked, so the pop fires on every real
/// selection."*
///
/// `radioControlClassName` is `checkboxControlClassName` character for
/// character apart from the corner — `aspect-square … rounded-full` against
/// `rounded-sm` — so everything but the shape comes from [ElSelectionControl].
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
/// | `transition-[background-color,border-color,box-shadow] duration-fast ease-out` | 250ms — `duration-fast` emits nothing, see [ElDurations.transitionDefault] |
///
/// `RadioGroup` itself is `grid w-full gap-2` — 8px — and the forms page passes
/// `className="gap-3"`, which tw-merges over it to **12px**. Both are reachable
/// through [ElRadioGroup.gap].
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
import 'field.dart';
import 'selection_control.dart';

/// `size-5`.
double get _boxSize => el(5);

/// `size-2` — the dot.
double get _dotSize => el(2);

/// The scope a `RadioGroupPrimitive.Root` provides: the selected value, the
/// setter, and the registry an item walks to answer an arrow key.
class _RadioScope<T> extends InheritedWidget {
  const _RadioScope({
    required this.value,
    required this.onChanged,
    required this.state,
    required this.invalid,
    required this.enabled,
    required this.field,
    required super.child,
  });

  final T? value;
  final ValueChanged<T>? onChanged;
  final _ElRadioGroupState<T> state;

  /// `aria-invalid` on the group, which `FormControl` stamps on the
  /// `RadioGroup` rather than on any item, and which every item then paints.
  final bool invalid;

  /// The group's own `disabled`, ANDed with its field's.
  final bool enabled;

  /// The [ElFieldScope] the **group** consumed, if any.
  ///
  /// An item compares its own nearest scope against this one: when they are the
  /// same object the group has already adopted that field's focus node, and a
  /// second `Focus` attaching it would be two widgets sharing one node. When
  /// they differ the item sits in a nested field of its own — the shape the
  /// reference uses to put a label beside each radio — and adopts it.
  final ElFieldScope? field;

  static _RadioScope<T>? maybeOf<T>(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_RadioScope<T>>();

  @override
  bool updateShouldNotify(_RadioScope<T> old) =>
      old.value != value ||
      old.onChanged != onChanged ||
      old.state != state ||
      old.invalid != invalid ||
      old.enabled != enabled ||
      old.field != field;
}

/// `RadioGroupPrimitive.Root` — `grid w-full gap-2`.
///
/// Owns the value, exactly as `onValueChange` / `value` on the Root do, and
/// owns the roving tab stop: the group is **one** stop, arrows move within it
/// and select as they move, and the movement wraps (Radix's `loop` defaults on).
class ElRadioGroup<T> extends StatefulWidget {
  const ElRadioGroup({
    super.key,
    required this.value,
    required this.onChanged,
    required this.children,
    this.gap,
    this.enabled = true,
    this.invalid = false,
    this.focusNode,
    this.label,
    this.hint,
  });

  /// `value` — `null` while nothing is chosen, which is also the state the
  /// composed form starts in.
  final T? value;

  /// `onValueChange`. `null` disables every item.
  final ValueChanged<T>? onChanged;

  /// The rows. Each holds a [ElRadioGroupItem] somewhere inside it — the
  /// reference wraps every item in a horizontal `Field` beside its label.
  final List<Widget> children;

  /// `gap-2` by default; the composed form passes `gap-3`.
  final double? gap;

  /// `disabled` on the Root. ANDed with the enclosing [ElFieldScope]'s.
  final bool enabled;

  /// `aria-invalid="true"`, which `FormControl` stamps on the **group** —
  /// `data-slot="radio-group"` survives the Slot merge, and the group is what
  /// the wiring wraps. ORed with the enclosing [ElFieldScope]'s.
  final bool invalid;

  /// The node a failed submit lands on, adopted from the enclosing
  /// [ElFieldScope] when this is null.
  ///
  /// A group is not itself operable, so focus does not stop here: taking it
  /// hands it straight to the item a keyboard user would reach — the checked
  /// one, or the first enabled one when nothing is checked. That is what makes
  /// `ElForm.focusFirstError` land somewhere useful on the `payout` field,
  /// which on the reference is where focus-on-error silently does nothing
  /// (forms-map drift 7, ruling F4).
  final FocusNode? focusNode;

  /// The legend's text, announced as the group's accessible name.
  ///
  /// The `payout` field is the page's one `FieldSet` + `FieldLegend`, and its
  /// source comment says why: `<label for>` may only point at a labelable
  /// element and a RadioGroup container is a `div`, so `FormLabel`'s `htmlFor`
  /// would announce nothing. A Flutter container has no such restriction.
  final String? label;

  /// `aria-describedby`, resolved: description, then error message.
  final String? hint;

  /// `gap-2` — the Root's own row gap.
  static double get defaultGap => el(2);

  @override
  State<ElRadioGroup<T>> createState() => _ElRadioGroupState<T>();
}

class _ElRadioGroupState<T> extends State<ElRadioGroup<T>> {
  /// Every mounted item, in mount order — which for a list of rows is tree
  /// order, and therefore the order an arrow key walks.
  final List<_ElRadioGroupItemState<T>> _items = <_ElRadioGroupItemState<T>>[];

  void _register(_ElRadioGroupItemState<T> item) => _items.add(item);
  void _unregister(_ElRadioGroupItemState<T> item) => _items.remove(item);

  /// Whether [value] is the one item allowed into the Tab order.
  ///
  /// The checked item owns the stop; with nothing checked the first enabled
  /// item does, which is what a roving tabindex does on an empty group.
  bool isTabStop(T value) {
    if (widget.value != null) return widget.value == value;
    final int first = _items.indexWhere(
      (_ElRadioGroupItemState<T> i) => i.enabled,
    );
    return first >= 0 && _items[first].widget.value == value;
  }

  /// Arrow keys: move to the next or previous enabled item, wrapping, and
  /// select it on arrival — the ARIA radio-group contract Radix implements.
  KeyEventResult moveFrom(T from, int step) {
    if (widget.onChanged == null) return KeyEventResult.ignored;
    final List<_ElRadioGroupItemState<T>> enabled = _items
        .where((_ElRadioGroupItemState<T> i) => i.enabled)
        .toList(growable: false);
    if (enabled.length < 2) return KeyEventResult.ignored;

    final int here = enabled.indexWhere(
      (_ElRadioGroupItemState<T> i) => i.widget.value == from,
    );
    if (here < 0) return KeyEventResult.ignored;

    final _ElRadioGroupItemState<T> next =
        enabled[(here + step + enabled.length) % enabled.length];
    widget.onChanged!(next.widget.value);
    next.focusNode.requestFocus();
    return KeyEventResult.handled;
  }

  /// Hands focus to the item the roving tabindex would have put it on.
  void _forwardToTabStop() {
    for (final _ElRadioGroupItemState<T> item in _items) {
      if (!item.enabled || !isTabStop(item.widget.value)) continue;
      item.focusNode.requestFocus();
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double gap = widget.gap ?? ElRadioGroup.defaultGap;
    final ElFieldScope? field = ElFieldScope.maybeOf(context);

    // The slot merge, at the element `FormControl` actually wraps.
    final bool invalid = widget.invalid || (field?.invalid ?? false);
    final bool enabled = widget.enabled && (field?.enabled ?? true);
    final FocusNode? node = widget.focusNode ?? field?.focusNode;

    // A group has no single toggle, so activating it is **focusing** the item
    // the roving tabindex is on — which is exactly what `<label for>` does to a
    // radiogroup: it moves focus and changes no selection. Registering a
    // "select the first one" here would invent a behaviour the web does not
    // have.
    field?.activator?.callback = enabled && widget.onChanged != null
        ? _forwardToTabStop
        : null;

    return _RadioScope<T>(
      value: widget.value,
      onChanged: enabled ? widget.onChanged : null,
      state: this,
      invalid: invalid,
      enabled: enabled,
      field: field,
      // `w-full` — the group fills whatever measure it is given. Its rows are
      // NOT stretched to match: a grid stretches its items, but
      // `RadioGroupItem` declares `size-5 shrink-0` and an explicit width beats
      // `justify-items: stretch`, so a bare item stays 20px while a `Field` row
      // beside it still fills. Loose constraints are what expresses that.
      child: Semantics(
        container: true,
        label: widget.label ?? field?.label,
        hint: widget.hint ?? field?.describedBy,
        enabled: enabled && widget.onChanged != null,
        child: _withGroupFocus(
          node,
          SizedBox(
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
        ),
      ),
    );
  }

  /// Attaches the field's node to the group so a failed submit can land on it,
  /// and passes the focus straight through to an item.
  ///
  /// `skipTraversal` because the items own the tab order between them: this
  /// node exists to be *requested*, never to be tabbed into.
  Widget _withGroupFocus(FocusNode? node, Widget child) {
    if (node == null) return child;
    return Focus(
      focusNode: node,
      skipTraversal: true,
      onFocusChange: (bool has) {
        if (has) _forwardToTabStop();
      },
      child: child,
    );
  }
}

/// `RadioGroupPrimitive.Item` — one 20px socket with a popping dot.
class ElRadioGroupItem<T> extends StatefulWidget {
  const ElRadioGroupItem({
    super.key,
    required this.value,
    this.enabled = true,
    this.invalid = false,
    this.forceFocusRing,
    this.label,
    this.hint,
  });

  /// The value this item selects. Compared with the group's by `==`.
  final T value;

  /// `disabled` on the item itself; the group disables every item by passing a
  /// null `onChanged`.
  final bool enabled;

  /// `aria-invalid="true"`.
  final bool invalid;

  /// `className="border-ring ring-3 ring-ring/50"` on the item — the matrix's
  /// "Focus" cell, which is painted rather than focused.
  ///
  /// See [ElSelectionControl.forceFocusRing]. The radio matrix carries the
  /// second of the page's two such cells, which is the reason the flag exists
  /// at all: only one control can really hold the focus.
  final bool? forceFocusRing;

  /// The accessible name, for a control whose visible label is a sibling.
  ///
  /// Taken from the item's **own** nested [ElFieldScope] when it has one —
  /// which is the shape the reference uses, one labelled field per radio — and
  /// never from the group's, whose label is the legend for all of them.
  final String? label;

  /// `aria-describedby`, resolved.
  final String? hint;

  /// `size-5` — 20px, level with a checkbox.
  static double get size => _boxSize;

  @override
  State<ElRadioGroupItem<T>> createState() => _ElRadioGroupItemState<T>();
}

class _ElRadioGroupItemState<T> extends State<ElRadioGroupItem<T>> {
  final FocusNode _ownNode = FocusNode(debugLabel: 'ElRadioGroupItem');

  /// A nested field's node, when this item sits in a `ElField` of its own that
  /// the group did not already take. See `_RadioScope.field`.
  FocusNode? _adoptedNode;

  /// The node the roving tabindex moves to and a failed submit can land on.
  FocusNode get focusNode => _adoptedNode ?? _ownNode;

  _ElRadioGroupState<T>? _group;

  /// Whether this item can be operated: its own `disabled`, its field's, and
  /// the group's.
  bool enabled = true;

  /// Which mounting of the indicator is on screen. Radix mounts it only when
  /// the item becomes checked, so the pop fires on every real selection and
  /// never on a rebuild.
  int _mount = 0;
  bool _wasChecked = false;

  @override
  void dispose() {
    _group?._unregister(this);
    // Only the owned one: an adopted node belongs to the field that made it.
    _ownNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    final _RadioScope<T>? scope = _RadioScope.maybeOf<T>(context);
    assert(
      scope != null,
      'ElRadioGroupItem must be inside a ElRadioGroup of the same type — the '
      'value and the setter live on the Root, exactly as they do in Radix.',
    );

    if (!identical(_group, scope!.state)) {
      _group?._unregister(this);
      _group = scope.state;
      _group!._register(this);
    }

    // The item's own nearest field, which is a *different* one from the
    // group's whenever the call site wraps each radio in its own labelled
    // `ElField` — the arrangement the reference uses. Where they are the same
    // object the group has already taken it, and the item takes nothing.
    final ElFieldScope? field = ElFieldScope.maybeOf(context);
    final bool ownField = field != null && !identical(field, scope.field);
    _adoptedNode = ownField ? field.focusNode : null;

    final bool invalid =
        widget.invalid || scope.invalid || (ownField && field.invalid);
    enabled =
        widget.enabled &&
        scope.enabled &&
        (!ownField || field.enabled) &&
        scope.onChanged != null;

    final VoidCallback? select = enabled
        ? () => scope.onChanged!(widget.value)
        : null;

    // Only when the item has a field of its own — one labelled `ElField` per
    // radio, which is how the reference puts a name beside each. There,
    // `<label for="payout-daily">` selects that radio, so the item registers
    // its own selection. The group's field is the legend's, and the group has
    // already registered focus-the-tab-stop on it.
    if (ownField) field.activator?.callback = select;

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

    return ElSelectionControl(
      width: _boxSize,
      height: _boxSize,
      // `rounded-full` on a square is a circle; half the box is the radius the
      // shape can never exceed.
      radius: BorderRadius.circular(_boxSize / 2),
      fill: checked ? theme.primary : theme.card,
      border: checked ? theme.primary : theme.input,
      shadow: checked ? ElShadows.btnPrimary : ElShadows.pressed,
      // NOT `--duration-fast` — same Tailwind v4 no-op as the checkbox's
      // socket, and probed at 0.25s on the live reference.
      duration: ElDurations.transitionDefault,
      jellyState: checked,
      enabled: enabled,
      invalid: invalid,
      forceFocusRing: widget.forceFocusRing,
      focusNode: focusNode,
      skipTraversal: !_group!.isTabStop(widget.value),
      onKey: _onKey,
      onTap: select,
      // Inside the hit-area expander, never around it — see [ElHitArea].
      semantics: (Widget child) => Semantics(
        container: true,
        inMutuallyExclusiveGroup: true,
        checked: checked,
        enabled: enabled,
        label: widget.label ?? (ownField ? field.label : null),
        hint: widget.hint ?? (ownField ? field.describedBy : null),
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
    return ElKeyframePlayer(
      duration: ElDotPop.duration,
      // `both`, so a reduced-motion browser lands on the settled dot rather
      // than on `scale(0)`.
      fill: ElDotPop.fill,
      builder: (BuildContext context, double t, Widget? child) => Opacity(
        opacity: ElDotPop.opacity.transform(t).clamp(0.0, 1.0),
        child: Transform.scale(
          scale: ElDotPop.scale.transform(t),
          child: child,
        ),
      ),
      child: SizedBox(
        width: _dotSize,
        height: _dotSize,
        child: ElMachineSurface(
          spec: ElShadows.e1,
          radius: BorderRadius.circular(_dotSize / 2),
          fill: color,
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}
