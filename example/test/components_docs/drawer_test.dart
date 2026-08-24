/// Tests for `components_docs/drawer/meta.dart` and
/// `components_docs/drawer/page.dart`: the public Drawer component
/// documentation page.
///
/// Split out of a former combined sheet+drawer test file: this file covers
/// `DrawerDocPage` alone. Sheet's own coverage lives in `sheet_test.dart`.
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never a synthetic `MediaQuery`. Theme
/// coverage flips a single live `ElThemeController` in place.
///
/// `ElDrawer` mounts its content through an `OverlayPortal`, so the live
/// specimen needs a real `Overlay`: the harness wraps the page in a
/// `MaterialApp`. Its open/close transition is a single forward-then-reverse
/// run on `ElDurations.drawer`, not a loop, so `pumpAndSettle` is safe —
/// the same discipline the former combined `sheet_test.dart` established for
/// this exact widget.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/drawer/meta.dart';
import 'package:example/components_docs/drawer/page.dart';
import 'package:example/kit.dart' show ElSection;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const Size _wide = Size(1440, 900);
const Size _narrow = Size(390, 844);

/// The shadcn-parity section order this page must render, matching
/// https://ui.shadcn.com/docs/components/base/drawer's own `<h2>` list
/// (narrowed to what this port actually has — see the SKIPPED panel inside
/// Sizing for the rest) plus this corpus's fixed six extras.
const List<String> _sectionOrder = <String>[
  'install',
  'usage',
  'composition',
  'sizing',
  'api',
  'states',
  'accessibility',
  'responsive',
  'dependencies',
  'theming',
  'source',
];

/// Every constructor parameter name declared on the public classes of
/// `lib/src/components/drawer.dart`. [ElDrawerHandle] takes no constructor
/// parameters of its own.
const List<String> _drawerParamNames = <String>[
  'trigger', // ElDrawer
  'content', // ElDrawer
  'children', // ElDrawerContent / ElDrawerHeader / ElDrawerFooter
  'text', // ElDrawerTitle / ElDrawerDescription
];

Future<ElThemeController> _pumpDrawerDoc(
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
          child: DrawerDocPage(onNavigate: onNavigate),
        ),
      ),
    ),
  );
  await tester.pump();
  return theme;
}

