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
///     see [ElItemGroup.gap].
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
///     See [ElTable] for the whole model.
///  7. **`Stat`'s API list is one row longer than the component.** §API names
///     *"Badge variant: default · blue · premium …"*, `blue` is not one of the
///     cva's ten, and `link` is. The copy ships as written.
///  8. **The empty state's dashed border never paints.** `Empty` carries
///     `border-dashed` with no `border-*` width, so the filtered-to-nothing
///     panel is a bordered rectangle in prose only: the `ElEmpty` family's
///     own recorded gap, reached here for the first time by a call site.
///  9. **The reload button's `disabled` is the only thing that stops a second
///     click.** `RELOAD_MS` is 1100 and the comment beside it says it is *"a
///     fake network wait, not a motion value"*: so it is not on the motion
///     scale and does not move with it. Ported as the literal it is.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

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
double get _captionGap => el(5);

/// `mt-6`: the wider caption gap, and the gap over a trailing Note.
double get _wideGap => el(6);

/// `mt-4`: between two panels.
double get _panelGap => el(4);

/// `space-y-6` in the marker panel, and `gap-8` in the stat grids.
double get _markerGap => el(6);

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
  ElStatState _live = ElStatState.ready;

  void _reload() {
    setState(() => _live = ElStatState.loading);
    Future<void>.delayed(_reloadWait, () {
      if (mounted) setState(() => _live = ElStatState.ready);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ElCategoryHit here = findCategory('base', 'data');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ElPageHeader(
          // DRIFT 1.
          eyebrow: '${here.group.title} · Base',
          title: here.category.title,
          blurb: here.category.blurb,
          contents: here.category.contents,
        ),
        const ElNote(
          title: 'Charts are not on this page',
          child: _ChartsNoteBody(),
        ),
        // `className="mb-12"`.
        SizedBox(height: el(12)),
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
        const ElPageFootNav(groupId: 'base', slug: 'data'),
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
    child: ElText(text, ElType.small),
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
    child: ElRichText(span, ElType.small),
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
  Widget build(BuildContext context) => ElRichText(
    TextSpan(
      children: <InlineSpan>[
        ElCode.span('components/ui/chart.tsx'),
        const TextSpan(text: ' and the five '),
        ElCode.span('--chart-*'),
        const TextSpan(text: ' tokens have a page to themselves: '),
        ElCode.span('/design-system/components/base/charts'),
        const TextSpan(
          text:
              '. Every family is there: area, bar, line, pie, radar, '
              'radial: along with the one thing that could not live here, '
              'which is how a library that animates in JavaScript reads '
              'this system’s motion tokens instead of copying them.',
        ),
      ],
    ),
    ElType.small,
  );
}

/* ── §1 · table ──────────────────────────────────────────────────────────── */

class _TableSection extends StatelessWidget {
  const _TableSection();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);

    return ElSection(
      id: 'table',
      title: 'Table',
      description:
          'Transaction history and pull history. Every figure is '
          'right-aligned and tabular so the decimal points form a column the '
          'eye can scan.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ElPanel(
            label: 'Transaction history',
            flush: true,
            child: ElTable(
              caption: 'Showing the 5 most recent transactions of 248.',
              header: const <ElTableCellSpec>[
                ElTableCellSpec(child: Text('Type')),
                ElTableCellSpec(child: Text('Detail')),
                ElTableCellSpec(child: Text('Amount'), align: ElTableAlign.end),
                ElTableCellSpec(child: Text('Status'), align: ElTableAlign.end),
              ],
              rows: <ElTableRowSpec>[
                for (final ({
                      String type,
                      String detail,
                      String amount,
                      bool incoming,
                      String status,
                    })
                    row
                    in _tx)
                  ElTableRowSpec(
                    cells: <ElTableCellSpec>[
                      ElTableCellSpec(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ElIcon.lucide(
                              row.incoming
                                  ? ElLucide.arrowDownLeft
                                  : ElLucide.arrowUpRight,
                              size: ElIconSize.sm,
                              tone: row.incoming
                                  ? ElIconTone.success
                                  : ElIconTone.subtle,
                            ),
                            SizedBox(width: el(2)),
                            ElText(
                              row.type,
                              ElComponentType.textSm,
                              color: theme.foreground,
                            ),
                          ],
                        ),
                      ),
                      ElTableCellSpec(
                        child: ElText(
                          row.detail,
                          ElComponentType.textSm,
                          color: theme.mutedForeground,
                        ),
                      ),
                      ElTableCellSpec(
                        align: ElTableAlign.end,
                        child: ElText(
                          row.amount,
                          ElType.numBase,
                          color: row.incoming
                              ? theme.valueInk
                              : theme.foreground,
                        ),
                      ),
                      ElTableCellSpec(
                        align: ElTableAlign.end,
                        child: ElBadge(
                          label: row.status,
                          variant: row.status == 'Pending'
                              ? ElBadgeVariant.warning
                              : ElBadgeVariant.success,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          // `className="mt-4"`.
          SizedBox(height: _panelGap),
          const ElNote(
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
  Widget build(BuildContext context) => ElRichText(
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
        ElCode.span('success'),
        const TextSpan(
          text:
              ' either: §1.5 keeps a completed sale from looking like a '
              'valuable one in the same row.',
        ),
      ],
    ),
    ElType.small,
  );
}

/* ── §2 · data table ─────────────────────────────────────────────────────── */

class _DataTableSection extends StatelessWidget {
  const _DataTableSection();

  @override
  Widget build(BuildContext context) => ElSection(
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
        const ElPanel(
          label: 'Sort a column, filter, select rows, page through',
          child: DataTableDemo(),
        ),
        SizedBox(height: _wideGap),
        const ElPanel(
          label: 'Loading: skeleton rows on the real footprint',
          child: DataTableDemo(loading: true),
        ),
        SizedBox(height: _wideGap),
        const ElNote(
          tone: ElNoteTone.value,
          title: 'TanStack Table is pinned to v8, on purpose',
          child: _PinnedNoteBody(),
        ),
        SizedBox(height: _wideGap),
        const ElNote(
          tone: ElNoteTone.value,
          title: 'The two states a table demo always skips',
          child: _SkippedNoteBody(),
        ),
        SizedBox(height: _wideGap),
        ElMeta(
          items: <ElMetaItem>[
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
  Widget build(BuildContext context) => ElRichText(
    TextSpan(
      children: <InlineSpan>[
        const TextSpan(
          text:
              'Data Table is the one shadcn entry that is not a file you '
              'own: it is a recipe driving ',
        ),
        ElCode.span('@tanstack/react-table'),
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
    ElType.small,
  );
}

class _SkippedNoteBody extends StatelessWidget {
  const _SkippedNoteBody();

  @override
  Widget build(BuildContext context) => ElRichText(
    TextSpan(
      children: <InlineSpan>[
        const TextSpan(
          text:
              'Filter this table down to nothing and you '
              'get an ',
        ),
        ElCode.span('Empty'),
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
    ElType.small,
  );
}

/* ── §3 · badge ──────────────────────────────────────────────────────────── */

class _BadgeSection extends StatelessWidget {
  const _BadgeSection();

  @override
  Widget build(BuildContext context) => ElSection(
    id: 'badge',
    title: 'Badge',
    description:
        'Short status and category labels. Five semantic variants '
        'were added to the stock set so badges can carry the product’s own '
        'meanings.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const ElPanel(
          label: 'Variants',
          child: ElRow(
            children: <Widget>[
              ElBadge(label: 'Default'),
              ElBadge(label: 'Selected', variant: ElBadgeVariant.action),
              ElBadge(label: 'Featured', variant: ElBadgeVariant.premium),
              ElBadge(label: '6 Cards', variant: ElBadgeVariant.secondary),
              ElBadge(label: 'Limited', variant: ElBadgeVariant.outline),
              ElBadge(label: 'Available', variant: ElBadgeVariant.success),
              ElBadge(label: 'Low supply', variant: ElBadgeVariant.warning),
              ElBadge(label: 'New set', variant: ElBadgeVariant.info),
              ElBadge(label: 'Sold out', variant: ElBadgeVariant.destructive),
              ElBadge(label: 'Draft', variant: ElBadgeVariant.ghost),
            ],
          ),
        ),
        SizedBox(height: _panelGap),
        ElPanel(
          label: 'With glyphs',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const ElRow(
                children: <Widget>[
                  ElBadge(
                    label: 'Featured',
                    variant: ElBadgeVariant.premium,
                    glyph: ElIcon.lucide(
                      ElLucide.star,
                      size: ElIconSize.xs,
                      tone: ElIconTone.inherit,
                    ),
                  ),
                  ElBadge(
                    label: 'Hot',
                    variant: ElBadgeVariant.destructive,
                    glyph: ElIcon.lucide(
                      ElLucide.flame,
                      size: ElIconSize.xs,
                      tone: ElIconTone.inherit,
                    ),
                  ),
                  ElBadge(
                    label: 'New',
                    variant: ElBadgeVariant.action,
                    glyph: ElIcon.lucide(
                      ElLucide.zap,
                      size: ElIconSize.xs,
                      tone: ElIconTone.inherit,
                    ),
                  ),
                  ElBadge(
                    label: 'Legendary hit',
                    variant: ElBadgeVariant.premium,
                    glyph: ElIcon.lucide(
                      ElLucide.crown,
                      size: ElIconSize.xs,
                      tone: ElIconTone.inherit,
                    ),
                  ),
                  ElBadge(
                    label: 'Verified',
                    variant: ElBadgeVariant.success,
                    glyph: ElIcon.lucide(
                      ElLucide.shieldCheck,
                      size: ElIconSize.xs,
                      tone: ElIconTone.inherit,
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
    final ElThemeData theme = ElTheme.of(context);

    return ElSection(
      id: 'avatar',
      title: 'Avatar',
      description:
          'Collectors on live pulls and the leaderboard. Initials are '
          'the fallback, and the verified tick is an AvatarBadge rather than a '
          'separate element.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ElPanel(
            label: 'Sizes and states',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                ElRow(
                  align: ElRowAlign.center,
                  children: <Widget>[
                    // `className="size-6"` with `.type-caption` on the
                    // fallback: the class beats the class, twice.
                    ElAvatar(
                      fallback: 'VW',
                      sizePx: el(6),
                      fallbackSpec: ElComponentType.avatarInitials,
                    ),
                    ElAvatar(
                      fallback: 'VW',
                      sizePx: el(8),
                      fallbackSpec: ElComponentType.avatarFallback,
                    ),
                    ElAvatar(fallback: 'VW', sizePx: el(10)),
                    ElAvatar(fallback: 'VW', sizePx: el(12)),
                    ElAvatar(
                      fallback: 'VW',
                      sizePx: el(10),
                      badge: ElAvatarBadge(fill: ElPalette.value),
                    ),
                    ElAvatar(
                      fallback: '#1',
                      sizePx: el(10),
                      // `ring-2 ring-value`, *"one of lime's permitted jobs."*
                      ring: (color: ElPalette.value, width: elAvatarRingWidth),
                      fallbackFill: ElPalette.value.withValues(
                        alpha: _valueTint,
                      ),
                      fallbackInk: theme.valueInk,
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
          ElPanel(
            label: 'Avatar group: who opened this pack',
            child: Builder(
              builder: (BuildContext context) => ElAvatarGroup(
                children: <Widget>[
                  for (final String initials in <String>[
                    'VW',
                    'EM',
                    'TC',
                    'SW',
                  ])
                    ElAvatar(
                      fallback: initials,
                      sizePx: el(8),
                      fallbackSpec: ElComponentType.avatarFallback,
                      ring: ElAvatarGroup.ringOf(context),
                    ),
                  const ElAvatarGroupCount('+248'),
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
    final ElThemeData theme = ElTheme.of(context);

    return ElSection(
      id: 'card',
      title: 'Card',
      description:
          'The generic container. A product builds its own richer '
          'cards on top of this one rather than forking it, so a token change '
          'still reaches them.',
      // `<div className="grid gap-4 md:grid-cols-2">`.
      child: ElGrid(
        md: 2,
        children: <Widget>[
          ElPanel(
            label: 'Card with action',
            child: ElCard(
              children: <Widget>[
                const ElCardHeader(
                  title: ElCardTitle('Weekly competition'),
                  description: ElCardDescription(
                    'Ends in 2 days, 14 hours. Top 100 collectors share the '
                    'pool.',
                  ),
                  action: ElBadge(
                    label: 'Live',
                    variant: ElBadgeVariant.premium,
                  ),
                ),
                ElCardContent(
                  // `flex items-baseline justify-between`.
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      ElText('Prize pool', ElType.label),
                      ElText(
                        r'$24,000.00',
                        ElType.numMd,
                        color: theme.valueInk,
                      ),
                    ],
                  ),
                ),
                ElCardFooter(
                  child: ElButton(
                    expanded: true,
                    onPressed: () {},
                    child: const Text('View Leaderboard'),
                  ),
                ),
              ],
            ),
          ),
          ElPanel(
            label: 'Card with figures',
            child: ElCard(
              children: <Widget>[
                const ElCardHeader(
                  title: ElCardTitle('Your collection'),
                  description: ElCardDescription('Across 8 card sets.'),
                ),
                ElCardContent(
                  // `grid grid-cols-2 gap-5`.
                  child: ElGrid(
                    base: 2,
                    gap: el(5),
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
                            ElText(figure.k, ElType.label),
                            // `mt-1.5`.
                            SizedBox(height: el(1.5)),
                            ElText(
                              figure.v,
                              ElType.numMd,
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
const ElStatDelta _up = (value: '8.2%', direction: ElStatDirection.up);
const ElStatDelta _refund = (value: '0.3%', direction: ElStatDirection.up);
const ElStatDelta _flat = (value: '0.0%', direction: ElStatDirection.flat);
const ElStatDelta _down = (value: '4.1%', direction: ElStatDirection.down);

class _StatSection extends StatelessWidget {
  const _StatSection({required this.live, required this.onReload});

  final ElStatState live;
  final VoidCallback onReload;

  static const ElStat _revenue = ElStat(
    label: 'Revenue',
    value: r'$12,480',
    delta: _up,
    hint: 'vs last month',
  );

  static const ElStat _withdrawals = ElStat(
    label: 'Withdrawals',
    value: r'$3,120',
    delta: _down,
    hint: 'vs last month',
  );

  static const ElStat _packs = ElStat(
    label: 'Packs opened',
    value: '412',
    delta: _flat,
    hint: 'vs last month',
  );

  @override
  Widget build(BuildContext context) => ElSection(
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
        ElPanel(
          label: 'Anatomy',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ElGrid(
                sm: 3,
                gap: el(8),
                children: const <Widget>[
                  _revenue,
                  ElStat(
                    label: 'Refund rate',
                    value: '1.4%',
                    delta: _refund,
                    betterWhen: ElStatDirection.down,
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
                    ElCode.span('betterWhen="down"'),
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
        ElPanel(
          label: 'Direction survives colour blindness',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // `space-y-6`.
              ElGrid(
                sm: 3,
                gap: el(8),
                children: const <Widget>[_revenue, _withdrawals, _packs],
              ),
              SizedBox(height: _markerGap),
              const ElSeparator(),
              SizedBox(height: _markerGap),
              ColorFiltered(
                colorFilter: _grayscale,
                child: ElGrid(
                  sm: 3,
                  gap: el(8),
                  children: const <Widget>[_revenue, _withdrawals, _packs],
                ),
              ),
              SizedBox(height: _wideGap),
              const ElNote(
                title: 'A coloured arrow is one signal',
                child: _OneSignalBody(),
              ),
            ],
          ),
        ),
        SizedBox(height: _panelGap),
        ElPanel(
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
                    ElCode.span('Stat'),
                    const TextSpan(
                      text:
                          ' in a revenue cell would print “Revenue” once '
                          'per row under a heading that already says it. ',
                    ),
                    ElCode.span('StatDeltaMark'),
                    const TextSpan(text: ' is the same mark '),
                    ElCode.span('Stat'),
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
                    ElCode.span('betterWhen'),
                    const TextSpan(
                      text:
                          ' is required rather than defaulted on the bare '
                          'mark, because a caller reaching past ',
                    ),
                    ElCode.span('Stat'),
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
        const ElStateGrid(
          cols: 5,
          children: <Widget>[
            ElStateCell(
              label: 'rest',
              note: 'the figure has landed',
              child: _revenue,
            ),
            ElStateCell(
              label: 'loading',
              note: 'skeleton, same footprint',
              child: ElStat(
                label: 'Revenue',
                value: r'$12,480',
                delta: _up,
                hint: 'vs last month',
                state: ElStatState.loading,
              ),
            ),
            ElStateCell(
              label: 'error',
              note: 'what failed',
              child: ElStat(
                label: 'Revenue',
                value: r'$12,480',
                delta: _up,
                state: ElStatState.error,
                message: 'Could not load',
              ),
            ),
            ElStateCell(
              label: 'empty',
              note: 'why there is nothing',
              child: ElStat(
                label: 'Revenue',
                value: r'$12,480',
                delta: _up,
                state: ElStatState.empty,
                message: 'No sales this period',
              ),
            ),
            ElStateCell(
              label: 'disabled',
              note: 'opacity-45, aria-disabled',
              child: ElStat(
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
        ElPanel(
          label: 'Loading, live',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ElGrid(
                sm: 4,
                gap: el(8),
                children: <Widget>[
                  ElStat(
                    label: 'Revenue',
                    value: r'$12,480',
                    delta: _up,
                    hint: 'vs last month',
                    state: live,
                  ),
                  ElStat(
                    label: 'Refund rate',
                    value: '1.4%',
                    delta: _refund,
                    betterWhen: ElStatDirection.down,
                    hint: 'vs last month',
                    state: live,
                  ),
                  ElStat(
                    label: 'Packs opened',
                    value: '412',
                    delta: _flat,
                    hint: 'vs last month',
                    state: live,
                  ),
                  ElStat(
                    label: 'Card sets',
                    value: '8',
                    hint: 'no comparison',
                    state: live,
                  ),
                ],
              ),
              // `<Row className="mt-8">`.
              SizedBox(height: el(8)),
              ElRow(
                children: <Widget>[
                  ElButton(
                    variant: ElButtonVariant.secondary,
                    onPressed: live == ElStatState.loading ? null : onReload,
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ElIcon.lucide(
                          ElLucide.rotateCcw,
                          size: ElIconSize.md,
                          tone: ElIconTone.inherit,
                        ),
                        _ButtonGap(),
                        Text('Reload Figures'),
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
                    ElCode.span('anim-swap-in'),
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
        ElPanel(
          label: 'When a stat navigates',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const ElGrid(sm: 2, lg: 3, children: <Widget>[_NavigatingStat()]),
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
                    ElCode.span('press-spring'),
                    const TextSpan(
                      text:
                          ' for the press. One transform '
                          'utility, not two, ',
                    ),
                    ElCode.span('lift'),
                    const TextSpan(text: ' and '),
                    ElCode.span('press-spring'),
                    const TextSpan(text: ' both write the whole '),
                    ElCode.span('transition'),
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
  Widget build(BuildContext context) => SizedBox(width: el(2));
}

class _OneSignalBody extends StatelessWidget {
  const _OneSignalBody();

  @override
  Widget build(BuildContext context) => ElRichText(
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
    ElType.small,
  );
}

/// The one-row table under *"The delta on its own"*.
class _DeltaCellTable extends StatelessWidget {
  const _DeltaCellTable();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);

    Widget cell(String figure, ElStatDelta delta, ElStatDirection better) =>
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ElText(figure, ElType.numSm, color: theme.foreground),
            // `gap-0.5`.
            SizedBox(height: el(0.5)),
            ElStatDeltaMark(delta: delta, betterWhen: better),
          ],
        );

    return ElTable(
      header: const <ElTableCellSpec>[
        ElTableCellSpec(child: Text('Campaign')),
        ElTableCellSpec(child: Text('Revenue')),
        ElTableCellSpec(child: Text('Refund rate')),
      ],
      rows: <ElTableRowSpec>[
        ElTableRowSpec(
          cells: <ElTableCellSpec>[
            const ElTableCellSpec(child: Text('Stir in strength')),
            ElTableCellSpec(
              child: cell(r'$12,180', (
                value: '16%',
                direction: ElStatDirection.up,
              ), ElStatDirection.up),
            ),
            ElTableCellSpec(
              child: cell('1.4%', (
                value: '0.3%',
                direction: ElStatDirection.up,
              ), ElStatDirection.down),
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
    final ElThemeData theme = ElTheme.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: ElPress(
        scale: ElTransforms.pressSpringScale,
        upDuration: ElDurations.pressSpringUp,
        onTap: () {},
        child: TweenAnimationBuilder<Color?>(
          // `transition-colors duration-fast`, DRIFT 3.
          duration: elAnimationDuration(context, ElDurations.transitionDefault),
          curve: ElCurves.out,
          tween: ColorTween(end: _hovered ? theme.accent : theme.card),
          builder: (BuildContext context, Color? fill, Widget? child) => ElCard(
            fill: fill,
            // DRIFT 4: `box-shadow` is not in `transition-colors`' property
            // list, so the ring is a hard cut.
            ringColor: _hovered
                ? ElPalette.action.withValues(alpha: _hoverRingAlpha)
                : ElCard.ringOf(theme),
            children: <Widget>[child!],
          ),
          child: const ElCardContent(
            child: ElStat(
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
  Widget build(BuildContext context) => ElSection(
    id: 'item',
    title: 'Item',
    description:
        'A structured list row: media, content, actions. Used for '
        'payment methods, shipment lines and settings rows.',
    child: ElPanel(
      label: 'Payment methods',
      flush: true,
      child: ElItemGroup(
        children: <Widget>[
          for (final ({String title, String desc, String badge}) method
              in _methods)
            ElItem(
              media: const ElItemMedia(
                child: ElIcon.lucide(
                  ElLucide.arrowUpRight,
                  size: ElIconSize.md,
                  tone: ElIconTone.subtle,
                ),
              ),
              content: ElItemContent(
                children: <Widget>[
                  ElItemTitle(method.title),
                  ElItemDescription(method.desc),
                ],
              ),
              actions: ElItemActions(
                children: <Widget>[
                  if (method.badge.isNotEmpty)
                    ElBadge(
                      label: method.badge,
                      variant: ElBadgeVariant.action,
                    ),
                  ElButton(
                    variant: ElButtonVariant.ghost,
                    size: ElButtonSize.sm,
                    onPressed: () {},
                    child: const Text('Manage'),
                  ),
                ],
              ),
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
  Widget build(BuildContext context) => ElSection(
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
        ElPanel(
          label: 'Three variants',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const ElMarker(
                icon: ElIcon.lucide(
                  ElLucide.info,
                  size: ElIconSize.sm,
                  tone: ElIconTone.muted,
                ),
                label:
                    'default: bare row, for a container that already '
                    'frames it',
              ),
              SizedBox(height: _markerGap),
              const ElMarker(
                variant: ElMarkerVariant.separator,
                label: 'separator: divides before from after',
              ),
              SizedBox(height: _markerGap),
              const ElMarker(
                variant: ElMarkerVariant.border,
                label: 'border: heads what follows',
              ),
            ],
          ),
        ),
        SizedBox(height: _panelGap),
        ElPanel(
          label: 'In use: the agent console, where a stream was stopped',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ElText(
                'The assistant was mid-sentence and the user pressed stop. '
                'Without the marker this reads as a finished answer that '
                'trails off.',
                ElType.small,
              ),
              // `space-y-4`.
              SizedBox(height: _panelGap),
              const ElMarker(
                variant: ElMarkerVariant.separator,
                icon: ElIcon.lucide(
                  ElLucide.square,
                  size: ElIconSize.sm,
                  tone: ElIconTone.muted,
                ),
                label: 'Stopped by you',
              ),
            ],
          ),
        ),
        SizedBox(height: _panelGap),
        const ElNote(
          tone: ElNoteTone.error,
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
  Widget build(BuildContext context) => ElRichText(
    TextSpan(
      children: <InlineSpan>[
        const TextSpan(
          text:
              'A marker reports; it never competes with what it '
              'annotates. If what you are marking is a ',
        ),
        _em('problem'),
        const TextSpan(text: ', that is an '),
        ElCode.span('Alert'),
        const TextSpan(
          text:
              ', §5’s table is explicit that a persistent condition '
              'worth explaining gets its own surface.',
        ),
      ],
    ),
    ElType.small,
  );
}

/* ── §9 · separator ──────────────────────────────────────────────────────── */

class _SeparatorSection extends StatelessWidget {
  const _SeparatorSection();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);

    Widget figure(String text) =>
        Center(child: ElText(text, ElType.numSm, color: theme.mutedForeground));

    return ElSection(
      id: 'separator',
      title: 'Separator',
      description:
          'A hairline. It uses the border token, so it holds up on '
          'every surface in the ladder without being restyled.',
      child: ElPanel(
        label: 'Horizontal and vertical',
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: SizedBox(
            // `max-w-md`.
            width: _measureMd,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ElText('Available balance', ElType.small),
                // `className="my-4"`.
                SizedBox(height: _panelGap),
                const ElSeparator(),
                SizedBox(height: _panelGap),
                ElText('Bonus balance', ElType.small),
                SizedBox(height: _panelGap),
                const ElSeparator(),
                SizedBox(height: _panelGap),
                SizedBox(
                  // `flex h-6 items-center gap-4`.
                  height: el(6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      figure('412 packs'),
                      SizedBox(width: _panelGap),
                      const ElSeparator.vertical(),
                      SizedBox(width: _panelGap),
                      figure('1,284 cards'),
                      SizedBox(width: _panelGap),
                      const ElSeparator.vertical(),
                      SizedBox(width: _panelGap),
                      figure('8 sets'),
                    ],
                  ),
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
  Widget build(BuildContext context) => ElSection(
    id: 'api',
    title: 'API',
    child: ElMeta(
      items: <ElMetaItem>[
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
  Widget build(BuildContext context) => const ElSection(
    id: 'rules',
    title: 'Rules',
    child: ElDoDont(
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
