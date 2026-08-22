/// The mechanical half of "product-neutral" (Phase G, ruling 4).
///
/// The prose gate is not machine-checkable, so it is replaced by three checks
/// over `example/lib/shots/**` — the installable half of a Shot, the files the
/// generator hashes and the CLI copies into a consumer project:
///
/// 1. **No parallel styling.** The same banned-pattern sweep
///    `showcase_source_guard_test.dart` runs over Signal Studio: no Flutter
///    theme, no raw colour, no bare `Text`, no hardcoded layout number. A Shot
///    consumes the design system; it does not restyle Flutter beside it.
/// 2. **Nothing outside the seventeen.** The registry holds seventeen items.
///    A Shot that names a symbol reachable only from something else compiles
///    here — the example app depends on the whole package — and fails in the
///    consumer project that installed it, where only the dependency closure
///    exists. That failure is invisible to every other test in the repo, so it
///    is caught here by name.
/// 3. **One exact umbrella import.** The CLI's import transformer rewrites
///    `package:elattar_design_system/elattar_design_system.dart` into the
///    consumer's generated barrels, and throws on a prefix or a combinator —
///    a filtered umbrella cannot be split across two barrels without changing
///    what resolves.
/// 4. **Every `Ds*` symbol traces to a declared dependency.** Ruling 4's
///    second half, and the only one of the four that is about *this* Shot
///    rather than about Shots in general: the closure is read out of the
///    Shot's own manifest and the symbol table out of the package sources
///    those manifests point at, so nothing is hand-maintained and nothing goes
///    stale. It is the check that catches a symbol which compiles here — the
///    example app depends on the whole package — and is missing in the project
///    that installed the Shot.
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// The installable compositions, and nothing from `shots_docs/`.
List<File> _shotSources() => Directory('lib/shots')
    .listSync(recursive: true)
    .whereType<File>()
    .where((File file) => file.path.endsWith('.dart'))
    .toList()
  ..sort((File a, File b) => a.path.compareTo(b.path));

/// The one import form the transformer accepts.
const String _umbrella =
    "import 'package:elattar_design_system/elattar_design_system.dart';";

/// Any import of the package, however spelled.
final RegExp _packageImport = RegExp(
  r'''^\s*import\s+['"]package:elattar_design_system/[^'"]*['"].*$''',
);

/// Symbols that exist in this repository but are **not** reachable from the
/// seventeen registry items.
///
/// The first four are the example app's own kit — they live in
/// `example/lib/kit.dart` and were never part of the package at all. The rest
/// are real package components that simply have no manifest yet: installing a
/// Shot that used one would copy a file that references a file the registry
/// never delivers.
const Map<String, String> _unreachable = <String, String>{
  'DsGrid': 'example app kit, not the package',
  'DsPageHeader': 'example app kit, not the package',
  'DsSection': 'example app kit, not the package',
  'DsPanel': 'example app kit, not the package',
  'DsBadge': 'a component, but not a registry item',
  'DsSeparator': 'a component, but not a registry item',
  'DsTable': 'a component, but not a registry item',
  'DsAvatar': 'a component, but not a registry item',
  'DsTabs': 'a component, but not a registry item',
  'DsTextarea': 'a component, but not a registry item',
};

/// The repository root, from the example package the suite runs in.
Directory get _root => Directory('..');

String _rooted(String relative) => '${_root.path}/$relative';

/// Every registry manifest, by item name.
Map<String, Map<String, Object?>> _manifests() {
  final Map<String, Map<String, Object?>> items =
      <String, Map<String, Object?>>{};
  for (final String folder in <String>[
    'foundations',
    'components',
    'effects',
    'motion',
    'shots',
  ]) {
    final Directory directory = Directory(_rooted('registry/$folder'));
    if (!directory.existsSync()) continue;
    for (final File file in directory
        .listSync(recursive: true)
        .whereType<File>()
        .where((File file) => file.path.endsWith('.json'))) {
      final Map<String, Object?> json =
          jsonDecode(file.readAsStringSync()) as Map<String, Object?>;
      items[json['name']! as String] = json;
    }
  }
  return items;
}

List<String> _strings(Map<String, Object?> json, String key) =>
    <String>[for (final Object? value in json[key]! as List<Object?>) value! as String];

