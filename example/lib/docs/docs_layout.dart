/// Reusable article layout for the public documentation pages.
///
/// This is application composition, not a package component. It keeps the
/// reading model independent from the existing parity shell: a wide viewport
/// gets a navigation rail and table of contents, while a narrow viewport keeps
/// the article primary and exposes the contents as a horizontal anchor strip.
///
/// **Anchors are not routes.** The table of contents and the mobile anchor
/// strip used to hand [DocsTocEntry.anchor] — a bare `overview`, `files` — to
/// [DocsLayout.onNavigate], the same callback the sidebar and the pager use for
/// real paths. Nothing routes a bare anchor id, so `main.dart`'s route table
/// fell through to its "Not found" placeholder *in the documentation shell*:
/// tapping "Overview" on `/skills` at tablet width replaced the public page
/// with a docs-chrome error page. On desktop, where the same entries live in
/// the "ON THIS PAGE" rail, they were simply inert. Both are the same bug.
///
/// So [onNavigate] now carries **paths only**, and an anchor scrolls the
/// article instead — see [docsAnchorKey] for how a page marks a target and
/// [_DocsLayoutState._scrollToAnchor] for what activating one does.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/material.dart';

import '../components_docs/catalog.dart' show ComponentDocEntry, componentDocs;
import '../kit.dart' show DsSection;
import '../site/site_routes.dart' show SiteRoute, SiteSection, siteRoutes;
import 'docs_sidebar.dart';

export 'docs_sidebar.dart' show DocsSidebar, DocsSidebarEntry, DocsSidebarGroup;

/// The "Sections" then "Components" rail [_DocsLayoutState.build] falls back
/// to when a page supplies neither [DocsLayout.sidebarGroups] nor the legacy
/// [DocsLayout.sidebar] list.
///
/// "Sections" lists the top-level public destinations from
/// `../site/site_routes.dart`, deliberately **excluding** [SiteSection.home]:
/// an earlier audit found stale `/docs/*` sub-routes that dead-ended on the
/// homepage inside this very rail, and Home is the one top-level destination
/// that is never useful to reach *from inside* the documentation shell. What
/// is left — `/docs`, `/components`, `/shots`, `/skills` — is exactly what
/// `main.dart`'s `publicPageFor` resolves today: `/docs`, `/components` and
/// `/shots` on their own switch arms, `/skills` one guard above it via
/// `skillDocForRoute`. Nothing listed here is a dead link.
///
/// "Components" lists every `../components_docs/catalog.dart` entry —
/// already alphabetical by title, per that file's own contract — with
/// whichever one matches [route] marked [DocsSidebarEntry.selected].
List<DocsSidebarGroup> _defaultSidebarGroups(String route) {
  return <DocsSidebarGroup>[
    DocsSidebarGroup(
      label: 'Sections',
      items: <DocsSidebarEntry>[
        for (final SiteRoute site in siteRoutes)
          if (site.section != SiteSection.home)
            DocsSidebarEntry(
              title: site.title,
              route: site.path,
              selected: site.path == route,
            ),
      ],
    ),
    DocsSidebarGroup(
      label: 'Components',
      items: <DocsSidebarEntry>[
        for (final ComponentDocEntry component in componentDocs)
          DocsSidebarEntry(
            title: component.title,
            route: component.route,
            selected: component.route == route,
          ),
      ],
    ),
  ];
}

/// The key a documentation article marks an in-page anchor target with.
///
/// One spelling of the convention `components_docs/button_card_pages.dart`
/// already had (`ValueKey<String>('docs-anchor:$name')`) — a plain [ValueKey],
/// compared by value, so a page that spells it by hand and a page that calls
/// this function mark the same target. Deliberately **not** a [GlobalKey]: two
/// documentation pages carry overlapping anchor ids (`preview`, `install`,
/// `api`), and a global key shared between them would let the framework
/// reparent one page's section into the next page during a route swap,
/// carrying that subtree's state — a tab selection, a file-tree cursor — with
/// it. Resolution walks the mounted article instead ([_DocsLayoutState._anchorContext]).
Key docsAnchorKey(String anchor) => ValueKey<String>('docs-anchor:$anchor');

/// An entry in the "ON THIS PAGE" rail (or the narrow anchor strip it
/// collapses to). [children] is one level of nested sub-entries — a
/// component page's "Examples" section lists each variant demo beneath it,
/// for instance — rendered indented under [title] and scrolled to the same
/// way a top-level entry is. A deeper level than that is not rendered: the
/// reference layout never needs one, so [_TableOfContents] does not recurse
/// into a child's own `children`.
class DocsTocEntry {
  const DocsTocEntry({
    required this.title,
    required this.anchor,
    this.children = const <DocsTocEntry>[],
  });

