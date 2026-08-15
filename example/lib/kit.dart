/// The docs component library — `components/ds/kit.tsx`.
///
/// Every foundation page is assembled out of these and nothing else: a header,
/// sections, framed panels, notes, reference lists, do/don't pairs, index
/// cards and a foot nav. The pages carry copy and specimens; the anatomy lives
/// here, once.
///
/// Two rendering facts that look like bugs and are not:
/// * `DsSection` renders an `h2` **styled `.type-h3`** — the reference's own
///   deliberate choice, so a page's sections sit a step below its `h1`.
/// * A [DsNote] title is **always** muted-foreground, in every tone.
///   `.type-label` declares `color: var(--muted-foreground)` on the element
///   itself, which beats the wrapper's `text-*-ink` by inheritance. The tone
///   shows in the border and the wash, never in the title.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import 'nav.dart';
import 'shell.dart';

/// `max-w-2xl` — 42rem, the measure every blurb and section description is cut
/// to.
final double _measure2xl = ds(168);

/// `sm:grid-cols-[minmax(0,13rem)_1fr]` — the key column in [DsMeta] and the
/// left column of a swatch row.
final double _keyColumn = ds(52);

/// `hover:border-action/45` on a lifting card.
const double _cardHoverBorderAlpha = 0.45;

/// Tailwind's `leading-relaxed` ratio, which the `<pre>` in [DsCodeBlock]
/// overrides `.type-code`'s own 1.4 with. `globals.css` declares no
/// `--leading-*` token for it, so it cannot come from the foundation layer.
// allow-hardcoded: framework default with no token to read it from.
const double _leadingRelaxed = 1.625;

/// `border-<tone>/30` and `bg-<tone>/[0.08]` on a [DsNote].
const double _noteBorderAlpha = 0.30;
const double _noteWashAlpha = 0.08;

/// `border-<tone>/25` and `bg-<tone>/[0.06]` on a [DsDoDont] panel.
const double _doDontBorderAlpha = 0.25;
const double _doDontWashAlpha = 0.06;

/// `group-hover:translate-x-0.5` — how far a card's arrow slides.
final double _arrowSlide = ds(0.5);

/* ── Page header ─────────────────────────────────────────────────────────── */

/// `header.mb-14.border-b.border-border.pb-10`.
class DsPageHeader extends StatelessWidget {
  const DsPageHeader({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.blurb,
    this.contents,
  });

  /// `.type-label text-action-ink` — the group this page belongs to.
  final String eyebrow;

  final String title;

  final String blurb;

  /// The chip row. Omitted on the overview page; the colors page passes its
  /// own list rather than the nav registry's (a documented drift).
  final List<String>? contents;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final List<String> chips = contents ?? const <String>[];

    return Container(
      margin: EdgeInsets.only(bottom: ds(14)),
      padding: EdgeInsets.only(bottom: ds(10)),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.border, width: DsWidths.hairline),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DsText(eyebrow, DsType.label, color: theme.actionInk),
          SizedBox(height: ds(4)),
          DsText(
            title,
            DsType.h1,
            fontSize: DsFluid.h1(context),
            color: theme.foreground,
          ),
          SizedBox(height: ds(4)),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: _measure2xl),
            child: DsText(blurb, DsType.lead),
          ),
          if (chips.isNotEmpty) ...<Widget>[
            SizedBox(height: ds(7)),
            Wrap(
              spacing: ds(2),
              runSpacing: ds(2),
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
    final DsThemeData theme = DsTheme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ds(3), vertical: ds(1.5)),
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(DsRadii.pill),
        border: Border.all(color: theme.border, width: DsWidths.hairline),
      ),
      child: DsText(label, DsType.chip, color: theme.mutedForeground),
    );
  }
}

/* ── Section ─────────────────────────────────────────────────────────────── */

