/// The shared body of `dropdown-menu.tsx`, `context-menu.tsx` and
/// `menubar.tsx` — three files, one Radix `Menu`, one set of rows.
///
/// The three references are the same primitive under three roots. Radix ships
/// `@radix-ui/react-menu` and wraps it in `DropdownMenu` (a button opens it),
/// `ContextMenu` (a right-click opens it at the pointer) and `Menubar` (a strip
/// of triggers hands the open state between them); every `*Content`,
/// `*Item`, `*Label`, `*Separator`, `*Shortcut`, `*CheckboxItem`,
/// `*RadioItem`, `*Sub*` in the three files is the same element with the same
/// class list under a different `data-slot`. This file is that shared half —
/// the row model, the surface, the geometry, the keyboard — and the three roots
/// live in `dropdown_menu.dart`, `context_menu.dart` and `menubar.dart`.
///
/// ## Geometry, all measured on the live reference at 1440×900
///
/// | part | class | value |
/// |---|---|---|
/// | content | `rounded-lg bg-popover p-2 text-popover-foreground shadow-md ring-1 ring-foreground/10` | 12px radius, 8px inset, Tailwind's stock elevation under a 1px `--foreground`/10 ring |
/// | | `min-w-40` / `min-w-36` | dropdown **160**, context and menubar **144** |
/// | item | `px-3 py-2 gap-2 rounded-md text-sm` | 12 / 8 / 8 / 10px, and a **34.5625px** row |
/// | check row | `py-2 pr-9 pl-3` + `absolute right-3` | a 36px right gutter holding a 16px tick 12px in |
/// | label | `px-3 py-2 text-xs font-medium text-muted-foreground` | 12px/**500** in a 16px line box → a **32px** row |
/// | separator | `-mx-2 my-2 h-px bg-border` | a 1px rule at the full content width, 8px of air each side → **17px** |
/// | shortcut | `ml-auto text-xs tracking-widest text-muted-foreground` | 12px sans at 0.1em, right-aligned |
/// | icons | `[&_svg:not([class*='size-'])]:size-4` | **16px**, `strokeWidth` still 2.4 — selects-map drift 15, again |
///
/// The account dropdown's content is 240 × 236.25: `8 + 48 (a two-line label)
/// + 17 + 3×34.5625 + 17 + 34.5625 + 8`. Every one of those numbers is a static
/// on [DsMenu] so a test can pin the sum rather than the total.
///
/// ## What the probe corrected (2026-08-16)
///
/// Nothing here was transcribed. The rules the class lists could not settle
/// were driven with real input and sampled at ~16.6ms:
///
///  1. **The rows do not transition.** Every menu row computes
///     `transition-property: all` with `transition-duration: 0s`, so the accent
///     highlight is a **snap** in both directions — one frame, no easing. The
///     same answer `DsButton`'s geometry gives, reached the same way.
///  2. **The overlay animates at 320ms on `--ease-out`,** entering from
///     `opacity 0 / scale .95` plus an 8px slide, and leaving on
///     `opacity → 0 / scale → .95` with **no** slide. Identical to
///     [DsPopover]'s own set — except that the slide runs on **all four**
///     sides here (a submenu at `side=right` enters from 8px to its left) and
///     the transform origin is Radix's **corner**, not base-ui's anchor centre.
///  3. **A menu opens on `pointerdown`,** not on the click. Measured: the
///     `enter` animation's start time backdates to the physical press, ~93ms
///     before the `pointerup`.
///  4. **The arrows do not wrap.** `End` then `ArrowDown` stays on the last
///     row; `Home` then `ArrowUp` stays on the first. Radix's `RovingFocusGroup`
///     is mounted with `loop` at its `false` default — the opposite of
///     [DsSelect], whose own menu wraps.
///  5. **Typeahead is real.** Pressing `p` in the open account menu moves the
///     highlight to **Preferences**; the buffer resets after 1s.
///  6. **A submenu opens ~100ms after the pointer enters its trigger**
///     (measured: `pointerover` at 131.7, content mounted between 243 and
///     259.5 — Radix's own `setTimeout(…, 100)` plus a render), and closes as
///     soon as the pointer reaches a sibling row.
///  7. **The highlight recolours the whole row.** At rest the icon is
///     `--muted-foreground` and the shortcut is too; highlighted, both take
///     `--accent-foreground` along with the label. A destructive row keeps
///     `--destructive-ink` for all three and takes `--destructive` at **10%**
///     (light) / **20%** (dark) as its fill.
///
/// DOCUMENTED DRIFT (menus drift 5): **the menubar's check rows put their
/// indicator on the left** (`pl-9 pr-3`, `absolute left-1.5`) while the
/// dropdown's and the context menu's put it on the right (`pr-9 pl-3`,
/// `absolute right-3`). One role, two mirror images, three files.
/// [DsMenuIndicatorSide] is that drift, named.
library;

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../foundation/motion.dart';
import '../foundation/shadows.dart';
import '../foundation/spacing.dart';
import '../foundation/theme.dart';
import '../foundation/typography.dart';
import '../theme_scope.dart';
import 'icon.dart';
import 'icon_paths.dart';
import 'popover.dart';

/// `data-disabled:opacity-50`.
const double _disabledOpacity = 0.50;

/// `data-[variant=destructive]:focus:bg-destructive/10` and its
/// `dark:…:bg-destructive/20` twin — *(measured in both themes)*.
const double _destructiveFillAlpha = 0.10;
const double _destructiveFillAlphaDark = 0.20;

/// How long a hovered `SubTrigger` waits before its content mounts.
///
/// Radix's `MenuSubTrigger` starts `window.setTimeout(open, 100)` on
/// `pointermove` and clears it on `pointerleave`. A dependency's own timer, not
/// a `--duration-*` token — the same standing as `select.tsx`'s 50ms
/// auto-scroll interval.
const Duration _subOpenDelay =
    Duration(milliseconds: 100); // allow-hardcoded: Radix's own submenu timer