/// [name] and everything it pulls in, transitively.
Set<String> _closure(String name, Map<String, Map<String, Object?>> items) {
  final Set<String> seen = <String>{};
  void walk(String current) {
    if (!seen.add(current)) return;
    final Map<String, Object?>? item = items[current];
    if (item == null) return;
    for (final String dependency in _strings(item, 'registryDependencies')) {
      walk(dependency);
    }
  }

  walk(name);
  return seen;
}

/// Top-level `Ds*` declarations in a package source file.
final RegExp _declaration = RegExp(
  r'^(?:abstract\s+|sealed\s+|base\s+|final\s+|interface\s+)*'
  r'(?:class|enum|mixin|typedef|extension\s+type)\s+(Ds[A-Z]\w*)',
  multiLine: true,
);

/// A `Ds*` symbol as a Shot names it.
///
/// `Ds` alone is excluded — a docstring writing `Ds*` is prose, not a
/// reference — and so is the lowercase `ds()` spacing helper, which is a
/// function rather than a type and belongs to the foundation every Shot
/// declares anyway.
final RegExp _reference = RegExp(r'\bDs[A-Z]\w*');

/// The source with its comments removed, so a docstring naming a symbol the
/// Shot does not use cannot fail the trace.
String _code(String source) => source
    .replaceAll(RegExp(r'/\*.*?\*/', dotAll: true), '')
    .split('\n')
    .map((String line) {
      final int marker = line.indexOf('//');
      return marker < 0 ? line : line.substring(0, marker);
    })
    .join('\n');

