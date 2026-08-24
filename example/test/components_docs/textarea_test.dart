/// Tests for `components_docs/textarea/page.dart`'s [TextareaDocPage] —
/// the textarea component documentation page.
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never synthetic `MediaQuery`, per the
/// Phase J brief. The live `ElThemeController` is flipped in place for theme
/// coverage rather than re-pumped under a new controller.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/textarea/meta.dart';
import 'package:example/components_docs/textarea/page.dart';
import 'package:example/docs/docs_code.dart';
import 'package:example/docs/docs_facts.dart';
import 'package:example/kit.dart' show ElSection;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const Size _wide = Size(1440, 900);
const Size _narrow = Size(390, 844);

/// Every public constructor parameter of `ElTextarea`, enumerated by reading
/// `lib/src/components/textarea.dart` directly (Step 1 of the task cycle).
/// The API table must cover all of these by name.
const List<String> _textareaParams = <String>[
  'controller',
  'initialValue',
  'focusNode',
  'placeholder',
  'onChanged',
  'enabled',
  'readOnly',
  'invalid',
  'label',
  'hint',
];

/// The rest of the public surface: the two static geometry getters.
const List<String> _textareaStatics = <String>[
  'ElTextarea.minHeight',
  'ElTextarea.insets',
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
            child: TextareaDocPage(onNavigate: onNavigate),
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

      expect(find.text(textareaDoc.title), findsWidgets);
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
        'Textarea vs. input',
        'Field',
        'Disabled',
        'Invalid',
        'Button',
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

  testWidgets(
    'the API table covers every ElTextarea constructor parameter and both '
    'static geometry getters',
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

      for (final String param in _textareaParams) {
        expect(
          documented,
          contains(param),
          reason: 'ElTextarea constructor parameter "$param" is undocumented',
        );
      }
      for (final String member in _textareaStatics) {
        expect(
          documented,
          contains(member),
          reason: 'ElTextarea static member "$member" is undocumented',
        );
      }
    },
  );

  testWidgets('a live textarea specimen mounts and accepts typed text', (
    WidgetTester tester,
  ) async {
    await _pump(tester);

    const Key key = ValueKey<String>('textarea-live-specimen');
    expect(find.byKey(key), findsOneWidget);
    await tester.ensureVisible(find.byKey(key));

    final Finder editable = find.descendant(
      of: find.byKey(key),
      matching: find.byType(EditableText),
    );
    expect(editable, findsOneWidget);
    expect(tester.widget<EditableText>(editable).controller.text, isEmpty);

    await tester.enterText(editable, 'Line one\nLine two');
    await tester.pump();

    expect(
      tester.widget<EditableText>(editable).controller.text,
      'Line one\nLine two',
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'the state matrix documents rest, focus-visible, error, read-only, '
    'disabled and reduced motion',
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
        'Error',
        'Read-only',
        'Disabled',
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
    'both themes render the article with no exceptions when flipped in '
    'place, at both wide and narrow widths',
    (WidgetTester tester) async {
      ElThemeController theme = await _pump(
        tester,
        size: _wide,
        mode: ElThemeMode.light,
      );
      expect(find.text(textareaDoc.title), findsWidgets);

      theme.setMode(ElThemeMode.dark);
      await tester.pump();
      expect(find.text(textareaDoc.title), findsWidgets);
      expect(tester.takeException(), isNull);

      theme = await _pump(tester, size: _narrow, mode: ElThemeMode.light);
      await tester.pumpAndSettle();
      expect(find.text(textareaDoc.title), findsWidgets);

      theme.setMode(ElThemeMode.dark);
      await tester.pump();
      expect(find.text(textareaDoc.title), findsWidgets);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('installation states that the component is installable', (
    WidgetTester tester,
  ) async {
    await _pump(tester);

    // This test used to assert the opposite, correctly: textarea was not a
    // registry item, and holding the page to saying so was the right guard
    // against overclaiming. The registry now ships it, so the same guard
    // points the other way — the page must not tell a reader that a command
    // which works will not.
    expect(find.textContaining('not yet a registry item'), findsNothing);
    expect(find.textContaining('elattar add textarea'), findsWidgets);
  });
}
