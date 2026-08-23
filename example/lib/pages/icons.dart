/// `/design-system/icons`: the Icons foundation page.
///
/// The page's subject is the component the whole site is drawn with, so almost
/// every specimen here is the real thing: the ladder is seven live [DsIcon]s at
/// seven sizes, the tones grid is ten live glyphs resolving ten tokens, the
/// pairings are five live [DsButton]s, and the registry is all 63 curated
/// glyphs stroked from their own transcribed geometry. Nothing on it is a
/// picture of an icon.
///
/// **The one deliberate translation** (plan ruling I-Q1, surfaced for
/// sign-off). The `Usage` block in `#component` shows the **Dart** API where
/// the reference shows TSX: same line count bar one, same comment wording,
/// same em dashes, same two examples. A code sample is the single element on
/// this page whose job is to be executable by its reader, and every other
/// specimen here is live; a TSX snippet would be the only dead one. Two
/// consequences were accepted rather than worked around: the reference's
/// two-import head collapses to one, because Dart has a barrel and there is no
/// separate `lucide-react` to import (a filler line would have been an
/// invention); and `Heart` arrives with it, which quietly **fixes** the
/// reference's missing-import bug rather than reintroducing it: drift 5 below
/// is therefore the one drift on this page that does not ship.
///
/// **The vertical delta that translation costs, exactly.** One `.type-code`
/// line at `leading-relaxed` is `12.5 × 1.625` = **20.3125px**, and that is the
/// page's whole sanctioned divergence from the reference's measured geometry:
/// * `#component` is 20.3125px **shorter** than the web's 720.1px section;
/// * every section below it, `#sizes`, `#tones`, `#in-context`, `#set`,
///   `#rules`: starts 20.3125px **higher**, and each keeps the reference's own
///   height to the pixel;
/// * the reading column stacks to **5270.29px** against the web's 5290.6px at
///   the 1440 frame.
///
/// Nothing else on this page is allowed to differ. `icons_page_test.dart`'s
/// `vertical parity at the 1440 frame` group mounts the real `DocsShell` with
/// the reference's font binaries loaded and holds every section top and height
/// to ±0.5px of that oracle, so a regression names the section it broke.
///
/// Reference drifts, all shipped as written (icons-map §11):
/// 1. **Chips vs sections.** Six header chips: the last three naming Panels
///    inside `#set`: against six sections named something else, with
///    "Money & status", `#in-context` and `#rules` unchipped. The chips are
///    static `<li>` in the reference and scroll nowhere, so they port as data
///    (ruling I-Q4); inventing three sections to satisfy them would be a
///    divergence, not a fidelity gain.
/// 2. **`size="sm"` renders 16px** inside a button: see [_PairedButton].
/// 3. The `#in-context` description names *destructive* as "the one
///    exception", and the panel then ships a **value**-toned ghost button as
///    the exception instead. Both stand; see [_IconOnlyButton].
/// 4. **Don't #1 quotes the wrong thing**: `<Icon icon={Search} />` is the
///    component the rule tells you to use. It means `<Search />`.
/// 5. The reference's usage snippet imports `PackageOpen` and then uses
///    `Heart`. See the translation note above: this is the one that does not
///    ship.
/// 6. A [DsNote] title renders muted-foreground in **every** tone; the tone
///    shows only in the border and the wash. The header *eyebrow* is the
///    reverse case and does take action-ink. (Recorded once, in `kit.dart`.)
/// 7. `.type-code` declares no `font-weight`, so both the `<pre>` and the
///    inline chip render at 400: the only mono classes on the site that are
///    not 600. Carried by [DsCodeBlock].
/// 8. `leading-relaxed` (1.625) overrides `.type-code`'s 1.4 in the `<pre>`.
///    Also carried by [DsCodeBlock].
/// 9. **`subtle` and `muted` are the same colour.** The tones grid ships two
///    identical swatches on purpose: see [_TonesSection] (ruling I-Q6).
/// 10. Button labels are **13px**: `--text-sm` is aliased to `--text-small`.
///     Stated once, in `DsComponentType.buttonLabel`.
/// 11. Fonts: the prose says Space Grotesk, the tokens say Inter Local. Tokens
///     win, per the project's standing decision.
/// 12. Three curated names, `Filter`, `HelpCircle`, `AlertTriangle`: are
///     deprecated lucide aliases whose geometry lives in `funnel.mjs`,
///     `circle-question-mark.mjs` and `triangle-alert.mjs`. The enum keeps the
///     curated name (ruling I-Q2) because that is the string this page prints;
///     `icon_paths.dart` cites the real module.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../kit.dart';
import '../nav.dart';

/// Tailwind's `leading-snug` ratio, which `.type-small`'s own 1.5 loses to on
/// every `use` caption in `#tones` and `#set`. `globals.css` declares no
/// `--leading-*` token for it, so it cannot come from the foundation layer.
// allow-hardcoded: framework default with no token to read it from.
const double _leadingSnug = 1.375;