/// `section#<id>.mb-20` with an `h2.type-h3` and an optional description.
///
/// The `id` is not decoration: it is the anchor an in-page link scrolls to.
/// The reference has **no** `scroll-mt-*` anywhere — `html` carries
/// `scroll-padding-block-start: var(--scroll-offset)` (96px), which is where
/// [scrollTo] puts the section's top edge.
class DsSection extends StatelessWidget {
  const DsSection({
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

  /// One key per section id, kept so a later lookup finds the same object.
  ///
  /// Not a `GlobalObjectKey`: its equality is *identity* on the value, and two
  /// interpolated strings with the same characters are not the same object —
  /// the lookup would silently miss.
  static final Map<String, GlobalKey<State<StatefulWidget>>> _anchors =
      <String, GlobalKey<State<StatefulWidget>>>{};

  /// The key [scrollTo] looks the section up by.
  static GlobalKey<State<StatefulWidget>> anchorKey(String id) =>
      _anchors.putIfAbsent(id, () => GlobalKey<State<StatefulWidget>>());

  /// `html { scroll-behavior: smooth }` to the section with [id], resting
  /// `--scroll-offset` (96px) below the viewport top.
  ///
  /// The browser picks its own smooth-scroll timing; there is no token for it,
  /// so this uses `--duration-slow` on `--ease-in-out`. Reduced motion forces
  /// `scroll-behavior: auto`, which is what a zero duration is here.
  static Future<void> scrollTo(String id) async {
    final BuildContext? target = anchorKey(id).currentContext;
    if (target == null) return;
    final ScrollableState? scrollable = Scrollable.maybeOf(target);
    if (scrollable == null) return;

    final RenderObject? box = target.findRenderObject();
    final RenderObject? viewport = scrollable.context.findRenderObject();
    if (box is! RenderBox || viewport is! RenderBox) return;

    final double delta =
        box.localToGlobal(Offset.zero, ancestor: viewport).dy -
            DsWidths.scrollOffset;
    final ScrollPosition position = scrollable.position;
    await position.animateTo(
      (position.pixels + delta)
          .clamp(position.minScrollExtent, position.maxScrollExtent),
      duration: dsAnimationDuration(target, DsDurations.slow),
      curve: DsCurves.inOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Padding(
      key: anchorKey(id),
      padding: EdgeInsets.only(bottom: ds(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: ds(6)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // An `h2` wearing `.type-h3`, intentionally.
                DsText(title, DsType.h3, color: theme.foreground),
                if (description != null) ...<Widget>[
                  SizedBox(height: ds(2)),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: _measure2xl),
                    child: DsText(description!, DsType.small),
                  ),
                ],
              ],
            ),
          ),
          child,
        ],
      ),
    );
  }
}

/* ── Panel ───────────────────────────────────────────────────────────────── */

/// The framed stage every specimen sits on.
///
/// `overflow-hidden rounded-xl border border-border bg-card`, an optional
/// muted header strip, and a `--background` body — so a specimen is never
/// judged against the card it is mounted on.
class DsPanel extends StatelessWidget {
  const DsPanel({
    super.key,
    this.label,
    this.note,
    required this.child,
    this.flush = false,
    this.bodyPadding,
  });

  /// `.type-label text-muted-foreground`, left of the strip.
  final String? label;

  /// `.type-num-sm text-muted-foreground`, right of the strip.
  final String? note;

  final Widget child;

  /// Drops the body padding, for specimens that reach the panel edge.
  final bool flush;

