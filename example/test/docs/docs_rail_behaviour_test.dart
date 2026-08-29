/// The two rail behaviours a reader notices immediately, and neither of which
/// a render-only test would catch.
///
///  1. A pinned rail keeps air between itself and the sticky header. It used
///     to pin flush against the header's underside, so the rail's first group
///     label sat on the header's bottom edge and the two read as one block.
///  2. Moving to a new page sends the *article* to its top and leaves the
///     *rail* where it was. `DocsLayout` is rebuilt per route, so its rail
///     controller was too: clicking Voice Indicator from the bottom of the
///     rail landed you on the right page with the rail snapped back to
///     Accordion. With no offset to restore — a cold load of a deep link —
///     the rail reveals the selected row instead.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/catalog.dart';
import 'package:example/main.dart';
import 'package:example/site/site_shell.dart';
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

const Size _desktop = Size(1600, 900);

void _sizeTo(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

Finder get _sidebar =>
    find.byKey(const ValueKey<String>('docs-layout-sidebar'));

/// The whole app, so `SiteShell` is the same element across a route change —
/// which is the only reason the remembered offset has anywhere to live.
Widget _shell(String route, ThemeController controller) => ThemeScope(
  controller: controller,
  child: MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SiteShell(
      route: route,
      child: publicPageFor(route, onNavigate: (_) {}),
    ),
  ),
);

void main() {
  testWidgets('a pinned rail keeps a gutter below the header', (
    WidgetTester tester,
  ) async {
    _sizeTo(tester, _desktop);
    final ThemeController controller = ThemeController(mode: ColorMode.dark);
    addTearDown(controller.dispose);

    await tester.pumpWidget(_shell('/components/button', controller));
    await tester.pump();

    final ScrollableState page = tester.state<ScrollableState>(
      find.byType(Scrollable).first,
    );
    // Far enough that the rail's resting top is well above the sticky line,
    // so the rail is definitely pinned rather than merely scrolled.
    page.position.jumpTo(600);
    await tester.pump();

    final double top = tester.getTopLeft(_sidebar).dy;
    expect(
      top,
      greaterThanOrEqualTo(LayoutHeights.siteHeader + space(6) - 0.5),
      reason:
          'a pinned rail must not touch the header: it sits a space(6) '
          'gutter below it, the same air it has at rest',
    );
  });

  testWidgets(
    'moving to another page keeps the rail where it was while the article '
    'goes back to its top',
    (WidgetTester tester) async {
      _sizeTo(tester, _desktop);
      final ThemeController controller = ThemeController(mode: ColorMode.dark);
      addTearDown(controller.dispose);

      await tester.pumpWidget(_shell('/components/button', controller));
      await tester.pump();

      // Drive the rail's own controller, not the page's: they are separate
      // positions, which is the whole point of the rail scrolling on its own.
      final ScrollableState rail = tester.state<ScrollableState>(
        find.descendant(of: _sidebar, matching: find.byType(Scrollable)).first,
      );
      const double parked = 420;
      rail.position.jumpTo(parked);
      await tester.pump();

      final ScrollableState page = tester.state<ScrollableState>(
        find.byType(Scrollable).first,
      );
      page.position.jumpTo(500);
      await tester.pump();

      // Same `SiteShell` element, new route — exactly what the router does.
      await tester.pumpWidget(_shell('/components/card', controller));
      await tester.pump();

      final ScrollableState nextPage = tester.state<ScrollableState>(
        find.byType(Scrollable).first,
      );
      expect(
        nextPage.position.pixels,
        nextPage.position.minScrollExtent,
        reason: 'a new page starts at its top',
      );

      final ScrollableState nextRail = tester.state<ScrollableState>(
        find.descendant(of: _sidebar, matching: find.byType(Scrollable)).first,
      );
      expect(
        nextRail.position.pixels,
        closeTo(parked, 1),
        reason:
            'the rail is the same list on both pages, so it holds its place',
      );
    },
  );

  testWidgets('with nothing to restore, the rail reveals the page you are on', (
    WidgetTester tester,
  ) async {
    _sizeTo(tester, _desktop);
    final ThemeController controller = ThemeController(mode: ColorMode.dark);
    addTearDown(controller.dispose);

    // Voice Indicator is in the Agent group, far below the fold in a rail
    // that opens on Accordion — the cold-load case a deep link produces.
    const String route = '/components/voice_indicator';
    expect(
      componentDocs.any((ComponentDocEntry e) => e.route == route),
      isTrue,
    );

    await tester.pumpWidget(_shell(route, controller));
    await tester.pump();
    await tester.pump();

    final ScrollableState rail = tester.state<ScrollableState>(
      find.descendant(of: _sidebar, matching: find.byType(Scrollable)).first,
    );
    expect(
      rail.position.pixels,
      greaterThan(0),
      reason:
          'the selected row sits below the fold, so the rail must scroll '
          'to it rather than opening on the alphabet',
    );

    final Finder selected = find.byKey(
      const ValueKey<String>('docs-sidebar:$route'),
    );
    expect(selected, findsOneWidget);
    final Rect box = tester.getRect(selected);
    final Rect railBox = tester.getRect(_sidebar);
    expect(box.top, greaterThanOrEqualTo(railBox.top - 1));
    expect(box.bottom, lessThanOrEqualTo(railBox.bottom + 1));
  });
}
