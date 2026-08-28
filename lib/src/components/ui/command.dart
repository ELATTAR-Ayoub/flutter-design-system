/// `components/ui/command.tsx` — the command palette, and the port's only
/// fuzzy matcher.
///
/// `cmdk` v1.1.1. Two things make this different from every other list in the
/// system: `shouldFilter` defaults **true**, which its own `d.ts` defines as
/// *"automatic filtering **and sorting**"* (ruling L9), and the palette is
/// **inline** — `Command` is rendered directly into the page, always open,
/// never in a dialog. There is no overlay here at all.
///
/// ## L7, settled by measurement
///
/// The map derived that tailwind-merge strips `rounded-xl!` when it groups
/// classes, so the call site's `rounded-lg` would win and the palette would
/// render at 12px. Ruling L7 said probe before building. *(Measured on the live
/// reference, 2026-08-16, both themes.)*
///
/// | | derived | **measured** |
/// |---|---|---|
/// | `border-radius` | 12px (`rounded-lg`) | **16px** — `--radius-xl` |
/// | `background-color` | `--card` | **`--card`** |
///
/// The class list the browser reports is
/// `… overflow-hidden rounded-xl! p-2 text-popover-foreground rounded-lg border
/// border-border bg-card`: twMerge **did** strip `bg-popover` — it is gone, and
/// `bg-card` survives — but it kept **both** radius classes, because the
/// important modifier puts `rounded-xl!` in a different group key from
/// `rounded-lg`. Both reach the stylesheet, and `!important` then wins outright.
///
/// So the drift is half of what the map recorded: the fill is discarded by the
/// call site, the radius is **not**. Corrected here rather than in the map's
/// drift 12, and the port renders [Radii.xl].
///
/// ## Measured geometry
///
/// *(All from `getComputedStyle` / `getBoundingClientRect` at 1440×900.)*
///
/// | part | value |
/// |---|---|
/// | root | radius **16**, `--card`, 1px `--border`, `p-2`, `overflow-hidden`, ink `--popover-foreground`, **293.25px** tall with all four rows |
/// | input wrapper | `p-2 pb-0` |
/// | its group | **32px**, radius **12**, `--input` at **30 %** for both fill and border, **no socket and no focus ring** |
/// | addon | `order-first`, `pl-2!` → **8px**, `py-1.5`, 24×28 |
/// | search glyph | **16px**, `--muted-foreground` at **opacity .5**, stroke 2.4 |
/// | input | **13 / 18.5714**, `pl-2` → 8, no right padding |
/// | list | cap **288** (`max-h-72`), no padding, `scroll-py-1`, scrollbar hidden |
/// | group | `p-2`; heading `px-3 py-2`, **12 / 16 / 500**, `--muted-foreground`, **32px** |
/// | separator | **1px** `--border`, `-mx-2` full-bleed, **no vertical margin** |
/// | item | **34.5625px**, radius **10**, `px-3 py-2`, `gap-2`, 13 / 18.5714 |
/// | item selected | `--muted` fill, `--foreground` ink, and its glyph and shortcut turn `--foreground` too |
/// | shortcut | **12 / 16 / 400 sans**, tracking **0.1em**, `ml-auto` |
/// | empty | `py-6` → **66.5625px**, centred, `--popover-foreground` |
///
/// ## The socket is removed, not restyled
///
/// `h-8! rounded-lg! border-input/30 bg-input/30 shadow-none!` — `rounded-pill`
/// and `shadow-pressed` both lose through twMerge, which is the exact bug
/// `lib/utils.ts` was extended to fix. *(Measured)* the group's `box-shadow`
/// computes to five fully transparent layers in **both** the resting and the
/// focused state, and its `border-color` does not move on focus either.
///
/// That second half is a finding the map does not carry: the group's
/// `has-[[data-slot=input-group-control]:focus-visible]:border-ring` predicate
/// looks for `data-slot="input-group-control"`, and `CommandPrimitive.Input`
/// stamps `data-slot="command-input"`. **The selector can never match**, and
/// `shadow-none!` would have killed the ring shadow regardless. The command
/// input is the one text field in the system with no focus affordance at all.
/// Reproduced; recorded as a new drift.
///
/// ## Why this file does not build on `Popover`
///
/// It has nothing to anchor. `CommandDialog` is the variant that would need one
/// and the page does not render it — `Command` is a plain child of the Panel.
/// The dialog variant is recorded, not built, on the precedent that scoped
/// `Select` and `InputGroupAlign`. What this file does reuse from wave A2 is
/// the input-group *recipe*; it cannot reuse the widget, because [InputGroup]
/// fixes the 40px pill, the `--card` fill and `shadow-pressed` that this control
/// overrides, and that file is not this task's to widen.
///
/// ## Drifts reproduced here
///
/// - **4** — the prices ride `CommandShortcut`'s `text-xs tracking-widest`,
///   which is **12px sans**, four sections above the page's own Do 5 telling
///   you to render prices in the numerical foundation. Shipped as written.
/// - **5** — `data-selected:bg-muted`. A third highlight token on one page,
///   after `SelectItem`'s `focus:bg-accent` and `ComboboxItem`'s
///   `data-highlighted:bg-accent`.
/// - **6** — the heading is the weight-**500** member of the three-way group
///   label split ([TextStyles.menuHeading]).
/// - **7** — `-mx-2` with **no `my-*`**: 1px of separator and not one pixel of
///   air, where `SelectSeparator` takes 17.
/// - **13** — the trailing check is `display:none` on all four items, because
///   all four carry a shortcut.
/// - **15** — the two `Search` glyphs are `size="sm"` and paint at **16px**
///   carrying the 14px-derived stroke of 2.4.
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

import '../../design_system/foundation/colors.dart';
import '../../design_system/foundation/spacing.dart';
import '../../design_system/foundation/theme.dart';
import '../../design_system/foundation/typography.dart';
import '../../design_system/foundation/theme_scope.dart';
import './icon.dart';
import './icon_paths.dart';
import './icon_paths.g.dart';
import './input.dart';
import './input_group.dart';

// ═══════════════════════════════════════════════════════════════════════════
// commandScore — ported verbatim
// ═══════════════════════════════════════════════════════════════════════════

