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

import 'dart:math' as math;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/material.dart';

import '../components_docs/catalog.dart' show ComponentDocEntry, componentDocs;
import '../kit.dart' show ElSection;
// The ambient router, so the rails navigate on pages that pass no callback.
import '../shell.dart' show AppRouterScope;
import '../site/site_routes.dart' show SiteRoute, SiteSection, siteRoutes;
import 'docs_sidebar.dart';

export 'docs_sidebar.dart' show DocsSidebar, DocsSidebarEntry, DocsSidebarGroup;

/// The "Sections" then "Components" rail [_DocsLayoutState.build] falls back
/// to when a page supplies neither [DocsLayout.sidebarGroups] nor the legacy
/// [DocsLayout.sidebar] list.
///
/// "Sections" lists the top-level public destinations from
/// `../site/site_routes.dart`, deliberately excluding two kinds of entry.
/// First, [SiteSection.home]: an earlier audit found stale `/docs/*`
/// sub-routes that dead-ended on the homepage inside this very rail, and
/// Home is the one top-level destination that is never useful to reach
/// *from inside* the documentation shell. Second, any [SiteRoute] whose
/// [SiteRoute.showInSidebar] is `false`, which today is only `docsRoute`
/// (title "Documentation"): that route still resolves through
/// `main.dart`'s `publicPageFor` and still appears in quick search, it is
/// just not also listed here, above the six sub-pages it groups. What is
/// left, Introduction, Components, Installation, Theming, CLI and Skills, is
/// exactly what `main.dart`'s `publicPageFor` resolves today. Nothing listed
/// here is a dead link.
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
          if (site.section != SiteSection.home && site.showInSidebar)
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
    this.breadcrumbs = const <ElBreadcrumbEntry>[],
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
  final List<ElBreadcrumbEntry> breadcrumbs;

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
  /// sections rather than the whole app. Doubles as the bottom bound
  /// [_StickyRail] clamps against — see that class.
  final GlobalKey _article = GlobalKey(debugLabel: 'DocsLayout article');

  /// Own their own scroll position, independent of the article's — see
  /// [_StickyRail].
  final ScrollController _sidebarScroll = ScrollController(
    debugLabel: 'DocsLayout sidebar rail',
  );
  final ScrollController _tocScroll = ScrollController(
    debugLabel: 'DocsLayout toc rail',
  );

  @override
  void dispose() {
    _sidebarScroll.dispose();
    _tocScroll.dispose();
    super.dispose();
  }

  /// Routes to [destination].
  ///
  /// The rail must navigate on EVERY page, so this can never depend on a page
  /// remembering to pass [DocsLayout.onNavigate]. Most component pages are
  /// built as `const ButtonDocPage()` with no callback at all, which made
  /// `widget.onNavigate?.call(...)` a silent no-op: every left-rail row on
  /// those pages looked clickable and did nothing.
  ///
  /// The router is ambient, so it is asked directly and the callback is only
  /// a fallback for the tests that supply one to observe routing.
  void _navigate(String destination) {
    final ValueChanged<String>? callback = widget.onNavigate;
    if (callback != null) {
      callback(destination);
      return;
    }
    AppRouterScope.maybeOf(context)?.navigate(destination);
  }

  /// Where [anchor] lives in the mounted article, or null when this page marks
  /// no such target.
  ///
  /// Two conventions are in use across the nine `DocsPageLayout` routes and
  /// both are honoured here rather than rewritten:
  /// * [docsAnchorKey] — a [ValueKey] on the section's subtree, which the
  ///   component and Skill articles carry. Resolved by walking this
  ///   layout's own article, which is what makes a value key enough.
  /// * `kit.dart`'s [ElSection], whose `id` already registers a [GlobalKey] in
  ///   that file's own anchor registry. The dialog, input and select guides
  ///   are built out of `ElSection`s whose ids are their TOC anchors, so they
  ///   need no marking at all. `kit.dart` is read here, never modified.
  ///
  /// The article-local convention wins: a page that marks a target explicitly
  /// means that one, even if some `ElSection` elsewhere happens to share the id.
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
    return found ?? ElSection.anchorKey(anchor).currentContext;
  }

  /// `html { scroll-behavior: smooth }` to [anchor], resting
  /// `--scroll-offset` below the viewport top.
  ///
  /// The same landing position and the same timing [ElSection.scrollTo] uses,
  /// against a target that method cannot resolve: its registry only knows ids
  /// that were declared by a `ElSection`, and most of these articles are
  /// composed out of panels instead. An anchor nothing marks scrolls nothing —
  /// it does **not** fall through to [DocsLayout.onNavigate], which is the
  /// whole point.
  Future<void> _scrollToAnchor(String anchor) async {
    final BuildContext? target = _anchorContext(anchor);
    // `target == null` gets no assert: an anchor nothing marks is legitimate
    // — see 'an unmarked anchor scrolls nothing and still routes nothing' in
    // docs_layout_test.dart, and the library note above. It is the two
    // returns below that assert, because by the time a target has been
    // found, "cannot actually be scrolled to" is a real defect, not a valid
    // outcome — and a silent no-op here was indistinguishable from a working
    // link, the loudest complaint against this method. These two asserts
    // change no behaviour, debug or release; they only turn that defect into
    // a thrown message during development instead of a link that quietly
    // does nothing.
    if (target == null) return;
    final ScrollableState? scrollable = Scrollable.maybeOf(target);
    assert(
      scrollable != null,
      'DocsLayout: "$anchor" resolved to a target with no enclosing '
      'Scrollable, so it cannot be scrolled to.',
    );
    if (scrollable == null) return;

    final RenderObject? box = target.findRenderObject();
    final RenderObject? viewport = scrollable.context.findRenderObject();
    assert(
      box is RenderBox && viewport is RenderBox,
      'DocsLayout: "$anchor" or its Scrollable has not been laid out yet.',
    );
    if (box is! RenderBox || viewport is! RenderBox) return;

    final double delta =
        box.localToGlobal(Offset.zero, ancestor: viewport).dy -
        ElWidths.scrollOffset;
    final ScrollPosition position = scrollable.position;
    await position.animateTo(
      (position.pixels + delta).clamp(
        position.minScrollExtent,
        position.maxScrollExtent,
      ),
      duration: elAnimationDuration(target, ElDurations.slow),
      curve: ElCurves.inOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double viewport = MediaQuery.sizeOf(context).width;
    final bool wide = viewport >= ElBreakpoints.lg;
    final bool extraWide = viewport >= ElBreakpoints.xl;
    // How tall either rail is allowed to grow before it scrolls on its own,
    // matching the width story in the [LayoutBuilder] below. A rail that
    // fits within this in the common case never notices the clamp: it is
    // only the "Components" list on a short screen, or a long "ON THIS PAGE"
    // outline, that hits [SingleChildScrollView] instead of stretching the
    // whole page (sidebar, article and all) down to its own height.
    final double railMaxHeight = MediaQuery.sizeOf(context).height;
    // `_SiteBody` (site_shell.dart) hands this widget a column already capped
    // at `ElWidths.page` and centred inside `ElWidths.shell`, the dead space
    // at the outer edges an earlier audit flagged. That constraint belongs to
    // the whole site (every public page reads inside a `max-w-page` column,
    // this one included) so it is not this widget's place to remove it
    // upstream. Instead the rails in the [LayoutBuilder] below reach past it
    // on their own, out to the shell's own edge or the viewport's, whichever
    // is narrower, re-centred on the same point `_SiteBody`'s own `Center` →
    // `Align` chain already centres it on. The reading column stays capped
    // at [ElWidths.content] regardless, so only the rails actually reach the
    // wider edge.
    // The full viewport, never clamped to [ElWidths.shell]. The rails belong
    // at the EDGES OF THE SCREEN: pinning them to the shell's measure instead
    // left a margin of dead space outside each rail on a wide monitor. Only
    // the centre column is capped, at [ElWidths.article], and centred between
    // them.
    final double fullBleedWidth = viewport;
    final List<DocsTocEntry> toc = widget.toc;
    // The left rail is the SAME on every documentation page, always. It is
    // cross-page navigation, so it cannot vary by which page is open: a reader
    // moving between Installation, Skills and a component must see one stable
    // list, with only the centre column changing.
    //
    // [DocsLayout.sidebar] and [DocsLayout.sidebarGroups] are therefore no
    // longer consulted here. Forty pages each passed their own hand-written
    // list, which is why the rail used to change shape as you navigated. Those
    // two parameters stay on the constructor so the forty call sites keep
    // compiling, and are documented as ignored.
    final List<DocsSidebarGroup> sidebarGroups = _defaultSidebarGroups(
      widget.route,
    );

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
          SizedBox(height: el(6)),
          if (wide)
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                // How far the rails must reach, past the box this widget was
                // actually given, to land on [fullBleedWidth]. Zero once that
                // box already reaches the full-bleed edge on its own: every
                // harness this layout is built and tested against today
                // (`docs_layout_test.dart`, every component doc test) hands
                // it the raw viewport directly, nothing above it narrows the
                // box first, so `inset` is 0 there. It is only positive
                // inside the real `_SiteBody` column, whose own
                // `ConstrainedBox(maxWidth: ElWidths.page)` this widget
                // cannot reach, see the comment above [fullBleedWidth].
                final double inset = math.max(
                  0.0,
                  (fullBleedWidth - constraints.maxWidth) / 2,
                );
                // The reading column's own margin: a rail plus the gap after
                // it, less however much of that margin already sits in the
                // escaped `inset` band outside this widget's own box.
                final double contentInset = math.max(
                  0.0,
                  ElWidths.rail + el(8) - inset,
                );

                // An earlier version of this widget wrapped a three-column
                // [Row] in an [OverflowBox] to reach past the box above. That
                // crashed here: [OverflowBox] always sizes itself to
                // `constraints.biggest`, and the incoming height constraint
                // is unbounded (this whole page sits in a vertical
                // [SingleChildScrollView]), so its reported size carried an
                // infinite height. A [Row] cannot replace it either: its
                // `Expanded` content column needs a bounded main-axis
                // constraint to size against, and the only bound this widget
                // has to offer is `constraints.maxWidth`, exactly the width
                // the rails need to escape.
                //
                // [Stack] sizes itself from its one non-positioned child
                // instead, via `constraints.constrain(child.size)`. That
                // child is the reading column below, and its height is the
                // article's own, always finite, so this widget's reported
                // height stays finite too even though the constraint it was
                // handed was not. The rails escape sideways as [Positioned]
                // children, each pinned `inset` past this box's own edge:
                // `clipBehavior: Clip.none` is what lets them paint there
                // instead of being cut at this box's own, narrower bounds.
                return Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topLeft,
                  children: <Widget>[
                    // Not [Positioned]: this is the one child [Stack] sizes
                    // itself from, matching the reference
                    // (https://ui.shadcn.com/docs/components), where the
                    // rails sit at the edges of whatever box this widget is
                    // given and only the middle column is capped and centred
                    // between them.
                    Padding(
                      padding: EdgeInsets.only(
                        left: contentInset,
                        right: extraWide ? contentInset : 0,
                      ),
                      child: Center(
                        child: ConstrainedBox(
                          // `max-w-160` = 640px on the reference's own
                          // article column (ui.shadcn.com/docs/installation,
                          // confirmed against its live layout) — narrower
                          // than [ElWidths.content], the three-column
                          // *shell*'s own measure. See [ElWidths.article].
                          constraints: const BoxConstraints(
                            maxWidth: ElWidths.article,
                          ),
                          child: article,
                        ),
                      ),
                    ),
                    Positioned(
                      left: -inset,
                      top: 0,
                      child: _StickyRail(
                        articleAnchor: _article,
                        child: SizedBox(
                          key: const ValueKey<String>('docs-layout-sidebar'),
                          // The rail is pinned to the screen edge, so its own
                          // gutter is what keeps the group labels and rows off
                          // that edge. Without it the first character of every
                          // row sits against the glass.
                          width: ElWidths.rail + el(6),
                          child: Padding(
                            padding: EdgeInsets.only(left: el(6)),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight: railMaxHeight,
                              ),
                              child: Scrollbar(
                                controller: _sidebarScroll,
                                child: SingleChildScrollView(
                                  controller: _sidebarScroll,
                                  child: DocsSidebar(
                                    groups: sidebarGroups,
                                    onNavigate: _navigate,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (extraWide)
                      Positioned(
                        right: -inset,
                        top: 0,
                        child: _StickyRail(
                          articleAnchor: _article,
                          child: SizedBox(
                            key: const ValueKey<String>('docs-layout-toc'),
                            // Mirrors the left rail's gutter, on the other
                            // side, for the same reason.
                            width: ElWidths.rail + el(6),
                            child: Padding(
                              padding: EdgeInsets.only(right: el(6)),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxHeight: railMaxHeight,
                                ),
                                child: Scrollbar(
                                  controller: _tocScroll,
                                  child: SingleChildScrollView(
                                    controller: _tocScroll,
                                    child: _TableOfContents(
                                      entries: toc,
                                      onAnchor: _scrollToAnchor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            )
          else
            article,
        ],
      ),
    );
  }
}

/// Keeps [child] pinned near the top of the ambient page scroll as the
/// reader scrolls past it, the way `position: sticky` holds the reference's
/// own sidebar and "ON THIS PAGE" rail in view while the article scrolls
/// underneath (https://ui.shadcn.com/docs/installation — both rails there
/// are `position: sticky`, each with its own `overflow-y` once its content
/// outgrows the room `top` leaves it).
///
/// There is no sliver ancestor to hand a [SliverPersistentHeader]: the real
/// page above this widget is a plain [SingleChildScrollView] (`_SiteBody` in
/// `site_shell.dart`), and every harness this layout is tested against
/// mirrors that. So this reimplements the effect by hand — on every ambient
/// scroll notification it measures how far [child]'s own resting position
/// has scrolled above [ElWidths.siteHeader] (the fixed header's own height,
/// the reference's sticky `top`) and translates it back down by exactly
/// that much, clamped so it never drifts past [articleAnchor]'s bottom edge:
/// the same stopping point CSS sticky's containing block gives it for free.
/// [child] supplies its own bounded-height [SingleChildScrollView] (see the
/// two call sites in [_DocsLayoutState.build]), which is what makes the
/// rail scroll on its own, independent of the article, once translating
/// further would run it off the bottom of that block.
class _StickyRail extends StatefulWidget {
  const _StickyRail({required this.child, required this.articleAnchor});

  final Widget child;

  /// The article's own [GlobalKey] ([_DocsLayoutState._article]) — this
  /// widget's containing block stand-in. Reused rather than re-measured: the
  /// rail always starts at the same `top: 0` the article's own Stack does,
  /// so the article's rendered height already *is* the block's height.
  final GlobalKey articleAnchor;

  @override
  State<_StickyRail> createState() => _StickyRailState();
}

class _StickyRailState extends State<_StickyRail> {
  /// The rail's own un-translated box, so its position can be measured
  /// without measuring the [Transform] this state applies to reach it.
  final GlobalKey _rest = GlobalKey(debugLabel: 'DocsLayout sticky rail');
  ScrollPosition? _position;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ScrollPosition? next = Scrollable.maybeOf(context)?.position;
    if (!identical(next, _position)) {
      _position?.removeListener(_handleScroll);
      _position = next;
      _position?.addListener(_handleScroll);
    }
  }

  void _handleScroll() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _position?.removeListener(_handleScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: _rest,
      child: Transform.translate(
        offset: Offset(0, _translate()),
        child: widget.child,
      ),
    );
  }

  /// How far to push [child] down to counteract however much the ambient
  /// scroll has carried its resting position above the sticky line — zero
  /// before that line is reached, and zero again once translating further
  /// would push the rail's own bottom past the article's.
  ///
  /// Reads render boxes straight from [GlobalKey]s rather than a
  /// [LayoutBuilder]: what is needed is each box's *position*, settled only
  /// after layout, not a constraint available while building. The one frame
  /// of lag this risks — building against the previous frame's geometry — is
  /// the same trade-off [_DocsLayoutState._scrollToAnchor] already makes,
  /// and imperceptible for a value that only changes by a scroll delta.
  double _translate() {
    final ScrollPosition? position = _position;
    final RenderObject? viewport = Scrollable.maybeOf(
      context,
    )?.context.findRenderObject();
    final RenderObject? rest = _rest.currentContext?.findRenderObject();
    final RenderObject? article = widget.articleAnchor.currentContext
        ?.findRenderObject();
    if (position == null ||
        viewport is! RenderBox ||
        rest is! RenderBox ||
        article is! RenderBox) {
      return 0;
    }

    final double staticTop = rest
        .localToGlobal(Offset.zero, ancestor: viewport)
        .dy;
    final double wanted = math.max(0.0, ElWidths.siteHeader - staticTop);
    if (wanted == 0) return 0;

    final double articleBottom = article
        .localToGlobal(Offset(0, article.size.height), ancestor: viewport)
        .dy;
    final double maxTranslate = math.max(
      0.0,
      articleBottom - rest.size.height - staticTop,
    );
    return math.min(wanted, maxTranslate);
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
  final List<ElBreadcrumbEntry> breadcrumbs;
  final Widget child;
  final List<DocsTocEntry> toc;
  final DocsPageLink? previous;
  final DocsPageLink? next;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      key: const ValueKey<String>('docs-layout-article'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (breadcrumbs.isNotEmpty) ...<Widget>[
          ElBreadcrumb(items: breadcrumbs),
          SizedBox(height: el(5)),
        ],
        Container(
          padding: EdgeInsets.only(bottom: el(8)),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: theme.border, width: ElWidths.hairline),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ElText(intro.eyebrow, ElType.label, color: theme.actionInk),
              SizedBox(height: el(2)),
              ElText(
                intro.title,
                ElType.h1,
                fontSize: ElFluid.h1(context),
                color: theme.foreground,
              ),
              SizedBox(height: el(3)),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: ElWidths.prose),
                child: ElText(intro.description, ElType.lead),
              ),
            ],
          ),
        ),
        SizedBox(height: el(8)),
        child,
        SizedBox(height: el(12)),
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
      padding: EdgeInsets.only(left: el(5)),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: ElTheme.of(context).border,
            width: ElWidths.hairline,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ElText('ON THIS PAGE', ElType.label),
          SizedBox(height: el(3)),
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
    final Widget row = MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        key: ValueKey<String>('docs-layout-toc-entry:${entry.anchor}'),
        onTap: () => onAnchor(entry.anchor),
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: el(1.5)),
          child: ElText(entry.title, ElType.small),
        ),
      ),
    );
    if (!indented) return row;
    return Padding(
      key: ValueKey<String>('docs-layout-toc-child:${entry.anchor}'),
      padding: EdgeInsets.only(left: el(4)),
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
      height: el(10),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: flat.length,
        separatorBuilder: (_, _) => SizedBox(width: el(2)),
        itemBuilder: (BuildContext context, int index) {
          final DocsTocEntry entry = flat[index];
          return ElButton(
            key: ValueKey<String>('docs-layout-anchor-chip:${entry.anchor}'),
            variant: ElButtonVariant.outline,
            size: ElButtonSize.sm,
            label: 'Jump to ${entry.title}',
            onPressed: () => onAnchor(entry.anchor),
            child: ElText(entry.title, ElComponentType.buttonLabel),
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
      padding: EdgeInsets.only(top: el(6)),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: ElTheme.of(context).border,
            width: ElWidths.hairline,
          ),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: _PageLinkCard(link: previous, onNavigate: onNavigate),
          ),
          SizedBox(width: el(3)),
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
    return ElButton(
      variant: ElButtonVariant.outline,
      size: ElButtonSize.md,
      label: 'Open ${link!.title}',
      onPressed: () => onNavigate(link!.route),
      expanded: true,
      contentAlignment: Alignment.centerLeft,
      child: ElText(link!.title, ElComponentType.buttonLabel),
    );
  }
}
