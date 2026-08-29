/// Tests for `components_docs/sheet/meta.dart` and
/// `components_docs/sheet/page.dart`: the public Sheet component
/// documentation page.
///
/// Split from a former combined sheet+drawer test file: this file covers
/// `SheetDocPage` alone. Drawer's own coverage lives in `drawer_test.dart`.
///
/// Re-housed onto `ComponentDocSpec`/`ComponentDocPage`, the same shape
/// `button_test.dart` and `alert_dialog_test.dart` assert against: sections
/// read through `DocsSection.title`/`DocsAnchor.keyFor`, and the API table
/// (now inside a `DocsDisclosure`, closed by default) is opened before its
/// rows are read.
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never a synthetic `MediaQuery`. Theme
/// coverage flips a single live `ThemeController` in place.
///
/// `SheetOverlay` mounts its content through an `OverlayPortal`, so the
/// live specimen needs a real `Overlay`: the harness wraps the page in a
/// `MaterialApp`. No `pumpAndSettle` is used anywhere on this page: every
/// open/close/disclosure step below advances with an explicit
/// `pump()`/`pump(duration)` pair instead.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/sheet/meta.dart';
import 'package:example/components_docs/sheet/page.dart';
import 'package:example/docs/docs_disclosure.dart';
import 'package:example/docs/docs_section.dart' show DocsAnchor, DocsSection;
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

const Size _wide = Size(1440, 900);
const Size _narrow = Size(390, 844);

const List<String> _sectionOrder = <String>[
  'Preview',
  'Installation',
  'Usage',
  'Composition',
  'Side',
  'No close button',
  'RTL',
  'API Reference',
  'States',
  'Accessibility',
  'Keyboard',
  'Responsive',
  'Dependencies',
  'Theming',
  'Source',
];

/// Every constructor parameter name declared on the public classes of
/// `lib/src/components/ui/sheet.dart`.
const List<String> _sheetParamNames = <String>[
  'builder', // Sheet.showLeft
  'width', // SheetPanel / SheetContent
  'showCloseButton', // SheetPanel / SheetContent
  'child', // SheetPanel / SheetTransition / SheetContentGroup
  'trigger', // SheetOverlay
  'content', // SheetOverlay
  'side', // SheetOverlay / SheetTransition / SheetContent
  'animation', // SheetTransition
  'children', // SheetContent / SheetHeader / SheetFooter
  'onClose', // SheetContent
  'fill', // SheetContent
  'text', // SheetTitle / SheetDescription
];

/// Matches only a [SheetContent] mounted by a live [SheetOverlay]
/// trigger: the page also keeps two static, always-mounted [SheetContent]
/// specimens on screen (the No close button and RTL sections' own
/// presentational panels, keyed `sheet-no-close-button` and `sheet-rtl`), so
/// `find.byType(SheetContent)` alone is never unique on this page.
Finder _liveOverlaySheet() => find.byWidgetPredicate(
  (Widget widget) =>
      widget is SheetContent &&
      widget.key != const ValueKey<String>('sheet-no-close-button') &&
      widget.key != const ValueKey<String>('sheet-rtl'),
);

Finder _disclosureTrigger(String title) => find.descendant(
  of: find.byWidgetPredicate(
    (Widget widget) => widget is DocsDisclosure && widget.title == title,
  ),
  matching: find.byKey(DocsDisclosure.triggerKey),
);