  final String title;
  final String anchor;
  final List<DocsTocEntry> children;
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
class DocsLayout extends StatefulWidget {
  const DocsLayout({
    super.key,
    required this.route,
    required this.intro,
    required this.child,
    this.breadcrumbs = const <DsBreadcrumbEntry>[],
    this.sidebar = const <DocsSidebarEntry>[],
    this.sidebarGroups = const <DocsSidebarGroup>[],
    this.toc = const <DocsTocEntry>[],
    this.previous,
    this.next,
    this.onNavigate,
  });

  final String route;
  final DocsPageIntro intro;
  final Widget child;
  final List<DsBreadcrumbEntry> breadcrumbs;

  /// Legacy ungrouped rail data — one flat list, no group label. Ignored
  /// once [sidebarGroups] is non-empty; kept only so pages that predate the
  /// grouped rail keep compiling and rendering unchanged. New callers should
  /// prefer [sidebarGroups].
  final List<DocsSidebarEntry> sidebar;

  /// The grouped left rail — "Sections" then "Components" in the reference
  /// layout. Takes priority over [sidebar] whenever it is non-empty. A page
  /// that supplies neither this nor [sidebar] gets [_defaultSidebarGroups]
  /// instead of an empty rail — see that function.
  final List<DocsSidebarGroup> sidebarGroups;
  final List<DocsTocEntry> toc;
  final DocsPageLink? previous;
  final DocsPageLink? next;

  /// Opens another **route**. Never receives an anchor id — see the library
  /// note.
  final ValueChanged<String>? onNavigate;

  @override
  State<DocsLayout> createState() => _DocsLayoutState();
}

class _DocsLayoutState extends State<DocsLayout> {
  /// The mounted article, so an anchor lookup searches this page's own
  /// sections rather than the whole app.
  final GlobalKey _article = GlobalKey(debugLabel: 'DocsLayout article');

  void _navigate(String destination) => widget.onNavigate?.call(destination);

  /// Where [anchor] lives in the mounted article, or null when this page marks
  /// no such target.
  ///
  /// Two conventions are in use across the nine `DocsPageLayout` routes and
  /// both are honoured here rather than rewritten:
  /// * [docsAnchorKey] — a [ValueKey] on the section's subtree, which the
  ///   component, Shot and Skill articles carry. Resolved by walking this
  ///   layout's own article, which is what makes a value key enough.
  /// * `kit.dart`'s [DsSection], whose `id` already registers a [GlobalKey] in
  ///   that file's own anchor registry. The dialog, input and select guides
  ///   are built out of `DsSection`s whose ids are their TOC anchors, so they
  ///   need no marking at all. `kit.dart` is read here, never modified.
  ///
  /// The article-local convention wins: a page that marks a target explicitly
  /// means that one, even if some `DsSection` elsewhere happens to share the id.
  BuildContext? _anchorContext(String anchor) {
    final Key key = docsAnchorKey(anchor);
    Element? found;
    void visit(Element element) {
      if (found != null) return;
      if (element.widget.key == key) {
        found = element;
        return;
      }
      element.visitChildren(visit);
    }

    _article.currentContext?.visitChildElements(visit);
    return found ?? DsSection.anchorKey(anchor).currentContext;
  }

