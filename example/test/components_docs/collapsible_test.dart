/// Tests for `components_docs/collapsible/page.dart`'s [CollapsibleDocPage]
/// — the public documentation page for `Collapsible` (and the [Unfold]
/// animation it shares with `Accordion`).
///
/// Re-housed onto the kit alongside the page: the section-order test now
/// reads `DocsSection.id`, and the API-table / state-matrix reads open the
/// relevant `DocsDisclosure` first — closed by default, unlike the old
/// page's always-visible `Section`.
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never synthetic `MediaQuery` for
/// layout. Motion is frozen through `MediaQuery(disableAnimations: true)`,
/// mounted below `MaterialApp` so it reaches every descendant `Unfold`,
/// rather than pumping `MotionDurations.open` / `MotionDurations.normal` by hand. No
/// `pumpAndSettle` anywhere, per the rollout brief: `tester.pump()` (motion
/// is already disabled, so a single frame settles any tween).
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/collapsible/meta.dart';
import 'package:example/components_docs/collapsible/page.dart'
    show CollapsibleDocPage, collapsibleDocSpec;
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

/// The house-shape section order this page must render, top to bottom.
const List<String> _expectedSectionOrder = <String>[
  'preview',
  'install',
  'usage',
  'composition',
  'independent-instances',
  'api',
  'states',
  'accessibility',
  'keyboard',
  'responsive',
  'dependencies',
  'theming',
  'source',
];

const Size _wide = Size(1440, 900);
const Size _narrow = Size(390, 844);

/// The single `DocsDisclosure` whose title is [title].
Finder _disclosureTrigger(String title) => find.descendant(
  of: find.byWidgetPredicate(
    (Widget widget) => widget is DocsDisclosure && widget.title == title,
  ),
  matching: find.byKey(DocsDisclosure.triggerKey),
);

