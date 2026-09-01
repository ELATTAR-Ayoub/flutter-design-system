/// `/design-system/components/base/selects`: seven ways to choose from a
/// known set, and every one of them answers a pointer.
///
/// The page four new components and one new primitive were built for, and the
/// last of the base-component pages the port owed a route. `Select` shipped
/// with `forms` at *"the fidelity the forms page renders"* and deferred its
/// groups, labels, separators, scroll caps and explicit width to here; the
/// other six specimens, [NativeSelect], [Combobox], [Command],
/// [Calendar] twice and [DatePicker]: arrive with this page.
///
/// **The fidelity bar is that all ten specimens are live** (selects-map §11).
/// A reader can open a grouped menu with two labels and a separator, type into
/// a combobox until it says *"No matching set."*, watch the palette filter and
/// re-sort under a query, walk a month grid with the arrow keys, pick two days
/// and watch **the Panel's own header rewrite itself**, and clear a date and
/// watch the Clear button unmount. There is not one still on this page, and a
/// port that renders any of them as a picture fails the bar however exact the
/// pixels.
///
/// ## The route waited for all seven (ruling L13)
///
/// `nav.dart` has promised seven chips since the tree was written, and this
/// page's own §6 is a postmortem of what happens when a `contents` entry has
/// no section behind it. So the route stayed on `PlaceholderPage` until every
/// one of the seven existed rather than shipping a page that advertises
/// Calendar and renders nothing: repeating the exact bug the page exists to
/// document.
///
/// ## The clock is load-bearing (ruling L2)
///
/// None of the three calendars is passed `month` or `defaultMonth`, so all
/// three open on **the reader's current month**, [Calendar] reproduces
/// `getInitialMonth` through [Clock]. That makes this page's rendered height
/// a function of the wall clock: a four-, five- or six-week month differs by
/// one 36px row per on-page calendar, ×2 (the third is in a popover and does
/// not push the document). Every number the page test pins is measured under a
/// frozen clock, and the capture rig freezes both renderers on the same
/// instant.
///
/// ## Drift register: recorded, shipped as written
///
/// selects-map §16's twenty-seven, with **two rewordings** and **five
/// additions** the build-time probes turned up (B1's palette probes and C1's
/// calendar probes). Thirty-two entries.
///
///  1. **The eyebrow says "Base" twice.** `` `${group.title} · Base` `` with
///     `group.title = "Base Components"`. All fourteen base pages.
///  2. **All three calendars open on the reader's current month, not on the
///     month of their own selected value**: and the consequence is worse than
///     the map recorded. *(Probed under the frozen August 2026 clock:)* August
///     opens with six outside days, 26–31 July, so §5's and §7's seeded
///     **30 Jul 2026 is on screen**, at full `--primary`, as a leading outside
///     day. Only §6's 12–20 Jul band is off-screen entirely: while the Panel
///     note above it still prints "12 Jul – 20 Jul". A selection that is
///     visible in one month and invisible in the next is not a stable
///     specimen; it is what passing neither `month` nor `defaultMonth` buys.
///  3. **`Ctrl + K` is decorative.** The §4 Panel note advertises it and the
///     section description says the palette is *"Opened with Ctrl+K from
///     anywhere"*: and no keydown listener exists on the page, in `Command`,
///     or in `cmdk`'s inline mode. The page's own Don't 3 forbids hiding the
///     palette without surfacing its shortcut; the shortcut is surfaced and
///     bound to nothing.
///  4. **The palette's prices are not in the numerical foundation.** `$48.00`
///     and `$120.00` ride `CommandShortcut`'s 12px **sans** at 0.1em tracking,
///     four sections above a Do that says *"Render dates and prices with the
///     named numerical typography foundation."* The date picker obeys it.
///  5. **Three highlight tokens for one idea.** `SelectItem` → `--accent`;
///     `ComboboxItem` → `--accent` through `data-highlighted`; `CommandItem` →
///     **`--muted`**. Two libraries' state vocabularies plus a third fill.
///  6. **Three group-label treatments.** Select's label is `px-3 py-2` at
///     weight 400, the combobox's `px-2 py-1.5` at 400, the palette's heading
///     `px-3 py-2` at **500**. Same role, three sets of numbers.
///  7. **Three separator rhythms.** `SelectSeparator` occupies 17px,
///     `CommandSeparator` **1px with no margin at all**, `ComboboxSeparator`
///     9px (unused here).
///  8. **`NativeSelect` is the only control in the family that is not a pill
///     over a socket**, 32px and 12px-cornered, transparent, no
///     `shadow-pressed`, two sections away from a 40px pill, on a page whose
///     whole subject is that they are the same kind of control.
///  9. **The Select menu is the only overlay here that does not animate.** It
///     ships the full `animate-in` set and cancels all of it; the combobox
///     popup and the date picker's popover both run it at 320ms.
/// 10. **`SelectTrigger`'s `w-fit` is dead in both directions on this page.**
///     In the Panel it loses to the vertical field's `*:w-full`; in the three
///     state cells it loses to `w-40` through twMerge. It never once applies —
///     which is why every [Select] below passes `expand` or `width`.
/// 11. **Tailwind's stock `shadow-md` is now on three overlays**: fixed
///     black, no theme response, under three surfaces whose fill flips.
/// 12. **`Command`'s `bg-popover` is discarded by the call site; its
///     `rounded-xl!` is not.** The map derived that twMerge strips the
///     important modifier and the palette renders at 12px. *(Measured: 16px in
///     both themes)*: twMerge keeps `rounded-xl!` under its own group key and
///     `!important` then wins the cascade over the later `rounded-lg`. Half
///     the drift stands (the fill really is `--card`), half was wrong, and the
///     port ships [Radii.xl].
/// 13. **The palette's check indicator is `display:none` on every row.** It is
///     hidden whenever a row carries a shortcut, and all four do. The
///     component ships a selection affordance the page can never show.
/// 14. **`⌘W` / `⌘S` beside "Ctrl + K".** Two platform idioms, one specimen,
///     four inches apart.
/// 15. **`Icon size="sm"` renders at 16px, not 14.** The container's
///     `[&_svg:not([class*='size-'])]:size-4` beats the SVG's own attributes
///     while `strokeWidth` stays at the 14px-derived 2.4. Four sites here.
/// 16. **Two dim levels inside one disabled field.** `<Field data-disabled>`
///     dims the label to 0.50; the disabled Button dims itself to 0.45; the
///     description is dimmed by neither: which is exactly what its own copy
///     claims, while the first two are reconciled nowhere.
/// 17. **`aria-invalid` beats focus-visible** on both selects. Unreachable
///     from this page: nothing validates.
/// 18. **The "Disabled" state cell ships an empty `<SelectContent />`**: a
///     menu with no rows behind a trigger that cannot open it (ruling L5:
///     nothing-opens is the parity, and [Select] already renders nothing).
/// 19. **`Select` is no longer the only control with `dark:` variants** —
///     `NativeSelect` carries the same four.
/// 20. **The date-picker trigger is the one Button on the page that does not
///     scale on press.** `PopoverTrigger` stamps `aria-haspopup="dialog"`,
///     which cancels `active:not-aria-[haspopup]:scale-95`. Its disabled twin
///     beside it: same variant, same classes, no popover: would squish if it
///     were not disabled. Assertable as [DatePicker.pressScaleSuppressed].
/// 21. **`Combobox` is the corpus's only `@base-ui/react` component**: a
///     second state vocabulary, a second positioner variable set and a second
///     filter philosophy, in one section.
/// 22. **The combobox popup is always 28px wider than its own input.**
///     `w-(--anchor-width)` asks for exactly the anchor and
///     `min-w-[calc(var(--anchor-width)+--spacing(7))]` overrules it, so the
///     popup overhangs to the right.
/// 23. **The combobox has no way back to an empty query.** `showClear`
///     defaults false: while the Meta three sections later says *"A date
///     picker with no way back to empty is a trap."*
/// 24. **`nav.ts`'s own source comment documents this page's §6 as a shipped
///     bug**, found the same way as the missing Chart section. `nav.dart`
///     already carries it verbatim, and §6's Note is the postmortem.
/// 25. **The calendar disagrees with itself about cell shape.** `today` paints
///     a 10px rounded `--muted` square on the cell; the button inside it is a
///     pill; so a selected today is a circle on a rounded square.
/// 26. **`CalendarDayButton` passes `size="icon"` and immediately throws it
///     away**, `size-10` loses to `size-auto` in the same className.
/// 27. **`duration-base` is a class that does nothing.** Tailwind v4 has no
///     `--duration-*` namespace, so every `duration-<word>` falls through to
///     the 250ms default: closed corpus-wide by the sweep.
/// 28. **cmdk's group re-sort is dead code.** *(Probed)* `sort()` looks groups
///     up by `[cmdk-group=""][data-value="<useId>"]` while the element's
///     `data-value` holds its heading, so the selector never matches. Item
///     sort is real: typing `t` lifts "Go to Stash" over "Open Wallet": and
///     group order never changes.
/// 29. **The command input has no focus affordance.** *(Probed)* the group's
///     `has-[[data-slot=input-group-control]:focus-visible]` selector misses,
///     because cmdk's own input stamps no such slot, and `shadow-none!` kills
///     the ring. Resting and focused are byte-identical.
/// 30. **The palette's separator unmounts on the first keystroke.** *(Probed)*
///     cmdk renders `Separator` only when `!state.search`, so the 1px rule
///     leaves the DOM the moment anything is typed and returns when the input
///     is cleared: a height swing on a control that has no other.
/// 31. **Outside days are a visual no-op.** *(Probed)* the `outside` slot asks
///     for `text-muted-foreground`, and the day button inside it declares its
///     own colour, so a 30 July in an August grid is painted exactly like a
///     31 August. The class is written, matched, and invisible.
/// 32. **A wrapped range gets capped rows.** *(Probed)* the cell's
///     `[&:first-child[data-selected=true]_button]:rounded-l-(--cell-radius)`
///     pair fires on range **middles** as well as on the ends, so a range that
///     crosses a week boundary renders as one rounded bar per row rather than
///     one continuous ribbon.
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

