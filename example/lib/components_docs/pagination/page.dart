/// Public documentation page for the `pagination` component.
///
/// **Re-housed onto the kit.** This page used to hand-compose [Section]
/// panels; it now declares a `ComponentDocSpec`
/// (`example/lib/docs/component_doc_page.dart`) and hands it to
/// `ComponentDocPage`, the same shape `button` established. Every specimen
/// widget and every code string below is the same one the hand-composed
/// page carried. Truncation used to be one section mixing prose, two
/// worked-example text diagrams, and three live boundary specimens; a
/// [DocsPageSection] is flat, so it is now four: Truncation rule (the
/// prose and the two diagrams, genuinely nothing new to construct beyond
/// what the Preview specimen already shows live, so it stays a snippet),
/// First page, Last page, and Single page. Usage's own second code block
/// — a real caller computing its own range — is now Computed range, kept a
/// snippet: it names `myTruncatedRange`/`goTo`, helpers that exist only in
/// the hypothetical call site the comment describes, not in this file, so
/// a live stage would have to invent an app around them. New: a Keyboard
/// disclosure, between Accessibility and Responsive — pagination.dart
/// wires none of its own, but every cell is a real, composed [Button],
/// so Tab and Enter both genuinely work here, inherited whole.
///
/// **The one fact this page exists to get right:** `lib/src/components/ui/`
/// `pagination.dart` contains zero truncation logic. There is no
/// `siblingCount`, no `boundaryCount`, and no `generatePagination`-style
/// helper anywhere in that file, [Pagination.children] is a bare
/// `List<Widget>` and the caller decides, before it ever reaches the widget,
/// exactly which [PaginationLink] / [PaginationEllipsis] /
/// [PaginationStep] cells appear and in what order. The `1 … 46 47 48 …
/// 100` recipe the live demo and Truncation rule section render with is
/// **this documentation page's own function** (`_truncatedPageRange` below),
/// not a package API.
///
/// `pagination` has no `registry/components/pagination.json` manifest yet:
/// the Installation section says so honestly rather than presenting an
/// `elattar add pagination` command that would fail.
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

import '../../docs/component_doc_page.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../docs/docs_section.dart' show DocsAnchor;
import 'meta.dart';

