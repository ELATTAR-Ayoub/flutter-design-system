/// `/design-system/components/base/menus`: three roots, one menu.
///
/// The page that `dropdown_menu.dart`, `context_menu.dart`, `menubar.dart` and
/// the shared `menu.dart` were built for. Every specimen on it is live: the
/// account menu opens on a press and closes on a pick, the Columns and Sort
/// menus open real check and radio rows, the card answers a **right**-click and
/// its Shipping row grows a submenu a tenth of a second after the pointer
/// settles on it, and the admin menubar hands one open menu between three
/// triggers on hover.
///
/// ## Drift register: recorded, shipped as written
///
///  1. **The eyebrow says "Base" twice.** `` `${group.title} · Base` `` with
///     `group.title = "Base Components"`. All fourteen base pages.
///  2. **The menubar's triggers overflow the bar they sit in.** The root is
///     `h-8 p-1`: a 24px content box: and every `MenubarTrigger` is `h-8`.
///     *(Measured: root `y=1531.63 h=32`, first trigger `y=1531.63 h=32`, so
///     the padding is spent entirely on overflow.)* Reproduced; the reference
///     writes no `overflow-hidden`, so nothing clips.
///  3. **`MenubarContent` has no exit animation.** Its class list ends at
///     `data-open:zoom-in-95`; the `data-closed:animate-out` trio that
///     `DropdownMenuContent`, `ContextMenuContent` and its own
///     `MenubarSubContent` all carry is absent. A menubar menu zooms in and
///     vanishes.
///  4. **`ContextMenuSubContent` is the one overlay in the corpus that writes
///     `border`** instead of `ring-1 ring-foreground/10`: a real 1px line that
///     costs its box 2px. *(Measured: a submenu holding two 34.5625 rows is
///     87.125 tall, not 85.125.)* Its two siblings in the other files write the
///     ring at the same `shadow-lg`.
///  5. **The menubar's check rows mirror everyone else's.** `MenubarCheckboxItem`
///     is `pr-3 pl-9` with `absolute left-1.5`; `DropdownMenuCheckboxItem` and
///     `ContextMenuCheckboxItem` are `pr-9 pl-3` with `absolute right-3`. One
///     role, two mirror images, three files. Unreachable from this page: no
///     menubar menu carries a check row: and recorded because the three files
///     are otherwise identical.
///  6. **Both check menus are controlled with no handler.**
///     `<DropdownMenuCheckboxItem checked>` and
///     `<DropdownMenuRadioGroup value="value">` pass state and no
///     `onCheckedChange` / `onValueChange`, so clicking a row closes the menu
///     and nothing moves. *(Probed: the four checkbox states read
///     `checked, checked, unchecked, unchecked` before the click and
///     identically after reopening; the radio value never leaves "Highest
///     value".)* This is the selection page's S4 "controlled-no-handler"
///     precedent, in menu form: and it lands under a Panel captioned
///     *"Checkbox items for independent toggles, radio items for one-of-many"*,
///     next to a section that demonstrates neither toggling nor selecting.
///  7. **`DropdownMenuContent`'s declared width is unreachable here.** The class
///     list opens with `w-(--radix-dropdown-menu-trigger-width)`: a menu as
///     wide as the button that opened it: and twMerge deletes it the moment a
///     call site passes any `w-*`. *(Measured: the resolved class list on both
///     of the page's dropdowns ends in `w-60` / `w-52` with no `w-(--radix-…)`
///     left in it.)* Neither menu is ever the trigger's width, and no
///     `DropdownMenu` on the page omits a width, so the declared behaviour
///     never renders.
///  8. **The account trigger does not squish.** `DropdownMenuTrigger` stamps
///     `aria-haspopup="menu"` *(probed on all three)*, which cancels the
///     Button's `active:not-aria-[haspopup]:scale-95`: selects-map drift 20,
///     one component over. Reproduced: every trigger on this page passes
///     [Button.suppressPressScale], and the open fill beside it comes from
///     [MenuTriggerScope] (GAP CLOSED 1 and 2 on [DropdownMenu]).
///  9. **`Icon size="sm"` renders at 16px, not 14.** Every row's
///     `[&_svg:not([class*='size-'])]:size-4` beats the SVG's own attributes
///     while `strokeWidth` stays at the 14px-derived 2.4. Seven sites here;
///     selects-map drift 15, again. The `size="xs"` tick in the account label
///     is the exception that proves it: the label carries no such rule, so it
///     really is 12px.
/// 10. **The menu rows do not transition.** Every one computes
///     `transition-property: all` at `transition-duration: 0s`, so the accent
///     highlight snaps in both directions while the overlay around it runs a
///     320ms zoom. Two motion vocabularies, one component.
/// 11. **The API list names five props and the page demonstrates four.**
///     `ContextMenuSub` is on the card; `DropdownMenuItem variant`,
///     `DropdownMenuShortcut`, `DropdownMenuCheckboxItem` and
///     `DropdownMenuRadioGroup` are all shown: but the Rules Note below
///     promises *"the same rhythm … applied to Dropdown, Context Menu, Menubar,
///     Select and Command"* and the last two live on other pages, where the
///     reader cannot compare them.
/// 12. **`Avatar`'s ring is a no-op composite.** Its `after:` pseudo-element
///     paints a 1px `--border` circle under `mix-blend-darken` (light) /
///     `mix-blend-lighten` (dark), over a `--muted` fill. `darken(#e4e4e7,
///     #f4f4f5)` is `#e4e4e7` and `lighten(#27272a, #27272a)` is `#27272a`, so
///     in both themes the blend resolves to the border colour itself: the
///     ring is exactly a plain 1px `--border`, and the two blend modes are
///     ceremony. Reproduced as the plain border they compute to.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart'
    hide
        AspectRatio,
        Form,
        FormField,
        Icon,
        OverlayPortal,
        RadioGroup,
        RichText,
        SafeArea,
        ScrollPosition,
        Table,
        TableColumnWidth;

