// example/test/docs/docs_copy_button_test.dart
/// The copy control, which is the only affordance on a snippet.
///
/// No `pumpAndSettle`: the confirmation is a timed state and settling would
/// wait for it rather than observe it.
library;

import 'dart:async';

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/docs/docs_copy_button.dart';
import 'package:example/docs/docs_toast_scope.dart';
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

/// Reads the icons `ElIconSwap` was built with, in wheel order, as their
/// `lucide` glyphs.
List<ElLucideGlyph> _wheelGlyphs(WidgetTester tester) => tester
    .widget<ElIconSwap>(find.byType(ElIconSwap))
    .icons
    .map((Widget w) => (w as ElIcon).lucide)
    .whereType<ElLucideGlyph>()
    .toList();

void main() {
  testWidgets(
    'it swaps its glyph through ElIconSwap, resting on the copy cell',
    (WidgetTester tester) async {
      await tester.pumpWidget(_host(const DocsCopyButton(text: 'const a = 1;')));
      await tester.pump();

      final ElButton button = tester.widget<ElButton>(find.byType(ElButton));
      expect(button.variant, ElButtonVariant.secondary);
      expect(button.size, ElButtonSize.iconSm);
      expect(button.label, 'Copy code');
      expect(find.byType(ElIconSwap), findsOneWidget);

      final ElIconSwap swap = tester.widget<ElIconSwap>(
        find.byType(ElIconSwap),
      );
      expect(swap.activeIndex, DocsCopyButton.idleIndex);
      expect(
        _wheelGlyphs(tester),
        <ElLucideGlyph>[ElLucide.copy, ElLucide.loaderCircle, ElLucide.check],
        reason:
            'idle, pending and copied are three meanings on one wheel, in '
            'that order — never an instant swap between two icons',
      );
    },
  );

  testWidgets(
    'pressing it rolls idle -> pending -> copied and back, writing the exact text',
    (WidgetTester tester) async {
      final List<String> written = <String>[];
      final Completer<void> writeGate = Completer<void>();
      await tester.pumpWidget(
        _host(
          DocsCopyButton(
            text: 'const a = 1;',
            writer: (String value) async {
              written.add(value);
              await writeGate.future;
            },
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.byType(ElButton));
      await tester.pump();

      // Mid-write: the wheel has already advanced to the pending cell, and
      // the control is disabled against a second tap.
      expect(
        tester.widget<ElIconSwap>(find.byType(ElIconSwap)).activeIndex,
        DocsCopyButton.pendingIndex,
      );
      expect(tester.widget<ElButton>(find.byType(ElButton)).onPressed, isNull);

      writeGate.complete();
      await tester.pump();
      await tester.pump();

      expect(written, <String>['const a = 1;']);
      expect(
        tester.widget<ElIconSwap>(find.byType(ElIconSwap)).activeIndex,
        DocsCopyButton.copiedIndex,
        reason: 'the wheel must confirm, or a copy is indistinguishable '
            'from a mis-tap',
      );
      expect(tester.widget<ElButton>(find.byType(ElButton)).label, 'Copied');

      // Drain the pending confirmation timer so the test framework does not
      // flag it as leaked at teardown.
      await tester.pump(DocsCopyButton.confirmation);
      expect(
        tester.widget<ElIconSwap>(find.byType(ElIconSwap)).activeIndex,
        DocsCopyButton.idleIndex,
      );
      expect(tester.widget<ElButton>(find.byType(ElButton)).label, 'Copy code');
    },
  );

  testWidgets(
    'fires a success toast when a DocsToastScope is in scope',
    (WidgetTester tester) async {
      final ElToastController controller = ElToastController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        _host(
          DocsToastScope(
            controller: controller,
            child: DocsCopyButton(
              text: 'x',
              writer: (String value) async {},
            ),
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.byType(ElButton));
      await tester.pump();
      await tester.pump();

      expect(controller.length, 1);
      final ElToastMessage? message = controller.messageOf(0);
      expect(message?.type, ElToastType.success);
      expect(message?.title, 'Copied to clipboard');

      await tester.pump(DocsCopyButton.confirmation);
    },
  );

  testWidgets(
    'does not throw when no DocsToastScope is in scope',
    (WidgetTester tester) async {
      // The widget's own tests everywhere else in this file pump it bare --
      // this test states that degradation as its own contract rather than
      // leaving it implicit.
      await tester.pumpWidget(
        _host(DocsCopyButton(text: 'x', writer: (String value) async {})),
      );
      await tester.pump();

      await tester.tap(find.byType(ElButton));
      await tester.pump();
      await tester.pump();

      expect(tester.takeException(), isNull);
      await tester.pump(DocsCopyButton.confirmation);
    },
  );
}
