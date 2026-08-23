/// Public documentation page for the `pagination` component.
///
/// Mirrors `badge/page.dart`'s use of the Phase C docs primitives
/// (`DocsLayout`, `DocsCodeExample`, `DocsApiTable`, `DocsStateMatrix`,
/// `DocsInstallFacts`) and `kit.dart`'s `DsSection` for titled,
/// anchor-registered content blocks, and `switch/meta.dart`'s two-constant
/// description split (`paginationDoc.description` for nav/search,
/// [paginationExpandedDescription] for "when to use this instead of a
/// neighbour").
///
/// **The one fact this page exists to get right:** `lib/src/components/`
/// `pagination.dart` contains zero truncation logic. There is no
/// `siblingCount`, no `boundaryCount`, and no `generatePagination`-style
/// helper anywhere in that file — [DsPagination.children] is a bare
/// `List<Widget>` and the caller decides, before it ever reaches the widget,
/// exactly which [DsPaginationLink] / [DsPaginationEllipsis] /
/// [DsPaginationStep] cells appear and in what order. The `1 … 46 47 48 …
/// 100` recipe this page's Preview and Truncation sections render with is
/// **this documentation page's own function** (`_truncatedPageRange` below),
/// not a package API — see the Truncation section for the worked example and
/// the exact rule it implements.
///
/// `pagination` has no registry manifest yet
/// (`registry/components/pagination.json` does not exist) — the Installation
/// section says so honestly rather than presenting an `elattar add
/// pagination` command that would fail.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/docs_code.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../kit.dart';
import 'meta.dart';

class PaginationDocPage extends StatelessWidget {
  const PaginationDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: paginationDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / BASE',
      title: paginationDoc.title,
      description: paginationDoc.description,
    ),
    breadcrumbs: const <DsBreadcrumbEntry>[
      DsBreadcrumbEntry.link('Components'),
      DsBreadcrumbEntry.page('Pagination'),
    ],
    sidebar: _sidebar,
    toc: const <DocsTocEntry>[
      DocsTocEntry(title: 'Overview', anchor: 'overview'),
      DocsTocEntry(title: 'Preview', anchor: 'preview'),
      DocsTocEntry(title: 'Truncation', anchor: 'truncation'),
      DocsTocEntry(title: 'Install', anchor: 'install'),
      DocsTocEntry(title: 'Usage', anchor: 'usage'),
      DocsTocEntry(title: 'API', anchor: 'api'),
      DocsTocEntry(title: 'Variants', anchor: 'variants'),
      DocsTocEntry(title: 'States', anchor: 'states'),
      DocsTocEntry(title: 'Accessibility', anchor: 'accessibility'),
      DocsTocEntry(title: 'Responsive', anchor: 'responsive'),
      DocsTocEntry(title: 'Dependencies', anchor: 'dependencies'),
      DocsTocEntry(title: 'Composition', anchor: 'composition'),
      DocsTocEntry(title: 'Theming', anchor: 'theming'),
      DocsTocEntry(title: 'Source', anchor: 'source'),
    ],
    // The five already-routed pages, the same cautious fallback
    // `popover/page.dart` uses: no Wave 3 (overlay and navigation) sibling
    // route is guaranteed wired into `site_routes.dart`/`main.dart` yet
    // (those files are supervisor-owned and aggregated once per wave), so
    // this points only at routes known to exist rather than guessing.
    previous: const DocsPageLink(title: 'Select', route: '/components/select'),
    next: const DocsPageLink(title: 'Popover', route: '/components/popover'),
    onNavigate: onNavigate,
    child: const _PaginationArticle(),
  );
}

/// The Wave 3 "overlay and navigation" group pagination belongs to (IA
/// §7.3), narrowed to routes this worker can confirm exist on disk as of
/// this page — `example/lib/components_docs/<name>/page.dart` files that
/// have actually landed — plus the five already-routed pages from Phase F.
/// The supervisor aggregates the real, complete sidebar in `catalog.dart`
/// and `site_routes.dart`; this list is not wired into either.
const List<DocsSidebarEntry> _sidebar = <DocsSidebarEntry>[
  DocsSidebarEntry(title: 'Button', route: '/components/button'),
  DocsSidebarEntry(title: 'Card', route: '/components/card'),
  DocsSidebarEntry(title: 'Input', route: '/components/input'),
  DocsSidebarEntry(title: 'Dialog', route: '/components/dialog'),
  DocsSidebarEntry(title: 'Select', route: '/components/select'),
  DocsSidebarEntry(title: 'Alert Dialog', route: '/components/alert-dialog'),
  DocsSidebarEntry(
    title: 'Pagination',
    route: '/components/pagination',
    selected: true,
  ),
  DocsSidebarEntry(title: 'Popover', route: '/components/popover'),
  DocsSidebarEntry(title: 'Sheet & Drawer', route: '/components/sheet'),
];

