/// The docs component library, `components/space/kit.tsx`.
///
/// Every foundation page is assembled out of these and nothing else: a header,
/// sections, framed panels, notes, reference lists, do/don't pairs, index
/// cards and a foot nav. The pages carry copy and specimens; the anatomy lives
/// here, once.
///
/// Two rendering facts that look like bugs and are not:
/// * `Section` renders an `h2` **styled `.type-h3`**: the reference's own
///   deliberate choice, so a page's sections sit a step below its `h1`.
/// * A [Note] title is **always** muted-foreground, in every tone.
///   `.type-label` declares `color: var(--muted-foreground)` on the element
///   itself, which beats the wrapper's `text-*-ink` by inheritance. The tone
///   shows in the border and the wash, never in the title.
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

import 'docs/docs_section.dart';
import 'nav.dart';
import 'shell.dart';

/// `max-w-2xl`, 42rem, the measure every blurb and section description is cut
/// to.
final double _measure2xl = space(168);

/// `sm:grid-cols-[minmax(0,13rem)_1fr]`: the key column in [Meta] and the
/// left column of a swatch row.
final double _keyColumn = space(52);

/// `hover:border-action/45` on a lifting card.
const double _cardHoverBorderAlpha = 0.45;

/// `border-<tone>/30` and `bg-<tone>/[0.08]` on a [Note].
const double _noteBorderAlpha = 0.30;
const double _noteWashAlpha = 0.08;

/// `border-<tone>/25` and `bg-<tone>/[0.06]` on a [DoDont] panel.
const double _doDontBorderAlpha = 0.25;
const double _doDontWashAlpha = 0.06;

/// `group-hover:translate-x-0.5`: how far a card's arrow slides.
final double _arrowSlide = space(0.5);

/* ── Page header ─────────────────────────────────────────────────────────── */

/// `header.mb-14.border-b.border-border.pb-10`.
class PageHeader extends StatelessWidget {
  const PageHeader({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.blurb,
    this.contents,
  });

  /// `.type-label text-action-ink`: the group this page belongs to.
  final String eyebrow;

  final String title;

  final String blurb;

  /// The chip row. Omitted on the overview page; the colors page passes its
  /// own list rather than the nav registry's (a documented drift).
  final List<String>? contents;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final List<String> chips = contents ?? const <String>[];

    return Container(
      margin: EdgeInsets.only(bottom: space(14)),
      padding: EdgeInsets.only(bottom: space(10)),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.border, width: BorderWidths.hairline),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          StyledText(eyebrow, TextStyles.eyebrow, color: theme.actionText),
          SizedBox(height: space(4)),
          StyledText(
            title,
            TextStyles.h1,
            fontSize: Fluid.h1(context),
            color: theme.foreground,
          ),
          SizedBox(height: space(4)),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: _measure2xl),
            child: StyledText(blurb, TextStyles.lead),
          ),
          if (chips.isNotEmpty) ...<Widget>[
            SizedBox(height: space(7)),
            Wrap(
              spacing: space(2),
              runSpacing: space(2),
              children: <Widget>[
                for (final String chip in chips) _HeaderChip(label: chip),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// `li.type-chip.rounded-pill.border.border-border.bg-card.px-3.py-1.5`.
class _HeaderChip extends StatelessWidget {
  const _HeaderChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: space(3), vertical: space(1.5)),
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(Radii.full),
        border: Border.all(color: theme.border, width: BorderWidths.hairline),
      ),
      child: StyledText(label, TextStyles.chip, color: theme.mutedForeground),
    );
  }
}

/* ── Section ─────────────────────────────────────────────────────────────── */

/// `section#<id>.mb-20` with an `h2.type-h3` and an optional description.
///
/// The `id` is not decoration: it is the anchor an in-page link scrolls to.
/// The reference has **no** `scroll-mt-*` anywhere, `html` carries
/// `scroll-padding-block-start: var(--scroll-offset)` (96px), which is where
/// [scrollTo] puts the section's top edge.
class Section extends StatelessWidget {
  const Section({
    super.key,
    required this.id,
    required this.title,
    this.description,
    required this.child,
  });

  final String id;
  final String title;
  final String? description;
  final Widget child;

  /// Forwarded so `docs_layout.dart` keeps one anchor registry.
  static GlobalKey<State<StatefulWidget>> anchorKey(String id) =>
      DocsAnchor.keyFor(id);

  static Future<void> scrollTo(String id) => DocsAnchor.scrollTo(id);

  @override
  Widget build(BuildContext context) =>
      DocsSection(id: id, title: title, description: description, child: child);
}

/* ── Panel ───────────────────────────────────────────────────────────────── */

/// The framed stage every specimen sits on.
///
/// `overflow-hidden rounded-xl border border-border bg-card`, an optional
/// muted header strip, and a `--background` body: so a specimen is never
/// judged against the card it is mounted on.
class Panel extends StatelessWidget {
  const Panel({
    super.key,
    this.label,
    this.note,
    required this.child,
    this.flush = false,
    this.bodyPadding,
    this.bodyFill,
  });

  /// `.type-label text-muted-foreground`, left of the strip.
  final String? label;

  /// `.type-num-sm text-muted-foreground`, right of the strip.
  final String? note;

  final Widget child;

  /// Drops the body padding, for specimens that reach the panel edge.
  final bool flush;

  /// Overrides `p-6`: the typography page's prose panel uses `p-6 sm:p-10`.
  final EdgeInsetsGeometry? bodyPadding;

