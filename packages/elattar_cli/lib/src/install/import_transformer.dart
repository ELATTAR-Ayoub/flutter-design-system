import 'dart:io';

import 'target_mapper.dart';

/// The package whose umbrella barrel application sources (shots) import so that
/// they compile inside this repository. A consumer project has no dependency on
/// it, so on install the import is rewritten onto the barrels the installer
/// generates.
const String designSystemPackage = 'elattar_design_system';

/// Barrels emitted by `Installer.plan`, project-root relative and in the order
/// they are written into a rewritten source. Keep in sync with the
/// `_queueBarrel` calls in `installer.dart`.
const List<String> designSystemBarrels = <String>[
  'lib/components/ui/ui.dart',
  'lib/design_system/foundation.dart',
];

const String _packagePrefix = 'package:$designSystemPackage/';

class DartImportTransformer {
  DartImportTransformer({LogicalTargetMapper? mapper})
    : mapper = mapper ?? const LogicalTargetMapper();

  final LogicalTargetMapper mapper;

  /// Rewrites the import/export URIs of [content] so the file compiles at
  /// [targetPath] inside the consumer project rooted at [projectRoot].
  ///
  /// [projectRoot] is passed in rather than derived from [targetPath]: the
  /// consumer's own root may itself contain a `lib` directory, and a target
  /// need not sit under `lib/` at all.
  String transform({
    required String sourcePath,
    required String targetPath,
    required String projectRoot,
    required String content,
  }) {
    final StringBuffer output = StringBuffer();
    int cursor = 0;
    for (final _Directive directive in _topLevelDirectives(content)) {
      // Only the `import 'uri'` head is ever replaced; any prefix, combinator
      // and the terminating `;` are copied through verbatim.
      final String original = content.substring(
        directive.start,
        directive.uriEnd,
      );
      output
        ..write(content.substring(cursor, directive.start))
        ..write(
          _rewriteDirective(
                directive: directive,
                sourcePath: sourcePath,
                targetPath: targetPath,
                projectRoot: projectRoot,
              ) ??
              original,
        );
      cursor = directive.uriEnd;
    }
    output.write(content.substring(cursor));
    return output.toString();
  }

  /// Returns the replacement for a directive's `import 'uri'` head, or `null`
  /// when the directive has no consumer-local counterpart and must be left as
  /// it is.
  String? _rewriteDirective({
    required _Directive directive,
    required String sourcePath,
    required String targetPath,
    required String projectRoot,
  }) {
    final String uri = directive.uri;
    if (uri.startsWith(_packagePrefix)) {
      return _rewriteDesignSystemPackage(
        directive: directive.keyword,
        uri: uri,
        targetPath: targetPath,
        projectRoot: projectRoot,
        trailing: directive.trailing,
      );
    }
    final bool hasScheme = RegExp(r'^[A-Za-z][A-Za-z0-9+.-]*:').hasMatch(uri);
    if (hasScheme) return null;
    final String sourceResolved = _normalise(
      '${File(sourcePath).parent.path}/$uri',
    );
    final String logical = _logicalTarget(sourceResolved);
    if (logical == sourceResolved) return null;
    final String destination = mapper.destination(projectRoot, logical);
    final String rewritten = mapper.relativeImport(targetPath, destination);
    return '${directive.keyword} \'$rewritten\'';
  }

  /// Rewrites `package:elattar_design_system/...` onto consumer-local paths.
  ///
  /// Returns `null` when the URI has no counterpart in a consumer project, in
  /// which case the directive is left untouched.
  String? _rewriteDesignSystemPackage({
    required String directive,
    required String uri,
    required String targetPath,
    required String projectRoot,
    required String trailing,
  }) {
    final String path = uri.substring(_packagePrefix.length);
    if (path == '$designSystemPackage.dart') {
      // The umbrella barrel has no single counterpart: the installer emits one
      // barrel per family, so one directive fans out to several. That is only
      // sound for a plain directive — a prefix (`as space`) or a combinator
      // (`show`/`hide`) cannot be distributed across barrels without silently
      // changing what resolves, so refuse rather than emit broken code.
      if (trailing.isNotEmpty) {
        throw StateError(
          'Cannot rewrite "$uri" for $targetPath: an umbrella directive with '
          '"$trailing" cannot be split across the generated barrels '
          '(${designSystemBarrels.join(', ')}). Import the umbrella barrel '
          'plainly, or import the specific library instead.',
        );
      }
      return <String>[
        for (final String barrel in designSystemBarrels)
          _barrelDirective(directive, targetPath, projectRoot, barrel),
        // The source's own `;` terminates the final directive.
      ].join(';\n');
    }
    if (path.startsWith('src/')) {
      final String? logical = _logicalForSourceSuffix(path.substring(4));
      if (logical == null) return null;
      final String destination = mapper.destination(projectRoot, logical);
      return '$directive \'${mapper.relativeImport(targetPath, destination)}\'';
    }
    return null;
  }

