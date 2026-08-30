/// Behavioural cover for the three stress-test pages.
///
/// Each test asserts one claim the UI director's completeness gate makes, so a
/// regression shows up as a named failure rather than a screenshot someone has
/// to squint at.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/stress/invoices_page.dart';
import 'package:example/stress/stress_app.dart';
import 'package:example/stress/stress_repository.dart';
import 'package:flutter/material.dart'
    hide
        AspectRatio,
        Form,
        FormField,
        Icon,
        OverlayPortal,
        RichText,
        SafeArea,
        ScrollPosition,
        Table,
        TableColumnWidth,
        AlertDialog,
        Badge,
        Card,
        Checkbox,
        Dialog,
        DropdownMenu,
        Drawer,
        Slider,
        Switch,
        TextFormField,
        Tooltip;
import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter_test/flutter_test.dart';

const Size _desktop = Size(1440, 900);
const Size _phone = Size(390, 844);

Future<void> _resize(WidgetTester tester, Size size) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.reset);
}

/// [WidgetTester.pumpAndSettle] cannot be used on these pages: `Skeleton` and
/// `Spinner` animate perpetually and do not honour
/// `MediaQuery.disableAnimations`, so the tree never reaches a quiet frame.
/// Pumping a fixed number of motion beats advances the fake clock past every
/// scripted delay and every overlay transition without waiting for a settle
/// that will not come.
Future<void> _settle(WidgetTester tester, {int frames = 6}) async {
  for (int i = 0; i < frames; i++) {
    await tester.pump(MotionDurations.slow);
  }
}

Finder _buttonLabelled(String label) => find.byWidgetPredicate(
  (Widget widget) => widget is Button && widget.label == label,
);

/// The [Button] whose visible label is [text].
Finder _textButton(String text) => find
    .ancestor(
      of: find.byWidgetPredicate(
        (Widget widget) => widget is StyledText && widget.text == text,
      ),
      matching: find.byType(Button),
    )
    .first;

/// The composer submits on Enter without Shift, through its focus node.
Future<void> _submitComposer(WidgetTester tester, String text) async {
  await tester.enterText(find.byType(EditableText).last, text);
  await tester.pump();
  await tester.sendKeyEvent(LogicalKeyboardKey.enter);
  await tester.pump();
}