/// `size-9`: the plinth every 20px specimen glyph is mounted on.
final double _tileSize = ds(9);

/// `h-14`: the box the seven ladder glyphs share, so they hang from one
/// vertical midpoint.
final double _ladderBox = ds(14);

/* ── Page data ───────────────────────────────────────────────────────────── */

/// The `<pre>`'s contents, **the one deliberate translation on this page**.
///
/// Eight lines where the reference has nine, with blank lines at 2 and 6 and
/// the comment wording, the em dashes (U+2014) and the straight ASCII quotes
/// carried over unchanged. See the library doc comment for why it is Dart.
///
/// The last line is **104 characters**, half again the TSX block's longest at
/// 71. Measured rather than assumed (ruling I-Q8): at 12.5px Geist Mono that
/// is roughly 784px against a text box near 1000px, so like the reference's
/// TSX it does **not** actually scroll at the 1440 frame, [DsCodeBlock]'s
/// scroller ships because `overflow-x-auto scrollbar-thin` is in the class
/// list, and this is the sample that reaches the edge of a narrower column
/// where the TSX never would. `icons_page_test.dart` pins both halves.
const String _usage = '''
import 'package:elattar_design_system/elattar_design_system.dart';

// Decorative — adjacent text already says "Open Pack",
// so the glyph is hidden from screen readers.
const DsIcon(DsIconGlyph.packageOpen, size: DsIconSize.md, tone: DsIconTone.inherit)

// Meaningful — icon-only control, so it must be named.
const DsIcon(DsIconGlyph.heart, size: DsIconSize.lg, tone: DsIconTone.value, label: 'Add to favourites')''';

/// `sizeUse`: one line of §3's use list per rung of the ladder.
///
/// Keyed by the enum rather than by its printed key, so the ladder, the
/// specimen row and this list cannot drift apart.
const Map<DsIconSize, String> _sizeUse = <DsIconSize, String>{
  DsIconSize.xs: 'Pips and inline markers inside badges.',
  DsIconSize.sm: 'Beside 13px text. Inside badges and chips. Small buttons.',
  DsIconSize.md: 'The default. Inside standard buttons, rows, inputs.',
  DsIconSize.lg: 'Navigation items, large buttons, stat tiles.',
  DsIconSize.xl: 'Empty states, feature panels, section headers.',
  DsIconSize.xl2: 'Reveal moments, rarity glyphs on cards.',
  DsIconSize.xl3: 'Hero and error illustrations.',
};

/// The `size` prop's Meta value: the whole ladder, printed off the ladder.
///
/// The separators are U+00B7, matching the use list in `#sizes`, and the two
/// top rungs come out **`2xl`** and **`3xl`** through [DsIconSize.label]: the
/// enum spells them `xl2`/`xl3` because a Dart identifier cannot start with a
/// digit, and that rename must not reach rendered copy.
String get _sizeRow {
  final Iterable<String> rungs = DsIconSize.values.map(
    (DsIconSize size) => '${size.label} ${DsIcon.pxFor(size).toInt()}',
  );
  return '${rungs.join(' · ')}. Default md.';
}

/// `toneUse`, §4's copy, one line per tone.
///
/// The reference's own `toneUse` literal declares `error` before `info`; the
/// grid renders `Object.keys(ICON_TONES)` instead, so the declaration order
/// never reaches the screen. [DsIconTone.values] **is** that key order, which
/// is what the grid iterates.
const Map<DsIconTone, String> _toneUse = <DsIconTone, String>{
  DsIconTone.normal: 'Primary text weight.',
  DsIconTone.muted: 'Beside body copy. Most common.',
  DsIconTone.subtle: 'Metadata and decorative affordances.',
  DsIconTone.action: 'Interactive, selected, active.',
  DsIconTone.value: 'Reward, premium, ranking — worth.',
  DsIconTone.success: 'Confirmed, cleared, live, gained.',
  DsIconTone.warning: 'Pending, needs attention.',
  DsIconTone.info: 'Neutral notice, explainer.',
  DsIconTone.error: 'Failed, destructive.',
  DsIconTone.inherit: 'Takes the parent colour — the default inside buttons.',
};

/// One entry of `ICON_GROUPS`: the glyph, the name `icons.ts` whitelists it
/// under, and the single meaning it is pinned to.
typedef _Entry = ({DsIconGlyph glyph, String name, String use});

/// One of the four groups the curated set is filed in.
typedef _IconGroup = ({String title, String blurb, List<_Entry> icons});

