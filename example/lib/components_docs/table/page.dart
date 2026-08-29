/// Public documentation page for the `table` component.
///
/// **Re-housed onto the kit.** This page used to hand-compose `Section`
/// panels; it now declares a `ComponentDocSpec`
/// (`example/lib/docs/component_doc_page.dart`) and hands it to
/// `ComponentDocPage`, the same shape `button` and `field` established.
/// Every specimen widget and every code string below is the one the
/// hand-composed page carried; only where it lives changed, plus a new
/// Keyboard disclosure (Table itself wires none) and a real live specimen
/// for Composition, which used to pair a code-only assembly diagram with a
/// separate, unheaded `DocsCodeExample`: the two are now one
/// `ShowcaseSection`, a specimen and its source together.
///
/// **`table` ships a real registry manifest.** `registry/components/
/// table.json` exists (`registryDependencies: [source-foundation]`), so
/// `elattar add table` installs today. The previous version of this page
/// said the opposite — "registry/components/table.json does not exist" —
/// which was wrong; every install-facing fact below reads off the shipped
/// manifest instead.
///
/// **Shadcn-parity reshape** (against
/// `https://ui.shadcn.com/docs/components/base/table`): a live demo renders
/// as this page's own Preview section, then Installation, Usage,
/// Composition, Actions, Data Table, and RTL, in that order, matching the
/// reference's own flat list. Footer has no counterpart here: the source's
/// own library doc says so plainly ("Not ported: TableFooter … no table in
/// the corpus has one"), so this page names it as skipped rather than
/// inventing a footer row Table cannot render. Variants folds into API
/// Reference's own intro sentence rather than standing as its own heading,
/// because Table has none to enumerate. Then the eight required
/// disclosures: API Reference, States, Accessibility, Keyboard, Responsive,
/// Dependencies, Theming, Source.
///
/// ## The one finding this page exists to surface
///
/// `lib/src/components/ui/table.dart`'s own library doc describes the
/// reference's `<table>` as living in its own `relative w-full
/// overflow-x-auto` container: that wrapper is never reproduced here.
/// `Table.build` returns a bare `Column` around a `Table`, nothing more.
/// At a narrow width that leaves three different outcomes depending on what
/// a cell holds, all three measured by
/// `example/test/components_docs/table_test.dart`'s `Table overflow
/// behaviour at 390px` group and written up in this page's Responsive
/// section: plain text reflows safely, a non-wrapping cell (an icon beside a
/// label: the real shape `example/lib/pages/data.dart`'s own Transaction
/// history table uses) throws a genuine `RenderFlex overflowed`, and the
/// obvious one-line fix (a bare horizontal `SingleChildScrollView`) throws a
/// *different* error, because `Table`'s root `Column` stretches its cross
/// axis and a scroll view hands it an unbounded one. The fix that actually
/// works, `SingleChildScrollView` around an `IntrinsicWidth` around the
/// table: is what this page's own live demo uses, which is why it survives
/// at 390px instead of demonstrating its own bug.
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

/// The key `table_test.dart` uses to scope its container search to this
/// page's own Preview specimen rather than every `Table` on the page.
const Key previewTableKey = ValueKey<String>('table-doc-preview-table');

