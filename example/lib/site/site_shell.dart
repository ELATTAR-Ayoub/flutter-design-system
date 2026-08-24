/// Public website shell for the published design-system experience.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/material.dart' show Navigator, SelectionArea;
import 'package:flutter/widgets.dart';

import '../logo.dart';
import '../shell.dart';
import '../theme_toggle.dart';
import 'site_navigation.dart';
import 'site_routes.dart';

/// Shell-scoped toasts for public-site actions.
final ElToastController siteToasts = ElToastController();

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
    ElSheet.showLeft(
      context,
      width: ElWidths.sidebarMobile,
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
    final ElThemeData theme = ElTheme.of(context);
    final double viewport = MediaQuery.sizeOf(context).width;
    final bool desktop = viewport >= ElBreakpoints.lg;
    final double header = ElSafeArea.topBarHeightOf(
      context,
      ElWidths.siteHeader,
    );

    return DefaultTextStyle(
      // `<body class="… text-foreground">`, exactly as `shell.dart:165` states
      // it for the documentation shell and `showcase/showcase_app.dart:151`
      // states it for Signal Studio. Without it this subtree has no
      // [DefaultTextStyle] of its own, so every [ElText] inherits
      // [WidgetsApp]'s fallback, 0xD0FF0000 ink under a double yellow
      // underline, the "you forgot a Material" style: because [ElText] builds
      // with `inherit: true` and never declares a `decoration`, and because its
      // [ElTypeColor.none] classes resolve their ink from
      // `DefaultTextStyle.of(context).style.color`. Both leaked onto every
      // public route until this landed.
      style: ElText.styleOf(context, ElType.body, color: theme.foreground),
      child: Stack(
        children: <Widget>[
          const Positioned.fill(child: ElPageGlow()),
          Positioned.fill(
            child: ElSafeArea(
              top: false,
              bottom: false,
              child: Center(
                child: SizedBox(
                  width: ElWidths.shell,
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
          Positioned.fill(child: ElToaster(controller: siteToasts)),
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
      padding: ElSafeArea.scrollPaddingOf(
        context,
        base: EdgeInsets.only(top: header),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: desktop ? el(12) : el(6),
          vertical: el(12),
        ),
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: ElWidths.page),
            child: SelectionArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  child,
                  SizedBox(height: el(12)),
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
    final ElThemeData theme = ElTheme.of(context);
    final bool compact = viewport < ElBreakpoints.sm;
    final double horizontalPadding = compact ? el(4) : el(6);
    final double compactGap = compact ? el(2) : el(3);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.background,
        border: Border(
          bottom: BorderSide(color: theme.border, width: ElWidths.hairline),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: ElSafeArea(
          bottom: false,
          child: Row(
            children: <Widget>[
              if (!desktop) ...<Widget>[
                ElButton(
                  variant: ElButtonVariant.outline,
                  size: ElButtonSize.icon,
                  label: 'Open site navigation',
                  onPressed: onOpenMobileNavigation,
                  child: const ElIcon(ElIconGlyph.menu),
                ),
                SizedBox(width: compactGap),
              ],
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: ElPress(
                  onTap: () => onNavigate(homeRoute),
                  child: SelectionContainer.disabled(
                    child: Logo(showMark: !compact),
                  ),
                ),
              ),
              if (desktop) ...<Widget>[
                SizedBox(width: el(6)),
                Expanded(
                  child: Wrap(
                    spacing: el(2),
                    runSpacing: el(2),
                    children: <Widget>[
                      for (final SiteNavEntry entry in primarySiteNavigation)
                        ElButton(
                          variant: route == entry.path
                              ? ElButtonVariant.secondary
                              : ElButtonVariant.ghost,
                          size: ElButtonSize.sm,
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
              ElButton(
                variant: ElButtonVariant.outline,
                size: compact ? ElButtonSize.icon : ElButtonSize.sm,
                label: 'Search documentation',
                onPressed: onOpenSearch,
                child: compact
                    ? const ElIcon(ElIconGlyph.search)
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ElIcon.lucide(ElLucide.search, size: ElIconSize.sm),
                          SizedBox(width: ElButton.gapFor(ElButtonSize.sm)),
                          ElText('Search', ElComponentType.buttonLabel),
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
    final ElThemeData theme = ElTheme.of(context);
    final List<SiteSearchGroup> groups = siteSearchGroups(_query);
    final bool empty = _query.trim().isNotEmpty && groups.isEmpty;

    return Padding(
      padding: EdgeInsets.fromLTRB(el(6), el(4), el(6), 0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: ElWidths.page),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: theme.card,
              borderRadius: BorderRadius.circular(ElRadii.xl),
              border: Border.all(color: theme.border, width: ElWidths.hairline),
              boxShadow: ElShadows.tailwindLg.outerShadows(theme),
            ),
            child: Padding(
              padding: EdgeInsets.all(el(4)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: ElText(
                          'Search the public site',
                          ElType.h4,
                          color: theme.foreground,
                        ),
                      ),
                      ElButton(
                        variant: ElButtonVariant.ghost,
                        size: ElButtonSize.iconSm,
                        label: 'Close search',
                        onPressed: widget.onClose,
                        child: const ElIcon(ElIconGlyph.x),
                      ),
                    ],
                  ),
                  SizedBox(height: el(3)),
                  if (empty)
                    _SearchEmptyState(onNavigate: widget.onNavigate)
                  else
                    ElCommand(
                      label: 'Public site search',
                      controller: widget.controller,
                      focusNode: widget.focusNode,
                      placeholder: 'Search pages, docs, and components…',
                      shouldFilter: false,
                      emptyLabel: null,
                      groups: <ElCommandGroup>[
                        for (int i = 0; i < groups.length; i++)
                          ElCommandGroup(
                            heading: groups[i].title,
                            separatorBefore: i > 0 && _query.trim().isEmpty,
                            items: <ElCommandItem>[
                              for (final SearchRoute route in groups[i].routes)
                                ElCommandItem(
                                  label: route.title,
                                  subtitle: route.description,
                                  meta: route.path,
                                  icon: route.isDesignSystemRoute
                                      ? ElIconGlyph.layers
                                      : ElIconGlyph.sparkles,
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
    return ElEmpty(
      children: <Widget>[
        const ElEmptyHeader(
          children: <Widget>[
            ElEmptyMedia(glyph: ElIconGlyph.search),
            ElEmptyTitle('Nothing matched that search'),
            ElEmptyDescription(
              'Try a broader term, or jump straight into the documentation index.',
            ),
          ],
        ),
        ElEmptyContent(
          children: <Widget>[
            ElButton(
              variant: ElButtonVariant.secondary,
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
      padding: EdgeInsets.symmetric(horizontal: el(6)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: el(4), bottom: el(4), right: el(12)),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: ElPress(
                onTap: () => onNavigate(homeRoute),
                child: SelectionContainer.disabled(child: const Logo()),
              ),
            ),
          ),
          for (final SiteNavGroup group in footerSiteNavigation) ...<Widget>[
            ElText(group.title, ElType.label),
            SizedBox(height: el(3)),
            for (final SiteNavEntry entry in group.entries) ...<Widget>[
              ElButton(
                variant: currentRoute == entry.path
                    ? ElButtonVariant.secondary
                    : ElButtonVariant.ghost,
                size: ElButtonSize.md,
                label: entry.title,
                onPressed: () => onNavigate(entry.path),
                contentAlignment: Alignment.centerLeft,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(entry.title),
                ),
              ),
              SizedBox(height: el(1)),
            ],
            SizedBox(height: el(5)),
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
    final ElThemeData theme = ElTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(ElRadii.xl),
        border: Border.all(color: theme.border, width: ElWidths.hairline),
      ),
      child: Padding(
        padding: EdgeInsets.all(el(6)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ElText('Build with Elattar', ElType.h4, color: theme.foreground),
            SizedBox(height: el(2)),
            ElText(
              'Start from the foundation, copy the components you need, and keep the design system transparent for every team that adopts it.',
              ElType.small,
            ),
            SizedBox(height: el(6)),
            Wrap(
              spacing: el(6),
              runSpacing: el(6),
              children: <Widget>[
                for (final SiteNavGroup group in footerSiteNavigation)
                  _FooterColumn(group: group, onNavigate: onNavigate),
              ],
            ),
            SizedBox(height: el(6)),
            Wrap(
              spacing: el(3),
              runSpacing: el(3),
              children: <Widget>[
                ElButton(
                  variant: ElButtonVariant.primary,
                  onPressed: () => onNavigate(docsRoute),
                  child: const Text('Read the docs'),
                ),
                ElButton(
                  variant: ElButtonVariant.secondary,
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
    final ElThemeData theme = ElTheme.of(context);
    return SizedBox(
      width: ElWidths.rail,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ElText(group.title, ElType.label, color: theme.foreground),
          SizedBox(height: el(3)),
          for (final SiteNavEntry entry in group.entries) ...<Widget>[
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: ElPress(
                onTap: () => onNavigate(entry.path),
                child: SelectionContainer.disabled(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: el(1)),
                    child: ElText(entry.title, ElType.small),
                  ),
                ),
              ),
            ),
            SizedBox(height: el(1)),
          ],
        ],
      ),
    );
  }
}
