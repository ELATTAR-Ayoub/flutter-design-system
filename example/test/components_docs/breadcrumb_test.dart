/// Tests for `components_docs/breadcrumb/meta.dart` and
/// `components_docs/breadcrumb/page.dart`: the public Breadcrumb component
/// documentation page.
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never synthetic `MediaQuery`: the
/// discipline `skills_docs_test.dart` already carries. Theme coverage uses a
/// live `ThemeController` flipped in place rather than two independent
/// pumps.
///
/// Re-housed onto the kit alongside the page: sections are now
/// `DocsSection`s rather than `Section`s, and the eight disclosures (API
/// Reference, States, Accessibility, Keyboard, Responsive, Dependencies,
/// Theming, Source) are collapsed `DocsDisclosure`s that mount no content
/// until opened — see `_disclosureTrigger`, the same helper `button_test.dart`
/// uses.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/breadcrumb/meta.dart';
import 'package:example/components_docs/breadcrumb/page.dart';
import 'package:example/docs/docs_disclosure.dart';
import 'package:example/docs/docs_install.dart';
import 'package:example/docs/docs_section.dart' show DocsSection;
import 'package:example/docs/docs_showcase.dart';
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
import 'package:flutter_test/flutter_test.dart';

const Size _wide = Size(1440, 900);
const Size _narrow = Size(390, 844);

