/// `/sidebar-demo`, *"the live sidebar, and the one design-system page that is
/// not under `/design-system`."*
///
/// The reference's own note explains why it lives where it does, and every word
/// of it survives the port: *"a real `Sidebar` is `fixed inset-y-0 h-svh`, an
/// app shell rather than a widget. That rules out a `Panel`, and it also rules
/// out any route under `app/design-system/layout.tsx`: that layout supplies the
/// docs chrome, including `Sidebar` and a 1080px reading column, and a nested
/// route in Next cannot opt out of a parent layout. Rendering there would drop a
/// fixed sidebar on top of the documentation's own one."* Flutter has the same
/// problem and the same shape of answer: [DocsShell] is a widget rather than a
/// layout file, so this page is mounted **beside** it in `main.dart` instead of
/// inside it: the single route arm that renders no docs chrome at all.
///
/// *"This route is the only place the four things that genuinely need a viewport
/// can be shown: collapsing, the rail, the mobile sheet, ⌘B."*
///
/// ## What the port does with `min-h-svh`
///
/// The reference's shell is as tall as the viewport and the **document** scrolls
/// past it. Flutter's home widget is handed the screen and nothing scrolls
/// behind it, so the inset's body is the scroller instead: the panel and the
/// 64px header stay put and only the content column moves. That is what a
/// `fixed inset-y-0 h-svh` sidebar renders as once the page around it is a
/// window rather than a document, and it is the same reading either way at the
/// 900px frame the port is verified at.
///
/// ## Drift register: reproduced, recorded, never fixed
///
///  1. **Readout 4 describes a cookie the port does not have.** *"The open state
///     is written to a cookie for seven days, so a reload keeps it. Toggle it and
///     refresh."* `sidebar.dart`'s own drift 6 says the provider's
///     `sidebar_state` cookie has no counterpart here: there is no store to put
///     one in. The copy ships as written, which is the standing rule for prose
///     the port cannot make true.
///  2. **Six of the demo's glyphs are off the generated registry.**
///     `CircleGauge`, `Funnel`, `Users`, `Receipt`, `ChevronsUpDown` and
///     `BookOpen` are not on the icons page's curated whitelist, so they come
///     through [Icon.lucide]: the same split the sidebar page's own `FOOT_NAV`
///     carries for `Receipt`.
///  3. **`group-data-[collapsible=icon]:hidden` on `SidebarInput` is a call-site
///     class**, not a component prop, so the port writes it at the call site too:
///     the field is read off [SidebarChrome] and simply not built in icon mode.
///
/// ## No oracle
///
/// `section-oracle.js` measures document height for a docs route inside the
/// reading column; this page has neither. Its contract is behavioural: it
/// mounts full-viewport, the panel collapses and expands, and the three shell
/// knobs remount it: and that is what `example/test/sidebar_demo_test.dart`
/// pins.
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

import '../nav.dart';
import '../shell.dart';

/// The route this page answers to.
///
/// `app/sidebar-demo/page.tsx`: at the **root**, deliberately outside
/// `$elRoot`, for the reason the library note gives.
const String sidebarDemoRoute = '/sidebar-demo';

/// `NAV`.
const List<({String label, LucideGlyph icon, String? count})> _nav =
    <({String label, LucideGlyph icon, String? count})>[
      (label: 'Overview', icon: Lucide.circleGauge, count: null),
      (label: 'Funnels', icon: Lucide.funnel, count: null),
      (label: 'Retention', icon: Lucide.sparkles, count: null),
      (label: 'Revenue', icon: Lucide.wallet, count: r'$24.8k'),
      (label: 'Users', icon: Lucide.users, count: null),
    ];

/// `EXPLORE`.
const List<({String label, LucideGlyph icon, String? count})> _explore =
    <({String label, LucideGlyph icon, String? count})>[
      (label: 'Dashboard', icon: Lucide.layers, count: null),
      (label: 'Segments', icon: Lucide.star, count: null),
      (label: 'Reports', icon: Lucide.receipt, count: '3'),
    ];

/// `SIDES`.
const List<String> _sides = <String>['left', 'right'];

/// `VARIANTS`.
const List<String> _variants = <String>['sidebar', 'floating', 'inset'];

/// `COLLAPSIBLES`.
const List<String> _collapsibles = <String>['offcanvas', 'icon', 'none'];

