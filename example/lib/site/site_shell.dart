/// Public website shell for the published design-system experience.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/material.dart' show Navigator, SelectionArea;
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

import '../kit.dart' show CapsLabel;
import '../logo.dart';
import '../shell.dart';
import '../theme_toggle.dart';
import 'site_navigation.dart';
import '../docs/docs_rail_scroll.dart';
import 'site_routes.dart';

/// Shell-scoped toasts for public-site actions.
final ToastController siteToasts = ToastController();

/// Header, search, mobile navigation, reading column, and footer for the
/// public website.
///
/// There is deliberately **no** repository CTA here. The header, the mobile
/// navigation sheet and the footer each carried a "GitHub" button behind an
/// `onOpenGitHub` seam that no call site ever filled, so every visitor who
/// pressed it got a developer's to-do note as a toast ("GitHub action not
/// wired / Pass onOpenGitHub …"). The repository is private and its URL is not
/// publishable yet, so the control was removed rather than disabled: a call to
/// action that cannot act is not a state to render, it is a control that does
/// not belong in the chrome. Bring it back with a real URL, not a seam.
class SiteShell extends StatefulWidget {
  const SiteShell({super.key, required this.route, required this.child});

  final String route;
  final Widget child;

  @override
  State<SiteShell> createState() => _SiteShellState();
}

class _SiteShellState extends State<SiteShell> {
  final ScrollController _main = ScrollController();

  /// Where the documentation left rail was last left, kept here rather than
  /// in `DocsLayout` because this state is what survives a route change and
  /// that one is not. See [DocsRailScrollScope].
  final DocsRailScrollStore _railScroll = DocsRailScrollStore();

