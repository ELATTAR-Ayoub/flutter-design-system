/// `/design-system/components/base/navigation`: six components, nine
/// sections, and one indicator that points at the wrong thing.
///
/// The page opens by ruling out the thing the rest of the system is built on:
/// *"Every active navigation state in the product is a controlled blue mark —
/// a 2px underline, a left border, or a tinted pill. Navigation items never
/// glow."* Nothing on this page carries a `sheen`, a `foil` or a `bloom`, and
/// that is the point of it.
///
/// ## The fidelity bar is that it moves
///
/// Three tab sets travel, three navigation menus open on hover and swap panels
/// between triggers, a chevron rotates, an accordion unfolds while its sibling
/// folds, and a collapsible pushes the rest of its panel down. A port that
/// renders these as stills fails, however exact the pixels.
///
/// ## Drift register: recorded, shipped as written
///
///  1. **The navigation-menu indicator never travels.** Radix positions it from
///     the active trigger's `offsetLeft`, and `NavigationMenuItem` carries
///     `relative`, so every trigger reports **0**. Probed: opening *Packs*
///     writes `left: 0px; width: 93px`, opening *Marketplace*, 96.89px further
///     along: writes `left: 0px; width: 134px`. Only the width follows. The
///     caret sits over the list's left edge under a panel labelled *"the caret
///     that names the open trigger"*. Carried by `navigation_menu.dart`.
///  2. **`origin-top-center` is not a Tailwind utility**, so the viewport zooms
///     from its own centre. Measured `transform-origin: 288px 89px` on a
///     576 × 178 panel.
///  3. **The whole `**:data-[slot=accordion-trigger-icon]:*` block is dead** —
///     `Icon` never forwards `data-slot`, so `ml-auto`, `size-4` and
///     `text-muted-foreground` all match nothing. The first two survive by
///     accident (`justify-between`, and `Icon`'s own 16px default); the colour
///     does not, and the chevrons render `--foreground`. Carried by
///     `accordion.dart`.
///  4. **`data-icon="inline-start"` on the pagination chevrons is doubly
///     dead**: not forwarded by `Icon`, and the only `[data-icon]` rules in
///     globals.css are scoped under `.cn-toast`. Carried by `pagination.dart`.
///  5. **`text-nav` is not `.type-nav`.** The navigation-menu triggers wear the
///     utility (13.5px / **1.5** = 20.25) and the top-nav buttons the component
///     class (13.5px / **1.2** = 16.2). Both measured on this page, three
///     sections apart. Carried by [DsComponentType.navMenuTrigger].
///  6. **The top-nav press SNAPS** (sweep item X1, the two sites on this page).
///     `press` declares the whole `transition` shorthand and `transition-colors
///     duration-fast` is emitted after it at equal specificity, so
///     `transition-property` becomes the colour list and `transform` is not in
///     it. Probed with a real pointer: `none → matrix(0.94, …) → none`, each in
///     a single frame, with no intermediate matrix: where the navigation-menu
///     trigger beside it reported 0.937591 mid-flight. Reproduced with
///     [DsPress] at zero on both legs, the `theme_toggle.dart` pattern.
///  7. **`duration-fast` / `duration-base` are inert system-wide**: closed by
///     the sweep. The two sites on this page (`tabs.tsx` L113 and
///     `navigation-menu.tsx` L125) run [DsDurations.transitionDefault].
///  8. **Nothing about a navigation-menu trigger's paint transitions.** `press`
///     supplies the only `transition-property` on the element and it is
///     `transform`, so `hover:bg-secondary`, `hover:text-foreground` and both
///     `data-[state=open]:` rules arrive in one frame. Same for the panel
///     links. The chevron is the exception, because `rotate` **is** in
///     `transition-transform`'s expansion.
///  9. **The `li` inside a breadcrumb carries `gap-1` and never uses it** —
///     every item on this page holds exactly one child.
/// 10. **The pagination numbers are 16px and the words beside them 13px.**
///     `size="icon"` declares no `text-*` at all, so `1` / `2` / `3` / `12`
///     inherit the document's own type while *Previous* and *Next* take the
///     `default` rung's `text-sm`. One row, two sizes.
/// 11. **`PaginationEllipsis` is `aria-hidden` around an `sr-only` label** —
///     the label is hidden along with the box, so *"More pages"* is announced
///     nowhere. Reproduced: nothing is announced.
/// 12. **The `h-16` top-nav buttons overflow their own `h-16` row by half a
///     pixel each way**: measured: the row at 663.14, its buttons at 662.64.
///     The row's `border-b` eats a pixel of its 64, leaving a 63px content box
///     that `items-center` centres a 64px button in, so the active underline
///     ends up half a pixel over the row's own border.
///
///     **The one construction divergence on this page.** Flutter cannot let a
///     flex child be taller than its cell without either an unbounded
///     `OverflowBox` (which has no width to size itself by inside a `Row`) or
///     an overflow error, so the port paints the border **over** the row's last
///     pixel instead of subtracting it: the row's border box is 64 either way,
///     the buttons sit at the row's own top rather than half a pixel above it,
///     and every section height is unchanged. The half pixel is the whole
///     difference, and it is inside the anchor tolerance rather than hidden by
///     it.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../kit.dart';
import '../logo.dart';
import '../nav.dart';

