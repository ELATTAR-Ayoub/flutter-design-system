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
      child: ClipRRect(
        // `overflow-hidden`, so the body's fill stops at the corner.
        borderRadius: radius,
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
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: <Widget>[
                    if (label != null)
                      Flexible(
                        child: DsText(
                          label!,
                          DsType.label,
                          color: theme.mutedForeground,
                        ),
                      ),
                    const Spacer(),
                    if (note != null) ...<Widget>[
                      SizedBox(width: ds(4)),
                      Flexible(
                        // `.type-num-*` declares no colour of its own; the
                        // strip states it.
                        child: DsText(
                          note!,
                          DsType.numSm,
                          color: theme.mutedForeground,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            Container(
              color: theme.background,
              padding:
                  flush ? EdgeInsets.zero : bodyPadding ?? EdgeInsets.all(ds(6)),
              child: child,
            ),
          ],
        ),
      ),
    );
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
  Widget build(BuildContext context) => Text.rich(
        value,
        style: DsText.styleOf(context, DsType.small),
      );
}

/// `code.type-code.rounded-sm.border.border-border.bg-card.px-1.5.py-0.5` —
/// the inline code chip.
class DsCode extends StatelessWidget {
  const DsCode(this.text, {super.key});

  final String text;

  /// The same chip, spliced into a sentence.
  ///
  /// Flutter has no inline box: a chip inside a paragraph is a [WidgetSpan],
  /// baseline-aligned so it sits on the sentence's own baseline rather than
  /// riding the line box.
  static InlineSpan span(String text) => WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: DsCode(text),
      );

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ds(1.5), vertical: ds(0.5)),
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(DsRadii.sm),
        border: Border.all(color: theme.border, width: DsWidths.hairline),
      ),
      child: DsText(text, DsType.code, color: theme.mutedForeground),
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
      margin: EdgeInsets.only(top: ds(8)),
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
      child: ClipRRect(
        borderRadius: shape,
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
                  child: children[i],
                ),
          ],
        ),
      ),
    );
  }
}