/// `<strong className="text-foreground">` inside a `.type-small` line: the
/// helper `dialogs.dart` and `feedback.dart` both carry, and for the same
/// reason: a bare [FontWeight.bold] would drop the `opsz` entry
/// `font-optical-sizing: auto` puts on the variable face.
const double _bolder = 700;

TextStyle _strong(TextStyle base, Color ink) => base.copyWith(
  color: ink,
  fontWeight: FontWeight.bold,
  fontVariations: <FontVariation>[
    for (final FontVariation v
        in base.fontVariations ?? const <FontVariation>[])
      if (v.axis != 'wght') v,
    const FontVariation('wght', _bolder),
  ],
);

/* ── The page ────────────────────────────────────────────────────────────── */

/// `SidebarDemoPage`: the whole screen, no docs chrome.
class SidebarDemoPage extends StatefulWidget {
  const SidebarDemoPage({super.key});

  @override
  State<SidebarDemoPage> createState() => _SidebarDemoPageState();
}

class _SidebarDemoPageState extends State<SidebarDemoPage> {
  SidebarSide _side = SidebarSide.left;
  SidebarVariant _variant = SidebarVariant.sidebar;
  SidebarCollapsible _collapsible = SidebarCollapsible.icon;
  String _active = _nav.first.label;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    return DefaultTextStyle(
      // `<body class="… bg-background text-foreground">`.
      //
      // [DocsShell] installs this for every other route; nothing installs it
      // here, because nothing else is above this page. Only the colour is ever
      // inherited: every string goes through a `.type-*` class that states its
      // own family, size and leading: but a class that declares no `color`
      // (`.type-caption`, `.type-body`) would otherwise take the framework's
      // debug ink instead of the token.
      style: StyledText.styleOf(
        context,
        TextStyles.body,
        color: theme.foreground,
      ),
      child: ColoredBox(
        color: theme.background,
        // USER-ORDERED MOBILE ADAPTATION (2026-08-16). This route is the one
        // page that *is* the viewport: no docs chrome above it: so the rule
        // [DocsShell] follows has to be written here too, in the same shape:
        // the background above paints to every edge, and the shell inside it
        // clears the bars. Horizontal is spent once, here, for both columns;
        // [SafeArea] removes it from the [MediaQuery] below, so the panel's
        // header and footer pay only the two insets they actually touch.
        //
        // On a phone this whole page is under 768px, where the panel is a sheet
        // rather than a column: and `SheetContent` insets nothing of its
        // own, so the same two wrappers are what keep the sheet's rows off the
        // clock and the gesture bar.
        child: SafeArea(
          top: false,
          bottom: false,
          child: SidebarProvider(
            // `key={`${side}-${variant}-${collapsible}`}`, *"structural shell
            // settings remount the provider so state from one geometry cannot
            // leak into the next."*
            key: ValueKey<String>(
              '${_sides[_side.index]}-${_variants[_variant.index]}-'
              '${_collapsibles[_collapsible.index]}',
            ),
            variant: _variant,
            // `className="min-h-svh"`.
            minHeight: MediaQuery.sizeOf(context).height,
            children: <Widget>[
              Sidebar(
                side: _side,
                variant: _variant,
                collapsible: _collapsible,
                children: <Widget>[
                  const _DemoHeader(),
                  _DemoContent(
                    active: _active,
                    onSelect: (String label) => setState(() => _active = label),
                  ),
                  const _DemoFooter(),
                  // `{collapsible !== "none" && <SidebarRail />}`.
                  if (_collapsible != SidebarCollapsible.none)
                    const SidebarRail(),
                ],
              ),
              SidebarInset(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _InsetHeader(active: _active),
                    // `<div className="flex-1 p-6">`: the scroller, for the
                    // reason the library note gives.
                    Expanded(
                      child: SingleChildScrollView(
                        // …and the scroller is therefore what owes the gesture
                        // bar: the readout's last line scrolls clear of it
                        // instead of resting under it.
                        padding: SafeArea.scrollPaddingOf(
                          context,
                          base: EdgeInsets.all(space(6)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const _BackLink(),
                            _ShellSettings(
                              side: _side,
                              variant: _variant,
                              collapsible: _collapsible,
                              onSide: (int i) =>
                                  setState(() => _side = SidebarSide.values[i]),
                              onVariant: (int i) => setState(
                                () => _variant = SidebarVariant.values[i],
                              ),
                              onCollapsible: (int i) => setState(
                                () =>
                                    _collapsible = SidebarCollapsible.values[i],
                              ),
                            ),
                            const _Readout(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ── The panel ───────────────────────────────────────────────────────────── */

/// `<SidebarHeader>`: the workspace row and the search field.
class _DemoHeader extends StatelessWidget {
  const _DemoHeader();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    // The panel runs the full height of the window, so its first row is what
    // the status bar lands on. The panel's own fill is painted by [Sidebar]
    // around this, and keeps reaching the top of the screen.
    return SafeArea(
      bottom: false,
      child: SidebarHeader(
        children: <Widget>[
          SidebarMenu(
            children: <Widget>[
              SidebarMenuItem(
                button: SidebarMenuButton(
                  size: SidebarMenuButtonSize.lg,
                  tooltip: 'Lumen workspace',
                  child: SidebarMenuRow(
                    size: SidebarMenuButtonSize.lg,
                    // `flex size-8 shrink-0 items-center justify-center
                    //  rounded-lg bg-secondary text-foreground shadow-chip`.
                    leading: SizedBox(
                      width: space(8),
                      height: space(8),
                      child: Surface(
                        spec: Shadows.compactControl,
                        radius: BorderRadius.circular(Radii.lg),
                        fill: theme.secondary,
                        child: Center(
                          child: Icon(
                            IconGlyph.sparkles,
                            size: IconSize.sm,
                            tone: IconTone.inherit,
                          ),
                        ),
                      ),
                    ),
                    label: const _WorkspaceLabel(),
                    trailing: const Icon.lucide(Lucide.chevronsUpDown),
                  ),
                ),
              ),
            ],
          ),
          // DRIFT 3: `group-data-[collapsible=icon]:hidden`, written at the
          // call site here exactly as it is there.
          if (!SidebarChrome.iconModeOf(context))
            const SidebarInput(
              placeholder: 'Search cards',
              label: 'Search cards',
            ),
        ],
      ),
    );
  }
}

/// The two-line block inside the workspace row.
class _WorkspaceLabel extends StatelessWidget {
  const _WorkspaceLabel();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        StyledText(
          'Lumen',
          TextStyles.nav,
          color: theme.foreground,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
        ),
        StyledText(
          '12 members',
          TextStyles.caption,
          color: theme.mutedForeground,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
        ),
      ],
    );
  }
}

/// `<SidebarContent>`: the two collapsible groups.
class _DemoContent extends StatelessWidget {
  const _DemoContent({required this.active, required this.onSelect});

  final String active;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) => SidebarContent(
    children: <Widget>[
      SidebarCollapsibleGroup(
        label: 'Essentials',
        toggleLabel: 'Toggle Essentials group',
        child: _DemoMenu(items: _nav, active: active, onSelect: onSelect),
      ),
      const SidebarSeparator(),
      SidebarCollapsibleGroup(
        label: 'Explore',
        toggleLabel: 'Toggle Explore group',
        action: const _AddView(),
        child: _DemoMenu(
          items: _explore,
          active: active,
          onSelect: onSelect,
          badgeVariant: BadgeVariant.destructive,
        ),
      ),
    ],
  );
}

/// One group's `<SidebarMenu>`: the same map over both lists.
class _DemoMenu extends StatelessWidget {
  const _DemoMenu({
    required this.items,
    required this.active,
    required this.onSelect,
    this.badgeVariant = BadgeVariant.secondary,
  });

  final List<({String label, LucideGlyph icon, String? count})> items;
  final String active;
  final ValueChanged<String> onSelect;

  /// `SidebarMenuBadge`'s own default on the first group, `destructive` on the
  /// second.
  final BadgeVariant badgeVariant;

  @override
  Widget build(BuildContext context) {
    final double glyph = Button.iconPxFor(SidebarMenuButtonSize.md.button);
    return SidebarMenu(
      children: <Widget>[
        for (final ({String label, LucideGlyph icon, String? count}) item
            in items)
          SidebarMenuItem(
            button: SidebarMenuButton(
              isActive: active == item.label,
              onPressed: () => onSelect(item.label),
              tooltip: item.label,
              child: SidebarMenuRow(
                // DRIFT 2: off the generated registry.
                leading: Icon.lucide(item.icon, sizePx: glyph),
                label: SidebarMenuLabel(item.label),
              ),
            ),
            badge: item.count == null
                ? null
                : SidebarMenuBadge(item.count!, variant: badgeVariant),
          ),
      ],
    );
  }
}

/// `<SidebarGroupAction aria-label="Add view"><Icon icon={Plus} /></…>`.
class _AddView extends StatelessWidget {
  const _AddView();

  @override
  Widget build(BuildContext context) => SidebarGroupAction(
    label: 'Add view',
    child: Icon(IconGlyph.plus, sizePx: Button.iconPxFor(ButtonSize.iconXs)),
  );
}

/// `<SidebarFooter>`: two rows, the first carrying a `ghost` badge.
class _DemoFooter extends StatelessWidget {
  const _DemoFooter();

  @override
  Widget build(BuildContext context) {
    final double glyph = Button.iconPxFor(SidebarMenuButtonSize.md.button);
    // The panel's floor, and so the row the gesture bar would sit on. `top` is
    // false: the status bar is the header's to pay, and paying it twice would
    // push the footer up by the height of the clock.
    return SafeArea(
      top: false,
      child: SidebarFooter(
        children: <Widget>[
          SidebarMenu(
            children: <Widget>[
              SidebarMenuItem(
                button: SidebarMenuButton(
                  tooltip: "What's new",
                  child: SidebarMenuRow(
                    leading: Icon(IconGlyph.bell, sizePx: glyph),
                    label: const SidebarMenuLabel("What's new"),
                  ),
                ),
                // `<SidebarMenuBadge variant="ghost">2</SidebarMenuBadge>`.
                //
                // The reference writes this one **inside** the button rather
                // than beside it, and the two spellings render the same pixels:
                // the badge is `absolute top-1/2 right-2`, and on a row with no
                // submenu the button's box and the item's are the same box. The
                // `pr-16` lane fires either way: it is
                // `group-has-data-[sidebar=menu-badge]/menu-item`, which reads
                // the item's whole subtree. The port has one slot for it.
                badge: const SidebarMenuBadge('2', variant: BadgeVariant.ghost),
              ),
              SidebarMenuItem(
                button: SidebarMenuButton(
                  tooltip: 'Docs',
                  child: SidebarMenuRow(
                    leading: const Icon.lucide(Lucide.bookOpen),
                    label: const SidebarMenuLabel('Docs'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/* ── The inset ───────────────────────────────────────────────────────────── */

/// `<header className="flex h-16 shrink-0 items-center gap-3 border-b
/// border-border px-6">`.
class _InsetHeader extends StatelessWidget {
  const _InsetHeader({required this.active});

  final String active;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    // `hidden … sm:inline` on the hint.
    final bool wide = MediaQuery.sizeOf(context).width >= Breakpoints.sm;

    return Container(
      // The inset's own top bar, and on this route there is nothing above it —
      // so it grows by the status bar exactly as [DocsShell]'s header does, and
      // its bottom rule stays where the header ends rather than where the clock
      // does. Under the `inset` variant the column carries an 8px margin above
      // this box, so the trigger lands 8px lower than it strictly must; the
      // overpay is the variant's margin and is left alone rather than
      // subtracted, because a control below the bar is right and a control
      // under it is not.
      height: SafeArea.topBarHeightOf(context, LayoutHeights.siteHeader),
      padding: EdgeInsets.symmetric(horizontal: space(6)),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.border, width: BorderWidths.hairline),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: <Widget>[
            const SidebarTrigger(),
            SizedBox(width: space(3)),
            StyledText(active, TextStyles.eyebrow),
            // `ml-auto flex items-center gap-2`.
            const Spacer(),
            if (wide) ...<Widget>[
              // `.type-caption` declares no colour, so `text-muted-foreground`
              // is doing real work at both caption sites on this page.
              StyledText(
                'Toggle with',
                TextStyles.caption,
                color: theme.mutedForeground,
              ),
              SizedBox(width: space(2)),
            ],
            const Kbd('⌘'),
            SizedBox(width: space(2)),
            const Kbd('B'),
          ],
        ),
      ),
    );
  }
}

/// `<Button variant="outline" size="sm" asChild><Link …>`: the B4 divergence:
/// `asChild` is not ported, so the link is the button's own handler.
class _BackLink extends StatelessWidget {
  const _BackLink();

  @override
  Widget build(BuildContext context) {
    final AppRouter router = AppRouter.of(context);
    return Padding(
      // `mb-8` on the row that holds it.
      padding: EdgeInsets.only(bottom: space(8)),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Button(
          variant: ButtonVariant.outline,
          size: ButtonSize.sm,
          onPressed: () => router.navigate('$elRoot/components/base/sidebar'),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                IconGlyph.arrowLeft,
                sizePx: Button.iconPxFor(ButtonSize.sm),
              ),
              SizedBox(width: Button.gapFor(ButtonSize.sm)),
              const Text('Back to Sidebar'),
            ],
          ),
        ),
      ),
    );
  }
}

/// `<section className="mb-8 rounded-xl border border-border bg-card p-4">` —
/// the three structural knobs.
class _ShellSettings extends StatelessWidget {
  const _ShellSettings({
    required this.side,
    required this.variant,
    required this.collapsible,
    required this.onSide,
    required this.onVariant,
    required this.onCollapsible,
  });

  final SidebarSide side;
  final SidebarVariant variant;
  final SidebarCollapsible collapsible;
  final ValueChanged<int> onSide;
  final ValueChanged<int> onVariant;
  final ValueChanged<int> onCollapsible;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: space(8)),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.card,
          borderRadius: BorderRadius.circular(Radii.xl),
          border: Border.all(color: theme.border, width: BorderWidths.hairline),
        ),
        child: Padding(
          padding: EdgeInsets.all(space(4)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              StyledText(
                'Shell settings',
                TextStyles.h4,
                color: theme.foreground,
              ),
              // `mt-4`.
              SizedBox(height: space(4)),
              // `flex flex-wrap gap-x-8 gap-y-5`.
              Wrap(
                spacing: space(8),
                runSpacing: space(5),
                children: <Widget>[
                  _ShellSetting(
                    label: 'side',
                    options: _sides,
                    selected: side.index,
                    onChanged: onSide,
                  ),
                  _ShellSetting(
                    label: 'variant',
                    options: _variants,
                    selected: variant.index,
                    onChanged: onVariant,
                  ),
                  _ShellSetting(
                    label: 'collapsible',
                    options: _collapsibles,
                    selected: collapsible.index,
                    onChanged: onCollapsible,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// `ShellSetting`: one caption over a wrapped row of `default` / `outline`
/// buttons.
class _ShellSetting extends StatelessWidget {
  const _ShellSetting({
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
      // `className="type-caption text-muted-foreground"`.
      StyledText(
        label,
        TextStyles.caption,
        color: ThemeScope.of(context).mutedForeground,
      ),
      // `gap-2` on the column.
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

/// `<div className="max-w-2xl space-y-4">`: the four things that need a
/// viewport, said out loud.
class _Readout extends StatelessWidget {
  const _Readout();

  /// The four `<li>` bodies, `<strong>` run first.
  static const List<({String lead, String rest})>
  _items = <({String lead, String rest})>[
    (
      lead: 'Collapsing.',
      rest:
          ' Hit the trigger, or press ⌘B. In rail mode the panel narrows to '
          '48px and every label is replaced by a tooltip; off-canvas, it '
          'leaves entirely.',
    ),
    (
      lead: 'The rail.',
      rest:
          " The strip down the panel's right edge is a hit target: click "
          'anywhere on it to toggle without aiming.',
    ),
    (
      lead: 'The mobile sheet.',
      rest:
          ' Narrow the window past 768px and the panel stops being a panel: '
          'it becomes a Sheet over a scrim, at 18rem.',
    ),
    (
      // DRIFT 1: there is no cookie here, `sidebar.dart` drift 6.
      lead: 'Persistence.',
      rest:
          ' The open state is written to a cookie for seven days, so a '
          'reload keeps it. Toggle it and refresh.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final TextStyle small = StyledText.styleOf(context, TextStyles.small);

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: Containers.xl2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          StyledText(
            'The live sidebar',
            TextStyles.h2,
            color: theme.foreground,
          ),
          // `space-y-4`.
          SizedBox(height: space(4)),
          StyledText(
            'Four things here need a viewport and cannot be shown in a boxed '
            'specimen.',
            TextStyles.body,
          ),
          SizedBox(height: space(4)),
          // `<ul className="space-y-3">`.
          for (int i = 0; i < _items.length; i++) ...<Widget>[
            if (i > 0) SizedBox(height: space(3)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Badge(label: '${i + 1}', variant: BadgeVariant.outline),
                // `gap-3`.
                SizedBox(width: space(3)),
                Expanded(
                  child: RichText(
                    TextSpan(
                      children: <InlineSpan>[
                        TextSpan(
                          text: _items[i].lead,
                          style: _strong(small, theme.foreground),
                        ),
                        TextSpan(text: _items[i].rest),
                      ],
                    ),
                    TextStyles.small,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
