import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/content_change/meta.dart';
import 'package:example/components_docs/content_change/page.dart';
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

Finder _disclosureTrigger(String title) => find.descendant(
  of: find.byWidgetPredicate(
    (Widget widget) => widget is DocsDisclosure && widget.title == title,
  ),
  matching: find.byKey(DocsDisclosure.triggerKey),
);

/// Every named constructor parameter `ContentChange`'s own class declares
/// (`lib/src/components/ui/content_change.dart`), excluding `key`.
const List<String> _swapInConstructorParams = <String>['child', 'replayKey'];

void main() {
  group('content-change docs page', () {
    testWidgets(
      'renders the article, the full API table, and every specimen this '
      'page claims to show',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        String? destination;
        await tester.pumpWidget(
          _harness(
            controller: ThemeController(mode: ColorMode.dark),
            child: ContentChangeDocPage(
              onNavigate: (String route) => destination = route,
            ),
          ),
        );
        // One frame: the mount spring plays once on every specimen and must
        // never be settled on.
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('content-change-doc-article')),
          findsOneWidget,
        );

        final Finder apiTrigger = _disclosureTrigger('API Reference');
        await tester.ensureVisible(apiTrigger);
        await tester.pump();
        await tester.tap(apiTrigger);
        await tester.pump();
        await tester.pump(MotionDurations.open);

        for (final String param in _swapInConstructorParams) {
          expect(find.text(param), findsWidgets, reason: 'missing $param');
        }
        expect(find.text('duration'), findsWidgets);
        expect(find.text('curve'), findsWidgets);

        // A live ContentChange specimen mounts on Preview's "Springs in" column,
        // Stat Figure, and both halves of Replay Key: four.
        expect(find.byType(ContentChange), findsNWidgets(4));

        for (final String key in <String>[
          'content-change-preview:springs',
          'content-change-preview:instant',
          'content-change-example:stat-figure',
          'content-change-example:replay-keyed',
          'content-change-example:replay-unkeyed',
        ]) {
          expect(
            find.byKey(ValueKey<String>(key)),
            findsOneWidget,
            reason: 'missing example specimen $key',
          );
        }

        expect(contentChangeDoc.name, 'content_change');
        expect(
          contentChangeDoc.exports,
          containsAll(<String>['ContentChange']),
        );
        expect(contentChangeDoc.command, 'elattar add content-change');
        expect(destination, isNull);
      },
    );

    testWidgets(
      'the keyed specimen changes its replayKey and the unkeyed one keeps '
      'null, exactly as the section claims',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ThemeController(mode: ColorMode.dark),
            child: const ContentChangeDocPage(),
          ),
        );
        await tester.pump();

        final Finder keyed = find.descendant(
          of: find.byKey(
            const ValueKey<String>('content-change-example:replay-keyed'),
          ),
          matching: find.byType(ContentChange),
        );
        final Finder unkeyed = find.descendant(
          of: find.byKey(
            const ValueKey<String>('content-change-example:replay-unkeyed'),
          ),
          matching: find.byType(ContentChange),
        );

        expect(tester.widget<ContentChange>(unkeyed).replayKey, isNull);
        final Object? before = tester.widget<ContentChange>(keyed).replayKey;

        final Finder changeBoth = find.widgetWithText(Button, 'Change both');
        await tester.ensureVisible(changeBoth);
        await tester.pump();
        await tester.tap(changeBoth);
        // A fraction of the spring's own 250ms (MotionDurations.normal): enough
        // to prove the key actually changed, never `pumpAndSettle`.
        await tester.pump(const Duration(milliseconds: 40));

        expect(tester.widget<ContentChange>(keyed).replayKey, isNot(before));
        expect(tester.widget<ContentChange>(unkeyed).replayKey, isNull);
      },
    );

    testWidgets('the page is declared, and every section is a kit component', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 4000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _harness(
          controller: ThemeController(mode: ColorMode.dark),
          child: const ContentChangeDocPage(),
        ),
      );
      await tester.pump();

      // Three EffectSection stages: Preview, Stat Figure, Replay Key.
      expect(find.byType(DocsShowcase), findsNWidgets(3));
      expect(find.byType(DocsInstall), findsOneWidget);
      expect(find.byType(DocsDisclosure), findsNWidgets(8));
    });

    test('the table of contents matches the declared sections', () {
      expect(
        swapInDocSpec.toc.map((DocsTocEntry entry) => entry.title).toList(),
        <String>[
          'Preview',
          'Installation',
          'Usage',
          'Stat Figure',
          'Replay Key',
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

    testWidgets('sections render in declaration order, section for section', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _harness(
          controller: ThemeController(mode: ColorMode.dark),
          child: const ContentChangeDocPage(),
        ),
      );
      await tester.pump();

      final List<String> titles = tester
          .widgetList<DocsSection>(find.byType(DocsSection))
          .map((DocsSection section) => section.title)
          .toList();

      expect(titles, <String>[
        'Preview',
        'Installation',
        'Usage',
        'Stat Figure',
        'Replay Key',
        'API Reference',
        'States',
        'Accessibility',
        'Keyboard',
        'Responsive',
        'Dependencies',
        'Theming',
        'Source',
      ]);
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
            child: const ContentChangeDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('content-change-doc-article')),
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

    testWidgets(
      'survives a live theme flip in place, at desktop width, without '
      'losing any example specimen',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        final ThemeController controller = ThemeController(
          mode: ColorMode.dark,
        );
        await tester.pumpWidget(
          _harness(controller: controller, child: const ContentChangeDocPage()),
        );
        await tester.pump();

        final ThemeTokens darkTheme = ThemeScope.of(
          tester.element(
            find.byKey(const ValueKey<String>('content-change-doc-article')),
          ),
        );

        controller.setMode(ColorMode.light);
        await tester.pump();

        final ThemeTokens lightTheme = ThemeScope.of(
          tester.element(
            find.byKey(const ValueKey<String>('content-change-doc-article')),
          ),
        );

        expect(lightTheme.background, isNot(darkTheme.background));
        expect(lightTheme.foreground, isNot(darkTheme.foreground));

        for (final String key in <String>[
          'content-change-preview:springs',
          'content-change-preview:instant',
          'content-change-example:stat-figure',
          'content-change-example:replay-keyed',
          'content-change-example:replay-unkeyed',
        ]) {
          expect(find.byKey(ValueKey<String>(key)), findsOneWidget);
        }
      },
    );
  });
}