  /// Overrides the body's `--background` fill.
  ///
  /// `bodyClassName` on the reference's own `Panel`, used by exactly two panels
  /// in the corpus: the chat page's two `BubbleReactions` specimens pass
  /// `bodyClassName="bg-card"`, because the rail rings itself in `--card` to
  /// punch a hole in the bubble edge and on `--background` that ring reads as a
  /// halo. The page says so in a source comment above them.
  final Color? bodyFill;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final BorderRadius radius = BorderRadius.circular(Radii.xl);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: radius,
        border: Border.all(color: theme.border, width: BorderWidths.hairline),
      ),
      // `box-sizing: border-box`: the frame is paid for out of the panel's
      // own width, so the strip and the body start at the border's inner edge
      // and are two pixels narrower than the panel. Outside the clip, not
      // inside it, so the body's fill still reaches that edge instead of
      // leaving a hairline of card showing.
      child: Padding(
        padding: const EdgeInsets.all(BorderWidths.hairline),
        child: ClipRRect(
          // `overflow-hidden`, so the body's fill stops at the corner: on the
          // *inner* curve, which CSS derives as the outer radius less the
          // border it sits inside.
          borderRadius: BorderRadius.circular(Radii.xl - BorderWidths.hairline),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (label != null || note != null)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: space(5),
                    vertical: space(3),
                  ),
                  decoration: BoxDecoration(
                    color: theme.muted,
                    border: Border(
                      bottom: BorderSide(
                        color: theme.border,
                        width: BorderWidths.hairline,
                      ),
                    ),
                  ),
                  child: _PanelStrip(label: label, note: note),
                ),
              Container(
                color: bodyFill ?? theme.background,
                padding: flush
                    ? EdgeInsets.zero
                    : bodyPadding ?? EdgeInsets.all(space(6)),
                child: child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The header strip's `flex items-baseline justify-between gap-4`.
///
/// A CSS flex item is laid out at the width its content asks for and shrinks
/// only when the line runs out of room; a Flutter `Flexible` is offered a
/// *share* of the row up front. The difference shows: a `Spacer` between two
/// `Flexible`s makes three flex children, each capped at a third of the strip,
/// and "Geist Mono: numerical values", 249.66px against a 163px third —
/// wrapped to a second line the browser never draws, pushing everything under
/// that panel 11px down.
///
/// So there is no spacer, and the count of flex children is the count of
/// strings. That was half of it. **The other half is that an equal share is
/// still not `flex: 0 1 auto`.** It was enough while every panel was full
/// width: the widest pairing on the first four pages is 170px + 240.7px
/// inside a 1038px strip, and half of that is plenty: but the motion page
/// puts panels three-up, and on a 307.33px strip half is 145.67px. Four
/// `.type-num-sm` notes did not fit it, each wrapped one 14.4px line the
/// browser never draws, and two of that page's sections came out 28.8px tall
/// between them. Same bug as the `Spacer`, one breakpoint further down.
///
/// So the share is weighted by what each run actually measures. `flex: 0 1
/// auto` is two rules in one, **the base size is the content width**, and
/// **shrinkage is proportional to that base**: and giving each [Flexible] a
/// flex of its own natural width reproduces both, because a proportional share
/// of the free space is `free × wᵢ / Σw`:
/// * while the pair fits, `free ≥ Σw`, so every share is at least the width it
///   was measured at: nothing is offered less than it asked for, and nothing
///   wraps that the browser would not wrap. `FlexFit.loose` then hands the
///   slack back, which is what `justify-between` puts between the two;
/// * once the pair does not fit, the shares fall in proportion to base size,
///   which is exactly what `flex-shrink: 1` computes against `flex-basis:
///   auto`: so the overflow behaviour the equal split got right is kept.
class _PanelStrip extends StatelessWidget {
  const _PanelStrip({this.label, this.note});

  final String? label;
  final String? note;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final Widget? labelText = label == null
        ? null
        : StyledText(label!, TextStyles.eyebrow, color: theme.mutedForeground);
    final Widget? noteText = note == null
        ? null
        // `.type-num-*` declares no colour of its own; the strip states it.
        : StyledText(
            note!,
            TextStyles.numberSm,
            color: theme.mutedForeground,
            // Alignment only matters in the one shape where the note fills the
            // row: with no label to push it over, it right-aligns itself.
            align: label == null ? TextAlign.right : null,
          );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      // `justify-between`: whatever neither string claims falls between them.
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        if (labelText != null)
          Flexible(
            flex: _basis(context, label!, TextStyles.eyebrow),
            child: labelText,
          ),
        if (labelText != null && noteText != null) SizedBox(width: space(4)),
        if (noteText != null)
          if (labelText == null)
            // One run and nothing to share with: it takes the strip, and its
            // own `text-align` is what pushes it to the far edge.
            Expanded(child: noteText)
          else
            Flexible(
              flex: _basis(context, note!, TextStyles.numberSm),
              child: noteText,
            ),
      ],
    );
  }

  /// The `flex-basis: auto` of a run, as a flex weight.
  ///
  /// Rounded because [Flexible.flex] is an `int`, and floored at 1 because
  /// `flex: 0` is not a small share: it is no share at all, and a run that
  /// measured zero would be given no width to lay out in.
  static int _basis(BuildContext context, String text, TextStyleToken spec) {
    final int width = _naturalWidth(context, text, spec).round();
    return width < 1 ? 1 : width;
  }

  /// What [text] asks for in [spec] with no line to run out of, `max-content`,
  /// which is what a flex item's `auto` basis resolves to.
  ///
  /// Measured on the string the class actually paints, not the string it was
  /// authored with: `.type-label` applies `text-transform: uppercase` at paint
  /// time, and `TWELVE COLUMNS · 24PX GUTTERS` is wider than the sentence case
  /// it is written in.
  static double _naturalWidth(
    BuildContext context,
    String text,
    TextStyleToken spec,
  ) {
    final TextPainter painter = TextPainter(
      text: TextSpan(
        text: spec.uppercase ? text.toUpperCase() : text,
        // Colour cannot move a glyph, so the strip's own `text-*` override is
        // left off and the class resolves its metrics alone.
        style: StyledText.styleOf(context, spec),
      ),
      textDirection: Directionality.of(context),
    )..layout();
    final double width = painter.width;
    painter.dispose();
    return width;
  }
}