void main() {
  group('Invoices', () {
    testWidgets('first load shows skeletons, then the rows', (
      WidgetTester tester,
    ) async {
      await _resize(tester, _desktop);
      await tester.pumpWidget(const StressApp());
      await tester.pump();

      expect(find.byType(Skeleton), findsWidgets);
      expect(find.text('INV-1042'), findsNothing);

      await _settle(tester);

      expect(find.text('INV-1042'), findsOneWidget);
      expect(find.byType(Skeleton), findsNothing);
    });

    testWidgets('the summary survives a list failure', (
      WidgetTester tester,
    ) async {
      await _resize(tester, _desktop);
      final StressRepository repository = StressRepository()
        ..listOutcome = Outcome.server;
      await tester.pumpWidget(StressApp(repository: repository));
      await _settle(tester);

      // The list failed in human words.
      expect(find.text('Something went wrong on our side'), findsOneWidget);
      // The summary rendered anyway.
      expect(find.text(r'$1,248.00'), findsOneWidget);
      // And nothing leaked the backend.
      expect(find.textContaining('NullPointerException'), findsNothing);
      expect(find.textContaining('500'), findsNothing);
    });

    testWidgets('the list survives a summary failure', (
      WidgetTester tester,
    ) async {
      await _resize(tester, _desktop);
      final StressRepository repository = StressRepository()
        ..summaryOutcome = Outcome.offline;
      await tester.pumpWidget(StressApp(repository: repository));
      await _settle(tester);

      expect(find.text('You are offline'), findsOneWidget);
      expect(find.text('INV-1042'), findsOneWidget);
    });

    testWidgets('diagnostics stay collapsed until asked for', (
      WidgetTester tester,
    ) async {
      await _resize(tester, _desktop);
      final StressRepository repository = StressRepository()
        ..listOutcome = Outcome.server;
      await tester.pumpWidget(StressApp(repository: repository));
      await _settle(tester);

      expect(find.textContaining('BillingResolver.kt'), findsNothing);

      await tester.tap(_textButton('Technical details'));
      await _settle(tester);

      expect(find.textContaining('BillingResolver.kt'), findsOneWidget);
      expect(find.textContaining('req_8f21ac'), findsOneWidget);
    });

    testWidgets('an empty account and a filtered list read differently', (
      WidgetTester tester,
    ) async {
      await _resize(tester, _desktop);
      final StressRepository repository = StressRepository()
        ..listOutcome = Outcome.empty;
      await tester.pumpWidget(StressApp(repository: repository));
      await _settle(tester);

      expect(find.text('No invoices yet'), findsOneWidget);
      expect(find.text('No invoices match this filter'), findsNothing);
    });

    testWidgets('paying shows a busy state and cannot be submitted twice', (
      WidgetTester tester,
    ) async {
      await _resize(tester, _desktop);
      await tester.pumpWidget(const StressApp());
      await _settle(tester);

      final Finder pay = _textButton('Pay now');
      expect(pay, findsOneWidget);

      await tester.tap(pay);
      await tester.pump();

      final Button busy = tester.widget<Button>(_textButton('Pay now'));
      expect(busy.loading, isTrue, reason: 'the control owns the busy state');
      expect(busy.onPressed, isNull, reason: 'a second press cannot fire');

      await _settle(tester);
    });

    testWidgets('a declined card reads as a decision, not a stack trace', (
      WidgetTester tester,
    ) async {
      await _resize(tester, _phone);
      final StressRepository repository = StressRepository()
        ..payOutcome = Outcome.declined;
      await tester.pumpWidget(StressApp(repository: repository));
      await _settle(tester);

      await tester.tap(_textButton('Pay now'));
      await _settle(tester);

      expect(find.text('Your card was declined'), findsOneWidget);
      expect(
        find.text('Your bank did not approve this payment. Nothing was charged.'),
        findsOneWidget,
      );
      expect(find.text('Use a different card'), findsOneWidget);
      expect(find.textContaining('card_declined'), findsNothing);
      expect(find.textContaining('402'), findsNothing);
    });

    testWidgets('narrow puts the filter behind one control', (
      WidgetTester tester,
    ) async {
      await _resize(tester, _phone);
      await tester.pumpWidget(const StressApp());
      await _settle(tester);

      expect(_buttonLabelled('Filter invoices'), findsOneWidget);
      expect(find.byType(Select<InvoiceFilter>), findsNothing);
    });

    testWidgets('wide puts the filter inline', (WidgetTester tester) async {
      await _resize(tester, _desktop);
      await tester.pumpWidget(const StressApp());
      await _settle(tester);

      expect(find.byType(Select<InvoiceFilter>), findsOneWidget);
      expect(_buttonLabelled('Filter invoices'), findsNothing);
    });
  });

  group('Team', () {
    testWidgets('pending invites are their own condition', (
      WidgetTester tester,
    ) async {
      await _resize(tester, _desktop);
      await tester.pumpWidget(
        const StressApp(initialPage: StressPage.team),
      );
      await _settle(tester);

      expect(find.text('1 invite is still pending'), findsOneWidget);
      expect(find.text('You are the only person here'), findsNothing);
    });

    testWidgets('an empty team is not the same as a filtered one', (
      WidgetTester tester,
    ) async {
      await _resize(tester, _desktop);
      final StressRepository repository = StressRepository()
        ..membersOutcome = Outcome.empty;
      await tester.pumpWidget(
        StressApp(initialPage: StressPage.team, repository: repository),
      );
      await _settle(tester);

      expect(find.text('You are the only person here'), findsOneWidget);
      expect(find.text('Nobody matches this filter'), findsNothing);
    });

    testWidgets('the invite dialog validates onto the field', (
      WidgetTester tester,
    ) async {
      await _resize(tester, _desktop);
      await tester.pumpWidget(
        const StressApp(initialPage: StressPage.team),
      );
      await _settle(tester);

      await tester.tap(_textButton('Invite member'));
      await _settle(tester);

      expect(find.text('Work email'), findsOneWidget);

      await tester.enterText(find.byType(Input), 'not-an-email');
      await tester.tap(_textButton('Send invitation'));
      await _settle(tester);

      // The message is on the field, not in a toast that disappears.
      expect(
        find.text('Enter a work email address, like name@company.com'),
        findsOneWidget,
      );
    });

    testWidgets('closing the invite dialog returns focus to its trigger', (
      WidgetTester tester,
    ) async {
      await _resize(tester, _desktop);
      await tester.pumpWidget(
        const StressApp(initialPage: StressPage.team),
      );
      await _settle(tester);

      await tester.tap(_textButton('Invite member'));
      await _settle(tester);
      await tester.tap(_textButton('Cancel'));
      await _settle(tester);

      final Button trigger = tester.widget<Button>(
        _textButton('Invite member'),
      );
      expect(
        trigger.focusNode?.hasFocus,
        isTrue,
        reason: 'focus does not get stranded on the page root',
      );
    });

    testWidgets('removing a member names the person and the consequence', (
      WidgetTester tester,
    ) async {
      await _resize(tester, _desktop);
      await tester.pumpWidget(
        const StressApp(initialPage: StressPage.team),
      );
      await _settle(tester);

      await tester.tap(_buttonLabelled('Remove Tobias Lindqvist'));
      await _settle(tester);

      expect(find.text('Remove Tobias Lindqvist?'), findsOneWidget);
      expect(
        find.textContaining('lose access to this workspace immediately'),
        findsOneWidget,
      );
      // The verb, not "OK".
      expect(find.text('Remove member'), findsOneWidget);
    });

    testWidgets('the owner cannot be removed from the row', (
      WidgetTester tester,
    ) async {
      await _resize(tester, _desktop);
      await tester.pumpWidget(
        const StressApp(initialPage: StressPage.team),
      );
      await _settle(tester);

      final Button remove = tester.widget<Button>(
        _buttonLabelled('Remove Amina Rahmouni'),
      );
      expect(remove.onPressed, isNull);
    });
  });

  group('Agent console', () {
    testWidgets('an empty conversation says what to do next', (
      WidgetTester tester,
    ) async {
      await _resize(tester, _desktop);
      await tester.pumpWidget(
        const StressApp(initialPage: StressPage.console),
      );
      await _settle(tester);

      expect(find.text('Nothing has run yet'), findsOneWidget);
      // Once in the header badge, once in the run detail panel.
      expect(find.text('Ready'), findsNWidgets(2));
    });

    testWidgets('stopping keeps everything that already arrived', (
      WidgetTester tester,
    ) async {
      await _resize(tester, _desktop);
      await tester.pumpWidget(
        const StressApp(initialPage: StressPage.console),
      );
      await _settle(tester);

      await _submitComposer(tester, 'reconcile');
      await tester.pump(MotionDurations.slow);
      await tester.pump(MotionDurations.slow);

      expect(find.text('Running'), findsWidgets);
      expect(find.text('reconcile'), findsOneWidget);

      final Finder stop = find.byType(AgentComposer);
      expect(
        tester.widget<AgentComposer>(stop).onStop,
        isNotNull,
        reason: 'Stop exists while there is something to stop',
      );
    });

    testWidgets('a mid-stream failure keeps the partial answer', (
      WidgetTester tester,
    ) async {
      await _resize(tester, _desktop);
      await tester.pumpWidget(
        const StressApp(
          initialPage: StressPage.console,
          failMidStream: true,
        ),
      );
      await _settle(tester);

      await _submitComposer(tester, 'reconcile');
      for (int i = 0; i < 5; i++) {
        await tester.pump(MotionDurations.slow);
      }
      await _settle(tester);

      expect(find.text('Something went wrong on our side'), findsOneWidget);
      expect(find.text('Try again, or contact support'), findsOneWidget);
      // The partial output is still on screen.
      expect(find.textContaining('Reading the billing schema'), findsOneWidget);
      // And the backend is not.
      expect(find.textContaining('RunStream.kt'), findsNothing);
    });

    testWidgets('narrow keeps run detail one control away', (
      WidgetTester tester,
    ) async {
      await _resize(tester, _phone);
      await tester.pumpWidget(
        const StressApp(initialPage: StressPage.console),
      );
      await _settle(tester);

      expect(_buttonLabelled('Show run details'), findsOneWidget);
      expect(find.text('This run'), findsNothing);
    });

    testWidgets('wide keeps run detail on screen', (
      WidgetTester tester,
    ) async {
      await _resize(tester, _desktop);
      await tester.pumpWidget(
        const StressApp(initialPage: StressPage.console),
      );
      await _settle(tester);

      expect(find.text('This run'), findsOneWidget);
      expect(_buttonLabelled('Show run details'), findsNothing);
    });
  });
}
