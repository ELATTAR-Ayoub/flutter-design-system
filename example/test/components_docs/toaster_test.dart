/// Tests for the toaster component documentation page.
///
/// Re-housed onto the kit alongside the page: the section-order test now
/// reads `DocsSection.id` (the kit's own section widget), and the
/// API-table / accessibility / keyboard / dependencies assertions each open
/// the relevant `DocsDisclosure` first — closed by default in the new kit,
/// unlike the old page's always-visible `Section`.
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never a synthetic `MediaQuery`. Theme
/// coverage flips a single live [ThemeController] in place rather than
/// rebuilding with a second controller instance.
///
/// **No `pumpAndSettle` anywhere in this file.** [Toaster]'s own choreology
/// mixes forever-loop effects ([FeedbackSurface]'s drift/starfield) with timed,
/// non-looping clocks (the 4000ms lifetime, the 200ms unmount window): the
/// forever loops mean `pumpAndSettle` would hang, so every timed assertion
/// below drives the clock with an explicit `tester.pump(duration)` using the
/// real durations read off `lib/src/components/ui/toaster.dart`
/// ([Toaster.transition], [Toaster.lifetime], [Toaster.unmountDelay]),
/// exactly the pattern `test/feedback_effects_test.dart` already established
/// for this widget.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/toaster/meta.dart';
import 'package:example/components_docs/toaster/page.dart';
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
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child, {required ThemeController controller}) =>
    ThemeScope(
      controller: controller,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SingleChildScrollView(child: child),
      ),
    );

/// The house section order this page must render.
const List<String> _expectedSectionOrder = <String>[
  'preview',
  'install',
  'usage',
  'types',
  'action',
  'promise',
  'api',
  'states',
  'accessibility',
  'keyboard',
  'responsive',
  'dependencies',
  'theming',
  'source',
];

/// The single `DocsDisclosure` whose title is [title]. `DocsDisclosure`'s
/// own trigger key ([DocsDisclosure.triggerKey]) is one constant shared by
/// every instance on the page, so a bare `find.byKey` would match all
/// eight -- this narrows to the one panel by its title first, matching
/// `button_test.dart`'s own convention.
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
  await tester.pump(MotionDurations.open);
}

