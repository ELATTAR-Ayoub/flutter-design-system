// example/lib/docs/docs_theme_syntax.dart
/// The theme-adaptive tokeniser shared by [DocsSelectableCodeBlock]
/// (`docs_code.dart`) and [CodeBlock] (`../kit.dart`).
///
/// This is deliberately **not** the same engine as [docsTokenise]
/// (`docs_syntax.dart`), and the two are not merged. `docsTokenise` paints
/// through `PrismPalette` — a verbatim, frozen VS Code Dark Plus theme that
/// [DocsSnippet] renders on its own fixed `PrismPalette.ground`, regardless
/// of the site's light/dark state. The blocks this file serves do the
/// opposite: they sit on `theme.background`/`theme.muted`, matching the
/// panel around them, so their ink has to answer to light *and* dark and to
/// a rebrand — `docs_code.dart`'s own former header comment ruled this out
/// explicitly before this file existed. Painting them from `PrismPalette`
/// would put a frozen dark palette on a surface that is not always dark.
/// So every colour here comes from this system's own semantic tokens
/// (`Palette.action/.value/.success/.warning/.info`, `--foreground`,
/// `--muted-foreground`) instead.
///
/// Originally lived, duplicated, inside `docs_code.dart` alone; `kit.dart`'s
/// `CodeBlock` rendered flat, untokenised text. Extracted here so the one
/// scanner backs both instead of `kit.dart` growing a second copy.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart' show Color;

/// Tokenises [code] as [language], painting through [theme]'s own semantic
/// colours rather than a fixed syntax theme.
///
/// `dart` and `bash`/`sh`/`shell` run the small scanners below. Any other
/// language — including one this file simply does not know — comes back as
/// one plain, uncoloured [CodeToken] per line, the same "render intact,
/// don't fail" contract [docsTokenise] promises.
List<List<CodeToken>> tokeniseThemedCode(
  String code,
  String language,
  ThemeTokens theme,
) {
  switch (language) {
    case 'dart':
      return <List<CodeToken>>[
        for (final String line in code.split('\n'))
          _tokeniseDartLine(line, theme),
      ];
    case 'bash':
    case 'sh':
    case 'shell':
      return <List<CodeToken>>[
        for (final String line in code.split('\n'))
          _tokeniseBashLine(line, theme),
      ];
    default:
      return <List<CodeToken>>[
        for (final String line in code.split('\n'))
          <CodeToken>[CodeToken(line, theme.foreground)],
      ];
  }
}

/* ── Shared scanning primitives ────────────────────────────────────────── */

/// What kind of run a token is, for [_dsCodeTokenColor] to paint.
enum _DsCodeTokenKind { plain, keyword, string, comment, number, type, annotation }

/// One classified run inside a line of source.
class _DsCodeToken {
  const _DsCodeToken(this.text, this.kind);
  final String text;
  final _DsCodeTokenKind kind;
}

/// This system's own semantic colours, not a fixed syntax theme: every hue is
/// one already defined for state (`Palette.action/.value/.success/.warning/
/// .info`) or for text (`--foreground`/`--muted-foreground`), so a block
/// painted from it stays correct under a rebrand and flips with light/dark
/// exactly as the rest of the page does.
Color _dsCodeTokenColor(_DsCodeTokenKind kind, ThemeTokens theme) =>
    switch (kind) {
      _DsCodeTokenKind.keyword => Palette.action,
      _DsCodeTokenKind.string => Palette.success,
      _DsCodeTokenKind.number => Palette.warning,
      _DsCodeTokenKind.type => Palette.info,
      _DsCodeTokenKind.annotation => Palette.value,
      _DsCodeTokenKind.comment => theme.mutedForeground,
      _DsCodeTokenKind.plain => theme.foreground,
    };

final RegExp _dsIdentStart = RegExp(r'[A-Za-z_$]');
final RegExp _dsIdentPart = RegExp(r'[A-Za-z0-9_$]');
final RegExp _dsDigit = RegExp(r'[0-9]');
// Equivalent to the old `word[0].toUpperCase() == word[0] &&
// word[0].toLowerCase() != word[0]` pair: that conjunction is true only when
// the leading character is an actual cased uppercase letter — a digit,
// underscore or `$` fails the second half because lower-casing them is a
// no-op, so they never qualify. A leading `[A-Z]` match captures exactly the
// same set.
final RegExp _upperStart = RegExp(r'^[A-Z]');

/* ── Dart ───────────────────────────────────────────────────────────────
 *
 * Ported verbatim from `docs_code.dart`'s original private tokeniser — same
 * grammar, same limits, now the one copy both callers share.
 */

