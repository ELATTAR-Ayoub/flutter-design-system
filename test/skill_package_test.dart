/// Verifies the `elattar-flutter-ui-director` skill package: one source of
/// truth, valid frontmatter, resolving internal links, accurate
/// this-repository claims, and correct plugin manifest wiring.
///
/// This is the machine-checkable half of the Phase H exit gate. It proves the
/// skill's own files are internally consistent and truthful about *this*
/// checkout. It cannot and does not invoke harness commands — `/plugin
/// marketplace add`, `/plugin install`, `/plugin update`, `/plugin
/// uninstall` — those need a recorded human run, tracked in
/// `docs/superpowers/reports/public-release/skill-install-verification.md`.
///
/// Frontmatter conformance (below) is re-implemented in Dart on purpose: a
/// shelled-out validator living in a machine-local plugin cache would not
/// exist on a CI runner, so it cannot be the thing that gates a release.
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:yaml/yaml.dart';

/// Directory names skipped while walking the repository for `SKILL.md`
/// files. Version control internals and build/tooling caches are never a
/// legitimate skill location, and `.git` in particular is large enough that
/// walking into it would slow the suite for no reason.
const Set<String> _walkDenylist = <String>{
  '.git',
  '.dart_tool',
  'build',
  '.idea',
  '.superpowers',
};

/// Repository root. `flutter test` always runs from the package root (the
/// directory holding `pubspec.yaml`), matching the convention already used by
/// `test/token_guard_test.dart` and `test/assets_test.dart`.
Directory get _repoRoot => Directory.current;

/// Recursively finds every file named [name] under [root], skipping
/// [_walkDenylist] directories.
List<File> _findFilesNamed(Directory root, String name) {
  final List<File> found = <File>[];

  void walk(Directory dir) {
    List<FileSystemEntity> entries;
    try {
      entries = dir.listSync(followLinks: false);
    } on FileSystemException {
      return;
    }
    for (final FileSystemEntity entity in entries) {
      final String baseName = entity.uri.pathSegments
          .where((String s) => s.isNotEmpty)
          .last;
      if (entity is Directory) {
        if (_walkDenylist.contains(baseName)) continue;
        walk(entity);
      } else if (entity is File && baseName == name) {
        found.add(entity);
      }
    }
  }

  walk(root);
  return found;
}

/// Parses a skill file's YAML frontmatter (the block between the opening and
/// closing `---` fences) into a plain map. Throws [FormatException] if the
/// fences are missing or the block does not parse as a YAML mapping — a
/// malformed skill file is a real failure, not something to swallow.
Map<String, dynamic> _parseFrontmatter(String content) {
  final List<String> lines = content.split('\n');
  if (lines.isEmpty || lines.first.trim() != '---') {
    throw const FormatException(
      'skill file must open with a `---` frontmatter fence on line 1',
    );
  }
  final int closeIndex = lines.indexWhere((String l) => l.trim() == '---', 1);
  if (closeIndex == -1) {
    throw const FormatException(
      'skill file frontmatter fence opened with `---` but never closed',
    );
  }
  final String yamlText = lines.sublist(1, closeIndex).join('\n');
  final dynamic doc = loadYaml(yamlText);
  if (doc is! YamlMap) {
    throw const FormatException('skill frontmatter is not a YAML mapping');
  }
  return doc.map(
    (dynamic k, dynamic v) => MapEntry<String, dynamic>(k.toString(), v),
  );
}

/// The single skill this repository is meant to publish. Used both as the
/// thing Test 1 counts and as the identity every later test cross-checks
/// against, so a rename shows up everywhere at once rather than only where
/// someone remembered to update a literal.
const String _skillName = 'elattar-flutter-ui-director';

/// Finds the one `SKILL.md` in the repository whose frontmatter declares
/// `name: $_skillName`. Throws with a descriptive message if there are zero
/// or more than one — callers that need the file (Tests 3-5) get a clear
/// failure instead of a null-dereference when Test 1's invariant is broken.
File _canonicalSkillFile() {
  final List<File> allSkillFiles = _findFilesNamed(_repoRoot, 'SKILL.md');
  final List<File> matches = <File>[];
  for (final File file in allSkillFiles) {
    final Map<String, dynamic> frontmatter;
    try {
      frontmatter = _parseFrontmatter(file.readAsStringSync());
    } on FormatException {
      continue; // unparsable frontmatter can't declare our name
    }
    if (frontmatter['name'] == _skillName) matches.add(file);
  }
  if (matches.length != 1) {
    throw StateError(
      'expected exactly one SKILL.md declaring name: $_skillName, found '
      '${matches.length}: ${matches.map((File f) => f.path).toList()} '
      '(all SKILL.md files on disk: '
      '${allSkillFiles.map((File f) => f.path).toList()})',
    );
  }
  return matches.single;
}

