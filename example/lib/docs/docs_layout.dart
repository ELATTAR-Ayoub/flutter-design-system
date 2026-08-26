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
// `PointerSignalEvent`/`PointerScrollEvent`/`GestureBinding` for
// `_RailHitCatchers` below — `material.dart` does not re-export
// `gestures.dart`. `LayerLink` (also used there) already comes through
// `material.dart` itself.
import 'package:flutter/gestures.dart';

import '../components_docs/catalog.dart' show ComponentDocEntry, componentDocs;
import '../kit.dart' show ElSection;
// The ambient router, so the rails navigate on pages that pass no callback.
import '../shell.dart' show AppRouterScope;
import '../site/site_routes.dart' show SiteRoute, SiteSection, siteRoutes;
import 'docs_link.dart';
import 'docs_sidebar.dart';

export 'docs_link.dart' show DocsLink, DocsLinkRow;
export 'docs_sidebar.dart' show DocsSidebar, DocsSidebarEntry, DocsSidebarGroup;

/// The share of the viewport's height either rail may occupy.
///
/// The rails are a desktop affordance by construction: the left rail only
/// renders at [ElBreakpoints.lg] and wider and the "ON THIS PAGE" rail only
/// at [ElBreakpoints.xl], and a narrower viewport — every tablet — gets the
/// horizontal [_AnchorStrip] instead and no rail at all. So this fraction is
/// only ever applied to a desktop viewport, and [_DocsLayoutState.build]
/// applies it only on the `wide` branch to keep that explicit rather than
/// implied.
///
/// A rail that fits inside this never notices it. It is the long
/// "Components" list, and a long outline on a component page, that stop
/// short of the fold instead of running the eye all the way to the bottom
/// edge of the screen: the rail reads as a panel with room around it rather
/// than as a column of text poured into the window.
const double _railViewportFraction = 0.8;

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

  /// One per rail — see [_SmoothRailScroll]. Held on the state, not rebuilt
  /// per frame, because each one carries the running target of an in-flight
  /// wheel animation across events: that is what makes a second notch
  /// arriving mid-animation extend the same glide instead of restarting it
  /// from wherever the first had reached.
  late final _SmoothRailScroll _sidebarWheel = _SmoothRailScroll(_sidebarScroll);
  late final _SmoothRailScroll _tocWheel = _SmoothRailScroll(_tocScroll);

  /// Tracks each rail's real on-screen box — including `_StickyRail`'s own
  /// vertical translate — for [_RailHitCatchers] to find from the ambient
  /// [Overlay]. See that class's doc comment for why an overlay entry is
  /// what the escaped band needs, not just a wider hit test on this widget's
  /// own [Stack].
  final LayerLink _sidebarLink = LayerLink();
  final LayerLink _tocLink = LayerLink();

  /// Shown once and left showing: [_RailHitCatchers] itself decides, every
  /// frame, whether either rail is actually on screen (`wide` / `extraWide`)
  /// and — via [CompositedTransformFollower.showWhenUnlinked] — whether its
  /// [LayerLink] is actually linked right now.
  final OverlayPortalController _railHitCatchers = OverlayPortalController();

  @override
  void initState() {
    super.initState();
    _railHitCatchers.show();
  }

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
    // Each rail begins BELOW the sticky header, so a rail capped at the full
    // viewport height runs past the fold and its last rows cannot be
    // reached. The gutter keeps the final row off the bottom edge.
    //
    // [_railViewportFraction] then caps it again, tighter, so a rail rests
    // at four fifths of the window rather than filling it. Both bounds are
    // kept: the fold bound is a correctness rule (a row below the fold
    // cannot be clicked) and the fraction is the house measure, and on a
    // short window the fold bound is the smaller of the two. Applied on the
    // `wide` branch only — the branch that renders a rail at all — so the
    // rule reads as what it is, a desktop rule. See [_railViewportFraction].
    final double viewportHeight = MediaQuery.sizeOf(context).height;
    final double foldMaxHeight =
        viewportHeight - ElWidths.siteHeader - el(4);
    final double railMaxHeight = wide
        ? math.min(viewportHeight * _railViewportFraction, foldMaxHeight)
        : foldMaxHeight;
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
    // **The rails no longer escape their own box, and that is the fix.**
    //
    // They used to be `Positioned` past the Stack's edge so they could sit at
    // the screen's edge rather than the reading column's. That put them
    // outside every ancestor box between here and the shell — and
    // `RenderBox.hitTest` gates on `_size.contains(position)` at EVERY
    // ancestor, so a pointer over the escaped band was rejected long before
    // it reached a row. The rails looked present and did nothing.
    //
    // It degraded with width, which is why it survived: the escape is half
    // the difference between the viewport and the reading column, so at 1440
    // roughly 144px of each rail stayed inside the box and clicking mostly
    // worked, while at 1909 a 24px sliver did and it did not.
    //
    // A previous fix noticed the same geometry for the WHEEL and routed
    // scroll events through an `Overlay` (`_RailHitCatchers`), which is not a
    // descendant of those narrow ancestors. Its own doc comment says plainly
    // that clicking "still depends on the ordinary, narrower hit-test path
    // (unchanged)". This closes that half — not by widening a gate, but by
    // removing the reason there was one.
    //
    // The rails now sit at the edges of the box this widget is given, and
    // `site_shell.dart` hands it the shell's full measure instead of the
    // narrower page column, so they land close to where the escape was
    // trying to put them — while staying inside every box that has to
    // hit-test them.
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

    return OverlayPortal(
      controller: _railHitCatchers,
      // Built fresh on every `_DocsLayoutState.build` — i.e. whenever
      // anything below might have moved the rails (ambient scroll, via
      // `_StickyRail`'s own listener triggering a `setState` up through this
      // widget's ancestry is not guaranteed, but [CompositedTransformFollower]
      // does not need it to be: it re-reads its [LayerLink]'s current
      // transform every compositing frame regardless of when this builder
      // last ran. This only needs to run often enough to keep `wide` /
      // `extraWide` current, which a normal rebuild already guarantees.
      overlayChildBuilder: (BuildContext context) => _RailHitCatchers(
        wide: wide,
        extraWide: extraWide,
        sidebarLink: _sidebarLink,
        tocLink: _tocLink,
        sidebarWheel: _sidebarWheel,
        tocWheel: _tocWheel,
        railMaxHeight: railMaxHeight,
      ),
      child: Semantics(
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
                // Kept as a named zero rather than deleted: `contentInset`
                // below is "a rail plus its gap, less whatever already sits
                // outside this box", and with no escape the second term is
                // nothing. Spelling that out is clearer than silently
                // dropping the subtraction.
                const double inset = 0.0;
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
                      left: inset,
                      top: 0,
                      child: _StickyRail(
                        articleAnchor: _article,
                        child: CompositedTransformTarget(
                          link: _sidebarLink,
                          child: SizedBox(
                            key: const ValueKey<String>('docs-layout-sidebar'),
                            // The rail is pinned to the screen edge, so its
                            // own gutter is what keeps the group labels and
                            // rows off that edge. Without it the first
                            // character of every row sits against the glass.
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
                                    // Deeper than this view's own
                                    // `Scrollable`, so it wins the
                                    // `PointerSignalResolver` and the rail
                                    // glides here too — see
                                    // [_SmoothRailScroll].
                                    child: Listener(
                                      behavior: HitTestBehavior.translucent,
                                      onPointerSignal:
                                          (PointerSignalEvent event) =>
                                              _sidebarWheel
                                                  .handlePointerSignal(
                                                    event,
                                                    context,
                                                  ),
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
                      ),
                    ),
                    if (extraWide)
                      Positioned(
                        right: inset,
                        top: 0,
                        child: _StickyRail(
                          articleAnchor: _article,
                          child: CompositedTransformTarget(
                            link: _tocLink,
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
                                      // See the sidebar's twin above.
                                      child: Listener(
                                        behavior: HitTestBehavior.translucent,
                                        onPointerSignal:
                                            (PointerSignalEvent event) =>
                                                _tocWheel.handlePointerSignal(
                                                  event,
                                                  context,
                                                ),
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
      ),
    );
  }
}

/// The escaped band's actual event path.
///
/// [DocsLayout]'s own `Stack` (`clipBehavior: Clip.none`, in the
/// [LayoutBuilder] above) paints each rail up to `inset` past its own box —
/// deliberately, so a rail reaches the screen edge on a wide viewport
/// instead of stopping at the reading column's margin. But
/// [RenderBox.hitTest] gates every hit test behind
/// `if (_size!.contains(position))` before it ever tries a child, and that
/// gate is not only the Stack's own: `_SiteBody` (site_shell.dart) narrows
/// the box this widget is given down to [ElWidths.page], centred, and every
/// ancestor between that narrowing and this Stack — the outer `Column`,
/// `Semantics`, `_SiteBody`'s own `ConstrainedBox`, and the render objects
/// `SelectionArea` itself introduces (`RenderTapRegion`, `RenderLeaderLayer`,
/// a `RenderPointerListener`) — applies the SAME gate against the SAME
/// narrow box. An earlier version of this fix overrode only the Stack's own
/// `hitTest`; verified against the real `SiteShell` tree (not just this
/// widget's own test harness) via a temporary diagnostic that walked the
/// mounted ancestor chain from the sidebar rail up to the `RenderView`, that
/// reached only the ~64 of each rail's 264 painted pixels that happen to
/// fall inside the SAME box every one of those ancestors shares — the rest
/// of the escaped band stayed exactly as unreachable as before, because the
/// ancestors that reject it FIRST (`_SiteBody`'s own, walked top-down before
/// this widget's Stack is ever reached) are not this widget's to override —
/// they live in a different file, out of this fix's stated scope, and
/// `SelectionArea`'s own internals are not cleanly subclassable at all.
///
/// [Transform.transformHitTests]'s own doc comment names the fix directly:
/// "Using an [OverlayEntry] or [OverlayPortal] to place the widget in an
/// [Overlay]." An [Overlay] entry is not a descendant of any of those narrow
/// ancestors — it paints (and hit-tests) directly against the [Navigator]'s
/// own full-bleed box (confirmed against the same real tree: the Overlay's
/// `_RenderTheater` measured the full viewport, unlike everything narrower
/// nested beneath it), so nothing upstream of it can reject a position
/// before this widget ever gets to try. This class is that overlay entry:
/// an invisible, otherwise-inert [CompositedTransformFollower] per rail,
/// linked (via a [LayerLink]) to a [CompositedTransformTarget] wrapping that
/// rail's own [SizedBox] — so it tracks the rail's real on-screen box,
/// including `_StickyRail`'s own vertical translate, automatically on every
/// compositing frame — sized to match it, and listening only for
/// [PointerScrollEvent]s, which it forwards to the SAME [ScrollController]
/// the rail's own [SingleChildScrollView] already uses, via
/// [ScrollPosition.pointerScroll] — the exact call `Scrollable` itself makes
/// internally for a wheel event ([RenderFollowerLayer.hitTest] deliberately
/// skips its own containment check for exactly this reason — see its
/// comment in `package:flutter/src/rendering/proxy_box.dart`). Nothing about
/// the rail's existing rendering, painting, or `_StickyRail` stickiness
/// changes: this widget only adds a second route to the SAME scroll
/// position, reachable from where the rail actually paints.
///
/// Registering through [PointerSignalResolver]
/// (`GestureBinding.instance.pointerSignalResolver`), exactly as
/// `Scrollable` does, means this defers correctly to the rail's own
/// [Scrollable] for the sliver of the band that WAS already reachable
/// (whichever hit-test entry is tried first wins the resolver; nothing
/// double-scrolls), and — because a delta that would not actually move the
/// position is never registered at all — degrades to a silent no-op (never
/// a swallowed page-scroll) over whatever portion of this catcher's
/// fixed-height footprint sits below a rail whose content is shorter than
/// [railMaxHeight]. Clicking a navigation row still depends on the ordinary,
/// narrower hit-test path (unchanged): only the wheel-scroll gap this class
/// exists to close is closed here.
class _RailHitCatchers extends StatelessWidget {
  const _RailHitCatchers({
    required this.wide,
    required this.extraWide,
    required this.sidebarLink,
    required this.tocLink,
    required this.sidebarWheel,
    required this.tocWheel,
    required this.railMaxHeight,
  });

  final bool wide;
  final bool extraWide;
  final LayerLink sidebarLink;
  final LayerLink tocLink;
  final _SmoothRailScroll sidebarWheel;
  final _SmoothRailScroll tocWheel;
  final double railMaxHeight;

  @override
  Widget build(BuildContext context) {
    // Tight, full-viewport bounds for the wrapping [Stack]: neither
    // [_RailWheelCatcher] is [Positioned], so [Stack] would otherwise need
    // to size itself from the larger of the two — harmless either way, since
    // an explicit, known-finite box is one fewer thing to reason about than
    // whatever constraint the ambient [Overlay] happens to hand its entries.
    //
    // No [IgnorePointer] wraps this: a [Stack] with no [hitTestSelf] of its
    // own (it has none) simply reports a MISS wherever neither catcher below
    // sits — the framework's own hit-test walk then keeps trying whatever is
    // painted underneath this overlay entry, i.e. the ordinary page. Only
    // the two small, exactly rail-sized [_RailWheelCatcher]s below are ever
    // actually reachable here, not this whole full-viewport box.
    final Size viewport = MediaQuery.sizeOf(context);
    return SizedBox(
      width: viewport.width,
      height: viewport.height,
      child: Stack(
        children: <Widget>[
          if (wide)
            _RailWheelCatcher(
              // Distinguishes this from `docs-layout-sidebar` itself (the
              // rail's own, normally hit-tested [SingleChildScrollView]) so
              // a test can tell which one actually answered a hit test —
              // see `docs_rail_scroll_test.dart`.
              key: const ValueKey<String>('docs-layout-sidebar-wheel-catcher'),
              link: sidebarLink,
              height: railMaxHeight,
              wheel: sidebarWheel,
            ),
          if (extraWide)
            _RailWheelCatcher(
              key: const ValueKey<String>('docs-layout-toc-wheel-catcher'),
              link: tocLink,
              height: railMaxHeight,
              wheel: tocWheel,
            ),
        ],
      ),
    );
  }
}

/// Turns a mouse-wheel notch over a rail into an animated glide instead of a
/// jump.
///
/// A raw [ScrollPosition.pointerScroll] — what [Scrollable] itself does, and
/// what this class replaced — moves the rail by the notch's full delta on the
/// very frame the event arrives. On a trackpad, which emits a stream of small
/// deltas, that reads fine. On a mouse wheel, which emits one large delta per
/// notch, the rail teleports: the "ON THIS PAGE" outline snaps by a third of
/// its height per click, and a reader loses their place in a list whose rows
/// all look alike. The article underneath scrolls smoothly (the page's own
/// [Scrollable] is driven by a real physics simulation), so the two surfaces
/// visibly disagree about what scrolling is.
///
/// This animates to the same destination instead, over [ElDurations.fast] on
/// [ElCurves.out]. Three details matter:
///
/// * **The target accumulates.** A notch arriving while a previous glide is
///   still running measures from that glide's destination ([_target]), not
///   from wherever the rail has physically reached. Spinning the wheel three
///   times therefore covers three notches of distance in one continuous
///   movement rather than three restarted, foreshortened ones.
/// * **Registration still goes through [PointerSignalResolver].** That is
///   what lets this cooperate with — rather than race — the rail's own
///   [Scrollable] over the band both can reach, exactly as the direct
///   `pointerScroll` call it replaced did. The deepest registrant wins, and
///   [_DocsLayoutState.build] deliberately mounts this handler *inside* each
///   rail's [SingleChildScrollView] so it is deeper than that view's own
///   [Scrollable] and takes the event there too — otherwise the escaped band
///   would glide and the rail's own body would still jump.
/// * **A delta that would not move the rail is never registered**, so this
///   never swallows an ambient page-scroll over a rail that is already at
///   its end, or over the catcher's dead space below a short rail.
class _SmoothRailScroll {
  _SmoothRailScroll(this.controller);

  final ScrollController controller;

  /// Where the in-flight animation is heading, or null when none is.
  double? _target;

  /// Mirrors `ScrollableState._receivedPointerSignal` for the one axis a rail
  /// ever scrolls: vertical, never reversed.
  void handlePointerSignal(PointerSignalEvent event, BuildContext context) {
    if (event is! PointerScrollEvent) return;
    if (!controller.hasClients) return;
    final ScrollPosition position = controller.position;
    final double delta = event.scrollDelta.dy;
    if (delta == 0.0) return;
    final double from = _target ?? position.pixels;
    final double target = (from + delta).clamp(
      position.minScrollExtent,
      position.maxScrollExtent,
    );
    if (target == from) return;
    final Duration duration = elAnimationDuration(context, ElDurations.fast);
    GestureBinding.instance.pointerSignalResolver.register(
      event,
      (PointerSignalEvent resolved) => _glideTo(target, duration),
    );
  }

  /// [ScrollPosition.animateTo] already degrades to a jump when [duration] is
  /// [Duration.zero], which is what `elAnimationDuration` returns under
  /// "reduce motion" — so this needs no branch of its own for that case, and
  /// an accessibility setting turns the glide off without turning the rail
  /// off.
  void _glideTo(double target, Duration duration) {
    if (!controller.hasClients) return;
    _target = target;
    controller.position
        .animateTo(target, duration: duration, curve: ElCurves.out)
        .whenComplete(() {
          if (_target == target) _target = null;
        });
  }
}

/// One rail's invisible wheel-event catcher — see [_RailHitCatchers].
class _RailWheelCatcher extends StatelessWidget {
  const _RailWheelCatcher({
    super.key,
    required this.link,
    required this.height,
    required this.wheel,
  });

  final LayerLink link;
  final double height;

  /// The same [_SmoothRailScroll] the rail's own body registers, so a notch
  /// delivered over the escaped band extends the very same glide a notch
  /// delivered over the rail proper would.
  final _SmoothRailScroll wheel;

  @override
  Widget build(BuildContext context) {
    return CompositedTransformFollower(
      link: link,
      // Nothing to catch (and nothing to show — this paints nothing either
      // way) while the linked rail is not mounted at all, e.g. `!wide`.
      showWhenUnlinked: false,
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerSignal: (PointerSignalEvent event) =>
            wheel.handlePointerSignal(event, context),
        child: SizedBox(width: ElWidths.rail + el(6), height: height),
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
              ElText(intro.eyebrow, ElType.section, color: theme.actionInk),
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
          ElText('ON THIS PAGE', ElType.section),
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

/// One row of the "ON THIS PAGE" rail.
///
/// A row is a **link** and now says so, in all three registers the
/// `/components` index's own links use ([DocsLink], extracted from it): a
/// pointer cursor, an ink cross-fade to `actionInk` on hover, and
/// `Semantics(link: true)` so a screen reader announces it as one. Before
/// this it carried only the cursor, which meant a rail of rows that looked
/// exactly like the captions elsewhere on the page and gave no feedback when
/// the pointer was actually over one — the same complaint the article's own
/// cross-references drew.
///
/// It composes the affordance rather than mounting a [DocsLink]: the
/// [MouseRegion] has to stay an **ancestor** of the row's keyed
/// [GestureDetector], which is where `docs_layout_test.dart` looks for it,
/// and a rail row scrolls rather than routes.
class _TocRow extends StatefulWidget {
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
  State<_TocRow> createState() => _TocRowState();
}

class _TocRowState extends State<_TocRow> {
  bool _hovered = false;

  void _hover(bool value) {
    if (_hovered == value) return;
    setState(() => _hovered = value);
  }

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    final DocsTocEntry entry = widget.entry;
    final Widget row = Semantics(
      // No label: the [ElText] below supplies it and merges up. See
      // [DocsLink], which makes the same choice for the same reason.
      link: true,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => _hover(true),
        onExit: (_) => _hover(false),
        child: GestureDetector(
          key: ValueKey<String>('docs-layout-toc-entry:${entry.anchor}'),
          onTap: () => widget.onAnchor(entry.anchor),
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: el(1.5)),
            child: TweenAnimationBuilder<Color?>(
              tween: ColorTween(
                end: _hovered ? theme.actionInk : theme.mutedForeground,
              ),
              duration: elAnimationDuration(
                context,
                ElDurations.transitionDefault,
              ),
              curve: ElCurves.out,
              builder: (BuildContext context, Color? ink, Widget? _) =>
                  ElText(
                    entry.title,
                    ElType.small,
                    color: ink ?? theme.mutedForeground,
                  ),
            ),
          ),
        ),
      ),
    );
    if (!widget.indented) return row;
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
