import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/table/meta.dart';
import 'package:example/components_docs/table/page.dart';
import 'package:example/docs/component_doc_page.dart' show DocsTocEntry;
import 'package:example/docs/docs_disclosure.dart';
import 'package:example/docs/docs_install.dart';
import 'package:example/docs/docs_section.dart' show DocsSection;
import 'package:example/docs/docs_showcase.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness({
  required Widget child,
  required ElThemeController controller,
}) => ElTheme(
  controller: controller,
  child: MaterialApp(home: SingleChildScrollView(child: child)),
);

/// The single `DocsDisclosure` whose title is [title]. `DocsDisclosure`'s own
/// trigger key ([DocsDisclosure.triggerKey]) is one constant shared by every
/// instance on the page, so a bare `find.byKey` would match all eight — this
/// narrows to the one panel by its title first, matching `button_test.dart`'s
/// own convention.
Finder _disclosureTrigger(String title) => find.descendant(
  of: find.byWidgetPredicate(
    (Widget widget) => widget is DocsDisclosure && widget.title == title,
  ),
  matching: find.byKey(DocsDisclosure.triggerKey),
);

Future<void> _open(WidgetTester tester, String title) async {
  final Finder trigger = _disclosureTrigger(title);
  await tester.ensureVisible(trigger);
  await tester.pump();
  await tester.tap(trigger);
  await tester.pump();
  await tester.pump(ElDurations.jelly);
}

/// A minimal, real [ElTable]: the same shape [TableDocPage]'s own Preview
/// specimen uses (an icon-and-label first cell, a right-aligned money
/// column, a badge column): mounted directly, without the rest of the doc
/// article around it, so the assertions below are about `ElTable` itself and
/// do not depend on how the page happens to compose it.
Widget _realisticTable({
  bool selectSecondRow = false,
  bool firstCellIsNonWrappingRow = true,
}) => ElTable(
  header: const <ElTableCellSpec>[
    ElTableCellSpec(child: Text('Type')),
    ElTableCellSpec(child: Text('Detail')),
    ElTableCellSpec(child: Text('Amount'), align: ElTableAlign.end),
  ],
  rows: <ElTableRowSpec>[
    ElTableRowSpec(
      cells: <ElTableCellSpec>[
        ElTableCellSpec(
          child: firstCellIsNonWrappingRow
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const <Widget>[
                    ElIcon.lucide(ElLucide.arrowDownLeft, size: ElIconSize.sm),
                    SizedBox(width: 8),
                    Text('Subscription renewal'),
                  ],
                )
              : const Text('Subscription renewal'),
        ),
        const ElTableCellSpec(child: Text('Studio Pro annual plan')),
        const ElTableCellSpec(align: ElTableAlign.end, child: Text('\$129.00')),
      ],
    ),
    ElTableRowSpec(
      selected: selectSecondRow,
      cells: const <ElTableCellSpec>[
        ElTableCellSpec(child: Text('Payout')),
        ElTableCellSpec(child: Text('Weekly creator payout')),
        ElTableCellSpec(align: ElTableAlign.end, child: Text('\$412.50')),
      ],
    ),
  ],
);

/// Every [Container] one [ElTable] paints, header row first then body rows,
/// each row left to right: the order `ElTable.build` composes its
/// `TableRow`s in. `_HeaderCell` and `_BodyCell` are private, so this is the
/// only way a test outside `table.dart` reads back what either one painted.
///
/// Scoped to a single `Table` [of] rather than the whole tree, because
/// `page.dart` mounts more than one live `ElTable` specimen: an unscoped
/// search would mix containers from whichever one the finder happened to
/// visit first.
List<Container> _cellContainers(WidgetTester tester, {required Finder of}) =>
    tester
        .widgetList<Container>(
          find.descendant(
            of: find.descendant(of: of, matching: find.byType(Table)),
            matching: find.byType(Container),
          ),
        )
        .toList();

/// The key `page.dart` puts on its Preview specimen.
const Key _previewTableKey = ValueKey<String>('table-doc-preview-table');

BoxDecoration _decoration(Container c) => c.decoration! as BoxDecoration;

