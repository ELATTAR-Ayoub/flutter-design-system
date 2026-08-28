/// `/design-system/components/base/sidebar`, *"the app shell, taken apart."*
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
/// `PartStage` is `collapsible="none"`, *"the one mode upstream renders as a
/// plain flex column: the real component, carrying the real tokens, with no
/// fixed positioning and no viewport dependency."* Every resting specimen sits
/// in one.
///
/// `ShellStage` is the whole shell, boxed. On the reference `transform-gpu`
/// traps a genuinely `position: fixed` panel inside a 384px frame, *"CSS doing
/// its documented job rather than a hack, and it is the whole reason
/// `SidebarRail` and `SidebarInset` can be documented in a panel instead of
/// behind a link."* The port needs no trap: [Sidebar] renders its container
/// as an overflowing child of its own gap, and this frame clips it.
///
/// ## Oracle (light, 1440 × 900, 2026-08-16)
///
/// `node tool/verify/section-oracle.js /design-system/components/base/sidebar`
///: document `scrollHeight` **5644**, `main` 64 → 5579.7. Section tops and
/// border-box heights are pinned in `example/test/sidebar_page_test.dart`.
///
/// ## Drift register: reproduced, recorded, never fixed
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
///     (12/500): measured 12px at 500, mono, tabular. Carried by
///     [TextStyles.sidebarMenuBadge].
///  4. **`NavUser`'s avatar fallback splits the difference**, 13px from
///     `text-sm`, 600 from `.type-num-sm`, mono from `.type-num-sm`.
///  5. **Every row on the page is a `<button>` with no `onClick`.** The active
///     row is fixed by prop, so the travelling pill never travels here: it
///     places once, squashes once, and stays. Reproduced exactly: the rows
///     answer a pointer (hover, press, focus) and change nothing.
///  6. **The pill lands on the parent row in §Submenu, not on the list item.**
///     Both the parent and the "Open" sub-link carry `data-active`;
///     `querySelector` takes the first, so the 149.5px item holds a 37.5px
///     pill.
///  7. **`SidebarMenuAction` appears exactly once**, in §Badges and actions,
///     and `showOnHover` is never passed: so the `md:opacity-0` branch is
///     declared and unreachable from this page.
///  8. **`SidebarMenuSkeleton` is exported and never rendered.** It is in
///     `contents`; no section shows one.
///  9. **`SidebarInput` is `h-8 bg-background shadow-none`**: the one field in
///     the system with no socket. It reads as a well only because the panel
///     around it is `--sidebar`.
/// 10. **~~The shell link goes nowhere here.~~, CLOSED.** *"Open the
///     full-viewport sidebar"* points at `/sidebar-demo`, which the port now
///     carries: `pages/sidebar_demo.dart`, mounted outside [DocsShell] by the
///     one route arm in `main.dart` that renders no docs chrome. The button
///     navigates. Kept in the register rather than deleted, because the drift
///     was real for two phases and the entry is where its close is recorded.
/// 11. **`duration-base` is inert, five times over**: closed corpus-wide by
///     the sweep. All five sites still run 250ms, because
///     `--default-transition-duration` **is** `--duration-base`.
/// 12. **The `sidebar_state` cookie has no counterpart**, and the readout copy
///     that mentions it is not on this page: the page shows the shell matrix
///     only.
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

import '../kit.dart';
import '../nav.dart';
import '../shell.dart';
import 'sidebar_demo.dart';

/* ── Fixtures ────────────────────────────────────────────────────────────── */

/// *"One product across every specimen, so the page reads as a thing rather
/// than a parts bin."*
const List<({String label, IconGlyph glyph, String? count})> _nav =
    <({String label, IconGlyph glyph, String? count})>[
      (label: 'All cards', glyph: IconGlyph.layers, count: '1,284'),
      (label: 'Favourites', glyph: IconGlyph.star, count: '37'),
      (label: 'New this week', glyph: IconGlyph.sparkles, count: null),
      (label: 'Wallet', glyph: IconGlyph.wallet, count: null),
    ];

/// `FOOT_NAV`. `Receipt` is not on the icons page's curated whitelist, so it
/// comes off the generated registry: the same split `Icon.lucide` carries.
const List<({String label, IconGlyph? glyph, LucideGlyph? lucide})> _footNav =
    <({String label, IconGlyph? glyph, LucideGlyph? lucide})>[
      (label: 'Orders', glyph: null, lucide: Lucide.receipt),
      (label: 'Alerts', glyph: IconGlyph.bell, lucide: null),
      (label: 'Settings', glyph: IconGlyph.settings, lucide: null),
    ];