/// Ruling L9: cmdk filters **and re-sorts**, so row order is visible fidelity
/// and the scorer ports rather than approximates.
///
/// Source: `design-system/node_modules/cmdk/dist/command-score.js` — cmdk
/// **1.1.1**, a single-line bundle, so the citations below are byte offsets
/// into that file. The signature is `command-score.d.ts:1`:
/// `commandScore(string, abbreviation, aliases): number`.
///
/// The bundle declares **eight** constants (bytes 467–520). The upstream
/// TypeScript declares nine — `PENALTY_DISTANCE_FROM_START = 0.9` is never
/// referenced in the body, so the minifier dropped it. It is not transcribed
/// here for the same reason: a constant with no reader is not part of the
/// algorithm.
///
/// The names are the upstream ones; the bundle's are single letters.

/// `SCORE_CONTINUE_MATCH` *(byte 467, `var D=1`)*. The scores are arranged so
/// that an unbroken run of matched characters totals exactly 1.
const double _scoreContinueMatch = 1;

/// `SCORE_SPACE_WORD_JUMP` *(byte 475, `K=.9`)* — a new match at the start of a
/// word, where the break was whitespace or a hyphen.
const double _scoreSpaceWordJump = 0.9;

/// `SCORE_NON_SPACE_WORD_JUMP` *(byte 480, `W=.8`)* — the same jump over a
/// punctuation break, scored slightly lower.
const double _scoreNonSpaceWordJump = 0.8;

/// `SCORE_CHARACTER_JUMP` *(byte 485, `j=.17`)* — a match in the middle of a
/// word. Not ideal, but not disqualifying.
const double _scoreCharacterJump = 0.17;

/// `SCORE_TRANSPOSITION` *(byte 491, `u=.1`)*.
const double _scoreTransposition = 0.1;

/// `PENALTY_SKIPPED` *(byte 496, `G=.999`)* — a match decays slightly with each
/// character it steps over.
const double _penaltySkipped = 0.999;

/// `PENALTY_CASE_MISMATCH` *(byte 503, `y=.9999`)* — an exact-case match beats
/// a case-folded one by a hair.
const double _penaltyCaseMismatch = 0.9999;

/// `PENALTY_NOT_COMPLETE` *(byte 511, `var F=.99`)* — the query ran out before
/// the string did.
const double _penaltyNotComplete = 0.99;

/// `IS_GAP_REGEXP` / `COUNT_GAPS_REGEXP` *(bytes 521 and 545)* — the two are
/// the same pattern, the second with `/g`; Dart spells that difference with
/// `allMatches` rather than a second object.
final RegExp _isGap = RegExp(r'[\\/_+.#"@\[\(\{&]');

/// `IS_SPACE_REGEXP` / `COUNT_SPACE_REGEXP` *(bytes 570 and 578)*. A **hyphen**
/// counts as a space here — which is why `foo-bar` scores as two words and
/// `fooBar` does not.
final RegExp _isSpace = RegExp(r'[\s-]');

/// JavaScript's `String.prototype.charAt`, which returns `''` out of range
/// where Dart's `[]` throws.
///
/// Not defensive padding: the transposition test reads `charAt(index - 1)` with
/// `index` legitimately 0, and `charAt(abbreviationIndex + 1)` one past the end
/// of the query. Both are load-bearing empty strings — they make the two
/// comparisons false — and a port that clamped instead would change the score.
String _charAt(String value, int index) =>
    index < 0 || index >= value.length ? '' : value[index];

/// `commandScoreInner` *(byte 591)*, transcribed.
double _commandScoreInner(
  String string,
  String abbreviation,
  String lowerString,
  String lowerAbbreviation,
  int stringIndex,
  int abbreviationIndex,
  Map<String, double> memoizedResults,
) {
  if (abbreviationIndex == abbreviation.length) {
    if (stringIndex == string.length) return _scoreContinueMatch;
    return _penaltyNotComplete;
  }

  final String memoizeKey = '$stringIndex,$abbreviationIndex';
  final double? memoized = memoizedResults[memoizeKey];
  // `!== undefined` — a memoized **0** is a real answer and is returned.
  if (memoized != null) return memoized;

  final String abbreviationChar = _charAt(lowerAbbreviation, abbreviationIndex);
  int index = lowerString.indexOf(abbreviationChar, stringIndex);
  double highScore = 0;

  while (index >= 0) {
    double score = _commandScoreInner(
      string,
      abbreviation,
      lowerString,
      lowerAbbreviation,
      index + 1,
      abbreviationIndex + 1,
      memoizedResults,
    );

    if (score > highScore) {
      if (index == stringIndex) {
        score *= _scoreContinueMatch;
      } else if (_isGap.hasMatch(_charAt(string, index - 1))) {
        score *= _scoreNonSpaceWordJump;
        final int wordBreaks = _isGap
            .allMatches(string.substring(stringIndex, index - 1))
            .length;
        if (wordBreaks > 0 && stringIndex > 0) {
          score *= math.pow(_penaltySkipped, wordBreaks).toDouble();
        }
      } else if (_isSpace.hasMatch(_charAt(string, index - 1))) {
        score *= _scoreSpaceWordJump;
        final int spaceBreaks = _isSpace
            .allMatches(string.substring(stringIndex, index - 1))
            .length;
        if (spaceBreaks > 0 && stringIndex > 0) {
          score *= math.pow(_penaltySkipped, spaceBreaks).toDouble();
        }
      } else {
        score *= _scoreCharacterJump;
        if (stringIndex > 0) {
          score *= math.pow(_penaltySkipped, index - stringIndex).toDouble();
        }
      }

      if (_charAt(string, index) != _charAt(abbreviation, abbreviationIndex)) {
        score *= _penaltyCaseMismatch;
      }
    }

    // Transposition: either the run scored badly and the *previous* character
    // is what the query wants next, or the query repeats a letter the string
    // does not. The second clause is upstream's "allow duplicate letters"
    // fix — its own comment cites cmdk issue #7428.
    if ((score < _scoreTransposition &&
            _charAt(lowerString, index - 1) ==
                _charAt(lowerAbbreviation, abbreviationIndex + 1)) ||
        (_charAt(lowerAbbreviation, abbreviationIndex + 1) ==
                _charAt(lowerAbbreviation, abbreviationIndex) &&
            _charAt(lowerString, index - 1) !=
                _charAt(lowerAbbreviation, abbreviationIndex))) {
      final double transposedScore = _commandScoreInner(
        string,
        abbreviation,
        lowerString,
        lowerAbbreviation,
        index + 1,
        abbreviationIndex + 2,
        memoizedResults,
      );
      if (transposedScore * _scoreTransposition > score) {
        score = transposedScore * _scoreTransposition;
      }
    }

    if (score > highScore) highScore = score;

    index = lowerString.indexOf(abbreviationChar, index + 1);
  }

  memoizedResults[memoizeKey] = highScore;
  return highScore;
}

