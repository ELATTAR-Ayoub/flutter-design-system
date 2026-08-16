/// `/design-system/components/base/layout` — five structural helpers, and the
/// page where three of them are quietly broken on the reference.
///
/// The four `components/ui/` files this page imports all land in the package
/// this phase: `aspect-ratio.tsx` → [DsAspectRatio], `scroll-area.tsx` →
/// [DsScrollArea], `carousel.tsx` → [DsCarousel], `resizable.tsx` →
/// [DsResizablePanelGroup]. `badge.tsx` was already here.
///
/// **The fidelity bar is that it moves — and that it does not move where the
/// reference does not.** A reader can hover the rail into existence and drag
/// its thumb, drag the carousel and click the 8px of arrow that survives the
/// clip, and drag the admin split. A reader can also *fail* to reach 284px of
/// the horizontal card rail, exactly as on the reference, because
/// `overflow-x` is `hidden` there and no gesture opens it.
///
/// ## Drift register — recorded, shipped as written
///
///  1. **The carousel's arrows are 8px wide, and the page says they are
///     "always visible".** `-left-12` / `-right-12` on a 32px button puts each
///     one 24px outside the `Panel`'s `overflow-hidden` frame. Measured:
///     `elementFromPoint` returns `<main>` at the button's own centre and the
///     button only across x ∈ [1372, 1379]; six real clicks at the centre
///     moved nothing. §4's description — *"Arrows are always visible and it is
///     fully keyboard navigable"* — describes the second half correctly and
///     the first half not at all. Reproduced: the port clips the same 24px
///     and answers the same sliver.
///  2. **The horizontal `ScrollArea` cannot scroll.** `<ScrollArea>` renders
///     one vertical `ScrollBar`, and Radix sets `overflow-x: hidden` on any
///     axis with no bar (measured inline `overflow: hidden scroll`). The rail
///     is 764px of cards in a 480px viewport: 284px are unreachable by wheel,
///     drag or keyboard, and only `scrollLeft = n` from a console moves it.
///     The page's own API row — *"Add ScrollBar for a horizontal bar"* — is
///     the instruction the specimen above it does not follow. Reproduced
///     ([DsScrollArea.horizontalBar] left false).
///  3. **`minSize={25}` is 25 pixels.** `react-resizable-panels@4` writes
///     `defaultSize` into `flex-grow` — where 40 and 60 survive only as a
///     ratio, and so *look* like percentages — while `minSize` stays in
///     pixels. Dragged hard left the first panel stops at 25.0px and the
///     separator reports `aria-valuemin="2.434"`. Two props on one component,
///     read in two units. Reproduced.
///  4. **The `Resizable` section demonstrates a component the page forbids.**
///     §5's description opens *"Not used in the collector-facing product"* and
///     §7's fourth don't is *"Don't use Resizable in the collector-facing
///     product"*. It is documented anyway, which is the right call and worth
///     recording as an inconsistency between the chips and the rules.
///  5. **`ScrollArea` has no rail until you hover it.** Radix's `type`
///     defaults to `"hover"`, so `[data-slot="scroll-area-scrollbar"]` is not
///     in the DOM at rest — a specimen whose entire subject is the scrollbar
///     shows no scrollbar in a screenshot. Measured: mounted within a frame of
///     `pointerenter`, unmounted 600ms after `pointerleave`. Reproduced.
///  6. **The two scrollbar sections reserve different amounts of nothing.**
///     `scrollbar-gutter-stable` on the vertical browser-scrollbar specimen
///     costs its content column 10px (measured `clientWidth` 470 against a
///     480px padding box); the horizontal one, which has no gutter class,
///     loses none — its rail is drawn over the content. Both ship.
///  7. **`AspectRatio`'s `mb-4` shrinks the box instead of spacing it.** The
///     carousel card's ratio box is absolutely positioned to its slot's four
///     edges, so a bottom margin comes out of its own height: a 398.203px slot
///     with a 382.203px box in it. Reproduced by [DsAspectRatio.margin].
///  8. **Five chips, seven sections.** `contents` is `[Aspect Ratio, Scroll
///     Area, Browser Scrollbar, Carousel, Resizable]`; `API` and `Rules` get
///     no chip. The same shape `selection` records as its drift 1.
///  9. **`ResizableHandle`'s `focus-visible:ring-1` is unreachable in
///     practice.** The separator is `tabIndex 0`, but the grab strip is 4px
///     wide and nothing on the page hints it can be tabbed to; the ring is
///     never seen. Built anyway — the port focuses on tab and paints nothing
///     extra, which is what the reference does at rest (`box-shadow: none`).
/// 10. **The group is `min-h-56` and its content is shorter**, so the two
///     panels are exactly 222px tall — the 224px floor less the frame. Nothing
///     on the page ever makes it taller.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../kit.dart';
import '../nav.dart';
import '../shell.dart';