/// How long the typeahead buffer survives an idle keyboard.
///
/// Radix's `useTypeaheadSearch` debounces its reset by 1000ms. Also a
/// dependency's constant.
const Duration _typeaheadReset =
    Duration(milliseconds: 1000); // allow-hardcoded: Radix's own typeahead reset

/* ── The row model ───────────────────────────────────────────────────────── */

/// Anything that can sit directly inside a `*MenuContent`.
///
/// Modelled as one sealed family for the reason [DsSelectChild] is: the
/// reference's content is a **child list**, not an array of options, and the
/// geometry, the keyboard order and the highlight all have to walk the same
/// list once.
sealed class DsMenuChild {
  const DsMenuChild();
}

/// Which variant of `*MenuItem` this is — the cva's only axis.
enum DsMenuItemVariant {
  /// `data-variant="default"`.
  normal,

  /// `data-variant="destructive"` — `text-destructive-ink`, and a tinted
  /// highlight instead of `--accent`.
  destructive,
}

/// One `*MenuItem` (`dropdown-menu.tsx:62`, `context-menu.tsx:79`,
/// `menubar.tsx:89` — the same class list three times).
@immutable
class DsMenuItem extends DsMenuChild {
  const DsMenuItem({
    required this.label,
    this.icon,
    this.shortcut,
    this.variant = DsMenuItemVariant.normal,
    this.enabled = true,
    this.inset = false,
    this.onSelect,
  });

  /// The row's text.
  final String label;

  /// The leading `Icon` — `size="sm" tone="subtle"`, which the item's own
  /// `[&_svg:not([class*='size-'])]:size-4` renders at 16.
  final DsIconGlyph? icon;

  /// `*MenuShortcut`'s content — *"a real number in the normal product face"*
  /// as often as a key hint.
  final String? shortcut;

  final DsMenuItemVariant variant;

  /// `data-disabled` — `pointer-events-none opacity-50`.
  final bool enabled;

  /// `data-inset:pl-9` — a 36px leading gutter, for a row that has to line up
  /// under rows that carry icons. Unreachable from the menus page; built
  /// because it is one number.
  final bool inset;

  /// `onSelect`. The menu closes after it, the way Radix's default does.
  final VoidCallback? onSelect;
}

/// One `*MenuCheckboxItem`.
///
/// DOCUMENTED DRIFT (menus drift 6): **both of the page's checkbox menus are
/// controlled with no handler.** `<DropdownMenuCheckboxItem checked>` passes a
/// fixed `checked` and no `onCheckedChange`, so clicking a row closes the menu
/// and the tick never moves — *(probed: the four states read
/// `checked, checked, unchecked, unchecked` before the click and identically
/// after reopening)*. [onSelect] null is that state, and it is the S4
/// "controlled-no-handler" precedent from the selection page, applied to a menu.
@immutable
class DsMenuCheckboxItem extends DsMenuChild {
  const DsMenuCheckboxItem({
    required this.label,
    required this.checked,
    this.enabled = true,
    this.inset = false,
    this.onSelect,
  });

  final String label;

  /// `checked` — the tick's `ItemIndicator` mounts only while this is true.
  /// *(Probed: an unchecked row holds **no** `<svg>` at all.)*
  final bool checked;

  final bool enabled;
  final bool inset;

  /// `onCheckedChange`, called with what the row would become. Null is the
  /// page's own state — see the class doc.
  final ValueChanged<bool>? onSelect;
}

/// One `*MenuRadioItem`, inside a [DsMenuRadioGroup].
@immutable
class DsMenuRadioItem {
  const DsMenuRadioItem({
    required this.value,
    required this.label,
    this.enabled = true,
  });

  final String value;
  final String label;
  final bool enabled;
}

/// `*MenuRadioGroup` — a `value` and the rows that answer to it.
///
/// The group paints nothing; it exists so exactly one row can wear the tick.
/// Same "controlled with no handler" drift as [DsMenuCheckboxItem]: the page's
/// `<DropdownMenuRadioGroup value="value">` has no `onValueChange`.
@immutable
class DsMenuRadioGroup extends DsMenuChild {
  const DsMenuRadioGroup({
    required this.value,
    required this.children,
    this.onChanged,
  });

  final String? value;
  final List<DsMenuRadioItem> children;
  final ValueChanged<String>? onChanged;
}

/// `*MenuLabel` — `px-3 py-2 text-xs font-medium text-muted-foreground`.
///
/// **Weight 500**, which is [DsComponentType.menuHeading] and not
/// [DsComponentType.menuLabel]: `SelectLabel` writes no `font-*` class and
/// inherits 400, this one writes `font-medium`. Same 12px rung, one weight
/// apart — selects-map drift 6, now with a fourth spelling.
@immutable
class DsMenuLabel extends DsMenuChild {
  const DsMenuLabel(this.text, {this.child, this.inset = false});

  /// The label's text, when it is a string. Ignored when [child] is given.
  final String text;

  /// The label's own children, for the account menu's two-line block: a
  /// `--foreground` name over a `.type-micro` line with a 12px tick in it.
  /// It keeps the label's `px-3 py-2`; everything inside is the caller's.
  final Widget? child;

  final bool inset;
}

/// `*MenuSeparator` — `-mx-2 my-2 h-px bg-border`.
///
/// `-mx-2` cancels the content's `p-2`, so the rule runs the **full content
/// width** — *(measured: a 240px content draws a 240px rule)* — and `my-2`
/// puts 8px of air on each side. A 1px line that occupies 17px.
@immutable
class DsMenuSeparator extends DsMenuChild {
  const DsMenuSeparator();
}

/// `*MenuGroup` — a `role="group"` wrapper that paints **nothing**.
///
/// Its whole class list is empty; the rows inside it are flush with the rows
/// outside it. *(Measured: the account menu's group is exactly 3 × 34.5625,
/// with no gap above, below or between.)* It is kept in the model because the
/// reference writes it and because it is where a future `aria-labelledby` would
/// hang.
@immutable
class DsMenuGroup extends DsMenuChild {
  const DsMenuGroup({required this.children});