void main() {
  test('Shots consume the design system instead of restyling Flutter', () {
    final List<File> files = _shotSources();
    expect(files, isNotEmpty, reason: 'No Shot sources were found.');

    final Map<String, RegExp> banned = <String, RegExp>{
      'parallel Flutter theme': RegExp(r'\bTheme\.of\('),
      'raw Material color': RegExp(r'\bColors\.'),
      'raw color constructor': RegExp(r'\bColor(?:\.from\w+)?\('),
      'raw text widget': RegExp(r'(^|[^A-Za-z])Text\('),
      'raw text style': RegExp(r'\bTextStyle\('),
      'raw icon widget': RegExp(r'(^|[^A-Za-z])Icon\('),
      'Material feedback': RegExp(r'\b(?:SnackBar|ScaffoldMessenger)\b'),
      'Material progress': RegExp(r'\bCircularProgressIndicator\b'),
      'Material page surface': RegExp(r'\b(?:Scaffold|Material)\('),
      'raw shadow': RegExp(r'\bBoxShadow\('),
      'raw duration': RegExp(r'\bDuration\('),
      'stock curve': RegExp(r'\bCurves\.'),
      'custom alpha': RegExp(r'\.withValues\(\s*alpha\s*:'),
      'custom gradient': RegExp(r'\b(?:Linear|Radial|Sweep)Gradient\('),
      'direct numeric layout': RegExp(
        r'\b(?:width|height|top|right|bottom|left|padding|spacing|runSpacing|'
        r'maxWidth|minWidth|maxHeight|minHeight|radius|opacity|fillOpacity|'
        r'strokeWidth|tickMargin|flex)\s*:\s*-?(?:[1-9]\d*|0\.\d+)',
      ),
    };

    final List<String> violations = <String>[];
    for (final File file in files) {
      final List<String> lines = file.readAsLinesSync();
      for (int index = 0; index < lines.length; index++) {
        final String line = lines[index];
        for (final MapEntry<String, RegExp> rule in banned.entries) {
          if (rule.value.hasMatch(line)) {
            violations.add(
              '${file.path}:${index + 1} [${rule.key}] ${line.trim()}',
            );
          }
        }
      }
    }

    expect(
      violations,
      isEmpty,
      reason:
          'A Shot must use public Ds* components and tokens.\n'
          '${violations.join('\n')}',
    );
  });

  test('Shots name nothing outside the seventeen registry items', () {
    final List<File> files = _shotSources();
    expect(files, isNotEmpty, reason: 'No Shot sources were found.');

    final List<String> violations = <String>[];
    for (final File file in files) {
      final List<String> lines = file.readAsLinesSync();
      for (int index = 0; index < lines.length; index++) {
        final String line = lines[index];
        for (final MapEntry<String, String> entry in _unreachable.entries) {
          if (RegExp('\\b${entry.key}\\b').hasMatch(line)) {
            violations.add(
              '${file.path}:${index + 1} [${entry.key} — ${entry.value}] '
              '${line.trim()}',
            );
          }
        }
      }
    }

    expect(
      violations,
      isEmpty,
      reason:
          'A Shot may only use symbols reachable from registry items that '
          'exist. Simplify the composition rather than adding a registry '
          'item.\n${violations.join('\n')}',
    );
  });

  test('every Shot imports the umbrella with no prefix and no combinator', () {
    final List<File> files = _shotSources();
    expect(files, isNotEmpty, reason: 'No Shot sources were found.');

    for (final File file in files) {
      final List<String> imports = file
          .readAsLinesSync()
          .where(_packageImport.hasMatch)
          .toList();

      expect(
        imports,
        hasLength(1),
        reason:
            '${file.path} must import the design system exactly once, through '
            'the umbrella library.',
      );
      expect(
        imports.single.trim(),
        _umbrella,
        reason:
            '${file.path} must import the umbrella verbatim. The CLI\'s import '
            'transformer throws on "as", "show" and "hide": a prefixed or '
            'filtered umbrella cannot be split across the consumer\'s two '
            'generated barrels without changing what resolves.',
      );
    }
  });

  test('every Ds* symbol a Shot names traces to a declared dependency', () {
    final Map<String, Map<String, Object?>> items = _manifests();
    expect(items, isNotEmpty, reason: 'No registry manifests were found.');

    final List<Map<String, Object?>> shots = items.values
        .where((Map<String, Object?> item) => item['type'] == 'shot')
        .toList()
      ..sort(
        (Map<String, Object?> a, Map<String, Object?> b) =>
            (a['name']! as String).compareTo(b['name']! as String),
      );
    expect(shots, isNotEmpty, reason: 'No Shot manifests were found.');

    // Every Shot source is claimed by exactly one manifest — an unhashed file
    // under `lib/shots/` would ship to nobody and be checked by nothing.
    final Set<String> claimed = <String>{
      for (final Map<String, Object?> shot in shots)
        for (final Object? file in shot['files']! as List<Object?>)
          ((file! as Map<String, Object?>)['source']! as String).split('/').last,
    };
    for (final File file in _shotSources()) {
      expect(
        claimed,
        contains(file.uri.pathSegments.last),
        reason: '${file.path} is not declared by any registry/shots manifest.',
      );
    }

    final List<String> violations = <String>[];
    for (final Map<String, Object?> shot in shots) {
      final String name = shot['name']! as String;

      // The symbol table, read out of the sources the closure's own manifests
      // point at. Nothing here is a hand-maintained list.
      final Set<String> provided = <String>{};
      for (final String dependency in _closure(name, items)) {
        if (dependency == name) continue;
        for (final Object? entry
            in items[dependency]!['files']! as List<Object?>) {
          final String source =
              (entry! as Map<String, Object?>)['source']! as String;
          final File file = File(_rooted(source));
          if (!file.existsSync()) continue;
          for (final RegExpMatch match in _declaration.allMatches(
            file.readAsStringSync(),
          )) {
            provided.add(match.group(1)!);
          }
        }
      }
      expect(
        provided,
        isNotEmpty,
        reason: '$name resolved an empty symbol table.',
      );

      for (final Object? entry in shot['files']! as List<Object?>) {
        final String source =
            (entry! as Map<String, Object?>)['source']! as String;
        final String code = _code(File(_rooted(source)).readAsStringSync());
        for (final String symbol
            in _reference.allMatches(code).map((RegExpMatch m) => m.group(0)!)) {
          if (provided.contains(symbol)) continue;
          violations.add(
            '$source names $symbol, which is not reachable from '
            "$name's declared dependencies "
            '(${_strings(shot, 'registryDependencies').join(', ')}).',
          );
        }
      }
    }

    expect(
      violations.toSet().toList()..sort(),
      isEmpty,
      reason:
          'A Shot compiles here because the example app depends on the whole '
          'package. In a consumer project only the dependency closure exists, '
          'so a symbol outside it is a build failure on install.\n'
          '${violations.toSet().join('\n')}',
    );
  });
}