/// A path-like claim found inside a `--- | --- ---` markdown table cell or
/// prose line: the literal text, whether it was written about a *consumer*
/// project rather than this repository, and the source line for error
/// messages.
class _PathClaim {
  const _PathClaim(this.path, this.isConsumerClaim, this.lineNumber);

  final String path;
  final bool isConsumerClaim;
  final int lineNumber;
}

/// Loose filter for "this backtick span looks like a repository-relative
/// path", not a shell flag, a `El<Type>` generic, a `package:` import URI, or
/// prose. Deliberately conservative: false negatives just mean a claim isn't
/// checked, false positives would make the test fail on non-claims.
bool _looksLikeRepoPath(String token) {
  if (token.isEmpty || token.contains(' ')) return false;
  if (!token.contains('/')) return false;
  return RegExp(r'^[A-Za-z0-9_.\-/]+$').hasMatch(token);
}

Iterable<String> _codeSpanPaths(String cell) sync* {
  for (final RegExpMatch m in RegExp(r'`([^`]+)`').allMatches(cell)) {
    final String token = m.group(1)!;
    if (_looksLikeRepoPath(token)) yield token;
  }
}

List<String> _splitTableRow(String line) {
  String trimmed = line.trim();
  if (trimmed.startsWith('|')) trimmed = trimmed.substring(1);
  if (trimmed.endsWith('|')) {
    trimmed = trimmed.substring(0, trimmed.length - 1);
  }
  return trimmed.split('|').map((String c) => c.trim()).toList();
}

bool _isTableSeparatorRow(List<String> cells) =>
    cells.isNotEmpty &&
    cells.every((String c) => RegExp(r'^:?-+:?$').hasMatch(c));

/// Reads every backtick-quoted, path-shaped claim out of a reference file and
/// classifies each as about *this repository* or about a *consumer project*
/// (an app that installed the design system through the `elattar` CLI).
///
/// Three independent signals feed the classification, matching how
/// `system-map.md` actually authors the split (a `## Consumer mode` /
/// `## Repository mode` section pair, a `Step 0` probe table whose rows are
/// labelled `**Consumer mode**` / `**Repository mode**` inline, and a `Mode
/// translation table` whose columns are headed `Repository mode` /
/// `Consumer mode`). A claim is a consumer claim if *any* signal says so:
///
/// 1. It sits under a heading whose text contains "consumer mode" or
///    "consumer project".
/// 2. It sits in a table row whose text contains the bolded marker
///    `**consumer mode**` (case-insensitive) — the Step 0 probe table shape.
/// 3. It sits in a table column whose header cell contains "consumer" — the
///    mode-translation-table shape.
List<_PathClaim> _extractPathClaims(String content) {
  final List<_PathClaim> claims = <_PathClaim>[];
  final List<String> lines = content.split('\n');

  bool headingIsConsumer = false;
  bool inTable = false;
  List<String>? headerCells;

  for (int i = 0; i < lines.length; i++) {
    final String line = lines[i];

    final RegExpMatch? heading = RegExp(r'^#{1,6}\s+(.*)$').firstMatch(line);
    if (heading != null) {
      final String headingText = heading.group(1)!.toLowerCase();
      headingIsConsumer =
          headingText.contains('consumer mode') ||
          headingText.contains('consumer project');
      inTable = false;
      headerCells = null;
      continue;
    }

    if (line.trim().startsWith('|')) {
      final List<String> cells = _splitTableRow(line);
      if (!inTable) {
        headerCells = cells;
        inTable = true;
        continue;
      }
      if (_isTableSeparatorRow(cells)) continue;

      final bool rowHasConsumerMarker = line.toLowerCase().contains(
        '**consumer mode**',
      );
      for (int col = 0; col < cells.length; col++) {
        final bool columnIsConsumer =
            headerCells != null &&
            col < headerCells.length &&
            headerCells[col].toLowerCase().contains('consumer');
        final bool isConsumer =
            headingIsConsumer || rowHasConsumerMarker || columnIsConsumer;
        for (final String path in _codeSpanPaths(cells[col])) {
          claims.add(_PathClaim(path, isConsumer, i + 1));
        }
      }
      continue;
    }

    inTable = false;
    headerCells = null;
    for (final String path in _codeSpanPaths(line)) {
      claims.add(_PathClaim(path, headingIsConsumer, i + 1));
    }
  }

  return claims;
}