  final List<DsMenuChild> children;
}

/// `*MenuSub` + its `SubTrigger` and `SubContent` — one nesting level.
///
/// The page's own copy: *"Submenus are allowed one level deep. Anything deeper
/// belongs in a dialog."* Nothing stops a caller nesting further; the rule is
/// editorial, and reproducing it means reproducing the sentence, not adding a
/// depth check the reference does not have.
@immutable
class DsMenuSub extends DsMenuChild {
  const DsMenuSub({
    required this.label,
    required this.children,
    this.icon,
    this.enabled = true,
    this.inset = false,
  });

  final String label;

  /// The `SubContent`'s own children.
  final List<DsMenuChild> children;

  final DsIconGlyph? icon;
  final bool enabled;
  final bool inset;
}

/* ── Geometry ────────────────────────────────────────────────────────────── */

/// Which side of a check row its `ItemIndicator` sits on — menus drift 5.
enum DsMenuIndicatorSide {
  /// `py-2 pr-9 pl-3` with `absolute right-3` — dropdown and context menu.
  end,

  /// `py-2 pr-3 pl-9` with `absolute left-1.5` — the menubar, alone.
  start,
}

/// The numbers every menu row is built out of, and the surface recipes the
/// three files pick from.
///
/// Static rather than instance state for the reason [DsSelect]'s are: an
/// item-aligned placement, a parity test and a page test all need a row's
/// height **before** the row exists.
abstract final class DsMenu {
  /// `py-2` plus one `text-sm` line box — **34.5714**, and the reference
  /// renders 34.5625 (Chrome quantises the 18.5714px line box to 18.5625).
  ///
  /// Read off the type spec, not measured, exactly as [DsSelect.itemHeight] is
  /// and against the same `text-sm` rung — the two menus are the same row.
  static double get itemHeight {
    final DsTypeSpec spec = DsComponentType.sheetBody;
    return (spec.size ?? 0) * (spec.height ?? 1) + ds(2) * 2;
  }

  /// `*MenuLabel`'s `px-3 py-2 text-xs` — 12px in a 16px line box, so **32**.
  static double get labelHeight {
    final DsTypeSpec spec = DsComponentType.menuHeading;
    return (spec.size ?? 0) * (spec.height ?? 1) + ds(2) * 2;
  }

  /// `my-2 h-px` — 8 + 1 + 8 = **17**.
  static double get separatorHeight => DsWidths.hairline + ds(2) * 2;

  /// `p-2` on the content box.
  static double get contentPadding => ds(2);

  /// `min-w-40` — `DropdownMenuContent`'s floor, 160.
  static double get minWidthDropdown => ds(40);

  /// `min-w-36` — `ContextMenuContent`'s and `MenubarContent`'s, 144.
  static double get minWidthMenu => ds(36);

  /// `min-w-40` — `ContextMenuSubContent`'s and `MenubarSubContent`'s.
  static double get minWidthSub => ds(40);

  /// `min-w-24` — `DropdownMenuSubContent`'s, and the only one of the three
  /// that is not 144 or 160. Unreachable from the menus page (no dropdown on it
  /// carries a submenu); recorded because the number is the drift.
  static double get minWidthSubDropdown => ds(24);

  /// `data-inset:pl-9` — 36.
  static double get insetPadding => ds(9);

  /// `[&_svg:not([class*='size-'])]:size-4` — the box every row icon is forced
  /// into, whatever `size` the `Icon` was asked for.
  static double get iconSize => ds(4);

  /// The stroke the *asked-for* `size="sm"` derives, kept while the box is
  /// overruled to 16 — selects-map drift 15, reproduced by construction.
  static double get iconStroke => DsIcon.strokeFor(DsIcon.pxFor(DsIconSize.sm));
}

/* ── The surface ─────────────────────────────────────────────────────────── */

/// The three elevation recipes the menu family writes, which are **not** one
/// recipe.
///
/// DOCUMENTED DRIFT (menus drift 4): a top-level content is `shadow-md ring-1
/// ring-foreground/10`; a dropdown's and a menubar's sub-content are
/// `shadow-lg ring-1 ring-foreground/10`; and `ContextMenuSubContent` alone
/// writes `border` — a real 1px `--border` line that **adds 2px to its box** —
/// with `shadow-lg` and no ring at all. *(Measured: a sub-content holding two
/// 34.5625 rows is 87.125 tall, not 85.125.)*
enum DsMenuSurfaceKind {
  /// `shadow-md ring-1 ring-foreground/10` — every top-level content.
  content,

  /// `shadow-lg ring-1 ring-foreground/10` — `DropdownMenuSubContent` and
  /// `MenubarSubContent`.
  subRinged,

  /// `shadow-lg border` — `ContextMenuSubContent`, alone.
  subBordered,
}

/// The popup box: `rounded-lg bg-popover p-2 text-popover-foreground` plus one
/// of the three elevations.
class DsMenuSurface extends StatelessWidget {
  const DsMenuSurface({
    super.key,
    required this.child,
    this.kind = DsMenuSurfaceKind.content,
  });

  final Widget child;
  final DsMenuSurfaceKind kind;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return switch (kind) {
      // `DsPopoverSurface` already *is* `shadow-md ring-1 ring-foreground/10`
      // over `--popover` at `rounded-lg`; the family's own recipe, reused
      // rather than restated.
      DsMenuSurfaceKind.content => DsPopoverSurface(child: child),
      DsMenuSurfaceKind.subRinged => DsPopoverSurface(
          shadow: DsShadows.tailwindLg,
          child: child,
        ),
      DsMenuSurfaceKind.subBordered => DsPopoverSurface(
          shadow: DsShadows.tailwindLg,
          ring: false,
          border: Border.all(color: theme.border, width: DsWidths.hairline),
          child: child,
        ),
    };
  }
}

/* ── Flattening ──────────────────────────────────────────────────────────── */

/// What kind of row this is.
enum _RowKind { item, checkbox, radio, label, separator, sub }