/// Dart's reserved and built-in-identifier words — the only vocabulary this
/// tokeniser recognises as a keyword. Anything else identifier-shaped falls
/// through to plain text, or, if it starts with an uppercase letter, to
/// [_DsCodeTokenKind.type] — real Dart style's own convention for a type
/// name, and the only signal a per-line scanner has for one.
const Set<String> _dsDartKeywords = <String>{
  'abstract', 'as', 'assert', 'async', 'await', 'base', 'break', 'case',
  'catch', 'class', 'const', 'continue', 'covariant', 'default', 'deferred',
  'do', 'dynamic', 'else', 'enum', 'export', 'extends', 'extension',
  'external', 'factory', 'false', 'final', 'finally', 'for', 'Function',
  'get', 'hide', 'if', 'implements', 'import', 'in', 'interface', 'is',
  'late', 'library', 'mixin', 'new', 'null', 'on', 'operator', 'part',
  'required', 'rethrow', 'return', 'sealed', 'set', 'show', 'static',
  'super', 'switch', 'sync', 'this', 'throw', 'true', 'try', 'typedef',
  'var', 'void', 'when', 'while', 'with', 'yield',
};

/// Tokenises one line of Dart-ish source.
///
/// **What this covers**: line comments (`//` and `///`, to end of line),
/// single- and double-quoted strings with backslash escapes, decimal
/// numbers, `@annotation`s, the reserved-word list above, and identifiers
/// read as a **type** on the one heuristic a per-line scan can afford —
/// `PascalCase`. Everything else — punctuation, operators, unmatched
/// identifiers — is plain text.
///
/// **What it does not cover, plainly**: this is a scanner, not a parser, and
/// it carries no state across a newline. A `/* block comment */`, a raw
/// string (`r'...'`), or a `'''triple-quoted'''` string that spans more than
/// one line is not recognised as such. String interpolation (`'$name'`,
/// `'${expr}'`) is not parsed inside a string; the whole quoted run is just
/// string-coloured throughout.
List<CodeToken> _tokeniseDartLine(String line, ThemeTokens theme) {
  final List<_DsCodeToken> out = <_DsCodeToken>[];
  final StringBuffer plain = StringBuffer();

  void flush() {
    if (plain.isEmpty) return;
    out.add(_DsCodeToken(plain.toString(), _DsCodeTokenKind.plain));
    plain.clear();
  }

  int i = 0;
  while (i < line.length) {
    final String c = line[i];

    // A line comment runs to the end of the line, `///` included.
    if (c == '/' && i + 1 < line.length && line[i + 1] == '/') {
      flush();
      out.add(_DsCodeToken(line.substring(i), _DsCodeTokenKind.comment));
      return <CodeToken>[
        for (final _DsCodeToken t in out)
          CodeToken(t.text, _dsCodeTokenColor(t.kind, theme)),
      ];
    }

    if (c == '@' &&
        i + 1 < line.length &&
        _dsIdentStart.hasMatch(line[i + 1])) {
      flush();
      final int start = i;
      i += 1;
      while (i < line.length && _dsIdentPart.hasMatch(line[i])) {
        i += 1;
      }
      out.add(
        _DsCodeToken(line.substring(start, i), _DsCodeTokenKind.annotation),
      );
      continue;
    }

    if (c == '"' || c == "'") {
      flush();
      final int start = i;
      i += 1;
      while (i < line.length) {
        if (line[i] == r'\' && i + 1 < line.length) {
          i += 2;
          continue;
        }
        if (line[i] == c) {
          i += 1;
          break;
        }
        i += 1;
      }
      out.add(
        _DsCodeToken(
          line.substring(start, i.clamp(0, line.length)),
          _DsCodeTokenKind.string,
        ),
      );
      continue;
    }

    if (_dsDigit.hasMatch(c)) {
      flush();
      final int start = i;
      while (i < line.length &&
          (_dsDigit.hasMatch(line[i]) || line[i] == '.' || line[i] == '_')) {
        i += 1;
      }
      out.add(_DsCodeToken(line.substring(start, i), _DsCodeTokenKind.number));
      continue;
    }

    if (_dsIdentStart.hasMatch(c)) {
      flush();
      final int start = i;
      while (i < line.length && _dsIdentPart.hasMatch(line[i])) {
        i += 1;
      }
      final String word = line.substring(start, i);
      if (_dsDartKeywords.contains(word)) {
        out.add(_DsCodeToken(word, _DsCodeTokenKind.keyword));
      } else if (word.isNotEmpty && _upperStart.hasMatch(word)) {
        out.add(_DsCodeToken(word, _DsCodeTokenKind.type));
      } else {
        out.add(_DsCodeToken(word, _DsCodeTokenKind.plain));
      }
      continue;
    }

    plain.write(c);
    i += 1;
  }

  flush();
  return <CodeToken>[
    for (final _DsCodeToken t in out)
      CodeToken(t.text, _dsCodeTokenColor(t.kind, theme)),
  ];
}

