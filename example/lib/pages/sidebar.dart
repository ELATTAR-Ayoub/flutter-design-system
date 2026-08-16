/// `/design-system/components/base/sidebar` — *"the app shell, taken apart."*
///
/// The page's own thesis, and the reason it has no second anatomy: **one
/// composition, rendered repeatedly.** `FixtureHeader`, `FixtureMenu`,
/// `FixtureContent` and `FixtureFooter` are declared once at the top and every
/// ordinary specimen below reuses them, so *"change `FixtureMenu` or a
/// primitive and every ordinary specimen changes with it."*
///
/// Nine sections, and only two of them are allowed to differ from the fixture:
/// §4 and §5, which are *"intentionally different: each row is the canonical
/// Button variant placed into the same sidebar geometry."*
///
/// ## The two stages
///
/// `PartStage` is `collapsible="none"` — *"the one mode upstream renders as a
/// plain flex column: the real component, carrying the real tokens, with no
/// fixed positioning and no viewport dependency."* Every resting specimen sits
/// in one.
///
/// `ShellStage` is the whole shell, boxed. On the reference `transform-gpu`
/// traps a genuinely `position: fixed` panel inside a 384px frame — *"CSS doing
/// its documented job rather than a hack, and it is the whole reason
/// `SidebarRail` and `SidebarInset` can be documented in a panel instead of
/// behind a link."* The port needs no trap: [DsSidebar] renders its container
/// as an overflowing child of its own gap, and this frame clips it.
///
/// ## Oracle (light, 1440 × 900, 2026-08-16)
///
/// `node tool/verify/section-oracle.js /design-system/components/base/sidebar`
/// — document `scrollHeight` **5644**, `main` 64 → 5579.7. Section tops and
/// border-box heights are pinned in `example/test/sidebar_page_test.dart`.
///
/// ## Drift register — reproduced, recorded, never fixed
///
///  1. **The chip list is the export inventory, not the section list.**
///     `contents` names twenty-one *components* while the page has nine
///     sections, and the two do not correspond at any point. `nav.ts` says so
///     itself: *"the same convention `buttons` uses, where `contents` is what
///     is shown rather than what the headings are called."*
///  2. **`SidebarGroupLabel`'s declared `px-3 pr-10` never renders.** Every
///     label on the page is inside a `SidebarCollapsibleGroup`, which passes
///     `px-0`; tailwind-merge drops `pr-10` with it.
///  3. **The badge is typed twice and loses both properties it shares.**
///     `.type-num-xs` (11/600) against `Badge`'s `text-xs font-medium`
///     (12/500) — measured 12px at 500, mono, tabular. Carried by
///     [DsComponentType.sidebarMenuBadge].
///  4. **`NavUser`'s avatar fallback splits the difference** — 13px from
///     `text-sm`, 600 from `.type-num-sm`, mono from `.type-num-sm`.
///  5. **Every row on the page is a `<button>` with no `onClick`.** The active
///     row is fixed by prop, so the travelling pill never travels here: it
///     places once, squashes once, and stays. Reproduced exactly — the rows
///     answer a pointer (hover, press, focus) and change nothing.
///  6. **The pill lands on the parent row in §Submenu, not on the list item.**
///     Both the parent and the "Open" sub-link carry `data-active`;
///     `querySelector` takes the first, so the 149.5px item holds a 37.5px
///     pill.
///  7. **`SidebarMenuAction` appears exactly once**, in §Badges and actions,
///     and `showOnHover` is never passed — so the `md:opacity-0` branch is
///     declared and unreachable from this page.
///  8. **`SidebarMenuSkeleton` is exported and never rendered.** It is in
///     `contents`; no section shows one.
///  9. **`SidebarInput` is `h-8 bg-background shadow-none`** — the one field in
///     the system with no socket. It reads as a well only because the panel
///     around it is `--sidebar`.
/// 10. **The shell link goes nowhere here.** *"Open the full-viewport
///     sidebar"* points at `/sidebar-demo`, a route this port does not carry;
///     the button ships, and pressing it does nothing.
/// 11. **`duration-base` is inert, five times over** — closed corpus-wide by
///     the sweep. All five sites still run 250ms, because
///     `--default-transition-duration` **is** `--duration-base`.
/// 12. **The `sidebar_state` cookie has no counterpart**, and the readout copy
///     that mentions it is not on this page — the page shows the shell matrix
///     only.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../kit.dart';
import '../nav.dart';

/* ── Fixtures ────────────────────────────────────────────────────────────── */

/// *"One product across every specimen, so the page reads as a thing rather
/// than a parts bin."*
const List<({String label, DsIconGlyph glyph, String? count})> _nav =
    <({String label, DsIconGlyph glyph, String? count})>[
  (label: 'All cards', glyph: DsIconGlyph.layers, count: '1,284'),
  (label: 'Favourites', glyph: DsIconGlyph.star, count: '37'),
  (label: 'New this week', glyph: DsIconGlyph.sparkles, count: null),
  (label: 'Wallet', glyph: DsIconGlyph.wallet, count: null),
];

