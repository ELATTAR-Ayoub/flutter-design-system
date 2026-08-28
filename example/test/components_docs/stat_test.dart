import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/stat/meta.dart';
import 'package:example/components_docs/stat/page.dart';
import 'package:example/docs/component_doc_page.dart' show DocsTocEntry;
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

Widget _harness({required Widget child, required ThemeController controller}) =>
    ThemeScope(
      controller: controller,
      child: MaterialApp(home: SingleChildScrollView(child: child)),
    );

/// The single `DocsDisclosure` whose title is [title].
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
  group('stat docs page', () {
    testWidgets(
      'renders the article, the full API tables, and live specimens of Stat',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        String? destination;
        await tester.pumpWidget(
          _harness(
            controller: ThemeController(mode: ColorMode.dark),
            child: StatDocPage(
              onNavigate: (String route) => destination = route,
            ),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('stat-doc-article')),
          findsOneWidget,
        );

        expect(find.byType(Stat), findsWidgets);
        // item/empty/kbd are their own pages now: no live specimens here.
        expect(find.byType(Item), findsNothing);
        expect(find.byType(Empty), findsNothing);
        expect(find.byType(Kbd), findsNothing);

        await _open(tester, 'API Reference');
        await _open(tester, 'Accessibility');

        final List<String> disclosureTitles = tester
            .widgetList<DocsDisclosure>(find.byType(DocsDisclosure))
            .map((DocsDisclosure d) => d.title)
            .toList();
        expect(disclosureTitles, contains('API Reference'));
        expect(disclosureTitles, contains('Accessibility'));

        expect(statDoc.name, 'stat');
        expect(statDoc.command, 'elattar add stat');
        expect(
          statDoc.exports,
          containsAll(<String>[
            'Stat',
            'StatDirection',
            'StatState',
            'StatDeltaMark',
          ]),
        );
        expect(destination, isNull);
        expect(tester.takeException(), isNull);
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
            controller: ThemeController(mode: ColorMode.dark),
            child: const StatDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('stat-doc-article')),
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

    testWidgets('stat delta direction uses glyph, sign, and sr-only word', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final ThemeController controller = ThemeController(mode: ColorMode.light);
      await tester.pumpWidget(
        _harness(controller: controller, child: const StatDocPage()),
      );
      await tester.pump();

      final Stat stat = tester.widget<Stat>(find.byType(Stat).first);
      expect(stat.delta, isNotNull, reason: 'expected a specimen with delta');

      expect(
        find.byType(StatDeltaMark),
        findsWidgets,
        reason: 'delta mark is rendered',
      );
    });

    testWidgets('stat renders correctly in every StatState', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _harness(
          controller: ThemeController(mode: ColorMode.dark),
          child: const StatDocPage(),
        ),
      );
      await tester.pump();

      for (final StatState state in StatState.values) {
        expect(
          find.byWidgetPredicate((Widget w) => w is Stat && w.state == state),
          findsWidgets,
          reason: 'missing a $state specimen',
        );
      }
    });

    testWidgets(
      'components render correctly in both themes at both breakpoints',
      (WidgetTester tester) async {
        for (final Size size in <Size>[
          const Size(390, 844),
          const Size(1440, 900),
        ]) {
          for (final ColorMode mode in <ColorMode>[
            ColorMode.light,
            ColorMode.dark,
          ]) {
            tester.view.physicalSize = size;
            tester.view.devicePixelRatio = 1;
            addTearDown(tester.view.reset);

            final ThemeController controller = ThemeController(mode: mode);
            await tester.pumpWidget(
              _harness(controller: controller, child: const StatDocPage()),
            );
            await tester.pump();

            expect(
              find.byKey(const ValueKey<String>('stat-doc-article')),
              findsOneWidget,
              reason: 'at $size in $mode',
            );

            expect(find.byType(Stat), findsWidgets);
          }
        }
      },
    );

    test('the table of contents matches the declared sections', () {
      expect(
        statDocSpec.toc.map((DocsTocEntry entry) => entry.title).toList(),
        <String>[
          'Preview',
          'Installation',
          'Usage',
          'Composition',
          'Delta and direction',
          'Loading, error, and empty',
          'RTL',
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
    });

    testWidgets(
      'renders the ours-only section list, in order: Preview, Installation, '
      'Usage, then stat\'s own sections, then the eight required disclosures',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ThemeController(mode: ColorMode.dark),
            child: const StatDocPage(),
          ),
        );
        await tester.pump();

        final List<DocsSection> sections = tester
            .widgetList<DocsSection>(find.byType(DocsSection))
            .toList();
        final List<String> sectionIds = sections
            .map((DocsSection section) => section.id)
            .toList();
        final List<String> sectionTitles = sections
            .map((DocsSection section) => section.title)
            .toList();

        expect(sectionIds, <String>[
          'preview',
          'install',
          'usage',
          'composition',
          'delta',
          'states-demo',
          'rtl',
          'api',
          'states',
          'accessibility',
          'keyboard',
          'responsive',
          'dependencies',
          'theming',
          'source',
        ]);

        expect(sectionTitles, isNot(contains('Item: Variant')));
        expect(sectionTitles, isNot(contains('Empty: Input group')));
        expect(sectionTitles, isNot(contains('Kbd: Group')));

        expect(
          sectionTitles,
          containsAll(<String>[
            'Preview',
            'Composition',
            'Delta and direction',
            'Loading, error, and empty',
            'RTL',
            'API Reference',
            'States',
            'Accessibility',
            'Keyboard',
            'Responsive',
            'Dependencies',
            'Theming',
            'Source',
          ]),
        );

        // Five specimen stages: Preview, Composition, Delta and direction,
        // Loading/error/empty, RTL.
        expect(find.byType(DocsShowcase), findsNWidgets(5));
        expect(find.byType(DocsInstall), findsOneWidget);
        expect(find.byType(DocsDisclosure), findsNWidgets(8));
      },
    );
  });
}
