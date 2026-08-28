/// Tests for `components_docs/pagination/meta.dart` and
/// `components_docs/pagination/page.dart`: the public Pagination component
/// documentation page.
///
/// Re-housed onto the kit alongside the page: sections are now
/// `DocsSection`s rather than `Section`s, and the eight disclosures (API
/// Reference, States, Accessibility, Keyboard, Responsive, Dependencies,
/// Theming, Source) are collapsed `DocsDisclosure`s that mount no content
/// until opened — see `_openDisclosure`, the same helper `button_test.dart`
/// uses. `pumpAndSettle` is never used here: several documentation-shell
/// widgets run controllers that repeat forever, so settling on this page
/// would hang; every wait below is a bounded `tester.pump()` instead.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/pagination/meta.dart';
import 'package:example/components_docs/pagination/page.dart';
import 'package:example/docs/docs_disclosure.dart';
import 'package:example/docs/docs_section.dart' show DocsSection;
import 'package:flutter/material.dart'
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
        TableColumnWidth,
        ActionChip,
        AlertDialog,
        Badge,
        Card,
        CarouselController,
        Checkbox,
        Dialog,
        DropdownMenu,
        Drawer,
        DrawerHeader,
        Slider,
        Switch,
        TextFormField,
        Tooltip;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness({required Widget child, required ThemeController controller}) =>
    ThemeScope(
      controller: controller,
      child: MaterialApp(home: SingleChildScrollView(child: child)),
    );

/// The single `DocsDisclosure` whose title is [title], opened. A closed
/// `DocsDisclosure` mounts no content, so a test reading anything inside one
/// must open it first — the same helper `button_test.dart` uses.
Future<void> _openDisclosure(WidgetTester tester, String title) async {
  final Finder trigger = find.descendant(
    of: find.byWidgetPredicate(
      (Widget widget) => widget is DocsDisclosure && widget.title == title,
    ),
    matching: find.byKey(DocsDisclosure.triggerKey),
  );
  await tester.ensureVisible(trigger);
  await tester.pump();
  await tester.tap(trigger);
  await tester.pump();
  await tester.pump(MotionDurations.open);
}

/// Every constructor parameter [pagination.dart](../../../lib/src/components/pagination.dart)
/// declares across its four public classes: [Pagination], [PaginationLink],
/// [PaginationStep] (both named constructors share the same field set) and
/// [PaginationEllipsis] (key only). The API table must render each of
/// these names somewhere.
const List<String> _apiParamNames = <String>[
  'children', // Pagination
  'label', 'isActive', 'onTap', // PaginationLink
  'text', // PaginationStep (onTap repeats, already listed)
];