/// `ICON_GROUPS`: the whitelist, in `icons.ts` order.
///
/// The order is load-bearing twice over: it is the reading order of §6, and it
/// is the order `test/icon_paths_test.dart`'s own `_curated` list asserts the
/// package against. Three of the names are lucide's deprecated aliases and are
/// printed as the whitelist spells them (ruling I-Q2): `Filter`, `HelpCircle`
/// and `AlertTriangle` draw `funnel`, `circle-question-mark` and
/// `triangle-alert`.
const List<_IconGroup> _groups = <_IconGroup>[
  (
    title: 'Navigation & structure',
    blurb:
        'Moving around the product. Directional glyphs only ever point the '
        'way they move.',
    icons: <_Entry>[
      (
        glyph: DsIconGlyph.package,
        name: 'Package',
        use: 'Packs — marketplace nav',
      ),
      (
        glyph: DsIconGlyph.radio,
        name: 'Radio',
        use: 'Live Pulls — nav, live state',
      ),
      (glyph: DsIconGlyph.layers, name: 'Layers', use: 'Stash — inventory nav'),
      (glyph: DsIconGlyph.gift, name: 'Gift', use: 'Rewards nav'),
      (glyph: DsIconGlyph.trophy, name: 'Trophy', use: 'Leaderboard nav'),
      (glyph: DsIconGlyph.wallet, name: 'Wallet', use: 'Wallet nav'),
      (
        glyph: DsIconGlyph.user,
        name: 'User',
        use: 'Account nav, avatar fallback',
      ),
      (
        glyph: DsIconGlyph.search,
        name: 'Search',
        use: 'Search input and trigger',
      ),
      (glyph: DsIconGlyph.bell, name: 'Bell', use: 'Notifications'),
      (glyph: DsIconGlyph.settings, name: 'Settings', use: 'Preferences'),
      (glyph: DsIconGlyph.logOut, name: 'LogOut', use: 'Sign out'),
      (
        glyph: DsIconGlyph.layoutGrid,
        name: 'LayoutGrid',
        use: 'Grid view toggle',
      ),
      (glyph: DsIconGlyph.rows3, name: 'Rows3', use: 'List view toggle'),
      (
        glyph: DsIconGlyph.chevronDown,
        name: 'ChevronDown',
        use: 'Disclosure, select',
      ),
      (glyph: DsIconGlyph.chevronUp, name: 'ChevronUp', use: 'Disclosure open'),
      (
        glyph: DsIconGlyph.chevronLeft,
        name: 'ChevronLeft',
        use: 'Carousel back',
      ),
      (
        glyph: DsIconGlyph.chevronRight,
        name: 'ChevronRight',
        use: 'Carousel forward, breadcrumb',
      ),
      (glyph: DsIconGlyph.arrowLeft, name: 'ArrowLeft', use: 'Back'),
      (
        glyph: DsIconGlyph.arrowRight,
        name: 'ArrowRight',
        use: 'Forward, see all',
      ),
      (glyph: DsIconGlyph.ellipsis, name: 'Ellipsis', use: 'Overflow menu'),
      (
        glyph: DsIconGlyph.externalLink,
        name: 'ExternalLink',
        use: 'Leaves the product',
      ),
    ],
  ),
  (
    title: 'Actions',
    blurb: 'Things the user does. Destructive actions use only Trash2 and Ban.',
    icons: <_Entry>[
      (
        glyph: DsIconGlyph.packageOpen,
        name: 'PackageOpen',
        use: 'Open Pack — the primary action',
      ),
      (
        glyph: DsIconGlyph.shoppingCart,
        name: 'ShoppingCart',
        use: 'Buy, add to cart',
      ),
      (glyph: DsIconGlyph.heart, name: 'Heart', use: 'Favourite'),
      (glyph: DsIconGlyph.eye, name: 'Eye', use: 'Inspect card, show password'),
      (glyph: DsIconGlyph.eyeOff, name: 'EyeOff', use: 'Hide password'),
      (glyph: DsIconGlyph.share2, name: 'Share2', use: 'Share pull'),
      (glyph: DsIconGlyph.copy, name: 'Copy', use: 'Copy referral or address'),
      (glyph: DsIconGlyph.filter, name: 'Filter', use: 'Filter drawer trigger'),
      (
        glyph: DsIconGlyph.slidersHorizontal,
        name: 'SlidersHorizontal',
        use: 'Sort and advanced filters',
      ),
      (
        glyph: DsIconGlyph.plus,
        name: 'Plus',
        use: 'Increase quantity, deposit',
      ),
      (glyph: DsIconGlyph.minus, name: 'Minus', use: 'Decrease quantity'),
      (
        glyph: DsIconGlyph.refreshCw,
        name: 'RefreshCw',
        use: 'Retry, refresh feed',
      ),
      (glyph: DsIconGlyph.download, name: 'Download', use: 'Withdraw, export'),
      (glyph: DsIconGlyph.upload, name: 'Upload', use: 'Deposit'),
      (glyph: DsIconGlyph.truck, name: 'Truck', use: 'Ship card'),
      (
        glyph: DsIconGlyph.trash2,
        name: 'Trash2',
        use: 'Delete — destructive only',
      ),
      (
        glyph: DsIconGlyph.ban,
        name: 'Ban',
        use: 'Cancel, blocked — destructive only',
      ),
      (glyph: DsIconGlyph.x, name: 'X', use: 'Close, dismiss, clear'),
      (glyph: DsIconGlyph.check, name: 'Check', use: 'Confirm, selected'),
    ],
  ),
  (
    title: 'Collectible domain',
    // One string with an internal em dash, and the shouted RARITY and NOT are
    // the reference's own. The file path inside it is plain text, not a `Code`
    // chip: it renders in `.type-small`, not mono.
    blurb:
        "The product's own vocabulary. Note that RARITY is NOT here — the "
        'eight tiers use their own drawn marks (circle, diamond, star) in '
        'components/pulls/rarity-symbol.tsx, never a Lucide glyph.',
    icons: <_Entry>[
      (
        glyph: DsIconGlyph.sparkles,
        name: 'Sparkles',
        use: 'Reveal and reward moments',
      ),
      (
        glyph: DsIconGlyph.crown,
        name: 'Crown',
        use: 'Leaderboard leader, top hit',
      ),
      (glyph: DsIconGlyph.flame, name: 'Flame', use: 'Hot pack badge'),
      (glyph: DsIconGlyph.zap, name: 'Zap', use: 'New, turbo open'),
      (glyph: DsIconGlyph.star, name: 'Star', use: 'Featured'),
      (glyph: DsIconGlyph.tag, name: 'Tag', use: 'Card set, category'),
      (glyph: DsIconGlyph.percent, name: 'Percent', use: 'Rarity odds'),
      (glyph: DsIconGlyph.medal, name: 'Medal', use: 'Rank badge'),
      (
        glyph: DsIconGlyph.activity,
        name: 'Activity',
        use: 'Popularity, volatility',
      ),
      (
        glyph: DsIconGlyph.trendingUp,
        name: 'TrendingUp',
        use: 'Rank up, value gain',
      ),
      (
        glyph: DsIconGlyph.trendingDown,
        name: 'TrendingDown',
        use: 'Rank down, value loss',
      ),
    ],
  ),
  (
    title: 'Money & status',
    blurb:
        'Wallet and state. Balance types are distinguished by glyph as well '
        'as by colour, so bonus never reads as real money.',
    icons: <_Entry>[
      (
        glyph: DsIconGlyph.circleDollarSign,
        name: 'CircleDollarSign',
        use: 'Available balance',
      ),
      (
        glyph: DsIconGlyph.creditCard,
        name: 'CreditCard',
        use: 'Payment method',
      ),
      (
        glyph: DsIconGlyph.arrowDownLeft,
        name: 'ArrowDownLeft',
        use: 'Money in — deposit, sale, refund',
      ),
      (
        glyph: DsIconGlyph.arrowUpRight,
        name: 'ArrowUpRight',
        use: 'Money out — purchase, withdrawal',
      ),
      (
        glyph: DsIconGlyph.hourglass,
        name: 'Hourglass',
        use: 'Pending balance, pending withdrawal',
      ),
      (
        glyph: DsIconGlyph.clock,
        name: 'Clock',
        use: 'Timestamp, time remaining',
      ),
      (
        glyph: DsIconGlyph.lock,
        name: 'Lock',
        use: 'Locked reward, security setting',
      ),
      (
        glyph: DsIconGlyph.shield,
        name: 'Shield',
        use: 'Security, provably fair',
      ),
      (
        glyph: DsIconGlyph.shieldCheck,
        name: 'ShieldCheck',
        use: 'Verified account',
      ),
      (glyph: DsIconGlyph.info, name: 'Info', use: 'Information state'),
      (
        glyph: DsIconGlyph.helpCircle,
        name: 'HelpCircle',
        use: 'Help, odds explainer',
      ),
      (
        glyph: DsIconGlyph.alertTriangle,
        name: 'AlertTriangle',
        use: 'Warning state',
      ),
    ],
  ),
];