/* ── Page constants ──────────────────────────────────────────────────────── */

/// The six featured packs, in the reference's own order.
const List<(String, String)> _packs = <(String, String)>[
  ('Eclipse Vault', r'$48.00'),
  ('Golden Rift', r'$120.00'),
  ('Mystic Surge', r'$32.00'),
  ('Shadow Core', r'$76.00'),
  ('Celestial Strike', r'$210.00'),
  ('Origin Pulse', r'$18.00'),
];

/// `bg-action/12` on the carousel card's ratio box, read off the ramp for the
/// same reason `selection.dart` does: the page says `action`, so the port says
/// `action`.
const double _actionTint = 0.12;

/// `h-64` — the vertical `ScrollArea`'s frame.
double get _scrollAreaHeight => ds(64);

/// `h-52` — the vertical browser-scrollbar frame.
double get _nativeScrollHeight => ds(52);

/// `min-h-56` on the resizable group.
double get _splitMinHeight => ds(56);

/// `scrollbar-gutter: stable` under `scrollbar-width: thin`, measured at 10px
/// — the same reservation `DsMessageScrollerViewport.gutter` names.
double get _scrollbarGutter => DsMessageScrollerViewport.gutter;

/// `size-28` on the ScrollArea rail's cards, `h-28 w-36` on the browser
/// scrollbar's.
double get _railCard => ds(28);
double get _shelfCardWidth => ds(36);

/* ── Page ────────────────────────────────────────────────────────────────── */

class LayoutPage extends StatelessWidget {
  const LayoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final DsCategoryHit here = findCategory('base', 'layout');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DsPageHeader(
          eyebrow: '${here.group.title} · Base',
          title: here.category.title,
          blurb: here.category.blurb,
          contents: here.category.contents,
        ),
        const _AspectRatioSection(),
        const _ScrollAreaSection(),
        const _BrowserScrollbarSection(),
        const _CarouselSection(),
        const _ResizableSection(),
        const _ApiSection(),
        const _RulesSection(),
        const DsPageFootNav(groupId: 'base', slug: 'layout'),
      ],
    );
  }
}

/* ── 1 · Aspect Ratio ────────────────────────────────────────────────────── */

class _AspectRatioSection extends StatelessWidget {
  const _AspectRatioSection();

  @override
  Widget build(BuildContext context) {
    return DsSection(
      id: 'aspect-ratio',
      title: 'Aspect Ratio',
      description:
          'Locks a box to a ratio so a grid of packs or cards never shifts as '
          'images load. This is the single most effective defence against '
          'layout jump.',
      child: DsPanel(
        label: "The product's three ratios",
        child: DsGrid(
          sm: 3,
          gap: ds(6),
          children: const <Widget>[
            _RatioCell(
              ratio: 5 / 7,
              label: '5 : 7',
              title: 'Collectible card',
              blurb:
                  'Matches a physical trading card, so scans sit in the '
                  'frame without cropping.',
            ),
            _RatioCell(
              ratio: 3 / 4,
              label: '3 : 4',
              title: 'Pack artwork',
              blurb:
                  'Taller than wide, so a pack reads as an object you tear '
                  'open.',
            ),
            _RatioCell(
              ratio: 16 / 9,
              label: '16 : 9',
              title: 'Featured banner',
              blurb: 'Hero panels and the featured pack carousel.',
            ),
          ],
        ),
      ),
    );
  }
}

/// One `<div>` of the three-up grid: a ratio box, a label and a sentence.
class _RatioCell extends StatelessWidget {
  const _RatioCell({
    required this.ratio,
    required this.label,
    required this.title,
    required this.blurb,
  });

