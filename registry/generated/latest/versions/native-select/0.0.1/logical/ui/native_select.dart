/// `components/ui/native-select.tsx` — a real `<select>`, and **the one place
/// in this port that cannot be 1:1 by construction.**
///
/// ## The divergence, stated first (supervisor ruling L6, option c)
///
/// The whole point of the selects page's §2 is that *the operating system draws
/// the list*: the section title says so, the description says so
/// (*"Renders the operating system's own picker"*), the page's opening Note
/// says so, and its Do 3 says so. Flutter has no OS `<select>`. There is no
/// widget, on any platform this package renders to, that opens the platform's
/// own option list against an arbitrary box.
///
/// So this component is split in two, and only one half is a port:
///
/// | half | fidelity |
/// |---|---|
/// | the **closed control** — 32px, 12px radius, transparent, no socket, 1px `--input` border, `pr-8` chevron gutter, both `dark:` fills, focus ring, invalid ring, the wrapper's disabled dim | **1:1, measured.** It is what every screenshot the rig takes contains |
/// | the **open list** | **DIVERGENT.** The port mounts its own [SelectMenu] — `SelectContent`'s surface, rows, tick and keyboard — where the OS would have drawn its picker. `<option class="bg-[Canvas] text-[CanvasText]">` asks for the platform's system colours; the port paints `--popover` |
///
/// The closed control is the specimen; the list is off-canvas in every capture.
/// That is the whole argument for option (c), and it is recorded here rather
/// than in a report so the next reader meets it before the code.
///
/// What *is* kept faithful about the open half is its **keyboard**, because
/// that belongs to the platform control rather than to Radix: a closed
/// `<select>` walks its own value with the arrow keys without opening anything,
/// which is the one behaviour that would be a real regression to lose. Enter,
/// Space and Alt+Down open it; Home and End jump; Escape closes without
/// committing. `Select` — a Radix menu — opens on the arrows instead, and the
/// two are different on purpose.
///
/// ## The control, verbatim (`native-select.tsx:19`, `:28`, `:31`, `:43`)
///
/// Wrapper: `group/native-select relative w-fit has-[select:disabled]:opacity-50`
///
/// ```
/// h-8 w-full min-w-0 appearance-none rounded-lg border border-input
/// bg-transparent py-1 pr-8 pl-2.5 text-sm transition-colors outline-none
/// select-none selection:bg-primary selection:text-primary-foreground
/// placeholder:text-muted-foreground focus-visible:border-ring
/// focus-visible:ring-3 focus-visible:ring-ring/50 disabled:pointer-events-none
/// disabled:cursor-not-allowed aria-invalid:border-destructive
/// aria-invalid:ring-3 aria-invalid:ring-destructive/20 data-[size=sm]:h-7
/// data-[size=sm]:rounded-[min(var(--radius-md),10px)] data-[size=sm]:py-0.5
/// dark:bg-input/30 dark:hover:bg-input/50 dark:aria-invalid:border-destructive/50
/// dark:aria-invalid:ring-destructive/40
/// ```
///
/// | property | value |
/// |---|---|
/// | height | **32px** (`h-8`) — the `Select` beside it is 40. selects-map drift 8 |
/// | radius | **12px** (`rounded-lg`). Not a indicator: the only non-pill control in the family |
/// | fill | **transparent** (light) / `--input` at 30% (dark), 50% on hover (dark) |
/// | socket | **none.** The only control in the family with no `shadow-pressed` |
/// | border | 1px `--input` |
/// | padding | `py-1 pr-8 pl-2.5` → 4 / 32 / 10. The 32px right gutter is the chevron's room |
/// | chevron | 16px `--muted-foreground`, 10px from the right edge, vertically centred |
/// | disabled | the dim is **`opacity-50` on the wrapper**, not on the control |
/// | `sm` | `h-7` 28px, radius `min(--radius-md, 10px)` = 10, `py-0.5` |
///
/// DOCUMENTED DRIFT (selects-map drift 19): `NativeSelect` carries the same
/// four `dark:` variants as `Select`, so forms-map drift 17's *"the only
/// control with `dark:` overrides"* now has a second member.
///
/// DOCUMENTED DRIFT: `placeholder:text-muted-foreground` and
/// `selection:bg-primary` are in the class list and **can never fire on a
/// `<select>`** — a `<select>` has no placeholder and no text selection. They
/// are carried over from `input.tsx`'s list. Nothing is built for them.
///
/// DOCUMENTED DRIFT: `NativeSelectOptGroup` (`native-select.tsx:49`) exists and
/// is unused on the page. It is expressible here anyway, because the option
/// list is a [SelectChild] list and [SelectGroup] is one of its members.
library;

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