/* ── Row ─────────────────────────────────────────────────────────────────── */

/// How a [SpecimenRow] lines its specimens up within a run.
///
/// The reference's `align` prop offers a fourth value, `baseline`, which no
/// page passes. It is **not** declared here: [Wrap] cross-aligns by
/// [WrapCrossAlignment], which has no baseline member, so the value would have
/// to silently behave like [start]: and a parameter that quietly does the
/// wrong thing is worse than an absent one.
enum SpecimenRowAlign {
  /// `items-center`: the default.
  center,

  /// `items-start`.
  start,

  /// `items-end`: the size ladder, where aligning the columns' bottoms is
  /// what gives the five buttons a shared baseline.
  end,
}

/// `div.flex.flex-wrap.gap-4`: the horizontal cluster of specimens.
///
/// One gap on both axes: `gap-4` sets `row-gap` and `column-gap` together, so
/// a run that wraps sits 16px under the one above it.
class SpecimenRow extends StatelessWidget {
  const SpecimenRow({
    super.key,
    required this.children,
    this.align = SpecimenRowAlign.center,
  });

  final List<Widget> children;

  final SpecimenRowAlign align;

  /// `gap-4`.
  static double get gap => space(4);

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: gap,
    runSpacing: gap,
    crossAxisAlignment: switch (align) {
      SpecimenRowAlign.center => WrapCrossAlignment.center,
      SpecimenRowAlign.start => WrapCrossAlignment.start,
      SpecimenRowAlign.end => WrapCrossAlignment.end,
    },
    children: children,
  );
}

/* ── State matrices ──────────────────────────────────────────────────────── */

/// `div.grid.gap-px.overflow-hidden.rounded-lg.border.border-border.bg-border`
///: the hairline lattice.
///
/// The container is painted `--border` **and** bordered `--border`, and the
/// `gap-px` gutters let that fill show through between `bg-background`
/// [StateCell]s. So there is no divider widget anywhere in here: the gaps
/// *are* the rules, and a short last row leaves its trailing slots showing the
/// field, which is what an empty CSS grid cell does.
class StateGrid extends StatelessWidget {
  /// `StateGrid cols={n}`: one of the kit's five column maps.
  ///
  /// Every one of them is 2-up on a phone; they part company at `sm:` and
  /// again at `lg:`. The buttons page passes 4 (variants) and 5 (states).
  const StateGrid({super.key, required this.children, this.cols = 4})
    : base = null,
      sm = null,
      lg = null;

  /// A lattice with a column map of its own.
  ///
  /// The icons page's glyph registry is `grid-cols-1 sm:grid-cols-2
  /// lg:grid-cols-3`, which is none of the five above: it is a page-local
  /// grid in the reference too. Only the *frame* is shared, and this is what
  /// sharing it looks like.
  const StateGrid.columns({
    super.key,
    required this.children,
    this.base = 1,
    this.sm,
    this.lg,
  }) : cols = null;

  final List<Widget> children;

  /// Which of the kit's maps to resolve, or null when [base]/[sm]/[lg] state
  /// the map directly.
  final int? cols;

  final int? base;
  final int? sm;
  final int? lg;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    // `{2: "grid-cols-1 sm:grid-cols-2", 3: "grid-cols-2 sm:grid-cols-3",
    //   4: "grid-cols-2 sm:grid-cols-4",
    //   5: "grid-cols-2 sm:grid-cols-3 lg:grid-cols-5",
    //   6: "grid-cols-2 sm:grid-cols-3 lg:grid-cols-6"}[cols]`
    final (int, int?, int?) map = switch (cols) {
      null => (base!, sm, lg),
      2 => (1, 2, null),
      3 => (2, 3, null),
      4 => (2, 4, null),
      5 => (2, 3, 5),
      _ => (2, 3, 6),
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.border,
        borderRadius: BorderRadius.circular(Radii.lg),
        border: Border.all(color: theme.border, width: BorderWidths.hairline),
      ),
      // `box-sizing: border-box`, as everywhere else in the kit: the frame is
      // paid for out of the grid's own width.
      child: Padding(
        padding: const EdgeInsets.all(BorderWidths.hairline),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Radii.lg - BorderWidths.hairline),
          child: Grid(
            base: map.$1,
            sm: map.$2,
            lg: map.$3,
            gap: BorderWidths.hairline,
            children: children,
          ),
        ),
      ),
    );
  }
}

/// `div.bg-background.p-5`: one opaque tile in a [StateGrid], holding a
/// specimen over its name.
///
/// The demo well is `mb-4 flex min-h-14 items-center justify-center`: **56px
/// minimum, which is exactly the `xl` button height**, so a grid of buttons
/// keeps one well depth however tall its tallest specimen is.
///
/// [label] and [note] are the same 10.5px, `.type-micro` and `.type-caption`
/// are separated only by case, weight, tracking and leading.
class StateCell extends StatelessWidget {
  const StateCell({
    super.key,
    required this.label,
    this.note,
    required this.child,
  }) : padding = null;

  /// The opaque tile without the kit's well-and-label block.
  ///
  /// The icons page's registry entry is a `bg-background p-4` cell holding a
  /// glyph beside its name: a different composition doing the same structural
  /// job, which is to be the solid tile the lattice shows between. Sharing the
  /// tile is what keeps one `gap-px` grid in the port instead of two.
  const StateCell.bare({super.key, required this.child, this.padding})
    : label = null,
      note = null;

