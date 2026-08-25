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

    final Finder rail = find.byKey(
      const ValueKey<String>('docs-layout-sidebar'),
    );
    expect(rail, findsOneWidget);
    expect(
      tester.getSize(rail).height,
      lessThanOrEqualTo(viewportHeight - ElWidths.siteHeader),
    );
  });
}
