/// Tests for `components_docs/slider/page.dart`'s [SliderDocPage] — the
/// slider component documentation page.
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never synthetic `MediaQuery`, per the
/// Phase J brief. The live `DsThemeController` is flipped in place for theme
/// coverage rather than re-pumped under a new controller.
///
/// Keyboard behaviour is driven directly against the real `Focus` nodes
/// `DsSlider` builds per thumb — the same technique `test/slider_test.dart`
/// (the package's own suite) uses, since there is no `WidgetsApp` traversal
/// to Tab through and the control answers `Focus.onKeyEvent` itself.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/slider/meta.dart';
import 'package:example/components_docs/slider/page.dart';
import 'package:example/docs/docs_code.dart';
import 'package:example/docs/docs_facts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const Size _wide = Size(1440, 900);
const Size _narrow = Size(390, 844);

/// Every public constructor parameter of `DsSlider`, enumerated by reading
/// `lib/src/components/slider.dart` directly (Step 1 of the task cycle). The
/// API table must cover all of these by name.
const List<String> _sliderParams = <String>[
  'values',
  'onChanged',
  'min',
  'max',
  'step',
  'enabled',
  'label',
];

/// The rest of the public surface: the two static geometry getters. `DsSlider`
/// exports no enum of its own — a range is just two entries in `values`, not a
/// second type.
const List<String> _sliderStatics = <String>[
  'DsSlider.trackHeight',
  'DsSlider.thumbSize',
];

