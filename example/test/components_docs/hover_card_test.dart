/// Tests for `components_docs/hover_card/meta.dart` and
/// `components_docs/hover_card/page.dart`: the public documentation page
/// for Hover Card, re-housed onto the kit (`ComponentDocSpec` +
/// `ComponentDocPage`), the same shape `button_test.dart` covers.
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never synthetic `MediaQuery`. Theme
/// coverage uses a live `ElThemeController` flipped in place rather than two
/// independent pumps.
///
/// ElHoverCard mounts through [OverlayPortal] directly (not ElPopover), so
/// the live specimens need a real [Overlay]: the harness wraps the page in a
/// `MaterialApp`, the same fix Popover and Select needed.
///
/// This page mounts `_HoverCardSpecimen` three times (Preview, Trigger
/// Delays, and Basic), each under its own `specimenKey` — the known-bug
/// guard the page's own doc comment explains. No test here waits on the
/// card's open/close timers with `pumpAndSettle`: a bare mount/render check
/// is what this specimen has always needed.
///
/// API Reference and Accessibility are both `DisclosureSection`s now,
/// closed by default and mounting no content while closed (see
/// `docs_disclosure_test.dart`), so both tests that read their content open
/// the relevant `DocsDisclosure` first — the same fix `button_test.dart`
/// needed for its own API table.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/hover_card/meta.dart';
import 'package:example/components_docs/hover_card/page.dart';
import 'package:example/docs/docs_disclosure.dart';
import 'package:example/docs/docs_install.dart';
import 'package:example/docs/docs_section.dart' show DocsSection;
import 'package:example/docs/docs_showcase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const Size _wide = Size(1440, 900);
const Size _narrow = Size(390, 844);

