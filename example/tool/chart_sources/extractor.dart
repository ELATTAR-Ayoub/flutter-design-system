/// Pulls the copyable source of every marked specimen out of a Dart file.
///
/// A library, not only a CLI, so `test/charts/chart_sources_guard_test.dart`
/// can re-run the extraction in-process and compare it against the committed
/// generated file. A guard that shells out to `dart run` is a guard that is
/// slow enough to be skipped.
library;

/// The marker a specimen declaration carries, on the line above it.
final RegExp _marker = RegExp(r'^\s*//\s*specimen:\s*([a-z0-9-]+)\s*$');

/// Every marked declaration in [source], keyed by its specimen id, in the
/// order the file declares them.
Map<String, String> extractSpecimens(String source) {
  final List<String> lines = source.split('\n');
  final Map<String, String> out = <String, String>{};

  for (int i = 0; i < lines.length; i++) {
    final RegExpMatch? match = _marker.firstMatch(lines[i]);
    if (match == null) continue;

    final String id = match.group(1)!;
    final int start = i + 1;
    if (start >= lines.length) {
      throw FormatException('specimen $id has no declaration under it');
    }
    final int end = _declarationEnd(lines, start, id);
    out[id] = lines.sublist(start, end + 1).join('\n').trimRight();
  }

  return out;
}

/// The index of the last line of the declaration beginning at [start].
///
/// A declaration ends either at a `;` seen at nesting depth zero, or at the
/// `}` that returns the depth to zero — plus the `;` that may follow it, so a
/// top-level `const Map<…> x = <…>{…};` keeps its terminator.
int _declarationEnd(List<String> lines, int start, String id) {
  int depth = 0;
  _Mode mode = _Mode.code;
  String quote = '';
  bool tripleQuoted = false;
  bool rawString = false;
  final List<int> interpolation = <int>[];

  for (int line = start; line < lines.length; line++) {
    final String text = lines[line];

    for (int i = 0; i < text.length; i++) {
      final String c = text[i];
      final String next = i + 1 < text.length ? text[i + 1] : '';

      if (mode == _Mode.blockComment) {
        if (c == '*' && next == '/') {
          mode = _Mode.code;
          i++;
        }
        continue;
      }

      if (mode == _Mode.string) {
        if (!rawString && c == r'\') {
          i++;
          continue;
        }
        if (!rawString && c == r'$' && next == '{') {
          interpolation.add(depth);
          depth++;
          mode = _Mode.code;
          i++;
          continue;
        }
        if (c == quote) {
          if (!tripleQuoted) {
            mode = _Mode.code;
            continue;
          }
          if (text.startsWith(quote * 3, i)) {
            mode = _Mode.code;
            i += 2;
            continue;
          }
        }
        continue;
      }

      // mode == _Mode.code
      if (c == '/' && next == '/') {
        i = text.length;
        continue;
      }
      if (c == '/' && next == '*') {
        mode = _Mode.blockComment;
        i++;
        continue;
      }
      if (c == "'" || c == '"') {
        quote = c;
        tripleQuoted = text.startsWith(c * 3, i);
        if (tripleQuoted) i += 2;
        rawString = i >= 1 && text[i - (tripleQuoted ? 3 : 1)] == 'r';
        mode = _Mode.string;
        continue;
      }
      if (c == '(' || c == '[' || c == '{') {
        depth++;
        continue;
      }
      if (c == ')' || c == ']' || c == '}') {
        depth--;
        if (interpolation.isNotEmpty && depth == interpolation.last) {
          interpolation.removeLast();
          mode = _Mode.string;
          continue;
        }
        if (depth == 0 && c == '}') {
          final String rest = text.substring(i + 1).trimLeft();
          if (rest.startsWith(';')) return line;
          if (rest.isEmpty &&
              line + 1 < lines.length &&
              lines[line + 1].trimLeft().startsWith(';')) {
            return line + 1;
          }
          return line;
        }
        continue;
      }
      if (c == ';' && depth == 0) return line;
    }
  }

  throw FormatException('specimen $id has no terminated declaration');
}

enum _Mode { code, string, blockComment }

/// [value] as a single-line Dart string literal.
///
/// Single-quoted with `\`, `'`, `$` and the newline escaped, rather than a raw
/// triple-quoted block: a specimen containing `'''` would close a raw block,
/// and one containing `$` would interpolate inside a non-raw one.
String dartStringLiteral(String value) {
  final StringBuffer out = StringBuffer("'");
  for (final int rune in value.runes) {
    final String c = String.fromCharCode(rune);
    out.write(switch (c) {
      r'\' => r'\\',
      "'" => r"\'",
      r'$' => r'\$',
      '\n' => r'\n',
      '\r' => r'\r',
      _ => c,
    });
  }
  out.write("'");
  return out.toString();
}
