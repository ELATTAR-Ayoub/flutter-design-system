/// `components/ui/combobox.tsx` — a select the user can type into, and **the
/// corpus's only `@base-ui/react` component** (selects-map drift 21).
///
/// Everything else in the reference is Radix or bespoke. base-ui brings a
/// second state vocabulary (`data-highlighted` where Radix writes `focus`), a
/// second positioner variable set (`--anchor-width` / `--available-height`
/// where Radix writes `--radix-*`), and a second filter philosophy — an
/// `Intl.Collator` rather than a fuzzy score. All three are ported as they are.
///
/// ## The chassis
///
/// `ComboboxInput` renders an `InputGroup` holding the base-ui input, plus an
/// `InputGroupAddon align="inline-end"` holding an `InputGroupButton
/// size="icon-xs" variant="ghost"` around `ComboboxTrigger`. `showTrigger`
/// defaults **true** and `showClear` defaults **false**, so the clear "×" the
/// component ships is not on this page — drift 23, and the page's own Meta
/// three sections later says *"a date picker with no way back to empty is a
/// trap"*.
///
/// | part | value | source |
/// |---|---|---|
/// | group | **40px** pill, `--input` border, `--card`, `shadow-pressed`, 250ms on shadow + border | *(measured)* |
/// | input | 13px / 18.5714px, `px-4` dropping to **8px** on the addon side | *(measured)* |
/// | addon button | **24 × 24**, radius **7px** ([Radii.addonButton]), `p-0`, ghost, and `data-pressed:bg-transparent` — the one button in the system whose press cancels its own fill | — |
/// | chevron | 16px `--muted-foreground` | — |
///
/// ## The popup, corrected by measurement
///
/// The map derived a **412px** popup from `min-w-[calc(var(--anchor-width) +
/// --spacing(7))]` against a 384px field. *(Measured on the live reference,
/// 2026-08-15: `--anchor-width` reads **344px** and the popup renders
/// **372px**.)* base-ui anchors the positioner to the **`<input>`**, not to the
/// `InputGroup` around it — 384 less two borders, less the end addon's 38 — so
/// the popup is 28px wider than the *input* and 11px **narrower** than the
/// field it hangs under. Drift 22 stands as written (*"always 28px wider than
/// its own input"*) with the anchor identified; the 412 does not.
///
/// That is why [Popover] wraps the input rather than the group: the anchor
/// box is the measured thing, not the visible pill.
///
/// | property | value | source |
/// |---|---|---|
/// | width | `--anchor-width` + `space(7)`, min-width beating width | *(measured 372)* |
/// | radius / fill | 12px, `--popover` | *(measured)* |
/// | elevation | `shadow-md` + 1px `--foreground`/10 ring — [PopoverSurface] | — |
/// | side / align / offset | bottom / start / **6px**, with a real collision flip | *(measured — the live popup flips to `data-side=top` when the room below runs out)* |
/// | animation | **0.32s `cubic-bezier(0.22, 1, 0.36, 1)`** | *(measured — `--duration-overlay` on `--ease-out`, and [MotionDurations.overlayEnter]'s first consumer)* |
/// | list | `p-1`, cap `min(space(72) − space(9), available − space(9))` = 252, scrollbar hidden | *(measured: `p-1`, and the popup's own `max-h` tracking `--available-height`)* |
/// | item | `py-1 pr-8 pl-1.5`, radius 10, gap 8 → **26.571px** | *(measured 26.563)* |
/// | indicator | 16px tick, **8px** from the right — the `Select`'s is 12 | — |
/// | empty | `py-2` centred muted `text-sm` → 34.571px, and the list drops to `p-0` | — |
///
/// **The popup animates and `SelectContent` does not** (drift 9). Both were
/// measured on the same page in the same second: `0.32s … enter` here, `0s
/// none` there. Same design system, same overlay job, opposite answers.
///
/// ## The filter
///
/// base-ui's default, *(source, `internals/filter.js:10–35`)*:
///
/// ```
/// new Intl.Collator(locale, { usage: 'search', sensitivity: 'base',
///                             ignorePunctuation: true })
/// contains(item, query): slide a window of query.length over the item label,
///                        true on the first compare(...) === 0; empty matches all
/// ```
///
/// `sensitivity: 'base'` is case- **and** accent-insensitive;
/// `ignorePunctuation` skips punctuation on both sides. The query is
/// `String(inputValue).trim()` (`AriaCombobox.js:195`). [collatorContains] is
/// that function, and the one bypass with it: in single-selection mode, until
/// the query has changed since the popup opened, the list is **not** narrowed
/// to the already-selected label (`AriaCombobox.js:198`) — so reopening after a
/// pick shows all six sets rather than the one whose name is in the box.
///
/// DIVERGENCE, recorded: ICU's collation table is not in this port and no
/// dependency may be added for it. [collatorContains] folds case and strips
/// the Latin diacritics, which is `sensitivity: 'base'` for the Latin script —
/// every string this page can produce. A script with its own collation rules
/// (Turkish dotless ı, German ß, Japanese kana equivalence) would diverge, and
/// nothing on the ported pages reaches one.
library;

