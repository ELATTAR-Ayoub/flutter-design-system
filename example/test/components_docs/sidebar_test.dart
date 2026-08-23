/// Tests for `components_docs/sidebar/meta.dart` and
/// `components_docs/sidebar/page.dart` — the public Sidebar component
/// documentation page.
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never synthetic `MediaQuery` for size.
/// The one thing the harness *does* override on [MediaQuery] is
/// `disableAnimations`, because the whole point of this page is a control
/// that **animates** its width over 250ms: `dsAnimationDuration` reads that
/// flag and returns [Duration.zero], so the collapse lands whole on the next
/// frame and no test here has to pump a made-up duration to catch it.
///
/// Theme coverage flips a live [DsThemeController] in place rather than
/// pumping two independent trees.
///
/// The page mounts three real [DsSidebarProvider]s (icon, parts, offcanvas).
/// Each installs its own `HardwareKeyboard` handler, so ⌘B/Ctrl-B toggles all
/// three at once — the reference's own behaviour, reproduced, and the reason
/// the keyboard case below asserts on one named panel rather than on a
/// count.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/sidebar/meta.dart';
import 'package:example/components_docs/sidebar/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter_test/flutter_test.dart';

const Size _wide = Size(1440, 900);
const Size _narrow = Size(390, 844);

const ValueKey<String> _articleKey = ValueKey<String>('sidebar-doc-article');
const ValueKey<String> _shellKey =
    ValueKey<String>('sidebar-doc-specimen-shell');
const ValueKey<String> _partsKey =
    ValueKey<String>('sidebar-doc-specimen-parts');
const ValueKey<String> _offcanvasKey =
    ValueKey<String>('sidebar-doc-specimen-offcanvas');