/// `formatInput` *(byte 1229)* — lower-case, and fold every space character to
/// a literal space so the two sides can match each other.
String _formatInput(String value) =>
    value.toLowerCase().replaceAll(_isSpace, ' ');

/// cmdk's `commandScore` *(byte 1281)* — **0 hides the row entirely**, 1 is a
/// perfect match.
///
/// [aliases] is the `keywords` prop: they are appended to the searchable string
/// rather than scored separately, so `keywords: ['money']` makes
/// `"Open Wallet money"` the thing being matched.
///
/// Upstream's own note on the two lower-cased arguments: the original folded
/// case on every recursive call, and `toLowerCase()` dominated the profile.
/// Passing both is uglier and considerably faster.
double commandScore(
  String string,
  String abbreviation, [
  List<String> aliases = const <String>[],
]) {
  final String subject = aliases.isNotEmpty
      ? '$string ${aliases.join(' ')}'
      : string;
  return _commandScoreInner(
    subject,
    abbreviation,
    _formatInput(subject),
    _formatInput(abbreviation),
    0,
    0,
    <String, double>{},
  );
}

// ═══════════════════════════════════════════════════════════════════════════
// The data
// ═══════════════════════════════════════════════════════════════════════════

/// One `CommandItem`.
class CommandItem {
  const CommandItem({
    required this.label,
    this.icon,
    this.lucideIcon,
    this.iconTone,
    this.subtitle,
    this.meta,
    this.shortcut,
    this.value,
    this.keywords = const <String>[],
    this.enabled = true,
    this.onSelect,
  });

  /// The row's copy.
  final String label;

  /// A second line under [label] — `<span className="type-caption block
  /// truncate text-muted-foreground">`.
  ///
  /// `CommandItem` takes arbitrary children, and the agent's history palette is
  /// the corpus's only row that uses more than one line of them: title over
  /// preview. *(Measured: the row grows from 34.5625 to **48.7** — one 18.5714
  /// line box plus one 14.175 caption line box inside the same `py-2`.)*
  final String? subtitle;

  /// Trailing metadata that is **not** a `CommandShortcut` —
  /// `<span className="type-caption shrink-0 text-muted-foreground">`.
  ///
  /// The distinction is load-bearing twice. It rides [TextStyles.caption] rather
  /// than [TextStyles.menuShortcut], and because it carries no
  /// `data-slot="command-shortcut"` it does **not** trigger
  /// `group-has-data-[slot=command-shortcut]/command-item:hidden` — so the
  /// trailing check indicator is still rendered, at `opacity-0`, and still
  /// reserves its 16px. Drift 13 the other way round.
  final String? meta;

  /// The same slot as [icon], over the **generated** registry — the split
  /// [MenuItem] already makes. Ignored when [icon] is given.
  final LucideGlyph? lucideIcon;

  /// Overrides the row's own `tone="subtle"`.
  ///
  /// The history palette's pinned rows carry `tone="action"`, which the
  /// selected-row rule (`data-selected:*:[svg]:text-foreground`) then overrules
  /// exactly as it overrules the muted default.
  final IconTone? iconTone;

  /// The leading glyph. `Icon size="sm" tone="subtle"` on this page, which
  /// paints **16px at stroke 2.4** — drift 15, and why this is a glyph rather
  /// than a widget: the size is the row's decision, not the call site's.
  final IconGlyph? icon;

  /// `CommandShortcut`'s content — `$48.00`, `⌘W`. Right-aligned metadata, and
  /// the reason the trailing check never paints (drift 13).
  final String? shortcut;

  /// cmdk's `value` prop.
  ///
  /// Null derives it the way cmdk does, from the row's rendered text — and that
  /// means **the shortcut is part of what gets searched**. *(Measured)* the
  /// live rows carry `data-value="Eclipse Vault$48.00"`, so typing `48` finds
  /// the first pack. Surprising, load-bearing, and reproduced: see [searchValue].
  final String? value;

  /// cmdk's `keywords` — appended to the searchable string, not scored apart.
  final List<String> keywords;

  /// `data-[disabled=true]:pointer-events-none data-[disabled=true]:opacity-50`.
  final bool enabled;

  /// `onSelect` — fired by Enter, by a click, and by nothing else. The page
  /// binds none, which is why its palette does nothing when you commit a row.
  final VoidCallback? onSelect;

  /// What the matcher sees.
  ///
  /// cmdk's `useValue` walks `[props.value, props.children, ref]` and takes the
  /// first string it finds, falling through to `ref.current.textContent.trim()`.
  /// The icon contributes no text and JSX has already collapsed the whitespace
  /// around the label, so the derived value is the label and the shortcut
  /// **concatenated with nothing between them**.
  String get searchValue =>
      (value ?? '$label${subtitle ?? ''}${meta ?? ''}${shortcut ?? ''}').trim();
}

/// One `CommandGroup`.
class CommandGroup {
  const CommandGroup({
    required this.items,
    this.heading,
    this.separatorBefore = false,
  });

  final List<CommandItem> items;

  /// `heading` — rendered `px-3 py-2` at [TextStyles.menuHeading].
  ///
  /// Nullable because cmdk's `Group` only renders the heading element when the
  /// prop is set, while `p-2` applies either way. Both of the page's groups
  /// carry one.
  final String? heading;

  /// The `<CommandSeparator />` the reference writes as a **sibling** before
  /// this group.
  ///
  /// Attached to the group it precedes rather than modelled as its own list
  /// entry, so the arrangement cannot drift from the groups it separates. The
  /// page writes exactly one, between Packs and Actions.
  ///
  /// It is not painted while a query is running: *(measured)* the separator
  /// leaves the DOM the moment anything is typed and comes back when the input
  /// is cleared, because cmdk's `Separator` renders only when `!state.search`
  /// unless `alwaysRender` is set. That is a **1px** swing in the palette's
  /// height on the first keystroke.
  final bool separatorBefore;
}

/// A group after filtering: the surviving rows, in the order cmdk sorted them.
class _ResolvedGroup {
  _ResolvedGroup(this.source, this.items);

