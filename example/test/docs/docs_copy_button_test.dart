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

/// Reads the icons `IconSwap` was built with, in wheel order, as their
/// `lucide` glyphs.
List<LucideGlyph> _wheelGlyphs(WidgetTester tester) => tester
    .widget<IconSwap>(find.byType(IconSwap))
    .icons
    .map((Widget w) => (w as Icon).lucide)
    .whereType<LucideGlyph>()
    .toList();

void main() {
  testWidgets('it swaps its glyph through IconSwap, resting on the copy cell', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_host(const DocsCopyButton(text: 'const a = 1;')));
    await tester.pump();

    final Button button = tester.widget<Button>(find.byType(Button));
    expect(button.variant, ButtonVariant.secondary);
    expect(button.size, ButtonSize.iconSm);
    expect(button.label, 'Copy code');
    expect(find.byType(IconSwap), findsOneWidget);

    final IconSwap swap = tester.widget<IconSwap>(find.byType(IconSwap));
    expect(swap.activeIndex, DocsCopyButton.idleIndex);
    expect(
      _wheelGlyphs(tester),
      <LucideGlyph>[Lucide.copy, Lucide.loaderCircle, Lucide.check],
      reason:
          'idle, pending and copied are three meanings on one wheel, in '
          'that order — never an instant swap between two icons',
    );
  });

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

      await tester.tap(find.byType(Button));
      await tester.pump();

      // Mid-write: the wheel has already advanced to the pending cell, and
      // the control is disabled against a second tap.
      expect(
        tester.widget<IconSwap>(find.byType(IconSwap)).activeIndex,
        DocsCopyButton.pendingIndex,
      );
      expect(tester.widget<Button>(find.byType(Button)).onPressed, isNull);

      writeGate.complete();
      await tester.pump();
      await tester.pump();

      expect(written, <String>['const a = 1;']);
      expect(
        tester.widget<IconSwap>(find.byType(IconSwap)).activeIndex,
        DocsCopyButton.copiedIndex,
        reason:
            'the wheel must confirm, or a copy is indistinguishable '
            'from a mis-tap',
      );
      expect(tester.widget<Button>(find.byType(Button)).label, 'Copied');

      // Drain the pending confirmation timer so the test framework does not
      // flag it as leaked at teardown.
      await tester.pump(DocsCopyButton.confirmation);
      expect(
        tester.widget<IconSwap>(find.byType(IconSwap)).activeIndex,
        DocsCopyButton.idleIndex,
      );
      expect(tester.widget<Button>(find.byType(Button)).label, 'Copy code');
    },
  );

  testWidgets('fires a success toast when a DocsToastScope is in scope', (
    WidgetTester tester,
  ) async {
    final ToastController controller = ToastController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      _host(
        DocsToastScope(
          controller: controller,
          child: DocsCopyButton(text: 'x', writer: (String value) async {}),
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.byType(Button));
    await tester.pump();
    await tester.pump();

    expect(controller.length, 1);
    final ToastMessage? message = controller.messageOf(0);
    expect(message?.type, ToastType.success);
    expect(message?.title, 'Copied to clipboard');

    await tester.pump(DocsCopyButton.confirmation);
  });

  testWidgets('does not throw when no DocsToastScope is in scope', (
    WidgetTester tester,
  ) async {
    // The widget's own tests everywhere else in this file pump it bare --
    // this test states that degradation as its own contract rather than
    // leaving it implicit.
    await tester.pumpWidget(
      _host(DocsCopyButton(text: 'x', writer: (String value) async {})),
    );
    await tester.pump();

    await tester.tap(find.byType(Button));
    await tester.pump();
    await tester.pump();

    expect(tester.takeException(), isNull);
    await tester.pump(DocsCopyButton.confirmation);
  });
}