/// `ACCOUNT`, *"the account the footer specimens show. Sample data, never a
/// default."*
const UserMenuAccount _account = UserMenuAccount(
  name: 'Ayoub Elattar',
  email: 'ayoub@eclipsevault.example',
);

/// `ACCOUNT_ITEMS`.
const List<UserMenuItem> _accountItems = <UserMenuItem>[
  UserMenuItem(label: 'Account', icon: Lucide.badgeCheck),
  UserMenuItem(label: 'Billing', icon: Lucide.creditCard),
  UserMenuItem(label: 'Notifications', icon: Lucide.bell),
  UserMenuItem(label: 'Sign out', icon: Lucide.logOut, destructive: true),
];

/// `BUTTON_VARIANTS`, in the page's own order, `ghost` first, `default`
/// second.
const List<({String label, ButtonVariant variant})> _buttonVariants =
    <({String label, ButtonVariant variant})>[
      (label: 'ghost', variant: ButtonVariant.ghost),
      (label: 'default', variant: ButtonVariant.primary),
      (label: 'premium', variant: ButtonVariant.premium),
      (label: 'secondary', variant: ButtonVariant.secondary),
      (label: 'outline', variant: ButtonVariant.outline),
      (label: 'destructive', variant: ButtonVariant.destructive),
      (label: 'link', variant: ButtonVariant.link),
    ];

/// `BADGE_VARIANTS`.
const List<({String label, BadgeVariant variant})> _badgeVariants =
    <({String label, BadgeVariant variant})>[
      (label: 'default', variant: BadgeVariant.primary),
      (label: 'secondary', variant: BadgeVariant.secondary),
      (label: 'destructive', variant: BadgeVariant.destructive),
      (label: 'outline', variant: BadgeVariant.outline),
      (label: 'ghost', variant: BadgeVariant.ghost),
      (label: 'link', variant: BadgeVariant.link),
      (label: 'action', variant: BadgeVariant.action),
      (label: 'premium', variant: BadgeVariant.premium),
      (label: 'success', variant: BadgeVariant.success),
      (label: 'warning', variant: BadgeVariant.warning),
      (label: 'info', variant: BadgeVariant.info),
    ];

/// `h-160`: the anatomy stage. 640px.
const double _stageTall = 640;

/// `h-40`: the header-in-context stage. 160px.
const double _stageShort = 160;

/// `h-80`: the two footer stages. 320px.
const double _stageFooter = 320;

/// `h-96`: the shell frame. 384px.
const double _shellHeight = 384;

/// `lg:grid-cols-[20rem_1fr]`: the anatomy's fixed first column, 20rem.
// allow-hardcoded: framework rem measure with no token to read it from.
const double _railColumn = 320;

/* ── Stages ──────────────────────────────────────────────────────────────── */

/// `PartStage`: one part, shown on its own.
///
/// Upstream this is a `SidebarProvider` at `min-h-0 w-auto` around a
/// `Sidebar collapsible="none"` at `rounded-lg border border-sidebar-border`,
/// and **every call site on the page passes `rounded-none border-0`**: so the
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
    final Widget stage = SidebarProvider(
      children: <Widget>[
        Expanded(
          child: Sidebar(
            collapsible: SidebarCollapsible.none,
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

/// `ShellStage`: the whole shell, boxed.
class _ShellStage extends StatelessWidget {
  const _ShellStage({required this.children, required this.variant});

  final List<Widget> children;

  /// See [SidebarProvider.variant]: the wrapper's `has-data-[variant=inset]`
  /// fill and the inset's `peer-data-[variant=inset]` margins are relational
  /// selectors, so the fact travels down rather than up.
  final SidebarVariant variant;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return SizedBox(
      height: _shellHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Radii.lg),
          border: Border.all(color: theme.border, width: BorderWidths.hairline),
        ),
        // `box-sizing: border-box`: the frame is paid out of the 384.
        child: Padding(
          padding: const EdgeInsets.all(BorderWidths.hairline),
          child: ClipRRect(
            // `overflow-hidden`, and what clips the collapsing panel.
            borderRadius: BorderRadius.circular(
              Radii.lg - BorderWidths.hairline,
            ),
            child: SidebarProvider(variant: variant, children: children),
          ),
        ),
      ),
    );
  }
}