  final CommandGroup source;
  final List<CommandItem> items;
}

// ═══════════════════════════════════════════════════════════════════════════
// The widget
// ═══════════════════════════════════════════════════════════════════════════

/// The command palette — inline, always open.
class Command extends StatefulWidget {
  const Command({
    super.key,
    required this.groups,
    this.placeholder,
    this.emptyLabel,
    this.controller,
    this.focusNode,
    this.shouldFilter = true,
    this.filter,
    this.loop = false,
    this.vimBindings = true,
    this.label,
    this.onValueChanged,
    this.inDialog = false,
  });

  /// The palette is rendered inside a `DialogContent` — `CommandDialog`.
  ///
  /// Two measured consequences, and they arrive together because only
  /// `CommandDialog` produces either:
  ///
  ///  * **Every item takes `rounded-lg!`**, not `rounded-md`. `CommandItem`'s
  ///    own class list carries `in-data-[slot=dialog-content]:rounded-lg!`, so
  ///    a row inside the dialog corners at **12px** and one on a page corners
  ///    at 10.
  ///  * **The root paints the component's own surface.** `Command` declares
  ///    `bg-popover` and no border; the selects page's inline palette adds
  ///    `border border-border bg-card` at the *call site*, and
  ///    `CommandDialog`'s children are handed straight to `DialogContent`
  ///    without it. So inside a dialog the palette is a bare `--popover` fill
  ///    with no stroke, and the panel around it supplies the ring and the
  ///    radius. *(Measured: dialog 384 × 344 at radius 16 on `--popover`;
  ///    command 384 × 344, `p-2`, no border of its own.)*
  final bool inDialog;

  /// The groups, in the order they are written. **They are never reordered** —
  /// see [Command.sortsGroups].
  final List<CommandGroup> groups;

  /// The input's `placeholder` — **"Search packs, cards and actions…"** (the
  /// ellipsis is U+2026).
  final String? placeholder;

  /// `CommandEmpty`'s copy — **"Nothing matches that."**.
  ///
  /// Null renders no empty row, which is what a `Command` without the slot
  /// does. It mounts when the filtered count reaches zero and at no other time.
  final String? emptyLabel;

  final TextEditingController? controller;
  final FocusNode? focusNode;

  /// cmdk's `shouldFilter`, default **true**: *"automatic filtering and
  /// sorting"*. False shows every row in source order and leaves the narrowing
  /// to the caller.
  final bool shouldFilter;

  /// cmdk's `filter` prop. Defaults to [commandScore]; return 0 to hide.
  final double Function(String value, String search, List<String> keywords)?
  filter;

  /// cmdk's `loop`, which the reference leaves **unset** — so it is `undefined`,
  /// falsy, and the arrows stop dead at both ends. *(Measured: five ArrowDowns
  /// from the top of a four-row palette leave the fourth row selected.)*
  final bool loop;

  /// cmdk's `vimBindings`, default **true** — `Ctrl+N`/`Ctrl+J` step down,
  /// `Ctrl+P`/`Ctrl+K` step up.
  ///
  /// Worth naming: the page advertises **Ctrl + K** as the shortcut that opens
  /// the palette (drift 3 — nothing binds it), while inside the palette
  /// `Ctrl+K` already means *move up*.
  final bool vimBindings;

  /// The accessible name — cmdk renders it into a visually hidden `<label>`.
  final String? label;

  /// cmdk's `onValueChange`, carrying the selected row's [CommandItem.searchValue].
  final ValueChanged<String>? onValueChanged;

  /// `p-2` on the root, and the distance the separator bleeds back out.
  static double get padding => space(2);

  /// `max-h-72` — **288px** *(measured)*.
  static double get listMaxHeight => space(72);

  /// `h-8!` — the input group, at 32px rather than the family's 40.
  static double get inputHeight => space(8);

  /// `bg-input/30` and `border-input/30` — one alpha, both properties.
  static const double inputFillAlpha = 0.30;

  /// `opacity-50` on the search glyph. It is **not** a colour: the glyph reads
  /// `--muted-foreground` from the addon and then fades *(measured)*, which is
  /// a different result from `--foreground` at 50 % that the map derived.
  static const double searchGlyphOpacity = 0.50;

  /// `data-[disabled=true]:opacity-50`.
  static const double disabledOpacity = 0.50;

  /// `px-3 py-2` around one `text-sm` line box — **34.5625px** *(measured)*.
  static double get itemHeight {
    final TextStyleToken spec = TextStyles.bodyCompact;
    return (spec.size ?? 0) * (spec.height ?? 1) + space(2) * 2;
  }

  /// `px-3 py-2` around one `text-xs` line box — **32px** *(measured)*.
  static double get headingHeight {
    final TextStyleToken spec = TextStyles.menuHeading;
    return (spec.size ?? 0) * (spec.height ?? 1) + space(2) * 2;
  }

  /// `py-6` around one `text-sm` line box — **66.5625px** *(measured)*.
  static double get emptyHeight {
    final TextStyleToken spec = TextStyles.bodyCompact;
    return (spec.size ?? 0) * (spec.height ?? 1) + space(6) * 2;
  }

  /// **Items re-sort; groups do not.** The asymmetry is cmdk's, not the port's.
  ///
  /// `sort()` does two passes. The first reads each item's score, sorts the
  /// valid items descending and re-appends them **inside their own group** —
  /// that one works, and it is visible: *(measured)* typing `t` puts
  /// **Go to Stash above Open Wallet**, reversing the source order, because
  /// `t` after a space scores 0.891 against 0.17 mid-word.
  ///
  /// The second pass sorts the groups by their best item and re-appends them
  /// with
  /// `querySelector('[cmdk-group=""][data-value="' + encodeURIComponent(id) + '"]')`
  /// — where `id` is the group's React `useId`, while the element's
  /// `data-value` holds its **heading**. The selector matches nothing and the
  /// pass is a no-op. *(Measured)* typing `o` leaves Packs (best score 0.168)
  /// above Actions (best score 0.99), which is the opposite of what the code
  /// intends.
  ///
  /// Reproduced as it renders. Recorded as a new drift.
  static bool get sortsGroups => false;

  @override
  State<Command> createState() => _CommandState();
}

class _CommandState extends State<Command> {
  TextEditingController? _ownedController;
  FocusNode? _ownedFocusNode;

  TextEditingController get _controller =>
      widget.controller ?? (_ownedController ??= TextEditingController());

