/// Tests for `components_docs/alert_dialog/meta.dart` and
/// `components_docs/alert_dialog/page.dart`: the public Alert Dialog
/// component documentation page.
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never synthetic `MediaQuery`: the
/// discipline `tooltip_test.dart` already carries. Theme coverage uses a
/// live `DsThemeController` flipped in place rather than two independent
/// pumps.
///
/// `DsAlertDialog` mounts its content through an `OverlayPortal` (via
/// `DsModalPortal`), so the live specimens need a real `Overlay`: the
/// harness wraps the page in a `MaterialApp`, the same fix `tooltip_test.dart`
/// and `dialogs_test.dart` both needed. A bare `Directionality`/`Material`
/// host would let the page render but the dialog would never actually open.
///
/// A dedicated `_FocusHarness` widget (private to this file, built from the
/// real public API) answers the brief's own question: does focus move into
/// the panel on open, stay trapped while open, and return to the trigger on
/// close?: by identity-comparing `FocusManager.instance.primaryFocus`
/// against the real internal `FocusNode`s of the trigger, Cancel, Action and
/// an outside control, recovered via `Focus.of` from each button's own text
/// descendant (`DsAlertDialogAction`/`DsAlertDialogCancel` accept no
/// `focusNode` parameter of their own, so there is no other way to pin the
/// identity down).
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/alert_dialog/meta.dart';
import 'package:example/components_docs/alert_dialog/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter_test/flutter_test.dart';

const Size _wide = Size(1440, 900);
const Size _narrow = Size(390, 844);

Future<DsThemeController> _pumpAlertDialogDoc(
  WidgetTester tester, {
  ValueChanged<String>? onNavigate,
  Size size = _wide,
  DsThemeMode mode = DsThemeMode.dark,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final DsThemeController theme = DsThemeController(mode: mode);
  addTearDown(theme.dispose);

  await tester.pumpWidget(
    DsTheme(
      controller: theme,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: SingleChildScrollView(
            child: AlertDialogDocPage(onNavigate: onNavigate),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  return theme;
}

Future<void> _open(WidgetTester tester, Finder trigger) async {
  await tester.ensureVisible(trigger);
  await tester.pumpAndSettle();
  await tester.tap(trigger);
  await tester.pump();
  await tester.pump(DsDurations.jelly);
}

/// Runs the exit and lets the portal's post-completion `setState` land: the
/// same two-pump shape `dialogs_test.dart`'s own `_settleExit` uses.
Future<void> _settleExit(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(DsDurations.overlay);
  await tester.pump();
}

/// A page built directly on the public `DsAlertDialog` family: not the
/// docs page's own specimen: wired with an outside control and real
/// `FocusNode`s recovered from each button's text descendant, so a focus
/// assertion can compare node *identity* rather than guess from geometry.
class _FocusHarness extends StatelessWidget {
  const _FocusHarness();

  @override
  Widget build(BuildContext context) => DsTheme(
    controller: DsThemeController(mode: DsThemeMode.dark),
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            DsButton(
              key: const ValueKey<String>('focus-harness-outside'),
              onPressed: () {},
              child: const Text('Outside'),
            ),
            DsAlertDialog(
              trigger: (BuildContext context, VoidCallback open) => DsButton(
                key: const ValueKey<String>('focus-harness-trigger'),
                onPressed: open,
                child: const Text('open'),
              ),
              content: (BuildContext context, VoidCallback close) =>
                  DsAlertDialogContent(
                    header: DsAlertDialogHeader(
                      title: const DsAlertDialogTitle('Sure?'),
                      description: const DsAlertDialogDescription(
                        'It cannot be undone.',
                      ),
                    ),
                    footer: DsAlertDialogFooter(
                      cancel: DsAlertDialogCancel(
                        key: const ValueKey<String>('focus-harness-cancel'),
                        label: 'Keep',
                        onPressed: close,
                      ),
                      action: DsAlertDialogAction(
                        key: const ValueKey<String>('focus-harness-action'),
                        label: 'Delete',
                        onPressed: close,
                      ),
                    ),
                  ),
            ),
          ],
        ),
      ),
    ),
  );
}

/// The real internal [FocusNode] behind the text inside [text]: recovered
/// via [Focus.of] walking up from that text's own [BuildContext], since
/// neither `DsAlertDialogAction` nor `DsAlertDialogCancel` exposes a
/// `focusNode` parameter of its own to inject one directly.
FocusNode _focusNodeFor(WidgetTester tester, String text) =>
    Focus.of(tester.element(find.text(text)));