import './surface.dart';
import '../../design_system/foundation/colors.dart';
import '../../design_system/foundation/motion.dart';
import '../../design_system/foundation/shadows.dart';
import '../../design_system/foundation/spacing.dart';
import '../../design_system/foundation/surfaces.dart';
import '../../design_system/foundation/theme.dart';
import '../../design_system/foundation/typography.dart';
import '../../design_system/foundation/theme_scope.dart';
import './button.dart';
import './field.dart';
import './icon.dart';
import './icon_paths.dart';
import './popover.dart';
import './select.dart';

/// `focus-visible:ring-ring/50`.
const double _focusRingAlpha = 0.50;

/// `aria-invalid:ring-destructive/20`, and its `dark:` override at 40.
const double _invalidRingAlpha = 0.20;
const double _invalidRingAlphaDark = 0.40;

/// `dark:aria-invalid:border-destructive/50`.
const double _invalidBorderAlphaDark = 0.50;

/// `dark:bg-input/30` and `dark:hover:bg-input/50`.
const double _darkFillAlpha = 0.30;
const double _darkHoverFillAlpha = 0.50;

/// `min-w-36` on the menu — the same floor `SelectContent` carries, because it
/// is the same menu.
double get _menuMinWidth => space(36);

/// The two rungs of `data-size` on the control.
enum NativeSelectSize {
  /// `data-[size=sm]` — `h-7`, `rounded-[min(var(--radius-md),10px)]`, `py-0.5`.
  sm,

  /// The default — `h-8`, `rounded-lg`, `py-1`. Named [md] because `default` is
  /// a Dart keyword, the same rename [SelectSize] carries.
  md;

  /// The attribute value the reference writes.
  String get label => this == NativeSelectSize.md ? 'default' : 'sm';

  /// `h-8` / `h-7`.
  double get height => this == NativeSelectSize.md ? space(8) : space(7);

  /// `rounded-lg`, or the `min()` the `sm` rung asks for — which resolves to
  /// `--radius-md` because 10 is the smaller of the two.
  double get radius => this == NativeSelectSize.md ? Radii.lg : Radii.md;

  /// `py-1` / `py-0.5`. Inert against a fixed height, transcribed anyway.
  double get insetY => this == NativeSelectSize.md ? space(1) : space(0.5);
}

/// The operating system's picker, as far as Flutter can carry it.
class NativeSelect<T> extends StatefulWidget {
  const NativeSelect({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
    this.size = NativeSelectSize.md,
    this.enabled = true,
    this.invalid = false,
    this.expand = false,
    this.width,
    this.focusNode,
    this.label,
    this.hint,
  });

  /// `NativeSelectOption` children, and `NativeSelectOptGroup` with them.
  final List<SelectChild<T>> options;

  /// The selected value.
  ///
  /// `null` renders the **first** option, because that is what a `<select>`
  /// with no `value` does — an unselected `<select>` does not exist. There is
  /// no placeholder here and no `data-placeholder` state to paint: the class
  /// list's `placeholder:` variant can never match.
  final T? value;

  final ValueChanged<T>? onChanged;

  final NativeSelectSize size;

  /// `disabled`. ANDed with the enclosing [FieldScope]'s.
  final bool enabled;

  /// `aria-invalid="true"`. ORed with the enclosing [FieldScope]'s.
  final bool invalid;

  /// The wrapper's own class is `w-fit`; the page's vertical `Field` overrides
  /// it to `w-full` and the control renders at 384px. Same cascade, and the
  /// same switch, as [Select.expand].
  final bool expand;

