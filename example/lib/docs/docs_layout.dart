/// Reusable article layout for the public documentation pages.
///
/// This is application composition, not a package component. It keeps the
/// reading model independent from the existing parity shell: a wide viewport
/// gets a navigation rail and table of contents, while a narrow viewport keeps
/// the article primary and exposes the contents as a horizontal anchor strip.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/material.dart';

class DocsSidebarEntry {
  const DocsSidebarEntry({
    required this.title,
    required this.route,
    this.selected = false,
  });

  final String title;
  final String route;
  final bool selected;
}

class DocsTocEntry {
  const DocsTocEntry({required this.title, required this.anchor});

  final String title;
  final String anchor;
}

class DocsPageIntro {
  const DocsPageIntro({
    required this.eyebrow,
    required this.title,
    required this.description,
  });

  final String eyebrow;
  final String title;
  final String description;
}

class DocsPageLink {
  const DocsPageLink({required this.title, required this.route});

  final String title;
  final String route;
}

/// Article frame used by documentation, component, and foundation pages.
class DocsLayout extends StatelessWidget {
  const DocsLayout({
    super.key,
    required this.route,
    required this.intro,
    required this.child,
    this.breadcrumbs = const <DsBreadcrumbEntry>[],
    this.sidebar = const <DocsSidebarEntry>[],
    this.toc = const <DocsTocEntry>[],
    this.previous,
    this.next,
    this.onNavigate,
  });

  final String route;
  final DocsPageIntro intro;
  final Widget child;
  final List<DsBreadcrumbEntry> breadcrumbs;
  final List<DocsSidebarEntry> sidebar;
  final List<DocsTocEntry> toc;
  final DocsPageLink? previous;
  final DocsPageLink? next;
  final ValueChanged<String>? onNavigate;

  void _navigate(String destination) => onNavigate?.call(destination);

  @override
  Widget build(BuildContext context) {
    final double viewport = MediaQuery.sizeOf(context).width;
    final bool wide = viewport >= DsBreakpoints.lg;
    final bool extraWide = viewport >= DsBreakpoints.xl;

    final Widget article = _Article(
      intro: intro,
      breadcrumbs: breadcrumbs,
      toc: toc,
      previous: previous,
      next: next,
      onNavigate: _navigate,
      child: child,
    );

    return Semantics(
      container: true,
      label: 'Documentation article',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (!wide && toc.isNotEmpty)
            _AnchorStrip(entries: toc, onNavigate: _navigate),
          SizedBox(height: ds(6)),
          if (wide)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  key: const ValueKey<String>('docs-layout-sidebar'),
                  width: DsWidths.rail,
                  child: _Sidebar(entries: sidebar, onNavigate: _navigate),
                ),
                SizedBox(width: ds(8)),
                Expanded(child: article),
                if (extraWide) ...<Widget>[
                  SizedBox(width: ds(8)),
                  SizedBox(
                    key: const ValueKey<String>('docs-layout-toc'),
                    width: DsWidths.rail,
                    child: _TableOfContents(
                      entries: toc,
                      onNavigate: _navigate,
                    ),
                  ),
                ],
              ],
            )
          else
            article,
        ],
      ),
    );
  }
}

class _Article extends StatelessWidget {
  const _Article({
    required this.intro,
    required this.breadcrumbs,
    required this.child,
    required this.toc,
    required this.previous,
    required this.next,
    required this.onNavigate,
  });

  final DocsPageIntro intro;
  final List<DsBreadcrumbEntry> breadcrumbs;
  final Widget child;
  final List<DocsTocEntry> toc;
  final DocsPageLink? previous;
  final DocsPageLink? next;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Column(
      key: const ValueKey<String>('docs-layout-article'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (breadcrumbs.isNotEmpty) ...<Widget>[
          DsBreadcrumb(items: breadcrumbs),
          SizedBox(height: ds(5)),
        ],
        Container(
          padding: EdgeInsets.only(bottom: ds(8)),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: theme.border, width: DsWidths.hairline),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DsText(intro.eyebrow, DsType.label, color: theme.actionInk),
              SizedBox(height: ds(2)),
              DsText(
                intro.title,
                DsType.h1,
                fontSize: DsFluid.h1(context),
                color: theme.foreground,
              ),
              SizedBox(height: ds(3)),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: DsWidths.prose),
                child: DsText(intro.description, DsType.lead),
              ),
            ],
          ),
        ),
        SizedBox(height: ds(8)),
        child,
        SizedBox(height: ds(12)),
        _PrevNext(previous: previous, next: next, onNavigate: onNavigate),
      ],
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({required this.entries, required this.onNavigate});

  final List<DocsSidebarEntry> entries;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) return const SizedBox.shrink();
    return Semantics(
      container: true,
      label: 'Documentation navigation',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          DsText('IN THIS GUIDE', DsType.label),
          SizedBox(height: ds(3)),
          for (final DocsSidebarEntry entry in entries)
            _RouteRow(entry: entry, onNavigate: onNavigate),
        ],
      ),
    );
  }
}