final ComponentDocSpec paginationDocSpec = ComponentDocSpec(
  name: 'pagination',
  title: paginationDoc.title,
  description: paginationDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'A live, tappable specimen, 100 pages, starting on page 47. Tap '
          'any page number, or Previous/Next, and the row re-truncates '
          'around the new current page. At narrow widths the row scrolls '
          'horizontally instead of overflowing: see Responsive.',
      specimen: _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'pagination has no registry/components/pagination.json manifest '
          'yet: elattar add pagination is not resolvable against the real '
          'registry client. The Manual tab is the only install path this '
          'component has today.',
      command: paginationDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/pagination.dart',
          title: '1. Copy the source',
          description:
              'Copy lib/src/components/ui/pagination.dart from the package '
              'source directly, then update its relative imports '
              '(button.dart, icon.dart, icon_paths.dart, '
              'foundation/spacing.dart) to wherever you land them.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the pagination source here; no manifest exists to '
              'do this for you yet.',
        ),
        DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Export all four symbols (${paginationDoc.exports.join(', ')}) '
              'from your ui barrel so callers only import one file.',
          code: "export 'pagination.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'The smallest correct call: a fixed row with no computed range '
          'at all.',
      code: _usageCode,
    ),
    SnippetSection(
      id: 'computed-range',
      title: 'Computed range',
      description:
          'The shape a real caller with a page count builds: pagination '
          'does not compute this range for you, see Truncation rule below. '
          'This names myTruncatedRange and goTo, helpers that exist only '
          'in the hypothetical call site the comment describes, not in '
          'this file, so a live stage here would have to invent an app '
          'around them rather than show the real thing.',
      code: _computedRangeCode,
    ),
    SnippetSection(
      id: 'composition',
      title: 'Composition',
      description:
          'Pagination has no PaginationContent, PaginationItem, or '
          'PaginationLink to assemble by hand: children is a bare '
          'List<Widget> and the caller builds each cell directly. This is '
          'what a full row looks like once built — a structure diagram, '
          'not code a caller would write, so it stays a snippet rather '
          'than a stage with nothing live to show. See Composed with '
          'other primitives below for the real shape this package\'s own '
          'navigation reference page builds.',
      code: _compositionTree,
    ),
    ShowcaseSection(
      id: 'composed-with-primitives',
      title: 'Composed with other primitives',
      description:
          'Reproduced verbatim from example/lib/pages/navigation.dart, '
          'paired with the range label the Rules section of that same '
          'reference page recommends: "Showing 25–48 of 184 packs." '
          'Wrapped in the same horizontal scroll every specimen on this '
          'page uses: Pagination\'s own Row neither wraps nor scrolls; '
          'see Responsive.',
      specimen: _ComposedWithPrimitivesSpecimen(),
      code: _navigationReferenceCode,
      label: 'Composed with other primitives specimen view',
    ),
    SnippetSection(
      id: 'truncation-rule',
      title: 'Truncation rule',
      description:
          'This is the one thing this page exists to get right, read it '
          'before reaching for Simple or Icons only. '
          'lib/src/components/ui/pagination.dart is 227 lines and none of '
          'them compute a page range: there is no siblingCount, no '
          'boundaryCount, and no generatePagination-shaped helper '
          'anywhere in the file. Pagination.children is a bare '
          'List<Widget>: the caller decides, before construction, exactly '
          'which PaginationLink, PaginationEllipsis, and '
          'PaginationStep cells appear and in what order — the way '
          "example/lib/pages/navigation.dart's own reference section "
          'hard-codes one fixed shape (1, 2•, 3, …, 12) rather than '
          'deriving it from a page count. The rule the Preview specimen '
          'above renders with, _truncatedPageRange in pagination/page.dart '
          '(this documentation page\'s own function, not a package API): '
          'page 1 and the last page are always shown; the current page '
          'keeps one sibling on each side (siblingCount: 1, a call-site '
          'parameter of the demo function, not of Pagination); a gap '
          'that hides exactly one page shows that page plainly instead of '
          'an ellipsis, since collapsing a single number into a dots '
          'glyph the same width as the number would save nothing; a gap '
          'that hides two or more pages collapses to exactly one '
          'PaginationEllipsis cell. Worked at 100 pages, current page '
          '47: siblingCount: 1 keeps 46 and 48, page 1 and page 100 are '
          'always shown, and both the 44-page gap and the 51-page gap '
          'collapse to one ellipsis each. Move to page 2 instead and the '
          'left side has nothing left to hide (1 is both the boundary and '
          'the left sibling), so only the right side collapses. The same '
          'rule applies at both boundaries by omission, not by a disabled '
          'parameter: PaginationLink and PaginationStep have no '
          'enabled flag; see States.',
      code: _truncationDiagramsCode,
    ),
    ShowcaseSection(
      id: 'first-page',
      title: 'First page',
      description: 'Previous omitted entirely, not rendered disabled.',
      specimen: _FirstPageSpecimen(),
      code: _firstPageCode,
      label: 'First page specimen view',
    ),
    ShowcaseSection(
      id: 'last-page',
      title: 'Last page',
      description: 'Next omitted entirely, not rendered disabled.',
      specimen: _LastPageSpecimen(),
      code: _lastPageCode,
      label: 'Last page specimen view',
    ),
    ShowcaseSection(
      id: 'single-page',
      title: 'Single page',
      description: 'No siblings, no ellipsis, no steps.',
      specimen: _SinglePageSpecimen(),
      code: _singlePageCode,
      label: 'Single page specimen view',
    ),
    ShowcaseSection(
      id: 'simple',
      title: 'Simple',
      description:
          'The bare minimum: page links only, no Previous/Next step and '
          'no ellipsis, for a page count small enough that nothing ever '
          'needs truncating.',
      specimen: _SimpleSpecimen(),
      code: _simpleCode,
      label: 'Simple specimen view',
    ),
    ShowcaseSection(
      id: 'icons-only',
      title: 'Icons only',
      description:
          'Previous and Next with no page numbers between them: useful '
          'for a data table with its own rows-per-page control, where a '
          'page link row would only repeat what the table already shows. '
          'Pagination renders no rows-per-page picker of its own; pair '
          'it with whatever selection control the table already owns, '
          'the same way Composed with other primitives pairs the '
          'numbered row with a range label.',
      specimen: _IconsOnlySpecimen(),
      code: _iconsOnlyCode,
      label: 'Icons only specimen view',
    ),
    ShowcaseSection(
      id: 'rtl',
      title: 'RTL',
      description:
          'A genuinely direction-aware cell, not a recorded gap: '
          'PaginationStep builds its tight/loose padding from '
          'EdgeInsetsDirectional and resolves it against '
          'Directionality.of(context), so the tightened edge swaps sides '
          'under RTL the same way the reference\'s own pl-1.5!/pr-1.5! '
          'pair does. The chevron glyph itself does not mirror: '
          'PaginationStep.previous always draws chevronLeft, regardless '
          'of direction, exactly as the port\'s own source records.',
      specimen: _RtlSpecimen(),
      code: _rtlCode,
      label: 'RTL specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every public class and constructor parameter the source '
          'declares: four classes, no enums.',
      children: const <DocsTocEntry>[
        DocsTocEntry(title: 'Pagination', anchor: 'api-elpagination'),
        DocsTocEntry(title: 'PaginationLink', anchor: 'api-elpaginationlink'),
        DocsTocEntry(title: 'PaginationStep', anchor: 'api-elpaginationstep'),
        DocsTocEntry(
          title: 'PaginationEllipsis',
          anchor: 'api-elpaginationellipsis',
        ),
        DocsTocEntry(title: 'Static tokens', anchor: 'api-statics'),
      ],
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'Every cell is a Button, so hover, focus-visible, and pressed '
          'are inherited wholesale: the source\'s own words are "the pill, '
          'the spring, the focus ring and the press are the button\'s and '
          'are not restated," and that is reflected here rather than '
          're-described. There is no PaginationVariant and no size axis '
          'of its own: PaginationLink\'s only look decision is isActive, '
          'and every cell sits on a fixed ButtonSize rung (icon for the '
          'numbers and the ellipsis box, md for Previous/Next) that a '
          'caller cannot override.',
      child: const DocsStateMatrix(facts: _stateFacts),
    ),
    DisclosureSection(
      id: 'accessibility',
      title: 'Accessibility',
      child: _AccessibilityContent(),
    ),
    DisclosureSection(
      id: 'keyboard',
      title: 'Keyboard',
      description:
          'pagination.dart wires no key handling of its own — every fact '
          'here is inherited wholesale from Button, because every cell '
          'is one. Read off button.dart\'s own _onKey and Focus wrapper, '
          'the same source Button\'s own Keyboard section cites.',
      child: _KeyboardContent(),
    ),
    DisclosureSection(
      id: 'responsive',
      title: 'Responsive',
      child: _ResponsiveContent(),
    ),
    DisclosureSection(
      id: 'dependencies',
      title: 'Dependencies',
      description:
          "Elattar's own technical-transparency panel: what this "
          'component needs, and what has not been wired into the '
          'registry yet.',
      child: _DependenciesContent(),
    ),
    DisclosureSection(
      id: 'theming',
      title: 'Theming',
      child: _ThemingContent(),
    ),
    DisclosureSection(
      id: 'source',
      title: 'Source',
      child: DocsInstallFacts(
        title: 'Reference',
        facts: <DocsInstallFact>[
          DocsInstallFact(
            label: 'Source',
            value: paginationDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'none yet',
            description:
                'No dedicated unit test exists for pagination.dart in the '
                'package test suite as of this page.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/pagination_test.dart',
            description:
                'Covers this page: the API table, the truncation worked '
                'example, a tapped page updating the live specimen, the '
                'boundary specimens, and responsive/theme coverage at '
                '390×844 and 1440×900.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/pagination/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class PaginationDocPage extends StatelessWidget {
  const PaginationDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: paginationDoc.route,
    intro: DocsPageIntro(
      title: paginationDoc.title,
      description:
          'Pagination is a centred row of cells, page links, an optional '
          'ellipsis, and a Previous/Next step, built entirely out of '
          'Button: "every cell is a Button asChild wrapped around an '
          '<a>, so the pill, the spring, the focus ring and the press are '
          'the button\'s and are not restated." Reach for it when the '
          'list is bounded and addressable, a grid or table with a known '
          'total page count, not for a feed that only grows from the top '
          '(that is a load-more button). Pair it with a range label at '
          'the call site: Pagination renders the page links only and '
          'has no count or total of its own.',
    ),
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Components'),
      BreadcrumbEntry.page('Pagination'),
    ],
    toc: paginationDocSpec.toc,
    // The five already-routed pages, the same cautious fallback
    // `popover/page.dart` uses: no Wave 3 (overlay and navigation) sibling
    // route is guaranteed wired into `site_routes.dart`/`main.dart` yet
    // (those files are supervisor-owned and aggregated once per wave), so
    // this points only at routes known to exist rather than guessing.
    previous: const DocsPageLink(title: 'Select', route: '/components/select'),
    next: const DocsPageLink(title: 'Popover', route: '/components/popover'),
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('pagination-doc-article'),
      child: ComponentDocPage(spec: paginationDocSpec, header: false),
    ),
  );
}

