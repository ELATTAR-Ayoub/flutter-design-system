/// `components/ui/select.tsx` — a pill trigger over a socket, and a popover
/// that does not animate.
///
/// Phase 3 built this to *"the fidelity the forms page renders"* and named the
/// `selects` page as the owner of the rest. **That promise is now discharged**:
/// all ten `select.tsx` exports are reachable from here. What arrived with the
/// selects page is marked NEW below.
///
/// | part | class | value |
/// |---|---|---|
/// | trigger | `data-[size=default]:h-10` / `:h-8` | 40 / 32 |
/// | | `rounded-pill border border-input bg-card shadow-pressed` | the socket, permanently |
/// | | `py-2 pr-3.5 pl-4 gap-2 text-sm` | 14 right, 16 left, 8 gap, 13px |
/// | | `transition-colors` | **250ms** on `--ease-out` — no duration class, so `--default-transition-duration` and `--default-transition-timing-function` supply both |
/// | | `focus-visible:border-ring focus-visible:ring-3 focus-visible:ring-ring/50` | — |
/// | | `aria-invalid:border-destructive aria-invalid:ring-3 ring-destructive/20` | and it beats focus |
/// | | `data-placeholder:text-muted-foreground` | — |
/// | | chevron | `size-4 text-muted-foreground` |
/// | | NEW `className="w-40"` | an explicit [Select.width] — see the ruling below |
/// | content | `min-w-36 rounded-lg bg-popover shadow-md ring-1 ring-foreground/10` | 144, 12px, Tailwind's stock elevation |
/// | viewport | `p-2` | 8 |
/// | item | `py-2 pr-9 pl-3 rounded-md gap-2 text-sm` | 8 / 36 / 12, 10px |
/// | | `focus:bg-accent focus:text-accent-foreground` | the highlighted row |
/// | indicator | `absolute right-3 size-4` | a 16px tick, 12px in |
/// | NEW label | `px-3 py-2 text-xs text-muted-foreground` | 12px/400 in a 16px line box → a **32px** row |
/// | NEW group | `scroll-my-2` | 8px of scroll margin; it paints nothing |
/// | NEW separator | `-mx-2 my-2 h-px bg-border` | a 1px rule at the **full content width**, 8px of air each side → **17px** |
/// | NEW scroll buttons | `flex items-center justify-center bg-popover py-2` + a 16px chevron | **32px**, opaque, one at each end of the viewport |
///
/// **The popover does not animate** (forms-map drift 10). `SelectContent`
/// ships a full `animate-in / fade-in-0 / zoom-in-95 / slide-in-from-*` set and
/// cancels all of it with `data-[align-trigger=true]:animate-none`, because
/// `position` defaults to `"item-aligned"` and the page passes none. The four
/// `translate-*` nudges are `data-[position=popper]`-only and inert for the
/// same reason. What renders is a menu that simply appears; that is what is
/// ported. Its counterexample now sits in the same package: `Popover` and
/// `Combobox` run the identical class set at 320ms (selects-map drift 9).
///
/// **`item-aligned`** is what that default *does*: the content is placed so the
/// chosen row sits over the trigger, the way a native `<select>` opens. With
/// nothing chosen the first row takes that place.
///
/// Phase 3 computed that placement as `space(2) + (index + 0.5) × itemHeight`,
/// which is only true of a menu whose rows are all items. The selects page's
/// first menu is a label, three items, a separator, a second label and two more
/// items, and its chosen row sits **40px** into the content rather than 17.3
/// (selects-map §4.2). The arithmetic is therefore a running offset over the
/// real flattened list — [SelectGroup] and [SelectSeparator] contribute
/// their own heights to it — and every row kind states its height as a static
/// on [Select] so a test can pin the sum rather than a magic number.
///
/// DOCUMENTED DRIFT (forms-map drift 11, selects-map drift 10): the trigger's
/// own `w-fit` never applies on either page — on the forms page the vertical
/// `Field`'s `*:w-full` is emitted later at equal specificity and wins; in the
/// selects page's state cells `w-40` kills it through twMerge before CSS is
/// consulted. All three widths are reachable here: [Select.expand] false is
/// the class, true is the cascade, and [Select.width] is the utility that
/// beats both — ruling L4 keeps `expand` rather than replacing a documented
/// switch with an enum.
///
/// DOCUMENTED DRIFT (forms-map drift 17, selects-map drift 19): `Select`'s dark
/// resting fill is `--input` at 30%, not `--card` like its siblings, and it
/// authors the only hover state in the family (`dark:hover:bg-input/50`). Light
/// mode has no hover feedback on any control. It is no longer *the only*
/// control with `dark:` variants — `NativeSelect` carries the same four.
///
/// DOCUMENTED DRIFT (forms-map drift 16, selects-map drift 11): `shadow-md` is
/// Tailwind's stock elevation, fixed black at 10% under a popover whose fill
/// flips with the theme. It now carries all three overlays on the selects page,
/// which is why the recipe moved to [PopoverSurface].
///
/// DOCUMENTED PARITY (ruling L5, selects-map drift 18): the "Disabled" state
/// cell ships an empty `<SelectContent />` behind a trigger that cannot open
/// it. [_openMenu] early-returns on a menu with no selectable row, so nothing
/// opens — which is the reference's own answer, reached from the other side.
library;

