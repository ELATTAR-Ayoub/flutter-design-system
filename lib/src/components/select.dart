/// `components/ui/select.tsx` — a pill trigger over a socket, and a popover
/// that does not animate.
///
/// Scope, per supervisor ruling F1: **the fidelity the forms page renders** —
/// a working menu with a keyboard, at the trigger, content and item geometry
/// below. The full variant matrix (groups, labels, separators, the two scroll
/// buttons, `position="popper"`) belongs to the `selects` page.
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
/// | content | `min-w-36 rounded-lg bg-popover shadow-md ring-1 ring-foreground/10` | 144, 12px, Tailwind's stock elevation |
/// | viewport | `p-2` | 8 |
/// | item | `py-2 pr-9 pl-3 rounded-md gap-2 text-sm` | 8 / 36 / 12, 10px |
/// | | `focus:bg-accent focus:text-accent-foreground` | the highlighted row |
/// | indicator | `absolute right-3 size-4` | a 16px tick, 12px in |
///
/// **The popover does not animate** (forms-map drift 10). `SelectContent`
/// ships a full `animate-in / fade-in-0 / zoom-in-95 / slide-in-from-*` set and
/// cancels all of it with `data-[align-trigger=true]:animate-none`, because
/// `position` defaults to `"item-aligned"` and the page passes none. The four
/// `translate-*` nudges are `data-[position=popper]`-only and inert for the
/// same reason. What renders is a menu that simply appears; that is what is
/// ported.
///
/// **`item-aligned`** is what that default *does*: the content is placed so the
/// chosen row sits over the trigger, the way a native `<select>` opens. With
/// nothing chosen the first row takes that place.
///
/// DOCUMENTED DRIFT (forms-map drift 11): the trigger's own `w-fit` never
/// applies on the forms page — the vertical `Field`'s `*:w-full` is emitted
/// later at equal specificity and wins, so the trigger renders at the full
/// 448px field width. Both behaviours are reachable: [DsSelect.expand] false is
/// the class, true is the cascade.
///
/// DOCUMENTED DRIFT (forms-map drift 17): `Select` is the only control on the
/// page with `dark:` variants — its dark resting fill is `--input` at 30%, not
/// `--card` like every sibling, and it is the only control anywhere in the form
/// that authors a hover state at all (`dark:hover:bg-input/50`). Light mode has
/// no hover feedback on any control.
///
/// DOCUMENTED DRIFT (forms-map drift 16): `shadow-md` is Tailwind's stock
/// elevation, the only one on the page outside the `--shadow-*` set — fixed
/// black at 10% under a popover whose fill flips with the theme.
library;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../effects/machine_surface.dart';
import '../foundation/motion.dart';
import '../foundation/shadows.dart';
import '../foundation/spacing.dart';
import '../foundation/theme.dart';
import '../foundation/typography.dart';
import '../theme_scope.dart';
import 'button.dart';
import 'field.dart';
import 'icon.dart';
import 'icon_paths.dart';

/// `focus-visible:ring-ring/50`.
const double _focusRingAlpha = 0.50;

/// `aria-invalid:ring-destructive/20`, and `dark:aria-invalid:ring-destructive/40`.
const double _invalidRingAlpha = 0.20;
const double _invalidRingAlphaDark = 0.40;

/// `dark:aria-invalid:border-destructive/50` — the border the dark theme
/// substitutes for the opaque one.
const double _invalidBorderAlphaDark = 0.50;

/// `disabled:opacity-50`.
const double _disabledOpacity = 0.50;

/// `dark:bg-input/30` and `dark:hover:bg-input/50`.
const double _darkFillAlpha = 0.30;
const double _darkHoverFillAlpha = 0.50;

/// `ring-1 ring-foreground/10` on the content.
const double _contentRingAlpha = 0.10;

/// `min-w-36`.
double get _contentMinWidth => ds(36);

/// How close the menu may come to the edge of the viewport before it is nudged
/// back — `--radix-select-content-available-height` reserves the same margin
/// that `collisionPadding` defaults to in Radix.
double get _viewportMargin => ds(2);