  String _barrelDirective(
    String directive,
    String targetPath,
    String projectRoot,
    String projectRelativeBarrel,
  ) {
    final String destination = '$projectRoot/$projectRelativeBarrel';
    final String line =
        '$directive \'${mapper.relativeImport(targetPath, destination)}\'';
    if (directive != 'import') return line;
    // One umbrella import fans out to every barrel, so a consumer project can
    // legitimately end up not using one of them. `unused_import` is an
    // analyzer warning that is on by default (and `flutter analyze` fails on
    // warnings), so suppress it per line rather than leaving consumers to
    // hand-prune generated code.
    return '// ignore: unused_import\n$line';
  }

  String _logicalTarget(String sourcePath) {
    final String normalized = sourcePath.replaceAll('\\', '/');
    final int marker = normalized.indexOf('/lib/src/');
    if (marker < 0) return sourcePath;
    return _logicalForSourceSuffix(normalized.substring(marker + 9)) ??
        sourcePath;
  }

  /// Maps a path relative to the package's `lib/src/` onto a logical target,
  /// or `null` when the path is not distributed through the registry.
  String? _logicalForSourceSuffix(String suffix) {
    if (suffix.startsWith('components/ui/')) {
      return '@ui/${suffix.substring('components/ui/'.length)}';
    }
    if (suffix.startsWith('design_system/foundation/')) {
      return '@foundation/${suffix.substring('design_system/foundation/'.length)}';
    }
    if (suffix.startsWith('blocks/')) {
      return '@block/${suffix.substring('blocks/'.length)}';
    }
    return null;
  }

  static String _normalise(String value) {
    final List<String> parts = <String>[];
    for (final String part in value.replaceAll('\\', '/').split('/')) {
      if (part.isEmpty || part == '.') continue;
      if (part == '..' && parts.isNotEmpty) {
        parts.removeLast();
      } else {
        parts.add(part);
      }
    }
    return parts.join('/');
  }
}

/// One `import`/`export` directive located in a compilation unit's directive
/// prologue.
class _Directive {
  const _Directive({
    required this.start,
    required this.uriEnd,
    required this.end,
    required this.keyword,
    required this.uri,
    required this.trailing,
  });

  /// Offset of the `import`/`export` keyword.
  final int start;

  /// Offset just past the closing quote of the URI literal, i.e. the end of
  /// the `import 'uri'` head that a rewrite replaces.
  final int uriEnd;

  /// Offset just past the terminating `;`.
  final int end;

  /// `import` or `export`.
  final String keyword;

  /// The URI as written, without its quotes.
  final String uri;

  /// Everything between the URI and the `;` — a prefix (`as space`), a combinator
  /// (`show X`, `hide Y`), a configuration clause — trimmed. Empty for a plain
  /// directive.
  final String trailing;
}

/// Collects the `import`/`export` directives of a Dart compilation unit.
///
/// Dart requires every directive to precede the first declaration, so this
/// walks the directive prologue only and stops at the first token that starts
/// a declaration (or an annotation on one). Whitespace, `//` and `/* */`
/// comments and string literals are *skipped* rather than pattern-matched, so
/// the word `import` written inside a doc comment, a line comment or a string
/// literal is never mistaken for a directive and rewritten.
List<_Directive> _topLevelDirectives(String content) {
  final List<_Directive> directives = <_Directive>[];
  int index = 0;
  while (true) {
    index = _skipTrivia(content, index);
    if (index >= content.length) break;
    final String word = _identifierAt(content, index);
    if (word == 'import' || word == 'export') {
      final _Directive? directive = _readDirective(content, index, word);
      if (directive == null) break;
      directives.add(directive);
      index = directive.end;
      continue;
    }
    if (word == 'library' || word == 'part') {
      // Carries no rewritable URI, but still belongs to the prologue.
      final int end = _skipToSemicolon(content, index + word.length);
      if (end < 0) break;
      index = end;
      continue;
    }
    break;
  }
  return directives;
}

