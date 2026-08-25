/// Tests for `components_docs/icon/meta.dart` and
/// `components_docs/icon/page.dart`: the public documentation page for
/// Icon, re-housed onto the kit (`ComponentDocSpec` + `ComponentDocPage`),
/// the same shape `button_test.dart` covers.
///
/// API Reference, Accessibility, Keyboard, Responsive, Dependencies, and
/// Theming are all `DisclosureSection`s, closed by default and mounting no
/// content while closed (see `docs_disclosure_test.dart`), so tests that
/// read their content open the relevant `DocsDisclosure` first — the same
/// fix `button_test.dart` needed for its own API table.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/icon/meta.dart';
import 'package:example/components_docs/icon/page.dart';
import 'package:example/docs/docs_disclosure.dart';
import 'package:example/docs/docs_install.dart';
import 'package:example/docs/docs_section.dart' show DocsSection;
import 'package:example/docs/docs_showcase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// This page's own section order: see
/// `example/lib/components_docs/icon/page.dart`'s own library doc.
const List<String> _iconSectionIds = <String>[
  'preview',
  'install',
  'usage',
  'sizes',
  'tones',
  'lucide',
  'api',
  'states',
  'accessibility',
  'keyboard',
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

Finder _disclosureTrigger(String title) => find.descendant(
  of: find.byWidgetPredicate(
    (Widget widget) => widget is DocsDisclosure && widget.title == title,
  ),
  matching: find.byKey(DocsDisclosure.triggerKey),
);

Future<void> _open(WidgetTester tester, String title) async {
  final Finder trigger = _disclosureTrigger(title);
  await tester.ensureVisible(trigger);
  await tester.pump();
  await tester.tap(trigger);
  await tester.pump();
  await tester.pump(ElDurations.jelly);
}

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
      await tester.pump();

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

      // Every section renders, in exactly the order the page declares —
      // both id and title, read off the same mounted `DocsSection` list so
      // "order" means tree order, not a second hand-typed list to drift
      // from the first.
      final List<DocsSection> sections = tester
          .widgetList<DocsSection>(find.byType(DocsSection))
          .toList();
      expect(
        sections.map((DocsSection section) => section.id).toList(),
        _iconSectionIds,
      );
      expect(sections.map((DocsSection section) => section.title).toList(), <
        String
      >[
        'Preview',
        'Installation',
        'Usage',
        'Sizes',
        'Tones',
        'Lucide catalog',
        'API Reference',
        'States',
        'Accessibility',
        'Keyboard',
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
      'the page is declared, and every section is a kit component',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 4000);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: const IconDocPage(),
          ),
        );
        await tester.pump();

        // Four specimen stages: Preview, Sizes, Tones, Lucide catalog.
        expect(find.byType(DocsShowcase), findsNWidgets(4));
        expect(find.byType(DocsInstall), findsOneWidget);
        // Eight collapsed sections: API Reference, States, Accessibility,
        // Keyboard, Responsive, Dependencies, Theming, Source.
        expect(find.byType(DocsDisclosure), findsNWidgets(8));
      },
    );

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

    testWidgets(
      'the installation section names all four manifest files and the '
      'license',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: const IconDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.textContaining('icon_paths.g.index.dart'),
          findsWidgets,
        );
        expect(find.byType(DocsInstall), findsOneWidget);
      },
    );

    testWidgets('keyboard section documents ElIcon has no focus of its own', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _harness(
          controller: ElThemeController(mode: ElThemeMode.dark),
          child: const IconDocPage(),
        ),
      );

      await _open(tester, 'Keyboard');

      expect(
        find.textContaining('No keyboard behaviour of its own'),
        findsWidgets,
      );
    });
  });
}