/// `ICON_COUNT`, `ICON_GROUPS.reduce((n, g) => n + g.icons.length, 0)`.
///
/// A reduce in the reference and a fold here, deliberately: the section
/// heading counts the set it is standing over, so the two cannot fall out of
/// step the way a literal `63` would.
int get _iconCount =>
    _groups.fold(0, (int n, _IconGroup group) => n + group.icons.length);

/* ── Page ────────────────────────────────────────────────────────────────── */

class IconsPage extends StatelessWidget {
  const IconsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Every one of the four header props comes from the registry: this page
    // overrides none of them, unlike the colors page.
    final DsCategoryHit here = findCategory('foundations', 'icons');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DsPageHeader(
          eyebrow: here.group.title,
          title: here.category.title,
          blurb: here.category.blurb,
          contents: here.category.contents,
        ),
        const _ComponentSection(),
        const _SizesSection(),
        const _TonesSection(),
        const _InContextSection(),
        const _SetSection(),
        const _RulesSection(),
        // `icons` is index 5 of 6 in `foundations`: the last category, and the
        // only page in the system whose foot nav has an empty half. `siblings`
        // resolves `next` to null and the kit renders the bare `flex-1` spacer
        // beside the Previous card, which keeps that card at exactly half the
        // row rather than letting it stretch.
        const DsPageFootNav(groupId: 'foundations', slug: 'icons'),
      ],
    );
  }
}