Future<ThemeController> _pumpSheetDoc(
  WidgetTester tester, {
  ValueChanged<String>? onNavigate,
  Size size = _wide,
  ColorMode mode = ColorMode.dark,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final ThemeController theme = ThemeController(mode: mode);
  addTearDown(theme.dispose);

  await tester.pumpWidget(
    ThemeScope(
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
      expect(sheetDoc.sourcePath, 'lib/src/components/ui/sheet.dart');
      expect(sheetDoc.description, isNotEmpty);
      expect(sheetDoc.description, isNot(contains('..')));
      expect(sheetDoc.description.trim(), sheetDoc.description);
      expect(
        sheetDoc.exports,
        containsAll(<String>[
          'Sheet',
          'SheetPanel',
          'SheetSide',
          'SheetOverlay',
          'SheetTransition',
          'SheetContent',
          'SheetContentGroup',
          'SheetHeader',
          'SheetFooter',
          'SheetTitle',
          'SheetDescription',
        ]),
      );
      // No drawer symbols on this page's export list any more.
      expect(sheetDoc.exports, isNot(contains('Drawer')));
    });
  });

  group('SheetDocPage house shape', () {
    testWidgets('renders every section, in order', (WidgetTester tester) async {
      await _pumpSheetDoc(tester, size: const Size(1440, 4000));

      final List<String> titles = tester
          .widgetList<DocsSection>(find.byType(DocsSection))
          .map((DocsSection section) => section.title)
          .toList();

      expect(titles, _sectionOrder);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'No close button and RTL sections each mount their own live specimen',
      (WidgetTester tester) async {
        await _pumpSheetDoc(tester, size: const Size(1440, 4000));

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
          tester.widget<SheetContent>(noCloseSpecimen).showCloseButton,
          isFalse,
        );
        expect(
          find.descendant(
            of: find.byKey(DocsAnchor.keyFor('no-close-button')),
            matching: find.byType(Button),
          ),
          findsNothing,
        );

        final Finder rtlSpecimen = find.byKey(
          const ValueKey<String>('sheet-rtl'),
        );
        expect(rtlSpecimen, findsOneWidget);
        expect(
          find.descendant(
            of: find.byKey(DocsAnchor.keyFor('rtl')),
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
        await _pumpSheetDoc(tester, size: const Size(1440, 4000));

        expect(
          find.byKey(const ValueKey<String>('sheet-doc-article')),
          findsOneWidget,
        );
        expect(find.textContaining('Sheet'), findsWidgets);

        final Finder apiTrigger = _disclosureTrigger('API Reference');
        await tester.ensureVisible(apiTrigger);
        await tester.pump();
        await tester.tap(apiTrigger);
        await tester.pump();
        await tester.pump(MotionDurations.open);

        for (final String param in _sheetParamNames) {
          expect(
            find.text(param),
            findsAtLeastNWidgets(1),
            reason: 'Parameter "$param" missing from an API table',
          );
        }

        // SheetSide's four values, plus the isHorizontal getter row.
        for (final String value in <String>['top', 'right', 'bottom', 'left']) {
          expect(
            find.text(value),
            findsAtLeastNWidgets(1),
            reason: 'SheetSide.$value missing from the API table',
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

      // The manual copy target only renders once the Manual tab is
      // selected: DocsInstall defaults to the CLI tab.
      final Finder manualTab = find.text('Manual');
      await tester.ensureVisible(manualTab);
      await tester.tap(manualTab);
      await tester.pump();

      expect(find.textContaining('lib/components/ui/sheet.dart'), findsWidgets);
    });

    testWidgets(
      'drops the sidebar and shows the anchor strip at mobile width',
      (WidgetTester tester) async {
        await _pumpSheetDoc(tester, size: _narrow, mode: ColorMode.light);

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
      'a live SheetOverlay opens a real SheetContent and dismisses on '
      'scrim tap',
      (WidgetTester tester) async {
        await _pumpSheetDoc(tester);

        expect(_liveOverlaySheet(), findsNothing);
        final Finder trigger = find.byKey(
          const ValueKey<String>('sheet-preview:right'),
        );
        await tester.ensureVisible(trigger);
        await tester.tap(trigger);
        await tester.pump();
        await tester.pump(MotionDurations.overlayEnter);
        await tester.pump();

        expect(_liveOverlaySheet(), findsOneWidget);
        expect(find.text('Notification settings'), findsOneWidget);
        final Rect panel = tester.getRect(_liveOverlaySheet());
        // side: right, pinned to the trailing edge of a 1440-wide viewport.
        expect(panel.right, closeTo(1440, 1));

        // Tap the scrim, well clear of the right-hand panel, to dismiss.
        await tester.tapAt(const Offset(20, 20));
        await tester.pump();
        for (int i = 0; i < 8; i++) {
          await tester.pump(const Duration(milliseconds: 50));
        }
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
      await tester.pump();
      await tester.pump(MotionDurations.overlayEnter);
      await tester.pump();
      expect(_liveOverlaySheet(), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();
      for (int i = 0; i < 8; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
      expect(_liveOverlaySheet(), findsNothing);
    });

    testWidgets('the Side section mounts its own independent set of triggers', (
      WidgetTester tester,
    ) async {
      await _pumpSheetDoc(tester, size: const Size(1440, 4000));

      final Finder sectionTrigger = find.byKey(
        const ValueKey<String>('sheet-example-side:left'),
      );
      await tester.ensureVisible(sectionTrigger);
      await tester.tap(sectionTrigger);
      await tester.pump();
      await tester.pump(MotionDurations.overlayEnter);
      await tester.pump();

      expect(_liveOverlaySheet(), findsOneWidget);
      final Rect panel = tester.getRect(_liveOverlaySheet());
      expect(panel.left, closeTo(0, 1));

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();
      for (int i = 0; i < 8; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
      expect(_liveOverlaySheet(), findsNothing);
    });

    testWidgets('flips between light and dark with one live controller', (
      WidgetTester tester,
    ) async {
      final ThemeController controller = await _pumpSheetDoc(tester);
      expect(tester.takeException(), isNull);

      controller.setMode(ColorMode.light);
      await tester.pump();
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