class _RouteRow extends StatelessWidget {
  const _RouteRow({required this.entry, required this.onNavigate});

  final DocsSidebarEntry entry;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Semantics(
      link: true,
      selected: entry.selected,
      child: GestureDetector(
        onTap: () => onNavigate(entry.route),
        behavior: HitTestBehavior.opaque,
        child: Container(
          key: ValueKey<String>('docs-sidebar:${entry.route}'),
          padding: EdgeInsets.symmetric(horizontal: ds(3), vertical: ds(2)),
          decoration: BoxDecoration(
            color: entry.selected ? theme.muted : null,
            borderRadius: BorderRadius.circular(DsRadii.md),
          ),
          child: DsText(
            entry.title,
            DsType.small,
            color: entry.selected ? theme.foreground : theme.mutedForeground,
          ),
        ),
      ),
    );
  }
}

class _TableOfContents extends StatelessWidget {
  const _TableOfContents({required this.entries, required this.onNavigate});

  final List<DocsTocEntry> entries;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) return const SizedBox.shrink();
    return Container(
      key: const ValueKey<String>('docs-layout-toc-content'),
      padding: EdgeInsets.only(left: ds(5)),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: DsTheme.of(context).border,
            width: DsWidths.hairline,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DsText('ON THIS PAGE', DsType.label),
          SizedBox(height: ds(3)),
          for (final DocsTocEntry entry in entries)
            GestureDetector(
              onTap: () => onNavigate(entry.anchor),
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: ds(1.5)),
                child: DsText(entry.title, DsType.small),
              ),
            ),
        ],
      ),
    );
  }
}

class _AnchorStrip extends StatelessWidget {
  const _AnchorStrip({required this.entries, required this.onNavigate});

  final List<DocsTocEntry> entries;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: const ValueKey<String>('docs-layout-anchor-strip'),
      height: ds(10),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: entries.length,
        separatorBuilder: (_, _) => SizedBox(width: ds(2)),
        itemBuilder: (BuildContext context, int index) {
          final DocsTocEntry entry = entries[index];
          return DsButton(
            variant: DsButtonVariant.outline,
            size: DsButtonSize.sm,
            label: 'Jump to ${entry.title}',
            onPressed: () => onNavigate(entry.anchor),
            child: DsText(entry.title, DsComponentType.buttonLabel),
          );
        },
      ),
    );
  }
}

class _PrevNext extends StatelessWidget {
  const _PrevNext({
    required this.previous,
    required this.next,
    required this.onNavigate,
  });

  final DocsPageLink? previous;
  final DocsPageLink? next;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    if (previous == null && next == null) return const SizedBox.shrink();
    return Container(
      key: const ValueKey<String>('docs-layout-prev-next'),
      padding: EdgeInsets.only(top: ds(6)),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: DsTheme.of(context).border,
            width: DsWidths.hairline,
          ),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: _PageLinkCard(link: previous, onNavigate: onNavigate),
          ),
          SizedBox(width: ds(3)),
          Expanded(
            child: _PageLinkCard(link: next, onNavigate: onNavigate),
          ),
        ],
      ),
    );
  }
}

class _PageLinkCard extends StatelessWidget {
  const _PageLinkCard({required this.link, required this.onNavigate});

  final DocsPageLink? link;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    if (link == null) return const SizedBox.shrink();
    return DsButton(
      variant: DsButtonVariant.outline,
      size: DsButtonSize.md,
      label: 'Open ${link!.title}',
      onPressed: () => onNavigate(link!.route),
      expanded: true,
      contentAlignment: Alignment.centerLeft,
      child: DsText(link!.title, DsComponentType.buttonLabel),
    );
  }
}