/// The two rungs of `data-size` on the trigger.
enum DsSelectSize {
  /// `data-size="sm"` — `h-8`.
  sm,

  /// `data-size="default"` — `h-10`, level with a `DsInput` and a default
  /// `DsButton`. Named [md] because `default` is a Dart keyword.
  md;

  /// The attribute value the reference writes.
  String get label => this == DsSelectSize.md ? 'default' : 'sm';

  /// `h-10` / `h-8`.
  double get height => this == DsSelectSize.md ? ds(10) : ds(8);
}

/// One `SelectItem`.
@immutable
class DsSelectOption<T> {
  const DsSelectOption({
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

/// A select with a real menu.
class DsSelect<T> extends StatefulWidget {
  const DsSelect({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
    this.placeholder,
    this.size = DsSelectSize.md,
    this.enabled = true,
    this.invalid = false,
    this.expand = false,
    this.focusNode,
    this.label,
    this.hint,
  });

  final List<DsSelectOption<T>> options;

  /// `value` — `null` renders [placeholder] under
  /// `data-placeholder:text-muted-foreground`.
  final T? value;

  /// `onValueChange`. `null` disables the trigger.
  final ValueChanged<T>? onChanged;

  /// `SelectValue placeholder="…"`.
  final String? placeholder;

  final DsSelectSize size;

  /// `disabled`. ANDed with the enclosing [DsFieldScope]'s.
  final bool enabled;

  /// `aria-invalid="true"`. ORed with the enclosing [DsFieldScope]'s.
  final bool invalid;

  /// The trigger's own class is `w-fit`; a vertical `Field` overrides it to
  /// `w-full`. False is the class, true is the cascade — see the drift note on
  /// this library.
  final bool expand;

  /// A [DsFieldScope]'s node wins over the owned one and loses to this.
  ///
  /// `FormControl` wraps the **trigger**, not the `Select` — *"the trigger is
  /// the focusable thing, so it is the thing that needs the id"* — which is why
  /// the scope's node lands here and nowhere else in this file.
  final FocusNode? focusNode;

  /// The accessible name.
  final String? label;

  /// `aria-describedby`, resolved: description, then error message.
  final String? hint;

  /// `py-2` plus one `text-sm` line box — the height of one row, and the step
  /// `item-aligned` positioning counts in.
  ///
  /// Read off the type spec rather than measured, because the placement runs
  /// before the menu has ever been laid out: `text-sm` is 13px on Tailwind's
  /// own `--text-sm--line-height`, which `DsLineBox` renders at exactly
  /// `size × height`.
  static double get itemHeight {
    final DsTypeSpec spec = DsComponentType.sheetBody;
    return (spec.size ?? 0) * (spec.height ?? 1) + ds(2) * 2;
  }

  @override
  State<DsSelect<T>> createState() => _DsSelectState<T>();
}

class _DsSelectState<T> extends State<DsSelect<T>> {
  final GlobalKey _triggerKey = GlobalKey();

  FocusNode? _ownedFocusNode;

  /// The enclosing [DsFieldScope], cached on every dependency change so the
  /// pointer and keyboard handlers can read it without depending on an
  /// inherited widget outside a build.
  DsFieldScope? _scope;

  FocusNode get _focusNode =>
      widget.focusNode ??
      _scope?.focusNode ??
      (_ownedFocusNode ??= FocusNode(debugLabel: 'DsSelect'));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scope = DsFieldScope.maybeOf(context);
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
    final int i = widget.options
        .indexWhere((DsSelectOption<T> o) => o.value == widget.value);
    return i < 0 ? 0 : i;
  }

  void _openMenu() {
    if (_open || !_enabled || widget.options.isEmpty) return;
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
    final DsSelectOption<T> option = widget.options[index];
    if (!option.enabled) return;
    _closeMenu();
    widget.onChanged?.call(option.value);
  }

  /// Walks to the next enabled row, wrapping the way Radix's menu does.
  void _move(int step) {
    final int count = widget.options.length;
    int next = _highlighted;
    for (int i = 0; i < count; i++) {
      next = (next + step + count) % count;
      if (widget.options[next].enabled) break;
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
        _highlighted = widget.options.length;
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
  Color _triggerFill(DsThemeData theme) {
    if (theme.kind == DsThemeKind.light) return theme.card;
    return theme.input.withValues(
      alpha: _hovered ? _darkHoverFillAlpha : _darkFillAlpha,
    );
  }

  Color _triggerBorder(DsThemeData theme) {
    if (_invalid) {
      return theme.kind == DsThemeKind.dark
          ? theme.destructive.withValues(alpha: _invalidBorderAlphaDark)
          : theme.destructive;
    }
    if (_focused || _open) return theme.ring;
    return theme.input;
  }

  Color _triggerRing(DsThemeData theme) {
    if (_invalid) {
      return theme.destructive.withValues(
        alpha: theme.kind == DsThemeKind.dark
            ? _invalidRingAlphaDark
            : _invalidRingAlpha,
      );
    }
    return theme.ring
        .withValues(alpha: _focused || _open ? _focusRingAlpha : 0);
  }

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final Duration duration = dsAnimationDuration(context, DsDurations.base);

    DsSelectOption<T>? chosen;
    if (widget.value != null) {
      for (final DsSelectOption<T> option in widget.options) {
        if (option.value != widget.value) continue;
        chosen = option;
        break;
      }
    }

    Widget trigger = TweenAnimationBuilder<Color?>(
      tween: ColorTween(end: _triggerFill(theme)),
      duration: duration,
      curve: DsCurves.out,
      builder: (BuildContext context, Color? fill, Widget? child) =>
          TweenAnimationBuilder<Color?>(
        tween: ColorTween(end: _triggerBorder(theme)),
        duration: duration,
        curve: DsCurves.out,
        builder: (BuildContext context, Color? border, Widget? child) =>
            TweenAnimationBuilder<Color?>(
          tween: ColorTween(end: _triggerRing(theme)),
          duration: duration,
          curve: DsCurves.out,
          builder: (BuildContext context, Color? ring, Widget? child) =>
              DsMachineSurface(
            spec: DsButton.withFocusRing(DsShadows.pressed, ring ?? theme.ring),
            radius: BorderRadius.circular(DsRadii.pill),
            fill: fill ?? theme.card,
            border: Border.all(
              color: border ?? theme.input,
              width: DsWidths.hairline,
            ),
            child: Padding(
              // `pl-4 pr-3.5`. The surface has already paid for the border.
              padding: EdgeInsets.only(left: ds(4), right: ds(3.5)),
              child: child,
            ),
          ),
          child: child,
        ),
        child: child,
      ),
      child: Row(
        // `justify-between` — the value takes the room, the chevron sits out.
        mainAxisSize: widget.expand ? MainAxisSize.max : MainAxisSize.min,
        children: <Widget>[
          Flexible(
            child: DsText(
              chosen?.label ?? widget.placeholder ?? '',
              DsComponentType.sheetBody,
              color: chosen == null ? theme.mutedForeground : theme.foreground,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
            ),
          ),
          // `gap-2`.
          SizedBox(width: ds(2)),
          const DsIcon(DsIconGlyph.chevronDown, tone: DsIconTone.muted),
        ],
      ),
    );

    trigger = SizedBox(
      key: _triggerKey,
      height: widget.size.height,
      width: widget.expand ? double.infinity : null,
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
      opacity: _fieldEnabled ? 1 : _disabledOpacity,
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
  /// The full alignment matrix — `popper`, the six sides, `collisionPadding`,
  /// the two scroll buttons — is the `selects` page's subject; this is the one
  /// arrangement the forms page renders.
  ({Offset origin, double width, double maxHeight}) _placement() {
    final RenderBox trigger =
        _triggerKey.currentContext!.findRenderObject()! as RenderBox;
    final RenderBox overlay = _overlayBox!;

    final Offset topLeft =
        trigger.localToGlobal(Offset.zero, ancestor: overlay);
    final Size screen = overlay.size;
    final double rowHeight = DsSelect.itemHeight;

    // The chosen row's centre lands on the trigger's centre.
    final double wanted = topLeft.dy +
        trigger.size.height / 2 -
        (ds(2) + (_selectedIndex + 0.5) * rowHeight);

    final double height =
        ds(2) * 2 + rowHeight * widget.options.length;
    final double maxHeight = screen.height - _viewportMargin * 2;
    final double top = wanted
        .clamp(_viewportMargin, (screen.height - _viewportMargin - height)
            .clamp(_viewportMargin, double.infinity))
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
    );
  }

  Widget _buildMenu(BuildContext overlayContext) {
    final DsThemeData theme = DsTheme.of(context);
    final ({Offset origin, double width, double maxHeight}) at = _placement();

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
              child: _SelectContent<T>(
                theme: theme,
                options: widget.options,
                selected: widget.value,
                highlighted: _highlighted,
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

/// `SelectContent` + `SelectPrimitive.Viewport`.
class _SelectContent<T> extends StatelessWidget {
  const _SelectContent({
    required this.theme,
    required this.options,
    required this.selected,
    required this.highlighted,
    required this.onPick,
    required this.onHover,
  });

  final DsThemeData theme;
  final List<DsSelectOption<T>> options;
  final T? selected;
  final int highlighted;
  final ValueChanged<int> onPick;
  final ValueChanged<int> onHover;

  @override
  Widget build(BuildContext context) {
    return DsMachineSurface(
      // `shadow-md ring-1 ring-foreground/10`. Tailwind composites its ring
      // slot in front of the shadow slot, which is what prepending the layer
      // means here — the same order `DsButton.withFocusRing` documents.
      spec: DsShadowSpec(<DsShadowLayer>[
        DsShadowLayer(
          0,
          0,
          0,
          DsWidths.hairline,
          (DsThemeData t) => t.foreground.withValues(alpha: _contentRingAlpha),
        ),
        ...DsShadows.tailwindMd.layers,
      ]),
      radius: BorderRadius.circular(DsRadii.lg),
      fill: theme.popover,
      child: Padding(
        // viewport `p-2`.
        padding: EdgeInsets.all(ds(2)),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              for (int i = 0; i < options.length; i++)
                _SelectItem<T>(
                  theme: theme,
                  option: options[i],
                  checked: options[i].value == selected,
                  highlighted: i == highlighted,
                  onTap: () => onPick(i),
                  onHover: () => onHover(i),
                ),
            ],
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

  final DsThemeData theme;
  final DsSelectOption<T> option;
  final bool checked;
  final bool highlighted;
  final VoidCallback onTap;
  final VoidCallback onHover;

  @override
  Widget build(BuildContext context) {
    final Color ink =
        highlighted ? theme.accentForeground : theme.popoverForeground;

    Widget row = DecoratedBox(
      decoration: BoxDecoration(
        // `focus:bg-accent` — Radix moves DOM focus onto the highlighted item,
        // so `:focus` is the highlight.
        color: highlighted ? theme.accent : null,
        borderRadius: BorderRadius.circular(DsRadii.md),
      ),
      child: Padding(
        // `py-2 pr-9 pl-3` — the 36px right gutter is the indicator's room.
        padding: EdgeInsets.only(
          left: ds(3),
          right: ds(9),
          top: ds(2),
          bottom: ds(2),
        ),
        child: DsText(
          option.label,
          DsComponentType.sheetBody,
          color: ink,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
        ),
      ),
    );

    row = Stack(
      children: <Widget>[
        row,
        if (checked)
          Positioned.fill(
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Padding(
                // `absolute right-3` on a `size-4` box.
                padding: EdgeInsets.only(right: ds(3)),
                child: DsIcon(DsIconGlyph.check, sizePx: ds(4)),
              ),
            ),
          ),
      ],
    );

    // The tick is `tone="inherit"` — `text-current` — so it takes whatever the
    // row's own colour resolves to, highlighted or not.
    row = DefaultTextStyle.merge(style: TextStyle(color: ink), child: row);
    row = Opacity(opacity: option.enabled ? 1 : _disabledOpacity, child: row);

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
