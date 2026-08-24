/// Tests for the toaster component documentation page.
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never a synthetic `MediaQuery`. Theme
/// coverage flips a single live [ElThemeController] in place rather than
/// rebuilding with a second controller instance.
///
/// **No `pumpAndSettle` anywhere in this file.** [ElToaster]'s own choreology
/// mixes forever-loop effects ([ElBloomCosmic]'s drift/starfield) with timed,
/// non-looping clocks (the 4000ms lifetime, the 200ms unmount window): the
/// forever loops mean `pumpAndSettle` would hang, so every timed assertion
/// below drives the clock with an explicit `tester.pump(duration)` using the
/// real durations read off `lib/src/components/toaster.dart`
/// ([ElToaster.transition], [ElToaster.lifetime], [ElToaster.unmountDelay]),
/// exactly the pattern `test/feedback_effects_test.dart` already established
/// for this widget.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/toaster/meta.dart';
import 'package:example/components_docs/toaster/page.dart';
import 'package:example/kit.dart' show ElSection;
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child, {required ElThemeController controller}) =>
    ElTheme(
      controller: controller,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SingleChildScrollView(child: child),
      ),
    );

/// The shadcn-parity section order (worker brief, `toaster` component,
/// counterpart `https://ui.shadcn.com/docs/components/base/toast`): a live
/// demo ahead of any heading (no entry here), Installation, Usage, When to
/// use it (this component's own decision-guidance addition), Types, Action,
/// Promise, API Reference, then the six fixed extras.
const List<String> _expectedSectionHeadings = <String>[
  'Installation',
  'Usage',
  'When to use it',
  'Types',
  'Action',
  'Promise',
  'API Reference',
  'States',
  'Accessibility',
  'Responsive',
  'Dependencies',
  'Theming',
  'Source',
];