import '../kit.dart';
import '../nav.dart';

/* ── Page constants ──────────────────────────────────────────────────────── */

/// `max-w-xs`, `--container-xs`, 20rem. The context-menu card.
// allow-hardcoded: framework container scale with no token to read it from.
const double _measureXs = 320;

/// `className="w-60"` on the account menu, 240.
double get _accountMenuWidth => space(60);

/// `className="w-52"` on the Columns and Sort menus, 208.
double get _optionMenuWidth => space(52);

/// `size-7` on the avatar, 28, one off the component's own `size-8` default.
double get _avatarSize => space(7);

/// `h-40` on the card.
double get _cardHeight => space(40);

/// `mt-5`: the caption under every specimen.
double get _captionGap => space(5);

/* ── Page ────────────────────────────────────────────────────────────────── */

class MenusPage extends StatelessWidget {
  const MenusPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CategoryHit here = findCategory('base', 'menus');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        PageHeader(
          // DRIFT 1.
          eyebrow: '${here.group.title} · Base',
          title: here.category.title,
          blurb: here.category.blurb,
          contents: here.category.contents,
        ),
        const _DropdownSection(),
        const _ContextSection(),
        const _MenubarSection(),
        const _ApiSection(),
        const _RulesSection(),
        const PageFootNav(groupId: 'base', slug: 'menus'),
      ],
    );
  }
}

/// The `<p className="type-small mt-5">` under every specimen.
class _Caption extends StatelessWidget {
  const _Caption(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(top: _captionGap),
    child: StyledText(text, TextStyles.small),
  );
}

/* ── §1 · dropdown ───────────────────────────────────────────────────────── */

class _DropdownSection extends StatelessWidget {
  const _DropdownSection();

