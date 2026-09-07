/// The rails sit at the screen edges, and the article fills the room left
/// between them, at every width `SiteShell` now hands `DocsLayout` its own
/// full, uncapped viewport.
///
/// `docs_layout.dart` used to place its rails with a `Positioned` escape past
/// a `Stack`'s own box, compensating for a shell that capped and centred the
/// page at `LayoutWidths.shell`. Both the escape and the cap are gone: the
/// layout is a plain three-column `Row` now, and `site_shell.dart` gives a
/// documentation route the full viewport instead of centring it in a fixed
/// box. This test pins the resulting geometry directly, rather than the
/// escape arithmetic it replaced.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/button/page.dart';
import 'package:flutter/material.dart' show MaterialApp, SelectionArea;
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

/// Replicates `_SiteBody` (site_shell.dart) in its full-bleed, documentation
/// shape: no horizontal padding, no centering `Align`, no `maxWidth` cap —
/// only the vertical padding and the `SelectionArea` wrapper stay.
Widget _host({required Widget child}) => ThemeScope(
  controller: ThemeController(mode: ColorMode.dark),
  child: MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: space(12)),
        child: SelectionArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[child],
          ),
        ),
      ),
    ),
  ),
);

void main() {
  for (final double width in <double>[1024, 1280, 1440, 1600, 1920, 2560]) {
    testWidgets('rails and article at ${width.toInt()}', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = Size(width, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final List<String> routed = <String>[];
      await tester.pumpWidget(
        _host(child: ButtonDocPage(onNavigate: routed.add)),
      );
      await tester.pump();

      final bool extraWide = width >= Breakpoints.xl;
      const double tolerance = 1;

      final Finder sidebar = find.byKey(
        const ValueKey<String>('docs-layout-sidebar'),
      );
      final Finder toc = find.byKey(const ValueKey<String>('docs-layout-toc'));
      final Finder article = find.byKey(
        const ValueKey<String>('docs-layout-article'),
      );
      final Finder anchorStrip = find.byKey(
        const ValueKey<String>('docs-layout-anchor-strip'),
      );

      expect(sidebar, findsOneWidget, reason: 'no sidebar rail at $width');

      final Rect sidebarRect = tester.getRect(sidebar);
      expect(
        sidebarRect.left,
        closeTo(0, tolerance),
        reason: 'the sidebar rail must sit flush against the screen edge',
      );
      expect(
        sidebarRect.right,
        closeTo(LayoutWidths.rail + space(6), tolerance),
      );

      final Rect articleRect = tester.getRect(article);
      expect(
        articleRect.left,
        greaterThan(sidebarRect.right),
        reason: 'the article must not overlap the sidebar rail',
      );

      if (extraWide) {
        expect(toc, findsOneWidget, reason: 'no toc rail at $width');
        expect(anchorStrip, findsNothing);

        final Rect tocRect = tester.getRect(toc);
        expect(
          tocRect.right,
          closeTo(width, tolerance),
          reason: 'the toc rail must sit flush against the screen edge',
        );
        expect(
          articleRect.right,
          lessThan(tocRect.left),
          reason: 'the article must not overlap the toc rail',
        );
      } else {
        expect(toc, findsNothing, reason: 'no toc rail below xl at $width');
        expect(
          anchorStrip,
          findsOneWidget,
          reason:
              'nothing is lost below xl: the anchor strip stands in for '
              'the missing toc rail at $width',
        );
      }

      // Reachability, not just geometry: a rail that merely looks correct
      // and cannot be tapped is the exact defect this replaced.
      final Finder row = find.byKey(
        const ValueKey<String>('docs-sidebar:/docs/installation'),
      );
      expect(row, findsOneWidget, reason: 'no rail row to tap at $width');
      await tester.ensureVisible(row);
      await tester.pump();
      await tester.tap(row, warnIfMissed: false);
      await tester.pump();
      expect(
        routed,
        contains('/docs/installation'),
        reason: 'tapping a rail row at $width routed nowhere',
      );
    });
  }
}
