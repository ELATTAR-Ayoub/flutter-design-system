import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/voice/meta.dart';
import 'package:example/components_docs/voice/page.dart';
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

/// The single `DocsDisclosure` whose title is [title]. Matches the
/// convention `button_test.dart` establishes: `DocsDisclosure.triggerKey`
/// is one constant shared by every instance on the page.
Finder _disclosureTrigger(String title) => find.descendant(
  of: find.byWidgetPredicate(
    (Widget widget) => widget is DocsDisclosure && widget.title == title,
  ),
  matching: find.byKey(DocsDisclosure.triggerKey),
);

/// Every named constructor parameter each exported widget declares
/// (`lib/src/components/voice.dart`), excluding `key`.
const List<String> _liveWaveformParams = <String>['samples', 'width', 'height'];
const List<String> _barVisualizerParams = <String>[
  'spectrum',
  'active',
  'bars',
  'width',
  'height',
];
const List<String> _micControlParams = <String>[
  'listening',
  'onToggle',
  'disabled',
];

const List<String> _specimenKeys = <String>[
  'voice-preview:mic',
  'voice-preview:waveform',
  'voice-preview:bars',
  'voice-example:waveform-default',
  'voice-example:waveform-wide',
  'voice-example:bars-floor',
  'voice-example:bars-active',
  'voice-example:mic-idle',
  'voice-example:mic-listening',
  'voice-example:mic-disabled',
];

void main() {
  group('voice docs page', () {
    testWidgets(
      'renders the article, the full API table, and a live specimen of '
      'every state this page claims to show',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        String? destination;
        await tester.pumpWidget(
          _harness(
            controller: ThemeController(mode: ColorMode.dark),
            child: VoiceDocPage(
              onNavigate: (String route) => destination = route,
            ),
          ),
        );
        // One frame is enough: nothing here settles, and the listening mic
        // pill and the active bar visualiser both loop forever.
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('voice-doc-article')),
          findsOneWidget,
        );

        final Finder apiTrigger = _disclosureTrigger('API Reference');
        await tester.ensureVisible(apiTrigger);
        await tester.pump();
        await tester.tap(apiTrigger);
        await tester.pump();
        await tester.pump(MotionDurations.open);

        for (final String param in <String>[
          ..._liveWaveformParams,
          ..._barVisualizerParams,
          ..._micControlParams,
        ]) {
          expect(find.text(param), findsWidgets, reason: 'missing $param');
        }

        for (final String key in _specimenKeys) {
          expect(
            find.byKey(ValueKey<String>(key)),
            findsOneWidget,
            reason: 'missing example specimen $key',
          );
        }

        final MicControl listeningMic = tester.widget<MicControl>(
          find.descendant(
            of: find.byKey(
              const ValueKey<String>('voice-example:mic-listening'),
            ),
            matching: find.byType(MicControl),
          ),
        );
        expect(listeningMic.listening, isTrue);

        final MicControl disabledMic = tester.widget<MicControl>(
          find.descendant(
            of: find.byKey(
              const ValueKey<String>('voice-example:mic-disabled'),
            ),
            matching: find.byType(MicControl),
          ),
        );
        expect(disabledMic.disabled, isTrue);
        expect(disabledMic.listening, isFalse);

        final BarVisualizer activeBars = tester.widget<BarVisualizer>(
          find.descendant(
            of: find.byKey(const ValueKey<String>('voice-example:bars-active')),
            matching: find.byType(BarVisualizer),
          ),
        );
        expect(activeBars.active, isTrue);

        final LiveWaveform wideWaveform = tester.widget<LiveWaveform>(
          find.descendant(
            of: find.byKey(
              const ValueKey<String>('voice-example:waveform-wide'),
            ),
            matching: find.byType(LiveWaveform),
          ),
        );
        expect(wideWaveform.width, 320);
        expect(wideWaveform.height, 48);

        expect(voiceDoc.name, 'voice');
        expect(
          voiceDoc.exports,
          containsAll(<String>['LiveWaveform', 'BarVisualizer', 'MicControl']),
        );
        expect(voiceDoc.command, 'elattar add voice');
        expect(destination, isNull);
      },
    );

    testWidgets('the mic pill toggles listening on tap', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _harness(
          controller: ThemeController(mode: ColorMode.dark),
          child: const VoiceDocPage(),
        ),
      );
      await tester.pump();

      final Finder previewMic = find.byKey(
        const ValueKey<String>('voice-preview:mic'),
      );
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
          child: const VoiceDocPage(),
        ),
      );
      await tester.pump();

      // Four specimen stages: Preview, Live waveform, Bar visualizer,
      // Mic control.
      expect(find.byType(DocsShowcase), findsNWidgets(4));
      expect(find.byType(DocsInstall), findsOneWidget);
      // Eight collapsed sections: API Reference, States, Accessibility,
      // Keyboard, Responsive, Dependencies, Theming, Source.
      expect(find.byType(DocsDisclosure), findsNWidgets(8));
    });

    test('the table of contents matches the declared sections', () {
      expect(
        voiceDocSpec.toc.map((DocsTocEntry entry) => entry.title).toList(),
        <String>[
          'Preview',
          'Installation',
          'Usage',
          'Live waveform',
          'Bar visualizer',
          'Mic control',
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
          child: const VoiceDocPage(),
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
        'Live waveform',
        'Bar visualizer',
        'Mic control',
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
            child: const VoiceDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('voice-doc-article')),
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
          _harness(controller: controller, child: const VoiceDocPage()),
        );
        await tester.pump();

        final ThemeTokens darkTheme = ThemeScope.of(
          tester.element(
            find.byKey(const ValueKey<String>('voice-doc-article')),
          ),
        );

        // The SAME controller, flipped in place, one pump only: the
        // listening mic pill and the active bar visualiser both loop
        // forever and must never be settled on.
        controller.setMode(ColorMode.light);
        await tester.pump();

        final ThemeTokens lightTheme = ThemeScope.of(
          tester.element(
            find.byKey(const ValueKey<String>('voice-doc-article')),
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
