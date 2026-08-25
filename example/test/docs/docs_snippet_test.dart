// example/test/docs/docs_snippet_test.dart
/// The one code renderer.
///
/// DEVIATION from the task-2 brief, ruled by the repository owner: the brief
/// had `DocsSnippet` render through `ElAgentCodeBlock`. That widget's
/// `normalise` looks the language up in `elLanguageAliases`
/// (`lib/src/components/agent_markdown.dart`), which registers bash, css,
/// js/javascript, json, jsx, md/markdown, py/python, sh/shell, sql, ts/tsx/
/// typescript — and no `dart`. Since `dart` is the default language and
/// nearly all documentation code, routing through `ElAgentCodeBlock` would
/// render every Dart snippet flat and unhighlighted. Instead `DocsSnippet`
/// paints its own body through `ElPrismPalette` — the same VS Code Dark Plus
/// palette `ElAgentCodeBlock` uses — so the site still carries exactly one
/// syntax theme.
///
/// This is why the brief's first test ("it renders through the agent code
/// block, not a second theme", pinning `find.byType(ElAgentCodeBlock)`) is
/// replaced by the two tests below: one that pins the real contract — a Dart
/// snippet is actually tokenised and coloured through the Prism palette — and
/// one that pins the header strip's language label and its uppercase-free
/// type role. Brief tests 2, 3 and 4 stand as written.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/docs/docs_copy_button.dart';
import 'package:example/docs/docs_snippet.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) => MediaQuery(
  data: const MediaQueryData(size: Size(1440, 900)),
  child: Directionality(
    textDirection: TextDirection.ltr,
    child: ElTheme(
      controller: ElThemeController(mode: ElThemeMode.dark),
      child: Center(child: child),
    ),
  ),
);

const String _long =
    'void main() {\n'
    '  final int a = 1;\n'
    '  final int b = 2;\n'
    '  final int c = 3;\n'
    '  final int d = 4;\n'
    '  final int e = 5;\n'
    '  final int f = 6;\n'
    '  final int g = 7;\n'
    '  final int h = 8;\n'
    '}';

/// True if [span]'s subtree contains a leaf [TextSpan] with exactly [text]
/// painted in exactly [color].
bool _hasColoredSpan(InlineSpan span, String text, Color color) {
  bool found = false;
  span.visitChildren((InlineSpan child) {
    if (child is TextSpan && child.text == text && child.style?.color == color) {
      found = true;
    }
    return true;
  });
  return found;
}

void main() {
  testWidgets(
    'a Dart snippet is actually highlighted, through the Prism palette',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        _host(
          const SizedBox(
            width: 640,
            child: DocsSnippet(code: 'final int a = 1;'),
          ),
        ),
      );
      await tester.pump();

      final Iterable<Text> richTexts = tester
          .widgetList<Text>(find.byType(Text))
          .where((Text t) => t.textSpan != null);

      final bool hasKeyword = richTexts.any(
        (Text t) =>
            _hasColoredSpan(t.textSpan!, 'final', ElPrismPalette.keyword),
      );
      final bool hasNumber = richTexts.any(
        (Text t) => _hasColoredSpan(t.textSpan!, '1', ElPrismPalette.number),
      );

      expect(
        hasKeyword,
        isTrue,
        reason:
            'a Dart keyword must be coloured ElPrismPalette.keyword — this '
            'is the assertion that would have caught routing Dart through '
            'ElAgentCodeBlock, which does not know the language at all',
      );
      expect(hasNumber, isTrue);
    },
  );

  testWidgets(
    'the language strip names the language and uses no uppercase role',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        _host(const SizedBox(width: 640, child: DocsSnippet(code: 'x'))),
      );
      await tester.pump();

      expect(find.text('dart'), findsOneWidget);

      for (final ElText widget in tester.widgetList<ElText>(
        find.byType(ElText),
      )) {
        expect(widget.spec.uppercase, isFalse);
      }
    },
  );

  testWidgets('it carries exactly one copy control, holding the source', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _host(const SizedBox(width: 640, child: DocsSnippet(code: 'final a = 1;'))),
    );
    await tester.pump();

    expect(find.byType(DocsCopyButton), findsOneWidget);
    expect(
      tester.widget<DocsCopyButton>(find.byType(DocsCopyButton)).text,
      'final a = 1;',
    );
  });

  testWidgets(
    'the copy control sits inside the header strip, clear of the code body',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        _host(const SizedBox(width: 640, child: DocsSnippet(code: 'final a = 1;'))),
      );
      await tester.pump();

      final Rect strip = tester.getRect(
        find.byKey(const ValueKey<String>('docs-snippet-strip')),
      );
      final Rect codeBody = tester.getRect(
        find.byKey(const ValueKey<String>('docs-snippet-code-body')),
      );
      final Rect control = tester.getRect(find.byType(DocsCopyButton));

      // Right-aligned against the strip's own padded content edge, not the
      // block's outer corner.
      expect(
        control.right,
        closeTo(strip.right - ElAgentCodeBlock.stripPadX, el(1)),
      );
      // Clear of the language label sitting at the strip's left edge.
      expect(control.left, greaterThan(strip.left));
      // Vertically centred against the strip -- not floating over it from
      // the block's own top-right corner.
      expect(control.center.dy, closeTo(strip.center.dy, el(1)));
      // Never reaching down into the code body below the strip.
      expect(control.bottom, lessThanOrEqualTo(codeBody.top));
    },
  );

  testWidgets('an uncapped snippet has no expansion control', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _host(const SizedBox(width: 640, child: DocsSnippet(code: _long))),
    );
    await tester.pump();

    expect(find.byType(DocsSnippetOverflow), findsNothing);
  });

  testWidgets('a capped snippet expands and collapses', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      _host(
        SizedBox(
          width: 640,
          child: DocsSnippet(code: _long, maxHeight: el(20)),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Show more'), findsOneWidget);
    final double collapsed = tester.getSize(find.byType(DocsSnippet)).height;

    await tester.tap(find.text('Show more'));
    await tester.pump();
    await tester.pump(ElDurations.jelly);

    expect(find.text('Show less'), findsOneWidget);
    expect(
      tester.getSize(find.byType(DocsSnippet)).height,
      greaterThan(collapsed),
    );
  });
}