  /// `.type-micro text-center text-muted-foreground`, 10.5px, uppercased by
  /// the class.
  final String? label;

  /// `.type-caption mt-1.5 text-center text-muted-foreground`, 10.5px again,
  /// sentence case.
  final String? note;

  final Widget child;

  /// Overrides `p-5`. [StateCell.bare] only: the labelled cell's padding is
  /// part of the kit's anatomy.
  final EdgeInsetsGeometry? padding;

  /// `min-h-14`.
  static double get wellHeight => space(14);

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    if (label == null) {
      return Container(
        color: theme.background,
        padding: padding ?? EdgeInsets.all(space(4)),
        child: child,
      );
    }

    return Container(
      color: theme.background,
      padding: EdgeInsets.all(space(5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: space(4)),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: wellHeight),
              child: Center(child: child),
            ),
          ),
          StyledText(
            label!,
            TextStyles.eyebrowSmall,
            color: theme.mutedForeground,
            align: TextAlign.center,
          ),
          if (note != null) ...<Widget>[
            SizedBox(height: space(1.5)),
            StyledText(
              note!,
              TextStyles.caption,
              color: theme.mutedForeground,
              align: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/* ── Reference blocks ────────────────────────────────────────────────────── */

/// One `<dt>/<dd>` pair in a [Meta].
typedef MetaItem = ({String k, InlineSpan v});

/// `dl.divide-y.divide-border.overflow-hidden.rounded-lg.border.bg-card`: the
/// token/prop reference list.
///
/// Values are [InlineSpan]s because half of them contain [Code] chips; a
/// bare `TextSpan(text: …)` inherits the row's own `.type-small` muted style.
class Meta extends StatelessWidget {
  const Meta({super.key, required this.items});

  final List<MetaItem> items;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final bool wide = MediaQuery.sizeOf(context).width >= Breakpoints.sm;

    return DividedList(
      radius: Radii.lg,
      children: <Widget>[
        for (final MetaItem item in items)
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: space(4),
              vertical: space(3),
            ),
            child: wide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: _keyColumn,
                        child: StyledText(
                          item.k,
                          TextStyles.numberSm,
                          color: theme.actionText,
                        ),
                      ),
                      SizedBox(width: space(4)),
                      Expanded(child: _MetaValue(value: item.v)),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      StyledText(
                        item.k,
                        TextStyles.numberSm,
                        color: theme.actionText,
                      ),
                      SizedBox(height: space(1)),
                      _MetaValue(value: item.v),
                    ],
                  ),
          ),
      ],
    );
  }
}

class _MetaValue extends StatelessWidget {
  const _MetaValue({required this.value});

  final InlineSpan value;

  @override
  Widget build(BuildContext context) => RichText(value, TextStyles.small);
}

/// `code.type-code.rounded-sm.border.border-border.bg-card.px-1.5.py-0.5` —
/// the inline code chip.
class Code extends StatelessWidget {
  const Code(this.text, {super.key})
    : chip = text,
      _openLeft = false,
      _openRight = false;

  /// One slice of a chip that a line break ran through: see [span].
  ///
  /// Positional because two of the fields are private, and a named parameter
  /// may not be: the whole chip, then the left edge, then the right.
  const Code._fragment(this.text, this.chip, this._openLeft, this._openRight);

  /// What this widget draws: a slice of [chip], or all of it.
  final String text;

  /// The whole chip this slice belongs to.
  ///
  /// Equal to [text] unless a line break was allowed to fall inside the chip,
  /// in which case the slices of one chip all name it: which is how a caller
  /// (a test, say) reads a chip back from however many pieces the line breaker
  /// left it in.
  final String chip;

  /// This slice continues a chip that began on the line above, so its frame is
  /// cut off on the left; likewise [_openRight] for one that continues below.
  final bool _openLeft;
  final bool _openRight;

  /// What the chip's frame costs it vertically: `py-0.5` twice, plus a
  /// hairline on each edge. A browser paints all four outside the line box.
  static final double _frame = (space(0.5) + BorderWidths.hairline) * 2;

  /// The chip cut at every break opportunity CSS gives it.
  ///
  /// `<code>` holds text, and text breaks: UAX #14 allows a line break *after*
  /// a hyphen (LB21 forbids one before it), which is why Chrome sets
  /// `action-feedback` as `sheen-` at the end of one line and `action` at the
  /// start of the next. A run of hyphens stays whole: no break may fall
  /// between two of them: so `--width-prose` offers `--` / `width-` / `prose`
  /// and not a break after the first dash.
  static List<String> _fragments(String text) {
    final List<String> out = <String>[];
    int start = 0;
    for (int i = 0; i < text.length - 1; i++) {
      if (text[i] == '-' && text[i + 1] != '-') {
        out.add(text.substring(start, i + 1));
        start = i + 1;
      }
    }
    out.add(text.substring(start));
    return out;
  }

  /// The same chip, spliced into a sentence.
  ///
  /// `<code>` is an inline element: the line box grows for its `line-height`
  /// only: never for its padding or its border, which overflow the leading —
  /// and its glyphs sit on the sentence's own baseline. A [WidgetSpan] makes
  /// no such distinction, so [InlineBox] hides the frame from the line and
  /// `PlaceholderAlignment.baseline` does the rest.
  ///
  /// A placeholder is also atomic, and a chip is not: it goes on one span per
  /// [_fragments] entry, which puts a break opportunity exactly where CSS has
  /// one and nowhere else. Flush on a single line the fragments meet with no
  /// gap and no seam, because each one paints the whole frame and shows only
  /// its own slice of it: that is `box-decoration-break: slice`, the default.
  static InlineSpan span(String text) {
    final List<String> parts = _fragments(text);
    if (parts.length == 1) {
      return _sliceSpan(text, text, openLeft: false, openRight: false);
    }
    return TextSpan(
      children: <InlineSpan>[
        for (int i = 0; i < parts.length; i++)
          _sliceSpan(
            parts[i],
            text,
            openLeft: i > 0,
            openRight: i < parts.length - 1,
          ),
      ],
    );
  }