  /// `<DropdownMenuLabel>` is a two-line block here, not a string: a
  /// `--foreground` name over a `.type-micro` line with a 12px verified tick in
  /// it. The rest of the menu is four rows and two rules.
  static List<MenuChild> _account(BuildContext context) => <MenuChild>[
    const MenuLabel('voidwing', child: _AccountLabel()),
    const MenuSeparator(),
    // `DropdownMenuGroup`: a `role="group"` that paints nothing.
    const MenuGroup(
      children: <MenuChild>[
        MenuItem(
          label: 'Wallet',
          icon: IconGlyph.wallet,
          // *"The balance rides in the shortcut slot on the right: a real
          // number in the normal product face with tabular numerals"*, says
          // the caption. The class is `text-xs tracking-widest` **sans**;
          // the caption describes a face the slot does not use.
          shortcut: r'$1,204.80',
        ),
        MenuItem(label: 'Favourites', icon: IconGlyph.heart),
        MenuItem(label: 'Preferences', icon: IconGlyph.settings),
      ],
    ),
    const MenuSeparator(),
    const MenuItem(
      label: 'Sign out',
      icon: IconGlyph.logOut,
      variant: MenuItemVariant.destructive,
    ),
  ];

  /// `<DropdownMenuCheckboxItem checked>` ×2 then ×2 unchecked, with no
  /// handler, DRIFT 6.
  static const List<MenuChild> _columns = <MenuChild>[
    MenuLabel('Visible columns'),
    MenuSeparator(),
    MenuCheckboxItem(label: 'Rarity', checked: true),
    MenuCheckboxItem(label: 'Value', checked: true),
    MenuCheckboxItem(label: 'Condition', checked: false),
    MenuCheckboxItem(label: 'Acquired', checked: false),
  ];