Future<ElThemeController> _pumpPage(
  WidgetTester tester, {
  ValueChanged<String>? onNavigate,
  Size size = _wide,
  ElThemeMode mode = ElThemeMode.dark,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final ElThemeController theme = ElThemeController(mode: mode);
  addTearDown(theme.dispose);

  await tester.pumpWidget(
    ElTheme(
      controller: theme,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: SingleChildScrollView(
            child: HoverCardDocPage(onNavigate: onNavigate),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  return theme;
}

/// The single `DocsDisclosure` whose title is [title]. `DocsDisclosure`'s
/// own trigger key is one constant shared by every instance on the page, so
/// a bare `find.byKey` would match all eight — this narrows to the one
/// panel by its title first, matching `button_test.dart`'s own helper.
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
  await tester.pump(ElDurations.jelly);
}

void main() {
  group('meta', () {
    test('hoverCardDoc names the real public API surface', () {
      expect(hoverCardDoc.name, 'hover-card');
      expect(hoverCardDoc.title, 'Hover Card');
      expect(hoverCardDoc.route, '/components/hover-card');
      expect(hoverCardDoc.dependencies, <String>[
        'popover',
        'source-foundation',
      ]);
      expect(hoverCardDoc.sourcePath, 'lib/src/components/hover_card.dart');
      expect(
        hoverCardDoc.exports,
        containsAll(<String>['ElHoverCard', 'ElHoverCardContent']),
      );
      // Short description: one sentence, no trailing ellipsis.
      expect(hoverCardDoc.description, isNot(contains('..')));
      expect(hoverCardDoc.description.trim(), hoverCardDoc.description);
      // A real registry manifest, not the stale "unregistered" claim the
      // hand-composed page used to carry — see this page's own library doc.
      expect(hoverCardDoc.command, 'elattar add hover-card');
    });
  });

  group('rendered page', () {
    testWidgets('sections render in the declared order', (
      WidgetTester tester,
    ) async {
      await _pumpPage(tester);

      final List<String> titles = tester
          .widgetList<DocsSection>(find.byType(DocsSection))
          .map((DocsSection section) => section.title)
          .toList();

      expect(titles, <String>[
        'Preview',
        'Installation',
        'Usage',
        'Composition',
        'Trigger Delays',
        'Basic',
        'RTL',
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
      'the page is declared, and every section is a kit component',
      (WidgetTester tester) async {
        await _pumpPage(tester);

        // Four specimen stages: Preview, Trigger Delays, Basic, RTL.
        expect(find.byType(DocsShowcase), findsNWidgets(4));
        expect(find.byType(DocsInstall), findsOneWidget);
        // Eight collapsed sections: API Reference, States, Accessibility,
        // Keyboard, Responsive, Dependencies, Theming, Source.
        expect(find.byType(DocsDisclosure), findsNWidgets(8));
      },
    );

    testWidgets(
      'renders the article and all three live specimens under distinct keys',
      (WidgetTester tester) async {
        await _pumpPage(tester);

        expect(
          find.byKey(const ValueKey<String>('hover-card-doc-article')),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey<String>('hover-card-specimen')),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey<String>('hover-card-delays-specimen')),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey<String>('hover-card-basic-specimen')),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'the API tables document constructor parameters from the source',
      (WidgetTester tester) async {
        await _pumpPage(tester);

        await _open(tester, 'API Reference');

        expect(find.text('trigger'), findsWidgets);
        expect(find.text('content'), findsWidgets);
        expect(find.text('width'), findsWidgets);
        expect(find.text('openDelay'), findsOneWidget);
        expect(find.text('closeDelay'), findsOneWidget);
        expect(find.text('ElHoverCardContent'), findsWidgets);
        expect(find.text('child'), findsWidgets);
      },
    );

    testWidgets('documents the working hover-card CLI install', (
      WidgetTester tester,
    ) async {
      await _pumpPage(tester);

      // The install command is derived, never a literal — see
      // `ComponentDocEntry.command`.
      expect(hoverCardDoc.command, 'elattar add hover-card');
      expect(find.byType(DocsInstall), findsOneWidget);
    });

    testWidgets('accessibility section documents the touch gap', (
      WidgetTester tester,
    ) async {
      await _pumpPage(tester);

      await _open(tester, 'Accessibility');

      expect(find.textContaining('Pointer only'), findsWidgets);
      // ElNote's title renders through ElType.label, which uppercases its
      // text, so match on the body copy instead of the title.
      expect(find.textContaining('optional detail'), findsWidgets);
    });

    testWidgets('keyboard section documents the absent keyboard path', (
      WidgetTester tester,
    ) async {
      await _pumpPage(tester);

      await _open(tester, 'Keyboard');

      expect(find.textContaining('No keyboard path exists'), findsWidgets);
    });
  });

  group('live specimens', () {
    testWidgets('all three mounts render without colliding', (
      WidgetTester tester,
    ) async {
      await _pumpPage(tester);

      final Finder top = find.byKey(
        const ValueKey<String>('hover-card-specimen'),
      );
      final Finder delays = find.byKey(
        const ValueKey<String>('hover-card-delays-specimen'),
      );
      final Finder basic = find.byKey(
        const ValueKey<String>('hover-card-basic-specimen'),
      );
      await tester.ensureVisible(basic);
      await tester.pump();

      expect(top, findsOneWidget);
      expect(delays, findsOneWidget);
      expect(basic, findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('viewport widths', () {
    testWidgets('a wide viewport exposes the sidebar and table of contents', (
      WidgetTester tester,
    ) async {
      await _pumpPage(tester, size: _wide);

      expect(
        find.byKey(const ValueKey<String>('docs-layout-sidebar')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('docs-layout-toc')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('hover-card-doc-article')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'a narrow viewport drops to the anchor strip and stays reachable',
      (WidgetTester tester) async {
        await _pumpPage(tester, size: _narrow);

        expect(
          find.byKey(const ValueKey<String>('docs-layout-sidebar')),
          findsNothing,
        );
        expect(
          find.byKey(const ValueKey<String>('docs-layout-anchor-strip')),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey<String>('hover-card-doc-article')),
          findsOneWidget,
        );
        tester.takeException();
      },
    );
  });

  group('both themes', () {
    testWidgets('renders on light', (WidgetTester tester) async {
      await _pumpPage(tester, mode: ElThemeMode.light);
      expect(
        find.byKey(const ValueKey<String>('hover-card-specimen')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders on dark', (WidgetTester tester) async {
      await _pumpPage(tester, mode: ElThemeMode.dark);
      expect(
        find.byKey(const ValueKey<String>('hover-card-specimen')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('flipping the theme in place keeps the page intact', (
      WidgetTester tester,
    ) async {
      final ElThemeController theme = await _pumpPage(
        tester,
        mode: ElThemeMode.dark,
      );
      expect(
        find.byKey(const ValueKey<String>('hover-card-specimen')),
        findsOneWidget,
      );

      theme.setMode(ElThemeMode.light);
      await tester.pump();

      expect(
        find.byKey(const ValueKey<String>('hover-card-specimen')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });
  });
}