/// The demo-only truncation recipe this page renders its specimens with.
///
/// **Nothing in `pagination.dart` computes this.** It lives in this
/// documentation file only, so the live demo and Truncation rule section
/// have a realistic large-page-count specimen to show and tap through. The
/// shape: always show page 1 and the last page, keep [siblingCount]
/// neighbours on each side of [currentPage], and collapse a gap into a
/// single ellipsis only when it hides two or more pages (a one-page gap
/// just shows that page: an ellipsis would take the same width as the
/// number it is hiding): is the same family of recipe shadcn's own
/// (unported) `usePagination` hook produces, chosen because it is the
/// standard, unsurprising rule, not because anything here requires it.
///
/// Returns the sequence to render: a page number, or `null` for one
/// ellipsis cell.
List<int?> _truncatedPageRange({
  required int totalPages,
  required int currentPage,
  int siblingCount = 1,
}) {
  final Set<int> shown = <int>{
    1,
    totalPages,
    for (
      int page = currentPage - siblingCount;
      page <= currentPage + siblingCount;
      page++
    )
      if (page >= 1 && page <= totalPages) page,
  };
  final List<int> sorted = shown.toList()..sort();
  final List<int?> result = <int?>[];
  for (int i = 0; i < sorted.length; i++) {
    if (i > 0) {
      final int gap = sorted[i] - sorted[i - 1];
      if (gap == 2) {
        // Exactly one page is hidden: show it plainly rather than
        // collapsing a single number into a dots glyph of the same width.
        result.add(sorted[i - 1] + 1);
      } else if (gap > 2) {
        result.add(null);
      }
    }
    result.add(sorted[i]);
  }
  return result;
}