_Directive? _readDirective(String content, int start, String keyword) {
  final int uriStart = _skipTrivia(content, start + keyword.length);
  final _StringLiteral? uri = _readStringLiteral(content, uriStart);
  if (uri == null) return null;
  final int end = _skipToSemicolon(content, uri.end);
  if (end < 0) return null;
  return _Directive(
    start: start,
    uriEnd: uri.end,
    end: end,
    keyword: keyword,
    uri: uri.value,
    trailing: content.substring(uri.end, end - 1).trim(),
  );
}

/// Advances past whitespace and comments. Returns [index] unchanged when it
/// already points at something else.
int _skipTrivia(String content, int index) {
  int i = index;
  while (i < content.length) {
    final String character = content[i];
    if (character == ' ' ||
        character == '\t' ||
        character == '\n' ||
        character == '\r') {
      i++;
      continue;
    }
    if (content.startsWith('//', i)) {
      final int newline = content.indexOf('\n', i);
      i = newline < 0 ? content.length : newline + 1;
      continue;
    }
    if (content.startsWith('/*', i)) {
      i = _skipBlockComment(content, i);
      continue;
    }
    break;
  }
  return i;
}

/// Dart block comments nest, so this counts depth rather than searching for
/// the first `*/`.
int _skipBlockComment(String content, int index) {
  int i = index + 2;
  int depth = 1;
  while (i < content.length && depth > 0) {
    if (content.startsWith('/*', i)) {
      depth++;
      i += 2;
      continue;
    }
    if (content.startsWith('*/', i)) {
      depth--;
      i += 2;
      continue;
    }
    i++;
  }
  return i;
}

/// Returns the offset just past the `;` that terminates a directive, skipping
/// comments and string literals (a configurable import carries both), or `-1`
/// when the directive is unterminated.
int _skipToSemicolon(String content, int index) {
  int i = index;
  while (i < content.length) {
    final int skipped = _skipTrivia(content, i);
    if (skipped != i) {
      i = skipped;
      continue;
    }
    if (content[i] == ';') return i + 1;
    final _StringLiteral? literal = _readStringLiteral(content, i);
    if (literal != null) {
      i = literal.end;
      continue;
    }
    i++;
  }
  return -1;
}

String _identifierAt(String content, int index) {
  int i = index;
  while (i < content.length && _isIdentifierChar(content.codeUnitAt(i))) {
    i++;
  }
  return content.substring(index, i);
}

bool _isIdentifierChar(int code) =>
    (code >= 0x61 && code <= 0x7a) || // a-z
    (code >= 0x41 && code <= 0x5a) || // A-Z
    (code >= 0x30 && code <= 0x39) || // 0-9
    code == 0x5f || // _
    code == 0x24; // $

class _StringLiteral {
  const _StringLiteral(this.value, this.end);

  final String value;

  /// Offset just past the closing quote.
  final int end;
}

/// Reads the string literal starting at [index], or returns `null` when
/// [index] does not begin one. Handles raw (`r'...'`) and multi-line
/// (`'''...'''`) forms.
_StringLiteral? _readStringLiteral(String content, int index) {
  int i = index;
  bool raw = false;
  if (i < content.length && content[i] == 'r') {
    raw = true;
    i++;
  }
  if (i >= content.length) return null;
  final String quote = content[i];
  if (quote != "'" && quote != '"') return null;
  final String delimiter = content.startsWith(quote * 3, i) ? quote * 3 : quote;
  i += delimiter.length;
  final StringBuffer value = StringBuffer();
  while (i < content.length) {
    if (content.startsWith(delimiter, i)) {
      return _StringLiteral(value.toString(), i + delimiter.length);
    }
    if (!raw && content[i] == r'\' && i + 1 < content.length) {
      // Kept verbatim: a directive URI never needs an escape, and the scanner
      // only has to get past it.
      value.write(content.substring(i, i + 2));
      i += 2;
      continue;
    }
    if (delimiter.length == 1 && (content[i] == '\n' || content[i] == '\r')) {
      return null; // Unterminated single-line string.
    }
    value.write(content[i]);
    i++;
  }
  return null;
}
