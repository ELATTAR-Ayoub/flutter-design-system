/// Public documentation page for the `table` component.
///
/// Mirrors `badge/page.dart`'s use of the Phase C docs primitives
/// (`DocsLayout`, `DocsCodeExample`, `DocsApiTable`, `DocsStateMatrix`,
/// `DocsInstallFacts`) and `kit.dart`'s `DsSection` for titled,
/// anchor-registered content blocks.
///
/// `table` has no registry manifest yet (`registry/components/table.json`
/// does not exist): every install-facing panel below says so honestly
/// rather than presenting a CLI command that would fail.
///
/// **Shadcn-parity reshape** (against
/// `https://ui.shadcn.com/docs/components/base/table`): a live demo renders
/// ahead of any heading, the same as the reference's own top-of-page
/// preview, no Overview, Status, or Preview heading precedes Installation.
/// Then Installation, Usage, Composition, Actions, Data Table, and RTL, in
/// that order, then API Reference. Footer has no counterpart here: the
/// source's own library doc says so plainly ("Not ported: TableFooter …
/// no table in the corpus has one"), so this page names it as skipped
/// rather than inventing a footer row DsTable cannot render. Variants
/// folds into API Reference's own intro sentence rather than standing as
/// its own heading, because DsTable has none to enumerate. States,
/// Accessibility, Responsive, Dependencies, Theming, and Source are this
/// package's own six sections, added after API Reference, named exactly
/// that with no extra words.
///
/// ## The one finding this page exists to surface
///
/// `lib/src/components/table.dart`'s own library doc describes the
/// reference's `<table>` as living in its own `relative w-full
/// overflow-x-auto` container: that wrapper is never reproduced here.
/// `DsTable.build` returns a bare `Column` around a `Table`, nothing more.
/// At a narrow width that leaves three different outcomes depending on what
/// a cell holds, all three measured by
/// `example/test/components_docs/table_test.dart`'s `DsTable overflow
/// behaviour at 390px` group and written up in this page's Responsive
/// section: plain text reflows safely, a non-wrapping cell (an icon beside a
/// label: the real shape `example/lib/pages/data.dart`'s own Transaction
/// history table uses) throws a genuine `RenderFlex overflowed`, and the
/// obvious one-line fix (a bare horizontal `SingleChildScrollView`) throws a
/// *different* error, because `DsTable`'s root `Column` stretches its cross
/// axis and a scroll view hands it an unbounded one. The fix that actually
/// works, `SingleChildScrollView` around an `IntrinsicWidth` around the
/// table: is what this page's own live demo uses, which is why it survives
/// at 390px instead of demonstrating its own bug.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/docs_code.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../kit.dart';
import 'meta.dart';

/// The key `table_test.dart` uses to scope its container search to this
/// page's own live-demo specimen rather than every `DsTable` on the page.
const Key previewTableKey = ValueKey<String>('table-doc-preview-table');

class TableDocPage extends StatelessWidget {
  const TableDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: tableDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / BASE',
      title: tableDoc.title,
      description: tableDoc.description,
    ),
    breadcrumbs: const <DsBreadcrumbEntry>[
      DsBreadcrumbEntry.link('Components'),
      DsBreadcrumbEntry.page('Table'),
    ],
    sidebar: _sidebar,
    toc: const <DocsTocEntry>[
      DocsTocEntry(title: 'Installation', anchor: 'install'),
      DocsTocEntry(title: 'Usage', anchor: 'usage'),
      DocsTocEntry(title: 'Composition', anchor: 'composition'),
      DocsTocEntry(title: 'Actions', anchor: 'actions'),
      DocsTocEntry(title: 'Data Table', anchor: 'data-table'),
      DocsTocEntry(title: 'RTL', anchor: 'rtl'),
      DocsTocEntry(title: 'API Reference', anchor: 'api'),
      DocsTocEntry(title: 'States', anchor: 'states'),
      DocsTocEntry(title: 'Accessibility', anchor: 'accessibility'),
      DocsTocEntry(title: 'Responsive', anchor: 'responsive'),
      DocsTocEntry(title: 'Dependencies', anchor: 'dependencies'),
      DocsTocEntry(title: 'Theming', anchor: 'theming'),
      DocsTocEntry(title: 'Source', anchor: 'source'),
    ],
    previous: const DocsPageLink(title: 'Stat', route: '/components/stat'),
    onNavigate: onNavigate,
    child: const _TableArticle(),
  );
}

/// Wave 4's own order (IA §7.3's "Base components" group, `layout and data`)
///, `table` is the last entry, so this page names no `next` link above.
const List<DocsSidebarEntry> _sidebar = <DocsSidebarEntry>[
  DocsSidebarEntry(title: 'Aspect Ratio', route: '/components/aspect_ratio'),
  DocsSidebarEntry(title: 'Calendar', route: '/components/calendar'),
  DocsSidebarEntry(title: 'Carousel', route: '/components/carousel'),
  DocsSidebarEntry(title: 'Item', route: '/components/item'),
  DocsSidebarEntry(title: 'Resizable', route: '/components/resizable'),
  DocsSidebarEntry(title: 'Scroll Area', route: '/components/scroll_area'),
  DocsSidebarEntry(title: 'Stat', route: '/components/stat'),
  DocsSidebarEntry(title: 'Table', route: '/components/table', selected: true),
];