import 'dart:async';

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
import 'package:flutter/widgets.dart' as flutter show ScrollPosition;

import './surface.dart';
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

/// `focus-visible:ring-ring/50`.
const double _focusRingAlpha = 0.50;

/// `aria-invalid:ring-destructive/20`, and `dark:aria-invalid:ring-destructive/40`.
const double _invalidRingAlpha = 0.20;
const double _invalidRingAlphaDark = 0.40;

/// `dark:aria-invalid:border-destructive/50` — the border the dark theme
/// substitutes for the opaque one.
const double _invalidBorderAlphaDark = 0.50;

/// `dark:bg-input/30` and `dark:hover:bg-input/50`.
const double _darkFillAlpha = 0.30;
const double _darkHoverFillAlpha = 0.50;

/// `min-w-36`.
double get _contentMinWidth => space(36);

/// How close the menu may come to the edge of the viewport before it is nudged
/// back — `--radix-select-content-available-height` reserves the same margin
/// that `collisionPadding` defaults to in Radix.
double get _viewportMargin => space(2);

/// How often a hovered scroll button advances the viewport.
///
/// `SelectScrollButtonImpl` starts a `window.setInterval(onAutoScroll, 50)` on
/// `pointerMove` and clears it on `pointerLeave`; each tick scrolls by one
/// item's height. A dependency's own timer, not a `--duration-*` token.
const Duration _autoScrollTick = Duration(
  milliseconds: 50,
); // allow-hardcoded: Radix's own scroll interval

/// The two rungs of `data-size` on the trigger.
enum SelectSize {
  /// `data-size="sm"` — `h-8`.
  sm,

  /// `data-size="default"` — `h-10`, level with a `Input` and a default
  /// `Button`. Named [md] because `default` is a Dart keyword.
  md;

  /// The attribute value the reference writes.
  String get label => this == SelectSize.md ? 'default' : 'sm';

  /// `h-10` / `h-8`.
  double get height => this == SelectSize.md ? space(10) : space(8);
}

/// Anything that can sit directly inside a `SelectContent`.
///
/// The reference's content is a child list, not an array of options: the
/// selects page writes `<SelectGroup>`, `<SelectSeparator />` and
/// `<SelectItem>` as siblings, and the item-aligned placement has to count all
/// three. Modelling it as one sealed family is what lets [Select] walk the
/// list once and get both the geometry and the keyboard order out of it.
sealed class SelectChild<T> {
  const SelectChild();
}

/// One `SelectItem`.
@immutable
class SelectOption<T> extends SelectChild<T> {
  const SelectOption({
    required this.value,
    required this.label,
    this.enabled = true,
  });

  final T value;

  /// `SelectPrimitive.ItemText`'s content.
  final String label;

  /// `data-disabled:pointer-events-none data-disabled:opacity-50`.
  final bool enabled;
}

/// `SelectGroup` + the `SelectLabel` inside it (`select.tsx:16`, `:94`).
///
/// The two are one type here because the reference never separates them on this
/// page: every `SelectGroup` opens with a `SelectLabel`, and a label outside a
/// group would be a `<div>` in a listbox with nothing to name. The group itself
/// paints nothing — its whole class list is `scroll-my-2`, an 8px scroll margin
/// that only `scrollIntoView` reads, which is why [Select] applies it when
/// the keyboard walks into a grouped row and nowhere else.
@immutable
class SelectGroup<T> extends SelectChild<T> {
  const SelectGroup({this.label, required this.children});

  /// The `SelectLabel`'s text. Null renders a group with no label — legal in
  /// the primitive, unused on the page.
  final String? label;

  final List<SelectOption<T>> children;
}

/// `SelectSeparator` (`select.tsx:131`) — `pointer-events-none -mx-2 my-2 h-px
/// bg-border`.
///
/// `-mx-2` cancels the viewport's `p-2`, so the rule runs the **full content
/// width** rather than the padded one; `my-2` puts 8px of air on each side. A
/// 1px line that occupies 17px, and the reason `(index + 0.5) × itemHeight` was
/// never going to survive this page.
///
/// It carries no value, so its element type is [Never] — which is what makes
/// one `const SelectSeparator()` legal inside a list of options of any type.
@immutable
class SelectSeparator extends SelectChild<Never> {
  const SelectSeparator();
}

/// A select with a real menu.
class Select<T> extends StatefulWidget {
  const Select({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
    this.placeholder,
    this.size = SelectSize.md,
    this.enabled = true,
    this.invalid = false,
    this.expand = false,
    this.width,
    this.focusNode,
    this.label,
    this.hint,
  });

  /// `SelectContent`'s children — items, groups and separators.
  ///
  /// Kept under the name `options` through the widening from
  /// `List<SelectOption<T>>`: a flat list of items is still the common call
  /// and still compiles unchanged, because a `List<SelectOption<T>>` is a
  /// `List<SelectChild<T>>`.
  final List<SelectChild<T>> options;