/// The demo-only truncation recipe this page renders its specimens with.
///
/// **Nothing in `pagination.dart` computes this.** It lives in this
/// documentation file only, so the Preview and Truncation sections have a
/// realistic large-page-count specimen to show and tap through. The shape —
/// always show page 1 and the last page, keep [siblingCount] neighbours on
/// each side of [currentPage], and collapse a gap into a single ellipsis
/// only when it hides two or more pages (a one-page gap just shows that page
/// — an ellipsis would take the same width as the number it is hiding) — is
/// the same family of recipe shadcn's own (unported) `usePagination` hook
/// produces, chosen because it is the standard, unsurprising rule, not
/// because anything here requires it.
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
        // Exactly one page is hidden — show it plainly rather than
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

class _PaginationArticle extends StatelessWidget {
  const _PaginationArticle();

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Column(
      key: const ValueKey<String>('pagination-doc-article'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _overview(theme),
        _preview(),
        _truncation(theme),
        _install(),
        _usage(),
        _api(),
        _variants(theme),
        _states(),
        _accessibility(theme),
        _responsive(theme),
        _dependencies(theme),
        _composition(),
        _theming(theme),
        _source(),
      ],
    );
  }

  Widget _overview(DsThemeData theme) => DsSection(
    id: 'overview',
    title: 'Overview',
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: DsWidths.prose),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DsText(
            'DsPagination is a centred row of cells — page links, an '
            'optional ellipsis, and a Previous/Next step — built entirely '
            'out of DsButton. Its own library doc puts the composition '
            'plainly: "every cell is a Button asChild wrapped around an '
            '<a>, so the pill, the spring, the focus ring and the press '
            'are the button\'s and are not restated." DsPagination itself '
            'contributes exactly one thing: the 2px gap between cells and '
            'the centring.',
            DsType.body,
          ),
          SizedBox(height: ds(4)),
          DsText(paginationExpandedDescription, DsType.body),
          SizedBox(height: ds(4)),
          DsText(
            'Status: stable primitive, not yet registered in the CLI (see '
            'Install). Version: tracks the package version — no '
            'independent versioning of its own. Platforms: Android, iOS, '
            'Web, macOS, Windows, Linux — the same six every widget in '
            'this package targets; nothing in pagination.dart branches on '
            'platform.',
            DsType.small,
            color: theme.mutedForeground,
          ),
        ],
      ),
    ),
  );

  Widget _preview() => DsSection(
    id: 'preview',
    title: 'Preview',
    description:
        'A live, tappable specimen — 100 pages, starting on page 47. Tap '
        'any page number, or Previous/Next, and the row re-truncates '
        'around the new current page. At narrow widths the row scrolls '
        'horizontally instead of overflowing — see Responsive.',
    child: DocsCodeExample(
      title: 'Pagination specimen',
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/pagination.dart',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Pagination has no registry manifest yet — copy\n'
              '// lib/src/components/pagination.dart from the package\n'
              '// source directly. There is no generated CLI payload to\n'
              '// fetch.',
        ),
      ],
      preview: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const KeyedSubtree(
            key: ValueKey<String>('pagination-preview:worked-example'),
            child: _TruncatedPaginationSpecimen(),
          ),
          SizedBox(height: ds(6)),
          DsText('Boundary specimens', DsType.label),
          SizedBox(height: ds(3)),
          KeyedSubtree(
            key: const ValueKey<String>('pagination-preview:first-page'),
            child: _EdgeCaseSpecimen(
              caption: 'First page — Previous omitted entirely',
              child: DsPagination(
                children: <Widget>[
                  const DsPaginationLink(label: '1', isActive: true),
                  const DsPaginationLink(label: '2'),
                  const DsPaginationLink(label: '3'),
                  const DsPaginationEllipsis(),
                  const DsPaginationLink(label: '10'),
                  const DsPaginationStep.next(),
                ],
              ),
            ),
          ),
          SizedBox(height: ds(4)),
          KeyedSubtree(
            key: const ValueKey<String>('pagination-preview:last-page'),
            child: _EdgeCaseSpecimen(
              caption: 'Last page — Next omitted entirely',
              child: DsPagination(
                children: <Widget>[
                  const DsPaginationStep.previous(),
                  const DsPaginationLink(label: '1'),
                  const DsPaginationEllipsis(),
                  const DsPaginationLink(label: '8'),
                  const DsPaginationLink(label: '9'),
                  const DsPaginationLink(label: '10', isActive: true),
                ],
              ),
            ),
          ),
          SizedBox(height: ds(4)),
          KeyedSubtree(
            key: const ValueKey<String>('pagination-preview:single-page'),
            child: _EdgeCaseSpecimen(
              caption: 'A single page — no siblings, no ellipsis, no steps',
              child: const DsPagination(
                children: <Widget>[
                  DsPaginationLink(label: '1', isActive: true),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _truncation(DsThemeData theme) => DsSection(
    id: 'truncation',
    title: 'The truncation rule',
    description:
        'This is the one thing this page exists to get right — read it '
        'before Usage.',
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: DsWidths.prose),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DsNote(
            tone: DsNoteTone.value,
            title: 'DsPagination computes none of this',
            child: DsText(
              'lib/src/components/pagination.dart is 227 lines and none of '
              'them compute a page range. There is no siblingCount, no '
              'boundaryCount, and no generatePagination-shaped helper '
              'anywhere in the file. DsPagination.children is a bare '
              'List<Widget> — the caller decides, before construction, '
              'exactly which DsPaginationLink, DsPaginationEllipsis, and '
              'DsPaginationStep cells appear and in what order. If a page '
              'range needs computing, the call site computes it — the way '
              "example/lib/pages/navigation.dart's own reference section "
              'hard-codes one fixed shape (1, 2•, 3, …, 12) rather than '
              'deriving it from a page count.',
              DsType.body,
            ),
          ),
          SizedBox(height: ds(4)),
          DsText(
            'The rule the specimens on this page render with — '
            '_truncatedPageRange in pagination/page.dart, this '
            'documentation page\'s own function, not a package API — is: ',
            DsType.body,
          ),
          SizedBox(height: ds(2)),
          _bulletColumn(theme, <String>[
            'Page 1 and the last page are always shown.',
            'The current page keeps one sibling on each side '
                '(siblingCount: 1 — a call-site parameter of the demo '
                'function, not of DsPagination).',
            'A gap that hides exactly one page shows that page plainly '
                'instead of an ellipsis — collapsing a single number into '
                'a dots glyph the same width as the number would save '
                'nothing.',
            'A gap that hides two or more pages collapses to exactly one '
                'DsPaginationEllipsis cell.',
          ]),
          SizedBox(height: ds(4)),
          DsPanel(
            label: 'WORKED EXAMPLE',
            note: '100 pages, current page 47',
            child: Padding(
              padding: EdgeInsets.all(ds(4)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  DsText(
                    'siblingCount: 1 keeps 46 and 48. Page 1 and page 100 '
                    'are always shown. The gap between 1 and 46 hides 44 '
                    'pages, so it collapses to one ellipsis; the gap '
                    'between 48 and 100 hides 51 pages, so it collapses '
                    'to one ellipsis too.',
                    DsType.small,
                    color: theme.mutedForeground,
                  ),
                  SizedBox(height: ds(3)),
                  const DocsSelectableCodeBlock(
                    code: '1  …  46  47  48  …  100',
                  ),
                  SizedBox(height: ds(3)),
                  DsText(
                    'Move to page 2 instead and the picture changes: '
                    'siblings are 1 and 3, so the left side has nothing '
                    'left to hide (1 is both the boundary and the left '
                    'sibling) and only the right side collapses:',
                    DsType.small,
                    color: theme.mutedForeground,
                  ),
                  SizedBox(height: ds(3)),
                  const DocsSelectableCodeBlock(code: '1  2  3  …  100'),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _install() => DsSection(
    id: 'install',
    title: 'Installation',
    description:
        'pagination has no registry manifest yet, so `elattar add '
        'pagination` is not available — install by copying the source '
        'file manually.',
    child: DocsInstallFacts(
      title: 'Installation facts',
      facts: <DocsInstallFact>[
        const DocsInstallFact(
          label: 'Registry item',
          value: 'not yet registered',
          description:
              'No registry/components/pagination.json exists. This is a '
              'source-only component today.',
        ),
        const DocsInstallFact(
          label: 'Destination',
          value: 'lib/components/ui/pagination.dart',
          description: 'Where a manual copy of the source belongs.',
        ),
        const DocsInstallFact(
          label: 'Foundation',
          value: 'source only',
          description: 'No package-backed alternative is offered yet.',
        ),
        const DocsInstallFact(
          label: 'Dependencies',
          value: 'button, icon, icon_paths, source-foundation',
          description:
              'What a future manifest would need to resolve — pagination '
              'imports button.dart, icon.dart, and icon_paths.dart '
              'directly, plus foundation/spacing.dart for ds(). None of '
              'this is resolved automatically today; copy the imports by '
              'hand.',
        ),
        const DocsInstallFact(
          label: 'Assets',
          value: 'none',
          description:
              'The chevron and ellipsis glyphs are vector path data '
              'compiled into icon_paths.g.dart, not image or font assets.',
        ),
        const DocsInstallFact(
          label: 'Shaders',
          value: 'none',
          description: 'Pagination paints no color or gradient of its own.',
        ),
        DocsInstallFact(
          label: 'Platforms',
          value: 'Android, iOS, Web, macOS, Windows, Linux',
          description: 'No platform-conditional code in pagination.dart.',
        ),
        const DocsInstallFact(
          label: 'Verified',
          value: 'docs specimen only',
          description:
              'This page\'s live preview and '
              'example/test/components_docs/pagination_test.dart. No '
              'dedicated package-level unit test and no registry fixture '
              'install exist yet — there is nothing to install.',
        ),
      ],
    ),
  );

  Widget _usage() => DsSection(
    id: 'usage',
    title: 'Usage',
    description:
        'The smallest correct call — a fixed row with no computed range at '
        'all — then the shape a real caller with a page count builds.',
    child: DsPanel(
      label: 'DART',
      note: 'COMPOSE',
      child: DocsSelectableCodeBlock(code: _usageCode),
    ),
  );

  Widget _api() => DsSection(
    id: 'api',
    title: 'API',
    description:
        'Every public class and constructor parameter the source declares '
        '— four classes, no enums.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const DocsApiTable(
          title: 'DsPagination',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'children',
              type: 'List<Widget>',
              description:
                  'Required. One cell each, in order — DsPaginationLink, '
                  'DsPaginationEllipsis, and/or DsPaginationStep, already '
                  'decided by the caller. DsPagination lays them out; it '
                  'does not choose them.',
            ),
          ],
        ),
        SizedBox(height: ds(5)),
        const DocsApiTable(
          title: 'DsPaginationLink',
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
                  'Defaults to false. Picks the DsButton variant — '
                  'outline when true, ghost when false — and sets '
                  'Semantics.selected, which is what an assistive '
                  'technology reads as "current."',
            ),
            DocsApiFact(
              name: 'onTap',
              type: 'VoidCallback?',
              description:
                  'Defaults to null, which DsPaginationLink itself '
                  'replaces with an empty closure before handing it to '
                  'DsButton.onPressed — so the cell is always tappable. '
                  'There is no way to make one inert; see States.',
            ),
          ],
        ),
        SizedBox(height: ds(5)),
        const DocsApiTable(
          title: 'DsPaginationStep',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'DsPaginationStep.previous',
              type: 'const constructor',
              description:
                  'A chevron-left icon before the word. Defaults text to '
                  '"Previous".',
            ),
            DocsApiFact(
              name: 'DsPaginationStep.next',
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
                  'defaults are the reference\'s own; this page never '
                  'overrides either.',
            ),
            DocsApiFact(
              name: 'onTap',
              type: 'VoidCallback?',
              description:
                  'Same fallback-to-no-op behavior as DsPaginationLink.onTap '
                  '— always tappable, never truly disabled.',
            ),
          ],
        ),
        SizedBox(height: ds(5)),
        const DocsApiTable(
          title: 'DsPaginationEllipsis',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: '(no fields)',
              type: '—',
              description:
                  'Takes only a key. A fixed 32px square holding a 16px '
                  'ellipsis glyph, in a 40px-tall row — it carries no '
                  'page-count or "how many hidden" information of its '
                  'own.',
            ),
          ],
        ),
        SizedBox(height: ds(5)),
        const DocsApiTable(
          title: 'Static tokens',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'DsPagination.gap',
              type: 'static double',
              description: 'The 2px gap between cells (gap-0.5).',
            ),
            DocsApiFact(
              name: 'DsPaginationStep.tightPadding',
              type: 'static double',
              description:
                  'The 6px !important-tightened edge — the side the '
                  'chevron sits against.',
            ),
            DocsApiFact(
              name: 'DsPaginationStep.loosePadding',
              type: 'static double',
              description:
                  'The untouched edge — DsButtonSize.md\'s own 16px '
                  'horizontal padding, unchanged.',
            ),
            DocsApiFact(
              name: 'DsPaginationEllipsis.boxSize',
              type: 'static double',
              description: 'The 32px square the glyph centres in (size-8).',
            ),
            DocsApiFact(
              name: 'DsPaginationEllipsis.glyphSize',
              type: 'static double',
              description: 'The 16px glyph itself (size-4).',
            ),
          ],
        ),
      ],
    ),
  );

  Widget _variants(DsThemeData theme) => DsSection(
    id: 'variants',
    title: 'Variants and sizes',
    description:
        'Pagination has no variant enum and no size axis of its own. Every '
        'cell is DsButtonSize.icon (the numbers, the ellipsis box) or '
        'DsButtonSize.md (Previous/Next) — fixed rungs, not a parameter a '
        'caller can change on this component.',
    child: _bulletColumn(theme, <String>[
      'DsPaginationLink has exactly two looks, chosen by isActive: '
          'DsButtonVariant.outline for the current page, '
          'DsButtonVariant.ghost for every other one. There is no third '
          'option and no way to pick a variant directly.',
      'The page numbers inherit their type from the page rather than '
          'declaring their own — DsButtonSize.icon sets no text-* class '
          'at all, so "1", "2", "3" and "12" render at the ambient body '
          'type, while Previous and Next sit one size class smaller '
          '(DsButtonSize.md\'s own text-sm) because they carry a word, '
          'not a bare number. One row, two effective type sizes — a fact '
          'about DsButton\'s rungs, not a knob pagination exposes.',
      'DsPaginationEllipsis is a fixed 32px square in the 40px row — '
          '4px shorter on every side than the number cells beside it, '
          'always.',
    ]),
  );

  Widget _states() => DsSection(
    id: 'states',
    title: 'States and feedback',
    description:
        'Every cell is a DsButton, so hover, focus-visible, and pressed '
        'are inherited wholesale — the source\'s own words are "the pill, '
        'the spring, the focus ring and the press are the button\'s and '
        'are not restated," and that is reflected here rather than '
        're-described. The rows below are grouped and reasoned rather '
        'than invented for the ones that genuinely do not apply.',
    child: const DocsStateMatrix(
      facts: <DocsStateFact>[
        DocsStateFact(
          state: 'Rest',
          treatment:
              'DsButtonVariant.ghost (numbers, Previous, Next) or '
              '.outline (the active page) at rest, exactly as DsButton '
              'paints those variants elsewhere.',
          userSignal:
              'The resting variant already distinguishes the '
              'current page from the rest — see Selected.',
        ),
        DocsStateFact(
          state: 'Hover / Focus-visible / Pressed',
          treatment:
              'Not repainted by pagination.dart — inherited entirely '
              'from DsButton\'s own hover fill, focus ring, and press '
              'spring for whichever variant (ghost or outline) the cell '
              'resolved to.',
          userSignal:
              'Identical to hovering, focusing, or pressing any '
              'other ghost/outline DsButton in the system.',
        ),
        DocsStateFact(
          state: 'Selected',
          treatment:
              'isActive: true on DsPaginationLink switches the variant '
              'to outline and sets Semantics(selected: true) — a real '
              'semantic flag, not styling alone. See Accessibility for '
              'what "selected" does and does not announce.',
          userSignal:
              'The current page reads visually distinct (outline vs. '
              'ghost) and is exposed to assistive tech as selected.',
        ),
        DocsStateFact(
          state: 'Disabled',
          treatment:
              'N/A by design gap, not by choice — DsPaginationLink and '
              'DsPaginationStep have no enabled/disabled parameter at '
              'all. onTap ?? () {} means DsButton.onPressed is never '
              'null, so DsButton\'s own _enabled is always true: a cell '
              'with no onTap given is still fully hoverable, focusable, '
              'and pressable, it just does nothing when pressed.',
          userSignal:
              'A caller wanting a "disabled Previous" on page 1 must '
              'omit the DsPaginationStep.previous cell entirely — see '
              'the Preview section\'s boundary specimens — because '
              'nothing here renders a dimmed, inert version of it.',
        ),
        DocsStateFact(
          state: 'Loading / Empty / Error / Success',
          treatment:
              'N/A — DsPagination and its three cell types are all '
              'StatelessWidgets with no async parameter, no error state, '
              'and no empty-state rendering. A caller building a loading '
              'or empty list state owns that entirely outside this '
              'component.',
          userSignal: 'N/A',
        ),
        DocsStateFact(
          state: 'Reduced motion',
          treatment:
              'Not reimplemented here — whatever DsButton\'s own press '
              'spring does under a reduced-motion preference is what '
              'every pagination cell does too, because every cell is a '
              'DsButton.',
          userSignal: 'Same as any other DsButton on the page.',
        ),
      ],
    ),
  );

  Widget _accessibility(DsThemeData theme) => DsSection(
    id: 'accessibility',
    title: 'Accessibility and keyboard behavior',
    child: _bulletColumn(theme, <String>[
      'Semantic role and name: DsPagination wraps its row in '
          "Semantics(container: true, label: 'pagination', "
          'explicitChildNodes: true) — a named, boundary-marked group '
          'with a real accessible name. It does not set role: '
          'SemanticsRole.navigation, and — checked against this '
          "package's own Flutter SDK (3.44.8) — that framework's "
          'SemanticsRole enum has no navigation value to set even if it '
          'wanted to. The practical ceiling here is a labelled generic '
          'container, not a native nav landmark; that is a real gap '
          'against the web reference\'s role="navigation", not an '
          'oversight left undone.',
      'Current-page announcement: the current page IS announced as a '
          'state, not styling alone — DsPaginationLink wraps every cell '
          'in Semantics(link: true, selected: isActive). The underlying '
          'flag is "selected," not the web reference\'s aria-current="page" '
          '— different attribute name, same practical outcome: assistive '
          'tech distinguishes the current page from the rest.',
      'A merged role: DsButton itself also declares Semantics(button: '
          'true, enabled: true, ...) inside every cell, and neither '
          'wrapper sets its own container: true, so Flutter merges the '
          'two into one node carrying both link and button flags '
          'together. Recorded as observed, not corrected — the merge is '
          'a property of how DsButton is composed into, not a defect '
          'unique to pagination.',
      'Keyboard interactions: inherited from DsButton — focusable '
          '(DsButton\'s canRequestFocus tracks its own _enabled, which is '
          'always true here; see States), and activated the same way '
          'any other DsButton is, by keyboard or pointer. Pagination '
          'adds no arrow-key roving-tabindex behavior of its own — every '
          'cell is its own stop in the tab order.',
      'Focus behavior: never moved automatically. Tapping a page number '
          'does not shift focus to a new location or announce the page '
          'change beyond the selected flag updating.',
      'Touch target: whatever DsButtonSize.icon (40×40) and '
          'DsButtonSize.md (Previous/Next, auto-width) already guarantee '
          '— pagination adds no padding of its own around a cell.',
      'Non-colour signal: the outline vs. ghost variant border, plus '
          'the label text itself ("1" vs. "2"), are the visible '
          'signals — colour is never the only cue for which page is '
          'current.',
      'Screen-reader announcements for the ellipsis: DsPaginationEllipsis '
          'wraps its glyph in ExcludeSemantics, so nothing is announced '
          'for it at all — no "more pages," no count of hidden pages. '
          'The source\'s own comment records the same intent the '
          'reference ships (an aria-hidden span around an sr-only label, '
          'which is a contradiction that hides the label too): "the port '
          'reproduces the outcome — nothing is announced."',
      'Known platform differences: none observed — pagination.dart '
          'branches on nothing platform-specific; the same widget tree '
          'renders everywhere.',
    ]),
  );

  Widget _responsive(DsThemeData theme) => DsSection(
    id: 'responsive',
    title: 'Responsive and platform behavior',
    child: _bulletColumn(theme, <String>[
      'DsPagination lays its children out in a plain Row with '
          'mainAxisAlignment.center — a Row, not a Wrap. It does not '
          'wrap onto a second line and it does not scroll on its own. A '
          'long page range at a narrow width (the classic case: this '
          "page's own 100-page worked example, at 390px) will overflow "
          'that Row and trigger a RenderFlex overflow unless the call '
          'site does something about it.',
      'This page\'s own mitigation, used for every specimen above: '
          'wrap DsPagination in a horizontally scrollable region '
          '(SingleChildScrollView(scrollDirection: Axis.horizontal)). '
          'That is docs-authored composition, not a DsPagination '
          'feature — the alternative most callers reach for instead is '
          'shrinking siblingCount at narrow widths so the row simply has '
          'fewer cells to lay out.',
      'Cell sizes do not change with width — DsButtonSize.icon stays a '
          'fixed 40×40 and DsButtonSize.md keeps its own padding at '
          'every breakpoint; nothing here reflows or shrinks a cell for '
          'a small screen.',
      'Platform parity: Android, iOS, Web, macOS, Windows, and Linux '
          'all render the same widget tree; nothing branches on '
          'platform.',
    ]),
  );

  Widget _dependencies(DsThemeData theme) => DsSection(
    id: 'dependencies',
    title: 'Dependencies, files, and assets',
    child: _bulletColumn(theme, <String>[
      'File: lib/src/components/pagination.dart (one file, four public '
          'classes, no companion parts).',
      'Direct imports: button.dart (DsButton, DsButtonVariant, '
          'DsButtonSize — every cell is one), icon.dart (DsIcon, '
          'DsIconTone) and icon_paths.dart (DsIconGlyph — the chevrons '
          'and the ellipsis glyph), and foundation/spacing.dart (ds()) '
          'for every measurement on this page.',
      'No import of theme.dart, colors.dart, or shadows.dart directly — '
          'pagination paints no fill, border, or shadow of its own; see '
          'Theming.',
      'Assets: none. Fonts: none beyond the system type scale every '
          'DsText/Text call already depends on. Shaders: none.',
    ]),
  );

  Widget _composition() => DsSection(
    id: 'composition',
    title: 'Composition examples',
    description:
        'The real shape this package\'s own navigation reference page '
        'builds — a fixed row, not a computed range — reproduced verbatim '
        'from example/lib/pages/navigation.dart.',
    child: DocsCodeExample(
      title: 'Composed with other primitives',
      preview: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Wrapped in the same horizontal scroll every specimen on this
          // page uses — DsPagination's own Row neither wraps nor scrolls;
          // see Responsive.
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: const DsPagination(
              children: <Widget>[
                DsPaginationStep.previous(),
                DsPaginationLink(label: '1'),
                DsPaginationLink(label: '2', isActive: true),
                DsPaginationLink(label: '3'),
                DsPaginationEllipsis(),
                DsPaginationLink(label: '12'),
                DsPaginationStep.next(),
              ],
            ),
          ),
          SizedBox(height: ds(3)),
          DsText(
            'Paired with the range label the Rules section of the same '
            'reference page recommends: "Showing 25–48 of 184 packs."',
            DsType.small,
          ),
        ],
      ),
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(
          path: 'navigation_reference_precedent.dart',
          title: 'example/lib/pages/navigation.dart, verbatim',
          description:
              'The marketplace/Stash pagination row this package ships, '
              'unchanged — a hard-coded shape, not a derived one.',
          code: '''const DsPagination(
  children: <Widget>[
    DsPaginationStep.previous(),
    DsPaginationLink(label: '1'),
    DsPaginationLink(label: '2', isActive: true),
    DsPaginationLink(label: '3'),
    DsPaginationEllipsis(),
    DsPaginationLink(label: '12'),
    DsPaginationStep.next(),
  ],
)''',
        ),
      ],
    ),
  );

  Widget _theming(DsThemeData theme) => DsSection(
    id: 'theming',
    title: 'Theming notes',
    child: _bulletColumn(theme, <String>[
      'DsPagination, DsPaginationLink, DsPaginationStep, and '
          'DsPaginationEllipsis paint no colour of their own — no '
          'DecoratedBox, no BoxDecoration, no direct theme.* read '
          'anywhere in pagination.dart. Every fill, border, and ink a '
          'cell shows comes from the DsButton it wraps (outline or '
          'ghost variant) or from DsIcon(tone: inherit) reading the '
          'button\'s own DefaultTextStyle.',
      'Flipping DsThemeController between light and dark re-resolves '
          'DsButton\'s own outline/ghost tokens exactly as it does '
          'anywhere else DsButton is used — pagination has no cached or '
          'independent colour of its own to go stale.',
      'There is no pagination-specific theming surface to override — a '
          'caller who needs a different look for a cell is overriding '
          'DsButton\'s variant tokens, not a parameter this component '
          'exposes.',
    ]),
  );

  Widget _source() => DsSection(
    id: 'source',
    title: 'Source, tests, and docs',
    child: DocsInstallFacts(
      title: 'Reference',
      facts: <DocsInstallFact>[
        DocsInstallFact(
          label: 'Source',
          value: paginationDoc.sourcePath,
          description:
              'Authoritative implementation — the truth this page was '
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
  );
}

/// The interactive worked example: 100 pages, starting on page 47. Tapping
/// any rendered page number (or Previous/Next) moves the current page and
/// re-truncates the row around it — a real, mounted [DsPagination], not an
/// illustration.
class _TruncatedPaginationSpecimen extends StatefulWidget {
  const _TruncatedPaginationSpecimen();

  @override
  State<_TruncatedPaginationSpecimen> createState() =>
      _TruncatedPaginationSpecimenState();
}

class _TruncatedPaginationSpecimenState
    extends State<_TruncatedPaginationSpecimen> {
  static const int _totalPages = 100;
  int _current = 47;

  void _goTo(int page) {
    if (page < 1 || page > _totalPages || page == _current) return;
    setState(() => _current = page);
  }

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final List<int?> range = _truncatedPageRange(
      totalPages: _totalPages,
      currentPage: _current,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Horizontal scroll is this page's own mitigation for the Row that
        // DsPagination itself never wraps or scrolls — see Responsive.
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DsPagination(
            children: <Widget>[
              DsPaginationStep.previous(onTap: () => _goTo(_current - 1)),
              for (final int? page in range)
                if (page == null)
                  const DsPaginationEllipsis()
                else
                  DsPaginationLink(
                    label: '$page',
                    isActive: page == _current,
                    onTap: () => _goTo(page),
                  ),
              DsPaginationStep.next(onTap: () => _goTo(_current + 1)),
            ],
          ),
        ),
        SizedBox(height: ds(3)),
        DsText(
          'Current page: $_current of $_totalPages',
          DsType.small,
          color: theme.mutedForeground,
        ),
      ],
    );
  }
}