final ComponentDocSpec tableDocSpec = ComponentDocSpec(
  name: 'table',
  title: tableDoc.title,
  description: tableDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'The real shape of example/lib/pages/data.dart\'s "Transaction '
          'history" panel: a leading icon-and-label cell, a right-aligned '
          'money column, a status badge, and a caption. Wrapped in '
          'SingleChildScrollView + IntrinsicWidth: see Responsive for why '
          'that wrapper, and not a plainer one, is what keeps this specimen '
          'from overflowing on a narrow phone.',
      specimen: const _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
      minHeight: space(160),
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'table ships a real registry manifest: `elattar add table` '
          'installs lib/src/components/ui/table.dart and resolves '
          'source-foundation automatically. The Manual tab is for a '
          'project not using the CLI.',
      command: tableDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/table.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/ui/table.dart's generated "
              '@ui/table.dart payload into components/ui.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated table source here when using manual '
              'mode.',
        ),
        const DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so Table and its companion types are '
              'reachable the same way the CLI path already makes them.',
          code: "export 'table.dart';",
        ),
      ],
    ),
    const SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'The smallest correct call: one header row, one body row. Every '
          'other example on this page only adds a caption, a selected row, '
          'or richer cell content on top of this.',
      code: _usageCode,
    ),
    ShowcaseSection(
      id: 'composition',
      title: 'Composition',
      description:
          'Table has no separate TableHeader, TableBody, TableFooter or '
          'TableCaption widget to assemble by hand: one call builds the '
          'whole table from three plain-data arguments, header, rows, and '
          'an optional caption. The private _HeaderCell and _BodyCell '
          'widgets below are what Table.build assembles internally on '
          'every rebuild, filled per row from hover or selected through a '
          'TweenAnimationBuilder, not something a caller composes piece by '
          'piece. The smallest real tree that shows it: one header row, one '
          'body row, no caption, no selection, no span, wrapped in the same '
          'SingleChildScrollView + IntrinsicWidth recipe the Preview '
          'specimen and the Responsive section both use, because Table '
          'has no scroll container of its own.',
      specimen: const _CompositionSpecimen(),
      code: _compositionCode,
      label: 'Composition specimen view',
    ),
    ShowcaseSection(
      id: 'actions',
      title: 'Actions',
      description:
          'Table places no constraint on a cell\'s child, so a trailing '
          'column can hold a real interactive control instead of plain '
          'text: here, a per-row DropdownMenu trigger, the same shape a '
          'caller would add to example/lib/pages/data.dart\'s own '
          'Transaction history table if it needed a row menu. Table '
          'itself contributes nothing to this beyond the cell it lays the '
          'trigger button out in.',
      specimen: const _ActionsSpecimen(),
      code: _actionsCode,
      label: 'Actions specimen view',
    ),
    const SnippetSection(
      id: 'data-table',
      title: 'Data Table',
      description:
          'Sorting, filtering, row selection and pagination are NOT part '
          'of this component, on purpose: table.dart is a presentational '
          'primitive, and the reference draws the same line: those four '
          'behaviours ship upstream as a separate recipe over table.tsx, '
          'not as part of it. This port keeps the same seam. '
          'example/lib/data_table_demo.dart, wired live into '
          '/components/data, is where that logic actually lives: a '
          'StatefulWidget that owns sort/filter/selection/page state and '
          'rebuilds a fresh header/rows list on every change. Nothing live '
          'renders below: reproducing that whole state machine on this '
          'page would be a second app, not a component specimen, so this '
          'section stays code-only, the recipe\'s own shape rather than a '
          'staged copy of it.',
      code: _dataTableCode,
    ),
    ShowcaseSection(
      id: 'rtl',
      title: 'RTL',
      description:
          'TableAlign.start and .end resolve to literal Alignment.'
          'centerLeft and Alignment.centerRight, the plain, direction-blind '
          'Alignment class, not the directionality-aware '
          'AlignmentDirectional.centerStart/.centerEnd pair. Wrapping a '
          'table in a right-to-left Directionality does not make an '
          '"end"-aligned numeric column swap sides the way a browser\'s own '
          'text-align: right paired with dir="rtl" would: the alignment '
          'stays pinned to the physical right regardless of ambient '
          'direction, verified directly against the enum\'s own getter in '
          'table_test.dart.',
      specimen: const _RtlSpecimen(),
      code: _rtlCode,
      label: 'RTL specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every public class, enum and top-level member table.dart '
          'exports — there is no separate TableHeader, TableBody, '
          'TableFooter or TableCaption widget; a table is one Table '
          'plus the two plain data classes below it. Table also has no '
          'variant or size enum of its own: every table renders the same '
          'visual family, and the only shape controls are per-cell '
          '(TableAlign, checkbox) and per-row (selected, or replacing '
          'the body with TableRowSpec.span), both documented below.',
      children: const <DocsTocEntry>[
        DocsTocEntry(title: 'Table properties', anchor: 'api-eltable'),
        DocsTocEntry(
          title: 'Table static tokens',
          anchor: 'api-eltable-static',
        ),
        DocsTocEntry(title: 'TableCellSpec', anchor: 'api-eltablecellspec'),
        DocsTocEntry(title: 'TableRowSpec', anchor: 'api-eltablerowspec'),
        DocsTocEntry(title: 'TableAlign', anchor: 'api-eltablealign'),
        DocsTocEntry(
          title: 'TableColumnWidth',
          anchor: 'api-eltablecolumnwidth',
        ),
        DocsTocEntry(
          title: 'Top-level motion tokens',
          anchor: 'api-table-motion',
        ),
      ],
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'Table is a StatefulWidget: unlike badge, it does carry real '
          'interaction state (row hover). Most of the remaining state rows '
          'still do not apply to the table itself, because they belong to '
          'whatever a caller puts inside a cell instead: grouped into one '
          'row below with the reason, rather than invented.',
      child: DocsStateMatrix(facts: _stateFacts),
    ),
    DisclosureSection(
      id: 'accessibility',
      title: 'Accessibility',
      description:
          'Flutter 3.44 ships real semantics for exactly this shape, '
          'SemanticsRole.table, .row, .cell and .columnHeader: and Table '
          'uses none of them. This is not "Flutter doesn\'t support it"; '
          'the primitives exist and this component does not opt in.',
      child: _AccessibilityContent(),
    ),
    DisclosureSection(
      id: 'keyboard',
      title: 'Keyboard',
      description:
          'Table itself is never in the tab order and wires no '
          'Focus.onKeyEvent of its own anywhere: every fact here is about '
          'what does NOT happen on the table, read off table.dart directly.',
      child: _KeyboardContent(),
    ),
    DisclosureSection(
      id: 'responsive',
      title: 'Responsive',
      description:
          'The reference\'s own <table> lives inside relative w-full '
          'overflow-x-auto, Table does not reproduce that container. Its '
          'build method returns a bare Column around a Table; there is no '
          'ScrollView anywhere in table.dart. What happens next depends on '
          'what a cell holds, measured directly rather than assumed:',
      child: _ResponsiveContent(),
    ),
    DisclosureSection(
      id: 'dependencies',
      title: 'Dependencies',
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
            value: tableDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
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
                'Covers this page (the API tables, live specimens, narrow '
                'and wide layout, live theme flip) plus a set of isolated '
                'Table widget tests that independently verify every '
                'claim in States and Responsive above: the overflow '
                'measurements, the hover/selected fill, and reduced '
                'motion.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/table/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class TableDocPage extends StatelessWidget {
  const TableDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: tableDoc.route,
    intro: DocsPageIntro(
      title: tableDoc.title,
      description: tableDoc.description,
    ),
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Components'),
      BreadcrumbEntry.page('Table'),
    ],
    toc: tableDocSpec.toc,
    previous: const DocsPageLink(title: 'Stat', route: '/components/stat'),
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('table-doc-article'),
      child: ComponentDocPage(spec: tableDocSpec, header: false),
    ),
  );
}