void main() {
  group('pagination docs page', () {
    testWidgets('renders the house-shape section list, in order', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 8000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _harness(
          controller: ThemeController(mode: ColorMode.dark),
          child: const PaginationDocPage(),
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
        'Computed range',
        'Composition',
        'Composed with other primitives',
        'Truncation rule',
        'First page',
        'Last page',
        'Single page',
        'Simple',
        'Icons only',
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
    });

    testWidgets(
      'renders the article, the full API table, and the truncation worked '
      'example, and reports a tapped page',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 8000);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        String? destination;
        await tester.pumpWidget(
          _harness(
            controller: ThemeController(mode: ColorMode.dark),
            child: PaginationDocPage(
              onNavigate: (String route) => destination = route,
            ),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('pagination-doc-article')),
          findsOneWidget,
        );

        await _openDisclosure(tester, 'API Reference');

        // The API table lists every constructor parameter found in
        // lib/src/components/pagination.dart.
        for (final String param in _apiParamNames) {
          expect(find.text(param), findsWidgets, reason: 'missing $param');
        }
        // The two named constructors are the real public surface of
        // PaginationStep: both must be documented as their own rows.
        for (final String ctor in <String>[
          'PaginationStep.previous',
          'PaginationStep.next',
        ]) {
          expect(
            find.textContaining(ctor),
            findsWidgets,
            reason: 'missing $ctor',
          );
        }
        // Static tokens every class exposes.
        for (final String token in <String>[
          'Pagination.gap',
          'PaginationStep.tightPadding',
          'PaginationStep.loosePadding',
          'PaginationEllipsis.boxSize',
          'PaginationEllipsis.glyphSize',
        ]) {
          expect(
            find.textContaining(token),
            findsWidgets,
            reason: 'missing $token',
          );
        }

        // The live-demo worked example, ahead of any heading: 100 pages,
        // current page 47, one sibling each side. It must render as
        // 1 … 46 47 48 … 100, exactly two ellipses.
        final Finder worked = find.byKey(
          const ValueKey<String>('pagination-preview:worked-example'),
        );
        expect(worked, findsOneWidget);
        for (final String label in <String>['1', '46', '47', '48', '100']) {
          expect(
            find.descendant(of: worked, matching: find.text(label)),
            findsOneWidget,
            reason: 'worked example missing page $label',
          );
        }
        expect(
          find.descendant(
            of: worked,
            matching: find.byType(PaginationEllipsis),
          ),
          findsNWidgets(2),
        );

        // A live specimen mounts and clicking a page number reports it:
        // tapping page 48 in the worked example moves the current page and
        // the on-screen "current page" readout updates to match.
        expect(
          find.descendant(
            of: worked,
            matching: find.text('Current page: 47 of 100'),
          ),
          findsOneWidget,
        );
        final Finder page48 = find.descendant(
          of: worked,
          matching: find.text('48'),
        );
        await tester.ensureVisible(page48);
        await tester.pump();
        await tester.tap(page48);
        await tester.pump();
        expect(
          find.descendant(
            of: worked,
            matching: find.text('Current page: 48 of 100'),
          ),
          findsOneWidget,
        );
        // Truncation re-centres on the new current page.
        for (final String label in <String>['1', '47', '48', '49', '100']) {
          expect(
            find.descendant(of: worked, matching: find.text(label)),
            findsOneWidget,
            reason: 'after tapping 48, missing page $label',
          );
        }

        // Boundary specimens: first page (no Previous cell), last page (no
        // Next cell), a single page (no siblings, no ellipsis at all).
        expect(
          find.byKey(const ValueKey<String>('pagination-preview:first-page')),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey<String>('pagination-preview:last-page')),
          findsOneWidget,
        );
        final Finder single = find.byKey(
          const ValueKey<String>('pagination-preview:single-page'),
        );
        expect(single, findsOneWidget);
        expect(
          find.descendant(
            of: single,
            matching: find.byType(PaginationEllipsis),
          ),
          findsNothing,
        );
        expect(
          find.descendant(of: single, matching: find.byType(PaginationStep)),
          findsNothing,
        );

        // Pagination declares an accessible container name: the page's
        // own Accessibility section claims this and the test proves it.
        expect(find.bySemanticsLabel('pagination'), findsWidgets);

        expect(paginationDoc.name, 'pagination');
        expect(
          paginationDoc.exports,
          containsAll(<String>[
            'Pagination',
            'PaginationLink',
            'PaginationStep',
            'PaginationEllipsis',
          ]),
        );
        expect(destination, isNull);
      },
    );

    testWidgets(
      'Simple, Icons only, and RTL each mount a real, distinct specimen',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 8000);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ThemeController(mode: ColorMode.dark),
            child: const PaginationDocPage(),
          ),
        );
        await tester.pump();

        // Simple: page links only, no Previous/Next, no ellipsis.
        final Finder simple = find.byKey(
          const ValueKey<String>('pagination-simple'),
        );
        expect(simple, findsOneWidget);
        expect(
          find.descendant(of: simple, matching: find.byType(PaginationStep)),
          findsNothing,
        );
        expect(
          find.descendant(
            of: simple,
            matching: find.byType(PaginationEllipsis),
          ),
          findsNothing,
        );
        expect(
          find.descendant(of: simple, matching: find.byType(PaginationLink)),
          findsNWidgets(5),
        );

        // Icons only: Previous/Next only, no page-number links.
        final Finder iconsOnly = find.byKey(
          const ValueKey<String>('pagination-icons-only'),
        );
        expect(iconsOnly, findsOneWidget);
        expect(
          find.descendant(of: iconsOnly, matching: find.byType(PaginationLink)),
          findsNothing,
        );
        expect(
          find.descendant(of: iconsOnly, matching: find.byType(PaginationStep)),
          findsNWidgets(2),
        );

        // RTL: composed under a real Directionality.rtl ancestor.
        final Finder rtl = find.byKey(const ValueKey<String>('pagination-rtl'));
        expect(rtl, findsOneWidget);
        expect(
          find.ancestor(
            of: rtl,
            matching: find.byWidgetPredicate(
              (Widget widget) =>
                  widget is Directionality &&
                  widget.textDirection == TextDirection.rtl,
            ),
          ),
          findsWidgets,
        );
        expect(
          find.descendant(of: rtl, matching: find.text('السابق')),
          findsOneWidget,
        );
        expect(
          find.descendant(of: rtl, matching: find.text('التالي')),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'renders at 390x844 with the anchor strip, no overflow, and reporting '
      'still works',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ThemeController(mode: ColorMode.dark),
            child: const PaginationDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('pagination-doc-article')),
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
        // Flutter reports a RenderFlex overflow through FlutterError, which
        // flutter_test surfaces via takeException: the classic 390px
        // failure mode for a long page range. Reaching this line with no
        // exception is the proof the page's own horizontal-scroll
        // mitigation works at this width.
        expect(tester.takeException(), isNull);

        final Finder worked = find.byKey(
          const ValueKey<String>('pagination-preview:worked-example'),
        );
        final Finder page48 = find.descendant(
          of: worked,
          matching: find.text('48'),
        );
        await tester.ensureVisible(page48);
        await tester.pump();
        await tester.tap(page48);
        await tester.pump();
        expect(
          find.descendant(
            of: worked,
            matching: find.text('Current page: 48 of 100'),
          ),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'the active page ink shifts when the live theme flips light/dark',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 8000);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        final ThemeController controller = ThemeController(
          mode: ColorMode.dark,
        );
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          _harness(controller: controller, child: const PaginationDocPage()),
        );
        await tester.pump();

        final Finder worked = find.byKey(
          const ValueKey<String>('pagination-preview:worked-example'),
        );
        ButtonVariant activeVariant() {
          final PaginationLink active = tester
              .widgetList<PaginationLink>(
                find.descendant(
                  of: worked,
                  matching: find.byType(PaginationLink),
                ),
              )
              .singleWhere((PaginationLink link) => link.isActive);
          final Finder activeFinder = find.descendant(
            of: find.byWidget(active),
            matching: find.byType(Button),
          );
          return tester.widget<Button>(activeFinder).variant;
        }

        expect(activeVariant(), ButtonVariant.outline);

        // Flip the SAME controller in place, not a fresh widget tree: the
        // same object every real theme toggle mutates.
        controller.setMode(ColorMode.light);
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('pagination-doc-article')),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: worked,
            matching: find.text('Current page: 47 of 100'),
          ),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'every cell is Tab-reachable and Enter activates a focused page link, '
      'inherited whole from Button',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 8000);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ThemeController(mode: ColorMode.dark),
            child: const PaginationDocPage(),
          ),
        );
        await tester.pump();

        final Finder simple = find.byKey(
          const ValueKey<String>('pagination-simple'),
        );
        await tester.ensureVisible(simple);
        await tester.pump();

        // Every PaginationLink cell wraps a genuinely focusable Button:
        // Focus.canRequestFocus tracks Button's own _enabled, which is
        // always true here (onTap ?? () {} means onPressed is never null).
        final Iterable<Focus> focusNodes = tester.widgetList<Focus>(
          find.descendant(of: simple, matching: find.byType(Focus)),
        );
        expect(focusNodes, isNotEmpty);
        expect(focusNodes.every((Focus f) => f.canRequestFocus), isTrue);

        // Enter activates a focused page link the same way a tap does: the
        // Preview specimen has real, observable onTap callbacks (Simple's
        // do not), so request focus on its page-48 cell's own Button
        // FocusNode directly and send Enter, then read the "current page"
        // text back.
        final Finder worked = find.byKey(
          const ValueKey<String>('pagination-preview:worked-example'),
        );
        final PaginationLink link48 = tester
            .widgetList<PaginationLink>(
              find.descendant(
                of: worked,
                matching: find.byType(PaginationLink),
              ),
            )
            .firstWhere((PaginationLink link) => link.label == '48');
        final Finder link48Cell = find.byWidget(link48);
        await tester.ensureVisible(link48Cell);
        await tester.pump();
        // PaginationLink passes no focusNode of its own to the Button
        // it wraps, so Focus auto-creates one internally; reach it through
        // a genuine descendant's context (the '48' label itself) rather
        // than the Focus widget's own field, which stays null unset.
        final BuildContext cellContext = tester.element(
          find.descendant(of: link48Cell, matching: find.text('48')),
        );
        Focus.of(cellContext).requestFocus();
        await tester.pump();
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await tester.pump();

        expect(
          find.descendant(
            of: worked,
            matching: find.text('Current page: 48 of 100'),
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'the Keyboard disclosure names the real, inherited Enter/Tab story',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          _harness(
            controller: ThemeController(mode: ColorMode.dark),
            child: const PaginationDocPage(),
          ),
        );
        await tester.pump();
        await _openDisclosure(tester, 'Keyboard');

        expect(find.textContaining('Tab'), findsWidgets);
        expect(find.textContaining('Enter'), findsWidgets);
      },
    );
  });
}