Future<DsThemeController> _pump(
  WidgetTester tester, {
  Size size = _wide,
  DsThemeMode mode = DsThemeMode.dark,
  ValueChanged<String>? onNavigate,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final DsThemeController theme = DsThemeController(mode: mode);
  addTearDown(theme.dispose);

  await tester.pumpWidget(
    DsTheme(
      controller: theme,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: SingleChildScrollView(
            child: SliderDocPage(onNavigate: onNavigate),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  return theme;
}

/// The `Focus` nodes `DsSlider` builds — one per thumb, in order. Found by key
/// on the `DsSlider` itself so a page with several live specimens does not
/// mix nodes from one slider into another.
List<FocusNode> _thumbNodes(WidgetTester tester, Key sliderKey) => tester
    .widgetList<Focus>(
      find.descendant(of: find.byKey(sliderKey), matching: find.byType(Focus)),
    )
    .map((Focus focus) => focus.focusNode!)
    .toList();

Future<void> _focusThumb(WidgetTester tester, Key sliderKey, int index) async {
  _thumbNodes(tester, sliderKey)[index].requestFocus();
  await tester.pump();
  await tester.pump();
}

void main() {
  testWidgets(
    'renders the article at wide and narrow widths with no exceptions',
    (WidgetTester tester) async {
      await _pump(tester, size: _wide);

      expect(find.text(sliderDoc.title), findsWidgets);
      expect(find.byType(DocsCodeExample), findsAtLeastNWidgets(1));
      expect(
        find.byKey(const ValueKey<String>('docs-layout-sidebar')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);

      await _pump(tester, size: _narrow);
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey<String>('docs-layout-anchor-strip')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('docs-layout-sidebar')),
        findsNothing,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'the API table covers every DsSlider constructor parameter and both '
    'static members',
    (WidgetTester tester) async {
      await _pump(tester);

      final List<DocsApiTable> tables = tester
          .widgetList<DocsApiTable>(find.byType(DocsApiTable))
          .toList();
      expect(tables, isNotEmpty);

      final Set<String> documented = <String>{
        for (final DocsApiTable table in tables)
          for (final DocsApiFact fact in table.facts) fact.name,
      };

      for (final String param in _sliderParams) {
        expect(
          documented,
          contains(param),
          reason: 'DsSlider constructor parameter "$param" is undocumented',
        );
      }
      for (final String member in _sliderStatics) {
        expect(
          documented,
          contains(member),
          reason: 'DsSlider static member "$member" is undocumented',
        );
      }
    },
  );

  testWidgets(
    'a live single-value specimen mounts and dragging changes the value',
    (WidgetTester tester) async {
      await _pump(tester);

      const Key key = ValueKey<String>('slider-live-specimen');
      expect(find.byKey(key), findsOneWidget);
      await tester.ensureVisible(find.byKey(key));

      final double before = tester
          .widget<DsSlider>(find.byKey(key))
          .values
          .single;

      await tester.drag(find.byKey(key), const Offset(80, 0));
      await tester.pump();

      final double after = tester
          .widget<DsSlider>(find.byKey(key))
          .values
          .single;
      expect(
        after,
        greaterThan(before),
        reason: 'dragging the single thumb to the right must raise its value',
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'a live range specimen mounts with two independently focusable thumbs, '
    'and arrow keys step whichever one is focused',
    (WidgetTester tester) async {
      await _pump(tester);

      const Key key = ValueKey<String>('slider-live-range-specimen');
      expect(find.byKey(key), findsOneWidget);
      await tester.ensureVisible(find.byKey(key));
      expect(_thumbNodes(tester, key), hasLength(2));

      final List<double> initial = tester
          .widget<DsSlider>(find.byKey(key))
          .values;

      await _focusThumb(tester, key, 0);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pump();
      List<double> after = tester.widget<DsSlider>(find.byKey(key)).values;
      expect(after[0], greaterThan(initial[0]), reason: 'the low thumb moved');
      expect(after[1], initial[1], reason: 'the high thumb did not');

      await _focusThumb(tester, key, 1);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await tester.pump();
      after = tester.widget<DsSlider>(find.byKey(key)).values;
      expect(after[1], lessThan(initial[1]), reason: 'the high thumb moved');
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Home and End jump the focused thumb to the slider bounds', (
    WidgetTester tester,
  ) async {
    await _pump(tester);

    const Key key = ValueKey<String>('slider-live-specimen');
    await tester.ensureVisible(find.byKey(key));
    final DsSlider widget = tester.widget<DsSlider>(find.byKey(key));

    await _focusThumb(tester, key, 0);
    await tester.sendKeyEvent(LogicalKeyboardKey.home);
    await tester.pump();
    expect(tester.widget<DsSlider>(find.byKey(key)).values.single, widget.min);

    await tester.sendKeyEvent(LogicalKeyboardKey.end);
    await tester.pump();
    expect(tester.widget<DsSlider>(find.byKey(key)).values.single, widget.max);
    expect(tester.takeException(), isNull);
  });

  testWidgets('the state matrix documents rest, hover, active, focus-visible, '
      'disabled and reduced motion', (WidgetTester tester) async {
    await _pump(tester);

    final DocsStateMatrix matrix = tester.widget<DocsStateMatrix>(
      find.byType(DocsStateMatrix),
    );
    final Set<String> states = matrix.facts
        .map((DocsStateFact fact) => fact.state)
        .toSet();

    for (final String expected in <String>[
      'Rest',
      'Hover',
      'Active (pressed / dragging)',
      'Focus-visible',
      'Disabled',
      'Reduced motion',
    ]) {
      expect(
        states,
        contains(expected),
        reason: 'state matrix is missing the "$expected" row',
      );
    }
  });

  testWidgets(
    'both themes render the article with no exceptions when flipped in place',
    (WidgetTester tester) async {
      final DsThemeController theme = await _pump(
        tester,
        mode: DsThemeMode.light,
      );
      expect(find.text(sliderDoc.title), findsWidgets);

      theme.setMode(DsThemeMode.dark);
      await tester.pump();
      expect(find.text(sliderDoc.title), findsWidgets);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('installation is honestly disclosed as not yet CLI-installable', (
    WidgetTester tester,
  ) async {
    await _pump(tester);

    // The honest disclosure is intentionally repeated (Status and
    // Installation each state it in their own words), so this asserts
    // presence, not a specific count.
    expect(find.textContaining('not yet a registry item'), findsWidgets);
  });
}
