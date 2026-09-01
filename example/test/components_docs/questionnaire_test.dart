import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/questionnaire/meta.dart';
import 'package:example/components_docs/questionnaire/page.dart';
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
      child: MaterialApp(
        home: Builder(
          // The ambient ink every route inherits, as the docs shell sets it
          // for the real app. Without it this subtree sits under WidgetsApp's
          // red fallback style, which StyledText asserts on rather than
          // quietly painting over.
          builder: (BuildContext context) => DefaultTextStyle(
            style: StyledText.styleOf(
              context,
              TextStyles.body,
              color: ThemeScope.of(context).foreground,
            ),
            child: SingleChildScrollView(child: child),
          ),
        ),
      ),
    );

Finder _disclosureTrigger(String title) => find.descendant(
  of: find.byWidgetPredicate(
    (Widget widget) => widget is DocsDisclosure && widget.title == title,
  ),
  matching: find.byKey(DocsDisclosure.triggerKey),
);

/// Every named constructor parameter `Questionnaire` itself declares
/// (`lib/src/components/ui/questionnaire.dart`), excluding `key`.
const List<String> _questionnaireParams = <String>[
  'children',
  'shortcuts',
  'onSubmit',
  'gap',
  'controller',
  'focusNode',
];

const List<String> _specimenKeys = <String>[
  'questionnaire-preview:root',
  'questionnaire-example:choice-unanswered',
  'questionnaire-example:choice-answered',
  'questionnaire-example:choice-skipped',
  'questionnaire-example:choice-invalid',
  'questionnaire-example:text-optional',
  'questionnaire-example:text-invalid',
  'questionnaire-example:shortcuts-letters',
  'questionnaire-example:shortcuts-numbers',
];

void main() {
  group('questionnaire docs page', () {
    testWidgets(
      'renders the article, the full API table, and a live specimen of '
      'every state this page claims to show',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 1200);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        String? destination;
        await tester.pumpWidget(
          _harness(
            controller: ThemeController(mode: ColorMode.dark),
            child: QuestionnaireDocPage(
              onNavigate: (String route) => destination = route,
            ),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('questionnaire-doc-article')),
          findsOneWidget,
        );

        final Finder apiTrigger = _disclosureTrigger('API Reference');
        await tester.ensureVisible(apiTrigger);
        await tester.pump();
        await tester.tap(apiTrigger);
        await tester.pump();
        await tester.pump(MotionDurations.open);

        for (final String param in _questionnaireParams) {
          expect(find.text(param), findsWidgets, reason: 'missing $param');
        }
        for (final QuestionnaireShortcuts value
            in QuestionnaireShortcuts.values) {
          expect(
            find.text(value.name),
            findsWidgets,
            reason: 'QuestionnaireShortcuts.${value.name} missing',
          );
        }

        for (final String key in _specimenKeys) {
          expect(
            find.byKey(ValueKey<String>(key)),
            findsOneWidget,
            reason: 'missing example specimen $key',
          );
        }

        // A live Questionnaire mounts somewhere on the page for every
        // one of the specimen roots above.
        expect(find.byType(Questionnaire), findsNWidgets(_specimenKeys.length));

        expect(questionnaireDoc.name, 'questionnaire');
        expect(
          questionnaireDoc.exports,
          containsAll(<String>[
            'Questionnaire',
            'QuestionnaireShortcuts',
            'QuestionnaireController',
            'QuestionnaireItem',
            'QuestionnaireChoice',
            'QuestionnaireInput',
            'QuestionnaireError',
            'QuestionnaireActions',
            'QuestionnairePrevious',
            'QuestionnaireSkip',
            'QuestionnaireNext',
            'QuestionnaireSubmit',
          ]),
        );
        expect(questionnaireDoc.command, 'elattar add questionnaire');
        expect(destination, isNull);
      },
    );

    testWidgets('the preview wizard answers a choice and advances on Next', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 1200);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _harness(
          controller: ThemeController(mode: ColorMode.dark),
          child: const QuestionnaireDocPage(),
        ),
      );
      await tester.pump();

      // "Question 1 of 3" before anything is answered.
      expect(find.textContaining('Question 1 of 3'), findsWidgets);

      await tester.tap(find.text('Sealed packs and boxes').first);
      await tester.pump();
      await tester.pump(MotionDurations.open);

      await tester.tap(find.text('Next').first);
      await tester.pump();

      expect(find.textContaining('Question 2 of 3'), findsWidgets);
    });

    testWidgets('the page is declared, and every section is a kit component', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 4200);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _harness(
          controller: ThemeController(mode: ColorMode.dark),
          child: const QuestionnaireDocPage(),
        ),
      );
      await tester.pump();

      // Four specimen stages: Preview, Choice states, Text item, Shortcuts.
      expect(find.byType(DocsShowcase), findsNWidgets(4));
      expect(find.byType(DocsInstall), findsOneWidget);
      expect(find.byType(DocsDisclosure), findsNWidgets(8));
    });

    test('the table of contents matches the declared sections', () {
      expect(
        questionnaireDocSpec.toc
            .map((DocsTocEntry entry) => entry.title)
            .toList(),
        <String>[
          'Preview',
          'Installation',
          'Usage',
          'Choice states',
          'Text item',
          'Shortcuts',
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
      tester.view.physicalSize = const Size(1440, 1200);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _harness(
          controller: ThemeController(mode: ColorMode.dark),
          child: const QuestionnaireDocPage(),
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
        'Choice states',
        'Text item',
        'Shortcuts',
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
            child: const QuestionnaireDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('questionnaire-doc-article')),
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
        tester.view.physicalSize = const Size(1440, 1200);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        final ThemeController controller = ThemeController(
          mode: ColorMode.dark,
        );
        await tester.pumpWidget(
          _harness(controller: controller, child: const QuestionnaireDocPage()),
        );
        await tester.pump();

        final ThemeTokens darkTheme = ThemeScope.of(
          tester.element(
            find.byKey(const ValueKey<String>('questionnaire-doc-article')),
          ),
        );

        controller.setMode(ColorMode.light);
        await tester.pump();

        final ThemeTokens lightTheme = ThemeScope.of(
          tester.element(
            find.byKey(const ValueKey<String>('questionnaire-doc-article')),
          ),
        );

        expect(lightTheme.background, isNot(darkTheme.background));
        expect(lightTheme.foreground, isNot(darkTheme.foreground));

        for (final String key in _specimenKeys) {
          expect(find.byKey(ValueKey<String>(key)), findsOneWidget);
        }
      },
    );
  });
}
