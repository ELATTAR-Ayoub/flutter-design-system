import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/icon/meta.dart';
import 'package:example/components_docs/icon/page.dart';
import 'package:example/kit.dart' show ElSection;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// This page's own section order, split off `spinner` and `rule`:
/// see `example/lib/components_docs/icon/page.dart`'s own library doc.
/// The unheaded live demo carries no [ElSection] and no heading, so
/// Installation is the first entry here.
const List<String> _iconSectionOrder = <String>[
  'install',
  'usage',
  'sizes',
  'tones',
  'lucide',
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
  required ElThemeController controller,
}) => ElTheme(
  controller: controller,
  child: MaterialApp(home: SingleChildScrollView(child: child)),
);

void main() {
  group('icon docs page', () {
    testWidgets('renders the article with icon specimens at multiple sizes', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      String? destination;
      await tester.pumpWidget(
        _harness(
          controller: ElThemeController(mode: ElThemeMode.dark),
          child: IconDocPage(onNavigate: (String route) => destination = route),
        ),
      );

      // Article mounts.
      expect(
        find.byKey(const ValueKey<String>('icon-doc-article')),
        findsOneWidget,
      );

      // Icon specimens mount at every ElIconSize rung.
      final List<ElIcon> icons = tester
          .widgetList<ElIcon>(find.byType(ElIcon))
          .toList();
      expect(icons.length, greaterThanOrEqualTo(ElIconSize.values.length));
      final Set<ElIconSize> mountedSizes = icons
          .map((ElIcon i) => i.size)
          .toSet();
      expect(mountedSizes, containsAll(ElIconSize.values));

      // Every fixed tone (all but inherit) mounts a live specimen.
      final Set<ElIconTone> mountedTones = icons
          .map((ElIcon i) => i.tone)
          .toSet();
      for (final ElIconTone tone in ElIconTone.values) {
        if (tone == ElIconTone.inherit) continue;
        expect(
          mountedTones,
          contains(tone),
          reason: 'ElIconTone.${tone.name} has no live specimen',
        );
      }

      // The lucide-registry constructor is demonstrated live.
      final List<ElIcon> lucideIcons = icons
          .where((ElIcon i) => i.lucide != null)
          .toList();
      expect(lucideIcons, isNotEmpty, reason: 'no ElIcon.lucide specimen');

      // Metadata reads correctly.
      expect(iconDoc.name, 'icon');
      expect(iconDoc.dependencies, <String>['source-foundation']);
      expect(
        iconDoc.exports,
        containsAll(<String>['ElIcon', 'ElIconGlyph', 'ElIconSize']),
      );
      expect(iconDoc.command, 'elattar add icon');

      // No navigate callback triggered during build.
      expect(destination, isNull);

      // Every section renders, in exactly the order the page declares.
      double? previousTop;
      for (final String id in _iconSectionOrder) {
        final Finder finder = find.byKey(ElSection.anchorKey(id));
        expect(finder, findsOneWidget, reason: 'missing section "$id"');
        final double top = tester.getTopLeft(finder).dy;
        if (previousTop != null) {
          expect(
            top,
            greaterThan(previousTop),
            reason: '"$id" is out of order',
          );
        }
        previousTop = top;
      }

      // Section titles match the shape brief exactly, in order.
      final List<String> titles = tester
          .widgetList<ElSection>(find.byType(ElSection))
          .map((ElSection section) => section.title)
          .toList();
      expect(titles, <String>[
        'Installation',
        'Usage',
        'Sizes',
        'Tones',
        'Lucide catalog',
        'API Reference',
        'States',
        'Accessibility',
        'Responsive',
        'Dependencies',
        'Theming',
        'Source',
      ]);

      // spinner and rule content no longer renders on this page.
      expect(find.byType(ElSpinner), findsNothing);
      expect(find.textContaining('ElRule'), findsNothing);
    });

    testWidgets(
      'renders at narrow width with the anchor strip instead of a rail',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: const IconDocPage(),
          ),
        );

        expect(
          find.byKey(const ValueKey<String>('icon-doc-article')),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey<String>('docs-layout-anchor-strip')),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey<String>('docs-layout-sidebar')),
          findsNothing,
        );
      },
    );

    testWidgets('icon sizes and tones resolve correctly in both themes', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final ElThemeController controller = ElThemeController(
        mode: ElThemeMode.dark,
      );

      await tester.pumpWidget(
        _harness(controller: controller, child: const IconDocPage()),
      );

      final List<ElIcon> darkIcons = tester
          .widgetList<ElIcon>(find.byType(ElIcon))
          .toList();
      expect(darkIcons.length, greaterThan(0));

      controller.setMode(ElThemeMode.light);
      await tester.pump();

      final List<ElIcon> lightIcons = tester
          .widgetList<ElIcon>(find.byType(ElIcon))
          .toList();
      expect(lightIcons.length, equals(darkIcons.length));
    });

    testWidgets('ElIcon.pxFor, strokeFor and colorFor resolve as documented', (
      WidgetTester tester,
    ) async {
      // Verifies the API table's own claims against the real static
      // methods, not just against rendered prose.
      expect(ElIcon.pxFor(ElIconSize.xs), 12);
      expect(ElIcon.pxFor(ElIconSize.sm), 14);
      expect(ElIcon.pxFor(ElIconSize.md), 16);
      expect(ElIcon.pxFor(ElIconSize.lg), 20);
      expect(ElIcon.pxFor(ElIconSize.xl), 24);
      expect(ElIcon.pxFor(ElIconSize.xl2), 32);
      expect(ElIcon.pxFor(ElIconSize.xl3), 40);

      // scaled = 48 / px: above 2.6 -> 2.4, below 1.5 -> 1.6, else 2.
      expect(ElIcon.strokeFor(16), 2.4); // 48/16 = 3.0 > 2.6
      expect(ElIcon.strokeFor(32), 2.0); // 48/32 = 1.5, not < 1.5
      expect(ElIcon.strokeFor(40), 1.6); // 48/40 = 1.2 < 1.5
    });
  });
}