  /// `<DropdownMenuRadioGroup value="value">`, also handler-free.
  static const List<MenuChild> _sort = <MenuChild>[
    MenuLabel('Sort cards by'),
    MenuSeparator(),
    MenuRadioGroup(
      value: 'value',
      children: <MenuRadioItem>[
        MenuRadioItem(value: 'value', label: 'Highest value'),
        MenuRadioItem(value: 'rarity', label: 'Rarity'),
        MenuRadioItem(value: 'recent', label: 'Recently acquired'),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Section(
      id: 'dropdown',
      title: 'Dropdown Menu',
      description:
          'The account menu in the top navigation is the most-used '
          'instance. Destructive items sit last, below a separator, so a '
          'mis-click cannot reach them.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Panel(
            label: 'Account dropdown',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                DropdownMenu(
                  width: _accountMenuWidth,
                  children: _account(context),
                  trigger: const _AccountTrigger(),
                ),
                const _Caption(
                  'The balance rides in the shortcut slot on the right: a '
                  'real number in the normal product face with tabular '
                  'numerals, not decoration.',
                ),
              ],
            ),
          ),
          // `className="mt-4"`.
          SizedBox(height: space(4)),
          Panel(
            label: 'Checkbox and radio items',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // `flex flex-wrap gap-3`.
                Wrap(
                  spacing: space(3),
                  runSpacing: space(3),
                  children: <Widget>[
                    DropdownMenu(
                      width: _optionMenuWidth,
                      children: _columns,
                      trigger: const _OutlineTrigger('Columns'),
                    ),
                    DropdownMenu(
                      width: _optionMenuWidth,
                      children: _sort,
                      trigger: const _OutlineTrigger('Sort'),
                    ),
                  ],
                ),
                const _Caption(
                  'Checkbox items for independent toggles, radio items for '
                  'one-of-many. The same rule as the selection controls, in '
                  'menu form.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// `DropdownMenuTrigger asChild` over a `Button variant="ghost"` carrying
/// `gap-2.5 px-2`: an avatar, a name, and a button that never squishes
/// (DRIFT 8).
class _AccountTrigger extends StatelessWidget {
  const _AccountTrigger();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Button(
      variant: ButtonVariant.ghost,
      // The two attributes `asChild` merges into this element. `aria-haspopup`
      // is a constant of the arrangement, DRIFT 8, the trigger does not
      // squish: and `aria-expanded` is the menu's own state, read from the
      // scope [DropdownMenu] publishes it on: `ghost` holds
      // `bg-secondary text-foreground` for as long as the menu is open,
      // pointer or no pointer.
      suppressPressScale: true,
      expanded: MenuTriggerScope.openOf(context),
      // `px-2` beats the `default` rung's own `px-4` through twMerge.
      padding: EdgeInsets.symmetric(horizontal: space(2)),
      // The menu opens on **pointer-down**, one level up in
      // `MenuPointerDown`: Radix's trigger never waits for the click. This
      // handler is the `asChild` arrangement itself: the page's `<Button>` has
      // no `onClick` of its own and is enabled all the same, and a `null` here
      // would dim it to 45% and stop the press ever reaching the trigger.
      onPressed: () {},
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const _Avatar('VW'),
          // `gap-2.5`, 10, not the rung's own 8.
          SizedBox(width: space(2.5)),
          // `<span className="type-small text-foreground">`. Flexible so a
          // narrow phone at 200% text can shrink the name instead of
          // overflowing the trigger; the desktop column never gets this
          // narrow, so it never sees the ellipsis.
          Flexible(
            child: StyledText(
              'voidwing',
              TextStyles.small,
              color: theme.foreground,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/// `<Button variant="outline">`: the Columns and Sort triggers.
class _OutlineTrigger extends StatelessWidget {
  const _OutlineTrigger(this.label);

  final String label;

  @override
  Widget build(BuildContext context) => Button(
    variant: ButtonVariant.outline,
    // See [_AccountTrigger]: the press is handled on pointer-down, and
    // the same two `asChild` attributes land here. `outline`'s open fill is
    // `aria-expanded:bg-muted`, which is its hover fill.
    suppressPressScale: true,
    expanded: MenuTriggerScope.openOf(context),
    onPressed: () {},
    child: StyledText(label, TextStyles.nav),
  );
}

/// `<Avatar className="size-7"><AvatarFallback className="type-num-sm">`.
///
/// DRIFT 12: the component's `after:` ring is a 1px `--border` circle under
/// `mix-blend-darken` / `mix-blend-lighten` over a `--muted` fill, and in both
/// themes that blend resolves to the border colour itself. What is drawn is a
/// plain 1px `--border`.
class _Avatar extends StatelessWidget {
  const _Avatar(this.initials);

  final String initials;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return SizedBox(
      width: _avatarSize,
      height: _avatarSize,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.muted,
          shape: BoxShape.circle,
          border: Border.all(color: theme.border, width: BorderWidths.hairline),
        ),
        child: Center(
          // `className="type-num-sm"` beats `AvatarFallback`'s own `text-sm`.
          child: StyledText(
            initials,
            TextStyles.numberSm,
            color: theme.mutedForeground,
          ),
        ),
      ),
    );
  }
}

/// The account menu's `DropdownMenuLabel` body: two lines, and the second one
/// carries a 12px success tick.
class _AccountLabel extends StatelessWidget {
  const _AccountLabel();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // `<span className="block text-foreground">`: no `font-*` of its own,
        // so it inherits the label's own 12px / 500.
        StyledText('voidwing', TextStyles.small, color: theme.foreground),
        // `mt-1`.
        SizedBox(height: space(1)),
        // `<span className="type-micro mt-1 flex items-center gap-1.5">`.
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // `size="xs"`: and the label carries no `size-4` rule, so this
            // one really is 12px. DRIFT 9's exception.
            const Icon(
              IconGlyph.shieldCheck,
              size: IconSize.xs,
              tone: IconTone.success,
            ),
            // `gap-1.5`.
            SizedBox(width: space(1.5)),
            StyledText('Verified · Rank 24', TextStyles.small),
          ],
        ),
      ],
    );
  }
}

/* ── §2 · context ────────────────────────────────────────────────────────── */

class _ContextSection extends StatelessWidget {
  const _ContextSection();

