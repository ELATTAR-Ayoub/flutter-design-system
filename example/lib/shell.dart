/// The docs chrome — `app/design-system/layout.tsx` + `components/ds/ds-nav.tsx`.
///
/// Three things the web gets from the platform and this file has to build:
///
/// * **`position: sticky` on the header.** Sticky keeps its 64px in the flow,
///   so the page starts below the header and slides *under* it on scroll —
///   which is the only reason `backdrop-blur-xl` has anything to blur. The
///   port is a [Stack]: the reading column is a full-viewport scroll view with
///   64px of top padding, and the header is painted over it.
/// * **`sticky top-(--height-site-header)` on the sidebar.** At every scroll
///   offset the rail occupies `64px → viewport bottom`, so it is not part of
///   the scrolling content at all: it is a fixed column with a scroll view of
///   its own.
/// * **`background-attachment: fixed` on the body glow.** Bottom layer of the
///   same [Stack], outside both scroll views.
///
/// ## The fourth thing: system bars (user-ordered mobile adaptation)
///
/// Ordered 2026-08-16 against screenshots — the header was rendering behind the
/// phone's clock and the reading column behind the gesture bar. A browser on a
/// desktop has neither obstruction, so there is no reference behaviour to port;
/// [DsSafeArea]'s library note carries the ruling and this file consumes it at
/// three places:
///
///  * the header **grows** by the status-bar inset ([DsSafeArea.topBarHeightOf])
///    and keeps painting across the whole of it, so the blur and the wash still
///    run to the top of the screen and only the row of controls moves down;
///  * both scroll views scroll *under* both bars and pay the bottom one at the
///    end of their content ([DsSafeArea.scrollPaddingOf]), so the last section
///    can be dragged clear of the gesture bar instead of hiding behind it;
///  * the horizontal insets — a landscape notch — are spent once on the shell
///    frame, which is also what stops the rail from paying for a bar it does
///    not touch: [DsSafeArea] removes what it spends from the [MediaQuery] it
///    hands down, so everything below reads zero for those two sides.
///
/// The glow is outside all of it and still bleeds off every edge, which is the
/// half of the ruling that says what *not* to inset. Every inset is zero on a
/// desktop, and [DsSafeArea] adds no widget at all when it is — so the geometry
/// pins taken at 1440×900 measure the tree they always measured.
library;

import 'dart:ui' as ui;

import 'package:elattar_design_system/elattar_design_system.dart';
// `SelectionArea` is the one thing here that lives in Material rather than
// Widgets: it is the port of `::selection`, and there is no widgets-layer
// equivalent that brings its own handles and toolbar.
import 'package:flutter/material.dart' show Navigator, SelectionArea;
import 'package:flutter/widgets.dart';

import 'logo.dart';
import 'nav.dart';
import 'scroll_bridge.dart';
import 'theme_toggle.dart';

/// `bg-background/85` — the header is translucent so the blur has something to
/// do.
const double _headerAlpha = 0.85;

/// `bg-action/12` — the active nav row's wash.
const double _activeRowAlpha = 0.12;

/// `bg-muted/50` — the sheet header's band.
const double _sheetHeaderAlpha = 0.5;

/// sonner's module-level `toast` — one queue for the whole app.
///
/// `<Toaster position="bottom-right" />` is mounted **once**, in the root
/// layout (`app/layout.tsx:39`), and every page just imports `toast` and calls
/// it. Supervisor ruling F8 keeps that split: the widget is a package
/// component, its mounting is the example's, and the queue behind it is a
/// singleton here for the same reason sonner's is a module-level object there.
final DsToastController docsToasts = DsToastController();

/// The current route, and the only way to change it.
///
/// The docs app has one route dimension (a path string) and no history, so a
/// [ValueNotifier] is the whole router. It lives above the app's
/// [WidgetsApp] — like [DsTheme] — because a pushed route (the mobile nav
/// sheet) has to be able to navigate too.
class AppRouter extends ValueNotifier<String> {
  AppRouter({String route = dsRoot}) : super(route);

