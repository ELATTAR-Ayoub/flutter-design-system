import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// The standing Flutter contract: **literals live in exactly one place.**
///
/// `lib/src/design_system/foundation/` is the token source of truth (colors, sizes, tracking,
/// durations, curves, radii, shadow geometry). Every other file in `lib/` and
/// `example/lib/` consumes those tokens and must not restate a number.
///
/// There is no per-line escape hatch — a file either consumes tokens or it
/// *is* one, and the second case is declared once in [_exemptDirs], not
/// scattered as a comment on every literal it owns. Bare `0` / `0.0` and
/// `transparent` are always legal.
///
/// This is a raw text scan, comments included — a doc comment that spells out a
/// literal takes the same weight as code would.

/// Directories and individual files exempt from the scan (relative to the
/// repo root, posix slashes) because they are themselves a source of truth
/// for the numbers they contain, not a component restating one.
///
/// Each entry names the one file/directory whose job is exactly this — a
/// blanket exemption is the failure mode this list exists to avoid, so a new
/// entry needs the same argument [_exemptDirs]'s existing ones make: the
/// numbers are transcribed *whole* from one named external source (a
/// stylesheet's `@keyframes`, a vendored theme, a third-party library's own
/// constant), nothing here is chosen or tuned by this codebase, and no other
/// file reads these values as a token.
const List<String> _exemptDirs = <String>[
  'lib/src/design_system/foundation/',
  // The reference's fourteen `@keyframes` (plus one transition), transcribed
  // whole — motion *data*, in exactly the sense `TypeStep(14, 20)` is type
  // data in foundation/. See the file's own header.
  'lib/src/components/ui/keyframes.dart',
  // The default Button surface's own gradient ramp/texture geometry
  // (globals.css L2093–2160) and its `@keyframes action-beat` (L2059–2088) —
  // one effect's own numbers, transcribed from one named stylesheet rule and
  // read by no other file. See the file's "The utility's own geometry"
  // section.
  'lib/src/components/ui/action_feedback.dart',
  // The body background-effect's own `radial-gradient()` geometry
  // (globals.css L985–989) — same reasoning as action_feedback.dart, for the
  // one gradient this file paints.
  'lib/src/components/ui/background_effect.dart',
  // The value foil's own metal-ramp gradient geometry (globals.css
  // L1964–2030) and its `@keyframes value-foil-drift` / `value-glint`
  // (L1915–1946) — same reasoning as action_feedback.dart, transcribed for
  // this one premium surface and read by nothing else.
  'lib/src/components/ui/premium_surface.dart',
  // The VS Code "Dark Plus" theme `react-syntax-highlighter` writes as
  // *inline* styles — a third-party theme's own palette and metrics, not
  // this system's tokens, and read by nothing outside this file.
  'lib/src/components/ui/agent_markdown_prism_theme.dart',

  // ── example/ ─────────────────────────────────────────────────────────────
  // The example app demonstrates the token system; it is not itself scoped
  // by task-36 (lib/ is the job), but the guard still scans it, and these
  // three pre-existing cases carry the same "not a token" argument the
  // entries above do — recorded here, not as a per-line comment, once the
  // per-line escape hatch was removed.
  //
  // The reference's own stand-in photograph (`agent-demo.tsx`) — raw pixels
  // a specimen must reproduce exactly, which the file's own comment above
  // `_photoBase` already argues: "it does not follow the theme, and it must
  // not, or the specimen would prove the wrong thing."
  'example/lib/pages/transcript.dart',
  // API-fact prose that spells out a documented Duration's own value for the
  // reader (e.g. "Duration(milliseconds: 200) -- 200ms. How long a...") —
  // copy, not a value anything computes with.
  'example/lib/components_docs/toaster/page.dart',
  // A ~60Hz audio-analyser polling interval — not a layout/motion duration,
  // and not stated in `globals.css`.
  'example/lib/voice_source_web.dart',
];

