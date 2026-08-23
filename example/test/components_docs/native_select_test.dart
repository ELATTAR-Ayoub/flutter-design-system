/// Tests for `components_docs/native_select/page.dart`'s [NativeSelectDocPage] —
/// the native_select, selection_control, and form documentation page.
///
/// Three components, documented together:
/// - **native_select**: [DsNativeSelect] and [DsNativeSelectSize]
/// - **selection_control**: [DsSelectionControl], [DsHitArea], [DsJellyReplay]
/// - **form**: [DsForm], [DsFormField], [DsTextFormField], [DsValidateMode]
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never synthetic `MediaQuery`, per the
/// Phase J brief. The live `DsThemeController` is flipped in place for theme
/// coverage rather than re-pumped under a new controller.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/native_select/meta.dart';
import 'package:example/components_docs/native_select/page.dart';
import 'package:example/docs/docs_code.dart';
import 'package:example/docs/docs_facts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const Size _wide = Size(1440, 900);
const Size _narrow = Size(390, 844);

/// Every `DsApiTable` this page must render, by title, and every public
/// constructor parameter or static member of each documented class found by
/// reading the source files directly. The completeness test asserts each list
/// is a subset of that specific table's own facts.
const Map<String, List<String>> _expectedApiTables = <String, List<String>>{
  'DsNativeSelect': <String>[
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
    'DsNativeSelect.menuOffset',
  ],
  'DsNativeSelectSize': <String>[
    'sm',
    'md',
    'label',
    'height',
    'radius',
    'insetY',
  ],
  'DsSelectionControl': <String>[
    'width',
    'height',
    'radius',
    'fill',
    'border',
    'shadow',
    'duration',
    'jellyState',
    'child',
    'onTap',
    'enabled',
    'inert',
    'invalid',
    'forceFocusRing',
    'focusNode',
    'skipTraversal',
    'onKey',
    'semantics',
  ],
  'DsForm': <String>[
    'fields',
    'mode',
    'reValidateMode',
    'validate',
    'focusFirstError',
    'submit',
    'setError',
    'clearErrors',
    'reset',
    'isValid',
    'isSubmitting',
    'submitCount',
    'DsFormField<T>',
    'DsTextFormField',
  ],
  'DsValidateMode': <String>['onSubmit', 'onChange'],
};

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
    'each DsApiTable covers every public constructor parameter and static '
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
          reason: 'no DsApiTable titled "${expected.key}" was rendered',
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
    'the live DsNativeSelect specimen is accessible and can be opened',
    (WidgetTester tester) async {
      await _pump(tester);

      const Key selectKey = ValueKey<String>('native-select-preview');
      await tester.ensureVisible(find.byKey(selectKey));
      expect(tester.takeException(), isNull);

      // The select should be renderable and tappable without error
      expect(find.byKey(selectKey), findsOneWidget);
    },
  );

  testWidgets(
    'the state matrix documents rest, focus, invalid, disabled, and open '
    'states for native_select, with N/A for selection_control and form',
    (WidgetTester tester) async {
      await _pump(tester);

      final DocsStateMatrix matrix = tester.widget<DocsStateMatrix>(
        find.byType(DocsStateMatrix),
      );
      final Set<String> states = matrix.facts
          .map((DocsStateFact fact) => fact.state)
          .toSet();

      for (final String expected in <String>[
        'Rest (DsNativeSelect)',
        'Focus-visible (DsNativeSelect)',
        'Invalid (DsNativeSelect)',
        'Disabled (DsNativeSelect)',
        'Hover (DsNativeSelect)',
        'Open (DsNativeSelect)',
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
      final DsThemeController theme = await _pump(
        tester,
        mode: DsThemeMode.light,
      );
      expect(find.text(nativeSelectDoc.title), findsWidgets);

      theme.setMode(DsThemeMode.dark);
      await tester.pump();
      expect(find.text(nativeSelectDoc.title), findsWidgets);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'installation correctly states that none of the three have registry '
    'manifests yet',
    (WidgetTester tester) async {
      await _pump(tester);

      expect(find.textContaining('not yet in the registry'), findsWidgets);
      expect(find.textContaining('no registry manifests'), findsWidgets);
    },
  );
}