/* ── Showcase specimens ─────────────────────────────────────────────────── */

class _PreviewSpecimen extends StatelessWidget {
  const _PreviewSpecimen();

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: IntrinsicWidth(
      child: Table(
        key: previewTableKey,
        caption: 'Showing the 5 most recent transactions of 248.',
        header: const <TableCellSpec>[
          TableCellSpec(child: Text('Type')),
          TableCellSpec(child: Text('Detail')),
          TableCellSpec(child: Text('Amount'), align: TableAlign.end),
          TableCellSpec(child: Text('Status'), align: TableAlign.end),
        ],
        rows: <TableRowSpec>[
          for (final _TxRow row in _previewRows)
            TableRowSpec(
              selected: row.selected,
              cells: <TableCellSpec>[
                TableCellSpec(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon.lucide(
                        row.incoming
                            ? Lucide.arrowDownLeft
                            : Lucide.arrowUpRight,
                        size: IconSize.sm,
                        tone: row.incoming ? IconTone.success : IconTone.subtle,
                      ),
                      SizedBox(width: space(2)),
                      Text(row.type),
                    ],
                  ),
                ),
                TableCellSpec(child: Text(row.detail)),
                TableCellSpec(align: TableAlign.end, child: Text(row.amount)),
                TableCellSpec(
                  align: TableAlign.end,
                  child: Badge(
                    label: row.status,
                    variant: row.status == 'Pending'
                        ? BadgeVariant.warning
                        : BadgeVariant.success,
                  ),
                ),
              ],
            ),
        ],
      ),
    ),
  );
}

/// One row of the Preview specimen: the same shape as
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

const String _previewCode = '''SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: IntrinsicWidth(
    child: Table(
      caption: 'Showing the 5 most recent transactions of 248.',
      header: const <TableCellSpec>[
        TableCellSpec(child: Text('Type')),
        TableCellSpec(child: Text('Detail')),
        TableCellSpec(child: Text('Amount'), align: TableAlign.end),
        TableCellSpec(child: Text('Status'), align: TableAlign.end),
      ],
      rows: <TableRowSpec>[
        TableRowSpec(
          cells: <TableCellSpec>[
            TableCellSpec(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon.lucide(Lucide.arrowDownLeft, size: IconSize.sm),
                  SizedBox(width: 8),
                  Text('Subscription'),
                ],
              ),
            ),
            TableCellSpec(child: Text('Studio Pro annual plan')),
            TableCellSpec(align: TableAlign.end, child: Text('\\\$129.00')),
            TableCellSpec(
              align: TableAlign.end,
              child: Badge(label: 'Completed', variant: BadgeVariant.success),
            ),
          ],
        ),
        // ...
      ],
    ),
  ),
)''';