/// Roots scanned, relative to the repo root.
const List<String> _roots = <String>['lib', 'example/lib'];

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
  // `\b` so this catches the bare `Color.fromARGB(...)` / `Color.fromRGBO(...)`
  // constructors it exists to push callers away from, without also matching
  // `OklabColor.fromOklch(...)` — the design system's own token-composing
  // method, whose name happens to contain the same "Color.from" substring.
  _Rule('Color.from* constructor', r'\bColor\.from'),
  _Rule('hardcoded font size', r'fontSize:\s*\d', zeroIsLegal: true),
  _Rule('hardcoded tracking', r'letterSpacing:\s*-?\d', zeroIsLegal: true),
  _Rule('hardcoded font weight', r'FontWeight\.w\d'),
  // `\b` so the rule catches stock `Curves.easeOut` without also catching
  // `MotionCurves.enter`, which is the thing it exists to push callers towards.
  _Rule('stock Flutter curve (use MotionCurves)', r'\bCurves\.'),
  _Rule(
    'hardcoded duration',
    r'Duration\((milli|micro)seconds:\s*\d',
    zeroIsLegal: true,
  ),
  _Rule('hardcoded radius', r'BorderRadius\.circular\(\d', zeroIsLegal: true),
  _Rule('raw BoxShadow (use Shadows/Surface)', r'BoxShadow\('),
  // Leading, not box height. A [TextStyle.height] is the unitless ratio CSS
  // calls `line-height`, so the scope is "the integer part is 0 or 1" — which
  // is every value the type scale declares and none of the pixel heights a box
  // takes (`h-9` is 36, a row is 40, an icon is 16, and all of them read off
  // `space()` or a component spec already).
  //
  // `\b` before `height` is what keeps `maxHeight:`/`minHeight:` out; the
  // camel-cased `lineHeight:` never matches at all, this rule being
  // case-sensitive like every other one here.
  _Rule('hardcoded line height', r'\bheight:\s*[01](?!\d)', zeroIsLegal: true),
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

    for (final _Rule rule in _rules) {
      for (final RegExpMatch match in rule.regExp.allMatches(line)) {
        if (rule.zeroIsLegal) {
          final Match? number = _numberFromHere.matchAsPrefix(
            line,
            match.end - 1,
          );
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

  test('no literals outside lib/src/design_system/foundation/', () {
    final List<TokenViolation> violations = <TokenViolation>[];
    int scanned = 0;

    for (final String root in _roots) {
      for (final File file in _dartFilesUnder(
        Directory('${repoRoot.path}/$root'),
      )) {
        final String posixPath = file.path
            .replaceAll(r'\', '/')
            .replaceFirst('${repoRoot.path.replaceAll(r'\', '/')}/', '');
        scanned++;
        violations.addAll(scanSource(posixPath, file.readAsStringSync()));
      }
    }

    expect(
      scanned,
      greaterThan(0),
      reason: 'guard scanned nothing — wrong cwd?',
    );
    expect(
      violations,
      isEmpty,
      reason:
          'Literals are allowed ONLY in lib/src/design_system/foundation/ and '
          'in the files _exemptPaths names as sources of truth in their own '
          'right. Either read the value from an existing token, add one to '
          'foundation/, or — if this file genuinely is a source of truth for '
          'this number (transcribed whole from one named external source, '
          'read as a token by nothing else) — add it to _exemptDirs with the '
          'same argument its existing entries make.\n${violations.join('\n')}',
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
        'stock Flutter curve (use MotionCurves)': 'final c = Curves.easeOut;',
        'hardcoded duration': 'const d = Duration(milliseconds: 250);',
        'hardcoded radius': 'final r = BorderRadius.circular(16);',
        'raw BoxShadow (use Shadows/Surface)': 'const b = BoxShadow();',
        'hardcoded line height': 'const s = TextStyle(height: 1.4);',
      };
      for (final MapEntry<String, String> sample in samples.entries) {
        final List<TokenViolation> hits = scanSource(
          'lib/src/probe.dart',
          sample.value,
        );
        expect(
          hits.map((TokenViolation v) => v.rule),
          contains(sample.key),
          reason: 'rule "${sample.key}" did not fire on: ${sample.value}',
        );
      }
    });

    test('MotionCurves is the sanctioned spelling, not a violation', () {
      expect(
        scanSource('lib/src/probe.dart', 'curve: MotionCurves.enter,'),
        isEmpty,
      );
      expect(
        scanSource(
          'lib/src/probe.dart',
          'reverseCurve: MotionCurves.enter.flipped,',
        ),
        isEmpty,
      );
      // …while the stock curve it replaces still trips, wherever it appears.
      expect(
        scanSource('lib/src/probe.dart', 'curve: Curves.easeOut,'),
        isNotEmpty,
      );
      expect(scanSource('lib/src/probe.dart', 'Curves.linear;'), isNotEmpty);
    });

    test('the line-height rule is leading, not box height', () {
      // What it is for: the ratios the type scale declares, wherever they are
      // restated — in code or in a comment quoting the stylesheet.
      for (final String leading in <String>[
        'height: 1,',
        'height: 1.0,',
        'height: 1.375,',
        'height: 1.625,',
        '/// `line-height: 1.4` inside `@layer components`',
      ]) {
        expect(
          scanSource('lib/src/probe.dart', leading),
          isNotEmpty,
          reason: 'a line height escaped the guard: $leading',
        );
      }

      // What it must not swallow: a box is measured in pixels and reads its
      // number off the scale, so those numbers are the *other* rules' business
      // and a false positive here would be paid for on every layout line.
      for (final String box in <String>[
        'SizedBox(height: 40)',
        'const SizedBox(height: 12, width: 12)',
        'constraints: const BoxConstraints(maxHeight: 1.5)',
        'BoxConstraints(minHeight: 20)',
        'final double lineHeight = 1.4;',
        '// width: 20, height: 14, x: 2, y: 3, rx: 2',
      ]) {
        expect(
          scanSource('lib/src/probe.dart', box),
          isEmpty,
          reason: 'the line-height rule fired on a box: $box',
        );
      }
    });

    test('lib/src/design_system/foundation/ is exempt', () {
      expect(
        scanSource(
          'lib/src/design_system/foundation/colors.dart',
          'const c = Color(0xFF92C2FC);',
        ),
        isEmpty,
      );
    });

    test('bare 0 and 0.0 are legal', () {
      expect(
        scanSource('lib/src/probe.dart', 'TextStyle(letterSpacing: 0)'),
        isEmpty,
      );
      expect(
        scanSource('lib/src/probe.dart', 'TextStyle(fontSize: 0.0)'),
        isEmpty,
      );
      expect(
        scanSource('lib/src/probe.dart', 'BorderRadius.circular(0)'),
        isEmpty,
      );
      // …but a real number still trips.
      expect(
        scanSource('lib/src/probe.dart', 'TextStyle(fontSize: 0.5)'),
        isNotEmpty,
      );
    });

    test('transparent is legal anywhere', () {
      expect(scanSource('lib/src/probe.dart', 'color: transparent,'), isEmpty);
    });

    test('a declared source-of-truth file is exempt', () {
      expect(
        scanSource(
          'lib/src/components/ui/keyframes.dart',
          'const c = Color(0xFF92C2FC);',
        ),
        isEmpty,
      );
    });

    test('OklabColor.fromOklch does not trip the Color.from* rule', () {
      expect(
        scanSource(
          'lib/src/probe.dart',
          'return OklabColor.fromOklch(l, c, h);',
        ),
        isEmpty,
      );
      // …while the bare constructor it exists to catch still trips.
      expect(
        scanSource('lib/src/probe.dart', 'Color.fromRGBO(0, 0, 0, 1);'),
        isNotEmpty,
      );
    });
  });
}
