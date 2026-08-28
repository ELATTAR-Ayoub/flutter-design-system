/// Tests for `components_docs/slider/page.dart`'s [SliderDocPage]: the
/// slider component documentation page.
///
/// Re-housed onto the kit alongside the page: the section-order test now
/// reads `DocsSection.id` (the kit's own section widget), and the API-table
/// / state-matrix tests open the relevant `DocsDisclosure` first — closed by
/// default in the new kit.
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never synthetic `MediaQuery`. The live
/// `ThemeController` is flipped in place for theme coverage.
///
/// Keyboard behaviour is driven directly against the real `Focus` nodes
/// `Slider` builds per thumb: the same technique `test/slider_test.dart`
/// (the package's own suite) uses, since there is no `WidgetsApp` traversal
/// to Tab through and the control answers `Focus.onKeyEvent` itself.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/slider/meta.dart';
import 'package:example/components_docs/slider/page.dart';
import 'package:example/docs/docs_disclosure.dart';
import 'package:example/docs/docs_facts.dart';
import 'package:example/docs/docs_section.dart' show DocsSection;
import 'package:example/docs/docs_showcase.dart';
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
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const Size _wide = Size(1440, 900);
const Size _narrow = Size(390, 844);

/// The house-shape section order this page must render, top to bottom.
const List<String> _expectedSectionIds = <String>[
  'preview',
  'install',
  'usage',
  'variants',
  'range',
  'multiple-thumbs',
  'controlled',
  'disabled',
  'composition',
  'api',
  'states',
  'accessibility',
  'keyboard',
  'responsive',
  'dependencies',
  'theming',
  'source',
];

/// Every public constructor parameter of `Slider`, enumerated by reading
/// `lib/src/components/slider.dart` directly. The API table must cover all
/// of these by name.
const List<String> _sliderParams = <String>[
  'values',
  'onChanged',
  'min',
  'max',
  'step',
  'enabled',
  'label',
];

/// The rest of the public surface: the two static geometry getters. `Slider`
/// exports no enum of its own: a range is just two entries in `values`, not a
/// second type.
const List<String> _sliderStatics = <String>[
  'Slider.trackHeight',
  'Slider.thumbSize',
];

/// The single `DocsDisclosure` whose title is [title], matching
/// `checkbox_test.dart`'s own convention.
Finder _disclosureTrigger(String title) => find.descendant(
  of: find.byWidgetPredicate(
    (Widget widget) => widget is DocsDisclosure && widget.title == title,
  ),
  matching: find.byKey(DocsDisclosure.triggerKey),
);

Future<ThemeController> _pump(
  WidgetTester tester, {
  Size size = _wide,
  ColorMode mode = ColorMode.dark,
  ValueChanged<String>? onNavigate,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final ThemeController theme = ThemeController(mode: mode);
  addTearDown(theme.dispose);

  await tester.pumpWidget(
    ThemeScope(
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

/// The `Focus` nodes `Slider` builds: one per thumb, in order. Found by key
/// on the `Slider` itself so a page with several live specimens does not
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
  testWidgets('sections render in the house-shape order, top to bottom', (
    WidgetTester tester,
  ) async {
    await _pump(tester);

    final List<String> ids = tester
        .widgetList<DocsSection>(find.byType(DocsSection))
        .map((DocsSection section) => section.id)
        .toList();

    expect(ids, _expectedSectionIds);
  });

  testWidgets(
    'renders the article at wide and narrow widths with no exceptions',
    (WidgetTester tester) async {
      await _pump(tester, size: _wide);

      expect(find.text(sliderDoc.title), findsWidgets);
      expect(find.byType(DocsShowcase), findsAtLeastNWidgets(1));
      expect(
        find.byKey(const ValueKey<String>('docs-layout-sidebar')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);

      await _pump(tester, size: _narrow);
      await tester.pump();

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
    'the API table covers every Slider constructor parameter and both '
    'static members',
    (WidgetTester tester) async {
      await _pump(tester);

      final Finder apiTrigger = _disclosureTrigger('API Reference');
      await tester.ensureVisible(apiTrigger);
      await tester.tap(apiTrigger);
      await tester.pump();
      await tester.pump(MotionDurations.open);

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
          reason: 'Slider constructor parameter "$param" is undocumented',
        );
      }
      for (final String member in _sliderStatics) {
        expect(
          documented,
          contains(member),
          reason: 'Slider static member "$member" is undocumented',
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
          .widget<Slider>(find.byKey(key))
          .values
          .single;

      await tester.drag(find.byKey(key), const Offset(80, 0));
      await tester.pump();

      final double after = tester.widget<Slider>(find.byKey(key)).values.single;
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
          .widget<Slider>(find.byKey(key))
          .values;

      await _focusThumb(tester, key, 0);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pump();
      List<double> after = tester.widget<Slider>(find.byKey(key)).values;
      expect(after[0], greaterThan(initial[0]), reason: 'the low thumb moved');
      expect(after[1], initial[1], reason: 'the high thumb did not');

      await _focusThumb(tester, key, 1);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await tester.pump();
      after = tester.widget<Slider>(find.byKey(key)).values;
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
    final Slider widget = tester.widget<Slider>(find.byKey(key));

    await _focusThumb(tester, key, 0);
    await tester.sendKeyEvent(LogicalKeyboardKey.home);
    await tester.pump();
    expect(tester.widget<Slider>(find.byKey(key)).values.single, widget.min);

    await tester.sendKeyEvent(LogicalKeyboardKey.end);
    await tester.pump();
    expect(tester.widget<Slider>(find.byKey(key)).values.single, widget.max);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'the Range, Multiple thumbs, Controlled and Disabled specimens all '
    'mount their own live Slider',
    (WidgetTester tester) async {
      await _pump(tester);

      for (final String key in <String>[
        'slider-example:range',
        'slider-example:multiple-thumbs',
        'slider-example:controlled',
        'slider-example:disabled',
      ]) {
        final Finder finder = find.byKey(ValueKey<String>(key));
        await tester.ensureVisible(finder);
        expect(finder, findsOneWidget, reason: 'missing specimen "$key"');
      }
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('the state matrix documents rest, hover, active, focus-visible, '
      'disabled and reduced motion', (WidgetTester tester) async {
    await _pump(tester);

    final Finder statesTrigger = _disclosureTrigger('States');
    await tester.ensureVisible(statesTrigger);
    await tester.tap(statesTrigger);
    await tester.pump();
    await tester.pump(MotionDurations.open);

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
      final ThemeController theme = await _pump(tester, mode: ColorMode.light);
      expect(find.text(sliderDoc.title), findsWidgets);

      theme.setMode(ColorMode.dark);
      await tester.pump();
      expect(find.text(sliderDoc.title), findsWidgets);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('installation states that the component is installable', (
    WidgetTester tester,
  ) async {
    await _pump(tester);

    expect(find.textContaining('not yet a registry item'), findsNothing);
    expect(find.textContaining('elattar add slider'), findsWidgets);
  });
}