  final double ratio;
  final String label;
  final String title;
  final String blurb;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        DsAspectRatio(
          ratio: ratio,
          // `grid place-items-center rounded-lg border border-border bg-muted`.
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: theme.muted,
              borderRadius: BorderRadius.circular(DsRadii.lg),
              border: Border.all(color: theme.border, width: DsWidths.hairline),
            ),
            child: Center(
              child: DsText(label, DsType.numSm, color: theme.mutedForeground),
            ),
          ),
        ),
        // `mt-3`.
        SizedBox(height: ds(3)),
        DsText(title, DsType.label),
        // `mt-1`.
        SizedBox(height: ds(1)),
        DsText(blurb, DsType.small),
      ],
    );
  }
}

/* ── 2 · Scroll Area ─────────────────────────────────────────────────────── */

class _ScrollAreaSection extends StatelessWidget {
  const _ScrollAreaSection();

  @override
  Widget build(BuildContext context) {
    return DsSection(
      id: 'scroll-area',
      title: 'Scroll Area',
      description:
          'A styled scroll container. Used wherever a list is taller than its '
          'panel — filter lists, the possible-hits gallery, notification '
          'panels.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          DsGrid(
            lg: 2,
            children: const <Widget>[
              DsPanel(
                label: 'Vertical — possible hits',
                child: _PossibleHits(),
              ),
              DsPanel(
                label: 'Horizontal — card set rail',
                child: _CardSetRail(),
              ),
            ],
          ),
          // `<Note className="mt-4">`.
          SizedBox(height: ds(4)),
          DsNote(
            // `DsRichText`, not a bare `Text.rich`: the chips are
            // [WidgetSpan]s 23px tall inside a 19.5px line, and only the
            // spec's own strut keeps the line box at `.type-small`'s height
            // instead of letting the tallest chip set it. Measured: half a
            // pixel per line, twice over, before this.
            child: DsRichText(
              TextSpan(
                children: <InlineSpan>[
                  DsCode.span('ScrollArea'),
                  const TextSpan(
                    text:
                        ' replaces the browser scrollbar with a composed '
                        'control. Use it for contained application panels; '
                        'use native overflow for the page and simple '
                        'shelves.',
                  ),
                ],
              ),
              DsType.small,
            ),
          ),
        ],
      ),
    );
  }
}

