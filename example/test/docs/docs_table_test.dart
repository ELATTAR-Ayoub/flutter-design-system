// example/test/docs/docs_table_test.dart
/// The tables the reference sections are made of.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/docs/docs_facts.dart' show DocsApiFact;
import 'package:example/docs/docs_table.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

// `pumpWidget`'s root gets tight constraints equal to the test view's size
// (RenderView hands its child `configuration.logicalConstraints`, which
// `tester.view.physicalSize` sets tight). A `SizedBox` sitting directly under
// that root cannot narrow below it — `RenderConstrainedBox` clamps its own
// constraints *into* whatever range the parent hands it, rather than
// intersecting, so a tight parent always wins. `Center` loosens the
// constraints it passes down, which is what lets the 640-wide `SizedBox`
// below actually measure 640 instead of the full view width.
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
  testWidgets('it is the package table, not a hand-rolled one', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 640,
          child: DocsTable(
            columns: <DocsTableColumn>[
              DocsTableColumn(header: 'Property', flex: 0.3),
              DocsTableColumn(header: 'Type', flex: 0.3),
              DocsTableColumn(header: 'Purpose', flex: 0.4),
            ],
            rows: <List<String>>[
              <String>['variant', 'ElButtonVariant', 'Which of the seven.'],
            ],
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(ElTable), findsOneWidget);
  });

  testWidgets('it fills its column with no trailing gap', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 640,
          child: DocsTable(
            columns: <DocsTableColumn>[
              DocsTableColumn(header: 'A', flex: 0.5),
              DocsTableColumn(header: 'B', flex: 0.5),
            ],
            rows: <List<String>>[
              <String>['one', 'two'],
            ],
          ),
        ),
      ),
    );
    await tester.pump();

    expect(tester.getSize(find.byType(ElTable)).width, 640);
  });

  testWidgets('the API table renders one row per fact', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 640,
          child: DocsApiTable(
            facts: <DocsApiFact>[
              DocsApiFact(
                name: 'variant',
                type: 'ElButtonVariant',
                description: 'Which of the seven.',
              ),
              DocsApiFact(
                name: 'size',
                type: 'ElButtonSize',
                description: 'Which of the nine.',
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('variant'), findsOneWidget);
    expect(find.text('size'), findsOneWidget);
  });

  testWidgets('headers use no uppercase type role', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 640,
          child: DocsApiTable(
            facts: <DocsApiFact>[
              DocsApiFact(name: 'a', type: 'b', description: 'c'),
            ],
          ),
        ),
      ),
    );
    await tester.pump();

    for (final ElText text in tester.widgetList<ElText>(find.byType(ElText))) {
      expect(text.spec.uppercase, isFalse, reason: text.text);
    }
  });
}