@immutable
class _Row {
  const _Row({
    required this.kind,
    this.item,
    this.checkbox,
    this.radio,
    this.radioGroup,
    this.label,
    this.sub,
    this.index = -1,
  });

  final _RowKind kind;
  final DsMenuItem? item;
  final DsMenuCheckboxItem? checkbox;
  final DsMenuRadioItem? radio;
  final DsMenuRadioGroup? radioGroup;
  final DsMenuLabel? label;
  final DsMenuSub? sub;

  /// Into [_MenuGeometry.focusable], or −1 for a row the keyboard skips.
  final int index;

  /// Whether the roving focus can land here — every enabled item-like row.
  bool get focusable => index >= 0;

  /// The string typeahead matches against.
  String get text => switch (kind) {
        _RowKind.item => item!.label,
        _RowKind.checkbox => checkbox!.label,
        _RowKind.radio => radio!.label,
        _RowKind.sub => sub!.label,
        _RowKind.label => label!.text,
        _RowKind.separator => '',
      };

  /// The row's own height, for a caller that has to add the menu up before it
  /// is laid out. A [DsMenuLabel] with a custom [DsMenuLabel.child] is
  /// intrinsic and reports its plain-text height instead.
  double get height => switch (kind) {
        _RowKind.item ||
        _RowKind.checkbox ||
        _RowKind.radio ||
        _RowKind.sub =>
          DsMenu.itemHeight,
        _RowKind.label => DsMenu.labelHeight,
        _RowKind.separator => DsMenu.separatorHeight,
      };
}

/// Every row in document order, with the focusable ones indexed.
class _MenuGeometry {
  _MenuGeometry(List<DsMenuChild> children) {
    void walk(List<DsMenuChild> list) {
      for (final DsMenuChild child in list) {
        switch (child) {
          case DsMenuItem():
            _add(_RowKind.item, enabled: child.enabled, item: child);
          case DsMenuCheckboxItem():
            _add(_RowKind.checkbox, enabled: child.enabled, checkbox: child);
          case DsMenuRadioGroup():
            for (final DsMenuRadioItem row in child.children) {
              _add(_RowKind.radio,
                  enabled: row.enabled, radio: row, radioGroup: child);
            }
          case DsMenuSub():
            _add(_RowKind.sub, enabled: child.enabled, sub: child);
          case DsMenuLabel():
            _add(_RowKind.label, enabled: false, label: child);
          case DsMenuSeparator():
            _add(_RowKind.separator, enabled: false);
          // `*MenuGroup` paints nothing and adds nothing — its children are
          // flush with their neighbours, which is why it flattens away here
          // rather than becoming a row.
          case DsMenuGroup():
            walk(child.children);
        }
      }
    }

    walk(children);
  }

  void _add(
    _RowKind kind, {
    required bool enabled,
    DsMenuItem? item,
    DsMenuCheckboxItem? checkbox,
    DsMenuRadioItem? radio,
    DsMenuRadioGroup? radioGroup,
    DsMenuLabel? label,
    DsMenuSub? sub,
  }) {
    final int index = enabled ? focusable.length : -1;
    final _Row row = _Row(
      kind: kind,
      item: item,
      checkbox: checkbox,
      radio: radio,
      radioGroup: radioGroup,
      label: label,
      sub: sub,
      index: index,
    );
    rows.add(row);
    if (enabled) focusable.add(row);
  }

  final List<_Row> rows = <_Row>[];

  /// The rows the roving focus walks — Radix's own set: every enabled item,
  /// check row and sub-trigger, and nothing else.
  final List<_Row> focusable = <_Row>[];

  /// `p-2` + every row + `p-2`.
  double get contentHeight =>
      DsMenu.contentPadding * 2 +
      rows.fold<double>(0, (double sum, _Row row) => sum + row.height);
}

/* ── The content ─────────────────────────────────────────────────────────── */

/// An open `*MenuContent` — the surface, the rows and the keyboard.
///
/// Public because all three roots mount it, and because a submenu mounts one
/// inside another. What it does **not** own is placement: a dropdown hangs off
/// a button, a context menu off a pointer and a menubar's off a strip, and all
/// three hand it to [DsPopover].
class DsMenuContent extends StatefulWidget {
  const DsMenuContent({
    super.key,
    required this.children,
    required this.onClose,
    this.width,
    this.minWidth,
    this.kind = DsMenuSurfaceKind.content,
    this.indicatorSide = DsMenuIndicatorSide.end,
    this.autofocus = true,
    this.initialHighlight = -1,
    this.onEscape,
  });

  /// `*MenuContent`'s children, in DOM order.
  final List<DsMenuChild> children;

  /// Dismisses the whole menu — what a committed row, an Escape or a pointer
  /// outside asks for.
  final VoidCallback onClose;

  /// An explicit `w-*` on the content. **The page passes one on both
  /// dropdowns** (`w-60`, `w-52`), which is why the default width is worth
  /// a note of its own — see [minWidth].
  final double? width;

  /// `min-w-*`. Null takes [DsMenu.minWidthMenu].
  ///
  /// DOCUMENTED DRIFT (menus drift 3): `DropdownMenuContent`'s class list opens
  /// with `w-(--radix-dropdown-menu-trigger-width)` — a menu as wide as the
  /// button that opened it — and **twMerge deletes it** the moment a call site
  /// passes any `w-*`. *(Measured: the resolved class list on both of the
  /// page's dropdowns ends in `w-60` / `w-52` with no `w-(--radix-…)` left in
  /// it.)* Neither of the page's two menus is ever the trigger's width, and the
  /// only way to see the declared behaviour is to write a `DropdownMenu` that
  /// passes no width at all — which the page does not.
  final double? minWidth;

  final DsMenuSurfaceKind kind;

  /// Which side the check rows put their indicator on — menus drift 5.
  final DsMenuIndicatorSide indicatorSide;

  /// Whether this content takes focus when it mounts. False for a submenu
  /// opened by hover: Radix leaves the keyboard on the parent's trigger until
  /// `ArrowRight` moves it.
  final bool autofocus;

