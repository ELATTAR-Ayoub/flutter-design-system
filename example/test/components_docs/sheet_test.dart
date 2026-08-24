/// Tests for `components_docs/sheet/meta.dart` and
/// `components_docs/sheet/page.dart`: the public Sheet component
/// documentation page.
///
/// Split from a former combined sheet+drawer test file: this file now
/// covers `SheetDocPage` alone. Drawer's own coverage lives in
/// `drawer_test.dart`.
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never a synthetic `MediaQuery`. Theme
/// coverage flips a single live `ElThemeController` in place.
///
/// `ElSheetOverlay` mounts its content through an `OverlayPortal`, so the
/// live specimen needs a real `Overlay`: the harness wraps the page in a
/// `MaterialApp`. Its open/close transition is a single forward-then-reverse
/// run on `ElDurations.overlay`, not a loop, so `pumpAndSettle` is safe.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/sheet/meta.dart';
import 'package:example/components_docs/sheet/page.dart';
import 'package:example/kit.dart' show ElSection;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const Size _wide = Size(1440, 900);
const Size _narrow = Size(390, 844);

/// The shadcn-parity section order this page must render, matching
/// https://ui.shadcn.com/docs/components/base/sheet's own `<h2>` list plus
/// this corpus's fixed six extras.
const List<String> _sectionOrder = <String>[
  'install',
  'usage',
  'composition',
  'side',
  'no-close-button',
  'rtl',
  'api',
  'states',
  'accessibility',
  'responsive',
  'dependencies',
  'theming',
  'source',
];

/// Every constructor parameter name declared on the public classes of
/// `lib/src/components/sheet.dart`.
const List<String> _sheetParamNames = <String>[
  'builder', // ElSheet.showLeft
  'width', // ElSheetPanel / ElSheetContent
  'showCloseButton', // ElSheetPanel / ElSheetContent
  'child', // ElSheetPanel / ElSheetTransition / ElSheetContentGroup
  'trigger', // ElSheetOverlay
  'content', // ElSheetOverlay
  'side', // ElSheetOverlay / ElSheetTransition / ElSheetContent
  'animation', // ElSheetTransition
  'children', // ElSheetContent / ElSheetHeader / ElSheetFooter
  'onClose', // ElSheetContent
  'fill', // ElSheetContent
  'text', // ElSheetTitle / ElSheetDescription
];

/// Matches only a [ElSheetContent] mounted by a live [ElSheetOverlay]
/// trigger: the page also keeps two static, always-mounted [ElSheetContent]
/// specimens on screen (the No close button and RTL sections' own
/// presentational panels, keyed `sheet-no-close-button` and `sheet-rtl`), so
/// `find.byType(ElSheetContent)` alone is never unique on this page.
Finder _liveOverlaySheet() => find.byWidgetPredicate(
  (Widget widget) =>
      widget is ElSheetContent &&
      widget.key != const ValueKey<String>('sheet-no-close-button') &&
      widget.key != const ValueKey<String>('sheet-rtl'),
);

Future<ElThemeController> _pumpSheetDoc(
  WidgetTester tester, {
  ValueChanged<String>? onNavigate,
  Size size = _wide,
  ElThemeMode mode = ElThemeMode.dark,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final ElThemeController theme = ElThemeController(mode: mode);
  addTearDown(theme.dispose);

  await tester.pumpWidget(
    ElTheme(
      controller: theme,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SingleChildScrollView(
          child: SheetDocPage(onNavigate: onNavigate),
        ),
      ),
    ),
  );
  await tester.pump();
  return theme;
}

