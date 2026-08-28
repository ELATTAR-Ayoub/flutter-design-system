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

Widget _harness({required Widget child, required ThemeController controller}) =>
    ThemeScope(
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
  await tester.pump(MotionDurations.open);
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
          controller: ThemeController(mode: ColorMode.dark),
          child: IconDocPage(onNavigate: (String route) => destination = route),
        ),
      );
      await tester.pump();

      // Article mounts.
      expect(
        find.byKey(const ValueKey<String>('icon-doc-article')),
        findsOneWidget,
      );

      // Icon specimens mount at every IconSize rung.
      final List<Icon> icons = tester
          .widgetList<Icon>(find.byType(Icon))
          .toList();
      expect(icons.length, greaterThanOrEqualTo(IconSize.values.length));
      final Set<IconSize> mountedSizes = icons.map((Icon i) => i.size).toSet();
      expect(mountedSizes, containsAll(IconSize.values));

      // Every fixed tone (all but inherit) mounts a live specimen.
      final Set<IconTone> mountedTones = icons.map((Icon i) => i.tone).toSet();
      for (final IconTone tone in IconTone.values) {
        if (tone == IconTone.inherit) continue;
        expect(
          mountedTones,
          contains(tone),
          reason: 'IconTone.${tone.name} has no live specimen',
        );
      }

      // The lucide-registry constructor is demonstrated live.
      final List<Icon> lucideIcons = icons
          .where((Icon i) => i.lucide != null)
          .toList();
      expect(lucideIcons, isNotEmpty, reason: 'no Icon.lucide specimen');

      // Metadata reads correctly.
      expect(iconDoc.name, 'icon');
      expect(iconDoc.dependencies, <String>['source-foundation']);
      expect(
        iconDoc.exports,
        containsAll(<String>['Icon', 'IconGlyph', 'IconSize']),
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
      expect(
        sections.map((DocsSection section) => section.title).toList(),
        <String>[
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
        ],
      );

      // spinner and rule content no longer renders on this page.
      expect(find.byType(Spinner), findsNothing);
      expect(find.textContaining('ValidationRule'), findsNothing);
    });

    testWidgets('the page is declared, and every section is a kit component', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 4000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _harness(
          controller: ThemeController(mode: ColorMode.dark),
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
    });

    testWidgets(
      'renders at narrow width with the anchor strip instead of a rail',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ThemeController(mode: ColorMode.dark),
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

      final ThemeController controller = ThemeController(mode: ColorMode.dark);

      await tester.pumpWidget(
        _harness(controller: controller, child: const IconDocPage()),
      );

      final List<Icon> darkIcons = tester
          .widgetList<Icon>(find.byType(Icon))
          .toList();
      expect(darkIcons.length, greaterThan(0));

      controller.setMode(ColorMode.light);
      await tester.pump();

      final List<Icon> lightIcons = tester
          .widgetList<Icon>(find.byType(Icon))
          .toList();
      expect(lightIcons.length, equals(darkIcons.length));
    });

    testWidgets('Icon.pxFor, strokeFor and colorFor resolve as documented', (
      WidgetTester tester,
    ) async {
      // Verifies the API table's own claims against the real static
      // methods, not just against rendered prose.
      expect(Icon.pxFor(IconSize.xs), 12);
      expect(Icon.pxFor(IconSize.sm), 14);
      expect(Icon.pxFor(IconSize.md), 16);
      expect(Icon.pxFor(IconSize.lg), 20);
      expect(Icon.pxFor(IconSize.xl), 24);
      expect(Icon.pxFor(IconSize.xl2), 32);
      expect(Icon.pxFor(IconSize.xl3), 40);

      // scaled = 48 / px: above 2.6 -> 2.4, below 1.5 -> 1.6, else 2.
      expect(Icon.strokeFor(16), 2.4); // 48/16 = 3.0 > 2.6
      expect(Icon.strokeFor(32), 2.0); // 48/32 = 1.5, not < 1.5
      expect(Icon.strokeFor(40), 1.6); // 48/40 = 1.2 < 1.5
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
            controller: ThemeController(mode: ColorMode.dark),
            child: const IconDocPage(),
          ),
        );
        await tester.pump();

        expect(find.textContaining('icon_paths.g.index.dart'), findsWidgets);
        expect(find.byType(DocsInstall), findsOneWidget);
      },
    );

    testWidgets('keyboard section documents Icon has no focus of its own', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _harness(
          controller: ThemeController(mode: ColorMode.dark),
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
