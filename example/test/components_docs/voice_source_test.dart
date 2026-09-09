import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/voice_source/meta.dart';
import 'package:example/components_docs/voice_source/page.dart';
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

/// The single `DocsDisclosure` whose title is [title]. Matches the
/// convention `voice_test.dart` establishes.
Finder _disclosureTrigger(String title) => find.descendant(
  of: find.byWidgetPredicate(
    (Widget widget) => widget is DocsDisclosure && widget.title == title,
  ),
  matching: find.byKey(DocsDisclosure.triggerKey),
);

const List<String> _apiNames = <String>[
  'status',
  'samples',
  'spectrum',
  'start()',
  'stop()',
  'dispose()',
  'createVoiceSource',
];

const List<String> _stateNames = <String>[
  'idle',
  'requesting',
  'active',
  'denied',
  'unavailable',
  'error',
];

void main() {
  group('voice-source docs page', () {
    testWidgets(
      'renders the article, the full API table and every state row this '
      'page claims to show',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        String? destination;
        await tester.pumpWidget(
          _harness(
            controller: ThemeController(mode: ColorMode.dark),
            child: VoiceSourceDocPage(
              onNavigate: (String route) => destination = route,
            ),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('voice-source-doc-article')),
          findsOneWidget,
        );

        final Finder apiTrigger = _disclosureTrigger('API Reference');
        await tester.ensureVisible(apiTrigger);
        await tester.pump();
        await tester.tap(apiTrigger);
        await tester.pump();
        await tester.pump(MotionDurations.open);

        for (final String name in _apiNames) {
          expect(find.text(name), findsWidgets, reason: 'missing $name');
        }

        final Finder statesTrigger = _disclosureTrigger('States');
        await tester.ensureVisible(statesTrigger);
        await tester.pump();
        await tester.tap(statesTrigger);
        await tester.pump();
        await tester.pump(MotionDurations.open);

        for (final String state in _stateNames) {
          expect(find.text(state), findsOneWidget, reason: 'missing $state');
        }

        expect(voiceSourceDoc.name, 'voice_source');
        expect(
          voiceSourceDoc.exports,
          containsAll(<String>[
            'VoiceSource',
            'VoiceSourceStatus',
            'createVoiceSource',
          ]),
        );
        expect(voiceSourceDoc.command, 'elattar add voice-source');
        expect(destination, isNull);
      },
    );

    testWidgets('pressing the demo mic arms it and drives the waveform', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _harness(
          controller: ThemeController(mode: ColorMode.dark),
          child: const VoiceSourceDocPage(),
        ),
      );
      await tester.pump();

      final Finder previewMic = find.byKey(
        const ValueKey<String>('voice-source-preview:mic'),
      );
      await tester.ensureVisible(previewMic);
      await tester.pump();
      expect(
        tester
            .widget<MicControl>(
              find.descendant(
                of: previewMic,
                matching: find.byType(MicControl),
              ),
            )
            .listening,
        isFalse,
      );

      await tester.tap(previewMic);
      await tester.pump();

      expect(
        tester
            .widget<MicControl>(
              find.descendant(
                of: previewMic,
                matching: find.byType(MicControl),
              ),
            )
            .listening,
        isTrue,
      );

      // Let the demo source's Timer.periodic emit at least one frame.
      await tester.pump(MotionDurations.tick);
      await tester.pump(MotionDurations.tick);

      // Tap again to stop and cancel the timer before the widget unmounts.
      await tester.tap(previewMic);
      await tester.pump();
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
          child: const VoiceSourceDocPage(),
        ),
      );
      await tester.pump();

      // One EffectSection stage (Preview, rendered as a DocsShowcase).
      expect(find.byType(DocsShowcase), findsOneWidget);
      expect(find.byType(DocsInstall), findsOneWidget);
      // Eight collapsed sections: API Reference, States, Accessibility,
      // Keyboard, Responsive, Dependencies, Theming, Source.
      expect(find.byType(DocsDisclosure), findsNWidgets(8));

      // Stop the demo source's timer, if armed, before the tree tears down.
      final Finder previewMic = find.byKey(
        const ValueKey<String>('voice-source-preview:mic'),
      );
      if (tester
          .widget<MicControl>(
            find.descendant(of: previewMic, matching: find.byType(MicControl)),
          )
          .listening) {
        await tester.tap(previewMic);
        await tester.pump();
      }
    });

    test('the table of contents matches the declared sections', () {
      expect(
        voiceSourceDocSpec.toc.map((DocsTocEntry entry) => entry.title).toList(),
        <String>[
          'Preview',
          'Installation',
          'Usage',
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
          child: const VoiceSourceDocPage(),
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
            child: const VoiceSourceDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('voice-source-doc-article')),
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
  });
}