/* ── #component ──────────────────────────────────────────────────────────── */

class _ComponentSection extends StatelessWidget {
  const _ComponentSection();

  @override
  Widget build(BuildContext context) {
    return DsSection(
      id: 'component',
      title: 'The Icon component',
      description:
          'Lucide is the source set, but it is never imported '
          'straight into a screen. Everything goes through one component, '
          'which forces a size, a tone and an accessibility decision on every '
          'instance.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const DsPanel(label: 'Usage', child: DsCodeBlock(_usage)),
          SizedBox(height: ds(4)),
          DsMeta(
            items: <DsMetaItem>[
              const (
                k: 'icon',
                v: TextSpan(text: 'A Lucide icon component. Required.'),
              ),
              (k: 'size', v: TextSpan(text: _sizeRow)),
              const (
                k: 'tone',
                v: TextSpan(
                  text:
                      'A token colour, or inherit. Default inherit, which is '
                      'correct inside buttons.',
                ),
              ),
              const (
                k: 'label',
                v: TextSpan(
                  text:
                      'Accessible name. Provide it when the icon carries '
                      'meaning alone; omit it and the icon is aria-hidden.',
                ),
              ),
            ],
          ),
          SizedBox(height: ds(4)),
          // The copy ships verbatim, and it is approximate rather than exact.
          // `strokeFor` is a three-rung snap (2.4 / 2 / 1.6), not a clamp, so
          // the rendered stroke still climbs 1.20 → 1.40 → 1.60 → 1.67 → 2.00
          // → 2.67 → 2.67 device px across the ladder: a 12px icon and a 40px
          // icon do not in fact carry the same optical weight. The port ships
          // the ternary, not the claim, `icon.dart:198` transcribes it and
          // `test/components_test.dart` pins all seven rungs.
          DsNote(
            title: 'Stroke scales with the box',
            child: DsText(
              'Lucide is drawn on a 24px grid for a 2px stroke. Rendered at '
              '12px that stroke reads twice as heavy, and at 40px it reads '
              'thin. The component compensates automatically, so a 12px icon '
              'and a 40px icon carry the same optical weight.',
              DsType.small,
            ),
          ),
        ],
      ),
    );
  }
}

/* ── #sizes ──────────────────────────────────────────────────────────────── */

class _SizesSection extends StatelessWidget {
  const _SizesSection();

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);

    return DsSection(
      id: 'sizes',
      title: 'Sizes',
      description:
          'Seven steps. Icons pair with text, so each size exists to '
          'sit beside a specific type class.',
      child: DsPanel(
        label: 'The ladder',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // `flex flex-wrap items-end gap-8`.
            Wrap(
              spacing: ds(8),
              runSpacing: ds(8),
              crossAxisAlignment: WrapCrossAlignment.end,
              children: <Widget>[
                for (final DsIconSize size in DsIconSize.values)
                  _LadderCell(size: size),
              ],
            ),
            // `mt-6 space-y-2 border-t border-border pt-5`.
            Container(
              margin: EdgeInsets.only(top: ds(6)),
              padding: EdgeInsets.only(top: ds(5)),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: theme.border,
                    width: DsWidths.hairline,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  for (
                    int i = 0;
                    i < DsIconSize.values.length;
                    i++
                  ) ...<Widget>[
                    if (i > 0) SizedBox(height: ds(2)),
                    _LadderUseLine(size: DsIconSize.values[i]),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// One specimen of the ladder: the glyph, its key, and its pixel size.
class _LadderCell extends StatelessWidget {
  const _LadderCell({required this.size});

  final DsIconSize size;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // `grid h-14 place-items-center`: every cell's box is the same 56px,
        // so the row's `items-end` bottom-aligns the *boxes* and the glyphs
        // hang from one common midpoint: the 40px one overhangs the 12px one
        // symmetrically rather than sitting on a shared baseline.
        //
        // `widthFactor: 1` is load-bearing. The CSS box is a block child of a
        // shrink-to-fit flex item, so it is as wide as the cell's widest line
        // and no wider. A bare [Center] takes `constraints.maxWidth` whenever
        // that is bounded: here the panel's full 1030px: which makes every
        // cell a full row of the [Wrap] and stacks the seven specimens
        // vertically. Shrink-wrapping keeps the row a row; the box paints
        // nothing, so its width is only ever a layout input.
        SizedBox(
          height: _ladderBox,
          child: Center(
            widthFactor: 1,
            child: DsIcon(
              DsIconGlyph.packageOpen,
              size: size,
              tone: DsIconTone.muted,
            ),
          ),
        ),
        SizedBox(height: ds(2)),
        // The **key**, not `.name`: `2xl` and `3xl`, which Dart spells `xl2`
        // and `xl3`.
        DsText(size.label, DsType.numSm, color: theme.actionInk),
        SizedBox(height: ds(1)),
        // `.type-micro` uppercases, which leaves digits and `px` untouched.
        DsText('${DsIcon.pxFor(size).toInt()}px', DsType.micro),
      ],
    );
  }
}

/// `<span class="type-num-sm text-muted-foreground">{key} · {px}px</span>` then
/// a literal space, then `— {use}`.
///
/// Two families and two sizes on one line, both landing on `--muted-foreground`
///: the mono span states that colour itself and `.type-small` brings its own.
/// Same colour, different face: that contrast *is* the treatment.
class _LadderUseLine extends StatelessWidget {
  const _LadderUseLine({required this.size});

  final DsIconSize size;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);

    return DsRichText(
      TextSpan(
        children: <InlineSpan>[
          TextSpan(
            text: '${size.label} · ${DsIcon.pxFor(size).toInt()}px',
            style: DsText.styleOf(
              context,
              DsType.numSm,
              color: theme.mutedForeground,
            ),
          ),
          TextSpan(text: ' — ${_sizeUse[size]!}'),
        ],
      ),
      DsType.small,
    );
  }
}

