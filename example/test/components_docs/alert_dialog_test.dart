/// Tests for `components_docs/alert_dialog/meta.dart` and
/// `components_docs/alert_dialog/page.dart`: the public Alert Dialog
/// component documentation page.
///
/// Re-housed onto `ComponentDocSpec`/`ComponentDocPage`, the same shape
/// `button_test.dart` and `field_test.dart` assert against: sections read
/// through `DocsSection.title`, and the API table (now inside a
/// `DocsDisclosure`, closed by default) is opened before its rows are read.
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never synthetic `MediaQuery`. Theme
/// coverage uses a live `ThemeController` flipped in place rather than two
/// independent pumps.
///
/// `AlertDialog` mounts its content through an `OverlayPortal` (via
/// `OverlayPortal`), so the live specimens need a real `Overlay`: the
/// harness wraps the page in a `MaterialApp`. No `pumpAndSettle` is used
/// anywhere a dialog is open: `OpenTransition`'s controller drives a
/// single forward/reverse run, but the page as a whole also hosts
/// `DocsDisclosure`'s chevron controller, so every open/close step below
/// advances with an explicit `pump()`/`pump(duration)` pair instead.
///
/// A dedicated `_FocusHarness` widget (private to this file, built from the
/// real public API) answers the brief's own question: does focus move into
/// the panel on open, stay trapped while open, and return to the trigger on
/// close?: by identity-comparing `FocusManager.instance.primaryFocus`
/// against the real internal `FocusNode`s of the trigger, Cancel, Action and
/// an outside control, recovered via `Focus.of` from each button's own text
/// descendant (`AlertDialogAction`/`AlertDialogCancel` accept no
/// `focusNode` parameter of their own, so there is no other way to pin the
/// identity down).
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/alert_dialog/meta.dart';
import 'package:example/components_docs/alert_dialog/page.dart';
import 'package:example/docs/docs_disclosure.dart';
import 'package:example/docs/docs_section.dart' show DocsSection;
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
import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter_test/flutter_test.dart';

const Size _wide = Size(1440, 900);
const Size _narrow = Size(390, 844);

/// The single `DocsDisclosure` whose title is [title]: `DocsDisclosure`'s
/// own trigger key is one constant shared by every instance on the page, so
/// a bare `find.byKey` would match all eight — this narrows to the one panel
/// by its title first, matching `button_test.dart`'s own convention.
Finder _disclosureTrigger(String title) => find.descendant(
  of: find.byWidgetPredicate(
    (Widget widget) => widget is DocsDisclosure && widget.title == title,
  ),
  matching: find.byKey(DocsDisclosure.triggerKey),
);