Future<ThemeController> _pumpCollapsible(
  WidgetTester tester, {
  Size size = _wide,
  ColorMode mode = ColorMode.dark,
  ValueChanged<String>? onNavigate,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final ThemeController theme = ThemeController(mode: mode);
  addTearDown(theme.dispose);

  await tester.pumpWidget(
    ThemeScope(
      controller: theme,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Builder(
          builder: (BuildContext context) => MediaQuery(
            data: MediaQuery.of(context).copyWith(disableAnimations: true),
            child: Scaffold(
              body: SingleChildScrollView(
                child: CollapsibleDocPage(onNavigate: onNavigate),
              ),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  return theme;
}

void main() {
  group('meta', () {
    test('collapsibleDoc names the real public API', () {
      expect(collapsibleDoc.name, 'collapsible');
      expect(collapsibleDoc.route, '/components/collapsible');
      expect(
        collapsibleDoc.sourcePath,
        'lib/src/components/ui/collapsible.dart',
      );
      expect(
        collapsibleDoc.exports,
        containsAll(<String>['Collapsible', 'Unfold']),
      );
      expect(collapsibleDoc.command, 'elattar add collapsible');
    });
  });

  group('page', () {
    testWidgets('renders the house-shape section order top to bottom', (
      WidgetTester tester,
    ) async {
      await _pumpCollapsible(tester, size: const Size(1440, 3600));

      final List<String> ids = tester
          .widgetList<DocsSection>(find.byType(DocsSection))
          .map((DocsSection section) => section.id)
          .toList();

      expect(ids, _expectedSectionOrder);

      // Three specimen stages (Preview, Independent instances), one
      // install section, eight collapsed disclosures. Composition is a
      // SnippetSection, not a showcase: see the page's own library note.
      expect(find.byType(DocsShowcase), findsNWidgets(2));
      expect(find.byType(DocsInstall), findsOneWidget);
      expect(find.byType(DocsDisclosure), findsNWidgets(8));
    });

    testWidgets(
      'renders the article at 1440x900 and flips a live theme controller in place',
      (WidgetTester tester) async {
        final ThemeController theme = await _pumpCollapsible(
          tester,
          size: _wide,
        );

        expect(
          find.byKey(const ValueKey<String>('collapsible-doc-article')),
          findsOneWidget,
        );
        expect(find.text('Collapsible'), findsWidgets);
        expect(
          find.byKey(const ValueKey<String>('docs-layout-sidebar')),
          findsOneWidget,
        );
        expect(find.byType(Collapsible), findsWidgets);
        expect(tester.takeException(), isNull);

        // Same controller, flipped in place rather than rebuilt: dark then
        // light must both render the same tree without throwing.
        theme.setMode(ColorMode.light);
        await tester.pump();
        expect(
          find.byKey(const ValueKey<String>('collapsible-doc-article')),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('exposes narrow anchors and no sidebar at 390x844', (
      WidgetTester tester,
    ) async {
      await _pumpCollapsible(tester, size: _narrow);

      expect(
        find.byKey(const ValueKey<String>('docs-layout-anchor-strip')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('docs-layout-sidebar')),
        findsNothing,
      );
      expect(
        find.byKey(const ValueKey<String>('collapsible-doc-article')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('the API tables document every Collapsible and Unfold '
        'constructor parameter', (WidgetTester tester) async {
      await _pumpCollapsible(tester);

      final Finder apiTrigger = _disclosureTrigger('API Reference');
      await tester.ensureVisible(apiTrigger);
      await tester.tap(apiTrigger);
      await tester.pump();
      await tester.pump(MotionDurations.open);

      // `open` is shared by both Collapsible and Unfold.
      expect(find.text('open'), findsNWidgets(2));
      // Collapsible-only.
      expect(find.text('trigger'), findsOneWidget);
      expect(find.text('content'), findsOneWidget);
      // Unfold-only.
      expect(find.text('child'), findsOneWidget);
    });

    testWidgets(
      'the install section presents the working collapsible CLI command',
      (WidgetTester tester) async {
        await _pumpCollapsible(tester);

        expect(find.text('elattar add collapsible'), findsOneWidget);
      },
    );

    testWidgets(
      'the live specimen mounts closed, then expands and collapses on tap '
      'with motion frozen',
      (WidgetTester tester) async {
        await _pumpCollapsible(tester, size: const Size(900, 1400));

        // Closed by default: Unfold renders nothing for its content.
        expect(find.text('Volatility'), findsNothing);
        expect(find.text('Advanced filters'), findsOneWidget);

        await tester.ensureVisible(find.text('Advanced filters'));
        await tester.tap(find.text('Advanced filters'));
        await tester.pump();

        expect(find.text('Volatility'), findsOneWidget);

        await tester.ensureVisible(find.text('Advanced filters'));
        await tester.tap(find.text('Advanced filters'));
        await tester.pump();

        expect(find.text('Volatility'), findsNothing);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'two independent collapsibles in the Independent instances example '
      'do not affect each other: the whole point versus an accordion',
      (WidgetTester tester) async {
        await _pumpCollapsible(tester, size: const Size(900, 1600));

        final Finder triggers = find.byKey(
          const ValueKey<String>('collapsible-doc-independent'),
        );
        expect(triggers, findsOneWidget);

        final Finder firstTrigger = find.descendant(
          of: triggers,
          matching: find.byKey(
            const ValueKey<String>('collapsible-doc-independent-a-trigger'),
          ),
        );
        await tester.ensureVisible(firstTrigger);
        await tester.tap(firstTrigger);
        await tester.pump();

        expect(
          find.byKey(
            const ValueKey<String>('collapsible-doc-independent-a-panel'),
          ),
          findsOneWidget,
        );
        expect(
          find.byKey(
            const ValueKey<String>('collapsible-doc-independent-b-panel'),
          ),
          findsNothing,
        );
        expect(tester.takeException(), isNull);
      },
    );

    test('the table of contents matches the declared sections', () {
      expect(
        collapsibleDocSpec.toc
            .map((DocsTocEntry entry) => entry.title)
            .toList(),
        <String>[
          'Preview',
          'Installation',
          'Usage',
          'Composition',
          'Independent instances',
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
  });
}