  FocusNode get _focusNode =>
      widget.focusNode ??
      (_ownedFocusNode ??= FocusNode(debugLabel: 'Command'));

  /// cmdk stores the selection as the item's **value**, not its index — which
  /// is what lets a row keep the highlight while the sort moves it.
  String? _value;

  /// The key of the selected row, so an arrow move can scroll it into view.
  /// Rebuilt every frame; only the current one is ever read.
  final Map<String, GlobalKey> _rowKeys = <String, GlobalKey>{};

  String get _search => _controller.text;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSearchChanged);
    // cmdk selects the first item once the items have registered, on the
    // schedule that follows the first render — `if (!state.value)
    // selectFirstItem()`. The palette therefore paints its first row
    // highlighted before the reader has touched anything, which is a static,
    // visible state and not a focus artefact.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _selectFirstItem();
    });
  }

  @override
  void didUpdateWidget(Command old) {
    super.didUpdateWidget(old);
    if (old.controller != widget.controller) {
      old.controller?.removeListener(_onSearchChanged);
      _controller.addListener(_onSearchChanged);
    }
    if (old.groups != widget.groups && _visibleItems.isNotEmpty) {
      final List<CommandItem> visible = _visibleItems;
      if (!visible.any((CommandItem i) => i.searchValue == _value)) {
        _selectFirstItem();
      }
    }
  }

  @override
  void dispose() {
    (widget.controller ?? _ownedController)?.removeListener(_onSearchChanged);
    _ownedController?.dispose();
    _ownedFocusNode?.dispose();
    super.dispose();
  }

  // ── filtering and sorting ────────────────────────────────────────────────

  double _score(CommandItem item) {
    final double Function(String, String, List<String>) filter =
        widget.filter ?? commandScore;
    return filter(item.searchValue, _search, item.keywords);
  }

  /// `filterItems()` then `sort()`, resolved into what actually paints.
  ///
  /// The guard is cmdk's: `if (!state.current.search || shouldFilter === false)
  /// return`. An **empty** query short-circuits both passes, so the source
  /// order stands — which matters, because `commandScore(value, '')` returns
  /// 0.99 for everything and a sort would otherwise run on a flat field.
  List<_ResolvedGroup> get _resolved {
    if (_search.isEmpty || !widget.shouldFilter) {
      return widget.groups
          .map((CommandGroup g) => _ResolvedGroup(g, g.items))
          .toList();
    }

    final List<_ResolvedGroup> out = <_ResolvedGroup>[];
    for (final CommandGroup group in widget.groups) {
      final List<({CommandItem item, double score, int order})> scored =
          <({CommandItem item, double score, int order})>[];
      for (int i = 0; i < group.items.length; i++) {
        final CommandItem item = group.items[i];
        final double score = _score(item);
        if (score > 0) scored.add((item: item, score: score, order: i));
      }
      // JavaScript's `Array.prototype.sort` has been stable since ES2019 and
      // Dart's `List.sort` is explicitly not, so the source index is the
      // tiebreaker. Without it, equal scores — which this corpus produces
      // constantly — would shuffle.
      scored.sort((
        ({CommandItem item, double score, int order}) a,
        ({CommandItem item, double score, int order}) b,
      ) {
        final int byScore = b.score.compareTo(a.score);
        return byScore != 0 ? byScore : a.order.compareTo(b.order);
      });
      // A group with nothing left takes the `hidden` attribute and stops
      // occupying space entirely — heading, padding and all *(measured)*.
      if (scored.isEmpty) continue;
      out.add(
        _ResolvedGroup(
          group,
          scored
              .map((({CommandItem item, double score, int order}) e) => e.item)
              .toList(),
        ),
      );
    }
    return out;
  }

  /// Every visible row, in paint order — the ring the arrows walk.
  List<CommandItem> get _visibleItems => <CommandItem>[
    for (final _ResolvedGroup g in _resolved) ...g.items,
  ];

  /// `getValidItems()` — `[cmdk-item=""]:not([aria-disabled="true"])`.
  List<CommandItem> get _validItems =>
      _visibleItems.where((CommandItem i) => i.enabled).toList();

  void _onSearchChanged() {
    // `setState('search', …)` schedules `filterItems(); sort(); selectFirstItem()`
    // — the highlight goes back to the top on **every** keystroke.
    setState(_selectFirstItemInner);
  }

  void _selectFirstItem() => setState(_selectFirstItemInner);

  void _selectFirstItemInner() {
    final List<CommandItem> valid = _validItems;
    _setValue(valid.isEmpty ? null : valid.first.searchValue, notify: true);
  }

  void _setValue(String? next, {bool notify = false}) {
    if (_value == next) return;
    _value = next;
    if (notify && next != null) widget.onValueChanged?.call(next);
  }

  /// `updateSelectedByChange(change)` — and `loop` is off, so the ends hold.
  void _move(int step) {
    final List<CommandItem> valid = _validItems;
    if (valid.isEmpty) return;
    final int at = valid.indexWhere((CommandItem i) => i.searchValue == _value);
    int next = at + step;
    if (widget.loop) {
      next = next < 0
          ? valid.length - 1
          : next >= valid.length
          ? 0
          : next;
    }
    if (next < 0 || next >= valid.length) return;
    setState(() => _setValue(valid[next].searchValue, notify: true));
    _scrollSelectedIntoView(step);
  }

  /// `updateSelectedByIndex(index)` — Home is 0, End is the last row.
  void _moveTo(int index) {
    final List<CommandItem> valid = _validItems;
    if (valid.isEmpty) return;
    final int at = index < 0 ? valid.length - 1 : index;
    if (at < 0 || at >= valid.length) return;
    setState(() => _setValue(valid[at].searchValue, notify: true));
    _scrollSelectedIntoView(index < 0 ? 1 : -1);
  }

  /// `updateSelectedByGroup(change)` — Alt+Arrow steps to the next group's
  /// first row, and falls back to a plain step when there is no next group.
  void _moveByGroup(int step) {
    final List<_ResolvedGroup> groups = _resolved;
    final int at = groups.indexWhere(
      (_ResolvedGroup g) =>
          g.items.any((CommandItem i) => i.searchValue == _value),
    );
    if (at < 0) return _move(step);
    final int target = at + step;
    if (target < 0 || target >= groups.length) return _move(step);
    final Iterable<CommandItem> valid = groups[target].items.where(
      (CommandItem i) => i.enabled,
    );
    if (valid.isEmpty) return _move(step);
    setState(() => _setValue(valid.first.searchValue, notify: true));
    _scrollSelectedIntoView(step);
  }

  /// `scrollSelectedIntoView` — `scrollIntoView({ block: 'nearest' })`, which
  /// is the alignment policy that only moves when the row is off-screen.
  ///
  /// Deliberately **not** called from a click or a hover: cmdk's `Item.select()`
  /// passes `true` as `setState`'s third argument, and that flag's only job is
  /// to skip this. A row you just pointed at does not need scrolling to.
  ///
  /// On this page it never fires — the list is 235.25px inside a 288px cap
  /// *(measured)*, so nothing ever overflows.
  void _scrollSelectedIntoView(int step) {
    final String? value = _value;
    if (value == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final BuildContext? ctx = _rowKeys[value]?.currentContext;
      if (ctx == null || !ctx.mounted) return;
      Scrollable.ensureVisible(
        ctx,
        alignmentPolicy: step > 0
            ? ScrollPositionAlignmentPolicy.keepVisibleAtEnd
            : ScrollPositionAlignmentPolicy.keepVisibleAtStart,
      );
    });
  }

  void _commit(CommandItem item) {
    // `Item.select()` — set the value, then dispatch `cmdk-item-select`, which
    // is the event `onSelect` listens for. The page binds none of them.
    setState(() => _setValue(item.searchValue, notify: true));
    item.onSelect?.call();
  }

  // ── the root keydown ─────────────────────────────────────────────────────

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    final HardwareKeyboard keys = HardwareKeyboard.instance;
    final bool ctrl = keys.isControlPressed;
    final bool alt = keys.isAltPressed;
    final bool meta = keys.isMetaPressed;
    final LogicalKeyboardKey key = event.logicalKey;

    // `case 'n': case 'j': { vimBindings && e.ctrlKey && next(e) }`
    if (ctrl && widget.vimBindings) {
      if (key == LogicalKeyboardKey.keyN || key == LogicalKeyboardKey.keyJ) {
        _move(1);
        return KeyEventResult.handled;
      }
      if (key == LogicalKeyboardKey.keyP || key == LogicalKeyboardKey.keyK) {
        _move(-1);
        return KeyEventResult.handled;
      }
    }

    if (key == LogicalKeyboardKey.arrowDown) {
      // `e.metaKey ? last() : e.altKey ? updateSelectedByGroup(1) : …`
      if (meta) {
        _moveTo(-1);
      } else if (alt) {
        _moveByGroup(1);
      } else {
        _move(1);
      }
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowUp) {
      if (meta) {
        _moveTo(0);
      } else if (alt) {
        _moveByGroup(-1);
      } else {
        _move(-1);
      }
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.home) {
      _moveTo(0);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.end) {
      _moveTo(-1);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.numpadEnter) {
      final CommandItem? selected = _selectedItem;
      // `e.preventDefault()` runs whether or not there is a row, so Enter never
      // reaches the input.
      if (selected != null) _commit(selected);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  CommandItem? get _selectedItem {
    for (final CommandItem item in _visibleItems) {
      if (item.searchValue == _value) return item;
    }
    return null;
  }

  // ── paint ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final List<_ResolvedGroup> resolved = _resolved;
    final bool empty = resolved.every((_ResolvedGroup g) => g.items.isEmpty);

    _rowKeys.removeWhere(
      (String value, GlobalKey _) =>
          !_visibleItems.any((CommandItem i) => i.searchValue == value),
    );

    final List<Widget> rows = <Widget>[];
    for (final _ResolvedGroup group in resolved) {
      // The separator is a sibling of the group, and it is not rendered at all
      // while a query is running.
      if (group.source.separatorBefore && _search.isEmpty) {
        // Full width, outside the horizontal inset every other child carries —
        // which is the whole of `-mx-2`.
        rows.add(_CommandSeparator(theme: theme));
      }
      rows.add(
        _inset(
          _CommandGroupBlock(
            theme: theme,
            heading: group.source.heading,
            children: <Widget>[
              for (final CommandItem item in group.items)
                _CommandRow(
                  key: _rowKeys.putIfAbsent(item.searchValue, GlobalKey.new),
                  theme: theme,
                  item: item,
                  inDialog: widget.inDialog,
                  selected: item.searchValue == _value,
                  onTap: () => _commit(item),
                  // `onPointerMove` — `disablePointerSelection` defaults false, so
                  // the pointer takes the highlight *(measured)*. And it keeps it:
                  // moving off the palette leaves the last-hovered row selected,
                  // because there is no matching pointer-leave handler.
                  onHover: () {
                    if (_value == item.searchValue) return;
                    setState(() => _setValue(item.searchValue, notify: true));
                  },
                ),
            ],
          ),
        ),
      );
    }

    Widget list = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // `CommandEmpty` renders when `filtered.count === 0` — including the
        // case of a palette with no items and no query.
        if (empty && widget.emptyLabel != null)
          _inset(_CommandEmpty(theme: theme, label: widget.emptyLabel!)),
        ...rows,
      ],
    );

    // `no-scrollbar max-h-72 scroll-py-1 overflow-y-auto`. Flutter paints no
    // scrollbar on a bare scroll view, so `no-scrollbar` needs no code, and a
    // `SingleChildScrollView` under a zero minimum shrink-wraps its child, so
    // the cap is a cap and not a height. `scroll-py-1` is **scroll**-padding —
    // it biases `scrollIntoView`'s resting position and contributes nothing to
    // layout; the list's own padding is 0 *(measured)*, and adding 4px here
    // would put the palette 8px over its measured height.
    list = ConstrainedBox(
      constraints: BoxConstraints(maxHeight: Command.listMaxHeight),
      child: SingleChildScrollView(child: list),
    );

    Widget palette = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // The root's `p-2` on three sides, over the wrapper's own `p-2 pb-0`.
        // *(Measured)* the input group sits 17px below the palette's top edge:
        // 1 border + 8 + 8.
        Padding(
          padding: EdgeInsets.only(
            left: Command.padding,
            right: Command.padding,
            top: Command.padding,
          ),
          child: _CommandInput(
            theme: theme,
            controller: _controller,
            focusNode: _focusNode,
            placeholder: widget.placeholder,
            label: widget.label,
          ),
        ),
        list,
        // The root's `p-2` at the bottom, which sits **outside** the list —
        // *(measured)* the list's lower edge is 9px above the palette's.
        SizedBox(height: Command.padding),
      ],
    );

    // `text-popover-foreground` on the root — and `text-foreground` on each
    // group inside it. Both resolve to the same value in both themes today;
    // both are written, because the reference writes both.
    palette = DefaultTextStyle.merge(
      style: TextStyle(color: theme.popoverForeground),
      child: palette,
    );

    // `flex size-full flex-col overflow-hidden rounded-xl!` + the call site's
    // `border border-border bg-card`. The radius is 16 — see the library doc.
    //
    // The root's `p-2` is **not** applied here. `CommandSeparator`'s `-mx-2`
    // cancels it exactly, so the separator spans the root's whole content box
    // *(measured: 1028px inside a 1030px palette)*. Flutter has no negative
    // margin, so the inset is pushed down onto the children that actually take
    // it — [_inset] — and the separator simply never asks for it. The four
    // edges still measure 8: the input carries it above, [_inset] carries it
    // beside every group and the empty row, and a spacer carries it below.
    palette = Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        // `bg-popover` is the component's own; `bg-card` and the stroke are the
        // inline call site's, which `CommandDialog` does not write. See
        // [Command.inDialog].
        color: widget.inDialog ? theme.popover : theme.card,
        borderRadius: BorderRadius.circular(Radii.xl),
        border: widget.inDialog
            ? null
            : Border.all(color: theme.border, width: BorderWidths.hairline),
      ),
      child: palette,
    );

    // `<div cmdk-root tabIndex={-1} onKeyDown={…}>` — the handler is on the
    // root, so it fires from anywhere inside, and it sits above the input in
    // the tree so it sees Home/End/arrows before the text field's own editing
    // shortcuts turn them into caret moves.
    palette = Focus(
      canRequestFocus: false,
      skipTraversal: true,
      onKeyEvent: _onKey,
      child: palette,
    );

    return Semantics(container: true, label: widget.label, child: palette);
  }

  /// The root's `p-2`, applied to a list child rather than to the root — see
  /// the note beside the root's `Container`.
  Widget _inset(Widget child) => Padding(
    padding: EdgeInsets.symmetric(horizontal: Command.padding),
    child: child,
  );
}