/* ── #tones ──────────────────────────────────────────────────────────────── */

class _TonesSection extends StatelessWidget {
  const _TonesSection();

  @override
  Widget build(BuildContext context) {
    return DsSection(
      id: 'tones',
      title: 'Tones',
      description:
          'Icons never carry a raw hex. Every tone maps to a token, '
          'which keeps icon colour inside the 70/20/10 balance automatically.',
      child: DsPanel(
        label: 'Ten tones',
        // `grid gap-x-8 gap-y-5 sm:grid-cols-2 lg:grid-cols-3`: ten cells in
        // a 3×4 grid at the desktop frame, with two empty cells on the last
        // row.
        child: _Grid(
          sm: 2,
          lg: 3,
          gapX: ds(8),
          gapY: ds(5),
          children: <Widget>[
            // Two things this grid reproduces rather than tidies. `muted` and
            // `subtle` are the **same colour** (ruling I-Q6): `subtle` is a
            // separate *intent*, not a separate token, and `icon.dart` keeps
            // the name so the two can diverge later without a rename at every
            // call site: so cells 2 and 3 are identical swatches on purpose.
            // And `inherit` renders as plain `--foreground`, because nothing
            // here sets a text colour on the panel body, so `text-current`
            // resolves to what `<body>` set.
            for (final DsIconTone tone in DsIconTone.values)
              _ToneCell(tone: tone),
          ],
        ),
      ),
    );
  }
}

class _ToneCell extends StatelessWidget {
  const _ToneCell({required this.tone});

  final DsIconTone tone;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);

    return Row(
      children: <Widget>[
        _GlyphTile(glyph: DsIconGlyph.search, tone: tone),
        SizedBox(width: ds(3)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // The **key**: `default`, which Dart spells `normal`.
              DsText(tone.label, DsType.numSm, color: theme.actionInk),
              _UseCopy(_toneUse[tone]!),
            ],
          ),
        ),
      ],
    );
  }
}

/* ── #in-context ─────────────────────────────────────────────────────────── */

class _InContextSection extends StatelessWidget {
  const _InContextSection();

  @override
  Widget build(BuildContext context) {
    return DsSection(
      id: 'in-context',
      title: 'Icons in controls',
      description:
          "Inside a button an icon should inherit the button's "
          'colour, not assert its own. The one exception is a destructive '
          'action, where the error tone is the point.',
      child: DsPanel(
        label: 'Correct pairings',
        // `flex flex-wrap gap-3`.
        child: Wrap(
          spacing: ds(3),
          runSpacing: ds(3),
          children: <Widget>[
            _PairedButton(
              variant: DsButtonVariant.primary,
              glyph: DsIconGlyph.packageOpen,
              label: 'Open Pack',
            ),
            _PairedButton(
              variant: DsButtonVariant.secondary,
              glyph: DsIconGlyph.heart,
              label: 'Favourite',
            ),
            _PairedButton(
              variant: DsButtonVariant.outline,
              glyph: DsIconGlyph.search,
              label: 'Search',
            ),
            _PairedButton(
              variant: DsButtonVariant.destructive,
              glyph: DsIconGlyph.trash2,
              label: 'Remove',
            ),
            const _IconOnlyButton(),
          ],
        ),
      ),
    );
  }
}

/// One of the four labelled pairings.
///
/// **The size override, written out** (ruling I-Q3). All four of these ask for
/// `size="sm"` in the reference and render **16px**: `Icon` emits `width`/
/// `height` *attributes* and a class list that never contains the substring
/// `size-`, so the button base's
/// `[&_svg:not([class*='size-'])]:size-4` matches, and a CSS rule beats an SVG
/// presentation attribute. `strokeWidth` is not CSS, so it keeps the value
/// computed for 14px, 2.4: and `strokeFor(16)` is also 2.4, so the two
/// coincide and no stroke drift is visible. [DsIcon.sizePx] is therefore not
/// needed here; 16px is written directly and the override is recorded in this
/// comment.
class _PairedButton extends StatelessWidget {
  const _PairedButton({
    required this.variant,
    required this.glyph,
    required this.label,
  });

