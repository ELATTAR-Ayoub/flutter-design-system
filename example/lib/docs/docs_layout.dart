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

import '../kit.dart' show DsSection;

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
class DocsLayout extends StatefulWidget {
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
                  child: _Sidebar(
                    entries: widget.sidebar,
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
          for (final DocsTocEntry entry in entries)
            GestureDetector(
              key: ValueKey<String>('docs-layout-toc-entry:${entry.anchor}'),
              onTap: () => onAnchor(entry.anchor),
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
  const _AnchorStrip({required this.entries, required this.onAnchor});

  final List<DocsTocEntry> entries;

  /// Scrolls the article to a section. **Not** a router — see the library note.
  final ValueChanged<String> onAnchor;

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