  /// Overrides `p-6` — the typography page's prose panel uses `p-6 sm:p-10`.
  final EdgeInsetsGeometry? bodyPadding;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final BorderRadius radius = BorderRadius.circular(DsRadii.xl);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: radius,
        border: Border.all(color: theme.border, width: DsWidths.hairline),
      ),
      // `box-sizing: border-box` — the frame is paid for out of the panel's
      // own width, so the strip and the body start at the border's inner edge
      // and are two pixels narrower than the panel. Outside the clip, not
      // inside it, so the body's fill still reaches that edge instead of
      // leaving a hairline of card showing.
      child: Padding(
        padding: const EdgeInsets.all(DsWidths.hairline),
        child: ClipRRect(
          // `overflow-hidden`, so the body's fill stops at the corner — on the
          // *inner* curve, which CSS derives as the outer radius less the
          // border it sits inside.
          borderRadius: BorderRadius.circular(DsRadii.xl - DsWidths.hairline),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (label != null || note != null)
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: ds(5), vertical: ds(3)),
                  decoration: BoxDecoration(
                    color: theme.muted,
                    border: Border(
                      bottom: BorderSide(
                        color: theme.border,
                        width: DsWidths.hairline,
                      ),
                    ),
                  ),
                  child: _PanelStrip(label: label, note: note),
                ),
              Container(
                color: theme.background,
                padding: flush
                    ? EdgeInsets.zero
                    : bodyPadding ?? EdgeInsets.all(ds(6)),
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
/// and "Geist Mono — numerical values" — 249.66px against a 163px third —
/// wrapped to a second line the browser never draws, pushing everything under
/// that panel 11px down.
///
/// So there is no spacer, and the count of flex children is the count of
/// strings. That was half of it. **The other half is that an equal share is
/// still not `flex: 0 1 auto`.** It was enough while every panel was full
/// width — the widest pairing on the first four pages is 170px + 240.7px
/// inside a 1038px strip, and half of that is plenty — but the motion page
/// puts panels three-up, and on a 307.33px strip half is 145.67px. Four
/// `.type-num-sm` notes did not fit it, each wrapped one 14.4px line the
/// browser never draws, and two of that page's sections came out 28.8px tall
/// between them. Same bug as the `Spacer`, one breakpoint further down.
///
/// So the share is weighted by what each run actually measures. `flex: 0 1
/// auto` is two rules in one — **the base size is the content width**, and
/// **shrinkage is proportional to that base** — and giving each [Flexible] a
/// flex of its own natural width reproduces both, because a proportional share
/// of the free space is `free × wᵢ / Σw`:
/// * while the pair fits, `free ≥ Σw`, so every share is at least the width it
///   was measured at: nothing is offered less than it asked for, and nothing
///   wraps that the browser would not wrap. `FlexFit.loose` then hands the
///   slack back, which is what `justify-between` puts between the two;
/// * once the pair does not fit, the shares fall in proportion to base size,
///   which is exactly what `flex-shrink: 1` computes against `flex-basis:
///   auto` — so the overflow behaviour the equal split got right is kept.
class _PanelStrip extends StatelessWidget {
  const _PanelStrip({this.label, this.note});

  final String? label;
  final String? note;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final Widget? labelText = label == null
        ? null
        : DsText(label!, DsType.label, color: theme.mutedForeground);
    final Widget? noteText = note == null
        ? null
        // `.type-num-*` declares no colour of its own; the strip states it.
        : DsText(
            note!,
            DsType.numSm,
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
            flex: _basis(context, label!, DsType.label),
            child: labelText,
          ),
        if (labelText != null && noteText != null) SizedBox(width: ds(4)),
        if (noteText != null)
          if (labelText == null)
            // One run and nothing to share with: it takes the strip, and its
            // own `text-align` is what pushes it to the far edge.
            Expanded(child: noteText)
          else
            Flexible(
              flex: _basis(context, note!, DsType.numSm),
              child: noteText,
            ),
      ],
    );
  }

  /// The `flex-basis: auto` of a run, as a flex weight.
  ///
  /// Rounded because [Flexible.flex] is an `int`, and floored at 1 because
  /// `flex: 0` is not a small share — it is no share at all, and a run that
  /// measured zero would be given no width to lay out in.
  static int _basis(BuildContext context, String text, DsTypeSpec spec) {
    final int width = _naturalWidth(context, text, spec).round();
    return width < 1 ? 1 : width;
  }

  /// What [text] asks for in [spec] with no line to run out of — `max-content`,
  /// which is what a flex item's `auto` basis resolves to.
  ///
  /// Measured on the string the class actually paints, not the string it was
  /// authored with: `.type-label` applies `text-transform: uppercase` at paint
  /// time, and `TWELVE COLUMNS · 24PX GUTTERS` is wider than the sentence case
  /// it is written in.
  static double _naturalWidth(
    BuildContext context,
    String text,
    DsTypeSpec spec,
  ) {
    final TextPainter painter = TextPainter(
      text: TextSpan(
        text: spec.uppercase ? text.toUpperCase() : text,
        // Colour cannot move a glyph, so the strip's own `text-*` override is
        // left off and the class resolves its metrics alone.
        style: DsText.styleOf(context, spec),
      ),
      textDirection: Directionality.of(context),
    )..layout();
    final double width = painter.width;
    painter.dispose();
    return width;
  }
}

/* ── Reference blocks ────────────────────────────────────────────────────── */

/// One `<dt>/<dd>` pair in a [DsMeta].
typedef DsMetaItem = ({String k, InlineSpan v});