  final DsButtonVariant variant;
  final DsIconGlyph glyph;
  final String label;

  @override
  Widget build(BuildContext context) {
    return DsButton(
      variant: variant,
      // Live, and deliberately inert: these are specimens on a docs page, and
      // a null callback would disable them down to `opacity-45`.
      onPressed: () {},
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          DsIcon(glyph, size: DsIconSize.md, tone: DsIconTone.inherit),
          // `gap-2` on the `default` size, asked of the component rather than
          // restated.
          SizedBox(width: DsButton.gapFor(DsButtonSize.md)),
          // A bare text node inside the button, exactly as
          // `<Button>…Open Pack</Button>` is: it inherits the button's own
          // `text-sm font-medium` and its animated ink from the
          // `DefaultTextStyle` the component installs.
          Text(label),
        ],
      ),
    );
  }
}

/// Button 5, `variant="ghost" size="icon"`, a 40px square with no fill at
/// rest.
///
/// The section's own thesis, stated twice. The accessible name lives on the
/// **control**, not on the glyph: matching the `label` row in `#component`'s
/// Meta: so the icon carries no label and is hidden from assistive tech while
/// the button announces "Add to favourites". And `tone="value"` is the panel's
/// deliberate exception to "inherit inside buttons", even though the section
/// description names *destructive* as "the one exception" and the destructive
/// button above inherits like the rest (drift 3).
///
/// `size="icon"` sets only `size-10` and adds no SVG override, so unlike the
/// four labelled buttons this glyph's own `size="md"` is what renders: the
/// same 16px, reached the other way.
class _IconOnlyButton extends StatelessWidget {
  const _IconOnlyButton();

  @override
  Widget build(BuildContext context) {
    return DsButton(
      variant: DsButtonVariant.ghost,
      size: DsButtonSize.icon,
      label: 'Add to favourites',
      onPressed: () {},
      child: const DsIcon(
        DsIconGlyph.heart,
        size: DsIconSize.md,
        tone: DsIconTone.value,
      ),
    );
  }
}

/* ── #set ────────────────────────────────────────────────────────────────── */

class _SetSection extends StatelessWidget {
  const _SetSection();

  @override
  Widget build(BuildContext context) {
    return DsSection(
      id: 'set',
      title: 'The curated set — $_iconCount glyphs',
      description:
          'Lucide ships well over a thousand icons; shipping all of '
          'them guarantees inconsistency. These are the ones the product uses, '
          'each pinned to one meaning so the same glyph never means two '
          'different things.',
      // `space-y-4`: four panels, 16px apart.
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          for (int i = 0; i < _groups.length; i++) ...<Widget>[
            if (i > 0) SizedBox(height: ds(4)),
            _GroupPanel(group: _groups[i]),
          ],
        ],
      ),
    );
  }
}

class _GroupPanel extends StatelessWidget {
  const _GroupPanel({required this.group});

  final _IconGroup group;

  @override
  Widget build(BuildContext context) {
    return DsPanel(
      label: group.title,
      note: '${group.icons.length} glyphs',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // `p.type-small.mb-6`.
          DsText(group.blurb, DsType.small),
          SizedBox(height: ds(6)),
          // `grid gap-px … sm:grid-cols-2 lg:grid-cols-3`: the kit's lattice
          // with this page's own column map, which is none of `StateGrid`'s
          // five. The frame is shared; the map is not.
          DsStateGrid.columns(
            sm: 2,
            lg: 3,
            children: <Widget>[
              for (final _Entry entry in group.icons) _EntryCell(entry: entry),
            ],
          ),
        ],
      ),
    );
  }
}

/// `div.flex.items-center.gap-3.bg-background.p-4`.
///
/// The tile itself is the kit's [DsStateCell]; what is page-local is what
/// stands in it: a glyph beside its name and its single meaning, where the
/// kit's own cell holds a demo well over a label.
class _EntryCell extends StatelessWidget {
  const _EntryCell({required this.entry});