void main() {
  group('meta', () {
    test('sheetDoc names the real public API surface', () {
      expect(sheetDoc.name, 'sheet');
      expect(sheetDoc.title, 'Sheet');
      expect(sheetDoc.route, '/components/sheet');
      expect(sheetDoc.sourcePath, 'lib/src/components/sheet.dart');
      expect(sheetDoc.description, isNotEmpty);
      expect(sheetDoc.description, isNot(contains('..')));
      expect(sheetDoc.description.trim(), sheetDoc.description);
      expect(
        sheetDoc.exports,
        containsAll(<String>[
          'ElSheet',
          'ElSheetPanel',
          'ElSheetSide',
          'ElSheetOverlay',
          'ElSheetTransition',
          'ElSheetContent',
          'ElSheetContentGroup',
          'ElSheetHeader',
          'ElSheetFooter',
          'ElSheetTitle',
          'ElSheetDescription',
        ]),
      );
      // No drawer symbols on this page's export list any more.
      expect(sheetDoc.exports, isNot(contains('ElDrawer')));
    });
  });

  group('SheetDocPage shadcn-parity section order', () {
    testWidgets('renders every shadcn-parity section, in order', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 3200);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await _pumpSheetDoc(tester, size: const Size(1440, 3200));

      double previousTop = -1;
      for (final String anchor in _sectionOrder) {
        final Finder section = find.byKey(ElSection.anchorKey(anchor));
        expect(section, findsOneWidget, reason: 'section "$anchor" missing');
        final double top = tester.getTopLeft(section).dy;
        expect(
          top,
          greaterThan(previousTop),
          reason: 'section "$anchor" should render after the previous section',
        );
        previousTop = top;
      }
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'No close button and RTL sections each mount their own live specimen',
      (WidgetTester tester) async {
        await _pumpSheetDoc(tester, size: const Size(1440, 3200));

        final Finder noCloseSpecimen = find.byKey(
          const ValueKey<String>('sheet-no-close-button'),
        );
        expect(noCloseSpecimen, findsOneWidget);
        expect(
          find.descendant(
            of: noCloseSpecimen,
            matching: find.text('Share link'),
          ),
          findsOneWidget,
        );
        expect(
          tester.widget<ElSheetContent>(noCloseSpecimen).showCloseButton,
          isFalse,
        );
        expect(
          find.descendant(
            of: find.byKey(ElSection.anchorKey('no-close-button')),
            matching: find.byType(ElButton),
          ),
          findsNothing,
        );

        final Finder rtlSpecimen = find.byKey(
          const ValueKey<String>('sheet-rtl'),
        );
        expect(rtlSpecimen, findsOneWidget);
        expect(
          find.descendant(
            of: find.byKey(ElSection.anchorKey('rtl')),
            matching: find.byWidgetPredicate(
              (Widget widget) =>
                  widget is Directionality &&
                  widget.textDirection == TextDirection.rtl,
            ),
          ),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: rtlSpecimen,
            matching: find.text('مشاركة الرابط'),
          ),
          findsOneWidget,
        );

        expect(tester.takeException(), isNull);
      },
    );
  });

  group('SheetDocPage', () {
    testWidgets(
      'renders the article with every documented constructor parameter',
      (WidgetTester tester) async {
        await _pumpSheetDoc(tester);

        expect(
          find.byKey(const ValueKey<String>('sheet-doc-article')),
          findsOneWidget,
        );
        expect(find.textContaining('Sheet'), findsWidgets);

        for (final String param in _sheetParamNames) {
          expect(
            find.text(param),
            findsAtLeastNWidgets(1),
            reason: 'Parameter "$param" missing from an API table',
          );
        }

        // ElSheetSide's four values, plus the isHorizontal getter row.
        for (final String value in <String>['top', 'right', 'bottom', 'left']) {
          expect(
            find.text(value),
            findsAtLeastNWidgets(1),
            reason: 'ElSheetSide.$value missing from the API table',
          );
        }
        expect(find.text('isHorizontal'), findsOneWidget);

        expect(
          find.byKey(const ValueKey<String>('docs-layout-sidebar')),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('installation names the real manual copy target', (
      WidgetTester tester,
    ) async {
      await _pumpSheetDoc(tester);

      expect(find.textContaining('elattar add sheet'), findsWidgets);
      expect(find.textContaining('source-foundation'), findsWidgets);
      expect(find.textContaining('lib/components/ui/sheet.dart'), findsWidgets);
    });

    testWidgets(
      'drops the sidebar and shows the anchor strip at mobile width',
      (WidgetTester tester) async {
        await _pumpSheetDoc(tester, size: _narrow, mode: ElThemeMode.light);

        expect(
          find.byKey(const ValueKey<String>('docs-layout-anchor-strip')),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey<String>('docs-layout-sidebar')),
          findsNothing,
        );
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'a live ElSheetOverlay opens a real ElSheetContent and dismisses on '
      'scrim tap',
      (WidgetTester tester) async {
        await _pumpSheetDoc(tester);

        expect(_liveOverlaySheet(), findsNothing);
        final Finder trigger = find.byKey(
          const ValueKey<String>('sheet-preview:right'),
        );
        await tester.ensureVisible(trigger);
        await tester.tap(trigger);
        await tester.pumpAndSettle();

        expect(_liveOverlaySheet(), findsOneWidget);
        expect(find.text('Notification settings'), findsOneWidget);
        final Rect panel = tester.getRect(_liveOverlaySheet());
        // side: right, pinned to the trailing edge of a 1440-wide viewport.
        expect(panel.right, closeTo(1440, 1));

        // Tap the scrim, well clear of the right-hand panel, to dismiss.
        await tester.tapAt(const Offset(20, 20));
        await tester.pumpAndSettle();
        expect(_liveOverlaySheet(), findsNothing);
      },
    );

    testWidgets('Escape dismisses an open sheet', (WidgetTester tester) async {
      await _pumpSheetDoc(tester);

      final Finder trigger = find.byKey(
        const ValueKey<String>('sheet-preview:right'),
      );
      await tester.ensureVisible(trigger);
      await tester.tap(trigger);
      await tester.pumpAndSettle();
      expect(_liveOverlaySheet(), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(_liveOverlaySheet(), findsNothing);
    });

    testWidgets('the Side section mounts its own independent set of triggers', (
      WidgetTester tester,
    ) async {
      await _pumpSheetDoc(tester, size: const Size(1440, 3200));

      final Finder sectionTrigger = find.byKey(
        const ValueKey<String>('sheet-example-side:left'),
      );
      await tester.ensureVisible(sectionTrigger);
      await tester.tap(sectionTrigger);
      await tester.pumpAndSettle();

      expect(_liveOverlaySheet(), findsOneWidget);
      final Rect panel = tester.getRect(_liveOverlaySheet());
      expect(panel.left, closeTo(0, 1));

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(_liveOverlaySheet(), findsNothing);
    });

    testWidgets('flips between light and dark with one live controller', (
      WidgetTester tester,
    ) async {
      final ElThemeController controller = await _pumpSheetDoc(tester);
      expect(tester.takeException(), isNull);

      controller.setMode(ElThemeMode.light);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byType(SheetDocPage), findsOneWidget);
    });

    testWidgets(
      'tapping a previous/next link calls onNavigate without throwing',
      (WidgetTester tester) async {
        String? destination;
        await _pumpSheetDoc(
          tester,
          onNavigate: (String route) => destination = route,
        );

        final Finder link = find.byKey(
          const ValueKey<String>('docs-layout-prev-next'),
        );
        await tester.ensureVisible(link);
        final Finder dialogLink = find.text('Dialog').first;
        await tester.ensureVisible(dialogLink);
        await tester.tap(dialogLink);
        expect(destination, isNotNull);
      },
    );
  });
}