const String _usageCode = '''
// The smallest correct call: one header row, one body row.
Table(
  header: const <TableCellSpec>[
    TableCellSpec(child: Text('Type')),
    TableCellSpec(child: Text('Amount'), align: TableAlign.end),
  ],
  rows: <TableRowSpec>[
    TableRowSpec(
      cells: <TableCellSpec>[
        const TableCellSpec(child: Text('Payout')),
        const TableCellSpec(
          align: TableAlign.end,
          child: Text('\\\$412.50'),
        ),
      ],
    ),
  ],
)

// A caption and a selected row: example/lib/pages/data.dart's own
// Transaction history panel.
Table(
  caption: 'Showing the 5 most recent transactions of 248.',
  header: const <TableCellSpec>[
    TableCellSpec(child: Text('Type')),
    TableCellSpec(child: Text('Amount'), align: TableAlign.end),
  ],
  rows: <TableRowSpec>[
    TableRowSpec(
      selected: true,
      cells: <TableCellSpec>[
        const TableCellSpec(child: Text('Payout')),
        const TableCellSpec(
          align: TableAlign.end,
          child: Text('\\\$412.50'),
        ),
      ],
    ),
  ],
)

// The empty state: a single spanning row replaces the body entirely: the
// same shape example/lib/data_table_demo.dart uses when its filter matches
// nothing. Table asserts if a spanning row is not the only row.
Table(
  header: const <TableCellSpec>[TableCellSpec(child: Text('Card'))],
  rows: <TableRowSpec>[
    TableRowSpec.span(const Text('No results.'), spanHeight: 192),
  ],
)
''';

class _CompositionSpecimen extends StatelessWidget {
  const _CompositionSpecimen();

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: IntrinsicWidth(
      child: Table(
        header: const <TableCellSpec>[
          TableCellSpec(child: Text('Campaign')),
          TableCellSpec(child: Text('Revenue')),
        ],
        rows: const <TableRowSpec>[
          TableRowSpec(
            cells: <TableCellSpec>[
              TableCellSpec(child: Text('Stir in strength')),
              TableCellSpec(child: Text('\$12,180')),
            ],
          ),
        ],
      ),
    ),
  );
}

const String _compositionCode =
    '''// Table(header, rows, caption) assembles internally:
//  Table (RenderTable, TableColumnWidth per column)
//   TableRow (header): one _HeaderCell per TableCellSpec in `header`
//   TableRow (body), one per TableRowSpec in `rows`:
//    _BodyCell per TableCellSpec in `cells`, filled from row hover or
//    `selected` via TweenAnimationBuilder
//   or, when the single row's `isSpan` is true: a full-width SizedBox
//   laid out beside the Table rather than inside it (Flutter's Table has
//   no colSpan of its own)
//  optional caption: centred StyledText under the body, Table.captionGap
//  below it

SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: IntrinsicWidth(
    child: Table(
      header: const <TableCellSpec>[
        TableCellSpec(child: Text('Campaign')),
        TableCellSpec(child: Text('Revenue')),
      ],
      rows: const <TableRowSpec>[
        TableRowSpec(
          cells: <TableCellSpec>[
            TableCellSpec(child: Text('Stir in strength')),
            TableCellSpec(child: Text('\\\$12,180')),
          ],
        ),
      ],
    ),
  ),
)''';