void main() {
  group('meta', () {
    test('drawerDoc names the real public API surface', () {
      expect(drawerDoc.name, 'drawer');
      expect(drawerDoc.title, 'Drawer');
      expect(drawerDoc.route, '/components/drawer');
      expect(drawerDoc.sourcePath, 'lib/src/components/drawer.dart');
      expect(drawerDoc.description, isNotEmpty);
      expect(drawerDoc.description, isNot(contains('..')));
      expect(drawerDoc.description.trim(), drawerDoc.description);
      expect(
        drawerDoc.exports,
        containsAll(<String>[
          'ElDrawer',
          'ElDrawerContent',
          'ElDrawerHandle',
          'ElDrawerHeader',
          'ElDrawerFooter',
          'ElDrawerTitle',
          'ElDrawerDescription',
        ]),
      );
      // No sheet symbols on this page's export list.
      expect(drawerDoc.exports, isNot(contains('ElSheetOverlay')));
      expect(drawerDoc.dependencies, <String>['dialog', 'source-foundation']);
    });
  });

  group('DrawerDocPage shadcn-parity section order', () {
    testWidgets('renders every shadcn-parity section, in order', (
      WidgetTester tester,
    ) async {
      await _pumpDrawerDoc(tester, size: const Size(1440, 3200));

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

    testWidgets('Sizing carries the consolidated, honest SKIPPED note', (
      WidgetTester tester,
    ) async {
      await _pumpDrawerDoc(tester, size: const Size(1440, 3200));

      expect(
        find.descendant(
          of: find.byKey(ElSection.anchorKey('sizing')),
          matching: find.textContaining('SKIPPED'),
        ),
        findsWidgets,
      );
      expect(tester.takeException(), isNull);
    });
  });

  group('DrawerDocPage', () {
    testWidgets(
      'renders the article with every documented constructor parameter',
      (WidgetTester tester) async {
        await _pumpDrawerDoc(tester);

        expect(
          find.byKey(const ValueKey<String>('drawer-doc-article')),
          findsOneWidget,
        );
        expect(find.textContaining('Drawer'), findsWidgets);

        for (final String param in _drawerParamNames) {
          expect(
            find.text(param),
            findsAtLeastNWidgets(1),
            reason: 'Parameter "$param" missing from an API table',
          );
        }

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
      await _pumpDrawerDoc(tester);

      expect(find.textContaining('elattar add drawer'), findsWidgets);
      expect(find.textContaining('source-foundation'), findsWidgets);
      expect(
        find.textContaining('lib/components/ui/drawer.dart'),
        findsWidgets,
      );
    });

    testWidgets(
      'drops the sidebar and shows the anchor strip at mobile width',
      (WidgetTester tester) async {
        await _pumpDrawerDoc(tester, size: _narrow, mode: ElThemeMode.light);

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
      'a live ElDrawer opens full-bleed at the bottom, drags past the '
      'close threshold, and dismisses',
      (WidgetTester tester) async {
        await _pumpDrawerDoc(tester);

        final Finder trigger = find.byKey(
          const ValueKey<String>('drawer-preview-trigger'),
        );
        await tester.ensureVisible(trigger);
        await tester.tap(trigger);
        await tester.pumpAndSettle();

        expect(find.byType(ElDrawerContent), findsOneWidget);
        expect(find.text('Card actions'), findsOneWidget);
        final Rect panel = tester.getRect(find.byType(ElDrawerContent));
        expect(panel.width, 1440);
        expect(panel.bottom, closeTo(900, 1));
        // The grip handle is part of the anatomy, unconditionally.
        expect(find.byType(ElDrawerHandle), findsOneWidget);

        // Past vaul's own 0.25-of-height close threshold, the drawer
        // unmounts.
        final TestGesture drag = await tester.startGesture(
          panel.topCenter + const Offset(0, 8),
        );
        await tester.pump();
        await drag.moveBy(Offset(0, panel.height * 0.6));
        await tester.pump();
        await drag.up();
        await tester.pump();
        // Not a single tester.pump(ElDurations.drawer): the reverse
        // AnimationController reaches value 0 within that frame, but its
        // whenComplete callback (which hides the portal) needs one more
        // pump to actually flush the OverlayPortal's removal from the
        // tree. pumpAndSettle is safe here: this is a bounded exit
        // animation, not a loop.
        await tester.pumpAndSettle();
        expect(find.byType(ElDrawerContent), findsNothing);
      },
    );

    testWidgets('a drag short of the threshold releases the drawer back open', (
      WidgetTester tester,
    ) async {
      await _pumpDrawerDoc(tester);

      final Finder trigger = find.byKey(
        const ValueKey<String>('drawer-preview-trigger'),
      );
      await tester.ensureVisible(trigger);
      await tester.tap(trigger);
      await tester.pumpAndSettle();

      final Rect panel = tester.getRect(find.byType(ElDrawerContent));
      final TestGesture drag = await tester.startGesture(
        panel.topCenter + const Offset(0, 8),
      );
      await tester.pump();
      await drag.moveBy(Offset(0, panel.height * 0.1));
      await tester.pump();
      await drag.up();
      await tester.pumpAndSettle();
      expect(find.byType(ElDrawerContent), findsOneWidget);
    });

    testWidgets('Escape dismisses an open drawer', (WidgetTester tester) async {
      await _pumpDrawerDoc(tester);

      final Finder trigger = find.byKey(
        const ValueKey<String>('drawer-preview-trigger'),
      );
      await tester.ensureVisible(trigger);
      await tester.tap(trigger);
      await tester.pumpAndSettle();
      expect(find.byType(ElDrawerContent), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.byType(ElDrawerContent), findsNothing);
    });

    testWidgets('flips between light and dark with one live controller', (
      WidgetTester tester,
    ) async {
      final ElThemeController controller = await _pumpDrawerDoc(tester);
      expect(tester.takeException(), isNull);

      controller.setMode(ElThemeMode.light);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byType(DrawerDocPage), findsOneWidget);
    });

    testWidgets(
      'tapping a previous/next link calls onNavigate without throwing',
      (WidgetTester tester) async {
        String? destination;
        await _pumpDrawerDoc(
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