/* ── Page data: the four const tables at the top of `page.tsx` ──────────── */

/// `NAV`: the signed-in top bar.
const List<({String label, DsIconGlyph icon, bool active})> _nav =
    <({String label, DsIconGlyph icon, bool active})>[
      (label: 'Packs', icon: DsIconGlyph.package, active: true),
      (label: 'Live Pulls', icon: DsIconGlyph.radio, active: false),
      (label: 'Stash', icon: DsIconGlyph.layers, active: false),
      (label: 'Wallet', icon: DsIconGlyph.wallet, active: false),
    ];

/// The signed-out bar's four words. Declared inline on the reference.
const List<String> _signedOut = <String>[
  'Packs',
  'How It Works',
  'Live Pulls',
  'Leaderboard',
];

/// `PACK_LINKS`: the two-column panel.
const List<({String title, String blurb})>
_packLinks = <({String title, String blurb})>[
  (
    title: 'Eclipse Vault',
    blurb: 'Sealed series with a published rarity table.',
  ),
  (title: 'Origin Pulse', blurb: 'The first print run, capped at 5,000 packs.'),
  (title: 'Nightfall', blurb: 'Graded pulls only. Every card ships slabbed.'),
  (title: 'Draft Bundle', blurb: 'Six packs at a set price, opened together.'),
];

/// `MARKET_LINKS`: the one-column panel, and the page's only `active` link.
const List<({String title, DsIconGlyph icon, bool active})> _marketLinks =
    <({String title, DsIconGlyph icon, bool active})>[
      (title: 'Browse all', icon: DsIconGlyph.layers, active: true),
      (title: 'Trending', icon: DsIconGlyph.trendingUp, active: false),
      (title: 'Ending soon', icon: DsIconGlyph.gavel, active: false),
      (title: 'Hot right now', icon: DsIconGlyph.flame, active: false),
    ];

/// `WALLET_LINKS`.
const List<String> _walletLinks = <String>[
  'Balance',
  'Transactions',
  'Withdraw',
];

/* ── Page constants ──────────────────────────────────────────────────────── */

/// `w-140`: the Packs panel's grid. Tailwind's spacing scale, so `ds` reaches
/// it, unlike the `max-w-*` container scale the other pages need literals for.
final double _packsGridWidth = ds(140);

/// `w-80`: the Marketplace panel's list.
final double _marketGridWidth = ds(80);

/// `w-72`: the two `viewport={false}` panels and the indicator panel.
final double _narrowGridWidth = ds(72);

/// The specimen stage under a navigation menu: `flex min-h-N items-start
/// justify-center px-5 pt-5 pb-M`.
///
/// The clearance is real and is what keeps the panel inside the `Panel`'s own
/// `overflow-hidden`: 20 + 40 + 160 = 220 against a 256px floor for the first,
/// 20 + 40 + 128 = 188 against 224 for the other two. Measured 256 / 224 / 224.
Widget _menuStage({
  required double minHeight,
  required double bottomPadding,
  required Widget child,
}) => ConstrainedBox(
  constraints: BoxConstraints(minHeight: minHeight),
  child: Padding(
    padding: EdgeInsets.fromLTRB(ds(5), ds(5), ds(5), bottomPadding),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[child],
    ),
  ),
);

/* ── Page ────────────────────────────────────────────────────────────────── */

class NavigationPage extends StatelessWidget {
  const NavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final DsCategoryHit here = findCategory('base', 'navigation');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DsPageHeader(
          // The drift every base page carries: the group is already called
          // "Base Components" and the page interpolates a second literal.
          eyebrow: '${here.group.title} · Base',
          title: here.category.title,
          blurb: here.category.blurb,
          contents: here.category.contents,
        ),
        // `className="mb-12"`, 48px.
        Padding(
          padding: EdgeInsets.only(bottom: ds(12)),
          child: DsNote(
            title: 'The active indicator is a rule, not a glow',
            // A [DsText], not a bare [Text]: [DsNote] hands its child the
            // `.type-small` ambient style, but only [DsText] brings the
            // [DsLineBox] that measures the paragraph as CSS measures it. The
            // difference here is one pixel on a two-line body, and it moves
            // every section on the page down with it.
            child: DsText(
              'Every active navigation state in the product is a controlled '
              'blue mark — a 2px underline, a left border, or a tinted pill. '
              'Navigation items never glow. The brief is explicit about this, '
              'and it is what keeps the top bar from looking like a slot '
              'machine.',
              DsType.small,
            ),
          ),
        ),
        const _TopNavSection(),
        const _DirectionSection(),
        const _TabsSection(),
        const _BreadcrumbSection(),
        const _PaginationSection(),
        const _NavigationMenuSection(),
        const _DisclosureSection(),
        const _ApiSection(),
        const _RulesSection(),
        const DsPageFootNav(groupId: 'base', slug: 'navigation'),
      ],
    );
  }
}