/// `max-w-sm`, `--container-sm`, 24rem. §1's and §2's `FieldGroup`, and §3's
/// bare `div`. Tailwind's **container** scale, which `globals.css` does not
/// override, so it is not the spacing ladder even where the two coincide.
// allow-hardcoded: framework container scale with no token to read it from.
const double _measureSm = 384;

/// `max-w-xs`, `--container-xs`, 20rem. §7's `FieldGroup`, and the only place
/// on the page that steps down from `sm`.
// allow-hardcoded: framework container scale with no token to read it from.
const double _measureXs = 320;

/// `w-40` on the three state-cell triggers: the third width case, and the one
/// [Select.expand] could not spell.
final double _triggerWidth = space(40);

/// `useState(new Date(2026, 6, 30))`, §5's `selected` and §7's `picked`.
///
/// **July**, seeded when the page was written, and read by a calendar that
/// opens on the reader's own month. Drift 2.
DateTime get _seedDay => DateTime(2026, 7, 30);

/// `useState({from: new Date(2026, 6, 12), to: new Date(2026, 6, 20)})`, §6.
DateRange get _seedRange =>
    DateRange(from: DateTime(2026, 7, 12), to: DateTime(2026, 7, 20));

/// The disabled twin's frozen value, *"Locked to the tax year"*, and the
/// start of the UK one.
DateTime get _taxYearStart => DateTime(2026, 4, 6);