  static const List<MenuChild> _stash = <MenuChild>[
    MenuItem(label: 'Favourite', icon: IconGlyph.heart, shortcut: 'F'),
    MenuItem(label: 'Share pull', icon: IconGlyph.share2),
    MenuSub(
      label: 'Shipping',
      icon: IconGlyph.truck,
      children: <MenuChild>[
        MenuItem(label: 'Add to shipment'),
        MenuItem(label: 'Ship immediately'),
      ],
    ),
    MenuSeparator(),
    MenuItem(
      label: r'Sell for $1,240.00',
      icon: IconGlyph.trash2,
      variant: MenuItemVariant.destructive,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Section(
      id: 'context',
      title: 'Context Menu',
      description:
          'Right-click on a card in the Stash. It is always a '
          'shortcut to actions that exist elsewhere too: never the only route '
          'to something.',
      child: Panel(
        label: 'Right-click the card',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ContextMenu(
              // `className="w-56"`.
              width: space(56),
              children: _stash,
              child: const _StashCard(),
            ),
            const _Caption(
              'Submenus are allowed one level deep. Anything deeper belongs in '
              'a dialog.',
            ),
          ],
        ),
      ),
    );
  }
}

/// The right-clickable specimen: `grid h-40 max-w-xs cursor-context-menu
/// place-items-center rounded-lg border border-border bg-card`.
class _StashCard extends StatelessWidget {
  const _StashCard();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: _measureXs),
      // `h-40` in the reference is a fixed height for the reference's own
      // fixed text scale; a minimum instead of an exact height keeps that
      // reading at normal scale while letting scaled-up text grow the card
      // instead of overflowing it.
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: _cardHeight),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: theme.card,
            borderRadius: BorderRadius.circular(Radii.lg),
            border: Border.all(
              color: theme.border,
              width: BorderWidths.hairline,
            ),
          ),
          // `place-items-center` on a one-cell grid.
          child: Center(
            // `<div className="text-center">`.
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                StyledText(
                  'Voidwing Ascendant',
                  TextStyles.h4,
                  color: theme.foreground,
                  align: TextAlign.center,
                ),
                // `mt-2`.
                SizedBox(height: space(2)),
                StyledText(
                  'Legendary',
                  TextStyles.small,
                  color: theme.premiumText,
                  align: TextAlign.center,
                ),
                // `mt-3`.
                SizedBox(height: space(3)),
                StyledText(
                  'Right-click me',
                  TextStyles.small,
                  align: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/* ── §3 · menubar ────────────────────────────────────────────────────────── */

class _MenubarSection extends StatelessWidget {
  const _MenubarSection();

  static const List<MenubarMenu> _admin = <MenubarMenu>[
    MenubarMenu(
      label: 'Packs',
      children: <MenuChild>[
        MenuItem(label: 'New pack', shortcut: '⌘N'),
        MenuItem(label: 'Import card set'),
        MenuSeparator(),
        MenuItem(label: 'Publish queue'),
      ],
    ),
    MenubarMenu(
      label: 'Users',
      children: <MenuChild>[
        MenuItem(label: 'Search users'),
        MenuItem(label: 'Verification queue'),
      ],
    ),
    MenubarMenu(
      label: 'Wallet',
      children: <MenuChild>[
        MenuItem(label: 'Withdrawal approvals'),
        MenuItem(label: 'Transaction audit'),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Section(
      id: 'menubar',
      title: 'Menubar',
      description:
          'Not used in the collector-facing product. It is here '
          'because the admin surface will need it: pack management, card '
          'management and audit logs.',
      child: const Panel(
        label: 'Admin menubar',
        note: 'Future admin surface',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // DRIFT 2, 32px triggers in a 32px bar with 4px of padding.
            //
            // A menubar is a single-row toolbar in the reference itself, not
            // a layout this page chose; at 320px and 200% text three
            // triggers do not fit the strip, so it scrolls horizontally the
            // way a real app's menu bar would rather than reflowing into
            // something the component was never designed to be.
            //
            // Menubar's own `OverflowBox` only relaxes its height, and
            // forwards the ambient width through unchanged (drift 2's own
            // comment): a bare scroll view hands it *infinite* width, which
            // is a different assertion than the one this fixes. `IntrinsicWidth`
            // gives it the bounded width its own content needs instead.
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: IntrinsicWidth(child: Menubar(menus: _admin)),
            ),
            _Caption(
              'Included so the design system can absorb the admin panel later '
              'without inventing new patterns, per the brief.',
            ),
          ],
        ),
      ),
    );
  }
}

/* ── §4 · api ────────────────────────────────────────────────────────────── */

class _ApiSection extends StatelessWidget {
  const _ApiSection();

  @override
  Widget build(BuildContext context) {
    return Section(
      id: 'api',
      title: 'API',
      child: Meta(
        items: <MetaItem>[
          (
            k: 'DropdownMenuItem variant',
            v: const TextSpan(
              text:
                  '"default" or "destructive". Destructive items go last, '
                  'after a separator.',
            ),
          ),
          (
            k: 'DropdownMenuShortcut',
            v: const TextSpan(
              text:
                  'Right-aligned slot. Used for keyboard hints and for live '
                  'figures like a balance.',
            ),
          ),
          (
            k: 'DropdownMenuCheckboxItem',
            v: const TextSpan(
              text: 'Independent toggles: visible columns, active filters.',
            ),
          ),
          (
            k: 'DropdownMenuRadioGroup',
            v: const TextSpan(text: 'One-of-many: sort order, view mode.'),
          ),
          (
            k: 'ContextMenuSub',
            v: const TextSpan(
              text:
                  'One nesting level only. Deeper hierarchies belong in a '
                  'dialog.',
            ),
          ),
        ],
      ),
    );
  }
}

/* ── §5 · rules ──────────────────────────────────────────────────────────── */

class _RulesSection extends StatelessWidget {
  const _RulesSection();

  @override
  Widget build(BuildContext context) {
    return Section(
      id: 'rules',
      title: 'Rules',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const DoDont(
            dos: <String>[
              'Put destructive items last, separated from everything above '
                  'them.',
              'Use the shortcut slot for real information: a balance, a '
                  'value, a key hint.',
              'Keep context menus as accelerators for actions that exist '
                  'elsewhere too.',
              'Label groups when a menu passes about five items.',
            ],
            donts: <String>[
              "Don't make a right-click menu the only path to an action, "
                  'touch users cannot reach it.',
              "Don't nest submenus more than one level deep.",
              "Don't mix checkbox and radio items in the same group; the "
                  'interaction model differs.',
              "Don't put Sign out next to Preferences without a separator.",
            ],
          ),
          // `className="mt-4"` on both Notes.
          SizedBox(height: space(4)),
          const Note(child: _AccentNoteBody()),
          SizedBox(height: space(4)),
          const Note(
            title: 'Geometry, and why it drifts',
            child: _GeometryNoteBody(),
          ),
        ],
      ),
    );
  }
}