class _TableArticle extends StatelessWidget {
  const _TableArticle();

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Column(
      key: const ValueKey<String>('table-doc-article'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _liveDemo(),
        SizedBox(height: ds(8)),
        _install(),
        _usage(),
        _composition(),
        _actions(),
        _dataTable(),
        _rtl(),
        _api(),
        _states(),
        _accessibility(theme),
        _responsive(theme),
        _dependencies(theme),
        _theming(theme),
        _source(),
      ],
    );
  }

  // The live demo, ahead of any heading: the same shape the reference page
  // itself opens with. No DsSection wraps it, so it carries no
  // Overview/Status/Preview heading of its own before Installation.
  Widget _liveDemo() => DocsCodeExample(
    title: 'Table specimen',
    description:
        'The real shape of example/lib/pages/data.dart’s "Transaction '
        'history" panel: a leading icon-and-label cell, a right-aligned '
        'money column, a status badge, and a caption. Wrapped in '
        'SingleChildScrollView + IntrinsicWidth: see Responsive for why '
        'that wrapper, and not a plainer one, is what keeps this specimen '
        'from overflowing on a narrow phone.',
    manualFiles: const <DocsCodeFile>[
      DocsCodeFile(
        path: 'lib/components/ui/table.dart',
        code:
            "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
            '// Table has no registry manifest yet: copy\n'
            '// lib/src/components/table.dart from the package source\n'
            '// directly. There is no generated CLI payload to fetch.',
      ),
    ],
    preview: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: IntrinsicWidth(
        child: DsTable(
          key: previewTableKey,
          caption: 'Showing the 5 most recent transactions of 248.',
          header: const <DsTableCellSpec>[
            DsTableCellSpec(child: Text('Type')),
            DsTableCellSpec(child: Text('Detail')),
            DsTableCellSpec(child: Text('Amount'), align: DsTableAlign.end),
            DsTableCellSpec(child: Text('Status'), align: DsTableAlign.end),
          ],
          rows: <DsTableRowSpec>[
            for (final _TxRow row in _previewRows)
              DsTableRowSpec(
                selected: row.selected,
                cells: <DsTableCellSpec>[
                  DsTableCellSpec(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        DsIcon.lucide(
                          row.incoming
                              ? DsLucide.arrowDownLeft
                              : DsLucide.arrowUpRight,
                          size: DsIconSize.sm,
                          tone: row.incoming
                              ? DsIconTone.success
                              : DsIconTone.subtle,
                        ),
                        SizedBox(width: ds(2)),
                        Text(row.type),
                      ],
                    ),
                  ),
                  DsTableCellSpec(child: Text(row.detail)),
                  DsTableCellSpec(
                    align: DsTableAlign.end,
                    child: Text(row.amount),
                  ),
                  DsTableCellSpec(
                    align: DsTableAlign.end,
                    child: DsBadge(
                      label: row.status,
                      variant: row.status == 'Pending'
                          ? DsBadgeVariant.warning
                          : DsBadgeVariant.success,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    ),
  );

  Widget _install() => DsSection(
    id: 'install',
    title: 'Installation',
    description:
        'table has no registry manifest yet, so `elattar add table` is not '
        'available: install by copying the source file manually.',
    child: DocsInstallFacts(
      title: 'Installation facts',
      facts: <DocsInstallFact>[
        const DocsInstallFact(
          label: 'Registry item',
          value: 'not yet registered',
          description:
              'No registry/components/table.json exists. This is a '
              'source-only component today.',
        ),
        const DocsInstallFact(
          label: 'Destination',
          value: 'lib/components/ui/table.dart',
          description: 'Where a manual copy of the source belongs.',
        ),
        const DocsInstallFact(
          label: 'Foundation',
          value: 'source only',
          description: 'No package-backed alternative is offered yet.',
        ),
        const DocsInstallFact(
          label: 'Dependencies',
          value: 'source-foundation',
          description:
              'What a future manifest would need to resolve: colors, '
              'spacing, theme, typography, and motion (the hover-fade '
              'duration and curve). table.dart imports no other component '
              'and no effect file: unlike badge or button, it does not '
              'reach for machine-surface or any other visual effect.',
        ),
        const DocsInstallFact(
          label: 'Assets',
          value: 'none',
          description: 'No images, icon fonts, or binary assets.',
        ),
        const DocsInstallFact(
          label: 'Shaders',
          value: 'none',
          description: 'Every fill is a plain BoxDecoration colour.',
        ),
        DocsInstallFact(
          label: 'Platforms',
          value: 'Android, iOS, Web, macOS, Windows, Linux',
          description: 'No platform-conditional code in table.dart.',
        ),
        const DocsInstallFact(
          label: 'Verified',
          value: 'docs specimen only',
          description:
              'This page\'s live demo and example/test/components_docs/'
              'table_test.dart. No dedicated package-level unit test exists '
              'for table.dart as of this page, and there is no registry '
              'fixture to install.',
        ),
      ],
    ),
  );

  Widget _usage() => DsSection(
    id: 'usage',
    title: 'Usage',
    description:
        'The smallest correct call, then the shapes example/lib/pages/'
        'data.dart and example/lib/data_table_demo.dart actually use.',
    child: DsPanel(
      label: 'DART',
      note: 'COMPOSE',
      child: DocsSelectableCodeBlock(code: _usageCode),
    ),
  );

  Widget _composition() => DsSection(
    id: 'composition',
    title: 'Composition',
    description:
        'DsTable has no separate TableHeader, TableBody, TableFooter or '
        'TableCaption widget to assemble by hand: one call builds the whole '
        'table from three plain-data arguments. _HeaderCell and _BodyCell, '
        'below, are private: what follows is what DsTable.build assembles '
        'internally on every rebuild, not something a caller composes '
        'piece by piece.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DsPanel(
          label: 'What DsTable(header: …, rows: …, caption: …) assembles',
          child: DocsSelectableCodeBlock(code: _compositionCode),
        ),
        SizedBox(height: ds(6)),
        DocsCodeExample(
          title: 'A read-only summary table',
          description:
              'The smallest real tree: one header row, one body row, no '
              'caption, no selection, no span. Wrapped in the same '
              'SingleChildScrollView + IntrinsicWidth recipe the live demo '
              'above and the Responsive section below use, for the same '
              'reason: DsTable has no scroll container of its own.',
          preview: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: IntrinsicWidth(
              child: DsTable(
                header: const <DsTableCellSpec>[
                  DsTableCellSpec(child: Text('Campaign')),
                  DsTableCellSpec(child: Text('Revenue')),
                ],
                rows: const <DsTableRowSpec>[
                  DsTableRowSpec(
                    cells: <DsTableCellSpec>[
                      DsTableCellSpec(child: Text('Stir in strength')),
                      DsTableCellSpec(child: Text('\$12,180')),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );

  Widget _actions() => DsSection(
    id: 'actions',
    title: 'Actions',
    description:
        'DsTable places no constraint on a cell\'s child, so a trailing '
        'column can hold a real interactive control instead of plain text: '
        'here, a per-row DsDropdownMenu trigger, the same shape a caller '
        'would add to example/lib/pages/data.dart\'s own Transaction '
        'history table if it needed a row menu. DsTable itself contributes '
        'nothing to this beyond the cell it lays the trigger button out in.',
    child: DocsCodeExample(
      title: 'Row actions menu',
      preview: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: IntrinsicWidth(
          child: DsTable(
            header: const <DsTableCellSpec>[
              DsTableCellSpec(child: Text('Campaign')),
              DsTableCellSpec(child: Text('Revenue')),
              DsTableCellSpec(child: Text(''), align: DsTableAlign.end),
            ],
            rows: <DsTableRowSpec>[
              for (final _ActionRow row in _actionRows)
                DsTableRowSpec(
                  cells: <DsTableCellSpec>[
                    DsTableCellSpec(child: Text(row.campaign)),
                    DsTableCellSpec(child: Text(row.revenue)),
                    DsTableCellSpec(
                      align: DsTableAlign.end,
                      child: DsDropdownMenu(
                        trigger: DsButton(
                          variant: DsButtonVariant.ghost,
                          size: DsButtonSize.icon,
                          label: 'Row actions for ${row.campaign}',
                          onPressed: () {},
                          child: const DsIcon.lucide(
                            DsLucide.ellipsis,
                            size: DsIconSize.sm,
                          ),
                        ),
                        children: <DsMenuChild>[
                          DsMenuItem(label: 'View', onSelect: () {}),
                          DsMenuItem(label: 'Edit', onSelect: () {}),
                          const DsMenuSeparator(),
                          DsMenuItem(
                            label: 'Delete',
                            variant: DsMenuItemVariant.destructive,
                            onSelect: () {},
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(path: 'table_row_actions.dart', code: _actionsCode),
      ],
    ),
  );

  Widget _dataTable() => DsSection(
    id: 'data-table',
    title: 'Data Table',
    description:
        'Sorting, filtering, row selection and pagination are NOT part of '
        'this component, on purpose: table.dart is a presentational '
        'primitive, and the reference draws the same line: those four '
        'behaviours ship upstream as a separate recipe over table.tsx, not '
        'as part of it. This port keeps the same seam.',
    child: DocsCodeExample(
      title: 'The sort, filter, select and page recipe',
      description:
          'example/lib/data_table_demo.dart, wired live into /components/'
          'data, is where that logic actually lives: a StatefulWidget that '
          'owns sort/filter/selection/page state and simply rebuilds a '
          'fresh header/rows list on every change. A caller that wants a '
          'sortable, filterable, paginated table copies that recipe\'s '
          'shape against its own data; DsTable stays the presentational '
          'layer underneath it, exactly as it already is underneath the '
          'plain read-only tables elsewhere on the same page.',
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(
          path: 'data_table_demo_recipe.dart',
          title:
              'example/lib/data_table_demo.dart’s sort/filter/select/page recipe',
          code: '''class _DataTableDemoState extends State<DataTableDemo> {
  _Column? _sortBy;
  bool _sortDesc = false;
  final TextEditingController _filter = TextEditingController();
  final Set<String> _selected = <String>{};
  int _page = 0;

  // getFilteredRowModel / getSortedRowModel equivalents, then:
  @override
  Widget build(BuildContext context) => DsTable(
    header: <DsTableCellSpec>[
      for (final column in _Column.values)
        DsTableCellSpec(
          checkbox: column == _Column.select,
          child: /* a real DsCheckbox, or a sortable-header DsButton */,
        ),
    ],
    rows: <DsTableRowSpec>[
      for (final row in _rows) // sorted, filtered, paginated by hand
        DsTableRowSpec(selected: _selected.contains(row.id), cells: /* … */),
    ],
  );
}''',
        ),
      ],
    ),
  );

  Widget _rtl() => DsSection(
    id: 'rtl',
    title: 'RTL',
    description:
        'DsTableAlign.start and .end resolve to literal Alignment.'
        'centerLeft and Alignment.centerRight, the plain, direction-blind '
        'Alignment class, not the directionality-aware '
        'AlignmentDirectional.centerStart/.centerEnd pair. Wrapping a '
        'table in a right-to-left Directionality does not make an '
        '"end"-aligned numeric column swap sides the way a browser\'s own '
        'text-align: right paired with dir="rtl" would: the alignment '
        'stays pinned to the physical right regardless of ambient '
        'direction, verified directly against the enum\'s own getter in '
        'table_test.dart.',
    child: DocsCodeExample(
      title: 'A table under a right-to-left Directionality',
      preview: const Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: IntrinsicWidth(
            child: DsTable(
              header: <DsTableCellSpec>[
                DsTableCellSpec(child: Text('البند')),
                DsTableCellSpec(
                  child: Text('المبلغ'),
                  align: DsTableAlign.end,
                ),
              ],
              rows: <DsTableRowSpec>[
                DsTableRowSpec(
                  cells: <DsTableCellSpec>[
                    DsTableCellSpec(child: Text('اشتراك')),
                    DsTableCellSpec(
                      align: DsTableAlign.end,
                      child: Text('129.00 دولار'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(path: 'rtl_table.dart', code: _rtlCode),
      ],
    ),
  );

  Widget _api() => DsSection(
    id: 'api',
    title: 'API Reference',
    description:
        'Every public class, enum and top-level member table.dart exports '
        '— there is no separate DsTableHeader, DsTableBody, DsTableFooter '
        'or DsTableCaption widget; a table is one DsTable plus the two '
        'plain data classes below it. DsTable also has no variant or size '
        'enum of its own: every table renders the same visual family, and '
        'the only shape controls are per-cell (DsTableAlign, checkbox) and '
        'per-row (selected, or replacing the body with '
        'DsTableRowSpec.span), both documented below.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const DocsApiTable(
          title: 'DsTable properties',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'header',
              type: 'List<DsTableCellSpec>',
              description:
                  'Required. The single header row: every table in the '
                  'corpus has exactly one.',
            ),
            DocsApiFact(
              name: 'rows',
              type: 'List<DsTableRowSpec>',
              description:
                  'Required. The body rows, or a single DsTableRowSpec.span '
                  'row replacing the whole body: see States.',
            ),
            DocsApiFact(
              name: 'caption',
              type: 'String?',
              description:
                  'Optional. Renders centred underneath the body, in its '
                  'own box (caption-bottom), not overlaid on it.',
            ),
          ],
        ),
        SizedBox(height: ds(6)),
        const DocsApiTable(
          title: 'DsTable static tokens',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'DsTable.headerHeight',
              type: 'static double',
              description:
                  'The header row’s whole box, 40px, rule '
                  'included.',
            ),
            DocsApiFact(
              name: 'DsTable.cellPadding',
              type: 'static double',
              description: 'Every cell’s padding on each unclipped side.',
            ),
            DocsApiFact(
              name: 'DsTable.captionGap',
              type: 'static double',
              description: 'The gap between the body and the caption.',
            ),
            DocsApiFact(
              name: 'DsTable.ruleWidth',
              type: 'static double',
              description: 'The hairline rule between rows.',
            ),
            DocsApiFact(
              name: 'DsTable.collapsedRemainder',
              type: 'static double',
              description:
                  'Half that hairline, kept as unpainted padding under the '
                  'last row of a multi-row body: the rule it would have '
                  'shared with a row below it. Layout only; nothing is '
                  'painted there.',
            ),
          ],
        ),
        SizedBox(height: ds(6)),
        const DocsApiTable(
          title: 'DsTableCellSpec: one header or body cell',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'child',
              type: 'Widget',
              description: 'Required. The cell’s content.',
            ),
            DocsApiFact(
              name: 'align',
              type: 'DsTableAlign',
              description:
                  'Defaults to start. end right-aligns: required on '
                  'numeric columns by this page’s own convention.',
            ),
            DocsApiFact(
              name: 'checkbox',
              type: 'bool',
              description:
                  'Defaults to false. Drops the cell’s trailing padding, '
                  'for a cell whose child is a checkbox-shaped control, '
                  'written as a flag because Flutter has no CSS :has() to '
                  'detect it automatically.',
            ),
          ],
        ),
        SizedBox(height: ds(6)),
        const DocsApiTable(
          title: 'DsTableRowSpec: one body row',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'cells',
              type: 'List<DsTableCellSpec>',
              description:
                  'The default constructor’s required field: this '
                  'row’s cells, one per header column.',
            ),
            DocsApiFact(
              name: 'selected',
              type: 'bool',
              description:
                  'Defaults to false. Paints theme.muted at full strength, '
                  'beating a simultaneous hover fill on the same row.',
            ),
            DocsApiFact(
              name: 'span',
              type: 'Widget',
              description:
                  'The DsTableRowSpec.span named constructor’s required '
                  'positional field: a widget that replaces the whole '
                  'table body. cells is forced empty and selected forced '
                  'false on this constructor.',
            ),
            DocsApiFact(
              name: 'spanHeight',
              type: 'double?',
              description:
                  'DsTableRowSpec.span only. The spanning box’s own '
                  'height; null lets it size to content.',
            ),
            DocsApiFact(
              name: 'isSpan',
              type: 'bool (getter)',
              description:
                  'True when span is non-null. DsTable asserts a spanning '
                  'row is the only entry in rows, Flutter’s Table has '
                  'no column-spanning of its own, so a spanning row is laid '
                  'out as its own full-width box beside the table rather '
                  'than inside it, which is only sound when it is the '
                  'entire body.',
            ),
          ],
        ),
        SizedBox(height: ds(6)),
        const DocsApiTable(
          title: 'DsTableAlign',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'start',
              type: 'enum value',
              description: 'Left-aligned, vertically centred. The default.',
            ),
            DocsApiFact(
              name: 'end',
              type: 'enum value',
              description: 'Right-aligned, vertically centred.',
            ),
            DocsApiFact(
              name: 'alignment',
              type: 'Alignment (getter)',
              description:
                  'start.alignment is Alignment.centerLeft, end.alignment '
                  'is Alignment.centerRight: literal, not '
                  'directionality-aware. See RTL.',
            ),
          ],
        ),
        SizedBox(height: ds(6)),
        const DocsApiTable(
          title: 'DsTableColumnWidth: the default column-width rule',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'minIntrinsicWidth',
              type: 'override',
              description:
                  'The column’s narrowest cell content can go: what a '
                  'narrow viewport squeezes every column down toward. See '
                  'Responsive.',
            ),
            DocsApiFact(
              name: 'maxIntrinsicWidth',
              type: 'override',
              description:
                  'The column’s widest unwrapped cell: also this '
                  'class’s flex, which is what turns Flutter’s '
                  'proportional column growth into the browser’s own '
                  'proportional-to-max-content distribution.',
            ),
            DocsApiFact(
              name: 'flex',
              type: 'override',
              description:
                  'Returns maxIntrinsicWidth (or null if it is zero, which '
                  'takes the column out of the flex distribution entirely).',
            ),
          ],
        ),
        SizedBox(height: ds(6)),
        const DocsApiTable(
          title: 'Top-level motion tokens',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'dsTableHoverDuration',
              type: 'Duration (getter)',
              description:
                  'DsDurations.transitionDefault, 250ms. What a row’s '
                  'hover fill fades on.',
            ),
            DocsApiFact(
              name: 'dsTableHoverCurve',
              type: 'Curve (getter)',
              description: 'DsCurves.out.',
            ),
          ],
        ),
      ],
    ),
  );

  Widget _states() => DsSection(
    id: 'states',
    title: 'States',
    description:
        'DsTable is a StatefulWidget: unlike badge, it does carry real '
        'interaction state (row hover). Most of IA §9.7’s remaining rows '
        'still do not apply to the table itself, because they belong to '
        'whatever a caller puts inside a cell instead: grouped into one '
        'row below with the reason, rather than invented.',
    child: const DocsStateMatrix(
      facts: <DocsStateFact>[
        DocsStateFact(
          state: 'Rest',
          treatment:
              'No fill on any row. A hairline rule (theme.border) sits '
              'under the header and under every body row except the last.',
          userSignal: 'A plain, unfilled table.',
        ),
        DocsStateFact(
          state: 'Hover',
          treatment:
              'The row under the pointer fades to theme.muted at 50% alpha '
              '(bg-muted/50) over dsTableHoverDuration (250ms) on '
              'dsTableHoverCurve: a MouseRegion on every body cell reports '
              'entry to the row, painted per cell via TweenAnimationBuilder '
              'since the fill has to travel, not just be a static colour.',
          userSignal:
              'A soft highlight follows the pointer down the body. The '
              'header row never hovers.',
        ),
        DocsStateFact(
          state: 'Selected',
          treatment:
              'DsTableRowSpec.selected paints theme.muted at full '
              'strength, and: because selection is resolved after hover '
              'in the same comparison, at equal specificity: it beats a '
              'simultaneous hover on that row rather than the two blending.',
          userSignal: 'A visibly stronger fill than a merely-hovered row.',
        ),
        DocsStateFact(
          state: 'Empty',
          treatment:
              'DsTableRowSpec.span replaces the entire body with one '
              'widget, vertically centred in a box of spanHeight. DsTable '
              'asserts if any other row is present alongside it.',
          userSignal:
              'Whatever the caller passes as the spanning widget, '
              'data_table_demo.dart uses a DsEmpty with a "Clear filter" '
              'button.',
        ),
        DocsStateFact(
          state: 'Reduced motion',
          treatment:
              'The hover fade’s duration is dsAnimationDuration(context, '
              'dsTableHoverDuration), which collapses to Duration.zero when '
              'MediaQuery.disableAnimationsOf(context) is true: verified '
              'in table_test.dart.',
          userSignal:
              'The hover fill still appears, instantly instead of '
              'fading.',
        ),
        DocsStateFact(
          state:
              'Focus-visible / Pressed / Loading / Error / Success / '
              'Disabled',
          treatment:
              'N/A on DsTable itself: it has no FocusNode, no tap gesture '
              'of its own beyond the hover MouseRegion, and no loading, '
              'error, success or enabled parameter. Whichever of these a '
              'real table needs lives on the widget a caller puts inside a '
              'cell instead: data_table_demo.dart’s sortable header is '
              'a real DsButton (focusable, has a disabled state while '
              'loading), its checkboxes are real DsCheckbox instances, and '
              'its loading rows are DsSkeleton content: none of it is a '
              'DsTable-level flag.',
          userSignal:
              'Look at the cell’s own widget’s documentation for '
              'that state, not this page.',
        ),
      ],
    ),
  );

  Widget _accessibility(DsThemeData theme) => DsSection(
    id: 'accessibility',
    title: 'Accessibility',
    description:
        'Flutter 3.44 ships real semantics for exactly this shape, '
        'SemanticsRole.table, .row, .cell and .columnHeader: and DsTable '
        'uses none of them. This is not "Flutter doesn’t support it"; '
        'the primitives exist and this component does not opt in.',
    child: _bullets(theme, <String>[
      'Semantic role: none. DsTable, and its private _HeaderCell/_BodyCell '
          'builders, construct zero Semantics widgets anywhere. Assistive '
          'tech receives whatever each cell’s own child happens to '
          'expose (a bare Text reads as static text, a DsBadge exposes '
          'nothing per its own docs, a DsCheckbox exposes its own control) '
          'with no table, row, cell or columnHeader grouping around any of '
          'it, and no association between a header cell and the column '
          'beneath it.',
      'Required labels: none of DsTable’s own: caption is rendered as '
          'plain centred text under the body, not wired to any table-level '
          'accessible label or description.',
      'Keyboard interactions: none, DsTable itself is never in the tab '
          'order. Only content a caller places inside a cell (a sortable '
          'header button, a checkbox) can receive focus, exactly as far as '
          'that widget’s own docs describe.',
      'Focus behavior: DsTable never requests or reports focus itself.',
      'Touch target: not evaluated by DsTable: a cell’s content owns '
          'its own target size. The table only fixes the header row’s '
          'height (DsTable.headerHeight, 40px); body rows are exactly as '
          'tall as their content.',
      'Non-colour signals: none for hover or selected: both are fills '
          'only, with no icon, border, or text change alongside them, and '
          'neither is exposed as semantics, so a screen reader gets no cue '
          'at all that a row is hovered or selected. A caller that needs '
          'selection announced has to wrap the row’s own content in its '
          'own Semantics(selected: …).',
      'Error wiring: none: a table is not a form control and has no '
          'invalid state of its own.',
      'Screen-reader announcements: none: there is no liveRegion. A '
          'caption or a cell whose text changes across a rebuild is not '
          'announced as a change.',
      'Known platform differences: none observed: table.dart has no '
          'platform-conditional code; the same widget tree renders '
          'everywhere.',
    ]),
  );

  Widget _responsive(DsThemeData theme) => DsSection(
    id: 'responsive',
    title: 'Responsive',
    description:
        'The reference’s own <table> lives inside relative w-full '
        'overflow-x-auto, DsTable does not reproduce that container. Its '
        'build method returns a bare Column around a Table; there is no '
        'ScrollView anywhere in table.dart. What happens next depends on '
        'what a cell holds, measured directly rather than assumed:',
    child: _bullets(theme, <String>[
      'No wrapper, plain-text cells: at 390px (358px available after 16px '
          'padding on each side) against a realistic 4-column table, '
          'RenderTable compresses every column proportionally toward its '
          'own minimum-intrinsic width, Flutter’s own algorithm, not a '
          'DsTable behaviour: rather than triggering a scrollbar the way '
          'overflow-x-auto would. A Text or DsText cell absorbs that '
          'safely: it wraps onto more lines and the row grows taller, with '
          'no error.',
      'No wrapper, a non-wrapping cell: the same table’s "Type" column '
          '— an icon beside a label in a Row(mainAxisSize: '
          'MainAxisSize.min), the exact shape example/lib/pages/data.dart’s '
          'own Transaction history table and example/lib/data_table_demo.dart’s '
          'Card column both use: has no give. Once its column is squeezed '
          'below the row’s own combined minimum width it throws "A '
          'RenderFlex overflowed by 104 pixels on the right": the debug '
          'yellow-and-black stripes, clipped paint outside debug mode. '
          'This is measured, not hypothetical: see table_test.dart’s '
          '"un-wrapped" case.',
      'The obvious fix does not work: wrapping the bare DsTable in '
          'SingleChildScrollView(scrollDirection: Axis.horizontal) throws '
          'a different error, "BoxConstraints forces an infinite width." '
          'DsTable’s root Column stretches its cross axis '
          '(crossAxisAlignment: CrossAxisAlignment.stretch), and a '
          'stretched cross axis needs a bounded width; a horizontal scroll '
          'view hands its child an unbounded one along the scroll axis.',
      'The recipe that does work: SingleChildScrollView(scrollDirection: '
          'Axis.horizontal, child: IntrinsicWidth(child: DsTable(…))). '
          'IntrinsicWidth measures the table’s own natural width first '
          'and hands the scroll view a bounded box, which is what lets the '
          'stretched Column resolve. This page’s own live demo uses '
          'exactly this wrapper, which is why it renders correctly at '
          '390px instead of reproducing its own finding: see '
          'table_test.dart’s narrow-width page test.',
      'Platform parity: no platform-conditional code in table.dart; the '
          'same widget tree renders on Android, iOS, Web, macOS, Windows '
          'and Linux.',
    ]),
  );

  Widget _dependencies(DsThemeData theme) => DsSection(
    id: 'dependencies',
    title: 'Dependencies',
    child: _bullets(theme, <String>[
      'File: lib/src/components/table.dart (one file, no companion parts).',
      'Engine imports: package:flutter/rendering.dart (TableColumnWidth, '
          'RenderBox) and package:flutter/widgets.dart (Table, TableRow, '
          'TableCellVerticalAlignment, MouseRegion, TweenAnimationBuilder).',
      'Foundation imports: foundation/motion.dart (dsAnimationDuration, '
          'DsDurations.transitionDefault, DsCurves.out), '
          'foundation/spacing.dart (ds()), foundation/theme.dart '
          '(DsThemeData), foundation/typography.dart '
          '(DsComponentType.tableHead).',
      'Scope import: theme_scope.dart (DsText, DsTheme).',
      'No effect import: unlike badge or button, table.dart does not '
          'reach for machine-surface, sheen-action, or any other visual '
          'effect. Every fill is a plain BoxDecoration colour.',
      'Assets: none. Fonts: none beyond the system type scale every DsText '
          'call already depends on. Shaders: none.',
    ]),
  );

  Widget _theming(DsThemeData theme) => DsSection(
    id: 'theming',
    title: 'Theming',
    child: _bullets(theme, <String>[
      'Every colour DsTable paints is theme-derived: theme.border for the '
          'header and row rules, theme.muted for the hover and selected '
          'fills, theme.foreground and theme.mutedForeground for header, '
          'body and caption text via DsComponentType.tableHead, '
          'DsType.textSm and DsType.small. Flipping DsThemeController '
          're-resolves all of them live: nothing is cached.',
      'The half-pixel collapsedRemainder and the hover '
          'dsTableHoverDuration/dsTableHoverCurve are not designer-facing '
          'colour tokens; they are exposed as static and top-level getters '
          'specifically so a page like this one: or a test: can name the '
          'exact number instead of restating it.',
      'DsTable declares no colour-override parameter of its own: no '
          'headerColor, no rowFill, no borderColor argument anywhere in '
          'its constructor. A caller that needs a different fill wraps a '
          'cell’s own content, or reaches for a new component, rather '
          'than bypassing the token system here.',
    ]),
  );

  Widget _source() => DsSection(
    id: 'source',
    title: 'Source',
    child: DocsInstallFacts(
      title: 'Reference',
      facts: <DocsInstallFact>[
        DocsInstallFact(
          label: 'Source',
          value: tableDoc.sourcePath,
          description:
              'Authoritative implementation: the truth this page '
              'was written from.',
        ),
        const DocsInstallFact(
          label: 'Package tests',
          value: 'none yet',
          description:
              'No dedicated unit test exists for table.dart in the '
              'package test suite as of this page.',
        ),
        const DocsInstallFact(
          label: 'Docs test',
          value: 'example/test/components_docs/table_test.dart',
          description:
              'Covers this page (the API table, a live specimen, narrow '
              'and wide layout, live theme flip) plus a set of isolated '
              'DsTable widget tests that independently verify every claim '
              'in States and Responsive above: the overflow measurements, '
              'the hover/selected fill, and reduced motion.',
        ),
        const DocsInstallFact(
          label: 'Edit these docs',
          value: 'example/lib/components_docs/table/page.dart',
          description: 'This file.',
        ),
      ],
    ),
  );
}

/// One row of the live demo specimen: the same shape as
/// example/lib/pages/data.dart's own `_tx` list.
class _TxRow {
  const _TxRow(
    this.type,
    this.detail,
    this.amount,
    this.incoming,
    this.status, {
    this.selected = false,
  });

  final String type;
  final String detail;
  final String amount;
  final bool incoming;
  final String status;
  final bool selected;
}

const List<_TxRow> _previewRows = <_TxRow>[
  _TxRow(
    'Subscription',
    'Studio Pro annual plan',
    '\$129.00',
    false,
    'Completed',
  ),
  _TxRow(
    'Payout',
    'Weekly creator payout',
    '\$412.50',
    true,
    'Completed',
    selected: true,
  ),
  _TxRow('Refund', 'Order #48213', '-\$18.00', false, 'Pending'),
];

/// One row of the Actions specimen: just enough data to give each row's
/// dropdown trigger a distinct accessible label.
class _ActionRow {
  const _ActionRow(this.campaign, this.revenue);

  final String campaign;
  final String revenue;
}

const List<_ActionRow> _actionRows = <_ActionRow>[
  _ActionRow('Stir in strength', '\$12,180'),
  _ActionRow('Quiet mornings', '\$8,420'),
];

Widget _bullets(DsThemeData theme, List<String> lines) => Column(
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
// The smallest correct call: one header row, one body row.
DsTable(
  header: const <DsTableCellSpec>[
    DsTableCellSpec(child: Text('Type')),
    DsTableCellSpec(child: Text('Amount'), align: DsTableAlign.end),
  ],
  rows: <DsTableRowSpec>[
    DsTableRowSpec(
      cells: <DsTableCellSpec>[
        const DsTableCellSpec(child: Text('Payout')),
        const DsTableCellSpec(
          align: DsTableAlign.end,
          child: Text('\\\$412.50'),
        ),
      ],
    ),
  ],
)

// A caption and a selected row: example/lib/pages/data.dart's own
// Transaction history panel.
DsTable(
  caption: 'Showing the 5 most recent transactions of 248.',
  header: const <DsTableCellSpec>[
    DsTableCellSpec(child: Text('Type')),
    DsTableCellSpec(child: Text('Amount'), align: DsTableAlign.end),
  ],
  rows: <DsTableRowSpec>[
    DsTableRowSpec(
      selected: true,
      cells: <DsTableCellSpec>[
        const DsTableCellSpec(child: Text('Payout')),
        const DsTableCellSpec(
          align: DsTableAlign.end,
          child: Text('\\\$412.50'),
        ),
      ],
    ),
  ],
)

// The empty state: a single spanning row replaces the body entirely: the
// same shape example/lib/data_table_demo.dart uses when its filter matches
// nothing. DsTable asserts if a spanning row is not the only row.
DsTable(
  header: const <DsTableCellSpec>[DsTableCellSpec(child: Text('Card'))],
  rows: <DsTableRowSpec>[
    DsTableRowSpec.span(const Text('No results.'), spanHeight: 192),
  ],
)

// Sorting, filtering, selection and pagination are NOT DsTable parameters —
// see the Data Table section, and example/lib/data_table_demo.dart's
// DataTableDemo, for the full recipe.
''';

const String _compositionCode =
    '''// DsTable(header, rows, caption)
//  Table (RenderTable, DsTableColumnWidth per column)
//   TableRow (header): one _HeaderCell per DsTableCellSpec in `header`
//   TableRow (body), one per DsTableRowSpec in `rows`:
//    _BodyCell per DsTableCellSpec in `cells`, filled from row hover or
//    `selected` via TweenAnimationBuilder
//   or, when the single row's `isSpan` is true: a full-width SizedBox
//   laid out beside the Table rather than inside it (Flutter's Table has
//   no colSpan of its own)
//  optional caption: centred DsText under the body, DsTable.captionGap
//  below it''';

const String _actionsCode =
    '''DsTableCellSpec(
  align: DsTableAlign.end,
  child: DsDropdownMenu(
    trigger: DsButton(
      variant: DsButtonVariant.ghost,
      size: DsButtonSize.icon,
      label: 'Row actions for \$campaign',
      onPressed: () {},
      child: const DsIcon.lucide(DsLucide.ellipsis, size: DsIconSize.sm),
    ),
    children: <DsMenuChild>[
      DsMenuItem(label: 'View', onSelect: () {}),
      DsMenuItem(label: 'Edit', onSelect: () {}),
      const DsMenuSeparator(),
      DsMenuItem(
        label: 'Delete',
        variant: DsMenuItemVariant.destructive,
        onSelect: () {},
      ),
    ],
  ),
)''';

const String _rtlCode = '''Directionality(
  textDirection: TextDirection.rtl,
  child: DsTable(
    header: <DsTableCellSpec>[
      DsTableCellSpec(child: Text('البند')),
      DsTableCellSpec(child: Text('المبلغ'), align: DsTableAlign.end),
    ],
    rows: <DsTableRowSpec>[
      DsTableRowSpec(
        cells: <DsTableCellSpec>[
          DsTableCellSpec(child: Text('اشتراك')),
          DsTableCellSpec(
            align: DsTableAlign.end,
            child: Text('129.00 دولار'),
          ),
        ],
      ),
    ],
  ),
)''';
