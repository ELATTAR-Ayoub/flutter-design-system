/// The collapsible every text-or-table section uses.
///
/// DEVIATION from the task-5 brief: `_host` wraps `child` in `Center`, which
/// the brief's version does not. Without it, `pumpWidget`'s root gives a
/// constraint tight to `tester.view.physicalSize` (1440x900 here), and a
/// `SizedBox(width: 640)` directly under that root cannot shrink below
/// 1440 — `BoxConstraints.enforce` clamps the 640 into the tight [1440,1440]
/// range, so `getSize` reports 1440 regardless of what `DocsDisclosure` does.
/// `docs_section_test.dart` and `docs_copy_button_test.dart` already document
/// and apply this same fix; this brings this file's helper in line with that
/// established convention so the width test actually exercises the
/// full-column claim it names.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/docs/docs_disclosure.dart';
import 'package:flutter/widgets.dart'
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
        TableColumnWidth;
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) => MediaQuery(
  data: const MediaQueryData(size: Size(1440, 900)),
  child: Directionality(
    textDirection: TextDirection.ltr,
    child: ThemeScope(
      controller: ThemeController(mode: ColorMode.dark),
      child: Center(child: child),
    ),
  ),
);

void main() {
  testWidgets('it is closed, and its content is not in the tree', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 640,
          child: DocsDisclosure(
            title: 'API reference',
            child: Text('the table'),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('API reference'), findsOneWidget);
    expect(
      find.text('the table'),
      findsNothing,
      reason: 'a closed disclosure must not render its content',
    );
  });

  testWidgets('the whole title row is the control and it fills the width', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 640,
          child: DocsDisclosure(title: 'Theming', child: Text('body')),
        ),
      ),
    );
    await tester.pump();

    expect(
      tester.getSize(find.byKey(DocsDisclosure.triggerKey)).width,
      640,
      reason: 'the trigger is the full column, not a text-width hit target',
    );

    await tester.tap(find.byKey(DocsDisclosure.triggerKey));
    await tester.pump();
    await tester.pump(MotionDurations.open);
    expect(find.text('body'), findsOneWidget);
  });

  testWidgets('the chevron sits hard right and rotates on open', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 640,
          child: DocsDisclosure(title: 'Source', child: Text('body')),
        ),
      ),
    );
    await tester.pump();

    expect(tester.widget<Icon>(find.byType(Icon)).lucide, Lucide.chevronDown);
    final double closed = tester
        .widget<RotationTransition>(find.byType(RotationTransition))
        .turns
        .value;

    await tester.tap(find.byKey(DocsDisclosure.triggerKey));
    await tester.pump();
    await tester.pump(MotionDurations.open);

    expect(
      tester
          .widget<RotationTransition>(find.byType(RotationTransition))
          .turns
          .value,
      isNot(closed),
    );
  });

  testWidgets('it sets no text below the supporting-copy role', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 640,
          child: DocsDisclosure(title: 'Dependencies', child: Text('body')),
        ),
      ),
    );
    await tester.pump();

    for (final StyledText text in tester.widgetList<StyledText>(
      find.byType(StyledText),
    )) {
      expect(text.text, text.text.trim(), reason: text.text);
      expect(
        text.spec.mobile.size,
        greaterThanOrEqualTo(TextStyles.small.mobile.size),
        reason: text.text,
      );
    }
  });

  testWidgets('a long title ellipsises rather than overflowing a phone', (
    WidgetTester tester,
  ) async {
    // Every one of the ninety-nine documentation pages shares this trigger,
    // so an unconstrained title here was a `RenderFlex overflowed` waiting
    // for whichever page first wrote a heading longer than the column. One
    // did ("What this port leaves out", at 390px). The fix belongs in the
    // trigger, not in the page's choice of words.
    // Enabled BEFORE the first pump: a handle taken afterwards does not
    // retroactively build the semantics tree for a frame already laid out.
    final SemanticsHandle handle = tester.ensureSemantics();

    // `_host` already pins the MediaQuery and centres its child, so the
    // narrow measure is the box handed to the disclosure itself — a phone's
    // reading column, minus its gutters.
    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 320,
          child: DocsDisclosure(
            title: 'What this port deliberately leaves out, and why',
            child: Text('body'),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);

    final Finder trigger = find.byKey(DocsDisclosure.triggerKey);
    expect(trigger, findsOneWidget);
    expect(tester.getSize(trigger).height, DocsDisclosure.triggerHeight);

    // The chevron must still be inside the trigger, not pushed past its
    // right edge by the title.
    final Finder chevron = find.descendant(
      of: trigger,
      matching: find.byType(RotationTransition),
    );
    expect(
      tester.getRect(chevron).right,
      lessThanOrEqualTo(tester.getRect(trigger).right + 1),
    );

    // And the whole title still reaches a screen reader, ellipsis or not.
    // Read off the trigger's own node rather than through
    // `find.bySemanticsLabel`, which matches on the widget element and does
    // not see a label contributed by an ancestor [Semantics] wrapper.
    expect(
      tester.getSemantics(trigger).label,
      contains('What this port deliberately leaves out, and why'),
    );
    handle.dispose();
  });
}