  /// Which row the roving focus starts on. **−1 is Radix's own "nothing
  /// focused yet"** — a menu opened by pointer starts there and highlights
  /// only what the pointer touches.
  ///
  /// 0 is what a keyboard opening asks for: `ArrowDown` on a closed trigger,
  /// and `ArrowRight` on a sub-trigger, both land on the first row. Passed as
  /// a prop rather than reached through the child's `GlobalKey`, because the
  /// child does not exist yet at the moment the key is pressed — the portal
  /// mounts at the frame boundary.
  final int initialHighlight;

  /// Escape, when this content has focus. Null routes to [onClose]; a submenu
  /// passes its own so Escape closes **one** level.
  final VoidCallback? onEscape;

  /// The height [children] renders at, `p-2` included — what a caller needs
  /// before the menu exists.
  static double heightOf(List<DsMenuChild> children) =>
      _MenuGeometry(children).contentHeight;

  @override
  State<DsMenuContent> createState() => _DsMenuContentState();
}

class _DsMenuContentState extends State<DsMenuContent> {
  late _MenuGeometry _menu = _MenuGeometry(widget.children);

  final FocusNode _focus = FocusNode(debugLabel: 'DsMenuContent');

  /// The row the roving focus is on, indexed into [_MenuGeometry.focusable].
  /// −1 is Radix's own "nothing focused yet" — a menu opened by pointer starts
  /// there and a menu opened by `ArrowDown` starts at 0.
  late int _highlighted = widget.initialHighlight;

  /// The open submenu's row, if any, and whether the keyboard opened it.
  int? _openSub;
  bool _subFromKeyboard = false;
  Timer? _subTimer;

  /// The typeahead buffer and its reset.
  String _search = '';
  Timer? _searchTimer;

