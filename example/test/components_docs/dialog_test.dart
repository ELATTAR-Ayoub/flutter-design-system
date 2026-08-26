/// Tests for `components_docs/dialog/meta.dart` and
/// `components_docs/dialog/page.dart`: the public Dialog component
/// documentation page.
///
/// Re-housed onto `ComponentDocSpec`/`ComponentDocPage`, the same shape
/// `button_test.dart`, `alert_dialog_test.dart` and `select_test.dart`
/// assert against: sections read through `DocsSection.title`, and the API
/// table (inside a `DocsDisclosure`, closed by default) is opened before
/// its rows are read.
///
/// `ElDialog` mounts its content through an `OverlayPortal` (via
/// `ElModalPortal`), so the live specimens need a real `Overlay`: the
/// harness wraps the page in a `MaterialApp`. No `pumpAndSettle` is used
/// anywhere a dialog is open — every open/close step advances with an
/// explicit `pump()`/`pump(duration)` pair instead, the same shape
/// `alert_dialog_test.dart`'s own `_open`/`_settleExit` helpers use.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/dialog/meta.dart';
import 'package:example/components_docs/dialog/page.dart';
import 'package:example/docs/docs_disclosure.dart';
import 'package:example/docs/docs_link.dart' show DocsLink, DocsLinkRow;
import 'package:example/docs/docs_section.dart' show DocsSection;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter_test/flutter_test.dart';

const Size _wide = Size(1440, 900);
const Size _narrow = Size(390, 844);

/// The single `DocsDisclosure` whose title is [title]: `DocsDisclosure`'s
/// own trigger key is one constant shared by every instance on the page, so
/// a bare `find.byKey` would match all eight — this narrows to the one
/// panel by its title first, matching `button_test.dart`'s own convention.
Finder _disclosureTrigger(String title) => find.descendant(
  of: find.byWidgetPredicate(
    (Widget widget) => widget is DocsDisclosure && widget.title == title,
  ),
  matching: find.byKey(DocsDisclosure.triggerKey),
);

Future<ElThemeController> _pumpDialogDoc(
  WidgetTester tester, {
  ValueChanged<String>? onNavigate,
  Size size = _wide,
  ElThemeMode mode = ElThemeMode.dark,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final ElThemeController theme = ElThemeController(mode: mode);
  await tester.pumpWidget(
    ElTheme(
      controller: theme,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SingleChildScrollView(child: DialogDocPage(onNavigate: onNavigate)),
      ),
    ),
  );
  await tester.pump();
  return theme;
}

Future<void> _open(WidgetTester tester, Finder trigger) async {
  await tester.ensureVisible(trigger);
  await tester.pump();
  await tester.tap(trigger);
  await tester.pump();
  await tester.pump(ElDurations.jelly);
}

/// Runs the exit and lets the portal's post-completion `setState` land — the
/// same two-pump shape `alert_dialog_test.dart`'s own `_settleExit` uses.
Future<void> _settleExit(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(ElDurations.overlay);
  await tester.pump();
}