  /// `value` — `null` renders [placeholder] under
  /// `data-placeholder:text-muted-foreground`.
  final T? value;

  /// `onValueChange`. `null` disables the trigger.
  final ValueChanged<T>? onChanged;

  /// `SelectValue placeholder="…"`.
  final String? placeholder;

  final SelectSize size;

  /// `disabled`. ANDed with the enclosing [FieldScope]'s.
  final bool enabled;

  /// `aria-invalid="true"`. ORed with the enclosing [FieldScope]'s.
  final bool invalid;

  /// The trigger's own class is `w-fit`; a vertical `Field` overrides it to
  /// `w-full`. False is the class, true is the cascade — see the drift note on
  /// this library.
  final bool expand;

  /// A `w-*` utility on the trigger — the selects page's three state cells pass
  /// `w-40`, which twMerge resolves against `w-fit` before CSS is consulted.
  ///
  /// Ruling L4: this is added **beside** [expand] rather than replacing it with
  /// a width enum. `expand` names a documented cascade that a shipped test
  /// pins; a number is a third case, not a third name for the same one. When
  /// both are given, this wins — which is what twMerge does to `w-fit` and what
  /// an explicit width does to `*:w-full`.
  final double? width;

  /// A [FieldScope]'s node wins over the owned one and loses to this.
  ///
  /// `FormControl` wraps the **trigger**, not the `Select` — *"the trigger is
  /// the focusable thing, so it is the thing that needs the id"* — which is why
  /// the scope's node lands here and nowhere else in this file.
  final FocusNode? focusNode;

  /// The accessible name.
  ///
  /// The selects page is the first consumer: its three state-cell triggers
  /// carry `aria-label` and no visible label at all.
  final String? label;

  /// `aria-describedby`, resolved: description, then error message.
  final String? hint;

  /// `py-2` plus one `text-sm` line box — the height of one row, and the step
  /// `item-aligned` positioning counts in.
  ///
  /// Read off the type spec rather than measured, because the placement runs
  /// before the menu has ever been laid out: `text-sm` is 13px on Tailwind's
  /// own `--text-sm--line-height`, which `LineBox` renders at exactly
  /// `size × height`.
  static double get itemHeight {
    final TextStyleToken spec = TextStyles.bodyCompact;
    return (spec.size ?? 0) * (spec.height ?? 1) + space(2) * 2;
  }

  /// `SelectLabel`'s `px-3 py-2 text-xs` — 12px in a 16px line box, so **32**.
  ///
  /// Derived from [TextStyles.menuLabel] for the same reason [itemHeight]
  /// is derived from `sheetBody`: the placement counts this height before the
  /// row exists.
  static double get labelHeight {
    final TextStyleToken spec = TextStyles.menuLabel;
    return (spec.size ?? 0) * (spec.height ?? 1) + space(2) * 2;
  }

  /// `SelectSeparator`'s `my-2 h-px` — 8 + 1 + 8 = **17**.
  static double get separatorHeight => BorderWidths.hairline + space(2) * 2;

  /// `SelectScrollUpButton` / `SelectScrollDownButton` — `py-2` around a 16px
  /// chevron, so **32** each.
  static double get scrollButtonHeight =>
      Icon.pxFor(IconSize.md) + space(2) * 2;

  @override
  State<Select<T>> createState() => _SelectState<T>();
}

class _SelectState<T> extends State<Select<T>> {
  final GlobalKey _triggerKey = GlobalKey();

  FocusNode? _ownedFocusNode;

  /// The enclosing [FieldScope], cached on every dependency change so the
  /// pointer and keyboard handlers can read it without depending on an
  /// inherited widget outside a build.
  FieldScope? _scope;

