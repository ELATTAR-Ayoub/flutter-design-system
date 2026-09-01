/// Regression coverage for layout defects found under 200% text scale in a
/// narrow (390×844 phone) box: a fixed part of a Row that never gives, next
/// to text that should have shrunk via [Flexible]/[Expanded] instead of
/// painting past its container. See AGENTS.md's Row rule.
library;

import 'dart:typed_data';

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart'
    hide
        AspectRatio,
        Icon,
        OverlayPortal,
        RichText,
        SafeArea,
        ScrollPosition,
        Table,
        TableColumnWidth;
import 'package:flutter/material.dart' show MaterialApp, Material;
import 'package:flutter_test/flutter_test.dart';

/// A real app root, at a given text scale — see `interaction_kernel_test.dart`.
Widget host(
  Widget child, {
  ColorMode mode = ColorMode.dark,
  double textScale = 1,
}) => ThemeScope(
  controller: ThemeController(mode: mode),
  child: MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Builder(
      builder: (BuildContext context) => MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: TextScaler.linear(textScale)),
        child: Builder(
          builder: (BuildContext context) {
            _lastContext = context;
            return DefaultTextStyle(
              style: StyledText.styleOf(
                context,
                TextStyles.body,
                color: ThemeScope.of(context).foreground,
              ),
              child: Material(child: child),
            );
          },
        ),
      ),
    ),
  ),
);

/// A 390×844 phone at 2x text scale, the two review passes' worst case.
Widget narrowPhone(Widget child, {double width = 390}) =>
    host(SizedBox(width: width, height: 844, child: child), textScale: 2);