  /// An explicit measure, which beats both [expand] states — [Select.width]'s
  /// twin. Unused on the page; the state grid's `w-40` is on the `Select`.
  final double? width;

  final FocusNode? focusNode;

  /// The accessible name — `<label for="ns">` supplies **Country** on the page.
  final String? label;

  /// `aria-describedby`, resolved.
  final String? hint;

  /// `sideOffset` for the port's own menu.
  ///
  /// Not a reference number — there is no reference for a list the OS draws.
  /// It is `PopoverContent`'s own 4px, so the one gap in this port that had to
  /// be invented is at least the gap the rest of the system uses.
  static double get menuOffset => space(1);

  @override
  State<NativeSelect<T>> createState() => _NativeSelectState<T>();
}

class _NativeSelectState<T> extends State<NativeSelect<T>> {
  FocusNode? _ownedFocusNode;
  FieldScope? _scope;

  FocusNode get _focusNode =>
      widget.focusNode ??
      _scope?.focusNode ??
      (_ownedFocusNode ??= FocusNode(debugLabel: 'NativeSelect'));

  bool _open = false;
  bool _focused = false;
  bool _hovered = false;

  /// The row the open list is on. Meaningless while closed, where the value
  /// itself is what the arrows move.
  int _highlighted = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scope = FieldScope.maybeOf(context);
  }

  @override
  void dispose() {
    _ownedFocusNode?.dispose();
    super.dispose();
  }

  bool get _invalid => widget.invalid || (_scope?.invalid ?? false);
  bool get _fieldEnabled => widget.enabled && (_scope?.enabled ?? true);
  bool get _enabled => _fieldEnabled && widget.onChanged != null;

  /// The selectable rows, flattened out of the child list exactly as the menu
  /// flattens them.
  List<SelectOption<T>> get _flat {
    final List<SelectOption<T>> flat = <SelectOption<T>>[];
    for (final SelectChild<T> child in widget.options) {
      switch (child) {
        case SelectOption<T>():
          flat.add(child);
        case SelectGroup<T>():
          flat.addAll(child.children);
        case SelectSeparator():
          break;
      }
    }
    return flat;
  }

  int get _selectedIndex {
    final List<SelectOption<T>> flat = _flat;
    final int i = flat.indexWhere(
      (SelectOption<T> o) => o.value == widget.value,
    );
    return i < 0 ? 0 : i;
  }

  void _openList() {
    if (_open || !_enabled || _flat.isEmpty) return;
    setState(() {
      _highlighted = _selectedIndex;
      _open = true;
    });
  }

  void _closeList({bool restoreFocus = true}) {
    if (!_open) return;
    setState(() => _open = false);
    if (restoreFocus) _focusNode.requestFocus();
  }

  void _commit(int index) {
    final List<SelectOption<T>> flat = _flat;
    if (index < 0 || index >= flat.length || !flat[index].enabled) return;
    _closeList();
    widget.onChanged?.call(flat[index].value);
  }

  /// The closed control's own arrow keys: they move the **value**, not a
  /// highlight, and they do not wrap — a `<select>` on its last option stays
  /// there.
  void _step(int by) {
    final List<SelectOption<T>> flat = _flat;
    if (flat.isEmpty) return;
    int next = _selectedIndex;
    while (true) {
      next += by;
      if (next < 0 || next >= flat.length) return;
      if (flat[next].enabled) break;
    }
    widget.onChanged?.call(flat[next].value);
  }

  /// The open list's highlight, which does wrap — it is [SelectMenu], and the
  /// menu is Radix's.
  void _move(int step) {
    final List<SelectOption<T>> flat = _flat;
    final int count = flat.length;
    if (count == 0) return;
    int next = _highlighted;
    for (int i = 0; i < count; i++) {
      next = (next + step + count) % count;
      if (flat[next].enabled) break;
    }
    if (next == _highlighted) return;
    setState(() => _highlighted = next);
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (!_enabled || event is! KeyDownEvent) return KeyEventResult.ignored;
    final LogicalKeyboardKey key = event.logicalKey;
    final bool alt = HardwareKeyboard.instance.isAltPressed;

    if (!_open) {
      // `Alt+ArrowDown` opens rather than steps — the one modifier a `<select>`
      // reads, and the reason the plain arrows can stay on the value.
      if (key == LogicalKeyboardKey.enter ||
          key == LogicalKeyboardKey.numpadEnter ||
          key == LogicalKeyboardKey.space ||
          key == LogicalKeyboardKey.f4 ||
          (alt &&
              (key == LogicalKeyboardKey.arrowDown ||
                  key == LogicalKeyboardKey.arrowUp))) {
        _openList();
        return KeyEventResult.handled;
      }
      switch (key) {
        case LogicalKeyboardKey.arrowDown:
          _step(1);
        case LogicalKeyboardKey.arrowUp:
          _step(-1);
        case LogicalKeyboardKey.home:
          _step(-_flat.length);
        case LogicalKeyboardKey.end:
          _step(_flat.length);
        default:
          return KeyEventResult.ignored;
      }
      return KeyEventResult.handled;
    }

    switch (key) {
      case LogicalKeyboardKey.arrowDown:
        _move(1);
      case LogicalKeyboardKey.arrowUp:
        _move(-1);
      case LogicalKeyboardKey.home:
        _highlighted = -1;
        _move(1);
      case LogicalKeyboardKey.end:
        _highlighted = _flat.length;
        _move(-1);
      case LogicalKeyboardKey.enter:
      case LogicalKeyboardKey.numpadEnter:
      case LogicalKeyboardKey.space:
        _commit(_highlighted);
      case LogicalKeyboardKey.escape:
      case LogicalKeyboardKey.tab:
        _closeList();
      default:
        return KeyEventResult.ignored;
    }
    return KeyEventResult.handled;
  }

  // ── paint ────────────────────────────────────────────────────────────────

  /// `bg-transparent`, or `--input` at 30% / 50% on dark.
  Color _fill(ThemeTokens theme) {
    if (theme.kind == ResolvedColorMode.light) return transparent;
    return theme.input.withValues(
      alpha: _hovered ? _darkHoverFillAlpha : _darkFillAlpha,
    );
  }

  Color _border(ThemeTokens theme) {
    if (_invalid) {
      return theme.kind == ResolvedColorMode.dark
          ? theme.destructive.withValues(alpha: _invalidBorderAlphaDark)
          : theme.destructive;
    }
    if (_focused || _open) return theme.ring;
    return theme.input;
  }

  Color _ring(ThemeTokens theme) {
    if (_invalid) {
      return theme.destructive.withValues(
        alpha: theme.kind == ResolvedColorMode.dark
            ? _invalidRingAlphaDark
            : _invalidRingAlpha,
      );
    }
    return theme.ring.withValues(
      alpha: _focused || _open ? _focusRingAlpha : 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final Duration duration = effectiveMotionDuration(
      context,
      MotionDurations.normal,
    );
    final List<SelectOption<T>> flat = _flat;

    // `<label for>` on a `<select>` opens its picker.
    _scope?.activator?.callback = _enabled ? _openList : null;

    // A `<select>` with no `value` shows its first option; there is nothing
    // else it could show.
    final SelectOption<T>? shown = flat.isEmpty ? null : flat[_selectedIndex];

    Widget control = TweenAnimationBuilder<Color?>(
      tween: ColorTween(end: _fill(theme)),
      duration: duration,
      curve: MotionCurves.enter,
      builder: (BuildContext context, Color? fill, Widget? child) =>
          TweenAnimationBuilder<Color?>(
            tween: ColorTween(end: _border(theme)),
            duration: duration,
            curve: MotionCurves.enter,
            builder: (BuildContext context, Color? border, Widget? child) =>
                TweenAnimationBuilder<Color?>(
                  tween: ColorTween(end: _ring(theme)),
                  duration: duration,
                  curve: MotionCurves.enter,
                  builder: (BuildContext context, Color? ring, Widget? child) {
                    final Color ringColor = ring ?? theme.ring;
                    return Surface(
                      // **No socket.** `shadow-none` is the resting state and the focus
                      // ring is the only layer this control ever paints — the opposite
                      // of every pill on the page.
                      spec: ringColor.a == 0
                          ? Shadows.none
                          : Button.withFocusRing(Shadows.none, ringColor),
                      radius: BorderRadius.circular(widget.size.radius),
                      fill: fill ?? transparent,
                      border: Border.all(
                        color: border ?? theme.input,
                        width: BorderWidths.hairline,
                      ),
                      // Threaded through all three builders unrebuilt, so it is the
                      // row handed to the outermost `child:` and never null.
                      child: child!,
                    );
                  },
                  child: child,
                ),
            child: child,
          ),
      child: Stack(
        children: <Widget>[
          Padding(
            // `py-1 pr-8 pl-2.5`.
            padding: EdgeInsets.only(
              left: space(2.5),
              right: space(8),
              top: widget.size.insetY,
              bottom: widget.size.insetY,
            ),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: StyledText(
                shown?.label ?? '',
                TextStyles.bodyCompact,
                color: theme.foreground,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
              ),
            ),
          ),
          // `absolute top-1/2 right-2.5 size-4 -translate-y-1/2`.
          Positioned.fill(
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Padding(
                padding: EdgeInsets.only(right: space(2.5)),
                child: const Icon(IconGlyph.chevronDown, tone: IconTone.muted),
              ),
            ),
          ),
        ],
      ),
    );

    control = SizedBox(
      height: widget.size.height,
      width: widget.width ?? (widget.expand ? double.infinity : null),
      child: control,
    );

    control = GestureDetector(
      behavior: HitTestBehavior.opaque,
      // A click on a `<select>` focuses it as well as opening it, and focus is
      // where this control's keyboard lives: the arrows walk the value while
      // the list is shut, so a control that opened without taking focus would
      // be mute the moment the list closed again.
      onTap: _enabled
          ? () {
              _focusNode.requestFocus();
              if (_open) {
                _closeList();
              } else {
                _openList();
              }
            }
          : null,
      child: MouseRegion(
        cursor: _enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: control,
      ),
    );

    control = Focus(
      focusNode: _focusNode,
      canRequestFocus: _enabled,
      onFocusChange: (bool value) => setState(() => _focused = value),
      onKeyEvent: _onKey,
      child: control,
    );

    // The list is anchored to the closed control and does not animate: an OS
    // picker appears. `Popover` supplies the positioner and the collision
    // flip; `SelectMenu` supplies everything inside it.
    control = Popover(
      open: _open,
      side: PopoverSide.bottom,
      align: PopoverAlign.start,
      sideOffset: NativeSelect.menuOffset,
      collisionPadding: space(2),
      animate: false,
      onDismiss: () => _closeList(restoreFocus: false),
      anchor: control,
      content: (BuildContext context, PopoverAnchorMetrics metrics) {
        final double width = metrics.anchorWidth > _menuMinWidth
            ? metrics.anchorWidth
            : _menuMinWidth;
        // Sized, not aligned: the positioner measures whatever it is given, and
        // an `Align` under loose constraints would hand it the whole boundary.
        return SizedBox(
          width: width,
          child: SelectMenu<T>(
            children: widget.options,
            selected: widget.value,
            highlighted: _highlighted,
            onPick: _commit,
            onHover: (int index) {
              if (_highlighted == index) return;
              setState(() => _highlighted = index);
            },
          ),
        );
      },
    );

    // The dim is on the wrapper — `has-[select:disabled]:opacity-50` — while
    // the control itself only stops taking pointers.
    control = Opacity(
      opacity: _fieldEnabled ? 1 : SurfaceOpacity.disabled,
      child: IgnorePointer(ignoring: !_enabled, child: control),
    );

    return Semantics(
      button: true,
      label: widget.label ?? _scope?.label,
      hint: widget.hint ?? _scope?.describedBy,
      value: shown?.label,
      expanded: _open,
      enabled: _enabled,
      child: control,
    );
  }
}
