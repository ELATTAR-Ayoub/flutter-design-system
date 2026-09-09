import 'package:flutter_test/flutter_test.dart';

import '../../tool/chart_sources/extractor.dart';

void main() {
  group('extractSpecimens', () {
    test('captures an expression-bodied declaration up to its semicolon', () {
      const String source = '''
// specimen: chart-area-default
Widget areaDefault(ChartInk ink) => plot(ink.desktop, const Text('x'));
''';
      expect(extractSpecimens(source), <String, String>{
        'chart-area-default':
            "Widget areaDefault(ChartInk ink) => plot(ink.desktop, const Text('x'));",
      });
    });

    test('captures a block-bodied declaration up to its closing brace', () {
      const String source = '''
// specimen: chart-pie-donut-text
Widget pieDonutText(ChartInk ink) {
  final int total = 1;
  return plot(ink.browsers, Text('\$total'));
}
''';
      expect(
        extractSpecimens(source)['chart-pie-donut-text'],
        'Widget pieDonutText(ChartInk ink) {\n'
        '  final int total = 1;\n'
        "  return plot(ink.browsers, Text('\$total'));\n"
        '}',
      );
    });

    test('includes the semicolon after a top-level assignment brace', () {
      const String source = '''
// specimen: chart-area-axes
const Map<String, int> axes = <String, int>{'a': 1};
''';
      expect(
        extractSpecimens(source)['chart-area-axes'],
        "const Map<String, int> axes = <String, int>{'a': 1};",
      );
    });

    test('a brace inside a string does not end the declaration', () {
      const String source = '''
// specimen: chart-bar-label
Widget barLabel() => const Text('}');
''';
      expect(
        extractSpecimens(source)['chart-bar-label'],
        "Widget barLabel() => const Text('}');",
      );
    });

    test('a brace inside a line comment does not end the declaration', () {
      const String source = '''
// specimen: chart-line-dots
Widget lineDots() {
  // a } in prose
  return const Text('x');
}
''';
      expect(
        extractSpecimens(source)['chart-line-dots'],
        'Widget lineDots() {\n'
        '  // a } in prose\n'
        "  return const Text('x');\n"
        '}',
      );
    });

    test('a brace inside a block comment does not end the declaration', () {
      const String source = '''
// specimen: chart-radar-dots
Widget radarDots() {
  /* } */
  return const Text('x');
}
''';
      expect(extractSpecimens(source)['chart-radar-dots'], contains('/* } */'));
    });

    test('interpolation braces are balanced as code, not swallowed', () {
      const String source = r'''
// specimen: chart-radial-text
Widget radialText(int n) => Text('${n + 1}');
''';
      expect(
        extractSpecimens(source)['chart-radial-text'],
        r"Widget radialText(int n) => Text('${n + 1}');",
      );
    });

    test('an escaped quote does not close the string', () {
      const String source = r'''
// specimen: chart-tooltip-default
Widget tooltipDefault() => const Text('it\'s');
''';
      expect(
        extractSpecimens(source)['chart-tooltip-default'],
        r"Widget tooltipDefault() => const Text('it\'s');",
      );
    });

    test('a raw string ignores escapes', () {
      const String source = r'''
// specimen: chart-bar-mixed
Widget barMixed() => const Text(r'a\');
''';
      expect(
        extractSpecimens(source)['chart-bar-mixed'],
        r"Widget barMixed() => const Text(r'a\');",
      );
    });

    test('a triple-quoted string may contain quotes and braces', () {
      const String source = """
// specimen: chart-pie-legend
Widget pieLegend() => const Text('''a } ' b''');
""";
      expect(
        extractSpecimens(source)['chart-pie-legend'],
        "Widget pieLegend() => const Text('''a } ' b''');",
      );
    });

    test('a class declaration is captured whole', () {
      const String source = '''
// specimen: chart-area-interactive
class AreaInteractive extends StatelessWidget {
  const AreaInteractive();

  @override
  Widget build(BuildContext context) => const Text('x');
}
''';
      final String out = extractSpecimens(source)['chart-area-interactive']!;
      expect(out, startsWith('class AreaInteractive'));
      expect(out, endsWith('}'));
    });

    test('several markers in one file are all captured', () {
      const String source = '''
// specimen: chart-a
Widget a() => const Text('a');

// specimen: chart-b
Widget b() => const Text('b');
''';
      expect(extractSpecimens(source).keys, <String>['chart-a', 'chart-b']);
    });

    test(
      'a differing quote character inside an interpolation does not leak '
      "into the outer string's quote state",
      () {
        const String source = r'''
// specimen: chart-quote-mismatch
Widget f() => Text("${'x'}");
''';
        expect(
          extractSpecimens(source)['chart-quote-mismatch'],
          r'Widget f() => Text("${' "'x'" r'}");',
        );
      },
    );

    test(
      'a quote mismatch inside one specimen does not over-capture the next',
      () {
        const String source = r'''
// specimen: chart-quote-mismatch
Widget f() => Text("${'x'}");

// specimen: chart-after-mismatch
Widget g() => const Text('y');
''';
        final Map<String, String> out = extractSpecimens(source);
        expect(out.keys, <String>['chart-quote-mismatch', 'chart-after-mismatch']);
        expect(out['chart-quote-mismatch'], isNot(contains('g()')));
      },
    );

    test('an unterminated declaration is an error naming the id', () {
      const String source = '''
// specimen: chart-broken
Widget broken() {
''';
      expect(
        () => extractSpecimens(source),
        throwsA(
          isA<FormatException>().having(
            (FormatException e) => e.message,
            'message',
            contains('chart-broken'),
          ),
        ),
      );
    });
  });

  group('dartStringLiteral', () {
    test('escapes backslash, quote and dollar', () {
      expect(dartStringLiteral(r"a\b'c$d"), r"'a\\b\'c\$d'");
    });

    test('escapes newlines so the literal stays on one line', () {
      expect(dartStringLiteral('a\nb'), r"'a\nb'");
    });

    test('round-trips a declaration containing all three', () {
      const String value = "Text('\$x') // a \\ b";
      final String literal = dartStringLiteral(value);
      expect(literal.startsWith("'"), isTrue);
      expect(literal.endsWith("'"), isTrue);
      expect(literal.contains('\n'), isFalse);
    });
  });
}