import 'dart:math' as math;

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

import '../../design_system/foundation/motion.dart';
import '../../design_system/foundation/spacing.dart';
import '../../design_system/foundation/surfaces.dart';
import '../../design_system/foundation/theme.dart';
import '../../design_system/foundation/typography.dart';
import '../../design_system/foundation/theme_scope.dart';
import './field.dart';
import './icon.dart';
import './icon_paths.dart';
import './input_group.dart';
import './popover.dart';
import './select.dart';

/// One row of the popup.
///
/// The row **data** — a value, a label, and whether it can be picked — is the
/// same record `SelectItem` carries, so it is the same type; the row **paint**
/// is not, and that lives in this file. Named for the vocabulary of the
/// primitive that renders it.
typedef ComboboxItem<T> = SelectOption<T>;

/// The Latin letters `sensitivity: 'base'` folds together, and what they fold
/// to. Two parallel strings rather than a map, because the pairing *is* the
/// data and a map would let the two halves drift apart.
const String _accented =
    'àáâãäåāăąèéêëēĕėęěìíîïĩīĭįıòóôõöøōŏőùúûüũūŭůűųçćĉċčñńņňýÿŷżźžßæœđðþłŕřśŝşšţťĝğġģĥħĵķĺļľŉ';
const String _folded =
    'aaaaaaaaaeeeeeeeeeiiiiiiiiiooooooooouuuuuuuuuucccccnnnnyyyzzzsaodoptlrrsssstttgggghhjkllln';

/// `ignorePunctuation: true`, plus ICU's variable weighting of whitespace: both
/// classes are skipped on both sides before anything is compared.
final RegExp _skipped = RegExp(r'''[\s!-/:-@\[-`{-~‐-⁞]''');

/// One string as the collator sees it at `sensitivity: 'base'`.
String _fold(String value) {
  final StringBuffer out = StringBuffer();
  for (final int rune in value.toLowerCase().runes) {
    final String ch = String.fromCharCode(rune);
    if (_skipped.hasMatch(ch)) continue;
    final int at = _accented.indexOf(ch);
    out.write(at < 0 ? ch : _folded[at]);
  }
  return out.toString();
}

/// base-ui's default `contains` filter: does [label] contain [query], ignoring
/// case, accents and punctuation?
///
/// The reference slides a window of `query.length` over the label and stops at
/// the first collator match; folding both sides first and asking for a
/// substring is the same question with the same answer, and it does not
/// allocate a window per character.
bool collatorContains(String label, String query) {
  final String needle = _fold(query.trim());
  return needle.isEmpty || _fold(label).contains(needle);
}

/// A select the user can type into.
class Combobox<T> extends StatefulWidget {
  const Combobox({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
    this.placeholder,
    this.emptyLabel,
    this.enabled = true,
    this.invalid = false,
    this.focusNode,
    this.label,
    this.hint,
    this.filter,
  });

  /// The unfiltered list. base-ui's `limit` defaults to −1: no cap.
  final List<ComboboxItem<T>> items;

  /// The selected value. Its label is what the input shows at rest.
  final T? value;