/// `FOOT_NAV`. `Receipt` is not on the icons page's curated whitelist, so it
/// comes off the generated registry — the same split `DsIcon.lucide` carries.
const List<({String label, DsIconGlyph? glyph, DsLucideGlyph? lucide})>
    _footNav = <({String label, DsIconGlyph? glyph, DsLucideGlyph? lucide})>[
  (label: 'Orders', glyph: null, lucide: DsLucide.receipt),
  (label: 'Alerts', glyph: DsIconGlyph.bell, lucide: null),
  (label: 'Settings', glyph: DsIconGlyph.settings, lucide: null),
];

/// `ACCOUNT` — *"the account the footer specimens show. Sample data, never a
/// default."*
const DsNavUserAccount _account = DsNavUserAccount(
  name: 'Ayoub Elattar',
  email: 'ayoub@eclipsevault.example',
);

/// `ACCOUNT_ITEMS`.
const List<DsNavUserItem> _accountItems = <DsNavUserItem>[
  DsNavUserItem(label: 'Account', icon: DsLucide.badgeCheck),
  DsNavUserItem(label: 'Billing', icon: DsLucide.creditCard),
  DsNavUserItem(label: 'Notifications', icon: DsLucide.bell),
  DsNavUserItem(label: 'Sign out', icon: DsLucide.logOut, destructive: true),
];

/// `BUTTON_VARIANTS`, in the page's own order — `ghost` first, `default`
/// second.
const List<({String label, DsButtonVariant variant})> _buttonVariants =
    <({String label, DsButtonVariant variant})>[
  (label: 'ghost', variant: DsButtonVariant.ghost),
  (label: 'default', variant: DsButtonVariant.primary),
  (label: 'premium', variant: DsButtonVariant.premium),
  (label: 'secondary', variant: DsButtonVariant.secondary),
  (label: 'outline', variant: DsButtonVariant.outline),
  (label: 'destructive', variant: DsButtonVariant.destructive),
  (label: 'link', variant: DsButtonVariant.link),
];

/// `BADGE_VARIANTS`.
const List<({String label, DsBadgeVariant variant})> _badgeVariants =
    <({String label, DsBadgeVariant variant})>[
  (label: 'default', variant: DsBadgeVariant.primary),
  (label: 'secondary', variant: DsBadgeVariant.secondary),
  (label: 'destructive', variant: DsBadgeVariant.destructive),
  (label: 'outline', variant: DsBadgeVariant.outline),
  (label: 'ghost', variant: DsBadgeVariant.ghost),
  (label: 'link', variant: DsBadgeVariant.link),
  (label: 'action', variant: DsBadgeVariant.action),
  (label: 'premium', variant: DsBadgeVariant.premium),
  (label: 'success', variant: DsBadgeVariant.success),
  (label: 'warning', variant: DsBadgeVariant.warning),
  (label: 'info', variant: DsBadgeVariant.info),
];

/// `h-160` — the anatomy stage. 640px.
const double _stageTall = 640;

/// `h-40` — the header-in-context stage. 160px.
const double _stageShort = 160;

/// `h-80` — the two footer stages. 320px.
const double _stageFooter = 320;

/// `h-96` — the shell frame. 384px.
const double _shellHeight = 384;

/// `lg:grid-cols-[20rem_1fr]` — the anatomy's fixed first column, 20rem.
// allow-hardcoded: framework rem measure with no token to read it from.
const double _railColumn = 320;

/* ── Stages ──────────────────────────────────────────────────────────────── */

/// `PartStage` — one part, shown on its own.
///
/// Upstream this is a `SidebarProvider` at `min-h-0 w-auto` around a
/// `Sidebar collapsible="none"` at `rounded-lg border border-sidebar-border`,
/// and **every call site on the page passes `rounded-none border-0`** — so the
/// declared frame never renders and the stage is a bare `--sidebar` block. The
/// `w-full` each of them also passes is what makes a 256px component fill the
/// panel it sits in.
class _PartStage extends StatelessWidget {
  const _PartStage({required this.children, this.height});

  final List<Widget> children;

  /// `h-160` / `h-40` / `h-80`, or null for a stage that hugs its content.
  final double? height;

  @override
  Widget build(BuildContext context) {
    final Widget stage = DsSidebarProvider(
      children: <Widget>[
        Expanded(
          child: DsSidebar(
            collapsible: DsSidebarCollapsible.none,
            expand: true,
            children: children,
          ),
        ),
      ],
    );
    // `min-h-0` on the provider, and nothing else to give the row a height:
    // a CSS flex row is as tall as its tallest item, which is what
    // [IntrinsicHeight] says here. Only the stages that state an `h-*` skip it.
    return height == null
        ? IntrinsicHeight(child: stage)
        : SizedBox(height: height, child: stage);
  }
}

/// `ShellStage` — the whole shell, boxed.
class _ShellStage extends StatelessWidget {
  const _ShellStage({required this.children, required this.variant});

  final List<Widget> children;