  @override
  void initState() {
    super.initState();
    // `Focus(autofocus:)` is not enough for a **submenu**: the framework only
    // honours autofocus while the enclosing scope has no focused child, and the
    // parent content is holding it. Radix moves focus into the submenu
    // outright on `ArrowRight`, so this asks outright — at the frame boundary,
    // because the node is not attached until the first build is over.
    if (!widget.autofocus) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focus.requestFocus();
    });
  }

  @override
  void didUpdateWidget(DsMenuContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.children, widget.children)) {
      _menu = _MenuGeometry(widget.children);
    }
  }

  @override
  void dispose() {
    _subTimer?.cancel();
    _searchTimer?.cancel();
    _focus.dispose();
    super.dispose();
  }

  // ── the roving focus ────────────────────────────────────────────────────

  /// **No wrap.** *(Probed: `End` then `ArrowDown` stays on "Sign out";
  /// `Home` then `ArrowUp` stays on "Wallet".)* Radix mounts its
  /// `RovingFocusGroup` with `loop` at its `false` default, which is the
  /// opposite of what `DsSelect`'s own menu does.
  void _move(int step) {
    final int count = _menu.focusable.length;
    if (count == 0) return;
    final int from = _highlighted < 0 ? (step > 0 ? -1 : count) : _highlighted;
    final int next = (from + step).clamp(0, count - 1);
    if (next == _highlighted) return;
    _closeSub();
    setState(() => _highlighted = next);
  }

  void _jump(int index) {
    if (index == _highlighted) return;
    _closeSub();
    setState(() => _highlighted = index);
  }

  /// `useTypeaheadSearch` — accumulate, match from the row **after** the
  /// current one so repeated presses of one letter cycle, reset after 1s.
  void _type(String character) {
    _searchTimer?.cancel();
    _searchTimer = Timer(_typeaheadReset, () {
      if (mounted) _search = '';
    });
    _search += character.toLowerCase();

    final List<_Row> rows = _menu.focusable;
    if (rows.isEmpty) return;
    // Radix rotates the candidate list so the search starts after the current
    // item — which is what makes "ppp" walk three rows beginning with p.
    final int start = _highlighted < 0 ? 0 : _highlighted;
    final bool repeat =
        _search.length > 1 && _search.split('').toSet().length == 1;
    final int offset = repeat ? 1 : 0;
    final String needle = repeat ? _search[0] : _search;
    for (int i = 0; i < rows.length; i++) {
      final int at = (start + offset + i) % rows.length;
      if (rows[at].text.toLowerCase().startsWith(needle)) {
        _jump(at);
        return;
      }
    }
  }

  // ── committing ──────────────────────────────────────────────────────────

  /// `onSelect` then `onOpenChange(false)` — Radix closes unless the handler
  /// calls `event.preventDefault()`, and nothing on this page does.
  void _commit(_Row row) {
    switch (row.kind) {
      case _RowKind.item:
        row.item!.onSelect?.call();
      case _RowKind.checkbox:
        row.checkbox!.onSelect?.call(!row.checkbox!.checked);
      case _RowKind.radio:
        row.radioGroup!.onChanged?.call(row.radio!.value);
      case _RowKind.sub:
        // A sub-trigger does not commit; Enter opens it, the same as
        // `ArrowRight`.
        _openSubAt(row.index, focus: true);
        return;
      case _RowKind.label:
      case _RowKind.separator:
        return;
    }
    widget.onClose();
  }

  // ── submenus ────────────────────────────────────────────────────────────

  void _closeSub() {
    _subTimer?.cancel();
    _subTimer = null;
    if (_openSub == null) return;
    setState(() {
      _openSub = null;
      _subFromKeyboard = false;
    });
  }

  void _openSubAt(int index, {required bool focus}) {
    _subTimer?.cancel();
    _subTimer = null;
    if (_openSub == index) return;
    setState(() {
      _openSub = index;
      _subFromKeyboard = focus;
      _highlighted = index;
    });
  }

  /// A pointer resting on a sub-trigger for [_subOpenDelay].
  void _scheduleSub(int index) {
    if (_openSub == index) return;
    _subTimer?.cancel();
    _subTimer = Timer(_subOpenDelay, () {
      if (mounted) _openSubAt(index, focus: false);
    });
  }

  // ── keys ────────────────────────────────────────────────────────────────

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    // While a submenu is open it owns the keyboard; its own `Focus` sees the
    // event first, so anything arriving here belongs to this level.
    final LogicalKeyboardKey key = event.logicalKey;
    final _Row? current = _highlighted >= 0 && _highlighted < _menu.focusable.length
        ? _menu.focusable[_highlighted]
        : null;

    switch (key) {
      case LogicalKeyboardKey.arrowDown:
        _move(1);
      case LogicalKeyboardKey.arrowUp:
        _move(-1);
      case LogicalKeyboardKey.home:
        _move(-_menu.focusable.length);
      case LogicalKeyboardKey.end:
        _move(_menu.focusable.length);
      case LogicalKeyboardKey.arrowRight:
        // *(Probed: `ArrowRight` on "Shipping" opens the submenu and focuses
        // "Add to shipment".)* On any other row it is **not handled here** —
        // it belongs to the menubar's strip, which moves to the next menu.
        if (current?.kind != _RowKind.sub) return KeyEventResult.ignored;
        _openSubAt(current!.index, focus: true);
      case LogicalKeyboardKey.arrowLeft:
        // *(Probed: `ArrowLeft` inside a submenu closes it and puts focus back
        // on "Shipping".)* At the top level it is the menubar's key, so this
        // content lets it past — [DsMenuContent.onEscape] is what tells the two
        // apart, being the thing only a submenu is given.
        if (widget.onEscape == null) return KeyEventResult.ignored;
        widget.onEscape!();
      case LogicalKeyboardKey.enter:
      case LogicalKeyboardKey.numpadEnter:
      case LogicalKeyboardKey.space:
        if (current != null) _commit(current);
      case LogicalKeyboardKey.escape:
        (widget.onEscape ?? widget.onClose)();
      case LogicalKeyboardKey.tab:
        widget.onClose();
      default:
        // `useTypeaheadSearch` takes single printable characters only.
        final String? typed = event.character;
        if (typed == null || typed.length != 1 || typed.trim().isEmpty) {
          return KeyEventResult.ignored;
        }
        _type(typed);
    }
    return KeyEventResult.handled;
  }

  // ── paint ───────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);

    final Widget column = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        for (final _Row row in _menu.rows) _buildRow(context, theme, row),
      ],
    );

    return Focus(
      focusNode: _focus,
      autofocus: widget.autofocus,
      onKeyEvent: _onKey,
      child: _sized(
        DsMenuSurface(
          kind: widget.kind,
          child: Padding(
            // `p-2`, vertical here and per-row horizontally, so a separator's
            // `-mx-2` has something to cancel.
            padding: EdgeInsets.symmetric(vertical: DsMenu.contentPadding),
            child: column,
          ),
        ),
      ),
    );
  }

  /// The popup's own width, which is **`max-content` with a floor**.
  ///
  /// *(Measured: an open dropdown's positioner wrapper computes
  /// `min-width: max-content`, and the content adds `min-w-40` on top.)* So a
  /// menu is as wide as its widest row unless the floor or an explicit `w-*`
  /// says otherwise — never as wide as the viewport, which is what a
  /// stretching `Column` in an overlay would otherwise give.
  Widget _sized(Widget child) {
    final double? width = widget.width;
    if (width != null) return SizedBox(width: width, child: child);
    return ConstrainedBox(
      constraints:
          BoxConstraints(minWidth: widget.minWidth ?? DsMenu.minWidthMenu),
      child: IntrinsicWidth(child: child),
    );
  }

  Widget _pad(Widget child) => Padding(
        padding: EdgeInsets.symmetric(horizontal: DsMenu.contentPadding),
        child: child,
      );

  Widget _buildRow(BuildContext context, DsThemeData theme, _Row row) {
    switch (row.kind) {
      case _RowKind.separator:
        return _MenuSeparator(theme: theme);
      case _RowKind.label:
        return _pad(_MenuLabel(theme: theme, label: row.label!));
      case _RowKind.item:
        final DsMenuItem item = row.item!;
        return _pad(_MenuRow(
          theme: theme,
          label: item.label,
          leading: item.icon,
          shortcut: item.shortcut,
          variant: item.variant,
          enabled: item.enabled,
          inset: item.inset,
          highlighted: row.focusable && row.index == _highlighted,
          onHover: row.focusable ? () => _jump(row.index) : null,
          onTap: row.focusable ? () => _commit(row) : null,
        ));
      case _RowKind.checkbox:
        final DsMenuCheckboxItem item = row.checkbox!;
        return _pad(_MenuRow(
          theme: theme,
          label: item.label,
          checked: item.checked,
          indicatorSide: widget.indicatorSide,
          enabled: item.enabled,
          inset: item.inset,
          highlighted: row.focusable && row.index == _highlighted,
          onHover: row.focusable ? () => _jump(row.index) : null,
          onTap: row.focusable ? () => _commit(row) : null,
        ));
      case _RowKind.radio:
        final DsMenuRadioItem item = row.radio!;
        return _pad(_MenuRow(
          theme: theme,
          label: item.label,
          checked: row.radioGroup!.value == item.value,
          indicatorSide: widget.indicatorSide,
          enabled: item.enabled,
          highlighted: row.focusable && row.index == _highlighted,
          onHover: row.focusable ? () => _jump(row.index) : null,
          onTap: row.focusable ? () => _commit(row) : null,
        ));
      case _RowKind.sub:
        final DsMenuSub sub = row.sub!;
        final bool open = _openSub == row.index;
        // NOT wrapped in `_pad`: the popover anchors to the **row**, and the
        // row is the padded box's child. *(Measured: the submenu's left edge
        // lands on the sub-trigger's right edge — 8px **inside** the parent
        // content's own right edge, which is exactly the `p-2` the row sits
        // in.)* Anchoring to the padding would put it 8px further out.
        final Widget trigger = _MenuRow(
          theme: theme,
          label: sub.label,
          leading: sub.icon,
          trailing: DsIconGlyph.chevronRight,
          enabled: sub.enabled,
          inset: sub.inset,
          // `data-open:bg-accent data-open:text-accent-foreground` — an open
          // sub-trigger is highlighted whether or not the pointer is on it.
          highlighted: open || (row.focusable && row.index == _highlighted),
          onHover: row.focusable
              ? () {
                  _jump(row.index);
                  _scheduleSub(row.index);
                }
              : null,
          onTap: row.focusable
              ? () => _openSubAt(row.index, focus: false)
              : null,
        );
        return _pad(DsPopover(
          open: open,
          anchor: trigger,
          // `MenuSubContent` — `side="right" align="start"`, and *(measured)*
          // its left edge lands exactly on the trigger's right edge: a
          // `sideOffset` of 0.
          side: DsPopoverSide.right,
          align: DsPopoverAlign.start,
          origin: DsPopoverOriginModel.corner,
          slideSides: DsPopoverSide.values.toSet(),
          // One dismissable branch with its parent — see [DsPopoverBarrier].
          barrier: DsPopoverBarrier.none,
          onDismiss: _closeSub,
          content: (BuildContext context, DsPopoverAnchorMetrics metrics) =>
              DsMenuContent(
            children: sub.children,
            kind: widget.kind == DsMenuSurfaceKind.content
                ? DsMenuSurfaceKind.subBordered
                : widget.kind,
            minWidth: DsMenu.minWidthSub,
            indicatorSide: widget.indicatorSide,
            // A submenu opened by `ArrowRight` takes the keyboard and lands on
            // its first row; one opened by hover takes neither — Radix leaves
            // the roving focus on the trigger until a key asks for it.
            autofocus: _subFromKeyboard,
            initialHighlight: _subFromKeyboard ? 0 : -1,
            onClose: widget.onClose,
            // `ArrowLeft`/`Escape` inside a submenu closes **one** level and
            // puts the keyboard back on the trigger.
            onEscape: () {
              _closeSub();
              _focus.requestFocus();
            },
          ),
        ));
    }
  }
}