void main() {
  group('ApprovalCard — action row at 2x text scale', () {
    const PendingApproval approval = PendingApproval(
      turnId: 'x',
      action: 'open_page',
      params: <String, Object?>{'url': '/vault'},
      approve: _nothing,
      reject: _nothingReject,
    );

    testWidgets('the actions survive a narrow box instead of overflowing', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        narrowPhone(const ApprovalCard(approval: approval), width: 220),
      );
      await tester.pump();
      expect(tester.takeException(), isNull);
    });
  });

  group('AgentAttachmentCard — description row at 2x text scale', () {
    const AgentAttachment longName = AgentAttachment(
      id: 'a',
      name: 'quarterly-vault-export-with-a-very-long-file-name.csv',
      mime: 'text/csv',
      kind: AgentAttachmentKind.data,
      size: 18422,
      delivery: AgentDelivery.reference(
        'It is not text, so only the name reached the model.',
      ),
    );

    testWidgets('the card survives a narrow box instead of overflowing', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        narrowPhone(
          const AgentAttachmentCard(attachment: longName),
          width: 220,
        ),
      );
      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets('the card survives inside a Wrap, unbounded, too', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        narrowPhone(
          Wrap(
            children: const <Widget>[AgentAttachmentCard(attachment: longName)],
          ),
          width: 220,
        ),
      );
      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets('the card survives an unbounded height, the real repro', (
      WidgetTester tester,
    ) async {
      // The two review passes' actual failure: `_Grid` gives the card a
      // bounded, tight *width* (via `Expanded`) but an unbounded *height*
      // (it sits in a scrollable column) — the combination `IntrinsicWidth`
      // mishandled. `SingleChildScrollView` reproduces the unbounded height
      // without pulling in the rest of `AgentAttachmentList`.
      await tester.pumpWidget(
        narrowPhone(
          SingleChildScrollView(
            child: Row(
              children: <Widget>[
                Expanded(child: AgentAttachmentCard(attachment: longName)),
              ],
            ),
          ),
          width: 260,
        ),
      );
      await tester.pump();
      expect(tester.takeException(), isNull);
    });
  });

  group('Avatar — a broken image falls back instead of throwing', () {
    testWidgets('corrupt bytes render the initials, not a FlutterError', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        host(
          Avatar(
            fallback: 'AB',
            image: MemoryImage(Uint8List.fromList(<int>[1, 2, 3, 4, 5])),
          ),
        ),
      );
      await tester.runAsync(() async {
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 50));
      });
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.text('AB'), findsOneWidget);
    });
  });

  group('Button — a loading label at 2x text scale in a narrow box', () {
    testWidgets('the label survives instead of overflowing', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        narrowPhone(
          SizedBox(
            width: 96,
            child: Button(
              loading: true,
              onPressed: () {},
              child: const Text(
                'A rather long label that does not fit beside a spinner',
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(tester.takeException(), isNull);
    });
  });

  group('DatePicker — trigger label at 2x text scale in a narrow box', () {
    testWidgets('the trigger survives instead of overflowing', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        narrowPhone(
          SizedBox(
            width: 96,
            child: DatePicker(value: DateTime(2026, 8, 31), onChanged: (_) {}),
          ),
        ),
      );
      await tester.pump();
      expect(tester.takeException(), isNull);
    });
  });

  group('Bubble — intrinsic height agrees with the real layout', () {
    const String longText =
        'This message is long enough that an 80%-of-column cap forces it to '
        'wrap across several lines rather than sit on one.';

    Widget bubble() => Bubble(
      child: BubbleContent(child: StyledText(longText, TextStyles.body)),
    );

    testWidgets(
      'computeMaxIntrinsicHeight agrees with the real laid-out height',
      (WidgetTester tester) async {
        // `SingleChildScrollView` gives its child a genuinely *unbounded*
        // height, the same way a chat column does — under a bounded one
        // Bubble's own `Align(centerStart)` fills the whole slot (Align
        // expands to fill any bounded axis), which would report the ambient
        // box's height rather than the content's, and hide the very
        // mismatch this test exists to catch.
        await tester.pumpWidget(
          narrowPhone(
            SingleChildScrollView(
              child: Align(
                alignment: Alignment.topLeft,
                child: SizedBox(width: 300, child: bubble()),
              ),
            ),
          ),
        );
        await tester.pump();
        expect(tester.takeException(), isNull);

        final RenderBox box = tester.renderObject<RenderBox>(
          find.byType(Bubble),
        );
        final double real = box.size.height;
        // The actual contract [_RenderMaxWidthFraction] has to keep: a
        // parent that measures this box intrinsically (any `IntrinsicHeight`
        // ancestor — `Grid`'s own cells, a chat page's rows) must be told at
        // least as much height as [performLayout] is about to take. A test
        // that only pumps `Bubble` in a box and checks for an exception would
        // stay green even with the old, unfixed proxy — nothing here ever
        // asks it an intrinsic question.
        final double intrinsic = box.getMaxIntrinsicHeight(300);
        expect(
          intrinsic,
          greaterThanOrEqualTo(real - 0.5),
          reason:
              'an intrinsic query that reports a shorter box than the real '
              'one under-reserves height for every consumer of Bubble',
        );
      },
    );
  });

  group('Stat — the error message at 2x text scale in a narrow cell', () {
    testWidgets('the message survives instead of overflowing', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        narrowPhone(
          const SizedBox(
            width: 140,
            child: Stat(
              label: 'Revenue',
              value: r'$12,480',
              state: StatState.error,
              message: 'Could not load the latest figures for this period',
            ),
          ),
        ),
      );
      await tester.pump();
      expect(tester.takeException(), isNull);
    });
  });

  group('Item — actions slot shrink-wraps instead of claiming the row', () {
    testWidgets('the content stays visible instead of being squeezed out', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        narrowPhone(
          SizedBox(
            width: 260,
            child: Item(
              content: const ItemContent(
                children: <Widget>[
                  ItemTitle('A fairly long title that wants the row'),
                ],
              ),
              actions: const Icon.lucide(Lucide.x, size: IconSize.sm),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(tester.takeException(), isNull);
      expect(find.byType(ItemTitle), findsOneWidget);
      expect(tester.getSize(find.byType(ItemTitle)).width, greaterThan(0));
    });
  });

  group(
    'QuestionnaireActions — footer row at 2x text scale in a narrow box',
    () {
      testWidgets('the actions survive instead of overflowing', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          narrowPhone(
            SizedBox(
              width: 200,
              child: Questionnaire(
                children: const <Widget>[
                  QuestionnaireItem(
                    name: 'demo',
                    title: QuestionnaireTitle('A question'),
                    children: <Widget>[
                      QuestionnaireChoices(
                        children: <QuestionnaireChoice>[
                          QuestionnaireChoice(value: 'a', label: 'Option A'),
                          QuestionnaireChoice(value: 'b', label: 'Option B'),
                        ],
                      ),
                    ],
                  ),
                  QuestionnaireActions(
                    children: <Widget>[
                      QuestionnairePrevious(),
                      QuestionnaireSkip(),
                      QuestionnaireNext(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
        await tester.pump();
        expect(tester.takeException(), isNull);
      });
    },
  );

  group('Menu row — height at 2x text scale in a narrow box', () {
    Widget menu() => MenuContent(
      children: const <MenuChild>[MenuItem(label: 'Open Wallet')],
      onClose: _nothing,
    );

    testWidgets('the row survives, and grows past the unscaled floor', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(narrowPhone(SizedBox(width: 200, child: menu())));
      await tester.pump();
      expect(tester.takeException(), isNull);

      // The row's own box — the `ConstrainedBox(minHeight:)` this fix put
      // under [_MenuRow] — read directly, rather than the surrounding
      // `MenuContent`'s size: that one can be stretched by its own ambient
      // constraints regardless of what any single row asks for, which would
      // let a regression to the unscaled floor hide behind it.
      final double rowHeight = tester
          .getSize(
            find
                .byWidgetPredicate(
                  (Widget w) =>
                      w is ConstrainedBox && w.constraints.minHeight > 0,
                )
                .first,
          )
          .height;

      expect(rowHeight, greaterThanOrEqualTo(Menu.itemHeightOf(_lastContext!)));
      expect(
        Menu.itemHeightOf(_lastContext!),
        greaterThan(Menu.itemHeight),
        reason: 'a regression to the unscaled constant would leave this flat',
      );
    });
  });

  group('Command row — height at 2x text scale in a narrow box', () {
    Widget command() => const Command(
      groups: <CommandGroup>[
        CommandGroup(items: <CommandItem>[CommandItem(label: 'Open Wallet')]),
      ],
    );

    testWidgets('the row survives, and grows past the unscaled floor', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        narrowPhone(SizedBox(width: 200, child: command())),
      );
      await tester.pump();
      expect(tester.takeException(), isNull);

      final double rowHeight = tester
          .getSize(
            find
                .byWidgetPredicate(
                  (Widget w) =>
                      w is ConstrainedBox && w.constraints.minHeight > 0,
                )
                .first,
          )
          .height;

      expect(
        rowHeight,
        greaterThanOrEqualTo(Command.itemHeightOf(_lastContext!)),
      );
      expect(
        Command.itemHeightOf(_lastContext!),
        greaterThan(Command.itemHeight),
        reason: 'a regression to the unscaled constant would leave this flat',
      );
    });
  });
}

/// Captured by [host]'s inner [Builder] — the last [BuildContext] reachable
/// from an actual pump, so [Menu.itemHeightOf] / [Command.itemHeightOf] can
/// be called with the real ambient [TextScaler] rather than a fabricated one.
BuildContext? _lastContext;

void _nothing() {}
void _nothingReject([String? reason]) {}
