// example/test/docs/docs_copy_button_test.dart
/// The copy control, which is the only affordance on a snippet.
///
/// No `pumpAndSettle`: the confirmation is a timed state and settling would
/// wait for it rather than observe it.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/docs/docs_copy_button.dart';
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
  testWidgets('it is a secondary icon button showing the copy glyph', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_host(const DocsCopyButton(text: 'const a = 1;')));
    await tester.pump();

    final ElButton button = tester.widget<ElButton>(find.byType(ElButton));
    expect(button.variant, ElButtonVariant.secondary);
    expect(button.size, ElButtonSize.iconSm);
    expect(button.label, 'Copy code');
    expect(
      tester.widget<ElIcon>(find.byType(ElIcon)).lucide,
      ElLucide.copy,
    );
  });

  testWidgets('pressing it writes the exact text and confirms', (
    WidgetTester tester,
  ) async {
    final List<String> written = <String>[];
    await tester.pumpWidget(
      _host(
        DocsCopyButton(
          text: 'const a = 1;',
          writer: (String value) async => written.add(value),
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.byType(ElButton));
    await tester.pump();
    await tester.pump();

    expect(written, <String>['const a = 1;']);
    expect(
      tester.widget<ElIcon>(find.byType(ElIcon)).lucide,
      ElLucide.check,
      reason: 'the glyph must confirm, or a copy is indistinguishable '
          'from a mis-tap',
    );
    expect(tester.widget<ElButton>(find.byType(ElButton)).label, 'Copied');

    // Drain the pending confirmation timer so the test framework does not
    // flag it as leaked at teardown; the revert itself is test 3's concern.
    await tester.pump(DocsCopyButton.confirmation);
  });

  testWidgets('the confirmation reverts', (WidgetTester tester) async {
    await tester.pumpWidget(
      _host(
        DocsCopyButton(
          text: 'x',
          writer: (String value) async {},
        ),
      ),
    );
    await tester.pump();
    await tester.tap(find.byType(ElButton));
    await tester.pump();
    await tester.pump(const Duration(seconds: 3));

    expect(tester.widget<ElIcon>(find.byType(ElIcon)).lucide, ElLucide.copy);
  });
}