/* ── Showcase specimens ─────────────────────────────────────────────────── */

/// The interactive worked example: 100 pages, starting on page 47. Tapping
/// any rendered page number (or Previous/Next) moves the current page and
/// re-truncates the row around it: a real, mounted [Pagination], not an
/// illustration.
class _PreviewSpecimen extends StatefulWidget {
  const _PreviewSpecimen();

  @override
  State<_PreviewSpecimen> createState() => _PreviewSpecimenState();
}

class _PreviewSpecimenState extends State<_PreviewSpecimen> {
  static const int _totalPages = 100;
  int _current = 47;

  void _goTo(int page) {
    if (page < 1 || page > _totalPages || page == _current) return;
    setState(() => _current = page);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final List<int?> range = _truncatedPageRange(
      totalPages: _totalPages,
      currentPage: _current,
    );
    return KeyedSubtree(
      key: const ValueKey<String>('pagination-preview:worked-example'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Horizontal scroll is this page's own mitigation for the Row
          // that Pagination itself never wraps or scrolls: see
          // Responsive.
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Pagination(
              children: <Widget>[
                PaginationStep.previous(onTap: () => _goTo(_current - 1)),
                for (final int? page in range)
                  if (page == null)
                    const PaginationEllipsis()
                  else
                    PaginationLink(
                      label: '$page',
                      isActive: page == _current,
                      onTap: () => _goTo(page),
                    ),
                PaginationStep.next(onTap: () => _goTo(_current + 1)),
              ],
            ),
          ),
          SizedBox(height: space(3)),
          StyledText(
            'Current page: $_current of $_totalPages',
            TextStyles.small,
            color: theme.mutedForeground,
          ),
        ],
      ),
    );
  }
}

class _ComposedWithPrimitivesSpecimen extends StatelessWidget {
  const _ComposedWithPrimitivesSpecimen();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        StyledText(
          'Showing 25–48 of 184 packs.',
          TextStyles.small,
          color: theme.mutedForeground,
        ),
        SizedBox(height: space(3)),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: const Pagination(
            children: <Widget>[
              PaginationStep.previous(),
              PaginationLink(label: '1'),
              PaginationLink(label: '2', isActive: true),
              PaginationLink(label: '3'),
              PaginationEllipsis(),
              PaginationLink(label: '12'),
              PaginationStep.next(),
            ],
          ),
        ),
      ],
    );
  }
}

class _FirstPageSpecimen extends StatelessWidget {
  const _FirstPageSpecimen();

  @override
  Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<String>('pagination-preview:first-page'),
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: const Pagination(
        children: <Widget>[
          PaginationLink(label: '1', isActive: true),
          PaginationLink(label: '2'),
          PaginationLink(label: '3'),
          PaginationEllipsis(),
          PaginationLink(label: '10'),
          PaginationStep.next(),
        ],
      ),
    ),
  );
}

class _LastPageSpecimen extends StatelessWidget {
  const _LastPageSpecimen();

  @override
  Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<String>('pagination-preview:last-page'),
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: const Pagination(
        children: <Widget>[
          PaginationStep.previous(),
          PaginationLink(label: '1'),
          PaginationEllipsis(),
          PaginationLink(label: '8'),
          PaginationLink(label: '9'),
          PaginationLink(label: '10', isActive: true),
        ],
      ),
    ),
  );
}

class _SinglePageSpecimen extends StatelessWidget {
  const _SinglePageSpecimen();

  @override
  Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<String>('pagination-preview:single-page'),
    child: const Pagination(
      children: <Widget>[PaginationLink(label: '1', isActive: true)],
    ),
  );
}

class _SimpleSpecimen extends StatelessWidget {
  const _SimpleSpecimen();

  @override
  Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<String>('pagination-simple'),
    child: const Pagination(
      children: <Widget>[
        PaginationLink(label: '1'),
        PaginationLink(label: '2', isActive: true),
        PaginationLink(label: '3'),
        PaginationLink(label: '4'),
        PaginationLink(label: '5'),
      ],
    ),
  );
}

class _IconsOnlySpecimen extends StatelessWidget {
  const _IconsOnlySpecimen();

  @override
  Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<String>('pagination-icons-only'),
    child: const Pagination(
      children: <Widget>[PaginationStep.previous(), PaginationStep.next()],
    ),
  );
}