/// A static, non-interactive [DsPagination] specimen plus its own caption —
/// the shape for a boundary or degenerate composition (first page, last
/// page, a single page) that the caller decides by which cells it includes,
/// not by a parameter DsPagination reads.
class _EdgeCaseSpecimen extends StatelessWidget {
  const _EdgeCaseSpecimen({required this.caption, required this.child});

  final String caption;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        DsText(caption, DsType.small, color: theme.mutedForeground),
        SizedBox(height: ds(2)),
        SingleChildScrollView(scrollDirection: Axis.horizontal, child: child),
      ],
    );
  }
}

Widget _bulletColumn(DsThemeData theme, List<String> lines) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: <Widget>[
    for (final String line in lines) ...<Widget>[
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: DsWidths.prose),
        child: DsText('•  $line', DsType.small, color: theme.mutedForeground),
      ),
      SizedBox(height: ds(2)),
    ],
  ],
);

const String _usageCode = '''
// The smallest correct call — a fixed row, no computed range at all.
const DsPagination(
  children: <Widget>[
    DsPaginationStep.previous(),
    DsPaginationLink(label: '1', isActive: true),
    DsPaginationLink(label: '2'),
    DsPaginationLink(label: '3'),
    DsPaginationStep.next(),
  ],
)

// A real caller with a page count computes the range itself — pagination
// does not do this for you (see Truncation) — then builds the same shapes:
DsPagination(
  children: <Widget>[
    DsPaginationStep.previous(onTap: page > 1 ? () => goTo(page - 1) : null),
    for (final int? p in myTruncatedRange(total: total, current: page))
      if (p == null)
        const DsPaginationEllipsis()
      else
        DsPaginationLink(
          label: '\$p',
          isActive: p == page,
          onTap: () => goTo(p),
        ),
    DsPaginationStep.next(
      onTap: page < total ? () => goTo(page + 1) : null,
    ),
  ],
)

// onTap: null above is still tappable — it just becomes a no-op via
// `onTap ?? () {}`. Omit the whole DsPaginationStep cell instead if the
// boundary must render as genuinely inert; see States.''';