  final ValueChanged<T>? onChanged;

  /// The input's `placeholder` — **"Search card sets"** on the page.
  final String? placeholder;

  /// `ComboboxEmpty`'s copy — **"No matching set."**. Null renders no empty row
  /// at all, which is the component's own behaviour when the slot is not used.
  final String? emptyLabel;

  final bool enabled;
  final bool invalid;
  final FocusNode? focusNode;

  /// The accessible name and description.
  final String? label;
  final String? hint;

  /// Overrides [collatorContains] — base-ui's `filter` prop.
  final bool Function(String label, String query)? filter;

  /// `sideOffset={6}` on the positioner.
  static double get popupOffset => space(1.5);

  /// `min-w-[calc(var(--anchor-width) + --spacing(7))]` — the 28px that beats
  /// `w-(--anchor-width)`.
  static double get popupOvershoot => space(7);

  /// `max-h-[min(calc(--spacing(72) - --spacing(9)), …)]` — the list's own cap,
  /// 252px, before `--available-height` is consulted.
  static double get listMaxHeight => space(72) - space(9);

  /// `py-1` around one `text-sm` line box — **26.571px**.
  static double get itemHeight => TextStyles.body.step.leading + space(1) * 2;

  /// `ComboboxEmpty`'s `py-2` around the same line box — 34.571px, an item row
  /// in every dimension but its padding.
  static double get emptyHeight => TextStyles.body.step.leading + space(2) * 2;

  @override
  State<Combobox<T>> createState() => _ComboboxState<T>();
}

class _ComboboxState<T> extends State<Combobox<T>> {
  final TextEditingController _controller = TextEditingController();

  FocusNode? _ownedFocusNode;
  FieldScope? _scope;

  FocusNode get _focusNode =>
      widget.focusNode ??
      _scope?.focusNode ??
      (_ownedFocusNode ??= FocusNode(debugLabel: 'Combobox'));

  bool _open = false;

  /// `autoHighlight: false` — **nothing is highlighted until an arrow key**, so
  /// −1 is the resting value and not an error.
  int _highlighted = -1;

  /// Whether the query has changed since the popup opened. Until it has, a
  /// single-selection combobox does not narrow to its own selected label
  /// (`AriaCombobox.js:198`).
  bool _typed = false;

  @override
  void initState() {
    super.initState();
    _controller.text = _labelOf(widget.value) ?? '';
  }