/// `dl.divide-y.divide-border.overflow-hidden.rounded-lg.border.bg-card` — the
/// token/prop reference list.
///
/// Values are [InlineSpan]s because half of them contain [DsCode] chips; a
/// bare `TextSpan(text: …)` inherits the row's own `.type-small` muted style.
class DsMeta extends StatelessWidget {
  const DsMeta({super.key, required this.items});

  final List<DsMetaItem> items;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final bool wide = MediaQuery.sizeOf(context).width >= DsBreakpoints.sm;

    return DsDividedList(
      radius: DsRadii.lg,
      children: <Widget>[
        for (final DsMetaItem item in items)
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: ds(4), vertical: ds(3)),
            child: wide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: _keyColumn,
                        child: DsText(
                          item.k,
                          DsType.numSm,
                          color: theme.actionInk,
                        ),
                      ),
                      SizedBox(width: ds(4)),
                      Expanded(child: _MetaValue(value: item.v)),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      DsText(item.k, DsType.numSm, color: theme.actionInk),
                      SizedBox(height: ds(1)),
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
  Widget build(BuildContext context) => DsRichText(value, DsType.small);
}

/// `code.type-code.rounded-sm.border.border-border.bg-card.px-1.5.py-0.5` —
/// the inline code chip.
class DsCode extends StatelessWidget {
  const DsCode(this.text, {super.key})
      : chip = text,
        _openLeft = false,
        _openRight = false;

  /// One slice of a chip that a line break ran through — see [span].
  ///
  /// Positional because two of the fields are private, and a named parameter
  /// may not be: the whole chip, then the left edge, then the right.
  const DsCode._fragment(this.text, this.chip, this._openLeft, this._openRight);

  /// What this widget draws — a slice of [chip], or all of it.
  final String text;

  /// The whole chip this slice belongs to.
  ///
  /// Equal to [text] unless a line break was allowed to fall inside the chip,
  /// in which case the slices of one chip all name it — which is how a caller
  /// (a test, say) reads a chip back from however many pieces the line breaker
  /// left it in.
  final String chip;

  /// This slice continues a chip that began on the line above, so its frame is
  /// cut off on the left; likewise [_openRight] for one that continues below.
  final bool _openLeft;
  final bool _openRight;

  /// What the chip's frame costs it vertically: `py-0.5` twice, plus a
  /// hairline on each edge. A browser paints all four outside the line box.
  static final double _frame = (ds(0.5) + DsWidths.hairline) * 2;

  /// The chip cut at every break opportunity CSS gives it.
  ///
  /// `<code>` holds text, and text breaks: UAX #14 allows a line break *after*
  /// a hyphen (LB21 forbids one before it), which is why Chrome sets
  /// `sheen-action` as `sheen-` at the end of one line and `action` at the
  /// start of the next. A run of hyphens stays whole — no break may fall
  /// between two of them — so `--width-prose` offers `--` / `width-` / `prose`
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
  /// only — never for its padding or its border, which overflow the leading —
  /// and its glyphs sit on the sentence's own baseline. A [WidgetSpan] makes
  /// no such distinction, so [DsInlineBox] hides the frame from the line and
  /// `PlaceholderAlignment.baseline` does the rest.
  ///
  /// A placeholder is also atomic, and a chip is not: it goes on one span per
  /// [_fragments] entry, which puts a break opportunity exactly where CSS has
  /// one and nowhere else. Flush on a single line the fragments meet with no
  /// gap and no seam, because each one paints the whole frame and shows only
  /// its own slice of it — that is `box-decoration-break: slice`, the default.
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
  }) =>
      WidgetSpan(
        alignment: PlaceholderAlignment.baseline,
        baseline: TextBaseline.alphabetic,
        child: DsInlineBox(
          trim: _frame,
          child: DsCode._fragment(text, chip, openLeft, openRight),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    // `px-1.5 py-0.5` plus the border, which insets content as CSS's
    // border-box does — and which an open edge does not have.
    final double pad = ds(1.5) + DsWidths.hairline;
    final double lead = ds(0.5) + DsWidths.hairline;
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
        child: DsText(
          text,
          DsType.code,
          color: theme.mutedForeground,
          inline: true,
        ),
      ),
    );
  }
}