/* ── Rows ────────────────────────────────────────────────────────────────── */

/// `*MenuLabel` — `px-3 py-2 text-xs font-medium text-muted-foreground`.
class _MenuLabel extends StatelessWidget {
  const _MenuLabel({required this.theme, required this.label});

  final DsThemeData theme;
  final DsMenuLabel label;

  @override
  Widget build(BuildContext context) {
    final Widget body = label.child ??
        DsText(
          label.text,
          DsComponentType.menuHeading,
          color: theme.mutedForeground,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
        );
    return Padding(
      padding: EdgeInsets.only(
        left: label.inset ? DsMenu.insetPadding : ds(3),
        right: ds(3),
        top: ds(2),
        bottom: ds(2),
      ),
      // The label's own `text-xs font-medium text-muted-foreground` is what a
      // custom child inherits — the account menu's first line then overrides
      // the colour with `text-foreground` and its second the whole spec with
      // `.type-micro`, exactly as the markup does.
      child: DefaultTextStyle.merge(
        style: DsText.styleOf(
          context,
          DsComponentType.menuHeading,
          color: theme.mutedForeground,
        ),
        child: body,
      ),
    );
  }
}

/// `*MenuSeparator` — `-mx-2 my-2 h-px bg-border`, `pointer-events-none` on the
/// context menu's and inert everywhere.
class _MenuSeparator extends StatelessWidget {
  const _MenuSeparator({required this.theme});

  final DsThemeData theme;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: ds(2)),
        child: SizedBox(
          height: DsWidths.hairline,
          child: ColoredBox(color: theme.border),
        ),
      ),
    );
  }
}

/// Every clickable row in the family: item, check row, radio row, sub-trigger.
///
/// One widget because one class list — the four differ by which of the three
/// optional slots they fill (a leading glyph, a trailing glyph, an absolutely
/// positioned indicator) and by nothing else.
class _MenuRow extends StatelessWidget {
  const _MenuRow({
    required this.theme,
    required this.label,
    required this.highlighted,
    required this.enabled,
    this.leading,
    this.trailing,
    this.shortcut,
    this.checked,
    this.indicatorSide = DsMenuIndicatorSide.end,
    this.variant = DsMenuItemVariant.normal,
    this.inset = false,
    this.onHover,
    this.onTap,
  });

  final DsThemeData theme;
  final String label;
  final bool highlighted;
  final bool enabled;

  /// The leading `Icon`, forced to 16px by the row's own class list.
  final DsIconGlyph? leading;

  /// `ChevronRightIcon className="ml-auto"` on a sub-trigger.
  final DsIconGlyph? trailing;

  final String? shortcut;

  /// Non-null on a check row; true renders the `ItemIndicator`. A false row
  /// holds **no** indicator element at all, which is what the reference does.
  final bool? checked;

  final DsMenuIndicatorSide indicatorSide;
  final DsMenuItemVariant variant;
  final bool inset;
  final VoidCallback? onHover;
  final VoidCallback? onTap;

  bool get _destructive => variant == DsMenuItemVariant.destructive;

  /// The row's resolved text colour, which every child inherits.
  Color _ink() {
    if (_destructive) return theme.destructiveInk;
    return highlighted ? theme.accentForeground : theme.popoverForeground;
  }