/* ── §1 · top navigation pattern ─────────────────────────────────────────── */

class _TopNavSection extends StatelessWidget {
  const _TopNavSection();

  @override
  Widget build(BuildContext context) {
    return DsSection(
      id: 'topnav',
      title: 'Top navigation pattern',
      description:
          'Not a component in its own right — a composition of '
          'Button, Avatar and the active indicator. Shown here so the pattern '
          'is documented once.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const DsPanel(
            label: 'Signed in',
            flush: true,
            child: _TopNavRow(signedIn: true),
          ),
          SizedBox(height: ds(4)),
          const DsPanel(
            label: 'Signed out',
            flush: true,
            child: _TopNavRow(signedIn: false),
          ),
        ],
      ),
    );
  }
}

/// `flex h-16 items-center gap-1 border-b border-border px-5`.
class _TopNavRow extends StatelessWidget {
  const _TopNavRow({required this.signedIn});

  final bool signedIn;

  /// `h-16`: the row's border box, `border-b` included.
  static double get height => ds(16);

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);

    return SizedBox(
      height: height,
      // `border-b` painted over the row's last pixel rather than subtracted
      // from its content box: see drift 12. The row's border box is 64 either
      // way; what moves is where the 64px buttons sit inside it.
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: DsWidths.hairline,
            child: ColoredBox(color: theme.border),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ds(5)),
            child: Row(
              children: <Widget>[
                // `className="mr-6"`.
                Padding(
                  padding: EdgeInsets.only(right: ds(6)),
                  child: const Logo(),
                ),
                if (signedIn)
                  for (final ({String label, DsIconGlyph icon, bool active})
                      item
                      in _nav) ...<Widget>[
                    _TopNavButton(
                      label: item.label,
                      glyph: item.icon,
                      active: item.active,
                    ),
                    // `gap-1`: the row's own, paid between every pair.
                    SizedBox(width: ds(1)),
                  ]
                else
                  for (final String label in _signedOut) ...<Widget>[
                    _TopNavButton(label: label),
                    SizedBox(width: ds(1)),
                  ],
                const Spacer(),
                if (signedIn) ...<Widget>[
                  const _BalanceChip(),
                  // `ml-auto flex items-center gap-3`.
                  SizedBox(width: ds(3)),
                  DsButton(
                    size: DsButtonSize.sm,
                    onPressed: () {},
                    child: const Text('Open Pack'),
                  ),
                ] else ...<Widget>[
                  DsButton(
                    variant: DsButtonVariant.ghost,
                    size: DsButtonSize.sm,
                    onPressed: () {},
                    child: const Text('Log In'),
                  ),
                  // `ml-auto flex items-center gap-2`.
                  SizedBox(width: ds(2)),
                  DsButton(
                    size: DsButtonSize.sm,
                    onPressed: () {},
                    child: const Text('Create Account'),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// One item in the bar: and drift 6's site.
class _TopNavButton extends StatefulWidget {
  const _TopNavButton({required this.label, this.glyph, this.active = false});

  final String label;

  /// The signed-out bar carries no icons at all: and no `gap-2` either.
  final DsIconGlyph? glyph;

  final bool active;

  /// `absolute inset-x-2 bottom-0 h-0.5 rounded-t-sm bg-action`.
  static double get underlineInset => ds(2);
  static double get underlineHeight => ds(0.5);

  @override
  State<_TopNavButton> createState() => _TopNavButtonState();
}

class _TopNavButtonState extends State<_TopNavButton> {
  bool _hovered = false;

  void _hover(bool value) {
    if (_hovered == value) return;
    setState(() => _hovered = value);
  }

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    // `text-foreground` when active; `text-muted-foreground
    // hover:text-foreground` otherwise. This is the only thing
    // `transition-colors` has left to animate.
    final Color ink = widget.active || _hovered
        ? theme.foreground
        : theme.mutedForeground;

    final Widget content = Padding(
      padding: EdgeInsets.symmetric(horizontal: ds(4)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (widget.glyph != null) ...<Widget>[
            DsIcon(
              widget.glyph!,
              size: DsIconSize.sm,
              // `tone={n.active ? "action" : "subtle"}`: the glyph keeps its
              // own tone and does **not** follow the label's hover.
              tone: widget.active ? DsIconTone.action : DsIconTone.subtle,
            ),
            SizedBox(width: ds(2)),
          ],
          TweenAnimationBuilder<Color?>(
            tween: ColorTween(end: ink),
            duration: dsAnimationDuration(
              context,
              DsDurations.transitionDefault,
            ),
            curve: DsCurves.out,
            builder: (BuildContext context, Color? value, Widget? _) => DsText(
              widget.label,
              DsType.nav,
              color: value ?? ink,
              softWrap: false,
            ),
          ),
        ],
      ),
    );

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _hover(true),
      onExit: (_) => _hover(false),
      child: Semantics(
        button: true,
        // `aria-current={n.active ? "page" : undefined}`: and §8's own API row
        // says why: *"the blue underline alone is not announced."*
        selected: widget.active ? true : null,
        label: widget.label,
        child: DsPress(
          // DRIFT 6 / sweep X1: the squish snaps here.
          downDuration: Duration.zero,
          upDuration: Duration.zero,
          onTap: () {},
          child: SizedBox(
            height: _TopNavRow.height,
            child: Stack(
              children: <Widget>[
                Center(widthFactor: 1, child: content),
                if (widget.active)
                  Positioned(
                    left: _TopNavButton.underlineInset,
                    right: _TopNavButton.underlineInset,
                    bottom: 0,
                    height: _TopNavButton.underlineHeight,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        // `bg-action`: the palette ramp, not `--primary`.
                        color: DsPalette.action,
                        // `rounded-t-sm`: the two top corners only.
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(DsRadii.sm),
                        ),
                      ),
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

/// `rounded-md border border-border bg-muted px-3 py-2` around a
/// `type-num-sm text-value-ink` span.
class _BalanceChip extends StatelessWidget {
  const _BalanceChip();

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    // The chip's own line box is the containing block's, not the small span's:
    // a blockified `<span>` inherits the row's 16px / 1.5 leading and the
    // 11.5px numeral sits inside it. 24px, measured.
    final TextStyle ambient = DefaultTextStyle.of(context).style;
    final double lineBox = (ambient.fontSize ?? 0) * (ambient.height ?? 1);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: ds(3), vertical: ds(2)),
      decoration: BoxDecoration(
        color: theme.muted,
        borderRadius: BorderRadius.circular(DsRadii.md),
        border: Border.all(color: theme.border, width: DsWidths.hairline),
      ),
      child: SizedBox(
        height: lineBox,
        child: Center(
          widthFactor: 1,
          child: DsText(r'$1,204.80', DsType.numSm, color: theme.valueInk),
        ),
      ),
    );
  }
}

/* ── §2 · direction provider ─────────────────────────────────────────────── */

class _DirectionSection extends StatelessWidget {
  const _DirectionSection();

  @override
  Widget build(BuildContext context) {
    return DsSection(
      id: 'direction',
      title: 'Direction provider',
      description:
          'Direction is context, not a second set of controls. The '
          'same Breadcrumb composition reads right-to-left when its provider '
          'changes.',
      child: const DsPanel(
        label: 'RTL context',
        note: 'direction=rtl',
        child: Directionality(
          // `<DirectionProvider direction="rtl"><div dir="rtl">`: one
          // statement in Flutter, where Radix needs the context provider and
          // the DOM attribute separately.
          textDirection: TextDirection.rtl,
          child: DsBreadcrumb(
            items: <DsBreadcrumbEntry>[
              DsBreadcrumbEntry.link('الحزم'),
              DsBreadcrumbEntry.page('نبض الأصل'),
            ],
          ),
        ),
      ),
    );
  }
}

/* ── §3 · tabs ───────────────────────────────────────────────────────────── */

class _TabsSection extends StatefulWidget {
  const _TabsSection();

  @override
  State<_TabsSection> createState() => _TabsSectionState();
}

class _TabsSectionState extends State<_TabsSection> {
  /// `defaultValue="live"` / `"overview"` / `"all"`: all three are the first
  /// trigger in their set.
  int _live = 0;
  int _account = 0;
  int _line = 0;

  static const List<String> _accountTabs = <String>[
    'Overview',
    'Pull History',
    'Transactions',
    'Preferences',
    'Security',
  ];

  static const List<String> _lineTabs = <String>[
    'All',
    'Sealed',
    'Graded',
    'Shipped',
  ];

  /// `className="pt-6"` on every `TabsContent` on this page.
  Widget _content(String text) => Padding(
    padding: EdgeInsets.only(top: ds(6)),
    child: DsText(text, DsType.small),
  );

  @override
  Widget build(BuildContext context) {
    return DsSection(
      id: 'tabs',
      title: 'Tabs',
      description:
          'Switching views inside one page — Live Pulls versus Top '
          'Hits, or the five tabs on the account page. The active pill slides '
          'between triggers.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          DsPanel(
            label: 'Live Pulls / Top Hits',
            child: DsTabs(
              selectedIndex: _live,
              onChanged: (int i) => setState(() => _live = i),
              items: <DsTabItem>[
                DsTabItem(
                  label: 'Live Pulls',
                  content: _content(
                    'A live feed of every pull across the platform, updating '
                    'continuously.',
                  ),
                ),
                DsTabItem(
                  label: 'Top Hits',
                  content: _content(
                    'The highest-value cards pulled in the last 24 hours.',
                  ),
                ),
                DsTabItem(
                  label: 'My Pulls',
                  content: _content('Your own pull history.'),
                ),
              ],
            ),
          ),
          SizedBox(height: ds(4)),
          DsPanel(
            label: 'Account tabs',
            child: DsTabs(
              selectedIndex: _account,
              onChanged: (int i) => setState(() => _account = i),
              items: <DsTabItem>[
                for (int i = 0; i < _accountTabs.length; i++)
                  DsTabItem(
                    label: _accountTabs[i],
                    // Five triggers, one `TabsContent`: the other four values
                    // have no panel at all in the reference.
                    content: i == 0
                        ? _content(
                            'The five tabs the brief specifies for the account '
                            'screen.',
                          )
                        : null,
                  ),
              ],
            ),
          ),
          SizedBox(height: ds(4)),
          DsPanel(
            label: 'Line variant',
            child: DsTabs(
              variant: DsTabsVariant.line,
              selectedIndex: _line,
              onChanged: (int i) => setState(() => _line = i),
              items: <DsTabItem>[
                for (int i = 0; i < _lineTabs.length; i++)
                  DsTabItem(
                    label: _lineTabs[i],
                    content: i == 0
                        ? _content(
                            'The rule travels too — as a 2px underline rather '
                            'than a filled pill, because an underlined tab set '
                            'that grew a blue fill would stop being an '
                            'underlined tab set.',
                          )
                        : null,
                  ),
              ],
            ),
          ),
          // `className="type-small mt-5"`, outside every Panel.
          Padding(
            padding: EdgeInsets.only(top: ds(5)),
            child: DsText(
              '40px track, 4px inset, 32px triggers on 16px padding — the same '
              'ladder as every other control. Stock shadcn ships 32 / 3 / 25, '
              'none of which is on the 8-point scale.',
              DsType.small,
            ),
          ),
        ],
      ),
    );
  }
}

/* ── §4 · breadcrumb ─────────────────────────────────────────────────────── */

class _BreadcrumbSection extends StatelessWidget {
  const _BreadcrumbSection();

  @override
  Widget build(BuildContext context) {
    return DsSection(
      id: 'breadcrumb',
      title: 'Breadcrumb',
      description:
          'Used on pack detail pages, where the user arrived from a '
          'filtered marketplace and needs a way back to it.',
      child: DsPanel(
        label: 'Pack detail',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const DsBreadcrumb(
              items: <DsBreadcrumbEntry>[
                DsBreadcrumbEntry.link('Packs'),
                DsBreadcrumbEntry.link('Eclipse Vault'),
                DsBreadcrumbEntry.page('Origin Pulse — Series I'),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: ds(5)),
              child: const _BreadcrumbCaption(),
            ),
          ],
        ),
      ),
    );
  }
}

