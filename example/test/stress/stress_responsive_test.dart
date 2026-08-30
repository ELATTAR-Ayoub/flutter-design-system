/// The two verification widths, both themes, and 200 percent text.
///
/// A `RenderFlex` overflow raises a `FlutterError` that fails the test on its
/// own, so pumping each page in each configuration is the assertion: nothing
/// here is a screenshot someone has to interpret.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
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
import 'package:flutter_test/flutter_test.dart';

const Size _desktop = Size(1440, 900);
const Size _phone = Size(390, 844);

/// The iOS home indicator and status bar, so `SafeArea` has something real to
/// spend and a double spend would show as an overflow.
const EdgeInsets _phoneInsets = EdgeInsets.only(top: 47, bottom: 34);

Future<void> _settle(WidgetTester tester, {int frames = 6}) async {
  for (int i = 0; i < frames; i++) {
    await tester.pump(MotionDurations.slow);
  }
}

Future<void> _pump(
  WidgetTester tester, {
  required Size size,
  required StressPage page,
  ColorMode mode = ColorMode.dark,
  double textScale = 1,
  EdgeInsets padding = EdgeInsets.zero,
  StressRepository? repository,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  tester.view.padding = FakeViewPadding(
    top: padding.top,
    bottom: padding.bottom,
  );
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

  await tester.pumpWidget(
    StressApp(
      initialPage: page,
      repository: repository,
      initialMode: mode,
    ),
  );
  await _settle(tester);
}

void main() {
  for (final ColorMode mode in <ColorMode>[ColorMode.light, ColorMode.dark]) {
    final String theme = mode.name;

    for (final StressPage page in StressPage.values) {
      testWidgets('$theme / ${page.name} lays out at 1440x900', (
        WidgetTester tester,
      ) async {
        await _pump(tester, size: _desktop, page: page, mode: mode);
        expect(tester.takeException(), isNull);
      });

      testWidgets('$theme / ${page.name} lays out at 390x844 with insets', (
        WidgetTester tester,
      ) async {
        await _pump(
          tester,
          size: _phone,
          page: page,
          mode: mode,
          padding: _phoneInsets,
        );
        expect(tester.takeException(), isNull);
      });

      testWidgets('$theme / ${page.name} survives 200 percent text on a phone', (
        WidgetTester tester,
      ) async {
        await _pump(
          tester,
          size: _phone,
          page: page,
          mode: mode,
          padding: _phoneInsets,
          textScale: 2,
        );
        expect(tester.takeException(), isNull);
      });

      testWidgets('$theme / ${page.name} survives 200 percent text on desktop', (
        WidgetTester tester,
      ) async {
        await _pump(
          tester,
          size: _desktop,
          page: page,
          mode: mode,
          textScale: 2,
        );
        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets('failure states lay out on a phone in both themes', (
    WidgetTester tester,
  ) async {
    for (final ColorMode mode in <ColorMode>[ColorMode.light, ColorMode.dark]) {
      final StressRepository repository = StressRepository()
        ..summaryOutcome = Outcome.offline
        ..listOutcome = Outcome.server;
      await _pump(
        tester,
        size: _phone,
        page: StressPage.invoices,
        mode: mode,
        padding: _phoneInsets,
        repository: repository,
      );
      expect(find.text('You are offline'), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('empty states lay out at 200 percent text on a phone', (
    WidgetTester tester,
  ) async {
    final StressRepository repository = StressRepository()
      ..listOutcome = Outcome.empty
      ..membersOutcome = Outcome.empty;
    await _pump(
      tester,
      size: _phone,
      page: StressPage.invoices,
      padding: _phoneInsets,
      textScale: 2,
      repository: repository,
    );
    expect(find.text('No invoices yet'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('reduced motion renders every page', (WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = _phone;
    addTearDown(tester.view.reset);

    for (final StressPage page in StressPage.values) {
      await tester.pumpWidget(
        StressApp(initialPage: page, reduceMotion: true),
      );
      await _settle(tester);
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('every icon only control carries a label', (
    WidgetTester tester,
  ) async {
    for (final StressPage page in StressPage.values) {
      await _pump(tester, size: _desktop, page: page);

      final Iterable<Button> buttons = tester.widgetList<Button>(
        find.byType(Button),
      );
      for (final Button button in buttons) {
        final bool hasVisibleText = _carriesText(button.child);
        expect(
          hasVisibleText || (button.label?.isNotEmpty ?? false),
          isTrue,
          reason:
              'an icon only Button on ${page.name} has no label for assistive '
              'technology',
        );
      }
    }
  });
}

/// Whether a control shows words, in which case it is not icon only.
bool _carriesText(Widget widget) {
  if (widget is StyledText) return widget.text.isNotEmpty;
  if (widget is Text) return (widget.data ?? '').isNotEmpty;
  if (widget is Row) return widget.children.any(_carriesText);
  if (widget is Column) return widget.children.any(_carriesText);
  if (widget is Padding) return _carriesText(widget.child!);
  return false;
}
