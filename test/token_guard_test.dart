import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// The standing contract of this port: **literals live in exactly one place.**
///
/// `lib/src/foundation/` is the token source of truth (colors, sizes, tracking,
/// durations, curves, radii, shadow geometry). Every other file in `lib/` and
/// `example/lib/` consumes those tokens and must not restate a number.
///
/// Escape hatch: put `allow-hardcoded: <reason>` on the offending line.
/// Bare `0` / `0.0` and `dsTransparent` are always legal.
///
/// This is a raw text scan, comments included — a doc comment that spells out a
/// literal takes the same `allow-hardcoded:` note as code would.

/// Directories exempt from the scan (relative to the repo root, posix slashes).
const List<String> _exemptDirs = <String>[
  'lib/src/foundation/',
];

/// Roots scanned, relative to the repo root.
const List<String> _roots = <String>[
  'lib',
  'example/lib',
];

class _Rule {
  const _Rule(this.name, this.pattern, {this.zeroIsLegal = false});

  final String name;
  final String pattern;

  /// When true, a match whose numeric literal is `0` / `0.0` is not a violation.
  final bool zeroIsLegal;

  RegExp get regExp => RegExp(pattern);
}

const List<_Rule> _rules = <_Rule>[
  _Rule('raw ARGB color', r'Color\(0x'),
  _Rule('Color.from* constructor', r'Color\.from'),
  _Rule('hardcoded font size', r'fontSize:\s*\d', zeroIsLegal: true),
  _Rule('hardcoded tracking', r'letterSpacing:\s*-?\d', zeroIsLegal: true),
  _Rule('hardcoded font weight', r'FontWeight\.w\d'),
  _Rule('stock Flutter curve (use DsCurves)', r'Curves\.'),
  _Rule('hardcoded duration', r'Duration\((milli|micro)seconds:\s*\d',
      zeroIsLegal: true),
  _Rule('hardcoded radius', r'BorderRadius\.circular\(\d', zeroIsLegal: true),
  _Rule('raw BoxShadow (use DsShadows/DsMachineSurface)', r'BoxShadow\('),
];

/// A number literal is "bare zero" when it is `0`, `0.0`, `0.00`… — nothing else.
final RegExp _zeroLiteral = RegExp(r'^0(?:\.0+)?$');

/// Every `zeroIsLegal` pattern ends on `\d`, so the literal starts one char
/// before the match end; read it forward to see the whole number.
final RegExp _numberFromHere = RegExp(r'\d[\d.]*');

class TokenViolation {
  TokenViolation(this.file, this.line, this.rule, this.text);

  final String file;
  final int line;
  final String rule;
  final String text;

  @override
  String toString() => '$file:$line  [$rule]  ${text.trim()}';
}

bool _isExempt(String posixPath) =>
    _exemptDirs.any((String dir) => posixPath.startsWith(dir));

/// Scans one file's source and returns every literal that escaped the
/// foundation layer. Pure function so the guard can be tested on itself.
List<TokenViolation> scanSource(String posixPath, String source) {
  if (_isExempt(posixPath)) return const <TokenViolation>[];

  final List<TokenViolation> found = <TokenViolation>[];
  final List<String> lines = source.split('\n');
  for (int i = 0; i < lines.length; i++) {
    final String line = lines[i];
    if (line.contains('allow-hardcoded:')) continue;

    for (final _Rule rule in _rules) {
      for (final RegExpMatch match in rule.regExp.allMatches(line)) {
        if (rule.zeroIsLegal) {
          final Match? number = _numberFromHere.matchAsPrefix(line, match.end - 1);
          if (number != null && _zeroLiteral.hasMatch(number[0]!)) continue;
        }
        found.add(TokenViolation(posixPath, i + 1, rule.name, line));
      }
    }
  }
  return found;
}

Iterable<File> _dartFilesUnder(Directory root) sync* {
  if (!root.existsSync()) return;
  for (final FileSystemEntity entity in root.listSync(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) yield entity;
  }
}

void main() {
  final Directory repoRoot = Directory.current;

  test('no literals outside lib/src/foundation/', () {
    final List<TokenViolation> violations = <TokenViolation>[];
    int scanned = 0;

    for (final String root in _roots) {
      for (final File file in _dartFilesUnder(Directory('${repoRoot.path}/$root'))) {
        final String posixPath = file.path
            .replaceAll(r'\', '/')
            .replaceFirst('${repoRoot.path.replaceAll(r'\', '/')}/', '');
        scanned++;
        violations.addAll(scanSource(posixPath, file.readAsStringSync()));
      }
    }

    expect(scanned, greaterThan(0), reason: 'guard scanned nothing — wrong cwd?');
    expect(
      violations,
      isEmpty,
      reason: 'Literals are allowed ONLY in lib/src/foundation/.\n'
          'Add `// allow-hardcoded: <reason>` to the line if it is genuinely '
          'unavoidable.\n${violations.join('\n')}',
    );
  });

  group('the guard itself', () {
    test('catches every rule it declares', () {
      const Map<String, String> samples = <String, String>{
        'raw ARGB color': 'const c = Color(0xFF92C2FC);',
        'Color.from* constructor': 'final c = Color.fromARGB(255, 1, 2, 3);',
        'hardcoded font size': 'const s = TextStyle(fontSize: 15);',
        'hardcoded tracking': 'const s = TextStyle(letterSpacing: -0.01);',
        'hardcoded font weight': 'const w = FontWeight.w650;',
        'stock Flutter curve (use DsCurves)': 'final c = Curves.easeOut;',
        'hardcoded duration': 'const d = Duration(milliseconds: 250);',
        'hardcoded radius': 'final r = BorderRadius.circular(16);',
        'raw BoxShadow (use DsShadows/DsMachineSurface)': 'const b = BoxShadow();',
      };
      for (final MapEntry<String, String> sample in samples.entries) {
        final List<TokenViolation> hits = scanSource('lib/src/probe.dart', sample.value);
        expect(hits.map((TokenViolation v) => v.rule), contains(sample.key),
            reason: 'rule "${sample.key}" did not fire on: ${sample.value}');
      }
    });

    test('allow-hardcoded: exempts the line', () {
      expect(
        scanSource('lib/src/probe.dart',
            'final c = Curves.easeOut; // allow-hardcoded: probe'),
        isEmpty,
      );
    });

    test('lib/src/foundation/ is exempt', () {
      expect(
        scanSource('lib/src/foundation/colors.dart', 'const c = Color(0xFF92C2FC);'),
        isEmpty,
      );
    });

    test('bare 0 and 0.0 are legal', () {
      expect(scanSource('lib/src/probe.dart', 'TextStyle(letterSpacing: 0)'), isEmpty);
      expect(scanSource('lib/src/probe.dart', 'TextStyle(fontSize: 0.0)'), isEmpty);
      expect(scanSource('lib/src/probe.dart', 'BorderRadius.circular(0)'), isEmpty);
      // …but a real number still trips.
      expect(scanSource('lib/src/probe.dart', 'TextStyle(fontSize: 0.5)'), isNotEmpty);
    });

    test('dsTransparent is legal anywhere', () {
      expect(scanSource('lib/src/probe.dart', 'color: dsTransparent,'), isEmpty);
    });
  });
}