class _BreadcrumbCaption extends StatelessWidget {
  const _BreadcrumbCaption();

  @override
  Widget build(BuildContext context) {
    return DsRichText(
      TextSpan(
        children: <InlineSpan>[
          const TextSpan(text: 'The current page is a '),
          DsCode.span('BreadcrumbPage'),
          const TextSpan(text: ', not a link — it carries '),
          DsCode.span('aria-current'),
          const TextSpan(text: ' and is not clickable.'),
        ],
      ),
      DsType.small,
    );
  }
}

/* ── §5 · pagination ─────────────────────────────────────────────────────── */

class _PaginationSection extends StatelessWidget {
  const _PaginationSection();

  @override
  Widget build(BuildContext context) {
    return DsSection(
      id: 'pagination',
      title: 'Pagination',
      description:
          'The marketplace and the Stash both paginate. Load-more is '
          'used for the live feed instead, because that list grows from the '
          'top.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          DsPanel(
            label: 'Pack grid pagination',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const DsPagination(
                  children: <Widget>[
                    DsPaginationStep.previous(),
                    DsPaginationLink(label: '1'),
                    DsPaginationLink(label: '2', isActive: true),
                    DsPaginationLink(label: '3'),
                    DsPaginationEllipsis(),
                    DsPaginationLink(label: '12'),
                    DsPaginationStep.next(),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: ds(5)),
                  child: DsText(
                    'Showing 25–48 of 184 packs',
                    DsType.small,
                    align: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: ds(4)),
          DsPanel(
            label: 'Load more — for feeds',
            child: Column(
              // `flex flex-col items-center gap-3`.
              children: <Widget>[
                DsButton(
                  variant: DsButtonVariant.outline,
                  onPressed: () {},
                  child: const Text('Load 25 more pulls'),
                ),
                SizedBox(height: ds(3)),
                DsText(
                  '48 of 12,480 shown',
                  DsType.numSm,
                  color: DsTheme.of(context).mutedForeground,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/* ── §6 · navigation menu ────────────────────────────────────────────────── */

class _NavigationMenuSection extends StatelessWidget {
  const _NavigationMenuSection();

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);

    return DsSection(
      id: 'navigation-menu',
      title: 'Navigation Menu',
      description:
          'A top bar whose items can open a panel. Reach for it when '
          'a section needs more than a link — a set of destinations with '
          'descriptions. The plain top-nav pattern above is still right when '
          'every item is a single destination.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          DsPanel(
            label: 'With a viewport — one shared panel that resizes',
            flush: true,
            child: _menuStage(
              minHeight: ds(64),
              bottomPadding: ds(40),
              child: DsNavigationMenu(
                items: <DsNavigationMenuItem>[
                  DsNavigationMenuItem.trigger(
                    label: 'Packs',
                    content: SizedBox(
                      width: _packsGridWidth,
                      child: _PackGrid(theme: theme),
                    ),
                  ),
                  DsNavigationMenuItem.trigger(
                    label: 'Marketplace',
                    content: SizedBox(
                      width: _marketGridWidth,
                      child: _IconLinkList(links: _marketLinks),
                    ),
                  ),
                  const DsNavigationMenuItem.link(label: 'Leaderboard'),
                ],
              ),
            ),
          ),
          SizedBox(height: ds(4)),
          DsPanel(
            label: 'Without a viewport — each item owns its panel',
            note: 'viewport={false}',
            flush: true,
            child: _menuStage(
              minHeight: ds(56),
              bottomPadding: ds(32),
              child: DsNavigationMenu(
                viewport: false,
                items: <DsNavigationMenuItem>[
                  DsNavigationMenuItem.trigger(
                    label: 'Stash',
                    content: SizedBox(
                      width: _narrowGridWidth,
                      child: _IconLinkList(
                        links: _marketLinks.sublist(0, 3),
                        // `.slice(0, 3)` keeps `active: true` on the first row.
                        honourActive: false,
                      ),
                    ),
                  ),
                  DsNavigationMenuItem.trigger(
                    label: 'Wallet',
                    content: SizedBox(
                      width: _narrowGridWidth,
                      child: const _PlainLinkList(labels: _walletLinks),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: ds(4)),
          DsPanel(
            label: 'Indicator — the caret that names the open trigger',
            flush: true,
            child: _menuStage(
              minHeight: ds(56),
              bottomPadding: ds(32),
              child: DsNavigationMenu(
                indicator: true,
                items: <DsNavigationMenuItem>[
                  for (final String label in <String>['Packs', 'Marketplace'])
                    DsNavigationMenuItem.trigger(
                      label: label,
                      content: SizedBox(
                        width: _narrowGridWidth,
                        child: const _PlainLinkList(labels: _walletLinks),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: ds(4)),
            child: DsGrid(
              base: 1,
              lg: 2,
              children: const <Widget>[
                DsNote(title: 'Keyboard', child: _KeyboardBody()),
                DsNote(
                  title: 'Where the state variants come from',
                  child: _VariantsBody(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// `<ul className="grid w-140 gap-1 md:grid-cols-2">`: four two-line links.
class _PackGrid extends StatelessWidget {
  const _PackGrid({required this.theme});

  final DsThemeData theme;

  @override
  Widget build(BuildContext context) {
    return DsGrid(
      base: 1,
      md: 2,
      // `gap-1`, not the kit default's `gap-4`.
      gap: ds(1),
      children: <Widget>[
        for (final ({String title, String blurb}) link in _packLinks)
          DsNavigationMenuLink(
            onTap: () {},
            // `className="flex-col items-start"` on the anchor: the row's own
            // `flex items-center` inverted for the two-line shape.
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                DsText(link.title, DsType.nav, color: theme.foreground),
                SizedBox(height: DsNavigationMenuLink.gap),
                DsText(link.blurb, DsType.small),
              ],
            ),
          ),
      ],
    );
  }
}

/// `<ul className="grid w-80 gap-1">` / `w-72`: an icon and a label per row.
class _IconLinkList extends StatelessWidget {
  const _IconLinkList({required this.links, this.honourActive = true});

  final List<({String title, DsIconGlyph icon, bool active})> links;

  /// The Stash panel takes the same three rows and shows them **unstyled** —
  /// `NavigationMenuLink` there is written without an `active` prop at all,
  /// where the Marketplace panel passes `active={l.active}`.
  final bool honourActive;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (int i = 0; i < links.length; i++) ...<Widget>[
          if (i > 0) SizedBox(height: ds(1)),
          DsNavigationMenuLink(
            active: honourActive && links[i].active,
            onTap: () {},
            child: Row(
              children: <Widget>[
                DsIcon(
                  links[i].icon,
                  size: DsIconSize.sm,
                  tone: DsIconTone.subtle,
                ),
                SizedBox(width: DsNavigationMenuLink.gap),
                DsText(links[i].title, DsComponentType.textSm),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

/// `<ul className="grid w-72 gap-1">`: three words.
class _PlainLinkList extends StatelessWidget {
  const _PlainLinkList({required this.labels});

  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (int i = 0; i < labels.length; i++) ...<Widget>[
          if (i > 0) SizedBox(height: ds(1)),
          DsNavigationMenuLink(
            onTap: () {},
            child: DsText(labels[i], DsComponentType.textSm),
          ),
        ],
      ],
    );
  }
}

/// The keyboard Note's `<ul className="space-y-1.5">`.
class _KeyboardBody extends StatelessWidget {
  const _KeyboardBody();

  @override
  Widget build(BuildContext context) {
    final List<InlineSpan> rows = <InlineSpan>[
      TextSpan(
        children: <InlineSpan>[
          DsCode.span('←'),
          const TextSpan(text: ' '),
          DsCode.span('→'),
          const TextSpan(text: ' move between triggers.'),
        ],
      ),
      TextSpan(
        children: <InlineSpan>[
          DsCode.span('Enter'),
          const TextSpan(text: ' or '),
          DsCode.span('Space'),
          const TextSpan(text: ' opens the panel; '),
          DsCode.span('↓'),
          const TextSpan(text: ' opens it and enters it.'),
        ],
      ),
      TextSpan(
        children: <InlineSpan>[
          DsCode.span('Tab'),
          const TextSpan(text: ' walks the links inside an open panel.'),
        ],
      ),
      TextSpan(
        children: <InlineSpan>[
          DsCode.span('Esc'),
          const TextSpan(
            text: ' closes the panel and returns focus to its trigger.',
          ),
        ],
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (int i = 0; i < rows.length; i++) ...<Widget>[
          // `space-y-1.5`: a margin between siblings, not a gap around them.
          if (i > 0) SizedBox(height: ds(1.5)),
          DsRichText(rows[i], DsType.small),
        ],
      ],
    );
  }
}

class _VariantsBody extends StatelessWidget {
  const _VariantsBody();

  @override
  Widget build(BuildContext context) {
    return DsRichText(
      TextSpan(
        children: <InlineSpan>[
          const TextSpan(text: 'Radix emits '),
          DsCode.span('data-state="open"'),
          const TextSpan(text: ' and '),
          DsCode.span('data-active=""'),
          const TextSpan(text: ' — never a bare '),
          DsCode.span('data-open'),
          const TextSpan(text: '. Tailwind alone would compile '),
          DsCode.span('data-open:'),
          const TextSpan(text: ' to '),
          DsCode.span('[data-open]'),
          const TextSpan(text: ' and match nothing. It works here because '),
          DsCode.span('app/globals.css'),
          const TextSpan(text: ' imports '),
          DsCode.span('shadcn/tailwind.css'),
          const TextSpan(text: ', which registers '),
          DsCode.span('@custom-variant data-open'),
          const TextSpan(text: ' covering '),
          DsCode.span('[data-state="open"]'),
          const TextSpan(text: ' as well — likewise '),
          DsCode.span('data-closed'),
          const TextSpan(text: ', '),
          DsCode.span('data-checked'),
          const TextSpan(text: ', '),
          DsCode.span('data-active'),
          const TextSpan(text: ', '),
          DsCode.span('data-horizontal'),
          const TextSpan(text: ' and '),
          DsCode.span('data-vertical'),
          const TextSpan(
            text:
                '. Fifteen vendored components depend on that shim. Check it '
                'before deciding one of them is broken: a compile test '
                'importing only ',
          ),
          DsCode.span('tailwindcss'),
          const TextSpan(
            text: ' reports every one of them dead, and is wrong.',
          ),
        ],
      ),
      DsType.small,
    );
  }
}

/* ── §7 · accordion & collapsible ────────────────────────────────────────── */

class _DisclosureSection extends StatefulWidget {
  const _DisclosureSection();

  @override
  State<_DisclosureSection> createState() => _DisclosureSectionState();
}

class _DisclosureSectionState extends State<_DisclosureSection> {
  /// `defaultValue="odds"`: the first question.
  int? _open = 0;

  /// `Collapsible` with no `defaultOpen`.
  bool _filters = false;

  static const List<String> _filterRows = <String>[
    'Volatility',
    'Print run size',
    'Pack type',
    'Card set',
  ];

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);

    return DsSection(
      id: 'disclosure',
      title: 'Accordion & Collapsible',
      description:
          'Accordion for a set of related disclosures where only one '
          'should be open — the FAQ. Collapsible for a single independent '
          'section, like an advanced filter block.',
      child: DsGrid(
        base: 1,
        lg: 2,
        children: <Widget>[
          DsPanel(
            label: 'Accordion — FAQ',
            child: DsAccordion(
              openIndex: _open,
              onChanged: (int? i) => setState(() => _open = i),
              items: <DsAccordionItem>[
                DsAccordionItem(
                  title: 'How are the odds decided?',
                  // `text-sm` on the content div, through a [DsText] for the
                  // Note's reason: the paragraph's own height is what the
                  // unfold animates to.
                  content: DsText(
                    'Every card in a pack is rolled independently against the '
                    'published rarity table. The table is shown on each '
                    'pack’s detail page before you buy.',
                    DsComponentType.textSm,
                  ),
                ),
                DsAccordionItem(
                  title: 'Can I sell a card back?',
                  content: DsText(
                    'Yes. Sell-back is offered at the card’s current listed '
                    'value, and the amount is credited to your available '
                    'balance immediately.',
                    DsComponentType.textSm,
                  ),
                ),
                DsAccordionItem(
                  title: 'How does shipping work?',
                  content: DsText(
                    'Request a shipment from your Stash. Cards are pulled from '
                    'the vault, graded, and dispatched together.',
                    DsComponentType.textSm,
                  ),
                ),
              ],
            ),
          ),
          DsPanel(
            label: 'Collapsible — advanced filters',
            child: DsCollapsible(
              open: _filters,
              trigger: DsButton(
                variant: DsButtonVariant.outline,
                onPressed: () => setState(() => _filters = !_filters),
                child: Row(
                  // `className="w-full justify-between"`.
                  children: <Widget>[
                    const Text('Advanced filters'),
                    const Spacer(),
                    DsIcon(
                      DsIconGlyph.chevronRight,
                      size: DsIconSize.sm,
                      tone: DsIconTone.subtle,
                    ),
                  ],
                ),
              ),
              content: Padding(
                // `className="pt-4"` on the content.
                padding: EdgeInsets.only(top: ds(4)),
                child: Container(
                  padding: EdgeInsets.all(ds(4)),
                  decoration: BoxDecoration(
                    color: theme.card,
                    borderRadius: BorderRadius.circular(DsRadii.lg),
                    border: Border.all(
                      color: theme.border,
                      width: DsWidths.hairline,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      for (int i = 0; i < _filterRows.length; i++) ...<Widget>[
                        // `space-y-3`.
                        if (i > 0) SizedBox(height: ds(3)),
                        DsText(_filterRows[i], DsType.small),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* ── §8 · API ────────────────────────────────────────────────────────────── */

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
            k: 'Tabs',
            v: const TextSpan(
              text:
                  'Tabs + TabsList + TabsTrigger + TabsContent. defaultValue '
                  'sets the initial tab.',
            ),
          ),
          (
            k: 'Breadcrumb',
            v: const TextSpan(
              text:
                  'Use BreadcrumbPage for the current page so it gets '
                  'aria-current and is not a link.',
            ),
          ),
          (
            k: 'PaginationLink isActive',
            v: const TextSpan(
              text: 'Marks the current page. Sets aria-current internally.',
            ),
          ),
          (
            k: 'NavigationMenu viewport',
            v: const TextSpan(
              text:
                  'Default true — one shared panel that resizes between '
                  'triggers. false gives each item its own panel, which is '
                  'right when the panels are very different sizes.',
            ),
          ),
          (
            k: 'NavigationMenuLink active',
            v: const TextSpan(
              text:
                  'Marks the current destination. Radix writes data-active='
                  '"", so style it with data-active:, never '
                  'data-[active=true].',
            ),
          ),
          (
            k: 'navigationMenuTriggerStyle()',
            v: const TextSpan(
              text:
                  'The 40px pill, for an item that is a plain link rather '
                  'than a trigger. Pass it to NavigationMenuLink\'s className '
                  'so both sit level.',
            ),
          ),
          (
            k: 'NavigationMenuIndicator',
            v: const TextSpan(
              text:
                  'The caret pointing at the open trigger. Optional, and it '
                  'is not an active-page marker — that is still aria-current '
                  'plus a blue rule.',
            ),
          ),
          (
            k: 'Accordion',
            v: const TextSpan(
              text:
                  'type="single" collapsible for FAQs; type="multiple" when '
                  'sections are independent.',
            ),
          ),
          (
            k: 'aria-current="page"',
            v: const TextSpan(
              text:
                  'Required on the active top-nav item — the blue underline '
                  'alone is not announced.',
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
    return const DsSection(
      id: 'rules',
      title: 'Rules',
      child: DsDoDont(
        dos: <String>[
          'Mark the active nav item with aria-current as well as the blue '
              'indicator.',
          'Use pagination for grids and load-more for feeds that grow from the '
              'top.',
          'Show the range and total alongside pagination: '
              "'Showing 25–48 of 184'.",
          'Use an accordion when only one section should be open at a time.',
          'Reach for a Navigation Menu only when items need a panel; a plain '
              'top-nav row is right when each item is one destination.',
        ],
        donts: <String>[
          "Don't put a glow on navigation — the brief rules this out "
              'explicitly.',
          "Don't make the current breadcrumb a link.",
          "Don't use tabs for steps in a sequence; that is a different "
              'pattern.',
          "Don't nest tabs inside tabs.",
          "Don't assume a data-* variant matches: check what the library emits "
              'and which @custom-variant covers it. A mismatch fails silently.',
        ],
      ),
    );
  }
}
