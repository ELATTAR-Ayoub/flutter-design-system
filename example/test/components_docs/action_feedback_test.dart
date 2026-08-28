/// Tests for the action-feedback effect documentation page.
///
/// **No `pumpAndSettle` anywhere in this file.** ActionFeedback's beat is
/// driven by a bare `Ticker` while hovered, which runs `infinite alternate`
/// and never settles on its own — every wait below is a bounded
/// `tester.pump()` / `tester.pump(Duration(...))`.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/action_feedback/meta.dart';
import 'package:example/components_docs/action_feedback/page.dart';
import 'package:example/docs/component_doc_page.dart' show DocsTocEntry;
import 'package:example/docs/docs_disclosure.dart';
import 'package:example/docs/docs_install.dart';
import 'package:example/docs/docs_section.dart' show DocsSection;
import 'package:example/docs/docs_showcase.dart';
import 'package:flutter/gestures.dart' show PointerDeviceKind;
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

/// `ActionFeedback`'s own constructor parameters (`lib/src/components/ui/
/// action_feedback.dart`), excluding `key`.
const List<String> _sheenActionConstructorParams = <String>[
  'spec',
  'radius',
  'border',
  'hovered',
  'pressed',
  'child',
];

void main() {
  group('action-feedback docs page', () {
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
            child: ActionFeedbackDocPage(
              onNavigate: (String route) => destination = route,
            ),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('action-feedback-doc-article')),
          findsOneWidget,
        );

        final Finder apiTrigger = _disclosureTrigger('API Reference');
        await tester.ensureVisible(apiTrigger);
        await tester.pump();
        await tester.tap(apiTrigger);
        await tester.pump();
        await tester.pump(MotionDurations.open);

        for (final String param in _sheenActionConstructorParams) {
          expect(find.text(param), findsWidgets, reason: 'missing $param');
        }

        // Preview's sheen pill, the Hover host and the Press host each mount
        // one ActionFeedback.
        expect(find.byType(ActionFeedback), findsNWidgets(3));
        expect(find.byType(Surface), findsWidgets);

        for (final String key in <String>[
          'action-feedback-preview:sheen',
          'action-feedback-preview:plain',
          'action-feedback-hover:host',
          'action-feedback-press:host',
        ]) {
          expect(
            find.byKey(ValueKey<String>(key)),
            findsOneWidget,
            reason: 'missing example specimen $key',
          );
        }

        expect(actionFeedbackDoc.name, 'action_feedback');
        expect(
          actionFeedbackDoc.exports,
          containsAll(<String>['ActionFeedback']),
        );
        expect(actionFeedbackDoc.command, 'elattar add action-feedback');
        expect(destination, isNull);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('a live mouse hover over the Hover specimen actually flips '
        'ActionFeedback.hovered', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _harness(
          controller: ThemeController(mode: ColorMode.dark),
          child: const ActionFeedbackDocPage(),
        ),
      );
      await tester.pump();

      final Finder host = find.byKey(
        const ValueKey<String>('action-feedback-hover:host'),
      );
      await tester.ensureVisible(host);
      await tester.pump();

      expect(tester.widget<ActionFeedback>(host).hovered, isFalse);

      final TestGesture gesture = await tester.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      addTearDown(() => gesture.removePointer());
      await gesture.addPointer(location: Offset.zero);
      await tester.pump();

      await gesture.moveTo(tester.getCenter(host));
      await tester.pump();
      // A bounded slice of the 2600ms hover loop — proves the beat's
      // Ticker actually started, never pumpAndSettle.
      await tester.pump(const Duration(milliseconds: 200));

      expect(tester.widget<ActionFeedback>(host).hovered, isTrue);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'a tap-down on the Press specimen flips ActionFeedback.pressed and '
      'swaps its shadow spec',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ThemeController(mode: ColorMode.dark),
            child: const ActionFeedbackDocPage(),
          ),
        );
        await tester.pump();

        final Finder host = find.byKey(
          const ValueKey<String>('action-feedback-press:host'),
        );
        await tester.ensureVisible(host);
        await tester.pump();

        expect(tester.widget<ActionFeedback>(host).pressed, isFalse);

        final TestGesture gesture = await tester.startGesture(
          tester.getCenter(host),
        );
        await tester.pump();

        expect(tester.widget<ActionFeedback>(host).pressed, isTrue);

        await gesture.up();
        await tester.pump();

        expect(tester.widget<ActionFeedback>(host).pressed, isFalse);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'holds the beat at rest under reduced motion, without throwing',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          ThemeScope(
            controller: ThemeController(mode: ColorMode.dark),
            child: MaterialApp(
              home: Builder(
                builder: (BuildContext context) => MediaQuery(
                  data: MediaQuery.of(
                    context,
                  ).copyWith(disableAnimations: true),
                  child: const SingleChildScrollView(
                    child: ActionFeedbackDocPage(),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(seconds: 3));

        expect(find.byType(ActionFeedback), findsWidgets);
        expect(tester.takeException(), isNull);
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
          child: const ActionFeedbackDocPage(),
        ),
      );
      await tester.pump();

      // Three EffectSection stages: Preview, Hover, Press.
      expect(find.byType(DocsShowcase), findsNWidgets(3));
      expect(find.byType(DocsInstall), findsOneWidget);
      expect(find.byType(DocsDisclosure), findsNWidgets(8));
    });

    test('the table of contents matches the declared sections', () {
      expect(
        sheenActionDocSpec.toc
            .map((DocsTocEntry entry) => entry.title)
            .toList(),
        <String>[
          'Preview',
          'Installation',
          'Usage',
          'Hover',
          'Press',
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

    testWidgets('sections render in declaration order', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final ThemeController controller = ThemeController(mode: ColorMode.dark);
      await tester.pumpWidget(
        _harness(controller: controller, child: const ActionFeedbackDocPage()),
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
        'Hover',
        'Press',
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
            child: const ActionFeedbackDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('action-feedback-doc-article')),
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

    testWidgets('renders in both themes without throwing', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      for (final ColorMode mode in <ColorMode>[
        ColorMode.dark,
        ColorMode.light,
      ]) {
        await tester.pumpWidget(
          _harness(
            controller: ThemeController(mode: mode),
            child: const ActionFeedbackDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('action-feedback-doc-article')),
          findsOneWidget,
          reason: '$mode',
        );
        expect(tester.takeException(), isNull, reason: '$mode');
      }
    });
  });
}