  /// See [DsSidebarProvider.variant]: the wrapper's `has-data-[variant=inset]`
  /// fill and the inset's `peer-data-[variant=inset]` margins are relational
  /// selectors, so the fact travels down rather than up.
  final DsSidebarVariant variant;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return SizedBox(
      height: _shellHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(DsRadii.lg),
          border: Border.all(color: theme.border, width: DsWidths.hairline),
        ),
        // `box-sizing: border-box` — the frame is paid out of the 384.
        child: Padding(
          padding: const EdgeInsets.all(DsWidths.hairline),
          child: ClipRRect(
            // `overflow-hidden`, and what clips the collapsing panel.
            borderRadius:
                BorderRadius.circular(DsRadii.lg - DsWidths.hairline),
            child: DsSidebarProvider(variant: variant, children: children),
          ),
        ),
      ),
    );
  }
}

/* ── The shared composition ──────────────────────────────────────────────── */

/// `FixtureHeader` — *"one workspace button and one SidebarInput."*
class _FixtureHeader extends StatelessWidget {
  const _FixtureHeader();

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return DsSidebarHeader(
      children: <Widget>[
        DsSidebarMenu(
          children: <Widget>[
            DsSidebarMenuItem(
              button: DsSidebarMenuButton(
                size: DsSidebarMenuButtonSize.lg,
                tooltip: 'Eclipse Vault workspace',
                child: DsSidebarMenuRow(
                  size: DsSidebarMenuButtonSize.lg,
                  // `type-num-sm flex size-8 shrink-0 items-center
                  //  justify-center rounded-lg bg-secondary text-foreground
                  //  shadow-chip`.
                  leading: SizedBox(
                    width: ds(8),
                    height: ds(8),
                    child: DsMachineSurface(
                      spec: DsShadows.chip,
                      radius: BorderRadius.circular(DsRadii.lg),
                      fill: theme.secondary,
                      child: Center(
                        child: DsText('EV', DsType.numSm,
                            color: theme.foreground),
                      ),
                    ),
                  ),
                  label: const _WorkspaceLabel(
                    title: 'Eclipse Vault',
                    subtitle: '12 members',
                  ),
                  trailing:
                      const DsIcon.lucide(DsLucide.chevronsUpDown),
                ),
              ),
            ),
          ],
        ),
        const DsSidebarInput(
          placeholder: 'Search cards',
          label: 'Search cards',
        ),
      ],
    );
  }
}

/// The two-line block a workspace / version / account row carries.
class _WorkspaceLabel extends StatelessWidget {
  const _WorkspaceLabel({
    required this.title,
    required this.subtitle,
    this.subtitleSpec,
  });

  final String title;
  final String subtitle;

  /// `.type-caption` by default; the version switcher's line is
  /// `.type-num-xs`.
  final DsTypeSpec? subtitleSpec;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        DsText(
          title,
          DsType.nav,
          color: theme.foreground,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
        ),
        DsText(
          subtitle,
          subtitleSpec ?? DsType.caption,
          color: theme.mutedForeground,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
        ),
      ],
    );
  }
}

/// `FixtureMenu` — *"every non-variant specimen uses this exact function."*
class _FixtureMenu extends StatelessWidget {
  const _FixtureMenu();

  /// `activeLabel = NAV[0].label` — the page never overrides either default,
  /// so both are stated once here rather than carried as unused props.
  static const String activeLabel = 'All cards';

  /// `badges = true`.
  static const bool badges = true;

  @override
  Widget build(BuildContext context) {
    final double glyph = DsButton.iconPxFor(DsSidebarMenuButtonSize.md.button);
    return DsSidebarMenu(
      children: <Widget>[
        for (final ({String label, DsIconGlyph glyph, String? count}) item
            in _nav)
          DsSidebarMenuItem(
            button: DsSidebarMenuButton(
              isActive: item.label == activeLabel,
              tooltip: item.label,
              child: DsSidebarMenuRow(
                leading: DsIcon(item.glyph, sizePx: glyph),
                label: DsSidebarMenuLabel(item.label),
              ),
            ),
            badge: badges && item.count != null
                ? DsSidebarMenuBadge(item.count!)
                : null,
          ),
      ],
    );
  }
}

/// The `FOOT_NAV` menu — the second group of `FixtureContent`.
class _ActivityMenu extends StatelessWidget {
  const _ActivityMenu();

  @override
  Widget build(BuildContext context) {
    final double glyph = DsButton.iconPxFor(DsSidebarMenuButtonSize.md.button);
    return DsSidebarMenu(
      children: <Widget>[
        for (final ({String label, DsIconGlyph? glyph, DsLucideGlyph? lucide})
            item in _footNav)
          DsSidebarMenuItem(
            button: DsSidebarMenuButton(
              tooltip: item.label,
              child: DsSidebarMenuRow(
                leading: item.glyph != null
                    ? DsIcon(item.glyph!, sizePx: glyph)
                    : DsIcon.lucide(item.lucide!, sizePx: glyph),
                label: DsSidebarMenuLabel(item.label),
              ),
            ),
          ),
      ],
    );
  }
}

/// `FixtureContent` — *"no section owns a private copy of these groups."*
class _FixtureContent extends StatelessWidget {
  const _FixtureContent();