  FocusNode get _focusNode =>
      widget.focusNode ??
      _scope?.focusNode ??
      (_ownedFocusNode ??= FocusNode(debugLabel: 'Select'));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scope = FieldScope.maybeOf(context);
  }

  // The slot merge (`FormControl`): the scope supplies what the id graph would
  // have wired, and this widget's own props win where both speak.
  bool get _invalid => widget.invalid || (_scope?.invalid ?? false);
  bool get _fieldEnabled => widget.enabled && (_scope?.enabled ?? true);

  OverlayEntry? _entry;

  /// The overlay's own box, captured when the menu opens.
  ///
  /// The entry's builder cannot ask for it: on the first build its context has
  /// no render object yet, and the placement has to be decided before that
  /// build produces one.
  RenderBox? _overlayBox;

  bool _focused = false;
  bool _hovered = false;

  /// The row the keyboard is on. Radix opens with the chosen row highlighted,
  /// or the first when nothing is chosen.
  int _highlighted = 0;

  /// The flattened child list, kept until the caller passes a different one.
  _MenuGeometry<T>? _cachedMenu;

  _MenuGeometry<T> get _menu =>
      _cachedMenu ??= _MenuGeometry<T>(widget.options);

  @override
  void didUpdateWidget(Select<T> old) {
    super.didUpdateWidget(old);
    if (!identical(old.options, widget.options)) _cachedMenu = null;
  }

  bool get _enabled => _fieldEnabled && widget.onChanged != null;
  bool get _open => _entry != null;

  @override
  void dispose() {
    _entry?.remove();
    _entry = null;
    _ownedFocusNode?.dispose();
    super.dispose();
  }

  int get _selectedIndex {
    final int i = _menu.options.indexWhere(
      (SelectOption<T> o) => o.value == widget.value,
    );
    return i < 0 ? 0 : i;
  }

  void _openMenu() {
    // Ruling L5: an empty `<SelectContent />` opens nothing. A content holding
    // only labels and rules has nothing to choose either, so the guard is on
    // the selectable rows rather than on the child list.
    if (_open || !_enabled || _menu.options.isEmpty) return;
    final OverlayState? overlay = Overlay.maybeOf(context);
    final RenderObject? box = overlay?.context.findRenderObject();
    if (overlay == null || box is! RenderBox) return;
    _overlayBox = box;
    _highlighted = _selectedIndex;
    _entry = OverlayEntry(builder: _buildMenu);
    overlay.insert(_entry!);
    setState(() {});
  }

  void _closeMenu({bool restoreFocus = true}) {
    if (!_open) return;
    _entry!.remove();
    _entry = null;
    if (restoreFocus) _focusNode.requestFocus();
    if (mounted) setState(() {});
  }

  void _commit(int index) {
    final SelectOption<T> option = _menu.options[index];
    if (!option.enabled) return;
    _closeMenu();
    widget.onChanged?.call(option.value);
  }

  /// Walks to the next enabled row, wrapping the way Radix's menu does.
  void _move(int step) {
    final int count = _menu.options.length;
    int next = _highlighted;
    for (int i = 0; i < count; i++) {
      next = (next + step + count) % count;
      if (_menu.options[next].enabled) break;
    }
    if (next == _highlighted) return;
    _highlighted = next;
    _entry?.markNeedsBuild();
  }

  KeyEventResult _onTriggerKey(FocusNode node, KeyEvent event) {
    if (!_enabled || event is! KeyDownEvent) return KeyEventResult.ignored;
    final LogicalKeyboardKey key = event.logicalKey;
    if (key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.numpadEnter ||
        key == LogicalKeyboardKey.space ||
        key == LogicalKeyboardKey.arrowDown ||
        key == LogicalKeyboardKey.arrowUp) {
      _openMenu();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  KeyEventResult _onMenuKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowDown:
        _move(1);
      case LogicalKeyboardKey.arrowUp:
        _move(-1);
      case LogicalKeyboardKey.home:
        _highlighted = -1;
        _move(1);
      case LogicalKeyboardKey.end:
        _highlighted = _menu.options.length;
        _move(-1);
      case LogicalKeyboardKey.enter:
      case LogicalKeyboardKey.numpadEnter:
      case LogicalKeyboardKey.space:
        _commit(_highlighted);
      case LogicalKeyboardKey.escape:
      case LogicalKeyboardKey.tab:
        _closeMenu();
      default:
        return KeyEventResult.ignored;
    }
    return KeyEventResult.handled;
  }

  // ── the trigger ──────────────────────────────────────────────────────────

  /// `bg-card`, or `--input` at 30% / 50% on dark. The only hover state any
  /// control on this page authors, and it exists in one theme.
  Color _triggerFill(ThemeTokens theme) {
    if (theme.kind == ResolvedColorMode.light) return theme.card;
    return theme.input.withValues(
      alpha: _hovered ? _darkHoverFillAlpha : _darkFillAlpha,
    );
  }

  Color _triggerBorder(ThemeTokens theme) {
    if (_invalid) {
      return theme.kind == ResolvedColorMode.dark
          ? theme.destructive.withValues(alpha: _invalidBorderAlphaDark)
          : theme.destructive;
    }
    if (_focused || _open) return theme.ring;
    return theme.input;
  }

  Color _triggerRing(ThemeTokens theme) {
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
    // `transition-colors` with no duration class — the framework default.
    final Duration duration = effectiveMotionDuration(
      context,
      MotionDurations.normal,
    );

    // `<label for>` on a select opens it — the trigger is the labelable thing,
    // and clicking its label is clicking the trigger. Null while disabled.
    _scope?.activator?.callback = _enabled ? _openMenu : null;

    SelectOption<T>? chosen;
    if (widget.value != null) {
      for (final SelectOption<T> option in _menu.options) {
        if (option.value != widget.value) continue;
        chosen = option;
        break;
      }
    }

    // `w-fit` unless something beats it: an explicit `w-40` first, then the
    // vertical field's `*:w-full`.
    final bool fills = widget.width != null || widget.expand;

    Widget trigger = TweenAnimationBuilder<Color?>(
      tween: ColorTween(end: _triggerFill(theme)),
      duration: duration,
      curve: MotionCurves.enter,
      builder: (BuildContext context, Color? fill, Widget? child) =>
          TweenAnimationBuilder<Color?>(
            tween: ColorTween(end: _triggerBorder(theme)),
            duration: duration,
            curve: MotionCurves.enter,
            builder: (BuildContext context, Color? border, Widget? child) =>
                TweenAnimationBuilder<Color?>(
                  tween: ColorTween(end: _triggerRing(theme)),
                  duration: duration,
                  curve: MotionCurves.enter,
                  builder: (BuildContext context, Color? ring, Widget? child) =>
                      Surface(
                        spec: Button.withFocusRing(
                          Shadows.inset,
                          ring ?? theme.ring,
                        ),
                        radius: BorderRadius.circular(Radii.full),
                        fill: fill ?? theme.card,
                        border: Border.all(
                          color: border ?? theme.input,
                          width: BorderWidths.hairline,
                        ),
                        child: Padding(
                          // `pl-4 pr-3.5`. The surface has already paid for the border.
                          padding: EdgeInsets.only(
                            left: space(4),
                            right: space(3.5),
                          ),
                          child: child,
                        ),
                      ),
                  child: child,
                ),
            child: child,
          ),
      child: Row(
        // `justify-between` — the value takes the room, the chevron sits out.
        // Said in a comment and not in the layout until this landed: a
        // `Flexible` label shrink-wraps, so a trigger wider than its own text
        // packed both children at the start and left the room after them.
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: fills ? MainAxisSize.max : MainAxisSize.min,
        children: <Widget>[
          Flexible(
            child: StyledText(
              chosen?.label ?? widget.placeholder ?? '',
              TextStyles.bodyCompact,
              color: chosen == null ? theme.mutedForeground : theme.foreground,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
            ),
          ),
          // `gap-2`.
          SizedBox(width: space(2)),
          const Icon(IconGlyph.chevronDown, tone: IconTone.muted),
        ],
      ),
    );

    trigger = SizedBox(
      key: _triggerKey,
      height: widget.size.height,
      width: widget.width ?? (widget.expand ? double.infinity : null),
      child: trigger,
    );

    trigger = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _enabled ? (_open ? _closeMenu : _openMenu) : null,
      child: MouseRegion(
        cursor: _enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: trigger,
      ),
    );

    trigger = Focus(
      focusNode: _focusNode,
      canRequestFocus: _enabled,
      onFocusChange: (bool value) => setState(() => _focused = value),
      onKeyEvent: _onTriggerKey,
      child: trigger,
    );

    trigger = Opacity(
      opacity: _fieldEnabled ? 1 : SurfaceOpacity.disabled,
      child: IgnorePointer(ignoring: !_enabled, child: trigger),
    );

    return Semantics(
      button: true,
      label: widget.label ?? _scope?.label,
      hint: widget.hint ?? _scope?.describedBy,
      value: chosen?.label ?? widget.placeholder,
      expanded: _open,
      enabled: _enabled,
      child: trigger,
    );
  }

  // ── the menu ─────────────────────────────────────────────────────────────

  /// Where `position="item-aligned"` puts the content: the chosen row over the
  /// trigger, clamped so the menu stays on screen.
  ///
  /// The chosen row's centre is `space(2) + Σ(heights of every row above it) +
  /// itemHeight / 2` — labels and separators included, which is the whole of
  /// selects-map §3.2 delta 5. A menu of nothing but items reduces to the
  /// arithmetic phase 3 shipped, so the forms page does not move.
  ///
  /// When the box cannot go where it wants — the clamp moved it — the
  /// **viewport** carries what is left of the alignment: it scrolls by exactly
  /// the distance the clamp stole, capped by its own scroll extent.
  ///
  /// *(Measured on the live reference, 2026-08-15.)* The `s-sort` menu opened
  /// against a trigger with 198px of room above it, wanted its top at 198.26,
  /// was clamped to Radix's own 10px margin, and its viewport came up scrolled
  /// by **32px** — which is its entire scroll extent (270 of content in a 238
  /// viewport), i.e. `clamp(198.26 − 10, 0, 32)`. It also painted a scroll-up
  /// button and no scroll-down button, at that offset. Both are reproduced.
  /// When nothing clamps, `wanted == top` and the offset is 0, which is why the
  /// forms page's flat menus do not move.
  ({Offset origin, double width, double maxHeight, double scroll})
  _placement() {
    final RenderBox trigger =
        _triggerKey.currentContext!.findRenderObject()! as RenderBox;
    final RenderBox overlay = _overlayBox!;

    final Offset topLeft = trigger.localToGlobal(
      Offset.zero,
      ancestor: overlay,
    );
    final Size screen = overlay.size;

    final double triggerCentre = topLeft.dy + trigger.size.height / 2;
    final double chosenCentre = _menu.centreOfOption(_selectedIndex);

    final double height = _menu.contentHeight;
    final double maxHeight = screen.height - _viewportMargin * 2;
    final double wanted = triggerCentre - chosenCentre;

    final double top = wanted
        .clamp(
          _viewportMargin,
          (screen.height - _viewportMargin - height).clamp(
            _viewportMargin,
            double.infinity,
          ),
        )
        .toDouble();

    // `min-w-36`, and never narrower than the thing it is aligned over: an
    // item-aligned menu sits *on* its trigger, so a menu the trigger sticks out
    // of would read as two controls rather than one. The full width matrix —
    // `popper`, `--radix-select-trigger-width`, a content-sized menu — is the
    // `selects` page's subject.
    final double width = trigger.size.width > _contentMinWidth
        ? trigger.size.width
        : _contentMinWidth;

    return (
      origin: Offset(topLeft.dx, top),
      width: width.clamp(0.0, screen.width).toDouble(),
      maxHeight: maxHeight,
      // The alignment the clamp could not pay for. Never negative — a menu
      // pushed *down* by the top margin has its chosen row below the trigger
      // and no amount of scrolling raises it — and the scroll position clamps
      // the far end against its own extent.
      scroll: wanted - top < 0 ? 0 : wanted - top,
    );
  }

  Widget _buildMenu(BuildContext overlayContext) {
    final ({Offset origin, double width, double maxHeight, double scroll}) at =
        _placement();

    return Stack(
      children: <Widget>[
        // Radix renders no scrim, but a pointer anywhere else dismisses.
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _closeMenu,
          ),
        ),
        Positioned(
          left: at.origin.dx,
          top: at.origin.dy,
          width: at.width,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: at.maxHeight),
            child: Focus(
              autofocus: true,
              onKeyEvent: _onMenuKey,
              child: SelectMenu<T>(
                children: widget.options,
                selected: widget.value,
                highlighted: _highlighted,
                initialScrollOffset: at.scroll,
                onPick: _commit,
                onHover: (int index) {
                  if (_highlighted == index) return;
                  _highlighted = index;
                  _entry?.markNeedsBuild();
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// The open menu, flattened: every row in document order with its own height,
/// and the running offset the item-aligned placement counts in.
///
/// Built once per child list and cached on the state, because it is read by the
/// placement (before the menu exists), by the keyboard (which walks only the
/// selectable rows) and by the scroll-into-view (which needs a row's box).
class _MenuGeometry<T> {
  _MenuGeometry(List<SelectChild<T>> children) {
    void add(_Row<T> row) {
      offsets.add(_height);
      rows.add(row);
      _height += row.height;
    }

    for (final SelectChild<T> child in children) {
      switch (child) {
        case SelectOption<T>():
          _rowOfOption.add(rows.length);
          add(_Row<T>.option(child, options.length, scrollMargin: 0));
          options.add(child);
        case SelectGroup<T>():
          // `scroll-my-2` lives on the group, so every row inside it — the
          // label included — carries the margin when it is scrolled to.
          if (child.label != null) {
            add(_Row<T>.label(child.label!, scrollMargin: space(2)));
          }
          for (final SelectOption<T> option in child.children) {
            _rowOfOption.add(rows.length);
            add(_Row<T>.option(option, options.length, scrollMargin: space(2)));
            options.add(option);
          }
        case SelectSeparator():
          add(_Row<T>.separator());
      }
    }
  }

  /// Every row that paints, in document order.
  final List<_Row<T>> rows = <_Row<T>>[];

  /// The top of each row, measured from the first row rather than from the
  /// content box — the viewport's `p-2` is added by whoever asks.
  final List<double> offsets = <double>[];

  /// The selectable rows only: what the value, the keyboard and the tick index
  /// into.
  final List<SelectOption<T>> options = <SelectOption<T>>[];

  final List<int> _rowOfOption = <int>[];

  double _height = 0;

  /// The height of the rows alone.
  double get rowsHeight => _height;

  /// `p-2` + every row + `p-2` — the menu's height when nothing caps it.
  double get contentHeight => space(2) * 2 + _height;

  /// The distance from the content's top edge to the middle of option [i].
  double centreOfOption(int i) =>
      space(2) + offsets[_rowOfOption[i]] + Select.itemHeight / 2;

  /// Option [i]'s box inside the scrolling viewport, `scroll-my-2` included —
  /// what `scrollIntoView` is asked to reveal.
  ({double top, double bottom}) scrollBoxOfOption(int i) {
    final int row = _rowOfOption[i];
    final double margin = rows[row].scrollMargin;
    return (
      top: space(2) + offsets[row] - margin,
      bottom: space(2) + offsets[row] + rows[row].height + margin,
    );
  }
}

/// What kind of row this is, and how tall.
enum _RowKind { option, label, separator }

@immutable
class _Row<T> {
  const _Row._(
    this.kind, {
    this.option,
    this.text,
    this.index = -1,
    this.scrollMargin = 0,
  });

  const _Row.option(
    SelectOption<T> option,
    int index, {
    required double scrollMargin,
  }) : this._(
         _RowKind.option,
         option: option,
         index: index,
         scrollMargin: scrollMargin,
       );

  const _Row.label(String text, {required double scrollMargin})
    : this._(_RowKind.label, text: text, scrollMargin: scrollMargin);

  const _Row.separator() : this._(_RowKind.separator);

  final _RowKind kind;
  final SelectOption<T>? option;
  final String? text;

  /// Into [_MenuGeometry.options], or −1 for a row that cannot be chosen.
  final int index;

  /// `scroll-my-2` on the enclosing `SelectGroup`.
  final double scrollMargin;

  double get height => switch (kind) {
    _RowKind.option => Select.itemHeight,
    _RowKind.label => Select.labelHeight,
    _RowKind.separator => Select.separatorHeight,
  };
}

/// `SelectContent` — the popover surface, the two scroll buttons and the
/// `Viewport` between them.
///
/// Public because ruling L6 makes [NativeSelect] mount it: Flutter has no OS
/// `<select>` list, so the port's own menu is what the native control opens.
/// Everything about it belongs to `select.tsx`; nothing about it belongs to
/// whoever is showing it, which is why the placement stays with the caller.
class SelectMenu<T> extends StatefulWidget {
  const SelectMenu({
    super.key,
    required this.children,
    required this.selected,
    required this.highlighted,
    required this.onPick,
    required this.onHover,
    this.initialScrollOffset = 0,
  });

  /// `SelectContent`'s children, in DOM order.
  ///
  /// The menu flattens them itself rather than taking the caller's geometry:
  /// the flattening is a walk over a handful of records, and a widget that took
  /// a private type could not be mounted from another file — which is exactly
  /// what ruling L6 asks of it.
  final List<SelectChild<T>> children;

  /// The chosen value — the row that wears the tick.
  final T? selected;

  /// The row the keyboard is on, indexed into the selectable rows.
  final int highlighted;

  /// Called with an index into the selectable rows.
  final ValueChanged<int> onPick;
  final ValueChanged<int> onHover;

  /// Where item-aligned placement wants the viewport to start when the content
  /// is too tall to be placed by moving the box.
  final double initialScrollOffset;

  /// The height the child list renders at, `p-2` included — what a caller
  /// needs before the menu exists in order to place it.
  static double heightOf<T>(List<SelectChild<T>> children) =>
      _MenuGeometry<T>(children).contentHeight;

  @override
  State<SelectMenu<T>> createState() => _SelectMenuState<T>();
}

class _SelectMenuState<T> extends State<SelectMenu<T>> {
  late final ScrollController _scroll = ScrollController(
    initialScrollOffset: widget.initialScrollOffset,
  );

  late _MenuGeometry<T> _menu = _MenuGeometry<T>(widget.children);

  /// `canScrollUp` / `canScrollDown` — Radix mounts each button only while the
  /// viewport can move that way, which is why a menu at rest shows the down
  /// cap alone.
  bool _canScrollUp = false;
  bool _canScrollDown = false;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_syncCaps);
    // The extents are unknown until the first layout.
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncCaps());
  }

  @override
  void didUpdateWidget(SelectMenu<T> old) {
    super.didUpdateWidget(old);
    if (!identical(old.children, widget.children)) {
      _menu = _MenuGeometry<T>(widget.children);
    }
    if (old.highlighted != widget.highlighted) {
      _revealHighlighted();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncCaps());
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _syncCaps() {
    if (!mounted || !_scroll.hasClients) return;
    final flutter.ScrollPosition at = _scroll.position;
    final bool up = at.extentBefore > 0;
    final bool down = at.extentAfter > 0;
    if (up == _canScrollUp && down == _canScrollDown) return;
    setState(() {
      _canScrollUp = up;
      _canScrollDown = down;
    });
  }

  /// `scrollIntoView` on the highlighted row, honouring the group's
  /// `scroll-my-2`.
  void _revealHighlighted() {
    if (!_scroll.hasClients) return;
    final int index = widget.highlighted;
    if (index < 0 || index >= _menu.options.length) return;
    final flutter.ScrollPosition at = _scroll.position;
    final ({double top, double bottom}) box = _menu.scrollBoxOfOption(index);
    final double ceiling = at.maxScrollExtent;
    if (box.top < at.pixels) {
      at.jumpTo(box.top.clamp(0, ceiling < 0 ? 0 : ceiling));
    } else if (box.bottom > at.pixels + at.viewportDimension) {
      at.jumpTo(
        (box.bottom - at.viewportDimension).clamp(0, ceiling < 0 ? 0 : ceiling),
      );
    }
  }

  void _scrollBy(double delta) {
    if (!_scroll.hasClients) return;
    final flutter.ScrollPosition at = _scroll.position;
    at.jumpTo((at.pixels + delta).clamp(0, at.maxScrollExtent));
  }

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    return PopoverSurface(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (_canScrollUp)
            _ScrollButton(
              glyph: IconGlyph.chevronUp,
              onScroll: () => _scrollBy(-Select.itemHeight),
            ),
          Flexible(
            child: SingleChildScrollView(
              controller: _scroll,
              // The viewport's `p-2`, on the scrolling box itself so a
              // separator's `-mx-2` has something to cancel. The horizontal
              // half is applied per row instead — see [_SelectSeparator].
              padding: EdgeInsets.symmetric(vertical: space(2)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  for (final _Row<T> row in _menu.rows)
                    switch (row.kind) {
                      _RowKind.option => Padding(
                        padding: EdgeInsets.symmetric(horizontal: space(2)),
                        child: _SelectItem<T>(
                          theme: theme,
                          option: row.option!,
                          checked: row.option!.value == widget.selected,
                          highlighted: row.index == widget.highlighted,
                          onTap: () => widget.onPick(row.index),
                          onHover: () => widget.onHover(row.index),
                        ),
                      ),
                      _RowKind.label => Padding(
                        padding: EdgeInsets.symmetric(horizontal: space(2)),
                        child: _SelectLabel(theme: theme, text: row.text!),
                      ),
                      // `-mx-2` cancels the padding the other rows keep, so the
                      // rule runs the full content width.
                      _RowKind.separator => _SelectSeparator(theme: theme),
                    },
                ],
              ),
            ),
          ),
          if (_canScrollDown)
            _ScrollButton(
              glyph: IconGlyph.chevronDown,
              onScroll: () => _scrollBy(Select.itemHeight),
            ),
        ],
      ),
    );
  }
}

