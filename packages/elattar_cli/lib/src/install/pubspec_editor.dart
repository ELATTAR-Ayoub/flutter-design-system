import 'models.dart';

/// The `flutter:` top-level block and its body, up to the next top-level key.
///
/// Written with real `multiLine`/`dotAll` flags rather than an inline `(?ms)`
/// prefix: Dart's `RegExp` is V8-backed and rejects inline modifier groups
/// with `FormatException: Invalid group`, so the inline form throws the moment
/// it is constructed.
final RegExp _flutterBlock = RegExp(
  r'^flutter:\s*\n((?:(?!^[A-Za-z0-9_]+:).)*)(?=^[A-Za-z0-9_]+:|(?![\s\S]))',
  multiLine: true,
  dotAll: true,
);

class PubspecEditor {
  const PubspecEditor();

  String addDependencies(String source, Map<String, String> dependencies) {
    String result = source;
    for (final MapEntry<String, String> entry in dependencies.entries) {
      if (_hasTopLevelKey(result, entry.key)) continue;
      result = _insertDependency(result, entry.key, entry.value);
    }
    return result;
  }

  String addAssets(String source, Iterable<String> assets) {
    final List<String> additions = assets
        .where((String value) => value.trim().isNotEmpty)
        .where((String value) => !source.contains('    - $value'))
        .toList();
    if (additions.isEmpty) return source;
    final Match? match = _flutterBlock.firstMatch(source);
    if (match == null) {
      return '$source\nflutter:\n  assets:\n${additions.map((String v) => '    - $v\n').join()}';
    }
    final String body = match.group(1) ?? '';
    if (body.contains(RegExp(r'^  assets:\s*$', multiLine: true))) {
      final int end = _sectionEnd(body, '  assets:');
      final String updated =
          '${body.substring(0, end)}${additions.map((String v) => '    - $v\n').join()}${body.substring(end)}';
      return source.replaceRange(match.start, match.end, 'flutter:\n$updated');
    }
    return source.replaceRange(
      match.start,
      match.end,
      'flutter:\n$body  assets:\n${additions.map((String v) => '    - $v\n').join()}',
    );
  }

  /// Declares [fonts] under `flutter: fonts:`, merging into an existing
  /// section rather than emitting a second `fonts:` key, and grouping the
  /// faces of one family under a single `- family:` entry.
  String addFonts(String source, Iterable<FontRegistration> fonts) {
    final List<FontRegistration> additions = fonts
        .where(
          (FontRegistration value) =>
              !source.contains('- asset: ${value.asset}'),
        )
        .toList();
    if (additions.isEmpty) return source;
    final String block = _fontsBlock(additions);
    final Match? match = _flutterBlock.firstMatch(source);
    if (match == null) return '$source\nflutter:\n  fonts:\n$block';
    final String body = match.group(1) ?? '';
    if (body.contains(RegExp(r'^  fonts:\s*$', multiLine: true))) {
      final int end = _sectionEnd(body, '  fonts:');
      final String updated =
          '${body.substring(0, end)}$block${body.substring(end)}';
      return source.replaceRange(match.start, match.end, 'flutter:\n$updated');
    }
    return source.replaceRange(
      match.start,
      match.end,
      'flutter:\n$body  fonts:\n$block',
    );
  }

  String addShaders(String source, Iterable<String> shaders) {
    final List<String> additions = shaders
        .where((String value) => value.trim().isNotEmpty)
        .where((String value) => !source.contains('    - $value'))
        .toList();
    if (additions.isEmpty) return source;
    final Match? match = _flutterBlock.firstMatch(source);
    if (match == null) {
      return '$source\nflutter:\n  shaders:\n${additions.map((String v) => '    - $v\n').join()}';
    }
    final String body = match.group(1) ?? '';
    if (body.contains(RegExp(r'^  shaders:\s*$', multiLine: true))) {
      final int end = _sectionEnd(body, '  shaders:');
      final String updated =
          '${body.substring(0, end)}${additions.map((String v) => '    - $v\n').join()}${body.substring(end)}';
      return source.replaceRange(match.start, match.end, 'flutter:\n$updated');
    }
    return source.replaceRange(
      match.start,
      match.end,
      'flutter:\n$body  shaders:\n${additions.map((String v) => '    - $v\n').join()}',
    );
  }

  /// One `- family:` entry per family, in first-seen order, with every face of
  /// that family beneath it. Two `- family:` entries with the same name are a
  /// duplicate key that `flutter_tools` resolves by keeping only one.
  static String _fontsBlock(List<FontRegistration> fonts) {
    final Map<String, List<FontRegistration>> byFamily =
        <String, List<FontRegistration>>{};
    for (final FontRegistration font in fonts) {
      byFamily.putIfAbsent(font.family, () => <FontRegistration>[]).add(font);
    }
    final StringBuffer out = StringBuffer();
    for (final MapEntry<String, List<FontRegistration>> entry
        in byFamily.entries) {
      out
        ..writeln('    - family: ${entry.key}')
        ..writeln('      fonts:');
      for (final FontRegistration font in entry.value) {
        out.writeln('        - asset: ${font.asset}');
        if (font.style case final String style) {
          out.writeln('          style: $style');
        }
      }
    }
    return out.toString();
  }

  String _insertDependency(String source, String name, String constraint) {
    final List<String> lines = source.split('\n');
    final int header = lines.indexWhere(
      (String line) => line.trim() == 'dependencies:',
    );
    if (header < 0) return 'dependencies:\n  $name: $constraint\n$source';
    int insert = header + 1;
    while (insert < lines.length &&
        (lines[insert].isEmpty ||
            lines[insert].startsWith(' ') ||
            lines[insert].startsWith('\t') ||
            lines[insert].trimLeft().startsWith('#'))) {
      insert++;
    }
    lines.insert(insert, '  $name: $constraint');
    return lines.join('\n');
  }

  static bool _hasTopLevelKey(String source, String key) =>
      RegExp('^  ${RegExp.escape(key)}:', multiLine: true).hasMatch(source);

  static int _sectionEnd(String body, String header) {
    final int start = body.indexOf(header);
    if (start < 0) return body.length;
    final RegExp next = RegExp(r'^  [A-Za-z0-9_]+:', multiLine: true);
    final Match? match = next.firstMatch(body.substring(start + header.length));
    return match == null ? body.length : start + header.length + match.start;
  }
}