/// Does [relativePath] exist in this repository? Trailing `/` claims a
/// directory (the convention `system-map.md` uses throughout); otherwise
/// tries a file first, falling back to a directory for the rare bare-name
/// directory reference.
bool _repoPathExists(String relativePath) {
  final String full = '${_repoRoot.path}/$relativePath';
  if (relativePath.endsWith('/')) return Directory(full).existsSync();
  return File(full).existsSync() || Directory(full).existsSync();
}

/// Collapses `.`/`..` segments so `./skills/x` and `skills/x` compare equal
/// regardless of how a manifest wrote the relative path.
String _normalizeRelativePath(String raw) {
  final List<String> segments = <String>[];
  for (final String part in raw.split('/')) {
    if (part.isEmpty || part == '.') continue;
    if (part == '..') {
      if (segments.isNotEmpty) segments.removeLast();
      continue;
    }
    segments.add(part);
  }
  return segments.join('/');
}

void main() {
  group('Test 1 — one source of truth', () {
    test('exactly one SKILL.md declares name: $_skillName', () {
      final List<File> allSkillFiles = _findFilesNamed(_repoRoot, 'SKILL.md');
      final List<File> matches = <File>[];
      for (final File file in allSkillFiles) {
        Map<String, dynamic> frontmatter;
        try {
          frontmatter = _parseFrontmatter(file.readAsStringSync());
        } on FormatException {
          continue;
        }
        if (frontmatter['name'] == _skillName) matches.add(file);
      }

      expect(
        matches,
        hasLength(1),
        reason:
            'exactly one SKILL.md may declare `name: $_skillName` — '
            'a second copy under .agents/, .claude/skills/, or a '
            'generated output directory means the skill can drift from '
            'itself. Matches: ${matches.map((File f) => f.path).toList()}; '
            'all SKILL.md on disk: '
            '${allSkillFiles.map((File f) => f.path).toList()}',
      );
    });
  });

  group('Test 2 — frontmatter conformance', () {
    const Set<String> allowedKeys = <String>{
      'name',
      'description',
      'license',
      'allowed-tools',
      'metadata',
      'compatibility',
    };

    test('frontmatter parses and stays inside the documented shape', () {
      final File skillFile = _canonicalSkillFile();
      final Map<String, dynamic> frontmatter = _parseFrontmatter(
        skillFile.readAsStringSync(),
      );

      final Iterable<String> unknownKeys = frontmatter.keys.where(
        (String k) => !allowedKeys.contains(k),
      );
      expect(
        unknownKeys,
        isEmpty,
        reason:
            'frontmatter keys must be a subset of $allowedKeys, found '
            'unexpected: ${unknownKeys.toList()}',
      );

      expect(frontmatter['name'], isA<String>(), reason: '`name` is required');
      expect(
        frontmatter['description'],
        isA<String>(),
        reason: '`description` is required',
      );

      final String name = frontmatter['name'] as String;
      expect(
        name.length,
        lessThanOrEqualTo(64),
        reason: '`name` must be <= 64 chars, got ${name.length}',
      );
      expect(
        RegExp(r'^[a-z0-9]+(-[a-z0-9]+)*$').hasMatch(name),
        isTrue,
        reason: '`name` must be kebab-case, got "$name"',
      );

      final String description = frontmatter['description'] as String;
      expect(
        description.length,
        lessThanOrEqualTo(1024),
        reason:
            '`description` must be <= 1024 chars, got '
            '${description.length}',
      );
      expect(
        description.contains('<'),
        isFalse,
        reason: '`description` must not contain `<`',
      );
      expect(
        description.contains('>'),
        isFalse,
        reason: '`description` must not contain `>`',
      );
    });
  });

  group('Test 3 — the skill\'s own links resolve', () {
    test('every references/*.md link resolves and no reference is orphaned', () {
      final File skillFile = _canonicalSkillFile();
      final Directory skillDir = skillFile.parent;
      final String content = skillFile.readAsStringSync();

      final RegExp linkPattern = RegExp(r'\]\((references/[^)\s]+\.md)\)');
      final Set<String> linked = <String>{
        for (final RegExpMatch m in linkPattern.allMatches(content))
          m.group(1)!,
      };

      expect(
        linked,
        isNotEmpty,
        reason:
            'SKILL.md should link to at least one references/*.md '
            'file — found none, which means this pattern stopped '
            'matching the real markup',
      );

      for (final String relative in linked) {
        final File target = File('${skillDir.path}/$relative');
        expect(
          target.existsSync(),
          isTrue,
          reason:
              'SKILL.md links to `$relative` but that file does not '
              'exist at ${target.path}',
        );
      }

      final Directory referencesDir = Directory('${skillDir.path}/references');
      expect(referencesDir.existsSync(), isTrue);
      final Set<String> onDisk = <String>{
        for (final FileSystemEntity e in referencesDir.listSync())
          if (e is File)
            'references/${e.uri.pathSegments.where((String s) => s.isNotEmpty).last}',
      };

      final Set<String> orphaned = onDisk.difference(linked);
      expect(
        orphaned,
        isEmpty,
        reason:
            'reference files exist but are never linked from '
            'SKILL.md (renamed or added without being routed): $orphaned',
      );
    });
  });

  group('Test 4 — the skill\'s repo claims are still true', () {
    /// The paths the exit gate names explicitly. If `system-map.md` stops
    /// naming one of these as a this-repository source of truth, that is
    /// itself a regression worth a named failure, independent of the
    /// general claim scan below.
    const List<String> requiredThisRepoPaths = <String>[
      'lib/elattar_design_system.dart',
      'lib/src/foundation/',
      'lib/src/components/',
      'lib/src/theme_scope.dart',
      'test/token_guard_test.dart',
      'tool/verify/README.md',
    ];

    test('required this-repository paths are named and real', () {
      final File skillFile = _canonicalSkillFile();
      final File systemMap = File(
        '${skillFile.parent.path}/references/system-map.md',
      );
      expect(
        systemMap.existsSync(),
        isTrue,
        reason: 'references/system-map.md is missing',
      );

      final List<_PathClaim> claims = _extractPathClaims(
        systemMap.readAsStringSync(),
      );
      final Set<String> thisRepoPaths = <String>{
        for (final _PathClaim c in claims)
          if (!c.isConsumerClaim) c.path,
      };

      for (final String required in requiredThisRepoPaths) {
        expect(
          thisRepoPaths,
          contains(required),
          reason:
              'system-map.md should name `$required` as a '
              'this-repository source of truth (either it was removed, '
              'or it now only appears inside a consumer-mode section — '
              'both are regressions the skill must not ship silently)',
        );
        expect(
          _repoPathExists(required),
          isTrue,
          reason:
              'system-map.md claims `$required` exists in this '
              'repository, but it does not',
        );
      }
    });

    test('every this-repository path claim in system-map.md is real', () {
      final File skillFile = _canonicalSkillFile();
      final File systemMap = File(
        '${skillFile.parent.path}/references/system-map.md',
      );
      final List<_PathClaim> claims = _extractPathClaims(
        systemMap.readAsStringSync(),
      );

      final List<_PathClaim> thisRepoClaims = claims
          .where((_PathClaim c) => !c.isConsumerClaim)
          .toList();
      expect(
        thisRepoClaims,
        isNotEmpty,
        reason:
            'found no this-repository path claims at all — the '
            'consumer/repository classifier likely stopped matching the '
            'real markup shape',
      );

      final List<String> stale = <String>[];
      for (final _PathClaim claim in thisRepoClaims) {
        if (!_repoPathExists(claim.path)) {
          stale.add('line ${claim.lineNumber}: `${claim.path}`');
        }
      }
      expect(
        stale,
        isEmpty,
        reason:
            'system-map.md names these as this-repository paths, but '
            'none of them exist on disk — a stale skill silently '
            'misleads every agent that loads it:\n${stale.join('\n')}',
      );
    });

    test('consumer-mode paths are not asserted against this repository', () {
      // Sanity check on the classifier itself, not the skill content: a
      // consumer-only path such as `lib/components/ui/` genuinely does not
      // exist here, and the previous two tests must not have flagged it.
      final File skillFile = _canonicalSkillFile();
      final File systemMap = File(
        '${skillFile.parent.path}/references/system-map.md',
      );
      final List<_PathClaim> claims = _extractPathClaims(
        systemMap.readAsStringSync(),
      );
      final Set<String> consumerPaths = <String>{
        for (final _PathClaim c in claims)
          if (c.isConsumerClaim) c.path,
      };
      // If system-map.md has not yet grown a consumer-mode section this is
      // vacuously true and the test still passes — it only ever fails when
      // the classifier mis-sorts a real consumer path into the repo bucket.
      expect(
        consumerPaths.intersection(requiredThisRepoPaths.toSet()),
        isEmpty,
        reason:
            'a this-repository required path was classified as a '
            'consumer-mode claim, which would silently exempt it from '
            'existence checking',
      );
    });
  });

  group('Test 5 — plugin manifest wiring', () {
    test(
      'marketplace.json and plugin.json resolve to the canonical SKILL.md',
      () {
        final File marketplaceFile = File('.claude-plugin/marketplace.json');
        final File pluginFile = File('.claude-plugin/plugin.json');
        expect(
          marketplaceFile.existsSync(),
          isTrue,
          reason:
              '.claude-plugin/marketplace.json is required for '
              '`/plugin marketplace add` to find this repository',
        );
        expect(
          pluginFile.existsSync(),
          isTrue,
          reason:
              '.claude-plugin/plugin.json is required for '
              '`/plugin install` to work',
        );

        final Map<String, dynamic> marketplace =
            jsonDecode(marketplaceFile.readAsStringSync())
                as Map<String, dynamic>;
        final Map<String, dynamic> plugin =
            jsonDecode(pluginFile.readAsStringSync()) as Map<String, dynamic>;

        final List<dynamic> plugins = marketplace['plugins'] as List<dynamic>;
        expect(
          plugins,
          isNotEmpty,
          reason: 'marketplace.json declares no plugins',
        );

        final String pluginName = plugin['name'] as String;
        final Map<String, dynamic> entry = plugins
            .cast<Map<String, dynamic>>()
            .firstWhere(
              (Map<String, dynamic> p) => p['name'] == pluginName,
              orElse: () => throw StateError(
                'marketplace.json has no plugin entry named "$pluginName" '
                '(from plugin.json) — `/plugin install $pluginName` would '
                'fail to resolve',
              ),
            );

        final String source = entry['source'] as String;
        expect(source, isNotEmpty, reason: 'plugin source must not be empty');

        final Directory sourceDir = Directory('${_repoRoot.path}/$source');
        expect(
          sourceDir.existsSync(),
          isTrue,
          reason:
              'declared plugin source "$source" does not resolve to a '
              'directory in this repository',
        );

        final File canonicalSkillFile = _canonicalSkillFile();
        final String expectedRelative = _normalizeRelativePath(
          '$source/skills/$_skillName/SKILL.md',
        );
        final String canonicalRelative = _normalizeRelativePath(
          canonicalSkillFile.path
              .replaceAll(r'\', '/')
              .replaceFirst('${_repoRoot.path.replaceAll(r'\', '/')}/', ''),
        );
        expect(
          expectedRelative,
          equals(canonicalRelative),
          reason:
              '<source>/skills/$_skillName/SKILL.md should resolve to '
              'the same file Test 1 found ($canonicalRelative), got '
              '$expectedRelative — `/plugin install` would load a '
              'different file than the one this repository treats as '
              'authoritative',
        );

        final File resolvedSkillFile = File(
          '${_repoRoot.path}/$expectedRelative',
        );
        expect(
          resolvedSkillFile.existsSync(),
          isTrue,
          reason:
              '<source>/skills/$_skillName/SKILL.md does not exist — '
              '`/plugin install` would break',
        );
        expect(
          resolvedSkillFile.readAsStringSync(),
          canonicalSkillFile.readAsStringSync(),
          reason:
              'the plugin-resolved SKILL.md and the canonical SKILL.md '
              'have diverging content, which should be impossible for the '
              'same file — check for encoding differences',
        );

        // plugin.json's own `skills` payload list should point at the same
        // directory, independent of how the marketplace resolved `source`.
        if (plugin.containsKey('skills')) {
          final List<String> declaredSkills =
              (plugin['skills'] as List<dynamic>).cast<String>();
          final bool pointsAtCanonical = declaredSkills.any(
            (String s) =>
                _normalizeRelativePath(s) ==
                _normalizeRelativePath('skills/$_skillName'),
          );
          expect(
            pointsAtCanonical,
            isTrue,
            reason:
                'plugin.json `skills` list $declaredSkills does not '
                'include skills/$_skillName',
          );
        }

        final Object? version = plugin['version'];
        expect(
          version,
          isA<String>(),
          reason: 'plugin.json must set `version`',
        );
        final String versionString = version as String;
        expect(
          versionString,
          isNotEmpty,
          reason: 'plugin.json `version` must not be empty',
        );
        expect(
          RegExp(
            r'^\d+\.\d+\.\d+(-[0-9A-Za-z.-]+)?(\+[0-9A-Za-z.-]+)?$',
          ).hasMatch(versionString),
          isTrue,
          reason:
              'plugin.json `version` "$versionString" is not '
              'semver-shaped (MAJOR.MINOR.PATCH)',
        );
      },
    );
  });
}