/// The chip's frame, painted the way a browser paints a broken inline box.
///
/// `box-decoration-break: slice` — the initial value — draws the border box
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
  static const double _overhang = DsRadii.sm + DsWidths.hairline;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect whole = Rect.fromLTRB(
      openLeft ? -_overhang : 0,
      0,
      size.width + (openRight ? _overhang : 0),
      size.height,
    );
    const Radius radius = Radius.circular(DsRadii.sm);
    // Half the hairline: a CSS border is drawn inside the border box, so the
    // stroke's centre line sits half a width in — the same inset
    // `BoxBorder.paintUniformBorder` uses for `BorderSide.strokeAlignInside`.
    final double inset = DsWidths.hairline / 2;

    canvas.save();
    canvas.clipRect(Offset.zero & size);
    canvas.drawRRect(
      RRect.fromRectAndRadius(whole, radius),
      Paint()..color = fill,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        whole.deflate(inset),
        Radius.circular(DsRadii.sm - inset),
      ),
      Paint()
        ..color = stroke
        ..style = PaintingStyle.stroke
        ..strokeWidth = DsWidths.hairline,
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
/// .bg-background.p-5.leading-relaxed.text-muted-foreground` — the multi-line
/// code sample. [DsCode]'s block-level twin, and the only one of the pair that
/// scrolls.
///
/// Three cascade facts decide how it reads, and two of them are utilities
/// beating the component layer:
/// * **`leading-relaxed` beats `.type-code`.** The class declares
///   `line-height: 1.4` inside `@layer components`; `leading-relaxed` is a
///   utility, so **1.625** wins — 20.3125px per line. That override is why the
///   style is assembled here rather than handed to [DsText], which renders a
///   `.type-*` class as declared.
/// * **`.type-code` sets no `font-weight`**, so a sample inherits 400. It is
///   the one mono class on the site that is not 600.
/// * The fill is `--background` — the same colour as the [DsPanel] body it
///   sits in — so only the hairline tells the two apart.
///
/// `<pre>` neither wraps nor reflows: it keeps the line breaks it was authored
/// with and hands anything too wide for the column to `overflow-x-auto`.
class DsCodeBlock extends StatefulWidget {
  const DsCodeBlock(this.code, {super.key});

  /// The sample, exactly as authored — newlines included, blank lines
  /// included, and never re-broken to fit.
  final String code;

  @override
  State<DsCodeBlock> createState() => _DsCodeBlockState();
}

