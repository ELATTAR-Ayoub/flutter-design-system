import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/voice_indicator/meta.dart';
import 'package:example/components_docs/voice_indicator/page.dart';
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

/// Every named constructor parameter `VoiceIndicator` declares
/// (`lib/src/components/ui/voice_indicator.dart`), excluding `key`.
const List<String> _voiceOrbParams = <String>['state', 'level', 'size', 'seed'];

const List<String> _specimenKeys = <String>[
  'voice-indicator-preview:idle',
  'voice-indicator-preview:listening',
  'voice-indicator-preview:thinking',
  'voice-indicator-preview:talking',
  'voice-indicator-example:level-rest',
  'voice-indicator-example:level-loud',
  'voice-indicator-example:size-sm',
  'voice-indicator-example:size-default',
  'voice-indicator-example:size-lg',
];

void main() {
  group('voice-indicator docs page', () {
    testWidgets(
      'renders the article, the full API table, and a live specimen of '
      'every VoiceIndicatorState this page claims to show',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        String? destination;
        await tester.pumpWidget(
          _harness(
            controller: ThemeController(mode: ColorMode.dark),
            child: VoiceIndicatorDocPage(
              onNavigate: (String route) => destination = route,
            ),
          ),
        );
        // One frame only: the shader ticker, once loaded, runs forever and
        // must never be settled on.
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('voice-indicator-doc-article')),
          findsOneWidget,
        );

        final Finder apiTrigger = _disclosureTrigger('API Reference');
        await tester.ensureVisible(apiTrigger);
        await tester.pump();
        await tester.tap(apiTrigger);
        await tester.pump();
        await tester.pump(MotionDurations.open);

        for (final String param in _voiceOrbParams) {
          expect(find.text(param), findsWidgets, reason: 'missing $param');
        }
        for (final VoiceIndicatorState state in VoiceIndicatorState.values) {
          expect(
            find.text(state.name),
            findsWidgets,
            reason: 'VoiceIndicatorState.${state.name} missing from API table',
          );
        }
        for (final String member in <String>[
          'VoiceIndicatorProgram.load()',
          'VoiceIndicatorProgram.loaded',
          'VoiceIndicatorProgram.lastError',
          'VoiceIndicatorProgram.resetForTest()',
        ]) {
          expect(find.text(member), findsWidgets, reason: 'missing $member');
        }

        for (final String key in _specimenKeys) {
          expect(
            find.byKey(ValueKey<String>(key)),
            findsOneWidget,
            reason: 'missing example specimen $key',
          );
        }

        // A live VoiceIndicator of every VoiceIndicatorState mounts, this page's own
        // promise, not just the API table's prose.
        final Set<VoiceIndicatorState> mountedStates = tester
            .widgetList<VoiceIndicator>(find.byType(VoiceIndicator))
            .map((VoiceIndicator orb) => orb.state)
            .toSet();
        expect(mountedStates, containsAll(VoiceIndicatorState.values));

        final VoiceIndicator loudOrb = tester.widget<VoiceIndicator>(
          find.descendant(
            of: find.byKey(
              const ValueKey<String>('voice-indicator-example:level-loud'),
            ),
            matching: find.byType(VoiceIndicator),
          ),
        );
        expect(loudOrb.level, isNotNull);
        expect(loudOrb.level!.value, 0.8);

        final VoiceIndicator smallOrb = tester.widget<VoiceIndicator>(
          find.descendant(
            of: find.byKey(
              const ValueKey<String>('voice-indicator-example:size-sm'),
            ),
            matching: find.byType(VoiceIndicator),
          ),
        );
        expect(smallOrb.size, 48);

        final VoiceIndicator largeOrb = tester.widget<VoiceIndicator>(
          find.descendant(
            of: find.byKey(
              const ValueKey<String>('voice-indicator-example:size-lg'),
            ),
            matching: find.byType(VoiceIndicator),
          ),
        );
        expect(largeOrb.size, 160);

        expect(voiceIndicatorDoc.name, 'voice_indicator');
        expect(
          voiceIndicatorDoc.exports,
          containsAll(<String>[
            'VoiceIndicatorState',
            'VoiceIndicatorProgram',
            'VoiceIndicator',
          ]),
        );
        expect(voiceIndicatorDoc.command, 'elattar add voice-indicator');
        expect(destination, isNull);
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
          child: const VoiceIndicatorDocPage(),
        ),
      );
      await tester.pump();

      // Three specimen stages: Preview, Level, Size.
      expect(find.byType(DocsShowcase), findsNWidgets(3));
      expect(find.byType(DocsInstall), findsOneWidget);
      expect(find.byType(DocsDisclosure), findsNWidgets(8));
    });

    test('the table of contents matches the declared sections', () {
      expect(
        voiceOrbDocSpec.toc.map((DocsTocEntry entry) => entry.title).toList(),
        <String>[
          'Preview',
          'Installation',
          'Usage',
          'Level',
          'Size',
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

      await tester.pumpWidget(
        _harness(
          controller: ThemeController(mode: ColorMode.dark),
          child: const VoiceIndicatorDocPage(),
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
        'Level',
        'Size',
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
            child: const VoiceIndicatorDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('voice-indicator-doc-article')),
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
          _harness(
            controller: controller,
            child: const VoiceIndicatorDocPage(),
          ),
        );
        await tester.pump();

        final ThemeTokens darkTheme = ThemeScope.of(
          tester.element(
            find.byKey(const ValueKey<String>('voice-indicator-doc-article')),
          ),
        );

        controller.setMode(ColorMode.light);
        await tester.pump();

        final ThemeTokens lightTheme = ThemeScope.of(
          tester.element(
            find.byKey(const ValueKey<String>('voice-indicator-doc-article')),
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