class _RtlSpecimen extends StatelessWidget {
  const _RtlSpecimen();

  @override
  Widget build(BuildContext context) => const Directionality(
    textDirection: TextDirection.rtl,
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: KeyedSubtree(
        key: ValueKey<String>('pagination-rtl'),
        child: Pagination(
          children: <Widget>[
            PaginationStep.previous(text: 'السابق'),
            PaginationLink(label: '1'),
            PaginationLink(label: '2', isActive: true),
            PaginationLink(label: '3'),
            PaginationStep.next(text: 'التالي'),
          ],
        ),
      ),
    ),
  );
}

/* ── Source strings ─────────────────────────────────────────────────────── */

const String _previewCode = '''int current = 47;
const int totalPages = 100;

// The truncation recipe is this docs page's own function, not a package
// API: see Truncation rule below for the exact rule it implements.
final List<int?> range = _truncatedPageRange(
  totalPages: totalPages,
  currentPage: current,
);

SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Pagination(
    children: [
      PaginationStep.previous(onTap: () => goTo(current - 1)),
      for (final int? page in range)
        if (page == null)
          const PaginationEllipsis()
        else
          PaginationLink(
            label: '\$page',
            isActive: page == current,
            onTap: () => goTo(page),
          ),
      PaginationStep.next(onTap: () => goTo(current + 1)),
    ],
  ),
)''';

const String _usageCode =
    '''// The smallest correct call: a fixed row, no computed range at all.
const Pagination(
  children: <Widget>[
    PaginationStep.previous(),
    PaginationLink(label: '1', isActive: true),
    PaginationLink(label: '2'),
    PaginationLink(label: '3'),
    PaginationStep.next(),
  ],
)''';

const String _computedRangeCode =
    '''// A real caller with a page count computes the range itself: pagination
// does not do this for you (see Truncation rule): then builds the same
// shapes:
Pagination(
  children: <Widget>[
    PaginationStep.previous(onTap: page > 1 ? () => goTo(page - 1) : null),
    for (final int? p in myTruncatedRange(total: total, current: page))
      if (p == null)
        const PaginationEllipsis()
      else
        PaginationLink(
          label: '\$p',
          isActive: p == page,
          onTap: () => goTo(p),
        ),
    PaginationStep.next(
      onTap: page < total ? () => goTo(page + 1) : null,
    ),
  ],
)

// onTap: null above is still tappable: it just becomes a no-op via
// `onTap ?? () {}`. Omit the whole PaginationStep cell instead if the
// boundary must render as genuinely inert; see States.''';

const String _compositionTree = '''Pagination(children: [ … ])
 // each cell in children is one of:
 PaginationStep.previous()   // chevron + word, before the numbers
 PaginationLink(label: '1')  // one numbered page
 PaginationEllipsis()        // a collapsed run of hidden pages
 PaginationStep.next()       // chevron + word, after the numbers''';

const String _navigationReferenceCode =
    '''// example/lib/pages/navigation.dart, verbatim: a hard-coded shape, not
// a derived one.
const Pagination(
  children: <Widget>[
    PaginationStep.previous(),
    PaginationLink(label: '1'),
    PaginationLink(label: '2', isActive: true),
    PaginationLink(label: '3'),
    PaginationEllipsis(),
    PaginationLink(label: '12'),
    PaginationStep.next(),
  ],
)''';

const String _truncationDiagramsCode = '''100 pages, current page 47:
1  …  46  47  48  …  100

Current page 2 (left boundary and left sibling are the same page,
nothing left to hide on that side):
1  2  3  …  100''';

const String _firstPageCode = '''const Pagination(
  children: <Widget>[
    PaginationLink(label: '1', isActive: true),
    PaginationLink(label: '2'),
    PaginationLink(label: '3'),
    PaginationEllipsis(),
    PaginationLink(label: '10'),
    PaginationStep.next(),
  ],
)''';

const String _lastPageCode = '''const Pagination(
  children: <Widget>[
    PaginationStep.previous(),
    PaginationLink(label: '1'),
    PaginationEllipsis(),
    PaginationLink(label: '8'),
    PaginationLink(label: '9'),
    PaginationLink(label: '10', isActive: true),
  ],
)''';

const String _singlePageCode = '''const Pagination(
  children: <Widget>[
    PaginationLink(label: '1', isActive: true),
  ],
)''';

const String _simpleCode = '''const Pagination(
  children: <Widget>[
    PaginationLink(label: '1'),
    PaginationLink(label: '2', isActive: true),
    PaginationLink(label: '3'),
    PaginationLink(label: '4'),
    PaginationLink(label: '5'),
  ],
)''';

const String _iconsOnlyCode = '''const Pagination(
  children: <Widget>[
    PaginationStep.previous(),
    PaginationStep.next(),
  ],
)''';

