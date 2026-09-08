/// Tests for `site/pages/charts_gallery_page.dart`, the `/charts` gallery.
///
/// `ChartSpecimenCard`'s toolbar hosts a `SheetOverlay` (View Code), and
/// `SheetOverlay` mounts its content through an `OverlayPortal` — a real
/// `Overlay` is required, which is why this harness wraps the page in a
/// `MaterialApp` rather than a bare `Directionality`/`MediaQuery` pair (see
/// `example/test/components_docs/sheet_test.dart`, which documents and hits
/// the same requirement). For the same reason, the View Code test advances
/// with explicit `pump()`/`pump(duration)` steps instead of `pumpAndSettle`:
/// the sheet's open transition and post-frame focus hop do not always settle
/// cleanly under a synthetic pump loop.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/charts/chart_card.dart';
import 'package:example/charts/chart_sources.g.dart';
import 'package:example/charts/specimens_area.dart';
import 'package:example/charts/specimens_radar.dart';
import 'package:example/docs/docs_copy_button.dart';
import 'package:example/site/pages/charts_gallery_page.dart';
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
import 'package:flutter_test/flutter_test.dart';

const Size _viewport = Size(1600, 2400);

/// `SheetOverlay` mounts its content through an `OverlayPortal`, which needs
/// a real `Overlay` ancestor — `WidgetsApp` supplies one (via its internal
/// `Navigator`) without pulling in Material's theme and default text style,
/// which is what a `MaterialApp` host did here and is not what this page (a
/// `widgets.dart`-only page, per the port's own rule against importing
/// `material.dart` into `lib/`) is designed against.
Future<void> _pump(
  WidgetTester tester, {
  DocsClipboardWriter? clipboardWriter,
}) async {
  tester.view.physicalSize = _viewport;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ThemeScope(
      controller: ThemeController(mode: ColorMode.light),
      child: WidgetsApp(
        color: const Color(0xFFFFFFFF),
        pageRouteBuilder:
            <T>(RouteSettings settings, WidgetBuilder builder) =>
                PageRouteBuilder<T>(
                  settings: settings,
                  pageBuilder:
                      (
                        BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation,
                      ) => builder(context),
                ),
        home: ChartsGalleryPage(clipboardWriter: clipboardWriter),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

/// The `ChartSpecimenCard` for exactly one specimen, found by its registry
/// id rather than by tree position.
///
/// The gallery renders every `fullWidth` specimen in its own row *before*
/// the rest of the family's grid (`charts_gallery_page.dart`'s `_family`
/// build), so `find.byType(ChartSpecimenCard).first` does not reliably mean
/// "the first entry in `areaSpecimens`" — for the area family it lands on
/// `chart-area-interactive` (the one `fullWidth` specimen), not
/// `chart-area-default` (`areaSpecimens.first`). Matching on
/// `specimen.id` is the targeting that cannot be fooled by that reordering.
Finder _cardFor(String specimenId) => find.byWidgetPredicate(
  (Widget widget) =>
      widget is ChartSpecimenCard && widget.specimen.id == specimenId,
);

void main() {
  testWidgets('opens on the area family and renders one card per specimen', (
    WidgetTester tester,
  ) async {
    await _pump(tester);
    expect(
      find.byType(ChartSpecimenCard),
      findsNWidgets(areaSpecimens.length),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('the tab strip switches families', (WidgetTester tester) async {
    await _pump(tester);

    await tester.tap(find.text('Radar'));
    await tester.pumpAndSettle();

    expect(
      find.byType(ChartSpecimenCard),
      findsNWidgets(radarSpecimens.length),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('every family tab renders without throwing', (
    WidgetTester tester,
  ) async {
    await _pump(tester);

    for (final String family in <String>[
      'Bar',
      'Line',
      'Pie',
      'Radar',
      'Radial',
      'Tooltips',
    ]) {
      await tester.tap(find.text(family));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: family);
      expect(find.byType(ChartSpecimenCard), findsWidgets, reason: family);
    }
  });

  testWidgets(
    "the area family's first card copies its own generated source",
    (WidgetTester tester) async {
      final List<String> written = <String>[];

      await _pump(
        tester,
        clipboardWriter: (String text) async {
          written.add(text);
        },
      );

      // Scoped to the ChartSpecimenCard for areaSpecimens.first specifically
      // (see `_cardFor`), then to a DocsCopyButton *inside* it. No sheet is
      // open anywhere in this test — `SheetOverlay`'s content is an
      // `OverlayPortal` that only builds once its trigger opens it
      // (`lib/src/components/ui/sheet.dart`) — so `DocsSnippet`'s own
      // (unwritable, real-clipboard) DocsCopyButton never gets built, and
      // this card's toolbar Copy button is the only DocsCopyButton in the
      // tree under it. That makes the target unambiguous by construction,
      // rather than by hoping a shared accessible name ('Copy code', which
      // every card's toolbar button carries) or a shared visible label
      // resolves to the right widget.
      final Finder card = _cardFor(areaSpecimens.first.id);
      expect(card, findsOneWidget);
      final Finder toolbarCopyButton = find.descendant(
        of: card,
        matching: find.byType(DocsCopyButton),
      );
      expect(toolbarCopyButton, findsOneWidget);

      await tester.tap(toolbarCopyButton);
      // Let the button's copy → confirm → revert cycle finish
      // (`DocsCopyButton.confirmation`, 2s) instead of leaving its timer
      // pending at the end of the test.
      await tester.pumpAndSettle(DocsCopyButton.confirmation);

      expect(written.single, chartSources[areaSpecimens.first.id]);
    },
  );

  testWidgets('View Code opens a right sheet holding that source', (
    WidgetTester tester,
  ) async {
    await _pump(tester);

    final Finder card = _cardFor(areaSpecimens.first.id);
    expect(card, findsOneWidget);
    final Finder viewCodeButton = find.descendant(
      of: card,
      matching: find.text('View Code'),
    );
    expect(viewCodeButton, findsOneWidget);

    await tester.tap(viewCodeButton);
    await tester.pump();
    await tester.pump(MotionDurations.overlayEnter);
    await tester.pump();

    expect(find.byType(SheetContent), findsOneWidget);
    expect(find.text(areaSpecimens.first.id), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}