void main() {
  group('meta', () {
    test('dialogDoc names the real public API surface', () {
      expect(dialogDoc.name, 'dialog');
      expect(dialogDoc.title, 'Dialog');
      expect(dialogDoc.route, '/components/dialog');
      expect(dialogDoc.command, 'elattar add dialog');
      expect(dialogDoc.sourcePath, 'lib/src/components/dialog.dart');
      // registry/components/dialog.json's own registryDependencies, verbatim.
      expect(dialogDoc.dependencies, <String>[
        'button',
        'icon',
        'machine-surface',
        'source-foundation',
      ]);
      expect(
        dialogDoc.exports,
        containsAll(<String>[
          'ElModalPortal',
          'ElDialogOverlay',
          'ElJellyTransition',
          'ElDialog',
          'ElDialogVariant',
          'ElDialogContent',
          'ElDialogContentGroup',
          'ElDialogHeader',
          'ElDialogFooter',
          'ElDialogTitle',
          'ElDialogDescription',
          'ElDialogMedia',
        ]),
      );
      expect(dialogDoc.description, isNot(contains('..')));
      expect(dialogDoc.description.trim(), dialogDoc.description);
    });
  });

  group('rendered page', () {
    testWidgets('renders the article and both live specimen triggers', (
      WidgetTester tester,
    ) async {
      await _pumpDialogDoc(tester);

      expect(
        find.byKey(const ValueKey<String>('dialog-doc-article')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('dialog-example:normal-trigger')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('dialog-example:media-trigger')),
        findsOneWidget,
      );
      // Neither overlay is mounted before anything opens it.
      expect(find.byType(ElDialogContent), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('sections render top to bottom in the declared house order', (
      WidgetTester tester,
    ) async {
      await _pumpDialogDoc(tester, size: const Size(1440, 4000));

      final List<String> titles = tester
          .widgetList<DocsSection>(find.byType(DocsSection))
          .map((DocsSection section) => section.title)
          .toList();

      expect(titles, <String>[
        'Preview',
        'Installation',
        'Usage',
        'Normal',
        'Media',
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
      'the API tables document every constructor parameter found in the '
      'source, across all twelve exports',
      (WidgetTester tester) async {
        await _pumpDialogDoc(tester, size: const Size(1440, 4000));

        final Finder apiTrigger = _disclosureTrigger('API Reference');
        await tester.ensureVisible(apiTrigger);
        await tester.pump();
        await tester.tap(apiTrigger);
        await tester.pump();
        await tester.pump(ElDurations.jelly);

        // ElDialog.
        expect(find.text('trigger'), findsWidgets);
        expect(find.text('content'), findsWidgets);
        expect(find.text('onOpenChange'), findsWidgets);
        // ElDialogContent.
        expect(find.text('children'), findsWidgets);
        expect(find.text('variant'), findsWidgets);
        // ElDialogContent AND ElDialogContentGroup both declare
        // showCloseButton, so two rows carry the string.
        expect(find.text('showCloseButton'), findsNWidgets(2));
        expect(find.text('onClose'), findsOneWidget);
        // ElDialogHeader / ElDialogFooter.
        expect(find.text('ElDialogHeader.closeButtonLane'), findsOneWidget);
        // ElDialogTitle / ElDialogDescription share `text (positional)`.
        expect(find.text('text (positional)'), findsWidgets);
        // ElDialogMedia.
        expect(find.text('child'), findsWidgets);
        expect(find.text('ElDialogMedia.aspect'), findsOneWidget);
        // ElModalPortal.
        expect(find.text('transition'), findsOneWidget);
        expect(find.text('alignment'), findsOneWidget);
        expect(find.text('enterDuration'), findsOneWidget);
        expect(find.text('exitDuration'), findsOneWidget);
        expect(find.text('overlayDuration'), findsOneWidget);
        expect(find.text('overlayCurve'), findsOneWidget);
        expect(find.text('dismissOnOverlayTap'), findsOneWidget);
        expect(find.text('clampToViewport'), findsOneWidget);
        // ElJellyTransition.
        expect(find.text('animation'), findsOneWidget);
        expect(
          find.text('ElJellyTransition.sample(progress, {entering})'),
          findsOneWidget,
        );
        for (final String table in <String>[
          'ElDialog',
          'ElDialogVariant',
          'ElDialogContent',
          'ElDialogContentGroup',
          'ElDialogHeader',
          'ElDialogFooter',
          'ElDialogTitle',
          'ElDialogDescription',
          'ElDialogMedia',
          'ElModalPortal',
          'ElDialogOverlay',
          'ElJellyTransition',
        ]) {
          expect(find.textContaining(table), findsWidgets, reason: 'missing $table');
        }
      },
    );

    testWidgets('installation shows the real, registry-backed CLI command', (
      WidgetTester tester,
    ) async {
      await _pumpDialogDoc(tester);

      expect(find.text('elattar add dialog'), findsWidgets);
      expect(find.textContaining('button'), findsWidgets);
      expect(find.textContaining('machine-surface'), findsWidgets);
    });

    testWidgets(
      'dependencies links out to the alert dialog, sheet and drawer that '
      'ride the same portal',
      (WidgetTester tester) async {
        await _pumpDialogDoc(tester, size: const Size(1440, 4000));

        final Finder depsTrigger = _disclosureTrigger('Dependencies');
        await tester.ensureVisible(depsTrigger);
        await tester.pump();
        await tester.tap(depsTrigger);
        await tester.pump();
        await tester.pump(ElDurations.jelly);

        // Scoped to the DocsLinkRow itself: the sidebar's own component nav
        // renders a link named "Sheet" too, and a bare find.text('Sheet')
        // matches both.
        final DocsLinkRow links = tester.widget<DocsLinkRow>(
          find.byType(DocsLinkRow),
        );
        final List<String> labels = links.links
            .map((DocsLink link) => link.label)
            .toList();
        expect(labels, contains('Alert dialog'));
        expect(labels, contains('Sheet'));
        expect(labels, contains('Drawer'));
      },
    );

    testWidgets('keyboard documents that Escape and back are not the same contract', (
      WidgetTester tester,
    ) async {
      await _pumpDialogDoc(tester, size: const Size(1440, 4000));

      final Finder keyboardTrigger = _disclosureTrigger('Keyboard');
      await tester.ensureVisible(keyboardTrigger);
      await tester.pump();
      await tester.tap(keyboardTrigger);
      await tester.pump();
      await tester.pump(ElDurations.jelly);

      expect(find.textContaining('Escape'), findsWidgets);
      expect(find.textContaining('NOT the same contract'), findsWidgets);
    });

    testWidgets('navigating next fires onNavigate with the linked page', (
      WidgetTester tester,
    ) async {
      String? destination;
      await _pumpDialogDoc(
        tester,
        onNavigate: (String route) => destination = route,
      );

      final Finder nextLink = find
          .widgetWithText(ElButton, 'Dropdown Menu')
          .last;
      await tester.ensureVisible(nextLink);
      await tester.tap(nextLink);
      expect(destination, '/components/dropdown-menu');
    });
  });

  group('live specimen: open, inspect, close', () {
    testWidgets('the Normal specimen opens, shows the header/footer, and '
        'Escape closes it', (WidgetTester tester) async {
      await _pumpDialogDoc(tester);
      final Finder trigger = find.byKey(
        const ValueKey<String>('dialog-example:normal-trigger'),
      );

      await _open(tester, trigger);
      expect(
        find.byKey(const ValueKey<String>('dialog-example:normal-content')),
        findsOneWidget,
      );
      expect(find.text('Confirm action'), findsOneWidget);
      expect(find.text('This is a live modal preview.'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await _settleExit(tester);
      expect(
        find.byKey(const ValueKey<String>('dialog-example:normal-content')),
        findsNothing,
      );
    });

    testWidgets('the Normal specimen also closes on a tap outside the panel '
        '— dismissOnOverlayTap defaults true, unlike the alert dialog', (
      WidgetTester tester,
    ) async {
      await _pumpDialogDoc(tester);
      final Finder trigger = find.byKey(
        const ValueKey<String>('dialog-example:normal-trigger'),
      );

      await _open(tester, trigger);
      expect(
        find.byKey(const ValueKey<String>('dialog-example:normal-content')),
        findsOneWidget,
      );

      await tester.tapAt(const Offset(4, 4));
      await _settleExit(tester);
      expect(
        find.byKey(const ValueKey<String>('dialog-example:normal-content')),
        findsNothing,
      );
    });

    testWidgets('the Media specimen opens with a full-bleed lead and no '
        'banded header, and its Continue button closes it', (
      WidgetTester tester,
    ) async {
      await _pumpDialogDoc(tester);
      final Finder trigger = find.byKey(
        const ValueKey<String>('dialog-example:media-trigger'),
      );

      await _open(tester, trigger);
      expect(
        find.byKey(const ValueKey<String>('dialog-example:media-content')),
        findsOneWidget,
      );
      expect(find.byType(ElDialogMedia), findsOneWidget);
      expect(find.text('A visual lead'), findsOneWidget);

      final ElDialogContent content = tester.widget<ElDialogContent>(
        find.byKey(const ValueKey<String>('dialog-example:media-content')),
      );
      expect(content.variant, ElDialogVariant.media);
      expect(content.showCloseButton, isFalse);

      await tester.tap(find.text('Continue'));
      await _settleExit(tester);
      expect(find.byType(ElDialogMedia), findsNothing);
    });
  });

  group('viewport widths', () {
    testWidgets('a wide viewport exposes the sidebar and table of contents', (
      WidgetTester tester,
    ) async {
      await _pumpDialogDoc(tester, size: _wide);

      expect(
        find.byKey(const ValueKey<String>('docs-layout-sidebar')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('docs-layout-toc')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('dialog-doc-article')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'a narrow viewport drops to the anchor strip and stays reachable',
      (WidgetTester tester) async {
        await _pumpDialogDoc(tester, size: _narrow);

        expect(
          find.byKey(const ValueKey<String>('docs-layout-sidebar')),
          findsNothing,
        );
        expect(
          find.byKey(const ValueKey<String>('docs-layout-anchor-strip')),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey<String>('dialog-doc-article')),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
      },
    );
  });

  group('both themes', () {
    testWidgets('renders on light', (WidgetTester tester) async {
      await _pumpDialogDoc(tester, mode: ElThemeMode.light);
      expect(find.byType(ElDialog), findsWidgets);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders on dark', (WidgetTester tester) async {
      await _pumpDialogDoc(tester, mode: ElThemeMode.dark);
      expect(find.byType(ElDialog), findsWidgets);
      expect(tester.takeException(), isNull);
    });

    testWidgets('flipping the theme in place keeps the page intact', (
      WidgetTester tester,
    ) async {
      final ElThemeController theme = await _pumpDialogDoc(
        tester,
        mode: ElThemeMode.dark,
      );
      expect(find.byType(ElDialog), findsWidgets);

      theme.setMode(ElThemeMode.light);
      await tester.pump();

      expect(find.byType(ElDialog), findsWidgets);
      expect(tester.takeException(), isNull);
    });
  });
}