  /// The path currently rendered, e.g. `/design-system/colors`.
  String get route => value;

  /// Goes to [href]. Idempotent: re-selecting the current page is a no-op, not
  /// a rebuild.
  void navigate(String href) => value = href;

  /// The router governing [context].
  static AppRouter of(BuildContext context) => AppRouterScope.of(context);
}

/// Puts an [AppRouter] over a subtree.
class AppRouterScope extends InheritedNotifier<AppRouter> {
  const AppRouterScope({
    super.key,
    required AppRouter router,
    required super.child,
  }) : super(notifier: router);

  static AppRouter of(BuildContext context) {
    final AppRouterScope? scope = context
        .dependOnInheritedWidgetOfExactType<AppRouterScope>();
    assert(scope != null, 'No AppRouterScope found above this widget.');
    return scope!.notifier!;
  }
}

/// Header, rail, reading column, atmosphere — everything around a page.
class DocsShell extends StatefulWidget {
  const DocsShell({super.key, required this.route, required this.child});

  /// The path being rendered; drives every active state in the nav.
  final String route;

  /// The page.
  final Widget child;

  @override
  State<DocsShell> createState() => _DocsShellState();
}

class _DocsShellState extends State<DocsShell> {
  final ScrollController _main = ScrollController();
  final ScrollController _rail = ScrollController();

  @override
  void initState() {
    super.initState();
    // The capture rig's ground truth for "where is this page scrolled to" —
    // see `scroll_bridge.dart` for why pixel matching cannot answer that here.
    // A no-op off the web.
    //
    // After the first frame, not during `initState`: a [ScrollController] has
    // no position until the view it drives has laid out, so `maxScrollExtent`
    // does not exist yet and the rig's first question would throw.
    WidgetsBinding.instance.addPostFrameCallback((Duration _) {
      if (mounted) dsInstallScrollBridge(_main);
    });
  }

