/// `/design-system/components/base/data`: nine families on one page: table,
/// data table, badge, avatar, card, stat, item, marker, separator.
///
/// Everything here is live. The data table sorts on a real button, filters to a
/// real `Empty`, ticks real checkboxes and pages through eight rows four at a
/// time; the four figures under *"Loading, live"* go to skeletons for 1100ms
/// and swap back; the transaction rows light on hover; the navigating stat
/// squishes under a press.
///
/// ## Drift register: recorded, shipped as written
///
///  1. **The eyebrow says "Base" twice.** `` `${group.title} · Base` `` with
///     `group.title = "Base Components"`. All fourteen base pages.
///  2. **The payment list's gap is a button's, not a row's.** `ItemGroup`'s
///     `has-data-[size=sm]:gap-2.5` is meant to tighten when its *items* are
///     small; it compiles to `:has(*[data-size="sm"])`, and each row ends in a
///     `<Button size="sm">Manage</Button>` that matches it. *(Measured: `gap:
///     10px`, with every item reporting `data-size="default"`.)* Reproduced —
///     see [ItemGroup.gap].
///  3. **`duration-fast` is a no-op, twice on this page.** `item.tsx` line 45
///     and
///     the navigating stat's `Card` both write `transition-colors
///     duration-fast`; both compute **0.25s** with `cubic-bezier(0.22, 1,
///     0.36, 1)`, the stylesheet's default, because a `duration-` word is not
///     a utility Tailwind emits. Probed on this page.
///  4. **The navigating card's ring snaps while its fill travels.**
///     `group-hover:bg-accent group-hover:ring-action/45 transition-colors`
///     names two properties and `transition-colors` covers only one of them —
///     `box-shadow` is not in its list. *(Probed: the ring reaches
///     `action/45` on the first frame after `pointerover`; the background
///     takes the full 250ms.)* Reproduced as measured.
///  5. **The badge glyph trims never fire.** `has-data-[icon=inline-start]:
///     pl-1.5` waits for a `data-icon` attribute `Icon` does not write, so all
///     five glyph chips keep the full `px-2` *(measured)*.
///  6. **A table's last row pays half a pixel for a rule it does not draw.**
///     `border-collapse: collapse` splits the rule between its two rows, and
///     `[&_tr:last-child]:border-0` removes only the *bottom* half.
///     *(Measured on all three multi-row tables: 37 / 37 / 37 / 37 / **36.5**.)*
///     See [Table] for the whole model.
///  7. **`Stat`'s API list is one row longer than the component.** §API names
///     *"Badge variant: default · blue · premium …"*, `blue` is not one of the
///     cva's ten, and `link` is. The copy ships as written.
///  8. **The empty state's dashed border never paints.** `Empty` carries
///     `border-dashed` with no `border-*` width, so the filtered-to-nothing
///     panel is a bordered rectangle in prose only: the `Empty` family's
///     own recorded gap, reached here for the first time by a call site.
///  9. **The reload button's `disabled` is the only thing that stops a second
///     click.** `RELOAD_MS` is 1100 and the comment beside it says it is *"a
///     fake network wait, not a motion value"*: so it is not on the motion
///     scale and does not move with it. Ported as the literal it is.
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

import '../data_table_demo.dart';
import '../kit.dart';
import '../nav.dart';

/* ── Page constants ──────────────────────────────────────────────────────── */

/// `max-w-md`, `--container-md`, 28rem.
// allow-hardcoded: framework container scale with no token to read it from.
const double _measureMd = 448;

/// *"A fake network wait, not a motion value. The motion scale describes how
/// long a thing takes to move; this is how long a server takes to answer, and
/// the two are unrelated, `--duration-slow` is 400ms and no API is that
/// polite."*
const Duration _reloadWait = Duration(
  milliseconds: 1100,
); // allow-hardcoded: RELOAD_MS: a network
// wait, not a motion value; the source says so beside it.

/// `mt-5`: the caption under a specimen.
double get _captionGap => space(5);

/// `mt-6`: the wider caption gap, and the gap over a trailing Note.
double get _wideGap => space(6);

/// `mt-4`: between two panels.
double get _panelGap => space(4);

/// `space-y-6` in the marker panel, and `gap-8` in the stat grids.
double get _markerGap => space(6);

/// `filter: grayscale(1)`, in Flutter's vocabulary.
///
/// The Filter Effects luminance coefficients: the same numbers the browser
/// uses for `grayscale(1)`, which is a saturate matrix at amount 0.
// allow-hardcoded: the CSS Filter Effects grayscale matrix, quoted.
const ColorFilter _grayscale = ColorFilter.matrix(<double>[
  0.2126, 0.7152, 0.0722, 0, 0, //
  0.2126, 0.7152, 0.0722, 0, 0, //
  0.2126, 0.7152, 0.0722, 0, 0, //
  0, 0, 0, 1, 0, //
]);

/// `TX`: the five transaction rows, in the page's own order.
///
/// `dir` decides three things at once: the glyph, its tone, and whether the
/// amount takes the value ramp.
const List<
  ({String type, String detail, String amount, bool incoming, String status})
>
_tx =
    <
      ({
        String type,
        String detail,
        String amount,
        bool incoming,
        String status,
      })
    >[
      (
        type: 'Pack purchase',
        detail: 'Eclipse Vault × 3',
        amount: '−\$144.00',
        incoming: false,
        status: 'Completed',
      ),
      (
        type: 'Card sale',
        detail: 'Voidwing Ascendant',
        amount: '+\$1,240.00',
        incoming: true,
        status: 'Completed',
      ),
      (
        type: 'Deposit',
        detail: 'Visa ···· 6411',
        amount: '+\$250.00',
        incoming: true,
        status: 'Completed',
      ),
      (
        type: 'Withdrawal',
        detail: 'USDC · 0xA71c…4F2b',
        amount: '−\$800.00',
        incoming: false,
        status: 'Pending',
      ),
      (
        type: 'Reward',
        detail: 'Weekly leaderboard · 4th',
        amount: '+\$50.00',
        incoming: true,
        status: 'Completed',
      ),
    ];