/* ── The shared composition ──────────────────────────────────────────────── */

/// `FixtureHeader`, *"one workspace button and one SidebarInput."*
class _FixtureHeader extends StatelessWidget {
  const _FixtureHeader();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return SidebarHeader(
      children: <Widget>[
        SidebarMenu(
          children: <Widget>[
            SidebarMenuItem(
              button: SidebarMenuButton(
                size: SidebarMenuButtonSize.lg,
                tooltip: 'Eclipse Vault workspace',
                child: SidebarMenuRow(
                  size: SidebarMenuButtonSize.lg,
                  // `type-num-sm flex size-8 shrink-0 items-center
                  //  justify-center rounded-lg bg-secondary text-foreground
                  //  shadow-chip`.
                  leading: SizedBox(
                    width: space(8),
                    height: space(8),
                    child: Surface(
                      spec: Shadows.compactControl,
                      radius: BorderRadius.circular(Radii.lg),
                      fill: theme.secondary,
                      child: Center(
                        child: StyledText(
                          'EV',
                          TextStyles.numberSm,
                          color: theme.foreground,
                        ),
                      ),
                    ),
                  ),
                  label: const _WorkspaceLabel(
                    title: 'Eclipse Vault',
                    subtitle: '12 members',
                  ),
                  trailing: const Icon.lucide(Lucide.chevronsUpDown),
                ),
              ),
            ),
          ],
        ),
        const SidebarInput(placeholder: 'Search cards', label: 'Search cards'),
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
  final TextStyleToken? subtitleSpec;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        StyledText(
          title,
          TextStyles.nav,
          color: theme.foreground,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
        ),
        StyledText(
          subtitle,
          subtitleSpec ?? TextStyles.caption,
          color: theme.mutedForeground,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
        ),
      ],
    );
  }
}

/// `FixtureMenu`, *"every non-variant specimen uses this exact function."*
class _FixtureMenu extends StatelessWidget {
  const _FixtureMenu();

  /// `activeLabel = NAV[0].label`: the page never overrides either default,
  /// so both are stated once here rather than carried as unused props.
  static const String activeLabel = 'All cards';

  /// `badges = true`.
  static const bool badges = true;

  @override
  Widget build(BuildContext context) {
    final double glyph = Button.iconPxFor(SidebarMenuButtonSize.md.button);
    return SidebarMenu(
      children: <Widget>[
        for (final ({String label, IconGlyph glyph, String? count}) item
            in _nav)
          SidebarMenuItem(
            button: SidebarMenuButton(
              isActive: item.label == activeLabel,
              tooltip: item.label,
              child: SidebarMenuRow(
                leading: Icon(item.glyph, sizePx: glyph),
                label: SidebarMenuLabel(item.label),
              ),
            ),
            badge: badges && item.count != null
                ? SidebarMenuBadge(item.count!)
                : null,
          ),
      ],
    );
  }
}

/// The `FOOT_NAV` menu: the second group of `FixtureContent`.
class _ActivityMenu extends StatelessWidget {
  const _ActivityMenu();

  @override
  Widget build(BuildContext context) {
    final double glyph = Button.iconPxFor(SidebarMenuButtonSize.md.button);
    return SidebarMenu(
      children: <Widget>[
        for (final ({String label, IconGlyph? glyph, LucideGlyph? lucide}) item
            in _footNav)
          SidebarMenuItem(
            button: SidebarMenuButton(
              tooltip: item.label,
              child: SidebarMenuRow(
                leading: item.glyph != null
                    ? Icon(item.glyph!, sizePx: glyph)
                    : Icon.lucide(item.lucide!, sizePx: glyph),
                label: SidebarMenuLabel(item.label),
              ),
            ),
          ),
      ],
    );
  }
}

/// `FixtureContent`, *"no section owns a private copy of these groups."*
class _FixtureContent extends StatelessWidget {
  const _FixtureContent();