  @override
  void dispose() {
    _main.dispose();
    _rail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final double viewport = MediaQuery.sizeOf(context).width;
    final bool desktop = viewport >= DsBreakpoints.lg;
    // What the header occupies, status bar included — the box it paints, the
    // gap the rail starts below, and the room the reading column scrolls under.
    // All three are the same number by construction, which is why it is read
    // once here rather than three times below.
    final double header = DsSafeArea.topBarHeightOf(
      context,
      DsWidths.siteHeader,
    );

    return DefaultTextStyle(
      // `<body class="… text-foreground">`. Only the colour is ever inherited
      // — every string on every page goes through a `.type-*` class that
      // states its own family, size and leading — but without this, anything
      // whose class declares no `color` would inherit the framework's default
      // instead of the token.
      style: DsText.styleOf(context, DsType.body, color: theme.foreground),
      child: Stack(
        children: <Widget>[
          // `background-attachment: fixed` — outside every scroll view.
          const Positioned.fill(child: DsPageGlow()),
          Positioned.fill(
            // The landscape notch, spent once for the whole frame: both columns
            // are inside it, and the two sides it pays are removed from the
            // [MediaQuery] below — so the rail does not then pay a right-hand
            // inset it is nowhere near. Vertical is *not* spent here; the header
            // and the two scroll views each owe a different thing.
            child: DsSafeArea(
              top: false,
              bottom: false,
              child: Center(
                // `mx-auto max-w-(--width-shell)`.
                child: SizedBox(
                  width: DsWidths.shell,
                  height: double.infinity,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      if (desktop)
                        _Sidebar(
                          controller: _rail,
                          route: widget.route,
                          header: header,
                        ),
                      Expanded(
                        child: _Main(
                          controller: _main,
                          desktop: desktop,
                          header: header,
                          child: widget.child,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: header,
            child: _Header(theme: theme, viewport: viewport, desktop: desktop),
          ),
          // `<Toaster position="bottom-right" />`, above everything, the way a
          // `position: fixed` viewport with sonner's z-index is.
          //
          // A full-size slot in **this** Stack rather than an `Overlay` entry:
          // the reduced-motion `MediaQuery` override the capture rig installs
          // sits below `MaterialApp`, and an overlay entry does not inherit it
          // — so a toast captured through the rig would still be animating.
          // The host paints nothing and takes no pointer until a toast is
          // queued.
          Positioned.fill(child: DsToaster(controller: docsToasts)),
        ],
      ),
    );
  }
}

/// `sticky top-0 z-40 flex h-(--height-site-header) shrink-0 items-center
/// gap-4 border-b border-border bg-background/85 px-6 backdrop-blur-xl`.
class _Header extends StatelessWidget {
  const _Header({
    required this.theme,
    required this.viewport,
    required this.desktop,
  });

  final DsThemeData theme;
  final double viewport;
  final bool desktop;

  @override
  Widget build(BuildContext context) {
    final Widget gap = SizedBox(width: ds(4));

    return ClipRect(
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: DsBlurs.xl, sigmaY: DsBlurs.xl),
        child: Container(
          decoration: BoxDecoration(
            color: theme.background.withValues(alpha: _headerAlpha),
            border: Border(
              bottom: BorderSide(color: theme.border, width: DsWidths.hairline),
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: ds(6)),
          // Inside the decoration, so the wash, the blur and the bottom rule
          // still cover the status bar and only the controls clear it — and
          // inside the `px-6`, so a control clears the design padding *and* the
          // notch rather than the larger of the two. `bottom` is false because
          // a bar pinned to the top of the window owes the gesture bar nothing;
          // the horizontal sides are this bar's own to pay, since it is a
          // sibling of the shell frame and so inherits none of what the frame
          // spent.
          child: DsSafeArea(
            bottom: false,
            child: Row(
              children: <Widget>[
                // `lg:hidden` — the rail takes over above it.
                if (!desktop) ...<Widget>[const _MobileNavTrigger(), gap],
                DsPress(
                  onTap: () => AppRouter.of(context).navigate(dsRoot),
                  child: const Logo(),
                ),
                // `hidden sm:block`.
                if (viewport >= DsBreakpoints.sm) ...<Widget>[
                  gap,
                  _VersionPill(theme: theme),
                ],
                // `ml-auto` on both the tagline and the toggle: the free space
                // collects here and the pair sits against the right edge. The
                // tagline is [Flexible] because a flex item's text wraps when
                // the row runs out of room rather than pushing past it.
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      // `hidden md:block`.
                      if (viewport >= DsBreakpoints.md) ...<Widget>[
                        Flexible(
                          child: DsText(
                            'Desktop-first · 1440 frame · Light & dark',
                            DsType.micro,
                          ),
                        ),
                        // The header's own `gap-4`…
                        gap,
                        // …then the toggle's `md:ml-4`.
                        gap,
                      ],
                      if (desktop) ...<Widget>[
                        DsButton(
                          variant: DsButtonVariant.secondary,
                          size: DsButtonSize.sm,
                          label: 'Open example app',
                          onPressed: () =>
                              AppRouter.of(context).navigate(showcaseRoute),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              DsIcon.lucide(
                                DsLucide.layoutDashboard,
                                size: DsIconSize.sm,
                              ),
                              SizedBox(width: DsButton.gapFor(DsButtonSize.sm)),
                              DsText(
                                'Example app',
                                DsComponentType.buttonLabel,
                              ),
                            ],
                          ),
                        ),
                        gap,
                      ],
                      const ThemeToggle(),
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

/// `type-micro hidden rounded-pill border border-border px-2.5 py-1 sm:block`.
class _VersionPill extends StatelessWidget {
  const _VersionPill({required this.theme});

  final DsThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Design system version',
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: ds(2.5), vertical: ds(1)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(DsRadii.pill),
          border: Border.all(color: theme.border, width: DsWidths.hairline),
        ),
        child: DsText('Design System v0.1', DsType.micro),
      ),
    );
  }
}

/// `Button variant="outline" size="icon" class="lg:hidden"` — opens the nav
/// sheet.
class _MobileNavTrigger extends StatelessWidget {
  const _MobileNavTrigger();

  @override
  Widget build(BuildContext context) {
    return DsButton(
      variant: DsButtonVariant.outline,
      size: DsButtonSize.icon,
      label: 'Open design system navigation',
      onPressed: () => DsSheet.showLeft(
        context,
        width: DsWidths.sidebarMobile,
        builder: (BuildContext sheetContext) => const _MobileNavSheet(),
      ),
      child: const DsIcon(DsIconGlyph.menu),
    );
  }
}

/// `SheetContent side="left" class="w-72 overflow-y-auto px-6"` with a Logo
/// header and the same tree the rail renders.
class _MobileNavSheet extends StatelessWidget {
  const _MobileNavSheet();

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    // Both scopes live above the [WidgetsApp], so a pushed route reads them
    // exactly like the page under it — and reading the route *here* is what
    // `usePathname()` does inside the reference's `NavTree`: the sheet stays
    // open across a navigation, so its own active row has to keep up.
    final AppRouter router = AppRouter.of(context);

    // `<NavTree />` — the reference passes no `onNavigate`, so a link routes
    // the page *underneath* and leaves the sheet standing; only the close
    // button and the barrier dismiss it. (SiteHeader's mobile nav is the one
    // that wraps its links in `SheetClose`; this one does not.)
    void go(String href) => router.navigate(href);

    void openShowcase() {
      Navigator.of(context).pop();
      router.navigate(showcaseRoute);
    }

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: ds(6)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // `SheetHeader className="px-0"` — `p-4 pr-12` minus its horizontal
          // padding, keeping the room the close button needs.
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: ds(4), bottom: ds(4), right: ds(12)),
            decoration: BoxDecoration(
              color: theme.muted.withValues(alpha: _sheetHeaderAlpha),
              border: Border(
                bottom: BorderSide(
                  color: theme.border,
                  width: DsWidths.hairline,
                ),
              ),
            ),
            child: GestureDetector(
              onTap: () => go(dsRoot),
              child: const Logo(),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: ds(4)),
            child: DsButton(
              variant: DsButtonVariant.secondary,
              size: DsButtonSize.md,
              label: 'Open example app',
              onPressed: openShowcase,
              contentAlignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  DsIcon.lucide(DsLucide.layoutDashboard, size: DsIconSize.sm),
                  SizedBox(width: DsButton.gapFor(DsButtonSize.md)),
                  DsText('Example app', DsComponentType.buttonLabel),
                ],
              ),
            ),
          ),
          NavTree(route: router.route, onNavigate: go),
        ],
      ),
    );
  }
}