/* ── Page ────────────────────────────────────────────────────────────────── */

class DataPage extends StatefulWidget {
  const DataPage({super.key});

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  /// *"The whole grid reloads together, ONE reveal rather than a stagger.
  /// Both are legal (§4); mixing them without deciding is what looks
  /// accidental."*
  StatState _live = StatState.ready;

  void _reload() {
    setState(() => _live = StatState.loading);
    Future<void>.delayed(_reloadWait, () {
      if (mounted) setState(() => _live = StatState.ready);
    });
  }

  @override
  Widget build(BuildContext context) {
    final CategoryHit here = findCategory('base', 'data');

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
        const Note(
          title: 'Charts are not on this page',
          child: _ChartsNoteBody(),
        ),
        // `className="mb-12"`.
        SizedBox(height: space(12)),
        const _TableSection(),
        const _DataTableSection(),
        const _BadgeSection(),
        const _AvatarSection(),
        const _CardSection(),
        _StatSection(live: _live, onReload: _reload),
        const _ItemSection(),
        const _MarkerSection(),
        const _SeparatorSection(),
        const _ApiSection(),
        const _RulesSection(),
        const PageFootNav(groupId: 'base', slug: 'data'),
      ],
    );
  }
}

/// The `<p className="type-small mt-N">` under a specimen.
class _Caption extends StatelessWidget {
  const _Caption(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(top: _captionGap),
    child: StyledText(text, TextStyles.small),
  );
}

/// The same, when the line carries an emphasis or a code chip.
class _RichCaption extends StatelessWidget {
  const _RichCaption(this.span, {this.gap});

  final InlineSpan span;
  final double? gap;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(top: gap ?? _captionGap),
    child: RichText(span, TextStyles.small),
  );
}

/// An `<em>` inside a `.type-small` line.
InlineSpan _em(String text) => TextSpan(
  text: text,
  style: const TextStyle(fontStyle: FontStyle.italic),
);

class _ChartsNoteBody extends StatelessWidget {
  const _ChartsNoteBody();

  @override
  Widget build(BuildContext context) => RichText(
    TextSpan(
      children: <InlineSpan>[
        Code.span('components/ui/chart.tsx'),
        const TextSpan(text: ' and the five '),
        Code.span('--chart-*'),
        const TextSpan(text: ' tokens have a page to themselves: '),
        Code.span('/design-system/components/base/charts'),
        const TextSpan(
          text:
              '. Every family is there: area, bar, line, pie, radar, '
              'radial: along with the one thing that could not live here, '
              'which is how a library that animates in JavaScript reads '
              'this system’s motion tokens instead of copying them.',
        ),
      ],
    ),
    TextStyles.small,
  );
}

/* ── §1 · table ──────────────────────────────────────────────────────────── */

