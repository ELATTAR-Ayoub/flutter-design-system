/// Tests for `components_docs/slider/page.dart`'s [SliderDocPage]: the
/// slider component documentation page.
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never synthetic `MediaQuery`, per the
/// Phase J brief. The live `ElThemeController` is flipped in place for theme
/// coverage rather than re-pumped under a new controller.
///
/// Keyboard behaviour is driven directly against the real `Focus` nodes
/// `ElSlider` builds per thumb: the same technique `test/slider_test.dart`
/// (the package's own suite) uses, since there is no `WidgetsApp` traversal
/// to Tab through and the control answers `Focus.onKeyEvent` itself.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/slider/meta.dart';
import 'package:example/components_docs/slider/page.dart';
import 'package:example/docs/docs_code.dart';
import 'package:example/docs/docs_facts.dart';
import 'package:example/kit.dart' show ElSection;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const Size _wide = Size(1440, 900);
const Size _narrow = Size(390, 844);

/// The full shadcn-parity section list, in the order the reshaped page must
/// render them: mirrors https://ui.shadcn.com/docs/components/base/slider
/// (Installation, Usage, Range, Multiple Thumbs, Controlled, Disabled, API
/// Reference), with Vertical and RTL skipped (ElSlider exposes no
/// orientation parameter and no directionality-aware layout), Overview,
/// Status and Preview ahead of it per this docs system's own convention, our
/// Composition examples folded in beside the mirrored examples, and our six
/// required extra sections (States, Accessibility, Responsive, Dependencies,
/// Theming, Source) directly after API Reference.
const List<String> _sectionOrder = <String>[
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
  'responsive',
  'dependencies',
  'theming',
  'source',
];

/// Every public constructor parameter of `ElSlider`, enumerated by reading
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

/// The rest of the public surface: the two static geometry getters. `ElSlider`
/// exports no enum of its own: a range is just two entries in `values`, not a
/// second type.
const List<String> _sliderStatics = <String>[
  'ElSlider.trackHeight',
  'ElSlider.thumbSize',
];

Future<ElThemeController> _pump(
  WidgetTester tester, {
  Size size = _wide,
  ElThemeMode mode = ElThemeMode.dark,
  ValueChanged<String>? onNavigate,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final ElThemeController theme = ElThemeController(mode: mode);
  addTearDown(theme.dispose);

  await tester.pumpWidget(
    ElTheme(
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

/// The `Focus` nodes `ElSlider` builds: one per thumb, in order. Found by key
/// on the `ElSlider` itself so a page with several live specimens does not
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
    'slider docs page renders every shadcn-parity section, in order',
    (WidgetTester tester) async {
      await _pump(tester);

      double previousTop = -1;
      for (final String anchor in _sectionOrder) {
        final Finder section = find.byKey(ElSection.anchorKey(anchor));
        expect(section, findsOneWidget, reason: 'section "$anchor" missing');
        final double top = tester.getTopLeft(section).dy;
        expect(
          top,
          greaterThan(previousTop),
          reason: 'section "$anchor" should render after the previous section',
        );
        previousTop = top;
      }
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'the API table covers every ElSlider constructor parameter and both '
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
          reason: 'ElSlider constructor parameter "$param" is undocumented',
        );
      }
      for (final String member in _sliderStatics) {
        expect(
          documented,
          contains(member),
          reason: 'ElSlider static member "$member" is undocumented',
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
          .widget<ElSlider>(find.byKey(key))
          .values
          .single;

      await tester.drag(find.byKey(key), const Offset(80, 0));
      await tester.pump();

      final double after = tester
          .widget<ElSlider>(find.byKey(key))
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
          .widget<ElSlider>(find.byKey(key))
          .values;

      await _focusThumb(tester, key, 0);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pump();
      List<double> after = tester.widget<ElSlider>(find.byKey(key)).values;
      expect(after[0], greaterThan(initial[0]), reason: 'the low thumb moved');
      expect(after[1], initial[1], reason: 'the high thumb did not');

      await _focusThumb(tester, key, 1);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await tester.pump();
      after = tester.widget<ElSlider>(find.byKey(key)).values;
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
    final ElSlider widget = tester.widget<ElSlider>(find.byKey(key));

    await _focusThumb(tester, key, 0);
    await tester.sendKeyEvent(LogicalKeyboardKey.home);
    await tester.pump();
    expect(tester.widget<ElSlider>(find.byKey(key)).values.single, widget.min);

    await tester.sendKeyEvent(LogicalKeyboardKey.end);
    await tester.pump();
    expect(tester.widget<ElSlider>(find.byKey(key)).values.single, widget.max);
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
      final ElThemeController theme = await _pump(
        tester,
        mode: ElThemeMode.light,
      );
      expect(find.text(sliderDoc.title), findsWidgets);

      theme.setMode(ElThemeMode.dark);
      await tester.pump();
      expect(find.text(sliderDoc.title), findsWidgets);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('installation states that the component is installable', (
    WidgetTester tester,
  ) async {
    await _pump(tester);

    // This test used to assert the opposite, correctly: slider was not a
    // registry item, and holding the page to saying so was the right guard
    // against overclaiming. The registry now ships it, so the same guard
    // points the other way — the page must not tell a reader that a command
    // which works will not.
    expect(find.textContaining('not yet a registry item'), findsNothing);
    expect(find.textContaining('elattar add slider'), findsWidgets);
  });
}
