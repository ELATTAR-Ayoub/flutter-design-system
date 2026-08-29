// example/lib/docs/docs_syntax.dart
/// The tokeniser behind [DocsSnippet].
///
/// DEVIATION from the task-2 brief, ruled by the repository owner: the brief
/// had `DocsSnippet` render through `AgentCodeBlock`. `AgentCodeBlock`
/// looks its language up in `languageAliases`
/// (`lib/src/components/ui/agent_markdown.dart`), which registers bash, css,
/// js/javascript, json, jsx, md/markdown, py/python, sh/shell, sql, ts/tsx/
/// typescript — and no `dart`. Since `dart` is the default language and
/// nearly all documentation code, routing through `AgentCodeBlock` would
/// render every Dart snippet flat and unhighlighted.
///
/// [docsTokenise] is the fix: for `dart` it runs a Dart tokenizer that lives
/// in this file, ported from `example/lib/docs/docs_code.dart` (the
/// `_DsCodeTokenKind` / `_DsCodeToken` / `_dsDartKeywords` /
/// `_dsIdentStart` / `_dsIdentPart` / `_dsDigit` / `_tokeniseDartLine`
/// grammar, kept exactly — see that file for what it does and does not
/// recognise). Only the colours change: instead of `docs_code.dart`'s own
/// `_dsCodeTokenColor` (this system's semantic tokens, `Palette.action`
/// etc.), every kind here paints through `PrismPalette` — the same VS Code
/// Dark Plus palette `AgentCodeBlock` uses — so the site still carries
/// exactly one syntax theme, not two. For every other language this falls
/// through to `AgentCodeBlock.normalise` + `tokenise`, the package's own
/// tokeniser; an unrecognised language renders as plain, uncoloured text
/// rather than failing.
///
/// `docs_code.dart` itself is left untouched: `DocsSelectableCodeBlock` and
/// its tokenizer still back the 65 other call sites this task does not move.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart' show Color;

/// Tokenises [code] as [language] for [DocsSnippet]'s highlighted body.
///
/// `language == 'dart'` runs the tokenizer below. Otherwise, when
/// `AgentCodeBlock.normalise(language)` recognises the fence, this defers
/// to the package's own `tokenise`. Anything else — an unrecognised
/// language — comes back as one plain, uncoloured [CodeToken] per line.
List<List<CodeToken>> docsTokenise(String code, String language) {
  if (language == 'dart') {
    return <List<CodeToken>>[
      for (final String line in code.split('\n')) _tokeniseDartLine(line),
    ];
  }

  final String? normalised = AgentCodeBlock.normalise(language);
  if (normalised != null) {
    return tokenise(code, normalised);
  }

  return <List<CodeToken>>[
    for (final String line in code.split('\n'))
      <CodeToken>[CodeToken(line, PrismPalette.plain)],
  ];
}

/* ── Dart source tokeniser — ported from docs_code.dart, colours only ─────
 *
 * Structured exactly as `docs_code.dart`'s own tokenizer: a single per-line
 * scan, no state carried across a newline. See that file's doc comment on
 * `_tokeniseDartLine` for the precise, honest list of what this covers (line
 * comments, single/double-quoted strings, decimal numbers, `@annotations`,
 * the reserved-word list below, PascalCase-as-type) and what it does not
 * (block comments, raw/triple-quoted strings, string interpolation — all of
 * which read as plain or string-coloured rather than failing).
 */

/// What kind of run a token is, for [_dsCodeTokenColor] to paint.
enum _DsCodeTokenKind {
  plain,
  keyword,
  string,
  comment,
  number,
  type,
  annotation,
}

/// One classified run inside a line of Dart-ish source.
class _DsCodeToken {
  const _DsCodeToken(this.text, this.kind);
  final String text;
  final _DsCodeTokenKind kind;
}

/// The VS Code Dark Plus palette [AgentCodeBlock] paints from — not this
/// system's own semantic tokens, so the site keeps exactly one syntax theme.
/// Annotations map to [PrismPalette.function]: Prism's own Dart grammar has
/// no dedicated annotation class, and `function` is the closest existing hue
/// for a `@override`-style marker that is neither a keyword nor a type.
Color _dsCodeTokenColor(_DsCodeTokenKind kind) => switch (kind) {
  _DsCodeTokenKind.keyword => PrismPalette.keyword,
  _DsCodeTokenKind.string => PrismPalette.string,
  _DsCodeTokenKind.number => PrismPalette.number,
  _DsCodeTokenKind.type => PrismPalette.type,
  _DsCodeTokenKind.annotation => PrismPalette.function,
  _DsCodeTokenKind.comment => PrismPalette.comment,
  _DsCodeTokenKind.plain => PrismPalette.plain,
};

/// Dart's reserved and built-in-identifier words — the only vocabulary this
/// tokeniser recognises as a keyword. Anything else identifier-shaped falls
/// through to plain text, or, if it starts with an uppercase letter, to
/// [_DsCodeTokenKind.type] — real Dart style's own convention for a type
/// name, and the only signal a per-line scanner has for one.
const Set<String> _dsDartKeywords = <String>{
  'abstract',
  'as',
  'assert',
  'async',
  'await',
  'base',
  'break',
  'case',
  'catch',
  'class',
  'const',
  'continue',
  'covariant',
  'default',
  'deferred',
  'do',
  'dynamic',
  'else',
  'enum',
  'export',
  'extends',
  'extension',
  'external',
  'factory',
  'false',
  'final',
  'finally',
  'for',
  'Function',
  'get',
  'hide',
  'if',
  'implements',
  'import',
  'in',
  'interface',
  'is',
  'late',
  'library',
  'mixin',
  'new',
  'null',
  'on',
  'operator',
  'part',
  'required',
  'rethrow',
  'return',
  'sealed',
  'set',
  'show',
  'static',
  'super',
  'switch',
  'sync',
  'this',
  'throw',
  'true',
  'try',
  'typedef',
  'var',
  'void',
  'when',
  'while',
  'with',
  'yield',
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

/// Tokenises one line of Dart-ish source into [CodeToken]s, coloured
/// through [PrismPalette].
///
/// See the file-level doc comment for exactly what this scanner covers.
List<CodeToken> _tokeniseDartLine(String line) {
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
          CodeToken(t.text, _dsCodeTokenColor(t.kind)),
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
      CodeToken(t.text, _dsCodeTokenColor(t.kind)),
  ];
}
