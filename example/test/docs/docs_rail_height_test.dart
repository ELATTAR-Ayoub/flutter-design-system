/// The rails scroll, and their last row is reachable.
///
/// The bug this pins: a rail capped at the full viewport height, but
/// positioned below a 64px sticky header, runs 64px past the fold.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/button/page.dart';
import 'package:flutter/material.dart' show MaterialApp;
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

void main() {
  testWidgets('a rail is never taller than the space below the header', (
    WidgetTester tester,
  ) async {
    const double viewportHeight = 900;
    tester.view.physicalSize = const Size(1600, viewportHeight);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final ThemeController controller = ThemeController(mode: ColorMode.dark);
    addTearDown(controller.dispose);

    // The same harness every component-doc test uses.
    await tester.pumpWidget(
      ThemeScope(
        controller: controller,
        child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: SingleChildScrollView(child: ButtonDocPage()),
        ),
      ),
    );
    await tester.pump();

    // The cap the implementation targets: the sticky header plus its own
    // bottom gutter, not just the header. A regression that drops the
    // gutter term but keeps the header term would still clear a bound of
    // `viewportHeight - LayoutHeights.siteHeader` alone, so the full expression
    // is pinned here, not a looser approximation of it.
    final double railMaxHeight =
        viewportHeight - LayoutHeights.siteHeader - space(4);

    final Finder sidebarRail = find.byKey(
      const ValueKey<String>('docs-layout-sidebar'),
    );
    expect(sidebarRail, findsOneWidget);
    expect(
      tester.getSize(sidebarRail).height,
      lessThanOrEqualTo(railMaxHeight),
    );

    // The table-of-contents rail on the right shares the same
    // `railMaxHeight` expression (`docs_layout.dart`'s two
    // `ConstrainedBox.maxHeight` sites), so it is pinned the same way. It
    // only renders at `Breakpoints.xl` and wider; this test's 1600-wide
    // view clears that.
    final Finder tocRail = find.byKey(
      const ValueKey<String>('docs-layout-toc'),
    );
    expect(tocRail, findsOneWidget);
    expect(tester.getSize(tocRail).height, lessThanOrEqualTo(railMaxHeight));
  });

  testWidgets('a rail rests at four fifths of a desktop window', (
    WidgetTester tester,
  ) async {
    // Tall enough that both rails' own content outgrows the cap — otherwise
    // this measures the content, not the cap, and would pass against no cap
    // at all. The button page's "Components" list is 55 rows and its outline
    // is long, so both overflow 720 comfortably.
    const double viewportHeight = 900;
    tester.view.physicalSize = const Size(1600, viewportHeight);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final ThemeController controller = ThemeController(mode: ColorMode.dark);
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      ThemeScope(
        controller: controller,
        child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: SingleChildScrollView(child: ButtonDocPage()),
        ),
      ),
    );
    await tester.pump();

    // `_railViewportFraction` in docs_layout.dart. Spelled out rather than
    // imported: it is private, and a test that reads the implementation's own
    // constant cannot catch that constant changing.
    const double desktopMaxHeight = viewportHeight * 0.8; // 720

    // The fold bound at this viewport is 900 - 64 - 16 = 820, so the
    // fraction is the tighter of the two and is what must actually bind. A
    // regression that dropped the fraction and kept only the fold bound
    // would land at 820 and fail here.
    for (final String key in const <String>[
      'docs-layout-sidebar',
      'docs-layout-toc',
    ]) {
      final Finder rail = find.byKey(ValueKey<String>(key));
      expect(rail, findsOneWidget, reason: key);
      expect(
        tester.getSize(rail).height,
        lessThanOrEqualTo(desktopMaxHeight),
        reason: '$key must rest inside four fifths of the window',
      );
      expect(
        tester.getSize(rail).height,
        closeTo(desktopMaxHeight, 1),
        reason:
            '$key overflows the cap, so it must be sitting exactly at it — '
            'if it is shorter, the cap is not the thing bounding it',
      );
    }
  });

  testWidgets('a tablet viewport gets no rail to cap', (
    WidgetTester tester,
  ) async {
    // The fraction is a desktop rule. It is desktop-only by construction —
    // below `Breakpoints.lg` there is no rail at all, only the horizontal
    // anchor strip — and this is what pins that construction, so a later
    // change that started rendering a rail on a tablet would have to come
    // past this test and decide the question deliberately.
    tester.view.physicalSize = const Size(Breakpoints.md, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final ThemeController controller = ThemeController(mode: ColorMode.dark);
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      ThemeScope(
        controller: controller,
        child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: SingleChildScrollView(child: ButtonDocPage()),
        ),
      ),
    );
    await tester.pump();

    expect(
      find.byKey(const ValueKey<String>('docs-layout-sidebar')),
      findsNothing,
    );
    expect(find.byKey(const ValueKey<String>('docs-layout-toc')), findsNothing);
    expect(
      find.byKey(const ValueKey<String>('docs-layout-anchor-strip')),
      findsOneWidget,
      reason: 'a tablet reads the outline as a strip, not a rail',
    );
  });
}
