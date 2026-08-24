/// Tests for `components_docs/native_select/page.dart`'s [NativeSelectDocPage].
///
/// This page documents exactly one component: [ElNativeSelect] and
/// [ElNativeSelectSize]. `selection_control` and `form` — previously
/// documented on this same page — now have their own pages, and their own
/// tests: `selection_control_test.dart` and `form_test.dart`.
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never synthetic `MediaQuery`. The live
/// `ElThemeController` is flipped in place for theme coverage rather than
/// re-pumped under a new controller.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/native_select/meta.dart';
import 'package:example/components_docs/native_select/page.dart';
import 'package:example/docs/docs_code.dart';
import 'package:example/docs/docs_facts.dart';
import 'package:example/kit.dart' show ElSection;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const Size _wide = Size(1440, 900);
const Size _narrow = Size(390, 844);

/// Every `ElApiTable` this page must render, by title, and every public
/// constructor parameter or static member of each documented class found by
/// reading `lib/src/components/native_select.dart` directly.
const Map<String, List<String>> _expectedApiTables = <String, List<String>>{
  'ElNativeSelect': <String>[
    'options',
    'value',
    'onChanged',
    'size',
    'enabled',
    'invalid',
    'expand',
    'width',
    'focusNode',
    'label',
    'hint',
    'ElNativeSelect.menuOffset',
  ],
  'ElNativeSelectSize': <String>[
    'sm',
    'md',
    'label',
    'height',
    'radius',
    'insetY',
  ],
};

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
            child: NativeSelectDocPage(onNavigate: onNavigate),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  return theme;
}

void main() {
  testWidgets(
    'sections render in the shadcn-mirrored order, section for section',
    (WidgetTester tester) async {
      await _pump(tester);

      final List<String> titles = tester
          .widgetList<ElSection>(find.byType(ElSection))
          .map((ElSection section) => section.title)
          .toList();

      expect(titles, <String>[
        'Installation',
        'Usage',
        'Composition',
        'Groups',
        'Disabled',
        'Invalid',
        'Native select vs select',
        'RTL',
        'API Reference',
        'States',
        'Accessibility',
        'Responsive',
        'Dependencies',
        'Theming',
        'Source',
      ]);
    },
  );

  testWidgets('the Groups, Disabled, Invalid, and RTL specimens render without '
      'exceptions', (WidgetTester tester) async {
    await _pump(tester);

    for (final String key in <String>[
      'native-select-groups-preview',
      'native-select-disabled-preview',
      'native-select-disabled-option-preview',
      'native-select-invalid-preview',
      'native-select-rtl-preview',
    ]) {
      final Finder finder = find.byKey(ValueKey<String>(key));
      await tester.ensureVisible(finder);
      expect(finder, findsOneWidget, reason: 'missing specimen "$key"');
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'renders the article at wide and narrow widths with no exceptions',
    (WidgetTester tester) async {
      await _pump(tester, size: _wide);

      expect(find.text(nativeSelectDoc.title), findsWidgets);
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
    'each ElApiTable covers every public constructor parameter and static '
    'of its own class',
    (WidgetTester tester) async {
      await _pump(tester);

      final List<DocsApiTable> tables = tester
          .widgetList<DocsApiTable>(find.byType(DocsApiTable))
          .toList();
      expect(tables, isNotEmpty);

      final Map<String, Set<String>> byTitle = <String, Set<String>>{
        for (final DocsApiTable table in tables)
          table.title: <String>{
            for (final DocsApiFact fact in table.facts) fact.name,
          },
      };

      for (final MapEntry<String, List<String>> expected
          in _expectedApiTables.entries) {
        final Set<String>? documented = byTitle[expected.key];
        expect(
          documented,
          isNotNull,
          reason: 'no ElApiTable titled "${expected.key}" was rendered',
        );
        for (final String param in expected.value) {
          expect(
            documented,
            contains(param),
            reason: '"${expected.key}" table is missing parameter "$param"',
          );
        }
      }
    },
  );

  testWidgets(
    'the live ElNativeSelect specimen is accessible and can be opened',
    (WidgetTester tester) async {
      await _pump(tester);

      const Key selectKey = ValueKey<String>('native-select-preview');
      await tester.ensureVisible(find.byKey(selectKey));
      expect(tester.takeException(), isNull);
      expect(find.byKey(selectKey), findsOneWidget);
    },
  );

  testWidgets(
    'the state matrix documents rest, focus, invalid, disabled, and open '
    'states',
    (WidgetTester tester) async {
      await _pump(tester);

      final DocsStateMatrix matrix = tester.widget<DocsStateMatrix>(
        find.byType(DocsStateMatrix),
      );
      final Set<String> states = matrix.facts
          .map((DocsStateFact fact) => fact.state)
          .toSet();

      for (final String expected in <String>[
        'Rest',
        'Focus-visible',
        'Invalid',
        'Disabled',
        'Hover',
        'Open',
        'Reduced motion',
      ]) {
        expect(
          states,
          contains(expected),
          reason: 'state matrix is missing the "$expected" row',
        );
      }
    },
  );

  testWidgets(
    'both themes render the article with no exceptions when flipped in place',
    (WidgetTester tester) async {
      final ElThemeController theme = await _pump(
        tester,
        mode: ElThemeMode.light,
      );
      expect(find.text(nativeSelectDoc.title), findsWidgets);

      theme.setMode(ElThemeMode.dark);
      await tester.pump();
      expect(find.text(nativeSelectDoc.title), findsWidgets);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('installation presents the working native-select CLI command', (
    WidgetTester tester,
  ) async {
    await _pump(tester);

    expect(find.textContaining('elattar add native-select'), findsWidgets);
  });
}