const String _rtlCode = '''Directionality(
  textDirection: TextDirection.rtl,
  child: Pagination(
    children: <Widget>[
      PaginationStep.previous(text: 'السابق'),
      PaginationLink(label: '1'),
      PaginationLink(label: '2', isActive: true),
      PaginationLink(label: '3'),
      PaginationStep.next(text: 'التالي'),
    ],
  ),
)''';

/* ── Disclosure content ─────────────────────────────────────────────────── */

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsAnchor(
        id: 'api-elpagination',
        child: DocsApiTable(
          title: 'Pagination',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'children',
              type: 'List<Widget>',
              description:
                  'Required. One cell each, in order, PaginationLink, '
                  'PaginationEllipsis, and/or PaginationStep, already '
                  'decided by the caller. Pagination lays them out; it '
                  'does not choose them.',
            ),
          ],
        ),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elpaginationlink',
        child: DocsApiTable(
          title: 'PaginationLink',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'label',
              type: 'String',
              description: 'Required. The page number\'s text.',
            ),
            DocsApiFact(
              name: 'isActive',
              type: 'bool',
              description:
                  'Defaults to false. Picks the Button variant, '
                  'outline when true, ghost when false, and sets '
                  'Semantics.selected, which is what an assistive '
                  'technology reads as "current." There is no third '
                  'option and no way to pick a variant directly.',
            ),
            DocsApiFact(
              name: 'onTap',
              type: 'VoidCallback?',
              description:
                  'Defaults to null, which PaginationLink itself '
                  'replaces with an empty closure before handing it to '
                  'Button.onPressed: so the cell is always tappable. '
                  'There is no way to make one inert; see States.',
            ),
          ],
        ),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elpaginationstep',
        child: DocsApiTable(
          title: 'PaginationStep',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'PaginationStep.previous',
              type: 'const constructor',
              description:
                  'A chevron-left icon before the word. Defaults text to '
                  '"Previous".',
            ),
            DocsApiFact(
              name: 'PaginationStep.next',
              type: 'const constructor',
              description:
                  'A chevron-right icon after the word. Defaults text to '
                  '"Next".',
            ),
            DocsApiFact(
              name: 'text',
              type: 'String',
              description:
                  'Defaults to "Previous" / "Next" per constructor. Both '
                  'defaults are the reference\'s own; this page overrides '
                  'them only in the RTL section, to show a translated '
                  'word.',
            ),
            DocsApiFact(
              name: 'onTap',
              type: 'VoidCallback?',
              description:
                  'Same fallback-to-no-op behavior as '
                  'PaginationLink.onTap: always tappable, never truly '
                  'disabled.',
            ),
          ],
        ),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elpaginationellipsis',
        child: DocsApiTable(
          title: 'PaginationEllipsis',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: '(no fields)',
              type: 'n/a',
              description:
                  'Takes only a key. A fixed 32px square holding a 16px '
                  'ellipsis glyph, in a 40px-tall row: it carries no '
                  'page-count or "how many hidden" information of its '
                  'own.',
            ),
          ],
        ),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-statics',
        child: DocsApiTable(
          title: 'Static tokens',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'Pagination.gap',
              type: 'static double',
              description: 'The 2px gap between cells (gap-0.5).',
            ),
            DocsApiFact(
              name: 'PaginationStep.tightPadding',
              type: 'static double',
              description:
                  'The 6px !important-tightened edge: the side the '
                  'chevron sits against.',
            ),
            DocsApiFact(
              name: 'PaginationStep.loosePadding',
              type: 'static double',
              description:
                  'The untouched edge, ButtonSize.md\'s own 16px '
                  'horizontal padding, unchanged.',
            ),
            DocsApiFact(
              name: 'PaginationEllipsis.boxSize',
              type: 'static double',
              description: 'The 32px square the glyph centres in (size-8).',
            ),
            DocsApiFact(
              name: 'PaginationEllipsis.glyphSize',
              type: 'static double',
              description: 'The 16px glyph itself (size-4).',
            ),
          ],
        ),
      ),
    ],
  );
}

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Semantic role and name: Pagination wraps its row in '
            "Semantics(container: true, label: 'pagination', "
            'explicitChildNodes: true): a named, boundary-marked group '
            'with a real accessible name. It does not set role: '
            'SemanticsRole.navigation, and: checked against this '
            "package's own Flutter SDK (3.44.8): that framework's "
            'SemanticsRole enum has no navigation value to set even if it '
            'wanted to. The practical ceiling here is a labelled generic '
            'container, not a native nav landmark; that is a real gap '
            'against the web reference\'s role="navigation", not an '
            'oversight left undone.',
        'Current-page announcement: the current page IS announced as a '
            'state, not styling alone, PaginationLink wraps every cell '
            'in Semantics(link: true, selected: isActive). The underlying '
            'flag is "selected," not the web reference\'s '
            'aria-current="page": a different attribute name, same '
            'practical outcome, assistive tech distinguishes the current '
            'page from the rest.',
        'A merged role: Button itself also declares Semantics(button: '
            'true, enabled: true, ...) inside every cell, and neither '
            'wrapper sets its own container: true, so Flutter merges the '
            'two into one node carrying both link and button flags '
            'together. Recorded as observed, not corrected: the merge is '
            'a property of how Button is composed into, not a defect '
            'unique to pagination.',
        'Keyboard interactions: real, inherited from Button. See '
            'Keyboard below for the full account.',
        'Focus behavior: never moved automatically. Tapping a page '
            'number does not shift focus to a new location or announce '
            'the page change beyond the selected flag updating.',
        'Touch target: whatever ButtonSize.icon (40×40) and '
            'ButtonSize.md (Previous/Next, auto-width) already '
            'guarantee, pagination adds no padding of its own around a '
            'cell.',
        'Non-colour signal: the outline vs. ghost variant border, plus '
            'the label text itself ("1" vs. "2"), are the visible '
            'signals: colour is never the only cue for which page is '
            'current.',
        'Screen-reader announcements for the ellipsis: '
            'PaginationEllipsis wraps its glyph in ExcludeSemantics, so '
            'nothing is announced for it at all: no "more pages," no '
            'count of hidden pages. The source\'s own comment records the '
            'same intent the reference ships (an aria-hidden span around '
            'an sr-only label, which is a contradiction that hides the '
            'label too): "the port reproduces the outcome: nothing is '
            'announced."',
        'Known platform differences: none observed: pagination.dart '
            'branches on nothing platform-specific; the same widget tree '
            'renders everywhere.',
      ]);
}

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Tab order: every cell is a real, reachable stop. Each '
            'PaginationLink and PaginationStep wraps an Button whose '
            'onTap is never null (onTap ?? () {}), so Button\'s own '
            '_enabled — and canRequestFocus, which tracks it — is always '
            'true, on every cell, including a boundary cell a caller '
            'chose to omit entirely rather than disable.',
        'Activation: Enter, NumpadEnter, and Space activate a focused '
            'cell, the same _onKey button.dart wires for every Button: '
            'pagination.dart adds no key handling of its own, it is '
            'inherited whole because every cell genuinely is a Button.',
        'No arrow-key roving tabindex: pagination.dart wires no '
            'Shortcuts, Actions, or onKeyEvent of its own. A native '
            'pagination or tablist widget conventionally moves between '
            'cells with the arrow keys inside one shared tab stop; this '
            'component does not, every cell is its own stop in the tab '
            'order instead, and Tab must be pressed once per cell to '
            'reach the next one.',
        'No custom FocusTraversalPolicy: Tab and Shift+Tab walk '
            'whatever order the surrounding page already declares, cell '
            'by cell, left to right as composed.',
        'Focus ring: real and live here, unlike Tabs\' permanently inert '
            'one — whatever Button\'s own focus-visible ring does for '
            'the ghost or outline variant is exactly what a focused '
            'pagination cell shows, because nothing here repaints it.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Pagination lays its children out in a plain Row with '
            'mainAxisAlignment.center: a Row, not a Wrap. It does not '
            'wrap onto a second line and it does not scroll on its own. '
            'A long page range at a narrow width (the classic case: this '
            "page's own 100-page worked example, at 390px) will overflow "
            'that Row and trigger a RenderFlex overflow unless the call '
            'site does something about it.',
        'This page\'s own mitigation, used for every specimen above: '
            'wrap Pagination in a horizontally scrollable region '
            '(SingleChildScrollView(scrollDirection: Axis.horizontal)). '
            'That is docs-authored composition, not a Pagination '
            'feature: the alternative most callers reach for instead is '
            'shrinking siblingCount at narrow widths so the row simply '
            'has fewer cells to lay out.',
        'Cell sizes do not change with width, ButtonSize.icon stays a '
            'fixed 40×40 and ButtonSize.md keeps its own padding at '
            'every breakpoint; nothing here reflows or shrinks a cell '
            'for a small screen.',
        'Platform parity: Android, iOS, Web, macOS, Windows, and Linux '
            'all render the same widget tree; nothing branches on '
            'platform.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      _bullets(ThemeScope.of(context), <String>[
        'File: ${paginationDoc.sourcePath}: one file, four public '
            'classes, no companion parts.',
        'Direct imports: button.dart (Button, ButtonVariant, '
            'ButtonSize: every cell is one), icon.dart (Icon, '
            'IconTone) and icon_paths.dart (IconGlyph: the chevrons '
            'and the ellipsis glyph), and foundation/spacing.dart (space()) '
            'for every measurement on this page. No import of theme.dart, '
            'colors.dart, or shadows.dart directly: see Theming.',
        'No registry/components/pagination.json manifest wires these in '
            'automatically yet: see Installation above for the '
            'manual-only story this leaves.',
        'Assets: none. The chevron and ellipsis glyphs are vector path '
            'data compiled into icon_paths.g.dart, not image or font '
            'assets. Shaders: none. Pagination paints no colour or '
            'gradient of its own.',
        'Platforms: Android, iOS, Web, macOS, Windows, Linux — no '
            'platform-conditional code in pagination.dart.',
      ]),
      SizedBox(height: space(2)),
      const DocsLinkRow(
        links: <DocsLink>[
          DocsLink(label: 'Button', route: '/components/button'),
          DocsLink(label: 'Icon', route: '/components/icon'),
          DocsLink(
            label: 'Source Foundation',
            route: '/components/source_foundation',
          ),
        ],
      ),
    ],
  );
}