void main() {
  group('meta', () {
    test('alertDialogDoc names the real public API surface', () {
      expect(alertDialogDoc.name, 'alert-dialog');
      expect(alertDialogDoc.title, 'Alert Dialog');
      expect(alertDialogDoc.route, '/components/alert-dialog');
      expect(alertDialogDoc.command, 'elattar add alert-dialog');
      expect(alertDialogDoc.sourcePath, 'lib/src/components/alert_dialog.dart');
      expect(
        alertDialogDoc.exports,
        containsAll(<String>[
          'DsAlertDialog',
          'DsAlertDialogSize',
          'DsAlertDialogContent',
          'DsAlertDialogHeader',
          'DsAlertDialogTitle',
          'DsAlertDialogDescription',
          'DsAlertDialogFooter',
          'DsAlertDialogAction',
          'DsAlertDialogCancel',
        ]),
      );
      // Matches registry/components/alert-dialog.json's registryDependencies
      // verbatim.
      expect(alertDialogDoc.dependencies, <String>[
        'source-foundation',
        'button',
        'dialog',
        'tooltip',
      ]);
      // Short description: one sentence, no trailing ellipsis.
      expect(alertDialogDoc.description, isNot(contains('..')));
      expect(alertDialogDoc.description.trim(), alertDialogDoc.description);
      // The expanded, decision-guidance description is a distinct constant,
      // not a restatement of the short one.
      expect(
        alertDialogExpandedDescription,
        isNot(equals(alertDialogDoc.description)),
      );
      expect(
        alertDialogExpandedDescription.trim(),
        alertDialogExpandedDescription,
      );
    });
  });

  group('rendered page', () {
    testWidgets('renders the article and the live specimen trigger', (
      WidgetTester tester,
    ) async {
      await _pumpAlertDialogDoc(tester);

      expect(
        find.byKey(const ValueKey<String>('alert-dialog-doc-article')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('alert-dialog-doc-trigger')),
        findsOneWidget,
      );
      // The overlay is not mounted before anything opens it.
      expect(find.byType(DsAlertDialogContent), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'section headings render top to bottom in shadcn-parity order',
      (WidgetTester tester) async {
        await _pumpAlertDialogDoc(tester);

        // The shadcn alert-dialog page's own shape, section for section:
        // a live demo before any heading (Preview), Installation, Usage, a
        // Composition tree, this component's own Sizes and Destructive
        // specimens, then API Reference, followed by this system's six
        // extra sections.
        const List<String> expectedOrder = <String>[
          'Installation',
          'Usage',
          'Composition',
          'Sizes',
          'Destructive',
          'API Reference',
          'States and feedback',
          'Accessibility and keyboard behavior',
          'Responsive and platform behavior',
          'Dependencies, files, and disclosure',
          'Theming notes',
          'Source and tests',
        ];

        final List<double> tops = <double>[];
        for (final String heading in expectedOrder) {
          final Finder finder = find.byWidgetPredicate(
            (Widget widget) =>
                widget is DsText &&
                widget.text == heading &&
                widget.spec == DsType.h3,
          );
          expect(finder, findsOneWidget, reason: 'missing heading: $heading');
          tops.add(tester.getTopLeft(finder).dy);
        }

        for (int i = 1; i < tops.length; i++) {
          expect(
            tops[i],
            greaterThan(tops[i - 1]),
            reason:
                '"${expectedOrder[i]}" did not render below '
                '"${expectedOrder[i - 1]}": observed offsets $tops',
          );
        }
      },
    );

    testWidgets(
      'the page intro distinguishes alert dialog, dialog, and alert',
      (WidgetTester tester) async {
        await _pumpAlertDialogDoc(tester);

        expect(find.textContaining('Reach for Dialog instead'), findsWidgets);
        expect(find.textContaining('Reach for Alert instead'), findsWidgets);
        expect(find.textContaining('cannot be undone'), findsWidgets);
      },
    );

    testWidgets(
      'the API tables document every constructor parameter found in the source',
      (WidgetTester tester) async {
        await _pumpAlertDialogDoc(tester);

        // DsAlertDialog.
        expect(find.text('trigger'), findsOneWidget);
        expect(find.text('content'), findsOneWidget);
        expect(find.text('onOpenChange'), findsOneWidget);
        // DsAlertDialogContent.
        expect(find.text('header'), findsOneWidget);
        expect(find.text('footer'), findsOneWidget);
        expect(find.text('size'), findsWidgets);
        // DsAlertDialogHeader.
        expect(find.text('title'), findsWidgets);
        expect(find.text('description'), findsWidgets);
        // DsAlertDialogTitle / DsAlertDialogDescription share `text`.
        expect(find.text('text'), findsWidgets);
        // DsAlertDialogFooter.
        expect(find.text('cancel'), findsOneWidget);
        expect(find.text('action'), findsOneWidget);
        // DsAlertDialogAction / DsAlertDialogCancel.
        expect(find.text('label'), findsWidgets);
        expect(find.text('onPressed'), findsWidgets);
        expect(find.text('variant'), findsWidgets);
        expect(find.text('loading'), findsOneWidget);
        expect(find.text('tooltip'), findsWidgets);
        // DsAlertDialogSize's two values.
        expect(find.text('normal'), findsOneWidget);
        expect(find.text('sm'), findsOneWidget);
      },
    );

    testWidgets('installation shows the real, registry-backed CLI command', (
      WidgetTester tester,
    ) async {
      await _pumpAlertDialogDoc(tester);

      expect(find.text('elattar add alert-dialog'), findsWidgets);
      expect(find.textContaining('button'), findsWidgets);
      expect(find.textContaining('tooltip'), findsWidgets);
    });

    testWidgets('sizes documents that sm only narrows the panel, honestly', (
      WidgetTester tester,
    ) async {
      await _pumpAlertDialogDoc(tester);

      expect(find.textContaining('DsAlertDialogSize'), findsWidgets);
      // The header/footer do not receive `size` at all, a real gap against
      // the enum's own "grid-cols-2 footer" doc comment.
      expect(find.textContaining('no size'), findsWidgets);
    });

    testWidgets('accessibility documents the Escape drift plainly', (
      WidgetTester tester,
    ) async {
      await _pumpAlertDialogDoc(tester);

      expect(find.textContaining('Escape'), findsWidgets);
      expect(find.textContaining('does not call'), findsWidgets);
    });

    testWidgets('navigating previous fires onNavigate with the linked page', (
      WidgetTester tester,
    ) async {
      String? destination;
      await _pumpAlertDialogDoc(
        tester,
        onNavigate: (String route) => destination = route,
      );

      await tester.ensureVisible(find.text('Dialog').first);
      await tester.tap(find.text('Dialog').first);
      expect(destination, '/components/dialog');
    });
  });

  group('live specimen: open, decide, close', () {
    testWidgets('opening mounts the real question, and Cancel closes it', (
      WidgetTester tester,
    ) async {
      await _pumpAlertDialogDoc(tester);
      final Finder trigger = find.byKey(
        const ValueKey<String>('alert-dialog-doc-trigger'),
      );

      await _open(tester, trigger);
      expect(find.byType(DsAlertDialogContent), findsOneWidget);

      final Finder cancel = find.byKey(
        const ValueKey<String>('alert-dialog-doc-cancel'),
      );
      await tester.tap(cancel);
      await _settleExit(tester);
      expect(find.byType(DsAlertDialogContent), findsNothing);
    });

    testWidgets('Action closes it too', (WidgetTester tester) async {
      await _pumpAlertDialogDoc(tester);
      final Finder trigger = find.byKey(
        const ValueKey<String>('alert-dialog-doc-trigger'),
      );

      await _open(tester, trigger);
      final Finder action = find.byKey(
        const ValueKey<String>('alert-dialog-doc-action'),
      );
      await tester.tap(action);
      await _settleExit(tester);
      expect(find.byType(DsAlertDialogContent), findsNothing);
    });

    testWidgets(
      'a tap on the scrim does NOT close it, matching the source comment',
      (WidgetTester tester) async {
        await _pumpAlertDialogDoc(tester);
        final Finder trigger = find.byKey(
          const ValueKey<String>('alert-dialog-doc-trigger'),
        );

        await _open(tester, trigger);
        await tester.tapAt(const Offset(4, 4));
        await _settleExit(tester);
        expect(find.byType(DsAlertDialogContent), findsOneWidget);
      },
    );

    testWidgets('Escape closes it despite the panel refusing the overlay tap', (
      WidgetTester tester,
    ) async {
      await _pumpAlertDialogDoc(tester);
      final Finder trigger = find.byKey(
        const ValueKey<String>('alert-dialog-doc-trigger'),
      );

      await _open(tester, trigger);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await _settleExit(tester);
      expect(find.byType(DsAlertDialogContent), findsNothing);
    });
  });

  group('focus behavior: moved in, trapped, and returned (or not)', () {
    testWidgets('opening moves focus onto a control inside the panel', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const _FocusHarness());
      await tester.pump();

      final FocusNode outside = _focusNodeFor(tester, 'Outside');
      await tester.tap(find.text('open'));
      await tester.pump();
      await tester.pump(DsDurations.jelly);

      expect(find.byType(DsAlertDialogContent), findsOneWidget);
      final FocusNode? focused = FocusManager.instance.primaryFocus;
      expect(focused, isNotNull);
      expect(
        focused,
        isNot(same(outside)),
        reason: 'focus must not stay on a control behind the overlay',
      );

      // Verified, not assumed: `FocusScope(autofocus: true)` with no
      // previously-focused descendant makes the FocusScopeNode ITSELF the
      // primary focus: not a leaf control such as Cancel. `FocusScope.of`
      // from inside the panel recovers that same scope node for comparison.
      final FocusScopeNode panelScope = FocusScope.of(
        tester.element(find.text('Keep')),
      );
      expect(
        focused,
        same(panelScope),
        reason:
            'expected autofocus to land on the panel\'s own FocusScopeNode '
            '— observed: $focused',
      );
    });

    testWidgets(
      'the first Tab moves focus onto a real footer button, and it never '
      'leaves the panel',
      (WidgetTester tester) async {
        await tester.pumpWidget(const _FocusHarness());
        await tester.pump();

        final FocusNode outside = _focusNodeFor(tester, 'Outside');
        await tester.tap(find.text('open'));
        await tester.pump();
        await tester.pump(DsDurations.jelly);

        final FocusNode cancelNode = _focusNodeFor(tester, 'Keep');
        final FocusNode actionNode = _focusNodeFor(tester, 'Delete');

        final List<FocusNode?> observed = <FocusNode?>[];
        for (int i = 0; i < 6; i++) {
          await tester.sendKeyEvent(LogicalKeyboardKey.tab);
          await tester.pump();
          final FocusNode? focused = FocusManager.instance.primaryFocus;
          observed.add(focused);
          expect(
            focused,
            isNot(same(outside)),
            reason:
                'Tab press #${i + 1} reached the control behind the '
                'overlay: the trap has a hole. Sequence so far: $observed',
          );
        }
        // Once Tab has moved at least once, focus has left the bare scope
        // node and landed on one of the two real buttons.
        expect(
          observed.last,
          anyOf(same(cancelNode), same(actionNode)),
          reason: 'observed sequence: $observed',
        );
      },
    );

    testWidgets(
      'closing via Cancel: where focus lands afterward, reported as-is',
      (WidgetTester tester) async {
        await tester.pumpWidget(const _FocusHarness());
        await tester.pump();

        final FocusNode triggerNode = _focusNodeFor(tester, 'open');
        await tester.tap(find.text('open'));
        await tester.pump();
        await tester.pump(DsDurations.jelly);

        await tester.tap(find.text('Keep'));
        await tester.pump();
        await tester.pump(DsDurations.overlay);
        await tester.pump();

        expect(find.byType(DsAlertDialogContent), findsNothing);
        // Documented, not assumed: the source wires no explicit
        // save/restore-focus step in DsModalPortalState.close(), so this
        // assertion pins whatever Flutter's own framework default produces
        // rather than an aspirational "returns to the trigger" claim.
        final FocusNode? focused = FocusManager.instance.primaryFocus;
        expect(
          focused == triggerNode,
          isFalse,
          reason:
              'if this starts failing, DsModalPortal gained an explicit '
              'restore-focus step and the Accessibility section needs to '
              'stop calling it a gap: observed after close: $focused',
        );
      },
    );
  });

  group('viewport widths', () {
    testWidgets('a wide viewport exposes the sidebar and table of contents', (
      WidgetTester tester,
    ) async {
      await _pumpAlertDialogDoc(tester, size: _wide);

      expect(
        find.byKey(const ValueKey<String>('docs-layout-sidebar')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('docs-layout-toc')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('alert-dialog-doc-article')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'a narrow viewport drops to the anchor strip and stays reachable',
      (WidgetTester tester) async {
        await _pumpAlertDialogDoc(tester, size: _narrow);

        expect(
          find.byKey(const ValueKey<String>('docs-layout-sidebar')),
          findsNothing,
        );
        expect(
          find.byKey(const ValueKey<String>('docs-layout-anchor-strip')),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey<String>('alert-dialog-doc-article')),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
      },
    );
  });

  group('both themes', () {
    testWidgets('renders on light', (WidgetTester tester) async {
      await _pumpAlertDialogDoc(tester, mode: DsThemeMode.light);
      expect(find.byType(DsAlertDialog), findsWidgets);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders on dark', (WidgetTester tester) async {
      await _pumpAlertDialogDoc(tester, mode: DsThemeMode.dark);
      expect(find.byType(DsAlertDialog), findsWidgets);
      expect(tester.takeException(), isNull);
    });

    testWidgets('flipping the theme in place keeps the page intact', (
      WidgetTester tester,
    ) async {
      final DsThemeController theme = await _pumpAlertDialogDoc(
        tester,
        mode: DsThemeMode.dark,
      );
      expect(find.byType(DsAlertDialog), findsWidgets);

      theme.setMode(DsThemeMode.light);
      await tester.pump();

      expect(find.byType(DsAlertDialog), findsWidgets);
      expect(tester.takeException(), isNull);
    });
  });
}