/* ── Shell / bash ───────────────────────────────────────────────────────
 *
 * New: this is the gap that had every CLI command in the docs — the home
 * page's "Own your first component" block among them — render as flat,
 * uncoloured text end to end (see the removed comment this replaces in
 * `docs_code.dart`, which said as much).
 */

/// Tokenises one line of shell-ish source: `dart install elattar_cli`,
/// `elattar init --foundation source`, and the like.
///
/// **What this covers**: a `# comment` to end of line, single- and
/// double-quoted strings with backslash escapes, `$VAR`/`${VAR}` references,
/// decimal numbers, `-flag`/`--flag` options, and the line's leading word —
/// the command name — as a keyword. Everything else is plain text.
///
/// **What it does not cover**: command chaining (`&&`, `;`, `|`) does not
/// reset the "leading word" detector, so only the very first word on a line
/// reads as the command; a subshell or pipeline's later commands render
/// plain rather than failing.
List<CodeToken> _tokeniseBashLine(String line, ThemeTokens theme) {
  final List<_DsCodeToken> out = <_DsCodeToken>[];
  final StringBuffer plain = StringBuffer();
  bool sawWord = false;

  void flush() {
    if (plain.isEmpty) return;
    out.add(_DsCodeToken(plain.toString(), _DsCodeTokenKind.plain));
    plain.clear();
  }

  int i = 0;
  while (i < line.length) {
    final String c = line[i];

    if (c == '#') {
      flush();
      out.add(_DsCodeToken(line.substring(i), _DsCodeTokenKind.comment));
      return <CodeToken>[
        for (final _DsCodeToken t in out)
          CodeToken(t.text, _dsCodeTokenColor(t.kind, theme)),
      ];
    }

    if (c == '"' || c == "'") {
      flush();
      final int start = i;
      i += 1;
      while (i < line.length) {
        if (line[i] == r'\' && i + 1 < line.length) {
          i += 2;
          continue;
        }
        if (line[i] == c) {
          i += 1;
          break;
        }
        i += 1;
      }
      out.add(
        _DsCodeToken(
          line.substring(start, i.clamp(0, line.length)),
          _DsCodeTokenKind.string,
        ),
      );
      sawWord = true;
      continue;
    }

    if (c == r'$' && i + 1 < line.length) {
      flush();
      final int start = i;
      i += 1;
      if (line[i] == '{') {
        i += 1;
        while (i < line.length && line[i] != '}') {
          i += 1;
        }
        if (i < line.length) i += 1;
      } else {
        while (i < line.length && _dsIdentPart.hasMatch(line[i])) {
          i += 1;
        }
      }
      out.add(_DsCodeToken(line.substring(start, i), _DsCodeTokenKind.type));
      sawWord = true;
      continue;
    }

    if (c == '-' &&
        i + 1 < line.length &&
        (line[i + 1] == '-' || _dsIdentStart.hasMatch(line[i + 1]))) {
      flush();
      final int start = i;
      i += 1;
      if (i < line.length && line[i] == '-') i += 1;
      while (i < line.length &&
          (_dsIdentPart.hasMatch(line[i]) || line[i] == '-')) {
        i += 1;
      }
      out.add(
        _DsCodeToken(line.substring(start, i), _DsCodeTokenKind.annotation),
      );
      sawWord = true;
      continue;
    }

    if (_dsDigit.hasMatch(c)) {
      flush();
      final int start = i;
      while (i < line.length &&
          (_dsDigit.hasMatch(line[i]) || line[i] == '.' || line[i] == '_')) {
        i += 1;
      }
      out.add(_DsCodeToken(line.substring(start, i), _DsCodeTokenKind.number));
      sawWord = true;
      continue;
    }

    if (_dsIdentStart.hasMatch(c)) {
      flush();
      final int start = i;
      while (i < line.length && _dsIdentPart.hasMatch(line[i])) {
        i += 1;
      }
      final String word = line.substring(start, i);
      if (!sawWord) {
        out.add(_DsCodeToken(word, _DsCodeTokenKind.keyword));
        sawWord = true;
      } else {
        out.add(_DsCodeToken(word, _DsCodeTokenKind.plain));
      }
      continue;
    }

    plain.write(c);
    i += 1;
  }

  flush();
  return <CodeToken>[
    for (final _DsCodeToken t in out)
      CodeToken(t.text, _dsCodeTokenColor(t.kind, theme)),
  ];
}