/// `SelectLabel` — `px-3 py-2 text-xs text-muted-foreground`.
class _SelectLabel extends StatelessWidget {
  const _SelectLabel({required this.theme, required this.text});

  final ThemeTokens theme;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: space(3), vertical: space(2)),
      child: StyledText(
        text,
        TextStyles.menuLabel,
        color: theme.mutedForeground,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
      ),
    );
  }
}

/// `SelectSeparator` — `-mx-2 my-2 h-px bg-border`, and `pointer-events-none`
/// so a pointer crossing it never leaves the row it came from.
class _SelectSeparator extends StatelessWidget {
  const _SelectSeparator({required this.theme});

  final ThemeTokens theme;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: space(2)),
        child: SizedBox(
          height: BorderWidths.hairline,
          child: ColoredBox(color: theme.border),
        ),
      ),
    );
  }
}

/// `SelectScrollUpButton` / `SelectScrollDownButton` — `z-10 flex cursor-default
/// items-center justify-center bg-popover py-2`.
///
/// Opaque by class, because it caps a viewport that scrolls underneath it, and
/// `cursor-default` because it is not a button you click: hovering it scrolls,
/// which is the whole of its behaviour.
class _ScrollButton extends StatefulWidget {
  const _ScrollButton({required this.glyph, required this.onScroll});