/// `SETS` (page:65–72), verbatim and in order.
const List<String> _sets = <String>[
  'Eclipse Vault',
  'Golden Rift',
  'Mystic Surge',
  'Shadow Core',
  'Celestial Strike',
  'Origin Pulse',
];

/* ── Page ────────────────────────────────────────────────────────────────── */

class SelectsPage extends StatelessWidget {
  const SelectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CategoryHit here = findCategory('base', 'selects');

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
        // `className="mb-12"`, 48px, above the first section rather than
        // inside it.
        Padding(
          padding: EdgeInsets.only(bottom: space(12)),
          child: const Note(
            title: 'Choosing the right one',
            child: _ChoosingBody(),
          ),
        ),
        const _SelectSection(),
        const _NativeSection(),
        const _ComboboxSection(),
        const _CommandSection(),
        const _CalendarSection(),
        const _DateRangeSection(),
        const _DatePickerSection(),
        const _ApiSection(),
        const _RulesSection(),
        const PageFootNav(groupId: 'base', slug: 'selects'),
      ],
    );
  }
}

/// A `max-w-*` block: as wide as its measure, no wider, and flush left.
///
/// [Align] and not a bare [ConstrainedBox]: a constrained box under a **tight**
/// width is still tight: the max never gets a chance to bind: and the panel
/// body hands its child exactly that. Align relaxes the incoming constraint to
/// loose first, which is what lets the measure win. Same shape the forms page
/// uses, and the shape a shrink-wrapping specimen needs too (§5, §6).
class _Measure extends StatelessWidget {
  const _Measure({required this.width, required this.child});

  final double width;
  final Widget child;

  @override
  Widget build(BuildContext context) => Align(
    alignment: AlignmentDirectional.centerStart,
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: width),
      child: child,
    ),
  );
}

/// The opening `Note`'s four `<Code>` chips.
class _ChoosingBody extends StatelessWidget {
  const _ChoosingBody();