/// `<ScrollArea className="h-64 rounded-lg border border-border">` — fourteen
/// rows of 43.5, thirteen hairlines, 622 of content in 254 of viewport.
class _PossibleHits extends StatelessWidget {
  const _PossibleHits();

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);

    return SizedBox(
      height: _scrollAreaHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(DsRadii.lg),
          border: Border.all(color: theme.border, width: DsWidths.hairline),
        ),
        child: Padding(
          padding: const EdgeInsets.all(DsWidths.hairline),
          child: DsScrollArea(
            // `rounded-[inherit]`, on the frame's inner curve.
            borderRadius: BorderRadius.circular(DsRadii.lg - DsWidths.hairline),
            child: _SeamedColumn(
              colour: theme.border,
              children: <Widget>[
                for (int i = 0; i < 14; i++)
                  _HitRow(
                    name: 'Card #${(i + 1).toString().padLeft(3, '0')}',
                    price: '\$${(1200 - i * 73).toStringAsFixed(2)}',
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// `flex items-center justify-between px-4 py-3`.
class _HitRow extends StatelessWidget {
  const _HitRow({required this.name, required this.price});

  final String name;
  final String price;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ds(4), vertical: ds(3)),
      child: Row(
        children: <Widget>[
          DsText(name, DsType.small, color: theme.foreground),
          const Spacer(),
          DsText(price, DsType.numSm, color: theme.valueInk),
        ],
      ),
    );
  }
}

/// `<ScrollArea className="w-full rounded-lg border border-border">` — 764px
/// of cards behind an `overflow-x: hidden` viewport. Drift 2.
class _CardSetRail extends StatelessWidget {
  const _CardSetRail();

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(DsRadii.lg),
        border: Border.all(color: theme.border, width: DsWidths.hairline),
      ),
      child: Padding(
        padding: const EdgeInsets.all(DsWidths.hairline),
        child: DsScrollArea(
          borderRadius: BorderRadius.circular(DsRadii.lg - DsWidths.hairline),
          child: Padding(
            // `p-4`.
            padding: EdgeInsets.all(ds(4)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                for (int i = 0; i < _packs.length; i++) ...<Widget>[
                  // `gap-3`.
                  if (i > 0) SizedBox(width: ds(3)),
                  SizedBox(
                    width: _railCard,
                    height: _railCard,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: theme.muted,
                        borderRadius: BorderRadius.circular(DsRadii.md),
                        border: Border.all(
                          color: theme.border,
                          width: DsWidths.hairline,
                        ),
                      ),
                      child: Center(
                        child: DsText(
                          _packs[i].$1,
                          DsType.micro,
                          align: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/* ── 3 · Browser Scrollbar ───────────────────────────────────────────────── */

class _BrowserScrollbarSection extends StatelessWidget {
  const _BrowserScrollbarSection();

  @override
  Widget build(BuildContext context) {
    return DsSection(
      id: 'browser-scrollbar',
      title: 'Browser Scrollbar',
      description:
          'The native browser rail, styled globally from globals.css. The page '
          'gets it automatically; nested overflow regions opt in with '
          'scrollbar-thin. Width and height share one treatment, so vertical '
          'and horizontal rails feel like the same control.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          DsGrid(
            lg: 2,
            children: const <Widget>[
              DsPanel(label: 'Vertical — long list', child: _ActivityList()),
              DsPanel(label: 'Horizontal — wide shelf', child: _WideShelf()),
            ],
          ),
          SizedBox(height: ds(4)),
          DsNote(
            child: DsRichText(
              TextSpan(
                children: <InlineSpan>[
                  const TextSpan(
                    text: 'The page-level scrollbar needs no class. Add ',
                  ),
                  DsCode.span('scrollbar-thin'),
                  const TextSpan(text: ' only to nested elements with '),
                  DsCode.span('overflow-x-*'),
                  const TextSpan(text: ' or '),
                  DsCode.span('overflow-y-*'),
                  const TextSpan(
                    text:
                        '. Operating systems may render native rails as '
                        'overlays until scrolling begins.',
                  ),
                ],
              ),
              DsType.small,
            ),
          ),
        ],
      ),
    );
  }
}

/// `scrollbar-thin scrollbar-gutter-stable h-52 overflow-y-scroll` — the
/// gutter is inside the frame, so the rows are 470 wide, not 480. Drift 6.
class _ActivityList extends StatefulWidget {
  const _ActivityList();

  @override
  State<_ActivityList> createState() => _ActivityListState();
}

class _ActivityListState extends State<_ActivityList> {
  final ScrollController _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);

    return SizedBox(
      height: _nativeScrollHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.background,
          borderRadius: BorderRadius.circular(DsRadii.lg),
          border: Border.all(color: theme.border, width: DsWidths.hairline),
        ),
        child: Padding(
          padding: const EdgeInsets.all(DsWidths.hairline),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(DsRadii.lg - DsWidths.hairline),
            child: DsThinScrollbar(
              controller: _controller,
              child: SingleChildScrollView(
                controller: _controller,
                child: Padding(
                  // `scrollbar-gutter: stable`.
                  padding: EdgeInsetsDirectional.only(end: _scrollbarGutter),
                  child: _SeamedColumn(
                    colour: theme.border,
                    children: <Widget>[
                      for (int i = 0; i < 12; i++)
                        _ActivityRow(
                          name:
                              'Activity ${(i + 1).toString().padLeft(2, '0')}',
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ds(4), vertical: ds(3)),
      child: Row(
        children: <Widget>[
          DsText(name, DsType.small, color: theme.foreground),
          const Spacer(),
          DsText('Ready', DsType.caption, color: theme.mutedForeground),
        ],
      ),
    );
  }
}

/// `scrollbar-thin w-full overflow-x-scroll … p-4` — no gutter class, so the
/// rail is drawn over the shelf rather than beside it. Drift 6.
class _WideShelf extends StatefulWidget {
  const _WideShelf();

  @override
  State<_WideShelf> createState() => _WideShelfState();
}

class _WideShelfState extends State<_WideShelf> {
  final ScrollController _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.background,
        borderRadius: BorderRadius.circular(DsRadii.lg),
        border: Border.all(color: theme.border, width: DsWidths.hairline),
      ),
      child: Padding(
        padding: const EdgeInsets.all(DsWidths.hairline),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(DsRadii.lg - DsWidths.hairline),
          child: DsThinScrollbar(
            controller: _controller,
            child: SingleChildScrollView(
              controller: _controller,
              scrollDirection: Axis.horizontal,
              // `p-4` on the scroll container itself, so it travels with the
              // content rather than framing the viewport.
              padding: EdgeInsets.all(ds(4)),
              child: Padding(
                // `pb-2` on the flex row inside.
                padding: EdgeInsets.only(bottom: ds(2)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    for (int i = 0; i < _packs.length; i++) ...<Widget>[
                      if (i > 0) SizedBox(width: ds(3)),
                      SizedBox(
                        width: _shelfCardWidth,
                        height: _railCard,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: theme.muted,
                            borderRadius: BorderRadius.circular(DsRadii.md),
                            border: Border.all(
                              color: theme.border,
                              width: DsWidths.hairline,
                            ),
                          ),
                          child: Padding(
                            // `px-3`.
                            padding: EdgeInsets.symmetric(horizontal: ds(3)),
                            child: Center(
                              child: DsText(
                                _packs[i].$1,
                                DsType.micro,
                                align: TextAlign.center,
                                color: theme.foreground,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/* ── 4 · Carousel ────────────────────────────────────────────────────────── */

class _CarouselSection extends StatelessWidget {
  const _CarouselSection();

  @override
  Widget build(BuildContext context) {
    return DsSection(
      id: 'carousel',
      title: 'Carousel',
      description:
          'The featured pack carousel on the landing page. Arrows are always '
          'visible and it is fully keyboard navigable — a carousel you can '
          'only swipe is inaccessible.',
      child: DsPanel(
        label: 'Featured packs',
        // The `p-6` moves inside so the arrows can hang out of it and be
        // clipped by this panel's own frame — drift 1, and the whole reason
        // [DsCarousel] takes a padding of its own.
        flush: true,
        child: DsCarousel(
          padding: EdgeInsets.all(ds(6)),
          // `basis-1/2 lg:basis-1/3` at the port's 1440 frame.
          basis: 1 / 3,
          items: <Widget>[
            for (final (String, String) pack in _packs) _PackCard(pack: pack),
          ],
        ),
      ),
    );
  }
}

/// `lift rounded-lg border border-border bg-card p-4`.
class _PackCard extends StatelessWidget {
  const _PackCard({required this.pack});

  final (String, String) pack;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);

    return DsLiftCard(
      radius: BorderRadius.circular(DsRadii.lg),
      padding: EdgeInsets.all(ds(4)),
      cursor: MouseCursor.defer,
      builder: (BuildContext context, bool hovered) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          DsAspectRatio(
            ratio: 3 / 4,
            // `mb-4` — drift 7: it shortens the box, it does not space it.
            margin: EdgeInsets.only(bottom: ds(4)),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: DsPalette.action.withValues(alpha: _actionTint),
                borderRadius: BorderRadius.circular(DsRadii.md),
                border: Border.all(
                  color: theme.border,
                  width: DsWidths.hairline,
                ),
              ),
            ),
          ),
          DsText('Eclipse series', DsType.label),
          // `mt-1.5`.
          SizedBox(height: ds(1.5)),
          DsText(pack.$1, DsType.h4, color: theme.foreground),
          // `mt-3`.
          SizedBox(height: ds(3)),
          Row(
            children: <Widget>[
              DsText(pack.$2, DsType.numMd, color: theme.valueInk),
              const Spacer(),
              const DsBadge(
                label: '6 Cards',
                variant: DsBadgeVariant.secondary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/* ── 5 · Resizable ───────────────────────────────────────────────────────── */

class _ResizableSection extends StatelessWidget {
  const _ResizableSection();

  @override
  Widget build(BuildContext context) {
    return DsSection(
      id: 'resizable',
      title: 'Resizable',
      description:
          'Not used in the collector-facing product. Reserved for the admin '
          'surface, where a card table beside a detail pane needs an '
          'adjustable split.',
      child: DsPanel(
        label: 'Admin split view',
        note: 'Future admin surface',
        child: _AdminSplit(),
      ),
    );
  }
}

class _AdminSplit extends StatelessWidget {
  const _AdminSplit();

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(DsRadii.lg),
        border: Border.all(color: theme.border, width: DsWidths.hairline),
      ),
      child: Padding(
        padding: const EdgeInsets.all(DsWidths.hairline),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(DsRadii.lg - DsWidths.hairline),
          child: DsResizablePanelGroup(
            minHeight: _splitMinHeight - DsWidths.hairline * 2,
            panels: <DsResizablePanel>[
              DsResizablePanel(
                defaultSize: 40,
                // DRIFT 3: pixels, however much it reads as a percentage.
                minSize: 25,
                child: _SplitPane(
                  fill: theme.background,
                  title: 'Card list',
                  body:
                      'Drag the handle. Panel sizes persist while the '
                      'session lasts.',
                ),
              ),
              DsResizablePanel(
                defaultSize: 60,
                child: _SplitPane(
                  fill: theme.card,
                  title: 'Card detail',
                  // `Editing a card&rsquo;s rarity, value and print run.` —
                  // a real right single quotation mark.
                  body: 'Editing a card’s rarity, value and print run.',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// `h-full bg-* p-5`.
class _SplitPane extends StatelessWidget {
  const _SplitPane({
    required this.fill,
    required this.title,
    required this.body,
  });

  final Color fill;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: fill,
      child: Padding(
        padding: EdgeInsets.all(ds(5)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            DsText(title, DsType.label),
            // `mb-3`.
            SizedBox(height: ds(3)),
            DsText(body, DsType.small),
          ],
        ),
      ),
    );
  }
}

/* ── 6 · API ─────────────────────────────────────────────────────────────── */

class _ApiSection extends StatelessWidget {
  const _ApiSection();

  @override
  Widget build(BuildContext context) {
    return DsSection(
      id: 'api',
      title: 'API',
      child: DsMeta(
        items: <DsMetaItem>[
          (
            k: 'AspectRatio',
            v: const TextSpan(
              text:
                  'ratio as a number. 5/7 collectible cards · 3/4 pack art · '
                  '16/9 banners.',
            ),
          ),
          (
            k: 'ScrollArea',
            v: const TextSpan(
              text:
                  'Set an explicit height (vertical) or width (horizontal). '
                  'Add ScrollBar for a horizontal bar.',
            ),
          ),
          (
            k: 'Carousel',
            v: const TextSpan(
              text:
                  'opts passes through to Embla. Control item width with '
                  'basis-* on CarouselItem.',
            ),
          ),
          (
            k: 'ResizablePanelGroup',
            v: const TextSpan(
              text:
                  'Horizontal by default; set orientation for a vertical '
                  'split. ResizableHandle withHandle draws a visible grip.',
            ),
          ),
          (
            k: 'scrollbar-thin',
            v: const TextSpan(
              text:
                  'Applies the global native-scrollbar treatment to a nested '
                  'overflow region. The html page scrollbar is styled '
                  'automatically.',
            ),
          ),
        ],
      ),
    );
  }
}

/* ── 7 · Rules ───────────────────────────────────────────────────────────── */

class _RulesSection extends StatelessWidget {
  const _RulesSection();

  @override
  Widget build(BuildContext context) {
    return const DsSection(
      id: 'rules',
      title: 'Rules',
      child: DsDoDont(
        dos: <String>[
          'Wrap every pack and card image in an AspectRatio so grids never '
              'jump.',
          'Keep carousel arrows visible and reachable by keyboard.',
          'Use 5:7 for collectible cards so scans match a physical card.',
          'Give a ScrollArea an explicit dimension on the axis it scrolls.',
          'Use native overflow for the page and lightweight rails; reserve '
              'ScrollArea for contained application panels.',
        ],
        donts: <String>[
          "Don't build a swipe-only carousel; it excludes keyboard and pointer "
              'users.',
          "Don't nest ScrollArea inside ScrollArea on the same axis.",
          "Don't let a pack image set its own height — the ratio is a system "
              'decision.',
          "Don't use Resizable in the collector-facing product.",
          "Don't hide a browser scrollbar when scrolling is the only way to "
              'reach content.',
        ],
      ),
    );
  }
}

/* ── Shared ──────────────────────────────────────────────────────────────── */

/// `divide-y divide-border` — a hairline **between** rows, drawn as a row of
/// its own so no child has to know it is not the first.
///
/// Deliberately not [DsDividedList]: that fills with `--card` and rounds
/// itself, and both of these lists declare no background at all.
class _SeamedColumn extends StatelessWidget {
  const _SeamedColumn({required this.colour, required this.children});

  final Color colour;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (int i = 0; i < children.length; i++) ...<Widget>[
          if (i > 0)
            SizedBox(
              height: DsWidths.hairline,
              child: ColoredBox(color: colour),
            ),
          children[i],
        ],
      ],
    );
  }
}