class _ThemingContent extends StatelessWidget {
  const _ThemingContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Pagination, PaginationLink, PaginationStep, and '
            'PaginationEllipsis paint no colour of their own: no '
            'DecoratedBox, no BoxDecoration, no direct theme.* read '
            'anywhere in pagination.dart. Every fill, border, and ink a '
            'cell shows comes from the Button it wraps (outline or '
            'ghost variant) or from Icon(tone: inherit) reading the '
            'button\'s own DefaultTextStyle.',
        'Type is inherited, not owned: ButtonSize.icon sets no text-* '
            'class of its own, so the page numbers ("1", "2", "12") '
            'render at the ambient body type, while Previous and Next '
            'sit one size class smaller (ButtonSize.md\'s own text-sm) '
            'because they carry a word, not a bare number, a fact about '
            'Button\'s size rungs, not a themeable pagination property.',
        'PaginationEllipsis is a fixed 32px square in the 40px row, '
            '4px shorter on every side than the number cells beside it, '
            'at every theme and breakpoint: sizing is not a themeable '
            'token here.',
        'Flipping ThemeController between light and dark re-resolves '
            'Button\'s own outline/ghost tokens exactly as it does '
            'anywhere else Button is used: pagination has no cached '
            'or independent colour of its own to go stale.',
        'There is no pagination-specific theming surface to override: a '
            'caller who needs a different look for a cell is overriding '
            'Button\'s variant tokens, not a parameter this component '
            'exposes.',
      ]);
}