  /// A new page starts at its top.
  ///
  /// The shell owns one scroll position and reuses it across routes, so
  /// opening a component from halfway down the rail used to land the reader
  /// halfway down the next page — usually somewhere in its API tables, with
  /// no indication that anything above existed. Every multi-page site resets
  /// this; a single-page app has to do it by hand, because nothing reloads.
  ///
  /// `jumpTo`, not `animateTo`: this is a page load, and a page load does not
  /// scroll. Animating would also race the incoming page's own layout.
  ///
  /// Guarded on the route actually changing, so it does not fire on a
  /// rebuild. In-page anchors — the "ON THIS PAGE" rail — do not change the
  /// route (see the library note in `docs/docs_layout.dart`), so they scroll
  /// where they mean to and are unaffected by this.
  @override
  void didUpdateWidget(SiteShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.route != widget.route && _main.hasClients) {
      _main.jumpTo(_main.position.minScrollExtent);
    }
  }

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode(debugLabel: 'SiteSearch');

  bool _searchOpen = false;

  @override
  void dispose() {
    _main.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _openSearch() {
    if (_searchOpen) return;
    setState(() => _searchOpen = true);
    WidgetsBinding.instance.addPostFrameCallback((Duration _) {
      if (mounted) _searchFocusNode.requestFocus();
    });
  }

  void _closeSearch() {
    if (!_searchOpen) return;
    _searchFocusNode.unfocus();
    setState(() => _searchOpen = false);
  }

  void _navigate(String href) {
    AppRouter.of(context).navigate(href);
    _closeSearch();
  }

  void _openMobileNavigation() {
    Sheet.showLeft(
      context,
      width: LayoutWidths.sidebarMobile,
      builder: (BuildContext sheetContext) => _SiteMobileNavigation(
        currentRoute: widget.route,
        onNavigate: (String href) {
          Navigator.of(sheetContext).pop();
          _navigate(href);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final double viewport = MediaQuery.sizeOf(context).width;
    final bool desktop = viewport >= Breakpoints.lg;
    final double header = SafeArea.topBarHeightOf(
      context,
      LayoutHeights.siteHeader,
    );

    return DocsRailScrollScope(
      store: _railScroll,
      child: _body(context, theme, header, desktop, viewport),
    );
  }

  Widget _body(
    BuildContext context,
    ThemeTokens theme,
    double header,
    bool desktop,
    double viewport,
  ) {
    return DefaultTextStyle(
      // `<body class="… text-foreground">`, exactly as `shell.dart:165` states
      // it for the documentation shell and `showcase/showcase_app.dart:151`
      // states it for Signal Studio. Without it this subtree has no
      // [DefaultTextStyle] of its own, so every [StyledText] would fall back
      // to the theme's foreground rather than to the shell's own ink. The
      // foundation refuses [WidgetsApp]'s red "you forgot a Material" fallback
      // outright — see `StyledText._inheritedInk` — so the failure this line
      // prevents is now a wrong-but-legible colour rather than a red page; it
      // is still the shell's job to state the ink its routes inherit.
      style: StyledText.styleOf(
        context,
        TextStyles.body,
        color: theme.foreground,
      ),
      child: Stack(
        children: <Widget>[
          const Positioned.fill(child: BackgroundEffect()),
          Positioned.fill(
            child: SafeArea(
              top: false,
              bottom: false,
              child: Center(
                child: SizedBox(
                  width: LayoutWidths.shell,
                  child: _SiteBody(
                    controller: _main,
                    header: header,
                    desktop: desktop,
                    footer: _SiteFooter(onNavigate: _navigate),
                    child: widget.child,
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
            child: _SiteHeader(
              route: widget.route,
              desktop: desktop,
              viewport: viewport,
              onNavigate: _navigate,
              onOpenSearch: _openSearch,
              onOpenMobileNavigation: _openMobileNavigation,
            ),
          ),
          if (_searchOpen)
            Positioned(
              top: header,
              left: 0,
              right: 0,
              child: _SearchOverlay(
                query: _searchController.text,
                controller: _searchController,
                focusNode: _searchFocusNode,
                onClose: _closeSearch,
                onNavigate: _navigate,
              ),
            ),
          Positioned.fill(child: Toaster(controller: siteToasts)),
        ],
      ),
    );
  }
}

class _SiteBody extends StatelessWidget {
  const _SiteBody({
    required this.controller,
    required this.header,
    required this.desktop,
    required this.child,
    required this.footer,
  });

  final ScrollController controller;
  final double header;
  final bool desktop;
  final Widget child;
  final Widget footer;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: controller,
      padding: SafeArea.scrollPaddingOf(
        context,
        base: EdgeInsets.only(top: header),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: desktop ? space(12) : space(6),
          vertical: space(12),
        ),
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            // The SHELL's measure, not the narrower page column.
            //
            // `DocsLayout` lays out three columns — rail, article, rail — and
            // used to reach past this box to place the outer two, which broke
            // hit-testing on every row in the overhang. It no longer reaches;
            // it needs the room instead. Pages that want the narrower column
            // still cap themselves (`_PublicPage` at `Breakpoints.xl`, and
            // `DocsLayout`'s own article at `LayoutWidths.article`), so this
            // widens only what was relying on this box to do the capping.
            constraints: const BoxConstraints(maxWidth: LayoutWidths.shell),
            child: SelectionArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  child,
                  SizedBox(height: space(12)),
                  footer,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SiteHeader extends StatelessWidget {
  const _SiteHeader({
    required this.route,
    required this.desktop,
    required this.viewport,
    required this.onNavigate,
    required this.onOpenSearch,
    required this.onOpenMobileNavigation,
  });

  final String route;
  final bool desktop;
  final double viewport;
  final ValueChanged<String> onNavigate;
  final VoidCallback onOpenSearch;
  final VoidCallback onOpenMobileNavigation;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final bool compact = viewport < Breakpoints.sm;
    final double horizontalPadding = compact ? space(4) : space(6);
    final double compactGap = compact ? space(2) : space(3);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.background,
        border: Border(
          bottom: BorderSide(color: theme.border, width: BorderWidths.hairline),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: SafeArea(
          bottom: false,
          child: Row(
            children: <Widget>[
              if (!desktop) ...<Widget>[
                Button(
                  variant: ButtonVariant.outline,
                  size: ButtonSize.icon,
                  label: 'Open site navigation',
                  onPressed: onOpenMobileNavigation,
                  child: const Icon(IconGlyph.menu),
                ),
                SizedBox(width: compactGap),
              ],
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Press(
                  onTap: () => onNavigate(homeRoute),
                  child: SelectionContainer.disabled(
                    child: Logo(showMark: !compact),
                  ),
                ),
              ),
              if (desktop) ...<Widget>[
                SizedBox(width: space(6)),
                Expanded(
                  child: Wrap(
                    spacing: space(2),
                    runSpacing: space(2),
                    children: <Widget>[
                      for (final SiteNavEntry entry in primarySiteNavigation)
                        Button(
                          variant: route == entry.path
                              ? ButtonVariant.secondary
                              : ButtonVariant.ghost,
                          size: ButtonSize.sm,
                          label: entry.title,
                          onPressed: () => onNavigate(entry.path),
                          child: Text(entry.title),
                        ),
                    ],
                  ),
                ),
              ] else
                const Spacer(),
              SizedBox(width: compactGap),
              Button(
                variant: ButtonVariant.outline,
                size: compact ? ButtonSize.icon : ButtonSize.sm,
                label: 'Search documentation',
                onPressed: onOpenSearch,
                child: compact
                    ? const Icon(IconGlyph.search)
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon.lucide(Lucide.search, size: IconSize.sm),
                          SizedBox(width: Button.gapFor(ButtonSize.sm)),
                          StyledText('Search', TextStyles.nav),
                        ],
                      ),
              ),
              SizedBox(width: compactGap),
              const ThemeToggle(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchOverlay extends StatefulWidget {
  const _SearchOverlay({
    required this.query,
    required this.controller,
    required this.focusNode,
    required this.onClose,
    required this.onNavigate,
  });

  final String query;
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onClose;
  final ValueChanged<String> onNavigate;

  @override
  State<_SearchOverlay> createState() => _SearchOverlayState();
}

class _SearchOverlayState extends State<_SearchOverlay> {
  late String _query = widget.query;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleQueryChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleQueryChanged);
    super.dispose();
  }

  void _handleQueryChanged() {
    final String next = widget.controller.text;
    if (next == _query) return;
    setState(() => _query = next);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final List<SiteSearchGroup> groups = siteSearchGroups(_query);
    final bool empty = _query.trim().isNotEmpty && groups.isEmpty;

    return Padding(
      padding: EdgeInsets.fromLTRB(space(6), space(4), space(6), 0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: LayoutWidths.page),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: theme.card,
              borderRadius: BorderRadius.circular(Radii.xl),
              border: Border.all(
                color: theme.border,
                width: BorderWidths.hairline,
              ),
              boxShadow: Shadows.overlay.outerShadows(theme),
            ),
            child: Padding(
              padding: EdgeInsets.all(space(4)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: StyledText(
                          'Search the public site',
                          TextStyles.h4,
                          color: theme.foreground,
                        ),
                      ),
                      Button(
                        variant: ButtonVariant.ghost,
                        size: ButtonSize.iconSm,
                        label: 'Close search',
                        onPressed: widget.onClose,
                        child: const Icon(IconGlyph.x),
                      ),
                    ],
                  ),
                  SizedBox(height: space(3)),
                  if (empty)
                    _SearchEmptyState(onNavigate: widget.onNavigate)
                  else
                    Command(
                      label: 'Public site search',
                      controller: widget.controller,
                      focusNode: widget.focusNode,
                      placeholder: 'Search pages, docs, and components…',
                      shouldFilter: false,
                      emptyLabel: null,
                      groups: <CommandGroup>[
                        for (int i = 0; i < groups.length; i++)
                          CommandGroup(
                            heading: groups[i].title,
                            separatorBefore: i > 0 && _query.trim().isEmpty,
                            items: <CommandItem>[
                              for (final SearchRoute route in groups[i].routes)
                                CommandItem(
                                  label: route.title,
                                  subtitle: route.description,
                                  meta: route.path,
                                  icon: route.isDesignSystemRoute
                                      ? IconGlyph.layers
                                      : IconGlyph.sparkles,
                                  keywords: route.keywords,
                                  onSelect: () => widget.onNavigate(route.path),
                                ),
                            ],
                          ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchEmptyState extends StatelessWidget {
  const _SearchEmptyState({required this.onNavigate});

  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return Empty(
      children: <Widget>[
        const EmptyHeader(
          children: <Widget>[
            EmptyMedia(glyph: IconGlyph.search),
            EmptyTitle('Nothing matched that search'),
            EmptyDescription(
              'Try a broader term, or jump straight into the documentation index.',
            ),
          ],
        ),
        EmptyContent(
          children: <Widget>[
            Button(
              variant: ButtonVariant.secondary,
              onPressed: () => onNavigate(docsRoute),
              child: const Text('Open documentation'),
            ),
          ],
        ),
      ],
    );
  }
}

class _SiteMobileNavigation extends StatelessWidget {
  const _SiteMobileNavigation({
    required this.currentRoute,
    required this.onNavigate,
  });

  final String currentRoute;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: space(6)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              top: space(4),
              bottom: space(4),
              right: space(12),
            ),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Press(
                onTap: () => onNavigate(homeRoute),
                child: SelectionContainer.disabled(child: const Logo()),
              ),
            ),
          ),
          for (final SiteNavGroup group in footerSiteNavigation) ...<Widget>[
            CapsLabel(group.title),
            SizedBox(height: space(3)),
            for (final SiteNavEntry entry in group.entries) ...<Widget>[
              Button(
                variant: currentRoute == entry.path
                    ? ButtonVariant.secondary
                    : ButtonVariant.ghost,
                size: ButtonSize.md,
                label: entry.title,
                onPressed: () => onNavigate(entry.path),
                contentAlignment: Alignment.centerLeft,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(entry.title),
                ),
              ),
              SizedBox(height: space(1)),
            ],
            SizedBox(height: space(5)),
          ],
        ],
      ),
    );
  }
}

class _SiteFooter extends StatelessWidget {
  const _SiteFooter({required this.onNavigate});

  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(Radii.xl),
        border: Border.all(color: theme.border, width: BorderWidths.hairline),
      ),
      child: Padding(
        padding: EdgeInsets.all(space(6)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StyledText(
              'Build with Elattar',
              TextStyles.h4,
              color: theme.foreground,
            ),
            SizedBox(height: space(2)),
            StyledText(
              'Start from the foundation, copy the components you need, and keep the design system transparent for every team that adopts it.',
              TextStyles.small,
            ),
            SizedBox(height: space(6)),
            Wrap(
              spacing: space(6),
              runSpacing: space(6),
              children: <Widget>[
                for (final SiteNavGroup group in footerSiteNavigation)
                  _FooterColumn(group: group, onNavigate: onNavigate),
              ],
            ),
            SizedBox(height: space(6)),
            Wrap(
              spacing: space(3),
              runSpacing: space(3),
              children: <Widget>[
                Button(
                  variant: ButtonVariant.primary,
                  onPressed: () => onNavigate(docsRoute),
                  child: const Text('Read the docs'),
                ),
                Button(
                  variant: ButtonVariant.secondary,
                  onPressed: () => onNavigate(componentsRoute),
                  child: const Text('Browse components'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FooterColumn extends StatelessWidget {
  const _FooterColumn({required this.group, required this.onNavigate});

  final SiteNavGroup group;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return SizedBox(
      width: LayoutWidths.rail,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CapsLabel(group.title, color: theme.foreground),
          SizedBox(height: space(3)),
          for (final SiteNavEntry entry in group.entries) ...<Widget>[
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Press(
                onTap: () => onNavigate(entry.path),
                child: SelectionContainer.disabled(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: space(1)),
                    child: StyledText(entry.title, TextStyles.small),
                  ),
                ),
              ),
            ),
            SizedBox(height: space(1)),
          ],
        ],
      ),
    );
  }
}