  static InlineSpan _sliceSpan(
    String text,
    String chip, {
    required bool openLeft,
    required bool openRight,
  }) => WidgetSpan(
    alignment: PlaceholderAlignment.baseline,
    baseline: TextBaseline.alphabetic,
    child: InlineBox(
      trim: _frame,
      child: Code._fragment(text, chip, openLeft, openRight),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    // `px-1.5 py-0.5` plus the border, which insets content as CSS's
    // border-box does: and which an open edge does not have.
    final double pad = space(1.5) + BorderWidths.hairline;
    final double lead = space(0.5) + BorderWidths.hairline;
    return CustomPaint(
      painter: _ChipFrame(
        fill: theme.card,
        stroke: theme.border,
        openLeft: _openLeft,
        openRight: _openRight,
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          _openLeft ? 0 : pad,
          lead,
          _openRight ? 0 : pad,
          lead,
        ),
        child: StyledText(
          text,
          TextStyles.code,
          color: theme.mutedForeground,
          inline: true,
        ),
      ),
    );
  }
}

/// The chip's frame, painted the way a browser paints a broken inline box.
///
/// `box-decoration-break: slice`: the initial value: draws the border box
/// once for the whole element and then cuts it at each line break, so the
/// fragment ending a line carries no right border and no right corners, and
/// the one continuing it carries no left border and no left corners. Painting
/// the whole frame and clipping to the fragment *is* that rule rather than an
/// imitation of it, and it is why two fragments flush on one line show no seam.
class _ChipFrame extends CustomPainter {
  const _ChipFrame({
    required this.fill,
    required this.stroke,
    required this.openLeft,
    required this.openRight,
  });

  final Color fill;
  final Color stroke;
  final bool openLeft;
  final bool openRight;

  /// Enough for the hidden side's corners and border to fall outside the clip.
  static const double _overhang = Radii.sm + BorderWidths.hairline;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect whole = Rect.fromLTRB(
      openLeft ? -_overhang : 0,
      0,
      size.width + (openRight ? _overhang : 0),
      size.height,
    );
    const Radius radius = Radius.circular(Radii.sm);
    // Half the hairline: a CSS border is drawn inside the border box, so the
    // stroke's centre line sits half a width in: the same inset
    // `BoxBorder.paintUniformBorder` uses for `BorderSide.strokeAlignInside`.
    final double inset = BorderWidths.hairline / 2;

    canvas.save();
    canvas.clipRect(Offset.zero & size);
    canvas.drawRRect(
      RRect.fromRectAndRadius(whole, radius),
      Paint()..color = fill,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        whole.deflate(inset),
        Radius.circular(Radii.sm - inset),
      ),
      Paint()
        ..color = stroke
        ..style = PaintingStyle.stroke
        ..strokeWidth = BorderWidths.hairline,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_ChipFrame old) =>
      old.fill != fill ||
      old.stroke != stroke ||
      old.openLeft != openLeft ||
      old.openRight != openRight;
}

/// `pre.type-code.scrollbar-thin.overflow-x-auto.rounded-lg.border.border-border
/// .bg-background.p-5.leading-relaxed.text-muted-foreground`: the multi-line
/// code sample. [Code]'s block-level twin, and the only one of the pair that
/// scrolls.
///
/// Three cascade facts decide how it reads, and two of them are utilities
/// beating the component layer:
/// * **`leading-relaxed` beats `.type-code`.** The class declares its own
///   leading inside `@layer components`, [TextStyles.code]'s, which owns that
///   number: and `leading-relaxed` is a utility, so the utility's 1.625 wins:
///   20.3125px per line. That override is why the style is assembled here
///   rather than handed to [StyledText], which renders a `.type-*` class as
///   declared. The ratio is read off [TextStyles.textareaBody], which
///   resolves the same utility on `Textarea`: one spelling of one number,
///   not a second literal that can drift from it.
/// * **`.type-code` sets no `font-weight`**, so a sample inherits 400. It is
///   the one mono class on the site that is not 600.
/// * The fill is `--background`: the same colour as the [Panel] body it
///   sits in: so only the hairline tells the two apart.
///
/// `<pre>` neither wraps nor reflows: it keeps the line breaks it was authored
/// with and hands anything too wide for the column to `overflow-x-auto`.
class CodeBlock extends StatefulWidget {
  const CodeBlock(this.code, {super.key});

  /// The sample, exactly as authored: newlines included, blank lines
  /// included, and never re-broken to fit.
  final String code;

  @override
  State<CodeBlock> createState() => _DsCodeBlockState();
}

class _DsCodeBlockState extends State<CodeBlock> {
  /// The scroller and its bar read the same position, which is what makes the
  /// thumb track the text rather than a second, parallel scroll offset.
  final ScrollController _scroller = ScrollController();