Widget _bullets(ThemeTokens theme, List<String> lines) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: <Widget>[
    for (final String line in lines) ...<Widget>[
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: LayoutWidths.prose),
        child: StyledText(
          '•  $line',
          TextStyles.small,
          color: theme.mutedForeground,
        ),
      ),
      SizedBox(height: space(2)),
    ],
  ],
);

/* ── Facts ───────────────────────────────────────────────────────────────── */

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Rest',
    treatment:
        'ButtonVariant.ghost (numbers, Previous, Next) or .outline '
        '(the active page) at rest, exactly as Button paints those '
        'variants elsewhere.',
    userSignal:
        'The resting variant already distinguishes the current page '
        'from the rest: see Selected.',
  ),
  DocsStateFact(
    state: 'Hover / Focus-visible / Pressed',
    treatment:
        'Not repainted by pagination.dart: inherited entirely from '
        'Button\'s own hover fill, focus ring, and press spring for '
        'whichever variant (ghost or outline) the cell resolved to.',
    userSignal:
        'Identical to hovering, focusing, or pressing any other '
        'ghost/outline Button in the system.',
  ),
  DocsStateFact(
    state: 'Selected',
    treatment:
        'isActive: true on PaginationLink switches the variant to '
        'outline and sets Semantics(selected: true): a real semantic '
        'flag, not styling alone. See Accessibility for what "selected" '
        'does and does not announce.',
    userSignal:
        'The current page reads visually distinct (outline vs. ghost) '
        'and is exposed to assistive tech as selected.',
  ),
  DocsStateFact(
    state: 'Disabled',
    treatment:
        'N/A by design gap, not by choice, PaginationLink and '
        'PaginationStep have no enabled/disabled parameter at all. '
        'onTap ?? () {} means Button.onPressed is never null, so '
        'Button\'s own _enabled is always true: a cell with no onTap '
        'given is still fully hoverable, focusable, and pressable, it '
        'just does nothing when pressed.',
    userSignal:
        'A caller wanting a "disabled Previous" on page 1 must omit '
        'the PaginationStep.previous cell entirely: see First page '
        'above, because nothing here renders a dimmed, inert version '
        'of it.',
  ),
  DocsStateFact(
    state: 'Loading / Empty / Error / Success',
    treatment:
        'N/A, Pagination and its three cell types are all '
        'StatelessWidgets with no async parameter, no error state, and '
        'no empty-state rendering. A caller building a loading or '
        'empty list state owns that entirely outside this component.',
    userSignal: 'N/A',
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment:
        'Not reimplemented here: whatever Button\'s own press spring '
        'does under a reduced-motion preference is what every '
        'pagination cell does too, because every cell is a Button.',
    userSignal: 'Same as any other Button on the page.',
  ),
];
