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
    final RegExp block = RegExp(
      r'(?ms)^flutter:\s*\n((?:(?!^[A-Za-z0-9_]+:).)*)(?=^[A-Za-z0-9_]+:|(?![\s\S]))',
    );
    final Match? match = block.firstMatch(source);
    if (match == null)
      return '$source\nflutter:\n  assets:\n${additions.map((String v) => '    - $v\n').join()}';
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

  String addFonts(
    String source,
    Iterable<({String family, String asset})> fonts,
  ) {
    final List<({String family, String asset})> additions = fonts
        .where(
          (({String family, String asset}) value) =>
              !source.contains('    - asset: ${value.asset}'),
        )
        .toList();
    if (additions.isEmpty) return source;
    final String block = additions
        .map(
          (({String family, String asset}) value) =>
              '    - family: ${value.family}\n      fonts:\n        - asset: ${value.asset}\n',
        )
        .join();
    final int flutter = _topLevelOffset(source, 'flutter');
    if (flutter < 0) return '$source\nflutter:\n  fonts:\n$block';
    final int insert = _sectionInsert(source, flutter);
    return source.substring(0, insert) +
        '  fonts:\n$block' +
        source.substring(insert);
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

  static int _topLevelOffset(String source, String key) =>
      source.indexOf(RegExp('^${RegExp.escape(key)}:', multiLine: true));

  static int _sectionEnd(String body, String header) {
    final int start = body.indexOf(header);
    if (start < 0) return body.length;
    final RegExp next = RegExp(r'^  [A-Za-z0-9_]+:', multiLine: true);
    final Match? match = next.firstMatch(body.substring(start + header.length));
    return match == null ? body.length : start + header.length + match.start;
  }

  static int _sectionInsert(String source, int topLevelStart) {
    final Match? next = RegExp(
      r'^\S[^\n]*:',
      multiLine: true,
    ).firstMatch(source.substring(topLevelStart + 8));
    return next == null ? source.length : topLevelStart + 8 + next.start;
  }
}