  /// `focus:bg-accent`, or the destructive tint.
  Color? _fill() {
    if (!highlighted) return null;
    if (!_destructive) return theme.accent;
    return theme.destructive.withValues(
      alpha: theme.kind == DsThemeKind.dark
          ? _destructiveFillAlphaDark
          : _destructiveFillAlpha,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color ink = _ink();
    // At rest the leading glyph is `tone="subtle"`; highlighted, the row's
    // `focus:**:text-accent-foreground` recolours it with everything else.
    // A destructive row's is `text-destructive-ink` in both states.
    final Color glyph = _destructive
        ? theme.destructiveInk
        : highlighted
            ? theme.accentForeground
            : theme.mutedForeground;

    final bool check = checked != null;
    final double leadingPad = inset
        ? DsMenu.insetPadding
        : check && indicatorSide == DsMenuIndicatorSide.start
            ? DsMenu.insetPadding
            : ds(3);
    final double trailingPad =
        check && indicatorSide == DsMenuIndicatorSide.end ? ds(9) : ds(3);

    Widget row = Padding(
      // `px-3 py-2`, or the check row's `pr-9 pl-3` / `pr-3 pl-9`.
      padding: EdgeInsets.only(
        left: leadingPad,
        right: trailingPad,
        top: ds(2),
        bottom: ds(2),
      ),
      // `ml-auto` on the trailing slot, expressed as `justify-between` over two
      // groups rather than as an `Expanded` spacer — because the popup is
      // `width: max-content` and a flex spacer would poison the intrinsic width
      // `IntrinsicWidth` reads. Two children and `spaceBetween` put every
      // leftover pixel between the label and the shortcut, which is what
      // `margin-left: auto` does; with one child it is a no-op, which is what a
      // row without a shortcut wants.
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (leading != null) ...<Widget>[
                  // `text-current` under a colour of its own — which is what a
                  // `text-*` utility on an SVG's parent means, and the only way
                  // a lucide glyph is ever coloured.
                  DefaultTextStyle.merge(
                    style: TextStyle(color: glyph),
                    child: DsIcon(
                      leading!,
                      sizePx: DsMenu.iconSize,
                      strokeOverride: DsMenu.iconStroke,
                    ),
                  ),
                  // `gap-2`.
                  SizedBox(width: ds(2)),
                ],
                Flexible(
                  child: DsText(
                    label,
                    DsComponentType.sheetBody,
                    color: ink,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                ),
              ],
            ),
          ),
          if (shortcut != null)
            Padding(
              padding: EdgeInsetsDirectional.only(start: ds(2)),
              child: DsText(
                shortcut!,
                DsComponentType.menuShortcut,
                color:
                    highlighted ? theme.accentForeground : theme.mutedForeground,
                maxLines: 1,
                softWrap: false,
              ),
            ),
          if (trailing != null)
            Padding(
              padding: EdgeInsetsDirectional.only(start: ds(2)),
              // `text-current` — the chevron is the row's own ink, not the
              // muted tone the leading glyph wears.
              child: DsIcon(
                trailing!,
                sizePx: DsMenu.iconSize,
                strokeOverride: DsMenu.iconStroke,
              ),
            ),
        ],
      ),
    );

    row = DecoratedBox(
      decoration: BoxDecoration(
        color: _fill(),
        borderRadius: BorderRadius.circular(DsRadii.md),
      ),
      child: row,
    );

    if (check) {
      row = Stack(
        // `w-full` on the row: without this the stack hands its child loose
        // constraints and the highlight shrink-wraps the label.
        fit: StackFit.passthrough,
        children: <Widget>[
          row,
          if (checked!)
            Positioned.fill(
              child: Align(
                alignment: indicatorSide == DsMenuIndicatorSide.end
                    ? AlignmentDirectional.centerEnd
                    : AlignmentDirectional.centerStart,
                child: Padding(
                  // `absolute right-3` on a 16px box, or the menubar's
                  // `absolute left-1.5`.
                  padding: EdgeInsetsDirectional.only(
                    start: indicatorSide == DsMenuIndicatorSide.start
                        ? ds(1.5)
                        : 0,
                    end: indicatorSide == DsMenuIndicatorSide.end ? ds(3) : 0,
                  ),
                  // The tick is `text-current` too.
                  child: DsIcon(
                    DsIconGlyph.check,
                    sizePx: DsMenu.iconSize,
                    strokeOverride: DsMenu.iconStroke,
                  ),
                ),
              ),
            ),
        ],
      );
    }

    row = SizedBox(height: DsMenu.itemHeight, child: row);
    // The row's resolved `color`, which every `text-current` child reads.
    row = DefaultTextStyle.merge(style: TextStyle(color: ink), child: row);
    row = Opacity(opacity: enabled ? 1 : _disabledOpacity, child: row);

    return Semantics(
      button: true,
      selected: checked,
      enabled: enabled,
      label: label,
      child: MouseRegion(
        // `cursor-default` — a menu row is not a link.
        cursor: SystemMouseCursors.basic,
        onEnter: enabled ? (_) => onHover?.call() : null,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: enabled ? onTap : null,
          child: row,
        ),
      ),
    );
  }
}

/// The one thing the three roots share besides the content: **a menu opens on
/// `pointerdown`.**
///
/// *(Measured: the `enter` animation on the account dropdown backdates to the
/// physical press at t=146.7, 93ms before the `pointerup` at t=240.1.)* Radix's
/// `MenuAnchor`/`Trigger` handles `onPointerDown` and never waits for a click,
/// which is why holding a menu trigger opens the menu under the finger rather
/// than on release.
///
/// Kept as a widget rather than repeated three times, because it is the shape
/// every trigger in the family needs and none of them may express it as an
/// `onPressed`.
class DsMenuPointerDown extends StatelessWidget {
  const DsMenuPointerDown({
    super.key,
    required this.child,
    required this.onPointerDown,
    this.enabled = true,
  });

  final Widget child;
  final VoidCallback onPointerDown;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;
    return Listener(
      onPointerDown: (_) => onPointerDown(),
      child: child,
    );
  }
}

/// The enter/exit set every menu overlay in the family runs, as one record so
/// the three roots cannot drift apart.
///
/// `--duration-overlay` (320ms) on `--ease-out`, entering from `opacity 0`,
/// `scale .95` and an 8px slide **towards the trigger on all four sides**, and
/// leaving on opacity and scale alone.
abstract final class DsMenuMotion {
  /// `data-open:animate-in` and friends.
  static Duration get duration => DsDurations.overlay;

  /// All four `data-[side=*]:slide-in-from-*` utilities.
  static Set<DsPopoverSide> get slideSides => DsPopoverSide.values.toSet();
}
