import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/voice_orb/meta.dart';
import 'package:example/components_docs/voice_orb/page.dart';
import 'package:example/docs/component_doc_page.dart' show DocsTocEntry;
import 'package:example/docs/docs_disclosure.dart';
import 'package:example/docs/docs_install.dart';
import 'package:example/docs/docs_section.dart' show DocsSection;
import 'package:example/docs/docs_showcase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

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

/// Every named constructor parameter `ElVoiceOrb` declares
/// (`lib/src/effects/voice_orb.dart`), excluding `key`.
const List<String> _voiceOrbParams = <String>['state', 'level', 'size', 'seed'];

const List<String> _specimenKeys = <String>[
  'voice-orb-preview:idle',
  'voice-orb-preview:listening',
  'voice-orb-preview:thinking',
  'voice-orb-preview:talking',
  'voice-orb-example:level-rest',
  'voice-orb-example:level-loud',
  'voice-orb-example:size-sm',
  'voice-orb-example:size-default',
  'voice-orb-example:size-lg',
];

void main() {
  group('voice-orb docs page', () {
    testWidgets(
      'renders the article, the full API table, and a live specimen of '
      'every ElOrbState this page claims to show',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        String? destination;
        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: VoiceOrbDocPage(
              onNavigate: (String route) => destination = route,
            ),
          ),
        );
        // One frame only: the shader ticker, once loaded, runs forever and
        // must never be settled on.
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('voice-orb-doc-article')),
          findsOneWidget,
        );

        final Finder apiTrigger = _disclosureTrigger('API Reference');
        await tester.ensureVisible(apiTrigger);
        await tester.pump();
        await tester.tap(apiTrigger);
        await tester.pump();
        await tester.pump(ElDurations.jelly);

        for (final String param in _voiceOrbParams) {
          expect(find.text(param), findsWidgets, reason: 'missing $param');
        }
        for (final ElOrbState state in ElOrbState.values) {
          expect(
            find.text(state.name),
            findsWidgets,
            reason: 'ElOrbState.${state.name} missing from API table',
          );
        }
        for (final String member in <String>[
          'ElOrbProgram.load()',
          'ElOrbProgram.loaded',
          'ElOrbProgram.lastError',
          'ElOrbProgram.resetForTest()',
        ]) {
          expect(
            find.text(member),
            findsWidgets,
            reason: 'missing $member',
          );
        }

        for (final String key in _specimenKeys) {
          expect(
            find.byKey(ValueKey<String>(key)),
            findsOneWidget,
            reason: 'missing example specimen $key',
          );
        }

        // A live ElVoiceOrb of every ElOrbState mounts, this page's own
        // promise, not just the API table's prose.
        final Set<ElOrbState> mountedStates = tester
            .widgetList<ElVoiceOrb>(find.byType(ElVoiceOrb))
            .map((ElVoiceOrb orb) => orb.state)
            .toSet();
        expect(mountedStates, containsAll(ElOrbState.values));

        final ElVoiceOrb loudOrb = tester.widget<ElVoiceOrb>(
          find.descendant(
            of: find.byKey(
              const ValueKey<String>('voice-orb-example:level-loud'),
            ),
            matching: find.byType(ElVoiceOrb),
          ),
        );
        expect(loudOrb.level, isNotNull);
        expect(loudOrb.level!.value, 0.8);

        final ElVoiceOrb smallOrb = tester.widget<ElVoiceOrb>(
          find.descendant(
            of: find.byKey(
              const ValueKey<String>('voice-orb-example:size-sm'),
            ),
            matching: find.byType(ElVoiceOrb),
          ),
        );
        expect(smallOrb.size, 48);

        final ElVoiceOrb largeOrb = tester.widget<ElVoiceOrb>(
          find.descendant(
            of: find.byKey(
              const ValueKey<String>('voice-orb-example:size-lg'),
            ),
            matching: find.byType(ElVoiceOrb),
          ),
        );
        expect(largeOrb.size, 160);

        expect(voiceOrbDoc.name, 'voice_orb');
        expect(
          voiceOrbDoc.exports,
          containsAll(<String>['ElOrbState', 'ElOrbProgram', 'ElVoiceOrb']),
        );
        expect(voiceOrbDoc.command, 'elattar add voice-orb');
        expect(destination, isNull);
      },
    );

    testWidgets(
      'the page is declared, and every section is a kit component',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 4000);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: const VoiceOrbDocPage(),
          ),
        );
        await tester.pump();

        // Three specimen stages: Preview, Level, Size.
        expect(find.byType(DocsShowcase), findsNWidgets(3));
        expect(find.byType(DocsInstall), findsOneWidget);
        expect(find.byType(DocsDisclosure), findsNWidgets(8));
      },
    );

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
          controller: ElThemeController(mode: ElThemeMode.dark),
          child: const VoiceOrbDocPage(),
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
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: const VoiceOrbDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('voice-orb-doc-article')),
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

        final ElThemeController controller = ElThemeController(
          mode: ElThemeMode.dark,
        );
        await tester.pumpWidget(
          _harness(controller: controller, child: const VoiceOrbDocPage()),
        );
        await tester.pump();

        final ElThemeData darkTheme = ElTheme.of(
          tester.element(
            find.byKey(const ValueKey<String>('voice-orb-doc-article')),
          ),
        );

        controller.setMode(ElThemeMode.light);
        await tester.pump();

        final ElThemeData lightTheme = ElTheme.of(
          tester.element(
            find.byKey(const ValueKey<String>('voice-orb-doc-article')),
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
