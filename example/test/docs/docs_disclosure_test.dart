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
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) => MediaQuery(
  data: const MediaQueryData(size: Size(1440, 900)),
  child: Directionality(
    textDirection: TextDirection.ltr,
    child: ElTheme(
      controller: ElThemeController(mode: ElThemeMode.dark),
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
    await tester.pump(ElDurations.jelly);
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

    expect(
      tester.widget<ElIcon>(find.byType(ElIcon)).lucide,
      ElLucide.chevronDown,
    );
    final double closed = tester
        .widget<RotationTransition>(find.byType(RotationTransition))
        .turns
        .value;

    await tester.tap(find.byKey(DocsDisclosure.triggerKey));
    await tester.pump();
    await tester.pump(ElDurations.jelly);

    expect(
      tester
          .widget<RotationTransition>(find.byType(RotationTransition))
          .turns
          .value,
      isNot(closed),
    );
  });

  testWidgets('it uses no uppercase type role', (WidgetTester tester) async {
    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 640,
          child: DocsDisclosure(title: 'Dependencies', child: Text('body')),
        ),
      ),
    );
    await tester.pump();

    for (final ElText text in tester.widgetList<ElText>(find.byType(ElText))) {
      expect(text.spec.uppercase, isFalse, reason: text.text);
    }
  });
}
