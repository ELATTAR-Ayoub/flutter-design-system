import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/switch/page.dart';
import 'package:example/docs/docs_layout.dart';
import 'package:example/kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// The `switch` documentation page: renders the shadcn-parity section order
/// (Installation, Usage, Description, Choice card, Disabled, Invalid, Size,
/// API Reference, States, Accessibility, Responsive, Dependencies, Theming,
/// Source, behind the un-headed hero demo), the API table lists every real
/// [ElSwitch] constructor parameter, and the live specimen actually toggles
/// under a real, live [ElThemeController] rather than a rebuilt one, and
/// under real `tester.view` sizing rather than a synthetic [MediaQuery].
///
/// Section order, matching https://ui.shadcn.com/docs/components/base/switch:
/// RTL is skipped (ElSwitch's thumb travel is not direction-aware); every
/// other shadcn section is mirrored, plus the six sections shadcn does not
/// carry (States, Accessibility, Responsive, Dependencies, Theming, Source).
const List<String> _sectionOrder = <String>[
  'install',
  'usage',
  'description',
  'choice-card',
  'disabled',
  'invalid',
  'size',
  'api',
  'states',
  'accessibility',
  'responsive',
  'dependencies',
  'theming',
  'source',
];

Widget _harness({
  required Widget child,
  required Size size,
  required ElThemeController controller,
  bool disableAnimations = false,
}) => MediaQuery(
  data: MediaQueryData(size: size, disableAnimations: disableAnimations),
  child: Directionality(
    textDirection: TextDirection.ltr,
    child: ElTheme(
      controller: controller,
      child: MaterialApp(home: SingleChildScrollView(child: child)),
    ),
  ),
);

void main() {
  testWidgets(
    'switch docs render at desktop, the API table lists every constructor '
    'parameter, the live specimen toggles, and the theme flips in place',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final ElThemeController controller = ElThemeController(
        mode: ElThemeMode.dark,
      );
      String? destination;

      await tester.pumpWidget(
        _harness(
          size: const Size(1440, 900),
          controller: controller,
          child: SwitchDocPage(
            onNavigate: (String route) => destination = route,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey<String>('switch-doc-article')),
        findsOneWidget,
      );
      expect(find.byType(ElSwitch), findsAtLeastNWidgets(4));
      expect(
        find.byKey(const ValueKey<String>('docs-layout-sidebar')),
        findsOneWidget,
      );

      // The API table covers every ElSwitch constructor parameter found in
      // lib/src/components/switch.dart.
      for (final String name in <String>[
        'value',
        'onChanged',
        'size',
        'enabled',
        'invalid',
        'focusNode',
        'label',
        'hint',
      ]) {
        expect(
          find.text(name),
          findsOneWidget,
          reason: 'missing API row: $name',
        );
      }

      // ElSwitchSize's two rungs are both documented.
      expect(find.textContaining('ElSwitchSize.sm'), findsWidgets);
      expect(find.textContaining('ElSwitchSize.md'), findsWidgets);

      // The shadcn-parity section list renders in order: the un-headed hero
      // demo first (no ElSection, no TOC entry), then every ElSection this
      // page declares, top to bottom, matching the anchors in page.dart's
      // own `toc:` list.
      final double previewTop = tester
          .getTopLeft(find.byKey(docsAnchorKey('preview')))
          .dy;
      double previousTop = previewTop;
      for (final String id in _sectionOrder) {
        final Finder section = find.byKey(ElSection.anchorKey(id));
        expect(section, findsOneWidget, reason: 'missing section: $id');
        final double top = tester.getTopLeft(section).dy;
        expect(
          top,
          greaterThan(previousTop),
          reason: 'section "$id" is not below the previous section',
        );
        previousTop = top;
      }

      // The live specimen mounts and actually toggles on tap.
      final Finder specimen = find.byKey(
        const ValueKey<String>('switch-doc-live-specimen'),
      );
      expect(specimen, findsOneWidget);
      await tester.ensureVisible(specimen);
      await tester.pumpAndSettle();
      final bool before = tester.widget<ElSwitch>(specimen).value;
      await tester.tap(specimen);
      await tester.pumpAndSettle();
      final bool after = tester.widget<ElSwitch>(specimen).value;
      expect(after, !before);

      // Previous/Next pager navigates through DocsLayout.onNavigate. The
      // specimen scroll above may have carried the sidebar's "Select" link
      // out of view: scroll it back into frame before tapping it.
      final Finder selectLink = find.text('Select').first;
      await tester.ensureVisible(selectLink);
      await tester.pumpAndSettle();
      await tester.tap(selectLink);
      expect(destination, '/components/select');

      // The theme flips live, in place, without losing specimen state.
      controller.setMode(ElThemeMode.light);
      await tester.pumpAndSettle();
      expect(
        find.byKey(const ValueKey<String>('switch-doc-article')),
        findsOneWidget,
      );
      expect(tester.widget<ElSwitch>(specimen).value, after);
    },
  );

  testWidgets(
    'switch docs render at mobile with narrow anchors, and reduced motion '
    'lands the live specimen on its end state in a single pump',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final ElThemeController controller = ElThemeController(
        mode: ElThemeMode.light,
      );

      await tester.pumpWidget(
        _harness(
          size: const Size(390, 844),
          controller: controller,
          disableAnimations: true,
          child: const SwitchDocPage(),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey<String>('switch-doc-article')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('docs-layout-anchor-strip')),
        findsOneWidget,
      );

      final Finder specimen = find.byKey(
        const ValueKey<String>('switch-doc-live-specimen'),
      );
      expect(specimen, findsOneWidget);
      // The specimen sits well below the fold at 390 × 844: scroll it into
      // view before tapping, the same as a real touch reader would have to.
      await tester.ensureVisible(specimen);
      await tester.pumpAndSettle();
      final bool before = tester.widget<ElSwitch>(specimen).value;
      await tester.tap(specimen);
      // MediaQueryData.disableAnimations collapses elAnimationDuration to
      // zero, so one pump is enough to land on the end state: no spring
      // overshoot to wait out, and no arbitrary duration to pump past.
      await tester.pump();
      expect(tester.widget<ElSwitch>(specimen).value, !before);
    },
  );
}