  @override
  Widget build(BuildContext context) {
    return RichText(
      TextSpan(
        children: <InlineSpan>[
          const TextSpan(text: 'Under about eight fixed options, use '),
          Code.span('Select'),
          const TextSpan(
            text:
                '. Over that, or when the user knows what they are looking '
                'for, use ',
          ),
          Code.span('Combobox'),
          const TextSpan(
            text:
                ' so they can type. For cross-product navigation and '
                'actions, use the ',
          ),
          Code.span('Command'),
          const TextSpan(text: ' palette. '),
          Code.span('NativeSelect'),
          const TextSpan(
            text:
                ' exists for long, boring lists like country — the OS picker '
                'beats anything custom on mobile.',
          ),
        ],
      ),
      TextStyles.small,
    );
  }
}

/* ── §1 · select ─────────────────────────────────────────────────────────── */

class _SelectSection extends StatefulWidget {
  const _SelectSection();

  @override
  State<_SelectSection> createState() => _SelectSectionState();
}

class _SelectSectionState extends State<_SelectSection> {
  /// `defaultValue="popular"`: uncontrolled on the reference, so a commit
  /// really does move it.
  String? _sort = 'popular';

  /// No `defaultValue`: the placeholder state, and the one that puts the
  /// **first** row over the trigger when the menu opens.
  String? _rarity;

  /// The two state cells that open a real one-row menu. Cell 3 is disabled and
  /// holds nothing.
  String? _cellDefault;
  String? _cellSelected = 'a';

  /// The grouped menu, in DOM order: label, three rows, separator, label, two
  /// rows. The heterogeneous list `_placement()` was rewritten for: the
  /// chosen row sits 40px into the content, not `8 + 0.5 × 34.571`.
  static const List<SelectChild<String>> _sortOptions = <SelectChild<String>>[
    SelectGroup<String>(
      label: 'Activity',
      children: <SelectOption<String>>[
        SelectOption<String>(value: 'popular', label: 'Most popular'),
        SelectOption<String>(value: 'newest', label: 'Newest'),
        SelectOption<String>(value: 'volatility', label: 'Volatility'),
      ],
    ),
    SelectSeparator(),
    SelectGroup<String>(
      label: 'Price',
      children: <SelectOption<String>>[
        SelectOption<String>(value: 'low', label: 'Price: low to high'),
        SelectOption<String>(value: 'high', label: 'Price: high to low'),
      ],
    ),
  ];

  /// `[…].map((r) => <SelectItem value={r.toLowerCase()}>)`: six flat rows,
  /// the labels cased and the values not.
  static const List<String> _rarities = <String>[
    'Common',
    'Uncommon',
    'Rare',
    'Epic',
    'Legendary',
    'Mythic',
  ];