  @override
  Widget build(BuildContext context) => SidebarContent(
    children: <Widget>[
      SidebarCollapsibleGroup(
        label: 'Collection',
        toggleLabel: 'Toggle Collection group',
        action: const _AddCollection(),
        child: const _FixtureMenu(),
      ),
      const SidebarSeparator(),
      const SidebarCollapsibleGroup(
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
  Widget build(BuildContext context) => SidebarGroupAction(
    label: 'Add collection',
    child: Icon(IconGlyph.plus, sizePx: Button.iconPxFor(ButtonSize.iconXs)),
  );
}

/// `FixtureFooter`, *"one NavUser composition, pinned by SidebarFooter."*
class _FixtureFooter extends StatelessWidget {
  const _FixtureFooter();

  @override
  Widget build(BuildContext context) => const SidebarFooter(
    children: <Widget>[UserMenu(user: _account, items: _accountItems)],
  );
}

/* ── §1 Complete sidebar ─────────────────────────────────────────────────── */

class _AnatomySection extends StatelessWidget {
  const _AnatomySection();

  @override
  Widget build(BuildContext context) => Section(
    id: 'anatomy',
    title: 'Complete sidebar',
    description:
        'The source of truth. Every ordinary specimen below '
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
                child: Panel(
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
              SizedBox(width: space(4)),
              Expanded(
                child: Meta(
                  items: <MetaItem>[
                    (
                      k: 'Header',
                      v: const TextSpan(
                        text: 'One workspace button and one SidebarInput.',
                      ),
                    ),
                    (
                      k: 'Content',
                      v: const TextSpan(
                        text:
                            'The only scrolling region; it owns the '
                            'shared groups.',
                      ),
                    ),
                    (
                      k: 'Menu',
                      v: const TextSpan(
                        text:
                            'One FixtureMenu supplies active state, '
                            'counts and tooltips.',
                      ),
                    ),
                    (
                      k: 'Footer',
                      v: const TextSpan(
                        text:
                            'One NavUser composition, pinned by '
                            'SidebarFooter.',
                      ),
                    ),
                    (
                      k: 'Spacing',
                      v: const TextSpan(
                        text:
                            'p-3 regions and groups, gap-1 menus, equal '
                            'X/Y row padding.',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: space(4)),
        const Note(title: 'No second anatomy', child: _NoSecondAnatomy()),
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
          text:
              'This page no longer redraws the assembled sidebar with '
              'private markup. Change ',
        ),
        Code.span('FixtureMenu'),
        const TextSpan(
          text:
              ' or a primitive and every ordinary specimen changes with '
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
  Widget build(BuildContext context) => Section(
    id: 'header-input',
    title: 'Header',
    description:
        'The same shared header first, followed by the three '
        'supported product patterns.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Grid(
          lg: 2,
          children: <Widget>[
            const Panel(
              label: 'Shared workspace header',
              flush: true,
              child: _PartStage(children: <Widget>[_FixtureHeader()]),
            ),
            const Panel(
              label: 'Shared header in context',
              flush: true,
              child: _PartStage(
                height: _stageShort,
                children: <Widget>[_FixtureHeader(), SidebarContent()],
              ),
            ),
          ],
        ),
        SizedBox(height: space(4)),
        const Grid(
          lg: 3,
          children: <Widget>[
            Panel(
              label: 'Team switcher',
              note: 'sidebar-07',
              flush: true,
              child: _PartStage(children: <Widget>[_TeamSwitcherHeader()]),
            ),
            Panel(
              label: 'Version switcher',
              note: 'sidebar-01',
              flush: true,
              child: _PartStage(children: <Widget>[_VersionSwitcherHeader()]),
            ),
            Panel(
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
const List<({String name, String plan})> _teams =
    <({String name, String plan})>[
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
    final ThemeTokens theme = ThemeScope.of(context);
    return SizedBox(
      width: space(8),
      height: space(8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.sidebarPrimary,
          borderRadius: BorderRadius.circular(Radii.md),
        ),
        child: Center(
          child: DefaultTextStyle.merge(
            style: TextStyle(color: theme.sidebarPrimaryForeground),
            child: const Icon.lucide(Lucide.galleryVerticalEnd),
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
  Widget build(BuildContext context) => SidebarHeader(
    children: <Widget>[
      SidebarMenu(
        children: <Widget>[
          SidebarMenuItem(
            button: DropdownMenu(
              side: PopoverSide.right,
              align: PopoverAlign.start,
              width: _switcherWidth,
              children: <MenuChild>[
                const MenuLabel('Teams'),
                for (final ({String name, String plan}) t in _teams)
                  MenuItem(
                    label: t.name,
                    onSelect: () => setState(() => _team = t),
                  ),
                const MenuSeparator(),
                const MenuItem(label: 'Add team', icon: IconGlyph.plus),
              ],
              trigger: SidebarMenuButton(
                size: SidebarMenuButtonSize.lg,
                tooltip: _team.name,
                suppressPressScale: DropdownMenu.pressScaleSuppressed,
                expanded: MenuTriggerScope.openOf(context),
                child: SidebarMenuRow(
                  size: SidebarMenuButtonSize.lg,
                  leading: const _Tile(),
                  label: _WorkspaceLabel(
                    title: _team.name,
                    subtitle: _team.plan,
                  ),
                  trailing: const Icon.lucide(Lucide.chevronsUpDown),
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
double get _switcherWidth => space(56);
double get _versionWidth => space(48);

/// *"The pattern from shadcn's sidebar-01 and sidebar-02."*
class _VersionSwitcherHeader extends StatefulWidget {
  const _VersionSwitcherHeader();

  @override
  State<_VersionSwitcherHeader> createState() => _VersionSwitcherHeaderState();
}

class _VersionSwitcherHeaderState extends State<_VersionSwitcherHeader> {
  String _version = _versions.first;

  @override
  Widget build(BuildContext context) => SidebarHeader(
    children: <Widget>[
      SidebarMenu(
        children: <Widget>[
          SidebarMenuItem(
            button: DropdownMenu(
              side: PopoverSide.right,
              align: PopoverAlign.start,
              width: _versionWidth,
              children: <MenuChild>[
                for (final String v in _versions)
                  MenuItem(
                    label: 'v$v',
                    onSelect: () => setState(() => _version = v),
                  ),
              ],
              trigger: SidebarMenuButton(
                size: SidebarMenuButtonSize.lg,
                tooltip: 'Version $_version',
                suppressPressScale: DropdownMenu.pressScaleSuppressed,
                expanded: MenuTriggerScope.openOf(context),
                child: SidebarMenuRow(
                  size: SidebarMenuButtonSize.lg,
                  leading: const _Tile(),
                  label: _WorkspaceLabel(
                    title: 'Documentation',
                    subtitle: 'v$_version',
                    subtitleSpec: TextStyles.numberXs,
                  ),
                  trailing: const Icon.lucide(Lucide.chevronsUpDown),
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
  Widget build(BuildContext context) => SidebarHeader(
    children: <Widget>[
      Stack(
        alignment: AlignmentDirectional.centerStart,
        children: <Widget>[
          SidebarInput(
            placeholder: 'Search the docs…',
            label: 'Search the docs',
            // `pl-8` over the field's own `px-4 py-1`.
            padding: EdgeInsets.only(
              left: space(8),
              right: space(4),
              top: space(1),
              bottom: space(1),
            ),
          ),
          // `absolute top-1/2 left-2 -translate-y-1/2`, `size="sm"`.
          Positioned(
            left: space(2),
            child: IgnorePointer(
              child: Icon(
                IconGlyph.search,
                size: IconSize.sm,
                tone: IconTone.muted,
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
  Widget build(BuildContext context) => Section(
    id: 'menu',
    title: 'Menu',
    description:
        'The shared menu in a labelled group, an action group and '
        'an unlabelled group. The rows do not change between panels.',
    child: const Grid(
      lg: 3,
      children: <Widget>[
        Panel(
          label: 'Labelled',
          flush: true,
          child: _PartStage(
            children: <Widget>[
              SidebarCollapsibleGroup(
                label: 'Collection',
                toggleLabel: 'Toggle Collection group',
                child: _FixtureMenu(),
              ),
            ],
          ),
        ),
        Panel(
          label: 'Label + action',
          flush: true,
          child: _PartStage(
            children: <Widget>[
              SidebarCollapsibleGroup(
                label: 'Collection',
                toggleLabel: 'Toggle Collection group',
                action: _AddCollection(),
                child: _FixtureMenu(),
              ),
            ],
          ),
        ),
        Panel(
          label: 'No label',
          flush: true,
          child: _PartStage(
            children: <Widget>[
              SidebarGroup(
                children: <Widget>[SidebarGroupContent(child: _FixtureMenu())],
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
    final double glyph = Button.iconPxFor(SidebarMenuButtonSize.md.button);
    return Section(
      id: 'button-variants',
      title: 'Menu button variants',
      description:
          'These are intentionally different: each row is the '
          'canonical Button variant placed into the same sidebar geometry.',
      child: StateGrid(
        children: <Widget>[
          for (final ({String label, ButtonVariant variant}) v
              in _buttonVariants)
            StateCell(
              label: v.label,
              child: _PartStage(
                children: <Widget>[
                  SidebarGroup(
                    children: <Widget>[
                      SidebarGroupContent(
                        child: SidebarMenu(
                          children: <Widget>[
                            SidebarMenuItem(
                              button: SidebarMenuButton(
                                variant: v.variant,
                                child: SidebarMenuRow(
                                  leading: Icon(
                                    _nav.first.glyph,
                                    sizePx: glyph,
                                  ),
                                  label: const SidebarMenuLabel('All cards'),
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
    final double glyph = Button.iconPxFor(SidebarMenuButtonSize.md.button);
    return Section(
      id: 'row-extras',
      title: 'Badges and actions',
      description:
          'Counts are canonical Badge variants; verbs are canonical '
          'Button variants. Sidebar owns only their placement.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          StateGrid(
            cols: 5,
            children: <Widget>[
              for (final ({String label, BadgeVariant variant}) v
                  in _badgeVariants)
                StateCell(
                  label: v.label,
                  child: _PartStage(
                    children: <Widget>[
                      SidebarGroup(
                        children: <Widget>[
                          SidebarGroupContent(
                            child: SidebarMenu(
                              children: <Widget>[
                                SidebarMenuItem(
                                  button: SidebarMenuButton(
                                    child: SidebarMenuRow(
                                      leading: Icon(
                                        _nav.first.glyph,
                                        sizePx: glyph,
                                      ),
                                      label: const SidebarMenuLabel('Reports'),
                                    ),
                                  ),
                                  badge: SidebarMenuBadge(
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
          SizedBox(height: space(4)),
          Grid(
            lg: 2,
            children: <Widget>[
              Panel(
                label: 'Menu action',
                flush: true,
                child: _PartStage(
                  children: <Widget>[
                    SidebarGroup(
                      children: <Widget>[
                        SidebarGroupContent(
                          child: SidebarMenu(
                            children: <Widget>[
                              SidebarMenuItem(
                                button: SidebarMenuButton(
                                  child: SidebarMenuRow(
                                    leading: Icon(
                                      _nav.first.glyph,
                                      sizePx: glyph,
                                    ),
                                    label: const SidebarMenuLabel('All cards'),
                                  ),
                                ),
                                action: SidebarMenuAction(
                                  label: 'Add card',
                                  child: Icon(
                                    IconGlyph.plus,
                                    sizePx: Button.iconPxFor(ButtonSize.iconXs),
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
              const Panel(
                label: 'Group action',
                flush: true,
                child: _PartStage(
                  children: <Widget>[
                    SidebarCollapsibleGroup(
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
    final double glyph = Button.iconPxFor(SidebarMenuButtonSize.md.button);
    return Section(
      id: 'submenu',
      title: 'Submenu',
      description:
          'The parent and nested links use the same Button system; '
          'depth comes from the spine and indentation.',
      child: Panel(
        label: 'Nested under the shared active row',
        flush: true,
        child: _PartStage(
          children: <Widget>[
            SidebarGroup(
              children: <Widget>[
                SidebarGroupContent(
                  child: SidebarMenu(
                    children: <Widget>[
                      SidebarMenuItem(
                        button: SidebarMenuButton(
                          isActive: true,
                          child: SidebarMenuRow(
                            leading: Icon(_nav.first.glyph, sizePx: glyph),
                            label: const SidebarMenuLabel('All cards'),
                          ),
                        ),
                        submenu: const SidebarMenuSub(
                          children: <Widget>[
                            SidebarMenuSubItem(
                              child: SidebarMenuSubButton(
                                label: 'Open',
                                isActive: true,
                              ),
                            ),
                            SidebarMenuSubItem(
                              child: SidebarMenuSubButton(label: 'Settled'),
                            ),
                            SidebarMenuSubItem(
                              child: SidebarMenuSubButton(label: 'Archived'),
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
  Widget build(BuildContext context) => Section(
    id: 'footer',
    title: 'Footer',
    description:
        'SidebarFooter pins the shared NavUser composition to the '
        'panel floor.',
    child: const Grid(
      lg: 2,
      children: <Widget>[
        Panel(
          label: 'Pinned below empty content',
          flush: true,
          child: _PartStage(
            height: _stageFooter,
            children: <Widget>[
              _FixtureHeader(),
              SidebarContent(),
              _FixtureFooter(),
            ],
          ),
        ),
        Panel(
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
  SidebarSide _side = SidebarSide.left;
  SidebarVariant _variant = SidebarVariant.sidebar;
  SidebarCollapsible _collapsible = SidebarCollapsible.icon;

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
          spacing: space(8),
          runSpacing: space(5),
          children: <Widget>[
            _Knob(
              label: 'side',
              options: _sideLabels,
              selected: _side.index,
              onChanged: (int i) =>
                  setState(() => _side = SidebarSide.values[i]),
            ),
            _Knob(
              label: 'variant',
              options: _variantLabels,
              selected: _variant.index,
              onChanged: (int i) =>
                  setState(() => _variant = SidebarVariant.values[i]),
            ),
            _Knob(
              label: 'collapsible',
              options: _collapsibleLabels,
              selected: _collapsible.index,
              onChanged: (int i) =>
                  setState(() => _collapsible = SidebarCollapsible.values[i]),
            ),
          ],
        ),
        // `gap-5`.
        SizedBox(height: space(5)),
        KeyedSubtree(
          key: ValueKey<String>(label),
          child: _ShellStage(
            variant: _variant,
            children: <Widget>[
              Sidebar(
                side: _side,
                variant: _variant,
                collapsible: _collapsible,
                children: <Widget>[
                  const _DemoNav(),
                  if (_collapsible != SidebarCollapsible.none)
                    const SidebarRail(),
                ],
              ),
              SidebarInset(child: _InsetHeader(label: label)),
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
      StyledText(label, TextStyles.caption),
      SizedBox(height: space(2)),
      Wrap(
        spacing: space(2),
        runSpacing: space(2),
        children: <Widget>[
          for (int i = 0; i < options.length; i++)
            Button(
              size: ButtonSize.sm,
              variant: i == selected
                  ? ButtonVariant.primary
                  : ButtonVariant.outline,
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
    final double glyph = Button.iconPxFor(SidebarMenuButtonSize.md.button);
    return SidebarContent(
      children: <Widget>[
        SidebarGroup(
          children: <Widget>[
            SidebarGroupContent(
              child: SidebarMenu(
                children: <Widget>[
                  for (final ({String label, IconGlyph glyph, String? count})
                      item
                      in _nav)
                    SidebarMenuItem(
                      button: SidebarMenuButton(
                        tooltip: item.label,
                        child: SidebarMenuRow(
                          leading: Icon(item.glyph, sizePx: glyph),
                          label: SidebarMenuLabel(item.label),
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
    final ThemeTokens theme = ThemeScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          height: LayoutHeights.siteHeader,
          padding: EdgeInsets.symmetric(horizontal: space(6)),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: theme.border,
                width: BorderWidths.hairline,
              ),
            ),
          ),
          child: Row(
            children: <Widget>[
              const SidebarTrigger(),
              SizedBox(width: space(3)),
              StyledText(label, TextStyles.eyebrow),
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
  Widget build(BuildContext context) => Section(
    id: 'shell',
    title: 'Shell',
    description:
        'One interactive shell matrix owns side, variant and collapse '
        'behavior.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const _ShellMatrixDemo(),
        SizedBox(height: space(4)),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Button(
            variant: ButtonVariant.outline,
            // `asChild` + `<Link href="/sidebar-demo">`: the B4
            // divergence, so the href is the button's own handler.
            onPressed: () => AppRouter.of(context).navigate(sidebarDemoRoute),
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
  Widget build(BuildContext context) => const Section(
    id: 'contract',
    title: 'Contract',
    child: DoDont(
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
    final CategoryHit here = findCategory('base', 'sidebar');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        PageHeader(
          eyebrow: '${here.group.title} · Base',
          title: here.category.title,
          blurb:
              'One sidebar system, rendered repeatedly from one '
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
        const PageFootNav(groupId: 'base', slug: 'sidebar'),
      ],
    );
  }
}