/// `aside sticky top-(--height-site-header) hidden h-[calc(100dvh -
/// var(--height-site-header))] w-60 shrink-0 overflow-y-auto border-r
/// border-border px-6 pt-10 scrollbar-thin lg:block`.
class _Sidebar extends StatelessWidget {
  const _Sidebar({
    required this.controller,
    required this.route,
    required this.header,
  });

  final ScrollController controller;
  final String route;

  /// The header's occupied height — [DsWidths.siteHeader] plus the status bar.
  final double header;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return SizedBox(
      width: DsWidths.rail,
      child: Column(
        children: <Widget>[
          // The header's own space in the flow; the rail is stuck below it.
          SizedBox(height: header),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(
                    color: theme.border,
                    width: DsWidths.hairline,
                  ),
                ),
              ),
              child: DsThinScrollbar(
                controller: controller,
                child: SingleChildScrollView(
                  controller: controller,
                  // The rail runs to the bottom of the window, so its last row
                  // is what the gesture bar would sit on. `NavTree`'s own
                  // `pb-16` is not that clearance — it is the reference's, and
                  // it is inside the scrolled content either way; this is
                  // added to the viewport so the list can still be dragged
                  // clear. Horizontal reads zero here: the frame spent it.
                  padding: DsSafeArea.scrollPaddingOf(
                    context,
                    base: EdgeInsets.only(
                      left: ds(6),
                      right: ds(6),
                      top: ds(10),
                    ),
                  ),
                  child: NavTree(
                    route: route,
                    onNavigate: (String href) =>
                        AppRouter.of(context).navigate(href),
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

/// `main class="min-w-0 flex-1 px-6 py-12 lg:px-12"` → `div.mx-auto
/// max-w-(--width-content)`.
class _Main extends StatelessWidget {
  const _Main({
    required this.controller,
    required this.desktop,
    required this.header,
    required this.child,
  });

  final ScrollController controller;
  final bool desktop;

  /// The header's occupied height — [DsWidths.siteHeader] plus the status bar.
  final double header;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DsThinScrollbar(
      controller: controller,
      child: SingleChildScrollView(
        controller: controller,
        // Top: what `position: sticky` reserves in the flow. Content scrolls
        // under the header from here — and on a phone the header is taller by
        // the status bar, so this is too.
        //
        // Bottom: the gesture bar, which the page scrolls under in the same way
        // and pays for at the end of its content. Both are zero-additions on a
        // desktop, where this is `EdgeInsets.only(top: 64)` and nothing else.
        padding: DsSafeArea.scrollPaddingOf(
          context,
          base: EdgeInsets.only(top: header),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: desktop ? ds(12) : ds(6),
            vertical: ds(12),
          ),
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: DsWidths.content),
              child: SelectionArea(child: child),
            ),
          ),
        ),
      ),
    );
  }
}