Future<ThemeController> _pumpAlertDialogDoc(
  WidgetTester tester, {
  ValueChanged<String>? onNavigate,
  Size size = _wide,
  ColorMode mode = ColorMode.dark,
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
  await tester.pump();
  await tester.tap(trigger);
  await tester.pump();
  await tester.pump(MotionDurations.open);
}

/// Runs the exit and lets the portal's post-completion `setState` land: the
/// same two-pump shape `dialogs_test.dart`'s own `_settleExit` uses.
Future<void> _settleExit(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(MotionDurations.overlayEnter);
  await tester.pump();
}

/// A page built directly on the public `AlertDialog` family: not the
/// docs page's own specimen: wired with an outside control and real
/// `FocusNode`s recovered from each button's text descendant, so a focus
/// assertion can compare node *identity* rather than guess from geometry.
class _FocusHarness extends StatelessWidget {
  const _FocusHarness();

  @override
  Widget build(BuildContext context) => ThemeScope(
    controller: ThemeController(mode: ColorMode.dark),
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Button(
              key: const ValueKey<String>('focus-harness-outside'),
              onPressed: () {},
              child: const Text('Outside'),
            ),
            AlertDialog(
              trigger: (BuildContext context, VoidCallback open) => Button(
                key: const ValueKey<String>('focus-harness-trigger'),
                onPressed: open,
                child: const Text('open'),
              ),
              content: (BuildContext context, VoidCallback close) =>
                  AlertDialogContent(
                    header: AlertDialogHeader(
                      title: const AlertDialogTitle('Sure?'),
                      description: const AlertDialogDescription(
                        'It cannot be undone.',
                      ),
                    ),
                    footer: AlertDialogFooter(
                      cancel: AlertDialogCancel(
                        key: const ValueKey<String>('focus-harness-cancel'),
                        label: 'Keep',
                        onPressed: close,
                      ),
                      action: AlertDialogAction(
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
/// neither `AlertDialogAction` nor `AlertDialogCancel` exposes a
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
          'AlertDialog',
          'AlertDialogSize',
          'AlertDialogContent',
          'AlertDialogHeader',
          'AlertDialogTitle',
          'AlertDialogDescription',
          'AlertDialogFooter',
          'AlertDialogAction',
          'AlertDialogCancel',
        ]),
      );
      // Matches registry/components/alert-dialog.json's registryDependencies
      // verbatim.
      expect(alertDialogDoc.dependencies, <String>[
        'button',
        'dialog',
        'surface',
        'source-foundation',
        'tooltip',
      ]);
      // Short description: one sentence, no trailing ellipsis.
      expect(alertDialogDoc.description, isNot(contains('..')));
      expect(alertDialogDoc.description.trim(), alertDialogDoc.description);
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
      expect(find.byType(AlertDialogContent), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('sections render top to bottom in the declared house order', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 4000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await _pumpAlertDialogDoc(tester, size: const Size(1440, 4000));

      final List<String> titles = tester
          .widgetList<DocsSection>(find.byType(DocsSection))
          .map((DocsSection section) => section.title)
          .toList();

      expect(titles, <String>[
        'Preview',
        'Installation',
        'Usage',
        'Composition',
        'Sizes',
        'Destructive',
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
      'the API tables document every constructor parameter found in the source',
      (WidgetTester tester) async {
        await _pumpAlertDialogDoc(tester, size: const Size(1440, 4000));

        final Finder apiTrigger = _disclosureTrigger('API Reference');
        await tester.ensureVisible(apiTrigger);
        await tester.pump();
        await tester.tap(apiTrigger);
        await tester.pump();
        await tester.pump(MotionDurations.open);

        // AlertDialog.
        expect(find.text('trigger'), findsOneWidget);
        expect(find.text('content'), findsOneWidget);
        expect(find.text('onOpenChange'), findsOneWidget);
        // AlertDialogContent.
        expect(find.text('header'), findsOneWidget);
        expect(find.text('footer'), findsOneWidget);
        expect(find.text('size'), findsWidgets);
        // AlertDialogHeader.
        expect(find.text('title'), findsWidgets);
        expect(find.text('description'), findsWidgets);
        // AlertDialogTitle / AlertDialogDescription share `text`.
        expect(find.text('text'), findsWidgets);
        // AlertDialogFooter.
        expect(find.text('cancel'), findsOneWidget);
        expect(find.text('action'), findsOneWidget);
        // AlertDialogAction / AlertDialogCancel.
        expect(find.text('label'), findsWidgets);
        expect(find.text('onPressed'), findsWidgets);
        expect(find.text('variant'), findsWidgets);
        expect(find.text('loading'), findsOneWidget);
        expect(find.text('tooltip'), findsWidgets);
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

      expect(find.textContaining('AlertDialogSize'), findsWidgets);
      // The header/footer do not receive `size` at all, a real gap against
      // the enum's own "grid-cols-2 footer" doc comment.
      expect(find.textContaining('no size'), findsWidgets);
      // The Sizes section is a live specimen now, not a bare table: both
      // triggers are on the page.
      expect(
        find.byKey(const ValueKey<String>('alert-dialog-example:size-normal')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('alert-dialog-example:size-sm')),
        findsOneWidget,
      );
    });

    testWidgets('keyboard documents the Escape drift plainly', (
      WidgetTester tester,
    ) async {
      await _pumpAlertDialogDoc(tester, size: const Size(1440, 4000));

      final Finder keyboardTrigger = _disclosureTrigger('Keyboard');
      await tester.ensureVisible(keyboardTrigger);
      await tester.pump();
      await tester.tap(keyboardTrigger);
      await tester.pump();
      await tester.pump(MotionDurations.open);

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
      expect(find.byType(AlertDialogContent), findsOneWidget);

      final Finder cancel = find.byKey(
        const ValueKey<String>('alert-dialog-doc-cancel'),
      );
      await tester.tap(cancel);
      await _settleExit(tester);
      expect(find.byType(AlertDialogContent), findsNothing);
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
      expect(find.byType(AlertDialogContent), findsNothing);
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
        expect(find.byType(AlertDialogContent), findsOneWidget);
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
      expect(find.byType(AlertDialogContent), findsNothing);
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
      await tester.pump(MotionDurations.open);

      expect(find.byType(AlertDialogContent), findsOneWidget);
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
        await tester.pump(MotionDurations.open);

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
        await tester.pump(MotionDurations.open);

        await tester.tap(find.text('Keep'));
        await tester.pump();
        await tester.pump(MotionDurations.overlayEnter);
        await tester.pump();

        expect(find.byType(AlertDialogContent), findsNothing);
        // Documented, not assumed: the source wires no explicit
        // save/restore-focus step in OverlayPortalState.close(), so this
        // assertion pins whatever Flutter's own framework default produces
        // rather than an aspirational "returns to the trigger" claim.
        final FocusNode? focused = FocusManager.instance.primaryFocus;
        expect(
          focused == triggerNode,
          isFalse,
          reason:
              'if this starts failing, OverlayPortal gained an explicit '
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
      await _pumpAlertDialogDoc(tester, mode: ColorMode.light);
      expect(find.byType(AlertDialog), findsWidgets);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders on dark', (WidgetTester tester) async {
      await _pumpAlertDialogDoc(tester, mode: ColorMode.dark);
      expect(find.byType(AlertDialog), findsWidgets);
      expect(tester.takeException(), isNull);
    });

    testWidgets('flipping the theme in place keeps the page intact', (
      WidgetTester tester,
    ) async {
      final ThemeController theme = await _pumpAlertDialogDoc(
        tester,
        mode: ColorMode.dark,
      );
      expect(find.byType(AlertDialog), findsWidgets);

      theme.setMode(ColorMode.light);
      await tester.pump();

      expect(find.byType(AlertDialog), findsWidgets);
      expect(tester.takeException(), isNull);
    });
  });
}