/// The first Rules Note: two `<Code>` chips in one sentence.
class _AccentNoteBody extends StatelessWidget {
  const _AccentNoteBody();

  @override
  Widget build(BuildContext context) {
    return RichText(
      TextSpan(
        children: <InlineSpan>[
          const TextSpan(text: 'Menu items take '),
          Code.span('--accent'),
          const TextSpan(text: ' on hover and sit on '),
          Code.span('--popover'),
          const TextSpan(
            text:
                ', which is why a menu reads as floating without needing a '
                'glow.',
          ),
        ],
      ),
      TextStyles.small,
    );
  }
}

/// The second Rules Note: the 8-point rhythm, and what `npx shadcn add`
/// undoes.
class _GeometryNoteBody extends StatelessWidget {
  const _GeometryNoteBody();

  @override
  Widget build(BuildContext context) {
    return RichText(
      TextSpan(
        children: <InlineSpan>[
          const TextSpan(text: '8px container inset, '),
          Code.span('px-3 py-2'),
          const TextSpan(
            text:
                ' items, 8px gap: a 36px row. Stock shadcn '
                'ships ',
          ),
          Code.span('p-1'),
          const TextSpan(text: ' and '),
          Code.span('px-1.5 py-1'),
          const TextSpan(
            text:
                ', which is 4px and 6px/4px: not on the 8-point scale and '
                'visibly cramped next to our controls. The same rhythm is '
                'applied to Dropdown, Context Menu, Menubar, Select and '
                'Command so a list looks the same wherever it appears. '
                'Re-running ',
          ),
          Code.span('npx shadcn add'),
          const TextSpan(
            text:
                ' on any of them brings the tight values '
                'straight back.',
          ),
        ],
      ),
      TextStyles.small,
    );
  }
}