  /// `html { scroll-behavior: smooth }` to [anchor], resting
  /// `--scroll-offset` below the viewport top.
  ///
  /// The same landing position and the same timing [DsSection.scrollTo] uses,
  /// against a target that method cannot resolve: its registry only knows ids
  /// that were declared by a `DsSection`, and most of these articles are
  /// composed out of panels instead. An anchor nothing marks scrolls nothing —
  /// it does **not** fall through to [DocsLayout.onNavigate], which is the
  /// whole point.
  Future<void> _scrollToAnchor(String anchor) async {
    final BuildContext? target = _anchorContext(anchor);
    if (target == null) return;
    final ScrollableState? scrollable = Scrollable.maybeOf(target);
    if (scrollable == null) return;

    final RenderObject? box = target.findRenderObject();
    final RenderObject? viewport = scrollable.context.findRenderObject();
    if (box is! RenderBox || viewport is! RenderBox) return;

    final double delta =
        box.localToGlobal(Offset.zero, ancestor: viewport).dy -
        DsWidths.scrollOffset;
    final ScrollPosition position = scrollable.position;
    await position.animateTo(
      (position.pixels + delta).clamp(
        position.minScrollExtent,
        position.maxScrollExtent,
      ),
      duration: dsAnimationDuration(target, DsDurations.slow),
      curve: DsCurves.inOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double viewport = MediaQuery.sizeOf(context).width;
    final bool wide = viewport >= DsBreakpoints.lg;
    final bool extraWide = viewport >= DsBreakpoints.xl;
    final List<DocsTocEntry> toc = widget.toc;
    final List<DocsSidebarGroup> sidebarGroups = widget.sidebarGroups.isNotEmpty
        ? widget.sidebarGroups
        : widget.sidebar.isEmpty
        ? _defaultSidebarGroups(widget.route)
        : <DocsSidebarGroup>[
            DocsSidebarGroup(label: 'IN THIS GUIDE', items: widget.sidebar),
          ];

    final Widget article = _Article(
      key: _article,
      intro: widget.intro,
      breadcrumbs: widget.breadcrumbs,
      toc: toc,
      previous: widget.previous,
      next: widget.next,
      onNavigate: _navigate,
      child: widget.child,
    );

    return Semantics(
      container: true,
      label: 'Documentation article',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (!wide && toc.isNotEmpty)
            _AnchorStrip(entries: toc, onAnchor: _scrollToAnchor),
          SizedBox(height: ds(6)),
          if (wide)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  key: const ValueKey<String>('docs-layout-sidebar'),
                  width: DsWidths.rail,
                  child: DocsSidebar(
                    groups: sidebarGroups,
                    onNavigate: _navigate,
                  ),
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
                      onAnchor: _scrollToAnchor,
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
    super.key,
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

/// The "ON THIS PAGE" rail. [entries] renders as given; any entry's
/// [DocsTocEntry.children] render indented immediately beneath it, one level
/// only — see the type's own doc comment.
class _TableOfContents extends StatelessWidget {
  const _TableOfContents({required this.entries, required this.onAnchor});

  final List<DocsTocEntry> entries;

  /// Scrolls the article to a section. **Not** a router — see the library note.
  final ValueChanged<String> onAnchor;

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
          for (final DocsTocEntry entry in entries) ...<Widget>[
            _TocRow(entry: entry, onAnchor: onAnchor),
            for (final DocsTocEntry child in entry.children)
              _TocRow(entry: child, onAnchor: onAnchor, indented: true),
          ],
        ],
      ),
    );
  }
}

class _TocRow extends StatelessWidget {
  const _TocRow({
    required this.entry,
    required this.onAnchor,
    this.indented = false,
  });

  final DocsTocEntry entry;

  /// Scrolls the article to a section. **Not** a router — see the library note.
  final ValueChanged<String> onAnchor;
  final bool indented;

  @override
  Widget build(BuildContext context) {
    final Widget row = GestureDetector(
      key: ValueKey<String>('docs-layout-toc-entry:${entry.anchor}'),
      onTap: () => onAnchor(entry.anchor),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: ds(1.5)),
        child: DsText(entry.title, DsType.small),
      ),
    );
    if (!indented) return row;
    return Padding(
      key: ValueKey<String>('docs-layout-toc-child:${entry.anchor}'),
      padding: EdgeInsets.only(left: ds(4)),
      child: row,
    );
  }
}

class _AnchorStrip extends StatelessWidget {
  const _AnchorStrip({required this.entries, required this.onAnchor});

  final List<DocsTocEntry> entries;

  /// Scrolls the article to a section. **Not** a router — see the library note.
  final ValueChanged<String> onAnchor;

  @override
  Widget build(BuildContext context) {
    // Flattened one level deep, so a nested "Examples" child stays reachable
    // even where there is no room for the indented rail — see DocsTocEntry.
    final List<DocsTocEntry> flat = <DocsTocEntry>[
      for (final DocsTocEntry entry in entries) ...<DocsTocEntry>[
        entry,
        ...entry.children,
      ],
    ];
    return SizedBox(
      key: const ValueKey<String>('docs-layout-anchor-strip'),
      height: ds(10),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: flat.length,
        separatorBuilder: (_, _) => SizedBox(width: ds(2)),
        itemBuilder: (BuildContext context, int index) {
          final DocsTocEntry entry = flat[index];
          return DsButton(
            key: ValueKey<String>('docs-layout-anchor-chip:${entry.anchor}'),
            variant: DsButtonVariant.outline,
            size: DsButtonSize.sm,
            label: 'Jump to ${entry.title}',
            onPressed: () => onAnchor(entry.anchor),
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