class _ActionsSpecimen extends StatelessWidget {
  const _ActionsSpecimen();

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: IntrinsicWidth(
      child: Table(
        header: const <TableCellSpec>[
          TableCellSpec(child: Text('Campaign')),
          TableCellSpec(child: Text('Revenue')),
          TableCellSpec(child: Text(''), align: TableAlign.end),
        ],
        rows: <TableRowSpec>[
          for (final _ActionRow row in _actionRows)
            TableRowSpec(
              cells: <TableCellSpec>[
                TableCellSpec(child: Text(row.campaign)),
                TableCellSpec(child: Text(row.revenue)),
                TableCellSpec(
                  align: TableAlign.end,
                  child: DropdownMenu(
                    trigger: Button(
                      variant: ButtonVariant.ghost,
                      size: ButtonSize.icon,
                      label: 'Row actions for ${row.campaign}',
                      onPressed: () {},
                      child: const Icon.lucide(
                        Lucide.ellipsis,
                        size: IconSize.sm,
                      ),
                    ),
                    children: <MenuChild>[
                      MenuItem(label: 'View', onSelect: () {}),
                      MenuItem(label: 'Edit', onSelect: () {}),
                      const MenuSeparator(),
                      MenuItem(
                        label: 'Delete',
                        variant: MenuItemVariant.destructive,
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
  );
}

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

const String _actionsCode = '''TableCellSpec(
  align: TableAlign.end,
  child: DropdownMenu(
    trigger: Button(
      variant: ButtonVariant.ghost,
      size: ButtonSize.icon,
      label: 'Row actions for \$campaign',
      onPressed: () {},
      child: const Icon.lucide(Lucide.ellipsis, size: IconSize.sm),
    ),
    children: <MenuChild>[
      MenuItem(label: 'View', onSelect: () {}),
      MenuItem(label: 'Edit', onSelect: () {}),
      const MenuSeparator(),
      MenuItem(
        label: 'Delete',
        variant: MenuItemVariant.destructive,
        onSelect: () {},
      ),
    ],
  ),
)''';

const String _dataTableCode =
    '''class _DataTableDemoState extends State<DataTableDemo> {
  _Column? _sortBy;
  bool _sortDesc = false;
  final TextEditingController _filter = TextEditingController();
  final Set<String> _selected = <String>{};
  int _page = 0;

  // getFilteredRowModel / getSortedRowModel equivalents, then:
  @override
  Widget build(BuildContext context) => Table(
    header: <TableCellSpec>[
      for (final column in _Column.values)
        TableCellSpec(
          checkbox: column == _Column.select,
          child: /* a real Checkbox, or a sortable-header Button */,
        ),
    ],
    rows: <TableRowSpec>[
      for (final row in _rows) // sorted, filtered, paginated by hand
        TableRowSpec(selected: _selected.contains(row.id), cells: /* … */),
    ],
  );
}''';

class _RtlSpecimen extends StatelessWidget {
  const _RtlSpecimen();

  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: TextDirection.rtl,
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: IntrinsicWidth(
        child: Table(
          header: const <TableCellSpec>[
            TableCellSpec(child: Text('البند')),
            TableCellSpec(child: Text('المبلغ'), align: TableAlign.end),
          ],
          rows: const <TableRowSpec>[
            TableRowSpec(
              cells: <TableCellSpec>[
                TableCellSpec(child: Text('اشتراك')),
                TableCellSpec(
                  align: TableAlign.end,
                  child: Text('129.00 دولار'),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

const String _rtlCode = '''Directionality(
  textDirection: TextDirection.rtl,
  child: Table(
    header: <TableCellSpec>[
      TableCellSpec(child: Text('البند')),
      TableCellSpec(child: Text('المبلغ'), align: TableAlign.end),
    ],
    rows: <TableRowSpec>[
      TableRowSpec(
        cells: <TableCellSpec>[
          TableCellSpec(child: Text('اشتراك')),
          TableCellSpec(
            align: TableAlign.end,
            child: Text('129.00 دولار'),
          ),
        ],
      ),
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
        id: 'api-eltable',
        child: DocsApiTable(
          title: 'Table properties',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'header',
              type: 'List<TableCellSpec>',
              description:
                  'Required. The single header row: every table in the '
                  'corpus has exactly one.',
            ),
            DocsApiFact(
              name: 'rows',
              type: 'List<TableRowSpec>',
              description:
                  'Required. The body rows, or a single '
                  'TableRowSpec.span row replacing the whole body: see '
                  'States.',
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
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-eltable-static',
        child: DocsApiTable(
          title: 'Table static tokens',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'Table.headerHeight',
              type: 'static double',
              description: "The header row's whole box, 40px, rule included.",
            ),
            DocsApiFact(
              name: 'Table.cellPadding',
              type: 'static double',
              description: "Every cell's padding on each unclipped side.",
            ),
            DocsApiFact(
              name: 'Table.captionGap',
              type: 'static double',
              description: 'The gap between the body and the caption.',
            ),
            DocsApiFact(
              name: 'Table.ruleWidth',
              type: 'static double',
              description: 'The hairline rule between rows.',
            ),
            DocsApiFact(
              name: 'Table.collapsedRemainder',
              type: 'static double',
              description:
                  'Half that hairline, kept as unpainted padding under '
                  'the last row of a multi-row body: the rule it would '
                  'have shared with a row below it. Layout only; nothing '
                  'is painted there.',
            ),
          ],
        ),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-eltablecellspec',
        child: DocsApiTable(
          title: 'TableCellSpec: one header or body cell',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'child',
              type: 'Widget',
              description: "Required. The cell's content.",
            ),
            DocsApiFact(
              name: 'align',
              type: 'TableAlign',
              description:
                  'Defaults to start. end right-aligns: required on '
                  "numeric columns by this page's own convention.",
            ),
            DocsApiFact(
              name: 'checkbox',
              type: 'bool',
              description:
                  "Defaults to false. Drops the cell's trailing padding, "
                  "for a cell whose child is a checkbox-shaped control, "
                  "written as a flag because Flutter has no CSS :has() to "
                  'detect it automatically.',
            ),
          ],
        ),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-eltablerowspec',
        child: DocsApiTable(
          title: 'TableRowSpec: one body row',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'cells',
              type: 'List<TableCellSpec>',
              description:
                  "The default constructor's required field: this row's "
                  'cells, one per header column.',
            ),
            DocsApiFact(
              name: 'selected',
              type: 'bool',
              description:
                  'Defaults to false. Paints theme.muted at full '
                  'strength, beating a simultaneous hover fill on the '
                  'same row.',
            ),
            DocsApiFact(
              name: 'span',
              type: 'Widget',
              description:
                  "The TableRowSpec.span named constructor's required "
                  'positional field: a widget that replaces the whole '
                  'table body. cells is forced empty and selected forced '
                  'false on this constructor.',
            ),
            DocsApiFact(
              name: 'spanHeight',
              type: 'double?',
              description:
                  "TableRowSpec.span only. The spanning box's own "
                  'height; null lets it size to content.',
            ),
            DocsApiFact(
              name: 'isSpan',
              type: 'bool (getter)',
              description:
                  'True when span is non-null. Table asserts a '
                  'spanning row is the only entry in rows, Flutter\'s '
                  'Table has no column-spanning of its own, so a spanning '
                  'row is laid out as its own full-width box beside the '
                  'table rather than inside it, which is only sound when '
                  'it is the entire body.',
            ),
          ],
        ),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-eltablealign',
        child: DocsApiTable(
          title: 'TableAlign',
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
                  'start.alignment is Alignment.centerLeft, '
                  'end.alignment is Alignment.centerRight: literal, not '
                  'directionality-aware. See RTL.',
            ),
          ],
        ),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-eltablecolumnwidth',
        child: DocsApiTable(
          title: 'TableColumnWidth: the default column-width rule',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'minIntrinsicWidth',
              type: 'override',
              description:
                  "The column's narrowest cell content can go: what a "
                  'narrow viewport squeezes every column down toward. '
                  'See Responsive.',
            ),
            DocsApiFact(
              name: 'maxIntrinsicWidth',
              type: 'override',
              description:
                  "The column's widest unwrapped cell: also this "
                  "class's flex, which is what turns Flutter's "
                  'proportional column growth into the browser\'s own '
                  'proportional-to-max-content distribution.',
            ),
            DocsApiFact(
              name: 'flex',
              type: 'override',
              description:
                  'Returns maxIntrinsicWidth (or null if it is zero, '
                  'which takes the column out of the flex distribution '
                  'entirely).',
            ),
          ],
        ),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-table-motion',
        child: DocsApiTable(
          title: 'Top-level motion tokens',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'tableHoverDuration',
              type: 'Duration (getter)',
              description:
                  "MotionDurations.normal, 250ms. What a row's "
                  'hover fill fades on.',
            ),
            DocsApiFact(
              name: 'tableHoverCurve',
              type: 'Curve (getter)',
              description: 'MotionCurves.enter.',
            ),
          ],
        ),
      ),
    ],
  );
}

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Rest',
    treatment:
        'No fill on any row. A hairline rule (theme.border) sits under '
        'the header and under every body row except the last.',
    userSignal: 'A plain, unfilled table.',
  ),
  DocsStateFact(
    state: 'Hover',
    treatment:
        'The row under the pointer fades to theme.muted at 50% alpha '
        '(bg-muted/50) over tableHoverDuration (250ms) on '
        'tableHoverCurve: a MouseRegion on every body cell reports '
        'entry to the row, painted per cell via TweenAnimationBuilder '
        'since the fill has to travel, not just be a static colour.',
    userSignal:
        'A soft highlight follows the pointer down the body. The header '
        'row never hovers.',
  ),
  DocsStateFact(
    state: 'Selected',
    treatment:
        'TableRowSpec.selected paints theme.muted at full strength, '
        'and: because selection is resolved after hover in the same '
        'comparison, at equal specificity: it beats a simultaneous hover '
        'on that row rather than the two blending.',
    userSignal: 'A visibly stronger fill than a merely-hovered row.',
  ),
  DocsStateFact(
    state: 'Empty',
    treatment:
        'TableRowSpec.span replaces the entire body with one widget, '
        'vertically centred in a box of spanHeight. Table asserts if '
        'any other row is present alongside it.',
    userSignal:
        "Whatever the caller passes as the spanning widget, "
        'data_table_demo.dart uses a Empty with a "Clear filter" '
        'button.',
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment:
        'The hover fade\'s duration is effectiveMotionDuration(context, '
        'tableHoverDuration), which collapses to Duration.zero when '
        'MediaQuery.disableAnimationsOf(context) is true: verified in '
        'table_test.dart.',
    userSignal: 'The hover fill still appears, instantly instead of fading.',
  ),
  DocsStateFact(
    state: 'Focus-visible / Pressed / Loading / Error / Success / Disabled',
    treatment:
        'N/A on Table itself: it has no FocusNode, no tap gesture of '
        'its own beyond the hover MouseRegion, and no loading, error, '
        'success or enabled parameter. Whichever of these a real table '
        'needs lives on the widget a caller puts inside a cell instead: '
        'data_table_demo.dart\'s sortable header is a real Button '
        '(focusable, has a disabled state while loading), its checkboxes '
        'are real Checkbox instances, and its loading rows are '
        'Skeleton content: none of it is a Table-level flag.',
    userSignal:
        "Look at the cell's own widget's documentation for that state, "
        'not this page.',
  ),
];

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Semantic role: none. Table, and its private _HeaderCell/'
            '_BodyCell builders, construct zero Semantics widgets '
            'anywhere. Assistive tech receives whatever each cell\'s own '
            'child happens to expose (a bare Text reads as static text, a '
            'Badge exposes nothing per its own docs, a Checkbox '
            'exposes its own control) with no table, row, cell or '
            'columnHeader grouping around any of it, and no association '
            'between a header cell and the column beneath it.',
        'Required labels: none of Table\'s own: caption is rendered as '
            'plain centred text under the body, not wired to any '
            'table-level accessible label or description.',
        'Keyboard interactions: none. See the Keyboard disclosure below.',
        'Focus behavior: Table never requests or reports focus itself.',
        "Touch target: not evaluated by Table: a cell's content owns "
            'its own target size. The table only fixes the header row\'s '
            'height (Table.headerHeight, 40px); body rows are exactly '
            'as tall as their content.',
        'Non-colour signals: none for hover or selected: both are fills '
            'only, with no icon, border, or text change alongside them, '
            'and neither is exposed as semantics, so a screen reader gets '
            'no cue at all that a row is hovered or selected. A caller '
            'that needs selection announced has to wrap the row\'s own '
            'content in its own Semantics(selected: …).',
        'Error wiring: none: a table is not a form control and has no '
            'invalid state of its own.',
        'Screen-reader announcements: none: there is no liveRegion. A '
            "caption or a cell whose text changes across a rebuild is "
            'not announced as a change.',
        'Known platform differences: none observed: table.dart has no '
            'platform-conditional code; the same widget tree renders '
            'everywhere.',
      ]);
}

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'No key handling of its own: table.dart wires no Focus.onKeyEvent '
            'anywhere, and Table holds no FocusNode. There is no way to '
            'tab into a table as such.',
        'Not in the tab order: Table itself never appears as a stop; '
            'only content a caller places inside a cell (a sortable '
            'header Button, an Checkbox, the Actions section\'s own '
            'DropdownMenu trigger) can receive focus, exactly as far as '
            "that widget's own keyboard documentation describes.",
        'Row hover is pointer-only: the MouseRegion behind the hover '
            'fade answers onEnter/onExit; there is no keyboard-driven '
            'equivalent that moves the highlight by focus.',
        'Tab order among cell content follows whatever order the table '
            'is built in, top row to bottom, left cell to right: '
            'table.dart declares no FocusTraversalPolicy of its own.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'No wrapper, plain-text cells: at 390px (358px available after '
            '16px padding on each side) against a realistic 4-column '
            'table, RenderTable compresses every column proportionally '
            "toward its own minimum-intrinsic width, Flutter's own "
            'algorithm, not a Table behaviour: rather than triggering a '
            'scrollbar the way overflow-x-auto would. A Text or StyledText '
            'cell absorbs that safely: it wraps onto more lines and the '
            'row grows taller, with no error.',
        'No wrapper, a non-wrapping cell: the same table\'s "Type" '
            "column — an icon beside a label in a Row(mainAxisSize: "
            'MainAxisSize.min), the exact shape example/lib/pages/'
            'data.dart\'s own Transaction history table and '
            'example/lib/data_table_demo.dart\'s Card column both use: '
            'has no give. Once its column is squeezed below the row\'s '
            'own combined minimum width it throws "A RenderFlex '
            'overflowed by 104 pixels on the right": the debug '
            'yellow-and-black stripes, clipped paint outside debug mode. '
            'This is measured, not hypothetical: see table_test.dart\'s '
            '"un-wrapped" case.',
        'The obvious fix does not work: wrapping the bare Table in '
            'SingleChildScrollView(scrollDirection: Axis.horizontal) '
            'throws a different error, "BoxConstraints forces an '
            'infinite width." Table\'s root Column stretches its cross '
            'axis (crossAxisAlignment: CrossAxisAlignment.stretch), and a '
            'stretched cross axis needs a bounded width; a horizontal '
            'scroll view hands its child an unbounded one along the '
            'scroll axis.',
        'The recipe that does work: SingleChildScrollView(scrollDirection: '
            'Axis.horizontal, child: IntrinsicWidth(child: Table(…))). '
            "IntrinsicWidth measures the table's own natural width first "
            'and hands the scroll view a bounded box, which is what lets '
            'the stretched Column resolve. Every live specimen on this '
            'page uses exactly this wrapper, which is why each one '
            'renders correctly at 390px instead of reproducing its own '
            'finding: see table_test.dart\'s narrow-width page test.',
        'Platform parity: no platform-conditional code in table.dart; '
            'the same widget tree renders on Android, iOS, Web, macOS, '
            'Windows and Linux.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      DocsInstallFacts(
        facts: <DocsInstallFact>[
          const DocsInstallFact(
            label: 'Registry item',
            value: 'table',
            description:
                'registry/components/table.json exists and is '
                'installable through the CLI today.',
          ),
          const DocsInstallFact(
            label: 'Destination',
            value: 'lib/components/ui/table.dart',
            description:
                'The same lib/components/ui/ target every component '
                'installs to.',
          ),
          DocsInstallFact(
            label: 'Dependencies',
            value: tableDoc.dependencies.join(', '),
            description:
                "The manifest's registryDependencies, resolved "
                'automatically by the registry client: colors, spacing, '
                'theme, typography, and motion (the hover-fade duration '
                'and curve). table.dart imports no other component and '
                'no effect file: unlike badge or button, it does not '
                'reach for surface or any other visual effect.',
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
          const DocsInstallFact(
            label: 'Platforms',
            value: 'Android, iOS, Web, macOS, Windows, Linux',
            description: 'No platform-conditional code in table.dart.',
          ),
          const DocsInstallFact(
            label: 'Verified',
            value: 'docs specimens only',
            description:
                "This page's live specimens and "
                'example/test/components_docs/table_test.dart. No '
                'dedicated package-level unit test exists for table.dart '
                'as of this page, and there is no registry fixture '
                'install run as part of writing it.',
          ),
        ],
      ),
      SizedBox(height: space(2)),
      DocsLinkRow(
        links: <DocsLink>[
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
  Widget build(BuildContext context) => DocsInstallFacts(
    title: 'What actually varies with the theme',
    facts: const <DocsInstallFact>[
      DocsInstallFact(
        label: 'theme.border',
        value: 'header and row rules',
        description:
            'Every colour Table paints is theme-derived: theme.border '
            'for the header and row rules, theme.muted for the hover and '
            'selected fills, theme.foreground and theme.mutedForeground '
            'for header, body and caption text via '
            'TextStyles.tableHead, TextStyles.bodySmall and TextStyles.small. '
            'Flipping ThemeController re-resolves all of them live: '
            'nothing is cached.',
      ),
      DocsInstallFact(
        label: 'Static, not theme, tokens',
        value: 'collapsedRemainder, tableHoverDuration/Curve',
        description:
            'Not designer-facing colour tokens; exposed as static and '
            'top-level getters specifically so a page like this one, or '
            'a test, can name the exact number instead of restating it.',
      ),
      DocsInstallFact(
        label: 'No colour override parameter',
        value: 'none',
        description:
            'Table declares no colour-override parameter of its own: '
            'no headerColor, no rowFill, no borderColor argument anywhere '
            "in its constructor. A caller that needs a different fill "
            "wraps a cell's own content, or reaches for a new component, "
            'rather than bypassing the token system here.',
      ),
    ],
  );
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