/// `scrollbar-thin`: `scrollbar-width: thin; scrollbar-color: var(--border)
/// transparent`, WebKit 8px with a pill thumb.
class DsThinScrollbar extends StatelessWidget {
  const DsThinScrollbar({
    super.key,
    required this.controller,
    required this.child,
  });

  final ScrollController controller;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return RawScrollbar(
      controller: controller,
      thumbColor: theme.border,
      thickness: ds(2),
      radius: Radius.circular(DsRadii.pill),
      // A native scrollbar is not a hover affordance: it is there whenever the
      // page can move.
      thumbVisibility: true,
      child: child,
    );
  }
}

/// `nav[aria-label="Design system"].pb-16` — the whole tree, shared by the
/// rail and the sheet.
class NavTree extends StatelessWidget {
  const NavTree({super.key, required this.route, this.onNavigate});

  final String route;

  /// Called with the href the user picked.
  final void Function(String href)? onNavigate;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);

    return Semantics(
      container: true,
      label: 'Design system',
      child: Padding(
        padding: EdgeInsets.only(bottom: ds(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            for (final DsGroup group in dsGroups)
              Padding(
                // `div.mb-8` per group.
                padding: EdgeInsets.only(bottom: ds(8)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _GroupLabel(
                      title: group.title,
                      active: route == group.href,
                      onTap: () => onNavigate?.call(group.href),
                    ),
                    // `mb-3`.
                    SizedBox(height: ds(3)),
                    DecoratedBox(
                      // `ul.space-y-px.border-l.border-border`. Painted, not
                      // laid out: every row's own `border-l` sits on this
                      // exact pixel (`-ml-px`), and a row that declares
                      // `border-transparent` is letting this line show
                      // through.
                      //
                      // The one bordered box on this page that must NOT inset
                      // its child. `border-box` does move the `ul`'s content
                      // edge in by a pixel, and the rows' `-ml-px` moves them
                      // straight back out again — the two cancel, and the
                      // rows span the list's full border box.
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            color: theme.border,
                            width: DsWidths.hairline,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          for (
                            int i = 0;
                            i < group.categories.length;
                            i++
                          ) ...<Widget>[
                            if (i > 0) SizedBox(height: DsWidths.hairline),
                            _NavRow(
                              title: group.categories[i].title,
                              href: categoryHref(group, group.categories[i]),
                              route: route,
                              onNavigate: onNavigate,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// `type-label mb-3 block transition-colors duration-fast
/// hover:text-muted-foreground`.
class _GroupLabel extends StatefulWidget {
  const _GroupLabel({
    required this.title,
    required this.active,
    required this.onTap,
  });

  final String title;
  final bool active;
  final VoidCallback onTap;

  @override
  State<_GroupLabel> createState() => _GroupLabelState();
}

class _GroupLabelState extends State<_GroupLabel> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    // `text-action-ink` when this group's index page is the one you are on —
    // and `hover:text-muted-foreground` dims even that, which is the reference
    // as written.
    final Color ink = _hovered
        ? theme.mutedForeground
        : widget.active
        ? theme.actionInk
        : theme.mutedForeground;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: Align(
          alignment: Alignment.centerLeft,
          child: _ColorFade(
            target: ink,
            builder: (BuildContext context, Color colour) =>
                DsText(widget.title, DsType.label, color: colour),
          ),
        ),
      ),
    );
  }
}

/// `type-nav -ml-px block border-l py-2 pl-4 transition-colors duration-fast`.
class _NavRow extends StatefulWidget {
  const _NavRow({
    required this.title,
    required this.href,
    required this.route,
    required this.onNavigate,
  });

  final String title;
  final String href;
  final String route;
  final void Function(String href)? onNavigate;

  @override
  State<_NavRow> createState() => _NavRowState();
}

class _NavRowState extends State<_NavRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final bool active = widget.route == widget.href;

    // Active: `border-action bg-action/12 text-foreground` — a 1px blue rule
    // replacing the hairline, no glow, no weight change (`.type-nav` already
    // carries 500). Otherwise: `border-transparent text-muted-foreground
    // hover:border-input hover:text-foreground`.
    final Color rule = active
        ? DsPalette.action
        : _hovered
        ? theme.input
        : dsTransparent;
    final Color wash = active
        ? DsPalette.action.withValues(alpha: _activeRowAlpha)
        : dsTransparent;
    final Color ink = active || _hovered
        ? theme.foreground
        : theme.mutedForeground;

    return Semantics(
      link: true,
      selected: active,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: () => widget.onNavigate?.call(widget.href),
          behavior: HitTestBehavior.opaque,
          child: _ColorFade(
            target: rule,
            builder: (BuildContext context, Color border) => _ColorFade(
              target: wash,
              builder: (BuildContext context, Color fill) => DecoratedBox(
                key: ValueKey<String>('nav:${widget.href}'),
                decoration: BoxDecoration(
                  color: fill,
                  border: Border(
                    left: BorderSide(color: border, width: DsWidths.hairline),
                  ),
                ),
                child: Padding(
                  // `py-2 pl-4`, measured from where the hairline sits — and
                  // `box-sizing: border-box` puts the row's own `border-l`
                  // inside its box, so the label starts one pixel further in
                  // than the padding alone would put it. Vertically there is
                  // no border to pay for, so `py-2` is `py-2`.
                  padding: EdgeInsets.only(
                    left: ds(4) + DsWidths.hairline,
                    top: ds(2),
                    bottom: ds(2),
                  ),
                  child: _ColorFade(
                    target: ink,
                    builder: (BuildContext context, Color colour) =>
                        DsText(widget.title, DsType.nav, color: colour),
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

/// `transition-colors duration-fast` for one colour.
///
/// At [DsDurations.transitionDefault], not `--duration-fast`: Tailwind v4
/// generates no `duration-fast` utility, so both nav levels fall through to
/// `--default-transition-duration`. Probed at 0.25s on the live sidebar.
class _ColorFade extends StatelessWidget {
  const _ColorFade({required this.target, required this.builder});

  final Color target;
  final Widget Function(BuildContext context, Color colour) builder;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<Color?>(
      tween: ColorTween(end: target),
      duration: dsAnimationDuration(context, DsDurations.transitionDefault),
      curve: DsCurves.out,
      builder: (BuildContext context, Color? colour, Widget? child) =>
          builder(context, colour ?? target),
    );
  }
}