  @override
  Widget build(BuildContext context) => DsSidebarContent(
        children: <Widget>[
          DsSidebarCollapsibleGroup(
            label: 'Collection',
            toggleLabel: 'Toggle Collection group',
            action: const _AddCollection(),
            child: const _FixtureMenu(),
          ),
          const DsSidebarSeparator(),
          const DsSidebarCollapsibleGroup(
            label: 'Activity',
            toggleLabel: 'Toggle Activity group',
            child: _ActivityMenu(),
          ),
        ],
      );
}

/// `<SidebarGroupAction aria-label="Add collection"><Icon icon={Plus} /></…>`.
class _AddCollection extends StatelessWidget {
  const _AddCollection();

  @override
  Widget build(BuildContext context) => DsSidebarGroupAction(
        label: 'Add collection',
        child: DsIcon(
          DsIconGlyph.plus,
          sizePx: DsButton.iconPxFor(DsButtonSize.iconXs),
        ),
      );
}

/// `FixtureFooter` — *"one NavUser composition, pinned by SidebarFooter."*
class _FixtureFooter extends StatelessWidget {
  const _FixtureFooter();

  @override
  Widget build(BuildContext context) => const DsSidebarFooter(
        children: <Widget>[
          DsNavUser(user: _account, items: _accountItems),
        ],
      );
}

/* ── §1 Complete sidebar ─────────────────────────────────────────────────── */

class _AnatomySection extends StatelessWidget {
  const _AnatomySection();

  @override
  Widget build(BuildContext context) => DsSection(
        id: 'anatomy',
        title: 'Complete sidebar',
        description: 'The source of truth. Every ordinary specimen below '
            'reuses FixtureHeader, FixtureMenu, FixtureContent or '
            'FixtureFooter from this composition.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(
                    width: _railColumn,
                    child: DsPanel(
                      label: 'The shared composition',
                      flush: true,
                      child: _PartStage(
                        height: _stageTall,
                        children: <Widget>[
                          _FixtureHeader(),
                          _FixtureContent(),
                          _FixtureFooter(),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: ds(4)),
                  Expanded(
                    child: DsMeta(
                      items: <DsMetaItem>[
                        (
                          k: 'Header',
                          v: const TextSpan(
                            text: 'One workspace button and one SidebarInput.',
                          )
                        ),
                        (
                          k: 'Content',
                          v: const TextSpan(
                            text: 'The only scrolling region; it owns the '
                                'shared groups.',
                          )
                        ),
                        (
                          k: 'Menu',
                          v: const TextSpan(
                            text: 'One FixtureMenu supplies active state, '
                                'counts and tooltips.',
                          )
                        ),
                        (
                          k: 'Footer',
                          v: const TextSpan(
                            text: 'One NavUser composition, pinned by '
                                'SidebarFooter.',
                          )
                        ),
                        (
                          k: 'Spacing',
                          v: const TextSpan(
                            text: 'p-3 regions and groups, gap-1 menus, equal '
                                'X/Y row padding.',
                          )
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: ds(4)),
            const DsNote(
              title: 'No second anatomy',
              child: _NoSecondAnatomy(),
            ),
          ],
        ),
      );
}

class _NoSecondAnatomy extends StatelessWidget {
  const _NoSecondAnatomy();

  @override
  Widget build(BuildContext context) => Text.rich(
        TextSpan(
          children: <InlineSpan>[
            const TextSpan(
              text: 'This page no longer redraws the assembled sidebar with '
                  'private markup. Change ',
            ),
            DsCode.span('FixtureMenu'),
            const TextSpan(
              text: ' or a primitive and every ordinary specimen changes with '
                  'it.',
            ),
          ],
        ),
      );
}

/* ── §2 Header ───────────────────────────────────────────────────────────── */

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) => DsSection(
        id: 'header-input',
        title: 'Header',
        description: 'The same shared header first, followed by the three '
            'supported product patterns.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DsGrid(
              lg: 2,
              children: <Widget>[
                const DsPanel(
                  label: 'Shared workspace header',
                  flush: true,
                  child: _PartStage(children: <Widget>[_FixtureHeader()]),
                ),
                const DsPanel(
                  label: 'Shared header in context',
                  flush: true,
                  child: _PartStage(
                    height: _stageShort,
                    children: <Widget>[_FixtureHeader(), DsSidebarContent()],
                  ),
                ),
              ],
            ),
            SizedBox(height: ds(4)),
            const DsGrid(
              lg: 3,
              children: <Widget>[
                DsPanel(
                  label: 'Team switcher',
                  note: 'sidebar-07',
                  flush: true,
                  child: _PartStage(children: <Widget>[_TeamSwitcherHeader()]),
                ),
                DsPanel(
                  label: 'Version switcher',
                  note: 'sidebar-01',
                  flush: true,
                  child:
                      _PartStage(children: <Widget>[_VersionSwitcherHeader()]),
                ),
                DsPanel(
                  label: 'Search form',
                  note: 'sidebar-05',
                  flush: true,
                  child: _PartStage(children: <Widget>[_SearchFormHeader()]),
                ),
              ],
            ),
          ],
        ),
      );
}

/// `TEAMS` and `VERSIONS`.
const List<({String name, String plan})> _teams = <({String name, String plan})>[
  (name: 'Eclipse Vault', plan: 'Enterprise'),
  (name: 'Acme Corp.', plan: 'Startup'),
  (name: 'Evil Corp.', plan: 'Free'),
];