  @override
  void didUpdateWidget(Combobox<T> old) {
    super.didUpdateWidget(old);
    if (old.value != widget.value && !_open) {
      _controller.text = _labelOf(widget.value) ?? '';
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scope = FieldScope.maybeOf(context);
  }

  @override
  void dispose() {
    _controller.dispose();
    _ownedFocusNode?.dispose();
    super.dispose();
  }

  bool get _invalid => widget.invalid || (_scope?.invalid ?? false);
  bool get _enabled =>
      widget.enabled && (_scope?.enabled ?? true) && widget.onChanged != null;

  String? _labelOf(T? value) {
    for (final ComboboxItem<T> item in widget.items) {
      if (item.value == value) return item.label;
    }
    return null;
  }

  /// The rows the popup is showing.
  List<ComboboxItem<T>> get _visible {
    final String query = _controller.text.trim();
    // The single-selection bypass: the query is only a filter once the user has
    // touched it. Reopening on a pick shows the whole list.
    if (query.isEmpty || !_typed) return widget.items;
    final bool Function(String, String) match =
        widget.filter ?? collatorContains;
    return widget.items
        .where((ComboboxItem<T> i) => match(i.label, query))
        .toList();
  }

  void _openPopup() {
    if (_open || !_enabled) return;
    setState(() {
      _open = true;
      _typed = false;
      _highlighted = -1;
    });
  }

  void _closePopup({bool restoreText = true}) {
    if (!_open) return;
    setState(() {
      _open = false;
      _highlighted = -1;
      _typed = false;
      // `mode: 'list'` — the input's value never came from the highlight, so
      // closing puts back whatever the selection says it should read.
      if (restoreText) {
        _controller.text = _labelOf(widget.value) ?? '';
      }
    });
  }

  void _onType(String value) {
    setState(() {
      _typed = true;
      _open = _enabled;
      // The filtered list has moved under it; base-ui does not carry a
      // highlight across a query change with `autoHighlight: false`.
      _highlighted = -1;
    });
  }

  void _commit(int index) {
    final List<ComboboxItem<T>> visible = _visible;
    if (index < 0 || index >= visible.length) return;
    final ComboboxItem<T> item = visible[index];
    if (!item.enabled) return;
    _controller.text = item.label;
    setState(() {
      _open = false;
      _highlighted = -1;
      _typed = false;
    });
    widget.onChanged?.call(item.value);
  }

  /// `loop: true` — the arrows wrap **through the input**: past the last row
  /// the highlight comes off the list entirely (−1) before starting again,
  /// which is the APG listbox-with-an-input behaviour base-ui implements.
  void _move(int step) {
    final List<ComboboxItem<T>> visible = _visible;
    final int count = visible.length;
    if (count == 0) return;
    // −1 is a real position in the ring, so the ring is count + 1 long.
    int next = _highlighted;
    for (int i = 0; i <= count; i++) {
      next = next + step;
      if (next >= count) {
        next = -1;
      } else if (next < -1) {
        next = count - 1;
      }
      if (next == -1 || visible[next].enabled) break;
    }
    setState(() => _highlighted = next);
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (!_enabled || event is! KeyDownEvent) return KeyEventResult.ignored;
    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowDown:
        if (!_open) {
          _openPopup();
        } else {
          _move(1);
        }
      case LogicalKeyboardKey.arrowUp:
        if (!_open) {
          _openPopup();
        } else {
          _move(-1);
        }
      case LogicalKeyboardKey.enter:
      case LogicalKeyboardKey.numpadEnter:
        if (!_open || _highlighted < 0) return KeyEventResult.ignored;
        _commit(_highlighted);
      case LogicalKeyboardKey.escape:
        if (!_open) return KeyEventResult.ignored;
        _closePopup();
      default:
        return KeyEventResult.ignored;
    }
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final List<ComboboxItem<T>> visible = _visible;

    // `openOnInputClick: true`.
    //
    // A [Listener] rather than a [GestureDetector]: the field already owns a
    // tap recognizer — the one that summons the keyboard — and two recognizers
    // over the same box put the outer one in the arena against the inner one,
    // where it loses. base-ui binds this to `pointerdown` anyway.
    Widget input = Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: _enabled ? (_) => _openPopup() : null,
      child: InputGroupInput(
        controller: _controller,
        placeholder: widget.placeholder,
        onChanged: _onType,
        label: widget.label,
      ),
    );

    // The positioner anchors to the **input**, which is what makes the popup
    // 28px wider than 344 rather than 28px wider than the pill.
    input = Popover(
      open: _open && _enabled,
      side: PopoverSide.bottom,
      align: PopoverAlign.start,
      sideOffset: Combobox.popupOffset,
      collisionPadding: space(2),
      onDismiss: () => _closePopup(),
      anchor: input,
      content: (BuildContext context, PopoverAnchorMetrics metrics) =>
          _ComboboxPopup<T>(
            width: metrics.anchorWidth + Combobox.popupOvershoot,
            maxHeight: math.min(
              Combobox.listMaxHeight,
              metrics.availableHeight - space(9),
            ),
            items: visible,
            selected: widget.value,
            highlighted: _highlighted,
            emptyLabel: widget.emptyLabel,
            onPick: _commit,
            onHover: (int index) {
              // `highlightItemOnHover: true`.
              if (_highlighted == index) return;
              setState(() => _highlighted = index);
            },
          ),
    );

    Widget group = InputGroup(
      invalid: _invalid,
      enabled: widget.enabled && (_scope?.enabled ?? true),
      focusNode: _focusNode,
      endAddon: InputGroupAddon(
        align: InputGroupAlign.end,
        // The addon holds a button, so it clears at 14 rather than 16. It is
        // not a `InputGroupButton`, so the inference cannot see it — this is
        // the override that prop exists for.
        holdsButton: true,
        child: _ComboboxTriggerButton(
          open: _open,
          onPressed: _enabled
              ? () {
                  if (_open) {
                    _closePopup();
                  } else {
                    _focusNode.requestFocus();
                    _openPopup();
                  }
                }
              : null,
        ),
      ),
      child: input,
    );