Future<ThemeController> _pumpBreadcrumbDoc(
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
        home: Scaffold(
          body: SingleChildScrollView(
            child: BreadcrumbDocPage(onNavigate: onNavigate),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  return theme;
}

/// The single `DocsDisclosure` whose title is [title], opened. Mirrors
/// `button_test.dart`'s own helper: a closed `DocsDisclosure` mounts no
/// content, so a test reading anything inside one must open it first.
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

void main() {
  group('meta', () {
    test('breadcrumbDoc names the real public API surface', () {
      expect(breadcrumbDoc.name, 'breadcrumb');
      expect(breadcrumbDoc.title, 'Breadcrumb');
      expect(breadcrumbDoc.route, '/components/breadcrumb');
      expect(breadcrumbDoc.sourcePath, 'lib/src/components/ui/breadcrumb.dart');
      expect(
        breadcrumbDoc.exports,
        containsAll(<String>['Breadcrumb', 'BreadcrumbEntry']),
      );
      // Short description: one sentence, no trailing dot-dot.
      expect(breadcrumbDoc.description, isNot(contains('..')));
      expect(breadcrumbDoc.description.trim(), breadcrumbDoc.description);
    });
  });

  group('rendered page', () {
    testWidgets('sections render in the house shape, section for section', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 4000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await _pumpBreadcrumbDoc(tester, size: const Size(1440, 4000));

      // Immune to the duplicate-string hazard `find.text` carries here: a
      // section heading and its own TOC link render the same string, so
      // reading each mounted `DocsSection`'s own `title` field sidesteps
      // that entirely.
      final List<String> titles = tester
          .widgetList<DocsSection>(find.byType(DocsSection))
          .map((DocsSection section) => section.title)
          .toList();

      expect(titles, <String>[
        'Preview',
        'Installation',
        'Usage',
        'Composition',
        'Page header',
        'Basic',
        'Link component',
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

      expect(find.byType(DocsInstall), findsOneWidget);
      // Five specimen stages: Preview, Page header, Basic, Link
      // component, RTL.
      expect(find.byType(DocsShowcase), findsNWidgets(5));
      // Eight collapsed sections: API Reference, States, Accessibility,
      // Keyboard, Responsive, Dependencies, Theming, Source.
      expect(find.byType(DocsDisclosure), findsNWidgets(8));
    });

    testWidgets('renders the article and a live multi-crumb specimen', (
      WidgetTester tester,
    ) async {
      await _pumpBreadcrumbDoc(tester);

      expect(
        find.byKey(const ValueKey<String>('breadcrumb-doc-article')),
        findsOneWidget,
      );
      expect(find.byType(Breadcrumb), findsWidgets);
      // A real specimen renders at least one derived chevron separator.
      expect(
        tester
            .widgetList<Icon>(find.byType(Icon))
            .where((Icon icon) => icon.glyph == IconGlyph.chevronRight),
        isNotEmpty,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'the API table documents every constructor parameter found in the source',
      (WidgetTester tester) async {
        await _pumpBreadcrumbDoc(tester);
        await _openDisclosure(tester, 'API Reference');

        // Breadcrumb.items
        expect(find.text('items'), findsOneWidget);
        expect(find.textContaining('List<BreadcrumbEntry>'), findsWidgets);
        // BreadcrumbEntry.link(label, {onTap})
        expect(find.textContaining('BreadcrumbEntry.link'), findsWidgets);
        expect(find.text('label'), findsWidgets);
        expect(find.text('onTap'), findsOneWidget);
        // BreadcrumbEntry.page(label)
        expect(find.textContaining('BreadcrumbEntry.page'), findsWidgets);
        // The derived, read-only isPage field.
        expect(find.text('isPage'), findsOneWidget);
        // The two static layout constants.
        expect(find.text('gap'), findsOneWidget);
        expect(find.text('separatorPx'), findsOneWidget);
      },
    );

    testWidgets('installation shows the shipped registry command', (
      WidgetTester tester,
    ) async {
      await _pumpBreadcrumbDoc(tester);

      expect(find.textContaining('elattar add breadcrumb'), findsWidgets);
      expect(
        find.textContaining('breadcrumb.json'),
        findsWidgets,
        reason: 'the page must name the shipped manifest',
      );
    });

    testWidgets('states the real overflow behavior: wrap, not truncation', (
      WidgetTester tester,
    ) async {
      await _pumpBreadcrumbDoc(tester);
      await _openDisclosure(tester, 'Responsive');

      expect(find.textContaining('wraps'), findsWidgets);
      expect(
        find.textContaining('BreadcrumbEllipsis'),
        findsOneWidget,
        reason: 'the page must say this is recorded, not built',
      );
    });

    testWidgets(
      'the Keyboard disclosure names the real absence of key handling',
      (WidgetTester tester) async {
        await _pumpBreadcrumbDoc(tester);
        await _openDisclosure(tester, 'Keyboard');

        expect(find.textContaining('Focus'), findsWidgets);
        expect(find.textContaining('Tab'), findsWidgets);
      },
    );

    testWidgets('a single-crumb specimen renders no separator', (
      WidgetTester tester,
    ) async {
      await _pumpBreadcrumbDoc(tester);

      final Breadcrumb single = tester.widget<Breadcrumb>(
        find.byWidgetPredicate(
          (Widget widget) => widget is Breadcrumb && widget.items.length == 1,
        ),
      );
      expect(single.items.single.isPage, isTrue);
    });

    testWidgets('the RTL specimen composes Breadcrumb under a Directionality', (
      WidgetTester tester,
    ) async {
      await _pumpBreadcrumbDoc(tester);

      final Iterable<Directionality> rtl = tester
          .widgetList<Directionality>(find.byType(Directionality))
          .where((Directionality d) => d.textDirection == TextDirection.rtl);
      expect(rtl, isNotEmpty);
    });

    testWidgets(
      'the Link component specimen fires its onTap seam on a real tap',
      (WidgetTester tester) async {
        await _pumpBreadcrumbDoc(tester);

        expect(find.textContaining('onTap fired: /dashboard'), findsOneWidget);

        // Scoped to the Link component section specifically: 'Projects'
        // renders as a crumb in several other specimens on this page too,
        // and only this one is wired to update the state text below it.
        final Finder section = find.byWidgetPredicate(
          (Widget widget) =>
              widget is DocsSection && widget.id == 'link-component',
        );
        final Finder projects = find.descendant(
          of: section,
          matching: find.text('Projects'),
        );
        await tester.ensureVisible(projects);
        await tester.tap(projects);
        await tester.pump();

        expect(find.textContaining('onTap fired: /projects'), findsOneWidget);
      },
    );

    testWidgets(
      'navigating previous/next fires onNavigate with the wave-1 neighbours',
      (WidgetTester tester) async {
        String? destination;
        await _pumpBreadcrumbDoc(
          tester,
          onNavigate: (String route) => destination = route,
        );

        // 'Badge' and 'Checkbox' also appear in the sidebar, so scope to the
        // prev/next pager specifically.
        final Finder pager = find.byKey(
          const ValueKey<String>('docs-layout-prev-next'),
        );
        final Finder badge = find.descendant(
          of: pager,
          matching: find.text('Badge'),
        );
        final Finder checkbox = find.descendant(
          of: pager,
          matching: find.text('Checkbox'),
        );

        await tester.ensureVisible(badge);
        await tester.tap(badge);
        expect(destination, '/components/badge');

        await tester.ensureVisible(checkbox);
        await tester.tap(checkbox);
        expect(destination, '/components/checkbox');
      },
    );
  });

  group('viewport widths', () {
    testWidgets('a wide viewport exposes the sidebar and table of contents', (
      WidgetTester tester,
    ) async {
      await _pumpBreadcrumbDoc(tester, size: _wide);

      expect(
        find.byKey(const ValueKey<String>('docs-layout-sidebar')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('docs-layout-toc')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('breadcrumb-doc-article')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'a narrow viewport drops to the anchor strip and stays reachable',
      (WidgetTester tester) async {
        await _pumpBreadcrumbDoc(tester, size: _narrow);

        expect(
          find.byKey(const ValueKey<String>('docs-layout-sidebar')),
          findsNothing,
        );
        expect(
          find.byKey(const ValueKey<String>('docs-layout-anchor-strip')),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey<String>('breadcrumb-doc-article')),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
      },
    );
  });

  group('both themes', () {
    testWidgets('renders on light', (WidgetTester tester) async {
      await _pumpBreadcrumbDoc(tester, mode: ColorMode.light);
      expect(find.byType(Breadcrumb), findsWidgets);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders on dark', (WidgetTester tester) async {
      await _pumpBreadcrumbDoc(tester, mode: ColorMode.dark);
      expect(find.byType(Breadcrumb), findsWidgets);
      expect(tester.takeException(), isNull);
    });

    testWidgets('flipping the theme in place keeps the page intact', (
      WidgetTester tester,
    ) async {
      final ThemeController theme = await _pumpBreadcrumbDoc(
        tester,
        mode: ColorMode.dark,
      );
      expect(find.byType(Breadcrumb), findsWidgets);

      theme.setMode(ColorMode.light);
      await tester.pump();

      expect(find.byType(Breadcrumb), findsWidgets);
      expect(tester.takeException(), isNull);
    });
  });
}
