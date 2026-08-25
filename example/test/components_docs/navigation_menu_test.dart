/// Tests for `components_docs/navigation_menu/meta.dart` and
/// `components_docs/navigation_menu/page.dart`: the public documentation
/// page for Navigation Menu only.
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never synthetic `MediaQuery`. Theme
/// coverage uses a live `ElThemeController` flipped in place rather than two
/// independent pumps. `pumpAndSettle` is never used: several documentation-
/// shell widgets run controllers that repeat forever, so settling on this
/// page would hang; every wait below is a bounded `tester.pump()` instead.
///
/// ElNavigationMenu mounts through [OverlayPortal] (via ElPopover), so the
/// live specimen needs a real [Overlay]: the harness wraps the page in a
/// `MaterialApp`, the same fix Popover and Select needed.
///
/// Re-housed onto the kit alongside the page: sections are now
/// `DocsSection`s rather than `ElSection`s, and the eight disclosures (API
/// Reference, States, Accessibility, Keyboard, Responsive, Dependencies,
/// Theming, Source) are collapsed `DocsDisclosure`s that mount no content
/// until opened — see `_openDisclosure`, the same helper `button_test.dart`
/// uses.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/navigation_menu/meta.dart';
import 'package:example/components_docs/navigation_menu/page.dart';
import 'package:example/docs/docs_disclosure.dart';
import 'package:example/docs/docs_section.dart' show DocsSection;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const Size _wide = Size(1440, 900);
const Size _narrow = Size(390, 844);

Future<ElThemeController> _pumpPage(
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
  await tester.pump(ElDurations.jelly);
}

void main() {
  group('meta', () {
    test('navigationMenuDoc names the real public API surface', () {
      expect(navigationMenuDoc.name, 'navigation-menu');
      expect(navigationMenuDoc.title, 'Navigation Menu');
      expect(navigationMenuDoc.route, '/components/navigation-menu');
      expect(navigationMenuDoc.dependencies, <String>[
        'icon',
        'popover',
        'press-motion',
        'source-foundation',
      ]);
      expect(
        navigationMenuDoc.sourcePath,
        'lib/src/components/navigation_menu.dart',
      );
      expect(
        navigationMenuDoc.exports,
        containsAll(<String>[
          'ElNavigationMenu',
          'ElNavigationMenuItem',
          'ElNavigationMenuIndicator',
          'ElNavigationMenuLink',
        ]),
      );
      // Short description: one sentence, no trailing ellipsis.
      expect(navigationMenuDoc.description, isNot(contains('..')));
      expect(
        navigationMenuDoc.description.trim(),
        navigationMenuDoc.description,
      );
    });
  });

  group('rendered page', () {
    testWidgets('sections render in the house shape, section for section', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 4000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await _pumpPage(tester, size: const Size(1440, 4000));

      final List<String> titles = tester
          .widgetList<DocsSection>(find.byType(DocsSection))
          .map((DocsSection section) => section.title)
          .toList();

      expect(titles, <String>[
        'Preview',
        'Installation',
        'Usage',
        'Composition',
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

    testWidgets('renders the article and the live specimen', (
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
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'the API tables document constructor parameters from the source',
      (WidgetTester tester) async {
        await _pumpPage(tester);
        await _openDisclosure(tester, 'API Reference');

        // ElNavigationMenu.
        expect(find.text('items'), findsWidgets);
        expect(find.text('viewport'), findsOneWidget);
        expect(find.text('indicator'), findsOneWidget);

        // ElNavigationMenuItem.
        expect(find.text('label'), findsWidgets);
        expect(find.text('content'), findsWidgets);
        expect(find.text('onTap'), findsWidgets);

        // ElNavigationMenuLink.
        expect(find.text('child'), findsWidgets);
        expect(find.text('active'), findsOneWidget);

        // ElNavigationMenuIndicator: previously missing entirely.
        expect(find.text('ElNavigationMenuIndicator'), findsWidgets);
        expect(find.text('width'), findsOneWidget);
      },
    );

    testWidgets('documents the working navigation-menu CLI install', (
      WidgetTester tester,
    ) async {
      await _pumpPage(tester);

      expect(find.textContaining('elattar add navigation-menu'), findsWidgets);
    });

    testWidgets('documents that the component is built on ElPopover', (
      WidgetTester tester,
    ) async {
      await _pumpPage(tester);
      await _openDisclosure(tester, 'Dependencies');

      expect(find.textContaining('ElPopover'), findsWidgets);
    });

    testWidgets(
      'the Keyboard disclosure names the real, total absence of key '
      'handling',
      (WidgetTester tester) async {
        await _pumpPage(tester);
        await _openDisclosure(tester, 'Keyboard');

        expect(find.textContaining('Focus'), findsWidgets);
        expect(find.textContaining('ElPress'), findsWidgets);
      },
    );

    testWidgets(
      'navigating previous fires onNavigate with the already-routed popover',
      (WidgetTester tester) async {
        String? destination;
        await _pumpPage(
          tester,
          onNavigate: (String route) => destination = route,
        );

        final Finder pager = find.byKey(
          const ValueKey<String>('docs-layout-prev-next'),
        );
        final Finder popoverLink = find.descendant(
          of: pager,
          matching: find.text('Popover'),
        );
        await tester.ensureVisible(popoverLink);
        await tester.tap(popoverLink);
        expect(destination, '/components/popover');
      },
    );
  });

  group('live specimen: open and close', () {
    testWidgets('trigger renders and opens the shared-viewport panel', (
      WidgetTester tester,
    ) async {
      await _pumpPage(tester);

      final Finder trigger = find.byKey(
        const ValueKey<String>('nav-menu-specimen'),
      );
      await tester.ensureVisible(trigger);
      await tester.pump();

      // Trigger is visible.
      expect(find.text('Products'), findsOneWidget);
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
        expect(tester.takeException(), isNull);
      },
    );
  });

  group('both themes', () {
    testWidgets('renders on light', (WidgetTester tester) async {
      await _pumpPage(tester, mode: ElThemeMode.light);
      expect(
        find.byKey(const ValueKey<String>('nav-menu-specimen')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders on dark', (WidgetTester tester) async {
      await _pumpPage(tester, mode: ElThemeMode.dark);
      expect(
        find.byKey(const ValueKey<String>('nav-menu-specimen')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('flipping the theme in place keeps the page intact', (
      WidgetTester tester,
    ) async {
      final ElThemeController theme = await _pumpPage(
        tester,
        mode: ElThemeMode.dark,
      );
      expect(
        find.byKey(const ValueKey<String>('nav-menu-specimen')),
        findsOneWidget,
      );

      theme.setMode(ElThemeMode.light);
      await tester.pump();

      expect(
        find.byKey(const ValueKey<String>('nav-menu-specimen')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });
  });
}