class _DsCodeBlockState extends State<DsCodeBlock> {
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
    final DsThemeData theme = DsTheme.of(context);
    final TextStyle style =
        DsText.styleOf(context, DsType.code, color: theme.mutedForeground)
            .copyWith(height: _leadingRelaxed);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.background,
        borderRadius: BorderRadius.circular(DsRadii.lg),
        border: Border.all(color: theme.border, width: DsWidths.hairline),
      ),
      // `box-sizing: border-box` — the hairline is paid for out of the block's
      // own width, so the scroll port starts at the border's inner edge. Same
      // treatment [DsPanel] gives its body, and the reason the frame stays put
      // while the text underneath it moves.
      child: Padding(
        padding: const EdgeInsets.all(DsWidths.hairline),
        child: ClipRRect(
          // The inner curve: the outer radius less the border inside it.
          borderRadius: BorderRadius.circular(DsRadii.lg - DsWidths.hairline),
          child: DsThinScrollbar(
            controller: _scroller,
            child: SingleChildScrollView(
              controller: _scroller,
              scrollDirection: Axis.horizontal,
              // `p-5` belongs to the scroll container, so it travels with the
              // content: the left inset is what the first line starts behind,
              // and the right one is what the longest line ends against once
              // it has been scrolled to.
              padding: EdgeInsets.all(ds(5)),
              child: DsLineBox(
                style: style,
                // `softWrap: false` in a horizontally unbounded port is
                // `white-space: pre` — the sample is laid out at its own
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
class DsDoDont extends StatelessWidget {
  const DsDoDont({super.key, required this.dos, required this.donts});

  final List<String> dos;
  final List<String> donts;

  @override
  Widget build(BuildContext context) {
    return DsGrid(
      sm: 2,
      children: <Widget>[
        _DoDontPanel(
          heading: 'Do',
          tone: DsPalette.value,
          ink: DsTheme.of(context).valueInk,
          glyph: DsIconGlyph.check,
          iconTone: DsIconTone.value,
          items: dos,
        ),
        _DoDontPanel(
          // `Don&rsquo;t` — a real right single quotation mark, not an
          // apostrophe.
          heading: 'Don’t',
          tone: DsTheme.of(context).destructive,
          ink: DsTheme.of(context).destructiveInk,
          glyph: DsIconGlyph.x,
          iconTone: DsIconTone.error,
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
  final DsIconGlyph glyph;
  final DsIconTone iconTone;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ds(5)),
      decoration: BoxDecoration(
        color: tone.withValues(alpha: _doDontWashAlpha),
        borderRadius: BorderRadius.circular(DsRadii.lg),
        border: Border.all(
          color: tone.withValues(alpha: _doDontBorderAlpha),
          width: DsWidths.hairline,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DsText(heading, DsType.label, color: ink),
          SizedBox(height: ds(3)),
          for (int i = 0; i < items.length; i++) ...<Widget>[
            if (i > 0) SizedBox(height: ds(2.5)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  // `mt-0.5` — the glyph sits on the first line's x-height.
                  padding: EdgeInsets.only(top: ds(0.5)),
                  child: DsIcon(
                    glyph,
                    size: DsIconSize.sm,
                    tone: iconTone,
                  ),
                ),
                SizedBox(width: ds(2.5)),
                Expanded(child: DsText(items[i], DsType.small)),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/* ── Note ────────────────────────────────────────────────────────────────── */

/// Which ramp a [DsNote] washes itself with.
enum DsNoteTone { action, value, error }

/// Callout for a rule or trap worth interrupting the reader for.
class DsNote extends StatelessWidget {
  const DsNote({
    super.key,
    this.tone = DsNoteTone.action,
    this.title,
    required this.child,
  });

  final DsNoteTone tone;

  /// Renders `--muted-foreground` in **every** tone — see the library note.
  final String? title;

  /// Wrapped in `.type-small text-muted-foreground`, so a plain [Text.rich]
  /// with [DsCode] chips inherits the right style.
  final Widget child;

  Color _tone(DsThemeData theme) => switch (tone) {
        DsNoteTone.action => DsPalette.action,
        DsNoteTone.value => DsPalette.value,
        DsNoteTone.error => theme.destructive,
      };

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final Color ramp = _tone(theme);

    return Container(
      padding: EdgeInsets.all(ds(5)),
      decoration: BoxDecoration(
        color: ramp.withValues(alpha: _noteWashAlpha),
        borderRadius: BorderRadius.circular(DsRadii.lg),
        border: Border.all(
          color: ramp.withValues(alpha: _noteBorderAlpha),
          width: DsWidths.hairline,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (title != null) ...<Widget>[
            // No colour override: `.type-label` brings its own
            // `--muted-foreground`, which is what the browser renders here.
            DsText(title!, DsType.label),
            SizedBox(height: ds(2)),
          ],
          DefaultTextStyle(
            style: DsText.styleOf(context, DsType.small),
            child: child,
          ),
        ],
      ),
    );
  }
}

/* ── Index cards ─────────────────────────────────────────────────────────── */

/// `grid gap-4 sm:grid-cols-2 xl:grid-cols-3` — the foundations index.
class DsIndexGrid extends StatelessWidget {
  const DsIndexGrid({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) =>
      DsGrid(sm: 2, xl: 3, children: children);
}

/// A responsive card grid: [base] columns, widened at each named breakpoint.
///
/// Rows stretch to their tallest card, which is what a CSS grid row does and
/// what lets a card push its chip strip to the bottom edge.
class DsGrid extends StatelessWidget {
  const DsGrid({
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
    if (sm != null && viewport >= DsBreakpoints.sm) columns = sm!;
    if (md != null && viewport >= DsBreakpoints.md) columns = md!;
    if (lg != null && viewport >= DsBreakpoints.lg) columns = lg!;
    if (xl != null && viewport >= DsBreakpoints.xl) columns = xl!;
    return columns;
  }

  @override
  Widget build(BuildContext context) {
    final double space = gap ?? ds(4);
    final int columns = _columns(MediaQuery.sizeOf(context).width);
    final List<List<Widget>> rows = <List<Widget>>[];
    for (int i = 0; i < children.length; i += columns) {
      rows.add(children.sublist(
        i,
        i + columns > children.length ? children.length : i + columns,
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        for (int r = 0; r < rows.length; r++) ...<Widget>[
          if (r > 0) SizedBox(height: space),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                for (int c = 0; c < columns; c++) ...<Widget>[
                  if (c > 0) SizedBox(width: space),
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
class DsIndexCard extends StatelessWidget {
  const DsIndexCard({
    super.key,
    required this.href,
    required this.title,
    required this.blurb,
    required this.contents,
  })  : label = null,
        _group = false;

  /// The `#components` variant.
  const DsIndexCard.group({
    super.key,
    required this.href,
    required this.label,
    required this.title,
    required this.blurb,
    required this.contents,
  }) : _group = true;

  final String href;

  /// `N sets`, `.type-label text-action-ink` — group cards only.
  final String? label;

  final String title;
  final String blurb;
  final List<String> contents;

  final bool _group;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final double pad = _group ? ds(7) : ds(5);
    final double chipGap = _group ? ds(5) : ds(4);

    return DsLiftCard(
      radius: BorderRadius.circular(DsRadii.xl),
      fill: theme.card,
      borderColor: theme.border,
      hoverBorderColor:
          DsPalette.action.withValues(alpha: _cardHoverBorderAlpha),
      padding: EdgeInsets.all(pad),
      onTap: () => AppRouter.of(context).navigate(href),
      builder: (BuildContext context, bool hovered) => Column(
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
                          DsText(label!, DsType.label, color: theme.actionInk),
                          SizedBox(height: ds(3)),
                          DsText(title, DsType.h3, color: theme.foreground),
                        ],
                      )
                    : DsText(title, DsType.h4, color: theme.foreground),
              ),
              SizedBox(width: _group ? ds(4) : ds(3)),
              Padding(
                // `mt-1` on the group card, `mt-0.5` on the index card.
                padding: EdgeInsets.only(top: _group ? ds(1) : ds(0.5)),
                child: _CardArrow(hovered: hovered, large: _group),
              ),
            ],
          ),
          SizedBox(height: _group ? ds(3) : ds(2)),
          // `grow` — the blurb takes the slack so the chips sit on the bottom
          // edge however tall the row's tallest card is.
          Expanded(child: DsText(blurb, DsType.small)),
          SizedBox(height: chipGap),
          Container(
            padding: EdgeInsets.only(top: chipGap),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: theme.border, width: DsWidths.hairline),
              ),
            ),
            child: Wrap(
              spacing: ds(1.5),
              runSpacing: ds(1.5),
              children: <Widget>[
                for (final String chip in contents) _CardChip(label: chip),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// `Icon icon={ArrowRight}` with `transition-[transform,color] duration-fast
/// group-hover:translate-x-0.5 group-hover:text-action-ink`.
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
    final DsThemeData theme = DsTheme.of(context);
    final Duration fast = dsAnimationDuration(context, DsDurations.fast);
    // `AnimatedSlide` measures its offset in child widths, and the two
    // variants are different widths for the same 2px travel.
    final double px = large ? ds(5) : DsIcon.pxFor(DsIconSize.md);

    return AnimatedSlide(
      offset: Offset(hovered ? _arrowSlide / px : 0, 0),
      duration: fast,
      curve: DsCurves.out,
      child: TweenAnimationBuilder<Color?>(
        tween: ColorTween(
          end: hovered ? theme.actionInk : theme.mutedForeground,
        ),
        duration: fast,
        curve: DsCurves.out,
        builder: (BuildContext context, Color? colour, Widget? child) =>
            DefaultTextStyle.merge(
          style: TextStyle(color: colour),
          child: child!,
        ),
        child: DsIcon(
          DsIconGlyph.arrowRight,
          sizePx: large ? ds(5) : null,
          strokeOverride:
              large ? DsIcon.strokeFor(DsIcon.pxFor(DsIconSize.md)) : null,
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
    final DsThemeData theme = DsTheme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ds(2), vertical: ds(1)),
      decoration: BoxDecoration(
        color: theme.muted,
        borderRadius: BorderRadius.circular(DsRadii.sm),
      ),
      child: DsText(label, DsType.caption, color: theme.mutedForeground),
    );
  }
}

/* ── Prev / next ─────────────────────────────────────────────────────────── */

/// `nav.mt-8.flex.items-stretch.gap-4.border-t.border-border.pt-8`.
///
/// Reads its two neighbours out of the nav registry, so the order of the pages
/// is stated once. A missing side is an empty flex slot, not a missing card —
/// the present side keeps its half of the row.
class DsPageFootNav extends StatelessWidget {
  const DsPageFootNav({super.key, required this.groupId, required this.slug});

  final String groupId;
  final String slug;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final DsSiblings around = siblings(groupId, slug);
    if (around.prev == null && around.next == null) {
      return const SizedBox.shrink();
    }

    return Container(
      // No `mt-8` here, and that is not an omission: the nav always follows a
      // `DsSection`, whose `mb-20` is an adjoining margin. CSS collapses the
      // pair to the larger of the two, so the 80px below the last section is
      // the whole gap and the nav's own 32px never shows. Flutter has no
      // margin collapsing — it would add them — so the collapse is done here.
      padding: EdgeInsets.only(top: ds(8)),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: theme.border, width: DsWidths.hairline),
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
            SizedBox(width: ds(4)),
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

  final DsNavLink link;
  final bool isNext;

  @override
  State<_FootNavCard> createState() => _FootNavCardState();
}

class _FootNavCardState extends State<_FootNavCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);

    final Widget arrow = DsIcon(
      widget.isNext ? DsIconGlyph.arrowRight : DsIconGlyph.arrowLeft,
      tone: DsIconTone.muted,
    );
    final Widget copy = Column(
      crossAxisAlignment: widget.isNext
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        DsText(
          widget.isNext ? 'Next' : 'Previous',
          DsType.micro,
          align: widget.isNext ? TextAlign.right : TextAlign.left,
        ),
        SizedBox(height: ds(1)),
        DsText(
          widget.link.title,
          DsType.small,
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
      child: DsPress(
        onTap: () => AppRouter.of(context).navigate(widget.link.href),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: ds(5), vertical: ds(4)),
          decoration: BoxDecoration(
            color: theme.card,
            borderRadius: BorderRadius.circular(DsRadii.lg),
            // `hover:border-input` with no transition utility on colour: the
            // card's `press` covers `transform` only, so this swap is instant.
            border: Border.all(
              color: _hovered ? theme.input : theme.border,
              width: DsWidths.hairline,
            ),
          ),
          child: Row(
            mainAxisAlignment: widget.isNext
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: <Widget>[
              if (!widget.isNext) ...<Widget>[arrow, SizedBox(width: ds(3))],
              Flexible(child: copy),
              if (widget.isNext) ...<Widget>[SizedBox(width: ds(3)), arrow],
            ],
          ),
        ),
      ),
    );
  }
}

/* ── Shared ──────────────────────────────────────────────────────────────── */

/// `divide-y divide-border overflow-hidden rounded-lg border border-border
/// bg-card` — one card with hairlines between its rows and none at its edges.
///
/// Public because three pages stack rows this way outside [DsMeta]: the
/// overview's numbered rules (`rounded-xl`), the typography specimen rows, and
/// the colors page's swatch list.
class DsDividedList extends StatelessWidget {
  const DsDividedList({
    super.key,
    this.radius = DsRadii.lg,
    required this.children,
  });

  final double radius;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final BorderRadius shape = BorderRadius.circular(radius);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: shape,
        border: Border.all(color: theme.border, width: DsWidths.hairline),
      ),
      // `box-sizing: border-box` — the frame costs the rows a pixel on each
      // side, so a row's content box is the list's width less two.
      child: Padding(
        padding: const EdgeInsets.all(DsWidths.hairline),
        child: ClipRRect(
          // The inner curve: the outer radius less the border inside it.
          borderRadius: BorderRadius.circular(radius - DsWidths.hairline),
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
                          width: DsWidths.hairline,
                        ),
                      ),
                    ),
                    // The divider is a `border-top` on the row itself, so it
                    // adds to that row's height and sits above its content
                    // rather than over the first pixel of it.
                    child: Padding(
                      padding: const EdgeInsets.only(top: DsWidths.hairline),
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