const List<String> _versions = <String>['1.4.0-beta', '1.3.2', '1.2.9'];

/// *"The tile that stands in for a workspace logo."* `bg-sidebar-primary`,
/// `rounded-md`.
class _Tile extends StatelessWidget {
  const _Tile();

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return SizedBox(
      width: ds(8),
      height: ds(8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.sidebarPrimary,
          borderRadius: BorderRadius.circular(DsRadii.md),
        ),
        child: Center(
          child: DefaultTextStyle.merge(
            style: TextStyle(color: theme.sidebarPrimaryForeground),
            child: const DsIcon.lucide(DsLucide.galleryVerticalEnd),
          ),
        ),
      ),
    );
  }
}

/// *"The pattern from shadcn's sidebar-07 and sidebar-10."*
class _TeamSwitcherHeader extends StatefulWidget {
  const _TeamSwitcherHeader();

  @override
  State<_TeamSwitcherHeader> createState() => _TeamSwitcherHeaderState();
}

class _TeamSwitcherHeaderState extends State<_TeamSwitcherHeader> {
  ({String name, String plan}) _team = _teams.first;

  @override
  Widget build(BuildContext context) => DsSidebarHeader(
        children: <Widget>[
          DsSidebarMenu(
            children: <Widget>[
              DsSidebarMenuItem(
                button: DsDropdownMenu(
                  side: DsPopoverSide.right,
                  align: DsPopoverAlign.start,
                  width: _switcherWidth,
                  children: <DsMenuChild>[
                    const DsMenuLabel('Teams'),
                    for (final ({String name, String plan}) t in _teams)
                      DsMenuItem(
                        label: t.name,
                        onSelect: () => setState(() => _team = t),
                      ),
                    const DsMenuSeparator(),
                    const DsMenuItem(
                      label: 'Add team',
                      icon: DsIconGlyph.plus,
                    ),
                  ],
                  trigger: DsSidebarMenuButton(
                    size: DsSidebarMenuButtonSize.lg,
                    tooltip: _team.name,
                    suppressPressScale: DsDropdownMenu.pressScaleSuppressed,
                    expanded: DsMenuTriggerScope.openOf(context),
                    child: DsSidebarMenuRow(
                      size: DsSidebarMenuButtonSize.lg,
                      leading: const _Tile(),
                      label: _WorkspaceLabel(
                        title: _team.name,
                        subtitle: _team.plan,
                      ),
                      trailing: const DsIcon.lucide(DsLucide.chevronsUpDown),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
}

/// `min-w-56` on the team menu, `min-w-48` on the version menu.
double get _switcherWidth => ds(56);
double get _versionWidth => ds(48);

/// *"The pattern from shadcn's sidebar-01 and sidebar-02."*
class _VersionSwitcherHeader extends StatefulWidget {
  const _VersionSwitcherHeader();

  @override
  State<_VersionSwitcherHeader> createState() => _VersionSwitcherHeaderState();
}

class _VersionSwitcherHeaderState extends State<_VersionSwitcherHeader> {
  String _version = _versions.first;

  @override
  Widget build(BuildContext context) => DsSidebarHeader(
        children: <Widget>[
          DsSidebarMenu(
            children: <Widget>[
              DsSidebarMenuItem(
                button: DsDropdownMenu(
                  side: DsPopoverSide.right,
                  align: DsPopoverAlign.start,
                  width: _versionWidth,
                  children: <DsMenuChild>[
                    for (final String v in _versions)
                      DsMenuItem(
                        label: 'v$v',
                        onSelect: () => setState(() => _version = v),
                      ),
                  ],
                  trigger: DsSidebarMenuButton(
                    size: DsSidebarMenuButtonSize.lg,
                    tooltip: 'Version $_version',
                    suppressPressScale: DsDropdownMenu.pressScaleSuppressed,
                    expanded: DsMenuTriggerScope.openOf(context),
                    child: DsSidebarMenuRow(
                      size: DsSidebarMenuButtonSize.lg,
                      leading: const _Tile(),
                      label: _WorkspaceLabel(
                        title: 'Documentation',
                        subtitle: 'v$_version',
                        subtitleSpec: DsType.numXs,
                      ),
                      trailing: const DsIcon.lucide(DsLucide.chevronsUpDown),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
}

/// *"What makes it a search form rather than a naked input is the label: the
/// field has an accessible name even though nothing visible says 'search'."*
class _SearchFormHeader extends StatelessWidget {
  const _SearchFormHeader();

  @override
  Widget build(BuildContext context) => DsSidebarHeader(
        children: <Widget>[
          Stack(
            alignment: AlignmentDirectional.centerStart,
            children: <Widget>[
              DsSidebarInput(
                placeholder: 'Search the docs…',
                label: 'Search the docs',
                // `pl-8` over the field's own `px-4 py-1`.
                padding: EdgeInsets.only(
                  left: ds(8),
                  right: ds(4),
                  top: ds(1),
                  bottom: ds(1),
                ),
              ),
              // `absolute top-1/2 left-2 -translate-y-1/2`, `size="sm"`.
              Positioned(
                left: ds(2),
                child: IgnorePointer(
                  child: DsIcon(
                    DsIconGlyph.search,
                    size: DsIconSize.sm,
                    tone: DsIconTone.muted,
                  ),
                ),
              ),
            ],
          ),
        ],
      );
}

/* ── §3 Menu ─────────────────────────────────────────────────────────────── */

class _MenuSection extends StatelessWidget {
  const _MenuSection();

  @override
  Widget build(BuildContext context) => DsSection(
        id: 'menu',
        title: 'Menu',
        description: 'The shared menu in a labelled group, an action group and '
            'an unlabelled group. The rows do not change between panels.',
        child: const DsGrid(
          lg: 3,
          children: <Widget>[
            DsPanel(
              label: 'Labelled',
              flush: true,
              child: _PartStage(
                children: <Widget>[
                  DsSidebarCollapsibleGroup(
                    label: 'Collection',
                    toggleLabel: 'Toggle Collection group',
                    child: _FixtureMenu(),
                  ),
                ],
              ),
            ),
            DsPanel(
              label: 'Label + action',
              flush: true,
              child: _PartStage(
                children: <Widget>[
                  DsSidebarCollapsibleGroup(
                    label: 'Collection',
                    toggleLabel: 'Toggle Collection group',
                    action: _AddCollection(),
                    child: _FixtureMenu(),
                  ),
                ],
              ),
            ),
            DsPanel(
              label: 'No label',
              flush: true,
              child: _PartStage(
                children: <Widget>[
                  DsSidebarGroup(
                    children: <Widget>[
                      DsSidebarGroupContent(child: _FixtureMenu()),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

/* ── §4 Menu button variants ─────────────────────────────────────────────── */

class _ButtonVariantsSection extends StatelessWidget {
  const _ButtonVariantsSection();

  @override
  Widget build(BuildContext context) {
    final double glyph = DsButton.iconPxFor(DsSidebarMenuButtonSize.md.button);
    return DsSection(
      id: 'button-variants',
      title: 'Menu button variants',
      description: 'These are intentionally different: each row is the '
          'canonical Button variant placed into the same sidebar geometry.',
      child: DsStateGrid(
        children: <Widget>[
          for (final ({String label, DsButtonVariant variant}) v
              in _buttonVariants)
            DsStateCell(
              label: v.label,
              child: _PartStage(
                children: <Widget>[
                  DsSidebarGroup(
                    children: <Widget>[
                      DsSidebarGroupContent(
                        child: DsSidebarMenu(
                          children: <Widget>[
                            DsSidebarMenuItem(
                              button: DsSidebarMenuButton(
                                variant: v.variant,
                                child: DsSidebarMenuRow(
                                  leading:
                                      DsIcon(_nav.first.glyph, sizePx: glyph),
                                  label: const DsSidebarMenuLabel('All cards'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/* ── §5 Badges and actions ───────────────────────────────────────────────── */

class _RowExtrasSection extends StatelessWidget {
  const _RowExtrasSection();

  @override
  Widget build(BuildContext context) {
    final double glyph = DsButton.iconPxFor(DsSidebarMenuButtonSize.md.button);
    return DsSection(
      id: 'row-extras',
      title: 'Badges and actions',
      description: 'Counts are canonical Badge variants; verbs are canonical '
          'Button variants. Sidebar owns only their placement.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          DsStateGrid(
            cols: 5,
            children: <Widget>[
              for (final ({String label, DsBadgeVariant variant}) v
                  in _badgeVariants)
                DsStateCell(
                  label: v.label,
                  child: _PartStage(
                    children: <Widget>[
                      DsSidebarGroup(
                        children: <Widget>[
                          DsSidebarGroupContent(
                            child: DsSidebarMenu(
                              children: <Widget>[
                                DsSidebarMenuItem(
                                  button: DsSidebarMenuButton(
                                    child: DsSidebarMenuRow(
                                      leading: DsIcon(_nav.first.glyph,
                                          sizePx: glyph),
                                      label: const DsSidebarMenuLabel('Reports'),
                                    ),
                                  ),
                                  badge: DsSidebarMenuBadge(
                                    '3',
                                    variant: v.variant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
          SizedBox(height: ds(4)),
          DsGrid(
            lg: 2,
            children: <Widget>[
              DsPanel(
                label: 'Menu action',
                flush: true,
                child: _PartStage(
                  children: <Widget>[
                    DsSidebarGroup(
                      children: <Widget>[
                        DsSidebarGroupContent(
                          child: DsSidebarMenu(
                            children: <Widget>[
                              DsSidebarMenuItem(
                                button: DsSidebarMenuButton(
                                  child: DsSidebarMenuRow(
                                    leading:
                                        DsIcon(_nav.first.glyph, sizePx: glyph),
                                    label: const DsSidebarMenuLabel('All cards'),
                                  ),
                                ),
                                action: DsSidebarMenuAction(
                                  label: 'Add card',
                                  child: DsIcon(
                                    DsIconGlyph.plus,
                                    sizePx:
                                        DsButton.iconPxFor(DsButtonSize.iconXs),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const DsPanel(
                label: 'Group action',
                flush: true,
                child: _PartStage(
                  children: <Widget>[
                    DsSidebarCollapsibleGroup(
                      label: 'Collection',
                      toggleLabel: 'Toggle Collection group',
                      action: _AddCollection(),
                      child: _FixtureMenu(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/* ── §6 Submenu ──────────────────────────────────────────────────────────── */

class _SubmenuSection extends StatelessWidget {
  const _SubmenuSection();

  @override
  Widget build(BuildContext context) {
    final double glyph = DsButton.iconPxFor(DsSidebarMenuButtonSize.md.button);
    return DsSection(
      id: 'submenu',
      title: 'Submenu',
      description: 'The parent and nested links use the same Button system; '
          'depth comes from the spine and indentation.',
      child: DsPanel(
        label: 'Nested under the shared active row',
        flush: true,
        child: _PartStage(
          children: <Widget>[
            DsSidebarGroup(
              children: <Widget>[
                DsSidebarGroupContent(
                  child: DsSidebarMenu(
                    children: <Widget>[
                      DsSidebarMenuItem(
                        button: DsSidebarMenuButton(
                          isActive: true,
                          child: DsSidebarMenuRow(
                            leading: DsIcon(_nav.first.glyph, sizePx: glyph),
                            label: const DsSidebarMenuLabel('All cards'),
                          ),
                        ),
                        submenu: const DsSidebarMenuSub(
                          children: <Widget>[
                            DsSidebarMenuSubItem(
                              child: DsSidebarMenuSubButton(
                                label: 'Open',
                                isActive: true,
                              ),
                            ),
                            DsSidebarMenuSubItem(
                              child: DsSidebarMenuSubButton(label: 'Settled'),
                            ),
                            DsSidebarMenuSubItem(
                              child: DsSidebarMenuSubButton(label: 'Archived'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/* ── §7 Footer ───────────────────────────────────────────────────────────── */

class _FooterSection extends StatelessWidget {
  const _FooterSection();

  @override
  Widget build(BuildContext context) => DsSection(
        id: 'footer',
        title: 'Footer',
        description: 'SidebarFooter pins the shared NavUser composition to the '
            'panel floor.',
        child: const DsGrid(
          lg: 2,
          children: <Widget>[
            DsPanel(
              label: 'Pinned below empty content',
              flush: true,
              child: _PartStage(
                height: _stageFooter,
                children: <Widget>[
                  _FixtureHeader(),
                  DsSidebarContent(),
                  _FixtureFooter(),
                ],
              ),
            ),
            DsPanel(
              label: 'Pinned below real content',
              flush: true,
              child: _PartStage(
                height: _stageFooter,
                children: <Widget>[_FixtureContent(), _FixtureFooter()],
              ),
            ),
          ],
        ),
      );
}

/* ── §8 Shell ────────────────────────────────────────────────────────────── */

/// *"The one control panel on this page, and the only place one is right."*
///
/// `side`, `variant` and `collapsible` *"change the shell's structure, and
/// three structures do not fit in one frame. The panel is remounted on every
/// change via `key`, so it is rebuilt with the new behaviour rather than
/// animating between two of them."*
class _ShellMatrixDemo extends StatefulWidget {
  const _ShellMatrixDemo();

  @override
  State<_ShellMatrixDemo> createState() => _ShellMatrixDemoState();
}

class _ShellMatrixDemoState extends State<_ShellMatrixDemo> {
  DsSidebarSide _side = DsSidebarSide.left;
  DsSidebarVariant _variant = DsSidebarVariant.sidebar;
  DsSidebarCollapsible _collapsible = DsSidebarCollapsible.icon;

  static const List<String> _sideLabels = <String>['left', 'right'];
  static const List<String> _variantLabels = <String>[
    'sidebar',
    'floating',
    'inset',
  ];
  static const List<String> _collapsibleLabels = <String>[
    'offcanvas',
    'icon',
    'none',
  ];

  @override
  Widget build(BuildContext context) {
    final String label =
        '${_sideLabels[_side.index]} · ${_variantLabels[_variant.index]} · '
        '${_collapsibleLabels[_collapsible.index]}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        // `flex flex-wrap gap-x-8 gap-y-5`.
        Wrap(
          spacing: ds(8),
          runSpacing: ds(5),
          children: <Widget>[
            _Knob(
              label: 'side',
              options: _sideLabels,
              selected: _side.index,
              onChanged: (int i) =>
                  setState(() => _side = DsSidebarSide.values[i]),
            ),
            _Knob(
              label: 'variant',
              options: _variantLabels,
              selected: _variant.index,
              onChanged: (int i) =>
                  setState(() => _variant = DsSidebarVariant.values[i]),
            ),
            _Knob(
              label: 'collapsible',
              options: _collapsibleLabels,
              selected: _collapsible.index,
              onChanged: (int i) =>
                  setState(() => _collapsible = DsSidebarCollapsible.values[i]),
            ),
          ],
        ),
        // `gap-5`.
        SizedBox(height: ds(5)),
        KeyedSubtree(
          key: ValueKey<String>(label),
          child: _ShellStage(
            variant: _variant,
            children: <Widget>[
              DsSidebar(
                side: _side,
                variant: _variant,
                collapsible: _collapsible,
                children: <Widget>[
                  const _DemoNav(),
                  if (_collapsible != DsSidebarCollapsible.none)
                    const DsSidebarRail(),
                ],
              ),
              DsSidebarInset(child: _InsetHeader(label: label)),
            ],
          ),
        ),
      ],
    );
  }
}

/// One labelled row of `default` / `outline` buttons.
class _Knob extends StatelessWidget {
  const _Knob({
    required this.label,
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  final String label;
  final List<String> options;
  final int selected;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          DsText(label, DsType.caption),
          SizedBox(height: ds(2)),
          Wrap(
            spacing: ds(2),
            runSpacing: ds(2),
            children: <Widget>[
              for (int i = 0; i < options.length; i++)
                DsButton(
                  size: DsButtonSize.sm,
                  variant: i == selected
                      ? DsButtonVariant.primary
                      : DsButtonVariant.outline,
                  onPressed: () => onChanged(i),
                  child: Text(options[i]),
                ),
            ],
          ),
        ],
      );
}

/// The shared body of every shell specimen.
class _DemoNav extends StatelessWidget {
  const _DemoNav();

  @override
  Widget build(BuildContext context) {
    final double glyph = DsButton.iconPxFor(DsSidebarMenuButtonSize.md.button);
    return DsSidebarContent(
      children: <Widget>[
        DsSidebarGroup(
          children: <Widget>[
            DsSidebarGroupContent(
              child: DsSidebarMenu(
                children: <Widget>[
                  for (final ({String label, DsIconGlyph glyph, String? count})
                      item in _nav)
                    DsSidebarMenuItem(
                      button: DsSidebarMenuButton(
                        tooltip: item.label,
                        child: DsSidebarMenuRow(
                          leading: DsIcon(item.glyph, sizePx: glyph),
                          label: DsSidebarMenuLabel(item.label),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// `header.flex.h-16.shrink-0.items-center.gap-3.border-b.border-border.px-6`.
class _InsetHeader extends StatelessWidget {
  const _InsetHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          height: DsWidths.siteHeader,
          padding: EdgeInsets.symmetric(horizontal: ds(6)),
          decoration: BoxDecoration(
            border: Border(
              bottom:
                  BorderSide(color: theme.border, width: DsWidths.hairline),
            ),
          ),
          child: Row(
            children: <Widget>[
              const DsSidebarTrigger(),
              SizedBox(width: ds(3)),
              DsText(label, DsType.label),
            ],
          ),
        ),
      ],
    );
  }
}

class _ShellSection extends StatelessWidget {
  const _ShellSection();

  @override
  Widget build(BuildContext context) => DsSection(
        id: 'shell',
        title: 'Shell',
        description:
            'One interactive shell matrix owns side, variant and collapse '
            'behavior.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const _ShellMatrixDemo(),
            SizedBox(height: ds(4)),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: DsButton(
                variant: DsButtonVariant.outline,
                // DRIFT 10: `/sidebar-demo` is not a route this port carries.
                onPressed: () {},
                child: const Text('Open the full-viewport sidebar'),
              ),
            ),
          ],
        ),
      );
}

/* ── §9 Contract ─────────────────────────────────────────────────────────── */

class _ContractSection extends StatelessWidget {
  const _ContractSection();

  @override
  Widget build(BuildContext context) => const DsSection(
        id: 'contract',
        title: 'Contract',
        child: DsDoDont(
          dos: <String>[
            'Change the primitives or the shared fixture, never a private '
                'specimen copy.',
            'Use Button variants for actions and Badge variants for counts.',
            'Keep SidebarFooter as the final region; it pins itself with '
                'mt-auto.',
            'Give every collapsible menu row a tooltip.',
          ],
          donts: <String>[
            'Do not recreate active, hover or focus visuals in page-only '
                'markup.',
            'Do not hand-paint a sidebar-only badge or action.',
            'Do not maintain a second anatomy composition.',
            'Do not compensate for primitive spacing in specimen wrappers.',
          ],
        ),
      );
}

/* ── The page ────────────────────────────────────────────────────────────── */

/// The sidebar page.
class SidebarPage extends StatelessWidget {
  const SidebarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final DsCategoryHit here = findCategory('base', 'sidebar');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DsPageHeader(
          eyebrow: '${here.group.title} · Base',
          title: here.category.title,
          blurb: 'One sidebar system, rendered repeatedly from one '
              'composition. Variants differ only when the section is '
              'explicitly demonstrating a canonical Button or Badge variant.',
          // DRIFT 1: twenty-one component names over nine sections.
          contents: here.category.contents,
        ),
        const _AnatomySection(),
        const _HeaderSection(),
        const _MenuSection(),
        const _ButtonVariantsSection(),
        const _RowExtrasSection(),
        const _SubmenuSection(),
        const _FooterSection(),
        const _ShellSection(),
        const _ContractSection(),
        const DsPageFootNav(groupId: 'base', slug: 'sidebar'),
      ],
    );
  }
}