Future<DsThemeController> _pumpSidebarDoc(
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
        home: Builder(
          builder: (BuildContext context) => MediaQuery(
            // Size still comes from the real test view; only motion is
            // frozen, so the 250ms collapse resolves in a single frame.
            data: MediaQuery.of(context).copyWith(disableAnimations: true),
            child: Scaffold(
              body: SingleChildScrollView(
                child: SidebarDocPage(onNavigate: onNavigate),
              ),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  return theme;
}

Finder _within(Key specimen, Type type) =>
    find.descendant(of: find.byKey(specimen), matching: find.byType(type));

double _panelWidth(WidgetTester tester, Key specimen) => tester
    .renderObject<RenderBox>(_within(specimen, DsSidebar))
    .size
    .width;

/// Scrolls [finder] into the docs scroller and taps it.
Future<void> _reveal(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pump();
}

void main() {
  group('meta', () {
    test('sidebarDoc names the real public API surface', () {
      expect(sidebarDoc.name, 'sidebar');
      expect(sidebarDoc.title, 'Sidebar');
      expect(sidebarDoc.route, '/components/sidebar');
      expect(sidebarDoc.command, 'elattar add sidebar');
      expect(sidebarDoc.sourcePath, 'lib/src/components/sidebar.dart');

      // The whole family, not just the panel: provider, panel, rail, trigger,
      // inset, regions, groups, menu, submenu, and the nav_user block that
      // ships in the same family.
      expect(
        sidebarDoc.exports,
        containsAll(<String>[
          'DsSidebarProvider',
          'DsSidebarScope',
          'DsSidebarChrome',
          'DsSidebar',
          'DsSidebarSide',
          'DsSidebarVariant',
          'DsSidebarCollapsible',
          'DsSidebarRail',
          'DsSidebarTrigger',
          'DsSidebarInset',
          'DsSidebarHeader',
          'DsSidebarFooter',
          'DsSidebarContent',
          'DsSidebarSeparator',
          'DsSidebarGroup',
          'DsSidebarGroupContent',
          'DsSidebarGroupLabel',
          'DsSidebarGroupAction',
          'DsSidebarCollapsibleGroup',
          'DsSidebarMenu',
          'DsSidebarMenuItem',
          'DsSidebarMenuButton',
          'DsSidebarMenuButtonSize',
          'DsSidebarMenuRow',
          'DsSidebarMenuLabel',
          'DsSidebarMenuAction',
          'DsSidebarMenuBadge',
          'DsSidebarMenuSkeleton',
          'DsSidebarMenuSub',
          'DsSidebarMenuSubItem',
          'DsSidebarMenuSubButton',
          'DsSidebarMenuSubButtonSize',
          'DsSidebarInput',
          'DsNavUser',
          'DsNavUserAccount',
          'DsNavUserItem',
        ]),
      );

      // Source-level imports, not a registry manifest — sidebar has none.
      expect(sidebarDoc.dependencies, contains('tooltip'));
      expect(sidebarDoc.dependencies, contains('sheet'));
      expect(sidebarDoc.dependencies, contains('button'));

      expect(sidebarDoc.description.trim(), sidebarDoc.description);
      expect(
        sidebarExpandedDescription,
        isNot(equals(sidebarDoc.description)),
      );
      expect(sidebarExpandedDescription.trim(), sidebarExpandedDescription);
      // The expanded description has to answer "instead of which neighbour".
      expect(sidebarExpandedDescription, contains('navigation menu'));
      expect(sidebarExpandedDescription, contains('drawer'));
    });
  });

  group('rendered page', () {
    testWidgets('renders the article and all three live specimens', (
      WidgetTester tester,
    ) async {
      await _pumpSidebarDoc(tester);

      expect(find.byKey(_articleKey), findsOneWidget);
      expect(find.byKey(_shellKey), findsOneWidget);
      expect(find.byKey(_partsKey), findsOneWidget);
      expect(find.byKey(_offcanvasKey), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('the API tables cover the whole family', (
      WidgetTester tester,
    ) async {
      await _pumpSidebarDoc(tester);

      // Every table title in the API section.
      for (final String klass in <String>[
        'DsSidebarProvider',
        'DsSidebar',
        'DsSidebarMenuButton',
        'DsSidebarMenuItem',
        'DsSidebarCollapsibleGroup',
        'DsSidebarScope',
        'DsNavUser',
      ]) {
        expect(
          find.textContaining(klass),
          findsWidgets,
          reason: '$klass should be documented somewhere on the page',
        );
      }

      // Constructor parameters that only exist on this family.
      for (final String property in <String>[
        'defaultOpen',
        'onOpenChange',
        'minHeight',
        'collapsible',
        'expand',
        'isActive',
        'tooltip',
        'suppressPressScale',
        'submenu',
        'toggleLabel',
        'seed',
        'showIcon',
      ]) {
        expect(
          find.text(property),
          findsWidgets,
          reason: '$property is a real constructor parameter',
        );
      }
    });

    testWidgets('the variants section lists all three enums in full', (
      WidgetTester tester,
    ) async {
      await _pumpSidebarDoc(tester);

      for (final String value in <String>[
        'offcanvas',
        'icon',
        'none',
        'floating',
        'inset',
        'left',
        'right',
      ]) {
        expect(find.text(value), findsWidgets, reason: '$value is an enum value');
      }
    });

    testWidgets('the collapse contract prints the measured widths', (
      WidgetTester tester,
    ) async {
      await _pumpSidebarDoc(tester);

      expect(find.textContaining('256'), findsWidgets);
      expect(find.textContaining('48'), findsWidgets);
      expect(find.textContaining('64'), findsWidgets);
      expect(find.textContaining('66'), findsWidgets);
      expect(find.textContaining('250ms'), findsWidgets);
    });

    testWidgets('installation states plainly that there is no manifest', (
      WidgetTester tester,
    ) async {
      await _pumpSidebarDoc(tester);

      expect(find.textContaining('no registry manifest'), findsWidgets);
      // And never prints a command that does not work.
      expect(find.text('elattar add sidebar'), findsNothing);
    });

    testWidgets('accessibility documents the collapsed-row naming contract', (
      WidgetTester tester,
    ) async {
      await _pumpSidebarDoc(tester);

      // The finding: a row's own accessible name comes from
      // DsButton(label: label ?? tooltip) — not from the tooltip overlay —
      // and a row given neither loses its name entirely once collapsed.
      expect(find.textContaining('accessible name'), findsWidgets);
      expect(find.textContaining('label ?? tooltip'), findsWidgets);
      expect(find.textContaining('unnamed button'), findsWidgets);
    });

    testWidgets('the mobile breakpoint is documented as the real 768', (
      WidgetTester tester,
    ) async {
      await _pumpSidebarDoc(tester);

      expect(find.textContaining('768'), findsWidgets);
      expect(find.textContaining('288'), findsWidgets);
    });

    testWidgets('navigating previous fires onNavigate with the neighbour', (
      WidgetTester tester,
    ) async {
      String? destination;
      await _pumpSidebarDoc(
        tester,
        onNavigate: (String route) => destination = route,
      );

      await _reveal(tester, find.text('Sheet').first);
      await tester.tap(find.text('Sheet').first);
      expect(destination, '/components/sheet');
    });
  });

  group('live specimen — the collapse contract', () {
    testWidgets('the icon shell narrows 256 -> 48 and back', (
      WidgetTester tester,
    ) async {
      await _pumpSidebarDoc(tester);

      expect(_panelWidth(tester, _shellKey), DsWidths.sidebar);

      final Finder trigger = _within(_shellKey, DsSidebarTrigger);
      await _reveal(tester, trigger);
      await tester.tap(trigger);
      await tester.pump();
      await tester.pump();
      expect(_panelWidth(tester, _shellKey), DsWidths.sidebarIcon);

      await tester.tap(trigger);
      await tester.pump();
      await tester.pump();
      expect(_panelWidth(tester, _shellKey), DsWidths.sidebar);
      expect(tester.takeException(), isNull);
    });

    testWidgets('collapsing drops the labels and the submenu, keeps the rows', (
      WidgetTester tester,
    ) async {
      await _pumpSidebarDoc(tester);

      final int rowsExpanded =
          tester.widgetList(_within(_shellKey, DsSidebarMenuButton)).length;
      expect(rowsExpanded, greaterThan(0));
      expect(_within(_shellKey, DsSidebarMenuSubButton), findsWidgets);

      final Finder trigger = _within(_shellKey, DsSidebarTrigger);
      await _reveal(tester, trigger);
      await tester.tap(trigger);
      await tester.pump();
      await tester.pump();

      // The rows survive at 32px; the nested list does not survive at all.
      expect(
        tester.widgetList(_within(_shellKey, DsSidebarMenuButton)).length,
        rowsExpanded,
      );
      expect(_within(_shellKey, DsSidebarMenuSubButton), findsNothing);
      expect(
        tester
            .renderObject<RenderBox>(
              _within(_shellKey, DsSidebarMenuButton).first,
            )
            .size
            .height,
        DsSidebarMenuButton.iconSize,
      );
    });

    testWidgets('offcanvas closes the gap to zero and keeps the panel 256', (
      WidgetTester tester,
    ) async {
      await _pumpSidebarDoc(tester);

      expect(_panelWidth(tester, _offcanvasKey), DsWidths.sidebar);

      final Finder trigger = _within(_offcanvasKey, DsSidebarTrigger);
      await _reveal(tester, trigger);
      await tester.tap(trigger);
      await tester.pump();
      await tester.pump();

      expect(_panelWidth(tester, _offcanvasKey), 0);
      // The container keeps its width and leaves to the left.
      final Rect content =
          tester.getRect(_within(_offcanvasKey, DsSidebarContent));
      expect(content.width, closeTo(DsWidths.sidebar - DsWidths.hairline, 0.5));
    });

    testWidgets('the parts stage is collapsible=none and never collapses', (
      WidgetTester tester,
    ) async {
      await _pumpSidebarDoc(tester);

      final double before = _panelWidth(tester, _partsKey);
      expect(before, greaterThan(DsWidths.sidebar));

      final Finder trigger = _within(_shellKey, DsSidebarTrigger);
      await _reveal(tester, trigger);
      await tester.tap(trigger);
      await tester.pump();
      await tester.pump();

      expect(_panelWidth(tester, _partsKey), before);
    });

    testWidgets('Ctrl-B toggles the shell from anywhere on the page', (
      WidgetTester tester,
    ) async {
      await _pumpSidebarDoc(tester);
      expect(_panelWidth(tester, _shellKey), DsWidths.sidebar);

      await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
      await tester.sendKeyEvent(DsSidebarProvider.shortcut);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
      await tester.pump();
      await tester.pump();

      expect(_panelWidth(tester, _shellKey), DsWidths.sidebarIcon);
    });
  });

  group('viewport widths', () {
    testWidgets('a wide viewport exposes the sidebar, toc, and live panel', (
      WidgetTester tester,
    ) async {
      await _pumpSidebarDoc(tester, size: _wide);

      expect(
        find.byKey(const ValueKey<String>('docs-layout-sidebar')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('docs-layout-toc')),
        findsOneWidget,
      );
      expect(_within(_shellKey, DsSidebarContent), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('a narrow viewport takes the real mobile branch', (
      WidgetTester tester,
    ) async {
      await _pumpSidebarDoc(tester, size: _narrow);

      expect(
        find.byKey(const ValueKey<String>('docs-layout-sidebar')),
        findsNothing,
      );
      expect(
        find.byKey(const ValueKey<String>('docs-layout-anchor-strip')),
        findsOneWidget,
      );
      expect(find.byKey(_articleKey), findsOneWidget);

      // Under DsBreakpoints.md the desktop gap/container pair is not built at
      // all — the panel is a sheet that is closed until openMobile says
      // otherwise.
      expect(DsSidebarProvider.isMobileWidth(_narrow.width), isTrue);
      expect(_within(_shellKey, DsSidebarContent), findsNothing);

      final Finder trigger = _within(_shellKey, DsSidebarTrigger);
      await _reveal(tester, trigger);
      await tester.tap(trigger);
      await tester.pump();
      await tester.pump();

      final Finder sheet = _within(_shellKey, DsSheetContent);
      expect(sheet, findsOneWidget);
      expect(
        tester.widget<DsSheetContent>(sheet).width,
        DsWidths.sidebarMobile,
      );
      expect(tester.takeException(), isNull);
    });
  });

  group('both themes', () {
    testWidgets('renders on light', (WidgetTester tester) async {
      await _pumpSidebarDoc(tester, mode: DsThemeMode.light);
      expect(find.byType(DsSidebar), findsWidgets);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders on dark', (WidgetTester tester) async {
      await _pumpSidebarDoc(tester, mode: DsThemeMode.dark);
      expect(find.byType(DsSidebar), findsWidgets);
      expect(tester.takeException(), isNull);
    });

    testWidgets('flipping the theme in place keeps the page intact', (
      WidgetTester tester,
    ) async {
      final DsThemeController theme = await _pumpSidebarDoc(
        tester,
        mode: DsThemeMode.dark,
      );
      expect(find.byKey(_shellKey), findsOneWidget);

      theme.setMode(DsThemeMode.light);
      await tester.pump();

      expect(find.byKey(_shellKey), findsOneWidget);
      expect(_panelWidth(tester, _shellKey), DsWidths.sidebar);
      expect(tester.takeException(), isNull);
    });
  });
}