    // Above the group, so it is an ancestor of the `EditableText` that holds
    // focus: a key event walks up from the focused node, and this node sees
    // ArrowDown before the text field's own shortcuts turn it into a caret
    // move.
    group = Focus(
      canRequestFocus: false,
      skipTraversal: true,
      onKeyEvent: _onKey,
      child: group,
    );

    return Semantics(
      // `role="combobox"` with `aria-expanded` and `aria-haspopup="listbox"`.
      textField: true,
      expanded: _open,
      label: widget.label ?? _scope?.label,
      hint: widget.hint ?? _scope?.describedBy,
      enabled: _enabled,
      child: group,
    );
  }
}

/// `ComboboxPopup` + `ComboboxList` + the rows inside them.
class _ComboboxPopup<T> extends StatefulWidget {
  const _ComboboxPopup({
    required this.width,
    required this.maxHeight,
    required this.items,
    required this.selected,
    required this.highlighted,
    required this.emptyLabel,
    required this.onPick,
    required this.onHover,
  });

  final double width;
  final double maxHeight;
  final List<ComboboxItem<T>> items;
  final T? selected;
  final int highlighted;
  final String? emptyLabel;
  final ValueChanged<int> onPick;
  final ValueChanged<int> onHover;

  @override
  State<_ComboboxPopup<T>> createState() => _ComboboxPopupState<T>();
}

class _ComboboxPopupState<T> extends State<_ComboboxPopup<T>> {
  final ScrollController _scroll = ScrollController();

  @override
  void didUpdateWidget(_ComboboxPopup<T> old) {
    super.didUpdateWidget(old);
    if (old.highlighted != widget.highlighted) _reveal();
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  /// `scroll-py-1` — the 4px the list keeps around whatever it scrolls to.
  void _reveal() {
    if (!_scroll.hasClients || widget.highlighted < 0) return;
    final flutter.ScrollPosition at = _scroll.position;
    final double top =
        space(1) + widget.highlighted * Combobox.itemHeight - space(1);
    final double bottom = top + Combobox.itemHeight + space(1) * 2;
    final double ceiling = at.maxScrollExtent < 0 ? 0 : at.maxScrollExtent;
    if (top < at.pixels) {
      at.jumpTo(top.clamp(0, ceiling));
    } else if (bottom > at.pixels + at.viewportDimension) {
      at.jumpTo((bottom - at.viewportDimension).clamp(0, ceiling));
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final bool empty = widget.items.isEmpty;

    return SizedBox(
      width: widget.width,
      child: PopoverSurface(
        // `overflow-hidden` on the popup — the list's own corners are square,
        // and it is the popup that rounds them off.
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Radii.lg),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: widget.maxHeight < 0 ? 0 : widget.maxHeight,
            ),
            child: SingleChildScrollView(
              controller: _scroll,
              // `p-1`, and `data-empty:p-0` — the empty row is full-bleed.
              padding: EdgeInsets.all(empty ? 0 : space(1)),
              child: empty
                  ? _ComboboxEmpty(theme: theme, label: widget.emptyLabel)
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        for (int i = 0; i < widget.items.length; i++)
                          _ComboboxRow<T>(
                            theme: theme,
                            item: widget.items[i],
                            checked: widget.items[i].value == widget.selected,
                            highlighted: i == widget.highlighted,
                            onTap: () => widget.onPick(i),
                            onHover: () => widget.onHover(i),
                          ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

/// `ComboboxItem` — `relative flex w-full cursor-default items-center gap-2
/// rounded-md py-1 pr-8 pl-1.5 text-sm data-highlighted:bg-accent
/// data-highlighted:text-accent-foreground`.
class _ComboboxRow<T> extends StatelessWidget {
  const _ComboboxRow({
    required this.theme,
    required this.item,
    required this.checked,
    required this.highlighted,
    required this.onTap,
    required this.onHover,
  });

  final ThemeTokens theme;
  final ComboboxItem<T> item;
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
        color: highlighted ? theme.accent : null,
        borderRadius: BorderRadius.circular(Radii.md),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: space(1.5),
          right: space(8),
          top: space(1),
          bottom: space(1),
        ),
        child: StyledText(
          item.label,
          TextStyles.body,
          color: ink,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
        ),
      ),
    );

    row = Stack(
      // `w-full` on the item — the same reason `_SelectItem` passes its
      // constraints through: a highlight that stops at the label is not the
      // row highlighting.
      fit: StackFit.passthrough,
      children: <Widget>[
        row,
        if (checked)
          Positioned.fill(
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Padding(
                // `absolute right-2` — 8px, where `SelectItem`'s tick sits at
                // 12. Two libraries, two answers, one page.
                padding: EdgeInsets.only(right: space(2)),
                child: Icon(IconGlyph.check, sizePx: space(4)),
              ),
            ),
          ),
      ],
    );

    row = DefaultTextStyle.merge(
      style: TextStyle(color: ink),
      child: row,
    );
    row = Opacity(
      opacity: item.enabled ? 1 : SurfaceOpacity.disabled,
      child: row,
    );

    return Semantics(
      button: true,
      selected: checked,
      enabled: item.enabled,
      label: item.label,
      child: MouseRegion(
        cursor: SystemMouseCursors.basic,
        onEnter: item.enabled ? (_) => onHover() : null,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: item.enabled ? onTap : null,
          child: row,
        ),
      ),
    );
  }
}

