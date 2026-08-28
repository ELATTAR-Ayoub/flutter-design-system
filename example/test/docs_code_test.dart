import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/docs/docs_code.dart';
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
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child) => ThemeScope(
  controller: ThemeController(mode: ColorMode.dark),
  child: MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(body: SingleChildScrollView(child: child)),
  ),
);

void main() {
  testWidgets('switches between preview, cli, and manual tabs', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _harness(
        DocsCodeExample(
          title: 'Install button',
          preview: const Text('Preview body'),
          command: const DocsCodeCommand(command: 'dart run lfr add button'),
          manualFiles: const <DocsCodeFile>[
            DocsCodeFile(
              path: 'lib/components/ui/button.dart',
              code: 'class Button {}',
            ),
          ],
        ),
      ),
    );

    expect(find.text('Preview body'), findsOneWidget);
    expect(find.text('dart run lfr add button'), findsNothing);
    expect(find.text('class Button {}'), findsNothing);

    await tester.tap(find.text('CLI'));
    await tester.pumpAndSettle();
    expect(find.text('dart run lfr add button'), findsOneWidget);

    await tester.tap(find.text('Manual'));
    await tester.pumpAndSettle();
    expect(find.text('class Button {}'), findsOneWidget);
  });

  testWidgets('copy success uses injected clipboard writer and feedback seam', (
    WidgetTester tester,
  ) async {
    String? copied;
    final List<ToastMessage> feedback = <ToastMessage>[];

    await tester.pumpWidget(
      _harness(
        DocsCodeExample(
          title: 'Install button',
          command: const DocsCodeCommand(
            command: 'dart run lfr add button',
            label: 'Install button',
          ),
          clipboardWriter: (String text) async => copied = text,
          onFeedback: feedback.add,
        ),
      ),
    );

    await tester.tap(find.bySemanticsLabel('Copy command'));
    await tester.pumpAndSettle();

    expect(copied, 'dart run lfr add button');
    expect(feedback, hasLength(1));
    expect(feedback.single.title, 'Command copied');
    expect(feedback.single.type, ToastType.success);
    expect(feedback.single.description, 'Install button');
  });

  testWidgets(
    'copy failure emits error feedback and keeps manual source visible',
    (WidgetTester tester) async {
      final List<ToastMessage> feedback = <ToastMessage>[];

      await tester.pumpWidget(
        _harness(
          DocsCodeExample(
            title: 'Manual install',
            manualFiles: const <DocsCodeFile>[
              DocsCodeFile(
                path: 'lib/components/ui/card.dart',
                code: 'class CardWidget {}',
              ),
            ],
            clipboardWriter: (String text) =>
                Future<void>.error(Exception('no')),
            onFeedback: feedback.add,
          ),
        ),
      );

      expect(find.text('class CardWidget {}'), findsOneWidget);
      await tester.tap(
        find.bySemanticsLabel('Copy lib/components/ui/card.dart'),
      );
      await tester.pumpAndSettle();

      expect(feedback, hasLength(1));
      expect(feedback.single.title, 'Copy failed');
      expect(feedback.single.type, ToastType.error);
      expect(find.text('class CardWidget {}'), findsOneWidget);
    },
  );

  testWidgets(
    'selectable code block stays horizontally scrollable on a narrow viewport',
    (WidgetTester tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(390, 844);
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _harness(
          const DocsSelectableCodeBlock(
            code:
                'dart run lfr add really-long-component-name --foundation source',
          ),
        ),
      );

      expect(
        find.byKey(const ValueKey<String>('docs-code-scroll')),
        findsOneWidget,
      );
      expect(
        find.text(
          'dart run lfr add really-long-component-name --foundation source',
        ),
        findsOneWidget,
      );
    },
  );
}