  @override
  Widget build(BuildContext context) {
    return Section(
      id: 'select',
      title: 'Select',
      description:
          'A fixed set of options with one selected. The trigger '
          'shows the current value, never a placeholder pretending to be a '
          'label.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Panel(
            label: 'Sort and filter selects',
            child: _Measure(
              width: _measureSm,
              child: FieldGroup(
                children: <Widget>[
                  Field(
                    label: 'Sort by',
                    description:
                        'Grouped with labels so long option lists '
                        'stay scannable.',
                    child: Select<String>(
                      options: _sortOptions,
                      value: _sort,
                      onChanged: (String next) => setState(() => _sort = next),
                      // DRIFT 10, first direction: the vertical field's
                      // `*:w-full` beats the trigger's own `w-fit`.
                      expand: true,
                    ),
                  ),
                  Field(
                    label: 'Minimum rarity',
                    child: Select<String>(
                      options: <SelectOption<String>>[
                        for (final String rarity in _rarities)
                          SelectOption<String>(
                            value: rarity.toLowerCase(),
                            label: rarity,
                          ),
                      ],
                      value: _rarity,
                      onChanged: (String next) =>
                          setState(() => _rarity = next),
                      placeholder: 'Any rarity',
                      expand: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // `StateGrid className="mt-4"`.
          SizedBox(height: space(4)),
          StateGrid(
            cols: 3,
            children: <Widget>[
              StateCell(
                label: 'Default',
                child: Select<String>(
                  options: const <SelectOption<String>>[
                    SelectOption<String>(value: 'a', label: 'Common'),
                  ],
                  value: _cellDefault,
                  onChanged: (String next) =>
                      setState(() => _cellDefault = next),
                  placeholder: 'Any rarity',
                  // DRIFT 10, second direction: `w-40` beats `w-fit` through
                  // twMerge, before CSS is consulted.
                  width: _triggerWidth,
                  // `aria-label`: the trigger has no visible label of its own,
                  // and this page is the first consumer of that parameter.
                  label: 'Default',
                ),
              ),
              StateCell(
                label: 'Selected',
                child: Select<String>(
                  options: const <SelectOption<String>>[
                    SelectOption<String>(value: 'a', label: 'Legendary'),
                  ],
                  value: _cellSelected,
                  onChanged: (String next) =>
                      setState(() => _cellSelected = next),
                  width: _triggerWidth,
                  label: 'Selected',
                ),
              ),
              StateCell(
                label: 'Disabled',
                // DRIFT 18. `<Select disabled>` over an empty
                // `<SelectContent />`: the trigger cannot open, and there
                // would be nothing behind it if it could. Both halves are
                // written, as the reference writes both.
                child: Select<String>(
                  options: const <SelectChild<String>>[],
                  value: null,
                  onChanged: null,
                  enabled: false,
                  placeholder: 'Unavailable',
                  width: _triggerWidth,
                  label: 'Disabled',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/* ── §2 · native select ──────────────────────────────────────────────────── */

class _NativeSection extends StatefulWidget {
  const _NativeSection();

  @override
  State<_NativeSection> createState() => _NativeSectionState();
}

class _NativeSectionState extends State<_NativeSection> {
  /// `defaultValue="us"`.
  String _country = 'us';

  static const List<SelectOption<String>> _countries = <SelectOption<String>>[
    SelectOption<String>(value: 'us', label: 'United States'),
    SelectOption<String>(value: 'gb', label: 'United Kingdom'),
    SelectOption<String>(value: 'ca', label: 'Canada'),
    SelectOption<String>(value: 'de', label: 'Germany'),
    SelectOption<String>(value: 'jp', label: 'Japan'),
  ];

  @override
  Widget build(BuildContext context) {
    return Section(
      id: 'native',
      title: 'Native Select',
      description:
          "Renders the operating system's own picker. Correct for "
          'country, region, timezone and other long, uninteresting lists — '
          'especially on mobile.',
      child: Panel(
        label: 'Native select',
        child: _Measure(
          width: _measureSm,
          child: FieldGroup(
            children: <Widget>[
              Field(
                label: 'Country',
                description: 'Used in shipping and account settings.',
                // DRIFT 8. 32px, 12px radius, transparent, no socket: beside
                // §1's 40px pill over one. The port's own menu stands in for
                // the OS list (ruling L6, the first by-construction
                // divergence); the *specimen* is the closed control, and that
                // is reproduced to the pixel.
                child: NativeSelect<String>(
                  options: _countries,
                  value: _country,
                  onChanged: (String next) => setState(() => _country = next),
                  expand: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ── §3 · combobox ───────────────────────────────────────────────────────── */

class _ComboboxSection extends StatefulWidget {
  const _ComboboxSection();

  @override
  State<_ComboboxSection> createState() => _ComboboxSectionState();
}

class _ComboboxSectionState extends State<_ComboboxSection> {
  /// Uncontrolled on the reference: nothing is selected until a row is
  /// committed, and `autoHighlight` is false, so nothing is highlighted until
  /// an arrow key is pressed either.
  String? _set;

  @override
  Widget build(BuildContext context) {
    return Section(
      id: 'combobox',
      title: 'Combobox',
      description:
          'A select the user can type into. Used for card sets, pack '
          'names and any list long enough that scrolling is worse than typing.',
      child: Panel(
        label: 'Filter by card set',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _Measure(
              width: _measureSm,
              child: Combobox<String>(
                items: <ComboboxItem<String>>[
                  for (final String set in _sets)
                    ComboboxItem<String>(value: set, label: set),
                ],
                value: _set,
                onChanged: (String next) => setState(() => _set = next),
                placeholder: 'Search card sets',
                emptyLabel: 'No matching set.',
              ),
            ),
            // `<p className="type-small mt-5">`: a bare paragraph, not a
            // `Note`, and the only caption on the page.
            SizedBox(height: space(5)),
            StyledText(
              'Typing narrows the list. The empty state says what happened '
              'rather than showing a blank panel.',
              TextStyles.small,
            ),
          ],
        ),
      ),
    );
  }
}

/* ── §4 · command palette ────────────────────────────────────────────────── */

class _CommandSection extends StatelessWidget {
  const _CommandSection();

  /// Two groups, one separator between them, four rows, four shortcuts.
  ///
  /// The separator is a property of the group it precedes rather than a list
  /// entry of its own, so the arrangement cannot drift from the groups it
  /// separates.
  static const List<CommandGroup> _groups = <CommandGroup>[
    CommandGroup(
      heading: 'Packs',
      items: <CommandItem>[
        // DRIFT 4: the prices ride `CommandShortcut`, which is 12px sans at
        // 0.1em: not the numerical foundation Do 5 asks for.
        CommandItem(
          label: 'Eclipse Vault',
          icon: IconGlyph.search,
          shortcut: r'$48.00',
        ),
        CommandItem(
          label: 'Golden Rift',
          icon: IconGlyph.search,
          shortcut: r'$120.00',
        ),
      ],
    ),
    CommandGroup(
      heading: 'Actions',
      separatorBefore: true,
      items: <CommandItem>[
        // DRIFT 14: two platform idioms on one specimen, U+2318 here, and
        // "Ctrl + K" in the Panel's own header strip.
        CommandItem(label: 'Open Wallet', shortcut: '⌘W'),
        CommandItem(label: 'Go to Stash', shortcut: '⌘S'),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Section(
      id: 'command',
      title: 'Command palette',
      description:
          'Keyboard-first navigation across the whole product. '
          'Opened with Ctrl+K from anywhere, and the fastest route for a '
          'returning collector.',
      // DRIFT 3. The note advertises a binding that does not exist: no
      // keydown listener anywhere on the page opens this palette, which is
      // always open in the first place.
      child: Panel(
        label: 'Command palette',
        note: 'Ctrl + K',
        // Command's search field and its item rows (icon, label, trailing
        // shortcut) are internal to the component, with no exposed slot for
        // the specimen to give a long label room by reflowing anything. At
        // 2x text on a 320px phone both rows outgrow the panel (a lib gap,
        // see the report); a horizontal scroll renders the palette at its
        // own width unclipped instead of erroring, and the wide reading,
        // which already fits, is unchanged. Command needs a bounded width to
        // lay out at all, so it is given the page's own `_measureSm`, the
        // same declared measure other fixed-width specimens on this page use.
        //
        // Each item row also carries a fixed height that does not grow with
        // its text (another facet of the same lib gap), so the scaler
        // reaching the palette is capped to the largest factor that still
        // keeps every row inside its fixed height.
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: _measureSm,
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: MediaQuery.textScalerOf(
                  context,
                ).clamp(maxScaleFactor: 1.15),
              ),
              child: const Command(
                groups: _groups,
                placeholder: 'Search packs, cards and actions…',
                emptyLabel: 'Nothing matches that.',
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/* ── §5 · calendar ───────────────────────────────────────────────────────── */

class _CalendarSection extends StatefulWidget {
  const _CalendarSection();

  @override
  State<_CalendarSection> createState() => _CalendarSectionState();
}

class _CalendarSectionState extends State<_CalendarSection> {
  DateTime? _date = _seedDay;

  @override
  Widget build(BuildContext context) {
    return Section(
      id: 'calendar',
      title: 'Calendar',
      description:
          'Used for filtering the Stash by date acquired, and '
          'transaction history in the Wallet. Never for anything the user has '
          'to type.',
      child: Panel(
        label: 'Single',
        // `root` is `w-fit` and here that is real: the calendar is 222px wide
        // and the panel body is 1030. Aligned, never stretched: a calendar
        // that fills its panel is a different component.
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          // No `month` and no `defaultMonth`, exactly as the reference
          // passes none: the grid opens on the clock's current month and
          // the seeded 30 July lands wherever that month puts it (drift 2).
          child: Calendar.single(
            selected: _date,
            onSelected: (DateTime? next) => setState(() => _date = next),
          ),
        ),
      ),
    );
  }
}

/* ── §6 · date range ─────────────────────────────────────────────────────── */

class _DateRangeSection extends StatefulWidget {
  const _DateRangeSection();

  @override
  State<_DateRangeSection> createState() => _DateRangeSectionState();
}

class _DateRangeSectionState extends State<_DateRangeSection> {
  DateRange? _range = _seedRange;

  /// `rangeLabel` (page:82–85): the Panel's own `note`, derived from the live
  /// range.
  ///
  /// The separator is U+2013 EN DASH, not a hyphen. Clicking two days rewrites
  /// the Panel header: the only place on the page where a specimen writes into
  /// its own chrome, and a fidelity requirement rather than decoration.
  String get _rangeLabel {
    final DateRange? range = _range;
    return range != null && range.isComplete
        ? '${DateFormat.dayMonth(range.from!)} – '
              '${DateFormat.dayMonth(range.to!)}'
        : 'Pick two dates';
  }

  @override
  Widget build(BuildContext context) {
    return Section(
      id: 'date-range',
      title: 'Date Range',
      // The apostrophe in "Wallet's" is **straight**; the quotes around
      // "between these dates" are curly U+201C/U+201D. Both as authored.
      description:
          'The same Calendar in range mode: a start, an end, and '
          "every day between them marked. Used for the Wallet's "
          'statement period and any “between these dates” filter.',
      child: Grid(
        lg: 2,
        children: <Widget>[
          Panel(
            label: 'Range',
            note: _rangeLabel,
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Calendar.range(
                selected: _range,
                onSelected: (DateRange? next) => setState(() => _range = next),
              ),
            ),
          ),
          const Note(
            title: 'This section existed only as a promise',
            child: _PromiseBody(),
          ),
        ],
      ),
    );
  }
}

/// §6's Note: the postmortem `nav.dart` already carries verbatim.
class _PromiseBody extends StatelessWidget {
  const _PromiseBody();

  @override
  Widget build(BuildContext context) {
    return RichText(
      TextSpan(
        children: <InlineSpan>[
          Code.span('nav.ts'),
          const TextSpan(
            text:
                ' has listed “Date Range” since the tree was '
                'written, and the section above it was titled “Calendar '
                'and date range” — but no calendar anywhere in the repo '
                'was ever rendered in ',
          ),
          Code.span('mode="range"'),
          const TextSpan(text: '. Nothing catches that: '),
          Code.span('check:refs'),
          const TextSpan(text: ' reads CSS references, not the nav, and a '),
          Code.span('contents'),
          const TextSpan(
            text:
                ' entry with no section is invisible to every guard here. '
                'The same bug removed “Chart” from Data Display. '
                'Adding a string to ',
          ),
          Code.span('contents'),
          const TextSpan(text: ' is a commitment, not a label.'),
        ],
      ),
      TextStyles.small,
    );
  }
}

/* ── §7 · date picker ────────────────────────────────────────────────────── */

class _DatePickerSection extends StatefulWidget {
  const _DatePickerSection();

  @override
  State<_DatePickerSection> createState() => _DatePickerSectionState();
}

class _DatePickerSectionState extends State<_DatePickerSection> {
  DateTime? _picked = _seedDay;

  /// `htmlFor="picker-empty"`: the label activates the trigger, which is a
  /// Button rather than an Input (the Meta says why).
  final FocusNode _pickerFocus = FocusNode(debugLabel: 'picker-empty');

  @override
  void dispose() {
    _pickerFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool picked = _picked != null;

    return Section(
      id: 'date-picker',
      title: 'Date Picker',
      description:
          'A Calendar inside a Popover, behind a trigger that shows '
          'the current value. The most common date control there is, and the '
          'one shadcn documents as a recipe rather than a file.',
      child: Grid(
        lg: 2,
        children: <Widget>[
          Panel(
            label: 'Every state',
            child: _Measure(
              width: _measureXs,
              child: FieldGroup(
                children: <Widget>[
                  Field(
                    label: 'Acquired after',
                    // The description is live too, and says which face the
                    // trigger is currently wearing.
                    description: picked
                        ? 'Selected. Dates use the shared numerical mono '
                              'foundation.'
                        : 'Empty. The placeholder sits in the sans face — it '
                              'is a word, not a value.',
                    focusNode: _pickerFocus,
                    // DRIFT 20: the one Button on the page that does not
                    // squish on press.
                    //
                    // The trigger is `Button`'s icon-and-date row with no
                    // flexible slot for the label (a lib gap, see the
                    // report), and this field is deliberately the page's
                    // narrowest measure (`_measureXs`). Narrowing it further
                    // to dodge the row would undo that; a horizontal scroll
                    // lets the trigger render at its own width unclipped
                    // instead, and the wide reading is unchanged.
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DatePicker(
                        value: _picked,
                        onChanged: (DateTime? next) =>
                            setState(() => _picked = next),
                        focusNode: _pickerFocus,
                        label: 'Acquired after',
                      ),
                    ),
                  ),
                  // `{picked && <Button …>Clear date</Button>}`: a direct
                  // child of the `FieldGroup`, so it takes the group's own
                  // 20px above and below, and `self-start` beats the group's
                  // stretch. It **unmounts** when the field goes empty, which
                  // includes re-picking the selected day in the calendar:
                  // `mode="single"` toggles, and the toggle reports null.
                  if (picked)
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Button(
                        variant: ButtonVariant.ghost,
                        size: ButtonSize.sm,
                        onPressed: () => setState(() => _picked = null),
                        child: const Text('Clear date'),
                      ),
                    ),
                  // `<Field data-disabled>`, DRIFT 16. The field dims the
                  // label to 0.50, the disabled trigger dims itself to 0.45,
                  // and the description is dimmed by neither.
                  Field(
                    label: 'Locked to the tax year',
                    description:
                        'Disabled. The control is exempt from '
                        'contrast, the description beside it is not.',
                    enabled: false,
                    // No handler at all: the twin is a plain disabled Button
                    // with a mono date inside it, and no popover behind it.
                    // See the field above: same unflexed trigger row.
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DatePicker(value: _taxYearStart),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // `div.space-y-4`.
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Note(
                tone: NoteTone.error,
                title: 'Never format a date with toISOString()',
                child: _ToIsoBody(),
              ),
              SizedBox(height: space(4)),
              Meta(
                items: <MetaItem>[
                  (
                    k: 'format(d, "d MMM yyyy")',
                    v: const TextSpan(
                      text:
                          'Local date, no timezone conversion. date-fns is '
                          'already a dependency — react-day-picker brings it.',
                    ),
                  ),
                  (
                    k: 'autoFocus',
                    v: const TextSpan(
                      text:
                          'On the Calendar inside the popover, so the '
                          'keyboard lands on the grid rather than behind it.',
                    ),
                  ),
                  (
                    k: 'The trigger is a Button',
                    v: const TextSpan(
                      text:
                          'Not an Input. There is nothing to type, so '
                          'nothing should look typeable.',
                    ),
                  ),
                  (
                    k: 'Clearing',
                    v: const TextSpan(
                      text:
                          'A date picker with no way back to empty is a '
                          'trap. Offer it whenever the field is optional.',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// §7's Note. The apostrophe after `date-fns` is U+2019 and sits **outside**
/// the chip.
class _ToIsoBody extends StatelessWidget {
  const _ToIsoBody();

  @override
  Widget build(BuildContext context) {
    return RichText(
      TextSpan(
        children: <InlineSpan>[
          Code.span('toISOString()'),
          const TextSpan(
            text:
                ' converts to UTC first. Pick the 30th anywhere west of '
                'Greenwich and ',
          ),
          Code.span('date.toISOString().slice(0, 10)'),
          const TextSpan(
            text:
                ' renders the 29th — the calendar shows one day selected and '
                'the trigger shows another. It is invisible in London, wrong '
                'in New York, and this page shipped it until now. Use ',
          ),
          Code.span('date-fns'),
          const TextSpan(text: '’ '),
          Code.span('format'),
          const TextSpan(text: ', which reads the local calendar date.'),
        ],
      ),
      TextStyles.small,
    );
  }
}

/* ── §8 · api ────────────────────────────────────────────────────────────── */

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
            k: 'Select',
            v: const TextSpan(
              text:
                  'Select + SelectTrigger + SelectValue + SelectContent + '
                  'SelectItem. Group with SelectGroup and SelectLabel.',
            ),
          ),
          (
            k: 'NativeSelect',
            v: const TextSpan(
              text:
                  'A real <select>. Use NativeSelectOption for options; the '
                  'OS renders the picker.',
            ),
          ),
          (
            k: 'Combobox',
            v: const TextSpan(
              text:
                  'Pass items, then render each with a function child inside '
                  'ComboboxList. ComboboxEmpty covers no-results.',
            ),
          ),
          (
            k: 'Command',
            v: const TextSpan(
              text:
                  'Command + CommandInput + CommandList + CommandGroup + '
                  'CommandItem. CommandShortcut right-aligns metadata.',
            ),
          ),
          (
            k: 'Calendar',
            v: const TextSpan(
              text:
                  'mode="single" | "range" | "multiple". Pair with Popover '
                  'for a date picker.',
            ),
          ),
        ],
      ),
    );
  }
}

/* ── §9 · rules ──────────────────────────────────────────────────────────── */

class _RulesSection extends StatelessWidget {
  const _RulesSection();

  @override
  Widget build(BuildContext context) {
    return const Section(
      id: 'rules',
      title: 'Rules',
      // Five dos against four don'ts: unequal columns, as `selection` has
      // them too.
      child: DoDont(
        dos: <String>[
          'Use Select under about eight options, Combobox above it.',
          'Group long option lists with labels so they stay scannable.',
          'Use NativeSelect for country, region and timezone.',
          'Show a real empty state when a search returns nothing.',
          'Render dates and prices with the named numerical typography '
              'foundation.',
        ],
        // Straight apostrophes in all four; only the panel heading is curly.
        donts: <String>[
          "Don't use a placeholder in place of a field label.",
          "Don't build a custom dropdown for a 200-item list; let the user "
              'type.',
          "Don't hide the command palette without surfacing its shortcut "
              'somewhere.',
          "Don't put a date picker where a plain text input would be faster.",
        ],
      ),
    );
  }
}