/// `ComboboxEmpty` — `hidden w-full justify-center py-2 text-center text-sm
/// text-muted-foreground group-data-empty/combobox-content:flex`.
///
/// It exists only while the popup is `data-empty`, which is why it is built
/// from that state rather than hidden behind a flag.
class _ComboboxEmpty extends StatelessWidget {
  const _ComboboxEmpty({required this.theme, this.label});

  final ThemeTokens theme;
  final String? label;

  @override
  Widget build(BuildContext context) {
    if (label == null) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.symmetric(vertical: space(2)),
      child: StyledText(
        label!,
        TextStyles.body,
        color: theme.mutedForeground,
        align: TextAlign.center,
      ),
    );
  }
}

/// `InputGroupButton size="icon-xs"` wrapping `ComboboxTrigger` — **24 × 24**,
/// radius 7, `p-0`, ghost.
///
/// **Promotion, landed.** This was a local copy of `input-group.tsx`'s
/// `icon-xs` cva rung, written here because the shipped [InputGroupButton]
/// only had the default `xs` rung and its 6px of horizontal padding would have
/// rendered the trigger 28px wide. The rung is now
/// [InputGroupButtonSize.iconXs] and this is a thin call site again: a
/// square, the chevron, and `data-pressed:bg-transparent` through
/// [InputGroupButton.cancelPressFill].
///
/// The collapse changes one pixel of behaviour and the change is a *fix*: the
/// local copy painted the focus ring but not `focus-visible:border-ring`, which
/// the reference's ghost `Button` base carries and the promoted rung does. The
/// trigger is not reachable by keyboard on this page anyway — the input takes
/// the focus and the arrows drive the popup — so the correction is invisible
/// where it matters and right where it does not.
class _ComboboxTriggerButton extends StatelessWidget {
  const _ComboboxTriggerButton({required this.open, required this.onPressed});

  final bool open;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return InputGroupButton(
      size: InputGroupButtonSize.iconXs,
      cancelPressFill: true,
      onPressed: onPressed,
      label: open ? 'Close' : 'Open',
      // `icon-xs` declares no `[&>svg]` size, so the `Button` base's `size-4`
      // stands: 16px, the [Icon] default. `pointer-events-none
      // text-muted-foreground` — the tone is the button's ink, which is what
      // [IconTone.inherit] reads.
      child: const Icon(IconGlyph.chevronDown, tone: IconTone.inherit),
    );
  }
}