  @override
  void dispose() {
    _scroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final TextStyle style = StyledText.styleOf(
      context,
      TextStyles.code,
      color: theme.mutedForeground,
    ).copyWith(height: TextStyles.textareaBody.height);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.background,
        borderRadius: BorderRadius.circular(Radii.lg),
        border: Border.all(color: theme.border, width: BorderWidths.hairline),
      ),
      // `box-sizing: border-box`: the hairline is paid for out of the block's
      // own width, so the scroll port starts at the border's inner edge. Same
      // treatment [Panel] gives its body, and the reason the frame stays put
      // while the text underneath it moves.
      child: Padding(
        padding: const EdgeInsets.all(BorderWidths.hairline),
        child: ClipRRect(
          // The inner curve: the outer radius less the border inside it.
          borderRadius: BorderRadius.circular(Radii.lg - BorderWidths.hairline),
          child: ThinScrollbar(
            controller: _scroller,
            child: SingleChildScrollView(
              controller: _scroller,
              scrollDirection: Axis.horizontal,
              // `p-5` belongs to the scroll container, so it travels with the
              // content: the left inset is what the first line starts behind,
              // and the right one is what the longest line ends against once
              // it has been scrolled to.
              padding: EdgeInsets.all(space(5)),
              child: LineBox(
                style: style,
                // `softWrap: false` in a horizontally unbounded port is
                // `white-space: pre`: the sample is laid out at its own
                // width and the port scrolls to reach the rest of it.
                child: Text(widget.code, style: style, softWrap: false),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/* ── Do / Don't ──────────────────────────────────────────────────────────── */

/// The rule pair. Every page that has a trap states it here.
class DoDont extends StatelessWidget {
  const DoDont({super.key, required this.dos, required this.donts});

  final List<String> dos;
  final List<String> donts;

  @override
  Widget build(BuildContext context) {
    return Grid(
      sm: 2,
      children: <Widget>[
        _DoDontPanel(
          heading: 'Do',
          tone: Palette.value,
          ink: ThemeScope.of(context).premiumText,
          glyph: IconGlyph.check,
          iconTone: IconTone.value,
          items: dos,
        ),
        _DoDontPanel(
          // `Don&rsquo;t`: a real right single quotation mark, not an
          // apostrophe.
          heading: 'Don’t',
          tone: ThemeScope.of(context).destructive,
          ink: ThemeScope.of(context).destructiveText,
          glyph: IconGlyph.x,
          iconTone: IconTone.error,
          items: donts,
        ),
      ],
    );
  }
}

class _DoDontPanel extends StatelessWidget {
  const _DoDontPanel({
    required this.heading,
    required this.tone,
    required this.ink,
    required this.glyph,
    required this.iconTone,
    required this.items,
  });

  final String heading;
  final Color tone;
  final Color ink;
  final IconGlyph glyph;
  final IconTone iconTone;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(space(5)),
      decoration: BoxDecoration(
        color: tone.withValues(alpha: _doDontWashAlpha),
        borderRadius: BorderRadius.circular(Radii.lg),
        border: Border.all(
          color: tone.withValues(alpha: _doDontBorderAlpha),
          width: BorderWidths.hairline,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          StyledText(heading, TextStyles.eyebrow, color: ink),
          SizedBox(height: space(3)),
          for (int i = 0; i < items.length; i++) ...<Widget>[
            if (i > 0) SizedBox(height: space(2.5)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  // `mt-0.5`: the glyph sits on the first line's x-height.
                  padding: EdgeInsets.only(top: space(0.5)),
                  child: Icon(glyph, size: IconSize.sm, tone: iconTone),
                ),
                SizedBox(width: space(2.5)),
                Expanded(child: StyledText(items[i], TextStyles.small)),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/* ── Note ────────────────────────────────────────────────────────────────── */

/// Which ramp a [Note] washes itself with.
enum NoteTone { action, value, error }

/// Callout for a rule or trap worth interrupting the reader for.
class Note extends StatelessWidget {
  const Note({
    super.key,
    this.tone = NoteTone.action,
    this.title,
    required this.child,
  });

  final NoteTone tone;

  /// Renders `--muted-foreground` in **every** tone: see the library note.
  final String? title;

  /// Wrapped in `.type-small text-muted-foreground`, so a plain [Text.rich]
  /// with [Code] chips inherits the right style.
  final Widget child;

  Color _tone(ThemeTokens theme) => switch (tone) {
    NoteTone.action => Palette.action,
    NoteTone.value => Palette.value,
    NoteTone.error => theme.destructive,
  };

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final Color ramp = _tone(theme);

    return Container(
      padding: EdgeInsets.all(space(5)),
      decoration: BoxDecoration(
        color: ramp.withValues(alpha: _noteWashAlpha),
        borderRadius: BorderRadius.circular(Radii.lg),
        border: Border.all(
          color: ramp.withValues(alpha: _noteBorderAlpha),
          width: BorderWidths.hairline,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (title != null) ...<Widget>[
            // No colour override: `.type-label` brings its own
            // `--muted-foreground`, which is what the browser renders here.
            StyledText(title!, TextStyles.eyebrow),
            SizedBox(height: space(2)),
          ],
          DefaultTextStyle(
            style: StyledText.styleOf(context, TextStyles.small),
            child: child,
          ),
        ],
      ),
    );
  }
}

/* ── Index cards ─────────────────────────────────────────────────────────── */

/// `grid gap-4 sm:grid-cols-2 xl:grid-cols-3`: the foundations index.
class IndexGrid extends StatelessWidget {
  const IndexGrid({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Grid(sm: 2, xl: 3, children: children);
}

/// A responsive card grid: [base] columns, widened at each named breakpoint.
///
/// Rows stretch to their tallest card, which is what a CSS grid row does and
/// what lets a card push its chip strip to the bottom edge.
class Grid extends StatelessWidget {
  const Grid({
    super.key,
    required this.children,
    this.base = 1,
    this.sm,
    this.md,
    this.lg,
    this.xl,
    this.gap,
  });

  final List<Widget> children;
  final int base;
  final int? sm;
  final int? md;
  final int? lg;
  final int? xl;

  /// Defaults to `gap-4`.
  final double? gap;

  int _columns(double viewport) {
    int columns = base;
    if (sm != null && viewport >= Breakpoints.sm) columns = sm!;
    if (md != null && viewport >= Breakpoints.md) columns = md!;
    if (lg != null && viewport >= Breakpoints.lg) columns = lg!;
    if (xl != null && viewport >= Breakpoints.xl) columns = xl!;
    return columns;
  }

  @override
  Widget build(BuildContext context) {
    final double layoutGap = gap ?? space(4);
    final int columns = _columns(MediaQuery.sizeOf(context).width);
    final List<List<Widget>> rows = <List<Widget>>[];
    for (int i = 0; i < children.length; i += columns) {
      rows.add(
        children.sublist(
          i,
          i + columns > children.length ? children.length : i + columns,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        for (int r = 0; r < rows.length; r++) ...<Widget>[
          if (r > 0) SizedBox(height: layoutGap),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                for (int c = 0; c < columns; c++) ...<Widget>[
                  if (c > 0) SizedBox(width: layoutGap),
                  Expanded(
                    child: c < rows[r].length
                        ? rows[r][c]
                        // The trailing cells of a short last row: empty, so
                        // the row's cards keep their column width.
                        : const SizedBox.shrink(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}

/// A lifting card that links to a page.
///
/// Two shapes, one component, as the reference has them: the six-up index card
/// (`p-5`, `.type-h4` title, 16px arrow) and the three-up group card (`p-7`, a
/// `N sets` label over a `.type-h3` title, 20px arrow).
class IndexCard extends StatelessWidget {
  const IndexCard({
    super.key,
    required this.href,
    required this.title,
    required this.blurb,
    required this.contents,
  }) : label = null,
       _group = false;

  /// The `#components` variant.
  const IndexCard.group({
    super.key,
    required this.href,
    required this.label,
    required this.title,
    required this.blurb,
    required this.contents,
  }) : _group = true;

  final String href;

  /// `N sets`, `.type-label text-action-ink`: group cards only.
  final String? label;

  final String title;
  final String blurb;
  final List<String> contents;

  final bool _group;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final double pad = _group ? space(7) : space(5);
    final double chipGap = _group ? space(5) : space(4);

    return InteractiveCard(
      radius: BorderRadius.circular(Radii.xl),
      fill: theme.card,
      borderColor: theme.border,
      hoverBorderColor: Palette.action.withValues(alpha: _cardHoverBorderAlpha),
      padding: EdgeInsets.all(pad),
      onTap: () => AppRouter.of(context).navigate(href),
      builder: (BuildContext context, bool hovered) =>
          SelectionContainer.disabled(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: _group
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                StyledText(
                                  label!,
                                  TextStyles.eyebrow,
                                  color: theme.actionText,
                                ),
                                SizedBox(height: space(3)),
                                StyledText(
                                  title,
                                  TextStyles.h3,
                                  color: theme.foreground,
                                ),
                              ],
                            )
                          : StyledText(
                              title,
                              TextStyles.h4,
                              color: theme.foreground,
                            ),
                    ),
                    SizedBox(width: _group ? space(4) : space(3)),
                    Padding(
                      // `mt-1` on the group card, `mt-0.5` on the index card.
                      padding: EdgeInsets.only(
                        top: _group ? space(1) : space(0.5),
                      ),
                      child: _CardArrow(hovered: hovered, large: _group),
                    ),
                  ],
                ),
                SizedBox(height: _group ? space(3) : space(2)),
                // `grow`: the blurb takes the slack so the chips sit on the
                // bottom edge however tall the row's tallest card is.
                Expanded(child: StyledText(blurb, TextStyles.small)),
                SizedBox(height: chipGap),
                Container(
                  padding: EdgeInsets.only(top: chipGap),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: theme.border,
                        width: BorderWidths.hairline,
                      ),
                    ),
                  ),
                  child: Wrap(
                    spacing: space(1.5),
                    runSpacing: space(1.5),
                    children: <Widget>[
                      for (final String chip in contents)
                        _CardChip(label: chip),
                    ],
                  ),
                ),
              ],
            ),
          ),
    );
  }
}

/// `Icon icon={ArrowRight}` with `transition-[transform,color] duration-fast
/// group-hover:translate-x-0.5 group-hover:text-action-ink`.
///
/// `duration-fast` is not a utility Tailwind v4 can generate, so the slide
/// and the tint both run at [MotionDurations.normal]: probed at
/// 0.25s on the index, the components index and every group page.
class _CardArrow extends StatelessWidget {
  const _CardArrow({required this.hovered, required this.large});

  final bool hovered;

  /// The group card renders the same 16px icon at `size-5`.
  ///
  /// A quirk kept on purpose: the class overrides the rendered box to 20px,
  /// but the `strokeWidth` attribute was computed for the default `md` size —
  /// so the glyph is 20px wide with a 16px stroke weight.
  final bool large;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final Duration transition = effectiveMotionDuration(
      context,
      MotionDurations.normal,
    );
    // `AnimatedSlide` measures its offset in child widths, and the two
    // variants are different widths for the same 2px travel.
    final double px = large ? space(5) : Icon.pxFor(IconSize.md);

    return AnimatedSlide(
      offset: Offset(hovered ? _arrowSlide / px : 0, 0),
      duration: transition,
      curve: MotionCurves.enter,
      child: TweenAnimationBuilder<Color?>(
        tween: ColorTween(
          end: hovered ? theme.actionText : theme.mutedForeground,
        ),
        duration: transition,
        curve: MotionCurves.enter,
        builder: (BuildContext context, Color? colour, Widget? child) =>
            DefaultTextStyle.merge(
              style: TextStyle(color: colour),
              child: child!,
            ),
        child: Icon(
          IconGlyph.arrowRight,
          sizePx: large ? space(5) : null,
          strokeOverride: large
              ? Icon.strokeFor(Icon.pxFor(IconSize.md))
              : null,
        ),
      ),
    );
  }
}

/// `li.type-caption.rounded-sm.bg-muted.px-2.py-1`.
class _CardChip extends StatelessWidget {
  const _CardChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: space(2), vertical: space(1)),
      decoration: BoxDecoration(
        color: theme.muted,
        borderRadius: BorderRadius.circular(Radii.sm),
      ),
      child: StyledText(
        label,
        TextStyles.caption,
        color: theme.mutedForeground,
      ),
    );
  }
}

/* ── Prev / next ─────────────────────────────────────────────────────────── */

/// `nav.mt-8.flex.items-stretch.gap-4.border-t.border-border.pt-8`.
///
/// Reads its two neighbours out of the nav registry, so the order of the pages
/// is stated once. A missing side is an empty flex slot, not a missing card —
/// the present side keeps its half of the row.
class PageFootNav extends StatelessWidget {
  const PageFootNav({super.key, required this.groupId, required this.slug});

  final String groupId;
  final String slug;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final Siblings around = siblings(groupId, slug);
    if (around.prev == null && around.next == null) {
      return const SizedBox.shrink();
    }

    return Container(
      // No `mt-8` here, and that is not an omission: the nav always follows a
      // `Section`, whose `mb-20` is an adjoining margin. CSS collapses the
      // pair to the larger of the two, so the 80px below the last section is
      // the whole gap and the nav's own 32px never shows. Flutter has no
      // margin collapsing: it would add them: so the collapse is done here.
      padding: EdgeInsets.only(top: space(8)),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: theme.border, width: BorderWidths.hairline),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: around.prev == null
                  ? const SizedBox.shrink()
                  : _FootNavCard(link: around.prev!, isNext: false),
            ),
            SizedBox(width: space(4)),
            Expanded(
              child: around.next == null
                  ? const SizedBox.shrink()
                  : _FootNavCard(link: around.next!, isNext: true),
            ),
          ],
        ),
      ),
    );
  }
}