  final IconGlyph glyph;
  final VoidCallback onScroll;

  @override
  State<_ScrollButton> createState() => _ScrollButtonState();
}

class _ScrollButtonState extends State<_ScrollButton> {
  Timer? _timer;

  void _start() {
    _timer ??= Timer.periodic(_autoScrollTick, (_) => widget.onScroll());
  }

  void _stop() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      onEnter: (_) => _start(),
      onExit: (_) => _stop(),
      child: ColoredBox(
        color: theme.popover,
        child: SizedBox(
          height: Select.scrollButtonHeight,
          child: Center(
            // `tone="inherit"` under the content's `text-popover-foreground`.
            child: Icon(widget.glyph, tone: IconTone.inherit),
          ),
        ),
      ),
    );
  }
}

/// `SelectItem`.
class _SelectItem<T> extends StatelessWidget {
  const _SelectItem({
    required this.theme,
    required this.option,
    required this.checked,
    required this.highlighted,
    required this.onTap,
    required this.onHover,
  });

  final ThemeTokens theme;
  final SelectOption<T> option;
  final bool checked;
  final bool highlighted;
  final VoidCallback onTap;
  final VoidCallback onHover;

  @override
  Widget build(BuildContext context) {
    final Color ink = highlighted
        ? theme.accentForeground
        : theme.popoverForeground;

    Widget row = DecoratedBox(
      decoration: BoxDecoration(
        // `focus:bg-accent` — Radix moves DOM focus onto the highlighted item,
        // so `:focus` is the highlight.
        color: highlighted ? theme.accent : null,
        borderRadius: BorderRadius.circular(Radii.md),
      ),
      child: Padding(
        // `py-2 pr-9 pl-3` — the 36px right gutter is the indicator's room.
        padding: EdgeInsets.only(
          left: space(3),
          right: space(9),
          top: space(2),
          bottom: space(2),
        ),
        child: StyledText(
          option.label,
          TextStyles.bodyCompact,
          color: ink,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
        ),
      ),
    );

    row = Stack(
      // `w-full` on the item. Without this the stack hands its child loose
      // constraints and the row shrinks to its own label — which puts the
      // accent highlight around the text instead of across the menu.
      fit: StackFit.passthrough,
      children: <Widget>[
        row,
        if (checked)
          Positioned.fill(
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Padding(
                // `absolute right-3` on a `size-4` box.
                padding: EdgeInsets.only(right: space(3)),
                child: Icon(IconGlyph.check, sizePx: space(4)),
              ),
            ),
          ),
      ],
    );

    // The tick is `tone="inherit"` — `text-current` — so it takes whatever the
    // row's own colour resolves to, highlighted or not.
    row = DefaultTextStyle.merge(
      style: TextStyle(color: ink),
      child: row,
    );
    row = Opacity(
      opacity: option.enabled ? 1 : SurfaceOpacity.disabled,
      child: row,
    );

    return Semantics(
      button: true,
      selected: checked,
      enabled: option.enabled,
      label: option.label,
      child: MouseRegion(
        cursor: SystemMouseCursors.basic,
        onEnter: option.enabled ? (_) => onHover() : null,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: option.enabled ? onTap : null,
          child: row,
        ),
      ),
    );
  }
}
