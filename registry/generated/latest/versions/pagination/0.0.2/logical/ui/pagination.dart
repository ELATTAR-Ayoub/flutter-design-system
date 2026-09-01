/// `components/ui/pagination.tsx` — page numbers, built entirely out of
/// [Button].
///
/// The page's framing: *"The marketplace and the Stash both paginate.
/// Load-more is used for the live feed instead, because that list grows from
/// the top."* Nothing here is a new surface: every cell is a `Button asChild`
/// wrapped around an `<a>`, so the pill, the spring, the focus ring and the
/// press are the button's and are not restated.
///
/// **Resolved, measured on the live reference at 1440 × 900 (2026-08-16):**
///
/// | slot | class list | measured |
/// |---|---|---|
/// | `nav` | `mx-auto flex w-full justify-center` | the full 1030 column, contents centred |
/// | `ul` | `flex items-center gap-0.5` | 2px between cells |
/// | number | `Button variant={isActive ? "outline" : "ghost"} size="icon"` | a 40 × 40 pill |
/// | Previous | the same, `size="default"` + `pl-1.5!` | `padding: 0 16px 0 6px`, `gap-2`, 101.94 wide |
/// | Next | `size="default"` + `pr-1.5!` | the mirror, 77.09 wide |
/// | ellipsis | `flex size-8 items-center justify-center` | a 32 × 32 box, 4px shorter than the row |
///
/// **The numbers inherit their type from the page.** `size="icon"` is
/// `size-10` and nothing else — no `text-*`, no `gap-*`, no `px-*` — so `1`,
/// `2`, `3` and `12` render at the document's own 16px / 400 rather than at the
/// 13px / 500 the two word buttons beside them use. The probe reads
/// `16px/24px 500` on the squares and `13px/18.5714px 500` on Previous and
/// Next. [Button.typeFor] already answers null for the four square rungs and
/// merges only the ink, which is that behaviour; this file spends nothing to
/// get it.
///
/// **DRIFT — `data-icon="inline-start"` is doubly dead.** `PaginationPrevious`
/// and `PaginationNext` write it onto their chevrons. `Icon`'s props do not
/// include it, so it never reaches the DOM; and the only `[data-icon]` rules in
/// `app/globals.css` are scoped under `.cn-toast`, so it would style nothing if
/// it did. Recorded, and nothing is built for it.
///
/// **`hidden sm:block` on both labels** is live at every width this port is
/// measured at (`--breakpoint-sm` is 640). Recorded; the words always render.
library;

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

import '../../design_system/foundation/spacing.dart';
import './button.dart';
import './icon.dart';
import './icon_paths.dart';

/// The `nav` and its `ul` — a centred row of cells.
///
/// Takes **widgets**, not models, and deliberately: `PaginationContent`'s
/// children are four different components (a link, an ellipsis, a previous and
/// a next), the reference's own API is compositional, and a model union would
/// be a translation of a translation. The one thing the container contributes
/// is the 2px gap and the centring.
class Pagination extends StatelessWidget {
  const Pagination({super.key, required this.children});

  /// One `PaginationItem` each, in order.
  final List<Widget> children;

  /// `gap-0.5` on the content row.
  static double get gap => space(0.5);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      // `role="navigation" aria-label="pagination"`.
      label: 'pagination',
      explicitChildNodes: true,
      // **Not scrolled, deliberately.** A pager that outgrows its column is
      // the page's problem, as it is in the reference: a scroll view here
      // unbounds the width the cells measure against and changes what every
      // specimen of this component measures. The consumer decides whether this
      // row scrolls.
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          for (int i = 0; i < children.length; i++) ...<Widget>[
            if (i > 0) SizedBox(width: gap),
            children[i],
          ],
        ],
      ),
    );
  }
}