void main() {
  test('toasterDoc exposes accurate, non-registry metadata', () {
    expect(toasterDoc.name, 'toaster');
    expect(toasterDoc.title, 'Toaster');
    expect(toasterDoc.sourcePath, 'lib/src/components/toaster.dart');
    // Both halves of the public surface: the overlay host and the
    // imperative controller/message/action/type/position types it takes —
    // are named as exports, not just the widget.
    expect(
      toasterDoc.exports,
      containsAll(<String>[
        'ElToaster',
        'ElToastController',
        'ElToastMessage',
        'ElToastAction',
        'ElToastType',
        'ElToastPosition',
        'ElToast',
      ]),
    );
    expect(toasterDoc.dependencies, <String>[
      'bloom-cosmic',
      'icon',
      'machine-surface',
      'safe-area',
      'source-foundation',
    ]);
  });

  testWidgets(
    'toaster docs page renders the article and documents every public '
    'constructor parameter, controller method, and message field',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final ElThemeController controller = ElThemeController(
        mode: ElThemeMode.dark,
      );
      addTearDown(controller.dispose);
      String? destination;

      await tester.pumpWidget(
        _harness(
          ToasterDocPage(onNavigate: (String route) => destination = route),
          controller: controller,
        ),
      );
      await tester.pump();

      expect(find.text('Toaster'), findsWidgets);
      expect(
        find.byKey(const ValueKey<String>('docs-layout-sidebar')),
        findsOneWidget,
      );

      // The API section documents ElToaster's own constructor, the imperative
      // ElToastController surface, and the ElToastMessage/ElToastAction
      // fields that make up the message a caller queues.
      final Finder apiSection = find.byKey(ElSection.anchorKey('api'));
      expect(apiSection, findsOneWidget);
      for (final String parameter in <String>[
        // ElToaster's own two constructor parameters.
        'controller',
        'position',
        // ElToastController: the imperative entry point ("toast(...)").
        'show',
        'success',
        'error',
        'info',
        'warning',
        'loading',
        'settle',
        'dismiss',
        'clear',
        // ElToastMessage's constructor fields.
        'title',
        'description',
        'type',
        'glyph',
        'duration',
        'action',
        // ElToastAction's constructor fields.
        'label',
        'onPressed',
      ]) {
        expect(
          find.descendant(of: apiSection, matching: find.text(parameter)),
          findsOneWidget,
          reason: 'API member "$parameter" should be documented',
        );
      }
      // 'promise' names both a ElToastController method (`promise<T>(...)`)
      // and a ElToastMessage field (`final bool promise`): a real collision
      // in the source itself, not a test bug, so it is asserted present
      // rather than asserted unique.
      expect(
        find.descendant(of: apiSection, matching: find.text('promise')),
        findsWidgets,
        reason:
            'both the promise() method and the promise field should be '
            'documented',
      );

      // Every ElToastType value is documented as the component's status
      // variants, mirroring shadcn's own Types section.
      final Finder typesSection = find.byKey(ElSection.anchorKey('types'));
      expect(typesSection, findsOneWidget);
      for (final String type in <String>[
        'success',
        'info',
        'warning',
        'error',
        'loading',
        'normal',
      ]) {
        expect(
          find.descendant(of: typesSection, matching: find.text(type)),
          findsOneWidget,
          reason: 'ElToastType.$type should be documented',
        );
      }

      // Action and Promise are each mirrored as their own top-level
      // sections, matching shadcn's own split rather than one combined
      // "Usage" example.
      final Finder actionSection = find.byKey(ElSection.anchorKey('action'));
      expect(actionSection, findsOneWidget);
      expect(
        find.descendant(
          of: actionSection,
          matching: find.textContaining('ElToastAction'),
        ),
        findsWidgets,
      );
      final Finder promiseSection = find.byKey(ElSection.anchorKey('promise'));
      expect(promiseSection, findsOneWidget);
      expect(
        find.descendant(
          of: promiseSection,
          matching: find.textContaining('ElToastController.promise'),
        ),
        findsWidgets,
      );

      // The real timing values: not invented ones, are on the page. 4000ms
      // is ElToastMessage's default duration/ElToaster.lifetime; 3 is
      // ElToaster.visibleLimit.
      expect(
        find.textContaining('4000ms'),
        findsWidgets,
        reason: 'the real 4000ms auto-dismiss lifetime should be documented',
      );
      expect(
        find.textContaining('200ms'),
        findsWidgets,
        reason: 'the real 200ms unmount delay should be documented',
      );

      // The install section names the command that installs it. It asserted
      // the opposite until the registry covered the whole component surface.
      final Finder installSection = find.byKey(ElSection.anchorKey('install'));
      expect(installSection, findsOneWidget);
      expect(
        find.descendant(
          of: installSection,
          matching: find.textContaining('elattar add toaster'),
        ),
        findsWidgets,
      );

      // The "When to use it" section names its neighbours instead of
      // restating the component's own name (IA 9.2's decision-guidance
      // contract): the alert/alert-dialog/toaster trio.
      final Finder whenToUseSection = find.byKey(
        ElSection.anchorKey('when-to-use'),
      );
      expect(whenToUseSection, findsOneWidget);
      expect(
        find.descendant(
          of: whenToUseSection,
          matching: find.textContaining('alert'),
        ),
        findsWidgets,
      );

      // The accessibility section states the live-region finding plainly.
      final Finder a11ySection = find.byKey(ElSection.anchorKey('a11y'));
      expect(a11ySection, findsOneWidget);
      expect(
        find.descendant(
          of: a11ySection,
          matching: find.textContaining('liveRegion'),
        ),
        findsWidgets,
      );

      // No prose link fires the router: onNavigate stays untouched.
      expect(destination, isNull);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'the live specimen fires a real toast through ElToastController, it '
    'announces via a live region, and it disappears on its own timer',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final ElThemeController controller = ElThemeController(
        mode: ElThemeMode.dark,
      );
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        _harness(const ToasterDocPage(), controller: controller),
      );
      await tester.pump();

      // The preview section mounts a real ElToaster over a real
      // ElToastController: nothing is queued until a specimen control fires
      // one, exactly like the package's own ElToaster.build, which paints
      // nothing while its controller is empty.
      expect(find.byType(ElToaster), findsOneWidget);
      expect(find.byType(ElToast), findsNothing);

      final Finder trigger = find.widgetWithText(ElButton, 'Show success');
      expect(trigger, findsOneWidget);
      await tester.ensureVisible(trigger);
      await tester.tap(trigger);
      await tester.pump(); // schedule
      await tester.pump(); // the post-frame callback that flips data-mounted
      await tester.pump(ElToaster.transition); // ride the entrance in

      expect(find.byType(ElToast), findsOneWidget);
      expect(find.text('Changes saved'), findsOneWidget);

      // Accessibility: the toast announces through a live region and never
      // requests focus (no FocusScope call exists anywhere in toaster.dart —
      // nothing here steals focus while it does). `Semantics(container:
      // true, label: message.title)` is a semantics boundary, so the
      // title/description ElText children below it: which are not
      // boundaries of their own: merge their literal text upward into this
      // one node rather than staying separate: the real announced label is
      // the explicit title, the title again (from the merged ElText), then
      // the description: not just the title alone.
      final SemanticsNode node = tester.getSemantics(find.byType(ElToast));
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
        find.descendant(of: find.byType(ElToast), matching: find.byType(Focus)),
        findsNothing,
      );

      // The real 4000ms lifetime: ElToaster.lifetime, expires the clock;
      // one more pump lets the completion listener call
      // ElToastController.dismiss, which starts the 200ms unmount window.
      await tester.pump(ElToaster.lifetime);
      await tester.pump();
      // The toast is leaving but is not torn out of the tree yet.
      expect(find.byType(ElToast), findsOneWidget);

      await tester.pump(ElToaster.unmountDelay);
      await tester.pump();

      // Gone on its own: nothing here tapped a dismiss control.
      expect(find.byType(ElToast), findsNothing);
      expect(find.text('Changes saved'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('toaster docs page adapts across breakpoints and themes without '
      'exceptions', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final ElThemeController controller = ElThemeController(
      mode: ElThemeMode.light,
    );
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
    expect(find.byType(ElToaster), findsOneWidget);
    expect(tester.takeException(), isNull);

    // The controller is flipped in place: no new app, no new element tree.
    controller.setMode(ElThemeMode.dark);
    await tester.pump();
    expect(tester.takeException(), isNull);

    tester.view.physicalSize = const Size(1440, 900);
    await tester.pump();
    expect(
      find.byKey(const ValueKey<String>('docs-layout-sidebar')),
      findsOneWidget,
    );
    expect(find.byType(ElToaster), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('toaster docs page renders the shadcn-parity section headings '
      'in order, with no heading before Installation', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final ElThemeController controller = ElThemeController(
      mode: ElThemeMode.dark,
    );
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      _harness(const ToasterDocPage(), controller: controller),
    );
    await tester.pump();

    final List<String> headings = tester
        .widgetList<ElText>(find.byType(ElText))
        .where((ElText text) => text.spec == ElType.h3)
        .map((ElText text) => text.text)
        .toList();

    expect(headings, _expectedSectionHeadings);

    // The old convention's own headings must not survive the reshape.
    // Section headings only: DocsCodeExample renders its own "Preview" tab
    // label as free text, so a plain find.text('Preview') finds that
    // affordance rather than a leftover heading. Read the mounted ElSection
    // titles instead, which are immune to that collision.
    final List<String> sectionTitles = tester
        .widgetList<ElSection>(find.byType(ElSection))
        .map((ElSection section) => section.title)
        .toList();
    expect(sectionTitles, isNot(contains('Purpose')));
    expect(sectionTitles, isNot(contains('Status')));
    expect(sectionTitles, isNot(contains('Preview')));
    expect(sectionTitles, isNot(contains('Composition')));
    expect(sectionTitles, isNot(contains('Composition examples')));
  });
}