  final _Entry entry;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);

    return DsStateCell.bare(
      padding: EdgeInsets.all(ds(4)),
      child: Row(
        children: <Widget>[
          _GlyphTile(glyph: entry.glyph, tone: DsIconTone.muted),
          SizedBox(width: ds(3)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // `truncate`: and by arithmetic it never fires: the longest
                // name, `SlidersHorizontal`, is 17 characters of 12px mono in
                // a text column of roughly 208px at the 1440 frame. It is
                // transcribed anyway, because the reference declares it and a
                // narrower column is exactly where it would start to matter.
                DsText(
                  entry.name,
                  DsType.numSm,
                  color: theme.foreground,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                _UseCopy(entry.use),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/* ── #rules ──────────────────────────────────────────────────────────────── */

class _RulesSection extends StatelessWidget {
  const _RulesSection();

  @override
  Widget build(BuildContext context) {
    return DsSection(
      id: 'rules',
      title: 'Rules',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const DsDoDont(
            dos: <String>[
              'Import Lucide glyphs through the Icon component so size, tone '
                  'and labelling are enforced.',
              'Give every icon-only control a label — it becomes the '
                  'accessible name.',
              // The escaped quotes in the source render as literal straight
              // ASCII `"`.
              'Use tone="inherit" inside buttons so the icon follows the '
                  "button's state.",
              'Keep one meaning per glyph: Package is always a pack, Layers is '
                  'always the Stash.',
            ],
            donts: <String>[
              // DRIFT 4, kept: the rule means the raw lucide element,
              // `<Search />`, but it typed `<Icon icon={Search} />`: which is
              // the component it tells you to use. The angle brackets are
              // literal text inside a JS string, so they render as visible
              // characters rather than as markup.
              "Don't render a raw <Icon icon={Search} /> from lucide-react in "
                  'a screen; go through Icon.',
              "Don't mix icon sets — Lucide only, no Heroicons, no Font "
                  'Awesome, no emoji as UI.',
              "Don't label a decorative icon; doubling the adjacent text makes "
                  'screen readers repeat it.',
              "Don't reuse Trash2 or Ban for anything non-destructive.",
            ],
          ),
          SizedBox(height: ds(4)),
          // Default tone, therefore `action`, and **no title**: so the whole
          // note is one `.type-small text-muted-foreground` line carrying an
          // inline `Code` chip.
          DsNote(
            child: DsRichText(
              TextSpan(
                children: <InlineSpan>[
                  const TextSpan(text: 'The set is defined in '),
                  DsCode.span('lib/ds/icons.ts'),
                  const TextSpan(
                    text:
                        '. Adding a glyph means adding it there with its '
                        'single meaning — that file is the whitelist.',
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

/* ── Shared ──────────────────────────────────────────────────────────────── */

/// `span.grid.size-9.shrink-0.place-items-center.rounded-md.border.border-border
/// .bg-card`: the 36px plinth a 20px glyph is mounted on.
///
/// Shared by `#tones` and all four `#set` grids, which is why `radius-md` is
/// **10px** here and not the 12 the surrounding cards use: the tile is the
/// smallest surface on the page and sits one rung down the ladder.
class _GlyphTile extends StatelessWidget {
  const _GlyphTile({required this.glyph, required this.tone});

  final DsIconGlyph glyph;
  final DsIconTone tone;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);

    return Container(
      width: _tileSize,
      height: _tileSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(DsRadii.md),
        border: Border.all(color: theme.border, width: DsWidths.hairline),
      ),
      // 20px, stroke 2.0: the one rung of the ladder where `48/px` lands in
      // the ternary's middle branch and the authored stroke survives.
      child: DsIcon(glyph, size: DsIconSize.lg, tone: tone),
    );
  }
}

/// `type-small leading-snug`: the caption beside a glyph.
///
/// The only place on this page a `.type-*` class is overridden, and it is
/// overridden in exactly one property: the leading tightens so a two-line
/// caption stays a caption.
class _UseCopy extends StatelessWidget {
  const _UseCopy(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final TextStyle style = DsText.styleOf(
      context,
      DsType.small,
    ).copyWith(height: _leadingSnug);
    // Not a `.type-*` class any more, so it cannot go through [DsText]: but
    // the line box still has to be the one CSS lays out.
    return DsLineBox(
      style: style,
      child: Text(text, style: style),
    );
  }
}

/// [DsGrid] with the two axes' gaps stated separately.
///
/// The kit's own grid takes one `gap`, which is right for the `gap-4` and
/// `gap-6` grids every other page uses. Both grids on this page need two:
/// `gap-x-8 gap-y-5` in `#tones`, and `gap-px` in `#set`, where the gutters
/// are the hairlines themselves and there is no divider to draw.
///
/// Rows stretch to their tallest cell, which is what a CSS grid row does: and
/// here it is what lets a `bg-background` cell fill its slot so the lattice
/// shows only in the gutters.
class _Grid extends StatelessWidget {
  const _Grid({
    required this.children,
    this.sm,
    this.lg,
    required this.gapX,
    required this.gapY,
  });

  final List<Widget> children;
  final int? sm;
  final int? lg;
  final double gapX;
  final double gapY;

  /// Both grids on this page are `grid-cols-1` until `sm:`, which is what a
  /// bare `grid` with no column template is: so the base is stated here
  /// rather than passed.
  static const int _base = 1;

  int _columns(double viewport) {
    int columns = _base;
    if (sm != null && viewport >= DsBreakpoints.sm) columns = sm!;
    if (lg != null && viewport >= DsBreakpoints.lg) columns = lg!;
    return columns;
  }

  @override
  Widget build(BuildContext context) {
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
          if (r > 0) SizedBox(height: gapY),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                for (int c = 0; c < columns; c++) ...<Widget>[
                  if (c > 0) SizedBox(width: gapX),
                  Expanded(
                    child: c < rows[r].length
                        ? rows[r][c]
                        // A trailing slot of a short last row. Empty, so the
                        // row's cells keep their column width: and in the
                        // hairline grid, so the field shows through exactly as
                        // an empty CSS grid cell does.
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