/// One numbered page.
///
/// `isActive` picks the variant — `outline` for the page you are on, `ghost`
/// for the rest — and is what sets `aria-current="page"`.
class PaginationLink extends StatelessWidget {
  const PaginationLink({
    super.key,
    required this.label,
    this.isActive = false,
    this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      link: true,
      selected: isActive,
      child: Button(
        variant: isActive ? ButtonVariant.outline : ButtonVariant.ghost,
        size: ButtonSize.icon,
        onPressed: onTap ?? () {},
        // A bare [Text]: the `icon` rung declares no `text-*`, so the number
        // takes the page's ambient style and only the ink comes from the
        // button. Resolving a spec here would invent a size.
        child: Text(label),
      ),
    );
  }
}

/// `PaginationPrevious` / `PaginationNext` — a chevron and a word.
///
/// One widget for both because the two differ in exactly three things: which
/// side the chevron sits on, which side the `!`-important 6px padding lands on,
/// and the default word. The reference writes them as two functions with the
/// same body mirrored.
class PaginationStep extends StatelessWidget {
  /// `PaginationPrevious` — `pl-1.5!`, chevron first, *"Previous"*.
  const PaginationStep.previous({super.key, this.text = 'Previous', this.onTap})
    : _next = false;

  /// `PaginationNext` — `pr-1.5!`, word first, *"Next"*.
  const PaginationStep.next({super.key, this.text = 'Next', this.onTap})
    : _next = true;

  /// The `text` prop. Both defaults are the reference's own, and the page
  /// overrides neither.
  final String text;

  final VoidCallback? onTap;

  final bool _next;

  /// `pl-1.5!` / `pr-1.5!` — the tightened edge.
  static double get tightPadding => space(1.5);

  /// The untouched edge keeps the `default` rung's own `px-4`.
  static double get loosePadding => Button.paddingXFor(ButtonSize.md);

  @override
  Widget build(BuildContext context) {
    final Widget chevron = Icon(
      _next ? IconGlyph.chevronRight : IconGlyph.chevronLeft,
      sizePx: Button.iconPxFor(ButtonSize.md),
      tone: IconTone.inherit,
    );
    final Widget word = Text(text);

    return Semantics(
      link: true,
      label: _next ? 'Go to next page' : 'Go to previous page',
      child: Button(
        // Neither carries `isActive`, so both take `PaginationLink`'s
        // `variant={isActive ? "outline" : "ghost"}` false branch.
        variant: ButtonVariant.ghost,
        size: ButtonSize.md,
        padding: EdgeInsetsDirectional.only(
          start: _next ? loosePadding : tightPadding,
          end: _next ? tightPadding : loosePadding,
        ).resolve(Directionality.of(context)),
        onPressed: onTap ?? () {},
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (!_next) ...<Widget>[
              chevron,
              SizedBox(width: Button.gapFor(ButtonSize.md)),
            ],
            // The button's own [DefaultTextStyle] is what both the word and
            // the `tone: inherit` chevron read — the animated ink, spelled
            // once, exactly as `currentColor` resolves in CSS.
            word,
            if (_next) ...<Widget>[
              SizedBox(width: Button.gapFor(ButtonSize.md)),
              chevron,
            ],
          ],
        ),
      ),
    );
  }
}

/// `PaginationEllipsis` — a 32px square in a 40px row.
///
/// `aria-hidden` with an `sr-only` *"More pages"* underneath it, which is a
/// contradiction the reference ships: `aria-hidden` hides the span too. The
/// port reproduces the outcome — nothing is announced — and records the intent.
class PaginationEllipsis extends StatelessWidget {
  const PaginationEllipsis({super.key});

  /// `size-8`.
  static double get boxSize => space(8);

  /// `[&_svg:not([class*='size-'])]:size-4`.
  static double get glyphSize => space(4);

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: SizedBox.square(
        dimension: boxSize,
        child: Center(
          // The cell sets no colour of its own, so the glyph inherits the
          // page's `--foreground` — which is what the probe reads.
          child: Icon(
            IconGlyph.ellipsis,
            sizePx: glyphSize,
            tone: IconTone.inherit,
          ),
        ),
      ),
    );
  }
}