// ═══════════════════════════════════════════════════════════════════════════
// The parts
// ═══════════════════════════════════════════════════════════════════════════

/// `CommandInput`'s wrapper, its overridden `InputGroup`, and the raw input.
///
/// Not a [InputGroup]: that widget fixes the 40px pill, the `--card` fill and
/// `shadow-pressed`, all three of which this control overrides, and its file is
/// another task's. The recipe is the same one, at the measured values.
class _CommandInput extends StatelessWidget {
  const _CommandInput({
    required this.theme,
    required this.controller,
    required this.focusNode,
    this.placeholder,
    this.label,
  });

  final ThemeTokens theme;
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? placeholder;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final Color fill = theme.input.withValues(alpha: Command.inputFillAlpha);

    Widget group = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        // `InputGroupAddon` with the default `align="inline-start"`, which
        // `order-first` pins to the leading edge — the glyph renders **left of**
        // the input despite being written after it. `pl-2!` overrides the
        // addon's own `pl-4`.
        Padding(
          padding: EdgeInsets.only(
            left: space(2),
            // `py-1.5`, the same inset [InputGroupAddon] carries.
            top: InputGroupAddon.insetY,
            bottom: InputGroupAddon.insetY,
          ),
          child: Opacity(
            opacity: Command.searchGlyphOpacity,
            child: const Icon(
              IconGlyph.search,
              // The addon's `text-muted-foreground`, which the glyph inherits
              // through `Icon`'s default tone — *(measured)* rgb(212,212,216)
              // at opacity .5, i.e. `--muted-foreground`, and **not** the
              // `--foreground` at 50 % the map derived.
              tone: IconTone.muted,
            ),
          ),
        ),
        Expanded(
          child: Input(
            controller: controller,
            focusNode: focusNode,
            placeholder: placeholder,
            label: label,
            // `CommandPrimitive.Input` is a raw `<input>`, not the `Input`
            // component: `w-full text-sm outline-hidden` and nothing else. No
            // `px-4`, and the group's `has-[>[data-align=inline-start]]:pl-2`
            // supplies the 8px on the addon side *(measured)*.
            bare: true,
            padding: EdgeInsetsDirectional.only(start: space(2)),
          ),
        ),
      ],
    );

    group = DecoratedBox(
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(Radii.lg),
        border: Border.all(color: fill, width: BorderWidths.hairline),
      ),
      child: group,
    );

    // `h-8!`. No socket and no focus ring: `shadow-none!` kills the first and
    // the group's focus predicate looks for a `data-slot` this input does not
    // carry, so the second never fires either.
    group = SizedBox(height: Command.inputHeight, child: group);

    // The wrapper's own `p-2 pb-0` — the sides and the top, nothing below. The
    // root's matching inset is applied by the caller.
    return Padding(
      padding: EdgeInsets.only(left: space(2), right: space(2), top: space(2)),
      child: group,
    );
  }
}

