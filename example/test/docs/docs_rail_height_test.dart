/// The rails scroll, and their last row is reachable.
///
/// The bug this pins: a rail capped at the full viewport height, but
/// positioned below a 64px sticky header, runs 64px past the fold.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/button/page.dart';
import 'package:flutter/material.dart' show MaterialApp;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('a rail is never taller than the space below the header', (
    WidgetTester tester,
  ) async {
    const double viewportHeight = 900;
    tester.view.physicalSize = const Size(1600, viewportHeight);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final ElThemeController controller = ElThemeController(
      mode: ElThemeMode.dark,
    );
    addTearDown(controller.dispose);

    // The same harness every component-doc test uses.
    await tester.pumpWidget(
      ElTheme(
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
    // `viewportHeight - ElWidths.siteHeader` alone, so the full expression
    // is pinned here, not a looser approximation of it.
    final double railMaxHeight = viewportHeight - ElWidths.siteHeader - el(4);

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
    // only renders at `ElBreakpoints.xl` and wider; this test's 1600-wide
    // view clears that.
    final Finder tocRail = find.byKey(
      const ValueKey<String>('docs-layout-toc'),
    );
    expect(tocRail, findsOneWidget);
    expect(tester.getSize(tocRail).height, lessThanOrEqualTo(railMaxHeight));
  });
}