class _FootNavCard extends StatefulWidget {
  const _FootNavCard({required this.link, required this.isNext});

  final NavLink link;
  final bool isNext;

  @override
  State<_FootNavCard> createState() => _FootNavCardState();
}

class _FootNavCardState extends State<_FootNavCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    final Widget arrow = Icon(
      widget.isNext ? IconGlyph.arrowRight : IconGlyph.arrowLeft,
      tone: IconTone.muted,
    );
    final Widget copy = Column(
      crossAxisAlignment: widget.isNext
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        StyledText(
          widget.isNext ? 'Next' : 'Previous',
          TextStyles.eyebrowSmall,
          align: widget.isNext ? TextAlign.right : TextAlign.left,
        ),
        SizedBox(height: space(1)),
        StyledText(
          widget.link.title,
          TextStyles.small,
          color: theme.foreground,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          align: widget.isNext ? TextAlign.right : TextAlign.left,
        ),
      ],
    );

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Press(
        onTap: () => AppRouter.of(context).navigate(widget.link.href),
        child: SelectionContainer.disabled(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: space(5),
              vertical: space(4),
            ),
            decoration: BoxDecoration(
              color: theme.card,
              borderRadius: BorderRadius.circular(Radii.lg),
              // `hover:border-input` with no transition utility on colour:
              // the card's `press` covers `transform` only, so this swap is
              // instant.
              border: Border.all(
                color: _hovered ? theme.input : theme.border,
                width: BorderWidths.hairline,
              ),
            ),
            child: Row(
              mainAxisAlignment: widget.isNext
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: <Widget>[
                if (!widget.isNext) ...<Widget>[
                  arrow,
                  SizedBox(width: space(3)),
                ],
                Flexible(child: copy),
                if (widget.isNext) ...<Widget>[
                  SizedBox(width: space(3)),
                  arrow,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/* ── Shared ──────────────────────────────────────────────────────────────── */

/// `divide-y divide-border overflow-hidden rounded-lg border border-border
/// bg-card`: one card with hairlines between its rows and none at its edges.
///
/// Public because three pages stack rows this way outside [Meta]: the
/// overview's numbered rules (`rounded-xl`), the typography specimen rows, and
/// the colors page's swatch list.
class DividedList extends StatelessWidget {
  const DividedList({
    super.key,
    this.radius = Radii.lg,
    required this.children,
  });

  final double radius;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final BorderRadius shape = BorderRadius.circular(radius);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: shape,
        border: Border.all(color: theme.border, width: BorderWidths.hairline),
      ),
      // `box-sizing: border-box`: the frame costs the rows a pixel on each
      // side, so a row's content box is the list's width less two.
      child: Padding(
        padding: const EdgeInsets.all(BorderWidths.hairline),
        child: ClipRRect(
          // The inner curve: the outer radius less the border inside it.
          borderRadius: BorderRadius.circular(radius - BorderWidths.hairline),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              for (int i = 0; i < children.length; i++)
                if (i == 0)
                  children[i]
                else
                  DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: theme.border,
                          width: BorderWidths.hairline,
                        ),
                      ),
                    ),
                    // The divider is a `border-top` on the row itself, so it
                    // adds to that row's height and sits above its content
                    // rather than over the first pixel of it.
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: BorderWidths.hairline,
                      ),
                      child: children[i],
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