/// `CommandGroup` — `overflow-hidden p-2 text-foreground`, plus the heading its
/// arbitrary-variant types.
class _CommandGroupBlock extends StatelessWidget {
  const _CommandGroupBlock({
    required this.theme,
    required this.heading,
    required this.children,
  });

  final ThemeTokens theme;
  final String? heading;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      // `p-2`.
      padding: EdgeInsets.all(space(2)),
      child: DefaultTextStyle.merge(
        // `text-foreground` — the group re-declares the ink the root already
        // set to `--popover-foreground`. Two tokens, one value, both written.
        style: TextStyle(color: theme.foreground),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (heading != null)
              Padding(
                // `px-3 py-2` — 32px tall around a 16px line box.
                padding: EdgeInsets.symmetric(
                  horizontal: space(3),
                  vertical: space(2),
                ),
                child: StyledText(
                  heading!,
                  TextStyles.menuHeading,
                  color: theme.mutedForeground,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ...children,
          ],
        ),
      ),
    );
  }
}

/// `CommandSeparator` — `-mx-2 h-px bg-border`.
///
/// The `-mx-2` bleeds it back out through the root's `p-2`, so it spans the
/// root's whole content box: *(measured)* 1028px inside a 1030px palette,
/// stopping exactly at the 1px border on each side. And there is **no vertical
/// margin at all** — drift 7, against `SelectSeparator`'s 17px of air.
class _CommandSeparator extends StatelessWidget {
  const _CommandSeparator({required this.theme});