class _TableSection extends StatelessWidget {
  const _TableSection();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    return Section(
      id: 'table',
      title: 'Table',
      description:
          'Transaction history and pull history. Every figure is '
          'right-aligned and tabular so the decimal points form a column the '
          'eye can scan.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Panel(
            label: 'Transaction history',
            flush: true,
            child: Table(
              caption: 'Showing the 5 most recent transactions of 248.',
              header: const <TableCellSpec>[
                TableCellSpec(child: Text('Type')),
                TableCellSpec(child: Text('Detail')),
                TableCellSpec(child: Text('Amount'), align: TableAlign.end),
                TableCellSpec(child: Text('Status'), align: TableAlign.end),
              ],
              rows: <TableRowSpec>[
                for (final ({
                      String type,
                      String detail,
                      String amount,
                      bool incoming,
                      String status,
                    })
                    row
                    in _tx)
                  TableRowSpec(
                    cells: <TableCellSpec>[
                      TableCellSpec(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon.lucide(
                              row.incoming
                                  ? Lucide.arrowDownLeft
                                  : Lucide.arrowUpRight,
                              size: IconSize.sm,
                              tone: row.incoming
                                  ? IconTone.success
                                  : IconTone.subtle,
                            ),
                            SizedBox(width: space(2)),
                            // Flexible so a narrow column can shrink the
                            // type word under 200% text instead of
                            // overflowing the cell.
                            Flexible(
                              child: StyledText(
                                row.type,
                                TextStyles.small,
                                color: theme.foreground,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TableCellSpec(
                        child: StyledText(
                          row.detail,
                          TextStyles.small,
                          color: theme.mutedForeground,
                        ),
                      ),
                      TableCellSpec(
                        align: TableAlign.end,
                        child: StyledText(
                          row.amount,
                          TextStyles.numberBase,
                          color: row.incoming
                              ? theme.premiumText
                              : theme.foreground,
                        ),
                      ),
                      TableCellSpec(
                        align: TableAlign.end,
                        child: Badge(
                          label: row.status,
                          variant: row.status == 'Pending'
                              ? BadgeVariant.warning
                              : BadgeVariant.success,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          // `className="mt-4"`.
          SizedBox(height: _panelGap),
          const Note(
            title: 'Money in versus money out',
            child: _MoneyNoteBody(),
          ),
        ],
      ),
    );
  }
}

class _MoneyNoteBody extends StatelessWidget {
  const _MoneyNoteBody();

  @override
  Widget build(BuildContext context) => RichText(
    TextSpan(
      children: <InlineSpan>[
        const TextSpan(
          text:
              'Direction is carried three ways at once: the sign on the '
              'number, the arrow glyph, and colour. Incoming takes the ',
        ),
        _em('value'),
        const TextSpan(
          text:
              ' ramp: money arriving is worth, which is what that ramp '
              'means: and outgoing is plain text. Never red for outgoing, '
              'because a purchase is not an error. Not ',
        ),
        Code.span('success'),
        const TextSpan(
          text:
              ' either: §1.5 keeps a completed sale from looking like a '
              'valuable one in the same row.',
        ),
      ],
    ),
    TextStyles.small,
  );
}

/* ── §2 · data table ─────────────────────────────────────────────────────── */

class _DataTableSection extends StatelessWidget {
  const _DataTableSection();

  @override
  Widget build(BuildContext context) => Section(
    id: 'data-table',
    title: 'Data Table',
    description:
        'Sorting, filtering, selection and pagination composed '
        'over the Table above. shadcn ships this as a recipe rather than a '
        'file, because the interesting part is always the column '
        'definitions: and those belong to whatever is being listed.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const Panel(
          label: 'Sort a column, filter, select rows, page through',
          child: DataTableDemo(),
        ),
        SizedBox(height: _wideGap),
        const Panel(
          label: 'Loading: skeleton rows on the real footprint',
          child: DataTableDemo(loading: true),
        ),
        SizedBox(height: _wideGap),
        const Note(
          tone: NoteTone.value,
          title: 'TanStack Table is pinned to v8, on purpose',
          child: _PinnedNoteBody(),
        ),
        SizedBox(height: _wideGap),
        const Note(
          tone: NoteTone.value,
          title: 'The two states a table demo always skips',
          child: _SkippedNoteBody(),
        ),
        SizedBox(height: _wideGap),
        Meta(
          items: <MetaItem>[
            (
              k: 'useReactTable',
              v: const TextSpan(
                text:
                    'The hook. Feed it data, columns and one get*RowModel '
                    'per feature you want: core, sorted, filtered, '
                    'paginated.',
              ),
            ),
            (
              k: 'flexRender',
              v: const TextSpan(
                text:
                    'Renders a header or cell definition, whether it is a '
                    'string, a component or a function.',
              ),
            ),
            (
              k: 'getRowId',
              v: const TextSpan(
                text:
                    'Give it a stable id from your data. Without it '
                    'selection is keyed by array index, and breaks the '
                    'moment anything sorts.',
              ),
            ),
            (
              k: 'state + on…Change',
              v: const TextSpan(
                text:
                    'Always a pair. A controlled slice handed in without '
                    'its writer is read once and then ignored: the filter '
                    'box types fine and never filters.',
              ),
            ),
            (
              k: 'aria-sort',
              v: const TextSpan(
                text:
                    'On the TableHead, not on the button. The trigger '
                    'inside it is a real <button> so sorting is reachable '
                    'by keyboard.',
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class _PinnedNoteBody extends StatelessWidget {
  const _PinnedNoteBody();

  @override
  Widget build(BuildContext context) => RichText(
    TextSpan(
      children: <InlineSpan>[
        const TextSpan(
          text:
              'Data Table is the one shadcn entry that is not a file you '
              'own: it is a recipe driving ',
        ),
        Code.span('@tanstack/react-table'),
        const TextSpan(
          text:
              ', a separate library on its own release schedule. That '
              'library has a v9 which is a full API rewrite, and under it '
              'not one line of shadcn’s published example compiles. So the '
              'dependency is pinned to v8: the version their docs are '
              'written against, which means the code on their site pastes '
              'in here and works. Treat the pin as load-bearing.',
        ),
      ],
    ),
    TextStyles.small,
  );
}

class _SkippedNoteBody extends StatelessWidget {
  const _SkippedNoteBody();

  @override
  Widget build(BuildContext context) => RichText(
    TextSpan(
      children: <InlineSpan>[
        const TextSpan(
          text:
              'Filter this table down to nothing and you '
              'get an ',
        ),
        Code.span('Empty'),
        const TextSpan(
          text:
              ' with a way back out, not a blank rectangle. The second '
              'panel is the loading state: skeleton rows carrying the same '
              'cell count, padding and height as real ones, so nothing '
              'moves when the data lands. A generic grey block here would '
              'be a layout jump, which is worse than the spinner it was '
              'meant to avoid.',
        ),
      ],
    ),
    TextStyles.small,
  );
}

/* ── §3 · badge ──────────────────────────────────────────────────────────── */

class _BadgeSection extends StatelessWidget {
  const _BadgeSection();

  @override
  Widget build(BuildContext context) => Section(
    id: 'badge',
    title: 'Badge',
    description:
        'Short status and category labels. Five semantic variants '
        'were added to the stock set so badges can carry the product’s own '
        'meanings.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const Panel(
          label: 'Variants',
          child: SpecimenRow(
            children: <Widget>[
              Badge(label: 'Default'),
              Badge(label: 'Selected', variant: BadgeVariant.action),
              Badge(label: 'Featured', variant: BadgeVariant.premium),
              Badge(label: '6 Cards', variant: BadgeVariant.secondary),
              Badge(label: 'Limited', variant: BadgeVariant.outline),
              Badge(label: 'Available', variant: BadgeVariant.success),
              Badge(label: 'Low supply', variant: BadgeVariant.warning),
              Badge(label: 'New set', variant: BadgeVariant.info),
              Badge(label: 'Sold out', variant: BadgeVariant.destructive),
              Badge(label: 'Draft', variant: BadgeVariant.ghost),
            ],
          ),
        ),
        SizedBox(height: _panelGap),
        Panel(
          label: 'With glyphs',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SpecimenRow(
                children: <Widget>[
                  Badge(
                    label: 'Featured',
                    variant: BadgeVariant.premium,
                    glyph: Icon.lucide(
                      Lucide.star,
                      size: IconSize.xs,
                      tone: IconTone.inherit,
                    ),
                  ),
                  Badge(
                    label: 'Hot',
                    variant: BadgeVariant.destructive,
                    glyph: Icon.lucide(
                      Lucide.flame,
                      size: IconSize.xs,
                      tone: IconTone.inherit,
                    ),
                  ),
                  Badge(
                    label: 'New',
                    variant: BadgeVariant.action,
                    glyph: Icon.lucide(
                      Lucide.zap,
                      size: IconSize.xs,
                      tone: IconTone.inherit,
                    ),
                  ),
                  Badge(
                    label: 'Legendary hit',
                    variant: BadgeVariant.premium,
                    glyph: Icon.lucide(
                      Lucide.crown,
                      size: IconSize.xs,
                      tone: IconTone.inherit,
                    ),
                  ),
                  Badge(
                    label: 'Verified',
                    variant: BadgeVariant.success,
                    glyph: Icon.lucide(
                      Lucide.shieldCheck,
                      size: IconSize.xs,
                      tone: IconTone.inherit,
                    ),
                  ),
                ],
              ),
              _RichCaption(
                TextSpan(
                  children: <InlineSpan>[
                    const TextSpan(text: 'Rank and tier badges are '),
                    _em('not'),
                    const TextSpan(
                      text:
                          ' here. Anything that carries product meaning, '
                          'a pip count, a scarcity step: belongs to the '
                          'product that means it, built on top of this '
                          'Badge rather than added to it.',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

/* ── §4 · avatar ─────────────────────────────────────────────────────────── */

class _AvatarSection extends StatelessWidget {
  const _AvatarSection();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    return Section(
      id: 'avatar',
      title: 'Avatar',
      description:
          'Collectors on live pulls and the leaderboard. Initials are '
          'the fallback, and the verified tick is an AvatarBadge rather than a '
          'separate element.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Panel(
            label: 'Sizes and states',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SpecimenRow(
                  align: SpecimenRowAlign.center,
                  children: <Widget>[
                    // `className="size-6"` with `.type-caption` on the
                    // fallback: the class beats the class, twice.
                    Avatar(
                      fallback: 'VW',
                      sizePx: space(6),
                      fallbackSpec: TextStyles.nav,
                    ),
                    Avatar(
                      fallback: 'VW',
                      sizePx: space(8),
                      fallbackSpec: TextStyles.nav,
                    ),
                    Avatar(fallback: 'VW', sizePx: space(10)),
                    Avatar(fallback: 'VW', sizePx: space(12)),
                    Avatar(
                      fallback: 'VW',
                      sizePx: space(10),
                      badge: AvatarBadge(fill: Palette.value),
                    ),
                    Avatar(
                      fallback: '#1',
                      sizePx: space(10),
                      // `ring-2 ring-value`, *"one of lime's permitted jobs."*
                      ring: (color: Palette.value, width: avatarRingWidth),
                      fallbackFill: Palette.value.withValues(alpha: _valueTint),
                      fallbackInk: theme.premiumText,
                    ),
                  ],
                ),
                const _Caption(
                  'The lime ring on the last avatar marks the leaderboard '
                  'leader: one of lime’s permitted jobs.',
                ),
              ],
            ),
          ),
          SizedBox(height: _panelGap),
          Panel(
            label: 'Avatar group: who opened this pack',
            child: Builder(
              builder: (BuildContext context) => AvatarGroup(
                children: <Widget>[
                  for (final String initials in <String>[
                    'VW',
                    'EM',
                    'TC',
                    'SW',
                  ])
                    Avatar(
                      fallback: initials,
                      sizePx: space(8),
                      fallbackSpec: TextStyles.nav,
                      ring: AvatarGroup.ringOf(context),
                    ),
                  const AvatarGroupCount('+248'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// `bg-value/12` on the leader's fallback.
const double _valueTint = 0.12;

/* ── §5 · card ───────────────────────────────────────────────────────────── */

class _CardSection extends StatelessWidget {
  const _CardSection();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    return Section(
      id: 'card',
      title: 'Card',
      description:
          'The generic container. A product builds its own richer '
          'cards on top of this one rather than forking it, so a token change '
          'still reaches them.',
      // `<div className="grid gap-4 md:grid-cols-2">`.
      child: Grid(
        md: 2,
        children: <Widget>[
          Panel(
            label: 'Card with action',
            child: Card(
              children: <Widget>[
                const CardHeader(
                  title: CardTitle('Weekly competition'),
                  description: CardDescription(
                    'Ends in 2 days, 14 hours. Top 100 collectors share the '
                    'pool.',
                  ),
                  action: Badge(label: 'Live', variant: BadgeVariant.premium),
                ),
                CardContent(
                  // `flex items-baseline justify-between`, as a `Wrap`: at
                  // 200% text `numberMd` alone can outgrow the card's own
                  // column width, so the label drops to its own line above
                  // the figure instead of the row overflowing past it.
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    runSpacing: space(1),
                    children: <Widget>[
                      StyledText('Prize pool', TextStyles.small),
                      StyledText(
                        r'$24,000.00',
                        TextStyles.numberMd,
                        color: theme.premiumText,
                      ),
                    ],
                  ),
                ),
                CardFooter(
                  child: Button(
                    expanded: true,
                    onPressed: () {},
                    child: const Text('View Leaderboard'),
                  ),
                ),
              ],
            ),
          ),
          Panel(
            label: 'Card with figures',
            child: Card(
              children: <Widget>[
                const CardHeader(
                  title: CardTitle('Your collection'),
                  description: CardDescription('Across 8 card sets.'),
                ),
                CardContent(
                  // `grid grid-cols-2 gap-5`.
                  child: Grid(
                    base: 2,
                    gap: space(5),
                    children: <Widget>[
                      for (final ({String k, String v}) figure
                          in const <({String k, String v})>[
                            (k: 'Total value', v: r'$12,480.65'),
                            (k: 'Cards owned', v: '1,284'),
                            (k: 'Packs opened', v: '412'),
                            (k: 'Best pull', v: r'$4,900.00'),
                          ])
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            StyledText(figure.k, TextStyles.small),
                            // `mt-1.5`.
                            SizedBox(height: space(1.5)),
                            StyledText(
                              figure.v,
                              TextStyles.numberMd,
                              color: theme.foreground,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/* ── §6 · stat ───────────────────────────────────────────────────────────── */

/// The three figures the Anatomy and colour-blindness panels repeat.
const StatDelta _up = (value: '8.2%', direction: StatDirection.up);
const StatDelta _refund = (value: '0.3%', direction: StatDirection.up);
const StatDelta _flat = (value: '0.0%', direction: StatDirection.flat);
const StatDelta _down = (value: '4.1%', direction: StatDirection.down);

class _StatSection extends StatelessWidget {
  const _StatSection({required this.live, required this.onReload});

  final StatState live;
  final VoidCallback onReload;

  static const Stat _revenue = Stat(
    label: 'Revenue',
    value: r'$12,480',
    delta: _up,
    hint: 'vs last month',
  );

  static const Stat _withdrawals = Stat(
    label: 'Withdrawals',
    value: r'$3,120',
    delta: _down,
    hint: 'vs last month',
  );

  static const Stat _packs = Stat(
    label: 'Packs opened',
    value: '412',
    delta: _flat,
    hint: 'vs last month',
  );

  @override
  Widget build(BuildContext context) => Section(
    id: 'stat',
    title: 'Stat',
    description:
        'A labelled figure, an optional delta against a previous '
        'period, and an optional trailing hint. It draws no container of '
        'its own, so it composes into a Card, a Panel, a table cell or a '
        'page header without a second surface appearing inside the first.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Panel(
          label: 'Anatomy',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Grid(
                sm: 3,
                gap: space(8),
                children: const <Widget>[
                  _revenue,
                  Stat(
                    label: 'Refund rate',
                    value: '1.4%',
                    delta: _refund,
                    betterWhen: StatDirection.down,
                    hint: 'vs last month',
                  ),
                  _packs,
                ],
              ),
              _RichCaption(
                TextSpan(
                  children: <InlineSpan>[
                    const TextSpan(text: 'The middle one is rising and is '),
                    _em('not'),
                    const TextSpan(
                      text:
                          ' good news. Refund rate, churn and latency all '
                          'improve by falling, so ',
                    ),
                    Code.span('betterWhen="down"'),
                    const TextSpan(
                      text:
                          ' flips which direction earns the green. '
                          'Without it a component that colours every '
                          'up-arrow green tells a lie by default.',
                    ),
                  ],
                ),
                gap: _wideGap,
              ),
            ],
          ),
        ),
        SizedBox(height: _panelGap),
        Panel(
          label: 'Direction survives colour blindness',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // `space-y-6`.
              Grid(
                sm: 3,
                gap: space(8),
                children: const <Widget>[_revenue, _withdrawals, _packs],
              ),
              SizedBox(height: _markerGap),
              const Separator(),
              SizedBox(height: _markerGap),
              ColorFiltered(
                colorFilter: _grayscale,
                child: Grid(
                  sm: 3,
                  gap: space(8),
                  children: const <Widget>[_revenue, _withdrawals, _packs],
                ),
              ),
              SizedBox(height: _wideGap),
              const Note(
                title: 'A coloured arrow is one signal',
                child: _OneSignalBody(),
              ),
            ],
          ),
        ),
        SizedBox(height: _panelGap),
        Panel(
          label:
              'The delta on its own, for a cell that already has a '
              'header',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const _DeltaCellTable(),
              _RichCaption(
                TextSpan(
                  children: <InlineSpan>[
                    const TextSpan(
                      text:
                          'A table gives its columns '
                          'headers, so a whole ',
                    ),
                    Code.span('Stat'),
                    const TextSpan(
                      text:
                          ' in a revenue cell would print “Revenue” once '
                          'per row under a heading that already says it. ',
                    ),
                    Code.span('StatDeltaMark'),
                    const TextSpan(text: ' is the same mark '),
                    Code.span('Stat'),
                    const TextSpan(
                      text:
                          ' draws, exported so the cell composes it '
                          'instead of redrawing an arrow and a sign of its '
                          'own: which would be a fork every guard here '
                          'stays green on. The two columns above move in '
                          'the ',
                    ),
                    _em('same'),
                    const TextSpan(
                      text: ' direction and only one of them is good news; ',
                    ),
                    Code.span('betterWhen'),
                    const TextSpan(
                      text:
                          ' is required rather than defaulted on the bare '
                          'mark, because a caller reaching past ',
                    ),
                    Code.span('Stat'),
                    const TextSpan(
                      text: ' for it is already thinking about direction.',
                    ),
                  ],
                ),
                gap: _wideGap,
              ),
            ],
          ),
        ),
        SizedBox(height: _panelGap),
        // `cols: 5` resolves to a 2-column base, which is right for a state
        // chip but too narrow for a Stat carrying an error message at 200%
        // text — `StateGrid.columns` keeps the same sm/lg breakpoints and
        // only widens the base column to one Stat per row.
        const StateGrid.columns(
          base: 1,
          sm: 3,
          lg: 5,
          children: <Widget>[
            StateCell(
              label: 'rest',
              note: 'the figure has landed',
              child: _revenue,
            ),
            StateCell(
              label: 'loading',
              note: 'skeleton, same footprint',
              child: Stat(
                label: 'Revenue',
                value: r'$12,480',
                delta: _up,
                hint: 'vs last month',
                state: StatState.loading,
              ),
            ),
            StateCell(
              label: 'error',
              note: 'what failed',
              child: Stat(
                label: 'Revenue',
                value: r'$12,480',
                delta: _up,
                state: StatState.error,
                message: 'Could not load',
              ),
            ),
            StateCell(
              label: 'empty',
              note: 'why there is nothing',
              child: Stat(
                label: 'Revenue',
                value: r'$12,480',
                delta: _up,
                state: StatState.empty,
                message: 'No sales this period',
              ),
            ),
            StateCell(
              label: 'disabled',
              note: 'opacity-45, aria-disabled',
              child: Stat(
                label: 'Revenue',
                value: r'$12,480',
                delta: _up,
                hint: 'vs last month',
                disabled: true,
              ),
            ),
          ],
        ),
        SizedBox(height: _panelGap),
        Panel(
          label: 'Loading, live',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Grid(
                sm: 4,
                gap: space(8),
                children: <Widget>[
                  Stat(
                    label: 'Revenue',
                    value: r'$12,480',
                    delta: _up,
                    hint: 'vs last month',
                    state: live,
                  ),
                  Stat(
                    label: 'Refund rate',
                    value: '1.4%',
                    delta: _refund,
                    betterWhen: StatDirection.down,
                    hint: 'vs last month',
                    state: live,
                  ),
                  Stat(
                    label: 'Packs opened',
                    value: '412',
                    delta: _flat,
                    hint: 'vs last month',
                    state: live,
                  ),
                  Stat(
                    label: 'Card sets',
                    value: '8',
                    hint: 'no comparison',
                    state: live,
                  ),
                ],
              ),
              // `<Row className="mt-8">`.
              SizedBox(height: space(8)),
              SpecimenRow(
                children: <Widget>[
                  Button(
                    variant: ButtonVariant.secondary,
                    onPressed: live == StatState.loading ? null : onReload,
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon.lucide(
                          Lucide.rotateCcw,
                          size: IconSize.md,
                          tone: IconTone.inherit,
                        ),
                        _ButtonGap(),
                        // Flexible so 200% text shrinks the label instead of
                        // overflowing the button's own row.
                        Flexible(
                          child: Text(
                            'Reload Figures',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              _RichCaption(
                TextSpan(
                  children: <InlineSpan>[
                    const TextSpan(
                      text:
                          'Only the figure and the delta are skeletons. '
                          'The label and the hint are chrome you already '
                          'know before the request returns, so they stay '
                          'real text: which is also what makes the '
                          'footprint provably identical in both states '
                          'rather than approximately so. The last stat has '
                          'no delta and reserves no delta line, in either '
                          'state. The swap is ',
                    ),
                    _em('one'),
                    const TextSpan(text: ' event: '),
                    Code.span('anim-content-change'),
                    const TextSpan(
                      text:
                          ' on the arriving figure, never a fade out '
                          'followed by a fade in.',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: _panelGap),
        Panel(
          label: 'When a stat navigates',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Grid(sm: 2, lg: 3, children: <Widget>[_NavigatingStat()]),
              _RichCaption(
                TextSpan(
                  children: <InlineSpan>[
                    const TextSpan(
                      text:
                          'A Stat is not a control and carries no hover, '
                          'focus or pressed state of its own: applying one '
                          'would promise an affordance that is not there. '
                          'When a figure navigates, the ',
                    ),
                    _em('wrapper'),
                    const TextSpan(
                      text:
                          ' is the control: it takes the surface change '
                          'on hover, the global focus ring, and ',
                    ),
                    Code.span('press-spring'),
                    const TextSpan(
                      text:
                          ' for the press. One transform '
                          'utility, not two, ',
                    ),
                    Code.span('lift'),
                    const TextSpan(text: ' and '),
                    Code.span('press-spring'),
                    const TextSpan(text: ' both write the whole '),
                    Code.span('transition'),
                    const TextSpan(
                      text:
                          ' shorthand, and §4 is explicit that which one '
                          'wins is not something to rely on.',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

/// `size="default"`'s `gap-2`.
class _ButtonGap extends StatelessWidget {
  const _ButtonGap();

  @override
  Widget build(BuildContext context) => SizedBox(width: space(2));
}

class _OneSignalBody extends StatelessWidget {
  const _OneSignalBody();

  @override
  Widget build(BuildContext context) => RichText(
    const TextSpan(
      text:
          'The lower row is the same markup with every hue removed, and '
          'it still reads. Direction is carried by the glyph’s shape, by '
          'the sign the component writes onto the number, and by a visually '
          'hidden word for assistive tech. Colour is the fourth signal, not '
          'the first: and it is never a red/green pair: the unfavourable '
          'direction is plain text, exactly as money leaving a wallet is '
          '(§1.4). Red means error, and a dip is not an error.',
    ),
    TextStyles.small,
  );
}

/// The one-row table under *"The delta on its own"*.
class _DeltaCellTable extends StatelessWidget {
  const _DeltaCellTable();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    Widget cell(String figure, StatDelta delta, StatDirection better) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        StyledText(figure, TextStyles.numberSm, color: theme.foreground),
        // `gap-0.5`.
        SizedBox(height: space(0.5)),
        StatDeltaMark(delta: delta, betterWhen: better),
      ],
    );

    return Table(
      header: const <TableCellSpec>[
        TableCellSpec(child: Text('Campaign')),
        TableCellSpec(child: Text('Revenue')),
        TableCellSpec(child: Text('Refund rate')),
      ],
      rows: <TableRowSpec>[
        TableRowSpec(
          cells: <TableCellSpec>[
            const TableCellSpec(child: Text('Stir in strength')),
            TableCellSpec(
              child: cell(r'$12,180', (
                value: '16%',
                direction: StatDirection.up,
              ), StatDirection.up),
            ),
            TableCellSpec(
              child: cell('1.4%', (
                value: '0.3%',
                direction: StatDirection.up,
              ), StatDirection.down),
            ),
          ],
        ),
      ],
    );
  }
}

/// The `<button className="group press-spring rounded-xl text-left">` wrapping
/// a `Card`, *"the wrapper is the control; the CONTAINER is still a Card."*
///
/// Drift 4 lives here: the fill travels 250ms and the ring does not.
class _NavigatingStat extends StatefulWidget {
  const _NavigatingStat();

  @override
  State<_NavigatingStat> createState() => _NavigatingStatState();
}

class _NavigatingStatState extends State<_NavigatingStat> {
  bool _hovered = false;

  /// `group-hover:ring-action/45`.
  static const double _hoverRingAlpha = 0.45;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Press(
        scale: MotionTransforms.pressSpringScale,
        upDuration: MotionDurations.pressSpringUp,
        onTap: () {},
        child: TweenAnimationBuilder<Color?>(
          // `transition-colors duration-fast`, DRIFT 3.
          duration: effectiveMotionDuration(context, MotionDurations.normal),
          curve: MotionCurves.enter,
          tween: ColorTween(end: _hovered ? theme.accent : theme.card),
          builder: (BuildContext context, Color? fill, Widget? child) => Card(
            fill: fill,
            // DRIFT 4: `box-shadow` is not in `transition-colors`' property
            // list, so the ring is a hard cut.
            ringColor: _hovered
                ? Palette.action.withValues(alpha: _hoverRingAlpha)
                : Card.ringOf(theme),
            children: <Widget>[child!],
          ),
          child: const CardContent(
            child: Stat(
              label: 'Revenue',
              value: r'$12,480',
              delta: _up,
              hint: 'vs last month',
            ),
          ),
        ),
      ),
    );
  }
}

/* ── §7 · item ───────────────────────────────────────────────────────────── */

class _ItemSection extends StatelessWidget {
  const _ItemSection();

  static const List<({String title, String desc, String badge})> _methods =
      <({String title, String desc, String badge})>[
        (
          title: 'Visa ···· 6411',
          desc: 'Expires 04/29 · Default',
          badge: 'Default',
        ),
        (title: 'Mastercard ···· 2087', desc: 'Expires 11/27', badge: ''),
        (title: 'USDC wallet', desc: '0xA71c…4F2b · Arbitrum', badge: ''),
      ];

  @override
  Widget build(BuildContext context) => Section(
    id: 'item',
    title: 'Item',
    description:
        'A structured list row: media, content, actions. Used for '
        'payment methods, shipment lines and settings rows.',
    child: Panel(
      label: 'Payment methods',
      flush: true,
      child: ItemGroup(
        children: <Widget>[
          for (final ({String title, String desc, String badge}) method
              in _methods)
            // The actions move INTO the content column on a narrow row.
            //
            // `Item` lays its slots out in a `Row`, and a `Row` hands a
            // non-flexible child an unbounded main axis, so nothing placed in
            // [Item.actions] can be told a width to wrap against. `Item` cannot
            // supply that bound without moving its own recorded geometry, which
            // `HistoryCard` pins. What a page CAN do is decide, at a width it
            // knows, that the row has no business being three columns wide: at
            // 480 and below the badge and the button stack under the text
            // instead of fighting it for the same line.
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final bool wide = constraints.maxWidth > Breakpoints.sm - 160;
                final List<Widget> actions = <Widget>[
                  if (method.badge.isNotEmpty)
                    Badge(label: method.badge, variant: BadgeVariant.action),
                  Button(
                    variant: ButtonVariant.ghost,
                    size: ButtonSize.sm,
                    onPressed: () {},
                    child: const Text('Manage'),
                  ),
                ];

                return Item(
                  media: const ItemMedia(
                    child: Icon.lucide(
                      Lucide.arrowUpRight,
                      size: IconSize.md,
                      tone: IconTone.subtle,
                    ),
                  ),
                  content: ItemContent(
                    children: <Widget>[
                      ItemTitle(method.title),
                      ItemDescription(method.desc),
                      if (!wide) ...<Widget>[
                        SizedBox(height: ItemActions.gap),
                        Wrap(
                          spacing: ItemActions.gap,
                          runSpacing: ItemActions.gap,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: actions,
                        ),
                      ],
                    ],
                  ),
                  actions: wide ? ItemActions(children: actions) : null,
                );
              },
            ),
        ],
      ),
    ),
  );
}

/* ── §8 · marker ─────────────────────────────────────────────────────────── */

class _MarkerSection extends StatelessWidget {
  const _MarkerSection();

  @override
  Widget build(BuildContext context) => Section(
    id: 'marker',
    title: 'Marker',
    description:
        'A note about a list, sitting in the list. Not a highlight '
        '— it draws no background and will not emphasise a matched '
        'substring. Reach for it when something happened between the rows '
        'around it.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Panel(
          label: 'Three variants',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Marker(
                icon: Icon.lucide(
                  Lucide.info,
                  size: IconSize.sm,
                  tone: IconTone.muted,
                ),
                label:
                    'default: bare row, for a container that already '
                    'frames it',
              ),
              SizedBox(height: _markerGap),
              const Marker(
                variant: MarkerVariant.separator,
                label: 'separator: divides before from after',
              ),
              SizedBox(height: _markerGap),
              const Marker(
                variant: MarkerVariant.border,
                label: 'border: heads what follows',
              ),
            ],
          ),
        ),
        SizedBox(height: _panelGap),
        Panel(
          label: 'In use: the agent console, where a stream was stopped',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              StyledText(
                'The assistant was mid-sentence and the user pressed stop. '
                'Without the marker this reads as a finished answer that '
                'trails off.',
                TextStyles.small,
              ),
              // `space-y-4`.
              SizedBox(height: _panelGap),
              const Marker(
                variant: MarkerVariant.separator,
                icon: Icon.lucide(
                  Lucide.square,
                  size: IconSize.sm,
                  tone: IconTone.muted,
                ),
                label: 'Stopped by you',
              ),
            ],
          ),
        ),
        SizedBox(height: _panelGap),
        const Note(
          tone: NoteTone.error,
          title: 'Not an Alert',
          child: _NotAnAlertBody(),
        ),
      ],
    ),
  );
}

class _NotAnAlertBody extends StatelessWidget {
  const _NotAnAlertBody();

  @override
  Widget build(BuildContext context) => RichText(
    TextSpan(
      children: <InlineSpan>[
        const TextSpan(
          text:
              'A marker reports; it never competes with what it '
              'annotates. If what you are marking is a ',
        ),
        _em('problem'),
        const TextSpan(text: ', that is an '),
        Code.span('Alert'),
        const TextSpan(
          text:
              ', §5’s table is explicit that a persistent condition '
              'worth explaining gets its own surface.',
        ),
      ],
    ),
    TextStyles.small,
  );
}

/* ── §9 · separator ──────────────────────────────────────────────────────── */

class _SeparatorSection extends StatelessWidget {
  const _SeparatorSection();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    Widget figure(String text) => Center(
      child: StyledText(
        text,
        TextStyles.numberSm,
        color: theme.mutedForeground,
      ),
    );

    return Section(
      id: 'separator',
      title: 'Separator',
      description:
          'A hairline. It uses the border token, so it holds up on '
          'every surface in the ladder without being restyled.',
      child: Panel(
        label: 'Horizontal and vertical',
        // `max-w-md` is a maximum, not a fixed width: a bare `SizedBox` here
        // enforced 448px regardless of the panel's own width, which is what
        // overflowed the figures row at 320px. `Align` turns the incoming
        // tight constraint loose again so `ConstrainedBox`'s `maxWidth` can
        // act as a cap instead of an exact width — the same reasoning
        // `feedback.dart`'s own `_measured` helper documents for the class.
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _measureMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                StyledText('Available balance', TextStyles.small),
                // `className="my-4"`.
                SizedBox(height: _panelGap),
                const Separator(),
                SizedBox(height: _panelGap),
                StyledText('Bonus balance', TextStyles.small),
                SizedBox(height: _panelGap),
                const Separator(),
                SizedBox(height: _panelGap),
                // The vertical rule needs a bounded cross axis (it is
                // `self-stretch` in the reference), which only a fixed-height
                // `Row` can give it; at 320px and 200% text three figures and
                // two rules no longer fit one line. `LayoutBuilder` keeps the
                // rule row exactly as built whenever it still fits, and falls
                // back to a `Wrap` of the figures alone — no vertical rule,
                // since `Wrap` cannot bound one — only when it does not.
                LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    final Widget ruled = SizedBox(
                      // `flex h-6 items-center gap-4`.
                      height: space(6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          figure('412 packs'),
                          SizedBox(width: _panelGap),
                          const Separator.vertical(),
                          SizedBox(width: _panelGap),
                          figure('1,284 cards'),
                          SizedBox(width: _panelGap),
                          const Separator.vertical(),
                          SizedBox(width: _panelGap),
                          figure('8 sets'),
                        ],
                      ),
                    );
                    // The 360 threshold alone is a viewport-width read; it
                    // missed that this column's own `_measureMd` cap (448)
                    // never grows, so at 200% text even a desktop-wide page
                    // still overflowed inside it. What three figures and two
                    // rules need scales with the text, not the viewport, so
                    // the threshold scales with `textScaler` too.
                    final double textScale = MediaQuery.textScalerOf(
                      context,
                    ).scale(1);
                    if (constraints.maxWidth >= 360 * textScale) return ruled;
                    return Wrap(
                      spacing: _panelGap,
                      runSpacing: space(2),
                      children: <Widget>[
                        figure('412 packs'),
                        figure('1,284 cards'),
                        figure('8 sets'),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/* ── §10 · api ───────────────────────────────────────────────────────────── */

class _ApiSection extends StatelessWidget {
  const _ApiSection();

  @override
  Widget build(BuildContext context) => Section(
    id: 'api',
    title: 'API',
    child: Meta(
      items: <MetaItem>[
        (
          // DRIFT 7: `blue` is not a variant and `link` is.
          k: 'Badge variant',
          v: const TextSpan(
            text:
                'default · blue · premium · secondary · outline · ghost · '
                'success · warning · info · destructive · link.',
          ),
        ),
        (
          k: 'Avatar',
          v: const TextSpan(
            text:
                'AvatarImage with AvatarFallback for initials. '
                'AvatarBadge for a status dot, AvatarGroup + '
                'AvatarGroupCount for stacks.',
          ),
        ),
        (
          k: 'Card',
          v: const TextSpan(
            text:
                'CardHeader + CardTitle + CardDescription + CardAction '
                '(top-right) + CardContent + CardFooter.',
          ),
        ),
        (
          k: 'Stat',
          v: const TextSpan(
            text:
                'label + value, plus optional delta, hint and message. '
                'Draws no container: put it in a Card, a Panel or a '
                'header.',
          ),
        ),
        (
          k: 'Stat delta',
          v: const TextSpan(
            text:
                '{ value: "8.2%", direction: "up" | "down" | "flat" }. '
                'Unsigned: the component writes the + or the −.',
          ),
        ),
        (
          k: 'Stat betterWhen',
          v: const TextSpan(
            text:
                '"up" (default) or "down". Which direction earns the '
                'favourable colour. Set it to down for churn, refunds and '
                'latency.',
          ),
        ),
        (
          k: 'Stat state',
          v: const TextSpan(
            text:
                'ready · loading · error · empty. Plus a separate '
                'disabled flag, which is orthogonal to all four.',
          ),
        ),
        (
          k: 'Item',
          v: const TextSpan(
            text:
                'ItemMedia + ItemContent (ItemTitle, ItemDescription) + '
                'ItemActions. Wrap in ItemGroup for a divided list.',
          ),
        ),
        (
          k: 'TableHead className="text-right"',
          v: const TextSpan(
            text:
                'Required on numeric columns; pair with type-num on the '
                'cell.',
          ),
        ),
      ],
    ),
  );
}

/* ── §11 · rules ─────────────────────────────────────────────────────────── */

class _RulesSection extends StatelessWidget {
  const _RulesSection();

  @override
  Widget build(BuildContext context) => const Section(
    id: 'rules',
    title: 'Rules',
    child: DoDont(
      dos: <String>[
        'Right-align numeric table columns and use the shared tabular '
            'type-num foundation.',
        'Show money direction with a sign, a glyph and colour together.',
        'Use initials as the avatar fallback: never a generic silhouette.',
        'Keep badges to one or two words.',
        'Say what a table is showing and out of how many, in the caption.',
        'Give a Stat’s delta a glyph and a sign, so it reads without '
            'colour.',
        'Say which direction is good: betterWhen="down" for churn and '
            'refunds.',
      ],
      donts: <String>[
        'Don’t colour an outgoing purchase red; red means error, not '
            'spending.',
        'Don’t colour a falling figure red either: a dip is not an error.',
        'Don’t put a border or a fill on a Stat; the container it sits in '
            'owns that.',
        'Don’t encode rank or tier in a base Badge: anything carrying '
            'pips belongs to the product, not the chassis.',
        'Don’t left-align a column of prices.',
        'Don’t use a Card where an Item row would be denser and clearer.',
      ],
    ),
  );
}