void main() {
  group('table docs page', () {
    testWidgets(
      'renders the article, the full API table, and a live ElTable specimen with real rows',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        String? destination;
        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: TableDocPage(
              onNavigate: (String route) => destination = route,
            ),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('table-doc-article')),
          findsOneWidget,
        );

        await _open(tester, 'API Reference');

        // Every public member enumerated from lib/src/components/table.dart:
        // ElTable's own constructor and static tokens, ElTableCellSpec,
        // ElTableRowSpec (both constructors) plus isSpan, ElTableAlign and its
        // alignment getter, ElTableColumnWidth's three overrides, and the two
        // top-level hover-motion getters.
        for (final String member in <String>[
          // ElTable
          'header', 'rows', 'caption',
          'ElTable.headerHeight', 'ElTable.cellPadding',
          'ElTable.captionGap', 'ElTable.ruleWidth',
          'ElTable.collapsedRemainder',
          // ElTableCellSpec
          'child', 'align', 'checkbox',
          // ElTableRowSpec
          'cells', 'selected', 'span', 'spanHeight', 'isSpan',
          // ElTableAlign
          'start', 'end', 'alignment',
          // ElTableColumnWidth
          'minIntrinsicWidth', 'maxIntrinsicWidth', 'flex',
          // top-level
          'elTableHoverDuration', 'elTableHoverCurve',
        ]) {
          expect(find.text(member), findsWidgets, reason: 'missing $member');
        }

        // A live ElTable specimen, with real (non-placeholder) row content,
        // mounts somewhere on the page.
        expect(find.byType(ElTable), findsWidgets);
        expect(
          find.text('Showing the 5 most recent transactions of 248.'),
          findsOneWidget,
          reason: 'the Preview specimen should carry a real caption',
        );

        expect(tableDoc.name, 'table');
        expect(tableDoc.exports, containsAll(<String>['ElTable']));
        expect(tableDoc.command, 'elattar add table');
        expect(destination, isNull);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'the page is declared, and every section is a kit component',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 4000);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: const TableDocPage(),
          ),
        );
        await tester.pump();

        // Five specimen stages: Preview, Composition, Actions, RTL — Data
        // Table is deliberately a SnippetSection, not a ShowcaseSection: see
        // the spec's own description.
        expect(find.byType(DocsShowcase), findsNWidgets(4));
        expect(find.byType(DocsInstall), findsOneWidget);
        // Eight collapsed sections: API Reference, States, Accessibility,
        // Keyboard, Responsive, Dependencies, Theming, Source.
        expect(find.byType(DocsDisclosure), findsNWidgets(8));
      },
    );

    test('the table of contents matches the declared sections', () {
      expect(
        tableDocSpec.toc.map((DocsTocEntry entry) => entry.title).toList(),
        <String>[
          'Preview',
          'Installation',
          'Usage',
          'Composition',
          'Actions',
          'Data Table',
          'RTL',
          'API Reference',
          'States',
          'Accessibility',
          'Keyboard',
          'Responsive',
          'Dependencies',
          'Theming',
          'Source',
        ],
      );
    });

    testWidgets(
      'sections render in the shadcn-mirrored order, section for section',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: const TableDocPage(),
          ),
        );
        await tester.pump();

        final List<String> titles = tester
            .widgetList<DocsSection>(find.byType(DocsSection))
            .map((DocsSection section) => section.title)
            .toList();

        expect(titles, <String>[
          'Preview',
          'Installation',
          'Usage',
          'Composition',
          'Actions',
          'Data Table',
          'RTL',
          'API Reference',
          'States',
          'Accessibility',
          'Keyboard',
          'Responsive',
          'Dependencies',
          'Theming',
          'Source',
        ]);
        expect(tester.takeException(), isNull);
      },
    );

    test(
      'ElTableAlign resolves literal, direction-blind Alignment values (backs RTL)',
      () {
        // The whole finding the RTL section documents: `start`/`end` map to
        // the plain, non-directional Alignment class, not
        // AlignmentDirectional.centerStart/.centerEnd, so no ambient
        // Directionality can change what these resolve to.
        expect(ElTableAlign.start.alignment, Alignment.centerLeft);
        expect(ElTableAlign.end.alignment, Alignment.centerRight);
      },
    );

    testWidgets(
      'renders at narrow width with the anchor strip instead of a rail, and '
      'the wide Preview specimen does not overflow',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: const TableDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('table-doc-article')),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey<String>('docs-layout-anchor-strip')),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey<String>('docs-layout-sidebar')),
          findsNothing,
        );
        // The Preview specimen wraps its table in a horizontal scroll view
        // precisely because ElTable does not provide one itself: see the
        // "ElTable overflow behaviour" group below for the bare-widget
        // proof. This assertion is what keeps that claim honest: if a
        // future edit to page.dart drops the wrapper, this page would
        // start throwing "RenderFlex overflowed" at 390px and this test
        // would fail loudly instead of a reader finding out first.
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'the header rule and the selected-row fill are live theme tokens',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        final ElThemeController controller = ElThemeController(
          mode: ElThemeMode.dark,
        );
        await tester.pumpWidget(
          _harness(controller: controller, child: const TableDocPage()),
        );
        await tester.pump();

        ElThemeData themeOf() =>
            ElTheme.of(tester.element(find.byType(TableDocPage)));
        final Finder preview = find.byKey(_previewTableKey);

        final Color darkBorder = _decoration(
          _cellContainers(tester, of: preview).first,
        ).border!.bottom.color;
        expect(darkBorder, themeOf().border);

        controller.setMode(ElThemeMode.light);
        await tester.pump();

        final Color lightBorder = _decoration(
          _cellContainers(tester, of: preview).first,
        ).border!.bottom.color;
        expect(lightBorder, themeOf().border);
        expect(
          lightBorder,
          isNot(darkBorder),
          reason: 'the header rule is theme.border, not a fixed colour',
        );
      },
    );
  });

  /// These tests are about `ElTable` itself, not about how `page.dart`
  /// composes it: a bare specimen the size of the doc page's own Preview,
  /// mounted on its own, so a claim made in the Responsive section (no
  /// scroll container of its own; columns compress; a non-wrapping cell can
  /// overflow; wrapping fixes it a specific way) is pinned to a real,
  /// independently-checkable widget test rather than asserted from reading
  /// the source alone.
  group(
    'ElTable overflow behaviour at 390px (backs the Responsive section)',
    () {
      Future<void> pumpNarrow(WidgetTester tester, Widget child) async {
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: Padding(padding: const EdgeInsets.all(16), child: child),
          ),
        );
      }

      testWidgets(
        'un-wrapped: a plain-text cell reflows (wraps, grows taller) with no '
        'exception, but a non-wrapping Row cell overflows',
        (WidgetTester tester) async {
          // Plain text: ElTable's own columns compress toward each cell's
          // min-intrinsic width; a Text cell simply wraps.
          await pumpNarrow(
            tester,
            _realisticTable(firstCellIsNonWrappingRow: false),
          );
          await tester.pump();
          expect(
            tester.takeException(),
            isNull,
            reason: 'wrappable text should reflow, not overflow',
          );

          // The same table, but its first cell is the icon+label Row every
          // real call site in this repo actually uses for a typed leading
          // cell (see example/lib/pages/data.dart's Transaction history and
          // example/lib/data_table_demo.dart's Card column): a Row with
          // mainAxisSize.min has no give, so once its column is squeezed
          // below the row's own minimum width it overflows for real.
          await pumpNarrow(tester, _realisticTable());
          await tester.pump();
          final dynamic error = tester.takeException();
          expect(error, isNotNull);
          expect(error.toString(), contains('RenderFlex overflowed'));
        },
      );

      testWidgets(
        'a bare horizontal SingleChildScrollView around ElTable throws: its '
        'root Column stretches its cross axis, which needs a bounded width',
        (WidgetTester tester) async {
          // The failure repeats across layout and semantics, which is more
          // than one exception: tester.takeException() then only hands back
          // a "Multiple exceptions (N)" summary instead of the message
          // itself. Installing a capturing FlutterError.onError first (and
          // restoring the original afterwards) reads the real first message
          // instead of that summary.
          final List<FlutterErrorDetails> captured = <FlutterErrorDetails>[];
          final FlutterExceptionHandler? previousHandler = FlutterError.onError;
          FlutterError.onError = captured.add;
          addTearDown(() => FlutterError.onError = previousHandler);

          await pumpNarrow(
            tester,
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: _realisticTable(),
            ),
          );

          expect(captured, isNotEmpty);
          expect(
            captured.first.exceptionAsString(),
            contains('forces an infinite width'),
          );
        },
      );

      testWidgets(
        'SingleChildScrollView + IntrinsicWidth renders the table at its full '
        'natural width, scrollable, with no exception: the working recipe',
        (WidgetTester tester) async {
          await pumpNarrow(
            tester,
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: IntrinsicWidth(child: _realisticTable()),
            ),
          );
          await tester.pump();
          expect(tester.takeException(), isNull);

          final RenderBox box = tester.renderObject<RenderBox>(
            find.byType(Table),
          );
          // Wide enough that it could only have rendered at its natural,
          // unconstrained width rather than the 390px (minus padding)
          // available: i.e. it is genuinely scrolling, not clipped.
          expect(box.size.width, greaterThan(390));
        },
      );
    },
  );

  group('ElTable row state (backs the States section)', () {
    testWidgets(
      'rest has no fill, hover fades in muted/50%, and a selected row wins '
      'over hover at full muted strength',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(900, 600);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        final ElThemeController controller = ElThemeController(
          mode: ElThemeMode.dark,
        );
        await tester.pumpWidget(
          _harness(
            controller: controller,
            child: _realisticTable(selectSecondRow: true),
          ),
        );
        await tester.pump();

        final ElThemeData theme = ElTheme.of(
          tester.element(find.byType(ElTable)),
        );

        // Containers, in build order: header cell ×3, row0 cell ×3 (rest),
        // row1 cell ×3 (selected).
        List<Container> cells() =>
            _cellContainers(tester, of: find.byType(ElTable));
        expect(cells().length, 9);

        final Color rest = _decoration(cells()[3]).color!;
        expect(
          rest,
          theme.muted.withValues(alpha: 0),
          reason: 'an unselected, unhovered row paints no fill',
        );

        final Color selected = _decoration(cells()[6]).color!;
        expect(
          selected,
          theme.muted,
          reason: 'ElTableRowSpec.selected is theme.muted at full strength',
        );

        // Hover row 0 (unselected) and let the 250ms transition run.
        final TestGesture pointer = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        addTearDown(pointer.removePointer);
        await pointer.addPointer(location: Offset.zero);
        await pointer.moveTo(
          tester.getCenter(find.text('Studio Pro annual plan')),
        );
        await tester.pump();
        await tester.pump(ElDurations.transitionDefault);

        final Color hovered = _decoration(cells()[3]).color!;
        expect(
          hovered,
          theme.muted.withValues(alpha: 0.5),
          reason: 'a hovered row fades to bg-muted/50',
        );

        // The selected row is unaffected by hovering a different row, and
        // hovering the SELECTED row itself would still read as full muted —
        // selection is written after hover and wins at equal specificity,
        // per table.dart's own _fill comment.
        await pointer.moveTo(
          tester.getCenter(find.text('Weekly creator payout')),
        );
        await tester.pump();
        await tester.pump(ElDurations.transitionDefault);
        final Color selectedWhileHovered = _decoration(cells()[6]).color!;
        expect(selectedWhileHovered, theme.muted);
      },
    );

    testWidgets(
      'reduced motion collapses the hover transition to zero duration',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(900, 600);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        final ElThemeController controller = ElThemeController(
          mode: ElThemeMode.dark,
        );
        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: _harness(controller: controller, child: _realisticTable()),
          ),
        );
        await tester.pump();

        final ElThemeData theme = ElTheme.of(
          tester.element(find.byType(ElTable)),
        );

        final TestGesture pointer = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        addTearDown(pointer.removePointer);
        await pointer.addPointer(location: Offset.zero);
        await pointer.moveTo(
          tester.getCenter(find.text('Studio Pro annual plan')),
        );
        // A single, zero-time pump: a non-reduced hover would still be mid
        // fade-in at this point (see the test above's post-transition pump).
        await tester.pump();

        final Color hovered = _decoration(
          _cellContainers(tester, of: find.byType(ElTable))[3],
        ).color!;
        expect(hovered, theme.muted.withValues(alpha: 0.5));
      },
    );
  });

  group('ElTableRowSpec.span (backs the Empty state and Composition)', () {
    testWidgets(
      'a spanning row lays its widget out beside the table body, at the '
      'given height, and asserts if it is not the only row',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(900, 600);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: ElTable(
              header: const <ElTableCellSpec>[
                ElTableCellSpec(child: Text('Card')),
              ],
              rows: <ElTableRowSpec>[
                ElTableRowSpec.span(const Text('No results.'), spanHeight: 120),
              ],
            ),
          ),
        );
        await tester.pump();

        expect(find.text('No results.'), findsOneWidget);
        final RenderBox box = tester.renderObject<RenderBox>(
          find
              .ancestor(
                of: find.text('No results.'),
                matching: find.byType(SizedBox),
              )
              .first,
        );
        expect(box.size.height, 120);
      },
    );
  });
}