  final ThemeTokens theme;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: BorderWidths.hairline,
      child: ColoredBox(color: theme.border),
    );
  }
}

/// `CommandItem` — `relative flex cursor-default items-center gap-2 rounded-md
/// px-3 py-2 text-sm data-selected:bg-muted data-selected:text-foreground`.
class _CommandRow extends StatelessWidget {
  const _CommandRow({
    super.key,
    required this.theme,
    required this.item,
    required this.selected,
    required this.onTap,
    required this.onHover,
    this.inDialog = false,
  });

  final ThemeTokens theme;
  final CommandItem item;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onHover;

  /// `in-data-[slot=dialog-content]:rounded-lg!` — see [Command.inDialog].
  final bool inDialog;

  @override
  Widget build(BuildContext context) {
    // `data-selected:text-foreground` over the group's own `text-foreground`:
    // the same token twice, so only the fill actually moves.
    final Color ink = theme.foreground;

    // `group-data-selected/command-item:text-foreground` on the shortcut, and
    // `data-selected:*:[svg]:text-foreground` on the glyph — one rule each,
    // the same pair of tokens. *(Measured)* the selected row's leading Search
    // glyph reads `--foreground` while its neighbour's reads
    // `--muted-foreground`.
    final Color meta = selected ? theme.foreground : theme.mutedForeground;

    Widget row = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        if (item.icon != null || item.lucideIcon != null) ...<Widget>[
          if (item.icon != null)
            Icon(
              item.icon!,
              // `size="sm"` writes 14 into the SVG's attributes and the row's
              // `[&_svg:not([class*='size-'])]:size-4` overrules it to **16**,
              // while `strokeWidth` stays computed from the 14 — drift 15.
              // *(Measured: a 16px box at stroke 2.4.)* The port needs no
              // override for it: `strokeFor` is 2.4 at both sizes, because 48/16
              // and 48/14 both clear the same 2.6 threshold, so the drift
              // collapses to an identity here exactly as it does in an addon.
              sizePx: space(4),
              // `tone="subtle"`, brightened by the selected row's own rule.
              tone: selected
                  ? IconTone.normal
                  : (item.iconTone ?? IconTone.subtle),
            )
          else
            Icon.lucide(
              item.lucideIcon!,
              sizePx: space(4),
              tone: selected
                  ? IconTone.normal
                  : (item.iconTone ?? IconTone.subtle),
            ),
          // `gap-2`.
          SizedBox(width: space(2)),
        ],
        Expanded(
          // `<span className="min-w-0 flex-1">` — one block when the row is one
          // line, two stacked blocks when it carries a [CommandItem.subtitle].
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              StyledText(
                item.label,
                TextStyles.bodyCompact,
                color: ink,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
              ),
              if (item.subtitle != null)
                StyledText(
                  item.subtitle!,
                  TextStyles.caption,
                  color: theme.mutedForeground,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
            ],
          ),
        ),
        if (item.meta != null) ...<Widget>[
          SizedBox(width: space(2)),
          // `shrink-0 text-muted-foreground`, and muted whether or not the row
          // is selected — the span's own class beats `data-selected:text-*`.
          StyledText(
            item.meta!,
            TextStyles.caption,
            color: theme.mutedForeground,
            maxLines: 1,
            softWrap: false,
          ),
        ],
        if (item.shortcut != null)
          // `ml-auto` — the shortcut is pushed to the trailing edge, which the
          // Expanded above already does.
          StyledText(
            item.shortcut!,
            TextStyles.menuShortcut,
            color: meta,
            maxLines: 1,
          )
        else
        // The trailing check, and the whole of drift 13. It is
        // `display:none` whenever the row has a shortcut — which is every row
        // on this page — and `opacity-0` otherwise, so on a shortcut-less row
        // it reserves 16px and shows nothing. Only `data-checked` reveals it,
        // and nothing here sets that.
        ...<Widget>[
          SizedBox(width: space(2)),
          Opacity(opacity: 0, child: Icon(IconGlyph.check, sizePx: space(4))),
        ],
      ],
    );

    row = Padding(
      // `px-3 py-2` — 34.5625px around a 18.5714px line box.
      padding: EdgeInsets.symmetric(horizontal: space(3), vertical: space(2)),
      child: row,
    );

    row = DecoratedBox(
      decoration: BoxDecoration(
        // `data-selected:bg-muted` — a third highlight token on one page,
        // drift 5. There is no `transition-*` on this row, so it snaps.
        color: selected ? theme.muted : transparent,
        borderRadius: BorderRadius.circular(inDialog ? Radii.lg : Radii.md),
      ),
      child: row,
    );

    row = Stack(
      // The item is a flex child of a block group, so it fills the width; a
      // highlight that stopped at the label would not be the row highlighting.
      // The same reason `_ComboboxRow` and `_SelectItem` pass their constraints
      // through.
      fit: StackFit.passthrough,
      children: <Widget>[row],
    );

    row = DefaultTextStyle.merge(
      style: TextStyle(color: ink),
      child: row,
    );

    row = Opacity(
      opacity: item.enabled ? 1 : Command.disabledOpacity,
      child: row,
    );

    return Semantics(
      button: true,
      selected: selected,
      enabled: item.enabled,
      label: item.shortcut == null
          ? item.label
          : '${item.label} ${item.shortcut}',
      child: MouseRegion(
        // `cursor-default` — a command row is not a link.
        cursor: SystemMouseCursors.basic,
        onEnter: item.enabled ? (_) => onHover() : null,
        onHover: item.enabled ? (_) => onHover() : null,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: item.enabled ? onTap : null,
          child: row,
        ),
      ),
    );
  }
}

/// `CommandEmpty` — `py-6 text-center text-sm`.
///
/// **66.5625px** *(measured)*, centred across the list's full width, and it
/// inherits the root's `--popover-foreground` rather than declaring an ink of
/// its own. Unlike `ComboboxEmpty` it is not muted.
class _CommandEmpty extends StatelessWidget {
  const _CommandEmpty({required this.theme, required this.label});

  final ThemeTokens theme;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: space(6)),
      child: StyledText(
        label,
        TextStyles.bodyCompact,
        color: theme.popoverForeground,
        align: TextAlign.center,
      ),
    );
  }
}