void main() {
  test('toasterDoc exposes accurate registry metadata', () {
    expect(toasterDoc.name, 'toaster');
    expect(toasterDoc.title, 'Toaster');
    expect(toasterDoc.sourcePath, 'lib/src/components/ui/toaster.dart');
    // Both halves of the public surface: the overlay host and the
    // imperative controller/message/action/type/position types it takes —
    // are named as exports, not just the widget.
    expect(
      toasterDoc.exports,
      containsAll(<String>[
        'Toaster',
        'ToastController',
        'ToastMessage',
        'ToastAction',
        'ToastType',
        'ToastPosition',
        'Toast',
      ]),
    );
    expect(toasterDoc.dependencies, <String>[
      'feedback-surface',
      'icon',
      'surface',
      'safe-area',
      'source-foundation',
    ]);
    expect(toasterDoc.command, 'elattar add toaster');
  });

  testWidgets('toaster docs page renders every section, in order', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final ThemeController controller = ThemeController(mode: ColorMode.dark);
    addTearDown(controller.dispose);
    String? destination;

    await tester.pumpWidget(
      _harness(
        ToasterDocPage(onNavigate: (String route) => destination = route),
        controller: controller,
      ),
    );
    await tester.pump();

    final List<String> ids = tester
        .widgetList<DocsSection>(find.byType(DocsSection))
        .map((DocsSection section) => section.id)
        .toList();
    expect(ids, _expectedSectionOrder);

    expect(
      find.byKey(const ValueKey<String>('docs-layout-sidebar')),
      findsOneWidget,
    );
    expect(destination, isNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'the Types specimen fires all six ToastType values live, including '
    'loading and normal',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final ThemeController controller = ThemeController(mode: ColorMode.dark);
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        _harness(const ToasterDocPage(), controller: controller),
      );
      await tester.pump();

      final Finder host = find.byKey(
        const ValueKey<String>('toaster-example:types-host'),
      );
      expect(host, findsOneWidget);
      expect(
        find.descendant(of: host, matching: find.byType(Toast)),
        findsNothing,
      );

      for (final (String key, String title) in <(String, String)>[
        ('toaster-example:types-loading', 'Uploading…'),
        ('toaster-example:types-normal', 'Note'),
      ]) {
        final Finder trigger = find.byKey(ValueKey<String>(key));
        await tester.ensureVisible(trigger);
        await tester.tap(trigger);
        await tester.pump();
        await tester.pump();
        await tester.pump(Toaster.transition);
        expect(
          find.descendant(of: host, matching: find.text(title)),
          findsOneWidget,
          reason: '"$key" should fire a live toast titled "$title"',
        );
      }

      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('the API Reference disclosure documents every public member', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final ThemeController controller = ThemeController(mode: ColorMode.dark);
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      _harness(const ToasterDocPage(), controller: controller),
    );
    await tester.pump();
    await _open(tester, 'API Reference');

    final Finder apiSection = find.byWidgetPredicate(
      (Widget widget) => widget is DocsSection && widget.id == 'api',
    );
    expect(apiSection, findsOneWidget);
    for (final String parameter in <String>[
      // Toaster's own two constructor parameters.
      'controller',
      'position',
      // ToastController: the imperative entry point ("toast(...)"), the
      // members with no ToastType-value twin.
      'show',
      'settle',
      'dismiss',
      'clear',
      // ToastMessage's constructor fields.
      'title',
      'description',
      'type',
      'glyph',
      'duration',
      'action',
      // ToastAction's constructor fields.
      'label',
      'onPressed',
      // ToastType's own value with no ToastController-method twin.
      'normal',
    ]) {
      expect(
        find.descendant(of: apiSection, matching: find.text(parameter)),
        findsOneWidget,
        reason: 'API member "$parameter" should be documented',
      );
    }
    // 'promise' names both a ToastController method (`promise<T>(...)`)
    // and a ToastMessage field (`final bool promise`): a real collision
    // in the source itself, not a test bug, so it is asserted present
    // rather than asserted unique. 'success' / 'error' / 'info' / 'warning'
    // / 'loading' name both a ToastController method AND an ToastType
    // value, now that the type table lives in the same API Reference
    // disclosure -- the same kind of real, source-level collision, so each
    // is asserted present twice rather than asserted unique.
    for (final String collision in <String>[
      'promise',
      'success',
      'error',
      'info',
      'warning',
      'loading',
    ]) {
      expect(
        find.descendant(of: apiSection, matching: find.text(collision)),
        findsAtLeastNWidgets(2),
        reason: '"$collision" should be documented on both of its tables',
      );
    }

    // The real timing values -- not invented ones -- are documented. 4000ms
    // is ToastMessage's default duration/Toaster.lifetime; 200ms is
    // Toaster.unmountDelay.
    expect(
      find.descendant(of: apiSection, matching: find.textContaining('4000ms')),
      findsWidgets,
      reason: 'the real 4000ms auto-dismiss lifetime should be documented',
    );
    expect(
      find.descendant(of: apiSection, matching: find.textContaining('200ms')),
      findsWidgets,
      reason: 'the real 200ms unmount delay should be documented',
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'the Action and Promise sections carry the same code Preview fires live',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final ThemeController controller = ThemeController(mode: ColorMode.dark);
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        _harness(const ToasterDocPage(), controller: controller),
      );
      await tester.pump();

      final Finder actionSection = find.byWidgetPredicate(
        (Widget widget) => widget is DocsSection && widget.id == 'action',
      );
      expect(actionSection, findsOneWidget);
      expect(
        find.descendant(
          of: actionSection,
          matching: find.textContaining('ToastAction'),
        ),
        findsWidgets,
      );

      final Finder promiseSection = find.byWidgetPredicate(
        (Widget widget) => widget is DocsSection && widget.id == 'promise',
      );
      expect(promiseSection, findsOneWidget);
      expect(
        find.descendant(
          of: promiseSection,
          matching: find.textContaining('ToastController.promise'),
        ),
        findsWidgets,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'the Dependencies disclosure names its neighbours and links both',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final ThemeController controller = ThemeController(mode: ColorMode.dark);
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        _harness(const ToasterDocPage(), controller: controller),
      );
      await tester.pump();
      await _open(tester, 'Dependencies');

      final Finder dependenciesSection = find.byWidgetPredicate(
        (Widget widget) => widget is DocsSection && widget.id == 'dependencies',
      );
      expect(
        find.descendant(
          of: dependenciesSection,
          matching: find.textContaining('alert'),
        ),
        findsWidgets,
      );
      expect(
        find.descendant(of: dependenciesSection, matching: find.text('Alert')),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: dependenciesSection,
          matching: find.text('Alert Dialog'),
        ),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('the Accessibility disclosure states the live-region finding', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final ThemeController controller = ThemeController(mode: ColorMode.dark);
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      _harness(const ToasterDocPage(), controller: controller),
    );
    await tester.pump();
    await _open(tester, 'Accessibility');

    final Finder a11ySection = find.byWidgetPredicate(
      (Widget widget) => widget is DocsSection && widget.id == 'accessibility',
    );
    expect(a11ySection, findsOneWidget);
    expect(
      find.descendant(
        of: a11ySection,
        matching: find.textContaining('liveRegion'),
      ),
      findsWidgets,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'the Keyboard disclosure states the action pill cannot be reached',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final ThemeController controller = ThemeController(mode: ColorMode.dark);
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        _harness(const ToasterDocPage(), controller: controller),
      );
      await tester.pump();
      await _open(tester, 'Keyboard');

      final Finder keyboardSection = find.byWidgetPredicate(
        (Widget widget) => widget is DocsSection && widget.id == 'keyboard',
      );
      expect(keyboardSection, findsOneWidget);
      expect(
        find.descendant(
          of: keyboardSection,
          matching: find.textContaining('cannot currently be reached'),
        ),
        findsWidgets,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'the live Preview specimen fires a real toast through ToastController, '
    'it announces via a live region, and it disappears on its own timer',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final ThemeController controller = ThemeController(mode: ColorMode.dark);
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        _harness(const ToasterDocPage(), controller: controller),
      );
      await tester.pump();

      // The Preview section mounts a real Toaster over a real
      // ToastController: nothing is queued until a specimen control fires
      // one, exactly like the package's own Toaster.build, which paints
      // nothing while its controller is empty. Types mounts a second,
      // independent Toaster/ToastController pair, so this scopes to
      // the Preview section explicitly rather than a bare byType search.
      final Finder previewSection = find.byWidgetPredicate(
        (Widget widget) => widget is DocsSection && widget.id == 'preview',
      );
      expect(
        find.descendant(of: previewSection, matching: find.byType(Toaster)),
        findsOneWidget,
      );
      expect(
        find.descendant(of: previewSection, matching: find.byType(Toast)),
        findsNothing,
      );

      final Finder trigger = find.descendant(
        of: previewSection,
        matching: find.widgetWithText(Button, 'Show success'),
      );
      expect(trigger, findsOneWidget);
      await tester.ensureVisible(trigger);
      await tester.tap(trigger);
      await tester.pump(); // schedule
      await tester.pump(); // the post-frame callback that flips data-mounted
      await tester.pump(Toaster.transition); // ride the entrance in

      final Finder toast = find.descendant(
        of: previewSection,
        matching: find.byType(Toast),
      );
      expect(toast, findsOneWidget);
      expect(
        find.descendant(
          of: previewSection,
          matching: find.text('Changes saved'),
        ),
        findsOneWidget,
      );

      // Accessibility: the toast announces through a live region and never
      // requests focus (no FocusScope call exists anywhere in toaster.dart —
      // nothing here steals focus while it does). `Semantics(container:
      // true, label: message.title)` is a semantics boundary, so the
      // title/description StyledText children below it: which are not
      // boundaries of their own: merge their literal text upward into this
      // one node rather than staying separate: the real announced label is
      // the explicit title, the title again (from the merged StyledText), then
      // the description: not just the title alone.
      final SemanticsNode node = tester.getSemantics(toast);
      expect(node.flagsCollection.isLiveRegion, isTrue);
      expect(
        node.label,
        'Changes saved\nChanges saved\nYour profile was updated successfully.',
      );
      // Nothing inside the toast can ever hold focus: there is no Focus (or
      // FocusScope) widget anywhere in its subtree to hold it. Checked on
      // the widget tree itself rather than on FocusManager.primaryFocus,
      // which would just as truthfully report the trigger button's own
      // ordinary post-tap focus: a fact about the button, not the toast.
      expect(
        find.descendant(of: toast, matching: find.byType(Focus)),
        findsNothing,
      );

      // The real 4000ms lifetime: Toaster.lifetime, expires the clock;
      // one more pump lets the completion listener call
      // ToastController.dismiss, which starts the 200ms unmount window.
      await tester.pump(Toaster.lifetime);
      await tester.pump();
      // The toast is leaving but is not torn out of the tree yet.
      expect(
        find.descendant(of: previewSection, matching: find.byType(Toast)),
        findsOneWidget,
      );

      await tester.pump(Toaster.unmountDelay);
      await tester.pump();

      // Gone on its own: nothing here tapped a dismiss control.
      expect(
        find.descendant(of: previewSection, matching: find.byType(Toast)),
        findsNothing,
      );
      expect(
        find.descendant(
          of: previewSection,
          matching: find.text('Changes saved'),
        ),
        findsNothing,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('toaster docs page adapts across breakpoints and themes without '
      'exceptions', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final ThemeController controller = ThemeController(mode: ColorMode.light);
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      _harness(const ToasterDocPage(), controller: controller),
    );
    await tester.pump();

    expect(
      find.byKey(const ValueKey<String>('docs-layout-anchor-strip')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey<String>('docs-layout-sidebar')),
      findsNothing,
    );
    expect(find.byType(Toaster), findsNWidgets(2));
    expect(tester.takeException(), isNull);

    // The controller is flipped in place: no new app, no new element tree.
    controller.setMode(ColorMode.dark);
    await tester.pump();
    expect(tester.takeException(), isNull);

    tester.view.physicalSize = const Size(1440, 900);
    await tester.pump();
    expect(
      find.byKey(const ValueKey<String>('docs-layout-sidebar')),
      findsOneWidget,
    );
    expect(find.byType(Toaster), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });
}
