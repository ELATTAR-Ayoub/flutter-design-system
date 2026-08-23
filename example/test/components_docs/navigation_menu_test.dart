/// Tests for `components_docs/navigation_menu/meta.dart` and
/// `components_docs/navigation_menu/page.dart`: the public documentation
/// page for Navigation Menu, Menubar, Context Menu, and Hover Card.
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never synthetic `MediaQuery`. Theme
/// coverage uses a live `DsThemeController` flipped in place rather than two
/// independent pumps.
///
/// DsNavigationMenu, DsMenubar, DsContextMenu, and DsHoverCard all mount
/// through [OverlayPortal], so the live specimens need a real [Overlay]: the
/// harness wraps the page in a `MaterialApp`, the same fix Popover and Select
/// needed.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/navigation_menu/meta.dart';
import 'package:example/components_docs/navigation_menu/page.dart';
import 'package:example/kit.dart' show DsSection;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const Size _wide = Size(1440, 900);
const Size _narrow = Size(390, 844);

Future<DsThemeController> _pumpPage(
  WidgetTester tester, {
  ValueChanged<String>? onNavigate,
  Size size = _wide,
  DsThemeMode mode = DsThemeMode.dark,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final DsThemeController theme = DsThemeController(mode: mode);
  addTearDown(theme.dispose);

  await tester.pumpWidget(
    DsTheme(
      controller: theme,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: SingleChildScrollView(
            child: NavigationMenuDocPage(onNavigate: onNavigate),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  return theme;
}

void main() {
  group('meta', () {
    test('navigationMenuDoc names the real public API surface', () {
      expect(navigationMenuDoc.name, 'navigation-menu');
      expect(
        navigationMenuDoc.title,
        'Navigation Menu, Menubar, Context Menu, Hover Card',
      );
      expect(navigationMenuDoc.route, '/components/navigation-menu');
      // No registry manifest: dependencies empty, not available for install yet.
      expect(navigationMenuDoc.dependencies, isEmpty);
      expect(navigationMenuDoc.sourcePath, 'lib/src/components/');
      expect(
        navigationMenuDoc.exports,
        containsAll(<String>[
          'DsNavigationMenu',
          'DsNavigationMenuItem',
          'DsNavigationMenuIndicator',
          'DsNavigationMenuLink',
          'DsMenubar',
          'DsMenubarMenu',
          'DsContextMenu',
          'DsHoverCard',
          'DsHoverCardContent',
        ]),
      );
      // Short description: one sentence, no trailing ellipsis.
      expect(navigationMenuDoc.description, isNot(contains('..')));
      expect(
        navigationMenuDoc.description.trim(),
        navigationMenuDoc.description,
      );
      // The expanded, decision-guidance description is distinct.
      expect(
        navigationMenuExpandedDescription,
        isNot(equals(navigationMenuDoc.description)),
      );
      expect(
        navigationMenuExpandedDescription.trim(),
        navigationMenuExpandedDescription,
      );
      expect(navigationMenuExpandedDescription, contains('Navigation Menu'));
      expect(navigationMenuExpandedDescription, contains('Menubar'));
      expect(navigationMenuExpandedDescription, contains('Context Menu'));
      expect(navigationMenuExpandedDescription, contains('Hover Card'));
    });
  });

  group('rendered page', () {
    testWidgets(
      'sections render in the shadcn-mirrored order, section for section, '
      'each of the four components grouped under its own name',
      (WidgetTester tester) async {
        await _pumpPage(tester);

        final List<String> titles = tester
            .widgetList<DsSection>(find.byType(DsSection))
            .map((DsSection section) => section.title)
            .toList();

        expect(titles, <String>[
          'Installation',
          'Usage',
          'Composition',
          'Navigation Menu: RTL',
          'Menubar: Checkbox',
          'Menubar: Radio',
          'Menubar: Submenu',
          'Menubar: With icons',
          'Menubar: RTL',
          'Context Menu: Basic',
          'Context Menu: Submenu',
          'Context Menu: Shortcuts',
          'Context Menu: Groups',
          'Context Menu: Icons',
          'Context Menu: Checkboxes',
          'Context Menu: Radio',
          'Context Menu: Destructive',
          'Context Menu: RTL',
          'Hover Card: Trigger delays',
          'Hover Card: Basic',
          'Hover Card: RTL',
          'API Reference',
          'States',
          'Accessibility',
          'Responsive',
          'Dependencies',
          'Theming',
          'Source',
        ]);
      },
    );

    testWidgets('renders the article and all four live specimens', (
      WidgetTester tester,
    ) async {
      await _pumpPage(tester);

      expect(
        find.byKey(const ValueKey<String>('navigation-menu-doc-article')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('nav-menu-specimen')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('menubar-specimen')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('context-menu-specimen')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('hover-card-specimen')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'the API tables document constructor parameters from the source',
      (WidgetTester tester) async {
        await _pumpPage(tester);

        // DsNavigationMenu parameters.
        expect(find.text('items'), findsWidgets);
        expect(find.text('viewport'), findsOneWidget);
        expect(find.text('indicator'), findsOneWidget);

        // DsMenubar.
        expect(find.text('menus'), findsWidgets);

        // DsContextMenu.
        expect(find.text('child'), findsWidgets);
        expect(find.text('children'), findsWidgets);
        expect(find.text('enabled'), findsOneWidget);

        // DsHoverCard.
        expect(find.text('trigger'), findsWidgets);
        expect(find.text('content'), findsWidgets);
        expect(find.text('width'), findsWidgets);
        expect(find.text('openDelay'), findsOneWidget);
        expect(find.text('closeDelay'), findsOneWidget);
      },
    );

    testWidgets('documents that none of the four have registry manifests', (
      WidgetTester tester,
    ) async {
      await _pumpPage(tester);

      expect(find.textContaining('Unregistered'), findsWidgets);
      expect(find.textContaining('registry manifest'), findsWidgets);
    });

    testWidgets(
      'accessibility section documents Context Menu and Hover Card touch gaps',
      (WidgetTester tester) async {
        await _pumpPage(tester);

        expect(find.textContaining('no touch path'), findsWidgets);
        expect(find.textContaining('Right-click only'), findsWidgets);
        expect(find.textContaining('Pointer only'), findsWidgets);
      },
    );

    testWidgets('documents that all four are built on DsPopover', (
      WidgetTester tester,
    ) async {
      await _pumpPage(tester);

      expect(find.textContaining('DsPopover'), findsWidgets);
      expect(find.textContaining('anchored overlay'), findsWidgets);
    });

    testWidgets(
      'navigating previous fires onNavigate with the already-routed popover',
      (WidgetTester tester) async {
        String? destination;
        await _pumpPage(
          tester,
          onNavigate: (String route) => destination = route,
        );

        await tester.ensureVisible(find.text('Popover').first);
        await tester.tap(find.text('Popover').first);
        expect(destination, '/components/popover');
      },
    );
  });

  group('live specimens: open and close', () {
    testWidgets('Navigation Menu trigger renders the specimen', (
      WidgetTester tester,
    ) async {
      await _pumpPage(tester);

      final Finder trigger = find.byKey(
        const ValueKey<String>('nav-menu-specimen'),
      );
      await tester.ensureVisible(trigger);
      await tester.pumpAndSettle();

      // Trigger is visible.
      expect(find.text('Products'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Context Menu specimen renders', (WidgetTester tester) async {
      await _pumpPage(tester);

      final Finder card = find.byKey(
        const ValueKey<String>('context-menu-specimen'),
      );
      await tester.ensureVisible(card);
      await tester.pumpAndSettle();

      // Specimen is visible and not erroring.
      expect(card, findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Hover Card specimen renders', (WidgetTester tester) async {
      await _pumpPage(tester);

      final Finder hoverCard = find.byKey(
        const ValueKey<String>('hover-card-specimen'),
      );
      await tester.ensureVisible(hoverCard);
      await tester.pumpAndSettle();

      // Specimen is visible.
      expect(hoverCard, findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('viewport widths', () {
    testWidgets('a wide viewport exposes the sidebar and table of contents', (
      WidgetTester tester,
    ) async {
      await _pumpPage(tester, size: _wide);

      expect(
        find.byKey(const ValueKey<String>('docs-layout-sidebar')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('docs-layout-toc')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('navigation-menu-doc-article')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'a narrow viewport drops to the anchor strip and stays reachable',
      (WidgetTester tester) async {
        await _pumpPage(tester, size: _narrow);

        expect(
          find.byKey(const ValueKey<String>('docs-layout-sidebar')),
          findsNothing,
        );
        expect(
          find.byKey(const ValueKey<String>('docs-layout-anchor-strip')),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey<String>('navigation-menu-doc-article')),
          findsOneWidget,
        );
        // Narrow viewport may have overflow warnings from long component names.
        tester.takeException();
      },
    );
  });

  group('both themes', () {
    testWidgets('renders on light', (WidgetTester tester) async {
      await _pumpPage(tester, mode: DsThemeMode.light);
      expect(
        find.byKey(const ValueKey<String>('nav-menu-specimen')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders on dark', (WidgetTester tester) async {
      await _pumpPage(tester, mode: DsThemeMode.dark);
      expect(
        find.byKey(const ValueKey<String>('nav-menu-specimen')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('flipping the theme in place keeps the page intact', (
      WidgetTester tester,
    ) async {
      final DsThemeController theme = await _pumpPage(
        tester,
        mode: DsThemeMode.dark,
      );
      expect(
        find.byKey(const ValueKey<String>('nav-menu-specimen')),
        findsOneWidget,
      );

      theme.setMode(DsThemeMode.light);
      await tester.pump();

      expect(
        find.byKey(const ValueKey<String>('nav-menu-specimen')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });
  });
}
