// A dependency free scanner for the UI completeness rules in the
// elattar-flutter-ui-director skill.
//
// Run it from the project root:
//
//   dart run skills/elattar-flutter-ui-director/scripts/check_ui_completeness.dart
//   dart run .../check_ui_completeness.dart lib/features   # explicit targets
//
// It reads text, not an AST, so it is fast, has no dependencies, and is
// deliberately conservative. It catches the mechanical failures that ship most
// often. It cannot judge copy, hierarchy, or whether a state is correct: the
// checklists in the skill's references cover those.
//
// Exit code 0 when clean, 1 when anything is found, 2 on a usage error.

import 'dart:io';

/// Substrings of paths to skip, from `--exclude=<substring>`.
final List<String> _userExcludes = <String>[];

void main(List<String> args) {
  final List<String> targets = args.where((String a) => !a.startsWith('-')).toList();
  final bool listRules = args.contains('--rules');

  for (final String arg in args.where((String a) => a.startsWith('--exclude='))) {
    _userExcludes.add(arg.substring('--exclude='.length).replaceAll(r'\', '/'));
  }

  if (listRules) {
    for (final _Rule rule in _rules) {
      stdout.writeln('${rule.id}  ${rule.summary}');
    }
    exit(0);
  }

  final List<Directory> roots = targets.isEmpty
      ? _defaultRoots()
      : targets.map((String t) => Directory(t)).toList();

  final List<Directory> missing =
      roots.where((Directory d) => !d.existsSync()).toList();
  if (missing.isNotEmpty) {
    stderr.writeln('No such directory: ${missing.map((Directory d) => d.path).join(', ')}');
    exit(2);
  }

  final List<_Finding> findings = <_Finding>[];
  int scanned = 0;

  for (final Directory root in roots) {
    for (final FileSystemEntity entity in root.listSync(recursive: true)) {
      if (entity is! File) continue;
      if (!entity.path.endsWith('.dart')) continue;
      if (_isExcluded(entity.path)) continue;
      scanned++;
      findings.addAll(_scan(entity));
    }
  }

  _report(findings, scanned, roots);
  exit(findings.isEmpty ? 0 : 1);
}

/// Product code only. System sources own the literals the rules forbid, and
/// generated code is not written by hand.
bool _isExcluded(String path) {
  final String p = path.replaceAll(r'\', '/');
  const List<String> skip = <String>[
    '/components/ui/',
    '/design_system/',
    '/lib/src/',
    '/.dart_tool/',
    '/build/',
    '/registry/',
    '/generated/',
  ];
  if (skip.any(p.contains)) return true;
  if (_userExcludes.any(p.contains)) return true;
  return p.endsWith('.g.dart') ||
      p.endsWith('.freezed.dart') ||
      p.endsWith('_test.dart');
}

/// Repository mode ships the system in `lib/`, so product code is `example/lib`.
/// A consumer app keeps product code in its own `lib/`, minus the installed
/// directories, which `_isExcluded` already removes.
List<Directory> _defaultRoots() {
  if (File('lib/elattar_design_system.dart').existsSync()) {
    final Directory example = Directory('example/lib');
    if (example.existsSync()) return <Directory>[example];
  }
  return <Directory>[Directory('lib')];
}

class _Rule {
  const _Rule(this.id, this.summary, this.reference);
  final String id;
  final String summary;
  final String reference;
}

const List<_Rule> _rules = <_Rule>[
  _Rule('raw-error', 'An exception reaches user copy', 'references/errors.md'),
  _Rule('no-loading', 'Awaited work with no loading state in the file', 'references/states.md'),
  _Rule('no-empty', 'A collection is rendered with no empty branch', 'references/states.md'),
  _Rule('dead-press', 'A trigger whose handler does nothing', 'references/feedback.md'),
  _Rule('unlabelled-icon', 'An icon only control with no label', 'references/accessibility.md'),
  _Rule('raw-token', 'A visual literal outside the foundation', 'references/theming.md'),
  _Rule('parallel-theme', 'Theme.of used as a second visual system', 'references/theming.md'),
  _Rule('copy', 'Copy that leaks jargon or a placeholder', 'references/copy.md'),
];

class _Finding {
  _Finding(this.rule, this.path, this.line, this.text);
  final String rule;
  final String path;
  final int line;
  final String text;
}

final RegExp _errorIdentifier = RegExp(
  r'\b(e|err|error|ex|exception|failure|stack|stackTrace)\b',
);
final RegExp _userCopySlot = RegExp(
  r'\b(Text|StyledText|EmptyTitle|EmptyDescription|CardTitle|CardDescription|'
  r'AlertDialogTitle|AlertDialogDescription)\s*\(|'
  r'\b(title|description|label|message|hint|placeholder)\s*:',
);
final RegExp _deadHandler = RegExp(
  r'\b(onPressed|onTap|onChanged|onSubmitted|onSelected)\s*:\s*'
  r'(\(\s*[\w,\s]*\)\s*\{\s*\}|\(\s*[\w,\s]*\)\s*=>\s*(null|\{\s*\})\s*[,)])',
);
final RegExp _rawColor = RegExp(r'\bColor\(0x|\bColors\.[a-zA-Z]');
final RegExp _rawType = RegExp(
  r'\b(fontSize|fontWeight|letterSpacing|height)\s*:\s*(FontWeight\.|[\d.]+)',
);
final RegExp _rawMotion = RegExp(r'\bDuration\(|\bCurves\.[a-zA-Z]');
final RegExp _rawRadius = RegExp(r'BorderRadius\.circular\(\s*[\d.]+\s*\)');
final RegExp _boxShadow = RegExp(r'\bBoxShadow\(');
final RegExp _themeOf = RegExp(r'\bTheme\.of\(|\bThemeData\(');
final RegExp _badCopy = RegExp(
  '''(["'])\\s*(Oops|Uh oh|Whoops|Error:|Exception|Something went wrong!|'''
  '''undefined|NaN)''',
  caseSensitive: false,
);
final RegExp _pleaseCopy = RegExp('''(["'])[^"']*\\bPlease\\b''');
final RegExp _collectionRender = RegExp(
  r'\bListView\.(builder|separated)\(|\bGridView\.builder\(|'
  r'\.map\(\s*\(|\bfor\s*\(\s*final\b',
);
/// A loop over `SomeEnum.values` is a compile time list. It has no empty case
/// to handle, so it must not count as rendering a collection.
final RegExp _enumValuesLoop = RegExp(r'\bfor\s*\([^)]*\bin\s+\w+\.values\b');
final RegExp _emptyHandled = RegExp(
  r'\bisEmpty\b|\bisNotEmpty\b|\bEmpty\(|\bUiEmpty\b|\bUiNoResults\b|'
  r'\bEmptyTitle\b|\borElse\b',
);
final RegExp _asyncWork = RegExp(r'\bawait\b|\bFutureBuilder\b|\bStreamBuilder\b');
final RegExp _dataShape = RegExp(
  r'\bUiState\b|\bAsyncValue\b|\bFuture<|\bStream<|\brepository\b|\bBloc\b',
);
final RegExp _loadingHandled = RegExp(
  r'\bSkeleton\b|\bSpinner\b|\bProgress\b|\bUiLoading\b|\bUiRefreshing\b|'
  r'\bloading\b|\bisBusy\b|\bsubmitting\b|\bConnectionState\b',
);
final RegExp _control = RegExp(r'\b(Button|IconButton|Toggle|Tooltip)\s*\(');
final RegExp _iconChild = RegExp(r'\bIcon\s*\(|\bglyph\s*:');
final RegExp _hasLabel = RegExp(
  r'\blabel\s*:|\bsemanticsLabel\s*:|\bSemantics\s*\(|\bTooltip\s*\(',
);
/// A file is UI when it actually builds widgets. Importing the design system
/// for one token does not make a data layer a widget layer, and scanning it
/// for loading states produces nothing but noise.
final RegExp _isWidgetFile = RegExp(
  r'Widget\s+build\s*\(|'
  r'extends\s+(StatelessWidget|StatefulWidget|InheritedWidget)|'
  r'extends\s+State<',
);

/// A file carrying `// ui-check: ignore-file` is skipped. A line carrying
/// `// ui-check: ignore` reports nothing. Use both sparingly, and say why.
const String _ignoreFile = 'ui-check: ignore-file';
const String _ignoreLine = 'ui-check: ignore';

List<_Finding> _scan(File file) {
  final String source = file.readAsStringSync();
  if (!_isWidgetFile.hasMatch(source)) return const <_Finding>[];
  if (source.contains(_ignoreFile)) return const <_Finding>[];

  final List<String> lines = source.split('\n');
  final String path = file.path.replaceAll(r'\', '/');
  final List<_Finding> out = <_Finding>[];

  void add(String rule, int index, String text) {
    if (index >= 0 && index < lines.length && lines[index].contains(_ignoreLine)) {
      return;
    }
    out.add(_Finding(rule, path, index + 1, text.trim()));
  }

  for (int i = 0; i < lines.length; i++) {
    final String line = lines[i];
    final String code = _stripComment(line);
    if (code.trim().isEmpty) continue;

    // An exception, formatted into something a person reads.
    final bool formatsError = code.contains('.toString()') ||
        RegExp(r'\$\{?(e|err|error|ex|exception)\b').hasMatch(code);
    if (formatsError &&
        _errorIdentifier.hasMatch(code) &&
        _userCopySlot.hasMatch(code)) {
      add('raw-error', i, line);
    }

    if (_deadHandler.hasMatch(code)) add('dead-press', i, line);

    if (_rawColor.hasMatch(code) ||
        _rawType.hasMatch(code) ||
        _rawMotion.hasMatch(code) ||
        _rawRadius.hasMatch(code) ||
        _boxShadow.hasMatch(code)) {
      add('raw-token', i, line);
    }

    if (_themeOf.hasMatch(code)) add('parallel-theme', i, line);

    if (_badCopy.hasMatch(code) || _pleaseCopy.hasMatch(code)) {
      add('copy', i, line);
    }
  }

  // File level heuristics. They ask whether the file handles the state at all,
  // which is the failure that actually ships.
  final String code = _stripComments(source);

  if (_asyncWork.hasMatch(code) && !_loadingHandled.hasMatch(code)) {
    add('no-loading', _firstLineOf(lines, _asyncWork), 'awaited work here');
  }

  // Only for files that render data. A specimen iterating a compile time list
  // has no empty case to handle.
  final bool rendersData = _asyncWork.hasMatch(code) || _dataShape.hasMatch(code);
  final String withoutEnumLoops = code.replaceAll(_enumValuesLoop, '');
  if (rendersData &&
      _collectionRender.hasMatch(withoutEnumLoops) &&
      !_emptyHandled.hasMatch(code)) {
    add('no-empty', _firstLineOf(lines, _collectionRender), 'collection rendered here');
  }

  for (final RegExpMatch match in _control.allMatches(code)) {
    final String call = _callTextAt(code, match.start);
    if (!_iconChild.hasMatch(call)) continue;
    if (_hasLabel.hasMatch(call)) continue;
    // A control with a visible text child is not icon only.
    if (RegExp(r'\bStyledText\s*\(|\bText\s*\(').hasMatch(call)) continue;
    final int line = '\n'.allMatches(code.substring(0, match.start)).length;
    add('unlabelled-icon', line, call.split('\n').first.trim());
  }

  return out;
}

int _firstLineOf(List<String> lines, RegExp pattern) {
  for (int i = 0; i < lines.length; i++) {
    if (pattern.hasMatch(_stripComment(lines[i]))) return i;
  }
  return 0;
}

/// The text of a call starting at [start], to its matching parenthesis or a
/// sane cap, whichever comes first.
String _callTextAt(String source, int start) {
  int depth = 0;
  final int cap = start + 800 < source.length ? start + 800 : source.length;
  for (int i = start; i < cap; i++) {
    final String c = source[i];
    if (c == '(') depth++;
    if (c == ')') {
      depth--;
      if (depth == 0) return source.substring(start, i + 1);
    }
  }
  return source.substring(start, cap);
}

String _stripComment(String line) {
  final int i = line.indexOf('//');
  if (i < 0) return line;
  // Do not cut inside a string that contains a URL.
  final String before = line.substring(0, i);
  final int quotes = "'".allMatches(before).length + '"'.allMatches(before).length;
  return quotes.isEven ? before : line;
}

String _stripComments(String source) =>
    source.split('\n').map(_stripComment).join('\n');

void _report(List<_Finding> findings, int scanned, List<Directory> roots) {
  final String where = roots.map((Directory d) => d.path).join(', ');
  if (findings.isEmpty) {
    stdout.writeln('UI completeness: $scanned files in $where, nothing found.');
    return;
  }

  final Map<String, List<_Finding>> byRule = <String, List<_Finding>>{};
  for (final _Finding f in findings) {
    byRule.putIfAbsent(f.rule, () => <_Finding>[]).add(f);
  }

  stdout.writeln('UI completeness: ${findings.length} findings in $scanned files ($where)');
  for (final _Rule rule in _rules) {
    final List<_Finding>? hits = byRule[rule.id];
    if (hits == null) continue;
    stdout.writeln('');
    stdout.writeln('${rule.id} (${hits.length})  ${rule.summary}');
    stdout.writeln('  see skills/elattar-flutter-ui-director/${rule.reference}');
    for (final _Finding f in hits) {
      final String text =
          f.text.length > 100 ? '${f.text.substring(0, 100)}...' : f.text;
      stdout.writeln('  ${f.path}:${f.line}  $text');
    }
  }
  stdout.writeln('');
  stdout.writeln('These are heuristics. Fix them, or say in the handoff why each one is wrong.');
}
